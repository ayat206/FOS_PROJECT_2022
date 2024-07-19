
obj/user/ef_mergesort_leakage:     file format elf32-i386


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
  800031:	e8 9a 07 00 00       	call   8007d0 <libmain>
1:      jmp 1b
  800036:	eb fe                	jmp    800036 <args_exist+0x5>

00800038 <_main>:
void Merge(int* A, int p, int q, int r);

uint32 CheckSorted(int *Elements, int NumOfElements);

void _main(void)
{
  800038:	55                   	push   %ebp
  800039:	89 e5                	mov    %esp,%ebp
  80003b:	81 ec 28 01 00 00    	sub    $0x128,%esp
	char Line[255] ;
	char Chose ;
	int numOfRep = 0;
  800041:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	do
	{
		numOfRep++ ;
  800048:	ff 45 f0             	incl   -0x10(%ebp)
		//2012: lock the interrupt
		sys_disable_interrupt();
  80004b:	e8 fb 1f 00 00       	call   80204b <sys_disable_interrupt>

		cprintf("\n");
  800050:	83 ec 0c             	sub    $0xc,%esp
  800053:	68 60 37 80 00       	push   $0x803760
  800058:	e8 63 0b 00 00       	call   800bc0 <cprintf>
  80005d:	83 c4 10             	add    $0x10,%esp
		cprintf("!!!!!!!!!!!!!!!!!!!!\n");
  800060:	83 ec 0c             	sub    $0xc,%esp
  800063:	68 62 37 80 00       	push   $0x803762
  800068:	e8 53 0b 00 00       	call   800bc0 <cprintf>
  80006d:	83 c4 10             	add    $0x10,%esp
		cprintf("!!!! MERGE SORT !!!!\n");
  800070:	83 ec 0c             	sub    $0xc,%esp
  800073:	68 78 37 80 00       	push   $0x803778
  800078:	e8 43 0b 00 00       	call   800bc0 <cprintf>
  80007d:	83 c4 10             	add    $0x10,%esp
		cprintf("!!!!!!!!!!!!!!!!!!!!\n");
  800080:	83 ec 0c             	sub    $0xc,%esp
  800083:	68 62 37 80 00       	push   $0x803762
  800088:	e8 33 0b 00 00       	call   800bc0 <cprintf>
  80008d:	83 c4 10             	add    $0x10,%esp
		cprintf("\n");
  800090:	83 ec 0c             	sub    $0xc,%esp
  800093:	68 60 37 80 00       	push   $0x803760
  800098:	e8 23 0b 00 00       	call   800bc0 <cprintf>
  80009d:	83 c4 10             	add    $0x10,%esp
		cprintf("Enter the number of elements: ");
  8000a0:	83 ec 0c             	sub    $0xc,%esp
  8000a3:	68 90 37 80 00       	push   $0x803790
  8000a8:	e8 13 0b 00 00       	call   800bc0 <cprintf>
  8000ad:	83 c4 10             	add    $0x10,%esp

		int NumOfElements ;

		if (numOfRep == 1)
  8000b0:	83 7d f0 01          	cmpl   $0x1,-0x10(%ebp)
  8000b4:	75 09                	jne    8000bf <_main+0x87>
			NumOfElements = 32;
  8000b6:	c7 45 ec 20 00 00 00 	movl   $0x20,-0x14(%ebp)
  8000bd:	eb 0d                	jmp    8000cc <_main+0x94>
		else if (numOfRep == 2)
  8000bf:	83 7d f0 02          	cmpl   $0x2,-0x10(%ebp)
  8000c3:	75 07                	jne    8000cc <_main+0x94>
			NumOfElements = 32;
  8000c5:	c7 45 ec 20 00 00 00 	movl   $0x20,-0x14(%ebp)

		cprintf("%d\n", NumOfElements) ;
  8000cc:	83 ec 08             	sub    $0x8,%esp
  8000cf:	ff 75 ec             	pushl  -0x14(%ebp)
  8000d2:	68 af 37 80 00       	push   $0x8037af
  8000d7:	e8 e4 0a 00 00       	call   800bc0 <cprintf>
  8000dc:	83 c4 10             	add    $0x10,%esp

		int *Elements = malloc(sizeof(int) * NumOfElements) ;
  8000df:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8000e2:	c1 e0 02             	shl    $0x2,%eax
  8000e5:	83 ec 0c             	sub    $0xc,%esp
  8000e8:	50                   	push   %eax
  8000e9:	e8 64 1a 00 00       	call   801b52 <malloc>
  8000ee:	83 c4 10             	add    $0x10,%esp
  8000f1:	89 45 e8             	mov    %eax,-0x18(%ebp)
		cprintf("Chose the initialization method:\n") ;
  8000f4:	83 ec 0c             	sub    $0xc,%esp
  8000f7:	68 b4 37 80 00       	push   $0x8037b4
  8000fc:	e8 bf 0a 00 00       	call   800bc0 <cprintf>
  800101:	83 c4 10             	add    $0x10,%esp
		cprintf("a) Ascending\n") ;
  800104:	83 ec 0c             	sub    $0xc,%esp
  800107:	68 d6 37 80 00       	push   $0x8037d6
  80010c:	e8 af 0a 00 00       	call   800bc0 <cprintf>
  800111:	83 c4 10             	add    $0x10,%esp
		cprintf("b) Descending\n") ;
  800114:	83 ec 0c             	sub    $0xc,%esp
  800117:	68 e4 37 80 00       	push   $0x8037e4
  80011c:	e8 9f 0a 00 00       	call   800bc0 <cprintf>
  800121:	83 c4 10             	add    $0x10,%esp
		cprintf("c) Semi random\n");
  800124:	83 ec 0c             	sub    $0xc,%esp
  800127:	68 f3 37 80 00       	push   $0x8037f3
  80012c:	e8 8f 0a 00 00       	call   800bc0 <cprintf>
  800131:	83 c4 10             	add    $0x10,%esp
		do
		{
			cprintf("Select: ") ;
  800134:	83 ec 0c             	sub    $0xc,%esp
  800137:	68 03 38 80 00       	push   $0x803803
  80013c:	e8 7f 0a 00 00       	call   800bc0 <cprintf>
  800141:	83 c4 10             	add    $0x10,%esp
			if (numOfRep == 1)
  800144:	83 7d f0 01          	cmpl   $0x1,-0x10(%ebp)
  800148:	75 06                	jne    800150 <_main+0x118>
				Chose = 'a' ;
  80014a:	c6 45 f7 61          	movb   $0x61,-0x9(%ebp)
  80014e:	eb 0a                	jmp    80015a <_main+0x122>
			else if (numOfRep == 2)
  800150:	83 7d f0 02          	cmpl   $0x2,-0x10(%ebp)
  800154:	75 04                	jne    80015a <_main+0x122>
				Chose = 'c' ;
  800156:	c6 45 f7 63          	movb   $0x63,-0x9(%ebp)
			cputchar(Chose);
  80015a:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
  80015e:	83 ec 0c             	sub    $0xc,%esp
  800161:	50                   	push   %eax
  800162:	e8 c9 05 00 00       	call   800730 <cputchar>
  800167:	83 c4 10             	add    $0x10,%esp
			cputchar('\n');
  80016a:	83 ec 0c             	sub    $0xc,%esp
  80016d:	6a 0a                	push   $0xa
  80016f:	e8 bc 05 00 00       	call   800730 <cputchar>
  800174:	83 c4 10             	add    $0x10,%esp
		} while (Chose != 'a' && Chose != 'b' && Chose != 'c');
  800177:	80 7d f7 61          	cmpb   $0x61,-0x9(%ebp)
  80017b:	74 0c                	je     800189 <_main+0x151>
  80017d:	80 7d f7 62          	cmpb   $0x62,-0x9(%ebp)
  800181:	74 06                	je     800189 <_main+0x151>
  800183:	80 7d f7 63          	cmpb   $0x63,-0x9(%ebp)
  800187:	75 ab                	jne    800134 <_main+0xfc>

		//2012: lock the interrupt
		sys_enable_interrupt();
  800189:	e8 d7 1e 00 00       	call   802065 <sys_enable_interrupt>

		int  i ;
		switch (Chose)
  80018e:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
  800192:	83 f8 62             	cmp    $0x62,%eax
  800195:	74 1d                	je     8001b4 <_main+0x17c>
  800197:	83 f8 63             	cmp    $0x63,%eax
  80019a:	74 2b                	je     8001c7 <_main+0x18f>
  80019c:	83 f8 61             	cmp    $0x61,%eax
  80019f:	75 39                	jne    8001da <_main+0x1a2>
		{
		case 'a':
			InitializeAscending(Elements, NumOfElements);
  8001a1:	83 ec 08             	sub    $0x8,%esp
  8001a4:	ff 75 ec             	pushl  -0x14(%ebp)
  8001a7:	ff 75 e8             	pushl  -0x18(%ebp)
  8001aa:	e8 f4 01 00 00       	call   8003a3 <InitializeAscending>
  8001af:	83 c4 10             	add    $0x10,%esp
			break ;
  8001b2:	eb 37                	jmp    8001eb <_main+0x1b3>
		case 'b':
			InitializeDescending(Elements, NumOfElements);
  8001b4:	83 ec 08             	sub    $0x8,%esp
  8001b7:	ff 75 ec             	pushl  -0x14(%ebp)
  8001ba:	ff 75 e8             	pushl  -0x18(%ebp)
  8001bd:	e8 12 02 00 00       	call   8003d4 <InitializeDescending>
  8001c2:	83 c4 10             	add    $0x10,%esp
			break ;
  8001c5:	eb 24                	jmp    8001eb <_main+0x1b3>
		case 'c':
			InitializeSemiRandom(Elements, NumOfElements);
  8001c7:	83 ec 08             	sub    $0x8,%esp
  8001ca:	ff 75 ec             	pushl  -0x14(%ebp)
  8001cd:	ff 75 e8             	pushl  -0x18(%ebp)
  8001d0:	e8 34 02 00 00       	call   800409 <InitializeSemiRandom>
  8001d5:	83 c4 10             	add    $0x10,%esp
			break ;
  8001d8:	eb 11                	jmp    8001eb <_main+0x1b3>
		default:
			InitializeSemiRandom(Elements, NumOfElements);
  8001da:	83 ec 08             	sub    $0x8,%esp
  8001dd:	ff 75 ec             	pushl  -0x14(%ebp)
  8001e0:	ff 75 e8             	pushl  -0x18(%ebp)
  8001e3:	e8 21 02 00 00       	call   800409 <InitializeSemiRandom>
  8001e8:	83 c4 10             	add    $0x10,%esp
		}

		MSort(Elements, 1, NumOfElements);
  8001eb:	83 ec 04             	sub    $0x4,%esp
  8001ee:	ff 75 ec             	pushl  -0x14(%ebp)
  8001f1:	6a 01                	push   $0x1
  8001f3:	ff 75 e8             	pushl  -0x18(%ebp)
  8001f6:	e8 e0 02 00 00       	call   8004db <MSort>
  8001fb:	83 c4 10             	add    $0x10,%esp

		sys_disable_interrupt();
  8001fe:	e8 48 1e 00 00       	call   80204b <sys_disable_interrupt>
		cprintf("Sorting is Finished!!!!it'll be checked now....\n") ;
  800203:	83 ec 0c             	sub    $0xc,%esp
  800206:	68 0c 38 80 00       	push   $0x80380c
  80020b:	e8 b0 09 00 00       	call   800bc0 <cprintf>
  800210:	83 c4 10             	add    $0x10,%esp
		//PrintElements(Elements, NumOfElements);
		sys_enable_interrupt();
  800213:	e8 4d 1e 00 00       	call   802065 <sys_enable_interrupt>

		uint32 Sorted = CheckSorted(Elements, NumOfElements);
  800218:	83 ec 08             	sub    $0x8,%esp
  80021b:	ff 75 ec             	pushl  -0x14(%ebp)
  80021e:	ff 75 e8             	pushl  -0x18(%ebp)
  800221:	e8 d3 00 00 00       	call   8002f9 <CheckSorted>
  800226:	83 c4 10             	add    $0x10,%esp
  800229:	89 45 e4             	mov    %eax,-0x1c(%ebp)

		if(Sorted == 0) panic("The array is NOT sorted correctly") ;
  80022c:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800230:	75 14                	jne    800246 <_main+0x20e>
  800232:	83 ec 04             	sub    $0x4,%esp
  800235:	68 40 38 80 00       	push   $0x803840
  80023a:	6a 58                	push   $0x58
  80023c:	68 62 38 80 00       	push   $0x803862
  800241:	e8 c6 06 00 00       	call   80090c <_panic>
		else
		{
			sys_disable_interrupt();
  800246:	e8 00 1e 00 00       	call   80204b <sys_disable_interrupt>
			cprintf("===============================================\n") ;
  80024b:	83 ec 0c             	sub    $0xc,%esp
  80024e:	68 80 38 80 00       	push   $0x803880
  800253:	e8 68 09 00 00       	call   800bc0 <cprintf>
  800258:	83 c4 10             	add    $0x10,%esp
			cprintf("Congratulations!! The array is sorted correctly\n") ;
  80025b:	83 ec 0c             	sub    $0xc,%esp
  80025e:	68 b4 38 80 00       	push   $0x8038b4
  800263:	e8 58 09 00 00       	call   800bc0 <cprintf>
  800268:	83 c4 10             	add    $0x10,%esp
			cprintf("===============================================\n\n") ;
  80026b:	83 ec 0c             	sub    $0xc,%esp
  80026e:	68 e8 38 80 00       	push   $0x8038e8
  800273:	e8 48 09 00 00       	call   800bc0 <cprintf>
  800278:	83 c4 10             	add    $0x10,%esp
			sys_enable_interrupt();
  80027b:	e8 e5 1d 00 00       	call   802065 <sys_enable_interrupt>
		}

		//free(Elements) ;

		sys_disable_interrupt();
  800280:	e8 c6 1d 00 00       	call   80204b <sys_disable_interrupt>
		Chose = 0 ;
  800285:	c6 45 f7 00          	movb   $0x0,-0x9(%ebp)
		while (Chose != 'y' && Chose != 'n')
  800289:	eb 50                	jmp    8002db <_main+0x2a3>
		{
			cprintf("Do you want to repeat (y/n): ") ;
  80028b:	83 ec 0c             	sub    $0xc,%esp
  80028e:	68 1a 39 80 00       	push   $0x80391a
  800293:	e8 28 09 00 00       	call   800bc0 <cprintf>
  800298:	83 c4 10             	add    $0x10,%esp
			if (numOfRep == 1)
  80029b:	83 7d f0 01          	cmpl   $0x1,-0x10(%ebp)
  80029f:	75 06                	jne    8002a7 <_main+0x26f>
				Chose = 'y' ;
  8002a1:	c6 45 f7 79          	movb   $0x79,-0x9(%ebp)
  8002a5:	eb 0a                	jmp    8002b1 <_main+0x279>
			else if (numOfRep == 2)
  8002a7:	83 7d f0 02          	cmpl   $0x2,-0x10(%ebp)
  8002ab:	75 04                	jne    8002b1 <_main+0x279>
				Chose = 'n' ;
  8002ad:	c6 45 f7 6e          	movb   $0x6e,-0x9(%ebp)
			cputchar(Chose);
  8002b1:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
  8002b5:	83 ec 0c             	sub    $0xc,%esp
  8002b8:	50                   	push   %eax
  8002b9:	e8 72 04 00 00       	call   800730 <cputchar>
  8002be:	83 c4 10             	add    $0x10,%esp
			cputchar('\n');
  8002c1:	83 ec 0c             	sub    $0xc,%esp
  8002c4:	6a 0a                	push   $0xa
  8002c6:	e8 65 04 00 00       	call   800730 <cputchar>
  8002cb:	83 c4 10             	add    $0x10,%esp
			cputchar('\n');
  8002ce:	83 ec 0c             	sub    $0xc,%esp
  8002d1:	6a 0a                	push   $0xa
  8002d3:	e8 58 04 00 00       	call   800730 <cputchar>
  8002d8:	83 c4 10             	add    $0x10,%esp

		//free(Elements) ;

		sys_disable_interrupt();
		Chose = 0 ;
		while (Chose != 'y' && Chose != 'n')
  8002db:	80 7d f7 79          	cmpb   $0x79,-0x9(%ebp)
  8002df:	74 06                	je     8002e7 <_main+0x2af>
  8002e1:	80 7d f7 6e          	cmpb   $0x6e,-0x9(%ebp)
  8002e5:	75 a4                	jne    80028b <_main+0x253>
				Chose = 'n' ;
			cputchar(Chose);
			cputchar('\n');
			cputchar('\n');
		}
		sys_enable_interrupt();
  8002e7:	e8 79 1d 00 00       	call   802065 <sys_enable_interrupt>

	} while (Chose == 'y');
  8002ec:	80 7d f7 79          	cmpb   $0x79,-0x9(%ebp)
  8002f0:	0f 84 52 fd ff ff    	je     800048 <_main+0x10>
}
  8002f6:	90                   	nop
  8002f7:	c9                   	leave  
  8002f8:	c3                   	ret    

008002f9 <CheckSorted>:


uint32 CheckSorted(int *Elements, int NumOfElements)
{
  8002f9:	55                   	push   %ebp
  8002fa:	89 e5                	mov    %esp,%ebp
  8002fc:	83 ec 10             	sub    $0x10,%esp
	uint32 Sorted = 1 ;
  8002ff:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
	int i ;
	for (i = 0 ; i < NumOfElements - 1; i++)
  800306:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  80030d:	eb 33                	jmp    800342 <CheckSorted+0x49>
	{
		if (Elements[i] > Elements[i+1])
  80030f:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800312:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800319:	8b 45 08             	mov    0x8(%ebp),%eax
  80031c:	01 d0                	add    %edx,%eax
  80031e:	8b 10                	mov    (%eax),%edx
  800320:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800323:	40                   	inc    %eax
  800324:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  80032b:	8b 45 08             	mov    0x8(%ebp),%eax
  80032e:	01 c8                	add    %ecx,%eax
  800330:	8b 00                	mov    (%eax),%eax
  800332:	39 c2                	cmp    %eax,%edx
  800334:	7e 09                	jle    80033f <CheckSorted+0x46>
		{
			Sorted = 0 ;
  800336:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
			break;
  80033d:	eb 0c                	jmp    80034b <CheckSorted+0x52>

uint32 CheckSorted(int *Elements, int NumOfElements)
{
	uint32 Sorted = 1 ;
	int i ;
	for (i = 0 ; i < NumOfElements - 1; i++)
  80033f:	ff 45 f8             	incl   -0x8(%ebp)
  800342:	8b 45 0c             	mov    0xc(%ebp),%eax
  800345:	48                   	dec    %eax
  800346:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800349:	7f c4                	jg     80030f <CheckSorted+0x16>
		{
			Sorted = 0 ;
			break;
		}
	}
	return Sorted ;
  80034b:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  80034e:	c9                   	leave  
  80034f:	c3                   	ret    

00800350 <Swap>:

///Private Functions


void Swap(int *Elements, int First, int Second)
{
  800350:	55                   	push   %ebp
  800351:	89 e5                	mov    %esp,%ebp
  800353:	83 ec 10             	sub    $0x10,%esp
	int Tmp = Elements[First] ;
  800356:	8b 45 0c             	mov    0xc(%ebp),%eax
  800359:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800360:	8b 45 08             	mov    0x8(%ebp),%eax
  800363:	01 d0                	add    %edx,%eax
  800365:	8b 00                	mov    (%eax),%eax
  800367:	89 45 fc             	mov    %eax,-0x4(%ebp)
	Elements[First] = Elements[Second] ;
  80036a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80036d:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800374:	8b 45 08             	mov    0x8(%ebp),%eax
  800377:	01 c2                	add    %eax,%edx
  800379:	8b 45 10             	mov    0x10(%ebp),%eax
  80037c:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  800383:	8b 45 08             	mov    0x8(%ebp),%eax
  800386:	01 c8                	add    %ecx,%eax
  800388:	8b 00                	mov    (%eax),%eax
  80038a:	89 02                	mov    %eax,(%edx)
	Elements[Second] = Tmp ;
  80038c:	8b 45 10             	mov    0x10(%ebp),%eax
  80038f:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800396:	8b 45 08             	mov    0x8(%ebp),%eax
  800399:	01 c2                	add    %eax,%edx
  80039b:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80039e:	89 02                	mov    %eax,(%edx)
}
  8003a0:	90                   	nop
  8003a1:	c9                   	leave  
  8003a2:	c3                   	ret    

008003a3 <InitializeAscending>:

void InitializeAscending(int *Elements, int NumOfElements)
{
  8003a3:	55                   	push   %ebp
  8003a4:	89 e5                	mov    %esp,%ebp
  8003a6:	83 ec 10             	sub    $0x10,%esp
	int i ;
	for (i = 0 ; i < NumOfElements ; i++)
  8003a9:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8003b0:	eb 17                	jmp    8003c9 <InitializeAscending+0x26>
	{
		(Elements)[i] = i ;
  8003b2:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8003b5:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8003bc:	8b 45 08             	mov    0x8(%ebp),%eax
  8003bf:	01 c2                	add    %eax,%edx
  8003c1:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8003c4:	89 02                	mov    %eax,(%edx)
}

void InitializeAscending(int *Elements, int NumOfElements)
{
	int i ;
	for (i = 0 ; i < NumOfElements ; i++)
  8003c6:	ff 45 fc             	incl   -0x4(%ebp)
  8003c9:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8003cc:	3b 45 0c             	cmp    0xc(%ebp),%eax
  8003cf:	7c e1                	jl     8003b2 <InitializeAscending+0xf>
	{
		(Elements)[i] = i ;
	}

}
  8003d1:	90                   	nop
  8003d2:	c9                   	leave  
  8003d3:	c3                   	ret    

008003d4 <InitializeDescending>:

void InitializeDescending(int *Elements, int NumOfElements)
{
  8003d4:	55                   	push   %ebp
  8003d5:	89 e5                	mov    %esp,%ebp
  8003d7:	83 ec 10             	sub    $0x10,%esp
	int i ;
	for (i = 0 ; i < NumOfElements ; i++)
  8003da:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8003e1:	eb 1b                	jmp    8003fe <InitializeDescending+0x2a>
	{
		Elements[i] = NumOfElements - i - 1 ;
  8003e3:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8003e6:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8003ed:	8b 45 08             	mov    0x8(%ebp),%eax
  8003f0:	01 c2                	add    %eax,%edx
  8003f2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8003f5:	2b 45 fc             	sub    -0x4(%ebp),%eax
  8003f8:	48                   	dec    %eax
  8003f9:	89 02                	mov    %eax,(%edx)
}

void InitializeDescending(int *Elements, int NumOfElements)
{
	int i ;
	for (i = 0 ; i < NumOfElements ; i++)
  8003fb:	ff 45 fc             	incl   -0x4(%ebp)
  8003fe:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800401:	3b 45 0c             	cmp    0xc(%ebp),%eax
  800404:	7c dd                	jl     8003e3 <InitializeDescending+0xf>
	{
		Elements[i] = NumOfElements - i - 1 ;
	}

}
  800406:	90                   	nop
  800407:	c9                   	leave  
  800408:	c3                   	ret    

00800409 <InitializeSemiRandom>:

void InitializeSemiRandom(int *Elements, int NumOfElements)
{
  800409:	55                   	push   %ebp
  80040a:	89 e5                	mov    %esp,%ebp
  80040c:	83 ec 10             	sub    $0x10,%esp
	int i ;
	int Repetition = NumOfElements / 3 ;
  80040f:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800412:	b8 56 55 55 55       	mov    $0x55555556,%eax
  800417:	f7 e9                	imul   %ecx
  800419:	c1 f9 1f             	sar    $0x1f,%ecx
  80041c:	89 d0                	mov    %edx,%eax
  80041e:	29 c8                	sub    %ecx,%eax
  800420:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0 ; i < NumOfElements ; i++)
  800423:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  80042a:	eb 1e                	jmp    80044a <InitializeSemiRandom+0x41>
	{
		Elements[i] = i % Repetition ;
  80042c:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80042f:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800436:	8b 45 08             	mov    0x8(%ebp),%eax
  800439:	8d 0c 02             	lea    (%edx,%eax,1),%ecx
  80043c:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80043f:	99                   	cltd   
  800440:	f7 7d f8             	idivl  -0x8(%ebp)
  800443:	89 d0                	mov    %edx,%eax
  800445:	89 01                	mov    %eax,(%ecx)

void InitializeSemiRandom(int *Elements, int NumOfElements)
{
	int i ;
	int Repetition = NumOfElements / 3 ;
	for (i = 0 ; i < NumOfElements ; i++)
  800447:	ff 45 fc             	incl   -0x4(%ebp)
  80044a:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80044d:	3b 45 0c             	cmp    0xc(%ebp),%eax
  800450:	7c da                	jl     80042c <InitializeSemiRandom+0x23>
	{
		Elements[i] = i % Repetition ;
		//	cprintf("i=%d\n",i);
	}

}
  800452:	90                   	nop
  800453:	c9                   	leave  
  800454:	c3                   	ret    

00800455 <PrintElements>:

void PrintElements(int *Elements, int NumOfElements)
{
  800455:	55                   	push   %ebp
  800456:	89 e5                	mov    %esp,%ebp
  800458:	83 ec 18             	sub    $0x18,%esp
	int i ;
	int NumsPerLine = 20 ;
  80045b:	c7 45 f0 14 00 00 00 	movl   $0x14,-0x10(%ebp)
	for (i = 0 ; i < NumOfElements-1 ; i++)
  800462:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  800469:	eb 42                	jmp    8004ad <PrintElements+0x58>
	{
		if (i%NumsPerLine == 0)
  80046b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80046e:	99                   	cltd   
  80046f:	f7 7d f0             	idivl  -0x10(%ebp)
  800472:	89 d0                	mov    %edx,%eax
  800474:	85 c0                	test   %eax,%eax
  800476:	75 10                	jne    800488 <PrintElements+0x33>
			cprintf("\n");
  800478:	83 ec 0c             	sub    $0xc,%esp
  80047b:	68 60 37 80 00       	push   $0x803760
  800480:	e8 3b 07 00 00       	call   800bc0 <cprintf>
  800485:	83 c4 10             	add    $0x10,%esp
		cprintf("%d, ",Elements[i]);
  800488:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80048b:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800492:	8b 45 08             	mov    0x8(%ebp),%eax
  800495:	01 d0                	add    %edx,%eax
  800497:	8b 00                	mov    (%eax),%eax
  800499:	83 ec 08             	sub    $0x8,%esp
  80049c:	50                   	push   %eax
  80049d:	68 38 39 80 00       	push   $0x803938
  8004a2:	e8 19 07 00 00       	call   800bc0 <cprintf>
  8004a7:	83 c4 10             	add    $0x10,%esp

void PrintElements(int *Elements, int NumOfElements)
{
	int i ;
	int NumsPerLine = 20 ;
	for (i = 0 ; i < NumOfElements-1 ; i++)
  8004aa:	ff 45 f4             	incl   -0xc(%ebp)
  8004ad:	8b 45 0c             	mov    0xc(%ebp),%eax
  8004b0:	48                   	dec    %eax
  8004b1:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  8004b4:	7f b5                	jg     80046b <PrintElements+0x16>
	{
		if (i%NumsPerLine == 0)
			cprintf("\n");
		cprintf("%d, ",Elements[i]);
	}
	cprintf("%d\n",Elements[i]);
  8004b6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8004b9:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8004c0:	8b 45 08             	mov    0x8(%ebp),%eax
  8004c3:	01 d0                	add    %edx,%eax
  8004c5:	8b 00                	mov    (%eax),%eax
  8004c7:	83 ec 08             	sub    $0x8,%esp
  8004ca:	50                   	push   %eax
  8004cb:	68 af 37 80 00       	push   $0x8037af
  8004d0:	e8 eb 06 00 00       	call   800bc0 <cprintf>
  8004d5:	83 c4 10             	add    $0x10,%esp

}
  8004d8:	90                   	nop
  8004d9:	c9                   	leave  
  8004da:	c3                   	ret    

008004db <MSort>:


void MSort(int* A, int p, int r)
{
  8004db:	55                   	push   %ebp
  8004dc:	89 e5                	mov    %esp,%ebp
  8004de:	83 ec 18             	sub    $0x18,%esp
	if (p >= r)
  8004e1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8004e4:	3b 45 10             	cmp    0x10(%ebp),%eax
  8004e7:	7d 54                	jge    80053d <MSort+0x62>
	{
		return;
	}

	int q = (p + r) / 2;
  8004e9:	8b 55 0c             	mov    0xc(%ebp),%edx
  8004ec:	8b 45 10             	mov    0x10(%ebp),%eax
  8004ef:	01 d0                	add    %edx,%eax
  8004f1:	89 c2                	mov    %eax,%edx
  8004f3:	c1 ea 1f             	shr    $0x1f,%edx
  8004f6:	01 d0                	add    %edx,%eax
  8004f8:	d1 f8                	sar    %eax
  8004fa:	89 45 f4             	mov    %eax,-0xc(%ebp)

	MSort(A, p, q);
  8004fd:	83 ec 04             	sub    $0x4,%esp
  800500:	ff 75 f4             	pushl  -0xc(%ebp)
  800503:	ff 75 0c             	pushl  0xc(%ebp)
  800506:	ff 75 08             	pushl  0x8(%ebp)
  800509:	e8 cd ff ff ff       	call   8004db <MSort>
  80050e:	83 c4 10             	add    $0x10,%esp

	MSort(A, q + 1, r);
  800511:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800514:	40                   	inc    %eax
  800515:	83 ec 04             	sub    $0x4,%esp
  800518:	ff 75 10             	pushl  0x10(%ebp)
  80051b:	50                   	push   %eax
  80051c:	ff 75 08             	pushl  0x8(%ebp)
  80051f:	e8 b7 ff ff ff       	call   8004db <MSort>
  800524:	83 c4 10             	add    $0x10,%esp

	Merge(A, p, q, r);
  800527:	ff 75 10             	pushl  0x10(%ebp)
  80052a:	ff 75 f4             	pushl  -0xc(%ebp)
  80052d:	ff 75 0c             	pushl  0xc(%ebp)
  800530:	ff 75 08             	pushl  0x8(%ebp)
  800533:	e8 08 00 00 00       	call   800540 <Merge>
  800538:	83 c4 10             	add    $0x10,%esp
  80053b:	eb 01                	jmp    80053e <MSort+0x63>

void MSort(int* A, int p, int r)
{
	if (p >= r)
	{
		return;
  80053d:	90                   	nop

	MSort(A, q + 1, r);

	Merge(A, p, q, r);

}
  80053e:	c9                   	leave  
  80053f:	c3                   	ret    

00800540 <Merge>:

void Merge(int* A, int p, int q, int r)
{
  800540:	55                   	push   %ebp
  800541:	89 e5                	mov    %esp,%ebp
  800543:	83 ec 38             	sub    $0x38,%esp
	int leftCapacity = q - p + 1;
  800546:	8b 45 10             	mov    0x10(%ebp),%eax
  800549:	2b 45 0c             	sub    0xc(%ebp),%eax
  80054c:	40                   	inc    %eax
  80054d:	89 45 e0             	mov    %eax,-0x20(%ebp)

	int rightCapacity = r - q;
  800550:	8b 45 14             	mov    0x14(%ebp),%eax
  800553:	2b 45 10             	sub    0x10(%ebp),%eax
  800556:	89 45 dc             	mov    %eax,-0x24(%ebp)

	int leftIndex = 0;
  800559:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	int rightIndex = 0;
  800560:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)

	int* Left = malloc(sizeof(int) * leftCapacity);
  800567:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80056a:	c1 e0 02             	shl    $0x2,%eax
  80056d:	83 ec 0c             	sub    $0xc,%esp
  800570:	50                   	push   %eax
  800571:	e8 dc 15 00 00       	call   801b52 <malloc>
  800576:	83 c4 10             	add    $0x10,%esp
  800579:	89 45 d8             	mov    %eax,-0x28(%ebp)

	int* Right = malloc(sizeof(int) * rightCapacity);
  80057c:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80057f:	c1 e0 02             	shl    $0x2,%eax
  800582:	83 ec 0c             	sub    $0xc,%esp
  800585:	50                   	push   %eax
  800586:	e8 c7 15 00 00       	call   801b52 <malloc>
  80058b:	83 c4 10             	add    $0x10,%esp
  80058e:	89 45 d4             	mov    %eax,-0x2c(%ebp)

	//	int Left[5000] ;
	//	int Right[5000] ;

	int i, j, k;
	for (i = 0; i < leftCapacity; i++)
  800591:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  800598:	eb 2f                	jmp    8005c9 <Merge+0x89>
	{
		Left[i] = A[p + i - 1];
  80059a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80059d:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8005a4:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8005a7:	01 c2                	add    %eax,%edx
  8005a9:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8005ac:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8005af:	01 c8                	add    %ecx,%eax
  8005b1:	05 ff ff ff 3f       	add    $0x3fffffff,%eax
  8005b6:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  8005bd:	8b 45 08             	mov    0x8(%ebp),%eax
  8005c0:	01 c8                	add    %ecx,%eax
  8005c2:	8b 00                	mov    (%eax),%eax
  8005c4:	89 02                	mov    %eax,(%edx)

	//	int Left[5000] ;
	//	int Right[5000] ;

	int i, j, k;
	for (i = 0; i < leftCapacity; i++)
  8005c6:	ff 45 ec             	incl   -0x14(%ebp)
  8005c9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8005cc:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  8005cf:	7c c9                	jl     80059a <Merge+0x5a>
	{
		Left[i] = A[p + i - 1];
	}
	for (j = 0; j < rightCapacity; j++)
  8005d1:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  8005d8:	eb 2a                	jmp    800604 <Merge+0xc4>
	{
		Right[j] = A[q + j];
  8005da:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8005dd:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8005e4:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8005e7:	01 c2                	add    %eax,%edx
  8005e9:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8005ec:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8005ef:	01 c8                	add    %ecx,%eax
  8005f1:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  8005f8:	8b 45 08             	mov    0x8(%ebp),%eax
  8005fb:	01 c8                	add    %ecx,%eax
  8005fd:	8b 00                	mov    (%eax),%eax
  8005ff:	89 02                	mov    %eax,(%edx)
	int i, j, k;
	for (i = 0; i < leftCapacity; i++)
	{
		Left[i] = A[p + i - 1];
	}
	for (j = 0; j < rightCapacity; j++)
  800601:	ff 45 e8             	incl   -0x18(%ebp)
  800604:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800607:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  80060a:	7c ce                	jl     8005da <Merge+0x9a>
	{
		Right[j] = A[q + j];
	}

	for ( k = p; k <= r; k++)
  80060c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80060f:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800612:	e9 0a 01 00 00       	jmp    800721 <Merge+0x1e1>
	{
		if (leftIndex < leftCapacity && rightIndex < rightCapacity)
  800617:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80061a:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  80061d:	0f 8d 95 00 00 00    	jge    8006b8 <Merge+0x178>
  800623:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800626:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  800629:	0f 8d 89 00 00 00    	jge    8006b8 <Merge+0x178>
		{
			if (Left[leftIndex] < Right[rightIndex] )
  80062f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800632:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800639:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80063c:	01 d0                	add    %edx,%eax
  80063e:	8b 10                	mov    (%eax),%edx
  800640:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800643:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  80064a:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80064d:	01 c8                	add    %ecx,%eax
  80064f:	8b 00                	mov    (%eax),%eax
  800651:	39 c2                	cmp    %eax,%edx
  800653:	7d 33                	jge    800688 <Merge+0x148>
			{
				A[k - 1] = Left[leftIndex++];
  800655:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800658:	05 ff ff ff 3f       	add    $0x3fffffff,%eax
  80065d:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800664:	8b 45 08             	mov    0x8(%ebp),%eax
  800667:	8d 0c 02             	lea    (%edx,%eax,1),%ecx
  80066a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80066d:	8d 50 01             	lea    0x1(%eax),%edx
  800670:	89 55 f4             	mov    %edx,-0xc(%ebp)
  800673:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80067a:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80067d:	01 d0                	add    %edx,%eax
  80067f:	8b 00                	mov    (%eax),%eax
  800681:	89 01                	mov    %eax,(%ecx)

	for ( k = p; k <= r; k++)
	{
		if (leftIndex < leftCapacity && rightIndex < rightCapacity)
		{
			if (Left[leftIndex] < Right[rightIndex] )
  800683:	e9 96 00 00 00       	jmp    80071e <Merge+0x1de>
			{
				A[k - 1] = Left[leftIndex++];
			}
			else
			{
				A[k - 1] = Right[rightIndex++];
  800688:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80068b:	05 ff ff ff 3f       	add    $0x3fffffff,%eax
  800690:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800697:	8b 45 08             	mov    0x8(%ebp),%eax
  80069a:	8d 0c 02             	lea    (%edx,%eax,1),%ecx
  80069d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8006a0:	8d 50 01             	lea    0x1(%eax),%edx
  8006a3:	89 55 f0             	mov    %edx,-0x10(%ebp)
  8006a6:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8006ad:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8006b0:	01 d0                	add    %edx,%eax
  8006b2:	8b 00                	mov    (%eax),%eax
  8006b4:	89 01                	mov    %eax,(%ecx)

	for ( k = p; k <= r; k++)
	{
		if (leftIndex < leftCapacity && rightIndex < rightCapacity)
		{
			if (Left[leftIndex] < Right[rightIndex] )
  8006b6:	eb 66                	jmp    80071e <Merge+0x1de>
			else
			{
				A[k - 1] = Right[rightIndex++];
			}
		}
		else if (leftIndex < leftCapacity)
  8006b8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8006bb:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  8006be:	7d 30                	jge    8006f0 <Merge+0x1b0>
		{
			A[k - 1] = Left[leftIndex++];
  8006c0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8006c3:	05 ff ff ff 3f       	add    $0x3fffffff,%eax
  8006c8:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8006cf:	8b 45 08             	mov    0x8(%ebp),%eax
  8006d2:	8d 0c 02             	lea    (%edx,%eax,1),%ecx
  8006d5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8006d8:	8d 50 01             	lea    0x1(%eax),%edx
  8006db:	89 55 f4             	mov    %edx,-0xc(%ebp)
  8006de:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8006e5:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8006e8:	01 d0                	add    %edx,%eax
  8006ea:	8b 00                	mov    (%eax),%eax
  8006ec:	89 01                	mov    %eax,(%ecx)
  8006ee:	eb 2e                	jmp    80071e <Merge+0x1de>
		}
		else
		{
			A[k - 1] = Right[rightIndex++];
  8006f0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8006f3:	05 ff ff ff 3f       	add    $0x3fffffff,%eax
  8006f8:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8006ff:	8b 45 08             	mov    0x8(%ebp),%eax
  800702:	8d 0c 02             	lea    (%edx,%eax,1),%ecx
  800705:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800708:	8d 50 01             	lea    0x1(%eax),%edx
  80070b:	89 55 f0             	mov    %edx,-0x10(%ebp)
  80070e:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800715:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  800718:	01 d0                	add    %edx,%eax
  80071a:	8b 00                	mov    (%eax),%eax
  80071c:	89 01                	mov    %eax,(%ecx)
	for (j = 0; j < rightCapacity; j++)
	{
		Right[j] = A[q + j];
	}

	for ( k = p; k <= r; k++)
  80071e:	ff 45 e4             	incl   -0x1c(%ebp)
  800721:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800724:	3b 45 14             	cmp    0x14(%ebp),%eax
  800727:	0f 8e ea fe ff ff    	jle    800617 <Merge+0xd7>
		{
			A[k - 1] = Right[rightIndex++];
		}
	}

}
  80072d:	90                   	nop
  80072e:	c9                   	leave  
  80072f:	c3                   	ret    

00800730 <cputchar>:
#include <inc/lib.h>


void
cputchar(int ch)
{
  800730:	55                   	push   %ebp
  800731:	89 e5                	mov    %esp,%ebp
  800733:	83 ec 18             	sub    $0x18,%esp
	char c = ch;
  800736:	8b 45 08             	mov    0x8(%ebp),%eax
  800739:	88 45 f7             	mov    %al,-0x9(%ebp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	//sys_cputs(&c, 1);

	sys_cputc(c);
  80073c:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
  800740:	83 ec 0c             	sub    $0xc,%esp
  800743:	50                   	push   %eax
  800744:	e8 36 19 00 00       	call   80207f <sys_cputc>
  800749:	83 c4 10             	add    $0x10,%esp
}
  80074c:	90                   	nop
  80074d:	c9                   	leave  
  80074e:	c3                   	ret    

0080074f <atomic_cputchar>:


void
atomic_cputchar(int ch)
{
  80074f:	55                   	push   %ebp
  800750:	89 e5                	mov    %esp,%ebp
  800752:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  800755:	e8 f1 18 00 00       	call   80204b <sys_disable_interrupt>
	char c = ch;
  80075a:	8b 45 08             	mov    0x8(%ebp),%eax
  80075d:	88 45 f7             	mov    %al,-0x9(%ebp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	//sys_cputs(&c, 1);

	sys_cputc(c);
  800760:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
  800764:	83 ec 0c             	sub    $0xc,%esp
  800767:	50                   	push   %eax
  800768:	e8 12 19 00 00       	call   80207f <sys_cputc>
  80076d:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  800770:	e8 f0 18 00 00       	call   802065 <sys_enable_interrupt>
}
  800775:	90                   	nop
  800776:	c9                   	leave  
  800777:	c3                   	ret    

00800778 <getchar>:

int
getchar(void)
{
  800778:	55                   	push   %ebp
  800779:	89 e5                	mov    %esp,%ebp
  80077b:	83 ec 18             	sub    $0x18,%esp

	//return sys_cgetc();
	int c=0;
  80077e:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	while(c == 0)
  800785:	eb 08                	jmp    80078f <getchar+0x17>
	{
		c = sys_cgetc();
  800787:	e8 3a 17 00 00       	call   801ec6 <sys_cgetc>
  80078c:	89 45 f4             	mov    %eax,-0xc(%ebp)
getchar(void)
{

	//return sys_cgetc();
	int c=0;
	while(c == 0)
  80078f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  800793:	74 f2                	je     800787 <getchar+0xf>
	{
		c = sys_cgetc();
	}
	return c;
  800795:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  800798:	c9                   	leave  
  800799:	c3                   	ret    

0080079a <atomic_getchar>:

int
atomic_getchar(void)
{
  80079a:	55                   	push   %ebp
  80079b:	89 e5                	mov    %esp,%ebp
  80079d:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  8007a0:	e8 a6 18 00 00       	call   80204b <sys_disable_interrupt>
	int c=0;
  8007a5:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	while(c == 0)
  8007ac:	eb 08                	jmp    8007b6 <atomic_getchar+0x1c>
	{
		c = sys_cgetc();
  8007ae:	e8 13 17 00 00       	call   801ec6 <sys_cgetc>
  8007b3:	89 45 f4             	mov    %eax,-0xc(%ebp)
int
atomic_getchar(void)
{
	sys_disable_interrupt();
	int c=0;
	while(c == 0)
  8007b6:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8007ba:	74 f2                	je     8007ae <atomic_getchar+0x14>
	{
		c = sys_cgetc();
	}
	sys_enable_interrupt();
  8007bc:	e8 a4 18 00 00       	call   802065 <sys_enable_interrupt>
	return c;
  8007c1:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  8007c4:	c9                   	leave  
  8007c5:	c3                   	ret    

008007c6 <iscons>:

int iscons(int fdnum)
{
  8007c6:	55                   	push   %ebp
  8007c7:	89 e5                	mov    %esp,%ebp
	// used by readline
	return 1;
  8007c9:	b8 01 00 00 00       	mov    $0x1,%eax
}
  8007ce:	5d                   	pop    %ebp
  8007cf:	c3                   	ret    

008007d0 <libmain>:
volatile struct Env *myEnv = NULL;
volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";

void
libmain(int argc, char **argv)
{
  8007d0:	55                   	push   %ebp
  8007d1:	89 e5                	mov    %esp,%ebp
  8007d3:	83 ec 18             	sub    $0x18,%esp
	int envIndex = sys_getenvindex();
  8007d6:	e8 63 1a 00 00       	call   80223e <sys_getenvindex>
  8007db:	89 45 f4             	mov    %eax,-0xc(%ebp)
	myEnv = &(envs[envIndex]);
  8007de:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8007e1:	89 d0                	mov    %edx,%eax
  8007e3:	c1 e0 03             	shl    $0x3,%eax
  8007e6:	01 d0                	add    %edx,%eax
  8007e8:	01 c0                	add    %eax,%eax
  8007ea:	01 d0                	add    %edx,%eax
  8007ec:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8007f3:	01 d0                	add    %edx,%eax
  8007f5:	c1 e0 04             	shl    $0x4,%eax
  8007f8:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8007fd:	a3 24 50 80 00       	mov    %eax,0x805024

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  800802:	a1 24 50 80 00       	mov    0x805024,%eax
  800807:	8a 80 5c 05 00 00    	mov    0x55c(%eax),%al
  80080d:	84 c0                	test   %al,%al
  80080f:	74 0f                	je     800820 <libmain+0x50>
		binaryname = myEnv->prog_name;
  800811:	a1 24 50 80 00       	mov    0x805024,%eax
  800816:	05 5c 05 00 00       	add    $0x55c,%eax
  80081b:	a3 00 50 80 00       	mov    %eax,0x805000

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800820:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800824:	7e 0a                	jle    800830 <libmain+0x60>
		binaryname = argv[0];
  800826:	8b 45 0c             	mov    0xc(%ebp),%eax
  800829:	8b 00                	mov    (%eax),%eax
  80082b:	a3 00 50 80 00       	mov    %eax,0x805000

	// call user main routine
	_main(argc, argv);
  800830:	83 ec 08             	sub    $0x8,%esp
  800833:	ff 75 0c             	pushl  0xc(%ebp)
  800836:	ff 75 08             	pushl  0x8(%ebp)
  800839:	e8 fa f7 ff ff       	call   800038 <_main>
  80083e:	83 c4 10             	add    $0x10,%esp



	sys_disable_interrupt();
  800841:	e8 05 18 00 00       	call   80204b <sys_disable_interrupt>
	cprintf("**************************************\n");
  800846:	83 ec 0c             	sub    $0xc,%esp
  800849:	68 58 39 80 00       	push   $0x803958
  80084e:	e8 6d 03 00 00       	call   800bc0 <cprintf>
  800853:	83 c4 10             	add    $0x10,%esp
	cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  800856:	a1 24 50 80 00       	mov    0x805024,%eax
  80085b:	8b 90 44 05 00 00    	mov    0x544(%eax),%edx
  800861:	a1 24 50 80 00       	mov    0x805024,%eax
  800866:	8b 80 34 05 00 00    	mov    0x534(%eax),%eax
  80086c:	83 ec 04             	sub    $0x4,%esp
  80086f:	52                   	push   %edx
  800870:	50                   	push   %eax
  800871:	68 80 39 80 00       	push   $0x803980
  800876:	e8 45 03 00 00       	call   800bc0 <cprintf>
  80087b:	83 c4 10             	add    $0x10,%esp
	cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  80087e:	a1 24 50 80 00       	mov    0x805024,%eax
  800883:	8b 88 54 05 00 00    	mov    0x554(%eax),%ecx
  800889:	a1 24 50 80 00       	mov    0x805024,%eax
  80088e:	8b 90 50 05 00 00    	mov    0x550(%eax),%edx
  800894:	a1 24 50 80 00       	mov    0x805024,%eax
  800899:	8b 80 4c 05 00 00    	mov    0x54c(%eax),%eax
  80089f:	51                   	push   %ecx
  8008a0:	52                   	push   %edx
  8008a1:	50                   	push   %eax
  8008a2:	68 a8 39 80 00       	push   $0x8039a8
  8008a7:	e8 14 03 00 00       	call   800bc0 <cprintf>
  8008ac:	83 c4 10             	add    $0x10,%esp
	//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
	cprintf("Num of clocks = %d\n", myEnv->nClocks);
  8008af:	a1 24 50 80 00       	mov    0x805024,%eax
  8008b4:	8b 80 a4 05 00 00    	mov    0x5a4(%eax),%eax
  8008ba:	83 ec 08             	sub    $0x8,%esp
  8008bd:	50                   	push   %eax
  8008be:	68 00 3a 80 00       	push   $0x803a00
  8008c3:	e8 f8 02 00 00       	call   800bc0 <cprintf>
  8008c8:	83 c4 10             	add    $0x10,%esp
	cprintf("**************************************\n");
  8008cb:	83 ec 0c             	sub    $0xc,%esp
  8008ce:	68 58 39 80 00       	push   $0x803958
  8008d3:	e8 e8 02 00 00       	call   800bc0 <cprintf>
  8008d8:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  8008db:	e8 85 17 00 00       	call   802065 <sys_enable_interrupt>

	// exit gracefully
	exit();
  8008e0:	e8 19 00 00 00       	call   8008fe <exit>
}
  8008e5:	90                   	nop
  8008e6:	c9                   	leave  
  8008e7:	c3                   	ret    

008008e8 <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  8008e8:	55                   	push   %ebp
  8008e9:	89 e5                	mov    %esp,%ebp
  8008eb:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  8008ee:	83 ec 0c             	sub    $0xc,%esp
  8008f1:	6a 00                	push   $0x0
  8008f3:	e8 12 19 00 00       	call   80220a <sys_destroy_env>
  8008f8:	83 c4 10             	add    $0x10,%esp
}
  8008fb:	90                   	nop
  8008fc:	c9                   	leave  
  8008fd:	c3                   	ret    

008008fe <exit>:

void
exit(void)
{
  8008fe:	55                   	push   %ebp
  8008ff:	89 e5                	mov    %esp,%ebp
  800901:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  800904:	e8 67 19 00 00       	call   802270 <sys_exit_env>
}
  800909:	90                   	nop
  80090a:	c9                   	leave  
  80090b:	c3                   	ret    

0080090c <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  80090c:	55                   	push   %ebp
  80090d:	89 e5                	mov    %esp,%ebp
  80090f:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  800912:	8d 45 10             	lea    0x10(%ebp),%eax
  800915:	83 c0 04             	add    $0x4,%eax
  800918:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  80091b:	a1 5c 51 80 00       	mov    0x80515c,%eax
  800920:	85 c0                	test   %eax,%eax
  800922:	74 16                	je     80093a <_panic+0x2e>
		cprintf("%s: ", argv0);
  800924:	a1 5c 51 80 00       	mov    0x80515c,%eax
  800929:	83 ec 08             	sub    $0x8,%esp
  80092c:	50                   	push   %eax
  80092d:	68 14 3a 80 00       	push   $0x803a14
  800932:	e8 89 02 00 00       	call   800bc0 <cprintf>
  800937:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  80093a:	a1 00 50 80 00       	mov    0x805000,%eax
  80093f:	ff 75 0c             	pushl  0xc(%ebp)
  800942:	ff 75 08             	pushl  0x8(%ebp)
  800945:	50                   	push   %eax
  800946:	68 19 3a 80 00       	push   $0x803a19
  80094b:	e8 70 02 00 00       	call   800bc0 <cprintf>
  800950:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  800953:	8b 45 10             	mov    0x10(%ebp),%eax
  800956:	83 ec 08             	sub    $0x8,%esp
  800959:	ff 75 f4             	pushl  -0xc(%ebp)
  80095c:	50                   	push   %eax
  80095d:	e8 f3 01 00 00       	call   800b55 <vcprintf>
  800962:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  800965:	83 ec 08             	sub    $0x8,%esp
  800968:	6a 00                	push   $0x0
  80096a:	68 35 3a 80 00       	push   $0x803a35
  80096f:	e8 e1 01 00 00       	call   800b55 <vcprintf>
  800974:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  800977:	e8 82 ff ff ff       	call   8008fe <exit>

	// should not return here
	while (1) ;
  80097c:	eb fe                	jmp    80097c <_panic+0x70>

0080097e <CheckWSWithoutLastIndex>:
}

void CheckWSWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  80097e:	55                   	push   %ebp
  80097f:	89 e5                	mov    %esp,%ebp
  800981:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  800984:	a1 24 50 80 00       	mov    0x805024,%eax
  800989:	8b 50 74             	mov    0x74(%eax),%edx
  80098c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80098f:	39 c2                	cmp    %eax,%edx
  800991:	74 14                	je     8009a7 <CheckWSWithoutLastIndex+0x29>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  800993:	83 ec 04             	sub    $0x4,%esp
  800996:	68 38 3a 80 00       	push   $0x803a38
  80099b:	6a 26                	push   $0x26
  80099d:	68 84 3a 80 00       	push   $0x803a84
  8009a2:	e8 65 ff ff ff       	call   80090c <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  8009a7:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  8009ae:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  8009b5:	e9 c2 00 00 00       	jmp    800a7c <CheckWSWithoutLastIndex+0xfe>
		if (expectedPages[e] == 0) {
  8009ba:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8009bd:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8009c4:	8b 45 08             	mov    0x8(%ebp),%eax
  8009c7:	01 d0                	add    %edx,%eax
  8009c9:	8b 00                	mov    (%eax),%eax
  8009cb:	85 c0                	test   %eax,%eax
  8009cd:	75 08                	jne    8009d7 <CheckWSWithoutLastIndex+0x59>
			expectedNumOfEmptyLocs++;
  8009cf:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  8009d2:	e9 a2 00 00 00       	jmp    800a79 <CheckWSWithoutLastIndex+0xfb>
		}
		int found = 0;
  8009d7:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8009de:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  8009e5:	eb 69                	jmp    800a50 <CheckWSWithoutLastIndex+0xd2>
			if (myEnv->__uptr_pws[w].empty == 0) {
  8009e7:	a1 24 50 80 00       	mov    0x805024,%eax
  8009ec:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  8009f2:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8009f5:	89 d0                	mov    %edx,%eax
  8009f7:	01 c0                	add    %eax,%eax
  8009f9:	01 d0                	add    %edx,%eax
  8009fb:	c1 e0 03             	shl    $0x3,%eax
  8009fe:	01 c8                	add    %ecx,%eax
  800a00:	8a 40 04             	mov    0x4(%eax),%al
  800a03:	84 c0                	test   %al,%al
  800a05:	75 46                	jne    800a4d <CheckWSWithoutLastIndex+0xcf>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  800a07:	a1 24 50 80 00       	mov    0x805024,%eax
  800a0c:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  800a12:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800a15:	89 d0                	mov    %edx,%eax
  800a17:	01 c0                	add    %eax,%eax
  800a19:	01 d0                	add    %edx,%eax
  800a1b:	c1 e0 03             	shl    $0x3,%eax
  800a1e:	01 c8                	add    %ecx,%eax
  800a20:	8b 00                	mov    (%eax),%eax
  800a22:	89 45 dc             	mov    %eax,-0x24(%ebp)
  800a25:	8b 45 dc             	mov    -0x24(%ebp),%eax
  800a28:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800a2d:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  800a2f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800a32:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  800a39:	8b 45 08             	mov    0x8(%ebp),%eax
  800a3c:	01 c8                	add    %ecx,%eax
  800a3e:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  800a40:	39 c2                	cmp    %eax,%edx
  800a42:	75 09                	jne    800a4d <CheckWSWithoutLastIndex+0xcf>
						== expectedPages[e]) {
					found = 1;
  800a44:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  800a4b:	eb 12                	jmp    800a5f <CheckWSWithoutLastIndex+0xe1>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800a4d:	ff 45 e8             	incl   -0x18(%ebp)
  800a50:	a1 24 50 80 00       	mov    0x805024,%eax
  800a55:	8b 50 74             	mov    0x74(%eax),%edx
  800a58:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800a5b:	39 c2                	cmp    %eax,%edx
  800a5d:	77 88                	ja     8009e7 <CheckWSWithoutLastIndex+0x69>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  800a5f:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  800a63:	75 14                	jne    800a79 <CheckWSWithoutLastIndex+0xfb>
			panic(
  800a65:	83 ec 04             	sub    $0x4,%esp
  800a68:	68 90 3a 80 00       	push   $0x803a90
  800a6d:	6a 3a                	push   $0x3a
  800a6f:	68 84 3a 80 00       	push   $0x803a84
  800a74:	e8 93 fe ff ff       	call   80090c <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  800a79:	ff 45 f0             	incl   -0x10(%ebp)
  800a7c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800a7f:	3b 45 0c             	cmp    0xc(%ebp),%eax
  800a82:	0f 8c 32 ff ff ff    	jl     8009ba <CheckWSWithoutLastIndex+0x3c>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  800a88:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800a8f:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  800a96:	eb 26                	jmp    800abe <CheckWSWithoutLastIndex+0x140>
		if (myEnv->__uptr_pws[w].empty == 1) {
  800a98:	a1 24 50 80 00       	mov    0x805024,%eax
  800a9d:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  800aa3:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800aa6:	89 d0                	mov    %edx,%eax
  800aa8:	01 c0                	add    %eax,%eax
  800aaa:	01 d0                	add    %edx,%eax
  800aac:	c1 e0 03             	shl    $0x3,%eax
  800aaf:	01 c8                	add    %ecx,%eax
  800ab1:	8a 40 04             	mov    0x4(%eax),%al
  800ab4:	3c 01                	cmp    $0x1,%al
  800ab6:	75 03                	jne    800abb <CheckWSWithoutLastIndex+0x13d>
			actualNumOfEmptyLocs++;
  800ab8:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800abb:	ff 45 e0             	incl   -0x20(%ebp)
  800abe:	a1 24 50 80 00       	mov    0x805024,%eax
  800ac3:	8b 50 74             	mov    0x74(%eax),%edx
  800ac6:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800ac9:	39 c2                	cmp    %eax,%edx
  800acb:	77 cb                	ja     800a98 <CheckWSWithoutLastIndex+0x11a>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  800acd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800ad0:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  800ad3:	74 14                	je     800ae9 <CheckWSWithoutLastIndex+0x16b>
		panic(
  800ad5:	83 ec 04             	sub    $0x4,%esp
  800ad8:	68 e4 3a 80 00       	push   $0x803ae4
  800add:	6a 44                	push   $0x44
  800adf:	68 84 3a 80 00       	push   $0x803a84
  800ae4:	e8 23 fe ff ff       	call   80090c <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  800ae9:	90                   	nop
  800aea:	c9                   	leave  
  800aeb:	c3                   	ret    

00800aec <putch>:
};

//2017:
uint8 printProgName = 0;

static void putch(int ch, struct printbuf *b) {
  800aec:	55                   	push   %ebp
  800aed:	89 e5                	mov    %esp,%ebp
  800aef:	83 ec 08             	sub    $0x8,%esp
	b->buf[b->idx++] = ch;
  800af2:	8b 45 0c             	mov    0xc(%ebp),%eax
  800af5:	8b 00                	mov    (%eax),%eax
  800af7:	8d 48 01             	lea    0x1(%eax),%ecx
  800afa:	8b 55 0c             	mov    0xc(%ebp),%edx
  800afd:	89 0a                	mov    %ecx,(%edx)
  800aff:	8b 55 08             	mov    0x8(%ebp),%edx
  800b02:	88 d1                	mov    %dl,%cl
  800b04:	8b 55 0c             	mov    0xc(%ebp),%edx
  800b07:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  800b0b:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b0e:	8b 00                	mov    (%eax),%eax
  800b10:	3d ff 00 00 00       	cmp    $0xff,%eax
  800b15:	75 2c                	jne    800b43 <putch+0x57>
		sys_cputs(b->buf, b->idx, printProgName);
  800b17:	a0 28 50 80 00       	mov    0x805028,%al
  800b1c:	0f b6 c0             	movzbl %al,%eax
  800b1f:	8b 55 0c             	mov    0xc(%ebp),%edx
  800b22:	8b 12                	mov    (%edx),%edx
  800b24:	89 d1                	mov    %edx,%ecx
  800b26:	8b 55 0c             	mov    0xc(%ebp),%edx
  800b29:	83 c2 08             	add    $0x8,%edx
  800b2c:	83 ec 04             	sub    $0x4,%esp
  800b2f:	50                   	push   %eax
  800b30:	51                   	push   %ecx
  800b31:	52                   	push   %edx
  800b32:	e8 66 13 00 00       	call   801e9d <sys_cputs>
  800b37:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  800b3a:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b3d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  800b43:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b46:	8b 40 04             	mov    0x4(%eax),%eax
  800b49:	8d 50 01             	lea    0x1(%eax),%edx
  800b4c:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b4f:	89 50 04             	mov    %edx,0x4(%eax)
}
  800b52:	90                   	nop
  800b53:	c9                   	leave  
  800b54:	c3                   	ret    

00800b55 <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  800b55:	55                   	push   %ebp
  800b56:	89 e5                	mov    %esp,%ebp
  800b58:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  800b5e:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800b65:	00 00 00 
	b.cnt = 0;
  800b68:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800b6f:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  800b72:	ff 75 0c             	pushl  0xc(%ebp)
  800b75:	ff 75 08             	pushl  0x8(%ebp)
  800b78:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800b7e:	50                   	push   %eax
  800b7f:	68 ec 0a 80 00       	push   $0x800aec
  800b84:	e8 11 02 00 00       	call   800d9a <vprintfmt>
  800b89:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName);
  800b8c:	a0 28 50 80 00       	mov    0x805028,%al
  800b91:	0f b6 c0             	movzbl %al,%eax
  800b94:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  800b9a:	83 ec 04             	sub    $0x4,%esp
  800b9d:	50                   	push   %eax
  800b9e:	52                   	push   %edx
  800b9f:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800ba5:	83 c0 08             	add    $0x8,%eax
  800ba8:	50                   	push   %eax
  800ba9:	e8 ef 12 00 00       	call   801e9d <sys_cputs>
  800bae:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  800bb1:	c6 05 28 50 80 00 00 	movb   $0x0,0x805028
	return b.cnt;
  800bb8:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  800bbe:	c9                   	leave  
  800bbf:	c3                   	ret    

00800bc0 <cprintf>:

int cprintf(const char *fmt, ...) {
  800bc0:	55                   	push   %ebp
  800bc1:	89 e5                	mov    %esp,%ebp
  800bc3:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  800bc6:	c6 05 28 50 80 00 01 	movb   $0x1,0x805028
	va_start(ap, fmt);
  800bcd:	8d 45 0c             	lea    0xc(%ebp),%eax
  800bd0:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800bd3:	8b 45 08             	mov    0x8(%ebp),%eax
  800bd6:	83 ec 08             	sub    $0x8,%esp
  800bd9:	ff 75 f4             	pushl  -0xc(%ebp)
  800bdc:	50                   	push   %eax
  800bdd:	e8 73 ff ff ff       	call   800b55 <vcprintf>
  800be2:	83 c4 10             	add    $0x10,%esp
  800be5:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  800be8:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800beb:	c9                   	leave  
  800bec:	c3                   	ret    

00800bed <atomic_cprintf>:

int atomic_cprintf(const char *fmt, ...) {
  800bed:	55                   	push   %ebp
  800bee:	89 e5                	mov    %esp,%ebp
  800bf0:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  800bf3:	e8 53 14 00 00       	call   80204b <sys_disable_interrupt>
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  800bf8:	8d 45 0c             	lea    0xc(%ebp),%eax
  800bfb:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800bfe:	8b 45 08             	mov    0x8(%ebp),%eax
  800c01:	83 ec 08             	sub    $0x8,%esp
  800c04:	ff 75 f4             	pushl  -0xc(%ebp)
  800c07:	50                   	push   %eax
  800c08:	e8 48 ff ff ff       	call   800b55 <vcprintf>
  800c0d:	83 c4 10             	add    $0x10,%esp
  800c10:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	sys_enable_interrupt();
  800c13:	e8 4d 14 00 00       	call   802065 <sys_enable_interrupt>
	return cnt;
  800c18:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800c1b:	c9                   	leave  
  800c1c:	c3                   	ret    

00800c1d <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800c1d:	55                   	push   %ebp
  800c1e:	89 e5                	mov    %esp,%ebp
  800c20:	53                   	push   %ebx
  800c21:	83 ec 14             	sub    $0x14,%esp
  800c24:	8b 45 10             	mov    0x10(%ebp),%eax
  800c27:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800c2a:	8b 45 14             	mov    0x14(%ebp),%eax
  800c2d:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800c30:	8b 45 18             	mov    0x18(%ebp),%eax
  800c33:	ba 00 00 00 00       	mov    $0x0,%edx
  800c38:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800c3b:	77 55                	ja     800c92 <printnum+0x75>
  800c3d:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800c40:	72 05                	jb     800c47 <printnum+0x2a>
  800c42:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800c45:	77 4b                	ja     800c92 <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800c47:	8b 45 1c             	mov    0x1c(%ebp),%eax
  800c4a:	8d 58 ff             	lea    -0x1(%eax),%ebx
  800c4d:	8b 45 18             	mov    0x18(%ebp),%eax
  800c50:	ba 00 00 00 00       	mov    $0x0,%edx
  800c55:	52                   	push   %edx
  800c56:	50                   	push   %eax
  800c57:	ff 75 f4             	pushl  -0xc(%ebp)
  800c5a:	ff 75 f0             	pushl  -0x10(%ebp)
  800c5d:	e8 86 28 00 00       	call   8034e8 <__udivdi3>
  800c62:	83 c4 10             	add    $0x10,%esp
  800c65:	83 ec 04             	sub    $0x4,%esp
  800c68:	ff 75 20             	pushl  0x20(%ebp)
  800c6b:	53                   	push   %ebx
  800c6c:	ff 75 18             	pushl  0x18(%ebp)
  800c6f:	52                   	push   %edx
  800c70:	50                   	push   %eax
  800c71:	ff 75 0c             	pushl  0xc(%ebp)
  800c74:	ff 75 08             	pushl  0x8(%ebp)
  800c77:	e8 a1 ff ff ff       	call   800c1d <printnum>
  800c7c:	83 c4 20             	add    $0x20,%esp
  800c7f:	eb 1a                	jmp    800c9b <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800c81:	83 ec 08             	sub    $0x8,%esp
  800c84:	ff 75 0c             	pushl  0xc(%ebp)
  800c87:	ff 75 20             	pushl  0x20(%ebp)
  800c8a:	8b 45 08             	mov    0x8(%ebp),%eax
  800c8d:	ff d0                	call   *%eax
  800c8f:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800c92:	ff 4d 1c             	decl   0x1c(%ebp)
  800c95:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  800c99:	7f e6                	jg     800c81 <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800c9b:	8b 4d 18             	mov    0x18(%ebp),%ecx
  800c9e:	bb 00 00 00 00       	mov    $0x0,%ebx
  800ca3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800ca6:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800ca9:	53                   	push   %ebx
  800caa:	51                   	push   %ecx
  800cab:	52                   	push   %edx
  800cac:	50                   	push   %eax
  800cad:	e8 46 29 00 00       	call   8035f8 <__umoddi3>
  800cb2:	83 c4 10             	add    $0x10,%esp
  800cb5:	05 54 3d 80 00       	add    $0x803d54,%eax
  800cba:	8a 00                	mov    (%eax),%al
  800cbc:	0f be c0             	movsbl %al,%eax
  800cbf:	83 ec 08             	sub    $0x8,%esp
  800cc2:	ff 75 0c             	pushl  0xc(%ebp)
  800cc5:	50                   	push   %eax
  800cc6:	8b 45 08             	mov    0x8(%ebp),%eax
  800cc9:	ff d0                	call   *%eax
  800ccb:	83 c4 10             	add    $0x10,%esp
}
  800cce:	90                   	nop
  800ccf:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800cd2:	c9                   	leave  
  800cd3:	c3                   	ret    

00800cd4 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  800cd4:	55                   	push   %ebp
  800cd5:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800cd7:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800cdb:	7e 1c                	jle    800cf9 <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  800cdd:	8b 45 08             	mov    0x8(%ebp),%eax
  800ce0:	8b 00                	mov    (%eax),%eax
  800ce2:	8d 50 08             	lea    0x8(%eax),%edx
  800ce5:	8b 45 08             	mov    0x8(%ebp),%eax
  800ce8:	89 10                	mov    %edx,(%eax)
  800cea:	8b 45 08             	mov    0x8(%ebp),%eax
  800ced:	8b 00                	mov    (%eax),%eax
  800cef:	83 e8 08             	sub    $0x8,%eax
  800cf2:	8b 50 04             	mov    0x4(%eax),%edx
  800cf5:	8b 00                	mov    (%eax),%eax
  800cf7:	eb 40                	jmp    800d39 <getuint+0x65>
	else if (lflag)
  800cf9:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800cfd:	74 1e                	je     800d1d <getuint+0x49>
		return va_arg(*ap, unsigned long);
  800cff:	8b 45 08             	mov    0x8(%ebp),%eax
  800d02:	8b 00                	mov    (%eax),%eax
  800d04:	8d 50 04             	lea    0x4(%eax),%edx
  800d07:	8b 45 08             	mov    0x8(%ebp),%eax
  800d0a:	89 10                	mov    %edx,(%eax)
  800d0c:	8b 45 08             	mov    0x8(%ebp),%eax
  800d0f:	8b 00                	mov    (%eax),%eax
  800d11:	83 e8 04             	sub    $0x4,%eax
  800d14:	8b 00                	mov    (%eax),%eax
  800d16:	ba 00 00 00 00       	mov    $0x0,%edx
  800d1b:	eb 1c                	jmp    800d39 <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  800d1d:	8b 45 08             	mov    0x8(%ebp),%eax
  800d20:	8b 00                	mov    (%eax),%eax
  800d22:	8d 50 04             	lea    0x4(%eax),%edx
  800d25:	8b 45 08             	mov    0x8(%ebp),%eax
  800d28:	89 10                	mov    %edx,(%eax)
  800d2a:	8b 45 08             	mov    0x8(%ebp),%eax
  800d2d:	8b 00                	mov    (%eax),%eax
  800d2f:	83 e8 04             	sub    $0x4,%eax
  800d32:	8b 00                	mov    (%eax),%eax
  800d34:	ba 00 00 00 00       	mov    $0x0,%edx
}
  800d39:	5d                   	pop    %ebp
  800d3a:	c3                   	ret    

00800d3b <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  800d3b:	55                   	push   %ebp
  800d3c:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800d3e:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800d42:	7e 1c                	jle    800d60 <getint+0x25>
		return va_arg(*ap, long long);
  800d44:	8b 45 08             	mov    0x8(%ebp),%eax
  800d47:	8b 00                	mov    (%eax),%eax
  800d49:	8d 50 08             	lea    0x8(%eax),%edx
  800d4c:	8b 45 08             	mov    0x8(%ebp),%eax
  800d4f:	89 10                	mov    %edx,(%eax)
  800d51:	8b 45 08             	mov    0x8(%ebp),%eax
  800d54:	8b 00                	mov    (%eax),%eax
  800d56:	83 e8 08             	sub    $0x8,%eax
  800d59:	8b 50 04             	mov    0x4(%eax),%edx
  800d5c:	8b 00                	mov    (%eax),%eax
  800d5e:	eb 38                	jmp    800d98 <getint+0x5d>
	else if (lflag)
  800d60:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800d64:	74 1a                	je     800d80 <getint+0x45>
		return va_arg(*ap, long);
  800d66:	8b 45 08             	mov    0x8(%ebp),%eax
  800d69:	8b 00                	mov    (%eax),%eax
  800d6b:	8d 50 04             	lea    0x4(%eax),%edx
  800d6e:	8b 45 08             	mov    0x8(%ebp),%eax
  800d71:	89 10                	mov    %edx,(%eax)
  800d73:	8b 45 08             	mov    0x8(%ebp),%eax
  800d76:	8b 00                	mov    (%eax),%eax
  800d78:	83 e8 04             	sub    $0x4,%eax
  800d7b:	8b 00                	mov    (%eax),%eax
  800d7d:	99                   	cltd   
  800d7e:	eb 18                	jmp    800d98 <getint+0x5d>
	else
		return va_arg(*ap, int);
  800d80:	8b 45 08             	mov    0x8(%ebp),%eax
  800d83:	8b 00                	mov    (%eax),%eax
  800d85:	8d 50 04             	lea    0x4(%eax),%edx
  800d88:	8b 45 08             	mov    0x8(%ebp),%eax
  800d8b:	89 10                	mov    %edx,(%eax)
  800d8d:	8b 45 08             	mov    0x8(%ebp),%eax
  800d90:	8b 00                	mov    (%eax),%eax
  800d92:	83 e8 04             	sub    $0x4,%eax
  800d95:	8b 00                	mov    (%eax),%eax
  800d97:	99                   	cltd   
}
  800d98:	5d                   	pop    %ebp
  800d99:	c3                   	ret    

00800d9a <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  800d9a:	55                   	push   %ebp
  800d9b:	89 e5                	mov    %esp,%ebp
  800d9d:	56                   	push   %esi
  800d9e:	53                   	push   %ebx
  800d9f:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800da2:	eb 17                	jmp    800dbb <vprintfmt+0x21>
			if (ch == '\0')
  800da4:	85 db                	test   %ebx,%ebx
  800da6:	0f 84 af 03 00 00    	je     80115b <vprintfmt+0x3c1>
				return;
			putch(ch, putdat);
  800dac:	83 ec 08             	sub    $0x8,%esp
  800daf:	ff 75 0c             	pushl  0xc(%ebp)
  800db2:	53                   	push   %ebx
  800db3:	8b 45 08             	mov    0x8(%ebp),%eax
  800db6:	ff d0                	call   *%eax
  800db8:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800dbb:	8b 45 10             	mov    0x10(%ebp),%eax
  800dbe:	8d 50 01             	lea    0x1(%eax),%edx
  800dc1:	89 55 10             	mov    %edx,0x10(%ebp)
  800dc4:	8a 00                	mov    (%eax),%al
  800dc6:	0f b6 d8             	movzbl %al,%ebx
  800dc9:	83 fb 25             	cmp    $0x25,%ebx
  800dcc:	75 d6                	jne    800da4 <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  800dce:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  800dd2:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  800dd9:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  800de0:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  800de7:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800dee:	8b 45 10             	mov    0x10(%ebp),%eax
  800df1:	8d 50 01             	lea    0x1(%eax),%edx
  800df4:	89 55 10             	mov    %edx,0x10(%ebp)
  800df7:	8a 00                	mov    (%eax),%al
  800df9:	0f b6 d8             	movzbl %al,%ebx
  800dfc:	8d 43 dd             	lea    -0x23(%ebx),%eax
  800dff:	83 f8 55             	cmp    $0x55,%eax
  800e02:	0f 87 2b 03 00 00    	ja     801133 <vprintfmt+0x399>
  800e08:	8b 04 85 78 3d 80 00 	mov    0x803d78(,%eax,4),%eax
  800e0f:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  800e11:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  800e15:	eb d7                	jmp    800dee <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800e17:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  800e1b:	eb d1                	jmp    800dee <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800e1d:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  800e24:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800e27:	89 d0                	mov    %edx,%eax
  800e29:	c1 e0 02             	shl    $0x2,%eax
  800e2c:	01 d0                	add    %edx,%eax
  800e2e:	01 c0                	add    %eax,%eax
  800e30:	01 d8                	add    %ebx,%eax
  800e32:	83 e8 30             	sub    $0x30,%eax
  800e35:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  800e38:	8b 45 10             	mov    0x10(%ebp),%eax
  800e3b:	8a 00                	mov    (%eax),%al
  800e3d:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  800e40:	83 fb 2f             	cmp    $0x2f,%ebx
  800e43:	7e 3e                	jle    800e83 <vprintfmt+0xe9>
  800e45:	83 fb 39             	cmp    $0x39,%ebx
  800e48:	7f 39                	jg     800e83 <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800e4a:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800e4d:	eb d5                	jmp    800e24 <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  800e4f:	8b 45 14             	mov    0x14(%ebp),%eax
  800e52:	83 c0 04             	add    $0x4,%eax
  800e55:	89 45 14             	mov    %eax,0x14(%ebp)
  800e58:	8b 45 14             	mov    0x14(%ebp),%eax
  800e5b:	83 e8 04             	sub    $0x4,%eax
  800e5e:	8b 00                	mov    (%eax),%eax
  800e60:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  800e63:	eb 1f                	jmp    800e84 <vprintfmt+0xea>

		case '.':
			if (width < 0)
  800e65:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800e69:	79 83                	jns    800dee <vprintfmt+0x54>
				width = 0;
  800e6b:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  800e72:	e9 77 ff ff ff       	jmp    800dee <vprintfmt+0x54>

		case '#':
			altflag = 1;
  800e77:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  800e7e:	e9 6b ff ff ff       	jmp    800dee <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  800e83:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  800e84:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800e88:	0f 89 60 ff ff ff    	jns    800dee <vprintfmt+0x54>
				width = precision, precision = -1;
  800e8e:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800e91:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800e94:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  800e9b:	e9 4e ff ff ff       	jmp    800dee <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  800ea0:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  800ea3:	e9 46 ff ff ff       	jmp    800dee <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  800ea8:	8b 45 14             	mov    0x14(%ebp),%eax
  800eab:	83 c0 04             	add    $0x4,%eax
  800eae:	89 45 14             	mov    %eax,0x14(%ebp)
  800eb1:	8b 45 14             	mov    0x14(%ebp),%eax
  800eb4:	83 e8 04             	sub    $0x4,%eax
  800eb7:	8b 00                	mov    (%eax),%eax
  800eb9:	83 ec 08             	sub    $0x8,%esp
  800ebc:	ff 75 0c             	pushl  0xc(%ebp)
  800ebf:	50                   	push   %eax
  800ec0:	8b 45 08             	mov    0x8(%ebp),%eax
  800ec3:	ff d0                	call   *%eax
  800ec5:	83 c4 10             	add    $0x10,%esp
			break;
  800ec8:	e9 89 02 00 00       	jmp    801156 <vprintfmt+0x3bc>

		// error message
		case 'e':
			err = va_arg(ap, int);
  800ecd:	8b 45 14             	mov    0x14(%ebp),%eax
  800ed0:	83 c0 04             	add    $0x4,%eax
  800ed3:	89 45 14             	mov    %eax,0x14(%ebp)
  800ed6:	8b 45 14             	mov    0x14(%ebp),%eax
  800ed9:	83 e8 04             	sub    $0x4,%eax
  800edc:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  800ede:	85 db                	test   %ebx,%ebx
  800ee0:	79 02                	jns    800ee4 <vprintfmt+0x14a>
				err = -err;
  800ee2:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  800ee4:	83 fb 64             	cmp    $0x64,%ebx
  800ee7:	7f 0b                	jg     800ef4 <vprintfmt+0x15a>
  800ee9:	8b 34 9d c0 3b 80 00 	mov    0x803bc0(,%ebx,4),%esi
  800ef0:	85 f6                	test   %esi,%esi
  800ef2:	75 19                	jne    800f0d <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  800ef4:	53                   	push   %ebx
  800ef5:	68 65 3d 80 00       	push   $0x803d65
  800efa:	ff 75 0c             	pushl  0xc(%ebp)
  800efd:	ff 75 08             	pushl  0x8(%ebp)
  800f00:	e8 5e 02 00 00       	call   801163 <printfmt>
  800f05:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800f08:	e9 49 02 00 00       	jmp    801156 <vprintfmt+0x3bc>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800f0d:	56                   	push   %esi
  800f0e:	68 6e 3d 80 00       	push   $0x803d6e
  800f13:	ff 75 0c             	pushl  0xc(%ebp)
  800f16:	ff 75 08             	pushl  0x8(%ebp)
  800f19:	e8 45 02 00 00       	call   801163 <printfmt>
  800f1e:	83 c4 10             	add    $0x10,%esp
			break;
  800f21:	e9 30 02 00 00       	jmp    801156 <vprintfmt+0x3bc>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  800f26:	8b 45 14             	mov    0x14(%ebp),%eax
  800f29:	83 c0 04             	add    $0x4,%eax
  800f2c:	89 45 14             	mov    %eax,0x14(%ebp)
  800f2f:	8b 45 14             	mov    0x14(%ebp),%eax
  800f32:	83 e8 04             	sub    $0x4,%eax
  800f35:	8b 30                	mov    (%eax),%esi
  800f37:	85 f6                	test   %esi,%esi
  800f39:	75 05                	jne    800f40 <vprintfmt+0x1a6>
				p = "(null)";
  800f3b:	be 71 3d 80 00       	mov    $0x803d71,%esi
			if (width > 0 && padc != '-')
  800f40:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800f44:	7e 6d                	jle    800fb3 <vprintfmt+0x219>
  800f46:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  800f4a:	74 67                	je     800fb3 <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  800f4c:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800f4f:	83 ec 08             	sub    $0x8,%esp
  800f52:	50                   	push   %eax
  800f53:	56                   	push   %esi
  800f54:	e8 0c 03 00 00       	call   801265 <strnlen>
  800f59:	83 c4 10             	add    $0x10,%esp
  800f5c:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  800f5f:	eb 16                	jmp    800f77 <vprintfmt+0x1dd>
					putch(padc, putdat);
  800f61:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  800f65:	83 ec 08             	sub    $0x8,%esp
  800f68:	ff 75 0c             	pushl  0xc(%ebp)
  800f6b:	50                   	push   %eax
  800f6c:	8b 45 08             	mov    0x8(%ebp),%eax
  800f6f:	ff d0                	call   *%eax
  800f71:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800f74:	ff 4d e4             	decl   -0x1c(%ebp)
  800f77:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800f7b:	7f e4                	jg     800f61 <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800f7d:	eb 34                	jmp    800fb3 <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  800f7f:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800f83:	74 1c                	je     800fa1 <vprintfmt+0x207>
  800f85:	83 fb 1f             	cmp    $0x1f,%ebx
  800f88:	7e 05                	jle    800f8f <vprintfmt+0x1f5>
  800f8a:	83 fb 7e             	cmp    $0x7e,%ebx
  800f8d:	7e 12                	jle    800fa1 <vprintfmt+0x207>
					putch('?', putdat);
  800f8f:	83 ec 08             	sub    $0x8,%esp
  800f92:	ff 75 0c             	pushl  0xc(%ebp)
  800f95:	6a 3f                	push   $0x3f
  800f97:	8b 45 08             	mov    0x8(%ebp),%eax
  800f9a:	ff d0                	call   *%eax
  800f9c:	83 c4 10             	add    $0x10,%esp
  800f9f:	eb 0f                	jmp    800fb0 <vprintfmt+0x216>
				else
					putch(ch, putdat);
  800fa1:	83 ec 08             	sub    $0x8,%esp
  800fa4:	ff 75 0c             	pushl  0xc(%ebp)
  800fa7:	53                   	push   %ebx
  800fa8:	8b 45 08             	mov    0x8(%ebp),%eax
  800fab:	ff d0                	call   *%eax
  800fad:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800fb0:	ff 4d e4             	decl   -0x1c(%ebp)
  800fb3:	89 f0                	mov    %esi,%eax
  800fb5:	8d 70 01             	lea    0x1(%eax),%esi
  800fb8:	8a 00                	mov    (%eax),%al
  800fba:	0f be d8             	movsbl %al,%ebx
  800fbd:	85 db                	test   %ebx,%ebx
  800fbf:	74 24                	je     800fe5 <vprintfmt+0x24b>
  800fc1:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800fc5:	78 b8                	js     800f7f <vprintfmt+0x1e5>
  800fc7:	ff 4d e0             	decl   -0x20(%ebp)
  800fca:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800fce:	79 af                	jns    800f7f <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800fd0:	eb 13                	jmp    800fe5 <vprintfmt+0x24b>
				putch(' ', putdat);
  800fd2:	83 ec 08             	sub    $0x8,%esp
  800fd5:	ff 75 0c             	pushl  0xc(%ebp)
  800fd8:	6a 20                	push   $0x20
  800fda:	8b 45 08             	mov    0x8(%ebp),%eax
  800fdd:	ff d0                	call   *%eax
  800fdf:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800fe2:	ff 4d e4             	decl   -0x1c(%ebp)
  800fe5:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800fe9:	7f e7                	jg     800fd2 <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  800feb:	e9 66 01 00 00       	jmp    801156 <vprintfmt+0x3bc>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  800ff0:	83 ec 08             	sub    $0x8,%esp
  800ff3:	ff 75 e8             	pushl  -0x18(%ebp)
  800ff6:	8d 45 14             	lea    0x14(%ebp),%eax
  800ff9:	50                   	push   %eax
  800ffa:	e8 3c fd ff ff       	call   800d3b <getint>
  800fff:	83 c4 10             	add    $0x10,%esp
  801002:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801005:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  801008:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80100b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80100e:	85 d2                	test   %edx,%edx
  801010:	79 23                	jns    801035 <vprintfmt+0x29b>
				putch('-', putdat);
  801012:	83 ec 08             	sub    $0x8,%esp
  801015:	ff 75 0c             	pushl  0xc(%ebp)
  801018:	6a 2d                	push   $0x2d
  80101a:	8b 45 08             	mov    0x8(%ebp),%eax
  80101d:	ff d0                	call   *%eax
  80101f:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  801022:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801025:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801028:	f7 d8                	neg    %eax
  80102a:	83 d2 00             	adc    $0x0,%edx
  80102d:	f7 da                	neg    %edx
  80102f:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801032:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  801035:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  80103c:	e9 bc 00 00 00       	jmp    8010fd <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  801041:	83 ec 08             	sub    $0x8,%esp
  801044:	ff 75 e8             	pushl  -0x18(%ebp)
  801047:	8d 45 14             	lea    0x14(%ebp),%eax
  80104a:	50                   	push   %eax
  80104b:	e8 84 fc ff ff       	call   800cd4 <getuint>
  801050:	83 c4 10             	add    $0x10,%esp
  801053:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801056:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  801059:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  801060:	e9 98 00 00 00       	jmp    8010fd <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  801065:	83 ec 08             	sub    $0x8,%esp
  801068:	ff 75 0c             	pushl  0xc(%ebp)
  80106b:	6a 58                	push   $0x58
  80106d:	8b 45 08             	mov    0x8(%ebp),%eax
  801070:	ff d0                	call   *%eax
  801072:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  801075:	83 ec 08             	sub    $0x8,%esp
  801078:	ff 75 0c             	pushl  0xc(%ebp)
  80107b:	6a 58                	push   $0x58
  80107d:	8b 45 08             	mov    0x8(%ebp),%eax
  801080:	ff d0                	call   *%eax
  801082:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  801085:	83 ec 08             	sub    $0x8,%esp
  801088:	ff 75 0c             	pushl  0xc(%ebp)
  80108b:	6a 58                	push   $0x58
  80108d:	8b 45 08             	mov    0x8(%ebp),%eax
  801090:	ff d0                	call   *%eax
  801092:	83 c4 10             	add    $0x10,%esp
			break;
  801095:	e9 bc 00 00 00       	jmp    801156 <vprintfmt+0x3bc>

		// pointer
		case 'p':
			putch('0', putdat);
  80109a:	83 ec 08             	sub    $0x8,%esp
  80109d:	ff 75 0c             	pushl  0xc(%ebp)
  8010a0:	6a 30                	push   $0x30
  8010a2:	8b 45 08             	mov    0x8(%ebp),%eax
  8010a5:	ff d0                	call   *%eax
  8010a7:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  8010aa:	83 ec 08             	sub    $0x8,%esp
  8010ad:	ff 75 0c             	pushl  0xc(%ebp)
  8010b0:	6a 78                	push   $0x78
  8010b2:	8b 45 08             	mov    0x8(%ebp),%eax
  8010b5:	ff d0                	call   *%eax
  8010b7:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  8010ba:	8b 45 14             	mov    0x14(%ebp),%eax
  8010bd:	83 c0 04             	add    $0x4,%eax
  8010c0:	89 45 14             	mov    %eax,0x14(%ebp)
  8010c3:	8b 45 14             	mov    0x14(%ebp),%eax
  8010c6:	83 e8 04             	sub    $0x4,%eax
  8010c9:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  8010cb:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8010ce:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  8010d5:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  8010dc:	eb 1f                	jmp    8010fd <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  8010de:	83 ec 08             	sub    $0x8,%esp
  8010e1:	ff 75 e8             	pushl  -0x18(%ebp)
  8010e4:	8d 45 14             	lea    0x14(%ebp),%eax
  8010e7:	50                   	push   %eax
  8010e8:	e8 e7 fb ff ff       	call   800cd4 <getuint>
  8010ed:	83 c4 10             	add    $0x10,%esp
  8010f0:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8010f3:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  8010f6:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  8010fd:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  801101:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801104:	83 ec 04             	sub    $0x4,%esp
  801107:	52                   	push   %edx
  801108:	ff 75 e4             	pushl  -0x1c(%ebp)
  80110b:	50                   	push   %eax
  80110c:	ff 75 f4             	pushl  -0xc(%ebp)
  80110f:	ff 75 f0             	pushl  -0x10(%ebp)
  801112:	ff 75 0c             	pushl  0xc(%ebp)
  801115:	ff 75 08             	pushl  0x8(%ebp)
  801118:	e8 00 fb ff ff       	call   800c1d <printnum>
  80111d:	83 c4 20             	add    $0x20,%esp
			break;
  801120:	eb 34                	jmp    801156 <vprintfmt+0x3bc>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  801122:	83 ec 08             	sub    $0x8,%esp
  801125:	ff 75 0c             	pushl  0xc(%ebp)
  801128:	53                   	push   %ebx
  801129:	8b 45 08             	mov    0x8(%ebp),%eax
  80112c:	ff d0                	call   *%eax
  80112e:	83 c4 10             	add    $0x10,%esp
			break;
  801131:	eb 23                	jmp    801156 <vprintfmt+0x3bc>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  801133:	83 ec 08             	sub    $0x8,%esp
  801136:	ff 75 0c             	pushl  0xc(%ebp)
  801139:	6a 25                	push   $0x25
  80113b:	8b 45 08             	mov    0x8(%ebp),%eax
  80113e:	ff d0                	call   *%eax
  801140:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  801143:	ff 4d 10             	decl   0x10(%ebp)
  801146:	eb 03                	jmp    80114b <vprintfmt+0x3b1>
  801148:	ff 4d 10             	decl   0x10(%ebp)
  80114b:	8b 45 10             	mov    0x10(%ebp),%eax
  80114e:	48                   	dec    %eax
  80114f:	8a 00                	mov    (%eax),%al
  801151:	3c 25                	cmp    $0x25,%al
  801153:	75 f3                	jne    801148 <vprintfmt+0x3ae>
				/* do nothing */;
			break;
  801155:	90                   	nop
		}
	}
  801156:	e9 47 fc ff ff       	jmp    800da2 <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  80115b:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  80115c:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80115f:	5b                   	pop    %ebx
  801160:	5e                   	pop    %esi
  801161:	5d                   	pop    %ebp
  801162:	c3                   	ret    

00801163 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  801163:	55                   	push   %ebp
  801164:	89 e5                	mov    %esp,%ebp
  801166:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  801169:	8d 45 10             	lea    0x10(%ebp),%eax
  80116c:	83 c0 04             	add    $0x4,%eax
  80116f:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  801172:	8b 45 10             	mov    0x10(%ebp),%eax
  801175:	ff 75 f4             	pushl  -0xc(%ebp)
  801178:	50                   	push   %eax
  801179:	ff 75 0c             	pushl  0xc(%ebp)
  80117c:	ff 75 08             	pushl  0x8(%ebp)
  80117f:	e8 16 fc ff ff       	call   800d9a <vprintfmt>
  801184:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  801187:	90                   	nop
  801188:	c9                   	leave  
  801189:	c3                   	ret    

0080118a <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  80118a:	55                   	push   %ebp
  80118b:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  80118d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801190:	8b 40 08             	mov    0x8(%eax),%eax
  801193:	8d 50 01             	lea    0x1(%eax),%edx
  801196:	8b 45 0c             	mov    0xc(%ebp),%eax
  801199:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  80119c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80119f:	8b 10                	mov    (%eax),%edx
  8011a1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011a4:	8b 40 04             	mov    0x4(%eax),%eax
  8011a7:	39 c2                	cmp    %eax,%edx
  8011a9:	73 12                	jae    8011bd <sprintputch+0x33>
		*b->buf++ = ch;
  8011ab:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011ae:	8b 00                	mov    (%eax),%eax
  8011b0:	8d 48 01             	lea    0x1(%eax),%ecx
  8011b3:	8b 55 0c             	mov    0xc(%ebp),%edx
  8011b6:	89 0a                	mov    %ecx,(%edx)
  8011b8:	8b 55 08             	mov    0x8(%ebp),%edx
  8011bb:	88 10                	mov    %dl,(%eax)
}
  8011bd:	90                   	nop
  8011be:	5d                   	pop    %ebp
  8011bf:	c3                   	ret    

008011c0 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  8011c0:	55                   	push   %ebp
  8011c1:	89 e5                	mov    %esp,%ebp
  8011c3:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  8011c6:	8b 45 08             	mov    0x8(%ebp),%eax
  8011c9:	89 45 ec             	mov    %eax,-0x14(%ebp)
  8011cc:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011cf:	8d 50 ff             	lea    -0x1(%eax),%edx
  8011d2:	8b 45 08             	mov    0x8(%ebp),%eax
  8011d5:	01 d0                	add    %edx,%eax
  8011d7:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8011da:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  8011e1:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8011e5:	74 06                	je     8011ed <vsnprintf+0x2d>
  8011e7:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8011eb:	7f 07                	jg     8011f4 <vsnprintf+0x34>
		return -E_INVAL;
  8011ed:	b8 03 00 00 00       	mov    $0x3,%eax
  8011f2:	eb 20                	jmp    801214 <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  8011f4:	ff 75 14             	pushl  0x14(%ebp)
  8011f7:	ff 75 10             	pushl  0x10(%ebp)
  8011fa:	8d 45 ec             	lea    -0x14(%ebp),%eax
  8011fd:	50                   	push   %eax
  8011fe:	68 8a 11 80 00       	push   $0x80118a
  801203:	e8 92 fb ff ff       	call   800d9a <vprintfmt>
  801208:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  80120b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80120e:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  801211:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  801214:	c9                   	leave  
  801215:	c3                   	ret    

00801216 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  801216:	55                   	push   %ebp
  801217:	89 e5                	mov    %esp,%ebp
  801219:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  80121c:	8d 45 10             	lea    0x10(%ebp),%eax
  80121f:	83 c0 04             	add    $0x4,%eax
  801222:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  801225:	8b 45 10             	mov    0x10(%ebp),%eax
  801228:	ff 75 f4             	pushl  -0xc(%ebp)
  80122b:	50                   	push   %eax
  80122c:	ff 75 0c             	pushl  0xc(%ebp)
  80122f:	ff 75 08             	pushl  0x8(%ebp)
  801232:	e8 89 ff ff ff       	call   8011c0 <vsnprintf>
  801237:	83 c4 10             	add    $0x10,%esp
  80123a:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  80123d:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801240:	c9                   	leave  
  801241:	c3                   	ret    

00801242 <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  801242:	55                   	push   %ebp
  801243:	89 e5                	mov    %esp,%ebp
  801245:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  801248:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  80124f:	eb 06                	jmp    801257 <strlen+0x15>
		n++;
  801251:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  801254:	ff 45 08             	incl   0x8(%ebp)
  801257:	8b 45 08             	mov    0x8(%ebp),%eax
  80125a:	8a 00                	mov    (%eax),%al
  80125c:	84 c0                	test   %al,%al
  80125e:	75 f1                	jne    801251 <strlen+0xf>
		n++;
	return n;
  801260:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  801263:	c9                   	leave  
  801264:	c3                   	ret    

00801265 <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  801265:	55                   	push   %ebp
  801266:	89 e5                	mov    %esp,%ebp
  801268:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  80126b:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801272:	eb 09                	jmp    80127d <strnlen+0x18>
		n++;
  801274:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  801277:	ff 45 08             	incl   0x8(%ebp)
  80127a:	ff 4d 0c             	decl   0xc(%ebp)
  80127d:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801281:	74 09                	je     80128c <strnlen+0x27>
  801283:	8b 45 08             	mov    0x8(%ebp),%eax
  801286:	8a 00                	mov    (%eax),%al
  801288:	84 c0                	test   %al,%al
  80128a:	75 e8                	jne    801274 <strnlen+0xf>
		n++;
	return n;
  80128c:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  80128f:	c9                   	leave  
  801290:	c3                   	ret    

00801291 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  801291:	55                   	push   %ebp
  801292:	89 e5                	mov    %esp,%ebp
  801294:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  801297:	8b 45 08             	mov    0x8(%ebp),%eax
  80129a:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  80129d:	90                   	nop
  80129e:	8b 45 08             	mov    0x8(%ebp),%eax
  8012a1:	8d 50 01             	lea    0x1(%eax),%edx
  8012a4:	89 55 08             	mov    %edx,0x8(%ebp)
  8012a7:	8b 55 0c             	mov    0xc(%ebp),%edx
  8012aa:	8d 4a 01             	lea    0x1(%edx),%ecx
  8012ad:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  8012b0:	8a 12                	mov    (%edx),%dl
  8012b2:	88 10                	mov    %dl,(%eax)
  8012b4:	8a 00                	mov    (%eax),%al
  8012b6:	84 c0                	test   %al,%al
  8012b8:	75 e4                	jne    80129e <strcpy+0xd>
		/* do nothing */;
	return ret;
  8012ba:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  8012bd:	c9                   	leave  
  8012be:	c3                   	ret    

008012bf <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  8012bf:	55                   	push   %ebp
  8012c0:	89 e5                	mov    %esp,%ebp
  8012c2:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  8012c5:	8b 45 08             	mov    0x8(%ebp),%eax
  8012c8:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  8012cb:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8012d2:	eb 1f                	jmp    8012f3 <strncpy+0x34>
		*dst++ = *src;
  8012d4:	8b 45 08             	mov    0x8(%ebp),%eax
  8012d7:	8d 50 01             	lea    0x1(%eax),%edx
  8012da:	89 55 08             	mov    %edx,0x8(%ebp)
  8012dd:	8b 55 0c             	mov    0xc(%ebp),%edx
  8012e0:	8a 12                	mov    (%edx),%dl
  8012e2:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  8012e4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012e7:	8a 00                	mov    (%eax),%al
  8012e9:	84 c0                	test   %al,%al
  8012eb:	74 03                	je     8012f0 <strncpy+0x31>
			src++;
  8012ed:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  8012f0:	ff 45 fc             	incl   -0x4(%ebp)
  8012f3:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8012f6:	3b 45 10             	cmp    0x10(%ebp),%eax
  8012f9:	72 d9                	jb     8012d4 <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  8012fb:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  8012fe:	c9                   	leave  
  8012ff:	c3                   	ret    

00801300 <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  801300:	55                   	push   %ebp
  801301:	89 e5                	mov    %esp,%ebp
  801303:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  801306:	8b 45 08             	mov    0x8(%ebp),%eax
  801309:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  80130c:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801310:	74 30                	je     801342 <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  801312:	eb 16                	jmp    80132a <strlcpy+0x2a>
			*dst++ = *src++;
  801314:	8b 45 08             	mov    0x8(%ebp),%eax
  801317:	8d 50 01             	lea    0x1(%eax),%edx
  80131a:	89 55 08             	mov    %edx,0x8(%ebp)
  80131d:	8b 55 0c             	mov    0xc(%ebp),%edx
  801320:	8d 4a 01             	lea    0x1(%edx),%ecx
  801323:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  801326:	8a 12                	mov    (%edx),%dl
  801328:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  80132a:	ff 4d 10             	decl   0x10(%ebp)
  80132d:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801331:	74 09                	je     80133c <strlcpy+0x3c>
  801333:	8b 45 0c             	mov    0xc(%ebp),%eax
  801336:	8a 00                	mov    (%eax),%al
  801338:	84 c0                	test   %al,%al
  80133a:	75 d8                	jne    801314 <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  80133c:	8b 45 08             	mov    0x8(%ebp),%eax
  80133f:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  801342:	8b 55 08             	mov    0x8(%ebp),%edx
  801345:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801348:	29 c2                	sub    %eax,%edx
  80134a:	89 d0                	mov    %edx,%eax
}
  80134c:	c9                   	leave  
  80134d:	c3                   	ret    

0080134e <strcmp>:

int
strcmp(const char *p, const char *q)
{
  80134e:	55                   	push   %ebp
  80134f:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  801351:	eb 06                	jmp    801359 <strcmp+0xb>
		p++, q++;
  801353:	ff 45 08             	incl   0x8(%ebp)
  801356:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  801359:	8b 45 08             	mov    0x8(%ebp),%eax
  80135c:	8a 00                	mov    (%eax),%al
  80135e:	84 c0                	test   %al,%al
  801360:	74 0e                	je     801370 <strcmp+0x22>
  801362:	8b 45 08             	mov    0x8(%ebp),%eax
  801365:	8a 10                	mov    (%eax),%dl
  801367:	8b 45 0c             	mov    0xc(%ebp),%eax
  80136a:	8a 00                	mov    (%eax),%al
  80136c:	38 c2                	cmp    %al,%dl
  80136e:	74 e3                	je     801353 <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  801370:	8b 45 08             	mov    0x8(%ebp),%eax
  801373:	8a 00                	mov    (%eax),%al
  801375:	0f b6 d0             	movzbl %al,%edx
  801378:	8b 45 0c             	mov    0xc(%ebp),%eax
  80137b:	8a 00                	mov    (%eax),%al
  80137d:	0f b6 c0             	movzbl %al,%eax
  801380:	29 c2                	sub    %eax,%edx
  801382:	89 d0                	mov    %edx,%eax
}
  801384:	5d                   	pop    %ebp
  801385:	c3                   	ret    

00801386 <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  801386:	55                   	push   %ebp
  801387:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  801389:	eb 09                	jmp    801394 <strncmp+0xe>
		n--, p++, q++;
  80138b:	ff 4d 10             	decl   0x10(%ebp)
  80138e:	ff 45 08             	incl   0x8(%ebp)
  801391:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  801394:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801398:	74 17                	je     8013b1 <strncmp+0x2b>
  80139a:	8b 45 08             	mov    0x8(%ebp),%eax
  80139d:	8a 00                	mov    (%eax),%al
  80139f:	84 c0                	test   %al,%al
  8013a1:	74 0e                	je     8013b1 <strncmp+0x2b>
  8013a3:	8b 45 08             	mov    0x8(%ebp),%eax
  8013a6:	8a 10                	mov    (%eax),%dl
  8013a8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8013ab:	8a 00                	mov    (%eax),%al
  8013ad:	38 c2                	cmp    %al,%dl
  8013af:	74 da                	je     80138b <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  8013b1:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8013b5:	75 07                	jne    8013be <strncmp+0x38>
		return 0;
  8013b7:	b8 00 00 00 00       	mov    $0x0,%eax
  8013bc:	eb 14                	jmp    8013d2 <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  8013be:	8b 45 08             	mov    0x8(%ebp),%eax
  8013c1:	8a 00                	mov    (%eax),%al
  8013c3:	0f b6 d0             	movzbl %al,%edx
  8013c6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8013c9:	8a 00                	mov    (%eax),%al
  8013cb:	0f b6 c0             	movzbl %al,%eax
  8013ce:	29 c2                	sub    %eax,%edx
  8013d0:	89 d0                	mov    %edx,%eax
}
  8013d2:	5d                   	pop    %ebp
  8013d3:	c3                   	ret    

008013d4 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  8013d4:	55                   	push   %ebp
  8013d5:	89 e5                	mov    %esp,%ebp
  8013d7:	83 ec 04             	sub    $0x4,%esp
  8013da:	8b 45 0c             	mov    0xc(%ebp),%eax
  8013dd:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  8013e0:	eb 12                	jmp    8013f4 <strchr+0x20>
		if (*s == c)
  8013e2:	8b 45 08             	mov    0x8(%ebp),%eax
  8013e5:	8a 00                	mov    (%eax),%al
  8013e7:	3a 45 fc             	cmp    -0x4(%ebp),%al
  8013ea:	75 05                	jne    8013f1 <strchr+0x1d>
			return (char *) s;
  8013ec:	8b 45 08             	mov    0x8(%ebp),%eax
  8013ef:	eb 11                	jmp    801402 <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  8013f1:	ff 45 08             	incl   0x8(%ebp)
  8013f4:	8b 45 08             	mov    0x8(%ebp),%eax
  8013f7:	8a 00                	mov    (%eax),%al
  8013f9:	84 c0                	test   %al,%al
  8013fb:	75 e5                	jne    8013e2 <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  8013fd:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801402:	c9                   	leave  
  801403:	c3                   	ret    

00801404 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  801404:	55                   	push   %ebp
  801405:	89 e5                	mov    %esp,%ebp
  801407:	83 ec 04             	sub    $0x4,%esp
  80140a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80140d:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  801410:	eb 0d                	jmp    80141f <strfind+0x1b>
		if (*s == c)
  801412:	8b 45 08             	mov    0x8(%ebp),%eax
  801415:	8a 00                	mov    (%eax),%al
  801417:	3a 45 fc             	cmp    -0x4(%ebp),%al
  80141a:	74 0e                	je     80142a <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  80141c:	ff 45 08             	incl   0x8(%ebp)
  80141f:	8b 45 08             	mov    0x8(%ebp),%eax
  801422:	8a 00                	mov    (%eax),%al
  801424:	84 c0                	test   %al,%al
  801426:	75 ea                	jne    801412 <strfind+0xe>
  801428:	eb 01                	jmp    80142b <strfind+0x27>
		if (*s == c)
			break;
  80142a:	90                   	nop
	return (char *) s;
  80142b:	8b 45 08             	mov    0x8(%ebp),%eax
}
  80142e:	c9                   	leave  
  80142f:	c3                   	ret    

00801430 <memset>:


void *
memset(void *v, int c, uint32 n)
{
  801430:	55                   	push   %ebp
  801431:	89 e5                	mov    %esp,%ebp
  801433:	83 ec 10             	sub    $0x10,%esp
	char *p;
	int m;

	p = v;
  801436:	8b 45 08             	mov    0x8(%ebp),%eax
  801439:	89 45 fc             	mov    %eax,-0x4(%ebp)
	m = n;
  80143c:	8b 45 10             	mov    0x10(%ebp),%eax
  80143f:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (--m >= 0)
  801442:	eb 0e                	jmp    801452 <memset+0x22>
		*p++ = c;
  801444:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801447:	8d 50 01             	lea    0x1(%eax),%edx
  80144a:	89 55 fc             	mov    %edx,-0x4(%ebp)
  80144d:	8b 55 0c             	mov    0xc(%ebp),%edx
  801450:	88 10                	mov    %dl,(%eax)
	char *p;
	int m;

	p = v;
	m = n;
	while (--m >= 0)
  801452:	ff 4d f8             	decl   -0x8(%ebp)
  801455:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  801459:	79 e9                	jns    801444 <memset+0x14>
		*p++ = c;

	return v;
  80145b:	8b 45 08             	mov    0x8(%ebp),%eax
}
  80145e:	c9                   	leave  
  80145f:	c3                   	ret    

00801460 <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  801460:	55                   	push   %ebp
  801461:	89 e5                	mov    %esp,%ebp
  801463:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  801466:	8b 45 0c             	mov    0xc(%ebp),%eax
  801469:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  80146c:	8b 45 08             	mov    0x8(%ebp),%eax
  80146f:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (n-- > 0)
  801472:	eb 16                	jmp    80148a <memcpy+0x2a>
		*d++ = *s++;
  801474:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801477:	8d 50 01             	lea    0x1(%eax),%edx
  80147a:	89 55 f8             	mov    %edx,-0x8(%ebp)
  80147d:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801480:	8d 4a 01             	lea    0x1(%edx),%ecx
  801483:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  801486:	8a 12                	mov    (%edx),%dl
  801488:	88 10                	mov    %dl,(%eax)
	const char *s;
	char *d;

	s = src;
	d = dst;
	while (n-- > 0)
  80148a:	8b 45 10             	mov    0x10(%ebp),%eax
  80148d:	8d 50 ff             	lea    -0x1(%eax),%edx
  801490:	89 55 10             	mov    %edx,0x10(%ebp)
  801493:	85 c0                	test   %eax,%eax
  801495:	75 dd                	jne    801474 <memcpy+0x14>
		*d++ = *s++;

	return dst;
  801497:	8b 45 08             	mov    0x8(%ebp),%eax
}
  80149a:	c9                   	leave  
  80149b:	c3                   	ret    

0080149c <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  80149c:	55                   	push   %ebp
  80149d:	89 e5                	mov    %esp,%ebp
  80149f:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  8014a2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8014a5:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  8014a8:	8b 45 08             	mov    0x8(%ebp),%eax
  8014ab:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  8014ae:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8014b1:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  8014b4:	73 50                	jae    801506 <memmove+0x6a>
  8014b6:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8014b9:	8b 45 10             	mov    0x10(%ebp),%eax
  8014bc:	01 d0                	add    %edx,%eax
  8014be:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  8014c1:	76 43                	jbe    801506 <memmove+0x6a>
		s += n;
  8014c3:	8b 45 10             	mov    0x10(%ebp),%eax
  8014c6:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  8014c9:	8b 45 10             	mov    0x10(%ebp),%eax
  8014cc:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  8014cf:	eb 10                	jmp    8014e1 <memmove+0x45>
			*--d = *--s;
  8014d1:	ff 4d f8             	decl   -0x8(%ebp)
  8014d4:	ff 4d fc             	decl   -0x4(%ebp)
  8014d7:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8014da:	8a 10                	mov    (%eax),%dl
  8014dc:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8014df:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  8014e1:	8b 45 10             	mov    0x10(%ebp),%eax
  8014e4:	8d 50 ff             	lea    -0x1(%eax),%edx
  8014e7:	89 55 10             	mov    %edx,0x10(%ebp)
  8014ea:	85 c0                	test   %eax,%eax
  8014ec:	75 e3                	jne    8014d1 <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  8014ee:	eb 23                	jmp    801513 <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  8014f0:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8014f3:	8d 50 01             	lea    0x1(%eax),%edx
  8014f6:	89 55 f8             	mov    %edx,-0x8(%ebp)
  8014f9:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8014fc:	8d 4a 01             	lea    0x1(%edx),%ecx
  8014ff:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  801502:	8a 12                	mov    (%edx),%dl
  801504:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  801506:	8b 45 10             	mov    0x10(%ebp),%eax
  801509:	8d 50 ff             	lea    -0x1(%eax),%edx
  80150c:	89 55 10             	mov    %edx,0x10(%ebp)
  80150f:	85 c0                	test   %eax,%eax
  801511:	75 dd                	jne    8014f0 <memmove+0x54>
			*d++ = *s++;

	return dst;
  801513:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801516:	c9                   	leave  
  801517:	c3                   	ret    

00801518 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  801518:	55                   	push   %ebp
  801519:	89 e5                	mov    %esp,%ebp
  80151b:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  80151e:	8b 45 08             	mov    0x8(%ebp),%eax
  801521:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  801524:	8b 45 0c             	mov    0xc(%ebp),%eax
  801527:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  80152a:	eb 2a                	jmp    801556 <memcmp+0x3e>
		if (*s1 != *s2)
  80152c:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80152f:	8a 10                	mov    (%eax),%dl
  801531:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801534:	8a 00                	mov    (%eax),%al
  801536:	38 c2                	cmp    %al,%dl
  801538:	74 16                	je     801550 <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  80153a:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80153d:	8a 00                	mov    (%eax),%al
  80153f:	0f b6 d0             	movzbl %al,%edx
  801542:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801545:	8a 00                	mov    (%eax),%al
  801547:	0f b6 c0             	movzbl %al,%eax
  80154a:	29 c2                	sub    %eax,%edx
  80154c:	89 d0                	mov    %edx,%eax
  80154e:	eb 18                	jmp    801568 <memcmp+0x50>
		s1++, s2++;
  801550:	ff 45 fc             	incl   -0x4(%ebp)
  801553:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  801556:	8b 45 10             	mov    0x10(%ebp),%eax
  801559:	8d 50 ff             	lea    -0x1(%eax),%edx
  80155c:	89 55 10             	mov    %edx,0x10(%ebp)
  80155f:	85 c0                	test   %eax,%eax
  801561:	75 c9                	jne    80152c <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  801563:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801568:	c9                   	leave  
  801569:	c3                   	ret    

0080156a <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  80156a:	55                   	push   %ebp
  80156b:	89 e5                	mov    %esp,%ebp
  80156d:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  801570:	8b 55 08             	mov    0x8(%ebp),%edx
  801573:	8b 45 10             	mov    0x10(%ebp),%eax
  801576:	01 d0                	add    %edx,%eax
  801578:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  80157b:	eb 15                	jmp    801592 <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  80157d:	8b 45 08             	mov    0x8(%ebp),%eax
  801580:	8a 00                	mov    (%eax),%al
  801582:	0f b6 d0             	movzbl %al,%edx
  801585:	8b 45 0c             	mov    0xc(%ebp),%eax
  801588:	0f b6 c0             	movzbl %al,%eax
  80158b:	39 c2                	cmp    %eax,%edx
  80158d:	74 0d                	je     80159c <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  80158f:	ff 45 08             	incl   0x8(%ebp)
  801592:	8b 45 08             	mov    0x8(%ebp),%eax
  801595:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  801598:	72 e3                	jb     80157d <memfind+0x13>
  80159a:	eb 01                	jmp    80159d <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  80159c:	90                   	nop
	return (void *) s;
  80159d:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8015a0:	c9                   	leave  
  8015a1:	c3                   	ret    

008015a2 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  8015a2:	55                   	push   %ebp
  8015a3:	89 e5                	mov    %esp,%ebp
  8015a5:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  8015a8:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  8015af:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  8015b6:	eb 03                	jmp    8015bb <strtol+0x19>
		s++;
  8015b8:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  8015bb:	8b 45 08             	mov    0x8(%ebp),%eax
  8015be:	8a 00                	mov    (%eax),%al
  8015c0:	3c 20                	cmp    $0x20,%al
  8015c2:	74 f4                	je     8015b8 <strtol+0x16>
  8015c4:	8b 45 08             	mov    0x8(%ebp),%eax
  8015c7:	8a 00                	mov    (%eax),%al
  8015c9:	3c 09                	cmp    $0x9,%al
  8015cb:	74 eb                	je     8015b8 <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  8015cd:	8b 45 08             	mov    0x8(%ebp),%eax
  8015d0:	8a 00                	mov    (%eax),%al
  8015d2:	3c 2b                	cmp    $0x2b,%al
  8015d4:	75 05                	jne    8015db <strtol+0x39>
		s++;
  8015d6:	ff 45 08             	incl   0x8(%ebp)
  8015d9:	eb 13                	jmp    8015ee <strtol+0x4c>
	else if (*s == '-')
  8015db:	8b 45 08             	mov    0x8(%ebp),%eax
  8015de:	8a 00                	mov    (%eax),%al
  8015e0:	3c 2d                	cmp    $0x2d,%al
  8015e2:	75 0a                	jne    8015ee <strtol+0x4c>
		s++, neg = 1;
  8015e4:	ff 45 08             	incl   0x8(%ebp)
  8015e7:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  8015ee:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8015f2:	74 06                	je     8015fa <strtol+0x58>
  8015f4:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  8015f8:	75 20                	jne    80161a <strtol+0x78>
  8015fa:	8b 45 08             	mov    0x8(%ebp),%eax
  8015fd:	8a 00                	mov    (%eax),%al
  8015ff:	3c 30                	cmp    $0x30,%al
  801601:	75 17                	jne    80161a <strtol+0x78>
  801603:	8b 45 08             	mov    0x8(%ebp),%eax
  801606:	40                   	inc    %eax
  801607:	8a 00                	mov    (%eax),%al
  801609:	3c 78                	cmp    $0x78,%al
  80160b:	75 0d                	jne    80161a <strtol+0x78>
		s += 2, base = 16;
  80160d:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  801611:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  801618:	eb 28                	jmp    801642 <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  80161a:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80161e:	75 15                	jne    801635 <strtol+0x93>
  801620:	8b 45 08             	mov    0x8(%ebp),%eax
  801623:	8a 00                	mov    (%eax),%al
  801625:	3c 30                	cmp    $0x30,%al
  801627:	75 0c                	jne    801635 <strtol+0x93>
		s++, base = 8;
  801629:	ff 45 08             	incl   0x8(%ebp)
  80162c:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  801633:	eb 0d                	jmp    801642 <strtol+0xa0>
	else if (base == 0)
  801635:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801639:	75 07                	jne    801642 <strtol+0xa0>
		base = 10;
  80163b:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  801642:	8b 45 08             	mov    0x8(%ebp),%eax
  801645:	8a 00                	mov    (%eax),%al
  801647:	3c 2f                	cmp    $0x2f,%al
  801649:	7e 19                	jle    801664 <strtol+0xc2>
  80164b:	8b 45 08             	mov    0x8(%ebp),%eax
  80164e:	8a 00                	mov    (%eax),%al
  801650:	3c 39                	cmp    $0x39,%al
  801652:	7f 10                	jg     801664 <strtol+0xc2>
			dig = *s - '0';
  801654:	8b 45 08             	mov    0x8(%ebp),%eax
  801657:	8a 00                	mov    (%eax),%al
  801659:	0f be c0             	movsbl %al,%eax
  80165c:	83 e8 30             	sub    $0x30,%eax
  80165f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801662:	eb 42                	jmp    8016a6 <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  801664:	8b 45 08             	mov    0x8(%ebp),%eax
  801667:	8a 00                	mov    (%eax),%al
  801669:	3c 60                	cmp    $0x60,%al
  80166b:	7e 19                	jle    801686 <strtol+0xe4>
  80166d:	8b 45 08             	mov    0x8(%ebp),%eax
  801670:	8a 00                	mov    (%eax),%al
  801672:	3c 7a                	cmp    $0x7a,%al
  801674:	7f 10                	jg     801686 <strtol+0xe4>
			dig = *s - 'a' + 10;
  801676:	8b 45 08             	mov    0x8(%ebp),%eax
  801679:	8a 00                	mov    (%eax),%al
  80167b:	0f be c0             	movsbl %al,%eax
  80167e:	83 e8 57             	sub    $0x57,%eax
  801681:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801684:	eb 20                	jmp    8016a6 <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  801686:	8b 45 08             	mov    0x8(%ebp),%eax
  801689:	8a 00                	mov    (%eax),%al
  80168b:	3c 40                	cmp    $0x40,%al
  80168d:	7e 39                	jle    8016c8 <strtol+0x126>
  80168f:	8b 45 08             	mov    0x8(%ebp),%eax
  801692:	8a 00                	mov    (%eax),%al
  801694:	3c 5a                	cmp    $0x5a,%al
  801696:	7f 30                	jg     8016c8 <strtol+0x126>
			dig = *s - 'A' + 10;
  801698:	8b 45 08             	mov    0x8(%ebp),%eax
  80169b:	8a 00                	mov    (%eax),%al
  80169d:	0f be c0             	movsbl %al,%eax
  8016a0:	83 e8 37             	sub    $0x37,%eax
  8016a3:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  8016a6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8016a9:	3b 45 10             	cmp    0x10(%ebp),%eax
  8016ac:	7d 19                	jge    8016c7 <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  8016ae:	ff 45 08             	incl   0x8(%ebp)
  8016b1:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8016b4:	0f af 45 10          	imul   0x10(%ebp),%eax
  8016b8:	89 c2                	mov    %eax,%edx
  8016ba:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8016bd:	01 d0                	add    %edx,%eax
  8016bf:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  8016c2:	e9 7b ff ff ff       	jmp    801642 <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  8016c7:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  8016c8:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8016cc:	74 08                	je     8016d6 <strtol+0x134>
		*endptr = (char *) s;
  8016ce:	8b 45 0c             	mov    0xc(%ebp),%eax
  8016d1:	8b 55 08             	mov    0x8(%ebp),%edx
  8016d4:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  8016d6:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8016da:	74 07                	je     8016e3 <strtol+0x141>
  8016dc:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8016df:	f7 d8                	neg    %eax
  8016e1:	eb 03                	jmp    8016e6 <strtol+0x144>
  8016e3:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  8016e6:	c9                   	leave  
  8016e7:	c3                   	ret    

008016e8 <ltostr>:

void
ltostr(long value, char *str)
{
  8016e8:	55                   	push   %ebp
  8016e9:	89 e5                	mov    %esp,%ebp
  8016eb:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  8016ee:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  8016f5:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  8016fc:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801700:	79 13                	jns    801715 <ltostr+0x2d>
	{
		neg = 1;
  801702:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  801709:	8b 45 0c             	mov    0xc(%ebp),%eax
  80170c:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  80170f:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  801712:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  801715:	8b 45 08             	mov    0x8(%ebp),%eax
  801718:	b9 0a 00 00 00       	mov    $0xa,%ecx
  80171d:	99                   	cltd   
  80171e:	f7 f9                	idiv   %ecx
  801720:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  801723:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801726:	8d 50 01             	lea    0x1(%eax),%edx
  801729:	89 55 f8             	mov    %edx,-0x8(%ebp)
  80172c:	89 c2                	mov    %eax,%edx
  80172e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801731:	01 d0                	add    %edx,%eax
  801733:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801736:	83 c2 30             	add    $0x30,%edx
  801739:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  80173b:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80173e:	b8 67 66 66 66       	mov    $0x66666667,%eax
  801743:	f7 e9                	imul   %ecx
  801745:	c1 fa 02             	sar    $0x2,%edx
  801748:	89 c8                	mov    %ecx,%eax
  80174a:	c1 f8 1f             	sar    $0x1f,%eax
  80174d:	29 c2                	sub    %eax,%edx
  80174f:	89 d0                	mov    %edx,%eax
  801751:	89 45 08             	mov    %eax,0x8(%ebp)
	} while (value % 10 != 0);
  801754:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801757:	b8 67 66 66 66       	mov    $0x66666667,%eax
  80175c:	f7 e9                	imul   %ecx
  80175e:	c1 fa 02             	sar    $0x2,%edx
  801761:	89 c8                	mov    %ecx,%eax
  801763:	c1 f8 1f             	sar    $0x1f,%eax
  801766:	29 c2                	sub    %eax,%edx
  801768:	89 d0                	mov    %edx,%eax
  80176a:	c1 e0 02             	shl    $0x2,%eax
  80176d:	01 d0                	add    %edx,%eax
  80176f:	01 c0                	add    %eax,%eax
  801771:	29 c1                	sub    %eax,%ecx
  801773:	89 ca                	mov    %ecx,%edx
  801775:	85 d2                	test   %edx,%edx
  801777:	75 9c                	jne    801715 <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  801779:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  801780:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801783:	48                   	dec    %eax
  801784:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  801787:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  80178b:	74 3d                	je     8017ca <ltostr+0xe2>
		start = 1 ;
  80178d:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  801794:	eb 34                	jmp    8017ca <ltostr+0xe2>
	{
		char tmp = str[start] ;
  801796:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801799:	8b 45 0c             	mov    0xc(%ebp),%eax
  80179c:	01 d0                	add    %edx,%eax
  80179e:	8a 00                	mov    (%eax),%al
  8017a0:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  8017a3:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8017a6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8017a9:	01 c2                	add    %eax,%edx
  8017ab:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  8017ae:	8b 45 0c             	mov    0xc(%ebp),%eax
  8017b1:	01 c8                	add    %ecx,%eax
  8017b3:	8a 00                	mov    (%eax),%al
  8017b5:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  8017b7:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8017ba:	8b 45 0c             	mov    0xc(%ebp),%eax
  8017bd:	01 c2                	add    %eax,%edx
  8017bf:	8a 45 eb             	mov    -0x15(%ebp),%al
  8017c2:	88 02                	mov    %al,(%edx)
		start++ ;
  8017c4:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  8017c7:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  8017ca:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8017cd:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8017d0:	7c c4                	jl     801796 <ltostr+0xae>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  8017d2:	8b 55 f8             	mov    -0x8(%ebp),%edx
  8017d5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8017d8:	01 d0                	add    %edx,%eax
  8017da:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  8017dd:	90                   	nop
  8017de:	c9                   	leave  
  8017df:	c3                   	ret    

008017e0 <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  8017e0:	55                   	push   %ebp
  8017e1:	89 e5                	mov    %esp,%ebp
  8017e3:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  8017e6:	ff 75 08             	pushl  0x8(%ebp)
  8017e9:	e8 54 fa ff ff       	call   801242 <strlen>
  8017ee:	83 c4 04             	add    $0x4,%esp
  8017f1:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  8017f4:	ff 75 0c             	pushl  0xc(%ebp)
  8017f7:	e8 46 fa ff ff       	call   801242 <strlen>
  8017fc:	83 c4 04             	add    $0x4,%esp
  8017ff:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  801802:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  801809:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801810:	eb 17                	jmp    801829 <strcconcat+0x49>
		final[s] = str1[s] ;
  801812:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801815:	8b 45 10             	mov    0x10(%ebp),%eax
  801818:	01 c2                	add    %eax,%edx
  80181a:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  80181d:	8b 45 08             	mov    0x8(%ebp),%eax
  801820:	01 c8                	add    %ecx,%eax
  801822:	8a 00                	mov    (%eax),%al
  801824:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  801826:	ff 45 fc             	incl   -0x4(%ebp)
  801829:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80182c:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  80182f:	7c e1                	jl     801812 <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  801831:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  801838:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  80183f:	eb 1f                	jmp    801860 <strcconcat+0x80>
		final[s++] = str2[i] ;
  801841:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801844:	8d 50 01             	lea    0x1(%eax),%edx
  801847:	89 55 fc             	mov    %edx,-0x4(%ebp)
  80184a:	89 c2                	mov    %eax,%edx
  80184c:	8b 45 10             	mov    0x10(%ebp),%eax
  80184f:	01 c2                	add    %eax,%edx
  801851:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  801854:	8b 45 0c             	mov    0xc(%ebp),%eax
  801857:	01 c8                	add    %ecx,%eax
  801859:	8a 00                	mov    (%eax),%al
  80185b:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  80185d:	ff 45 f8             	incl   -0x8(%ebp)
  801860:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801863:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801866:	7c d9                	jl     801841 <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  801868:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80186b:	8b 45 10             	mov    0x10(%ebp),%eax
  80186e:	01 d0                	add    %edx,%eax
  801870:	c6 00 00             	movb   $0x0,(%eax)
}
  801873:	90                   	nop
  801874:	c9                   	leave  
  801875:	c3                   	ret    

00801876 <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  801876:	55                   	push   %ebp
  801877:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  801879:	8b 45 14             	mov    0x14(%ebp),%eax
  80187c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  801882:	8b 45 14             	mov    0x14(%ebp),%eax
  801885:	8b 00                	mov    (%eax),%eax
  801887:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80188e:	8b 45 10             	mov    0x10(%ebp),%eax
  801891:	01 d0                	add    %edx,%eax
  801893:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801899:	eb 0c                	jmp    8018a7 <strsplit+0x31>
			*string++ = 0;
  80189b:	8b 45 08             	mov    0x8(%ebp),%eax
  80189e:	8d 50 01             	lea    0x1(%eax),%edx
  8018a1:	89 55 08             	mov    %edx,0x8(%ebp)
  8018a4:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  8018a7:	8b 45 08             	mov    0x8(%ebp),%eax
  8018aa:	8a 00                	mov    (%eax),%al
  8018ac:	84 c0                	test   %al,%al
  8018ae:	74 18                	je     8018c8 <strsplit+0x52>
  8018b0:	8b 45 08             	mov    0x8(%ebp),%eax
  8018b3:	8a 00                	mov    (%eax),%al
  8018b5:	0f be c0             	movsbl %al,%eax
  8018b8:	50                   	push   %eax
  8018b9:	ff 75 0c             	pushl  0xc(%ebp)
  8018bc:	e8 13 fb ff ff       	call   8013d4 <strchr>
  8018c1:	83 c4 08             	add    $0x8,%esp
  8018c4:	85 c0                	test   %eax,%eax
  8018c6:	75 d3                	jne    80189b <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  8018c8:	8b 45 08             	mov    0x8(%ebp),%eax
  8018cb:	8a 00                	mov    (%eax),%al
  8018cd:	84 c0                	test   %al,%al
  8018cf:	74 5a                	je     80192b <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  8018d1:	8b 45 14             	mov    0x14(%ebp),%eax
  8018d4:	8b 00                	mov    (%eax),%eax
  8018d6:	83 f8 0f             	cmp    $0xf,%eax
  8018d9:	75 07                	jne    8018e2 <strsplit+0x6c>
		{
			return 0;
  8018db:	b8 00 00 00 00       	mov    $0x0,%eax
  8018e0:	eb 66                	jmp    801948 <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  8018e2:	8b 45 14             	mov    0x14(%ebp),%eax
  8018e5:	8b 00                	mov    (%eax),%eax
  8018e7:	8d 48 01             	lea    0x1(%eax),%ecx
  8018ea:	8b 55 14             	mov    0x14(%ebp),%edx
  8018ed:	89 0a                	mov    %ecx,(%edx)
  8018ef:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8018f6:	8b 45 10             	mov    0x10(%ebp),%eax
  8018f9:	01 c2                	add    %eax,%edx
  8018fb:	8b 45 08             	mov    0x8(%ebp),%eax
  8018fe:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  801900:	eb 03                	jmp    801905 <strsplit+0x8f>
			string++;
  801902:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  801905:	8b 45 08             	mov    0x8(%ebp),%eax
  801908:	8a 00                	mov    (%eax),%al
  80190a:	84 c0                	test   %al,%al
  80190c:	74 8b                	je     801899 <strsplit+0x23>
  80190e:	8b 45 08             	mov    0x8(%ebp),%eax
  801911:	8a 00                	mov    (%eax),%al
  801913:	0f be c0             	movsbl %al,%eax
  801916:	50                   	push   %eax
  801917:	ff 75 0c             	pushl  0xc(%ebp)
  80191a:	e8 b5 fa ff ff       	call   8013d4 <strchr>
  80191f:	83 c4 08             	add    $0x8,%esp
  801922:	85 c0                	test   %eax,%eax
  801924:	74 dc                	je     801902 <strsplit+0x8c>
			string++;
	}
  801926:	e9 6e ff ff ff       	jmp    801899 <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  80192b:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  80192c:	8b 45 14             	mov    0x14(%ebp),%eax
  80192f:	8b 00                	mov    (%eax),%eax
  801931:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801938:	8b 45 10             	mov    0x10(%ebp),%eax
  80193b:	01 d0                	add    %edx,%eax
  80193d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  801943:	b8 01 00 00 00       	mov    $0x1,%eax
}
  801948:	c9                   	leave  
  801949:	c3                   	ret    

0080194a <InitializeUHeap>:
//============================== GIVEN FUNCTIONS ===================================//
//==================================================================================//

int FirstTimeFlag = 1;
void InitializeUHeap()
{
  80194a:	55                   	push   %ebp
  80194b:	89 e5                	mov    %esp,%ebp
  80194d:	83 ec 08             	sub    $0x8,%esp
	if(FirstTimeFlag)
  801950:	a1 04 50 80 00       	mov    0x805004,%eax
  801955:	85 c0                	test   %eax,%eax
  801957:	74 1f                	je     801978 <InitializeUHeap+0x2e>
	{
		initialize_dyn_block_system();
  801959:	e8 1d 00 00 00       	call   80197b <initialize_dyn_block_system>
		cprintf("DYNAMIC BLOCK SYSTEM IS INITIALIZED\n");
  80195e:	83 ec 0c             	sub    $0xc,%esp
  801961:	68 d0 3e 80 00       	push   $0x803ed0
  801966:	e8 55 f2 ff ff       	call   800bc0 <cprintf>
  80196b:	83 c4 10             	add    $0x10,%esp
#if UHP_USE_BUDDY
		initialize_buddy();
		cprintf("BUDDY SYSTEM IS INITIALIZED\n");
#endif
		FirstTimeFlag = 0;
  80196e:	c7 05 04 50 80 00 00 	movl   $0x0,0x805004
  801975:	00 00 00 
	}
}
  801978:	90                   	nop
  801979:	c9                   	leave  
  80197a:	c3                   	ret    

0080197b <initialize_dyn_block_system>:

//=================================
// [1] INITIALIZE DYNAMIC ALLOCATOR:
//=================================
void initialize_dyn_block_system()
{
  80197b:	55                   	push   %ebp
  80197c:	89 e5                	mov    %esp,%ebp
  80197e:	83 ec 28             	sub    $0x28,%esp
	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] initialize_dyn_block_system
	// your code is here, remove the panic and write your code
	//panic("initialize_dyn_block_system() is not implemented yet...!!");

	LIST_INIT(&AllocMemBlocksList);
  801981:	c7 05 40 50 80 00 00 	movl   $0x0,0x805040
  801988:	00 00 00 
  80198b:	c7 05 44 50 80 00 00 	movl   $0x0,0x805044
  801992:	00 00 00 
  801995:	c7 05 4c 50 80 00 00 	movl   $0x0,0x80504c
  80199c:	00 00 00 
	LIST_INIT(&FreeMemBlocksList);
  80199f:	c7 05 38 51 80 00 00 	movl   $0x0,0x805138
  8019a6:	00 00 00 
  8019a9:	c7 05 3c 51 80 00 00 	movl   $0x0,0x80513c
  8019b0:	00 00 00 
  8019b3:	c7 05 44 51 80 00 00 	movl   $0x0,0x805144
  8019ba:	00 00 00 
	MAX_MEM_BLOCK_CNT = NUM_OF_UHEAP_PAGES;
  8019bd:	c7 05 20 51 80 00 00 	movl   $0x20000,0x805120
  8019c4:	00 02 00 
	MemBlockNodes = (void*)USER_DYN_BLKS_ARRAY;
  8019c7:	c7 45 f4 00 00 e0 7f 	movl   $0x7fe00000,-0xc(%ebp)
  8019ce:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8019d1:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8019d6:	2d 00 10 00 00       	sub    $0x1000,%eax
  8019db:	a3 50 50 80 00       	mov    %eax,0x805050
	int size_of_block = sizeof(struct MemBlock);
  8019e0:	c7 45 f0 10 00 00 00 	movl   $0x10,-0x10(%ebp)
	int size_all_struct = size_of_block*MAX_MEM_BLOCK_CNT;
  8019e7:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8019ea:	a1 20 51 80 00       	mov    0x805120,%eax
  8019ef:	0f af c2             	imul   %edx,%eax
  8019f2:	89 45 ec             	mov    %eax,-0x14(%ebp)
	size_all_struct = ROUNDUP(size_all_struct, PAGE_SIZE);
  8019f5:	c7 45 e8 00 10 00 00 	movl   $0x1000,-0x18(%ebp)
  8019fc:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8019ff:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801a02:	01 d0                	add    %edx,%eax
  801a04:	48                   	dec    %eax
  801a05:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  801a08:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801a0b:	ba 00 00 00 00       	mov    $0x0,%edx
  801a10:	f7 75 e8             	divl   -0x18(%ebp)
  801a13:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801a16:	29 d0                	sub    %edx,%eax
  801a18:	89 45 ec             	mov    %eax,-0x14(%ebp)
	sys_allocate_chunk(USER_DYN_BLKS_ARRAY, size_all_struct,PERM_USER| PERM_WRITEABLE);
  801a1b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801a1e:	c7 45 e0 00 00 e0 7f 	movl   $0x7fe00000,-0x20(%ebp)
  801a25:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801a28:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
  801a2e:	81 ea 00 10 00 00    	sub    $0x1000,%edx
  801a34:	83 ec 04             	sub    $0x4,%esp
  801a37:	6a 06                	push   $0x6
  801a39:	50                   	push   %eax
  801a3a:	52                   	push   %edx
  801a3b:	e8 a1 05 00 00       	call   801fe1 <sys_allocate_chunk>
  801a40:	83 c4 10             	add    $0x10,%esp
	initialize_MemBlocksList(MAX_MEM_BLOCK_CNT);
  801a43:	a1 20 51 80 00       	mov    0x805120,%eax
  801a48:	83 ec 0c             	sub    $0xc,%esp
  801a4b:	50                   	push   %eax
  801a4c:	e8 16 0c 00 00       	call   802667 <initialize_MemBlocksList>
  801a51:	83 c4 10             	add    $0x10,%esp
	struct MemBlock* ourBlock =LIST_LAST(&AvailableMemBlocksList);
  801a54:	a1 4c 51 80 00       	mov    0x80514c,%eax
  801a59:	89 45 dc             	mov    %eax,-0x24(%ebp)
	LIST_REMOVE(&AvailableMemBlocksList,ourBlock);
  801a5c:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  801a60:	75 14                	jne    801a76 <initialize_dyn_block_system+0xfb>
  801a62:	83 ec 04             	sub    $0x4,%esp
  801a65:	68 f5 3e 80 00       	push   $0x803ef5
  801a6a:	6a 2d                	push   $0x2d
  801a6c:	68 13 3f 80 00       	push   $0x803f13
  801a71:	e8 96 ee ff ff       	call   80090c <_panic>
  801a76:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801a79:	8b 00                	mov    (%eax),%eax
  801a7b:	85 c0                	test   %eax,%eax
  801a7d:	74 10                	je     801a8f <initialize_dyn_block_system+0x114>
  801a7f:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801a82:	8b 00                	mov    (%eax),%eax
  801a84:	8b 55 dc             	mov    -0x24(%ebp),%edx
  801a87:	8b 52 04             	mov    0x4(%edx),%edx
  801a8a:	89 50 04             	mov    %edx,0x4(%eax)
  801a8d:	eb 0b                	jmp    801a9a <initialize_dyn_block_system+0x11f>
  801a8f:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801a92:	8b 40 04             	mov    0x4(%eax),%eax
  801a95:	a3 4c 51 80 00       	mov    %eax,0x80514c
  801a9a:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801a9d:	8b 40 04             	mov    0x4(%eax),%eax
  801aa0:	85 c0                	test   %eax,%eax
  801aa2:	74 0f                	je     801ab3 <initialize_dyn_block_system+0x138>
  801aa4:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801aa7:	8b 40 04             	mov    0x4(%eax),%eax
  801aaa:	8b 55 dc             	mov    -0x24(%ebp),%edx
  801aad:	8b 12                	mov    (%edx),%edx
  801aaf:	89 10                	mov    %edx,(%eax)
  801ab1:	eb 0a                	jmp    801abd <initialize_dyn_block_system+0x142>
  801ab3:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801ab6:	8b 00                	mov    (%eax),%eax
  801ab8:	a3 48 51 80 00       	mov    %eax,0x805148
  801abd:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801ac0:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  801ac6:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801ac9:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  801ad0:	a1 54 51 80 00       	mov    0x805154,%eax
  801ad5:	48                   	dec    %eax
  801ad6:	a3 54 51 80 00       	mov    %eax,0x805154
	ourBlock->size = USER_HEAP_MAX-USER_HEAP_START;
  801adb:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801ade:	c7 40 0c 00 00 00 20 	movl   $0x20000000,0xc(%eax)
	ourBlock->sva=USER_HEAP_START;
  801ae5:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801ae8:	c7 40 08 00 00 00 80 	movl   $0x80000000,0x8(%eax)
	LIST_INSERT_TAIL(&FreeMemBlocksList, ourBlock);
  801aef:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  801af3:	75 14                	jne    801b09 <initialize_dyn_block_system+0x18e>
  801af5:	83 ec 04             	sub    $0x4,%esp
  801af8:	68 20 3f 80 00       	push   $0x803f20
  801afd:	6a 30                	push   $0x30
  801aff:	68 13 3f 80 00       	push   $0x803f13
  801b04:	e8 03 ee ff ff       	call   80090c <_panic>
  801b09:	8b 15 3c 51 80 00    	mov    0x80513c,%edx
  801b0f:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801b12:	89 50 04             	mov    %edx,0x4(%eax)
  801b15:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801b18:	8b 40 04             	mov    0x4(%eax),%eax
  801b1b:	85 c0                	test   %eax,%eax
  801b1d:	74 0c                	je     801b2b <initialize_dyn_block_system+0x1b0>
  801b1f:	a1 3c 51 80 00       	mov    0x80513c,%eax
  801b24:	8b 55 dc             	mov    -0x24(%ebp),%edx
  801b27:	89 10                	mov    %edx,(%eax)
  801b29:	eb 08                	jmp    801b33 <initialize_dyn_block_system+0x1b8>
  801b2b:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801b2e:	a3 38 51 80 00       	mov    %eax,0x805138
  801b33:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801b36:	a3 3c 51 80 00       	mov    %eax,0x80513c
  801b3b:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801b3e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  801b44:	a1 44 51 80 00       	mov    0x805144,%eax
  801b49:	40                   	inc    %eax
  801b4a:	a3 44 51 80 00       	mov    %eax,0x805144
	//[1] Initialize two lists (AllocMemBlocksList & FreeMemBlocksList) [Hint: use LIST_INIT()]
	//[2] Dynamically allocate the array of MemBlockNodes at VA USER_DYN_BLKS_ARRAY
	//	  (remember to set MAX_MEM_BLOCK_CNT with the chosen size of the array)
	//[3] Initialize AvailableMemBlocksList by filling it with the MemBlockNodes
	//[4] Insert a new MemBlock with the heap size into the FreeMemBlocksList
}
  801b4f:	90                   	nop
  801b50:	c9                   	leave  
  801b51:	c3                   	ret    

00801b52 <malloc>:
//=================================
// [2] ALLOCATE SPACE IN USER HEAP:
//=================================

void* malloc(uint32 size)
{
  801b52:	55                   	push   %ebp
  801b53:	89 e5                	mov    %esp,%ebp
  801b55:	83 ec 18             	sub    $0x18,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801b58:	e8 ed fd ff ff       	call   80194a <InitializeUHeap>
	if (size == 0) return NULL ;
  801b5d:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801b61:	75 07                	jne    801b6a <malloc+0x18>
  801b63:	b8 00 00 00 00       	mov    $0x0,%eax
  801b68:	eb 67                	jmp    801bd1 <malloc+0x7f>

	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] malloc
	// your code is here, remove the panic and write your code
	//panic("malloc() is not implemented yet...!!");

	size = ROUNDUP(size, PAGE_SIZE);
  801b6a:	c7 45 f4 00 10 00 00 	movl   $0x1000,-0xc(%ebp)
  801b71:	8b 55 08             	mov    0x8(%ebp),%edx
  801b74:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801b77:	01 d0                	add    %edx,%eax
  801b79:	48                   	dec    %eax
  801b7a:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801b7d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801b80:	ba 00 00 00 00       	mov    $0x0,%edx
  801b85:	f7 75 f4             	divl   -0xc(%ebp)
  801b88:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801b8b:	29 d0                	sub    %edx,%eax
  801b8d:	89 45 08             	mov    %eax,0x8(%ebp)
	if(sys_isUHeapPlacementStrategyFIRSTFIT())
  801b90:	e8 1a 08 00 00       	call   8023af <sys_isUHeapPlacementStrategyFIRSTFIT>
  801b95:	85 c0                	test   %eax,%eax
  801b97:	74 33                	je     801bcc <malloc+0x7a>
	{
		struct MemBlock * myBlock = alloc_block_FF(size);
  801b99:	83 ec 0c             	sub    $0xc,%esp
  801b9c:	ff 75 08             	pushl  0x8(%ebp)
  801b9f:	e8 0c 0e 00 00       	call   8029b0 <alloc_block_FF>
  801ba4:	83 c4 10             	add    $0x10,%esp
  801ba7:	89 45 ec             	mov    %eax,-0x14(%ebp)
		if(myBlock != NULL)
  801baa:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  801bae:	74 1c                	je     801bcc <malloc+0x7a>
		{
			insert_sorted_allocList(myBlock);
  801bb0:	83 ec 0c             	sub    $0xc,%esp
  801bb3:	ff 75 ec             	pushl  -0x14(%ebp)
  801bb6:	e8 07 0c 00 00       	call   8027c2 <insert_sorted_allocList>
  801bbb:	83 c4 10             	add    $0x10,%esp
			uint32 ptr = myBlock->sva;
  801bbe:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801bc1:	8b 40 08             	mov    0x8(%eax),%eax
  801bc4:	89 45 e8             	mov    %eax,-0x18(%ebp)
			return (void *)ptr;
  801bc7:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801bca:	eb 05                	jmp    801bd1 <malloc+0x7f>
		}
	}
	return NULL;
  801bcc:	b8 00 00 00 00       	mov    $0x0,%eax
	//		to the required allocation size (space should be on 4 KB BOUNDARY)
	//	2) if no suitable space found, return NULL
	// 	3) Return pointer containing the virtual address of allocated space,
	//
	//Use sys_isUHeapPlacementStrategyFIRSTFIT()... to check the current strategy
}
  801bd1:	c9                   	leave  
  801bd2:	c3                   	ret    

00801bd3 <free>:
//	We can use sys_free_user_mem(uint32 virtual_address, uint32 size); which
//		switches to the kernel mode, calls free_user_mem() in
//		"kern/mem/chunk_operations.c", then switch back to the user mode here
//	the free_user_mem function is empty, make sure to implement it.
void free(void* virtual_address)
{
  801bd3:	55                   	push   %ebp
  801bd4:	89 e5                	mov    %esp,%ebp
  801bd6:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] free
	// your code is here, remove the panic and write your code
	//panic("free() is not implemented yet...!!");

	uint32 virtualAddress = (uint32 )(virtual_address);
  801bd9:	8b 45 08             	mov    0x8(%ebp),%eax
  801bdc:	89 45 f4             	mov    %eax,-0xc(%ebp)
//	virtualAddress = ROUNDDOWN(virtualAddress, PAGE_SIZE);
	struct MemBlock * myBlock = find_block(&AllocMemBlocksList, virtualAddress);
  801bdf:	83 ec 08             	sub    $0x8,%esp
  801be2:	ff 75 f4             	pushl  -0xc(%ebp)
  801be5:	68 40 50 80 00       	push   $0x805040
  801bea:	e8 5b 0b 00 00       	call   80274a <find_block>
  801bef:	83 c4 10             	add    $0x10,%esp
  801bf2:	89 45 f0             	mov    %eax,-0x10(%ebp)
//	cprintf ("ptr sva at free user side = %x \n", myBlock->sva);
	sys_free_user_mem(virtualAddress, myBlock->size);
  801bf5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801bf8:	8b 40 0c             	mov    0xc(%eax),%eax
  801bfb:	83 ec 08             	sub    $0x8,%esp
  801bfe:	50                   	push   %eax
  801bff:	ff 75 f4             	pushl  -0xc(%ebp)
  801c02:	e8 a2 03 00 00       	call   801fa9 <sys_free_user_mem>
  801c07:	83 c4 10             	add    $0x10,%esp
	LIST_REMOVE(&AllocMemBlocksList, myBlock);
  801c0a:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801c0e:	75 14                	jne    801c24 <free+0x51>
  801c10:	83 ec 04             	sub    $0x4,%esp
  801c13:	68 f5 3e 80 00       	push   $0x803ef5
  801c18:	6a 76                	push   $0x76
  801c1a:	68 13 3f 80 00       	push   $0x803f13
  801c1f:	e8 e8 ec ff ff       	call   80090c <_panic>
  801c24:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801c27:	8b 00                	mov    (%eax),%eax
  801c29:	85 c0                	test   %eax,%eax
  801c2b:	74 10                	je     801c3d <free+0x6a>
  801c2d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801c30:	8b 00                	mov    (%eax),%eax
  801c32:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801c35:	8b 52 04             	mov    0x4(%edx),%edx
  801c38:	89 50 04             	mov    %edx,0x4(%eax)
  801c3b:	eb 0b                	jmp    801c48 <free+0x75>
  801c3d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801c40:	8b 40 04             	mov    0x4(%eax),%eax
  801c43:	a3 44 50 80 00       	mov    %eax,0x805044
  801c48:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801c4b:	8b 40 04             	mov    0x4(%eax),%eax
  801c4e:	85 c0                	test   %eax,%eax
  801c50:	74 0f                	je     801c61 <free+0x8e>
  801c52:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801c55:	8b 40 04             	mov    0x4(%eax),%eax
  801c58:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801c5b:	8b 12                	mov    (%edx),%edx
  801c5d:	89 10                	mov    %edx,(%eax)
  801c5f:	eb 0a                	jmp    801c6b <free+0x98>
  801c61:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801c64:	8b 00                	mov    (%eax),%eax
  801c66:	a3 40 50 80 00       	mov    %eax,0x805040
  801c6b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801c6e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  801c74:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801c77:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  801c7e:	a1 4c 50 80 00       	mov    0x80504c,%eax
  801c83:	48                   	dec    %eax
  801c84:	a3 4c 50 80 00       	mov    %eax,0x80504c
	insert_sorted_with_merge_freeList(myBlock);
  801c89:	83 ec 0c             	sub    $0xc,%esp
  801c8c:	ff 75 f0             	pushl  -0x10(%ebp)
  801c8f:	e8 0b 14 00 00       	call   80309f <insert_sorted_with_merge_freeList>
  801c94:	83 c4 10             	add    $0x10,%esp

	//you should get the size of the given allocation using its address
	//you need to call sys_free_user_mem()
	//refer to the project presentation and documentation for details
}
  801c97:	90                   	nop
  801c98:	c9                   	leave  
  801c99:	c3                   	ret    

00801c9a <smalloc>:

//=================================
// [4] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
  801c9a:	55                   	push   %ebp
  801c9b:	89 e5                	mov    %esp,%ebp
  801c9d:	83 ec 28             	sub    $0x28,%esp
  801ca0:	8b 45 10             	mov    0x10(%ebp),%eax
  801ca3:	88 45 e4             	mov    %al,-0x1c(%ebp)
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801ca6:	e8 9f fc ff ff       	call   80194a <InitializeUHeap>
	if (size == 0) return NULL ;
  801cab:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801caf:	75 0a                	jne    801cbb <smalloc+0x21>
  801cb1:	b8 00 00 00 00       	mov    $0x0,%eax
  801cb6:	e9 8d 00 00 00       	jmp    801d48 <smalloc+0xae>

	//This function should find the space of the required range
	// * ON 4KB BOUNDARY **** //
	//Use sys_isUHeapPlacementStrategyFIRSTFIT() to check the current strategy

	size = ROUNDUP(size, PAGE_SIZE);
  801cbb:	c7 45 f4 00 10 00 00 	movl   $0x1000,-0xc(%ebp)
  801cc2:	8b 55 0c             	mov    0xc(%ebp),%edx
  801cc5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801cc8:	01 d0                	add    %edx,%eax
  801cca:	48                   	dec    %eax
  801ccb:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801cce:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801cd1:	ba 00 00 00 00       	mov    $0x0,%edx
  801cd6:	f7 75 f4             	divl   -0xc(%ebp)
  801cd9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801cdc:	29 d0                	sub    %edx,%eax
  801cde:	89 45 0c             	mov    %eax,0xc(%ebp)
		if(sys_isUHeapPlacementStrategyFIRSTFIT())
  801ce1:	e8 c9 06 00 00       	call   8023af <sys_isUHeapPlacementStrategyFIRSTFIT>
  801ce6:	85 c0                	test   %eax,%eax
  801ce8:	74 59                	je     801d43 <smalloc+0xa9>
		{
			struct MemBlock * v1=NULL;
  801cea:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
			v1= alloc_block_FF(size);
  801cf1:	83 ec 0c             	sub    $0xc,%esp
  801cf4:	ff 75 0c             	pushl  0xc(%ebp)
  801cf7:	e8 b4 0c 00 00       	call   8029b0 <alloc_block_FF>
  801cfc:	83 c4 10             	add    $0x10,%esp
  801cff:	89 45 ec             	mov    %eax,-0x14(%ebp)
			if(v1==NULL)
  801d02:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  801d06:	75 07                	jne    801d0f <smalloc+0x75>
			{
				return NULL;
  801d08:	b8 00 00 00 00       	mov    $0x0,%eax
  801d0d:	eb 39                	jmp    801d48 <smalloc+0xae>
			}
			else
			{
				int ret=sys_createSharedObject(sharedVarName,  size,  isWritable,(void*)v1->sva);
  801d0f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801d12:	8b 40 08             	mov    0x8(%eax),%eax
  801d15:	89 c2                	mov    %eax,%edx
  801d17:	0f b6 45 e4          	movzbl -0x1c(%ebp),%eax
  801d1b:	52                   	push   %edx
  801d1c:	50                   	push   %eax
  801d1d:	ff 75 0c             	pushl  0xc(%ebp)
  801d20:	ff 75 08             	pushl  0x8(%ebp)
  801d23:	e8 0c 04 00 00       	call   802134 <sys_createSharedObject>
  801d28:	83 c4 10             	add    $0x10,%esp
  801d2b:	89 45 e8             	mov    %eax,-0x18(%ebp)
				if(ret>=0)
  801d2e:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  801d32:	78 08                	js     801d3c <smalloc+0xa2>
				{
					return (void*)v1->sva;
  801d34:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801d37:	8b 40 08             	mov    0x8(%eax),%eax
  801d3a:	eb 0c                	jmp    801d48 <smalloc+0xae>
				}
				else
				{
					return NULL;
  801d3c:	b8 00 00 00 00       	mov    $0x0,%eax
  801d41:	eb 05                	jmp    801d48 <smalloc+0xae>
				}
			}

		}
		return NULL;
  801d43:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801d48:	c9                   	leave  
  801d49:	c3                   	ret    

00801d4a <sget>:

//========================================
// [5] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  801d4a:	55                   	push   %ebp
  801d4b:	89 e5                	mov    %esp,%ebp
  801d4d:	83 ec 18             	sub    $0x18,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801d50:	e8 f5 fb ff ff       	call   80194a <InitializeUHeap>

	//This function should find the space for sharing the variable
	// *** ON 4KB BOUNDARY ******** //

	//Use sys_isUHeapPlacementStrategyFIRSTFIT() to check the current strategy
	int ret=sys_getSizeOfSharedObject(ownerEnvID,sharedVarName);
  801d55:	83 ec 08             	sub    $0x8,%esp
  801d58:	ff 75 0c             	pushl  0xc(%ebp)
  801d5b:	ff 75 08             	pushl  0x8(%ebp)
  801d5e:	e8 fb 03 00 00       	call   80215e <sys_getSizeOfSharedObject>
  801d63:	83 c4 10             	add    $0x10,%esp
  801d66:	89 45 f4             	mov    %eax,-0xc(%ebp)
	if(ret==0)
  801d69:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801d6d:	75 07                	jne    801d76 <sget+0x2c>
	{
		return NULL;
  801d6f:	b8 00 00 00 00       	mov    $0x0,%eax
  801d74:	eb 64                	jmp    801dda <sget+0x90>
	}
	if(sys_isUHeapPlacementStrategyFIRSTFIT())
  801d76:	e8 34 06 00 00       	call   8023af <sys_isUHeapPlacementStrategyFIRSTFIT>
  801d7b:	85 c0                	test   %eax,%eax
  801d7d:	74 56                	je     801dd5 <sget+0x8b>
	{
		struct MemBlock * v1=NULL;
  801d7f:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
		v1= alloc_block_FF(ret);
  801d86:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801d89:	83 ec 0c             	sub    $0xc,%esp
  801d8c:	50                   	push   %eax
  801d8d:	e8 1e 0c 00 00       	call   8029b0 <alloc_block_FF>
  801d92:	83 c4 10             	add    $0x10,%esp
  801d95:	89 45 f0             	mov    %eax,-0x10(%ebp)
		if(v1==NULL)
  801d98:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801d9c:	75 07                	jne    801da5 <sget+0x5b>
		{
		return NULL;
  801d9e:	b8 00 00 00 00       	mov    $0x0,%eax
  801da3:	eb 35                	jmp    801dda <sget+0x90>
	    }
		else
		{
			int ret1=sys_getSharedObject(ownerEnvID,sharedVarName,(void*)v1->sva);
  801da5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801da8:	8b 40 08             	mov    0x8(%eax),%eax
  801dab:	83 ec 04             	sub    $0x4,%esp
  801dae:	50                   	push   %eax
  801daf:	ff 75 0c             	pushl  0xc(%ebp)
  801db2:	ff 75 08             	pushl  0x8(%ebp)
  801db5:	e8 c1 03 00 00       	call   80217b <sys_getSharedObject>
  801dba:	83 c4 10             	add    $0x10,%esp
  801dbd:	89 45 ec             	mov    %eax,-0x14(%ebp)
			if(ret1>=0)
  801dc0:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  801dc4:	78 08                	js     801dce <sget+0x84>
			{
				return (void*)v1->sva;
  801dc6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801dc9:	8b 40 08             	mov    0x8(%eax),%eax
  801dcc:	eb 0c                	jmp    801dda <sget+0x90>
			}
			else
			{
				return NULL;
  801dce:	b8 00 00 00 00       	mov    $0x0,%eax
  801dd3:	eb 05                	jmp    801dda <sget+0x90>
			}
		}
	}
  return NULL;
  801dd5:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801dda:	c9                   	leave  
  801ddb:	c3                   	ret    

00801ddc <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  801ddc:	55                   	push   %ebp
  801ddd:	89 e5                	mov    %esp,%ebp
  801ddf:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801de2:	e8 63 fb ff ff       	call   80194a <InitializeUHeap>
	//==============================================================
	// [USER HEAP - USER SIDE] realloc
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  801de7:	83 ec 04             	sub    $0x4,%esp
  801dea:	68 44 3f 80 00       	push   $0x803f44
  801def:	68 0e 01 00 00       	push   $0x10e
  801df4:	68 13 3f 80 00       	push   $0x803f13
  801df9:	e8 0e eb ff ff       	call   80090c <_panic>

00801dfe <sfree>:
//	use sys_freeSharedObject(...); which switches to the kernel mode,
//	calls freeSharedObject(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the freeSharedObject() function is empty, make sure to implement it.

void sfree(void* virtual_address)
{
  801dfe:	55                   	push   %ebp
  801dff:	89 e5                	mov    %esp,%ebp
  801e01:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS3 - BONUS] [SHARING - USER SIDE] sfree()

	// Write your code here, remove the panic and write your code
	panic("sfree() is not implemented yet...!!");
  801e04:	83 ec 04             	sub    $0x4,%esp
  801e07:	68 6c 3f 80 00       	push   $0x803f6c
  801e0c:	68 22 01 00 00       	push   $0x122
  801e11:	68 13 3f 80 00       	push   $0x803f13
  801e16:	e8 f1 ea ff ff       	call   80090c <_panic>

00801e1b <expand>:

//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//
void expand(uint32 newSize)
{
  801e1b:	55                   	push   %ebp
  801e1c:	89 e5                	mov    %esp,%ebp
  801e1e:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801e21:	83 ec 04             	sub    $0x4,%esp
  801e24:	68 90 3f 80 00       	push   $0x803f90
  801e29:	68 2d 01 00 00       	push   $0x12d
  801e2e:	68 13 3f 80 00       	push   $0x803f13
  801e33:	e8 d4 ea ff ff       	call   80090c <_panic>

00801e38 <shrink>:

}
void shrink(uint32 newSize)
{
  801e38:	55                   	push   %ebp
  801e39:	89 e5                	mov    %esp,%ebp
  801e3b:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801e3e:	83 ec 04             	sub    $0x4,%esp
  801e41:	68 90 3f 80 00       	push   $0x803f90
  801e46:	68 32 01 00 00       	push   $0x132
  801e4b:	68 13 3f 80 00       	push   $0x803f13
  801e50:	e8 b7 ea ff ff       	call   80090c <_panic>

00801e55 <freeHeap>:

}
void freeHeap(void* virtual_address)
{
  801e55:	55                   	push   %ebp
  801e56:	89 e5                	mov    %esp,%ebp
  801e58:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801e5b:	83 ec 04             	sub    $0x4,%esp
  801e5e:	68 90 3f 80 00       	push   $0x803f90
  801e63:	68 37 01 00 00       	push   $0x137
  801e68:	68 13 3f 80 00       	push   $0x803f13
  801e6d:	e8 9a ea ff ff       	call   80090c <_panic>

00801e72 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  801e72:	55                   	push   %ebp
  801e73:	89 e5                	mov    %esp,%ebp
  801e75:	57                   	push   %edi
  801e76:	56                   	push   %esi
  801e77:	53                   	push   %ebx
  801e78:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801e7b:	8b 45 08             	mov    0x8(%ebp),%eax
  801e7e:	8b 55 0c             	mov    0xc(%ebp),%edx
  801e81:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801e84:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801e87:	8b 7d 18             	mov    0x18(%ebp),%edi
  801e8a:	8b 75 1c             	mov    0x1c(%ebp),%esi
  801e8d:	cd 30                	int    $0x30
  801e8f:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  801e92:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801e95:	83 c4 10             	add    $0x10,%esp
  801e98:	5b                   	pop    %ebx
  801e99:	5e                   	pop    %esi
  801e9a:	5f                   	pop    %edi
  801e9b:	5d                   	pop    %ebp
  801e9c:	c3                   	ret    

00801e9d <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  801e9d:	55                   	push   %ebp
  801e9e:	89 e5                	mov    %esp,%ebp
  801ea0:	83 ec 04             	sub    $0x4,%esp
  801ea3:	8b 45 10             	mov    0x10(%ebp),%eax
  801ea6:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  801ea9:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801ead:	8b 45 08             	mov    0x8(%ebp),%eax
  801eb0:	6a 00                	push   $0x0
  801eb2:	6a 00                	push   $0x0
  801eb4:	52                   	push   %edx
  801eb5:	ff 75 0c             	pushl  0xc(%ebp)
  801eb8:	50                   	push   %eax
  801eb9:	6a 00                	push   $0x0
  801ebb:	e8 b2 ff ff ff       	call   801e72 <syscall>
  801ec0:	83 c4 18             	add    $0x18,%esp
}
  801ec3:	90                   	nop
  801ec4:	c9                   	leave  
  801ec5:	c3                   	ret    

00801ec6 <sys_cgetc>:

int
sys_cgetc(void)
{
  801ec6:	55                   	push   %ebp
  801ec7:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  801ec9:	6a 00                	push   $0x0
  801ecb:	6a 00                	push   $0x0
  801ecd:	6a 00                	push   $0x0
  801ecf:	6a 00                	push   $0x0
  801ed1:	6a 00                	push   $0x0
  801ed3:	6a 01                	push   $0x1
  801ed5:	e8 98 ff ff ff       	call   801e72 <syscall>
  801eda:	83 c4 18             	add    $0x18,%esp
}
  801edd:	c9                   	leave  
  801ede:	c3                   	ret    

00801edf <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  801edf:	55                   	push   %ebp
  801ee0:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  801ee2:	8b 55 0c             	mov    0xc(%ebp),%edx
  801ee5:	8b 45 08             	mov    0x8(%ebp),%eax
  801ee8:	6a 00                	push   $0x0
  801eea:	6a 00                	push   $0x0
  801eec:	6a 00                	push   $0x0
  801eee:	52                   	push   %edx
  801eef:	50                   	push   %eax
  801ef0:	6a 05                	push   $0x5
  801ef2:	e8 7b ff ff ff       	call   801e72 <syscall>
  801ef7:	83 c4 18             	add    $0x18,%esp
}
  801efa:	c9                   	leave  
  801efb:	c3                   	ret    

00801efc <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  801efc:	55                   	push   %ebp
  801efd:	89 e5                	mov    %esp,%ebp
  801eff:	56                   	push   %esi
  801f00:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  801f01:	8b 75 18             	mov    0x18(%ebp),%esi
  801f04:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801f07:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801f0a:	8b 55 0c             	mov    0xc(%ebp),%edx
  801f0d:	8b 45 08             	mov    0x8(%ebp),%eax
  801f10:	56                   	push   %esi
  801f11:	53                   	push   %ebx
  801f12:	51                   	push   %ecx
  801f13:	52                   	push   %edx
  801f14:	50                   	push   %eax
  801f15:	6a 06                	push   $0x6
  801f17:	e8 56 ff ff ff       	call   801e72 <syscall>
  801f1c:	83 c4 18             	add    $0x18,%esp
}
  801f1f:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801f22:	5b                   	pop    %ebx
  801f23:	5e                   	pop    %esi
  801f24:	5d                   	pop    %ebp
  801f25:	c3                   	ret    

00801f26 <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  801f26:	55                   	push   %ebp
  801f27:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  801f29:	8b 55 0c             	mov    0xc(%ebp),%edx
  801f2c:	8b 45 08             	mov    0x8(%ebp),%eax
  801f2f:	6a 00                	push   $0x0
  801f31:	6a 00                	push   $0x0
  801f33:	6a 00                	push   $0x0
  801f35:	52                   	push   %edx
  801f36:	50                   	push   %eax
  801f37:	6a 07                	push   $0x7
  801f39:	e8 34 ff ff ff       	call   801e72 <syscall>
  801f3e:	83 c4 18             	add    $0x18,%esp
}
  801f41:	c9                   	leave  
  801f42:	c3                   	ret    

00801f43 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  801f43:	55                   	push   %ebp
  801f44:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  801f46:	6a 00                	push   $0x0
  801f48:	6a 00                	push   $0x0
  801f4a:	6a 00                	push   $0x0
  801f4c:	ff 75 0c             	pushl  0xc(%ebp)
  801f4f:	ff 75 08             	pushl  0x8(%ebp)
  801f52:	6a 08                	push   $0x8
  801f54:	e8 19 ff ff ff       	call   801e72 <syscall>
  801f59:	83 c4 18             	add    $0x18,%esp
}
  801f5c:	c9                   	leave  
  801f5d:	c3                   	ret    

00801f5e <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  801f5e:	55                   	push   %ebp
  801f5f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  801f61:	6a 00                	push   $0x0
  801f63:	6a 00                	push   $0x0
  801f65:	6a 00                	push   $0x0
  801f67:	6a 00                	push   $0x0
  801f69:	6a 00                	push   $0x0
  801f6b:	6a 09                	push   $0x9
  801f6d:	e8 00 ff ff ff       	call   801e72 <syscall>
  801f72:	83 c4 18             	add    $0x18,%esp
}
  801f75:	c9                   	leave  
  801f76:	c3                   	ret    

00801f77 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  801f77:	55                   	push   %ebp
  801f78:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  801f7a:	6a 00                	push   $0x0
  801f7c:	6a 00                	push   $0x0
  801f7e:	6a 00                	push   $0x0
  801f80:	6a 00                	push   $0x0
  801f82:	6a 00                	push   $0x0
  801f84:	6a 0a                	push   $0xa
  801f86:	e8 e7 fe ff ff       	call   801e72 <syscall>
  801f8b:	83 c4 18             	add    $0x18,%esp
}
  801f8e:	c9                   	leave  
  801f8f:	c3                   	ret    

00801f90 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  801f90:	55                   	push   %ebp
  801f91:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  801f93:	6a 00                	push   $0x0
  801f95:	6a 00                	push   $0x0
  801f97:	6a 00                	push   $0x0
  801f99:	6a 00                	push   $0x0
  801f9b:	6a 00                	push   $0x0
  801f9d:	6a 0b                	push   $0xb
  801f9f:	e8 ce fe ff ff       	call   801e72 <syscall>
  801fa4:	83 c4 18             	add    $0x18,%esp
}
  801fa7:	c9                   	leave  
  801fa8:	c3                   	ret    

00801fa9 <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  801fa9:	55                   	push   %ebp
  801faa:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  801fac:	6a 00                	push   $0x0
  801fae:	6a 00                	push   $0x0
  801fb0:	6a 00                	push   $0x0
  801fb2:	ff 75 0c             	pushl  0xc(%ebp)
  801fb5:	ff 75 08             	pushl  0x8(%ebp)
  801fb8:	6a 0f                	push   $0xf
  801fba:	e8 b3 fe ff ff       	call   801e72 <syscall>
  801fbf:	83 c4 18             	add    $0x18,%esp
	return;
  801fc2:	90                   	nop
}
  801fc3:	c9                   	leave  
  801fc4:	c3                   	ret    

00801fc5 <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  801fc5:	55                   	push   %ebp
  801fc6:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  801fc8:	6a 00                	push   $0x0
  801fca:	6a 00                	push   $0x0
  801fcc:	6a 00                	push   $0x0
  801fce:	ff 75 0c             	pushl  0xc(%ebp)
  801fd1:	ff 75 08             	pushl  0x8(%ebp)
  801fd4:	6a 10                	push   $0x10
  801fd6:	e8 97 fe ff ff       	call   801e72 <syscall>
  801fdb:	83 c4 18             	add    $0x18,%esp
	return ;
  801fde:	90                   	nop
}
  801fdf:	c9                   	leave  
  801fe0:	c3                   	ret    

00801fe1 <sys_allocate_chunk>:

void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  801fe1:	55                   	push   %ebp
  801fe2:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  801fe4:	6a 00                	push   $0x0
  801fe6:	6a 00                	push   $0x0
  801fe8:	ff 75 10             	pushl  0x10(%ebp)
  801feb:	ff 75 0c             	pushl  0xc(%ebp)
  801fee:	ff 75 08             	pushl  0x8(%ebp)
  801ff1:	6a 11                	push   $0x11
  801ff3:	e8 7a fe ff ff       	call   801e72 <syscall>
  801ff8:	83 c4 18             	add    $0x18,%esp
	return ;
  801ffb:	90                   	nop
}
  801ffc:	c9                   	leave  
  801ffd:	c3                   	ret    

00801ffe <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  801ffe:	55                   	push   %ebp
  801fff:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  802001:	6a 00                	push   $0x0
  802003:	6a 00                	push   $0x0
  802005:	6a 00                	push   $0x0
  802007:	6a 00                	push   $0x0
  802009:	6a 00                	push   $0x0
  80200b:	6a 0c                	push   $0xc
  80200d:	e8 60 fe ff ff       	call   801e72 <syscall>
  802012:	83 c4 18             	add    $0x18,%esp
}
  802015:	c9                   	leave  
  802016:	c3                   	ret    

00802017 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  802017:	55                   	push   %ebp
  802018:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  80201a:	6a 00                	push   $0x0
  80201c:	6a 00                	push   $0x0
  80201e:	6a 00                	push   $0x0
  802020:	6a 00                	push   $0x0
  802022:	ff 75 08             	pushl  0x8(%ebp)
  802025:	6a 0d                	push   $0xd
  802027:	e8 46 fe ff ff       	call   801e72 <syscall>
  80202c:	83 c4 18             	add    $0x18,%esp
}
  80202f:	c9                   	leave  
  802030:	c3                   	ret    

00802031 <sys_scarce_memory>:

void sys_scarce_memory()
{
  802031:	55                   	push   %ebp
  802032:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  802034:	6a 00                	push   $0x0
  802036:	6a 00                	push   $0x0
  802038:	6a 00                	push   $0x0
  80203a:	6a 00                	push   $0x0
  80203c:	6a 00                	push   $0x0
  80203e:	6a 0e                	push   $0xe
  802040:	e8 2d fe ff ff       	call   801e72 <syscall>
  802045:	83 c4 18             	add    $0x18,%esp
}
  802048:	90                   	nop
  802049:	c9                   	leave  
  80204a:	c3                   	ret    

0080204b <sys_disable_interrupt>:

//NEW !! 2012...
void
sys_disable_interrupt()
{
  80204b:	55                   	push   %ebp
  80204c:	89 e5                	mov    %esp,%ebp
	syscall(SYS_disableINTR,0, 0, 0, 0, 0);
  80204e:	6a 00                	push   $0x0
  802050:	6a 00                	push   $0x0
  802052:	6a 00                	push   $0x0
  802054:	6a 00                	push   $0x0
  802056:	6a 00                	push   $0x0
  802058:	6a 13                	push   $0x13
  80205a:	e8 13 fe ff ff       	call   801e72 <syscall>
  80205f:	83 c4 18             	add    $0x18,%esp
}
  802062:	90                   	nop
  802063:	c9                   	leave  
  802064:	c3                   	ret    

00802065 <sys_enable_interrupt>:


void
sys_enable_interrupt()
{
  802065:	55                   	push   %ebp
  802066:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enableINTR,0, 0, 0, 0, 0);
  802068:	6a 00                	push   $0x0
  80206a:	6a 00                	push   $0x0
  80206c:	6a 00                	push   $0x0
  80206e:	6a 00                	push   $0x0
  802070:	6a 00                	push   $0x0
  802072:	6a 14                	push   $0x14
  802074:	e8 f9 fd ff ff       	call   801e72 <syscall>
  802079:	83 c4 18             	add    $0x18,%esp
}
  80207c:	90                   	nop
  80207d:	c9                   	leave  
  80207e:	c3                   	ret    

0080207f <sys_cputc>:


void
sys_cputc(const char c)
{
  80207f:	55                   	push   %ebp
  802080:	89 e5                	mov    %esp,%ebp
  802082:	83 ec 04             	sub    $0x4,%esp
  802085:	8b 45 08             	mov    0x8(%ebp),%eax
  802088:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  80208b:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  80208f:	6a 00                	push   $0x0
  802091:	6a 00                	push   $0x0
  802093:	6a 00                	push   $0x0
  802095:	6a 00                	push   $0x0
  802097:	50                   	push   %eax
  802098:	6a 15                	push   $0x15
  80209a:	e8 d3 fd ff ff       	call   801e72 <syscall>
  80209f:	83 c4 18             	add    $0x18,%esp
}
  8020a2:	90                   	nop
  8020a3:	c9                   	leave  
  8020a4:	c3                   	ret    

008020a5 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  8020a5:	55                   	push   %ebp
  8020a6:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  8020a8:	6a 00                	push   $0x0
  8020aa:	6a 00                	push   $0x0
  8020ac:	6a 00                	push   $0x0
  8020ae:	6a 00                	push   $0x0
  8020b0:	6a 00                	push   $0x0
  8020b2:	6a 16                	push   $0x16
  8020b4:	e8 b9 fd ff ff       	call   801e72 <syscall>
  8020b9:	83 c4 18             	add    $0x18,%esp
}
  8020bc:	90                   	nop
  8020bd:	c9                   	leave  
  8020be:	c3                   	ret    

008020bf <sys_createSemaphore>:

int
sys_createSemaphore(char* semaphoreName, uint32 initialValue)
{
  8020bf:	55                   	push   %ebp
  8020c0:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_semaphore,(uint32)semaphoreName, (uint32)initialValue, 0, 0, 0);
  8020c2:	8b 45 08             	mov    0x8(%ebp),%eax
  8020c5:	6a 00                	push   $0x0
  8020c7:	6a 00                	push   $0x0
  8020c9:	6a 00                	push   $0x0
  8020cb:	ff 75 0c             	pushl  0xc(%ebp)
  8020ce:	50                   	push   %eax
  8020cf:	6a 17                	push   $0x17
  8020d1:	e8 9c fd ff ff       	call   801e72 <syscall>
  8020d6:	83 c4 18             	add    $0x18,%esp
}
  8020d9:	c9                   	leave  
  8020da:	c3                   	ret    

