
obj/user/tst_sharing_2slave2:     file format elf32-i386


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
  800031:	e8 c3 01 00 00       	call   8001f9 <libmain>
1:      jmp 1b
  800036:	eb fe                	jmp    800036 <args_exist+0x5>

00800038 <_main>:
// Slave program2: Get 2 shared variables, edit the writable one, and attempt to edit the readOnly one
#include <inc/lib.h>

void
_main(void)
{
  800038:	55                   	push   %ebp
  800039:	89 e5                	mov    %esp,%ebp
  80003b:	53                   	push   %ebx
  80003c:	83 ec 24             	sub    $0x24,%esp
	//Initial test to ensure it works on "PLACEMENT" not "REPLACEMENT"
	{
		uint8 fullWS = 1;
  80003f:	c6 45 f7 01          	movb   $0x1,-0x9(%ebp)
		for (int i = 0; i < myEnv->page_WS_max_size; ++i)
  800043:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  80004a:	eb 29                	jmp    800075 <_main+0x3d>
		{
			if (myEnv->__uptr_pws[i].empty)
  80004c:	a1 20 40 80 00       	mov    0x804020,%eax
  800051:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  800057:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80005a:	89 d0                	mov    %edx,%eax
  80005c:	01 c0                	add    %eax,%eax
  80005e:	01 d0                	add    %edx,%eax
  800060:	c1 e0 03             	shl    $0x3,%eax
  800063:	01 c8                	add    %ecx,%eax
  800065:	8a 40 04             	mov    0x4(%eax),%al
  800068:	84 c0                	test   %al,%al
  80006a:	74 06                	je     800072 <_main+0x3a>
			{
				fullWS = 0;
  80006c:	c6 45 f7 00          	movb   $0x0,-0x9(%ebp)
				break;
  800070:	eb 12                	jmp    800084 <_main+0x4c>
_main(void)
{
	//Initial test to ensure it works on "PLACEMENT" not "REPLACEMENT"
	{
		uint8 fullWS = 1;
		for (int i = 0; i < myEnv->page_WS_max_size; ++i)
  800072:	ff 45 f0             	incl   -0x10(%ebp)
  800075:	a1 20 40 80 00       	mov    0x804020,%eax
  80007a:	8b 50 74             	mov    0x74(%eax),%edx
  80007d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800080:	39 c2                	cmp    %eax,%edx
  800082:	77 c8                	ja     80004c <_main+0x14>
			{
				fullWS = 0;
				break;
			}
		}
		if (fullWS) panic("Please increase the WS size");
  800084:	80 7d f7 00          	cmpb   $0x0,-0x9(%ebp)
  800088:	74 14                	je     80009e <_main+0x66>
  80008a:	83 ec 04             	sub    $0x4,%esp
  80008d:	68 80 31 80 00       	push   $0x803180
  800092:	6a 13                	push   $0x13
  800094:	68 9c 31 80 00       	push   $0x80319c
  800099:	e8 97 02 00 00       	call   800335 <_panic>
	}
	/*Dummy malloc to enforce the UHEAP initializations*/
	malloc(0);
  80009e:	83 ec 0c             	sub    $0xc,%esp
  8000a1:	6a 00                	push   $0x0
  8000a3:	e8 d3 14 00 00       	call   80157b <malloc>
  8000a8:	83 c4 10             	add    $0x10,%esp
	/*=================================================*/

	int32 parentenvID = sys_getparentenvid();
  8000ab:	e8 d0 1b 00 00       	call   801c80 <sys_getparentenvid>
  8000b0:	89 45 ec             	mov    %eax,-0x14(%ebp)
	uint32 *x, *z;

	//GET: z then x, opposite to creation order (x then y then z)
	//So, addresses here will be different from the OWNER addresses
	sys_disable_interrupt();
  8000b3:	e8 bc 19 00 00       	call   801a74 <sys_disable_interrupt>
	int freeFrames = sys_calculate_free_frames() ;
  8000b8:	e8 ca 18 00 00       	call   801987 <sys_calculate_free_frames>
  8000bd:	89 45 e8             	mov    %eax,-0x18(%ebp)
	z = sget(parentenvID,"z");
  8000c0:	83 ec 08             	sub    $0x8,%esp
  8000c3:	68 b7 31 80 00       	push   $0x8031b7
  8000c8:	ff 75 ec             	pushl  -0x14(%ebp)
  8000cb:	e8 a3 16 00 00       	call   801773 <sget>
  8000d0:	83 c4 10             	add    $0x10,%esp
  8000d3:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	if (z != (uint32*)(USER_HEAP_START + 0 * PAGE_SIZE)) panic("Get(): Returned address is not correct. make sure that you align the allocation on 4KB boundary");
  8000d6:	81 7d e4 00 00 00 80 	cmpl   $0x80000000,-0x1c(%ebp)
  8000dd:	74 14                	je     8000f3 <_main+0xbb>
  8000df:	83 ec 04             	sub    $0x4,%esp
  8000e2:	68 bc 31 80 00       	push   $0x8031bc
  8000e7:	6a 21                	push   $0x21
  8000e9:	68 9c 31 80 00       	push   $0x80319c
  8000ee:	e8 42 02 00 00       	call   800335 <_panic>
	if ((freeFrames - sys_calculate_free_frames()) !=  1) panic("Get(): Wrong sharing- make sure that you share the required space in the current user environment using the correct frames (from frames_storage)");
  8000f3:	8b 5d e8             	mov    -0x18(%ebp),%ebx
  8000f6:	e8 8c 18 00 00       	call   801987 <sys_calculate_free_frames>
  8000fb:	29 c3                	sub    %eax,%ebx
  8000fd:	89 d8                	mov    %ebx,%eax
  8000ff:	83 f8 01             	cmp    $0x1,%eax
  800102:	74 14                	je     800118 <_main+0xe0>
  800104:	83 ec 04             	sub    $0x4,%esp
  800107:	68 1c 32 80 00       	push   $0x80321c
  80010c:	6a 22                	push   $0x22
  80010e:	68 9c 31 80 00       	push   $0x80319c
  800113:	e8 1d 02 00 00       	call   800335 <_panic>
	sys_enable_interrupt();
  800118:	e8 71 19 00 00       	call   801a8e <sys_enable_interrupt>

	sys_disable_interrupt();
  80011d:	e8 52 19 00 00       	call   801a74 <sys_disable_interrupt>
	freeFrames = sys_calculate_free_frames() ;
  800122:	e8 60 18 00 00       	call   801987 <sys_calculate_free_frames>
  800127:	89 45 e8             	mov    %eax,-0x18(%ebp)
	x = sget(parentenvID,"x");
  80012a:	83 ec 08             	sub    $0x8,%esp
  80012d:	68 ad 32 80 00       	push   $0x8032ad
  800132:	ff 75 ec             	pushl  -0x14(%ebp)
  800135:	e8 39 16 00 00       	call   801773 <sget>
  80013a:	83 c4 10             	add    $0x10,%esp
  80013d:	89 45 e0             	mov    %eax,-0x20(%ebp)
	if (x != (uint32*)(USER_HEAP_START + 1 * PAGE_SIZE)) panic("Get(): Returned address is not correct. make sure that you align the allocation on 4KB boundary");
  800140:	81 7d e0 00 10 00 80 	cmpl   $0x80001000,-0x20(%ebp)
  800147:	74 14                	je     80015d <_main+0x125>
  800149:	83 ec 04             	sub    $0x4,%esp
  80014c:	68 bc 31 80 00       	push   $0x8031bc
  800151:	6a 28                	push   $0x28
  800153:	68 9c 31 80 00       	push   $0x80319c
  800158:	e8 d8 01 00 00       	call   800335 <_panic>
	if ((freeFrames - sys_calculate_free_frames()) !=  0) panic("Get(): Wrong sharing- make sure that you share the required space in the current user environment using the correct frames (from frames_storage)");
  80015d:	e8 25 18 00 00       	call   801987 <sys_calculate_free_frames>
  800162:	89 c2                	mov    %eax,%edx
  800164:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800167:	39 c2                	cmp    %eax,%edx
  800169:	74 14                	je     80017f <_main+0x147>
  80016b:	83 ec 04             	sub    $0x4,%esp
  80016e:	68 1c 32 80 00       	push   $0x80321c
  800173:	6a 29                	push   $0x29
  800175:	68 9c 31 80 00       	push   $0x80319c
  80017a:	e8 b6 01 00 00       	call   800335 <_panic>
	sys_enable_interrupt();
  80017f:	e8 0a 19 00 00       	call   801a8e <sys_enable_interrupt>

	if (*x != 10) panic("Get(): Shared Variable is not created or got correctly") ;
  800184:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800187:	8b 00                	mov    (%eax),%eax
  800189:	83 f8 0a             	cmp    $0xa,%eax
  80018c:	74 14                	je     8001a2 <_main+0x16a>
  80018e:	83 ec 04             	sub    $0x4,%esp
  800191:	68 b0 32 80 00       	push   $0x8032b0
  800196:	6a 2c                	push   $0x2c
  800198:	68 9c 31 80 00       	push   $0x80319c
  80019d:	e8 93 01 00 00       	call   800335 <_panic>

	//Edit the writable object
	*z = 30;
  8001a2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8001a5:	c7 00 1e 00 00 00    	movl   $0x1e,(%eax)
	if (*z != 30) panic("Get(): Shared Variable is not created or got correctly") ;
  8001ab:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8001ae:	8b 00                	mov    (%eax),%eax
  8001b0:	83 f8 1e             	cmp    $0x1e,%eax
  8001b3:	74 14                	je     8001c9 <_main+0x191>
  8001b5:	83 ec 04             	sub    $0x4,%esp
  8001b8:	68 b0 32 80 00       	push   $0x8032b0
  8001bd:	6a 30                	push   $0x30
  8001bf:	68 9c 31 80 00       	push   $0x80319c
  8001c4:	e8 6c 01 00 00       	call   800335 <_panic>

	//Attempt to edit the ReadOnly object, it should panic
	cprintf("Attempt to edit the ReadOnly object @ va = %x\n", x);
  8001c9:	83 ec 08             	sub    $0x8,%esp
  8001cc:	ff 75 e0             	pushl  -0x20(%ebp)
  8001cf:	68 e8 32 80 00       	push   $0x8032e8
  8001d4:	e8 10 04 00 00       	call   8005e9 <cprintf>
  8001d9:	83 c4 10             	add    $0x10,%esp
	*x = 100;
  8001dc:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8001df:	c7 00 64 00 00 00    	movl   $0x64,(%eax)

	panic("Test FAILED! it should panic early and not reach this line of code") ;
  8001e5:	83 ec 04             	sub    $0x4,%esp
  8001e8:	68 18 33 80 00       	push   $0x803318
  8001ed:	6a 36                	push   $0x36
  8001ef:	68 9c 31 80 00       	push   $0x80319c
  8001f4:	e8 3c 01 00 00       	call   800335 <_panic>

008001f9 <libmain>:
volatile struct Env *myEnv = NULL;
volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";

void
libmain(int argc, char **argv)
{
  8001f9:	55                   	push   %ebp
  8001fa:	89 e5                	mov    %esp,%ebp
  8001fc:	83 ec 18             	sub    $0x18,%esp
	int envIndex = sys_getenvindex();
  8001ff:	e8 63 1a 00 00       	call   801c67 <sys_getenvindex>
  800204:	89 45 f4             	mov    %eax,-0xc(%ebp)
	myEnv = &(envs[envIndex]);
  800207:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80020a:	89 d0                	mov    %edx,%eax
  80020c:	c1 e0 03             	shl    $0x3,%eax
  80020f:	01 d0                	add    %edx,%eax
  800211:	01 c0                	add    %eax,%eax
  800213:	01 d0                	add    %edx,%eax
  800215:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80021c:	01 d0                	add    %edx,%eax
  80021e:	c1 e0 04             	shl    $0x4,%eax
  800221:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  800226:	a3 20 40 80 00       	mov    %eax,0x804020

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  80022b:	a1 20 40 80 00       	mov    0x804020,%eax
  800230:	8a 80 5c 05 00 00    	mov    0x55c(%eax),%al
  800236:	84 c0                	test   %al,%al
  800238:	74 0f                	je     800249 <libmain+0x50>
		binaryname = myEnv->prog_name;
  80023a:	a1 20 40 80 00       	mov    0x804020,%eax
  80023f:	05 5c 05 00 00       	add    $0x55c,%eax
  800244:	a3 00 40 80 00       	mov    %eax,0x804000

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800249:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80024d:	7e 0a                	jle    800259 <libmain+0x60>
		binaryname = argv[0];
  80024f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800252:	8b 00                	mov    (%eax),%eax
  800254:	a3 00 40 80 00       	mov    %eax,0x804000

	// call user main routine
	_main(argc, argv);
  800259:	83 ec 08             	sub    $0x8,%esp
  80025c:	ff 75 0c             	pushl  0xc(%ebp)
  80025f:	ff 75 08             	pushl  0x8(%ebp)
  800262:	e8 d1 fd ff ff       	call   800038 <_main>
  800267:	83 c4 10             	add    $0x10,%esp



	sys_disable_interrupt();
  80026a:	e8 05 18 00 00       	call   801a74 <sys_disable_interrupt>
	cprintf("**************************************\n");
  80026f:	83 ec 0c             	sub    $0xc,%esp
  800272:	68 74 33 80 00       	push   $0x803374
  800277:	e8 6d 03 00 00       	call   8005e9 <cprintf>
  80027c:	83 c4 10             	add    $0x10,%esp
	cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  80027f:	a1 20 40 80 00       	mov    0x804020,%eax
  800284:	8b 90 44 05 00 00    	mov    0x544(%eax),%edx
  80028a:	a1 20 40 80 00       	mov    0x804020,%eax
  80028f:	8b 80 34 05 00 00    	mov    0x534(%eax),%eax
  800295:	83 ec 04             	sub    $0x4,%esp
  800298:	52                   	push   %edx
  800299:	50                   	push   %eax
  80029a:	68 9c 33 80 00       	push   $0x80339c
  80029f:	e8 45 03 00 00       	call   8005e9 <cprintf>
  8002a4:	83 c4 10             	add    $0x10,%esp
	cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  8002a7:	a1 20 40 80 00       	mov    0x804020,%eax
  8002ac:	8b 88 54 05 00 00    	mov    0x554(%eax),%ecx
  8002b2:	a1 20 40 80 00       	mov    0x804020,%eax
  8002b7:	8b 90 50 05 00 00    	mov    0x550(%eax),%edx
  8002bd:	a1 20 40 80 00       	mov    0x804020,%eax
  8002c2:	8b 80 4c 05 00 00    	mov    0x54c(%eax),%eax
  8002c8:	51                   	push   %ecx
  8002c9:	52                   	push   %edx
  8002ca:	50                   	push   %eax
  8002cb:	68 c4 33 80 00       	push   $0x8033c4
  8002d0:	e8 14 03 00 00       	call   8005e9 <cprintf>
  8002d5:	83 c4 10             	add    $0x10,%esp
	//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
	cprintf("Num of clocks = %d\n", myEnv->nClocks);
  8002d8:	a1 20 40 80 00       	mov    0x804020,%eax
  8002dd:	8b 80 a4 05 00 00    	mov    0x5a4(%eax),%eax
  8002e3:	83 ec 08             	sub    $0x8,%esp
  8002e6:	50                   	push   %eax
  8002e7:	68 1c 34 80 00       	push   $0x80341c
  8002ec:	e8 f8 02 00 00       	call   8005e9 <cprintf>
  8002f1:	83 c4 10             	add    $0x10,%esp
	cprintf("**************************************\n");
  8002f4:	83 ec 0c             	sub    $0xc,%esp
  8002f7:	68 74 33 80 00       	push   $0x803374
  8002fc:	e8 e8 02 00 00       	call   8005e9 <cprintf>
  800301:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  800304:	e8 85 17 00 00       	call   801a8e <sys_enable_interrupt>

	// exit gracefully
	exit();
  800309:	e8 19 00 00 00       	call   800327 <exit>
}
  80030e:	90                   	nop
  80030f:	c9                   	leave  
  800310:	c3                   	ret    

00800311 <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  800311:	55                   	push   %ebp
  800312:	89 e5                	mov    %esp,%ebp
  800314:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  800317:	83 ec 0c             	sub    $0xc,%esp
  80031a:	6a 00                	push   $0x0
  80031c:	e8 12 19 00 00       	call   801c33 <sys_destroy_env>
  800321:	83 c4 10             	add    $0x10,%esp
}
  800324:	90                   	nop
  800325:	c9                   	leave  
  800326:	c3                   	ret    

00800327 <exit>:

void
exit(void)
{
  800327:	55                   	push   %ebp
  800328:	89 e5                	mov    %esp,%ebp
  80032a:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  80032d:	e8 67 19 00 00       	call   801c99 <sys_exit_env>
}
  800332:	90                   	nop
  800333:	c9                   	leave  
  800334:	c3                   	ret    

00800335 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  800335:	55                   	push   %ebp
  800336:	89 e5                	mov    %esp,%ebp
  800338:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  80033b:	8d 45 10             	lea    0x10(%ebp),%eax
  80033e:	83 c0 04             	add    $0x4,%eax
  800341:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  800344:	a1 5c 41 80 00       	mov    0x80415c,%eax
  800349:	85 c0                	test   %eax,%eax
  80034b:	74 16                	je     800363 <_panic+0x2e>
		cprintf("%s: ", argv0);
  80034d:	a1 5c 41 80 00       	mov    0x80415c,%eax
  800352:	83 ec 08             	sub    $0x8,%esp
  800355:	50                   	push   %eax
  800356:	68 30 34 80 00       	push   $0x803430
  80035b:	e8 89 02 00 00       	call   8005e9 <cprintf>
  800360:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  800363:	a1 00 40 80 00       	mov    0x804000,%eax
  800368:	ff 75 0c             	pushl  0xc(%ebp)
  80036b:	ff 75 08             	pushl  0x8(%ebp)
  80036e:	50                   	push   %eax
  80036f:	68 35 34 80 00       	push   $0x803435
  800374:	e8 70 02 00 00       	call   8005e9 <cprintf>
  800379:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  80037c:	8b 45 10             	mov    0x10(%ebp),%eax
  80037f:	83 ec 08             	sub    $0x8,%esp
  800382:	ff 75 f4             	pushl  -0xc(%ebp)
  800385:	50                   	push   %eax
  800386:	e8 f3 01 00 00       	call   80057e <vcprintf>
  80038b:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  80038e:	83 ec 08             	sub    $0x8,%esp
  800391:	6a 00                	push   $0x0
  800393:	68 51 34 80 00       	push   $0x803451
  800398:	e8 e1 01 00 00       	call   80057e <vcprintf>
  80039d:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  8003a0:	e8 82 ff ff ff       	call   800327 <exit>

	// should not return here
	while (1) ;
  8003a5:	eb fe                	jmp    8003a5 <_panic+0x70>

008003a7 <CheckWSWithoutLastIndex>:
}

void CheckWSWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  8003a7:	55                   	push   %ebp
  8003a8:	89 e5                	mov    %esp,%ebp
  8003aa:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  8003ad:	a1 20 40 80 00       	mov    0x804020,%eax
  8003b2:	8b 50 74             	mov    0x74(%eax),%edx
  8003b5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8003b8:	39 c2                	cmp    %eax,%edx
  8003ba:	74 14                	je     8003d0 <CheckWSWithoutLastIndex+0x29>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  8003bc:	83 ec 04             	sub    $0x4,%esp
  8003bf:	68 54 34 80 00       	push   $0x803454
  8003c4:	6a 26                	push   $0x26
  8003c6:	68 a0 34 80 00       	push   $0x8034a0
  8003cb:	e8 65 ff ff ff       	call   800335 <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  8003d0:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  8003d7:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  8003de:	e9 c2 00 00 00       	jmp    8004a5 <CheckWSWithoutLastIndex+0xfe>
		if (expectedPages[e] == 0) {
  8003e3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8003e6:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8003ed:	8b 45 08             	mov    0x8(%ebp),%eax
  8003f0:	01 d0                	add    %edx,%eax
  8003f2:	8b 00                	mov    (%eax),%eax
  8003f4:	85 c0                	test   %eax,%eax
  8003f6:	75 08                	jne    800400 <CheckWSWithoutLastIndex+0x59>
			expectedNumOfEmptyLocs++;
  8003f8:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  8003fb:	e9 a2 00 00 00       	jmp    8004a2 <CheckWSWithoutLastIndex+0xfb>
		}
		int found = 0;
  800400:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800407:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  80040e:	eb 69                	jmp    800479 <CheckWSWithoutLastIndex+0xd2>
			if (myEnv->__uptr_pws[w].empty == 0) {
  800410:	a1 20 40 80 00       	mov    0x804020,%eax
  800415:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  80041b:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80041e:	89 d0                	mov    %edx,%eax
  800420:	01 c0                	add    %eax,%eax
  800422:	01 d0                	add    %edx,%eax
  800424:	c1 e0 03             	shl    $0x3,%eax
  800427:	01 c8                	add    %ecx,%eax
  800429:	8a 40 04             	mov    0x4(%eax),%al
  80042c:	84 c0                	test   %al,%al
  80042e:	75 46                	jne    800476 <CheckWSWithoutLastIndex+0xcf>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  800430:	a1 20 40 80 00       	mov    0x804020,%eax
  800435:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  80043b:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80043e:	89 d0                	mov    %edx,%eax
  800440:	01 c0                	add    %eax,%eax
  800442:	01 d0                	add    %edx,%eax
  800444:	c1 e0 03             	shl    $0x3,%eax
  800447:	01 c8                	add    %ecx,%eax
  800449:	8b 00                	mov    (%eax),%eax
  80044b:	89 45 dc             	mov    %eax,-0x24(%ebp)
  80044e:	8b 45 dc             	mov    -0x24(%ebp),%eax
  800451:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800456:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  800458:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80045b:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  800462:	8b 45 08             	mov    0x8(%ebp),%eax
  800465:	01 c8                	add    %ecx,%eax
  800467:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  800469:	39 c2                	cmp    %eax,%edx
  80046b:	75 09                	jne    800476 <CheckWSWithoutLastIndex+0xcf>
						== expectedPages[e]) {
					found = 1;
  80046d:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  800474:	eb 12                	jmp    800488 <CheckWSWithoutLastIndex+0xe1>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800476:	ff 45 e8             	incl   -0x18(%ebp)
  800479:	a1 20 40 80 00       	mov    0x804020,%eax
  80047e:	8b 50 74             	mov    0x74(%eax),%edx
  800481:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800484:	39 c2                	cmp    %eax,%edx
  800486:	77 88                	ja     800410 <CheckWSWithoutLastIndex+0x69>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  800488:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  80048c:	75 14                	jne    8004a2 <CheckWSWithoutLastIndex+0xfb>
			panic(
  80048e:	83 ec 04             	sub    $0x4,%esp
  800491:	68 ac 34 80 00       	push   $0x8034ac
  800496:	6a 3a                	push   $0x3a
  800498:	68 a0 34 80 00       	push   $0x8034a0
  80049d:	e8 93 fe ff ff       	call   800335 <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  8004a2:	ff 45 f0             	incl   -0x10(%ebp)
  8004a5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8004a8:	3b 45 0c             	cmp    0xc(%ebp),%eax
  8004ab:	0f 8c 32 ff ff ff    	jl     8003e3 <CheckWSWithoutLastIndex+0x3c>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  8004b1:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8004b8:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  8004bf:	eb 26                	jmp    8004e7 <CheckWSWithoutLastIndex+0x140>
		if (myEnv->__uptr_pws[w].empty == 1) {
  8004c1:	a1 20 40 80 00       	mov    0x804020,%eax
  8004c6:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  8004cc:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8004cf:	89 d0                	mov    %edx,%eax
  8004d1:	01 c0                	add    %eax,%eax
  8004d3:	01 d0                	add    %edx,%eax
  8004d5:	c1 e0 03             	shl    $0x3,%eax
  8004d8:	01 c8                	add    %ecx,%eax
  8004da:	8a 40 04             	mov    0x4(%eax),%al
  8004dd:	3c 01                	cmp    $0x1,%al
  8004df:	75 03                	jne    8004e4 <CheckWSWithoutLastIndex+0x13d>
			actualNumOfEmptyLocs++;
  8004e1:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8004e4:	ff 45 e0             	incl   -0x20(%ebp)
  8004e7:	a1 20 40 80 00       	mov    0x804020,%eax
  8004ec:	8b 50 74             	mov    0x74(%eax),%edx
  8004ef:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8004f2:	39 c2                	cmp    %eax,%edx
  8004f4:	77 cb                	ja     8004c1 <CheckWSWithoutLastIndex+0x11a>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  8004f6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8004f9:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  8004fc:	74 14                	je     800512 <CheckWSWithoutLastIndex+0x16b>
		panic(
  8004fe:	83 ec 04             	sub    $0x4,%esp
  800501:	68 00 35 80 00       	push   $0x803500
  800506:	6a 44                	push   $0x44
  800508:	68 a0 34 80 00       	push   $0x8034a0
  80050d:	e8 23 fe ff ff       	call   800335 <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  800512:	90                   	nop
  800513:	c9                   	leave  
  800514:	c3                   	ret    

00800515 <putch>:
};

//2017:
uint8 printProgName = 0;

static void putch(int ch, struct printbuf *b) {
  800515:	55                   	push   %ebp
  800516:	89 e5                	mov    %esp,%ebp
  800518:	83 ec 08             	sub    $0x8,%esp
	b->buf[b->idx++] = ch;
  80051b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80051e:	8b 00                	mov    (%eax),%eax
  800520:	8d 48 01             	lea    0x1(%eax),%ecx
  800523:	8b 55 0c             	mov    0xc(%ebp),%edx
  800526:	89 0a                	mov    %ecx,(%edx)
  800528:	8b 55 08             	mov    0x8(%ebp),%edx
  80052b:	88 d1                	mov    %dl,%cl
  80052d:	8b 55 0c             	mov    0xc(%ebp),%edx
  800530:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  800534:	8b 45 0c             	mov    0xc(%ebp),%eax
  800537:	8b 00                	mov    (%eax),%eax
  800539:	3d ff 00 00 00       	cmp    $0xff,%eax
  80053e:	75 2c                	jne    80056c <putch+0x57>
		sys_cputs(b->buf, b->idx, printProgName);
  800540:	a0 24 40 80 00       	mov    0x804024,%al
  800545:	0f b6 c0             	movzbl %al,%eax
  800548:	8b 55 0c             	mov    0xc(%ebp),%edx
  80054b:	8b 12                	mov    (%edx),%edx
  80054d:	89 d1                	mov    %edx,%ecx
  80054f:	8b 55 0c             	mov    0xc(%ebp),%edx
  800552:	83 c2 08             	add    $0x8,%edx
  800555:	83 ec 04             	sub    $0x4,%esp
  800558:	50                   	push   %eax
  800559:	51                   	push   %ecx
  80055a:	52                   	push   %edx
  80055b:	e8 66 13 00 00       	call   8018c6 <sys_cputs>
  800560:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  800563:	8b 45 0c             	mov    0xc(%ebp),%eax
  800566:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  80056c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80056f:	8b 40 04             	mov    0x4(%eax),%eax
  800572:	8d 50 01             	lea    0x1(%eax),%edx
  800575:	8b 45 0c             	mov    0xc(%ebp),%eax
  800578:	89 50 04             	mov    %edx,0x4(%eax)
}
  80057b:	90                   	nop
  80057c:	c9                   	leave  
  80057d:	c3                   	ret    

0080057e <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  80057e:	55                   	push   %ebp
  80057f:	89 e5                	mov    %esp,%ebp
  800581:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  800587:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  80058e:	00 00 00 
	b.cnt = 0;
  800591:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800598:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  80059b:	ff 75 0c             	pushl  0xc(%ebp)
  80059e:	ff 75 08             	pushl  0x8(%ebp)
  8005a1:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8005a7:	50                   	push   %eax
  8005a8:	68 15 05 80 00       	push   $0x800515
  8005ad:	e8 11 02 00 00       	call   8007c3 <vprintfmt>
  8005b2:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName);
  8005b5:	a0 24 40 80 00       	mov    0x804024,%al
  8005ba:	0f b6 c0             	movzbl %al,%eax
  8005bd:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  8005c3:	83 ec 04             	sub    $0x4,%esp
  8005c6:	50                   	push   %eax
  8005c7:	52                   	push   %edx
  8005c8:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8005ce:	83 c0 08             	add    $0x8,%eax
  8005d1:	50                   	push   %eax
  8005d2:	e8 ef 12 00 00       	call   8018c6 <sys_cputs>
  8005d7:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  8005da:	c6 05 24 40 80 00 00 	movb   $0x0,0x804024
	return b.cnt;
  8005e1:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  8005e7:	c9                   	leave  
  8005e8:	c3                   	ret    

008005e9 <cprintf>:

int cprintf(const char *fmt, ...) {
  8005e9:	55                   	push   %ebp
  8005ea:	89 e5                	mov    %esp,%ebp
  8005ec:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  8005ef:	c6 05 24 40 80 00 01 	movb   $0x1,0x804024
	va_start(ap, fmt);
  8005f6:	8d 45 0c             	lea    0xc(%ebp),%eax
  8005f9:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  8005fc:	8b 45 08             	mov    0x8(%ebp),%eax
  8005ff:	83 ec 08             	sub    $0x8,%esp
  800602:	ff 75 f4             	pushl  -0xc(%ebp)
  800605:	50                   	push   %eax
  800606:	e8 73 ff ff ff       	call   80057e <vcprintf>
  80060b:	83 c4 10             	add    $0x10,%esp
  80060e:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  800611:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800614:	c9                   	leave  
  800615:	c3                   	ret    

00800616 <atomic_cprintf>:

int atomic_cprintf(const char *fmt, ...) {
  800616:	55                   	push   %ebp
  800617:	89 e5                	mov    %esp,%ebp
  800619:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  80061c:	e8 53 14 00 00       	call   801a74 <sys_disable_interrupt>
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  800621:	8d 45 0c             	lea    0xc(%ebp),%eax
  800624:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800627:	8b 45 08             	mov    0x8(%ebp),%eax
  80062a:	83 ec 08             	sub    $0x8,%esp
  80062d:	ff 75 f4             	pushl  -0xc(%ebp)
  800630:	50                   	push   %eax
  800631:	e8 48 ff ff ff       	call   80057e <vcprintf>
  800636:	83 c4 10             	add    $0x10,%esp
  800639:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	sys_enable_interrupt();
  80063c:	e8 4d 14 00 00       	call   801a8e <sys_enable_interrupt>
	return cnt;
  800641:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800644:	c9                   	leave  
  800645:	c3                   	ret    

00800646 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800646:	55                   	push   %ebp
  800647:	89 e5                	mov    %esp,%ebp
  800649:	53                   	push   %ebx
  80064a:	83 ec 14             	sub    $0x14,%esp
  80064d:	8b 45 10             	mov    0x10(%ebp),%eax
  800650:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800653:	8b 45 14             	mov    0x14(%ebp),%eax
  800656:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800659:	8b 45 18             	mov    0x18(%ebp),%eax
  80065c:	ba 00 00 00 00       	mov    $0x0,%edx
  800661:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800664:	77 55                	ja     8006bb <printnum+0x75>
  800666:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800669:	72 05                	jb     800670 <printnum+0x2a>
  80066b:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80066e:	77 4b                	ja     8006bb <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800670:	8b 45 1c             	mov    0x1c(%ebp),%eax
  800673:	8d 58 ff             	lea    -0x1(%eax),%ebx
  800676:	8b 45 18             	mov    0x18(%ebp),%eax
  800679:	ba 00 00 00 00       	mov    $0x0,%edx
  80067e:	52                   	push   %edx
  80067f:	50                   	push   %eax
  800680:	ff 75 f4             	pushl  -0xc(%ebp)
  800683:	ff 75 f0             	pushl  -0x10(%ebp)
  800686:	e8 85 28 00 00       	call   802f10 <__udivdi3>
  80068b:	83 c4 10             	add    $0x10,%esp
  80068e:	83 ec 04             	sub    $0x4,%esp
  800691:	ff 75 20             	pushl  0x20(%ebp)
  800694:	53                   	push   %ebx
  800695:	ff 75 18             	pushl  0x18(%ebp)
  800698:	52                   	push   %edx
  800699:	50                   	push   %eax
  80069a:	ff 75 0c             	pushl  0xc(%ebp)
  80069d:	ff 75 08             	pushl  0x8(%ebp)
  8006a0:	e8 a1 ff ff ff       	call   800646 <printnum>
  8006a5:	83 c4 20             	add    $0x20,%esp
  8006a8:	eb 1a                	jmp    8006c4 <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  8006aa:	83 ec 08             	sub    $0x8,%esp
  8006ad:	ff 75 0c             	pushl  0xc(%ebp)
  8006b0:	ff 75 20             	pushl  0x20(%ebp)
  8006b3:	8b 45 08             	mov    0x8(%ebp),%eax
  8006b6:	ff d0                	call   *%eax
  8006b8:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  8006bb:	ff 4d 1c             	decl   0x1c(%ebp)
  8006be:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  8006c2:	7f e6                	jg     8006aa <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  8006c4:	8b 4d 18             	mov    0x18(%ebp),%ecx
  8006c7:	bb 00 00 00 00       	mov    $0x0,%ebx
  8006cc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8006cf:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8006d2:	53                   	push   %ebx
  8006d3:	51                   	push   %ecx
  8006d4:	52                   	push   %edx
  8006d5:	50                   	push   %eax
  8006d6:	e8 45 29 00 00       	call   803020 <__umoddi3>
  8006db:	83 c4 10             	add    $0x10,%esp
  8006de:	05 74 37 80 00       	add    $0x803774,%eax
  8006e3:	8a 00                	mov    (%eax),%al
  8006e5:	0f be c0             	movsbl %al,%eax
  8006e8:	83 ec 08             	sub    $0x8,%esp
  8006eb:	ff 75 0c             	pushl  0xc(%ebp)
  8006ee:	50                   	push   %eax
  8006ef:	8b 45 08             	mov    0x8(%ebp),%eax
  8006f2:	ff d0                	call   *%eax
  8006f4:	83 c4 10             	add    $0x10,%esp
}
  8006f7:	90                   	nop
  8006f8:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8006fb:	c9                   	leave  
  8006fc:	c3                   	ret    

008006fd <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  8006fd:	55                   	push   %ebp
  8006fe:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800700:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800704:	7e 1c                	jle    800722 <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  800706:	8b 45 08             	mov    0x8(%ebp),%eax
  800709:	8b 00                	mov    (%eax),%eax
  80070b:	8d 50 08             	lea    0x8(%eax),%edx
  80070e:	8b 45 08             	mov    0x8(%ebp),%eax
  800711:	89 10                	mov    %edx,(%eax)
  800713:	8b 45 08             	mov    0x8(%ebp),%eax
  800716:	8b 00                	mov    (%eax),%eax
  800718:	83 e8 08             	sub    $0x8,%eax
  80071b:	8b 50 04             	mov    0x4(%eax),%edx
  80071e:	8b 00                	mov    (%eax),%eax
  800720:	eb 40                	jmp    800762 <getuint+0x65>
	else if (lflag)
  800722:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800726:	74 1e                	je     800746 <getuint+0x49>
		return va_arg(*ap, unsigned long);
  800728:	8b 45 08             	mov    0x8(%ebp),%eax
  80072b:	8b 00                	mov    (%eax),%eax
  80072d:	8d 50 04             	lea    0x4(%eax),%edx
  800730:	8b 45 08             	mov    0x8(%ebp),%eax
  800733:	89 10                	mov    %edx,(%eax)
  800735:	8b 45 08             	mov    0x8(%ebp),%eax
  800738:	8b 00                	mov    (%eax),%eax
  80073a:	83 e8 04             	sub    $0x4,%eax
  80073d:	8b 00                	mov    (%eax),%eax
  80073f:	ba 00 00 00 00       	mov    $0x0,%edx
  800744:	eb 1c                	jmp    800762 <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  800746:	8b 45 08             	mov    0x8(%ebp),%eax
  800749:	8b 00                	mov    (%eax),%eax
  80074b:	8d 50 04             	lea    0x4(%eax),%edx
  80074e:	8b 45 08             	mov    0x8(%ebp),%eax
  800751:	89 10                	mov    %edx,(%eax)
  800753:	8b 45 08             	mov    0x8(%ebp),%eax
  800756:	8b 00                	mov    (%eax),%eax
  800758:	83 e8 04             	sub    $0x4,%eax
  80075b:	8b 00                	mov    (%eax),%eax
  80075d:	ba 00 00 00 00       	mov    $0x0,%edx
}
  800762:	5d                   	pop    %ebp
  800763:	c3                   	ret    

00800764 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  800764:	55                   	push   %ebp
  800765:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800767:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  80076b:	7e 1c                	jle    800789 <getint+0x25>
		return va_arg(*ap, long long);
  80076d:	8b 45 08             	mov    0x8(%ebp),%eax
  800770:	8b 00                	mov    (%eax),%eax
  800772:	8d 50 08             	lea    0x8(%eax),%edx
  800775:	8b 45 08             	mov    0x8(%ebp),%eax
  800778:	89 10                	mov    %edx,(%eax)
  80077a:	8b 45 08             	mov    0x8(%ebp),%eax
  80077d:	8b 00                	mov    (%eax),%eax
  80077f:	83 e8 08             	sub    $0x8,%eax
  800782:	8b 50 04             	mov    0x4(%eax),%edx
  800785:	8b 00                	mov    (%eax),%eax
  800787:	eb 38                	jmp    8007c1 <getint+0x5d>
	else if (lflag)
  800789:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80078d:	74 1a                	je     8007a9 <getint+0x45>
		return va_arg(*ap, long);
  80078f:	8b 45 08             	mov    0x8(%ebp),%eax
  800792:	8b 00                	mov    (%eax),%eax
  800794:	8d 50 04             	lea    0x4(%eax),%edx
  800797:	8b 45 08             	mov    0x8(%ebp),%eax
  80079a:	89 10                	mov    %edx,(%eax)
  80079c:	8b 45 08             	mov    0x8(%ebp),%eax
  80079f:	8b 00                	mov    (%eax),%eax
  8007a1:	83 e8 04             	sub    $0x4,%eax
  8007a4:	8b 00                	mov    (%eax),%eax
  8007a6:	99                   	cltd   
  8007a7:	eb 18                	jmp    8007c1 <getint+0x5d>
	else
		return va_arg(*ap, int);
  8007a9:	8b 45 08             	mov    0x8(%ebp),%eax
  8007ac:	8b 00                	mov    (%eax),%eax
  8007ae:	8d 50 04             	lea    0x4(%eax),%edx
  8007b1:	8b 45 08             	mov    0x8(%ebp),%eax
  8007b4:	89 10                	mov    %edx,(%eax)
  8007b6:	8b 45 08             	mov    0x8(%ebp),%eax
  8007b9:	8b 00                	mov    (%eax),%eax
  8007bb:	83 e8 04             	sub    $0x4,%eax
  8007be:	8b 00                	mov    (%eax),%eax
  8007c0:	99                   	cltd   
}
  8007c1:	5d                   	pop    %ebp
  8007c2:	c3                   	ret    

008007c3 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  8007c3:	55                   	push   %ebp
  8007c4:	89 e5                	mov    %esp,%ebp
  8007c6:	56                   	push   %esi
  8007c7:	53                   	push   %ebx
  8007c8:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8007cb:	eb 17                	jmp    8007e4 <vprintfmt+0x21>
			if (ch == '\0')
  8007cd:	85 db                	test   %ebx,%ebx
  8007cf:	0f 84 af 03 00 00    	je     800b84 <vprintfmt+0x3c1>
				return;
			putch(ch, putdat);
  8007d5:	83 ec 08             	sub    $0x8,%esp
  8007d8:	ff 75 0c             	pushl  0xc(%ebp)
  8007db:	53                   	push   %ebx
  8007dc:	8b 45 08             	mov    0x8(%ebp),%eax
  8007df:	ff d0                	call   *%eax
  8007e1:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8007e4:	8b 45 10             	mov    0x10(%ebp),%eax
  8007e7:	8d 50 01             	lea    0x1(%eax),%edx
  8007ea:	89 55 10             	mov    %edx,0x10(%ebp)
  8007ed:	8a 00                	mov    (%eax),%al
  8007ef:	0f b6 d8             	movzbl %al,%ebx
  8007f2:	83 fb 25             	cmp    $0x25,%ebx
  8007f5:	75 d6                	jne    8007cd <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  8007f7:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  8007fb:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  800802:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  800809:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  800810:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800817:	8b 45 10             	mov    0x10(%ebp),%eax
  80081a:	8d 50 01             	lea    0x1(%eax),%edx
  80081d:	89 55 10             	mov    %edx,0x10(%ebp)
  800820:	8a 00                	mov    (%eax),%al
  800822:	0f b6 d8             	movzbl %al,%ebx
  800825:	8d 43 dd             	lea    -0x23(%ebx),%eax
  800828:	83 f8 55             	cmp    $0x55,%eax
  80082b:	0f 87 2b 03 00 00    	ja     800b5c <vprintfmt+0x399>
  800831:	8b 04 85 98 37 80 00 	mov    0x803798(,%eax,4),%eax
  800838:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  80083a:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  80083e:	eb d7                	jmp    800817 <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800840:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  800844:	eb d1                	jmp    800817 <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800846:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  80084d:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800850:	89 d0                	mov    %edx,%eax
  800852:	c1 e0 02             	shl    $0x2,%eax
  800855:	01 d0                	add    %edx,%eax
  800857:	01 c0                	add    %eax,%eax
  800859:	01 d8                	add    %ebx,%eax
  80085b:	83 e8 30             	sub    $0x30,%eax
  80085e:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  800861:	8b 45 10             	mov    0x10(%ebp),%eax
  800864:	8a 00                	mov    (%eax),%al
  800866:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  800869:	83 fb 2f             	cmp    $0x2f,%ebx
  80086c:	7e 3e                	jle    8008ac <vprintfmt+0xe9>
  80086e:	83 fb 39             	cmp    $0x39,%ebx
  800871:	7f 39                	jg     8008ac <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800873:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800876:	eb d5                	jmp    80084d <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  800878:	8b 45 14             	mov    0x14(%ebp),%eax
  80087b:	83 c0 04             	add    $0x4,%eax
  80087e:	89 45 14             	mov    %eax,0x14(%ebp)
  800881:	8b 45 14             	mov    0x14(%ebp),%eax
  800884:	83 e8 04             	sub    $0x4,%eax
  800887:	8b 00                	mov    (%eax),%eax
  800889:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  80088c:	eb 1f                	jmp    8008ad <vprintfmt+0xea>

		case '.':
			if (width < 0)
  80088e:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800892:	79 83                	jns    800817 <vprintfmt+0x54>
				width = 0;
  800894:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  80089b:	e9 77 ff ff ff       	jmp    800817 <vprintfmt+0x54>

		case '#':
			altflag = 1;
  8008a0:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  8008a7:	e9 6b ff ff ff       	jmp    800817 <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  8008ac:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  8008ad:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8008b1:	0f 89 60 ff ff ff    	jns    800817 <vprintfmt+0x54>
				width = precision, precision = -1;
  8008b7:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8008ba:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8008bd:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  8008c4:	e9 4e ff ff ff       	jmp    800817 <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  8008c9:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  8008cc:	e9 46 ff ff ff       	jmp    800817 <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  8008d1:	8b 45 14             	mov    0x14(%ebp),%eax
  8008d4:	83 c0 04             	add    $0x4,%eax
  8008d7:	89 45 14             	mov    %eax,0x14(%ebp)
  8008da:	8b 45 14             	mov    0x14(%ebp),%eax
  8008dd:	83 e8 04             	sub    $0x4,%eax
  8008e0:	8b 00                	mov    (%eax),%eax
  8008e2:	83 ec 08             	sub    $0x8,%esp
  8008e5:	ff 75 0c             	pushl  0xc(%ebp)
  8008e8:	50                   	push   %eax
  8008e9:	8b 45 08             	mov    0x8(%ebp),%eax
  8008ec:	ff d0                	call   *%eax
  8008ee:	83 c4 10             	add    $0x10,%esp
			break;
  8008f1:	e9 89 02 00 00       	jmp    800b7f <vprintfmt+0x3bc>

		// error message
		case 'e':
			err = va_arg(ap, int);
  8008f6:	8b 45 14             	mov    0x14(%ebp),%eax
  8008f9:	83 c0 04             	add    $0x4,%eax
  8008fc:	89 45 14             	mov    %eax,0x14(%ebp)
  8008ff:	8b 45 14             	mov    0x14(%ebp),%eax
  800902:	83 e8 04             	sub    $0x4,%eax
  800905:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  800907:	85 db                	test   %ebx,%ebx
  800909:	79 02                	jns    80090d <vprintfmt+0x14a>
				err = -err;
  80090b:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  80090d:	83 fb 64             	cmp    $0x64,%ebx
  800910:	7f 0b                	jg     80091d <vprintfmt+0x15a>
  800912:	8b 34 9d e0 35 80 00 	mov    0x8035e0(,%ebx,4),%esi
  800919:	85 f6                	test   %esi,%esi
  80091b:	75 19                	jne    800936 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  80091d:	53                   	push   %ebx
  80091e:	68 85 37 80 00       	push   $0x803785
  800923:	ff 75 0c             	pushl  0xc(%ebp)
  800926:	ff 75 08             	pushl  0x8(%ebp)
  800929:	e8 5e 02 00 00       	call   800b8c <printfmt>
  80092e:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800931:	e9 49 02 00 00       	jmp    800b7f <vprintfmt+0x3bc>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800936:	56                   	push   %esi
  800937:	68 8e 37 80 00       	push   $0x80378e
  80093c:	ff 75 0c             	pushl  0xc(%ebp)
  80093f:	ff 75 08             	pushl  0x8(%ebp)
  800942:	e8 45 02 00 00       	call   800b8c <printfmt>
  800947:	83 c4 10             	add    $0x10,%esp
			break;
  80094a:	e9 30 02 00 00       	jmp    800b7f <vprintfmt+0x3bc>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  80094f:	8b 45 14             	mov    0x14(%ebp),%eax
  800952:	83 c0 04             	add    $0x4,%eax
  800955:	89 45 14             	mov    %eax,0x14(%ebp)
  800958:	8b 45 14             	mov    0x14(%ebp),%eax
  80095b:	83 e8 04             	sub    $0x4,%eax
  80095e:	8b 30                	mov    (%eax),%esi
  800960:	85 f6                	test   %esi,%esi
  800962:	75 05                	jne    800969 <vprintfmt+0x1a6>
				p = "(null)";
  800964:	be 91 37 80 00       	mov    $0x803791,%esi
			if (width > 0 && padc != '-')
  800969:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80096d:	7e 6d                	jle    8009dc <vprintfmt+0x219>
  80096f:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  800973:	74 67                	je     8009dc <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  800975:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800978:	83 ec 08             	sub    $0x8,%esp
  80097b:	50                   	push   %eax
  80097c:	56                   	push   %esi
  80097d:	e8 0c 03 00 00       	call   800c8e <strnlen>
  800982:	83 c4 10             	add    $0x10,%esp
  800985:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  800988:	eb 16                	jmp    8009a0 <vprintfmt+0x1dd>
					putch(padc, putdat);
  80098a:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  80098e:	83 ec 08             	sub    $0x8,%esp
  800991:	ff 75 0c             	pushl  0xc(%ebp)
  800994:	50                   	push   %eax
  800995:	8b 45 08             	mov    0x8(%ebp),%eax
  800998:	ff d0                	call   *%eax
  80099a:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  80099d:	ff 4d e4             	decl   -0x1c(%ebp)
  8009a0:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8009a4:	7f e4                	jg     80098a <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8009a6:	eb 34                	jmp    8009dc <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  8009a8:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  8009ac:	74 1c                	je     8009ca <vprintfmt+0x207>
  8009ae:	83 fb 1f             	cmp    $0x1f,%ebx
  8009b1:	7e 05                	jle    8009b8 <vprintfmt+0x1f5>
  8009b3:	83 fb 7e             	cmp    $0x7e,%ebx
  8009b6:	7e 12                	jle    8009ca <vprintfmt+0x207>
					putch('?', putdat);
  8009b8:	83 ec 08             	sub    $0x8,%esp
  8009bb:	ff 75 0c             	pushl  0xc(%ebp)
  8009be:	6a 3f                	push   $0x3f
  8009c0:	8b 45 08             	mov    0x8(%ebp),%eax
  8009c3:	ff d0                	call   *%eax
  8009c5:	83 c4 10             	add    $0x10,%esp
  8009c8:	eb 0f                	jmp    8009d9 <vprintfmt+0x216>
				else
					putch(ch, putdat);
  8009ca:	83 ec 08             	sub    $0x8,%esp
  8009cd:	ff 75 0c             	pushl  0xc(%ebp)
  8009d0:	53                   	push   %ebx
  8009d1:	8b 45 08             	mov    0x8(%ebp),%eax
  8009d4:	ff d0                	call   *%eax
  8009d6:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8009d9:	ff 4d e4             	decl   -0x1c(%ebp)
  8009dc:	89 f0                	mov    %esi,%eax
  8009de:	8d 70 01             	lea    0x1(%eax),%esi
  8009e1:	8a 00                	mov    (%eax),%al
  8009e3:	0f be d8             	movsbl %al,%ebx
  8009e6:	85 db                	test   %ebx,%ebx
  8009e8:	74 24                	je     800a0e <vprintfmt+0x24b>
  8009ea:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8009ee:	78 b8                	js     8009a8 <vprintfmt+0x1e5>
  8009f0:	ff 4d e0             	decl   -0x20(%ebp)
  8009f3:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8009f7:	79 af                	jns    8009a8 <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  8009f9:	eb 13                	jmp    800a0e <vprintfmt+0x24b>
				putch(' ', putdat);
  8009fb:	83 ec 08             	sub    $0x8,%esp
  8009fe:	ff 75 0c             	pushl  0xc(%ebp)
  800a01:	6a 20                	push   $0x20
  800a03:	8b 45 08             	mov    0x8(%ebp),%eax
  800a06:	ff d0                	call   *%eax
  800a08:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800a0b:	ff 4d e4             	decl   -0x1c(%ebp)
  800a0e:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800a12:	7f e7                	jg     8009fb <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  800a14:	e9 66 01 00 00       	jmp    800b7f <vprintfmt+0x3bc>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  800a19:	83 ec 08             	sub    $0x8,%esp
  800a1c:	ff 75 e8             	pushl  -0x18(%ebp)
  800a1f:	8d 45 14             	lea    0x14(%ebp),%eax
  800a22:	50                   	push   %eax
  800a23:	e8 3c fd ff ff       	call   800764 <getint>
  800a28:	83 c4 10             	add    $0x10,%esp
  800a2b:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800a2e:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  800a31:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800a34:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800a37:	85 d2                	test   %edx,%edx
  800a39:	79 23                	jns    800a5e <vprintfmt+0x29b>
				putch('-', putdat);
  800a3b:	83 ec 08             	sub    $0x8,%esp
  800a3e:	ff 75 0c             	pushl  0xc(%ebp)
  800a41:	6a 2d                	push   $0x2d
  800a43:	8b 45 08             	mov    0x8(%ebp),%eax
  800a46:	ff d0                	call   *%eax
  800a48:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  800a4b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800a4e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800a51:	f7 d8                	neg    %eax
  800a53:	83 d2 00             	adc    $0x0,%edx
  800a56:	f7 da                	neg    %edx
  800a58:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800a5b:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  800a5e:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800a65:	e9 bc 00 00 00       	jmp    800b26 <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  800a6a:	83 ec 08             	sub    $0x8,%esp
  800a6d:	ff 75 e8             	pushl  -0x18(%ebp)
  800a70:	8d 45 14             	lea    0x14(%ebp),%eax
  800a73:	50                   	push   %eax
  800a74:	e8 84 fc ff ff       	call   8006fd <getuint>
  800a79:	83 c4 10             	add    $0x10,%esp
  800a7c:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800a7f:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  800a82:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800a89:	e9 98 00 00 00       	jmp    800b26 <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  800a8e:	83 ec 08             	sub    $0x8,%esp
  800a91:	ff 75 0c             	pushl  0xc(%ebp)
  800a94:	6a 58                	push   $0x58
  800a96:	8b 45 08             	mov    0x8(%ebp),%eax
  800a99:	ff d0                	call   *%eax
  800a9b:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800a9e:	83 ec 08             	sub    $0x8,%esp
  800aa1:	ff 75 0c             	pushl  0xc(%ebp)
  800aa4:	6a 58                	push   $0x58
  800aa6:	8b 45 08             	mov    0x8(%ebp),%eax
  800aa9:	ff d0                	call   *%eax
  800aab:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800aae:	83 ec 08             	sub    $0x8,%esp
  800ab1:	ff 75 0c             	pushl  0xc(%ebp)
  800ab4:	6a 58                	push   $0x58
  800ab6:	8b 45 08             	mov    0x8(%ebp),%eax
  800ab9:	ff d0                	call   *%eax
  800abb:	83 c4 10             	add    $0x10,%esp
			break;
  800abe:	e9 bc 00 00 00       	jmp    800b7f <vprintfmt+0x3bc>

		// pointer
		case 'p':
			putch('0', putdat);
  800ac3:	83 ec 08             	sub    $0x8,%esp
  800ac6:	ff 75 0c             	pushl  0xc(%ebp)
  800ac9:	6a 30                	push   $0x30
  800acb:	8b 45 08             	mov    0x8(%ebp),%eax
  800ace:	ff d0                	call   *%eax
  800ad0:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  800ad3:	83 ec 08             	sub    $0x8,%esp
  800ad6:	ff 75 0c             	pushl  0xc(%ebp)
  800ad9:	6a 78                	push   $0x78
  800adb:	8b 45 08             	mov    0x8(%ebp),%eax
  800ade:	ff d0                	call   *%eax
  800ae0:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  800ae3:	8b 45 14             	mov    0x14(%ebp),%eax
  800ae6:	83 c0 04             	add    $0x4,%eax
  800ae9:	89 45 14             	mov    %eax,0x14(%ebp)
  800aec:	8b 45 14             	mov    0x14(%ebp),%eax
  800aef:	83 e8 04             	sub    $0x4,%eax
  800af2:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800af4:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800af7:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  800afe:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  800b05:	eb 1f                	jmp    800b26 <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800b07:	83 ec 08             	sub    $0x8,%esp
  800b0a:	ff 75 e8             	pushl  -0x18(%ebp)
  800b0d:	8d 45 14             	lea    0x14(%ebp),%eax
  800b10:	50                   	push   %eax
  800b11:	e8 e7 fb ff ff       	call   8006fd <getuint>
  800b16:	83 c4 10             	add    $0x10,%esp
  800b19:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800b1c:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  800b1f:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800b26:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  800b2a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800b2d:	83 ec 04             	sub    $0x4,%esp
  800b30:	52                   	push   %edx
  800b31:	ff 75 e4             	pushl  -0x1c(%ebp)
  800b34:	50                   	push   %eax
  800b35:	ff 75 f4             	pushl  -0xc(%ebp)
  800b38:	ff 75 f0             	pushl  -0x10(%ebp)
  800b3b:	ff 75 0c             	pushl  0xc(%ebp)
  800b3e:	ff 75 08             	pushl  0x8(%ebp)
  800b41:	e8 00 fb ff ff       	call   800646 <printnum>
  800b46:	83 c4 20             	add    $0x20,%esp
			break;
  800b49:	eb 34                	jmp    800b7f <vprintfmt+0x3bc>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  800b4b:	83 ec 08             	sub    $0x8,%esp
  800b4e:	ff 75 0c             	pushl  0xc(%ebp)
  800b51:	53                   	push   %ebx
  800b52:	8b 45 08             	mov    0x8(%ebp),%eax
  800b55:	ff d0                	call   *%eax
  800b57:	83 c4 10             	add    $0x10,%esp
			break;
  800b5a:	eb 23                	jmp    800b7f <vprintfmt+0x3bc>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800b5c:	83 ec 08             	sub    $0x8,%esp
  800b5f:	ff 75 0c             	pushl  0xc(%ebp)
  800b62:	6a 25                	push   $0x25
  800b64:	8b 45 08             	mov    0x8(%ebp),%eax
  800b67:	ff d0                	call   *%eax
  800b69:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  800b6c:	ff 4d 10             	decl   0x10(%ebp)
  800b6f:	eb 03                	jmp    800b74 <vprintfmt+0x3b1>
  800b71:	ff 4d 10             	decl   0x10(%ebp)
  800b74:	8b 45 10             	mov    0x10(%ebp),%eax
  800b77:	48                   	dec    %eax
  800b78:	8a 00                	mov    (%eax),%al
  800b7a:	3c 25                	cmp    $0x25,%al
  800b7c:	75 f3                	jne    800b71 <vprintfmt+0x3ae>
				/* do nothing */;
			break;
  800b7e:	90                   	nop
		}
	}
  800b7f:	e9 47 fc ff ff       	jmp    8007cb <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  800b84:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  800b85:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800b88:	5b                   	pop    %ebx
  800b89:	5e                   	pop    %esi
  800b8a:	5d                   	pop    %ebp
  800b8b:	c3                   	ret    

00800b8c <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800b8c:	55                   	push   %ebp
  800b8d:	89 e5                	mov    %esp,%ebp
  800b8f:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  800b92:	8d 45 10             	lea    0x10(%ebp),%eax
  800b95:	83 c0 04             	add    $0x4,%eax
  800b98:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  800b9b:	8b 45 10             	mov    0x10(%ebp),%eax
  800b9e:	ff 75 f4             	pushl  -0xc(%ebp)
  800ba1:	50                   	push   %eax
  800ba2:	ff 75 0c             	pushl  0xc(%ebp)
  800ba5:	ff 75 08             	pushl  0x8(%ebp)
  800ba8:	e8 16 fc ff ff       	call   8007c3 <vprintfmt>
  800bad:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  800bb0:	90                   	nop
  800bb1:	c9                   	leave  
  800bb2:	c3                   	ret    

00800bb3 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800bb3:	55                   	push   %ebp
  800bb4:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  800bb6:	8b 45 0c             	mov    0xc(%ebp),%eax
  800bb9:	8b 40 08             	mov    0x8(%eax),%eax
  800bbc:	8d 50 01             	lea    0x1(%eax),%edx
  800bbf:	8b 45 0c             	mov    0xc(%ebp),%eax
  800bc2:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  800bc5:	8b 45 0c             	mov    0xc(%ebp),%eax
  800bc8:	8b 10                	mov    (%eax),%edx
  800bca:	8b 45 0c             	mov    0xc(%ebp),%eax
  800bcd:	8b 40 04             	mov    0x4(%eax),%eax
  800bd0:	39 c2                	cmp    %eax,%edx
  800bd2:	73 12                	jae    800be6 <sprintputch+0x33>
		*b->buf++ = ch;
  800bd4:	8b 45 0c             	mov    0xc(%ebp),%eax
  800bd7:	8b 00                	mov    (%eax),%eax
  800bd9:	8d 48 01             	lea    0x1(%eax),%ecx
  800bdc:	8b 55 0c             	mov    0xc(%ebp),%edx
  800bdf:	89 0a                	mov    %ecx,(%edx)
  800be1:	8b 55 08             	mov    0x8(%ebp),%edx
  800be4:	88 10                	mov    %dl,(%eax)
}
  800be6:	90                   	nop
  800be7:	5d                   	pop    %ebp
  800be8:	c3                   	ret    

