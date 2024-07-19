
obj/user/arrayOperations_Master:     file format elf32-i386


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
  800031:	e8 2b 07 00 00       	call   800761 <libmain>
1:      jmp 1b
  800036:	eb fe                	jmp    800036 <args_exist+0x5>

00800038 <_main>:
uint32 CheckSorted(int *Elements, int NumOfElements);
void ArrayStats(int *Elements, int NumOfElements, int *mean, int *var);

void
_main(void)
{
  800038:	55                   	push   %ebp
  800039:	89 e5                	mov    %esp,%ebp
  80003b:	81 ec 88 00 00 00    	sub    $0x88,%esp
	/*[1] CREATE SHARED ARRAY*/
	int ret;
	char Chose;
	char Line[30];
	//2012: lock the interrupt
	sys_disable_interrupt();
  800041:	e8 9c 21 00 00       	call   8021e2 <sys_disable_interrupt>
		cprintf("\n");
  800046:	83 ec 0c             	sub    $0xc,%esp
  800049:	68 00 39 80 00       	push   $0x803900
  80004e:	e8 fe 0a 00 00       	call   800b51 <cprintf>
  800053:	83 c4 10             	add    $0x10,%esp
		cprintf("!!!!!!!!!!!!!!!!!!!!!!!!!!!!\n");
  800056:	83 ec 0c             	sub    $0xc,%esp
  800059:	68 02 39 80 00       	push   $0x803902
  80005e:	e8 ee 0a 00 00       	call   800b51 <cprintf>
  800063:	83 c4 10             	add    $0x10,%esp
		cprintf("!!!   ARRAY OOERATIONS   !!!\n");
  800066:	83 ec 0c             	sub    $0xc,%esp
  800069:	68 20 39 80 00       	push   $0x803920
  80006e:	e8 de 0a 00 00       	call   800b51 <cprintf>
  800073:	83 c4 10             	add    $0x10,%esp
		cprintf("!!!!!!!!!!!!!!!!!!!!!!!!!!!!\n");
  800076:	83 ec 0c             	sub    $0xc,%esp
  800079:	68 02 39 80 00       	push   $0x803902
  80007e:	e8 ce 0a 00 00       	call   800b51 <cprintf>
  800083:	83 c4 10             	add    $0x10,%esp
		cprintf("\n");
  800086:	83 ec 0c             	sub    $0xc,%esp
  800089:	68 00 39 80 00       	push   $0x803900
  80008e:	e8 be 0a 00 00       	call   800b51 <cprintf>
  800093:	83 c4 10             	add    $0x10,%esp

		readline("Enter the number of elements: ", Line);
  800096:	83 ec 08             	sub    $0x8,%esp
  800099:	8d 45 82             	lea    -0x7e(%ebp),%eax
  80009c:	50                   	push   %eax
  80009d:	68 40 39 80 00       	push   $0x803940
  8000a2:	e8 2c 11 00 00       	call   8011d3 <readline>
  8000a7:	83 c4 10             	add    $0x10,%esp

		//Create the shared array & its size
		int *arrSize = smalloc("arrSize", sizeof(int) , 0) ;
  8000aa:	83 ec 04             	sub    $0x4,%esp
  8000ad:	6a 00                	push   $0x0
  8000af:	6a 04                	push   $0x4
  8000b1:	68 5f 39 80 00       	push   $0x80395f
  8000b6:	e8 76 1d 00 00       	call   801e31 <smalloc>
  8000bb:	83 c4 10             	add    $0x10,%esp
  8000be:	89 45 f4             	mov    %eax,-0xc(%ebp)
		*arrSize = strtol(Line, NULL, 10) ;
  8000c1:	83 ec 04             	sub    $0x4,%esp
  8000c4:	6a 0a                	push   $0xa
  8000c6:	6a 00                	push   $0x0
  8000c8:	8d 45 82             	lea    -0x7e(%ebp),%eax
  8000cb:	50                   	push   %eax
  8000cc:	e8 68 16 00 00       	call   801739 <strtol>
  8000d1:	83 c4 10             	add    $0x10,%esp
  8000d4:	89 c2                	mov    %eax,%edx
  8000d6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8000d9:	89 10                	mov    %edx,(%eax)
		int NumOfElements = *arrSize;
  8000db:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8000de:	8b 00                	mov    (%eax),%eax
  8000e0:	89 45 f0             	mov    %eax,-0x10(%ebp)
		int *Elements = smalloc("arr", sizeof(int) * NumOfElements , 0) ;
  8000e3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8000e6:	c1 e0 02             	shl    $0x2,%eax
  8000e9:	83 ec 04             	sub    $0x4,%esp
  8000ec:	6a 00                	push   $0x0
  8000ee:	50                   	push   %eax
  8000ef:	68 67 39 80 00       	push   $0x803967
  8000f4:	e8 38 1d 00 00       	call   801e31 <smalloc>
  8000f9:	83 c4 10             	add    $0x10,%esp
  8000fc:	89 45 ec             	mov    %eax,-0x14(%ebp)

		cprintf("Chose the initialization method:\n") ;
  8000ff:	83 ec 0c             	sub    $0xc,%esp
  800102:	68 6c 39 80 00       	push   $0x80396c
  800107:	e8 45 0a 00 00       	call   800b51 <cprintf>
  80010c:	83 c4 10             	add    $0x10,%esp
		cprintf("a) Ascending\n") ;
  80010f:	83 ec 0c             	sub    $0xc,%esp
  800112:	68 8e 39 80 00       	push   $0x80398e
  800117:	e8 35 0a 00 00       	call   800b51 <cprintf>
  80011c:	83 c4 10             	add    $0x10,%esp
		cprintf("b) Descending\n") ;
  80011f:	83 ec 0c             	sub    $0xc,%esp
  800122:	68 9c 39 80 00       	push   $0x80399c
  800127:	e8 25 0a 00 00       	call   800b51 <cprintf>
  80012c:	83 c4 10             	add    $0x10,%esp
		cprintf("c) Semi random\n");
  80012f:	83 ec 0c             	sub    $0xc,%esp
  800132:	68 ab 39 80 00       	push   $0x8039ab
  800137:	e8 15 0a 00 00       	call   800b51 <cprintf>
  80013c:	83 c4 10             	add    $0x10,%esp
		do
		{
			cprintf("Select: ") ;
  80013f:	83 ec 0c             	sub    $0xc,%esp
  800142:	68 bb 39 80 00       	push   $0x8039bb
  800147:	e8 05 0a 00 00       	call   800b51 <cprintf>
  80014c:	83 c4 10             	add    $0x10,%esp
			Chose = getchar() ;
  80014f:	e8 b5 05 00 00       	call   800709 <getchar>
  800154:	88 45 eb             	mov    %al,-0x15(%ebp)
			cputchar(Chose);
  800157:	0f be 45 eb          	movsbl -0x15(%ebp),%eax
  80015b:	83 ec 0c             	sub    $0xc,%esp
  80015e:	50                   	push   %eax
  80015f:	e8 5d 05 00 00       	call   8006c1 <cputchar>
  800164:	83 c4 10             	add    $0x10,%esp
			cputchar('\n');
  800167:	83 ec 0c             	sub    $0xc,%esp
  80016a:	6a 0a                	push   $0xa
  80016c:	e8 50 05 00 00       	call   8006c1 <cputchar>
  800171:	83 c4 10             	add    $0x10,%esp
		} while (Chose != 'a' && Chose != 'b' && Chose != 'c');
  800174:	80 7d eb 61          	cmpb   $0x61,-0x15(%ebp)
  800178:	74 0c                	je     800186 <_main+0x14e>
  80017a:	80 7d eb 62          	cmpb   $0x62,-0x15(%ebp)
  80017e:	74 06                	je     800186 <_main+0x14e>
  800180:	80 7d eb 63          	cmpb   $0x63,-0x15(%ebp)
  800184:	75 b9                	jne    80013f <_main+0x107>

	//2012: unlock the interrupt
	sys_enable_interrupt();
  800186:	e8 71 20 00 00       	call   8021fc <sys_enable_interrupt>

	int  i ;
	switch (Chose)
  80018b:	0f be 45 eb          	movsbl -0x15(%ebp),%eax
  80018f:	83 f8 62             	cmp    $0x62,%eax
  800192:	74 1d                	je     8001b1 <_main+0x179>
  800194:	83 f8 63             	cmp    $0x63,%eax
  800197:	74 2b                	je     8001c4 <_main+0x18c>
  800199:	83 f8 61             	cmp    $0x61,%eax
  80019c:	75 39                	jne    8001d7 <_main+0x19f>
	{
	case 'a':
		InitializeAscending(Elements, NumOfElements);
  80019e:	83 ec 08             	sub    $0x8,%esp
  8001a1:	ff 75 f0             	pushl  -0x10(%ebp)
  8001a4:	ff 75 ec             	pushl  -0x14(%ebp)
  8001a7:	e8 9b 03 00 00       	call   800547 <InitializeAscending>
  8001ac:	83 c4 10             	add    $0x10,%esp
		break ;
  8001af:	eb 37                	jmp    8001e8 <_main+0x1b0>
	case 'b':
		InitializeDescending(Elements, NumOfElements);
  8001b1:	83 ec 08             	sub    $0x8,%esp
  8001b4:	ff 75 f0             	pushl  -0x10(%ebp)
  8001b7:	ff 75 ec             	pushl  -0x14(%ebp)
  8001ba:	e8 b9 03 00 00       	call   800578 <InitializeDescending>
  8001bf:	83 c4 10             	add    $0x10,%esp
		break ;
  8001c2:	eb 24                	jmp    8001e8 <_main+0x1b0>
	case 'c':
		InitializeSemiRandom(Elements, NumOfElements);
  8001c4:	83 ec 08             	sub    $0x8,%esp
  8001c7:	ff 75 f0             	pushl  -0x10(%ebp)
  8001ca:	ff 75 ec             	pushl  -0x14(%ebp)
  8001cd:	e8 db 03 00 00       	call   8005ad <InitializeSemiRandom>
  8001d2:	83 c4 10             	add    $0x10,%esp
		break ;
  8001d5:	eb 11                	jmp    8001e8 <_main+0x1b0>
	default:
		InitializeSemiRandom(Elements, NumOfElements);
  8001d7:	83 ec 08             	sub    $0x8,%esp
  8001da:	ff 75 f0             	pushl  -0x10(%ebp)
  8001dd:	ff 75 ec             	pushl  -0x14(%ebp)
  8001e0:	e8 c8 03 00 00       	call   8005ad <InitializeSemiRandom>
  8001e5:	83 c4 10             	add    $0x10,%esp
	}

	//Create the check-finishing counter
	int numOfSlaveProgs = 3 ;
  8001e8:	c7 45 e4 03 00 00 00 	movl   $0x3,-0x1c(%ebp)
	int *numOfFinished = smalloc("finishedCount", sizeof(int), 1) ;
  8001ef:	83 ec 04             	sub    $0x4,%esp
  8001f2:	6a 01                	push   $0x1
  8001f4:	6a 04                	push   $0x4
  8001f6:	68 c4 39 80 00       	push   $0x8039c4
  8001fb:	e8 31 1c 00 00       	call   801e31 <smalloc>
  800200:	83 c4 10             	add    $0x10,%esp
  800203:	89 45 e0             	mov    %eax,-0x20(%ebp)
	*numOfFinished = 0 ;
  800206:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800209:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

	/*[2] RUN THE SLAVES PROGRAMS*/
	int32 envIdQuickSort = sys_create_env("slave_qs", (myEnv->page_WS_max_size),(myEnv->SecondListSize) ,(myEnv->percentage_of_WS_pages_to_be_removed));
  80020f:	a1 20 50 80 00       	mov    0x805020,%eax
  800214:	8b 90 a0 05 00 00    	mov    0x5a0(%eax),%edx
  80021a:	a1 20 50 80 00       	mov    0x805020,%eax
  80021f:	8b 80 ec 05 00 00    	mov    0x5ec(%eax),%eax
  800225:	89 c1                	mov    %eax,%ecx
  800227:	a1 20 50 80 00       	mov    0x805020,%eax
  80022c:	8b 40 74             	mov    0x74(%eax),%eax
  80022f:	52                   	push   %edx
  800230:	51                   	push   %ecx
  800231:	50                   	push   %eax
  800232:	68 d2 39 80 00       	push   $0x8039d2
  800237:	e8 2b 21 00 00       	call   802367 <sys_create_env>
  80023c:	83 c4 10             	add    $0x10,%esp
  80023f:	89 45 dc             	mov    %eax,-0x24(%ebp)
	int32 envIdMergeSort = sys_create_env("slave_ms", (myEnv->page_WS_max_size),(myEnv->SecondListSize), (myEnv->percentage_of_WS_pages_to_be_removed));
  800242:	a1 20 50 80 00       	mov    0x805020,%eax
  800247:	8b 90 a0 05 00 00    	mov    0x5a0(%eax),%edx
  80024d:	a1 20 50 80 00       	mov    0x805020,%eax
  800252:	8b 80 ec 05 00 00    	mov    0x5ec(%eax),%eax
  800258:	89 c1                	mov    %eax,%ecx
  80025a:	a1 20 50 80 00       	mov    0x805020,%eax
  80025f:	8b 40 74             	mov    0x74(%eax),%eax
  800262:	52                   	push   %edx
  800263:	51                   	push   %ecx
  800264:	50                   	push   %eax
  800265:	68 db 39 80 00       	push   $0x8039db
  80026a:	e8 f8 20 00 00       	call   802367 <sys_create_env>
  80026f:	83 c4 10             	add    $0x10,%esp
  800272:	89 45 d8             	mov    %eax,-0x28(%ebp)
	int32 envIdStats = sys_create_env("slave_stats", (myEnv->page_WS_max_size), (myEnv->SecondListSize),(myEnv->percentage_of_WS_pages_to_be_removed));
  800275:	a1 20 50 80 00       	mov    0x805020,%eax
  80027a:	8b 90 a0 05 00 00    	mov    0x5a0(%eax),%edx
  800280:	a1 20 50 80 00       	mov    0x805020,%eax
  800285:	8b 80 ec 05 00 00    	mov    0x5ec(%eax),%eax
  80028b:	89 c1                	mov    %eax,%ecx
  80028d:	a1 20 50 80 00       	mov    0x805020,%eax
  800292:	8b 40 74             	mov    0x74(%eax),%eax
  800295:	52                   	push   %edx
  800296:	51                   	push   %ecx
  800297:	50                   	push   %eax
  800298:	68 e4 39 80 00       	push   $0x8039e4
  80029d:	e8 c5 20 00 00       	call   802367 <sys_create_env>
  8002a2:	83 c4 10             	add    $0x10,%esp
  8002a5:	89 45 d4             	mov    %eax,-0x2c(%ebp)

	if (envIdQuickSort == E_ENV_CREATION_ERROR || envIdMergeSort == E_ENV_CREATION_ERROR || envIdStats == E_ENV_CREATION_ERROR)
  8002a8:	83 7d dc ef          	cmpl   $0xffffffef,-0x24(%ebp)
  8002ac:	74 0c                	je     8002ba <_main+0x282>
  8002ae:	83 7d d8 ef          	cmpl   $0xffffffef,-0x28(%ebp)
  8002b2:	74 06                	je     8002ba <_main+0x282>
  8002b4:	83 7d d4 ef          	cmpl   $0xffffffef,-0x2c(%ebp)
  8002b8:	75 14                	jne    8002ce <_main+0x296>
		panic("NO AVAILABLE ENVs...");
  8002ba:	83 ec 04             	sub    $0x4,%esp
  8002bd:	68 f0 39 80 00       	push   $0x8039f0
  8002c2:	6a 4b                	push   $0x4b
  8002c4:	68 05 3a 80 00       	push   $0x803a05
  8002c9:	e8 cf 05 00 00       	call   80089d <_panic>

	sys_run_env(envIdQuickSort);
  8002ce:	83 ec 0c             	sub    $0xc,%esp
  8002d1:	ff 75 dc             	pushl  -0x24(%ebp)
  8002d4:	e8 ac 20 00 00       	call   802385 <sys_run_env>
  8002d9:	83 c4 10             	add    $0x10,%esp
	sys_run_env(envIdMergeSort);
  8002dc:	83 ec 0c             	sub    $0xc,%esp
  8002df:	ff 75 d8             	pushl  -0x28(%ebp)
  8002e2:	e8 9e 20 00 00       	call   802385 <sys_run_env>
  8002e7:	83 c4 10             	add    $0x10,%esp
	sys_run_env(envIdStats);
  8002ea:	83 ec 0c             	sub    $0xc,%esp
  8002ed:	ff 75 d4             	pushl  -0x2c(%ebp)
  8002f0:	e8 90 20 00 00       	call   802385 <sys_run_env>
  8002f5:	83 c4 10             	add    $0x10,%esp

	/*[3] BUSY-WAIT TILL FINISHING THEM*/
	while (*numOfFinished != numOfSlaveProgs) ;
  8002f8:	90                   	nop
  8002f9:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8002fc:	8b 00                	mov    (%eax),%eax
  8002fe:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  800301:	75 f6                	jne    8002f9 <_main+0x2c1>

	/*[4] GET THEIR RESULTS*/
	int *quicksortedArr = NULL;
  800303:	c7 45 d0 00 00 00 00 	movl   $0x0,-0x30(%ebp)
	int *mergesortedArr = NULL;
  80030a:	c7 45 cc 00 00 00 00 	movl   $0x0,-0x34(%ebp)
	int *mean = NULL;
  800311:	c7 45 c8 00 00 00 00 	movl   $0x0,-0x38(%ebp)
	int *var = NULL;
  800318:	c7 45 c4 00 00 00 00 	movl   $0x0,-0x3c(%ebp)
	int *min = NULL;
  80031f:	c7 45 c0 00 00 00 00 	movl   $0x0,-0x40(%ebp)
	int *max = NULL;
  800326:	c7 45 bc 00 00 00 00 	movl   $0x0,-0x44(%ebp)
	int *med = NULL;
  80032d:	c7 45 b8 00 00 00 00 	movl   $0x0,-0x48(%ebp)
	quicksortedArr = sget(envIdQuickSort, "quicksortedArr") ;
  800334:	83 ec 08             	sub    $0x8,%esp
  800337:	68 23 3a 80 00       	push   $0x803a23
  80033c:	ff 75 dc             	pushl  -0x24(%ebp)
  80033f:	e8 9d 1b 00 00       	call   801ee1 <sget>
  800344:	83 c4 10             	add    $0x10,%esp
  800347:	89 45 d0             	mov    %eax,-0x30(%ebp)
	mergesortedArr = sget(envIdMergeSort, "mergesortedArr") ;
  80034a:	83 ec 08             	sub    $0x8,%esp
  80034d:	68 32 3a 80 00       	push   $0x803a32
  800352:	ff 75 d8             	pushl  -0x28(%ebp)
  800355:	e8 87 1b 00 00       	call   801ee1 <sget>
  80035a:	83 c4 10             	add    $0x10,%esp
  80035d:	89 45 cc             	mov    %eax,-0x34(%ebp)
	mean = sget(envIdStats, "mean") ;
  800360:	83 ec 08             	sub    $0x8,%esp
  800363:	68 41 3a 80 00       	push   $0x803a41
  800368:	ff 75 d4             	pushl  -0x2c(%ebp)
  80036b:	e8 71 1b 00 00       	call   801ee1 <sget>
  800370:	83 c4 10             	add    $0x10,%esp
  800373:	89 45 c8             	mov    %eax,-0x38(%ebp)
	var = sget(envIdStats,"var") ;
  800376:	83 ec 08             	sub    $0x8,%esp
  800379:	68 46 3a 80 00       	push   $0x803a46
  80037e:	ff 75 d4             	pushl  -0x2c(%ebp)
  800381:	e8 5b 1b 00 00       	call   801ee1 <sget>
  800386:	83 c4 10             	add    $0x10,%esp
  800389:	89 45 c4             	mov    %eax,-0x3c(%ebp)
	min = sget(envIdStats,"min") ;
  80038c:	83 ec 08             	sub    $0x8,%esp
  80038f:	68 4a 3a 80 00       	push   $0x803a4a
  800394:	ff 75 d4             	pushl  -0x2c(%ebp)
  800397:	e8 45 1b 00 00       	call   801ee1 <sget>
  80039c:	83 c4 10             	add    $0x10,%esp
  80039f:	89 45 c0             	mov    %eax,-0x40(%ebp)
	max = sget(envIdStats,"max") ;
  8003a2:	83 ec 08             	sub    $0x8,%esp
  8003a5:	68 4e 3a 80 00       	push   $0x803a4e
  8003aa:	ff 75 d4             	pushl  -0x2c(%ebp)
  8003ad:	e8 2f 1b 00 00       	call   801ee1 <sget>
  8003b2:	83 c4 10             	add    $0x10,%esp
  8003b5:	89 45 bc             	mov    %eax,-0x44(%ebp)
	med = sget(envIdStats,"med") ;
  8003b8:	83 ec 08             	sub    $0x8,%esp
  8003bb:	68 52 3a 80 00       	push   $0x803a52
  8003c0:	ff 75 d4             	pushl  -0x2c(%ebp)
  8003c3:	e8 19 1b 00 00       	call   801ee1 <sget>
  8003c8:	83 c4 10             	add    $0x10,%esp
  8003cb:	89 45 b8             	mov    %eax,-0x48(%ebp)

	/*[5] VALIDATE THE RESULTS*/
	uint32 sorted = CheckSorted(quicksortedArr, NumOfElements);
  8003ce:	83 ec 08             	sub    $0x8,%esp
  8003d1:	ff 75 f0             	pushl  -0x10(%ebp)
  8003d4:	ff 75 d0             	pushl  -0x30(%ebp)
  8003d7:	e8 14 01 00 00       	call   8004f0 <CheckSorted>
  8003dc:	83 c4 10             	add    $0x10,%esp
  8003df:	89 45 b4             	mov    %eax,-0x4c(%ebp)
	if(sorted == 0) panic("The array is NOT quick-sorted correctly") ;
  8003e2:	83 7d b4 00          	cmpl   $0x0,-0x4c(%ebp)
  8003e6:	75 14                	jne    8003fc <_main+0x3c4>
  8003e8:	83 ec 04             	sub    $0x4,%esp
  8003eb:	68 58 3a 80 00       	push   $0x803a58
  8003f0:	6a 66                	push   $0x66
  8003f2:	68 05 3a 80 00       	push   $0x803a05
  8003f7:	e8 a1 04 00 00       	call   80089d <_panic>
	sorted = CheckSorted(mergesortedArr, NumOfElements);
  8003fc:	83 ec 08             	sub    $0x8,%esp
  8003ff:	ff 75 f0             	pushl  -0x10(%ebp)
  800402:	ff 75 cc             	pushl  -0x34(%ebp)
  800405:	e8 e6 00 00 00       	call   8004f0 <CheckSorted>
  80040a:	83 c4 10             	add    $0x10,%esp
  80040d:	89 45 b4             	mov    %eax,-0x4c(%ebp)
	if(sorted == 0) panic("The array is NOT merge-sorted correctly") ;
  800410:	83 7d b4 00          	cmpl   $0x0,-0x4c(%ebp)
  800414:	75 14                	jne    80042a <_main+0x3f2>
  800416:	83 ec 04             	sub    $0x4,%esp
  800419:	68 80 3a 80 00       	push   $0x803a80
  80041e:	6a 68                	push   $0x68
  800420:	68 05 3a 80 00       	push   $0x803a05
  800425:	e8 73 04 00 00       	call   80089d <_panic>
	int correctMean, correctVar ;
	ArrayStats(Elements, NumOfElements, &correctMean , &correctVar);
  80042a:	8d 85 78 ff ff ff    	lea    -0x88(%ebp),%eax
  800430:	50                   	push   %eax
  800431:	8d 85 7c ff ff ff    	lea    -0x84(%ebp),%eax
  800437:	50                   	push   %eax
  800438:	ff 75 f0             	pushl  -0x10(%ebp)
  80043b:	ff 75 ec             	pushl  -0x14(%ebp)
  80043e:	e8 b6 01 00 00       	call   8005f9 <ArrayStats>
  800443:	83 c4 10             	add    $0x10,%esp
	int correctMin = quicksortedArr[0];
  800446:	8b 45 d0             	mov    -0x30(%ebp),%eax
  800449:	8b 00                	mov    (%eax),%eax
  80044b:	89 45 b0             	mov    %eax,-0x50(%ebp)
	int last = NumOfElements-1;
  80044e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800451:	48                   	dec    %eax
  800452:	89 45 ac             	mov    %eax,-0x54(%ebp)
	int middle = (NumOfElements-1)/2;
  800455:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800458:	48                   	dec    %eax
  800459:	89 c2                	mov    %eax,%edx
  80045b:	c1 ea 1f             	shr    $0x1f,%edx
  80045e:	01 d0                	add    %edx,%eax
  800460:	d1 f8                	sar    %eax
  800462:	89 45 a8             	mov    %eax,-0x58(%ebp)
	int correctMax = quicksortedArr[last];
  800465:	8b 45 ac             	mov    -0x54(%ebp),%eax
  800468:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80046f:	8b 45 d0             	mov    -0x30(%ebp),%eax
  800472:	01 d0                	add    %edx,%eax
  800474:	8b 00                	mov    (%eax),%eax
  800476:	89 45 a4             	mov    %eax,-0x5c(%ebp)
	int correctMed = quicksortedArr[middle];
  800479:	8b 45 a8             	mov    -0x58(%ebp),%eax
  80047c:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800483:	8b 45 d0             	mov    -0x30(%ebp),%eax
  800486:	01 d0                	add    %edx,%eax
  800488:	8b 00                	mov    (%eax),%eax
  80048a:	89 45 a0             	mov    %eax,-0x60(%ebp)
	//cprintf("Array is correctly sorted\n");
	//cprintf("mean = %d, var = %d\nmin = %d, max = %d, med = %d\n", *mean, *var, *min, *max, *med);
	//cprintf("mean = %d, var = %d\nmin = %d, max = %d, med = %d\n", correctMean, correctVar, correctMin, correctMax, correctMed);

	if(*mean != correctMean || *var != correctVar|| *min != correctMin || *max != correctMax || *med != correctMed)
  80048d:	8b 45 c8             	mov    -0x38(%ebp),%eax
  800490:	8b 10                	mov    (%eax),%edx
  800492:	8b 85 7c ff ff ff    	mov    -0x84(%ebp),%eax
  800498:	39 c2                	cmp    %eax,%edx
  80049a:	75 2d                	jne    8004c9 <_main+0x491>
  80049c:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  80049f:	8b 10                	mov    (%eax),%edx
  8004a1:	8b 85 78 ff ff ff    	mov    -0x88(%ebp),%eax
  8004a7:	39 c2                	cmp    %eax,%edx
  8004a9:	75 1e                	jne    8004c9 <_main+0x491>
  8004ab:	8b 45 c0             	mov    -0x40(%ebp),%eax
  8004ae:	8b 00                	mov    (%eax),%eax
  8004b0:	3b 45 b0             	cmp    -0x50(%ebp),%eax
  8004b3:	75 14                	jne    8004c9 <_main+0x491>
  8004b5:	8b 45 bc             	mov    -0x44(%ebp),%eax
  8004b8:	8b 00                	mov    (%eax),%eax
  8004ba:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  8004bd:	75 0a                	jne    8004c9 <_main+0x491>
  8004bf:	8b 45 b8             	mov    -0x48(%ebp),%eax
  8004c2:	8b 00                	mov    (%eax),%eax
  8004c4:	3b 45 a0             	cmp    -0x60(%ebp),%eax
  8004c7:	74 14                	je     8004dd <_main+0x4a5>
		panic("The array STATS are NOT calculated correctly") ;
  8004c9:	83 ec 04             	sub    $0x4,%esp
  8004cc:	68 a8 3a 80 00       	push   $0x803aa8
  8004d1:	6a 75                	push   $0x75
  8004d3:	68 05 3a 80 00       	push   $0x803a05
  8004d8:	e8 c0 03 00 00       	call   80089d <_panic>

	cprintf("Congratulations!! Scenario of Using the Shared Variables [Create & Get] completed successfully!!\n\n\n");
  8004dd:	83 ec 0c             	sub    $0xc,%esp
  8004e0:	68 d8 3a 80 00       	push   $0x803ad8
  8004e5:	e8 67 06 00 00       	call   800b51 <cprintf>
  8004ea:	83 c4 10             	add    $0x10,%esp

	return;
  8004ed:	90                   	nop
}
  8004ee:	c9                   	leave  
  8004ef:	c3                   	ret    

008004f0 <CheckSorted>:


uint32 CheckSorted(int *Elements, int NumOfElements)
{
  8004f0:	55                   	push   %ebp
  8004f1:	89 e5                	mov    %esp,%ebp
  8004f3:	83 ec 10             	sub    $0x10,%esp
	uint32 Sorted = 1 ;
  8004f6:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
	int i ;
	for (i = 0 ; i < NumOfElements - 1; i++)
  8004fd:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  800504:	eb 33                	jmp    800539 <CheckSorted+0x49>
	{
		if (Elements[i] > Elements[i+1])
  800506:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800509:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800510:	8b 45 08             	mov    0x8(%ebp),%eax
  800513:	01 d0                	add    %edx,%eax
  800515:	8b 10                	mov    (%eax),%edx
  800517:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80051a:	40                   	inc    %eax
  80051b:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  800522:	8b 45 08             	mov    0x8(%ebp),%eax
  800525:	01 c8                	add    %ecx,%eax
  800527:	8b 00                	mov    (%eax),%eax
  800529:	39 c2                	cmp    %eax,%edx
  80052b:	7e 09                	jle    800536 <CheckSorted+0x46>
		{
			Sorted = 0 ;
  80052d:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
			break;
  800534:	eb 0c                	jmp    800542 <CheckSorted+0x52>

uint32 CheckSorted(int *Elements, int NumOfElements)
{
	uint32 Sorted = 1 ;
	int i ;
	for (i = 0 ; i < NumOfElements - 1; i++)
  800536:	ff 45 f8             	incl   -0x8(%ebp)
  800539:	8b 45 0c             	mov    0xc(%ebp),%eax
  80053c:	48                   	dec    %eax
  80053d:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800540:	7f c4                	jg     800506 <CheckSorted+0x16>
		{
			Sorted = 0 ;
			break;
		}
	}
	return Sorted ;
  800542:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800545:	c9                   	leave  
  800546:	c3                   	ret    

00800547 <InitializeAscending>:

void InitializeAscending(int *Elements, int NumOfElements)
{
  800547:	55                   	push   %ebp
  800548:	89 e5                	mov    %esp,%ebp
  80054a:	83 ec 10             	sub    $0x10,%esp
	int i ;
	for (i = 0 ; i < NumOfElements ; i++)
  80054d:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800554:	eb 17                	jmp    80056d <InitializeAscending+0x26>
	{
		(Elements)[i] = i ;
  800556:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800559:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800560:	8b 45 08             	mov    0x8(%ebp),%eax
  800563:	01 c2                	add    %eax,%edx
  800565:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800568:	89 02                	mov    %eax,(%edx)
}

void InitializeAscending(int *Elements, int NumOfElements)
{
	int i ;
	for (i = 0 ; i < NumOfElements ; i++)
  80056a:	ff 45 fc             	incl   -0x4(%ebp)
  80056d:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800570:	3b 45 0c             	cmp    0xc(%ebp),%eax
  800573:	7c e1                	jl     800556 <InitializeAscending+0xf>
	{
		(Elements)[i] = i ;
	}

}
  800575:	90                   	nop
  800576:	c9                   	leave  
  800577:	c3                   	ret    

00800578 <InitializeDescending>:

void InitializeDescending(int *Elements, int NumOfElements)
{
  800578:	55                   	push   %ebp
  800579:	89 e5                	mov    %esp,%ebp
  80057b:	83 ec 10             	sub    $0x10,%esp
	int i ;
	for (i = 0 ; i < NumOfElements ; i++)
  80057e:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800585:	eb 1b                	jmp    8005a2 <InitializeDescending+0x2a>
	{
		Elements[i] = NumOfElements - i - 1 ;
  800587:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80058a:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800591:	8b 45 08             	mov    0x8(%ebp),%eax
  800594:	01 c2                	add    %eax,%edx
  800596:	8b 45 0c             	mov    0xc(%ebp),%eax
  800599:	2b 45 fc             	sub    -0x4(%ebp),%eax
  80059c:	48                   	dec    %eax
  80059d:	89 02                	mov    %eax,(%edx)
}

void InitializeDescending(int *Elements, int NumOfElements)
{
	int i ;
	for (i = 0 ; i < NumOfElements ; i++)
  80059f:	ff 45 fc             	incl   -0x4(%ebp)
  8005a2:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8005a5:	3b 45 0c             	cmp    0xc(%ebp),%eax
  8005a8:	7c dd                	jl     800587 <InitializeDescending+0xf>
	{
		Elements[i] = NumOfElements - i - 1 ;
	}

}
  8005aa:	90                   	nop
  8005ab:	c9                   	leave  
  8005ac:	c3                   	ret    

008005ad <InitializeSemiRandom>:

void InitializeSemiRandom(int *Elements, int NumOfElements)
{
  8005ad:	55                   	push   %ebp
  8005ae:	89 e5                	mov    %esp,%ebp
  8005b0:	83 ec 10             	sub    $0x10,%esp
	int i ;
	int Repetition = NumOfElements / 3 ;
  8005b3:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8005b6:	b8 56 55 55 55       	mov    $0x55555556,%eax
  8005bb:	f7 e9                	imul   %ecx
  8005bd:	c1 f9 1f             	sar    $0x1f,%ecx
  8005c0:	89 d0                	mov    %edx,%eax
  8005c2:	29 c8                	sub    %ecx,%eax
  8005c4:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0 ; i < NumOfElements ; i++)
  8005c7:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8005ce:	eb 1e                	jmp    8005ee <InitializeSemiRandom+0x41>
	{
		Elements[i] = i % Repetition ;
  8005d0:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8005d3:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8005da:	8b 45 08             	mov    0x8(%ebp),%eax
  8005dd:	8d 0c 02             	lea    (%edx,%eax,1),%ecx
  8005e0:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8005e3:	99                   	cltd   
  8005e4:	f7 7d f8             	idivl  -0x8(%ebp)
  8005e7:	89 d0                	mov    %edx,%eax
  8005e9:	89 01                	mov    %eax,(%ecx)

void InitializeSemiRandom(int *Elements, int NumOfElements)
{
	int i ;
	int Repetition = NumOfElements / 3 ;
	for (i = 0 ; i < NumOfElements ; i++)
  8005eb:	ff 45 fc             	incl   -0x4(%ebp)
  8005ee:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8005f1:	3b 45 0c             	cmp    0xc(%ebp),%eax
  8005f4:	7c da                	jl     8005d0 <InitializeSemiRandom+0x23>
	{
		Elements[i] = i % Repetition ;
		//cprintf("Elements[%d] = %d\n",i, Elements[i]);
	}

}
  8005f6:	90                   	nop
  8005f7:	c9                   	leave  
  8005f8:	c3                   	ret    

008005f9 <ArrayStats>:

void ArrayStats(int *Elements, int NumOfElements, int *mean, int *var)
{
  8005f9:	55                   	push   %ebp
  8005fa:	89 e5                	mov    %esp,%ebp
  8005fc:	53                   	push   %ebx
  8005fd:	83 ec 10             	sub    $0x10,%esp
	int i ;
	*mean =0 ;
  800600:	8b 45 10             	mov    0x10(%ebp),%eax
  800603:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	for (i = 0 ; i < NumOfElements ; i++)
  800609:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  800610:	eb 20                	jmp    800632 <ArrayStats+0x39>
	{
		*mean += Elements[i];
  800612:	8b 45 10             	mov    0x10(%ebp),%eax
  800615:	8b 10                	mov    (%eax),%edx
  800617:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80061a:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  800621:	8b 45 08             	mov    0x8(%ebp),%eax
  800624:	01 c8                	add    %ecx,%eax
  800626:	8b 00                	mov    (%eax),%eax
  800628:	01 c2                	add    %eax,%edx
  80062a:	8b 45 10             	mov    0x10(%ebp),%eax
  80062d:	89 10                	mov    %edx,(%eax)

void ArrayStats(int *Elements, int NumOfElements, int *mean, int *var)
{
	int i ;
	*mean =0 ;
	for (i = 0 ; i < NumOfElements ; i++)
  80062f:	ff 45 f8             	incl   -0x8(%ebp)
  800632:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800635:	3b 45 0c             	cmp    0xc(%ebp),%eax
  800638:	7c d8                	jl     800612 <ArrayStats+0x19>
	{
		*mean += Elements[i];
	}
	*mean /= NumOfElements;
  80063a:	8b 45 10             	mov    0x10(%ebp),%eax
  80063d:	8b 00                	mov    (%eax),%eax
  80063f:	99                   	cltd   
  800640:	f7 7d 0c             	idivl  0xc(%ebp)
  800643:	89 c2                	mov    %eax,%edx
  800645:	8b 45 10             	mov    0x10(%ebp),%eax
  800648:	89 10                	mov    %edx,(%eax)
	*var = 0;
  80064a:	8b 45 14             	mov    0x14(%ebp),%eax
  80064d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	for (i = 0 ; i < NumOfElements ; i++)
  800653:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  80065a:	eb 46                	jmp    8006a2 <ArrayStats+0xa9>
	{
		*var += (Elements[i] - *mean)*(Elements[i] - *mean);
  80065c:	8b 45 14             	mov    0x14(%ebp),%eax
  80065f:	8b 10                	mov    (%eax),%edx
  800661:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800664:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  80066b:	8b 45 08             	mov    0x8(%ebp),%eax
  80066e:	01 c8                	add    %ecx,%eax
  800670:	8b 08                	mov    (%eax),%ecx
  800672:	8b 45 10             	mov    0x10(%ebp),%eax
  800675:	8b 00                	mov    (%eax),%eax
  800677:	89 cb                	mov    %ecx,%ebx
  800679:	29 c3                	sub    %eax,%ebx
  80067b:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80067e:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  800685:	8b 45 08             	mov    0x8(%ebp),%eax
  800688:	01 c8                	add    %ecx,%eax
  80068a:	8b 08                	mov    (%eax),%ecx
  80068c:	8b 45 10             	mov    0x10(%ebp),%eax
  80068f:	8b 00                	mov    (%eax),%eax
  800691:	29 c1                	sub    %eax,%ecx
  800693:	89 c8                	mov    %ecx,%eax
  800695:	0f af c3             	imul   %ebx,%eax
  800698:	01 c2                	add    %eax,%edx
  80069a:	8b 45 14             	mov    0x14(%ebp),%eax
  80069d:	89 10                	mov    %edx,(%eax)
	{
		*mean += Elements[i];
	}
	*mean /= NumOfElements;
	*var = 0;
	for (i = 0 ; i < NumOfElements ; i++)
  80069f:	ff 45 f8             	incl   -0x8(%ebp)
  8006a2:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8006a5:	3b 45 0c             	cmp    0xc(%ebp),%eax
  8006a8:	7c b2                	jl     80065c <ArrayStats+0x63>
	{
		*var += (Elements[i] - *mean)*(Elements[i] - *mean);
	}
	*var /= NumOfElements;
  8006aa:	8b 45 14             	mov    0x14(%ebp),%eax
  8006ad:	8b 00                	mov    (%eax),%eax
  8006af:	99                   	cltd   
  8006b0:	f7 7d 0c             	idivl  0xc(%ebp)
  8006b3:	89 c2                	mov    %eax,%edx
  8006b5:	8b 45 14             	mov    0x14(%ebp),%eax
  8006b8:	89 10                	mov    %edx,(%eax)
}
  8006ba:	90                   	nop
  8006bb:	83 c4 10             	add    $0x10,%esp
  8006be:	5b                   	pop    %ebx
  8006bf:	5d                   	pop    %ebp
  8006c0:	c3                   	ret    

008006c1 <cputchar>:
#include <inc/lib.h>


void
cputchar(int ch)
{
  8006c1:	55                   	push   %ebp
  8006c2:	89 e5                	mov    %esp,%ebp
  8006c4:	83 ec 18             	sub    $0x18,%esp
	char c = ch;
  8006c7:	8b 45 08             	mov    0x8(%ebp),%eax
  8006ca:	88 45 f7             	mov    %al,-0x9(%ebp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	//sys_cputs(&c, 1);

	sys_cputc(c);
  8006cd:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
  8006d1:	83 ec 0c             	sub    $0xc,%esp
  8006d4:	50                   	push   %eax
  8006d5:	e8 3c 1b 00 00       	call   802216 <sys_cputc>
  8006da:	83 c4 10             	add    $0x10,%esp
}
  8006dd:	90                   	nop
  8006de:	c9                   	leave  
  8006df:	c3                   	ret    

008006e0 <atomic_cputchar>:


void
atomic_cputchar(int ch)
{
  8006e0:	55                   	push   %ebp
  8006e1:	89 e5                	mov    %esp,%ebp
  8006e3:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  8006e6:	e8 f7 1a 00 00       	call   8021e2 <sys_disable_interrupt>
	char c = ch;
  8006eb:	8b 45 08             	mov    0x8(%ebp),%eax
  8006ee:	88 45 f7             	mov    %al,-0x9(%ebp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	//sys_cputs(&c, 1);

	sys_cputc(c);
  8006f1:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
  8006f5:	83 ec 0c             	sub    $0xc,%esp
  8006f8:	50                   	push   %eax
  8006f9:	e8 18 1b 00 00       	call   802216 <sys_cputc>
  8006fe:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  800701:	e8 f6 1a 00 00       	call   8021fc <sys_enable_interrupt>
}
  800706:	90                   	nop
  800707:	c9                   	leave  
  800708:	c3                   	ret    

00800709 <getchar>:

int
getchar(void)
{
  800709:	55                   	push   %ebp
  80070a:	89 e5                	mov    %esp,%ebp
  80070c:	83 ec 18             	sub    $0x18,%esp

	//return sys_cgetc();
	int c=0;
  80070f:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	while(c == 0)
  800716:	eb 08                	jmp    800720 <getchar+0x17>
	{
		c = sys_cgetc();
  800718:	e8 40 19 00 00       	call   80205d <sys_cgetc>
  80071d:	89 45 f4             	mov    %eax,-0xc(%ebp)
getchar(void)
{

	//return sys_cgetc();
	int c=0;
	while(c == 0)
  800720:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  800724:	74 f2                	je     800718 <getchar+0xf>
	{
		c = sys_cgetc();
	}
	return c;
  800726:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  800729:	c9                   	leave  
  80072a:	c3                   	ret    

0080072b <atomic_getchar>:

int
atomic_getchar(void)
{
  80072b:	55                   	push   %ebp
  80072c:	89 e5                	mov    %esp,%ebp
  80072e:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  800731:	e8 ac 1a 00 00       	call   8021e2 <sys_disable_interrupt>
	int c=0;
  800736:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	while(c == 0)
  80073d:	eb 08                	jmp    800747 <atomic_getchar+0x1c>
	{
		c = sys_cgetc();
  80073f:	e8 19 19 00 00       	call   80205d <sys_cgetc>
  800744:	89 45 f4             	mov    %eax,-0xc(%ebp)
int
atomic_getchar(void)
{
	sys_disable_interrupt();
	int c=0;
	while(c == 0)
  800747:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80074b:	74 f2                	je     80073f <atomic_getchar+0x14>
	{
		c = sys_cgetc();
	}
	sys_enable_interrupt();
  80074d:	e8 aa 1a 00 00       	call   8021fc <sys_enable_interrupt>
	return c;
  800752:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  800755:	c9                   	leave  
  800756:	c3                   	ret    

00800757 <iscons>:

int iscons(int fdnum)
{
  800757:	55                   	push   %ebp
  800758:	89 e5                	mov    %esp,%ebp
	// used by readline
	return 1;
  80075a:	b8 01 00 00 00       	mov    $0x1,%eax
}
  80075f:	5d                   	pop    %ebp
  800760:	c3                   	ret    

00800761 <libmain>:
volatile struct Env *myEnv = NULL;
volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";

void
libmain(int argc, char **argv)
{
  800761:	55                   	push   %ebp
  800762:	89 e5                	mov    %esp,%ebp
  800764:	83 ec 18             	sub    $0x18,%esp
	int envIndex = sys_getenvindex();
  800767:	e8 69 1c 00 00       	call   8023d5 <sys_getenvindex>
  80076c:	89 45 f4             	mov    %eax,-0xc(%ebp)
	myEnv = &(envs[envIndex]);
  80076f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800772:	89 d0                	mov    %edx,%eax
  800774:	c1 e0 03             	shl    $0x3,%eax
  800777:	01 d0                	add    %edx,%eax
  800779:	01 c0                	add    %eax,%eax
  80077b:	01 d0                	add    %edx,%eax
  80077d:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800784:	01 d0                	add    %edx,%eax
  800786:	c1 e0 04             	shl    $0x4,%eax
  800789:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  80078e:	a3 20 50 80 00       	mov    %eax,0x805020

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  800793:	a1 20 50 80 00       	mov    0x805020,%eax
  800798:	8a 80 5c 05 00 00    	mov    0x55c(%eax),%al
  80079e:	84 c0                	test   %al,%al
  8007a0:	74 0f                	je     8007b1 <libmain+0x50>
		binaryname = myEnv->prog_name;
  8007a2:	a1 20 50 80 00       	mov    0x805020,%eax
  8007a7:	05 5c 05 00 00       	add    $0x55c,%eax
  8007ac:	a3 00 50 80 00       	mov    %eax,0x805000

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8007b1:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8007b5:	7e 0a                	jle    8007c1 <libmain+0x60>
		binaryname = argv[0];
  8007b7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8007ba:	8b 00                	mov    (%eax),%eax
  8007bc:	a3 00 50 80 00       	mov    %eax,0x805000

	// call user main routine
	_main(argc, argv);
  8007c1:	83 ec 08             	sub    $0x8,%esp
  8007c4:	ff 75 0c             	pushl  0xc(%ebp)
  8007c7:	ff 75 08             	pushl  0x8(%ebp)
  8007ca:	e8 69 f8 ff ff       	call   800038 <_main>
  8007cf:	83 c4 10             	add    $0x10,%esp



	sys_disable_interrupt();
  8007d2:	e8 0b 1a 00 00       	call   8021e2 <sys_disable_interrupt>
	cprintf("**************************************\n");
  8007d7:	83 ec 0c             	sub    $0xc,%esp
  8007da:	68 54 3b 80 00       	push   $0x803b54
  8007df:	e8 6d 03 00 00       	call   800b51 <cprintf>
  8007e4:	83 c4 10             	add    $0x10,%esp
	cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  8007e7:	a1 20 50 80 00       	mov    0x805020,%eax
  8007ec:	8b 90 44 05 00 00    	mov    0x544(%eax),%edx
  8007f2:	a1 20 50 80 00       	mov    0x805020,%eax
  8007f7:	8b 80 34 05 00 00    	mov    0x534(%eax),%eax
  8007fd:	83 ec 04             	sub    $0x4,%esp
  800800:	52                   	push   %edx
  800801:	50                   	push   %eax
  800802:	68 7c 3b 80 00       	push   $0x803b7c
  800807:	e8 45 03 00 00       	call   800b51 <cprintf>
  80080c:	83 c4 10             	add    $0x10,%esp
	cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  80080f:	a1 20 50 80 00       	mov    0x805020,%eax
  800814:	8b 88 54 05 00 00    	mov    0x554(%eax),%ecx
  80081a:	a1 20 50 80 00       	mov    0x805020,%eax
  80081f:	8b 90 50 05 00 00    	mov    0x550(%eax),%edx
  800825:	a1 20 50 80 00       	mov    0x805020,%eax
  80082a:	8b 80 4c 05 00 00    	mov    0x54c(%eax),%eax
  800830:	51                   	push   %ecx
  800831:	52                   	push   %edx
  800832:	50                   	push   %eax
  800833:	68 a4 3b 80 00       	push   $0x803ba4
  800838:	e8 14 03 00 00       	call   800b51 <cprintf>
  80083d:	83 c4 10             	add    $0x10,%esp
	//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
	cprintf("Num of clocks = %d\n", myEnv->nClocks);
  800840:	a1 20 50 80 00       	mov    0x805020,%eax
  800845:	8b 80 a4 05 00 00    	mov    0x5a4(%eax),%eax
  80084b:	83 ec 08             	sub    $0x8,%esp
  80084e:	50                   	push   %eax
  80084f:	68 fc 3b 80 00       	push   $0x803bfc
  800854:	e8 f8 02 00 00       	call   800b51 <cprintf>
  800859:	83 c4 10             	add    $0x10,%esp
	cprintf("**************************************\n");
  80085c:	83 ec 0c             	sub    $0xc,%esp
  80085f:	68 54 3b 80 00       	push   $0x803b54
  800864:	e8 e8 02 00 00       	call   800b51 <cprintf>
  800869:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  80086c:	e8 8b 19 00 00       	call   8021fc <sys_enable_interrupt>

	// exit gracefully
	exit();
  800871:	e8 19 00 00 00       	call   80088f <exit>
}
  800876:	90                   	nop
  800877:	c9                   	leave  
  800878:	c3                   	ret    

00800879 <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  800879:	55                   	push   %ebp
  80087a:	89 e5                	mov    %esp,%ebp
  80087c:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  80087f:	83 ec 0c             	sub    $0xc,%esp
  800882:	6a 00                	push   $0x0
  800884:	e8 18 1b 00 00       	call   8023a1 <sys_destroy_env>
  800889:	83 c4 10             	add    $0x10,%esp
}
  80088c:	90                   	nop
  80088d:	c9                   	leave  
  80088e:	c3                   	ret    

0080088f <exit>:

void
exit(void)
{
  80088f:	55                   	push   %ebp
  800890:	89 e5                	mov    %esp,%ebp
  800892:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  800895:	e8 6d 1b 00 00       	call   802407 <sys_exit_env>
}
  80089a:	90                   	nop
  80089b:	c9                   	leave  
  80089c:	c3                   	ret    

0080089d <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  80089d:	55                   	push   %ebp
  80089e:	89 e5                	mov    %esp,%ebp
  8008a0:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  8008a3:	8d 45 10             	lea    0x10(%ebp),%eax
  8008a6:	83 c0 04             	add    $0x4,%eax
  8008a9:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  8008ac:	a1 5c 51 80 00       	mov    0x80515c,%eax
  8008b1:	85 c0                	test   %eax,%eax
  8008b3:	74 16                	je     8008cb <_panic+0x2e>
		cprintf("%s: ", argv0);
  8008b5:	a1 5c 51 80 00       	mov    0x80515c,%eax
  8008ba:	83 ec 08             	sub    $0x8,%esp
  8008bd:	50                   	push   %eax
  8008be:	68 10 3c 80 00       	push   $0x803c10
  8008c3:	e8 89 02 00 00       	call   800b51 <cprintf>
  8008c8:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  8008cb:	a1 00 50 80 00       	mov    0x805000,%eax
  8008d0:	ff 75 0c             	pushl  0xc(%ebp)
  8008d3:	ff 75 08             	pushl  0x8(%ebp)
  8008d6:	50                   	push   %eax
  8008d7:	68 15 3c 80 00       	push   $0x803c15
  8008dc:	e8 70 02 00 00       	call   800b51 <cprintf>
  8008e1:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  8008e4:	8b 45 10             	mov    0x10(%ebp),%eax
  8008e7:	83 ec 08             	sub    $0x8,%esp
  8008ea:	ff 75 f4             	pushl  -0xc(%ebp)
  8008ed:	50                   	push   %eax
  8008ee:	e8 f3 01 00 00       	call   800ae6 <vcprintf>
  8008f3:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  8008f6:	83 ec 08             	sub    $0x8,%esp
  8008f9:	6a 00                	push   $0x0
  8008fb:	68 31 3c 80 00       	push   $0x803c31
  800900:	e8 e1 01 00 00       	call   800ae6 <vcprintf>
  800905:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  800908:	e8 82 ff ff ff       	call   80088f <exit>

	// should not return here
	while (1) ;
  80090d:	eb fe                	jmp    80090d <_panic+0x70>

0080090f <CheckWSWithoutLastIndex>:
}

void CheckWSWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  80090f:	55                   	push   %ebp
  800910:	89 e5                	mov    %esp,%ebp
  800912:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  800915:	a1 20 50 80 00       	mov    0x805020,%eax
  80091a:	8b 50 74             	mov    0x74(%eax),%edx
  80091d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800920:	39 c2                	cmp    %eax,%edx
  800922:	74 14                	je     800938 <CheckWSWithoutLastIndex+0x29>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  800924:	83 ec 04             	sub    $0x4,%esp
  800927:	68 34 3c 80 00       	push   $0x803c34
  80092c:	6a 26                	push   $0x26
  80092e:	68 80 3c 80 00       	push   $0x803c80
  800933:	e8 65 ff ff ff       	call   80089d <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  800938:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  80093f:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800946:	e9 c2 00 00 00       	jmp    800a0d <CheckWSWithoutLastIndex+0xfe>
		if (expectedPages[e] == 0) {
  80094b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80094e:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800955:	8b 45 08             	mov    0x8(%ebp),%eax
  800958:	01 d0                	add    %edx,%eax
  80095a:	8b 00                	mov    (%eax),%eax
  80095c:	85 c0                	test   %eax,%eax
  80095e:	75 08                	jne    800968 <CheckWSWithoutLastIndex+0x59>
			expectedNumOfEmptyLocs++;
  800960:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  800963:	e9 a2 00 00 00       	jmp    800a0a <CheckWSWithoutLastIndex+0xfb>
		}
		int found = 0;
  800968:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  80096f:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  800976:	eb 69                	jmp    8009e1 <CheckWSWithoutLastIndex+0xd2>
			if (myEnv->__uptr_pws[w].empty == 0) {
  800978:	a1 20 50 80 00       	mov    0x805020,%eax
  80097d:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  800983:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800986:	89 d0                	mov    %edx,%eax
  800988:	01 c0                	add    %eax,%eax
  80098a:	01 d0                	add    %edx,%eax
  80098c:	c1 e0 03             	shl    $0x3,%eax
  80098f:	01 c8                	add    %ecx,%eax
  800991:	8a 40 04             	mov    0x4(%eax),%al
  800994:	84 c0                	test   %al,%al
  800996:	75 46                	jne    8009de <CheckWSWithoutLastIndex+0xcf>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  800998:	a1 20 50 80 00       	mov    0x805020,%eax
  80099d:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  8009a3:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8009a6:	89 d0                	mov    %edx,%eax
  8009a8:	01 c0                	add    %eax,%eax
  8009aa:	01 d0                	add    %edx,%eax
  8009ac:	c1 e0 03             	shl    $0x3,%eax
  8009af:	01 c8                	add    %ecx,%eax
  8009b1:	8b 00                	mov    (%eax),%eax
  8009b3:	89 45 dc             	mov    %eax,-0x24(%ebp)
  8009b6:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8009b9:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8009be:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  8009c0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8009c3:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  8009ca:	8b 45 08             	mov    0x8(%ebp),%eax
  8009cd:	01 c8                	add    %ecx,%eax
  8009cf:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  8009d1:	39 c2                	cmp    %eax,%edx
  8009d3:	75 09                	jne    8009de <CheckWSWithoutLastIndex+0xcf>
						== expectedPages[e]) {
					found = 1;
  8009d5:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  8009dc:	eb 12                	jmp    8009f0 <CheckWSWithoutLastIndex+0xe1>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8009de:	ff 45 e8             	incl   -0x18(%ebp)
  8009e1:	a1 20 50 80 00       	mov    0x805020,%eax
  8009e6:	8b 50 74             	mov    0x74(%eax),%edx
  8009e9:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8009ec:	39 c2                	cmp    %eax,%edx
  8009ee:	77 88                	ja     800978 <CheckWSWithoutLastIndex+0x69>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  8009f0:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8009f4:	75 14                	jne    800a0a <CheckWSWithoutLastIndex+0xfb>
			panic(
  8009f6:	83 ec 04             	sub    $0x4,%esp
  8009f9:	68 8c 3c 80 00       	push   $0x803c8c
  8009fe:	6a 3a                	push   $0x3a
  800a00:	68 80 3c 80 00       	push   $0x803c80
  800a05:	e8 93 fe ff ff       	call   80089d <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  800a0a:	ff 45 f0             	incl   -0x10(%ebp)
  800a0d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800a10:	3b 45 0c             	cmp    0xc(%ebp),%eax
  800a13:	0f 8c 32 ff ff ff    	jl     80094b <CheckWSWithoutLastIndex+0x3c>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  800a19:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800a20:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  800a27:	eb 26                	jmp    800a4f <CheckWSWithoutLastIndex+0x140>
		if (myEnv->__uptr_pws[w].empty == 1) {
  800a29:	a1 20 50 80 00       	mov    0x805020,%eax
  800a2e:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  800a34:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800a37:	89 d0                	mov    %edx,%eax
  800a39:	01 c0                	add    %eax,%eax
  800a3b:	01 d0                	add    %edx,%eax
  800a3d:	c1 e0 03             	shl    $0x3,%eax
  800a40:	01 c8                	add    %ecx,%eax
  800a42:	8a 40 04             	mov    0x4(%eax),%al
  800a45:	3c 01                	cmp    $0x1,%al
  800a47:	75 03                	jne    800a4c <CheckWSWithoutLastIndex+0x13d>
			actualNumOfEmptyLocs++;
  800a49:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800a4c:	ff 45 e0             	incl   -0x20(%ebp)
  800a4f:	a1 20 50 80 00       	mov    0x805020,%eax
  800a54:	8b 50 74             	mov    0x74(%eax),%edx
  800a57:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800a5a:	39 c2                	cmp    %eax,%edx
  800a5c:	77 cb                	ja     800a29 <CheckWSWithoutLastIndex+0x11a>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  800a5e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800a61:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  800a64:	74 14                	je     800a7a <CheckWSWithoutLastIndex+0x16b>
		panic(
  800a66:	83 ec 04             	sub    $0x4,%esp
  800a69:	68 e0 3c 80 00       	push   $0x803ce0
  800a6e:	6a 44                	push   $0x44
  800a70:	68 80 3c 80 00       	push   $0x803c80
  800a75:	e8 23 fe ff ff       	call   80089d <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  800a7a:	90                   	nop
  800a7b:	c9                   	leave  
  800a7c:	c3                   	ret    

00800a7d <putch>:
};

//2017:
uint8 printProgName = 0;

static void putch(int ch, struct printbuf *b) {
  800a7d:	55                   	push   %ebp
  800a7e:	89 e5                	mov    %esp,%ebp
  800a80:	83 ec 08             	sub    $0x8,%esp
	b->buf[b->idx++] = ch;
  800a83:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a86:	8b 00                	mov    (%eax),%eax
  800a88:	8d 48 01             	lea    0x1(%eax),%ecx
  800a8b:	8b 55 0c             	mov    0xc(%ebp),%edx
  800a8e:	89 0a                	mov    %ecx,(%edx)
  800a90:	8b 55 08             	mov    0x8(%ebp),%edx
  800a93:	88 d1                	mov    %dl,%cl
  800a95:	8b 55 0c             	mov    0xc(%ebp),%edx
  800a98:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  800a9c:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a9f:	8b 00                	mov    (%eax),%eax
  800aa1:	3d ff 00 00 00       	cmp    $0xff,%eax
  800aa6:	75 2c                	jne    800ad4 <putch+0x57>
		sys_cputs(b->buf, b->idx, printProgName);
  800aa8:	a0 24 50 80 00       	mov    0x805024,%al
  800aad:	0f b6 c0             	movzbl %al,%eax
  800ab0:	8b 55 0c             	mov    0xc(%ebp),%edx
  800ab3:	8b 12                	mov    (%edx),%edx
  800ab5:	89 d1                	mov    %edx,%ecx
  800ab7:	8b 55 0c             	mov    0xc(%ebp),%edx
  800aba:	83 c2 08             	add    $0x8,%edx
  800abd:	83 ec 04             	sub    $0x4,%esp
  800ac0:	50                   	push   %eax
  800ac1:	51                   	push   %ecx
  800ac2:	52                   	push   %edx
  800ac3:	e8 6c 15 00 00       	call   802034 <sys_cputs>
  800ac8:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  800acb:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ace:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  800ad4:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ad7:	8b 40 04             	mov    0x4(%eax),%eax
  800ada:	8d 50 01             	lea    0x1(%eax),%edx
  800add:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ae0:	89 50 04             	mov    %edx,0x4(%eax)
}
  800ae3:	90                   	nop
  800ae4:	c9                   	leave  
  800ae5:	c3                   	ret    

00800ae6 <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  800ae6:	55                   	push   %ebp
  800ae7:	89 e5                	mov    %esp,%ebp
  800ae9:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  800aef:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800af6:	00 00 00 
	b.cnt = 0;
  800af9:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800b00:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  800b03:	ff 75 0c             	pushl  0xc(%ebp)
  800b06:	ff 75 08             	pushl  0x8(%ebp)
  800b09:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800b0f:	50                   	push   %eax
  800b10:	68 7d 0a 80 00       	push   $0x800a7d
  800b15:	e8 11 02 00 00       	call   800d2b <vprintfmt>
  800b1a:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName);
  800b1d:	a0 24 50 80 00       	mov    0x805024,%al
  800b22:	0f b6 c0             	movzbl %al,%eax
  800b25:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  800b2b:	83 ec 04             	sub    $0x4,%esp
  800b2e:	50                   	push   %eax
  800b2f:	52                   	push   %edx
  800b30:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800b36:	83 c0 08             	add    $0x8,%eax
  800b39:	50                   	push   %eax
  800b3a:	e8 f5 14 00 00       	call   802034 <sys_cputs>
  800b3f:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  800b42:	c6 05 24 50 80 00 00 	movb   $0x0,0x805024
	return b.cnt;
  800b49:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  800b4f:	c9                   	leave  
  800b50:	c3                   	ret    

00800b51 <cprintf>:

int cprintf(const char *fmt, ...) {
  800b51:	55                   	push   %ebp
  800b52:	89 e5                	mov    %esp,%ebp
  800b54:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  800b57:	c6 05 24 50 80 00 01 	movb   $0x1,0x805024
	va_start(ap, fmt);
  800b5e:	8d 45 0c             	lea    0xc(%ebp),%eax
  800b61:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800b64:	8b 45 08             	mov    0x8(%ebp),%eax
  800b67:	83 ec 08             	sub    $0x8,%esp
  800b6a:	ff 75 f4             	pushl  -0xc(%ebp)
  800b6d:	50                   	push   %eax
  800b6e:	e8 73 ff ff ff       	call   800ae6 <vcprintf>
  800b73:	83 c4 10             	add    $0x10,%esp
  800b76:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  800b79:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800b7c:	c9                   	leave  
  800b7d:	c3                   	ret    

00800b7e <atomic_cprintf>:

int atomic_cprintf(const char *fmt, ...) {
  800b7e:	55                   	push   %ebp
  800b7f:	89 e5                	mov    %esp,%ebp
  800b81:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  800b84:	e8 59 16 00 00       	call   8021e2 <sys_disable_interrupt>
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  800b89:	8d 45 0c             	lea    0xc(%ebp),%eax
  800b8c:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800b8f:	8b 45 08             	mov    0x8(%ebp),%eax
  800b92:	83 ec 08             	sub    $0x8,%esp
  800b95:	ff 75 f4             	pushl  -0xc(%ebp)
  800b98:	50                   	push   %eax
  800b99:	e8 48 ff ff ff       	call   800ae6 <vcprintf>
  800b9e:	83 c4 10             	add    $0x10,%esp
  800ba1:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	sys_enable_interrupt();
  800ba4:	e8 53 16 00 00       	call   8021fc <sys_enable_interrupt>
	return cnt;
  800ba9:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800bac:	c9                   	leave  
  800bad:	c3                   	ret    

00800bae <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800bae:	55                   	push   %ebp
  800baf:	89 e5                	mov    %esp,%ebp
  800bb1:	53                   	push   %ebx
  800bb2:	83 ec 14             	sub    $0x14,%esp
  800bb5:	8b 45 10             	mov    0x10(%ebp),%eax
  800bb8:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800bbb:	8b 45 14             	mov    0x14(%ebp),%eax
  800bbe:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800bc1:	8b 45 18             	mov    0x18(%ebp),%eax
  800bc4:	ba 00 00 00 00       	mov    $0x0,%edx
  800bc9:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800bcc:	77 55                	ja     800c23 <printnum+0x75>
  800bce:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800bd1:	72 05                	jb     800bd8 <printnum+0x2a>
  800bd3:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800bd6:	77 4b                	ja     800c23 <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800bd8:	8b 45 1c             	mov    0x1c(%ebp),%eax
  800bdb:	8d 58 ff             	lea    -0x1(%eax),%ebx
  800bde:	8b 45 18             	mov    0x18(%ebp),%eax
  800be1:	ba 00 00 00 00       	mov    $0x0,%edx
  800be6:	52                   	push   %edx
  800be7:	50                   	push   %eax
  800be8:	ff 75 f4             	pushl  -0xc(%ebp)
  800beb:	ff 75 f0             	pushl  -0x10(%ebp)
  800bee:	e8 8d 2a 00 00       	call   803680 <__udivdi3>
  800bf3:	83 c4 10             	add    $0x10,%esp
  800bf6:	83 ec 04             	sub    $0x4,%esp
  800bf9:	ff 75 20             	pushl  0x20(%ebp)
  800bfc:	53                   	push   %ebx
  800bfd:	ff 75 18             	pushl  0x18(%ebp)
  800c00:	52                   	push   %edx
  800c01:	50                   	push   %eax
  800c02:	ff 75 0c             	pushl  0xc(%ebp)
  800c05:	ff 75 08             	pushl  0x8(%ebp)
  800c08:	e8 a1 ff ff ff       	call   800bae <printnum>
  800c0d:	83 c4 20             	add    $0x20,%esp
  800c10:	eb 1a                	jmp    800c2c <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800c12:	83 ec 08             	sub    $0x8,%esp
  800c15:	ff 75 0c             	pushl  0xc(%ebp)
  800c18:	ff 75 20             	pushl  0x20(%ebp)
  800c1b:	8b 45 08             	mov    0x8(%ebp),%eax
  800c1e:	ff d0                	call   *%eax
  800c20:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800c23:	ff 4d 1c             	decl   0x1c(%ebp)
  800c26:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  800c2a:	7f e6                	jg     800c12 <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800c2c:	8b 4d 18             	mov    0x18(%ebp),%ecx
  800c2f:	bb 00 00 00 00       	mov    $0x0,%ebx
  800c34:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800c37:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800c3a:	53                   	push   %ebx
  800c3b:	51                   	push   %ecx
  800c3c:	52                   	push   %edx
  800c3d:	50                   	push   %eax
  800c3e:	e8 4d 2b 00 00       	call   803790 <__umoddi3>
  800c43:	83 c4 10             	add    $0x10,%esp
  800c46:	05 54 3f 80 00       	add    $0x803f54,%eax
  800c4b:	8a 00                	mov    (%eax),%al
  800c4d:	0f be c0             	movsbl %al,%eax
  800c50:	83 ec 08             	sub    $0x8,%esp
  800c53:	ff 75 0c             	pushl  0xc(%ebp)
  800c56:	50                   	push   %eax
  800c57:	8b 45 08             	mov    0x8(%ebp),%eax
  800c5a:	ff d0                	call   *%eax
  800c5c:	83 c4 10             	add    $0x10,%esp
}
  800c5f:	90                   	nop
  800c60:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800c63:	c9                   	leave  
  800c64:	c3                   	ret    

00800c65 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  800c65:	55                   	push   %ebp
  800c66:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800c68:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800c6c:	7e 1c                	jle    800c8a <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  800c6e:	8b 45 08             	mov    0x8(%ebp),%eax
  800c71:	8b 00                	mov    (%eax),%eax
  800c73:	8d 50 08             	lea    0x8(%eax),%edx
  800c76:	8b 45 08             	mov    0x8(%ebp),%eax
  800c79:	89 10                	mov    %edx,(%eax)
  800c7b:	8b 45 08             	mov    0x8(%ebp),%eax
  800c7e:	8b 00                	mov    (%eax),%eax
  800c80:	83 e8 08             	sub    $0x8,%eax
  800c83:	8b 50 04             	mov    0x4(%eax),%edx
  800c86:	8b 00                	mov    (%eax),%eax
  800c88:	eb 40                	jmp    800cca <getuint+0x65>
	else if (lflag)
  800c8a:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800c8e:	74 1e                	je     800cae <getuint+0x49>
		return va_arg(*ap, unsigned long);
  800c90:	8b 45 08             	mov    0x8(%ebp),%eax
  800c93:	8b 00                	mov    (%eax),%eax
  800c95:	8d 50 04             	lea    0x4(%eax),%edx
  800c98:	8b 45 08             	mov    0x8(%ebp),%eax
  800c9b:	89 10                	mov    %edx,(%eax)
  800c9d:	8b 45 08             	mov    0x8(%ebp),%eax
  800ca0:	8b 00                	mov    (%eax),%eax
  800ca2:	83 e8 04             	sub    $0x4,%eax
  800ca5:	8b 00                	mov    (%eax),%eax
  800ca7:	ba 00 00 00 00       	mov    $0x0,%edx
  800cac:	eb 1c                	jmp    800cca <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  800cae:	8b 45 08             	mov    0x8(%ebp),%eax
  800cb1:	8b 00                	mov    (%eax),%eax
  800cb3:	8d 50 04             	lea    0x4(%eax),%edx
  800cb6:	8b 45 08             	mov    0x8(%ebp),%eax
  800cb9:	89 10                	mov    %edx,(%eax)
  800cbb:	8b 45 08             	mov    0x8(%ebp),%eax
  800cbe:	8b 00                	mov    (%eax),%eax
  800cc0:	83 e8 04             	sub    $0x4,%eax
  800cc3:	8b 00                	mov    (%eax),%eax
  800cc5:	ba 00 00 00 00       	mov    $0x0,%edx
}
  800cca:	5d                   	pop    %ebp
  800ccb:	c3                   	ret    

00800ccc <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  800ccc:	55                   	push   %ebp
  800ccd:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800ccf:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800cd3:	7e 1c                	jle    800cf1 <getint+0x25>
		return va_arg(*ap, long long);
  800cd5:	8b 45 08             	mov    0x8(%ebp),%eax
  800cd8:	8b 00                	mov    (%eax),%eax
  800cda:	8d 50 08             	lea    0x8(%eax),%edx
  800cdd:	8b 45 08             	mov    0x8(%ebp),%eax
  800ce0:	89 10                	mov    %edx,(%eax)
  800ce2:	8b 45 08             	mov    0x8(%ebp),%eax
  800ce5:	8b 00                	mov    (%eax),%eax
  800ce7:	83 e8 08             	sub    $0x8,%eax
  800cea:	8b 50 04             	mov    0x4(%eax),%edx
  800ced:	8b 00                	mov    (%eax),%eax
  800cef:	eb 38                	jmp    800d29 <getint+0x5d>
	else if (lflag)
  800cf1:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800cf5:	74 1a                	je     800d11 <getint+0x45>
		return va_arg(*ap, long);
  800cf7:	8b 45 08             	mov    0x8(%ebp),%eax
  800cfa:	8b 00                	mov    (%eax),%eax
  800cfc:	8d 50 04             	lea    0x4(%eax),%edx
  800cff:	8b 45 08             	mov    0x8(%ebp),%eax
  800d02:	89 10                	mov    %edx,(%eax)
  800d04:	8b 45 08             	mov    0x8(%ebp),%eax
  800d07:	8b 00                	mov    (%eax),%eax
  800d09:	83 e8 04             	sub    $0x4,%eax
  800d0c:	8b 00                	mov    (%eax),%eax
  800d0e:	99                   	cltd   
  800d0f:	eb 18                	jmp    800d29 <getint+0x5d>
	else
		return va_arg(*ap, int);
  800d11:	8b 45 08             	mov    0x8(%ebp),%eax
  800d14:	8b 00                	mov    (%eax),%eax
  800d16:	8d 50 04             	lea    0x4(%eax),%edx
  800d19:	8b 45 08             	mov    0x8(%ebp),%eax
  800d1c:	89 10                	mov    %edx,(%eax)
  800d1e:	8b 45 08             	mov    0x8(%ebp),%eax
  800d21:	8b 00                	mov    (%eax),%eax
  800d23:	83 e8 04             	sub    $0x4,%eax
  800d26:	8b 00                	mov    (%eax),%eax
  800d28:	99                   	cltd   
}
  800d29:	5d                   	pop    %ebp
  800d2a:	c3                   	ret    

00800d2b <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  800d2b:	55                   	push   %ebp
  800d2c:	89 e5                	mov    %esp,%ebp
  800d2e:	56                   	push   %esi
  800d2f:	53                   	push   %ebx
  800d30:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800d33:	eb 17                	jmp    800d4c <vprintfmt+0x21>
			if (ch == '\0')
  800d35:	85 db                	test   %ebx,%ebx
  800d37:	0f 84 af 03 00 00    	je     8010ec <vprintfmt+0x3c1>
				return;
			putch(ch, putdat);
  800d3d:	83 ec 08             	sub    $0x8,%esp
  800d40:	ff 75 0c             	pushl  0xc(%ebp)
  800d43:	53                   	push   %ebx
  800d44:	8b 45 08             	mov    0x8(%ebp),%eax
  800d47:	ff d0                	call   *%eax
  800d49:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800d4c:	8b 45 10             	mov    0x10(%ebp),%eax
  800d4f:	8d 50 01             	lea    0x1(%eax),%edx
  800d52:	89 55 10             	mov    %edx,0x10(%ebp)
  800d55:	8a 00                	mov    (%eax),%al
  800d57:	0f b6 d8             	movzbl %al,%ebx
  800d5a:	83 fb 25             	cmp    $0x25,%ebx
  800d5d:	75 d6                	jne    800d35 <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  800d5f:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  800d63:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  800d6a:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  800d71:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  800d78:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800d7f:	8b 45 10             	mov    0x10(%ebp),%eax
  800d82:	8d 50 01             	lea    0x1(%eax),%edx
  800d85:	89 55 10             	mov    %edx,0x10(%ebp)
  800d88:	8a 00                	mov    (%eax),%al
  800d8a:	0f b6 d8             	movzbl %al,%ebx
  800d8d:	8d 43 dd             	lea    -0x23(%ebx),%eax
  800d90:	83 f8 55             	cmp    $0x55,%eax
  800d93:	0f 87 2b 03 00 00    	ja     8010c4 <vprintfmt+0x399>
  800d99:	8b 04 85 78 3f 80 00 	mov    0x803f78(,%eax,4),%eax
  800da0:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  800da2:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  800da6:	eb d7                	jmp    800d7f <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800da8:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  800dac:	eb d1                	jmp    800d7f <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800dae:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  800db5:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800db8:	89 d0                	mov    %edx,%eax
  800dba:	c1 e0 02             	shl    $0x2,%eax
  800dbd:	01 d0                	add    %edx,%eax
  800dbf:	01 c0                	add    %eax,%eax
  800dc1:	01 d8                	add    %ebx,%eax
  800dc3:	83 e8 30             	sub    $0x30,%eax
  800dc6:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  800dc9:	8b 45 10             	mov    0x10(%ebp),%eax
  800dcc:	8a 00                	mov    (%eax),%al
  800dce:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  800dd1:	83 fb 2f             	cmp    $0x2f,%ebx
  800dd4:	7e 3e                	jle    800e14 <vprintfmt+0xe9>
  800dd6:	83 fb 39             	cmp    $0x39,%ebx
  800dd9:	7f 39                	jg     800e14 <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800ddb:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800dde:	eb d5                	jmp    800db5 <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  800de0:	8b 45 14             	mov    0x14(%ebp),%eax
  800de3:	83 c0 04             	add    $0x4,%eax
  800de6:	89 45 14             	mov    %eax,0x14(%ebp)
  800de9:	8b 45 14             	mov    0x14(%ebp),%eax
  800dec:	83 e8 04             	sub    $0x4,%eax
  800def:	8b 00                	mov    (%eax),%eax
  800df1:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  800df4:	eb 1f                	jmp    800e15 <vprintfmt+0xea>

		case '.':
			if (width < 0)
  800df6:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800dfa:	79 83                	jns    800d7f <vprintfmt+0x54>
				width = 0;
  800dfc:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  800e03:	e9 77 ff ff ff       	jmp    800d7f <vprintfmt+0x54>

		case '#':
			altflag = 1;
  800e08:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  800e0f:	e9 6b ff ff ff       	jmp    800d7f <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  800e14:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  800e15:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800e19:	0f 89 60 ff ff ff    	jns    800d7f <vprintfmt+0x54>
				width = precision, precision = -1;
  800e1f:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800e22:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800e25:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  800e2c:	e9 4e ff ff ff       	jmp    800d7f <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  800e31:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  800e34:	e9 46 ff ff ff       	jmp    800d7f <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  800e39:	8b 45 14             	mov    0x14(%ebp),%eax
  800e3c:	83 c0 04             	add    $0x4,%eax
  800e3f:	89 45 14             	mov    %eax,0x14(%ebp)
  800e42:	8b 45 14             	mov    0x14(%ebp),%eax
  800e45:	83 e8 04             	sub    $0x4,%eax
  800e48:	8b 00                	mov    (%eax),%eax
  800e4a:	83 ec 08             	sub    $0x8,%esp
  800e4d:	ff 75 0c             	pushl  0xc(%ebp)
  800e50:	50                   	push   %eax
  800e51:	8b 45 08             	mov    0x8(%ebp),%eax
  800e54:	ff d0                	call   *%eax
  800e56:	83 c4 10             	add    $0x10,%esp
			break;
  800e59:	e9 89 02 00 00       	jmp    8010e7 <vprintfmt+0x3bc>

		// error message
		case 'e':
			err = va_arg(ap, int);
  800e5e:	8b 45 14             	mov    0x14(%ebp),%eax
  800e61:	83 c0 04             	add    $0x4,%eax
  800e64:	89 45 14             	mov    %eax,0x14(%ebp)
  800e67:	8b 45 14             	mov    0x14(%ebp),%eax
  800e6a:	83 e8 04             	sub    $0x4,%eax
  800e6d:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  800e6f:	85 db                	test   %ebx,%ebx
  800e71:	79 02                	jns    800e75 <vprintfmt+0x14a>
				err = -err;
  800e73:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  800e75:	83 fb 64             	cmp    $0x64,%ebx
  800e78:	7f 0b                	jg     800e85 <vprintfmt+0x15a>
  800e7a:	8b 34 9d c0 3d 80 00 	mov    0x803dc0(,%ebx,4),%esi
  800e81:	85 f6                	test   %esi,%esi
  800e83:	75 19                	jne    800e9e <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  800e85:	53                   	push   %ebx
  800e86:	68 65 3f 80 00       	push   $0x803f65
  800e8b:	ff 75 0c             	pushl  0xc(%ebp)
  800e8e:	ff 75 08             	pushl  0x8(%ebp)
  800e91:	e8 5e 02 00 00       	call   8010f4 <printfmt>
  800e96:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800e99:	e9 49 02 00 00       	jmp    8010e7 <vprintfmt+0x3bc>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800e9e:	56                   	push   %esi
  800e9f:	68 6e 3f 80 00       	push   $0x803f6e
  800ea4:	ff 75 0c             	pushl  0xc(%ebp)
  800ea7:	ff 75 08             	pushl  0x8(%ebp)
  800eaa:	e8 45 02 00 00       	call   8010f4 <printfmt>
  800eaf:	83 c4 10             	add    $0x10,%esp
			break;
  800eb2:	e9 30 02 00 00       	jmp    8010e7 <vprintfmt+0x3bc>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  800eb7:	8b 45 14             	mov    0x14(%ebp),%eax
  800eba:	83 c0 04             	add    $0x4,%eax
  800ebd:	89 45 14             	mov    %eax,0x14(%ebp)
  800ec0:	8b 45 14             	mov    0x14(%ebp),%eax
  800ec3:	83 e8 04             	sub    $0x4,%eax
  800ec6:	8b 30                	mov    (%eax),%esi
  800ec8:	85 f6                	test   %esi,%esi
  800eca:	75 05                	jne    800ed1 <vprintfmt+0x1a6>
				p = "(null)";
  800ecc:	be 71 3f 80 00       	mov    $0x803f71,%esi
			if (width > 0 && padc != '-')
  800ed1:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800ed5:	7e 6d                	jle    800f44 <vprintfmt+0x219>
  800ed7:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  800edb:	74 67                	je     800f44 <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  800edd:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800ee0:	83 ec 08             	sub    $0x8,%esp
  800ee3:	50                   	push   %eax
  800ee4:	56                   	push   %esi
  800ee5:	e8 12 05 00 00       	call   8013fc <strnlen>
  800eea:	83 c4 10             	add    $0x10,%esp
  800eed:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  800ef0:	eb 16                	jmp    800f08 <vprintfmt+0x1dd>
					putch(padc, putdat);
  800ef2:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  800ef6:	83 ec 08             	sub    $0x8,%esp
  800ef9:	ff 75 0c             	pushl  0xc(%ebp)
  800efc:	50                   	push   %eax
  800efd:	8b 45 08             	mov    0x8(%ebp),%eax
  800f00:	ff d0                	call   *%eax
  800f02:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800f05:	ff 4d e4             	decl   -0x1c(%ebp)
  800f08:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800f0c:	7f e4                	jg     800ef2 <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800f0e:	eb 34                	jmp    800f44 <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  800f10:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800f14:	74 1c                	je     800f32 <vprintfmt+0x207>
  800f16:	83 fb 1f             	cmp    $0x1f,%ebx
  800f19:	7e 05                	jle    800f20 <vprintfmt+0x1f5>
  800f1b:	83 fb 7e             	cmp    $0x7e,%ebx
  800f1e:	7e 12                	jle    800f32 <vprintfmt+0x207>
					putch('?', putdat);
  800f20:	83 ec 08             	sub    $0x8,%esp
  800f23:	ff 75 0c             	pushl  0xc(%ebp)
  800f26:	6a 3f                	push   $0x3f
  800f28:	8b 45 08             	mov    0x8(%ebp),%eax
  800f2b:	ff d0                	call   *%eax
  800f2d:	83 c4 10             	add    $0x10,%esp
  800f30:	eb 0f                	jmp    800f41 <vprintfmt+0x216>
				else
					putch(ch, putdat);
  800f32:	83 ec 08             	sub    $0x8,%esp
  800f35:	ff 75 0c             	pushl  0xc(%ebp)
  800f38:	53                   	push   %ebx
  800f39:	8b 45 08             	mov    0x8(%ebp),%eax
  800f3c:	ff d0                	call   *%eax
  800f3e:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800f41:	ff 4d e4             	decl   -0x1c(%ebp)
  800f44:	89 f0                	mov    %esi,%eax
  800f46:	8d 70 01             	lea    0x1(%eax),%esi
  800f49:	8a 00                	mov    (%eax),%al
  800f4b:	0f be d8             	movsbl %al,%ebx
  800f4e:	85 db                	test   %ebx,%ebx
  800f50:	74 24                	je     800f76 <vprintfmt+0x24b>
  800f52:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800f56:	78 b8                	js     800f10 <vprintfmt+0x1e5>
  800f58:	ff 4d e0             	decl   -0x20(%ebp)
  800f5b:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800f5f:	79 af                	jns    800f10 <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800f61:	eb 13                	jmp    800f76 <vprintfmt+0x24b>
				putch(' ', putdat);
  800f63:	83 ec 08             	sub    $0x8,%esp
  800f66:	ff 75 0c             	pushl  0xc(%ebp)
  800f69:	6a 20                	push   $0x20
  800f6b:	8b 45 08             	mov    0x8(%ebp),%eax
  800f6e:	ff d0                	call   *%eax
  800f70:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800f73:	ff 4d e4             	decl   -0x1c(%ebp)
  800f76:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800f7a:	7f e7                	jg     800f63 <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  800f7c:	e9 66 01 00 00       	jmp    8010e7 <vprintfmt+0x3bc>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  800f81:	83 ec 08             	sub    $0x8,%esp
  800f84:	ff 75 e8             	pushl  -0x18(%ebp)
  800f87:	8d 45 14             	lea    0x14(%ebp),%eax
  800f8a:	50                   	push   %eax
  800f8b:	e8 3c fd ff ff       	call   800ccc <getint>
  800f90:	83 c4 10             	add    $0x10,%esp
  800f93:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800f96:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  800f99:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800f9c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800f9f:	85 d2                	test   %edx,%edx
  800fa1:	79 23                	jns    800fc6 <vprintfmt+0x29b>
				putch('-', putdat);
  800fa3:	83 ec 08             	sub    $0x8,%esp
  800fa6:	ff 75 0c             	pushl  0xc(%ebp)
  800fa9:	6a 2d                	push   $0x2d
  800fab:	8b 45 08             	mov    0x8(%ebp),%eax
  800fae:	ff d0                	call   *%eax
  800fb0:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  800fb3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800fb6:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800fb9:	f7 d8                	neg    %eax
  800fbb:	83 d2 00             	adc    $0x0,%edx
  800fbe:	f7 da                	neg    %edx
  800fc0:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800fc3:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  800fc6:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800fcd:	e9 bc 00 00 00       	jmp    80108e <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  800fd2:	83 ec 08             	sub    $0x8,%esp
  800fd5:	ff 75 e8             	pushl  -0x18(%ebp)
  800fd8:	8d 45 14             	lea    0x14(%ebp),%eax
  800fdb:	50                   	push   %eax
  800fdc:	e8 84 fc ff ff       	call   800c65 <getuint>
  800fe1:	83 c4 10             	add    $0x10,%esp
  800fe4:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800fe7:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  800fea:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800ff1:	e9 98 00 00 00       	jmp    80108e <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  800ff6:	83 ec 08             	sub    $0x8,%esp
  800ff9:	ff 75 0c             	pushl  0xc(%ebp)
  800ffc:	6a 58                	push   $0x58
  800ffe:	8b 45 08             	mov    0x8(%ebp),%eax
  801001:	ff d0                	call   *%eax
  801003:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  801006:	83 ec 08             	sub    $0x8,%esp
  801009:	ff 75 0c             	pushl  0xc(%ebp)
  80100c:	6a 58                	push   $0x58
  80100e:	8b 45 08             	mov    0x8(%ebp),%eax
  801011:	ff d0                	call   *%eax
  801013:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  801016:	83 ec 08             	sub    $0x8,%esp
  801019:	ff 75 0c             	pushl  0xc(%ebp)
  80101c:	6a 58                	push   $0x58
  80101e:	8b 45 08             	mov    0x8(%ebp),%eax
  801021:	ff d0                	call   *%eax
  801023:	83 c4 10             	add    $0x10,%esp
			break;
  801026:	e9 bc 00 00 00       	jmp    8010e7 <vprintfmt+0x3bc>

		// pointer
		case 'p':
			putch('0', putdat);
  80102b:	83 ec 08             	sub    $0x8,%esp
  80102e:	ff 75 0c             	pushl  0xc(%ebp)
  801031:	6a 30                	push   $0x30
  801033:	8b 45 08             	mov    0x8(%ebp),%eax
  801036:	ff d0                	call   *%eax
  801038:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  80103b:	83 ec 08             	sub    $0x8,%esp
  80103e:	ff 75 0c             	pushl  0xc(%ebp)
  801041:	6a 78                	push   $0x78
  801043:	8b 45 08             	mov    0x8(%ebp),%eax
  801046:	ff d0                	call   *%eax
  801048:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  80104b:	8b 45 14             	mov    0x14(%ebp),%eax
  80104e:	83 c0 04             	add    $0x4,%eax
  801051:	89 45 14             	mov    %eax,0x14(%ebp)
  801054:	8b 45 14             	mov    0x14(%ebp),%eax
  801057:	83 e8 04             	sub    $0x4,%eax
  80105a:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  80105c:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80105f:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  801066:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  80106d:	eb 1f                	jmp    80108e <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  80106f:	83 ec 08             	sub    $0x8,%esp
  801072:	ff 75 e8             	pushl  -0x18(%ebp)
  801075:	8d 45 14             	lea    0x14(%ebp),%eax
  801078:	50                   	push   %eax
  801079:	e8 e7 fb ff ff       	call   800c65 <getuint>
  80107e:	83 c4 10             	add    $0x10,%esp
  801081:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801084:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  801087:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  80108e:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  801092:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801095:	83 ec 04             	sub    $0x4,%esp
  801098:	52                   	push   %edx
  801099:	ff 75 e4             	pushl  -0x1c(%ebp)
  80109c:	50                   	push   %eax
  80109d:	ff 75 f4             	pushl  -0xc(%ebp)
  8010a0:	ff 75 f0             	pushl  -0x10(%ebp)
  8010a3:	ff 75 0c             	pushl  0xc(%ebp)
  8010a6:	ff 75 08             	pushl  0x8(%ebp)
  8010a9:	e8 00 fb ff ff       	call   800bae <printnum>
  8010ae:	83 c4 20             	add    $0x20,%esp
			break;
  8010b1:	eb 34                	jmp    8010e7 <vprintfmt+0x3bc>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  8010b3:	83 ec 08             	sub    $0x8,%esp
  8010b6:	ff 75 0c             	pushl  0xc(%ebp)
  8010b9:	53                   	push   %ebx
  8010ba:	8b 45 08             	mov    0x8(%ebp),%eax
  8010bd:	ff d0                	call   *%eax
  8010bf:	83 c4 10             	add    $0x10,%esp
			break;
  8010c2:	eb 23                	jmp    8010e7 <vprintfmt+0x3bc>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  8010c4:	83 ec 08             	sub    $0x8,%esp
  8010c7:	ff 75 0c             	pushl  0xc(%ebp)
  8010ca:	6a 25                	push   $0x25
  8010cc:	8b 45 08             	mov    0x8(%ebp),%eax
  8010cf:	ff d0                	call   *%eax
  8010d1:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  8010d4:	ff 4d 10             	decl   0x10(%ebp)
  8010d7:	eb 03                	jmp    8010dc <vprintfmt+0x3b1>
  8010d9:	ff 4d 10             	decl   0x10(%ebp)
  8010dc:	8b 45 10             	mov    0x10(%ebp),%eax
  8010df:	48                   	dec    %eax
  8010e0:	8a 00                	mov    (%eax),%al
  8010e2:	3c 25                	cmp    $0x25,%al
  8010e4:	75 f3                	jne    8010d9 <vprintfmt+0x3ae>
				/* do nothing */;
			break;
  8010e6:	90                   	nop
		}
	}
  8010e7:	e9 47 fc ff ff       	jmp    800d33 <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  8010ec:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  8010ed:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8010f0:	5b                   	pop    %ebx
  8010f1:	5e                   	pop    %esi
  8010f2:	5d                   	pop    %ebp
  8010f3:	c3                   	ret    

008010f4 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  8010f4:	55                   	push   %ebp
  8010f5:	89 e5                	mov    %esp,%ebp
  8010f7:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  8010fa:	8d 45 10             	lea    0x10(%ebp),%eax
  8010fd:	83 c0 04             	add    $0x4,%eax
  801100:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  801103:	8b 45 10             	mov    0x10(%ebp),%eax
  801106:	ff 75 f4             	pushl  -0xc(%ebp)
  801109:	50                   	push   %eax
  80110a:	ff 75 0c             	pushl  0xc(%ebp)
  80110d:	ff 75 08             	pushl  0x8(%ebp)
  801110:	e8 16 fc ff ff       	call   800d2b <vprintfmt>
  801115:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  801118:	90                   	nop
  801119:	c9                   	leave  
  80111a:	c3                   	ret    

0080111b <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  80111b:	55                   	push   %ebp
  80111c:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  80111e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801121:	8b 40 08             	mov    0x8(%eax),%eax
  801124:	8d 50 01             	lea    0x1(%eax),%edx
  801127:	8b 45 0c             	mov    0xc(%ebp),%eax
  80112a:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  80112d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801130:	8b 10                	mov    (%eax),%edx
  801132:	8b 45 0c             	mov    0xc(%ebp),%eax
  801135:	8b 40 04             	mov    0x4(%eax),%eax
  801138:	39 c2                	cmp    %eax,%edx
  80113a:	73 12                	jae    80114e <sprintputch+0x33>
		*b->buf++ = ch;
  80113c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80113f:	8b 00                	mov    (%eax),%eax
  801141:	8d 48 01             	lea    0x1(%eax),%ecx
  801144:	8b 55 0c             	mov    0xc(%ebp),%edx
  801147:	89 0a                	mov    %ecx,(%edx)
  801149:	8b 55 08             	mov    0x8(%ebp),%edx
  80114c:	88 10                	mov    %dl,(%eax)
}
  80114e:	90                   	nop
  80114f:	5d                   	pop    %ebp
  801150:	c3                   	ret    

00801151 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  801151:	55                   	push   %ebp
  801152:	89 e5                	mov    %esp,%ebp
  801154:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  801157:	8b 45 08             	mov    0x8(%ebp),%eax
  80115a:	89 45 ec             	mov    %eax,-0x14(%ebp)
  80115d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801160:	8d 50 ff             	lea    -0x1(%eax),%edx
  801163:	8b 45 08             	mov    0x8(%ebp),%eax
  801166:	01 d0                	add    %edx,%eax
  801168:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80116b:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  801172:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801176:	74 06                	je     80117e <vsnprintf+0x2d>
  801178:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80117c:	7f 07                	jg     801185 <vsnprintf+0x34>
		return -E_INVAL;
  80117e:	b8 03 00 00 00       	mov    $0x3,%eax
  801183:	eb 20                	jmp    8011a5 <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  801185:	ff 75 14             	pushl  0x14(%ebp)
  801188:	ff 75 10             	pushl  0x10(%ebp)
  80118b:	8d 45 ec             	lea    -0x14(%ebp),%eax
  80118e:	50                   	push   %eax
  80118f:	68 1b 11 80 00       	push   $0x80111b
  801194:	e8 92 fb ff ff       	call   800d2b <vprintfmt>
  801199:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  80119c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80119f:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  8011a2:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  8011a5:	c9                   	leave  
  8011a6:	c3                   	ret    

008011a7 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  8011a7:	55                   	push   %ebp
  8011a8:	89 e5                	mov    %esp,%ebp
  8011aa:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  8011ad:	8d 45 10             	lea    0x10(%ebp),%eax
  8011b0:	83 c0 04             	add    $0x4,%eax
  8011b3:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  8011b6:	8b 45 10             	mov    0x10(%ebp),%eax
  8011b9:	ff 75 f4             	pushl  -0xc(%ebp)
  8011bc:	50                   	push   %eax
  8011bd:	ff 75 0c             	pushl  0xc(%ebp)
  8011c0:	ff 75 08             	pushl  0x8(%ebp)
  8011c3:	e8 89 ff ff ff       	call   801151 <vsnprintf>
  8011c8:	83 c4 10             	add    $0x10,%esp
  8011cb:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  8011ce:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8011d1:	c9                   	leave  
  8011d2:	c3                   	ret    

008011d3 <readline>:
#include <inc/lib.h>

//static char buf[BUFLEN];

void readline(const char *prompt, char* buf)
{
  8011d3:	55                   	push   %ebp
  8011d4:	89 e5                	mov    %esp,%ebp
  8011d6:	83 ec 18             	sub    $0x18,%esp
		int i, c, echoing;

	if (prompt != NULL)
  8011d9:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8011dd:	74 13                	je     8011f2 <readline+0x1f>
		cprintf("%s", prompt);
  8011df:	83 ec 08             	sub    $0x8,%esp
  8011e2:	ff 75 08             	pushl  0x8(%ebp)
  8011e5:	68 d0 40 80 00       	push   $0x8040d0
  8011ea:	e8 62 f9 ff ff       	call   800b51 <cprintf>
  8011ef:	83 c4 10             	add    $0x10,%esp

	i = 0;
  8011f2:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	echoing = iscons(0);
  8011f9:	83 ec 0c             	sub    $0xc,%esp
  8011fc:	6a 00                	push   $0x0
  8011fe:	e8 54 f5 ff ff       	call   800757 <iscons>
  801203:	83 c4 10             	add    $0x10,%esp
  801206:	89 45 f0             	mov    %eax,-0x10(%ebp)
	while (1) {
		c = getchar();
  801209:	e8 fb f4 ff ff       	call   800709 <getchar>
  80120e:	89 45 ec             	mov    %eax,-0x14(%ebp)
		if (c < 0) {
  801211:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  801215:	79 22                	jns    801239 <readline+0x66>
			if (c != -E_EOF)
  801217:	83 7d ec 07          	cmpl   $0x7,-0x14(%ebp)
  80121b:	0f 84 ad 00 00 00    	je     8012ce <readline+0xfb>
				cprintf("read error: %e\n", c);
  801221:	83 ec 08             	sub    $0x8,%esp
  801224:	ff 75 ec             	pushl  -0x14(%ebp)
  801227:	68 d3 40 80 00       	push   $0x8040d3
  80122c:	e8 20 f9 ff ff       	call   800b51 <cprintf>
  801231:	83 c4 10             	add    $0x10,%esp
			return;
  801234:	e9 95 00 00 00       	jmp    8012ce <readline+0xfb>
		} else if (c >= ' ' && i < BUFLEN-1) {
  801239:	83 7d ec 1f          	cmpl   $0x1f,-0x14(%ebp)
  80123d:	7e 34                	jle    801273 <readline+0xa0>
  80123f:	81 7d f4 fe 03 00 00 	cmpl   $0x3fe,-0xc(%ebp)
  801246:	7f 2b                	jg     801273 <readline+0xa0>
			if (echoing)
  801248:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80124c:	74 0e                	je     80125c <readline+0x89>
				cputchar(c);
  80124e:	83 ec 0c             	sub    $0xc,%esp
  801251:	ff 75 ec             	pushl  -0x14(%ebp)
  801254:	e8 68 f4 ff ff       	call   8006c1 <cputchar>
  801259:	83 c4 10             	add    $0x10,%esp
			buf[i++] = c;
  80125c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80125f:	8d 50 01             	lea    0x1(%eax),%edx
  801262:	89 55 f4             	mov    %edx,-0xc(%ebp)
  801265:	89 c2                	mov    %eax,%edx
  801267:	8b 45 0c             	mov    0xc(%ebp),%eax
  80126a:	01 d0                	add    %edx,%eax
  80126c:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80126f:	88 10                	mov    %dl,(%eax)
  801271:	eb 56                	jmp    8012c9 <readline+0xf6>
		} else if (c == '\b' && i > 0) {
  801273:	83 7d ec 08          	cmpl   $0x8,-0x14(%ebp)
  801277:	75 1f                	jne    801298 <readline+0xc5>
  801279:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80127d:	7e 19                	jle    801298 <readline+0xc5>
			if (echoing)
  80127f:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801283:	74 0e                	je     801293 <readline+0xc0>
				cputchar(c);
  801285:	83 ec 0c             	sub    $0xc,%esp
  801288:	ff 75 ec             	pushl  -0x14(%ebp)
  80128b:	e8 31 f4 ff ff       	call   8006c1 <cputchar>
  801290:	83 c4 10             	add    $0x10,%esp

			i--;
  801293:	ff 4d f4             	decl   -0xc(%ebp)
  801296:	eb 31                	jmp    8012c9 <readline+0xf6>
		} else if (c == '\n' || c == '\r') {
  801298:	83 7d ec 0a          	cmpl   $0xa,-0x14(%ebp)
  80129c:	74 0a                	je     8012a8 <readline+0xd5>
  80129e:	83 7d ec 0d          	cmpl   $0xd,-0x14(%ebp)
  8012a2:	0f 85 61 ff ff ff    	jne    801209 <readline+0x36>
			if (echoing)
  8012a8:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8012ac:	74 0e                	je     8012bc <readline+0xe9>
				cputchar(c);
  8012ae:	83 ec 0c             	sub    $0xc,%esp
  8012b1:	ff 75 ec             	pushl  -0x14(%ebp)
  8012b4:	e8 08 f4 ff ff       	call   8006c1 <cputchar>
  8012b9:	83 c4 10             	add    $0x10,%esp

			buf[i] = 0;
  8012bc:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8012bf:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012c2:	01 d0                	add    %edx,%eax
  8012c4:	c6 00 00             	movb   $0x0,(%eax)
			return;
  8012c7:	eb 06                	jmp    8012cf <readline+0xfc>
		}
	}
  8012c9:	e9 3b ff ff ff       	jmp    801209 <readline+0x36>
	while (1) {
		c = getchar();
		if (c < 0) {
			if (c != -E_EOF)
				cprintf("read error: %e\n", c);
			return;
  8012ce:	90                   	nop
			buf[i] = 0;
			return;
		}
	}

}
  8012cf:	c9                   	leave  
  8012d0:	c3                   	ret    

008012d1 <atomic_readline>:

void atomic_readline(const char *prompt, char* buf)
{
  8012d1:	55                   	push   %ebp
  8012d2:	89 e5                	mov    %esp,%ebp
  8012d4:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  8012d7:	e8 06 0f 00 00       	call   8021e2 <sys_disable_interrupt>
	int i, c, echoing;

	if (prompt != NULL)
  8012dc:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8012e0:	74 13                	je     8012f5 <atomic_readline+0x24>
		cprintf("%s", prompt);
  8012e2:	83 ec 08             	sub    $0x8,%esp
  8012e5:	ff 75 08             	pushl  0x8(%ebp)
  8012e8:	68 d0 40 80 00       	push   $0x8040d0
  8012ed:	e8 5f f8 ff ff       	call   800b51 <cprintf>
  8012f2:	83 c4 10             	add    $0x10,%esp

	i = 0;
  8012f5:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	echoing = iscons(0);
  8012fc:	83 ec 0c             	sub    $0xc,%esp
  8012ff:	6a 00                	push   $0x0
  801301:	e8 51 f4 ff ff       	call   800757 <iscons>
  801306:	83 c4 10             	add    $0x10,%esp
  801309:	89 45 f0             	mov    %eax,-0x10(%ebp)
	while (1) {
		c = getchar();
  80130c:	e8 f8 f3 ff ff       	call   800709 <getchar>
  801311:	89 45 ec             	mov    %eax,-0x14(%ebp)
		if (c < 0) {
  801314:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  801318:	79 23                	jns    80133d <atomic_readline+0x6c>
			if (c != -E_EOF)
  80131a:	83 7d ec 07          	cmpl   $0x7,-0x14(%ebp)
  80131e:	74 13                	je     801333 <atomic_readline+0x62>
				cprintf("read error: %e\n", c);
  801320:	83 ec 08             	sub    $0x8,%esp
  801323:	ff 75 ec             	pushl  -0x14(%ebp)
  801326:	68 d3 40 80 00       	push   $0x8040d3
  80132b:	e8 21 f8 ff ff       	call   800b51 <cprintf>
  801330:	83 c4 10             	add    $0x10,%esp
			sys_enable_interrupt();
  801333:	e8 c4 0e 00 00       	call   8021fc <sys_enable_interrupt>
			return;
  801338:	e9 9a 00 00 00       	jmp    8013d7 <atomic_readline+0x106>
		} else if (c >= ' ' && i < BUFLEN-1) {
  80133d:	83 7d ec 1f          	cmpl   $0x1f,-0x14(%ebp)
  801341:	7e 34                	jle    801377 <atomic_readline+0xa6>
  801343:	81 7d f4 fe 03 00 00 	cmpl   $0x3fe,-0xc(%ebp)
  80134a:	7f 2b                	jg     801377 <atomic_readline+0xa6>
			if (echoing)
  80134c:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801350:	74 0e                	je     801360 <atomic_readline+0x8f>
				cputchar(c);
  801352:	83 ec 0c             	sub    $0xc,%esp
  801355:	ff 75 ec             	pushl  -0x14(%ebp)
  801358:	e8 64 f3 ff ff       	call   8006c1 <cputchar>
  80135d:	83 c4 10             	add    $0x10,%esp
			buf[i++] = c;
  801360:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801363:	8d 50 01             	lea    0x1(%eax),%edx
  801366:	89 55 f4             	mov    %edx,-0xc(%ebp)
  801369:	89 c2                	mov    %eax,%edx
  80136b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80136e:	01 d0                	add    %edx,%eax
  801370:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801373:	88 10                	mov    %dl,(%eax)
  801375:	eb 5b                	jmp    8013d2 <atomic_readline+0x101>
		} else if (c == '\b' && i > 0) {
  801377:	83 7d ec 08          	cmpl   $0x8,-0x14(%ebp)
  80137b:	75 1f                	jne    80139c <atomic_readline+0xcb>
  80137d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801381:	7e 19                	jle    80139c <atomic_readline+0xcb>
			if (echoing)
  801383:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801387:	74 0e                	je     801397 <atomic_readline+0xc6>
				cputchar(c);
  801389:	83 ec 0c             	sub    $0xc,%esp
  80138c:	ff 75 ec             	pushl  -0x14(%ebp)
  80138f:	e8 2d f3 ff ff       	call   8006c1 <cputchar>
  801394:	83 c4 10             	add    $0x10,%esp
			i--;
  801397:	ff 4d f4             	decl   -0xc(%ebp)
  80139a:	eb 36                	jmp    8013d2 <atomic_readline+0x101>
		} else if (c == '\n' || c == '\r') {
  80139c:	83 7d ec 0a          	cmpl   $0xa,-0x14(%ebp)
  8013a0:	74 0a                	je     8013ac <atomic_readline+0xdb>
  8013a2:	83 7d ec 0d          	cmpl   $0xd,-0x14(%ebp)
  8013a6:	0f 85 60 ff ff ff    	jne    80130c <atomic_readline+0x3b>
			if (echoing)
  8013ac:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8013b0:	74 0e                	je     8013c0 <atomic_readline+0xef>
				cputchar(c);
  8013b2:	83 ec 0c             	sub    $0xc,%esp
  8013b5:	ff 75 ec             	pushl  -0x14(%ebp)
  8013b8:	e8 04 f3 ff ff       	call   8006c1 <cputchar>
  8013bd:	83 c4 10             	add    $0x10,%esp
			buf[i] = 0;
  8013c0:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8013c3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8013c6:	01 d0                	add    %edx,%eax
  8013c8:	c6 00 00             	movb   $0x0,(%eax)
			sys_enable_interrupt();
  8013cb:	e8 2c 0e 00 00       	call   8021fc <sys_enable_interrupt>
			return;
  8013d0:	eb 05                	jmp    8013d7 <atomic_readline+0x106>
		}
	}
  8013d2:	e9 35 ff ff ff       	jmp    80130c <atomic_readline+0x3b>
}
  8013d7:	c9                   	leave  
  8013d8:	c3                   	ret    

008013d9 <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  8013d9:	55                   	push   %ebp
  8013da:	89 e5                	mov    %esp,%ebp
  8013dc:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  8013df:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8013e6:	eb 06                	jmp    8013ee <strlen+0x15>
		n++;
  8013e8:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  8013eb:	ff 45 08             	incl   0x8(%ebp)
  8013ee:	8b 45 08             	mov    0x8(%ebp),%eax
  8013f1:	8a 00                	mov    (%eax),%al
  8013f3:	84 c0                	test   %al,%al
  8013f5:	75 f1                	jne    8013e8 <strlen+0xf>
		n++;
	return n;
  8013f7:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  8013fa:	c9                   	leave  
  8013fb:	c3                   	ret    

008013fc <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  8013fc:	55                   	push   %ebp
  8013fd:	89 e5                	mov    %esp,%ebp
  8013ff:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  801402:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801409:	eb 09                	jmp    801414 <strnlen+0x18>
		n++;
  80140b:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  80140e:	ff 45 08             	incl   0x8(%ebp)
  801411:	ff 4d 0c             	decl   0xc(%ebp)
  801414:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801418:	74 09                	je     801423 <strnlen+0x27>
  80141a:	8b 45 08             	mov    0x8(%ebp),%eax
  80141d:	8a 00                	mov    (%eax),%al
  80141f:	84 c0                	test   %al,%al
  801421:	75 e8                	jne    80140b <strnlen+0xf>
		n++;
	return n;
  801423:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  801426:	c9                   	leave  
  801427:	c3                   	ret    

00801428 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  801428:	55                   	push   %ebp
  801429:	89 e5                	mov    %esp,%ebp
  80142b:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  80142e:	8b 45 08             	mov    0x8(%ebp),%eax
  801431:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  801434:	90                   	nop
  801435:	8b 45 08             	mov    0x8(%ebp),%eax
  801438:	8d 50 01             	lea    0x1(%eax),%edx
  80143b:	89 55 08             	mov    %edx,0x8(%ebp)
  80143e:	8b 55 0c             	mov    0xc(%ebp),%edx
  801441:	8d 4a 01             	lea    0x1(%edx),%ecx
  801444:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  801447:	8a 12                	mov    (%edx),%dl
  801449:	88 10                	mov    %dl,(%eax)
  80144b:	8a 00                	mov    (%eax),%al
  80144d:	84 c0                	test   %al,%al
  80144f:	75 e4                	jne    801435 <strcpy+0xd>
		/* do nothing */;
	return ret;
  801451:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  801454:	c9                   	leave  
  801455:	c3                   	ret    

00801456 <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  801456:	55                   	push   %ebp
  801457:	89 e5                	mov    %esp,%ebp
  801459:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  80145c:	8b 45 08             	mov    0x8(%ebp),%eax
  80145f:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  801462:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801469:	eb 1f                	jmp    80148a <strncpy+0x34>
		*dst++ = *src;
  80146b:	8b 45 08             	mov    0x8(%ebp),%eax
  80146e:	8d 50 01             	lea    0x1(%eax),%edx
  801471:	89 55 08             	mov    %edx,0x8(%ebp)
  801474:	8b 55 0c             	mov    0xc(%ebp),%edx
  801477:	8a 12                	mov    (%edx),%dl
  801479:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  80147b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80147e:	8a 00                	mov    (%eax),%al
  801480:	84 c0                	test   %al,%al
  801482:	74 03                	je     801487 <strncpy+0x31>
			src++;
  801484:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  801487:	ff 45 fc             	incl   -0x4(%ebp)
  80148a:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80148d:	3b 45 10             	cmp    0x10(%ebp),%eax
  801490:	72 d9                	jb     80146b <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  801492:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  801495:	c9                   	leave  
  801496:	c3                   	ret    

00801497 <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  801497:	55                   	push   %ebp
  801498:	89 e5                	mov    %esp,%ebp
  80149a:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  80149d:	8b 45 08             	mov    0x8(%ebp),%eax
  8014a0:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  8014a3:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8014a7:	74 30                	je     8014d9 <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  8014a9:	eb 16                	jmp    8014c1 <strlcpy+0x2a>
			*dst++ = *src++;
  8014ab:	8b 45 08             	mov    0x8(%ebp),%eax
  8014ae:	8d 50 01             	lea    0x1(%eax),%edx
  8014b1:	89 55 08             	mov    %edx,0x8(%ebp)
  8014b4:	8b 55 0c             	mov    0xc(%ebp),%edx
  8014b7:	8d 4a 01             	lea    0x1(%edx),%ecx
  8014ba:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  8014bd:	8a 12                	mov    (%edx),%dl
  8014bf:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  8014c1:	ff 4d 10             	decl   0x10(%ebp)
  8014c4:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8014c8:	74 09                	je     8014d3 <strlcpy+0x3c>
  8014ca:	8b 45 0c             	mov    0xc(%ebp),%eax
  8014cd:	8a 00                	mov    (%eax),%al
  8014cf:	84 c0                	test   %al,%al
  8014d1:	75 d8                	jne    8014ab <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  8014d3:	8b 45 08             	mov    0x8(%ebp),%eax
  8014d6:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  8014d9:	8b 55 08             	mov    0x8(%ebp),%edx
  8014dc:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8014df:	29 c2                	sub    %eax,%edx
  8014e1:	89 d0                	mov    %edx,%eax
}
  8014e3:	c9                   	leave  
  8014e4:	c3                   	ret    

008014e5 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  8014e5:	55                   	push   %ebp
  8014e6:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  8014e8:	eb 06                	jmp    8014f0 <strcmp+0xb>
		p++, q++;
  8014ea:	ff 45 08             	incl   0x8(%ebp)
  8014ed:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  8014f0:	8b 45 08             	mov    0x8(%ebp),%eax
  8014f3:	8a 00                	mov    (%eax),%al
  8014f5:	84 c0                	test   %al,%al
  8014f7:	74 0e                	je     801507 <strcmp+0x22>
  8014f9:	8b 45 08             	mov    0x8(%ebp),%eax
  8014fc:	8a 10                	mov    (%eax),%dl
  8014fe:	8b 45 0c             	mov    0xc(%ebp),%eax
  801501:	8a 00                	mov    (%eax),%al
  801503:	38 c2                	cmp    %al,%dl
  801505:	74 e3                	je     8014ea <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  801507:	8b 45 08             	mov    0x8(%ebp),%eax
  80150a:	8a 00                	mov    (%eax),%al
  80150c:	0f b6 d0             	movzbl %al,%edx
  80150f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801512:	8a 00                	mov    (%eax),%al
  801514:	0f b6 c0             	movzbl %al,%eax
  801517:	29 c2                	sub    %eax,%edx
  801519:	89 d0                	mov    %edx,%eax
}
  80151b:	5d                   	pop    %ebp
  80151c:	c3                   	ret    

0080151d <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  80151d:	55                   	push   %ebp
  80151e:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  801520:	eb 09                	jmp    80152b <strncmp+0xe>
		n--, p++, q++;
  801522:	ff 4d 10             	decl   0x10(%ebp)
  801525:	ff 45 08             	incl   0x8(%ebp)
  801528:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  80152b:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80152f:	74 17                	je     801548 <strncmp+0x2b>
  801531:	8b 45 08             	mov    0x8(%ebp),%eax
  801534:	8a 00                	mov    (%eax),%al
  801536:	84 c0                	test   %al,%al
  801538:	74 0e                	je     801548 <strncmp+0x2b>
  80153a:	8b 45 08             	mov    0x8(%ebp),%eax
  80153d:	8a 10                	mov    (%eax),%dl
  80153f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801542:	8a 00                	mov    (%eax),%al
  801544:	38 c2                	cmp    %al,%dl
  801546:	74 da                	je     801522 <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  801548:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80154c:	75 07                	jne    801555 <strncmp+0x38>
		return 0;
  80154e:	b8 00 00 00 00       	mov    $0x0,%eax
  801553:	eb 14                	jmp    801569 <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  801555:	8b 45 08             	mov    0x8(%ebp),%eax
  801558:	8a 00                	mov    (%eax),%al
  80155a:	0f b6 d0             	movzbl %al,%edx
  80155d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801560:	8a 00                	mov    (%eax),%al
  801562:	0f b6 c0             	movzbl %al,%eax
  801565:	29 c2                	sub    %eax,%edx
  801567:	89 d0                	mov    %edx,%eax
}
  801569:	5d                   	pop    %ebp
  80156a:	c3                   	ret    

0080156b <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  80156b:	55                   	push   %ebp
  80156c:	89 e5                	mov    %esp,%ebp
  80156e:	83 ec 04             	sub    $0x4,%esp
  801571:	8b 45 0c             	mov    0xc(%ebp),%eax
  801574:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  801577:	eb 12                	jmp    80158b <strchr+0x20>
		if (*s == c)
  801579:	8b 45 08             	mov    0x8(%ebp),%eax
  80157c:	8a 00                	mov    (%eax),%al
  80157e:	3a 45 fc             	cmp    -0x4(%ebp),%al
  801581:	75 05                	jne    801588 <strchr+0x1d>
			return (char *) s;
  801583:	8b 45 08             	mov    0x8(%ebp),%eax
  801586:	eb 11                	jmp    801599 <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  801588:	ff 45 08             	incl   0x8(%ebp)
  80158b:	8b 45 08             	mov    0x8(%ebp),%eax
  80158e:	8a 00                	mov    (%eax),%al
  801590:	84 c0                	test   %al,%al
  801592:	75 e5                	jne    801579 <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  801594:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801599:	c9                   	leave  
  80159a:	c3                   	ret    

0080159b <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  80159b:	55                   	push   %ebp
  80159c:	89 e5                	mov    %esp,%ebp
  80159e:	83 ec 04             	sub    $0x4,%esp
  8015a1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8015a4:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  8015a7:	eb 0d                	jmp    8015b6 <strfind+0x1b>
		if (*s == c)
  8015a9:	8b 45 08             	mov    0x8(%ebp),%eax
  8015ac:	8a 00                	mov    (%eax),%al
  8015ae:	3a 45 fc             	cmp    -0x4(%ebp),%al
  8015b1:	74 0e                	je     8015c1 <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  8015b3:	ff 45 08             	incl   0x8(%ebp)
  8015b6:	8b 45 08             	mov    0x8(%ebp),%eax
  8015b9:	8a 00                	mov    (%eax),%al
  8015bb:	84 c0                	test   %al,%al
  8015bd:	75 ea                	jne    8015a9 <strfind+0xe>
  8015bf:	eb 01                	jmp    8015c2 <strfind+0x27>
		if (*s == c)
			break;
  8015c1:	90                   	nop
	return (char *) s;
  8015c2:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8015c5:	c9                   	leave  
  8015c6:	c3                   	ret    

008015c7 <memset>:


void *
memset(void *v, int c, uint32 n)
{
  8015c7:	55                   	push   %ebp
  8015c8:	89 e5                	mov    %esp,%ebp
  8015ca:	83 ec 10             	sub    $0x10,%esp
	char *p;
	int m;

	p = v;
  8015cd:	8b 45 08             	mov    0x8(%ebp),%eax
  8015d0:	89 45 fc             	mov    %eax,-0x4(%ebp)
	m = n;
  8015d3:	8b 45 10             	mov    0x10(%ebp),%eax
  8015d6:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (--m >= 0)
  8015d9:	eb 0e                	jmp    8015e9 <memset+0x22>
		*p++ = c;
  8015db:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8015de:	8d 50 01             	lea    0x1(%eax),%edx
  8015e1:	89 55 fc             	mov    %edx,-0x4(%ebp)
  8015e4:	8b 55 0c             	mov    0xc(%ebp),%edx
  8015e7:	88 10                	mov    %dl,(%eax)
	char *p;
	int m;

	p = v;
	m = n;
	while (--m >= 0)
  8015e9:	ff 4d f8             	decl   -0x8(%ebp)
  8015ec:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  8015f0:	79 e9                	jns    8015db <memset+0x14>
		*p++ = c;

	return v;
  8015f2:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8015f5:	c9                   	leave  
  8015f6:	c3                   	ret    

008015f7 <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  8015f7:	55                   	push   %ebp
  8015f8:	89 e5                	mov    %esp,%ebp
  8015fa:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  8015fd:	8b 45 0c             	mov    0xc(%ebp),%eax
  801600:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  801603:	8b 45 08             	mov    0x8(%ebp),%eax
  801606:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (n-- > 0)
  801609:	eb 16                	jmp    801621 <memcpy+0x2a>
		*d++ = *s++;
  80160b:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80160e:	8d 50 01             	lea    0x1(%eax),%edx
  801611:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801614:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801617:	8d 4a 01             	lea    0x1(%edx),%ecx
  80161a:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  80161d:	8a 12                	mov    (%edx),%dl
  80161f:	88 10                	mov    %dl,(%eax)
	const char *s;
	char *d;

	s = src;
	d = dst;
	while (n-- > 0)
  801621:	8b 45 10             	mov    0x10(%ebp),%eax
  801624:	8d 50 ff             	lea    -0x1(%eax),%edx
  801627:	89 55 10             	mov    %edx,0x10(%ebp)
  80162a:	85 c0                	test   %eax,%eax
  80162c:	75 dd                	jne    80160b <memcpy+0x14>
		*d++ = *s++;

	return dst;
  80162e:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801631:	c9                   	leave  
  801632:	c3                   	ret    

00801633 <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  801633:	55                   	push   %ebp
  801634:	89 e5                	mov    %esp,%ebp
  801636:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  801639:	8b 45 0c             	mov    0xc(%ebp),%eax
  80163c:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  80163f:	8b 45 08             	mov    0x8(%ebp),%eax
  801642:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  801645:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801648:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  80164b:	73 50                	jae    80169d <memmove+0x6a>
  80164d:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801650:	8b 45 10             	mov    0x10(%ebp),%eax
  801653:	01 d0                	add    %edx,%eax
  801655:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  801658:	76 43                	jbe    80169d <memmove+0x6a>
		s += n;
  80165a:	8b 45 10             	mov    0x10(%ebp),%eax
  80165d:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  801660:	8b 45 10             	mov    0x10(%ebp),%eax
  801663:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  801666:	eb 10                	jmp    801678 <memmove+0x45>
			*--d = *--s;
  801668:	ff 4d f8             	decl   -0x8(%ebp)
  80166b:	ff 4d fc             	decl   -0x4(%ebp)
  80166e:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801671:	8a 10                	mov    (%eax),%dl
  801673:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801676:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  801678:	8b 45 10             	mov    0x10(%ebp),%eax
  80167b:	8d 50 ff             	lea    -0x1(%eax),%edx
  80167e:	89 55 10             	mov    %edx,0x10(%ebp)
  801681:	85 c0                	test   %eax,%eax
  801683:	75 e3                	jne    801668 <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  801685:	eb 23                	jmp    8016aa <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  801687:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80168a:	8d 50 01             	lea    0x1(%eax),%edx
  80168d:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801690:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801693:	8d 4a 01             	lea    0x1(%edx),%ecx
  801696:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  801699:	8a 12                	mov    (%edx),%dl
  80169b:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  80169d:	8b 45 10             	mov    0x10(%ebp),%eax
  8016a0:	8d 50 ff             	lea    -0x1(%eax),%edx
  8016a3:	89 55 10             	mov    %edx,0x10(%ebp)
  8016a6:	85 c0                	test   %eax,%eax
  8016a8:	75 dd                	jne    801687 <memmove+0x54>
			*d++ = *s++;

	return dst;
  8016aa:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8016ad:	c9                   	leave  
  8016ae:	c3                   	ret    

008016af <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  8016af:	55                   	push   %ebp
  8016b0:	89 e5                	mov    %esp,%ebp
  8016b2:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  8016b5:	8b 45 08             	mov    0x8(%ebp),%eax
  8016b8:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  8016bb:	8b 45 0c             	mov    0xc(%ebp),%eax
  8016be:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  8016c1:	eb 2a                	jmp    8016ed <memcmp+0x3e>
		if (*s1 != *s2)
  8016c3:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8016c6:	8a 10                	mov    (%eax),%dl
  8016c8:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8016cb:	8a 00                	mov    (%eax),%al
  8016cd:	38 c2                	cmp    %al,%dl
  8016cf:	74 16                	je     8016e7 <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  8016d1:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8016d4:	8a 00                	mov    (%eax),%al
  8016d6:	0f b6 d0             	movzbl %al,%edx
  8016d9:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8016dc:	8a 00                	mov    (%eax),%al
  8016de:	0f b6 c0             	movzbl %al,%eax
  8016e1:	29 c2                	sub    %eax,%edx
  8016e3:	89 d0                	mov    %edx,%eax
  8016e5:	eb 18                	jmp    8016ff <memcmp+0x50>
		s1++, s2++;
  8016e7:	ff 45 fc             	incl   -0x4(%ebp)
  8016ea:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  8016ed:	8b 45 10             	mov    0x10(%ebp),%eax
  8016f0:	8d 50 ff             	lea    -0x1(%eax),%edx
  8016f3:	89 55 10             	mov    %edx,0x10(%ebp)
  8016f6:	85 c0                	test   %eax,%eax
  8016f8:	75 c9                	jne    8016c3 <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  8016fa:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8016ff:	c9                   	leave  
  801700:	c3                   	ret    

00801701 <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  801701:	55                   	push   %ebp
  801702:	89 e5                	mov    %esp,%ebp
  801704:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  801707:	8b 55 08             	mov    0x8(%ebp),%edx
  80170a:	8b 45 10             	mov    0x10(%ebp),%eax
  80170d:	01 d0                	add    %edx,%eax
  80170f:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  801712:	eb 15                	jmp    801729 <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  801714:	8b 45 08             	mov    0x8(%ebp),%eax
  801717:	8a 00                	mov    (%eax),%al
  801719:	0f b6 d0             	movzbl %al,%edx
  80171c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80171f:	0f b6 c0             	movzbl %al,%eax
  801722:	39 c2                	cmp    %eax,%edx
  801724:	74 0d                	je     801733 <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  801726:	ff 45 08             	incl   0x8(%ebp)
  801729:	8b 45 08             	mov    0x8(%ebp),%eax
  80172c:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  80172f:	72 e3                	jb     801714 <memfind+0x13>
  801731:	eb 01                	jmp    801734 <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  801733:	90                   	nop
	return (void *) s;
  801734:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801737:	c9                   	leave  
  801738:	c3                   	ret    

00801739 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  801739:	55                   	push   %ebp
  80173a:	89 e5                	mov    %esp,%ebp
  80173c:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  80173f:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  801746:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  80174d:	eb 03                	jmp    801752 <strtol+0x19>
		s++;
  80174f:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801752:	8b 45 08             	mov    0x8(%ebp),%eax
  801755:	8a 00                	mov    (%eax),%al
  801757:	3c 20                	cmp    $0x20,%al
  801759:	74 f4                	je     80174f <strtol+0x16>
  80175b:	8b 45 08             	mov    0x8(%ebp),%eax
  80175e:	8a 00                	mov    (%eax),%al
  801760:	3c 09                	cmp    $0x9,%al
  801762:	74 eb                	je     80174f <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  801764:	8b 45 08             	mov    0x8(%ebp),%eax
  801767:	8a 00                	mov    (%eax),%al
  801769:	3c 2b                	cmp    $0x2b,%al
  80176b:	75 05                	jne    801772 <strtol+0x39>
		s++;
  80176d:	ff 45 08             	incl   0x8(%ebp)
  801770:	eb 13                	jmp    801785 <strtol+0x4c>
	else if (*s == '-')
  801772:	8b 45 08             	mov    0x8(%ebp),%eax
  801775:	8a 00                	mov    (%eax),%al
  801777:	3c 2d                	cmp    $0x2d,%al
  801779:	75 0a                	jne    801785 <strtol+0x4c>
		s++, neg = 1;
  80177b:	ff 45 08             	incl   0x8(%ebp)
  80177e:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  801785:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801789:	74 06                	je     801791 <strtol+0x58>
  80178b:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  80178f:	75 20                	jne    8017b1 <strtol+0x78>
  801791:	8b 45 08             	mov    0x8(%ebp),%eax
  801794:	8a 00                	mov    (%eax),%al
  801796:	3c 30                	cmp    $0x30,%al
  801798:	75 17                	jne    8017b1 <strtol+0x78>
  80179a:	8b 45 08             	mov    0x8(%ebp),%eax
  80179d:	40                   	inc    %eax
  80179e:	8a 00                	mov    (%eax),%al
  8017a0:	3c 78                	cmp    $0x78,%al
  8017a2:	75 0d                	jne    8017b1 <strtol+0x78>
		s += 2, base = 16;
  8017a4:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  8017a8:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  8017af:	eb 28                	jmp    8017d9 <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  8017b1:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8017b5:	75 15                	jne    8017cc <strtol+0x93>
  8017b7:	8b 45 08             	mov    0x8(%ebp),%eax
  8017ba:	8a 00                	mov    (%eax),%al
  8017bc:	3c 30                	cmp    $0x30,%al
  8017be:	75 0c                	jne    8017cc <strtol+0x93>
		s++, base = 8;
  8017c0:	ff 45 08             	incl   0x8(%ebp)
  8017c3:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  8017ca:	eb 0d                	jmp    8017d9 <strtol+0xa0>
	else if (base == 0)
  8017cc:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8017d0:	75 07                	jne    8017d9 <strtol+0xa0>
		base = 10;
  8017d2:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  8017d9:	8b 45 08             	mov    0x8(%ebp),%eax
  8017dc:	8a 00                	mov    (%eax),%al
  8017de:	3c 2f                	cmp    $0x2f,%al
  8017e0:	7e 19                	jle    8017fb <strtol+0xc2>
  8017e2:	8b 45 08             	mov    0x8(%ebp),%eax
  8017e5:	8a 00                	mov    (%eax),%al
  8017e7:	3c 39                	cmp    $0x39,%al
  8017e9:	7f 10                	jg     8017fb <strtol+0xc2>
			dig = *s - '0';
  8017eb:	8b 45 08             	mov    0x8(%ebp),%eax
  8017ee:	8a 00                	mov    (%eax),%al
  8017f0:	0f be c0             	movsbl %al,%eax
  8017f3:	83 e8 30             	sub    $0x30,%eax
  8017f6:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8017f9:	eb 42                	jmp    80183d <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  8017fb:	8b 45 08             	mov    0x8(%ebp),%eax
  8017fe:	8a 00                	mov    (%eax),%al
  801800:	3c 60                	cmp    $0x60,%al
  801802:	7e 19                	jle    80181d <strtol+0xe4>
  801804:	8b 45 08             	mov    0x8(%ebp),%eax
  801807:	8a 00                	mov    (%eax),%al
  801809:	3c 7a                	cmp    $0x7a,%al
  80180b:	7f 10                	jg     80181d <strtol+0xe4>
			dig = *s - 'a' + 10;
  80180d:	8b 45 08             	mov    0x8(%ebp),%eax
  801810:	8a 00                	mov    (%eax),%al
  801812:	0f be c0             	movsbl %al,%eax
  801815:	83 e8 57             	sub    $0x57,%eax
  801818:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80181b:	eb 20                	jmp    80183d <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  80181d:	8b 45 08             	mov    0x8(%ebp),%eax
  801820:	8a 00                	mov    (%eax),%al
  801822:	3c 40                	cmp    $0x40,%al
  801824:	7e 39                	jle    80185f <strtol+0x126>
  801826:	8b 45 08             	mov    0x8(%ebp),%eax
  801829:	8a 00                	mov    (%eax),%al
  80182b:	3c 5a                	cmp    $0x5a,%al
  80182d:	7f 30                	jg     80185f <strtol+0x126>
			dig = *s - 'A' + 10;
  80182f:	8b 45 08             	mov    0x8(%ebp),%eax
  801832:	8a 00                	mov    (%eax),%al
  801834:	0f be c0             	movsbl %al,%eax
  801837:	83 e8 37             	sub    $0x37,%eax
  80183a:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  80183d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801840:	3b 45 10             	cmp    0x10(%ebp),%eax
  801843:	7d 19                	jge    80185e <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  801845:	ff 45 08             	incl   0x8(%ebp)
  801848:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80184b:	0f af 45 10          	imul   0x10(%ebp),%eax
  80184f:	89 c2                	mov    %eax,%edx
  801851:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801854:	01 d0                	add    %edx,%eax
  801856:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  801859:	e9 7b ff ff ff       	jmp    8017d9 <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  80185e:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  80185f:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801863:	74 08                	je     80186d <strtol+0x134>
		*endptr = (char *) s;
  801865:	8b 45 0c             	mov    0xc(%ebp),%eax
  801868:	8b 55 08             	mov    0x8(%ebp),%edx
  80186b:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  80186d:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801871:	74 07                	je     80187a <strtol+0x141>
  801873:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801876:	f7 d8                	neg    %eax
  801878:	eb 03                	jmp    80187d <strtol+0x144>
  80187a:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  80187d:	c9                   	leave  
  80187e:	c3                   	ret    

0080187f <ltostr>:

void
ltostr(long value, char *str)
{
  80187f:	55                   	push   %ebp
  801880:	89 e5                	mov    %esp,%ebp
  801882:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  801885:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  80188c:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  801893:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801897:	79 13                	jns    8018ac <ltostr+0x2d>
	{
		neg = 1;
  801899:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  8018a0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8018a3:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  8018a6:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  8018a9:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  8018ac:	8b 45 08             	mov    0x8(%ebp),%eax
  8018af:	b9 0a 00 00 00       	mov    $0xa,%ecx
  8018b4:	99                   	cltd   
  8018b5:	f7 f9                	idiv   %ecx
  8018b7:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  8018ba:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8018bd:	8d 50 01             	lea    0x1(%eax),%edx
  8018c0:	89 55 f8             	mov    %edx,-0x8(%ebp)
  8018c3:	89 c2                	mov    %eax,%edx
  8018c5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8018c8:	01 d0                	add    %edx,%eax
  8018ca:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8018cd:	83 c2 30             	add    $0x30,%edx
  8018d0:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  8018d2:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8018d5:	b8 67 66 66 66       	mov    $0x66666667,%eax
  8018da:	f7 e9                	imul   %ecx
  8018dc:	c1 fa 02             	sar    $0x2,%edx
  8018df:	89 c8                	mov    %ecx,%eax
  8018e1:	c1 f8 1f             	sar    $0x1f,%eax
  8018e4:	29 c2                	sub    %eax,%edx
  8018e6:	89 d0                	mov    %edx,%eax
  8018e8:	89 45 08             	mov    %eax,0x8(%ebp)
	} while (value % 10 != 0);
  8018eb:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8018ee:	b8 67 66 66 66       	mov    $0x66666667,%eax
  8018f3:	f7 e9                	imul   %ecx
  8018f5:	c1 fa 02             	sar    $0x2,%edx
  8018f8:	89 c8                	mov    %ecx,%eax
  8018fa:	c1 f8 1f             	sar    $0x1f,%eax
  8018fd:	29 c2                	sub    %eax,%edx
  8018ff:	89 d0                	mov    %edx,%eax
  801901:	c1 e0 02             	shl    $0x2,%eax
  801904:	01 d0                	add    %edx,%eax
  801906:	01 c0                	add    %eax,%eax
  801908:	29 c1                	sub    %eax,%ecx
  80190a:	89 ca                	mov    %ecx,%edx
  80190c:	85 d2                	test   %edx,%edx
  80190e:	75 9c                	jne    8018ac <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  801910:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  801917:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80191a:	48                   	dec    %eax
  80191b:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  80191e:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801922:	74 3d                	je     801961 <ltostr+0xe2>
		start = 1 ;
  801924:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  80192b:	eb 34                	jmp    801961 <ltostr+0xe2>
	{
		char tmp = str[start] ;
  80192d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801930:	8b 45 0c             	mov    0xc(%ebp),%eax
  801933:	01 d0                	add    %edx,%eax
  801935:	8a 00                	mov    (%eax),%al
  801937:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  80193a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80193d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801940:	01 c2                	add    %eax,%edx
  801942:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  801945:	8b 45 0c             	mov    0xc(%ebp),%eax
  801948:	01 c8                	add    %ecx,%eax
  80194a:	8a 00                	mov    (%eax),%al
  80194c:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  80194e:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801951:	8b 45 0c             	mov    0xc(%ebp),%eax
  801954:	01 c2                	add    %eax,%edx
  801956:	8a 45 eb             	mov    -0x15(%ebp),%al
  801959:	88 02                	mov    %al,(%edx)
		start++ ;
  80195b:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  80195e:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  801961:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801964:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801967:	7c c4                	jl     80192d <ltostr+0xae>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  801969:	8b 55 f8             	mov    -0x8(%ebp),%edx
  80196c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80196f:	01 d0                	add    %edx,%eax
  801971:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  801974:	90                   	nop
  801975:	c9                   	leave  
  801976:	c3                   	ret    

00801977 <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  801977:	55                   	push   %ebp
  801978:	89 e5                	mov    %esp,%ebp
  80197a:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  80197d:	ff 75 08             	pushl  0x8(%ebp)
  801980:	e8 54 fa ff ff       	call   8013d9 <strlen>
  801985:	83 c4 04             	add    $0x4,%esp
  801988:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  80198b:	ff 75 0c             	pushl  0xc(%ebp)
  80198e:	e8 46 fa ff ff       	call   8013d9 <strlen>
  801993:	83 c4 04             	add    $0x4,%esp
  801996:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  801999:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  8019a0:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8019a7:	eb 17                	jmp    8019c0 <strcconcat+0x49>
		final[s] = str1[s] ;
  8019a9:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8019ac:	8b 45 10             	mov    0x10(%ebp),%eax
  8019af:	01 c2                	add    %eax,%edx
  8019b1:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  8019b4:	8b 45 08             	mov    0x8(%ebp),%eax
  8019b7:	01 c8                	add    %ecx,%eax
  8019b9:	8a 00                	mov    (%eax),%al
  8019bb:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  8019bd:	ff 45 fc             	incl   -0x4(%ebp)
  8019c0:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8019c3:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  8019c6:	7c e1                	jl     8019a9 <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  8019c8:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  8019cf:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  8019d6:	eb 1f                	jmp    8019f7 <strcconcat+0x80>
		final[s++] = str2[i] ;
  8019d8:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8019db:	8d 50 01             	lea    0x1(%eax),%edx
  8019de:	89 55 fc             	mov    %edx,-0x4(%ebp)
  8019e1:	89 c2                	mov    %eax,%edx
  8019e3:	8b 45 10             	mov    0x10(%ebp),%eax
  8019e6:	01 c2                	add    %eax,%edx
  8019e8:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  8019eb:	8b 45 0c             	mov    0xc(%ebp),%eax
  8019ee:	01 c8                	add    %ecx,%eax
  8019f0:	8a 00                	mov    (%eax),%al
  8019f2:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  8019f4:	ff 45 f8             	incl   -0x8(%ebp)
  8019f7:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8019fa:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8019fd:	7c d9                	jl     8019d8 <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  8019ff:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801a02:	8b 45 10             	mov    0x10(%ebp),%eax
  801a05:	01 d0                	add    %edx,%eax
  801a07:	c6 00 00             	movb   $0x0,(%eax)
}
  801a0a:	90                   	nop
  801a0b:	c9                   	leave  
  801a0c:	c3                   	ret    

00801a0d <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  801a0d:	55                   	push   %ebp
  801a0e:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  801a10:	8b 45 14             	mov    0x14(%ebp),%eax
  801a13:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  801a19:	8b 45 14             	mov    0x14(%ebp),%eax
  801a1c:	8b 00                	mov    (%eax),%eax
  801a1e:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801a25:	8b 45 10             	mov    0x10(%ebp),%eax
  801a28:	01 d0                	add    %edx,%eax
  801a2a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801a30:	eb 0c                	jmp    801a3e <strsplit+0x31>
			*string++ = 0;
  801a32:	8b 45 08             	mov    0x8(%ebp),%eax
  801a35:	8d 50 01             	lea    0x1(%eax),%edx
  801a38:	89 55 08             	mov    %edx,0x8(%ebp)
  801a3b:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801a3e:	8b 45 08             	mov    0x8(%ebp),%eax
  801a41:	8a 00                	mov    (%eax),%al
  801a43:	84 c0                	test   %al,%al
  801a45:	74 18                	je     801a5f <strsplit+0x52>
  801a47:	8b 45 08             	mov    0x8(%ebp),%eax
  801a4a:	8a 00                	mov    (%eax),%al
  801a4c:	0f be c0             	movsbl %al,%eax
  801a4f:	50                   	push   %eax
  801a50:	ff 75 0c             	pushl  0xc(%ebp)
  801a53:	e8 13 fb ff ff       	call   80156b <strchr>
  801a58:	83 c4 08             	add    $0x8,%esp
  801a5b:	85 c0                	test   %eax,%eax
  801a5d:	75 d3                	jne    801a32 <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  801a5f:	8b 45 08             	mov    0x8(%ebp),%eax
  801a62:	8a 00                	mov    (%eax),%al
  801a64:	84 c0                	test   %al,%al
  801a66:	74 5a                	je     801ac2 <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  801a68:	8b 45 14             	mov    0x14(%ebp),%eax
  801a6b:	8b 00                	mov    (%eax),%eax
  801a6d:	83 f8 0f             	cmp    $0xf,%eax
  801a70:	75 07                	jne    801a79 <strsplit+0x6c>
		{
			return 0;
  801a72:	b8 00 00 00 00       	mov    $0x0,%eax
  801a77:	eb 66                	jmp    801adf <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  801a79:	8b 45 14             	mov    0x14(%ebp),%eax
  801a7c:	8b 00                	mov    (%eax),%eax
  801a7e:	8d 48 01             	lea    0x1(%eax),%ecx
  801a81:	8b 55 14             	mov    0x14(%ebp),%edx
  801a84:	89 0a                	mov    %ecx,(%edx)
  801a86:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801a8d:	8b 45 10             	mov    0x10(%ebp),%eax
  801a90:	01 c2                	add    %eax,%edx
  801a92:	8b 45 08             	mov    0x8(%ebp),%eax
  801a95:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  801a97:	eb 03                	jmp    801a9c <strsplit+0x8f>
			string++;
  801a99:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  801a9c:	8b 45 08             	mov    0x8(%ebp),%eax
  801a9f:	8a 00                	mov    (%eax),%al
  801aa1:	84 c0                	test   %al,%al
  801aa3:	74 8b                	je     801a30 <strsplit+0x23>
  801aa5:	8b 45 08             	mov    0x8(%ebp),%eax
  801aa8:	8a 00                	mov    (%eax),%al
  801aaa:	0f be c0             	movsbl %al,%eax
  801aad:	50                   	push   %eax
  801aae:	ff 75 0c             	pushl  0xc(%ebp)
  801ab1:	e8 b5 fa ff ff       	call   80156b <strchr>
  801ab6:	83 c4 08             	add    $0x8,%esp
  801ab9:	85 c0                	test   %eax,%eax
  801abb:	74 dc                	je     801a99 <strsplit+0x8c>
			string++;
	}
  801abd:	e9 6e ff ff ff       	jmp    801a30 <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  801ac2:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  801ac3:	8b 45 14             	mov    0x14(%ebp),%eax
  801ac6:	8b 00                	mov    (%eax),%eax
  801ac8:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801acf:	8b 45 10             	mov    0x10(%ebp),%eax
  801ad2:	01 d0                	add    %edx,%eax
  801ad4:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  801ada:	b8 01 00 00 00       	mov    $0x1,%eax
}
  801adf:	c9                   	leave  
  801ae0:	c3                   	ret    

00801ae1 <InitializeUHeap>:
//============================== GIVEN FUNCTIONS ===================================//
//==================================================================================//

int FirstTimeFlag = 1;
void InitializeUHeap()
{
  801ae1:	55                   	push   %ebp
  801ae2:	89 e5                	mov    %esp,%ebp
  801ae4:	83 ec 08             	sub    $0x8,%esp
	if(FirstTimeFlag)
  801ae7:	a1 04 50 80 00       	mov    0x805004,%eax
  801aec:	85 c0                	test   %eax,%eax
  801aee:	74 1f                	je     801b0f <InitializeUHeap+0x2e>
	{
		initialize_dyn_block_system();
  801af0:	e8 1d 00 00 00       	call   801b12 <initialize_dyn_block_system>
		cprintf("DYNAMIC BLOCK SYSTEM IS INITIALIZED\n");
  801af5:	83 ec 0c             	sub    $0xc,%esp
  801af8:	68 e4 40 80 00       	push   $0x8040e4
  801afd:	e8 4f f0 ff ff       	call   800b51 <cprintf>
  801b02:	83 c4 10             	add    $0x10,%esp
#if UHP_USE_BUDDY
		initialize_buddy();
		cprintf("BUDDY SYSTEM IS INITIALIZED\n");
#endif
		FirstTimeFlag = 0;
  801b05:	c7 05 04 50 80 00 00 	movl   $0x0,0x805004
  801b0c:	00 00 00 
	}
}
  801b0f:	90                   	nop
  801b10:	c9                   	leave  
  801b11:	c3                   	ret    

00801b12 <initialize_dyn_block_system>:

//=================================
// [1] INITIALIZE DYNAMIC ALLOCATOR:
//=================================
void initialize_dyn_block_system()
{
  801b12:	55                   	push   %ebp
  801b13:	89 e5                	mov    %esp,%ebp
  801b15:	83 ec 28             	sub    $0x28,%esp
	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] initialize_dyn_block_system
	// your code is here, remove the panic and write your code
	//panic("initialize_dyn_block_system() is not implemented yet...!!");

	LIST_INIT(&AllocMemBlocksList);
  801b18:	c7 05 40 50 80 00 00 	movl   $0x0,0x805040
  801b1f:	00 00 00 
  801b22:	c7 05 44 50 80 00 00 	movl   $0x0,0x805044
  801b29:	00 00 00 
  801b2c:	c7 05 4c 50 80 00 00 	movl   $0x0,0x80504c
  801b33:	00 00 00 
	LIST_INIT(&FreeMemBlocksList);
  801b36:	c7 05 38 51 80 00 00 	movl   $0x0,0x805138
  801b3d:	00 00 00 
  801b40:	c7 05 3c 51 80 00 00 	movl   $0x0,0x80513c
  801b47:	00 00 00 
  801b4a:	c7 05 44 51 80 00 00 	movl   $0x0,0x805144
  801b51:	00 00 00 
	MAX_MEM_BLOCK_CNT = NUM_OF_UHEAP_PAGES;
  801b54:	c7 05 20 51 80 00 00 	movl   $0x20000,0x805120
  801b5b:	00 02 00 
	MemBlockNodes = (void*)USER_DYN_BLKS_ARRAY;
  801b5e:	c7 45 f4 00 00 e0 7f 	movl   $0x7fe00000,-0xc(%ebp)
  801b65:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801b68:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801b6d:	2d 00 10 00 00       	sub    $0x1000,%eax
  801b72:	a3 50 50 80 00       	mov    %eax,0x805050
	int size_of_block = sizeof(struct MemBlock);
  801b77:	c7 45 f0 10 00 00 00 	movl   $0x10,-0x10(%ebp)
	int size_all_struct = size_of_block*MAX_MEM_BLOCK_CNT;
  801b7e:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801b81:	a1 20 51 80 00       	mov    0x805120,%eax
  801b86:	0f af c2             	imul   %edx,%eax
  801b89:	89 45 ec             	mov    %eax,-0x14(%ebp)
	size_all_struct = ROUNDUP(size_all_struct, PAGE_SIZE);
  801b8c:	c7 45 e8 00 10 00 00 	movl   $0x1000,-0x18(%ebp)
  801b93:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801b96:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801b99:	01 d0                	add    %edx,%eax
  801b9b:	48                   	dec    %eax
  801b9c:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  801b9f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801ba2:	ba 00 00 00 00       	mov    $0x0,%edx
  801ba7:	f7 75 e8             	divl   -0x18(%ebp)
  801baa:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801bad:	29 d0                	sub    %edx,%eax
  801baf:	89 45 ec             	mov    %eax,-0x14(%ebp)
	sys_allocate_chunk(USER_DYN_BLKS_ARRAY, size_all_struct,PERM_USER| PERM_WRITEABLE);
  801bb2:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801bb5:	c7 45 e0 00 00 e0 7f 	movl   $0x7fe00000,-0x20(%ebp)
  801bbc:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801bbf:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
  801bc5:	81 ea 00 10 00 00    	sub    $0x1000,%edx
  801bcb:	83 ec 04             	sub    $0x4,%esp
  801bce:	6a 06                	push   $0x6
  801bd0:	50                   	push   %eax
  801bd1:	52                   	push   %edx
  801bd2:	e8 a1 05 00 00       	call   802178 <sys_allocate_chunk>
  801bd7:	83 c4 10             	add    $0x10,%esp
	initialize_MemBlocksList(MAX_MEM_BLOCK_CNT);
  801bda:	a1 20 51 80 00       	mov    0x805120,%eax
  801bdf:	83 ec 0c             	sub    $0xc,%esp
  801be2:	50                   	push   %eax
  801be3:	e8 16 0c 00 00       	call   8027fe <initialize_MemBlocksList>
  801be8:	83 c4 10             	add    $0x10,%esp
	struct MemBlock* ourBlock =LIST_LAST(&AvailableMemBlocksList);
  801beb:	a1 4c 51 80 00       	mov    0x80514c,%eax
  801bf0:	89 45 dc             	mov    %eax,-0x24(%ebp)
	LIST_REMOVE(&AvailableMemBlocksList,ourBlock);
  801bf3:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  801bf7:	75 14                	jne    801c0d <initialize_dyn_block_system+0xfb>
  801bf9:	83 ec 04             	sub    $0x4,%esp
  801bfc:	68 09 41 80 00       	push   $0x804109
  801c01:	6a 2d                	push   $0x2d
  801c03:	68 27 41 80 00       	push   $0x804127
  801c08:	e8 90 ec ff ff       	call   80089d <_panic>
  801c0d:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801c10:	8b 00                	mov    (%eax),%eax
  801c12:	85 c0                	test   %eax,%eax
  801c14:	74 10                	je     801c26 <initialize_dyn_block_system+0x114>
  801c16:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801c19:	8b 00                	mov    (%eax),%eax
  801c1b:	8b 55 dc             	mov    -0x24(%ebp),%edx
  801c1e:	8b 52 04             	mov    0x4(%edx),%edx
  801c21:	89 50 04             	mov    %edx,0x4(%eax)
  801c24:	eb 0b                	jmp    801c31 <initialize_dyn_block_system+0x11f>
  801c26:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801c29:	8b 40 04             	mov    0x4(%eax),%eax
  801c2c:	a3 4c 51 80 00       	mov    %eax,0x80514c
  801c31:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801c34:	8b 40 04             	mov    0x4(%eax),%eax
  801c37:	85 c0                	test   %eax,%eax
  801c39:	74 0f                	je     801c4a <initialize_dyn_block_system+0x138>
  801c3b:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801c3e:	8b 40 04             	mov    0x4(%eax),%eax
  801c41:	8b 55 dc             	mov    -0x24(%ebp),%edx
  801c44:	8b 12                	mov    (%edx),%edx
  801c46:	89 10                	mov    %edx,(%eax)
  801c48:	eb 0a                	jmp    801c54 <initialize_dyn_block_system+0x142>
  801c4a:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801c4d:	8b 00                	mov    (%eax),%eax
  801c4f:	a3 48 51 80 00       	mov    %eax,0x805148
  801c54:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801c57:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  801c5d:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801c60:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  801c67:	a1 54 51 80 00       	mov    0x805154,%eax
  801c6c:	48                   	dec    %eax
  801c6d:	a3 54 51 80 00       	mov    %eax,0x805154
	ourBlock->size = USER_HEAP_MAX-USER_HEAP_START;
  801c72:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801c75:	c7 40 0c 00 00 00 20 	movl   $0x20000000,0xc(%eax)
	ourBlock->sva=USER_HEAP_START;
  801c7c:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801c7f:	c7 40 08 00 00 00 80 	movl   $0x80000000,0x8(%eax)
	LIST_INSERT_TAIL(&FreeMemBlocksList, ourBlock);
  801c86:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  801c8a:	75 14                	jne    801ca0 <initialize_dyn_block_system+0x18e>
  801c8c:	83 ec 04             	sub    $0x4,%esp
  801c8f:	68 34 41 80 00       	push   $0x804134
  801c94:	6a 30                	push   $0x30
  801c96:	68 27 41 80 00       	push   $0x804127
  801c9b:	e8 fd eb ff ff       	call   80089d <_panic>
  801ca0:	8b 15 3c 51 80 00    	mov    0x80513c,%edx
  801ca6:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801ca9:	89 50 04             	mov    %edx,0x4(%eax)
  801cac:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801caf:	8b 40 04             	mov    0x4(%eax),%eax
  801cb2:	85 c0                	test   %eax,%eax
  801cb4:	74 0c                	je     801cc2 <initialize_dyn_block_system+0x1b0>
  801cb6:	a1 3c 51 80 00       	mov    0x80513c,%eax
  801cbb:	8b 55 dc             	mov    -0x24(%ebp),%edx
  801cbe:	89 10                	mov    %edx,(%eax)
  801cc0:	eb 08                	jmp    801cca <initialize_dyn_block_system+0x1b8>
  801cc2:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801cc5:	a3 38 51 80 00       	mov    %eax,0x805138
  801cca:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801ccd:	a3 3c 51 80 00       	mov    %eax,0x80513c
  801cd2:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801cd5:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  801cdb:	a1 44 51 80 00       	mov    0x805144,%eax
  801ce0:	40                   	inc    %eax
  801ce1:	a3 44 51 80 00       	mov    %eax,0x805144
	//[1] Initialize two lists (AllocMemBlocksList & FreeMemBlocksList) [Hint: use LIST_INIT()]
	//[2] Dynamically allocate the array of MemBlockNodes at VA USER_DYN_BLKS_ARRAY
	//	  (remember to set MAX_MEM_BLOCK_CNT with the chosen size of the array)
	//[3] Initialize AvailableMemBlocksList by filling it with the MemBlockNodes
	//[4] Insert a new MemBlock with the heap size into the FreeMemBlocksList
}
  801ce6:	90                   	nop
  801ce7:	c9                   	leave  
  801ce8:	c3                   	ret    

00801ce9 <malloc>:
//=================================
// [2] ALLOCATE SPACE IN USER HEAP:
//=================================

void* malloc(uint32 size)
{
  801ce9:	55                   	push   %ebp
  801cea:	89 e5                	mov    %esp,%ebp
  801cec:	83 ec 18             	sub    $0x18,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801cef:	e8 ed fd ff ff       	call   801ae1 <InitializeUHeap>
	if (size == 0) return NULL ;
  801cf4:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801cf8:	75 07                	jne    801d01 <malloc+0x18>
  801cfa:	b8 00 00 00 00       	mov    $0x0,%eax
  801cff:	eb 67                	jmp    801d68 <malloc+0x7f>

	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] malloc
	// your code is here, remove the panic and write your code
	//panic("malloc() is not implemented yet...!!");

	size = ROUNDUP(size, PAGE_SIZE);
  801d01:	c7 45 f4 00 10 00 00 	movl   $0x1000,-0xc(%ebp)
  801d08:	8b 55 08             	mov    0x8(%ebp),%edx
  801d0b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801d0e:	01 d0                	add    %edx,%eax
  801d10:	48                   	dec    %eax
  801d11:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801d14:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801d17:	ba 00 00 00 00       	mov    $0x0,%edx
  801d1c:	f7 75 f4             	divl   -0xc(%ebp)
  801d1f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801d22:	29 d0                	sub    %edx,%eax
  801d24:	89 45 08             	mov    %eax,0x8(%ebp)
	if(sys_isUHeapPlacementStrategyFIRSTFIT())
  801d27:	e8 1a 08 00 00       	call   802546 <sys_isUHeapPlacementStrategyFIRSTFIT>
  801d2c:	85 c0                	test   %eax,%eax
  801d2e:	74 33                	je     801d63 <malloc+0x7a>
	{
		struct MemBlock * myBlock = alloc_block_FF(size);
  801d30:	83 ec 0c             	sub    $0xc,%esp
  801d33:	ff 75 08             	pushl  0x8(%ebp)
  801d36:	e8 0c 0e 00 00       	call   802b47 <alloc_block_FF>
  801d3b:	83 c4 10             	add    $0x10,%esp
  801d3e:	89 45 ec             	mov    %eax,-0x14(%ebp)
		if(myBlock != NULL)
  801d41:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  801d45:	74 1c                	je     801d63 <malloc+0x7a>
		{
			insert_sorted_allocList(myBlock);
  801d47:	83 ec 0c             	sub    $0xc,%esp
  801d4a:	ff 75 ec             	pushl  -0x14(%ebp)
  801d4d:	e8 07 0c 00 00       	call   802959 <insert_sorted_allocList>
  801d52:	83 c4 10             	add    $0x10,%esp
			uint32 ptr = myBlock->sva;
  801d55:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801d58:	8b 40 08             	mov    0x8(%eax),%eax
  801d5b:	89 45 e8             	mov    %eax,-0x18(%ebp)
			return (void *)ptr;
  801d5e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801d61:	eb 05                	jmp    801d68 <malloc+0x7f>
		}
	}
	return NULL;
  801d63:	b8 00 00 00 00       	mov    $0x0,%eax
	//		to the required allocation size (space should be on 4 KB BOUNDARY)
	//	2) if no suitable space found, return NULL
	// 	3) Return pointer containing the virtual address of allocated space,
	//
	//Use sys_isUHeapPlacementStrategyFIRSTFIT()... to check the current strategy
}
  801d68:	c9                   	leave  
  801d69:	c3                   	ret    

00801d6a <free>:
//	We can use sys_free_user_mem(uint32 virtual_address, uint32 size); which
//		switches to the kernel mode, calls free_user_mem() in
//		"kern/mem/chunk_operations.c", then switch back to the user mode here
//	the free_user_mem function is empty, make sure to implement it.
void free(void* virtual_address)
{
  801d6a:	55                   	push   %ebp
  801d6b:	89 e5                	mov    %esp,%ebp
  801d6d:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] free
	// your code is here, remove the panic and write your code
	//panic("free() is not implemented yet...!!");

	uint32 virtualAddress = (uint32 )(virtual_address);
  801d70:	8b 45 08             	mov    0x8(%ebp),%eax
  801d73:	89 45 f4             	mov    %eax,-0xc(%ebp)
//	virtualAddress = ROUNDDOWN(virtualAddress, PAGE_SIZE);
	struct MemBlock * myBlock = find_block(&AllocMemBlocksList, virtualAddress);
  801d76:	83 ec 08             	sub    $0x8,%esp
  801d79:	ff 75 f4             	pushl  -0xc(%ebp)
  801d7c:	68 40 50 80 00       	push   $0x805040
  801d81:	e8 5b 0b 00 00       	call   8028e1 <find_block>
  801d86:	83 c4 10             	add    $0x10,%esp
  801d89:	89 45 f0             	mov    %eax,-0x10(%ebp)
//	cprintf ("ptr sva at free user side = %x \n", myBlock->sva);
	sys_free_user_mem(virtualAddress, myBlock->size);
  801d8c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801d8f:	8b 40 0c             	mov    0xc(%eax),%eax
  801d92:	83 ec 08             	sub    $0x8,%esp
  801d95:	50                   	push   %eax
  801d96:	ff 75 f4             	pushl  -0xc(%ebp)
  801d99:	e8 a2 03 00 00       	call   802140 <sys_free_user_mem>
  801d9e:	83 c4 10             	add    $0x10,%esp
	LIST_REMOVE(&AllocMemBlocksList, myBlock);
  801da1:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801da5:	75 14                	jne    801dbb <free+0x51>
  801da7:	83 ec 04             	sub    $0x4,%esp
  801daa:	68 09 41 80 00       	push   $0x804109
  801daf:	6a 76                	push   $0x76
  801db1:	68 27 41 80 00       	push   $0x804127
  801db6:	e8 e2 ea ff ff       	call   80089d <_panic>
  801dbb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801dbe:	8b 00                	mov    (%eax),%eax
  801dc0:	85 c0                	test   %eax,%eax
  801dc2:	74 10                	je     801dd4 <free+0x6a>
  801dc4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801dc7:	8b 00                	mov    (%eax),%eax
  801dc9:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801dcc:	8b 52 04             	mov    0x4(%edx),%edx
  801dcf:	89 50 04             	mov    %edx,0x4(%eax)
  801dd2:	eb 0b                	jmp    801ddf <free+0x75>
  801dd4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801dd7:	8b 40 04             	mov    0x4(%eax),%eax
  801dda:	a3 44 50 80 00       	mov    %eax,0x805044
  801ddf:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801de2:	8b 40 04             	mov    0x4(%eax),%eax
  801de5:	85 c0                	test   %eax,%eax
  801de7:	74 0f                	je     801df8 <free+0x8e>
  801de9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801dec:	8b 40 04             	mov    0x4(%eax),%eax
  801def:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801df2:	8b 12                	mov    (%edx),%edx
  801df4:	89 10                	mov    %edx,(%eax)
  801df6:	eb 0a                	jmp    801e02 <free+0x98>
  801df8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801dfb:	8b 00                	mov    (%eax),%eax
  801dfd:	a3 40 50 80 00       	mov    %eax,0x805040
  801e02:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801e05:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  801e0b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801e0e:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  801e15:	a1 4c 50 80 00       	mov    0x80504c,%eax
  801e1a:	48                   	dec    %eax
  801e1b:	a3 4c 50 80 00       	mov    %eax,0x80504c
	insert_sorted_with_merge_freeList(myBlock);
  801e20:	83 ec 0c             	sub    $0xc,%esp
  801e23:	ff 75 f0             	pushl  -0x10(%ebp)
  801e26:	e8 0b 14 00 00       	call   803236 <insert_sorted_with_merge_freeList>
  801e2b:	83 c4 10             	add    $0x10,%esp

	//you should get the size of the given allocation using its address
	//you need to call sys_free_user_mem()
	//refer to the project presentation and documentation for details
}
  801e2e:	90                   	nop
  801e2f:	c9                   	leave  
  801e30:	c3                   	ret    

00801e31 <smalloc>:

//=================================
// [4] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
  801e31:	55                   	push   %ebp
  801e32:	89 e5                	mov    %esp,%ebp
  801e34:	83 ec 28             	sub    $0x28,%esp
  801e37:	8b 45 10             	mov    0x10(%ebp),%eax
  801e3a:	88 45 e4             	mov    %al,-0x1c(%ebp)
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801e3d:	e8 9f fc ff ff       	call   801ae1 <InitializeUHeap>
	if (size == 0) return NULL ;
  801e42:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801e46:	75 0a                	jne    801e52 <smalloc+0x21>
  801e48:	b8 00 00 00 00       	mov    $0x0,%eax
  801e4d:	e9 8d 00 00 00       	jmp    801edf <smalloc+0xae>

	//This function should find the space of the required range
	// * ON 4KB BOUNDARY **** //
	//Use sys_isUHeapPlacementStrategyFIRSTFIT() to check the current strategy

	size = ROUNDUP(size, PAGE_SIZE);
  801e52:	c7 45 f4 00 10 00 00 	movl   $0x1000,-0xc(%ebp)
  801e59:	8b 55 0c             	mov    0xc(%ebp),%edx
  801e5c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e5f:	01 d0                	add    %edx,%eax
  801e61:	48                   	dec    %eax
  801e62:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801e65:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801e68:	ba 00 00 00 00       	mov    $0x0,%edx
  801e6d:	f7 75 f4             	divl   -0xc(%ebp)
  801e70:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801e73:	29 d0                	sub    %edx,%eax
  801e75:	89 45 0c             	mov    %eax,0xc(%ebp)
		if(sys_isUHeapPlacementStrategyFIRSTFIT())
  801e78:	e8 c9 06 00 00       	call   802546 <sys_isUHeapPlacementStrategyFIRSTFIT>
  801e7d:	85 c0                	test   %eax,%eax
  801e7f:	74 59                	je     801eda <smalloc+0xa9>
		{
			struct MemBlock * v1=NULL;
  801e81:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
			v1= alloc_block_FF(size);
  801e88:	83 ec 0c             	sub    $0xc,%esp
  801e8b:	ff 75 0c             	pushl  0xc(%ebp)
  801e8e:	e8 b4 0c 00 00       	call   802b47 <alloc_block_FF>
  801e93:	83 c4 10             	add    $0x10,%esp
  801e96:	89 45 ec             	mov    %eax,-0x14(%ebp)
			if(v1==NULL)
  801e99:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  801e9d:	75 07                	jne    801ea6 <smalloc+0x75>
			{
				return NULL;
  801e9f:	b8 00 00 00 00       	mov    $0x0,%eax
  801ea4:	eb 39                	jmp    801edf <smalloc+0xae>
			}
			else
			{
				int ret=sys_createSharedObject(sharedVarName,  size,  isWritable,(void*)v1->sva);
  801ea6:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801ea9:	8b 40 08             	mov    0x8(%eax),%eax
  801eac:	89 c2                	mov    %eax,%edx
  801eae:	0f b6 45 e4          	movzbl -0x1c(%ebp),%eax
  801eb2:	52                   	push   %edx
  801eb3:	50                   	push   %eax
  801eb4:	ff 75 0c             	pushl  0xc(%ebp)
  801eb7:	ff 75 08             	pushl  0x8(%ebp)
  801eba:	e8 0c 04 00 00       	call   8022cb <sys_createSharedObject>
  801ebf:	83 c4 10             	add    $0x10,%esp
  801ec2:	89 45 e8             	mov    %eax,-0x18(%ebp)
				if(ret>=0)
  801ec5:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  801ec9:	78 08                	js     801ed3 <smalloc+0xa2>
				{
					return (void*)v1->sva;
  801ecb:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801ece:	8b 40 08             	mov    0x8(%eax),%eax
  801ed1:	eb 0c                	jmp    801edf <smalloc+0xae>
				}
				else
				{
					return NULL;
  801ed3:	b8 00 00 00 00       	mov    $0x0,%eax
  801ed8:	eb 05                	jmp    801edf <smalloc+0xae>
				}
			}

		}
		return NULL;
  801eda:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801edf:	c9                   	leave  
  801ee0:	c3                   	ret    

00801ee1 <sget>:

//========================================
// [5] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  801ee1:	55                   	push   %ebp
  801ee2:	89 e5                	mov    %esp,%ebp
  801ee4:	83 ec 18             	sub    $0x18,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801ee7:	e8 f5 fb ff ff       	call   801ae1 <InitializeUHeap>

	//This function should find the space for sharing the variable
	// *** ON 4KB BOUNDARY ******** //

	//Use sys_isUHeapPlacementStrategyFIRSTFIT() to check the current strategy
	int ret=sys_getSizeOfSharedObject(ownerEnvID,sharedVarName);
  801eec:	83 ec 08             	sub    $0x8,%esp
  801eef:	ff 75 0c             	pushl  0xc(%ebp)
  801ef2:	ff 75 08             	pushl  0x8(%ebp)
  801ef5:	e8 fb 03 00 00       	call   8022f5 <sys_getSizeOfSharedObject>
  801efa:	83 c4 10             	add    $0x10,%esp
  801efd:	89 45 f4             	mov    %eax,-0xc(%ebp)
	if(ret==0)
  801f00:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801f04:	75 07                	jne    801f0d <sget+0x2c>
	{
		return NULL;
  801f06:	b8 00 00 00 00       	mov    $0x0,%eax
  801f0b:	eb 64                	jmp    801f71 <sget+0x90>
	}
	if(sys_isUHeapPlacementStrategyFIRSTFIT())
  801f0d:	e8 34 06 00 00       	call   802546 <sys_isUHeapPlacementStrategyFIRSTFIT>
  801f12:	85 c0                	test   %eax,%eax
  801f14:	74 56                	je     801f6c <sget+0x8b>
	{
		struct MemBlock * v1=NULL;
  801f16:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
		v1= alloc_block_FF(ret);
  801f1d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f20:	83 ec 0c             	sub    $0xc,%esp
  801f23:	50                   	push   %eax
  801f24:	e8 1e 0c 00 00       	call   802b47 <alloc_block_FF>
  801f29:	83 c4 10             	add    $0x10,%esp
  801f2c:	89 45 f0             	mov    %eax,-0x10(%ebp)
		if(v1==NULL)
  801f2f:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801f33:	75 07                	jne    801f3c <sget+0x5b>
		{
		return NULL;
  801f35:	b8 00 00 00 00       	mov    $0x0,%eax
  801f3a:	eb 35                	jmp    801f71 <sget+0x90>
	    }
		else
		{
			int ret1=sys_getSharedObject(ownerEnvID,sharedVarName,(void*)v1->sva);
  801f3c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801f3f:	8b 40 08             	mov    0x8(%eax),%eax
  801f42:	83 ec 04             	sub    $0x4,%esp
  801f45:	50                   	push   %eax
  801f46:	ff 75 0c             	pushl  0xc(%ebp)
  801f49:	ff 75 08             	pushl  0x8(%ebp)
  801f4c:	e8 c1 03 00 00       	call   802312 <sys_getSharedObject>
  801f51:	83 c4 10             	add    $0x10,%esp
  801f54:	89 45 ec             	mov    %eax,-0x14(%ebp)
			if(ret1>=0)
  801f57:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  801f5b:	78 08                	js     801f65 <sget+0x84>
			{
				return (void*)v1->sva;
  801f5d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801f60:	8b 40 08             	mov    0x8(%eax),%eax
  801f63:	eb 0c                	jmp    801f71 <sget+0x90>
			}
			else
			{
				return NULL;
  801f65:	b8 00 00 00 00       	mov    $0x0,%eax
  801f6a:	eb 05                	jmp    801f71 <sget+0x90>
			}
		}
	}
  return NULL;
  801f6c:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801f71:	c9                   	leave  
  801f72:	c3                   	ret    

00801f73 <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  801f73:	55                   	push   %ebp
  801f74:	89 e5                	mov    %esp,%ebp
  801f76:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801f79:	e8 63 fb ff ff       	call   801ae1 <InitializeUHeap>
	//==============================================================
	// [USER HEAP - USER SIDE] realloc
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  801f7e:	83 ec 04             	sub    $0x4,%esp
  801f81:	68 58 41 80 00       	push   $0x804158
  801f86:	68 0e 01 00 00       	push   $0x10e
  801f8b:	68 27 41 80 00       	push   $0x804127
  801f90:	e8 08 e9 ff ff       	call   80089d <_panic>

00801f95 <sfree>:
//	use sys_freeSharedObject(...); which switches to the kernel mode,
//	calls freeSharedObject(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the freeSharedObject() function is empty, make sure to implement it.

void sfree(void* virtual_address)
{
  801f95:	55                   	push   %ebp
  801f96:	89 e5                	mov    %esp,%ebp
  801f98:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS3 - BONUS] [SHARING - USER SIDE] sfree()

	// Write your code here, remove the panic and write your code
	panic("sfree() is not implemented yet...!!");
  801f9b:	83 ec 04             	sub    $0x4,%esp
  801f9e:	68 80 41 80 00       	push   $0x804180
  801fa3:	68 22 01 00 00       	push   $0x122
  801fa8:	68 27 41 80 00       	push   $0x804127
  801fad:	e8 eb e8 ff ff       	call   80089d <_panic>

00801fb2 <expand>:

//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//
void expand(uint32 newSize)
{
  801fb2:	55                   	push   %ebp
  801fb3:	89 e5                	mov    %esp,%ebp
  801fb5:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801fb8:	83 ec 04             	sub    $0x4,%esp
  801fbb:	68 a4 41 80 00       	push   $0x8041a4
  801fc0:	68 2d 01 00 00       	push   $0x12d
  801fc5:	68 27 41 80 00       	push   $0x804127
  801fca:	e8 ce e8 ff ff       	call   80089d <_panic>

00801fcf <shrink>:

}
void shrink(uint32 newSize)
{
  801fcf:	55                   	push   %ebp
  801fd0:	89 e5                	mov    %esp,%ebp
  801fd2:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801fd5:	83 ec 04             	sub    $0x4,%esp
  801fd8:	68 a4 41 80 00       	push   $0x8041a4
  801fdd:	68 32 01 00 00       	push   $0x132
  801fe2:	68 27 41 80 00       	push   $0x804127
  801fe7:	e8 b1 e8 ff ff       	call   80089d <_panic>

00801fec <freeHeap>:

}
void freeHeap(void* virtual_address)
{
  801fec:	55                   	push   %ebp
  801fed:	89 e5                	mov    %esp,%ebp
  801fef:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801ff2:	83 ec 04             	sub    $0x4,%esp
  801ff5:	68 a4 41 80 00       	push   $0x8041a4
  801ffa:	68 37 01 00 00       	push   $0x137
  801fff:	68 27 41 80 00       	push   $0x804127
  802004:	e8 94 e8 ff ff       	call   80089d <_panic>

00802009 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  802009:	55                   	push   %ebp
  80200a:	89 e5                	mov    %esp,%ebp
  80200c:	57                   	push   %edi
  80200d:	56                   	push   %esi
  80200e:	53                   	push   %ebx
  80200f:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  802012:	8b 45 08             	mov    0x8(%ebp),%eax
  802015:	8b 55 0c             	mov    0xc(%ebp),%edx
  802018:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80201b:	8b 5d 14             	mov    0x14(%ebp),%ebx
  80201e:	8b 7d 18             	mov    0x18(%ebp),%edi
  802021:	8b 75 1c             	mov    0x1c(%ebp),%esi
  802024:	cd 30                	int    $0x30
  802026:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  802029:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  80202c:	83 c4 10             	add    $0x10,%esp
  80202f:	5b                   	pop    %ebx
  802030:	5e                   	pop    %esi
  802031:	5f                   	pop    %edi
  802032:	5d                   	pop    %ebp
  802033:	c3                   	ret    

00802034 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  802034:	55                   	push   %ebp
  802035:	89 e5                	mov    %esp,%ebp
  802037:	83 ec 04             	sub    $0x4,%esp
  80203a:	8b 45 10             	mov    0x10(%ebp),%eax
  80203d:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  802040:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  802044:	8b 45 08             	mov    0x8(%ebp),%eax
  802047:	6a 00                	push   $0x0
  802049:	6a 00                	push   $0x0
  80204b:	52                   	push   %edx
  80204c:	ff 75 0c             	pushl  0xc(%ebp)
  80204f:	50                   	push   %eax
  802050:	6a 00                	push   $0x0
  802052:	e8 b2 ff ff ff       	call   802009 <syscall>
  802057:	83 c4 18             	add    $0x18,%esp
}
  80205a:	90                   	nop
  80205b:	c9                   	leave  
  80205c:	c3                   	ret    

0080205d <sys_cgetc>:

int
sys_cgetc(void)
{
  80205d:	55                   	push   %ebp
  80205e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  802060:	6a 00                	push   $0x0
  802062:	6a 00                	push   $0x0
  802064:	6a 00                	push   $0x0
  802066:	6a 00                	push   $0x0
  802068:	6a 00                	push   $0x0
  80206a:	6a 01                	push   $0x1
  80206c:	e8 98 ff ff ff       	call   802009 <syscall>
  802071:	83 c4 18             	add    $0x18,%esp
}
  802074:	c9                   	leave  
  802075:	c3                   	ret    

00802076 <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  802076:	55                   	push   %ebp
  802077:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  802079:	8b 55 0c             	mov    0xc(%ebp),%edx
  80207c:	8b 45 08             	mov    0x8(%ebp),%eax
  80207f:	6a 00                	push   $0x0
  802081:	6a 00                	push   $0x0
  802083:	6a 00                	push   $0x0
  802085:	52                   	push   %edx
  802086:	50                   	push   %eax
  802087:	6a 05                	push   $0x5
  802089:	e8 7b ff ff ff       	call   802009 <syscall>
  80208e:	83 c4 18             	add    $0x18,%esp
}
  802091:	c9                   	leave  
  802092:	c3                   	ret    

00802093 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  802093:	55                   	push   %ebp
  802094:	89 e5                	mov    %esp,%ebp
  802096:	56                   	push   %esi
  802097:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  802098:	8b 75 18             	mov    0x18(%ebp),%esi
  80209b:	8b 5d 14             	mov    0x14(%ebp),%ebx
  80209e:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8020a1:	8b 55 0c             	mov    0xc(%ebp),%edx
  8020a4:	8b 45 08             	mov    0x8(%ebp),%eax
  8020a7:	56                   	push   %esi
  8020a8:	53                   	push   %ebx
  8020a9:	51                   	push   %ecx
  8020aa:	52                   	push   %edx
  8020ab:	50                   	push   %eax
  8020ac:	6a 06                	push   $0x6
  8020ae:	e8 56 ff ff ff       	call   802009 <syscall>
  8020b3:	83 c4 18             	add    $0x18,%esp
}
  8020b6:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8020b9:	5b                   	pop    %ebx
  8020ba:	5e                   	pop    %esi
  8020bb:	5d                   	pop    %ebp
  8020bc:	c3                   	ret    

008020bd <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  8020bd:	55                   	push   %ebp
  8020be:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  8020c0:	8b 55 0c             	mov    0xc(%ebp),%edx
  8020c3:	8b 45 08             	mov    0x8(%ebp),%eax
  8020c6:	6a 00                	push   $0x0
  8020c8:	6a 00                	push   $0x0
  8020ca:	6a 00                	push   $0x0
  8020cc:	52                   	push   %edx
  8020cd:	50                   	push   %eax
  8020ce:	6a 07                	push   $0x7
  8020d0:	e8 34 ff ff ff       	call   802009 <syscall>
  8020d5:	83 c4 18             	add    $0x18,%esp
}
  8020d8:	c9                   	leave  
  8020d9:	c3                   	ret    

008020da <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  8020da:	55                   	push   %ebp
  8020db:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  8020dd:	6a 00                	push   $0x0
  8020df:	6a 00                	push   $0x0
  8020e1:	6a 00                	push   $0x0
  8020e3:	ff 75 0c             	pushl  0xc(%ebp)
  8020e6:	ff 75 08             	pushl  0x8(%ebp)
  8020e9:	6a 08                	push   $0x8
  8020eb:	e8 19 ff ff ff       	call   802009 <syscall>
  8020f0:	83 c4 18             	add    $0x18,%esp
}
  8020f3:	c9                   	leave  
  8020f4:	c3                   	ret    

008020f5 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  8020f5:	55                   	push   %ebp
  8020f6:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  8020f8:	6a 00                	push   $0x0
  8020fa:	6a 00                	push   $0x0
  8020fc:	6a 00                	push   $0x0
  8020fe:	6a 00                	push   $0x0
  802100:	6a 00                	push   $0x0
  802102:	6a 09                	push   $0x9
  802104:	e8 00 ff ff ff       	call   802009 <syscall>
  802109:	83 c4 18             	add    $0x18,%esp
}
  80210c:	c9                   	leave  
  80210d:	c3                   	ret    

0080210e <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  80210e:	55                   	push   %ebp
  80210f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  802111:	6a 00                	push   $0x0
  802113:	6a 00                	push   $0x0
  802115:	6a 00                	push   $0x0
  802117:	6a 00                	push   $0x0
  802119:	6a 00                	push   $0x0
  80211b:	6a 0a                	push   $0xa
  80211d:	e8 e7 fe ff ff       	call   802009 <syscall>
  802122:	83 c4 18             	add    $0x18,%esp
}
  802125:	c9                   	leave  
  802126:	c3                   	ret    

00802127 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  802127:	55                   	push   %ebp
  802128:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  80212a:	6a 00                	push   $0x0
  80212c:	6a 00                	push   $0x0
  80212e:	6a 00                	push   $0x0
  802130:	6a 00                	push   $0x0
  802132:	6a 00                	push   $0x0
  802134:	6a 0b                	push   $0xb
  802136:	e8 ce fe ff ff       	call   802009 <syscall>
  80213b:	83 c4 18             	add    $0x18,%esp
}
  80213e:	c9                   	leave  
  80213f:	c3                   	ret    

00802140 <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  802140:	55                   	push   %ebp
  802141:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  802143:	6a 00                	push   $0x0
  802145:	6a 00                	push   $0x0
  802147:	6a 00                	push   $0x0
  802149:	ff 75 0c             	pushl  0xc(%ebp)
  80214c:	ff 75 08             	pushl  0x8(%ebp)
  80214f:	6a 0f                	push   $0xf
  802151:	e8 b3 fe ff ff       	call   802009 <syscall>
  802156:	83 c4 18             	add    $0x18,%esp
	return;
  802159:	90                   	nop
}
  80215a:	c9                   	leave  
  80215b:	c3                   	ret    

