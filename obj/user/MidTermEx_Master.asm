
obj/user/MidTermEx_Master:     file format elf32-i386


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
  800031:	e8 14 02 00 00       	call   80024a <libmain>
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
  800045:	68 e0 31 80 00       	push   $0x8031e0
  80004a:	e8 e5 14 00 00       	call   801534 <smalloc>
  80004f:	83 c4 10             	add    $0x10,%esp
  800052:	89 45 f4             	mov    %eax,-0xc(%ebp)
	*X = 5 ;
  800055:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800058:	c7 00 05 00 00 00    	movl   $0x5,(%eax)

	/*[2] SPECIFY WHETHER TO USE SEMAPHORE OR NOT*/
	cprintf("Do you want to use semaphore (y/n)? ") ;
  80005e:	83 ec 0c             	sub    $0xc,%esp
  800061:	68 e4 31 80 00       	push   $0x8031e4
  800066:	e8 ef 03 00 00       	call   80045a <cprintf>
  80006b:	83 c4 10             	add    $0x10,%esp
	char select = getchar() ;
  80006e:	e8 7f 01 00 00       	call   8001f2 <getchar>
  800073:	88 45 f3             	mov    %al,-0xd(%ebp)
	cputchar(select);
  800076:	0f be 45 f3          	movsbl -0xd(%ebp),%eax
  80007a:	83 ec 0c             	sub    $0xc,%esp
  80007d:	50                   	push   %eax
  80007e:	e8 27 01 00 00       	call   8001aa <cputchar>
  800083:	83 c4 10             	add    $0x10,%esp
	cputchar('\n');
  800086:	83 ec 0c             	sub    $0xc,%esp
  800089:	6a 0a                	push   $0xa
  80008b:	e8 1a 01 00 00       	call   8001aa <cputchar>
  800090:	83 c4 10             	add    $0x10,%esp

	/*[3] SHARE THIS SELECTION WITH OTHER PROCESSES*/
	int *useSem = smalloc("useSem", sizeof(int) , 0) ;
  800093:	83 ec 04             	sub    $0x4,%esp
  800096:	6a 00                	push   $0x0
  800098:	6a 04                	push   $0x4
  80009a:	68 09 32 80 00       	push   $0x803209
  80009f:	e8 90 14 00 00       	call   801534 <smalloc>
  8000a4:	83 c4 10             	add    $0x10,%esp
  8000a7:	89 45 ec             	mov    %eax,-0x14(%ebp)
	*useSem = 0 ;
  8000aa:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8000ad:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	if (select == 'Y' || select == 'y')
  8000b3:	80 7d f3 59          	cmpb   $0x59,-0xd(%ebp)
  8000b7:	74 06                	je     8000bf <_main+0x87>
  8000b9:	80 7d f3 79          	cmpb   $0x79,-0xd(%ebp)
  8000bd:	75 09                	jne    8000c8 <_main+0x90>
		*useSem = 1 ;
  8000bf:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8000c2:	c7 00 01 00 00 00    	movl   $0x1,(%eax)

	if (*useSem == 1)
  8000c8:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8000cb:	8b 00                	mov    (%eax),%eax
  8000cd:	83 f8 01             	cmp    $0x1,%eax
  8000d0:	75 12                	jne    8000e4 <_main+0xac>
	{
		sys_createSemaphore("T", 0);
  8000d2:	83 ec 08             	sub    $0x8,%esp
  8000d5:	6a 00                	push   $0x0
  8000d7:	68 10 32 80 00       	push   $0x803210
  8000dc:	e8 78 18 00 00       	call   801959 <sys_createSemaphore>
  8000e1:	83 c4 10             	add    $0x10,%esp
	}

	/*[4] CREATE AND RUN ProcessA & ProcessB*/

	//Create the check-finishing counter
	int *numOfFinished = smalloc("finishedCount", sizeof(int), 1) ;
  8000e4:	83 ec 04             	sub    $0x4,%esp
  8000e7:	6a 01                	push   $0x1
  8000e9:	6a 04                	push   $0x4
  8000eb:	68 12 32 80 00       	push   $0x803212
  8000f0:	e8 3f 14 00 00       	call   801534 <smalloc>
  8000f5:	83 c4 10             	add    $0x10,%esp
  8000f8:	89 45 e8             	mov    %eax,-0x18(%ebp)
	*numOfFinished = 0 ;
  8000fb:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8000fe:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

	//Create the 2 processes
	int32 envIdProcessA = sys_create_env("midterm_a", (myEnv->page_WS_max_size),(myEnv->SecondListSize), (myEnv->percentage_of_WS_pages_to_be_removed));
  800104:	a1 20 40 80 00       	mov    0x804020,%eax
  800109:	8b 90 a0 05 00 00    	mov    0x5a0(%eax),%edx
  80010f:	a1 20 40 80 00       	mov    0x804020,%eax
  800114:	8b 80 ec 05 00 00    	mov    0x5ec(%eax),%eax
  80011a:	89 c1                	mov    %eax,%ecx
  80011c:	a1 20 40 80 00       	mov    0x804020,%eax
  800121:	8b 40 74             	mov    0x74(%eax),%eax
  800124:	52                   	push   %edx
  800125:	51                   	push   %ecx
  800126:	50                   	push   %eax
  800127:	68 20 32 80 00       	push   $0x803220
  80012c:	e8 39 19 00 00       	call   801a6a <sys_create_env>
  800131:	83 c4 10             	add    $0x10,%esp
  800134:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	int32 envIdProcessB = sys_create_env("midterm_b", (myEnv->page_WS_max_size), (myEnv->SecondListSize),(myEnv->percentage_of_WS_pages_to_be_removed));
  800137:	a1 20 40 80 00       	mov    0x804020,%eax
  80013c:	8b 90 a0 05 00 00    	mov    0x5a0(%eax),%edx
  800142:	a1 20 40 80 00       	mov    0x804020,%eax
  800147:	8b 80 ec 05 00 00    	mov    0x5ec(%eax),%eax
  80014d:	89 c1                	mov    %eax,%ecx
  80014f:	a1 20 40 80 00       	mov    0x804020,%eax
  800154:	8b 40 74             	mov    0x74(%eax),%eax
  800157:	52                   	push   %edx
  800158:	51                   	push   %ecx
  800159:	50                   	push   %eax
  80015a:	68 2a 32 80 00       	push   $0x80322a
  80015f:	e8 06 19 00 00       	call   801a6a <sys_create_env>
  800164:	83 c4 10             	add    $0x10,%esp
  800167:	89 45 e0             	mov    %eax,-0x20(%ebp)

	//Run the 2 processes
	sys_run_env(envIdProcessA);
  80016a:	83 ec 0c             	sub    $0xc,%esp
  80016d:	ff 75 e4             	pushl  -0x1c(%ebp)
  800170:	e8 13 19 00 00       	call   801a88 <sys_run_env>
  800175:	83 c4 10             	add    $0x10,%esp
	sys_run_env(envIdProcessB);
  800178:	83 ec 0c             	sub    $0xc,%esp
  80017b:	ff 75 e0             	pushl  -0x20(%ebp)
  80017e:	e8 05 19 00 00       	call   801a88 <sys_run_env>
  800183:	83 c4 10             	add    $0x10,%esp

	/*[5] BUSY-WAIT TILL FINISHING BOTH PROCESSES*/
	while (*numOfFinished != 2) ;
  800186:	90                   	nop
  800187:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80018a:	8b 00                	mov    (%eax),%eax
  80018c:	83 f8 02             	cmp    $0x2,%eax
  80018f:	75 f6                	jne    800187 <_main+0x14f>

	/*[6] PRINT X*/
	cprintf("Final value of X = %d\n", *X);
  800191:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800194:	8b 00                	mov    (%eax),%eax
  800196:	83 ec 08             	sub    $0x8,%esp
  800199:	50                   	push   %eax
  80019a:	68 34 32 80 00       	push   $0x803234
  80019f:	e8 b6 02 00 00       	call   80045a <cprintf>
  8001a4:	83 c4 10             	add    $0x10,%esp

	return;
  8001a7:	90                   	nop
}
  8001a8:	c9                   	leave  
  8001a9:	c3                   	ret    

008001aa <cputchar>:
#include <inc/lib.h>


