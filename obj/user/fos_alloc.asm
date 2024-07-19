
obj/user/fos_alloc:     file format elf32-i386


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
  800031:	e8 02 01 00 00       	call   800138 <libmain>
1:      jmp 1b
  800036:	eb fe                	jmp    800036 <args_exist+0x5>

00800038 <_main>:
#include <inc/lib.h>


void _main(void)
{	
  800038:	55                   	push   %ebp
  800039:	89 e5                	mov    %esp,%ebp
  80003b:	83 ec 18             	sub    $0x18,%esp
	//uint32 size = 2*1024*1024 +120*4096+1;
	//uint32 size = 1*1024*1024 + 256*1024;
	//uint32 size = 1*1024*1024;
	uint32 size = 100;
  80003e:	c7 45 f0 64 00 00 00 	movl   $0x64,-0x10(%ebp)

	unsigned char *x = malloc(sizeof(unsigned char)*size) ;
  800045:	83 ec 0c             	sub    $0xc,%esp
  800048:	ff 75 f0             	pushl  -0x10(%ebp)
  80004b:	e8 8a 12 00 00       	call   8012da <malloc>
  800050:	83 c4 10             	add    $0x10,%esp
  800053:	89 45 ec             	mov    %eax,-0x14(%ebp)
	atomic_cprintf("x allocated at %x\n",x);
  800056:	83 ec 08             	sub    $0x8,%esp
  800059:	ff 75 ec             	pushl  -0x14(%ebp)
  80005c:	68 c0 30 80 00       	push   $0x8030c0
  800061:	e8 0f 03 00 00       	call   800375 <atomic_cprintf>
  800066:	83 c4 10             	add    $0x10,%esp

	//unsigned char *z = malloc(sizeof(unsigned char)*size) ;
	//cprintf("z allocated at %x\n",z);
	
	int i ;
	for (i = 0 ; i < size ; i++)
  800069:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  800070:	eb 20                	jmp    800092 <_main+0x5a>
	{
		x[i] = i%256 ;
  800072:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800075:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800078:	01 c2                	add    %eax,%edx
  80007a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80007d:	25 ff 00 00 80       	and    $0x800000ff,%eax
  800082:	85 c0                	test   %eax,%eax
  800084:	79 07                	jns    80008d <_main+0x55>
  800086:	48                   	dec    %eax
  800087:	0d 00 ff ff ff       	or     $0xffffff00,%eax
  80008c:	40                   	inc    %eax
  80008d:	88 02                	mov    %al,(%edx)

	//unsigned char *z = malloc(sizeof(unsigned char)*size) ;
	//cprintf("z allocated at %x\n",z);
	
	int i ;
	for (i = 0 ; i < size ; i++)
  80008f:	ff 45 f4             	incl   -0xc(%ebp)
  800092:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800095:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800098:	72 d8                	jb     800072 <_main+0x3a>
		////z[i] = (int)(x[i]  * y[i]);
		////z[i] = i%256;
	}

	
	for (i = size-7 ; i < size ; i++)
  80009a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80009d:	83 e8 07             	sub    $0x7,%eax
  8000a0:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8000a3:	eb 24                	jmp    8000c9 <_main+0x91>
		atomic_cprintf("x[%d] = %d\n",i, x[i]);
  8000a5:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8000a8:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8000ab:	01 d0                	add    %edx,%eax
  8000ad:	8a 00                	mov    (%eax),%al
  8000af:	0f b6 c0             	movzbl %al,%eax
  8000b2:	83 ec 04             	sub    $0x4,%esp
  8000b5:	50                   	push   %eax
  8000b6:	ff 75 f4             	pushl  -0xc(%ebp)
  8000b9:	68 d3 30 80 00       	push   $0x8030d3
  8000be:	e8 b2 02 00 00       	call   800375 <atomic_cprintf>
  8000c3:	83 c4 10             	add    $0x10,%esp
		////z[i] = (int)(x[i]  * y[i]);
		////z[i] = i%256;
	}

	
	for (i = size-7 ; i < size ; i++)
  8000c6:	ff 45 f4             	incl   -0xc(%ebp)
  8000c9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8000cc:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8000cf:	72 d4                	jb     8000a5 <_main+0x6d>
		atomic_cprintf("x[%d] = %d\n",i, x[i]);
	
	free(x);
  8000d1:	83 ec 0c             	sub    $0xc,%esp
  8000d4:	ff 75 ec             	pushl  -0x14(%ebp)
  8000d7:	e8 7f 12 00 00       	call   80135b <free>
  8000dc:	83 c4 10             	add    $0x10,%esp

	x = malloc(sizeof(unsigned char)*size) ;
  8000df:	83 ec 0c             	sub    $0xc,%esp
  8000e2:	ff 75 f0             	pushl  -0x10(%ebp)
  8000e5:	e8 f0 11 00 00       	call   8012da <malloc>
  8000ea:	83 c4 10             	add    $0x10,%esp
  8000ed:	89 45 ec             	mov    %eax,-0x14(%ebp)
	
	for (i = size-7 ; i < size ; i++)
  8000f0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8000f3:	83 e8 07             	sub    $0x7,%eax
  8000f6:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8000f9:	eb 24                	jmp    80011f <_main+0xe7>
	{
		atomic_cprintf("x[%d] = %d\n",i,x[i]);
  8000fb:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8000fe:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800101:	01 d0                	add    %edx,%eax
  800103:	8a 00                	mov    (%eax),%al
  800105:	0f b6 c0             	movzbl %al,%eax
  800108:	83 ec 04             	sub    $0x4,%esp
  80010b:	50                   	push   %eax
  80010c:	ff 75 f4             	pushl  -0xc(%ebp)
  80010f:	68 d3 30 80 00       	push   $0x8030d3
  800114:	e8 5c 02 00 00       	call   800375 <atomic_cprintf>
  800119:	83 c4 10             	add    $0x10,%esp
	
	free(x);

	x = malloc(sizeof(unsigned char)*size) ;
	
	for (i = size-7 ; i < size ; i++)
  80011c:	ff 45 f4             	incl   -0xc(%ebp)
  80011f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800122:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800125:	72 d4                	jb     8000fb <_main+0xc3>
	{
		atomic_cprintf("x[%d] = %d\n",i,x[i]);
	}

	free(x);
  800127:	83 ec 0c             	sub    $0xc,%esp
  80012a:	ff 75 ec             	pushl  -0x14(%ebp)
  80012d:	e8 29 12 00 00       	call   80135b <free>
  800132:	83 c4 10             	add    $0x10,%esp
	
	return;	
  800135:	90                   	nop
}
  800136:	c9                   	leave  
  800137:	c3                   	ret    

00800138 <libmain>:
volatile struct Env *myEnv = NULL;
volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";

void
libmain(int argc, char **argv)
{
  800138:	55                   	push   %ebp
  800139:	89 e5                	mov    %esp,%ebp
  80013b:	83 ec 18             	sub    $0x18,%esp
	int envIndex = sys_getenvindex();
  80013e:	e8 83 18 00 00       	call   8019c6 <sys_getenvindex>
  800143:	89 45 f4             	mov    %eax,-0xc(%ebp)
	myEnv = &(envs[envIndex]);
  800146:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800149:	89 d0                	mov    %edx,%eax
  80014b:	c1 e0 03             	shl    $0x3,%eax
  80014e:	01 d0                	add    %edx,%eax
  800150:	01 c0                	add    %eax,%eax
  800152:	01 d0                	add    %edx,%eax
  800154:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80015b:	01 d0                	add    %edx,%eax
  80015d:	c1 e0 04             	shl    $0x4,%eax
  800160:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  800165:	a3 20 40 80 00       	mov    %eax,0x804020

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  80016a:	a1 20 40 80 00       	mov    0x804020,%eax
  80016f:	8a 80 5c 05 00 00    	mov    0x55c(%eax),%al
  800175:	84 c0                	test   %al,%al
  800177:	74 0f                	je     800188 <libmain+0x50>
		binaryname = myEnv->prog_name;
  800179:	a1 20 40 80 00       	mov    0x804020,%eax
  80017e:	05 5c 05 00 00       	add    $0x55c,%eax
  800183:	a3 00 40 80 00       	mov    %eax,0x804000

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800188:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80018c:	7e 0a                	jle    800198 <libmain+0x60>
		binaryname = argv[0];
  80018e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800191:	8b 00                	mov    (%eax),%eax
  800193:	a3 00 40 80 00       	mov    %eax,0x804000

	// call user main routine
	_main(argc, argv);
  800198:	83 ec 08             	sub    $0x8,%esp
  80019b:	ff 75 0c             	pushl  0xc(%ebp)
  80019e:	ff 75 08             	pushl  0x8(%ebp)
  8001a1:	e8 92 fe ff ff       	call   800038 <_main>
  8001a6:	83 c4 10             	add    $0x10,%esp



	sys_disable_interrupt();
  8001a9:	e8 25 16 00 00       	call   8017d3 <sys_disable_interrupt>
	cprintf("**************************************\n");
  8001ae:	83 ec 0c             	sub    $0xc,%esp
  8001b1:	68 f8 30 80 00       	push   $0x8030f8
  8001b6:	e8 8d 01 00 00       	call   800348 <cprintf>
  8001bb:	83 c4 10             	add    $0x10,%esp
	cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  8001be:	a1 20 40 80 00       	mov    0x804020,%eax
  8001c3:	8b 90 44 05 00 00    	mov    0x544(%eax),%edx
  8001c9:	a1 20 40 80 00       	mov    0x804020,%eax
  8001ce:	8b 80 34 05 00 00    	mov    0x534(%eax),%eax
  8001d4:	83 ec 04             	sub    $0x4,%esp
  8001d7:	52                   	push   %edx
  8001d8:	50                   	push   %eax
  8001d9:	68 20 31 80 00       	push   $0x803120
  8001de:	e8 65 01 00 00       	call   800348 <cprintf>
  8001e3:	83 c4 10             	add    $0x10,%esp
	cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  8001e6:	a1 20 40 80 00       	mov    0x804020,%eax
  8001eb:	8b 88 54 05 00 00    	mov    0x554(%eax),%ecx
  8001f1:	a1 20 40 80 00       	mov    0x804020,%eax
  8001f6:	8b 90 50 05 00 00    	mov    0x550(%eax),%edx
  8001fc:	a1 20 40 80 00       	mov    0x804020,%eax
  800201:	8b 80 4c 05 00 00    	mov    0x54c(%eax),%eax
  800207:	51                   	push   %ecx
  800208:	52                   	push   %edx
  800209:	50                   	push   %eax
  80020a:	68 48 31 80 00       	push   $0x803148
  80020f:	e8 34 01 00 00       	call   800348 <cprintf>
  800214:	83 c4 10             	add    $0x10,%esp
	//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
	cprintf("Num of clocks = %d\n", myEnv->nClocks);
  800217:	a1 20 40 80 00       	mov    0x804020,%eax
  80021c:	8b 80 a4 05 00 00    	mov    0x5a4(%eax),%eax
  800222:	83 ec 08             	sub    $0x8,%esp
  800225:	50                   	push   %eax
  800226:	68 a0 31 80 00       	push   $0x8031a0
  80022b:	e8 18 01 00 00       	call   800348 <cprintf>
  800230:	83 c4 10             	add    $0x10,%esp
	cprintf("**************************************\n");
  800233:	83 ec 0c             	sub    $0xc,%esp
  800236:	68 f8 30 80 00       	push   $0x8030f8
  80023b:	e8 08 01 00 00       	call   800348 <cprintf>
  800240:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  800243:	e8 a5 15 00 00       	call   8017ed <sys_enable_interrupt>

	// exit gracefully
	exit();
  800248:	e8 19 00 00 00       	call   800266 <exit>
}
  80024d:	90                   	nop
  80024e:	c9                   	leave  
  80024f:	c3                   	ret    

00800250 <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  800250:	55                   	push   %ebp
  800251:	89 e5                	mov    %esp,%ebp
  800253:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  800256:	83 ec 0c             	sub    $0xc,%esp
  800259:	6a 00                	push   $0x0
  80025b:	e8 32 17 00 00       	call   801992 <sys_destroy_env>
  800260:	83 c4 10             	add    $0x10,%esp
}
  800263:	90                   	nop
  800264:	c9                   	leave  
  800265:	c3                   	ret    

00800266 <exit>:

void
exit(void)
{
  800266:	55                   	push   %ebp
  800267:	89 e5                	mov    %esp,%ebp
  800269:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  80026c:	e8 87 17 00 00       	call   8019f8 <sys_exit_env>
}
  800271:	90                   	nop
  800272:	c9                   	leave  
  800273:	c3                   	ret    

00800274 <putch>:
};

//2017:
uint8 printProgName = 0;

static void putch(int ch, struct printbuf *b) {
  800274:	55                   	push   %ebp
  800275:	89 e5                	mov    %esp,%ebp
  800277:	83 ec 08             	sub    $0x8,%esp
	b->buf[b->idx++] = ch;
  80027a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80027d:	8b 00                	mov    (%eax),%eax
  80027f:	8d 48 01             	lea    0x1(%eax),%ecx
  800282:	8b 55 0c             	mov    0xc(%ebp),%edx
  800285:	89 0a                	mov    %ecx,(%edx)
  800287:	8b 55 08             	mov    0x8(%ebp),%edx
  80028a:	88 d1                	mov    %dl,%cl
  80028c:	8b 55 0c             	mov    0xc(%ebp),%edx
  80028f:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  800293:	8b 45 0c             	mov    0xc(%ebp),%eax
  800296:	8b 00                	mov    (%eax),%eax
  800298:	3d ff 00 00 00       	cmp    $0xff,%eax
  80029d:	75 2c                	jne    8002cb <putch+0x57>
		sys_cputs(b->buf, b->idx, printProgName);
  80029f:	a0 24 40 80 00       	mov    0x804024,%al
  8002a4:	0f b6 c0             	movzbl %al,%eax
  8002a7:	8b 55 0c             	mov    0xc(%ebp),%edx
  8002aa:	8b 12                	mov    (%edx),%edx
  8002ac:	89 d1                	mov    %edx,%ecx
  8002ae:	8b 55 0c             	mov    0xc(%ebp),%edx
  8002b1:	83 c2 08             	add    $0x8,%edx
  8002b4:	83 ec 04             	sub    $0x4,%esp
  8002b7:	50                   	push   %eax
  8002b8:	51                   	push   %ecx
  8002b9:	52                   	push   %edx
  8002ba:	e8 66 13 00 00       	call   801625 <sys_cputs>
  8002bf:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  8002c2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8002c5:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  8002cb:	8b 45 0c             	mov    0xc(%ebp),%eax
  8002ce:	8b 40 04             	mov    0x4(%eax),%eax
  8002d1:	8d 50 01             	lea    0x1(%eax),%edx
  8002d4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8002d7:	89 50 04             	mov    %edx,0x4(%eax)
}
  8002da:	90                   	nop
  8002db:	c9                   	leave  
  8002dc:	c3                   	ret    

008002dd <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  8002dd:	55                   	push   %ebp
  8002de:	89 e5                	mov    %esp,%ebp
  8002e0:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  8002e6:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  8002ed:	00 00 00 
	b.cnt = 0;
  8002f0:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  8002f7:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  8002fa:	ff 75 0c             	pushl  0xc(%ebp)
  8002fd:	ff 75 08             	pushl  0x8(%ebp)
  800300:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800306:	50                   	push   %eax
  800307:	68 74 02 80 00       	push   $0x800274
  80030c:	e8 11 02 00 00       	call   800522 <vprintfmt>
  800311:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName);
  800314:	a0 24 40 80 00       	mov    0x804024,%al
  800319:	0f b6 c0             	movzbl %al,%eax
  80031c:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  800322:	83 ec 04             	sub    $0x4,%esp
  800325:	50                   	push   %eax
  800326:	52                   	push   %edx
  800327:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  80032d:	83 c0 08             	add    $0x8,%eax
  800330:	50                   	push   %eax
  800331:	e8 ef 12 00 00       	call   801625 <sys_cputs>
  800336:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  800339:	c6 05 24 40 80 00 00 	movb   $0x0,0x804024
	return b.cnt;
  800340:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  800346:	c9                   	leave  
  800347:	c3                   	ret    

00800348 <cprintf>:

int cprintf(const char *fmt, ...) {
  800348:	55                   	push   %ebp
  800349:	89 e5                	mov    %esp,%ebp
  80034b:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  80034e:	c6 05 24 40 80 00 01 	movb   $0x1,0x804024
	va_start(ap, fmt);
  800355:	8d 45 0c             	lea    0xc(%ebp),%eax
  800358:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  80035b:	8b 45 08             	mov    0x8(%ebp),%eax
  80035e:	83 ec 08             	sub    $0x8,%esp
  800361:	ff 75 f4             	pushl  -0xc(%ebp)
  800364:	50                   	push   %eax
  800365:	e8 73 ff ff ff       	call   8002dd <vcprintf>
  80036a:	83 c4 10             	add    $0x10,%esp
  80036d:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  800370:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800373:	c9                   	leave  
  800374:	c3                   	ret    

00800375 <atomic_cprintf>:

int atomic_cprintf(const char *fmt, ...) {
  800375:	55                   	push   %ebp
  800376:	89 e5                	mov    %esp,%ebp
  800378:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  80037b:	e8 53 14 00 00       	call   8017d3 <sys_disable_interrupt>
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  800380:	8d 45 0c             	lea    0xc(%ebp),%eax
  800383:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800386:	8b 45 08             	mov    0x8(%ebp),%eax
  800389:	83 ec 08             	sub    $0x8,%esp
  80038c:	ff 75 f4             	pushl  -0xc(%ebp)
  80038f:	50                   	push   %eax
  800390:	e8 48 ff ff ff       	call   8002dd <vcprintf>
  800395:	83 c4 10             	add    $0x10,%esp
  800398:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	sys_enable_interrupt();
  80039b:	e8 4d 14 00 00       	call   8017ed <sys_enable_interrupt>
	return cnt;
  8003a0:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8003a3:	c9                   	leave  
  8003a4:	c3                   	ret    

008003a5 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8003a5:	55                   	push   %ebp
  8003a6:	89 e5                	mov    %esp,%ebp
  8003a8:	53                   	push   %ebx
  8003a9:	83 ec 14             	sub    $0x14,%esp
  8003ac:	8b 45 10             	mov    0x10(%ebp),%eax
  8003af:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8003b2:	8b 45 14             	mov    0x14(%ebp),%eax
  8003b5:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  8003b8:	8b 45 18             	mov    0x18(%ebp),%eax
  8003bb:	ba 00 00 00 00       	mov    $0x0,%edx
  8003c0:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  8003c3:	77 55                	ja     80041a <printnum+0x75>
  8003c5:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  8003c8:	72 05                	jb     8003cf <printnum+0x2a>
  8003ca:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8003cd:	77 4b                	ja     80041a <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  8003cf:	8b 45 1c             	mov    0x1c(%ebp),%eax
  8003d2:	8d 58 ff             	lea    -0x1(%eax),%ebx
  8003d5:	8b 45 18             	mov    0x18(%ebp),%eax
  8003d8:	ba 00 00 00 00       	mov    $0x0,%edx
  8003dd:	52                   	push   %edx
  8003de:	50                   	push   %eax
  8003df:	ff 75 f4             	pushl  -0xc(%ebp)
  8003e2:	ff 75 f0             	pushl  -0x10(%ebp)
  8003e5:	e8 66 2a 00 00       	call   802e50 <__udivdi3>
  8003ea:	83 c4 10             	add    $0x10,%esp
  8003ed:	83 ec 04             	sub    $0x4,%esp
  8003f0:	ff 75 20             	pushl  0x20(%ebp)
  8003f3:	53                   	push   %ebx
  8003f4:	ff 75 18             	pushl  0x18(%ebp)
  8003f7:	52                   	push   %edx
  8003f8:	50                   	push   %eax
  8003f9:	ff 75 0c             	pushl  0xc(%ebp)
  8003fc:	ff 75 08             	pushl  0x8(%ebp)
  8003ff:	e8 a1 ff ff ff       	call   8003a5 <printnum>
  800404:	83 c4 20             	add    $0x20,%esp
  800407:	eb 1a                	jmp    800423 <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800409:	83 ec 08             	sub    $0x8,%esp
  80040c:	ff 75 0c             	pushl  0xc(%ebp)
  80040f:	ff 75 20             	pushl  0x20(%ebp)
  800412:	8b 45 08             	mov    0x8(%ebp),%eax
  800415:	ff d0                	call   *%eax
  800417:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  80041a:	ff 4d 1c             	decl   0x1c(%ebp)
  80041d:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  800421:	7f e6                	jg     800409 <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800423:	8b 4d 18             	mov    0x18(%ebp),%ecx
  800426:	bb 00 00 00 00       	mov    $0x0,%ebx
  80042b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80042e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800431:	53                   	push   %ebx
  800432:	51                   	push   %ecx
  800433:	52                   	push   %edx
  800434:	50                   	push   %eax
  800435:	e8 26 2b 00 00       	call   802f60 <__umoddi3>
  80043a:	83 c4 10             	add    $0x10,%esp
  80043d:	05 d4 33 80 00       	add    $0x8033d4,%eax
  800442:	8a 00                	mov    (%eax),%al
  800444:	0f be c0             	movsbl %al,%eax
  800447:	83 ec 08             	sub    $0x8,%esp
  80044a:	ff 75 0c             	pushl  0xc(%ebp)
  80044d:	50                   	push   %eax
  80044e:	8b 45 08             	mov    0x8(%ebp),%eax
  800451:	ff d0                	call   *%eax
  800453:	83 c4 10             	add    $0x10,%esp
}
  800456:	90                   	nop
  800457:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80045a:	c9                   	leave  
  80045b:	c3                   	ret    

0080045c <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  80045c:	55                   	push   %ebp
  80045d:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  80045f:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800463:	7e 1c                	jle    800481 <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  800465:	8b 45 08             	mov    0x8(%ebp),%eax
  800468:	8b 00                	mov    (%eax),%eax
  80046a:	8d 50 08             	lea    0x8(%eax),%edx
  80046d:	8b 45 08             	mov    0x8(%ebp),%eax
  800470:	89 10                	mov    %edx,(%eax)
  800472:	8b 45 08             	mov    0x8(%ebp),%eax
  800475:	8b 00                	mov    (%eax),%eax
  800477:	83 e8 08             	sub    $0x8,%eax
  80047a:	8b 50 04             	mov    0x4(%eax),%edx
  80047d:	8b 00                	mov    (%eax),%eax
  80047f:	eb 40                	jmp    8004c1 <getuint+0x65>
	else if (lflag)
  800481:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800485:	74 1e                	je     8004a5 <getuint+0x49>
		return va_arg(*ap, unsigned long);
  800487:	8b 45 08             	mov    0x8(%ebp),%eax
  80048a:	8b 00                	mov    (%eax),%eax
  80048c:	8d 50 04             	lea    0x4(%eax),%edx
  80048f:	8b 45 08             	mov    0x8(%ebp),%eax
  800492:	89 10                	mov    %edx,(%eax)
  800494:	8b 45 08             	mov    0x8(%ebp),%eax
  800497:	8b 00                	mov    (%eax),%eax
  800499:	83 e8 04             	sub    $0x4,%eax
  80049c:	8b 00                	mov    (%eax),%eax
  80049e:	ba 00 00 00 00       	mov    $0x0,%edx
  8004a3:	eb 1c                	jmp    8004c1 <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  8004a5:	8b 45 08             	mov    0x8(%ebp),%eax
  8004a8:	8b 00                	mov    (%eax),%eax
  8004aa:	8d 50 04             	lea    0x4(%eax),%edx
  8004ad:	8b 45 08             	mov    0x8(%ebp),%eax
  8004b0:	89 10                	mov    %edx,(%eax)
  8004b2:	8b 45 08             	mov    0x8(%ebp),%eax
  8004b5:	8b 00                	mov    (%eax),%eax
  8004b7:	83 e8 04             	sub    $0x4,%eax
  8004ba:	8b 00                	mov    (%eax),%eax
  8004bc:	ba 00 00 00 00       	mov    $0x0,%edx
}
  8004c1:	5d                   	pop    %ebp
  8004c2:	c3                   	ret    

008004c3 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  8004c3:	55                   	push   %ebp
  8004c4:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  8004c6:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  8004ca:	7e 1c                	jle    8004e8 <getint+0x25>
		return va_arg(*ap, long long);
  8004cc:	8b 45 08             	mov    0x8(%ebp),%eax
  8004cf:	8b 00                	mov    (%eax),%eax
  8004d1:	8d 50 08             	lea    0x8(%eax),%edx
  8004d4:	8b 45 08             	mov    0x8(%ebp),%eax
  8004d7:	89 10                	mov    %edx,(%eax)
  8004d9:	8b 45 08             	mov    0x8(%ebp),%eax
  8004dc:	8b 00                	mov    (%eax),%eax
  8004de:	83 e8 08             	sub    $0x8,%eax
  8004e1:	8b 50 04             	mov    0x4(%eax),%edx
  8004e4:	8b 00                	mov    (%eax),%eax
  8004e6:	eb 38                	jmp    800520 <getint+0x5d>
	else if (lflag)
  8004e8:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8004ec:	74 1a                	je     800508 <getint+0x45>
		return va_arg(*ap, long);
  8004ee:	8b 45 08             	mov    0x8(%ebp),%eax
  8004f1:	8b 00                	mov    (%eax),%eax
  8004f3:	8d 50 04             	lea    0x4(%eax),%edx
  8004f6:	8b 45 08             	mov    0x8(%ebp),%eax
  8004f9:	89 10                	mov    %edx,(%eax)
  8004fb:	8b 45 08             	mov    0x8(%ebp),%eax
  8004fe:	8b 00                	mov    (%eax),%eax
  800500:	83 e8 04             	sub    $0x4,%eax
  800503:	8b 00                	mov    (%eax),%eax
  800505:	99                   	cltd   
  800506:	eb 18                	jmp    800520 <getint+0x5d>
	else
		return va_arg(*ap, int);
  800508:	8b 45 08             	mov    0x8(%ebp),%eax
  80050b:	8b 00                	mov    (%eax),%eax
  80050d:	8d 50 04             	lea    0x4(%eax),%edx
  800510:	8b 45 08             	mov    0x8(%ebp),%eax
  800513:	89 10                	mov    %edx,(%eax)
  800515:	8b 45 08             	mov    0x8(%ebp),%eax
  800518:	8b 00                	mov    (%eax),%eax
  80051a:	83 e8 04             	sub    $0x4,%eax
  80051d:	8b 00                	mov    (%eax),%eax
  80051f:	99                   	cltd   
}
  800520:	5d                   	pop    %ebp
  800521:	c3                   	ret    