00800be9 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800be9:	55                   	push   %ebp
  800bea:	89 e5                	mov    %esp,%ebp
  800bec:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  800bef:	8b 45 08             	mov    0x8(%ebp),%eax
  800bf2:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800bf5:	8b 45 0c             	mov    0xc(%ebp),%eax
  800bf8:	8d 50 ff             	lea    -0x1(%eax),%edx
  800bfb:	8b 45 08             	mov    0x8(%ebp),%eax
  800bfe:	01 d0                	add    %edx,%eax
  800c00:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800c03:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800c0a:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800c0e:	74 06                	je     800c16 <vsnprintf+0x2d>
  800c10:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800c14:	7f 07                	jg     800c1d <vsnprintf+0x34>
		return -E_INVAL;
  800c16:	b8 03 00 00 00       	mov    $0x3,%eax
  800c1b:	eb 20                	jmp    800c3d <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800c1d:	ff 75 14             	pushl  0x14(%ebp)
  800c20:	ff 75 10             	pushl  0x10(%ebp)
  800c23:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800c26:	50                   	push   %eax
  800c27:	68 b3 0b 80 00       	push   $0x800bb3
  800c2c:	e8 92 fb ff ff       	call   8007c3 <vprintfmt>
  800c31:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  800c34:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800c37:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800c3a:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  800c3d:	c9                   	leave  
  800c3e:	c3                   	ret    

00800c3f <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800c3f:	55                   	push   %ebp
  800c40:	89 e5                	mov    %esp,%ebp
  800c42:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800c45:	8d 45 10             	lea    0x10(%ebp),%eax
  800c48:	83 c0 04             	add    $0x4,%eax
  800c4b:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  800c4e:	8b 45 10             	mov    0x10(%ebp),%eax
  800c51:	ff 75 f4             	pushl  -0xc(%ebp)
  800c54:	50                   	push   %eax
  800c55:	ff 75 0c             	pushl  0xc(%ebp)
  800c58:	ff 75 08             	pushl  0x8(%ebp)
  800c5b:	e8 89 ff ff ff       	call   800be9 <vsnprintf>
  800c60:	83 c4 10             	add    $0x10,%esp
  800c63:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  800c66:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800c69:	c9                   	leave  
  800c6a:	c3                   	ret    

00800c6b <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  800c6b:	55                   	push   %ebp
  800c6c:	89 e5                	mov    %esp,%ebp
  800c6e:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  800c71:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800c78:	eb 06                	jmp    800c80 <strlen+0x15>
		n++;
  800c7a:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800c7d:	ff 45 08             	incl   0x8(%ebp)
  800c80:	8b 45 08             	mov    0x8(%ebp),%eax
  800c83:	8a 00                	mov    (%eax),%al
  800c85:	84 c0                	test   %al,%al
  800c87:	75 f1                	jne    800c7a <strlen+0xf>
		n++;
	return n;
  800c89:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800c8c:	c9                   	leave  
  800c8d:	c3                   	ret    

00800c8e <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  800c8e:	55                   	push   %ebp
  800c8f:	89 e5                	mov    %esp,%ebp
  800c91:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800c94:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800c9b:	eb 09                	jmp    800ca6 <strnlen+0x18>
		n++;
  800c9d:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800ca0:	ff 45 08             	incl   0x8(%ebp)
  800ca3:	ff 4d 0c             	decl   0xc(%ebp)
  800ca6:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800caa:	74 09                	je     800cb5 <strnlen+0x27>
  800cac:	8b 45 08             	mov    0x8(%ebp),%eax
  800caf:	8a 00                	mov    (%eax),%al
  800cb1:	84 c0                	test   %al,%al
  800cb3:	75 e8                	jne    800c9d <strnlen+0xf>
		n++;
	return n;
  800cb5:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800cb8:	c9                   	leave  
  800cb9:	c3                   	ret    

00800cba <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800cba:	55                   	push   %ebp
  800cbb:	89 e5                	mov    %esp,%ebp
  800cbd:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  800cc0:	8b 45 08             	mov    0x8(%ebp),%eax
  800cc3:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  800cc6:	90                   	nop
  800cc7:	8b 45 08             	mov    0x8(%ebp),%eax
  800cca:	8d 50 01             	lea    0x1(%eax),%edx
  800ccd:	89 55 08             	mov    %edx,0x8(%ebp)
  800cd0:	8b 55 0c             	mov    0xc(%ebp),%edx
  800cd3:	8d 4a 01             	lea    0x1(%edx),%ecx
  800cd6:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800cd9:	8a 12                	mov    (%edx),%dl
  800cdb:	88 10                	mov    %dl,(%eax)
  800cdd:	8a 00                	mov    (%eax),%al
  800cdf:	84 c0                	test   %al,%al
  800ce1:	75 e4                	jne    800cc7 <strcpy+0xd>
		/* do nothing */;
	return ret;
  800ce3:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800ce6:	c9                   	leave  
  800ce7:	c3                   	ret    

00800ce8 <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  800ce8:	55                   	push   %ebp
  800ce9:	89 e5                	mov    %esp,%ebp
  800ceb:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  800cee:	8b 45 08             	mov    0x8(%ebp),%eax
  800cf1:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  800cf4:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800cfb:	eb 1f                	jmp    800d1c <strncpy+0x34>
		*dst++ = *src;
  800cfd:	8b 45 08             	mov    0x8(%ebp),%eax
  800d00:	8d 50 01             	lea    0x1(%eax),%edx
  800d03:	89 55 08             	mov    %edx,0x8(%ebp)
  800d06:	8b 55 0c             	mov    0xc(%ebp),%edx
  800d09:	8a 12                	mov    (%edx),%dl
  800d0b:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  800d0d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d10:	8a 00                	mov    (%eax),%al
  800d12:	84 c0                	test   %al,%al
  800d14:	74 03                	je     800d19 <strncpy+0x31>
			src++;
  800d16:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800d19:	ff 45 fc             	incl   -0x4(%ebp)
  800d1c:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800d1f:	3b 45 10             	cmp    0x10(%ebp),%eax
  800d22:	72 d9                	jb     800cfd <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  800d24:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  800d27:	c9                   	leave  
  800d28:	c3                   	ret    