void
cputchar(int ch)
{
  8001aa:	55                   	push   %ebp
  8001ab:	89 e5                	mov    %esp,%ebp
  8001ad:	83 ec 18             	sub    $0x18,%esp
	char c = ch;
  8001b0:	8b 45 08             	mov    0x8(%ebp),%eax
  8001b3:	88 45 f7             	mov    %al,-0x9(%ebp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	//sys_cputs(&c, 1);

	sys_cputc(c);
  8001b6:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
  8001ba:	83 ec 0c             	sub    $0xc,%esp
  8001bd:	50                   	push   %eax
  8001be:	e8 56 17 00 00       	call   801919 <sys_cputc>
  8001c3:	83 c4 10             	add    $0x10,%esp
}
  8001c6:	90                   	nop
  8001c7:	c9                   	leave  
  8001c8:	c3                   	ret    

008001c9 <atomic_cputchar>:


void
atomic_cputchar(int ch)
{
  8001c9:	55                   	push   %ebp
  8001ca:	89 e5                	mov    %esp,%ebp
  8001cc:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  8001cf:	e8 11 17 00 00       	call   8018e5 <sys_disable_interrupt>
	char c = ch;
  8001d4:	8b 45 08             	mov    0x8(%ebp),%eax
  8001d7:	88 45 f7             	mov    %al,-0x9(%ebp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	//sys_cputs(&c, 1);

	sys_cputc(c);
  8001da:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
  8001de:	83 ec 0c             	sub    $0xc,%esp
  8001e1:	50                   	push   %eax
  8001e2:	e8 32 17 00 00       	call   801919 <sys_cputc>
  8001e7:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  8001ea:	e8 10 17 00 00       	call   8018ff <sys_enable_interrupt>
}
  8001ef:	90                   	nop
  8001f0:	c9                   	leave  
  8001f1:	c3                   	ret    

008001f2 <getchar>:

int
getchar(void)
{
  8001f2:	55                   	push   %ebp
  8001f3:	89 e5                	mov    %esp,%ebp
  8001f5:	83 ec 18             	sub    $0x18,%esp

	//return sys_cgetc();
	int c=0;
  8001f8:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	while(c == 0)
  8001ff:	eb 08                	jmp    800209 <getchar+0x17>
	{
		c = sys_cgetc();
  800201:	e8 5a 15 00 00       	call   801760 <sys_cgetc>
  800206:	89 45 f4             	mov    %eax,-0xc(%ebp)
getchar(void)
{

	//return sys_cgetc();
	int c=0;
	while(c == 0)
  800209:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80020d:	74 f2                	je     800201 <getchar+0xf>
	{
		c = sys_cgetc();
	}
	return c;
  80020f:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  800212:	c9                   	leave  
  800213:	c3                   	ret    

00800214 <atomic_getchar>:

int
atomic_getchar(void)
{
  800214:	55                   	push   %ebp
  800215:	89 e5                	mov    %esp,%ebp
  800217:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  80021a:	e8 c6 16 00 00       	call   8018e5 <sys_disable_interrupt>
	int c=0;
  80021f:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	while(c == 0)
  800226:	eb 08                	jmp    800230 <atomic_getchar+0x1c>
	{
		c = sys_cgetc();
  800228:	e8 33 15 00 00       	call   801760 <sys_cgetc>
  80022d:	89 45 f4             	mov    %eax,-0xc(%ebp)
int
atomic_getchar(void)
{
	sys_disable_interrupt();
	int c=0;
	while(c == 0)
  800230:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  800234:	74 f2                	je     800228 <atomic_getchar+0x14>
	{
		c = sys_cgetc();
	}
	sys_enable_interrupt();
  800236:	e8 c4 16 00 00       	call   8018ff <sys_enable_interrupt>
	return c;
  80023b:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  80023e:	c9                   	leave  
  80023f:	c3                   	ret    

00800240 <iscons>:

int iscons(int fdnum)
{
  800240:	55                   	push   %ebp
  800241:	89 e5                	mov    %esp,%ebp
	// used by readline
	return 1;
  800243:	b8 01 00 00 00       	mov    $0x1,%eax
}
  800248:	5d                   	pop    %ebp
  800249:	c3                   	ret    

0080024a <libmain>:
volatile struct Env *myEnv = NULL;
volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";

void
libmain(int argc, char **argv)
{
  80024a:	55                   	push   %ebp
  80024b:	89 e5                	mov    %esp,%ebp
  80024d:	83 ec 18             	sub    $0x18,%esp
	int envIndex = sys_getenvindex();
  800250:	e8 83 18 00 00       	call   801ad8 <sys_getenvindex>
  800255:	89 45 f4             	mov    %eax,-0xc(%ebp)
	myEnv = &(envs[envIndex]);
  800258:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80025b:	89 d0                	mov    %edx,%eax
  80025d:	c1 e0 03             	shl    $0x3,%eax
  800260:	01 d0                	add    %edx,%eax
  800262:	01 c0                	add    %eax,%eax
  800264:	01 d0                	add    %edx,%eax
  800266:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80026d:	01 d0                	add    %edx,%eax
  80026f:	c1 e0 04             	shl    $0x4,%eax
  800272:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  800277:	a3 20 40 80 00       	mov    %eax,0x804020

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  80027c:	a1 20 40 80 00       	mov    0x804020,%eax
  800281:	8a 80 5c 05 00 00    	mov    0x55c(%eax),%al
  800287:	84 c0                	test   %al,%al
  800289:	74 0f                	je     80029a <libmain+0x50>
		binaryname = myEnv->prog_name;
  80028b:	a1 20 40 80 00       	mov    0x804020,%eax
  800290:	05 5c 05 00 00       	add    $0x55c,%eax
  800295:	a3 00 40 80 00       	mov    %eax,0x804000

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  80029a:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80029e:	7e 0a                	jle    8002aa <libmain+0x60>
		binaryname = argv[0];
  8002a0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8002a3:	8b 00                	mov    (%eax),%eax
  8002a5:	a3 00 40 80 00       	mov    %eax,0x804000

	// call user main routine
	_main(argc, argv);
  8002aa:	83 ec 08             	sub    $0x8,%esp
  8002ad:	ff 75 0c             	pushl  0xc(%ebp)
  8002b0:	ff 75 08             	pushl  0x8(%ebp)
  8002b3:	e8 80 fd ff ff       	call   800038 <_main>
  8002b8:	83 c4 10             	add    $0x10,%esp



	sys_disable_interrupt();
  8002bb:	e8 25 16 00 00       	call   8018e5 <sys_disable_interrupt>
	cprintf("**************************************\n");
  8002c0:	83 ec 0c             	sub    $0xc,%esp
  8002c3:	68 64 32 80 00       	push   $0x803264
  8002c8:	e8 8d 01 00 00       	call   80045a <cprintf>
  8002cd:	83 c4 10             	add    $0x10,%esp
	cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  8002d0:	a1 20 40 80 00       	mov    0x804020,%eax
  8002d5:	8b 90 44 05 00 00    	mov    0x544(%eax),%edx
  8002db:	a1 20 40 80 00       	mov    0x804020,%eax
  8002e0:	8b 80 34 05 00 00    	mov    0x534(%eax),%eax
  8002e6:	83 ec 04             	sub    $0x4,%esp
  8002e9:	52                   	push   %edx
  8002ea:	50                   	push   %eax
  8002eb:	68 8c 32 80 00       	push   $0x80328c
  8002f0:	e8 65 01 00 00       	call   80045a <cprintf>
  8002f5:	83 c4 10             	add    $0x10,%esp
	cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  8002f8:	a1 20 40 80 00       	mov    0x804020,%eax
  8002fd:	8b 88 54 05 00 00    	mov    0x554(%eax),%ecx
  800303:	a1 20 40 80 00       	mov    0x804020,%eax
  800308:	8b 90 50 05 00 00    	mov    0x550(%eax),%edx
  80030e:	a1 20 40 80 00       	mov    0x804020,%eax
  800313:	8b 80 4c 05 00 00    	mov    0x54c(%eax),%eax
  800319:	51                   	push   %ecx
  80031a:	52                   	push   %edx
  80031b:	50                   	push   %eax
  80031c:	68 b4 32 80 00       	push   $0x8032b4
  800321:	e8 34 01 00 00       	call   80045a <cprintf>
  800326:	83 c4 10             	add    $0x10,%esp
	//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
	cprintf("Num of clocks = %d\n", myEnv->nClocks);
  800329:	a1 20 40 80 00       	mov    0x804020,%eax
  80032e:	8b 80 a4 05 00 00    	mov    0x5a4(%eax),%eax
  800334:	83 ec 08             	sub    $0x8,%esp
  800337:	50                   	push   %eax
  800338:	68 0c 33 80 00       	push   $0x80330c
  80033d:	e8 18 01 00 00       	call   80045a <cprintf>
  800342:	83 c4 10             	add    $0x10,%esp
	cprintf("**************************************\n");
  800345:	83 ec 0c             	sub    $0xc,%esp
  800348:	68 64 32 80 00       	push   $0x803264
  80034d:	e8 08 01 00 00       	call   80045a <cprintf>
  800352:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  800355:	e8 a5 15 00 00       	call   8018ff <sys_enable_interrupt>

	// exit gracefully
	exit();
  80035a:	e8 19 00 00 00       	call   800378 <exit>
}
  80035f:	90                   	nop
  800360:	c9                   	leave  
  800361:	c3                   	ret    

00800362 <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  800362:	55                   	push   %ebp
  800363:	89 e5                	mov    %esp,%ebp
  800365:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  800368:	83 ec 0c             	sub    $0xc,%esp
  80036b:	6a 00                	push   $0x0
  80036d:	e8 32 17 00 00       	call   801aa4 <sys_destroy_env>
  800372:	83 c4 10             	add    $0x10,%esp
}
  800375:	90                   	nop
  800376:	c9                   	leave  
  800377:	c3                   	ret    

00800378 <exit>:

void
exit(void)
{
  800378:	55                   	push   %ebp
  800379:	89 e5                	mov    %esp,%ebp
  80037b:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  80037e:	e8 87 17 00 00       	call   801b0a <sys_exit_env>
}
  800383:	90                   	nop
  800384:	c9                   	leave  
  800385:	c3                   	ret    

00800386 <putch>:
};

//2017:
uint8 printProgName = 0;

static void putch(int ch, struct printbuf *b) {
  800386:	55                   	push   %ebp
  800387:	89 e5                	mov    %esp,%ebp
  800389:	83 ec 08             	sub    $0x8,%esp
	b->buf[b->idx++] = ch;
  80038c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80038f:	8b 00                	mov    (%eax),%eax
  800391:	8d 48 01             	lea    0x1(%eax),%ecx
  800394:	8b 55 0c             	mov    0xc(%ebp),%edx
  800397:	89 0a                	mov    %ecx,(%edx)
  800399:	8b 55 08             	mov    0x8(%ebp),%edx
  80039c:	88 d1                	mov    %dl,%cl
  80039e:	8b 55 0c             	mov    0xc(%ebp),%edx
  8003a1:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  8003a5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8003a8:	8b 00                	mov    (%eax),%eax
  8003aa:	3d ff 00 00 00       	cmp    $0xff,%eax
  8003af:	75 2c                	jne    8003dd <putch+0x57>
		sys_cputs(b->buf, b->idx, printProgName);
  8003b1:	a0 24 40 80 00       	mov    0x804024,%al
  8003b6:	0f b6 c0             	movzbl %al,%eax
  8003b9:	8b 55 0c             	mov    0xc(%ebp),%edx
  8003bc:	8b 12                	mov    (%edx),%edx
  8003be:	89 d1                	mov    %edx,%ecx
  8003c0:	8b 55 0c             	mov    0xc(%ebp),%edx
  8003c3:	83 c2 08             	add    $0x8,%edx
  8003c6:	83 ec 04             	sub    $0x4,%esp
  8003c9:	50                   	push   %eax
  8003ca:	51                   	push   %ecx
  8003cb:	52                   	push   %edx
  8003cc:	e8 66 13 00 00       	call   801737 <sys_cputs>
  8003d1:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  8003d4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8003d7:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  8003dd:	8b 45 0c             	mov    0xc(%ebp),%eax
  8003e0:	8b 40 04             	mov    0x4(%eax),%eax
  8003e3:	8d 50 01             	lea    0x1(%eax),%edx
  8003e6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8003e9:	89 50 04             	mov    %edx,0x4(%eax)
}
  8003ec:	90                   	nop
  8003ed:	c9                   	leave  
  8003ee:	c3                   	ret    

008003ef <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  8003ef:	55                   	push   %ebp
  8003f0:	89 e5                	mov    %esp,%ebp
  8003f2:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  8003f8:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  8003ff:	00 00 00 
	b.cnt = 0;
  800402:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800409:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  80040c:	ff 75 0c             	pushl  0xc(%ebp)
  80040f:	ff 75 08             	pushl  0x8(%ebp)
  800412:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800418:	50                   	push   %eax
  800419:	68 86 03 80 00       	push   $0x800386
  80041e:	e8 11 02 00 00       	call   800634 <vprintfmt>
  800423:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName);
  800426:	a0 24 40 80 00       	mov    0x804024,%al
  80042b:	0f b6 c0             	movzbl %al,%eax
  80042e:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  800434:	83 ec 04             	sub    $0x4,%esp
  800437:	50                   	push   %eax
  800438:	52                   	push   %edx
  800439:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  80043f:	83 c0 08             	add    $0x8,%eax
  800442:	50                   	push   %eax
  800443:	e8 ef 12 00 00       	call   801737 <sys_cputs>
  800448:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  80044b:	c6 05 24 40 80 00 00 	movb   $0x0,0x804024
	return b.cnt;
  800452:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  800458:	c9                   	leave  
  800459:	c3                   	ret    

0080045a <cprintf>:

int cprintf(const char *fmt, ...) {
  80045a:	55                   	push   %ebp
  80045b:	89 e5                	mov    %esp,%ebp
  80045d:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  800460:	c6 05 24 40 80 00 01 	movb   $0x1,0x804024
	va_start(ap, fmt);
  800467:	8d 45 0c             	lea    0xc(%ebp),%eax
  80046a:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  80046d:	8b 45 08             	mov    0x8(%ebp),%eax
  800470:	83 ec 08             	sub    $0x8,%esp
  800473:	ff 75 f4             	pushl  -0xc(%ebp)
  800476:	50                   	push   %eax
  800477:	e8 73 ff ff ff       	call   8003ef <vcprintf>
  80047c:	83 c4 10             	add    $0x10,%esp
  80047f:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  800482:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800485:	c9                   	leave  
  800486:	c3                   	ret    

00800487 <atomic_cprintf>:

int atomic_cprintf(const char *fmt, ...) {
  800487:	55                   	push   %ebp
  800488:	89 e5                	mov    %esp,%ebp
  80048a:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  80048d:	e8 53 14 00 00       	call   8018e5 <sys_disable_interrupt>
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  800492:	8d 45 0c             	lea    0xc(%ebp),%eax
  800495:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800498:	8b 45 08             	mov    0x8(%ebp),%eax
  80049b:	83 ec 08             	sub    $0x8,%esp
  80049e:	ff 75 f4             	pushl  -0xc(%ebp)
  8004a1:	50                   	push   %eax
  8004a2:	e8 48 ff ff ff       	call   8003ef <vcprintf>
  8004a7:	83 c4 10             	add    $0x10,%esp
  8004aa:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	sys_enable_interrupt();
  8004ad:	e8 4d 14 00 00       	call   8018ff <sys_enable_interrupt>
	return cnt;
  8004b2:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8004b5:	c9                   	leave  
  8004b6:	c3                   	ret    

008004b7 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8004b7:	55                   	push   %ebp
  8004b8:	89 e5                	mov    %esp,%ebp
  8004ba:	53                   	push   %ebx
  8004bb:	83 ec 14             	sub    $0x14,%esp
  8004be:	8b 45 10             	mov    0x10(%ebp),%eax
  8004c1:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8004c4:	8b 45 14             	mov    0x14(%ebp),%eax
  8004c7:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  8004ca:	8b 45 18             	mov    0x18(%ebp),%eax
  8004cd:	ba 00 00 00 00       	mov    $0x0,%edx
  8004d2:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  8004d5:	77 55                	ja     80052c <printnum+0x75>
  8004d7:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  8004da:	72 05                	jb     8004e1 <printnum+0x2a>
  8004dc:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8004df:	77 4b                	ja     80052c <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  8004e1:	8b 45 1c             	mov    0x1c(%ebp),%eax
  8004e4:	8d 58 ff             	lea    -0x1(%eax),%ebx
  8004e7:	8b 45 18             	mov    0x18(%ebp),%eax
  8004ea:	ba 00 00 00 00       	mov    $0x0,%edx
  8004ef:	52                   	push   %edx
  8004f0:	50                   	push   %eax
  8004f1:	ff 75 f4             	pushl  -0xc(%ebp)
  8004f4:	ff 75 f0             	pushl  -0x10(%ebp)
  8004f7:	e8 64 2a 00 00       	call   802f60 <__udivdi3>
  8004fc:	83 c4 10             	add    $0x10,%esp
  8004ff:	83 ec 04             	sub    $0x4,%esp
  800502:	ff 75 20             	pushl  0x20(%ebp)
  800505:	53                   	push   %ebx
  800506:	ff 75 18             	pushl  0x18(%ebp)
  800509:	52                   	push   %edx
  80050a:	50                   	push   %eax
  80050b:	ff 75 0c             	pushl  0xc(%ebp)
  80050e:	ff 75 08             	pushl  0x8(%ebp)
  800511:	e8 a1 ff ff ff       	call   8004b7 <printnum>
  800516:	83 c4 20             	add    $0x20,%esp
  800519:	eb 1a                	jmp    800535 <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  80051b:	83 ec 08             	sub    $0x8,%esp
  80051e:	ff 75 0c             	pushl  0xc(%ebp)
  800521:	ff 75 20             	pushl  0x20(%ebp)
  800524:	8b 45 08             	mov    0x8(%ebp),%eax
  800527:	ff d0                	call   *%eax
  800529:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  80052c:	ff 4d 1c             	decl   0x1c(%ebp)
  80052f:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  800533:	7f e6                	jg     80051b <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800535:	8b 4d 18             	mov    0x18(%ebp),%ecx
  800538:	bb 00 00 00 00       	mov    $0x0,%ebx
  80053d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800540:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800543:	53                   	push   %ebx
  800544:	51                   	push   %ecx
  800545:	52                   	push   %edx
  800546:	50                   	push   %eax
  800547:	e8 24 2b 00 00       	call   803070 <__umoddi3>
  80054c:	83 c4 10             	add    $0x10,%esp
  80054f:	05 34 35 80 00       	add    $0x803534,%eax
  800554:	8a 00                	mov    (%eax),%al
  800556:	0f be c0             	movsbl %al,%eax
  800559:	83 ec 08             	sub    $0x8,%esp
  80055c:	ff 75 0c             	pushl  0xc(%ebp)
  80055f:	50                   	push   %eax
  800560:	8b 45 08             	mov    0x8(%ebp),%eax
  800563:	ff d0                	call   *%eax
  800565:	83 c4 10             	add    $0x10,%esp
}
  800568:	90                   	nop
  800569:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80056c:	c9                   	leave  
  80056d:	c3                   	ret    

0080056e <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  80056e:	55                   	push   %ebp
  80056f:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800571:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800575:	7e 1c                	jle    800593 <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  800577:	8b 45 08             	mov    0x8(%ebp),%eax
  80057a:	8b 00                	mov    (%eax),%eax
  80057c:	8d 50 08             	lea    0x8(%eax),%edx
  80057f:	8b 45 08             	mov    0x8(%ebp),%eax
  800582:	89 10                	mov    %edx,(%eax)
  800584:	8b 45 08             	mov    0x8(%ebp),%eax
  800587:	8b 00                	mov    (%eax),%eax
  800589:	83 e8 08             	sub    $0x8,%eax
  80058c:	8b 50 04             	mov    0x4(%eax),%edx
  80058f:	8b 00                	mov    (%eax),%eax
  800591:	eb 40                	jmp    8005d3 <getuint+0x65>
	else if (lflag)
  800593:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800597:	74 1e                	je     8005b7 <getuint+0x49>
		return va_arg(*ap, unsigned long);
  800599:	8b 45 08             	mov    0x8(%ebp),%eax
  80059c:	8b 00                	mov    (%eax),%eax
  80059e:	8d 50 04             	lea    0x4(%eax),%edx
  8005a1:	8b 45 08             	mov    0x8(%ebp),%eax
  8005a4:	89 10                	mov    %edx,(%eax)
  8005a6:	8b 45 08             	mov    0x8(%ebp),%eax
  8005a9:	8b 00                	mov    (%eax),%eax
  8005ab:	83 e8 04             	sub    $0x4,%eax
  8005ae:	8b 00                	mov    (%eax),%eax
  8005b0:	ba 00 00 00 00       	mov    $0x0,%edx
  8005b5:	eb 1c                	jmp    8005d3 <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  8005b7:	8b 45 08             	mov    0x8(%ebp),%eax
  8005ba:	8b 00                	mov    (%eax),%eax
  8005bc:	8d 50 04             	lea    0x4(%eax),%edx
  8005bf:	8b 45 08             	mov    0x8(%ebp),%eax
  8005c2:	89 10                	mov    %edx,(%eax)
  8005c4:	8b 45 08             	mov    0x8(%ebp),%eax
  8005c7:	8b 00                	mov    (%eax),%eax
  8005c9:	83 e8 04             	sub    $0x4,%eax
  8005cc:	8b 00                	mov    (%eax),%eax
  8005ce:	ba 00 00 00 00       	mov    $0x0,%edx
}
  8005d3:	5d                   	pop    %ebp
  8005d4:	c3                   	ret    

008005d5 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  8005d5:	55                   	push   %ebp
  8005d6:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  8005d8:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  8005dc:	7e 1c                	jle    8005fa <getint+0x25>
		return va_arg(*ap, long long);
  8005de:	8b 45 08             	mov    0x8(%ebp),%eax
  8005e1:	8b 00                	mov    (%eax),%eax
  8005e3:	8d 50 08             	lea    0x8(%eax),%edx
  8005e6:	8b 45 08             	mov    0x8(%ebp),%eax
  8005e9:	89 10                	mov    %edx,(%eax)
  8005eb:	8b 45 08             	mov    0x8(%ebp),%eax
  8005ee:	8b 00                	mov    (%eax),%eax
  8005f0:	83 e8 08             	sub    $0x8,%eax
  8005f3:	8b 50 04             	mov    0x4(%eax),%edx
  8005f6:	8b 00                	mov    (%eax),%eax
  8005f8:	eb 38                	jmp    800632 <getint+0x5d>
	else if (lflag)
  8005fa:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8005fe:	74 1a                	je     80061a <getint+0x45>
		return va_arg(*ap, long);
  800600:	8b 45 08             	mov    0x8(%ebp),%eax
  800603:	8b 00                	mov    (%eax),%eax
  800605:	8d 50 04             	lea    0x4(%eax),%edx
  800608:	8b 45 08             	mov    0x8(%ebp),%eax
  80060b:	89 10                	mov    %edx,(%eax)
  80060d:	8b 45 08             	mov    0x8(%ebp),%eax
  800610:	8b 00                	mov    (%eax),%eax
  800612:	83 e8 04             	sub    $0x4,%eax
  800615:	8b 00                	mov    (%eax),%eax
  800617:	99                   	cltd   
  800618:	eb 18                	jmp    800632 <getint+0x5d>
	else
		return va_arg(*ap, int);
  80061a:	8b 45 08             	mov    0x8(%ebp),%eax
  80061d:	8b 00                	mov    (%eax),%eax
  80061f:	8d 50 04             	lea    0x4(%eax),%edx
  800622:	8b 45 08             	mov    0x8(%ebp),%eax
  800625:	89 10                	mov    %edx,(%eax)
  800627:	8b 45 08             	mov    0x8(%ebp),%eax
  80062a:	8b 00                	mov    (%eax),%eax
  80062c:	83 e8 04             	sub    $0x4,%eax
  80062f:	8b 00                	mov    (%eax),%eax
  800631:	99                   	cltd   
}
  800632:	5d                   	pop    %ebp
  800633:	c3                   	ret    

00800634 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  800634:	55                   	push   %ebp
  800635:	89 e5                	mov    %esp,%ebp
  800637:	56                   	push   %esi
  800638:	53                   	push   %ebx
  800639:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  80063c:	eb 17                	jmp    800655 <vprintfmt+0x21>
			if (ch == '\0')
  80063e:	85 db                	test   %ebx,%ebx
  800640:	0f 84 af 03 00 00    	je     8009f5 <vprintfmt+0x3c1>
				return;
			putch(ch, putdat);
  800646:	83 ec 08             	sub    $0x8,%esp
  800649:	ff 75 0c             	pushl  0xc(%ebp)
  80064c:	53                   	push   %ebx
  80064d:	8b 45 08             	mov    0x8(%ebp),%eax
  800650:	ff d0                	call   *%eax
  800652:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800655:	8b 45 10             	mov    0x10(%ebp),%eax
  800658:	8d 50 01             	lea    0x1(%eax),%edx
  80065b:	89 55 10             	mov    %edx,0x10(%ebp)
  80065e:	8a 00                	mov    (%eax),%al
  800660:	0f b6 d8             	movzbl %al,%ebx
  800663:	83 fb 25             	cmp    $0x25,%ebx
  800666:	75 d6                	jne    80063e <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  800668:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  80066c:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  800673:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  80067a:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  800681:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800688:	8b 45 10             	mov    0x10(%ebp),%eax
  80068b:	8d 50 01             	lea    0x1(%eax),%edx
  80068e:	89 55 10             	mov    %edx,0x10(%ebp)
  800691:	8a 00                	mov    (%eax),%al
  800693:	0f b6 d8             	movzbl %al,%ebx
  800696:	8d 43 dd             	lea    -0x23(%ebx),%eax
  800699:	83 f8 55             	cmp    $0x55,%eax
  80069c:	0f 87 2b 03 00 00    	ja     8009cd <vprintfmt+0x399>
  8006a2:	8b 04 85 58 35 80 00 	mov    0x803558(,%eax,4),%eax
  8006a9:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  8006ab:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  8006af:	eb d7                	jmp    800688 <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  8006b1:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  8006b5:	eb d1                	jmp    800688 <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8006b7:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  8006be:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8006c1:	89 d0                	mov    %edx,%eax
  8006c3:	c1 e0 02             	shl    $0x2,%eax
  8006c6:	01 d0                	add    %edx,%eax
  8006c8:	01 c0                	add    %eax,%eax
  8006ca:	01 d8                	add    %ebx,%eax
  8006cc:	83 e8 30             	sub    $0x30,%eax
  8006cf:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  8006d2:	8b 45 10             	mov    0x10(%ebp),%eax
  8006d5:	8a 00                	mov    (%eax),%al
  8006d7:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  8006da:	83 fb 2f             	cmp    $0x2f,%ebx
  8006dd:	7e 3e                	jle    80071d <vprintfmt+0xe9>
  8006df:	83 fb 39             	cmp    $0x39,%ebx
  8006e2:	7f 39                	jg     80071d <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8006e4:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  8006e7:	eb d5                	jmp    8006be <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  8006e9:	8b 45 14             	mov    0x14(%ebp),%eax
  8006ec:	83 c0 04             	add    $0x4,%eax
  8006ef:	89 45 14             	mov    %eax,0x14(%ebp)
  8006f2:	8b 45 14             	mov    0x14(%ebp),%eax
  8006f5:	83 e8 04             	sub    $0x4,%eax
  8006f8:	8b 00                	mov    (%eax),%eax
  8006fa:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  8006fd:	eb 1f                	jmp    80071e <vprintfmt+0xea>

		case '.':
			if (width < 0)
  8006ff:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800703:	79 83                	jns    800688 <vprintfmt+0x54>
				width = 0;
  800705:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  80070c:	e9 77 ff ff ff       	jmp    800688 <vprintfmt+0x54>

		case '#':
			altflag = 1;
  800711:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  800718:	e9 6b ff ff ff       	jmp    800688 <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  80071d:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  80071e:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800722:	0f 89 60 ff ff ff    	jns    800688 <vprintfmt+0x54>
				width = precision, precision = -1;
  800728:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80072b:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  80072e:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  800735:	e9 4e ff ff ff       	jmp    800688 <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  80073a:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  80073d:	e9 46 ff ff ff       	jmp    800688 <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  800742:	8b 45 14             	mov    0x14(%ebp),%eax
  800745:	83 c0 04             	add    $0x4,%eax
  800748:	89 45 14             	mov    %eax,0x14(%ebp)
  80074b:	8b 45 14             	mov    0x14(%ebp),%eax
  80074e:	83 e8 04             	sub    $0x4,%eax
  800751:	8b 00                	mov    (%eax),%eax
  800753:	83 ec 08             	sub    $0x8,%esp
  800756:	ff 75 0c             	pushl  0xc(%ebp)
  800759:	50                   	push   %eax
  80075a:	8b 45 08             	mov    0x8(%ebp),%eax
  80075d:	ff d0                	call   *%eax
  80075f:	83 c4 10             	add    $0x10,%esp
			break;
  800762:	e9 89 02 00 00       	jmp    8009f0 <vprintfmt+0x3bc>

		// error message
		case 'e':
			err = va_arg(ap, int);
  800767:	8b 45 14             	mov    0x14(%ebp),%eax
  80076a:	83 c0 04             	add    $0x4,%eax
  80076d:	89 45 14             	mov    %eax,0x14(%ebp)
  800770:	8b 45 14             	mov    0x14(%ebp),%eax
  800773:	83 e8 04             	sub    $0x4,%eax
  800776:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  800778:	85 db                	test   %ebx,%ebx
  80077a:	79 02                	jns    80077e <vprintfmt+0x14a>
				err = -err;
  80077c:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  80077e:	83 fb 64             	cmp    $0x64,%ebx
  800781:	7f 0b                	jg     80078e <vprintfmt+0x15a>
  800783:	8b 34 9d a0 33 80 00 	mov    0x8033a0(,%ebx,4),%esi
  80078a:	85 f6                	test   %esi,%esi
  80078c:	75 19                	jne    8007a7 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  80078e:	53                   	push   %ebx
  80078f:	68 45 35 80 00       	push   $0x803545
  800794:	ff 75 0c             	pushl  0xc(%ebp)
  800797:	ff 75 08             	pushl  0x8(%ebp)
  80079a:	e8 5e 02 00 00       	call   8009fd <printfmt>
  80079f:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  8007a2:	e9 49 02 00 00       	jmp    8009f0 <vprintfmt+0x3bc>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  8007a7:	56                   	push   %esi
  8007a8:	68 4e 35 80 00       	push   $0x80354e
  8007ad:	ff 75 0c             	pushl  0xc(%ebp)
  8007b0:	ff 75 08             	pushl  0x8(%ebp)
  8007b3:	e8 45 02 00 00       	call   8009fd <printfmt>
  8007b8:	83 c4 10             	add    $0x10,%esp
			break;
  8007bb:	e9 30 02 00 00       	jmp    8009f0 <vprintfmt+0x3bc>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  8007c0:	8b 45 14             	mov    0x14(%ebp),%eax
  8007c3:	83 c0 04             	add    $0x4,%eax
  8007c6:	89 45 14             	mov    %eax,0x14(%ebp)
  8007c9:	8b 45 14             	mov    0x14(%ebp),%eax
  8007cc:	83 e8 04             	sub    $0x4,%eax
  8007cf:	8b 30                	mov    (%eax),%esi
  8007d1:	85 f6                	test   %esi,%esi
  8007d3:	75 05                	jne    8007da <vprintfmt+0x1a6>
				p = "(null)";
  8007d5:	be 51 35 80 00       	mov    $0x803551,%esi
			if (width > 0 && padc != '-')
  8007da:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8007de:	7e 6d                	jle    80084d <vprintfmt+0x219>
  8007e0:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  8007e4:	74 67                	je     80084d <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  8007e6:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8007e9:	83 ec 08             	sub    $0x8,%esp
  8007ec:	50                   	push   %eax
  8007ed:	56                   	push   %esi
  8007ee:	e8 0c 03 00 00       	call   800aff <strnlen>
  8007f3:	83 c4 10             	add    $0x10,%esp
  8007f6:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  8007f9:	eb 16                	jmp    800811 <vprintfmt+0x1dd>
					putch(padc, putdat);
  8007fb:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  8007ff:	83 ec 08             	sub    $0x8,%esp
  800802:	ff 75 0c             	pushl  0xc(%ebp)
  800805:	50                   	push   %eax
  800806:	8b 45 08             	mov    0x8(%ebp),%eax
  800809:	ff d0                	call   *%eax
  80080b:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  80080e:	ff 4d e4             	decl   -0x1c(%ebp)
  800811:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800815:	7f e4                	jg     8007fb <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800817:	eb 34                	jmp    80084d <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  800819:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  80081d:	74 1c                	je     80083b <vprintfmt+0x207>
  80081f:	83 fb 1f             	cmp    $0x1f,%ebx
  800822:	7e 05                	jle    800829 <vprintfmt+0x1f5>
  800824:	83 fb 7e             	cmp    $0x7e,%ebx
  800827:	7e 12                	jle    80083b <vprintfmt+0x207>
					putch('?', putdat);
  800829:	83 ec 08             	sub    $0x8,%esp
  80082c:	ff 75 0c             	pushl  0xc(%ebp)
  80082f:	6a 3f                	push   $0x3f
  800831:	8b 45 08             	mov    0x8(%ebp),%eax
  800834:	ff d0                	call   *%eax
  800836:	83 c4 10             	add    $0x10,%esp
  800839:	eb 0f                	jmp    80084a <vprintfmt+0x216>
				else
					putch(ch, putdat);
  80083b:	83 ec 08             	sub    $0x8,%esp
  80083e:	ff 75 0c             	pushl  0xc(%ebp)
  800841:	53                   	push   %ebx
  800842:	8b 45 08             	mov    0x8(%ebp),%eax
  800845:	ff d0                	call   *%eax
  800847:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  80084a:	ff 4d e4             	decl   -0x1c(%ebp)
  80084d:	89 f0                	mov    %esi,%eax
  80084f:	8d 70 01             	lea    0x1(%eax),%esi
  800852:	8a 00                	mov    (%eax),%al
  800854:	0f be d8             	movsbl %al,%ebx
  800857:	85 db                	test   %ebx,%ebx
  800859:	74 24                	je     80087f <vprintfmt+0x24b>
  80085b:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80085f:	78 b8                	js     800819 <vprintfmt+0x1e5>
  800861:	ff 4d e0             	decl   -0x20(%ebp)
  800864:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800868:	79 af                	jns    800819 <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  80086a:	eb 13                	jmp    80087f <vprintfmt+0x24b>
				putch(' ', putdat);
  80086c:	83 ec 08             	sub    $0x8,%esp
  80086f:	ff 75 0c             	pushl  0xc(%ebp)
  800872:	6a 20                	push   $0x20
  800874:	8b 45 08             	mov    0x8(%ebp),%eax
  800877:	ff d0                	call   *%eax
  800879:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  80087c:	ff 4d e4             	decl   -0x1c(%ebp)
  80087f:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800883:	7f e7                	jg     80086c <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  800885:	e9 66 01 00 00       	jmp    8009f0 <vprintfmt+0x3bc>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  80088a:	83 ec 08             	sub    $0x8,%esp
  80088d:	ff 75 e8             	pushl  -0x18(%ebp)
  800890:	8d 45 14             	lea    0x14(%ebp),%eax
  800893:	50                   	push   %eax
  800894:	e8 3c fd ff ff       	call   8005d5 <getint>
  800899:	83 c4 10             	add    $0x10,%esp
  80089c:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80089f:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  8008a2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8008a5:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8008a8:	85 d2                	test   %edx,%edx
  8008aa:	79 23                	jns    8008cf <vprintfmt+0x29b>
				putch('-', putdat);
  8008ac:	83 ec 08             	sub    $0x8,%esp
  8008af:	ff 75 0c             	pushl  0xc(%ebp)
  8008b2:	6a 2d                	push   $0x2d
  8008b4:	8b 45 08             	mov    0x8(%ebp),%eax
  8008b7:	ff d0                	call   *%eax
  8008b9:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  8008bc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8008bf:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8008c2:	f7 d8                	neg    %eax
  8008c4:	83 d2 00             	adc    $0x0,%edx
  8008c7:	f7 da                	neg    %edx
  8008c9:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8008cc:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  8008cf:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  8008d6:	e9 bc 00 00 00       	jmp    800997 <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  8008db:	83 ec 08             	sub    $0x8,%esp
  8008de:	ff 75 e8             	pushl  -0x18(%ebp)
  8008e1:	8d 45 14             	lea    0x14(%ebp),%eax
  8008e4:	50                   	push   %eax
  8008e5:	e8 84 fc ff ff       	call   80056e <getuint>
  8008ea:	83 c4 10             	add    $0x10,%esp
  8008ed:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8008f0:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  8008f3:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  8008fa:	e9 98 00 00 00       	jmp    800997 <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  8008ff:	83 ec 08             	sub    $0x8,%esp
  800902:	ff 75 0c             	pushl  0xc(%ebp)
  800905:	6a 58                	push   $0x58
  800907:	8b 45 08             	mov    0x8(%ebp),%eax
  80090a:	ff d0                	call   *%eax
  80090c:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  80090f:	83 ec 08             	sub    $0x8,%esp
  800912:	ff 75 0c             	pushl  0xc(%ebp)
  800915:	6a 58                	push   $0x58
  800917:	8b 45 08             	mov    0x8(%ebp),%eax
  80091a:	ff d0                	call   *%eax
  80091c:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  80091f:	83 ec 08             	sub    $0x8,%esp
  800922:	ff 75 0c             	pushl  0xc(%ebp)
  800925:	6a 58                	push   $0x58
  800927:	8b 45 08             	mov    0x8(%ebp),%eax
  80092a:	ff d0                	call   *%eax
  80092c:	83 c4 10             	add    $0x10,%esp
			break;
  80092f:	e9 bc 00 00 00       	jmp    8009f0 <vprintfmt+0x3bc>

		// pointer
		case 'p':
			putch('0', putdat);
  800934:	83 ec 08             	sub    $0x8,%esp
  800937:	ff 75 0c             	pushl  0xc(%ebp)
  80093a:	6a 30                	push   $0x30
  80093c:	8b 45 08             	mov    0x8(%ebp),%eax
  80093f:	ff d0                	call   *%eax
  800941:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  800944:	83 ec 08             	sub    $0x8,%esp
  800947:	ff 75 0c             	pushl  0xc(%ebp)
  80094a:	6a 78                	push   $0x78
  80094c:	8b 45 08             	mov    0x8(%ebp),%eax
  80094f:	ff d0                	call   *%eax
  800951:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  800954:	8b 45 14             	mov    0x14(%ebp),%eax
  800957:	83 c0 04             	add    $0x4,%eax
  80095a:	89 45 14             	mov    %eax,0x14(%ebp)
  80095d:	8b 45 14             	mov    0x14(%ebp),%eax
  800960:	83 e8 04             	sub    $0x4,%eax
  800963:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800965:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800968:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  80096f:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  800976:	eb 1f                	jmp    800997 <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800978:	83 ec 08             	sub    $0x8,%esp
  80097b:	ff 75 e8             	pushl  -0x18(%ebp)
  80097e:	8d 45 14             	lea    0x14(%ebp),%eax
  800981:	50                   	push   %eax
  800982:	e8 e7 fb ff ff       	call   80056e <getuint>
  800987:	83 c4 10             	add    $0x10,%esp
  80098a:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80098d:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  800990:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800997:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  80099b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80099e:	83 ec 04             	sub    $0x4,%esp
  8009a1:	52                   	push   %edx
  8009a2:	ff 75 e4             	pushl  -0x1c(%ebp)
  8009a5:	50                   	push   %eax
  8009a6:	ff 75 f4             	pushl  -0xc(%ebp)
  8009a9:	ff 75 f0             	pushl  -0x10(%ebp)
  8009ac:	ff 75 0c             	pushl  0xc(%ebp)
  8009af:	ff 75 08             	pushl  0x8(%ebp)
  8009b2:	e8 00 fb ff ff       	call   8004b7 <printnum>
  8009b7:	83 c4 20             	add    $0x20,%esp
			break;
  8009ba:	eb 34                	jmp    8009f0 <vprintfmt+0x3bc>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  8009bc:	83 ec 08             	sub    $0x8,%esp
  8009bf:	ff 75 0c             	pushl  0xc(%ebp)
  8009c2:	53                   	push   %ebx
  8009c3:	8b 45 08             	mov    0x8(%ebp),%eax
  8009c6:	ff d0                	call   *%eax
  8009c8:	83 c4 10             	add    $0x10,%esp
			break;
  8009cb:	eb 23                	jmp    8009f0 <vprintfmt+0x3bc>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  8009cd:	83 ec 08             	sub    $0x8,%esp
  8009d0:	ff 75 0c             	pushl  0xc(%ebp)
  8009d3:	6a 25                	push   $0x25
  8009d5:	8b 45 08             	mov    0x8(%ebp),%eax
  8009d8:	ff d0                	call   *%eax
  8009da:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  8009dd:	ff 4d 10             	decl   0x10(%ebp)
  8009e0:	eb 03                	jmp    8009e5 <vprintfmt+0x3b1>
  8009e2:	ff 4d 10             	decl   0x10(%ebp)
  8009e5:	8b 45 10             	mov    0x10(%ebp),%eax
  8009e8:	48                   	dec    %eax
  8009e9:	8a 00                	mov    (%eax),%al
  8009eb:	3c 25                	cmp    $0x25,%al
  8009ed:	75 f3                	jne    8009e2 <vprintfmt+0x3ae>
				/* do nothing */;
			break;
  8009ef:	90                   	nop
		}
	}
  8009f0:	e9 47 fc ff ff       	jmp    80063c <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  8009f5:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  8009f6:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8009f9:	5b                   	pop    %ebx
  8009fa:	5e                   	pop    %esi
  8009fb:	5d                   	pop    %ebp
  8009fc:	c3                   	ret    

008009fd <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  8009fd:	55                   	push   %ebp
  8009fe:	89 e5                	mov    %esp,%ebp
  800a00:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  800a03:	8d 45 10             	lea    0x10(%ebp),%eax
  800a06:	83 c0 04             	add    $0x4,%eax
  800a09:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  800a0c:	8b 45 10             	mov    0x10(%ebp),%eax
  800a0f:	ff 75 f4             	pushl  -0xc(%ebp)
  800a12:	50                   	push   %eax
  800a13:	ff 75 0c             	pushl  0xc(%ebp)
  800a16:	ff 75 08             	pushl  0x8(%ebp)
  800a19:	e8 16 fc ff ff       	call   800634 <vprintfmt>
  800a1e:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  800a21:	90                   	nop
  800a22:	c9                   	leave  
  800a23:	c3                   	ret    

00800a24 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800a24:	55                   	push   %ebp
  800a25:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  800a27:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a2a:	8b 40 08             	mov    0x8(%eax),%eax
  800a2d:	8d 50 01             	lea    0x1(%eax),%edx
  800a30:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a33:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  800a36:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a39:	8b 10                	mov    (%eax),%edx
  800a3b:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a3e:	8b 40 04             	mov    0x4(%eax),%eax
  800a41:	39 c2                	cmp    %eax,%edx
  800a43:	73 12                	jae    800a57 <sprintputch+0x33>
		*b->buf++ = ch;
  800a45:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a48:	8b 00                	mov    (%eax),%eax
  800a4a:	8d 48 01             	lea    0x1(%eax),%ecx
  800a4d:	8b 55 0c             	mov    0xc(%ebp),%edx
  800a50:	89 0a                	mov    %ecx,(%edx)
  800a52:	8b 55 08             	mov    0x8(%ebp),%edx
  800a55:	88 10                	mov    %dl,(%eax)
}
  800a57:	90                   	nop
  800a58:	5d                   	pop    %ebp
  800a59:	c3                   	ret    

00800a5a <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800a5a:	55                   	push   %ebp
  800a5b:	89 e5                	mov    %esp,%ebp
  800a5d:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  800a60:	8b 45 08             	mov    0x8(%ebp),%eax
  800a63:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800a66:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a69:	8d 50 ff             	lea    -0x1(%eax),%edx
  800a6c:	8b 45 08             	mov    0x8(%ebp),%eax
  800a6f:	01 d0                	add    %edx,%eax
  800a71:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800a74:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800a7b:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800a7f:	74 06                	je     800a87 <vsnprintf+0x2d>
  800a81:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800a85:	7f 07                	jg     800a8e <vsnprintf+0x34>
		return -E_INVAL;
  800a87:	b8 03 00 00 00       	mov    $0x3,%eax
  800a8c:	eb 20                	jmp    800aae <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800a8e:	ff 75 14             	pushl  0x14(%ebp)
  800a91:	ff 75 10             	pushl  0x10(%ebp)
  800a94:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800a97:	50                   	push   %eax
  800a98:	68 24 0a 80 00       	push   $0x800a24
  800a9d:	e8 92 fb ff ff       	call   800634 <vprintfmt>
  800aa2:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  800aa5:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800aa8:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800aab:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  800aae:	c9                   	leave  
  800aaf:	c3                   	ret    

00800ab0 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800ab0:	55                   	push   %ebp
  800ab1:	89 e5                	mov    %esp,%ebp
  800ab3:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800ab6:	8d 45 10             	lea    0x10(%ebp),%eax
  800ab9:	83 c0 04             	add    $0x4,%eax
  800abc:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  800abf:	8b 45 10             	mov    0x10(%ebp),%eax
  800ac2:	ff 75 f4             	pushl  -0xc(%ebp)
  800ac5:	50                   	push   %eax
  800ac6:	ff 75 0c             	pushl  0xc(%ebp)
  800ac9:	ff 75 08             	pushl  0x8(%ebp)
  800acc:	e8 89 ff ff ff       	call   800a5a <vsnprintf>
  800ad1:	83 c4 10             	add    $0x10,%esp
  800ad4:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  800ad7:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800ada:	c9                   	leave  
  800adb:	c3                   	ret    

00800adc <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  800adc:	55                   	push   %ebp
  800add:	89 e5                	mov    %esp,%ebp
  800adf:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  800ae2:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800ae9:	eb 06                	jmp    800af1 <strlen+0x15>
		n++;
  800aeb:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800aee:	ff 45 08             	incl   0x8(%ebp)
  800af1:	8b 45 08             	mov    0x8(%ebp),%eax
  800af4:	8a 00                	mov    (%eax),%al
  800af6:	84 c0                	test   %al,%al
  800af8:	75 f1                	jne    800aeb <strlen+0xf>
		n++;
	return n;
  800afa:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800afd:	c9                   	leave  
  800afe:	c3                   	ret    

00800aff <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  800aff:	55                   	push   %ebp
  800b00:	89 e5                	mov    %esp,%ebp
  800b02:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800b05:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800b0c:	eb 09                	jmp    800b17 <strnlen+0x18>
		n++;
  800b0e:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800b11:	ff 45 08             	incl   0x8(%ebp)
  800b14:	ff 4d 0c             	decl   0xc(%ebp)
  800b17:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800b1b:	74 09                	je     800b26 <strnlen+0x27>
  800b1d:	8b 45 08             	mov    0x8(%ebp),%eax
  800b20:	8a 00                	mov    (%eax),%al
  800b22:	84 c0                	test   %al,%al
  800b24:	75 e8                	jne    800b0e <strnlen+0xf>
		n++;
	return n;
  800b26:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800b29:	c9                   	leave  
  800b2a:	c3                   	ret    

00800b2b <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800b2b:	55                   	push   %ebp
  800b2c:	89 e5                	mov    %esp,%ebp
  800b2e:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  800b31:	8b 45 08             	mov    0x8(%ebp),%eax
  800b34:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  800b37:	90                   	nop
  800b38:	8b 45 08             	mov    0x8(%ebp),%eax
  800b3b:	8d 50 01             	lea    0x1(%eax),%edx
  800b3e:	89 55 08             	mov    %edx,0x8(%ebp)
  800b41:	8b 55 0c             	mov    0xc(%ebp),%edx
  800b44:	8d 4a 01             	lea    0x1(%edx),%ecx
  800b47:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800b4a:	8a 12                	mov    (%edx),%dl
  800b4c:	88 10                	mov    %dl,(%eax)
  800b4e:	8a 00                	mov    (%eax),%al
  800b50:	84 c0                	test   %al,%al
  800b52:	75 e4                	jne    800b38 <strcpy+0xd>
		/* do nothing */;
	return ret;
  800b54:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800b57:	c9                   	leave  
  800b58:	c3                   	ret    

00800b59 <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  800b59:	55                   	push   %ebp
  800b5a:	89 e5                	mov    %esp,%ebp
  800b5c:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  800b5f:	8b 45 08             	mov    0x8(%ebp),%eax
  800b62:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  800b65:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800b6c:	eb 1f                	jmp    800b8d <strncpy+0x34>
		*dst++ = *src;
  800b6e:	8b 45 08             	mov    0x8(%ebp),%eax
  800b71:	8d 50 01             	lea    0x1(%eax),%edx
  800b74:	89 55 08             	mov    %edx,0x8(%ebp)
  800b77:	8b 55 0c             	mov    0xc(%ebp),%edx
  800b7a:	8a 12                	mov    (%edx),%dl
  800b7c:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  800b7e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b81:	8a 00                	mov    (%eax),%al
  800b83:	84 c0                	test   %al,%al
  800b85:	74 03                	je     800b8a <strncpy+0x31>
			src++;
  800b87:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800b8a:	ff 45 fc             	incl   -0x4(%ebp)
  800b8d:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800b90:	3b 45 10             	cmp    0x10(%ebp),%eax
  800b93:	72 d9                	jb     800b6e <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  800b95:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  800b98:	c9                   	leave  
  800b99:	c3                   	ret    

00800b9a <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  800b9a:	55                   	push   %ebp
  800b9b:	89 e5                	mov    %esp,%ebp
  800b9d:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  800ba0:	8b 45 08             	mov    0x8(%ebp),%eax
  800ba3:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  800ba6:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800baa:	74 30                	je     800bdc <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  800bac:	eb 16                	jmp    800bc4 <strlcpy+0x2a>
			*dst++ = *src++;
  800bae:	8b 45 08             	mov    0x8(%ebp),%eax
  800bb1:	8d 50 01             	lea    0x1(%eax),%edx
  800bb4:	89 55 08             	mov    %edx,0x8(%ebp)
  800bb7:	8b 55 0c             	mov    0xc(%ebp),%edx
  800bba:	8d 4a 01             	lea    0x1(%edx),%ecx
  800bbd:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800bc0:	8a 12                	mov    (%edx),%dl
  800bc2:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800bc4:	ff 4d 10             	decl   0x10(%ebp)
  800bc7:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800bcb:	74 09                	je     800bd6 <strlcpy+0x3c>
  800bcd:	8b 45 0c             	mov    0xc(%ebp),%eax
  800bd0:	8a 00                	mov    (%eax),%al
  800bd2:	84 c0                	test   %al,%al
  800bd4:	75 d8                	jne    800bae <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  800bd6:	8b 45 08             	mov    0x8(%ebp),%eax
  800bd9:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800bdc:	8b 55 08             	mov    0x8(%ebp),%edx
  800bdf:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800be2:	29 c2                	sub    %eax,%edx
  800be4:	89 d0                	mov    %edx,%eax
}
  800be6:	c9                   	leave  
  800be7:	c3                   	ret    

00800be8 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800be8:	55                   	push   %ebp
  800be9:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  800beb:	eb 06                	jmp    800bf3 <strcmp+0xb>
		p++, q++;
  800bed:	ff 45 08             	incl   0x8(%ebp)
  800bf0:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  800bf3:	8b 45 08             	mov    0x8(%ebp),%eax
  800bf6:	8a 00                	mov    (%eax),%al
  800bf8:	84 c0                	test   %al,%al
  800bfa:	74 0e                	je     800c0a <strcmp+0x22>
  800bfc:	8b 45 08             	mov    0x8(%ebp),%eax
  800bff:	8a 10                	mov    (%eax),%dl
  800c01:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c04:	8a 00                	mov    (%eax),%al
  800c06:	38 c2                	cmp    %al,%dl
  800c08:	74 e3                	je     800bed <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800c0a:	8b 45 08             	mov    0x8(%ebp),%eax
  800c0d:	8a 00                	mov    (%eax),%al
  800c0f:	0f b6 d0             	movzbl %al,%edx
  800c12:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c15:	8a 00                	mov    (%eax),%al
  800c17:	0f b6 c0             	movzbl %al,%eax
  800c1a:	29 c2                	sub    %eax,%edx
  800c1c:	89 d0                	mov    %edx,%eax
}
  800c1e:	5d                   	pop    %ebp
  800c1f:	c3                   	ret    

00800c20 <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  800c20:	55                   	push   %ebp
  800c21:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  800c23:	eb 09                	jmp    800c2e <strncmp+0xe>
		n--, p++, q++;
  800c25:	ff 4d 10             	decl   0x10(%ebp)
  800c28:	ff 45 08             	incl   0x8(%ebp)
  800c2b:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  800c2e:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800c32:	74 17                	je     800c4b <strncmp+0x2b>
  800c34:	8b 45 08             	mov    0x8(%ebp),%eax
  800c37:	8a 00                	mov    (%eax),%al
  800c39:	84 c0                	test   %al,%al
  800c3b:	74 0e                	je     800c4b <strncmp+0x2b>
  800c3d:	8b 45 08             	mov    0x8(%ebp),%eax
  800c40:	8a 10                	mov    (%eax),%dl
  800c42:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c45:	8a 00                	mov    (%eax),%al
  800c47:	38 c2                	cmp    %al,%dl
  800c49:	74 da                	je     800c25 <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  800c4b:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800c4f:	75 07                	jne    800c58 <strncmp+0x38>
		return 0;
  800c51:	b8 00 00 00 00       	mov    $0x0,%eax
  800c56:	eb 14                	jmp    800c6c <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800c58:	8b 45 08             	mov    0x8(%ebp),%eax
  800c5b:	8a 00                	mov    (%eax),%al
  800c5d:	0f b6 d0             	movzbl %al,%edx
  800c60:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c63:	8a 00                	mov    (%eax),%al
  800c65:	0f b6 c0             	movzbl %al,%eax
  800c68:	29 c2                	sub    %eax,%edx
  800c6a:	89 d0                	mov    %edx,%eax
}
  800c6c:	5d                   	pop    %ebp
  800c6d:	c3                   	ret    

00800c6e <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800c6e:	55                   	push   %ebp
  800c6f:	89 e5                	mov    %esp,%ebp
  800c71:	83 ec 04             	sub    $0x4,%esp
  800c74:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c77:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800c7a:	eb 12                	jmp    800c8e <strchr+0x20>
		if (*s == c)
  800c7c:	8b 45 08             	mov    0x8(%ebp),%eax
  800c7f:	8a 00                	mov    (%eax),%al
  800c81:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800c84:	75 05                	jne    800c8b <strchr+0x1d>
			return (char *) s;
  800c86:	8b 45 08             	mov    0x8(%ebp),%eax
  800c89:	eb 11                	jmp    800c9c <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  800c8b:	ff 45 08             	incl   0x8(%ebp)
  800c8e:	8b 45 08             	mov    0x8(%ebp),%eax
  800c91:	8a 00                	mov    (%eax),%al
  800c93:	84 c0                	test   %al,%al
  800c95:	75 e5                	jne    800c7c <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  800c97:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800c9c:	c9                   	leave  
  800c9d:	c3                   	ret    

00800c9e <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800c9e:	55                   	push   %ebp
  800c9f:	89 e5                	mov    %esp,%ebp
  800ca1:	83 ec 04             	sub    $0x4,%esp
  800ca4:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ca7:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800caa:	eb 0d                	jmp    800cb9 <strfind+0x1b>
		if (*s == c)
  800cac:	8b 45 08             	mov    0x8(%ebp),%eax
  800caf:	8a 00                	mov    (%eax),%al
  800cb1:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800cb4:	74 0e                	je     800cc4 <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  800cb6:	ff 45 08             	incl   0x8(%ebp)
  800cb9:	8b 45 08             	mov    0x8(%ebp),%eax
  800cbc:	8a 00                	mov    (%eax),%al
  800cbe:	84 c0                	test   %al,%al
  800cc0:	75 ea                	jne    800cac <strfind+0xe>
  800cc2:	eb 01                	jmp    800cc5 <strfind+0x27>
		if (*s == c)
			break;
  800cc4:	90                   	nop
	return (char *) s;
  800cc5:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800cc8:	c9                   	leave  
  800cc9:	c3                   	ret    

00800cca <memset>:


void *
memset(void *v, int c, uint32 n)
{
  800cca:	55                   	push   %ebp
  800ccb:	89 e5                	mov    %esp,%ebp
  800ccd:	83 ec 10             	sub    $0x10,%esp
	char *p;
	int m;

	p = v;
  800cd0:	8b 45 08             	mov    0x8(%ebp),%eax
  800cd3:	89 45 fc             	mov    %eax,-0x4(%ebp)
	m = n;
  800cd6:	8b 45 10             	mov    0x10(%ebp),%eax
  800cd9:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (--m >= 0)
  800cdc:	eb 0e                	jmp    800cec <memset+0x22>
		*p++ = c;
  800cde:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800ce1:	8d 50 01             	lea    0x1(%eax),%edx
  800ce4:	89 55 fc             	mov    %edx,-0x4(%ebp)
  800ce7:	8b 55 0c             	mov    0xc(%ebp),%edx
  800cea:	88 10                	mov    %dl,(%eax)
	char *p;
	int m;

	p = v;
	m = n;
	while (--m >= 0)
  800cec:	ff 4d f8             	decl   -0x8(%ebp)
  800cef:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  800cf3:	79 e9                	jns    800cde <memset+0x14>
		*p++ = c;

	return v;
  800cf5:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800cf8:	c9                   	leave  
  800cf9:	c3                   	ret    

00800cfa <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  800cfa:	55                   	push   %ebp
  800cfb:	89 e5                	mov    %esp,%ebp
  800cfd:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800d00:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d03:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800d06:	8b 45 08             	mov    0x8(%ebp),%eax
  800d09:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (n-- > 0)
  800d0c:	eb 16                	jmp    800d24 <memcpy+0x2a>
		*d++ = *s++;
  800d0e:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800d11:	8d 50 01             	lea    0x1(%eax),%edx
  800d14:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800d17:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800d1a:	8d 4a 01             	lea    0x1(%edx),%ecx
  800d1d:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800d20:	8a 12                	mov    (%edx),%dl
  800d22:	88 10                	mov    %dl,(%eax)
	const char *s;
	char *d;

	s = src;
	d = dst;
	while (n-- > 0)
  800d24:	8b 45 10             	mov    0x10(%ebp),%eax
  800d27:	8d 50 ff             	lea    -0x1(%eax),%edx
  800d2a:	89 55 10             	mov    %edx,0x10(%ebp)
  800d2d:	85 c0                	test   %eax,%eax
  800d2f:	75 dd                	jne    800d0e <memcpy+0x14>
		*d++ = *s++;

	return dst;
  800d31:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800d34:	c9                   	leave  
  800d35:	c3                   	ret    

00800d36 <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  800d36:	55                   	push   %ebp
  800d37:	89 e5                	mov    %esp,%ebp
  800d39:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800d3c:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d3f:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800d42:	8b 45 08             	mov    0x8(%ebp),%eax
  800d45:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  800d48:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800d4b:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800d4e:	73 50                	jae    800da0 <memmove+0x6a>
  800d50:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800d53:	8b 45 10             	mov    0x10(%ebp),%eax
  800d56:	01 d0                	add    %edx,%eax
  800d58:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800d5b:	76 43                	jbe    800da0 <memmove+0x6a>
		s += n;
  800d5d:	8b 45 10             	mov    0x10(%ebp),%eax
  800d60:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  800d63:	8b 45 10             	mov    0x10(%ebp),%eax
  800d66:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  800d69:	eb 10                	jmp    800d7b <memmove+0x45>
			*--d = *--s;
  800d6b:	ff 4d f8             	decl   -0x8(%ebp)
  800d6e:	ff 4d fc             	decl   -0x4(%ebp)
  800d71:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800d74:	8a 10                	mov    (%eax),%dl
  800d76:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800d79:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  800d7b:	8b 45 10             	mov    0x10(%ebp),%eax
  800d7e:	8d 50 ff             	lea    -0x1(%eax),%edx
  800d81:	89 55 10             	mov    %edx,0x10(%ebp)
  800d84:	85 c0                	test   %eax,%eax
  800d86:	75 e3                	jne    800d6b <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800d88:	eb 23                	jmp    800dad <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  800d8a:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800d8d:	8d 50 01             	lea    0x1(%eax),%edx
  800d90:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800d93:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800d96:	8d 4a 01             	lea    0x1(%edx),%ecx
  800d99:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800d9c:	8a 12                	mov    (%edx),%dl
  800d9e:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  800da0:	8b 45 10             	mov    0x10(%ebp),%eax
  800da3:	8d 50 ff             	lea    -0x1(%eax),%edx
  800da6:	89 55 10             	mov    %edx,0x10(%ebp)
  800da9:	85 c0                	test   %eax,%eax
  800dab:	75 dd                	jne    800d8a <memmove+0x54>
			*d++ = *s++;

	return dst;
  800dad:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800db0:	c9                   	leave  
  800db1:	c3                   	ret    

00800db2 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  800db2:	55                   	push   %ebp
  800db3:	89 e5                	mov    %esp,%ebp
  800db5:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  800db8:	8b 45 08             	mov    0x8(%ebp),%eax
  800dbb:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  800dbe:	8b 45 0c             	mov    0xc(%ebp),%eax
  800dc1:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  800dc4:	eb 2a                	jmp    800df0 <memcmp+0x3e>
		if (*s1 != *s2)
  800dc6:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800dc9:	8a 10                	mov    (%eax),%dl
  800dcb:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800dce:	8a 00                	mov    (%eax),%al
  800dd0:	38 c2                	cmp    %al,%dl
  800dd2:	74 16                	je     800dea <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  800dd4:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800dd7:	8a 00                	mov    (%eax),%al
  800dd9:	0f b6 d0             	movzbl %al,%edx
  800ddc:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800ddf:	8a 00                	mov    (%eax),%al
  800de1:	0f b6 c0             	movzbl %al,%eax
  800de4:	29 c2                	sub    %eax,%edx
  800de6:	89 d0                	mov    %edx,%eax
  800de8:	eb 18                	jmp    800e02 <memcmp+0x50>
		s1++, s2++;
  800dea:	ff 45 fc             	incl   -0x4(%ebp)
  800ded:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  800df0:	8b 45 10             	mov    0x10(%ebp),%eax
  800df3:	8d 50 ff             	lea    -0x1(%eax),%edx
  800df6:	89 55 10             	mov    %edx,0x10(%ebp)
  800df9:	85 c0                	test   %eax,%eax
  800dfb:	75 c9                	jne    800dc6 <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  800dfd:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800e02:	c9                   	leave  
  800e03:	c3                   	ret    

00800e04 <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  800e04:	55                   	push   %ebp
  800e05:	89 e5                	mov    %esp,%ebp
  800e07:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  800e0a:	8b 55 08             	mov    0x8(%ebp),%edx
  800e0d:	8b 45 10             	mov    0x10(%ebp),%eax
  800e10:	01 d0                	add    %edx,%eax
  800e12:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  800e15:	eb 15                	jmp    800e2c <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  800e17:	8b 45 08             	mov    0x8(%ebp),%eax
  800e1a:	8a 00                	mov    (%eax),%al
  800e1c:	0f b6 d0             	movzbl %al,%edx
  800e1f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e22:	0f b6 c0             	movzbl %al,%eax
  800e25:	39 c2                	cmp    %eax,%edx
  800e27:	74 0d                	je     800e36 <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  800e29:	ff 45 08             	incl   0x8(%ebp)
  800e2c:	8b 45 08             	mov    0x8(%ebp),%eax
  800e2f:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  800e32:	72 e3                	jb     800e17 <memfind+0x13>
  800e34:	eb 01                	jmp    800e37 <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  800e36:	90                   	nop
	return (void *) s;
  800e37:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800e3a:	c9                   	leave  
  800e3b:	c3                   	ret    

00800e3c <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800e3c:	55                   	push   %ebp
  800e3d:	89 e5                	mov    %esp,%ebp
  800e3f:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  800e42:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  800e49:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800e50:	eb 03                	jmp    800e55 <strtol+0x19>
		s++;
  800e52:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800e55:	8b 45 08             	mov    0x8(%ebp),%eax
  800e58:	8a 00                	mov    (%eax),%al
  800e5a:	3c 20                	cmp    $0x20,%al
  800e5c:	74 f4                	je     800e52 <strtol+0x16>
  800e5e:	8b 45 08             	mov    0x8(%ebp),%eax
  800e61:	8a 00                	mov    (%eax),%al
  800e63:	3c 09                	cmp    $0x9,%al
  800e65:	74 eb                	je     800e52 <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  800e67:	8b 45 08             	mov    0x8(%ebp),%eax
  800e6a:	8a 00                	mov    (%eax),%al
  800e6c:	3c 2b                	cmp    $0x2b,%al
  800e6e:	75 05                	jne    800e75 <strtol+0x39>
		s++;
  800e70:	ff 45 08             	incl   0x8(%ebp)
  800e73:	eb 13                	jmp    800e88 <strtol+0x4c>
	else if (*s == '-')
  800e75:	8b 45 08             	mov    0x8(%ebp),%eax
  800e78:	8a 00                	mov    (%eax),%al
  800e7a:	3c 2d                	cmp    $0x2d,%al
  800e7c:	75 0a                	jne    800e88 <strtol+0x4c>
		s++, neg = 1;
  800e7e:	ff 45 08             	incl   0x8(%ebp)
  800e81:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800e88:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800e8c:	74 06                	je     800e94 <strtol+0x58>
  800e8e:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  800e92:	75 20                	jne    800eb4 <strtol+0x78>
  800e94:	8b 45 08             	mov    0x8(%ebp),%eax
  800e97:	8a 00                	mov    (%eax),%al
  800e99:	3c 30                	cmp    $0x30,%al
  800e9b:	75 17                	jne    800eb4 <strtol+0x78>
  800e9d:	8b 45 08             	mov    0x8(%ebp),%eax
  800ea0:	40                   	inc    %eax
  800ea1:	8a 00                	mov    (%eax),%al
  800ea3:	3c 78                	cmp    $0x78,%al
  800ea5:	75 0d                	jne    800eb4 <strtol+0x78>
		s += 2, base = 16;
  800ea7:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  800eab:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  800eb2:	eb 28                	jmp    800edc <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  800eb4:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800eb8:	75 15                	jne    800ecf <strtol+0x93>
  800eba:	8b 45 08             	mov    0x8(%ebp),%eax
  800ebd:	8a 00                	mov    (%eax),%al
  800ebf:	3c 30                	cmp    $0x30,%al
  800ec1:	75 0c                	jne    800ecf <strtol+0x93>
		s++, base = 8;
  800ec3:	ff 45 08             	incl   0x8(%ebp)
  800ec6:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  800ecd:	eb 0d                	jmp    800edc <strtol+0xa0>
	else if (base == 0)
  800ecf:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800ed3:	75 07                	jne    800edc <strtol+0xa0>
		base = 10;
  800ed5:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  800edc:	8b 45 08             	mov    0x8(%ebp),%eax
  800edf:	8a 00                	mov    (%eax),%al
  800ee1:	3c 2f                	cmp    $0x2f,%al
  800ee3:	7e 19                	jle    800efe <strtol+0xc2>
  800ee5:	8b 45 08             	mov    0x8(%ebp),%eax
  800ee8:	8a 00                	mov    (%eax),%al
  800eea:	3c 39                	cmp    $0x39,%al
  800eec:	7f 10                	jg     800efe <strtol+0xc2>
			dig = *s - '0';
  800eee:	8b 45 08             	mov    0x8(%ebp),%eax
  800ef1:	8a 00                	mov    (%eax),%al
  800ef3:	0f be c0             	movsbl %al,%eax
  800ef6:	83 e8 30             	sub    $0x30,%eax
  800ef9:	89 45 f4             	mov    %eax,-0xc(%ebp)
  800efc:	eb 42                	jmp    800f40 <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  800efe:	8b 45 08             	mov    0x8(%ebp),%eax
  800f01:	8a 00                	mov    (%eax),%al
  800f03:	3c 60                	cmp    $0x60,%al
  800f05:	7e 19                	jle    800f20 <strtol+0xe4>
  800f07:	8b 45 08             	mov    0x8(%ebp),%eax
  800f0a:	8a 00                	mov    (%eax),%al
  800f0c:	3c 7a                	cmp    $0x7a,%al
  800f0e:	7f 10                	jg     800f20 <strtol+0xe4>
			dig = *s - 'a' + 10;
  800f10:	8b 45 08             	mov    0x8(%ebp),%eax
  800f13:	8a 00                	mov    (%eax),%al
  800f15:	0f be c0             	movsbl %al,%eax
  800f18:	83 e8 57             	sub    $0x57,%eax
  800f1b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  800f1e:	eb 20                	jmp    800f40 <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  800f20:	8b 45 08             	mov    0x8(%ebp),%eax
  800f23:	8a 00                	mov    (%eax),%al
  800f25:	3c 40                	cmp    $0x40,%al
  800f27:	7e 39                	jle    800f62 <strtol+0x126>
  800f29:	8b 45 08             	mov    0x8(%ebp),%eax
  800f2c:	8a 00                	mov    (%eax),%al
  800f2e:	3c 5a                	cmp    $0x5a,%al
  800f30:	7f 30                	jg     800f62 <strtol+0x126>
			dig = *s - 'A' + 10;
  800f32:	8b 45 08             	mov    0x8(%ebp),%eax
  800f35:	8a 00                	mov    (%eax),%al
  800f37:	0f be c0             	movsbl %al,%eax
  800f3a:	83 e8 37             	sub    $0x37,%eax
  800f3d:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  800f40:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800f43:	3b 45 10             	cmp    0x10(%ebp),%eax
  800f46:	7d 19                	jge    800f61 <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  800f48:	ff 45 08             	incl   0x8(%ebp)
  800f4b:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800f4e:	0f af 45 10          	imul   0x10(%ebp),%eax
  800f52:	89 c2                	mov    %eax,%edx
  800f54:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800f57:	01 d0                	add    %edx,%eax
  800f59:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  800f5c:	e9 7b ff ff ff       	jmp    800edc <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  800f61:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  800f62:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800f66:	74 08                	je     800f70 <strtol+0x134>
		*endptr = (char *) s;
  800f68:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f6b:	8b 55 08             	mov    0x8(%ebp),%edx
  800f6e:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  800f70:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  800f74:	74 07                	je     800f7d <strtol+0x141>
  800f76:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800f79:	f7 d8                	neg    %eax
  800f7b:	eb 03                	jmp    800f80 <strtol+0x144>
  800f7d:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  800f80:	c9                   	leave  
  800f81:	c3                   	ret    

00800f82 <ltostr>:

void
ltostr(long value, char *str)
{
  800f82:	55                   	push   %ebp
  800f83:	89 e5                	mov    %esp,%ebp
  800f85:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  800f88:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  800f8f:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  800f96:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800f9a:	79 13                	jns    800faf <ltostr+0x2d>
	{
		neg = 1;
  800f9c:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  800fa3:	8b 45 0c             	mov    0xc(%ebp),%eax
  800fa6:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  800fa9:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  800fac:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  800faf:	8b 45 08             	mov    0x8(%ebp),%eax
  800fb2:	b9 0a 00 00 00       	mov    $0xa,%ecx
  800fb7:	99                   	cltd   
  800fb8:	f7 f9                	idiv   %ecx
  800fba:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  800fbd:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800fc0:	8d 50 01             	lea    0x1(%eax),%edx
  800fc3:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800fc6:	89 c2                	mov    %eax,%edx
  800fc8:	8b 45 0c             	mov    0xc(%ebp),%eax
  800fcb:	01 d0                	add    %edx,%eax
  800fcd:	8b 55 ec             	mov    -0x14(%ebp),%edx
  800fd0:	83 c2 30             	add    $0x30,%edx
  800fd3:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  800fd5:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800fd8:	b8 67 66 66 66       	mov    $0x66666667,%eax
  800fdd:	f7 e9                	imul   %ecx
  800fdf:	c1 fa 02             	sar    $0x2,%edx
  800fe2:	89 c8                	mov    %ecx,%eax
  800fe4:	c1 f8 1f             	sar    $0x1f,%eax
  800fe7:	29 c2                	sub    %eax,%edx
  800fe9:	89 d0                	mov    %edx,%eax
  800feb:	89 45 08             	mov    %eax,0x8(%ebp)
	} while (value % 10 != 0);
  800fee:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800ff1:	b8 67 66 66 66       	mov    $0x66666667,%eax
  800ff6:	f7 e9                	imul   %ecx
  800ff8:	c1 fa 02             	sar    $0x2,%edx
  800ffb:	89 c8                	mov    %ecx,%eax
  800ffd:	c1 f8 1f             	sar    $0x1f,%eax
  801000:	29 c2                	sub    %eax,%edx
  801002:	89 d0                	mov    %edx,%eax
  801004:	c1 e0 02             	shl    $0x2,%eax
  801007:	01 d0                	add    %edx,%eax
  801009:	01 c0                	add    %eax,%eax
  80100b:	29 c1                	sub    %eax,%ecx
  80100d:	89 ca                	mov    %ecx,%edx
  80100f:	85 d2                	test   %edx,%edx
  801011:	75 9c                	jne    800faf <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  801013:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  80101a:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80101d:	48                   	dec    %eax
  80101e:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  801021:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801025:	74 3d                	je     801064 <ltostr+0xe2>
		start = 1 ;
  801027:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  80102e:	eb 34                	jmp    801064 <ltostr+0xe2>
	{
		char tmp = str[start] ;
  801030:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801033:	8b 45 0c             	mov    0xc(%ebp),%eax
  801036:	01 d0                	add    %edx,%eax
  801038:	8a 00                	mov    (%eax),%al
  80103a:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  80103d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801040:	8b 45 0c             	mov    0xc(%ebp),%eax
  801043:	01 c2                	add    %eax,%edx
  801045:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  801048:	8b 45 0c             	mov    0xc(%ebp),%eax
  80104b:	01 c8                	add    %ecx,%eax
  80104d:	8a 00                	mov    (%eax),%al
  80104f:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  801051:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801054:	8b 45 0c             	mov    0xc(%ebp),%eax
  801057:	01 c2                	add    %eax,%edx
  801059:	8a 45 eb             	mov    -0x15(%ebp),%al
  80105c:	88 02                	mov    %al,(%edx)
		start++ ;
  80105e:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  801061:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  801064:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801067:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80106a:	7c c4                	jl     801030 <ltostr+0xae>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  80106c:	8b 55 f8             	mov    -0x8(%ebp),%edx
  80106f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801072:	01 d0                	add    %edx,%eax
  801074:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  801077:	90                   	nop
  801078:	c9                   	leave  
  801079:	c3                   	ret    

0080107a <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  80107a:	55                   	push   %ebp
  80107b:	89 e5                	mov    %esp,%ebp
  80107d:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  801080:	ff 75 08             	pushl  0x8(%ebp)
  801083:	e8 54 fa ff ff       	call   800adc <strlen>
  801088:	83 c4 04             	add    $0x4,%esp
  80108b:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  80108e:	ff 75 0c             	pushl  0xc(%ebp)
  801091:	e8 46 fa ff ff       	call   800adc <strlen>
  801096:	83 c4 04             	add    $0x4,%esp
  801099:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  80109c:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  8010a3:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8010aa:	eb 17                	jmp    8010c3 <strcconcat+0x49>
		final[s] = str1[s] ;
  8010ac:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8010af:	8b 45 10             	mov    0x10(%ebp),%eax
  8010b2:	01 c2                	add    %eax,%edx
  8010b4:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  8010b7:	8b 45 08             	mov    0x8(%ebp),%eax
  8010ba:	01 c8                	add    %ecx,%eax
  8010bc:	8a 00                	mov    (%eax),%al
  8010be:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  8010c0:	ff 45 fc             	incl   -0x4(%ebp)
  8010c3:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8010c6:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  8010c9:	7c e1                	jl     8010ac <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  8010cb:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  8010d2:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  8010d9:	eb 1f                	jmp    8010fa <strcconcat+0x80>
		final[s++] = str2[i] ;
  8010db:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8010de:	8d 50 01             	lea    0x1(%eax),%edx
  8010e1:	89 55 fc             	mov    %edx,-0x4(%ebp)
  8010e4:	89 c2                	mov    %eax,%edx
  8010e6:	8b 45 10             	mov    0x10(%ebp),%eax
  8010e9:	01 c2                	add    %eax,%edx
  8010eb:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  8010ee:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010f1:	01 c8                	add    %ecx,%eax
  8010f3:	8a 00                	mov    (%eax),%al
  8010f5:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  8010f7:	ff 45 f8             	incl   -0x8(%ebp)
  8010fa:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8010fd:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801100:	7c d9                	jl     8010db <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  801102:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801105:	8b 45 10             	mov    0x10(%ebp),%eax
  801108:	01 d0                	add    %edx,%eax
  80110a:	c6 00 00             	movb   $0x0,(%eax)
}
  80110d:	90                   	nop
  80110e:	c9                   	leave  
  80110f:	c3                   	ret    

00801110 <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  801110:	55                   	push   %ebp
  801111:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  801113:	8b 45 14             	mov    0x14(%ebp),%eax
  801116:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  80111c:	8b 45 14             	mov    0x14(%ebp),%eax
  80111f:	8b 00                	mov    (%eax),%eax
  801121:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801128:	8b 45 10             	mov    0x10(%ebp),%eax
  80112b:	01 d0                	add    %edx,%eax
  80112d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801133:	eb 0c                	jmp    801141 <strsplit+0x31>
			*string++ = 0;
  801135:	8b 45 08             	mov    0x8(%ebp),%eax
  801138:	8d 50 01             	lea    0x1(%eax),%edx
  80113b:	89 55 08             	mov    %edx,0x8(%ebp)
  80113e:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801141:	8b 45 08             	mov    0x8(%ebp),%eax
  801144:	8a 00                	mov    (%eax),%al
  801146:	84 c0                	test   %al,%al
  801148:	74 18                	je     801162 <strsplit+0x52>
  80114a:	8b 45 08             	mov    0x8(%ebp),%eax
  80114d:	8a 00                	mov    (%eax),%al
  80114f:	0f be c0             	movsbl %al,%eax
  801152:	50                   	push   %eax
  801153:	ff 75 0c             	pushl  0xc(%ebp)
  801156:	e8 13 fb ff ff       	call   800c6e <strchr>
  80115b:	83 c4 08             	add    $0x8,%esp
  80115e:	85 c0                	test   %eax,%eax
  801160:	75 d3                	jne    801135 <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  801162:	8b 45 08             	mov    0x8(%ebp),%eax
  801165:	8a 00                	mov    (%eax),%al
  801167:	84 c0                	test   %al,%al
  801169:	74 5a                	je     8011c5 <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  80116b:	8b 45 14             	mov    0x14(%ebp),%eax
  80116e:	8b 00                	mov    (%eax),%eax
  801170:	83 f8 0f             	cmp    $0xf,%eax
  801173:	75 07                	jne    80117c <strsplit+0x6c>
		{
			return 0;
  801175:	b8 00 00 00 00       	mov    $0x0,%eax
  80117a:	eb 66                	jmp    8011e2 <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  80117c:	8b 45 14             	mov    0x14(%ebp),%eax
  80117f:	8b 00                	mov    (%eax),%eax
  801181:	8d 48 01             	lea    0x1(%eax),%ecx
  801184:	8b 55 14             	mov    0x14(%ebp),%edx
  801187:	89 0a                	mov    %ecx,(%edx)
  801189:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801190:	8b 45 10             	mov    0x10(%ebp),%eax
  801193:	01 c2                	add    %eax,%edx
  801195:	8b 45 08             	mov    0x8(%ebp),%eax
  801198:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  80119a:	eb 03                	jmp    80119f <strsplit+0x8f>
			string++;
  80119c:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  80119f:	8b 45 08             	mov    0x8(%ebp),%eax
  8011a2:	8a 00                	mov    (%eax),%al
  8011a4:	84 c0                	test   %al,%al
  8011a6:	74 8b                	je     801133 <strsplit+0x23>
  8011a8:	8b 45 08             	mov    0x8(%ebp),%eax
  8011ab:	8a 00                	mov    (%eax),%al
  8011ad:	0f be c0             	movsbl %al,%eax
  8011b0:	50                   	push   %eax
  8011b1:	ff 75 0c             	pushl  0xc(%ebp)
  8011b4:	e8 b5 fa ff ff       	call   800c6e <strchr>
  8011b9:	83 c4 08             	add    $0x8,%esp
  8011bc:	85 c0                	test   %eax,%eax
  8011be:	74 dc                	je     80119c <strsplit+0x8c>
			string++;
	}
  8011c0:	e9 6e ff ff ff       	jmp    801133 <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  8011c5:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  8011c6:	8b 45 14             	mov    0x14(%ebp),%eax
  8011c9:	8b 00                	mov    (%eax),%eax
  8011cb:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8011d2:	8b 45 10             	mov    0x10(%ebp),%eax
  8011d5:	01 d0                	add    %edx,%eax
  8011d7:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  8011dd:	b8 01 00 00 00       	mov    $0x1,%eax
}
  8011e2:	c9                   	leave  
  8011e3:	c3                   	ret    

008011e4 <InitializeUHeap>:
//============================== GIVEN FUNCTIONS ===================================//
//==================================================================================//

int FirstTimeFlag = 1;
void InitializeUHeap()
{
  8011e4:	55                   	push   %ebp
  8011e5:	89 e5                	mov    %esp,%ebp
  8011e7:	83 ec 08             	sub    $0x8,%esp
	if(FirstTimeFlag)
  8011ea:	a1 04 40 80 00       	mov    0x804004,%eax
  8011ef:	85 c0                	test   %eax,%eax
  8011f1:	74 1f                	je     801212 <InitializeUHeap+0x2e>
	{
		initialize_dyn_block_system();
  8011f3:	e8 1d 00 00 00       	call   801215 <initialize_dyn_block_system>
		cprintf("DYNAMIC BLOCK SYSTEM IS INITIALIZED\n");
  8011f8:	83 ec 0c             	sub    $0xc,%esp
  8011fb:	68 b0 36 80 00       	push   $0x8036b0
  801200:	e8 55 f2 ff ff       	call   80045a <cprintf>
  801205:	83 c4 10             	add    $0x10,%esp
#if UHP_USE_BUDDY
		initialize_buddy();
		cprintf("BUDDY SYSTEM IS INITIALIZED\n");
#endif
		FirstTimeFlag = 0;
  801208:	c7 05 04 40 80 00 00 	movl   $0x0,0x804004
  80120f:	00 00 00 
	}
}
  801212:	90                   	nop
  801213:	c9                   	leave  
  801214:	c3                   	ret    

00801215 <initialize_dyn_block_system>:

//=================================
// [1] INITIALIZE DYNAMIC ALLOCATOR:
//=================================
void initialize_dyn_block_system()
{
  801215:	55                   	push   %ebp
  801216:	89 e5                	mov    %esp,%ebp
  801218:	83 ec 28             	sub    $0x28,%esp
	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] initialize_dyn_block_system
	// your code is here, remove the panic and write your code
	//panic("initialize_dyn_block_system() is not implemented yet...!!");

	LIST_INIT(&AllocMemBlocksList);
  80121b:	c7 05 40 40 80 00 00 	movl   $0x0,0x804040
  801222:	00 00 00 
  801225:	c7 05 44 40 80 00 00 	movl   $0x0,0x804044
  80122c:	00 00 00 
  80122f:	c7 05 4c 40 80 00 00 	movl   $0x0,0x80404c
  801236:	00 00 00 
	LIST_INIT(&FreeMemBlocksList);
  801239:	c7 05 38 41 80 00 00 	movl   $0x0,0x804138
  801240:	00 00 00 
  801243:	c7 05 3c 41 80 00 00 	movl   $0x0,0x80413c
  80124a:	00 00 00 
  80124d:	c7 05 44 41 80 00 00 	movl   $0x0,0x804144
  801254:	00 00 00 
	MAX_MEM_BLOCK_CNT = NUM_OF_UHEAP_PAGES;
  801257:	c7 05 20 41 80 00 00 	movl   $0x20000,0x804120
  80125e:	00 02 00 
	MemBlockNodes = (void*)USER_DYN_BLKS_ARRAY;
  801261:	c7 45 f4 00 00 e0 7f 	movl   $0x7fe00000,-0xc(%ebp)
  801268:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80126b:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801270:	2d 00 10 00 00       	sub    $0x1000,%eax
  801275:	a3 50 40 80 00       	mov    %eax,0x804050
	int size_of_block = sizeof(struct MemBlock);
  80127a:	c7 45 f0 10 00 00 00 	movl   $0x10,-0x10(%ebp)
	int size_all_struct = size_of_block*MAX_MEM_BLOCK_CNT;
  801281:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801284:	a1 20 41 80 00       	mov    0x804120,%eax
  801289:	0f af c2             	imul   %edx,%eax
  80128c:	89 45 ec             	mov    %eax,-0x14(%ebp)
	size_all_struct = ROUNDUP(size_all_struct, PAGE_SIZE);
  80128f:	c7 45 e8 00 10 00 00 	movl   $0x1000,-0x18(%ebp)
  801296:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801299:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80129c:	01 d0                	add    %edx,%eax
  80129e:	48                   	dec    %eax
  80129f:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8012a2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8012a5:	ba 00 00 00 00       	mov    $0x0,%edx
  8012aa:	f7 75 e8             	divl   -0x18(%ebp)
  8012ad:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8012b0:	29 d0                	sub    %edx,%eax
  8012b2:	89 45 ec             	mov    %eax,-0x14(%ebp)
	sys_allocate_chunk(USER_DYN_BLKS_ARRAY, size_all_struct,PERM_USER| PERM_WRITEABLE);
  8012b5:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8012b8:	c7 45 e0 00 00 e0 7f 	movl   $0x7fe00000,-0x20(%ebp)
  8012bf:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8012c2:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
  8012c8:	81 ea 00 10 00 00    	sub    $0x1000,%edx
  8012ce:	83 ec 04             	sub    $0x4,%esp
  8012d1:	6a 06                	push   $0x6
  8012d3:	50                   	push   %eax
  8012d4:	52                   	push   %edx
  8012d5:	e8 a1 05 00 00       	call   80187b <sys_allocate_chunk>
  8012da:	83 c4 10             	add    $0x10,%esp
	initialize_MemBlocksList(MAX_MEM_BLOCK_CNT);
  8012dd:	a1 20 41 80 00       	mov    0x804120,%eax
  8012e2:	83 ec 0c             	sub    $0xc,%esp
  8012e5:	50                   	push   %eax
  8012e6:	e8 16 0c 00 00       	call   801f01 <initialize_MemBlocksList>
  8012eb:	83 c4 10             	add    $0x10,%esp
	struct MemBlock* ourBlock =LIST_LAST(&AvailableMemBlocksList);
  8012ee:	a1 4c 41 80 00       	mov    0x80414c,%eax
  8012f3:	89 45 dc             	mov    %eax,-0x24(%ebp)
	LIST_REMOVE(&AvailableMemBlocksList,ourBlock);
  8012f6:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  8012fa:	75 14                	jne    801310 <initialize_dyn_block_system+0xfb>
  8012fc:	83 ec 04             	sub    $0x4,%esp
  8012ff:	68 d5 36 80 00       	push   $0x8036d5
  801304:	6a 2d                	push   $0x2d
  801306:	68 f3 36 80 00       	push   $0x8036f3
  80130b:	e8 70 1a 00 00       	call   802d80 <_panic>
  801310:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801313:	8b 00                	mov    (%eax),%eax
  801315:	85 c0                	test   %eax,%eax
  801317:	74 10                	je     801329 <initialize_dyn_block_system+0x114>
  801319:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80131c:	8b 00                	mov    (%eax),%eax
  80131e:	8b 55 dc             	mov    -0x24(%ebp),%edx
  801321:	8b 52 04             	mov    0x4(%edx),%edx
  801324:	89 50 04             	mov    %edx,0x4(%eax)
  801327:	eb 0b                	jmp    801334 <initialize_dyn_block_system+0x11f>
  801329:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80132c:	8b 40 04             	mov    0x4(%eax),%eax
  80132f:	a3 4c 41 80 00       	mov    %eax,0x80414c
  801334:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801337:	8b 40 04             	mov    0x4(%eax),%eax
  80133a:	85 c0                	test   %eax,%eax
  80133c:	74 0f                	je     80134d <initialize_dyn_block_system+0x138>
  80133e:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801341:	8b 40 04             	mov    0x4(%eax),%eax
  801344:	8b 55 dc             	mov    -0x24(%ebp),%edx
  801347:	8b 12                	mov    (%edx),%edx
  801349:	89 10                	mov    %edx,(%eax)
  80134b:	eb 0a                	jmp    801357 <initialize_dyn_block_system+0x142>
  80134d:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801350:	8b 00                	mov    (%eax),%eax
  801352:	a3 48 41 80 00       	mov    %eax,0x804148
  801357:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80135a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  801360:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801363:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80136a:	a1 54 41 80 00       	mov    0x804154,%eax
  80136f:	48                   	dec    %eax
  801370:	a3 54 41 80 00       	mov    %eax,0x804154
	ourBlock->size = USER_HEAP_MAX-USER_HEAP_START;
  801375:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801378:	c7 40 0c 00 00 00 20 	movl   $0x20000000,0xc(%eax)
	ourBlock->sva=USER_HEAP_START;
  80137f:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801382:	c7 40 08 00 00 00 80 	movl   $0x80000000,0x8(%eax)
	LIST_INSERT_TAIL(&FreeMemBlocksList, ourBlock);
  801389:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  80138d:	75 14                	jne    8013a3 <initialize_dyn_block_system+0x18e>
  80138f:	83 ec 04             	sub    $0x4,%esp
  801392:	68 00 37 80 00       	push   $0x803700
  801397:	6a 30                	push   $0x30
  801399:	68 f3 36 80 00       	push   $0x8036f3
  80139e:	e8 dd 19 00 00       	call   802d80 <_panic>
  8013a3:	8b 15 3c 41 80 00    	mov    0x80413c,%edx
  8013a9:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8013ac:	89 50 04             	mov    %edx,0x4(%eax)
  8013af:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8013b2:	8b 40 04             	mov    0x4(%eax),%eax
  8013b5:	85 c0                	test   %eax,%eax
  8013b7:	74 0c                	je     8013c5 <initialize_dyn_block_system+0x1b0>
  8013b9:	a1 3c 41 80 00       	mov    0x80413c,%eax
  8013be:	8b 55 dc             	mov    -0x24(%ebp),%edx
  8013c1:	89 10                	mov    %edx,(%eax)
  8013c3:	eb 08                	jmp    8013cd <initialize_dyn_block_system+0x1b8>
  8013c5:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8013c8:	a3 38 41 80 00       	mov    %eax,0x804138
  8013cd:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8013d0:	a3 3c 41 80 00       	mov    %eax,0x80413c
  8013d5:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8013d8:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8013de:	a1 44 41 80 00       	mov    0x804144,%eax
  8013e3:	40                   	inc    %eax
  8013e4:	a3 44 41 80 00       	mov    %eax,0x804144
	//[1] Initialize two lists (AllocMemBlocksList & FreeMemBlocksList) [Hint: use LIST_INIT()]
	//[2] Dynamically allocate the array of MemBlockNodes at VA USER_DYN_BLKS_ARRAY
	//	  (remember to set MAX_MEM_BLOCK_CNT with the chosen size of the array)
	//[3] Initialize AvailableMemBlocksList by filling it with the MemBlockNodes
	//[4] Insert a new MemBlock with the heap size into the FreeMemBlocksList
}
  8013e9:	90                   	nop
  8013ea:	c9                   	leave  
  8013eb:	c3                   	ret    

