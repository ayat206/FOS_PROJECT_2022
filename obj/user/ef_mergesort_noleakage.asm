
obj/user/ef_mergesort_noleakage:     file format elf32-i386


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
  800031:	e8 81 07 00 00       	call   8007b7 <libmain>
1:      jmp 1b
  800036:	eb fe                	jmp    800036 <args_exist+0x5>

00800038 <_main>:
void Merge(int* A, int p, int q, int r);

uint32 CheckSorted(int *Elements, int NumOfElements);

void _main(void)
{
  800038:	55                   	push   %ebp
  800039:	89 e5                	mov    %esp,%ebp
  80003b:	81 ec 18 01 00 00    	sub    $0x118,%esp
	char Line[255] ;
	char Chose ;
	do
	{
		//2012: lock the interrupt
		sys_disable_interrupt();
  800041:	e8 ec 1f 00 00       	call   802032 <sys_disable_interrupt>

		cprintf("\n");
  800046:	83 ec 0c             	sub    $0xc,%esp
  800049:	68 40 37 80 00       	push   $0x803740
  80004e:	e8 54 0b 00 00       	call   800ba7 <cprintf>
  800053:	83 c4 10             	add    $0x10,%esp
		cprintf("!!!!!!!!!!!!!!!!!!!!\n");
  800056:	83 ec 0c             	sub    $0xc,%esp
  800059:	68 42 37 80 00       	push   $0x803742
  80005e:	e8 44 0b 00 00       	call   800ba7 <cprintf>
  800063:	83 c4 10             	add    $0x10,%esp
		cprintf("!!!! MERGE SORT !!!!\n");
  800066:	83 ec 0c             	sub    $0xc,%esp
  800069:	68 58 37 80 00       	push   $0x803758
  80006e:	e8 34 0b 00 00       	call   800ba7 <cprintf>
  800073:	83 c4 10             	add    $0x10,%esp
		cprintf("!!!!!!!!!!!!!!!!!!!!\n");
  800076:	83 ec 0c             	sub    $0xc,%esp
  800079:	68 42 37 80 00       	push   $0x803742
  80007e:	e8 24 0b 00 00       	call   800ba7 <cprintf>
  800083:	83 c4 10             	add    $0x10,%esp
		cprintf("\n");
  800086:	83 ec 0c             	sub    $0xc,%esp
  800089:	68 40 37 80 00       	push   $0x803740
  80008e:	e8 14 0b 00 00       	call   800ba7 <cprintf>
  800093:	83 c4 10             	add    $0x10,%esp
		//readline("Enter the number of elements: ", Line);
		cprintf("Enter the number of elements: ");
  800096:	83 ec 0c             	sub    $0xc,%esp
  800099:	68 70 37 80 00       	push   $0x803770
  80009e:	e8 04 0b 00 00       	call   800ba7 <cprintf>
  8000a3:	83 c4 10             	add    $0x10,%esp
		int NumOfElements = 2000 ;
  8000a6:	c7 45 f0 d0 07 00 00 	movl   $0x7d0,-0x10(%ebp)
		cprintf("%d\n", NumOfElements) ;
  8000ad:	83 ec 08             	sub    $0x8,%esp
  8000b0:	ff 75 f0             	pushl  -0x10(%ebp)
  8000b3:	68 8f 37 80 00       	push   $0x80378f
  8000b8:	e8 ea 0a 00 00       	call   800ba7 <cprintf>
  8000bd:	83 c4 10             	add    $0x10,%esp

		int *Elements = malloc(sizeof(int) * NumOfElements) ;
  8000c0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8000c3:	c1 e0 02             	shl    $0x2,%eax
  8000c6:	83 ec 0c             	sub    $0xc,%esp
  8000c9:	50                   	push   %eax
  8000ca:	e8 6a 1a 00 00       	call   801b39 <malloc>
  8000cf:	83 c4 10             	add    $0x10,%esp
  8000d2:	89 45 ec             	mov    %eax,-0x14(%ebp)
		cprintf("Chose the initialization method:\n") ;
  8000d5:	83 ec 0c             	sub    $0xc,%esp
  8000d8:	68 94 37 80 00       	push   $0x803794
  8000dd:	e8 c5 0a 00 00       	call   800ba7 <cprintf>
  8000e2:	83 c4 10             	add    $0x10,%esp
		cprintf("a) Ascending\n") ;
  8000e5:	83 ec 0c             	sub    $0xc,%esp
  8000e8:	68 b6 37 80 00       	push   $0x8037b6
  8000ed:	e8 b5 0a 00 00       	call   800ba7 <cprintf>
  8000f2:	83 c4 10             	add    $0x10,%esp
		cprintf("b) Descending\n") ;
  8000f5:	83 ec 0c             	sub    $0xc,%esp
  8000f8:	68 c4 37 80 00       	push   $0x8037c4
  8000fd:	e8 a5 0a 00 00       	call   800ba7 <cprintf>
  800102:	83 c4 10             	add    $0x10,%esp
		cprintf("c) Semi random\n");
  800105:	83 ec 0c             	sub    $0xc,%esp
  800108:	68 d3 37 80 00       	push   $0x8037d3
  80010d:	e8 95 0a 00 00       	call   800ba7 <cprintf>
  800112:	83 c4 10             	add    $0x10,%esp
		do
		{
			cprintf("Select: ") ;
  800115:	83 ec 0c             	sub    $0xc,%esp
  800118:	68 e3 37 80 00       	push   $0x8037e3
  80011d:	e8 85 0a 00 00       	call   800ba7 <cprintf>
  800122:	83 c4 10             	add    $0x10,%esp
			//Chose = getchar() ;
			Chose = 'a';
  800125:	c6 45 f7 61          	movb   $0x61,-0x9(%ebp)
			cputchar(Chose);
  800129:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
  80012d:	83 ec 0c             	sub    $0xc,%esp
  800130:	50                   	push   %eax
  800131:	e8 e1 05 00 00       	call   800717 <cputchar>
  800136:	83 c4 10             	add    $0x10,%esp
			cputchar('\n');
  800139:	83 ec 0c             	sub    $0xc,%esp
  80013c:	6a 0a                	push   $0xa
  80013e:	e8 d4 05 00 00       	call   800717 <cputchar>
  800143:	83 c4 10             	add    $0x10,%esp
		} while (Chose != 'a' && Chose != 'b' && Chose != 'c');
  800146:	80 7d f7 61          	cmpb   $0x61,-0x9(%ebp)
  80014a:	74 0c                	je     800158 <_main+0x120>
  80014c:	80 7d f7 62          	cmpb   $0x62,-0x9(%ebp)
  800150:	74 06                	je     800158 <_main+0x120>
  800152:	80 7d f7 63          	cmpb   $0x63,-0x9(%ebp)
  800156:	75 bd                	jne    800115 <_main+0xdd>

		//2012: lock the interrupt
		sys_enable_interrupt();
  800158:	e8 ef 1e 00 00       	call   80204c <sys_enable_interrupt>

		int  i ;
		switch (Chose)
  80015d:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
  800161:	83 f8 62             	cmp    $0x62,%eax
  800164:	74 1d                	je     800183 <_main+0x14b>
  800166:	83 f8 63             	cmp    $0x63,%eax
  800169:	74 2b                	je     800196 <_main+0x15e>
  80016b:	83 f8 61             	cmp    $0x61,%eax
  80016e:	75 39                	jne    8001a9 <_main+0x171>
		{
		case 'a':
			InitializeAscending(Elements, NumOfElements);
  800170:	83 ec 08             	sub    $0x8,%esp
  800173:	ff 75 f0             	pushl  -0x10(%ebp)
  800176:	ff 75 ec             	pushl  -0x14(%ebp)
  800179:	e8 f0 01 00 00       	call   80036e <InitializeAscending>
  80017e:	83 c4 10             	add    $0x10,%esp
			break ;
  800181:	eb 37                	jmp    8001ba <_main+0x182>
		case 'b':
			InitializeDescending(Elements, NumOfElements);
  800183:	83 ec 08             	sub    $0x8,%esp
  800186:	ff 75 f0             	pushl  -0x10(%ebp)
  800189:	ff 75 ec             	pushl  -0x14(%ebp)
  80018c:	e8 0e 02 00 00       	call   80039f <InitializeDescending>
  800191:	83 c4 10             	add    $0x10,%esp
			break ;
  800194:	eb 24                	jmp    8001ba <_main+0x182>
		case 'c':
			InitializeSemiRandom(Elements, NumOfElements);
  800196:	83 ec 08             	sub    $0x8,%esp
  800199:	ff 75 f0             	pushl  -0x10(%ebp)
  80019c:	ff 75 ec             	pushl  -0x14(%ebp)
  80019f:	e8 30 02 00 00       	call   8003d4 <InitializeSemiRandom>
  8001a4:	83 c4 10             	add    $0x10,%esp
			break ;
  8001a7:	eb 11                	jmp    8001ba <_main+0x182>
		default:
			InitializeSemiRandom(Elements, NumOfElements);
  8001a9:	83 ec 08             	sub    $0x8,%esp
  8001ac:	ff 75 f0             	pushl  -0x10(%ebp)
  8001af:	ff 75 ec             	pushl  -0x14(%ebp)
  8001b2:	e8 1d 02 00 00       	call   8003d4 <InitializeSemiRandom>
  8001b7:	83 c4 10             	add    $0x10,%esp
		}

		MSort(Elements, 1, NumOfElements);
  8001ba:	83 ec 04             	sub    $0x4,%esp
  8001bd:	ff 75 f0             	pushl  -0x10(%ebp)
  8001c0:	6a 01                	push   $0x1
  8001c2:	ff 75 ec             	pushl  -0x14(%ebp)
  8001c5:	e8 dc 02 00 00       	call   8004a6 <MSort>
  8001ca:	83 c4 10             	add    $0x10,%esp

		sys_disable_interrupt();
  8001cd:	e8 60 1e 00 00       	call   802032 <sys_disable_interrupt>
		cprintf("Sorting is Finished!!!!it'll be checked now....\n") ;
  8001d2:	83 ec 0c             	sub    $0xc,%esp
  8001d5:	68 ec 37 80 00       	push   $0x8037ec
  8001da:	e8 c8 09 00 00       	call   800ba7 <cprintf>
  8001df:	83 c4 10             	add    $0x10,%esp
		//PrintElements(Elements, NumOfElements);
		sys_enable_interrupt();
  8001e2:	e8 65 1e 00 00       	call   80204c <sys_enable_interrupt>

		uint32 Sorted = CheckSorted(Elements, NumOfElements);
  8001e7:	83 ec 08             	sub    $0x8,%esp
  8001ea:	ff 75 f0             	pushl  -0x10(%ebp)
  8001ed:	ff 75 ec             	pushl  -0x14(%ebp)
  8001f0:	e8 cf 00 00 00       	call   8002c4 <CheckSorted>
  8001f5:	83 c4 10             	add    $0x10,%esp
  8001f8:	89 45 e8             	mov    %eax,-0x18(%ebp)

		if(Sorted == 0) panic("The array is NOT sorted correctly") ;
  8001fb:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8001ff:	75 14                	jne    800215 <_main+0x1dd>
  800201:	83 ec 04             	sub    $0x4,%esp
  800204:	68 20 38 80 00       	push   $0x803820
  800209:	6a 4e                	push   $0x4e
  80020b:	68 42 38 80 00       	push   $0x803842
  800210:	e8 de 06 00 00       	call   8008f3 <_panic>
		else
		{
			sys_disable_interrupt();
  800215:	e8 18 1e 00 00       	call   802032 <sys_disable_interrupt>
			cprintf("===============================================\n") ;
  80021a:	83 ec 0c             	sub    $0xc,%esp
  80021d:	68 60 38 80 00       	push   $0x803860
  800222:	e8 80 09 00 00       	call   800ba7 <cprintf>
  800227:	83 c4 10             	add    $0x10,%esp
			cprintf("Congratulations!! The array is sorted correctly\n") ;
  80022a:	83 ec 0c             	sub    $0xc,%esp
  80022d:	68 94 38 80 00       	push   $0x803894
  800232:	e8 70 09 00 00       	call   800ba7 <cprintf>
  800237:	83 c4 10             	add    $0x10,%esp
			cprintf("===============================================\n\n") ;
  80023a:	83 ec 0c             	sub    $0xc,%esp
  80023d:	68 c8 38 80 00       	push   $0x8038c8
  800242:	e8 60 09 00 00       	call   800ba7 <cprintf>
  800247:	83 c4 10             	add    $0x10,%esp
			sys_enable_interrupt();
  80024a:	e8 fd 1d 00 00       	call   80204c <sys_enable_interrupt>
		}

		free(Elements) ;
  80024f:	83 ec 0c             	sub    $0xc,%esp
  800252:	ff 75 ec             	pushl  -0x14(%ebp)
  800255:	e8 60 19 00 00       	call   801bba <free>
  80025a:	83 c4 10             	add    $0x10,%esp

		sys_disable_interrupt();
  80025d:	e8 d0 1d 00 00       	call   802032 <sys_disable_interrupt>
			Chose = 0 ;
  800262:	c6 45 f7 00          	movb   $0x0,-0x9(%ebp)
			while (Chose != 'y' && Chose != 'n')
  800266:	eb 3e                	jmp    8002a6 <_main+0x26e>
			{
				cprintf("Do you want to repeat (y/n): ") ;
  800268:	83 ec 0c             	sub    $0xc,%esp
  80026b:	68 fa 38 80 00       	push   $0x8038fa
  800270:	e8 32 09 00 00       	call   800ba7 <cprintf>
  800275:	83 c4 10             	add    $0x10,%esp
				Chose = 'n' ;
  800278:	c6 45 f7 6e          	movb   $0x6e,-0x9(%ebp)
				cputchar(Chose);
  80027c:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
  800280:	83 ec 0c             	sub    $0xc,%esp
  800283:	50                   	push   %eax
  800284:	e8 8e 04 00 00       	call   800717 <cputchar>
  800289:	83 c4 10             	add    $0x10,%esp
				cputchar('\n');
  80028c:	83 ec 0c             	sub    $0xc,%esp
  80028f:	6a 0a                	push   $0xa
  800291:	e8 81 04 00 00       	call   800717 <cputchar>
  800296:	83 c4 10             	add    $0x10,%esp
				cputchar('\n');
  800299:	83 ec 0c             	sub    $0xc,%esp
  80029c:	6a 0a                	push   $0xa
  80029e:	e8 74 04 00 00       	call   800717 <cputchar>
  8002a3:	83 c4 10             	add    $0x10,%esp

		free(Elements) ;

		sys_disable_interrupt();
			Chose = 0 ;
			while (Chose != 'y' && Chose != 'n')
  8002a6:	80 7d f7 79          	cmpb   $0x79,-0x9(%ebp)
  8002aa:	74 06                	je     8002b2 <_main+0x27a>
  8002ac:	80 7d f7 6e          	cmpb   $0x6e,-0x9(%ebp)
  8002b0:	75 b6                	jne    800268 <_main+0x230>
				Chose = 'n' ;
				cputchar(Chose);
				cputchar('\n');
				cputchar('\n');
			}
		sys_enable_interrupt();
  8002b2:	e8 95 1d 00 00       	call   80204c <sys_enable_interrupt>

	} while (Chose == 'y');
  8002b7:	80 7d f7 79          	cmpb   $0x79,-0x9(%ebp)
  8002bb:	0f 84 80 fd ff ff    	je     800041 <_main+0x9>
}
  8002c1:	90                   	nop
  8002c2:	c9                   	leave  
  8002c3:	c3                   	ret    

008002c4 <CheckSorted>:


uint32 CheckSorted(int *Elements, int NumOfElements)
{
  8002c4:	55                   	push   %ebp
  8002c5:	89 e5                	mov    %esp,%ebp
  8002c7:	83 ec 10             	sub    $0x10,%esp
	uint32 Sorted = 1 ;
  8002ca:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
	int i ;
	for (i = 0 ; i < NumOfElements - 1; i++)
  8002d1:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  8002d8:	eb 33                	jmp    80030d <CheckSorted+0x49>
	{
		if (Elements[i] > Elements[i+1])
  8002da:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8002dd:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8002e4:	8b 45 08             	mov    0x8(%ebp),%eax
  8002e7:	01 d0                	add    %edx,%eax
  8002e9:	8b 10                	mov    (%eax),%edx
  8002eb:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8002ee:	40                   	inc    %eax
  8002ef:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  8002f6:	8b 45 08             	mov    0x8(%ebp),%eax
  8002f9:	01 c8                	add    %ecx,%eax
  8002fb:	8b 00                	mov    (%eax),%eax
  8002fd:	39 c2                	cmp    %eax,%edx
  8002ff:	7e 09                	jle    80030a <CheckSorted+0x46>
		{
			Sorted = 0 ;
  800301:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
			break;
  800308:	eb 0c                	jmp    800316 <CheckSorted+0x52>

uint32 CheckSorted(int *Elements, int NumOfElements)
{
	uint32 Sorted = 1 ;
	int i ;
	for (i = 0 ; i < NumOfElements - 1; i++)
  80030a:	ff 45 f8             	incl   -0x8(%ebp)
  80030d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800310:	48                   	dec    %eax
  800311:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800314:	7f c4                	jg     8002da <CheckSorted+0x16>
		{
			Sorted = 0 ;
			break;
		}
	}
	return Sorted ;
  800316:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800319:	c9                   	leave  
  80031a:	c3                   	ret    

0080031b <Swap>:

///Private Functions


void Swap(int *Elements, int First, int Second)
{
  80031b:	55                   	push   %ebp
  80031c:	89 e5                	mov    %esp,%ebp
  80031e:	83 ec 10             	sub    $0x10,%esp
	int Tmp = Elements[First] ;
  800321:	8b 45 0c             	mov    0xc(%ebp),%eax
  800324:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80032b:	8b 45 08             	mov    0x8(%ebp),%eax
  80032e:	01 d0                	add    %edx,%eax
  800330:	8b 00                	mov    (%eax),%eax
  800332:	89 45 fc             	mov    %eax,-0x4(%ebp)
	Elements[First] = Elements[Second] ;
  800335:	8b 45 0c             	mov    0xc(%ebp),%eax
  800338:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80033f:	8b 45 08             	mov    0x8(%ebp),%eax
  800342:	01 c2                	add    %eax,%edx
  800344:	8b 45 10             	mov    0x10(%ebp),%eax
  800347:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  80034e:	8b 45 08             	mov    0x8(%ebp),%eax
  800351:	01 c8                	add    %ecx,%eax
  800353:	8b 00                	mov    (%eax),%eax
  800355:	89 02                	mov    %eax,(%edx)
	Elements[Second] = Tmp ;
  800357:	8b 45 10             	mov    0x10(%ebp),%eax
  80035a:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800361:	8b 45 08             	mov    0x8(%ebp),%eax
  800364:	01 c2                	add    %eax,%edx
  800366:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800369:	89 02                	mov    %eax,(%edx)
}
  80036b:	90                   	nop
  80036c:	c9                   	leave  
  80036d:	c3                   	ret    

0080036e <InitializeAscending>:

void InitializeAscending(int *Elements, int NumOfElements)
{
  80036e:	55                   	push   %ebp
  80036f:	89 e5                	mov    %esp,%ebp
  800371:	83 ec 10             	sub    $0x10,%esp
	int i ;
	for (i = 0 ; i < NumOfElements ; i++)
  800374:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  80037b:	eb 17                	jmp    800394 <InitializeAscending+0x26>
	{
		(Elements)[i] = i ;
  80037d:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800380:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800387:	8b 45 08             	mov    0x8(%ebp),%eax
  80038a:	01 c2                	add    %eax,%edx
  80038c:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80038f:	89 02                	mov    %eax,(%edx)
}

void InitializeAscending(int *Elements, int NumOfElements)
{
	int i ;
	for (i = 0 ; i < NumOfElements ; i++)
  800391:	ff 45 fc             	incl   -0x4(%ebp)
  800394:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800397:	3b 45 0c             	cmp    0xc(%ebp),%eax
  80039a:	7c e1                	jl     80037d <InitializeAscending+0xf>
	{
		(Elements)[i] = i ;
	}

}
  80039c:	90                   	nop
  80039d:	c9                   	leave  
  80039e:	c3                   	ret    

0080039f <InitializeDescending>:

void InitializeDescending(int *Elements, int NumOfElements)
{
  80039f:	55                   	push   %ebp
  8003a0:	89 e5                	mov    %esp,%ebp
  8003a2:	83 ec 10             	sub    $0x10,%esp
	int i ;
	for (i = 0 ; i < NumOfElements ; i++)
  8003a5:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8003ac:	eb 1b                	jmp    8003c9 <InitializeDescending+0x2a>
	{
		Elements[i] = NumOfElements - i - 1 ;
  8003ae:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8003b1:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8003b8:	8b 45 08             	mov    0x8(%ebp),%eax
  8003bb:	01 c2                	add    %eax,%edx
  8003bd:	8b 45 0c             	mov    0xc(%ebp),%eax
  8003c0:	2b 45 fc             	sub    -0x4(%ebp),%eax
  8003c3:	48                   	dec    %eax
  8003c4:	89 02                	mov    %eax,(%edx)
}

void InitializeDescending(int *Elements, int NumOfElements)
{
	int i ;
	for (i = 0 ; i < NumOfElements ; i++)
  8003c6:	ff 45 fc             	incl   -0x4(%ebp)
  8003c9:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8003cc:	3b 45 0c             	cmp    0xc(%ebp),%eax
  8003cf:	7c dd                	jl     8003ae <InitializeDescending+0xf>
	{
		Elements[i] = NumOfElements - i - 1 ;
	}

}
  8003d1:	90                   	nop
  8003d2:	c9                   	leave  
  8003d3:	c3                   	ret    

008003d4 <InitializeSemiRandom>:

void InitializeSemiRandom(int *Elements, int NumOfElements)
{
  8003d4:	55                   	push   %ebp
  8003d5:	89 e5                	mov    %esp,%ebp
  8003d7:	83 ec 10             	sub    $0x10,%esp
	int i ;
	int Repetition = NumOfElements / 3 ;
  8003da:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8003dd:	b8 56 55 55 55       	mov    $0x55555556,%eax
  8003e2:	f7 e9                	imul   %ecx
  8003e4:	c1 f9 1f             	sar    $0x1f,%ecx
  8003e7:	89 d0                	mov    %edx,%eax
  8003e9:	29 c8                	sub    %ecx,%eax
  8003eb:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0 ; i < NumOfElements ; i++)
  8003ee:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8003f5:	eb 1e                	jmp    800415 <InitializeSemiRandom+0x41>
	{
		Elements[i] = i % Repetition ;
  8003f7:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8003fa:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800401:	8b 45 08             	mov    0x8(%ebp),%eax
  800404:	8d 0c 02             	lea    (%edx,%eax,1),%ecx
  800407:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80040a:	99                   	cltd   
  80040b:	f7 7d f8             	idivl  -0x8(%ebp)
  80040e:	89 d0                	mov    %edx,%eax
  800410:	89 01                	mov    %eax,(%ecx)

void InitializeSemiRandom(int *Elements, int NumOfElements)
{
	int i ;
	int Repetition = NumOfElements / 3 ;
	for (i = 0 ; i < NumOfElements ; i++)
  800412:	ff 45 fc             	incl   -0x4(%ebp)
  800415:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800418:	3b 45 0c             	cmp    0xc(%ebp),%eax
  80041b:	7c da                	jl     8003f7 <InitializeSemiRandom+0x23>
	{
		Elements[i] = i % Repetition ;
		//	cprintf("i=%d\n",i);
	}

}
  80041d:	90                   	nop
  80041e:	c9                   	leave  
  80041f:	c3                   	ret    

00800420 <PrintElements>:

void PrintElements(int *Elements, int NumOfElements)
{
  800420:	55                   	push   %ebp
  800421:	89 e5                	mov    %esp,%ebp
  800423:	83 ec 18             	sub    $0x18,%esp
	int i ;
	int NumsPerLine = 20 ;
  800426:	c7 45 f0 14 00 00 00 	movl   $0x14,-0x10(%ebp)
	for (i = 0 ; i < NumOfElements-1 ; i++)
  80042d:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  800434:	eb 42                	jmp    800478 <PrintElements+0x58>
	{
		if (i%NumsPerLine == 0)
  800436:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800439:	99                   	cltd   
  80043a:	f7 7d f0             	idivl  -0x10(%ebp)
  80043d:	89 d0                	mov    %edx,%eax
  80043f:	85 c0                	test   %eax,%eax
  800441:	75 10                	jne    800453 <PrintElements+0x33>
			cprintf("\n");
  800443:	83 ec 0c             	sub    $0xc,%esp
  800446:	68 40 37 80 00       	push   $0x803740
  80044b:	e8 57 07 00 00       	call   800ba7 <cprintf>
  800450:	83 c4 10             	add    $0x10,%esp
		cprintf("%d, ",Elements[i]);
  800453:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800456:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80045d:	8b 45 08             	mov    0x8(%ebp),%eax
  800460:	01 d0                	add    %edx,%eax
  800462:	8b 00                	mov    (%eax),%eax
  800464:	83 ec 08             	sub    $0x8,%esp
  800467:	50                   	push   %eax
  800468:	68 18 39 80 00       	push   $0x803918
  80046d:	e8 35 07 00 00       	call   800ba7 <cprintf>
  800472:	83 c4 10             	add    $0x10,%esp

void PrintElements(int *Elements, int NumOfElements)
{
	int i ;
	int NumsPerLine = 20 ;
	for (i = 0 ; i < NumOfElements-1 ; i++)
  800475:	ff 45 f4             	incl   -0xc(%ebp)
  800478:	8b 45 0c             	mov    0xc(%ebp),%eax
  80047b:	48                   	dec    %eax
  80047c:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  80047f:	7f b5                	jg     800436 <PrintElements+0x16>
	{
		if (i%NumsPerLine == 0)
			cprintf("\n");
		cprintf("%d, ",Elements[i]);
	}
	cprintf("%d\n",Elements[i]);
  800481:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800484:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80048b:	8b 45 08             	mov    0x8(%ebp),%eax
  80048e:	01 d0                	add    %edx,%eax
  800490:	8b 00                	mov    (%eax),%eax
  800492:	83 ec 08             	sub    $0x8,%esp
  800495:	50                   	push   %eax
  800496:	68 8f 37 80 00       	push   $0x80378f
  80049b:	e8 07 07 00 00       	call   800ba7 <cprintf>
  8004a0:	83 c4 10             	add    $0x10,%esp

}
  8004a3:	90                   	nop
  8004a4:	c9                   	leave  
  8004a5:	c3                   	ret    

008004a6 <MSort>:


void MSort(int* A, int p, int r)
{
  8004a6:	55                   	push   %ebp
  8004a7:	89 e5                	mov    %esp,%ebp
  8004a9:	83 ec 18             	sub    $0x18,%esp
	if (p >= r)
  8004ac:	8b 45 0c             	mov    0xc(%ebp),%eax
  8004af:	3b 45 10             	cmp    0x10(%ebp),%eax
  8004b2:	7d 54                	jge    800508 <MSort+0x62>
	{
		return;
	}

	int q = (p + r) / 2;
  8004b4:	8b 55 0c             	mov    0xc(%ebp),%edx
  8004b7:	8b 45 10             	mov    0x10(%ebp),%eax
  8004ba:	01 d0                	add    %edx,%eax
  8004bc:	89 c2                	mov    %eax,%edx
  8004be:	c1 ea 1f             	shr    $0x1f,%edx
  8004c1:	01 d0                	add    %edx,%eax
  8004c3:	d1 f8                	sar    %eax
  8004c5:	89 45 f4             	mov    %eax,-0xc(%ebp)

	MSort(A, p, q);
  8004c8:	83 ec 04             	sub    $0x4,%esp
  8004cb:	ff 75 f4             	pushl  -0xc(%ebp)
  8004ce:	ff 75 0c             	pushl  0xc(%ebp)
  8004d1:	ff 75 08             	pushl  0x8(%ebp)
  8004d4:	e8 cd ff ff ff       	call   8004a6 <MSort>
  8004d9:	83 c4 10             	add    $0x10,%esp

	MSort(A, q + 1, r);
  8004dc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8004df:	40                   	inc    %eax
  8004e0:	83 ec 04             	sub    $0x4,%esp
  8004e3:	ff 75 10             	pushl  0x10(%ebp)
  8004e6:	50                   	push   %eax
  8004e7:	ff 75 08             	pushl  0x8(%ebp)
  8004ea:	e8 b7 ff ff ff       	call   8004a6 <MSort>
  8004ef:	83 c4 10             	add    $0x10,%esp

	Merge(A, p, q, r);
  8004f2:	ff 75 10             	pushl  0x10(%ebp)
  8004f5:	ff 75 f4             	pushl  -0xc(%ebp)
  8004f8:	ff 75 0c             	pushl  0xc(%ebp)
  8004fb:	ff 75 08             	pushl  0x8(%ebp)
  8004fe:	e8 08 00 00 00       	call   80050b <Merge>
  800503:	83 c4 10             	add    $0x10,%esp
  800506:	eb 01                	jmp    800509 <MSort+0x63>

void MSort(int* A, int p, int r)
{
	if (p >= r)
	{
		return;
  800508:	90                   	nop

	MSort(A, q + 1, r);

	Merge(A, p, q, r);

}
  800509:	c9                   	leave  
  80050a:	c3                   	ret    

0080050b <Merge>:

void Merge(int* A, int p, int q, int r)
{
  80050b:	55                   	push   %ebp
  80050c:	89 e5                	mov    %esp,%ebp
  80050e:	83 ec 38             	sub    $0x38,%esp
	int leftCapacity = q - p + 1;
  800511:	8b 45 10             	mov    0x10(%ebp),%eax
  800514:	2b 45 0c             	sub    0xc(%ebp),%eax
  800517:	40                   	inc    %eax
  800518:	89 45 e0             	mov    %eax,-0x20(%ebp)

	int rightCapacity = r - q;
  80051b:	8b 45 14             	mov    0x14(%ebp),%eax
  80051e:	2b 45 10             	sub    0x10(%ebp),%eax
  800521:	89 45 dc             	mov    %eax,-0x24(%ebp)

	int leftIndex = 0;
  800524:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	int rightIndex = 0;
  80052b:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)

	int* Left = malloc(sizeof(int) * leftCapacity);
  800532:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800535:	c1 e0 02             	shl    $0x2,%eax
  800538:	83 ec 0c             	sub    $0xc,%esp
  80053b:	50                   	push   %eax
  80053c:	e8 f8 15 00 00       	call   801b39 <malloc>
  800541:	83 c4 10             	add    $0x10,%esp
  800544:	89 45 d8             	mov    %eax,-0x28(%ebp)

	int* Right = malloc(sizeof(int) * rightCapacity);
  800547:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80054a:	c1 e0 02             	shl    $0x2,%eax
  80054d:	83 ec 0c             	sub    $0xc,%esp
  800550:	50                   	push   %eax
  800551:	e8 e3 15 00 00       	call   801b39 <malloc>
  800556:	83 c4 10             	add    $0x10,%esp
  800559:	89 45 d4             	mov    %eax,-0x2c(%ebp)

	int i, j, k;
	for (i = 0; i < leftCapacity; i++)
  80055c:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  800563:	eb 2f                	jmp    800594 <Merge+0x89>
	{
		Left[i] = A[p + i - 1];
  800565:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800568:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80056f:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800572:	01 c2                	add    %eax,%edx
  800574:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800577:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80057a:	01 c8                	add    %ecx,%eax
  80057c:	05 ff ff ff 3f       	add    $0x3fffffff,%eax
  800581:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  800588:	8b 45 08             	mov    0x8(%ebp),%eax
  80058b:	01 c8                	add    %ecx,%eax
  80058d:	8b 00                	mov    (%eax),%eax
  80058f:	89 02                	mov    %eax,(%edx)
	int* Left = malloc(sizeof(int) * leftCapacity);

	int* Right = malloc(sizeof(int) * rightCapacity);

	int i, j, k;
	for (i = 0; i < leftCapacity; i++)
  800591:	ff 45 ec             	incl   -0x14(%ebp)
  800594:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800597:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  80059a:	7c c9                	jl     800565 <Merge+0x5a>
	{
		Left[i] = A[p + i - 1];
	}
	for (j = 0; j < rightCapacity; j++)
  80059c:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  8005a3:	eb 2a                	jmp    8005cf <Merge+0xc4>
	{
		Right[j] = A[q + j];
  8005a5:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8005a8:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8005af:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8005b2:	01 c2                	add    %eax,%edx
  8005b4:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8005b7:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8005ba:	01 c8                	add    %ecx,%eax
  8005bc:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  8005c3:	8b 45 08             	mov    0x8(%ebp),%eax
  8005c6:	01 c8                	add    %ecx,%eax
  8005c8:	8b 00                	mov    (%eax),%eax
  8005ca:	89 02                	mov    %eax,(%edx)
	int i, j, k;
	for (i = 0; i < leftCapacity; i++)
	{
		Left[i] = A[p + i - 1];
	}
	for (j = 0; j < rightCapacity; j++)
  8005cc:	ff 45 e8             	incl   -0x18(%ebp)
  8005cf:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8005d2:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  8005d5:	7c ce                	jl     8005a5 <Merge+0x9a>
	{
		Right[j] = A[q + j];
	}

	for ( k = p; k <= r; k++)
  8005d7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8005da:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8005dd:	e9 0a 01 00 00       	jmp    8006ec <Merge+0x1e1>
	{
		if (leftIndex < leftCapacity && rightIndex < rightCapacity)
  8005e2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8005e5:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  8005e8:	0f 8d 95 00 00 00    	jge    800683 <Merge+0x178>
  8005ee:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8005f1:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  8005f4:	0f 8d 89 00 00 00    	jge    800683 <Merge+0x178>
		{
			if (Left[leftIndex] < Right[rightIndex] )
  8005fa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8005fd:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800604:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800607:	01 d0                	add    %edx,%eax
  800609:	8b 10                	mov    (%eax),%edx
  80060b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80060e:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  800615:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  800618:	01 c8                	add    %ecx,%eax
  80061a:	8b 00                	mov    (%eax),%eax
  80061c:	39 c2                	cmp    %eax,%edx
  80061e:	7d 33                	jge    800653 <Merge+0x148>
			{
				A[k - 1] = Left[leftIndex++];
  800620:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800623:	05 ff ff ff 3f       	add    $0x3fffffff,%eax
  800628:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80062f:	8b 45 08             	mov    0x8(%ebp),%eax
  800632:	8d 0c 02             	lea    (%edx,%eax,1),%ecx
  800635:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800638:	8d 50 01             	lea    0x1(%eax),%edx
  80063b:	89 55 f4             	mov    %edx,-0xc(%ebp)
  80063e:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800645:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800648:	01 d0                	add    %edx,%eax
  80064a:	8b 00                	mov    (%eax),%eax
  80064c:	89 01                	mov    %eax,(%ecx)

	for ( k = p; k <= r; k++)
	{
		if (leftIndex < leftCapacity && rightIndex < rightCapacity)
		{
			if (Left[leftIndex] < Right[rightIndex] )
  80064e:	e9 96 00 00 00       	jmp    8006e9 <Merge+0x1de>
			{
				A[k - 1] = Left[leftIndex++];
			}
			else
			{
				A[k - 1] = Right[rightIndex++];
  800653:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800656:	05 ff ff ff 3f       	add    $0x3fffffff,%eax
  80065b:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800662:	8b 45 08             	mov    0x8(%ebp),%eax
  800665:	8d 0c 02             	lea    (%edx,%eax,1),%ecx
  800668:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80066b:	8d 50 01             	lea    0x1(%eax),%edx
  80066e:	89 55 f0             	mov    %edx,-0x10(%ebp)
  800671:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800678:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80067b:	01 d0                	add    %edx,%eax
  80067d:	8b 00                	mov    (%eax),%eax
  80067f:	89 01                	mov    %eax,(%ecx)

	for ( k = p; k <= r; k++)
	{
		if (leftIndex < leftCapacity && rightIndex < rightCapacity)
		{
			if (Left[leftIndex] < Right[rightIndex] )
  800681:	eb 66                	jmp    8006e9 <Merge+0x1de>
			else
			{
				A[k - 1] = Right[rightIndex++];
			}
		}
		else if (leftIndex < leftCapacity)
  800683:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800686:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  800689:	7d 30                	jge    8006bb <Merge+0x1b0>
		{
			A[k - 1] = Left[leftIndex++];
  80068b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80068e:	05 ff ff ff 3f       	add    $0x3fffffff,%eax
  800693:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80069a:	8b 45 08             	mov    0x8(%ebp),%eax
  80069d:	8d 0c 02             	lea    (%edx,%eax,1),%ecx
  8006a0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8006a3:	8d 50 01             	lea    0x1(%eax),%edx
  8006a6:	89 55 f4             	mov    %edx,-0xc(%ebp)
  8006a9:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8006b0:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8006b3:	01 d0                	add    %edx,%eax
  8006b5:	8b 00                	mov    (%eax),%eax
  8006b7:	89 01                	mov    %eax,(%ecx)
  8006b9:	eb 2e                	jmp    8006e9 <Merge+0x1de>
		}
		else
		{
			A[k - 1] = Right[rightIndex++];
  8006bb:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8006be:	05 ff ff ff 3f       	add    $0x3fffffff,%eax
  8006c3:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8006ca:	8b 45 08             	mov    0x8(%ebp),%eax
  8006cd:	8d 0c 02             	lea    (%edx,%eax,1),%ecx
  8006d0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8006d3:	8d 50 01             	lea    0x1(%eax),%edx
  8006d6:	89 55 f0             	mov    %edx,-0x10(%ebp)
  8006d9:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8006e0:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8006e3:	01 d0                	add    %edx,%eax
  8006e5:	8b 00                	mov    (%eax),%eax
  8006e7:	89 01                	mov    %eax,(%ecx)
	for (j = 0; j < rightCapacity; j++)
	{
		Right[j] = A[q + j];
	}

	for ( k = p; k <= r; k++)
  8006e9:	ff 45 e4             	incl   -0x1c(%ebp)
  8006ec:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8006ef:	3b 45 14             	cmp    0x14(%ebp),%eax
  8006f2:	0f 8e ea fe ff ff    	jle    8005e2 <Merge+0xd7>
		{
			A[k - 1] = Right[rightIndex++];
		}
	}

	free(Left);
  8006f8:	83 ec 0c             	sub    $0xc,%esp
  8006fb:	ff 75 d8             	pushl  -0x28(%ebp)
  8006fe:	e8 b7 14 00 00       	call   801bba <free>
  800703:	83 c4 10             	add    $0x10,%esp
	free(Right);
  800706:	83 ec 0c             	sub    $0xc,%esp
  800709:	ff 75 d4             	pushl  -0x2c(%ebp)
  80070c:	e8 a9 14 00 00       	call   801bba <free>
  800711:	83 c4 10             	add    $0x10,%esp

}
  800714:	90                   	nop
  800715:	c9                   	leave  
  800716:	c3                   	ret    

00800717 <cputchar>:
#include <inc/lib.h>


void
cputchar(int ch)
{
  800717:	55                   	push   %ebp
  800718:	89 e5                	mov    %esp,%ebp
  80071a:	83 ec 18             	sub    $0x18,%esp
	char c = ch;
  80071d:	8b 45 08             	mov    0x8(%ebp),%eax
  800720:	88 45 f7             	mov    %al,-0x9(%ebp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	//sys_cputs(&c, 1);

	sys_cputc(c);
  800723:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
  800727:	83 ec 0c             	sub    $0xc,%esp
  80072a:	50                   	push   %eax
  80072b:	e8 36 19 00 00       	call   802066 <sys_cputc>
  800730:	83 c4 10             	add    $0x10,%esp
}
  800733:	90                   	nop
  800734:	c9                   	leave  
  800735:	c3                   	ret    

00800736 <atomic_cputchar>:


void
atomic_cputchar(int ch)
{
  800736:	55                   	push   %ebp
  800737:	89 e5                	mov    %esp,%ebp
  800739:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  80073c:	e8 f1 18 00 00       	call   802032 <sys_disable_interrupt>
	char c = ch;
  800741:	8b 45 08             	mov    0x8(%ebp),%eax
  800744:	88 45 f7             	mov    %al,-0x9(%ebp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	//sys_cputs(&c, 1);

	sys_cputc(c);
  800747:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
  80074b:	83 ec 0c             	sub    $0xc,%esp
  80074e:	50                   	push   %eax
  80074f:	e8 12 19 00 00       	call   802066 <sys_cputc>
  800754:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  800757:	e8 f0 18 00 00       	call   80204c <sys_enable_interrupt>
}
  80075c:	90                   	nop
  80075d:	c9                   	leave  
  80075e:	c3                   	ret    

0080075f <getchar>:

int
getchar(void)
{
  80075f:	55                   	push   %ebp
  800760:	89 e5                	mov    %esp,%ebp
  800762:	83 ec 18             	sub    $0x18,%esp

	//return sys_cgetc();
	int c=0;
  800765:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	while(c == 0)
  80076c:	eb 08                	jmp    800776 <getchar+0x17>
	{
		c = sys_cgetc();
  80076e:	e8 3a 17 00 00       	call   801ead <sys_cgetc>
  800773:	89 45 f4             	mov    %eax,-0xc(%ebp)
getchar(void)
{

	//return sys_cgetc();
	int c=0;
	while(c == 0)
  800776:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80077a:	74 f2                	je     80076e <getchar+0xf>
	{
		c = sys_cgetc();
	}
	return c;
  80077c:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  80077f:	c9                   	leave  
  800780:	c3                   	ret    

00800781 <atomic_getchar>:

int
atomic_getchar(void)
{
  800781:	55                   	push   %ebp
  800782:	89 e5                	mov    %esp,%ebp
  800784:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  800787:	e8 a6 18 00 00       	call   802032 <sys_disable_interrupt>
	int c=0;
  80078c:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	while(c == 0)
  800793:	eb 08                	jmp    80079d <atomic_getchar+0x1c>
	{
		c = sys_cgetc();
  800795:	e8 13 17 00 00       	call   801ead <sys_cgetc>
  80079a:	89 45 f4             	mov    %eax,-0xc(%ebp)
int
atomic_getchar(void)
{
	sys_disable_interrupt();
	int c=0;
	while(c == 0)
  80079d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8007a1:	74 f2                	je     800795 <atomic_getchar+0x14>
	{
		c = sys_cgetc();
	}
	sys_enable_interrupt();
  8007a3:	e8 a4 18 00 00       	call   80204c <sys_enable_interrupt>
	return c;
  8007a8:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  8007ab:	c9                   	leave  
  8007ac:	c3                   	ret    

008007ad <iscons>:

int iscons(int fdnum)
{
  8007ad:	55                   	push   %ebp
  8007ae:	89 e5                	mov    %esp,%ebp
	// used by readline
	return 1;
  8007b0:	b8 01 00 00 00       	mov    $0x1,%eax
}
  8007b5:	5d                   	pop    %ebp
  8007b6:	c3                   	ret    

008007b7 <libmain>:
volatile struct Env *myEnv = NULL;
volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";

void
libmain(int argc, char **argv)
{
  8007b7:	55                   	push   %ebp
  8007b8:	89 e5                	mov    %esp,%ebp
  8007ba:	83 ec 18             	sub    $0x18,%esp
	int envIndex = sys_getenvindex();
  8007bd:	e8 63 1a 00 00       	call   802225 <sys_getenvindex>
  8007c2:	89 45 f4             	mov    %eax,-0xc(%ebp)
	myEnv = &(envs[envIndex]);
  8007c5:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8007c8:	89 d0                	mov    %edx,%eax
  8007ca:	c1 e0 03             	shl    $0x3,%eax
  8007cd:	01 d0                	add    %edx,%eax
  8007cf:	01 c0                	add    %eax,%eax
  8007d1:	01 d0                	add    %edx,%eax
  8007d3:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8007da:	01 d0                	add    %edx,%eax
  8007dc:	c1 e0 04             	shl    $0x4,%eax
  8007df:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8007e4:	a3 24 50 80 00       	mov    %eax,0x805024

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  8007e9:	a1 24 50 80 00       	mov    0x805024,%eax
  8007ee:	8a 80 5c 05 00 00    	mov    0x55c(%eax),%al
  8007f4:	84 c0                	test   %al,%al
  8007f6:	74 0f                	je     800807 <libmain+0x50>
		binaryname = myEnv->prog_name;
  8007f8:	a1 24 50 80 00       	mov    0x805024,%eax
  8007fd:	05 5c 05 00 00       	add    $0x55c,%eax
  800802:	a3 00 50 80 00       	mov    %eax,0x805000

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800807:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80080b:	7e 0a                	jle    800817 <libmain+0x60>
		binaryname = argv[0];
  80080d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800810:	8b 00                	mov    (%eax),%eax
  800812:	a3 00 50 80 00       	mov    %eax,0x805000

	// call user main routine
	_main(argc, argv);
  800817:	83 ec 08             	sub    $0x8,%esp
  80081a:	ff 75 0c             	pushl  0xc(%ebp)
  80081d:	ff 75 08             	pushl  0x8(%ebp)
  800820:	e8 13 f8 ff ff       	call   800038 <_main>
  800825:	83 c4 10             	add    $0x10,%esp



	sys_disable_interrupt();
  800828:	e8 05 18 00 00       	call   802032 <sys_disable_interrupt>
	cprintf("**************************************\n");
  80082d:	83 ec 0c             	sub    $0xc,%esp
  800830:	68 38 39 80 00       	push   $0x803938
  800835:	e8 6d 03 00 00       	call   800ba7 <cprintf>
  80083a:	83 c4 10             	add    $0x10,%esp
	cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  80083d:	a1 24 50 80 00       	mov    0x805024,%eax
  800842:	8b 90 44 05 00 00    	mov    0x544(%eax),%edx
  800848:	a1 24 50 80 00       	mov    0x805024,%eax
  80084d:	8b 80 34 05 00 00    	mov    0x534(%eax),%eax
  800853:	83 ec 04             	sub    $0x4,%esp
  800856:	52                   	push   %edx
  800857:	50                   	push   %eax
  800858:	68 60 39 80 00       	push   $0x803960
  80085d:	e8 45 03 00 00       	call   800ba7 <cprintf>
  800862:	83 c4 10             	add    $0x10,%esp
	cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  800865:	a1 24 50 80 00       	mov    0x805024,%eax
  80086a:	8b 88 54 05 00 00    	mov    0x554(%eax),%ecx
  800870:	a1 24 50 80 00       	mov    0x805024,%eax
  800875:	8b 90 50 05 00 00    	mov    0x550(%eax),%edx
  80087b:	a1 24 50 80 00       	mov    0x805024,%eax
  800880:	8b 80 4c 05 00 00    	mov    0x54c(%eax),%eax
  800886:	51                   	push   %ecx
  800887:	52                   	push   %edx
  800888:	50                   	push   %eax
  800889:	68 88 39 80 00       	push   $0x803988
  80088e:	e8 14 03 00 00       	call   800ba7 <cprintf>
  800893:	83 c4 10             	add    $0x10,%esp
	//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
	cprintf("Num of clocks = %d\n", myEnv->nClocks);
  800896:	a1 24 50 80 00       	mov    0x805024,%eax
  80089b:	8b 80 a4 05 00 00    	mov    0x5a4(%eax),%eax
  8008a1:	83 ec 08             	sub    $0x8,%esp
  8008a4:	50                   	push   %eax
  8008a5:	68 e0 39 80 00       	push   $0x8039e0
  8008aa:	e8 f8 02 00 00       	call   800ba7 <cprintf>
  8008af:	83 c4 10             	add    $0x10,%esp
	cprintf("**************************************\n");
  8008b2:	83 ec 0c             	sub    $0xc,%esp
  8008b5:	68 38 39 80 00       	push   $0x803938
  8008ba:	e8 e8 02 00 00       	call   800ba7 <cprintf>
  8008bf:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  8008c2:	e8 85 17 00 00       	call   80204c <sys_enable_interrupt>

	// exit gracefully
	exit();
  8008c7:	e8 19 00 00 00       	call   8008e5 <exit>
}
  8008cc:	90                   	nop
  8008cd:	c9                   	leave  
  8008ce:	c3                   	ret    

008008cf <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  8008cf:	55                   	push   %ebp
  8008d0:	89 e5                	mov    %esp,%ebp
  8008d2:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  8008d5:	83 ec 0c             	sub    $0xc,%esp
  8008d8:	6a 00                	push   $0x0
  8008da:	e8 12 19 00 00       	call   8021f1 <sys_destroy_env>
  8008df:	83 c4 10             	add    $0x10,%esp
}
  8008e2:	90                   	nop
  8008e3:	c9                   	leave  
  8008e4:	c3                   	ret    

008008e5 <exit>:

void
exit(void)
{
  8008e5:	55                   	push   %ebp
  8008e6:	89 e5                	mov    %esp,%ebp
  8008e8:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  8008eb:	e8 67 19 00 00       	call   802257 <sys_exit_env>
}
  8008f0:	90                   	nop
  8008f1:	c9                   	leave  
  8008f2:	c3                   	ret    

008008f3 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  8008f3:	55                   	push   %ebp
  8008f4:	89 e5                	mov    %esp,%ebp
  8008f6:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  8008f9:	8d 45 10             	lea    0x10(%ebp),%eax
  8008fc:	83 c0 04             	add    $0x4,%eax
  8008ff:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  800902:	a1 5c 51 80 00       	mov    0x80515c,%eax
  800907:	85 c0                	test   %eax,%eax
  800909:	74 16                	je     800921 <_panic+0x2e>
		cprintf("%s: ", argv0);
  80090b:	a1 5c 51 80 00       	mov    0x80515c,%eax
  800910:	83 ec 08             	sub    $0x8,%esp
  800913:	50                   	push   %eax
  800914:	68 f4 39 80 00       	push   $0x8039f4
  800919:	e8 89 02 00 00       	call   800ba7 <cprintf>
  80091e:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  800921:	a1 00 50 80 00       	mov    0x805000,%eax
  800926:	ff 75 0c             	pushl  0xc(%ebp)
  800929:	ff 75 08             	pushl  0x8(%ebp)
  80092c:	50                   	push   %eax
  80092d:	68 f9 39 80 00       	push   $0x8039f9
  800932:	e8 70 02 00 00       	call   800ba7 <cprintf>
  800937:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  80093a:	8b 45 10             	mov    0x10(%ebp),%eax
  80093d:	83 ec 08             	sub    $0x8,%esp
  800940:	ff 75 f4             	pushl  -0xc(%ebp)
  800943:	50                   	push   %eax
  800944:	e8 f3 01 00 00       	call   800b3c <vcprintf>
  800949:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  80094c:	83 ec 08             	sub    $0x8,%esp
  80094f:	6a 00                	push   $0x0
  800951:	68 15 3a 80 00       	push   $0x803a15
  800956:	e8 e1 01 00 00       	call   800b3c <vcprintf>
  80095b:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  80095e:	e8 82 ff ff ff       	call   8008e5 <exit>

	// should not return here
	while (1) ;
  800963:	eb fe                	jmp    800963 <_panic+0x70>

00800965 <CheckWSWithoutLastIndex>:
}

void CheckWSWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  800965:	55                   	push   %ebp
  800966:	89 e5                	mov    %esp,%ebp
  800968:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  80096b:	a1 24 50 80 00       	mov    0x805024,%eax
  800970:	8b 50 74             	mov    0x74(%eax),%edx
  800973:	8b 45 0c             	mov    0xc(%ebp),%eax
  800976:	39 c2                	cmp    %eax,%edx
  800978:	74 14                	je     80098e <CheckWSWithoutLastIndex+0x29>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  80097a:	83 ec 04             	sub    $0x4,%esp
  80097d:	68 18 3a 80 00       	push   $0x803a18
  800982:	6a 26                	push   $0x26
  800984:	68 64 3a 80 00       	push   $0x803a64
  800989:	e8 65 ff ff ff       	call   8008f3 <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  80098e:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  800995:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  80099c:	e9 c2 00 00 00       	jmp    800a63 <CheckWSWithoutLastIndex+0xfe>
		if (expectedPages[e] == 0) {
  8009a1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8009a4:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8009ab:	8b 45 08             	mov    0x8(%ebp),%eax
  8009ae:	01 d0                	add    %edx,%eax
  8009b0:	8b 00                	mov    (%eax),%eax
  8009b2:	85 c0                	test   %eax,%eax
  8009b4:	75 08                	jne    8009be <CheckWSWithoutLastIndex+0x59>
			expectedNumOfEmptyLocs++;
  8009b6:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  8009b9:	e9 a2 00 00 00       	jmp    800a60 <CheckWSWithoutLastIndex+0xfb>
		}
		int found = 0;
  8009be:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8009c5:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  8009cc:	eb 69                	jmp    800a37 <CheckWSWithoutLastIndex+0xd2>
			if (myEnv->__uptr_pws[w].empty == 0) {
  8009ce:	a1 24 50 80 00       	mov    0x805024,%eax
  8009d3:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  8009d9:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8009dc:	89 d0                	mov    %edx,%eax
  8009de:	01 c0                	add    %eax,%eax
  8009e0:	01 d0                	add    %edx,%eax
  8009e2:	c1 e0 03             	shl    $0x3,%eax
  8009e5:	01 c8                	add    %ecx,%eax
  8009e7:	8a 40 04             	mov    0x4(%eax),%al
  8009ea:	84 c0                	test   %al,%al
  8009ec:	75 46                	jne    800a34 <CheckWSWithoutLastIndex+0xcf>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  8009ee:	a1 24 50 80 00       	mov    0x805024,%eax
  8009f3:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  8009f9:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8009fc:	89 d0                	mov    %edx,%eax
  8009fe:	01 c0                	add    %eax,%eax
  800a00:	01 d0                	add    %edx,%eax
  800a02:	c1 e0 03             	shl    $0x3,%eax
  800a05:	01 c8                	add    %ecx,%eax
  800a07:	8b 00                	mov    (%eax),%eax
  800a09:	89 45 dc             	mov    %eax,-0x24(%ebp)
  800a0c:	8b 45 dc             	mov    -0x24(%ebp),%eax
  800a0f:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800a14:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  800a16:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800a19:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  800a20:	8b 45 08             	mov    0x8(%ebp),%eax
  800a23:	01 c8                	add    %ecx,%eax
  800a25:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  800a27:	39 c2                	cmp    %eax,%edx
  800a29:	75 09                	jne    800a34 <CheckWSWithoutLastIndex+0xcf>
						== expectedPages[e]) {
					found = 1;
  800a2b:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  800a32:	eb 12                	jmp    800a46 <CheckWSWithoutLastIndex+0xe1>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800a34:	ff 45 e8             	incl   -0x18(%ebp)
  800a37:	a1 24 50 80 00       	mov    0x805024,%eax
  800a3c:	8b 50 74             	mov    0x74(%eax),%edx
  800a3f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800a42:	39 c2                	cmp    %eax,%edx
  800a44:	77 88                	ja     8009ce <CheckWSWithoutLastIndex+0x69>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  800a46:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  800a4a:	75 14                	jne    800a60 <CheckWSWithoutLastIndex+0xfb>
			panic(
  800a4c:	83 ec 04             	sub    $0x4,%esp
  800a4f:	68 70 3a 80 00       	push   $0x803a70
  800a54:	6a 3a                	push   $0x3a
  800a56:	68 64 3a 80 00       	push   $0x803a64
  800a5b:	e8 93 fe ff ff       	call   8008f3 <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  800a60:	ff 45 f0             	incl   -0x10(%ebp)
  800a63:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800a66:	3b 45 0c             	cmp    0xc(%ebp),%eax
  800a69:	0f 8c 32 ff ff ff    	jl     8009a1 <CheckWSWithoutLastIndex+0x3c>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  800a6f:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800a76:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  800a7d:	eb 26                	jmp    800aa5 <CheckWSWithoutLastIndex+0x140>
		if (myEnv->__uptr_pws[w].empty == 1) {
  800a7f:	a1 24 50 80 00       	mov    0x805024,%eax
  800a84:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  800a8a:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800a8d:	89 d0                	mov    %edx,%eax
  800a8f:	01 c0                	add    %eax,%eax
  800a91:	01 d0                	add    %edx,%eax
  800a93:	c1 e0 03             	shl    $0x3,%eax
  800a96:	01 c8                	add    %ecx,%eax
  800a98:	8a 40 04             	mov    0x4(%eax),%al
  800a9b:	3c 01                	cmp    $0x1,%al
  800a9d:	75 03                	jne    800aa2 <CheckWSWithoutLastIndex+0x13d>
			actualNumOfEmptyLocs++;
  800a9f:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800aa2:	ff 45 e0             	incl   -0x20(%ebp)
  800aa5:	a1 24 50 80 00       	mov    0x805024,%eax
  800aaa:	8b 50 74             	mov    0x74(%eax),%edx
  800aad:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800ab0:	39 c2                	cmp    %eax,%edx
  800ab2:	77 cb                	ja     800a7f <CheckWSWithoutLastIndex+0x11a>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  800ab4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800ab7:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  800aba:	74 14                	je     800ad0 <CheckWSWithoutLastIndex+0x16b>
		panic(
  800abc:	83 ec 04             	sub    $0x4,%esp
  800abf:	68 c4 3a 80 00       	push   $0x803ac4
  800ac4:	6a 44                	push   $0x44
  800ac6:	68 64 3a 80 00       	push   $0x803a64
  800acb:	e8 23 fe ff ff       	call   8008f3 <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  800ad0:	90                   	nop
  800ad1:	c9                   	leave  
  800ad2:	c3                   	ret    

00800ad3 <putch>:
};

//2017:
uint8 printProgName = 0;

static void putch(int ch, struct printbuf *b) {
  800ad3:	55                   	push   %ebp
  800ad4:	89 e5                	mov    %esp,%ebp
  800ad6:	83 ec 08             	sub    $0x8,%esp
	b->buf[b->idx++] = ch;
  800ad9:	8b 45 0c             	mov    0xc(%ebp),%eax
  800adc:	8b 00                	mov    (%eax),%eax
  800ade:	8d 48 01             	lea    0x1(%eax),%ecx
  800ae1:	8b 55 0c             	mov    0xc(%ebp),%edx
  800ae4:	89 0a                	mov    %ecx,(%edx)
  800ae6:	8b 55 08             	mov    0x8(%ebp),%edx
  800ae9:	88 d1                	mov    %dl,%cl
  800aeb:	8b 55 0c             	mov    0xc(%ebp),%edx
  800aee:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  800af2:	8b 45 0c             	mov    0xc(%ebp),%eax
  800af5:	8b 00                	mov    (%eax),%eax
  800af7:	3d ff 00 00 00       	cmp    $0xff,%eax
  800afc:	75 2c                	jne    800b2a <putch+0x57>
		sys_cputs(b->buf, b->idx, printProgName);
  800afe:	a0 28 50 80 00       	mov    0x805028,%al
  800b03:	0f b6 c0             	movzbl %al,%eax
  800b06:	8b 55 0c             	mov    0xc(%ebp),%edx
  800b09:	8b 12                	mov    (%edx),%edx
  800b0b:	89 d1                	mov    %edx,%ecx
  800b0d:	8b 55 0c             	mov    0xc(%ebp),%edx
  800b10:	83 c2 08             	add    $0x8,%edx
  800b13:	83 ec 04             	sub    $0x4,%esp
  800b16:	50                   	push   %eax
  800b17:	51                   	push   %ecx
  800b18:	52                   	push   %edx
  800b19:	e8 66 13 00 00       	call   801e84 <sys_cputs>
  800b1e:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  800b21:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b24:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  800b2a:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b2d:	8b 40 04             	mov    0x4(%eax),%eax
  800b30:	8d 50 01             	lea    0x1(%eax),%edx
  800b33:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b36:	89 50 04             	mov    %edx,0x4(%eax)
}
  800b39:	90                   	nop
  800b3a:	c9                   	leave  
  800b3b:	c3                   	ret    

00800b3c <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  800b3c:	55                   	push   %ebp
  800b3d:	89 e5                	mov    %esp,%ebp
  800b3f:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  800b45:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800b4c:	00 00 00 
	b.cnt = 0;
  800b4f:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800b56:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  800b59:	ff 75 0c             	pushl  0xc(%ebp)
  800b5c:	ff 75 08             	pushl  0x8(%ebp)
  800b5f:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800b65:	50                   	push   %eax
  800b66:	68 d3 0a 80 00       	push   $0x800ad3
  800b6b:	e8 11 02 00 00       	call   800d81 <vprintfmt>
  800b70:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName);
  800b73:	a0 28 50 80 00       	mov    0x805028,%al
  800b78:	0f b6 c0             	movzbl %al,%eax
  800b7b:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  800b81:	83 ec 04             	sub    $0x4,%esp
  800b84:	50                   	push   %eax
  800b85:	52                   	push   %edx
  800b86:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800b8c:	83 c0 08             	add    $0x8,%eax
  800b8f:	50                   	push   %eax
  800b90:	e8 ef 12 00 00       	call   801e84 <sys_cputs>
  800b95:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  800b98:	c6 05 28 50 80 00 00 	movb   $0x0,0x805028
	return b.cnt;
  800b9f:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  800ba5:	c9                   	leave  
  800ba6:	c3                   	ret    

00800ba7 <cprintf>:

int cprintf(const char *fmt, ...) {
  800ba7:	55                   	push   %ebp
  800ba8:	89 e5                	mov    %esp,%ebp
  800baa:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  800bad:	c6 05 28 50 80 00 01 	movb   $0x1,0x805028
	va_start(ap, fmt);
  800bb4:	8d 45 0c             	lea    0xc(%ebp),%eax
  800bb7:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800bba:	8b 45 08             	mov    0x8(%ebp),%eax
  800bbd:	83 ec 08             	sub    $0x8,%esp
  800bc0:	ff 75 f4             	pushl  -0xc(%ebp)
  800bc3:	50                   	push   %eax
  800bc4:	e8 73 ff ff ff       	call   800b3c <vcprintf>
  800bc9:	83 c4 10             	add    $0x10,%esp
  800bcc:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  800bcf:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800bd2:	c9                   	leave  
  800bd3:	c3                   	ret    

00800bd4 <atomic_cprintf>:

int atomic_cprintf(const char *fmt, ...) {
  800bd4:	55                   	push   %ebp
  800bd5:	89 e5                	mov    %esp,%ebp
  800bd7:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  800bda:	e8 53 14 00 00       	call   802032 <sys_disable_interrupt>
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  800bdf:	8d 45 0c             	lea    0xc(%ebp),%eax
  800be2:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800be5:	8b 45 08             	mov    0x8(%ebp),%eax
  800be8:	83 ec 08             	sub    $0x8,%esp
  800beb:	ff 75 f4             	pushl  -0xc(%ebp)
  800bee:	50                   	push   %eax
  800bef:	e8 48 ff ff ff       	call   800b3c <vcprintf>
  800bf4:	83 c4 10             	add    $0x10,%esp
  800bf7:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	sys_enable_interrupt();
  800bfa:	e8 4d 14 00 00       	call   80204c <sys_enable_interrupt>
	return cnt;
  800bff:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800c02:	c9                   	leave  
  800c03:	c3                   	ret    

00800c04 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800c04:	55                   	push   %ebp
  800c05:	89 e5                	mov    %esp,%ebp
  800c07:	53                   	push   %ebx
  800c08:	83 ec 14             	sub    $0x14,%esp
  800c0b:	8b 45 10             	mov    0x10(%ebp),%eax
  800c0e:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800c11:	8b 45 14             	mov    0x14(%ebp),%eax
  800c14:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800c17:	8b 45 18             	mov    0x18(%ebp),%eax
  800c1a:	ba 00 00 00 00       	mov    $0x0,%edx
  800c1f:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800c22:	77 55                	ja     800c79 <printnum+0x75>
  800c24:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800c27:	72 05                	jb     800c2e <printnum+0x2a>
  800c29:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800c2c:	77 4b                	ja     800c79 <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800c2e:	8b 45 1c             	mov    0x1c(%ebp),%eax
  800c31:	8d 58 ff             	lea    -0x1(%eax),%ebx
  800c34:	8b 45 18             	mov    0x18(%ebp),%eax
  800c37:	ba 00 00 00 00       	mov    $0x0,%edx
  800c3c:	52                   	push   %edx
  800c3d:	50                   	push   %eax
  800c3e:	ff 75 f4             	pushl  -0xc(%ebp)
  800c41:	ff 75 f0             	pushl  -0x10(%ebp)
  800c44:	e8 87 28 00 00       	call   8034d0 <__udivdi3>
  800c49:	83 c4 10             	add    $0x10,%esp
  800c4c:	83 ec 04             	sub    $0x4,%esp
  800c4f:	ff 75 20             	pushl  0x20(%ebp)
  800c52:	53                   	push   %ebx
  800c53:	ff 75 18             	pushl  0x18(%ebp)
  800c56:	52                   	push   %edx
  800c57:	50                   	push   %eax
  800c58:	ff 75 0c             	pushl  0xc(%ebp)
  800c5b:	ff 75 08             	pushl  0x8(%ebp)
  800c5e:	e8 a1 ff ff ff       	call   800c04 <printnum>
  800c63:	83 c4 20             	add    $0x20,%esp
  800c66:	eb 1a                	jmp    800c82 <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800c68:	83 ec 08             	sub    $0x8,%esp
  800c6b:	ff 75 0c             	pushl  0xc(%ebp)
  800c6e:	ff 75 20             	pushl  0x20(%ebp)
  800c71:	8b 45 08             	mov    0x8(%ebp),%eax
  800c74:	ff d0                	call   *%eax
  800c76:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800c79:	ff 4d 1c             	decl   0x1c(%ebp)
  800c7c:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  800c80:	7f e6                	jg     800c68 <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800c82:	8b 4d 18             	mov    0x18(%ebp),%ecx
  800c85:	bb 00 00 00 00       	mov    $0x0,%ebx
  800c8a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800c8d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800c90:	53                   	push   %ebx
  800c91:	51                   	push   %ecx
  800c92:	52                   	push   %edx
  800c93:	50                   	push   %eax
  800c94:	e8 47 29 00 00       	call   8035e0 <__umoddi3>
  800c99:	83 c4 10             	add    $0x10,%esp
  800c9c:	05 34 3d 80 00       	add    $0x803d34,%eax
  800ca1:	8a 00                	mov    (%eax),%al
  800ca3:	0f be c0             	movsbl %al,%eax
  800ca6:	83 ec 08             	sub    $0x8,%esp
  800ca9:	ff 75 0c             	pushl  0xc(%ebp)
  800cac:	50                   	push   %eax
  800cad:	8b 45 08             	mov    0x8(%ebp),%eax
  800cb0:	ff d0                	call   *%eax
  800cb2:	83 c4 10             	add    $0x10,%esp
}
  800cb5:	90                   	nop
  800cb6:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800cb9:	c9                   	leave  
  800cba:	c3                   	ret    

00800cbb <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  800cbb:	55                   	push   %ebp
  800cbc:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800cbe:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800cc2:	7e 1c                	jle    800ce0 <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  800cc4:	8b 45 08             	mov    0x8(%ebp),%eax
  800cc7:	8b 00                	mov    (%eax),%eax
  800cc9:	8d 50 08             	lea    0x8(%eax),%edx
  800ccc:	8b 45 08             	mov    0x8(%ebp),%eax
  800ccf:	89 10                	mov    %edx,(%eax)
  800cd1:	8b 45 08             	mov    0x8(%ebp),%eax
  800cd4:	8b 00                	mov    (%eax),%eax
  800cd6:	83 e8 08             	sub    $0x8,%eax
  800cd9:	8b 50 04             	mov    0x4(%eax),%edx
  800cdc:	8b 00                	mov    (%eax),%eax
  800cde:	eb 40                	jmp    800d20 <getuint+0x65>
	else if (lflag)
  800ce0:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800ce4:	74 1e                	je     800d04 <getuint+0x49>
		return va_arg(*ap, unsigned long);
  800ce6:	8b 45 08             	mov    0x8(%ebp),%eax
  800ce9:	8b 00                	mov    (%eax),%eax
  800ceb:	8d 50 04             	lea    0x4(%eax),%edx
  800cee:	8b 45 08             	mov    0x8(%ebp),%eax
  800cf1:	89 10                	mov    %edx,(%eax)
  800cf3:	8b 45 08             	mov    0x8(%ebp),%eax
  800cf6:	8b 00                	mov    (%eax),%eax
  800cf8:	83 e8 04             	sub    $0x4,%eax
  800cfb:	8b 00                	mov    (%eax),%eax
  800cfd:	ba 00 00 00 00       	mov    $0x0,%edx
  800d02:	eb 1c                	jmp    800d20 <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  800d04:	8b 45 08             	mov    0x8(%ebp),%eax
  800d07:	8b 00                	mov    (%eax),%eax
  800d09:	8d 50 04             	lea    0x4(%eax),%edx
  800d0c:	8b 45 08             	mov    0x8(%ebp),%eax
  800d0f:	89 10                	mov    %edx,(%eax)
  800d11:	8b 45 08             	mov    0x8(%ebp),%eax
  800d14:	8b 00                	mov    (%eax),%eax
  800d16:	83 e8 04             	sub    $0x4,%eax
  800d19:	8b 00                	mov    (%eax),%eax
  800d1b:	ba 00 00 00 00       	mov    $0x0,%edx
}
  800d20:	5d                   	pop    %ebp
  800d21:	c3                   	ret    

00800d22 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  800d22:	55                   	push   %ebp
  800d23:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800d25:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800d29:	7e 1c                	jle    800d47 <getint+0x25>
		return va_arg(*ap, long long);
  800d2b:	8b 45 08             	mov    0x8(%ebp),%eax
  800d2e:	8b 00                	mov    (%eax),%eax
  800d30:	8d 50 08             	lea    0x8(%eax),%edx
  800d33:	8b 45 08             	mov    0x8(%ebp),%eax
  800d36:	89 10                	mov    %edx,(%eax)
  800d38:	8b 45 08             	mov    0x8(%ebp),%eax
  800d3b:	8b 00                	mov    (%eax),%eax
  800d3d:	83 e8 08             	sub    $0x8,%eax
  800d40:	8b 50 04             	mov    0x4(%eax),%edx
  800d43:	8b 00                	mov    (%eax),%eax
  800d45:	eb 38                	jmp    800d7f <getint+0x5d>
	else if (lflag)
  800d47:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800d4b:	74 1a                	je     800d67 <getint+0x45>
		return va_arg(*ap, long);
  800d4d:	8b 45 08             	mov    0x8(%ebp),%eax
  800d50:	8b 00                	mov    (%eax),%eax
  800d52:	8d 50 04             	lea    0x4(%eax),%edx
  800d55:	8b 45 08             	mov    0x8(%ebp),%eax
  800d58:	89 10                	mov    %edx,(%eax)
  800d5a:	8b 45 08             	mov    0x8(%ebp),%eax
  800d5d:	8b 00                	mov    (%eax),%eax
  800d5f:	83 e8 04             	sub    $0x4,%eax
  800d62:	8b 00                	mov    (%eax),%eax
  800d64:	99                   	cltd   
  800d65:	eb 18                	jmp    800d7f <getint+0x5d>
	else
		return va_arg(*ap, int);
  800d67:	8b 45 08             	mov    0x8(%ebp),%eax
  800d6a:	8b 00                	mov    (%eax),%eax
  800d6c:	8d 50 04             	lea    0x4(%eax),%edx
  800d6f:	8b 45 08             	mov    0x8(%ebp),%eax
  800d72:	89 10                	mov    %edx,(%eax)
  800d74:	8b 45 08             	mov    0x8(%ebp),%eax
  800d77:	8b 00                	mov    (%eax),%eax
  800d79:	83 e8 04             	sub    $0x4,%eax
  800d7c:	8b 00                	mov    (%eax),%eax
  800d7e:	99                   	cltd   
}
  800d7f:	5d                   	pop    %ebp
  800d80:	c3                   	ret    

00800d81 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  800d81:	55                   	push   %ebp
  800d82:	89 e5                	mov    %esp,%ebp
  800d84:	56                   	push   %esi
  800d85:	53                   	push   %ebx
  800d86:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800d89:	eb 17                	jmp    800da2 <vprintfmt+0x21>
			if (ch == '\0')
  800d8b:	85 db                	test   %ebx,%ebx
  800d8d:	0f 84 af 03 00 00    	je     801142 <vprintfmt+0x3c1>
				return;
			putch(ch, putdat);
  800d93:	83 ec 08             	sub    $0x8,%esp
  800d96:	ff 75 0c             	pushl  0xc(%ebp)
  800d99:	53                   	push   %ebx
  800d9a:	8b 45 08             	mov    0x8(%ebp),%eax
  800d9d:	ff d0                	call   *%eax
  800d9f:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800da2:	8b 45 10             	mov    0x10(%ebp),%eax
  800da5:	8d 50 01             	lea    0x1(%eax),%edx
  800da8:	89 55 10             	mov    %edx,0x10(%ebp)
  800dab:	8a 00                	mov    (%eax),%al
  800dad:	0f b6 d8             	movzbl %al,%ebx
  800db0:	83 fb 25             	cmp    $0x25,%ebx
  800db3:	75 d6                	jne    800d8b <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  800db5:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  800db9:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  800dc0:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  800dc7:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  800dce:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800dd5:	8b 45 10             	mov    0x10(%ebp),%eax
  800dd8:	8d 50 01             	lea    0x1(%eax),%edx
  800ddb:	89 55 10             	mov    %edx,0x10(%ebp)
  800dde:	8a 00                	mov    (%eax),%al
  800de0:	0f b6 d8             	movzbl %al,%ebx
  800de3:	8d 43 dd             	lea    -0x23(%ebx),%eax
  800de6:	83 f8 55             	cmp    $0x55,%eax
  800de9:	0f 87 2b 03 00 00    	ja     80111a <vprintfmt+0x399>
  800def:	8b 04 85 58 3d 80 00 	mov    0x803d58(,%eax,4),%eax
  800df6:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  800df8:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  800dfc:	eb d7                	jmp    800dd5 <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800dfe:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  800e02:	eb d1                	jmp    800dd5 <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800e04:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  800e0b:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800e0e:	89 d0                	mov    %edx,%eax
  800e10:	c1 e0 02             	shl    $0x2,%eax
  800e13:	01 d0                	add    %edx,%eax
  800e15:	01 c0                	add    %eax,%eax
  800e17:	01 d8                	add    %ebx,%eax
  800e19:	83 e8 30             	sub    $0x30,%eax
  800e1c:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  800e1f:	8b 45 10             	mov    0x10(%ebp),%eax
  800e22:	8a 00                	mov    (%eax),%al
  800e24:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  800e27:	83 fb 2f             	cmp    $0x2f,%ebx
  800e2a:	7e 3e                	jle    800e6a <vprintfmt+0xe9>
  800e2c:	83 fb 39             	cmp    $0x39,%ebx
  800e2f:	7f 39                	jg     800e6a <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800e31:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800e34:	eb d5                	jmp    800e0b <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  800e36:	8b 45 14             	mov    0x14(%ebp),%eax
  800e39:	83 c0 04             	add    $0x4,%eax
  800e3c:	89 45 14             	mov    %eax,0x14(%ebp)
  800e3f:	8b 45 14             	mov    0x14(%ebp),%eax
  800e42:	83 e8 04             	sub    $0x4,%eax
  800e45:	8b 00                	mov    (%eax),%eax
  800e47:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  800e4a:	eb 1f                	jmp    800e6b <vprintfmt+0xea>

		case '.':
			if (width < 0)
  800e4c:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800e50:	79 83                	jns    800dd5 <vprintfmt+0x54>
				width = 0;
  800e52:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  800e59:	e9 77 ff ff ff       	jmp    800dd5 <vprintfmt+0x54>

		case '#':
			altflag = 1;
  800e5e:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  800e65:	e9 6b ff ff ff       	jmp    800dd5 <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  800e6a:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  800e6b:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800e6f:	0f 89 60 ff ff ff    	jns    800dd5 <vprintfmt+0x54>
				width = precision, precision = -1;
  800e75:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800e78:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800e7b:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  800e82:	e9 4e ff ff ff       	jmp    800dd5 <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  800e87:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  800e8a:	e9 46 ff ff ff       	jmp    800dd5 <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  800e8f:	8b 45 14             	mov    0x14(%ebp),%eax
  800e92:	83 c0 04             	add    $0x4,%eax
  800e95:	89 45 14             	mov    %eax,0x14(%ebp)
  800e98:	8b 45 14             	mov    0x14(%ebp),%eax
  800e9b:	83 e8 04             	sub    $0x4,%eax
  800e9e:	8b 00                	mov    (%eax),%eax
  800ea0:	83 ec 08             	sub    $0x8,%esp
  800ea3:	ff 75 0c             	pushl  0xc(%ebp)
  800ea6:	50                   	push   %eax
  800ea7:	8b 45 08             	mov    0x8(%ebp),%eax
  800eaa:	ff d0                	call   *%eax
  800eac:	83 c4 10             	add    $0x10,%esp
			break;
  800eaf:	e9 89 02 00 00       	jmp    80113d <vprintfmt+0x3bc>

		// error message
		case 'e':
			err = va_arg(ap, int);
  800eb4:	8b 45 14             	mov    0x14(%ebp),%eax
  800eb7:	83 c0 04             	add    $0x4,%eax
  800eba:	89 45 14             	mov    %eax,0x14(%ebp)
  800ebd:	8b 45 14             	mov    0x14(%ebp),%eax
  800ec0:	83 e8 04             	sub    $0x4,%eax
  800ec3:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  800ec5:	85 db                	test   %ebx,%ebx
  800ec7:	79 02                	jns    800ecb <vprintfmt+0x14a>
				err = -err;
  800ec9:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  800ecb:	83 fb 64             	cmp    $0x64,%ebx
  800ece:	7f 0b                	jg     800edb <vprintfmt+0x15a>
  800ed0:	8b 34 9d a0 3b 80 00 	mov    0x803ba0(,%ebx,4),%esi
  800ed7:	85 f6                	test   %esi,%esi
  800ed9:	75 19                	jne    800ef4 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  800edb:	53                   	push   %ebx
  800edc:	68 45 3d 80 00       	push   $0x803d45
  800ee1:	ff 75 0c             	pushl  0xc(%ebp)
  800ee4:	ff 75 08             	pushl  0x8(%ebp)
  800ee7:	e8 5e 02 00 00       	call   80114a <printfmt>
  800eec:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800eef:	e9 49 02 00 00       	jmp    80113d <vprintfmt+0x3bc>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800ef4:	56                   	push   %esi
  800ef5:	68 4e 3d 80 00       	push   $0x803d4e
  800efa:	ff 75 0c             	pushl  0xc(%ebp)
  800efd:	ff 75 08             	pushl  0x8(%ebp)
  800f00:	e8 45 02 00 00       	call   80114a <printfmt>
  800f05:	83 c4 10             	add    $0x10,%esp
			break;
  800f08:	e9 30 02 00 00       	jmp    80113d <vprintfmt+0x3bc>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  800f0d:	8b 45 14             	mov    0x14(%ebp),%eax
  800f10:	83 c0 04             	add    $0x4,%eax
  800f13:	89 45 14             	mov    %eax,0x14(%ebp)
  800f16:	8b 45 14             	mov    0x14(%ebp),%eax
  800f19:	83 e8 04             	sub    $0x4,%eax
  800f1c:	8b 30                	mov    (%eax),%esi
  800f1e:	85 f6                	test   %esi,%esi
  800f20:	75 05                	jne    800f27 <vprintfmt+0x1a6>
				p = "(null)";
  800f22:	be 51 3d 80 00       	mov    $0x803d51,%esi
			if (width > 0 && padc != '-')
  800f27:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800f2b:	7e 6d                	jle    800f9a <vprintfmt+0x219>
  800f2d:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  800f31:	74 67                	je     800f9a <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  800f33:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800f36:	83 ec 08             	sub    $0x8,%esp
  800f39:	50                   	push   %eax
  800f3a:	56                   	push   %esi
  800f3b:	e8 0c 03 00 00       	call   80124c <strnlen>
  800f40:	83 c4 10             	add    $0x10,%esp
  800f43:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  800f46:	eb 16                	jmp    800f5e <vprintfmt+0x1dd>
					putch(padc, putdat);
  800f48:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  800f4c:	83 ec 08             	sub    $0x8,%esp
  800f4f:	ff 75 0c             	pushl  0xc(%ebp)
  800f52:	50                   	push   %eax
  800f53:	8b 45 08             	mov    0x8(%ebp),%eax
  800f56:	ff d0                	call   *%eax
  800f58:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800f5b:	ff 4d e4             	decl   -0x1c(%ebp)
  800f5e:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800f62:	7f e4                	jg     800f48 <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800f64:	eb 34                	jmp    800f9a <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  800f66:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800f6a:	74 1c                	je     800f88 <vprintfmt+0x207>
  800f6c:	83 fb 1f             	cmp    $0x1f,%ebx
  800f6f:	7e 05                	jle    800f76 <vprintfmt+0x1f5>
  800f71:	83 fb 7e             	cmp    $0x7e,%ebx
  800f74:	7e 12                	jle    800f88 <vprintfmt+0x207>
					putch('?', putdat);
  800f76:	83 ec 08             	sub    $0x8,%esp
  800f79:	ff 75 0c             	pushl  0xc(%ebp)
  800f7c:	6a 3f                	push   $0x3f
  800f7e:	8b 45 08             	mov    0x8(%ebp),%eax
  800f81:	ff d0                	call   *%eax
  800f83:	83 c4 10             	add    $0x10,%esp
  800f86:	eb 0f                	jmp    800f97 <vprintfmt+0x216>
				else
					putch(ch, putdat);
  800f88:	83 ec 08             	sub    $0x8,%esp
  800f8b:	ff 75 0c             	pushl  0xc(%ebp)
  800f8e:	53                   	push   %ebx
  800f8f:	8b 45 08             	mov    0x8(%ebp),%eax
  800f92:	ff d0                	call   *%eax
  800f94:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800f97:	ff 4d e4             	decl   -0x1c(%ebp)
  800f9a:	89 f0                	mov    %esi,%eax
  800f9c:	8d 70 01             	lea    0x1(%eax),%esi
  800f9f:	8a 00                	mov    (%eax),%al
  800fa1:	0f be d8             	movsbl %al,%ebx
  800fa4:	85 db                	test   %ebx,%ebx
  800fa6:	74 24                	je     800fcc <vprintfmt+0x24b>
  800fa8:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800fac:	78 b8                	js     800f66 <vprintfmt+0x1e5>
  800fae:	ff 4d e0             	decl   -0x20(%ebp)
  800fb1:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800fb5:	79 af                	jns    800f66 <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800fb7:	eb 13                	jmp    800fcc <vprintfmt+0x24b>
				putch(' ', putdat);
  800fb9:	83 ec 08             	sub    $0x8,%esp
  800fbc:	ff 75 0c             	pushl  0xc(%ebp)
  800fbf:	6a 20                	push   $0x20
  800fc1:	8b 45 08             	mov    0x8(%ebp),%eax
  800fc4:	ff d0                	call   *%eax
  800fc6:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800fc9:	ff 4d e4             	decl   -0x1c(%ebp)
  800fcc:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800fd0:	7f e7                	jg     800fb9 <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  800fd2:	e9 66 01 00 00       	jmp    80113d <vprintfmt+0x3bc>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  800fd7:	83 ec 08             	sub    $0x8,%esp
  800fda:	ff 75 e8             	pushl  -0x18(%ebp)
  800fdd:	8d 45 14             	lea    0x14(%ebp),%eax
  800fe0:	50                   	push   %eax
  800fe1:	e8 3c fd ff ff       	call   800d22 <getint>
  800fe6:	83 c4 10             	add    $0x10,%esp
  800fe9:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800fec:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  800fef:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800ff2:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800ff5:	85 d2                	test   %edx,%edx
  800ff7:	79 23                	jns    80101c <vprintfmt+0x29b>
				putch('-', putdat);
  800ff9:	83 ec 08             	sub    $0x8,%esp
  800ffc:	ff 75 0c             	pushl  0xc(%ebp)
  800fff:	6a 2d                	push   $0x2d
  801001:	8b 45 08             	mov    0x8(%ebp),%eax
  801004:	ff d0                	call   *%eax
  801006:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  801009:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80100c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80100f:	f7 d8                	neg    %eax
  801011:	83 d2 00             	adc    $0x0,%edx
  801014:	f7 da                	neg    %edx
  801016:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801019:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  80101c:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  801023:	e9 bc 00 00 00       	jmp    8010e4 <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  801028:	83 ec 08             	sub    $0x8,%esp
  80102b:	ff 75 e8             	pushl  -0x18(%ebp)
  80102e:	8d 45 14             	lea    0x14(%ebp),%eax
  801031:	50                   	push   %eax
  801032:	e8 84 fc ff ff       	call   800cbb <getuint>
  801037:	83 c4 10             	add    $0x10,%esp
  80103a:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80103d:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  801040:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  801047:	e9 98 00 00 00       	jmp    8010e4 <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  80104c:	83 ec 08             	sub    $0x8,%esp
  80104f:	ff 75 0c             	pushl  0xc(%ebp)
  801052:	6a 58                	push   $0x58
  801054:	8b 45 08             	mov    0x8(%ebp),%eax
  801057:	ff d0                	call   *%eax
  801059:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  80105c:	83 ec 08             	sub    $0x8,%esp
  80105f:	ff 75 0c             	pushl  0xc(%ebp)
  801062:	6a 58                	push   $0x58
  801064:	8b 45 08             	mov    0x8(%ebp),%eax
  801067:	ff d0                	call   *%eax
  801069:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  80106c:	83 ec 08             	sub    $0x8,%esp
  80106f:	ff 75 0c             	pushl  0xc(%ebp)
  801072:	6a 58                	push   $0x58
  801074:	8b 45 08             	mov    0x8(%ebp),%eax
  801077:	ff d0                	call   *%eax
  801079:	83 c4 10             	add    $0x10,%esp
			break;
  80107c:	e9 bc 00 00 00       	jmp    80113d <vprintfmt+0x3bc>

		// pointer
		case 'p':
			putch('0', putdat);
  801081:	83 ec 08             	sub    $0x8,%esp
  801084:	ff 75 0c             	pushl  0xc(%ebp)
  801087:	6a 30                	push   $0x30
  801089:	8b 45 08             	mov    0x8(%ebp),%eax
  80108c:	ff d0                	call   *%eax
  80108e:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  801091:	83 ec 08             	sub    $0x8,%esp
  801094:	ff 75 0c             	pushl  0xc(%ebp)
  801097:	6a 78                	push   $0x78
  801099:	8b 45 08             	mov    0x8(%ebp),%eax
  80109c:	ff d0                	call   *%eax
  80109e:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  8010a1:	8b 45 14             	mov    0x14(%ebp),%eax
  8010a4:	83 c0 04             	add    $0x4,%eax
  8010a7:	89 45 14             	mov    %eax,0x14(%ebp)
  8010aa:	8b 45 14             	mov    0x14(%ebp),%eax
  8010ad:	83 e8 04             	sub    $0x4,%eax
  8010b0:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  8010b2:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8010b5:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  8010bc:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  8010c3:	eb 1f                	jmp    8010e4 <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  8010c5:	83 ec 08             	sub    $0x8,%esp
  8010c8:	ff 75 e8             	pushl  -0x18(%ebp)
  8010cb:	8d 45 14             	lea    0x14(%ebp),%eax
  8010ce:	50                   	push   %eax
  8010cf:	e8 e7 fb ff ff       	call   800cbb <getuint>
  8010d4:	83 c4 10             	add    $0x10,%esp
  8010d7:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8010da:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  8010dd:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  8010e4:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  8010e8:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8010eb:	83 ec 04             	sub    $0x4,%esp
  8010ee:	52                   	push   %edx
  8010ef:	ff 75 e4             	pushl  -0x1c(%ebp)
  8010f2:	50                   	push   %eax
  8010f3:	ff 75 f4             	pushl  -0xc(%ebp)
  8010f6:	ff 75 f0             	pushl  -0x10(%ebp)
  8010f9:	ff 75 0c             	pushl  0xc(%ebp)
  8010fc:	ff 75 08             	pushl  0x8(%ebp)
  8010ff:	e8 00 fb ff ff       	call   800c04 <printnum>
  801104:	83 c4 20             	add    $0x20,%esp
			break;
  801107:	eb 34                	jmp    80113d <vprintfmt+0x3bc>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  801109:	83 ec 08             	sub    $0x8,%esp
  80110c:	ff 75 0c             	pushl  0xc(%ebp)
  80110f:	53                   	push   %ebx
  801110:	8b 45 08             	mov    0x8(%ebp),%eax
  801113:	ff d0                	call   *%eax
  801115:	83 c4 10             	add    $0x10,%esp
			break;
  801118:	eb 23                	jmp    80113d <vprintfmt+0x3bc>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  80111a:	83 ec 08             	sub    $0x8,%esp
  80111d:	ff 75 0c             	pushl  0xc(%ebp)
  801120:	6a 25                	push   $0x25
  801122:	8b 45 08             	mov    0x8(%ebp),%eax
  801125:	ff d0                	call   *%eax
  801127:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  80112a:	ff 4d 10             	decl   0x10(%ebp)
  80112d:	eb 03                	jmp    801132 <vprintfmt+0x3b1>
  80112f:	ff 4d 10             	decl   0x10(%ebp)
  801132:	8b 45 10             	mov    0x10(%ebp),%eax
  801135:	48                   	dec    %eax
  801136:	8a 00                	mov    (%eax),%al
  801138:	3c 25                	cmp    $0x25,%al
  80113a:	75 f3                	jne    80112f <vprintfmt+0x3ae>
				/* do nothing */;
			break;
  80113c:	90                   	nop
		}
	}
  80113d:	e9 47 fc ff ff       	jmp    800d89 <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  801142:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  801143:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801146:	5b                   	pop    %ebx
  801147:	5e                   	pop    %esi
  801148:	5d                   	pop    %ebp
  801149:	c3                   	ret    

0080114a <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  80114a:	55                   	push   %ebp
  80114b:	89 e5                	mov    %esp,%ebp
  80114d:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  801150:	8d 45 10             	lea    0x10(%ebp),%eax
  801153:	83 c0 04             	add    $0x4,%eax
  801156:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  801159:	8b 45 10             	mov    0x10(%ebp),%eax
  80115c:	ff 75 f4             	pushl  -0xc(%ebp)
  80115f:	50                   	push   %eax
  801160:	ff 75 0c             	pushl  0xc(%ebp)
  801163:	ff 75 08             	pushl  0x8(%ebp)
  801166:	e8 16 fc ff ff       	call   800d81 <vprintfmt>
  80116b:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  80116e:	90                   	nop
  80116f:	c9                   	leave  
  801170:	c3                   	ret    

00801171 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  801171:	55                   	push   %ebp
  801172:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  801174:	8b 45 0c             	mov    0xc(%ebp),%eax
  801177:	8b 40 08             	mov    0x8(%eax),%eax
  80117a:	8d 50 01             	lea    0x1(%eax),%edx
  80117d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801180:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  801183:	8b 45 0c             	mov    0xc(%ebp),%eax
  801186:	8b 10                	mov    (%eax),%edx
  801188:	8b 45 0c             	mov    0xc(%ebp),%eax
  80118b:	8b 40 04             	mov    0x4(%eax),%eax
  80118e:	39 c2                	cmp    %eax,%edx
  801190:	73 12                	jae    8011a4 <sprintputch+0x33>
		*b->buf++ = ch;
  801192:	8b 45 0c             	mov    0xc(%ebp),%eax
  801195:	8b 00                	mov    (%eax),%eax
  801197:	8d 48 01             	lea    0x1(%eax),%ecx
  80119a:	8b 55 0c             	mov    0xc(%ebp),%edx
  80119d:	89 0a                	mov    %ecx,(%edx)
  80119f:	8b 55 08             	mov    0x8(%ebp),%edx
  8011a2:	88 10                	mov    %dl,(%eax)
}
  8011a4:	90                   	nop
  8011a5:	5d                   	pop    %ebp
  8011a6:	c3                   	ret    

008011a7 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  8011a7:	55                   	push   %ebp
  8011a8:	89 e5                	mov    %esp,%ebp
  8011aa:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  8011ad:	8b 45 08             	mov    0x8(%ebp),%eax
  8011b0:	89 45 ec             	mov    %eax,-0x14(%ebp)
  8011b3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011b6:	8d 50 ff             	lea    -0x1(%eax),%edx
  8011b9:	8b 45 08             	mov    0x8(%ebp),%eax
  8011bc:	01 d0                	add    %edx,%eax
  8011be:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8011c1:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  8011c8:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8011cc:	74 06                	je     8011d4 <vsnprintf+0x2d>
  8011ce:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8011d2:	7f 07                	jg     8011db <vsnprintf+0x34>
		return -E_INVAL;
  8011d4:	b8 03 00 00 00       	mov    $0x3,%eax
  8011d9:	eb 20                	jmp    8011fb <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  8011db:	ff 75 14             	pushl  0x14(%ebp)
  8011de:	ff 75 10             	pushl  0x10(%ebp)
  8011e1:	8d 45 ec             	lea    -0x14(%ebp),%eax
  8011e4:	50                   	push   %eax
  8011e5:	68 71 11 80 00       	push   $0x801171
  8011ea:	e8 92 fb ff ff       	call   800d81 <vprintfmt>
  8011ef:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  8011f2:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8011f5:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  8011f8:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  8011fb:	c9                   	leave  
  8011fc:	c3                   	ret    

008011fd <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  8011fd:	55                   	push   %ebp
  8011fe:	89 e5                	mov    %esp,%ebp
  801200:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  801203:	8d 45 10             	lea    0x10(%ebp),%eax
  801206:	83 c0 04             	add    $0x4,%eax
  801209:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  80120c:	8b 45 10             	mov    0x10(%ebp),%eax
  80120f:	ff 75 f4             	pushl  -0xc(%ebp)
  801212:	50                   	push   %eax
  801213:	ff 75 0c             	pushl  0xc(%ebp)
  801216:	ff 75 08             	pushl  0x8(%ebp)
  801219:	e8 89 ff ff ff       	call   8011a7 <vsnprintf>
  80121e:	83 c4 10             	add    $0x10,%esp
  801221:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  801224:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801227:	c9                   	leave  
  801228:	c3                   	ret    

00801229 <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  801229:	55                   	push   %ebp
  80122a:	89 e5                	mov    %esp,%ebp
  80122c:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  80122f:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801236:	eb 06                	jmp    80123e <strlen+0x15>
		n++;
  801238:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  80123b:	ff 45 08             	incl   0x8(%ebp)
  80123e:	8b 45 08             	mov    0x8(%ebp),%eax
  801241:	8a 00                	mov    (%eax),%al
  801243:	84 c0                	test   %al,%al
  801245:	75 f1                	jne    801238 <strlen+0xf>
		n++;
	return n;
  801247:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  80124a:	c9                   	leave  
  80124b:	c3                   	ret    

0080124c <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  80124c:	55                   	push   %ebp
  80124d:	89 e5                	mov    %esp,%ebp
  80124f:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  801252:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801259:	eb 09                	jmp    801264 <strnlen+0x18>
		n++;
  80125b:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  80125e:	ff 45 08             	incl   0x8(%ebp)
  801261:	ff 4d 0c             	decl   0xc(%ebp)
  801264:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801268:	74 09                	je     801273 <strnlen+0x27>
  80126a:	8b 45 08             	mov    0x8(%ebp),%eax
  80126d:	8a 00                	mov    (%eax),%al
  80126f:	84 c0                	test   %al,%al
  801271:	75 e8                	jne    80125b <strnlen+0xf>
		n++;
	return n;
  801273:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  801276:	c9                   	leave  
  801277:	c3                   	ret    

00801278 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  801278:	55                   	push   %ebp
  801279:	89 e5                	mov    %esp,%ebp
  80127b:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  80127e:	8b 45 08             	mov    0x8(%ebp),%eax
  801281:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  801284:	90                   	nop
  801285:	8b 45 08             	mov    0x8(%ebp),%eax
  801288:	8d 50 01             	lea    0x1(%eax),%edx
  80128b:	89 55 08             	mov    %edx,0x8(%ebp)
  80128e:	8b 55 0c             	mov    0xc(%ebp),%edx
  801291:	8d 4a 01             	lea    0x1(%edx),%ecx
  801294:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  801297:	8a 12                	mov    (%edx),%dl
  801299:	88 10                	mov    %dl,(%eax)
  80129b:	8a 00                	mov    (%eax),%al
  80129d:	84 c0                	test   %al,%al
  80129f:	75 e4                	jne    801285 <strcpy+0xd>
		/* do nothing */;
	return ret;
  8012a1:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  8012a4:	c9                   	leave  
  8012a5:	c3                   	ret    

008012a6 <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  8012a6:	55                   	push   %ebp
  8012a7:	89 e5                	mov    %esp,%ebp
  8012a9:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  8012ac:	8b 45 08             	mov    0x8(%ebp),%eax
  8012af:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  8012b2:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8012b9:	eb 1f                	jmp    8012da <strncpy+0x34>
		*dst++ = *src;
  8012bb:	8b 45 08             	mov    0x8(%ebp),%eax
  8012be:	8d 50 01             	lea    0x1(%eax),%edx
  8012c1:	89 55 08             	mov    %edx,0x8(%ebp)
  8012c4:	8b 55 0c             	mov    0xc(%ebp),%edx
  8012c7:	8a 12                	mov    (%edx),%dl
  8012c9:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  8012cb:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012ce:	8a 00                	mov    (%eax),%al
  8012d0:	84 c0                	test   %al,%al
  8012d2:	74 03                	je     8012d7 <strncpy+0x31>
			src++;
  8012d4:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  8012d7:	ff 45 fc             	incl   -0x4(%ebp)
  8012da:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8012dd:	3b 45 10             	cmp    0x10(%ebp),%eax
  8012e0:	72 d9                	jb     8012bb <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  8012e2:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  8012e5:	c9                   	leave  
  8012e6:	c3                   	ret    

008012e7 <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  8012e7:	55                   	push   %ebp
  8012e8:	89 e5                	mov    %esp,%ebp
  8012ea:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  8012ed:	8b 45 08             	mov    0x8(%ebp),%eax
  8012f0:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  8012f3:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8012f7:	74 30                	je     801329 <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  8012f9:	eb 16                	jmp    801311 <strlcpy+0x2a>
			*dst++ = *src++;
  8012fb:	8b 45 08             	mov    0x8(%ebp),%eax
  8012fe:	8d 50 01             	lea    0x1(%eax),%edx
  801301:	89 55 08             	mov    %edx,0x8(%ebp)
  801304:	8b 55 0c             	mov    0xc(%ebp),%edx
  801307:	8d 4a 01             	lea    0x1(%edx),%ecx
  80130a:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  80130d:	8a 12                	mov    (%edx),%dl
  80130f:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  801311:	ff 4d 10             	decl   0x10(%ebp)
  801314:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801318:	74 09                	je     801323 <strlcpy+0x3c>
  80131a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80131d:	8a 00                	mov    (%eax),%al
  80131f:	84 c0                	test   %al,%al
  801321:	75 d8                	jne    8012fb <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  801323:	8b 45 08             	mov    0x8(%ebp),%eax
  801326:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  801329:	8b 55 08             	mov    0x8(%ebp),%edx
  80132c:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80132f:	29 c2                	sub    %eax,%edx
  801331:	89 d0                	mov    %edx,%eax
}
  801333:	c9                   	leave  
  801334:	c3                   	ret    

00801335 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  801335:	55                   	push   %ebp
  801336:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  801338:	eb 06                	jmp    801340 <strcmp+0xb>
		p++, q++;
  80133a:	ff 45 08             	incl   0x8(%ebp)
  80133d:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  801340:	8b 45 08             	mov    0x8(%ebp),%eax
  801343:	8a 00                	mov    (%eax),%al
  801345:	84 c0                	test   %al,%al
  801347:	74 0e                	je     801357 <strcmp+0x22>
  801349:	8b 45 08             	mov    0x8(%ebp),%eax
  80134c:	8a 10                	mov    (%eax),%dl
  80134e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801351:	8a 00                	mov    (%eax),%al
  801353:	38 c2                	cmp    %al,%dl
  801355:	74 e3                	je     80133a <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  801357:	8b 45 08             	mov    0x8(%ebp),%eax
  80135a:	8a 00                	mov    (%eax),%al
  80135c:	0f b6 d0             	movzbl %al,%edx
  80135f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801362:	8a 00                	mov    (%eax),%al
  801364:	0f b6 c0             	movzbl %al,%eax
  801367:	29 c2                	sub    %eax,%edx
  801369:	89 d0                	mov    %edx,%eax
}
  80136b:	5d                   	pop    %ebp
  80136c:	c3                   	ret    

0080136d <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  80136d:	55                   	push   %ebp
  80136e:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  801370:	eb 09                	jmp    80137b <strncmp+0xe>
		n--, p++, q++;
  801372:	ff 4d 10             	decl   0x10(%ebp)
  801375:	ff 45 08             	incl   0x8(%ebp)
  801378:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  80137b:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80137f:	74 17                	je     801398 <strncmp+0x2b>
  801381:	8b 45 08             	mov    0x8(%ebp),%eax
  801384:	8a 00                	mov    (%eax),%al
  801386:	84 c0                	test   %al,%al
  801388:	74 0e                	je     801398 <strncmp+0x2b>
  80138a:	8b 45 08             	mov    0x8(%ebp),%eax
  80138d:	8a 10                	mov    (%eax),%dl
  80138f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801392:	8a 00                	mov    (%eax),%al
  801394:	38 c2                	cmp    %al,%dl
  801396:	74 da                	je     801372 <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  801398:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80139c:	75 07                	jne    8013a5 <strncmp+0x38>
		return 0;
  80139e:	b8 00 00 00 00       	mov    $0x0,%eax
  8013a3:	eb 14                	jmp    8013b9 <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  8013a5:	8b 45 08             	mov    0x8(%ebp),%eax
  8013a8:	8a 00                	mov    (%eax),%al
  8013aa:	0f b6 d0             	movzbl %al,%edx
  8013ad:	8b 45 0c             	mov    0xc(%ebp),%eax
  8013b0:	8a 00                	mov    (%eax),%al
  8013b2:	0f b6 c0             	movzbl %al,%eax
  8013b5:	29 c2                	sub    %eax,%edx
  8013b7:	89 d0                	mov    %edx,%eax
}
  8013b9:	5d                   	pop    %ebp
  8013ba:	c3                   	ret    

008013bb <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  8013bb:	55                   	push   %ebp
  8013bc:	89 e5                	mov    %esp,%ebp
  8013be:	83 ec 04             	sub    $0x4,%esp
  8013c1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8013c4:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  8013c7:	eb 12                	jmp    8013db <strchr+0x20>
		if (*s == c)
  8013c9:	8b 45 08             	mov    0x8(%ebp),%eax
  8013cc:	8a 00                	mov    (%eax),%al
  8013ce:	3a 45 fc             	cmp    -0x4(%ebp),%al
  8013d1:	75 05                	jne    8013d8 <strchr+0x1d>
			return (char *) s;
  8013d3:	8b 45 08             	mov    0x8(%ebp),%eax
  8013d6:	eb 11                	jmp    8013e9 <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  8013d8:	ff 45 08             	incl   0x8(%ebp)
  8013db:	8b 45 08             	mov    0x8(%ebp),%eax
  8013de:	8a 00                	mov    (%eax),%al
  8013e0:	84 c0                	test   %al,%al
  8013e2:	75 e5                	jne    8013c9 <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  8013e4:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8013e9:	c9                   	leave  
  8013ea:	c3                   	ret    

008013eb <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  8013eb:	55                   	push   %ebp
  8013ec:	89 e5                	mov    %esp,%ebp
  8013ee:	83 ec 04             	sub    $0x4,%esp
  8013f1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8013f4:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  8013f7:	eb 0d                	jmp    801406 <strfind+0x1b>
		if (*s == c)
  8013f9:	8b 45 08             	mov    0x8(%ebp),%eax
  8013fc:	8a 00                	mov    (%eax),%al
  8013fe:	3a 45 fc             	cmp    -0x4(%ebp),%al
  801401:	74 0e                	je     801411 <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  801403:	ff 45 08             	incl   0x8(%ebp)
  801406:	8b 45 08             	mov    0x8(%ebp),%eax
  801409:	8a 00                	mov    (%eax),%al
  80140b:	84 c0                	test   %al,%al
  80140d:	75 ea                	jne    8013f9 <strfind+0xe>
  80140f:	eb 01                	jmp    801412 <strfind+0x27>
		if (*s == c)
			break;
  801411:	90                   	nop
	return (char *) s;
  801412:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801415:	c9                   	leave  
  801416:	c3                   	ret    

00801417 <memset>:


void *
memset(void *v, int c, uint32 n)
{
  801417:	55                   	push   %ebp
  801418:	89 e5                	mov    %esp,%ebp
  80141a:	83 ec 10             	sub    $0x10,%esp
	char *p;
	int m;

	p = v;
  80141d:	8b 45 08             	mov    0x8(%ebp),%eax
  801420:	89 45 fc             	mov    %eax,-0x4(%ebp)
	m = n;
  801423:	8b 45 10             	mov    0x10(%ebp),%eax
  801426:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (--m >= 0)
  801429:	eb 0e                	jmp    801439 <memset+0x22>
		*p++ = c;
  80142b:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80142e:	8d 50 01             	lea    0x1(%eax),%edx
  801431:	89 55 fc             	mov    %edx,-0x4(%ebp)
  801434:	8b 55 0c             	mov    0xc(%ebp),%edx
  801437:	88 10                	mov    %dl,(%eax)
	char *p;
	int m;

	p = v;
	m = n;
	while (--m >= 0)
  801439:	ff 4d f8             	decl   -0x8(%ebp)
  80143c:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  801440:	79 e9                	jns    80142b <memset+0x14>
		*p++ = c;

	return v;
  801442:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801445:	c9                   	leave  
  801446:	c3                   	ret    

00801447 <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  801447:	55                   	push   %ebp
  801448:	89 e5                	mov    %esp,%ebp
  80144a:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  80144d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801450:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  801453:	8b 45 08             	mov    0x8(%ebp),%eax
  801456:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (n-- > 0)
  801459:	eb 16                	jmp    801471 <memcpy+0x2a>
		*d++ = *s++;
  80145b:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80145e:	8d 50 01             	lea    0x1(%eax),%edx
  801461:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801464:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801467:	8d 4a 01             	lea    0x1(%edx),%ecx
  80146a:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  80146d:	8a 12                	mov    (%edx),%dl
  80146f:	88 10                	mov    %dl,(%eax)
	const char *s;
	char *d;

	s = src;
	d = dst;
	while (n-- > 0)
  801471:	8b 45 10             	mov    0x10(%ebp),%eax
  801474:	8d 50 ff             	lea    -0x1(%eax),%edx
  801477:	89 55 10             	mov    %edx,0x10(%ebp)
  80147a:	85 c0                	test   %eax,%eax
  80147c:	75 dd                	jne    80145b <memcpy+0x14>
		*d++ = *s++;

	return dst;
  80147e:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801481:	c9                   	leave  
  801482:	c3                   	ret    

00801483 <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  801483:	55                   	push   %ebp
  801484:	89 e5                	mov    %esp,%ebp
  801486:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  801489:	8b 45 0c             	mov    0xc(%ebp),%eax
  80148c:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  80148f:	8b 45 08             	mov    0x8(%ebp),%eax
  801492:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  801495:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801498:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  80149b:	73 50                	jae    8014ed <memmove+0x6a>
  80149d:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8014a0:	8b 45 10             	mov    0x10(%ebp),%eax
  8014a3:	01 d0                	add    %edx,%eax
  8014a5:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  8014a8:	76 43                	jbe    8014ed <memmove+0x6a>
		s += n;
  8014aa:	8b 45 10             	mov    0x10(%ebp),%eax
  8014ad:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  8014b0:	8b 45 10             	mov    0x10(%ebp),%eax
  8014b3:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  8014b6:	eb 10                	jmp    8014c8 <memmove+0x45>
			*--d = *--s;
  8014b8:	ff 4d f8             	decl   -0x8(%ebp)
  8014bb:	ff 4d fc             	decl   -0x4(%ebp)
  8014be:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8014c1:	8a 10                	mov    (%eax),%dl
  8014c3:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8014c6:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  8014c8:	8b 45 10             	mov    0x10(%ebp),%eax
  8014cb:	8d 50 ff             	lea    -0x1(%eax),%edx
  8014ce:	89 55 10             	mov    %edx,0x10(%ebp)
  8014d1:	85 c0                	test   %eax,%eax
  8014d3:	75 e3                	jne    8014b8 <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  8014d5:	eb 23                	jmp    8014fa <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  8014d7:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8014da:	8d 50 01             	lea    0x1(%eax),%edx
  8014dd:	89 55 f8             	mov    %edx,-0x8(%ebp)
  8014e0:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8014e3:	8d 4a 01             	lea    0x1(%edx),%ecx
  8014e6:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  8014e9:	8a 12                	mov    (%edx),%dl
  8014eb:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  8014ed:	8b 45 10             	mov    0x10(%ebp),%eax
  8014f0:	8d 50 ff             	lea    -0x1(%eax),%edx
  8014f3:	89 55 10             	mov    %edx,0x10(%ebp)
  8014f6:	85 c0                	test   %eax,%eax
  8014f8:	75 dd                	jne    8014d7 <memmove+0x54>
			*d++ = *s++;

	return dst;
  8014fa:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8014fd:	c9                   	leave  
  8014fe:	c3                   	ret    

008014ff <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  8014ff:	55                   	push   %ebp
  801500:	89 e5                	mov    %esp,%ebp
  801502:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  801505:	8b 45 08             	mov    0x8(%ebp),%eax
  801508:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  80150b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80150e:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  801511:	eb 2a                	jmp    80153d <memcmp+0x3e>
		if (*s1 != *s2)
  801513:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801516:	8a 10                	mov    (%eax),%dl
  801518:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80151b:	8a 00                	mov    (%eax),%al
  80151d:	38 c2                	cmp    %al,%dl
  80151f:	74 16                	je     801537 <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  801521:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801524:	8a 00                	mov    (%eax),%al
  801526:	0f b6 d0             	movzbl %al,%edx
  801529:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80152c:	8a 00                	mov    (%eax),%al
  80152e:	0f b6 c0             	movzbl %al,%eax
  801531:	29 c2                	sub    %eax,%edx
  801533:	89 d0                	mov    %edx,%eax
  801535:	eb 18                	jmp    80154f <memcmp+0x50>
		s1++, s2++;
  801537:	ff 45 fc             	incl   -0x4(%ebp)
  80153a:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  80153d:	8b 45 10             	mov    0x10(%ebp),%eax
  801540:	8d 50 ff             	lea    -0x1(%eax),%edx
  801543:	89 55 10             	mov    %edx,0x10(%ebp)
  801546:	85 c0                	test   %eax,%eax
  801548:	75 c9                	jne    801513 <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  80154a:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80154f:	c9                   	leave  
  801550:	c3                   	ret    

00801551 <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  801551:	55                   	push   %ebp
  801552:	89 e5                	mov    %esp,%ebp
  801554:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  801557:	8b 55 08             	mov    0x8(%ebp),%edx
  80155a:	8b 45 10             	mov    0x10(%ebp),%eax
  80155d:	01 d0                	add    %edx,%eax
  80155f:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  801562:	eb 15                	jmp    801579 <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  801564:	8b 45 08             	mov    0x8(%ebp),%eax
  801567:	8a 00                	mov    (%eax),%al
  801569:	0f b6 d0             	movzbl %al,%edx
  80156c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80156f:	0f b6 c0             	movzbl %al,%eax
  801572:	39 c2                	cmp    %eax,%edx
  801574:	74 0d                	je     801583 <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  801576:	ff 45 08             	incl   0x8(%ebp)
  801579:	8b 45 08             	mov    0x8(%ebp),%eax
  80157c:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  80157f:	72 e3                	jb     801564 <memfind+0x13>
  801581:	eb 01                	jmp    801584 <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  801583:	90                   	nop
	return (void *) s;
  801584:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801587:	c9                   	leave  
  801588:	c3                   	ret    

00801589 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  801589:	55                   	push   %ebp
  80158a:	89 e5                	mov    %esp,%ebp
  80158c:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  80158f:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  801596:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  80159d:	eb 03                	jmp    8015a2 <strtol+0x19>
		s++;
  80159f:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  8015a2:	8b 45 08             	mov    0x8(%ebp),%eax
  8015a5:	8a 00                	mov    (%eax),%al
  8015a7:	3c 20                	cmp    $0x20,%al
  8015a9:	74 f4                	je     80159f <strtol+0x16>
  8015ab:	8b 45 08             	mov    0x8(%ebp),%eax
  8015ae:	8a 00                	mov    (%eax),%al
  8015b0:	3c 09                	cmp    $0x9,%al
  8015b2:	74 eb                	je     80159f <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  8015b4:	8b 45 08             	mov    0x8(%ebp),%eax
  8015b7:	8a 00                	mov    (%eax),%al
  8015b9:	3c 2b                	cmp    $0x2b,%al
  8015bb:	75 05                	jne    8015c2 <strtol+0x39>
		s++;
  8015bd:	ff 45 08             	incl   0x8(%ebp)
  8015c0:	eb 13                	jmp    8015d5 <strtol+0x4c>
	else if (*s == '-')
  8015c2:	8b 45 08             	mov    0x8(%ebp),%eax
  8015c5:	8a 00                	mov    (%eax),%al
  8015c7:	3c 2d                	cmp    $0x2d,%al
  8015c9:	75 0a                	jne    8015d5 <strtol+0x4c>
		s++, neg = 1;
  8015cb:	ff 45 08             	incl   0x8(%ebp)
  8015ce:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  8015d5:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8015d9:	74 06                	je     8015e1 <strtol+0x58>
  8015db:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  8015df:	75 20                	jne    801601 <strtol+0x78>
  8015e1:	8b 45 08             	mov    0x8(%ebp),%eax
  8015e4:	8a 00                	mov    (%eax),%al
  8015e6:	3c 30                	cmp    $0x30,%al
  8015e8:	75 17                	jne    801601 <strtol+0x78>
  8015ea:	8b 45 08             	mov    0x8(%ebp),%eax
  8015ed:	40                   	inc    %eax
  8015ee:	8a 00                	mov    (%eax),%al
  8015f0:	3c 78                	cmp    $0x78,%al
  8015f2:	75 0d                	jne    801601 <strtol+0x78>
		s += 2, base = 16;
  8015f4:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  8015f8:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  8015ff:	eb 28                	jmp    801629 <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  801601:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801605:	75 15                	jne    80161c <strtol+0x93>
  801607:	8b 45 08             	mov    0x8(%ebp),%eax
  80160a:	8a 00                	mov    (%eax),%al
  80160c:	3c 30                	cmp    $0x30,%al
  80160e:	75 0c                	jne    80161c <strtol+0x93>
		s++, base = 8;
  801610:	ff 45 08             	incl   0x8(%ebp)
  801613:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  80161a:	eb 0d                	jmp    801629 <strtol+0xa0>
	else if (base == 0)
  80161c:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801620:	75 07                	jne    801629 <strtol+0xa0>
		base = 10;
  801622:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  801629:	8b 45 08             	mov    0x8(%ebp),%eax
  80162c:	8a 00                	mov    (%eax),%al
  80162e:	3c 2f                	cmp    $0x2f,%al
  801630:	7e 19                	jle    80164b <strtol+0xc2>
  801632:	8b 45 08             	mov    0x8(%ebp),%eax
  801635:	8a 00                	mov    (%eax),%al
  801637:	3c 39                	cmp    $0x39,%al
  801639:	7f 10                	jg     80164b <strtol+0xc2>
			dig = *s - '0';
  80163b:	8b 45 08             	mov    0x8(%ebp),%eax
  80163e:	8a 00                	mov    (%eax),%al
  801640:	0f be c0             	movsbl %al,%eax
  801643:	83 e8 30             	sub    $0x30,%eax
  801646:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801649:	eb 42                	jmp    80168d <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  80164b:	8b 45 08             	mov    0x8(%ebp),%eax
  80164e:	8a 00                	mov    (%eax),%al
  801650:	3c 60                	cmp    $0x60,%al
  801652:	7e 19                	jle    80166d <strtol+0xe4>
  801654:	8b 45 08             	mov    0x8(%ebp),%eax
  801657:	8a 00                	mov    (%eax),%al
  801659:	3c 7a                	cmp    $0x7a,%al
  80165b:	7f 10                	jg     80166d <strtol+0xe4>
			dig = *s - 'a' + 10;
  80165d:	8b 45 08             	mov    0x8(%ebp),%eax
  801660:	8a 00                	mov    (%eax),%al
  801662:	0f be c0             	movsbl %al,%eax
  801665:	83 e8 57             	sub    $0x57,%eax
  801668:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80166b:	eb 20                	jmp    80168d <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  80166d:	8b 45 08             	mov    0x8(%ebp),%eax
  801670:	8a 00                	mov    (%eax),%al
  801672:	3c 40                	cmp    $0x40,%al
  801674:	7e 39                	jle    8016af <strtol+0x126>
  801676:	8b 45 08             	mov    0x8(%ebp),%eax
  801679:	8a 00                	mov    (%eax),%al
  80167b:	3c 5a                	cmp    $0x5a,%al
  80167d:	7f 30                	jg     8016af <strtol+0x126>
			dig = *s - 'A' + 10;
  80167f:	8b 45 08             	mov    0x8(%ebp),%eax
  801682:	8a 00                	mov    (%eax),%al
  801684:	0f be c0             	movsbl %al,%eax
  801687:	83 e8 37             	sub    $0x37,%eax
  80168a:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  80168d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801690:	3b 45 10             	cmp    0x10(%ebp),%eax
  801693:	7d 19                	jge    8016ae <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  801695:	ff 45 08             	incl   0x8(%ebp)
  801698:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80169b:	0f af 45 10          	imul   0x10(%ebp),%eax
  80169f:	89 c2                	mov    %eax,%edx
  8016a1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8016a4:	01 d0                	add    %edx,%eax
  8016a6:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  8016a9:	e9 7b ff ff ff       	jmp    801629 <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  8016ae:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  8016af:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8016b3:	74 08                	je     8016bd <strtol+0x134>
		*endptr = (char *) s;
  8016b5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8016b8:	8b 55 08             	mov    0x8(%ebp),%edx
  8016bb:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  8016bd:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8016c1:	74 07                	je     8016ca <strtol+0x141>
  8016c3:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8016c6:	f7 d8                	neg    %eax
  8016c8:	eb 03                	jmp    8016cd <strtol+0x144>
  8016ca:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  8016cd:	c9                   	leave  
  8016ce:	c3                   	ret    

008016cf <ltostr>:

void
ltostr(long value, char *str)
{
  8016cf:	55                   	push   %ebp
  8016d0:	89 e5                	mov    %esp,%ebp
  8016d2:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  8016d5:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  8016dc:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  8016e3:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8016e7:	79 13                	jns    8016fc <ltostr+0x2d>
	{
		neg = 1;
  8016e9:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  8016f0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8016f3:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  8016f6:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  8016f9:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  8016fc:	8b 45 08             	mov    0x8(%ebp),%eax
  8016ff:	b9 0a 00 00 00       	mov    $0xa,%ecx
  801704:	99                   	cltd   
  801705:	f7 f9                	idiv   %ecx
  801707:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  80170a:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80170d:	8d 50 01             	lea    0x1(%eax),%edx
  801710:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801713:	89 c2                	mov    %eax,%edx
  801715:	8b 45 0c             	mov    0xc(%ebp),%eax
  801718:	01 d0                	add    %edx,%eax
  80171a:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80171d:	83 c2 30             	add    $0x30,%edx
  801720:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  801722:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801725:	b8 67 66 66 66       	mov    $0x66666667,%eax
  80172a:	f7 e9                	imul   %ecx
  80172c:	c1 fa 02             	sar    $0x2,%edx
  80172f:	89 c8                	mov    %ecx,%eax
  801731:	c1 f8 1f             	sar    $0x1f,%eax
  801734:	29 c2                	sub    %eax,%edx
  801736:	89 d0                	mov    %edx,%eax
  801738:	89 45 08             	mov    %eax,0x8(%ebp)
	} while (value % 10 != 0);
  80173b:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80173e:	b8 67 66 66 66       	mov    $0x66666667,%eax
  801743:	f7 e9                	imul   %ecx
  801745:	c1 fa 02             	sar    $0x2,%edx
  801748:	89 c8                	mov    %ecx,%eax
  80174a:	c1 f8 1f             	sar    $0x1f,%eax
  80174d:	29 c2                	sub    %eax,%edx
  80174f:	89 d0                	mov    %edx,%eax
  801751:	c1 e0 02             	shl    $0x2,%eax
  801754:	01 d0                	add    %edx,%eax
  801756:	01 c0                	add    %eax,%eax
  801758:	29 c1                	sub    %eax,%ecx
  80175a:	89 ca                	mov    %ecx,%edx
  80175c:	85 d2                	test   %edx,%edx
  80175e:	75 9c                	jne    8016fc <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  801760:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  801767:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80176a:	48                   	dec    %eax
  80176b:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  80176e:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801772:	74 3d                	je     8017b1 <ltostr+0xe2>
		start = 1 ;
  801774:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  80177b:	eb 34                	jmp    8017b1 <ltostr+0xe2>
	{
		char tmp = str[start] ;
  80177d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801780:	8b 45 0c             	mov    0xc(%ebp),%eax
  801783:	01 d0                	add    %edx,%eax
  801785:	8a 00                	mov    (%eax),%al
  801787:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  80178a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80178d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801790:	01 c2                	add    %eax,%edx
  801792:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  801795:	8b 45 0c             	mov    0xc(%ebp),%eax
  801798:	01 c8                	add    %ecx,%eax
  80179a:	8a 00                	mov    (%eax),%al
  80179c:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  80179e:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8017a1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8017a4:	01 c2                	add    %eax,%edx
  8017a6:	8a 45 eb             	mov    -0x15(%ebp),%al
  8017a9:	88 02                	mov    %al,(%edx)
		start++ ;
  8017ab:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  8017ae:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  8017b1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8017b4:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8017b7:	7c c4                	jl     80177d <ltostr+0xae>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  8017b9:	8b 55 f8             	mov    -0x8(%ebp),%edx
  8017bc:	8b 45 0c             	mov    0xc(%ebp),%eax
  8017bf:	01 d0                	add    %edx,%eax
  8017c1:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  8017c4:	90                   	nop
  8017c5:	c9                   	leave  
  8017c6:	c3                   	ret    

008017c7 <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  8017c7:	55                   	push   %ebp
  8017c8:	89 e5                	mov    %esp,%ebp
  8017ca:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  8017cd:	ff 75 08             	pushl  0x8(%ebp)
  8017d0:	e8 54 fa ff ff       	call   801229 <strlen>
  8017d5:	83 c4 04             	add    $0x4,%esp
  8017d8:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  8017db:	ff 75 0c             	pushl  0xc(%ebp)
  8017de:	e8 46 fa ff ff       	call   801229 <strlen>
  8017e3:	83 c4 04             	add    $0x4,%esp
  8017e6:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  8017e9:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  8017f0:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8017f7:	eb 17                	jmp    801810 <strcconcat+0x49>
		final[s] = str1[s] ;
  8017f9:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8017fc:	8b 45 10             	mov    0x10(%ebp),%eax
  8017ff:	01 c2                	add    %eax,%edx
  801801:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  801804:	8b 45 08             	mov    0x8(%ebp),%eax
  801807:	01 c8                	add    %ecx,%eax
  801809:	8a 00                	mov    (%eax),%al
  80180b:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  80180d:	ff 45 fc             	incl   -0x4(%ebp)
  801810:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801813:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  801816:	7c e1                	jl     8017f9 <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  801818:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  80181f:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  801826:	eb 1f                	jmp    801847 <strcconcat+0x80>
		final[s++] = str2[i] ;
  801828:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80182b:	8d 50 01             	lea    0x1(%eax),%edx
  80182e:	89 55 fc             	mov    %edx,-0x4(%ebp)
  801831:	89 c2                	mov    %eax,%edx
  801833:	8b 45 10             	mov    0x10(%ebp),%eax
  801836:	01 c2                	add    %eax,%edx
  801838:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  80183b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80183e:	01 c8                	add    %ecx,%eax
  801840:	8a 00                	mov    (%eax),%al
  801842:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  801844:	ff 45 f8             	incl   -0x8(%ebp)
  801847:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80184a:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80184d:	7c d9                	jl     801828 <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  80184f:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801852:	8b 45 10             	mov    0x10(%ebp),%eax
  801855:	01 d0                	add    %edx,%eax
  801857:	c6 00 00             	movb   $0x0,(%eax)
}
  80185a:	90                   	nop
  80185b:	c9                   	leave  
  80185c:	c3                   	ret    

0080185d <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  80185d:	55                   	push   %ebp
  80185e:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  801860:	8b 45 14             	mov    0x14(%ebp),%eax
  801863:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  801869:	8b 45 14             	mov    0x14(%ebp),%eax
  80186c:	8b 00                	mov    (%eax),%eax
  80186e:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801875:	8b 45 10             	mov    0x10(%ebp),%eax
  801878:	01 d0                	add    %edx,%eax
  80187a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801880:	eb 0c                	jmp    80188e <strsplit+0x31>
			*string++ = 0;
  801882:	8b 45 08             	mov    0x8(%ebp),%eax
  801885:	8d 50 01             	lea    0x1(%eax),%edx
  801888:	89 55 08             	mov    %edx,0x8(%ebp)
  80188b:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  80188e:	8b 45 08             	mov    0x8(%ebp),%eax
  801891:	8a 00                	mov    (%eax),%al
  801893:	84 c0                	test   %al,%al
  801895:	74 18                	je     8018af <strsplit+0x52>
  801897:	8b 45 08             	mov    0x8(%ebp),%eax
  80189a:	8a 00                	mov    (%eax),%al
  80189c:	0f be c0             	movsbl %al,%eax
  80189f:	50                   	push   %eax
  8018a0:	ff 75 0c             	pushl  0xc(%ebp)
  8018a3:	e8 13 fb ff ff       	call   8013bb <strchr>
  8018a8:	83 c4 08             	add    $0x8,%esp
  8018ab:	85 c0                	test   %eax,%eax
  8018ad:	75 d3                	jne    801882 <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  8018af:	8b 45 08             	mov    0x8(%ebp),%eax
  8018b2:	8a 00                	mov    (%eax),%al
  8018b4:	84 c0                	test   %al,%al
  8018b6:	74 5a                	je     801912 <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  8018b8:	8b 45 14             	mov    0x14(%ebp),%eax
  8018bb:	8b 00                	mov    (%eax),%eax
  8018bd:	83 f8 0f             	cmp    $0xf,%eax
  8018c0:	75 07                	jne    8018c9 <strsplit+0x6c>
		{
			return 0;
  8018c2:	b8 00 00 00 00       	mov    $0x0,%eax
  8018c7:	eb 66                	jmp    80192f <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  8018c9:	8b 45 14             	mov    0x14(%ebp),%eax
  8018cc:	8b 00                	mov    (%eax),%eax
  8018ce:	8d 48 01             	lea    0x1(%eax),%ecx
  8018d1:	8b 55 14             	mov    0x14(%ebp),%edx
  8018d4:	89 0a                	mov    %ecx,(%edx)
  8018d6:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8018dd:	8b 45 10             	mov    0x10(%ebp),%eax
  8018e0:	01 c2                	add    %eax,%edx
  8018e2:	8b 45 08             	mov    0x8(%ebp),%eax
  8018e5:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  8018e7:	eb 03                	jmp    8018ec <strsplit+0x8f>
			string++;
  8018e9:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  8018ec:	8b 45 08             	mov    0x8(%ebp),%eax
  8018ef:	8a 00                	mov    (%eax),%al
  8018f1:	84 c0                	test   %al,%al
  8018f3:	74 8b                	je     801880 <strsplit+0x23>
  8018f5:	8b 45 08             	mov    0x8(%ebp),%eax
  8018f8:	8a 00                	mov    (%eax),%al
  8018fa:	0f be c0             	movsbl %al,%eax
  8018fd:	50                   	push   %eax
  8018fe:	ff 75 0c             	pushl  0xc(%ebp)
  801901:	e8 b5 fa ff ff       	call   8013bb <strchr>
  801906:	83 c4 08             	add    $0x8,%esp
  801909:	85 c0                	test   %eax,%eax
  80190b:	74 dc                	je     8018e9 <strsplit+0x8c>
			string++;
	}
  80190d:	e9 6e ff ff ff       	jmp    801880 <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  801912:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  801913:	8b 45 14             	mov    0x14(%ebp),%eax
  801916:	8b 00                	mov    (%eax),%eax
  801918:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80191f:	8b 45 10             	mov    0x10(%ebp),%eax
  801922:	01 d0                	add    %edx,%eax
  801924:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  80192a:	b8 01 00 00 00       	mov    $0x1,%eax
}
  80192f:	c9                   	leave  
  801930:	c3                   	ret    

00801931 <InitializeUHeap>:
//============================== GIVEN FUNCTIONS ===================================//
//==================================================================================//

int FirstTimeFlag = 1;
void InitializeUHeap()
{
  801931:	55                   	push   %ebp
  801932:	89 e5                	mov    %esp,%ebp
  801934:	83 ec 08             	sub    $0x8,%esp
	if(FirstTimeFlag)
  801937:	a1 04 50 80 00       	mov    0x805004,%eax
  80193c:	85 c0                	test   %eax,%eax
  80193e:	74 1f                	je     80195f <InitializeUHeap+0x2e>
	{
		initialize_dyn_block_system();
  801940:	e8 1d 00 00 00       	call   801962 <initialize_dyn_block_system>
		cprintf("DYNAMIC BLOCK SYSTEM IS INITIALIZED\n");
  801945:	83 ec 0c             	sub    $0xc,%esp
  801948:	68 b0 3e 80 00       	push   $0x803eb0
  80194d:	e8 55 f2 ff ff       	call   800ba7 <cprintf>
  801952:	83 c4 10             	add    $0x10,%esp
#if UHP_USE_BUDDY
		initialize_buddy();
		cprintf("BUDDY SYSTEM IS INITIALIZED\n");
#endif
		FirstTimeFlag = 0;
  801955:	c7 05 04 50 80 00 00 	movl   $0x0,0x805004
  80195c:	00 00 00 
	}
}
  80195f:	90                   	nop
  801960:	c9                   	leave  
  801961:	c3                   	ret    

00801962 <initialize_dyn_block_system>:

//=================================
// [1] INITIALIZE DYNAMIC ALLOCATOR:
//=================================
void initialize_dyn_block_system()
{
  801962:	55                   	push   %ebp
  801963:	89 e5                	mov    %esp,%ebp
  801965:	83 ec 28             	sub    $0x28,%esp
	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] initialize_dyn_block_system
	// your code is here, remove the panic and write your code
	//panic("initialize_dyn_block_system() is not implemented yet...!!");

	LIST_INIT(&AllocMemBlocksList);
  801968:	c7 05 40 50 80 00 00 	movl   $0x0,0x805040
  80196f:	00 00 00 
  801972:	c7 05 44 50 80 00 00 	movl   $0x0,0x805044
  801979:	00 00 00 
  80197c:	c7 05 4c 50 80 00 00 	movl   $0x0,0x80504c
  801983:	00 00 00 
	LIST_INIT(&FreeMemBlocksList);
  801986:	c7 05 38 51 80 00 00 	movl   $0x0,0x805138
  80198d:	00 00 00 
  801990:	c7 05 3c 51 80 00 00 	movl   $0x0,0x80513c
  801997:	00 00 00 
  80199a:	c7 05 44 51 80 00 00 	movl   $0x0,0x805144
  8019a1:	00 00 00 
	MAX_MEM_BLOCK_CNT = NUM_OF_UHEAP_PAGES;
  8019a4:	c7 05 20 51 80 00 00 	movl   $0x20000,0x805120
  8019ab:	00 02 00 
	MemBlockNodes = (void*)USER_DYN_BLKS_ARRAY;
  8019ae:	c7 45 f4 00 00 e0 7f 	movl   $0x7fe00000,-0xc(%ebp)
  8019b5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8019b8:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8019bd:	2d 00 10 00 00       	sub    $0x1000,%eax
  8019c2:	a3 50 50 80 00       	mov    %eax,0x805050
	int size_of_block = sizeof(struct MemBlock);
  8019c7:	c7 45 f0 10 00 00 00 	movl   $0x10,-0x10(%ebp)
	int size_all_struct = size_of_block*MAX_MEM_BLOCK_CNT;
  8019ce:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8019d1:	a1 20 51 80 00       	mov    0x805120,%eax
  8019d6:	0f af c2             	imul   %edx,%eax
  8019d9:	89 45 ec             	mov    %eax,-0x14(%ebp)
	size_all_struct = ROUNDUP(size_all_struct, PAGE_SIZE);
  8019dc:	c7 45 e8 00 10 00 00 	movl   $0x1000,-0x18(%ebp)
  8019e3:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8019e6:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8019e9:	01 d0                	add    %edx,%eax
  8019eb:	48                   	dec    %eax
  8019ec:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8019ef:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8019f2:	ba 00 00 00 00       	mov    $0x0,%edx
  8019f7:	f7 75 e8             	divl   -0x18(%ebp)
  8019fa:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8019fd:	29 d0                	sub    %edx,%eax
  8019ff:	89 45 ec             	mov    %eax,-0x14(%ebp)
	sys_allocate_chunk(USER_DYN_BLKS_ARRAY, size_all_struct,PERM_USER| PERM_WRITEABLE);
  801a02:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801a05:	c7 45 e0 00 00 e0 7f 	movl   $0x7fe00000,-0x20(%ebp)
  801a0c:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801a0f:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
  801a15:	81 ea 00 10 00 00    	sub    $0x1000,%edx
  801a1b:	83 ec 04             	sub    $0x4,%esp
  801a1e:	6a 06                	push   $0x6
  801a20:	50                   	push   %eax
  801a21:	52                   	push   %edx
  801a22:	e8 a1 05 00 00       	call   801fc8 <sys_allocate_chunk>
  801a27:	83 c4 10             	add    $0x10,%esp
	initialize_MemBlocksList(MAX_MEM_BLOCK_CNT);
  801a2a:	a1 20 51 80 00       	mov    0x805120,%eax
  801a2f:	83 ec 0c             	sub    $0xc,%esp
  801a32:	50                   	push   %eax
  801a33:	e8 16 0c 00 00       	call   80264e <initialize_MemBlocksList>
  801a38:	83 c4 10             	add    $0x10,%esp
	struct MemBlock* ourBlock =LIST_LAST(&AvailableMemBlocksList);
  801a3b:	a1 4c 51 80 00       	mov    0x80514c,%eax
  801a40:	89 45 dc             	mov    %eax,-0x24(%ebp)
	LIST_REMOVE(&AvailableMemBlocksList,ourBlock);
  801a43:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  801a47:	75 14                	jne    801a5d <initialize_dyn_block_system+0xfb>
  801a49:	83 ec 04             	sub    $0x4,%esp
  801a4c:	68 d5 3e 80 00       	push   $0x803ed5
  801a51:	6a 2d                	push   $0x2d
  801a53:	68 f3 3e 80 00       	push   $0x803ef3
  801a58:	e8 96 ee ff ff       	call   8008f3 <_panic>
  801a5d:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801a60:	8b 00                	mov    (%eax),%eax
  801a62:	85 c0                	test   %eax,%eax
  801a64:	74 10                	je     801a76 <initialize_dyn_block_system+0x114>
  801a66:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801a69:	8b 00                	mov    (%eax),%eax
  801a6b:	8b 55 dc             	mov    -0x24(%ebp),%edx
  801a6e:	8b 52 04             	mov    0x4(%edx),%edx
  801a71:	89 50 04             	mov    %edx,0x4(%eax)
  801a74:	eb 0b                	jmp    801a81 <initialize_dyn_block_system+0x11f>
  801a76:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801a79:	8b 40 04             	mov    0x4(%eax),%eax
  801a7c:	a3 4c 51 80 00       	mov    %eax,0x80514c
  801a81:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801a84:	8b 40 04             	mov    0x4(%eax),%eax
  801a87:	85 c0                	test   %eax,%eax
  801a89:	74 0f                	je     801a9a <initialize_dyn_block_system+0x138>
  801a8b:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801a8e:	8b 40 04             	mov    0x4(%eax),%eax
  801a91:	8b 55 dc             	mov    -0x24(%ebp),%edx
  801a94:	8b 12                	mov    (%edx),%edx
  801a96:	89 10                	mov    %edx,(%eax)
  801a98:	eb 0a                	jmp    801aa4 <initialize_dyn_block_system+0x142>
  801a9a:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801a9d:	8b 00                	mov    (%eax),%eax
  801a9f:	a3 48 51 80 00       	mov    %eax,0x805148
  801aa4:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801aa7:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  801aad:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801ab0:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  801ab7:	a1 54 51 80 00       	mov    0x805154,%eax
  801abc:	48                   	dec    %eax
  801abd:	a3 54 51 80 00       	mov    %eax,0x805154
	ourBlock->size = USER_HEAP_MAX-USER_HEAP_START;
  801ac2:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801ac5:	c7 40 0c 00 00 00 20 	movl   $0x20000000,0xc(%eax)
	ourBlock->sva=USER_HEAP_START;
  801acc:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801acf:	c7 40 08 00 00 00 80 	movl   $0x80000000,0x8(%eax)
	LIST_INSERT_TAIL(&FreeMemBlocksList, ourBlock);
  801ad6:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  801ada:	75 14                	jne    801af0 <initialize_dyn_block_system+0x18e>
  801adc:	83 ec 04             	sub    $0x4,%esp
  801adf:	68 00 3f 80 00       	push   $0x803f00
  801ae4:	6a 30                	push   $0x30
  801ae6:	68 f3 3e 80 00       	push   $0x803ef3
  801aeb:	e8 03 ee ff ff       	call   8008f3 <_panic>
  801af0:	8b 15 3c 51 80 00    	mov    0x80513c,%edx
  801af6:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801af9:	89 50 04             	mov    %edx,0x4(%eax)
  801afc:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801aff:	8b 40 04             	mov    0x4(%eax),%eax
  801b02:	85 c0                	test   %eax,%eax
  801b04:	74 0c                	je     801b12 <initialize_dyn_block_system+0x1b0>
  801b06:	a1 3c 51 80 00       	mov    0x80513c,%eax
  801b0b:	8b 55 dc             	mov    -0x24(%ebp),%edx
  801b0e:	89 10                	mov    %edx,(%eax)
  801b10:	eb 08                	jmp    801b1a <initialize_dyn_block_system+0x1b8>
  801b12:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801b15:	a3 38 51 80 00       	mov    %eax,0x805138
  801b1a:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801b1d:	a3 3c 51 80 00       	mov    %eax,0x80513c
  801b22:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801b25:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  801b2b:	a1 44 51 80 00       	mov    0x805144,%eax
  801b30:	40                   	inc    %eax
  801b31:	a3 44 51 80 00       	mov    %eax,0x805144
	//[1] Initialize two lists (AllocMemBlocksList & FreeMemBlocksList) [Hint: use LIST_INIT()]
	//[2] Dynamically allocate the array of MemBlockNodes at VA USER_DYN_BLKS_ARRAY
	//	  (remember to set MAX_MEM_BLOCK_CNT with the chosen size of the array)
	//[3] Initialize AvailableMemBlocksList by filling it with the MemBlockNodes
	//[4] Insert a new MemBlock with the heap size into the FreeMemBlocksList
}
  801b36:	90                   	nop
  801b37:	c9                   	leave  
  801b38:	c3                   	ret    

00801b39 <malloc>:
//=================================
// [2] ALLOCATE SPACE IN USER HEAP:
//=================================

void* malloc(uint32 size)
{
  801b39:	55                   	push   %ebp
  801b3a:	89 e5                	mov    %esp,%ebp
  801b3c:	83 ec 18             	sub    $0x18,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801b3f:	e8 ed fd ff ff       	call   801931 <InitializeUHeap>
	if (size == 0) return NULL ;
  801b44:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801b48:	75 07                	jne    801b51 <malloc+0x18>
  801b4a:	b8 00 00 00 00       	mov    $0x0,%eax
  801b4f:	eb 67                	jmp    801bb8 <malloc+0x7f>

	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] malloc
	// your code is here, remove the panic and write your code
	//panic("malloc() is not implemented yet...!!");

	size = ROUNDUP(size, PAGE_SIZE);
  801b51:	c7 45 f4 00 10 00 00 	movl   $0x1000,-0xc(%ebp)
  801b58:	8b 55 08             	mov    0x8(%ebp),%edx
  801b5b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801b5e:	01 d0                	add    %edx,%eax
  801b60:	48                   	dec    %eax
  801b61:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801b64:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801b67:	ba 00 00 00 00       	mov    $0x0,%edx
  801b6c:	f7 75 f4             	divl   -0xc(%ebp)
  801b6f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801b72:	29 d0                	sub    %edx,%eax
  801b74:	89 45 08             	mov    %eax,0x8(%ebp)
	if(sys_isUHeapPlacementStrategyFIRSTFIT())
  801b77:	e8 1a 08 00 00       	call   802396 <sys_isUHeapPlacementStrategyFIRSTFIT>
  801b7c:	85 c0                	test   %eax,%eax
  801b7e:	74 33                	je     801bb3 <malloc+0x7a>
	{
		struct MemBlock * myBlock = alloc_block_FF(size);
  801b80:	83 ec 0c             	sub    $0xc,%esp
  801b83:	ff 75 08             	pushl  0x8(%ebp)
  801b86:	e8 0c 0e 00 00       	call   802997 <alloc_block_FF>
  801b8b:	83 c4 10             	add    $0x10,%esp
  801b8e:	89 45 ec             	mov    %eax,-0x14(%ebp)
		if(myBlock != NULL)
  801b91:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  801b95:	74 1c                	je     801bb3 <malloc+0x7a>
		{
			insert_sorted_allocList(myBlock);
  801b97:	83 ec 0c             	sub    $0xc,%esp
  801b9a:	ff 75 ec             	pushl  -0x14(%ebp)
  801b9d:	e8 07 0c 00 00       	call   8027a9 <insert_sorted_allocList>
  801ba2:	83 c4 10             	add    $0x10,%esp
			uint32 ptr = myBlock->sva;
  801ba5:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801ba8:	8b 40 08             	mov    0x8(%eax),%eax
  801bab:	89 45 e8             	mov    %eax,-0x18(%ebp)
			return (void *)ptr;
  801bae:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801bb1:	eb 05                	jmp    801bb8 <malloc+0x7f>
		}
	}
	return NULL;
  801bb3:	b8 00 00 00 00       	mov    $0x0,%eax
	//		to the required allocation size (space should be on 4 KB BOUNDARY)
	//	2) if no suitable space found, return NULL
	// 	3) Return pointer containing the virtual address of allocated space,
	//
	//Use sys_isUHeapPlacementStrategyFIRSTFIT()... to check the current strategy
}
  801bb8:	c9                   	leave  
  801bb9:	c3                   	ret    

00801bba <free>:
//	We can use sys_free_user_mem(uint32 virtual_address, uint32 size); which
//		switches to the kernel mode, calls free_user_mem() in
//		"kern/mem/chunk_operations.c", then switch back to the user mode here
//	the free_user_mem function is empty, make sure to implement it.
void free(void* virtual_address)
{
  801bba:	55                   	push   %ebp
  801bbb:	89 e5                	mov    %esp,%ebp
  801bbd:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] free
	// your code is here, remove the panic and write your code
	//panic("free() is not implemented yet...!!");

	uint32 virtualAddress = (uint32 )(virtual_address);
  801bc0:	8b 45 08             	mov    0x8(%ebp),%eax
  801bc3:	89 45 f4             	mov    %eax,-0xc(%ebp)
//	virtualAddress = ROUNDDOWN(virtualAddress, PAGE_SIZE);
	struct MemBlock * myBlock = find_block(&AllocMemBlocksList, virtualAddress);
  801bc6:	83 ec 08             	sub    $0x8,%esp
  801bc9:	ff 75 f4             	pushl  -0xc(%ebp)
  801bcc:	68 40 50 80 00       	push   $0x805040
  801bd1:	e8 5b 0b 00 00       	call   802731 <find_block>
  801bd6:	83 c4 10             	add    $0x10,%esp
  801bd9:	89 45 f0             	mov    %eax,-0x10(%ebp)
//	cprintf ("ptr sva at free user side = %x \n", myBlock->sva);
	sys_free_user_mem(virtualAddress, myBlock->size);
  801bdc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801bdf:	8b 40 0c             	mov    0xc(%eax),%eax
  801be2:	83 ec 08             	sub    $0x8,%esp
  801be5:	50                   	push   %eax
  801be6:	ff 75 f4             	pushl  -0xc(%ebp)
  801be9:	e8 a2 03 00 00       	call   801f90 <sys_free_user_mem>
  801bee:	83 c4 10             	add    $0x10,%esp
	LIST_REMOVE(&AllocMemBlocksList, myBlock);
  801bf1:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801bf5:	75 14                	jne    801c0b <free+0x51>
  801bf7:	83 ec 04             	sub    $0x4,%esp
  801bfa:	68 d5 3e 80 00       	push   $0x803ed5
  801bff:	6a 76                	push   $0x76
  801c01:	68 f3 3e 80 00       	push   $0x803ef3
  801c06:	e8 e8 ec ff ff       	call   8008f3 <_panic>
  801c0b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801c0e:	8b 00                	mov    (%eax),%eax
  801c10:	85 c0                	test   %eax,%eax
  801c12:	74 10                	je     801c24 <free+0x6a>
  801c14:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801c17:	8b 00                	mov    (%eax),%eax
  801c19:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801c1c:	8b 52 04             	mov    0x4(%edx),%edx
  801c1f:	89 50 04             	mov    %edx,0x4(%eax)
  801c22:	eb 0b                	jmp    801c2f <free+0x75>
  801c24:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801c27:	8b 40 04             	mov    0x4(%eax),%eax
  801c2a:	a3 44 50 80 00       	mov    %eax,0x805044
  801c2f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801c32:	8b 40 04             	mov    0x4(%eax),%eax
  801c35:	85 c0                	test   %eax,%eax
  801c37:	74 0f                	je     801c48 <free+0x8e>
  801c39:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801c3c:	8b 40 04             	mov    0x4(%eax),%eax
  801c3f:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801c42:	8b 12                	mov    (%edx),%edx
  801c44:	89 10                	mov    %edx,(%eax)
  801c46:	eb 0a                	jmp    801c52 <free+0x98>
  801c48:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801c4b:	8b 00                	mov    (%eax),%eax
  801c4d:	a3 40 50 80 00       	mov    %eax,0x805040
  801c52:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801c55:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  801c5b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801c5e:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  801c65:	a1 4c 50 80 00       	mov    0x80504c,%eax
  801c6a:	48                   	dec    %eax
  801c6b:	a3 4c 50 80 00       	mov    %eax,0x80504c
	insert_sorted_with_merge_freeList(myBlock);
  801c70:	83 ec 0c             	sub    $0xc,%esp
  801c73:	ff 75 f0             	pushl  -0x10(%ebp)
  801c76:	e8 0b 14 00 00       	call   803086 <insert_sorted_with_merge_freeList>
  801c7b:	83 c4 10             	add    $0x10,%esp

	//you should get the size of the given allocation using its address
	//you need to call sys_free_user_mem()
	//refer to the project presentation and documentation for details
}
  801c7e:	90                   	nop
  801c7f:	c9                   	leave  
  801c80:	c3                   	ret    

00801c81 <smalloc>:

//=================================
// [4] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
  801c81:	55                   	push   %ebp
  801c82:	89 e5                	mov    %esp,%ebp
  801c84:	83 ec 28             	sub    $0x28,%esp
  801c87:	8b 45 10             	mov    0x10(%ebp),%eax
  801c8a:	88 45 e4             	mov    %al,-0x1c(%ebp)
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801c8d:	e8 9f fc ff ff       	call   801931 <InitializeUHeap>
	if (size == 0) return NULL ;
  801c92:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801c96:	75 0a                	jne    801ca2 <smalloc+0x21>
  801c98:	b8 00 00 00 00       	mov    $0x0,%eax
  801c9d:	e9 8d 00 00 00       	jmp    801d2f <smalloc+0xae>

	//This function should find the space of the required range
	// * ON 4KB BOUNDARY **** //
	//Use sys_isUHeapPlacementStrategyFIRSTFIT() to check the current strategy

	size = ROUNDUP(size, PAGE_SIZE);
  801ca2:	c7 45 f4 00 10 00 00 	movl   $0x1000,-0xc(%ebp)
  801ca9:	8b 55 0c             	mov    0xc(%ebp),%edx
  801cac:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801caf:	01 d0                	add    %edx,%eax
  801cb1:	48                   	dec    %eax
  801cb2:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801cb5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801cb8:	ba 00 00 00 00       	mov    $0x0,%edx
  801cbd:	f7 75 f4             	divl   -0xc(%ebp)
  801cc0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801cc3:	29 d0                	sub    %edx,%eax
  801cc5:	89 45 0c             	mov    %eax,0xc(%ebp)
		if(sys_isUHeapPlacementStrategyFIRSTFIT())
  801cc8:	e8 c9 06 00 00       	call   802396 <sys_isUHeapPlacementStrategyFIRSTFIT>
  801ccd:	85 c0                	test   %eax,%eax
  801ccf:	74 59                	je     801d2a <smalloc+0xa9>
		{
			struct MemBlock * v1=NULL;
  801cd1:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
			v1= alloc_block_FF(size);
  801cd8:	83 ec 0c             	sub    $0xc,%esp
  801cdb:	ff 75 0c             	pushl  0xc(%ebp)
  801cde:	e8 b4 0c 00 00       	call   802997 <alloc_block_FF>
  801ce3:	83 c4 10             	add    $0x10,%esp
  801ce6:	89 45 ec             	mov    %eax,-0x14(%ebp)
			if(v1==NULL)
  801ce9:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  801ced:	75 07                	jne    801cf6 <smalloc+0x75>
			{
				return NULL;
  801cef:	b8 00 00 00 00       	mov    $0x0,%eax
  801cf4:	eb 39                	jmp    801d2f <smalloc+0xae>
			}
			else
			{
				int ret=sys_createSharedObject(sharedVarName,  size,  isWritable,(void*)v1->sva);
  801cf6:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801cf9:	8b 40 08             	mov    0x8(%eax),%eax
  801cfc:	89 c2                	mov    %eax,%edx
  801cfe:	0f b6 45 e4          	movzbl -0x1c(%ebp),%eax
  801d02:	52                   	push   %edx
  801d03:	50                   	push   %eax
  801d04:	ff 75 0c             	pushl  0xc(%ebp)
  801d07:	ff 75 08             	pushl  0x8(%ebp)
  801d0a:	e8 0c 04 00 00       	call   80211b <sys_createSharedObject>
  801d0f:	83 c4 10             	add    $0x10,%esp
  801d12:	89 45 e8             	mov    %eax,-0x18(%ebp)
				if(ret>=0)
  801d15:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  801d19:	78 08                	js     801d23 <smalloc+0xa2>
				{
					return (void*)v1->sva;
  801d1b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801d1e:	8b 40 08             	mov    0x8(%eax),%eax
  801d21:	eb 0c                	jmp    801d2f <smalloc+0xae>
				}
				else
				{
					return NULL;
  801d23:	b8 00 00 00 00       	mov    $0x0,%eax
  801d28:	eb 05                	jmp    801d2f <smalloc+0xae>
				}
			}

		}
		return NULL;
  801d2a:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801d2f:	c9                   	leave  
  801d30:	c3                   	ret    

00801d31 <sget>:

//========================================
// [5] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  801d31:	55                   	push   %ebp
  801d32:	89 e5                	mov    %esp,%ebp
  801d34:	83 ec 18             	sub    $0x18,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801d37:	e8 f5 fb ff ff       	call   801931 <InitializeUHeap>

	//This function should find the space for sharing the variable
	// *** ON 4KB BOUNDARY ******** //

	//Use sys_isUHeapPlacementStrategyFIRSTFIT() to check the current strategy
	int ret=sys_getSizeOfSharedObject(ownerEnvID,sharedVarName);
  801d3c:	83 ec 08             	sub    $0x8,%esp
  801d3f:	ff 75 0c             	pushl  0xc(%ebp)
  801d42:	ff 75 08             	pushl  0x8(%ebp)
  801d45:	e8 fb 03 00 00       	call   802145 <sys_getSizeOfSharedObject>
  801d4a:	83 c4 10             	add    $0x10,%esp
  801d4d:	89 45 f4             	mov    %eax,-0xc(%ebp)
	if(ret==0)
  801d50:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801d54:	75 07                	jne    801d5d <sget+0x2c>
	{
		return NULL;
  801d56:	b8 00 00 00 00       	mov    $0x0,%eax
  801d5b:	eb 64                	jmp    801dc1 <sget+0x90>
	}
	if(sys_isUHeapPlacementStrategyFIRSTFIT())
  801d5d:	e8 34 06 00 00       	call   802396 <sys_isUHeapPlacementStrategyFIRSTFIT>
  801d62:	85 c0                	test   %eax,%eax
  801d64:	74 56                	je     801dbc <sget+0x8b>
	{
		struct MemBlock * v1=NULL;
  801d66:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
		v1= alloc_block_FF(ret);
  801d6d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801d70:	83 ec 0c             	sub    $0xc,%esp
  801d73:	50                   	push   %eax
  801d74:	e8 1e 0c 00 00       	call   802997 <alloc_block_FF>
  801d79:	83 c4 10             	add    $0x10,%esp
  801d7c:	89 45 f0             	mov    %eax,-0x10(%ebp)
		if(v1==NULL)
  801d7f:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801d83:	75 07                	jne    801d8c <sget+0x5b>
		{
		return NULL;
  801d85:	b8 00 00 00 00       	mov    $0x0,%eax
  801d8a:	eb 35                	jmp    801dc1 <sget+0x90>
	    }
		else
		{
			int ret1=sys_getSharedObject(ownerEnvID,sharedVarName,(void*)v1->sva);
  801d8c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801d8f:	8b 40 08             	mov    0x8(%eax),%eax
  801d92:	83 ec 04             	sub    $0x4,%esp
  801d95:	50                   	push   %eax
  801d96:	ff 75 0c             	pushl  0xc(%ebp)
  801d99:	ff 75 08             	pushl  0x8(%ebp)
  801d9c:	e8 c1 03 00 00       	call   802162 <sys_getSharedObject>
  801da1:	83 c4 10             	add    $0x10,%esp
  801da4:	89 45 ec             	mov    %eax,-0x14(%ebp)
			if(ret1>=0)
  801da7:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  801dab:	78 08                	js     801db5 <sget+0x84>
			{
				return (void*)v1->sva;
  801dad:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801db0:	8b 40 08             	mov    0x8(%eax),%eax
  801db3:	eb 0c                	jmp    801dc1 <sget+0x90>
			}
			else
			{
				return NULL;
  801db5:	b8 00 00 00 00       	mov    $0x0,%eax
  801dba:	eb 05                	jmp    801dc1 <sget+0x90>
			}
		}
	}
  return NULL;
  801dbc:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801dc1:	c9                   	leave  
  801dc2:	c3                   	ret    

00801dc3 <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  801dc3:	55                   	push   %ebp
  801dc4:	89 e5                	mov    %esp,%ebp
  801dc6:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801dc9:	e8 63 fb ff ff       	call   801931 <InitializeUHeap>
	//==============================================================
	// [USER HEAP - USER SIDE] realloc
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  801dce:	83 ec 04             	sub    $0x4,%esp
  801dd1:	68 24 3f 80 00       	push   $0x803f24
  801dd6:	68 0e 01 00 00       	push   $0x10e
  801ddb:	68 f3 3e 80 00       	push   $0x803ef3
  801de0:	e8 0e eb ff ff       	call   8008f3 <_panic>

00801de5 <sfree>:
//	use sys_freeSharedObject(...); which switches to the kernel mode,
//	calls freeSharedObject(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the freeSharedObject() function is empty, make sure to implement it.

void sfree(void* virtual_address)
{
  801de5:	55                   	push   %ebp
  801de6:	89 e5                	mov    %esp,%ebp
  801de8:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS3 - BONUS] [SHARING - USER SIDE] sfree()

	// Write your code here, remove the panic and write your code
	panic("sfree() is not implemented yet...!!");
  801deb:	83 ec 04             	sub    $0x4,%esp
  801dee:	68 4c 3f 80 00       	push   $0x803f4c
  801df3:	68 22 01 00 00       	push   $0x122
  801df8:	68 f3 3e 80 00       	push   $0x803ef3
  801dfd:	e8 f1 ea ff ff       	call   8008f3 <_panic>

00801e02 <expand>:

//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//
void expand(uint32 newSize)
{
  801e02:	55                   	push   %ebp
  801e03:	89 e5                	mov    %esp,%ebp
  801e05:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801e08:	83 ec 04             	sub    $0x4,%esp
  801e0b:	68 70 3f 80 00       	push   $0x803f70
  801e10:	68 2d 01 00 00       	push   $0x12d
  801e15:	68 f3 3e 80 00       	push   $0x803ef3
  801e1a:	e8 d4 ea ff ff       	call   8008f3 <_panic>

00801e1f <shrink>:

}
void shrink(uint32 newSize)
{
  801e1f:	55                   	push   %ebp
  801e20:	89 e5                	mov    %esp,%ebp
  801e22:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801e25:	83 ec 04             	sub    $0x4,%esp
  801e28:	68 70 3f 80 00       	push   $0x803f70
  801e2d:	68 32 01 00 00       	push   $0x132
  801e32:	68 f3 3e 80 00       	push   $0x803ef3
  801e37:	e8 b7 ea ff ff       	call   8008f3 <_panic>

00801e3c <freeHeap>:

}
void freeHeap(void* virtual_address)
{
  801e3c:	55                   	push   %ebp
  801e3d:	89 e5                	mov    %esp,%ebp
  801e3f:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801e42:	83 ec 04             	sub    $0x4,%esp
  801e45:	68 70 3f 80 00       	push   $0x803f70
  801e4a:	68 37 01 00 00       	push   $0x137
  801e4f:	68 f3 3e 80 00       	push   $0x803ef3
  801e54:	e8 9a ea ff ff       	call   8008f3 <_panic>

00801e59 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  801e59:	55                   	push   %ebp
  801e5a:	89 e5                	mov    %esp,%ebp
  801e5c:	57                   	push   %edi
  801e5d:	56                   	push   %esi
  801e5e:	53                   	push   %ebx
  801e5f:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801e62:	8b 45 08             	mov    0x8(%ebp),%eax
  801e65:	8b 55 0c             	mov    0xc(%ebp),%edx
  801e68:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801e6b:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801e6e:	8b 7d 18             	mov    0x18(%ebp),%edi
  801e71:	8b 75 1c             	mov    0x1c(%ebp),%esi
  801e74:	cd 30                	int    $0x30
  801e76:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  801e79:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801e7c:	83 c4 10             	add    $0x10,%esp
  801e7f:	5b                   	pop    %ebx
  801e80:	5e                   	pop    %esi
  801e81:	5f                   	pop    %edi
  801e82:	5d                   	pop    %ebp
  801e83:	c3                   	ret    

00801e84 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  801e84:	55                   	push   %ebp
  801e85:	89 e5                	mov    %esp,%ebp
  801e87:	83 ec 04             	sub    $0x4,%esp
  801e8a:	8b 45 10             	mov    0x10(%ebp),%eax
  801e8d:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  801e90:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801e94:	8b 45 08             	mov    0x8(%ebp),%eax
  801e97:	6a 00                	push   $0x0
  801e99:	6a 00                	push   $0x0
  801e9b:	52                   	push   %edx
  801e9c:	ff 75 0c             	pushl  0xc(%ebp)
  801e9f:	50                   	push   %eax
  801ea0:	6a 00                	push   $0x0
  801ea2:	e8 b2 ff ff ff       	call   801e59 <syscall>
  801ea7:	83 c4 18             	add    $0x18,%esp
}
  801eaa:	90                   	nop
  801eab:	c9                   	leave  
  801eac:	c3                   	ret    

00801ead <sys_cgetc>:

int
sys_cgetc(void)
{
  801ead:	55                   	push   %ebp
  801eae:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  801eb0:	6a 00                	push   $0x0
  801eb2:	6a 00                	push   $0x0
  801eb4:	6a 00                	push   $0x0
  801eb6:	6a 00                	push   $0x0
  801eb8:	6a 00                	push   $0x0
  801eba:	6a 01                	push   $0x1
  801ebc:	e8 98 ff ff ff       	call   801e59 <syscall>
  801ec1:	83 c4 18             	add    $0x18,%esp
}
  801ec4:	c9                   	leave  
  801ec5:	c3                   	ret    

00801ec6 <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  801ec6:	55                   	push   %ebp
  801ec7:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  801ec9:	8b 55 0c             	mov    0xc(%ebp),%edx
  801ecc:	8b 45 08             	mov    0x8(%ebp),%eax
  801ecf:	6a 00                	push   $0x0
  801ed1:	6a 00                	push   $0x0
  801ed3:	6a 00                	push   $0x0
  801ed5:	52                   	push   %edx
  801ed6:	50                   	push   %eax
  801ed7:	6a 05                	push   $0x5
  801ed9:	e8 7b ff ff ff       	call   801e59 <syscall>
  801ede:	83 c4 18             	add    $0x18,%esp
}
  801ee1:	c9                   	leave  
  801ee2:	c3                   	ret    

00801ee3 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  801ee3:	55                   	push   %ebp
  801ee4:	89 e5                	mov    %esp,%ebp
  801ee6:	56                   	push   %esi
  801ee7:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  801ee8:	8b 75 18             	mov    0x18(%ebp),%esi
  801eeb:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801eee:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801ef1:	8b 55 0c             	mov    0xc(%ebp),%edx
  801ef4:	8b 45 08             	mov    0x8(%ebp),%eax
  801ef7:	56                   	push   %esi
  801ef8:	53                   	push   %ebx
  801ef9:	51                   	push   %ecx
  801efa:	52                   	push   %edx
  801efb:	50                   	push   %eax
  801efc:	6a 06                	push   $0x6
  801efe:	e8 56 ff ff ff       	call   801e59 <syscall>
  801f03:	83 c4 18             	add    $0x18,%esp
}
  801f06:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801f09:	5b                   	pop    %ebx
  801f0a:	5e                   	pop    %esi
  801f0b:	5d                   	pop    %ebp
  801f0c:	c3                   	ret    

00801f0d <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  801f0d:	55                   	push   %ebp
  801f0e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  801f10:	8b 55 0c             	mov    0xc(%ebp),%edx
  801f13:	8b 45 08             	mov    0x8(%ebp),%eax
  801f16:	6a 00                	push   $0x0
  801f18:	6a 00                	push   $0x0
  801f1a:	6a 00                	push   $0x0
  801f1c:	52                   	push   %edx
  801f1d:	50                   	push   %eax
  801f1e:	6a 07                	push   $0x7
  801f20:	e8 34 ff ff ff       	call   801e59 <syscall>
  801f25:	83 c4 18             	add    $0x18,%esp
}
  801f28:	c9                   	leave  
  801f29:	c3                   	ret    

00801f2a <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  801f2a:	55                   	push   %ebp
  801f2b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  801f2d:	6a 00                	push   $0x0
  801f2f:	6a 00                	push   $0x0
  801f31:	6a 00                	push   $0x0
  801f33:	ff 75 0c             	pushl  0xc(%ebp)
  801f36:	ff 75 08             	pushl  0x8(%ebp)
  801f39:	6a 08                	push   $0x8
  801f3b:	e8 19 ff ff ff       	call   801e59 <syscall>
  801f40:	83 c4 18             	add    $0x18,%esp
}
  801f43:	c9                   	leave  
  801f44:	c3                   	ret    

00801f45 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  801f45:	55                   	push   %ebp
  801f46:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  801f48:	6a 00                	push   $0x0
  801f4a:	6a 00                	push   $0x0
  801f4c:	6a 00                	push   $0x0
  801f4e:	6a 00                	push   $0x0
  801f50:	6a 00                	push   $0x0
  801f52:	6a 09                	push   $0x9
  801f54:	e8 00 ff ff ff       	call   801e59 <syscall>
  801f59:	83 c4 18             	add    $0x18,%esp
}
  801f5c:	c9                   	leave  
  801f5d:	c3                   	ret    

00801f5e <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  801f5e:	55                   	push   %ebp
  801f5f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  801f61:	6a 00                	push   $0x0
  801f63:	6a 00                	push   $0x0
  801f65:	6a 00                	push   $0x0
  801f67:	6a 00                	push   $0x0
  801f69:	6a 00                	push   $0x0
  801f6b:	6a 0a                	push   $0xa
  801f6d:	e8 e7 fe ff ff       	call   801e59 <syscall>
  801f72:	83 c4 18             	add    $0x18,%esp
}
  801f75:	c9                   	leave  
  801f76:	c3                   	ret    

00801f77 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  801f77:	55                   	push   %ebp
  801f78:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  801f7a:	6a 00                	push   $0x0
  801f7c:	6a 00                	push   $0x0
  801f7e:	6a 00                	push   $0x0
  801f80:	6a 00                	push   $0x0
  801f82:	6a 00                	push   $0x0
  801f84:	6a 0b                	push   $0xb
  801f86:	e8 ce fe ff ff       	call   801e59 <syscall>
  801f8b:	83 c4 18             	add    $0x18,%esp
}
  801f8e:	c9                   	leave  
  801f8f:	c3                   	ret    

00801f90 <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  801f90:	55                   	push   %ebp
  801f91:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  801f93:	6a 00                	push   $0x0
  801f95:	6a 00                	push   $0x0
  801f97:	6a 00                	push   $0x0
  801f99:	ff 75 0c             	pushl  0xc(%ebp)
  801f9c:	ff 75 08             	pushl  0x8(%ebp)
  801f9f:	6a 0f                	push   $0xf
  801fa1:	e8 b3 fe ff ff       	call   801e59 <syscall>
  801fa6:	83 c4 18             	add    $0x18,%esp
	return;
  801fa9:	90                   	nop
}
  801faa:	c9                   	leave  
  801fab:	c3                   	ret    

00801fac <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  801fac:	55                   	push   %ebp
  801fad:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  801faf:	6a 00                	push   $0x0
  801fb1:	6a 00                	push   $0x0
  801fb3:	6a 00                	push   $0x0
  801fb5:	ff 75 0c             	pushl  0xc(%ebp)
  801fb8:	ff 75 08             	pushl  0x8(%ebp)
  801fbb:	6a 10                	push   $0x10
  801fbd:	e8 97 fe ff ff       	call   801e59 <syscall>
  801fc2:	83 c4 18             	add    $0x18,%esp
	return ;
  801fc5:	90                   	nop
}
  801fc6:	c9                   	leave  
  801fc7:	c3                   	ret    

00801fc8 <sys_allocate_chunk>:

void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  801fc8:	55                   	push   %ebp
  801fc9:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  801fcb:	6a 00                	push   $0x0
  801fcd:	6a 00                	push   $0x0
  801fcf:	ff 75 10             	pushl  0x10(%ebp)
  801fd2:	ff 75 0c             	pushl  0xc(%ebp)
  801fd5:	ff 75 08             	pushl  0x8(%ebp)
  801fd8:	6a 11                	push   $0x11
  801fda:	e8 7a fe ff ff       	call   801e59 <syscall>
  801fdf:	83 c4 18             	add    $0x18,%esp
	return ;
  801fe2:	90                   	nop
}
  801fe3:	c9                   	leave  
  801fe4:	c3                   	ret    

00801fe5 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  801fe5:	55                   	push   %ebp
  801fe6:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  801fe8:	6a 00                	push   $0x0
  801fea:	6a 00                	push   $0x0
  801fec:	6a 00                	push   $0x0
  801fee:	6a 00                	push   $0x0
  801ff0:	6a 00                	push   $0x0
  801ff2:	6a 0c                	push   $0xc
  801ff4:	e8 60 fe ff ff       	call   801e59 <syscall>
  801ff9:	83 c4 18             	add    $0x18,%esp
}
  801ffc:	c9                   	leave  
  801ffd:	c3                   	ret    

00801ffe <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  801ffe:	55                   	push   %ebp
  801fff:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  802001:	6a 00                	push   $0x0
  802003:	6a 00                	push   $0x0
  802005:	6a 00                	push   $0x0
  802007:	6a 00                	push   $0x0
  802009:	ff 75 08             	pushl  0x8(%ebp)
  80200c:	6a 0d                	push   $0xd
  80200e:	e8 46 fe ff ff       	call   801e59 <syscall>
  802013:	83 c4 18             	add    $0x18,%esp
}
  802016:	c9                   	leave  
  802017:	c3                   	ret    

00802018 <sys_scarce_memory>:

void sys_scarce_memory()
{
  802018:	55                   	push   %ebp
  802019:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  80201b:	6a 00                	push   $0x0
  80201d:	6a 00                	push   $0x0
  80201f:	6a 00                	push   $0x0
  802021:	6a 00                	push   $0x0
  802023:	6a 00                	push   $0x0
  802025:	6a 0e                	push   $0xe
  802027:	e8 2d fe ff ff       	call   801e59 <syscall>
  80202c:	83 c4 18             	add    $0x18,%esp
}
  80202f:	90                   	nop
  802030:	c9                   	leave  
  802031:	c3                   	ret    

00802032 <sys_disable_interrupt>:

//NEW !! 2012...
void
sys_disable_interrupt()
{
  802032:	55                   	push   %ebp
  802033:	89 e5                	mov    %esp,%ebp
	syscall(SYS_disableINTR,0, 0, 0, 0, 0);
  802035:	6a 00                	push   $0x0
  802037:	6a 00                	push   $0x0
  802039:	6a 00                	push   $0x0
  80203b:	6a 00                	push   $0x0
  80203d:	6a 00                	push   $0x0
  80203f:	6a 13                	push   $0x13
  802041:	e8 13 fe ff ff       	call   801e59 <syscall>
  802046:	83 c4 18             	add    $0x18,%esp
}
  802049:	90                   	nop
  80204a:	c9                   	leave  
  80204b:	c3                   	ret    

0080204c <sys_enable_interrupt>:


void
sys_enable_interrupt()
{
  80204c:	55                   	push   %ebp
  80204d:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enableINTR,0, 0, 0, 0, 0);
  80204f:	6a 00                	push   $0x0
  802051:	6a 00                	push   $0x0
  802053:	6a 00                	push   $0x0
  802055:	6a 00                	push   $0x0
  802057:	6a 00                	push   $0x0
  802059:	6a 14                	push   $0x14
  80205b:	e8 f9 fd ff ff       	call   801e59 <syscall>
  802060:	83 c4 18             	add    $0x18,%esp
}
  802063:	90                   	nop
  802064:	c9                   	leave  
  802065:	c3                   	ret    

00802066 <sys_cputc>:


void
sys_cputc(const char c)
{
  802066:	55                   	push   %ebp
  802067:	89 e5                	mov    %esp,%ebp
  802069:	83 ec 04             	sub    $0x4,%esp
  80206c:	8b 45 08             	mov    0x8(%ebp),%eax
  80206f:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  802072:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  802076:	6a 00                	push   $0x0
  802078:	6a 00                	push   $0x0
  80207a:	6a 00                	push   $0x0
  80207c:	6a 00                	push   $0x0
  80207e:	50                   	push   %eax
  80207f:	6a 15                	push   $0x15
  802081:	e8 d3 fd ff ff       	call   801e59 <syscall>
  802086:	83 c4 18             	add    $0x18,%esp
}
  802089:	90                   	nop
  80208a:	c9                   	leave  
  80208b:	c3                   	ret    

0080208c <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  80208c:	55                   	push   %ebp
  80208d:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  80208f:	6a 00                	push   $0x0
  802091:	6a 00                	push   $0x0
  802093:	6a 00                	push   $0x0
  802095:	6a 00                	push   $0x0
  802097:	6a 00                	push   $0x0
  802099:	6a 16                	push   $0x16
  80209b:	e8 b9 fd ff ff       	call   801e59 <syscall>
  8020a0:	83 c4 18             	add    $0x18,%esp
}
  8020a3:	90                   	nop
  8020a4:	c9                   	leave  
  8020a5:	c3                   	ret    

008020a6 <sys_createSemaphore>:

int
sys_createSemaphore(char* semaphoreName, uint32 initialValue)
{
  8020a6:	55                   	push   %ebp
  8020a7:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_semaphore,(uint32)semaphoreName, (uint32)initialValue, 0, 0, 0);
  8020a9:	8b 45 08             	mov    0x8(%ebp),%eax
  8020ac:	6a 00                	push   $0x0
  8020ae:	6a 00                	push   $0x0
  8020b0:	6a 00                	push   $0x0
  8020b2:	ff 75 0c             	pushl  0xc(%ebp)
  8020b5:	50                   	push   %eax
  8020b6:	6a 17                	push   $0x17
  8020b8:	e8 9c fd ff ff       	call   801e59 <syscall>
  8020bd:	83 c4 18             	add    $0x18,%esp
}
  8020c0:	c9                   	leave  
  8020c1:	c3                   	ret    

008020c2 <sys_getSemaphoreValue>:

int
sys_getSemaphoreValue(int32 ownerEnvID, char* semaphoreName)
{
  8020c2:	55                   	push   %ebp
  8020c3:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_semaphore_value,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  8020c5:	8b 55 0c             	mov    0xc(%ebp),%edx
  8020c8:	8b 45 08             	mov    0x8(%ebp),%eax
  8020cb:	6a 00                	push   $0x0
  8020cd:	6a 00                	push   $0x0
  8020cf:	6a 00                	push   $0x0
  8020d1:	52                   	push   %edx
  8020d2:	50                   	push   %eax
  8020d3:	6a 1a                	push   $0x1a
  8020d5:	e8 7f fd ff ff       	call   801e59 <syscall>
  8020da:	83 c4 18             	add    $0x18,%esp
}
  8020dd:	c9                   	leave  
  8020de:	c3                   	ret    

008020df <sys_waitSemaphore>:

void
sys_waitSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  8020df:	55                   	push   %ebp
  8020e0:	89 e5                	mov    %esp,%ebp
	syscall(SYS_wait_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  8020e2:	8b 55 0c             	mov    0xc(%ebp),%edx
  8020e5:	8b 45 08             	mov    0x8(%ebp),%eax
  8020e8:	6a 00                	push   $0x0
  8020ea:	6a 00                	push   $0x0
  8020ec:	6a 00                	push   $0x0
  8020ee:	52                   	push   %edx
  8020ef:	50                   	push   %eax
  8020f0:	6a 18                	push   $0x18
  8020f2:	e8 62 fd ff ff       	call   801e59 <syscall>
  8020f7:	83 c4 18             	add    $0x18,%esp
}
  8020fa:	90                   	nop
  8020fb:	c9                   	leave  
  8020fc:	c3                   	ret    

008020fd <sys_signalSemaphore>:

void
sys_signalSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  8020fd:	55                   	push   %ebp
  8020fe:	89 e5                	mov    %esp,%ebp
	syscall(SYS_signal_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  802100:	8b 55 0c             	mov    0xc(%ebp),%edx
  802103:	8b 45 08             	mov    0x8(%ebp),%eax
  802106:	6a 00                	push   $0x0
  802108:	6a 00                	push   $0x0
  80210a:	6a 00                	push   $0x0
  80210c:	52                   	push   %edx
  80210d:	50                   	push   %eax
  80210e:	6a 19                	push   $0x19
  802110:	e8 44 fd ff ff       	call   801e59 <syscall>
  802115:	83 c4 18             	add    $0x18,%esp
}
  802118:	90                   	nop
  802119:	c9                   	leave  
  80211a:	c3                   	ret    

0080211b <sys_createSharedObject>:

int
sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  80211b:	55                   	push   %ebp
  80211c:	89 e5                	mov    %esp,%ebp
  80211e:	83 ec 04             	sub    $0x4,%esp
  802121:	8b 45 10             	mov    0x10(%ebp),%eax
  802124:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  802127:	8b 4d 14             	mov    0x14(%ebp),%ecx
  80212a:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  80212e:	8b 45 08             	mov    0x8(%ebp),%eax
  802131:	6a 00                	push   $0x0
  802133:	51                   	push   %ecx
  802134:	52                   	push   %edx
  802135:	ff 75 0c             	pushl  0xc(%ebp)
  802138:	50                   	push   %eax
  802139:	6a 1b                	push   $0x1b
  80213b:	e8 19 fd ff ff       	call   801e59 <syscall>
  802140:	83 c4 18             	add    $0x18,%esp
}
  802143:	c9                   	leave  
  802144:	c3                   	ret    

00802145 <sys_getSizeOfSharedObject>:

//2017:
int
sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  802145:	55                   	push   %ebp
  802146:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  802148:	8b 55 0c             	mov    0xc(%ebp),%edx
  80214b:	8b 45 08             	mov    0x8(%ebp),%eax
  80214e:	6a 00                	push   $0x0
  802150:	6a 00                	push   $0x0
  802152:	6a 00                	push   $0x0
  802154:	52                   	push   %edx
  802155:	50                   	push   %eax
  802156:	6a 1c                	push   $0x1c
  802158:	e8 fc fc ff ff       	call   801e59 <syscall>
  80215d:	83 c4 18             	add    $0x18,%esp
}
  802160:	c9                   	leave  
  802161:	c3                   	ret    