008020db <sys_getSemaphoreValue>:

int
sys_getSemaphoreValue(int32 ownerEnvID, char* semaphoreName)
{
  8020db:	55                   	push   %ebp
  8020dc:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_semaphore_value,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  8020de:	8b 55 0c             	mov    0xc(%ebp),%edx
  8020e1:	8b 45 08             	mov    0x8(%ebp),%eax
  8020e4:	6a 00                	push   $0x0
  8020e6:	6a 00                	push   $0x0
  8020e8:	6a 00                	push   $0x0
  8020ea:	52                   	push   %edx
  8020eb:	50                   	push   %eax
  8020ec:	6a 1a                	push   $0x1a
  8020ee:	e8 7f fd ff ff       	call   801e72 <syscall>
  8020f3:	83 c4 18             	add    $0x18,%esp
}
  8020f6:	c9                   	leave  
  8020f7:	c3                   	ret    

008020f8 <sys_waitSemaphore>:

void
sys_waitSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  8020f8:	55                   	push   %ebp
  8020f9:	89 e5                	mov    %esp,%ebp
	syscall(SYS_wait_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  8020fb:	8b 55 0c             	mov    0xc(%ebp),%edx
  8020fe:	8b 45 08             	mov    0x8(%ebp),%eax
  802101:	6a 00                	push   $0x0
  802103:	6a 00                	push   $0x0
  802105:	6a 00                	push   $0x0
  802107:	52                   	push   %edx
  802108:	50                   	push   %eax
  802109:	6a 18                	push   $0x18
  80210b:	e8 62 fd ff ff       	call   801e72 <syscall>
  802110:	83 c4 18             	add    $0x18,%esp
}
  802113:	90                   	nop
  802114:	c9                   	leave  
  802115:	c3                   	ret    