00800d29 <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  800d29:	55                   	push   %ebp
  800d2a:	89 e5                	mov    %esp,%ebp
  800d2c:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  800d2f:	8b 45 08             	mov    0x8(%ebp),%eax
  800d32:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  800d35:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800d39:	74 30                	je     800d6b <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  800d3b:	eb 16                	jmp    800d53 <strlcpy+0x2a>
			*dst++ = *src++;
  800d3d:	8b 45 08             	mov    0x8(%ebp),%eax
  800d40:	8d 50 01             	lea    0x1(%eax),%edx
  800d43:	89 55 08             	mov    %edx,0x8(%ebp)
  800d46:	8b 55 0c             	mov    0xc(%ebp),%edx
  800d49:	8d 4a 01             	lea    0x1(%edx),%ecx
  800d4c:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800d4f:	8a 12                	mov    (%edx),%dl
  800d51:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800d53:	ff 4d 10             	decl   0x10(%ebp)
  800d56:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800d5a:	74 09                	je     800d65 <strlcpy+0x3c>
  800d5c:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d5f:	8a 00                	mov    (%eax),%al
  800d61:	84 c0                	test   %al,%al
  800d63:	75 d8                	jne    800d3d <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  800d65:	8b 45 08             	mov    0x8(%ebp),%eax
  800d68:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800d6b:	8b 55 08             	mov    0x8(%ebp),%edx
  800d6e:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800d71:	29 c2                	sub    %eax,%edx
  800d73:	89 d0                	mov    %edx,%eax
}
  800d75:	c9                   	leave  
  800d76:	c3                   	ret    

00800d77 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800d77:	55                   	push   %ebp
  800d78:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  800d7a:	eb 06                	jmp    800d82 <strcmp+0xb>
		p++, q++;
  800d7c:	ff 45 08             	incl   0x8(%ebp)
  800d7f:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  800d82:	8b 45 08             	mov    0x8(%ebp),%eax
  800d85:	8a 00                	mov    (%eax),%al
  800d87:	84 c0                	test   %al,%al
  800d89:	74 0e                	je     800d99 <strcmp+0x22>
  800d8b:	8b 45 08             	mov    0x8(%ebp),%eax
  800d8e:	8a 10                	mov    (%eax),%dl
  800d90:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d93:	8a 00                	mov    (%eax),%al
  800d95:	38 c2                	cmp    %al,%dl
  800d97:	74 e3                	je     800d7c <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800d99:	8b 45 08             	mov    0x8(%ebp),%eax
  800d9c:	8a 00                	mov    (%eax),%al
  800d9e:	0f b6 d0             	movzbl %al,%edx
  800da1:	8b 45 0c             	mov    0xc(%ebp),%eax
  800da4:	8a 00                	mov    (%eax),%al
  800da6:	0f b6 c0             	movzbl %al,%eax
  800da9:	29 c2                	sub    %eax,%edx
  800dab:	89 d0                	mov    %edx,%eax
}
  800dad:	5d                   	pop    %ebp
  800dae:	c3                   	ret    

00800daf <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  800daf:	55                   	push   %ebp
  800db0:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  800db2:	eb 09                	jmp    800dbd <strncmp+0xe>
		n--, p++, q++;
  800db4:	ff 4d 10             	decl   0x10(%ebp)
  800db7:	ff 45 08             	incl   0x8(%ebp)
  800dba:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  800dbd:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800dc1:	74 17                	je     800dda <strncmp+0x2b>
  800dc3:	8b 45 08             	mov    0x8(%ebp),%eax
  800dc6:	8a 00                	mov    (%eax),%al
  800dc8:	84 c0                	test   %al,%al
  800dca:	74 0e                	je     800dda <strncmp+0x2b>
  800dcc:	8b 45 08             	mov    0x8(%ebp),%eax
  800dcf:	8a 10                	mov    (%eax),%dl
  800dd1:	8b 45 0c             	mov    0xc(%ebp),%eax
  800dd4:	8a 00                	mov    (%eax),%al
  800dd6:	38 c2                	cmp    %al,%dl
  800dd8:	74 da                	je     800db4 <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  800dda:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800dde:	75 07                	jne    800de7 <strncmp+0x38>
		return 0;
  800de0:	b8 00 00 00 00       	mov    $0x0,%eax
  800de5:	eb 14                	jmp    800dfb <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800de7:	8b 45 08             	mov    0x8(%ebp),%eax
  800dea:	8a 00                	mov    (%eax),%al
  800dec:	0f b6 d0             	movzbl %al,%edx
  800def:	8b 45 0c             	mov    0xc(%ebp),%eax
  800df2:	8a 00                	mov    (%eax),%al
  800df4:	0f b6 c0             	movzbl %al,%eax
  800df7:	29 c2                	sub    %eax,%edx
  800df9:	89 d0                	mov    %edx,%eax
}
  800dfb:	5d                   	pop    %ebp
  800dfc:	c3                   	ret    

00800dfd <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800dfd:	55                   	push   %ebp
  800dfe:	89 e5                	mov    %esp,%ebp
  800e00:	83 ec 04             	sub    $0x4,%esp
  800e03:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e06:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800e09:	eb 12                	jmp    800e1d <strchr+0x20>
		if (*s == c)
  800e0b:	8b 45 08             	mov    0x8(%ebp),%eax
  800e0e:	8a 00                	mov    (%eax),%al
  800e10:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800e13:	75 05                	jne    800e1a <strchr+0x1d>
			return (char *) s;
  800e15:	8b 45 08             	mov    0x8(%ebp),%eax
  800e18:	eb 11                	jmp    800e2b <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  800e1a:	ff 45 08             	incl   0x8(%ebp)
  800e1d:	8b 45 08             	mov    0x8(%ebp),%eax
  800e20:	8a 00                	mov    (%eax),%al
  800e22:	84 c0                	test   %al,%al
  800e24:	75 e5                	jne    800e0b <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  800e26:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800e2b:	c9                   	leave  
  800e2c:	c3                   	ret    

00800e2d <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800e2d:	55                   	push   %ebp
  800e2e:	89 e5                	mov    %esp,%ebp
  800e30:	83 ec 04             	sub    $0x4,%esp
  800e33:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e36:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800e39:	eb 0d                	jmp    800e48 <strfind+0x1b>
		if (*s == c)
  800e3b:	8b 45 08             	mov    0x8(%ebp),%eax
  800e3e:	8a 00                	mov    (%eax),%al
  800e40:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800e43:	74 0e                	je     800e53 <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  800e45:	ff 45 08             	incl   0x8(%ebp)
  800e48:	8b 45 08             	mov    0x8(%ebp),%eax
  800e4b:	8a 00                	mov    (%eax),%al
  800e4d:	84 c0                	test   %al,%al
  800e4f:	75 ea                	jne    800e3b <strfind+0xe>
  800e51:	eb 01                	jmp    800e54 <strfind+0x27>
		if (*s == c)
			break;
  800e53:	90                   	nop
	return (char *) s;
  800e54:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800e57:	c9                   	leave  
  800e58:	c3                   	ret    

00800e59 <memset>:


void *
memset(void *v, int c, uint32 n)
{
  800e59:	55                   	push   %ebp
  800e5a:	89 e5                	mov    %esp,%ebp
  800e5c:	83 ec 10             	sub    $0x10,%esp
	char *p;
	int m;

	p = v;
  800e5f:	8b 45 08             	mov    0x8(%ebp),%eax
  800e62:	89 45 fc             	mov    %eax,-0x4(%ebp)
	m = n;
  800e65:	8b 45 10             	mov    0x10(%ebp),%eax
  800e68:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (--m >= 0)
  800e6b:	eb 0e                	jmp    800e7b <memset+0x22>
		*p++ = c;
  800e6d:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800e70:	8d 50 01             	lea    0x1(%eax),%edx
  800e73:	89 55 fc             	mov    %edx,-0x4(%ebp)
  800e76:	8b 55 0c             	mov    0xc(%ebp),%edx
  800e79:	88 10                	mov    %dl,(%eax)
	char *p;
	int m;

	p = v;
	m = n;
	while (--m >= 0)
  800e7b:	ff 4d f8             	decl   -0x8(%ebp)
  800e7e:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  800e82:	79 e9                	jns    800e6d <memset+0x14>
		*p++ = c;

	return v;
  800e84:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800e87:	c9                   	leave  
  800e88:	c3                   	ret    

00800e89 <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  800e89:	55                   	push   %ebp
  800e8a:	89 e5                	mov    %esp,%ebp
  800e8c:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800e8f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e92:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800e95:	8b 45 08             	mov    0x8(%ebp),%eax
  800e98:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (n-- > 0)
  800e9b:	eb 16                	jmp    800eb3 <memcpy+0x2a>
		*d++ = *s++;
  800e9d:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800ea0:	8d 50 01             	lea    0x1(%eax),%edx
  800ea3:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800ea6:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800ea9:	8d 4a 01             	lea    0x1(%edx),%ecx
  800eac:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800eaf:	8a 12                	mov    (%edx),%dl
  800eb1:	88 10                	mov    %dl,(%eax)
	const char *s;
	char *d;

	s = src;
	d = dst;
	while (n-- > 0)
  800eb3:	8b 45 10             	mov    0x10(%ebp),%eax
  800eb6:	8d 50 ff             	lea    -0x1(%eax),%edx
  800eb9:	89 55 10             	mov    %edx,0x10(%ebp)
  800ebc:	85 c0                	test   %eax,%eax
  800ebe:	75 dd                	jne    800e9d <memcpy+0x14>
		*d++ = *s++;

	return dst;
  800ec0:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800ec3:	c9                   	leave  
  800ec4:	c3                   	ret    

00800ec5 <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  800ec5:	55                   	push   %ebp
  800ec6:	89 e5                	mov    %esp,%ebp
  800ec8:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800ecb:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ece:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800ed1:	8b 45 08             	mov    0x8(%ebp),%eax
  800ed4:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  800ed7:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800eda:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800edd:	73 50                	jae    800f2f <memmove+0x6a>
  800edf:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800ee2:	8b 45 10             	mov    0x10(%ebp),%eax
  800ee5:	01 d0                	add    %edx,%eax
  800ee7:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800eea:	76 43                	jbe    800f2f <memmove+0x6a>
		s += n;
  800eec:	8b 45 10             	mov    0x10(%ebp),%eax
  800eef:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  800ef2:	8b 45 10             	mov    0x10(%ebp),%eax
  800ef5:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  800ef8:	eb 10                	jmp    800f0a <memmove+0x45>
			*--d = *--s;
  800efa:	ff 4d f8             	decl   -0x8(%ebp)
  800efd:	ff 4d fc             	decl   -0x4(%ebp)
  800f00:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800f03:	8a 10                	mov    (%eax),%dl
  800f05:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800f08:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  800f0a:	8b 45 10             	mov    0x10(%ebp),%eax
  800f0d:	8d 50 ff             	lea    -0x1(%eax),%edx
  800f10:	89 55 10             	mov    %edx,0x10(%ebp)
  800f13:	85 c0                	test   %eax,%eax
  800f15:	75 e3                	jne    800efa <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800f17:	eb 23                	jmp    800f3c <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  800f19:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800f1c:	8d 50 01             	lea    0x1(%eax),%edx
  800f1f:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800f22:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800f25:	8d 4a 01             	lea    0x1(%edx),%ecx
  800f28:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800f2b:	8a 12                	mov    (%edx),%dl
  800f2d:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  800f2f:	8b 45 10             	mov    0x10(%ebp),%eax
  800f32:	8d 50 ff             	lea    -0x1(%eax),%edx
  800f35:	89 55 10             	mov    %edx,0x10(%ebp)
  800f38:	85 c0                	test   %eax,%eax
  800f3a:	75 dd                	jne    800f19 <memmove+0x54>
			*d++ = *s++;

	return dst;
  800f3c:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800f3f:	c9                   	leave  
  800f40:	c3                   	ret    

00800f41 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  800f41:	55                   	push   %ebp
  800f42:	89 e5                	mov    %esp,%ebp
  800f44:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  800f47:	8b 45 08             	mov    0x8(%ebp),%eax
  800f4a:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  800f4d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f50:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  800f53:	eb 2a                	jmp    800f7f <memcmp+0x3e>
		if (*s1 != *s2)
  800f55:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800f58:	8a 10                	mov    (%eax),%dl
  800f5a:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800f5d:	8a 00                	mov    (%eax),%al
  800f5f:	38 c2                	cmp    %al,%dl
  800f61:	74 16                	je     800f79 <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  800f63:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800f66:	8a 00                	mov    (%eax),%al
  800f68:	0f b6 d0             	movzbl %al,%edx
  800f6b:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800f6e:	8a 00                	mov    (%eax),%al
  800f70:	0f b6 c0             	movzbl %al,%eax
  800f73:	29 c2                	sub    %eax,%edx
  800f75:	89 d0                	mov    %edx,%eax
  800f77:	eb 18                	jmp    800f91 <memcmp+0x50>
		s1++, s2++;
  800f79:	ff 45 fc             	incl   -0x4(%ebp)
  800f7c:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  800f7f:	8b 45 10             	mov    0x10(%ebp),%eax
  800f82:	8d 50 ff             	lea    -0x1(%eax),%edx
  800f85:	89 55 10             	mov    %edx,0x10(%ebp)
  800f88:	85 c0                	test   %eax,%eax
  800f8a:	75 c9                	jne    800f55 <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  800f8c:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800f91:	c9                   	leave  
  800f92:	c3                   	ret    

00800f93 <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  800f93:	55                   	push   %ebp
  800f94:	89 e5                	mov    %esp,%ebp
  800f96:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  800f99:	8b 55 08             	mov    0x8(%ebp),%edx
  800f9c:	8b 45 10             	mov    0x10(%ebp),%eax
  800f9f:	01 d0                	add    %edx,%eax
  800fa1:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  800fa4:	eb 15                	jmp    800fbb <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  800fa6:	8b 45 08             	mov    0x8(%ebp),%eax
  800fa9:	8a 00                	mov    (%eax),%al
  800fab:	0f b6 d0             	movzbl %al,%edx
  800fae:	8b 45 0c             	mov    0xc(%ebp),%eax
  800fb1:	0f b6 c0             	movzbl %al,%eax
  800fb4:	39 c2                	cmp    %eax,%edx
  800fb6:	74 0d                	je     800fc5 <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  800fb8:	ff 45 08             	incl   0x8(%ebp)
  800fbb:	8b 45 08             	mov    0x8(%ebp),%eax
  800fbe:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  800fc1:	72 e3                	jb     800fa6 <memfind+0x13>
  800fc3:	eb 01                	jmp    800fc6 <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  800fc5:	90                   	nop
	return (void *) s;
  800fc6:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800fc9:	c9                   	leave  
  800fca:	c3                   	ret    

00800fcb <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800fcb:	55                   	push   %ebp
  800fcc:	89 e5                	mov    %esp,%ebp
  800fce:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  800fd1:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  800fd8:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800fdf:	eb 03                	jmp    800fe4 <strtol+0x19>
		s++;
  800fe1:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800fe4:	8b 45 08             	mov    0x8(%ebp),%eax
  800fe7:	8a 00                	mov    (%eax),%al
  800fe9:	3c 20                	cmp    $0x20,%al
  800feb:	74 f4                	je     800fe1 <strtol+0x16>
  800fed:	8b 45 08             	mov    0x8(%ebp),%eax
  800ff0:	8a 00                	mov    (%eax),%al
  800ff2:	3c 09                	cmp    $0x9,%al
  800ff4:	74 eb                	je     800fe1 <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  800ff6:	8b 45 08             	mov    0x8(%ebp),%eax
  800ff9:	8a 00                	mov    (%eax),%al
  800ffb:	3c 2b                	cmp    $0x2b,%al
  800ffd:	75 05                	jne    801004 <strtol+0x39>
		s++;
  800fff:	ff 45 08             	incl   0x8(%ebp)
  801002:	eb 13                	jmp    801017 <strtol+0x4c>
	else if (*s == '-')
  801004:	8b 45 08             	mov    0x8(%ebp),%eax
  801007:	8a 00                	mov    (%eax),%al
  801009:	3c 2d                	cmp    $0x2d,%al
  80100b:	75 0a                	jne    801017 <strtol+0x4c>
		s++, neg = 1;
  80100d:	ff 45 08             	incl   0x8(%ebp)
  801010:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  801017:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80101b:	74 06                	je     801023 <strtol+0x58>
  80101d:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  801021:	75 20                	jne    801043 <strtol+0x78>
  801023:	8b 45 08             	mov    0x8(%ebp),%eax
  801026:	8a 00                	mov    (%eax),%al
  801028:	3c 30                	cmp    $0x30,%al
  80102a:	75 17                	jne    801043 <strtol+0x78>
  80102c:	8b 45 08             	mov    0x8(%ebp),%eax
  80102f:	40                   	inc    %eax
  801030:	8a 00                	mov    (%eax),%al
  801032:	3c 78                	cmp    $0x78,%al
  801034:	75 0d                	jne    801043 <strtol+0x78>
		s += 2, base = 16;
  801036:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  80103a:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  801041:	eb 28                	jmp    80106b <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  801043:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801047:	75 15                	jne    80105e <strtol+0x93>
  801049:	8b 45 08             	mov    0x8(%ebp),%eax
  80104c:	8a 00                	mov    (%eax),%al
  80104e:	3c 30                	cmp    $0x30,%al
  801050:	75 0c                	jne    80105e <strtol+0x93>
		s++, base = 8;
  801052:	ff 45 08             	incl   0x8(%ebp)
  801055:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  80105c:	eb 0d                	jmp    80106b <strtol+0xa0>
	else if (base == 0)
  80105e:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801062:	75 07                	jne    80106b <strtol+0xa0>
		base = 10;
  801064:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  80106b:	8b 45 08             	mov    0x8(%ebp),%eax
  80106e:	8a 00                	mov    (%eax),%al
  801070:	3c 2f                	cmp    $0x2f,%al
  801072:	7e 19                	jle    80108d <strtol+0xc2>
  801074:	8b 45 08             	mov    0x8(%ebp),%eax
  801077:	8a 00                	mov    (%eax),%al
  801079:	3c 39                	cmp    $0x39,%al
  80107b:	7f 10                	jg     80108d <strtol+0xc2>
			dig = *s - '0';
  80107d:	8b 45 08             	mov    0x8(%ebp),%eax
  801080:	8a 00                	mov    (%eax),%al
  801082:	0f be c0             	movsbl %al,%eax
  801085:	83 e8 30             	sub    $0x30,%eax
  801088:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80108b:	eb 42                	jmp    8010cf <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  80108d:	8b 45 08             	mov    0x8(%ebp),%eax
  801090:	8a 00                	mov    (%eax),%al
  801092:	3c 60                	cmp    $0x60,%al
  801094:	7e 19                	jle    8010af <strtol+0xe4>
  801096:	8b 45 08             	mov    0x8(%ebp),%eax
  801099:	8a 00                	mov    (%eax),%al
  80109b:	3c 7a                	cmp    $0x7a,%al
  80109d:	7f 10                	jg     8010af <strtol+0xe4>
			dig = *s - 'a' + 10;
  80109f:	8b 45 08             	mov    0x8(%ebp),%eax
  8010a2:	8a 00                	mov    (%eax),%al
  8010a4:	0f be c0             	movsbl %al,%eax
  8010a7:	83 e8 57             	sub    $0x57,%eax
  8010aa:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8010ad:	eb 20                	jmp    8010cf <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  8010af:	8b 45 08             	mov    0x8(%ebp),%eax
  8010b2:	8a 00                	mov    (%eax),%al
  8010b4:	3c 40                	cmp    $0x40,%al
  8010b6:	7e 39                	jle    8010f1 <strtol+0x126>
  8010b8:	8b 45 08             	mov    0x8(%ebp),%eax
  8010bb:	8a 00                	mov    (%eax),%al
  8010bd:	3c 5a                	cmp    $0x5a,%al
  8010bf:	7f 30                	jg     8010f1 <strtol+0x126>
			dig = *s - 'A' + 10;
  8010c1:	8b 45 08             	mov    0x8(%ebp),%eax
  8010c4:	8a 00                	mov    (%eax),%al
  8010c6:	0f be c0             	movsbl %al,%eax
  8010c9:	83 e8 37             	sub    $0x37,%eax
  8010cc:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  8010cf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8010d2:	3b 45 10             	cmp    0x10(%ebp),%eax
  8010d5:	7d 19                	jge    8010f0 <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  8010d7:	ff 45 08             	incl   0x8(%ebp)
  8010da:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8010dd:	0f af 45 10          	imul   0x10(%ebp),%eax
  8010e1:	89 c2                	mov    %eax,%edx
  8010e3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8010e6:	01 d0                	add    %edx,%eax
  8010e8:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  8010eb:	e9 7b ff ff ff       	jmp    80106b <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  8010f0:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  8010f1:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8010f5:	74 08                	je     8010ff <strtol+0x134>
		*endptr = (char *) s;
  8010f7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010fa:	8b 55 08             	mov    0x8(%ebp),%edx
  8010fd:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  8010ff:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801103:	74 07                	je     80110c <strtol+0x141>
  801105:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801108:	f7 d8                	neg    %eax
  80110a:	eb 03                	jmp    80110f <strtol+0x144>
  80110c:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  80110f:	c9                   	leave  
  801110:	c3                   	ret    

00801111 <ltostr>:

void
ltostr(long value, char *str)
{
  801111:	55                   	push   %ebp
  801112:	89 e5                	mov    %esp,%ebp
  801114:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  801117:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  80111e:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  801125:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801129:	79 13                	jns    80113e <ltostr+0x2d>
	{
		neg = 1;
  80112b:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  801132:	8b 45 0c             	mov    0xc(%ebp),%eax
  801135:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  801138:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  80113b:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  80113e:	8b 45 08             	mov    0x8(%ebp),%eax
  801141:	b9 0a 00 00 00       	mov    $0xa,%ecx
  801146:	99                   	cltd   
  801147:	f7 f9                	idiv   %ecx
  801149:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  80114c:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80114f:	8d 50 01             	lea    0x1(%eax),%edx
  801152:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801155:	89 c2                	mov    %eax,%edx
  801157:	8b 45 0c             	mov    0xc(%ebp),%eax
  80115a:	01 d0                	add    %edx,%eax
  80115c:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80115f:	83 c2 30             	add    $0x30,%edx
  801162:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  801164:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801167:	b8 67 66 66 66       	mov    $0x66666667,%eax
  80116c:	f7 e9                	imul   %ecx
  80116e:	c1 fa 02             	sar    $0x2,%edx
  801171:	89 c8                	mov    %ecx,%eax
  801173:	c1 f8 1f             	sar    $0x1f,%eax
  801176:	29 c2                	sub    %eax,%edx
  801178:	89 d0                	mov    %edx,%eax
  80117a:	89 45 08             	mov    %eax,0x8(%ebp)
	} while (value % 10 != 0);
  80117d:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801180:	b8 67 66 66 66       	mov    $0x66666667,%eax
  801185:	f7 e9                	imul   %ecx
  801187:	c1 fa 02             	sar    $0x2,%edx
  80118a:	89 c8                	mov    %ecx,%eax
  80118c:	c1 f8 1f             	sar    $0x1f,%eax
  80118f:	29 c2                	sub    %eax,%edx
  801191:	89 d0                	mov    %edx,%eax
  801193:	c1 e0 02             	shl    $0x2,%eax
  801196:	01 d0                	add    %edx,%eax
  801198:	01 c0                	add    %eax,%eax
  80119a:	29 c1                	sub    %eax,%ecx
  80119c:	89 ca                	mov    %ecx,%edx
  80119e:	85 d2                	test   %edx,%edx
  8011a0:	75 9c                	jne    80113e <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  8011a2:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  8011a9:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8011ac:	48                   	dec    %eax
  8011ad:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  8011b0:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8011b4:	74 3d                	je     8011f3 <ltostr+0xe2>
		start = 1 ;
  8011b6:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  8011bd:	eb 34                	jmp    8011f3 <ltostr+0xe2>
	{
		char tmp = str[start] ;
  8011bf:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8011c2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011c5:	01 d0                	add    %edx,%eax
  8011c7:	8a 00                	mov    (%eax),%al
  8011c9:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  8011cc:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8011cf:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011d2:	01 c2                	add    %eax,%edx
  8011d4:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  8011d7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011da:	01 c8                	add    %ecx,%eax
  8011dc:	8a 00                	mov    (%eax),%al
  8011de:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  8011e0:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8011e3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011e6:	01 c2                	add    %eax,%edx
  8011e8:	8a 45 eb             	mov    -0x15(%ebp),%al
  8011eb:	88 02                	mov    %al,(%edx)
		start++ ;
  8011ed:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  8011f0:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  8011f3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8011f6:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8011f9:	7c c4                	jl     8011bf <ltostr+0xae>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  8011fb:	8b 55 f8             	mov    -0x8(%ebp),%edx
  8011fe:	8b 45 0c             	mov    0xc(%ebp),%eax
  801201:	01 d0                	add    %edx,%eax
  801203:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  801206:	90                   	nop
  801207:	c9                   	leave  
  801208:	c3                   	ret    

00801209 <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  801209:	55                   	push   %ebp
  80120a:	89 e5                	mov    %esp,%ebp
  80120c:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  80120f:	ff 75 08             	pushl  0x8(%ebp)
  801212:	e8 54 fa ff ff       	call   800c6b <strlen>
  801217:	83 c4 04             	add    $0x4,%esp
  80121a:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  80121d:	ff 75 0c             	pushl  0xc(%ebp)
  801220:	e8 46 fa ff ff       	call   800c6b <strlen>
  801225:	83 c4 04             	add    $0x4,%esp
  801228:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  80122b:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  801232:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801239:	eb 17                	jmp    801252 <strcconcat+0x49>
		final[s] = str1[s] ;
  80123b:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80123e:	8b 45 10             	mov    0x10(%ebp),%eax
  801241:	01 c2                	add    %eax,%edx
  801243:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  801246:	8b 45 08             	mov    0x8(%ebp),%eax
  801249:	01 c8                	add    %ecx,%eax
  80124b:	8a 00                	mov    (%eax),%al
  80124d:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  80124f:	ff 45 fc             	incl   -0x4(%ebp)
  801252:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801255:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  801258:	7c e1                	jl     80123b <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  80125a:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  801261:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  801268:	eb 1f                	jmp    801289 <strcconcat+0x80>
		final[s++] = str2[i] ;
  80126a:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80126d:	8d 50 01             	lea    0x1(%eax),%edx
  801270:	89 55 fc             	mov    %edx,-0x4(%ebp)
  801273:	89 c2                	mov    %eax,%edx
  801275:	8b 45 10             	mov    0x10(%ebp),%eax
  801278:	01 c2                	add    %eax,%edx
  80127a:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  80127d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801280:	01 c8                	add    %ecx,%eax
  801282:	8a 00                	mov    (%eax),%al
  801284:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  801286:	ff 45 f8             	incl   -0x8(%ebp)
  801289:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80128c:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80128f:	7c d9                	jl     80126a <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  801291:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801294:	8b 45 10             	mov    0x10(%ebp),%eax
  801297:	01 d0                	add    %edx,%eax
  801299:	c6 00 00             	movb   $0x0,(%eax)
}
  80129c:	90                   	nop
  80129d:	c9                   	leave  
  80129e:	c3                   	ret    

0080129f <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  80129f:	55                   	push   %ebp
  8012a0:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  8012a2:	8b 45 14             	mov    0x14(%ebp),%eax
  8012a5:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  8012ab:	8b 45 14             	mov    0x14(%ebp),%eax
  8012ae:	8b 00                	mov    (%eax),%eax
  8012b0:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8012b7:	8b 45 10             	mov    0x10(%ebp),%eax
  8012ba:	01 d0                	add    %edx,%eax
  8012bc:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  8012c2:	eb 0c                	jmp    8012d0 <strsplit+0x31>
			*string++ = 0;
  8012c4:	8b 45 08             	mov    0x8(%ebp),%eax
  8012c7:	8d 50 01             	lea    0x1(%eax),%edx
  8012ca:	89 55 08             	mov    %edx,0x8(%ebp)
  8012cd:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  8012d0:	8b 45 08             	mov    0x8(%ebp),%eax
  8012d3:	8a 00                	mov    (%eax),%al
  8012d5:	84 c0                	test   %al,%al
  8012d7:	74 18                	je     8012f1 <strsplit+0x52>
  8012d9:	8b 45 08             	mov    0x8(%ebp),%eax
  8012dc:	8a 00                	mov    (%eax),%al
  8012de:	0f be c0             	movsbl %al,%eax
  8012e1:	50                   	push   %eax
  8012e2:	ff 75 0c             	pushl  0xc(%ebp)
  8012e5:	e8 13 fb ff ff       	call   800dfd <strchr>
  8012ea:	83 c4 08             	add    $0x8,%esp
  8012ed:	85 c0                	test   %eax,%eax
  8012ef:	75 d3                	jne    8012c4 <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  8012f1:	8b 45 08             	mov    0x8(%ebp),%eax
  8012f4:	8a 00                	mov    (%eax),%al
  8012f6:	84 c0                	test   %al,%al
  8012f8:	74 5a                	je     801354 <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  8012fa:	8b 45 14             	mov    0x14(%ebp),%eax
  8012fd:	8b 00                	mov    (%eax),%eax
  8012ff:	83 f8 0f             	cmp    $0xf,%eax
  801302:	75 07                	jne    80130b <strsplit+0x6c>
		{
			return 0;
  801304:	b8 00 00 00 00       	mov    $0x0,%eax
  801309:	eb 66                	jmp    801371 <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  80130b:	8b 45 14             	mov    0x14(%ebp),%eax
  80130e:	8b 00                	mov    (%eax),%eax
  801310:	8d 48 01             	lea    0x1(%eax),%ecx
  801313:	8b 55 14             	mov    0x14(%ebp),%edx
  801316:	89 0a                	mov    %ecx,(%edx)
  801318:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80131f:	8b 45 10             	mov    0x10(%ebp),%eax
  801322:	01 c2                	add    %eax,%edx
  801324:	8b 45 08             	mov    0x8(%ebp),%eax
  801327:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  801329:	eb 03                	jmp    80132e <strsplit+0x8f>
			string++;
  80132b:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  80132e:	8b 45 08             	mov    0x8(%ebp),%eax
  801331:	8a 00                	mov    (%eax),%al
  801333:	84 c0                	test   %al,%al
  801335:	74 8b                	je     8012c2 <strsplit+0x23>
  801337:	8b 45 08             	mov    0x8(%ebp),%eax
  80133a:	8a 00                	mov    (%eax),%al
  80133c:	0f be c0             	movsbl %al,%eax
  80133f:	50                   	push   %eax
  801340:	ff 75 0c             	pushl  0xc(%ebp)
  801343:	e8 b5 fa ff ff       	call   800dfd <strchr>
  801348:	83 c4 08             	add    $0x8,%esp
  80134b:	85 c0                	test   %eax,%eax
  80134d:	74 dc                	je     80132b <strsplit+0x8c>
			string++;
	}
  80134f:	e9 6e ff ff ff       	jmp    8012c2 <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  801354:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  801355:	8b 45 14             	mov    0x14(%ebp),%eax
  801358:	8b 00                	mov    (%eax),%eax
  80135a:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801361:	8b 45 10             	mov    0x10(%ebp),%eax
  801364:	01 d0                	add    %edx,%eax
  801366:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  80136c:	b8 01 00 00 00       	mov    $0x1,%eax
}
  801371:	c9                   	leave  
  801372:	c3                   	ret    

00801373 <InitializeUHeap>:
//============================== GIVEN FUNCTIONS ===================================//
//==================================================================================//

int FirstTimeFlag = 1;
void InitializeUHeap()
{
  801373:	55                   	push   %ebp
  801374:	89 e5                	mov    %esp,%ebp
  801376:	83 ec 08             	sub    $0x8,%esp
	if(FirstTimeFlag)
  801379:	a1 04 40 80 00       	mov    0x804004,%eax
  80137e:	85 c0                	test   %eax,%eax
  801380:	74 1f                	je     8013a1 <InitializeUHeap+0x2e>
	{
		initialize_dyn_block_system();
  801382:	e8 1d 00 00 00       	call   8013a4 <initialize_dyn_block_system>
		cprintf("DYNAMIC BLOCK SYSTEM IS INITIALIZED\n");
  801387:	83 ec 0c             	sub    $0xc,%esp
  80138a:	68 f0 38 80 00       	push   $0x8038f0
  80138f:	e8 55 f2 ff ff       	call   8005e9 <cprintf>
  801394:	83 c4 10             	add    $0x10,%esp
#if UHP_USE_BUDDY
		initialize_buddy();
		cprintf("BUDDY SYSTEM IS INITIALIZED\n");
#endif
		FirstTimeFlag = 0;
  801397:	c7 05 04 40 80 00 00 	movl   $0x0,0x804004
  80139e:	00 00 00 
	}
}
  8013a1:	90                   	nop
  8013a2:	c9                   	leave  
  8013a3:	c3                   	ret    

008013a4 <initialize_dyn_block_system>:

//=================================
// [1] INITIALIZE DYNAMIC ALLOCATOR:
//=================================
void initialize_dyn_block_system()
{
  8013a4:	55                   	push   %ebp
  8013a5:	89 e5                	mov    %esp,%ebp
  8013a7:	83 ec 28             	sub    $0x28,%esp
	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] initialize_dyn_block_system
	// your code is here, remove the panic and write your code
	//panic("initialize_dyn_block_system() is not implemented yet...!!");

	LIST_INIT(&AllocMemBlocksList);
  8013aa:	c7 05 40 40 80 00 00 	movl   $0x0,0x804040
  8013b1:	00 00 00 
  8013b4:	c7 05 44 40 80 00 00 	movl   $0x0,0x804044
  8013bb:	00 00 00 
  8013be:	c7 05 4c 40 80 00 00 	movl   $0x0,0x80404c
  8013c5:	00 00 00 
	LIST_INIT(&FreeMemBlocksList);
  8013c8:	c7 05 38 41 80 00 00 	movl   $0x0,0x804138
  8013cf:	00 00 00 
  8013d2:	c7 05 3c 41 80 00 00 	movl   $0x0,0x80413c
  8013d9:	00 00 00 
  8013dc:	c7 05 44 41 80 00 00 	movl   $0x0,0x804144
  8013e3:	00 00 00 
	MAX_MEM_BLOCK_CNT = NUM_OF_UHEAP_PAGES;
  8013e6:	c7 05 20 41 80 00 00 	movl   $0x20000,0x804120
  8013ed:	00 02 00 
	MemBlockNodes = (void*)USER_DYN_BLKS_ARRAY;
  8013f0:	c7 45 f4 00 00 e0 7f 	movl   $0x7fe00000,-0xc(%ebp)
  8013f7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8013fa:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8013ff:	2d 00 10 00 00       	sub    $0x1000,%eax
  801404:	a3 50 40 80 00       	mov    %eax,0x804050
	int size_of_block = sizeof(struct MemBlock);
  801409:	c7 45 f0 10 00 00 00 	movl   $0x10,-0x10(%ebp)
	int size_all_struct = size_of_block*MAX_MEM_BLOCK_CNT;
  801410:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801413:	a1 20 41 80 00       	mov    0x804120,%eax
  801418:	0f af c2             	imul   %edx,%eax
  80141b:	89 45 ec             	mov    %eax,-0x14(%ebp)
	size_all_struct = ROUNDUP(size_all_struct, PAGE_SIZE);
  80141e:	c7 45 e8 00 10 00 00 	movl   $0x1000,-0x18(%ebp)
  801425:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801428:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80142b:	01 d0                	add    %edx,%eax
  80142d:	48                   	dec    %eax
  80142e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  801431:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801434:	ba 00 00 00 00       	mov    $0x0,%edx
  801439:	f7 75 e8             	divl   -0x18(%ebp)
  80143c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80143f:	29 d0                	sub    %edx,%eax
  801441:	89 45 ec             	mov    %eax,-0x14(%ebp)
	sys_allocate_chunk(USER_DYN_BLKS_ARRAY, size_all_struct,PERM_USER| PERM_WRITEABLE);
  801444:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801447:	c7 45 e0 00 00 e0 7f 	movl   $0x7fe00000,-0x20(%ebp)
  80144e:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801451:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
  801457:	81 ea 00 10 00 00    	sub    $0x1000,%edx
  80145d:	83 ec 04             	sub    $0x4,%esp
  801460:	6a 06                	push   $0x6
  801462:	50                   	push   %eax
  801463:	52                   	push   %edx
  801464:	e8 a1 05 00 00       	call   801a0a <sys_allocate_chunk>
  801469:	83 c4 10             	add    $0x10,%esp
	initialize_MemBlocksList(MAX_MEM_BLOCK_CNT);
  80146c:	a1 20 41 80 00       	mov    0x804120,%eax
  801471:	83 ec 0c             	sub    $0xc,%esp
  801474:	50                   	push   %eax
  801475:	e8 16 0c 00 00       	call   802090 <initialize_MemBlocksList>
  80147a:	83 c4 10             	add    $0x10,%esp
	struct MemBlock* ourBlock =LIST_LAST(&AvailableMemBlocksList);
  80147d:	a1 4c 41 80 00       	mov    0x80414c,%eax
  801482:	89 45 dc             	mov    %eax,-0x24(%ebp)
	LIST_REMOVE(&AvailableMemBlocksList,ourBlock);
  801485:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  801489:	75 14                	jne    80149f <initialize_dyn_block_system+0xfb>
  80148b:	83 ec 04             	sub    $0x4,%esp
  80148e:	68 15 39 80 00       	push   $0x803915
  801493:	6a 2d                	push   $0x2d
  801495:	68 33 39 80 00       	push   $0x803933
  80149a:	e8 96 ee ff ff       	call   800335 <_panic>
  80149f:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8014a2:	8b 00                	mov    (%eax),%eax
  8014a4:	85 c0                	test   %eax,%eax
  8014a6:	74 10                	je     8014b8 <initialize_dyn_block_system+0x114>
  8014a8:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8014ab:	8b 00                	mov    (%eax),%eax
  8014ad:	8b 55 dc             	mov    -0x24(%ebp),%edx
  8014b0:	8b 52 04             	mov    0x4(%edx),%edx
  8014b3:	89 50 04             	mov    %edx,0x4(%eax)
  8014b6:	eb 0b                	jmp    8014c3 <initialize_dyn_block_system+0x11f>
  8014b8:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8014bb:	8b 40 04             	mov    0x4(%eax),%eax
  8014be:	a3 4c 41 80 00       	mov    %eax,0x80414c
  8014c3:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8014c6:	8b 40 04             	mov    0x4(%eax),%eax
  8014c9:	85 c0                	test   %eax,%eax
  8014cb:	74 0f                	je     8014dc <initialize_dyn_block_system+0x138>
  8014cd:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8014d0:	8b 40 04             	mov    0x4(%eax),%eax
  8014d3:	8b 55 dc             	mov    -0x24(%ebp),%edx
  8014d6:	8b 12                	mov    (%edx),%edx
  8014d8:	89 10                	mov    %edx,(%eax)
  8014da:	eb 0a                	jmp    8014e6 <initialize_dyn_block_system+0x142>
  8014dc:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8014df:	8b 00                	mov    (%eax),%eax
  8014e1:	a3 48 41 80 00       	mov    %eax,0x804148
  8014e6:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8014e9:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8014ef:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8014f2:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8014f9:	a1 54 41 80 00       	mov    0x804154,%eax
  8014fe:	48                   	dec    %eax
  8014ff:	a3 54 41 80 00       	mov    %eax,0x804154
	ourBlock->size = USER_HEAP_MAX-USER_HEAP_START;
  801504:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801507:	c7 40 0c 00 00 00 20 	movl   $0x20000000,0xc(%eax)
	ourBlock->sva=USER_HEAP_START;
  80150e:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801511:	c7 40 08 00 00 00 80 	movl   $0x80000000,0x8(%eax)
	LIST_INSERT_TAIL(&FreeMemBlocksList, ourBlock);
  801518:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  80151c:	75 14                	jne    801532 <initialize_dyn_block_system+0x18e>
  80151e:	83 ec 04             	sub    $0x4,%esp
  801521:	68 40 39 80 00       	push   $0x803940
  801526:	6a 30                	push   $0x30
  801528:	68 33 39 80 00       	push   $0x803933
  80152d:	e8 03 ee ff ff       	call   800335 <_panic>
  801532:	8b 15 3c 41 80 00    	mov    0x80413c,%edx
  801538:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80153b:	89 50 04             	mov    %edx,0x4(%eax)
  80153e:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801541:	8b 40 04             	mov    0x4(%eax),%eax
  801544:	85 c0                	test   %eax,%eax
  801546:	74 0c                	je     801554 <initialize_dyn_block_system+0x1b0>
  801548:	a1 3c 41 80 00       	mov    0x80413c,%eax
  80154d:	8b 55 dc             	mov    -0x24(%ebp),%edx
  801550:	89 10                	mov    %edx,(%eax)
  801552:	eb 08                	jmp    80155c <initialize_dyn_block_system+0x1b8>
  801554:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801557:	a3 38 41 80 00       	mov    %eax,0x804138
  80155c:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80155f:	a3 3c 41 80 00       	mov    %eax,0x80413c
  801564:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801567:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80156d:	a1 44 41 80 00       	mov    0x804144,%eax
  801572:	40                   	inc    %eax
  801573:	a3 44 41 80 00       	mov    %eax,0x804144
	//[1] Initialize two lists (AllocMemBlocksList & FreeMemBlocksList) [Hint: use LIST_INIT()]
	//[2] Dynamically allocate the array of MemBlockNodes at VA USER_DYN_BLKS_ARRAY
	//	  (remember to set MAX_MEM_BLOCK_CNT with the chosen size of the array)
	//[3] Initialize AvailableMemBlocksList by filling it with the MemBlockNodes
	//[4] Insert a new MemBlock with the heap size into the FreeMemBlocksList
}
  801578:	90                   	nop
  801579:	c9                   	leave  
  80157a:	c3                   	ret    