008013ec <malloc>:
//=================================
// [2] ALLOCATE SPACE IN USER HEAP:
//=================================

void* malloc(uint32 size)
{
  8013ec:	55                   	push   %ebp
  8013ed:	89 e5                	mov    %esp,%ebp
  8013ef:	83 ec 18             	sub    $0x18,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  8013f2:	e8 ed fd ff ff       	call   8011e4 <InitializeUHeap>
	if (size == 0) return NULL ;
  8013f7:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8013fb:	75 07                	jne    801404 <malloc+0x18>
  8013fd:	b8 00 00 00 00       	mov    $0x0,%eax
  801402:	eb 67                	jmp    80146b <malloc+0x7f>

	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] malloc
	// your code is here, remove the panic and write your code
	//panic("malloc() is not implemented yet...!!");

	size = ROUNDUP(size, PAGE_SIZE);
  801404:	c7 45 f4 00 10 00 00 	movl   $0x1000,-0xc(%ebp)
  80140b:	8b 55 08             	mov    0x8(%ebp),%edx
  80140e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801411:	01 d0                	add    %edx,%eax
  801413:	48                   	dec    %eax
  801414:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801417:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80141a:	ba 00 00 00 00       	mov    $0x0,%edx
  80141f:	f7 75 f4             	divl   -0xc(%ebp)
  801422:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801425:	29 d0                	sub    %edx,%eax
  801427:	89 45 08             	mov    %eax,0x8(%ebp)
	if(sys_isUHeapPlacementStrategyFIRSTFIT())
  80142a:	e8 1a 08 00 00       	call   801c49 <sys_isUHeapPlacementStrategyFIRSTFIT>
  80142f:	85 c0                	test   %eax,%eax
  801431:	74 33                	je     801466 <malloc+0x7a>
	{
		struct MemBlock * myBlock = alloc_block_FF(size);
  801433:	83 ec 0c             	sub    $0xc,%esp
  801436:	ff 75 08             	pushl  0x8(%ebp)
  801439:	e8 0c 0e 00 00       	call   80224a <alloc_block_FF>
  80143e:	83 c4 10             	add    $0x10,%esp
  801441:	89 45 ec             	mov    %eax,-0x14(%ebp)
		if(myBlock != NULL)
  801444:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  801448:	74 1c                	je     801466 <malloc+0x7a>
		{
			insert_sorted_allocList(myBlock);
  80144a:	83 ec 0c             	sub    $0xc,%esp
  80144d:	ff 75 ec             	pushl  -0x14(%ebp)
  801450:	e8 07 0c 00 00       	call   80205c <insert_sorted_allocList>
  801455:	83 c4 10             	add    $0x10,%esp
			uint32 ptr = myBlock->sva;
  801458:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80145b:	8b 40 08             	mov    0x8(%eax),%eax
  80145e:	89 45 e8             	mov    %eax,-0x18(%ebp)
			return (void *)ptr;
  801461:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801464:	eb 05                	jmp    80146b <malloc+0x7f>
		}
	}
	return NULL;
  801466:	b8 00 00 00 00       	mov    $0x0,%eax
	//		to the required allocation size (space should be on 4 KB BOUNDARY)
	//	2) if no suitable space found, return NULL
	// 	3) Return pointer containing the virtual address of allocated space,
	//
	//Use sys_isUHeapPlacementStrategyFIRSTFIT()... to check the current strategy
}
  80146b:	c9                   	leave  
  80146c:	c3                   	ret    

0080146d <free>:
//	We can use sys_free_user_mem(uint32 virtual_address, uint32 size); which
//		switches to the kernel mode, calls free_user_mem() in
//		"kern/mem/chunk_operations.c", then switch back to the user mode here
//	the free_user_mem function is empty, make sure to implement it.
void free(void* virtual_address)
{
  80146d:	55                   	push   %ebp
  80146e:	89 e5                	mov    %esp,%ebp
  801470:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] free
	// your code is here, remove the panic and write your code
	//panic("free() is not implemented yet...!!");

	uint32 virtualAddress = (uint32 )(virtual_address);
  801473:	8b 45 08             	mov    0x8(%ebp),%eax
  801476:	89 45 f4             	mov    %eax,-0xc(%ebp)
//	virtualAddress = ROUNDDOWN(virtualAddress, PAGE_SIZE);
	struct MemBlock * myBlock = find_block(&AllocMemBlocksList, virtualAddress);
  801479:	83 ec 08             	sub    $0x8,%esp
  80147c:	ff 75 f4             	pushl  -0xc(%ebp)
  80147f:	68 40 40 80 00       	push   $0x804040
  801484:	e8 5b 0b 00 00       	call   801fe4 <find_block>
  801489:	83 c4 10             	add    $0x10,%esp
  80148c:	89 45 f0             	mov    %eax,-0x10(%ebp)
//	cprintf ("ptr sva at free user side = %x \n", myBlock->sva);
	sys_free_user_mem(virtualAddress, myBlock->size);
  80148f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801492:	8b 40 0c             	mov    0xc(%eax),%eax
  801495:	83 ec 08             	sub    $0x8,%esp
  801498:	50                   	push   %eax
  801499:	ff 75 f4             	pushl  -0xc(%ebp)
  80149c:	e8 a2 03 00 00       	call   801843 <sys_free_user_mem>
  8014a1:	83 c4 10             	add    $0x10,%esp
	LIST_REMOVE(&AllocMemBlocksList, myBlock);
  8014a4:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8014a8:	75 14                	jne    8014be <free+0x51>
  8014aa:	83 ec 04             	sub    $0x4,%esp
  8014ad:	68 d5 36 80 00       	push   $0x8036d5
  8014b2:	6a 76                	push   $0x76
  8014b4:	68 f3 36 80 00       	push   $0x8036f3
  8014b9:	e8 c2 18 00 00       	call   802d80 <_panic>
  8014be:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8014c1:	8b 00                	mov    (%eax),%eax
  8014c3:	85 c0                	test   %eax,%eax
  8014c5:	74 10                	je     8014d7 <free+0x6a>
  8014c7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8014ca:	8b 00                	mov    (%eax),%eax
  8014cc:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8014cf:	8b 52 04             	mov    0x4(%edx),%edx
  8014d2:	89 50 04             	mov    %edx,0x4(%eax)
  8014d5:	eb 0b                	jmp    8014e2 <free+0x75>
  8014d7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8014da:	8b 40 04             	mov    0x4(%eax),%eax
  8014dd:	a3 44 40 80 00       	mov    %eax,0x804044
  8014e2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8014e5:	8b 40 04             	mov    0x4(%eax),%eax
  8014e8:	85 c0                	test   %eax,%eax
  8014ea:	74 0f                	je     8014fb <free+0x8e>
  8014ec:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8014ef:	8b 40 04             	mov    0x4(%eax),%eax
  8014f2:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8014f5:	8b 12                	mov    (%edx),%edx
  8014f7:	89 10                	mov    %edx,(%eax)
  8014f9:	eb 0a                	jmp    801505 <free+0x98>
  8014fb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8014fe:	8b 00                	mov    (%eax),%eax
  801500:	a3 40 40 80 00       	mov    %eax,0x804040
  801505:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801508:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80150e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801511:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  801518:	a1 4c 40 80 00       	mov    0x80404c,%eax
  80151d:	48                   	dec    %eax
  80151e:	a3 4c 40 80 00       	mov    %eax,0x80404c
	insert_sorted_with_merge_freeList(myBlock);
  801523:	83 ec 0c             	sub    $0xc,%esp
  801526:	ff 75 f0             	pushl  -0x10(%ebp)
  801529:	e8 0b 14 00 00       	call   802939 <insert_sorted_with_merge_freeList>
  80152e:	83 c4 10             	add    $0x10,%esp

	//you should get the size of the given allocation using its address
	//you need to call sys_free_user_mem()
	//refer to the project presentation and documentation for details
}
  801531:	90                   	nop
  801532:	c9                   	leave  
  801533:	c3                   	ret    

00801534 <smalloc>:

//=================================
// [4] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
  801534:	55                   	push   %ebp
  801535:	89 e5                	mov    %esp,%ebp
  801537:	83 ec 28             	sub    $0x28,%esp
  80153a:	8b 45 10             	mov    0x10(%ebp),%eax
  80153d:	88 45 e4             	mov    %al,-0x1c(%ebp)
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801540:	e8 9f fc ff ff       	call   8011e4 <InitializeUHeap>
	if (size == 0) return NULL ;
  801545:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801549:	75 0a                	jne    801555 <smalloc+0x21>
  80154b:	b8 00 00 00 00       	mov    $0x0,%eax
  801550:	e9 8d 00 00 00       	jmp    8015e2 <smalloc+0xae>

	//This function should find the space of the required range
	// * ON 4KB BOUNDARY **** //
	//Use sys_isUHeapPlacementStrategyFIRSTFIT() to check the current strategy

	size = ROUNDUP(size, PAGE_SIZE);
  801555:	c7 45 f4 00 10 00 00 	movl   $0x1000,-0xc(%ebp)
  80155c:	8b 55 0c             	mov    0xc(%ebp),%edx
  80155f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801562:	01 d0                	add    %edx,%eax
  801564:	48                   	dec    %eax
  801565:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801568:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80156b:	ba 00 00 00 00       	mov    $0x0,%edx
  801570:	f7 75 f4             	divl   -0xc(%ebp)
  801573:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801576:	29 d0                	sub    %edx,%eax
  801578:	89 45 0c             	mov    %eax,0xc(%ebp)
		if(sys_isUHeapPlacementStrategyFIRSTFIT())
  80157b:	e8 c9 06 00 00       	call   801c49 <sys_isUHeapPlacementStrategyFIRSTFIT>
  801580:	85 c0                	test   %eax,%eax
  801582:	74 59                	je     8015dd <smalloc+0xa9>
		{
			struct MemBlock * v1=NULL;
  801584:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
			v1= alloc_block_FF(size);
  80158b:	83 ec 0c             	sub    $0xc,%esp
  80158e:	ff 75 0c             	pushl  0xc(%ebp)
  801591:	e8 b4 0c 00 00       	call   80224a <alloc_block_FF>
  801596:	83 c4 10             	add    $0x10,%esp
  801599:	89 45 ec             	mov    %eax,-0x14(%ebp)
			if(v1==NULL)
  80159c:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8015a0:	75 07                	jne    8015a9 <smalloc+0x75>
			{
				return NULL;
  8015a2:	b8 00 00 00 00       	mov    $0x0,%eax
  8015a7:	eb 39                	jmp    8015e2 <smalloc+0xae>
			}
			else
			{
				int ret=sys_createSharedObject(sharedVarName,  size,  isWritable,(void*)v1->sva);
  8015a9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8015ac:	8b 40 08             	mov    0x8(%eax),%eax
  8015af:	89 c2                	mov    %eax,%edx
  8015b1:	0f b6 45 e4          	movzbl -0x1c(%ebp),%eax
  8015b5:	52                   	push   %edx
  8015b6:	50                   	push   %eax
  8015b7:	ff 75 0c             	pushl  0xc(%ebp)
  8015ba:	ff 75 08             	pushl  0x8(%ebp)
  8015bd:	e8 0c 04 00 00       	call   8019ce <sys_createSharedObject>
  8015c2:	83 c4 10             	add    $0x10,%esp
  8015c5:	89 45 e8             	mov    %eax,-0x18(%ebp)
				if(ret>=0)
  8015c8:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8015cc:	78 08                	js     8015d6 <smalloc+0xa2>
				{
					return (void*)v1->sva;
  8015ce:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8015d1:	8b 40 08             	mov    0x8(%eax),%eax
  8015d4:	eb 0c                	jmp    8015e2 <smalloc+0xae>
				}
				else
				{
					return NULL;
  8015d6:	b8 00 00 00 00       	mov    $0x0,%eax
  8015db:	eb 05                	jmp    8015e2 <smalloc+0xae>
				}
			}

		}
		return NULL;
  8015dd:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8015e2:	c9                   	leave  
  8015e3:	c3                   	ret    

008015e4 <sget>:

//========================================
// [5] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  8015e4:	55                   	push   %ebp
  8015e5:	89 e5                	mov    %esp,%ebp
  8015e7:	83 ec 18             	sub    $0x18,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  8015ea:	e8 f5 fb ff ff       	call   8011e4 <InitializeUHeap>

	//This function should find the space for sharing the variable
	// *** ON 4KB BOUNDARY ******** //

	//Use sys_isUHeapPlacementStrategyFIRSTFIT() to check the current strategy
	int ret=sys_getSizeOfSharedObject(ownerEnvID,sharedVarName);
  8015ef:	83 ec 08             	sub    $0x8,%esp
  8015f2:	ff 75 0c             	pushl  0xc(%ebp)
  8015f5:	ff 75 08             	pushl  0x8(%ebp)
  8015f8:	e8 fb 03 00 00       	call   8019f8 <sys_getSizeOfSharedObject>
  8015fd:	83 c4 10             	add    $0x10,%esp
  801600:	89 45 f4             	mov    %eax,-0xc(%ebp)
	if(ret==0)
  801603:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801607:	75 07                	jne    801610 <sget+0x2c>
	{
		return NULL;
  801609:	b8 00 00 00 00       	mov    $0x0,%eax
  80160e:	eb 64                	jmp    801674 <sget+0x90>
	}
	if(sys_isUHeapPlacementStrategyFIRSTFIT())
  801610:	e8 34 06 00 00       	call   801c49 <sys_isUHeapPlacementStrategyFIRSTFIT>
  801615:	85 c0                	test   %eax,%eax
  801617:	74 56                	je     80166f <sget+0x8b>
	{
		struct MemBlock * v1=NULL;
  801619:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
		v1= alloc_block_FF(ret);
  801620:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801623:	83 ec 0c             	sub    $0xc,%esp
  801626:	50                   	push   %eax
  801627:	e8 1e 0c 00 00       	call   80224a <alloc_block_FF>
  80162c:	83 c4 10             	add    $0x10,%esp
  80162f:	89 45 f0             	mov    %eax,-0x10(%ebp)
		if(v1==NULL)
  801632:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801636:	75 07                	jne    80163f <sget+0x5b>
		{
		return NULL;
  801638:	b8 00 00 00 00       	mov    $0x0,%eax
  80163d:	eb 35                	jmp    801674 <sget+0x90>
	    }
		else
		{
			int ret1=sys_getSharedObject(ownerEnvID,sharedVarName,(void*)v1->sva);
  80163f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801642:	8b 40 08             	mov    0x8(%eax),%eax
  801645:	83 ec 04             	sub    $0x4,%esp
  801648:	50                   	push   %eax
  801649:	ff 75 0c             	pushl  0xc(%ebp)
  80164c:	ff 75 08             	pushl  0x8(%ebp)
  80164f:	e8 c1 03 00 00       	call   801a15 <sys_getSharedObject>
  801654:	83 c4 10             	add    $0x10,%esp
  801657:	89 45 ec             	mov    %eax,-0x14(%ebp)
			if(ret1>=0)
  80165a:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  80165e:	78 08                	js     801668 <sget+0x84>
			{
				return (void*)v1->sva;
  801660:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801663:	8b 40 08             	mov    0x8(%eax),%eax
  801666:	eb 0c                	jmp    801674 <sget+0x90>
			}
			else
			{
				return NULL;
  801668:	b8 00 00 00 00       	mov    $0x0,%eax
  80166d:	eb 05                	jmp    801674 <sget+0x90>
			}
		}
	}
  return NULL;
  80166f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801674:	c9                   	leave  
  801675:	c3                   	ret    

00801676 <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  801676:	55                   	push   %ebp
  801677:	89 e5                	mov    %esp,%ebp
  801679:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  80167c:	e8 63 fb ff ff       	call   8011e4 <InitializeUHeap>
	//==============================================================
	// [USER HEAP - USER SIDE] realloc
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  801681:	83 ec 04             	sub    $0x4,%esp
  801684:	68 24 37 80 00       	push   $0x803724
  801689:	68 0e 01 00 00       	push   $0x10e
  80168e:	68 f3 36 80 00       	push   $0x8036f3
  801693:	e8 e8 16 00 00       	call   802d80 <_panic>

00801698 <sfree>:
//	use sys_freeSharedObject(...); which switches to the kernel mode,
//	calls freeSharedObject(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the freeSharedObject() function is empty, make sure to implement it.

void sfree(void* virtual_address)
{
  801698:	55                   	push   %ebp
  801699:	89 e5                	mov    %esp,%ebp
  80169b:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS3 - BONUS] [SHARING - USER SIDE] sfree()

	// Write your code here, remove the panic and write your code
	panic("sfree() is not implemented yet...!!");
  80169e:	83 ec 04             	sub    $0x4,%esp
  8016a1:	68 4c 37 80 00       	push   $0x80374c
  8016a6:	68 22 01 00 00       	push   $0x122
  8016ab:	68 f3 36 80 00       	push   $0x8036f3
  8016b0:	e8 cb 16 00 00       	call   802d80 <_panic>

008016b5 <expand>:

//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//
void expand(uint32 newSize)
{
  8016b5:	55                   	push   %ebp
  8016b6:	89 e5                	mov    %esp,%ebp
  8016b8:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  8016bb:	83 ec 04             	sub    $0x4,%esp
  8016be:	68 70 37 80 00       	push   $0x803770
  8016c3:	68 2d 01 00 00       	push   $0x12d
  8016c8:	68 f3 36 80 00       	push   $0x8036f3
  8016cd:	e8 ae 16 00 00       	call   802d80 <_panic>

008016d2 <shrink>:

}
void shrink(uint32 newSize)
{
  8016d2:	55                   	push   %ebp
  8016d3:	89 e5                	mov    %esp,%ebp
  8016d5:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  8016d8:	83 ec 04             	sub    $0x4,%esp
  8016db:	68 70 37 80 00       	push   $0x803770
  8016e0:	68 32 01 00 00       	push   $0x132
  8016e5:	68 f3 36 80 00       	push   $0x8036f3
  8016ea:	e8 91 16 00 00       	call   802d80 <_panic>

008016ef <freeHeap>:

}
void freeHeap(void* virtual_address)
{
  8016ef:	55                   	push   %ebp
  8016f0:	89 e5                	mov    %esp,%ebp
  8016f2:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  8016f5:	83 ec 04             	sub    $0x4,%esp
  8016f8:	68 70 37 80 00       	push   $0x803770
  8016fd:	68 37 01 00 00       	push   $0x137
  801702:	68 f3 36 80 00       	push   $0x8036f3
  801707:	e8 74 16 00 00       	call   802d80 <_panic>

0080170c <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  80170c:	55                   	push   %ebp
  80170d:	89 e5                	mov    %esp,%ebp
  80170f:	57                   	push   %edi
  801710:	56                   	push   %esi
  801711:	53                   	push   %ebx
  801712:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801715:	8b 45 08             	mov    0x8(%ebp),%eax
  801718:	8b 55 0c             	mov    0xc(%ebp),%edx
  80171b:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80171e:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801721:	8b 7d 18             	mov    0x18(%ebp),%edi
  801724:	8b 75 1c             	mov    0x1c(%ebp),%esi
  801727:	cd 30                	int    $0x30
  801729:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  80172c:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  80172f:	83 c4 10             	add    $0x10,%esp
  801732:	5b                   	pop    %ebx
  801733:	5e                   	pop    %esi
  801734:	5f                   	pop    %edi
  801735:	5d                   	pop    %ebp
  801736:	c3                   	ret    

00801737 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  801737:	55                   	push   %ebp
  801738:	89 e5                	mov    %esp,%ebp
  80173a:	83 ec 04             	sub    $0x4,%esp
  80173d:	8b 45 10             	mov    0x10(%ebp),%eax
  801740:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  801743:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801747:	8b 45 08             	mov    0x8(%ebp),%eax
  80174a:	6a 00                	push   $0x0
  80174c:	6a 00                	push   $0x0
  80174e:	52                   	push   %edx
  80174f:	ff 75 0c             	pushl  0xc(%ebp)
  801752:	50                   	push   %eax
  801753:	6a 00                	push   $0x0
  801755:	e8 b2 ff ff ff       	call   80170c <syscall>
  80175a:	83 c4 18             	add    $0x18,%esp
}
  80175d:	90                   	nop
  80175e:	c9                   	leave  
  80175f:	c3                   	ret    

00801760 <sys_cgetc>:

int
sys_cgetc(void)
{
  801760:	55                   	push   %ebp
  801761:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  801763:	6a 00                	push   $0x0
  801765:	6a 00                	push   $0x0
  801767:	6a 00                	push   $0x0
  801769:	6a 00                	push   $0x0
  80176b:	6a 00                	push   $0x0
  80176d:	6a 01                	push   $0x1
  80176f:	e8 98 ff ff ff       	call   80170c <syscall>
  801774:	83 c4 18             	add    $0x18,%esp
}
  801777:	c9                   	leave  
  801778:	c3                   	ret    

00801779 <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  801779:	55                   	push   %ebp
  80177a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  80177c:	8b 55 0c             	mov    0xc(%ebp),%edx
  80177f:	8b 45 08             	mov    0x8(%ebp),%eax
  801782:	6a 00                	push   $0x0
  801784:	6a 00                	push   $0x0
  801786:	6a 00                	push   $0x0
  801788:	52                   	push   %edx
  801789:	50                   	push   %eax
  80178a:	6a 05                	push   $0x5
  80178c:	e8 7b ff ff ff       	call   80170c <syscall>
  801791:	83 c4 18             	add    $0x18,%esp
}
  801794:	c9                   	leave  
  801795:	c3                   	ret    

00801796 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  801796:	55                   	push   %ebp
  801797:	89 e5                	mov    %esp,%ebp
  801799:	56                   	push   %esi
  80179a:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  80179b:	8b 75 18             	mov    0x18(%ebp),%esi
  80179e:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8017a1:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8017a4:	8b 55 0c             	mov    0xc(%ebp),%edx
  8017a7:	8b 45 08             	mov    0x8(%ebp),%eax
  8017aa:	56                   	push   %esi
  8017ab:	53                   	push   %ebx
  8017ac:	51                   	push   %ecx
  8017ad:	52                   	push   %edx
  8017ae:	50                   	push   %eax
  8017af:	6a 06                	push   $0x6
  8017b1:	e8 56 ff ff ff       	call   80170c <syscall>
  8017b6:	83 c4 18             	add    $0x18,%esp
}
  8017b9:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8017bc:	5b                   	pop    %ebx
  8017bd:	5e                   	pop    %esi
  8017be:	5d                   	pop    %ebp
  8017bf:	c3                   	ret    

008017c0 <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  8017c0:	55                   	push   %ebp
  8017c1:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  8017c3:	8b 55 0c             	mov    0xc(%ebp),%edx
  8017c6:	8b 45 08             	mov    0x8(%ebp),%eax
  8017c9:	6a 00                	push   $0x0
  8017cb:	6a 00                	push   $0x0
  8017cd:	6a 00                	push   $0x0
  8017cf:	52                   	push   %edx
  8017d0:	50                   	push   %eax
  8017d1:	6a 07                	push   $0x7
  8017d3:	e8 34 ff ff ff       	call   80170c <syscall>
  8017d8:	83 c4 18             	add    $0x18,%esp
}
  8017db:	c9                   	leave  
  8017dc:	c3                   	ret    

008017dd <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  8017dd:	55                   	push   %ebp
  8017de:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  8017e0:	6a 00                	push   $0x0
  8017e2:	6a 00                	push   $0x0
  8017e4:	6a 00                	push   $0x0
  8017e6:	ff 75 0c             	pushl  0xc(%ebp)
  8017e9:	ff 75 08             	pushl  0x8(%ebp)
  8017ec:	6a 08                	push   $0x8
  8017ee:	e8 19 ff ff ff       	call   80170c <syscall>
  8017f3:	83 c4 18             	add    $0x18,%esp
}
  8017f6:	c9                   	leave  
  8017f7:	c3                   	ret    

008017f8 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  8017f8:	55                   	push   %ebp
  8017f9:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  8017fb:	6a 00                	push   $0x0
  8017fd:	6a 00                	push   $0x0
  8017ff:	6a 00                	push   $0x0
  801801:	6a 00                	push   $0x0
  801803:	6a 00                	push   $0x0
  801805:	6a 09                	push   $0x9
  801807:	e8 00 ff ff ff       	call   80170c <syscall>
  80180c:	83 c4 18             	add    $0x18,%esp
}
  80180f:	c9                   	leave  
  801810:	c3                   	ret    

00801811 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  801811:	55                   	push   %ebp
  801812:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  801814:	6a 00                	push   $0x0
  801816:	6a 00                	push   $0x0
  801818:	6a 00                	push   $0x0
  80181a:	6a 00                	push   $0x0
  80181c:	6a 00                	push   $0x0
  80181e:	6a 0a                	push   $0xa
  801820:	e8 e7 fe ff ff       	call   80170c <syscall>
  801825:	83 c4 18             	add    $0x18,%esp
}
  801828:	c9                   	leave  
  801829:	c3                   	ret    

0080182a <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  80182a:	55                   	push   %ebp
  80182b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  80182d:	6a 00                	push   $0x0
  80182f:	6a 00                	push   $0x0
  801831:	6a 00                	push   $0x0
  801833:	6a 00                	push   $0x0
  801835:	6a 00                	push   $0x0
  801837:	6a 0b                	push   $0xb
  801839:	e8 ce fe ff ff       	call   80170c <syscall>
  80183e:	83 c4 18             	add    $0x18,%esp
}
  801841:	c9                   	leave  
  801842:	c3                   	ret    

00801843 <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  801843:	55                   	push   %ebp
  801844:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  801846:	6a 00                	push   $0x0
  801848:	6a 00                	push   $0x0
  80184a:	6a 00                	push   $0x0
  80184c:	ff 75 0c             	pushl  0xc(%ebp)
  80184f:	ff 75 08             	pushl  0x8(%ebp)
  801852:	6a 0f                	push   $0xf
  801854:	e8 b3 fe ff ff       	call   80170c <syscall>
  801859:	83 c4 18             	add    $0x18,%esp
	return;
  80185c:	90                   	nop
}
  80185d:	c9                   	leave  
  80185e:	c3                   	ret    

0080185f <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  80185f:	55                   	push   %ebp
  801860:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  801862:	6a 00                	push   $0x0
  801864:	6a 00                	push   $0x0
  801866:	6a 00                	push   $0x0
  801868:	ff 75 0c             	pushl  0xc(%ebp)
  80186b:	ff 75 08             	pushl  0x8(%ebp)
  80186e:	6a 10                	push   $0x10
  801870:	e8 97 fe ff ff       	call   80170c <syscall>
  801875:	83 c4 18             	add    $0x18,%esp
	return ;
  801878:	90                   	nop
}
  801879:	c9                   	leave  
  80187a:	c3                   	ret    

0080187b <sys_allocate_chunk>:

void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  80187b:	55                   	push   %ebp
  80187c:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  80187e:	6a 00                	push   $0x0
  801880:	6a 00                	push   $0x0
  801882:	ff 75 10             	pushl  0x10(%ebp)
  801885:	ff 75 0c             	pushl  0xc(%ebp)
  801888:	ff 75 08             	pushl  0x8(%ebp)
  80188b:	6a 11                	push   $0x11
  80188d:	e8 7a fe ff ff       	call   80170c <syscall>
  801892:	83 c4 18             	add    $0x18,%esp
	return ;
  801895:	90                   	nop
}
  801896:	c9                   	leave  
  801897:	c3                   	ret    

00801898 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  801898:	55                   	push   %ebp
  801899:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  80189b:	6a 00                	push   $0x0
  80189d:	6a 00                	push   $0x0
  80189f:	6a 00                	push   $0x0
  8018a1:	6a 00                	push   $0x0
  8018a3:	6a 00                	push   $0x0
  8018a5:	6a 0c                	push   $0xc
  8018a7:	e8 60 fe ff ff       	call   80170c <syscall>
  8018ac:	83 c4 18             	add    $0x18,%esp
}
  8018af:	c9                   	leave  
  8018b0:	c3                   	ret    

008018b1 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  8018b1:	55                   	push   %ebp
  8018b2:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  8018b4:	6a 00                	push   $0x0
  8018b6:	6a 00                	push   $0x0
  8018b8:	6a 00                	push   $0x0
  8018ba:	6a 00                	push   $0x0
  8018bc:	ff 75 08             	pushl  0x8(%ebp)
  8018bf:	6a 0d                	push   $0xd
  8018c1:	e8 46 fe ff ff       	call   80170c <syscall>
  8018c6:	83 c4 18             	add    $0x18,%esp
}
  8018c9:	c9                   	leave  
  8018ca:	c3                   	ret    

008018cb <sys_scarce_memory>:

void sys_scarce_memory()
{
  8018cb:	55                   	push   %ebp
  8018cc:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  8018ce:	6a 00                	push   $0x0
  8018d0:	6a 00                	push   $0x0
  8018d2:	6a 00                	push   $0x0
  8018d4:	6a 00                	push   $0x0
  8018d6:	6a 00                	push   $0x0
  8018d8:	6a 0e                	push   $0xe
  8018da:	e8 2d fe ff ff       	call   80170c <syscall>
  8018df:	83 c4 18             	add    $0x18,%esp
}
  8018e2:	90                   	nop
  8018e3:	c9                   	leave  
  8018e4:	c3                   	ret    

008018e5 <sys_disable_interrupt>:

//NEW !! 2012...
void
sys_disable_interrupt()
{
  8018e5:	55                   	push   %ebp
  8018e6:	89 e5                	mov    %esp,%ebp
	syscall(SYS_disableINTR,0, 0, 0, 0, 0);
  8018e8:	6a 00                	push   $0x0
  8018ea:	6a 00                	push   $0x0
  8018ec:	6a 00                	push   $0x0
  8018ee:	6a 00                	push   $0x0
  8018f0:	6a 00                	push   $0x0
  8018f2:	6a 13                	push   $0x13
  8018f4:	e8 13 fe ff ff       	call   80170c <syscall>
  8018f9:	83 c4 18             	add    $0x18,%esp
}
  8018fc:	90                   	nop
  8018fd:	c9                   	leave  
  8018fe:	c3                   	ret    

008018ff <sys_enable_interrupt>:


void
sys_enable_interrupt()
{
  8018ff:	55                   	push   %ebp
  801900:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enableINTR,0, 0, 0, 0, 0);
  801902:	6a 00                	push   $0x0
  801904:	6a 00                	push   $0x0
  801906:	6a 00                	push   $0x0
  801908:	6a 00                	push   $0x0
  80190a:	6a 00                	push   $0x0
  80190c:	6a 14                	push   $0x14
  80190e:	e8 f9 fd ff ff       	call   80170c <syscall>
  801913:	83 c4 18             	add    $0x18,%esp
}
  801916:	90                   	nop
  801917:	c9                   	leave  
  801918:	c3                   	ret    

00801919 <sys_cputc>:


void
sys_cputc(const char c)
{
  801919:	55                   	push   %ebp
  80191a:	89 e5                	mov    %esp,%ebp
  80191c:	83 ec 04             	sub    $0x4,%esp
  80191f:	8b 45 08             	mov    0x8(%ebp),%eax
  801922:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  801925:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801929:	6a 00                	push   $0x0
  80192b:	6a 00                	push   $0x0
  80192d:	6a 00                	push   $0x0
  80192f:	6a 00                	push   $0x0
  801931:	50                   	push   %eax
  801932:	6a 15                	push   $0x15
  801934:	e8 d3 fd ff ff       	call   80170c <syscall>
  801939:	83 c4 18             	add    $0x18,%esp
}
  80193c:	90                   	nop
  80193d:	c9                   	leave  
  80193e:	c3                   	ret    

0080193f <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  80193f:	55                   	push   %ebp
  801940:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  801942:	6a 00                	push   $0x0
  801944:	6a 00                	push   $0x0
  801946:	6a 00                	push   $0x0
  801948:	6a 00                	push   $0x0
  80194a:	6a 00                	push   $0x0
  80194c:	6a 16                	push   $0x16
  80194e:	e8 b9 fd ff ff       	call   80170c <syscall>
  801953:	83 c4 18             	add    $0x18,%esp
}
  801956:	90                   	nop
  801957:	c9                   	leave  
  801958:	c3                   	ret    