00802162 <sys_getSharedObject>:
//==========

int
sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  802162:	55                   	push   %ebp
  802163:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  802165:	8b 4d 10             	mov    0x10(%ebp),%ecx
  802168:	8b 55 0c             	mov    0xc(%ebp),%edx
  80216b:	8b 45 08             	mov    0x8(%ebp),%eax
  80216e:	6a 00                	push   $0x0
  802170:	6a 00                	push   $0x0
  802172:	51                   	push   %ecx
  802173:	52                   	push   %edx
  802174:	50                   	push   %eax
  802175:	6a 1d                	push   $0x1d
  802177:	e8 dd fc ff ff       	call   801e59 <syscall>
  80217c:	83 c4 18             	add    $0x18,%esp
}
  80217f:	c9                   	leave  
  802180:	c3                   	ret    

00802181 <sys_freeSharedObject>:

int
sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  802181:	55                   	push   %ebp
  802182:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  802184:	8b 55 0c             	mov    0xc(%ebp),%edx
  802187:	8b 45 08             	mov    0x8(%ebp),%eax
  80218a:	6a 00                	push   $0x0
  80218c:	6a 00                	push   $0x0
  80218e:	6a 00                	push   $0x0
  802190:	52                   	push   %edx
  802191:	50                   	push   %eax
  802192:	6a 1e                	push   $0x1e
  802194:	e8 c0 fc ff ff       	call   801e59 <syscall>
  802199:	83 c4 18             	add    $0x18,%esp
}
  80219c:	c9                   	leave  
  80219d:	c3                   	ret    