0080157b <malloc>:
//=================================
// [2] ALLOCATE SPACE IN USER HEAP:
//=================================

void* malloc(uint32 size)
{
  80157b:	55                   	push   %ebp
  80157c:	89 e5                	mov    %esp,%ebp
  80157e:	83 ec 18             	sub    $0x18,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801581:	e8 ed fd ff ff       	call   801373 <InitializeUHeap>
	if (size == 0) return NULL ;
  801586:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80158a:	75 07                	jne    801593 <malloc+0x18>
  80158c:	b8 00 00 00 00       	mov    $0x0,%eax
  801591:	eb 67                	jmp    8015fa <malloc+0x7f>

	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] malloc
	// your code is here, remove the panic and write your code
	//panic("malloc() is not implemented yet...!!");

	size = ROUNDUP(size, PAGE_SIZE);
  801593:	c7 45 f4 00 10 00 00 	movl   $0x1000,-0xc(%ebp)
  80159a:	8b 55 08             	mov    0x8(%ebp),%edx
  80159d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8015a0:	01 d0                	add    %edx,%eax
  8015a2:	48                   	dec    %eax
  8015a3:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8015a6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8015a9:	ba 00 00 00 00       	mov    $0x0,%edx
  8015ae:	f7 75 f4             	divl   -0xc(%ebp)
  8015b1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8015b4:	29 d0                	sub    %edx,%eax
  8015b6:	89 45 08             	mov    %eax,0x8(%ebp)
	if(sys_isUHeapPlacementStrategyFIRSTFIT())
  8015b9:	e8 1a 08 00 00       	call   801dd8 <sys_isUHeapPlacementStrategyFIRSTFIT>
  8015be:	85 c0                	test   %eax,%eax
  8015c0:	74 33                	je     8015f5 <malloc+0x7a>
	{
		struct MemBlock * myBlock = alloc_block_FF(size);
  8015c2:	83 ec 0c             	sub    $0xc,%esp
  8015c5:	ff 75 08             	pushl  0x8(%ebp)
  8015c8:	e8 0c 0e 00 00       	call   8023d9 <alloc_block_FF>
  8015cd:	83 c4 10             	add    $0x10,%esp
  8015d0:	89 45 ec             	mov    %eax,-0x14(%ebp)
		if(myBlock != NULL)
  8015d3:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8015d7:	74 1c                	je     8015f5 <malloc+0x7a>
		{
			insert_sorted_allocList(myBlock);
  8015d9:	83 ec 0c             	sub    $0xc,%esp
  8015dc:	ff 75 ec             	pushl  -0x14(%ebp)
  8015df:	e8 07 0c 00 00       	call   8021eb <insert_sorted_allocList>
  8015e4:	83 c4 10             	add    $0x10,%esp
			uint32 ptr = myBlock->sva;
  8015e7:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8015ea:	8b 40 08             	mov    0x8(%eax),%eax
  8015ed:	89 45 e8             	mov    %eax,-0x18(%ebp)
			return (void *)ptr;
  8015f0:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8015f3:	eb 05                	jmp    8015fa <malloc+0x7f>
		}
	}
	return NULL;
  8015f5:	b8 00 00 00 00       	mov    $0x0,%eax
	//		to the required allocation size (space should be on 4 KB BOUNDARY)
	//	2) if no suitable space found, return NULL
	// 	3) Return pointer containing the virtual address of allocated space,
	//
	//Use sys_isUHeapPlacementStrategyFIRSTFIT()... to check the current strategy
}
  8015fa:	c9                   	leave  
  8015fb:	c3                   	ret    

008015fc <free>:
//	We can use sys_free_user_mem(uint32 virtual_address, uint32 size); which
//		switches to the kernel mode, calls free_user_mem() in
//		"kern/mem/chunk_operations.c", then switch back to the user mode here
//	the free_user_mem function is empty, make sure to implement it.
void free(void* virtual_address)
{
  8015fc:	55                   	push   %ebp
  8015fd:	89 e5                	mov    %esp,%ebp
  8015ff:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] free
	// your code is here, remove the panic and write your code
	//panic("free() is not implemented yet...!!");

	uint32 virtualAddress = (uint32 )(virtual_address);
  801602:	8b 45 08             	mov    0x8(%ebp),%eax
  801605:	89 45 f4             	mov    %eax,-0xc(%ebp)
//	virtualAddress = ROUNDDOWN(virtualAddress, PAGE_SIZE);
	struct MemBlock * myBlock = find_block(&AllocMemBlocksList, virtualAddress);
  801608:	83 ec 08             	sub    $0x8,%esp
  80160b:	ff 75 f4             	pushl  -0xc(%ebp)
  80160e:	68 40 40 80 00       	push   $0x804040
  801613:	e8 5b 0b 00 00       	call   802173 <find_block>
  801618:	83 c4 10             	add    $0x10,%esp
  80161b:	89 45 f0             	mov    %eax,-0x10(%ebp)
//	cprintf ("ptr sva at free user side = %x \n", myBlock->sva);
	sys_free_user_mem(virtualAddress, myBlock->size);
  80161e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801621:	8b 40 0c             	mov    0xc(%eax),%eax
  801624:	83 ec 08             	sub    $0x8,%esp
  801627:	50                   	push   %eax
  801628:	ff 75 f4             	pushl  -0xc(%ebp)
  80162b:	e8 a2 03 00 00       	call   8019d2 <sys_free_user_mem>
  801630:	83 c4 10             	add    $0x10,%esp
	LIST_REMOVE(&AllocMemBlocksList, myBlock);
  801633:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801637:	75 14                	jne    80164d <free+0x51>
  801639:	83 ec 04             	sub    $0x4,%esp
  80163c:	68 15 39 80 00       	push   $0x803915
  801641:	6a 76                	push   $0x76
  801643:	68 33 39 80 00       	push   $0x803933
  801648:	e8 e8 ec ff ff       	call   800335 <_panic>
  80164d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801650:	8b 00                	mov    (%eax),%eax
  801652:	85 c0                	test   %eax,%eax
  801654:	74 10                	je     801666 <free+0x6a>
  801656:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801659:	8b 00                	mov    (%eax),%eax
  80165b:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80165e:	8b 52 04             	mov    0x4(%edx),%edx
  801661:	89 50 04             	mov    %edx,0x4(%eax)
  801664:	eb 0b                	jmp    801671 <free+0x75>
  801666:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801669:	8b 40 04             	mov    0x4(%eax),%eax
  80166c:	a3 44 40 80 00       	mov    %eax,0x804044
  801671:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801674:	8b 40 04             	mov    0x4(%eax),%eax
  801677:	85 c0                	test   %eax,%eax
  801679:	74 0f                	je     80168a <free+0x8e>
  80167b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80167e:	8b 40 04             	mov    0x4(%eax),%eax
  801681:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801684:	8b 12                	mov    (%edx),%edx
  801686:	89 10                	mov    %edx,(%eax)
  801688:	eb 0a                	jmp    801694 <free+0x98>
  80168a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80168d:	8b 00                	mov    (%eax),%eax
  80168f:	a3 40 40 80 00       	mov    %eax,0x804040
  801694:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801697:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80169d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8016a0:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8016a7:	a1 4c 40 80 00       	mov    0x80404c,%eax
  8016ac:	48                   	dec    %eax
  8016ad:	a3 4c 40 80 00       	mov    %eax,0x80404c
	insert_sorted_with_merge_freeList(myBlock);
  8016b2:	83 ec 0c             	sub    $0xc,%esp
  8016b5:	ff 75 f0             	pushl  -0x10(%ebp)
  8016b8:	e8 0b 14 00 00       	call   802ac8 <insert_sorted_with_merge_freeList>
  8016bd:	83 c4 10             	add    $0x10,%esp

	//you should get the size of the given allocation using its address
	//you need to call sys_free_user_mem()
	//refer to the project presentation and documentation for details
}
  8016c0:	90                   	nop
  8016c1:	c9                   	leave  
  8016c2:	c3                   	ret    

008016c3 <smalloc>:

//=================================
// [4] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
  8016c3:	55                   	push   %ebp
  8016c4:	89 e5                	mov    %esp,%ebp
  8016c6:	83 ec 28             	sub    $0x28,%esp
  8016c9:	8b 45 10             	mov    0x10(%ebp),%eax
  8016cc:	88 45 e4             	mov    %al,-0x1c(%ebp)
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  8016cf:	e8 9f fc ff ff       	call   801373 <InitializeUHeap>
	if (size == 0) return NULL ;
  8016d4:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8016d8:	75 0a                	jne    8016e4 <smalloc+0x21>
  8016da:	b8 00 00 00 00       	mov    $0x0,%eax
  8016df:	e9 8d 00 00 00       	jmp    801771 <smalloc+0xae>

	//This function should find the space of the required range
	// * ON 4KB BOUNDARY **** //
	//Use sys_isUHeapPlacementStrategyFIRSTFIT() to check the current strategy

	size = ROUNDUP(size, PAGE_SIZE);
  8016e4:	c7 45 f4 00 10 00 00 	movl   $0x1000,-0xc(%ebp)
  8016eb:	8b 55 0c             	mov    0xc(%ebp),%edx
  8016ee:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8016f1:	01 d0                	add    %edx,%eax
  8016f3:	48                   	dec    %eax
  8016f4:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8016f7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8016fa:	ba 00 00 00 00       	mov    $0x0,%edx
  8016ff:	f7 75 f4             	divl   -0xc(%ebp)
  801702:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801705:	29 d0                	sub    %edx,%eax
  801707:	89 45 0c             	mov    %eax,0xc(%ebp)
		if(sys_isUHeapPlacementStrategyFIRSTFIT())
  80170a:	e8 c9 06 00 00       	call   801dd8 <sys_isUHeapPlacementStrategyFIRSTFIT>
  80170f:	85 c0                	test   %eax,%eax
  801711:	74 59                	je     80176c <smalloc+0xa9>
		{
			struct MemBlock * v1=NULL;
  801713:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
			v1= alloc_block_FF(size);
  80171a:	83 ec 0c             	sub    $0xc,%esp
  80171d:	ff 75 0c             	pushl  0xc(%ebp)
  801720:	e8 b4 0c 00 00       	call   8023d9 <alloc_block_FF>
  801725:	83 c4 10             	add    $0x10,%esp
  801728:	89 45 ec             	mov    %eax,-0x14(%ebp)
			if(v1==NULL)
  80172b:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  80172f:	75 07                	jne    801738 <smalloc+0x75>
			{
				return NULL;
  801731:	b8 00 00 00 00       	mov    $0x0,%eax
  801736:	eb 39                	jmp    801771 <smalloc+0xae>
			}
			else
			{
				int ret=sys_createSharedObject(sharedVarName,  size,  isWritable,(void*)v1->sva);
  801738:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80173b:	8b 40 08             	mov    0x8(%eax),%eax
  80173e:	89 c2                	mov    %eax,%edx
  801740:	0f b6 45 e4          	movzbl -0x1c(%ebp),%eax
  801744:	52                   	push   %edx
  801745:	50                   	push   %eax
  801746:	ff 75 0c             	pushl  0xc(%ebp)
  801749:	ff 75 08             	pushl  0x8(%ebp)
  80174c:	e8 0c 04 00 00       	call   801b5d <sys_createSharedObject>
  801751:	83 c4 10             	add    $0x10,%esp
  801754:	89 45 e8             	mov    %eax,-0x18(%ebp)
				if(ret>=0)
  801757:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  80175b:	78 08                	js     801765 <smalloc+0xa2>
				{
					return (void*)v1->sva;
  80175d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801760:	8b 40 08             	mov    0x8(%eax),%eax
  801763:	eb 0c                	jmp    801771 <smalloc+0xae>
				}
				else
				{
					return NULL;
  801765:	b8 00 00 00 00       	mov    $0x0,%eax
  80176a:	eb 05                	jmp    801771 <smalloc+0xae>
				}
			}

		}
		return NULL;
  80176c:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801771:	c9                   	leave  
  801772:	c3                   	ret    

00801773 <sget>:

//========================================
// [5] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  801773:	55                   	push   %ebp
  801774:	89 e5                	mov    %esp,%ebp
  801776:	83 ec 18             	sub    $0x18,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801779:	e8 f5 fb ff ff       	call   801373 <InitializeUHeap>

	//This function should find the space for sharing the variable
	// *** ON 4KB BOUNDARY ******** //

	//Use sys_isUHeapPlacementStrategyFIRSTFIT() to check the current strategy
	int ret=sys_getSizeOfSharedObject(ownerEnvID,sharedVarName);
  80177e:	83 ec 08             	sub    $0x8,%esp
  801781:	ff 75 0c             	pushl  0xc(%ebp)
  801784:	ff 75 08             	pushl  0x8(%ebp)
  801787:	e8 fb 03 00 00       	call   801b87 <sys_getSizeOfSharedObject>
  80178c:	83 c4 10             	add    $0x10,%esp
  80178f:	89 45 f4             	mov    %eax,-0xc(%ebp)
	if(ret==0)
  801792:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801796:	75 07                	jne    80179f <sget+0x2c>
	{
		return NULL;
  801798:	b8 00 00 00 00       	mov    $0x0,%eax
  80179d:	eb 64                	jmp    801803 <sget+0x90>
	}
	if(sys_isUHeapPlacementStrategyFIRSTFIT())
  80179f:	e8 34 06 00 00       	call   801dd8 <sys_isUHeapPlacementStrategyFIRSTFIT>
  8017a4:	85 c0                	test   %eax,%eax
  8017a6:	74 56                	je     8017fe <sget+0x8b>
	{
		struct MemBlock * v1=NULL;
  8017a8:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
		v1= alloc_block_FF(ret);
  8017af:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8017b2:	83 ec 0c             	sub    $0xc,%esp
  8017b5:	50                   	push   %eax
  8017b6:	e8 1e 0c 00 00       	call   8023d9 <alloc_block_FF>
  8017bb:	83 c4 10             	add    $0x10,%esp
  8017be:	89 45 f0             	mov    %eax,-0x10(%ebp)
		if(v1==NULL)
  8017c1:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8017c5:	75 07                	jne    8017ce <sget+0x5b>
		{
		return NULL;
  8017c7:	b8 00 00 00 00       	mov    $0x0,%eax
  8017cc:	eb 35                	jmp    801803 <sget+0x90>
	    }
		else
		{
			int ret1=sys_getSharedObject(ownerEnvID,sharedVarName,(void*)v1->sva);
  8017ce:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8017d1:	8b 40 08             	mov    0x8(%eax),%eax
  8017d4:	83 ec 04             	sub    $0x4,%esp
  8017d7:	50                   	push   %eax
  8017d8:	ff 75 0c             	pushl  0xc(%ebp)
  8017db:	ff 75 08             	pushl  0x8(%ebp)
  8017de:	e8 c1 03 00 00       	call   801ba4 <sys_getSharedObject>
  8017e3:	83 c4 10             	add    $0x10,%esp
  8017e6:	89 45 ec             	mov    %eax,-0x14(%ebp)
			if(ret1>=0)
  8017e9:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8017ed:	78 08                	js     8017f7 <sget+0x84>
			{
				return (void*)v1->sva;
  8017ef:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8017f2:	8b 40 08             	mov    0x8(%eax),%eax
  8017f5:	eb 0c                	jmp    801803 <sget+0x90>
			}
			else
			{
				return NULL;
  8017f7:	b8 00 00 00 00       	mov    $0x0,%eax
  8017fc:	eb 05                	jmp    801803 <sget+0x90>
			}
		}
	}
  return NULL;
  8017fe:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801803:	c9                   	leave  
  801804:	c3                   	ret    

00801805 <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  801805:	55                   	push   %ebp
  801806:	89 e5                	mov    %esp,%ebp
  801808:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  80180b:	e8 63 fb ff ff       	call   801373 <InitializeUHeap>
	//==============================================================
	// [USER HEAP - USER SIDE] realloc
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  801810:	83 ec 04             	sub    $0x4,%esp
  801813:	68 64 39 80 00       	push   $0x803964
  801818:	68 0e 01 00 00       	push   $0x10e
  80181d:	68 33 39 80 00       	push   $0x803933
  801822:	e8 0e eb ff ff       	call   800335 <_panic>

00801827 <sfree>:
//	use sys_freeSharedObject(...); which switches to the kernel mode,
//	calls freeSharedObject(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the freeSharedObject() function is empty, make sure to implement it.

void sfree(void* virtual_address)
{
  801827:	55                   	push   %ebp
  801828:	89 e5                	mov    %esp,%ebp
  80182a:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS3 - BONUS] [SHARING - USER SIDE] sfree()

	// Write your code here, remove the panic and write your code
	panic("sfree() is not implemented yet...!!");
  80182d:	83 ec 04             	sub    $0x4,%esp
  801830:	68 8c 39 80 00       	push   $0x80398c
  801835:	68 22 01 00 00       	push   $0x122
  80183a:	68 33 39 80 00       	push   $0x803933
  80183f:	e8 f1 ea ff ff       	call   800335 <_panic>

00801844 <expand>:

//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//
void expand(uint32 newSize)
{
  801844:	55                   	push   %ebp
  801845:	89 e5                	mov    %esp,%ebp
  801847:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  80184a:	83 ec 04             	sub    $0x4,%esp
  80184d:	68 b0 39 80 00       	push   $0x8039b0
  801852:	68 2d 01 00 00       	push   $0x12d
  801857:	68 33 39 80 00       	push   $0x803933
  80185c:	e8 d4 ea ff ff       	call   800335 <_panic>

00801861 <shrink>:

}
void shrink(uint32 newSize)
{
  801861:	55                   	push   %ebp
  801862:	89 e5                	mov    %esp,%ebp
  801864:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801867:	83 ec 04             	sub    $0x4,%esp
  80186a:	68 b0 39 80 00       	push   $0x8039b0
  80186f:	68 32 01 00 00       	push   $0x132
  801874:	68 33 39 80 00       	push   $0x803933
  801879:	e8 b7 ea ff ff       	call   800335 <_panic>

0080187e <freeHeap>:

}
void freeHeap(void* virtual_address)
{
  80187e:	55                   	push   %ebp
  80187f:	89 e5                	mov    %esp,%ebp
  801881:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801884:	83 ec 04             	sub    $0x4,%esp
  801887:	68 b0 39 80 00       	push   $0x8039b0
  80188c:	68 37 01 00 00       	push   $0x137
  801891:	68 33 39 80 00       	push   $0x803933
  801896:	e8 9a ea ff ff       	call   800335 <_panic>

0080189b <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  80189b:	55                   	push   %ebp
  80189c:	89 e5                	mov    %esp,%ebp
  80189e:	57                   	push   %edi
  80189f:	56                   	push   %esi
  8018a0:	53                   	push   %ebx
  8018a1:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8018a4:	8b 45 08             	mov    0x8(%ebp),%eax
  8018a7:	8b 55 0c             	mov    0xc(%ebp),%edx
  8018aa:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8018ad:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8018b0:	8b 7d 18             	mov    0x18(%ebp),%edi
  8018b3:	8b 75 1c             	mov    0x1c(%ebp),%esi
  8018b6:	cd 30                	int    $0x30
  8018b8:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  8018bb:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8018be:	83 c4 10             	add    $0x10,%esp
  8018c1:	5b                   	pop    %ebx
  8018c2:	5e                   	pop    %esi
  8018c3:	5f                   	pop    %edi
  8018c4:	5d                   	pop    %ebp
  8018c5:	c3                   	ret    

008018c6 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  8018c6:	55                   	push   %ebp
  8018c7:	89 e5                	mov    %esp,%ebp
  8018c9:	83 ec 04             	sub    $0x4,%esp
  8018cc:	8b 45 10             	mov    0x10(%ebp),%eax
  8018cf:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  8018d2:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  8018d6:	8b 45 08             	mov    0x8(%ebp),%eax
  8018d9:	6a 00                	push   $0x0
  8018db:	6a 00                	push   $0x0
  8018dd:	52                   	push   %edx
  8018de:	ff 75 0c             	pushl  0xc(%ebp)
  8018e1:	50                   	push   %eax
  8018e2:	6a 00                	push   $0x0
  8018e4:	e8 b2 ff ff ff       	call   80189b <syscall>
  8018e9:	83 c4 18             	add    $0x18,%esp
}
  8018ec:	90                   	nop
  8018ed:	c9                   	leave  
  8018ee:	c3                   	ret    

008018ef <sys_cgetc>:

int
sys_cgetc(void)
{
  8018ef:	55                   	push   %ebp
  8018f0:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  8018f2:	6a 00                	push   $0x0
  8018f4:	6a 00                	push   $0x0
  8018f6:	6a 00                	push   $0x0
  8018f8:	6a 00                	push   $0x0
  8018fa:	6a 00                	push   $0x0
  8018fc:	6a 01                	push   $0x1
  8018fe:	e8 98 ff ff ff       	call   80189b <syscall>
  801903:	83 c4 18             	add    $0x18,%esp
}
  801906:	c9                   	leave  
  801907:	c3                   	ret    

00801908 <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  801908:	55                   	push   %ebp
  801909:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  80190b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80190e:	8b 45 08             	mov    0x8(%ebp),%eax
  801911:	6a 00                	push   $0x0
  801913:	6a 00                	push   $0x0
  801915:	6a 00                	push   $0x0
  801917:	52                   	push   %edx
  801918:	50                   	push   %eax
  801919:	6a 05                	push   $0x5
  80191b:	e8 7b ff ff ff       	call   80189b <syscall>
  801920:	83 c4 18             	add    $0x18,%esp
}
  801923:	c9                   	leave  
  801924:	c3                   	ret    

00801925 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  801925:	55                   	push   %ebp
  801926:	89 e5                	mov    %esp,%ebp
  801928:	56                   	push   %esi
  801929:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  80192a:	8b 75 18             	mov    0x18(%ebp),%esi
  80192d:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801930:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801933:	8b 55 0c             	mov    0xc(%ebp),%edx
  801936:	8b 45 08             	mov    0x8(%ebp),%eax
  801939:	56                   	push   %esi
  80193a:	53                   	push   %ebx
  80193b:	51                   	push   %ecx
  80193c:	52                   	push   %edx
  80193d:	50                   	push   %eax
  80193e:	6a 06                	push   $0x6
  801940:	e8 56 ff ff ff       	call   80189b <syscall>
  801945:	83 c4 18             	add    $0x18,%esp
}
  801948:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80194b:	5b                   	pop    %ebx
  80194c:	5e                   	pop    %esi
  80194d:	5d                   	pop    %ebp
  80194e:	c3                   	ret    

0080194f <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  80194f:	55                   	push   %ebp
  801950:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  801952:	8b 55 0c             	mov    0xc(%ebp),%edx
  801955:	8b 45 08             	mov    0x8(%ebp),%eax
  801958:	6a 00                	push   $0x0
  80195a:	6a 00                	push   $0x0
  80195c:	6a 00                	push   $0x0
  80195e:	52                   	push   %edx
  80195f:	50                   	push   %eax
  801960:	6a 07                	push   $0x7
  801962:	e8 34 ff ff ff       	call   80189b <syscall>
  801967:	83 c4 18             	add    $0x18,%esp
}
  80196a:	c9                   	leave  
  80196b:	c3                   	ret    

0080196c <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  80196c:	55                   	push   %ebp
  80196d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  80196f:	6a 00                	push   $0x0
  801971:	6a 00                	push   $0x0
  801973:	6a 00                	push   $0x0
  801975:	ff 75 0c             	pushl  0xc(%ebp)
  801978:	ff 75 08             	pushl  0x8(%ebp)
  80197b:	6a 08                	push   $0x8
  80197d:	e8 19 ff ff ff       	call   80189b <syscall>
  801982:	83 c4 18             	add    $0x18,%esp
}
  801985:	c9                   	leave  
  801986:	c3                   	ret    

00801987 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  801987:	55                   	push   %ebp
  801988:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  80198a:	6a 00                	push   $0x0
  80198c:	6a 00                	push   $0x0
  80198e:	6a 00                	push   $0x0
  801990:	6a 00                	push   $0x0
  801992:	6a 00                	push   $0x0
  801994:	6a 09                	push   $0x9
  801996:	e8 00 ff ff ff       	call   80189b <syscall>
  80199b:	83 c4 18             	add    $0x18,%esp
}
  80199e:	c9                   	leave  
  80199f:	c3                   	ret    