00800522 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  800522:	55                   	push   %ebp
  800523:	89 e5                	mov    %esp,%ebp
  800525:	56                   	push   %esi
  800526:	53                   	push   %ebx
  800527:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  80052a:	eb 17                	jmp    800543 <vprintfmt+0x21>
			if (ch == '\0')
  80052c:	85 db                	test   %ebx,%ebx
  80052e:	0f 84 af 03 00 00    	je     8008e3 <vprintfmt+0x3c1>
				return;
			putch(ch, putdat);
  800534:	83 ec 08             	sub    $0x8,%esp
  800537:	ff 75 0c             	pushl  0xc(%ebp)
  80053a:	53                   	push   %ebx
  80053b:	8b 45 08             	mov    0x8(%ebp),%eax
  80053e:	ff d0                	call   *%eax
  800540:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800543:	8b 45 10             	mov    0x10(%ebp),%eax
  800546:	8d 50 01             	lea    0x1(%eax),%edx
  800549:	89 55 10             	mov    %edx,0x10(%ebp)
  80054c:	8a 00                	mov    (%eax),%al
  80054e:	0f b6 d8             	movzbl %al,%ebx
  800551:	83 fb 25             	cmp    $0x25,%ebx
  800554:	75 d6                	jne    80052c <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  800556:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  80055a:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  800561:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  800568:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  80056f:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800576:	8b 45 10             	mov    0x10(%ebp),%eax
  800579:	8d 50 01             	lea    0x1(%eax),%edx
  80057c:	89 55 10             	mov    %edx,0x10(%ebp)
  80057f:	8a 00                	mov    (%eax),%al
  800581:	0f b6 d8             	movzbl %al,%ebx
  800584:	8d 43 dd             	lea    -0x23(%ebx),%eax
  800587:	83 f8 55             	cmp    $0x55,%eax
  80058a:	0f 87 2b 03 00 00    	ja     8008bb <vprintfmt+0x399>
  800590:	8b 04 85 f8 33 80 00 	mov    0x8033f8(,%eax,4),%eax
  800597:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  800599:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  80059d:	eb d7                	jmp    800576 <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  80059f:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  8005a3:	eb d1                	jmp    800576 <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8005a5:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  8005ac:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8005af:	89 d0                	mov    %edx,%eax
  8005b1:	c1 e0 02             	shl    $0x2,%eax
  8005b4:	01 d0                	add    %edx,%eax
  8005b6:	01 c0                	add    %eax,%eax
  8005b8:	01 d8                	add    %ebx,%eax
  8005ba:	83 e8 30             	sub    $0x30,%eax
  8005bd:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  8005c0:	8b 45 10             	mov    0x10(%ebp),%eax
  8005c3:	8a 00                	mov    (%eax),%al
  8005c5:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  8005c8:	83 fb 2f             	cmp    $0x2f,%ebx
  8005cb:	7e 3e                	jle    80060b <vprintfmt+0xe9>
  8005cd:	83 fb 39             	cmp    $0x39,%ebx
  8005d0:	7f 39                	jg     80060b <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8005d2:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  8005d5:	eb d5                	jmp    8005ac <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  8005d7:	8b 45 14             	mov    0x14(%ebp),%eax
  8005da:	83 c0 04             	add    $0x4,%eax
  8005dd:	89 45 14             	mov    %eax,0x14(%ebp)
  8005e0:	8b 45 14             	mov    0x14(%ebp),%eax
  8005e3:	83 e8 04             	sub    $0x4,%eax
  8005e6:	8b 00                	mov    (%eax),%eax
  8005e8:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  8005eb:	eb 1f                	jmp    80060c <vprintfmt+0xea>

		case '.':
			if (width < 0)
  8005ed:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8005f1:	79 83                	jns    800576 <vprintfmt+0x54>
				width = 0;
  8005f3:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  8005fa:	e9 77 ff ff ff       	jmp    800576 <vprintfmt+0x54>

		case '#':
			altflag = 1;
  8005ff:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  800606:	e9 6b ff ff ff       	jmp    800576 <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  80060b:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  80060c:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800610:	0f 89 60 ff ff ff    	jns    800576 <vprintfmt+0x54>
				width = precision, precision = -1;
  800616:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800619:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  80061c:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  800623:	e9 4e ff ff ff       	jmp    800576 <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  800628:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  80062b:	e9 46 ff ff ff       	jmp    800576 <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  800630:	8b 45 14             	mov    0x14(%ebp),%eax
  800633:	83 c0 04             	add    $0x4,%eax
  800636:	89 45 14             	mov    %eax,0x14(%ebp)
  800639:	8b 45 14             	mov    0x14(%ebp),%eax
  80063c:	83 e8 04             	sub    $0x4,%eax
  80063f:	8b 00                	mov    (%eax),%eax
  800641:	83 ec 08             	sub    $0x8,%esp
  800644:	ff 75 0c             	pushl  0xc(%ebp)
  800647:	50                   	push   %eax
  800648:	8b 45 08             	mov    0x8(%ebp),%eax
  80064b:	ff d0                	call   *%eax
  80064d:	83 c4 10             	add    $0x10,%esp
			break;
  800650:	e9 89 02 00 00       	jmp    8008de <vprintfmt+0x3bc>

		// error message
		case 'e':
			err = va_arg(ap, int);
  800655:	8b 45 14             	mov    0x14(%ebp),%eax
  800658:	83 c0 04             	add    $0x4,%eax
  80065b:	89 45 14             	mov    %eax,0x14(%ebp)
  80065e:	8b 45 14             	mov    0x14(%ebp),%eax
  800661:	83 e8 04             	sub    $0x4,%eax
  800664:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  800666:	85 db                	test   %ebx,%ebx
  800668:	79 02                	jns    80066c <vprintfmt+0x14a>
				err = -err;
  80066a:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  80066c:	83 fb 64             	cmp    $0x64,%ebx
  80066f:	7f 0b                	jg     80067c <vprintfmt+0x15a>
  800671:	8b 34 9d 40 32 80 00 	mov    0x803240(,%ebx,4),%esi
  800678:	85 f6                	test   %esi,%esi
  80067a:	75 19                	jne    800695 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  80067c:	53                   	push   %ebx
  80067d:	68 e5 33 80 00       	push   $0x8033e5
  800682:	ff 75 0c             	pushl  0xc(%ebp)
  800685:	ff 75 08             	pushl  0x8(%ebp)
  800688:	e8 5e 02 00 00       	call   8008eb <printfmt>
  80068d:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800690:	e9 49 02 00 00       	jmp    8008de <vprintfmt+0x3bc>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800695:	56                   	push   %esi
  800696:	68 ee 33 80 00       	push   $0x8033ee
  80069b:	ff 75 0c             	pushl  0xc(%ebp)
  80069e:	ff 75 08             	pushl  0x8(%ebp)
  8006a1:	e8 45 02 00 00       	call   8008eb <printfmt>
  8006a6:	83 c4 10             	add    $0x10,%esp
			break;
  8006a9:	e9 30 02 00 00       	jmp    8008de <vprintfmt+0x3bc>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  8006ae:	8b 45 14             	mov    0x14(%ebp),%eax
  8006b1:	83 c0 04             	add    $0x4,%eax
  8006b4:	89 45 14             	mov    %eax,0x14(%ebp)
  8006b7:	8b 45 14             	mov    0x14(%ebp),%eax
  8006ba:	83 e8 04             	sub    $0x4,%eax
  8006bd:	8b 30                	mov    (%eax),%esi
  8006bf:	85 f6                	test   %esi,%esi
  8006c1:	75 05                	jne    8006c8 <vprintfmt+0x1a6>
				p = "(null)";
  8006c3:	be f1 33 80 00       	mov    $0x8033f1,%esi
			if (width > 0 && padc != '-')
  8006c8:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8006cc:	7e 6d                	jle    80073b <vprintfmt+0x219>
  8006ce:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  8006d2:	74 67                	je     80073b <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  8006d4:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8006d7:	83 ec 08             	sub    $0x8,%esp
  8006da:	50                   	push   %eax
  8006db:	56                   	push   %esi
  8006dc:	e8 0c 03 00 00       	call   8009ed <strnlen>
  8006e1:	83 c4 10             	add    $0x10,%esp
  8006e4:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  8006e7:	eb 16                	jmp    8006ff <vprintfmt+0x1dd>
					putch(padc, putdat);
  8006e9:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  8006ed:	83 ec 08             	sub    $0x8,%esp
  8006f0:	ff 75 0c             	pushl  0xc(%ebp)
  8006f3:	50                   	push   %eax
  8006f4:	8b 45 08             	mov    0x8(%ebp),%eax
  8006f7:	ff d0                	call   *%eax
  8006f9:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  8006fc:	ff 4d e4             	decl   -0x1c(%ebp)
  8006ff:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800703:	7f e4                	jg     8006e9 <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800705:	eb 34                	jmp    80073b <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  800707:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  80070b:	74 1c                	je     800729 <vprintfmt+0x207>
  80070d:	83 fb 1f             	cmp    $0x1f,%ebx
  800710:	7e 05                	jle    800717 <vprintfmt+0x1f5>
  800712:	83 fb 7e             	cmp    $0x7e,%ebx
  800715:	7e 12                	jle    800729 <vprintfmt+0x207>
					putch('?', putdat);
  800717:	83 ec 08             	sub    $0x8,%esp
  80071a:	ff 75 0c             	pushl  0xc(%ebp)
  80071d:	6a 3f                	push   $0x3f
  80071f:	8b 45 08             	mov    0x8(%ebp),%eax
  800722:	ff d0                	call   *%eax
  800724:	83 c4 10             	add    $0x10,%esp
  800727:	eb 0f                	jmp    800738 <vprintfmt+0x216>
				else
					putch(ch, putdat);
  800729:	83 ec 08             	sub    $0x8,%esp
  80072c:	ff 75 0c             	pushl  0xc(%ebp)
  80072f:	53                   	push   %ebx
  800730:	8b 45 08             	mov    0x8(%ebp),%eax
  800733:	ff d0                	call   *%eax
  800735:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800738:	ff 4d e4             	decl   -0x1c(%ebp)
  80073b:	89 f0                	mov    %esi,%eax
  80073d:	8d 70 01             	lea    0x1(%eax),%esi
  800740:	8a 00                	mov    (%eax),%al
  800742:	0f be d8             	movsbl %al,%ebx
  800745:	85 db                	test   %ebx,%ebx
  800747:	74 24                	je     80076d <vprintfmt+0x24b>
  800749:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80074d:	78 b8                	js     800707 <vprintfmt+0x1e5>
  80074f:	ff 4d e0             	decl   -0x20(%ebp)
  800752:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800756:	79 af                	jns    800707 <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800758:	eb 13                	jmp    80076d <vprintfmt+0x24b>
				putch(' ', putdat);
  80075a:	83 ec 08             	sub    $0x8,%esp
  80075d:	ff 75 0c             	pushl  0xc(%ebp)
  800760:	6a 20                	push   $0x20
  800762:	8b 45 08             	mov    0x8(%ebp),%eax
  800765:	ff d0                	call   *%eax
  800767:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  80076a:	ff 4d e4             	decl   -0x1c(%ebp)
  80076d:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800771:	7f e7                	jg     80075a <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  800773:	e9 66 01 00 00       	jmp    8008de <vprintfmt+0x3bc>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  800778:	83 ec 08             	sub    $0x8,%esp
  80077b:	ff 75 e8             	pushl  -0x18(%ebp)
  80077e:	8d 45 14             	lea    0x14(%ebp),%eax
  800781:	50                   	push   %eax
  800782:	e8 3c fd ff ff       	call   8004c3 <getint>
  800787:	83 c4 10             	add    $0x10,%esp
  80078a:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80078d:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  800790:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800793:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800796:	85 d2                	test   %edx,%edx
  800798:	79 23                	jns    8007bd <vprintfmt+0x29b>
				putch('-', putdat);
  80079a:	83 ec 08             	sub    $0x8,%esp
  80079d:	ff 75 0c             	pushl  0xc(%ebp)
  8007a0:	6a 2d                	push   $0x2d
  8007a2:	8b 45 08             	mov    0x8(%ebp),%eax
  8007a5:	ff d0                	call   *%eax
  8007a7:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  8007aa:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8007ad:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8007b0:	f7 d8                	neg    %eax
  8007b2:	83 d2 00             	adc    $0x0,%edx
  8007b5:	f7 da                	neg    %edx
  8007b7:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8007ba:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  8007bd:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  8007c4:	e9 bc 00 00 00       	jmp    800885 <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  8007c9:	83 ec 08             	sub    $0x8,%esp
  8007cc:	ff 75 e8             	pushl  -0x18(%ebp)
  8007cf:	8d 45 14             	lea    0x14(%ebp),%eax
  8007d2:	50                   	push   %eax
  8007d3:	e8 84 fc ff ff       	call   80045c <getuint>
  8007d8:	83 c4 10             	add    $0x10,%esp
  8007db:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8007de:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  8007e1:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  8007e8:	e9 98 00 00 00       	jmp    800885 <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  8007ed:	83 ec 08             	sub    $0x8,%esp
  8007f0:	ff 75 0c             	pushl  0xc(%ebp)
  8007f3:	6a 58                	push   $0x58
  8007f5:	8b 45 08             	mov    0x8(%ebp),%eax
  8007f8:	ff d0                	call   *%eax
  8007fa:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  8007fd:	83 ec 08             	sub    $0x8,%esp
  800800:	ff 75 0c             	pushl  0xc(%ebp)
  800803:	6a 58                	push   $0x58
  800805:	8b 45 08             	mov    0x8(%ebp),%eax
  800808:	ff d0                	call   *%eax
  80080a:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  80080d:	83 ec 08             	sub    $0x8,%esp
  800810:	ff 75 0c             	pushl  0xc(%ebp)
  800813:	6a 58                	push   $0x58
  800815:	8b 45 08             	mov    0x8(%ebp),%eax
  800818:	ff d0                	call   *%eax
  80081a:	83 c4 10             	add    $0x10,%esp
			break;
  80081d:	e9 bc 00 00 00       	jmp    8008de <vprintfmt+0x3bc>

		// pointer
		case 'p':
			putch('0', putdat);
  800822:	83 ec 08             	sub    $0x8,%esp
  800825:	ff 75 0c             	pushl  0xc(%ebp)
  800828:	6a 30                	push   $0x30
  80082a:	8b 45 08             	mov    0x8(%ebp),%eax
  80082d:	ff d0                	call   *%eax
  80082f:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  800832:	83 ec 08             	sub    $0x8,%esp
  800835:	ff 75 0c             	pushl  0xc(%ebp)
  800838:	6a 78                	push   $0x78
  80083a:	8b 45 08             	mov    0x8(%ebp),%eax
  80083d:	ff d0                	call   *%eax
  80083f:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  800842:	8b 45 14             	mov    0x14(%ebp),%eax
  800845:	83 c0 04             	add    $0x4,%eax
  800848:	89 45 14             	mov    %eax,0x14(%ebp)
  80084b:	8b 45 14             	mov    0x14(%ebp),%eax
  80084e:	83 e8 04             	sub    $0x4,%eax
  800851:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800853:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800856:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  80085d:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  800864:	eb 1f                	jmp    800885 <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800866:	83 ec 08             	sub    $0x8,%esp
  800869:	ff 75 e8             	pushl  -0x18(%ebp)
  80086c:	8d 45 14             	lea    0x14(%ebp),%eax
  80086f:	50                   	push   %eax
  800870:	e8 e7 fb ff ff       	call   80045c <getuint>
  800875:	83 c4 10             	add    $0x10,%esp
  800878:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80087b:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  80087e:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800885:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  800889:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80088c:	83 ec 04             	sub    $0x4,%esp
  80088f:	52                   	push   %edx
  800890:	ff 75 e4             	pushl  -0x1c(%ebp)
  800893:	50                   	push   %eax
  800894:	ff 75 f4             	pushl  -0xc(%ebp)
  800897:	ff 75 f0             	pushl  -0x10(%ebp)
  80089a:	ff 75 0c             	pushl  0xc(%ebp)
  80089d:	ff 75 08             	pushl  0x8(%ebp)
  8008a0:	e8 00 fb ff ff       	call   8003a5 <printnum>
  8008a5:	83 c4 20             	add    $0x20,%esp
			break;
  8008a8:	eb 34                	jmp    8008de <vprintfmt+0x3bc>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  8008aa:	83 ec 08             	sub    $0x8,%esp
  8008ad:	ff 75 0c             	pushl  0xc(%ebp)
  8008b0:	53                   	push   %ebx
  8008b1:	8b 45 08             	mov    0x8(%ebp),%eax
  8008b4:	ff d0                	call   *%eax
  8008b6:	83 c4 10             	add    $0x10,%esp
			break;
  8008b9:	eb 23                	jmp    8008de <vprintfmt+0x3bc>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  8008bb:	83 ec 08             	sub    $0x8,%esp
  8008be:	ff 75 0c             	pushl  0xc(%ebp)
  8008c1:	6a 25                	push   $0x25
  8008c3:	8b 45 08             	mov    0x8(%ebp),%eax
  8008c6:	ff d0                	call   *%eax
  8008c8:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  8008cb:	ff 4d 10             	decl   0x10(%ebp)
  8008ce:	eb 03                	jmp    8008d3 <vprintfmt+0x3b1>
  8008d0:	ff 4d 10             	decl   0x10(%ebp)
  8008d3:	8b 45 10             	mov    0x10(%ebp),%eax
  8008d6:	48                   	dec    %eax
  8008d7:	8a 00                	mov    (%eax),%al
  8008d9:	3c 25                	cmp    $0x25,%al
  8008db:	75 f3                	jne    8008d0 <vprintfmt+0x3ae>
				/* do nothing */;
			break;
  8008dd:	90                   	nop
		}
	}
  8008de:	e9 47 fc ff ff       	jmp    80052a <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  8008e3:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  8008e4:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8008e7:	5b                   	pop    %ebx
  8008e8:	5e                   	pop    %esi
  8008e9:	5d                   	pop    %ebp
  8008ea:	c3                   	ret    

008008eb <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  8008eb:	55                   	push   %ebp
  8008ec:	89 e5                	mov    %esp,%ebp
  8008ee:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  8008f1:	8d 45 10             	lea    0x10(%ebp),%eax
  8008f4:	83 c0 04             	add    $0x4,%eax
  8008f7:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  8008fa:	8b 45 10             	mov    0x10(%ebp),%eax
  8008fd:	ff 75 f4             	pushl  -0xc(%ebp)
  800900:	50                   	push   %eax
  800901:	ff 75 0c             	pushl  0xc(%ebp)
  800904:	ff 75 08             	pushl  0x8(%ebp)
  800907:	e8 16 fc ff ff       	call   800522 <vprintfmt>
  80090c:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  80090f:	90                   	nop
  800910:	c9                   	leave  
  800911:	c3                   	ret    

00800912 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800912:	55                   	push   %ebp
  800913:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  800915:	8b 45 0c             	mov    0xc(%ebp),%eax
  800918:	8b 40 08             	mov    0x8(%eax),%eax
  80091b:	8d 50 01             	lea    0x1(%eax),%edx
  80091e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800921:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  800924:	8b 45 0c             	mov    0xc(%ebp),%eax
  800927:	8b 10                	mov    (%eax),%edx
  800929:	8b 45 0c             	mov    0xc(%ebp),%eax
  80092c:	8b 40 04             	mov    0x4(%eax),%eax
  80092f:	39 c2                	cmp    %eax,%edx
  800931:	73 12                	jae    800945 <sprintputch+0x33>
		*b->buf++ = ch;
  800933:	8b 45 0c             	mov    0xc(%ebp),%eax
  800936:	8b 00                	mov    (%eax),%eax
  800938:	8d 48 01             	lea    0x1(%eax),%ecx
  80093b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80093e:	89 0a                	mov    %ecx,(%edx)
  800940:	8b 55 08             	mov    0x8(%ebp),%edx
  800943:	88 10                	mov    %dl,(%eax)
}
  800945:	90                   	nop
  800946:	5d                   	pop    %ebp
  800947:	c3                   	ret    

00800948 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800948:	55                   	push   %ebp
  800949:	89 e5                	mov    %esp,%ebp
  80094b:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  80094e:	8b 45 08             	mov    0x8(%ebp),%eax
  800951:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800954:	8b 45 0c             	mov    0xc(%ebp),%eax
  800957:	8d 50 ff             	lea    -0x1(%eax),%edx
  80095a:	8b 45 08             	mov    0x8(%ebp),%eax
  80095d:	01 d0                	add    %edx,%eax
  80095f:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800962:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800969:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80096d:	74 06                	je     800975 <vsnprintf+0x2d>
  80096f:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800973:	7f 07                	jg     80097c <vsnprintf+0x34>
		return -E_INVAL;
  800975:	b8 03 00 00 00       	mov    $0x3,%eax
  80097a:	eb 20                	jmp    80099c <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  80097c:	ff 75 14             	pushl  0x14(%ebp)
  80097f:	ff 75 10             	pushl  0x10(%ebp)
  800982:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800985:	50                   	push   %eax
  800986:	68 12 09 80 00       	push   $0x800912
  80098b:	e8 92 fb ff ff       	call   800522 <vprintfmt>
  800990:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  800993:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800996:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800999:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  80099c:	c9                   	leave  
  80099d:	c3                   	ret    

0080099e <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  80099e:	55                   	push   %ebp
  80099f:	89 e5                	mov    %esp,%ebp
  8009a1:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  8009a4:	8d 45 10             	lea    0x10(%ebp),%eax
  8009a7:	83 c0 04             	add    $0x4,%eax
  8009aa:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  8009ad:	8b 45 10             	mov    0x10(%ebp),%eax
  8009b0:	ff 75 f4             	pushl  -0xc(%ebp)
  8009b3:	50                   	push   %eax
  8009b4:	ff 75 0c             	pushl  0xc(%ebp)
  8009b7:	ff 75 08             	pushl  0x8(%ebp)
  8009ba:	e8 89 ff ff ff       	call   800948 <vsnprintf>
  8009bf:	83 c4 10             	add    $0x10,%esp
  8009c2:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  8009c5:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8009c8:	c9                   	leave  
  8009c9:	c3                   	ret    

008009ca <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  8009ca:	55                   	push   %ebp
  8009cb:	89 e5                	mov    %esp,%ebp
  8009cd:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  8009d0:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8009d7:	eb 06                	jmp    8009df <strlen+0x15>
		n++;
  8009d9:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  8009dc:	ff 45 08             	incl   0x8(%ebp)
  8009df:	8b 45 08             	mov    0x8(%ebp),%eax
  8009e2:	8a 00                	mov    (%eax),%al
  8009e4:	84 c0                	test   %al,%al
  8009e6:	75 f1                	jne    8009d9 <strlen+0xf>
		n++;
	return n;
  8009e8:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  8009eb:	c9                   	leave  
  8009ec:	c3                   	ret    

008009ed <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  8009ed:	55                   	push   %ebp
  8009ee:	89 e5                	mov    %esp,%ebp
  8009f0:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8009f3:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8009fa:	eb 09                	jmp    800a05 <strnlen+0x18>
		n++;
  8009fc:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8009ff:	ff 45 08             	incl   0x8(%ebp)
  800a02:	ff 4d 0c             	decl   0xc(%ebp)
  800a05:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800a09:	74 09                	je     800a14 <strnlen+0x27>
  800a0b:	8b 45 08             	mov    0x8(%ebp),%eax
  800a0e:	8a 00                	mov    (%eax),%al
  800a10:	84 c0                	test   %al,%al
  800a12:	75 e8                	jne    8009fc <strnlen+0xf>
		n++;
	return n;
  800a14:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800a17:	c9                   	leave  
  800a18:	c3                   	ret    

00800a19 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800a19:	55                   	push   %ebp
  800a1a:	89 e5                	mov    %esp,%ebp
  800a1c:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  800a1f:	8b 45 08             	mov    0x8(%ebp),%eax
  800a22:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  800a25:	90                   	nop
  800a26:	8b 45 08             	mov    0x8(%ebp),%eax
  800a29:	8d 50 01             	lea    0x1(%eax),%edx
  800a2c:	89 55 08             	mov    %edx,0x8(%ebp)
  800a2f:	8b 55 0c             	mov    0xc(%ebp),%edx
  800a32:	8d 4a 01             	lea    0x1(%edx),%ecx
  800a35:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800a38:	8a 12                	mov    (%edx),%dl
  800a3a:	88 10                	mov    %dl,(%eax)
  800a3c:	8a 00                	mov    (%eax),%al
  800a3e:	84 c0                	test   %al,%al
  800a40:	75 e4                	jne    800a26 <strcpy+0xd>
		/* do nothing */;
	return ret;
  800a42:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800a45:	c9                   	leave  
  800a46:	c3                   	ret    

00800a47 <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  800a47:	55                   	push   %ebp
  800a48:	89 e5                	mov    %esp,%ebp
  800a4a:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  800a4d:	8b 45 08             	mov    0x8(%ebp),%eax
  800a50:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  800a53:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800a5a:	eb 1f                	jmp    800a7b <strncpy+0x34>
		*dst++ = *src;
  800a5c:	8b 45 08             	mov    0x8(%ebp),%eax
  800a5f:	8d 50 01             	lea    0x1(%eax),%edx
  800a62:	89 55 08             	mov    %edx,0x8(%ebp)
  800a65:	8b 55 0c             	mov    0xc(%ebp),%edx
  800a68:	8a 12                	mov    (%edx),%dl
  800a6a:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  800a6c:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a6f:	8a 00                	mov    (%eax),%al
  800a71:	84 c0                	test   %al,%al
  800a73:	74 03                	je     800a78 <strncpy+0x31>
			src++;
  800a75:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800a78:	ff 45 fc             	incl   -0x4(%ebp)
  800a7b:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800a7e:	3b 45 10             	cmp    0x10(%ebp),%eax
  800a81:	72 d9                	jb     800a5c <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  800a83:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  800a86:	c9                   	leave  
  800a87:	c3                   	ret    

00800a88 <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  800a88:	55                   	push   %ebp
  800a89:	89 e5                	mov    %esp,%ebp
  800a8b:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  800a8e:	8b 45 08             	mov    0x8(%ebp),%eax
  800a91:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  800a94:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800a98:	74 30                	je     800aca <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  800a9a:	eb 16                	jmp    800ab2 <strlcpy+0x2a>
			*dst++ = *src++;
  800a9c:	8b 45 08             	mov    0x8(%ebp),%eax
  800a9f:	8d 50 01             	lea    0x1(%eax),%edx
  800aa2:	89 55 08             	mov    %edx,0x8(%ebp)
  800aa5:	8b 55 0c             	mov    0xc(%ebp),%edx
  800aa8:	8d 4a 01             	lea    0x1(%edx),%ecx
  800aab:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800aae:	8a 12                	mov    (%edx),%dl
  800ab0:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800ab2:	ff 4d 10             	decl   0x10(%ebp)
  800ab5:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800ab9:	74 09                	je     800ac4 <strlcpy+0x3c>
  800abb:	8b 45 0c             	mov    0xc(%ebp),%eax
  800abe:	8a 00                	mov    (%eax),%al
  800ac0:	84 c0                	test   %al,%al
  800ac2:	75 d8                	jne    800a9c <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  800ac4:	8b 45 08             	mov    0x8(%ebp),%eax
  800ac7:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800aca:	8b 55 08             	mov    0x8(%ebp),%edx
  800acd:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800ad0:	29 c2                	sub    %eax,%edx
  800ad2:	89 d0                	mov    %edx,%eax
}
  800ad4:	c9                   	leave  
  800ad5:	c3                   	ret    

00800ad6 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800ad6:	55                   	push   %ebp
  800ad7:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  800ad9:	eb 06                	jmp    800ae1 <strcmp+0xb>
		p++, q++;
  800adb:	ff 45 08             	incl   0x8(%ebp)
  800ade:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  800ae1:	8b 45 08             	mov    0x8(%ebp),%eax
  800ae4:	8a 00                	mov    (%eax),%al
  800ae6:	84 c0                	test   %al,%al
  800ae8:	74 0e                	je     800af8 <strcmp+0x22>
  800aea:	8b 45 08             	mov    0x8(%ebp),%eax
  800aed:	8a 10                	mov    (%eax),%dl
  800aef:	8b 45 0c             	mov    0xc(%ebp),%eax
  800af2:	8a 00                	mov    (%eax),%al
  800af4:	38 c2                	cmp    %al,%dl
  800af6:	74 e3                	je     800adb <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800af8:	8b 45 08             	mov    0x8(%ebp),%eax
  800afb:	8a 00                	mov    (%eax),%al
  800afd:	0f b6 d0             	movzbl %al,%edx
  800b00:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b03:	8a 00                	mov    (%eax),%al
  800b05:	0f b6 c0             	movzbl %al,%eax
  800b08:	29 c2                	sub    %eax,%edx
  800b0a:	89 d0                	mov    %edx,%eax
}
  800b0c:	5d                   	pop    %ebp
  800b0d:	c3                   	ret    

00800b0e <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  800b0e:	55                   	push   %ebp
  800b0f:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  800b11:	eb 09                	jmp    800b1c <strncmp+0xe>
		n--, p++, q++;
  800b13:	ff 4d 10             	decl   0x10(%ebp)
  800b16:	ff 45 08             	incl   0x8(%ebp)
  800b19:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  800b1c:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800b20:	74 17                	je     800b39 <strncmp+0x2b>
  800b22:	8b 45 08             	mov    0x8(%ebp),%eax
  800b25:	8a 00                	mov    (%eax),%al
  800b27:	84 c0                	test   %al,%al
  800b29:	74 0e                	je     800b39 <strncmp+0x2b>
  800b2b:	8b 45 08             	mov    0x8(%ebp),%eax
  800b2e:	8a 10                	mov    (%eax),%dl
  800b30:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b33:	8a 00                	mov    (%eax),%al
  800b35:	38 c2                	cmp    %al,%dl
  800b37:	74 da                	je     800b13 <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  800b39:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800b3d:	75 07                	jne    800b46 <strncmp+0x38>
		return 0;
  800b3f:	b8 00 00 00 00       	mov    $0x0,%eax
  800b44:	eb 14                	jmp    800b5a <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800b46:	8b 45 08             	mov    0x8(%ebp),%eax
  800b49:	8a 00                	mov    (%eax),%al
  800b4b:	0f b6 d0             	movzbl %al,%edx
  800b4e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b51:	8a 00                	mov    (%eax),%al
  800b53:	0f b6 c0             	movzbl %al,%eax
  800b56:	29 c2                	sub    %eax,%edx
  800b58:	89 d0                	mov    %edx,%eax
}
  800b5a:	5d                   	pop    %ebp
  800b5b:	c3                   	ret    

00800b5c <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800b5c:	55                   	push   %ebp
  800b5d:	89 e5                	mov    %esp,%ebp
  800b5f:	83 ec 04             	sub    $0x4,%esp
  800b62:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b65:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800b68:	eb 12                	jmp    800b7c <strchr+0x20>
		if (*s == c)
  800b6a:	8b 45 08             	mov    0x8(%ebp),%eax
  800b6d:	8a 00                	mov    (%eax),%al
  800b6f:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800b72:	75 05                	jne    800b79 <strchr+0x1d>
			return (char *) s;
  800b74:	8b 45 08             	mov    0x8(%ebp),%eax
  800b77:	eb 11                	jmp    800b8a <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  800b79:	ff 45 08             	incl   0x8(%ebp)
  800b7c:	8b 45 08             	mov    0x8(%ebp),%eax
  800b7f:	8a 00                	mov    (%eax),%al
  800b81:	84 c0                	test   %al,%al
  800b83:	75 e5                	jne    800b6a <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  800b85:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800b8a:	c9                   	leave  
  800b8b:	c3                   	ret    

00800b8c <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800b8c:	55                   	push   %ebp
  800b8d:	89 e5                	mov    %esp,%ebp
  800b8f:	83 ec 04             	sub    $0x4,%esp
  800b92:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b95:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800b98:	eb 0d                	jmp    800ba7 <strfind+0x1b>
		if (*s == c)
  800b9a:	8b 45 08             	mov    0x8(%ebp),%eax
  800b9d:	8a 00                	mov    (%eax),%al
  800b9f:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800ba2:	74 0e                	je     800bb2 <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  800ba4:	ff 45 08             	incl   0x8(%ebp)
  800ba7:	8b 45 08             	mov    0x8(%ebp),%eax
  800baa:	8a 00                	mov    (%eax),%al
  800bac:	84 c0                	test   %al,%al
  800bae:	75 ea                	jne    800b9a <strfind+0xe>
  800bb0:	eb 01                	jmp    800bb3 <strfind+0x27>
		if (*s == c)
			break;
  800bb2:	90                   	nop
	return (char *) s;
  800bb3:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800bb6:	c9                   	leave  
  800bb7:	c3                   	ret    

00800bb8 <memset>:


void *
memset(void *v, int c, uint32 n)
{
  800bb8:	55                   	push   %ebp
  800bb9:	89 e5                	mov    %esp,%ebp
  800bbb:	83 ec 10             	sub    $0x10,%esp
	char *p;
	int m;

	p = v;
  800bbe:	8b 45 08             	mov    0x8(%ebp),%eax
  800bc1:	89 45 fc             	mov    %eax,-0x4(%ebp)
	m = n;
  800bc4:	8b 45 10             	mov    0x10(%ebp),%eax
  800bc7:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (--m >= 0)
  800bca:	eb 0e                	jmp    800bda <memset+0x22>
		*p++ = c;
  800bcc:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800bcf:	8d 50 01             	lea    0x1(%eax),%edx
  800bd2:	89 55 fc             	mov    %edx,-0x4(%ebp)
  800bd5:	8b 55 0c             	mov    0xc(%ebp),%edx
  800bd8:	88 10                	mov    %dl,(%eax)
	char *p;
	int m;

	p = v;
	m = n;
	while (--m >= 0)
  800bda:	ff 4d f8             	decl   -0x8(%ebp)
  800bdd:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  800be1:	79 e9                	jns    800bcc <memset+0x14>
		*p++ = c;

	return v;
  800be3:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800be6:	c9                   	leave  
  800be7:	c3                   	ret    

00800be8 <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  800be8:	55                   	push   %ebp
  800be9:	89 e5                	mov    %esp,%ebp
  800beb:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800bee:	8b 45 0c             	mov    0xc(%ebp),%eax
  800bf1:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800bf4:	8b 45 08             	mov    0x8(%ebp),%eax
  800bf7:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (n-- > 0)
  800bfa:	eb 16                	jmp    800c12 <memcpy+0x2a>
		*d++ = *s++;
  800bfc:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800bff:	8d 50 01             	lea    0x1(%eax),%edx
  800c02:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800c05:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800c08:	8d 4a 01             	lea    0x1(%edx),%ecx
  800c0b:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800c0e:	8a 12                	mov    (%edx),%dl
  800c10:	88 10                	mov    %dl,(%eax)
	const char *s;
	char *d;

	s = src;
	d = dst;
	while (n-- > 0)
  800c12:	8b 45 10             	mov    0x10(%ebp),%eax
  800c15:	8d 50 ff             	lea    -0x1(%eax),%edx
  800c18:	89 55 10             	mov    %edx,0x10(%ebp)
  800c1b:	85 c0                	test   %eax,%eax
  800c1d:	75 dd                	jne    800bfc <memcpy+0x14>
		*d++ = *s++;

	return dst;
  800c1f:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800c22:	c9                   	leave  
  800c23:	c3                   	ret    

00800c24 <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  800c24:	55                   	push   %ebp
  800c25:	89 e5                	mov    %esp,%ebp
  800c27:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800c2a:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c2d:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800c30:	8b 45 08             	mov    0x8(%ebp),%eax
  800c33:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  800c36:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800c39:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800c3c:	73 50                	jae    800c8e <memmove+0x6a>
  800c3e:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800c41:	8b 45 10             	mov    0x10(%ebp),%eax
  800c44:	01 d0                	add    %edx,%eax
  800c46:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800c49:	76 43                	jbe    800c8e <memmove+0x6a>
		s += n;
  800c4b:	8b 45 10             	mov    0x10(%ebp),%eax
  800c4e:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  800c51:	8b 45 10             	mov    0x10(%ebp),%eax
  800c54:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  800c57:	eb 10                	jmp    800c69 <memmove+0x45>
			*--d = *--s;
  800c59:	ff 4d f8             	decl   -0x8(%ebp)
  800c5c:	ff 4d fc             	decl   -0x4(%ebp)
  800c5f:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800c62:	8a 10                	mov    (%eax),%dl
  800c64:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800c67:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  800c69:	8b 45 10             	mov    0x10(%ebp),%eax
  800c6c:	8d 50 ff             	lea    -0x1(%eax),%edx
  800c6f:	89 55 10             	mov    %edx,0x10(%ebp)
  800c72:	85 c0                	test   %eax,%eax
  800c74:	75 e3                	jne    800c59 <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800c76:	eb 23                	jmp    800c9b <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  800c78:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800c7b:	8d 50 01             	lea    0x1(%eax),%edx
  800c7e:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800c81:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800c84:	8d 4a 01             	lea    0x1(%edx),%ecx
  800c87:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800c8a:	8a 12                	mov    (%edx),%dl
  800c8c:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  800c8e:	8b 45 10             	mov    0x10(%ebp),%eax
  800c91:	8d 50 ff             	lea    -0x1(%eax),%edx
  800c94:	89 55 10             	mov    %edx,0x10(%ebp)
  800c97:	85 c0                	test   %eax,%eax
  800c99:	75 dd                	jne    800c78 <memmove+0x54>
			*d++ = *s++;

	return dst;
  800c9b:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800c9e:	c9                   	leave  
  800c9f:	c3                   	ret    

00800ca0 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  800ca0:	55                   	push   %ebp
  800ca1:	89 e5                	mov    %esp,%ebp
  800ca3:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  800ca6:	8b 45 08             	mov    0x8(%ebp),%eax
  800ca9:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  800cac:	8b 45 0c             	mov    0xc(%ebp),%eax
  800caf:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  800cb2:	eb 2a                	jmp    800cde <memcmp+0x3e>
		if (*s1 != *s2)
  800cb4:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800cb7:	8a 10                	mov    (%eax),%dl
  800cb9:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800cbc:	8a 00                	mov    (%eax),%al
  800cbe:	38 c2                	cmp    %al,%dl
  800cc0:	74 16                	je     800cd8 <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  800cc2:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800cc5:	8a 00                	mov    (%eax),%al
  800cc7:	0f b6 d0             	movzbl %al,%edx
  800cca:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800ccd:	8a 00                	mov    (%eax),%al
  800ccf:	0f b6 c0             	movzbl %al,%eax
  800cd2:	29 c2                	sub    %eax,%edx
  800cd4:	89 d0                	mov    %edx,%eax
  800cd6:	eb 18                	jmp    800cf0 <memcmp+0x50>
		s1++, s2++;
  800cd8:	ff 45 fc             	incl   -0x4(%ebp)
  800cdb:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  800cde:	8b 45 10             	mov    0x10(%ebp),%eax
  800ce1:	8d 50 ff             	lea    -0x1(%eax),%edx
  800ce4:	89 55 10             	mov    %edx,0x10(%ebp)
  800ce7:	85 c0                	test   %eax,%eax
  800ce9:	75 c9                	jne    800cb4 <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  800ceb:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800cf0:	c9                   	leave  
  800cf1:	c3                   	ret    

00800cf2 <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  800cf2:	55                   	push   %ebp
  800cf3:	89 e5                	mov    %esp,%ebp
  800cf5:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  800cf8:	8b 55 08             	mov    0x8(%ebp),%edx
  800cfb:	8b 45 10             	mov    0x10(%ebp),%eax
  800cfe:	01 d0                	add    %edx,%eax
  800d00:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  800d03:	eb 15                	jmp    800d1a <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  800d05:	8b 45 08             	mov    0x8(%ebp),%eax
  800d08:	8a 00                	mov    (%eax),%al
  800d0a:	0f b6 d0             	movzbl %al,%edx
  800d0d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d10:	0f b6 c0             	movzbl %al,%eax
  800d13:	39 c2                	cmp    %eax,%edx
  800d15:	74 0d                	je     800d24 <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  800d17:	ff 45 08             	incl   0x8(%ebp)
  800d1a:	8b 45 08             	mov    0x8(%ebp),%eax
  800d1d:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  800d20:	72 e3                	jb     800d05 <memfind+0x13>
  800d22:	eb 01                	jmp    800d25 <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  800d24:	90                   	nop
	return (void *) s;
  800d25:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800d28:	c9                   	leave  
  800d29:	c3                   	ret    

00800d2a <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800d2a:	55                   	push   %ebp
  800d2b:	89 e5                	mov    %esp,%ebp
  800d2d:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  800d30:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  800d37:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800d3e:	eb 03                	jmp    800d43 <strtol+0x19>
		s++;
  800d40:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800d43:	8b 45 08             	mov    0x8(%ebp),%eax
  800d46:	8a 00                	mov    (%eax),%al
  800d48:	3c 20                	cmp    $0x20,%al
  800d4a:	74 f4                	je     800d40 <strtol+0x16>
  800d4c:	8b 45 08             	mov    0x8(%ebp),%eax
  800d4f:	8a 00                	mov    (%eax),%al
  800d51:	3c 09                	cmp    $0x9,%al
  800d53:	74 eb                	je     800d40 <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  800d55:	8b 45 08             	mov    0x8(%ebp),%eax
  800d58:	8a 00                	mov    (%eax),%al
  800d5a:	3c 2b                	cmp    $0x2b,%al
  800d5c:	75 05                	jne    800d63 <strtol+0x39>
		s++;
  800d5e:	ff 45 08             	incl   0x8(%ebp)
  800d61:	eb 13                	jmp    800d76 <strtol+0x4c>
	else if (*s == '-')
  800d63:	8b 45 08             	mov    0x8(%ebp),%eax
  800d66:	8a 00                	mov    (%eax),%al
  800d68:	3c 2d                	cmp    $0x2d,%al
  800d6a:	75 0a                	jne    800d76 <strtol+0x4c>
		s++, neg = 1;
  800d6c:	ff 45 08             	incl   0x8(%ebp)
  800d6f:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800d76:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800d7a:	74 06                	je     800d82 <strtol+0x58>
  800d7c:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  800d80:	75 20                	jne    800da2 <strtol+0x78>
  800d82:	8b 45 08             	mov    0x8(%ebp),%eax
  800d85:	8a 00                	mov    (%eax),%al
  800d87:	3c 30                	cmp    $0x30,%al
  800d89:	75 17                	jne    800da2 <strtol+0x78>
  800d8b:	8b 45 08             	mov    0x8(%ebp),%eax
  800d8e:	40                   	inc    %eax
  800d8f:	8a 00                	mov    (%eax),%al
  800d91:	3c 78                	cmp    $0x78,%al
  800d93:	75 0d                	jne    800da2 <strtol+0x78>
		s += 2, base = 16;
  800d95:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  800d99:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  800da0:	eb 28                	jmp    800dca <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  800da2:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800da6:	75 15                	jne    800dbd <strtol+0x93>
  800da8:	8b 45 08             	mov    0x8(%ebp),%eax
  800dab:	8a 00                	mov    (%eax),%al
  800dad:	3c 30                	cmp    $0x30,%al
  800daf:	75 0c                	jne    800dbd <strtol+0x93>
		s++, base = 8;
  800db1:	ff 45 08             	incl   0x8(%ebp)
  800db4:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  800dbb:	eb 0d                	jmp    800dca <strtol+0xa0>
	else if (base == 0)
  800dbd:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800dc1:	75 07                	jne    800dca <strtol+0xa0>
		base = 10;
  800dc3:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  800dca:	8b 45 08             	mov    0x8(%ebp),%eax
  800dcd:	8a 00                	mov    (%eax),%al
  800dcf:	3c 2f                	cmp    $0x2f,%al
  800dd1:	7e 19                	jle    800dec <strtol+0xc2>
  800dd3:	8b 45 08             	mov    0x8(%ebp),%eax
  800dd6:	8a 00                	mov    (%eax),%al
  800dd8:	3c 39                	cmp    $0x39,%al
  800dda:	7f 10                	jg     800dec <strtol+0xc2>
			dig = *s - '0';
  800ddc:	8b 45 08             	mov    0x8(%ebp),%eax
  800ddf:	8a 00                	mov    (%eax),%al
  800de1:	0f be c0             	movsbl %al,%eax
  800de4:	83 e8 30             	sub    $0x30,%eax
  800de7:	89 45 f4             	mov    %eax,-0xc(%ebp)
  800dea:	eb 42                	jmp    800e2e <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  800dec:	8b 45 08             	mov    0x8(%ebp),%eax
  800def:	8a 00                	mov    (%eax),%al
  800df1:	3c 60                	cmp    $0x60,%al
  800df3:	7e 19                	jle    800e0e <strtol+0xe4>
  800df5:	8b 45 08             	mov    0x8(%ebp),%eax
  800df8:	8a 00                	mov    (%eax),%al
  800dfa:	3c 7a                	cmp    $0x7a,%al
  800dfc:	7f 10                	jg     800e0e <strtol+0xe4>
			dig = *s - 'a' + 10;
  800dfe:	8b 45 08             	mov    0x8(%ebp),%eax
  800e01:	8a 00                	mov    (%eax),%al
  800e03:	0f be c0             	movsbl %al,%eax
  800e06:	83 e8 57             	sub    $0x57,%eax
  800e09:	89 45 f4             	mov    %eax,-0xc(%ebp)
  800e0c:	eb 20                	jmp    800e2e <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  800e0e:	8b 45 08             	mov    0x8(%ebp),%eax
  800e11:	8a 00                	mov    (%eax),%al
  800e13:	3c 40                	cmp    $0x40,%al
  800e15:	7e 39                	jle    800e50 <strtol+0x126>
  800e17:	8b 45 08             	mov    0x8(%ebp),%eax
  800e1a:	8a 00                	mov    (%eax),%al
  800e1c:	3c 5a                	cmp    $0x5a,%al
  800e1e:	7f 30                	jg     800e50 <strtol+0x126>
			dig = *s - 'A' + 10;
  800e20:	8b 45 08             	mov    0x8(%ebp),%eax
  800e23:	8a 00                	mov    (%eax),%al
  800e25:	0f be c0             	movsbl %al,%eax
  800e28:	83 e8 37             	sub    $0x37,%eax
  800e2b:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  800e2e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800e31:	3b 45 10             	cmp    0x10(%ebp),%eax
  800e34:	7d 19                	jge    800e4f <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  800e36:	ff 45 08             	incl   0x8(%ebp)
  800e39:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800e3c:	0f af 45 10          	imul   0x10(%ebp),%eax
  800e40:	89 c2                	mov    %eax,%edx
  800e42:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800e45:	01 d0                	add    %edx,%eax
  800e47:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  800e4a:	e9 7b ff ff ff       	jmp    800dca <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  800e4f:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  800e50:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800e54:	74 08                	je     800e5e <strtol+0x134>
		*endptr = (char *) s;
  800e56:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e59:	8b 55 08             	mov    0x8(%ebp),%edx
  800e5c:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  800e5e:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  800e62:	74 07                	je     800e6b <strtol+0x141>
  800e64:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800e67:	f7 d8                	neg    %eax
  800e69:	eb 03                	jmp    800e6e <strtol+0x144>
  800e6b:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  800e6e:	c9                   	leave  
  800e6f:	c3                   	ret    

00800e70 <ltostr>:

void
ltostr(long value, char *str)
{
  800e70:	55                   	push   %ebp
  800e71:	89 e5                	mov    %esp,%ebp
  800e73:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  800e76:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  800e7d:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  800e84:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800e88:	79 13                	jns    800e9d <ltostr+0x2d>
	{
		neg = 1;
  800e8a:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  800e91:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e94:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  800e97:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  800e9a:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  800e9d:	8b 45 08             	mov    0x8(%ebp),%eax
  800ea0:	b9 0a 00 00 00       	mov    $0xa,%ecx
  800ea5:	99                   	cltd   
  800ea6:	f7 f9                	idiv   %ecx
  800ea8:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  800eab:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800eae:	8d 50 01             	lea    0x1(%eax),%edx
  800eb1:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800eb4:	89 c2                	mov    %eax,%edx
  800eb6:	8b 45 0c             	mov    0xc(%ebp),%eax
  800eb9:	01 d0                	add    %edx,%eax
  800ebb:	8b 55 ec             	mov    -0x14(%ebp),%edx
  800ebe:	83 c2 30             	add    $0x30,%edx
  800ec1:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  800ec3:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800ec6:	b8 67 66 66 66       	mov    $0x66666667,%eax
  800ecb:	f7 e9                	imul   %ecx
  800ecd:	c1 fa 02             	sar    $0x2,%edx
  800ed0:	89 c8                	mov    %ecx,%eax
  800ed2:	c1 f8 1f             	sar    $0x1f,%eax
  800ed5:	29 c2                	sub    %eax,%edx
  800ed7:	89 d0                	mov    %edx,%eax
  800ed9:	89 45 08             	mov    %eax,0x8(%ebp)
	} while (value % 10 != 0);
  800edc:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800edf:	b8 67 66 66 66       	mov    $0x66666667,%eax
  800ee4:	f7 e9                	imul   %ecx
  800ee6:	c1 fa 02             	sar    $0x2,%edx
  800ee9:	89 c8                	mov    %ecx,%eax
  800eeb:	c1 f8 1f             	sar    $0x1f,%eax
  800eee:	29 c2                	sub    %eax,%edx
  800ef0:	89 d0                	mov    %edx,%eax
  800ef2:	c1 e0 02             	shl    $0x2,%eax
  800ef5:	01 d0                	add    %edx,%eax
  800ef7:	01 c0                	add    %eax,%eax
  800ef9:	29 c1                	sub    %eax,%ecx
  800efb:	89 ca                	mov    %ecx,%edx
  800efd:	85 d2                	test   %edx,%edx
  800eff:	75 9c                	jne    800e9d <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  800f01:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  800f08:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800f0b:	48                   	dec    %eax
  800f0c:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  800f0f:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  800f13:	74 3d                	je     800f52 <ltostr+0xe2>
		start = 1 ;
  800f15:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  800f1c:	eb 34                	jmp    800f52 <ltostr+0xe2>
	{
		char tmp = str[start] ;
  800f1e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800f21:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f24:	01 d0                	add    %edx,%eax
  800f26:	8a 00                	mov    (%eax),%al
  800f28:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  800f2b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800f2e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f31:	01 c2                	add    %eax,%edx
  800f33:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  800f36:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f39:	01 c8                	add    %ecx,%eax
  800f3b:	8a 00                	mov    (%eax),%al
  800f3d:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  800f3f:	8b 55 f0             	mov    -0x10(%ebp),%edx
  800f42:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f45:	01 c2                	add    %eax,%edx
  800f47:	8a 45 eb             	mov    -0x15(%ebp),%al
  800f4a:	88 02                	mov    %al,(%edx)
		start++ ;
  800f4c:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  800f4f:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  800f52:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800f55:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800f58:	7c c4                	jl     800f1e <ltostr+0xae>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  800f5a:	8b 55 f8             	mov    -0x8(%ebp),%edx
  800f5d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f60:	01 d0                	add    %edx,%eax
  800f62:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  800f65:	90                   	nop
  800f66:	c9                   	leave  
  800f67:	c3                   	ret    

00800f68 <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  800f68:	55                   	push   %ebp
  800f69:	89 e5                	mov    %esp,%ebp
  800f6b:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  800f6e:	ff 75 08             	pushl  0x8(%ebp)
  800f71:	e8 54 fa ff ff       	call   8009ca <strlen>
  800f76:	83 c4 04             	add    $0x4,%esp
  800f79:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  800f7c:	ff 75 0c             	pushl  0xc(%ebp)
  800f7f:	e8 46 fa ff ff       	call   8009ca <strlen>
  800f84:	83 c4 04             	add    $0x4,%esp
  800f87:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  800f8a:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  800f91:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800f98:	eb 17                	jmp    800fb1 <strcconcat+0x49>
		final[s] = str1[s] ;
  800f9a:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800f9d:	8b 45 10             	mov    0x10(%ebp),%eax
  800fa0:	01 c2                	add    %eax,%edx
  800fa2:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  800fa5:	8b 45 08             	mov    0x8(%ebp),%eax
  800fa8:	01 c8                	add    %ecx,%eax
  800faa:	8a 00                	mov    (%eax),%al
  800fac:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  800fae:	ff 45 fc             	incl   -0x4(%ebp)
  800fb1:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800fb4:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  800fb7:	7c e1                	jl     800f9a <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  800fb9:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  800fc0:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  800fc7:	eb 1f                	jmp    800fe8 <strcconcat+0x80>
		final[s++] = str2[i] ;
  800fc9:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800fcc:	8d 50 01             	lea    0x1(%eax),%edx
  800fcf:	89 55 fc             	mov    %edx,-0x4(%ebp)
  800fd2:	89 c2                	mov    %eax,%edx
  800fd4:	8b 45 10             	mov    0x10(%ebp),%eax
  800fd7:	01 c2                	add    %eax,%edx
  800fd9:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  800fdc:	8b 45 0c             	mov    0xc(%ebp),%eax
  800fdf:	01 c8                	add    %ecx,%eax
  800fe1:	8a 00                	mov    (%eax),%al
  800fe3:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  800fe5:	ff 45 f8             	incl   -0x8(%ebp)
  800fe8:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800feb:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800fee:	7c d9                	jl     800fc9 <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  800ff0:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800ff3:	8b 45 10             	mov    0x10(%ebp),%eax
  800ff6:	01 d0                	add    %edx,%eax
  800ff8:	c6 00 00             	movb   $0x0,(%eax)
}
  800ffb:	90                   	nop
  800ffc:	c9                   	leave  
  800ffd:	c3                   	ret    

00800ffe <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  800ffe:	55                   	push   %ebp
  800fff:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  801001:	8b 45 14             	mov    0x14(%ebp),%eax
  801004:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  80100a:	8b 45 14             	mov    0x14(%ebp),%eax
  80100d:	8b 00                	mov    (%eax),%eax
  80100f:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801016:	8b 45 10             	mov    0x10(%ebp),%eax
  801019:	01 d0                	add    %edx,%eax
  80101b:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801021:	eb 0c                	jmp    80102f <strsplit+0x31>
			*string++ = 0;
  801023:	8b 45 08             	mov    0x8(%ebp),%eax
  801026:	8d 50 01             	lea    0x1(%eax),%edx
  801029:	89 55 08             	mov    %edx,0x8(%ebp)
  80102c:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  80102f:	8b 45 08             	mov    0x8(%ebp),%eax
  801032:	8a 00                	mov    (%eax),%al
  801034:	84 c0                	test   %al,%al
  801036:	74 18                	je     801050 <strsplit+0x52>
  801038:	8b 45 08             	mov    0x8(%ebp),%eax
  80103b:	8a 00                	mov    (%eax),%al
  80103d:	0f be c0             	movsbl %al,%eax
  801040:	50                   	push   %eax
  801041:	ff 75 0c             	pushl  0xc(%ebp)
  801044:	e8 13 fb ff ff       	call   800b5c <strchr>
  801049:	83 c4 08             	add    $0x8,%esp
  80104c:	85 c0                	test   %eax,%eax
  80104e:	75 d3                	jne    801023 <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  801050:	8b 45 08             	mov    0x8(%ebp),%eax
  801053:	8a 00                	mov    (%eax),%al
  801055:	84 c0                	test   %al,%al
  801057:	74 5a                	je     8010b3 <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  801059:	8b 45 14             	mov    0x14(%ebp),%eax
  80105c:	8b 00                	mov    (%eax),%eax
  80105e:	83 f8 0f             	cmp    $0xf,%eax
  801061:	75 07                	jne    80106a <strsplit+0x6c>
		{
			return 0;
  801063:	b8 00 00 00 00       	mov    $0x0,%eax
  801068:	eb 66                	jmp    8010d0 <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  80106a:	8b 45 14             	mov    0x14(%ebp),%eax
  80106d:	8b 00                	mov    (%eax),%eax
  80106f:	8d 48 01             	lea    0x1(%eax),%ecx
  801072:	8b 55 14             	mov    0x14(%ebp),%edx
  801075:	89 0a                	mov    %ecx,(%edx)
  801077:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80107e:	8b 45 10             	mov    0x10(%ebp),%eax
  801081:	01 c2                	add    %eax,%edx
  801083:	8b 45 08             	mov    0x8(%ebp),%eax
  801086:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  801088:	eb 03                	jmp    80108d <strsplit+0x8f>
			string++;
  80108a:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  80108d:	8b 45 08             	mov    0x8(%ebp),%eax
  801090:	8a 00                	mov    (%eax),%al
  801092:	84 c0                	test   %al,%al
  801094:	74 8b                	je     801021 <strsplit+0x23>
  801096:	8b 45 08             	mov    0x8(%ebp),%eax
  801099:	8a 00                	mov    (%eax),%al
  80109b:	0f be c0             	movsbl %al,%eax
  80109e:	50                   	push   %eax
  80109f:	ff 75 0c             	pushl  0xc(%ebp)
  8010a2:	e8 b5 fa ff ff       	call   800b5c <strchr>
  8010a7:	83 c4 08             	add    $0x8,%esp
  8010aa:	85 c0                	test   %eax,%eax
  8010ac:	74 dc                	je     80108a <strsplit+0x8c>
			string++;
	}
  8010ae:	e9 6e ff ff ff       	jmp    801021 <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  8010b3:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  8010b4:	8b 45 14             	mov    0x14(%ebp),%eax
  8010b7:	8b 00                	mov    (%eax),%eax
  8010b9:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8010c0:	8b 45 10             	mov    0x10(%ebp),%eax
  8010c3:	01 d0                	add    %edx,%eax
  8010c5:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  8010cb:	b8 01 00 00 00       	mov    $0x1,%eax
}
  8010d0:	c9                   	leave  
  8010d1:	c3                   	ret    

008010d2 <InitializeUHeap>:
//============================== GIVEN FUNCTIONS ===================================//
//==================================================================================//

int FirstTimeFlag = 1;
void InitializeUHeap()
{
  8010d2:	55                   	push   %ebp
  8010d3:	89 e5                	mov    %esp,%ebp
  8010d5:	83 ec 08             	sub    $0x8,%esp
	if(FirstTimeFlag)
  8010d8:	a1 04 40 80 00       	mov    0x804004,%eax
  8010dd:	85 c0                	test   %eax,%eax
  8010df:	74 1f                	je     801100 <InitializeUHeap+0x2e>
	{
		initialize_dyn_block_system();
  8010e1:	e8 1d 00 00 00       	call   801103 <initialize_dyn_block_system>
		cprintf("DYNAMIC BLOCK SYSTEM IS INITIALIZED\n");
  8010e6:	83 ec 0c             	sub    $0xc,%esp
  8010e9:	68 50 35 80 00       	push   $0x803550
  8010ee:	e8 55 f2 ff ff       	call   800348 <cprintf>
  8010f3:	83 c4 10             	add    $0x10,%esp
#if UHP_USE_BUDDY
		initialize_buddy();
		cprintf("BUDDY SYSTEM IS INITIALIZED\n");
#endif
		FirstTimeFlag = 0;
  8010f6:	c7 05 04 40 80 00 00 	movl   $0x0,0x804004
  8010fd:	00 00 00 
	}
}
  801100:	90                   	nop
  801101:	c9                   	leave  
  801102:	c3                   	ret    

00801103 <initialize_dyn_block_system>:

//=================================
// [1] INITIALIZE DYNAMIC ALLOCATOR:
//=================================
void initialize_dyn_block_system()
{
  801103:	55                   	push   %ebp
  801104:	89 e5                	mov    %esp,%ebp
  801106:	83 ec 28             	sub    $0x28,%esp
	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] initialize_dyn_block_system
	// your code is here, remove the panic and write your code
	//panic("initialize_dyn_block_system() is not implemented yet...!!");

	LIST_INIT(&AllocMemBlocksList);
  801109:	c7 05 40 40 80 00 00 	movl   $0x0,0x804040
  801110:	00 00 00 
  801113:	c7 05 44 40 80 00 00 	movl   $0x0,0x804044
  80111a:	00 00 00 
  80111d:	c7 05 4c 40 80 00 00 	movl   $0x0,0x80404c
  801124:	00 00 00 
	LIST_INIT(&FreeMemBlocksList);
  801127:	c7 05 38 41 80 00 00 	movl   $0x0,0x804138
  80112e:	00 00 00 
  801131:	c7 05 3c 41 80 00 00 	movl   $0x0,0x80413c
  801138:	00 00 00 
  80113b:	c7 05 44 41 80 00 00 	movl   $0x0,0x804144
  801142:	00 00 00 
	MAX_MEM_BLOCK_CNT = NUM_OF_UHEAP_PAGES;
  801145:	c7 05 20 41 80 00 00 	movl   $0x20000,0x804120
  80114c:	00 02 00 
	MemBlockNodes = (void*)USER_DYN_BLKS_ARRAY;
  80114f:	c7 45 f4 00 00 e0 7f 	movl   $0x7fe00000,-0xc(%ebp)
  801156:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801159:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80115e:	2d 00 10 00 00       	sub    $0x1000,%eax
  801163:	a3 50 40 80 00       	mov    %eax,0x804050
	int size_of_block = sizeof(struct MemBlock);
  801168:	c7 45 f0 10 00 00 00 	movl   $0x10,-0x10(%ebp)
	int size_all_struct = size_of_block*MAX_MEM_BLOCK_CNT;
  80116f:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801172:	a1 20 41 80 00       	mov    0x804120,%eax
  801177:	0f af c2             	imul   %edx,%eax
  80117a:	89 45 ec             	mov    %eax,-0x14(%ebp)
	size_all_struct = ROUNDUP(size_all_struct, PAGE_SIZE);
  80117d:	c7 45 e8 00 10 00 00 	movl   $0x1000,-0x18(%ebp)
  801184:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801187:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80118a:	01 d0                	add    %edx,%eax
  80118c:	48                   	dec    %eax
  80118d:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  801190:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801193:	ba 00 00 00 00       	mov    $0x0,%edx
  801198:	f7 75 e8             	divl   -0x18(%ebp)
  80119b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80119e:	29 d0                	sub    %edx,%eax
  8011a0:	89 45 ec             	mov    %eax,-0x14(%ebp)
	sys_allocate_chunk(USER_DYN_BLKS_ARRAY, size_all_struct,PERM_USER| PERM_WRITEABLE);
  8011a3:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8011a6:	c7 45 e0 00 00 e0 7f 	movl   $0x7fe00000,-0x20(%ebp)
  8011ad:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8011b0:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
  8011b6:	81 ea 00 10 00 00    	sub    $0x1000,%edx
  8011bc:	83 ec 04             	sub    $0x4,%esp
  8011bf:	6a 06                	push   $0x6
  8011c1:	50                   	push   %eax
  8011c2:	52                   	push   %edx
  8011c3:	e8 a1 05 00 00       	call   801769 <sys_allocate_chunk>
  8011c8:	83 c4 10             	add    $0x10,%esp
	initialize_MemBlocksList(MAX_MEM_BLOCK_CNT);
  8011cb:	a1 20 41 80 00       	mov    0x804120,%eax
  8011d0:	83 ec 0c             	sub    $0xc,%esp
  8011d3:	50                   	push   %eax
  8011d4:	e8 16 0c 00 00       	call   801def <initialize_MemBlocksList>
  8011d9:	83 c4 10             	add    $0x10,%esp
	struct MemBlock* ourBlock =LIST_LAST(&AvailableMemBlocksList);
  8011dc:	a1 4c 41 80 00       	mov    0x80414c,%eax
  8011e1:	89 45 dc             	mov    %eax,-0x24(%ebp)
	LIST_REMOVE(&AvailableMemBlocksList,ourBlock);
  8011e4:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  8011e8:	75 14                	jne    8011fe <initialize_dyn_block_system+0xfb>
  8011ea:	83 ec 04             	sub    $0x4,%esp
  8011ed:	68 75 35 80 00       	push   $0x803575
  8011f2:	6a 2d                	push   $0x2d
  8011f4:	68 93 35 80 00       	push   $0x803593
  8011f9:	e8 70 1a 00 00       	call   802c6e <_panic>
  8011fe:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801201:	8b 00                	mov    (%eax),%eax
  801203:	85 c0                	test   %eax,%eax
  801205:	74 10                	je     801217 <initialize_dyn_block_system+0x114>
  801207:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80120a:	8b 00                	mov    (%eax),%eax
  80120c:	8b 55 dc             	mov    -0x24(%ebp),%edx
  80120f:	8b 52 04             	mov    0x4(%edx),%edx
  801212:	89 50 04             	mov    %edx,0x4(%eax)
  801215:	eb 0b                	jmp    801222 <initialize_dyn_block_system+0x11f>
  801217:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80121a:	8b 40 04             	mov    0x4(%eax),%eax
  80121d:	a3 4c 41 80 00       	mov    %eax,0x80414c
  801222:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801225:	8b 40 04             	mov    0x4(%eax),%eax
  801228:	85 c0                	test   %eax,%eax
  80122a:	74 0f                	je     80123b <initialize_dyn_block_system+0x138>
  80122c:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80122f:	8b 40 04             	mov    0x4(%eax),%eax
  801232:	8b 55 dc             	mov    -0x24(%ebp),%edx
  801235:	8b 12                	mov    (%edx),%edx
  801237:	89 10                	mov    %edx,(%eax)
  801239:	eb 0a                	jmp    801245 <initialize_dyn_block_system+0x142>
  80123b:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80123e:	8b 00                	mov    (%eax),%eax
  801240:	a3 48 41 80 00       	mov    %eax,0x804148
  801245:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801248:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80124e:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801251:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  801258:	a1 54 41 80 00       	mov    0x804154,%eax
  80125d:	48                   	dec    %eax
  80125e:	a3 54 41 80 00       	mov    %eax,0x804154
	ourBlock->size = USER_HEAP_MAX-USER_HEAP_START;
  801263:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801266:	c7 40 0c 00 00 00 20 	movl   $0x20000000,0xc(%eax)
	ourBlock->sva=USER_HEAP_START;
  80126d:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801270:	c7 40 08 00 00 00 80 	movl   $0x80000000,0x8(%eax)
	LIST_INSERT_TAIL(&FreeMemBlocksList, ourBlock);
  801277:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  80127b:	75 14                	jne    801291 <initialize_dyn_block_system+0x18e>
  80127d:	83 ec 04             	sub    $0x4,%esp
  801280:	68 a0 35 80 00       	push   $0x8035a0
  801285:	6a 30                	push   $0x30
  801287:	68 93 35 80 00       	push   $0x803593
  80128c:	e8 dd 19 00 00       	call   802c6e <_panic>
  801291:	8b 15 3c 41 80 00    	mov    0x80413c,%edx
  801297:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80129a:	89 50 04             	mov    %edx,0x4(%eax)
  80129d:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8012a0:	8b 40 04             	mov    0x4(%eax),%eax
  8012a3:	85 c0                	test   %eax,%eax
  8012a5:	74 0c                	je     8012b3 <initialize_dyn_block_system+0x1b0>
  8012a7:	a1 3c 41 80 00       	mov    0x80413c,%eax
  8012ac:	8b 55 dc             	mov    -0x24(%ebp),%edx
  8012af:	89 10                	mov    %edx,(%eax)
  8012b1:	eb 08                	jmp    8012bb <initialize_dyn_block_system+0x1b8>
  8012b3:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8012b6:	a3 38 41 80 00       	mov    %eax,0x804138
  8012bb:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8012be:	a3 3c 41 80 00       	mov    %eax,0x80413c
  8012c3:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8012c6:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8012cc:	a1 44 41 80 00       	mov    0x804144,%eax
  8012d1:	40                   	inc    %eax
  8012d2:	a3 44 41 80 00       	mov    %eax,0x804144
	//[1] Initialize two lists (AllocMemBlocksList & FreeMemBlocksList) [Hint: use LIST_INIT()]
	//[2] Dynamically allocate the array of MemBlockNodes at VA USER_DYN_BLKS_ARRAY
	//	  (remember to set MAX_MEM_BLOCK_CNT with the chosen size of the array)
	//[3] Initialize AvailableMemBlocksList by filling it with the MemBlockNodes
	//[4] Insert a new MemBlock with the heap size into the FreeMemBlocksList
}
  8012d7:	90                   	nop
  8012d8:	c9                   	leave  
  8012d9:	c3                   	ret    

008012da <malloc>:
//=================================
// [2] ALLOCATE SPACE IN USER HEAP:
//=================================

void* malloc(uint32 size)
{
  8012da:	55                   	push   %ebp
  8012db:	89 e5                	mov    %esp,%ebp
  8012dd:	83 ec 18             	sub    $0x18,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  8012e0:	e8 ed fd ff ff       	call   8010d2 <InitializeUHeap>
	if (size == 0) return NULL ;
  8012e5:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8012e9:	75 07                	jne    8012f2 <malloc+0x18>
  8012eb:	b8 00 00 00 00       	mov    $0x0,%eax
  8012f0:	eb 67                	jmp    801359 <malloc+0x7f>

	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] malloc
	// your code is here, remove the panic and write your code
	//panic("malloc() is not implemented yet...!!");

	size = ROUNDUP(size, PAGE_SIZE);
  8012f2:	c7 45 f4 00 10 00 00 	movl   $0x1000,-0xc(%ebp)
  8012f9:	8b 55 08             	mov    0x8(%ebp),%edx
  8012fc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8012ff:	01 d0                	add    %edx,%eax
  801301:	48                   	dec    %eax
  801302:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801305:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801308:	ba 00 00 00 00       	mov    $0x0,%edx
  80130d:	f7 75 f4             	divl   -0xc(%ebp)
  801310:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801313:	29 d0                	sub    %edx,%eax
  801315:	89 45 08             	mov    %eax,0x8(%ebp)
	if(sys_isUHeapPlacementStrategyFIRSTFIT())
  801318:	e8 1a 08 00 00       	call   801b37 <sys_isUHeapPlacementStrategyFIRSTFIT>
  80131d:	85 c0                	test   %eax,%eax
  80131f:	74 33                	je     801354 <malloc+0x7a>
	{
		struct MemBlock * myBlock = alloc_block_FF(size);
  801321:	83 ec 0c             	sub    $0xc,%esp
  801324:	ff 75 08             	pushl  0x8(%ebp)
  801327:	e8 0c 0e 00 00       	call   802138 <alloc_block_FF>
  80132c:	83 c4 10             	add    $0x10,%esp
  80132f:	89 45 ec             	mov    %eax,-0x14(%ebp)
		if(myBlock != NULL)
  801332:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  801336:	74 1c                	je     801354 <malloc+0x7a>
		{
			insert_sorted_allocList(myBlock);
  801338:	83 ec 0c             	sub    $0xc,%esp
  80133b:	ff 75 ec             	pushl  -0x14(%ebp)
  80133e:	e8 07 0c 00 00       	call   801f4a <insert_sorted_allocList>
  801343:	83 c4 10             	add    $0x10,%esp
			uint32 ptr = myBlock->sva;
  801346:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801349:	8b 40 08             	mov    0x8(%eax),%eax
  80134c:	89 45 e8             	mov    %eax,-0x18(%ebp)
			return (void *)ptr;
  80134f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801352:	eb 05                	jmp    801359 <malloc+0x7f>
		}
	}
	return NULL;
  801354:	b8 00 00 00 00       	mov    $0x0,%eax
	//		to the required allocation size (space should be on 4 KB BOUNDARY)
	//	2) if no suitable space found, return NULL
	// 	3) Return pointer containing the virtual address of allocated space,
	//
	//Use sys_isUHeapPlacementStrategyFIRSTFIT()... to check the current strategy
}
  801359:	c9                   	leave  
  80135a:	c3                   	ret    