00801959 <sys_createSemaphore>:

int
sys_createSemaphore(char* semaphoreName, uint32 initialValue)
{
  801959:	55                   	push   %ebp
  80195a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_semaphore,(uint32)semaphoreName, (uint32)initialValue, 0, 0, 0);
  80195c:	8b 45 08             	mov    0x8(%ebp),%eax
  80195f:	6a 00                	push   $0x0
  801961:	6a 00                	push   $0x0
  801963:	6a 00                	push   $0x0
  801965:	ff 75 0c             	pushl  0xc(%ebp)
  801968:	50                   	push   %eax
  801969:	6a 17                	push   $0x17
  80196b:	e8 9c fd ff ff       	call   80170c <syscall>
  801970:	83 c4 18             	add    $0x18,%esp
}
  801973:	c9                   	leave  
  801974:	c3                   	ret    

00801975 <sys_getSemaphoreValue>:

int
sys_getSemaphoreValue(int32 ownerEnvID, char* semaphoreName)
{
  801975:	55                   	push   %ebp
  801976:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_semaphore_value,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801978:	8b 55 0c             	mov    0xc(%ebp),%edx
  80197b:	8b 45 08             	mov    0x8(%ebp),%eax
  80197e:	6a 00                	push   $0x0
  801980:	6a 00                	push   $0x0
  801982:	6a 00                	push   $0x0
  801984:	52                   	push   %edx
  801985:	50                   	push   %eax
  801986:	6a 1a                	push   $0x1a
  801988:	e8 7f fd ff ff       	call   80170c <syscall>
  80198d:	83 c4 18             	add    $0x18,%esp
}
  801990:	c9                   	leave  
  801991:	c3                   	ret    

00801992 <sys_waitSemaphore>:

void
sys_waitSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801992:	55                   	push   %ebp
  801993:	89 e5                	mov    %esp,%ebp
	syscall(SYS_wait_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801995:	8b 55 0c             	mov    0xc(%ebp),%edx
  801998:	8b 45 08             	mov    0x8(%ebp),%eax
  80199b:	6a 00                	push   $0x0
  80199d:	6a 00                	push   $0x0
  80199f:	6a 00                	push   $0x0
  8019a1:	52                   	push   %edx
  8019a2:	50                   	push   %eax
  8019a3:	6a 18                	push   $0x18
  8019a5:	e8 62 fd ff ff       	call   80170c <syscall>
  8019aa:	83 c4 18             	add    $0x18,%esp
}
  8019ad:	90                   	nop
  8019ae:	c9                   	leave  
  8019af:	c3                   	ret    

008019b0 <sys_signalSemaphore>:

void
sys_signalSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  8019b0:	55                   	push   %ebp
  8019b1:	89 e5                	mov    %esp,%ebp
	syscall(SYS_signal_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  8019b3:	8b 55 0c             	mov    0xc(%ebp),%edx
  8019b6:	8b 45 08             	mov    0x8(%ebp),%eax
  8019b9:	6a 00                	push   $0x0
  8019bb:	6a 00                	push   $0x0
  8019bd:	6a 00                	push   $0x0
  8019bf:	52                   	push   %edx
  8019c0:	50                   	push   %eax
  8019c1:	6a 19                	push   $0x19
  8019c3:	e8 44 fd ff ff       	call   80170c <syscall>
  8019c8:	83 c4 18             	add    $0x18,%esp
}
  8019cb:	90                   	nop
  8019cc:	c9                   	leave  
  8019cd:	c3                   	ret    

008019ce <sys_createSharedObject>:

int
sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  8019ce:	55                   	push   %ebp
  8019cf:	89 e5                	mov    %esp,%ebp
  8019d1:	83 ec 04             	sub    $0x4,%esp
  8019d4:	8b 45 10             	mov    0x10(%ebp),%eax
  8019d7:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  8019da:	8b 4d 14             	mov    0x14(%ebp),%ecx
  8019dd:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  8019e1:	8b 45 08             	mov    0x8(%ebp),%eax
  8019e4:	6a 00                	push   $0x0
  8019e6:	51                   	push   %ecx
  8019e7:	52                   	push   %edx
  8019e8:	ff 75 0c             	pushl  0xc(%ebp)
  8019eb:	50                   	push   %eax
  8019ec:	6a 1b                	push   $0x1b
  8019ee:	e8 19 fd ff ff       	call   80170c <syscall>
  8019f3:	83 c4 18             	add    $0x18,%esp
}
  8019f6:	c9                   	leave  
  8019f7:	c3                   	ret    

008019f8 <sys_getSizeOfSharedObject>:

//2017:
int
sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  8019f8:	55                   	push   %ebp
  8019f9:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  8019fb:	8b 55 0c             	mov    0xc(%ebp),%edx
  8019fe:	8b 45 08             	mov    0x8(%ebp),%eax
  801a01:	6a 00                	push   $0x0
  801a03:	6a 00                	push   $0x0
  801a05:	6a 00                	push   $0x0
  801a07:	52                   	push   %edx
  801a08:	50                   	push   %eax
  801a09:	6a 1c                	push   $0x1c
  801a0b:	e8 fc fc ff ff       	call   80170c <syscall>
  801a10:	83 c4 18             	add    $0x18,%esp
}
  801a13:	c9                   	leave  
  801a14:	c3                   	ret    

00801a15 <sys_getSharedObject>:
//==========

int
sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  801a15:	55                   	push   %ebp
  801a16:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  801a18:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801a1b:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a1e:	8b 45 08             	mov    0x8(%ebp),%eax
  801a21:	6a 00                	push   $0x0
  801a23:	6a 00                	push   $0x0
  801a25:	51                   	push   %ecx
  801a26:	52                   	push   %edx
  801a27:	50                   	push   %eax
  801a28:	6a 1d                	push   $0x1d
  801a2a:	e8 dd fc ff ff       	call   80170c <syscall>
  801a2f:	83 c4 18             	add    $0x18,%esp
}
  801a32:	c9                   	leave  
  801a33:	c3                   	ret    

00801a34 <sys_freeSharedObject>:

int
sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  801a34:	55                   	push   %ebp
  801a35:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  801a37:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a3a:	8b 45 08             	mov    0x8(%ebp),%eax
  801a3d:	6a 00                	push   $0x0
  801a3f:	6a 00                	push   $0x0
  801a41:	6a 00                	push   $0x0
  801a43:	52                   	push   %edx
  801a44:	50                   	push   %eax
  801a45:	6a 1e                	push   $0x1e
  801a47:	e8 c0 fc ff ff       	call   80170c <syscall>
  801a4c:	83 c4 18             	add    $0x18,%esp
}
  801a4f:	c9                   	leave  
  801a50:	c3                   	ret    

00801a51 <sys_getMaxShares>:

uint32 	sys_getMaxShares()
{
  801a51:	55                   	push   %ebp
  801a52:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_max_shares,0, 0, 0, 0, 0);
  801a54:	6a 00                	push   $0x0
  801a56:	6a 00                	push   $0x0
  801a58:	6a 00                	push   $0x0
  801a5a:	6a 00                	push   $0x0
  801a5c:	6a 00                	push   $0x0
  801a5e:	6a 1f                	push   $0x1f
  801a60:	e8 a7 fc ff ff       	call   80170c <syscall>
  801a65:	83 c4 18             	add    $0x18,%esp
}
  801a68:	c9                   	leave  
  801a69:	c3                   	ret    

00801a6a <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  801a6a:	55                   	push   %ebp
  801a6b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  801a6d:	8b 45 08             	mov    0x8(%ebp),%eax
  801a70:	6a 00                	push   $0x0
  801a72:	ff 75 14             	pushl  0x14(%ebp)
  801a75:	ff 75 10             	pushl  0x10(%ebp)
  801a78:	ff 75 0c             	pushl  0xc(%ebp)
  801a7b:	50                   	push   %eax
  801a7c:	6a 20                	push   $0x20
  801a7e:	e8 89 fc ff ff       	call   80170c <syscall>
  801a83:	83 c4 18             	add    $0x18,%esp
}
  801a86:	c9                   	leave  
  801a87:	c3                   	ret    

00801a88 <sys_run_env>:

void
sys_run_env(int32 envId)
{
  801a88:	55                   	push   %ebp
  801a89:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  801a8b:	8b 45 08             	mov    0x8(%ebp),%eax
  801a8e:	6a 00                	push   $0x0
  801a90:	6a 00                	push   $0x0
  801a92:	6a 00                	push   $0x0
  801a94:	6a 00                	push   $0x0
  801a96:	50                   	push   %eax
  801a97:	6a 21                	push   $0x21
  801a99:	e8 6e fc ff ff       	call   80170c <syscall>
  801a9e:	83 c4 18             	add    $0x18,%esp
}
  801aa1:	90                   	nop
  801aa2:	c9                   	leave  
  801aa3:	c3                   	ret    

00801aa4 <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  801aa4:	55                   	push   %ebp
  801aa5:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  801aa7:	8b 45 08             	mov    0x8(%ebp),%eax
  801aaa:	6a 00                	push   $0x0
  801aac:	6a 00                	push   $0x0
  801aae:	6a 00                	push   $0x0
  801ab0:	6a 00                	push   $0x0
  801ab2:	50                   	push   %eax
  801ab3:	6a 22                	push   $0x22
  801ab5:	e8 52 fc ff ff       	call   80170c <syscall>
  801aba:	83 c4 18             	add    $0x18,%esp
}
  801abd:	c9                   	leave  
  801abe:	c3                   	ret    

00801abf <sys_getenvid>:

int32 sys_getenvid(void)
{
  801abf:	55                   	push   %ebp
  801ac0:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  801ac2:	6a 00                	push   $0x0
  801ac4:	6a 00                	push   $0x0
  801ac6:	6a 00                	push   $0x0
  801ac8:	6a 00                	push   $0x0
  801aca:	6a 00                	push   $0x0
  801acc:	6a 02                	push   $0x2
  801ace:	e8 39 fc ff ff       	call   80170c <syscall>
  801ad3:	83 c4 18             	add    $0x18,%esp
}
  801ad6:	c9                   	leave  
  801ad7:	c3                   	ret    

00801ad8 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  801ad8:	55                   	push   %ebp
  801ad9:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  801adb:	6a 00                	push   $0x0
  801add:	6a 00                	push   $0x0
  801adf:	6a 00                	push   $0x0
  801ae1:	6a 00                	push   $0x0
  801ae3:	6a 00                	push   $0x0
  801ae5:	6a 03                	push   $0x3
  801ae7:	e8 20 fc ff ff       	call   80170c <syscall>
  801aec:	83 c4 18             	add    $0x18,%esp
}
  801aef:	c9                   	leave  
  801af0:	c3                   	ret    

00801af1 <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  801af1:	55                   	push   %ebp
  801af2:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  801af4:	6a 00                	push   $0x0
  801af6:	6a 00                	push   $0x0
  801af8:	6a 00                	push   $0x0
  801afa:	6a 00                	push   $0x0
  801afc:	6a 00                	push   $0x0
  801afe:	6a 04                	push   $0x4
  801b00:	e8 07 fc ff ff       	call   80170c <syscall>
  801b05:	83 c4 18             	add    $0x18,%esp
}
  801b08:	c9                   	leave  
  801b09:	c3                   	ret    

00801b0a <sys_exit_env>:


void sys_exit_env(void)
{
  801b0a:	55                   	push   %ebp
  801b0b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  801b0d:	6a 00                	push   $0x0
  801b0f:	6a 00                	push   $0x0
  801b11:	6a 00                	push   $0x0
  801b13:	6a 00                	push   $0x0
  801b15:	6a 00                	push   $0x0
  801b17:	6a 23                	push   $0x23
  801b19:	e8 ee fb ff ff       	call   80170c <syscall>
  801b1e:	83 c4 18             	add    $0x18,%esp
}
  801b21:	90                   	nop
  801b22:	c9                   	leave  
  801b23:	c3                   	ret    

00801b24 <sys_get_virtual_time>:


struct uint64
sys_get_virtual_time()
{
  801b24:	55                   	push   %ebp
  801b25:	89 e5                	mov    %esp,%ebp
  801b27:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  801b2a:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801b2d:	8d 50 04             	lea    0x4(%eax),%edx
  801b30:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801b33:	6a 00                	push   $0x0
  801b35:	6a 00                	push   $0x0
  801b37:	6a 00                	push   $0x0
  801b39:	52                   	push   %edx
  801b3a:	50                   	push   %eax
  801b3b:	6a 24                	push   $0x24
  801b3d:	e8 ca fb ff ff       	call   80170c <syscall>
  801b42:	83 c4 18             	add    $0x18,%esp
	return result;
  801b45:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801b48:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801b4b:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801b4e:	89 01                	mov    %eax,(%ecx)
  801b50:	89 51 04             	mov    %edx,0x4(%ecx)
}
  801b53:	8b 45 08             	mov    0x8(%ebp),%eax
  801b56:	c9                   	leave  
  801b57:	c2 04 00             	ret    $0x4

00801b5a <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  801b5a:	55                   	push   %ebp
  801b5b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  801b5d:	6a 00                	push   $0x0
  801b5f:	6a 00                	push   $0x0
  801b61:	ff 75 10             	pushl  0x10(%ebp)
  801b64:	ff 75 0c             	pushl  0xc(%ebp)
  801b67:	ff 75 08             	pushl  0x8(%ebp)
  801b6a:	6a 12                	push   $0x12
  801b6c:	e8 9b fb ff ff       	call   80170c <syscall>
  801b71:	83 c4 18             	add    $0x18,%esp
	return ;
  801b74:	90                   	nop
}
  801b75:	c9                   	leave  
  801b76:	c3                   	ret    

00801b77 <sys_rcr2>:
uint32 sys_rcr2()
{
  801b77:	55                   	push   %ebp
  801b78:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  801b7a:	6a 00                	push   $0x0
  801b7c:	6a 00                	push   $0x0
  801b7e:	6a 00                	push   $0x0
  801b80:	6a 00                	push   $0x0
  801b82:	6a 00                	push   $0x0
  801b84:	6a 25                	push   $0x25
  801b86:	e8 81 fb ff ff       	call   80170c <syscall>
  801b8b:	83 c4 18             	add    $0x18,%esp
}
  801b8e:	c9                   	leave  
  801b8f:	c3                   	ret    

00801b90 <sys_bypassPageFault>:
void sys_bypassPageFault(uint8 instrLength)
{
  801b90:	55                   	push   %ebp
  801b91:	89 e5                	mov    %esp,%ebp
  801b93:	83 ec 04             	sub    $0x4,%esp
  801b96:	8b 45 08             	mov    0x8(%ebp),%eax
  801b99:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  801b9c:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  801ba0:	6a 00                	push   $0x0
  801ba2:	6a 00                	push   $0x0
  801ba4:	6a 00                	push   $0x0
  801ba6:	6a 00                	push   $0x0
  801ba8:	50                   	push   %eax
  801ba9:	6a 26                	push   $0x26
  801bab:	e8 5c fb ff ff       	call   80170c <syscall>
  801bb0:	83 c4 18             	add    $0x18,%esp
	return ;
  801bb3:	90                   	nop
}
  801bb4:	c9                   	leave  
  801bb5:	c3                   	ret    

00801bb6 <rsttst>:
void rsttst()
{
  801bb6:	55                   	push   %ebp
  801bb7:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  801bb9:	6a 00                	push   $0x0
  801bbb:	6a 00                	push   $0x0
  801bbd:	6a 00                	push   $0x0
  801bbf:	6a 00                	push   $0x0
  801bc1:	6a 00                	push   $0x0
  801bc3:	6a 28                	push   $0x28
  801bc5:	e8 42 fb ff ff       	call   80170c <syscall>
  801bca:	83 c4 18             	add    $0x18,%esp
	return ;
  801bcd:	90                   	nop
}
  801bce:	c9                   	leave  
  801bcf:	c3                   	ret    

00801bd0 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  801bd0:	55                   	push   %ebp
  801bd1:	89 e5                	mov    %esp,%ebp
  801bd3:	83 ec 04             	sub    $0x4,%esp
  801bd6:	8b 45 14             	mov    0x14(%ebp),%eax
  801bd9:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  801bdc:	8b 55 18             	mov    0x18(%ebp),%edx
  801bdf:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801be3:	52                   	push   %edx
  801be4:	50                   	push   %eax
  801be5:	ff 75 10             	pushl  0x10(%ebp)
  801be8:	ff 75 0c             	pushl  0xc(%ebp)
  801beb:	ff 75 08             	pushl  0x8(%ebp)
  801bee:	6a 27                	push   $0x27
  801bf0:	e8 17 fb ff ff       	call   80170c <syscall>
  801bf5:	83 c4 18             	add    $0x18,%esp
	return ;
  801bf8:	90                   	nop
}
  801bf9:	c9                   	leave  
  801bfa:	c3                   	ret    

00801bfb <chktst>:
void chktst(uint32 n)
{
  801bfb:	55                   	push   %ebp
  801bfc:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  801bfe:	6a 00                	push   $0x0
  801c00:	6a 00                	push   $0x0
  801c02:	6a 00                	push   $0x0
  801c04:	6a 00                	push   $0x0
  801c06:	ff 75 08             	pushl  0x8(%ebp)
  801c09:	6a 29                	push   $0x29
  801c0b:	e8 fc fa ff ff       	call   80170c <syscall>
  801c10:	83 c4 18             	add    $0x18,%esp
	return ;
  801c13:	90                   	nop
}
  801c14:	c9                   	leave  
  801c15:	c3                   	ret    

00801c16 <inctst>:

void inctst()
{
  801c16:	55                   	push   %ebp
  801c17:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  801c19:	6a 00                	push   $0x0
  801c1b:	6a 00                	push   $0x0
  801c1d:	6a 00                	push   $0x0
  801c1f:	6a 00                	push   $0x0
  801c21:	6a 00                	push   $0x0
  801c23:	6a 2a                	push   $0x2a
  801c25:	e8 e2 fa ff ff       	call   80170c <syscall>
  801c2a:	83 c4 18             	add    $0x18,%esp
	return ;
  801c2d:	90                   	nop
}
  801c2e:	c9                   	leave  
  801c2f:	c3                   	ret    

00801c30 <gettst>:
uint32 gettst()
{
  801c30:	55                   	push   %ebp
  801c31:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  801c33:	6a 00                	push   $0x0
  801c35:	6a 00                	push   $0x0
  801c37:	6a 00                	push   $0x0
  801c39:	6a 00                	push   $0x0
  801c3b:	6a 00                	push   $0x0
  801c3d:	6a 2b                	push   $0x2b
  801c3f:	e8 c8 fa ff ff       	call   80170c <syscall>
  801c44:	83 c4 18             	add    $0x18,%esp
}
  801c47:	c9                   	leave  
  801c48:	c3                   	ret    

00801c49 <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  801c49:	55                   	push   %ebp
  801c4a:	89 e5                	mov    %esp,%ebp
  801c4c:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801c4f:	6a 00                	push   $0x0
  801c51:	6a 00                	push   $0x0
  801c53:	6a 00                	push   $0x0
  801c55:	6a 00                	push   $0x0
  801c57:	6a 00                	push   $0x0
  801c59:	6a 2c                	push   $0x2c
  801c5b:	e8 ac fa ff ff       	call   80170c <syscall>
  801c60:	83 c4 18             	add    $0x18,%esp
  801c63:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  801c66:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  801c6a:	75 07                	jne    801c73 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  801c6c:	b8 01 00 00 00       	mov    $0x1,%eax
  801c71:	eb 05                	jmp    801c78 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  801c73:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801c78:	c9                   	leave  
  801c79:	c3                   	ret    

00801c7a <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  801c7a:	55                   	push   %ebp
  801c7b:	89 e5                	mov    %esp,%ebp
  801c7d:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801c80:	6a 00                	push   $0x0
  801c82:	6a 00                	push   $0x0
  801c84:	6a 00                	push   $0x0
  801c86:	6a 00                	push   $0x0
  801c88:	6a 00                	push   $0x0
  801c8a:	6a 2c                	push   $0x2c
  801c8c:	e8 7b fa ff ff       	call   80170c <syscall>
  801c91:	83 c4 18             	add    $0x18,%esp
  801c94:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  801c97:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  801c9b:	75 07                	jne    801ca4 <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  801c9d:	b8 01 00 00 00       	mov    $0x1,%eax
  801ca2:	eb 05                	jmp    801ca9 <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  801ca4:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801ca9:	c9                   	leave  
  801caa:	c3                   	ret    

00801cab <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  801cab:	55                   	push   %ebp
  801cac:	89 e5                	mov    %esp,%ebp
  801cae:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801cb1:	6a 00                	push   $0x0
  801cb3:	6a 00                	push   $0x0
  801cb5:	6a 00                	push   $0x0
  801cb7:	6a 00                	push   $0x0
  801cb9:	6a 00                	push   $0x0
  801cbb:	6a 2c                	push   $0x2c
  801cbd:	e8 4a fa ff ff       	call   80170c <syscall>
  801cc2:	83 c4 18             	add    $0x18,%esp
  801cc5:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  801cc8:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  801ccc:	75 07                	jne    801cd5 <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  801cce:	b8 01 00 00 00       	mov    $0x1,%eax
  801cd3:	eb 05                	jmp    801cda <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  801cd5:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801cda:	c9                   	leave  
  801cdb:	c3                   	ret    

00801cdc <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  801cdc:	55                   	push   %ebp
  801cdd:	89 e5                	mov    %esp,%ebp
  801cdf:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801ce2:	6a 00                	push   $0x0
  801ce4:	6a 00                	push   $0x0
  801ce6:	6a 00                	push   $0x0
  801ce8:	6a 00                	push   $0x0
  801cea:	6a 00                	push   $0x0
  801cec:	6a 2c                	push   $0x2c
  801cee:	e8 19 fa ff ff       	call   80170c <syscall>
  801cf3:	83 c4 18             	add    $0x18,%esp
  801cf6:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  801cf9:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  801cfd:	75 07                	jne    801d06 <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  801cff:	b8 01 00 00 00       	mov    $0x1,%eax
  801d04:	eb 05                	jmp    801d0b <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  801d06:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801d0b:	c9                   	leave  
  801d0c:	c3                   	ret    

00801d0d <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  801d0d:	55                   	push   %ebp
  801d0e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  801d10:	6a 00                	push   $0x0
  801d12:	6a 00                	push   $0x0
  801d14:	6a 00                	push   $0x0
  801d16:	6a 00                	push   $0x0
  801d18:	ff 75 08             	pushl  0x8(%ebp)
  801d1b:	6a 2d                	push   $0x2d
  801d1d:	e8 ea f9 ff ff       	call   80170c <syscall>
  801d22:	83 c4 18             	add    $0x18,%esp
	return ;
  801d25:	90                   	nop
}
  801d26:	c9                   	leave  
  801d27:	c3                   	ret    

00801d28 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  801d28:	55                   	push   %ebp
  801d29:	89 e5                	mov    %esp,%ebp
  801d2b:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  801d2c:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801d2f:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801d32:	8b 55 0c             	mov    0xc(%ebp),%edx
  801d35:	8b 45 08             	mov    0x8(%ebp),%eax
  801d38:	6a 00                	push   $0x0
  801d3a:	53                   	push   %ebx
  801d3b:	51                   	push   %ecx
  801d3c:	52                   	push   %edx
  801d3d:	50                   	push   %eax
  801d3e:	6a 2e                	push   $0x2e
  801d40:	e8 c7 f9 ff ff       	call   80170c <syscall>
  801d45:	83 c4 18             	add    $0x18,%esp
}
  801d48:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801d4b:	c9                   	leave  
  801d4c:	c3                   	ret    

00801d4d <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  801d4d:	55                   	push   %ebp
  801d4e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  801d50:	8b 55 0c             	mov    0xc(%ebp),%edx
  801d53:	8b 45 08             	mov    0x8(%ebp),%eax
  801d56:	6a 00                	push   $0x0
  801d58:	6a 00                	push   $0x0
  801d5a:	6a 00                	push   $0x0
  801d5c:	52                   	push   %edx
  801d5d:	50                   	push   %eax
  801d5e:	6a 2f                	push   $0x2f
  801d60:	e8 a7 f9 ff ff       	call   80170c <syscall>
  801d65:	83 c4 18             	add    $0x18,%esp
}
  801d68:	c9                   	leave  
  801d69:	c3                   	ret    

00801d6a <print_mem_block_lists>:
//===========================
// PRINT MEM BLOCK LISTS:
//===========================

void print_mem_block_lists()
{
  801d6a:	55                   	push   %ebp
  801d6b:	89 e5                	mov    %esp,%ebp
  801d6d:	83 ec 18             	sub    $0x18,%esp
	cprintf("\n=========================================\n");
  801d70:	83 ec 0c             	sub    $0xc,%esp
  801d73:	68 80 37 80 00       	push   $0x803780
  801d78:	e8 dd e6 ff ff       	call   80045a <cprintf>
  801d7d:	83 c4 10             	add    $0x10,%esp
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
  801d80:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nFreeMemBlocksList:\n");
  801d87:	83 ec 0c             	sub    $0xc,%esp
  801d8a:	68 ac 37 80 00       	push   $0x8037ac
  801d8f:	e8 c6 e6 ff ff       	call   80045a <cprintf>
  801d94:	83 c4 10             	add    $0x10,%esp
	uint8 sorted = 1 ;
  801d97:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &FreeMemBlocksList)
  801d9b:	a1 38 41 80 00       	mov    0x804138,%eax
  801da0:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801da3:	eb 56                	jmp    801dfb <print_mem_block_lists+0x91>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  801da5:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801da9:	74 1c                	je     801dc7 <print_mem_block_lists+0x5d>
  801dab:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801dae:	8b 50 08             	mov    0x8(%eax),%edx
  801db1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801db4:	8b 48 08             	mov    0x8(%eax),%ecx
  801db7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801dba:	8b 40 0c             	mov    0xc(%eax),%eax
  801dbd:	01 c8                	add    %ecx,%eax
  801dbf:	39 c2                	cmp    %eax,%edx
  801dc1:	73 04                	jae    801dc7 <print_mem_block_lists+0x5d>
			sorted = 0 ;
  801dc3:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  801dc7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801dca:	8b 50 08             	mov    0x8(%eax),%edx
  801dcd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801dd0:	8b 40 0c             	mov    0xc(%eax),%eax
  801dd3:	01 c2                	add    %eax,%edx
  801dd5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801dd8:	8b 40 08             	mov    0x8(%eax),%eax
  801ddb:	83 ec 04             	sub    $0x4,%esp
  801dde:	52                   	push   %edx
  801ddf:	50                   	push   %eax
  801de0:	68 c1 37 80 00       	push   $0x8037c1
  801de5:	e8 70 e6 ff ff       	call   80045a <cprintf>
  801dea:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  801ded:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801df0:	89 45 f0             	mov    %eax,-0x10(%ebp)
	cprintf("\n=========================================\n");
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
	cprintf("\nFreeMemBlocksList:\n");
	uint8 sorted = 1 ;
	LIST_FOREACH(blk, &FreeMemBlocksList)
  801df3:	a1 40 41 80 00       	mov    0x804140,%eax
  801df8:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801dfb:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801dff:	74 07                	je     801e08 <print_mem_block_lists+0x9e>
  801e01:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e04:	8b 00                	mov    (%eax),%eax
  801e06:	eb 05                	jmp    801e0d <print_mem_block_lists+0xa3>
  801e08:	b8 00 00 00 00       	mov    $0x0,%eax
  801e0d:	a3 40 41 80 00       	mov    %eax,0x804140
  801e12:	a1 40 41 80 00       	mov    0x804140,%eax
  801e17:	85 c0                	test   %eax,%eax
  801e19:	75 8a                	jne    801da5 <print_mem_block_lists+0x3b>
  801e1b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801e1f:	75 84                	jne    801da5 <print_mem_block_lists+0x3b>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;
  801e21:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  801e25:	75 10                	jne    801e37 <print_mem_block_lists+0xcd>
  801e27:	83 ec 0c             	sub    $0xc,%esp
  801e2a:	68 d0 37 80 00       	push   $0x8037d0
  801e2f:	e8 26 e6 ff ff       	call   80045a <cprintf>
  801e34:	83 c4 10             	add    $0x10,%esp

	lastBlk = NULL ;
  801e37:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nAllocMemBlocksList:\n");
  801e3e:	83 ec 0c             	sub    $0xc,%esp
  801e41:	68 f4 37 80 00       	push   $0x8037f4
  801e46:	e8 0f e6 ff ff       	call   80045a <cprintf>
  801e4b:	83 c4 10             	add    $0x10,%esp
	sorted = 1 ;
  801e4e:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &AllocMemBlocksList)
  801e52:	a1 40 40 80 00       	mov    0x804040,%eax
  801e57:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801e5a:	eb 56                	jmp    801eb2 <print_mem_block_lists+0x148>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  801e5c:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801e60:	74 1c                	je     801e7e <print_mem_block_lists+0x114>
  801e62:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e65:	8b 50 08             	mov    0x8(%eax),%edx
  801e68:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801e6b:	8b 48 08             	mov    0x8(%eax),%ecx
  801e6e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801e71:	8b 40 0c             	mov    0xc(%eax),%eax
  801e74:	01 c8                	add    %ecx,%eax
  801e76:	39 c2                	cmp    %eax,%edx
  801e78:	73 04                	jae    801e7e <print_mem_block_lists+0x114>
			sorted = 0 ;
  801e7a:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  801e7e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e81:	8b 50 08             	mov    0x8(%eax),%edx
  801e84:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e87:	8b 40 0c             	mov    0xc(%eax),%eax
  801e8a:	01 c2                	add    %eax,%edx
  801e8c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e8f:	8b 40 08             	mov    0x8(%eax),%eax
  801e92:	83 ec 04             	sub    $0x4,%esp
  801e95:	52                   	push   %edx
  801e96:	50                   	push   %eax
  801e97:	68 c1 37 80 00       	push   $0x8037c1
  801e9c:	e8 b9 e5 ff ff       	call   80045a <cprintf>
  801ea1:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  801ea4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ea7:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;

	lastBlk = NULL ;
	cprintf("\nAllocMemBlocksList:\n");
	sorted = 1 ;
	LIST_FOREACH(blk, &AllocMemBlocksList)
  801eaa:	a1 48 40 80 00       	mov    0x804048,%eax
  801eaf:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801eb2:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801eb6:	74 07                	je     801ebf <print_mem_block_lists+0x155>
  801eb8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ebb:	8b 00                	mov    (%eax),%eax
  801ebd:	eb 05                	jmp    801ec4 <print_mem_block_lists+0x15a>
  801ebf:	b8 00 00 00 00       	mov    $0x0,%eax
  801ec4:	a3 48 40 80 00       	mov    %eax,0x804048
  801ec9:	a1 48 40 80 00       	mov    0x804048,%eax
  801ece:	85 c0                	test   %eax,%eax
  801ed0:	75 8a                	jne    801e5c <print_mem_block_lists+0xf2>
  801ed2:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801ed6:	75 84                	jne    801e5c <print_mem_block_lists+0xf2>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nAllocMemBlocksList is NOT SORTED!!\n") ;
  801ed8:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  801edc:	75 10                	jne    801eee <print_mem_block_lists+0x184>
  801ede:	83 ec 0c             	sub    $0xc,%esp
  801ee1:	68 0c 38 80 00       	push   $0x80380c
  801ee6:	e8 6f e5 ff ff       	call   80045a <cprintf>
  801eeb:	83 c4 10             	add    $0x10,%esp
	cprintf("\n=========================================\n");
  801eee:	83 ec 0c             	sub    $0xc,%esp
  801ef1:	68 80 37 80 00       	push   $0x803780
  801ef6:	e8 5f e5 ff ff       	call   80045a <cprintf>
  801efb:	83 c4 10             	add    $0x10,%esp

}
  801efe:	90                   	nop
  801eff:	c9                   	leave  
  801f00:	c3                   	ret    

00801f01 <initialize_MemBlocksList>:

//===============================
// [1] INITIALIZE AVAILABLE LIST:
//===============================
void initialize_MemBlocksList(uint32 numOfBlocks)
{
  801f01:	55                   	push   %ebp
  801f02:	89 e5                	mov    %esp,%ebp
  801f04:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] initialize_MemBlocksList
	// Write your code here, remove the panic and write your code
	//panic("initialize_MemBlocksList() is not implemented yet...!!");
	uint32 n = numOfBlocks;
  801f07:	8b 45 08             	mov    0x8(%ebp),%eax
  801f0a:	89 45 f0             	mov    %eax,-0x10(%ebp)

	LIST_INIT(&AvailableMemBlocksList);
  801f0d:	c7 05 48 41 80 00 00 	movl   $0x0,0x804148
  801f14:	00 00 00 
  801f17:	c7 05 4c 41 80 00 00 	movl   $0x0,0x80414c
  801f1e:	00 00 00 
  801f21:	c7 05 54 41 80 00 00 	movl   $0x0,0x804154
  801f28:	00 00 00 
	for(int i = 0; i<n;i++)
  801f2b:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  801f32:	e9 9e 00 00 00       	jmp    801fd5 <initialize_MemBlocksList+0xd4>
	{
		LIST_INSERT_HEAD(&AvailableMemBlocksList, &(MemBlockNodes[i]));
  801f37:	a1 50 40 80 00       	mov    0x804050,%eax
  801f3c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801f3f:	c1 e2 04             	shl    $0x4,%edx
  801f42:	01 d0                	add    %edx,%eax
  801f44:	85 c0                	test   %eax,%eax
  801f46:	75 14                	jne    801f5c <initialize_MemBlocksList+0x5b>
  801f48:	83 ec 04             	sub    $0x4,%esp
  801f4b:	68 34 38 80 00       	push   $0x803834
  801f50:	6a 47                	push   $0x47
  801f52:	68 57 38 80 00       	push   $0x803857
  801f57:	e8 24 0e 00 00       	call   802d80 <_panic>
  801f5c:	a1 50 40 80 00       	mov    0x804050,%eax
  801f61:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801f64:	c1 e2 04             	shl    $0x4,%edx
  801f67:	01 d0                	add    %edx,%eax
  801f69:	8b 15 48 41 80 00    	mov    0x804148,%edx
  801f6f:	89 10                	mov    %edx,(%eax)
  801f71:	8b 00                	mov    (%eax),%eax
  801f73:	85 c0                	test   %eax,%eax
  801f75:	74 18                	je     801f8f <initialize_MemBlocksList+0x8e>
  801f77:	a1 48 41 80 00       	mov    0x804148,%eax
  801f7c:	8b 15 50 40 80 00    	mov    0x804050,%edx
  801f82:	8b 4d f4             	mov    -0xc(%ebp),%ecx
  801f85:	c1 e1 04             	shl    $0x4,%ecx
  801f88:	01 ca                	add    %ecx,%edx
  801f8a:	89 50 04             	mov    %edx,0x4(%eax)
  801f8d:	eb 12                	jmp    801fa1 <initialize_MemBlocksList+0xa0>
  801f8f:	a1 50 40 80 00       	mov    0x804050,%eax
  801f94:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801f97:	c1 e2 04             	shl    $0x4,%edx
  801f9a:	01 d0                	add    %edx,%eax
  801f9c:	a3 4c 41 80 00       	mov    %eax,0x80414c
  801fa1:	a1 50 40 80 00       	mov    0x804050,%eax
  801fa6:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801fa9:	c1 e2 04             	shl    $0x4,%edx
  801fac:	01 d0                	add    %edx,%eax
  801fae:	a3 48 41 80 00       	mov    %eax,0x804148
  801fb3:	a1 50 40 80 00       	mov    0x804050,%eax
  801fb8:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801fbb:	c1 e2 04             	shl    $0x4,%edx
  801fbe:	01 d0                	add    %edx,%eax
  801fc0:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  801fc7:	a1 54 41 80 00       	mov    0x804154,%eax
  801fcc:	40                   	inc    %eax
  801fcd:	a3 54 41 80 00       	mov    %eax,0x804154
	// Write your code here, remove the panic and write your code
	//panic("initialize_MemBlocksList() is not implemented yet...!!");
	uint32 n = numOfBlocks;

	LIST_INIT(&AvailableMemBlocksList);
	for(int i = 0; i<n;i++)
  801fd2:	ff 45 f4             	incl   -0xc(%ebp)
  801fd5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801fd8:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801fdb:	0f 82 56 ff ff ff    	jb     801f37 <initialize_MemBlocksList+0x36>
	{
		LIST_INSERT_HEAD(&AvailableMemBlocksList, &(MemBlockNodes[i]));
	}
}
  801fe1:	90                   	nop
  801fe2:	c9                   	leave  
  801fe3:	c3                   	ret    

00801fe4 <find_block>:

//===============================
// [2] FIND BLOCK:
//===============================
struct MemBlock *find_block(struct MemBlock_List *blockList, uint32 va)
{
  801fe4:	55                   	push   %ebp
  801fe5:	89 e5                	mov    %esp,%ebp
  801fe7:	83 ec 10             	sub    $0x10,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] find_block
	// Write your code here, remove the panic and write your code
	//panic("find_block() is not implemented yet...!!");
	uint32 virAddress = va;
  801fea:	8b 45 0c             	mov    0xc(%ebp),%eax
  801fed:	89 45 f4             	mov    %eax,-0xc(%ebp)
	struct MemBlock* blk;
	int found = 0;
  801ff0:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	LIST_FOREACH(blk, &(AllocMemBlocksList))
  801ff7:	a1 40 40 80 00       	mov    0x804040,%eax
  801ffc:	89 45 fc             	mov    %eax,-0x4(%ebp)
  801fff:	eb 23                	jmp    802024 <find_block+0x40>
	{
		if(blk->sva == virAddress)
  802001:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802004:	8b 40 08             	mov    0x8(%eax),%eax
  802007:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  80200a:	75 09                	jne    802015 <find_block+0x31>
		{
			found = 1;
  80200c:	c7 45 f8 01 00 00 00 	movl   $0x1,-0x8(%ebp)
			break;
  802013:	eb 35                	jmp    80204a <find_block+0x66>
		}
		else
		{
			found = 0;
  802015:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	//panic("find_block() is not implemented yet...!!");
	uint32 virAddress = va;
	struct MemBlock* blk;
	int found = 0;

	LIST_FOREACH(blk, &(AllocMemBlocksList))
  80201c:	a1 48 40 80 00       	mov    0x804048,%eax
  802021:	89 45 fc             	mov    %eax,-0x4(%ebp)
  802024:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  802028:	74 07                	je     802031 <find_block+0x4d>
  80202a:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80202d:	8b 00                	mov    (%eax),%eax
  80202f:	eb 05                	jmp    802036 <find_block+0x52>
  802031:	b8 00 00 00 00       	mov    $0x0,%eax
  802036:	a3 48 40 80 00       	mov    %eax,0x804048
  80203b:	a1 48 40 80 00       	mov    0x804048,%eax
  802040:	85 c0                	test   %eax,%eax
  802042:	75 bd                	jne    802001 <find_block+0x1d>
  802044:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  802048:	75 b7                	jne    802001 <find_block+0x1d>
		{
			found = 0;
			continue;
		}
	}
	if(found == 1)
  80204a:	83 7d f8 01          	cmpl   $0x1,-0x8(%ebp)
  80204e:	75 05                	jne    802055 <find_block+0x71>
	{
		return blk;
  802050:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802053:	eb 05                	jmp    80205a <find_block+0x76>
	}
	else
	{
		return NULL;
  802055:	b8 00 00 00 00       	mov    $0x0,%eax
	}
}
  80205a:	c9                   	leave  
  80205b:	c3                   	ret    

0080205c <insert_sorted_allocList>:

//=========================================
// [3] INSERT BLOCK IN ALLOC LIST [SORTED]:
//=========================================
void insert_sorted_allocList(struct MemBlock *blockToInsert)
{
  80205c:	55                   	push   %ebp
  80205d:	89 e5                	mov    %esp,%ebp
  80205f:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] insert_sorted_allocList
	// Write your code here, remove the panic and write your code
	//panic("insert_sorted_allocList() is not implemented yet...!!");
	struct MemBlock* blk;
	struct MemBlock* newblk = blockToInsert;
  802062:	8b 45 08             	mov    0x8(%ebp),%eax
  802065:	89 45 f0             	mov    %eax,-0x10(%ebp)

	if((LIST_EMPTY(&AllocMemBlocksList)) || (newblk->sva < LIST_FIRST(&AllocMemBlocksList)->sva))
  802068:	a1 40 40 80 00       	mov    0x804040,%eax
  80206d:	85 c0                	test   %eax,%eax
  80206f:	74 12                	je     802083 <insert_sorted_allocList+0x27>
  802071:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802074:	8b 50 08             	mov    0x8(%eax),%edx
  802077:	a1 40 40 80 00       	mov    0x804040,%eax
  80207c:	8b 40 08             	mov    0x8(%eax),%eax
  80207f:	39 c2                	cmp    %eax,%edx
  802081:	73 65                	jae    8020e8 <insert_sorted_allocList+0x8c>
	{
		LIST_INSERT_HEAD(&(AllocMemBlocksList), newblk);
  802083:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802087:	75 14                	jne    80209d <insert_sorted_allocList+0x41>
  802089:	83 ec 04             	sub    $0x4,%esp
  80208c:	68 34 38 80 00       	push   $0x803834
  802091:	6a 7b                	push   $0x7b
  802093:	68 57 38 80 00       	push   $0x803857
  802098:	e8 e3 0c 00 00       	call   802d80 <_panic>
  80209d:	8b 15 40 40 80 00    	mov    0x804040,%edx
  8020a3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8020a6:	89 10                	mov    %edx,(%eax)
  8020a8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8020ab:	8b 00                	mov    (%eax),%eax
  8020ad:	85 c0                	test   %eax,%eax
  8020af:	74 0d                	je     8020be <insert_sorted_allocList+0x62>
  8020b1:	a1 40 40 80 00       	mov    0x804040,%eax
  8020b6:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8020b9:	89 50 04             	mov    %edx,0x4(%eax)
  8020bc:	eb 08                	jmp    8020c6 <insert_sorted_allocList+0x6a>
  8020be:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8020c1:	a3 44 40 80 00       	mov    %eax,0x804044
  8020c6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8020c9:	a3 40 40 80 00       	mov    %eax,0x804040
  8020ce:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8020d1:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8020d8:	a1 4c 40 80 00       	mov    0x80404c,%eax
  8020dd:	40                   	inc    %eax
  8020de:	a3 4c 40 80 00       	mov    %eax,0x80404c
  8020e3:	e9 5f 01 00 00       	jmp    802247 <insert_sorted_allocList+0x1eb>
	}
	else if(newblk->sva > LIST_LAST(&AllocMemBlocksList)->sva)
  8020e8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8020eb:	8b 50 08             	mov    0x8(%eax),%edx
  8020ee:	a1 44 40 80 00       	mov    0x804044,%eax
  8020f3:	8b 40 08             	mov    0x8(%eax),%eax
  8020f6:	39 c2                	cmp    %eax,%edx
  8020f8:	76 65                	jbe    80215f <insert_sorted_allocList+0x103>
	{
		LIST_INSERT_TAIL(&AllocMemBlocksList, newblk);
  8020fa:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8020fe:	75 14                	jne    802114 <insert_sorted_allocList+0xb8>
  802100:	83 ec 04             	sub    $0x4,%esp
  802103:	68 70 38 80 00       	push   $0x803870
  802108:	6a 7f                	push   $0x7f
  80210a:	68 57 38 80 00       	push   $0x803857
  80210f:	e8 6c 0c 00 00       	call   802d80 <_panic>
  802114:	8b 15 44 40 80 00    	mov    0x804044,%edx
  80211a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80211d:	89 50 04             	mov    %edx,0x4(%eax)
  802120:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802123:	8b 40 04             	mov    0x4(%eax),%eax
  802126:	85 c0                	test   %eax,%eax
  802128:	74 0c                	je     802136 <insert_sorted_allocList+0xda>
  80212a:	a1 44 40 80 00       	mov    0x804044,%eax
  80212f:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802132:	89 10                	mov    %edx,(%eax)
  802134:	eb 08                	jmp    80213e <insert_sorted_allocList+0xe2>
  802136:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802139:	a3 40 40 80 00       	mov    %eax,0x804040
  80213e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802141:	a3 44 40 80 00       	mov    %eax,0x804044
  802146:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802149:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80214f:	a1 4c 40 80 00       	mov    0x80404c,%eax
  802154:	40                   	inc    %eax
  802155:	a3 4c 40 80 00       	mov    %eax,0x80404c
				LIST_INSERT_AFTER(&AllocMemBlocksList, blk, newblk);
				break;
			}
		}
	}
}
  80215a:	e9 e8 00 00 00       	jmp    802247 <insert_sorted_allocList+0x1eb>
	{
		LIST_INSERT_TAIL(&AllocMemBlocksList, newblk);
	}
	else
	{
		LIST_FOREACH(blk, &AllocMemBlocksList)
  80215f:	a1 40 40 80 00       	mov    0x804040,%eax
  802164:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802167:	e9 ab 00 00 00       	jmp    802217 <insert_sorted_allocList+0x1bb>
		{
			if(blk->prev_next_info.le_next != NULL && newblk->sva > blk->sva  && newblk->sva < blk->prev_next_info.le_next->sva)
  80216c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80216f:	8b 00                	mov    (%eax),%eax
  802171:	85 c0                	test   %eax,%eax
  802173:	0f 84 96 00 00 00    	je     80220f <insert_sorted_allocList+0x1b3>
  802179:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80217c:	8b 50 08             	mov    0x8(%eax),%edx
  80217f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802182:	8b 40 08             	mov    0x8(%eax),%eax
  802185:	39 c2                	cmp    %eax,%edx
  802187:	0f 86 82 00 00 00    	jbe    80220f <insert_sorted_allocList+0x1b3>
  80218d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802190:	8b 50 08             	mov    0x8(%eax),%edx
  802193:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802196:	8b 00                	mov    (%eax),%eax
  802198:	8b 40 08             	mov    0x8(%eax),%eax
  80219b:	39 c2                	cmp    %eax,%edx
  80219d:	73 70                	jae    80220f <insert_sorted_allocList+0x1b3>
			{
				LIST_INSERT_AFTER(&AllocMemBlocksList, blk, newblk);
  80219f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8021a3:	74 06                	je     8021ab <insert_sorted_allocList+0x14f>
  8021a5:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8021a9:	75 17                	jne    8021c2 <insert_sorted_allocList+0x166>
  8021ab:	83 ec 04             	sub    $0x4,%esp
  8021ae:	68 94 38 80 00       	push   $0x803894
  8021b3:	68 87 00 00 00       	push   $0x87
  8021b8:	68 57 38 80 00       	push   $0x803857
  8021bd:	e8 be 0b 00 00       	call   802d80 <_panic>
  8021c2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021c5:	8b 10                	mov    (%eax),%edx
  8021c7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8021ca:	89 10                	mov    %edx,(%eax)
  8021cc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8021cf:	8b 00                	mov    (%eax),%eax
  8021d1:	85 c0                	test   %eax,%eax
  8021d3:	74 0b                	je     8021e0 <insert_sorted_allocList+0x184>
  8021d5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021d8:	8b 00                	mov    (%eax),%eax
  8021da:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8021dd:	89 50 04             	mov    %edx,0x4(%eax)
  8021e0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021e3:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8021e6:	89 10                	mov    %edx,(%eax)
  8021e8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8021eb:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8021ee:	89 50 04             	mov    %edx,0x4(%eax)
  8021f1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8021f4:	8b 00                	mov    (%eax),%eax
  8021f6:	85 c0                	test   %eax,%eax
  8021f8:	75 08                	jne    802202 <insert_sorted_allocList+0x1a6>
  8021fa:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8021fd:	a3 44 40 80 00       	mov    %eax,0x804044
  802202:	a1 4c 40 80 00       	mov    0x80404c,%eax
  802207:	40                   	inc    %eax
  802208:	a3 4c 40 80 00       	mov    %eax,0x80404c
				break;
  80220d:	eb 38                	jmp    802247 <insert_sorted_allocList+0x1eb>
	{
		LIST_INSERT_TAIL(&AllocMemBlocksList, newblk);
	}
	else
	{
		LIST_FOREACH(blk, &AllocMemBlocksList)
  80220f:	a1 48 40 80 00       	mov    0x804048,%eax
  802214:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802217:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80221b:	74 07                	je     802224 <insert_sorted_allocList+0x1c8>
  80221d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802220:	8b 00                	mov    (%eax),%eax
  802222:	eb 05                	jmp    802229 <insert_sorted_allocList+0x1cd>
  802224:	b8 00 00 00 00       	mov    $0x0,%eax
  802229:	a3 48 40 80 00       	mov    %eax,0x804048
  80222e:	a1 48 40 80 00       	mov    0x804048,%eax
  802233:	85 c0                	test   %eax,%eax
  802235:	0f 85 31 ff ff ff    	jne    80216c <insert_sorted_allocList+0x110>
  80223b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80223f:	0f 85 27 ff ff ff    	jne    80216c <insert_sorted_allocList+0x110>
				LIST_INSERT_AFTER(&AllocMemBlocksList, blk, newblk);
				break;
			}
		}
	}
}
  802245:	eb 00                	jmp    802247 <insert_sorted_allocList+0x1eb>
  802247:	90                   	nop
  802248:	c9                   	leave  
  802249:	c3                   	ret    

0080224a <alloc_block_FF>:

//=========================================
// [4] ALLOCATE BLOCK BY FIRST FIT:
//=========================================
struct MemBlock *alloc_block_FF(uint32 size)
{
  80224a:	55                   	push   %ebp
  80224b:	89 e5                	mov    %esp,%ebp
  80224d:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_FF
	// Write your code here, remove the panic and write your code
	//panic("alloc_block_FF() is not implemented yet...!!");
	uint32 versize = size;
  802250:	8b 45 08             	mov    0x8(%ebp),%eax
  802253:	89 45 f0             	mov    %eax,-0x10(%ebp)
	struct MemBlock* blk;
	struct MemBlock* newblk = LIST_FIRST(&AvailableMemBlocksList);
  802256:	a1 48 41 80 00       	mov    0x804148,%eax
  80225b:	89 45 ec             	mov    %eax,-0x14(%ebp)

	LIST_FOREACH(blk,&FreeMemBlocksList)
  80225e:	a1 38 41 80 00       	mov    0x804138,%eax
  802263:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802266:	e9 77 01 00 00       	jmp    8023e2 <alloc_block_FF+0x198>
	{
		if(blk->size == versize)
  80226b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80226e:	8b 40 0c             	mov    0xc(%eax),%eax
  802271:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  802274:	0f 85 8a 00 00 00    	jne    802304 <alloc_block_FF+0xba>
		{
			LIST_REMOVE(&FreeMemBlocksList,blk);
  80227a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80227e:	75 17                	jne    802297 <alloc_block_FF+0x4d>
  802280:	83 ec 04             	sub    $0x4,%esp
  802283:	68 c8 38 80 00       	push   $0x8038c8
  802288:	68 9e 00 00 00       	push   $0x9e
  80228d:	68 57 38 80 00       	push   $0x803857
  802292:	e8 e9 0a 00 00       	call   802d80 <_panic>
  802297:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80229a:	8b 00                	mov    (%eax),%eax
  80229c:	85 c0                	test   %eax,%eax
  80229e:	74 10                	je     8022b0 <alloc_block_FF+0x66>
  8022a0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022a3:	8b 00                	mov    (%eax),%eax
  8022a5:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8022a8:	8b 52 04             	mov    0x4(%edx),%edx
  8022ab:	89 50 04             	mov    %edx,0x4(%eax)
  8022ae:	eb 0b                	jmp    8022bb <alloc_block_FF+0x71>
  8022b0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022b3:	8b 40 04             	mov    0x4(%eax),%eax
  8022b6:	a3 3c 41 80 00       	mov    %eax,0x80413c
  8022bb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022be:	8b 40 04             	mov    0x4(%eax),%eax
  8022c1:	85 c0                	test   %eax,%eax
  8022c3:	74 0f                	je     8022d4 <alloc_block_FF+0x8a>
  8022c5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022c8:	8b 40 04             	mov    0x4(%eax),%eax
  8022cb:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8022ce:	8b 12                	mov    (%edx),%edx
  8022d0:	89 10                	mov    %edx,(%eax)
  8022d2:	eb 0a                	jmp    8022de <alloc_block_FF+0x94>
  8022d4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022d7:	8b 00                	mov    (%eax),%eax
  8022d9:	a3 38 41 80 00       	mov    %eax,0x804138
  8022de:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022e1:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8022e7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022ea:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8022f1:	a1 44 41 80 00       	mov    0x804144,%eax
  8022f6:	48                   	dec    %eax
  8022f7:	a3 44 41 80 00       	mov    %eax,0x804144
			return blk;
  8022fc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022ff:	e9 11 01 00 00       	jmp    802415 <alloc_block_FF+0x1cb>
		}
		else if(blk->size > versize)
  802304:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802307:	8b 40 0c             	mov    0xc(%eax),%eax
  80230a:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80230d:	0f 86 c7 00 00 00    	jbe    8023da <alloc_block_FF+0x190>
		{
			LIST_REMOVE(&AvailableMemBlocksList,newblk);
  802313:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802317:	75 17                	jne    802330 <alloc_block_FF+0xe6>
  802319:	83 ec 04             	sub    $0x4,%esp
  80231c:	68 c8 38 80 00       	push   $0x8038c8
  802321:	68 a3 00 00 00       	push   $0xa3
  802326:	68 57 38 80 00       	push   $0x803857
  80232b:	e8 50 0a 00 00       	call   802d80 <_panic>
  802330:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802333:	8b 00                	mov    (%eax),%eax
  802335:	85 c0                	test   %eax,%eax
  802337:	74 10                	je     802349 <alloc_block_FF+0xff>
  802339:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80233c:	8b 00                	mov    (%eax),%eax
  80233e:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802341:	8b 52 04             	mov    0x4(%edx),%edx
  802344:	89 50 04             	mov    %edx,0x4(%eax)
  802347:	eb 0b                	jmp    802354 <alloc_block_FF+0x10a>
  802349:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80234c:	8b 40 04             	mov    0x4(%eax),%eax
  80234f:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802354:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802357:	8b 40 04             	mov    0x4(%eax),%eax
  80235a:	85 c0                	test   %eax,%eax
  80235c:	74 0f                	je     80236d <alloc_block_FF+0x123>
  80235e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802361:	8b 40 04             	mov    0x4(%eax),%eax
  802364:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802367:	8b 12                	mov    (%edx),%edx
  802369:	89 10                	mov    %edx,(%eax)
  80236b:	eb 0a                	jmp    802377 <alloc_block_FF+0x12d>
  80236d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802370:	8b 00                	mov    (%eax),%eax
  802372:	a3 48 41 80 00       	mov    %eax,0x804148
  802377:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80237a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802380:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802383:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80238a:	a1 54 41 80 00       	mov    0x804154,%eax
  80238f:	48                   	dec    %eax
  802390:	a3 54 41 80 00       	mov    %eax,0x804154
			newblk->size = versize;
  802395:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802398:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80239b:	89 50 0c             	mov    %edx,0xc(%eax)
			blk->size = blk->size-versize;
  80239e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023a1:	8b 40 0c             	mov    0xc(%eax),%eax
  8023a4:	2b 45 f0             	sub    -0x10(%ebp),%eax
  8023a7:	89 c2                	mov    %eax,%edx
  8023a9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023ac:	89 50 0c             	mov    %edx,0xc(%eax)
			uint32 newveradd = blk->sva;
  8023af:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023b2:	8b 40 08             	mov    0x8(%eax),%eax
  8023b5:	89 45 e8             	mov    %eax,-0x18(%ebp)
			blk->sva+=newblk->size;
  8023b8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023bb:	8b 50 08             	mov    0x8(%eax),%edx
  8023be:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8023c1:	8b 40 0c             	mov    0xc(%eax),%eax
  8023c4:	01 c2                	add    %eax,%edx
  8023c6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023c9:	89 50 08             	mov    %edx,0x8(%eax)
			newblk->sva = newveradd;
  8023cc:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8023cf:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8023d2:	89 50 08             	mov    %edx,0x8(%eax)
			return newblk;
  8023d5:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8023d8:	eb 3b                	jmp    802415 <alloc_block_FF+0x1cb>
	//panic("alloc_block_FF() is not implemented yet...!!");
	uint32 versize = size;
	struct MemBlock* blk;
	struct MemBlock* newblk = LIST_FIRST(&AvailableMemBlocksList);

	LIST_FOREACH(blk,&FreeMemBlocksList)
  8023da:	a1 40 41 80 00       	mov    0x804140,%eax
  8023df:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8023e2:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8023e6:	74 07                	je     8023ef <alloc_block_FF+0x1a5>
  8023e8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023eb:	8b 00                	mov    (%eax),%eax
  8023ed:	eb 05                	jmp    8023f4 <alloc_block_FF+0x1aa>
  8023ef:	b8 00 00 00 00       	mov    $0x0,%eax
  8023f4:	a3 40 41 80 00       	mov    %eax,0x804140
  8023f9:	a1 40 41 80 00       	mov    0x804140,%eax
  8023fe:	85 c0                	test   %eax,%eax
  802400:	0f 85 65 fe ff ff    	jne    80226b <alloc_block_FF+0x21>
  802406:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80240a:	0f 85 5b fe ff ff    	jne    80226b <alloc_block_FF+0x21>
			blk->sva+=newblk->size;
			newblk->sva = newveradd;
			return newblk;
		}
	}
	return NULL;
  802410:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802415:	c9                   	leave  
  802416:	c3                   	ret    

00802417 <alloc_block_BF>:

//=========================================
// [5] ALLOCATE BLOCK BY BEST FIT:
//=========================================
struct MemBlock *alloc_block_BF(uint32 size)
{
  802417:	55                   	push   %ebp
  802418:	89 e5                	mov    %esp,%ebp
  80241a:	83 ec 28             	sub    $0x28,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_BF
	// Write your code here, remove the panic and write your code
	//panic("alloc_block_BF() is not implemented yet...!!");
	uint32 versize=size;
  80241d:	8b 45 08             	mov    0x8(%ebp),%eax
  802420:	89 45 e8             	mov    %eax,-0x18(%ebp)
	struct MemBlock* blk;
	struct MemBlock* newblk=LIST_FIRST(&AvailableMemBlocksList);
  802423:	a1 48 41 80 00       	mov    0x804148,%eax
  802428:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	uint32 newveradd;
	uint32 newsize;
	int size_free = LIST_SIZE(&FreeMemBlocksList);
  80242b:	a1 44 41 80 00       	mov    0x804144,%eax
  802430:	89 45 e0             	mov    %eax,-0x20(%ebp)

	LIST_FOREACH(blk, &FreeMemBlocksList)
  802433:	a1 38 41 80 00       	mov    0x804138,%eax
  802438:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80243b:	e9 a1 00 00 00       	jmp    8024e1 <alloc_block_BF+0xca>
	{
		if(blk->size == versize)
  802440:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802443:	8b 40 0c             	mov    0xc(%eax),%eax
  802446:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  802449:	0f 85 8a 00 00 00    	jne    8024d9 <alloc_block_BF+0xc2>
		{
			LIST_REMOVE(&FreeMemBlocksList, blk);
  80244f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802453:	75 17                	jne    80246c <alloc_block_BF+0x55>
  802455:	83 ec 04             	sub    $0x4,%esp
  802458:	68 c8 38 80 00       	push   $0x8038c8
  80245d:	68 c2 00 00 00       	push   $0xc2
  802462:	68 57 38 80 00       	push   $0x803857
  802467:	e8 14 09 00 00       	call   802d80 <_panic>
  80246c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80246f:	8b 00                	mov    (%eax),%eax
  802471:	85 c0                	test   %eax,%eax
  802473:	74 10                	je     802485 <alloc_block_BF+0x6e>
  802475:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802478:	8b 00                	mov    (%eax),%eax
  80247a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80247d:	8b 52 04             	mov    0x4(%edx),%edx
  802480:	89 50 04             	mov    %edx,0x4(%eax)
  802483:	eb 0b                	jmp    802490 <alloc_block_BF+0x79>
  802485:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802488:	8b 40 04             	mov    0x4(%eax),%eax
  80248b:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802490:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802493:	8b 40 04             	mov    0x4(%eax),%eax
  802496:	85 c0                	test   %eax,%eax
  802498:	74 0f                	je     8024a9 <alloc_block_BF+0x92>
  80249a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80249d:	8b 40 04             	mov    0x4(%eax),%eax
  8024a0:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8024a3:	8b 12                	mov    (%edx),%edx
  8024a5:	89 10                	mov    %edx,(%eax)
  8024a7:	eb 0a                	jmp    8024b3 <alloc_block_BF+0x9c>
  8024a9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024ac:	8b 00                	mov    (%eax),%eax
  8024ae:	a3 38 41 80 00       	mov    %eax,0x804138
  8024b3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024b6:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8024bc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024bf:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8024c6:	a1 44 41 80 00       	mov    0x804144,%eax
  8024cb:	48                   	dec    %eax
  8024cc:	a3 44 41 80 00       	mov    %eax,0x804144
			return blk;
  8024d1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024d4:	e9 11 02 00 00       	jmp    8026ea <alloc_block_BF+0x2d3>
	struct MemBlock* newblk=LIST_FIRST(&AvailableMemBlocksList);
	uint32 newveradd;
	uint32 newsize;
	int size_free = LIST_SIZE(&FreeMemBlocksList);

	LIST_FOREACH(blk, &FreeMemBlocksList)
  8024d9:	a1 40 41 80 00       	mov    0x804140,%eax
  8024de:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8024e1:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8024e5:	74 07                	je     8024ee <alloc_block_BF+0xd7>
  8024e7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024ea:	8b 00                	mov    (%eax),%eax
  8024ec:	eb 05                	jmp    8024f3 <alloc_block_BF+0xdc>
  8024ee:	b8 00 00 00 00       	mov    $0x0,%eax
  8024f3:	a3 40 41 80 00       	mov    %eax,0x804140
  8024f8:	a1 40 41 80 00       	mov    0x804140,%eax
  8024fd:	85 c0                	test   %eax,%eax
  8024ff:	0f 85 3b ff ff ff    	jne    802440 <alloc_block_BF+0x29>
  802505:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802509:	0f 85 31 ff ff ff    	jne    802440 <alloc_block_BF+0x29>
		{
			LIST_REMOVE(&FreeMemBlocksList, blk);
			return blk;
		}
	}
	LIST_FOREACH(blk, &FreeMemBlocksList)
  80250f:	a1 38 41 80 00       	mov    0x804138,%eax
  802514:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802517:	eb 27                	jmp    802540 <alloc_block_BF+0x129>
	{
		if(blk->size > versize)
  802519:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80251c:	8b 40 0c             	mov    0xc(%eax),%eax
  80251f:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  802522:	76 14                	jbe    802538 <alloc_block_BF+0x121>
		{
			newsize = blk->size;
  802524:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802527:	8b 40 0c             	mov    0xc(%eax),%eax
  80252a:	89 45 ec             	mov    %eax,-0x14(%ebp)
			newveradd = blk->sva;
  80252d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802530:	8b 40 08             	mov    0x8(%eax),%eax
  802533:	89 45 f0             	mov    %eax,-0x10(%ebp)
			break;
  802536:	eb 2e                	jmp    802566 <alloc_block_BF+0x14f>
		{
			LIST_REMOVE(&FreeMemBlocksList, blk);
			return blk;
		}
	}
	LIST_FOREACH(blk, &FreeMemBlocksList)
  802538:	a1 40 41 80 00       	mov    0x804140,%eax
  80253d:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802540:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802544:	74 07                	je     80254d <alloc_block_BF+0x136>
  802546:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802549:	8b 00                	mov    (%eax),%eax
  80254b:	eb 05                	jmp    802552 <alloc_block_BF+0x13b>
  80254d:	b8 00 00 00 00       	mov    $0x0,%eax
  802552:	a3 40 41 80 00       	mov    %eax,0x804140
  802557:	a1 40 41 80 00       	mov    0x804140,%eax
  80255c:	85 c0                	test   %eax,%eax
  80255e:	75 b9                	jne    802519 <alloc_block_BF+0x102>
  802560:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802564:	75 b3                	jne    802519 <alloc_block_BF+0x102>
			newsize = blk->size;
			newveradd = blk->sva;
			break;
		}
	}
	LIST_FOREACH(blk, &FreeMemBlocksList)
  802566:	a1 38 41 80 00       	mov    0x804138,%eax
  80256b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80256e:	eb 30                	jmp    8025a0 <alloc_block_BF+0x189>
	{
		if(newsize > blk->size && blk->size > versize)
  802570:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802573:	8b 40 0c             	mov    0xc(%eax),%eax
  802576:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  802579:	73 1d                	jae    802598 <alloc_block_BF+0x181>
  80257b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80257e:	8b 40 0c             	mov    0xc(%eax),%eax
  802581:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  802584:	76 12                	jbe    802598 <alloc_block_BF+0x181>
		{
	       newsize = blk->size;
  802586:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802589:	8b 40 0c             	mov    0xc(%eax),%eax
  80258c:	89 45 ec             	mov    %eax,-0x14(%ebp)
		   newveradd = blk->sva;
  80258f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802592:	8b 40 08             	mov    0x8(%eax),%eax
  802595:	89 45 f0             	mov    %eax,-0x10(%ebp)
			newsize = blk->size;
			newveradd = blk->sva;
			break;
		}
	}
	LIST_FOREACH(blk, &FreeMemBlocksList)
  802598:	a1 40 41 80 00       	mov    0x804140,%eax
  80259d:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8025a0:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8025a4:	74 07                	je     8025ad <alloc_block_BF+0x196>
  8025a6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025a9:	8b 00                	mov    (%eax),%eax
  8025ab:	eb 05                	jmp    8025b2 <alloc_block_BF+0x19b>
  8025ad:	b8 00 00 00 00       	mov    $0x0,%eax
  8025b2:	a3 40 41 80 00       	mov    %eax,0x804140
  8025b7:	a1 40 41 80 00       	mov    0x804140,%eax
  8025bc:	85 c0                	test   %eax,%eax
  8025be:	75 b0                	jne    802570 <alloc_block_BF+0x159>
  8025c0:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8025c4:	75 aa                	jne    802570 <alloc_block_BF+0x159>
		{
	       newsize = blk->size;
		   newveradd = blk->sva;
		}
	}
	LIST_FOREACH(blk, &FreeMemBlocksList)
  8025c6:	a1 38 41 80 00       	mov    0x804138,%eax
  8025cb:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8025ce:	e9 e4 00 00 00       	jmp    8026b7 <alloc_block_BF+0x2a0>
	{
		if(blk->size == newsize && blk->sva == newveradd)
  8025d3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025d6:	8b 40 0c             	mov    0xc(%eax),%eax
  8025d9:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  8025dc:	0f 85 cd 00 00 00    	jne    8026af <alloc_block_BF+0x298>
  8025e2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025e5:	8b 40 08             	mov    0x8(%eax),%eax
  8025e8:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8025eb:	0f 85 be 00 00 00    	jne    8026af <alloc_block_BF+0x298>
		{
			LIST_REMOVE(&AvailableMemBlocksList, newblk);
  8025f1:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8025f5:	75 17                	jne    80260e <alloc_block_BF+0x1f7>
  8025f7:	83 ec 04             	sub    $0x4,%esp
  8025fa:	68 c8 38 80 00       	push   $0x8038c8
  8025ff:	68 db 00 00 00       	push   $0xdb
  802604:	68 57 38 80 00       	push   $0x803857
  802609:	e8 72 07 00 00       	call   802d80 <_panic>
  80260e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802611:	8b 00                	mov    (%eax),%eax
  802613:	85 c0                	test   %eax,%eax
  802615:	74 10                	je     802627 <alloc_block_BF+0x210>
  802617:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80261a:	8b 00                	mov    (%eax),%eax
  80261c:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80261f:	8b 52 04             	mov    0x4(%edx),%edx
  802622:	89 50 04             	mov    %edx,0x4(%eax)
  802625:	eb 0b                	jmp    802632 <alloc_block_BF+0x21b>
  802627:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80262a:	8b 40 04             	mov    0x4(%eax),%eax
  80262d:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802632:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802635:	8b 40 04             	mov    0x4(%eax),%eax
  802638:	85 c0                	test   %eax,%eax
  80263a:	74 0f                	je     80264b <alloc_block_BF+0x234>
  80263c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80263f:	8b 40 04             	mov    0x4(%eax),%eax
  802642:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802645:	8b 12                	mov    (%edx),%edx
  802647:	89 10                	mov    %edx,(%eax)
  802649:	eb 0a                	jmp    802655 <alloc_block_BF+0x23e>
  80264b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80264e:	8b 00                	mov    (%eax),%eax
  802650:	a3 48 41 80 00       	mov    %eax,0x804148
  802655:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802658:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80265e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802661:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802668:	a1 54 41 80 00       	mov    0x804154,%eax
  80266d:	48                   	dec    %eax
  80266e:	a3 54 41 80 00       	mov    %eax,0x804154
			newblk->size = versize;
  802673:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802676:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802679:	89 50 0c             	mov    %edx,0xc(%eax)
			newblk->sva = newveradd;
  80267c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80267f:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802682:	89 50 08             	mov    %edx,0x8(%eax)
			blk->size = blk->size - versize;
  802685:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802688:	8b 40 0c             	mov    0xc(%eax),%eax
  80268b:	2b 45 e8             	sub    -0x18(%ebp),%eax
  80268e:	89 c2                	mov    %eax,%edx
  802690:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802693:	89 50 0c             	mov    %edx,0xc(%eax)
			blk->sva+= newblk->size;
  802696:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802699:	8b 50 08             	mov    0x8(%eax),%edx
  80269c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80269f:	8b 40 0c             	mov    0xc(%eax),%eax
  8026a2:	01 c2                	add    %eax,%edx
  8026a4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026a7:	89 50 08             	mov    %edx,0x8(%eax)
			return newblk;
  8026aa:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8026ad:	eb 3b                	jmp    8026ea <alloc_block_BF+0x2d3>
		{
	       newsize = blk->size;
		   newveradd = blk->sva;
		}
	}
	LIST_FOREACH(blk, &FreeMemBlocksList)
  8026af:	a1 40 41 80 00       	mov    0x804140,%eax
  8026b4:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8026b7:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8026bb:	74 07                	je     8026c4 <alloc_block_BF+0x2ad>
  8026bd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026c0:	8b 00                	mov    (%eax),%eax
  8026c2:	eb 05                	jmp    8026c9 <alloc_block_BF+0x2b2>
  8026c4:	b8 00 00 00 00       	mov    $0x0,%eax
  8026c9:	a3 40 41 80 00       	mov    %eax,0x804140
  8026ce:	a1 40 41 80 00       	mov    0x804140,%eax
  8026d3:	85 c0                	test   %eax,%eax
  8026d5:	0f 85 f8 fe ff ff    	jne    8025d3 <alloc_block_BF+0x1bc>
  8026db:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8026df:	0f 85 ee fe ff ff    	jne    8025d3 <alloc_block_BF+0x1bc>
			blk->size = blk->size - versize;
			blk->sva+= newblk->size;
			return newblk;
		}
	}
	return NULL;
  8026e5:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8026ea:	c9                   	leave  
  8026eb:	c3                   	ret    