008019a0 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  8019a0:	55                   	push   %ebp
  8019a1:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  8019a3:	6a 00                	push   $0x0
  8019a5:	6a 00                	push   $0x0
  8019a7:	6a 00                	push   $0x0
  8019a9:	6a 00                	push   $0x0
  8019ab:	6a 00                	push   $0x0
  8019ad:	6a 0a                	push   $0xa
  8019af:	e8 e7 fe ff ff       	call   80189b <syscall>
  8019b4:	83 c4 18             	add    $0x18,%esp
}
  8019b7:	c9                   	leave  
  8019b8:	c3                   	ret    

008019b9 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  8019b9:	55                   	push   %ebp
  8019ba:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  8019bc:	6a 00                	push   $0x0
  8019be:	6a 00                	push   $0x0
  8019c0:	6a 00                	push   $0x0
  8019c2:	6a 00                	push   $0x0
  8019c4:	6a 00                	push   $0x0
  8019c6:	6a 0b                	push   $0xb
  8019c8:	e8 ce fe ff ff       	call   80189b <syscall>
  8019cd:	83 c4 18             	add    $0x18,%esp
}
  8019d0:	c9                   	leave  
  8019d1:	c3                   	ret    

008019d2 <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  8019d2:	55                   	push   %ebp
  8019d3:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  8019d5:	6a 00                	push   $0x0
  8019d7:	6a 00                	push   $0x0
  8019d9:	6a 00                	push   $0x0
  8019db:	ff 75 0c             	pushl  0xc(%ebp)
  8019de:	ff 75 08             	pushl  0x8(%ebp)
  8019e1:	6a 0f                	push   $0xf
  8019e3:	e8 b3 fe ff ff       	call   80189b <syscall>
  8019e8:	83 c4 18             	add    $0x18,%esp
	return;
  8019eb:	90                   	nop
}
  8019ec:	c9                   	leave  
  8019ed:	c3                   	ret    

008019ee <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  8019ee:	55                   	push   %ebp
  8019ef:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  8019f1:	6a 00                	push   $0x0
  8019f3:	6a 00                	push   $0x0
  8019f5:	6a 00                	push   $0x0
  8019f7:	ff 75 0c             	pushl  0xc(%ebp)
  8019fa:	ff 75 08             	pushl  0x8(%ebp)
  8019fd:	6a 10                	push   $0x10
  8019ff:	e8 97 fe ff ff       	call   80189b <syscall>
  801a04:	83 c4 18             	add    $0x18,%esp
	return ;
  801a07:	90                   	nop
}
  801a08:	c9                   	leave  
  801a09:	c3                   	ret    

00801a0a <sys_allocate_chunk>:

void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  801a0a:	55                   	push   %ebp
  801a0b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  801a0d:	6a 00                	push   $0x0
  801a0f:	6a 00                	push   $0x0
  801a11:	ff 75 10             	pushl  0x10(%ebp)
  801a14:	ff 75 0c             	pushl  0xc(%ebp)
  801a17:	ff 75 08             	pushl  0x8(%ebp)
  801a1a:	6a 11                	push   $0x11
  801a1c:	e8 7a fe ff ff       	call   80189b <syscall>
  801a21:	83 c4 18             	add    $0x18,%esp
	return ;
  801a24:	90                   	nop
}
  801a25:	c9                   	leave  
  801a26:	c3                   	ret    

00801a27 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  801a27:	55                   	push   %ebp
  801a28:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  801a2a:	6a 00                	push   $0x0
  801a2c:	6a 00                	push   $0x0
  801a2e:	6a 00                	push   $0x0
  801a30:	6a 00                	push   $0x0
  801a32:	6a 00                	push   $0x0
  801a34:	6a 0c                	push   $0xc
  801a36:	e8 60 fe ff ff       	call   80189b <syscall>
  801a3b:	83 c4 18             	add    $0x18,%esp
}
  801a3e:	c9                   	leave  
  801a3f:	c3                   	ret    

00801a40 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  801a40:	55                   	push   %ebp
  801a41:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  801a43:	6a 00                	push   $0x0
  801a45:	6a 00                	push   $0x0
  801a47:	6a 00                	push   $0x0
  801a49:	6a 00                	push   $0x0
  801a4b:	ff 75 08             	pushl  0x8(%ebp)
  801a4e:	6a 0d                	push   $0xd
  801a50:	e8 46 fe ff ff       	call   80189b <syscall>
  801a55:	83 c4 18             	add    $0x18,%esp
}
  801a58:	c9                   	leave  
  801a59:	c3                   	ret    

00801a5a <sys_scarce_memory>:

void sys_scarce_memory()
{
  801a5a:	55                   	push   %ebp
  801a5b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  801a5d:	6a 00                	push   $0x0
  801a5f:	6a 00                	push   $0x0
  801a61:	6a 00                	push   $0x0
  801a63:	6a 00                	push   $0x0
  801a65:	6a 00                	push   $0x0
  801a67:	6a 0e                	push   $0xe
  801a69:	e8 2d fe ff ff       	call   80189b <syscall>
  801a6e:	83 c4 18             	add    $0x18,%esp
}
  801a71:	90                   	nop
  801a72:	c9                   	leave  
  801a73:	c3                   	ret    

00801a74 <sys_disable_interrupt>:

//NEW !! 2012...
void
sys_disable_interrupt()
{
  801a74:	55                   	push   %ebp
  801a75:	89 e5                	mov    %esp,%ebp
	syscall(SYS_disableINTR,0, 0, 0, 0, 0);
  801a77:	6a 00                	push   $0x0
  801a79:	6a 00                	push   $0x0
  801a7b:	6a 00                	push   $0x0
  801a7d:	6a 00                	push   $0x0
  801a7f:	6a 00                	push   $0x0
  801a81:	6a 13                	push   $0x13
  801a83:	e8 13 fe ff ff       	call   80189b <syscall>
  801a88:	83 c4 18             	add    $0x18,%esp
}
  801a8b:	90                   	nop
  801a8c:	c9                   	leave  
  801a8d:	c3                   	ret    

00801a8e <sys_enable_interrupt>:


void
sys_enable_interrupt()
{
  801a8e:	55                   	push   %ebp
  801a8f:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enableINTR,0, 0, 0, 0, 0);
  801a91:	6a 00                	push   $0x0
  801a93:	6a 00                	push   $0x0
  801a95:	6a 00                	push   $0x0
  801a97:	6a 00                	push   $0x0
  801a99:	6a 00                	push   $0x0
  801a9b:	6a 14                	push   $0x14
  801a9d:	e8 f9 fd ff ff       	call   80189b <syscall>
  801aa2:	83 c4 18             	add    $0x18,%esp
}
  801aa5:	90                   	nop
  801aa6:	c9                   	leave  
  801aa7:	c3                   	ret    

00801aa8 <sys_cputc>:


void
sys_cputc(const char c)
{
  801aa8:	55                   	push   %ebp
  801aa9:	89 e5                	mov    %esp,%ebp
  801aab:	83 ec 04             	sub    $0x4,%esp
  801aae:	8b 45 08             	mov    0x8(%ebp),%eax
  801ab1:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  801ab4:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801ab8:	6a 00                	push   $0x0
  801aba:	6a 00                	push   $0x0
  801abc:	6a 00                	push   $0x0
  801abe:	6a 00                	push   $0x0
  801ac0:	50                   	push   %eax
  801ac1:	6a 15                	push   $0x15
  801ac3:	e8 d3 fd ff ff       	call   80189b <syscall>
  801ac8:	83 c4 18             	add    $0x18,%esp
}
  801acb:	90                   	nop
  801acc:	c9                   	leave  
  801acd:	c3                   	ret    

00801ace <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  801ace:	55                   	push   %ebp
  801acf:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  801ad1:	6a 00                	push   $0x0
  801ad3:	6a 00                	push   $0x0
  801ad5:	6a 00                	push   $0x0
  801ad7:	6a 00                	push   $0x0
  801ad9:	6a 00                	push   $0x0
  801adb:	6a 16                	push   $0x16
  801add:	e8 b9 fd ff ff       	call   80189b <syscall>
  801ae2:	83 c4 18             	add    $0x18,%esp
}
  801ae5:	90                   	nop
  801ae6:	c9                   	leave  
  801ae7:	c3                   	ret    

00801ae8 <sys_createSemaphore>:

int
sys_createSemaphore(char* semaphoreName, uint32 initialValue)
{
  801ae8:	55                   	push   %ebp
  801ae9:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_semaphore,(uint32)semaphoreName, (uint32)initialValue, 0, 0, 0);
  801aeb:	8b 45 08             	mov    0x8(%ebp),%eax
  801aee:	6a 00                	push   $0x0
  801af0:	6a 00                	push   $0x0
  801af2:	6a 00                	push   $0x0
  801af4:	ff 75 0c             	pushl  0xc(%ebp)
  801af7:	50                   	push   %eax
  801af8:	6a 17                	push   $0x17
  801afa:	e8 9c fd ff ff       	call   80189b <syscall>
  801aff:	83 c4 18             	add    $0x18,%esp
}
  801b02:	c9                   	leave  
  801b03:	c3                   	ret    

00801b04 <sys_getSemaphoreValue>:

int
sys_getSemaphoreValue(int32 ownerEnvID, char* semaphoreName)
{
  801b04:	55                   	push   %ebp
  801b05:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_semaphore_value,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801b07:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b0a:	8b 45 08             	mov    0x8(%ebp),%eax
  801b0d:	6a 00                	push   $0x0
  801b0f:	6a 00                	push   $0x0
  801b11:	6a 00                	push   $0x0
  801b13:	52                   	push   %edx
  801b14:	50                   	push   %eax
  801b15:	6a 1a                	push   $0x1a
  801b17:	e8 7f fd ff ff       	call   80189b <syscall>
  801b1c:	83 c4 18             	add    $0x18,%esp
}
  801b1f:	c9                   	leave  
  801b20:	c3                   	ret    

00801b21 <sys_waitSemaphore>:

void
sys_waitSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801b21:	55                   	push   %ebp
  801b22:	89 e5                	mov    %esp,%ebp
	syscall(SYS_wait_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801b24:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b27:	8b 45 08             	mov    0x8(%ebp),%eax
  801b2a:	6a 00                	push   $0x0
  801b2c:	6a 00                	push   $0x0
  801b2e:	6a 00                	push   $0x0
  801b30:	52                   	push   %edx
  801b31:	50                   	push   %eax
  801b32:	6a 18                	push   $0x18
  801b34:	e8 62 fd ff ff       	call   80189b <syscall>
  801b39:	83 c4 18             	add    $0x18,%esp
}
  801b3c:	90                   	nop
  801b3d:	c9                   	leave  
  801b3e:	c3                   	ret    

00801b3f <sys_signalSemaphore>:

void
sys_signalSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801b3f:	55                   	push   %ebp
  801b40:	89 e5                	mov    %esp,%ebp
	syscall(SYS_signal_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801b42:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b45:	8b 45 08             	mov    0x8(%ebp),%eax
  801b48:	6a 00                	push   $0x0
  801b4a:	6a 00                	push   $0x0
  801b4c:	6a 00                	push   $0x0
  801b4e:	52                   	push   %edx
  801b4f:	50                   	push   %eax
  801b50:	6a 19                	push   $0x19
  801b52:	e8 44 fd ff ff       	call   80189b <syscall>
  801b57:	83 c4 18             	add    $0x18,%esp
}
  801b5a:	90                   	nop
  801b5b:	c9                   	leave  
  801b5c:	c3                   	ret    

00801b5d <sys_createSharedObject>:

int
sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  801b5d:	55                   	push   %ebp
  801b5e:	89 e5                	mov    %esp,%ebp
  801b60:	83 ec 04             	sub    $0x4,%esp
  801b63:	8b 45 10             	mov    0x10(%ebp),%eax
  801b66:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  801b69:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801b6c:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801b70:	8b 45 08             	mov    0x8(%ebp),%eax
  801b73:	6a 00                	push   $0x0
  801b75:	51                   	push   %ecx
  801b76:	52                   	push   %edx
  801b77:	ff 75 0c             	pushl  0xc(%ebp)
  801b7a:	50                   	push   %eax
  801b7b:	6a 1b                	push   $0x1b
  801b7d:	e8 19 fd ff ff       	call   80189b <syscall>
  801b82:	83 c4 18             	add    $0x18,%esp
}
  801b85:	c9                   	leave  
  801b86:	c3                   	ret    

00801b87 <sys_getSizeOfSharedObject>:

//2017:
int
sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  801b87:	55                   	push   %ebp
  801b88:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  801b8a:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b8d:	8b 45 08             	mov    0x8(%ebp),%eax
  801b90:	6a 00                	push   $0x0
  801b92:	6a 00                	push   $0x0
  801b94:	6a 00                	push   $0x0
  801b96:	52                   	push   %edx
  801b97:	50                   	push   %eax
  801b98:	6a 1c                	push   $0x1c
  801b9a:	e8 fc fc ff ff       	call   80189b <syscall>
  801b9f:	83 c4 18             	add    $0x18,%esp
}
  801ba2:	c9                   	leave  
  801ba3:	c3                   	ret    

00801ba4 <sys_getSharedObject>:
//==========

int
sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  801ba4:	55                   	push   %ebp
  801ba5:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  801ba7:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801baa:	8b 55 0c             	mov    0xc(%ebp),%edx
  801bad:	8b 45 08             	mov    0x8(%ebp),%eax
  801bb0:	6a 00                	push   $0x0
  801bb2:	6a 00                	push   $0x0
  801bb4:	51                   	push   %ecx
  801bb5:	52                   	push   %edx
  801bb6:	50                   	push   %eax
  801bb7:	6a 1d                	push   $0x1d
  801bb9:	e8 dd fc ff ff       	call   80189b <syscall>
  801bbe:	83 c4 18             	add    $0x18,%esp
}
  801bc1:	c9                   	leave  
  801bc2:	c3                   	ret    

00801bc3 <sys_freeSharedObject>:

int
sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  801bc3:	55                   	push   %ebp
  801bc4:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  801bc6:	8b 55 0c             	mov    0xc(%ebp),%edx
  801bc9:	8b 45 08             	mov    0x8(%ebp),%eax
  801bcc:	6a 00                	push   $0x0
  801bce:	6a 00                	push   $0x0
  801bd0:	6a 00                	push   $0x0
  801bd2:	52                   	push   %edx
  801bd3:	50                   	push   %eax
  801bd4:	6a 1e                	push   $0x1e
  801bd6:	e8 c0 fc ff ff       	call   80189b <syscall>
  801bdb:	83 c4 18             	add    $0x18,%esp
}
  801bde:	c9                   	leave  
  801bdf:	c3                   	ret    

00801be0 <sys_getMaxShares>:

uint32 	sys_getMaxShares()
{
  801be0:	55                   	push   %ebp
  801be1:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_max_shares,0, 0, 0, 0, 0);
  801be3:	6a 00                	push   $0x0
  801be5:	6a 00                	push   $0x0
  801be7:	6a 00                	push   $0x0
  801be9:	6a 00                	push   $0x0
  801beb:	6a 00                	push   $0x0
  801bed:	6a 1f                	push   $0x1f
  801bef:	e8 a7 fc ff ff       	call   80189b <syscall>
  801bf4:	83 c4 18             	add    $0x18,%esp
}
  801bf7:	c9                   	leave  
  801bf8:	c3                   	ret    

00801bf9 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  801bf9:	55                   	push   %ebp
  801bfa:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  801bfc:	8b 45 08             	mov    0x8(%ebp),%eax
  801bff:	6a 00                	push   $0x0
  801c01:	ff 75 14             	pushl  0x14(%ebp)
  801c04:	ff 75 10             	pushl  0x10(%ebp)
  801c07:	ff 75 0c             	pushl  0xc(%ebp)
  801c0a:	50                   	push   %eax
  801c0b:	6a 20                	push   $0x20
  801c0d:	e8 89 fc ff ff       	call   80189b <syscall>
  801c12:	83 c4 18             	add    $0x18,%esp
}
  801c15:	c9                   	leave  
  801c16:	c3                   	ret    

00801c17 <sys_run_env>:

void
sys_run_env(int32 envId)
{
  801c17:	55                   	push   %ebp
  801c18:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  801c1a:	8b 45 08             	mov    0x8(%ebp),%eax
  801c1d:	6a 00                	push   $0x0
  801c1f:	6a 00                	push   $0x0
  801c21:	6a 00                	push   $0x0
  801c23:	6a 00                	push   $0x0
  801c25:	50                   	push   %eax
  801c26:	6a 21                	push   $0x21
  801c28:	e8 6e fc ff ff       	call   80189b <syscall>
  801c2d:	83 c4 18             	add    $0x18,%esp
}
  801c30:	90                   	nop
  801c31:	c9                   	leave  
  801c32:	c3                   	ret    

00801c33 <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  801c33:	55                   	push   %ebp
  801c34:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  801c36:	8b 45 08             	mov    0x8(%ebp),%eax
  801c39:	6a 00                	push   $0x0
  801c3b:	6a 00                	push   $0x0
  801c3d:	6a 00                	push   $0x0
  801c3f:	6a 00                	push   $0x0
  801c41:	50                   	push   %eax
  801c42:	6a 22                	push   $0x22
  801c44:	e8 52 fc ff ff       	call   80189b <syscall>
  801c49:	83 c4 18             	add    $0x18,%esp
}
  801c4c:	c9                   	leave  
  801c4d:	c3                   	ret    

00801c4e <sys_getenvid>:

int32 sys_getenvid(void)
{
  801c4e:	55                   	push   %ebp
  801c4f:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  801c51:	6a 00                	push   $0x0
  801c53:	6a 00                	push   $0x0
  801c55:	6a 00                	push   $0x0
  801c57:	6a 00                	push   $0x0
  801c59:	6a 00                	push   $0x0
  801c5b:	6a 02                	push   $0x2
  801c5d:	e8 39 fc ff ff       	call   80189b <syscall>
  801c62:	83 c4 18             	add    $0x18,%esp
}
  801c65:	c9                   	leave  
  801c66:	c3                   	ret    

00801c67 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  801c67:	55                   	push   %ebp
  801c68:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  801c6a:	6a 00                	push   $0x0
  801c6c:	6a 00                	push   $0x0
  801c6e:	6a 00                	push   $0x0
  801c70:	6a 00                	push   $0x0
  801c72:	6a 00                	push   $0x0
  801c74:	6a 03                	push   $0x3
  801c76:	e8 20 fc ff ff       	call   80189b <syscall>
  801c7b:	83 c4 18             	add    $0x18,%esp
}
  801c7e:	c9                   	leave  
  801c7f:	c3                   	ret    

00801c80 <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  801c80:	55                   	push   %ebp
  801c81:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  801c83:	6a 00                	push   $0x0
  801c85:	6a 00                	push   $0x0
  801c87:	6a 00                	push   $0x0
  801c89:	6a 00                	push   $0x0
  801c8b:	6a 00                	push   $0x0
  801c8d:	6a 04                	push   $0x4
  801c8f:	e8 07 fc ff ff       	call   80189b <syscall>
  801c94:	83 c4 18             	add    $0x18,%esp
}
  801c97:	c9                   	leave  
  801c98:	c3                   	ret    

00801c99 <sys_exit_env>:


void sys_exit_env(void)
{
  801c99:	55                   	push   %ebp
  801c9a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  801c9c:	6a 00                	push   $0x0
  801c9e:	6a 00                	push   $0x0
  801ca0:	6a 00                	push   $0x0
  801ca2:	6a 00                	push   $0x0
  801ca4:	6a 00                	push   $0x0
  801ca6:	6a 23                	push   $0x23
  801ca8:	e8 ee fb ff ff       	call   80189b <syscall>
  801cad:	83 c4 18             	add    $0x18,%esp
}
  801cb0:	90                   	nop
  801cb1:	c9                   	leave  
  801cb2:	c3                   	ret    

00801cb3 <sys_get_virtual_time>:


struct uint64
sys_get_virtual_time()
{
  801cb3:	55                   	push   %ebp
  801cb4:	89 e5                	mov    %esp,%ebp
  801cb6:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  801cb9:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801cbc:	8d 50 04             	lea    0x4(%eax),%edx
  801cbf:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801cc2:	6a 00                	push   $0x0
  801cc4:	6a 00                	push   $0x0
  801cc6:	6a 00                	push   $0x0
  801cc8:	52                   	push   %edx
  801cc9:	50                   	push   %eax
  801cca:	6a 24                	push   $0x24
  801ccc:	e8 ca fb ff ff       	call   80189b <syscall>
  801cd1:	83 c4 18             	add    $0x18,%esp
	return result;
  801cd4:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801cd7:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801cda:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801cdd:	89 01                	mov    %eax,(%ecx)
  801cdf:	89 51 04             	mov    %edx,0x4(%ecx)
}
  801ce2:	8b 45 08             	mov    0x8(%ebp),%eax
  801ce5:	c9                   	leave  
  801ce6:	c2 04 00             	ret    $0x4

00801ce9 <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  801ce9:	55                   	push   %ebp
  801cea:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  801cec:	6a 00                	push   $0x0
  801cee:	6a 00                	push   $0x0
  801cf0:	ff 75 10             	pushl  0x10(%ebp)
  801cf3:	ff 75 0c             	pushl  0xc(%ebp)
  801cf6:	ff 75 08             	pushl  0x8(%ebp)
  801cf9:	6a 12                	push   $0x12
  801cfb:	e8 9b fb ff ff       	call   80189b <syscall>
  801d00:	83 c4 18             	add    $0x18,%esp
	return ;
  801d03:	90                   	nop
}
  801d04:	c9                   	leave  
  801d05:	c3                   	ret    

00801d06 <sys_rcr2>:
uint32 sys_rcr2()
{
  801d06:	55                   	push   %ebp
  801d07:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  801d09:	6a 00                	push   $0x0
  801d0b:	6a 00                	push   $0x0
  801d0d:	6a 00                	push   $0x0
  801d0f:	6a 00                	push   $0x0
  801d11:	6a 00                	push   $0x0
  801d13:	6a 25                	push   $0x25
  801d15:	e8 81 fb ff ff       	call   80189b <syscall>
  801d1a:	83 c4 18             	add    $0x18,%esp
}
  801d1d:	c9                   	leave  
  801d1e:	c3                   	ret    

00801d1f <sys_bypassPageFault>:
void sys_bypassPageFault(uint8 instrLength)
{
  801d1f:	55                   	push   %ebp
  801d20:	89 e5                	mov    %esp,%ebp
  801d22:	83 ec 04             	sub    $0x4,%esp
  801d25:	8b 45 08             	mov    0x8(%ebp),%eax
  801d28:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  801d2b:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  801d2f:	6a 00                	push   $0x0
  801d31:	6a 00                	push   $0x0
  801d33:	6a 00                	push   $0x0
  801d35:	6a 00                	push   $0x0
  801d37:	50                   	push   %eax
  801d38:	6a 26                	push   $0x26
  801d3a:	e8 5c fb ff ff       	call   80189b <syscall>
  801d3f:	83 c4 18             	add    $0x18,%esp
	return ;
  801d42:	90                   	nop
}
  801d43:	c9                   	leave  
  801d44:	c3                   	ret    

00801d45 <rsttst>:
void rsttst()
{
  801d45:	55                   	push   %ebp
  801d46:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  801d48:	6a 00                	push   $0x0
  801d4a:	6a 00                	push   $0x0
  801d4c:	6a 00                	push   $0x0
  801d4e:	6a 00                	push   $0x0
  801d50:	6a 00                	push   $0x0
  801d52:	6a 28                	push   $0x28
  801d54:	e8 42 fb ff ff       	call   80189b <syscall>
  801d59:	83 c4 18             	add    $0x18,%esp
	return ;
  801d5c:	90                   	nop
}
  801d5d:	c9                   	leave  
  801d5e:	c3                   	ret    

00801d5f <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  801d5f:	55                   	push   %ebp
  801d60:	89 e5                	mov    %esp,%ebp
  801d62:	83 ec 04             	sub    $0x4,%esp
  801d65:	8b 45 14             	mov    0x14(%ebp),%eax
  801d68:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  801d6b:	8b 55 18             	mov    0x18(%ebp),%edx
  801d6e:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801d72:	52                   	push   %edx
  801d73:	50                   	push   %eax
  801d74:	ff 75 10             	pushl  0x10(%ebp)
  801d77:	ff 75 0c             	pushl  0xc(%ebp)
  801d7a:	ff 75 08             	pushl  0x8(%ebp)
  801d7d:	6a 27                	push   $0x27
  801d7f:	e8 17 fb ff ff       	call   80189b <syscall>
  801d84:	83 c4 18             	add    $0x18,%esp
	return ;
  801d87:	90                   	nop
}
  801d88:	c9                   	leave  
  801d89:	c3                   	ret    

00801d8a <chktst>:
void chktst(uint32 n)
{
  801d8a:	55                   	push   %ebp
  801d8b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  801d8d:	6a 00                	push   $0x0
  801d8f:	6a 00                	push   $0x0
  801d91:	6a 00                	push   $0x0
  801d93:	6a 00                	push   $0x0
  801d95:	ff 75 08             	pushl  0x8(%ebp)
  801d98:	6a 29                	push   $0x29
  801d9a:	e8 fc fa ff ff       	call   80189b <syscall>
  801d9f:	83 c4 18             	add    $0x18,%esp
	return ;
  801da2:	90                   	nop
}
  801da3:	c9                   	leave  
  801da4:	c3                   	ret    

00801da5 <inctst>:

void inctst()
{
  801da5:	55                   	push   %ebp
  801da6:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  801da8:	6a 00                	push   $0x0
  801daa:	6a 00                	push   $0x0
  801dac:	6a 00                	push   $0x0
  801dae:	6a 00                	push   $0x0
  801db0:	6a 00                	push   $0x0
  801db2:	6a 2a                	push   $0x2a
  801db4:	e8 e2 fa ff ff       	call   80189b <syscall>
  801db9:	83 c4 18             	add    $0x18,%esp
	return ;
  801dbc:	90                   	nop
}
  801dbd:	c9                   	leave  
  801dbe:	c3                   	ret    

00801dbf <gettst>:
uint32 gettst()
{
  801dbf:	55                   	push   %ebp
  801dc0:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  801dc2:	6a 00                	push   $0x0
  801dc4:	6a 00                	push   $0x0
  801dc6:	6a 00                	push   $0x0
  801dc8:	6a 00                	push   $0x0
  801dca:	6a 00                	push   $0x0
  801dcc:	6a 2b                	push   $0x2b
  801dce:	e8 c8 fa ff ff       	call   80189b <syscall>
  801dd3:	83 c4 18             	add    $0x18,%esp
}
  801dd6:	c9                   	leave  
  801dd7:	c3                   	ret    

00801dd8 <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  801dd8:	55                   	push   %ebp
  801dd9:	89 e5                	mov    %esp,%ebp
  801ddb:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801dde:	6a 00                	push   $0x0
  801de0:	6a 00                	push   $0x0
  801de2:	6a 00                	push   $0x0
  801de4:	6a 00                	push   $0x0
  801de6:	6a 00                	push   $0x0
  801de8:	6a 2c                	push   $0x2c
  801dea:	e8 ac fa ff ff       	call   80189b <syscall>
  801def:	83 c4 18             	add    $0x18,%esp
  801df2:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  801df5:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  801df9:	75 07                	jne    801e02 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  801dfb:	b8 01 00 00 00       	mov    $0x1,%eax
  801e00:	eb 05                	jmp    801e07 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  801e02:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801e07:	c9                   	leave  
  801e08:	c3                   	ret    

00801e09 <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  801e09:	55                   	push   %ebp
  801e0a:	89 e5                	mov    %esp,%ebp
  801e0c:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801e0f:	6a 00                	push   $0x0
  801e11:	6a 00                	push   $0x0
  801e13:	6a 00                	push   $0x0
  801e15:	6a 00                	push   $0x0
  801e17:	6a 00                	push   $0x0
  801e19:	6a 2c                	push   $0x2c
  801e1b:	e8 7b fa ff ff       	call   80189b <syscall>
  801e20:	83 c4 18             	add    $0x18,%esp
  801e23:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  801e26:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  801e2a:	75 07                	jne    801e33 <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  801e2c:	b8 01 00 00 00       	mov    $0x1,%eax
  801e31:	eb 05                	jmp    801e38 <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  801e33:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801e38:	c9                   	leave  
  801e39:	c3                   	ret    

00801e3a <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  801e3a:	55                   	push   %ebp
  801e3b:	89 e5                	mov    %esp,%ebp
  801e3d:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801e40:	6a 00                	push   $0x0
  801e42:	6a 00                	push   $0x0
  801e44:	6a 00                	push   $0x0
  801e46:	6a 00                	push   $0x0
  801e48:	6a 00                	push   $0x0
  801e4a:	6a 2c                	push   $0x2c
  801e4c:	e8 4a fa ff ff       	call   80189b <syscall>
  801e51:	83 c4 18             	add    $0x18,%esp
  801e54:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  801e57:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  801e5b:	75 07                	jne    801e64 <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  801e5d:	b8 01 00 00 00       	mov    $0x1,%eax
  801e62:	eb 05                	jmp    801e69 <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  801e64:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801e69:	c9                   	leave  
  801e6a:	c3                   	ret    

00801e6b <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  801e6b:	55                   	push   %ebp
  801e6c:	89 e5                	mov    %esp,%ebp
  801e6e:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801e71:	6a 00                	push   $0x0
  801e73:	6a 00                	push   $0x0
  801e75:	6a 00                	push   $0x0
  801e77:	6a 00                	push   $0x0
  801e79:	6a 00                	push   $0x0
  801e7b:	6a 2c                	push   $0x2c
  801e7d:	e8 19 fa ff ff       	call   80189b <syscall>
  801e82:	83 c4 18             	add    $0x18,%esp
  801e85:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  801e88:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  801e8c:	75 07                	jne    801e95 <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  801e8e:	b8 01 00 00 00       	mov    $0x1,%eax
  801e93:	eb 05                	jmp    801e9a <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  801e95:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801e9a:	c9                   	leave  
  801e9b:	c3                   	ret    

00801e9c <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  801e9c:	55                   	push   %ebp
  801e9d:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  801e9f:	6a 00                	push   $0x0
  801ea1:	6a 00                	push   $0x0
  801ea3:	6a 00                	push   $0x0
  801ea5:	6a 00                	push   $0x0
  801ea7:	ff 75 08             	pushl  0x8(%ebp)
  801eaa:	6a 2d                	push   $0x2d
  801eac:	e8 ea f9 ff ff       	call   80189b <syscall>
  801eb1:	83 c4 18             	add    $0x18,%esp
	return ;
  801eb4:	90                   	nop
}
  801eb5:	c9                   	leave  
  801eb6:	c3                   	ret    

00801eb7 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  801eb7:	55                   	push   %ebp
  801eb8:	89 e5                	mov    %esp,%ebp
  801eba:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  801ebb:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801ebe:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801ec1:	8b 55 0c             	mov    0xc(%ebp),%edx
  801ec4:	8b 45 08             	mov    0x8(%ebp),%eax
  801ec7:	6a 00                	push   $0x0
  801ec9:	53                   	push   %ebx
  801eca:	51                   	push   %ecx
  801ecb:	52                   	push   %edx
  801ecc:	50                   	push   %eax
  801ecd:	6a 2e                	push   $0x2e
  801ecf:	e8 c7 f9 ff ff       	call   80189b <syscall>
  801ed4:	83 c4 18             	add    $0x18,%esp
}
  801ed7:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801eda:	c9                   	leave  
  801edb:	c3                   	ret    

00801edc <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  801edc:	55                   	push   %ebp
  801edd:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  801edf:	8b 55 0c             	mov    0xc(%ebp),%edx
  801ee2:	8b 45 08             	mov    0x8(%ebp),%eax
  801ee5:	6a 00                	push   $0x0
  801ee7:	6a 00                	push   $0x0
  801ee9:	6a 00                	push   $0x0
  801eeb:	52                   	push   %edx
  801eec:	50                   	push   %eax
  801eed:	6a 2f                	push   $0x2f
  801eef:	e8 a7 f9 ff ff       	call   80189b <syscall>
  801ef4:	83 c4 18             	add    $0x18,%esp
}
  801ef7:	c9                   	leave  
  801ef8:	c3                   	ret    

00801ef9 <print_mem_block_lists>:
//===========================
// PRINT MEM BLOCK LISTS:
//===========================