0080219e <sys_getMaxShares>:

uint32 	sys_getMaxShares()
{
  80219e:	55                   	push   %ebp
  80219f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_max_shares,0, 0, 0, 0, 0);
  8021a1:	6a 00                	push   $0x0
  8021a3:	6a 00                	push   $0x0
  8021a5:	6a 00                	push   $0x0
  8021a7:	6a 00                	push   $0x0
  8021a9:	6a 00                	push   $0x0
  8021ab:	6a 1f                	push   $0x1f
  8021ad:	e8 a7 fc ff ff       	call   801e59 <syscall>
  8021b2:	83 c4 18             	add    $0x18,%esp
}
  8021b5:	c9                   	leave  
  8021b6:	c3                   	ret    

008021b7 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  8021b7:	55                   	push   %ebp
  8021b8:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  8021ba:	8b 45 08             	mov    0x8(%ebp),%eax
  8021bd:	6a 00                	push   $0x0
  8021bf:	ff 75 14             	pushl  0x14(%ebp)
  8021c2:	ff 75 10             	pushl  0x10(%ebp)
  8021c5:	ff 75 0c             	pushl  0xc(%ebp)
  8021c8:	50                   	push   %eax
  8021c9:	6a 20                	push   $0x20
  8021cb:	e8 89 fc ff ff       	call   801e59 <syscall>
  8021d0:	83 c4 18             	add    $0x18,%esp
}
  8021d3:	c9                   	leave  
  8021d4:	c3                   	ret    