008026ec <alloc_block_NF>:
//=========================================
// [7] ALLOCATE BLOCK BY NEXT FIT:
//=========================================
struct MemBlock *last_allocate;
struct MemBlock *alloc_block_NF(uint32 size)
{
  8026ec:	55                   	push   %ebp
  8026ed:	89 e5                	mov    %esp,%ebp
  8026ef:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1 - BONUS] [DYNAMIC ALLOCATOR] alloc_block_NF
	// Write your code here, remove the panic and write your code
	//panic("alloc_block_NF() is not implemented yet...!!");
	uint32 versize = size;
  8026f2:	8b 45 08             	mov    0x8(%ebp),%eax
  8026f5:	89 45 f0             	mov    %eax,-0x10(%ebp)
	struct MemBlock* blk;
	struct MemBlock* newblk = LIST_FIRST(&AvailableMemBlocksList);
  8026f8:	a1 48 41 80 00       	mov    0x804148,%eax
  8026fd:	89 45 ec             	mov    %eax,-0x14(%ebp)

	LIST_FOREACH(blk,&FreeMemBlocksList)
  802700:	a1 38 41 80 00       	mov    0x804138,%eax
  802705:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802708:	e9 77 01 00 00       	jmp    802884 <alloc_block_NF+0x198>
	{
		if(blk->size == versize)
  80270d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802710:	8b 40 0c             	mov    0xc(%eax),%eax
  802713:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  802716:	0f 85 8a 00 00 00    	jne    8027a6 <alloc_block_NF+0xba>
		{
			LIST_REMOVE(&FreeMemBlocksList,blk);
  80271c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802720:	75 17                	jne    802739 <alloc_block_NF+0x4d>
  802722:	83 ec 04             	sub    $0x4,%esp
  802725:	68 c8 38 80 00       	push   $0x8038c8
  80272a:	68 f7 00 00 00       	push   $0xf7
  80272f:	68 57 38 80 00       	push   $0x803857
  802734:	e8 47 06 00 00       	call   802d80 <_panic>
  802739:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80273c:	8b 00                	mov    (%eax),%eax
  80273e:	85 c0                	test   %eax,%eax
  802740:	74 10                	je     802752 <alloc_block_NF+0x66>
  802742:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802745:	8b 00                	mov    (%eax),%eax
  802747:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80274a:	8b 52 04             	mov    0x4(%edx),%edx
  80274d:	89 50 04             	mov    %edx,0x4(%eax)
  802750:	eb 0b                	jmp    80275d <alloc_block_NF+0x71>
  802752:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802755:	8b 40 04             	mov    0x4(%eax),%eax
  802758:	a3 3c 41 80 00       	mov    %eax,0x80413c
  80275d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802760:	8b 40 04             	mov    0x4(%eax),%eax
  802763:	85 c0                	test   %eax,%eax
  802765:	74 0f                	je     802776 <alloc_block_NF+0x8a>
  802767:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80276a:	8b 40 04             	mov    0x4(%eax),%eax
  80276d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802770:	8b 12                	mov    (%edx),%edx
  802772:	89 10                	mov    %edx,(%eax)
  802774:	eb 0a                	jmp    802780 <alloc_block_NF+0x94>
  802776:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802779:	8b 00                	mov    (%eax),%eax
  80277b:	a3 38 41 80 00       	mov    %eax,0x804138
  802780:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802783:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802789:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80278c:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802793:	a1 44 41 80 00       	mov    0x804144,%eax
  802798:	48                   	dec    %eax
  802799:	a3 44 41 80 00       	mov    %eax,0x804144
			return blk;
  80279e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027a1:	e9 11 01 00 00       	jmp    8028b7 <alloc_block_NF+0x1cb>
		}
		else if(blk->size > versize)
  8027a6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027a9:	8b 40 0c             	mov    0xc(%eax),%eax
  8027ac:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8027af:	0f 86 c7 00 00 00    	jbe    80287c <alloc_block_NF+0x190>
		{
			LIST_REMOVE(&AvailableMemBlocksList,newblk);
  8027b5:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8027b9:	75 17                	jne    8027d2 <alloc_block_NF+0xe6>
  8027bb:	83 ec 04             	sub    $0x4,%esp
  8027be:	68 c8 38 80 00       	push   $0x8038c8
  8027c3:	68 fc 00 00 00       	push   $0xfc
  8027c8:	68 57 38 80 00       	push   $0x803857
  8027cd:	e8 ae 05 00 00       	call   802d80 <_panic>
  8027d2:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8027d5:	8b 00                	mov    (%eax),%eax
  8027d7:	85 c0                	test   %eax,%eax
  8027d9:	74 10                	je     8027eb <alloc_block_NF+0xff>
  8027db:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8027de:	8b 00                	mov    (%eax),%eax
  8027e0:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8027e3:	8b 52 04             	mov    0x4(%edx),%edx
  8027e6:	89 50 04             	mov    %edx,0x4(%eax)
  8027e9:	eb 0b                	jmp    8027f6 <alloc_block_NF+0x10a>
  8027eb:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8027ee:	8b 40 04             	mov    0x4(%eax),%eax
  8027f1:	a3 4c 41 80 00       	mov    %eax,0x80414c
  8027f6:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8027f9:	8b 40 04             	mov    0x4(%eax),%eax
  8027fc:	85 c0                	test   %eax,%eax
  8027fe:	74 0f                	je     80280f <alloc_block_NF+0x123>
  802800:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802803:	8b 40 04             	mov    0x4(%eax),%eax
  802806:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802809:	8b 12                	mov    (%edx),%edx
  80280b:	89 10                	mov    %edx,(%eax)
  80280d:	eb 0a                	jmp    802819 <alloc_block_NF+0x12d>
  80280f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802812:	8b 00                	mov    (%eax),%eax
  802814:	a3 48 41 80 00       	mov    %eax,0x804148
  802819:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80281c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802822:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802825:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80282c:	a1 54 41 80 00       	mov    0x804154,%eax
  802831:	48                   	dec    %eax
  802832:	a3 54 41 80 00       	mov    %eax,0x804154
			newblk->size = versize;
  802837:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80283a:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80283d:	89 50 0c             	mov    %edx,0xc(%eax)
			blk->size = blk->size-versize;
  802840:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802843:	8b 40 0c             	mov    0xc(%eax),%eax
  802846:	2b 45 f0             	sub    -0x10(%ebp),%eax
  802849:	89 c2                	mov    %eax,%edx
  80284b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80284e:	89 50 0c             	mov    %edx,0xc(%eax)
			uint32 newveradd = blk->sva;
  802851:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802854:	8b 40 08             	mov    0x8(%eax),%eax
  802857:	89 45 e8             	mov    %eax,-0x18(%ebp)
			blk->sva+=newblk->size;
  80285a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80285d:	8b 50 08             	mov    0x8(%eax),%edx
  802860:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802863:	8b 40 0c             	mov    0xc(%eax),%eax
  802866:	01 c2                	add    %eax,%edx
  802868:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80286b:	89 50 08             	mov    %edx,0x8(%eax)
			newblk->sva = newveradd;
  80286e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802871:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802874:	89 50 08             	mov    %edx,0x8(%eax)
			return newblk;
  802877:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80287a:	eb 3b                	jmp    8028b7 <alloc_block_NF+0x1cb>
	//panic("alloc_block_NF() is not implemented yet...!!");
	uint32 versize = size;
	struct MemBlock* blk;
	struct MemBlock* newblk = LIST_FIRST(&AvailableMemBlocksList);

	LIST_FOREACH(blk,&FreeMemBlocksList)
  80287c:	a1 40 41 80 00       	mov    0x804140,%eax
  802881:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802884:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802888:	74 07                	je     802891 <alloc_block_NF+0x1a5>
  80288a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80288d:	8b 00                	mov    (%eax),%eax
  80288f:	eb 05                	jmp    802896 <alloc_block_NF+0x1aa>
  802891:	b8 00 00 00 00       	mov    $0x0,%eax
  802896:	a3 40 41 80 00       	mov    %eax,0x804140
  80289b:	a1 40 41 80 00       	mov    0x804140,%eax
  8028a0:	85 c0                	test   %eax,%eax
  8028a2:	0f 85 65 fe ff ff    	jne    80270d <alloc_block_NF+0x21>
  8028a8:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8028ac:	0f 85 5b fe ff ff    	jne    80270d <alloc_block_NF+0x21>
			blk->sva+=newblk->size;
			newblk->sva = newveradd;
			return newblk;
		}
	}
	return NULL;
  8028b2:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8028b7:	c9                   	leave  
  8028b8:	c3                   	ret    

008028b9 <addToAvailMemBlocksList>:

//===================================================
// [8] INSERT BLOCK (SORTED WITH MERGE) IN FREE LIST:
//===================================================
void addToAvailMemBlocksList(struct MemBlock *blockToInsert)
{
  8028b9:	55                   	push   %ebp
  8028ba:	89 e5                	mov    %esp,%ebp
  8028bc:	83 ec 08             	sub    $0x8,%esp
	blockToInsert->sva = 0;
  8028bf:	8b 45 08             	mov    0x8(%ebp),%eax
  8028c2:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
	blockToInsert->size = 0;
  8028c9:	8b 45 08             	mov    0x8(%ebp),%eax
  8028cc:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
	//add to avail
	LIST_INSERT_TAIL(&AvailableMemBlocksList, blockToInsert);
  8028d3:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8028d7:	75 17                	jne    8028f0 <addToAvailMemBlocksList+0x37>
  8028d9:	83 ec 04             	sub    $0x4,%esp
  8028dc:	68 70 38 80 00       	push   $0x803870
  8028e1:	68 10 01 00 00       	push   $0x110
  8028e6:	68 57 38 80 00       	push   $0x803857
  8028eb:	e8 90 04 00 00       	call   802d80 <_panic>
  8028f0:	8b 15 4c 41 80 00    	mov    0x80414c,%edx
  8028f6:	8b 45 08             	mov    0x8(%ebp),%eax
  8028f9:	89 50 04             	mov    %edx,0x4(%eax)
  8028fc:	8b 45 08             	mov    0x8(%ebp),%eax
  8028ff:	8b 40 04             	mov    0x4(%eax),%eax
  802902:	85 c0                	test   %eax,%eax
  802904:	74 0c                	je     802912 <addToAvailMemBlocksList+0x59>
  802906:	a1 4c 41 80 00       	mov    0x80414c,%eax
  80290b:	8b 55 08             	mov    0x8(%ebp),%edx
  80290e:	89 10                	mov    %edx,(%eax)
  802910:	eb 08                	jmp    80291a <addToAvailMemBlocksList+0x61>
  802912:	8b 45 08             	mov    0x8(%ebp),%eax
  802915:	a3 48 41 80 00       	mov    %eax,0x804148
  80291a:	8b 45 08             	mov    0x8(%ebp),%eax
  80291d:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802922:	8b 45 08             	mov    0x8(%ebp),%eax
  802925:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80292b:	a1 54 41 80 00       	mov    0x804154,%eax
  802930:	40                   	inc    %eax
  802931:	a3 54 41 80 00       	mov    %eax,0x804154
}
  802936:	90                   	nop
  802937:	c9                   	leave  
  802938:	c3                   	ret    