0080215c <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  80215c:	55                   	push   %ebp
  80215d:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  80215f:	6a 00                	push   $0x0
  802161:	6a 00                	push   $0x0
  802163:	6a 00                	push   $0x0
  802165:	ff 75 0c             	pushl  0xc(%ebp)
  802168:	ff 75 08             	pushl  0x8(%ebp)
  80216b:	6a 10                	push   $0x10
  80216d:	e8 97 fe ff ff       	call   802009 <syscall>
  802172:	83 c4 18             	add    $0x18,%esp
	return ;
  802175:	90                   	nop
}
  802176:	c9                   	leave  
  802177:	c3                   	ret    

00802178 <sys_allocate_chunk>:

void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  802178:	55                   	push   %ebp
  802179:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  80217b:	6a 00                	push   $0x0
  80217d:	6a 00                	push   $0x0
  80217f:	ff 75 10             	pushl  0x10(%ebp)
  802182:	ff 75 0c             	pushl  0xc(%ebp)
  802185:	ff 75 08             	pushl  0x8(%ebp)
  802188:	6a 11                	push   $0x11
  80218a:	e8 7a fe ff ff       	call   802009 <syscall>
  80218f:	83 c4 18             	add    $0x18,%esp
	return ;
  802192:	90                   	nop
}
  802193:	c9                   	leave  
  802194:	c3                   	ret    