008021d5 <sys_run_env>:

void
sys_run_env(int32 envId)
{
  8021d5:	55                   	push   %ebp
  8021d6:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  8021d8:	8b 45 08             	mov    0x8(%ebp),%eax
  8021db:	6a 00                	push   $0x0
  8021dd:	6a 00                	push   $0x0
  8021df:	6a 00                	push   $0x0
  8021e1:	6a 00                	push   $0x0
  8021e3:	50                   	push   %eax
  8021e4:	6a 21                	push   $0x21
  8021e6:	e8 6e fc ff ff       	call   801e59 <syscall>
  8021eb:	83 c4 18             	add    $0x18,%esp
}
  8021ee:	90                   	nop
  8021ef:	c9                   	leave  
  8021f0:	c3                   	ret    

008021f1 <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  8021f1:	55                   	push   %ebp
  8021f2:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  8021f4:	8b 45 08             	mov    0x8(%ebp),%eax
  8021f7:	6a 00                	push   $0x0
  8021f9:	6a 00                	push   $0x0
  8021fb:	6a 00                	push   $0x0
  8021fd:	6a 00                	push   $0x0
  8021ff:	50                   	push   %eax
  802200:	6a 22                	push   $0x22
  802202:	e8 52 fc ff ff       	call   801e59 <syscall>
  802207:	83 c4 18             	add    $0x18,%esp
}
  80220a:	c9                   	leave  
  80220b:	c3                   	ret    

0080220c <sys_getenvid>:

int32 sys_getenvid(void)
{
  80220c:	55                   	push   %ebp
  80220d:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  80220f:	6a 00                	push   $0x0
  802211:	6a 00                	push   $0x0
  802213:	6a 00                	push   $0x0
  802215:	6a 00                	push   $0x0
  802217:	6a 00                	push   $0x0
  802219:	6a 02                	push   $0x2
  80221b:	e8 39 fc ff ff       	call   801e59 <syscall>
  802220:	83 c4 18             	add    $0x18,%esp
}
  802223:	c9                   	leave  
  802224:	c3                   	ret    

00802225 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  802225:	55                   	push   %ebp
  802226:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  802228:	6a 00                	push   $0x0
  80222a:	6a 00                	push   $0x0
  80222c:	6a 00                	push   $0x0
  80222e:	6a 00                	push   $0x0
  802230:	6a 00                	push   $0x0
  802232:	6a 03                	push   $0x3
  802234:	e8 20 fc ff ff       	call   801e59 <syscall>
  802239:	83 c4 18             	add    $0x18,%esp
}
  80223c:	c9                   	leave  
  80223d:	c3                   	ret    

0080223e <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  80223e:	55                   	push   %ebp
  80223f:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  802241:	6a 00                	push   $0x0
  802243:	6a 00                	push   $0x0
  802245:	6a 00                	push   $0x0
  802247:	6a 00                	push   $0x0
  802249:	6a 00                	push   $0x0
  80224b:	6a 04                	push   $0x4
  80224d:	e8 07 fc ff ff       	call   801e59 <syscall>
  802252:	83 c4 18             	add    $0x18,%esp
}
  802255:	c9                   	leave  
  802256:	c3                   	ret    

00802257 <sys_exit_env>:


void sys_exit_env(void)
{
  802257:	55                   	push   %ebp
  802258:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  80225a:	6a 00                	push   $0x0
  80225c:	6a 00                	push   $0x0
  80225e:	6a 00                	push   $0x0
  802260:	6a 00                	push   $0x0
  802262:	6a 00                	push   $0x0
  802264:	6a 23                	push   $0x23
  802266:	e8 ee fb ff ff       	call   801e59 <syscall>
  80226b:	83 c4 18             	add    $0x18,%esp
}
  80226e:	90                   	nop
  80226f:	c9                   	leave  
  802270:	c3                   	ret    

00802271 <sys_get_virtual_time>:


struct uint64
sys_get_virtual_time()
{
  802271:	55                   	push   %ebp
  802272:	89 e5                	mov    %esp,%ebp
  802274:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  802277:	8d 45 f8             	lea    -0x8(%ebp),%eax
  80227a:	8d 50 04             	lea    0x4(%eax),%edx
  80227d:	8d 45 f8             	lea    -0x8(%ebp),%eax
  802280:	6a 00                	push   $0x0
  802282:	6a 00                	push   $0x0
  802284:	6a 00                	push   $0x0
  802286:	52                   	push   %edx
  802287:	50                   	push   %eax
  802288:	6a 24                	push   $0x24
  80228a:	e8 ca fb ff ff       	call   801e59 <syscall>
  80228f:	83 c4 18             	add    $0x18,%esp
	return result;
  802292:	8b 4d 08             	mov    0x8(%ebp),%ecx
  802295:	8b 45 f8             	mov    -0x8(%ebp),%eax
  802298:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80229b:	89 01                	mov    %eax,(%ecx)
  80229d:	89 51 04             	mov    %edx,0x4(%ecx)
}
  8022a0:	8b 45 08             	mov    0x8(%ebp),%eax
  8022a3:	c9                   	leave  
  8022a4:	c2 04 00             	ret    $0x4

008022a7 <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  8022a7:	55                   	push   %ebp
  8022a8:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  8022aa:	6a 00                	push   $0x0
  8022ac:	6a 00                	push   $0x0
  8022ae:	ff 75 10             	pushl  0x10(%ebp)
  8022b1:	ff 75 0c             	pushl  0xc(%ebp)
  8022b4:	ff 75 08             	pushl  0x8(%ebp)
  8022b7:	6a 12                	push   $0x12
  8022b9:	e8 9b fb ff ff       	call   801e59 <syscall>
  8022be:	83 c4 18             	add    $0x18,%esp
	return ;
  8022c1:	90                   	nop
}
  8022c2:	c9                   	leave  
  8022c3:	c3                   	ret    

008022c4 <sys_rcr2>:
uint32 sys_rcr2()
{
  8022c4:	55                   	push   %ebp
  8022c5:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  8022c7:	6a 00                	push   $0x0
  8022c9:	6a 00                	push   $0x0
  8022cb:	6a 00                	push   $0x0
  8022cd:	6a 00                	push   $0x0
  8022cf:	6a 00                	push   $0x0
  8022d1:	6a 25                	push   $0x25
  8022d3:	e8 81 fb ff ff       	call   801e59 <syscall>
  8022d8:	83 c4 18             	add    $0x18,%esp
}
  8022db:	c9                   	leave  
  8022dc:	c3                   	ret    

008022dd <sys_bypassPageFault>:
void sys_bypassPageFault(uint8 instrLength)
{
  8022dd:	55                   	push   %ebp
  8022de:	89 e5                	mov    %esp,%ebp
  8022e0:	83 ec 04             	sub    $0x4,%esp
  8022e3:	8b 45 08             	mov    0x8(%ebp),%eax
  8022e6:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  8022e9:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  8022ed:	6a 00                	push   $0x0
  8022ef:	6a 00                	push   $0x0
  8022f1:	6a 00                	push   $0x0
  8022f3:	6a 00                	push   $0x0
  8022f5:	50                   	push   %eax
  8022f6:	6a 26                	push   $0x26
  8022f8:	e8 5c fb ff ff       	call   801e59 <syscall>
  8022fd:	83 c4 18             	add    $0x18,%esp
	return ;
  802300:	90                   	nop
}
  802301:	c9                   	leave  
  802302:	c3                   	ret    

00802303 <rsttst>:
void rsttst()
{
  802303:	55                   	push   %ebp
  802304:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  802306:	6a 00                	push   $0x0
  802308:	6a 00                	push   $0x0
  80230a:	6a 00                	push   $0x0
  80230c:	6a 00                	push   $0x0
  80230e:	6a 00                	push   $0x0
  802310:	6a 28                	push   $0x28
  802312:	e8 42 fb ff ff       	call   801e59 <syscall>
  802317:	83 c4 18             	add    $0x18,%esp
	return ;
  80231a:	90                   	nop
}
  80231b:	c9                   	leave  
  80231c:	c3                   	ret    

0080231d <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  80231d:	55                   	push   %ebp
  80231e:	89 e5                	mov    %esp,%ebp
  802320:	83 ec 04             	sub    $0x4,%esp
  802323:	8b 45 14             	mov    0x14(%ebp),%eax
  802326:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  802329:	8b 55 18             	mov    0x18(%ebp),%edx
  80232c:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  802330:	52                   	push   %edx
  802331:	50                   	push   %eax
  802332:	ff 75 10             	pushl  0x10(%ebp)
  802335:	ff 75 0c             	pushl  0xc(%ebp)
  802338:	ff 75 08             	pushl  0x8(%ebp)
  80233b:	6a 27                	push   $0x27
  80233d:	e8 17 fb ff ff       	call   801e59 <syscall>
  802342:	83 c4 18             	add    $0x18,%esp
	return ;
  802345:	90                   	nop
}
  802346:	c9                   	leave  
  802347:	c3                   	ret    

00802348 <chktst>:
void chktst(uint32 n)
{
  802348:	55                   	push   %ebp
  802349:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  80234b:	6a 00                	push   $0x0
  80234d:	6a 00                	push   $0x0
  80234f:	6a 00                	push   $0x0
  802351:	6a 00                	push   $0x0
  802353:	ff 75 08             	pushl  0x8(%ebp)
  802356:	6a 29                	push   $0x29
  802358:	e8 fc fa ff ff       	call   801e59 <syscall>
  80235d:	83 c4 18             	add    $0x18,%esp
	return ;
  802360:	90                   	nop
}
  802361:	c9                   	leave  
  802362:	c3                   	ret    

00802363 <inctst>:

void inctst()
{
  802363:	55                   	push   %ebp
  802364:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  802366:	6a 00                	push   $0x0
  802368:	6a 00                	push   $0x0
  80236a:	6a 00                	push   $0x0
  80236c:	6a 00                	push   $0x0
  80236e:	6a 00                	push   $0x0
  802370:	6a 2a                	push   $0x2a
  802372:	e8 e2 fa ff ff       	call   801e59 <syscall>
  802377:	83 c4 18             	add    $0x18,%esp
	return ;
  80237a:	90                   	nop
}
  80237b:	c9                   	leave  
  80237c:	c3                   	ret    

0080237d <gettst>:
uint32 gettst()
{
  80237d:	55                   	push   %ebp
  80237e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  802380:	6a 00                	push   $0x0
  802382:	6a 00                	push   $0x0
  802384:	6a 00                	push   $0x0
  802386:	6a 00                	push   $0x0
  802388:	6a 00                	push   $0x0
  80238a:	6a 2b                	push   $0x2b
  80238c:	e8 c8 fa ff ff       	call   801e59 <syscall>
  802391:	83 c4 18             	add    $0x18,%esp
}
  802394:	c9                   	leave  
  802395:	c3                   	ret    

00802396 <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  802396:	55                   	push   %ebp
  802397:	89 e5                	mov    %esp,%ebp
  802399:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  80239c:	6a 00                	push   $0x0
  80239e:	6a 00                	push   $0x0
  8023a0:	6a 00                	push   $0x0
  8023a2:	6a 00                	push   $0x0
  8023a4:	6a 00                	push   $0x0
  8023a6:	6a 2c                	push   $0x2c
  8023a8:	e8 ac fa ff ff       	call   801e59 <syscall>
  8023ad:	83 c4 18             	add    $0x18,%esp
  8023b0:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  8023b3:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  8023b7:	75 07                	jne    8023c0 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  8023b9:	b8 01 00 00 00       	mov    $0x1,%eax
  8023be:	eb 05                	jmp    8023c5 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  8023c0:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8023c5:	c9                   	leave  
  8023c6:	c3                   	ret    

008023c7 <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  8023c7:	55                   	push   %ebp
  8023c8:	89 e5                	mov    %esp,%ebp
  8023ca:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8023cd:	6a 00                	push   $0x0
  8023cf:	6a 00                	push   $0x0
  8023d1:	6a 00                	push   $0x0
  8023d3:	6a 00                	push   $0x0
  8023d5:	6a 00                	push   $0x0
  8023d7:	6a 2c                	push   $0x2c
  8023d9:	e8 7b fa ff ff       	call   801e59 <syscall>
  8023de:	83 c4 18             	add    $0x18,%esp
  8023e1:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  8023e4:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  8023e8:	75 07                	jne    8023f1 <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  8023ea:	b8 01 00 00 00       	mov    $0x1,%eax
  8023ef:	eb 05                	jmp    8023f6 <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  8023f1:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8023f6:	c9                   	leave  
  8023f7:	c3                   	ret    

008023f8 <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  8023f8:	55                   	push   %ebp
  8023f9:	89 e5                	mov    %esp,%ebp
  8023fb:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8023fe:	6a 00                	push   $0x0
  802400:	6a 00                	push   $0x0
  802402:	6a 00                	push   $0x0
  802404:	6a 00                	push   $0x0
  802406:	6a 00                	push   $0x0
  802408:	6a 2c                	push   $0x2c
  80240a:	e8 4a fa ff ff       	call   801e59 <syscall>
  80240f:	83 c4 18             	add    $0x18,%esp
  802412:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  802415:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  802419:	75 07                	jne    802422 <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  80241b:	b8 01 00 00 00       	mov    $0x1,%eax
  802420:	eb 05                	jmp    802427 <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  802422:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802427:	c9                   	leave  
  802428:	c3                   	ret    

00802429 <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  802429:	55                   	push   %ebp
  80242a:	89 e5                	mov    %esp,%ebp
  80242c:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  80242f:	6a 00                	push   $0x0
  802431:	6a 00                	push   $0x0
  802433:	6a 00                	push   $0x0
  802435:	6a 00                	push   $0x0
  802437:	6a 00                	push   $0x0
  802439:	6a 2c                	push   $0x2c
  80243b:	e8 19 fa ff ff       	call   801e59 <syscall>
  802440:	83 c4 18             	add    $0x18,%esp
  802443:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  802446:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  80244a:	75 07                	jne    802453 <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  80244c:	b8 01 00 00 00       	mov    $0x1,%eax
  802451:	eb 05                	jmp    802458 <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  802453:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802458:	c9                   	leave  
  802459:	c3                   	ret    

0080245a <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  80245a:	55                   	push   %ebp
  80245b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  80245d:	6a 00                	push   $0x0
  80245f:	6a 00                	push   $0x0
  802461:	6a 00                	push   $0x0
  802463:	6a 00                	push   $0x0
  802465:	ff 75 08             	pushl  0x8(%ebp)
  802468:	6a 2d                	push   $0x2d
  80246a:	e8 ea f9 ff ff       	call   801e59 <syscall>
  80246f:	83 c4 18             	add    $0x18,%esp
	return ;
  802472:	90                   	nop
}
  802473:	c9                   	leave  
  802474:	c3                   	ret    

00802475 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  802475:	55                   	push   %ebp
  802476:	89 e5                	mov    %esp,%ebp
  802478:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  802479:	8b 5d 14             	mov    0x14(%ebp),%ebx
  80247c:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80247f:	8b 55 0c             	mov    0xc(%ebp),%edx
  802482:	8b 45 08             	mov    0x8(%ebp),%eax
  802485:	6a 00                	push   $0x0
  802487:	53                   	push   %ebx
  802488:	51                   	push   %ecx
  802489:	52                   	push   %edx
  80248a:	50                   	push   %eax
  80248b:	6a 2e                	push   $0x2e
  80248d:	e8 c7 f9 ff ff       	call   801e59 <syscall>
  802492:	83 c4 18             	add    $0x18,%esp
}
  802495:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802498:	c9                   	leave  
  802499:	c3                   	ret    

0080249a <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  80249a:	55                   	push   %ebp
  80249b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  80249d:	8b 55 0c             	mov    0xc(%ebp),%edx
  8024a0:	8b 45 08             	mov    0x8(%ebp),%eax
  8024a3:	6a 00                	push   $0x0
  8024a5:	6a 00                	push   $0x0
  8024a7:	6a 00                	push   $0x0
  8024a9:	52                   	push   %edx
  8024aa:	50                   	push   %eax
  8024ab:	6a 2f                	push   $0x2f
  8024ad:	e8 a7 f9 ff ff       	call   801e59 <syscall>
  8024b2:	83 c4 18             	add    $0x18,%esp
}
  8024b5:	c9                   	leave  
  8024b6:	c3                   	ret    

008024b7 <print_mem_block_lists>:
//===========================
// PRINT MEM BLOCK LISTS:
//===========================

void print_mem_block_lists()
{
  8024b7:	55                   	push   %ebp
  8024b8:	89 e5                	mov    %esp,%ebp
  8024ba:	83 ec 18             	sub    $0x18,%esp
	cprintf("\n=========================================\n");
  8024bd:	83 ec 0c             	sub    $0xc,%esp
  8024c0:	68 80 3f 80 00       	push   $0x803f80
  8024c5:	e8 dd e6 ff ff       	call   800ba7 <cprintf>
  8024ca:	83 c4 10             	add    $0x10,%esp
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
  8024cd:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nFreeMemBlocksList:\n");
  8024d4:	83 ec 0c             	sub    $0xc,%esp
  8024d7:	68 ac 3f 80 00       	push   $0x803fac
  8024dc:	e8 c6 e6 ff ff       	call   800ba7 <cprintf>
  8024e1:	83 c4 10             	add    $0x10,%esp
	uint8 sorted = 1 ;
  8024e4:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &FreeMemBlocksList)
  8024e8:	a1 38 51 80 00       	mov    0x805138,%eax
  8024ed:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8024f0:	eb 56                	jmp    802548 <print_mem_block_lists+0x91>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  8024f2:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8024f6:	74 1c                	je     802514 <print_mem_block_lists+0x5d>
  8024f8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024fb:	8b 50 08             	mov    0x8(%eax),%edx
  8024fe:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802501:	8b 48 08             	mov    0x8(%eax),%ecx
  802504:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802507:	8b 40 0c             	mov    0xc(%eax),%eax
  80250a:	01 c8                	add    %ecx,%eax
  80250c:	39 c2                	cmp    %eax,%edx
  80250e:	73 04                	jae    802514 <print_mem_block_lists+0x5d>
			sorted = 0 ;
  802510:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  802514:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802517:	8b 50 08             	mov    0x8(%eax),%edx
  80251a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80251d:	8b 40 0c             	mov    0xc(%eax),%eax
  802520:	01 c2                	add    %eax,%edx
  802522:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802525:	8b 40 08             	mov    0x8(%eax),%eax
  802528:	83 ec 04             	sub    $0x4,%esp
  80252b:	52                   	push   %edx
  80252c:	50                   	push   %eax
  80252d:	68 c1 3f 80 00       	push   $0x803fc1
  802532:	e8 70 e6 ff ff       	call   800ba7 <cprintf>
  802537:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  80253a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80253d:	89 45 f0             	mov    %eax,-0x10(%ebp)
	cprintf("\n=========================================\n");
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
	cprintf("\nFreeMemBlocksList:\n");
	uint8 sorted = 1 ;
	LIST_FOREACH(blk, &FreeMemBlocksList)
  802540:	a1 40 51 80 00       	mov    0x805140,%eax
  802545:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802548:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80254c:	74 07                	je     802555 <print_mem_block_lists+0x9e>
  80254e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802551:	8b 00                	mov    (%eax),%eax
  802553:	eb 05                	jmp    80255a <print_mem_block_lists+0xa3>
  802555:	b8 00 00 00 00       	mov    $0x0,%eax
  80255a:	a3 40 51 80 00       	mov    %eax,0x805140
  80255f:	a1 40 51 80 00       	mov    0x805140,%eax
  802564:	85 c0                	test   %eax,%eax
  802566:	75 8a                	jne    8024f2 <print_mem_block_lists+0x3b>
  802568:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80256c:	75 84                	jne    8024f2 <print_mem_block_lists+0x3b>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;
  80256e:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  802572:	75 10                	jne    802584 <print_mem_block_lists+0xcd>
  802574:	83 ec 0c             	sub    $0xc,%esp
  802577:	68 d0 3f 80 00       	push   $0x803fd0
  80257c:	e8 26 e6 ff ff       	call   800ba7 <cprintf>
  802581:	83 c4 10             	add    $0x10,%esp

	lastBlk = NULL ;
  802584:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nAllocMemBlocksList:\n");
  80258b:	83 ec 0c             	sub    $0xc,%esp
  80258e:	68 f4 3f 80 00       	push   $0x803ff4
  802593:	e8 0f e6 ff ff       	call   800ba7 <cprintf>
  802598:	83 c4 10             	add    $0x10,%esp
	sorted = 1 ;
  80259b:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &AllocMemBlocksList)
  80259f:	a1 40 50 80 00       	mov    0x805040,%eax
  8025a4:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8025a7:	eb 56                	jmp    8025ff <print_mem_block_lists+0x148>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  8025a9:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8025ad:	74 1c                	je     8025cb <print_mem_block_lists+0x114>
  8025af:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025b2:	8b 50 08             	mov    0x8(%eax),%edx
  8025b5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8025b8:	8b 48 08             	mov    0x8(%eax),%ecx
  8025bb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8025be:	8b 40 0c             	mov    0xc(%eax),%eax
  8025c1:	01 c8                	add    %ecx,%eax
  8025c3:	39 c2                	cmp    %eax,%edx
  8025c5:	73 04                	jae    8025cb <print_mem_block_lists+0x114>
			sorted = 0 ;
  8025c7:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  8025cb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025ce:	8b 50 08             	mov    0x8(%eax),%edx
  8025d1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025d4:	8b 40 0c             	mov    0xc(%eax),%eax
  8025d7:	01 c2                	add    %eax,%edx
  8025d9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025dc:	8b 40 08             	mov    0x8(%eax),%eax
  8025df:	83 ec 04             	sub    $0x4,%esp
  8025e2:	52                   	push   %edx
  8025e3:	50                   	push   %eax
  8025e4:	68 c1 3f 80 00       	push   $0x803fc1
  8025e9:	e8 b9 e5 ff ff       	call   800ba7 <cprintf>
  8025ee:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  8025f1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025f4:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;

	lastBlk = NULL ;
	cprintf("\nAllocMemBlocksList:\n");
	sorted = 1 ;
	LIST_FOREACH(blk, &AllocMemBlocksList)
  8025f7:	a1 48 50 80 00       	mov    0x805048,%eax
  8025fc:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8025ff:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802603:	74 07                	je     80260c <print_mem_block_lists+0x155>
  802605:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802608:	8b 00                	mov    (%eax),%eax
  80260a:	eb 05                	jmp    802611 <print_mem_block_lists+0x15a>
  80260c:	b8 00 00 00 00       	mov    $0x0,%eax
  802611:	a3 48 50 80 00       	mov    %eax,0x805048
  802616:	a1 48 50 80 00       	mov    0x805048,%eax
  80261b:	85 c0                	test   %eax,%eax
  80261d:	75 8a                	jne    8025a9 <print_mem_block_lists+0xf2>
  80261f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802623:	75 84                	jne    8025a9 <print_mem_block_lists+0xf2>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nAllocMemBlocksList is NOT SORTED!!\n") ;
  802625:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  802629:	75 10                	jne    80263b <print_mem_block_lists+0x184>
  80262b:	83 ec 0c             	sub    $0xc,%esp
  80262e:	68 0c 40 80 00       	push   $0x80400c
  802633:	e8 6f e5 ff ff       	call   800ba7 <cprintf>
  802638:	83 c4 10             	add    $0x10,%esp
	cprintf("\n=========================================\n");
  80263b:	83 ec 0c             	sub    $0xc,%esp
  80263e:	68 80 3f 80 00       	push   $0x803f80
  802643:	e8 5f e5 ff ff       	call   800ba7 <cprintf>
  802648:	83 c4 10             	add    $0x10,%esp

}
  80264b:	90                   	nop
  80264c:	c9                   	leave  
  80264d:	c3                   	ret    

0080264e <initialize_MemBlocksList>:

//===============================
// [1] INITIALIZE AVAILABLE LIST:
//===============================
void initialize_MemBlocksList(uint32 numOfBlocks)
{
  80264e:	55                   	push   %ebp
  80264f:	89 e5                	mov    %esp,%ebp
  802651:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] initialize_MemBlocksList
	// Write your code here, remove the panic and write your code
	//panic("initialize_MemBlocksList() is not implemented yet...!!");
	uint32 n = numOfBlocks;
  802654:	8b 45 08             	mov    0x8(%ebp),%eax
  802657:	89 45 f0             	mov    %eax,-0x10(%ebp)

	LIST_INIT(&AvailableMemBlocksList);
  80265a:	c7 05 48 51 80 00 00 	movl   $0x0,0x805148
  802661:	00 00 00 
  802664:	c7 05 4c 51 80 00 00 	movl   $0x0,0x80514c
  80266b:	00 00 00 
  80266e:	c7 05 54 51 80 00 00 	movl   $0x0,0x805154
  802675:	00 00 00 
	for(int i = 0; i<n;i++)
  802678:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  80267f:	e9 9e 00 00 00       	jmp    802722 <initialize_MemBlocksList+0xd4>
	{
		LIST_INSERT_HEAD(&AvailableMemBlocksList, &(MemBlockNodes[i]));
  802684:	a1 50 50 80 00       	mov    0x805050,%eax
  802689:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80268c:	c1 e2 04             	shl    $0x4,%edx
  80268f:	01 d0                	add    %edx,%eax
  802691:	85 c0                	test   %eax,%eax
  802693:	75 14                	jne    8026a9 <initialize_MemBlocksList+0x5b>
  802695:	83 ec 04             	sub    $0x4,%esp
  802698:	68 34 40 80 00       	push   $0x804034
  80269d:	6a 47                	push   $0x47
  80269f:	68 57 40 80 00       	push   $0x804057
  8026a4:	e8 4a e2 ff ff       	call   8008f3 <_panic>
  8026a9:	a1 50 50 80 00       	mov    0x805050,%eax
  8026ae:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8026b1:	c1 e2 04             	shl    $0x4,%edx
  8026b4:	01 d0                	add    %edx,%eax
  8026b6:	8b 15 48 51 80 00    	mov    0x805148,%edx
  8026bc:	89 10                	mov    %edx,(%eax)
  8026be:	8b 00                	mov    (%eax),%eax
  8026c0:	85 c0                	test   %eax,%eax
  8026c2:	74 18                	je     8026dc <initialize_MemBlocksList+0x8e>
  8026c4:	a1 48 51 80 00       	mov    0x805148,%eax
  8026c9:	8b 15 50 50 80 00    	mov    0x805050,%edx
  8026cf:	8b 4d f4             	mov    -0xc(%ebp),%ecx
  8026d2:	c1 e1 04             	shl    $0x4,%ecx
  8026d5:	01 ca                	add    %ecx,%edx
  8026d7:	89 50 04             	mov    %edx,0x4(%eax)
  8026da:	eb 12                	jmp    8026ee <initialize_MemBlocksList+0xa0>
  8026dc:	a1 50 50 80 00       	mov    0x805050,%eax
  8026e1:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8026e4:	c1 e2 04             	shl    $0x4,%edx
  8026e7:	01 d0                	add    %edx,%eax
  8026e9:	a3 4c 51 80 00       	mov    %eax,0x80514c
  8026ee:	a1 50 50 80 00       	mov    0x805050,%eax
  8026f3:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8026f6:	c1 e2 04             	shl    $0x4,%edx
  8026f9:	01 d0                	add    %edx,%eax
  8026fb:	a3 48 51 80 00       	mov    %eax,0x805148
  802700:	a1 50 50 80 00       	mov    0x805050,%eax
  802705:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802708:	c1 e2 04             	shl    $0x4,%edx
  80270b:	01 d0                	add    %edx,%eax
  80270d:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802714:	a1 54 51 80 00       	mov    0x805154,%eax
  802719:	40                   	inc    %eax
  80271a:	a3 54 51 80 00       	mov    %eax,0x805154
	// Write your code here, remove the panic and write your code
	//panic("initialize_MemBlocksList() is not implemented yet...!!");
	uint32 n = numOfBlocks;

	LIST_INIT(&AvailableMemBlocksList);
	for(int i = 0; i<n;i++)
  80271f:	ff 45 f4             	incl   -0xc(%ebp)
  802722:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802725:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  802728:	0f 82 56 ff ff ff    	jb     802684 <initialize_MemBlocksList+0x36>
	{
		LIST_INSERT_HEAD(&AvailableMemBlocksList, &(MemBlockNodes[i]));
	}
}
  80272e:	90                   	nop
  80272f:	c9                   	leave  
  802730:	c3                   	ret    

00802731 <find_block>:

//===============================
// [2] FIND BLOCK:
//===============================
struct MemBlock *find_block(struct MemBlock_List *blockList, uint32 va)
{
  802731:	55                   	push   %ebp
  802732:	89 e5                	mov    %esp,%ebp
  802734:	83 ec 10             	sub    $0x10,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] find_block
	// Write your code here, remove the panic and write your code
	//panic("find_block() is not implemented yet...!!");
	uint32 virAddress = va;
  802737:	8b 45 0c             	mov    0xc(%ebp),%eax
  80273a:	89 45 f4             	mov    %eax,-0xc(%ebp)
	struct MemBlock* blk;
	int found = 0;
  80273d:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	LIST_FOREACH(blk, &(AllocMemBlocksList))
  802744:	a1 40 50 80 00       	mov    0x805040,%eax
  802749:	89 45 fc             	mov    %eax,-0x4(%ebp)
  80274c:	eb 23                	jmp    802771 <find_block+0x40>
	{
		if(blk->sva == virAddress)
  80274e:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802751:	8b 40 08             	mov    0x8(%eax),%eax
  802754:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  802757:	75 09                	jne    802762 <find_block+0x31>
		{
			found = 1;
  802759:	c7 45 f8 01 00 00 00 	movl   $0x1,-0x8(%ebp)
			break;
  802760:	eb 35                	jmp    802797 <find_block+0x66>
		}
		else
		{
			found = 0;
  802762:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	//panic("find_block() is not implemented yet...!!");
	uint32 virAddress = va;
	struct MemBlock* blk;
	int found = 0;

	LIST_FOREACH(blk, &(AllocMemBlocksList))
  802769:	a1 48 50 80 00       	mov    0x805048,%eax
  80276e:	89 45 fc             	mov    %eax,-0x4(%ebp)
  802771:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  802775:	74 07                	je     80277e <find_block+0x4d>
  802777:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80277a:	8b 00                	mov    (%eax),%eax
  80277c:	eb 05                	jmp    802783 <find_block+0x52>
  80277e:	b8 00 00 00 00       	mov    $0x0,%eax
  802783:	a3 48 50 80 00       	mov    %eax,0x805048
  802788:	a1 48 50 80 00       	mov    0x805048,%eax
  80278d:	85 c0                	test   %eax,%eax
  80278f:	75 bd                	jne    80274e <find_block+0x1d>
  802791:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  802795:	75 b7                	jne    80274e <find_block+0x1d>
		{
			found = 0;
			continue;
		}
	}
	if(found == 1)
  802797:	83 7d f8 01          	cmpl   $0x1,-0x8(%ebp)
  80279b:	75 05                	jne    8027a2 <find_block+0x71>
	{
		return blk;
  80279d:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8027a0:	eb 05                	jmp    8027a7 <find_block+0x76>
	}
	else
	{
		return NULL;
  8027a2:	b8 00 00 00 00       	mov    $0x0,%eax
	}
}
  8027a7:	c9                   	leave  
  8027a8:	c3                   	ret    

008027a9 <insert_sorted_allocList>:

//=========================================
// [3] INSERT BLOCK IN ALLOC LIST [SORTED]:
//=========================================
void insert_sorted_allocList(struct MemBlock *blockToInsert)
{
  8027a9:	55                   	push   %ebp
  8027aa:	89 e5                	mov    %esp,%ebp
  8027ac:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] insert_sorted_allocList
	// Write your code here, remove the panic and write your code
	//panic("insert_sorted_allocList() is not implemented yet...!!");
	struct MemBlock* blk;
	struct MemBlock* newblk = blockToInsert;
  8027af:	8b 45 08             	mov    0x8(%ebp),%eax
  8027b2:	89 45 f0             	mov    %eax,-0x10(%ebp)

	if((LIST_EMPTY(&AllocMemBlocksList)) || (newblk->sva < LIST_FIRST(&AllocMemBlocksList)->sva))
  8027b5:	a1 40 50 80 00       	mov    0x805040,%eax
  8027ba:	85 c0                	test   %eax,%eax
  8027bc:	74 12                	je     8027d0 <insert_sorted_allocList+0x27>
  8027be:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8027c1:	8b 50 08             	mov    0x8(%eax),%edx
  8027c4:	a1 40 50 80 00       	mov    0x805040,%eax
  8027c9:	8b 40 08             	mov    0x8(%eax),%eax
  8027cc:	39 c2                	cmp    %eax,%edx
  8027ce:	73 65                	jae    802835 <insert_sorted_allocList+0x8c>
	{
		LIST_INSERT_HEAD(&(AllocMemBlocksList), newblk);
  8027d0:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8027d4:	75 14                	jne    8027ea <insert_sorted_allocList+0x41>
  8027d6:	83 ec 04             	sub    $0x4,%esp
  8027d9:	68 34 40 80 00       	push   $0x804034
  8027de:	6a 7b                	push   $0x7b
  8027e0:	68 57 40 80 00       	push   $0x804057
  8027e5:	e8 09 e1 ff ff       	call   8008f3 <_panic>
  8027ea:	8b 15 40 50 80 00    	mov    0x805040,%edx
  8027f0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8027f3:	89 10                	mov    %edx,(%eax)
  8027f5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8027f8:	8b 00                	mov    (%eax),%eax
  8027fa:	85 c0                	test   %eax,%eax
  8027fc:	74 0d                	je     80280b <insert_sorted_allocList+0x62>
  8027fe:	a1 40 50 80 00       	mov    0x805040,%eax
  802803:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802806:	89 50 04             	mov    %edx,0x4(%eax)
  802809:	eb 08                	jmp    802813 <insert_sorted_allocList+0x6a>
  80280b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80280e:	a3 44 50 80 00       	mov    %eax,0x805044
  802813:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802816:	a3 40 50 80 00       	mov    %eax,0x805040
  80281b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80281e:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802825:	a1 4c 50 80 00       	mov    0x80504c,%eax
  80282a:	40                   	inc    %eax
  80282b:	a3 4c 50 80 00       	mov    %eax,0x80504c
  802830:	e9 5f 01 00 00       	jmp    802994 <insert_sorted_allocList+0x1eb>
	}
	else if(newblk->sva > LIST_LAST(&AllocMemBlocksList)->sva)
  802835:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802838:	8b 50 08             	mov    0x8(%eax),%edx
  80283b:	a1 44 50 80 00       	mov    0x805044,%eax
  802840:	8b 40 08             	mov    0x8(%eax),%eax
  802843:	39 c2                	cmp    %eax,%edx
  802845:	76 65                	jbe    8028ac <insert_sorted_allocList+0x103>
	{
		LIST_INSERT_TAIL(&AllocMemBlocksList, newblk);
  802847:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80284b:	75 14                	jne    802861 <insert_sorted_allocList+0xb8>
  80284d:	83 ec 04             	sub    $0x4,%esp
  802850:	68 70 40 80 00       	push   $0x804070
  802855:	6a 7f                	push   $0x7f
  802857:	68 57 40 80 00       	push   $0x804057
  80285c:	e8 92 e0 ff ff       	call   8008f3 <_panic>
  802861:	8b 15 44 50 80 00    	mov    0x805044,%edx
  802867:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80286a:	89 50 04             	mov    %edx,0x4(%eax)
  80286d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802870:	8b 40 04             	mov    0x4(%eax),%eax
  802873:	85 c0                	test   %eax,%eax
  802875:	74 0c                	je     802883 <insert_sorted_allocList+0xda>
  802877:	a1 44 50 80 00       	mov    0x805044,%eax
  80287c:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80287f:	89 10                	mov    %edx,(%eax)
  802881:	eb 08                	jmp    80288b <insert_sorted_allocList+0xe2>
  802883:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802886:	a3 40 50 80 00       	mov    %eax,0x805040
  80288b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80288e:	a3 44 50 80 00       	mov    %eax,0x805044
  802893:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802896:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80289c:	a1 4c 50 80 00       	mov    0x80504c,%eax
  8028a1:	40                   	inc    %eax
  8028a2:	a3 4c 50 80 00       	mov    %eax,0x80504c
				LIST_INSERT_AFTER(&AllocMemBlocksList, blk, newblk);
				break;
			}
		}
	}
}
  8028a7:	e9 e8 00 00 00       	jmp    802994 <insert_sorted_allocList+0x1eb>
	{
		LIST_INSERT_TAIL(&AllocMemBlocksList, newblk);
	}
	else
	{
		LIST_FOREACH(blk, &AllocMemBlocksList)
  8028ac:	a1 40 50 80 00       	mov    0x805040,%eax
  8028b1:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8028b4:	e9 ab 00 00 00       	jmp    802964 <insert_sorted_allocList+0x1bb>
		{
			if(blk->prev_next_info.le_next != NULL && newblk->sva > blk->sva  && newblk->sva < blk->prev_next_info.le_next->sva)
  8028b9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028bc:	8b 00                	mov    (%eax),%eax
  8028be:	85 c0                	test   %eax,%eax
  8028c0:	0f 84 96 00 00 00    	je     80295c <insert_sorted_allocList+0x1b3>
  8028c6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8028c9:	8b 50 08             	mov    0x8(%eax),%edx
  8028cc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028cf:	8b 40 08             	mov    0x8(%eax),%eax
  8028d2:	39 c2                	cmp    %eax,%edx
  8028d4:	0f 86 82 00 00 00    	jbe    80295c <insert_sorted_allocList+0x1b3>
  8028da:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8028dd:	8b 50 08             	mov    0x8(%eax),%edx
  8028e0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028e3:	8b 00                	mov    (%eax),%eax
  8028e5:	8b 40 08             	mov    0x8(%eax),%eax
  8028e8:	39 c2                	cmp    %eax,%edx
  8028ea:	73 70                	jae    80295c <insert_sorted_allocList+0x1b3>
			{
				LIST_INSERT_AFTER(&AllocMemBlocksList, blk, newblk);
  8028ec:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8028f0:	74 06                	je     8028f8 <insert_sorted_allocList+0x14f>
  8028f2:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8028f6:	75 17                	jne    80290f <insert_sorted_allocList+0x166>
  8028f8:	83 ec 04             	sub    $0x4,%esp
  8028fb:	68 94 40 80 00       	push   $0x804094
  802900:	68 87 00 00 00       	push   $0x87
  802905:	68 57 40 80 00       	push   $0x804057
  80290a:	e8 e4 df ff ff       	call   8008f3 <_panic>
  80290f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802912:	8b 10                	mov    (%eax),%edx
  802914:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802917:	89 10                	mov    %edx,(%eax)
  802919:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80291c:	8b 00                	mov    (%eax),%eax
  80291e:	85 c0                	test   %eax,%eax
  802920:	74 0b                	je     80292d <insert_sorted_allocList+0x184>
  802922:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802925:	8b 00                	mov    (%eax),%eax
  802927:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80292a:	89 50 04             	mov    %edx,0x4(%eax)
  80292d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802930:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802933:	89 10                	mov    %edx,(%eax)
  802935:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802938:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80293b:	89 50 04             	mov    %edx,0x4(%eax)
  80293e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802941:	8b 00                	mov    (%eax),%eax
  802943:	85 c0                	test   %eax,%eax
  802945:	75 08                	jne    80294f <insert_sorted_allocList+0x1a6>
  802947:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80294a:	a3 44 50 80 00       	mov    %eax,0x805044
  80294f:	a1 4c 50 80 00       	mov    0x80504c,%eax
  802954:	40                   	inc    %eax
  802955:	a3 4c 50 80 00       	mov    %eax,0x80504c
				break;
  80295a:	eb 38                	jmp    802994 <insert_sorted_allocList+0x1eb>
	{
		LIST_INSERT_TAIL(&AllocMemBlocksList, newblk);
	}
	else
	{
		LIST_FOREACH(blk, &AllocMemBlocksList)
  80295c:	a1 48 50 80 00       	mov    0x805048,%eax
  802961:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802964:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802968:	74 07                	je     802971 <insert_sorted_allocList+0x1c8>
  80296a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80296d:	8b 00                	mov    (%eax),%eax
  80296f:	eb 05                	jmp    802976 <insert_sorted_allocList+0x1cd>
  802971:	b8 00 00 00 00       	mov    $0x0,%eax
  802976:	a3 48 50 80 00       	mov    %eax,0x805048
  80297b:	a1 48 50 80 00       	mov    0x805048,%eax
  802980:	85 c0                	test   %eax,%eax
  802982:	0f 85 31 ff ff ff    	jne    8028b9 <insert_sorted_allocList+0x110>
  802988:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80298c:	0f 85 27 ff ff ff    	jne    8028b9 <insert_sorted_allocList+0x110>
				LIST_INSERT_AFTER(&AllocMemBlocksList, blk, newblk);
				break;
			}
		}
	}
}
  802992:	eb 00                	jmp    802994 <insert_sorted_allocList+0x1eb>
  802994:	90                   	nop
  802995:	c9                   	leave  
  802996:	c3                   	ret    

00802997 <alloc_block_FF>:

//=========================================
// [4] ALLOCATE BLOCK BY FIRST FIT:
//=========================================
struct MemBlock *alloc_block_FF(uint32 size)
{
  802997:	55                   	push   %ebp
  802998:	89 e5                	mov    %esp,%ebp
  80299a:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_FF
	// Write your code here, remove the panic and write your code
	//panic("alloc_block_FF() is not implemented yet...!!");
	uint32 versize = size;
  80299d:	8b 45 08             	mov    0x8(%ebp),%eax
  8029a0:	89 45 f0             	mov    %eax,-0x10(%ebp)
	struct MemBlock* blk;
	struct MemBlock* newblk = LIST_FIRST(&AvailableMemBlocksList);
  8029a3:	a1 48 51 80 00       	mov    0x805148,%eax
  8029a8:	89 45 ec             	mov    %eax,-0x14(%ebp)

	LIST_FOREACH(blk,&FreeMemBlocksList)
  8029ab:	a1 38 51 80 00       	mov    0x805138,%eax
  8029b0:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8029b3:	e9 77 01 00 00       	jmp    802b2f <alloc_block_FF+0x198>
	{
		if(blk->size == versize)
  8029b8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029bb:	8b 40 0c             	mov    0xc(%eax),%eax
  8029be:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8029c1:	0f 85 8a 00 00 00    	jne    802a51 <alloc_block_FF+0xba>
		{
			LIST_REMOVE(&FreeMemBlocksList,blk);
  8029c7:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8029cb:	75 17                	jne    8029e4 <alloc_block_FF+0x4d>
  8029cd:	83 ec 04             	sub    $0x4,%esp
  8029d0:	68 c8 40 80 00       	push   $0x8040c8
  8029d5:	68 9e 00 00 00       	push   $0x9e
  8029da:	68 57 40 80 00       	push   $0x804057
  8029df:	e8 0f df ff ff       	call   8008f3 <_panic>
  8029e4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029e7:	8b 00                	mov    (%eax),%eax
  8029e9:	85 c0                	test   %eax,%eax
  8029eb:	74 10                	je     8029fd <alloc_block_FF+0x66>
  8029ed:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029f0:	8b 00                	mov    (%eax),%eax
  8029f2:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8029f5:	8b 52 04             	mov    0x4(%edx),%edx
  8029f8:	89 50 04             	mov    %edx,0x4(%eax)
  8029fb:	eb 0b                	jmp    802a08 <alloc_block_FF+0x71>
  8029fd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a00:	8b 40 04             	mov    0x4(%eax),%eax
  802a03:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802a08:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a0b:	8b 40 04             	mov    0x4(%eax),%eax
  802a0e:	85 c0                	test   %eax,%eax
  802a10:	74 0f                	je     802a21 <alloc_block_FF+0x8a>
  802a12:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a15:	8b 40 04             	mov    0x4(%eax),%eax
  802a18:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802a1b:	8b 12                	mov    (%edx),%edx
  802a1d:	89 10                	mov    %edx,(%eax)
  802a1f:	eb 0a                	jmp    802a2b <alloc_block_FF+0x94>
  802a21:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a24:	8b 00                	mov    (%eax),%eax
  802a26:	a3 38 51 80 00       	mov    %eax,0x805138
  802a2b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a2e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802a34:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a37:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802a3e:	a1 44 51 80 00       	mov    0x805144,%eax
  802a43:	48                   	dec    %eax
  802a44:	a3 44 51 80 00       	mov    %eax,0x805144
			return blk;
  802a49:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a4c:	e9 11 01 00 00       	jmp    802b62 <alloc_block_FF+0x1cb>
		}
		else if(blk->size > versize)
  802a51:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a54:	8b 40 0c             	mov    0xc(%eax),%eax
  802a57:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  802a5a:	0f 86 c7 00 00 00    	jbe    802b27 <alloc_block_FF+0x190>
		{
			LIST_REMOVE(&AvailableMemBlocksList,newblk);
  802a60:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802a64:	75 17                	jne    802a7d <alloc_block_FF+0xe6>
  802a66:	83 ec 04             	sub    $0x4,%esp
  802a69:	68 c8 40 80 00       	push   $0x8040c8
  802a6e:	68 a3 00 00 00       	push   $0xa3
  802a73:	68 57 40 80 00       	push   $0x804057
  802a78:	e8 76 de ff ff       	call   8008f3 <_panic>
  802a7d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802a80:	8b 00                	mov    (%eax),%eax
  802a82:	85 c0                	test   %eax,%eax
  802a84:	74 10                	je     802a96 <alloc_block_FF+0xff>
  802a86:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802a89:	8b 00                	mov    (%eax),%eax
  802a8b:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802a8e:	8b 52 04             	mov    0x4(%edx),%edx
  802a91:	89 50 04             	mov    %edx,0x4(%eax)
  802a94:	eb 0b                	jmp    802aa1 <alloc_block_FF+0x10a>
  802a96:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802a99:	8b 40 04             	mov    0x4(%eax),%eax
  802a9c:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802aa1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802aa4:	8b 40 04             	mov    0x4(%eax),%eax
  802aa7:	85 c0                	test   %eax,%eax
  802aa9:	74 0f                	je     802aba <alloc_block_FF+0x123>
  802aab:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802aae:	8b 40 04             	mov    0x4(%eax),%eax
  802ab1:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802ab4:	8b 12                	mov    (%edx),%edx
  802ab6:	89 10                	mov    %edx,(%eax)
  802ab8:	eb 0a                	jmp    802ac4 <alloc_block_FF+0x12d>
  802aba:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802abd:	8b 00                	mov    (%eax),%eax
  802abf:	a3 48 51 80 00       	mov    %eax,0x805148
  802ac4:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802ac7:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802acd:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802ad0:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802ad7:	a1 54 51 80 00       	mov    0x805154,%eax
  802adc:	48                   	dec    %eax
  802add:	a3 54 51 80 00       	mov    %eax,0x805154
			newblk->size = versize;
  802ae2:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802ae5:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802ae8:	89 50 0c             	mov    %edx,0xc(%eax)
			blk->size = blk->size-versize;
  802aeb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802aee:	8b 40 0c             	mov    0xc(%eax),%eax
  802af1:	2b 45 f0             	sub    -0x10(%ebp),%eax
  802af4:	89 c2                	mov    %eax,%edx
  802af6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802af9:	89 50 0c             	mov    %edx,0xc(%eax)
			uint32 newveradd = blk->sva;
  802afc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802aff:	8b 40 08             	mov    0x8(%eax),%eax
  802b02:	89 45 e8             	mov    %eax,-0x18(%ebp)
			blk->sva+=newblk->size;
  802b05:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b08:	8b 50 08             	mov    0x8(%eax),%edx
  802b0b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802b0e:	8b 40 0c             	mov    0xc(%eax),%eax
  802b11:	01 c2                	add    %eax,%edx
  802b13:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b16:	89 50 08             	mov    %edx,0x8(%eax)
			newblk->sva = newveradd;
  802b19:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802b1c:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802b1f:	89 50 08             	mov    %edx,0x8(%eax)
			return newblk;
  802b22:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802b25:	eb 3b                	jmp    802b62 <alloc_block_FF+0x1cb>
	//panic("alloc_block_FF() is not implemented yet...!!");
	uint32 versize = size;
	struct MemBlock* blk;
	struct MemBlock* newblk = LIST_FIRST(&AvailableMemBlocksList);

	LIST_FOREACH(blk,&FreeMemBlocksList)
  802b27:	a1 40 51 80 00       	mov    0x805140,%eax
  802b2c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802b2f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802b33:	74 07                	je     802b3c <alloc_block_FF+0x1a5>
  802b35:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b38:	8b 00                	mov    (%eax),%eax
  802b3a:	eb 05                	jmp    802b41 <alloc_block_FF+0x1aa>
  802b3c:	b8 00 00 00 00       	mov    $0x0,%eax
  802b41:	a3 40 51 80 00       	mov    %eax,0x805140
  802b46:	a1 40 51 80 00       	mov    0x805140,%eax
  802b4b:	85 c0                	test   %eax,%eax
  802b4d:	0f 85 65 fe ff ff    	jne    8029b8 <alloc_block_FF+0x21>
  802b53:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802b57:	0f 85 5b fe ff ff    	jne    8029b8 <alloc_block_FF+0x21>
			blk->sva+=newblk->size;
			newblk->sva = newveradd;
			return newblk;
		}
	}
	return NULL;
  802b5d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802b62:	c9                   	leave  
  802b63:	c3                   	ret    

00802b64 <alloc_block_BF>:

//=========================================
// [5] ALLOCATE BLOCK BY BEST FIT:
//=========================================
struct MemBlock *alloc_block_BF(uint32 size)
{
  802b64:	55                   	push   %ebp
  802b65:	89 e5                	mov    %esp,%ebp
  802b67:	83 ec 28             	sub    $0x28,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_BF
	// Write your code here, remove the panic and write your code
	//panic("alloc_block_BF() is not implemented yet...!!");
	uint32 versize=size;
  802b6a:	8b 45 08             	mov    0x8(%ebp),%eax
  802b6d:	89 45 e8             	mov    %eax,-0x18(%ebp)
	struct MemBlock* blk;
	struct MemBlock* newblk=LIST_FIRST(&AvailableMemBlocksList);
  802b70:	a1 48 51 80 00       	mov    0x805148,%eax
  802b75:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	uint32 newveradd;
	uint32 newsize;
	int size_free = LIST_SIZE(&FreeMemBlocksList);
  802b78:	a1 44 51 80 00       	mov    0x805144,%eax
  802b7d:	89 45 e0             	mov    %eax,-0x20(%ebp)

	LIST_FOREACH(blk, &FreeMemBlocksList)
  802b80:	a1 38 51 80 00       	mov    0x805138,%eax
  802b85:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802b88:	e9 a1 00 00 00       	jmp    802c2e <alloc_block_BF+0xca>
	{
		if(blk->size == versize)
  802b8d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b90:	8b 40 0c             	mov    0xc(%eax),%eax
  802b93:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  802b96:	0f 85 8a 00 00 00    	jne    802c26 <alloc_block_BF+0xc2>
		{
			LIST_REMOVE(&FreeMemBlocksList, blk);
  802b9c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802ba0:	75 17                	jne    802bb9 <alloc_block_BF+0x55>
  802ba2:	83 ec 04             	sub    $0x4,%esp
  802ba5:	68 c8 40 80 00       	push   $0x8040c8
  802baa:	68 c2 00 00 00       	push   $0xc2
  802baf:	68 57 40 80 00       	push   $0x804057
  802bb4:	e8 3a dd ff ff       	call   8008f3 <_panic>
  802bb9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bbc:	8b 00                	mov    (%eax),%eax
  802bbe:	85 c0                	test   %eax,%eax
  802bc0:	74 10                	je     802bd2 <alloc_block_BF+0x6e>
  802bc2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bc5:	8b 00                	mov    (%eax),%eax
  802bc7:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802bca:	8b 52 04             	mov    0x4(%edx),%edx
  802bcd:	89 50 04             	mov    %edx,0x4(%eax)
  802bd0:	eb 0b                	jmp    802bdd <alloc_block_BF+0x79>
  802bd2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bd5:	8b 40 04             	mov    0x4(%eax),%eax
  802bd8:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802bdd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802be0:	8b 40 04             	mov    0x4(%eax),%eax
  802be3:	85 c0                	test   %eax,%eax
  802be5:	74 0f                	je     802bf6 <alloc_block_BF+0x92>
  802be7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bea:	8b 40 04             	mov    0x4(%eax),%eax
  802bed:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802bf0:	8b 12                	mov    (%edx),%edx
  802bf2:	89 10                	mov    %edx,(%eax)
  802bf4:	eb 0a                	jmp    802c00 <alloc_block_BF+0x9c>
  802bf6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bf9:	8b 00                	mov    (%eax),%eax
  802bfb:	a3 38 51 80 00       	mov    %eax,0x805138
  802c00:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c03:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802c09:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c0c:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802c13:	a1 44 51 80 00       	mov    0x805144,%eax
  802c18:	48                   	dec    %eax
  802c19:	a3 44 51 80 00       	mov    %eax,0x805144
			return blk;
  802c1e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c21:	e9 11 02 00 00       	jmp    802e37 <alloc_block_BF+0x2d3>
	struct MemBlock* newblk=LIST_FIRST(&AvailableMemBlocksList);
	uint32 newveradd;
	uint32 newsize;
	int size_free = LIST_SIZE(&FreeMemBlocksList);

	LIST_FOREACH(blk, &FreeMemBlocksList)
  802c26:	a1 40 51 80 00       	mov    0x805140,%eax
  802c2b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802c2e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802c32:	74 07                	je     802c3b <alloc_block_BF+0xd7>
  802c34:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c37:	8b 00                	mov    (%eax),%eax
  802c39:	eb 05                	jmp    802c40 <alloc_block_BF+0xdc>
  802c3b:	b8 00 00 00 00       	mov    $0x0,%eax
  802c40:	a3 40 51 80 00       	mov    %eax,0x805140
  802c45:	a1 40 51 80 00       	mov    0x805140,%eax
  802c4a:	85 c0                	test   %eax,%eax
  802c4c:	0f 85 3b ff ff ff    	jne    802b8d <alloc_block_BF+0x29>
  802c52:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802c56:	0f 85 31 ff ff ff    	jne    802b8d <alloc_block_BF+0x29>
		{
			LIST_REMOVE(&FreeMemBlocksList, blk);
			return blk;
		}
	}
	LIST_FOREACH(blk, &FreeMemBlocksList)
  802c5c:	a1 38 51 80 00       	mov    0x805138,%eax
  802c61:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802c64:	eb 27                	jmp    802c8d <alloc_block_BF+0x129>
	{
		if(blk->size > versize)
  802c66:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c69:	8b 40 0c             	mov    0xc(%eax),%eax
  802c6c:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  802c6f:	76 14                	jbe    802c85 <alloc_block_BF+0x121>
		{
			newsize = blk->size;
  802c71:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c74:	8b 40 0c             	mov    0xc(%eax),%eax
  802c77:	89 45 ec             	mov    %eax,-0x14(%ebp)
			newveradd = blk->sva;
  802c7a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c7d:	8b 40 08             	mov    0x8(%eax),%eax
  802c80:	89 45 f0             	mov    %eax,-0x10(%ebp)
			break;
  802c83:	eb 2e                	jmp    802cb3 <alloc_block_BF+0x14f>
		{
			LIST_REMOVE(&FreeMemBlocksList, blk);
			return blk;
		}
	}
	LIST_FOREACH(blk, &FreeMemBlocksList)
  802c85:	a1 40 51 80 00       	mov    0x805140,%eax
  802c8a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802c8d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802c91:	74 07                	je     802c9a <alloc_block_BF+0x136>
  802c93:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c96:	8b 00                	mov    (%eax),%eax
  802c98:	eb 05                	jmp    802c9f <alloc_block_BF+0x13b>
  802c9a:	b8 00 00 00 00       	mov    $0x0,%eax
  802c9f:	a3 40 51 80 00       	mov    %eax,0x805140
  802ca4:	a1 40 51 80 00       	mov    0x805140,%eax
  802ca9:	85 c0                	test   %eax,%eax
  802cab:	75 b9                	jne    802c66 <alloc_block_BF+0x102>
  802cad:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802cb1:	75 b3                	jne    802c66 <alloc_block_BF+0x102>
			newsize = blk->size;
			newveradd = blk->sva;
			break;
		}
	}
	LIST_FOREACH(blk, &FreeMemBlocksList)
  802cb3:	a1 38 51 80 00       	mov    0x805138,%eax
  802cb8:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802cbb:	eb 30                	jmp    802ced <alloc_block_BF+0x189>
	{
		if(newsize > blk->size && blk->size > versize)
  802cbd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cc0:	8b 40 0c             	mov    0xc(%eax),%eax
  802cc3:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  802cc6:	73 1d                	jae    802ce5 <alloc_block_BF+0x181>
  802cc8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ccb:	8b 40 0c             	mov    0xc(%eax),%eax
  802cce:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  802cd1:	76 12                	jbe    802ce5 <alloc_block_BF+0x181>
		{
	       newsize = blk->size;
  802cd3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cd6:	8b 40 0c             	mov    0xc(%eax),%eax
  802cd9:	89 45 ec             	mov    %eax,-0x14(%ebp)
		   newveradd = blk->sva;
  802cdc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cdf:	8b 40 08             	mov    0x8(%eax),%eax
  802ce2:	89 45 f0             	mov    %eax,-0x10(%ebp)
			newsize = blk->size;
			newveradd = blk->sva;
			break;
		}
	}
	LIST_FOREACH(blk, &FreeMemBlocksList)
  802ce5:	a1 40 51 80 00       	mov    0x805140,%eax
  802cea:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802ced:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802cf1:	74 07                	je     802cfa <alloc_block_BF+0x196>
  802cf3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cf6:	8b 00                	mov    (%eax),%eax
  802cf8:	eb 05                	jmp    802cff <alloc_block_BF+0x19b>
  802cfa:	b8 00 00 00 00       	mov    $0x0,%eax
  802cff:	a3 40 51 80 00       	mov    %eax,0x805140
  802d04:	a1 40 51 80 00       	mov    0x805140,%eax
  802d09:	85 c0                	test   %eax,%eax
  802d0b:	75 b0                	jne    802cbd <alloc_block_BF+0x159>
  802d0d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802d11:	75 aa                	jne    802cbd <alloc_block_BF+0x159>
		{
	       newsize = blk->size;
		   newveradd = blk->sva;
		}
	}
	LIST_FOREACH(blk, &FreeMemBlocksList)
  802d13:	a1 38 51 80 00       	mov    0x805138,%eax
  802d18:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802d1b:	e9 e4 00 00 00       	jmp    802e04 <alloc_block_BF+0x2a0>
	{
		if(blk->size == newsize && blk->sva == newveradd)
  802d20:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d23:	8b 40 0c             	mov    0xc(%eax),%eax
  802d26:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  802d29:	0f 85 cd 00 00 00    	jne    802dfc <alloc_block_BF+0x298>
  802d2f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d32:	8b 40 08             	mov    0x8(%eax),%eax
  802d35:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  802d38:	0f 85 be 00 00 00    	jne    802dfc <alloc_block_BF+0x298>
		{
			LIST_REMOVE(&AvailableMemBlocksList, newblk);
  802d3e:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  802d42:	75 17                	jne    802d5b <alloc_block_BF+0x1f7>
  802d44:	83 ec 04             	sub    $0x4,%esp
  802d47:	68 c8 40 80 00       	push   $0x8040c8
  802d4c:	68 db 00 00 00       	push   $0xdb
  802d51:	68 57 40 80 00       	push   $0x804057
  802d56:	e8 98 db ff ff       	call   8008f3 <_panic>
  802d5b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802d5e:	8b 00                	mov    (%eax),%eax
  802d60:	85 c0                	test   %eax,%eax
  802d62:	74 10                	je     802d74 <alloc_block_BF+0x210>
  802d64:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802d67:	8b 00                	mov    (%eax),%eax
  802d69:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802d6c:	8b 52 04             	mov    0x4(%edx),%edx
  802d6f:	89 50 04             	mov    %edx,0x4(%eax)
  802d72:	eb 0b                	jmp    802d7f <alloc_block_BF+0x21b>
  802d74:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802d77:	8b 40 04             	mov    0x4(%eax),%eax
  802d7a:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802d7f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802d82:	8b 40 04             	mov    0x4(%eax),%eax
  802d85:	85 c0                	test   %eax,%eax
  802d87:	74 0f                	je     802d98 <alloc_block_BF+0x234>
  802d89:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802d8c:	8b 40 04             	mov    0x4(%eax),%eax
  802d8f:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802d92:	8b 12                	mov    (%edx),%edx
  802d94:	89 10                	mov    %edx,(%eax)
  802d96:	eb 0a                	jmp    802da2 <alloc_block_BF+0x23e>
  802d98:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802d9b:	8b 00                	mov    (%eax),%eax
  802d9d:	a3 48 51 80 00       	mov    %eax,0x805148
  802da2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802da5:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802dab:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802dae:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802db5:	a1 54 51 80 00       	mov    0x805154,%eax
  802dba:	48                   	dec    %eax
  802dbb:	a3 54 51 80 00       	mov    %eax,0x805154
			newblk->size = versize;
  802dc0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802dc3:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802dc6:	89 50 0c             	mov    %edx,0xc(%eax)
			newblk->sva = newveradd;
  802dc9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802dcc:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802dcf:	89 50 08             	mov    %edx,0x8(%eax)
			blk->size = blk->size - versize;
  802dd2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802dd5:	8b 40 0c             	mov    0xc(%eax),%eax
  802dd8:	2b 45 e8             	sub    -0x18(%ebp),%eax
  802ddb:	89 c2                	mov    %eax,%edx
  802ddd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802de0:	89 50 0c             	mov    %edx,0xc(%eax)
			blk->sva+= newblk->size;
  802de3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802de6:	8b 50 08             	mov    0x8(%eax),%edx
  802de9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802dec:	8b 40 0c             	mov    0xc(%eax),%eax
  802def:	01 c2                	add    %eax,%edx
  802df1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802df4:	89 50 08             	mov    %edx,0x8(%eax)
			return newblk;
  802df7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802dfa:	eb 3b                	jmp    802e37 <alloc_block_BF+0x2d3>
		{
	       newsize = blk->size;
		   newveradd = blk->sva;
		}
	}
	LIST_FOREACH(blk, &FreeMemBlocksList)
  802dfc:	a1 40 51 80 00       	mov    0x805140,%eax
  802e01:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802e04:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802e08:	74 07                	je     802e11 <alloc_block_BF+0x2ad>
  802e0a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e0d:	8b 00                	mov    (%eax),%eax
  802e0f:	eb 05                	jmp    802e16 <alloc_block_BF+0x2b2>
  802e11:	b8 00 00 00 00       	mov    $0x0,%eax
  802e16:	a3 40 51 80 00       	mov    %eax,0x805140
  802e1b:	a1 40 51 80 00       	mov    0x805140,%eax
  802e20:	85 c0                	test   %eax,%eax
  802e22:	0f 85 f8 fe ff ff    	jne    802d20 <alloc_block_BF+0x1bc>
  802e28:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802e2c:	0f 85 ee fe ff ff    	jne    802d20 <alloc_block_BF+0x1bc>
			blk->size = blk->size - versize;
			blk->sva+= newblk->size;
			return newblk;
		}
	}
	return NULL;
  802e32:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802e37:	c9                   	leave  
  802e38:	c3                   	ret    

00802e39 <alloc_block_NF>:
//=========================================
// [7] ALLOCATE BLOCK BY NEXT FIT:
//=========================================
struct MemBlock *last_allocate;
struct MemBlock *alloc_block_NF(uint32 size)
{
  802e39:	55                   	push   %ebp
  802e3a:	89 e5                	mov    %esp,%ebp
  802e3c:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1 - BONUS] [DYNAMIC ALLOCATOR] alloc_block_NF
	// Write your code here, remove the panic and write your code
	//panic("alloc_block_NF() is not implemented yet...!!");
	uint32 versize = size;
  802e3f:	8b 45 08             	mov    0x8(%ebp),%eax
  802e42:	89 45 f0             	mov    %eax,-0x10(%ebp)
	struct MemBlock* blk;
	struct MemBlock* newblk = LIST_FIRST(&AvailableMemBlocksList);
  802e45:	a1 48 51 80 00       	mov    0x805148,%eax
  802e4a:	89 45 ec             	mov    %eax,-0x14(%ebp)

	LIST_FOREACH(blk,&FreeMemBlocksList)
  802e4d:	a1 38 51 80 00       	mov    0x805138,%eax
  802e52:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802e55:	e9 77 01 00 00       	jmp    802fd1 <alloc_block_NF+0x198>
	{
		if(blk->size == versize)
  802e5a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e5d:	8b 40 0c             	mov    0xc(%eax),%eax
  802e60:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  802e63:	0f 85 8a 00 00 00    	jne    802ef3 <alloc_block_NF+0xba>
		{
			LIST_REMOVE(&FreeMemBlocksList,blk);
  802e69:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802e6d:	75 17                	jne    802e86 <alloc_block_NF+0x4d>
  802e6f:	83 ec 04             	sub    $0x4,%esp
  802e72:	68 c8 40 80 00       	push   $0x8040c8
  802e77:	68 f7 00 00 00       	push   $0xf7
  802e7c:	68 57 40 80 00       	push   $0x804057
  802e81:	e8 6d da ff ff       	call   8008f3 <_panic>
  802e86:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e89:	8b 00                	mov    (%eax),%eax
  802e8b:	85 c0                	test   %eax,%eax
  802e8d:	74 10                	je     802e9f <alloc_block_NF+0x66>
  802e8f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e92:	8b 00                	mov    (%eax),%eax
  802e94:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802e97:	8b 52 04             	mov    0x4(%edx),%edx
  802e9a:	89 50 04             	mov    %edx,0x4(%eax)
  802e9d:	eb 0b                	jmp    802eaa <alloc_block_NF+0x71>
  802e9f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ea2:	8b 40 04             	mov    0x4(%eax),%eax
  802ea5:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802eaa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ead:	8b 40 04             	mov    0x4(%eax),%eax
  802eb0:	85 c0                	test   %eax,%eax
  802eb2:	74 0f                	je     802ec3 <alloc_block_NF+0x8a>
  802eb4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802eb7:	8b 40 04             	mov    0x4(%eax),%eax
  802eba:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802ebd:	8b 12                	mov    (%edx),%edx
  802ebf:	89 10                	mov    %edx,(%eax)
  802ec1:	eb 0a                	jmp    802ecd <alloc_block_NF+0x94>
  802ec3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ec6:	8b 00                	mov    (%eax),%eax
  802ec8:	a3 38 51 80 00       	mov    %eax,0x805138
  802ecd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ed0:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802ed6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ed9:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802ee0:	a1 44 51 80 00       	mov    0x805144,%eax
  802ee5:	48                   	dec    %eax
  802ee6:	a3 44 51 80 00       	mov    %eax,0x805144
			return blk;
  802eeb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802eee:	e9 11 01 00 00       	jmp    803004 <alloc_block_NF+0x1cb>
		}
		else if(blk->size > versize)
  802ef3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ef6:	8b 40 0c             	mov    0xc(%eax),%eax
  802ef9:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  802efc:	0f 86 c7 00 00 00    	jbe    802fc9 <alloc_block_NF+0x190>
		{
			LIST_REMOVE(&AvailableMemBlocksList,newblk);
  802f02:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802f06:	75 17                	jne    802f1f <alloc_block_NF+0xe6>
  802f08:	83 ec 04             	sub    $0x4,%esp
  802f0b:	68 c8 40 80 00       	push   $0x8040c8
  802f10:	68 fc 00 00 00       	push   $0xfc
  802f15:	68 57 40 80 00       	push   $0x804057
  802f1a:	e8 d4 d9 ff ff       	call   8008f3 <_panic>
  802f1f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802f22:	8b 00                	mov    (%eax),%eax
  802f24:	85 c0                	test   %eax,%eax
  802f26:	74 10                	je     802f38 <alloc_block_NF+0xff>
  802f28:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802f2b:	8b 00                	mov    (%eax),%eax
  802f2d:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802f30:	8b 52 04             	mov    0x4(%edx),%edx
  802f33:	89 50 04             	mov    %edx,0x4(%eax)
  802f36:	eb 0b                	jmp    802f43 <alloc_block_NF+0x10a>
  802f38:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802f3b:	8b 40 04             	mov    0x4(%eax),%eax
  802f3e:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802f43:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802f46:	8b 40 04             	mov    0x4(%eax),%eax
  802f49:	85 c0                	test   %eax,%eax
  802f4b:	74 0f                	je     802f5c <alloc_block_NF+0x123>
  802f4d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802f50:	8b 40 04             	mov    0x4(%eax),%eax
  802f53:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802f56:	8b 12                	mov    (%edx),%edx
  802f58:	89 10                	mov    %edx,(%eax)
  802f5a:	eb 0a                	jmp    802f66 <alloc_block_NF+0x12d>
  802f5c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802f5f:	8b 00                	mov    (%eax),%eax
  802f61:	a3 48 51 80 00       	mov    %eax,0x805148
  802f66:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802f69:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802f6f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802f72:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802f79:	a1 54 51 80 00       	mov    0x805154,%eax
  802f7e:	48                   	dec    %eax
  802f7f:	a3 54 51 80 00       	mov    %eax,0x805154
			newblk->size = versize;
  802f84:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802f87:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802f8a:	89 50 0c             	mov    %edx,0xc(%eax)
			blk->size = blk->size-versize;
  802f8d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f90:	8b 40 0c             	mov    0xc(%eax),%eax
  802f93:	2b 45 f0             	sub    -0x10(%ebp),%eax
  802f96:	89 c2                	mov    %eax,%edx
  802f98:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f9b:	89 50 0c             	mov    %edx,0xc(%eax)
			uint32 newveradd = blk->sva;
  802f9e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802fa1:	8b 40 08             	mov    0x8(%eax),%eax
  802fa4:	89 45 e8             	mov    %eax,-0x18(%ebp)
			blk->sva+=newblk->size;
  802fa7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802faa:	8b 50 08             	mov    0x8(%eax),%edx
  802fad:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802fb0:	8b 40 0c             	mov    0xc(%eax),%eax
  802fb3:	01 c2                	add    %eax,%edx
  802fb5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802fb8:	89 50 08             	mov    %edx,0x8(%eax)
			newblk->sva = newveradd;
  802fbb:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802fbe:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802fc1:	89 50 08             	mov    %edx,0x8(%eax)
			return newblk;
  802fc4:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802fc7:	eb 3b                	jmp    803004 <alloc_block_NF+0x1cb>
	//panic("alloc_block_NF() is not implemented yet...!!");
	uint32 versize = size;
	struct MemBlock* blk;
	struct MemBlock* newblk = LIST_FIRST(&AvailableMemBlocksList);

	LIST_FOREACH(blk,&FreeMemBlocksList)
  802fc9:	a1 40 51 80 00       	mov    0x805140,%eax
  802fce:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802fd1:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802fd5:	74 07                	je     802fde <alloc_block_NF+0x1a5>
  802fd7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802fda:	8b 00                	mov    (%eax),%eax
  802fdc:	eb 05                	jmp    802fe3 <alloc_block_NF+0x1aa>
  802fde:	b8 00 00 00 00       	mov    $0x0,%eax
  802fe3:	a3 40 51 80 00       	mov    %eax,0x805140
  802fe8:	a1 40 51 80 00       	mov    0x805140,%eax
  802fed:	85 c0                	test   %eax,%eax
  802fef:	0f 85 65 fe ff ff    	jne    802e5a <alloc_block_NF+0x21>
  802ff5:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802ff9:	0f 85 5b fe ff ff    	jne    802e5a <alloc_block_NF+0x21>
			blk->sva+=newblk->size;
			newblk->sva = newveradd;
			return newblk;
		}
	}
	return NULL;
  802fff:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803004:	c9                   	leave  
  803005:	c3                   	ret    

00803006 <addToAvailMemBlocksList>:

//===================================================
// [8] INSERT BLOCK (SORTED WITH MERGE) IN FREE LIST:
//===================================================
void addToAvailMemBlocksList(struct MemBlock *blockToInsert)
{
  803006:	55                   	push   %ebp
  803007:	89 e5                	mov    %esp,%ebp
  803009:	83 ec 08             	sub    $0x8,%esp
	blockToInsert->sva = 0;
  80300c:	8b 45 08             	mov    0x8(%ebp),%eax
  80300f:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
	blockToInsert->size = 0;
  803016:	8b 45 08             	mov    0x8(%ebp),%eax
  803019:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
	//add to avail
	LIST_INSERT_TAIL(&AvailableMemBlocksList, blockToInsert);
  803020:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803024:	75 17                	jne    80303d <addToAvailMemBlocksList+0x37>
  803026:	83 ec 04             	sub    $0x4,%esp
  803029:	68 70 40 80 00       	push   $0x804070
  80302e:	68 10 01 00 00       	push   $0x110
  803033:	68 57 40 80 00       	push   $0x804057
  803038:	e8 b6 d8 ff ff       	call   8008f3 <_panic>
  80303d:	8b 15 4c 51 80 00    	mov    0x80514c,%edx
  803043:	8b 45 08             	mov    0x8(%ebp),%eax
  803046:	89 50 04             	mov    %edx,0x4(%eax)
  803049:	8b 45 08             	mov    0x8(%ebp),%eax
  80304c:	8b 40 04             	mov    0x4(%eax),%eax
  80304f:	85 c0                	test   %eax,%eax
  803051:	74 0c                	je     80305f <addToAvailMemBlocksList+0x59>
  803053:	a1 4c 51 80 00       	mov    0x80514c,%eax
  803058:	8b 55 08             	mov    0x8(%ebp),%edx
  80305b:	89 10                	mov    %edx,(%eax)
  80305d:	eb 08                	jmp    803067 <addToAvailMemBlocksList+0x61>
  80305f:	8b 45 08             	mov    0x8(%ebp),%eax
  803062:	a3 48 51 80 00       	mov    %eax,0x805148
  803067:	8b 45 08             	mov    0x8(%ebp),%eax
  80306a:	a3 4c 51 80 00       	mov    %eax,0x80514c
  80306f:	8b 45 08             	mov    0x8(%ebp),%eax
  803072:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803078:	a1 54 51 80 00       	mov    0x805154,%eax
  80307d:	40                   	inc    %eax
  80307e:	a3 54 51 80 00       	mov    %eax,0x805154
}
  803083:	90                   	nop
  803084:	c9                   	leave  
  803085:	c3                   	ret    