0080135b <free>:
//	We can use sys_free_user_mem(uint32 virtual_address, uint32 size); which
//		switches to the kernel mode, calls free_user_mem() in
//		"kern/mem/chunk_operations.c", then switch back to the user mode here
//	the free_user_mem function is empty, make sure to implement it.
void free(void* virtual_address)
{
  80135b:	55                   	push   %ebp
  80135c:	89 e5                	mov    %esp,%ebp
  80135e:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] free
	// your code is here, remove the panic and write your code
	//panic("free() is not implemented yet...!!");

	uint32 virtualAddress = (uint32 )(virtual_address);
  801361:	8b 45 08             	mov    0x8(%ebp),%eax
  801364:	89 45 f4             	mov    %eax,-0xc(%ebp)
//	virtualAddress = ROUNDDOWN(virtualAddress, PAGE_SIZE);
	struct MemBlock * myBlock = find_block(&AllocMemBlocksList, virtualAddress);
  801367:	83 ec 08             	sub    $0x8,%esp
  80136a:	ff 75 f4             	pushl  -0xc(%ebp)
  80136d:	68 40 40 80 00       	push   $0x804040
  801372:	e8 5b 0b 00 00       	call   801ed2 <find_block>
  801377:	83 c4 10             	add    $0x10,%esp
  80137a:	89 45 f0             	mov    %eax,-0x10(%ebp)
//	cprintf ("ptr sva at free user side = %x \n", myBlock->sva);
	sys_free_user_mem(virtualAddress, myBlock->size);
  80137d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801380:	8b 40 0c             	mov    0xc(%eax),%eax
  801383:	83 ec 08             	sub    $0x8,%esp
  801386:	50                   	push   %eax
  801387:	ff 75 f4             	pushl  -0xc(%ebp)
  80138a:	e8 a2 03 00 00       	call   801731 <sys_free_user_mem>
  80138f:	83 c4 10             	add    $0x10,%esp
	LIST_REMOVE(&AllocMemBlocksList, myBlock);
  801392:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801396:	75 14                	jne    8013ac <free+0x51>
  801398:	83 ec 04             	sub    $0x4,%esp
  80139b:	68 75 35 80 00       	push   $0x803575
  8013a0:	6a 76                	push   $0x76
  8013a2:	68 93 35 80 00       	push   $0x803593
  8013a7:	e8 c2 18 00 00       	call   802c6e <_panic>
  8013ac:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8013af:	8b 00                	mov    (%eax),%eax
  8013b1:	85 c0                	test   %eax,%eax
  8013b3:	74 10                	je     8013c5 <free+0x6a>
  8013b5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8013b8:	8b 00                	mov    (%eax),%eax
  8013ba:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8013bd:	8b 52 04             	mov    0x4(%edx),%edx
  8013c0:	89 50 04             	mov    %edx,0x4(%eax)
  8013c3:	eb 0b                	jmp    8013d0 <free+0x75>
  8013c5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8013c8:	8b 40 04             	mov    0x4(%eax),%eax
  8013cb:	a3 44 40 80 00       	mov    %eax,0x804044
  8013d0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8013d3:	8b 40 04             	mov    0x4(%eax),%eax
  8013d6:	85 c0                	test   %eax,%eax
  8013d8:	74 0f                	je     8013e9 <free+0x8e>
  8013da:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8013dd:	8b 40 04             	mov    0x4(%eax),%eax
  8013e0:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8013e3:	8b 12                	mov    (%edx),%edx
  8013e5:	89 10                	mov    %edx,(%eax)
  8013e7:	eb 0a                	jmp    8013f3 <free+0x98>
  8013e9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8013ec:	8b 00                	mov    (%eax),%eax
  8013ee:	a3 40 40 80 00       	mov    %eax,0x804040
  8013f3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8013f6:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8013fc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8013ff:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  801406:	a1 4c 40 80 00       	mov    0x80404c,%eax
  80140b:	48                   	dec    %eax
  80140c:	a3 4c 40 80 00       	mov    %eax,0x80404c
	insert_sorted_with_merge_freeList(myBlock);
  801411:	83 ec 0c             	sub    $0xc,%esp
  801414:	ff 75 f0             	pushl  -0x10(%ebp)
  801417:	e8 0b 14 00 00       	call   802827 <insert_sorted_with_merge_freeList>
  80141c:	83 c4 10             	add    $0x10,%esp

	//you should get the size of the given allocation using its address
	//you need to call sys_free_user_mem()
	//refer to the project presentation and documentation for details
}
  80141f:	90                   	nop
  801420:	c9                   	leave  
  801421:	c3                   	ret    

00801422 <smalloc>:

//=================================
// [4] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
  801422:	55                   	push   %ebp
  801423:	89 e5                	mov    %esp,%ebp
  801425:	83 ec 28             	sub    $0x28,%esp
  801428:	8b 45 10             	mov    0x10(%ebp),%eax
  80142b:	88 45 e4             	mov    %al,-0x1c(%ebp)
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  80142e:	e8 9f fc ff ff       	call   8010d2 <InitializeUHeap>
	if (size == 0) return NULL ;
  801433:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801437:	75 0a                	jne    801443 <smalloc+0x21>
  801439:	b8 00 00 00 00       	mov    $0x0,%eax
  80143e:	e9 8d 00 00 00       	jmp    8014d0 <smalloc+0xae>

	//This function should find the space of the required range
	// * ON 4KB BOUNDARY **** //
	//Use sys_isUHeapPlacementStrategyFIRSTFIT() to check the current strategy

	size = ROUNDUP(size, PAGE_SIZE);
  801443:	c7 45 f4 00 10 00 00 	movl   $0x1000,-0xc(%ebp)
  80144a:	8b 55 0c             	mov    0xc(%ebp),%edx
  80144d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801450:	01 d0                	add    %edx,%eax
  801452:	48                   	dec    %eax
  801453:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801456:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801459:	ba 00 00 00 00       	mov    $0x0,%edx
  80145e:	f7 75 f4             	divl   -0xc(%ebp)
  801461:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801464:	29 d0                	sub    %edx,%eax
  801466:	89 45 0c             	mov    %eax,0xc(%ebp)
		if(sys_isUHeapPlacementStrategyFIRSTFIT())
  801469:	e8 c9 06 00 00       	call   801b37 <sys_isUHeapPlacementStrategyFIRSTFIT>
  80146e:	85 c0                	test   %eax,%eax
  801470:	74 59                	je     8014cb <smalloc+0xa9>
		{
			struct MemBlock * v1=NULL;
  801472:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
			v1= alloc_block_FF(size);
  801479:	83 ec 0c             	sub    $0xc,%esp
  80147c:	ff 75 0c             	pushl  0xc(%ebp)
  80147f:	e8 b4 0c 00 00       	call   802138 <alloc_block_FF>
  801484:	83 c4 10             	add    $0x10,%esp
  801487:	89 45 ec             	mov    %eax,-0x14(%ebp)
			if(v1==NULL)
  80148a:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  80148e:	75 07                	jne    801497 <smalloc+0x75>
			{
				return NULL;
  801490:	b8 00 00 00 00       	mov    $0x0,%eax
  801495:	eb 39                	jmp    8014d0 <smalloc+0xae>
			}
			else
			{
				int ret=sys_createSharedObject(sharedVarName,  size,  isWritable,(void*)v1->sva);
  801497:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80149a:	8b 40 08             	mov    0x8(%eax),%eax
  80149d:	89 c2                	mov    %eax,%edx
  80149f:	0f b6 45 e4          	movzbl -0x1c(%ebp),%eax
  8014a3:	52                   	push   %edx
  8014a4:	50                   	push   %eax
  8014a5:	ff 75 0c             	pushl  0xc(%ebp)
  8014a8:	ff 75 08             	pushl  0x8(%ebp)
  8014ab:	e8 0c 04 00 00       	call   8018bc <sys_createSharedObject>
  8014b0:	83 c4 10             	add    $0x10,%esp
  8014b3:	89 45 e8             	mov    %eax,-0x18(%ebp)
				if(ret>=0)
  8014b6:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8014ba:	78 08                	js     8014c4 <smalloc+0xa2>
				{
					return (void*)v1->sva;
  8014bc:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8014bf:	8b 40 08             	mov    0x8(%eax),%eax
  8014c2:	eb 0c                	jmp    8014d0 <smalloc+0xae>
				}
				else
				{
					return NULL;
  8014c4:	b8 00 00 00 00       	mov    $0x0,%eax
  8014c9:	eb 05                	jmp    8014d0 <smalloc+0xae>
				}
			}

		}
		return NULL;
  8014cb:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8014d0:	c9                   	leave  
  8014d1:	c3                   	ret    

008014d2 <sget>:

//========================================
// [5] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  8014d2:	55                   	push   %ebp
  8014d3:	89 e5                	mov    %esp,%ebp
  8014d5:	83 ec 18             	sub    $0x18,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  8014d8:	e8 f5 fb ff ff       	call   8010d2 <InitializeUHeap>

	//This function should find the space for sharing the variable
	// *** ON 4KB BOUNDARY ******** //

	//Use sys_isUHeapPlacementStrategyFIRSTFIT() to check the current strategy
	int ret=sys_getSizeOfSharedObject(ownerEnvID,sharedVarName);
  8014dd:	83 ec 08             	sub    $0x8,%esp
  8014e0:	ff 75 0c             	pushl  0xc(%ebp)
  8014e3:	ff 75 08             	pushl  0x8(%ebp)
  8014e6:	e8 fb 03 00 00       	call   8018e6 <sys_getSizeOfSharedObject>
  8014eb:	83 c4 10             	add    $0x10,%esp
  8014ee:	89 45 f4             	mov    %eax,-0xc(%ebp)
	if(ret==0)
  8014f1:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8014f5:	75 07                	jne    8014fe <sget+0x2c>
	{
		return NULL;
  8014f7:	b8 00 00 00 00       	mov    $0x0,%eax
  8014fc:	eb 64                	jmp    801562 <sget+0x90>
	}
	if(sys_isUHeapPlacementStrategyFIRSTFIT())
  8014fe:	e8 34 06 00 00       	call   801b37 <sys_isUHeapPlacementStrategyFIRSTFIT>
  801503:	85 c0                	test   %eax,%eax
  801505:	74 56                	je     80155d <sget+0x8b>
	{
		struct MemBlock * v1=NULL;
  801507:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
		v1= alloc_block_FF(ret);
  80150e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801511:	83 ec 0c             	sub    $0xc,%esp
  801514:	50                   	push   %eax
  801515:	e8 1e 0c 00 00       	call   802138 <alloc_block_FF>
  80151a:	83 c4 10             	add    $0x10,%esp
  80151d:	89 45 f0             	mov    %eax,-0x10(%ebp)
		if(v1==NULL)
  801520:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801524:	75 07                	jne    80152d <sget+0x5b>
		{
		return NULL;
  801526:	b8 00 00 00 00       	mov    $0x0,%eax
  80152b:	eb 35                	jmp    801562 <sget+0x90>
	    }
		else
		{
			int ret1=sys_getSharedObject(ownerEnvID,sharedVarName,(void*)v1->sva);
  80152d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801530:	8b 40 08             	mov    0x8(%eax),%eax
  801533:	83 ec 04             	sub    $0x4,%esp
  801536:	50                   	push   %eax
  801537:	ff 75 0c             	pushl  0xc(%ebp)
  80153a:	ff 75 08             	pushl  0x8(%ebp)
  80153d:	e8 c1 03 00 00       	call   801903 <sys_getSharedObject>
  801542:	83 c4 10             	add    $0x10,%esp
  801545:	89 45 ec             	mov    %eax,-0x14(%ebp)
			if(ret1>=0)
  801548:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  80154c:	78 08                	js     801556 <sget+0x84>
			{
				return (void*)v1->sva;
  80154e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801551:	8b 40 08             	mov    0x8(%eax),%eax
  801554:	eb 0c                	jmp    801562 <sget+0x90>
			}
			else
			{
				return NULL;
  801556:	b8 00 00 00 00       	mov    $0x0,%eax
  80155b:	eb 05                	jmp    801562 <sget+0x90>
			}
		}
	}
  return NULL;
  80155d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801562:	c9                   	leave  
  801563:	c3                   	ret    

00801564 <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  801564:	55                   	push   %ebp
  801565:	89 e5                	mov    %esp,%ebp
  801567:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  80156a:	e8 63 fb ff ff       	call   8010d2 <InitializeUHeap>
	//==============================================================
	// [USER HEAP - USER SIDE] realloc
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  80156f:	83 ec 04             	sub    $0x4,%esp
  801572:	68 c4 35 80 00       	push   $0x8035c4
  801577:	68 0e 01 00 00       	push   $0x10e
  80157c:	68 93 35 80 00       	push   $0x803593
  801581:	e8 e8 16 00 00       	call   802c6e <_panic>

00801586 <sfree>:
//	use sys_freeSharedObject(...); which switches to the kernel mode,
//	calls freeSharedObject(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the freeSharedObject() function is empty, make sure to implement it.

void sfree(void* virtual_address)
{
  801586:	55                   	push   %ebp
  801587:	89 e5                	mov    %esp,%ebp
  801589:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS3 - BONUS] [SHARING - USER SIDE] sfree()

	// Write your code here, remove the panic and write your code
	panic("sfree() is not implemented yet...!!");
  80158c:	83 ec 04             	sub    $0x4,%esp
  80158f:	68 ec 35 80 00       	push   $0x8035ec
  801594:	68 22 01 00 00       	push   $0x122
  801599:	68 93 35 80 00       	push   $0x803593
  80159e:	e8 cb 16 00 00       	call   802c6e <_panic>

008015a3 <expand>:

//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//
void expand(uint32 newSize)
{
  8015a3:	55                   	push   %ebp
  8015a4:	89 e5                	mov    %esp,%ebp
  8015a6:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  8015a9:	83 ec 04             	sub    $0x4,%esp
  8015ac:	68 10 36 80 00       	push   $0x803610
  8015b1:	68 2d 01 00 00       	push   $0x12d
  8015b6:	68 93 35 80 00       	push   $0x803593
  8015bb:	e8 ae 16 00 00       	call   802c6e <_panic>

008015c0 <shrink>:

}
void shrink(uint32 newSize)
{
  8015c0:	55                   	push   %ebp
  8015c1:	89 e5                	mov    %esp,%ebp
  8015c3:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  8015c6:	83 ec 04             	sub    $0x4,%esp
  8015c9:	68 10 36 80 00       	push   $0x803610
  8015ce:	68 32 01 00 00       	push   $0x132
  8015d3:	68 93 35 80 00       	push   $0x803593
  8015d8:	e8 91 16 00 00       	call   802c6e <_panic>

008015dd <freeHeap>:

}
void freeHeap(void* virtual_address)
{
  8015dd:	55                   	push   %ebp
  8015de:	89 e5                	mov    %esp,%ebp
  8015e0:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  8015e3:	83 ec 04             	sub    $0x4,%esp
  8015e6:	68 10 36 80 00       	push   $0x803610
  8015eb:	68 37 01 00 00       	push   $0x137
  8015f0:	68 93 35 80 00       	push   $0x803593
  8015f5:	e8 74 16 00 00       	call   802c6e <_panic>

008015fa <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  8015fa:	55                   	push   %ebp
  8015fb:	89 e5                	mov    %esp,%ebp
  8015fd:	57                   	push   %edi
  8015fe:	56                   	push   %esi
  8015ff:	53                   	push   %ebx
  801600:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801603:	8b 45 08             	mov    0x8(%ebp),%eax
  801606:	8b 55 0c             	mov    0xc(%ebp),%edx
  801609:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80160c:	8b 5d 14             	mov    0x14(%ebp),%ebx
  80160f:	8b 7d 18             	mov    0x18(%ebp),%edi
  801612:	8b 75 1c             	mov    0x1c(%ebp),%esi
  801615:	cd 30                	int    $0x30
  801617:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  80161a:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  80161d:	83 c4 10             	add    $0x10,%esp
  801620:	5b                   	pop    %ebx
  801621:	5e                   	pop    %esi
  801622:	5f                   	pop    %edi
  801623:	5d                   	pop    %ebp
  801624:	c3                   	ret    

00801625 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  801625:	55                   	push   %ebp
  801626:	89 e5                	mov    %esp,%ebp
  801628:	83 ec 04             	sub    $0x4,%esp
  80162b:	8b 45 10             	mov    0x10(%ebp),%eax
  80162e:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  801631:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801635:	8b 45 08             	mov    0x8(%ebp),%eax
  801638:	6a 00                	push   $0x0
  80163a:	6a 00                	push   $0x0
  80163c:	52                   	push   %edx
  80163d:	ff 75 0c             	pushl  0xc(%ebp)
  801640:	50                   	push   %eax
  801641:	6a 00                	push   $0x0
  801643:	e8 b2 ff ff ff       	call   8015fa <syscall>
  801648:	83 c4 18             	add    $0x18,%esp
}
  80164b:	90                   	nop
  80164c:	c9                   	leave  
  80164d:	c3                   	ret    

0080164e <sys_cgetc>:

int
sys_cgetc(void)
{
  80164e:	55                   	push   %ebp
  80164f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  801651:	6a 00                	push   $0x0
  801653:	6a 00                	push   $0x0
  801655:	6a 00                	push   $0x0
  801657:	6a 00                	push   $0x0
  801659:	6a 00                	push   $0x0
  80165b:	6a 01                	push   $0x1
  80165d:	e8 98 ff ff ff       	call   8015fa <syscall>
  801662:	83 c4 18             	add    $0x18,%esp
}
  801665:	c9                   	leave  
  801666:	c3                   	ret    

00801667 <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  801667:	55                   	push   %ebp
  801668:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  80166a:	8b 55 0c             	mov    0xc(%ebp),%edx
  80166d:	8b 45 08             	mov    0x8(%ebp),%eax
  801670:	6a 00                	push   $0x0
  801672:	6a 00                	push   $0x0
  801674:	6a 00                	push   $0x0
  801676:	52                   	push   %edx
  801677:	50                   	push   %eax
  801678:	6a 05                	push   $0x5
  80167a:	e8 7b ff ff ff       	call   8015fa <syscall>
  80167f:	83 c4 18             	add    $0x18,%esp
}
  801682:	c9                   	leave  
  801683:	c3                   	ret    

00801684 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  801684:	55                   	push   %ebp
  801685:	89 e5                	mov    %esp,%ebp
  801687:	56                   	push   %esi
  801688:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  801689:	8b 75 18             	mov    0x18(%ebp),%esi
  80168c:	8b 5d 14             	mov    0x14(%ebp),%ebx
  80168f:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801692:	8b 55 0c             	mov    0xc(%ebp),%edx
  801695:	8b 45 08             	mov    0x8(%ebp),%eax
  801698:	56                   	push   %esi
  801699:	53                   	push   %ebx
  80169a:	51                   	push   %ecx
  80169b:	52                   	push   %edx
  80169c:	50                   	push   %eax
  80169d:	6a 06                	push   $0x6
  80169f:	e8 56 ff ff ff       	call   8015fa <syscall>
  8016a4:	83 c4 18             	add    $0x18,%esp
}
  8016a7:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8016aa:	5b                   	pop    %ebx
  8016ab:	5e                   	pop    %esi
  8016ac:	5d                   	pop    %ebp
  8016ad:	c3                   	ret    

008016ae <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  8016ae:	55                   	push   %ebp
  8016af:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  8016b1:	8b 55 0c             	mov    0xc(%ebp),%edx
  8016b4:	8b 45 08             	mov    0x8(%ebp),%eax
  8016b7:	6a 00                	push   $0x0
  8016b9:	6a 00                	push   $0x0
  8016bb:	6a 00                	push   $0x0
  8016bd:	52                   	push   %edx
  8016be:	50                   	push   %eax
  8016bf:	6a 07                	push   $0x7
  8016c1:	e8 34 ff ff ff       	call   8015fa <syscall>
  8016c6:	83 c4 18             	add    $0x18,%esp
}
  8016c9:	c9                   	leave  
  8016ca:	c3                   	ret    

008016cb <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  8016cb:	55                   	push   %ebp
  8016cc:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  8016ce:	6a 00                	push   $0x0
  8016d0:	6a 00                	push   $0x0
  8016d2:	6a 00                	push   $0x0
  8016d4:	ff 75 0c             	pushl  0xc(%ebp)
  8016d7:	ff 75 08             	pushl  0x8(%ebp)
  8016da:	6a 08                	push   $0x8
  8016dc:	e8 19 ff ff ff       	call   8015fa <syscall>
  8016e1:	83 c4 18             	add    $0x18,%esp
}
  8016e4:	c9                   	leave  
  8016e5:	c3                   	ret    

008016e6 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  8016e6:	55                   	push   %ebp
  8016e7:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  8016e9:	6a 00                	push   $0x0
  8016eb:	6a 00                	push   $0x0
  8016ed:	6a 00                	push   $0x0
  8016ef:	6a 00                	push   $0x0
  8016f1:	6a 00                	push   $0x0
  8016f3:	6a 09                	push   $0x9
  8016f5:	e8 00 ff ff ff       	call   8015fa <syscall>
  8016fa:	83 c4 18             	add    $0x18,%esp
}
  8016fd:	c9                   	leave  
  8016fe:	c3                   	ret    

008016ff <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  8016ff:	55                   	push   %ebp
  801700:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  801702:	6a 00                	push   $0x0
  801704:	6a 00                	push   $0x0
  801706:	6a 00                	push   $0x0
  801708:	6a 00                	push   $0x0
  80170a:	6a 00                	push   $0x0
  80170c:	6a 0a                	push   $0xa
  80170e:	e8 e7 fe ff ff       	call   8015fa <syscall>
  801713:	83 c4 18             	add    $0x18,%esp
}
  801716:	c9                   	leave  
  801717:	c3                   	ret    

00801718 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  801718:	55                   	push   %ebp
  801719:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  80171b:	6a 00                	push   $0x0
  80171d:	6a 00                	push   $0x0
  80171f:	6a 00                	push   $0x0
  801721:	6a 00                	push   $0x0
  801723:	6a 00                	push   $0x0
  801725:	6a 0b                	push   $0xb
  801727:	e8 ce fe ff ff       	call   8015fa <syscall>
  80172c:	83 c4 18             	add    $0x18,%esp
}
  80172f:	c9                   	leave  
  801730:	c3                   	ret    

00801731 <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  801731:	55                   	push   %ebp
  801732:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  801734:	6a 00                	push   $0x0
  801736:	6a 00                	push   $0x0
  801738:	6a 00                	push   $0x0
  80173a:	ff 75 0c             	pushl  0xc(%ebp)
  80173d:	ff 75 08             	pushl  0x8(%ebp)
  801740:	6a 0f                	push   $0xf
  801742:	e8 b3 fe ff ff       	call   8015fa <syscall>
  801747:	83 c4 18             	add    $0x18,%esp
	return;
  80174a:	90                   	nop
}
  80174b:	c9                   	leave  
  80174c:	c3                   	ret    

0080174d <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  80174d:	55                   	push   %ebp
  80174e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  801750:	6a 00                	push   $0x0
  801752:	6a 00                	push   $0x0
  801754:	6a 00                	push   $0x0
  801756:	ff 75 0c             	pushl  0xc(%ebp)
  801759:	ff 75 08             	pushl  0x8(%ebp)
  80175c:	6a 10                	push   $0x10
  80175e:	e8 97 fe ff ff       	call   8015fa <syscall>
  801763:	83 c4 18             	add    $0x18,%esp
	return ;
  801766:	90                   	nop
}
  801767:	c9                   	leave  
  801768:	c3                   	ret    

00801769 <sys_allocate_chunk>:

void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  801769:	55                   	push   %ebp
  80176a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  80176c:	6a 00                	push   $0x0
  80176e:	6a 00                	push   $0x0
  801770:	ff 75 10             	pushl  0x10(%ebp)
  801773:	ff 75 0c             	pushl  0xc(%ebp)
  801776:	ff 75 08             	pushl  0x8(%ebp)
  801779:	6a 11                	push   $0x11
  80177b:	e8 7a fe ff ff       	call   8015fa <syscall>
  801780:	83 c4 18             	add    $0x18,%esp
	return ;
  801783:	90                   	nop
}
  801784:	c9                   	leave  
  801785:	c3                   	ret    

00801786 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  801786:	55                   	push   %ebp
  801787:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  801789:	6a 00                	push   $0x0
  80178b:	6a 00                	push   $0x0
  80178d:	6a 00                	push   $0x0
  80178f:	6a 00                	push   $0x0
  801791:	6a 00                	push   $0x0
  801793:	6a 0c                	push   $0xc
  801795:	e8 60 fe ff ff       	call   8015fa <syscall>
  80179a:	83 c4 18             	add    $0x18,%esp
}
  80179d:	c9                   	leave  
  80179e:	c3                   	ret    

0080179f <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  80179f:	55                   	push   %ebp
  8017a0:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  8017a2:	6a 00                	push   $0x0
  8017a4:	6a 00                	push   $0x0
  8017a6:	6a 00                	push   $0x0
  8017a8:	6a 00                	push   $0x0
  8017aa:	ff 75 08             	pushl  0x8(%ebp)
  8017ad:	6a 0d                	push   $0xd
  8017af:	e8 46 fe ff ff       	call   8015fa <syscall>
  8017b4:	83 c4 18             	add    $0x18,%esp
}
  8017b7:	c9                   	leave  
  8017b8:	c3                   	ret    

008017b9 <sys_scarce_memory>:

void sys_scarce_memory()
{
  8017b9:	55                   	push   %ebp
  8017ba:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  8017bc:	6a 00                	push   $0x0
  8017be:	6a 00                	push   $0x0
  8017c0:	6a 00                	push   $0x0
  8017c2:	6a 00                	push   $0x0
  8017c4:	6a 00                	push   $0x0
  8017c6:	6a 0e                	push   $0xe
  8017c8:	e8 2d fe ff ff       	call   8015fa <syscall>
  8017cd:	83 c4 18             	add    $0x18,%esp
}
  8017d0:	90                   	nop
  8017d1:	c9                   	leave  
  8017d2:	c3                   	ret    

008017d3 <sys_disable_interrupt>:

//NEW !! 2012...
void
sys_disable_interrupt()
{
  8017d3:	55                   	push   %ebp
  8017d4:	89 e5                	mov    %esp,%ebp
	syscall(SYS_disableINTR,0, 0, 0, 0, 0);
  8017d6:	6a 00                	push   $0x0
  8017d8:	6a 00                	push   $0x0
  8017da:	6a 00                	push   $0x0
  8017dc:	6a 00                	push   $0x0
  8017de:	6a 00                	push   $0x0
  8017e0:	6a 13                	push   $0x13
  8017e2:	e8 13 fe ff ff       	call   8015fa <syscall>
  8017e7:	83 c4 18             	add    $0x18,%esp
}
  8017ea:	90                   	nop
  8017eb:	c9                   	leave  
  8017ec:	c3                   	ret    

008017ed <sys_enable_interrupt>:


void
sys_enable_interrupt()
{
  8017ed:	55                   	push   %ebp
  8017ee:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enableINTR,0, 0, 0, 0, 0);
  8017f0:	6a 00                	push   $0x0
  8017f2:	6a 00                	push   $0x0
  8017f4:	6a 00                	push   $0x0
  8017f6:	6a 00                	push   $0x0
  8017f8:	6a 00                	push   $0x0
  8017fa:	6a 14                	push   $0x14
  8017fc:	e8 f9 fd ff ff       	call   8015fa <syscall>
  801801:	83 c4 18             	add    $0x18,%esp
}
  801804:	90                   	nop
  801805:	c9                   	leave  
  801806:	c3                   	ret    

00801807 <sys_cputc>:


void
sys_cputc(const char c)
{
  801807:	55                   	push   %ebp
  801808:	89 e5                	mov    %esp,%ebp
  80180a:	83 ec 04             	sub    $0x4,%esp
  80180d:	8b 45 08             	mov    0x8(%ebp),%eax
  801810:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  801813:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801817:	6a 00                	push   $0x0
  801819:	6a 00                	push   $0x0
  80181b:	6a 00                	push   $0x0
  80181d:	6a 00                	push   $0x0
  80181f:	50                   	push   %eax
  801820:	6a 15                	push   $0x15
  801822:	e8 d3 fd ff ff       	call   8015fa <syscall>
  801827:	83 c4 18             	add    $0x18,%esp
}
  80182a:	90                   	nop
  80182b:	c9                   	leave  
  80182c:	c3                   	ret    

0080182d <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  80182d:	55                   	push   %ebp
  80182e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  801830:	6a 00                	push   $0x0
  801832:	6a 00                	push   $0x0
  801834:	6a 00                	push   $0x0
  801836:	6a 00                	push   $0x0
  801838:	6a 00                	push   $0x0
  80183a:	6a 16                	push   $0x16
  80183c:	e8 b9 fd ff ff       	call   8015fa <syscall>
  801841:	83 c4 18             	add    $0x18,%esp
}
  801844:	90                   	nop
  801845:	c9                   	leave  
  801846:	c3                   	ret    

00801847 <sys_createSemaphore>:

int
sys_createSemaphore(char* semaphoreName, uint32 initialValue)
{
  801847:	55                   	push   %ebp
  801848:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_semaphore,(uint32)semaphoreName, (uint32)initialValue, 0, 0, 0);
  80184a:	8b 45 08             	mov    0x8(%ebp),%eax
  80184d:	6a 00                	push   $0x0
  80184f:	6a 00                	push   $0x0
  801851:	6a 00                	push   $0x0
  801853:	ff 75 0c             	pushl  0xc(%ebp)
  801856:	50                   	push   %eax
  801857:	6a 17                	push   $0x17
  801859:	e8 9c fd ff ff       	call   8015fa <syscall>
  80185e:	83 c4 18             	add    $0x18,%esp
}
  801861:	c9                   	leave  
  801862:	c3                   	ret    

00801863 <sys_getSemaphoreValue>:

int
sys_getSemaphoreValue(int32 ownerEnvID, char* semaphoreName)
{
  801863:	55                   	push   %ebp
  801864:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_semaphore_value,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801866:	8b 55 0c             	mov    0xc(%ebp),%edx
  801869:	8b 45 08             	mov    0x8(%ebp),%eax
  80186c:	6a 00                	push   $0x0
  80186e:	6a 00                	push   $0x0
  801870:	6a 00                	push   $0x0
  801872:	52                   	push   %edx
  801873:	50                   	push   %eax
  801874:	6a 1a                	push   $0x1a
  801876:	e8 7f fd ff ff       	call   8015fa <syscall>
  80187b:	83 c4 18             	add    $0x18,%esp
}
  80187e:	c9                   	leave  
  80187f:	c3                   	ret    

00801880 <sys_waitSemaphore>:

void
sys_waitSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801880:	55                   	push   %ebp
  801881:	89 e5                	mov    %esp,%ebp
	syscall(SYS_wait_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801883:	8b 55 0c             	mov    0xc(%ebp),%edx
  801886:	8b 45 08             	mov    0x8(%ebp),%eax
  801889:	6a 00                	push   $0x0
  80188b:	6a 00                	push   $0x0
  80188d:	6a 00                	push   $0x0
  80188f:	52                   	push   %edx
  801890:	50                   	push   %eax
  801891:	6a 18                	push   $0x18
  801893:	e8 62 fd ff ff       	call   8015fa <syscall>
  801898:	83 c4 18             	add    $0x18,%esp
}
  80189b:	90                   	nop
  80189c:	c9                   	leave  
  80189d:	c3                   	ret    

0080189e <sys_signalSemaphore>:

void
sys_signalSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  80189e:	55                   	push   %ebp
  80189f:	89 e5                	mov    %esp,%ebp
	syscall(SYS_signal_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  8018a1:	8b 55 0c             	mov    0xc(%ebp),%edx
  8018a4:	8b 45 08             	mov    0x8(%ebp),%eax
  8018a7:	6a 00                	push   $0x0
  8018a9:	6a 00                	push   $0x0
  8018ab:	6a 00                	push   $0x0
  8018ad:	52                   	push   %edx
  8018ae:	50                   	push   %eax
  8018af:	6a 19                	push   $0x19
  8018b1:	e8 44 fd ff ff       	call   8015fa <syscall>
  8018b6:	83 c4 18             	add    $0x18,%esp
}
  8018b9:	90                   	nop
  8018ba:	c9                   	leave  
  8018bb:	c3                   	ret    

008018bc <sys_createSharedObject>:

int
sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  8018bc:	55                   	push   %ebp
  8018bd:	89 e5                	mov    %esp,%ebp
  8018bf:	83 ec 04             	sub    $0x4,%esp
  8018c2:	8b 45 10             	mov    0x10(%ebp),%eax
  8018c5:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  8018c8:	8b 4d 14             	mov    0x14(%ebp),%ecx
  8018cb:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  8018cf:	8b 45 08             	mov    0x8(%ebp),%eax
  8018d2:	6a 00                	push   $0x0
  8018d4:	51                   	push   %ecx
  8018d5:	52                   	push   %edx
  8018d6:	ff 75 0c             	pushl  0xc(%ebp)
  8018d9:	50                   	push   %eax
  8018da:	6a 1b                	push   $0x1b
  8018dc:	e8 19 fd ff ff       	call   8015fa <syscall>
  8018e1:	83 c4 18             	add    $0x18,%esp
}
  8018e4:	c9                   	leave  
  8018e5:	c3                   	ret    

008018e6 <sys_getSizeOfSharedObject>:

//2017:
int
sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  8018e6:	55                   	push   %ebp
  8018e7:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  8018e9:	8b 55 0c             	mov    0xc(%ebp),%edx
  8018ec:	8b 45 08             	mov    0x8(%ebp),%eax
  8018ef:	6a 00                	push   $0x0
  8018f1:	6a 00                	push   $0x0
  8018f3:	6a 00                	push   $0x0
  8018f5:	52                   	push   %edx
  8018f6:	50                   	push   %eax
  8018f7:	6a 1c                	push   $0x1c
  8018f9:	e8 fc fc ff ff       	call   8015fa <syscall>
  8018fe:	83 c4 18             	add    $0x18,%esp
}
  801901:	c9                   	leave  
  801902:	c3                   	ret    

00801903 <sys_getSharedObject>:
//==========

int
sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  801903:	55                   	push   %ebp
  801904:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  801906:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801909:	8b 55 0c             	mov    0xc(%ebp),%edx
  80190c:	8b 45 08             	mov    0x8(%ebp),%eax
  80190f:	6a 00                	push   $0x0
  801911:	6a 00                	push   $0x0
  801913:	51                   	push   %ecx
  801914:	52                   	push   %edx
  801915:	50                   	push   %eax
  801916:	6a 1d                	push   $0x1d
  801918:	e8 dd fc ff ff       	call   8015fa <syscall>
  80191d:	83 c4 18             	add    $0x18,%esp
}
  801920:	c9                   	leave  
  801921:	c3                   	ret    

00801922 <sys_freeSharedObject>:

int
sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  801922:	55                   	push   %ebp
  801923:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  801925:	8b 55 0c             	mov    0xc(%ebp),%edx
  801928:	8b 45 08             	mov    0x8(%ebp),%eax
  80192b:	6a 00                	push   $0x0
  80192d:	6a 00                	push   $0x0
  80192f:	6a 00                	push   $0x0
  801931:	52                   	push   %edx
  801932:	50                   	push   %eax
  801933:	6a 1e                	push   $0x1e
  801935:	e8 c0 fc ff ff       	call   8015fa <syscall>
  80193a:	83 c4 18             	add    $0x18,%esp
}
  80193d:	c9                   	leave  
  80193e:	c3                   	ret    

0080193f <sys_getMaxShares>:

uint32 	sys_getMaxShares()
{
  80193f:	55                   	push   %ebp
  801940:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_max_shares,0, 0, 0, 0, 0);
  801942:	6a 00                	push   $0x0
  801944:	6a 00                	push   $0x0
  801946:	6a 00                	push   $0x0
  801948:	6a 00                	push   $0x0
  80194a:	6a 00                	push   $0x0
  80194c:	6a 1f                	push   $0x1f
  80194e:	e8 a7 fc ff ff       	call   8015fa <syscall>
  801953:	83 c4 18             	add    $0x18,%esp
}
  801956:	c9                   	leave  
  801957:	c3                   	ret    

00801958 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  801958:	55                   	push   %ebp
  801959:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  80195b:	8b 45 08             	mov    0x8(%ebp),%eax
  80195e:	6a 00                	push   $0x0
  801960:	ff 75 14             	pushl  0x14(%ebp)
  801963:	ff 75 10             	pushl  0x10(%ebp)
  801966:	ff 75 0c             	pushl  0xc(%ebp)
  801969:	50                   	push   %eax
  80196a:	6a 20                	push   $0x20
  80196c:	e8 89 fc ff ff       	call   8015fa <syscall>
  801971:	83 c4 18             	add    $0x18,%esp
}
  801974:	c9                   	leave  
  801975:	c3                   	ret    

00801976 <sys_run_env>:

void
sys_run_env(int32 envId)
{
  801976:	55                   	push   %ebp
  801977:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  801979:	8b 45 08             	mov    0x8(%ebp),%eax
  80197c:	6a 00                	push   $0x0
  80197e:	6a 00                	push   $0x0
  801980:	6a 00                	push   $0x0
  801982:	6a 00                	push   $0x0
  801984:	50                   	push   %eax
  801985:	6a 21                	push   $0x21
  801987:	e8 6e fc ff ff       	call   8015fa <syscall>
  80198c:	83 c4 18             	add    $0x18,%esp
}
  80198f:	90                   	nop
  801990:	c9                   	leave  
  801991:	c3                   	ret    

00801992 <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  801992:	55                   	push   %ebp
  801993:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  801995:	8b 45 08             	mov    0x8(%ebp),%eax
  801998:	6a 00                	push   $0x0
  80199a:	6a 00                	push   $0x0
  80199c:	6a 00                	push   $0x0
  80199e:	6a 00                	push   $0x0
  8019a0:	50                   	push   %eax
  8019a1:	6a 22                	push   $0x22
  8019a3:	e8 52 fc ff ff       	call   8015fa <syscall>
  8019a8:	83 c4 18             	add    $0x18,%esp
}
  8019ab:	c9                   	leave  
  8019ac:	c3                   	ret    

008019ad <sys_getenvid>:

int32 sys_getenvid(void)
{
  8019ad:	55                   	push   %ebp
  8019ae:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  8019b0:	6a 00                	push   $0x0
  8019b2:	6a 00                	push   $0x0
  8019b4:	6a 00                	push   $0x0
  8019b6:	6a 00                	push   $0x0
  8019b8:	6a 00                	push   $0x0
  8019ba:	6a 02                	push   $0x2
  8019bc:	e8 39 fc ff ff       	call   8015fa <syscall>
  8019c1:	83 c4 18             	add    $0x18,%esp
}
  8019c4:	c9                   	leave  
  8019c5:	c3                   	ret    

008019c6 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  8019c6:	55                   	push   %ebp
  8019c7:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  8019c9:	6a 00                	push   $0x0
  8019cb:	6a 00                	push   $0x0
  8019cd:	6a 00                	push   $0x0
  8019cf:	6a 00                	push   $0x0
  8019d1:	6a 00                	push   $0x0
  8019d3:	6a 03                	push   $0x3
  8019d5:	e8 20 fc ff ff       	call   8015fa <syscall>
  8019da:	83 c4 18             	add    $0x18,%esp
}
  8019dd:	c9                   	leave  
  8019de:	c3                   	ret    

008019df <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  8019df:	55                   	push   %ebp
  8019e0:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  8019e2:	6a 00                	push   $0x0
  8019e4:	6a 00                	push   $0x0
  8019e6:	6a 00                	push   $0x0
  8019e8:	6a 00                	push   $0x0
  8019ea:	6a 00                	push   $0x0
  8019ec:	6a 04                	push   $0x4
  8019ee:	e8 07 fc ff ff       	call   8015fa <syscall>
  8019f3:	83 c4 18             	add    $0x18,%esp
}
  8019f6:	c9                   	leave  
  8019f7:	c3                   	ret    

008019f8 <sys_exit_env>:


void sys_exit_env(void)
{
  8019f8:	55                   	push   %ebp
  8019f9:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  8019fb:	6a 00                	push   $0x0
  8019fd:	6a 00                	push   $0x0
  8019ff:	6a 00                	push   $0x0
  801a01:	6a 00                	push   $0x0
  801a03:	6a 00                	push   $0x0
  801a05:	6a 23                	push   $0x23
  801a07:	e8 ee fb ff ff       	call   8015fa <syscall>
  801a0c:	83 c4 18             	add    $0x18,%esp
}
  801a0f:	90                   	nop
  801a10:	c9                   	leave  
  801a11:	c3                   	ret    

00801a12 <sys_get_virtual_time>:


struct uint64
sys_get_virtual_time()
{
  801a12:	55                   	push   %ebp
  801a13:	89 e5                	mov    %esp,%ebp
  801a15:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  801a18:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801a1b:	8d 50 04             	lea    0x4(%eax),%edx
  801a1e:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801a21:	6a 00                	push   $0x0
  801a23:	6a 00                	push   $0x0
  801a25:	6a 00                	push   $0x0
  801a27:	52                   	push   %edx
  801a28:	50                   	push   %eax
  801a29:	6a 24                	push   $0x24
  801a2b:	e8 ca fb ff ff       	call   8015fa <syscall>
  801a30:	83 c4 18             	add    $0x18,%esp
	return result;
  801a33:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801a36:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801a39:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801a3c:	89 01                	mov    %eax,(%ecx)
  801a3e:	89 51 04             	mov    %edx,0x4(%ecx)
}
  801a41:	8b 45 08             	mov    0x8(%ebp),%eax
  801a44:	c9                   	leave  
  801a45:	c2 04 00             	ret    $0x4

00801a48 <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  801a48:	55                   	push   %ebp
  801a49:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  801a4b:	6a 00                	push   $0x0
  801a4d:	6a 00                	push   $0x0
  801a4f:	ff 75 10             	pushl  0x10(%ebp)
  801a52:	ff 75 0c             	pushl  0xc(%ebp)
  801a55:	ff 75 08             	pushl  0x8(%ebp)
  801a58:	6a 12                	push   $0x12
  801a5a:	e8 9b fb ff ff       	call   8015fa <syscall>
  801a5f:	83 c4 18             	add    $0x18,%esp
	return ;
  801a62:	90                   	nop
}
  801a63:	c9                   	leave  
  801a64:	c3                   	ret    

00801a65 <sys_rcr2>:
uint32 sys_rcr2()
{
  801a65:	55                   	push   %ebp
  801a66:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  801a68:	6a 00                	push   $0x0
  801a6a:	6a 00                	push   $0x0
  801a6c:	6a 00                	push   $0x0
  801a6e:	6a 00                	push   $0x0
  801a70:	6a 00                	push   $0x0
  801a72:	6a 25                	push   $0x25
  801a74:	e8 81 fb ff ff       	call   8015fa <syscall>
  801a79:	83 c4 18             	add    $0x18,%esp
}
  801a7c:	c9                   	leave  
  801a7d:	c3                   	ret    

00801a7e <sys_bypassPageFault>:
void sys_bypassPageFault(uint8 instrLength)
{
  801a7e:	55                   	push   %ebp
  801a7f:	89 e5                	mov    %esp,%ebp
  801a81:	83 ec 04             	sub    $0x4,%esp
  801a84:	8b 45 08             	mov    0x8(%ebp),%eax
  801a87:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  801a8a:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  801a8e:	6a 00                	push   $0x0
  801a90:	6a 00                	push   $0x0
  801a92:	6a 00                	push   $0x0
  801a94:	6a 00                	push   $0x0
  801a96:	50                   	push   %eax
  801a97:	6a 26                	push   $0x26
  801a99:	e8 5c fb ff ff       	call   8015fa <syscall>
  801a9e:	83 c4 18             	add    $0x18,%esp
	return ;
  801aa1:	90                   	nop
}
  801aa2:	c9                   	leave  
  801aa3:	c3                   	ret    

00801aa4 <rsttst>:
void rsttst()
{
  801aa4:	55                   	push   %ebp
  801aa5:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  801aa7:	6a 00                	push   $0x0
  801aa9:	6a 00                	push   $0x0
  801aab:	6a 00                	push   $0x0
  801aad:	6a 00                	push   $0x0
  801aaf:	6a 00                	push   $0x0
  801ab1:	6a 28                	push   $0x28
  801ab3:	e8 42 fb ff ff       	call   8015fa <syscall>
  801ab8:	83 c4 18             	add    $0x18,%esp
	return ;
  801abb:	90                   	nop
}
  801abc:	c9                   	leave  
  801abd:	c3                   	ret    

00801abe <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  801abe:	55                   	push   %ebp
  801abf:	89 e5                	mov    %esp,%ebp
  801ac1:	83 ec 04             	sub    $0x4,%esp
  801ac4:	8b 45 14             	mov    0x14(%ebp),%eax
  801ac7:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  801aca:	8b 55 18             	mov    0x18(%ebp),%edx
  801acd:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801ad1:	52                   	push   %edx
  801ad2:	50                   	push   %eax
  801ad3:	ff 75 10             	pushl  0x10(%ebp)
  801ad6:	ff 75 0c             	pushl  0xc(%ebp)
  801ad9:	ff 75 08             	pushl  0x8(%ebp)
  801adc:	6a 27                	push   $0x27
  801ade:	e8 17 fb ff ff       	call   8015fa <syscall>
  801ae3:	83 c4 18             	add    $0x18,%esp
	return ;
  801ae6:	90                   	nop
}
  801ae7:	c9                   	leave  
  801ae8:	c3                   	ret    

00801ae9 <chktst>:
void chktst(uint32 n)
{
  801ae9:	55                   	push   %ebp
  801aea:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  801aec:	6a 00                	push   $0x0
  801aee:	6a 00                	push   $0x0
  801af0:	6a 00                	push   $0x0
  801af2:	6a 00                	push   $0x0
  801af4:	ff 75 08             	pushl  0x8(%ebp)
  801af7:	6a 29                	push   $0x29
  801af9:	e8 fc fa ff ff       	call   8015fa <syscall>
  801afe:	83 c4 18             	add    $0x18,%esp
	return ;
  801b01:	90                   	nop
}
  801b02:	c9                   	leave  
  801b03:	c3                   	ret    

00801b04 <inctst>:

void inctst()
{
  801b04:	55                   	push   %ebp
  801b05:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  801b07:	6a 00                	push   $0x0
  801b09:	6a 00                	push   $0x0
  801b0b:	6a 00                	push   $0x0
  801b0d:	6a 00                	push   $0x0
  801b0f:	6a 00                	push   $0x0
  801b11:	6a 2a                	push   $0x2a
  801b13:	e8 e2 fa ff ff       	call   8015fa <syscall>
  801b18:	83 c4 18             	add    $0x18,%esp
	return ;
  801b1b:	90                   	nop
}
  801b1c:	c9                   	leave  
  801b1d:	c3                   	ret    

00801b1e <gettst>:
uint32 gettst()
{
  801b1e:	55                   	push   %ebp
  801b1f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  801b21:	6a 00                	push   $0x0
  801b23:	6a 00                	push   $0x0
  801b25:	6a 00                	push   $0x0
  801b27:	6a 00                	push   $0x0
  801b29:	6a 00                	push   $0x0
  801b2b:	6a 2b                	push   $0x2b
  801b2d:	e8 c8 fa ff ff       	call   8015fa <syscall>
  801b32:	83 c4 18             	add    $0x18,%esp
}
  801b35:	c9                   	leave  
  801b36:	c3                   	ret    

00801b37 <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  801b37:	55                   	push   %ebp
  801b38:	89 e5                	mov    %esp,%ebp
  801b3a:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801b3d:	6a 00                	push   $0x0
  801b3f:	6a 00                	push   $0x0
  801b41:	6a 00                	push   $0x0
  801b43:	6a 00                	push   $0x0
  801b45:	6a 00                	push   $0x0
  801b47:	6a 2c                	push   $0x2c
  801b49:	e8 ac fa ff ff       	call   8015fa <syscall>
  801b4e:	83 c4 18             	add    $0x18,%esp
  801b51:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  801b54:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  801b58:	75 07                	jne    801b61 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  801b5a:	b8 01 00 00 00       	mov    $0x1,%eax
  801b5f:	eb 05                	jmp    801b66 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  801b61:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801b66:	c9                   	leave  
  801b67:	c3                   	ret    

00801b68 <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  801b68:	55                   	push   %ebp
  801b69:	89 e5                	mov    %esp,%ebp
  801b6b:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801b6e:	6a 00                	push   $0x0
  801b70:	6a 00                	push   $0x0
  801b72:	6a 00                	push   $0x0
  801b74:	6a 00                	push   $0x0
  801b76:	6a 00                	push   $0x0
  801b78:	6a 2c                	push   $0x2c
  801b7a:	e8 7b fa ff ff       	call   8015fa <syscall>
  801b7f:	83 c4 18             	add    $0x18,%esp
  801b82:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  801b85:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  801b89:	75 07                	jne    801b92 <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  801b8b:	b8 01 00 00 00       	mov    $0x1,%eax
  801b90:	eb 05                	jmp    801b97 <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  801b92:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801b97:	c9                   	leave  
  801b98:	c3                   	ret    

00801b99 <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  801b99:	55                   	push   %ebp
  801b9a:	89 e5                	mov    %esp,%ebp
  801b9c:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801b9f:	6a 00                	push   $0x0
  801ba1:	6a 00                	push   $0x0
  801ba3:	6a 00                	push   $0x0
  801ba5:	6a 00                	push   $0x0
  801ba7:	6a 00                	push   $0x0
  801ba9:	6a 2c                	push   $0x2c
  801bab:	e8 4a fa ff ff       	call   8015fa <syscall>
  801bb0:	83 c4 18             	add    $0x18,%esp
  801bb3:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  801bb6:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  801bba:	75 07                	jne    801bc3 <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  801bbc:	b8 01 00 00 00       	mov    $0x1,%eax
  801bc1:	eb 05                	jmp    801bc8 <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  801bc3:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801bc8:	c9                   	leave  
  801bc9:	c3                   	ret    

00801bca <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  801bca:	55                   	push   %ebp
  801bcb:	89 e5                	mov    %esp,%ebp
  801bcd:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801bd0:	6a 00                	push   $0x0
  801bd2:	6a 00                	push   $0x0
  801bd4:	6a 00                	push   $0x0
  801bd6:	6a 00                	push   $0x0
  801bd8:	6a 00                	push   $0x0
  801bda:	6a 2c                	push   $0x2c
  801bdc:	e8 19 fa ff ff       	call   8015fa <syscall>
  801be1:	83 c4 18             	add    $0x18,%esp
  801be4:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  801be7:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  801beb:	75 07                	jne    801bf4 <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  801bed:	b8 01 00 00 00       	mov    $0x1,%eax
  801bf2:	eb 05                	jmp    801bf9 <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  801bf4:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801bf9:	c9                   	leave  
  801bfa:	c3                   	ret    

00801bfb <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  801bfb:	55                   	push   %ebp
  801bfc:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  801bfe:	6a 00                	push   $0x0
  801c00:	6a 00                	push   $0x0
  801c02:	6a 00                	push   $0x0
  801c04:	6a 00                	push   $0x0
  801c06:	ff 75 08             	pushl  0x8(%ebp)
  801c09:	6a 2d                	push   $0x2d
  801c0b:	e8 ea f9 ff ff       	call   8015fa <syscall>
  801c10:	83 c4 18             	add    $0x18,%esp
	return ;
  801c13:	90                   	nop
}
  801c14:	c9                   	leave  
  801c15:	c3                   	ret    

00801c16 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  801c16:	55                   	push   %ebp
  801c17:	89 e5                	mov    %esp,%ebp
  801c19:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  801c1a:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801c1d:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801c20:	8b 55 0c             	mov    0xc(%ebp),%edx
  801c23:	8b 45 08             	mov    0x8(%ebp),%eax
  801c26:	6a 00                	push   $0x0
  801c28:	53                   	push   %ebx
  801c29:	51                   	push   %ecx
  801c2a:	52                   	push   %edx
  801c2b:	50                   	push   %eax
  801c2c:	6a 2e                	push   $0x2e
  801c2e:	e8 c7 f9 ff ff       	call   8015fa <syscall>
  801c33:	83 c4 18             	add    $0x18,%esp
}
  801c36:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801c39:	c9                   	leave  
  801c3a:	c3                   	ret    

00801c3b <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  801c3b:	55                   	push   %ebp
  801c3c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  801c3e:	8b 55 0c             	mov    0xc(%ebp),%edx
  801c41:	8b 45 08             	mov    0x8(%ebp),%eax
  801c44:	6a 00                	push   $0x0
  801c46:	6a 00                	push   $0x0
  801c48:	6a 00                	push   $0x0
  801c4a:	52                   	push   %edx
  801c4b:	50                   	push   %eax
  801c4c:	6a 2f                	push   $0x2f
  801c4e:	e8 a7 f9 ff ff       	call   8015fa <syscall>
  801c53:	83 c4 18             	add    $0x18,%esp
}
  801c56:	c9                   	leave  
  801c57:	c3                   	ret    

00801c58 <print_mem_block_lists>:
//===========================
// PRINT MEM BLOCK LISTS:
//===========================

void print_mem_block_lists()
{
  801c58:	55                   	push   %ebp
  801c59:	89 e5                	mov    %esp,%ebp
  801c5b:	83 ec 18             	sub    $0x18,%esp
	cprintf("\n=========================================\n");
  801c5e:	83 ec 0c             	sub    $0xc,%esp
  801c61:	68 20 36 80 00       	push   $0x803620
  801c66:	e8 dd e6 ff ff       	call   800348 <cprintf>
  801c6b:	83 c4 10             	add    $0x10,%esp
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
  801c6e:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nFreeMemBlocksList:\n");
  801c75:	83 ec 0c             	sub    $0xc,%esp
  801c78:	68 4c 36 80 00       	push   $0x80364c
  801c7d:	e8 c6 e6 ff ff       	call   800348 <cprintf>
  801c82:	83 c4 10             	add    $0x10,%esp
	uint8 sorted = 1 ;
  801c85:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &FreeMemBlocksList)
  801c89:	a1 38 41 80 00       	mov    0x804138,%eax
  801c8e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801c91:	eb 56                	jmp    801ce9 <print_mem_block_lists+0x91>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  801c93:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801c97:	74 1c                	je     801cb5 <print_mem_block_lists+0x5d>
  801c99:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801c9c:	8b 50 08             	mov    0x8(%eax),%edx
  801c9f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801ca2:	8b 48 08             	mov    0x8(%eax),%ecx
  801ca5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801ca8:	8b 40 0c             	mov    0xc(%eax),%eax
  801cab:	01 c8                	add    %ecx,%eax
  801cad:	39 c2                	cmp    %eax,%edx
  801caf:	73 04                	jae    801cb5 <print_mem_block_lists+0x5d>
			sorted = 0 ;
  801cb1:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  801cb5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801cb8:	8b 50 08             	mov    0x8(%eax),%edx
  801cbb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801cbe:	8b 40 0c             	mov    0xc(%eax),%eax
  801cc1:	01 c2                	add    %eax,%edx
  801cc3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801cc6:	8b 40 08             	mov    0x8(%eax),%eax
  801cc9:	83 ec 04             	sub    $0x4,%esp
  801ccc:	52                   	push   %edx
  801ccd:	50                   	push   %eax
  801cce:	68 61 36 80 00       	push   $0x803661
  801cd3:	e8 70 e6 ff ff       	call   800348 <cprintf>
  801cd8:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  801cdb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801cde:	89 45 f0             	mov    %eax,-0x10(%ebp)
	cprintf("\n=========================================\n");
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
	cprintf("\nFreeMemBlocksList:\n");
	uint8 sorted = 1 ;
	LIST_FOREACH(blk, &FreeMemBlocksList)
  801ce1:	a1 40 41 80 00       	mov    0x804140,%eax
  801ce6:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801ce9:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801ced:	74 07                	je     801cf6 <print_mem_block_lists+0x9e>
  801cef:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801cf2:	8b 00                	mov    (%eax),%eax
  801cf4:	eb 05                	jmp    801cfb <print_mem_block_lists+0xa3>
  801cf6:	b8 00 00 00 00       	mov    $0x0,%eax
  801cfb:	a3 40 41 80 00       	mov    %eax,0x804140
  801d00:	a1 40 41 80 00       	mov    0x804140,%eax
  801d05:	85 c0                	test   %eax,%eax
  801d07:	75 8a                	jne    801c93 <print_mem_block_lists+0x3b>
  801d09:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801d0d:	75 84                	jne    801c93 <print_mem_block_lists+0x3b>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;
  801d0f:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  801d13:	75 10                	jne    801d25 <print_mem_block_lists+0xcd>
  801d15:	83 ec 0c             	sub    $0xc,%esp
  801d18:	68 70 36 80 00       	push   $0x803670
  801d1d:	e8 26 e6 ff ff       	call   800348 <cprintf>
  801d22:	83 c4 10             	add    $0x10,%esp

	lastBlk = NULL ;
  801d25:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nAllocMemBlocksList:\n");
  801d2c:	83 ec 0c             	sub    $0xc,%esp
  801d2f:	68 94 36 80 00       	push   $0x803694
  801d34:	e8 0f e6 ff ff       	call   800348 <cprintf>
  801d39:	83 c4 10             	add    $0x10,%esp
	sorted = 1 ;
  801d3c:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &AllocMemBlocksList)
  801d40:	a1 40 40 80 00       	mov    0x804040,%eax
  801d45:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801d48:	eb 56                	jmp    801da0 <print_mem_block_lists+0x148>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  801d4a:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801d4e:	74 1c                	je     801d6c <print_mem_block_lists+0x114>
  801d50:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801d53:	8b 50 08             	mov    0x8(%eax),%edx
  801d56:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801d59:	8b 48 08             	mov    0x8(%eax),%ecx
  801d5c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801d5f:	8b 40 0c             	mov    0xc(%eax),%eax
  801d62:	01 c8                	add    %ecx,%eax
  801d64:	39 c2                	cmp    %eax,%edx
  801d66:	73 04                	jae    801d6c <print_mem_block_lists+0x114>
			sorted = 0 ;
  801d68:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  801d6c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801d6f:	8b 50 08             	mov    0x8(%eax),%edx
  801d72:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801d75:	8b 40 0c             	mov    0xc(%eax),%eax
  801d78:	01 c2                	add    %eax,%edx
  801d7a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801d7d:	8b 40 08             	mov    0x8(%eax),%eax
  801d80:	83 ec 04             	sub    $0x4,%esp
  801d83:	52                   	push   %edx
  801d84:	50                   	push   %eax
  801d85:	68 61 36 80 00       	push   $0x803661
  801d8a:	e8 b9 e5 ff ff       	call   800348 <cprintf>
  801d8f:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  801d92:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801d95:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;

	lastBlk = NULL ;
	cprintf("\nAllocMemBlocksList:\n");
	sorted = 1 ;
	LIST_FOREACH(blk, &AllocMemBlocksList)
  801d98:	a1 48 40 80 00       	mov    0x804048,%eax
  801d9d:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801da0:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801da4:	74 07                	je     801dad <print_mem_block_lists+0x155>
  801da6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801da9:	8b 00                	mov    (%eax),%eax
  801dab:	eb 05                	jmp    801db2 <print_mem_block_lists+0x15a>
  801dad:	b8 00 00 00 00       	mov    $0x0,%eax
  801db2:	a3 48 40 80 00       	mov    %eax,0x804048
  801db7:	a1 48 40 80 00       	mov    0x804048,%eax
  801dbc:	85 c0                	test   %eax,%eax
  801dbe:	75 8a                	jne    801d4a <print_mem_block_lists+0xf2>
  801dc0:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801dc4:	75 84                	jne    801d4a <print_mem_block_lists+0xf2>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nAllocMemBlocksList is NOT SORTED!!\n") ;
  801dc6:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  801dca:	75 10                	jne    801ddc <print_mem_block_lists+0x184>
  801dcc:	83 ec 0c             	sub    $0xc,%esp
  801dcf:	68 ac 36 80 00       	push   $0x8036ac
  801dd4:	e8 6f e5 ff ff       	call   800348 <cprintf>
  801dd9:	83 c4 10             	add    $0x10,%esp
	cprintf("\n=========================================\n");
  801ddc:	83 ec 0c             	sub    $0xc,%esp
  801ddf:	68 20 36 80 00       	push   $0x803620
  801de4:	e8 5f e5 ff ff       	call   800348 <cprintf>
  801de9:	83 c4 10             	add    $0x10,%esp

}
  801dec:	90                   	nop
  801ded:	c9                   	leave  
  801dee:	c3                   	ret    

00801def <initialize_MemBlocksList>:

//===============================
// [1] INITIALIZE AVAILABLE LIST:
//===============================
void initialize_MemBlocksList(uint32 numOfBlocks)
{
  801def:	55                   	push   %ebp
  801df0:	89 e5                	mov    %esp,%ebp
  801df2:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] initialize_MemBlocksList
	// Write your code here, remove the panic and write your code
	//panic("initialize_MemBlocksList() is not implemented yet...!!");
	uint32 n = numOfBlocks;
  801df5:	8b 45 08             	mov    0x8(%ebp),%eax
  801df8:	89 45 f0             	mov    %eax,-0x10(%ebp)

	LIST_INIT(&AvailableMemBlocksList);
  801dfb:	c7 05 48 41 80 00 00 	movl   $0x0,0x804148
  801e02:	00 00 00 
  801e05:	c7 05 4c 41 80 00 00 	movl   $0x0,0x80414c
  801e0c:	00 00 00 
  801e0f:	c7 05 54 41 80 00 00 	movl   $0x0,0x804154
  801e16:	00 00 00 
	for(int i = 0; i<n;i++)
  801e19:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  801e20:	e9 9e 00 00 00       	jmp    801ec3 <initialize_MemBlocksList+0xd4>
	{
		LIST_INSERT_HEAD(&AvailableMemBlocksList, &(MemBlockNodes[i]));
  801e25:	a1 50 40 80 00       	mov    0x804050,%eax
  801e2a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801e2d:	c1 e2 04             	shl    $0x4,%edx
  801e30:	01 d0                	add    %edx,%eax
  801e32:	85 c0                	test   %eax,%eax
  801e34:	75 14                	jne    801e4a <initialize_MemBlocksList+0x5b>
  801e36:	83 ec 04             	sub    $0x4,%esp
  801e39:	68 d4 36 80 00       	push   $0x8036d4
  801e3e:	6a 47                	push   $0x47
  801e40:	68 f7 36 80 00       	push   $0x8036f7
  801e45:	e8 24 0e 00 00       	call   802c6e <_panic>
  801e4a:	a1 50 40 80 00       	mov    0x804050,%eax
  801e4f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801e52:	c1 e2 04             	shl    $0x4,%edx
  801e55:	01 d0                	add    %edx,%eax
  801e57:	8b 15 48 41 80 00    	mov    0x804148,%edx
  801e5d:	89 10                	mov    %edx,(%eax)
  801e5f:	8b 00                	mov    (%eax),%eax
  801e61:	85 c0                	test   %eax,%eax
  801e63:	74 18                	je     801e7d <initialize_MemBlocksList+0x8e>
  801e65:	a1 48 41 80 00       	mov    0x804148,%eax
  801e6a:	8b 15 50 40 80 00    	mov    0x804050,%edx
  801e70:	8b 4d f4             	mov    -0xc(%ebp),%ecx
  801e73:	c1 e1 04             	shl    $0x4,%ecx
  801e76:	01 ca                	add    %ecx,%edx
  801e78:	89 50 04             	mov    %edx,0x4(%eax)
  801e7b:	eb 12                	jmp    801e8f <initialize_MemBlocksList+0xa0>
  801e7d:	a1 50 40 80 00       	mov    0x804050,%eax
  801e82:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801e85:	c1 e2 04             	shl    $0x4,%edx
  801e88:	01 d0                	add    %edx,%eax
  801e8a:	a3 4c 41 80 00       	mov    %eax,0x80414c
  801e8f:	a1 50 40 80 00       	mov    0x804050,%eax
  801e94:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801e97:	c1 e2 04             	shl    $0x4,%edx
  801e9a:	01 d0                	add    %edx,%eax
  801e9c:	a3 48 41 80 00       	mov    %eax,0x804148
  801ea1:	a1 50 40 80 00       	mov    0x804050,%eax
  801ea6:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801ea9:	c1 e2 04             	shl    $0x4,%edx
  801eac:	01 d0                	add    %edx,%eax
  801eae:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  801eb5:	a1 54 41 80 00       	mov    0x804154,%eax
  801eba:	40                   	inc    %eax
  801ebb:	a3 54 41 80 00       	mov    %eax,0x804154
	// Write your code here, remove the panic and write your code
	//panic("initialize_MemBlocksList() is not implemented yet...!!");
	uint32 n = numOfBlocks;

	LIST_INIT(&AvailableMemBlocksList);
	for(int i = 0; i<n;i++)
  801ec0:	ff 45 f4             	incl   -0xc(%ebp)
  801ec3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ec6:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801ec9:	0f 82 56 ff ff ff    	jb     801e25 <initialize_MemBlocksList+0x36>
	{
		LIST_INSERT_HEAD(&AvailableMemBlocksList, &(MemBlockNodes[i]));
	}
}
  801ecf:	90                   	nop
  801ed0:	c9                   	leave  
  801ed1:	c3                   	ret    