00802195 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  802195:	55                   	push   %ebp
  802196:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  802198:	6a 00                	push   $0x0
  80219a:	6a 00                	push   $0x0
  80219c:	6a 00                	push   $0x0
  80219e:	6a 00                	push   $0x0
  8021a0:	6a 00                	push   $0x0
  8021a2:	6a 0c                	push   $0xc
  8021a4:	e8 60 fe ff ff       	call   802009 <syscall>
  8021a9:	83 c4 18             	add    $0x18,%esp
}
  8021ac:	c9                   	leave  
  8021ad:	c3                   	ret    

008021ae <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  8021ae:	55                   	push   %ebp
  8021af:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  8021b1:	6a 00                	push   $0x0
  8021b3:	6a 00                	push   $0x0
  8021b5:	6a 00                	push   $0x0
  8021b7:	6a 00                	push   $0x0
  8021b9:	ff 75 08             	pushl  0x8(%ebp)
  8021bc:	6a 0d                	push   $0xd
  8021be:	e8 46 fe ff ff       	call   802009 <syscall>
  8021c3:	83 c4 18             	add    $0x18,%esp
}
  8021c6:	c9                   	leave  
  8021c7:	c3                   	ret    

008021c8 <sys_scarce_memory>:

void sys_scarce_memory()
{
  8021c8:	55                   	push   %ebp
  8021c9:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  8021cb:	6a 00                	push   $0x0
  8021cd:	6a 00                	push   $0x0
  8021cf:	6a 00                	push   $0x0
  8021d1:	6a 00                	push   $0x0
  8021d3:	6a 00                	push   $0x0
  8021d5:	6a 0e                	push   $0xe
  8021d7:	e8 2d fe ff ff       	call   802009 <syscall>
  8021dc:	83 c4 18             	add    $0x18,%esp
}
  8021df:	90                   	nop
  8021e0:	c9                   	leave  
  8021e1:	c3                   	ret    