00802116 <sys_signalSemaphore>:

void
sys_signalSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  802116:	55                   	push   %ebp
  802117:	89 e5                	mov    %esp,%ebp
	syscall(SYS_signal_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  802119:	8b 55 0c             	mov    0xc(%ebp),%edx
  80211c:	8b 45 08             	mov    0x8(%ebp),%eax
  80211f:	6a 00                	push   $0x0
  802121:	6a 00                	push   $0x0
  802123:	6a 00                	push   $0x0
  802125:	52                   	push   %edx
  802126:	50                   	push   %eax
  802127:	6a 19                	push   $0x19
  802129:	e8 44 fd ff ff       	call   801e72 <syscall>
  80212e:	83 c4 18             	add    $0x18,%esp
}
  802131:	90                   	nop
  802132:	c9                   	leave  
  802133:	c3                   	ret    

00802134 <sys_createSharedObject>:

int
sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  802134:	55                   	push   %ebp
  802135:	89 e5                	mov    %esp,%ebp
  802137:	83 ec 04             	sub    $0x4,%esp
  80213a:	8b 45 10             	mov    0x10(%ebp),%eax
  80213d:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  802140:	8b 4d 14             	mov    0x14(%ebp),%ecx
  802143:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  802147:	8b 45 08             	mov    0x8(%ebp),%eax
  80214a:	6a 00                	push   $0x0
  80214c:	51                   	push   %ecx
  80214d:	52                   	push   %edx
  80214e:	ff 75 0c             	pushl  0xc(%ebp)
  802151:	50                   	push   %eax
  802152:	6a 1b                	push   $0x1b
  802154:	e8 19 fd ff ff       	call   801e72 <syscall>
  802159:	83 c4 18             	add    $0x18,%esp
}
  80215c:	c9                   	leave  
  80215d:	c3                   	ret    