void print_mem_block_lists()
{
  801ef9:	55                   	push   %ebp
  801efa:	89 e5                	mov    %esp,%ebp
  801efc:	83 ec 18             	sub    $0x18,%esp
	cprintf("\n=========================================\n");
  801eff:	83 ec 0c             	sub    $0xc,%esp
  801f02:	68 c0 39 80 00       	push   $0x8039c0
  801f07:	e8 dd e6 ff ff       	call   8005e9 <cprintf>
  801f0c:	83 c4 10             	add    $0x10,%esp
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
  801f0f:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nFreeMemBlocksList:\n");
  801f16:	83 ec 0c             	sub    $0xc,%esp
  801f19:	68 ec 39 80 00       	push   $0x8039ec
  801f1e:	e8 c6 e6 ff ff       	call   8005e9 <cprintf>
  801f23:	83 c4 10             	add    $0x10,%esp
	uint8 sorted = 1 ;
  801f26:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &FreeMemBlocksList)
  801f2a:	a1 38 41 80 00       	mov    0x804138,%eax
  801f2f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801f32:	eb 56                	jmp    801f8a <print_mem_block_lists+0x91>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  801f34:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801f38:	74 1c                	je     801f56 <print_mem_block_lists+0x5d>
  801f3a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f3d:	8b 50 08             	mov    0x8(%eax),%edx
  801f40:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801f43:	8b 48 08             	mov    0x8(%eax),%ecx
  801f46:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801f49:	8b 40 0c             	mov    0xc(%eax),%eax
  801f4c:	01 c8                	add    %ecx,%eax
  801f4e:	39 c2                	cmp    %eax,%edx
  801f50:	73 04                	jae    801f56 <print_mem_block_lists+0x5d>
			sorted = 0 ;
  801f52:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  801f56:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f59:	8b 50 08             	mov    0x8(%eax),%edx
  801f5c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f5f:	8b 40 0c             	mov    0xc(%eax),%eax
  801f62:	01 c2                	add    %eax,%edx
  801f64:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f67:	8b 40 08             	mov    0x8(%eax),%eax
  801f6a:	83 ec 04             	sub    $0x4,%esp
  801f6d:	52                   	push   %edx
  801f6e:	50                   	push   %eax
  801f6f:	68 01 3a 80 00       	push   $0x803a01
  801f74:	e8 70 e6 ff ff       	call   8005e9 <cprintf>
  801f79:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  801f7c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f7f:	89 45 f0             	mov    %eax,-0x10(%ebp)
	cprintf("\n=========================================\n");
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
	cprintf("\nFreeMemBlocksList:\n");
	uint8 sorted = 1 ;
	LIST_FOREACH(blk, &FreeMemBlocksList)
  801f82:	a1 40 41 80 00       	mov    0x804140,%eax
  801f87:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801f8a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801f8e:	74 07                	je     801f97 <print_mem_block_lists+0x9e>
  801f90:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f93:	8b 00                	mov    (%eax),%eax
  801f95:	eb 05                	jmp    801f9c <print_mem_block_lists+0xa3>
  801f97:	b8 00 00 00 00       	mov    $0x0,%eax
  801f9c:	a3 40 41 80 00       	mov    %eax,0x804140
  801fa1:	a1 40 41 80 00       	mov    0x804140,%eax
  801fa6:	85 c0                	test   %eax,%eax
  801fa8:	75 8a                	jne    801f34 <print_mem_block_lists+0x3b>
  801faa:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801fae:	75 84                	jne    801f34 <print_mem_block_lists+0x3b>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;
  801fb0:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  801fb4:	75 10                	jne    801fc6 <print_mem_block_lists+0xcd>
  801fb6:	83 ec 0c             	sub    $0xc,%esp
  801fb9:	68 10 3a 80 00       	push   $0x803a10
  801fbe:	e8 26 e6 ff ff       	call   8005e9 <cprintf>
  801fc3:	83 c4 10             	add    $0x10,%esp

	lastBlk = NULL ;
  801fc6:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nAllocMemBlocksList:\n");
  801fcd:	83 ec 0c             	sub    $0xc,%esp
  801fd0:	68 34 3a 80 00       	push   $0x803a34
  801fd5:	e8 0f e6 ff ff       	call   8005e9 <cprintf>
  801fda:	83 c4 10             	add    $0x10,%esp
	sorted = 1 ;
  801fdd:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &AllocMemBlocksList)
  801fe1:	a1 40 40 80 00       	mov    0x804040,%eax
  801fe6:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801fe9:	eb 56                	jmp    802041 <print_mem_block_lists+0x148>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  801feb:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801fef:	74 1c                	je     80200d <print_mem_block_lists+0x114>
  801ff1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ff4:	8b 50 08             	mov    0x8(%eax),%edx
  801ff7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801ffa:	8b 48 08             	mov    0x8(%eax),%ecx
  801ffd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802000:	8b 40 0c             	mov    0xc(%eax),%eax
  802003:	01 c8                	add    %ecx,%eax
  802005:	39 c2                	cmp    %eax,%edx
  802007:	73 04                	jae    80200d <print_mem_block_lists+0x114>
			sorted = 0 ;
  802009:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  80200d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802010:	8b 50 08             	mov    0x8(%eax),%edx
  802013:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802016:	8b 40 0c             	mov    0xc(%eax),%eax
  802019:	01 c2                	add    %eax,%edx
  80201b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80201e:	8b 40 08             	mov    0x8(%eax),%eax
  802021:	83 ec 04             	sub    $0x4,%esp
  802024:	52                   	push   %edx
  802025:	50                   	push   %eax
  802026:	68 01 3a 80 00       	push   $0x803a01
  80202b:	e8 b9 e5 ff ff       	call   8005e9 <cprintf>
  802030:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  802033:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802036:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;

	lastBlk = NULL ;
	cprintf("\nAllocMemBlocksList:\n");
	sorted = 1 ;
	LIST_FOREACH(blk, &AllocMemBlocksList)
  802039:	a1 48 40 80 00       	mov    0x804048,%eax
  80203e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802041:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802045:	74 07                	je     80204e <print_mem_block_lists+0x155>
  802047:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80204a:	8b 00                	mov    (%eax),%eax
  80204c:	eb 05                	jmp    802053 <print_mem_block_lists+0x15a>
  80204e:	b8 00 00 00 00       	mov    $0x0,%eax
  802053:	a3 48 40 80 00       	mov    %eax,0x804048
  802058:	a1 48 40 80 00       	mov    0x804048,%eax
  80205d:	85 c0                	test   %eax,%eax
  80205f:	75 8a                	jne    801feb <print_mem_block_lists+0xf2>
  802061:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802065:	75 84                	jne    801feb <print_mem_block_lists+0xf2>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nAllocMemBlocksList is NOT SORTED!!\n") ;
  802067:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  80206b:	75 10                	jne    80207d <print_mem_block_lists+0x184>
  80206d:	83 ec 0c             	sub    $0xc,%esp
  802070:	68 4c 3a 80 00       	push   $0x803a4c
  802075:	e8 6f e5 ff ff       	call   8005e9 <cprintf>
  80207a:	83 c4 10             	add    $0x10,%esp
	cprintf("\n=========================================\n");
  80207d:	83 ec 0c             	sub    $0xc,%esp
  802080:	68 c0 39 80 00       	push   $0x8039c0
  802085:	e8 5f e5 ff ff       	call   8005e9 <cprintf>
  80208a:	83 c4 10             	add    $0x10,%esp

}
  80208d:	90                   	nop
  80208e:	c9                   	leave  
  80208f:	c3                   	ret    

00802090 <initialize_MemBlocksList>:

//===============================
// [1] INITIALIZE AVAILABLE LIST:
//===============================
void initialize_MemBlocksList(uint32 numOfBlocks)
{
  802090:	55                   	push   %ebp
  802091:	89 e5                	mov    %esp,%ebp
  802093:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] initialize_MemBlocksList
	// Write your code here, remove the panic and write your code
	//panic("initialize_MemBlocksList() is not implemented yet...!!");
	uint32 n = numOfBlocks;
  802096:	8b 45 08             	mov    0x8(%ebp),%eax
  802099:	89 45 f0             	mov    %eax,-0x10(%ebp)

	LIST_INIT(&AvailableMemBlocksList);
  80209c:	c7 05 48 41 80 00 00 	movl   $0x0,0x804148
  8020a3:	00 00 00 
  8020a6:	c7 05 4c 41 80 00 00 	movl   $0x0,0x80414c
  8020ad:	00 00 00 
  8020b0:	c7 05 54 41 80 00 00 	movl   $0x0,0x804154
  8020b7:	00 00 00 
	for(int i = 0; i<n;i++)
  8020ba:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  8020c1:	e9 9e 00 00 00       	jmp    802164 <initialize_MemBlocksList+0xd4>
	{
		LIST_INSERT_HEAD(&AvailableMemBlocksList, &(MemBlockNodes[i]));
  8020c6:	a1 50 40 80 00       	mov    0x804050,%eax
  8020cb:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8020ce:	c1 e2 04             	shl    $0x4,%edx
  8020d1:	01 d0                	add    %edx,%eax
  8020d3:	85 c0                	test   %eax,%eax
  8020d5:	75 14                	jne    8020eb <initialize_MemBlocksList+0x5b>
  8020d7:	83 ec 04             	sub    $0x4,%esp
  8020da:	68 74 3a 80 00       	push   $0x803a74
  8020df:	6a 47                	push   $0x47
  8020e1:	68 97 3a 80 00       	push   $0x803a97
  8020e6:	e8 4a e2 ff ff       	call   800335 <_panic>
  8020eb:	a1 50 40 80 00       	mov    0x804050,%eax
  8020f0:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8020f3:	c1 e2 04             	shl    $0x4,%edx
  8020f6:	01 d0                	add    %edx,%eax
  8020f8:	8b 15 48 41 80 00    	mov    0x804148,%edx
  8020fe:	89 10                	mov    %edx,(%eax)
  802100:	8b 00                	mov    (%eax),%eax
  802102:	85 c0                	test   %eax,%eax
  802104:	74 18                	je     80211e <initialize_MemBlocksList+0x8e>
  802106:	a1 48 41 80 00       	mov    0x804148,%eax
  80210b:	8b 15 50 40 80 00    	mov    0x804050,%edx
  802111:	8b 4d f4             	mov    -0xc(%ebp),%ecx
  802114:	c1 e1 04             	shl    $0x4,%ecx
  802117:	01 ca                	add    %ecx,%edx
  802119:	89 50 04             	mov    %edx,0x4(%eax)
  80211c:	eb 12                	jmp    802130 <initialize_MemBlocksList+0xa0>
  80211e:	a1 50 40 80 00       	mov    0x804050,%eax
  802123:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802126:	c1 e2 04             	shl    $0x4,%edx
  802129:	01 d0                	add    %edx,%eax
  80212b:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802130:	a1 50 40 80 00       	mov    0x804050,%eax
  802135:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802138:	c1 e2 04             	shl    $0x4,%edx
  80213b:	01 d0                	add    %edx,%eax
  80213d:	a3 48 41 80 00       	mov    %eax,0x804148
  802142:	a1 50 40 80 00       	mov    0x804050,%eax
  802147:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80214a:	c1 e2 04             	shl    $0x4,%edx
  80214d:	01 d0                	add    %edx,%eax
  80214f:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802156:	a1 54 41 80 00       	mov    0x804154,%eax
  80215b:	40                   	inc    %eax
  80215c:	a3 54 41 80 00       	mov    %eax,0x804154
	// Write your code here, remove the panic and write your code
	//panic("initialize_MemBlocksList() is not implemented yet...!!");
	uint32 n = numOfBlocks;

	LIST_INIT(&AvailableMemBlocksList);
	for(int i = 0; i<n;i++)
  802161:	ff 45 f4             	incl   -0xc(%ebp)
  802164:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802167:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80216a:	0f 82 56 ff ff ff    	jb     8020c6 <initialize_MemBlocksList+0x36>
	{
		LIST_INSERT_HEAD(&AvailableMemBlocksList, &(MemBlockNodes[i]));
	}
}
  802170:	90                   	nop
  802171:	c9                   	leave  
  802172:	c3                   	ret    

00802173 <find_block>:

//===============================
// [2] FIND BLOCK:
//===============================
struct MemBlock *find_block(struct MemBlock_List *blockList, uint32 va)
{
  802173:	55                   	push   %ebp
  802174:	89 e5                	mov    %esp,%ebp
  802176:	83 ec 10             	sub    $0x10,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] find_block
	// Write your code here, remove the panic and write your code
	//panic("find_block() is not implemented yet...!!");
	uint32 virAddress = va;
  802179:	8b 45 0c             	mov    0xc(%ebp),%eax
  80217c:	89 45 f4             	mov    %eax,-0xc(%ebp)
	struct MemBlock* blk;
	int found = 0;
  80217f:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	LIST_FOREACH(blk, &(AllocMemBlocksList))
  802186:	a1 40 40 80 00       	mov    0x804040,%eax
  80218b:	89 45 fc             	mov    %eax,-0x4(%ebp)
  80218e:	eb 23                	jmp    8021b3 <find_block+0x40>
	{
		if(blk->sva == virAddress)
  802190:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802193:	8b 40 08             	mov    0x8(%eax),%eax
  802196:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  802199:	75 09                	jne    8021a4 <find_block+0x31>
		{
			found = 1;
  80219b:	c7 45 f8 01 00 00 00 	movl   $0x1,-0x8(%ebp)
			break;
  8021a2:	eb 35                	jmp    8021d9 <find_block+0x66>
		}
		else
		{
			found = 0;
  8021a4:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	//panic("find_block() is not implemented yet...!!");
	uint32 virAddress = va;
	struct MemBlock* blk;
	int found = 0;

	LIST_FOREACH(blk, &(AllocMemBlocksList))
  8021ab:	a1 48 40 80 00       	mov    0x804048,%eax
  8021b0:	89 45 fc             	mov    %eax,-0x4(%ebp)
  8021b3:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8021b7:	74 07                	je     8021c0 <find_block+0x4d>
  8021b9:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8021bc:	8b 00                	mov    (%eax),%eax
  8021be:	eb 05                	jmp    8021c5 <find_block+0x52>
  8021c0:	b8 00 00 00 00       	mov    $0x0,%eax
  8021c5:	a3 48 40 80 00       	mov    %eax,0x804048
  8021ca:	a1 48 40 80 00       	mov    0x804048,%eax
  8021cf:	85 c0                	test   %eax,%eax
  8021d1:	75 bd                	jne    802190 <find_block+0x1d>
  8021d3:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8021d7:	75 b7                	jne    802190 <find_block+0x1d>
		{
			found = 0;
			continue;
		}
	}
	if(found == 1)
  8021d9:	83 7d f8 01          	cmpl   $0x1,-0x8(%ebp)
  8021dd:	75 05                	jne    8021e4 <find_block+0x71>
	{
		return blk;
  8021df:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8021e2:	eb 05                	jmp    8021e9 <find_block+0x76>
	}
	else
	{
		return NULL;
  8021e4:	b8 00 00 00 00       	mov    $0x0,%eax
	}
}
  8021e9:	c9                   	leave  
  8021ea:	c3                   	ret    

008021eb <insert_sorted_allocList>:

//=========================================
// [3] INSERT BLOCK IN ALLOC LIST [SORTED]:
//=========================================
void insert_sorted_allocList(struct MemBlock *blockToInsert)
{
  8021eb:	55                   	push   %ebp
  8021ec:	89 e5                	mov    %esp,%ebp
  8021ee:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] insert_sorted_allocList
	// Write your code here, remove the panic and write your code
	//panic("insert_sorted_allocList() is not implemented yet...!!");
	struct MemBlock* blk;
	struct MemBlock* newblk = blockToInsert;
  8021f1:	8b 45 08             	mov    0x8(%ebp),%eax
  8021f4:	89 45 f0             	mov    %eax,-0x10(%ebp)

	if((LIST_EMPTY(&AllocMemBlocksList)) || (newblk->sva < LIST_FIRST(&AllocMemBlocksList)->sva))
  8021f7:	a1 40 40 80 00       	mov    0x804040,%eax
  8021fc:	85 c0                	test   %eax,%eax
  8021fe:	74 12                	je     802212 <insert_sorted_allocList+0x27>
  802200:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802203:	8b 50 08             	mov    0x8(%eax),%edx
  802206:	a1 40 40 80 00       	mov    0x804040,%eax
  80220b:	8b 40 08             	mov    0x8(%eax),%eax
  80220e:	39 c2                	cmp    %eax,%edx
  802210:	73 65                	jae    802277 <insert_sorted_allocList+0x8c>
	{
		LIST_INSERT_HEAD(&(AllocMemBlocksList), newblk);
  802212:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802216:	75 14                	jne    80222c <insert_sorted_allocList+0x41>
  802218:	83 ec 04             	sub    $0x4,%esp
  80221b:	68 74 3a 80 00       	push   $0x803a74
  802220:	6a 7b                	push   $0x7b
  802222:	68 97 3a 80 00       	push   $0x803a97
  802227:	e8 09 e1 ff ff       	call   800335 <_panic>
  80222c:	8b 15 40 40 80 00    	mov    0x804040,%edx
  802232:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802235:	89 10                	mov    %edx,(%eax)
  802237:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80223a:	8b 00                	mov    (%eax),%eax
  80223c:	85 c0                	test   %eax,%eax
  80223e:	74 0d                	je     80224d <insert_sorted_allocList+0x62>
  802240:	a1 40 40 80 00       	mov    0x804040,%eax
  802245:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802248:	89 50 04             	mov    %edx,0x4(%eax)
  80224b:	eb 08                	jmp    802255 <insert_sorted_allocList+0x6a>
  80224d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802250:	a3 44 40 80 00       	mov    %eax,0x804044
  802255:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802258:	a3 40 40 80 00       	mov    %eax,0x804040
  80225d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802260:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802267:	a1 4c 40 80 00       	mov    0x80404c,%eax
  80226c:	40                   	inc    %eax
  80226d:	a3 4c 40 80 00       	mov    %eax,0x80404c
  802272:	e9 5f 01 00 00       	jmp    8023d6 <insert_sorted_allocList+0x1eb>
	}
	else if(newblk->sva > LIST_LAST(&AllocMemBlocksList)->sva)
  802277:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80227a:	8b 50 08             	mov    0x8(%eax),%edx
  80227d:	a1 44 40 80 00       	mov    0x804044,%eax
  802282:	8b 40 08             	mov    0x8(%eax),%eax
  802285:	39 c2                	cmp    %eax,%edx
  802287:	76 65                	jbe    8022ee <insert_sorted_allocList+0x103>
	{
		LIST_INSERT_TAIL(&AllocMemBlocksList, newblk);
  802289:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80228d:	75 14                	jne    8022a3 <insert_sorted_allocList+0xb8>
  80228f:	83 ec 04             	sub    $0x4,%esp
  802292:	68 b0 3a 80 00       	push   $0x803ab0
  802297:	6a 7f                	push   $0x7f
  802299:	68 97 3a 80 00       	push   $0x803a97
  80229e:	e8 92 e0 ff ff       	call   800335 <_panic>
  8022a3:	8b 15 44 40 80 00    	mov    0x804044,%edx
  8022a9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8022ac:	89 50 04             	mov    %edx,0x4(%eax)
  8022af:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8022b2:	8b 40 04             	mov    0x4(%eax),%eax
  8022b5:	85 c0                	test   %eax,%eax
  8022b7:	74 0c                	je     8022c5 <insert_sorted_allocList+0xda>
  8022b9:	a1 44 40 80 00       	mov    0x804044,%eax
  8022be:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8022c1:	89 10                	mov    %edx,(%eax)
  8022c3:	eb 08                	jmp    8022cd <insert_sorted_allocList+0xe2>
  8022c5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8022c8:	a3 40 40 80 00       	mov    %eax,0x804040
  8022cd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8022d0:	a3 44 40 80 00       	mov    %eax,0x804044
  8022d5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8022d8:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8022de:	a1 4c 40 80 00       	mov    0x80404c,%eax
  8022e3:	40                   	inc    %eax
  8022e4:	a3 4c 40 80 00       	mov    %eax,0x80404c
				LIST_INSERT_AFTER(&AllocMemBlocksList, blk, newblk);
				break;
			}
		}
	}
}
  8022e9:	e9 e8 00 00 00       	jmp    8023d6 <insert_sorted_allocList+0x1eb>
	{
		LIST_INSERT_TAIL(&AllocMemBlocksList, newblk);
	}
	else
	{
		LIST_FOREACH(blk, &AllocMemBlocksList)
  8022ee:	a1 40 40 80 00       	mov    0x804040,%eax
  8022f3:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8022f6:	e9 ab 00 00 00       	jmp    8023a6 <insert_sorted_allocList+0x1bb>
		{
			if(blk->prev_next_info.le_next != NULL && newblk->sva > blk->sva  && newblk->sva < blk->prev_next_info.le_next->sva)
  8022fb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022fe:	8b 00                	mov    (%eax),%eax
  802300:	85 c0                	test   %eax,%eax
  802302:	0f 84 96 00 00 00    	je     80239e <insert_sorted_allocList+0x1b3>
  802308:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80230b:	8b 50 08             	mov    0x8(%eax),%edx
  80230e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802311:	8b 40 08             	mov    0x8(%eax),%eax
  802314:	39 c2                	cmp    %eax,%edx
  802316:	0f 86 82 00 00 00    	jbe    80239e <insert_sorted_allocList+0x1b3>
  80231c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80231f:	8b 50 08             	mov    0x8(%eax),%edx
  802322:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802325:	8b 00                	mov    (%eax),%eax
  802327:	8b 40 08             	mov    0x8(%eax),%eax
  80232a:	39 c2                	cmp    %eax,%edx
  80232c:	73 70                	jae    80239e <insert_sorted_allocList+0x1b3>
			{
				LIST_INSERT_AFTER(&AllocMemBlocksList, blk, newblk);
  80232e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802332:	74 06                	je     80233a <insert_sorted_allocList+0x14f>
  802334:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802338:	75 17                	jne    802351 <insert_sorted_allocList+0x166>
  80233a:	83 ec 04             	sub    $0x4,%esp
  80233d:	68 d4 3a 80 00       	push   $0x803ad4
  802342:	68 87 00 00 00       	push   $0x87
  802347:	68 97 3a 80 00       	push   $0x803a97
  80234c:	e8 e4 df ff ff       	call   800335 <_panic>
  802351:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802354:	8b 10                	mov    (%eax),%edx
  802356:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802359:	89 10                	mov    %edx,(%eax)
  80235b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80235e:	8b 00                	mov    (%eax),%eax
  802360:	85 c0                	test   %eax,%eax
  802362:	74 0b                	je     80236f <insert_sorted_allocList+0x184>
  802364:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802367:	8b 00                	mov    (%eax),%eax
  802369:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80236c:	89 50 04             	mov    %edx,0x4(%eax)
  80236f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802372:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802375:	89 10                	mov    %edx,(%eax)
  802377:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80237a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80237d:	89 50 04             	mov    %edx,0x4(%eax)
  802380:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802383:	8b 00                	mov    (%eax),%eax
  802385:	85 c0                	test   %eax,%eax
  802387:	75 08                	jne    802391 <insert_sorted_allocList+0x1a6>
  802389:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80238c:	a3 44 40 80 00       	mov    %eax,0x804044
  802391:	a1 4c 40 80 00       	mov    0x80404c,%eax
  802396:	40                   	inc    %eax
  802397:	a3 4c 40 80 00       	mov    %eax,0x80404c
				break;
  80239c:	eb 38                	jmp    8023d6 <insert_sorted_allocList+0x1eb>
	{
		LIST_INSERT_TAIL(&AllocMemBlocksList, newblk);
	}
	else
	{
		LIST_FOREACH(blk, &AllocMemBlocksList)
  80239e:	a1 48 40 80 00       	mov    0x804048,%eax
  8023a3:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8023a6:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8023aa:	74 07                	je     8023b3 <insert_sorted_allocList+0x1c8>
  8023ac:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023af:	8b 00                	mov    (%eax),%eax
  8023b1:	eb 05                	jmp    8023b8 <insert_sorted_allocList+0x1cd>
  8023b3:	b8 00 00 00 00       	mov    $0x0,%eax
  8023b8:	a3 48 40 80 00       	mov    %eax,0x804048
  8023bd:	a1 48 40 80 00       	mov    0x804048,%eax
  8023c2:	85 c0                	test   %eax,%eax
  8023c4:	0f 85 31 ff ff ff    	jne    8022fb <insert_sorted_allocList+0x110>
  8023ca:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8023ce:	0f 85 27 ff ff ff    	jne    8022fb <insert_sorted_allocList+0x110>
				LIST_INSERT_AFTER(&AllocMemBlocksList, blk, newblk);
				break;
			}
		}
	}
}
  8023d4:	eb 00                	jmp    8023d6 <insert_sorted_allocList+0x1eb>
  8023d6:	90                   	nop
  8023d7:	c9                   	leave  
  8023d8:	c3                   	ret    

008023d9 <alloc_block_FF>:

//=========================================
// [4] ALLOCATE BLOCK BY FIRST FIT:
//=========================================
struct MemBlock *alloc_block_FF(uint32 size)
{
  8023d9:	55                   	push   %ebp
  8023da:	89 e5                	mov    %esp,%ebp
  8023dc:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_FF
	// Write your code here, remove the panic and write your code
	//panic("alloc_block_FF() is not implemented yet...!!");
	uint32 versize = size;
  8023df:	8b 45 08             	mov    0x8(%ebp),%eax
  8023e2:	89 45 f0             	mov    %eax,-0x10(%ebp)
	struct MemBlock* blk;
	struct MemBlock* newblk = LIST_FIRST(&AvailableMemBlocksList);
  8023e5:	a1 48 41 80 00       	mov    0x804148,%eax
  8023ea:	89 45 ec             	mov    %eax,-0x14(%ebp)

	LIST_FOREACH(blk,&FreeMemBlocksList)
  8023ed:	a1 38 41 80 00       	mov    0x804138,%eax
  8023f2:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8023f5:	e9 77 01 00 00       	jmp    802571 <alloc_block_FF+0x198>
	{
		if(blk->size == versize)
  8023fa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023fd:	8b 40 0c             	mov    0xc(%eax),%eax
  802400:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  802403:	0f 85 8a 00 00 00    	jne    802493 <alloc_block_FF+0xba>
		{
			LIST_REMOVE(&FreeMemBlocksList,blk);
  802409:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80240d:	75 17                	jne    802426 <alloc_block_FF+0x4d>
  80240f:	83 ec 04             	sub    $0x4,%esp
  802412:	68 08 3b 80 00       	push   $0x803b08
  802417:	68 9e 00 00 00       	push   $0x9e
  80241c:	68 97 3a 80 00       	push   $0x803a97
  802421:	e8 0f df ff ff       	call   800335 <_panic>
  802426:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802429:	8b 00                	mov    (%eax),%eax
  80242b:	85 c0                	test   %eax,%eax
  80242d:	74 10                	je     80243f <alloc_block_FF+0x66>
  80242f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802432:	8b 00                	mov    (%eax),%eax
  802434:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802437:	8b 52 04             	mov    0x4(%edx),%edx
  80243a:	89 50 04             	mov    %edx,0x4(%eax)
  80243d:	eb 0b                	jmp    80244a <alloc_block_FF+0x71>
  80243f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802442:	8b 40 04             	mov    0x4(%eax),%eax
  802445:	a3 3c 41 80 00       	mov    %eax,0x80413c
  80244a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80244d:	8b 40 04             	mov    0x4(%eax),%eax
  802450:	85 c0                	test   %eax,%eax
  802452:	74 0f                	je     802463 <alloc_block_FF+0x8a>
  802454:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802457:	8b 40 04             	mov    0x4(%eax),%eax
  80245a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80245d:	8b 12                	mov    (%edx),%edx
  80245f:	89 10                	mov    %edx,(%eax)
  802461:	eb 0a                	jmp    80246d <alloc_block_FF+0x94>
  802463:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802466:	8b 00                	mov    (%eax),%eax
  802468:	a3 38 41 80 00       	mov    %eax,0x804138
  80246d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802470:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802476:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802479:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802480:	a1 44 41 80 00       	mov    0x804144,%eax
  802485:	48                   	dec    %eax
  802486:	a3 44 41 80 00       	mov    %eax,0x804144
			return blk;
  80248b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80248e:	e9 11 01 00 00       	jmp    8025a4 <alloc_block_FF+0x1cb>
		}
		else if(blk->size > versize)
  802493:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802496:	8b 40 0c             	mov    0xc(%eax),%eax
  802499:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80249c:	0f 86 c7 00 00 00    	jbe    802569 <alloc_block_FF+0x190>
		{
			LIST_REMOVE(&AvailableMemBlocksList,newblk);
  8024a2:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8024a6:	75 17                	jne    8024bf <alloc_block_FF+0xe6>
  8024a8:	83 ec 04             	sub    $0x4,%esp
  8024ab:	68 08 3b 80 00       	push   $0x803b08
  8024b0:	68 a3 00 00 00       	push   $0xa3
  8024b5:	68 97 3a 80 00       	push   $0x803a97
  8024ba:	e8 76 de ff ff       	call   800335 <_panic>
  8024bf:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8024c2:	8b 00                	mov    (%eax),%eax
  8024c4:	85 c0                	test   %eax,%eax
  8024c6:	74 10                	je     8024d8 <alloc_block_FF+0xff>
  8024c8:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8024cb:	8b 00                	mov    (%eax),%eax
  8024cd:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8024d0:	8b 52 04             	mov    0x4(%edx),%edx
  8024d3:	89 50 04             	mov    %edx,0x4(%eax)
  8024d6:	eb 0b                	jmp    8024e3 <alloc_block_FF+0x10a>
  8024d8:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8024db:	8b 40 04             	mov    0x4(%eax),%eax
  8024de:	a3 4c 41 80 00       	mov    %eax,0x80414c
  8024e3:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8024e6:	8b 40 04             	mov    0x4(%eax),%eax
  8024e9:	85 c0                	test   %eax,%eax
  8024eb:	74 0f                	je     8024fc <alloc_block_FF+0x123>
  8024ed:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8024f0:	8b 40 04             	mov    0x4(%eax),%eax
  8024f3:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8024f6:	8b 12                	mov    (%edx),%edx
  8024f8:	89 10                	mov    %edx,(%eax)
  8024fa:	eb 0a                	jmp    802506 <alloc_block_FF+0x12d>
  8024fc:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8024ff:	8b 00                	mov    (%eax),%eax
  802501:	a3 48 41 80 00       	mov    %eax,0x804148
  802506:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802509:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80250f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802512:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802519:	a1 54 41 80 00       	mov    0x804154,%eax
  80251e:	48                   	dec    %eax
  80251f:	a3 54 41 80 00       	mov    %eax,0x804154
			newblk->size = versize;
  802524:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802527:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80252a:	89 50 0c             	mov    %edx,0xc(%eax)
			blk->size = blk->size-versize;
  80252d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802530:	8b 40 0c             	mov    0xc(%eax),%eax
  802533:	2b 45 f0             	sub    -0x10(%ebp),%eax
  802536:	89 c2                	mov    %eax,%edx
  802538:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80253b:	89 50 0c             	mov    %edx,0xc(%eax)
			uint32 newveradd = blk->sva;
  80253e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802541:	8b 40 08             	mov    0x8(%eax),%eax
  802544:	89 45 e8             	mov    %eax,-0x18(%ebp)
			blk->sva+=newblk->size;
  802547:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80254a:	8b 50 08             	mov    0x8(%eax),%edx
  80254d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802550:	8b 40 0c             	mov    0xc(%eax),%eax
  802553:	01 c2                	add    %eax,%edx
  802555:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802558:	89 50 08             	mov    %edx,0x8(%eax)
			newblk->sva = newveradd;
  80255b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80255e:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802561:	89 50 08             	mov    %edx,0x8(%eax)
			return newblk;
  802564:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802567:	eb 3b                	jmp    8025a4 <alloc_block_FF+0x1cb>
	//panic("alloc_block_FF() is not implemented yet...!!");
	uint32 versize = size;
	struct MemBlock* blk;
	struct MemBlock* newblk = LIST_FIRST(&AvailableMemBlocksList);

	LIST_FOREACH(blk,&FreeMemBlocksList)
  802569:	a1 40 41 80 00       	mov    0x804140,%eax
  80256e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802571:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802575:	74 07                	je     80257e <alloc_block_FF+0x1a5>
  802577:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80257a:	8b 00                	mov    (%eax),%eax
  80257c:	eb 05                	jmp    802583 <alloc_block_FF+0x1aa>
  80257e:	b8 00 00 00 00       	mov    $0x0,%eax
  802583:	a3 40 41 80 00       	mov    %eax,0x804140
  802588:	a1 40 41 80 00       	mov    0x804140,%eax
  80258d:	85 c0                	test   %eax,%eax
  80258f:	0f 85 65 fe ff ff    	jne    8023fa <alloc_block_FF+0x21>
  802595:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802599:	0f 85 5b fe ff ff    	jne    8023fa <alloc_block_FF+0x21>
			blk->sva+=newblk->size;
			newblk->sva = newveradd;
			return newblk;
		}
	}
	return NULL;
  80259f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8025a4:	c9                   	leave  
  8025a5:	c3                   	ret    

008025a6 <alloc_block_BF>:

//=========================================
// [5] ALLOCATE BLOCK BY BEST FIT:
//=========================================
struct MemBlock *alloc_block_BF(uint32 size)
{
  8025a6:	55                   	push   %ebp
  8025a7:	89 e5                	mov    %esp,%ebp
  8025a9:	83 ec 28             	sub    $0x28,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_BF
	// Write your code here, remove the panic and write your code
	//panic("alloc_block_BF() is not implemented yet...!!");
	uint32 versize=size;
  8025ac:	8b 45 08             	mov    0x8(%ebp),%eax
  8025af:	89 45 e8             	mov    %eax,-0x18(%ebp)
	struct MemBlock* blk;
	struct MemBlock* newblk=LIST_FIRST(&AvailableMemBlocksList);
  8025b2:	a1 48 41 80 00       	mov    0x804148,%eax
  8025b7:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	uint32 newveradd;
	uint32 newsize;
	int size_free = LIST_SIZE(&FreeMemBlocksList);
  8025ba:	a1 44 41 80 00       	mov    0x804144,%eax
  8025bf:	89 45 e0             	mov    %eax,-0x20(%ebp)