008021e2 <sys_disable_interrupt>:

//NEW !! 2012...
void
sys_disable_interrupt()
{
  8021e2:	55                   	push   %ebp
  8021e3:	89 e5                	mov    %esp,%ebp
	syscall(SYS_disableINTR,0, 0, 0, 0, 0);
  8021e5:	6a 00                	push   $0x0
  8021e7:	6a 00                	push   $0x0
  8021e9:	6a 00                	push   $0x0
  8021eb:	6a 00                	push   $0x0
  8021ed:	6a 00                	push   $0x0
  8021ef:	6a 13                	push   $0x13
  8021f1:	e8 13 fe ff ff       	call   802009 <syscall>
  8021f6:	83 c4 18             	add    $0x18,%esp
}
  8021f9:	90                   	nop
  8021fa:	c9                   	leave  
  8021fb:	c3                   	ret    

008021fc <sys_enable_interrupt>:


void
sys_enable_interrupt()
{
  8021fc:	55                   	push   %ebp
  8021fd:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enableINTR,0, 0, 0, 0, 0);
  8021ff:	6a 00                	push   $0x0
  802201:	6a 00                	push   $0x0
  802203:	6a 00                	push   $0x0
  802205:	6a 00                	push   $0x0
  802207:	6a 00                	push   $0x0
  802209:	6a 14                	push   $0x14
  80220b:	e8 f9 fd ff ff       	call   802009 <syscall>
  802210:	83 c4 18             	add    $0x18,%esp
}
  802213:	90                   	nop
  802214:	c9                   	leave  
  802215:	c3                   	ret    

00802216 <sys_cputc>:


void
sys_cputc(const char c)
{
  802216:	55                   	push   %ebp
  802217:	89 e5                	mov    %esp,%ebp
  802219:	83 ec 04             	sub    $0x4,%esp
  80221c:	8b 45 08             	mov    0x8(%ebp),%eax
  80221f:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  802222:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  802226:	6a 00                	push   $0x0
  802228:	6a 00                	push   $0x0
  80222a:	6a 00                	push   $0x0
  80222c:	6a 00                	push   $0x0
  80222e:	50                   	push   %eax
  80222f:	6a 15                	push   $0x15
  802231:	e8 d3 fd ff ff       	call   802009 <syscall>
  802236:	83 c4 18             	add    $0x18,%esp
}
  802239:	90                   	nop
  80223a:	c9                   	leave  
  80223b:	c3                   	ret    

0080223c <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  80223c:	55                   	push   %ebp
  80223d:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  80223f:	6a 00                	push   $0x0
  802241:	6a 00                	push   $0x0
  802243:	6a 00                	push   $0x0
  802245:	6a 00                	push   $0x0
  802247:	6a 00                	push   $0x0
  802249:	6a 16                	push   $0x16
  80224b:	e8 b9 fd ff ff       	call   802009 <syscall>
  802250:	83 c4 18             	add    $0x18,%esp
}
  802253:	90                   	nop
  802254:	c9                   	leave  
  802255:	c3                   	ret    

00802256 <sys_createSemaphore>:

int
sys_createSemaphore(char* semaphoreName, uint32 initialValue)
{
  802256:	55                   	push   %ebp
  802257:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_semaphore,(uint32)semaphoreName, (uint32)initialValue, 0, 0, 0);
  802259:	8b 45 08             	mov    0x8(%ebp),%eax
  80225c:	6a 00                	push   $0x0
  80225e:	6a 00                	push   $0x0
  802260:	6a 00                	push   $0x0
  802262:	ff 75 0c             	pushl  0xc(%ebp)
  802265:	50                   	push   %eax
  802266:	6a 17                	push   $0x17
  802268:	e8 9c fd ff ff       	call   802009 <syscall>
  80226d:	83 c4 18             	add    $0x18,%esp
}
  802270:	c9                   	leave  
  802271:	c3                   	ret    

00802272 <sys_getSemaphoreValue>:

int
sys_getSemaphoreValue(int32 ownerEnvID, char* semaphoreName)
{
  802272:	55                   	push   %ebp
  802273:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_semaphore_value,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  802275:	8b 55 0c             	mov    0xc(%ebp),%edx
  802278:	8b 45 08             	mov    0x8(%ebp),%eax
  80227b:	6a 00                	push   $0x0
  80227d:	6a 00                	push   $0x0
  80227f:	6a 00                	push   $0x0
  802281:	52                   	push   %edx
  802282:	50                   	push   %eax
  802283:	6a 1a                	push   $0x1a
  802285:	e8 7f fd ff ff       	call   802009 <syscall>
  80228a:	83 c4 18             	add    $0x18,%esp
}
  80228d:	c9                   	leave  
  80228e:	c3                   	ret    

0080228f <sys_waitSemaphore>:

void
sys_waitSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  80228f:	55                   	push   %ebp
  802290:	89 e5                	mov    %esp,%ebp
	syscall(SYS_wait_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  802292:	8b 55 0c             	mov    0xc(%ebp),%edx
  802295:	8b 45 08             	mov    0x8(%ebp),%eax
  802298:	6a 00                	push   $0x0
  80229a:	6a 00                	push   $0x0
  80229c:	6a 00                	push   $0x0
  80229e:	52                   	push   %edx
  80229f:	50                   	push   %eax
  8022a0:	6a 18                	push   $0x18
  8022a2:	e8 62 fd ff ff       	call   802009 <syscall>
  8022a7:	83 c4 18             	add    $0x18,%esp
}
  8022aa:	90                   	nop
  8022ab:	c9                   	leave  
  8022ac:	c3                   	ret    

008022ad <sys_signalSemaphore>:

void
sys_signalSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  8022ad:	55                   	push   %ebp
  8022ae:	89 e5                	mov    %esp,%ebp
	syscall(SYS_signal_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  8022b0:	8b 55 0c             	mov    0xc(%ebp),%edx
  8022b3:	8b 45 08             	mov    0x8(%ebp),%eax
  8022b6:	6a 00                	push   $0x0
  8022b8:	6a 00                	push   $0x0
  8022ba:	6a 00                	push   $0x0
  8022bc:	52                   	push   %edx
  8022bd:	50                   	push   %eax
  8022be:	6a 19                	push   $0x19
  8022c0:	e8 44 fd ff ff       	call   802009 <syscall>
  8022c5:	83 c4 18             	add    $0x18,%esp
}
  8022c8:	90                   	nop
  8022c9:	c9                   	leave  
  8022ca:	c3                   	ret    

008022cb <sys_createSharedObject>:

int
sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  8022cb:	55                   	push   %ebp
  8022cc:	89 e5                	mov    %esp,%ebp
  8022ce:	83 ec 04             	sub    $0x4,%esp
  8022d1:	8b 45 10             	mov    0x10(%ebp),%eax
  8022d4:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  8022d7:	8b 4d 14             	mov    0x14(%ebp),%ecx
  8022da:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  8022de:	8b 45 08             	mov    0x8(%ebp),%eax
  8022e1:	6a 00                	push   $0x0
  8022e3:	51                   	push   %ecx
  8022e4:	52                   	push   %edx
  8022e5:	ff 75 0c             	pushl  0xc(%ebp)
  8022e8:	50                   	push   %eax
  8022e9:	6a 1b                	push   $0x1b
  8022eb:	e8 19 fd ff ff       	call   802009 <syscall>
  8022f0:	83 c4 18             	add    $0x18,%esp
}
  8022f3:	c9                   	leave  
  8022f4:	c3                   	ret    

008022f5 <sys_getSizeOfSharedObject>:

//2017:
int
sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  8022f5:	55                   	push   %ebp
  8022f6:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  8022f8:	8b 55 0c             	mov    0xc(%ebp),%edx
  8022fb:	8b 45 08             	mov    0x8(%ebp),%eax
  8022fe:	6a 00                	push   $0x0
  802300:	6a 00                	push   $0x0
  802302:	6a 00                	push   $0x0
  802304:	52                   	push   %edx
  802305:	50                   	push   %eax
  802306:	6a 1c                	push   $0x1c
  802308:	e8 fc fc ff ff       	call   802009 <syscall>
  80230d:	83 c4 18             	add    $0x18,%esp
}
  802310:	c9                   	leave  
  802311:	c3                   	ret    

00802312 <sys_getSharedObject>:
//==========

int
sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  802312:	55                   	push   %ebp
  802313:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  802315:	8b 4d 10             	mov    0x10(%ebp),%ecx
  802318:	8b 55 0c             	mov    0xc(%ebp),%edx
  80231b:	8b 45 08             	mov    0x8(%ebp),%eax
  80231e:	6a 00                	push   $0x0
  802320:	6a 00                	push   $0x0
  802322:	51                   	push   %ecx
  802323:	52                   	push   %edx
  802324:	50                   	push   %eax
  802325:	6a 1d                	push   $0x1d
  802327:	e8 dd fc ff ff       	call   802009 <syscall>
  80232c:	83 c4 18             	add    $0x18,%esp
}
  80232f:	c9                   	leave  
  802330:	c3                   	ret    

00802331 <sys_freeSharedObject>:

int
sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  802331:	55                   	push   %ebp
  802332:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  802334:	8b 55 0c             	mov    0xc(%ebp),%edx
  802337:	8b 45 08             	mov    0x8(%ebp),%eax
  80233a:	6a 00                	push   $0x0
  80233c:	6a 00                	push   $0x0
  80233e:	6a 00                	push   $0x0
  802340:	52                   	push   %edx
  802341:	50                   	push   %eax
  802342:	6a 1e                	push   $0x1e
  802344:	e8 c0 fc ff ff       	call   802009 <syscall>
  802349:	83 c4 18             	add    $0x18,%esp
}
  80234c:	c9                   	leave  
  80234d:	c3                   	ret    

0080234e <sys_getMaxShares>:

uint32 	sys_getMaxShares()
{
  80234e:	55                   	push   %ebp
  80234f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_max_shares,0, 0, 0, 0, 0);
  802351:	6a 00                	push   $0x0
  802353:	6a 00                	push   $0x0
  802355:	6a 00                	push   $0x0
  802357:	6a 00                	push   $0x0
  802359:	6a 00                	push   $0x0
  80235b:	6a 1f                	push   $0x1f
  80235d:	e8 a7 fc ff ff       	call   802009 <syscall>
  802362:	83 c4 18             	add    $0x18,%esp
}
  802365:	c9                   	leave  
  802366:	c3                   	ret    

00802367 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  802367:	55                   	push   %ebp
  802368:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  80236a:	8b 45 08             	mov    0x8(%ebp),%eax
  80236d:	6a 00                	push   $0x0
  80236f:	ff 75 14             	pushl  0x14(%ebp)
  802372:	ff 75 10             	pushl  0x10(%ebp)
  802375:	ff 75 0c             	pushl  0xc(%ebp)
  802378:	50                   	push   %eax
  802379:	6a 20                	push   $0x20
  80237b:	e8 89 fc ff ff       	call   802009 <syscall>
  802380:	83 c4 18             	add    $0x18,%esp
}
  802383:	c9                   	leave  
  802384:	c3                   	ret    