00801ed2 <find_block>:

//===============================
// [2] FIND BLOCK:
//===============================
struct MemBlock *find_block(struct MemBlock_List *blockList, uint32 va)
{
  801ed2:	55                   	push   %ebp
  801ed3:	89 e5                	mov    %esp,%ebp
  801ed5:	83 ec 10             	sub    $0x10,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] find_block
	// Write your code here, remove the panic and write your code
	//panic("find_block() is not implemented yet...!!");
	uint32 virAddress = va;
  801ed8:	8b 45 0c             	mov    0xc(%ebp),%eax
  801edb:	89 45 f4             	mov    %eax,-0xc(%ebp)
	struct MemBlock* blk;
	int found = 0;
  801ede:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	LIST_FOREACH(blk, &(AllocMemBlocksList))
  801ee5:	a1 40 40 80 00       	mov    0x804040,%eax
  801eea:	89 45 fc             	mov    %eax,-0x4(%ebp)
  801eed:	eb 23                	jmp    801f12 <find_block+0x40>
	{
		if(blk->sva == virAddress)
  801eef:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801ef2:	8b 40 08             	mov    0x8(%eax),%eax
  801ef5:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  801ef8:	75 09                	jne    801f03 <find_block+0x31>
		{
			found = 1;
  801efa:	c7 45 f8 01 00 00 00 	movl   $0x1,-0x8(%ebp)
			break;
  801f01:	eb 35                	jmp    801f38 <find_block+0x66>
		}
		else
		{
			found = 0;
  801f03:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	//panic("find_block() is not implemented yet...!!");
	uint32 virAddress = va;
	struct MemBlock* blk;
	int found = 0;

	LIST_FOREACH(blk, &(AllocMemBlocksList))
  801f0a:	a1 48 40 80 00       	mov    0x804048,%eax
  801f0f:	89 45 fc             	mov    %eax,-0x4(%ebp)
  801f12:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801f16:	74 07                	je     801f1f <find_block+0x4d>
  801f18:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801f1b:	8b 00                	mov    (%eax),%eax
  801f1d:	eb 05                	jmp    801f24 <find_block+0x52>
  801f1f:	b8 00 00 00 00       	mov    $0x0,%eax
  801f24:	a3 48 40 80 00       	mov    %eax,0x804048
  801f29:	a1 48 40 80 00       	mov    0x804048,%eax
  801f2e:	85 c0                	test   %eax,%eax
  801f30:	75 bd                	jne    801eef <find_block+0x1d>
  801f32:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801f36:	75 b7                	jne    801eef <find_block+0x1d>
		{
			found = 0;
			continue;
		}
	}
	if(found == 1)
  801f38:	83 7d f8 01          	cmpl   $0x1,-0x8(%ebp)
  801f3c:	75 05                	jne    801f43 <find_block+0x71>
	{
		return blk;
  801f3e:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801f41:	eb 05                	jmp    801f48 <find_block+0x76>
	}
	else
	{
		return NULL;
  801f43:	b8 00 00 00 00       	mov    $0x0,%eax
	}
}
  801f48:	c9                   	leave  
  801f49:	c3                   	ret    

00801f4a <insert_sorted_allocList>:

//=========================================
// [3] INSERT BLOCK IN ALLOC LIST [SORTED]:
//=========================================
void insert_sorted_allocList(struct MemBlock *blockToInsert)
{
  801f4a:	55                   	push   %ebp
  801f4b:	89 e5                	mov    %esp,%ebp
  801f4d:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] insert_sorted_allocList
	// Write your code here, remove the panic and write your code
	//panic("insert_sorted_allocList() is not implemented yet...!!");
	struct MemBlock* blk;
	struct MemBlock* newblk = blockToInsert;
  801f50:	8b 45 08             	mov    0x8(%ebp),%eax
  801f53:	89 45 f0             	mov    %eax,-0x10(%ebp)

	if((LIST_EMPTY(&AllocMemBlocksList)) || (newblk->sva < LIST_FIRST(&AllocMemBlocksList)->sva))
  801f56:	a1 40 40 80 00       	mov    0x804040,%eax
  801f5b:	85 c0                	test   %eax,%eax
  801f5d:	74 12                	je     801f71 <insert_sorted_allocList+0x27>
  801f5f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801f62:	8b 50 08             	mov    0x8(%eax),%edx
  801f65:	a1 40 40 80 00       	mov    0x804040,%eax
  801f6a:	8b 40 08             	mov    0x8(%eax),%eax
  801f6d:	39 c2                	cmp    %eax,%edx
  801f6f:	73 65                	jae    801fd6 <insert_sorted_allocList+0x8c>
	{
		LIST_INSERT_HEAD(&(AllocMemBlocksList), newblk);
  801f71:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801f75:	75 14                	jne    801f8b <insert_sorted_allocList+0x41>
  801f77:	83 ec 04             	sub    $0x4,%esp
  801f7a:	68 d4 36 80 00       	push   $0x8036d4
  801f7f:	6a 7b                	push   $0x7b
  801f81:	68 f7 36 80 00       	push   $0x8036f7
  801f86:	e8 e3 0c 00 00       	call   802c6e <_panic>
  801f8b:	8b 15 40 40 80 00    	mov    0x804040,%edx
  801f91:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801f94:	89 10                	mov    %edx,(%eax)
  801f96:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801f99:	8b 00                	mov    (%eax),%eax
  801f9b:	85 c0                	test   %eax,%eax
  801f9d:	74 0d                	je     801fac <insert_sorted_allocList+0x62>
  801f9f:	a1 40 40 80 00       	mov    0x804040,%eax
  801fa4:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801fa7:	89 50 04             	mov    %edx,0x4(%eax)
  801faa:	eb 08                	jmp    801fb4 <insert_sorted_allocList+0x6a>
  801fac:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801faf:	a3 44 40 80 00       	mov    %eax,0x804044
  801fb4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801fb7:	a3 40 40 80 00       	mov    %eax,0x804040
  801fbc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801fbf:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  801fc6:	a1 4c 40 80 00       	mov    0x80404c,%eax
  801fcb:	40                   	inc    %eax
  801fcc:	a3 4c 40 80 00       	mov    %eax,0x80404c
  801fd1:	e9 5f 01 00 00       	jmp    802135 <insert_sorted_allocList+0x1eb>
	}
	else if(newblk->sva > LIST_LAST(&AllocMemBlocksList)->sva)
  801fd6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801fd9:	8b 50 08             	mov    0x8(%eax),%edx
  801fdc:	a1 44 40 80 00       	mov    0x804044,%eax
  801fe1:	8b 40 08             	mov    0x8(%eax),%eax
  801fe4:	39 c2                	cmp    %eax,%edx
  801fe6:	76 65                	jbe    80204d <insert_sorted_allocList+0x103>
	{
		LIST_INSERT_TAIL(&AllocMemBlocksList, newblk);
  801fe8:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801fec:	75 14                	jne    802002 <insert_sorted_allocList+0xb8>
  801fee:	83 ec 04             	sub    $0x4,%esp
  801ff1:	68 10 37 80 00       	push   $0x803710
  801ff6:	6a 7f                	push   $0x7f
  801ff8:	68 f7 36 80 00       	push   $0x8036f7
  801ffd:	e8 6c 0c 00 00       	call   802c6e <_panic>
  802002:	8b 15 44 40 80 00    	mov    0x804044,%edx
  802008:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80200b:	89 50 04             	mov    %edx,0x4(%eax)
  80200e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802011:	8b 40 04             	mov    0x4(%eax),%eax
  802014:	85 c0                	test   %eax,%eax
  802016:	74 0c                	je     802024 <insert_sorted_allocList+0xda>
  802018:	a1 44 40 80 00       	mov    0x804044,%eax
  80201d:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802020:	89 10                	mov    %edx,(%eax)
  802022:	eb 08                	jmp    80202c <insert_sorted_allocList+0xe2>
  802024:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802027:	a3 40 40 80 00       	mov    %eax,0x804040
  80202c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80202f:	a3 44 40 80 00       	mov    %eax,0x804044
  802034:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802037:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80203d:	a1 4c 40 80 00       	mov    0x80404c,%eax
  802042:	40                   	inc    %eax
  802043:	a3 4c 40 80 00       	mov    %eax,0x80404c
				LIST_INSERT_AFTER(&AllocMemBlocksList, blk, newblk);
				break;
			}
		}
	}
}
  802048:	e9 e8 00 00 00       	jmp    802135 <insert_sorted_allocList+0x1eb>
	{
		LIST_INSERT_TAIL(&AllocMemBlocksList, newblk);
	}
	else
	{
		LIST_FOREACH(blk, &AllocMemBlocksList)
  80204d:	a1 40 40 80 00       	mov    0x804040,%eax
  802052:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802055:	e9 ab 00 00 00       	jmp    802105 <insert_sorted_allocList+0x1bb>
		{
			if(blk->prev_next_info.le_next != NULL && newblk->sva > blk->sva  && newblk->sva < blk->prev_next_info.le_next->sva)
  80205a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80205d:	8b 00                	mov    (%eax),%eax
  80205f:	85 c0                	test   %eax,%eax
  802061:	0f 84 96 00 00 00    	je     8020fd <insert_sorted_allocList+0x1b3>
  802067:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80206a:	8b 50 08             	mov    0x8(%eax),%edx
  80206d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802070:	8b 40 08             	mov    0x8(%eax),%eax
  802073:	39 c2                	cmp    %eax,%edx
  802075:	0f 86 82 00 00 00    	jbe    8020fd <insert_sorted_allocList+0x1b3>
  80207b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80207e:	8b 50 08             	mov    0x8(%eax),%edx
  802081:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802084:	8b 00                	mov    (%eax),%eax
  802086:	8b 40 08             	mov    0x8(%eax),%eax
  802089:	39 c2                	cmp    %eax,%edx
  80208b:	73 70                	jae    8020fd <insert_sorted_allocList+0x1b3>
			{
				LIST_INSERT_AFTER(&AllocMemBlocksList, blk, newblk);
  80208d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802091:	74 06                	je     802099 <insert_sorted_allocList+0x14f>
  802093:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802097:	75 17                	jne    8020b0 <insert_sorted_allocList+0x166>
  802099:	83 ec 04             	sub    $0x4,%esp
  80209c:	68 34 37 80 00       	push   $0x803734
  8020a1:	68 87 00 00 00       	push   $0x87
  8020a6:	68 f7 36 80 00       	push   $0x8036f7
  8020ab:	e8 be 0b 00 00       	call   802c6e <_panic>
  8020b0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020b3:	8b 10                	mov    (%eax),%edx
  8020b5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8020b8:	89 10                	mov    %edx,(%eax)
  8020ba:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8020bd:	8b 00                	mov    (%eax),%eax
  8020bf:	85 c0                	test   %eax,%eax
  8020c1:	74 0b                	je     8020ce <insert_sorted_allocList+0x184>
  8020c3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020c6:	8b 00                	mov    (%eax),%eax
  8020c8:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8020cb:	89 50 04             	mov    %edx,0x4(%eax)
  8020ce:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020d1:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8020d4:	89 10                	mov    %edx,(%eax)
  8020d6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8020d9:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8020dc:	89 50 04             	mov    %edx,0x4(%eax)
  8020df:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8020e2:	8b 00                	mov    (%eax),%eax
  8020e4:	85 c0                	test   %eax,%eax
  8020e6:	75 08                	jne    8020f0 <insert_sorted_allocList+0x1a6>
  8020e8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8020eb:	a3 44 40 80 00       	mov    %eax,0x804044
  8020f0:	a1 4c 40 80 00       	mov    0x80404c,%eax
  8020f5:	40                   	inc    %eax
  8020f6:	a3 4c 40 80 00       	mov    %eax,0x80404c
				break;
  8020fb:	eb 38                	jmp    802135 <insert_sorted_allocList+0x1eb>
	{
		LIST_INSERT_TAIL(&AllocMemBlocksList, newblk);
	}
	else
	{
		LIST_FOREACH(blk, &AllocMemBlocksList)
  8020fd:	a1 48 40 80 00       	mov    0x804048,%eax
  802102:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802105:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802109:	74 07                	je     802112 <insert_sorted_allocList+0x1c8>
  80210b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80210e:	8b 00                	mov    (%eax),%eax
  802110:	eb 05                	jmp    802117 <insert_sorted_allocList+0x1cd>
  802112:	b8 00 00 00 00       	mov    $0x0,%eax
  802117:	a3 48 40 80 00       	mov    %eax,0x804048
  80211c:	a1 48 40 80 00       	mov    0x804048,%eax
  802121:	85 c0                	test   %eax,%eax
  802123:	0f 85 31 ff ff ff    	jne    80205a <insert_sorted_allocList+0x110>
  802129:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80212d:	0f 85 27 ff ff ff    	jne    80205a <insert_sorted_allocList+0x110>
				LIST_INSERT_AFTER(&AllocMemBlocksList, blk, newblk);
				break;
			}
		}
	}
}
  802133:	eb 00                	jmp    802135 <insert_sorted_allocList+0x1eb>
  802135:	90                   	nop
  802136:	c9                   	leave  
  802137:	c3                   	ret    

00802138 <alloc_block_FF>:

//=========================================
// [4] ALLOCATE BLOCK BY FIRST FIT:
//=========================================
struct MemBlock *alloc_block_FF(uint32 size)
{
  802138:	55                   	push   %ebp
  802139:	89 e5                	mov    %esp,%ebp
  80213b:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_FF
	// Write your code here, remove the panic and write your code
	//panic("alloc_block_FF() is not implemented yet...!!");
	uint32 versize = size;
  80213e:	8b 45 08             	mov    0x8(%ebp),%eax
  802141:	89 45 f0             	mov    %eax,-0x10(%ebp)
	struct MemBlock* blk;
	struct MemBlock* newblk = LIST_FIRST(&AvailableMemBlocksList);
  802144:	a1 48 41 80 00       	mov    0x804148,%eax
  802149:	89 45 ec             	mov    %eax,-0x14(%ebp)

	LIST_FOREACH(blk,&FreeMemBlocksList)
  80214c:	a1 38 41 80 00       	mov    0x804138,%eax
  802151:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802154:	e9 77 01 00 00       	jmp    8022d0 <alloc_block_FF+0x198>
	{
		if(blk->size == versize)
  802159:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80215c:	8b 40 0c             	mov    0xc(%eax),%eax
  80215f:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  802162:	0f 85 8a 00 00 00    	jne    8021f2 <alloc_block_FF+0xba>
		{
			LIST_REMOVE(&FreeMemBlocksList,blk);
  802168:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80216c:	75 17                	jne    802185 <alloc_block_FF+0x4d>
  80216e:	83 ec 04             	sub    $0x4,%esp
  802171:	68 68 37 80 00       	push   $0x803768
  802176:	68 9e 00 00 00       	push   $0x9e
  80217b:	68 f7 36 80 00       	push   $0x8036f7
  802180:	e8 e9 0a 00 00       	call   802c6e <_panic>
  802185:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802188:	8b 00                	mov    (%eax),%eax
  80218a:	85 c0                	test   %eax,%eax
  80218c:	74 10                	je     80219e <alloc_block_FF+0x66>
  80218e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802191:	8b 00                	mov    (%eax),%eax
  802193:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802196:	8b 52 04             	mov    0x4(%edx),%edx
  802199:	89 50 04             	mov    %edx,0x4(%eax)
  80219c:	eb 0b                	jmp    8021a9 <alloc_block_FF+0x71>
  80219e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021a1:	8b 40 04             	mov    0x4(%eax),%eax
  8021a4:	a3 3c 41 80 00       	mov    %eax,0x80413c
  8021a9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021ac:	8b 40 04             	mov    0x4(%eax),%eax
  8021af:	85 c0                	test   %eax,%eax
  8021b1:	74 0f                	je     8021c2 <alloc_block_FF+0x8a>
  8021b3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021b6:	8b 40 04             	mov    0x4(%eax),%eax
  8021b9:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8021bc:	8b 12                	mov    (%edx),%edx
  8021be:	89 10                	mov    %edx,(%eax)
  8021c0:	eb 0a                	jmp    8021cc <alloc_block_FF+0x94>
  8021c2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021c5:	8b 00                	mov    (%eax),%eax
  8021c7:	a3 38 41 80 00       	mov    %eax,0x804138
  8021cc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021cf:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8021d5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021d8:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8021df:	a1 44 41 80 00       	mov    0x804144,%eax
  8021e4:	48                   	dec    %eax
  8021e5:	a3 44 41 80 00       	mov    %eax,0x804144
			return blk;
  8021ea:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021ed:	e9 11 01 00 00       	jmp    802303 <alloc_block_FF+0x1cb>
		}
		else if(blk->size > versize)
  8021f2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021f5:	8b 40 0c             	mov    0xc(%eax),%eax
  8021f8:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8021fb:	0f 86 c7 00 00 00    	jbe    8022c8 <alloc_block_FF+0x190>
		{
			LIST_REMOVE(&AvailableMemBlocksList,newblk);
  802201:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802205:	75 17                	jne    80221e <alloc_block_FF+0xe6>
  802207:	83 ec 04             	sub    $0x4,%esp
  80220a:	68 68 37 80 00       	push   $0x803768
  80220f:	68 a3 00 00 00       	push   $0xa3
  802214:	68 f7 36 80 00       	push   $0x8036f7
  802219:	e8 50 0a 00 00       	call   802c6e <_panic>
  80221e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802221:	8b 00                	mov    (%eax),%eax
  802223:	85 c0                	test   %eax,%eax
  802225:	74 10                	je     802237 <alloc_block_FF+0xff>
  802227:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80222a:	8b 00                	mov    (%eax),%eax
  80222c:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80222f:	8b 52 04             	mov    0x4(%edx),%edx
  802232:	89 50 04             	mov    %edx,0x4(%eax)
  802235:	eb 0b                	jmp    802242 <alloc_block_FF+0x10a>
  802237:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80223a:	8b 40 04             	mov    0x4(%eax),%eax
  80223d:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802242:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802245:	8b 40 04             	mov    0x4(%eax),%eax
  802248:	85 c0                	test   %eax,%eax
  80224a:	74 0f                	je     80225b <alloc_block_FF+0x123>
  80224c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80224f:	8b 40 04             	mov    0x4(%eax),%eax
  802252:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802255:	8b 12                	mov    (%edx),%edx
  802257:	89 10                	mov    %edx,(%eax)
  802259:	eb 0a                	jmp    802265 <alloc_block_FF+0x12d>
  80225b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80225e:	8b 00                	mov    (%eax),%eax
  802260:	a3 48 41 80 00       	mov    %eax,0x804148
  802265:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802268:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80226e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802271:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802278:	a1 54 41 80 00       	mov    0x804154,%eax
  80227d:	48                   	dec    %eax
  80227e:	a3 54 41 80 00       	mov    %eax,0x804154
			newblk->size = versize;
  802283:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802286:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802289:	89 50 0c             	mov    %edx,0xc(%eax)
			blk->size = blk->size-versize;
  80228c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80228f:	8b 40 0c             	mov    0xc(%eax),%eax
  802292:	2b 45 f0             	sub    -0x10(%ebp),%eax
  802295:	89 c2                	mov    %eax,%edx
  802297:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80229a:	89 50 0c             	mov    %edx,0xc(%eax)
			uint32 newveradd = blk->sva;
  80229d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022a0:	8b 40 08             	mov    0x8(%eax),%eax
  8022a3:	89 45 e8             	mov    %eax,-0x18(%ebp)
			blk->sva+=newblk->size;
  8022a6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022a9:	8b 50 08             	mov    0x8(%eax),%edx
  8022ac:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8022af:	8b 40 0c             	mov    0xc(%eax),%eax
  8022b2:	01 c2                	add    %eax,%edx
  8022b4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022b7:	89 50 08             	mov    %edx,0x8(%eax)
			newblk->sva = newveradd;
  8022ba:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8022bd:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8022c0:	89 50 08             	mov    %edx,0x8(%eax)
			return newblk;
  8022c3:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8022c6:	eb 3b                	jmp    802303 <alloc_block_FF+0x1cb>
	//panic("alloc_block_FF() is not implemented yet...!!");
	uint32 versize = size;
	struct MemBlock* blk;
	struct MemBlock* newblk = LIST_FIRST(&AvailableMemBlocksList);

	LIST_FOREACH(blk,&FreeMemBlocksList)
  8022c8:	a1 40 41 80 00       	mov    0x804140,%eax
  8022cd:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8022d0:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8022d4:	74 07                	je     8022dd <alloc_block_FF+0x1a5>
  8022d6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022d9:	8b 00                	mov    (%eax),%eax
  8022db:	eb 05                	jmp    8022e2 <alloc_block_FF+0x1aa>
  8022dd:	b8 00 00 00 00       	mov    $0x0,%eax
  8022e2:	a3 40 41 80 00       	mov    %eax,0x804140
  8022e7:	a1 40 41 80 00       	mov    0x804140,%eax
  8022ec:	85 c0                	test   %eax,%eax
  8022ee:	0f 85 65 fe ff ff    	jne    802159 <alloc_block_FF+0x21>
  8022f4:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8022f8:	0f 85 5b fe ff ff    	jne    802159 <alloc_block_FF+0x21>
			blk->sva+=newblk->size;
			newblk->sva = newveradd;
			return newblk;
		}
	}
	return NULL;
  8022fe:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802303:	c9                   	leave  
  802304:	c3                   	ret    

00802305 <alloc_block_BF>:

//=========================================
// [5] ALLOCATE BLOCK BY BEST FIT:
//=========================================
struct MemBlock *alloc_block_BF(uint32 size)
{
  802305:	55                   	push   %ebp
  802306:	89 e5                	mov    %esp,%ebp
  802308:	83 ec 28             	sub    $0x28,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_BF
	// Write your code here, remove the panic and write your code
	//panic("alloc_block_BF() is not implemented yet...!!");
	uint32 versize=size;
  80230b:	8b 45 08             	mov    0x8(%ebp),%eax
  80230e:	89 45 e8             	mov    %eax,-0x18(%ebp)
	struct MemBlock* blk;
	struct MemBlock* newblk=LIST_FIRST(&AvailableMemBlocksList);
  802311:	a1 48 41 80 00       	mov    0x804148,%eax
  802316:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	uint32 newveradd;
	uint32 newsize;
	int size_free = LIST_SIZE(&FreeMemBlocksList);
  802319:	a1 44 41 80 00       	mov    0x804144,%eax
  80231e:	89 45 e0             	mov    %eax,-0x20(%ebp)

	LIST_FOREACH(blk, &FreeMemBlocksList)
  802321:	a1 38 41 80 00       	mov    0x804138,%eax
  802326:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802329:	e9 a1 00 00 00       	jmp    8023cf <alloc_block_BF+0xca>
	{
		if(blk->size == versize)
  80232e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802331:	8b 40 0c             	mov    0xc(%eax),%eax
  802334:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  802337:	0f 85 8a 00 00 00    	jne    8023c7 <alloc_block_BF+0xc2>
		{
			LIST_REMOVE(&FreeMemBlocksList, blk);
  80233d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802341:	75 17                	jne    80235a <alloc_block_BF+0x55>
  802343:	83 ec 04             	sub    $0x4,%esp
  802346:	68 68 37 80 00       	push   $0x803768
  80234b:	68 c2 00 00 00       	push   $0xc2
  802350:	68 f7 36 80 00       	push   $0x8036f7
  802355:	e8 14 09 00 00       	call   802c6e <_panic>
  80235a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80235d:	8b 00                	mov    (%eax),%eax
  80235f:	85 c0                	test   %eax,%eax
  802361:	74 10                	je     802373 <alloc_block_BF+0x6e>
  802363:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802366:	8b 00                	mov    (%eax),%eax
  802368:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80236b:	8b 52 04             	mov    0x4(%edx),%edx
  80236e:	89 50 04             	mov    %edx,0x4(%eax)
  802371:	eb 0b                	jmp    80237e <alloc_block_BF+0x79>
  802373:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802376:	8b 40 04             	mov    0x4(%eax),%eax
  802379:	a3 3c 41 80 00       	mov    %eax,0x80413c
  80237e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802381:	8b 40 04             	mov    0x4(%eax),%eax
  802384:	85 c0                	test   %eax,%eax
  802386:	74 0f                	je     802397 <alloc_block_BF+0x92>
  802388:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80238b:	8b 40 04             	mov    0x4(%eax),%eax
  80238e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802391:	8b 12                	mov    (%edx),%edx
  802393:	89 10                	mov    %edx,(%eax)
  802395:	eb 0a                	jmp    8023a1 <alloc_block_BF+0x9c>
  802397:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80239a:	8b 00                	mov    (%eax),%eax
  80239c:	a3 38 41 80 00       	mov    %eax,0x804138
  8023a1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023a4:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8023aa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023ad:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8023b4:	a1 44 41 80 00       	mov    0x804144,%eax
  8023b9:	48                   	dec    %eax
  8023ba:	a3 44 41 80 00       	mov    %eax,0x804144
			return blk;
  8023bf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023c2:	e9 11 02 00 00       	jmp    8025d8 <alloc_block_BF+0x2d3>
	struct MemBlock* newblk=LIST_FIRST(&AvailableMemBlocksList);
	uint32 newveradd;
	uint32 newsize;
	int size_free = LIST_SIZE(&FreeMemBlocksList);

	LIST_FOREACH(blk, &FreeMemBlocksList)
  8023c7:	a1 40 41 80 00       	mov    0x804140,%eax
  8023cc:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8023cf:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8023d3:	74 07                	je     8023dc <alloc_block_BF+0xd7>
  8023d5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023d8:	8b 00                	mov    (%eax),%eax
  8023da:	eb 05                	jmp    8023e1 <alloc_block_BF+0xdc>
  8023dc:	b8 00 00 00 00       	mov    $0x0,%eax
  8023e1:	a3 40 41 80 00       	mov    %eax,0x804140
  8023e6:	a1 40 41 80 00       	mov    0x804140,%eax
  8023eb:	85 c0                	test   %eax,%eax
  8023ed:	0f 85 3b ff ff ff    	jne    80232e <alloc_block_BF+0x29>
  8023f3:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8023f7:	0f 85 31 ff ff ff    	jne    80232e <alloc_block_BF+0x29>
		{
			LIST_REMOVE(&FreeMemBlocksList, blk);
			return blk;
		}
	}
	LIST_FOREACH(blk, &FreeMemBlocksList)
  8023fd:	a1 38 41 80 00       	mov    0x804138,%eax
  802402:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802405:	eb 27                	jmp    80242e <alloc_block_BF+0x129>
	{
		if(blk->size > versize)
  802407:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80240a:	8b 40 0c             	mov    0xc(%eax),%eax
  80240d:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  802410:	76 14                	jbe    802426 <alloc_block_BF+0x121>
		{
			newsize = blk->size;
  802412:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802415:	8b 40 0c             	mov    0xc(%eax),%eax
  802418:	89 45 ec             	mov    %eax,-0x14(%ebp)
			newveradd = blk->sva;
  80241b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80241e:	8b 40 08             	mov    0x8(%eax),%eax
  802421:	89 45 f0             	mov    %eax,-0x10(%ebp)
			break;
  802424:	eb 2e                	jmp    802454 <alloc_block_BF+0x14f>
		{
			LIST_REMOVE(&FreeMemBlocksList, blk);
			return blk;
		}
	}
	LIST_FOREACH(blk, &FreeMemBlocksList)
  802426:	a1 40 41 80 00       	mov    0x804140,%eax
  80242b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80242e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802432:	74 07                	je     80243b <alloc_block_BF+0x136>
  802434:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802437:	8b 00                	mov    (%eax),%eax
  802439:	eb 05                	jmp    802440 <alloc_block_BF+0x13b>
  80243b:	b8 00 00 00 00       	mov    $0x0,%eax
  802440:	a3 40 41 80 00       	mov    %eax,0x804140
  802445:	a1 40 41 80 00       	mov    0x804140,%eax
  80244a:	85 c0                	test   %eax,%eax
  80244c:	75 b9                	jne    802407 <alloc_block_BF+0x102>
  80244e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802452:	75 b3                	jne    802407 <alloc_block_BF+0x102>
			newsize = blk->size;
			newveradd = blk->sva;
			break;
		}
	}
	LIST_FOREACH(blk, &FreeMemBlocksList)
  802454:	a1 38 41 80 00       	mov    0x804138,%eax
  802459:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80245c:	eb 30                	jmp    80248e <alloc_block_BF+0x189>
	{
		if(newsize > blk->size && blk->size > versize)
  80245e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802461:	8b 40 0c             	mov    0xc(%eax),%eax
  802464:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  802467:	73 1d                	jae    802486 <alloc_block_BF+0x181>
  802469:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80246c:	8b 40 0c             	mov    0xc(%eax),%eax
  80246f:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  802472:	76 12                	jbe    802486 <alloc_block_BF+0x181>
		{
	       newsize = blk->size;
  802474:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802477:	8b 40 0c             	mov    0xc(%eax),%eax
  80247a:	89 45 ec             	mov    %eax,-0x14(%ebp)
		   newveradd = blk->sva;
  80247d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802480:	8b 40 08             	mov    0x8(%eax),%eax
  802483:	89 45 f0             	mov    %eax,-0x10(%ebp)
			newsize = blk->size;
			newveradd = blk->sva;
			break;
		}
	}
	LIST_FOREACH(blk, &FreeMemBlocksList)
  802486:	a1 40 41 80 00       	mov    0x804140,%eax
  80248b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80248e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802492:	74 07                	je     80249b <alloc_block_BF+0x196>
  802494:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802497:	8b 00                	mov    (%eax),%eax
  802499:	eb 05                	jmp    8024a0 <alloc_block_BF+0x19b>
  80249b:	b8 00 00 00 00       	mov    $0x0,%eax
  8024a0:	a3 40 41 80 00       	mov    %eax,0x804140
  8024a5:	a1 40 41 80 00       	mov    0x804140,%eax
  8024aa:	85 c0                	test   %eax,%eax
  8024ac:	75 b0                	jne    80245e <alloc_block_BF+0x159>
  8024ae:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8024b2:	75 aa                	jne    80245e <alloc_block_BF+0x159>
		{
	       newsize = blk->size;
		   newveradd = blk->sva;
		}
	}
	LIST_FOREACH(blk, &FreeMemBlocksList)
  8024b4:	a1 38 41 80 00       	mov    0x804138,%eax
  8024b9:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8024bc:	e9 e4 00 00 00       	jmp    8025a5 <alloc_block_BF+0x2a0>
	{
		if(blk->size == newsize && blk->sva == newveradd)
  8024c1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024c4:	8b 40 0c             	mov    0xc(%eax),%eax
  8024c7:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  8024ca:	0f 85 cd 00 00 00    	jne    80259d <alloc_block_BF+0x298>
  8024d0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024d3:	8b 40 08             	mov    0x8(%eax),%eax
  8024d6:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8024d9:	0f 85 be 00 00 00    	jne    80259d <alloc_block_BF+0x298>
		{
			LIST_REMOVE(&AvailableMemBlocksList, newblk);
  8024df:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8024e3:	75 17                	jne    8024fc <alloc_block_BF+0x1f7>
  8024e5:	83 ec 04             	sub    $0x4,%esp
  8024e8:	68 68 37 80 00       	push   $0x803768
  8024ed:	68 db 00 00 00       	push   $0xdb
  8024f2:	68 f7 36 80 00       	push   $0x8036f7
  8024f7:	e8 72 07 00 00       	call   802c6e <_panic>
  8024fc:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8024ff:	8b 00                	mov    (%eax),%eax
  802501:	85 c0                	test   %eax,%eax
  802503:	74 10                	je     802515 <alloc_block_BF+0x210>
  802505:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802508:	8b 00                	mov    (%eax),%eax
  80250a:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80250d:	8b 52 04             	mov    0x4(%edx),%edx
  802510:	89 50 04             	mov    %edx,0x4(%eax)
  802513:	eb 0b                	jmp    802520 <alloc_block_BF+0x21b>
  802515:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802518:	8b 40 04             	mov    0x4(%eax),%eax
  80251b:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802520:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802523:	8b 40 04             	mov    0x4(%eax),%eax
  802526:	85 c0                	test   %eax,%eax
  802528:	74 0f                	je     802539 <alloc_block_BF+0x234>
  80252a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80252d:	8b 40 04             	mov    0x4(%eax),%eax
  802530:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802533:	8b 12                	mov    (%edx),%edx
  802535:	89 10                	mov    %edx,(%eax)
  802537:	eb 0a                	jmp    802543 <alloc_block_BF+0x23e>
  802539:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80253c:	8b 00                	mov    (%eax),%eax
  80253e:	a3 48 41 80 00       	mov    %eax,0x804148
  802543:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802546:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80254c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80254f:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802556:	a1 54 41 80 00       	mov    0x804154,%eax
  80255b:	48                   	dec    %eax
  80255c:	a3 54 41 80 00       	mov    %eax,0x804154
			newblk->size = versize;
  802561:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802564:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802567:	89 50 0c             	mov    %edx,0xc(%eax)
			newblk->sva = newveradd;
  80256a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80256d:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802570:	89 50 08             	mov    %edx,0x8(%eax)
			blk->size = blk->size - versize;
  802573:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802576:	8b 40 0c             	mov    0xc(%eax),%eax
  802579:	2b 45 e8             	sub    -0x18(%ebp),%eax
  80257c:	89 c2                	mov    %eax,%edx
  80257e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802581:	89 50 0c             	mov    %edx,0xc(%eax)
			blk->sva+= newblk->size;
  802584:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802587:	8b 50 08             	mov    0x8(%eax),%edx
  80258a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80258d:	8b 40 0c             	mov    0xc(%eax),%eax
  802590:	01 c2                	add    %eax,%edx
  802592:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802595:	89 50 08             	mov    %edx,0x8(%eax)
			return newblk;
  802598:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80259b:	eb 3b                	jmp    8025d8 <alloc_block_BF+0x2d3>
		{
	       newsize = blk->size;
		   newveradd = blk->sva;
		}
	}
	LIST_FOREACH(blk, &FreeMemBlocksList)
  80259d:	a1 40 41 80 00       	mov    0x804140,%eax
  8025a2:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8025a5:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8025a9:	74 07                	je     8025b2 <alloc_block_BF+0x2ad>
  8025ab:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025ae:	8b 00                	mov    (%eax),%eax
  8025b0:	eb 05                	jmp    8025b7 <alloc_block_BF+0x2b2>
  8025b2:	b8 00 00 00 00       	mov    $0x0,%eax
  8025b7:	a3 40 41 80 00       	mov    %eax,0x804140
  8025bc:	a1 40 41 80 00       	mov    0x804140,%eax
  8025c1:	85 c0                	test   %eax,%eax
  8025c3:	0f 85 f8 fe ff ff    	jne    8024c1 <alloc_block_BF+0x1bc>
  8025c9:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8025cd:	0f 85 ee fe ff ff    	jne    8024c1 <alloc_block_BF+0x1bc>
			blk->size = blk->size - versize;
			blk->sva+= newblk->size;
			return newblk;
		}
	}
	return NULL;
  8025d3:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8025d8:	c9                   	leave  
  8025d9:	c3                   	ret    