	LIST_FOREACH(blk, &FreeMemBlocksList)
  8025c2:	a1 38 41 80 00       	mov    0x804138,%eax
  8025c7:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8025ca:	e9 a1 00 00 00       	jmp    802670 <alloc_block_BF+0xca>
	{
		if(blk->size == versize)
  8025cf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025d2:	8b 40 0c             	mov    0xc(%eax),%eax
  8025d5:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  8025d8:	0f 85 8a 00 00 00    	jne    802668 <alloc_block_BF+0xc2>
		{
			LIST_REMOVE(&FreeMemBlocksList, blk);
  8025de:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8025e2:	75 17                	jne    8025fb <alloc_block_BF+0x55>
  8025e4:	83 ec 04             	sub    $0x4,%esp
  8025e7:	68 08 3b 80 00       	push   $0x803b08
  8025ec:	68 c2 00 00 00       	push   $0xc2
  8025f1:	68 97 3a 80 00       	push   $0x803a97
  8025f6:	e8 3a dd ff ff       	call   800335 <_panic>
  8025fb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025fe:	8b 00                	mov    (%eax),%eax
  802600:	85 c0                	test   %eax,%eax
  802602:	74 10                	je     802614 <alloc_block_BF+0x6e>
  802604:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802607:	8b 00                	mov    (%eax),%eax
  802609:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80260c:	8b 52 04             	mov    0x4(%edx),%edx
  80260f:	89 50 04             	mov    %edx,0x4(%eax)
  802612:	eb 0b                	jmp    80261f <alloc_block_BF+0x79>
  802614:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802617:	8b 40 04             	mov    0x4(%eax),%eax
  80261a:	a3 3c 41 80 00       	mov    %eax,0x80413c
  80261f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802622:	8b 40 04             	mov    0x4(%eax),%eax
  802625:	85 c0                	test   %eax,%eax
  802627:	74 0f                	je     802638 <alloc_block_BF+0x92>
  802629:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80262c:	8b 40 04             	mov    0x4(%eax),%eax
  80262f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802632:	8b 12                	mov    (%edx),%edx
  802634:	89 10                	mov    %edx,(%eax)
  802636:	eb 0a                	jmp    802642 <alloc_block_BF+0x9c>
  802638:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80263b:	8b 00                	mov    (%eax),%eax
  80263d:	a3 38 41 80 00       	mov    %eax,0x804138
  802642:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802645:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80264b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80264e:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802655:	a1 44 41 80 00       	mov    0x804144,%eax
  80265a:	48                   	dec    %eax
  80265b:	a3 44 41 80 00       	mov    %eax,0x804144
			return blk;
  802660:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802663:	e9 11 02 00 00       	jmp    802879 <alloc_block_BF+0x2d3>
	struct MemBlock* newblk=LIST_FIRST(&AvailableMemBlocksList);
	uint32 newveradd;
	uint32 newsize;
	int size_free = LIST_SIZE(&FreeMemBlocksList);

	LIST_FOREACH(blk, &FreeMemBlocksList)
  802668:	a1 40 41 80 00       	mov    0x804140,%eax
  80266d:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802670:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802674:	74 07                	je     80267d <alloc_block_BF+0xd7>
  802676:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802679:	8b 00                	mov    (%eax),%eax
  80267b:	eb 05                	jmp    802682 <alloc_block_BF+0xdc>
  80267d:	b8 00 00 00 00       	mov    $0x0,%eax
  802682:	a3 40 41 80 00       	mov    %eax,0x804140
  802687:	a1 40 41 80 00       	mov    0x804140,%eax
  80268c:	85 c0                	test   %eax,%eax
  80268e:	0f 85 3b ff ff ff    	jne    8025cf <alloc_block_BF+0x29>
  802694:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802698:	0f 85 31 ff ff ff    	jne    8025cf <alloc_block_BF+0x29>
		{
			LIST_REMOVE(&FreeMemBlocksList, blk);
			return blk;
		}
	}
	LIST_FOREACH(blk, &FreeMemBlocksList)
  80269e:	a1 38 41 80 00       	mov    0x804138,%eax
  8026a3:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8026a6:	eb 27                	jmp    8026cf <alloc_block_BF+0x129>
	{
		if(blk->size > versize)
  8026a8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026ab:	8b 40 0c             	mov    0xc(%eax),%eax
  8026ae:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  8026b1:	76 14                	jbe    8026c7 <alloc_block_BF+0x121>
		{
			newsize = blk->size;
  8026b3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026b6:	8b 40 0c             	mov    0xc(%eax),%eax
  8026b9:	89 45 ec             	mov    %eax,-0x14(%ebp)
			newveradd = blk->sva;
  8026bc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026bf:	8b 40 08             	mov    0x8(%eax),%eax
  8026c2:	89 45 f0             	mov    %eax,-0x10(%ebp)
			break;
  8026c5:	eb 2e                	jmp    8026f5 <alloc_block_BF+0x14f>
		{
			LIST_REMOVE(&FreeMemBlocksList, blk);
			return blk;
		}
	}
	LIST_FOREACH(blk, &FreeMemBlocksList)
  8026c7:	a1 40 41 80 00       	mov    0x804140,%eax
  8026cc:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8026cf:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8026d3:	74 07                	je     8026dc <alloc_block_BF+0x136>
  8026d5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026d8:	8b 00                	mov    (%eax),%eax
  8026da:	eb 05                	jmp    8026e1 <alloc_block_BF+0x13b>
  8026dc:	b8 00 00 00 00       	mov    $0x0,%eax
  8026e1:	a3 40 41 80 00       	mov    %eax,0x804140
  8026e6:	a1 40 41 80 00       	mov    0x804140,%eax
  8026eb:	85 c0                	test   %eax,%eax
  8026ed:	75 b9                	jne    8026a8 <alloc_block_BF+0x102>
  8026ef:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8026f3:	75 b3                	jne    8026a8 <alloc_block_BF+0x102>
			newsize = blk->size;
			newveradd = blk->sva;
			break;
		}
	}
	LIST_FOREACH(blk, &FreeMemBlocksList)
  8026f5:	a1 38 41 80 00       	mov    0x804138,%eax
  8026fa:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8026fd:	eb 30                	jmp    80272f <alloc_block_BF+0x189>
	{
		if(newsize > blk->size && blk->size > versize)
  8026ff:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802702:	8b 40 0c             	mov    0xc(%eax),%eax
  802705:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  802708:	73 1d                	jae    802727 <alloc_block_BF+0x181>
  80270a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80270d:	8b 40 0c             	mov    0xc(%eax),%eax
  802710:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  802713:	76 12                	jbe    802727 <alloc_block_BF+0x181>
		{
	       newsize = blk->size;
  802715:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802718:	8b 40 0c             	mov    0xc(%eax),%eax
  80271b:	89 45 ec             	mov    %eax,-0x14(%ebp)
		   newveradd = blk->sva;
  80271e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802721:	8b 40 08             	mov    0x8(%eax),%eax
  802724:	89 45 f0             	mov    %eax,-0x10(%ebp)
			newsize = blk->size;
			newveradd = blk->sva;
			break;
		}
	}
	LIST_FOREACH(blk, &FreeMemBlocksList)
  802727:	a1 40 41 80 00       	mov    0x804140,%eax
  80272c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80272f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802733:	74 07                	je     80273c <alloc_block_BF+0x196>
  802735:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802738:	8b 00                	mov    (%eax),%eax
  80273a:	eb 05                	jmp    802741 <alloc_block_BF+0x19b>
  80273c:	b8 00 00 00 00       	mov    $0x0,%eax
  802741:	a3 40 41 80 00       	mov    %eax,0x804140
  802746:	a1 40 41 80 00       	mov    0x804140,%eax
  80274b:	85 c0                	test   %eax,%eax
  80274d:	75 b0                	jne    8026ff <alloc_block_BF+0x159>
  80274f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802753:	75 aa                	jne    8026ff <alloc_block_BF+0x159>
		{
	       newsize = blk->size;
		   newveradd = blk->sva;
		}
	}
	LIST_FOREACH(blk, &FreeMemBlocksList)
  802755:	a1 38 41 80 00       	mov    0x804138,%eax
  80275a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80275d:	e9 e4 00 00 00       	jmp    802846 <alloc_block_BF+0x2a0>
	{
		if(blk->size == newsize && blk->sva == newveradd)
  802762:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802765:	8b 40 0c             	mov    0xc(%eax),%eax
  802768:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  80276b:	0f 85 cd 00 00 00    	jne    80283e <alloc_block_BF+0x298>
  802771:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802774:	8b 40 08             	mov    0x8(%eax),%eax
  802777:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80277a:	0f 85 be 00 00 00    	jne    80283e <alloc_block_BF+0x298>
		{
			LIST_REMOVE(&AvailableMemBlocksList, newblk);
  802780:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  802784:	75 17                	jne    80279d <alloc_block_BF+0x1f7>
  802786:	83 ec 04             	sub    $0x4,%esp
  802789:	68 08 3b 80 00       	push   $0x803b08
  80278e:	68 db 00 00 00       	push   $0xdb
  802793:	68 97 3a 80 00       	push   $0x803a97
  802798:	e8 98 db ff ff       	call   800335 <_panic>
  80279d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8027a0:	8b 00                	mov    (%eax),%eax
  8027a2:	85 c0                	test   %eax,%eax
  8027a4:	74 10                	je     8027b6 <alloc_block_BF+0x210>
  8027a6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8027a9:	8b 00                	mov    (%eax),%eax
  8027ab:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8027ae:	8b 52 04             	mov    0x4(%edx),%edx
  8027b1:	89 50 04             	mov    %edx,0x4(%eax)
  8027b4:	eb 0b                	jmp    8027c1 <alloc_block_BF+0x21b>
  8027b6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8027b9:	8b 40 04             	mov    0x4(%eax),%eax
  8027bc:	a3 4c 41 80 00       	mov    %eax,0x80414c
  8027c1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8027c4:	8b 40 04             	mov    0x4(%eax),%eax
  8027c7:	85 c0                	test   %eax,%eax
  8027c9:	74 0f                	je     8027da <alloc_block_BF+0x234>
  8027cb:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8027ce:	8b 40 04             	mov    0x4(%eax),%eax
  8027d1:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8027d4:	8b 12                	mov    (%edx),%edx
  8027d6:	89 10                	mov    %edx,(%eax)
  8027d8:	eb 0a                	jmp    8027e4 <alloc_block_BF+0x23e>
  8027da:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8027dd:	8b 00                	mov    (%eax),%eax
  8027df:	a3 48 41 80 00       	mov    %eax,0x804148
  8027e4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8027e7:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8027ed:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8027f0:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8027f7:	a1 54 41 80 00       	mov    0x804154,%eax
  8027fc:	48                   	dec    %eax
  8027fd:	a3 54 41 80 00       	mov    %eax,0x804154
			newblk->size = versize;
  802802:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802805:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802808:	89 50 0c             	mov    %edx,0xc(%eax)
			newblk->sva = newveradd;
  80280b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80280e:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802811:	89 50 08             	mov    %edx,0x8(%eax)
			blk->size = blk->size - versize;
  802814:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802817:	8b 40 0c             	mov    0xc(%eax),%eax
  80281a:	2b 45 e8             	sub    -0x18(%ebp),%eax
  80281d:	89 c2                	mov    %eax,%edx
  80281f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802822:	89 50 0c             	mov    %edx,0xc(%eax)
			blk->sva+= newblk->size;
  802825:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802828:	8b 50 08             	mov    0x8(%eax),%edx
  80282b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80282e:	8b 40 0c             	mov    0xc(%eax),%eax
  802831:	01 c2                	add    %eax,%edx
  802833:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802836:	89 50 08             	mov    %edx,0x8(%eax)
			return newblk;
  802839:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80283c:	eb 3b                	jmp    802879 <alloc_block_BF+0x2d3>
		{
	       newsize = blk->size;
		   newveradd = blk->sva;
		}
	}
	LIST_FOREACH(blk, &FreeMemBlocksList)
  80283e:	a1 40 41 80 00       	mov    0x804140,%eax
  802843:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802846:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80284a:	74 07                	je     802853 <alloc_block_BF+0x2ad>
  80284c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80284f:	8b 00                	mov    (%eax),%eax
  802851:	eb 05                	jmp    802858 <alloc_block_BF+0x2b2>
  802853:	b8 00 00 00 00       	mov    $0x0,%eax
  802858:	a3 40 41 80 00       	mov    %eax,0x804140
  80285d:	a1 40 41 80 00       	mov    0x804140,%eax
  802862:	85 c0                	test   %eax,%eax
  802864:	0f 85 f8 fe ff ff    	jne    802762 <alloc_block_BF+0x1bc>
  80286a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80286e:	0f 85 ee fe ff ff    	jne    802762 <alloc_block_BF+0x1bc>
			blk->size = blk->size - versize;
			blk->sva+= newblk->size;
			return newblk;
		}
	}
	return NULL;
  802874:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802879:	c9                   	leave  
  80287a:	c3                   	ret    

0080287b <alloc_block_NF>:
//=========================================
// [7] ALLOCATE BLOCK BY NEXT FIT:
//=========================================
struct MemBlock *last_allocate;
struct MemBlock *alloc_block_NF(uint32 size)
{
  80287b:	55                   	push   %ebp
  80287c:	89 e5                	mov    %esp,%ebp
  80287e:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1 - BONUS] [DYNAMIC ALLOCATOR] alloc_block_NF
	// Write your code here, remove the panic and write your code
	//panic("alloc_block_NF() is not implemented yet...!!");
	uint32 versize = size;
  802881:	8b 45 08             	mov    0x8(%ebp),%eax
  802884:	89 45 f0             	mov    %eax,-0x10(%ebp)
	struct MemBlock* blk;
	struct MemBlock* newblk = LIST_FIRST(&AvailableMemBlocksList);
  802887:	a1 48 41 80 00       	mov    0x804148,%eax
  80288c:	89 45 ec             	mov    %eax,-0x14(%ebp)

	LIST_FOREACH(blk,&FreeMemBlocksList)
  80288f:	a1 38 41 80 00       	mov    0x804138,%eax
  802894:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802897:	e9 77 01 00 00       	jmp    802a13 <alloc_block_NF+0x198>
	{
		if(blk->size == versize)
  80289c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80289f:	8b 40 0c             	mov    0xc(%eax),%eax
  8028a2:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8028a5:	0f 85 8a 00 00 00    	jne    802935 <alloc_block_NF+0xba>
		{
			LIST_REMOVE(&FreeMemBlocksList,blk);
  8028ab:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8028af:	75 17                	jne    8028c8 <alloc_block_NF+0x4d>
  8028b1:	83 ec 04             	sub    $0x4,%esp
  8028b4:	68 08 3b 80 00       	push   $0x803b08
  8028b9:	68 f7 00 00 00       	push   $0xf7
  8028be:	68 97 3a 80 00       	push   $0x803a97
  8028c3:	e8 6d da ff ff       	call   800335 <_panic>
  8028c8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028cb:	8b 00                	mov    (%eax),%eax
  8028cd:	85 c0                	test   %eax,%eax
  8028cf:	74 10                	je     8028e1 <alloc_block_NF+0x66>
  8028d1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028d4:	8b 00                	mov    (%eax),%eax
  8028d6:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8028d9:	8b 52 04             	mov    0x4(%edx),%edx
  8028dc:	89 50 04             	mov    %edx,0x4(%eax)
  8028df:	eb 0b                	jmp    8028ec <alloc_block_NF+0x71>
  8028e1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028e4:	8b 40 04             	mov    0x4(%eax),%eax
  8028e7:	a3 3c 41 80 00       	mov    %eax,0x80413c
  8028ec:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028ef:	8b 40 04             	mov    0x4(%eax),%eax
  8028f2:	85 c0                	test   %eax,%eax
  8028f4:	74 0f                	je     802905 <alloc_block_NF+0x8a>
  8028f6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028f9:	8b 40 04             	mov    0x4(%eax),%eax
  8028fc:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8028ff:	8b 12                	mov    (%edx),%edx
  802901:	89 10                	mov    %edx,(%eax)
  802903:	eb 0a                	jmp    80290f <alloc_block_NF+0x94>
  802905:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802908:	8b 00                	mov    (%eax),%eax
  80290a:	a3 38 41 80 00       	mov    %eax,0x804138
  80290f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802912:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802918:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80291b:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802922:	a1 44 41 80 00       	mov    0x804144,%eax
  802927:	48                   	dec    %eax
  802928:	a3 44 41 80 00       	mov    %eax,0x804144
			return blk;
  80292d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802930:	e9 11 01 00 00       	jmp    802a46 <alloc_block_NF+0x1cb>
		}
		else if(blk->size > versize)
  802935:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802938:	8b 40 0c             	mov    0xc(%eax),%eax
  80293b:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80293e:	0f 86 c7 00 00 00    	jbe    802a0b <alloc_block_NF+0x190>
		{
			LIST_REMOVE(&AvailableMemBlocksList,newblk);
  802944:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802948:	75 17                	jne    802961 <alloc_block_NF+0xe6>
  80294a:	83 ec 04             	sub    $0x4,%esp
  80294d:	68 08 3b 80 00       	push   $0x803b08
  802952:	68 fc 00 00 00       	push   $0xfc
  802957:	68 97 3a 80 00       	push   $0x803a97
  80295c:	e8 d4 d9 ff ff       	call   800335 <_panic>
  802961:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802964:	8b 00                	mov    (%eax),%eax
  802966:	85 c0                	test   %eax,%eax
  802968:	74 10                	je     80297a <alloc_block_NF+0xff>
  80296a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80296d:	8b 00                	mov    (%eax),%eax
  80296f:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802972:	8b 52 04             	mov    0x4(%edx),%edx
  802975:	89 50 04             	mov    %edx,0x4(%eax)
  802978:	eb 0b                	jmp    802985 <alloc_block_NF+0x10a>
  80297a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80297d:	8b 40 04             	mov    0x4(%eax),%eax
  802980:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802985:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802988:	8b 40 04             	mov    0x4(%eax),%eax
  80298b:	85 c0                	test   %eax,%eax
  80298d:	74 0f                	je     80299e <alloc_block_NF+0x123>
  80298f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802992:	8b 40 04             	mov    0x4(%eax),%eax
  802995:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802998:	8b 12                	mov    (%edx),%edx
  80299a:	89 10                	mov    %edx,(%eax)
  80299c:	eb 0a                	jmp    8029a8 <alloc_block_NF+0x12d>
  80299e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8029a1:	8b 00                	mov    (%eax),%eax
  8029a3:	a3 48 41 80 00       	mov    %eax,0x804148
  8029a8:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8029ab:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8029b1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8029b4:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8029bb:	a1 54 41 80 00       	mov    0x804154,%eax
  8029c0:	48                   	dec    %eax
  8029c1:	a3 54 41 80 00       	mov    %eax,0x804154
			newblk->size = versize;
  8029c6:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8029c9:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8029cc:	89 50 0c             	mov    %edx,0xc(%eax)
			blk->size = blk->size-versize;
  8029cf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029d2:	8b 40 0c             	mov    0xc(%eax),%eax
  8029d5:	2b 45 f0             	sub    -0x10(%ebp),%eax
  8029d8:	89 c2                	mov    %eax,%edx
  8029da:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029dd:	89 50 0c             	mov    %edx,0xc(%eax)
			uint32 newveradd = blk->sva;
  8029e0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029e3:	8b 40 08             	mov    0x8(%eax),%eax
  8029e6:	89 45 e8             	mov    %eax,-0x18(%ebp)
			blk->sva+=newblk->size;
  8029e9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029ec:	8b 50 08             	mov    0x8(%eax),%edx
  8029ef:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8029f2:	8b 40 0c             	mov    0xc(%eax),%eax
  8029f5:	01 c2                	add    %eax,%edx
  8029f7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029fa:	89 50 08             	mov    %edx,0x8(%eax)
			newblk->sva = newveradd;
  8029fd:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802a00:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802a03:	89 50 08             	mov    %edx,0x8(%eax)
			return newblk;
  802a06:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802a09:	eb 3b                	jmp    802a46 <alloc_block_NF+0x1cb>
	//panic("alloc_block_NF() is not implemented yet...!!");
	uint32 versize = size;
	struct MemBlock* blk;
	struct MemBlock* newblk = LIST_FIRST(&AvailableMemBlocksList);

	LIST_FOREACH(blk,&FreeMemBlocksList)
  802a0b:	a1 40 41 80 00       	mov    0x804140,%eax
  802a10:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802a13:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802a17:	74 07                	je     802a20 <alloc_block_NF+0x1a5>
  802a19:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a1c:	8b 00                	mov    (%eax),%eax
  802a1e:	eb 05                	jmp    802a25 <alloc_block_NF+0x1aa>
  802a20:	b8 00 00 00 00       	mov    $0x0,%eax
  802a25:	a3 40 41 80 00       	mov    %eax,0x804140
  802a2a:	a1 40 41 80 00       	mov    0x804140,%eax
  802a2f:	85 c0                	test   %eax,%eax
  802a31:	0f 85 65 fe ff ff    	jne    80289c <alloc_block_NF+0x21>
  802a37:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802a3b:	0f 85 5b fe ff ff    	jne    80289c <alloc_block_NF+0x21>
			blk->sva+=newblk->size;
			newblk->sva = newveradd;
			return newblk;
		}
	}
	return NULL;
  802a41:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802a46:	c9                   	leave  
  802a47:	c3                   	ret    

00802a48 <addToAvailMemBlocksList>:

//===================================================
// [8] INSERT BLOCK (SORTED WITH MERGE) IN FREE LIST:
//===================================================
void addToAvailMemBlocksList(struct MemBlock *blockToInsert)
{
  802a48:	55                   	push   %ebp
  802a49:	89 e5                	mov    %esp,%ebp
  802a4b:	83 ec 08             	sub    $0x8,%esp
	blockToInsert->sva = 0;
  802a4e:	8b 45 08             	mov    0x8(%ebp),%eax
  802a51:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
	blockToInsert->size = 0;
  802a58:	8b 45 08             	mov    0x8(%ebp),%eax
  802a5b:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
	//add to avail
	LIST_INSERT_TAIL(&AvailableMemBlocksList, blockToInsert);
  802a62:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802a66:	75 17                	jne    802a7f <addToAvailMemBlocksList+0x37>
  802a68:	83 ec 04             	sub    $0x4,%esp
  802a6b:	68 b0 3a 80 00       	push   $0x803ab0
  802a70:	68 10 01 00 00       	push   $0x110
  802a75:	68 97 3a 80 00       	push   $0x803a97
  802a7a:	e8 b6 d8 ff ff       	call   800335 <_panic>
  802a7f:	8b 15 4c 41 80 00    	mov    0x80414c,%edx
  802a85:	8b 45 08             	mov    0x8(%ebp),%eax
  802a88:	89 50 04             	mov    %edx,0x4(%eax)
  802a8b:	8b 45 08             	mov    0x8(%ebp),%eax
  802a8e:	8b 40 04             	mov    0x4(%eax),%eax
  802a91:	85 c0                	test   %eax,%eax
  802a93:	74 0c                	je     802aa1 <addToAvailMemBlocksList+0x59>
  802a95:	a1 4c 41 80 00       	mov    0x80414c,%eax
  802a9a:	8b 55 08             	mov    0x8(%ebp),%edx
  802a9d:	89 10                	mov    %edx,(%eax)
  802a9f:	eb 08                	jmp    802aa9 <addToAvailMemBlocksList+0x61>
  802aa1:	8b 45 08             	mov    0x8(%ebp),%eax
  802aa4:	a3 48 41 80 00       	mov    %eax,0x804148
  802aa9:	8b 45 08             	mov    0x8(%ebp),%eax
  802aac:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802ab1:	8b 45 08             	mov    0x8(%ebp),%eax
  802ab4:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802aba:	a1 54 41 80 00       	mov    0x804154,%eax
  802abf:	40                   	inc    %eax
  802ac0:	a3 54 41 80 00       	mov    %eax,0x804154
}
  802ac5:	90                   	nop
  802ac6:	c9                   	leave  
  802ac7:	c3                   	ret    