00802385 <sys_run_env>:

void
sys_run_env(int32 envId)
{
  802385:	55                   	push   %ebp
  802386:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  802388:	8b 45 08             	mov    0x8(%ebp),%eax
  80238b:	6a 00                	push   $0x0
  80238d:	6a 00                	push   $0x0
  80238f:	6a 00                	push   $0x0
  802391:	6a 00                	push   $0x0
  802393:	50                   	push   %eax
  802394:	6a 21                	push   $0x21
  802396:	e8 6e fc ff ff       	call   802009 <syscall>
  80239b:	83 c4 18             	add    $0x18,%esp
}
  80239e:	90                   	nop
  80239f:	c9                   	leave  
  8023a0:	c3                   	ret    

008023a1 <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  8023a1:	55                   	push   %ebp
  8023a2:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  8023a4:	8b 45 08             	mov    0x8(%ebp),%eax
  8023a7:	6a 00                	push   $0x0
  8023a9:	6a 00                	push   $0x0
  8023ab:	6a 00                	push   $0x0
  8023ad:	6a 00                	push   $0x0
  8023af:	50                   	push   %eax
  8023b0:	6a 22                	push   $0x22
  8023b2:	e8 52 fc ff ff       	call   802009 <syscall>
  8023b7:	83 c4 18             	add    $0x18,%esp
}
  8023ba:	c9                   	leave  
  8023bb:	c3                   	ret    

008023bc <sys_getenvid>:

int32 sys_getenvid(void)
{
  8023bc:	55                   	push   %ebp
  8023bd:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  8023bf:	6a 00                	push   $0x0
  8023c1:	6a 00                	push   $0x0
  8023c3:	6a 00                	push   $0x0
  8023c5:	6a 00                	push   $0x0
  8023c7:	6a 00                	push   $0x0
  8023c9:	6a 02                	push   $0x2
  8023cb:	e8 39 fc ff ff       	call   802009 <syscall>
  8023d0:	83 c4 18             	add    $0x18,%esp
}
  8023d3:	c9                   	leave  
  8023d4:	c3                   	ret    

008023d5 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  8023d5:	55                   	push   %ebp
  8023d6:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  8023d8:	6a 00                	push   $0x0
  8023da:	6a 00                	push   $0x0
  8023dc:	6a 00                	push   $0x0
  8023de:	6a 00                	push   $0x0
  8023e0:	6a 00                	push   $0x0
  8023e2:	6a 03                	push   $0x3
  8023e4:	e8 20 fc ff ff       	call   802009 <syscall>
  8023e9:	83 c4 18             	add    $0x18,%esp
}
  8023ec:	c9                   	leave  
  8023ed:	c3                   	ret    

008023ee <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  8023ee:	55                   	push   %ebp
  8023ef:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  8023f1:	6a 00                	push   $0x0
  8023f3:	6a 00                	push   $0x0
  8023f5:	6a 00                	push   $0x0
  8023f7:	6a 00                	push   $0x0
  8023f9:	6a 00                	push   $0x0
  8023fb:	6a 04                	push   $0x4
  8023fd:	e8 07 fc ff ff       	call   802009 <syscall>
  802402:	83 c4 18             	add    $0x18,%esp
}
  802405:	c9                   	leave  
  802406:	c3                   	ret    

00802407 <sys_exit_env>:


void sys_exit_env(void)
{
  802407:	55                   	push   %ebp
  802408:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  80240a:	6a 00                	push   $0x0
  80240c:	6a 00                	push   $0x0
  80240e:	6a 00                	push   $0x0
  802410:	6a 00                	push   $0x0
  802412:	6a 00                	push   $0x0
  802414:	6a 23                	push   $0x23
  802416:	e8 ee fb ff ff       	call   802009 <syscall>
  80241b:	83 c4 18             	add    $0x18,%esp
}
  80241e:	90                   	nop
  80241f:	c9                   	leave  
  802420:	c3                   	ret    

00802421 <sys_get_virtual_time>:


struct uint64
sys_get_virtual_time()
{
  802421:	55                   	push   %ebp
  802422:	89 e5                	mov    %esp,%ebp
  802424:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  802427:	8d 45 f8             	lea    -0x8(%ebp),%eax
  80242a:	8d 50 04             	lea    0x4(%eax),%edx
  80242d:	8d 45 f8             	lea    -0x8(%ebp),%eax
  802430:	6a 00                	push   $0x0
  802432:	6a 00                	push   $0x0
  802434:	6a 00                	push   $0x0
  802436:	52                   	push   %edx
  802437:	50                   	push   %eax
  802438:	6a 24                	push   $0x24
  80243a:	e8 ca fb ff ff       	call   802009 <syscall>
  80243f:	83 c4 18             	add    $0x18,%esp
	return result;
  802442:	8b 4d 08             	mov    0x8(%ebp),%ecx
  802445:	8b 45 f8             	mov    -0x8(%ebp),%eax
  802448:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80244b:	89 01                	mov    %eax,(%ecx)
  80244d:	89 51 04             	mov    %edx,0x4(%ecx)
}
  802450:	8b 45 08             	mov    0x8(%ebp),%eax
  802453:	c9                   	leave  
  802454:	c2 04 00             	ret    $0x4

00802457 <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  802457:	55                   	push   %ebp
  802458:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  80245a:	6a 00                	push   $0x0
  80245c:	6a 00                	push   $0x0
  80245e:	ff 75 10             	pushl  0x10(%ebp)
  802461:	ff 75 0c             	pushl  0xc(%ebp)
  802464:	ff 75 08             	pushl  0x8(%ebp)
  802467:	6a 12                	push   $0x12
  802469:	e8 9b fb ff ff       	call   802009 <syscall>
  80246e:	83 c4 18             	add    $0x18,%esp
	return ;
  802471:	90                   	nop
}
  802472:	c9                   	leave  
  802473:	c3                   	ret    

00802474 <sys_rcr2>:
uint32 sys_rcr2()
{
  802474:	55                   	push   %ebp
  802475:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  802477:	6a 00                	push   $0x0
  802479:	6a 00                	push   $0x0
  80247b:	6a 00                	push   $0x0
  80247d:	6a 00                	push   $0x0
  80247f:	6a 00                	push   $0x0
  802481:	6a 25                	push   $0x25
  802483:	e8 81 fb ff ff       	call   802009 <syscall>
  802488:	83 c4 18             	add    $0x18,%esp
}
  80248b:	c9                   	leave  
  80248c:	c3                   	ret    

0080248d <sys_bypassPageFault>:
void sys_bypassPageFault(uint8 instrLength)
{
  80248d:	55                   	push   %ebp
  80248e:	89 e5                	mov    %esp,%ebp
  802490:	83 ec 04             	sub    $0x4,%esp
  802493:	8b 45 08             	mov    0x8(%ebp),%eax
  802496:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  802499:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  80249d:	6a 00                	push   $0x0
  80249f:	6a 00                	push   $0x0
  8024a1:	6a 00                	push   $0x0
  8024a3:	6a 00                	push   $0x0
  8024a5:	50                   	push   %eax
  8024a6:	6a 26                	push   $0x26
  8024a8:	e8 5c fb ff ff       	call   802009 <syscall>
  8024ad:	83 c4 18             	add    $0x18,%esp
	return ;
  8024b0:	90                   	nop
}
  8024b1:	c9                   	leave  
  8024b2:	c3                   	ret    

008024b3 <rsttst>:
void rsttst()
{
  8024b3:	55                   	push   %ebp
  8024b4:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  8024b6:	6a 00                	push   $0x0
  8024b8:	6a 00                	push   $0x0
  8024ba:	6a 00                	push   $0x0
  8024bc:	6a 00                	push   $0x0
  8024be:	6a 00                	push   $0x0
  8024c0:	6a 28                	push   $0x28
  8024c2:	e8 42 fb ff ff       	call   802009 <syscall>
  8024c7:	83 c4 18             	add    $0x18,%esp
	return ;
  8024ca:	90                   	nop
}
  8024cb:	c9                   	leave  
  8024cc:	c3                   	ret    

008024cd <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  8024cd:	55                   	push   %ebp
  8024ce:	89 e5                	mov    %esp,%ebp
  8024d0:	83 ec 04             	sub    $0x4,%esp
  8024d3:	8b 45 14             	mov    0x14(%ebp),%eax
  8024d6:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  8024d9:	8b 55 18             	mov    0x18(%ebp),%edx
  8024dc:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  8024e0:	52                   	push   %edx
  8024e1:	50                   	push   %eax
  8024e2:	ff 75 10             	pushl  0x10(%ebp)
  8024e5:	ff 75 0c             	pushl  0xc(%ebp)
  8024e8:	ff 75 08             	pushl  0x8(%ebp)
  8024eb:	6a 27                	push   $0x27
  8024ed:	e8 17 fb ff ff       	call   802009 <syscall>
  8024f2:	83 c4 18             	add    $0x18,%esp
	return ;
  8024f5:	90                   	nop
}
  8024f6:	c9                   	leave  
  8024f7:	c3                   	ret    

008024f8 <chktst>:
void chktst(uint32 n)
{
  8024f8:	55                   	push   %ebp
  8024f9:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  8024fb:	6a 00                	push   $0x0
  8024fd:	6a 00                	push   $0x0
  8024ff:	6a 00                	push   $0x0
  802501:	6a 00                	push   $0x0
  802503:	ff 75 08             	pushl  0x8(%ebp)
  802506:	6a 29                	push   $0x29
  802508:	e8 fc fa ff ff       	call   802009 <syscall>
  80250d:	83 c4 18             	add    $0x18,%esp
	return ;
  802510:	90                   	nop
}
  802511:	c9                   	leave  
  802512:	c3                   	ret    

00802513 <inctst>:

void inctst()
{
  802513:	55                   	push   %ebp
  802514:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  802516:	6a 00                	push   $0x0
  802518:	6a 00                	push   $0x0
  80251a:	6a 00                	push   $0x0
  80251c:	6a 00                	push   $0x0
  80251e:	6a 00                	push   $0x0
  802520:	6a 2a                	push   $0x2a
  802522:	e8 e2 fa ff ff       	call   802009 <syscall>
  802527:	83 c4 18             	add    $0x18,%esp
	return ;
  80252a:	90                   	nop
}
  80252b:	c9                   	leave  
  80252c:	c3                   	ret    

0080252d <gettst>:
uint32 gettst()
{
  80252d:	55                   	push   %ebp
  80252e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  802530:	6a 00                	push   $0x0
  802532:	6a 00                	push   $0x0
  802534:	6a 00                	push   $0x0
  802536:	6a 00                	push   $0x0
  802538:	6a 00                	push   $0x0
  80253a:	6a 2b                	push   $0x2b
  80253c:	e8 c8 fa ff ff       	call   802009 <syscall>
  802541:	83 c4 18             	add    $0x18,%esp
}
  802544:	c9                   	leave  
  802545:	c3                   	ret    

00802546 <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  802546:	55                   	push   %ebp
  802547:	89 e5                	mov    %esp,%ebp
  802549:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  80254c:	6a 00                	push   $0x0
  80254e:	6a 00                	push   $0x0
  802550:	6a 00                	push   $0x0
  802552:	6a 00                	push   $0x0
  802554:	6a 00                	push   $0x0
  802556:	6a 2c                	push   $0x2c
  802558:	e8 ac fa ff ff       	call   802009 <syscall>
  80255d:	83 c4 18             	add    $0x18,%esp
  802560:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  802563:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  802567:	75 07                	jne    802570 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  802569:	b8 01 00 00 00       	mov    $0x1,%eax
  80256e:	eb 05                	jmp    802575 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  802570:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802575:	c9                   	leave  
  802576:	c3                   	ret    

00802577 <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  802577:	55                   	push   %ebp
  802578:	89 e5                	mov    %esp,%ebp
  80257a:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  80257d:	6a 00                	push   $0x0
  80257f:	6a 00                	push   $0x0
  802581:	6a 00                	push   $0x0
  802583:	6a 00                	push   $0x0
  802585:	6a 00                	push   $0x0
  802587:	6a 2c                	push   $0x2c
  802589:	e8 7b fa ff ff       	call   802009 <syscall>
  80258e:	83 c4 18             	add    $0x18,%esp
  802591:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  802594:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  802598:	75 07                	jne    8025a1 <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  80259a:	b8 01 00 00 00       	mov    $0x1,%eax
  80259f:	eb 05                	jmp    8025a6 <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  8025a1:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8025a6:	c9                   	leave  
  8025a7:	c3                   	ret    

008025a8 <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  8025a8:	55                   	push   %ebp
  8025a9:	89 e5                	mov    %esp,%ebp
  8025ab:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8025ae:	6a 00                	push   $0x0
  8025b0:	6a 00                	push   $0x0
  8025b2:	6a 00                	push   $0x0
  8025b4:	6a 00                	push   $0x0
  8025b6:	6a 00                	push   $0x0
  8025b8:	6a 2c                	push   $0x2c
  8025ba:	e8 4a fa ff ff       	call   802009 <syscall>
  8025bf:	83 c4 18             	add    $0x18,%esp
  8025c2:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  8025c5:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  8025c9:	75 07                	jne    8025d2 <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  8025cb:	b8 01 00 00 00       	mov    $0x1,%eax
  8025d0:	eb 05                	jmp    8025d7 <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  8025d2:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8025d7:	c9                   	leave  
  8025d8:	c3                   	ret    

008025d9 <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  8025d9:	55                   	push   %ebp
  8025da:	89 e5                	mov    %esp,%ebp
  8025dc:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8025df:	6a 00                	push   $0x0
  8025e1:	6a 00                	push   $0x0
  8025e3:	6a 00                	push   $0x0
  8025e5:	6a 00                	push   $0x0
  8025e7:	6a 00                	push   $0x0
  8025e9:	6a 2c                	push   $0x2c
  8025eb:	e8 19 fa ff ff       	call   802009 <syscall>
  8025f0:	83 c4 18             	add    $0x18,%esp
  8025f3:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  8025f6:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  8025fa:	75 07                	jne    802603 <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  8025fc:	b8 01 00 00 00       	mov    $0x1,%eax
  802601:	eb 05                	jmp    802608 <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  802603:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802608:	c9                   	leave  
  802609:	c3                   	ret    

0080260a <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  80260a:	55                   	push   %ebp
  80260b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  80260d:	6a 00                	push   $0x0
  80260f:	6a 00                	push   $0x0
  802611:	6a 00                	push   $0x0
  802613:	6a 00                	push   $0x0
  802615:	ff 75 08             	pushl  0x8(%ebp)
  802618:	6a 2d                	push   $0x2d
  80261a:	e8 ea f9 ff ff       	call   802009 <syscall>
  80261f:	83 c4 18             	add    $0x18,%esp
	return ;
  802622:	90                   	nop
}
  802623:	c9                   	leave  
  802624:	c3                   	ret    

00802625 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  802625:	55                   	push   %ebp
  802626:	89 e5                	mov    %esp,%ebp
  802628:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  802629:	8b 5d 14             	mov    0x14(%ebp),%ebx
  80262c:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80262f:	8b 55 0c             	mov    0xc(%ebp),%edx
  802632:	8b 45 08             	mov    0x8(%ebp),%eax
  802635:	6a 00                	push   $0x0
  802637:	53                   	push   %ebx
  802638:	51                   	push   %ecx
  802639:	52                   	push   %edx
  80263a:	50                   	push   %eax
  80263b:	6a 2e                	push   $0x2e
  80263d:	e8 c7 f9 ff ff       	call   802009 <syscall>
  802642:	83 c4 18             	add    $0x18,%esp
}
  802645:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802648:	c9                   	leave  
  802649:	c3                   	ret    

0080264a <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  80264a:	55                   	push   %ebp
  80264b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  80264d:	8b 55 0c             	mov    0xc(%ebp),%edx
  802650:	8b 45 08             	mov    0x8(%ebp),%eax
  802653:	6a 00                	push   $0x0
  802655:	6a 00                	push   $0x0
  802657:	6a 00                	push   $0x0
  802659:	52                   	push   %edx
  80265a:	50                   	push   %eax
  80265b:	6a 2f                	push   $0x2f
  80265d:	e8 a7 f9 ff ff       	call   802009 <syscall>
  802662:	83 c4 18             	add    $0x18,%esp
}
  802665:	c9                   	leave  
  802666:	c3                   	ret    

00802667 <print_mem_block_lists>:
//===========================
// PRINT MEM BLOCK LISTS:
//===========================

void print_mem_block_lists()
{
  802667:	55                   	push   %ebp
  802668:	89 e5                	mov    %esp,%ebp
  80266a:	83 ec 18             	sub    $0x18,%esp
	cprintf("\n=========================================\n");
  80266d:	83 ec 0c             	sub    $0xc,%esp
  802670:	68 b4 41 80 00       	push   $0x8041b4
  802675:	e8 d7 e4 ff ff       	call   800b51 <cprintf>
  80267a:	83 c4 10             	add    $0x10,%esp
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
  80267d:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nFreeMemBlocksList:\n");
  802684:	83 ec 0c             	sub    $0xc,%esp
  802687:	68 e0 41 80 00       	push   $0x8041e0
  80268c:	e8 c0 e4 ff ff       	call   800b51 <cprintf>
  802691:	83 c4 10             	add    $0x10,%esp
	uint8 sorted = 1 ;
  802694:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &FreeMemBlocksList)
  802698:	a1 38 51 80 00       	mov    0x805138,%eax
  80269d:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8026a0:	eb 56                	jmp    8026f8 <print_mem_block_lists+0x91>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  8026a2:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8026a6:	74 1c                	je     8026c4 <print_mem_block_lists+0x5d>
  8026a8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026ab:	8b 50 08             	mov    0x8(%eax),%edx
  8026ae:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8026b1:	8b 48 08             	mov    0x8(%eax),%ecx
  8026b4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8026b7:	8b 40 0c             	mov    0xc(%eax),%eax
  8026ba:	01 c8                	add    %ecx,%eax
  8026bc:	39 c2                	cmp    %eax,%edx
  8026be:	73 04                	jae    8026c4 <print_mem_block_lists+0x5d>
			sorted = 0 ;
  8026c0:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  8026c4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026c7:	8b 50 08             	mov    0x8(%eax),%edx
  8026ca:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026cd:	8b 40 0c             	mov    0xc(%eax),%eax
  8026d0:	01 c2                	add    %eax,%edx
  8026d2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026d5:	8b 40 08             	mov    0x8(%eax),%eax
  8026d8:	83 ec 04             	sub    $0x4,%esp
  8026db:	52                   	push   %edx
  8026dc:	50                   	push   %eax
  8026dd:	68 f5 41 80 00       	push   $0x8041f5
  8026e2:	e8 6a e4 ff ff       	call   800b51 <cprintf>
  8026e7:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  8026ea:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026ed:	89 45 f0             	mov    %eax,-0x10(%ebp)
	cprintf("\n=========================================\n");
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
	cprintf("\nFreeMemBlocksList:\n");
	uint8 sorted = 1 ;
	LIST_FOREACH(blk, &FreeMemBlocksList)
  8026f0:	a1 40 51 80 00       	mov    0x805140,%eax
  8026f5:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8026f8:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8026fc:	74 07                	je     802705 <print_mem_block_lists+0x9e>
  8026fe:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802701:	8b 00                	mov    (%eax),%eax
  802703:	eb 05                	jmp    80270a <print_mem_block_lists+0xa3>
  802705:	b8 00 00 00 00       	mov    $0x0,%eax
  80270a:	a3 40 51 80 00       	mov    %eax,0x805140
  80270f:	a1 40 51 80 00       	mov    0x805140,%eax
  802714:	85 c0                	test   %eax,%eax
  802716:	75 8a                	jne    8026a2 <print_mem_block_lists+0x3b>
  802718:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80271c:	75 84                	jne    8026a2 <print_mem_block_lists+0x3b>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;
  80271e:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  802722:	75 10                	jne    802734 <print_mem_block_lists+0xcd>
  802724:	83 ec 0c             	sub    $0xc,%esp
  802727:	68 04 42 80 00       	push   $0x804204
  80272c:	e8 20 e4 ff ff       	call   800b51 <cprintf>
  802731:	83 c4 10             	add    $0x10,%esp

	lastBlk = NULL ;
  802734:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nAllocMemBlocksList:\n");
  80273b:	83 ec 0c             	sub    $0xc,%esp
  80273e:	68 28 42 80 00       	push   $0x804228
  802743:	e8 09 e4 ff ff       	call   800b51 <cprintf>
  802748:	83 c4 10             	add    $0x10,%esp
	sorted = 1 ;
  80274b:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &AllocMemBlocksList)
  80274f:	a1 40 50 80 00       	mov    0x805040,%eax
  802754:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802757:	eb 56                	jmp    8027af <print_mem_block_lists+0x148>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  802759:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80275d:	74 1c                	je     80277b <print_mem_block_lists+0x114>
  80275f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802762:	8b 50 08             	mov    0x8(%eax),%edx
  802765:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802768:	8b 48 08             	mov    0x8(%eax),%ecx
  80276b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80276e:	8b 40 0c             	mov    0xc(%eax),%eax
  802771:	01 c8                	add    %ecx,%eax
  802773:	39 c2                	cmp    %eax,%edx
  802775:	73 04                	jae    80277b <print_mem_block_lists+0x114>
			sorted = 0 ;
  802777:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  80277b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80277e:	8b 50 08             	mov    0x8(%eax),%edx
  802781:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802784:	8b 40 0c             	mov    0xc(%eax),%eax
  802787:	01 c2                	add    %eax,%edx
  802789:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80278c:	8b 40 08             	mov    0x8(%eax),%eax
  80278f:	83 ec 04             	sub    $0x4,%esp
  802792:	52                   	push   %edx
  802793:	50                   	push   %eax
  802794:	68 f5 41 80 00       	push   $0x8041f5
  802799:	e8 b3 e3 ff ff       	call   800b51 <cprintf>
  80279e:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  8027a1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027a4:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;

	lastBlk = NULL ;
	cprintf("\nAllocMemBlocksList:\n");
	sorted = 1 ;
	LIST_FOREACH(blk, &AllocMemBlocksList)
  8027a7:	a1 48 50 80 00       	mov    0x805048,%eax
  8027ac:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8027af:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8027b3:	74 07                	je     8027bc <print_mem_block_lists+0x155>
  8027b5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027b8:	8b 00                	mov    (%eax),%eax
  8027ba:	eb 05                	jmp    8027c1 <print_mem_block_lists+0x15a>
  8027bc:	b8 00 00 00 00       	mov    $0x0,%eax
  8027c1:	a3 48 50 80 00       	mov    %eax,0x805048
  8027c6:	a1 48 50 80 00       	mov    0x805048,%eax
  8027cb:	85 c0                	test   %eax,%eax
  8027cd:	75 8a                	jne    802759 <print_mem_block_lists+0xf2>
  8027cf:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8027d3:	75 84                	jne    802759 <print_mem_block_lists+0xf2>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nAllocMemBlocksList is NOT SORTED!!\n") ;
  8027d5:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  8027d9:	75 10                	jne    8027eb <print_mem_block_lists+0x184>
  8027db:	83 ec 0c             	sub    $0xc,%esp
  8027de:	68 40 42 80 00       	push   $0x804240
  8027e3:	e8 69 e3 ff ff       	call   800b51 <cprintf>
  8027e8:	83 c4 10             	add    $0x10,%esp
	cprintf("\n=========================================\n");
  8027eb:	83 ec 0c             	sub    $0xc,%esp
  8027ee:	68 b4 41 80 00       	push   $0x8041b4
  8027f3:	e8 59 e3 ff ff       	call   800b51 <cprintf>
  8027f8:	83 c4 10             	add    $0x10,%esp

}
  8027fb:	90                   	nop
  8027fc:	c9                   	leave  
  8027fd:	c3                   	ret    

008027fe <initialize_MemBlocksList>:

//===============================
// [1] INITIALIZE AVAILABLE LIST:
//===============================
void initialize_MemBlocksList(uint32 numOfBlocks)
{
  8027fe:	55                   	push   %ebp
  8027ff:	89 e5                	mov    %esp,%ebp
  802801:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] initialize_MemBlocksList
	// Write your code here, remove the panic and write your code
	//panic("initialize_MemBlocksList() is not implemented yet...!!");
	uint32 n = numOfBlocks;
  802804:	8b 45 08             	mov    0x8(%ebp),%eax
  802807:	89 45 f0             	mov    %eax,-0x10(%ebp)

	LIST_INIT(&AvailableMemBlocksList);
  80280a:	c7 05 48 51 80 00 00 	movl   $0x0,0x805148
  802811:	00 00 00 
  802814:	c7 05 4c 51 80 00 00 	movl   $0x0,0x80514c
  80281b:	00 00 00 
  80281e:	c7 05 54 51 80 00 00 	movl   $0x0,0x805154
  802825:	00 00 00 
	for(int i = 0; i<n;i++)
  802828:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  80282f:	e9 9e 00 00 00       	jmp    8028d2 <initialize_MemBlocksList+0xd4>
	{
		LIST_INSERT_HEAD(&AvailableMemBlocksList, &(MemBlockNodes[i]));
  802834:	a1 50 50 80 00       	mov    0x805050,%eax
  802839:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80283c:	c1 e2 04             	shl    $0x4,%edx
  80283f:	01 d0                	add    %edx,%eax
  802841:	85 c0                	test   %eax,%eax
  802843:	75 14                	jne    802859 <initialize_MemBlocksList+0x5b>
  802845:	83 ec 04             	sub    $0x4,%esp
  802848:	68 68 42 80 00       	push   $0x804268
  80284d:	6a 47                	push   $0x47
  80284f:	68 8b 42 80 00       	push   $0x80428b
  802854:	e8 44 e0 ff ff       	call   80089d <_panic>
  802859:	a1 50 50 80 00       	mov    0x805050,%eax
  80285e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802861:	c1 e2 04             	shl    $0x4,%edx
  802864:	01 d0                	add    %edx,%eax
  802866:	8b 15 48 51 80 00    	mov    0x805148,%edx
  80286c:	89 10                	mov    %edx,(%eax)
  80286e:	8b 00                	mov    (%eax),%eax
  802870:	85 c0                	test   %eax,%eax
  802872:	74 18                	je     80288c <initialize_MemBlocksList+0x8e>
  802874:	a1 48 51 80 00       	mov    0x805148,%eax
  802879:	8b 15 50 50 80 00    	mov    0x805050,%edx
  80287f:	8b 4d f4             	mov    -0xc(%ebp),%ecx
  802882:	c1 e1 04             	shl    $0x4,%ecx
  802885:	01 ca                	add    %ecx,%edx
  802887:	89 50 04             	mov    %edx,0x4(%eax)
  80288a:	eb 12                	jmp    80289e <initialize_MemBlocksList+0xa0>
  80288c:	a1 50 50 80 00       	mov    0x805050,%eax
  802891:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802894:	c1 e2 04             	shl    $0x4,%edx
  802897:	01 d0                	add    %edx,%eax
  802899:	a3 4c 51 80 00       	mov    %eax,0x80514c
  80289e:	a1 50 50 80 00       	mov    0x805050,%eax
  8028a3:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8028a6:	c1 e2 04             	shl    $0x4,%edx
  8028a9:	01 d0                	add    %edx,%eax
  8028ab:	a3 48 51 80 00       	mov    %eax,0x805148
  8028b0:	a1 50 50 80 00       	mov    0x805050,%eax
  8028b5:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8028b8:	c1 e2 04             	shl    $0x4,%edx
  8028bb:	01 d0                	add    %edx,%eax
  8028bd:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8028c4:	a1 54 51 80 00       	mov    0x805154,%eax
  8028c9:	40                   	inc    %eax
  8028ca:	a3 54 51 80 00       	mov    %eax,0x805154
	// Write your code here, remove the panic and write your code
	//panic("initialize_MemBlocksList() is not implemented yet...!!");
	uint32 n = numOfBlocks;

	LIST_INIT(&AvailableMemBlocksList);
	for(int i = 0; i<n;i++)
  8028cf:	ff 45 f4             	incl   -0xc(%ebp)
  8028d2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028d5:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8028d8:	0f 82 56 ff ff ff    	jb     802834 <initialize_MemBlocksList+0x36>
	{
		LIST_INSERT_HEAD(&AvailableMemBlocksList, &(MemBlockNodes[i]));
	}
}
  8028de:	90                   	nop
  8028df:	c9                   	leave  
  8028e0:	c3                   	ret    

008028e1 <find_block>:

//===============================
// [2] FIND BLOCK:
//===============================
struct MemBlock *find_block(struct MemBlock_List *blockList, uint32 va)
{
  8028e1:	55                   	push   %ebp
  8028e2:	89 e5                	mov    %esp,%ebp
  8028e4:	83 ec 10             	sub    $0x10,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] find_block
	// Write your code here, remove the panic and write your code
	//panic("find_block() is not implemented yet...!!");
	uint32 virAddress = va;
  8028e7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8028ea:	89 45 f4             	mov    %eax,-0xc(%ebp)
	struct MemBlock* blk;
	int found = 0;
  8028ed:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	LIST_FOREACH(blk, &(AllocMemBlocksList))
  8028f4:	a1 40 50 80 00       	mov    0x805040,%eax
  8028f9:	89 45 fc             	mov    %eax,-0x4(%ebp)
  8028fc:	eb 23                	jmp    802921 <find_block+0x40>
	{
		if(blk->sva == virAddress)
  8028fe:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802901:	8b 40 08             	mov    0x8(%eax),%eax
  802904:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  802907:	75 09                	jne    802912 <find_block+0x31>
		{
			found = 1;
  802909:	c7 45 f8 01 00 00 00 	movl   $0x1,-0x8(%ebp)
			break;
  802910:	eb 35                	jmp    802947 <find_block+0x66>
		}
		else
		{
			found = 0;
  802912:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	//panic("find_block() is not implemented yet...!!");
	uint32 virAddress = va;
	struct MemBlock* blk;
	int found = 0;

	LIST_FOREACH(blk, &(AllocMemBlocksList))
  802919:	a1 48 50 80 00       	mov    0x805048,%eax
  80291e:	89 45 fc             	mov    %eax,-0x4(%ebp)
  802921:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  802925:	74 07                	je     80292e <find_block+0x4d>
  802927:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80292a:	8b 00                	mov    (%eax),%eax
  80292c:	eb 05                	jmp    802933 <find_block+0x52>
  80292e:	b8 00 00 00 00       	mov    $0x0,%eax
  802933:	a3 48 50 80 00       	mov    %eax,0x805048
  802938:	a1 48 50 80 00       	mov    0x805048,%eax
  80293d:	85 c0                	test   %eax,%eax
  80293f:	75 bd                	jne    8028fe <find_block+0x1d>
  802941:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  802945:	75 b7                	jne    8028fe <find_block+0x1d>
		{
			found = 0;
			continue;
		}
	}
	if(found == 1)
  802947:	83 7d f8 01          	cmpl   $0x1,-0x8(%ebp)
  80294b:	75 05                	jne    802952 <find_block+0x71>
	{
		return blk;
  80294d:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802950:	eb 05                	jmp    802957 <find_block+0x76>
	}
	else
	{
		return NULL;
  802952:	b8 00 00 00 00       	mov    $0x0,%eax
	}
}
  802957:	c9                   	leave  
  802958:	c3                   	ret    

00802959 <insert_sorted_allocList>:

//=========================================
// [3] INSERT BLOCK IN ALLOC LIST [SORTED]:
//=========================================
void insert_sorted_allocList(struct MemBlock *blockToInsert)
{
  802959:	55                   	push   %ebp
  80295a:	89 e5                	mov    %esp,%ebp
  80295c:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] insert_sorted_allocList
	// Write your code here, remove the panic and write your code
	//panic("insert_sorted_allocList() is not implemented yet...!!");
	struct MemBlock* blk;
	struct MemBlock* newblk = blockToInsert;
  80295f:	8b 45 08             	mov    0x8(%ebp),%eax
  802962:	89 45 f0             	mov    %eax,-0x10(%ebp)

	if((LIST_EMPTY(&AllocMemBlocksList)) || (newblk->sva < LIST_FIRST(&AllocMemBlocksList)->sva))
  802965:	a1 40 50 80 00       	mov    0x805040,%eax
  80296a:	85 c0                	test   %eax,%eax
  80296c:	74 12                	je     802980 <insert_sorted_allocList+0x27>
  80296e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802971:	8b 50 08             	mov    0x8(%eax),%edx
  802974:	a1 40 50 80 00       	mov    0x805040,%eax
  802979:	8b 40 08             	mov    0x8(%eax),%eax
  80297c:	39 c2                	cmp    %eax,%edx
  80297e:	73 65                	jae    8029e5 <insert_sorted_allocList+0x8c>
	{
		LIST_INSERT_HEAD(&(AllocMemBlocksList), newblk);
  802980:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802984:	75 14                	jne    80299a <insert_sorted_allocList+0x41>
  802986:	83 ec 04             	sub    $0x4,%esp
  802989:	68 68 42 80 00       	push   $0x804268
  80298e:	6a 7b                	push   $0x7b
  802990:	68 8b 42 80 00       	push   $0x80428b
  802995:	e8 03 df ff ff       	call   80089d <_panic>
  80299a:	8b 15 40 50 80 00    	mov    0x805040,%edx
  8029a0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8029a3:	89 10                	mov    %edx,(%eax)
  8029a5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8029a8:	8b 00                	mov    (%eax),%eax
  8029aa:	85 c0                	test   %eax,%eax
  8029ac:	74 0d                	je     8029bb <insert_sorted_allocList+0x62>
  8029ae:	a1 40 50 80 00       	mov    0x805040,%eax
  8029b3:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8029b6:	89 50 04             	mov    %edx,0x4(%eax)
  8029b9:	eb 08                	jmp    8029c3 <insert_sorted_allocList+0x6a>
  8029bb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8029be:	a3 44 50 80 00       	mov    %eax,0x805044
  8029c3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8029c6:	a3 40 50 80 00       	mov    %eax,0x805040
  8029cb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8029ce:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8029d5:	a1 4c 50 80 00       	mov    0x80504c,%eax
  8029da:	40                   	inc    %eax
  8029db:	a3 4c 50 80 00       	mov    %eax,0x80504c
  8029e0:	e9 5f 01 00 00       	jmp    802b44 <insert_sorted_allocList+0x1eb>
	}
	else if(newblk->sva > LIST_LAST(&AllocMemBlocksList)->sva)
  8029e5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8029e8:	8b 50 08             	mov    0x8(%eax),%edx
  8029eb:	a1 44 50 80 00       	mov    0x805044,%eax
  8029f0:	8b 40 08             	mov    0x8(%eax),%eax
  8029f3:	39 c2                	cmp    %eax,%edx
  8029f5:	76 65                	jbe    802a5c <insert_sorted_allocList+0x103>
	{
		LIST_INSERT_TAIL(&AllocMemBlocksList, newblk);
  8029f7:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8029fb:	75 14                	jne    802a11 <insert_sorted_allocList+0xb8>
  8029fd:	83 ec 04             	sub    $0x4,%esp
  802a00:	68 a4 42 80 00       	push   $0x8042a4
  802a05:	6a 7f                	push   $0x7f
  802a07:	68 8b 42 80 00       	push   $0x80428b
  802a0c:	e8 8c de ff ff       	call   80089d <_panic>
  802a11:	8b 15 44 50 80 00    	mov    0x805044,%edx
  802a17:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a1a:	89 50 04             	mov    %edx,0x4(%eax)
  802a1d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a20:	8b 40 04             	mov    0x4(%eax),%eax
  802a23:	85 c0                	test   %eax,%eax
  802a25:	74 0c                	je     802a33 <insert_sorted_allocList+0xda>
  802a27:	a1 44 50 80 00       	mov    0x805044,%eax
  802a2c:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802a2f:	89 10                	mov    %edx,(%eax)
  802a31:	eb 08                	jmp    802a3b <insert_sorted_allocList+0xe2>
  802a33:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a36:	a3 40 50 80 00       	mov    %eax,0x805040
  802a3b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a3e:	a3 44 50 80 00       	mov    %eax,0x805044
  802a43:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a46:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802a4c:	a1 4c 50 80 00       	mov    0x80504c,%eax
  802a51:	40                   	inc    %eax
  802a52:	a3 4c 50 80 00       	mov    %eax,0x80504c
				LIST_INSERT_AFTER(&AllocMemBlocksList, blk, newblk);
				break;
			}
		}
	}
}
  802a57:	e9 e8 00 00 00       	jmp    802b44 <insert_sorted_allocList+0x1eb>
	{
		LIST_INSERT_TAIL(&AllocMemBlocksList, newblk);
	}
	else
	{
		LIST_FOREACH(blk, &AllocMemBlocksList)
  802a5c:	a1 40 50 80 00       	mov    0x805040,%eax
  802a61:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802a64:	e9 ab 00 00 00       	jmp    802b14 <insert_sorted_allocList+0x1bb>
		{
			if(blk->prev_next_info.le_next != NULL && newblk->sva > blk->sva  && newblk->sva < blk->prev_next_info.le_next->sva)
  802a69:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a6c:	8b 00                	mov    (%eax),%eax
  802a6e:	85 c0                	test   %eax,%eax
  802a70:	0f 84 96 00 00 00    	je     802b0c <insert_sorted_allocList+0x1b3>
  802a76:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a79:	8b 50 08             	mov    0x8(%eax),%edx
  802a7c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a7f:	8b 40 08             	mov    0x8(%eax),%eax
  802a82:	39 c2                	cmp    %eax,%edx
  802a84:	0f 86 82 00 00 00    	jbe    802b0c <insert_sorted_allocList+0x1b3>
  802a8a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a8d:	8b 50 08             	mov    0x8(%eax),%edx
  802a90:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a93:	8b 00                	mov    (%eax),%eax
  802a95:	8b 40 08             	mov    0x8(%eax),%eax
  802a98:	39 c2                	cmp    %eax,%edx
  802a9a:	73 70                	jae    802b0c <insert_sorted_allocList+0x1b3>
			{
				LIST_INSERT_AFTER(&AllocMemBlocksList, blk, newblk);
  802a9c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802aa0:	74 06                	je     802aa8 <insert_sorted_allocList+0x14f>
  802aa2:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802aa6:	75 17                	jne    802abf <insert_sorted_allocList+0x166>
  802aa8:	83 ec 04             	sub    $0x4,%esp
  802aab:	68 c8 42 80 00       	push   $0x8042c8
  802ab0:	68 87 00 00 00       	push   $0x87
  802ab5:	68 8b 42 80 00       	push   $0x80428b
  802aba:	e8 de dd ff ff       	call   80089d <_panic>
  802abf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ac2:	8b 10                	mov    (%eax),%edx
  802ac4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ac7:	89 10                	mov    %edx,(%eax)
  802ac9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802acc:	8b 00                	mov    (%eax),%eax
  802ace:	85 c0                	test   %eax,%eax
  802ad0:	74 0b                	je     802add <insert_sorted_allocList+0x184>
  802ad2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ad5:	8b 00                	mov    (%eax),%eax
  802ad7:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802ada:	89 50 04             	mov    %edx,0x4(%eax)
  802add:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ae0:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802ae3:	89 10                	mov    %edx,(%eax)
  802ae5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ae8:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802aeb:	89 50 04             	mov    %edx,0x4(%eax)
  802aee:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802af1:	8b 00                	mov    (%eax),%eax
  802af3:	85 c0                	test   %eax,%eax
  802af5:	75 08                	jne    802aff <insert_sorted_allocList+0x1a6>
  802af7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802afa:	a3 44 50 80 00       	mov    %eax,0x805044
  802aff:	a1 4c 50 80 00       	mov    0x80504c,%eax
  802b04:	40                   	inc    %eax
  802b05:	a3 4c 50 80 00       	mov    %eax,0x80504c
				break;
  802b0a:	eb 38                	jmp    802b44 <insert_sorted_allocList+0x1eb>
	{
		LIST_INSERT_TAIL(&AllocMemBlocksList, newblk);
	}
	else
	{
		LIST_FOREACH(blk, &AllocMemBlocksList)
  802b0c:	a1 48 50 80 00       	mov    0x805048,%eax
  802b11:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802b14:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802b18:	74 07                	je     802b21 <insert_sorted_allocList+0x1c8>
  802b1a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b1d:	8b 00                	mov    (%eax),%eax
  802b1f:	eb 05                	jmp    802b26 <insert_sorted_allocList+0x1cd>
  802b21:	b8 00 00 00 00       	mov    $0x0,%eax
  802b26:	a3 48 50 80 00       	mov    %eax,0x805048
  802b2b:	a1 48 50 80 00       	mov    0x805048,%eax
  802b30:	85 c0                	test   %eax,%eax
  802b32:	0f 85 31 ff ff ff    	jne    802a69 <insert_sorted_allocList+0x110>
  802b38:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802b3c:	0f 85 27 ff ff ff    	jne    802a69 <insert_sorted_allocList+0x110>
				LIST_INSERT_AFTER(&AllocMemBlocksList, blk, newblk);
				break;
			}
		}
	}
}
  802b42:	eb 00                	jmp    802b44 <insert_sorted_allocList+0x1eb>
  802b44:	90                   	nop
  802b45:	c9                   	leave  
  802b46:	c3                   	ret    