00803086 <insert_sorted_with_merge_freeList>:
void insert_sorted_with_merge_freeList(struct MemBlock *blockToInsert)
{
  803086:	55                   	push   %ebp
  803087:	89 e5                	mov    %esp,%ebp
  803089:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] insert_sorted_with_merge_freeList
	// Write your code here, remove the panic and write your code

	struct MemBlock* last = LIST_LAST(&FreeMemBlocksList);
  80308c:	a1 3c 51 80 00       	mov    0x80513c,%eax
  803091:	89 45 f0             	mov    %eax,-0x10(%ebp)
	//check if list empty
	if (LIST_SIZE(&(FreeMemBlocksList)) == 0)
  803094:	a1 44 51 80 00       	mov    0x805144,%eax
  803099:	85 c0                	test   %eax,%eax
  80309b:	75 68                	jne    803105 <insert_sorted_with_merge_freeList+0x7f>
		LIST_INSERT_HEAD(&FreeMemBlocksList, blockToInsert);
  80309d:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8030a1:	75 17                	jne    8030ba <insert_sorted_with_merge_freeList+0x34>
  8030a3:	83 ec 04             	sub    $0x4,%esp
  8030a6:	68 34 40 80 00       	push   $0x804034
  8030ab:	68 1a 01 00 00       	push   $0x11a
  8030b0:	68 57 40 80 00       	push   $0x804057
  8030b5:	e8 39 d8 ff ff       	call   8008f3 <_panic>
  8030ba:	8b 15 38 51 80 00    	mov    0x805138,%edx
  8030c0:	8b 45 08             	mov    0x8(%ebp),%eax
  8030c3:	89 10                	mov    %edx,(%eax)
  8030c5:	8b 45 08             	mov    0x8(%ebp),%eax
  8030c8:	8b 00                	mov    (%eax),%eax
  8030ca:	85 c0                	test   %eax,%eax
  8030cc:	74 0d                	je     8030db <insert_sorted_with_merge_freeList+0x55>
  8030ce:	a1 38 51 80 00       	mov    0x805138,%eax
  8030d3:	8b 55 08             	mov    0x8(%ebp),%edx
  8030d6:	89 50 04             	mov    %edx,0x4(%eax)
  8030d9:	eb 08                	jmp    8030e3 <insert_sorted_with_merge_freeList+0x5d>
  8030db:	8b 45 08             	mov    0x8(%ebp),%eax
  8030de:	a3 3c 51 80 00       	mov    %eax,0x80513c
  8030e3:	8b 45 08             	mov    0x8(%ebp),%eax
  8030e6:	a3 38 51 80 00       	mov    %eax,0x805138
  8030eb:	8b 45 08             	mov    0x8(%ebp),%eax
  8030ee:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8030f5:	a1 44 51 80 00       	mov    0x805144,%eax
  8030fa:	40                   	inc    %eax
  8030fb:	a3 44 51 80 00       	mov    %eax,0x805144
		}
	}

	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  803100:	e9 c5 03 00 00       	jmp    8034ca <insert_sorted_with_merge_freeList+0x444>
	struct MemBlock* last = LIST_LAST(&FreeMemBlocksList);
	//check if list empty
	if (LIST_SIZE(&(FreeMemBlocksList)) == 0)
		LIST_INSERT_HEAD(&FreeMemBlocksList, blockToInsert);
	//check if it's position is at last
	else if (last->sva < blockToInsert->sva) {
  803105:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803108:	8b 50 08             	mov    0x8(%eax),%edx
  80310b:	8b 45 08             	mov    0x8(%ebp),%eax
  80310e:	8b 40 08             	mov    0x8(%eax),%eax
  803111:	39 c2                	cmp    %eax,%edx
  803113:	0f 83 b2 00 00 00    	jae    8031cb <insert_sorted_with_merge_freeList+0x145>

		//if i have to merge
		if (last->sva + last->size == blockToInsert->sva) {
  803119:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80311c:	8b 50 08             	mov    0x8(%eax),%edx
  80311f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803122:	8b 40 0c             	mov    0xc(%eax),%eax
  803125:	01 c2                	add    %eax,%edx
  803127:	8b 45 08             	mov    0x8(%ebp),%eax
  80312a:	8b 40 08             	mov    0x8(%eax),%eax
  80312d:	39 c2                	cmp    %eax,%edx
  80312f:	75 27                	jne    803158 <insert_sorted_with_merge_freeList+0xd2>
			last->size = last->size + blockToInsert->size;
  803131:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803134:	8b 50 0c             	mov    0xc(%eax),%edx
  803137:	8b 45 08             	mov    0x8(%ebp),%eax
  80313a:	8b 40 0c             	mov    0xc(%eax),%eax
  80313d:	01 c2                	add    %eax,%edx
  80313f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803142:	89 50 0c             	mov    %edx,0xc(%eax)
			addToAvailMemBlocksList(blockToInsert);
  803145:	83 ec 0c             	sub    $0xc,%esp
  803148:	ff 75 08             	pushl  0x8(%ebp)
  80314b:	e8 b6 fe ff ff       	call   803006 <addToAvailMemBlocksList>
  803150:	83 c4 10             	add    $0x10,%esp
		}
	}

	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  803153:	e9 72 03 00 00       	jmp    8034ca <insert_sorted_with_merge_freeList+0x444>
		if (last->sva + last->size == blockToInsert->sva) {
			last->size = last->size + blockToInsert->size;
			addToAvailMemBlocksList(blockToInsert);

		} else {
			LIST_INSERT_AFTER(&FreeMemBlocksList, last, blockToInsert);
  803158:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80315c:	74 06                	je     803164 <insert_sorted_with_merge_freeList+0xde>
  80315e:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803162:	75 17                	jne    80317b <insert_sorted_with_merge_freeList+0xf5>
  803164:	83 ec 04             	sub    $0x4,%esp
  803167:	68 94 40 80 00       	push   $0x804094
  80316c:	68 24 01 00 00       	push   $0x124
  803171:	68 57 40 80 00       	push   $0x804057
  803176:	e8 78 d7 ff ff       	call   8008f3 <_panic>
  80317b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80317e:	8b 10                	mov    (%eax),%edx
  803180:	8b 45 08             	mov    0x8(%ebp),%eax
  803183:	89 10                	mov    %edx,(%eax)
  803185:	8b 45 08             	mov    0x8(%ebp),%eax
  803188:	8b 00                	mov    (%eax),%eax
  80318a:	85 c0                	test   %eax,%eax
  80318c:	74 0b                	je     803199 <insert_sorted_with_merge_freeList+0x113>
  80318e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803191:	8b 00                	mov    (%eax),%eax
  803193:	8b 55 08             	mov    0x8(%ebp),%edx
  803196:	89 50 04             	mov    %edx,0x4(%eax)
  803199:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80319c:	8b 55 08             	mov    0x8(%ebp),%edx
  80319f:	89 10                	mov    %edx,(%eax)
  8031a1:	8b 45 08             	mov    0x8(%ebp),%eax
  8031a4:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8031a7:	89 50 04             	mov    %edx,0x4(%eax)
  8031aa:	8b 45 08             	mov    0x8(%ebp),%eax
  8031ad:	8b 00                	mov    (%eax),%eax
  8031af:	85 c0                	test   %eax,%eax
  8031b1:	75 08                	jne    8031bb <insert_sorted_with_merge_freeList+0x135>
  8031b3:	8b 45 08             	mov    0x8(%ebp),%eax
  8031b6:	a3 3c 51 80 00       	mov    %eax,0x80513c
  8031bb:	a1 44 51 80 00       	mov    0x805144,%eax
  8031c0:	40                   	inc    %eax
  8031c1:	a3 44 51 80 00       	mov    %eax,0x805144
		}
	}

	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  8031c6:	e9 ff 02 00 00       	jmp    8034ca <insert_sorted_with_merge_freeList+0x444>
		} else {
			LIST_INSERT_AFTER(&FreeMemBlocksList, last, blockToInsert);
		}
	} else {
		struct MemBlock *iterator;
		LIST_FOREACH(iterator, &(FreeMemBlocksList))
  8031cb:	a1 38 51 80 00       	mov    0x805138,%eax
  8031d0:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8031d3:	e9 c2 02 00 00       	jmp    80349a <insert_sorted_with_merge_freeList+0x414>
		{

			if (iterator->sva > blockToInsert->sva) {
  8031d8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8031db:	8b 50 08             	mov    0x8(%eax),%edx
  8031de:	8b 45 08             	mov    0x8(%ebp),%eax
  8031e1:	8b 40 08             	mov    0x8(%eax),%eax
  8031e4:	39 c2                	cmp    %eax,%edx
  8031e6:	0f 86 a6 02 00 00    	jbe    803492 <insert_sorted_with_merge_freeList+0x40c>

				struct MemBlock* prev = LIST_PREV(iterator);
  8031ec:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8031ef:	8b 40 04             	mov    0x4(%eax),%eax
  8031f2:	89 45 ec             	mov    %eax,-0x14(%ebp)
				if (prev == NULL) {
  8031f5:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8031f9:	0f 85 ba 00 00 00    	jne    8032b9 <insert_sorted_with_merge_freeList+0x233>
					//check merge
					if (blockToInsert->size + blockToInsert->sva
  8031ff:	8b 45 08             	mov    0x8(%ebp),%eax
  803202:	8b 50 0c             	mov    0xc(%eax),%edx
  803205:	8b 45 08             	mov    0x8(%ebp),%eax
  803208:	8b 40 08             	mov    0x8(%eax),%eax
  80320b:	01 c2                	add    %eax,%edx
							== iterator->sva) {
  80320d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803210:	8b 40 08             	mov    0x8(%eax),%eax
			if (iterator->sva > blockToInsert->sva) {

				struct MemBlock* prev = LIST_PREV(iterator);
				if (prev == NULL) {
					//check merge
					if (blockToInsert->size + blockToInsert->sva
  803213:	39 c2                	cmp    %eax,%edx
  803215:	75 33                	jne    80324a <insert_sorted_with_merge_freeList+0x1c4>
							== iterator->sva) {
						iterator->sva = blockToInsert->sva;
  803217:	8b 45 08             	mov    0x8(%ebp),%eax
  80321a:	8b 50 08             	mov    0x8(%eax),%edx
  80321d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803220:	89 50 08             	mov    %edx,0x8(%eax)
						iterator->size = iterator->size + blockToInsert->size;
  803223:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803226:	8b 50 0c             	mov    0xc(%eax),%edx
  803229:	8b 45 08             	mov    0x8(%ebp),%eax
  80322c:	8b 40 0c             	mov    0xc(%eax),%eax
  80322f:	01 c2                	add    %eax,%edx
  803231:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803234:	89 50 0c             	mov    %edx,0xc(%eax)
						addToAvailMemBlocksList(blockToInsert);
  803237:	83 ec 0c             	sub    $0xc,%esp
  80323a:	ff 75 08             	pushl  0x8(%ebp)
  80323d:	e8 c4 fd ff ff       	call   803006 <addToAvailMemBlocksList>
  803242:	83 c4 10             	add    $0x10,%esp

					else {
						LIST_INSERT_BEFORE(&FreeMemBlocksList, iterator,
								blockToInsert);
					}
					break;
  803245:	e9 80 02 00 00       	jmp    8034ca <insert_sorted_with_merge_freeList+0x444>
						addToAvailMemBlocksList(blockToInsert);

					}

					else {
						LIST_INSERT_BEFORE(&FreeMemBlocksList, iterator,
  80324a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80324e:	74 06                	je     803256 <insert_sorted_with_merge_freeList+0x1d0>
  803250:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803254:	75 17                	jne    80326d <insert_sorted_with_merge_freeList+0x1e7>
  803256:	83 ec 04             	sub    $0x4,%esp
  803259:	68 e8 40 80 00       	push   $0x8040e8
  80325e:	68 3a 01 00 00       	push   $0x13a
  803263:	68 57 40 80 00       	push   $0x804057
  803268:	e8 86 d6 ff ff       	call   8008f3 <_panic>
  80326d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803270:	8b 50 04             	mov    0x4(%eax),%edx
  803273:	8b 45 08             	mov    0x8(%ebp),%eax
  803276:	89 50 04             	mov    %edx,0x4(%eax)
  803279:	8b 45 08             	mov    0x8(%ebp),%eax
  80327c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80327f:	89 10                	mov    %edx,(%eax)
  803281:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803284:	8b 40 04             	mov    0x4(%eax),%eax
  803287:	85 c0                	test   %eax,%eax
  803289:	74 0d                	je     803298 <insert_sorted_with_merge_freeList+0x212>
  80328b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80328e:	8b 40 04             	mov    0x4(%eax),%eax
  803291:	8b 55 08             	mov    0x8(%ebp),%edx
  803294:	89 10                	mov    %edx,(%eax)
  803296:	eb 08                	jmp    8032a0 <insert_sorted_with_merge_freeList+0x21a>
  803298:	8b 45 08             	mov    0x8(%ebp),%eax
  80329b:	a3 38 51 80 00       	mov    %eax,0x805138
  8032a0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8032a3:	8b 55 08             	mov    0x8(%ebp),%edx
  8032a6:	89 50 04             	mov    %edx,0x4(%eax)
  8032a9:	a1 44 51 80 00       	mov    0x805144,%eax
  8032ae:	40                   	inc    %eax
  8032af:	a3 44 51 80 00       	mov    %eax,0x805144
								blockToInsert);
					}
					break;
  8032b4:	e9 11 02 00 00       	jmp    8034ca <insert_sorted_with_merge_freeList+0x444>
				} else {
					//prev and next merge
					if (prev->sva + prev->size + blockToInsert->size
  8032b9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8032bc:	8b 50 08             	mov    0x8(%eax),%edx
  8032bf:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8032c2:	8b 40 0c             	mov    0xc(%eax),%eax
  8032c5:	01 c2                	add    %eax,%edx
  8032c7:	8b 45 08             	mov    0x8(%ebp),%eax
  8032ca:	8b 40 0c             	mov    0xc(%eax),%eax
  8032cd:	01 c2                	add    %eax,%edx
							== iterator->sva) {
  8032cf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8032d2:	8b 40 08             	mov    0x8(%eax),%eax
								blockToInsert);
					}
					break;
				} else {
					//prev and next merge
					if (prev->sva + prev->size + blockToInsert->size
  8032d5:	39 c2                	cmp    %eax,%edx
  8032d7:	0f 85 bf 00 00 00    	jne    80339c <insert_sorted_with_merge_freeList+0x316>
							== iterator->sva) {
						prev->size = prev->size + blockToInsert->size
  8032dd:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8032e0:	8b 50 0c             	mov    0xc(%eax),%edx
  8032e3:	8b 45 08             	mov    0x8(%ebp),%eax
  8032e6:	8b 40 0c             	mov    0xc(%eax),%eax
  8032e9:	01 c2                	add    %eax,%edx
								+ iterator->size;
  8032eb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8032ee:	8b 40 0c             	mov    0xc(%eax),%eax
  8032f1:	01 c2                	add    %eax,%edx
					break;
				} else {
					//prev and next merge
					if (prev->sva + prev->size + blockToInsert->size
							== iterator->sva) {
						prev->size = prev->size + blockToInsert->size
  8032f3:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8032f6:	89 50 0c             	mov    %edx,0xc(%eax)
								+ iterator->size;
						LIST_REMOVE(&FreeMemBlocksList, iterator);
  8032f9:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8032fd:	75 17                	jne    803316 <insert_sorted_with_merge_freeList+0x290>
  8032ff:	83 ec 04             	sub    $0x4,%esp
  803302:	68 c8 40 80 00       	push   $0x8040c8
  803307:	68 43 01 00 00       	push   $0x143
  80330c:	68 57 40 80 00       	push   $0x804057
  803311:	e8 dd d5 ff ff       	call   8008f3 <_panic>
  803316:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803319:	8b 00                	mov    (%eax),%eax
  80331b:	85 c0                	test   %eax,%eax
  80331d:	74 10                	je     80332f <insert_sorted_with_merge_freeList+0x2a9>
  80331f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803322:	8b 00                	mov    (%eax),%eax
  803324:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803327:	8b 52 04             	mov    0x4(%edx),%edx
  80332a:	89 50 04             	mov    %edx,0x4(%eax)
  80332d:	eb 0b                	jmp    80333a <insert_sorted_with_merge_freeList+0x2b4>
  80332f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803332:	8b 40 04             	mov    0x4(%eax),%eax
  803335:	a3 3c 51 80 00       	mov    %eax,0x80513c
  80333a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80333d:	8b 40 04             	mov    0x4(%eax),%eax
  803340:	85 c0                	test   %eax,%eax
  803342:	74 0f                	je     803353 <insert_sorted_with_merge_freeList+0x2cd>
  803344:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803347:	8b 40 04             	mov    0x4(%eax),%eax
  80334a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80334d:	8b 12                	mov    (%edx),%edx
  80334f:	89 10                	mov    %edx,(%eax)
  803351:	eb 0a                	jmp    80335d <insert_sorted_with_merge_freeList+0x2d7>
  803353:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803356:	8b 00                	mov    (%eax),%eax
  803358:	a3 38 51 80 00       	mov    %eax,0x805138
  80335d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803360:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803366:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803369:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803370:	a1 44 51 80 00       	mov    0x805144,%eax
  803375:	48                   	dec    %eax
  803376:	a3 44 51 80 00       	mov    %eax,0x805144
						addToAvailMemBlocksList(blockToInsert);
  80337b:	83 ec 0c             	sub    $0xc,%esp
  80337e:	ff 75 08             	pushl  0x8(%ebp)
  803381:	e8 80 fc ff ff       	call   803006 <addToAvailMemBlocksList>
  803386:	83 c4 10             	add    $0x10,%esp
						addToAvailMemBlocksList(iterator);
  803389:	83 ec 0c             	sub    $0xc,%esp
  80338c:	ff 75 f4             	pushl  -0xc(%ebp)
  80338f:	e8 72 fc ff ff       	call   803006 <addToAvailMemBlocksList>
  803394:	83 c4 10             	add    $0x10,%esp
					//Insert
					else {
						LIST_INSERT_BEFORE(&FreeMemBlocksList, iterator,
								blockToInsert);
					}
					break;
  803397:	e9 2e 01 00 00       	jmp    8034ca <insert_sorted_with_merge_freeList+0x444>
						LIST_REMOVE(&FreeMemBlocksList, iterator);
						addToAvailMemBlocksList(blockToInsert);
						addToAvailMemBlocksList(iterator);
					}
					//previous merge
					else if (prev->sva + prev->size == blockToInsert->sva) {
  80339c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80339f:	8b 50 08             	mov    0x8(%eax),%edx
  8033a2:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8033a5:	8b 40 0c             	mov    0xc(%eax),%eax
  8033a8:	01 c2                	add    %eax,%edx
  8033aa:	8b 45 08             	mov    0x8(%ebp),%eax
  8033ad:	8b 40 08             	mov    0x8(%eax),%eax
  8033b0:	39 c2                	cmp    %eax,%edx
  8033b2:	75 27                	jne    8033db <insert_sorted_with_merge_freeList+0x355>
						prev->size = prev->size + blockToInsert->size;
  8033b4:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8033b7:	8b 50 0c             	mov    0xc(%eax),%edx
  8033ba:	8b 45 08             	mov    0x8(%ebp),%eax
  8033bd:	8b 40 0c             	mov    0xc(%eax),%eax
  8033c0:	01 c2                	add    %eax,%edx
  8033c2:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8033c5:	89 50 0c             	mov    %edx,0xc(%eax)
						addToAvailMemBlocksList(blockToInsert);
  8033c8:	83 ec 0c             	sub    $0xc,%esp
  8033cb:	ff 75 08             	pushl  0x8(%ebp)
  8033ce:	e8 33 fc ff ff       	call   803006 <addToAvailMemBlocksList>
  8033d3:	83 c4 10             	add    $0x10,%esp
					//Insert
					else {
						LIST_INSERT_BEFORE(&FreeMemBlocksList, iterator,
								blockToInsert);
					}
					break;
  8033d6:	e9 ef 00 00 00       	jmp    8034ca <insert_sorted_with_merge_freeList+0x444>
					else if (prev->sva + prev->size == blockToInsert->sva) {
						prev->size = prev->size + blockToInsert->size;
						addToAvailMemBlocksList(blockToInsert);
					}
					//next merge
					else if (blockToInsert->size + blockToInsert->sva
  8033db:	8b 45 08             	mov    0x8(%ebp),%eax
  8033de:	8b 50 0c             	mov    0xc(%eax),%edx
  8033e1:	8b 45 08             	mov    0x8(%ebp),%eax
  8033e4:	8b 40 08             	mov    0x8(%eax),%eax
  8033e7:	01 c2                	add    %eax,%edx
							== iterator->sva) {
  8033e9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8033ec:	8b 40 08             	mov    0x8(%eax),%eax
					else if (prev->sva + prev->size == blockToInsert->sva) {
						prev->size = prev->size + blockToInsert->size;
						addToAvailMemBlocksList(blockToInsert);
					}
					//next merge
					else if (blockToInsert->size + blockToInsert->sva
  8033ef:	39 c2                	cmp    %eax,%edx
  8033f1:	75 33                	jne    803426 <insert_sorted_with_merge_freeList+0x3a0>
							== iterator->sva) {
						iterator->sva = blockToInsert->sva;
  8033f3:	8b 45 08             	mov    0x8(%ebp),%eax
  8033f6:	8b 50 08             	mov    0x8(%eax),%edx
  8033f9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8033fc:	89 50 08             	mov    %edx,0x8(%eax)
						iterator->size = iterator->size + blockToInsert->size;
  8033ff:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803402:	8b 50 0c             	mov    0xc(%eax),%edx
  803405:	8b 45 08             	mov    0x8(%ebp),%eax
  803408:	8b 40 0c             	mov    0xc(%eax),%eax
  80340b:	01 c2                	add    %eax,%edx
  80340d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803410:	89 50 0c             	mov    %edx,0xc(%eax)
						addToAvailMemBlocksList(blockToInsert);
  803413:	83 ec 0c             	sub    $0xc,%esp
  803416:	ff 75 08             	pushl  0x8(%ebp)
  803419:	e8 e8 fb ff ff       	call   803006 <addToAvailMemBlocksList>
  80341e:	83 c4 10             	add    $0x10,%esp
					//Insert
					else {
						LIST_INSERT_BEFORE(&FreeMemBlocksList, iterator,
								blockToInsert);
					}
					break;
  803421:	e9 a4 00 00 00       	jmp    8034ca <insert_sorted_with_merge_freeList+0x444>
						iterator->size = iterator->size + blockToInsert->size;
						addToAvailMemBlocksList(blockToInsert);
					}
					//Insert
					else {
						LIST_INSERT_BEFORE(&FreeMemBlocksList, iterator,
  803426:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80342a:	74 06                	je     803432 <insert_sorted_with_merge_freeList+0x3ac>
  80342c:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803430:	75 17                	jne    803449 <insert_sorted_with_merge_freeList+0x3c3>
  803432:	83 ec 04             	sub    $0x4,%esp
  803435:	68 e8 40 80 00       	push   $0x8040e8
  80343a:	68 56 01 00 00       	push   $0x156
  80343f:	68 57 40 80 00       	push   $0x804057
  803444:	e8 aa d4 ff ff       	call   8008f3 <_panic>
  803449:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80344c:	8b 50 04             	mov    0x4(%eax),%edx
  80344f:	8b 45 08             	mov    0x8(%ebp),%eax
  803452:	89 50 04             	mov    %edx,0x4(%eax)
  803455:	8b 45 08             	mov    0x8(%ebp),%eax
  803458:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80345b:	89 10                	mov    %edx,(%eax)
  80345d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803460:	8b 40 04             	mov    0x4(%eax),%eax
  803463:	85 c0                	test   %eax,%eax
  803465:	74 0d                	je     803474 <insert_sorted_with_merge_freeList+0x3ee>
  803467:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80346a:	8b 40 04             	mov    0x4(%eax),%eax
  80346d:	8b 55 08             	mov    0x8(%ebp),%edx
  803470:	89 10                	mov    %edx,(%eax)
  803472:	eb 08                	jmp    80347c <insert_sorted_with_merge_freeList+0x3f6>
  803474:	8b 45 08             	mov    0x8(%ebp),%eax
  803477:	a3 38 51 80 00       	mov    %eax,0x805138
  80347c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80347f:	8b 55 08             	mov    0x8(%ebp),%edx
  803482:	89 50 04             	mov    %edx,0x4(%eax)
  803485:	a1 44 51 80 00       	mov    0x805144,%eax
  80348a:	40                   	inc    %eax
  80348b:	a3 44 51 80 00       	mov    %eax,0x805144
								blockToInsert);
					}
					break;
  803490:	eb 38                	jmp    8034ca <insert_sorted_with_merge_freeList+0x444>
		} else {
			LIST_INSERT_AFTER(&FreeMemBlocksList, last, blockToInsert);
		}
	} else {
		struct MemBlock *iterator;
		LIST_FOREACH(iterator, &(FreeMemBlocksList))
  803492:	a1 40 51 80 00       	mov    0x805140,%eax
  803497:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80349a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80349e:	74 07                	je     8034a7 <insert_sorted_with_merge_freeList+0x421>
  8034a0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8034a3:	8b 00                	mov    (%eax),%eax
  8034a5:	eb 05                	jmp    8034ac <insert_sorted_with_merge_freeList+0x426>
  8034a7:	b8 00 00 00 00       	mov    $0x0,%eax
  8034ac:	a3 40 51 80 00       	mov    %eax,0x805140
  8034b1:	a1 40 51 80 00       	mov    0x805140,%eax
  8034b6:	85 c0                	test   %eax,%eax
  8034b8:	0f 85 1a fd ff ff    	jne    8031d8 <insert_sorted_with_merge_freeList+0x152>
  8034be:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8034c2:	0f 85 10 fd ff ff    	jne    8031d8 <insert_sorted_with_merge_freeList+0x152>
		}
	}

	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  8034c8:	eb 00                	jmp    8034ca <insert_sorted_with_merge_freeList+0x444>
  8034ca:	90                   	nop
  8034cb:	c9                   	leave  
  8034cc:	c3                   	ret    
  8034cd:	66 90                	xchg   %ax,%ax
  8034cf:	90                   	nop

008034d0 <__udivdi3>:
  8034d0:	55                   	push   %ebp
  8034d1:	57                   	push   %edi
  8034d2:	56                   	push   %esi
  8034d3:	53                   	push   %ebx
  8034d4:	83 ec 1c             	sub    $0x1c,%esp
  8034d7:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  8034db:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  8034df:	8b 7c 24 38          	mov    0x38(%esp),%edi
  8034e3:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8034e7:	89 ca                	mov    %ecx,%edx
  8034e9:	89 f8                	mov    %edi,%eax
  8034eb:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  8034ef:	85 f6                	test   %esi,%esi
  8034f1:	75 2d                	jne    803520 <__udivdi3+0x50>
  8034f3:	39 cf                	cmp    %ecx,%edi
  8034f5:	77 65                	ja     80355c <__udivdi3+0x8c>
  8034f7:	89 fd                	mov    %edi,%ebp
  8034f9:	85 ff                	test   %edi,%edi
  8034fb:	75 0b                	jne    803508 <__udivdi3+0x38>
  8034fd:	b8 01 00 00 00       	mov    $0x1,%eax
  803502:	31 d2                	xor    %edx,%edx
  803504:	f7 f7                	div    %edi
  803506:	89 c5                	mov    %eax,%ebp
  803508:	31 d2                	xor    %edx,%edx
  80350a:	89 c8                	mov    %ecx,%eax
  80350c:	f7 f5                	div    %ebp
  80350e:	89 c1                	mov    %eax,%ecx
  803510:	89 d8                	mov    %ebx,%eax
  803512:	f7 f5                	div    %ebp
  803514:	89 cf                	mov    %ecx,%edi
  803516:	89 fa                	mov    %edi,%edx
  803518:	83 c4 1c             	add    $0x1c,%esp
  80351b:	5b                   	pop    %ebx
  80351c:	5e                   	pop    %esi
  80351d:	5f                   	pop    %edi
  80351e:	5d                   	pop    %ebp
  80351f:	c3                   	ret    
  803520:	39 ce                	cmp    %ecx,%esi
  803522:	77 28                	ja     80354c <__udivdi3+0x7c>
  803524:	0f bd fe             	bsr    %esi,%edi
  803527:	83 f7 1f             	xor    $0x1f,%edi
  80352a:	75 40                	jne    80356c <__udivdi3+0x9c>
  80352c:	39 ce                	cmp    %ecx,%esi
  80352e:	72 0a                	jb     80353a <__udivdi3+0x6a>
  803530:	3b 44 24 08          	cmp    0x8(%esp),%eax
  803534:	0f 87 9e 00 00 00    	ja     8035d8 <__udivdi3+0x108>
  80353a:	b8 01 00 00 00       	mov    $0x1,%eax
  80353f:	89 fa                	mov    %edi,%edx
  803541:	83 c4 1c             	add    $0x1c,%esp
  803544:	5b                   	pop    %ebx
  803545:	5e                   	pop    %esi
  803546:	5f                   	pop    %edi
  803547:	5d                   	pop    %ebp
  803548:	c3                   	ret    
  803549:	8d 76 00             	lea    0x0(%esi),%esi
  80354c:	31 ff                	xor    %edi,%edi
  80354e:	31 c0                	xor    %eax,%eax
  803550:	89 fa                	mov    %edi,%edx
  803552:	83 c4 1c             	add    $0x1c,%esp
  803555:	5b                   	pop    %ebx
  803556:	5e                   	pop    %esi
  803557:	5f                   	pop    %edi
  803558:	5d                   	pop    %ebp
  803559:	c3                   	ret    
  80355a:	66 90                	xchg   %ax,%ax
  80355c:	89 d8                	mov    %ebx,%eax
  80355e:	f7 f7                	div    %edi
  803560:	31 ff                	xor    %edi,%edi
  803562:	89 fa                	mov    %edi,%edx
  803564:	83 c4 1c             	add    $0x1c,%esp
  803567:	5b                   	pop    %ebx
  803568:	5e                   	pop    %esi
  803569:	5f                   	pop    %edi
  80356a:	5d                   	pop    %ebp
  80356b:	c3                   	ret    
  80356c:	bd 20 00 00 00       	mov    $0x20,%ebp
  803571:	89 eb                	mov    %ebp,%ebx
  803573:	29 fb                	sub    %edi,%ebx
  803575:	89 f9                	mov    %edi,%ecx
  803577:	d3 e6                	shl    %cl,%esi
  803579:	89 c5                	mov    %eax,%ebp
  80357b:	88 d9                	mov    %bl,%cl
  80357d:	d3 ed                	shr    %cl,%ebp
  80357f:	89 e9                	mov    %ebp,%ecx
  803581:	09 f1                	or     %esi,%ecx
  803583:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  803587:	89 f9                	mov    %edi,%ecx
  803589:	d3 e0                	shl    %cl,%eax
  80358b:	89 c5                	mov    %eax,%ebp
  80358d:	89 d6                	mov    %edx,%esi
  80358f:	88 d9                	mov    %bl,%cl
  803591:	d3 ee                	shr    %cl,%esi
  803593:	89 f9                	mov    %edi,%ecx
  803595:	d3 e2                	shl    %cl,%edx
  803597:	8b 44 24 08          	mov    0x8(%esp),%eax
  80359b:	88 d9                	mov    %bl,%cl
  80359d:	d3 e8                	shr    %cl,%eax
  80359f:	09 c2                	or     %eax,%edx
  8035a1:	89 d0                	mov    %edx,%eax
  8035a3:	89 f2                	mov    %esi,%edx
  8035a5:	f7 74 24 0c          	divl   0xc(%esp)
  8035a9:	89 d6                	mov    %edx,%esi
  8035ab:	89 c3                	mov    %eax,%ebx
  8035ad:	f7 e5                	mul    %ebp
  8035af:	39 d6                	cmp    %edx,%esi
  8035b1:	72 19                	jb     8035cc <__udivdi3+0xfc>
  8035b3:	74 0b                	je     8035c0 <__udivdi3+0xf0>
  8035b5:	89 d8                	mov    %ebx,%eax
  8035b7:	31 ff                	xor    %edi,%edi
  8035b9:	e9 58 ff ff ff       	jmp    803516 <__udivdi3+0x46>
  8035be:	66 90                	xchg   %ax,%ax
  8035c0:	8b 54 24 08          	mov    0x8(%esp),%edx
  8035c4:	89 f9                	mov    %edi,%ecx
  8035c6:	d3 e2                	shl    %cl,%edx
  8035c8:	39 c2                	cmp    %eax,%edx
  8035ca:	73 e9                	jae    8035b5 <__udivdi3+0xe5>
  8035cc:	8d 43 ff             	lea    -0x1(%ebx),%eax
  8035cf:	31 ff                	xor    %edi,%edi
  8035d1:	e9 40 ff ff ff       	jmp    803516 <__udivdi3+0x46>
  8035d6:	66 90                	xchg   %ax,%ax
  8035d8:	31 c0                	xor    %eax,%eax
  8035da:	e9 37 ff ff ff       	jmp    803516 <__udivdi3+0x46>
  8035df:	90                   	nop

008035e0 <__umoddi3>:
  8035e0:	55                   	push   %ebp
  8035e1:	57                   	push   %edi
  8035e2:	56                   	push   %esi
  8035e3:	53                   	push   %ebx
  8035e4:	83 ec 1c             	sub    $0x1c,%esp
  8035e7:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  8035eb:	8b 74 24 34          	mov    0x34(%esp),%esi
  8035ef:	8b 7c 24 38          	mov    0x38(%esp),%edi
  8035f3:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  8035f7:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8035fb:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8035ff:	89 f3                	mov    %esi,%ebx
  803601:	89 fa                	mov    %edi,%edx
  803603:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  803607:	89 34 24             	mov    %esi,(%esp)
  80360a:	85 c0                	test   %eax,%eax
  80360c:	75 1a                	jne    803628 <__umoddi3+0x48>
  80360e:	39 f7                	cmp    %esi,%edi
  803610:	0f 86 a2 00 00 00    	jbe    8036b8 <__umoddi3+0xd8>
  803616:	89 c8                	mov    %ecx,%eax
  803618:	89 f2                	mov    %esi,%edx
  80361a:	f7 f7                	div    %edi
  80361c:	89 d0                	mov    %edx,%eax
  80361e:	31 d2                	xor    %edx,%edx
  803620:	83 c4 1c             	add    $0x1c,%esp
  803623:	5b                   	pop    %ebx
  803624:	5e                   	pop    %esi
  803625:	5f                   	pop    %edi
  803626:	5d                   	pop    %ebp
  803627:	c3                   	ret    
  803628:	39 f0                	cmp    %esi,%eax
  80362a:	0f 87 ac 00 00 00    	ja     8036dc <__umoddi3+0xfc>
  803630:	0f bd e8             	bsr    %eax,%ebp
  803633:	83 f5 1f             	xor    $0x1f,%ebp
  803636:	0f 84 ac 00 00 00    	je     8036e8 <__umoddi3+0x108>
  80363c:	bf 20 00 00 00       	mov    $0x20,%edi
  803641:	29 ef                	sub    %ebp,%edi
  803643:	89 fe                	mov    %edi,%esi
  803645:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  803649:	89 e9                	mov    %ebp,%ecx
  80364b:	d3 e0                	shl    %cl,%eax
  80364d:	89 d7                	mov    %edx,%edi
  80364f:	89 f1                	mov    %esi,%ecx
  803651:	d3 ef                	shr    %cl,%edi
  803653:	09 c7                	or     %eax,%edi
  803655:	89 e9                	mov    %ebp,%ecx
  803657:	d3 e2                	shl    %cl,%edx
  803659:	89 14 24             	mov    %edx,(%esp)
  80365c:	89 d8                	mov    %ebx,%eax
  80365e:	d3 e0                	shl    %cl,%eax
  803660:	89 c2                	mov    %eax,%edx
  803662:	8b 44 24 08          	mov    0x8(%esp),%eax
  803666:	d3 e0                	shl    %cl,%eax
  803668:	89 44 24 04          	mov    %eax,0x4(%esp)
  80366c:	8b 44 24 08          	mov    0x8(%esp),%eax
  803670:	89 f1                	mov    %esi,%ecx
  803672:	d3 e8                	shr    %cl,%eax
  803674:	09 d0                	or     %edx,%eax
  803676:	d3 eb                	shr    %cl,%ebx
  803678:	89 da                	mov    %ebx,%edx
  80367a:	f7 f7                	div    %edi
  80367c:	89 d3                	mov    %edx,%ebx
  80367e:	f7 24 24             	mull   (%esp)
  803681:	89 c6                	mov    %eax,%esi
  803683:	89 d1                	mov    %edx,%ecx
  803685:	39 d3                	cmp    %edx,%ebx
  803687:	0f 82 87 00 00 00    	jb     803714 <__umoddi3+0x134>
  80368d:	0f 84 91 00 00 00    	je     803724 <__umoddi3+0x144>
  803693:	8b 54 24 04          	mov    0x4(%esp),%edx
  803697:	29 f2                	sub    %esi,%edx
  803699:	19 cb                	sbb    %ecx,%ebx
  80369b:	89 d8                	mov    %ebx,%eax
  80369d:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  8036a1:	d3 e0                	shl    %cl,%eax
  8036a3:	89 e9                	mov    %ebp,%ecx
  8036a5:	d3 ea                	shr    %cl,%edx
  8036a7:	09 d0                	or     %edx,%eax
  8036a9:	89 e9                	mov    %ebp,%ecx
  8036ab:	d3 eb                	shr    %cl,%ebx
  8036ad:	89 da                	mov    %ebx,%edx
  8036af:	83 c4 1c             	add    $0x1c,%esp
  8036b2:	5b                   	pop    %ebx
  8036b3:	5e                   	pop    %esi
  8036b4:	5f                   	pop    %edi
  8036b5:	5d                   	pop    %ebp
  8036b6:	c3                   	ret    
  8036b7:	90                   	nop
  8036b8:	89 fd                	mov    %edi,%ebp
  8036ba:	85 ff                	test   %edi,%edi
  8036bc:	75 0b                	jne    8036c9 <__umoddi3+0xe9>
  8036be:	b8 01 00 00 00       	mov    $0x1,%eax
  8036c3:	31 d2                	xor    %edx,%edx
  8036c5:	f7 f7                	div    %edi
  8036c7:	89 c5                	mov    %eax,%ebp
  8036c9:	89 f0                	mov    %esi,%eax
  8036cb:	31 d2                	xor    %edx,%edx
  8036cd:	f7 f5                	div    %ebp
  8036cf:	89 c8                	mov    %ecx,%eax
  8036d1:	f7 f5                	div    %ebp
  8036d3:	89 d0                	mov    %edx,%eax
  8036d5:	e9 44 ff ff ff       	jmp    80361e <__umoddi3+0x3e>
  8036da:	66 90                	xchg   %ax,%ax
  8036dc:	89 c8                	mov    %ecx,%eax
  8036de:	89 f2                	mov    %esi,%edx
  8036e0:	83 c4 1c             	add    $0x1c,%esp
  8036e3:	5b                   	pop    %ebx
  8036e4:	5e                   	pop    %esi
  8036e5:	5f                   	pop    %edi
  8036e6:	5d                   	pop    %ebp
  8036e7:	c3                   	ret    
  8036e8:	3b 04 24             	cmp    (%esp),%eax
  8036eb:	72 06                	jb     8036f3 <__umoddi3+0x113>
  8036ed:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  8036f1:	77 0f                	ja     803702 <__umoddi3+0x122>
  8036f3:	89 f2                	mov    %esi,%edx
  8036f5:	29 f9                	sub    %edi,%ecx
  8036f7:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  8036fb:	89 14 24             	mov    %edx,(%esp)
  8036fe:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  803702:	8b 44 24 04          	mov    0x4(%esp),%eax
  803706:	8b 14 24             	mov    (%esp),%edx
  803709:	83 c4 1c             	add    $0x1c,%esp
  80370c:	5b                   	pop    %ebx
  80370d:	5e                   	pop    %esi
  80370e:	5f                   	pop    %edi
  80370f:	5d                   	pop    %ebp
  803710:	c3                   	ret    
  803711:	8d 76 00             	lea    0x0(%esi),%esi
  803714:	2b 04 24             	sub    (%esp),%eax
  803717:	19 fa                	sbb    %edi,%edx
  803719:	89 d1                	mov    %edx,%ecx
  80371b:	89 c6                	mov    %eax,%esi
  80371d:	e9 71 ff ff ff       	jmp    803693 <__umoddi3+0xb3>
  803722:	66 90                	xchg   %ax,%ax
  803724:	39 44 24 04          	cmp    %eax,0x4(%esp)
  803728:	72 ea                	jb     803714 <__umoddi3+0x134>
  80372a:	89 d9                	mov    %ebx,%ecx
  80372c:	e9 62 ff ff ff       	jmp    803693 <__umoddi3+0xb3>