008025da <alloc_block_NF>:
//=========================================
// [7] ALLOCATE BLOCK BY NEXT FIT:
//=========================================
struct MemBlock *last_allocate;
struct MemBlock *alloc_block_NF(uint32 size)
{
  8025da:	55                   	push   %ebp
  8025db:	89 e5                	mov    %esp,%ebp
  8025dd:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1 - BONUS] [DYNAMIC ALLOCATOR] alloc_block_NF
	// Write your code here, remove the panic and write your code
	//panic("alloc_block_NF() is not implemented yet...!!");
	uint32 versize = size;
  8025e0:	8b 45 08             	mov    0x8(%ebp),%eax
  8025e3:	89 45 f0             	mov    %eax,-0x10(%ebp)
	struct MemBlock* blk;
	struct MemBlock* newblk = LIST_FIRST(&AvailableMemBlocksList);
  8025e6:	a1 48 41 80 00       	mov    0x804148,%eax
  8025eb:	89 45 ec             	mov    %eax,-0x14(%ebp)

	LIST_FOREACH(blk,&FreeMemBlocksList)
  8025ee:	a1 38 41 80 00       	mov    0x804138,%eax
  8025f3:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8025f6:	e9 77 01 00 00       	jmp    802772 <alloc_block_NF+0x198>
	{
		if(blk->size == versize)
  8025fb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025fe:	8b 40 0c             	mov    0xc(%eax),%eax
  802601:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  802604:	0f 85 8a 00 00 00    	jne    802694 <alloc_block_NF+0xba>
		{
			LIST_REMOVE(&FreeMemBlocksList,blk);
  80260a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80260e:	75 17                	jne    802627 <alloc_block_NF+0x4d>
  802610:	83 ec 04             	sub    $0x4,%esp
  802613:	68 68 37 80 00       	push   $0x803768
  802618:	68 f7 00 00 00       	push   $0xf7
  80261d:	68 f7 36 80 00       	push   $0x8036f7
  802622:	e8 47 06 00 00       	call   802c6e <_panic>
  802627:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80262a:	8b 00                	mov    (%eax),%eax
  80262c:	85 c0                	test   %eax,%eax
  80262e:	74 10                	je     802640 <alloc_block_NF+0x66>
  802630:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802633:	8b 00                	mov    (%eax),%eax
  802635:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802638:	8b 52 04             	mov    0x4(%edx),%edx
  80263b:	89 50 04             	mov    %edx,0x4(%eax)
  80263e:	eb 0b                	jmp    80264b <alloc_block_NF+0x71>
  802640:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802643:	8b 40 04             	mov    0x4(%eax),%eax
  802646:	a3 3c 41 80 00       	mov    %eax,0x80413c
  80264b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80264e:	8b 40 04             	mov    0x4(%eax),%eax
  802651:	85 c0                	test   %eax,%eax
  802653:	74 0f                	je     802664 <alloc_block_NF+0x8a>
  802655:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802658:	8b 40 04             	mov    0x4(%eax),%eax
  80265b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80265e:	8b 12                	mov    (%edx),%edx
  802660:	89 10                	mov    %edx,(%eax)
  802662:	eb 0a                	jmp    80266e <alloc_block_NF+0x94>
  802664:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802667:	8b 00                	mov    (%eax),%eax
  802669:	a3 38 41 80 00       	mov    %eax,0x804138
  80266e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802671:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802677:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80267a:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802681:	a1 44 41 80 00       	mov    0x804144,%eax
  802686:	48                   	dec    %eax
  802687:	a3 44 41 80 00       	mov    %eax,0x804144
			return blk;
  80268c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80268f:	e9 11 01 00 00       	jmp    8027a5 <alloc_block_NF+0x1cb>
		}
		else if(blk->size > versize)
  802694:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802697:	8b 40 0c             	mov    0xc(%eax),%eax
  80269a:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80269d:	0f 86 c7 00 00 00    	jbe    80276a <alloc_block_NF+0x190>
		{
			LIST_REMOVE(&AvailableMemBlocksList,newblk);
  8026a3:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8026a7:	75 17                	jne    8026c0 <alloc_block_NF+0xe6>
  8026a9:	83 ec 04             	sub    $0x4,%esp
  8026ac:	68 68 37 80 00       	push   $0x803768
  8026b1:	68 fc 00 00 00       	push   $0xfc
  8026b6:	68 f7 36 80 00       	push   $0x8036f7
  8026bb:	e8 ae 05 00 00       	call   802c6e <_panic>
  8026c0:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8026c3:	8b 00                	mov    (%eax),%eax
  8026c5:	85 c0                	test   %eax,%eax
  8026c7:	74 10                	je     8026d9 <alloc_block_NF+0xff>
  8026c9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8026cc:	8b 00                	mov    (%eax),%eax
  8026ce:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8026d1:	8b 52 04             	mov    0x4(%edx),%edx
  8026d4:	89 50 04             	mov    %edx,0x4(%eax)
  8026d7:	eb 0b                	jmp    8026e4 <alloc_block_NF+0x10a>
  8026d9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8026dc:	8b 40 04             	mov    0x4(%eax),%eax
  8026df:	a3 4c 41 80 00       	mov    %eax,0x80414c
  8026e4:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8026e7:	8b 40 04             	mov    0x4(%eax),%eax
  8026ea:	85 c0                	test   %eax,%eax
  8026ec:	74 0f                	je     8026fd <alloc_block_NF+0x123>
  8026ee:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8026f1:	8b 40 04             	mov    0x4(%eax),%eax
  8026f4:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8026f7:	8b 12                	mov    (%edx),%edx
  8026f9:	89 10                	mov    %edx,(%eax)
  8026fb:	eb 0a                	jmp    802707 <alloc_block_NF+0x12d>
  8026fd:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802700:	8b 00                	mov    (%eax),%eax
  802702:	a3 48 41 80 00       	mov    %eax,0x804148
  802707:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80270a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802710:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802713:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80271a:	a1 54 41 80 00       	mov    0x804154,%eax
  80271f:	48                   	dec    %eax
  802720:	a3 54 41 80 00       	mov    %eax,0x804154
			newblk->size = versize;
  802725:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802728:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80272b:	89 50 0c             	mov    %edx,0xc(%eax)
			blk->size = blk->size-versize;
  80272e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802731:	8b 40 0c             	mov    0xc(%eax),%eax
  802734:	2b 45 f0             	sub    -0x10(%ebp),%eax
  802737:	89 c2                	mov    %eax,%edx
  802739:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80273c:	89 50 0c             	mov    %edx,0xc(%eax)
			uint32 newveradd = blk->sva;
  80273f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802742:	8b 40 08             	mov    0x8(%eax),%eax
  802745:	89 45 e8             	mov    %eax,-0x18(%ebp)
			blk->sva+=newblk->size;
  802748:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80274b:	8b 50 08             	mov    0x8(%eax),%edx
  80274e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802751:	8b 40 0c             	mov    0xc(%eax),%eax
  802754:	01 c2                	add    %eax,%edx
  802756:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802759:	89 50 08             	mov    %edx,0x8(%eax)
			newblk->sva = newveradd;
  80275c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80275f:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802762:	89 50 08             	mov    %edx,0x8(%eax)
			return newblk;
  802765:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802768:	eb 3b                	jmp    8027a5 <alloc_block_NF+0x1cb>
	//panic("alloc_block_NF() is not implemented yet...!!");
	uint32 versize = size;
	struct MemBlock* blk;
	struct MemBlock* newblk = LIST_FIRST(&AvailableMemBlocksList);

	LIST_FOREACH(blk,&FreeMemBlocksList)
  80276a:	a1 40 41 80 00       	mov    0x804140,%eax
  80276f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802772:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802776:	74 07                	je     80277f <alloc_block_NF+0x1a5>
  802778:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80277b:	8b 00                	mov    (%eax),%eax
  80277d:	eb 05                	jmp    802784 <alloc_block_NF+0x1aa>
  80277f:	b8 00 00 00 00       	mov    $0x0,%eax
  802784:	a3 40 41 80 00       	mov    %eax,0x804140
  802789:	a1 40 41 80 00       	mov    0x804140,%eax
  80278e:	85 c0                	test   %eax,%eax
  802790:	0f 85 65 fe ff ff    	jne    8025fb <alloc_block_NF+0x21>
  802796:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80279a:	0f 85 5b fe ff ff    	jne    8025fb <alloc_block_NF+0x21>
			blk->sva+=newblk->size;
			newblk->sva = newveradd;
			return newblk;
		}
	}
	return NULL;
  8027a0:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8027a5:	c9                   	leave  
  8027a6:	c3                   	ret    

008027a7 <addToAvailMemBlocksList>:

//===================================================
// [8] INSERT BLOCK (SORTED WITH MERGE) IN FREE LIST:
//===================================================
void addToAvailMemBlocksList(struct MemBlock *blockToInsert)
{
  8027a7:	55                   	push   %ebp
  8027a8:	89 e5                	mov    %esp,%ebp
  8027aa:	83 ec 08             	sub    $0x8,%esp
	blockToInsert->sva = 0;
  8027ad:	8b 45 08             	mov    0x8(%ebp),%eax
  8027b0:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
	blockToInsert->size = 0;
  8027b7:	8b 45 08             	mov    0x8(%ebp),%eax
  8027ba:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
	//add to avail
	LIST_INSERT_TAIL(&AvailableMemBlocksList, blockToInsert);
  8027c1:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8027c5:	75 17                	jne    8027de <addToAvailMemBlocksList+0x37>
  8027c7:	83 ec 04             	sub    $0x4,%esp
  8027ca:	68 10 37 80 00       	push   $0x803710
  8027cf:	68 10 01 00 00       	push   $0x110
  8027d4:	68 f7 36 80 00       	push   $0x8036f7
  8027d9:	e8 90 04 00 00       	call   802c6e <_panic>
  8027de:	8b 15 4c 41 80 00    	mov    0x80414c,%edx
  8027e4:	8b 45 08             	mov    0x8(%ebp),%eax
  8027e7:	89 50 04             	mov    %edx,0x4(%eax)
  8027ea:	8b 45 08             	mov    0x8(%ebp),%eax
  8027ed:	8b 40 04             	mov    0x4(%eax),%eax
  8027f0:	85 c0                	test   %eax,%eax
  8027f2:	74 0c                	je     802800 <addToAvailMemBlocksList+0x59>
  8027f4:	a1 4c 41 80 00       	mov    0x80414c,%eax
  8027f9:	8b 55 08             	mov    0x8(%ebp),%edx
  8027fc:	89 10                	mov    %edx,(%eax)
  8027fe:	eb 08                	jmp    802808 <addToAvailMemBlocksList+0x61>
  802800:	8b 45 08             	mov    0x8(%ebp),%eax
  802803:	a3 48 41 80 00       	mov    %eax,0x804148
  802808:	8b 45 08             	mov    0x8(%ebp),%eax
  80280b:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802810:	8b 45 08             	mov    0x8(%ebp),%eax
  802813:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802819:	a1 54 41 80 00       	mov    0x804154,%eax
  80281e:	40                   	inc    %eax
  80281f:	a3 54 41 80 00       	mov    %eax,0x804154
}
  802824:	90                   	nop
  802825:	c9                   	leave  
  802826:	c3                   	ret    