00802b47 <alloc_block_FF>:

//=========================================
// [4] ALLOCATE BLOCK BY FIRST FIT:
//=========================================
struct MemBlock *alloc_block_FF(uint32 size)
{
  802b47:	55                   	push   %ebp
  802b48:	89 e5                	mov    %esp,%ebp
  802b4a:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_FF
	// Write your code here, remove the panic and write your code
	//panic("alloc_block_FF() is not implemented yet...!!");
	uint32 versize = size;
  802b4d:	8b 45 08             	mov    0x8(%ebp),%eax
  802b50:	89 45 f0             	mov    %eax,-0x10(%ebp)
	struct MemBlock* blk;
	struct MemBlock* newblk = LIST_FIRST(&AvailableMemBlocksList);
  802b53:	a1 48 51 80 00       	mov    0x805148,%eax
  802b58:	89 45 ec             	mov    %eax,-0x14(%ebp)

	LIST_FOREACH(blk,&FreeMemBlocksList)
  802b5b:	a1 38 51 80 00       	mov    0x805138,%eax
  802b60:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802b63:	e9 77 01 00 00       	jmp    802cdf <alloc_block_FF+0x198>
	{
		if(blk->size == versize)
  802b68:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b6b:	8b 40 0c             	mov    0xc(%eax),%eax
  802b6e:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  802b71:	0f 85 8a 00 00 00    	jne    802c01 <alloc_block_FF+0xba>
		{
			LIST_REMOVE(&FreeMemBlocksList,blk);
  802b77:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802b7b:	75 17                	jne    802b94 <alloc_block_FF+0x4d>
  802b7d:	83 ec 04             	sub    $0x4,%esp
  802b80:	68 fc 42 80 00       	push   $0x8042fc
  802b85:	68 9e 00 00 00       	push   $0x9e
  802b8a:	68 8b 42 80 00       	push   $0x80428b
  802b8f:	e8 09 dd ff ff       	call   80089d <_panic>
  802b94:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b97:	8b 00                	mov    (%eax),%eax
  802b99:	85 c0                	test   %eax,%eax
  802b9b:	74 10                	je     802bad <alloc_block_FF+0x66>
  802b9d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ba0:	8b 00                	mov    (%eax),%eax
  802ba2:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802ba5:	8b 52 04             	mov    0x4(%edx),%edx
  802ba8:	89 50 04             	mov    %edx,0x4(%eax)
  802bab:	eb 0b                	jmp    802bb8 <alloc_block_FF+0x71>
  802bad:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bb0:	8b 40 04             	mov    0x4(%eax),%eax
  802bb3:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802bb8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bbb:	8b 40 04             	mov    0x4(%eax),%eax
  802bbe:	85 c0                	test   %eax,%eax
  802bc0:	74 0f                	je     802bd1 <alloc_block_FF+0x8a>
  802bc2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bc5:	8b 40 04             	mov    0x4(%eax),%eax
  802bc8:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802bcb:	8b 12                	mov    (%edx),%edx
  802bcd:	89 10                	mov    %edx,(%eax)
  802bcf:	eb 0a                	jmp    802bdb <alloc_block_FF+0x94>
  802bd1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bd4:	8b 00                	mov    (%eax),%eax
  802bd6:	a3 38 51 80 00       	mov    %eax,0x805138
  802bdb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bde:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802be4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802be7:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802bee:	a1 44 51 80 00       	mov    0x805144,%eax
  802bf3:	48                   	dec    %eax
  802bf4:	a3 44 51 80 00       	mov    %eax,0x805144
			return blk;
  802bf9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bfc:	e9 11 01 00 00       	jmp    802d12 <alloc_block_FF+0x1cb>
		}
		else if(blk->size > versize)
  802c01:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c04:	8b 40 0c             	mov    0xc(%eax),%eax
  802c07:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  802c0a:	0f 86 c7 00 00 00    	jbe    802cd7 <alloc_block_FF+0x190>
		{
			LIST_REMOVE(&AvailableMemBlocksList,newblk);
  802c10:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802c14:	75 17                	jne    802c2d <alloc_block_FF+0xe6>
  802c16:	83 ec 04             	sub    $0x4,%esp
  802c19:	68 fc 42 80 00       	push   $0x8042fc
  802c1e:	68 a3 00 00 00       	push   $0xa3
  802c23:	68 8b 42 80 00       	push   $0x80428b
  802c28:	e8 70 dc ff ff       	call   80089d <_panic>
  802c2d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802c30:	8b 00                	mov    (%eax),%eax
  802c32:	85 c0                	test   %eax,%eax
  802c34:	74 10                	je     802c46 <alloc_block_FF+0xff>
  802c36:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802c39:	8b 00                	mov    (%eax),%eax
  802c3b:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802c3e:	8b 52 04             	mov    0x4(%edx),%edx
  802c41:	89 50 04             	mov    %edx,0x4(%eax)
  802c44:	eb 0b                	jmp    802c51 <alloc_block_FF+0x10a>
  802c46:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802c49:	8b 40 04             	mov    0x4(%eax),%eax
  802c4c:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802c51:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802c54:	8b 40 04             	mov    0x4(%eax),%eax
  802c57:	85 c0                	test   %eax,%eax
  802c59:	74 0f                	je     802c6a <alloc_block_FF+0x123>
  802c5b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802c5e:	8b 40 04             	mov    0x4(%eax),%eax
  802c61:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802c64:	8b 12                	mov    (%edx),%edx
  802c66:	89 10                	mov    %edx,(%eax)
  802c68:	eb 0a                	jmp    802c74 <alloc_block_FF+0x12d>
  802c6a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802c6d:	8b 00                	mov    (%eax),%eax
  802c6f:	a3 48 51 80 00       	mov    %eax,0x805148
  802c74:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802c77:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802c7d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802c80:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802c87:	a1 54 51 80 00       	mov    0x805154,%eax
  802c8c:	48                   	dec    %eax
  802c8d:	a3 54 51 80 00       	mov    %eax,0x805154
			newblk->size = versize;
  802c92:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802c95:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802c98:	89 50 0c             	mov    %edx,0xc(%eax)
			blk->size = blk->size-versize;
  802c9b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c9e:	8b 40 0c             	mov    0xc(%eax),%eax
  802ca1:	2b 45 f0             	sub    -0x10(%ebp),%eax
  802ca4:	89 c2                	mov    %eax,%edx
  802ca6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ca9:	89 50 0c             	mov    %edx,0xc(%eax)
			uint32 newveradd = blk->sva;
  802cac:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802caf:	8b 40 08             	mov    0x8(%eax),%eax
  802cb2:	89 45 e8             	mov    %eax,-0x18(%ebp)
			blk->sva+=newblk->size;
  802cb5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cb8:	8b 50 08             	mov    0x8(%eax),%edx
  802cbb:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802cbe:	8b 40 0c             	mov    0xc(%eax),%eax
  802cc1:	01 c2                	add    %eax,%edx
  802cc3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cc6:	89 50 08             	mov    %edx,0x8(%eax)
			newblk->sva = newveradd;
  802cc9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802ccc:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802ccf:	89 50 08             	mov    %edx,0x8(%eax)
			return newblk;
  802cd2:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802cd5:	eb 3b                	jmp    802d12 <alloc_block_FF+0x1cb>
	//panic("alloc_block_FF() is not implemented yet...!!");
	uint32 versize = size;
	struct MemBlock* blk;
	struct MemBlock* newblk = LIST_FIRST(&AvailableMemBlocksList);

	LIST_FOREACH(blk,&FreeMemBlocksList)
  802cd7:	a1 40 51 80 00       	mov    0x805140,%eax
  802cdc:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802cdf:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802ce3:	74 07                	je     802cec <alloc_block_FF+0x1a5>
  802ce5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ce8:	8b 00                	mov    (%eax),%eax
  802cea:	eb 05                	jmp    802cf1 <alloc_block_FF+0x1aa>
  802cec:	b8 00 00 00 00       	mov    $0x0,%eax
  802cf1:	a3 40 51 80 00       	mov    %eax,0x805140
  802cf6:	a1 40 51 80 00       	mov    0x805140,%eax
  802cfb:	85 c0                	test   %eax,%eax
  802cfd:	0f 85 65 fe ff ff    	jne    802b68 <alloc_block_FF+0x21>
  802d03:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802d07:	0f 85 5b fe ff ff    	jne    802b68 <alloc_block_FF+0x21>
			blk->sva+=newblk->size;
			newblk->sva = newveradd;
			return newblk;
		}
	}
	return NULL;
  802d0d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802d12:	c9                   	leave  
  802d13:	c3                   	ret    

00802d14 <alloc_block_BF>:

//=========================================
// [5] ALLOCATE BLOCK BY BEST FIT:
//=========================================
struct MemBlock *alloc_block_BF(uint32 size)
{
  802d14:	55                   	push   %ebp
  802d15:	89 e5                	mov    %esp,%ebp
  802d17:	83 ec 28             	sub    $0x28,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_BF
	// Write your code here, remove the panic and write your code
	//panic("alloc_block_BF() is not implemented yet...!!");
	uint32 versize=size;
  802d1a:	8b 45 08             	mov    0x8(%ebp),%eax
  802d1d:	89 45 e8             	mov    %eax,-0x18(%ebp)
	struct MemBlock* blk;
	struct MemBlock* newblk=LIST_FIRST(&AvailableMemBlocksList);
  802d20:	a1 48 51 80 00       	mov    0x805148,%eax
  802d25:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	uint32 newveradd;
	uint32 newsize;
	int size_free = LIST_SIZE(&FreeMemBlocksList);
  802d28:	a1 44 51 80 00       	mov    0x805144,%eax
  802d2d:	89 45 e0             	mov    %eax,-0x20(%ebp)

	LIST_FOREACH(blk, &FreeMemBlocksList)
  802d30:	a1 38 51 80 00       	mov    0x805138,%eax
  802d35:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802d38:	e9 a1 00 00 00       	jmp    802dde <alloc_block_BF+0xca>
	{
		if(blk->size == versize)
  802d3d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d40:	8b 40 0c             	mov    0xc(%eax),%eax
  802d43:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  802d46:	0f 85 8a 00 00 00    	jne    802dd6 <alloc_block_BF+0xc2>
		{
			LIST_REMOVE(&FreeMemBlocksList, blk);
  802d4c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802d50:	75 17                	jne    802d69 <alloc_block_BF+0x55>
  802d52:	83 ec 04             	sub    $0x4,%esp
  802d55:	68 fc 42 80 00       	push   $0x8042fc
  802d5a:	68 c2 00 00 00       	push   $0xc2
  802d5f:	68 8b 42 80 00       	push   $0x80428b
  802d64:	e8 34 db ff ff       	call   80089d <_panic>
  802d69:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d6c:	8b 00                	mov    (%eax),%eax
  802d6e:	85 c0                	test   %eax,%eax
  802d70:	74 10                	je     802d82 <alloc_block_BF+0x6e>
  802d72:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d75:	8b 00                	mov    (%eax),%eax
  802d77:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802d7a:	8b 52 04             	mov    0x4(%edx),%edx
  802d7d:	89 50 04             	mov    %edx,0x4(%eax)
  802d80:	eb 0b                	jmp    802d8d <alloc_block_BF+0x79>
  802d82:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d85:	8b 40 04             	mov    0x4(%eax),%eax
  802d88:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802d8d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d90:	8b 40 04             	mov    0x4(%eax),%eax
  802d93:	85 c0                	test   %eax,%eax
  802d95:	74 0f                	je     802da6 <alloc_block_BF+0x92>
  802d97:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d9a:	8b 40 04             	mov    0x4(%eax),%eax
  802d9d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802da0:	8b 12                	mov    (%edx),%edx
  802da2:	89 10                	mov    %edx,(%eax)
  802da4:	eb 0a                	jmp    802db0 <alloc_block_BF+0x9c>
  802da6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802da9:	8b 00                	mov    (%eax),%eax
  802dab:	a3 38 51 80 00       	mov    %eax,0x805138
  802db0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802db3:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802db9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802dbc:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802dc3:	a1 44 51 80 00       	mov    0x805144,%eax
  802dc8:	48                   	dec    %eax
  802dc9:	a3 44 51 80 00       	mov    %eax,0x805144
			return blk;
  802dce:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802dd1:	e9 11 02 00 00       	jmp    802fe7 <alloc_block_BF+0x2d3>
	struct MemBlock* newblk=LIST_FIRST(&AvailableMemBlocksList);
	uint32 newveradd;
	uint32 newsize;
	int size_free = LIST_SIZE(&FreeMemBlocksList);

	LIST_FOREACH(blk, &FreeMemBlocksList)
  802dd6:	a1 40 51 80 00       	mov    0x805140,%eax
  802ddb:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802dde:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802de2:	74 07                	je     802deb <alloc_block_BF+0xd7>
  802de4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802de7:	8b 00                	mov    (%eax),%eax
  802de9:	eb 05                	jmp    802df0 <alloc_block_BF+0xdc>
  802deb:	b8 00 00 00 00       	mov    $0x0,%eax
  802df0:	a3 40 51 80 00       	mov    %eax,0x805140
  802df5:	a1 40 51 80 00       	mov    0x805140,%eax
  802dfa:	85 c0                	test   %eax,%eax
  802dfc:	0f 85 3b ff ff ff    	jne    802d3d <alloc_block_BF+0x29>
  802e02:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802e06:	0f 85 31 ff ff ff    	jne    802d3d <alloc_block_BF+0x29>
		{
			LIST_REMOVE(&FreeMemBlocksList, blk);
			return blk;
		}
	}
	LIST_FOREACH(blk, &FreeMemBlocksList)
  802e0c:	a1 38 51 80 00       	mov    0x805138,%eax
  802e11:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802e14:	eb 27                	jmp    802e3d <alloc_block_BF+0x129>
	{
		if(blk->size > versize)
  802e16:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e19:	8b 40 0c             	mov    0xc(%eax),%eax
  802e1c:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  802e1f:	76 14                	jbe    802e35 <alloc_block_BF+0x121>
		{
			newsize = blk->size;
  802e21:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e24:	8b 40 0c             	mov    0xc(%eax),%eax
  802e27:	89 45 ec             	mov    %eax,-0x14(%ebp)
			newveradd = blk->sva;
  802e2a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e2d:	8b 40 08             	mov    0x8(%eax),%eax
  802e30:	89 45 f0             	mov    %eax,-0x10(%ebp)
			break;
  802e33:	eb 2e                	jmp    802e63 <alloc_block_BF+0x14f>
		{
			LIST_REMOVE(&FreeMemBlocksList, blk);
			return blk;
		}
	}
	LIST_FOREACH(blk, &FreeMemBlocksList)
  802e35:	a1 40 51 80 00       	mov    0x805140,%eax
  802e3a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802e3d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802e41:	74 07                	je     802e4a <alloc_block_BF+0x136>
  802e43:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e46:	8b 00                	mov    (%eax),%eax
  802e48:	eb 05                	jmp    802e4f <alloc_block_BF+0x13b>
  802e4a:	b8 00 00 00 00       	mov    $0x0,%eax
  802e4f:	a3 40 51 80 00       	mov    %eax,0x805140
  802e54:	a1 40 51 80 00       	mov    0x805140,%eax
  802e59:	85 c0                	test   %eax,%eax
  802e5b:	75 b9                	jne    802e16 <alloc_block_BF+0x102>
  802e5d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802e61:	75 b3                	jne    802e16 <alloc_block_BF+0x102>
			newsize = blk->size;
			newveradd = blk->sva;
			break;
		}
	}
	LIST_FOREACH(blk, &FreeMemBlocksList)
  802e63:	a1 38 51 80 00       	mov    0x805138,%eax
  802e68:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802e6b:	eb 30                	jmp    802e9d <alloc_block_BF+0x189>
	{
		if(newsize > blk->size && blk->size > versize)
  802e6d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e70:	8b 40 0c             	mov    0xc(%eax),%eax
  802e73:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  802e76:	73 1d                	jae    802e95 <alloc_block_BF+0x181>
  802e78:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e7b:	8b 40 0c             	mov    0xc(%eax),%eax
  802e7e:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  802e81:	76 12                	jbe    802e95 <alloc_block_BF+0x181>
		{
	       newsize = blk->size;
  802e83:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e86:	8b 40 0c             	mov    0xc(%eax),%eax
  802e89:	89 45 ec             	mov    %eax,-0x14(%ebp)
		   newveradd = blk->sva;
  802e8c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e8f:	8b 40 08             	mov    0x8(%eax),%eax
  802e92:	89 45 f0             	mov    %eax,-0x10(%ebp)
			newsize = blk->size;
			newveradd = blk->sva;
			break;
		}
	}
	LIST_FOREACH(blk, &FreeMemBlocksList)
  802e95:	a1 40 51 80 00       	mov    0x805140,%eax
  802e9a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802e9d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802ea1:	74 07                	je     802eaa <alloc_block_BF+0x196>
  802ea3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ea6:	8b 00                	mov    (%eax),%eax
  802ea8:	eb 05                	jmp    802eaf <alloc_block_BF+0x19b>
  802eaa:	b8 00 00 00 00       	mov    $0x0,%eax
  802eaf:	a3 40 51 80 00       	mov    %eax,0x805140
  802eb4:	a1 40 51 80 00       	mov    0x805140,%eax
  802eb9:	85 c0                	test   %eax,%eax
  802ebb:	75 b0                	jne    802e6d <alloc_block_BF+0x159>
  802ebd:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802ec1:	75 aa                	jne    802e6d <alloc_block_BF+0x159>
		{
	       newsize = blk->size;
		   newveradd = blk->sva;
		}
	}
	LIST_FOREACH(blk, &FreeMemBlocksList)
  802ec3:	a1 38 51 80 00       	mov    0x805138,%eax
  802ec8:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802ecb:	e9 e4 00 00 00       	jmp    802fb4 <alloc_block_BF+0x2a0>
	{
		if(blk->size == newsize && blk->sva == newveradd)
  802ed0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ed3:	8b 40 0c             	mov    0xc(%eax),%eax
  802ed6:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  802ed9:	0f 85 cd 00 00 00    	jne    802fac <alloc_block_BF+0x298>
  802edf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ee2:	8b 40 08             	mov    0x8(%eax),%eax
  802ee5:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  802ee8:	0f 85 be 00 00 00    	jne    802fac <alloc_block_BF+0x298>
		{
			LIST_REMOVE(&AvailableMemBlocksList, newblk);
  802eee:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  802ef2:	75 17                	jne    802f0b <alloc_block_BF+0x1f7>
  802ef4:	83 ec 04             	sub    $0x4,%esp
  802ef7:	68 fc 42 80 00       	push   $0x8042fc
  802efc:	68 db 00 00 00       	push   $0xdb
  802f01:	68 8b 42 80 00       	push   $0x80428b
  802f06:	e8 92 d9 ff ff       	call   80089d <_panic>
  802f0b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802f0e:	8b 00                	mov    (%eax),%eax
  802f10:	85 c0                	test   %eax,%eax
  802f12:	74 10                	je     802f24 <alloc_block_BF+0x210>
  802f14:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802f17:	8b 00                	mov    (%eax),%eax
  802f19:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802f1c:	8b 52 04             	mov    0x4(%edx),%edx
  802f1f:	89 50 04             	mov    %edx,0x4(%eax)
  802f22:	eb 0b                	jmp    802f2f <alloc_block_BF+0x21b>
  802f24:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802f27:	8b 40 04             	mov    0x4(%eax),%eax
  802f2a:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802f2f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802f32:	8b 40 04             	mov    0x4(%eax),%eax
  802f35:	85 c0                	test   %eax,%eax
  802f37:	74 0f                	je     802f48 <alloc_block_BF+0x234>
  802f39:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802f3c:	8b 40 04             	mov    0x4(%eax),%eax
  802f3f:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802f42:	8b 12                	mov    (%edx),%edx
  802f44:	89 10                	mov    %edx,(%eax)
  802f46:	eb 0a                	jmp    802f52 <alloc_block_BF+0x23e>
  802f48:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802f4b:	8b 00                	mov    (%eax),%eax
  802f4d:	a3 48 51 80 00       	mov    %eax,0x805148
  802f52:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802f55:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802f5b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802f5e:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802f65:	a1 54 51 80 00       	mov    0x805154,%eax
  802f6a:	48                   	dec    %eax
  802f6b:	a3 54 51 80 00       	mov    %eax,0x805154
			newblk->size = versize;
  802f70:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802f73:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802f76:	89 50 0c             	mov    %edx,0xc(%eax)
			newblk->sva = newveradd;
  802f79:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802f7c:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802f7f:	89 50 08             	mov    %edx,0x8(%eax)
			blk->size = blk->size - versize;
  802f82:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f85:	8b 40 0c             	mov    0xc(%eax),%eax
  802f88:	2b 45 e8             	sub    -0x18(%ebp),%eax
  802f8b:	89 c2                	mov    %eax,%edx
  802f8d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f90:	89 50 0c             	mov    %edx,0xc(%eax)
			blk->sva+= newblk->size;
  802f93:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f96:	8b 50 08             	mov    0x8(%eax),%edx
  802f99:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802f9c:	8b 40 0c             	mov    0xc(%eax),%eax
  802f9f:	01 c2                	add    %eax,%edx
  802fa1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802fa4:	89 50 08             	mov    %edx,0x8(%eax)
			return newblk;
  802fa7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802faa:	eb 3b                	jmp    802fe7 <alloc_block_BF+0x2d3>
		{
	       newsize = blk->size;
		   newveradd = blk->sva;
		}
	}
	LIST_FOREACH(blk, &FreeMemBlocksList)
  802fac:	a1 40 51 80 00       	mov    0x805140,%eax
  802fb1:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802fb4:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802fb8:	74 07                	je     802fc1 <alloc_block_BF+0x2ad>
  802fba:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802fbd:	8b 00                	mov    (%eax),%eax
  802fbf:	eb 05                	jmp    802fc6 <alloc_block_BF+0x2b2>
  802fc1:	b8 00 00 00 00       	mov    $0x0,%eax
  802fc6:	a3 40 51 80 00       	mov    %eax,0x805140
  802fcb:	a1 40 51 80 00       	mov    0x805140,%eax
  802fd0:	85 c0                	test   %eax,%eax
  802fd2:	0f 85 f8 fe ff ff    	jne    802ed0 <alloc_block_BF+0x1bc>
  802fd8:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802fdc:	0f 85 ee fe ff ff    	jne    802ed0 <alloc_block_BF+0x1bc>
			blk->size = blk->size - versize;
			blk->sva+= newblk->size;
			return newblk;
		}
	}
	return NULL;
  802fe2:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802fe7:	c9                   	leave  
  802fe8:	c3                   	ret    

00802fe9 <alloc_block_NF>:
//=========================================
// [7] ALLOCATE BLOCK BY NEXT FIT:
//=========================================
struct MemBlock *last_allocate;
struct MemBlock *alloc_block_NF(uint32 size)
{
  802fe9:	55                   	push   %ebp
  802fea:	89 e5                	mov    %esp,%ebp
  802fec:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1 - BONUS] [DYNAMIC ALLOCATOR] alloc_block_NF
	// Write your code here, remove the panic and write your code
	//panic("alloc_block_NF() is not implemented yet...!!");
	uint32 versize = size;
  802fef:	8b 45 08             	mov    0x8(%ebp),%eax
  802ff2:	89 45 f0             	mov    %eax,-0x10(%ebp)
	struct MemBlock* blk;
	struct MemBlock* newblk = LIST_FIRST(&AvailableMemBlocksList);
  802ff5:	a1 48 51 80 00       	mov    0x805148,%eax
  802ffa:	89 45 ec             	mov    %eax,-0x14(%ebp)

	LIST_FOREACH(blk,&FreeMemBlocksList)
  802ffd:	a1 38 51 80 00       	mov    0x805138,%eax
  803002:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803005:	e9 77 01 00 00       	jmp    803181 <alloc_block_NF+0x198>
	{
		if(blk->size == versize)
  80300a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80300d:	8b 40 0c             	mov    0xc(%eax),%eax
  803010:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  803013:	0f 85 8a 00 00 00    	jne    8030a3 <alloc_block_NF+0xba>
		{
			LIST_REMOVE(&FreeMemBlocksList,blk);
  803019:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80301d:	75 17                	jne    803036 <alloc_block_NF+0x4d>
  80301f:	83 ec 04             	sub    $0x4,%esp
  803022:	68 fc 42 80 00       	push   $0x8042fc
  803027:	68 f7 00 00 00       	push   $0xf7
  80302c:	68 8b 42 80 00       	push   $0x80428b
  803031:	e8 67 d8 ff ff       	call   80089d <_panic>
  803036:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803039:	8b 00                	mov    (%eax),%eax
  80303b:	85 c0                	test   %eax,%eax
  80303d:	74 10                	je     80304f <alloc_block_NF+0x66>
  80303f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803042:	8b 00                	mov    (%eax),%eax
  803044:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803047:	8b 52 04             	mov    0x4(%edx),%edx
  80304a:	89 50 04             	mov    %edx,0x4(%eax)
  80304d:	eb 0b                	jmp    80305a <alloc_block_NF+0x71>
  80304f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803052:	8b 40 04             	mov    0x4(%eax),%eax
  803055:	a3 3c 51 80 00       	mov    %eax,0x80513c
  80305a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80305d:	8b 40 04             	mov    0x4(%eax),%eax
  803060:	85 c0                	test   %eax,%eax
  803062:	74 0f                	je     803073 <alloc_block_NF+0x8a>
  803064:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803067:	8b 40 04             	mov    0x4(%eax),%eax
  80306a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80306d:	8b 12                	mov    (%edx),%edx
  80306f:	89 10                	mov    %edx,(%eax)
  803071:	eb 0a                	jmp    80307d <alloc_block_NF+0x94>
  803073:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803076:	8b 00                	mov    (%eax),%eax
  803078:	a3 38 51 80 00       	mov    %eax,0x805138
  80307d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803080:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803086:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803089:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803090:	a1 44 51 80 00       	mov    0x805144,%eax
  803095:	48                   	dec    %eax
  803096:	a3 44 51 80 00       	mov    %eax,0x805144
			return blk;
  80309b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80309e:	e9 11 01 00 00       	jmp    8031b4 <alloc_block_NF+0x1cb>
		}
		else if(blk->size > versize)
  8030a3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030a6:	8b 40 0c             	mov    0xc(%eax),%eax
  8030a9:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8030ac:	0f 86 c7 00 00 00    	jbe    803179 <alloc_block_NF+0x190>
		{
			LIST_REMOVE(&AvailableMemBlocksList,newblk);
  8030b2:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8030b6:	75 17                	jne    8030cf <alloc_block_NF+0xe6>
  8030b8:	83 ec 04             	sub    $0x4,%esp
  8030bb:	68 fc 42 80 00       	push   $0x8042fc
  8030c0:	68 fc 00 00 00       	push   $0xfc
  8030c5:	68 8b 42 80 00       	push   $0x80428b
  8030ca:	e8 ce d7 ff ff       	call   80089d <_panic>
  8030cf:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8030d2:	8b 00                	mov    (%eax),%eax
  8030d4:	85 c0                	test   %eax,%eax
  8030d6:	74 10                	je     8030e8 <alloc_block_NF+0xff>
  8030d8:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8030db:	8b 00                	mov    (%eax),%eax
  8030dd:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8030e0:	8b 52 04             	mov    0x4(%edx),%edx
  8030e3:	89 50 04             	mov    %edx,0x4(%eax)
  8030e6:	eb 0b                	jmp    8030f3 <alloc_block_NF+0x10a>
  8030e8:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8030eb:	8b 40 04             	mov    0x4(%eax),%eax
  8030ee:	a3 4c 51 80 00       	mov    %eax,0x80514c
  8030f3:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8030f6:	8b 40 04             	mov    0x4(%eax),%eax
  8030f9:	85 c0                	test   %eax,%eax
  8030fb:	74 0f                	je     80310c <alloc_block_NF+0x123>
  8030fd:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803100:	8b 40 04             	mov    0x4(%eax),%eax
  803103:	8b 55 ec             	mov    -0x14(%ebp),%edx
  803106:	8b 12                	mov    (%edx),%edx
  803108:	89 10                	mov    %edx,(%eax)
  80310a:	eb 0a                	jmp    803116 <alloc_block_NF+0x12d>
  80310c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80310f:	8b 00                	mov    (%eax),%eax
  803111:	a3 48 51 80 00       	mov    %eax,0x805148
  803116:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803119:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80311f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803122:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803129:	a1 54 51 80 00       	mov    0x805154,%eax
  80312e:	48                   	dec    %eax
  80312f:	a3 54 51 80 00       	mov    %eax,0x805154
			newblk->size = versize;
  803134:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803137:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80313a:	89 50 0c             	mov    %edx,0xc(%eax)
			blk->size = blk->size-versize;
  80313d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803140:	8b 40 0c             	mov    0xc(%eax),%eax
  803143:	2b 45 f0             	sub    -0x10(%ebp),%eax
  803146:	89 c2                	mov    %eax,%edx
  803148:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80314b:	89 50 0c             	mov    %edx,0xc(%eax)
			uint32 newveradd = blk->sva;
  80314e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803151:	8b 40 08             	mov    0x8(%eax),%eax
  803154:	89 45 e8             	mov    %eax,-0x18(%ebp)
			blk->sva+=newblk->size;
  803157:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80315a:	8b 50 08             	mov    0x8(%eax),%edx
  80315d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803160:	8b 40 0c             	mov    0xc(%eax),%eax
  803163:	01 c2                	add    %eax,%edx
  803165:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803168:	89 50 08             	mov    %edx,0x8(%eax)
			newblk->sva = newveradd;
  80316b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80316e:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803171:	89 50 08             	mov    %edx,0x8(%eax)
			return newblk;
  803174:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803177:	eb 3b                	jmp    8031b4 <alloc_block_NF+0x1cb>
	//panic("alloc_block_NF() is not implemented yet...!!");
	uint32 versize = size;
	struct MemBlock* blk;
	struct MemBlock* newblk = LIST_FIRST(&AvailableMemBlocksList);

	LIST_FOREACH(blk,&FreeMemBlocksList)
  803179:	a1 40 51 80 00       	mov    0x805140,%eax
  80317e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803181:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803185:	74 07                	je     80318e <alloc_block_NF+0x1a5>
  803187:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80318a:	8b 00                	mov    (%eax),%eax
  80318c:	eb 05                	jmp    803193 <alloc_block_NF+0x1aa>
  80318e:	b8 00 00 00 00       	mov    $0x0,%eax
  803193:	a3 40 51 80 00       	mov    %eax,0x805140
  803198:	a1 40 51 80 00       	mov    0x805140,%eax
  80319d:	85 c0                	test   %eax,%eax
  80319f:	0f 85 65 fe ff ff    	jne    80300a <alloc_block_NF+0x21>
  8031a5:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8031a9:	0f 85 5b fe ff ff    	jne    80300a <alloc_block_NF+0x21>
			blk->sva+=newblk->size;
			newblk->sva = newveradd;
			return newblk;
		}
	}
	return NULL;
  8031af:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8031b4:	c9                   	leave  
  8031b5:	c3                   	ret    

008031b6 <addToAvailMemBlocksList>:

//===================================================
// [8] INSERT BLOCK (SORTED WITH MERGE) IN FREE LIST:
//===================================================
void addToAvailMemBlocksList(struct MemBlock *blockToInsert)
{
  8031b6:	55                   	push   %ebp
  8031b7:	89 e5                	mov    %esp,%ebp
  8031b9:	83 ec 08             	sub    $0x8,%esp
	blockToInsert->sva = 0;
  8031bc:	8b 45 08             	mov    0x8(%ebp),%eax
  8031bf:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
	blockToInsert->size = 0;
  8031c6:	8b 45 08             	mov    0x8(%ebp),%eax
  8031c9:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
	//add to avail
	LIST_INSERT_TAIL(&AvailableMemBlocksList, blockToInsert);
  8031d0:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8031d4:	75 17                	jne    8031ed <addToAvailMemBlocksList+0x37>
  8031d6:	83 ec 04             	sub    $0x4,%esp
  8031d9:	68 a4 42 80 00       	push   $0x8042a4
  8031de:	68 10 01 00 00       	push   $0x110
  8031e3:	68 8b 42 80 00       	push   $0x80428b
  8031e8:	e8 b0 d6 ff ff       	call   80089d <_panic>
  8031ed:	8b 15 4c 51 80 00    	mov    0x80514c,%edx
  8031f3:	8b 45 08             	mov    0x8(%ebp),%eax
  8031f6:	89 50 04             	mov    %edx,0x4(%eax)
  8031f9:	8b 45 08             	mov    0x8(%ebp),%eax
  8031fc:	8b 40 04             	mov    0x4(%eax),%eax
  8031ff:	85 c0                	test   %eax,%eax
  803201:	74 0c                	je     80320f <addToAvailMemBlocksList+0x59>
  803203:	a1 4c 51 80 00       	mov    0x80514c,%eax
  803208:	8b 55 08             	mov    0x8(%ebp),%edx
  80320b:	89 10                	mov    %edx,(%eax)
  80320d:	eb 08                	jmp    803217 <addToAvailMemBlocksList+0x61>
  80320f:	8b 45 08             	mov    0x8(%ebp),%eax
  803212:	a3 48 51 80 00       	mov    %eax,0x805148
  803217:	8b 45 08             	mov    0x8(%ebp),%eax
  80321a:	a3 4c 51 80 00       	mov    %eax,0x80514c
  80321f:	8b 45 08             	mov    0x8(%ebp),%eax
  803222:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803228:	a1 54 51 80 00       	mov    0x805154,%eax
  80322d:	40                   	inc    %eax
  80322e:	a3 54 51 80 00       	mov    %eax,0x805154
}
  803233:	90                   	nop
  803234:	c9                   	leave  
  803235:	c3                   	ret    