0080215e <sys_getSizeOfSharedObject>:

//2017:
int
sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  80215e:	55                   	push   %ebp
  80215f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  802161:	8b 55 0c             	mov    0xc(%ebp),%edx
  802164:	8b 45 08             	mov    0x8(%ebp),%eax
  802167:	6a 00                	push   $0x0
  802169:	6a 00                	push   $0x0
  80216b:	6a 00                	push   $0x0
  80216d:	52                   	push   %edx
  80216e:	50                   	push   %eax
  80216f:	6a 1c                	push   $0x1c
  802171:	e8 fc fc ff ff       	call   801e72 <syscall>
  802176:	83 c4 18             	add    $0x18,%esp
}
  802179:	c9                   	leave  
  80217a:	c3                   	ret    

0080217b <sys_getSharedObject>:
//==========

int
sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  80217b:	55                   	push   %ebp
  80217c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  80217e:	8b 4d 10             	mov    0x10(%ebp),%ecx
  802181:	8b 55 0c             	mov    0xc(%ebp),%edx
  802184:	8b 45 08             	mov    0x8(%ebp),%eax
  802187:	6a 00                	push   $0x0
  802189:	6a 00                	push   $0x0
  80218b:	51                   	push   %ecx
  80218c:	52                   	push   %edx
  80218d:	50                   	push   %eax
  80218e:	6a 1d                	push   $0x1d
  802190:	e8 dd fc ff ff       	call   801e72 <syscall>
  802195:	83 c4 18             	add    $0x18,%esp
}
  802198:	c9                   	leave  
  802199:	c3                   	ret    

0080219a <sys_freeSharedObject>:

int
sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  80219a:	55                   	push   %ebp
  80219b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  80219d:	8b 55 0c             	mov    0xc(%ebp),%edx
  8021a0:	8b 45 08             	mov    0x8(%ebp),%eax
  8021a3:	6a 00                	push   $0x0
  8021a5:	6a 00                	push   $0x0
  8021a7:	6a 00                	push   $0x0
  8021a9:	52                   	push   %edx
  8021aa:	50                   	push   %eax
  8021ab:	6a 1e                	push   $0x1e
  8021ad:	e8 c0 fc ff ff       	call   801e72 <syscall>
  8021b2:	83 c4 18             	add    $0x18,%esp
}
  8021b5:	c9                   	leave  
  8021b6:	c3                   	ret    

008021b7 <sys_getMaxShares>:

uint32 	sys_getMaxShares()
{
  8021b7:	55                   	push   %ebp
  8021b8:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_max_shares,0, 0, 0, 0, 0);
  8021ba:	6a 00                	push   $0x0
  8021bc:	6a 00                	push   $0x0
  8021be:	6a 00                	push   $0x0
  8021c0:	6a 00                	push   $0x0
  8021c2:	6a 00                	push   $0x0
  8021c4:	6a 1f                	push   $0x1f
  8021c6:	e8 a7 fc ff ff       	call   801e72 <syscall>
  8021cb:	83 c4 18             	add    $0x18,%esp
}
  8021ce:	c9                   	leave  
  8021cf:	c3                   	ret    

008021d0 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  8021d0:	55                   	push   %ebp
  8021d1:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  8021d3:	8b 45 08             	mov    0x8(%ebp),%eax
  8021d6:	6a 00                	push   $0x0
  8021d8:	ff 75 14             	pushl  0x14(%ebp)
  8021db:	ff 75 10             	pushl  0x10(%ebp)
  8021de:	ff 75 0c             	pushl  0xc(%ebp)
  8021e1:	50                   	push   %eax
  8021e2:	6a 20                	push   $0x20
  8021e4:	e8 89 fc ff ff       	call   801e72 <syscall>
  8021e9:	83 c4 18             	add    $0x18,%esp
}
  8021ec:	c9                   	leave  
  8021ed:	c3                   	ret    

008021ee <sys_run_env>:

void
sys_run_env(int32 envId)
{
  8021ee:	55                   	push   %ebp
  8021ef:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  8021f1:	8b 45 08             	mov    0x8(%ebp),%eax
  8021f4:	6a 00                	push   $0x0
  8021f6:	6a 00                	push   $0x0
  8021f8:	6a 00                	push   $0x0
  8021fa:	6a 00                	push   $0x0
  8021fc:	50                   	push   %eax
  8021fd:	6a 21                	push   $0x21
  8021ff:	e8 6e fc ff ff       	call   801e72 <syscall>
  802204:	83 c4 18             	add    $0x18,%esp
}
  802207:	90                   	nop
  802208:	c9                   	leave  
  802209:	c3                   	ret    

0080220a <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  80220a:	55                   	push   %ebp
  80220b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  80220d:	8b 45 08             	mov    0x8(%ebp),%eax
  802210:	6a 00                	push   $0x0
  802212:	6a 00                	push   $0x0
  802214:	6a 00                	push   $0x0
  802216:	6a 00                	push   $0x0
  802218:	50                   	push   %eax
  802219:	6a 22                	push   $0x22
  80221b:	e8 52 fc ff ff       	call   801e72 <syscall>
  802220:	83 c4 18             	add    $0x18,%esp
}
  802223:	c9                   	leave  
  802224:	c3                   	ret    

00802225 <sys_getenvid>:

int32 sys_getenvid(void)
{
  802225:	55                   	push   %ebp
  802226:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  802228:	6a 00                	push   $0x0
  80222a:	6a 00                	push   $0x0
  80222c:	6a 00                	push   $0x0
  80222e:	6a 00                	push   $0x0
  802230:	6a 00                	push   $0x0
  802232:	6a 02                	push   $0x2
  802234:	e8 39 fc ff ff       	call   801e72 <syscall>
  802239:	83 c4 18             	add    $0x18,%esp
}
  80223c:	c9                   	leave  
  80223d:	c3                   	ret    

0080223e <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  80223e:	55                   	push   %ebp
  80223f:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  802241:	6a 00                	push   $0x0
  802243:	6a 00                	push   $0x0
  802245:	6a 00                	push   $0x0
  802247:	6a 00                	push   $0x0
  802249:	6a 00                	push   $0x0
  80224b:	6a 03                	push   $0x3
  80224d:	e8 20 fc ff ff       	call   801e72 <syscall>
  802252:	83 c4 18             	add    $0x18,%esp
}
  802255:	c9                   	leave  
  802256:	c3                   	ret    

00802257 <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  802257:	55                   	push   %ebp
  802258:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  80225a:	6a 00                	push   $0x0
  80225c:	6a 00                	push   $0x0
  80225e:	6a 00                	push   $0x0
  802260:	6a 00                	push   $0x0
  802262:	6a 00                	push   $0x0
  802264:	6a 04                	push   $0x4
  802266:	e8 07 fc ff ff       	call   801e72 <syscall>
  80226b:	83 c4 18             	add    $0x18,%esp
}
  80226e:	c9                   	leave  
  80226f:	c3                   	ret    

00802270 <sys_exit_env>:


void sys_exit_env(void)
{
  802270:	55                   	push   %ebp
  802271:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  802273:	6a 00                	push   $0x0
  802275:	6a 00                	push   $0x0
  802277:	6a 00                	push   $0x0
  802279:	6a 00                	push   $0x0
  80227b:	6a 00                	push   $0x0
  80227d:	6a 23                	push   $0x23
  80227f:	e8 ee fb ff ff       	call   801e72 <syscall>
  802284:	83 c4 18             	add    $0x18,%esp
}
  802287:	90                   	nop
  802288:	c9                   	leave  
  802289:	c3                   	ret    

0080228a <sys_get_virtual_time>:


struct uint64
sys_get_virtual_time()
{
  80228a:	55                   	push   %ebp
  80228b:	89 e5                	mov    %esp,%ebp
  80228d:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  802290:	8d 45 f8             	lea    -0x8(%ebp),%eax
  802293:	8d 50 04             	lea    0x4(%eax),%edx
  802296:	8d 45 f8             	lea    -0x8(%ebp),%eax
  802299:	6a 00                	push   $0x0
  80229b:	6a 00                	push   $0x0
  80229d:	6a 00                	push   $0x0
  80229f:	52                   	push   %edx
  8022a0:	50                   	push   %eax
  8022a1:	6a 24                	push   $0x24
  8022a3:	e8 ca fb ff ff       	call   801e72 <syscall>
  8022a8:	83 c4 18             	add    $0x18,%esp
	return result;
  8022ab:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8022ae:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8022b1:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8022b4:	89 01                	mov    %eax,(%ecx)
  8022b6:	89 51 04             	mov    %edx,0x4(%ecx)
}
  8022b9:	8b 45 08             	mov    0x8(%ebp),%eax
  8022bc:	c9                   	leave  
  8022bd:	c2 04 00             	ret    $0x4

008022c0 <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  8022c0:	55                   	push   %ebp
  8022c1:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  8022c3:	6a 00                	push   $0x0
  8022c5:	6a 00                	push   $0x0
  8022c7:	ff 75 10             	pushl  0x10(%ebp)
  8022ca:	ff 75 0c             	pushl  0xc(%ebp)
  8022cd:	ff 75 08             	pushl  0x8(%ebp)
  8022d0:	6a 12                	push   $0x12
  8022d2:	e8 9b fb ff ff       	call   801e72 <syscall>
  8022d7:	83 c4 18             	add    $0x18,%esp
	return ;
  8022da:	90                   	nop
}
  8022db:	c9                   	leave  
  8022dc:	c3                   	ret    

008022dd <sys_rcr2>:
uint32 sys_rcr2()
{
  8022dd:	55                   	push   %ebp
  8022de:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  8022e0:	6a 00                	push   $0x0
  8022e2:	6a 00                	push   $0x0
  8022e4:	6a 00                	push   $0x0
  8022e6:	6a 00                	push   $0x0
  8022e8:	6a 00                	push   $0x0
  8022ea:	6a 25                	push   $0x25
  8022ec:	e8 81 fb ff ff       	call   801e72 <syscall>
  8022f1:	83 c4 18             	add    $0x18,%esp
}
  8022f4:	c9                   	leave  
  8022f5:	c3                   	ret    

008022f6 <sys_bypassPageFault>:
void sys_bypassPageFault(uint8 instrLength)
{
  8022f6:	55                   	push   %ebp
  8022f7:	89 e5                	mov    %esp,%ebp
  8022f9:	83 ec 04             	sub    $0x4,%esp
  8022fc:	8b 45 08             	mov    0x8(%ebp),%eax
  8022ff:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  802302:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  802306:	6a 00                	push   $0x0
  802308:	6a 00                	push   $0x0
  80230a:	6a 00                	push   $0x0
  80230c:	6a 00                	push   $0x0
  80230e:	50                   	push   %eax
  80230f:	6a 26                	push   $0x26
  802311:	e8 5c fb ff ff       	call   801e72 <syscall>
  802316:	83 c4 18             	add    $0x18,%esp
	return ;
  802319:	90                   	nop
}
  80231a:	c9                   	leave  
  80231b:	c3                   	ret    

0080231c <rsttst>:
void rsttst()
{
  80231c:	55                   	push   %ebp
  80231d:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  80231f:	6a 00                	push   $0x0
  802321:	6a 00                	push   $0x0
  802323:	6a 00                	push   $0x0
  802325:	6a 00                	push   $0x0
  802327:	6a 00                	push   $0x0
  802329:	6a 28                	push   $0x28
  80232b:	e8 42 fb ff ff       	call   801e72 <syscall>
  802330:	83 c4 18             	add    $0x18,%esp
	return ;
  802333:	90                   	nop
}
  802334:	c9                   	leave  
  802335:	c3                   	ret    

00802336 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  802336:	55                   	push   %ebp
  802337:	89 e5                	mov    %esp,%ebp
  802339:	83 ec 04             	sub    $0x4,%esp
  80233c:	8b 45 14             	mov    0x14(%ebp),%eax
  80233f:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  802342:	8b 55 18             	mov    0x18(%ebp),%edx
  802345:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  802349:	52                   	push   %edx
  80234a:	50                   	push   %eax
  80234b:	ff 75 10             	pushl  0x10(%ebp)
  80234e:	ff 75 0c             	pushl  0xc(%ebp)
  802351:	ff 75 08             	pushl  0x8(%ebp)
  802354:	6a 27                	push   $0x27
  802356:	e8 17 fb ff ff       	call   801e72 <syscall>
  80235b:	83 c4 18             	add    $0x18,%esp
	return ;
  80235e:	90                   	nop
}
  80235f:	c9                   	leave  
  802360:	c3                   	ret    

00802361 <chktst>:
void chktst(uint32 n)
{
  802361:	55                   	push   %ebp
  802362:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  802364:	6a 00                	push   $0x0
  802366:	6a 00                	push   $0x0
  802368:	6a 00                	push   $0x0
  80236a:	6a 00                	push   $0x0
  80236c:	ff 75 08             	pushl  0x8(%ebp)
  80236f:	6a 29                	push   $0x29
  802371:	e8 fc fa ff ff       	call   801e72 <syscall>
  802376:	83 c4 18             	add    $0x18,%esp
	return ;
  802379:	90                   	nop
}
  80237a:	c9                   	leave  
  80237b:	c3                   	ret    

0080237c <inctst>:

void inctst()
{
  80237c:	55                   	push   %ebp
  80237d:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  80237f:	6a 00                	push   $0x0
  802381:	6a 00                	push   $0x0
  802383:	6a 00                	push   $0x0
  802385:	6a 00                	push   $0x0
  802387:	6a 00                	push   $0x0
  802389:	6a 2a                	push   $0x2a
  80238b:	e8 e2 fa ff ff       	call   801e72 <syscall>
  802390:	83 c4 18             	add    $0x18,%esp
	return ;
  802393:	90                   	nop
}
  802394:	c9                   	leave  
  802395:	c3                   	ret    

00802396 <gettst>:
uint32 gettst()
{
  802396:	55                   	push   %ebp
  802397:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  802399:	6a 00                	push   $0x0
  80239b:	6a 00                	push   $0x0
  80239d:	6a 00                	push   $0x0
  80239f:	6a 00                	push   $0x0
  8023a1:	6a 00                	push   $0x0
  8023a3:	6a 2b                	push   $0x2b
  8023a5:	e8 c8 fa ff ff       	call   801e72 <syscall>
  8023aa:	83 c4 18             	add    $0x18,%esp
}
  8023ad:	c9                   	leave  
  8023ae:	c3                   	ret    

008023af <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  8023af:	55                   	push   %ebp
  8023b0:	89 e5                	mov    %esp,%ebp
  8023b2:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8023b5:	6a 00                	push   $0x0
  8023b7:	6a 00                	push   $0x0
  8023b9:	6a 00                	push   $0x0
  8023bb:	6a 00                	push   $0x0
  8023bd:	6a 00                	push   $0x0
  8023bf:	6a 2c                	push   $0x2c
  8023c1:	e8 ac fa ff ff       	call   801e72 <syscall>
  8023c6:	83 c4 18             	add    $0x18,%esp
  8023c9:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  8023cc:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  8023d0:	75 07                	jne    8023d9 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  8023d2:	b8 01 00 00 00       	mov    $0x1,%eax
  8023d7:	eb 05                	jmp    8023de <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  8023d9:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8023de:	c9                   	leave  
  8023df:	c3                   	ret    

008023e0 <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  8023e0:	55                   	push   %ebp
  8023e1:	89 e5                	mov    %esp,%ebp
  8023e3:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8023e6:	6a 00                	push   $0x0
  8023e8:	6a 00                	push   $0x0
  8023ea:	6a 00                	push   $0x0
  8023ec:	6a 00                	push   $0x0
  8023ee:	6a 00                	push   $0x0
  8023f0:	6a 2c                	push   $0x2c
  8023f2:	e8 7b fa ff ff       	call   801e72 <syscall>
  8023f7:	83 c4 18             	add    $0x18,%esp
  8023fa:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  8023fd:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  802401:	75 07                	jne    80240a <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  802403:	b8 01 00 00 00       	mov    $0x1,%eax
  802408:	eb 05                	jmp    80240f <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  80240a:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80240f:	c9                   	leave  
  802410:	c3                   	ret    

00802411 <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  802411:	55                   	push   %ebp
  802412:	89 e5                	mov    %esp,%ebp
  802414:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  802417:	6a 00                	push   $0x0
  802419:	6a 00                	push   $0x0
  80241b:	6a 00                	push   $0x0
  80241d:	6a 00                	push   $0x0
  80241f:	6a 00                	push   $0x0
  802421:	6a 2c                	push   $0x2c
  802423:	e8 4a fa ff ff       	call   801e72 <syscall>
  802428:	83 c4 18             	add    $0x18,%esp
  80242b:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  80242e:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  802432:	75 07                	jne    80243b <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  802434:	b8 01 00 00 00       	mov    $0x1,%eax
  802439:	eb 05                	jmp    802440 <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  80243b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802440:	c9                   	leave  
  802441:	c3                   	ret    

00802442 <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  802442:	55                   	push   %ebp
  802443:	89 e5                	mov    %esp,%ebp
  802445:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  802448:	6a 00                	push   $0x0
  80244a:	6a 00                	push   $0x0
  80244c:	6a 00                	push   $0x0
  80244e:	6a 00                	push   $0x0
  802450:	6a 00                	push   $0x0
  802452:	6a 2c                	push   $0x2c
  802454:	e8 19 fa ff ff       	call   801e72 <syscall>
  802459:	83 c4 18             	add    $0x18,%esp
  80245c:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  80245f:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  802463:	75 07                	jne    80246c <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  802465:	b8 01 00 00 00       	mov    $0x1,%eax
  80246a:	eb 05                	jmp    802471 <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  80246c:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802471:	c9                   	leave  
  802472:	c3                   	ret    

00802473 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  802473:	55                   	push   %ebp
  802474:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  802476:	6a 00                	push   $0x0
  802478:	6a 00                	push   $0x0
  80247a:	6a 00                	push   $0x0
  80247c:	6a 00                	push   $0x0
  80247e:	ff 75 08             	pushl  0x8(%ebp)
  802481:	6a 2d                	push   $0x2d
  802483:	e8 ea f9 ff ff       	call   801e72 <syscall>
  802488:	83 c4 18             	add    $0x18,%esp
	return ;
  80248b:	90                   	nop
}
  80248c:	c9                   	leave  
  80248d:	c3                   	ret    

0080248e <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  80248e:	55                   	push   %ebp
  80248f:	89 e5                	mov    %esp,%ebp
  802491:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  802492:	8b 5d 14             	mov    0x14(%ebp),%ebx
  802495:	8b 4d 10             	mov    0x10(%ebp),%ecx
  802498:	8b 55 0c             	mov    0xc(%ebp),%edx
  80249b:	8b 45 08             	mov    0x8(%ebp),%eax
  80249e:	6a 00                	push   $0x0
  8024a0:	53                   	push   %ebx
  8024a1:	51                   	push   %ecx
  8024a2:	52                   	push   %edx
  8024a3:	50                   	push   %eax
  8024a4:	6a 2e                	push   $0x2e
  8024a6:	e8 c7 f9 ff ff       	call   801e72 <syscall>
  8024ab:	83 c4 18             	add    $0x18,%esp
}
  8024ae:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8024b1:	c9                   	leave  
  8024b2:	c3                   	ret    

008024b3 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  8024b3:	55                   	push   %ebp
  8024b4:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  8024b6:	8b 55 0c             	mov    0xc(%ebp),%edx
  8024b9:	8b 45 08             	mov    0x8(%ebp),%eax
  8024bc:	6a 00                	push   $0x0
  8024be:	6a 00                	push   $0x0
  8024c0:	6a 00                	push   $0x0
  8024c2:	52                   	push   %edx
  8024c3:	50                   	push   %eax
  8024c4:	6a 2f                	push   $0x2f
  8024c6:	e8 a7 f9 ff ff       	call   801e72 <syscall>
  8024cb:	83 c4 18             	add    $0x18,%esp
}
  8024ce:	c9                   	leave  
  8024cf:	c3                   	ret    

008024d0 <print_mem_block_lists>:
//===========================
// PRINT MEM BLOCK LISTS:
//===========================

void print_mem_block_lists()
{
  8024d0:	55                   	push   %ebp
  8024d1:	89 e5                	mov    %esp,%ebp
  8024d3:	83 ec 18             	sub    $0x18,%esp
	cprintf("\n=========================================\n");
  8024d6:	83 ec 0c             	sub    $0xc,%esp
  8024d9:	68 a0 3f 80 00       	push   $0x803fa0
  8024de:	e8 dd e6 ff ff       	call   800bc0 <cprintf>
  8024e3:	83 c4 10             	add    $0x10,%esp
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
  8024e6:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nFreeMemBlocksList:\n");
  8024ed:	83 ec 0c             	sub    $0xc,%esp
  8024f0:	68 cc 3f 80 00       	push   $0x803fcc
  8024f5:	e8 c6 e6 ff ff       	call   800bc0 <cprintf>
  8024fa:	83 c4 10             	add    $0x10,%esp
	uint8 sorted = 1 ;
  8024fd:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &FreeMemBlocksList)
  802501:	a1 38 51 80 00       	mov    0x805138,%eax
  802506:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802509:	eb 56                	jmp    802561 <print_mem_block_lists+0x91>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  80250b:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80250f:	74 1c                	je     80252d <print_mem_block_lists+0x5d>
  802511:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802514:	8b 50 08             	mov    0x8(%eax),%edx
  802517:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80251a:	8b 48 08             	mov    0x8(%eax),%ecx
  80251d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802520:	8b 40 0c             	mov    0xc(%eax),%eax
  802523:	01 c8                	add    %ecx,%eax
  802525:	39 c2                	cmp    %eax,%edx
  802527:	73 04                	jae    80252d <print_mem_block_lists+0x5d>
			sorted = 0 ;
  802529:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  80252d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802530:	8b 50 08             	mov    0x8(%eax),%edx
  802533:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802536:	8b 40 0c             	mov    0xc(%eax),%eax
  802539:	01 c2                	add    %eax,%edx
  80253b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80253e:	8b 40 08             	mov    0x8(%eax),%eax
  802541:	83 ec 04             	sub    $0x4,%esp
  802544:	52                   	push   %edx
  802545:	50                   	push   %eax
  802546:	68 e1 3f 80 00       	push   $0x803fe1
  80254b:	e8 70 e6 ff ff       	call   800bc0 <cprintf>
  802550:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  802553:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802556:	89 45 f0             	mov    %eax,-0x10(%ebp)
	cprintf("\n=========================================\n");
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
	cprintf("\nFreeMemBlocksList:\n");
	uint8 sorted = 1 ;
	LIST_FOREACH(blk, &FreeMemBlocksList)
  802559:	a1 40 51 80 00       	mov    0x805140,%eax
  80255e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802561:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802565:	74 07                	je     80256e <print_mem_block_lists+0x9e>
  802567:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80256a:	8b 00                	mov    (%eax),%eax
  80256c:	eb 05                	jmp    802573 <print_mem_block_lists+0xa3>
  80256e:	b8 00 00 00 00       	mov    $0x0,%eax
  802573:	a3 40 51 80 00       	mov    %eax,0x805140
  802578:	a1 40 51 80 00       	mov    0x805140,%eax
  80257d:	85 c0                	test   %eax,%eax
  80257f:	75 8a                	jne    80250b <print_mem_block_lists+0x3b>
  802581:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802585:	75 84                	jne    80250b <print_mem_block_lists+0x3b>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;
  802587:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  80258b:	75 10                	jne    80259d <print_mem_block_lists+0xcd>
  80258d:	83 ec 0c             	sub    $0xc,%esp
  802590:	68 f0 3f 80 00       	push   $0x803ff0
  802595:	e8 26 e6 ff ff       	call   800bc0 <cprintf>
  80259a:	83 c4 10             	add    $0x10,%esp

	lastBlk = NULL ;
  80259d:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nAllocMemBlocksList:\n");
  8025a4:	83 ec 0c             	sub    $0xc,%esp
  8025a7:	68 14 40 80 00       	push   $0x804014
  8025ac:	e8 0f e6 ff ff       	call   800bc0 <cprintf>
  8025b1:	83 c4 10             	add    $0x10,%esp
	sorted = 1 ;
  8025b4:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &AllocMemBlocksList)
  8025b8:	a1 40 50 80 00       	mov    0x805040,%eax
  8025bd:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8025c0:	eb 56                	jmp    802618 <print_mem_block_lists+0x148>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  8025c2:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8025c6:	74 1c                	je     8025e4 <print_mem_block_lists+0x114>
  8025c8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025cb:	8b 50 08             	mov    0x8(%eax),%edx
  8025ce:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8025d1:	8b 48 08             	mov    0x8(%eax),%ecx
  8025d4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8025d7:	8b 40 0c             	mov    0xc(%eax),%eax
  8025da:	01 c8                	add    %ecx,%eax
  8025dc:	39 c2                	cmp    %eax,%edx
  8025de:	73 04                	jae    8025e4 <print_mem_block_lists+0x114>
			sorted = 0 ;
  8025e0:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  8025e4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025e7:	8b 50 08             	mov    0x8(%eax),%edx
  8025ea:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025ed:	8b 40 0c             	mov    0xc(%eax),%eax
  8025f0:	01 c2                	add    %eax,%edx
  8025f2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025f5:	8b 40 08             	mov    0x8(%eax),%eax
  8025f8:	83 ec 04             	sub    $0x4,%esp
  8025fb:	52                   	push   %edx
  8025fc:	50                   	push   %eax
  8025fd:	68 e1 3f 80 00       	push   $0x803fe1
  802602:	e8 b9 e5 ff ff       	call   800bc0 <cprintf>
  802607:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  80260a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80260d:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;

	lastBlk = NULL ;
	cprintf("\nAllocMemBlocksList:\n");
	sorted = 1 ;
	LIST_FOREACH(blk, &AllocMemBlocksList)
  802610:	a1 48 50 80 00       	mov    0x805048,%eax
  802615:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802618:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80261c:	74 07                	je     802625 <print_mem_block_lists+0x155>
  80261e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802621:	8b 00                	mov    (%eax),%eax
  802623:	eb 05                	jmp    80262a <print_mem_block_lists+0x15a>
  802625:	b8 00 00 00 00       	mov    $0x0,%eax
  80262a:	a3 48 50 80 00       	mov    %eax,0x805048
  80262f:	a1 48 50 80 00       	mov    0x805048,%eax
  802634:	85 c0                	test   %eax,%eax
  802636:	75 8a                	jne    8025c2 <print_mem_block_lists+0xf2>
  802638:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80263c:	75 84                	jne    8025c2 <print_mem_block_lists+0xf2>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nAllocMemBlocksList is NOT SORTED!!\n") ;
  80263e:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  802642:	75 10                	jne    802654 <print_mem_block_lists+0x184>
  802644:	83 ec 0c             	sub    $0xc,%esp
  802647:	68 2c 40 80 00       	push   $0x80402c
  80264c:	e8 6f e5 ff ff       	call   800bc0 <cprintf>
  802651:	83 c4 10             	add    $0x10,%esp
	cprintf("\n=========================================\n");
  802654:	83 ec 0c             	sub    $0xc,%esp
  802657:	68 a0 3f 80 00       	push   $0x803fa0
  80265c:	e8 5f e5 ff ff       	call   800bc0 <cprintf>
  802661:	83 c4 10             	add    $0x10,%esp

}
  802664:	90                   	nop
  802665:	c9                   	leave  
  802666:	c3                   	ret    

00802667 <initialize_MemBlocksList>:

//===============================
// [1] INITIALIZE AVAILABLE LIST:
//===============================
void initialize_MemBlocksList(uint32 numOfBlocks)
{
  802667:	55                   	push   %ebp
  802668:	89 e5                	mov    %esp,%ebp
  80266a:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] initialize_MemBlocksList
	// Write your code here, remove the panic and write your code
	//panic("initialize_MemBlocksList() is not implemented yet...!!");
	uint32 n = numOfBlocks;
  80266d:	8b 45 08             	mov    0x8(%ebp),%eax
  802670:	89 45 f0             	mov    %eax,-0x10(%ebp)

	LIST_INIT(&AvailableMemBlocksList);
  802673:	c7 05 48 51 80 00 00 	movl   $0x0,0x805148
  80267a:	00 00 00 
  80267d:	c7 05 4c 51 80 00 00 	movl   $0x0,0x80514c
  802684:	00 00 00 
  802687:	c7 05 54 51 80 00 00 	movl   $0x0,0x805154
  80268e:	00 00 00 
	for(int i = 0; i<n;i++)
  802691:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  802698:	e9 9e 00 00 00       	jmp    80273b <initialize_MemBlocksList+0xd4>
	{
		LIST_INSERT_HEAD(&AvailableMemBlocksList, &(MemBlockNodes[i]));
  80269d:	a1 50 50 80 00       	mov    0x805050,%eax
  8026a2:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8026a5:	c1 e2 04             	shl    $0x4,%edx
  8026a8:	01 d0                	add    %edx,%eax
  8026aa:	85 c0                	test   %eax,%eax
  8026ac:	75 14                	jne    8026c2 <initialize_MemBlocksList+0x5b>
  8026ae:	83 ec 04             	sub    $0x4,%esp
  8026b1:	68 54 40 80 00       	push   $0x804054
  8026b6:	6a 47                	push   $0x47
  8026b8:	68 77 40 80 00       	push   $0x804077
  8026bd:	e8 4a e2 ff ff       	call   80090c <_panic>
  8026c2:	a1 50 50 80 00       	mov    0x805050,%eax
  8026c7:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8026ca:	c1 e2 04             	shl    $0x4,%edx
  8026cd:	01 d0                	add    %edx,%eax
  8026cf:	8b 15 48 51 80 00    	mov    0x805148,%edx
  8026d5:	89 10                	mov    %edx,(%eax)
  8026d7:	8b 00                	mov    (%eax),%eax
  8026d9:	85 c0                	test   %eax,%eax
  8026db:	74 18                	je     8026f5 <initialize_MemBlocksList+0x8e>
  8026dd:	a1 48 51 80 00       	mov    0x805148,%eax
  8026e2:	8b 15 50 50 80 00    	mov    0x805050,%edx
  8026e8:	8b 4d f4             	mov    -0xc(%ebp),%ecx
  8026eb:	c1 e1 04             	shl    $0x4,%ecx
  8026ee:	01 ca                	add    %ecx,%edx
  8026f0:	89 50 04             	mov    %edx,0x4(%eax)
  8026f3:	eb 12                	jmp    802707 <initialize_MemBlocksList+0xa0>
  8026f5:	a1 50 50 80 00       	mov    0x805050,%eax
  8026fa:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8026fd:	c1 e2 04             	shl    $0x4,%edx
  802700:	01 d0                	add    %edx,%eax
  802702:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802707:	a1 50 50 80 00       	mov    0x805050,%eax
  80270c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80270f:	c1 e2 04             	shl    $0x4,%edx
  802712:	01 d0                	add    %edx,%eax
  802714:	a3 48 51 80 00       	mov    %eax,0x805148
  802719:	a1 50 50 80 00       	mov    0x805050,%eax
  80271e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802721:	c1 e2 04             	shl    $0x4,%edx
  802724:	01 d0                	add    %edx,%eax
  802726:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80272d:	a1 54 51 80 00       	mov    0x805154,%eax
  802732:	40                   	inc    %eax
  802733:	a3 54 51 80 00       	mov    %eax,0x805154
	// Write your code here, remove the panic and write your code
	//panic("initialize_MemBlocksList() is not implemented yet...!!");
	uint32 n = numOfBlocks;

	LIST_INIT(&AvailableMemBlocksList);
	for(int i = 0; i<n;i++)
  802738:	ff 45 f4             	incl   -0xc(%ebp)
  80273b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80273e:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  802741:	0f 82 56 ff ff ff    	jb     80269d <initialize_MemBlocksList+0x36>
	{
		LIST_INSERT_HEAD(&AvailableMemBlocksList, &(MemBlockNodes[i]));
	}
}
  802747:	90                   	nop
  802748:	c9                   	leave  
  802749:	c3                   	ret    

0080274a <find_block>:

//===============================
// [2] FIND BLOCK:
//===============================
struct MemBlock *find_block(struct MemBlock_List *blockList, uint32 va)
{
  80274a:	55                   	push   %ebp
  80274b:	89 e5                	mov    %esp,%ebp
  80274d:	83 ec 10             	sub    $0x10,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] find_block
	// Write your code here, remove the panic and write your code
	//panic("find_block() is not implemented yet...!!");
	uint32 virAddress = va;
  802750:	8b 45 0c             	mov    0xc(%ebp),%eax
  802753:	89 45 f4             	mov    %eax,-0xc(%ebp)
	struct MemBlock* blk;
	int found = 0;
  802756:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	LIST_FOREACH(blk, &(AllocMemBlocksList))
  80275d:	a1 40 50 80 00       	mov    0x805040,%eax
  802762:	89 45 fc             	mov    %eax,-0x4(%ebp)
  802765:	eb 23                	jmp    80278a <find_block+0x40>
	{
		if(blk->sva == virAddress)
  802767:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80276a:	8b 40 08             	mov    0x8(%eax),%eax
  80276d:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  802770:	75 09                	jne    80277b <find_block+0x31>
		{
			found = 1;
  802772:	c7 45 f8 01 00 00 00 	movl   $0x1,-0x8(%ebp)
			break;
  802779:	eb 35                	jmp    8027b0 <find_block+0x66>
		}
		else
		{
			found = 0;
  80277b:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	//panic("find_block() is not implemented yet...!!");
	uint32 virAddress = va;
	struct MemBlock* blk;
	int found = 0;

	LIST_FOREACH(blk, &(AllocMemBlocksList))
  802782:	a1 48 50 80 00       	mov    0x805048,%eax
  802787:	89 45 fc             	mov    %eax,-0x4(%ebp)
  80278a:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  80278e:	74 07                	je     802797 <find_block+0x4d>
  802790:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802793:	8b 00                	mov    (%eax),%eax
  802795:	eb 05                	jmp    80279c <find_block+0x52>
  802797:	b8 00 00 00 00       	mov    $0x0,%eax
  80279c:	a3 48 50 80 00       	mov    %eax,0x805048
  8027a1:	a1 48 50 80 00       	mov    0x805048,%eax
  8027a6:	85 c0                	test   %eax,%eax
  8027a8:	75 bd                	jne    802767 <find_block+0x1d>
  8027aa:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8027ae:	75 b7                	jne    802767 <find_block+0x1d>
		{
			found = 0;
			continue;
		}
	}
	if(found == 1)
  8027b0:	83 7d f8 01          	cmpl   $0x1,-0x8(%ebp)
  8027b4:	75 05                	jne    8027bb <find_block+0x71>
	{
		return blk;
  8027b6:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8027b9:	eb 05                	jmp    8027c0 <find_block+0x76>
	}
	else
	{
		return NULL;
  8027bb:	b8 00 00 00 00       	mov    $0x0,%eax
	}
}
  8027c0:	c9                   	leave  
  8027c1:	c3                   	ret    

008027c2 <insert_sorted_allocList>:

//=========================================
// [3] INSERT BLOCK IN ALLOC LIST [SORTED]:
//=========================================
void insert_sorted_allocList(struct MemBlock *blockToInsert)
{
  8027c2:	55                   	push   %ebp
  8027c3:	89 e5                	mov    %esp,%ebp
  8027c5:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] insert_sorted_allocList
	// Write your code here, remove the panic and write your code
	//panic("insert_sorted_allocList() is not implemented yet...!!");
	struct MemBlock* blk;
	struct MemBlock* newblk = blockToInsert;
  8027c8:	8b 45 08             	mov    0x8(%ebp),%eax
  8027cb:	89 45 f0             	mov    %eax,-0x10(%ebp)

	if((LIST_EMPTY(&AllocMemBlocksList)) || (newblk->sva < LIST_FIRST(&AllocMemBlocksList)->sva))
  8027ce:	a1 40 50 80 00       	mov    0x805040,%eax
  8027d3:	85 c0                	test   %eax,%eax
  8027d5:	74 12                	je     8027e9 <insert_sorted_allocList+0x27>
  8027d7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8027da:	8b 50 08             	mov    0x8(%eax),%edx
  8027dd:	a1 40 50 80 00       	mov    0x805040,%eax
  8027e2:	8b 40 08             	mov    0x8(%eax),%eax
  8027e5:	39 c2                	cmp    %eax,%edx
  8027e7:	73 65                	jae    80284e <insert_sorted_allocList+0x8c>
	{
		LIST_INSERT_HEAD(&(AllocMemBlocksList), newblk);
  8027e9:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8027ed:	75 14                	jne    802803 <insert_sorted_allocList+0x41>
  8027ef:	83 ec 04             	sub    $0x4,%esp
  8027f2:	68 54 40 80 00       	push   $0x804054
  8027f7:	6a 7b                	push   $0x7b
  8027f9:	68 77 40 80 00       	push   $0x804077
  8027fe:	e8 09 e1 ff ff       	call   80090c <_panic>
  802803:	8b 15 40 50 80 00    	mov    0x805040,%edx
  802809:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80280c:	89 10                	mov    %edx,(%eax)
  80280e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802811:	8b 00                	mov    (%eax),%eax
  802813:	85 c0                	test   %eax,%eax
  802815:	74 0d                	je     802824 <insert_sorted_allocList+0x62>
  802817:	a1 40 50 80 00       	mov    0x805040,%eax
  80281c:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80281f:	89 50 04             	mov    %edx,0x4(%eax)
  802822:	eb 08                	jmp    80282c <insert_sorted_allocList+0x6a>
  802824:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802827:	a3 44 50 80 00       	mov    %eax,0x805044
  80282c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80282f:	a3 40 50 80 00       	mov    %eax,0x805040
  802834:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802837:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80283e:	a1 4c 50 80 00       	mov    0x80504c,%eax
  802843:	40                   	inc    %eax
  802844:	a3 4c 50 80 00       	mov    %eax,0x80504c
  802849:	e9 5f 01 00 00       	jmp    8029ad <insert_sorted_allocList+0x1eb>
	}
	else if(newblk->sva > LIST_LAST(&AllocMemBlocksList)->sva)
  80284e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802851:	8b 50 08             	mov    0x8(%eax),%edx
  802854:	a1 44 50 80 00       	mov    0x805044,%eax
  802859:	8b 40 08             	mov    0x8(%eax),%eax
  80285c:	39 c2                	cmp    %eax,%edx
  80285e:	76 65                	jbe    8028c5 <insert_sorted_allocList+0x103>
	{
		LIST_INSERT_TAIL(&AllocMemBlocksList, newblk);
  802860:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802864:	75 14                	jne    80287a <insert_sorted_allocList+0xb8>
  802866:	83 ec 04             	sub    $0x4,%esp
  802869:	68 90 40 80 00       	push   $0x804090
  80286e:	6a 7f                	push   $0x7f
  802870:	68 77 40 80 00       	push   $0x804077
  802875:	e8 92 e0 ff ff       	call   80090c <_panic>
  80287a:	8b 15 44 50 80 00    	mov    0x805044,%edx
  802880:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802883:	89 50 04             	mov    %edx,0x4(%eax)
  802886:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802889:	8b 40 04             	mov    0x4(%eax),%eax
  80288c:	85 c0                	test   %eax,%eax
  80288e:	74 0c                	je     80289c <insert_sorted_allocList+0xda>
  802890:	a1 44 50 80 00       	mov    0x805044,%eax
  802895:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802898:	89 10                	mov    %edx,(%eax)
  80289a:	eb 08                	jmp    8028a4 <insert_sorted_allocList+0xe2>
  80289c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80289f:	a3 40 50 80 00       	mov    %eax,0x805040
  8028a4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8028a7:	a3 44 50 80 00       	mov    %eax,0x805044
  8028ac:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8028af:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8028b5:	a1 4c 50 80 00       	mov    0x80504c,%eax
  8028ba:	40                   	inc    %eax
  8028bb:	a3 4c 50 80 00       	mov    %eax,0x80504c
				LIST_INSERT_AFTER(&AllocMemBlocksList, blk, newblk);
				break;
			}
		}
	}
}
  8028c0:	e9 e8 00 00 00       	jmp    8029ad <insert_sorted_allocList+0x1eb>
	{
		LIST_INSERT_TAIL(&AllocMemBlocksList, newblk);
	}
	else
	{
		LIST_FOREACH(blk, &AllocMemBlocksList)
  8028c5:	a1 40 50 80 00       	mov    0x805040,%eax
  8028ca:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8028cd:	e9 ab 00 00 00       	jmp    80297d <insert_sorted_allocList+0x1bb>
		{
			if(blk->prev_next_info.le_next != NULL && newblk->sva > blk->sva  && newblk->sva < blk->prev_next_info.le_next->sva)
  8028d2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028d5:	8b 00                	mov    (%eax),%eax
  8028d7:	85 c0                	test   %eax,%eax
  8028d9:	0f 84 96 00 00 00    	je     802975 <insert_sorted_allocList+0x1b3>
  8028df:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8028e2:	8b 50 08             	mov    0x8(%eax),%edx
  8028e5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028e8:	8b 40 08             	mov    0x8(%eax),%eax
  8028eb:	39 c2                	cmp    %eax,%edx
  8028ed:	0f 86 82 00 00 00    	jbe    802975 <insert_sorted_allocList+0x1b3>
  8028f3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8028f6:	8b 50 08             	mov    0x8(%eax),%edx
  8028f9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028fc:	8b 00                	mov    (%eax),%eax
  8028fe:	8b 40 08             	mov    0x8(%eax),%eax
  802901:	39 c2                	cmp    %eax,%edx
  802903:	73 70                	jae    802975 <insert_sorted_allocList+0x1b3>
			{
				LIST_INSERT_AFTER(&AllocMemBlocksList, blk, newblk);
  802905:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802909:	74 06                	je     802911 <insert_sorted_allocList+0x14f>
  80290b:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80290f:	75 17                	jne    802928 <insert_sorted_allocList+0x166>
  802911:	83 ec 04             	sub    $0x4,%esp
  802914:	68 b4 40 80 00       	push   $0x8040b4
  802919:	68 87 00 00 00       	push   $0x87
  80291e:	68 77 40 80 00       	push   $0x804077
  802923:	e8 e4 df ff ff       	call   80090c <_panic>
  802928:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80292b:	8b 10                	mov    (%eax),%edx
  80292d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802930:	89 10                	mov    %edx,(%eax)
  802932:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802935:	8b 00                	mov    (%eax),%eax
  802937:	85 c0                	test   %eax,%eax
  802939:	74 0b                	je     802946 <insert_sorted_allocList+0x184>
  80293b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80293e:	8b 00                	mov    (%eax),%eax
  802940:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802943:	89 50 04             	mov    %edx,0x4(%eax)
  802946:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802949:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80294c:	89 10                	mov    %edx,(%eax)
  80294e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802951:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802954:	89 50 04             	mov    %edx,0x4(%eax)
  802957:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80295a:	8b 00                	mov    (%eax),%eax
  80295c:	85 c0                	test   %eax,%eax
  80295e:	75 08                	jne    802968 <insert_sorted_allocList+0x1a6>
  802960:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802963:	a3 44 50 80 00       	mov    %eax,0x805044
  802968:	a1 4c 50 80 00       	mov    0x80504c,%eax
  80296d:	40                   	inc    %eax
  80296e:	a3 4c 50 80 00       	mov    %eax,0x80504c
				break;
  802973:	eb 38                	jmp    8029ad <insert_sorted_allocList+0x1eb>
	{
		LIST_INSERT_TAIL(&AllocMemBlocksList, newblk);
	}
	else
	{
		LIST_FOREACH(blk, &AllocMemBlocksList)
  802975:	a1 48 50 80 00       	mov    0x805048,%eax
  80297a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80297d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802981:	74 07                	je     80298a <insert_sorted_allocList+0x1c8>
  802983:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802986:	8b 00                	mov    (%eax),%eax
  802988:	eb 05                	jmp    80298f <insert_sorted_allocList+0x1cd>
  80298a:	b8 00 00 00 00       	mov    $0x0,%eax
  80298f:	a3 48 50 80 00       	mov    %eax,0x805048
  802994:	a1 48 50 80 00       	mov    0x805048,%eax
  802999:	85 c0                	test   %eax,%eax
  80299b:	0f 85 31 ff ff ff    	jne    8028d2 <insert_sorted_allocList+0x110>
  8029a1:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8029a5:	0f 85 27 ff ff ff    	jne    8028d2 <insert_sorted_allocList+0x110>
				LIST_INSERT_AFTER(&AllocMemBlocksList, blk, newblk);
				break;
			}
		}
	}
}
  8029ab:	eb 00                	jmp    8029ad <insert_sorted_allocList+0x1eb>
  8029ad:	90                   	nop
  8029ae:	c9                   	leave  
  8029af:	c3                   	ret    

008029b0 <alloc_block_FF>:

//=========================================
// [4] ALLOCATE BLOCK BY FIRST FIT:
//=========================================
struct MemBlock *alloc_block_FF(uint32 size)
{
  8029b0:	55                   	push   %ebp
  8029b1:	89 e5                	mov    %esp,%ebp
  8029b3:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_FF
	// Write your code here, remove the panic and write your code
	//panic("alloc_block_FF() is not implemented yet...!!");
	uint32 versize = size;
  8029b6:	8b 45 08             	mov    0x8(%ebp),%eax
  8029b9:	89 45 f0             	mov    %eax,-0x10(%ebp)
	struct MemBlock* blk;
	struct MemBlock* newblk = LIST_FIRST(&AvailableMemBlocksList);
  8029bc:	a1 48 51 80 00       	mov    0x805148,%eax
  8029c1:	89 45 ec             	mov    %eax,-0x14(%ebp)

	LIST_FOREACH(blk,&FreeMemBlocksList)
  8029c4:	a1 38 51 80 00       	mov    0x805138,%eax
  8029c9:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8029cc:	e9 77 01 00 00       	jmp    802b48 <alloc_block_FF+0x198>
	{
		if(blk->size == versize)
  8029d1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029d4:	8b 40 0c             	mov    0xc(%eax),%eax
  8029d7:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8029da:	0f 85 8a 00 00 00    	jne    802a6a <alloc_block_FF+0xba>
		{
			LIST_REMOVE(&FreeMemBlocksList,blk);
  8029e0:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8029e4:	75 17                	jne    8029fd <alloc_block_FF+0x4d>
  8029e6:	83 ec 04             	sub    $0x4,%esp
  8029e9:	68 e8 40 80 00       	push   $0x8040e8
  8029ee:	68 9e 00 00 00       	push   $0x9e
  8029f3:	68 77 40 80 00       	push   $0x804077
  8029f8:	e8 0f df ff ff       	call   80090c <_panic>
  8029fd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a00:	8b 00                	mov    (%eax),%eax
  802a02:	85 c0                	test   %eax,%eax
  802a04:	74 10                	je     802a16 <alloc_block_FF+0x66>
  802a06:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a09:	8b 00                	mov    (%eax),%eax
  802a0b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802a0e:	8b 52 04             	mov    0x4(%edx),%edx
  802a11:	89 50 04             	mov    %edx,0x4(%eax)
  802a14:	eb 0b                	jmp    802a21 <alloc_block_FF+0x71>
  802a16:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a19:	8b 40 04             	mov    0x4(%eax),%eax
  802a1c:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802a21:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a24:	8b 40 04             	mov    0x4(%eax),%eax
  802a27:	85 c0                	test   %eax,%eax
  802a29:	74 0f                	je     802a3a <alloc_block_FF+0x8a>
  802a2b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a2e:	8b 40 04             	mov    0x4(%eax),%eax
  802a31:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802a34:	8b 12                	mov    (%edx),%edx
  802a36:	89 10                	mov    %edx,(%eax)
  802a38:	eb 0a                	jmp    802a44 <alloc_block_FF+0x94>
  802a3a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a3d:	8b 00                	mov    (%eax),%eax
  802a3f:	a3 38 51 80 00       	mov    %eax,0x805138
  802a44:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a47:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802a4d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a50:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802a57:	a1 44 51 80 00       	mov    0x805144,%eax
  802a5c:	48                   	dec    %eax
  802a5d:	a3 44 51 80 00       	mov    %eax,0x805144
			return blk;
  802a62:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a65:	e9 11 01 00 00       	jmp    802b7b <alloc_block_FF+0x1cb>
		}
		else if(blk->size > versize)
  802a6a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a6d:	8b 40 0c             	mov    0xc(%eax),%eax
  802a70:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  802a73:	0f 86 c7 00 00 00    	jbe    802b40 <alloc_block_FF+0x190>
		{
			LIST_REMOVE(&AvailableMemBlocksList,newblk);
  802a79:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802a7d:	75 17                	jne    802a96 <alloc_block_FF+0xe6>
  802a7f:	83 ec 04             	sub    $0x4,%esp
  802a82:	68 e8 40 80 00       	push   $0x8040e8
  802a87:	68 a3 00 00 00       	push   $0xa3
  802a8c:	68 77 40 80 00       	push   $0x804077
  802a91:	e8 76 de ff ff       	call   80090c <_panic>
  802a96:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802a99:	8b 00                	mov    (%eax),%eax
  802a9b:	85 c0                	test   %eax,%eax
  802a9d:	74 10                	je     802aaf <alloc_block_FF+0xff>
  802a9f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802aa2:	8b 00                	mov    (%eax),%eax
  802aa4:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802aa7:	8b 52 04             	mov    0x4(%edx),%edx
  802aaa:	89 50 04             	mov    %edx,0x4(%eax)
  802aad:	eb 0b                	jmp    802aba <alloc_block_FF+0x10a>
  802aaf:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802ab2:	8b 40 04             	mov    0x4(%eax),%eax
  802ab5:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802aba:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802abd:	8b 40 04             	mov    0x4(%eax),%eax
  802ac0:	85 c0                	test   %eax,%eax
  802ac2:	74 0f                	je     802ad3 <alloc_block_FF+0x123>
  802ac4:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802ac7:	8b 40 04             	mov    0x4(%eax),%eax
  802aca:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802acd:	8b 12                	mov    (%edx),%edx
  802acf:	89 10                	mov    %edx,(%eax)
  802ad1:	eb 0a                	jmp    802add <alloc_block_FF+0x12d>
  802ad3:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802ad6:	8b 00                	mov    (%eax),%eax
  802ad8:	a3 48 51 80 00       	mov    %eax,0x805148
  802add:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802ae0:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802ae6:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802ae9:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802af0:	a1 54 51 80 00       	mov    0x805154,%eax
  802af5:	48                   	dec    %eax
  802af6:	a3 54 51 80 00       	mov    %eax,0x805154
			newblk->size = versize;
  802afb:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802afe:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802b01:	89 50 0c             	mov    %edx,0xc(%eax)
			blk->size = blk->size-versize;
  802b04:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b07:	8b 40 0c             	mov    0xc(%eax),%eax
  802b0a:	2b 45 f0             	sub    -0x10(%ebp),%eax
  802b0d:	89 c2                	mov    %eax,%edx
  802b0f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b12:	89 50 0c             	mov    %edx,0xc(%eax)
			uint32 newveradd = blk->sva;
  802b15:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b18:	8b 40 08             	mov    0x8(%eax),%eax
  802b1b:	89 45 e8             	mov    %eax,-0x18(%ebp)
			blk->sva+=newblk->size;
  802b1e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b21:	8b 50 08             	mov    0x8(%eax),%edx
  802b24:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802b27:	8b 40 0c             	mov    0xc(%eax),%eax
  802b2a:	01 c2                	add    %eax,%edx
  802b2c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b2f:	89 50 08             	mov    %edx,0x8(%eax)
			newblk->sva = newveradd;
  802b32:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802b35:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802b38:	89 50 08             	mov    %edx,0x8(%eax)
			return newblk;
  802b3b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802b3e:	eb 3b                	jmp    802b7b <alloc_block_FF+0x1cb>
	//panic("alloc_block_FF() is not implemented yet...!!");
	uint32 versize = size;
	struct MemBlock* blk;
	struct MemBlock* newblk = LIST_FIRST(&AvailableMemBlocksList);

	LIST_FOREACH(blk,&FreeMemBlocksList)
  802b40:	a1 40 51 80 00       	mov    0x805140,%eax
  802b45:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802b48:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802b4c:	74 07                	je     802b55 <alloc_block_FF+0x1a5>
  802b4e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b51:	8b 00                	mov    (%eax),%eax
  802b53:	eb 05                	jmp    802b5a <alloc_block_FF+0x1aa>
  802b55:	b8 00 00 00 00       	mov    $0x0,%eax
  802b5a:	a3 40 51 80 00       	mov    %eax,0x805140
  802b5f:	a1 40 51 80 00       	mov    0x805140,%eax
  802b64:	85 c0                	test   %eax,%eax
  802b66:	0f 85 65 fe ff ff    	jne    8029d1 <alloc_block_FF+0x21>
  802b6c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802b70:	0f 85 5b fe ff ff    	jne    8029d1 <alloc_block_FF+0x21>
			blk->sva+=newblk->size;
			newblk->sva = newveradd;
			return newblk;
		}
	}
	return NULL;
  802b76:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802b7b:	c9                   	leave  
  802b7c:	c3                   	ret    

00802b7d <alloc_block_BF>:

//=========================================
// [5] ALLOCATE BLOCK BY BEST FIT:
//=========================================
struct MemBlock *alloc_block_BF(uint32 size)
{
  802b7d:	55                   	push   %ebp
  802b7e:	89 e5                	mov    %esp,%ebp
  802b80:	83 ec 28             	sub    $0x28,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_BF
	// Write your code here, remove the panic and write your code
	//panic("alloc_block_BF() is not implemented yet...!!");
	uint32 versize=size;
  802b83:	8b 45 08             	mov    0x8(%ebp),%eax
  802b86:	89 45 e8             	mov    %eax,-0x18(%ebp)
	struct MemBlock* blk;
	struct MemBlock* newblk=LIST_FIRST(&AvailableMemBlocksList);
  802b89:	a1 48 51 80 00       	mov    0x805148,%eax
  802b8e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	uint32 newveradd;
	uint32 newsize;
	int size_free = LIST_SIZE(&FreeMemBlocksList);
  802b91:	a1 44 51 80 00       	mov    0x805144,%eax
  802b96:	89 45 e0             	mov    %eax,-0x20(%ebp)

	LIST_FOREACH(blk, &FreeMemBlocksList)
  802b99:	a1 38 51 80 00       	mov    0x805138,%eax
  802b9e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802ba1:	e9 a1 00 00 00       	jmp    802c47 <alloc_block_BF+0xca>
	{
		if(blk->size == versize)
  802ba6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ba9:	8b 40 0c             	mov    0xc(%eax),%eax
  802bac:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  802baf:	0f 85 8a 00 00 00    	jne    802c3f <alloc_block_BF+0xc2>
		{
			LIST_REMOVE(&FreeMemBlocksList, blk);
  802bb5:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802bb9:	75 17                	jne    802bd2 <alloc_block_BF+0x55>
  802bbb:	83 ec 04             	sub    $0x4,%esp
  802bbe:	68 e8 40 80 00       	push   $0x8040e8
  802bc3:	68 c2 00 00 00       	push   $0xc2
  802bc8:	68 77 40 80 00       	push   $0x804077
  802bcd:	e8 3a dd ff ff       	call   80090c <_panic>
  802bd2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bd5:	8b 00                	mov    (%eax),%eax
  802bd7:	85 c0                	test   %eax,%eax
  802bd9:	74 10                	je     802beb <alloc_block_BF+0x6e>
  802bdb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bde:	8b 00                	mov    (%eax),%eax
  802be0:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802be3:	8b 52 04             	mov    0x4(%edx),%edx
  802be6:	89 50 04             	mov    %edx,0x4(%eax)
  802be9:	eb 0b                	jmp    802bf6 <alloc_block_BF+0x79>
  802beb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bee:	8b 40 04             	mov    0x4(%eax),%eax
  802bf1:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802bf6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bf9:	8b 40 04             	mov    0x4(%eax),%eax
  802bfc:	85 c0                	test   %eax,%eax
  802bfe:	74 0f                	je     802c0f <alloc_block_BF+0x92>
  802c00:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c03:	8b 40 04             	mov    0x4(%eax),%eax
  802c06:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802c09:	8b 12                	mov    (%edx),%edx
  802c0b:	89 10                	mov    %edx,(%eax)
  802c0d:	eb 0a                	jmp    802c19 <alloc_block_BF+0x9c>
  802c0f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c12:	8b 00                	mov    (%eax),%eax
  802c14:	a3 38 51 80 00       	mov    %eax,0x805138
  802c19:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c1c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802c22:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c25:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802c2c:	a1 44 51 80 00       	mov    0x805144,%eax
  802c31:	48                   	dec    %eax
  802c32:	a3 44 51 80 00       	mov    %eax,0x805144
			return blk;
  802c37:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c3a:	e9 11 02 00 00       	jmp    802e50 <alloc_block_BF+0x2d3>
	struct MemBlock* newblk=LIST_FIRST(&AvailableMemBlocksList);
	uint32 newveradd;
	uint32 newsize;
	int size_free = LIST_SIZE(&FreeMemBlocksList);

	LIST_FOREACH(blk, &FreeMemBlocksList)
  802c3f:	a1 40 51 80 00       	mov    0x805140,%eax
  802c44:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802c47:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802c4b:	74 07                	je     802c54 <alloc_block_BF+0xd7>
  802c4d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c50:	8b 00                	mov    (%eax),%eax
  802c52:	eb 05                	jmp    802c59 <alloc_block_BF+0xdc>
  802c54:	b8 00 00 00 00       	mov    $0x0,%eax
  802c59:	a3 40 51 80 00       	mov    %eax,0x805140
  802c5e:	a1 40 51 80 00       	mov    0x805140,%eax
  802c63:	85 c0                	test   %eax,%eax
  802c65:	0f 85 3b ff ff ff    	jne    802ba6 <alloc_block_BF+0x29>
  802c6b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802c6f:	0f 85 31 ff ff ff    	jne    802ba6 <alloc_block_BF+0x29>
		{
			LIST_REMOVE(&FreeMemBlocksList, blk);
			return blk;
		}
	}
	LIST_FOREACH(blk, &FreeMemBlocksList)
  802c75:	a1 38 51 80 00       	mov    0x805138,%eax
  802c7a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802c7d:	eb 27                	jmp    802ca6 <alloc_block_BF+0x129>
	{
		if(blk->size > versize)
  802c7f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c82:	8b 40 0c             	mov    0xc(%eax),%eax
  802c85:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  802c88:	76 14                	jbe    802c9e <alloc_block_BF+0x121>
		{
			newsize = blk->size;
  802c8a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c8d:	8b 40 0c             	mov    0xc(%eax),%eax
  802c90:	89 45 ec             	mov    %eax,-0x14(%ebp)
			newveradd = blk->sva;
  802c93:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c96:	8b 40 08             	mov    0x8(%eax),%eax
  802c99:	89 45 f0             	mov    %eax,-0x10(%ebp)
			break;
  802c9c:	eb 2e                	jmp    802ccc <alloc_block_BF+0x14f>
		{
			LIST_REMOVE(&FreeMemBlocksList, blk);
			return blk;
		}
	}
	LIST_FOREACH(blk, &FreeMemBlocksList)
  802c9e:	a1 40 51 80 00       	mov    0x805140,%eax
  802ca3:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802ca6:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802caa:	74 07                	je     802cb3 <alloc_block_BF+0x136>
  802cac:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802caf:	8b 00                	mov    (%eax),%eax
  802cb1:	eb 05                	jmp    802cb8 <alloc_block_BF+0x13b>
  802cb3:	b8 00 00 00 00       	mov    $0x0,%eax
  802cb8:	a3 40 51 80 00       	mov    %eax,0x805140
  802cbd:	a1 40 51 80 00       	mov    0x805140,%eax
  802cc2:	85 c0                	test   %eax,%eax
  802cc4:	75 b9                	jne    802c7f <alloc_block_BF+0x102>
  802cc6:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802cca:	75 b3                	jne    802c7f <alloc_block_BF+0x102>
			newsize = blk->size;
			newveradd = blk->sva;
			break;
		}
	}
	LIST_FOREACH(blk, &FreeMemBlocksList)
  802ccc:	a1 38 51 80 00       	mov    0x805138,%eax
  802cd1:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802cd4:	eb 30                	jmp    802d06 <alloc_block_BF+0x189>
	{
		if(newsize > blk->size && blk->size > versize)
  802cd6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cd9:	8b 40 0c             	mov    0xc(%eax),%eax
  802cdc:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  802cdf:	73 1d                	jae    802cfe <alloc_block_BF+0x181>
  802ce1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ce4:	8b 40 0c             	mov    0xc(%eax),%eax
  802ce7:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  802cea:	76 12                	jbe    802cfe <alloc_block_BF+0x181>
		{
	       newsize = blk->size;
  802cec:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cef:	8b 40 0c             	mov    0xc(%eax),%eax
  802cf2:	89 45 ec             	mov    %eax,-0x14(%ebp)
		   newveradd = blk->sva;
  802cf5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cf8:	8b 40 08             	mov    0x8(%eax),%eax
  802cfb:	89 45 f0             	mov    %eax,-0x10(%ebp)
			newsize = blk->size;
			newveradd = blk->sva;
			break;
		}
	}
	LIST_FOREACH(blk, &FreeMemBlocksList)
  802cfe:	a1 40 51 80 00       	mov    0x805140,%eax
  802d03:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802d06:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802d0a:	74 07                	je     802d13 <alloc_block_BF+0x196>
  802d0c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d0f:	8b 00                	mov    (%eax),%eax
  802d11:	eb 05                	jmp    802d18 <alloc_block_BF+0x19b>
  802d13:	b8 00 00 00 00       	mov    $0x0,%eax
  802d18:	a3 40 51 80 00       	mov    %eax,0x805140
  802d1d:	a1 40 51 80 00       	mov    0x805140,%eax
  802d22:	85 c0                	test   %eax,%eax
  802d24:	75 b0                	jne    802cd6 <alloc_block_BF+0x159>
  802d26:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802d2a:	75 aa                	jne    802cd6 <alloc_block_BF+0x159>
		{
	       newsize = blk->size;
		   newveradd = blk->sva;
		}
	}
	LIST_FOREACH(blk, &FreeMemBlocksList)
  802d2c:	a1 38 51 80 00       	mov    0x805138,%eax
  802d31:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802d34:	e9 e4 00 00 00       	jmp    802e1d <alloc_block_BF+0x2a0>
	{
		if(blk->size == newsize && blk->sva == newveradd)
  802d39:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d3c:	8b 40 0c             	mov    0xc(%eax),%eax
  802d3f:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  802d42:	0f 85 cd 00 00 00    	jne    802e15 <alloc_block_BF+0x298>
  802d48:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d4b:	8b 40 08             	mov    0x8(%eax),%eax
  802d4e:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  802d51:	0f 85 be 00 00 00    	jne    802e15 <alloc_block_BF+0x298>
		{
			LIST_REMOVE(&AvailableMemBlocksList, newblk);
  802d57:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  802d5b:	75 17                	jne    802d74 <alloc_block_BF+0x1f7>
  802d5d:	83 ec 04             	sub    $0x4,%esp
  802d60:	68 e8 40 80 00       	push   $0x8040e8
  802d65:	68 db 00 00 00       	push   $0xdb
  802d6a:	68 77 40 80 00       	push   $0x804077
  802d6f:	e8 98 db ff ff       	call   80090c <_panic>
  802d74:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802d77:	8b 00                	mov    (%eax),%eax
  802d79:	85 c0                	test   %eax,%eax
  802d7b:	74 10                	je     802d8d <alloc_block_BF+0x210>
  802d7d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802d80:	8b 00                	mov    (%eax),%eax
  802d82:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802d85:	8b 52 04             	mov    0x4(%edx),%edx
  802d88:	89 50 04             	mov    %edx,0x4(%eax)
  802d8b:	eb 0b                	jmp    802d98 <alloc_block_BF+0x21b>
  802d8d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802d90:	8b 40 04             	mov    0x4(%eax),%eax
  802d93:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802d98:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802d9b:	8b 40 04             	mov    0x4(%eax),%eax
  802d9e:	85 c0                	test   %eax,%eax
  802da0:	74 0f                	je     802db1 <alloc_block_BF+0x234>
  802da2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802da5:	8b 40 04             	mov    0x4(%eax),%eax
  802da8:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802dab:	8b 12                	mov    (%edx),%edx
  802dad:	89 10                	mov    %edx,(%eax)
  802daf:	eb 0a                	jmp    802dbb <alloc_block_BF+0x23e>
  802db1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802db4:	8b 00                	mov    (%eax),%eax
  802db6:	a3 48 51 80 00       	mov    %eax,0x805148
  802dbb:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802dbe:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802dc4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802dc7:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802dce:	a1 54 51 80 00       	mov    0x805154,%eax
  802dd3:	48                   	dec    %eax
  802dd4:	a3 54 51 80 00       	mov    %eax,0x805154
			newblk->size = versize;
  802dd9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802ddc:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802ddf:	89 50 0c             	mov    %edx,0xc(%eax)
			newblk->sva = newveradd;
  802de2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802de5:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802de8:	89 50 08             	mov    %edx,0x8(%eax)
			blk->size = blk->size - versize;
  802deb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802dee:	8b 40 0c             	mov    0xc(%eax),%eax
  802df1:	2b 45 e8             	sub    -0x18(%ebp),%eax
  802df4:	89 c2                	mov    %eax,%edx
  802df6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802df9:	89 50 0c             	mov    %edx,0xc(%eax)
			blk->sva+= newblk->size;
  802dfc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802dff:	8b 50 08             	mov    0x8(%eax),%edx
  802e02:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802e05:	8b 40 0c             	mov    0xc(%eax),%eax
  802e08:	01 c2                	add    %eax,%edx
  802e0a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e0d:	89 50 08             	mov    %edx,0x8(%eax)
			return newblk;
  802e10:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802e13:	eb 3b                	jmp    802e50 <alloc_block_BF+0x2d3>
		{
	       newsize = blk->size;
		   newveradd = blk->sva;
		}
	}
	LIST_FOREACH(blk, &FreeMemBlocksList)
  802e15:	a1 40 51 80 00       	mov    0x805140,%eax
  802e1a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802e1d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802e21:	74 07                	je     802e2a <alloc_block_BF+0x2ad>
  802e23:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e26:	8b 00                	mov    (%eax),%eax
  802e28:	eb 05                	jmp    802e2f <alloc_block_BF+0x2b2>
  802e2a:	b8 00 00 00 00       	mov    $0x0,%eax
  802e2f:	a3 40 51 80 00       	mov    %eax,0x805140
  802e34:	a1 40 51 80 00       	mov    0x805140,%eax
  802e39:	85 c0                	test   %eax,%eax
  802e3b:	0f 85 f8 fe ff ff    	jne    802d39 <alloc_block_BF+0x1bc>
  802e41:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802e45:	0f 85 ee fe ff ff    	jne    802d39 <alloc_block_BF+0x1bc>
			blk->size = blk->size - versize;
			blk->sva+= newblk->size;
			return newblk;
		}
	}
	return NULL;
  802e4b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802e50:	c9                   	leave  
  802e51:	c3                   	ret    

00802e52 <alloc_block_NF>:
//=========================================
// [7] ALLOCATE BLOCK BY NEXT FIT:
//=========================================
struct MemBlock *last_allocate;
struct MemBlock *alloc_block_NF(uint32 size)
{
  802e52:	55                   	push   %ebp
  802e53:	89 e5                	mov    %esp,%ebp
  802e55:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1 - BONUS] [DYNAMIC ALLOCATOR] alloc_block_NF
	// Write your code here, remove the panic and write your code
	//panic("alloc_block_NF() is not implemented yet...!!");
	uint32 versize = size;
  802e58:	8b 45 08             	mov    0x8(%ebp),%eax
  802e5b:	89 45 f0             	mov    %eax,-0x10(%ebp)
	struct MemBlock* blk;
	struct MemBlock* newblk = LIST_FIRST(&AvailableMemBlocksList);
  802e5e:	a1 48 51 80 00       	mov    0x805148,%eax
  802e63:	89 45 ec             	mov    %eax,-0x14(%ebp)

	LIST_FOREACH(blk,&FreeMemBlocksList)
  802e66:	a1 38 51 80 00       	mov    0x805138,%eax
  802e6b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802e6e:	e9 77 01 00 00       	jmp    802fea <alloc_block_NF+0x198>
	{
		if(blk->size == versize)
  802e73:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e76:	8b 40 0c             	mov    0xc(%eax),%eax
  802e79:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  802e7c:	0f 85 8a 00 00 00    	jne    802f0c <alloc_block_NF+0xba>
		{
			LIST_REMOVE(&FreeMemBlocksList,blk);
  802e82:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802e86:	75 17                	jne    802e9f <alloc_block_NF+0x4d>
  802e88:	83 ec 04             	sub    $0x4,%esp
  802e8b:	68 e8 40 80 00       	push   $0x8040e8
  802e90:	68 f7 00 00 00       	push   $0xf7
  802e95:	68 77 40 80 00       	push   $0x804077
  802e9a:	e8 6d da ff ff       	call   80090c <_panic>
  802e9f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ea2:	8b 00                	mov    (%eax),%eax
  802ea4:	85 c0                	test   %eax,%eax
  802ea6:	74 10                	je     802eb8 <alloc_block_NF+0x66>
  802ea8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802eab:	8b 00                	mov    (%eax),%eax
  802ead:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802eb0:	8b 52 04             	mov    0x4(%edx),%edx
  802eb3:	89 50 04             	mov    %edx,0x4(%eax)
  802eb6:	eb 0b                	jmp    802ec3 <alloc_block_NF+0x71>
  802eb8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ebb:	8b 40 04             	mov    0x4(%eax),%eax
  802ebe:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802ec3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ec6:	8b 40 04             	mov    0x4(%eax),%eax
  802ec9:	85 c0                	test   %eax,%eax
  802ecb:	74 0f                	je     802edc <alloc_block_NF+0x8a>
  802ecd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ed0:	8b 40 04             	mov    0x4(%eax),%eax
  802ed3:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802ed6:	8b 12                	mov    (%edx),%edx
  802ed8:	89 10                	mov    %edx,(%eax)
  802eda:	eb 0a                	jmp    802ee6 <alloc_block_NF+0x94>
  802edc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802edf:	8b 00                	mov    (%eax),%eax
  802ee1:	a3 38 51 80 00       	mov    %eax,0x805138
  802ee6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ee9:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802eef:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ef2:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802ef9:	a1 44 51 80 00       	mov    0x805144,%eax
  802efe:	48                   	dec    %eax
  802eff:	a3 44 51 80 00       	mov    %eax,0x805144
			return blk;
  802f04:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f07:	e9 11 01 00 00       	jmp    80301d <alloc_block_NF+0x1cb>
		}
		else if(blk->size > versize)
  802f0c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f0f:	8b 40 0c             	mov    0xc(%eax),%eax
  802f12:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  802f15:	0f 86 c7 00 00 00    	jbe    802fe2 <alloc_block_NF+0x190>
		{
			LIST_REMOVE(&AvailableMemBlocksList,newblk);
  802f1b:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802f1f:	75 17                	jne    802f38 <alloc_block_NF+0xe6>
  802f21:	83 ec 04             	sub    $0x4,%esp
  802f24:	68 e8 40 80 00       	push   $0x8040e8
  802f29:	68 fc 00 00 00       	push   $0xfc
  802f2e:	68 77 40 80 00       	push   $0x804077
  802f33:	e8 d4 d9 ff ff       	call   80090c <_panic>
  802f38:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802f3b:	8b 00                	mov    (%eax),%eax
  802f3d:	85 c0                	test   %eax,%eax
  802f3f:	74 10                	je     802f51 <alloc_block_NF+0xff>
  802f41:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802f44:	8b 00                	mov    (%eax),%eax
  802f46:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802f49:	8b 52 04             	mov    0x4(%edx),%edx
  802f4c:	89 50 04             	mov    %edx,0x4(%eax)
  802f4f:	eb 0b                	jmp    802f5c <alloc_block_NF+0x10a>
  802f51:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802f54:	8b 40 04             	mov    0x4(%eax),%eax
  802f57:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802f5c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802f5f:	8b 40 04             	mov    0x4(%eax),%eax
  802f62:	85 c0                	test   %eax,%eax
  802f64:	74 0f                	je     802f75 <alloc_block_NF+0x123>
  802f66:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802f69:	8b 40 04             	mov    0x4(%eax),%eax
  802f6c:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802f6f:	8b 12                	mov    (%edx),%edx
  802f71:	89 10                	mov    %edx,(%eax)
  802f73:	eb 0a                	jmp    802f7f <alloc_block_NF+0x12d>
  802f75:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802f78:	8b 00                	mov    (%eax),%eax
  802f7a:	a3 48 51 80 00       	mov    %eax,0x805148
  802f7f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802f82:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802f88:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802f8b:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802f92:	a1 54 51 80 00       	mov    0x805154,%eax
  802f97:	48                   	dec    %eax
  802f98:	a3 54 51 80 00       	mov    %eax,0x805154
			newblk->size = versize;
  802f9d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802fa0:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802fa3:	89 50 0c             	mov    %edx,0xc(%eax)
			blk->size = blk->size-versize;
  802fa6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802fa9:	8b 40 0c             	mov    0xc(%eax),%eax
  802fac:	2b 45 f0             	sub    -0x10(%ebp),%eax
  802faf:	89 c2                	mov    %eax,%edx
  802fb1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802fb4:	89 50 0c             	mov    %edx,0xc(%eax)
			uint32 newveradd = blk->sva;
  802fb7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802fba:	8b 40 08             	mov    0x8(%eax),%eax
  802fbd:	89 45 e8             	mov    %eax,-0x18(%ebp)
			blk->sva+=newblk->size;
  802fc0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802fc3:	8b 50 08             	mov    0x8(%eax),%edx
  802fc6:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802fc9:	8b 40 0c             	mov    0xc(%eax),%eax
  802fcc:	01 c2                	add    %eax,%edx
  802fce:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802fd1:	89 50 08             	mov    %edx,0x8(%eax)
			newblk->sva = newveradd;
  802fd4:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802fd7:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802fda:	89 50 08             	mov    %edx,0x8(%eax)
			return newblk;
  802fdd:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802fe0:	eb 3b                	jmp    80301d <alloc_block_NF+0x1cb>
	//panic("alloc_block_NF() is not implemented yet...!!");
	uint32 versize = size;
	struct MemBlock* blk;
	struct MemBlock* newblk = LIST_FIRST(&AvailableMemBlocksList);

	LIST_FOREACH(blk,&FreeMemBlocksList)
  802fe2:	a1 40 51 80 00       	mov    0x805140,%eax
  802fe7:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802fea:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802fee:	74 07                	je     802ff7 <alloc_block_NF+0x1a5>
  802ff0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ff3:	8b 00                	mov    (%eax),%eax
  802ff5:	eb 05                	jmp    802ffc <alloc_block_NF+0x1aa>
  802ff7:	b8 00 00 00 00       	mov    $0x0,%eax
  802ffc:	a3 40 51 80 00       	mov    %eax,0x805140
  803001:	a1 40 51 80 00       	mov    0x805140,%eax
  803006:	85 c0                	test   %eax,%eax
  803008:	0f 85 65 fe ff ff    	jne    802e73 <alloc_block_NF+0x21>
  80300e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803012:	0f 85 5b fe ff ff    	jne    802e73 <alloc_block_NF+0x21>
			blk->sva+=newblk->size;
			newblk->sva = newveradd;
			return newblk;
		}
	}
	return NULL;
  803018:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80301d:	c9                   	leave  
  80301e:	c3                   	ret    

0080301f <addToAvailMemBlocksList>:

//===================================================
// [8] INSERT BLOCK (SORTED WITH MERGE) IN FREE LIST:
//===================================================
void addToAvailMemBlocksList(struct MemBlock *blockToInsert)
{
  80301f:	55                   	push   %ebp
  803020:	89 e5                	mov    %esp,%ebp
  803022:	83 ec 08             	sub    $0x8,%esp
	blockToInsert->sva = 0;
  803025:	8b 45 08             	mov    0x8(%ebp),%eax
  803028:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
	blockToInsert->size = 0;
  80302f:	8b 45 08             	mov    0x8(%ebp),%eax
  803032:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
	//add to avail
	LIST_INSERT_TAIL(&AvailableMemBlocksList, blockToInsert);
  803039:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80303d:	75 17                	jne    803056 <addToAvailMemBlocksList+0x37>
  80303f:	83 ec 04             	sub    $0x4,%esp
  803042:	68 90 40 80 00       	push   $0x804090
  803047:	68 10 01 00 00       	push   $0x110
  80304c:	68 77 40 80 00       	push   $0x804077
  803051:	e8 b6 d8 ff ff       	call   80090c <_panic>
  803056:	8b 15 4c 51 80 00    	mov    0x80514c,%edx
  80305c:	8b 45 08             	mov    0x8(%ebp),%eax
  80305f:	89 50 04             	mov    %edx,0x4(%eax)
  803062:	8b 45 08             	mov    0x8(%ebp),%eax
  803065:	8b 40 04             	mov    0x4(%eax),%eax
  803068:	85 c0                	test   %eax,%eax
  80306a:	74 0c                	je     803078 <addToAvailMemBlocksList+0x59>
  80306c:	a1 4c 51 80 00       	mov    0x80514c,%eax
  803071:	8b 55 08             	mov    0x8(%ebp),%edx
  803074:	89 10                	mov    %edx,(%eax)
  803076:	eb 08                	jmp    803080 <addToAvailMemBlocksList+0x61>
  803078:	8b 45 08             	mov    0x8(%ebp),%eax
  80307b:	a3 48 51 80 00       	mov    %eax,0x805148
  803080:	8b 45 08             	mov    0x8(%ebp),%eax
  803083:	a3 4c 51 80 00       	mov    %eax,0x80514c
  803088:	8b 45 08             	mov    0x8(%ebp),%eax
  80308b:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803091:	a1 54 51 80 00       	mov    0x805154,%eax
  803096:	40                   	inc    %eax
  803097:	a3 54 51 80 00       	mov    %eax,0x805154
}
  80309c:	90                   	nop
  80309d:	c9                   	leave  
  80309e:	c3                   	ret    