00802827 <insert_sorted_with_merge_freeList>:
void insert_sorted_with_merge_freeList(struct MemBlock *blockToInsert)
{
  802827:	55                   	push   %ebp
  802828:	89 e5                	mov    %esp,%ebp
  80282a:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] insert_sorted_with_merge_freeList
	// Write your code here, remove the panic and write your code

	struct MemBlock* last = LIST_LAST(&FreeMemBlocksList);
  80282d:	a1 3c 41 80 00       	mov    0x80413c,%eax
  802832:	89 45 f0             	mov    %eax,-0x10(%ebp)
	//check if list empty
	if (LIST_SIZE(&(FreeMemBlocksList)) == 0)
  802835:	a1 44 41 80 00       	mov    0x804144,%eax
  80283a:	85 c0                	test   %eax,%eax
  80283c:	75 68                	jne    8028a6 <insert_sorted_with_merge_freeList+0x7f>
		LIST_INSERT_HEAD(&FreeMemBlocksList, blockToInsert);
  80283e:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802842:	75 17                	jne    80285b <insert_sorted_with_merge_freeList+0x34>
  802844:	83 ec 04             	sub    $0x4,%esp
  802847:	68 d4 36 80 00       	push   $0x8036d4
  80284c:	68 1a 01 00 00       	push   $0x11a
  802851:	68 f7 36 80 00       	push   $0x8036f7
  802856:	e8 13 04 00 00       	call   802c6e <_panic>
  80285b:	8b 15 38 41 80 00    	mov    0x804138,%edx
  802861:	8b 45 08             	mov    0x8(%ebp),%eax
  802864:	89 10                	mov    %edx,(%eax)
  802866:	8b 45 08             	mov    0x8(%ebp),%eax
  802869:	8b 00                	mov    (%eax),%eax
  80286b:	85 c0                	test   %eax,%eax
  80286d:	74 0d                	je     80287c <insert_sorted_with_merge_freeList+0x55>
  80286f:	a1 38 41 80 00       	mov    0x804138,%eax
  802874:	8b 55 08             	mov    0x8(%ebp),%edx
  802877:	89 50 04             	mov    %edx,0x4(%eax)
  80287a:	eb 08                	jmp    802884 <insert_sorted_with_merge_freeList+0x5d>
  80287c:	8b 45 08             	mov    0x8(%ebp),%eax
  80287f:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802884:	8b 45 08             	mov    0x8(%ebp),%eax
  802887:	a3 38 41 80 00       	mov    %eax,0x804138
  80288c:	8b 45 08             	mov    0x8(%ebp),%eax
  80288f:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802896:	a1 44 41 80 00       	mov    0x804144,%eax
  80289b:	40                   	inc    %eax
  80289c:	a3 44 41 80 00       	mov    %eax,0x804144
		}
	}

	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  8028a1:	e9 c5 03 00 00       	jmp    802c6b <insert_sorted_with_merge_freeList+0x444>
	struct MemBlock* last = LIST_LAST(&FreeMemBlocksList);
	//check if list empty
	if (LIST_SIZE(&(FreeMemBlocksList)) == 0)
		LIST_INSERT_HEAD(&FreeMemBlocksList, blockToInsert);
	//check if it's position is at last
	else if (last->sva < blockToInsert->sva) {
  8028a6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8028a9:	8b 50 08             	mov    0x8(%eax),%edx
  8028ac:	8b 45 08             	mov    0x8(%ebp),%eax
  8028af:	8b 40 08             	mov    0x8(%eax),%eax
  8028b2:	39 c2                	cmp    %eax,%edx
  8028b4:	0f 83 b2 00 00 00    	jae    80296c <insert_sorted_with_merge_freeList+0x145>

		//if i have to merge
		if (last->sva + last->size == blockToInsert->sva) {
  8028ba:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8028bd:	8b 50 08             	mov    0x8(%eax),%edx
  8028c0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8028c3:	8b 40 0c             	mov    0xc(%eax),%eax
  8028c6:	01 c2                	add    %eax,%edx
  8028c8:	8b 45 08             	mov    0x8(%ebp),%eax
  8028cb:	8b 40 08             	mov    0x8(%eax),%eax
  8028ce:	39 c2                	cmp    %eax,%edx
  8028d0:	75 27                	jne    8028f9 <insert_sorted_with_merge_freeList+0xd2>
			last->size = last->size + blockToInsert->size;
  8028d2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8028d5:	8b 50 0c             	mov    0xc(%eax),%edx
  8028d8:	8b 45 08             	mov    0x8(%ebp),%eax
  8028db:	8b 40 0c             	mov    0xc(%eax),%eax
  8028de:	01 c2                	add    %eax,%edx
  8028e0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8028e3:	89 50 0c             	mov    %edx,0xc(%eax)
			addToAvailMemBlocksList(blockToInsert);
  8028e6:	83 ec 0c             	sub    $0xc,%esp
  8028e9:	ff 75 08             	pushl  0x8(%ebp)
  8028ec:	e8 b6 fe ff ff       	call   8027a7 <addToAvailMemBlocksList>
  8028f1:	83 c4 10             	add    $0x10,%esp
		}
	}

	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  8028f4:	e9 72 03 00 00       	jmp    802c6b <insert_sorted_with_merge_freeList+0x444>
		if (last->sva + last->size == blockToInsert->sva) {
			last->size = last->size + blockToInsert->size;
			addToAvailMemBlocksList(blockToInsert);

		} else {
			LIST_INSERT_AFTER(&FreeMemBlocksList, last, blockToInsert);
  8028f9:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8028fd:	74 06                	je     802905 <insert_sorted_with_merge_freeList+0xde>
  8028ff:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802903:	75 17                	jne    80291c <insert_sorted_with_merge_freeList+0xf5>
  802905:	83 ec 04             	sub    $0x4,%esp
  802908:	68 34 37 80 00       	push   $0x803734
  80290d:	68 24 01 00 00       	push   $0x124
  802912:	68 f7 36 80 00       	push   $0x8036f7
  802917:	e8 52 03 00 00       	call   802c6e <_panic>
  80291c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80291f:	8b 10                	mov    (%eax),%edx
  802921:	8b 45 08             	mov    0x8(%ebp),%eax
  802924:	89 10                	mov    %edx,(%eax)
  802926:	8b 45 08             	mov    0x8(%ebp),%eax
  802929:	8b 00                	mov    (%eax),%eax
  80292b:	85 c0                	test   %eax,%eax
  80292d:	74 0b                	je     80293a <insert_sorted_with_merge_freeList+0x113>
  80292f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802932:	8b 00                	mov    (%eax),%eax
  802934:	8b 55 08             	mov    0x8(%ebp),%edx
  802937:	89 50 04             	mov    %edx,0x4(%eax)
  80293a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80293d:	8b 55 08             	mov    0x8(%ebp),%edx
  802940:	89 10                	mov    %edx,(%eax)
  802942:	8b 45 08             	mov    0x8(%ebp),%eax
  802945:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802948:	89 50 04             	mov    %edx,0x4(%eax)
  80294b:	8b 45 08             	mov    0x8(%ebp),%eax
  80294e:	8b 00                	mov    (%eax),%eax
  802950:	85 c0                	test   %eax,%eax
  802952:	75 08                	jne    80295c <insert_sorted_with_merge_freeList+0x135>
  802954:	8b 45 08             	mov    0x8(%ebp),%eax
  802957:	a3 3c 41 80 00       	mov    %eax,0x80413c
  80295c:	a1 44 41 80 00       	mov    0x804144,%eax
  802961:	40                   	inc    %eax
  802962:	a3 44 41 80 00       	mov    %eax,0x804144
		}
	}

	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  802967:	e9 ff 02 00 00       	jmp    802c6b <insert_sorted_with_merge_freeList+0x444>
		} else {
			LIST_INSERT_AFTER(&FreeMemBlocksList, last, blockToInsert);
		}
	} else {
		struct MemBlock *iterator;
		LIST_FOREACH(iterator, &(FreeMemBlocksList))
  80296c:	a1 38 41 80 00       	mov    0x804138,%eax
  802971:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802974:	e9 c2 02 00 00       	jmp    802c3b <insert_sorted_with_merge_freeList+0x414>
		{

			if (iterator->sva > blockToInsert->sva) {
  802979:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80297c:	8b 50 08             	mov    0x8(%eax),%edx
  80297f:	8b 45 08             	mov    0x8(%ebp),%eax
  802982:	8b 40 08             	mov    0x8(%eax),%eax
  802985:	39 c2                	cmp    %eax,%edx
  802987:	0f 86 a6 02 00 00    	jbe    802c33 <insert_sorted_with_merge_freeList+0x40c>

				struct MemBlock* prev = LIST_PREV(iterator);
  80298d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802990:	8b 40 04             	mov    0x4(%eax),%eax
  802993:	89 45 ec             	mov    %eax,-0x14(%ebp)
				if (prev == NULL) {
  802996:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  80299a:	0f 85 ba 00 00 00    	jne    802a5a <insert_sorted_with_merge_freeList+0x233>
					//check merge
					if (blockToInsert->size + blockToInsert->sva
  8029a0:	8b 45 08             	mov    0x8(%ebp),%eax
  8029a3:	8b 50 0c             	mov    0xc(%eax),%edx
  8029a6:	8b 45 08             	mov    0x8(%ebp),%eax
  8029a9:	8b 40 08             	mov    0x8(%eax),%eax
  8029ac:	01 c2                	add    %eax,%edx
							== iterator->sva) {
  8029ae:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029b1:	8b 40 08             	mov    0x8(%eax),%eax
			if (iterator->sva > blockToInsert->sva) {

				struct MemBlock* prev = LIST_PREV(iterator);
				if (prev == NULL) {
					//check merge
					if (blockToInsert->size + blockToInsert->sva
  8029b4:	39 c2                	cmp    %eax,%edx
  8029b6:	75 33                	jne    8029eb <insert_sorted_with_merge_freeList+0x1c4>
							== iterator->sva) {
						iterator->sva = blockToInsert->sva;
  8029b8:	8b 45 08             	mov    0x8(%ebp),%eax
  8029bb:	8b 50 08             	mov    0x8(%eax),%edx
  8029be:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029c1:	89 50 08             	mov    %edx,0x8(%eax)
						iterator->size = iterator->size + blockToInsert->size;
  8029c4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029c7:	8b 50 0c             	mov    0xc(%eax),%edx
  8029ca:	8b 45 08             	mov    0x8(%ebp),%eax
  8029cd:	8b 40 0c             	mov    0xc(%eax),%eax
  8029d0:	01 c2                	add    %eax,%edx
  8029d2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029d5:	89 50 0c             	mov    %edx,0xc(%eax)
						addToAvailMemBlocksList(blockToInsert);
  8029d8:	83 ec 0c             	sub    $0xc,%esp
  8029db:	ff 75 08             	pushl  0x8(%ebp)
  8029de:	e8 c4 fd ff ff       	call   8027a7 <addToAvailMemBlocksList>
  8029e3:	83 c4 10             	add    $0x10,%esp

					else {
						LIST_INSERT_BEFORE(&FreeMemBlocksList, iterator,
								blockToInsert);
					}
					break;
  8029e6:	e9 80 02 00 00       	jmp    802c6b <insert_sorted_with_merge_freeList+0x444>
						addToAvailMemBlocksList(blockToInsert);

					}

					else {
						LIST_INSERT_BEFORE(&FreeMemBlocksList, iterator,
  8029eb:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8029ef:	74 06                	je     8029f7 <insert_sorted_with_merge_freeList+0x1d0>
  8029f1:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8029f5:	75 17                	jne    802a0e <insert_sorted_with_merge_freeList+0x1e7>
  8029f7:	83 ec 04             	sub    $0x4,%esp
  8029fa:	68 88 37 80 00       	push   $0x803788
  8029ff:	68 3a 01 00 00       	push   $0x13a
  802a04:	68 f7 36 80 00       	push   $0x8036f7
  802a09:	e8 60 02 00 00       	call   802c6e <_panic>
  802a0e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a11:	8b 50 04             	mov    0x4(%eax),%edx
  802a14:	8b 45 08             	mov    0x8(%ebp),%eax
  802a17:	89 50 04             	mov    %edx,0x4(%eax)
  802a1a:	8b 45 08             	mov    0x8(%ebp),%eax
  802a1d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802a20:	89 10                	mov    %edx,(%eax)
  802a22:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a25:	8b 40 04             	mov    0x4(%eax),%eax
  802a28:	85 c0                	test   %eax,%eax
  802a2a:	74 0d                	je     802a39 <insert_sorted_with_merge_freeList+0x212>
  802a2c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a2f:	8b 40 04             	mov    0x4(%eax),%eax
  802a32:	8b 55 08             	mov    0x8(%ebp),%edx
  802a35:	89 10                	mov    %edx,(%eax)
  802a37:	eb 08                	jmp    802a41 <insert_sorted_with_merge_freeList+0x21a>
  802a39:	8b 45 08             	mov    0x8(%ebp),%eax
  802a3c:	a3 38 41 80 00       	mov    %eax,0x804138
  802a41:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a44:	8b 55 08             	mov    0x8(%ebp),%edx
  802a47:	89 50 04             	mov    %edx,0x4(%eax)
  802a4a:	a1 44 41 80 00       	mov    0x804144,%eax
  802a4f:	40                   	inc    %eax
  802a50:	a3 44 41 80 00       	mov    %eax,0x804144
								blockToInsert);
					}
					break;
  802a55:	e9 11 02 00 00       	jmp    802c6b <insert_sorted_with_merge_freeList+0x444>
				} else {
					//prev and next merge
					if (prev->sva + prev->size + blockToInsert->size
  802a5a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802a5d:	8b 50 08             	mov    0x8(%eax),%edx
  802a60:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802a63:	8b 40 0c             	mov    0xc(%eax),%eax
  802a66:	01 c2                	add    %eax,%edx
  802a68:	8b 45 08             	mov    0x8(%ebp),%eax
  802a6b:	8b 40 0c             	mov    0xc(%eax),%eax
  802a6e:	01 c2                	add    %eax,%edx
							== iterator->sva) {
  802a70:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a73:	8b 40 08             	mov    0x8(%eax),%eax
								blockToInsert);
					}
					break;
				} else {
					//prev and next merge
					if (prev->sva + prev->size + blockToInsert->size
  802a76:	39 c2                	cmp    %eax,%edx
  802a78:	0f 85 bf 00 00 00    	jne    802b3d <insert_sorted_with_merge_freeList+0x316>
							== iterator->sva) {
						prev->size = prev->size + blockToInsert->size
  802a7e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802a81:	8b 50 0c             	mov    0xc(%eax),%edx
  802a84:	8b 45 08             	mov    0x8(%ebp),%eax
  802a87:	8b 40 0c             	mov    0xc(%eax),%eax
  802a8a:	01 c2                	add    %eax,%edx
								+ iterator->size;
  802a8c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a8f:	8b 40 0c             	mov    0xc(%eax),%eax
  802a92:	01 c2                	add    %eax,%edx
					break;
				} else {
					//prev and next merge
					if (prev->sva + prev->size + blockToInsert->size
							== iterator->sva) {
						prev->size = prev->size + blockToInsert->size
  802a94:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802a97:	89 50 0c             	mov    %edx,0xc(%eax)
								+ iterator->size;
						LIST_REMOVE(&FreeMemBlocksList, iterator);
  802a9a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802a9e:	75 17                	jne    802ab7 <insert_sorted_with_merge_freeList+0x290>
  802aa0:	83 ec 04             	sub    $0x4,%esp
  802aa3:	68 68 37 80 00       	push   $0x803768
  802aa8:	68 43 01 00 00       	push   $0x143
  802aad:	68 f7 36 80 00       	push   $0x8036f7
  802ab2:	e8 b7 01 00 00       	call   802c6e <_panic>
  802ab7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802aba:	8b 00                	mov    (%eax),%eax
  802abc:	85 c0                	test   %eax,%eax
  802abe:	74 10                	je     802ad0 <insert_sorted_with_merge_freeList+0x2a9>
  802ac0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ac3:	8b 00                	mov    (%eax),%eax
  802ac5:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802ac8:	8b 52 04             	mov    0x4(%edx),%edx
  802acb:	89 50 04             	mov    %edx,0x4(%eax)
  802ace:	eb 0b                	jmp    802adb <insert_sorted_with_merge_freeList+0x2b4>
  802ad0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ad3:	8b 40 04             	mov    0x4(%eax),%eax
  802ad6:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802adb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ade:	8b 40 04             	mov    0x4(%eax),%eax
  802ae1:	85 c0                	test   %eax,%eax
  802ae3:	74 0f                	je     802af4 <insert_sorted_with_merge_freeList+0x2cd>
  802ae5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ae8:	8b 40 04             	mov    0x4(%eax),%eax
  802aeb:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802aee:	8b 12                	mov    (%edx),%edx
  802af0:	89 10                	mov    %edx,(%eax)
  802af2:	eb 0a                	jmp    802afe <insert_sorted_with_merge_freeList+0x2d7>
  802af4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802af7:	8b 00                	mov    (%eax),%eax
  802af9:	a3 38 41 80 00       	mov    %eax,0x804138
  802afe:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b01:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802b07:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b0a:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802b11:	a1 44 41 80 00       	mov    0x804144,%eax
  802b16:	48                   	dec    %eax
  802b17:	a3 44 41 80 00       	mov    %eax,0x804144
						addToAvailMemBlocksList(blockToInsert);
  802b1c:	83 ec 0c             	sub    $0xc,%esp
  802b1f:	ff 75 08             	pushl  0x8(%ebp)
  802b22:	e8 80 fc ff ff       	call   8027a7 <addToAvailMemBlocksList>
  802b27:	83 c4 10             	add    $0x10,%esp
						addToAvailMemBlocksList(iterator);
  802b2a:	83 ec 0c             	sub    $0xc,%esp
  802b2d:	ff 75 f4             	pushl  -0xc(%ebp)
  802b30:	e8 72 fc ff ff       	call   8027a7 <addToAvailMemBlocksList>
  802b35:	83 c4 10             	add    $0x10,%esp
					//Insert
					else {
						LIST_INSERT_BEFORE(&FreeMemBlocksList, iterator,
								blockToInsert);
					}
					break;
  802b38:	e9 2e 01 00 00       	jmp    802c6b <insert_sorted_with_merge_freeList+0x444>
						LIST_REMOVE(&FreeMemBlocksList, iterator);
						addToAvailMemBlocksList(blockToInsert);
						addToAvailMemBlocksList(iterator);
					}
					//previous merge
					else if (prev->sva + prev->size == blockToInsert->sva) {
  802b3d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802b40:	8b 50 08             	mov    0x8(%eax),%edx
  802b43:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802b46:	8b 40 0c             	mov    0xc(%eax),%eax
  802b49:	01 c2                	add    %eax,%edx
  802b4b:	8b 45 08             	mov    0x8(%ebp),%eax
  802b4e:	8b 40 08             	mov    0x8(%eax),%eax
  802b51:	39 c2                	cmp    %eax,%edx
  802b53:	75 27                	jne    802b7c <insert_sorted_with_merge_freeList+0x355>
						prev->size = prev->size + blockToInsert->size;
  802b55:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802b58:	8b 50 0c             	mov    0xc(%eax),%edx
  802b5b:	8b 45 08             	mov    0x8(%ebp),%eax
  802b5e:	8b 40 0c             	mov    0xc(%eax),%eax
  802b61:	01 c2                	add    %eax,%edx
  802b63:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802b66:	89 50 0c             	mov    %edx,0xc(%eax)
						addToAvailMemBlocksList(blockToInsert);
  802b69:	83 ec 0c             	sub    $0xc,%esp
  802b6c:	ff 75 08             	pushl  0x8(%ebp)
  802b6f:	e8 33 fc ff ff       	call   8027a7 <addToAvailMemBlocksList>
  802b74:	83 c4 10             	add    $0x10,%esp
					//Insert
					else {
						LIST_INSERT_BEFORE(&FreeMemBlocksList, iterator,
								blockToInsert);
					}
					break;
  802b77:	e9 ef 00 00 00       	jmp    802c6b <insert_sorted_with_merge_freeList+0x444>
					else if (prev->sva + prev->size == blockToInsert->sva) {
						prev->size = prev->size + blockToInsert->size;
						addToAvailMemBlocksList(blockToInsert);
					}
					//next merge
					else if (blockToInsert->size + blockToInsert->sva
  802b7c:	8b 45 08             	mov    0x8(%ebp),%eax
  802b7f:	8b 50 0c             	mov    0xc(%eax),%edx
  802b82:	8b 45 08             	mov    0x8(%ebp),%eax
  802b85:	8b 40 08             	mov    0x8(%eax),%eax
  802b88:	01 c2                	add    %eax,%edx
							== iterator->sva) {
  802b8a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b8d:	8b 40 08             	mov    0x8(%eax),%eax
					else if (prev->sva + prev->size == blockToInsert->sva) {
						prev->size = prev->size + blockToInsert->size;
						addToAvailMemBlocksList(blockToInsert);
					}
					//next merge
					else if (blockToInsert->size + blockToInsert->sva
  802b90:	39 c2                	cmp    %eax,%edx
  802b92:	75 33                	jne    802bc7 <insert_sorted_with_merge_freeList+0x3a0>
							== iterator->sva) {
						iterator->sva = blockToInsert->sva;
  802b94:	8b 45 08             	mov    0x8(%ebp),%eax
  802b97:	8b 50 08             	mov    0x8(%eax),%edx
  802b9a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b9d:	89 50 08             	mov    %edx,0x8(%eax)
						iterator->size = iterator->size + blockToInsert->size;
  802ba0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ba3:	8b 50 0c             	mov    0xc(%eax),%edx
  802ba6:	8b 45 08             	mov    0x8(%ebp),%eax
  802ba9:	8b 40 0c             	mov    0xc(%eax),%eax
  802bac:	01 c2                	add    %eax,%edx
  802bae:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bb1:	89 50 0c             	mov    %edx,0xc(%eax)
						addToAvailMemBlocksList(blockToInsert);
  802bb4:	83 ec 0c             	sub    $0xc,%esp
  802bb7:	ff 75 08             	pushl  0x8(%ebp)
  802bba:	e8 e8 fb ff ff       	call   8027a7 <addToAvailMemBlocksList>
  802bbf:	83 c4 10             	add    $0x10,%esp
					//Insert
					else {
						LIST_INSERT_BEFORE(&FreeMemBlocksList, iterator,
								blockToInsert);
					}
					break;
  802bc2:	e9 a4 00 00 00       	jmp    802c6b <insert_sorted_with_merge_freeList+0x444>
						iterator->size = iterator->size + blockToInsert->size;
						addToAvailMemBlocksList(blockToInsert);
					}
					//Insert
					else {
						LIST_INSERT_BEFORE(&FreeMemBlocksList, iterator,
  802bc7:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802bcb:	74 06                	je     802bd3 <insert_sorted_with_merge_freeList+0x3ac>
  802bcd:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802bd1:	75 17                	jne    802bea <insert_sorted_with_merge_freeList+0x3c3>
  802bd3:	83 ec 04             	sub    $0x4,%esp
  802bd6:	68 88 37 80 00       	push   $0x803788
  802bdb:	68 56 01 00 00       	push   $0x156
  802be0:	68 f7 36 80 00       	push   $0x8036f7
  802be5:	e8 84 00 00 00       	call   802c6e <_panic>
  802bea:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bed:	8b 50 04             	mov    0x4(%eax),%edx
  802bf0:	8b 45 08             	mov    0x8(%ebp),%eax
  802bf3:	89 50 04             	mov    %edx,0x4(%eax)
  802bf6:	8b 45 08             	mov    0x8(%ebp),%eax
  802bf9:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802bfc:	89 10                	mov    %edx,(%eax)
  802bfe:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c01:	8b 40 04             	mov    0x4(%eax),%eax
  802c04:	85 c0                	test   %eax,%eax
  802c06:	74 0d                	je     802c15 <insert_sorted_with_merge_freeList+0x3ee>
  802c08:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c0b:	8b 40 04             	mov    0x4(%eax),%eax
  802c0e:	8b 55 08             	mov    0x8(%ebp),%edx
  802c11:	89 10                	mov    %edx,(%eax)
  802c13:	eb 08                	jmp    802c1d <insert_sorted_with_merge_freeList+0x3f6>
  802c15:	8b 45 08             	mov    0x8(%ebp),%eax
  802c18:	a3 38 41 80 00       	mov    %eax,0x804138
  802c1d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c20:	8b 55 08             	mov    0x8(%ebp),%edx
  802c23:	89 50 04             	mov    %edx,0x4(%eax)
  802c26:	a1 44 41 80 00       	mov    0x804144,%eax
  802c2b:	40                   	inc    %eax
  802c2c:	a3 44 41 80 00       	mov    %eax,0x804144
								blockToInsert);
					}
					break;
  802c31:	eb 38                	jmp    802c6b <insert_sorted_with_merge_freeList+0x444>
		} else {
			LIST_INSERT_AFTER(&FreeMemBlocksList, last, blockToInsert);
		}
	} else {
		struct MemBlock *iterator;
		LIST_FOREACH(iterator, &(FreeMemBlocksList))
  802c33:	a1 40 41 80 00       	mov    0x804140,%eax
  802c38:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802c3b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802c3f:	74 07                	je     802c48 <insert_sorted_with_merge_freeList+0x421>
  802c41:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c44:	8b 00                	mov    (%eax),%eax
  802c46:	eb 05                	jmp    802c4d <insert_sorted_with_merge_freeList+0x426>
  802c48:	b8 00 00 00 00       	mov    $0x0,%eax
  802c4d:	a3 40 41 80 00       	mov    %eax,0x804140
  802c52:	a1 40 41 80 00       	mov    0x804140,%eax
  802c57:	85 c0                	test   %eax,%eax
  802c59:	0f 85 1a fd ff ff    	jne    802979 <insert_sorted_with_merge_freeList+0x152>
  802c5f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802c63:	0f 85 10 fd ff ff    	jne    802979 <insert_sorted_with_merge_freeList+0x152>
		}
	}

	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  802c69:	eb 00                	jmp    802c6b <insert_sorted_with_merge_freeList+0x444>
  802c6b:	90                   	nop
  802c6c:	c9                   	leave  
  802c6d:	c3                   	ret    

00802c6e <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  802c6e:	55                   	push   %ebp
  802c6f:	89 e5                	mov    %esp,%ebp
  802c71:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  802c74:	8d 45 10             	lea    0x10(%ebp),%eax
  802c77:	83 c0 04             	add    $0x4,%eax
  802c7a:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  802c7d:	a1 60 41 80 00       	mov    0x804160,%eax
  802c82:	85 c0                	test   %eax,%eax
  802c84:	74 16                	je     802c9c <_panic+0x2e>
		cprintf("%s: ", argv0);
  802c86:	a1 60 41 80 00       	mov    0x804160,%eax
  802c8b:	83 ec 08             	sub    $0x8,%esp
  802c8e:	50                   	push   %eax
  802c8f:	68 c0 37 80 00       	push   $0x8037c0
  802c94:	e8 af d6 ff ff       	call   800348 <cprintf>
  802c99:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  802c9c:	a1 00 40 80 00       	mov    0x804000,%eax
  802ca1:	ff 75 0c             	pushl  0xc(%ebp)
  802ca4:	ff 75 08             	pushl  0x8(%ebp)
  802ca7:	50                   	push   %eax
  802ca8:	68 c5 37 80 00       	push   $0x8037c5
  802cad:	e8 96 d6 ff ff       	call   800348 <cprintf>
  802cb2:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  802cb5:	8b 45 10             	mov    0x10(%ebp),%eax
  802cb8:	83 ec 08             	sub    $0x8,%esp
  802cbb:	ff 75 f4             	pushl  -0xc(%ebp)
  802cbe:	50                   	push   %eax
  802cbf:	e8 19 d6 ff ff       	call   8002dd <vcprintf>
  802cc4:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  802cc7:	83 ec 08             	sub    $0x8,%esp
  802cca:	6a 00                	push   $0x0
  802ccc:	68 e1 37 80 00       	push   $0x8037e1
  802cd1:	e8 07 d6 ff ff       	call   8002dd <vcprintf>
  802cd6:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  802cd9:	e8 88 d5 ff ff       	call   800266 <exit>

	// should not return here
	while (1) ;
  802cde:	eb fe                	jmp    802cde <_panic+0x70>

00802ce0 <CheckWSWithoutLastIndex>:
}

void CheckWSWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  802ce0:	55                   	push   %ebp
  802ce1:	89 e5                	mov    %esp,%ebp
  802ce3:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  802ce6:	a1 20 40 80 00       	mov    0x804020,%eax
  802ceb:	8b 50 74             	mov    0x74(%eax),%edx
  802cee:	8b 45 0c             	mov    0xc(%ebp),%eax
  802cf1:	39 c2                	cmp    %eax,%edx
  802cf3:	74 14                	je     802d09 <CheckWSWithoutLastIndex+0x29>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  802cf5:	83 ec 04             	sub    $0x4,%esp
  802cf8:	68 e4 37 80 00       	push   $0x8037e4
  802cfd:	6a 26                	push   $0x26
  802cff:	68 30 38 80 00       	push   $0x803830
  802d04:	e8 65 ff ff ff       	call   802c6e <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  802d09:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  802d10:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  802d17:	e9 c2 00 00 00       	jmp    802dde <CheckWSWithoutLastIndex+0xfe>
		if (expectedPages[e] == 0) {
  802d1c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d1f:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  802d26:	8b 45 08             	mov    0x8(%ebp),%eax
  802d29:	01 d0                	add    %edx,%eax
  802d2b:	8b 00                	mov    (%eax),%eax
  802d2d:	85 c0                	test   %eax,%eax
  802d2f:	75 08                	jne    802d39 <CheckWSWithoutLastIndex+0x59>
			expectedNumOfEmptyLocs++;
  802d31:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  802d34:	e9 a2 00 00 00       	jmp    802ddb <CheckWSWithoutLastIndex+0xfb>
		}
		int found = 0;
  802d39:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  802d40:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  802d47:	eb 69                	jmp    802db2 <CheckWSWithoutLastIndex+0xd2>
			if (myEnv->__uptr_pws[w].empty == 0) {
  802d49:	a1 20 40 80 00       	mov    0x804020,%eax
  802d4e:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  802d54:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802d57:	89 d0                	mov    %edx,%eax
  802d59:	01 c0                	add    %eax,%eax
  802d5b:	01 d0                	add    %edx,%eax
  802d5d:	c1 e0 03             	shl    $0x3,%eax
  802d60:	01 c8                	add    %ecx,%eax
  802d62:	8a 40 04             	mov    0x4(%eax),%al
  802d65:	84 c0                	test   %al,%al
  802d67:	75 46                	jne    802daf <CheckWSWithoutLastIndex+0xcf>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  802d69:	a1 20 40 80 00       	mov    0x804020,%eax
  802d6e:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  802d74:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802d77:	89 d0                	mov    %edx,%eax
  802d79:	01 c0                	add    %eax,%eax
  802d7b:	01 d0                	add    %edx,%eax
  802d7d:	c1 e0 03             	shl    $0x3,%eax
  802d80:	01 c8                	add    %ecx,%eax
  802d82:	8b 00                	mov    (%eax),%eax
  802d84:	89 45 dc             	mov    %eax,-0x24(%ebp)
  802d87:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802d8a:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  802d8f:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  802d91:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d94:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  802d9b:	8b 45 08             	mov    0x8(%ebp),%eax
  802d9e:	01 c8                	add    %ecx,%eax
  802da0:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  802da2:	39 c2                	cmp    %eax,%edx
  802da4:	75 09                	jne    802daf <CheckWSWithoutLastIndex+0xcf>
						== expectedPages[e]) {
					found = 1;
  802da6:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  802dad:	eb 12                	jmp    802dc1 <CheckWSWithoutLastIndex+0xe1>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  802daf:	ff 45 e8             	incl   -0x18(%ebp)
  802db2:	a1 20 40 80 00       	mov    0x804020,%eax
  802db7:	8b 50 74             	mov    0x74(%eax),%edx
  802dba:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802dbd:	39 c2                	cmp    %eax,%edx
  802dbf:	77 88                	ja     802d49 <CheckWSWithoutLastIndex+0x69>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  802dc1:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802dc5:	75 14                	jne    802ddb <CheckWSWithoutLastIndex+0xfb>
			panic(
  802dc7:	83 ec 04             	sub    $0x4,%esp
  802dca:	68 3c 38 80 00       	push   $0x80383c
  802dcf:	6a 3a                	push   $0x3a
  802dd1:	68 30 38 80 00       	push   $0x803830
  802dd6:	e8 93 fe ff ff       	call   802c6e <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  802ddb:	ff 45 f0             	incl   -0x10(%ebp)
  802dde:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802de1:	3b 45 0c             	cmp    0xc(%ebp),%eax
  802de4:	0f 8c 32 ff ff ff    	jl     802d1c <CheckWSWithoutLastIndex+0x3c>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  802dea:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  802df1:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  802df8:	eb 26                	jmp    802e20 <CheckWSWithoutLastIndex+0x140>
		if (myEnv->__uptr_pws[w].empty == 1) {
  802dfa:	a1 20 40 80 00       	mov    0x804020,%eax
  802dff:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  802e05:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802e08:	89 d0                	mov    %edx,%eax
  802e0a:	01 c0                	add    %eax,%eax
  802e0c:	01 d0                	add    %edx,%eax
  802e0e:	c1 e0 03             	shl    $0x3,%eax
  802e11:	01 c8                	add    %ecx,%eax
  802e13:	8a 40 04             	mov    0x4(%eax),%al
  802e16:	3c 01                	cmp    $0x1,%al
  802e18:	75 03                	jne    802e1d <CheckWSWithoutLastIndex+0x13d>
			actualNumOfEmptyLocs++;
  802e1a:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  802e1d:	ff 45 e0             	incl   -0x20(%ebp)
  802e20:	a1 20 40 80 00       	mov    0x804020,%eax
  802e25:	8b 50 74             	mov    0x74(%eax),%edx
  802e28:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802e2b:	39 c2                	cmp    %eax,%edx
  802e2d:	77 cb                	ja     802dfa <CheckWSWithoutLastIndex+0x11a>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  802e2f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e32:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  802e35:	74 14                	je     802e4b <CheckWSWithoutLastIndex+0x16b>
		panic(
  802e37:	83 ec 04             	sub    $0x4,%esp
  802e3a:	68 90 38 80 00       	push   $0x803890
  802e3f:	6a 44                	push   $0x44
  802e41:	68 30 38 80 00       	push   $0x803830
  802e46:	e8 23 fe ff ff       	call   802c6e <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  802e4b:	90                   	nop
  802e4c:	c9                   	leave  
  802e4d:	c3                   	ret    
  802e4e:	66 90                	xchg   %ax,%ax

00802e50 <__udivdi3>:
  802e50:	55                   	push   %ebp
  802e51:	57                   	push   %edi
  802e52:	56                   	push   %esi
  802e53:	53                   	push   %ebx
  802e54:	83 ec 1c             	sub    $0x1c,%esp
  802e57:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  802e5b:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  802e5f:	8b 7c 24 38          	mov    0x38(%esp),%edi
  802e63:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  802e67:	89 ca                	mov    %ecx,%edx
  802e69:	89 f8                	mov    %edi,%eax
  802e6b:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  802e6f:	85 f6                	test   %esi,%esi
  802e71:	75 2d                	jne    802ea0 <__udivdi3+0x50>
  802e73:	39 cf                	cmp    %ecx,%edi
  802e75:	77 65                	ja     802edc <__udivdi3+0x8c>
  802e77:	89 fd                	mov    %edi,%ebp
  802e79:	85 ff                	test   %edi,%edi
  802e7b:	75 0b                	jne    802e88 <__udivdi3+0x38>
  802e7d:	b8 01 00 00 00       	mov    $0x1,%eax
  802e82:	31 d2                	xor    %edx,%edx
  802e84:	f7 f7                	div    %edi
  802e86:	89 c5                	mov    %eax,%ebp
  802e88:	31 d2                	xor    %edx,%edx
  802e8a:	89 c8                	mov    %ecx,%eax
  802e8c:	f7 f5                	div    %ebp
  802e8e:	89 c1                	mov    %eax,%ecx
  802e90:	89 d8                	mov    %ebx,%eax
  802e92:	f7 f5                	div    %ebp
  802e94:	89 cf                	mov    %ecx,%edi
  802e96:	89 fa                	mov    %edi,%edx
  802e98:	83 c4 1c             	add    $0x1c,%esp
  802e9b:	5b                   	pop    %ebx
  802e9c:	5e                   	pop    %esi
  802e9d:	5f                   	pop    %edi
  802e9e:	5d                   	pop    %ebp
  802e9f:	c3                   	ret    
  802ea0:	39 ce                	cmp    %ecx,%esi
  802ea2:	77 28                	ja     802ecc <__udivdi3+0x7c>
  802ea4:	0f bd fe             	bsr    %esi,%edi
  802ea7:	83 f7 1f             	xor    $0x1f,%edi
  802eaa:	75 40                	jne    802eec <__udivdi3+0x9c>
  802eac:	39 ce                	cmp    %ecx,%esi
  802eae:	72 0a                	jb     802eba <__udivdi3+0x6a>
  802eb0:	3b 44 24 08          	cmp    0x8(%esp),%eax
  802eb4:	0f 87 9e 00 00 00    	ja     802f58 <__udivdi3+0x108>
  802eba:	b8 01 00 00 00       	mov    $0x1,%eax
  802ebf:	89 fa                	mov    %edi,%edx
  802ec1:	83 c4 1c             	add    $0x1c,%esp
  802ec4:	5b                   	pop    %ebx
  802ec5:	5e                   	pop    %esi
  802ec6:	5f                   	pop    %edi
  802ec7:	5d                   	pop    %ebp
  802ec8:	c3                   	ret    
  802ec9:	8d 76 00             	lea    0x0(%esi),%esi
  802ecc:	31 ff                	xor    %edi,%edi
  802ece:	31 c0                	xor    %eax,%eax
  802ed0:	89 fa                	mov    %edi,%edx
  802ed2:	83 c4 1c             	add    $0x1c,%esp
  802ed5:	5b                   	pop    %ebx
  802ed6:	5e                   	pop    %esi
  802ed7:	5f                   	pop    %edi
  802ed8:	5d                   	pop    %ebp
  802ed9:	c3                   	ret    
  802eda:	66 90                	xchg   %ax,%ax
  802edc:	89 d8                	mov    %ebx,%eax
  802ede:	f7 f7                	div    %edi
  802ee0:	31 ff                	xor    %edi,%edi
  802ee2:	89 fa                	mov    %edi,%edx
  802ee4:	83 c4 1c             	add    $0x1c,%esp
  802ee7:	5b                   	pop    %ebx
  802ee8:	5e                   	pop    %esi
  802ee9:	5f                   	pop    %edi
  802eea:	5d                   	pop    %ebp
  802eeb:	c3                   	ret    
  802eec:	bd 20 00 00 00       	mov    $0x20,%ebp
  802ef1:	89 eb                	mov    %ebp,%ebx
  802ef3:	29 fb                	sub    %edi,%ebx
  802ef5:	89 f9                	mov    %edi,%ecx
  802ef7:	d3 e6                	shl    %cl,%esi
  802ef9:	89 c5                	mov    %eax,%ebp
  802efb:	88 d9                	mov    %bl,%cl
  802efd:	d3 ed                	shr    %cl,%ebp
  802eff:	89 e9                	mov    %ebp,%ecx
  802f01:	09 f1                	or     %esi,%ecx
  802f03:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  802f07:	89 f9                	mov    %edi,%ecx
  802f09:	d3 e0                	shl    %cl,%eax
  802f0b:	89 c5                	mov    %eax,%ebp
  802f0d:	89 d6                	mov    %edx,%esi
  802f0f:	88 d9                	mov    %bl,%cl
  802f11:	d3 ee                	shr    %cl,%esi
  802f13:	89 f9                	mov    %edi,%ecx
  802f15:	d3 e2                	shl    %cl,%edx
  802f17:	8b 44 24 08          	mov    0x8(%esp),%eax
  802f1b:	88 d9                	mov    %bl,%cl
  802f1d:	d3 e8                	shr    %cl,%eax
  802f1f:	09 c2                	or     %eax,%edx
  802f21:	89 d0                	mov    %edx,%eax
  802f23:	89 f2                	mov    %esi,%edx
  802f25:	f7 74 24 0c          	divl   0xc(%esp)
  802f29:	89 d6                	mov    %edx,%esi
  802f2b:	89 c3                	mov    %eax,%ebx
  802f2d:	f7 e5                	mul    %ebp
  802f2f:	39 d6                	cmp    %edx,%esi
  802f31:	72 19                	jb     802f4c <__udivdi3+0xfc>
  802f33:	74 0b                	je     802f40 <__udivdi3+0xf0>
  802f35:	89 d8                	mov    %ebx,%eax
  802f37:	31 ff                	xor    %edi,%edi
  802f39:	e9 58 ff ff ff       	jmp    802e96 <__udivdi3+0x46>
  802f3e:	66 90                	xchg   %ax,%ax
  802f40:	8b 54 24 08          	mov    0x8(%esp),%edx
  802f44:	89 f9                	mov    %edi,%ecx
  802f46:	d3 e2                	shl    %cl,%edx
  802f48:	39 c2                	cmp    %eax,%edx
  802f4a:	73 e9                	jae    802f35 <__udivdi3+0xe5>
  802f4c:	8d 43 ff             	lea    -0x1(%ebx),%eax
  802f4f:	31 ff                	xor    %edi,%edi
  802f51:	e9 40 ff ff ff       	jmp    802e96 <__udivdi3+0x46>
  802f56:	66 90                	xchg   %ax,%ax
  802f58:	31 c0                	xor    %eax,%eax
  802f5a:	e9 37 ff ff ff       	jmp    802e96 <__udivdi3+0x46>
  802f5f:	90                   	nop

00802f60 <__umoddi3>:
  802f60:	55                   	push   %ebp
  802f61:	57                   	push   %edi
  802f62:	56                   	push   %esi
  802f63:	53                   	push   %ebx
  802f64:	83 ec 1c             	sub    $0x1c,%esp
  802f67:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  802f6b:	8b 74 24 34          	mov    0x34(%esp),%esi
  802f6f:	8b 7c 24 38          	mov    0x38(%esp),%edi
  802f73:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  802f77:	89 44 24 0c          	mov    %eax,0xc(%esp)
  802f7b:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  802f7f:	89 f3                	mov    %esi,%ebx
  802f81:	89 fa                	mov    %edi,%edx
  802f83:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  802f87:	89 34 24             	mov    %esi,(%esp)
  802f8a:	85 c0                	test   %eax,%eax
  802f8c:	75 1a                	jne    802fa8 <__umoddi3+0x48>
  802f8e:	39 f7                	cmp    %esi,%edi
  802f90:	0f 86 a2 00 00 00    	jbe    803038 <__umoddi3+0xd8>
  802f96:	89 c8                	mov    %ecx,%eax
  802f98:	89 f2                	mov    %esi,%edx
  802f9a:	f7 f7                	div    %edi
  802f9c:	89 d0                	mov    %edx,%eax
  802f9e:	31 d2                	xor    %edx,%edx
  802fa0:	83 c4 1c             	add    $0x1c,%esp
  802fa3:	5b                   	pop    %ebx
  802fa4:	5e                   	pop    %esi
  802fa5:	5f                   	pop    %edi
  802fa6:	5d                   	pop    %ebp
  802fa7:	c3                   	ret    
  802fa8:	39 f0                	cmp    %esi,%eax
  802faa:	0f 87 ac 00 00 00    	ja     80305c <__umoddi3+0xfc>
  802fb0:	0f bd e8             	bsr    %eax,%ebp
  802fb3:	83 f5 1f             	xor    $0x1f,%ebp
  802fb6:	0f 84 ac 00 00 00    	je     803068 <__umoddi3+0x108>
  802fbc:	bf 20 00 00 00       	mov    $0x20,%edi
  802fc1:	29 ef                	sub    %ebp,%edi
  802fc3:	89 fe                	mov    %edi,%esi
  802fc5:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  802fc9:	89 e9                	mov    %ebp,%ecx
  802fcb:	d3 e0                	shl    %cl,%eax
  802fcd:	89 d7                	mov    %edx,%edi
  802fcf:	89 f1                	mov    %esi,%ecx
  802fd1:	d3 ef                	shr    %cl,%edi
  802fd3:	09 c7                	or     %eax,%edi
  802fd5:	89 e9                	mov    %ebp,%ecx
  802fd7:	d3 e2                	shl    %cl,%edx
  802fd9:	89 14 24             	mov    %edx,(%esp)
  802fdc:	89 d8                	mov    %ebx,%eax
  802fde:	d3 e0                	shl    %cl,%eax
  802fe0:	89 c2                	mov    %eax,%edx
  802fe2:	8b 44 24 08          	mov    0x8(%esp),%eax
  802fe6:	d3 e0                	shl    %cl,%eax
  802fe8:	89 44 24 04          	mov    %eax,0x4(%esp)
  802fec:	8b 44 24 08          	mov    0x8(%esp),%eax
  802ff0:	89 f1                	mov    %esi,%ecx
  802ff2:	d3 e8                	shr    %cl,%eax
  802ff4:	09 d0                	or     %edx,%eax
  802ff6:	d3 eb                	shr    %cl,%ebx
  802ff8:	89 da                	mov    %ebx,%edx
  802ffa:	f7 f7                	div    %edi
  802ffc:	89 d3                	mov    %edx,%ebx
  802ffe:	f7 24 24             	mull   (%esp)
  803001:	89 c6                	mov    %eax,%esi
  803003:	89 d1                	mov    %edx,%ecx
  803005:	39 d3                	cmp    %edx,%ebx
  803007:	0f 82 87 00 00 00    	jb     803094 <__umoddi3+0x134>
  80300d:	0f 84 91 00 00 00    	je     8030a4 <__umoddi3+0x144>
  803013:	8b 54 24 04          	mov    0x4(%esp),%edx
  803017:	29 f2                	sub    %esi,%edx
  803019:	19 cb                	sbb    %ecx,%ebx
  80301b:	89 d8                	mov    %ebx,%eax
  80301d:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  803021:	d3 e0                	shl    %cl,%eax
  803023:	89 e9                	mov    %ebp,%ecx
  803025:	d3 ea                	shr    %cl,%edx
  803027:	09 d0                	or     %edx,%eax
  803029:	89 e9                	mov    %ebp,%ecx
  80302b:	d3 eb                	shr    %cl,%ebx
  80302d:	89 da                	mov    %ebx,%edx
  80302f:	83 c4 1c             	add    $0x1c,%esp
  803032:	5b                   	pop    %ebx
  803033:	5e                   	pop    %esi
  803034:	5f                   	pop    %edi
  803035:	5d                   	pop    %ebp
  803036:	c3                   	ret    
  803037:	90                   	nop
  803038:	89 fd                	mov    %edi,%ebp
  80303a:	85 ff                	test   %edi,%edi
  80303c:	75 0b                	jne    803049 <__umoddi3+0xe9>
  80303e:	b8 01 00 00 00       	mov    $0x1,%eax
  803043:	31 d2                	xor    %edx,%edx
  803045:	f7 f7                	div    %edi
  803047:	89 c5                	mov    %eax,%ebp
  803049:	89 f0                	mov    %esi,%eax
  80304b:	31 d2                	xor    %edx,%edx
  80304d:	f7 f5                	div    %ebp
  80304f:	89 c8                	mov    %ecx,%eax
  803051:	f7 f5                	div    %ebp
  803053:	89 d0                	mov    %edx,%eax
  803055:	e9 44 ff ff ff       	jmp    802f9e <__umoddi3+0x3e>
  80305a:	66 90                	xchg   %ax,%ax
  80305c:	89 c8                	mov    %ecx,%eax
  80305e:	89 f2                	mov    %esi,%edx
  803060:	83 c4 1c             	add    $0x1c,%esp
  803063:	5b                   	pop    %ebx
  803064:	5e                   	pop    %esi
  803065:	5f                   	pop    %edi
  803066:	5d                   	pop    %ebp
  803067:	c3                   	ret    
  803068:	3b 04 24             	cmp    (%esp),%eax
  80306b:	72 06                	jb     803073 <__umoddi3+0x113>
  80306d:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  803071:	77 0f                	ja     803082 <__umoddi3+0x122>
  803073:	89 f2                	mov    %esi,%edx
  803075:	29 f9                	sub    %edi,%ecx
  803077:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  80307b:	89 14 24             	mov    %edx,(%esp)
  80307e:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  803082:	8b 44 24 04          	mov    0x4(%esp),%eax
  803086:	8b 14 24             	mov    (%esp),%edx
  803089:	83 c4 1c             	add    $0x1c,%esp
  80308c:	5b                   	pop    %ebx
  80308d:	5e                   	pop    %esi
  80308e:	5f                   	pop    %edi
  80308f:	5d                   	pop    %ebp
  803090:	c3                   	ret    
  803091:	8d 76 00             	lea    0x0(%esi),%esi
  803094:	2b 04 24             	sub    (%esp),%eax
  803097:	19 fa                	sbb    %edi,%edx
  803099:	89 d1                	mov    %edx,%ecx
  80309b:	89 c6                	mov    %eax,%esi
  80309d:	e9 71 ff ff ff       	jmp    803013 <__umoddi3+0xb3>
  8030a2:	66 90                	xchg   %ax,%ax
  8030a4:	39 44 24 04          	cmp    %eax,0x4(%esp)
  8030a8:	72 ea                	jb     803094 <__umoddi3+0x134>
  8030aa:	89 d9                	mov    %ebx,%ecx
  8030ac:	e9 62 ff ff ff       	jmp    803013 <__umoddi3+0xb3>