00803236 <insert_sorted_with_merge_freeList>:
void insert_sorted_with_merge_freeList(struct MemBlock *blockToInsert)
{
  803236:	55                   	push   %ebp
  803237:	89 e5                	mov    %esp,%ebp
  803239:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] insert_sorted_with_merge_freeList
	// Write your code here, remove the panic and write your code

	struct MemBlock* last = LIST_LAST(&FreeMemBlocksList);
  80323c:	a1 3c 51 80 00       	mov    0x80513c,%eax
  803241:	89 45 f0             	mov    %eax,-0x10(%ebp)
	//check if list empty
	if (LIST_SIZE(&(FreeMemBlocksList)) == 0)
  803244:	a1 44 51 80 00       	mov    0x805144,%eax
  803249:	85 c0                	test   %eax,%eax
  80324b:	75 68                	jne    8032b5 <insert_sorted_with_merge_freeList+0x7f>
		LIST_INSERT_HEAD(&FreeMemBlocksList, blockToInsert);
  80324d:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803251:	75 17                	jne    80326a <insert_sorted_with_merge_freeList+0x34>
  803253:	83 ec 04             	sub    $0x4,%esp
  803256:	68 68 42 80 00       	push   $0x804268
  80325b:	68 1a 01 00 00       	push   $0x11a
  803260:	68 8b 42 80 00       	push   $0x80428b
  803265:	e8 33 d6 ff ff       	call   80089d <_panic>
  80326a:	8b 15 38 51 80 00    	mov    0x805138,%edx
  803270:	8b 45 08             	mov    0x8(%ebp),%eax
  803273:	89 10                	mov    %edx,(%eax)
  803275:	8b 45 08             	mov    0x8(%ebp),%eax
  803278:	8b 00                	mov    (%eax),%eax
  80327a:	85 c0                	test   %eax,%eax
  80327c:	74 0d                	je     80328b <insert_sorted_with_merge_freeList+0x55>
  80327e:	a1 38 51 80 00       	mov    0x805138,%eax
  803283:	8b 55 08             	mov    0x8(%ebp),%edx
  803286:	89 50 04             	mov    %edx,0x4(%eax)
  803289:	eb 08                	jmp    803293 <insert_sorted_with_merge_freeList+0x5d>
  80328b:	8b 45 08             	mov    0x8(%ebp),%eax
  80328e:	a3 3c 51 80 00       	mov    %eax,0x80513c
  803293:	8b 45 08             	mov    0x8(%ebp),%eax
  803296:	a3 38 51 80 00       	mov    %eax,0x805138
  80329b:	8b 45 08             	mov    0x8(%ebp),%eax
  80329e:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8032a5:	a1 44 51 80 00       	mov    0x805144,%eax
  8032aa:	40                   	inc    %eax
  8032ab:	a3 44 51 80 00       	mov    %eax,0x805144
		}
	}

	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  8032b0:	e9 c5 03 00 00       	jmp    80367a <insert_sorted_with_merge_freeList+0x444>
	struct MemBlock* last = LIST_LAST(&FreeMemBlocksList);
	//check if list empty
	if (LIST_SIZE(&(FreeMemBlocksList)) == 0)
		LIST_INSERT_HEAD(&FreeMemBlocksList, blockToInsert);
	//check if it's position is at last
	else if (last->sva < blockToInsert->sva) {
  8032b5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8032b8:	8b 50 08             	mov    0x8(%eax),%edx
  8032bb:	8b 45 08             	mov    0x8(%ebp),%eax
  8032be:	8b 40 08             	mov    0x8(%eax),%eax
  8032c1:	39 c2                	cmp    %eax,%edx
  8032c3:	0f 83 b2 00 00 00    	jae    80337b <insert_sorted_with_merge_freeList+0x145>

		//if i have to merge
		if (last->sva + last->size == blockToInsert->sva) {
  8032c9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8032cc:	8b 50 08             	mov    0x8(%eax),%edx
  8032cf:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8032d2:	8b 40 0c             	mov    0xc(%eax),%eax
  8032d5:	01 c2                	add    %eax,%edx
  8032d7:	8b 45 08             	mov    0x8(%ebp),%eax
  8032da:	8b 40 08             	mov    0x8(%eax),%eax
  8032dd:	39 c2                	cmp    %eax,%edx
  8032df:	75 27                	jne    803308 <insert_sorted_with_merge_freeList+0xd2>
			last->size = last->size + blockToInsert->size;
  8032e1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8032e4:	8b 50 0c             	mov    0xc(%eax),%edx
  8032e7:	8b 45 08             	mov    0x8(%ebp),%eax
  8032ea:	8b 40 0c             	mov    0xc(%eax),%eax
  8032ed:	01 c2                	add    %eax,%edx
  8032ef:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8032f2:	89 50 0c             	mov    %edx,0xc(%eax)
			addToAvailMemBlocksList(blockToInsert);
  8032f5:	83 ec 0c             	sub    $0xc,%esp
  8032f8:	ff 75 08             	pushl  0x8(%ebp)
  8032fb:	e8 b6 fe ff ff       	call   8031b6 <addToAvailMemBlocksList>
  803300:	83 c4 10             	add    $0x10,%esp
		}
	}

	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  803303:	e9 72 03 00 00       	jmp    80367a <insert_sorted_with_merge_freeList+0x444>
		if (last->sva + last->size == blockToInsert->sva) {
			last->size = last->size + blockToInsert->size;
			addToAvailMemBlocksList(blockToInsert);

		} else {
			LIST_INSERT_AFTER(&FreeMemBlocksList, last, blockToInsert);
  803308:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80330c:	74 06                	je     803314 <insert_sorted_with_merge_freeList+0xde>
  80330e:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803312:	75 17                	jne    80332b <insert_sorted_with_merge_freeList+0xf5>
  803314:	83 ec 04             	sub    $0x4,%esp
  803317:	68 c8 42 80 00       	push   $0x8042c8
  80331c:	68 24 01 00 00       	push   $0x124
  803321:	68 8b 42 80 00       	push   $0x80428b
  803326:	e8 72 d5 ff ff       	call   80089d <_panic>
  80332b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80332e:	8b 10                	mov    (%eax),%edx
  803330:	8b 45 08             	mov    0x8(%ebp),%eax
  803333:	89 10                	mov    %edx,(%eax)
  803335:	8b 45 08             	mov    0x8(%ebp),%eax
  803338:	8b 00                	mov    (%eax),%eax
  80333a:	85 c0                	test   %eax,%eax
  80333c:	74 0b                	je     803349 <insert_sorted_with_merge_freeList+0x113>
  80333e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803341:	8b 00                	mov    (%eax),%eax
  803343:	8b 55 08             	mov    0x8(%ebp),%edx
  803346:	89 50 04             	mov    %edx,0x4(%eax)
  803349:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80334c:	8b 55 08             	mov    0x8(%ebp),%edx
  80334f:	89 10                	mov    %edx,(%eax)
  803351:	8b 45 08             	mov    0x8(%ebp),%eax
  803354:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803357:	89 50 04             	mov    %edx,0x4(%eax)
  80335a:	8b 45 08             	mov    0x8(%ebp),%eax
  80335d:	8b 00                	mov    (%eax),%eax
  80335f:	85 c0                	test   %eax,%eax
  803361:	75 08                	jne    80336b <insert_sorted_with_merge_freeList+0x135>
  803363:	8b 45 08             	mov    0x8(%ebp),%eax
  803366:	a3 3c 51 80 00       	mov    %eax,0x80513c
  80336b:	a1 44 51 80 00       	mov    0x805144,%eax
  803370:	40                   	inc    %eax
  803371:	a3 44 51 80 00       	mov    %eax,0x805144
		}
	}

	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  803376:	e9 ff 02 00 00       	jmp    80367a <insert_sorted_with_merge_freeList+0x444>
		} else {
			LIST_INSERT_AFTER(&FreeMemBlocksList, last, blockToInsert);
		}
	} else {
		struct MemBlock *iterator;
		LIST_FOREACH(iterator, &(FreeMemBlocksList))
  80337b:	a1 38 51 80 00       	mov    0x805138,%eax
  803380:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803383:	e9 c2 02 00 00       	jmp    80364a <insert_sorted_with_merge_freeList+0x414>
		{

			if (iterator->sva > blockToInsert->sva) {
  803388:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80338b:	8b 50 08             	mov    0x8(%eax),%edx
  80338e:	8b 45 08             	mov    0x8(%ebp),%eax
  803391:	8b 40 08             	mov    0x8(%eax),%eax
  803394:	39 c2                	cmp    %eax,%edx
  803396:	0f 86 a6 02 00 00    	jbe    803642 <insert_sorted_with_merge_freeList+0x40c>

				struct MemBlock* prev = LIST_PREV(iterator);
  80339c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80339f:	8b 40 04             	mov    0x4(%eax),%eax
  8033a2:	89 45 ec             	mov    %eax,-0x14(%ebp)
				if (prev == NULL) {
  8033a5:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8033a9:	0f 85 ba 00 00 00    	jne    803469 <insert_sorted_with_merge_freeList+0x233>
					//check merge
					if (blockToInsert->size + blockToInsert->sva
  8033af:	8b 45 08             	mov    0x8(%ebp),%eax
  8033b2:	8b 50 0c             	mov    0xc(%eax),%edx
  8033b5:	8b 45 08             	mov    0x8(%ebp),%eax
  8033b8:	8b 40 08             	mov    0x8(%eax),%eax
  8033bb:	01 c2                	add    %eax,%edx
							== iterator->sva) {
  8033bd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8033c0:	8b 40 08             	mov    0x8(%eax),%eax
			if (iterator->sva > blockToInsert->sva) {

				struct MemBlock* prev = LIST_PREV(iterator);
				if (prev == NULL) {
					//check merge
					if (blockToInsert->size + blockToInsert->sva
  8033c3:	39 c2                	cmp    %eax,%edx
  8033c5:	75 33                	jne    8033fa <insert_sorted_with_merge_freeList+0x1c4>
							== iterator->sva) {
						iterator->sva = blockToInsert->sva;
  8033c7:	8b 45 08             	mov    0x8(%ebp),%eax
  8033ca:	8b 50 08             	mov    0x8(%eax),%edx
  8033cd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8033d0:	89 50 08             	mov    %edx,0x8(%eax)
						iterator->size = iterator->size + blockToInsert->size;
  8033d3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8033d6:	8b 50 0c             	mov    0xc(%eax),%edx
  8033d9:	8b 45 08             	mov    0x8(%ebp),%eax
  8033dc:	8b 40 0c             	mov    0xc(%eax),%eax
  8033df:	01 c2                	add    %eax,%edx
  8033e1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8033e4:	89 50 0c             	mov    %edx,0xc(%eax)
						addToAvailMemBlocksList(blockToInsert);
  8033e7:	83 ec 0c             	sub    $0xc,%esp
  8033ea:	ff 75 08             	pushl  0x8(%ebp)
  8033ed:	e8 c4 fd ff ff       	call   8031b6 <addToAvailMemBlocksList>
  8033f2:	83 c4 10             	add    $0x10,%esp

					else {
						LIST_INSERT_BEFORE(&FreeMemBlocksList, iterator,
								blockToInsert);
					}
					break;
  8033f5:	e9 80 02 00 00       	jmp    80367a <insert_sorted_with_merge_freeList+0x444>
						addToAvailMemBlocksList(blockToInsert);

					}

					else {
						LIST_INSERT_BEFORE(&FreeMemBlocksList, iterator,
  8033fa:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8033fe:	74 06                	je     803406 <insert_sorted_with_merge_freeList+0x1d0>
  803400:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803404:	75 17                	jne    80341d <insert_sorted_with_merge_freeList+0x1e7>
  803406:	83 ec 04             	sub    $0x4,%esp
  803409:	68 1c 43 80 00       	push   $0x80431c
  80340e:	68 3a 01 00 00       	push   $0x13a
  803413:	68 8b 42 80 00       	push   $0x80428b
  803418:	e8 80 d4 ff ff       	call   80089d <_panic>
  80341d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803420:	8b 50 04             	mov    0x4(%eax),%edx
  803423:	8b 45 08             	mov    0x8(%ebp),%eax
  803426:	89 50 04             	mov    %edx,0x4(%eax)
  803429:	8b 45 08             	mov    0x8(%ebp),%eax
  80342c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80342f:	89 10                	mov    %edx,(%eax)
  803431:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803434:	8b 40 04             	mov    0x4(%eax),%eax
  803437:	85 c0                	test   %eax,%eax
  803439:	74 0d                	je     803448 <insert_sorted_with_merge_freeList+0x212>
  80343b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80343e:	8b 40 04             	mov    0x4(%eax),%eax
  803441:	8b 55 08             	mov    0x8(%ebp),%edx
  803444:	89 10                	mov    %edx,(%eax)
  803446:	eb 08                	jmp    803450 <insert_sorted_with_merge_freeList+0x21a>
  803448:	8b 45 08             	mov    0x8(%ebp),%eax
  80344b:	a3 38 51 80 00       	mov    %eax,0x805138
  803450:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803453:	8b 55 08             	mov    0x8(%ebp),%edx
  803456:	89 50 04             	mov    %edx,0x4(%eax)
  803459:	a1 44 51 80 00       	mov    0x805144,%eax
  80345e:	40                   	inc    %eax
  80345f:	a3 44 51 80 00       	mov    %eax,0x805144
								blockToInsert);
					}
					break;
  803464:	e9 11 02 00 00       	jmp    80367a <insert_sorted_with_merge_freeList+0x444>
				} else {
					//prev and next merge
					if (prev->sva + prev->size + blockToInsert->size
  803469:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80346c:	8b 50 08             	mov    0x8(%eax),%edx
  80346f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803472:	8b 40 0c             	mov    0xc(%eax),%eax
  803475:	01 c2                	add    %eax,%edx
  803477:	8b 45 08             	mov    0x8(%ebp),%eax
  80347a:	8b 40 0c             	mov    0xc(%eax),%eax
  80347d:	01 c2                	add    %eax,%edx
							== iterator->sva) {
  80347f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803482:	8b 40 08             	mov    0x8(%eax),%eax
								blockToInsert);
					}
					break;
				} else {
					//prev and next merge
					if (prev->sva + prev->size + blockToInsert->size
  803485:	39 c2                	cmp    %eax,%edx
  803487:	0f 85 bf 00 00 00    	jne    80354c <insert_sorted_with_merge_freeList+0x316>
							== iterator->sva) {
						prev->size = prev->size + blockToInsert->size
  80348d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803490:	8b 50 0c             	mov    0xc(%eax),%edx
  803493:	8b 45 08             	mov    0x8(%ebp),%eax
  803496:	8b 40 0c             	mov    0xc(%eax),%eax
  803499:	01 c2                	add    %eax,%edx
								+ iterator->size;
  80349b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80349e:	8b 40 0c             	mov    0xc(%eax),%eax
  8034a1:	01 c2                	add    %eax,%edx
					break;
				} else {
					//prev and next merge
					if (prev->sva + prev->size + blockToInsert->size
							== iterator->sva) {
						prev->size = prev->size + blockToInsert->size
  8034a3:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8034a6:	89 50 0c             	mov    %edx,0xc(%eax)
								+ iterator->size;
						LIST_REMOVE(&FreeMemBlocksList, iterator);
  8034a9:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8034ad:	75 17                	jne    8034c6 <insert_sorted_with_merge_freeList+0x290>
  8034af:	83 ec 04             	sub    $0x4,%esp
  8034b2:	68 fc 42 80 00       	push   $0x8042fc
  8034b7:	68 43 01 00 00       	push   $0x143
  8034bc:	68 8b 42 80 00       	push   $0x80428b
  8034c1:	e8 d7 d3 ff ff       	call   80089d <_panic>
  8034c6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8034c9:	8b 00                	mov    (%eax),%eax
  8034cb:	85 c0                	test   %eax,%eax
  8034cd:	74 10                	je     8034df <insert_sorted_with_merge_freeList+0x2a9>
  8034cf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8034d2:	8b 00                	mov    (%eax),%eax
  8034d4:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8034d7:	8b 52 04             	mov    0x4(%edx),%edx
  8034da:	89 50 04             	mov    %edx,0x4(%eax)
  8034dd:	eb 0b                	jmp    8034ea <insert_sorted_with_merge_freeList+0x2b4>
  8034df:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8034e2:	8b 40 04             	mov    0x4(%eax),%eax
  8034e5:	a3 3c 51 80 00       	mov    %eax,0x80513c
  8034ea:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8034ed:	8b 40 04             	mov    0x4(%eax),%eax
  8034f0:	85 c0                	test   %eax,%eax
  8034f2:	74 0f                	je     803503 <insert_sorted_with_merge_freeList+0x2cd>
  8034f4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8034f7:	8b 40 04             	mov    0x4(%eax),%eax
  8034fa:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8034fd:	8b 12                	mov    (%edx),%edx
  8034ff:	89 10                	mov    %edx,(%eax)
  803501:	eb 0a                	jmp    80350d <insert_sorted_with_merge_freeList+0x2d7>
  803503:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803506:	8b 00                	mov    (%eax),%eax
  803508:	a3 38 51 80 00       	mov    %eax,0x805138
  80350d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803510:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803516:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803519:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803520:	a1 44 51 80 00       	mov    0x805144,%eax
  803525:	48                   	dec    %eax
  803526:	a3 44 51 80 00       	mov    %eax,0x805144
						addToAvailMemBlocksList(blockToInsert);
  80352b:	83 ec 0c             	sub    $0xc,%esp
  80352e:	ff 75 08             	pushl  0x8(%ebp)
  803531:	e8 80 fc ff ff       	call   8031b6 <addToAvailMemBlocksList>
  803536:	83 c4 10             	add    $0x10,%esp
						addToAvailMemBlocksList(iterator);
  803539:	83 ec 0c             	sub    $0xc,%esp
  80353c:	ff 75 f4             	pushl  -0xc(%ebp)
  80353f:	e8 72 fc ff ff       	call   8031b6 <addToAvailMemBlocksList>
  803544:	83 c4 10             	add    $0x10,%esp
					//Insert
					else {
						LIST_INSERT_BEFORE(&FreeMemBlocksList, iterator,
								blockToInsert);
					}
					break;
  803547:	e9 2e 01 00 00       	jmp    80367a <insert_sorted_with_merge_freeList+0x444>
						LIST_REMOVE(&FreeMemBlocksList, iterator);
						addToAvailMemBlocksList(blockToInsert);
						addToAvailMemBlocksList(iterator);
					}
					//previous merge
					else if (prev->sva + prev->size == blockToInsert->sva) {
  80354c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80354f:	8b 50 08             	mov    0x8(%eax),%edx
  803552:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803555:	8b 40 0c             	mov    0xc(%eax),%eax
  803558:	01 c2                	add    %eax,%edx
  80355a:	8b 45 08             	mov    0x8(%ebp),%eax
  80355d:	8b 40 08             	mov    0x8(%eax),%eax
  803560:	39 c2                	cmp    %eax,%edx
  803562:	75 27                	jne    80358b <insert_sorted_with_merge_freeList+0x355>
						prev->size = prev->size + blockToInsert->size;
  803564:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803567:	8b 50 0c             	mov    0xc(%eax),%edx
  80356a:	8b 45 08             	mov    0x8(%ebp),%eax
  80356d:	8b 40 0c             	mov    0xc(%eax),%eax
  803570:	01 c2                	add    %eax,%edx
  803572:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803575:	89 50 0c             	mov    %edx,0xc(%eax)
						addToAvailMemBlocksList(blockToInsert);
  803578:	83 ec 0c             	sub    $0xc,%esp
  80357b:	ff 75 08             	pushl  0x8(%ebp)
  80357e:	e8 33 fc ff ff       	call   8031b6 <addToAvailMemBlocksList>
  803583:	83 c4 10             	add    $0x10,%esp
					//Insert
					else {
						LIST_INSERT_BEFORE(&FreeMemBlocksList, iterator,
								blockToInsert);
					}
					break;
  803586:	e9 ef 00 00 00       	jmp    80367a <insert_sorted_with_merge_freeList+0x444>
					else if (prev->sva + prev->size == blockToInsert->sva) {
						prev->size = prev->size + blockToInsert->size;
						addToAvailMemBlocksList(blockToInsert);
					}
					//next merge
					else if (blockToInsert->size + blockToInsert->sva
  80358b:	8b 45 08             	mov    0x8(%ebp),%eax
  80358e:	8b 50 0c             	mov    0xc(%eax),%edx
  803591:	8b 45 08             	mov    0x8(%ebp),%eax
  803594:	8b 40 08             	mov    0x8(%eax),%eax
  803597:	01 c2                	add    %eax,%edx
							== iterator->sva) {
  803599:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80359c:	8b 40 08             	mov    0x8(%eax),%eax
					else if (prev->sva + prev->size == blockToInsert->sva) {
						prev->size = prev->size + blockToInsert->size;
						addToAvailMemBlocksList(blockToInsert);
					}
					//next merge
					else if (blockToInsert->size + blockToInsert->sva
  80359f:	39 c2                	cmp    %eax,%edx
  8035a1:	75 33                	jne    8035d6 <insert_sorted_with_merge_freeList+0x3a0>
							== iterator->sva) {
						iterator->sva = blockToInsert->sva;
  8035a3:	8b 45 08             	mov    0x8(%ebp),%eax
  8035a6:	8b 50 08             	mov    0x8(%eax),%edx
  8035a9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8035ac:	89 50 08             	mov    %edx,0x8(%eax)
						iterator->size = iterator->size + blockToInsert->size;
  8035af:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8035b2:	8b 50 0c             	mov    0xc(%eax),%edx
  8035b5:	8b 45 08             	mov    0x8(%ebp),%eax
  8035b8:	8b 40 0c             	mov    0xc(%eax),%eax
  8035bb:	01 c2                	add    %eax,%edx
  8035bd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8035c0:	89 50 0c             	mov    %edx,0xc(%eax)
						addToAvailMemBlocksList(blockToInsert);
  8035c3:	83 ec 0c             	sub    $0xc,%esp
  8035c6:	ff 75 08             	pushl  0x8(%ebp)
  8035c9:	e8 e8 fb ff ff       	call   8031b6 <addToAvailMemBlocksList>
  8035ce:	83 c4 10             	add    $0x10,%esp
					//Insert
					else {
						LIST_INSERT_BEFORE(&FreeMemBlocksList, iterator,
								blockToInsert);
					}
					break;
  8035d1:	e9 a4 00 00 00       	jmp    80367a <insert_sorted_with_merge_freeList+0x444>
						iterator->size = iterator->size + blockToInsert->size;
						addToAvailMemBlocksList(blockToInsert);
					}
					//Insert
					else {
						LIST_INSERT_BEFORE(&FreeMemBlocksList, iterator,
  8035d6:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8035da:	74 06                	je     8035e2 <insert_sorted_with_merge_freeList+0x3ac>
  8035dc:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8035e0:	75 17                	jne    8035f9 <insert_sorted_with_merge_freeList+0x3c3>
  8035e2:	83 ec 04             	sub    $0x4,%esp
  8035e5:	68 1c 43 80 00       	push   $0x80431c
  8035ea:	68 56 01 00 00       	push   $0x156
  8035ef:	68 8b 42 80 00       	push   $0x80428b
  8035f4:	e8 a4 d2 ff ff       	call   80089d <_panic>
  8035f9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8035fc:	8b 50 04             	mov    0x4(%eax),%edx
  8035ff:	8b 45 08             	mov    0x8(%ebp),%eax
  803602:	89 50 04             	mov    %edx,0x4(%eax)
  803605:	8b 45 08             	mov    0x8(%ebp),%eax
  803608:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80360b:	89 10                	mov    %edx,(%eax)
  80360d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803610:	8b 40 04             	mov    0x4(%eax),%eax
  803613:	85 c0                	test   %eax,%eax
  803615:	74 0d                	je     803624 <insert_sorted_with_merge_freeList+0x3ee>
  803617:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80361a:	8b 40 04             	mov    0x4(%eax),%eax
  80361d:	8b 55 08             	mov    0x8(%ebp),%edx
  803620:	89 10                	mov    %edx,(%eax)
  803622:	eb 08                	jmp    80362c <insert_sorted_with_merge_freeList+0x3f6>
  803624:	8b 45 08             	mov    0x8(%ebp),%eax
  803627:	a3 38 51 80 00       	mov    %eax,0x805138
  80362c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80362f:	8b 55 08             	mov    0x8(%ebp),%edx
  803632:	89 50 04             	mov    %edx,0x4(%eax)
  803635:	a1 44 51 80 00       	mov    0x805144,%eax
  80363a:	40                   	inc    %eax
  80363b:	a3 44 51 80 00       	mov    %eax,0x805144
								blockToInsert);
					}
					break;
  803640:	eb 38                	jmp    80367a <insert_sorted_with_merge_freeList+0x444>
		} else {
			LIST_INSERT_AFTER(&FreeMemBlocksList, last, blockToInsert);
		}
	} else {
		struct MemBlock *iterator;
		LIST_FOREACH(iterator, &(FreeMemBlocksList))
  803642:	a1 40 51 80 00       	mov    0x805140,%eax
  803647:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80364a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80364e:	74 07                	je     803657 <insert_sorted_with_merge_freeList+0x421>
  803650:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803653:	8b 00                	mov    (%eax),%eax
  803655:	eb 05                	jmp    80365c <insert_sorted_with_merge_freeList+0x426>
  803657:	b8 00 00 00 00       	mov    $0x0,%eax
  80365c:	a3 40 51 80 00       	mov    %eax,0x805140
  803661:	a1 40 51 80 00       	mov    0x805140,%eax
  803666:	85 c0                	test   %eax,%eax
  803668:	0f 85 1a fd ff ff    	jne    803388 <insert_sorted_with_merge_freeList+0x152>
  80366e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803672:	0f 85 10 fd ff ff    	jne    803388 <insert_sorted_with_merge_freeList+0x152>
		}
	}

	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  803678:	eb 00                	jmp    80367a <insert_sorted_with_merge_freeList+0x444>
  80367a:	90                   	nop
  80367b:	c9                   	leave  
  80367c:	c3                   	ret    
  80367d:	66 90                	xchg   %ax,%ax
  80367f:	90                   	nop

00803680 <__udivdi3>:
  803680:	55                   	push   %ebp
  803681:	57                   	push   %edi
  803682:	56                   	push   %esi
  803683:	53                   	push   %ebx
  803684:	83 ec 1c             	sub    $0x1c,%esp
  803687:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  80368b:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  80368f:	8b 7c 24 38          	mov    0x38(%esp),%edi
  803693:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  803697:	89 ca                	mov    %ecx,%edx
  803699:	89 f8                	mov    %edi,%eax
  80369b:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  80369f:	85 f6                	test   %esi,%esi
  8036a1:	75 2d                	jne    8036d0 <__udivdi3+0x50>
  8036a3:	39 cf                	cmp    %ecx,%edi
  8036a5:	77 65                	ja     80370c <__udivdi3+0x8c>
  8036a7:	89 fd                	mov    %edi,%ebp
  8036a9:	85 ff                	test   %edi,%edi
  8036ab:	75 0b                	jne    8036b8 <__udivdi3+0x38>
  8036ad:	b8 01 00 00 00       	mov    $0x1,%eax
  8036b2:	31 d2                	xor    %edx,%edx
  8036b4:	f7 f7                	div    %edi
  8036b6:	89 c5                	mov    %eax,%ebp
  8036b8:	31 d2                	xor    %edx,%edx
  8036ba:	89 c8                	mov    %ecx,%eax
  8036bc:	f7 f5                	div    %ebp
  8036be:	89 c1                	mov    %eax,%ecx
  8036c0:	89 d8                	mov    %ebx,%eax
  8036c2:	f7 f5                	div    %ebp
  8036c4:	89 cf                	mov    %ecx,%edi
  8036c6:	89 fa                	mov    %edi,%edx
  8036c8:	83 c4 1c             	add    $0x1c,%esp
  8036cb:	5b                   	pop    %ebx
  8036cc:	5e                   	pop    %esi
  8036cd:	5f                   	pop    %edi
  8036ce:	5d                   	pop    %ebp
  8036cf:	c3                   	ret    
  8036d0:	39 ce                	cmp    %ecx,%esi
  8036d2:	77 28                	ja     8036fc <__udivdi3+0x7c>
  8036d4:	0f bd fe             	bsr    %esi,%edi
  8036d7:	83 f7 1f             	xor    $0x1f,%edi
  8036da:	75 40                	jne    80371c <__udivdi3+0x9c>
  8036dc:	39 ce                	cmp    %ecx,%esi
  8036de:	72 0a                	jb     8036ea <__udivdi3+0x6a>
  8036e0:	3b 44 24 08          	cmp    0x8(%esp),%eax
  8036e4:	0f 87 9e 00 00 00    	ja     803788 <__udivdi3+0x108>
  8036ea:	b8 01 00 00 00       	mov    $0x1,%eax
  8036ef:	89 fa                	mov    %edi,%edx
  8036f1:	83 c4 1c             	add    $0x1c,%esp
  8036f4:	5b                   	pop    %ebx
  8036f5:	5e                   	pop    %esi
  8036f6:	5f                   	pop    %edi
  8036f7:	5d                   	pop    %ebp
  8036f8:	c3                   	ret    
  8036f9:	8d 76 00             	lea    0x0(%esi),%esi
  8036fc:	31 ff                	xor    %edi,%edi
  8036fe:	31 c0                	xor    %eax,%eax
  803700:	89 fa                	mov    %edi,%edx
  803702:	83 c4 1c             	add    $0x1c,%esp
  803705:	5b                   	pop    %ebx
  803706:	5e                   	pop    %esi
  803707:	5f                   	pop    %edi
  803708:	5d                   	pop    %ebp
  803709:	c3                   	ret    
  80370a:	66 90                	xchg   %ax,%ax
  80370c:	89 d8                	mov    %ebx,%eax
  80370e:	f7 f7                	div    %edi
  803710:	31 ff                	xor    %edi,%edi
  803712:	89 fa                	mov    %edi,%edx
  803714:	83 c4 1c             	add    $0x1c,%esp
  803717:	5b                   	pop    %ebx
  803718:	5e                   	pop    %esi
  803719:	5f                   	pop    %edi
  80371a:	5d                   	pop    %ebp
  80371b:	c3                   	ret    
  80371c:	bd 20 00 00 00       	mov    $0x20,%ebp
  803721:	89 eb                	mov    %ebp,%ebx
  803723:	29 fb                	sub    %edi,%ebx
  803725:	89 f9                	mov    %edi,%ecx
  803727:	d3 e6                	shl    %cl,%esi
  803729:	89 c5                	mov    %eax,%ebp
  80372b:	88 d9                	mov    %bl,%cl
  80372d:	d3 ed                	shr    %cl,%ebp
  80372f:	89 e9                	mov    %ebp,%ecx
  803731:	09 f1                	or     %esi,%ecx
  803733:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  803737:	89 f9                	mov    %edi,%ecx
  803739:	d3 e0                	shl    %cl,%eax
  80373b:	89 c5                	mov    %eax,%ebp
  80373d:	89 d6                	mov    %edx,%esi
  80373f:	88 d9                	mov    %bl,%cl
  803741:	d3 ee                	shr    %cl,%esi
  803743:	89 f9                	mov    %edi,%ecx
  803745:	d3 e2                	shl    %cl,%edx
  803747:	8b 44 24 08          	mov    0x8(%esp),%eax
  80374b:	88 d9                	mov    %bl,%cl
  80374d:	d3 e8                	shr    %cl,%eax
  80374f:	09 c2                	or     %eax,%edx
  803751:	89 d0                	mov    %edx,%eax
  803753:	89 f2                	mov    %esi,%edx
  803755:	f7 74 24 0c          	divl   0xc(%esp)
  803759:	89 d6                	mov    %edx,%esi
  80375b:	89 c3                	mov    %eax,%ebx
  80375d:	f7 e5                	mul    %ebp
  80375f:	39 d6                	cmp    %edx,%esi
  803761:	72 19                	jb     80377c <__udivdi3+0xfc>
  803763:	74 0b                	je     803770 <__udivdi3+0xf0>
  803765:	89 d8                	mov    %ebx,%eax
  803767:	31 ff                	xor    %edi,%edi
  803769:	e9 58 ff ff ff       	jmp    8036c6 <__udivdi3+0x46>
  80376e:	66 90                	xchg   %ax,%ax
  803770:	8b 54 24 08          	mov    0x8(%esp),%edx
  803774:	89 f9                	mov    %edi,%ecx
  803776:	d3 e2                	shl    %cl,%edx
  803778:	39 c2                	cmp    %eax,%edx
  80377a:	73 e9                	jae    803765 <__udivdi3+0xe5>
  80377c:	8d 43 ff             	lea    -0x1(%ebx),%eax
  80377f:	31 ff                	xor    %edi,%edi
  803781:	e9 40 ff ff ff       	jmp    8036c6 <__udivdi3+0x46>
  803786:	66 90                	xchg   %ax,%ax
  803788:	31 c0                	xor    %eax,%eax
  80378a:	e9 37 ff ff ff       	jmp    8036c6 <__udivdi3+0x46>
  80378f:	90                   	nop

00803790 <__umoddi3>:
  803790:	55                   	push   %ebp
  803791:	57                   	push   %edi
  803792:	56                   	push   %esi
  803793:	53                   	push   %ebx
  803794:	83 ec 1c             	sub    $0x1c,%esp
  803797:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  80379b:	8b 74 24 34          	mov    0x34(%esp),%esi
  80379f:	8b 7c 24 38          	mov    0x38(%esp),%edi
  8037a3:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  8037a7:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8037ab:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8037af:	89 f3                	mov    %esi,%ebx
  8037b1:	89 fa                	mov    %edi,%edx
  8037b3:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8037b7:	89 34 24             	mov    %esi,(%esp)
  8037ba:	85 c0                	test   %eax,%eax
  8037bc:	75 1a                	jne    8037d8 <__umoddi3+0x48>
  8037be:	39 f7                	cmp    %esi,%edi
  8037c0:	0f 86 a2 00 00 00    	jbe    803868 <__umoddi3+0xd8>
  8037c6:	89 c8                	mov    %ecx,%eax
  8037c8:	89 f2                	mov    %esi,%edx
  8037ca:	f7 f7                	div    %edi
  8037cc:	89 d0                	mov    %edx,%eax
  8037ce:	31 d2                	xor    %edx,%edx
  8037d0:	83 c4 1c             	add    $0x1c,%esp
  8037d3:	5b                   	pop    %ebx
  8037d4:	5e                   	pop    %esi
  8037d5:	5f                   	pop    %edi
  8037d6:	5d                   	pop    %ebp
  8037d7:	c3                   	ret    
  8037d8:	39 f0                	cmp    %esi,%eax
  8037da:	0f 87 ac 00 00 00    	ja     80388c <__umoddi3+0xfc>
  8037e0:	0f bd e8             	bsr    %eax,%ebp
  8037e3:	83 f5 1f             	xor    $0x1f,%ebp
  8037e6:	0f 84 ac 00 00 00    	je     803898 <__umoddi3+0x108>
  8037ec:	bf 20 00 00 00       	mov    $0x20,%edi
  8037f1:	29 ef                	sub    %ebp,%edi
  8037f3:	89 fe                	mov    %edi,%esi
  8037f5:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  8037f9:	89 e9                	mov    %ebp,%ecx
  8037fb:	d3 e0                	shl    %cl,%eax
  8037fd:	89 d7                	mov    %edx,%edi
  8037ff:	89 f1                	mov    %esi,%ecx
  803801:	d3 ef                	shr    %cl,%edi
  803803:	09 c7                	or     %eax,%edi
  803805:	89 e9                	mov    %ebp,%ecx
  803807:	d3 e2                	shl    %cl,%edx
  803809:	89 14 24             	mov    %edx,(%esp)
  80380c:	89 d8                	mov    %ebx,%eax
  80380e:	d3 e0                	shl    %cl,%eax
  803810:	89 c2                	mov    %eax,%edx
  803812:	8b 44 24 08          	mov    0x8(%esp),%eax
  803816:	d3 e0                	shl    %cl,%eax
  803818:	89 44 24 04          	mov    %eax,0x4(%esp)
  80381c:	8b 44 24 08          	mov    0x8(%esp),%eax
  803820:	89 f1                	mov    %esi,%ecx
  803822:	d3 e8                	shr    %cl,%eax
  803824:	09 d0                	or     %edx,%eax
  803826:	d3 eb                	shr    %cl,%ebx
  803828:	89 da                	mov    %ebx,%edx
  80382a:	f7 f7                	div    %edi
  80382c:	89 d3                	mov    %edx,%ebx
  80382e:	f7 24 24             	mull   (%esp)
  803831:	89 c6                	mov    %eax,%esi
  803833:	89 d1                	mov    %edx,%ecx
  803835:	39 d3                	cmp    %edx,%ebx
  803837:	0f 82 87 00 00 00    	jb     8038c4 <__umoddi3+0x134>
  80383d:	0f 84 91 00 00 00    	je     8038d4 <__umoddi3+0x144>
  803843:	8b 54 24 04          	mov    0x4(%esp),%edx
  803847:	29 f2                	sub    %esi,%edx
  803849:	19 cb                	sbb    %ecx,%ebx
  80384b:	89 d8                	mov    %ebx,%eax
  80384d:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  803851:	d3 e0                	shl    %cl,%eax
  803853:	89 e9                	mov    %ebp,%ecx
  803855:	d3 ea                	shr    %cl,%edx
  803857:	09 d0                	or     %edx,%eax
  803859:	89 e9                	mov    %ebp,%ecx
  80385b:	d3 eb                	shr    %cl,%ebx
  80385d:	89 da                	mov    %ebx,%edx
  80385f:	83 c4 1c             	add    $0x1c,%esp
  803862:	5b                   	pop    %ebx
  803863:	5e                   	pop    %esi
  803864:	5f                   	pop    %edi
  803865:	5d                   	pop    %ebp
  803866:	c3                   	ret    
  803867:	90                   	nop
  803868:	89 fd                	mov    %edi,%ebp
  80386a:	85 ff                	test   %edi,%edi
  80386c:	75 0b                	jne    803879 <__umoddi3+0xe9>
  80386e:	b8 01 00 00 00       	mov    $0x1,%eax
  803873:	31 d2                	xor    %edx,%edx
  803875:	f7 f7                	div    %edi
  803877:	89 c5                	mov    %eax,%ebp
  803879:	89 f0                	mov    %esi,%eax
  80387b:	31 d2                	xor    %edx,%edx
  80387d:	f7 f5                	div    %ebp
  80387f:	89 c8                	mov    %ecx,%eax
  803881:	f7 f5                	div    %ebp
  803883:	89 d0                	mov    %edx,%eax
  803885:	e9 44 ff ff ff       	jmp    8037ce <__umoddi3+0x3e>
  80388a:	66 90                	xchg   %ax,%ax
  80388c:	89 c8                	mov    %ecx,%eax
  80388e:	89 f2                	mov    %esi,%edx
  803890:	83 c4 1c             	add    $0x1c,%esp
  803893:	5b                   	pop    %ebx
  803894:	5e                   	pop    %esi
  803895:	5f                   	pop    %edi
  803896:	5d                   	pop    %ebp
  803897:	c3                   	ret    
  803898:	3b 04 24             	cmp    (%esp),%eax
  80389b:	72 06                	jb     8038a3 <__umoddi3+0x113>
  80389d:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  8038a1:	77 0f                	ja     8038b2 <__umoddi3+0x122>
  8038a3:	89 f2                	mov    %esi,%edx
  8038a5:	29 f9                	sub    %edi,%ecx
  8038a7:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  8038ab:	89 14 24             	mov    %edx,(%esp)
  8038ae:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8038b2:	8b 44 24 04          	mov    0x4(%esp),%eax
  8038b6:	8b 14 24             	mov    (%esp),%edx
  8038b9:	83 c4 1c             	add    $0x1c,%esp
  8038bc:	5b                   	pop    %ebx
  8038bd:	5e                   	pop    %esi
  8038be:	5f                   	pop    %edi
  8038bf:	5d                   	pop    %ebp
  8038c0:	c3                   	ret    
  8038c1:	8d 76 00             	lea    0x0(%esi),%esi
  8038c4:	2b 04 24             	sub    (%esp),%eax
  8038c7:	19 fa                	sbb    %edi,%edx
  8038c9:	89 d1                	mov    %edx,%ecx
  8038cb:	89 c6                	mov    %eax,%esi
  8038cd:	e9 71 ff ff ff       	jmp    803843 <__umoddi3+0xb3>
  8038d2:	66 90                	xchg   %ax,%ax
  8038d4:	39 44 24 04          	cmp    %eax,0x4(%esp)
  8038d8:	72 ea                	jb     8038c4 <__umoddi3+0x134>
  8038da:	89 d9                	mov    %ebx,%ecx
  8038dc:	e9 62 ff ff ff       	jmp    803843 <__umoddi3+0xb3>