00802939 <insert_sorted_with_merge_freeList>:
void insert_sorted_with_merge_freeList(struct MemBlock *blockToInsert)
{
  802939:	55                   	push   %ebp
  80293a:	89 e5                	mov    %esp,%ebp
  80293c:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] insert_sorted_with_merge_freeList
	// Write your code here, remove the panic and write your code

	struct MemBlock* last = LIST_LAST(&FreeMemBlocksList);
  80293f:	a1 3c 41 80 00       	mov    0x80413c,%eax
  802944:	89 45 f0             	mov    %eax,-0x10(%ebp)
	//check if list empty
	if (LIST_SIZE(&(FreeMemBlocksList)) == 0)
  802947:	a1 44 41 80 00       	mov    0x804144,%eax
  80294c:	85 c0                	test   %eax,%eax
  80294e:	75 68                	jne    8029b8 <insert_sorted_with_merge_freeList+0x7f>
		LIST_INSERT_HEAD(&FreeMemBlocksList, blockToInsert);
  802950:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802954:	75 17                	jne    80296d <insert_sorted_with_merge_freeList+0x34>
  802956:	83 ec 04             	sub    $0x4,%esp
  802959:	68 34 38 80 00       	push   $0x803834
  80295e:	68 1a 01 00 00       	push   $0x11a
  802963:	68 57 38 80 00       	push   $0x803857
  802968:	e8 13 04 00 00       	call   802d80 <_panic>
  80296d:	8b 15 38 41 80 00    	mov    0x804138,%edx
  802973:	8b 45 08             	mov    0x8(%ebp),%eax
  802976:	89 10                	mov    %edx,(%eax)
  802978:	8b 45 08             	mov    0x8(%ebp),%eax
  80297b:	8b 00                	mov    (%eax),%eax
  80297d:	85 c0                	test   %eax,%eax
  80297f:	74 0d                	je     80298e <insert_sorted_with_merge_freeList+0x55>
  802981:	a1 38 41 80 00       	mov    0x804138,%eax
  802986:	8b 55 08             	mov    0x8(%ebp),%edx
  802989:	89 50 04             	mov    %edx,0x4(%eax)
  80298c:	eb 08                	jmp    802996 <insert_sorted_with_merge_freeList+0x5d>
  80298e:	8b 45 08             	mov    0x8(%ebp),%eax
  802991:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802996:	8b 45 08             	mov    0x8(%ebp),%eax
  802999:	a3 38 41 80 00       	mov    %eax,0x804138
  80299e:	8b 45 08             	mov    0x8(%ebp),%eax
  8029a1:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8029a8:	a1 44 41 80 00       	mov    0x804144,%eax
  8029ad:	40                   	inc    %eax
  8029ae:	a3 44 41 80 00       	mov    %eax,0x804144
		}
	}

	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  8029b3:	e9 c5 03 00 00       	jmp    802d7d <insert_sorted_with_merge_freeList+0x444>
	struct MemBlock* last = LIST_LAST(&FreeMemBlocksList);
	//check if list empty
	if (LIST_SIZE(&(FreeMemBlocksList)) == 0)
		LIST_INSERT_HEAD(&FreeMemBlocksList, blockToInsert);
	//check if it's position is at last
	else if (last->sva < blockToInsert->sva) {
  8029b8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8029bb:	8b 50 08             	mov    0x8(%eax),%edx
  8029be:	8b 45 08             	mov    0x8(%ebp),%eax
  8029c1:	8b 40 08             	mov    0x8(%eax),%eax
  8029c4:	39 c2                	cmp    %eax,%edx
  8029c6:	0f 83 b2 00 00 00    	jae    802a7e <insert_sorted_with_merge_freeList+0x145>

		//if i have to merge
		if (last->sva + last->size == blockToInsert->sva) {
  8029cc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8029cf:	8b 50 08             	mov    0x8(%eax),%edx
  8029d2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8029d5:	8b 40 0c             	mov    0xc(%eax),%eax
  8029d8:	01 c2                	add    %eax,%edx
  8029da:	8b 45 08             	mov    0x8(%ebp),%eax
  8029dd:	8b 40 08             	mov    0x8(%eax),%eax
  8029e0:	39 c2                	cmp    %eax,%edx
  8029e2:	75 27                	jne    802a0b <insert_sorted_with_merge_freeList+0xd2>
			last->size = last->size + blockToInsert->size;
  8029e4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8029e7:	8b 50 0c             	mov    0xc(%eax),%edx
  8029ea:	8b 45 08             	mov    0x8(%ebp),%eax
  8029ed:	8b 40 0c             	mov    0xc(%eax),%eax
  8029f0:	01 c2                	add    %eax,%edx
  8029f2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8029f5:	89 50 0c             	mov    %edx,0xc(%eax)
			addToAvailMemBlocksList(blockToInsert);
  8029f8:	83 ec 0c             	sub    $0xc,%esp
  8029fb:	ff 75 08             	pushl  0x8(%ebp)
  8029fe:	e8 b6 fe ff ff       	call   8028b9 <addToAvailMemBlocksList>
  802a03:	83 c4 10             	add    $0x10,%esp
		}
	}

	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  802a06:	e9 72 03 00 00       	jmp    802d7d <insert_sorted_with_merge_freeList+0x444>
		if (last->sva + last->size == blockToInsert->sva) {
			last->size = last->size + blockToInsert->size;
			addToAvailMemBlocksList(blockToInsert);

		} else {
			LIST_INSERT_AFTER(&FreeMemBlocksList, last, blockToInsert);
  802a0b:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802a0f:	74 06                	je     802a17 <insert_sorted_with_merge_freeList+0xde>
  802a11:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802a15:	75 17                	jne    802a2e <insert_sorted_with_merge_freeList+0xf5>
  802a17:	83 ec 04             	sub    $0x4,%esp
  802a1a:	68 94 38 80 00       	push   $0x803894
  802a1f:	68 24 01 00 00       	push   $0x124
  802a24:	68 57 38 80 00       	push   $0x803857
  802a29:	e8 52 03 00 00       	call   802d80 <_panic>
  802a2e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a31:	8b 10                	mov    (%eax),%edx
  802a33:	8b 45 08             	mov    0x8(%ebp),%eax
  802a36:	89 10                	mov    %edx,(%eax)
  802a38:	8b 45 08             	mov    0x8(%ebp),%eax
  802a3b:	8b 00                	mov    (%eax),%eax
  802a3d:	85 c0                	test   %eax,%eax
  802a3f:	74 0b                	je     802a4c <insert_sorted_with_merge_freeList+0x113>
  802a41:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a44:	8b 00                	mov    (%eax),%eax
  802a46:	8b 55 08             	mov    0x8(%ebp),%edx
  802a49:	89 50 04             	mov    %edx,0x4(%eax)
  802a4c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a4f:	8b 55 08             	mov    0x8(%ebp),%edx
  802a52:	89 10                	mov    %edx,(%eax)
  802a54:	8b 45 08             	mov    0x8(%ebp),%eax
  802a57:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802a5a:	89 50 04             	mov    %edx,0x4(%eax)
  802a5d:	8b 45 08             	mov    0x8(%ebp),%eax
  802a60:	8b 00                	mov    (%eax),%eax
  802a62:	85 c0                	test   %eax,%eax
  802a64:	75 08                	jne    802a6e <insert_sorted_with_merge_freeList+0x135>
  802a66:	8b 45 08             	mov    0x8(%ebp),%eax
  802a69:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802a6e:	a1 44 41 80 00       	mov    0x804144,%eax
  802a73:	40                   	inc    %eax
  802a74:	a3 44 41 80 00       	mov    %eax,0x804144
		}
	}

	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  802a79:	e9 ff 02 00 00       	jmp    802d7d <insert_sorted_with_merge_freeList+0x444>
		} else {
			LIST_INSERT_AFTER(&FreeMemBlocksList, last, blockToInsert);
		}
	} else {
		struct MemBlock *iterator;
		LIST_FOREACH(iterator, &(FreeMemBlocksList))
  802a7e:	a1 38 41 80 00       	mov    0x804138,%eax
  802a83:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802a86:	e9 c2 02 00 00       	jmp    802d4d <insert_sorted_with_merge_freeList+0x414>
		{

			if (iterator->sva > blockToInsert->sva) {
  802a8b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a8e:	8b 50 08             	mov    0x8(%eax),%edx
  802a91:	8b 45 08             	mov    0x8(%ebp),%eax
  802a94:	8b 40 08             	mov    0x8(%eax),%eax
  802a97:	39 c2                	cmp    %eax,%edx
  802a99:	0f 86 a6 02 00 00    	jbe    802d45 <insert_sorted_with_merge_freeList+0x40c>

				struct MemBlock* prev = LIST_PREV(iterator);
  802a9f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802aa2:	8b 40 04             	mov    0x4(%eax),%eax
  802aa5:	89 45 ec             	mov    %eax,-0x14(%ebp)
				if (prev == NULL) {
  802aa8:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802aac:	0f 85 ba 00 00 00    	jne    802b6c <insert_sorted_with_merge_freeList+0x233>
					//check merge
					if (blockToInsert->size + blockToInsert->sva
  802ab2:	8b 45 08             	mov    0x8(%ebp),%eax
  802ab5:	8b 50 0c             	mov    0xc(%eax),%edx
  802ab8:	8b 45 08             	mov    0x8(%ebp),%eax
  802abb:	8b 40 08             	mov    0x8(%eax),%eax
  802abe:	01 c2                	add    %eax,%edx
							== iterator->sva) {
  802ac0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ac3:	8b 40 08             	mov    0x8(%eax),%eax
			if (iterator->sva > blockToInsert->sva) {

				struct MemBlock* prev = LIST_PREV(iterator);
				if (prev == NULL) {
					//check merge
					if (blockToInsert->size + blockToInsert->sva
  802ac6:	39 c2                	cmp    %eax,%edx
  802ac8:	75 33                	jne    802afd <insert_sorted_with_merge_freeList+0x1c4>
							== iterator->sva) {
						iterator->sva = blockToInsert->sva;
  802aca:	8b 45 08             	mov    0x8(%ebp),%eax
  802acd:	8b 50 08             	mov    0x8(%eax),%edx
  802ad0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ad3:	89 50 08             	mov    %edx,0x8(%eax)
						iterator->size = iterator->size + blockToInsert->size;
  802ad6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ad9:	8b 50 0c             	mov    0xc(%eax),%edx
  802adc:	8b 45 08             	mov    0x8(%ebp),%eax
  802adf:	8b 40 0c             	mov    0xc(%eax),%eax
  802ae2:	01 c2                	add    %eax,%edx
  802ae4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ae7:	89 50 0c             	mov    %edx,0xc(%eax)
						addToAvailMemBlocksList(blockToInsert);
  802aea:	83 ec 0c             	sub    $0xc,%esp
  802aed:	ff 75 08             	pushl  0x8(%ebp)
  802af0:	e8 c4 fd ff ff       	call   8028b9 <addToAvailMemBlocksList>
  802af5:	83 c4 10             	add    $0x10,%esp

					else {
						LIST_INSERT_BEFORE(&FreeMemBlocksList, iterator,
								blockToInsert);
					}
					break;
  802af8:	e9 80 02 00 00       	jmp    802d7d <insert_sorted_with_merge_freeList+0x444>
						addToAvailMemBlocksList(blockToInsert);

					}

					else {
						LIST_INSERT_BEFORE(&FreeMemBlocksList, iterator,
  802afd:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802b01:	74 06                	je     802b09 <insert_sorted_with_merge_freeList+0x1d0>
  802b03:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802b07:	75 17                	jne    802b20 <insert_sorted_with_merge_freeList+0x1e7>
  802b09:	83 ec 04             	sub    $0x4,%esp
  802b0c:	68 e8 38 80 00       	push   $0x8038e8
  802b11:	68 3a 01 00 00       	push   $0x13a
  802b16:	68 57 38 80 00       	push   $0x803857
  802b1b:	e8 60 02 00 00       	call   802d80 <_panic>
  802b20:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b23:	8b 50 04             	mov    0x4(%eax),%edx
  802b26:	8b 45 08             	mov    0x8(%ebp),%eax
  802b29:	89 50 04             	mov    %edx,0x4(%eax)
  802b2c:	8b 45 08             	mov    0x8(%ebp),%eax
  802b2f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802b32:	89 10                	mov    %edx,(%eax)
  802b34:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b37:	8b 40 04             	mov    0x4(%eax),%eax
  802b3a:	85 c0                	test   %eax,%eax
  802b3c:	74 0d                	je     802b4b <insert_sorted_with_merge_freeList+0x212>
  802b3e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b41:	8b 40 04             	mov    0x4(%eax),%eax
  802b44:	8b 55 08             	mov    0x8(%ebp),%edx
  802b47:	89 10                	mov    %edx,(%eax)
  802b49:	eb 08                	jmp    802b53 <insert_sorted_with_merge_freeList+0x21a>
  802b4b:	8b 45 08             	mov    0x8(%ebp),%eax
  802b4e:	a3 38 41 80 00       	mov    %eax,0x804138
  802b53:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b56:	8b 55 08             	mov    0x8(%ebp),%edx
  802b59:	89 50 04             	mov    %edx,0x4(%eax)
  802b5c:	a1 44 41 80 00       	mov    0x804144,%eax
  802b61:	40                   	inc    %eax
  802b62:	a3 44 41 80 00       	mov    %eax,0x804144
								blockToInsert);
					}
					break;
  802b67:	e9 11 02 00 00       	jmp    802d7d <insert_sorted_with_merge_freeList+0x444>
				} else {
					//prev and next merge
					if (prev->sva + prev->size + blockToInsert->size
  802b6c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802b6f:	8b 50 08             	mov    0x8(%eax),%edx
  802b72:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802b75:	8b 40 0c             	mov    0xc(%eax),%eax
  802b78:	01 c2                	add    %eax,%edx
  802b7a:	8b 45 08             	mov    0x8(%ebp),%eax
  802b7d:	8b 40 0c             	mov    0xc(%eax),%eax
  802b80:	01 c2                	add    %eax,%edx
							== iterator->sva) {
  802b82:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b85:	8b 40 08             	mov    0x8(%eax),%eax
								blockToInsert);
					}
					break;
				} else {
					//prev and next merge
					if (prev->sva + prev->size + blockToInsert->size
  802b88:	39 c2                	cmp    %eax,%edx
  802b8a:	0f 85 bf 00 00 00    	jne    802c4f <insert_sorted_with_merge_freeList+0x316>
							== iterator->sva) {
						prev->size = prev->size + blockToInsert->size
  802b90:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802b93:	8b 50 0c             	mov    0xc(%eax),%edx
  802b96:	8b 45 08             	mov    0x8(%ebp),%eax
  802b99:	8b 40 0c             	mov    0xc(%eax),%eax
  802b9c:	01 c2                	add    %eax,%edx
								+ iterator->size;
  802b9e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ba1:	8b 40 0c             	mov    0xc(%eax),%eax
  802ba4:	01 c2                	add    %eax,%edx
					break;
				} else {
					//prev and next merge
					if (prev->sva + prev->size + blockToInsert->size
							== iterator->sva) {
						prev->size = prev->size + blockToInsert->size
  802ba6:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802ba9:	89 50 0c             	mov    %edx,0xc(%eax)
								+ iterator->size;
						LIST_REMOVE(&FreeMemBlocksList, iterator);
  802bac:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802bb0:	75 17                	jne    802bc9 <insert_sorted_with_merge_freeList+0x290>
  802bb2:	83 ec 04             	sub    $0x4,%esp
  802bb5:	68 c8 38 80 00       	push   $0x8038c8
  802bba:	68 43 01 00 00       	push   $0x143
  802bbf:	68 57 38 80 00       	push   $0x803857
  802bc4:	e8 b7 01 00 00       	call   802d80 <_panic>
  802bc9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bcc:	8b 00                	mov    (%eax),%eax
  802bce:	85 c0                	test   %eax,%eax
  802bd0:	74 10                	je     802be2 <insert_sorted_with_merge_freeList+0x2a9>
  802bd2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bd5:	8b 00                	mov    (%eax),%eax
  802bd7:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802bda:	8b 52 04             	mov    0x4(%edx),%edx
  802bdd:	89 50 04             	mov    %edx,0x4(%eax)
  802be0:	eb 0b                	jmp    802bed <insert_sorted_with_merge_freeList+0x2b4>
  802be2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802be5:	8b 40 04             	mov    0x4(%eax),%eax
  802be8:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802bed:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bf0:	8b 40 04             	mov    0x4(%eax),%eax
  802bf3:	85 c0                	test   %eax,%eax
  802bf5:	74 0f                	je     802c06 <insert_sorted_with_merge_freeList+0x2cd>
  802bf7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bfa:	8b 40 04             	mov    0x4(%eax),%eax
  802bfd:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802c00:	8b 12                	mov    (%edx),%edx
  802c02:	89 10                	mov    %edx,(%eax)
  802c04:	eb 0a                	jmp    802c10 <insert_sorted_with_merge_freeList+0x2d7>
  802c06:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c09:	8b 00                	mov    (%eax),%eax
  802c0b:	a3 38 41 80 00       	mov    %eax,0x804138
  802c10:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c13:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802c19:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c1c:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802c23:	a1 44 41 80 00       	mov    0x804144,%eax
  802c28:	48                   	dec    %eax
  802c29:	a3 44 41 80 00       	mov    %eax,0x804144
						addToAvailMemBlocksList(blockToInsert);
  802c2e:	83 ec 0c             	sub    $0xc,%esp
  802c31:	ff 75 08             	pushl  0x8(%ebp)
  802c34:	e8 80 fc ff ff       	call   8028b9 <addToAvailMemBlocksList>
  802c39:	83 c4 10             	add    $0x10,%esp
						addToAvailMemBlocksList(iterator);
  802c3c:	83 ec 0c             	sub    $0xc,%esp
  802c3f:	ff 75 f4             	pushl  -0xc(%ebp)
  802c42:	e8 72 fc ff ff       	call   8028b9 <addToAvailMemBlocksList>
  802c47:	83 c4 10             	add    $0x10,%esp
					//Insert
					else {
						LIST_INSERT_BEFORE(&FreeMemBlocksList, iterator,
								blockToInsert);
					}
					break;
  802c4a:	e9 2e 01 00 00       	jmp    802d7d <insert_sorted_with_merge_freeList+0x444>
						LIST_REMOVE(&FreeMemBlocksList, iterator);
						addToAvailMemBlocksList(blockToInsert);
						addToAvailMemBlocksList(iterator);
					}
					//previous merge
					else if (prev->sva + prev->size == blockToInsert->sva) {
  802c4f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802c52:	8b 50 08             	mov    0x8(%eax),%edx
  802c55:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802c58:	8b 40 0c             	mov    0xc(%eax),%eax
  802c5b:	01 c2                	add    %eax,%edx
  802c5d:	8b 45 08             	mov    0x8(%ebp),%eax
  802c60:	8b 40 08             	mov    0x8(%eax),%eax
  802c63:	39 c2                	cmp    %eax,%edx
  802c65:	75 27                	jne    802c8e <insert_sorted_with_merge_freeList+0x355>
						prev->size = prev->size + blockToInsert->size;
  802c67:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802c6a:	8b 50 0c             	mov    0xc(%eax),%edx
  802c6d:	8b 45 08             	mov    0x8(%ebp),%eax
  802c70:	8b 40 0c             	mov    0xc(%eax),%eax
  802c73:	01 c2                	add    %eax,%edx
  802c75:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802c78:	89 50 0c             	mov    %edx,0xc(%eax)
						addToAvailMemBlocksList(blockToInsert);
  802c7b:	83 ec 0c             	sub    $0xc,%esp
  802c7e:	ff 75 08             	pushl  0x8(%ebp)
  802c81:	e8 33 fc ff ff       	call   8028b9 <addToAvailMemBlocksList>
  802c86:	83 c4 10             	add    $0x10,%esp
					//Insert
					else {
						LIST_INSERT_BEFORE(&FreeMemBlocksList, iterator,
								blockToInsert);
					}
					break;
  802c89:	e9 ef 00 00 00       	jmp    802d7d <insert_sorted_with_merge_freeList+0x444>
					else if (prev->sva + prev->size == blockToInsert->sva) {
						prev->size = prev->size + blockToInsert->size;
						addToAvailMemBlocksList(blockToInsert);
					}
					//next merge
					else if (blockToInsert->size + blockToInsert->sva
  802c8e:	8b 45 08             	mov    0x8(%ebp),%eax
  802c91:	8b 50 0c             	mov    0xc(%eax),%edx
  802c94:	8b 45 08             	mov    0x8(%ebp),%eax
  802c97:	8b 40 08             	mov    0x8(%eax),%eax
  802c9a:	01 c2                	add    %eax,%edx
							== iterator->sva) {
  802c9c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c9f:	8b 40 08             	mov    0x8(%eax),%eax
					else if (prev->sva + prev->size == blockToInsert->sva) {
						prev->size = prev->size + blockToInsert->size;
						addToAvailMemBlocksList(blockToInsert);
					}
					//next merge
					else if (blockToInsert->size + blockToInsert->sva
  802ca2:	39 c2                	cmp    %eax,%edx
  802ca4:	75 33                	jne    802cd9 <insert_sorted_with_merge_freeList+0x3a0>
							== iterator->sva) {
						iterator->sva = blockToInsert->sva;
  802ca6:	8b 45 08             	mov    0x8(%ebp),%eax
  802ca9:	8b 50 08             	mov    0x8(%eax),%edx
  802cac:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802caf:	89 50 08             	mov    %edx,0x8(%eax)
						iterator->size = iterator->size + blockToInsert->size;
  802cb2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cb5:	8b 50 0c             	mov    0xc(%eax),%edx
  802cb8:	8b 45 08             	mov    0x8(%ebp),%eax
  802cbb:	8b 40 0c             	mov    0xc(%eax),%eax
  802cbe:	01 c2                	add    %eax,%edx
  802cc0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cc3:	89 50 0c             	mov    %edx,0xc(%eax)
						addToAvailMemBlocksList(blockToInsert);
  802cc6:	83 ec 0c             	sub    $0xc,%esp
  802cc9:	ff 75 08             	pushl  0x8(%ebp)
  802ccc:	e8 e8 fb ff ff       	call   8028b9 <addToAvailMemBlocksList>
  802cd1:	83 c4 10             	add    $0x10,%esp
					//Insert
					else {
						LIST_INSERT_BEFORE(&FreeMemBlocksList, iterator,
								blockToInsert);
					}
					break;
  802cd4:	e9 a4 00 00 00       	jmp    802d7d <insert_sorted_with_merge_freeList+0x444>
						iterator->size = iterator->size + blockToInsert->size;
						addToAvailMemBlocksList(blockToInsert);
					}
					//Insert
					else {
						LIST_INSERT_BEFORE(&FreeMemBlocksList, iterator,
  802cd9:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802cdd:	74 06                	je     802ce5 <insert_sorted_with_merge_freeList+0x3ac>
  802cdf:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802ce3:	75 17                	jne    802cfc <insert_sorted_with_merge_freeList+0x3c3>
  802ce5:	83 ec 04             	sub    $0x4,%esp
  802ce8:	68 e8 38 80 00       	push   $0x8038e8
  802ced:	68 56 01 00 00       	push   $0x156
  802cf2:	68 57 38 80 00       	push   $0x803857
  802cf7:	e8 84 00 00 00       	call   802d80 <_panic>
  802cfc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cff:	8b 50 04             	mov    0x4(%eax),%edx
  802d02:	8b 45 08             	mov    0x8(%ebp),%eax
  802d05:	89 50 04             	mov    %edx,0x4(%eax)
  802d08:	8b 45 08             	mov    0x8(%ebp),%eax
  802d0b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802d0e:	89 10                	mov    %edx,(%eax)
  802d10:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d13:	8b 40 04             	mov    0x4(%eax),%eax
  802d16:	85 c0                	test   %eax,%eax
  802d18:	74 0d                	je     802d27 <insert_sorted_with_merge_freeList+0x3ee>
  802d1a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d1d:	8b 40 04             	mov    0x4(%eax),%eax
  802d20:	8b 55 08             	mov    0x8(%ebp),%edx
  802d23:	89 10                	mov    %edx,(%eax)
  802d25:	eb 08                	jmp    802d2f <insert_sorted_with_merge_freeList+0x3f6>
  802d27:	8b 45 08             	mov    0x8(%ebp),%eax
  802d2a:	a3 38 41 80 00       	mov    %eax,0x804138
  802d2f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d32:	8b 55 08             	mov    0x8(%ebp),%edx
  802d35:	89 50 04             	mov    %edx,0x4(%eax)
  802d38:	a1 44 41 80 00       	mov    0x804144,%eax
  802d3d:	40                   	inc    %eax
  802d3e:	a3 44 41 80 00       	mov    %eax,0x804144
								blockToInsert);
					}
					break;
  802d43:	eb 38                	jmp    802d7d <insert_sorted_with_merge_freeList+0x444>
		} else {
			LIST_INSERT_AFTER(&FreeMemBlocksList, last, blockToInsert);
		}
	} else {
		struct MemBlock *iterator;
		LIST_FOREACH(iterator, &(FreeMemBlocksList))
  802d45:	a1 40 41 80 00       	mov    0x804140,%eax
  802d4a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802d4d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802d51:	74 07                	je     802d5a <insert_sorted_with_merge_freeList+0x421>
  802d53:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d56:	8b 00                	mov    (%eax),%eax
  802d58:	eb 05                	jmp    802d5f <insert_sorted_with_merge_freeList+0x426>
  802d5a:	b8 00 00 00 00       	mov    $0x0,%eax
  802d5f:	a3 40 41 80 00       	mov    %eax,0x804140
  802d64:	a1 40 41 80 00       	mov    0x804140,%eax
  802d69:	85 c0                	test   %eax,%eax
  802d6b:	0f 85 1a fd ff ff    	jne    802a8b <insert_sorted_with_merge_freeList+0x152>
  802d71:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802d75:	0f 85 10 fd ff ff    	jne    802a8b <insert_sorted_with_merge_freeList+0x152>
		}
	}

	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  802d7b:	eb 00                	jmp    802d7d <insert_sorted_with_merge_freeList+0x444>
  802d7d:	90                   	nop
  802d7e:	c9                   	leave  
  802d7f:	c3                   	ret    

00802d80 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  802d80:	55                   	push   %ebp
  802d81:	89 e5                	mov    %esp,%ebp
  802d83:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  802d86:	8d 45 10             	lea    0x10(%ebp),%eax
  802d89:	83 c0 04             	add    $0x4,%eax
  802d8c:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  802d8f:	a1 60 41 80 00       	mov    0x804160,%eax
  802d94:	85 c0                	test   %eax,%eax
  802d96:	74 16                	je     802dae <_panic+0x2e>
		cprintf("%s: ", argv0);
  802d98:	a1 60 41 80 00       	mov    0x804160,%eax
  802d9d:	83 ec 08             	sub    $0x8,%esp
  802da0:	50                   	push   %eax
  802da1:	68 20 39 80 00       	push   $0x803920
  802da6:	e8 af d6 ff ff       	call   80045a <cprintf>
  802dab:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  802dae:	a1 00 40 80 00       	mov    0x804000,%eax
  802db3:	ff 75 0c             	pushl  0xc(%ebp)
  802db6:	ff 75 08             	pushl  0x8(%ebp)
  802db9:	50                   	push   %eax
  802dba:	68 25 39 80 00       	push   $0x803925
  802dbf:	e8 96 d6 ff ff       	call   80045a <cprintf>
  802dc4:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  802dc7:	8b 45 10             	mov    0x10(%ebp),%eax
  802dca:	83 ec 08             	sub    $0x8,%esp
  802dcd:	ff 75 f4             	pushl  -0xc(%ebp)
  802dd0:	50                   	push   %eax
  802dd1:	e8 19 d6 ff ff       	call   8003ef <vcprintf>
  802dd6:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  802dd9:	83 ec 08             	sub    $0x8,%esp
  802ddc:	6a 00                	push   $0x0
  802dde:	68 41 39 80 00       	push   $0x803941
  802de3:	e8 07 d6 ff ff       	call   8003ef <vcprintf>
  802de8:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  802deb:	e8 88 d5 ff ff       	call   800378 <exit>

	// should not return here
	while (1) ;
  802df0:	eb fe                	jmp    802df0 <_panic+0x70>

00802df2 <CheckWSWithoutLastIndex>:
}

void CheckWSWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  802df2:	55                   	push   %ebp
  802df3:	89 e5                	mov    %esp,%ebp
  802df5:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  802df8:	a1 20 40 80 00       	mov    0x804020,%eax
  802dfd:	8b 50 74             	mov    0x74(%eax),%edx
  802e00:	8b 45 0c             	mov    0xc(%ebp),%eax
  802e03:	39 c2                	cmp    %eax,%edx
  802e05:	74 14                	je     802e1b <CheckWSWithoutLastIndex+0x29>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  802e07:	83 ec 04             	sub    $0x4,%esp
  802e0a:	68 44 39 80 00       	push   $0x803944
  802e0f:	6a 26                	push   $0x26
  802e11:	68 90 39 80 00       	push   $0x803990
  802e16:	e8 65 ff ff ff       	call   802d80 <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  802e1b:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  802e22:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  802e29:	e9 c2 00 00 00       	jmp    802ef0 <CheckWSWithoutLastIndex+0xfe>
		if (expectedPages[e] == 0) {
  802e2e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e31:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  802e38:	8b 45 08             	mov    0x8(%ebp),%eax
  802e3b:	01 d0                	add    %edx,%eax
  802e3d:	8b 00                	mov    (%eax),%eax
  802e3f:	85 c0                	test   %eax,%eax
  802e41:	75 08                	jne    802e4b <CheckWSWithoutLastIndex+0x59>
			expectedNumOfEmptyLocs++;
  802e43:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  802e46:	e9 a2 00 00 00       	jmp    802eed <CheckWSWithoutLastIndex+0xfb>
		}
		int found = 0;
  802e4b:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  802e52:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  802e59:	eb 69                	jmp    802ec4 <CheckWSWithoutLastIndex+0xd2>
			if (myEnv->__uptr_pws[w].empty == 0) {
  802e5b:	a1 20 40 80 00       	mov    0x804020,%eax
  802e60:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  802e66:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802e69:	89 d0                	mov    %edx,%eax
  802e6b:	01 c0                	add    %eax,%eax
  802e6d:	01 d0                	add    %edx,%eax
  802e6f:	c1 e0 03             	shl    $0x3,%eax
  802e72:	01 c8                	add    %ecx,%eax
  802e74:	8a 40 04             	mov    0x4(%eax),%al
  802e77:	84 c0                	test   %al,%al
  802e79:	75 46                	jne    802ec1 <CheckWSWithoutLastIndex+0xcf>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  802e7b:	a1 20 40 80 00       	mov    0x804020,%eax
  802e80:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  802e86:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802e89:	89 d0                	mov    %edx,%eax
  802e8b:	01 c0                	add    %eax,%eax
  802e8d:	01 d0                	add    %edx,%eax
  802e8f:	c1 e0 03             	shl    $0x3,%eax
  802e92:	01 c8                	add    %ecx,%eax
  802e94:	8b 00                	mov    (%eax),%eax
  802e96:	89 45 dc             	mov    %eax,-0x24(%ebp)
  802e99:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802e9c:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  802ea1:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  802ea3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ea6:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  802ead:	8b 45 08             	mov    0x8(%ebp),%eax
  802eb0:	01 c8                	add    %ecx,%eax
  802eb2:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  802eb4:	39 c2                	cmp    %eax,%edx
  802eb6:	75 09                	jne    802ec1 <CheckWSWithoutLastIndex+0xcf>
						== expectedPages[e]) {
					found = 1;
  802eb8:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  802ebf:	eb 12                	jmp    802ed3 <CheckWSWithoutLastIndex+0xe1>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  802ec1:	ff 45 e8             	incl   -0x18(%ebp)
  802ec4:	a1 20 40 80 00       	mov    0x804020,%eax
  802ec9:	8b 50 74             	mov    0x74(%eax),%edx
  802ecc:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802ecf:	39 c2                	cmp    %eax,%edx
  802ed1:	77 88                	ja     802e5b <CheckWSWithoutLastIndex+0x69>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  802ed3:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802ed7:	75 14                	jne    802eed <CheckWSWithoutLastIndex+0xfb>
			panic(
  802ed9:	83 ec 04             	sub    $0x4,%esp
  802edc:	68 9c 39 80 00       	push   $0x80399c
  802ee1:	6a 3a                	push   $0x3a
  802ee3:	68 90 39 80 00       	push   $0x803990
  802ee8:	e8 93 fe ff ff       	call   802d80 <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  802eed:	ff 45 f0             	incl   -0x10(%ebp)
  802ef0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ef3:	3b 45 0c             	cmp    0xc(%ebp),%eax
  802ef6:	0f 8c 32 ff ff ff    	jl     802e2e <CheckWSWithoutLastIndex+0x3c>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  802efc:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  802f03:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  802f0a:	eb 26                	jmp    802f32 <CheckWSWithoutLastIndex+0x140>
		if (myEnv->__uptr_pws[w].empty == 1) {
  802f0c:	a1 20 40 80 00       	mov    0x804020,%eax
  802f11:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  802f17:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802f1a:	89 d0                	mov    %edx,%eax
  802f1c:	01 c0                	add    %eax,%eax
  802f1e:	01 d0                	add    %edx,%eax
  802f20:	c1 e0 03             	shl    $0x3,%eax
  802f23:	01 c8                	add    %ecx,%eax
  802f25:	8a 40 04             	mov    0x4(%eax),%al
  802f28:	3c 01                	cmp    $0x1,%al
  802f2a:	75 03                	jne    802f2f <CheckWSWithoutLastIndex+0x13d>
			actualNumOfEmptyLocs++;
  802f2c:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  802f2f:	ff 45 e0             	incl   -0x20(%ebp)
  802f32:	a1 20 40 80 00       	mov    0x804020,%eax
  802f37:	8b 50 74             	mov    0x74(%eax),%edx
  802f3a:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802f3d:	39 c2                	cmp    %eax,%edx
  802f3f:	77 cb                	ja     802f0c <CheckWSWithoutLastIndex+0x11a>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  802f41:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f44:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  802f47:	74 14                	je     802f5d <CheckWSWithoutLastIndex+0x16b>
		panic(
  802f49:	83 ec 04             	sub    $0x4,%esp
  802f4c:	68 f0 39 80 00       	push   $0x8039f0
  802f51:	6a 44                	push   $0x44
  802f53:	68 90 39 80 00       	push   $0x803990
  802f58:	e8 23 fe ff ff       	call   802d80 <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  802f5d:	90                   	nop
  802f5e:	c9                   	leave  
  802f5f:	c3                   	ret    

00802f60 <__udivdi3>:
  802f60:	55                   	push   %ebp
  802f61:	57                   	push   %edi
  802f62:	56                   	push   %esi
  802f63:	53                   	push   %ebx
  802f64:	83 ec 1c             	sub    $0x1c,%esp
  802f67:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  802f6b:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  802f6f:	8b 7c 24 38          	mov    0x38(%esp),%edi
  802f73:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  802f77:	89 ca                	mov    %ecx,%edx
  802f79:	89 f8                	mov    %edi,%eax
  802f7b:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  802f7f:	85 f6                	test   %esi,%esi
  802f81:	75 2d                	jne    802fb0 <__udivdi3+0x50>
  802f83:	39 cf                	cmp    %ecx,%edi
  802f85:	77 65                	ja     802fec <__udivdi3+0x8c>
  802f87:	89 fd                	mov    %edi,%ebp
  802f89:	85 ff                	test   %edi,%edi
  802f8b:	75 0b                	jne    802f98 <__udivdi3+0x38>
  802f8d:	b8 01 00 00 00       	mov    $0x1,%eax
  802f92:	31 d2                	xor    %edx,%edx
  802f94:	f7 f7                	div    %edi
  802f96:	89 c5                	mov    %eax,%ebp
  802f98:	31 d2                	xor    %edx,%edx
  802f9a:	89 c8                	mov    %ecx,%eax
  802f9c:	f7 f5                	div    %ebp
  802f9e:	89 c1                	mov    %eax,%ecx
  802fa0:	89 d8                	mov    %ebx,%eax
  802fa2:	f7 f5                	div    %ebp
  802fa4:	89 cf                	mov    %ecx,%edi
  802fa6:	89 fa                	mov    %edi,%edx
  802fa8:	83 c4 1c             	add    $0x1c,%esp
  802fab:	5b                   	pop    %ebx
  802fac:	5e                   	pop    %esi
  802fad:	5f                   	pop    %edi
  802fae:	5d                   	pop    %ebp
  802faf:	c3                   	ret    
  802fb0:	39 ce                	cmp    %ecx,%esi
  802fb2:	77 28                	ja     802fdc <__udivdi3+0x7c>
  802fb4:	0f bd fe             	bsr    %esi,%edi
  802fb7:	83 f7 1f             	xor    $0x1f,%edi
  802fba:	75 40                	jne    802ffc <__udivdi3+0x9c>
  802fbc:	39 ce                	cmp    %ecx,%esi
  802fbe:	72 0a                	jb     802fca <__udivdi3+0x6a>
  802fc0:	3b 44 24 08          	cmp    0x8(%esp),%eax
  802fc4:	0f 87 9e 00 00 00    	ja     803068 <__udivdi3+0x108>
  802fca:	b8 01 00 00 00       	mov    $0x1,%eax
  802fcf:	89 fa                	mov    %edi,%edx
  802fd1:	83 c4 1c             	add    $0x1c,%esp
  802fd4:	5b                   	pop    %ebx
  802fd5:	5e                   	pop    %esi
  802fd6:	5f                   	pop    %edi
  802fd7:	5d                   	pop    %ebp
  802fd8:	c3                   	ret    
  802fd9:	8d 76 00             	lea    0x0(%esi),%esi
  802fdc:	31 ff                	xor    %edi,%edi
  802fde:	31 c0                	xor    %eax,%eax
  802fe0:	89 fa                	mov    %edi,%edx
  802fe2:	83 c4 1c             	add    $0x1c,%esp
  802fe5:	5b                   	pop    %ebx
  802fe6:	5e                   	pop    %esi
  802fe7:	5f                   	pop    %edi
  802fe8:	5d                   	pop    %ebp
  802fe9:	c3                   	ret    
  802fea:	66 90                	xchg   %ax,%ax
  802fec:	89 d8                	mov    %ebx,%eax
  802fee:	f7 f7                	div    %edi
  802ff0:	31 ff                	xor    %edi,%edi
  802ff2:	89 fa                	mov    %edi,%edx
  802ff4:	83 c4 1c             	add    $0x1c,%esp
  802ff7:	5b                   	pop    %ebx
  802ff8:	5e                   	pop    %esi
  802ff9:	5f                   	pop    %edi
  802ffa:	5d                   	pop    %ebp
  802ffb:	c3                   	ret    
  802ffc:	bd 20 00 00 00       	mov    $0x20,%ebp
  803001:	89 eb                	mov    %ebp,%ebx
  803003:	29 fb                	sub    %edi,%ebx
  803005:	89 f9                	mov    %edi,%ecx
  803007:	d3 e6                	shl    %cl,%esi
  803009:	89 c5                	mov    %eax,%ebp
  80300b:	88 d9                	mov    %bl,%cl
  80300d:	d3 ed                	shr    %cl,%ebp
  80300f:	89 e9                	mov    %ebp,%ecx
  803011:	09 f1                	or     %esi,%ecx
  803013:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  803017:	89 f9                	mov    %edi,%ecx
  803019:	d3 e0                	shl    %cl,%eax
  80301b:	89 c5                	mov    %eax,%ebp
  80301d:	89 d6                	mov    %edx,%esi
  80301f:	88 d9                	mov    %bl,%cl
  803021:	d3 ee                	shr    %cl,%esi
  803023:	89 f9                	mov    %edi,%ecx
  803025:	d3 e2                	shl    %cl,%edx
  803027:	8b 44 24 08          	mov    0x8(%esp),%eax
  80302b:	88 d9                	mov    %bl,%cl
  80302d:	d3 e8                	shr    %cl,%eax
  80302f:	09 c2                	or     %eax,%edx
  803031:	89 d0                	mov    %edx,%eax
  803033:	89 f2                	mov    %esi,%edx
  803035:	f7 74 24 0c          	divl   0xc(%esp)
  803039:	89 d6                	mov    %edx,%esi
  80303b:	89 c3                	mov    %eax,%ebx
  80303d:	f7 e5                	mul    %ebp
  80303f:	39 d6                	cmp    %edx,%esi
  803041:	72 19                	jb     80305c <__udivdi3+0xfc>
  803043:	74 0b                	je     803050 <__udivdi3+0xf0>
  803045:	89 d8                	mov    %ebx,%eax
  803047:	31 ff                	xor    %edi,%edi
  803049:	e9 58 ff ff ff       	jmp    802fa6 <__udivdi3+0x46>
  80304e:	66 90                	xchg   %ax,%ax
  803050:	8b 54 24 08          	mov    0x8(%esp),%edx
  803054:	89 f9                	mov    %edi,%ecx
  803056:	d3 e2                	shl    %cl,%edx
  803058:	39 c2                	cmp    %eax,%edx
  80305a:	73 e9                	jae    803045 <__udivdi3+0xe5>
  80305c:	8d 43 ff             	lea    -0x1(%ebx),%eax
  80305f:	31 ff                	xor    %edi,%edi
  803061:	e9 40 ff ff ff       	jmp    802fa6 <__udivdi3+0x46>
  803066:	66 90                	xchg   %ax,%ax
  803068:	31 c0                	xor    %eax,%eax
  80306a:	e9 37 ff ff ff       	jmp    802fa6 <__udivdi3+0x46>
  80306f:	90                   	nop

00803070 <__umoddi3>:
  803070:	55                   	push   %ebp
  803071:	57                   	push   %edi
  803072:	56                   	push   %esi
  803073:	53                   	push   %ebx
  803074:	83 ec 1c             	sub    $0x1c,%esp
  803077:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  80307b:	8b 74 24 34          	mov    0x34(%esp),%esi
  80307f:	8b 7c 24 38          	mov    0x38(%esp),%edi
  803083:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  803087:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80308b:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  80308f:	89 f3                	mov    %esi,%ebx
  803091:	89 fa                	mov    %edi,%edx
  803093:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  803097:	89 34 24             	mov    %esi,(%esp)
  80309a:	85 c0                	test   %eax,%eax
  80309c:	75 1a                	jne    8030b8 <__umoddi3+0x48>
  80309e:	39 f7                	cmp    %esi,%edi
  8030a0:	0f 86 a2 00 00 00    	jbe    803148 <__umoddi3+0xd8>
  8030a6:	89 c8                	mov    %ecx,%eax
  8030a8:	89 f2                	mov    %esi,%edx
  8030aa:	f7 f7                	div    %edi
  8030ac:	89 d0                	mov    %edx,%eax
  8030ae:	31 d2                	xor    %edx,%edx
  8030b0:	83 c4 1c             	add    $0x1c,%esp
  8030b3:	5b                   	pop    %ebx
  8030b4:	5e                   	pop    %esi
  8030b5:	5f                   	pop    %edi
  8030b6:	5d                   	pop    %ebp
  8030b7:	c3                   	ret    
  8030b8:	39 f0                	cmp    %esi,%eax
  8030ba:	0f 87 ac 00 00 00    	ja     80316c <__umoddi3+0xfc>
  8030c0:	0f bd e8             	bsr    %eax,%ebp
  8030c3:	83 f5 1f             	xor    $0x1f,%ebp
  8030c6:	0f 84 ac 00 00 00    	je     803178 <__umoddi3+0x108>
  8030cc:	bf 20 00 00 00       	mov    $0x20,%edi
  8030d1:	29 ef                	sub    %ebp,%edi
  8030d3:	89 fe                	mov    %edi,%esi
  8030d5:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  8030d9:	89 e9                	mov    %ebp,%ecx
  8030db:	d3 e0                	shl    %cl,%eax
  8030dd:	89 d7                	mov    %edx,%edi
  8030df:	89 f1                	mov    %esi,%ecx
  8030e1:	d3 ef                	shr    %cl,%edi
  8030e3:	09 c7                	or     %eax,%edi
  8030e5:	89 e9                	mov    %ebp,%ecx
  8030e7:	d3 e2                	shl    %cl,%edx
  8030e9:	89 14 24             	mov    %edx,(%esp)
  8030ec:	89 d8                	mov    %ebx,%eax
  8030ee:	d3 e0                	shl    %cl,%eax
  8030f0:	89 c2                	mov    %eax,%edx
  8030f2:	8b 44 24 08          	mov    0x8(%esp),%eax
  8030f6:	d3 e0                	shl    %cl,%eax
  8030f8:	89 44 24 04          	mov    %eax,0x4(%esp)
  8030fc:	8b 44 24 08          	mov    0x8(%esp),%eax
  803100:	89 f1                	mov    %esi,%ecx
  803102:	d3 e8                	shr    %cl,%eax
  803104:	09 d0                	or     %edx,%eax
  803106:	d3 eb                	shr    %cl,%ebx
  803108:	89 da                	mov    %ebx,%edx
  80310a:	f7 f7                	div    %edi
  80310c:	89 d3                	mov    %edx,%ebx
  80310e:	f7 24 24             	mull   (%esp)
  803111:	89 c6                	mov    %eax,%esi
  803113:	89 d1                	mov    %edx,%ecx
  803115:	39 d3                	cmp    %edx,%ebx
  803117:	0f 82 87 00 00 00    	jb     8031a4 <__umoddi3+0x134>
  80311d:	0f 84 91 00 00 00    	je     8031b4 <__umoddi3+0x144>
  803123:	8b 54 24 04          	mov    0x4(%esp),%edx
  803127:	29 f2                	sub    %esi,%edx
  803129:	19 cb                	sbb    %ecx,%ebx
  80312b:	89 d8                	mov    %ebx,%eax
  80312d:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  803131:	d3 e0                	shl    %cl,%eax
  803133:	89 e9                	mov    %ebp,%ecx
  803135:	d3 ea                	shr    %cl,%edx
  803137:	09 d0                	or     %edx,%eax
  803139:	89 e9                	mov    %ebp,%ecx
  80313b:	d3 eb                	shr    %cl,%ebx
  80313d:	89 da                	mov    %ebx,%edx
  80313f:	83 c4 1c             	add    $0x1c,%esp
  803142:	5b                   	pop    %ebx
  803143:	5e                   	pop    %esi
  803144:	5f                   	pop    %edi
  803145:	5d                   	pop    %ebp
  803146:	c3                   	ret    
  803147:	90                   	nop
  803148:	89 fd                	mov    %edi,%ebp
  80314a:	85 ff                	test   %edi,%edi
  80314c:	75 0b                	jne    803159 <__umoddi3+0xe9>
  80314e:	b8 01 00 00 00       	mov    $0x1,%eax
  803153:	31 d2                	xor    %edx,%edx
  803155:	f7 f7                	div    %edi
  803157:	89 c5                	mov    %eax,%ebp
  803159:	89 f0                	mov    %esi,%eax
  80315b:	31 d2                	xor    %edx,%edx
  80315d:	f7 f5                	div    %ebp
  80315f:	89 c8                	mov    %ecx,%eax
  803161:	f7 f5                	div    %ebp
  803163:	89 d0                	mov    %edx,%eax
  803165:	e9 44 ff ff ff       	jmp    8030ae <__umoddi3+0x3e>
  80316a:	66 90                	xchg   %ax,%ax
  80316c:	89 c8                	mov    %ecx,%eax
  80316e:	89 f2                	mov    %esi,%edx
  803170:	83 c4 1c             	add    $0x1c,%esp
  803173:	5b                   	pop    %ebx
  803174:	5e                   	pop    %esi
  803175:	5f                   	pop    %edi
  803176:	5d                   	pop    %ebp
  803177:	c3                   	ret    
  803178:	3b 04 24             	cmp    (%esp),%eax
  80317b:	72 06                	jb     803183 <__umoddi3+0x113>
  80317d:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  803181:	77 0f                	ja     803192 <__umoddi3+0x122>
  803183:	89 f2                	mov    %esi,%edx
  803185:	29 f9                	sub    %edi,%ecx
  803187:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  80318b:	89 14 24             	mov    %edx,(%esp)
  80318e:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  803192:	8b 44 24 04          	mov    0x4(%esp),%eax
  803196:	8b 14 24             	mov    (%esp),%edx
  803199:	83 c4 1c             	add    $0x1c,%esp
  80319c:	5b                   	pop    %ebx
  80319d:	5e                   	pop    %esi
  80319e:	5f                   	pop    %edi
  80319f:	5d                   	pop    %ebp
  8031a0:	c3                   	ret    
  8031a1:	8d 76 00             	lea    0x0(%esi),%esi
  8031a4:	2b 04 24             	sub    (%esp),%eax
  8031a7:	19 fa                	sbb    %edi,%edx
  8031a9:	89 d1                	mov    %edx,%ecx
  8031ab:	89 c6                	mov    %eax,%esi
  8031ad:	e9 71 ff ff ff       	jmp    803123 <__umoddi3+0xb3>
  8031b2:	66 90                	xchg   %ax,%ax
  8031b4:	39 44 24 04          	cmp    %eax,0x4(%esp)
  8031b8:	72 ea                	jb     8031a4 <__umoddi3+0x134>
  8031ba:	89 d9                	mov    %ebx,%ecx
  8031bc:	e9 62 ff ff ff       	jmp    803123 <__umoddi3+0xb3>