0080309f <insert_sorted_with_merge_freeList>:
void insert_sorted_with_merge_freeList(struct MemBlock *blockToInsert)
{
  80309f:	55                   	push   %ebp
  8030a0:	89 e5                	mov    %esp,%ebp
  8030a2:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] insert_sorted_with_merge_freeList
	// Write your code here, remove the panic and write your code

	struct MemBlock* last = LIST_LAST(&FreeMemBlocksList);
  8030a5:	a1 3c 51 80 00       	mov    0x80513c,%eax
  8030aa:	89 45 f0             	mov    %eax,-0x10(%ebp)
	//check if list empty
	if (LIST_SIZE(&(FreeMemBlocksList)) == 0)
  8030ad:	a1 44 51 80 00       	mov    0x805144,%eax
  8030b2:	85 c0                	test   %eax,%eax
  8030b4:	75 68                	jne    80311e <insert_sorted_with_merge_freeList+0x7f>
		LIST_INSERT_HEAD(&FreeMemBlocksList, blockToInsert);
  8030b6:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8030ba:	75 17                	jne    8030d3 <insert_sorted_with_merge_freeList+0x34>
  8030bc:	83 ec 04             	sub    $0x4,%esp
  8030bf:	68 54 40 80 00       	push   $0x804054
  8030c4:	68 1a 01 00 00       	push   $0x11a
  8030c9:	68 77 40 80 00       	push   $0x804077
  8030ce:	e8 39 d8 ff ff       	call   80090c <_panic>
  8030d3:	8b 15 38 51 80 00    	mov    0x805138,%edx
  8030d9:	8b 45 08             	mov    0x8(%ebp),%eax
  8030dc:	89 10                	mov    %edx,(%eax)
  8030de:	8b 45 08             	mov    0x8(%ebp),%eax
  8030e1:	8b 00                	mov    (%eax),%eax
  8030e3:	85 c0                	test   %eax,%eax
  8030e5:	74 0d                	je     8030f4 <insert_sorted_with_merge_freeList+0x55>
  8030e7:	a1 38 51 80 00       	mov    0x805138,%eax
  8030ec:	8b 55 08             	mov    0x8(%ebp),%edx
  8030ef:	89 50 04             	mov    %edx,0x4(%eax)
  8030f2:	eb 08                	jmp    8030fc <insert_sorted_with_merge_freeList+0x5d>
  8030f4:	8b 45 08             	mov    0x8(%ebp),%eax
  8030f7:	a3 3c 51 80 00       	mov    %eax,0x80513c
  8030fc:	8b 45 08             	mov    0x8(%ebp),%eax
  8030ff:	a3 38 51 80 00       	mov    %eax,0x805138
  803104:	8b 45 08             	mov    0x8(%ebp),%eax
  803107:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80310e:	a1 44 51 80 00       	mov    0x805144,%eax
  803113:	40                   	inc    %eax
  803114:	a3 44 51 80 00       	mov    %eax,0x805144
		}
	}

	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  803119:	e9 c5 03 00 00       	jmp    8034e3 <insert_sorted_with_merge_freeList+0x444>
	struct MemBlock* last = LIST_LAST(&FreeMemBlocksList);
	//check if list empty
	if (LIST_SIZE(&(FreeMemBlocksList)) == 0)
		LIST_INSERT_HEAD(&FreeMemBlocksList, blockToInsert);
	//check if it's position is at last
	else if (last->sva < blockToInsert->sva) {
  80311e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803121:	8b 50 08             	mov    0x8(%eax),%edx
  803124:	8b 45 08             	mov    0x8(%ebp),%eax
  803127:	8b 40 08             	mov    0x8(%eax),%eax
  80312a:	39 c2                	cmp    %eax,%edx
  80312c:	0f 83 b2 00 00 00    	jae    8031e4 <insert_sorted_with_merge_freeList+0x145>

		//if i have to merge
		if (last->sva + last->size == blockToInsert->sva) {
  803132:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803135:	8b 50 08             	mov    0x8(%eax),%edx
  803138:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80313b:	8b 40 0c             	mov    0xc(%eax),%eax
  80313e:	01 c2                	add    %eax,%edx
  803140:	8b 45 08             	mov    0x8(%ebp),%eax
  803143:	8b 40 08             	mov    0x8(%eax),%eax
  803146:	39 c2                	cmp    %eax,%edx
  803148:	75 27                	jne    803171 <insert_sorted_with_merge_freeList+0xd2>
			last->size = last->size + blockToInsert->size;
  80314a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80314d:	8b 50 0c             	mov    0xc(%eax),%edx
  803150:	8b 45 08             	mov    0x8(%ebp),%eax
  803153:	8b 40 0c             	mov    0xc(%eax),%eax
  803156:	01 c2                	add    %eax,%edx
  803158:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80315b:	89 50 0c             	mov    %edx,0xc(%eax)
			addToAvailMemBlocksList(blockToInsert);
  80315e:	83 ec 0c             	sub    $0xc,%esp
  803161:	ff 75 08             	pushl  0x8(%ebp)
  803164:	e8 b6 fe ff ff       	call   80301f <addToAvailMemBlocksList>
  803169:	83 c4 10             	add    $0x10,%esp
		}
	}

	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  80316c:	e9 72 03 00 00       	jmp    8034e3 <insert_sorted_with_merge_freeList+0x444>
		if (last->sva + last->size == blockToInsert->sva) {
			last->size = last->size + blockToInsert->size;
			addToAvailMemBlocksList(blockToInsert);

		} else {
			LIST_INSERT_AFTER(&FreeMemBlocksList, last, blockToInsert);
  803171:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  803175:	74 06                	je     80317d <insert_sorted_with_merge_freeList+0xde>
  803177:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80317b:	75 17                	jne    803194 <insert_sorted_with_merge_freeList+0xf5>
  80317d:	83 ec 04             	sub    $0x4,%esp
  803180:	68 b4 40 80 00       	push   $0x8040b4
  803185:	68 24 01 00 00       	push   $0x124
  80318a:	68 77 40 80 00       	push   $0x804077
  80318f:	e8 78 d7 ff ff       	call   80090c <_panic>
  803194:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803197:	8b 10                	mov    (%eax),%edx
  803199:	8b 45 08             	mov    0x8(%ebp),%eax
  80319c:	89 10                	mov    %edx,(%eax)
  80319e:	8b 45 08             	mov    0x8(%ebp),%eax
  8031a1:	8b 00                	mov    (%eax),%eax
  8031a3:	85 c0                	test   %eax,%eax
  8031a5:	74 0b                	je     8031b2 <insert_sorted_with_merge_freeList+0x113>
  8031a7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8031aa:	8b 00                	mov    (%eax),%eax
  8031ac:	8b 55 08             	mov    0x8(%ebp),%edx
  8031af:	89 50 04             	mov    %edx,0x4(%eax)
  8031b2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8031b5:	8b 55 08             	mov    0x8(%ebp),%edx
  8031b8:	89 10                	mov    %edx,(%eax)
  8031ba:	8b 45 08             	mov    0x8(%ebp),%eax
  8031bd:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8031c0:	89 50 04             	mov    %edx,0x4(%eax)
  8031c3:	8b 45 08             	mov    0x8(%ebp),%eax
  8031c6:	8b 00                	mov    (%eax),%eax
  8031c8:	85 c0                	test   %eax,%eax
  8031ca:	75 08                	jne    8031d4 <insert_sorted_with_merge_freeList+0x135>
  8031cc:	8b 45 08             	mov    0x8(%ebp),%eax
  8031cf:	a3 3c 51 80 00       	mov    %eax,0x80513c
  8031d4:	a1 44 51 80 00       	mov    0x805144,%eax
  8031d9:	40                   	inc    %eax
  8031da:	a3 44 51 80 00       	mov    %eax,0x805144
		}
	}

	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  8031df:	e9 ff 02 00 00       	jmp    8034e3 <insert_sorted_with_merge_freeList+0x444>
		} else {
			LIST_INSERT_AFTER(&FreeMemBlocksList, last, blockToInsert);
		}
	} else {
		struct MemBlock *iterator;
		LIST_FOREACH(iterator, &(FreeMemBlocksList))
  8031e4:	a1 38 51 80 00       	mov    0x805138,%eax
  8031e9:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8031ec:	e9 c2 02 00 00       	jmp    8034b3 <insert_sorted_with_merge_freeList+0x414>
		{

			if (iterator->sva > blockToInsert->sva) {
  8031f1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8031f4:	8b 50 08             	mov    0x8(%eax),%edx
  8031f7:	8b 45 08             	mov    0x8(%ebp),%eax
  8031fa:	8b 40 08             	mov    0x8(%eax),%eax
  8031fd:	39 c2                	cmp    %eax,%edx
  8031ff:	0f 86 a6 02 00 00    	jbe    8034ab <insert_sorted_with_merge_freeList+0x40c>

				struct MemBlock* prev = LIST_PREV(iterator);
  803205:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803208:	8b 40 04             	mov    0x4(%eax),%eax
  80320b:	89 45 ec             	mov    %eax,-0x14(%ebp)
				if (prev == NULL) {
  80320e:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  803212:	0f 85 ba 00 00 00    	jne    8032d2 <insert_sorted_with_merge_freeList+0x233>
					//check merge
					if (blockToInsert->size + blockToInsert->sva
  803218:	8b 45 08             	mov    0x8(%ebp),%eax
  80321b:	8b 50 0c             	mov    0xc(%eax),%edx
  80321e:	8b 45 08             	mov    0x8(%ebp),%eax
  803221:	8b 40 08             	mov    0x8(%eax),%eax
  803224:	01 c2                	add    %eax,%edx
							== iterator->sva) {
  803226:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803229:	8b 40 08             	mov    0x8(%eax),%eax
			if (iterator->sva > blockToInsert->sva) {

				struct MemBlock* prev = LIST_PREV(iterator);
				if (prev == NULL) {
					//check merge
					if (blockToInsert->size + blockToInsert->sva
  80322c:	39 c2                	cmp    %eax,%edx
  80322e:	75 33                	jne    803263 <insert_sorted_with_merge_freeList+0x1c4>
							== iterator->sva) {
						iterator->sva = blockToInsert->sva;
  803230:	8b 45 08             	mov    0x8(%ebp),%eax
  803233:	8b 50 08             	mov    0x8(%eax),%edx
  803236:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803239:	89 50 08             	mov    %edx,0x8(%eax)
						iterator->size = iterator->size + blockToInsert->size;
  80323c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80323f:	8b 50 0c             	mov    0xc(%eax),%edx
  803242:	8b 45 08             	mov    0x8(%ebp),%eax
  803245:	8b 40 0c             	mov    0xc(%eax),%eax
  803248:	01 c2                	add    %eax,%edx
  80324a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80324d:	89 50 0c             	mov    %edx,0xc(%eax)
						addToAvailMemBlocksList(blockToInsert);
  803250:	83 ec 0c             	sub    $0xc,%esp
  803253:	ff 75 08             	pushl  0x8(%ebp)
  803256:	e8 c4 fd ff ff       	call   80301f <addToAvailMemBlocksList>
  80325b:	83 c4 10             	add    $0x10,%esp

					else {
						LIST_INSERT_BEFORE(&FreeMemBlocksList, iterator,
								blockToInsert);
					}
					break;
  80325e:	e9 80 02 00 00       	jmp    8034e3 <insert_sorted_with_merge_freeList+0x444>
						addToAvailMemBlocksList(blockToInsert);

					}

					else {
						LIST_INSERT_BEFORE(&FreeMemBlocksList, iterator,
  803263:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803267:	74 06                	je     80326f <insert_sorted_with_merge_freeList+0x1d0>
  803269:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80326d:	75 17                	jne    803286 <insert_sorted_with_merge_freeList+0x1e7>
  80326f:	83 ec 04             	sub    $0x4,%esp
  803272:	68 08 41 80 00       	push   $0x804108
  803277:	68 3a 01 00 00       	push   $0x13a
  80327c:	68 77 40 80 00       	push   $0x804077
  803281:	e8 86 d6 ff ff       	call   80090c <_panic>
  803286:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803289:	8b 50 04             	mov    0x4(%eax),%edx
  80328c:	8b 45 08             	mov    0x8(%ebp),%eax
  80328f:	89 50 04             	mov    %edx,0x4(%eax)
  803292:	8b 45 08             	mov    0x8(%ebp),%eax
  803295:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803298:	89 10                	mov    %edx,(%eax)
  80329a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80329d:	8b 40 04             	mov    0x4(%eax),%eax
  8032a0:	85 c0                	test   %eax,%eax
  8032a2:	74 0d                	je     8032b1 <insert_sorted_with_merge_freeList+0x212>
  8032a4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8032a7:	8b 40 04             	mov    0x4(%eax),%eax
  8032aa:	8b 55 08             	mov    0x8(%ebp),%edx
  8032ad:	89 10                	mov    %edx,(%eax)
  8032af:	eb 08                	jmp    8032b9 <insert_sorted_with_merge_freeList+0x21a>
  8032b1:	8b 45 08             	mov    0x8(%ebp),%eax
  8032b4:	a3 38 51 80 00       	mov    %eax,0x805138
  8032b9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8032bc:	8b 55 08             	mov    0x8(%ebp),%edx
  8032bf:	89 50 04             	mov    %edx,0x4(%eax)
  8032c2:	a1 44 51 80 00       	mov    0x805144,%eax
  8032c7:	40                   	inc    %eax
  8032c8:	a3 44 51 80 00       	mov    %eax,0x805144
								blockToInsert);
					}
					break;
  8032cd:	e9 11 02 00 00       	jmp    8034e3 <insert_sorted_with_merge_freeList+0x444>
				} else {
					//prev and next merge
					if (prev->sva + prev->size + blockToInsert->size
  8032d2:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8032d5:	8b 50 08             	mov    0x8(%eax),%edx
  8032d8:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8032db:	8b 40 0c             	mov    0xc(%eax),%eax
  8032de:	01 c2                	add    %eax,%edx
  8032e0:	8b 45 08             	mov    0x8(%ebp),%eax
  8032e3:	8b 40 0c             	mov    0xc(%eax),%eax
  8032e6:	01 c2                	add    %eax,%edx
							== iterator->sva) {
  8032e8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8032eb:	8b 40 08             	mov    0x8(%eax),%eax
								blockToInsert);
					}
					break;
				} else {
					//prev and next merge
					if (prev->sva + prev->size + blockToInsert->size
  8032ee:	39 c2                	cmp    %eax,%edx
  8032f0:	0f 85 bf 00 00 00    	jne    8033b5 <insert_sorted_with_merge_freeList+0x316>
							== iterator->sva) {
						prev->size = prev->size + blockToInsert->size
  8032f6:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8032f9:	8b 50 0c             	mov    0xc(%eax),%edx
  8032fc:	8b 45 08             	mov    0x8(%ebp),%eax
  8032ff:	8b 40 0c             	mov    0xc(%eax),%eax
  803302:	01 c2                	add    %eax,%edx
								+ iterator->size;
  803304:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803307:	8b 40 0c             	mov    0xc(%eax),%eax
  80330a:	01 c2                	add    %eax,%edx
					break;
				} else {
					//prev and next merge
					if (prev->sva + prev->size + blockToInsert->size
							== iterator->sva) {
						prev->size = prev->size + blockToInsert->size
  80330c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80330f:	89 50 0c             	mov    %edx,0xc(%eax)
								+ iterator->size;
						LIST_REMOVE(&FreeMemBlocksList, iterator);
  803312:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803316:	75 17                	jne    80332f <insert_sorted_with_merge_freeList+0x290>
  803318:	83 ec 04             	sub    $0x4,%esp
  80331b:	68 e8 40 80 00       	push   $0x8040e8
  803320:	68 43 01 00 00       	push   $0x143
  803325:	68 77 40 80 00       	push   $0x804077
  80332a:	e8 dd d5 ff ff       	call   80090c <_panic>
  80332f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803332:	8b 00                	mov    (%eax),%eax
  803334:	85 c0                	test   %eax,%eax
  803336:	74 10                	je     803348 <insert_sorted_with_merge_freeList+0x2a9>
  803338:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80333b:	8b 00                	mov    (%eax),%eax
  80333d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803340:	8b 52 04             	mov    0x4(%edx),%edx
  803343:	89 50 04             	mov    %edx,0x4(%eax)
  803346:	eb 0b                	jmp    803353 <insert_sorted_with_merge_freeList+0x2b4>
  803348:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80334b:	8b 40 04             	mov    0x4(%eax),%eax
  80334e:	a3 3c 51 80 00       	mov    %eax,0x80513c
  803353:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803356:	8b 40 04             	mov    0x4(%eax),%eax
  803359:	85 c0                	test   %eax,%eax
  80335b:	74 0f                	je     80336c <insert_sorted_with_merge_freeList+0x2cd>
  80335d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803360:	8b 40 04             	mov    0x4(%eax),%eax
  803363:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803366:	8b 12                	mov    (%edx),%edx
  803368:	89 10                	mov    %edx,(%eax)
  80336a:	eb 0a                	jmp    803376 <insert_sorted_with_merge_freeList+0x2d7>
  80336c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80336f:	8b 00                	mov    (%eax),%eax
  803371:	a3 38 51 80 00       	mov    %eax,0x805138
  803376:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803379:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80337f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803382:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803389:	a1 44 51 80 00       	mov    0x805144,%eax
  80338e:	48                   	dec    %eax
  80338f:	a3 44 51 80 00       	mov    %eax,0x805144
						addToAvailMemBlocksList(blockToInsert);
  803394:	83 ec 0c             	sub    $0xc,%esp
  803397:	ff 75 08             	pushl  0x8(%ebp)
  80339a:	e8 80 fc ff ff       	call   80301f <addToAvailMemBlocksList>
  80339f:	83 c4 10             	add    $0x10,%esp
						addToAvailMemBlocksList(iterator);
  8033a2:	83 ec 0c             	sub    $0xc,%esp
  8033a5:	ff 75 f4             	pushl  -0xc(%ebp)
  8033a8:	e8 72 fc ff ff       	call   80301f <addToAvailMemBlocksList>
  8033ad:	83 c4 10             	add    $0x10,%esp
					//Insert
					else {
						LIST_INSERT_BEFORE(&FreeMemBlocksList, iterator,
								blockToInsert);
					}
					break;
  8033b0:	e9 2e 01 00 00       	jmp    8034e3 <insert_sorted_with_merge_freeList+0x444>
						LIST_REMOVE(&FreeMemBlocksList, iterator);
						addToAvailMemBlocksList(blockToInsert);
						addToAvailMemBlocksList(iterator);
					}
					//previous merge
					else if (prev->sva + prev->size == blockToInsert->sva) {
  8033b5:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8033b8:	8b 50 08             	mov    0x8(%eax),%edx
  8033bb:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8033be:	8b 40 0c             	mov    0xc(%eax),%eax
  8033c1:	01 c2                	add    %eax,%edx
  8033c3:	8b 45 08             	mov    0x8(%ebp),%eax
  8033c6:	8b 40 08             	mov    0x8(%eax),%eax
  8033c9:	39 c2                	cmp    %eax,%edx
  8033cb:	75 27                	jne    8033f4 <insert_sorted_with_merge_freeList+0x355>
						prev->size = prev->size + blockToInsert->size;
  8033cd:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8033d0:	8b 50 0c             	mov    0xc(%eax),%edx
  8033d3:	8b 45 08             	mov    0x8(%ebp),%eax
  8033d6:	8b 40 0c             	mov    0xc(%eax),%eax
  8033d9:	01 c2                	add    %eax,%edx
  8033db:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8033de:	89 50 0c             	mov    %edx,0xc(%eax)
						addToAvailMemBlocksList(blockToInsert);
  8033e1:	83 ec 0c             	sub    $0xc,%esp
  8033e4:	ff 75 08             	pushl  0x8(%ebp)
  8033e7:	e8 33 fc ff ff       	call   80301f <addToAvailMemBlocksList>
  8033ec:	83 c4 10             	add    $0x10,%esp
					//Insert
					else {
						LIST_INSERT_BEFORE(&FreeMemBlocksList, iterator,
								blockToInsert);
					}
					break;
  8033ef:	e9 ef 00 00 00       	jmp    8034e3 <insert_sorted_with_merge_freeList+0x444>
					else if (prev->sva + prev->size == blockToInsert->sva) {
						prev->size = prev->size + blockToInsert->size;
						addToAvailMemBlocksList(blockToInsert);
					}
					//next merge
					else if (blockToInsert->size + blockToInsert->sva
  8033f4:	8b 45 08             	mov    0x8(%ebp),%eax
  8033f7:	8b 50 0c             	mov    0xc(%eax),%edx
  8033fa:	8b 45 08             	mov    0x8(%ebp),%eax
  8033fd:	8b 40 08             	mov    0x8(%eax),%eax
  803400:	01 c2                	add    %eax,%edx
							== iterator->sva) {
  803402:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803405:	8b 40 08             	mov    0x8(%eax),%eax
					else if (prev->sva + prev->size == blockToInsert->sva) {
						prev->size = prev->size + blockToInsert->size;
						addToAvailMemBlocksList(blockToInsert);
					}
					//next merge
					else if (blockToInsert->size + blockToInsert->sva
  803408:	39 c2                	cmp    %eax,%edx
  80340a:	75 33                	jne    80343f <insert_sorted_with_merge_freeList+0x3a0>
							== iterator->sva) {
						iterator->sva = blockToInsert->sva;
  80340c:	8b 45 08             	mov    0x8(%ebp),%eax
  80340f:	8b 50 08             	mov    0x8(%eax),%edx
  803412:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803415:	89 50 08             	mov    %edx,0x8(%eax)
						iterator->size = iterator->size + blockToInsert->size;
  803418:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80341b:	8b 50 0c             	mov    0xc(%eax),%edx
  80341e:	8b 45 08             	mov    0x8(%ebp),%eax
  803421:	8b 40 0c             	mov    0xc(%eax),%eax
  803424:	01 c2                	add    %eax,%edx
  803426:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803429:	89 50 0c             	mov    %edx,0xc(%eax)
						addToAvailMemBlocksList(blockToInsert);
  80342c:	83 ec 0c             	sub    $0xc,%esp
  80342f:	ff 75 08             	pushl  0x8(%ebp)
  803432:	e8 e8 fb ff ff       	call   80301f <addToAvailMemBlocksList>
  803437:	83 c4 10             	add    $0x10,%esp
					//Insert
					else {
						LIST_INSERT_BEFORE(&FreeMemBlocksList, iterator,
								blockToInsert);
					}
					break;
  80343a:	e9 a4 00 00 00       	jmp    8034e3 <insert_sorted_with_merge_freeList+0x444>
						iterator->size = iterator->size + blockToInsert->size;
						addToAvailMemBlocksList(blockToInsert);
					}
					//Insert
					else {
						LIST_INSERT_BEFORE(&FreeMemBlocksList, iterator,
  80343f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803443:	74 06                	je     80344b <insert_sorted_with_merge_freeList+0x3ac>
  803445:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803449:	75 17                	jne    803462 <insert_sorted_with_merge_freeList+0x3c3>
  80344b:	83 ec 04             	sub    $0x4,%esp
  80344e:	68 08 41 80 00       	push   $0x804108
  803453:	68 56 01 00 00       	push   $0x156
  803458:	68 77 40 80 00       	push   $0x804077
  80345d:	e8 aa d4 ff ff       	call   80090c <_panic>
  803462:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803465:	8b 50 04             	mov    0x4(%eax),%edx
  803468:	8b 45 08             	mov    0x8(%ebp),%eax
  80346b:	89 50 04             	mov    %edx,0x4(%eax)
  80346e:	8b 45 08             	mov    0x8(%ebp),%eax
  803471:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803474:	89 10                	mov    %edx,(%eax)
  803476:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803479:	8b 40 04             	mov    0x4(%eax),%eax
  80347c:	85 c0                	test   %eax,%eax
  80347e:	74 0d                	je     80348d <insert_sorted_with_merge_freeList+0x3ee>
  803480:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803483:	8b 40 04             	mov    0x4(%eax),%eax
  803486:	8b 55 08             	mov    0x8(%ebp),%edx
  803489:	89 10                	mov    %edx,(%eax)
  80348b:	eb 08                	jmp    803495 <insert_sorted_with_merge_freeList+0x3f6>
  80348d:	8b 45 08             	mov    0x8(%ebp),%eax
  803490:	a3 38 51 80 00       	mov    %eax,0x805138
  803495:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803498:	8b 55 08             	mov    0x8(%ebp),%edx
  80349b:	89 50 04             	mov    %edx,0x4(%eax)
  80349e:	a1 44 51 80 00       	mov    0x805144,%eax
  8034a3:	40                   	inc    %eax
  8034a4:	a3 44 51 80 00       	mov    %eax,0x805144
								blockToInsert);
					}
					break;
  8034a9:	eb 38                	jmp    8034e3 <insert_sorted_with_merge_freeList+0x444>
		} else {
			LIST_INSERT_AFTER(&FreeMemBlocksList, last, blockToInsert);
		}
	} else {
		struct MemBlock *iterator;
		LIST_FOREACH(iterator, &(FreeMemBlocksList))
  8034ab:	a1 40 51 80 00       	mov    0x805140,%eax
  8034b0:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8034b3:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8034b7:	74 07                	je     8034c0 <insert_sorted_with_merge_freeList+0x421>
  8034b9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8034bc:	8b 00                	mov    (%eax),%eax
  8034be:	eb 05                	jmp    8034c5 <insert_sorted_with_merge_freeList+0x426>
  8034c0:	b8 00 00 00 00       	mov    $0x0,%eax
  8034c5:	a3 40 51 80 00       	mov    %eax,0x805140
  8034ca:	a1 40 51 80 00       	mov    0x805140,%eax
  8034cf:	85 c0                	test   %eax,%eax
  8034d1:	0f 85 1a fd ff ff    	jne    8031f1 <insert_sorted_with_merge_freeList+0x152>
  8034d7:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8034db:	0f 85 10 fd ff ff    	jne    8031f1 <insert_sorted_with_merge_freeList+0x152>
		}
	}

	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  8034e1:	eb 00                	jmp    8034e3 <insert_sorted_with_merge_freeList+0x444>
  8034e3:	90                   	nop
  8034e4:	c9                   	leave  
  8034e5:	c3                   	ret    
  8034e6:	66 90                	xchg   %ax,%ax

008034e8 <__udivdi3>:
  8034e8:	55                   	push   %ebp
  8034e9:	57                   	push   %edi
  8034ea:	56                   	push   %esi
  8034eb:	53                   	push   %ebx
  8034ec:	83 ec 1c             	sub    $0x1c,%esp
  8034ef:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  8034f3:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  8034f7:	8b 7c 24 38          	mov    0x38(%esp),%edi
  8034fb:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8034ff:	89 ca                	mov    %ecx,%edx
  803501:	89 f8                	mov    %edi,%eax
  803503:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  803507:	85 f6                	test   %esi,%esi
  803509:	75 2d                	jne    803538 <__udivdi3+0x50>
  80350b:	39 cf                	cmp    %ecx,%edi
  80350d:	77 65                	ja     803574 <__udivdi3+0x8c>
  80350f:	89 fd                	mov    %edi,%ebp
  803511:	85 ff                	test   %edi,%edi
  803513:	75 0b                	jne    803520 <__udivdi3+0x38>
  803515:	b8 01 00 00 00       	mov    $0x1,%eax
  80351a:	31 d2                	xor    %edx,%edx
  80351c:	f7 f7                	div    %edi
  80351e:	89 c5                	mov    %eax,%ebp
  803520:	31 d2                	xor    %edx,%edx
  803522:	89 c8                	mov    %ecx,%eax
  803524:	f7 f5                	div    %ebp
  803526:	89 c1                	mov    %eax,%ecx
  803528:	89 d8                	mov    %ebx,%eax
  80352a:	f7 f5                	div    %ebp
  80352c:	89 cf                	mov    %ecx,%edi
  80352e:	89 fa                	mov    %edi,%edx
  803530:	83 c4 1c             	add    $0x1c,%esp
  803533:	5b                   	pop    %ebx
  803534:	5e                   	pop    %esi
  803535:	5f                   	pop    %edi
  803536:	5d                   	pop    %ebp
  803537:	c3                   	ret    
  803538:	39 ce                	cmp    %ecx,%esi
  80353a:	77 28                	ja     803564 <__udivdi3+0x7c>
  80353c:	0f bd fe             	bsr    %esi,%edi
  80353f:	83 f7 1f             	xor    $0x1f,%edi
  803542:	75 40                	jne    803584 <__udivdi3+0x9c>
  803544:	39 ce                	cmp    %ecx,%esi
  803546:	72 0a                	jb     803552 <__udivdi3+0x6a>
  803548:	3b 44 24 08          	cmp    0x8(%esp),%eax
  80354c:	0f 87 9e 00 00 00    	ja     8035f0 <__udivdi3+0x108>
  803552:	b8 01 00 00 00       	mov    $0x1,%eax
  803557:	89 fa                	mov    %edi,%edx
  803559:	83 c4 1c             	add    $0x1c,%esp
  80355c:	5b                   	pop    %ebx
  80355d:	5e                   	pop    %esi
  80355e:	5f                   	pop    %edi
  80355f:	5d                   	pop    %ebp
  803560:	c3                   	ret    
  803561:	8d 76 00             	lea    0x0(%esi),%esi
  803564:	31 ff                	xor    %edi,%edi
  803566:	31 c0                	xor    %eax,%eax
  803568:	89 fa                	mov    %edi,%edx
  80356a:	83 c4 1c             	add    $0x1c,%esp
  80356d:	5b                   	pop    %ebx
  80356e:	5e                   	pop    %esi
  80356f:	5f                   	pop    %edi
  803570:	5d                   	pop    %ebp
  803571:	c3                   	ret    
  803572:	66 90                	xchg   %ax,%ax
  803574:	89 d8                	mov    %ebx,%eax
  803576:	f7 f7                	div    %edi
  803578:	31 ff                	xor    %edi,%edi
  80357a:	89 fa                	mov    %edi,%edx
  80357c:	83 c4 1c             	add    $0x1c,%esp
  80357f:	5b                   	pop    %ebx
  803580:	5e                   	pop    %esi
  803581:	5f                   	pop    %edi
  803582:	5d                   	pop    %ebp
  803583:	c3                   	ret    
  803584:	bd 20 00 00 00       	mov    $0x20,%ebp
  803589:	89 eb                	mov    %ebp,%ebx
  80358b:	29 fb                	sub    %edi,%ebx
  80358d:	89 f9                	mov    %edi,%ecx
  80358f:	d3 e6                	shl    %cl,%esi
  803591:	89 c5                	mov    %eax,%ebp
  803593:	88 d9                	mov    %bl,%cl
  803595:	d3 ed                	shr    %cl,%ebp
  803597:	89 e9                	mov    %ebp,%ecx
  803599:	09 f1                	or     %esi,%ecx
  80359b:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  80359f:	89 f9                	mov    %edi,%ecx
  8035a1:	d3 e0                	shl    %cl,%eax
  8035a3:	89 c5                	mov    %eax,%ebp
  8035a5:	89 d6                	mov    %edx,%esi
  8035a7:	88 d9                	mov    %bl,%cl
  8035a9:	d3 ee                	shr    %cl,%esi
  8035ab:	89 f9                	mov    %edi,%ecx
  8035ad:	d3 e2                	shl    %cl,%edx
  8035af:	8b 44 24 08          	mov    0x8(%esp),%eax
  8035b3:	88 d9                	mov    %bl,%cl
  8035b5:	d3 e8                	shr    %cl,%eax
  8035b7:	09 c2                	or     %eax,%edx
  8035b9:	89 d0                	mov    %edx,%eax
  8035bb:	89 f2                	mov    %esi,%edx
  8035bd:	f7 74 24 0c          	divl   0xc(%esp)
  8035c1:	89 d6                	mov    %edx,%esi
  8035c3:	89 c3                	mov    %eax,%ebx
  8035c5:	f7 e5                	mul    %ebp
  8035c7:	39 d6                	cmp    %edx,%esi
  8035c9:	72 19                	jb     8035e4 <__udivdi3+0xfc>
  8035cb:	74 0b                	je     8035d8 <__udivdi3+0xf0>
  8035cd:	89 d8                	mov    %ebx,%eax
  8035cf:	31 ff                	xor    %edi,%edi
  8035d1:	e9 58 ff ff ff       	jmp    80352e <__udivdi3+0x46>
  8035d6:	66 90                	xchg   %ax,%ax
  8035d8:	8b 54 24 08          	mov    0x8(%esp),%edx
  8035dc:	89 f9                	mov    %edi,%ecx
  8035de:	d3 e2                	shl    %cl,%edx
  8035e0:	39 c2                	cmp    %eax,%edx
  8035e2:	73 e9                	jae    8035cd <__udivdi3+0xe5>
  8035e4:	8d 43 ff             	lea    -0x1(%ebx),%eax
  8035e7:	31 ff                	xor    %edi,%edi
  8035e9:	e9 40 ff ff ff       	jmp    80352e <__udivdi3+0x46>
  8035ee:	66 90                	xchg   %ax,%ax
  8035f0:	31 c0                	xor    %eax,%eax
  8035f2:	e9 37 ff ff ff       	jmp    80352e <__udivdi3+0x46>
  8035f7:	90                   	nop

008035f8 <__umoddi3>:
  8035f8:	55                   	push   %ebp
  8035f9:	57                   	push   %edi
  8035fa:	56                   	push   %esi
  8035fb:	53                   	push   %ebx
  8035fc:	83 ec 1c             	sub    $0x1c,%esp
  8035ff:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  803603:	8b 74 24 34          	mov    0x34(%esp),%esi
  803607:	8b 7c 24 38          	mov    0x38(%esp),%edi
  80360b:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  80360f:	89 44 24 0c          	mov    %eax,0xc(%esp)
  803613:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  803617:	89 f3                	mov    %esi,%ebx
  803619:	89 fa                	mov    %edi,%edx
  80361b:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  80361f:	89 34 24             	mov    %esi,(%esp)
  803622:	85 c0                	test   %eax,%eax
  803624:	75 1a                	jne    803640 <__umoddi3+0x48>
  803626:	39 f7                	cmp    %esi,%edi
  803628:	0f 86 a2 00 00 00    	jbe    8036d0 <__umoddi3+0xd8>
  80362e:	89 c8                	mov    %ecx,%eax
  803630:	89 f2                	mov    %esi,%edx
  803632:	f7 f7                	div    %edi
  803634:	89 d0                	mov    %edx,%eax
  803636:	31 d2                	xor    %edx,%edx
  803638:	83 c4 1c             	add    $0x1c,%esp
  80363b:	5b                   	pop    %ebx
  80363c:	5e                   	pop    %esi
  80363d:	5f                   	pop    %edi
  80363e:	5d                   	pop    %ebp
  80363f:	c3                   	ret    
  803640:	39 f0                	cmp    %esi,%eax
  803642:	0f 87 ac 00 00 00    	ja     8036f4 <__umoddi3+0xfc>
  803648:	0f bd e8             	bsr    %eax,%ebp
  80364b:	83 f5 1f             	xor    $0x1f,%ebp
  80364e:	0f 84 ac 00 00 00    	je     803700 <__umoddi3+0x108>
  803654:	bf 20 00 00 00       	mov    $0x20,%edi
  803659:	29 ef                	sub    %ebp,%edi
  80365b:	89 fe                	mov    %edi,%esi
  80365d:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  803661:	89 e9                	mov    %ebp,%ecx
  803663:	d3 e0                	shl    %cl,%eax
  803665:	89 d7                	mov    %edx,%edi
  803667:	89 f1                	mov    %esi,%ecx
  803669:	d3 ef                	shr    %cl,%edi
  80366b:	09 c7                	or     %eax,%edi
  80366d:	89 e9                	mov    %ebp,%ecx
  80366f:	d3 e2                	shl    %cl,%edx
  803671:	89 14 24             	mov    %edx,(%esp)
  803674:	89 d8                	mov    %ebx,%eax
  803676:	d3 e0                	shl    %cl,%eax
  803678:	89 c2                	mov    %eax,%edx
  80367a:	8b 44 24 08          	mov    0x8(%esp),%eax
  80367e:	d3 e0                	shl    %cl,%eax
  803680:	89 44 24 04          	mov    %eax,0x4(%esp)
  803684:	8b 44 24 08          	mov    0x8(%esp),%eax
  803688:	89 f1                	mov    %esi,%ecx
  80368a:	d3 e8                	shr    %cl,%eax
  80368c:	09 d0                	or     %edx,%eax
  80368e:	d3 eb                	shr    %cl,%ebx
  803690:	89 da                	mov    %ebx,%edx
  803692:	f7 f7                	div    %edi
  803694:	89 d3                	mov    %edx,%ebx
  803696:	f7 24 24             	mull   (%esp)
  803699:	89 c6                	mov    %eax,%esi
  80369b:	89 d1                	mov    %edx,%ecx
  80369d:	39 d3                	cmp    %edx,%ebx
  80369f:	0f 82 87 00 00 00    	jb     80372c <__umoddi3+0x134>
  8036a5:	0f 84 91 00 00 00    	je     80373c <__umoddi3+0x144>
  8036ab:	8b 54 24 04          	mov    0x4(%esp),%edx
  8036af:	29 f2                	sub    %esi,%edx
  8036b1:	19 cb                	sbb    %ecx,%ebx
  8036b3:	89 d8                	mov    %ebx,%eax
  8036b5:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  8036b9:	d3 e0                	shl    %cl,%eax
  8036bb:	89 e9                	mov    %ebp,%ecx
  8036bd:	d3 ea                	shr    %cl,%edx
  8036bf:	09 d0                	or     %edx,%eax
  8036c1:	89 e9                	mov    %ebp,%ecx
  8036c3:	d3 eb                	shr    %cl,%ebx
  8036c5:	89 da                	mov    %ebx,%edx
  8036c7:	83 c4 1c             	add    $0x1c,%esp
  8036ca:	5b                   	pop    %ebx
  8036cb:	5e                   	pop    %esi
  8036cc:	5f                   	pop    %edi
  8036cd:	5d                   	pop    %ebp
  8036ce:	c3                   	ret    
  8036cf:	90                   	nop
  8036d0:	89 fd                	mov    %edi,%ebp
  8036d2:	85 ff                	test   %edi,%edi
  8036d4:	75 0b                	jne    8036e1 <__umoddi3+0xe9>
  8036d6:	b8 01 00 00 00       	mov    $0x1,%eax
  8036db:	31 d2                	xor    %edx,%edx
  8036dd:	f7 f7                	div    %edi
  8036df:	89 c5                	mov    %eax,%ebp
  8036e1:	89 f0                	mov    %esi,%eax
  8036e3:	31 d2                	xor    %edx,%edx
  8036e5:	f7 f5                	div    %ebp
  8036e7:	89 c8                	mov    %ecx,%eax
  8036e9:	f7 f5                	div    %ebp
  8036eb:	89 d0                	mov    %edx,%eax
  8036ed:	e9 44 ff ff ff       	jmp    803636 <__umoddi3+0x3e>
  8036f2:	66 90                	xchg   %ax,%ax
  8036f4:	89 c8                	mov    %ecx,%eax
  8036f6:	89 f2                	mov    %esi,%edx
  8036f8:	83 c4 1c             	add    $0x1c,%esp
  8036fb:	5b                   	pop    %ebx
  8036fc:	5e                   	pop    %esi
  8036fd:	5f                   	pop    %edi
  8036fe:	5d                   	pop    %ebp
  8036ff:	c3                   	ret    
  803700:	3b 04 24             	cmp    (%esp),%eax
  803703:	72 06                	jb     80370b <__umoddi3+0x113>
  803705:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  803709:	77 0f                	ja     80371a <__umoddi3+0x122>
  80370b:	89 f2                	mov    %esi,%edx
  80370d:	29 f9                	sub    %edi,%ecx
  80370f:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  803713:	89 14 24             	mov    %edx,(%esp)
  803716:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  80371a:	8b 44 24 04          	mov    0x4(%esp),%eax
  80371e:	8b 14 24             	mov    (%esp),%edx
  803721:	83 c4 1c             	add    $0x1c,%esp
  803724:	5b                   	pop    %ebx
  803725:	5e                   	pop    %esi
  803726:	5f                   	pop    %edi
  803727:	5d                   	pop    %ebp
  803728:	c3                   	ret    
  803729:	8d 76 00             	lea    0x0(%esi),%esi
  80372c:	2b 04 24             	sub    (%esp),%eax
  80372f:	19 fa                	sbb    %edi,%edx
  803731:	89 d1                	mov    %edx,%ecx
  803733:	89 c6                	mov    %eax,%esi
  803735:	e9 71 ff ff ff       	jmp    8036ab <__umoddi3+0xb3>
  80373a:	66 90                	xchg   %ax,%ax
  80373c:	39 44 24 04          	cmp    %eax,0x4(%esp)
  803740:	72 ea                	jb     80372c <__umoddi3+0x134>
  803742:	89 d9                	mov    %ebx,%ecx
  803744:	e9 62 ff ff ff       	jmp    8036ab <__umoddi3+0xb3>