00802ac8 <insert_sorted_with_merge_freeList>:
void insert_sorted_with_merge_freeList(struct MemBlock *blockToInsert)
{
  802ac8:	55                   	push   %ebp
  802ac9:	89 e5                	mov    %esp,%ebp
  802acb:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] insert_sorted_with_merge_freeList
	// Write your code here, remove the panic and write your code

	struct MemBlock* last = LIST_LAST(&FreeMemBlocksList);
  802ace:	a1 3c 41 80 00       	mov    0x80413c,%eax
  802ad3:	89 45 f0             	mov    %eax,-0x10(%ebp)
	//check if list empty
	if (LIST_SIZE(&(FreeMemBlocksList)) == 0)
  802ad6:	a1 44 41 80 00       	mov    0x804144,%eax
  802adb:	85 c0                	test   %eax,%eax
  802add:	75 68                	jne    802b47 <insert_sorted_with_merge_freeList+0x7f>
		LIST_INSERT_HEAD(&FreeMemBlocksList, blockToInsert);
  802adf:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802ae3:	75 17                	jne    802afc <insert_sorted_with_merge_freeList+0x34>
  802ae5:	83 ec 04             	sub    $0x4,%esp
  802ae8:	68 74 3a 80 00       	push   $0x803a74
  802aed:	68 1a 01 00 00       	push   $0x11a
  802af2:	68 97 3a 80 00       	push   $0x803a97
  802af7:	e8 39 d8 ff ff       	call   800335 <_panic>
  802afc:	8b 15 38 41 80 00    	mov    0x804138,%edx
  802b02:	8b 45 08             	mov    0x8(%ebp),%eax
  802b05:	89 10                	mov    %edx,(%eax)
  802b07:	8b 45 08             	mov    0x8(%ebp),%eax
  802b0a:	8b 00                	mov    (%eax),%eax
  802b0c:	85 c0                	test   %eax,%eax
  802b0e:	74 0d                	je     802b1d <insert_sorted_with_merge_freeList+0x55>
  802b10:	a1 38 41 80 00       	mov    0x804138,%eax
  802b15:	8b 55 08             	mov    0x8(%ebp),%edx
  802b18:	89 50 04             	mov    %edx,0x4(%eax)
  802b1b:	eb 08                	jmp    802b25 <insert_sorted_with_merge_freeList+0x5d>
  802b1d:	8b 45 08             	mov    0x8(%ebp),%eax
  802b20:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802b25:	8b 45 08             	mov    0x8(%ebp),%eax
  802b28:	a3 38 41 80 00       	mov    %eax,0x804138
  802b2d:	8b 45 08             	mov    0x8(%ebp),%eax
  802b30:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802b37:	a1 44 41 80 00       	mov    0x804144,%eax
  802b3c:	40                   	inc    %eax
  802b3d:	a3 44 41 80 00       	mov    %eax,0x804144
		}
	}

	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  802b42:	e9 c5 03 00 00       	jmp    802f0c <insert_sorted_with_merge_freeList+0x444>
	struct MemBlock* last = LIST_LAST(&FreeMemBlocksList);
	//check if list empty
	if (LIST_SIZE(&(FreeMemBlocksList)) == 0)
		LIST_INSERT_HEAD(&FreeMemBlocksList, blockToInsert);
	//check if it's position is at last
	else if (last->sva < blockToInsert->sva) {
  802b47:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b4a:	8b 50 08             	mov    0x8(%eax),%edx
  802b4d:	8b 45 08             	mov    0x8(%ebp),%eax
  802b50:	8b 40 08             	mov    0x8(%eax),%eax
  802b53:	39 c2                	cmp    %eax,%edx
  802b55:	0f 83 b2 00 00 00    	jae    802c0d <insert_sorted_with_merge_freeList+0x145>

		//if i have to merge
		if (last->sva + last->size == blockToInsert->sva) {
  802b5b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b5e:	8b 50 08             	mov    0x8(%eax),%edx
  802b61:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b64:	8b 40 0c             	mov    0xc(%eax),%eax
  802b67:	01 c2                	add    %eax,%edx
  802b69:	8b 45 08             	mov    0x8(%ebp),%eax
  802b6c:	8b 40 08             	mov    0x8(%eax),%eax
  802b6f:	39 c2                	cmp    %eax,%edx
  802b71:	75 27                	jne    802b9a <insert_sorted_with_merge_freeList+0xd2>
			last->size = last->size + blockToInsert->size;
  802b73:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b76:	8b 50 0c             	mov    0xc(%eax),%edx
  802b79:	8b 45 08             	mov    0x8(%ebp),%eax
  802b7c:	8b 40 0c             	mov    0xc(%eax),%eax
  802b7f:	01 c2                	add    %eax,%edx
  802b81:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b84:	89 50 0c             	mov    %edx,0xc(%eax)
			addToAvailMemBlocksList(blockToInsert);
  802b87:	83 ec 0c             	sub    $0xc,%esp
  802b8a:	ff 75 08             	pushl  0x8(%ebp)
  802b8d:	e8 b6 fe ff ff       	call   802a48 <addToAvailMemBlocksList>
  802b92:	83 c4 10             	add    $0x10,%esp
		}
	}

	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  802b95:	e9 72 03 00 00       	jmp    802f0c <insert_sorted_with_merge_freeList+0x444>
		if (last->sva + last->size == blockToInsert->sva) {
			last->size = last->size + blockToInsert->size;
			addToAvailMemBlocksList(blockToInsert);

		} else {
			LIST_INSERT_AFTER(&FreeMemBlocksList, last, blockToInsert);
  802b9a:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802b9e:	74 06                	je     802ba6 <insert_sorted_with_merge_freeList+0xde>
  802ba0:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802ba4:	75 17                	jne    802bbd <insert_sorted_with_merge_freeList+0xf5>
  802ba6:	83 ec 04             	sub    $0x4,%esp
  802ba9:	68 d4 3a 80 00       	push   $0x803ad4
  802bae:	68 24 01 00 00       	push   $0x124
  802bb3:	68 97 3a 80 00       	push   $0x803a97
  802bb8:	e8 78 d7 ff ff       	call   800335 <_panic>
  802bbd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802bc0:	8b 10                	mov    (%eax),%edx
  802bc2:	8b 45 08             	mov    0x8(%ebp),%eax
  802bc5:	89 10                	mov    %edx,(%eax)
  802bc7:	8b 45 08             	mov    0x8(%ebp),%eax
  802bca:	8b 00                	mov    (%eax),%eax
  802bcc:	85 c0                	test   %eax,%eax
  802bce:	74 0b                	je     802bdb <insert_sorted_with_merge_freeList+0x113>
  802bd0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802bd3:	8b 00                	mov    (%eax),%eax
  802bd5:	8b 55 08             	mov    0x8(%ebp),%edx
  802bd8:	89 50 04             	mov    %edx,0x4(%eax)
  802bdb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802bde:	8b 55 08             	mov    0x8(%ebp),%edx
  802be1:	89 10                	mov    %edx,(%eax)
  802be3:	8b 45 08             	mov    0x8(%ebp),%eax
  802be6:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802be9:	89 50 04             	mov    %edx,0x4(%eax)
  802bec:	8b 45 08             	mov    0x8(%ebp),%eax
  802bef:	8b 00                	mov    (%eax),%eax
  802bf1:	85 c0                	test   %eax,%eax
  802bf3:	75 08                	jne    802bfd <insert_sorted_with_merge_freeList+0x135>
  802bf5:	8b 45 08             	mov    0x8(%ebp),%eax
  802bf8:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802bfd:	a1 44 41 80 00       	mov    0x804144,%eax
  802c02:	40                   	inc    %eax
  802c03:	a3 44 41 80 00       	mov    %eax,0x804144
		}
	}

	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  802c08:	e9 ff 02 00 00       	jmp    802f0c <insert_sorted_with_merge_freeList+0x444>
		} else {
			LIST_INSERT_AFTER(&FreeMemBlocksList, last, blockToInsert);
		}
	} else {
		struct MemBlock *iterator;
		LIST_FOREACH(iterator, &(FreeMemBlocksList))
  802c0d:	a1 38 41 80 00       	mov    0x804138,%eax
  802c12:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802c15:	e9 c2 02 00 00       	jmp    802edc <insert_sorted_with_merge_freeList+0x414>
		{

			if (iterator->sva > blockToInsert->sva) {
  802c1a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c1d:	8b 50 08             	mov    0x8(%eax),%edx
  802c20:	8b 45 08             	mov    0x8(%ebp),%eax
  802c23:	8b 40 08             	mov    0x8(%eax),%eax
  802c26:	39 c2                	cmp    %eax,%edx
  802c28:	0f 86 a6 02 00 00    	jbe    802ed4 <insert_sorted_with_merge_freeList+0x40c>

				struct MemBlock* prev = LIST_PREV(iterator);
  802c2e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c31:	8b 40 04             	mov    0x4(%eax),%eax
  802c34:	89 45 ec             	mov    %eax,-0x14(%ebp)
				if (prev == NULL) {
  802c37:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802c3b:	0f 85 ba 00 00 00    	jne    802cfb <insert_sorted_with_merge_freeList+0x233>
					//check merge
					if (blockToInsert->size + blockToInsert->sva
  802c41:	8b 45 08             	mov    0x8(%ebp),%eax
  802c44:	8b 50 0c             	mov    0xc(%eax),%edx
  802c47:	8b 45 08             	mov    0x8(%ebp),%eax
  802c4a:	8b 40 08             	mov    0x8(%eax),%eax
  802c4d:	01 c2                	add    %eax,%edx
							== iterator->sva) {
  802c4f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c52:	8b 40 08             	mov    0x8(%eax),%eax
			if (iterator->sva > blockToInsert->sva) {

				struct MemBlock* prev = LIST_PREV(iterator);
				if (prev == NULL) {
					//check merge
					if (blockToInsert->size + blockToInsert->sva
  802c55:	39 c2                	cmp    %eax,%edx
  802c57:	75 33                	jne    802c8c <insert_sorted_with_merge_freeList+0x1c4>
							== iterator->sva) {
						iterator->sva = blockToInsert->sva;
  802c59:	8b 45 08             	mov    0x8(%ebp),%eax
  802c5c:	8b 50 08             	mov    0x8(%eax),%edx
  802c5f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c62:	89 50 08             	mov    %edx,0x8(%eax)
						iterator->size = iterator->size + blockToInsert->size;
  802c65:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c68:	8b 50 0c             	mov    0xc(%eax),%edx
  802c6b:	8b 45 08             	mov    0x8(%ebp),%eax
  802c6e:	8b 40 0c             	mov    0xc(%eax),%eax
  802c71:	01 c2                	add    %eax,%edx
  802c73:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c76:	89 50 0c             	mov    %edx,0xc(%eax)
						addToAvailMemBlocksList(blockToInsert);
  802c79:	83 ec 0c             	sub    $0xc,%esp
  802c7c:	ff 75 08             	pushl  0x8(%ebp)
  802c7f:	e8 c4 fd ff ff       	call   802a48 <addToAvailMemBlocksList>
  802c84:	83 c4 10             	add    $0x10,%esp

					else {
						LIST_INSERT_BEFORE(&FreeMemBlocksList, iterator,
								blockToInsert);
					}
					break;
  802c87:	e9 80 02 00 00       	jmp    802f0c <insert_sorted_with_merge_freeList+0x444>
						addToAvailMemBlocksList(blockToInsert);

					}

					else {
						LIST_INSERT_BEFORE(&FreeMemBlocksList, iterator,
  802c8c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802c90:	74 06                	je     802c98 <insert_sorted_with_merge_freeList+0x1d0>
  802c92:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802c96:	75 17                	jne    802caf <insert_sorted_with_merge_freeList+0x1e7>
  802c98:	83 ec 04             	sub    $0x4,%esp
  802c9b:	68 28 3b 80 00       	push   $0x803b28
  802ca0:	68 3a 01 00 00       	push   $0x13a
  802ca5:	68 97 3a 80 00       	push   $0x803a97
  802caa:	e8 86 d6 ff ff       	call   800335 <_panic>
  802caf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cb2:	8b 50 04             	mov    0x4(%eax),%edx
  802cb5:	8b 45 08             	mov    0x8(%ebp),%eax
  802cb8:	89 50 04             	mov    %edx,0x4(%eax)
  802cbb:	8b 45 08             	mov    0x8(%ebp),%eax
  802cbe:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802cc1:	89 10                	mov    %edx,(%eax)
  802cc3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cc6:	8b 40 04             	mov    0x4(%eax),%eax
  802cc9:	85 c0                	test   %eax,%eax
  802ccb:	74 0d                	je     802cda <insert_sorted_with_merge_freeList+0x212>
  802ccd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cd0:	8b 40 04             	mov    0x4(%eax),%eax
  802cd3:	8b 55 08             	mov    0x8(%ebp),%edx
  802cd6:	89 10                	mov    %edx,(%eax)
  802cd8:	eb 08                	jmp    802ce2 <insert_sorted_with_merge_freeList+0x21a>
  802cda:	8b 45 08             	mov    0x8(%ebp),%eax
  802cdd:	a3 38 41 80 00       	mov    %eax,0x804138
  802ce2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ce5:	8b 55 08             	mov    0x8(%ebp),%edx
  802ce8:	89 50 04             	mov    %edx,0x4(%eax)
  802ceb:	a1 44 41 80 00       	mov    0x804144,%eax
  802cf0:	40                   	inc    %eax
  802cf1:	a3 44 41 80 00       	mov    %eax,0x804144
								blockToInsert);
					}
					break;
  802cf6:	e9 11 02 00 00       	jmp    802f0c <insert_sorted_with_merge_freeList+0x444>
				} else {
					//prev and next merge
					if (prev->sva + prev->size + blockToInsert->size
  802cfb:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802cfe:	8b 50 08             	mov    0x8(%eax),%edx
  802d01:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802d04:	8b 40 0c             	mov    0xc(%eax),%eax
  802d07:	01 c2                	add    %eax,%edx
  802d09:	8b 45 08             	mov    0x8(%ebp),%eax
  802d0c:	8b 40 0c             	mov    0xc(%eax),%eax
  802d0f:	01 c2                	add    %eax,%edx
							== iterator->sva) {
  802d11:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d14:	8b 40 08             	mov    0x8(%eax),%eax
								blockToInsert);
					}
					break;
				} else {
					//prev and next merge
					if (prev->sva + prev->size + blockToInsert->size
  802d17:	39 c2                	cmp    %eax,%edx
  802d19:	0f 85 bf 00 00 00    	jne    802dde <insert_sorted_with_merge_freeList+0x316>
							== iterator->sva) {
						prev->size = prev->size + blockToInsert->size
  802d1f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802d22:	8b 50 0c             	mov    0xc(%eax),%edx
  802d25:	8b 45 08             	mov    0x8(%ebp),%eax
  802d28:	8b 40 0c             	mov    0xc(%eax),%eax
  802d2b:	01 c2                	add    %eax,%edx
								+ iterator->size;
  802d2d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d30:	8b 40 0c             	mov    0xc(%eax),%eax
  802d33:	01 c2                	add    %eax,%edx
					break;
				} else {
					//prev and next merge
					if (prev->sva + prev->size + blockToInsert->size
							== iterator->sva) {
						prev->size = prev->size + blockToInsert->size
  802d35:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802d38:	89 50 0c             	mov    %edx,0xc(%eax)
								+ iterator->size;
						LIST_REMOVE(&FreeMemBlocksList, iterator);
  802d3b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802d3f:	75 17                	jne    802d58 <insert_sorted_with_merge_freeList+0x290>
  802d41:	83 ec 04             	sub    $0x4,%esp
  802d44:	68 08 3b 80 00       	push   $0x803b08
  802d49:	68 43 01 00 00       	push   $0x143
  802d4e:	68 97 3a 80 00       	push   $0x803a97
  802d53:	e8 dd d5 ff ff       	call   800335 <_panic>
  802d58:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d5b:	8b 00                	mov    (%eax),%eax
  802d5d:	85 c0                	test   %eax,%eax
  802d5f:	74 10                	je     802d71 <insert_sorted_with_merge_freeList+0x2a9>
  802d61:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d64:	8b 00                	mov    (%eax),%eax
  802d66:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802d69:	8b 52 04             	mov    0x4(%edx),%edx
  802d6c:	89 50 04             	mov    %edx,0x4(%eax)
  802d6f:	eb 0b                	jmp    802d7c <insert_sorted_with_merge_freeList+0x2b4>
  802d71:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d74:	8b 40 04             	mov    0x4(%eax),%eax
  802d77:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802d7c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d7f:	8b 40 04             	mov    0x4(%eax),%eax
  802d82:	85 c0                	test   %eax,%eax
  802d84:	74 0f                	je     802d95 <insert_sorted_with_merge_freeList+0x2cd>
  802d86:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d89:	8b 40 04             	mov    0x4(%eax),%eax
  802d8c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802d8f:	8b 12                	mov    (%edx),%edx
  802d91:	89 10                	mov    %edx,(%eax)
  802d93:	eb 0a                	jmp    802d9f <insert_sorted_with_merge_freeList+0x2d7>
  802d95:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d98:	8b 00                	mov    (%eax),%eax
  802d9a:	a3 38 41 80 00       	mov    %eax,0x804138
  802d9f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802da2:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802da8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802dab:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802db2:	a1 44 41 80 00       	mov    0x804144,%eax
  802db7:	48                   	dec    %eax
  802db8:	a3 44 41 80 00       	mov    %eax,0x804144
						addToAvailMemBlocksList(blockToInsert);
  802dbd:	83 ec 0c             	sub    $0xc,%esp
  802dc0:	ff 75 08             	pushl  0x8(%ebp)
  802dc3:	e8 80 fc ff ff       	call   802a48 <addToAvailMemBlocksList>
  802dc8:	83 c4 10             	add    $0x10,%esp
						addToAvailMemBlocksList(iterator);
  802dcb:	83 ec 0c             	sub    $0xc,%esp
  802dce:	ff 75 f4             	pushl  -0xc(%ebp)
  802dd1:	e8 72 fc ff ff       	call   802a48 <addToAvailMemBlocksList>
  802dd6:	83 c4 10             	add    $0x10,%esp
					//Insert
					else {
						LIST_INSERT_BEFORE(&FreeMemBlocksList, iterator,
								blockToInsert);
					}
					break;
  802dd9:	e9 2e 01 00 00       	jmp    802f0c <insert_sorted_with_merge_freeList+0x444>
						LIST_REMOVE(&FreeMemBlocksList, iterator);
						addToAvailMemBlocksList(blockToInsert);
						addToAvailMemBlocksList(iterator);
					}
					//previous merge
					else if (prev->sva + prev->size == blockToInsert->sva) {
  802dde:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802de1:	8b 50 08             	mov    0x8(%eax),%edx
  802de4:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802de7:	8b 40 0c             	mov    0xc(%eax),%eax
  802dea:	01 c2                	add    %eax,%edx
  802dec:	8b 45 08             	mov    0x8(%ebp),%eax
  802def:	8b 40 08             	mov    0x8(%eax),%eax
  802df2:	39 c2                	cmp    %eax,%edx
  802df4:	75 27                	jne    802e1d <insert_sorted_with_merge_freeList+0x355>
						prev->size = prev->size + blockToInsert->size;
  802df6:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802df9:	8b 50 0c             	mov    0xc(%eax),%edx
  802dfc:	8b 45 08             	mov    0x8(%ebp),%eax
  802dff:	8b 40 0c             	mov    0xc(%eax),%eax
  802e02:	01 c2                	add    %eax,%edx
  802e04:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802e07:	89 50 0c             	mov    %edx,0xc(%eax)
						addToAvailMemBlocksList(blockToInsert);
  802e0a:	83 ec 0c             	sub    $0xc,%esp
  802e0d:	ff 75 08             	pushl  0x8(%ebp)
  802e10:	e8 33 fc ff ff       	call   802a48 <addToAvailMemBlocksList>
  802e15:	83 c4 10             	add    $0x10,%esp
					//Insert
					else {
						LIST_INSERT_BEFORE(&FreeMemBlocksList, iterator,
								blockToInsert);
					}
					break;
  802e18:	e9 ef 00 00 00       	jmp    802f0c <insert_sorted_with_merge_freeList+0x444>
					else if (prev->sva + prev->size == blockToInsert->sva) {
						prev->size = prev->size + blockToInsert->size;
						addToAvailMemBlocksList(blockToInsert);
					}
					//next merge
					else if (blockToInsert->size + blockToInsert->sva
  802e1d:	8b 45 08             	mov    0x8(%ebp),%eax
  802e20:	8b 50 0c             	mov    0xc(%eax),%edx
  802e23:	8b 45 08             	mov    0x8(%ebp),%eax
  802e26:	8b 40 08             	mov    0x8(%eax),%eax
  802e29:	01 c2                	add    %eax,%edx
							== iterator->sva) {
  802e2b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e2e:	8b 40 08             	mov    0x8(%eax),%eax
					else if (prev->sva + prev->size == blockToInsert->sva) {
						prev->size = prev->size + blockToInsert->size;
						addToAvailMemBlocksList(blockToInsert);
					}
					//next merge
					else if (blockToInsert->size + blockToInsert->sva
  802e31:	39 c2                	cmp    %eax,%edx
  802e33:	75 33                	jne    802e68 <insert_sorted_with_merge_freeList+0x3a0>
							== iterator->sva) {
						iterator->sva = blockToInsert->sva;
  802e35:	8b 45 08             	mov    0x8(%ebp),%eax
  802e38:	8b 50 08             	mov    0x8(%eax),%edx
  802e3b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e3e:	89 50 08             	mov    %edx,0x8(%eax)
						iterator->size = iterator->size + blockToInsert->size;
  802e41:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e44:	8b 50 0c             	mov    0xc(%eax),%edx
  802e47:	8b 45 08             	mov    0x8(%ebp),%eax
  802e4a:	8b 40 0c             	mov    0xc(%eax),%eax
  802e4d:	01 c2                	add    %eax,%edx
  802e4f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e52:	89 50 0c             	mov    %edx,0xc(%eax)
						addToAvailMemBlocksList(blockToInsert);
  802e55:	83 ec 0c             	sub    $0xc,%esp
  802e58:	ff 75 08             	pushl  0x8(%ebp)
  802e5b:	e8 e8 fb ff ff       	call   802a48 <addToAvailMemBlocksList>
  802e60:	83 c4 10             	add    $0x10,%esp
					//Insert
					else {
						LIST_INSERT_BEFORE(&FreeMemBlocksList, iterator,
								blockToInsert);
					}
					break;
  802e63:	e9 a4 00 00 00       	jmp    802f0c <insert_sorted_with_merge_freeList+0x444>
						iterator->size = iterator->size + blockToInsert->size;
						addToAvailMemBlocksList(blockToInsert);
					}
					//Insert
					else {
						LIST_INSERT_BEFORE(&FreeMemBlocksList, iterator,
  802e68:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802e6c:	74 06                	je     802e74 <insert_sorted_with_merge_freeList+0x3ac>
  802e6e:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802e72:	75 17                	jne    802e8b <insert_sorted_with_merge_freeList+0x3c3>
  802e74:	83 ec 04             	sub    $0x4,%esp
  802e77:	68 28 3b 80 00       	push   $0x803b28
  802e7c:	68 56 01 00 00       	push   $0x156
  802e81:	68 97 3a 80 00       	push   $0x803a97
  802e86:	e8 aa d4 ff ff       	call   800335 <_panic>
  802e8b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e8e:	8b 50 04             	mov    0x4(%eax),%edx
  802e91:	8b 45 08             	mov    0x8(%ebp),%eax
  802e94:	89 50 04             	mov    %edx,0x4(%eax)
  802e97:	8b 45 08             	mov    0x8(%ebp),%eax
  802e9a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802e9d:	89 10                	mov    %edx,(%eax)
  802e9f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ea2:	8b 40 04             	mov    0x4(%eax),%eax
  802ea5:	85 c0                	test   %eax,%eax
  802ea7:	74 0d                	je     802eb6 <insert_sorted_with_merge_freeList+0x3ee>
  802ea9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802eac:	8b 40 04             	mov    0x4(%eax),%eax
  802eaf:	8b 55 08             	mov    0x8(%ebp),%edx
  802eb2:	89 10                	mov    %edx,(%eax)
  802eb4:	eb 08                	jmp    802ebe <insert_sorted_with_merge_freeList+0x3f6>
  802eb6:	8b 45 08             	mov    0x8(%ebp),%eax
  802eb9:	a3 38 41 80 00       	mov    %eax,0x804138
  802ebe:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ec1:	8b 55 08             	mov    0x8(%ebp),%edx
  802ec4:	89 50 04             	mov    %edx,0x4(%eax)
  802ec7:	a1 44 41 80 00       	mov    0x804144,%eax
  802ecc:	40                   	inc    %eax
  802ecd:	a3 44 41 80 00       	mov    %eax,0x804144
								blockToInsert);
					}
					break;
  802ed2:	eb 38                	jmp    802f0c <insert_sorted_with_merge_freeList+0x444>
		} else {
			LIST_INSERT_AFTER(&FreeMemBlocksList, last, blockToInsert);
		}
	} else {
		struct MemBlock *iterator;
		LIST_FOREACH(iterator, &(FreeMemBlocksList))
  802ed4:	a1 40 41 80 00       	mov    0x804140,%eax
  802ed9:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802edc:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802ee0:	74 07                	je     802ee9 <insert_sorted_with_merge_freeList+0x421>
  802ee2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ee5:	8b 00                	mov    (%eax),%eax
  802ee7:	eb 05                	jmp    802eee <insert_sorted_with_merge_freeList+0x426>
  802ee9:	b8 00 00 00 00       	mov    $0x0,%eax
  802eee:	a3 40 41 80 00       	mov    %eax,0x804140
  802ef3:	a1 40 41 80 00       	mov    0x804140,%eax
  802ef8:	85 c0                	test   %eax,%eax
  802efa:	0f 85 1a fd ff ff    	jne    802c1a <insert_sorted_with_merge_freeList+0x152>
  802f00:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802f04:	0f 85 10 fd ff ff    	jne    802c1a <insert_sorted_with_merge_freeList+0x152>
		}
	}

	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  802f0a:	eb 00                	jmp    802f0c <insert_sorted_with_merge_freeList+0x444>
  802f0c:	90                   	nop
  802f0d:	c9                   	leave  
  802f0e:	c3                   	ret    
  802f0f:	90                   	nop

00802f10 <__udivdi3>:
  802f10:	55                   	push   %ebp
  802f11:	57                   	push   %edi
  802f12:	56                   	push   %esi
  802f13:	53                   	push   %ebx
  802f14:	83 ec 1c             	sub    $0x1c,%esp
  802f17:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  802f1b:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  802f1f:	8b 7c 24 38          	mov    0x38(%esp),%edi
  802f23:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  802f27:	89 ca                	mov    %ecx,%edx
  802f29:	89 f8                	mov    %edi,%eax
  802f2b:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  802f2f:	85 f6                	test   %esi,%esi
  802f31:	75 2d                	jne    802f60 <__udivdi3+0x50>
  802f33:	39 cf                	cmp    %ecx,%edi
  802f35:	77 65                	ja     802f9c <__udivdi3+0x8c>
  802f37:	89 fd                	mov    %edi,%ebp
  802f39:	85 ff                	test   %edi,%edi
  802f3b:	75 0b                	jne    802f48 <__udivdi3+0x38>
  802f3d:	b8 01 00 00 00       	mov    $0x1,%eax
  802f42:	31 d2                	xor    %edx,%edx
  802f44:	f7 f7                	div    %edi
  802f46:	89 c5                	mov    %eax,%ebp
  802f48:	31 d2                	xor    %edx,%edx
  802f4a:	89 c8                	mov    %ecx,%eax
  802f4c:	f7 f5                	div    %ebp
  802f4e:	89 c1                	mov    %eax,%ecx
  802f50:	89 d8                	mov    %ebx,%eax
  802f52:	f7 f5                	div    %ebp
  802f54:	89 cf                	mov    %ecx,%edi
  802f56:	89 fa                	mov    %edi,%edx
  802f58:	83 c4 1c             	add    $0x1c,%esp
  802f5b:	5b                   	pop    %ebx
  802f5c:	5e                   	pop    %esi
  802f5d:	5f                   	pop    %edi
  802f5e:	5d                   	pop    %ebp
  802f5f:	c3                   	ret    
  802f60:	39 ce                	cmp    %ecx,%esi
  802f62:	77 28                	ja     802f8c <__udivdi3+0x7c>
  802f64:	0f bd fe             	bsr    %esi,%edi
  802f67:	83 f7 1f             	xor    $0x1f,%edi
  802f6a:	75 40                	jne    802fac <__udivdi3+0x9c>
  802f6c:	39 ce                	cmp    %ecx,%esi
  802f6e:	72 0a                	jb     802f7a <__udivdi3+0x6a>
  802f70:	3b 44 24 08          	cmp    0x8(%esp),%eax
  802f74:	0f 87 9e 00 00 00    	ja     803018 <__udivdi3+0x108>
  802f7a:	b8 01 00 00 00       	mov    $0x1,%eax
  802f7f:	89 fa                	mov    %edi,%edx
  802f81:	83 c4 1c             	add    $0x1c,%esp
  802f84:	5b                   	pop    %ebx
  802f85:	5e                   	pop    %esi
  802f86:	5f                   	pop    %edi
  802f87:	5d                   	pop    %ebp
  802f88:	c3                   	ret    
  802f89:	8d 76 00             	lea    0x0(%esi),%esi
  802f8c:	31 ff                	xor    %edi,%edi
  802f8e:	31 c0                	xor    %eax,%eax
  802f90:	89 fa                	mov    %edi,%edx
  802f92:	83 c4 1c             	add    $0x1c,%esp
  802f95:	5b                   	pop    %ebx
  802f96:	5e                   	pop    %esi
  802f97:	5f                   	pop    %edi
  802f98:	5d                   	pop    %ebp
  802f99:	c3                   	ret    
  802f9a:	66 90                	xchg   %ax,%ax
  802f9c:	89 d8                	mov    %ebx,%eax
  802f9e:	f7 f7                	div    %edi
  802fa0:	31 ff                	xor    %edi,%edi
  802fa2:	89 fa                	mov    %edi,%edx
  802fa4:	83 c4 1c             	add    $0x1c,%esp
  802fa7:	5b                   	pop    %ebx
  802fa8:	5e                   	pop    %esi
  802fa9:	5f                   	pop    %edi
  802faa:	5d                   	pop    %ebp
  802fab:	c3                   	ret    
  802fac:	bd 20 00 00 00       	mov    $0x20,%ebp
  802fb1:	89 eb                	mov    %ebp,%ebx
  802fb3:	29 fb                	sub    %edi,%ebx
  802fb5:	89 f9                	mov    %edi,%ecx
  802fb7:	d3 e6                	shl    %cl,%esi
  802fb9:	89 c5                	mov    %eax,%ebp
  802fbb:	88 d9                	mov    %bl,%cl
  802fbd:	d3 ed                	shr    %cl,%ebp
  802fbf:	89 e9                	mov    %ebp,%ecx
  802fc1:	09 f1                	or     %esi,%ecx
  802fc3:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  802fc7:	89 f9                	mov    %edi,%ecx
  802fc9:	d3 e0                	shl    %cl,%eax
  802fcb:	89 c5                	mov    %eax,%ebp
  802fcd:	89 d6                	mov    %edx,%esi
  802fcf:	88 d9                	mov    %bl,%cl
  802fd1:	d3 ee                	shr    %cl,%esi
  802fd3:	89 f9                	mov    %edi,%ecx
  802fd5:	d3 e2                	shl    %cl,%edx
  802fd7:	8b 44 24 08          	mov    0x8(%esp),%eax
  802fdb:	88 d9                	mov    %bl,%cl
  802fdd:	d3 e8                	shr    %cl,%eax
  802fdf:	09 c2                	or     %eax,%edx
  802fe1:	89 d0                	mov    %edx,%eax
  802fe3:	89 f2                	mov    %esi,%edx
  802fe5:	f7 74 24 0c          	divl   0xc(%esp)
  802fe9:	89 d6                	mov    %edx,%esi
  802feb:	89 c3                	mov    %eax,%ebx
  802fed:	f7 e5                	mul    %ebp
  802fef:	39 d6                	cmp    %edx,%esi
  802ff1:	72 19                	jb     80300c <__udivdi3+0xfc>
  802ff3:	74 0b                	je     803000 <__udivdi3+0xf0>
  802ff5:	89 d8                	mov    %ebx,%eax
  802ff7:	31 ff                	xor    %edi,%edi
  802ff9:	e9 58 ff ff ff       	jmp    802f56 <__udivdi3+0x46>
  802ffe:	66 90                	xchg   %ax,%ax
  803000:	8b 54 24 08          	mov    0x8(%esp),%edx
  803004:	89 f9                	mov    %edi,%ecx
  803006:	d3 e2                	shl    %cl,%edx
  803008:	39 c2                	cmp    %eax,%edx
  80300a:	73 e9                	jae    802ff5 <__udivdi3+0xe5>
  80300c:	8d 43 ff             	lea    -0x1(%ebx),%eax
  80300f:	31 ff                	xor    %edi,%edi
  803011:	e9 40 ff ff ff       	jmp    802f56 <__udivdi3+0x46>
  803016:	66 90                	xchg   %ax,%ax
  803018:	31 c0                	xor    %eax,%eax
  80301a:	e9 37 ff ff ff       	jmp    802f56 <__udivdi3+0x46>
  80301f:	90                   	nop

00803020 <__umoddi3>:
  803020:	55                   	push   %ebp
  803021:	57                   	push   %edi
  803022:	56                   	push   %esi
  803023:	53                   	push   %ebx
  803024:	83 ec 1c             	sub    $0x1c,%esp
  803027:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  80302b:	8b 74 24 34          	mov    0x34(%esp),%esi
  80302f:	8b 7c 24 38          	mov    0x38(%esp),%edi
  803033:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  803037:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80303b:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  80303f:	89 f3                	mov    %esi,%ebx
  803041:	89 fa                	mov    %edi,%edx
  803043:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  803047:	89 34 24             	mov    %esi,(%esp)
  80304a:	85 c0                	test   %eax,%eax
  80304c:	75 1a                	jne    803068 <__umoddi3+0x48>
  80304e:	39 f7                	cmp    %esi,%edi
  803050:	0f 86 a2 00 00 00    	jbe    8030f8 <__umoddi3+0xd8>
  803056:	89 c8                	mov    %ecx,%eax
  803058:	89 f2                	mov    %esi,%edx
  80305a:	f7 f7                	div    %edi
  80305c:	89 d0                	mov    %edx,%eax
  80305e:	31 d2                	xor    %edx,%edx
  803060:	83 c4 1c             	add    $0x1c,%esp
  803063:	5b                   	pop    %ebx
  803064:	5e                   	pop    %esi
  803065:	5f                   	pop    %edi
  803066:	5d                   	pop    %ebp
  803067:	c3                   	ret    
  803068:	39 f0                	cmp    %esi,%eax
  80306a:	0f 87 ac 00 00 00    	ja     80311c <__umoddi3+0xfc>
  803070:	0f bd e8             	bsr    %eax,%ebp
  803073:	83 f5 1f             	xor    $0x1f,%ebp
  803076:	0f 84 ac 00 00 00    	je     803128 <__umoddi3+0x108>
  80307c:	bf 20 00 00 00       	mov    $0x20,%edi
  803081:	29 ef                	sub    %ebp,%edi
  803083:	89 fe                	mov    %edi,%esi
  803085:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  803089:	89 e9                	mov    %ebp,%ecx
  80308b:	d3 e0                	shl    %cl,%eax
  80308d:	89 d7                	mov    %edx,%edi
  80308f:	89 f1                	mov    %esi,%ecx
  803091:	d3 ef                	shr    %cl,%edi
  803093:	09 c7                	or     %eax,%edi
  803095:	89 e9                	mov    %ebp,%ecx
  803097:	d3 e2                	shl    %cl,%edx
  803099:	89 14 24             	mov    %edx,(%esp)
  80309c:	89 d8                	mov    %ebx,%eax
  80309e:	d3 e0                	shl    %cl,%eax
  8030a0:	89 c2                	mov    %eax,%edx
  8030a2:	8b 44 24 08          	mov    0x8(%esp),%eax
  8030a6:	d3 e0                	shl    %cl,%eax
  8030a8:	89 44 24 04          	mov    %eax,0x4(%esp)
  8030ac:	8b 44 24 08          	mov    0x8(%esp),%eax
  8030b0:	89 f1                	mov    %esi,%ecx
  8030b2:	d3 e8                	shr    %cl,%eax
  8030b4:	09 d0                	or     %edx,%eax
  8030b6:	d3 eb                	shr    %cl,%ebx
  8030b8:	89 da                	mov    %ebx,%edx
  8030ba:	f7 f7                	div    %edi
  8030bc:	89 d3                	mov    %edx,%ebx
  8030be:	f7 24 24             	mull   (%esp)
  8030c1:	89 c6                	mov    %eax,%esi
  8030c3:	89 d1                	mov    %edx,%ecx
  8030c5:	39 d3                	cmp    %edx,%ebx
  8030c7:	0f 82 87 00 00 00    	jb     803154 <__umoddi3+0x134>
  8030cd:	0f 84 91 00 00 00    	je     803164 <__umoddi3+0x144>
  8030d3:	8b 54 24 04          	mov    0x4(%esp),%edx
  8030d7:	29 f2                	sub    %esi,%edx
  8030d9:	19 cb                	sbb    %ecx,%ebx
  8030db:	89 d8                	mov    %ebx,%eax
  8030dd:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  8030e1:	d3 e0                	shl    %cl,%eax
  8030e3:	89 e9                	mov    %ebp,%ecx
  8030e5:	d3 ea                	shr    %cl,%edx
  8030e7:	09 d0                	or     %edx,%eax
  8030e9:	89 e9                	mov    %ebp,%ecx
  8030eb:	d3 eb                	shr    %cl,%ebx
  8030ed:	89 da                	mov    %ebx,%edx
  8030ef:	83 c4 1c             	add    $0x1c,%esp
  8030f2:	5b                   	pop    %ebx
  8030f3:	5e                   	pop    %esi
  8030f4:	5f                   	pop    %edi
  8030f5:	5d                   	pop    %ebp
  8030f6:	c3                   	ret    
  8030f7:	90                   	nop
  8030f8:	89 fd                	mov    %edi,%ebp
  8030fa:	85 ff                	test   %edi,%edi
  8030fc:	75 0b                	jne    803109 <__umoddi3+0xe9>
  8030fe:	b8 01 00 00 00       	mov    $0x1,%eax
  803103:	31 d2                	xor    %edx,%edx
  803105:	f7 f7                	div    %edi
  803107:	89 c5                	mov    %eax,%ebp
  803109:	89 f0                	mov    %esi,%eax
  80310b:	31 d2                	xor    %edx,%edx
  80310d:	f7 f5                	div    %ebp
  80310f:	89 c8                	mov    %ecx,%eax
  803111:	f7 f5                	div    %ebp
  803113:	89 d0                	mov    %edx,%eax
  803115:	e9 44 ff ff ff       	jmp    80305e <__umoddi3+0x3e>
  80311a:	66 90                	xchg   %ax,%ax
  80311c:	89 c8                	mov    %ecx,%eax
  80311e:	89 f2                	mov    %esi,%edx
  803120:	83 c4 1c             	add    $0x1c,%esp
  803123:	5b                   	pop    %ebx
  803124:	5e                   	pop    %esi
  803125:	5f                   	pop    %edi
  803126:	5d                   	pop    %ebp
  803127:	c3                   	ret    
  803128:	3b 04 24             	cmp    (%esp),%eax
  80312b:	72 06                	jb     803133 <__umoddi3+0x113>
  80312d:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  803131:	77 0f                	ja     803142 <__umoddi3+0x122>
  803133:	89 f2                	mov    %esi,%edx
  803135:	29 f9                	sub    %edi,%ecx
  803137:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  80313b:	89 14 24             	mov    %edx,(%esp)
  80313e:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  803142:	8b 44 24 04          	mov    0x4(%esp),%eax
  803146:	8b 14 24             	mov    (%esp),%edx
  803149:	83 c4 1c             	add    $0x1c,%esp
  80314c:	5b                   	pop    %ebx
  80314d:	5e                   	pop    %esi
  80314e:	5f                   	pop    %edi
  80314f:	5d                   	pop    %ebp
  803150:	c3                   	ret    
  803151:	8d 76 00             	lea    0x0(%esi),%esi
  803154:	2b 04 24             	sub    (%esp),%eax
  803157:	19 fa                	sbb    %edi,%edx
  803159:	89 d1                	mov    %edx,%ecx
  80315b:	89 c6                	mov    %eax,%esi
  80315d:	e9 71 ff ff ff       	jmp    8030d3 <__umoddi3+0xb3>
  803162:	66 90                	xchg   %ax,%ax
  803164:	39 44 24 04          	cmp    %eax,0x4(%esp)
  803168:	72 ea                	jb     803154 <__umoddi3+0x134>
  80316a:	89 d9                	mov    %ebx,%ecx
  80316c:	e9 62 ff ff ff       	jmp    8030d3 <__umoddi3+0xb3>
