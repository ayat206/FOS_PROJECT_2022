
obj/user/quicksort_noleakage:     file format elf32-i386


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
  800031:	e8 0e 06 00 00       	call   800644 <libmain>
1:      jmp 1b
  800036:	eb fe                	jmp    800036 <args_exist+0x5>

00800038 <_main>:
void QuickSort(int *Elements, int NumOfElements);
void QSort(int *Elements,int NumOfElements, int startIndex, int finalIndex);
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
  800041:	e8 7f 20 00 00       	call   8020c5 <sys_disable_interrupt>
		cprintf("\n");
  800046:	83 ec 0c             	sub    $0xc,%esp
  800049:	68 e0 37 80 00       	push   $0x8037e0
  80004e:	e8 e1 09 00 00       	call   800a34 <cprintf>
  800053:	83 c4 10             	add    $0x10,%esp
		cprintf("!!!!!!!!!!!!!!!!!!!!!!!\n");
  800056:	83 ec 0c             	sub    $0xc,%esp
  800059:	68 e2 37 80 00       	push   $0x8037e2
  80005e:	e8 d1 09 00 00       	call   800a34 <cprintf>
  800063:	83 c4 10             	add    $0x10,%esp
		cprintf("!!!   QUICK SORT    !!!\n");
  800066:	83 ec 0c             	sub    $0xc,%esp
  800069:	68 fb 37 80 00       	push   $0x8037fb
  80006e:	e8 c1 09 00 00       	call   800a34 <cprintf>
  800073:	83 c4 10             	add    $0x10,%esp
		cprintf("!!!!!!!!!!!!!!!!!!!!!!!\n");
  800076:	83 ec 0c             	sub    $0xc,%esp
  800079:	68 e2 37 80 00       	push   $0x8037e2
  80007e:	e8 b1 09 00 00       	call   800a34 <cprintf>
  800083:	83 c4 10             	add    $0x10,%esp
		cprintf("\n");
  800086:	83 ec 0c             	sub    $0xc,%esp
  800089:	68 e0 37 80 00       	push   $0x8037e0
  80008e:	e8 a1 09 00 00       	call   800a34 <cprintf>
  800093:	83 c4 10             	add    $0x10,%esp

		readline("Enter the number of elements: ", Line);
  800096:	83 ec 08             	sub    $0x8,%esp
  800099:	8d 85 e9 fe ff ff    	lea    -0x117(%ebp),%eax
  80009f:	50                   	push   %eax
  8000a0:	68 14 38 80 00       	push   $0x803814
  8000a5:	e8 0c 10 00 00       	call   8010b6 <readline>
  8000aa:	83 c4 10             	add    $0x10,%esp
		int NumOfElements = strtol(Line, NULL, 10) ;
  8000ad:	83 ec 04             	sub    $0x4,%esp
  8000b0:	6a 0a                	push   $0xa
  8000b2:	6a 00                	push   $0x0
  8000b4:	8d 85 e9 fe ff ff    	lea    -0x117(%ebp),%eax
  8000ba:	50                   	push   %eax
  8000bb:	e8 5c 15 00 00       	call   80161c <strtol>
  8000c0:	83 c4 10             	add    $0x10,%esp
  8000c3:	89 45 f4             	mov    %eax,-0xc(%ebp)
		int *Elements = malloc(sizeof(int) * NumOfElements) ;
  8000c6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8000c9:	c1 e0 02             	shl    $0x2,%eax
  8000cc:	83 ec 0c             	sub    $0xc,%esp
  8000cf:	50                   	push   %eax
  8000d0:	e8 f7 1a 00 00       	call   801bcc <malloc>
  8000d5:	83 c4 10             	add    $0x10,%esp
  8000d8:	89 45 f0             	mov    %eax,-0x10(%ebp)
		cprintf("Chose the initialization method:\n") ;
  8000db:	83 ec 0c             	sub    $0xc,%esp
  8000de:	68 34 38 80 00       	push   $0x803834
  8000e3:	e8 4c 09 00 00       	call   800a34 <cprintf>
  8000e8:	83 c4 10             	add    $0x10,%esp
		cprintf("a) Ascending\n") ;
  8000eb:	83 ec 0c             	sub    $0xc,%esp
  8000ee:	68 56 38 80 00       	push   $0x803856
  8000f3:	e8 3c 09 00 00       	call   800a34 <cprintf>
  8000f8:	83 c4 10             	add    $0x10,%esp
		cprintf("b) Descending\n") ;
  8000fb:	83 ec 0c             	sub    $0xc,%esp
  8000fe:	68 64 38 80 00       	push   $0x803864
  800103:	e8 2c 09 00 00       	call   800a34 <cprintf>
  800108:	83 c4 10             	add    $0x10,%esp
		cprintf("c) Semi random\n");
  80010b:	83 ec 0c             	sub    $0xc,%esp
  80010e:	68 73 38 80 00       	push   $0x803873
  800113:	e8 1c 09 00 00       	call   800a34 <cprintf>
  800118:	83 c4 10             	add    $0x10,%esp
		do
		{
			cprintf("Select: ") ;
  80011b:	83 ec 0c             	sub    $0xc,%esp
  80011e:	68 83 38 80 00       	push   $0x803883
  800123:	e8 0c 09 00 00       	call   800a34 <cprintf>
  800128:	83 c4 10             	add    $0x10,%esp
			Chose = getchar() ;
  80012b:	e8 bc 04 00 00       	call   8005ec <getchar>
  800130:	88 45 ef             	mov    %al,-0x11(%ebp)
			cputchar(Chose);
  800133:	0f be 45 ef          	movsbl -0x11(%ebp),%eax
  800137:	83 ec 0c             	sub    $0xc,%esp
  80013a:	50                   	push   %eax
  80013b:	e8 64 04 00 00       	call   8005a4 <cputchar>
  800140:	83 c4 10             	add    $0x10,%esp
			cputchar('\n');
  800143:	83 ec 0c             	sub    $0xc,%esp
  800146:	6a 0a                	push   $0xa
  800148:	e8 57 04 00 00       	call   8005a4 <cputchar>
  80014d:	83 c4 10             	add    $0x10,%esp
		} while (Chose != 'a' && Chose != 'b' && Chose != 'c');
  800150:	80 7d ef 61          	cmpb   $0x61,-0x11(%ebp)
  800154:	74 0c                	je     800162 <_main+0x12a>
  800156:	80 7d ef 62          	cmpb   $0x62,-0x11(%ebp)
  80015a:	74 06                	je     800162 <_main+0x12a>
  80015c:	80 7d ef 63          	cmpb   $0x63,-0x11(%ebp)
  800160:	75 b9                	jne    80011b <_main+0xe3>

		//2012: lock the interrupt
		sys_enable_interrupt();
  800162:	e8 78 1f 00 00       	call   8020df <sys_enable_interrupt>

		int  i ;
		switch (Chose)
  800167:	0f be 45 ef          	movsbl -0x11(%ebp),%eax
  80016b:	83 f8 62             	cmp    $0x62,%eax
  80016e:	74 1d                	je     80018d <_main+0x155>
  800170:	83 f8 63             	cmp    $0x63,%eax
  800173:	74 2b                	je     8001a0 <_main+0x168>
  800175:	83 f8 61             	cmp    $0x61,%eax
  800178:	75 39                	jne    8001b3 <_main+0x17b>
		{
		case 'a':
			InitializeAscending(Elements, NumOfElements);
  80017a:	83 ec 08             	sub    $0x8,%esp
  80017d:	ff 75 f4             	pushl  -0xc(%ebp)
  800180:	ff 75 f0             	pushl  -0x10(%ebp)
  800183:	e8 e4 02 00 00       	call   80046c <InitializeAscending>
  800188:	83 c4 10             	add    $0x10,%esp
			break ;
  80018b:	eb 37                	jmp    8001c4 <_main+0x18c>
		case 'b':
			InitializeDescending(Elements, NumOfElements);
  80018d:	83 ec 08             	sub    $0x8,%esp
  800190:	ff 75 f4             	pushl  -0xc(%ebp)
  800193:	ff 75 f0             	pushl  -0x10(%ebp)
  800196:	e8 02 03 00 00       	call   80049d <InitializeDescending>
  80019b:	83 c4 10             	add    $0x10,%esp
			break ;
  80019e:	eb 24                	jmp    8001c4 <_main+0x18c>
		case 'c':
			InitializeSemiRandom(Elements, NumOfElements);
  8001a0:	83 ec 08             	sub    $0x8,%esp
  8001a3:	ff 75 f4             	pushl  -0xc(%ebp)
  8001a6:	ff 75 f0             	pushl  -0x10(%ebp)
  8001a9:	e8 24 03 00 00       	call   8004d2 <InitializeSemiRandom>
  8001ae:	83 c4 10             	add    $0x10,%esp
			break ;
  8001b1:	eb 11                	jmp    8001c4 <_main+0x18c>
		default:
			InitializeSemiRandom(Elements, NumOfElements);
  8001b3:	83 ec 08             	sub    $0x8,%esp
  8001b6:	ff 75 f4             	pushl  -0xc(%ebp)
  8001b9:	ff 75 f0             	pushl  -0x10(%ebp)
  8001bc:	e8 11 03 00 00       	call   8004d2 <InitializeSemiRandom>
  8001c1:	83 c4 10             	add    $0x10,%esp
		}

		QuickSort(Elements, NumOfElements);
  8001c4:	83 ec 08             	sub    $0x8,%esp
  8001c7:	ff 75 f4             	pushl  -0xc(%ebp)
  8001ca:	ff 75 f0             	pushl  -0x10(%ebp)
  8001cd:	e8 df 00 00 00       	call   8002b1 <QuickSort>
  8001d2:	83 c4 10             	add    $0x10,%esp

		sys_disable_interrupt();
  8001d5:	e8 eb 1e 00 00       	call   8020c5 <sys_disable_interrupt>
			cprintf("Sorting is Finished!!!!it'll be checked now....\n") ;
  8001da:	83 ec 0c             	sub    $0xc,%esp
  8001dd:	68 8c 38 80 00       	push   $0x80388c
  8001e2:	e8 4d 08 00 00       	call   800a34 <cprintf>
  8001e7:	83 c4 10             	add    $0x10,%esp
		//		PrintElements(Elements, NumOfElements);
		sys_enable_interrupt();
  8001ea:	e8 f0 1e 00 00       	call   8020df <sys_enable_interrupt>

		uint32 Sorted = CheckSorted(Elements, NumOfElements);
  8001ef:	83 ec 08             	sub    $0x8,%esp
  8001f2:	ff 75 f4             	pushl  -0xc(%ebp)
  8001f5:	ff 75 f0             	pushl  -0x10(%ebp)
  8001f8:	e8 c5 01 00 00       	call   8003c2 <CheckSorted>
  8001fd:	83 c4 10             	add    $0x10,%esp
  800200:	89 45 e8             	mov    %eax,-0x18(%ebp)

		if(Sorted == 0) panic("The array is NOT sorted correctly") ;
  800203:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  800207:	75 14                	jne    80021d <_main+0x1e5>
  800209:	83 ec 04             	sub    $0x4,%esp
  80020c:	68 c0 38 80 00       	push   $0x8038c0
  800211:	6a 49                	push   $0x49
  800213:	68 e2 38 80 00       	push   $0x8038e2
  800218:	e8 63 05 00 00       	call   800780 <_panic>
		else
		{
			sys_disable_interrupt();
  80021d:	e8 a3 1e 00 00       	call   8020c5 <sys_disable_interrupt>
			cprintf("===============================================\n") ;
  800222:	83 ec 0c             	sub    $0xc,%esp
  800225:	68 00 39 80 00       	push   $0x803900
  80022a:	e8 05 08 00 00       	call   800a34 <cprintf>
  80022f:	83 c4 10             	add    $0x10,%esp
			cprintf("Congratulations!! The array is sorted correctly\n") ;
  800232:	83 ec 0c             	sub    $0xc,%esp
  800235:	68 34 39 80 00       	push   $0x803934
  80023a:	e8 f5 07 00 00       	call   800a34 <cprintf>
  80023f:	83 c4 10             	add    $0x10,%esp
			cprintf("===============================================\n\n") ;
  800242:	83 ec 0c             	sub    $0xc,%esp
  800245:	68 68 39 80 00       	push   $0x803968
  80024a:	e8 e5 07 00 00       	call   800a34 <cprintf>
  80024f:	83 c4 10             	add    $0x10,%esp
			sys_enable_interrupt();
  800252:	e8 88 1e 00 00       	call   8020df <sys_enable_interrupt>

		}

		free(Elements) ;
  800257:	83 ec 0c             	sub    $0xc,%esp
  80025a:	ff 75 f0             	pushl  -0x10(%ebp)
  80025d:	e8 eb 19 00 00       	call   801c4d <free>
  800262:	83 c4 10             	add    $0x10,%esp

		sys_disable_interrupt();
  800265:	e8 5b 1e 00 00       	call   8020c5 <sys_disable_interrupt>

		cprintf("Do you want to repeat (y/n): ") ;
  80026a:	83 ec 0c             	sub    $0xc,%esp
  80026d:	68 9a 39 80 00       	push   $0x80399a
  800272:	e8 bd 07 00 00       	call   800a34 <cprintf>
  800277:	83 c4 10             	add    $0x10,%esp
		Chose = getchar() ;
  80027a:	e8 6d 03 00 00       	call   8005ec <getchar>
  80027f:	88 45 ef             	mov    %al,-0x11(%ebp)
		cputchar(Chose);
  800282:	0f be 45 ef          	movsbl -0x11(%ebp),%eax
  800286:	83 ec 0c             	sub    $0xc,%esp
  800289:	50                   	push   %eax
  80028a:	e8 15 03 00 00       	call   8005a4 <cputchar>
  80028f:	83 c4 10             	add    $0x10,%esp
		cputchar('\n');
  800292:	83 ec 0c             	sub    $0xc,%esp
  800295:	6a 0a                	push   $0xa
  800297:	e8 08 03 00 00       	call   8005a4 <cputchar>
  80029c:	83 c4 10             	add    $0x10,%esp

		sys_enable_interrupt();
  80029f:	e8 3b 1e 00 00       	call   8020df <sys_enable_interrupt>

	} while (Chose == 'y');
  8002a4:	80 7d ef 79          	cmpb   $0x79,-0x11(%ebp)
  8002a8:	0f 84 93 fd ff ff    	je     800041 <_main+0x9>

}
  8002ae:	90                   	nop
  8002af:	c9                   	leave  
  8002b0:	c3                   	ret    

008002b1 <QuickSort>:

///Quick sort
void QuickSort(int *Elements, int NumOfElements)
{
  8002b1:	55                   	push   %ebp
  8002b2:	89 e5                	mov    %esp,%ebp
  8002b4:	83 ec 08             	sub    $0x8,%esp
	QSort(Elements, NumOfElements, 0, NumOfElements-1) ;
  8002b7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8002ba:	48                   	dec    %eax
  8002bb:	50                   	push   %eax
  8002bc:	6a 00                	push   $0x0
  8002be:	ff 75 0c             	pushl  0xc(%ebp)
  8002c1:	ff 75 08             	pushl  0x8(%ebp)
  8002c4:	e8 06 00 00 00       	call   8002cf <QSort>
  8002c9:	83 c4 10             	add    $0x10,%esp
}
  8002cc:	90                   	nop
  8002cd:	c9                   	leave  
  8002ce:	c3                   	ret    

008002cf <QSort>:


void QSort(int *Elements,int NumOfElements, int startIndex, int finalIndex)
{
  8002cf:	55                   	push   %ebp
  8002d0:	89 e5                	mov    %esp,%ebp
  8002d2:	83 ec 18             	sub    $0x18,%esp
	if (startIndex >= finalIndex) return;
  8002d5:	8b 45 10             	mov    0x10(%ebp),%eax
  8002d8:	3b 45 14             	cmp    0x14(%ebp),%eax
  8002db:	0f 8d de 00 00 00    	jge    8003bf <QSort+0xf0>

	int i = startIndex+1, j = finalIndex;
  8002e1:	8b 45 10             	mov    0x10(%ebp),%eax
  8002e4:	40                   	inc    %eax
  8002e5:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8002e8:	8b 45 14             	mov    0x14(%ebp),%eax
  8002eb:	89 45 f0             	mov    %eax,-0x10(%ebp)

	while (i <= j)
  8002ee:	e9 80 00 00 00       	jmp    800373 <QSort+0xa4>
	{
		while (i <= finalIndex && Elements[startIndex] >= Elements[i]) i++;
  8002f3:	ff 45 f4             	incl   -0xc(%ebp)
  8002f6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8002f9:	3b 45 14             	cmp    0x14(%ebp),%eax
  8002fc:	7f 2b                	jg     800329 <QSort+0x5a>
  8002fe:	8b 45 10             	mov    0x10(%ebp),%eax
  800301:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800308:	8b 45 08             	mov    0x8(%ebp),%eax
  80030b:	01 d0                	add    %edx,%eax
  80030d:	8b 10                	mov    (%eax),%edx
  80030f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800312:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  800319:	8b 45 08             	mov    0x8(%ebp),%eax
  80031c:	01 c8                	add    %ecx,%eax
  80031e:	8b 00                	mov    (%eax),%eax
  800320:	39 c2                	cmp    %eax,%edx
  800322:	7d cf                	jge    8002f3 <QSort+0x24>
		while (j > startIndex && Elements[startIndex] <= Elements[j]) j--;
  800324:	eb 03                	jmp    800329 <QSort+0x5a>
  800326:	ff 4d f0             	decl   -0x10(%ebp)
  800329:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80032c:	3b 45 10             	cmp    0x10(%ebp),%eax
  80032f:	7e 26                	jle    800357 <QSort+0x88>
  800331:	8b 45 10             	mov    0x10(%ebp),%eax
  800334:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80033b:	8b 45 08             	mov    0x8(%ebp),%eax
  80033e:	01 d0                	add    %edx,%eax
  800340:	8b 10                	mov    (%eax),%edx
  800342:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800345:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  80034c:	8b 45 08             	mov    0x8(%ebp),%eax
  80034f:	01 c8                	add    %ecx,%eax
  800351:	8b 00                	mov    (%eax),%eax
  800353:	39 c2                	cmp    %eax,%edx
  800355:	7e cf                	jle    800326 <QSort+0x57>

		if (i <= j)
  800357:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80035a:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80035d:	7f 14                	jg     800373 <QSort+0xa4>
		{
			Swap(Elements, i, j);
  80035f:	83 ec 04             	sub    $0x4,%esp
  800362:	ff 75 f0             	pushl  -0x10(%ebp)
  800365:	ff 75 f4             	pushl  -0xc(%ebp)
  800368:	ff 75 08             	pushl  0x8(%ebp)
  80036b:	e8 a9 00 00 00       	call   800419 <Swap>
  800370:	83 c4 10             	add    $0x10,%esp
{
	if (startIndex >= finalIndex) return;

	int i = startIndex+1, j = finalIndex;

	while (i <= j)
  800373:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800376:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800379:	0f 8e 77 ff ff ff    	jle    8002f6 <QSort+0x27>
		{
			Swap(Elements, i, j);
		}
	}

	Swap( Elements, startIndex, j);
  80037f:	83 ec 04             	sub    $0x4,%esp
  800382:	ff 75 f0             	pushl  -0x10(%ebp)
  800385:	ff 75 10             	pushl  0x10(%ebp)
  800388:	ff 75 08             	pushl  0x8(%ebp)
  80038b:	e8 89 00 00 00       	call   800419 <Swap>
  800390:	83 c4 10             	add    $0x10,%esp

	QSort(Elements, NumOfElements, startIndex, j - 1);
  800393:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800396:	48                   	dec    %eax
  800397:	50                   	push   %eax
  800398:	ff 75 10             	pushl  0x10(%ebp)
  80039b:	ff 75 0c             	pushl  0xc(%ebp)
  80039e:	ff 75 08             	pushl  0x8(%ebp)
  8003a1:	e8 29 ff ff ff       	call   8002cf <QSort>
  8003a6:	83 c4 10             	add    $0x10,%esp
	QSort(Elements, NumOfElements, i, finalIndex);
  8003a9:	ff 75 14             	pushl  0x14(%ebp)
  8003ac:	ff 75 f4             	pushl  -0xc(%ebp)
  8003af:	ff 75 0c             	pushl  0xc(%ebp)
  8003b2:	ff 75 08             	pushl  0x8(%ebp)
  8003b5:	e8 15 ff ff ff       	call   8002cf <QSort>
  8003ba:	83 c4 10             	add    $0x10,%esp
  8003bd:	eb 01                	jmp    8003c0 <QSort+0xf1>
}


void QSort(int *Elements,int NumOfElements, int startIndex, int finalIndex)
{
	if (startIndex >= finalIndex) return;
  8003bf:	90                   	nop
	QSort(Elements, NumOfElements, startIndex, j - 1);
	QSort(Elements, NumOfElements, i, finalIndex);

	//cprintf("qs,after sorting: start = %d, end = %d\n", startIndex, finalIndex);

}
  8003c0:	c9                   	leave  
  8003c1:	c3                   	ret    

008003c2 <CheckSorted>:

uint32 CheckSorted(int *Elements, int NumOfElements)
{
  8003c2:	55                   	push   %ebp
  8003c3:	89 e5                	mov    %esp,%ebp
  8003c5:	83 ec 10             	sub    $0x10,%esp
	uint32 Sorted = 1 ;
  8003c8:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
	int i ;
	for (i = 0 ; i < NumOfElements - 1; i++)
  8003cf:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  8003d6:	eb 33                	jmp    80040b <CheckSorted+0x49>
	{
		if (Elements[i] > Elements[i+1])
  8003d8:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8003db:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8003e2:	8b 45 08             	mov    0x8(%ebp),%eax
  8003e5:	01 d0                	add    %edx,%eax
  8003e7:	8b 10                	mov    (%eax),%edx
  8003e9:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8003ec:	40                   	inc    %eax
  8003ed:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  8003f4:	8b 45 08             	mov    0x8(%ebp),%eax
  8003f7:	01 c8                	add    %ecx,%eax
  8003f9:	8b 00                	mov    (%eax),%eax
  8003fb:	39 c2                	cmp    %eax,%edx
  8003fd:	7e 09                	jle    800408 <CheckSorted+0x46>
		{
			Sorted = 0 ;
  8003ff:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
			break;
  800406:	eb 0c                	jmp    800414 <CheckSorted+0x52>

uint32 CheckSorted(int *Elements, int NumOfElements)
{
	uint32 Sorted = 1 ;
	int i ;
	for (i = 0 ; i < NumOfElements - 1; i++)
  800408:	ff 45 f8             	incl   -0x8(%ebp)
  80040b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80040e:	48                   	dec    %eax
  80040f:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800412:	7f c4                	jg     8003d8 <CheckSorted+0x16>
		{
			Sorted = 0 ;
			break;
		}
	}
	return Sorted ;
  800414:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800417:	c9                   	leave  
  800418:	c3                   	ret    

00800419 <Swap>:

///Private Functions


void Swap(int *Elements, int First, int Second)
{
  800419:	55                   	push   %ebp
  80041a:	89 e5                	mov    %esp,%ebp
  80041c:	83 ec 10             	sub    $0x10,%esp
	int Tmp = Elements[First] ;
  80041f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800422:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800429:	8b 45 08             	mov    0x8(%ebp),%eax
  80042c:	01 d0                	add    %edx,%eax
  80042e:	8b 00                	mov    (%eax),%eax
  800430:	89 45 fc             	mov    %eax,-0x4(%ebp)
	Elements[First] = Elements[Second] ;
  800433:	8b 45 0c             	mov    0xc(%ebp),%eax
  800436:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80043d:	8b 45 08             	mov    0x8(%ebp),%eax
  800440:	01 c2                	add    %eax,%edx
  800442:	8b 45 10             	mov    0x10(%ebp),%eax
  800445:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  80044c:	8b 45 08             	mov    0x8(%ebp),%eax
  80044f:	01 c8                	add    %ecx,%eax
  800451:	8b 00                	mov    (%eax),%eax
  800453:	89 02                	mov    %eax,(%edx)
	Elements[Second] = Tmp ;
  800455:	8b 45 10             	mov    0x10(%ebp),%eax
  800458:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80045f:	8b 45 08             	mov    0x8(%ebp),%eax
  800462:	01 c2                	add    %eax,%edx
  800464:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800467:	89 02                	mov    %eax,(%edx)
}
  800469:	90                   	nop
  80046a:	c9                   	leave  
  80046b:	c3                   	ret    

0080046c <InitializeAscending>:

void InitializeAscending(int *Elements, int NumOfElements)
{
  80046c:	55                   	push   %ebp
  80046d:	89 e5                	mov    %esp,%ebp
  80046f:	83 ec 10             	sub    $0x10,%esp
	int i ;
	for (i = 0 ; i < NumOfElements ; i++)
  800472:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800479:	eb 17                	jmp    800492 <InitializeAscending+0x26>
	{
		(Elements)[i] = i ;
  80047b:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80047e:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800485:	8b 45 08             	mov    0x8(%ebp),%eax
  800488:	01 c2                	add    %eax,%edx
  80048a:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80048d:	89 02                	mov    %eax,(%edx)
}

void InitializeAscending(int *Elements, int NumOfElements)
{
	int i ;
	for (i = 0 ; i < NumOfElements ; i++)
  80048f:	ff 45 fc             	incl   -0x4(%ebp)
  800492:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800495:	3b 45 0c             	cmp    0xc(%ebp),%eax
  800498:	7c e1                	jl     80047b <InitializeAscending+0xf>
	{
		(Elements)[i] = i ;
	}

}
  80049a:	90                   	nop
  80049b:	c9                   	leave  
  80049c:	c3                   	ret    

0080049d <InitializeDescending>:

void InitializeDescending(int *Elements, int NumOfElements)
{
  80049d:	55                   	push   %ebp
  80049e:	89 e5                	mov    %esp,%ebp
  8004a0:	83 ec 10             	sub    $0x10,%esp
	int i ;
	for (i = 0 ; i < NumOfElements ; i++)
  8004a3:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8004aa:	eb 1b                	jmp    8004c7 <InitializeDescending+0x2a>
	{
		Elements[i] = NumOfElements - i - 1 ;
  8004ac:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8004af:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8004b6:	8b 45 08             	mov    0x8(%ebp),%eax
  8004b9:	01 c2                	add    %eax,%edx
  8004bb:	8b 45 0c             	mov    0xc(%ebp),%eax
  8004be:	2b 45 fc             	sub    -0x4(%ebp),%eax
  8004c1:	48                   	dec    %eax
  8004c2:	89 02                	mov    %eax,(%edx)
}

void InitializeDescending(int *Elements, int NumOfElements)
{
	int i ;
	for (i = 0 ; i < NumOfElements ; i++)
  8004c4:	ff 45 fc             	incl   -0x4(%ebp)
  8004c7:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8004ca:	3b 45 0c             	cmp    0xc(%ebp),%eax
  8004cd:	7c dd                	jl     8004ac <InitializeDescending+0xf>
	{
		Elements[i] = NumOfElements - i - 1 ;
	}

}
  8004cf:	90                   	nop
  8004d0:	c9                   	leave  
  8004d1:	c3                   	ret    

008004d2 <InitializeSemiRandom>:

void InitializeSemiRandom(int *Elements, int NumOfElements)
{
  8004d2:	55                   	push   %ebp
  8004d3:	89 e5                	mov    %esp,%ebp
  8004d5:	83 ec 10             	sub    $0x10,%esp
	int i ;
	int Repetition = NumOfElements / 3 ;
  8004d8:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8004db:	b8 56 55 55 55       	mov    $0x55555556,%eax
  8004e0:	f7 e9                	imul   %ecx
  8004e2:	c1 f9 1f             	sar    $0x1f,%ecx
  8004e5:	89 d0                	mov    %edx,%eax
  8004e7:	29 c8                	sub    %ecx,%eax
  8004e9:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0 ; i < NumOfElements ; i++)
  8004ec:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8004f3:	eb 1e                	jmp    800513 <InitializeSemiRandom+0x41>
	{
		Elements[i] = i % Repetition ;
  8004f5:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8004f8:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8004ff:	8b 45 08             	mov    0x8(%ebp),%eax
  800502:	8d 0c 02             	lea    (%edx,%eax,1),%ecx
  800505:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800508:	99                   	cltd   
  800509:	f7 7d f8             	idivl  -0x8(%ebp)
  80050c:	89 d0                	mov    %edx,%eax
  80050e:	89 01                	mov    %eax,(%ecx)

void InitializeSemiRandom(int *Elements, int NumOfElements)
{
	int i ;
	int Repetition = NumOfElements / 3 ;
	for (i = 0 ; i < NumOfElements ; i++)
  800510:	ff 45 fc             	incl   -0x4(%ebp)
  800513:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800516:	3b 45 0c             	cmp    0xc(%ebp),%eax
  800519:	7c da                	jl     8004f5 <InitializeSemiRandom+0x23>
	{
		Elements[i] = i % Repetition ;
		//	cprintf("i=%d\n",i);
	}

}
  80051b:	90                   	nop
  80051c:	c9                   	leave  
  80051d:	c3                   	ret    

0080051e <PrintElements>:

void PrintElements(int *Elements, int NumOfElements)
{
  80051e:	55                   	push   %ebp
  80051f:	89 e5                	mov    %esp,%ebp
  800521:	83 ec 18             	sub    $0x18,%esp
	int i ;
	int NumsPerLine = 20 ;
  800524:	c7 45 f0 14 00 00 00 	movl   $0x14,-0x10(%ebp)
	for (i = 0 ; i < NumOfElements-1 ; i++)
  80052b:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  800532:	eb 42                	jmp    800576 <PrintElements+0x58>
	{
		if (i%NumsPerLine == 0)
  800534:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800537:	99                   	cltd   
  800538:	f7 7d f0             	idivl  -0x10(%ebp)
  80053b:	89 d0                	mov    %edx,%eax
  80053d:	85 c0                	test   %eax,%eax
  80053f:	75 10                	jne    800551 <PrintElements+0x33>
			cprintf("\n");
  800541:	83 ec 0c             	sub    $0xc,%esp
  800544:	68 e0 37 80 00       	push   $0x8037e0
  800549:	e8 e6 04 00 00       	call   800a34 <cprintf>
  80054e:	83 c4 10             	add    $0x10,%esp
		cprintf("%d, ",Elements[i]);
  800551:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800554:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80055b:	8b 45 08             	mov    0x8(%ebp),%eax
  80055e:	01 d0                	add    %edx,%eax
  800560:	8b 00                	mov    (%eax),%eax
  800562:	83 ec 08             	sub    $0x8,%esp
  800565:	50                   	push   %eax
  800566:	68 b8 39 80 00       	push   $0x8039b8
  80056b:	e8 c4 04 00 00       	call   800a34 <cprintf>
  800570:	83 c4 10             	add    $0x10,%esp

void PrintElements(int *Elements, int NumOfElements)
{
	int i ;
	int NumsPerLine = 20 ;
	for (i = 0 ; i < NumOfElements-1 ; i++)
  800573:	ff 45 f4             	incl   -0xc(%ebp)
  800576:	8b 45 0c             	mov    0xc(%ebp),%eax
  800579:	48                   	dec    %eax
  80057a:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  80057d:	7f b5                	jg     800534 <PrintElements+0x16>
	{
		if (i%NumsPerLine == 0)
			cprintf("\n");
		cprintf("%d, ",Elements[i]);
	}
	cprintf("%d\n",Elements[i]);
  80057f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800582:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800589:	8b 45 08             	mov    0x8(%ebp),%eax
  80058c:	01 d0                	add    %edx,%eax
  80058e:	8b 00                	mov    (%eax),%eax
  800590:	83 ec 08             	sub    $0x8,%esp
  800593:	50                   	push   %eax
  800594:	68 bd 39 80 00       	push   $0x8039bd
  800599:	e8 96 04 00 00       	call   800a34 <cprintf>
  80059e:	83 c4 10             	add    $0x10,%esp

}
  8005a1:	90                   	nop
  8005a2:	c9                   	leave  
  8005a3:	c3                   	ret    

008005a4 <cputchar>:
#include <inc/lib.h>


void
cputchar(int ch)
{
  8005a4:	55                   	push   %ebp
  8005a5:	89 e5                	mov    %esp,%ebp
  8005a7:	83 ec 18             	sub    $0x18,%esp
	char c = ch;
  8005aa:	8b 45 08             	mov    0x8(%ebp),%eax
  8005ad:	88 45 f7             	mov    %al,-0x9(%ebp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	//sys_cputs(&c, 1);

	sys_cputc(c);
  8005b0:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
  8005b4:	83 ec 0c             	sub    $0xc,%esp
  8005b7:	50                   	push   %eax
  8005b8:	e8 3c 1b 00 00       	call   8020f9 <sys_cputc>
  8005bd:	83 c4 10             	add    $0x10,%esp
}
  8005c0:	90                   	nop
  8005c1:	c9                   	leave  
  8005c2:	c3                   	ret    

008005c3 <atomic_cputchar>:


void
atomic_cputchar(int ch)
{
  8005c3:	55                   	push   %ebp
  8005c4:	89 e5                	mov    %esp,%ebp
  8005c6:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  8005c9:	e8 f7 1a 00 00       	call   8020c5 <sys_disable_interrupt>
	char c = ch;
  8005ce:	8b 45 08             	mov    0x8(%ebp),%eax
  8005d1:	88 45 f7             	mov    %al,-0x9(%ebp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	//sys_cputs(&c, 1);

	sys_cputc(c);
  8005d4:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
  8005d8:	83 ec 0c             	sub    $0xc,%esp
  8005db:	50                   	push   %eax
  8005dc:	e8 18 1b 00 00       	call   8020f9 <sys_cputc>
  8005e1:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  8005e4:	e8 f6 1a 00 00       	call   8020df <sys_enable_interrupt>
}
  8005e9:	90                   	nop
  8005ea:	c9                   	leave  
  8005eb:	c3                   	ret    

008005ec <getchar>:

int
getchar(void)
{
  8005ec:	55                   	push   %ebp
  8005ed:	89 e5                	mov    %esp,%ebp
  8005ef:	83 ec 18             	sub    $0x18,%esp

	//return sys_cgetc();
	int c=0;
  8005f2:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	while(c == 0)
  8005f9:	eb 08                	jmp    800603 <getchar+0x17>
	{
		c = sys_cgetc();
  8005fb:	e8 40 19 00 00       	call   801f40 <sys_cgetc>
  800600:	89 45 f4             	mov    %eax,-0xc(%ebp)
getchar(void)
{

	//return sys_cgetc();
	int c=0;
	while(c == 0)
  800603:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  800607:	74 f2                	je     8005fb <getchar+0xf>
	{
		c = sys_cgetc();
	}
	return c;
  800609:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  80060c:	c9                   	leave  
  80060d:	c3                   	ret    

0080060e <atomic_getchar>:

int
atomic_getchar(void)
{
  80060e:	55                   	push   %ebp
  80060f:	89 e5                	mov    %esp,%ebp
  800611:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  800614:	e8 ac 1a 00 00       	call   8020c5 <sys_disable_interrupt>
	int c=0;
  800619:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	while(c == 0)
  800620:	eb 08                	jmp    80062a <atomic_getchar+0x1c>
	{
		c = sys_cgetc();
  800622:	e8 19 19 00 00       	call   801f40 <sys_cgetc>
  800627:	89 45 f4             	mov    %eax,-0xc(%ebp)
int
atomic_getchar(void)
{
	sys_disable_interrupt();
	int c=0;
	while(c == 0)
  80062a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80062e:	74 f2                	je     800622 <atomic_getchar+0x14>
	{
		c = sys_cgetc();
	}
	sys_enable_interrupt();
  800630:	e8 aa 1a 00 00       	call   8020df <sys_enable_interrupt>
	return c;
  800635:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  800638:	c9                   	leave  
  800639:	c3                   	ret    

0080063a <iscons>:

int iscons(int fdnum)
{
  80063a:	55                   	push   %ebp
  80063b:	89 e5                	mov    %esp,%ebp
	// used by readline
	return 1;
  80063d:	b8 01 00 00 00       	mov    $0x1,%eax
}
  800642:	5d                   	pop    %ebp
  800643:	c3                   	ret    

00800644 <libmain>:
volatile struct Env *myEnv = NULL;
volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";

void
libmain(int argc, char **argv)
{
  800644:	55                   	push   %ebp
  800645:	89 e5                	mov    %esp,%ebp
  800647:	83 ec 18             	sub    $0x18,%esp
	int envIndex = sys_getenvindex();
  80064a:	e8 69 1c 00 00       	call   8022b8 <sys_getenvindex>
  80064f:	89 45 f4             	mov    %eax,-0xc(%ebp)
	myEnv = &(envs[envIndex]);
  800652:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800655:	89 d0                	mov    %edx,%eax
  800657:	c1 e0 03             	shl    $0x3,%eax
  80065a:	01 d0                	add    %edx,%eax
  80065c:	01 c0                	add    %eax,%eax
  80065e:	01 d0                	add    %edx,%eax
  800660:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800667:	01 d0                	add    %edx,%eax
  800669:	c1 e0 04             	shl    $0x4,%eax
  80066c:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  800671:	a3 24 50 80 00       	mov    %eax,0x805024

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  800676:	a1 24 50 80 00       	mov    0x805024,%eax
  80067b:	8a 80 5c 05 00 00    	mov    0x55c(%eax),%al
  800681:	84 c0                	test   %al,%al
  800683:	74 0f                	je     800694 <libmain+0x50>
		binaryname = myEnv->prog_name;
  800685:	a1 24 50 80 00       	mov    0x805024,%eax
  80068a:	05 5c 05 00 00       	add    $0x55c,%eax
  80068f:	a3 00 50 80 00       	mov    %eax,0x805000

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800694:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800698:	7e 0a                	jle    8006a4 <libmain+0x60>
		binaryname = argv[0];
  80069a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80069d:	8b 00                	mov    (%eax),%eax
  80069f:	a3 00 50 80 00       	mov    %eax,0x805000

	// call user main routine
	_main(argc, argv);
  8006a4:	83 ec 08             	sub    $0x8,%esp
  8006a7:	ff 75 0c             	pushl  0xc(%ebp)
  8006aa:	ff 75 08             	pushl  0x8(%ebp)
  8006ad:	e8 86 f9 ff ff       	call   800038 <_main>
  8006b2:	83 c4 10             	add    $0x10,%esp



	sys_disable_interrupt();
  8006b5:	e8 0b 1a 00 00       	call   8020c5 <sys_disable_interrupt>
	cprintf("**************************************\n");
  8006ba:	83 ec 0c             	sub    $0xc,%esp
  8006bd:	68 dc 39 80 00       	push   $0x8039dc
  8006c2:	e8 6d 03 00 00       	call   800a34 <cprintf>
  8006c7:	83 c4 10             	add    $0x10,%esp
	cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  8006ca:	a1 24 50 80 00       	mov    0x805024,%eax
  8006cf:	8b 90 44 05 00 00    	mov    0x544(%eax),%edx
  8006d5:	a1 24 50 80 00       	mov    0x805024,%eax
  8006da:	8b 80 34 05 00 00    	mov    0x534(%eax),%eax
  8006e0:	83 ec 04             	sub    $0x4,%esp
  8006e3:	52                   	push   %edx
  8006e4:	50                   	push   %eax
  8006e5:	68 04 3a 80 00       	push   $0x803a04
  8006ea:	e8 45 03 00 00       	call   800a34 <cprintf>
  8006ef:	83 c4 10             	add    $0x10,%esp
	cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  8006f2:	a1 24 50 80 00       	mov    0x805024,%eax
  8006f7:	8b 88 54 05 00 00    	mov    0x554(%eax),%ecx
  8006fd:	a1 24 50 80 00       	mov    0x805024,%eax
  800702:	8b 90 50 05 00 00    	mov    0x550(%eax),%edx
  800708:	a1 24 50 80 00       	mov    0x805024,%eax
  80070d:	8b 80 4c 05 00 00    	mov    0x54c(%eax),%eax
  800713:	51                   	push   %ecx
  800714:	52                   	push   %edx
  800715:	50                   	push   %eax
  800716:	68 2c 3a 80 00       	push   $0x803a2c
  80071b:	e8 14 03 00 00       	call   800a34 <cprintf>
  800720:	83 c4 10             	add    $0x10,%esp
	//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
	cprintf("Num of clocks = %d\n", myEnv->nClocks);
  800723:	a1 24 50 80 00       	mov    0x805024,%eax
  800728:	8b 80 a4 05 00 00    	mov    0x5a4(%eax),%eax
  80072e:	83 ec 08             	sub    $0x8,%esp
  800731:	50                   	push   %eax
  800732:	68 84 3a 80 00       	push   $0x803a84
  800737:	e8 f8 02 00 00       	call   800a34 <cprintf>
  80073c:	83 c4 10             	add    $0x10,%esp
	cprintf("**************************************\n");
  80073f:	83 ec 0c             	sub    $0xc,%esp
  800742:	68 dc 39 80 00       	push   $0x8039dc
  800747:	e8 e8 02 00 00       	call   800a34 <cprintf>
  80074c:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  80074f:	e8 8b 19 00 00       	call   8020df <sys_enable_interrupt>

	// exit gracefully
	exit();
  800754:	e8 19 00 00 00       	call   800772 <exit>
}
  800759:	90                   	nop
  80075a:	c9                   	leave  
  80075b:	c3                   	ret    

0080075c <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  80075c:	55                   	push   %ebp
  80075d:	89 e5                	mov    %esp,%ebp
  80075f:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  800762:	83 ec 0c             	sub    $0xc,%esp
  800765:	6a 00                	push   $0x0
  800767:	e8 18 1b 00 00       	call   802284 <sys_destroy_env>
  80076c:	83 c4 10             	add    $0x10,%esp
}
  80076f:	90                   	nop
  800770:	c9                   	leave  
  800771:	c3                   	ret    

00800772 <exit>:

void
exit(void)
{
  800772:	55                   	push   %ebp
  800773:	89 e5                	mov    %esp,%ebp
  800775:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  800778:	e8 6d 1b 00 00       	call   8022ea <sys_exit_env>
}
  80077d:	90                   	nop
  80077e:	c9                   	leave  
  80077f:	c3                   	ret    

00800780 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  800780:	55                   	push   %ebp
  800781:	89 e5                	mov    %esp,%ebp
  800783:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  800786:	8d 45 10             	lea    0x10(%ebp),%eax
  800789:	83 c0 04             	add    $0x4,%eax
  80078c:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  80078f:	a1 5c 51 80 00       	mov    0x80515c,%eax
  800794:	85 c0                	test   %eax,%eax
  800796:	74 16                	je     8007ae <_panic+0x2e>
		cprintf("%s: ", argv0);
  800798:	a1 5c 51 80 00       	mov    0x80515c,%eax
  80079d:	83 ec 08             	sub    $0x8,%esp
  8007a0:	50                   	push   %eax
  8007a1:	68 98 3a 80 00       	push   $0x803a98
  8007a6:	e8 89 02 00 00       	call   800a34 <cprintf>
  8007ab:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  8007ae:	a1 00 50 80 00       	mov    0x805000,%eax
  8007b3:	ff 75 0c             	pushl  0xc(%ebp)
  8007b6:	ff 75 08             	pushl  0x8(%ebp)
  8007b9:	50                   	push   %eax
  8007ba:	68 9d 3a 80 00       	push   $0x803a9d
  8007bf:	e8 70 02 00 00       	call   800a34 <cprintf>
  8007c4:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  8007c7:	8b 45 10             	mov    0x10(%ebp),%eax
  8007ca:	83 ec 08             	sub    $0x8,%esp
  8007cd:	ff 75 f4             	pushl  -0xc(%ebp)
  8007d0:	50                   	push   %eax
  8007d1:	e8 f3 01 00 00       	call   8009c9 <vcprintf>
  8007d6:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  8007d9:	83 ec 08             	sub    $0x8,%esp
  8007dc:	6a 00                	push   $0x0
  8007de:	68 b9 3a 80 00       	push   $0x803ab9
  8007e3:	e8 e1 01 00 00       	call   8009c9 <vcprintf>
  8007e8:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  8007eb:	e8 82 ff ff ff       	call   800772 <exit>

	// should not return here
	while (1) ;
  8007f0:	eb fe                	jmp    8007f0 <_panic+0x70>

008007f2 <CheckWSWithoutLastIndex>:
}

void CheckWSWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  8007f2:	55                   	push   %ebp
  8007f3:	89 e5                	mov    %esp,%ebp
  8007f5:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  8007f8:	a1 24 50 80 00       	mov    0x805024,%eax
  8007fd:	8b 50 74             	mov    0x74(%eax),%edx
  800800:	8b 45 0c             	mov    0xc(%ebp),%eax
  800803:	39 c2                	cmp    %eax,%edx
  800805:	74 14                	je     80081b <CheckWSWithoutLastIndex+0x29>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  800807:	83 ec 04             	sub    $0x4,%esp
  80080a:	68 bc 3a 80 00       	push   $0x803abc
  80080f:	6a 26                	push   $0x26
  800811:	68 08 3b 80 00       	push   $0x803b08
  800816:	e8 65 ff ff ff       	call   800780 <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  80081b:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  800822:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800829:	e9 c2 00 00 00       	jmp    8008f0 <CheckWSWithoutLastIndex+0xfe>
		if (expectedPages[e] == 0) {
  80082e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800831:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800838:	8b 45 08             	mov    0x8(%ebp),%eax
  80083b:	01 d0                	add    %edx,%eax
  80083d:	8b 00                	mov    (%eax),%eax
  80083f:	85 c0                	test   %eax,%eax
  800841:	75 08                	jne    80084b <CheckWSWithoutLastIndex+0x59>
			expectedNumOfEmptyLocs++;
  800843:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  800846:	e9 a2 00 00 00       	jmp    8008ed <CheckWSWithoutLastIndex+0xfb>
		}
		int found = 0;
  80084b:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800852:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  800859:	eb 69                	jmp    8008c4 <CheckWSWithoutLastIndex+0xd2>
			if (myEnv->__uptr_pws[w].empty == 0) {
  80085b:	a1 24 50 80 00       	mov    0x805024,%eax
  800860:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  800866:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800869:	89 d0                	mov    %edx,%eax
  80086b:	01 c0                	add    %eax,%eax
  80086d:	01 d0                	add    %edx,%eax
  80086f:	c1 e0 03             	shl    $0x3,%eax
  800872:	01 c8                	add    %ecx,%eax
  800874:	8a 40 04             	mov    0x4(%eax),%al
  800877:	84 c0                	test   %al,%al
  800879:	75 46                	jne    8008c1 <CheckWSWithoutLastIndex+0xcf>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  80087b:	a1 24 50 80 00       	mov    0x805024,%eax
  800880:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  800886:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800889:	89 d0                	mov    %edx,%eax
  80088b:	01 c0                	add    %eax,%eax
  80088d:	01 d0                	add    %edx,%eax
  80088f:	c1 e0 03             	shl    $0x3,%eax
  800892:	01 c8                	add    %ecx,%eax
  800894:	8b 00                	mov    (%eax),%eax
  800896:	89 45 dc             	mov    %eax,-0x24(%ebp)
  800899:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80089c:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8008a1:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  8008a3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8008a6:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  8008ad:	8b 45 08             	mov    0x8(%ebp),%eax
  8008b0:	01 c8                	add    %ecx,%eax
  8008b2:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  8008b4:	39 c2                	cmp    %eax,%edx
  8008b6:	75 09                	jne    8008c1 <CheckWSWithoutLastIndex+0xcf>
						== expectedPages[e]) {
					found = 1;
  8008b8:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  8008bf:	eb 12                	jmp    8008d3 <CheckWSWithoutLastIndex+0xe1>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8008c1:	ff 45 e8             	incl   -0x18(%ebp)
  8008c4:	a1 24 50 80 00       	mov    0x805024,%eax
  8008c9:	8b 50 74             	mov    0x74(%eax),%edx
  8008cc:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8008cf:	39 c2                	cmp    %eax,%edx
  8008d1:	77 88                	ja     80085b <CheckWSWithoutLastIndex+0x69>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  8008d3:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8008d7:	75 14                	jne    8008ed <CheckWSWithoutLastIndex+0xfb>
			panic(
  8008d9:	83 ec 04             	sub    $0x4,%esp
  8008dc:	68 14 3b 80 00       	push   $0x803b14
  8008e1:	6a 3a                	push   $0x3a
  8008e3:	68 08 3b 80 00       	push   $0x803b08
  8008e8:	e8 93 fe ff ff       	call   800780 <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  8008ed:	ff 45 f0             	incl   -0x10(%ebp)
  8008f0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8008f3:	3b 45 0c             	cmp    0xc(%ebp),%eax
  8008f6:	0f 8c 32 ff ff ff    	jl     80082e <CheckWSWithoutLastIndex+0x3c>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  8008fc:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800903:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  80090a:	eb 26                	jmp    800932 <CheckWSWithoutLastIndex+0x140>
		if (myEnv->__uptr_pws[w].empty == 1) {
  80090c:	a1 24 50 80 00       	mov    0x805024,%eax
  800911:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  800917:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80091a:	89 d0                	mov    %edx,%eax
  80091c:	01 c0                	add    %eax,%eax
  80091e:	01 d0                	add    %edx,%eax
  800920:	c1 e0 03             	shl    $0x3,%eax
  800923:	01 c8                	add    %ecx,%eax
  800925:	8a 40 04             	mov    0x4(%eax),%al
  800928:	3c 01                	cmp    $0x1,%al
  80092a:	75 03                	jne    80092f <CheckWSWithoutLastIndex+0x13d>
			actualNumOfEmptyLocs++;
  80092c:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  80092f:	ff 45 e0             	incl   -0x20(%ebp)
  800932:	a1 24 50 80 00       	mov    0x805024,%eax
  800937:	8b 50 74             	mov    0x74(%eax),%edx
  80093a:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80093d:	39 c2                	cmp    %eax,%edx
  80093f:	77 cb                	ja     80090c <CheckWSWithoutLastIndex+0x11a>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  800941:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800944:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  800947:	74 14                	je     80095d <CheckWSWithoutLastIndex+0x16b>
		panic(
  800949:	83 ec 04             	sub    $0x4,%esp
  80094c:	68 68 3b 80 00       	push   $0x803b68
  800951:	6a 44                	push   $0x44
  800953:	68 08 3b 80 00       	push   $0x803b08
  800958:	e8 23 fe ff ff       	call   800780 <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  80095d:	90                   	nop
  80095e:	c9                   	leave  
  80095f:	c3                   	ret    

00800960 <putch>:
};

//2017:
uint8 printProgName = 0;

static void putch(int ch, struct printbuf *b) {
  800960:	55                   	push   %ebp
  800961:	89 e5                	mov    %esp,%ebp
  800963:	83 ec 08             	sub    $0x8,%esp
	b->buf[b->idx++] = ch;
  800966:	8b 45 0c             	mov    0xc(%ebp),%eax
  800969:	8b 00                	mov    (%eax),%eax
  80096b:	8d 48 01             	lea    0x1(%eax),%ecx
  80096e:	8b 55 0c             	mov    0xc(%ebp),%edx
  800971:	89 0a                	mov    %ecx,(%edx)
  800973:	8b 55 08             	mov    0x8(%ebp),%edx
  800976:	88 d1                	mov    %dl,%cl
  800978:	8b 55 0c             	mov    0xc(%ebp),%edx
  80097b:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  80097f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800982:	8b 00                	mov    (%eax),%eax
  800984:	3d ff 00 00 00       	cmp    $0xff,%eax
  800989:	75 2c                	jne    8009b7 <putch+0x57>
		sys_cputs(b->buf, b->idx, printProgName);
  80098b:	a0 28 50 80 00       	mov    0x805028,%al
  800990:	0f b6 c0             	movzbl %al,%eax
  800993:	8b 55 0c             	mov    0xc(%ebp),%edx
  800996:	8b 12                	mov    (%edx),%edx
  800998:	89 d1                	mov    %edx,%ecx
  80099a:	8b 55 0c             	mov    0xc(%ebp),%edx
  80099d:	83 c2 08             	add    $0x8,%edx
  8009a0:	83 ec 04             	sub    $0x4,%esp
  8009a3:	50                   	push   %eax
  8009a4:	51                   	push   %ecx
  8009a5:	52                   	push   %edx
  8009a6:	e8 6c 15 00 00       	call   801f17 <sys_cputs>
  8009ab:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  8009ae:	8b 45 0c             	mov    0xc(%ebp),%eax
  8009b1:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  8009b7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8009ba:	8b 40 04             	mov    0x4(%eax),%eax
  8009bd:	8d 50 01             	lea    0x1(%eax),%edx
  8009c0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8009c3:	89 50 04             	mov    %edx,0x4(%eax)
}
  8009c6:	90                   	nop
  8009c7:	c9                   	leave  
  8009c8:	c3                   	ret    

008009c9 <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  8009c9:	55                   	push   %ebp
  8009ca:	89 e5                	mov    %esp,%ebp
  8009cc:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  8009d2:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  8009d9:	00 00 00 
	b.cnt = 0;
  8009dc:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  8009e3:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  8009e6:	ff 75 0c             	pushl  0xc(%ebp)
  8009e9:	ff 75 08             	pushl  0x8(%ebp)
  8009ec:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8009f2:	50                   	push   %eax
  8009f3:	68 60 09 80 00       	push   $0x800960
  8009f8:	e8 11 02 00 00       	call   800c0e <vprintfmt>
  8009fd:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName);
  800a00:	a0 28 50 80 00       	mov    0x805028,%al
  800a05:	0f b6 c0             	movzbl %al,%eax
  800a08:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  800a0e:	83 ec 04             	sub    $0x4,%esp
  800a11:	50                   	push   %eax
  800a12:	52                   	push   %edx
  800a13:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800a19:	83 c0 08             	add    $0x8,%eax
  800a1c:	50                   	push   %eax
  800a1d:	e8 f5 14 00 00       	call   801f17 <sys_cputs>
  800a22:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  800a25:	c6 05 28 50 80 00 00 	movb   $0x0,0x805028
	return b.cnt;
  800a2c:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  800a32:	c9                   	leave  
  800a33:	c3                   	ret    

00800a34 <cprintf>:

int cprintf(const char *fmt, ...) {
  800a34:	55                   	push   %ebp
  800a35:	89 e5                	mov    %esp,%ebp
  800a37:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  800a3a:	c6 05 28 50 80 00 01 	movb   $0x1,0x805028
	va_start(ap, fmt);
  800a41:	8d 45 0c             	lea    0xc(%ebp),%eax
  800a44:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800a47:	8b 45 08             	mov    0x8(%ebp),%eax
  800a4a:	83 ec 08             	sub    $0x8,%esp
  800a4d:	ff 75 f4             	pushl  -0xc(%ebp)
  800a50:	50                   	push   %eax
  800a51:	e8 73 ff ff ff       	call   8009c9 <vcprintf>
  800a56:	83 c4 10             	add    $0x10,%esp
  800a59:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  800a5c:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800a5f:	c9                   	leave  
  800a60:	c3                   	ret    

00800a61 <atomic_cprintf>:

int atomic_cprintf(const char *fmt, ...) {
  800a61:	55                   	push   %ebp
  800a62:	89 e5                	mov    %esp,%ebp
  800a64:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  800a67:	e8 59 16 00 00       	call   8020c5 <sys_disable_interrupt>
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  800a6c:	8d 45 0c             	lea    0xc(%ebp),%eax
  800a6f:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800a72:	8b 45 08             	mov    0x8(%ebp),%eax
  800a75:	83 ec 08             	sub    $0x8,%esp
  800a78:	ff 75 f4             	pushl  -0xc(%ebp)
  800a7b:	50                   	push   %eax
  800a7c:	e8 48 ff ff ff       	call   8009c9 <vcprintf>
  800a81:	83 c4 10             	add    $0x10,%esp
  800a84:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	sys_enable_interrupt();
  800a87:	e8 53 16 00 00       	call   8020df <sys_enable_interrupt>
	return cnt;
  800a8c:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800a8f:	c9                   	leave  
  800a90:	c3                   	ret    

00800a91 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800a91:	55                   	push   %ebp
  800a92:	89 e5                	mov    %esp,%ebp
  800a94:	53                   	push   %ebx
  800a95:	83 ec 14             	sub    $0x14,%esp
  800a98:	8b 45 10             	mov    0x10(%ebp),%eax
  800a9b:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800a9e:	8b 45 14             	mov    0x14(%ebp),%eax
  800aa1:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800aa4:	8b 45 18             	mov    0x18(%ebp),%eax
  800aa7:	ba 00 00 00 00       	mov    $0x0,%edx
  800aac:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800aaf:	77 55                	ja     800b06 <printnum+0x75>
  800ab1:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800ab4:	72 05                	jb     800abb <printnum+0x2a>
  800ab6:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800ab9:	77 4b                	ja     800b06 <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800abb:	8b 45 1c             	mov    0x1c(%ebp),%eax
  800abe:	8d 58 ff             	lea    -0x1(%eax),%ebx
  800ac1:	8b 45 18             	mov    0x18(%ebp),%eax
  800ac4:	ba 00 00 00 00       	mov    $0x0,%edx
  800ac9:	52                   	push   %edx
  800aca:	50                   	push   %eax
  800acb:	ff 75 f4             	pushl  -0xc(%ebp)
  800ace:	ff 75 f0             	pushl  -0x10(%ebp)
  800ad1:	e8 8a 2a 00 00       	call   803560 <__udivdi3>
  800ad6:	83 c4 10             	add    $0x10,%esp
  800ad9:	83 ec 04             	sub    $0x4,%esp
  800adc:	ff 75 20             	pushl  0x20(%ebp)
  800adf:	53                   	push   %ebx
  800ae0:	ff 75 18             	pushl  0x18(%ebp)
  800ae3:	52                   	push   %edx
  800ae4:	50                   	push   %eax
  800ae5:	ff 75 0c             	pushl  0xc(%ebp)
  800ae8:	ff 75 08             	pushl  0x8(%ebp)
  800aeb:	e8 a1 ff ff ff       	call   800a91 <printnum>
  800af0:	83 c4 20             	add    $0x20,%esp
  800af3:	eb 1a                	jmp    800b0f <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800af5:	83 ec 08             	sub    $0x8,%esp
  800af8:	ff 75 0c             	pushl  0xc(%ebp)
  800afb:	ff 75 20             	pushl  0x20(%ebp)
  800afe:	8b 45 08             	mov    0x8(%ebp),%eax
  800b01:	ff d0                	call   *%eax
  800b03:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800b06:	ff 4d 1c             	decl   0x1c(%ebp)
  800b09:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  800b0d:	7f e6                	jg     800af5 <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800b0f:	8b 4d 18             	mov    0x18(%ebp),%ecx
  800b12:	bb 00 00 00 00       	mov    $0x0,%ebx
  800b17:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800b1a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800b1d:	53                   	push   %ebx
  800b1e:	51                   	push   %ecx
  800b1f:	52                   	push   %edx
  800b20:	50                   	push   %eax
  800b21:	e8 4a 2b 00 00       	call   803670 <__umoddi3>
  800b26:	83 c4 10             	add    $0x10,%esp
  800b29:	05 d4 3d 80 00       	add    $0x803dd4,%eax
  800b2e:	8a 00                	mov    (%eax),%al
  800b30:	0f be c0             	movsbl %al,%eax
  800b33:	83 ec 08             	sub    $0x8,%esp
  800b36:	ff 75 0c             	pushl  0xc(%ebp)
  800b39:	50                   	push   %eax
  800b3a:	8b 45 08             	mov    0x8(%ebp),%eax
  800b3d:	ff d0                	call   *%eax
  800b3f:	83 c4 10             	add    $0x10,%esp
}
  800b42:	90                   	nop
  800b43:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800b46:	c9                   	leave  
  800b47:	c3                   	ret    

00800b48 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  800b48:	55                   	push   %ebp
  800b49:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800b4b:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800b4f:	7e 1c                	jle    800b6d <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  800b51:	8b 45 08             	mov    0x8(%ebp),%eax
  800b54:	8b 00                	mov    (%eax),%eax
  800b56:	8d 50 08             	lea    0x8(%eax),%edx
  800b59:	8b 45 08             	mov    0x8(%ebp),%eax
  800b5c:	89 10                	mov    %edx,(%eax)
  800b5e:	8b 45 08             	mov    0x8(%ebp),%eax
  800b61:	8b 00                	mov    (%eax),%eax
  800b63:	83 e8 08             	sub    $0x8,%eax
  800b66:	8b 50 04             	mov    0x4(%eax),%edx
  800b69:	8b 00                	mov    (%eax),%eax
  800b6b:	eb 40                	jmp    800bad <getuint+0x65>
	else if (lflag)
  800b6d:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800b71:	74 1e                	je     800b91 <getuint+0x49>
		return va_arg(*ap, unsigned long);
  800b73:	8b 45 08             	mov    0x8(%ebp),%eax
  800b76:	8b 00                	mov    (%eax),%eax
  800b78:	8d 50 04             	lea    0x4(%eax),%edx
  800b7b:	8b 45 08             	mov    0x8(%ebp),%eax
  800b7e:	89 10                	mov    %edx,(%eax)
  800b80:	8b 45 08             	mov    0x8(%ebp),%eax
  800b83:	8b 00                	mov    (%eax),%eax
  800b85:	83 e8 04             	sub    $0x4,%eax
  800b88:	8b 00                	mov    (%eax),%eax
  800b8a:	ba 00 00 00 00       	mov    $0x0,%edx
  800b8f:	eb 1c                	jmp    800bad <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  800b91:	8b 45 08             	mov    0x8(%ebp),%eax
  800b94:	8b 00                	mov    (%eax),%eax
  800b96:	8d 50 04             	lea    0x4(%eax),%edx
  800b99:	8b 45 08             	mov    0x8(%ebp),%eax
  800b9c:	89 10                	mov    %edx,(%eax)
  800b9e:	8b 45 08             	mov    0x8(%ebp),%eax
  800ba1:	8b 00                	mov    (%eax),%eax
  800ba3:	83 e8 04             	sub    $0x4,%eax
  800ba6:	8b 00                	mov    (%eax),%eax
  800ba8:	ba 00 00 00 00       	mov    $0x0,%edx
}
  800bad:	5d                   	pop    %ebp
  800bae:	c3                   	ret    

00800baf <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  800baf:	55                   	push   %ebp
  800bb0:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800bb2:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800bb6:	7e 1c                	jle    800bd4 <getint+0x25>
		return va_arg(*ap, long long);
  800bb8:	8b 45 08             	mov    0x8(%ebp),%eax
  800bbb:	8b 00                	mov    (%eax),%eax
  800bbd:	8d 50 08             	lea    0x8(%eax),%edx
  800bc0:	8b 45 08             	mov    0x8(%ebp),%eax
  800bc3:	89 10                	mov    %edx,(%eax)
  800bc5:	8b 45 08             	mov    0x8(%ebp),%eax
  800bc8:	8b 00                	mov    (%eax),%eax
  800bca:	83 e8 08             	sub    $0x8,%eax
  800bcd:	8b 50 04             	mov    0x4(%eax),%edx
  800bd0:	8b 00                	mov    (%eax),%eax
  800bd2:	eb 38                	jmp    800c0c <getint+0x5d>
	else if (lflag)
  800bd4:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800bd8:	74 1a                	je     800bf4 <getint+0x45>
		return va_arg(*ap, long);
  800bda:	8b 45 08             	mov    0x8(%ebp),%eax
  800bdd:	8b 00                	mov    (%eax),%eax
  800bdf:	8d 50 04             	lea    0x4(%eax),%edx
  800be2:	8b 45 08             	mov    0x8(%ebp),%eax
  800be5:	89 10                	mov    %edx,(%eax)
  800be7:	8b 45 08             	mov    0x8(%ebp),%eax
  800bea:	8b 00                	mov    (%eax),%eax
  800bec:	83 e8 04             	sub    $0x4,%eax
  800bef:	8b 00                	mov    (%eax),%eax
  800bf1:	99                   	cltd   
  800bf2:	eb 18                	jmp    800c0c <getint+0x5d>
	else
		return va_arg(*ap, int);
  800bf4:	8b 45 08             	mov    0x8(%ebp),%eax
  800bf7:	8b 00                	mov    (%eax),%eax
  800bf9:	8d 50 04             	lea    0x4(%eax),%edx
  800bfc:	8b 45 08             	mov    0x8(%ebp),%eax
  800bff:	89 10                	mov    %edx,(%eax)
  800c01:	8b 45 08             	mov    0x8(%ebp),%eax
  800c04:	8b 00                	mov    (%eax),%eax
  800c06:	83 e8 04             	sub    $0x4,%eax
  800c09:	8b 00                	mov    (%eax),%eax
  800c0b:	99                   	cltd   
}
  800c0c:	5d                   	pop    %ebp
  800c0d:	c3                   	ret    

00800c0e <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  800c0e:	55                   	push   %ebp
  800c0f:	89 e5                	mov    %esp,%ebp
  800c11:	56                   	push   %esi
  800c12:	53                   	push   %ebx
  800c13:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800c16:	eb 17                	jmp    800c2f <vprintfmt+0x21>
			if (ch == '\0')
  800c18:	85 db                	test   %ebx,%ebx
  800c1a:	0f 84 af 03 00 00    	je     800fcf <vprintfmt+0x3c1>
				return;
			putch(ch, putdat);
  800c20:	83 ec 08             	sub    $0x8,%esp
  800c23:	ff 75 0c             	pushl  0xc(%ebp)
  800c26:	53                   	push   %ebx
  800c27:	8b 45 08             	mov    0x8(%ebp),%eax
  800c2a:	ff d0                	call   *%eax
  800c2c:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800c2f:	8b 45 10             	mov    0x10(%ebp),%eax
  800c32:	8d 50 01             	lea    0x1(%eax),%edx
  800c35:	89 55 10             	mov    %edx,0x10(%ebp)
  800c38:	8a 00                	mov    (%eax),%al
  800c3a:	0f b6 d8             	movzbl %al,%ebx
  800c3d:	83 fb 25             	cmp    $0x25,%ebx
  800c40:	75 d6                	jne    800c18 <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  800c42:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  800c46:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  800c4d:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  800c54:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  800c5b:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800c62:	8b 45 10             	mov    0x10(%ebp),%eax
  800c65:	8d 50 01             	lea    0x1(%eax),%edx
  800c68:	89 55 10             	mov    %edx,0x10(%ebp)
  800c6b:	8a 00                	mov    (%eax),%al
  800c6d:	0f b6 d8             	movzbl %al,%ebx
  800c70:	8d 43 dd             	lea    -0x23(%ebx),%eax
  800c73:	83 f8 55             	cmp    $0x55,%eax
  800c76:	0f 87 2b 03 00 00    	ja     800fa7 <vprintfmt+0x399>
  800c7c:	8b 04 85 f8 3d 80 00 	mov    0x803df8(,%eax,4),%eax
  800c83:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  800c85:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  800c89:	eb d7                	jmp    800c62 <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800c8b:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  800c8f:	eb d1                	jmp    800c62 <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800c91:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  800c98:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800c9b:	89 d0                	mov    %edx,%eax
  800c9d:	c1 e0 02             	shl    $0x2,%eax
  800ca0:	01 d0                	add    %edx,%eax
  800ca2:	01 c0                	add    %eax,%eax
  800ca4:	01 d8                	add    %ebx,%eax
  800ca6:	83 e8 30             	sub    $0x30,%eax
  800ca9:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  800cac:	8b 45 10             	mov    0x10(%ebp),%eax
  800caf:	8a 00                	mov    (%eax),%al
  800cb1:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  800cb4:	83 fb 2f             	cmp    $0x2f,%ebx
  800cb7:	7e 3e                	jle    800cf7 <vprintfmt+0xe9>
  800cb9:	83 fb 39             	cmp    $0x39,%ebx
  800cbc:	7f 39                	jg     800cf7 <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800cbe:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800cc1:	eb d5                	jmp    800c98 <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  800cc3:	8b 45 14             	mov    0x14(%ebp),%eax
  800cc6:	83 c0 04             	add    $0x4,%eax
  800cc9:	89 45 14             	mov    %eax,0x14(%ebp)
  800ccc:	8b 45 14             	mov    0x14(%ebp),%eax
  800ccf:	83 e8 04             	sub    $0x4,%eax
  800cd2:	8b 00                	mov    (%eax),%eax
  800cd4:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  800cd7:	eb 1f                	jmp    800cf8 <vprintfmt+0xea>

		case '.':
			if (width < 0)
  800cd9:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800cdd:	79 83                	jns    800c62 <vprintfmt+0x54>
				width = 0;
  800cdf:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  800ce6:	e9 77 ff ff ff       	jmp    800c62 <vprintfmt+0x54>

		case '#':
			altflag = 1;
  800ceb:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  800cf2:	e9 6b ff ff ff       	jmp    800c62 <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  800cf7:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  800cf8:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800cfc:	0f 89 60 ff ff ff    	jns    800c62 <vprintfmt+0x54>
				width = precision, precision = -1;
  800d02:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800d05:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800d08:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  800d0f:	e9 4e ff ff ff       	jmp    800c62 <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  800d14:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  800d17:	e9 46 ff ff ff       	jmp    800c62 <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  800d1c:	8b 45 14             	mov    0x14(%ebp),%eax
  800d1f:	83 c0 04             	add    $0x4,%eax
  800d22:	89 45 14             	mov    %eax,0x14(%ebp)
  800d25:	8b 45 14             	mov    0x14(%ebp),%eax
  800d28:	83 e8 04             	sub    $0x4,%eax
  800d2b:	8b 00                	mov    (%eax),%eax
  800d2d:	83 ec 08             	sub    $0x8,%esp
  800d30:	ff 75 0c             	pushl  0xc(%ebp)
  800d33:	50                   	push   %eax
  800d34:	8b 45 08             	mov    0x8(%ebp),%eax
  800d37:	ff d0                	call   *%eax
  800d39:	83 c4 10             	add    $0x10,%esp
			break;
  800d3c:	e9 89 02 00 00       	jmp    800fca <vprintfmt+0x3bc>

		// error message
		case 'e':
			err = va_arg(ap, int);
  800d41:	8b 45 14             	mov    0x14(%ebp),%eax
  800d44:	83 c0 04             	add    $0x4,%eax
  800d47:	89 45 14             	mov    %eax,0x14(%ebp)
  800d4a:	8b 45 14             	mov    0x14(%ebp),%eax
  800d4d:	83 e8 04             	sub    $0x4,%eax
  800d50:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  800d52:	85 db                	test   %ebx,%ebx
  800d54:	79 02                	jns    800d58 <vprintfmt+0x14a>
				err = -err;
  800d56:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  800d58:	83 fb 64             	cmp    $0x64,%ebx
  800d5b:	7f 0b                	jg     800d68 <vprintfmt+0x15a>
  800d5d:	8b 34 9d 40 3c 80 00 	mov    0x803c40(,%ebx,4),%esi
  800d64:	85 f6                	test   %esi,%esi
  800d66:	75 19                	jne    800d81 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  800d68:	53                   	push   %ebx
  800d69:	68 e5 3d 80 00       	push   $0x803de5
  800d6e:	ff 75 0c             	pushl  0xc(%ebp)
  800d71:	ff 75 08             	pushl  0x8(%ebp)
  800d74:	e8 5e 02 00 00       	call   800fd7 <printfmt>
  800d79:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800d7c:	e9 49 02 00 00       	jmp    800fca <vprintfmt+0x3bc>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800d81:	56                   	push   %esi
  800d82:	68 ee 3d 80 00       	push   $0x803dee
  800d87:	ff 75 0c             	pushl  0xc(%ebp)
  800d8a:	ff 75 08             	pushl  0x8(%ebp)
  800d8d:	e8 45 02 00 00       	call   800fd7 <printfmt>
  800d92:	83 c4 10             	add    $0x10,%esp
			break;
  800d95:	e9 30 02 00 00       	jmp    800fca <vprintfmt+0x3bc>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  800d9a:	8b 45 14             	mov    0x14(%ebp),%eax
  800d9d:	83 c0 04             	add    $0x4,%eax
  800da0:	89 45 14             	mov    %eax,0x14(%ebp)
  800da3:	8b 45 14             	mov    0x14(%ebp),%eax
  800da6:	83 e8 04             	sub    $0x4,%eax
  800da9:	8b 30                	mov    (%eax),%esi
  800dab:	85 f6                	test   %esi,%esi
  800dad:	75 05                	jne    800db4 <vprintfmt+0x1a6>
				p = "(null)";
  800daf:	be f1 3d 80 00       	mov    $0x803df1,%esi
			if (width > 0 && padc != '-')
  800db4:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800db8:	7e 6d                	jle    800e27 <vprintfmt+0x219>
  800dba:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  800dbe:	74 67                	je     800e27 <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  800dc0:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800dc3:	83 ec 08             	sub    $0x8,%esp
  800dc6:	50                   	push   %eax
  800dc7:	56                   	push   %esi
  800dc8:	e8 12 05 00 00       	call   8012df <strnlen>
  800dcd:	83 c4 10             	add    $0x10,%esp
  800dd0:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  800dd3:	eb 16                	jmp    800deb <vprintfmt+0x1dd>
					putch(padc, putdat);
  800dd5:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  800dd9:	83 ec 08             	sub    $0x8,%esp
  800ddc:	ff 75 0c             	pushl  0xc(%ebp)
  800ddf:	50                   	push   %eax
  800de0:	8b 45 08             	mov    0x8(%ebp),%eax
  800de3:	ff d0                	call   *%eax
  800de5:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800de8:	ff 4d e4             	decl   -0x1c(%ebp)
  800deb:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800def:	7f e4                	jg     800dd5 <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800df1:	eb 34                	jmp    800e27 <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  800df3:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800df7:	74 1c                	je     800e15 <vprintfmt+0x207>
  800df9:	83 fb 1f             	cmp    $0x1f,%ebx
  800dfc:	7e 05                	jle    800e03 <vprintfmt+0x1f5>
  800dfe:	83 fb 7e             	cmp    $0x7e,%ebx
  800e01:	7e 12                	jle    800e15 <vprintfmt+0x207>
					putch('?', putdat);
  800e03:	83 ec 08             	sub    $0x8,%esp
  800e06:	ff 75 0c             	pushl  0xc(%ebp)
  800e09:	6a 3f                	push   $0x3f
  800e0b:	8b 45 08             	mov    0x8(%ebp),%eax
  800e0e:	ff d0                	call   *%eax
  800e10:	83 c4 10             	add    $0x10,%esp
  800e13:	eb 0f                	jmp    800e24 <vprintfmt+0x216>
				else
					putch(ch, putdat);
  800e15:	83 ec 08             	sub    $0x8,%esp
  800e18:	ff 75 0c             	pushl  0xc(%ebp)
  800e1b:	53                   	push   %ebx
  800e1c:	8b 45 08             	mov    0x8(%ebp),%eax
  800e1f:	ff d0                	call   *%eax
  800e21:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800e24:	ff 4d e4             	decl   -0x1c(%ebp)
  800e27:	89 f0                	mov    %esi,%eax
  800e29:	8d 70 01             	lea    0x1(%eax),%esi
  800e2c:	8a 00                	mov    (%eax),%al
  800e2e:	0f be d8             	movsbl %al,%ebx
  800e31:	85 db                	test   %ebx,%ebx
  800e33:	74 24                	je     800e59 <vprintfmt+0x24b>
  800e35:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800e39:	78 b8                	js     800df3 <vprintfmt+0x1e5>
  800e3b:	ff 4d e0             	decl   -0x20(%ebp)
  800e3e:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800e42:	79 af                	jns    800df3 <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800e44:	eb 13                	jmp    800e59 <vprintfmt+0x24b>
				putch(' ', putdat);
  800e46:	83 ec 08             	sub    $0x8,%esp
  800e49:	ff 75 0c             	pushl  0xc(%ebp)
  800e4c:	6a 20                	push   $0x20
  800e4e:	8b 45 08             	mov    0x8(%ebp),%eax
  800e51:	ff d0                	call   *%eax
  800e53:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800e56:	ff 4d e4             	decl   -0x1c(%ebp)
  800e59:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800e5d:	7f e7                	jg     800e46 <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  800e5f:	e9 66 01 00 00       	jmp    800fca <vprintfmt+0x3bc>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  800e64:	83 ec 08             	sub    $0x8,%esp
  800e67:	ff 75 e8             	pushl  -0x18(%ebp)
  800e6a:	8d 45 14             	lea    0x14(%ebp),%eax
  800e6d:	50                   	push   %eax
  800e6e:	e8 3c fd ff ff       	call   800baf <getint>
  800e73:	83 c4 10             	add    $0x10,%esp
  800e76:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800e79:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  800e7c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800e7f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800e82:	85 d2                	test   %edx,%edx
  800e84:	79 23                	jns    800ea9 <vprintfmt+0x29b>
				putch('-', putdat);
  800e86:	83 ec 08             	sub    $0x8,%esp
  800e89:	ff 75 0c             	pushl  0xc(%ebp)
  800e8c:	6a 2d                	push   $0x2d
  800e8e:	8b 45 08             	mov    0x8(%ebp),%eax
  800e91:	ff d0                	call   *%eax
  800e93:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  800e96:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800e99:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800e9c:	f7 d8                	neg    %eax
  800e9e:	83 d2 00             	adc    $0x0,%edx
  800ea1:	f7 da                	neg    %edx
  800ea3:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800ea6:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  800ea9:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800eb0:	e9 bc 00 00 00       	jmp    800f71 <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  800eb5:	83 ec 08             	sub    $0x8,%esp
  800eb8:	ff 75 e8             	pushl  -0x18(%ebp)
  800ebb:	8d 45 14             	lea    0x14(%ebp),%eax
  800ebe:	50                   	push   %eax
  800ebf:	e8 84 fc ff ff       	call   800b48 <getuint>
  800ec4:	83 c4 10             	add    $0x10,%esp
  800ec7:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800eca:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  800ecd:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800ed4:	e9 98 00 00 00       	jmp    800f71 <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  800ed9:	83 ec 08             	sub    $0x8,%esp
  800edc:	ff 75 0c             	pushl  0xc(%ebp)
  800edf:	6a 58                	push   $0x58
  800ee1:	8b 45 08             	mov    0x8(%ebp),%eax
  800ee4:	ff d0                	call   *%eax
  800ee6:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800ee9:	83 ec 08             	sub    $0x8,%esp
  800eec:	ff 75 0c             	pushl  0xc(%ebp)
  800eef:	6a 58                	push   $0x58
  800ef1:	8b 45 08             	mov    0x8(%ebp),%eax
  800ef4:	ff d0                	call   *%eax
  800ef6:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800ef9:	83 ec 08             	sub    $0x8,%esp
  800efc:	ff 75 0c             	pushl  0xc(%ebp)
  800eff:	6a 58                	push   $0x58
  800f01:	8b 45 08             	mov    0x8(%ebp),%eax
  800f04:	ff d0                	call   *%eax
  800f06:	83 c4 10             	add    $0x10,%esp
			break;
  800f09:	e9 bc 00 00 00       	jmp    800fca <vprintfmt+0x3bc>

		// pointer
		case 'p':
			putch('0', putdat);
  800f0e:	83 ec 08             	sub    $0x8,%esp
  800f11:	ff 75 0c             	pushl  0xc(%ebp)
  800f14:	6a 30                	push   $0x30
  800f16:	8b 45 08             	mov    0x8(%ebp),%eax
  800f19:	ff d0                	call   *%eax
  800f1b:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  800f1e:	83 ec 08             	sub    $0x8,%esp
  800f21:	ff 75 0c             	pushl  0xc(%ebp)
  800f24:	6a 78                	push   $0x78
  800f26:	8b 45 08             	mov    0x8(%ebp),%eax
  800f29:	ff d0                	call   *%eax
  800f2b:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  800f2e:	8b 45 14             	mov    0x14(%ebp),%eax
  800f31:	83 c0 04             	add    $0x4,%eax
  800f34:	89 45 14             	mov    %eax,0x14(%ebp)
  800f37:	8b 45 14             	mov    0x14(%ebp),%eax
  800f3a:	83 e8 04             	sub    $0x4,%eax
  800f3d:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800f3f:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800f42:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  800f49:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  800f50:	eb 1f                	jmp    800f71 <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800f52:	83 ec 08             	sub    $0x8,%esp
  800f55:	ff 75 e8             	pushl  -0x18(%ebp)
  800f58:	8d 45 14             	lea    0x14(%ebp),%eax
  800f5b:	50                   	push   %eax
  800f5c:	e8 e7 fb ff ff       	call   800b48 <getuint>
  800f61:	83 c4 10             	add    $0x10,%esp
  800f64:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800f67:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  800f6a:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800f71:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  800f75:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800f78:	83 ec 04             	sub    $0x4,%esp
  800f7b:	52                   	push   %edx
  800f7c:	ff 75 e4             	pushl  -0x1c(%ebp)
  800f7f:	50                   	push   %eax
  800f80:	ff 75 f4             	pushl  -0xc(%ebp)
  800f83:	ff 75 f0             	pushl  -0x10(%ebp)
  800f86:	ff 75 0c             	pushl  0xc(%ebp)
  800f89:	ff 75 08             	pushl  0x8(%ebp)
  800f8c:	e8 00 fb ff ff       	call   800a91 <printnum>
  800f91:	83 c4 20             	add    $0x20,%esp
			break;
  800f94:	eb 34                	jmp    800fca <vprintfmt+0x3bc>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  800f96:	83 ec 08             	sub    $0x8,%esp
  800f99:	ff 75 0c             	pushl  0xc(%ebp)
  800f9c:	53                   	push   %ebx
  800f9d:	8b 45 08             	mov    0x8(%ebp),%eax
  800fa0:	ff d0                	call   *%eax
  800fa2:	83 c4 10             	add    $0x10,%esp
			break;
  800fa5:	eb 23                	jmp    800fca <vprintfmt+0x3bc>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800fa7:	83 ec 08             	sub    $0x8,%esp
  800faa:	ff 75 0c             	pushl  0xc(%ebp)
  800fad:	6a 25                	push   $0x25
  800faf:	8b 45 08             	mov    0x8(%ebp),%eax
  800fb2:	ff d0                	call   *%eax
  800fb4:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  800fb7:	ff 4d 10             	decl   0x10(%ebp)
  800fba:	eb 03                	jmp    800fbf <vprintfmt+0x3b1>
  800fbc:	ff 4d 10             	decl   0x10(%ebp)
  800fbf:	8b 45 10             	mov    0x10(%ebp),%eax
  800fc2:	48                   	dec    %eax
  800fc3:	8a 00                	mov    (%eax),%al
  800fc5:	3c 25                	cmp    $0x25,%al
  800fc7:	75 f3                	jne    800fbc <vprintfmt+0x3ae>
				/* do nothing */;
			break;
  800fc9:	90                   	nop
		}
	}
  800fca:	e9 47 fc ff ff       	jmp    800c16 <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  800fcf:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  800fd0:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800fd3:	5b                   	pop    %ebx
  800fd4:	5e                   	pop    %esi
  800fd5:	5d                   	pop    %ebp
  800fd6:	c3                   	ret    

00800fd7 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800fd7:	55                   	push   %ebp
  800fd8:	89 e5                	mov    %esp,%ebp
  800fda:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  800fdd:	8d 45 10             	lea    0x10(%ebp),%eax
  800fe0:	83 c0 04             	add    $0x4,%eax
  800fe3:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  800fe6:	8b 45 10             	mov    0x10(%ebp),%eax
  800fe9:	ff 75 f4             	pushl  -0xc(%ebp)
  800fec:	50                   	push   %eax
  800fed:	ff 75 0c             	pushl  0xc(%ebp)
  800ff0:	ff 75 08             	pushl  0x8(%ebp)
  800ff3:	e8 16 fc ff ff       	call   800c0e <vprintfmt>
  800ff8:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  800ffb:	90                   	nop
  800ffc:	c9                   	leave  
  800ffd:	c3                   	ret    

00800ffe <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800ffe:	55                   	push   %ebp
  800fff:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  801001:	8b 45 0c             	mov    0xc(%ebp),%eax
  801004:	8b 40 08             	mov    0x8(%eax),%eax
  801007:	8d 50 01             	lea    0x1(%eax),%edx
  80100a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80100d:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  801010:	8b 45 0c             	mov    0xc(%ebp),%eax
  801013:	8b 10                	mov    (%eax),%edx
  801015:	8b 45 0c             	mov    0xc(%ebp),%eax
  801018:	8b 40 04             	mov    0x4(%eax),%eax
  80101b:	39 c2                	cmp    %eax,%edx
  80101d:	73 12                	jae    801031 <sprintputch+0x33>
		*b->buf++ = ch;
  80101f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801022:	8b 00                	mov    (%eax),%eax
  801024:	8d 48 01             	lea    0x1(%eax),%ecx
  801027:	8b 55 0c             	mov    0xc(%ebp),%edx
  80102a:	89 0a                	mov    %ecx,(%edx)
  80102c:	8b 55 08             	mov    0x8(%ebp),%edx
  80102f:	88 10                	mov    %dl,(%eax)
}
  801031:	90                   	nop
  801032:	5d                   	pop    %ebp
  801033:	c3                   	ret    

00801034 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  801034:	55                   	push   %ebp
  801035:	89 e5                	mov    %esp,%ebp
  801037:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  80103a:	8b 45 08             	mov    0x8(%ebp),%eax
  80103d:	89 45 ec             	mov    %eax,-0x14(%ebp)
  801040:	8b 45 0c             	mov    0xc(%ebp),%eax
  801043:	8d 50 ff             	lea    -0x1(%eax),%edx
  801046:	8b 45 08             	mov    0x8(%ebp),%eax
  801049:	01 d0                	add    %edx,%eax
  80104b:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80104e:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  801055:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801059:	74 06                	je     801061 <vsnprintf+0x2d>
  80105b:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80105f:	7f 07                	jg     801068 <vsnprintf+0x34>
		return -E_INVAL;
  801061:	b8 03 00 00 00       	mov    $0x3,%eax
  801066:	eb 20                	jmp    801088 <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  801068:	ff 75 14             	pushl  0x14(%ebp)
  80106b:	ff 75 10             	pushl  0x10(%ebp)
  80106e:	8d 45 ec             	lea    -0x14(%ebp),%eax
  801071:	50                   	push   %eax
  801072:	68 fe 0f 80 00       	push   $0x800ffe
  801077:	e8 92 fb ff ff       	call   800c0e <vprintfmt>
  80107c:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  80107f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801082:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  801085:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  801088:	c9                   	leave  
  801089:	c3                   	ret    

0080108a <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  80108a:	55                   	push   %ebp
  80108b:	89 e5                	mov    %esp,%ebp
  80108d:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  801090:	8d 45 10             	lea    0x10(%ebp),%eax
  801093:	83 c0 04             	add    $0x4,%eax
  801096:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  801099:	8b 45 10             	mov    0x10(%ebp),%eax
  80109c:	ff 75 f4             	pushl  -0xc(%ebp)
  80109f:	50                   	push   %eax
  8010a0:	ff 75 0c             	pushl  0xc(%ebp)
  8010a3:	ff 75 08             	pushl  0x8(%ebp)
  8010a6:	e8 89 ff ff ff       	call   801034 <vsnprintf>
  8010ab:	83 c4 10             	add    $0x10,%esp
  8010ae:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  8010b1:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8010b4:	c9                   	leave  
  8010b5:	c3                   	ret    

008010b6 <readline>:
#include <inc/lib.h>

//static char buf[BUFLEN];

void readline(const char *prompt, char* buf)
{
  8010b6:	55                   	push   %ebp
  8010b7:	89 e5                	mov    %esp,%ebp
  8010b9:	83 ec 18             	sub    $0x18,%esp
		int i, c, echoing;

	if (prompt != NULL)
  8010bc:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8010c0:	74 13                	je     8010d5 <readline+0x1f>
		cprintf("%s", prompt);
  8010c2:	83 ec 08             	sub    $0x8,%esp
  8010c5:	ff 75 08             	pushl  0x8(%ebp)
  8010c8:	68 50 3f 80 00       	push   $0x803f50
  8010cd:	e8 62 f9 ff ff       	call   800a34 <cprintf>
  8010d2:	83 c4 10             	add    $0x10,%esp

	i = 0;
  8010d5:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	echoing = iscons(0);
  8010dc:	83 ec 0c             	sub    $0xc,%esp
  8010df:	6a 00                	push   $0x0
  8010e1:	e8 54 f5 ff ff       	call   80063a <iscons>
  8010e6:	83 c4 10             	add    $0x10,%esp
  8010e9:	89 45 f0             	mov    %eax,-0x10(%ebp)
	while (1) {
		c = getchar();
  8010ec:	e8 fb f4 ff ff       	call   8005ec <getchar>
  8010f1:	89 45 ec             	mov    %eax,-0x14(%ebp)
		if (c < 0) {
  8010f4:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8010f8:	79 22                	jns    80111c <readline+0x66>
			if (c != -E_EOF)
  8010fa:	83 7d ec 07          	cmpl   $0x7,-0x14(%ebp)
  8010fe:	0f 84 ad 00 00 00    	je     8011b1 <readline+0xfb>
				cprintf("read error: %e\n", c);
  801104:	83 ec 08             	sub    $0x8,%esp
  801107:	ff 75 ec             	pushl  -0x14(%ebp)
  80110a:	68 53 3f 80 00       	push   $0x803f53
  80110f:	e8 20 f9 ff ff       	call   800a34 <cprintf>
  801114:	83 c4 10             	add    $0x10,%esp
			return;
  801117:	e9 95 00 00 00       	jmp    8011b1 <readline+0xfb>
		} else if (c >= ' ' && i < BUFLEN-1) {
  80111c:	83 7d ec 1f          	cmpl   $0x1f,-0x14(%ebp)
  801120:	7e 34                	jle    801156 <readline+0xa0>
  801122:	81 7d f4 fe 03 00 00 	cmpl   $0x3fe,-0xc(%ebp)
  801129:	7f 2b                	jg     801156 <readline+0xa0>
			if (echoing)
  80112b:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80112f:	74 0e                	je     80113f <readline+0x89>
				cputchar(c);
  801131:	83 ec 0c             	sub    $0xc,%esp
  801134:	ff 75 ec             	pushl  -0x14(%ebp)
  801137:	e8 68 f4 ff ff       	call   8005a4 <cputchar>
  80113c:	83 c4 10             	add    $0x10,%esp
			buf[i++] = c;
  80113f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801142:	8d 50 01             	lea    0x1(%eax),%edx
  801145:	89 55 f4             	mov    %edx,-0xc(%ebp)
  801148:	89 c2                	mov    %eax,%edx
  80114a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80114d:	01 d0                	add    %edx,%eax
  80114f:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801152:	88 10                	mov    %dl,(%eax)
  801154:	eb 56                	jmp    8011ac <readline+0xf6>
		} else if (c == '\b' && i > 0) {
  801156:	83 7d ec 08          	cmpl   $0x8,-0x14(%ebp)
  80115a:	75 1f                	jne    80117b <readline+0xc5>
  80115c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801160:	7e 19                	jle    80117b <readline+0xc5>
			if (echoing)
  801162:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801166:	74 0e                	je     801176 <readline+0xc0>
				cputchar(c);
  801168:	83 ec 0c             	sub    $0xc,%esp
  80116b:	ff 75 ec             	pushl  -0x14(%ebp)
  80116e:	e8 31 f4 ff ff       	call   8005a4 <cputchar>
  801173:	83 c4 10             	add    $0x10,%esp

			i--;
  801176:	ff 4d f4             	decl   -0xc(%ebp)
  801179:	eb 31                	jmp    8011ac <readline+0xf6>
		} else if (c == '\n' || c == '\r') {
  80117b:	83 7d ec 0a          	cmpl   $0xa,-0x14(%ebp)
  80117f:	74 0a                	je     80118b <readline+0xd5>
  801181:	83 7d ec 0d          	cmpl   $0xd,-0x14(%ebp)
  801185:	0f 85 61 ff ff ff    	jne    8010ec <readline+0x36>
			if (echoing)
  80118b:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80118f:	74 0e                	je     80119f <readline+0xe9>
				cputchar(c);
  801191:	83 ec 0c             	sub    $0xc,%esp
  801194:	ff 75 ec             	pushl  -0x14(%ebp)
  801197:	e8 08 f4 ff ff       	call   8005a4 <cputchar>
  80119c:	83 c4 10             	add    $0x10,%esp

			buf[i] = 0;
  80119f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8011a2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011a5:	01 d0                	add    %edx,%eax
  8011a7:	c6 00 00             	movb   $0x0,(%eax)
			return;
  8011aa:	eb 06                	jmp    8011b2 <readline+0xfc>
		}
	}
  8011ac:	e9 3b ff ff ff       	jmp    8010ec <readline+0x36>
	while (1) {
		c = getchar();
		if (c < 0) {
			if (c != -E_EOF)
				cprintf("read error: %e\n", c);
			return;
  8011b1:	90                   	nop
			buf[i] = 0;
			return;
		}
	}

}
  8011b2:	c9                   	leave  
  8011b3:	c3                   	ret    

008011b4 <atomic_readline>:

void atomic_readline(const char *prompt, char* buf)
{
  8011b4:	55                   	push   %ebp
  8011b5:	89 e5                	mov    %esp,%ebp
  8011b7:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  8011ba:	e8 06 0f 00 00       	call   8020c5 <sys_disable_interrupt>
	int i, c, echoing;

	if (prompt != NULL)
  8011bf:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8011c3:	74 13                	je     8011d8 <atomic_readline+0x24>
		cprintf("%s", prompt);
  8011c5:	83 ec 08             	sub    $0x8,%esp
  8011c8:	ff 75 08             	pushl  0x8(%ebp)
  8011cb:	68 50 3f 80 00       	push   $0x803f50
  8011d0:	e8 5f f8 ff ff       	call   800a34 <cprintf>
  8011d5:	83 c4 10             	add    $0x10,%esp

	i = 0;
  8011d8:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	echoing = iscons(0);
  8011df:	83 ec 0c             	sub    $0xc,%esp
  8011e2:	6a 00                	push   $0x0
  8011e4:	e8 51 f4 ff ff       	call   80063a <iscons>
  8011e9:	83 c4 10             	add    $0x10,%esp
  8011ec:	89 45 f0             	mov    %eax,-0x10(%ebp)
	while (1) {
		c = getchar();
  8011ef:	e8 f8 f3 ff ff       	call   8005ec <getchar>
  8011f4:	89 45 ec             	mov    %eax,-0x14(%ebp)
		if (c < 0) {
  8011f7:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8011fb:	79 23                	jns    801220 <atomic_readline+0x6c>
			if (c != -E_EOF)
  8011fd:	83 7d ec 07          	cmpl   $0x7,-0x14(%ebp)
  801201:	74 13                	je     801216 <atomic_readline+0x62>
				cprintf("read error: %e\n", c);
  801203:	83 ec 08             	sub    $0x8,%esp
  801206:	ff 75 ec             	pushl  -0x14(%ebp)
  801209:	68 53 3f 80 00       	push   $0x803f53
  80120e:	e8 21 f8 ff ff       	call   800a34 <cprintf>
  801213:	83 c4 10             	add    $0x10,%esp
			sys_enable_interrupt();
  801216:	e8 c4 0e 00 00       	call   8020df <sys_enable_interrupt>
			return;
  80121b:	e9 9a 00 00 00       	jmp    8012ba <atomic_readline+0x106>
		} else if (c >= ' ' && i < BUFLEN-1) {
  801220:	83 7d ec 1f          	cmpl   $0x1f,-0x14(%ebp)
  801224:	7e 34                	jle    80125a <atomic_readline+0xa6>
  801226:	81 7d f4 fe 03 00 00 	cmpl   $0x3fe,-0xc(%ebp)
  80122d:	7f 2b                	jg     80125a <atomic_readline+0xa6>
			if (echoing)
  80122f:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801233:	74 0e                	je     801243 <atomic_readline+0x8f>
				cputchar(c);
  801235:	83 ec 0c             	sub    $0xc,%esp
  801238:	ff 75 ec             	pushl  -0x14(%ebp)
  80123b:	e8 64 f3 ff ff       	call   8005a4 <cputchar>
  801240:	83 c4 10             	add    $0x10,%esp
			buf[i++] = c;
  801243:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801246:	8d 50 01             	lea    0x1(%eax),%edx
  801249:	89 55 f4             	mov    %edx,-0xc(%ebp)
  80124c:	89 c2                	mov    %eax,%edx
  80124e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801251:	01 d0                	add    %edx,%eax
  801253:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801256:	88 10                	mov    %dl,(%eax)
  801258:	eb 5b                	jmp    8012b5 <atomic_readline+0x101>
		} else if (c == '\b' && i > 0) {
  80125a:	83 7d ec 08          	cmpl   $0x8,-0x14(%ebp)
  80125e:	75 1f                	jne    80127f <atomic_readline+0xcb>
  801260:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801264:	7e 19                	jle    80127f <atomic_readline+0xcb>
			if (echoing)
  801266:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80126a:	74 0e                	je     80127a <atomic_readline+0xc6>
				cputchar(c);
  80126c:	83 ec 0c             	sub    $0xc,%esp
  80126f:	ff 75 ec             	pushl  -0x14(%ebp)
  801272:	e8 2d f3 ff ff       	call   8005a4 <cputchar>
  801277:	83 c4 10             	add    $0x10,%esp
			i--;
  80127a:	ff 4d f4             	decl   -0xc(%ebp)
  80127d:	eb 36                	jmp    8012b5 <atomic_readline+0x101>
		} else if (c == '\n' || c == '\r') {
  80127f:	83 7d ec 0a          	cmpl   $0xa,-0x14(%ebp)
  801283:	74 0a                	je     80128f <atomic_readline+0xdb>
  801285:	83 7d ec 0d          	cmpl   $0xd,-0x14(%ebp)
  801289:	0f 85 60 ff ff ff    	jne    8011ef <atomic_readline+0x3b>
			if (echoing)
  80128f:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801293:	74 0e                	je     8012a3 <atomic_readline+0xef>
				cputchar(c);
  801295:	83 ec 0c             	sub    $0xc,%esp
  801298:	ff 75 ec             	pushl  -0x14(%ebp)
  80129b:	e8 04 f3 ff ff       	call   8005a4 <cputchar>
  8012a0:	83 c4 10             	add    $0x10,%esp
			buf[i] = 0;
  8012a3:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8012a6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012a9:	01 d0                	add    %edx,%eax
  8012ab:	c6 00 00             	movb   $0x0,(%eax)
			sys_enable_interrupt();
  8012ae:	e8 2c 0e 00 00       	call   8020df <sys_enable_interrupt>
			return;
  8012b3:	eb 05                	jmp    8012ba <atomic_readline+0x106>
		}
	}
  8012b5:	e9 35 ff ff ff       	jmp    8011ef <atomic_readline+0x3b>
}
  8012ba:	c9                   	leave  
  8012bb:	c3                   	ret    

008012bc <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  8012bc:	55                   	push   %ebp
  8012bd:	89 e5                	mov    %esp,%ebp
  8012bf:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  8012c2:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8012c9:	eb 06                	jmp    8012d1 <strlen+0x15>
		n++;
  8012cb:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  8012ce:	ff 45 08             	incl   0x8(%ebp)
  8012d1:	8b 45 08             	mov    0x8(%ebp),%eax
  8012d4:	8a 00                	mov    (%eax),%al
  8012d6:	84 c0                	test   %al,%al
  8012d8:	75 f1                	jne    8012cb <strlen+0xf>
		n++;
	return n;
  8012da:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  8012dd:	c9                   	leave  
  8012de:	c3                   	ret    

008012df <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  8012df:	55                   	push   %ebp
  8012e0:	89 e5                	mov    %esp,%ebp
  8012e2:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8012e5:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8012ec:	eb 09                	jmp    8012f7 <strnlen+0x18>
		n++;
  8012ee:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8012f1:	ff 45 08             	incl   0x8(%ebp)
  8012f4:	ff 4d 0c             	decl   0xc(%ebp)
  8012f7:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8012fb:	74 09                	je     801306 <strnlen+0x27>
  8012fd:	8b 45 08             	mov    0x8(%ebp),%eax
  801300:	8a 00                	mov    (%eax),%al
  801302:	84 c0                	test   %al,%al
  801304:	75 e8                	jne    8012ee <strnlen+0xf>
		n++;
	return n;
  801306:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  801309:	c9                   	leave  
  80130a:	c3                   	ret    

0080130b <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  80130b:	55                   	push   %ebp
  80130c:	89 e5                	mov    %esp,%ebp
  80130e:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  801311:	8b 45 08             	mov    0x8(%ebp),%eax
  801314:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  801317:	90                   	nop
  801318:	8b 45 08             	mov    0x8(%ebp),%eax
  80131b:	8d 50 01             	lea    0x1(%eax),%edx
  80131e:	89 55 08             	mov    %edx,0x8(%ebp)
  801321:	8b 55 0c             	mov    0xc(%ebp),%edx
  801324:	8d 4a 01             	lea    0x1(%edx),%ecx
  801327:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  80132a:	8a 12                	mov    (%edx),%dl
  80132c:	88 10                	mov    %dl,(%eax)
  80132e:	8a 00                	mov    (%eax),%al
  801330:	84 c0                	test   %al,%al
  801332:	75 e4                	jne    801318 <strcpy+0xd>
		/* do nothing */;
	return ret;
  801334:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  801337:	c9                   	leave  
  801338:	c3                   	ret    

00801339 <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  801339:	55                   	push   %ebp
  80133a:	89 e5                	mov    %esp,%ebp
  80133c:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  80133f:	8b 45 08             	mov    0x8(%ebp),%eax
  801342:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  801345:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  80134c:	eb 1f                	jmp    80136d <strncpy+0x34>
		*dst++ = *src;
  80134e:	8b 45 08             	mov    0x8(%ebp),%eax
  801351:	8d 50 01             	lea    0x1(%eax),%edx
  801354:	89 55 08             	mov    %edx,0x8(%ebp)
  801357:	8b 55 0c             	mov    0xc(%ebp),%edx
  80135a:	8a 12                	mov    (%edx),%dl
  80135c:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  80135e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801361:	8a 00                	mov    (%eax),%al
  801363:	84 c0                	test   %al,%al
  801365:	74 03                	je     80136a <strncpy+0x31>
			src++;
  801367:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  80136a:	ff 45 fc             	incl   -0x4(%ebp)
  80136d:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801370:	3b 45 10             	cmp    0x10(%ebp),%eax
  801373:	72 d9                	jb     80134e <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  801375:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  801378:	c9                   	leave  
  801379:	c3                   	ret    

0080137a <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  80137a:	55                   	push   %ebp
  80137b:	89 e5                	mov    %esp,%ebp
  80137d:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  801380:	8b 45 08             	mov    0x8(%ebp),%eax
  801383:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  801386:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80138a:	74 30                	je     8013bc <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  80138c:	eb 16                	jmp    8013a4 <strlcpy+0x2a>
			*dst++ = *src++;
  80138e:	8b 45 08             	mov    0x8(%ebp),%eax
  801391:	8d 50 01             	lea    0x1(%eax),%edx
  801394:	89 55 08             	mov    %edx,0x8(%ebp)
  801397:	8b 55 0c             	mov    0xc(%ebp),%edx
  80139a:	8d 4a 01             	lea    0x1(%edx),%ecx
  80139d:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  8013a0:	8a 12                	mov    (%edx),%dl
  8013a2:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  8013a4:	ff 4d 10             	decl   0x10(%ebp)
  8013a7:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8013ab:	74 09                	je     8013b6 <strlcpy+0x3c>
  8013ad:	8b 45 0c             	mov    0xc(%ebp),%eax
  8013b0:	8a 00                	mov    (%eax),%al
  8013b2:	84 c0                	test   %al,%al
  8013b4:	75 d8                	jne    80138e <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  8013b6:	8b 45 08             	mov    0x8(%ebp),%eax
  8013b9:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  8013bc:	8b 55 08             	mov    0x8(%ebp),%edx
  8013bf:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8013c2:	29 c2                	sub    %eax,%edx
  8013c4:	89 d0                	mov    %edx,%eax
}
  8013c6:	c9                   	leave  
  8013c7:	c3                   	ret    

008013c8 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  8013c8:	55                   	push   %ebp
  8013c9:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  8013cb:	eb 06                	jmp    8013d3 <strcmp+0xb>
		p++, q++;
  8013cd:	ff 45 08             	incl   0x8(%ebp)
  8013d0:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  8013d3:	8b 45 08             	mov    0x8(%ebp),%eax
  8013d6:	8a 00                	mov    (%eax),%al
  8013d8:	84 c0                	test   %al,%al
  8013da:	74 0e                	je     8013ea <strcmp+0x22>
  8013dc:	8b 45 08             	mov    0x8(%ebp),%eax
  8013df:	8a 10                	mov    (%eax),%dl
  8013e1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8013e4:	8a 00                	mov    (%eax),%al
  8013e6:	38 c2                	cmp    %al,%dl
  8013e8:	74 e3                	je     8013cd <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  8013ea:	8b 45 08             	mov    0x8(%ebp),%eax
  8013ed:	8a 00                	mov    (%eax),%al
  8013ef:	0f b6 d0             	movzbl %al,%edx
  8013f2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8013f5:	8a 00                	mov    (%eax),%al
  8013f7:	0f b6 c0             	movzbl %al,%eax
  8013fa:	29 c2                	sub    %eax,%edx
  8013fc:	89 d0                	mov    %edx,%eax
}
  8013fe:	5d                   	pop    %ebp
  8013ff:	c3                   	ret    

00801400 <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  801400:	55                   	push   %ebp
  801401:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  801403:	eb 09                	jmp    80140e <strncmp+0xe>
		n--, p++, q++;
  801405:	ff 4d 10             	decl   0x10(%ebp)
  801408:	ff 45 08             	incl   0x8(%ebp)
  80140b:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  80140e:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801412:	74 17                	je     80142b <strncmp+0x2b>
  801414:	8b 45 08             	mov    0x8(%ebp),%eax
  801417:	8a 00                	mov    (%eax),%al
  801419:	84 c0                	test   %al,%al
  80141b:	74 0e                	je     80142b <strncmp+0x2b>
  80141d:	8b 45 08             	mov    0x8(%ebp),%eax
  801420:	8a 10                	mov    (%eax),%dl
  801422:	8b 45 0c             	mov    0xc(%ebp),%eax
  801425:	8a 00                	mov    (%eax),%al
  801427:	38 c2                	cmp    %al,%dl
  801429:	74 da                	je     801405 <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  80142b:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80142f:	75 07                	jne    801438 <strncmp+0x38>
		return 0;
  801431:	b8 00 00 00 00       	mov    $0x0,%eax
  801436:	eb 14                	jmp    80144c <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  801438:	8b 45 08             	mov    0x8(%ebp),%eax
  80143b:	8a 00                	mov    (%eax),%al
  80143d:	0f b6 d0             	movzbl %al,%edx
  801440:	8b 45 0c             	mov    0xc(%ebp),%eax
  801443:	8a 00                	mov    (%eax),%al
  801445:	0f b6 c0             	movzbl %al,%eax
  801448:	29 c2                	sub    %eax,%edx
  80144a:	89 d0                	mov    %edx,%eax
}
  80144c:	5d                   	pop    %ebp
  80144d:	c3                   	ret    

0080144e <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  80144e:	55                   	push   %ebp
  80144f:	89 e5                	mov    %esp,%ebp
  801451:	83 ec 04             	sub    $0x4,%esp
  801454:	8b 45 0c             	mov    0xc(%ebp),%eax
  801457:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  80145a:	eb 12                	jmp    80146e <strchr+0x20>
		if (*s == c)
  80145c:	8b 45 08             	mov    0x8(%ebp),%eax
  80145f:	8a 00                	mov    (%eax),%al
  801461:	3a 45 fc             	cmp    -0x4(%ebp),%al
  801464:	75 05                	jne    80146b <strchr+0x1d>
			return (char *) s;
  801466:	8b 45 08             	mov    0x8(%ebp),%eax
  801469:	eb 11                	jmp    80147c <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  80146b:	ff 45 08             	incl   0x8(%ebp)
  80146e:	8b 45 08             	mov    0x8(%ebp),%eax
  801471:	8a 00                	mov    (%eax),%al
  801473:	84 c0                	test   %al,%al
  801475:	75 e5                	jne    80145c <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  801477:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80147c:	c9                   	leave  
  80147d:	c3                   	ret    

0080147e <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  80147e:	55                   	push   %ebp
  80147f:	89 e5                	mov    %esp,%ebp
  801481:	83 ec 04             	sub    $0x4,%esp
  801484:	8b 45 0c             	mov    0xc(%ebp),%eax
  801487:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  80148a:	eb 0d                	jmp    801499 <strfind+0x1b>
		if (*s == c)
  80148c:	8b 45 08             	mov    0x8(%ebp),%eax
  80148f:	8a 00                	mov    (%eax),%al
  801491:	3a 45 fc             	cmp    -0x4(%ebp),%al
  801494:	74 0e                	je     8014a4 <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  801496:	ff 45 08             	incl   0x8(%ebp)
  801499:	8b 45 08             	mov    0x8(%ebp),%eax
  80149c:	8a 00                	mov    (%eax),%al
  80149e:	84 c0                	test   %al,%al
  8014a0:	75 ea                	jne    80148c <strfind+0xe>
  8014a2:	eb 01                	jmp    8014a5 <strfind+0x27>
		if (*s == c)
			break;
  8014a4:	90                   	nop
	return (char *) s;
  8014a5:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8014a8:	c9                   	leave  
  8014a9:	c3                   	ret    

008014aa <memset>:


void *
memset(void *v, int c, uint32 n)
{
  8014aa:	55                   	push   %ebp
  8014ab:	89 e5                	mov    %esp,%ebp
  8014ad:	83 ec 10             	sub    $0x10,%esp
	char *p;
	int m;

	p = v;
  8014b0:	8b 45 08             	mov    0x8(%ebp),%eax
  8014b3:	89 45 fc             	mov    %eax,-0x4(%ebp)
	m = n;
  8014b6:	8b 45 10             	mov    0x10(%ebp),%eax
  8014b9:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (--m >= 0)
  8014bc:	eb 0e                	jmp    8014cc <memset+0x22>
		*p++ = c;
  8014be:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8014c1:	8d 50 01             	lea    0x1(%eax),%edx
  8014c4:	89 55 fc             	mov    %edx,-0x4(%ebp)
  8014c7:	8b 55 0c             	mov    0xc(%ebp),%edx
  8014ca:	88 10                	mov    %dl,(%eax)
	char *p;
	int m;

	p = v;
	m = n;
	while (--m >= 0)
  8014cc:	ff 4d f8             	decl   -0x8(%ebp)
  8014cf:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  8014d3:	79 e9                	jns    8014be <memset+0x14>
		*p++ = c;

	return v;
  8014d5:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8014d8:	c9                   	leave  
  8014d9:	c3                   	ret    

008014da <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  8014da:	55                   	push   %ebp
  8014db:	89 e5                	mov    %esp,%ebp
  8014dd:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  8014e0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8014e3:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  8014e6:	8b 45 08             	mov    0x8(%ebp),%eax
  8014e9:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (n-- > 0)
  8014ec:	eb 16                	jmp    801504 <memcpy+0x2a>
		*d++ = *s++;
  8014ee:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8014f1:	8d 50 01             	lea    0x1(%eax),%edx
  8014f4:	89 55 f8             	mov    %edx,-0x8(%ebp)
  8014f7:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8014fa:	8d 4a 01             	lea    0x1(%edx),%ecx
  8014fd:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  801500:	8a 12                	mov    (%edx),%dl
  801502:	88 10                	mov    %dl,(%eax)
	const char *s;
	char *d;

	s = src;
	d = dst;
	while (n-- > 0)
  801504:	8b 45 10             	mov    0x10(%ebp),%eax
  801507:	8d 50 ff             	lea    -0x1(%eax),%edx
  80150a:	89 55 10             	mov    %edx,0x10(%ebp)
  80150d:	85 c0                	test   %eax,%eax
  80150f:	75 dd                	jne    8014ee <memcpy+0x14>
		*d++ = *s++;

	return dst;
  801511:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801514:	c9                   	leave  
  801515:	c3                   	ret    

00801516 <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  801516:	55                   	push   %ebp
  801517:	89 e5                	mov    %esp,%ebp
  801519:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  80151c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80151f:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  801522:	8b 45 08             	mov    0x8(%ebp),%eax
  801525:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  801528:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80152b:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  80152e:	73 50                	jae    801580 <memmove+0x6a>
  801530:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801533:	8b 45 10             	mov    0x10(%ebp),%eax
  801536:	01 d0                	add    %edx,%eax
  801538:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  80153b:	76 43                	jbe    801580 <memmove+0x6a>
		s += n;
  80153d:	8b 45 10             	mov    0x10(%ebp),%eax
  801540:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  801543:	8b 45 10             	mov    0x10(%ebp),%eax
  801546:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  801549:	eb 10                	jmp    80155b <memmove+0x45>
			*--d = *--s;
  80154b:	ff 4d f8             	decl   -0x8(%ebp)
  80154e:	ff 4d fc             	decl   -0x4(%ebp)
  801551:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801554:	8a 10                	mov    (%eax),%dl
  801556:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801559:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  80155b:	8b 45 10             	mov    0x10(%ebp),%eax
  80155e:	8d 50 ff             	lea    -0x1(%eax),%edx
  801561:	89 55 10             	mov    %edx,0x10(%ebp)
  801564:	85 c0                	test   %eax,%eax
  801566:	75 e3                	jne    80154b <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  801568:	eb 23                	jmp    80158d <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  80156a:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80156d:	8d 50 01             	lea    0x1(%eax),%edx
  801570:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801573:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801576:	8d 4a 01             	lea    0x1(%edx),%ecx
  801579:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  80157c:	8a 12                	mov    (%edx),%dl
  80157e:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  801580:	8b 45 10             	mov    0x10(%ebp),%eax
  801583:	8d 50 ff             	lea    -0x1(%eax),%edx
  801586:	89 55 10             	mov    %edx,0x10(%ebp)
  801589:	85 c0                	test   %eax,%eax
  80158b:	75 dd                	jne    80156a <memmove+0x54>
			*d++ = *s++;

	return dst;
  80158d:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801590:	c9                   	leave  
  801591:	c3                   	ret    

00801592 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  801592:	55                   	push   %ebp
  801593:	89 e5                	mov    %esp,%ebp
  801595:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  801598:	8b 45 08             	mov    0x8(%ebp),%eax
  80159b:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  80159e:	8b 45 0c             	mov    0xc(%ebp),%eax
  8015a1:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  8015a4:	eb 2a                	jmp    8015d0 <memcmp+0x3e>
		if (*s1 != *s2)
  8015a6:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8015a9:	8a 10                	mov    (%eax),%dl
  8015ab:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8015ae:	8a 00                	mov    (%eax),%al
  8015b0:	38 c2                	cmp    %al,%dl
  8015b2:	74 16                	je     8015ca <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  8015b4:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8015b7:	8a 00                	mov    (%eax),%al
  8015b9:	0f b6 d0             	movzbl %al,%edx
  8015bc:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8015bf:	8a 00                	mov    (%eax),%al
  8015c1:	0f b6 c0             	movzbl %al,%eax
  8015c4:	29 c2                	sub    %eax,%edx
  8015c6:	89 d0                	mov    %edx,%eax
  8015c8:	eb 18                	jmp    8015e2 <memcmp+0x50>
		s1++, s2++;
  8015ca:	ff 45 fc             	incl   -0x4(%ebp)
  8015cd:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  8015d0:	8b 45 10             	mov    0x10(%ebp),%eax
  8015d3:	8d 50 ff             	lea    -0x1(%eax),%edx
  8015d6:	89 55 10             	mov    %edx,0x10(%ebp)
  8015d9:	85 c0                	test   %eax,%eax
  8015db:	75 c9                	jne    8015a6 <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  8015dd:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8015e2:	c9                   	leave  
  8015e3:	c3                   	ret    

008015e4 <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  8015e4:	55                   	push   %ebp
  8015e5:	89 e5                	mov    %esp,%ebp
  8015e7:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  8015ea:	8b 55 08             	mov    0x8(%ebp),%edx
  8015ed:	8b 45 10             	mov    0x10(%ebp),%eax
  8015f0:	01 d0                	add    %edx,%eax
  8015f2:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  8015f5:	eb 15                	jmp    80160c <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  8015f7:	8b 45 08             	mov    0x8(%ebp),%eax
  8015fa:	8a 00                	mov    (%eax),%al
  8015fc:	0f b6 d0             	movzbl %al,%edx
  8015ff:	8b 45 0c             	mov    0xc(%ebp),%eax
  801602:	0f b6 c0             	movzbl %al,%eax
  801605:	39 c2                	cmp    %eax,%edx
  801607:	74 0d                	je     801616 <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  801609:	ff 45 08             	incl   0x8(%ebp)
  80160c:	8b 45 08             	mov    0x8(%ebp),%eax
  80160f:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  801612:	72 e3                	jb     8015f7 <memfind+0x13>
  801614:	eb 01                	jmp    801617 <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  801616:	90                   	nop
	return (void *) s;
  801617:	8b 45 08             	mov    0x8(%ebp),%eax
}
  80161a:	c9                   	leave  
  80161b:	c3                   	ret    

0080161c <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  80161c:	55                   	push   %ebp
  80161d:	89 e5                	mov    %esp,%ebp
  80161f:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  801622:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  801629:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801630:	eb 03                	jmp    801635 <strtol+0x19>
		s++;
  801632:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801635:	8b 45 08             	mov    0x8(%ebp),%eax
  801638:	8a 00                	mov    (%eax),%al
  80163a:	3c 20                	cmp    $0x20,%al
  80163c:	74 f4                	je     801632 <strtol+0x16>
  80163e:	8b 45 08             	mov    0x8(%ebp),%eax
  801641:	8a 00                	mov    (%eax),%al
  801643:	3c 09                	cmp    $0x9,%al
  801645:	74 eb                	je     801632 <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  801647:	8b 45 08             	mov    0x8(%ebp),%eax
  80164a:	8a 00                	mov    (%eax),%al
  80164c:	3c 2b                	cmp    $0x2b,%al
  80164e:	75 05                	jne    801655 <strtol+0x39>
		s++;
  801650:	ff 45 08             	incl   0x8(%ebp)
  801653:	eb 13                	jmp    801668 <strtol+0x4c>
	else if (*s == '-')
  801655:	8b 45 08             	mov    0x8(%ebp),%eax
  801658:	8a 00                	mov    (%eax),%al
  80165a:	3c 2d                	cmp    $0x2d,%al
  80165c:	75 0a                	jne    801668 <strtol+0x4c>
		s++, neg = 1;
  80165e:	ff 45 08             	incl   0x8(%ebp)
  801661:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  801668:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80166c:	74 06                	je     801674 <strtol+0x58>
  80166e:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  801672:	75 20                	jne    801694 <strtol+0x78>
  801674:	8b 45 08             	mov    0x8(%ebp),%eax
  801677:	8a 00                	mov    (%eax),%al
  801679:	3c 30                	cmp    $0x30,%al
  80167b:	75 17                	jne    801694 <strtol+0x78>
  80167d:	8b 45 08             	mov    0x8(%ebp),%eax
  801680:	40                   	inc    %eax
  801681:	8a 00                	mov    (%eax),%al
  801683:	3c 78                	cmp    $0x78,%al
  801685:	75 0d                	jne    801694 <strtol+0x78>
		s += 2, base = 16;
  801687:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  80168b:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  801692:	eb 28                	jmp    8016bc <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  801694:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801698:	75 15                	jne    8016af <strtol+0x93>
  80169a:	8b 45 08             	mov    0x8(%ebp),%eax
  80169d:	8a 00                	mov    (%eax),%al
  80169f:	3c 30                	cmp    $0x30,%al
  8016a1:	75 0c                	jne    8016af <strtol+0x93>
		s++, base = 8;
  8016a3:	ff 45 08             	incl   0x8(%ebp)
  8016a6:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  8016ad:	eb 0d                	jmp    8016bc <strtol+0xa0>
	else if (base == 0)
  8016af:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8016b3:	75 07                	jne    8016bc <strtol+0xa0>
		base = 10;
  8016b5:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  8016bc:	8b 45 08             	mov    0x8(%ebp),%eax
  8016bf:	8a 00                	mov    (%eax),%al
  8016c1:	3c 2f                	cmp    $0x2f,%al
  8016c3:	7e 19                	jle    8016de <strtol+0xc2>
  8016c5:	8b 45 08             	mov    0x8(%ebp),%eax
  8016c8:	8a 00                	mov    (%eax),%al
  8016ca:	3c 39                	cmp    $0x39,%al
  8016cc:	7f 10                	jg     8016de <strtol+0xc2>
			dig = *s - '0';
  8016ce:	8b 45 08             	mov    0x8(%ebp),%eax
  8016d1:	8a 00                	mov    (%eax),%al
  8016d3:	0f be c0             	movsbl %al,%eax
  8016d6:	83 e8 30             	sub    $0x30,%eax
  8016d9:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8016dc:	eb 42                	jmp    801720 <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  8016de:	8b 45 08             	mov    0x8(%ebp),%eax
  8016e1:	8a 00                	mov    (%eax),%al
  8016e3:	3c 60                	cmp    $0x60,%al
  8016e5:	7e 19                	jle    801700 <strtol+0xe4>
  8016e7:	8b 45 08             	mov    0x8(%ebp),%eax
  8016ea:	8a 00                	mov    (%eax),%al
  8016ec:	3c 7a                	cmp    $0x7a,%al
  8016ee:	7f 10                	jg     801700 <strtol+0xe4>
			dig = *s - 'a' + 10;
  8016f0:	8b 45 08             	mov    0x8(%ebp),%eax
  8016f3:	8a 00                	mov    (%eax),%al
  8016f5:	0f be c0             	movsbl %al,%eax
  8016f8:	83 e8 57             	sub    $0x57,%eax
  8016fb:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8016fe:	eb 20                	jmp    801720 <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  801700:	8b 45 08             	mov    0x8(%ebp),%eax
  801703:	8a 00                	mov    (%eax),%al
  801705:	3c 40                	cmp    $0x40,%al
  801707:	7e 39                	jle    801742 <strtol+0x126>
  801709:	8b 45 08             	mov    0x8(%ebp),%eax
  80170c:	8a 00                	mov    (%eax),%al
  80170e:	3c 5a                	cmp    $0x5a,%al
  801710:	7f 30                	jg     801742 <strtol+0x126>
			dig = *s - 'A' + 10;
  801712:	8b 45 08             	mov    0x8(%ebp),%eax
  801715:	8a 00                	mov    (%eax),%al
  801717:	0f be c0             	movsbl %al,%eax
  80171a:	83 e8 37             	sub    $0x37,%eax
  80171d:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  801720:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801723:	3b 45 10             	cmp    0x10(%ebp),%eax
  801726:	7d 19                	jge    801741 <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  801728:	ff 45 08             	incl   0x8(%ebp)
  80172b:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80172e:	0f af 45 10          	imul   0x10(%ebp),%eax
  801732:	89 c2                	mov    %eax,%edx
  801734:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801737:	01 d0                	add    %edx,%eax
  801739:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  80173c:	e9 7b ff ff ff       	jmp    8016bc <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  801741:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  801742:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801746:	74 08                	je     801750 <strtol+0x134>
		*endptr = (char *) s;
  801748:	8b 45 0c             	mov    0xc(%ebp),%eax
  80174b:	8b 55 08             	mov    0x8(%ebp),%edx
  80174e:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  801750:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801754:	74 07                	je     80175d <strtol+0x141>
  801756:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801759:	f7 d8                	neg    %eax
  80175b:	eb 03                	jmp    801760 <strtol+0x144>
  80175d:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  801760:	c9                   	leave  
  801761:	c3                   	ret    

00801762 <ltostr>:

void
ltostr(long value, char *str)
{
  801762:	55                   	push   %ebp
  801763:	89 e5                	mov    %esp,%ebp
  801765:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  801768:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  80176f:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  801776:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80177a:	79 13                	jns    80178f <ltostr+0x2d>
	{
		neg = 1;
  80177c:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  801783:	8b 45 0c             	mov    0xc(%ebp),%eax
  801786:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  801789:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  80178c:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  80178f:	8b 45 08             	mov    0x8(%ebp),%eax
  801792:	b9 0a 00 00 00       	mov    $0xa,%ecx
  801797:	99                   	cltd   
  801798:	f7 f9                	idiv   %ecx
  80179a:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  80179d:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8017a0:	8d 50 01             	lea    0x1(%eax),%edx
  8017a3:	89 55 f8             	mov    %edx,-0x8(%ebp)
  8017a6:	89 c2                	mov    %eax,%edx
  8017a8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8017ab:	01 d0                	add    %edx,%eax
  8017ad:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8017b0:	83 c2 30             	add    $0x30,%edx
  8017b3:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  8017b5:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8017b8:	b8 67 66 66 66       	mov    $0x66666667,%eax
  8017bd:	f7 e9                	imul   %ecx
  8017bf:	c1 fa 02             	sar    $0x2,%edx
  8017c2:	89 c8                	mov    %ecx,%eax
  8017c4:	c1 f8 1f             	sar    $0x1f,%eax
  8017c7:	29 c2                	sub    %eax,%edx
  8017c9:	89 d0                	mov    %edx,%eax
  8017cb:	89 45 08             	mov    %eax,0x8(%ebp)
	} while (value % 10 != 0);
  8017ce:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8017d1:	b8 67 66 66 66       	mov    $0x66666667,%eax
  8017d6:	f7 e9                	imul   %ecx
  8017d8:	c1 fa 02             	sar    $0x2,%edx
  8017db:	89 c8                	mov    %ecx,%eax
  8017dd:	c1 f8 1f             	sar    $0x1f,%eax
  8017e0:	29 c2                	sub    %eax,%edx
  8017e2:	89 d0                	mov    %edx,%eax
  8017e4:	c1 e0 02             	shl    $0x2,%eax
  8017e7:	01 d0                	add    %edx,%eax
  8017e9:	01 c0                	add    %eax,%eax
  8017eb:	29 c1                	sub    %eax,%ecx
  8017ed:	89 ca                	mov    %ecx,%edx
  8017ef:	85 d2                	test   %edx,%edx
  8017f1:	75 9c                	jne    80178f <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  8017f3:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  8017fa:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8017fd:	48                   	dec    %eax
  8017fe:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  801801:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801805:	74 3d                	je     801844 <ltostr+0xe2>
		start = 1 ;
  801807:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  80180e:	eb 34                	jmp    801844 <ltostr+0xe2>
	{
		char tmp = str[start] ;
  801810:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801813:	8b 45 0c             	mov    0xc(%ebp),%eax
  801816:	01 d0                	add    %edx,%eax
  801818:	8a 00                	mov    (%eax),%al
  80181a:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  80181d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801820:	8b 45 0c             	mov    0xc(%ebp),%eax
  801823:	01 c2                	add    %eax,%edx
  801825:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  801828:	8b 45 0c             	mov    0xc(%ebp),%eax
  80182b:	01 c8                	add    %ecx,%eax
  80182d:	8a 00                	mov    (%eax),%al
  80182f:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  801831:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801834:	8b 45 0c             	mov    0xc(%ebp),%eax
  801837:	01 c2                	add    %eax,%edx
  801839:	8a 45 eb             	mov    -0x15(%ebp),%al
  80183c:	88 02                	mov    %al,(%edx)
		start++ ;
  80183e:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  801841:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  801844:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801847:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80184a:	7c c4                	jl     801810 <ltostr+0xae>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  80184c:	8b 55 f8             	mov    -0x8(%ebp),%edx
  80184f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801852:	01 d0                	add    %edx,%eax
  801854:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  801857:	90                   	nop
  801858:	c9                   	leave  
  801859:	c3                   	ret    

0080185a <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  80185a:	55                   	push   %ebp
  80185b:	89 e5                	mov    %esp,%ebp
  80185d:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  801860:	ff 75 08             	pushl  0x8(%ebp)
  801863:	e8 54 fa ff ff       	call   8012bc <strlen>
  801868:	83 c4 04             	add    $0x4,%esp
  80186b:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  80186e:	ff 75 0c             	pushl  0xc(%ebp)
  801871:	e8 46 fa ff ff       	call   8012bc <strlen>
  801876:	83 c4 04             	add    $0x4,%esp
  801879:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  80187c:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  801883:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  80188a:	eb 17                	jmp    8018a3 <strcconcat+0x49>
		final[s] = str1[s] ;
  80188c:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80188f:	8b 45 10             	mov    0x10(%ebp),%eax
  801892:	01 c2                	add    %eax,%edx
  801894:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  801897:	8b 45 08             	mov    0x8(%ebp),%eax
  80189a:	01 c8                	add    %ecx,%eax
  80189c:	8a 00                	mov    (%eax),%al
  80189e:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  8018a0:	ff 45 fc             	incl   -0x4(%ebp)
  8018a3:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8018a6:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  8018a9:	7c e1                	jl     80188c <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  8018ab:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  8018b2:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  8018b9:	eb 1f                	jmp    8018da <strcconcat+0x80>
		final[s++] = str2[i] ;
  8018bb:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8018be:	8d 50 01             	lea    0x1(%eax),%edx
  8018c1:	89 55 fc             	mov    %edx,-0x4(%ebp)
  8018c4:	89 c2                	mov    %eax,%edx
  8018c6:	8b 45 10             	mov    0x10(%ebp),%eax
  8018c9:	01 c2                	add    %eax,%edx
  8018cb:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  8018ce:	8b 45 0c             	mov    0xc(%ebp),%eax
  8018d1:	01 c8                	add    %ecx,%eax
  8018d3:	8a 00                	mov    (%eax),%al
  8018d5:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  8018d7:	ff 45 f8             	incl   -0x8(%ebp)
  8018da:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8018dd:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8018e0:	7c d9                	jl     8018bb <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  8018e2:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8018e5:	8b 45 10             	mov    0x10(%ebp),%eax
  8018e8:	01 d0                	add    %edx,%eax
  8018ea:	c6 00 00             	movb   $0x0,(%eax)
}
  8018ed:	90                   	nop
  8018ee:	c9                   	leave  
  8018ef:	c3                   	ret    

008018f0 <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  8018f0:	55                   	push   %ebp
  8018f1:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  8018f3:	8b 45 14             	mov    0x14(%ebp),%eax
  8018f6:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  8018fc:	8b 45 14             	mov    0x14(%ebp),%eax
  8018ff:	8b 00                	mov    (%eax),%eax
  801901:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801908:	8b 45 10             	mov    0x10(%ebp),%eax
  80190b:	01 d0                	add    %edx,%eax
  80190d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801913:	eb 0c                	jmp    801921 <strsplit+0x31>
			*string++ = 0;
  801915:	8b 45 08             	mov    0x8(%ebp),%eax
  801918:	8d 50 01             	lea    0x1(%eax),%edx
  80191b:	89 55 08             	mov    %edx,0x8(%ebp)
  80191e:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801921:	8b 45 08             	mov    0x8(%ebp),%eax
  801924:	8a 00                	mov    (%eax),%al
  801926:	84 c0                	test   %al,%al
  801928:	74 18                	je     801942 <strsplit+0x52>
  80192a:	8b 45 08             	mov    0x8(%ebp),%eax
  80192d:	8a 00                	mov    (%eax),%al
  80192f:	0f be c0             	movsbl %al,%eax
  801932:	50                   	push   %eax
  801933:	ff 75 0c             	pushl  0xc(%ebp)
  801936:	e8 13 fb ff ff       	call   80144e <strchr>
  80193b:	83 c4 08             	add    $0x8,%esp
  80193e:	85 c0                	test   %eax,%eax
  801940:	75 d3                	jne    801915 <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  801942:	8b 45 08             	mov    0x8(%ebp),%eax
  801945:	8a 00                	mov    (%eax),%al
  801947:	84 c0                	test   %al,%al
  801949:	74 5a                	je     8019a5 <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  80194b:	8b 45 14             	mov    0x14(%ebp),%eax
  80194e:	8b 00                	mov    (%eax),%eax
  801950:	83 f8 0f             	cmp    $0xf,%eax
  801953:	75 07                	jne    80195c <strsplit+0x6c>
		{
			return 0;
  801955:	b8 00 00 00 00       	mov    $0x0,%eax
  80195a:	eb 66                	jmp    8019c2 <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  80195c:	8b 45 14             	mov    0x14(%ebp),%eax
  80195f:	8b 00                	mov    (%eax),%eax
  801961:	8d 48 01             	lea    0x1(%eax),%ecx
  801964:	8b 55 14             	mov    0x14(%ebp),%edx
  801967:	89 0a                	mov    %ecx,(%edx)
  801969:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801970:	8b 45 10             	mov    0x10(%ebp),%eax
  801973:	01 c2                	add    %eax,%edx
  801975:	8b 45 08             	mov    0x8(%ebp),%eax
  801978:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  80197a:	eb 03                	jmp    80197f <strsplit+0x8f>
			string++;
  80197c:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  80197f:	8b 45 08             	mov    0x8(%ebp),%eax
  801982:	8a 00                	mov    (%eax),%al
  801984:	84 c0                	test   %al,%al
  801986:	74 8b                	je     801913 <strsplit+0x23>
  801988:	8b 45 08             	mov    0x8(%ebp),%eax
  80198b:	8a 00                	mov    (%eax),%al
  80198d:	0f be c0             	movsbl %al,%eax
  801990:	50                   	push   %eax
  801991:	ff 75 0c             	pushl  0xc(%ebp)
  801994:	e8 b5 fa ff ff       	call   80144e <strchr>
  801999:	83 c4 08             	add    $0x8,%esp
  80199c:	85 c0                	test   %eax,%eax
  80199e:	74 dc                	je     80197c <strsplit+0x8c>
			string++;
	}
  8019a0:	e9 6e ff ff ff       	jmp    801913 <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  8019a5:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  8019a6:	8b 45 14             	mov    0x14(%ebp),%eax
  8019a9:	8b 00                	mov    (%eax),%eax
  8019ab:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8019b2:	8b 45 10             	mov    0x10(%ebp),%eax
  8019b5:	01 d0                	add    %edx,%eax
  8019b7:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  8019bd:	b8 01 00 00 00       	mov    $0x1,%eax
}
  8019c2:	c9                   	leave  
  8019c3:	c3                   	ret    

008019c4 <InitializeUHeap>:
//============================== GIVEN FUNCTIONS ===================================//
//==================================================================================//

int FirstTimeFlag = 1;
void InitializeUHeap()
{
  8019c4:	55                   	push   %ebp
  8019c5:	89 e5                	mov    %esp,%ebp
  8019c7:	83 ec 08             	sub    $0x8,%esp
	if(FirstTimeFlag)
  8019ca:	a1 04 50 80 00       	mov    0x805004,%eax
  8019cf:	85 c0                	test   %eax,%eax
  8019d1:	74 1f                	je     8019f2 <InitializeUHeap+0x2e>
	{
		initialize_dyn_block_system();
  8019d3:	e8 1d 00 00 00       	call   8019f5 <initialize_dyn_block_system>
		cprintf("DYNAMIC BLOCK SYSTEM IS INITIALIZED\n");
  8019d8:	83 ec 0c             	sub    $0xc,%esp
  8019db:	68 64 3f 80 00       	push   $0x803f64
  8019e0:	e8 4f f0 ff ff       	call   800a34 <cprintf>
  8019e5:	83 c4 10             	add    $0x10,%esp
#if UHP_USE_BUDDY
		initialize_buddy();
		cprintf("BUDDY SYSTEM IS INITIALIZED\n");
#endif
		FirstTimeFlag = 0;
  8019e8:	c7 05 04 50 80 00 00 	movl   $0x0,0x805004
  8019ef:	00 00 00 
	}
}
  8019f2:	90                   	nop
  8019f3:	c9                   	leave  
  8019f4:	c3                   	ret    

008019f5 <initialize_dyn_block_system>:

//=================================
// [1] INITIALIZE DYNAMIC ALLOCATOR:
//=================================
void initialize_dyn_block_system()
{
  8019f5:	55                   	push   %ebp
  8019f6:	89 e5                	mov    %esp,%ebp
  8019f8:	83 ec 28             	sub    $0x28,%esp
	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] initialize_dyn_block_system
	// your code is here, remove the panic and write your code
	//panic("initialize_dyn_block_system() is not implemented yet...!!");

	LIST_INIT(&AllocMemBlocksList);
  8019fb:	c7 05 40 50 80 00 00 	movl   $0x0,0x805040
  801a02:	00 00 00 
  801a05:	c7 05 44 50 80 00 00 	movl   $0x0,0x805044
  801a0c:	00 00 00 
  801a0f:	c7 05 4c 50 80 00 00 	movl   $0x0,0x80504c
  801a16:	00 00 00 
	LIST_INIT(&FreeMemBlocksList);
  801a19:	c7 05 38 51 80 00 00 	movl   $0x0,0x805138
  801a20:	00 00 00 
  801a23:	c7 05 3c 51 80 00 00 	movl   $0x0,0x80513c
  801a2a:	00 00 00 
  801a2d:	c7 05 44 51 80 00 00 	movl   $0x0,0x805144
  801a34:	00 00 00 
	MAX_MEM_BLOCK_CNT = NUM_OF_UHEAP_PAGES;
  801a37:	c7 05 20 51 80 00 00 	movl   $0x20000,0x805120
  801a3e:	00 02 00 
	MemBlockNodes = (void*)USER_DYN_BLKS_ARRAY;
  801a41:	c7 45 f4 00 00 e0 7f 	movl   $0x7fe00000,-0xc(%ebp)
  801a48:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801a4b:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801a50:	2d 00 10 00 00       	sub    $0x1000,%eax
  801a55:	a3 50 50 80 00       	mov    %eax,0x805050
	int size_of_block = sizeof(struct MemBlock);
  801a5a:	c7 45 f0 10 00 00 00 	movl   $0x10,-0x10(%ebp)
	int size_all_struct = size_of_block*MAX_MEM_BLOCK_CNT;
  801a61:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801a64:	a1 20 51 80 00       	mov    0x805120,%eax
  801a69:	0f af c2             	imul   %edx,%eax
  801a6c:	89 45 ec             	mov    %eax,-0x14(%ebp)
	size_all_struct = ROUNDUP(size_all_struct, PAGE_SIZE);
  801a6f:	c7 45 e8 00 10 00 00 	movl   $0x1000,-0x18(%ebp)
  801a76:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801a79:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801a7c:	01 d0                	add    %edx,%eax
  801a7e:	48                   	dec    %eax
  801a7f:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  801a82:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801a85:	ba 00 00 00 00       	mov    $0x0,%edx
  801a8a:	f7 75 e8             	divl   -0x18(%ebp)
  801a8d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801a90:	29 d0                	sub    %edx,%eax
  801a92:	89 45 ec             	mov    %eax,-0x14(%ebp)
	sys_allocate_chunk(USER_DYN_BLKS_ARRAY, size_all_struct,PERM_USER| PERM_WRITEABLE);
  801a95:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801a98:	c7 45 e0 00 00 e0 7f 	movl   $0x7fe00000,-0x20(%ebp)
  801a9f:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801aa2:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
  801aa8:	81 ea 00 10 00 00    	sub    $0x1000,%edx
  801aae:	83 ec 04             	sub    $0x4,%esp
  801ab1:	6a 06                	push   $0x6
  801ab3:	50                   	push   %eax
  801ab4:	52                   	push   %edx
  801ab5:	e8 a1 05 00 00       	call   80205b <sys_allocate_chunk>
  801aba:	83 c4 10             	add    $0x10,%esp
	initialize_MemBlocksList(MAX_MEM_BLOCK_CNT);
  801abd:	a1 20 51 80 00       	mov    0x805120,%eax
  801ac2:	83 ec 0c             	sub    $0xc,%esp
  801ac5:	50                   	push   %eax
  801ac6:	e8 16 0c 00 00       	call   8026e1 <initialize_MemBlocksList>
  801acb:	83 c4 10             	add    $0x10,%esp
	struct MemBlock* ourBlock =LIST_LAST(&AvailableMemBlocksList);
  801ace:	a1 4c 51 80 00       	mov    0x80514c,%eax
  801ad3:	89 45 dc             	mov    %eax,-0x24(%ebp)
	LIST_REMOVE(&AvailableMemBlocksList,ourBlock);
  801ad6:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  801ada:	75 14                	jne    801af0 <initialize_dyn_block_system+0xfb>
  801adc:	83 ec 04             	sub    $0x4,%esp
  801adf:	68 89 3f 80 00       	push   $0x803f89
  801ae4:	6a 2d                	push   $0x2d
  801ae6:	68 a7 3f 80 00       	push   $0x803fa7
  801aeb:	e8 90 ec ff ff       	call   800780 <_panic>
  801af0:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801af3:	8b 00                	mov    (%eax),%eax
  801af5:	85 c0                	test   %eax,%eax
  801af7:	74 10                	je     801b09 <initialize_dyn_block_system+0x114>
  801af9:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801afc:	8b 00                	mov    (%eax),%eax
  801afe:	8b 55 dc             	mov    -0x24(%ebp),%edx
  801b01:	8b 52 04             	mov    0x4(%edx),%edx
  801b04:	89 50 04             	mov    %edx,0x4(%eax)
  801b07:	eb 0b                	jmp    801b14 <initialize_dyn_block_system+0x11f>
  801b09:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801b0c:	8b 40 04             	mov    0x4(%eax),%eax
  801b0f:	a3 4c 51 80 00       	mov    %eax,0x80514c
  801b14:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801b17:	8b 40 04             	mov    0x4(%eax),%eax
  801b1a:	85 c0                	test   %eax,%eax
  801b1c:	74 0f                	je     801b2d <initialize_dyn_block_system+0x138>
  801b1e:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801b21:	8b 40 04             	mov    0x4(%eax),%eax
  801b24:	8b 55 dc             	mov    -0x24(%ebp),%edx
  801b27:	8b 12                	mov    (%edx),%edx
  801b29:	89 10                	mov    %edx,(%eax)
  801b2b:	eb 0a                	jmp    801b37 <initialize_dyn_block_system+0x142>
  801b2d:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801b30:	8b 00                	mov    (%eax),%eax
  801b32:	a3 48 51 80 00       	mov    %eax,0x805148
  801b37:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801b3a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  801b40:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801b43:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  801b4a:	a1 54 51 80 00       	mov    0x805154,%eax
  801b4f:	48                   	dec    %eax
  801b50:	a3 54 51 80 00       	mov    %eax,0x805154
	ourBlock->size = USER_HEAP_MAX-USER_HEAP_START;
  801b55:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801b58:	c7 40 0c 00 00 00 20 	movl   $0x20000000,0xc(%eax)
	ourBlock->sva=USER_HEAP_START;
  801b5f:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801b62:	c7 40 08 00 00 00 80 	movl   $0x80000000,0x8(%eax)
	LIST_INSERT_TAIL(&FreeMemBlocksList, ourBlock);
  801b69:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  801b6d:	75 14                	jne    801b83 <initialize_dyn_block_system+0x18e>
  801b6f:	83 ec 04             	sub    $0x4,%esp
  801b72:	68 b4 3f 80 00       	push   $0x803fb4
  801b77:	6a 30                	push   $0x30
  801b79:	68 a7 3f 80 00       	push   $0x803fa7
  801b7e:	e8 fd eb ff ff       	call   800780 <_panic>
  801b83:	8b 15 3c 51 80 00    	mov    0x80513c,%edx
  801b89:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801b8c:	89 50 04             	mov    %edx,0x4(%eax)
  801b8f:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801b92:	8b 40 04             	mov    0x4(%eax),%eax
  801b95:	85 c0                	test   %eax,%eax
  801b97:	74 0c                	je     801ba5 <initialize_dyn_block_system+0x1b0>
  801b99:	a1 3c 51 80 00       	mov    0x80513c,%eax
  801b9e:	8b 55 dc             	mov    -0x24(%ebp),%edx
  801ba1:	89 10                	mov    %edx,(%eax)
  801ba3:	eb 08                	jmp    801bad <initialize_dyn_block_system+0x1b8>
  801ba5:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801ba8:	a3 38 51 80 00       	mov    %eax,0x805138
  801bad:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801bb0:	a3 3c 51 80 00       	mov    %eax,0x80513c
  801bb5:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801bb8:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  801bbe:	a1 44 51 80 00       	mov    0x805144,%eax
  801bc3:	40                   	inc    %eax
  801bc4:	a3 44 51 80 00       	mov    %eax,0x805144
	//[1] Initialize two lists (AllocMemBlocksList & FreeMemBlocksList) [Hint: use LIST_INIT()]
	//[2] Dynamically allocate the array of MemBlockNodes at VA USER_DYN_BLKS_ARRAY
	//	  (remember to set MAX_MEM_BLOCK_CNT with the chosen size of the array)
	//[3] Initialize AvailableMemBlocksList by filling it with the MemBlockNodes
	//[4] Insert a new MemBlock with the heap size into the FreeMemBlocksList
}
  801bc9:	90                   	nop
  801bca:	c9                   	leave  
  801bcb:	c3                   	ret    

00801bcc <malloc>:
//=================================
// [2] ALLOCATE SPACE IN USER HEAP:
//=================================

void* malloc(uint32 size)
{
  801bcc:	55                   	push   %ebp
  801bcd:	89 e5                	mov    %esp,%ebp
  801bcf:	83 ec 18             	sub    $0x18,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801bd2:	e8 ed fd ff ff       	call   8019c4 <InitializeUHeap>
	if (size == 0) return NULL ;
  801bd7:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801bdb:	75 07                	jne    801be4 <malloc+0x18>
  801bdd:	b8 00 00 00 00       	mov    $0x0,%eax
  801be2:	eb 67                	jmp    801c4b <malloc+0x7f>

	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] malloc
	// your code is here, remove the panic and write your code
	//panic("malloc() is not implemented yet...!!");

	size = ROUNDUP(size, PAGE_SIZE);
  801be4:	c7 45 f4 00 10 00 00 	movl   $0x1000,-0xc(%ebp)
  801beb:	8b 55 08             	mov    0x8(%ebp),%edx
  801bee:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801bf1:	01 d0                	add    %edx,%eax
  801bf3:	48                   	dec    %eax
  801bf4:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801bf7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801bfa:	ba 00 00 00 00       	mov    $0x0,%edx
  801bff:	f7 75 f4             	divl   -0xc(%ebp)
  801c02:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801c05:	29 d0                	sub    %edx,%eax
  801c07:	89 45 08             	mov    %eax,0x8(%ebp)
	if(sys_isUHeapPlacementStrategyFIRSTFIT())
  801c0a:	e8 1a 08 00 00       	call   802429 <sys_isUHeapPlacementStrategyFIRSTFIT>
  801c0f:	85 c0                	test   %eax,%eax
  801c11:	74 33                	je     801c46 <malloc+0x7a>
	{
		struct MemBlock * myBlock = alloc_block_FF(size);
  801c13:	83 ec 0c             	sub    $0xc,%esp
  801c16:	ff 75 08             	pushl  0x8(%ebp)
  801c19:	e8 0c 0e 00 00       	call   802a2a <alloc_block_FF>
  801c1e:	83 c4 10             	add    $0x10,%esp
  801c21:	89 45 ec             	mov    %eax,-0x14(%ebp)
		if(myBlock != NULL)
  801c24:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  801c28:	74 1c                	je     801c46 <malloc+0x7a>
		{
			insert_sorted_allocList(myBlock);
  801c2a:	83 ec 0c             	sub    $0xc,%esp
  801c2d:	ff 75 ec             	pushl  -0x14(%ebp)
  801c30:	e8 07 0c 00 00       	call   80283c <insert_sorted_allocList>
  801c35:	83 c4 10             	add    $0x10,%esp
			uint32 ptr = myBlock->sva;
  801c38:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801c3b:	8b 40 08             	mov    0x8(%eax),%eax
  801c3e:	89 45 e8             	mov    %eax,-0x18(%ebp)
			return (void *)ptr;
  801c41:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801c44:	eb 05                	jmp    801c4b <malloc+0x7f>
		}
	}
	return NULL;
  801c46:	b8 00 00 00 00       	mov    $0x0,%eax
	//		to the required allocation size (space should be on 4 KB BOUNDARY)
	//	2) if no suitable space found, return NULL
	// 	3) Return pointer containing the virtual address of allocated space,
	//
	//Use sys_isUHeapPlacementStrategyFIRSTFIT()... to check the current strategy
}
  801c4b:	c9                   	leave  
  801c4c:	c3                   	ret    

00801c4d <free>:
//	We can use sys_free_user_mem(uint32 virtual_address, uint32 size); which
//		switches to the kernel mode, calls free_user_mem() in
//		"kern/mem/chunk_operations.c", then switch back to the user mode here
//	the free_user_mem function is empty, make sure to implement it.
void free(void* virtual_address)
{
  801c4d:	55                   	push   %ebp
  801c4e:	89 e5                	mov    %esp,%ebp
  801c50:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] free
	// your code is here, remove the panic and write your code
	//panic("free() is not implemented yet...!!");

	uint32 virtualAddress = (uint32 )(virtual_address);
  801c53:	8b 45 08             	mov    0x8(%ebp),%eax
  801c56:	89 45 f4             	mov    %eax,-0xc(%ebp)
//	virtualAddress = ROUNDDOWN(virtualAddress, PAGE_SIZE);
	struct MemBlock * myBlock = find_block(&AllocMemBlocksList, virtualAddress);
  801c59:	83 ec 08             	sub    $0x8,%esp
  801c5c:	ff 75 f4             	pushl  -0xc(%ebp)
  801c5f:	68 40 50 80 00       	push   $0x805040
  801c64:	e8 5b 0b 00 00       	call   8027c4 <find_block>
  801c69:	83 c4 10             	add    $0x10,%esp
  801c6c:	89 45 f0             	mov    %eax,-0x10(%ebp)
//	cprintf ("ptr sva at free user side = %x \n", myBlock->sva);
	sys_free_user_mem(virtualAddress, myBlock->size);
  801c6f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801c72:	8b 40 0c             	mov    0xc(%eax),%eax
  801c75:	83 ec 08             	sub    $0x8,%esp
  801c78:	50                   	push   %eax
  801c79:	ff 75 f4             	pushl  -0xc(%ebp)
  801c7c:	e8 a2 03 00 00       	call   802023 <sys_free_user_mem>
  801c81:	83 c4 10             	add    $0x10,%esp
	LIST_REMOVE(&AllocMemBlocksList, myBlock);
  801c84:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801c88:	75 14                	jne    801c9e <free+0x51>
  801c8a:	83 ec 04             	sub    $0x4,%esp
  801c8d:	68 89 3f 80 00       	push   $0x803f89
  801c92:	6a 76                	push   $0x76
  801c94:	68 a7 3f 80 00       	push   $0x803fa7
  801c99:	e8 e2 ea ff ff       	call   800780 <_panic>
  801c9e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801ca1:	8b 00                	mov    (%eax),%eax
  801ca3:	85 c0                	test   %eax,%eax
  801ca5:	74 10                	je     801cb7 <free+0x6a>
  801ca7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801caa:	8b 00                	mov    (%eax),%eax
  801cac:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801caf:	8b 52 04             	mov    0x4(%edx),%edx
  801cb2:	89 50 04             	mov    %edx,0x4(%eax)
  801cb5:	eb 0b                	jmp    801cc2 <free+0x75>
  801cb7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801cba:	8b 40 04             	mov    0x4(%eax),%eax
  801cbd:	a3 44 50 80 00       	mov    %eax,0x805044
  801cc2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801cc5:	8b 40 04             	mov    0x4(%eax),%eax
  801cc8:	85 c0                	test   %eax,%eax
  801cca:	74 0f                	je     801cdb <free+0x8e>
  801ccc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801ccf:	8b 40 04             	mov    0x4(%eax),%eax
  801cd2:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801cd5:	8b 12                	mov    (%edx),%edx
  801cd7:	89 10                	mov    %edx,(%eax)
  801cd9:	eb 0a                	jmp    801ce5 <free+0x98>
  801cdb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801cde:	8b 00                	mov    (%eax),%eax
  801ce0:	a3 40 50 80 00       	mov    %eax,0x805040
  801ce5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801ce8:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  801cee:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801cf1:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  801cf8:	a1 4c 50 80 00       	mov    0x80504c,%eax
  801cfd:	48                   	dec    %eax
  801cfe:	a3 4c 50 80 00       	mov    %eax,0x80504c
	insert_sorted_with_merge_freeList(myBlock);
  801d03:	83 ec 0c             	sub    $0xc,%esp
  801d06:	ff 75 f0             	pushl  -0x10(%ebp)
  801d09:	e8 0b 14 00 00       	call   803119 <insert_sorted_with_merge_freeList>
  801d0e:	83 c4 10             	add    $0x10,%esp

	//you should get the size of the given allocation using its address
	//you need to call sys_free_user_mem()
	//refer to the project presentation and documentation for details
}
  801d11:	90                   	nop
  801d12:	c9                   	leave  
  801d13:	c3                   	ret    

00801d14 <smalloc>:

//=================================
// [4] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
  801d14:	55                   	push   %ebp
  801d15:	89 e5                	mov    %esp,%ebp
  801d17:	83 ec 28             	sub    $0x28,%esp
  801d1a:	8b 45 10             	mov    0x10(%ebp),%eax
  801d1d:	88 45 e4             	mov    %al,-0x1c(%ebp)
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801d20:	e8 9f fc ff ff       	call   8019c4 <InitializeUHeap>
	if (size == 0) return NULL ;
  801d25:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801d29:	75 0a                	jne    801d35 <smalloc+0x21>
  801d2b:	b8 00 00 00 00       	mov    $0x0,%eax
  801d30:	e9 8d 00 00 00       	jmp    801dc2 <smalloc+0xae>

	//This function should find the space of the required range
	// * ON 4KB BOUNDARY **** //
	//Use sys_isUHeapPlacementStrategyFIRSTFIT() to check the current strategy

	size = ROUNDUP(size, PAGE_SIZE);
  801d35:	c7 45 f4 00 10 00 00 	movl   $0x1000,-0xc(%ebp)
  801d3c:	8b 55 0c             	mov    0xc(%ebp),%edx
  801d3f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801d42:	01 d0                	add    %edx,%eax
  801d44:	48                   	dec    %eax
  801d45:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801d48:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801d4b:	ba 00 00 00 00       	mov    $0x0,%edx
  801d50:	f7 75 f4             	divl   -0xc(%ebp)
  801d53:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801d56:	29 d0                	sub    %edx,%eax
  801d58:	89 45 0c             	mov    %eax,0xc(%ebp)
		if(sys_isUHeapPlacementStrategyFIRSTFIT())
  801d5b:	e8 c9 06 00 00       	call   802429 <sys_isUHeapPlacementStrategyFIRSTFIT>
  801d60:	85 c0                	test   %eax,%eax
  801d62:	74 59                	je     801dbd <smalloc+0xa9>
		{
			struct MemBlock * v1=NULL;
  801d64:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
			v1= alloc_block_FF(size);
  801d6b:	83 ec 0c             	sub    $0xc,%esp
  801d6e:	ff 75 0c             	pushl  0xc(%ebp)
  801d71:	e8 b4 0c 00 00       	call   802a2a <alloc_block_FF>
  801d76:	83 c4 10             	add    $0x10,%esp
  801d79:	89 45 ec             	mov    %eax,-0x14(%ebp)
			if(v1==NULL)
  801d7c:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  801d80:	75 07                	jne    801d89 <smalloc+0x75>
			{
				return NULL;
  801d82:	b8 00 00 00 00       	mov    $0x0,%eax
  801d87:	eb 39                	jmp    801dc2 <smalloc+0xae>
			}
			else
			{
				int ret=sys_createSharedObject(sharedVarName,  size,  isWritable,(void*)v1->sva);
  801d89:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801d8c:	8b 40 08             	mov    0x8(%eax),%eax
  801d8f:	89 c2                	mov    %eax,%edx
  801d91:	0f b6 45 e4          	movzbl -0x1c(%ebp),%eax
  801d95:	52                   	push   %edx
  801d96:	50                   	push   %eax
  801d97:	ff 75 0c             	pushl  0xc(%ebp)
  801d9a:	ff 75 08             	pushl  0x8(%ebp)
  801d9d:	e8 0c 04 00 00       	call   8021ae <sys_createSharedObject>
  801da2:	83 c4 10             	add    $0x10,%esp
  801da5:	89 45 e8             	mov    %eax,-0x18(%ebp)
				if(ret>=0)
  801da8:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  801dac:	78 08                	js     801db6 <smalloc+0xa2>
				{
					return (void*)v1->sva;
  801dae:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801db1:	8b 40 08             	mov    0x8(%eax),%eax
  801db4:	eb 0c                	jmp    801dc2 <smalloc+0xae>
				}
				else
				{
					return NULL;
  801db6:	b8 00 00 00 00       	mov    $0x0,%eax
  801dbb:	eb 05                	jmp    801dc2 <smalloc+0xae>
				}
			}

		}
		return NULL;
  801dbd:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801dc2:	c9                   	leave  
  801dc3:	c3                   	ret    

00801dc4 <sget>:

//========================================
// [5] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  801dc4:	55                   	push   %ebp
  801dc5:	89 e5                	mov    %esp,%ebp
  801dc7:	83 ec 18             	sub    $0x18,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801dca:	e8 f5 fb ff ff       	call   8019c4 <InitializeUHeap>

	//This function should find the space for sharing the variable
	// *** ON 4KB BOUNDARY ******** //

	//Use sys_isUHeapPlacementStrategyFIRSTFIT() to check the current strategy
	int ret=sys_getSizeOfSharedObject(ownerEnvID,sharedVarName);
  801dcf:	83 ec 08             	sub    $0x8,%esp
  801dd2:	ff 75 0c             	pushl  0xc(%ebp)
  801dd5:	ff 75 08             	pushl  0x8(%ebp)
  801dd8:	e8 fb 03 00 00       	call   8021d8 <sys_getSizeOfSharedObject>
  801ddd:	83 c4 10             	add    $0x10,%esp
  801de0:	89 45 f4             	mov    %eax,-0xc(%ebp)
	if(ret==0)
  801de3:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801de7:	75 07                	jne    801df0 <sget+0x2c>
	{
		return NULL;
  801de9:	b8 00 00 00 00       	mov    $0x0,%eax
  801dee:	eb 64                	jmp    801e54 <sget+0x90>
	}
	if(sys_isUHeapPlacementStrategyFIRSTFIT())
  801df0:	e8 34 06 00 00       	call   802429 <sys_isUHeapPlacementStrategyFIRSTFIT>
  801df5:	85 c0                	test   %eax,%eax
  801df7:	74 56                	je     801e4f <sget+0x8b>
	{
		struct MemBlock * v1=NULL;
  801df9:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
		v1= alloc_block_FF(ret);
  801e00:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e03:	83 ec 0c             	sub    $0xc,%esp
  801e06:	50                   	push   %eax
  801e07:	e8 1e 0c 00 00       	call   802a2a <alloc_block_FF>
  801e0c:	83 c4 10             	add    $0x10,%esp
  801e0f:	89 45 f0             	mov    %eax,-0x10(%ebp)
		if(v1==NULL)
  801e12:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801e16:	75 07                	jne    801e1f <sget+0x5b>
		{
		return NULL;
  801e18:	b8 00 00 00 00       	mov    $0x0,%eax
  801e1d:	eb 35                	jmp    801e54 <sget+0x90>
	    }
		else
		{
			int ret1=sys_getSharedObject(ownerEnvID,sharedVarName,(void*)v1->sva);
  801e1f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801e22:	8b 40 08             	mov    0x8(%eax),%eax
  801e25:	83 ec 04             	sub    $0x4,%esp
  801e28:	50                   	push   %eax
  801e29:	ff 75 0c             	pushl  0xc(%ebp)
  801e2c:	ff 75 08             	pushl  0x8(%ebp)
  801e2f:	e8 c1 03 00 00       	call   8021f5 <sys_getSharedObject>
  801e34:	83 c4 10             	add    $0x10,%esp
  801e37:	89 45 ec             	mov    %eax,-0x14(%ebp)
			if(ret1>=0)
  801e3a:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  801e3e:	78 08                	js     801e48 <sget+0x84>
			{
				return (void*)v1->sva;
  801e40:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801e43:	8b 40 08             	mov    0x8(%eax),%eax
  801e46:	eb 0c                	jmp    801e54 <sget+0x90>
			}
			else
			{
				return NULL;
  801e48:	b8 00 00 00 00       	mov    $0x0,%eax
  801e4d:	eb 05                	jmp    801e54 <sget+0x90>
			}
		}
	}
  return NULL;
  801e4f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801e54:	c9                   	leave  
  801e55:	c3                   	ret    

00801e56 <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  801e56:	55                   	push   %ebp
  801e57:	89 e5                	mov    %esp,%ebp
  801e59:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801e5c:	e8 63 fb ff ff       	call   8019c4 <InitializeUHeap>
	//==============================================================
	// [USER HEAP - USER SIDE] realloc
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  801e61:	83 ec 04             	sub    $0x4,%esp
  801e64:	68 d8 3f 80 00       	push   $0x803fd8
  801e69:	68 0e 01 00 00       	push   $0x10e
  801e6e:	68 a7 3f 80 00       	push   $0x803fa7
  801e73:	e8 08 e9 ff ff       	call   800780 <_panic>

00801e78 <sfree>:
//	use sys_freeSharedObject(...); which switches to the kernel mode,
//	calls freeSharedObject(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the freeSharedObject() function is empty, make sure to implement it.

void sfree(void* virtual_address)
{
  801e78:	55                   	push   %ebp
  801e79:	89 e5                	mov    %esp,%ebp
  801e7b:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS3 - BONUS] [SHARING - USER SIDE] sfree()

	// Write your code here, remove the panic and write your code
	panic("sfree() is not implemented yet...!!");
  801e7e:	83 ec 04             	sub    $0x4,%esp
  801e81:	68 00 40 80 00       	push   $0x804000
  801e86:	68 22 01 00 00       	push   $0x122
  801e8b:	68 a7 3f 80 00       	push   $0x803fa7
  801e90:	e8 eb e8 ff ff       	call   800780 <_panic>

00801e95 <expand>:

//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//
void expand(uint32 newSize)
{
  801e95:	55                   	push   %ebp
  801e96:	89 e5                	mov    %esp,%ebp
  801e98:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801e9b:	83 ec 04             	sub    $0x4,%esp
  801e9e:	68 24 40 80 00       	push   $0x804024
  801ea3:	68 2d 01 00 00       	push   $0x12d
  801ea8:	68 a7 3f 80 00       	push   $0x803fa7
  801ead:	e8 ce e8 ff ff       	call   800780 <_panic>

00801eb2 <shrink>:

}
void shrink(uint32 newSize)
{
  801eb2:	55                   	push   %ebp
  801eb3:	89 e5                	mov    %esp,%ebp
  801eb5:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801eb8:	83 ec 04             	sub    $0x4,%esp
  801ebb:	68 24 40 80 00       	push   $0x804024
  801ec0:	68 32 01 00 00       	push   $0x132
  801ec5:	68 a7 3f 80 00       	push   $0x803fa7
  801eca:	e8 b1 e8 ff ff       	call   800780 <_panic>

00801ecf <freeHeap>:

}
void freeHeap(void* virtual_address)
{
  801ecf:	55                   	push   %ebp
  801ed0:	89 e5                	mov    %esp,%ebp
  801ed2:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801ed5:	83 ec 04             	sub    $0x4,%esp
  801ed8:	68 24 40 80 00       	push   $0x804024
  801edd:	68 37 01 00 00       	push   $0x137
  801ee2:	68 a7 3f 80 00       	push   $0x803fa7
  801ee7:	e8 94 e8 ff ff       	call   800780 <_panic>

00801eec <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  801eec:	55                   	push   %ebp
  801eed:	89 e5                	mov    %esp,%ebp
  801eef:	57                   	push   %edi
  801ef0:	56                   	push   %esi
  801ef1:	53                   	push   %ebx
  801ef2:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801ef5:	8b 45 08             	mov    0x8(%ebp),%eax
  801ef8:	8b 55 0c             	mov    0xc(%ebp),%edx
  801efb:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801efe:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801f01:	8b 7d 18             	mov    0x18(%ebp),%edi
  801f04:	8b 75 1c             	mov    0x1c(%ebp),%esi
  801f07:	cd 30                	int    $0x30
  801f09:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  801f0c:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801f0f:	83 c4 10             	add    $0x10,%esp
  801f12:	5b                   	pop    %ebx
  801f13:	5e                   	pop    %esi
  801f14:	5f                   	pop    %edi
  801f15:	5d                   	pop    %ebp
  801f16:	c3                   	ret    

00801f17 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  801f17:	55                   	push   %ebp
  801f18:	89 e5                	mov    %esp,%ebp
  801f1a:	83 ec 04             	sub    $0x4,%esp
  801f1d:	8b 45 10             	mov    0x10(%ebp),%eax
  801f20:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  801f23:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801f27:	8b 45 08             	mov    0x8(%ebp),%eax
  801f2a:	6a 00                	push   $0x0
  801f2c:	6a 00                	push   $0x0
  801f2e:	52                   	push   %edx
  801f2f:	ff 75 0c             	pushl  0xc(%ebp)
  801f32:	50                   	push   %eax
  801f33:	6a 00                	push   $0x0
  801f35:	e8 b2 ff ff ff       	call   801eec <syscall>
  801f3a:	83 c4 18             	add    $0x18,%esp
}
  801f3d:	90                   	nop
  801f3e:	c9                   	leave  
  801f3f:	c3                   	ret    

00801f40 <sys_cgetc>:

int
sys_cgetc(void)
{
  801f40:	55                   	push   %ebp
  801f41:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  801f43:	6a 00                	push   $0x0
  801f45:	6a 00                	push   $0x0
  801f47:	6a 00                	push   $0x0
  801f49:	6a 00                	push   $0x0
  801f4b:	6a 00                	push   $0x0
  801f4d:	6a 01                	push   $0x1
  801f4f:	e8 98 ff ff ff       	call   801eec <syscall>
  801f54:	83 c4 18             	add    $0x18,%esp
}
  801f57:	c9                   	leave  
  801f58:	c3                   	ret    

00801f59 <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  801f59:	55                   	push   %ebp
  801f5a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  801f5c:	8b 55 0c             	mov    0xc(%ebp),%edx
  801f5f:	8b 45 08             	mov    0x8(%ebp),%eax
  801f62:	6a 00                	push   $0x0
  801f64:	6a 00                	push   $0x0
  801f66:	6a 00                	push   $0x0
  801f68:	52                   	push   %edx
  801f69:	50                   	push   %eax
  801f6a:	6a 05                	push   $0x5
  801f6c:	e8 7b ff ff ff       	call   801eec <syscall>
  801f71:	83 c4 18             	add    $0x18,%esp
}
  801f74:	c9                   	leave  
  801f75:	c3                   	ret    

00801f76 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  801f76:	55                   	push   %ebp
  801f77:	89 e5                	mov    %esp,%ebp
  801f79:	56                   	push   %esi
  801f7a:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  801f7b:	8b 75 18             	mov    0x18(%ebp),%esi
  801f7e:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801f81:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801f84:	8b 55 0c             	mov    0xc(%ebp),%edx
  801f87:	8b 45 08             	mov    0x8(%ebp),%eax
  801f8a:	56                   	push   %esi
  801f8b:	53                   	push   %ebx
  801f8c:	51                   	push   %ecx
  801f8d:	52                   	push   %edx
  801f8e:	50                   	push   %eax
  801f8f:	6a 06                	push   $0x6
  801f91:	e8 56 ff ff ff       	call   801eec <syscall>
  801f96:	83 c4 18             	add    $0x18,%esp
}
  801f99:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801f9c:	5b                   	pop    %ebx
  801f9d:	5e                   	pop    %esi
  801f9e:	5d                   	pop    %ebp
  801f9f:	c3                   	ret    

00801fa0 <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  801fa0:	55                   	push   %ebp
  801fa1:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  801fa3:	8b 55 0c             	mov    0xc(%ebp),%edx
  801fa6:	8b 45 08             	mov    0x8(%ebp),%eax
  801fa9:	6a 00                	push   $0x0
  801fab:	6a 00                	push   $0x0
  801fad:	6a 00                	push   $0x0
  801faf:	52                   	push   %edx
  801fb0:	50                   	push   %eax
  801fb1:	6a 07                	push   $0x7
  801fb3:	e8 34 ff ff ff       	call   801eec <syscall>
  801fb8:	83 c4 18             	add    $0x18,%esp
}
  801fbb:	c9                   	leave  
  801fbc:	c3                   	ret    

00801fbd <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  801fbd:	55                   	push   %ebp
  801fbe:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  801fc0:	6a 00                	push   $0x0
  801fc2:	6a 00                	push   $0x0
  801fc4:	6a 00                	push   $0x0
  801fc6:	ff 75 0c             	pushl  0xc(%ebp)
  801fc9:	ff 75 08             	pushl  0x8(%ebp)
  801fcc:	6a 08                	push   $0x8
  801fce:	e8 19 ff ff ff       	call   801eec <syscall>
  801fd3:	83 c4 18             	add    $0x18,%esp
}
  801fd6:	c9                   	leave  
  801fd7:	c3                   	ret    

00801fd8 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  801fd8:	55                   	push   %ebp
  801fd9:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  801fdb:	6a 00                	push   $0x0
  801fdd:	6a 00                	push   $0x0
  801fdf:	6a 00                	push   $0x0
  801fe1:	6a 00                	push   $0x0
  801fe3:	6a 00                	push   $0x0
  801fe5:	6a 09                	push   $0x9
  801fe7:	e8 00 ff ff ff       	call   801eec <syscall>
  801fec:	83 c4 18             	add    $0x18,%esp
}
  801fef:	c9                   	leave  
  801ff0:	c3                   	ret    

00801ff1 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  801ff1:	55                   	push   %ebp
  801ff2:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  801ff4:	6a 00                	push   $0x0
  801ff6:	6a 00                	push   $0x0
  801ff8:	6a 00                	push   $0x0
  801ffa:	6a 00                	push   $0x0
  801ffc:	6a 00                	push   $0x0
  801ffe:	6a 0a                	push   $0xa
  802000:	e8 e7 fe ff ff       	call   801eec <syscall>
  802005:	83 c4 18             	add    $0x18,%esp
}
  802008:	c9                   	leave  
  802009:	c3                   	ret    

0080200a <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  80200a:	55                   	push   %ebp
  80200b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  80200d:	6a 00                	push   $0x0
  80200f:	6a 00                	push   $0x0
  802011:	6a 00                	push   $0x0
  802013:	6a 00                	push   $0x0
  802015:	6a 00                	push   $0x0
  802017:	6a 0b                	push   $0xb
  802019:	e8 ce fe ff ff       	call   801eec <syscall>
  80201e:	83 c4 18             	add    $0x18,%esp
}
  802021:	c9                   	leave  
  802022:	c3                   	ret    

00802023 <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  802023:	55                   	push   %ebp
  802024:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  802026:	6a 00                	push   $0x0
  802028:	6a 00                	push   $0x0
  80202a:	6a 00                	push   $0x0
  80202c:	ff 75 0c             	pushl  0xc(%ebp)
  80202f:	ff 75 08             	pushl  0x8(%ebp)
  802032:	6a 0f                	push   $0xf
  802034:	e8 b3 fe ff ff       	call   801eec <syscall>
  802039:	83 c4 18             	add    $0x18,%esp
	return;
  80203c:	90                   	nop
}
  80203d:	c9                   	leave  
  80203e:	c3                   	ret    

0080203f <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  80203f:	55                   	push   %ebp
  802040:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  802042:	6a 00                	push   $0x0
  802044:	6a 00                	push   $0x0
  802046:	6a 00                	push   $0x0
  802048:	ff 75 0c             	pushl  0xc(%ebp)
  80204b:	ff 75 08             	pushl  0x8(%ebp)
  80204e:	6a 10                	push   $0x10
  802050:	e8 97 fe ff ff       	call   801eec <syscall>
  802055:	83 c4 18             	add    $0x18,%esp
	return ;
  802058:	90                   	nop
}
  802059:	c9                   	leave  
  80205a:	c3                   	ret    

0080205b <sys_allocate_chunk>:

void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  80205b:	55                   	push   %ebp
  80205c:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  80205e:	6a 00                	push   $0x0
  802060:	6a 00                	push   $0x0
  802062:	ff 75 10             	pushl  0x10(%ebp)
  802065:	ff 75 0c             	pushl  0xc(%ebp)
  802068:	ff 75 08             	pushl  0x8(%ebp)
  80206b:	6a 11                	push   $0x11
  80206d:	e8 7a fe ff ff       	call   801eec <syscall>
  802072:	83 c4 18             	add    $0x18,%esp
	return ;
  802075:	90                   	nop
}
  802076:	c9                   	leave  
  802077:	c3                   	ret    

00802078 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  802078:	55                   	push   %ebp
  802079:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  80207b:	6a 00                	push   $0x0
  80207d:	6a 00                	push   $0x0
  80207f:	6a 00                	push   $0x0
  802081:	6a 00                	push   $0x0
  802083:	6a 00                	push   $0x0
  802085:	6a 0c                	push   $0xc
  802087:	e8 60 fe ff ff       	call   801eec <syscall>
  80208c:	83 c4 18             	add    $0x18,%esp
}
  80208f:	c9                   	leave  
  802090:	c3                   	ret    

00802091 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  802091:	55                   	push   %ebp
  802092:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  802094:	6a 00                	push   $0x0
  802096:	6a 00                	push   $0x0
  802098:	6a 00                	push   $0x0
  80209a:	6a 00                	push   $0x0
  80209c:	ff 75 08             	pushl  0x8(%ebp)
  80209f:	6a 0d                	push   $0xd
  8020a1:	e8 46 fe ff ff       	call   801eec <syscall>
  8020a6:	83 c4 18             	add    $0x18,%esp
}
  8020a9:	c9                   	leave  
  8020aa:	c3                   	ret    

008020ab <sys_scarce_memory>:

void sys_scarce_memory()
{
  8020ab:	55                   	push   %ebp
  8020ac:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  8020ae:	6a 00                	push   $0x0
  8020b0:	6a 00                	push   $0x0
  8020b2:	6a 00                	push   $0x0
  8020b4:	6a 00                	push   $0x0
  8020b6:	6a 00                	push   $0x0
  8020b8:	6a 0e                	push   $0xe
  8020ba:	e8 2d fe ff ff       	call   801eec <syscall>
  8020bf:	83 c4 18             	add    $0x18,%esp
}
  8020c2:	90                   	nop
  8020c3:	c9                   	leave  
  8020c4:	c3                   	ret    

008020c5 <sys_disable_interrupt>:

//NEW !! 2012...
void
sys_disable_interrupt()
{
  8020c5:	55                   	push   %ebp
  8020c6:	89 e5                	mov    %esp,%ebp
	syscall(SYS_disableINTR,0, 0, 0, 0, 0);
  8020c8:	6a 00                	push   $0x0
  8020ca:	6a 00                	push   $0x0
  8020cc:	6a 00                	push   $0x0
  8020ce:	6a 00                	push   $0x0
  8020d0:	6a 00                	push   $0x0
  8020d2:	6a 13                	push   $0x13
  8020d4:	e8 13 fe ff ff       	call   801eec <syscall>
  8020d9:	83 c4 18             	add    $0x18,%esp
}
  8020dc:	90                   	nop
  8020dd:	c9                   	leave  
  8020de:	c3                   	ret    

008020df <sys_enable_interrupt>:


void
sys_enable_interrupt()
{
  8020df:	55                   	push   %ebp
  8020e0:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enableINTR,0, 0, 0, 0, 0);
  8020e2:	6a 00                	push   $0x0
  8020e4:	6a 00                	push   $0x0
  8020e6:	6a 00                	push   $0x0
  8020e8:	6a 00                	push   $0x0
  8020ea:	6a 00                	push   $0x0
  8020ec:	6a 14                	push   $0x14
  8020ee:	e8 f9 fd ff ff       	call   801eec <syscall>
  8020f3:	83 c4 18             	add    $0x18,%esp
}
  8020f6:	90                   	nop
  8020f7:	c9                   	leave  
  8020f8:	c3                   	ret    

008020f9 <sys_cputc>:


void
sys_cputc(const char c)
{
  8020f9:	55                   	push   %ebp
  8020fa:	89 e5                	mov    %esp,%ebp
  8020fc:	83 ec 04             	sub    $0x4,%esp
  8020ff:	8b 45 08             	mov    0x8(%ebp),%eax
  802102:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  802105:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  802109:	6a 00                	push   $0x0
  80210b:	6a 00                	push   $0x0
  80210d:	6a 00                	push   $0x0
  80210f:	6a 00                	push   $0x0
  802111:	50                   	push   %eax
  802112:	6a 15                	push   $0x15
  802114:	e8 d3 fd ff ff       	call   801eec <syscall>
  802119:	83 c4 18             	add    $0x18,%esp
}
  80211c:	90                   	nop
  80211d:	c9                   	leave  
  80211e:	c3                   	ret    

0080211f <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  80211f:	55                   	push   %ebp
  802120:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  802122:	6a 00                	push   $0x0
  802124:	6a 00                	push   $0x0
  802126:	6a 00                	push   $0x0
  802128:	6a 00                	push   $0x0
  80212a:	6a 00                	push   $0x0
  80212c:	6a 16                	push   $0x16
  80212e:	e8 b9 fd ff ff       	call   801eec <syscall>
  802133:	83 c4 18             	add    $0x18,%esp
}
  802136:	90                   	nop
  802137:	c9                   	leave  
  802138:	c3                   	ret    

00802139 <sys_createSemaphore>:

int
sys_createSemaphore(char* semaphoreName, uint32 initialValue)
{
  802139:	55                   	push   %ebp
  80213a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_semaphore,(uint32)semaphoreName, (uint32)initialValue, 0, 0, 0);
  80213c:	8b 45 08             	mov    0x8(%ebp),%eax
  80213f:	6a 00                	push   $0x0
  802141:	6a 00                	push   $0x0
  802143:	6a 00                	push   $0x0
  802145:	ff 75 0c             	pushl  0xc(%ebp)
  802148:	50                   	push   %eax
  802149:	6a 17                	push   $0x17
  80214b:	e8 9c fd ff ff       	call   801eec <syscall>
  802150:	83 c4 18             	add    $0x18,%esp
}
  802153:	c9                   	leave  
  802154:	c3                   	ret    

00802155 <sys_getSemaphoreValue>:

int
sys_getSemaphoreValue(int32 ownerEnvID, char* semaphoreName)
{
  802155:	55                   	push   %ebp
  802156:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_semaphore_value,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  802158:	8b 55 0c             	mov    0xc(%ebp),%edx
  80215b:	8b 45 08             	mov    0x8(%ebp),%eax
  80215e:	6a 00                	push   $0x0
  802160:	6a 00                	push   $0x0
  802162:	6a 00                	push   $0x0
  802164:	52                   	push   %edx
  802165:	50                   	push   %eax
  802166:	6a 1a                	push   $0x1a
  802168:	e8 7f fd ff ff       	call   801eec <syscall>
  80216d:	83 c4 18             	add    $0x18,%esp
}
  802170:	c9                   	leave  
  802171:	c3                   	ret    

00802172 <sys_waitSemaphore>:

void
sys_waitSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  802172:	55                   	push   %ebp
  802173:	89 e5                	mov    %esp,%ebp
	syscall(SYS_wait_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  802175:	8b 55 0c             	mov    0xc(%ebp),%edx
  802178:	8b 45 08             	mov    0x8(%ebp),%eax
  80217b:	6a 00                	push   $0x0
  80217d:	6a 00                	push   $0x0
  80217f:	6a 00                	push   $0x0
  802181:	52                   	push   %edx
  802182:	50                   	push   %eax
  802183:	6a 18                	push   $0x18
  802185:	e8 62 fd ff ff       	call   801eec <syscall>
  80218a:	83 c4 18             	add    $0x18,%esp
}
  80218d:	90                   	nop
  80218e:	c9                   	leave  
  80218f:	c3                   	ret    

00802190 <sys_signalSemaphore>:

void
sys_signalSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  802190:	55                   	push   %ebp
  802191:	89 e5                	mov    %esp,%ebp
	syscall(SYS_signal_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  802193:	8b 55 0c             	mov    0xc(%ebp),%edx
  802196:	8b 45 08             	mov    0x8(%ebp),%eax
  802199:	6a 00                	push   $0x0
  80219b:	6a 00                	push   $0x0
  80219d:	6a 00                	push   $0x0
  80219f:	52                   	push   %edx
  8021a0:	50                   	push   %eax
  8021a1:	6a 19                	push   $0x19
  8021a3:	e8 44 fd ff ff       	call   801eec <syscall>
  8021a8:	83 c4 18             	add    $0x18,%esp
}
  8021ab:	90                   	nop
  8021ac:	c9                   	leave  
  8021ad:	c3                   	ret    

008021ae <sys_createSharedObject>:

int
sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  8021ae:	55                   	push   %ebp
  8021af:	89 e5                	mov    %esp,%ebp
  8021b1:	83 ec 04             	sub    $0x4,%esp
  8021b4:	8b 45 10             	mov    0x10(%ebp),%eax
  8021b7:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  8021ba:	8b 4d 14             	mov    0x14(%ebp),%ecx
  8021bd:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  8021c1:	8b 45 08             	mov    0x8(%ebp),%eax
  8021c4:	6a 00                	push   $0x0
  8021c6:	51                   	push   %ecx
  8021c7:	52                   	push   %edx
  8021c8:	ff 75 0c             	pushl  0xc(%ebp)
  8021cb:	50                   	push   %eax
  8021cc:	6a 1b                	push   $0x1b
  8021ce:	e8 19 fd ff ff       	call   801eec <syscall>
  8021d3:	83 c4 18             	add    $0x18,%esp
}
  8021d6:	c9                   	leave  
  8021d7:	c3                   	ret    

008021d8 <sys_getSizeOfSharedObject>:

//2017:
int
sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  8021d8:	55                   	push   %ebp
  8021d9:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  8021db:	8b 55 0c             	mov    0xc(%ebp),%edx
  8021de:	8b 45 08             	mov    0x8(%ebp),%eax
  8021e1:	6a 00                	push   $0x0
  8021e3:	6a 00                	push   $0x0
  8021e5:	6a 00                	push   $0x0
  8021e7:	52                   	push   %edx
  8021e8:	50                   	push   %eax
  8021e9:	6a 1c                	push   $0x1c
  8021eb:	e8 fc fc ff ff       	call   801eec <syscall>
  8021f0:	83 c4 18             	add    $0x18,%esp
}
  8021f3:	c9                   	leave  
  8021f4:	c3                   	ret    

008021f5 <sys_getSharedObject>:
//==========

int
sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  8021f5:	55                   	push   %ebp
  8021f6:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  8021f8:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8021fb:	8b 55 0c             	mov    0xc(%ebp),%edx
  8021fe:	8b 45 08             	mov    0x8(%ebp),%eax
  802201:	6a 00                	push   $0x0
  802203:	6a 00                	push   $0x0
  802205:	51                   	push   %ecx
  802206:	52                   	push   %edx
  802207:	50                   	push   %eax
  802208:	6a 1d                	push   $0x1d
  80220a:	e8 dd fc ff ff       	call   801eec <syscall>
  80220f:	83 c4 18             	add    $0x18,%esp
}
  802212:	c9                   	leave  
  802213:	c3                   	ret    

00802214 <sys_freeSharedObject>:

int
sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  802214:	55                   	push   %ebp
  802215:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  802217:	8b 55 0c             	mov    0xc(%ebp),%edx
  80221a:	8b 45 08             	mov    0x8(%ebp),%eax
  80221d:	6a 00                	push   $0x0
  80221f:	6a 00                	push   $0x0
  802221:	6a 00                	push   $0x0
  802223:	52                   	push   %edx
  802224:	50                   	push   %eax
  802225:	6a 1e                	push   $0x1e
  802227:	e8 c0 fc ff ff       	call   801eec <syscall>
  80222c:	83 c4 18             	add    $0x18,%esp
}
  80222f:	c9                   	leave  
  802230:	c3                   	ret    

00802231 <sys_getMaxShares>:

uint32 	sys_getMaxShares()
{
  802231:	55                   	push   %ebp
  802232:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_max_shares,0, 0, 0, 0, 0);
  802234:	6a 00                	push   $0x0
  802236:	6a 00                	push   $0x0
  802238:	6a 00                	push   $0x0
  80223a:	6a 00                	push   $0x0
  80223c:	6a 00                	push   $0x0
  80223e:	6a 1f                	push   $0x1f
  802240:	e8 a7 fc ff ff       	call   801eec <syscall>
  802245:	83 c4 18             	add    $0x18,%esp
}
  802248:	c9                   	leave  
  802249:	c3                   	ret    

0080224a <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  80224a:	55                   	push   %ebp
  80224b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  80224d:	8b 45 08             	mov    0x8(%ebp),%eax
  802250:	6a 00                	push   $0x0
  802252:	ff 75 14             	pushl  0x14(%ebp)
  802255:	ff 75 10             	pushl  0x10(%ebp)
  802258:	ff 75 0c             	pushl  0xc(%ebp)
  80225b:	50                   	push   %eax
  80225c:	6a 20                	push   $0x20
  80225e:	e8 89 fc ff ff       	call   801eec <syscall>
  802263:	83 c4 18             	add    $0x18,%esp
}
  802266:	c9                   	leave  
  802267:	c3                   	ret    

00802268 <sys_run_env>:

void
sys_run_env(int32 envId)
{
  802268:	55                   	push   %ebp
  802269:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  80226b:	8b 45 08             	mov    0x8(%ebp),%eax
  80226e:	6a 00                	push   $0x0
  802270:	6a 00                	push   $0x0
  802272:	6a 00                	push   $0x0
  802274:	6a 00                	push   $0x0
  802276:	50                   	push   %eax
  802277:	6a 21                	push   $0x21
  802279:	e8 6e fc ff ff       	call   801eec <syscall>
  80227e:	83 c4 18             	add    $0x18,%esp
}
  802281:	90                   	nop
  802282:	c9                   	leave  
  802283:	c3                   	ret    

00802284 <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  802284:	55                   	push   %ebp
  802285:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  802287:	8b 45 08             	mov    0x8(%ebp),%eax
  80228a:	6a 00                	push   $0x0
  80228c:	6a 00                	push   $0x0
  80228e:	6a 00                	push   $0x0
  802290:	6a 00                	push   $0x0
  802292:	50                   	push   %eax
  802293:	6a 22                	push   $0x22
  802295:	e8 52 fc ff ff       	call   801eec <syscall>
  80229a:	83 c4 18             	add    $0x18,%esp
}
  80229d:	c9                   	leave  
  80229e:	c3                   	ret    

0080229f <sys_getenvid>:

int32 sys_getenvid(void)
{
  80229f:	55                   	push   %ebp
  8022a0:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  8022a2:	6a 00                	push   $0x0
  8022a4:	6a 00                	push   $0x0
  8022a6:	6a 00                	push   $0x0
  8022a8:	6a 00                	push   $0x0
  8022aa:	6a 00                	push   $0x0
  8022ac:	6a 02                	push   $0x2
  8022ae:	e8 39 fc ff ff       	call   801eec <syscall>
  8022b3:	83 c4 18             	add    $0x18,%esp
}
  8022b6:	c9                   	leave  
  8022b7:	c3                   	ret    

008022b8 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  8022b8:	55                   	push   %ebp
  8022b9:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  8022bb:	6a 00                	push   $0x0
  8022bd:	6a 00                	push   $0x0
  8022bf:	6a 00                	push   $0x0
  8022c1:	6a 00                	push   $0x0
  8022c3:	6a 00                	push   $0x0
  8022c5:	6a 03                	push   $0x3
  8022c7:	e8 20 fc ff ff       	call   801eec <syscall>
  8022cc:	83 c4 18             	add    $0x18,%esp
}
  8022cf:	c9                   	leave  
  8022d0:	c3                   	ret    

008022d1 <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  8022d1:	55                   	push   %ebp
  8022d2:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  8022d4:	6a 00                	push   $0x0
  8022d6:	6a 00                	push   $0x0
  8022d8:	6a 00                	push   $0x0
  8022da:	6a 00                	push   $0x0
  8022dc:	6a 00                	push   $0x0
  8022de:	6a 04                	push   $0x4
  8022e0:	e8 07 fc ff ff       	call   801eec <syscall>
  8022e5:	83 c4 18             	add    $0x18,%esp
}
  8022e8:	c9                   	leave  
  8022e9:	c3                   	ret    

008022ea <sys_exit_env>:


void sys_exit_env(void)
{
  8022ea:	55                   	push   %ebp
  8022eb:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  8022ed:	6a 00                	push   $0x0
  8022ef:	6a 00                	push   $0x0
  8022f1:	6a 00                	push   $0x0
  8022f3:	6a 00                	push   $0x0
  8022f5:	6a 00                	push   $0x0
  8022f7:	6a 23                	push   $0x23
  8022f9:	e8 ee fb ff ff       	call   801eec <syscall>
  8022fe:	83 c4 18             	add    $0x18,%esp
}
  802301:	90                   	nop
  802302:	c9                   	leave  
  802303:	c3                   	ret    

00802304 <sys_get_virtual_time>:


struct uint64
sys_get_virtual_time()
{
  802304:	55                   	push   %ebp
  802305:	89 e5                	mov    %esp,%ebp
  802307:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  80230a:	8d 45 f8             	lea    -0x8(%ebp),%eax
  80230d:	8d 50 04             	lea    0x4(%eax),%edx
  802310:	8d 45 f8             	lea    -0x8(%ebp),%eax
  802313:	6a 00                	push   $0x0
  802315:	6a 00                	push   $0x0
  802317:	6a 00                	push   $0x0
  802319:	52                   	push   %edx
  80231a:	50                   	push   %eax
  80231b:	6a 24                	push   $0x24
  80231d:	e8 ca fb ff ff       	call   801eec <syscall>
  802322:	83 c4 18             	add    $0x18,%esp
	return result;
  802325:	8b 4d 08             	mov    0x8(%ebp),%ecx
  802328:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80232b:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80232e:	89 01                	mov    %eax,(%ecx)
  802330:	89 51 04             	mov    %edx,0x4(%ecx)
}
  802333:	8b 45 08             	mov    0x8(%ebp),%eax
  802336:	c9                   	leave  
  802337:	c2 04 00             	ret    $0x4

0080233a <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  80233a:	55                   	push   %ebp
  80233b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  80233d:	6a 00                	push   $0x0
  80233f:	6a 00                	push   $0x0
  802341:	ff 75 10             	pushl  0x10(%ebp)
  802344:	ff 75 0c             	pushl  0xc(%ebp)
  802347:	ff 75 08             	pushl  0x8(%ebp)
  80234a:	6a 12                	push   $0x12
  80234c:	e8 9b fb ff ff       	call   801eec <syscall>
  802351:	83 c4 18             	add    $0x18,%esp
	return ;
  802354:	90                   	nop
}
  802355:	c9                   	leave  
  802356:	c3                   	ret    

00802357 <sys_rcr2>:
uint32 sys_rcr2()
{
  802357:	55                   	push   %ebp
  802358:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  80235a:	6a 00                	push   $0x0
  80235c:	6a 00                	push   $0x0
  80235e:	6a 00                	push   $0x0
  802360:	6a 00                	push   $0x0
  802362:	6a 00                	push   $0x0
  802364:	6a 25                	push   $0x25
  802366:	e8 81 fb ff ff       	call   801eec <syscall>
  80236b:	83 c4 18             	add    $0x18,%esp
}
  80236e:	c9                   	leave  
  80236f:	c3                   	ret    

00802370 <sys_bypassPageFault>:
void sys_bypassPageFault(uint8 instrLength)
{
  802370:	55                   	push   %ebp
  802371:	89 e5                	mov    %esp,%ebp
  802373:	83 ec 04             	sub    $0x4,%esp
  802376:	8b 45 08             	mov    0x8(%ebp),%eax
  802379:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  80237c:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  802380:	6a 00                	push   $0x0
  802382:	6a 00                	push   $0x0
  802384:	6a 00                	push   $0x0
  802386:	6a 00                	push   $0x0
  802388:	50                   	push   %eax
  802389:	6a 26                	push   $0x26
  80238b:	e8 5c fb ff ff       	call   801eec <syscall>
  802390:	83 c4 18             	add    $0x18,%esp
	return ;
  802393:	90                   	nop
}
  802394:	c9                   	leave  
  802395:	c3                   	ret    

00802396 <rsttst>:
void rsttst()
{
  802396:	55                   	push   %ebp
  802397:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  802399:	6a 00                	push   $0x0
  80239b:	6a 00                	push   $0x0
  80239d:	6a 00                	push   $0x0
  80239f:	6a 00                	push   $0x0
  8023a1:	6a 00                	push   $0x0
  8023a3:	6a 28                	push   $0x28
  8023a5:	e8 42 fb ff ff       	call   801eec <syscall>
  8023aa:	83 c4 18             	add    $0x18,%esp
	return ;
  8023ad:	90                   	nop
}
  8023ae:	c9                   	leave  
  8023af:	c3                   	ret    

008023b0 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  8023b0:	55                   	push   %ebp
  8023b1:	89 e5                	mov    %esp,%ebp
  8023b3:	83 ec 04             	sub    $0x4,%esp
  8023b6:	8b 45 14             	mov    0x14(%ebp),%eax
  8023b9:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  8023bc:	8b 55 18             	mov    0x18(%ebp),%edx
  8023bf:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  8023c3:	52                   	push   %edx
  8023c4:	50                   	push   %eax
  8023c5:	ff 75 10             	pushl  0x10(%ebp)
  8023c8:	ff 75 0c             	pushl  0xc(%ebp)
  8023cb:	ff 75 08             	pushl  0x8(%ebp)
  8023ce:	6a 27                	push   $0x27
  8023d0:	e8 17 fb ff ff       	call   801eec <syscall>
  8023d5:	83 c4 18             	add    $0x18,%esp
	return ;
  8023d8:	90                   	nop
}
  8023d9:	c9                   	leave  
  8023da:	c3                   	ret    

008023db <chktst>:
void chktst(uint32 n)
{
  8023db:	55                   	push   %ebp
  8023dc:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  8023de:	6a 00                	push   $0x0
  8023e0:	6a 00                	push   $0x0
  8023e2:	6a 00                	push   $0x0
  8023e4:	6a 00                	push   $0x0
  8023e6:	ff 75 08             	pushl  0x8(%ebp)
  8023e9:	6a 29                	push   $0x29
  8023eb:	e8 fc fa ff ff       	call   801eec <syscall>
  8023f0:	83 c4 18             	add    $0x18,%esp
	return ;
  8023f3:	90                   	nop
}
  8023f4:	c9                   	leave  
  8023f5:	c3                   	ret    

008023f6 <inctst>:

void inctst()
{
  8023f6:	55                   	push   %ebp
  8023f7:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  8023f9:	6a 00                	push   $0x0
  8023fb:	6a 00                	push   $0x0
  8023fd:	6a 00                	push   $0x0
  8023ff:	6a 00                	push   $0x0
  802401:	6a 00                	push   $0x0
  802403:	6a 2a                	push   $0x2a
  802405:	e8 e2 fa ff ff       	call   801eec <syscall>
  80240a:	83 c4 18             	add    $0x18,%esp
	return ;
  80240d:	90                   	nop
}
  80240e:	c9                   	leave  
  80240f:	c3                   	ret    

00802410 <gettst>:
uint32 gettst()
{
  802410:	55                   	push   %ebp
  802411:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  802413:	6a 00                	push   $0x0
  802415:	6a 00                	push   $0x0
  802417:	6a 00                	push   $0x0
  802419:	6a 00                	push   $0x0
  80241b:	6a 00                	push   $0x0
  80241d:	6a 2b                	push   $0x2b
  80241f:	e8 c8 fa ff ff       	call   801eec <syscall>
  802424:	83 c4 18             	add    $0x18,%esp
}
  802427:	c9                   	leave  
  802428:	c3                   	ret    

00802429 <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
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
  80243b:	e8 ac fa ff ff       	call   801eec <syscall>
  802440:	83 c4 18             	add    $0x18,%esp
  802443:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  802446:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  80244a:	75 07                	jne    802453 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  80244c:	b8 01 00 00 00       	mov    $0x1,%eax
  802451:	eb 05                	jmp    802458 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  802453:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802458:	c9                   	leave  
  802459:	c3                   	ret    

0080245a <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  80245a:	55                   	push   %ebp
  80245b:	89 e5                	mov    %esp,%ebp
  80245d:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  802460:	6a 00                	push   $0x0
  802462:	6a 00                	push   $0x0
  802464:	6a 00                	push   $0x0
  802466:	6a 00                	push   $0x0
  802468:	6a 00                	push   $0x0
  80246a:	6a 2c                	push   $0x2c
  80246c:	e8 7b fa ff ff       	call   801eec <syscall>
  802471:	83 c4 18             	add    $0x18,%esp
  802474:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  802477:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  80247b:	75 07                	jne    802484 <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  80247d:	b8 01 00 00 00       	mov    $0x1,%eax
  802482:	eb 05                	jmp    802489 <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  802484:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802489:	c9                   	leave  
  80248a:	c3                   	ret    

0080248b <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  80248b:	55                   	push   %ebp
  80248c:	89 e5                	mov    %esp,%ebp
  80248e:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  802491:	6a 00                	push   $0x0
  802493:	6a 00                	push   $0x0
  802495:	6a 00                	push   $0x0
  802497:	6a 00                	push   $0x0
  802499:	6a 00                	push   $0x0
  80249b:	6a 2c                	push   $0x2c
  80249d:	e8 4a fa ff ff       	call   801eec <syscall>
  8024a2:	83 c4 18             	add    $0x18,%esp
  8024a5:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  8024a8:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  8024ac:	75 07                	jne    8024b5 <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  8024ae:	b8 01 00 00 00       	mov    $0x1,%eax
  8024b3:	eb 05                	jmp    8024ba <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  8024b5:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8024ba:	c9                   	leave  
  8024bb:	c3                   	ret    

008024bc <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  8024bc:	55                   	push   %ebp
  8024bd:	89 e5                	mov    %esp,%ebp
  8024bf:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8024c2:	6a 00                	push   $0x0
  8024c4:	6a 00                	push   $0x0
  8024c6:	6a 00                	push   $0x0
  8024c8:	6a 00                	push   $0x0
  8024ca:	6a 00                	push   $0x0
  8024cc:	6a 2c                	push   $0x2c
  8024ce:	e8 19 fa ff ff       	call   801eec <syscall>
  8024d3:	83 c4 18             	add    $0x18,%esp
  8024d6:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  8024d9:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  8024dd:	75 07                	jne    8024e6 <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  8024df:	b8 01 00 00 00       	mov    $0x1,%eax
  8024e4:	eb 05                	jmp    8024eb <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  8024e6:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8024eb:	c9                   	leave  
  8024ec:	c3                   	ret    

008024ed <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  8024ed:	55                   	push   %ebp
  8024ee:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  8024f0:	6a 00                	push   $0x0
  8024f2:	6a 00                	push   $0x0
  8024f4:	6a 00                	push   $0x0
  8024f6:	6a 00                	push   $0x0
  8024f8:	ff 75 08             	pushl  0x8(%ebp)
  8024fb:	6a 2d                	push   $0x2d
  8024fd:	e8 ea f9 ff ff       	call   801eec <syscall>
  802502:	83 c4 18             	add    $0x18,%esp
	return ;
  802505:	90                   	nop
}
  802506:	c9                   	leave  
  802507:	c3                   	ret    

00802508 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  802508:	55                   	push   %ebp
  802509:	89 e5                	mov    %esp,%ebp
  80250b:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  80250c:	8b 5d 14             	mov    0x14(%ebp),%ebx
  80250f:	8b 4d 10             	mov    0x10(%ebp),%ecx
  802512:	8b 55 0c             	mov    0xc(%ebp),%edx
  802515:	8b 45 08             	mov    0x8(%ebp),%eax
  802518:	6a 00                	push   $0x0
  80251a:	53                   	push   %ebx
  80251b:	51                   	push   %ecx
  80251c:	52                   	push   %edx
  80251d:	50                   	push   %eax
  80251e:	6a 2e                	push   $0x2e
  802520:	e8 c7 f9 ff ff       	call   801eec <syscall>
  802525:	83 c4 18             	add    $0x18,%esp
}
  802528:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80252b:	c9                   	leave  
  80252c:	c3                   	ret    

0080252d <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  80252d:	55                   	push   %ebp
  80252e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  802530:	8b 55 0c             	mov    0xc(%ebp),%edx
  802533:	8b 45 08             	mov    0x8(%ebp),%eax
  802536:	6a 00                	push   $0x0
  802538:	6a 00                	push   $0x0
  80253a:	6a 00                	push   $0x0
  80253c:	52                   	push   %edx
  80253d:	50                   	push   %eax
  80253e:	6a 2f                	push   $0x2f
  802540:	e8 a7 f9 ff ff       	call   801eec <syscall>
  802545:	83 c4 18             	add    $0x18,%esp
}
  802548:	c9                   	leave  
  802549:	c3                   	ret    

0080254a <print_mem_block_lists>:
//===========================
// PRINT MEM BLOCK LISTS:
//===========================

void print_mem_block_lists()
{
  80254a:	55                   	push   %ebp
  80254b:	89 e5                	mov    %esp,%ebp
  80254d:	83 ec 18             	sub    $0x18,%esp
	cprintf("\n=========================================\n");
  802550:	83 ec 0c             	sub    $0xc,%esp
  802553:	68 34 40 80 00       	push   $0x804034
  802558:	e8 d7 e4 ff ff       	call   800a34 <cprintf>
  80255d:	83 c4 10             	add    $0x10,%esp
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
  802560:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nFreeMemBlocksList:\n");
  802567:	83 ec 0c             	sub    $0xc,%esp
  80256a:	68 60 40 80 00       	push   $0x804060
  80256f:	e8 c0 e4 ff ff       	call   800a34 <cprintf>
  802574:	83 c4 10             	add    $0x10,%esp
	uint8 sorted = 1 ;
  802577:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &FreeMemBlocksList)
  80257b:	a1 38 51 80 00       	mov    0x805138,%eax
  802580:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802583:	eb 56                	jmp    8025db <print_mem_block_lists+0x91>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  802585:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802589:	74 1c                	je     8025a7 <print_mem_block_lists+0x5d>
  80258b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80258e:	8b 50 08             	mov    0x8(%eax),%edx
  802591:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802594:	8b 48 08             	mov    0x8(%eax),%ecx
  802597:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80259a:	8b 40 0c             	mov    0xc(%eax),%eax
  80259d:	01 c8                	add    %ecx,%eax
  80259f:	39 c2                	cmp    %eax,%edx
  8025a1:	73 04                	jae    8025a7 <print_mem_block_lists+0x5d>
			sorted = 0 ;
  8025a3:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  8025a7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025aa:	8b 50 08             	mov    0x8(%eax),%edx
  8025ad:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025b0:	8b 40 0c             	mov    0xc(%eax),%eax
  8025b3:	01 c2                	add    %eax,%edx
  8025b5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025b8:	8b 40 08             	mov    0x8(%eax),%eax
  8025bb:	83 ec 04             	sub    $0x4,%esp
  8025be:	52                   	push   %edx
  8025bf:	50                   	push   %eax
  8025c0:	68 75 40 80 00       	push   $0x804075
  8025c5:	e8 6a e4 ff ff       	call   800a34 <cprintf>
  8025ca:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  8025cd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025d0:	89 45 f0             	mov    %eax,-0x10(%ebp)
	cprintf("\n=========================================\n");
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
	cprintf("\nFreeMemBlocksList:\n");
	uint8 sorted = 1 ;
	LIST_FOREACH(blk, &FreeMemBlocksList)
  8025d3:	a1 40 51 80 00       	mov    0x805140,%eax
  8025d8:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8025db:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8025df:	74 07                	je     8025e8 <print_mem_block_lists+0x9e>
  8025e1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025e4:	8b 00                	mov    (%eax),%eax
  8025e6:	eb 05                	jmp    8025ed <print_mem_block_lists+0xa3>
  8025e8:	b8 00 00 00 00       	mov    $0x0,%eax
  8025ed:	a3 40 51 80 00       	mov    %eax,0x805140
  8025f2:	a1 40 51 80 00       	mov    0x805140,%eax
  8025f7:	85 c0                	test   %eax,%eax
  8025f9:	75 8a                	jne    802585 <print_mem_block_lists+0x3b>
  8025fb:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8025ff:	75 84                	jne    802585 <print_mem_block_lists+0x3b>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;
  802601:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  802605:	75 10                	jne    802617 <print_mem_block_lists+0xcd>
  802607:	83 ec 0c             	sub    $0xc,%esp
  80260a:	68 84 40 80 00       	push   $0x804084
  80260f:	e8 20 e4 ff ff       	call   800a34 <cprintf>
  802614:	83 c4 10             	add    $0x10,%esp

	lastBlk = NULL ;
  802617:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nAllocMemBlocksList:\n");
  80261e:	83 ec 0c             	sub    $0xc,%esp
  802621:	68 a8 40 80 00       	push   $0x8040a8
  802626:	e8 09 e4 ff ff       	call   800a34 <cprintf>
  80262b:	83 c4 10             	add    $0x10,%esp
	sorted = 1 ;
  80262e:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &AllocMemBlocksList)
  802632:	a1 40 50 80 00       	mov    0x805040,%eax
  802637:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80263a:	eb 56                	jmp    802692 <print_mem_block_lists+0x148>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  80263c:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802640:	74 1c                	je     80265e <print_mem_block_lists+0x114>
  802642:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802645:	8b 50 08             	mov    0x8(%eax),%edx
  802648:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80264b:	8b 48 08             	mov    0x8(%eax),%ecx
  80264e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802651:	8b 40 0c             	mov    0xc(%eax),%eax
  802654:	01 c8                	add    %ecx,%eax
  802656:	39 c2                	cmp    %eax,%edx
  802658:	73 04                	jae    80265e <print_mem_block_lists+0x114>
			sorted = 0 ;
  80265a:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  80265e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802661:	8b 50 08             	mov    0x8(%eax),%edx
  802664:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802667:	8b 40 0c             	mov    0xc(%eax),%eax
  80266a:	01 c2                	add    %eax,%edx
  80266c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80266f:	8b 40 08             	mov    0x8(%eax),%eax
  802672:	83 ec 04             	sub    $0x4,%esp
  802675:	52                   	push   %edx
  802676:	50                   	push   %eax
  802677:	68 75 40 80 00       	push   $0x804075
  80267c:	e8 b3 e3 ff ff       	call   800a34 <cprintf>
  802681:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  802684:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802687:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;

	lastBlk = NULL ;
	cprintf("\nAllocMemBlocksList:\n");
	sorted = 1 ;
	LIST_FOREACH(blk, &AllocMemBlocksList)
  80268a:	a1 48 50 80 00       	mov    0x805048,%eax
  80268f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802692:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802696:	74 07                	je     80269f <print_mem_block_lists+0x155>
  802698:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80269b:	8b 00                	mov    (%eax),%eax
  80269d:	eb 05                	jmp    8026a4 <print_mem_block_lists+0x15a>
  80269f:	b8 00 00 00 00       	mov    $0x0,%eax
  8026a4:	a3 48 50 80 00       	mov    %eax,0x805048
  8026a9:	a1 48 50 80 00       	mov    0x805048,%eax
  8026ae:	85 c0                	test   %eax,%eax
  8026b0:	75 8a                	jne    80263c <print_mem_block_lists+0xf2>
  8026b2:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8026b6:	75 84                	jne    80263c <print_mem_block_lists+0xf2>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nAllocMemBlocksList is NOT SORTED!!\n") ;
  8026b8:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  8026bc:	75 10                	jne    8026ce <print_mem_block_lists+0x184>
  8026be:	83 ec 0c             	sub    $0xc,%esp
  8026c1:	68 c0 40 80 00       	push   $0x8040c0
  8026c6:	e8 69 e3 ff ff       	call   800a34 <cprintf>
  8026cb:	83 c4 10             	add    $0x10,%esp
	cprintf("\n=========================================\n");
  8026ce:	83 ec 0c             	sub    $0xc,%esp
  8026d1:	68 34 40 80 00       	push   $0x804034
  8026d6:	e8 59 e3 ff ff       	call   800a34 <cprintf>
  8026db:	83 c4 10             	add    $0x10,%esp

}
  8026de:	90                   	nop
  8026df:	c9                   	leave  
  8026e0:	c3                   	ret    

008026e1 <initialize_MemBlocksList>:

//===============================
// [1] INITIALIZE AVAILABLE LIST:
//===============================
void initialize_MemBlocksList(uint32 numOfBlocks)
{
  8026e1:	55                   	push   %ebp
  8026e2:	89 e5                	mov    %esp,%ebp
  8026e4:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] initialize_MemBlocksList
	// Write your code here, remove the panic and write your code
	//panic("initialize_MemBlocksList() is not implemented yet...!!");
	uint32 n = numOfBlocks;
  8026e7:	8b 45 08             	mov    0x8(%ebp),%eax
  8026ea:	89 45 f0             	mov    %eax,-0x10(%ebp)

	LIST_INIT(&AvailableMemBlocksList);
  8026ed:	c7 05 48 51 80 00 00 	movl   $0x0,0x805148
  8026f4:	00 00 00 
  8026f7:	c7 05 4c 51 80 00 00 	movl   $0x0,0x80514c
  8026fe:	00 00 00 
  802701:	c7 05 54 51 80 00 00 	movl   $0x0,0x805154
  802708:	00 00 00 
	for(int i = 0; i<n;i++)
  80270b:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  802712:	e9 9e 00 00 00       	jmp    8027b5 <initialize_MemBlocksList+0xd4>
	{
		LIST_INSERT_HEAD(&AvailableMemBlocksList, &(MemBlockNodes[i]));
  802717:	a1 50 50 80 00       	mov    0x805050,%eax
  80271c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80271f:	c1 e2 04             	shl    $0x4,%edx
  802722:	01 d0                	add    %edx,%eax
  802724:	85 c0                	test   %eax,%eax
  802726:	75 14                	jne    80273c <initialize_MemBlocksList+0x5b>
  802728:	83 ec 04             	sub    $0x4,%esp
  80272b:	68 e8 40 80 00       	push   $0x8040e8
  802730:	6a 47                	push   $0x47
  802732:	68 0b 41 80 00       	push   $0x80410b
  802737:	e8 44 e0 ff ff       	call   800780 <_panic>
  80273c:	a1 50 50 80 00       	mov    0x805050,%eax
  802741:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802744:	c1 e2 04             	shl    $0x4,%edx
  802747:	01 d0                	add    %edx,%eax
  802749:	8b 15 48 51 80 00    	mov    0x805148,%edx
  80274f:	89 10                	mov    %edx,(%eax)
  802751:	8b 00                	mov    (%eax),%eax
  802753:	85 c0                	test   %eax,%eax
  802755:	74 18                	je     80276f <initialize_MemBlocksList+0x8e>
  802757:	a1 48 51 80 00       	mov    0x805148,%eax
  80275c:	8b 15 50 50 80 00    	mov    0x805050,%edx
  802762:	8b 4d f4             	mov    -0xc(%ebp),%ecx
  802765:	c1 e1 04             	shl    $0x4,%ecx
  802768:	01 ca                	add    %ecx,%edx
  80276a:	89 50 04             	mov    %edx,0x4(%eax)
  80276d:	eb 12                	jmp    802781 <initialize_MemBlocksList+0xa0>
  80276f:	a1 50 50 80 00       	mov    0x805050,%eax
  802774:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802777:	c1 e2 04             	shl    $0x4,%edx
  80277a:	01 d0                	add    %edx,%eax
  80277c:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802781:	a1 50 50 80 00       	mov    0x805050,%eax
  802786:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802789:	c1 e2 04             	shl    $0x4,%edx
  80278c:	01 d0                	add    %edx,%eax
  80278e:	a3 48 51 80 00       	mov    %eax,0x805148
  802793:	a1 50 50 80 00       	mov    0x805050,%eax
  802798:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80279b:	c1 e2 04             	shl    $0x4,%edx
  80279e:	01 d0                	add    %edx,%eax
  8027a0:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8027a7:	a1 54 51 80 00       	mov    0x805154,%eax
  8027ac:	40                   	inc    %eax
  8027ad:	a3 54 51 80 00       	mov    %eax,0x805154
	// Write your code here, remove the panic and write your code
	//panic("initialize_MemBlocksList() is not implemented yet...!!");
	uint32 n = numOfBlocks;

	LIST_INIT(&AvailableMemBlocksList);
	for(int i = 0; i<n;i++)
  8027b2:	ff 45 f4             	incl   -0xc(%ebp)
  8027b5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027b8:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8027bb:	0f 82 56 ff ff ff    	jb     802717 <initialize_MemBlocksList+0x36>
	{
		LIST_INSERT_HEAD(&AvailableMemBlocksList, &(MemBlockNodes[i]));
	}
}
  8027c1:	90                   	nop
  8027c2:	c9                   	leave  
  8027c3:	c3                   	ret    

008027c4 <find_block>:

//===============================
// [2] FIND BLOCK:
//===============================
struct MemBlock *find_block(struct MemBlock_List *blockList, uint32 va)
{
  8027c4:	55                   	push   %ebp
  8027c5:	89 e5                	mov    %esp,%ebp
  8027c7:	83 ec 10             	sub    $0x10,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] find_block
	// Write your code here, remove the panic and write your code
	//panic("find_block() is not implemented yet...!!");
	uint32 virAddress = va;
  8027ca:	8b 45 0c             	mov    0xc(%ebp),%eax
  8027cd:	89 45 f4             	mov    %eax,-0xc(%ebp)
	struct MemBlock* blk;
	int found = 0;
  8027d0:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	LIST_FOREACH(blk, &(AllocMemBlocksList))
  8027d7:	a1 40 50 80 00       	mov    0x805040,%eax
  8027dc:	89 45 fc             	mov    %eax,-0x4(%ebp)
  8027df:	eb 23                	jmp    802804 <find_block+0x40>
	{
		if(blk->sva == virAddress)
  8027e1:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8027e4:	8b 40 08             	mov    0x8(%eax),%eax
  8027e7:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  8027ea:	75 09                	jne    8027f5 <find_block+0x31>
		{
			found = 1;
  8027ec:	c7 45 f8 01 00 00 00 	movl   $0x1,-0x8(%ebp)
			break;
  8027f3:	eb 35                	jmp    80282a <find_block+0x66>
		}
		else
		{
			found = 0;
  8027f5:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	//panic("find_block() is not implemented yet...!!");
	uint32 virAddress = va;
	struct MemBlock* blk;
	int found = 0;

	LIST_FOREACH(blk, &(AllocMemBlocksList))
  8027fc:	a1 48 50 80 00       	mov    0x805048,%eax
  802801:	89 45 fc             	mov    %eax,-0x4(%ebp)
  802804:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  802808:	74 07                	je     802811 <find_block+0x4d>
  80280a:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80280d:	8b 00                	mov    (%eax),%eax
  80280f:	eb 05                	jmp    802816 <find_block+0x52>
  802811:	b8 00 00 00 00       	mov    $0x0,%eax
  802816:	a3 48 50 80 00       	mov    %eax,0x805048
  80281b:	a1 48 50 80 00       	mov    0x805048,%eax
  802820:	85 c0                	test   %eax,%eax
  802822:	75 bd                	jne    8027e1 <find_block+0x1d>
  802824:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  802828:	75 b7                	jne    8027e1 <find_block+0x1d>
		{
			found = 0;
			continue;
		}
	}
	if(found == 1)
  80282a:	83 7d f8 01          	cmpl   $0x1,-0x8(%ebp)
  80282e:	75 05                	jne    802835 <find_block+0x71>
	{
		return blk;
  802830:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802833:	eb 05                	jmp    80283a <find_block+0x76>
	}
	else
	{
		return NULL;
  802835:	b8 00 00 00 00       	mov    $0x0,%eax
	}
}
  80283a:	c9                   	leave  
  80283b:	c3                   	ret    

0080283c <insert_sorted_allocList>:

//=========================================
// [3] INSERT BLOCK IN ALLOC LIST [SORTED]:
//=========================================
void insert_sorted_allocList(struct MemBlock *blockToInsert)
{
  80283c:	55                   	push   %ebp
  80283d:	89 e5                	mov    %esp,%ebp
  80283f:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] insert_sorted_allocList
	// Write your code here, remove the panic and write your code
	//panic("insert_sorted_allocList() is not implemented yet...!!");
	struct MemBlock* blk;
	struct MemBlock* newblk = blockToInsert;
  802842:	8b 45 08             	mov    0x8(%ebp),%eax
  802845:	89 45 f0             	mov    %eax,-0x10(%ebp)

	if((LIST_EMPTY(&AllocMemBlocksList)) || (newblk->sva < LIST_FIRST(&AllocMemBlocksList)->sva))
  802848:	a1 40 50 80 00       	mov    0x805040,%eax
  80284d:	85 c0                	test   %eax,%eax
  80284f:	74 12                	je     802863 <insert_sorted_allocList+0x27>
  802851:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802854:	8b 50 08             	mov    0x8(%eax),%edx
  802857:	a1 40 50 80 00       	mov    0x805040,%eax
  80285c:	8b 40 08             	mov    0x8(%eax),%eax
  80285f:	39 c2                	cmp    %eax,%edx
  802861:	73 65                	jae    8028c8 <insert_sorted_allocList+0x8c>
	{
		LIST_INSERT_HEAD(&(AllocMemBlocksList), newblk);
  802863:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802867:	75 14                	jne    80287d <insert_sorted_allocList+0x41>
  802869:	83 ec 04             	sub    $0x4,%esp
  80286c:	68 e8 40 80 00       	push   $0x8040e8
  802871:	6a 7b                	push   $0x7b
  802873:	68 0b 41 80 00       	push   $0x80410b
  802878:	e8 03 df ff ff       	call   800780 <_panic>
  80287d:	8b 15 40 50 80 00    	mov    0x805040,%edx
  802883:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802886:	89 10                	mov    %edx,(%eax)
  802888:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80288b:	8b 00                	mov    (%eax),%eax
  80288d:	85 c0                	test   %eax,%eax
  80288f:	74 0d                	je     80289e <insert_sorted_allocList+0x62>
  802891:	a1 40 50 80 00       	mov    0x805040,%eax
  802896:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802899:	89 50 04             	mov    %edx,0x4(%eax)
  80289c:	eb 08                	jmp    8028a6 <insert_sorted_allocList+0x6a>
  80289e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8028a1:	a3 44 50 80 00       	mov    %eax,0x805044
  8028a6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8028a9:	a3 40 50 80 00       	mov    %eax,0x805040
  8028ae:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8028b1:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8028b8:	a1 4c 50 80 00       	mov    0x80504c,%eax
  8028bd:	40                   	inc    %eax
  8028be:	a3 4c 50 80 00       	mov    %eax,0x80504c
  8028c3:	e9 5f 01 00 00       	jmp    802a27 <insert_sorted_allocList+0x1eb>
	}
	else if(newblk->sva > LIST_LAST(&AllocMemBlocksList)->sva)
  8028c8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8028cb:	8b 50 08             	mov    0x8(%eax),%edx
  8028ce:	a1 44 50 80 00       	mov    0x805044,%eax
  8028d3:	8b 40 08             	mov    0x8(%eax),%eax
  8028d6:	39 c2                	cmp    %eax,%edx
  8028d8:	76 65                	jbe    80293f <insert_sorted_allocList+0x103>
	{
		LIST_INSERT_TAIL(&AllocMemBlocksList, newblk);
  8028da:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8028de:	75 14                	jne    8028f4 <insert_sorted_allocList+0xb8>
  8028e0:	83 ec 04             	sub    $0x4,%esp
  8028e3:	68 24 41 80 00       	push   $0x804124
  8028e8:	6a 7f                	push   $0x7f
  8028ea:	68 0b 41 80 00       	push   $0x80410b
  8028ef:	e8 8c de ff ff       	call   800780 <_panic>
  8028f4:	8b 15 44 50 80 00    	mov    0x805044,%edx
  8028fa:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8028fd:	89 50 04             	mov    %edx,0x4(%eax)
  802900:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802903:	8b 40 04             	mov    0x4(%eax),%eax
  802906:	85 c0                	test   %eax,%eax
  802908:	74 0c                	je     802916 <insert_sorted_allocList+0xda>
  80290a:	a1 44 50 80 00       	mov    0x805044,%eax
  80290f:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802912:	89 10                	mov    %edx,(%eax)
  802914:	eb 08                	jmp    80291e <insert_sorted_allocList+0xe2>
  802916:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802919:	a3 40 50 80 00       	mov    %eax,0x805040
  80291e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802921:	a3 44 50 80 00       	mov    %eax,0x805044
  802926:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802929:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80292f:	a1 4c 50 80 00       	mov    0x80504c,%eax
  802934:	40                   	inc    %eax
  802935:	a3 4c 50 80 00       	mov    %eax,0x80504c
				LIST_INSERT_AFTER(&AllocMemBlocksList, blk, newblk);
				break;
			}
		}
	}
}
  80293a:	e9 e8 00 00 00       	jmp    802a27 <insert_sorted_allocList+0x1eb>
	{
		LIST_INSERT_TAIL(&AllocMemBlocksList, newblk);
	}
	else
	{
		LIST_FOREACH(blk, &AllocMemBlocksList)
  80293f:	a1 40 50 80 00       	mov    0x805040,%eax
  802944:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802947:	e9 ab 00 00 00       	jmp    8029f7 <insert_sorted_allocList+0x1bb>
		{
			if(blk->prev_next_info.le_next != NULL && newblk->sva > blk->sva  && newblk->sva < blk->prev_next_info.le_next->sva)
  80294c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80294f:	8b 00                	mov    (%eax),%eax
  802951:	85 c0                	test   %eax,%eax
  802953:	0f 84 96 00 00 00    	je     8029ef <insert_sorted_allocList+0x1b3>
  802959:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80295c:	8b 50 08             	mov    0x8(%eax),%edx
  80295f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802962:	8b 40 08             	mov    0x8(%eax),%eax
  802965:	39 c2                	cmp    %eax,%edx
  802967:	0f 86 82 00 00 00    	jbe    8029ef <insert_sorted_allocList+0x1b3>
  80296d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802970:	8b 50 08             	mov    0x8(%eax),%edx
  802973:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802976:	8b 00                	mov    (%eax),%eax
  802978:	8b 40 08             	mov    0x8(%eax),%eax
  80297b:	39 c2                	cmp    %eax,%edx
  80297d:	73 70                	jae    8029ef <insert_sorted_allocList+0x1b3>
			{
				LIST_INSERT_AFTER(&AllocMemBlocksList, blk, newblk);
  80297f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802983:	74 06                	je     80298b <insert_sorted_allocList+0x14f>
  802985:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802989:	75 17                	jne    8029a2 <insert_sorted_allocList+0x166>
  80298b:	83 ec 04             	sub    $0x4,%esp
  80298e:	68 48 41 80 00       	push   $0x804148
  802993:	68 87 00 00 00       	push   $0x87
  802998:	68 0b 41 80 00       	push   $0x80410b
  80299d:	e8 de dd ff ff       	call   800780 <_panic>
  8029a2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029a5:	8b 10                	mov    (%eax),%edx
  8029a7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8029aa:	89 10                	mov    %edx,(%eax)
  8029ac:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8029af:	8b 00                	mov    (%eax),%eax
  8029b1:	85 c0                	test   %eax,%eax
  8029b3:	74 0b                	je     8029c0 <insert_sorted_allocList+0x184>
  8029b5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029b8:	8b 00                	mov    (%eax),%eax
  8029ba:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8029bd:	89 50 04             	mov    %edx,0x4(%eax)
  8029c0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029c3:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8029c6:	89 10                	mov    %edx,(%eax)
  8029c8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8029cb:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8029ce:	89 50 04             	mov    %edx,0x4(%eax)
  8029d1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8029d4:	8b 00                	mov    (%eax),%eax
  8029d6:	85 c0                	test   %eax,%eax
  8029d8:	75 08                	jne    8029e2 <insert_sorted_allocList+0x1a6>
  8029da:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8029dd:	a3 44 50 80 00       	mov    %eax,0x805044
  8029e2:	a1 4c 50 80 00       	mov    0x80504c,%eax
  8029e7:	40                   	inc    %eax
  8029e8:	a3 4c 50 80 00       	mov    %eax,0x80504c
				break;
  8029ed:	eb 38                	jmp    802a27 <insert_sorted_allocList+0x1eb>
	{
		LIST_INSERT_TAIL(&AllocMemBlocksList, newblk);
	}
	else
	{
		LIST_FOREACH(blk, &AllocMemBlocksList)
  8029ef:	a1 48 50 80 00       	mov    0x805048,%eax
  8029f4:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8029f7:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8029fb:	74 07                	je     802a04 <insert_sorted_allocList+0x1c8>
  8029fd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a00:	8b 00                	mov    (%eax),%eax
  802a02:	eb 05                	jmp    802a09 <insert_sorted_allocList+0x1cd>
  802a04:	b8 00 00 00 00       	mov    $0x0,%eax
  802a09:	a3 48 50 80 00       	mov    %eax,0x805048
  802a0e:	a1 48 50 80 00       	mov    0x805048,%eax
  802a13:	85 c0                	test   %eax,%eax
  802a15:	0f 85 31 ff ff ff    	jne    80294c <insert_sorted_allocList+0x110>
  802a1b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802a1f:	0f 85 27 ff ff ff    	jne    80294c <insert_sorted_allocList+0x110>
				LIST_INSERT_AFTER(&AllocMemBlocksList, blk, newblk);
				break;
			}
		}
	}
}
  802a25:	eb 00                	jmp    802a27 <insert_sorted_allocList+0x1eb>
  802a27:	90                   	nop
  802a28:	c9                   	leave  
  802a29:	c3                   	ret    

00802a2a <alloc_block_FF>:

//=========================================
// [4] ALLOCATE BLOCK BY FIRST FIT:
//=========================================
struct MemBlock *alloc_block_FF(uint32 size)
{
  802a2a:	55                   	push   %ebp
  802a2b:	89 e5                	mov    %esp,%ebp
  802a2d:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_FF
	// Write your code here, remove the panic and write your code
	//panic("alloc_block_FF() is not implemented yet...!!");
	uint32 versize = size;
  802a30:	8b 45 08             	mov    0x8(%ebp),%eax
  802a33:	89 45 f0             	mov    %eax,-0x10(%ebp)
	struct MemBlock* blk;
	struct MemBlock* newblk = LIST_FIRST(&AvailableMemBlocksList);
  802a36:	a1 48 51 80 00       	mov    0x805148,%eax
  802a3b:	89 45 ec             	mov    %eax,-0x14(%ebp)

	LIST_FOREACH(blk,&FreeMemBlocksList)
  802a3e:	a1 38 51 80 00       	mov    0x805138,%eax
  802a43:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802a46:	e9 77 01 00 00       	jmp    802bc2 <alloc_block_FF+0x198>
	{
		if(blk->size == versize)
  802a4b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a4e:	8b 40 0c             	mov    0xc(%eax),%eax
  802a51:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  802a54:	0f 85 8a 00 00 00    	jne    802ae4 <alloc_block_FF+0xba>
		{
			LIST_REMOVE(&FreeMemBlocksList,blk);
  802a5a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802a5e:	75 17                	jne    802a77 <alloc_block_FF+0x4d>
  802a60:	83 ec 04             	sub    $0x4,%esp
  802a63:	68 7c 41 80 00       	push   $0x80417c
  802a68:	68 9e 00 00 00       	push   $0x9e
  802a6d:	68 0b 41 80 00       	push   $0x80410b
  802a72:	e8 09 dd ff ff       	call   800780 <_panic>
  802a77:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a7a:	8b 00                	mov    (%eax),%eax
  802a7c:	85 c0                	test   %eax,%eax
  802a7e:	74 10                	je     802a90 <alloc_block_FF+0x66>
  802a80:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a83:	8b 00                	mov    (%eax),%eax
  802a85:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802a88:	8b 52 04             	mov    0x4(%edx),%edx
  802a8b:	89 50 04             	mov    %edx,0x4(%eax)
  802a8e:	eb 0b                	jmp    802a9b <alloc_block_FF+0x71>
  802a90:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a93:	8b 40 04             	mov    0x4(%eax),%eax
  802a96:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802a9b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a9e:	8b 40 04             	mov    0x4(%eax),%eax
  802aa1:	85 c0                	test   %eax,%eax
  802aa3:	74 0f                	je     802ab4 <alloc_block_FF+0x8a>
  802aa5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802aa8:	8b 40 04             	mov    0x4(%eax),%eax
  802aab:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802aae:	8b 12                	mov    (%edx),%edx
  802ab0:	89 10                	mov    %edx,(%eax)
  802ab2:	eb 0a                	jmp    802abe <alloc_block_FF+0x94>
  802ab4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ab7:	8b 00                	mov    (%eax),%eax
  802ab9:	a3 38 51 80 00       	mov    %eax,0x805138
  802abe:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ac1:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802ac7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802aca:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802ad1:	a1 44 51 80 00       	mov    0x805144,%eax
  802ad6:	48                   	dec    %eax
  802ad7:	a3 44 51 80 00       	mov    %eax,0x805144
			return blk;
  802adc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802adf:	e9 11 01 00 00       	jmp    802bf5 <alloc_block_FF+0x1cb>
		}
		else if(blk->size > versize)
  802ae4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ae7:	8b 40 0c             	mov    0xc(%eax),%eax
  802aea:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  802aed:	0f 86 c7 00 00 00    	jbe    802bba <alloc_block_FF+0x190>
		{
			LIST_REMOVE(&AvailableMemBlocksList,newblk);
  802af3:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802af7:	75 17                	jne    802b10 <alloc_block_FF+0xe6>
  802af9:	83 ec 04             	sub    $0x4,%esp
  802afc:	68 7c 41 80 00       	push   $0x80417c
  802b01:	68 a3 00 00 00       	push   $0xa3
  802b06:	68 0b 41 80 00       	push   $0x80410b
  802b0b:	e8 70 dc ff ff       	call   800780 <_panic>
  802b10:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802b13:	8b 00                	mov    (%eax),%eax
  802b15:	85 c0                	test   %eax,%eax
  802b17:	74 10                	je     802b29 <alloc_block_FF+0xff>
  802b19:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802b1c:	8b 00                	mov    (%eax),%eax
  802b1e:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802b21:	8b 52 04             	mov    0x4(%edx),%edx
  802b24:	89 50 04             	mov    %edx,0x4(%eax)
  802b27:	eb 0b                	jmp    802b34 <alloc_block_FF+0x10a>
  802b29:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802b2c:	8b 40 04             	mov    0x4(%eax),%eax
  802b2f:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802b34:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802b37:	8b 40 04             	mov    0x4(%eax),%eax
  802b3a:	85 c0                	test   %eax,%eax
  802b3c:	74 0f                	je     802b4d <alloc_block_FF+0x123>
  802b3e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802b41:	8b 40 04             	mov    0x4(%eax),%eax
  802b44:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802b47:	8b 12                	mov    (%edx),%edx
  802b49:	89 10                	mov    %edx,(%eax)
  802b4b:	eb 0a                	jmp    802b57 <alloc_block_FF+0x12d>
  802b4d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802b50:	8b 00                	mov    (%eax),%eax
  802b52:	a3 48 51 80 00       	mov    %eax,0x805148
  802b57:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802b5a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802b60:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802b63:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802b6a:	a1 54 51 80 00       	mov    0x805154,%eax
  802b6f:	48                   	dec    %eax
  802b70:	a3 54 51 80 00       	mov    %eax,0x805154
			newblk->size = versize;
  802b75:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802b78:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802b7b:	89 50 0c             	mov    %edx,0xc(%eax)
			blk->size = blk->size-versize;
  802b7e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b81:	8b 40 0c             	mov    0xc(%eax),%eax
  802b84:	2b 45 f0             	sub    -0x10(%ebp),%eax
  802b87:	89 c2                	mov    %eax,%edx
  802b89:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b8c:	89 50 0c             	mov    %edx,0xc(%eax)
			uint32 newveradd = blk->sva;
  802b8f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b92:	8b 40 08             	mov    0x8(%eax),%eax
  802b95:	89 45 e8             	mov    %eax,-0x18(%ebp)
			blk->sva+=newblk->size;
  802b98:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b9b:	8b 50 08             	mov    0x8(%eax),%edx
  802b9e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802ba1:	8b 40 0c             	mov    0xc(%eax),%eax
  802ba4:	01 c2                	add    %eax,%edx
  802ba6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ba9:	89 50 08             	mov    %edx,0x8(%eax)
			newblk->sva = newveradd;
  802bac:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802baf:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802bb2:	89 50 08             	mov    %edx,0x8(%eax)
			return newblk;
  802bb5:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802bb8:	eb 3b                	jmp    802bf5 <alloc_block_FF+0x1cb>
	//panic("alloc_block_FF() is not implemented yet...!!");
	uint32 versize = size;
	struct MemBlock* blk;
	struct MemBlock* newblk = LIST_FIRST(&AvailableMemBlocksList);

	LIST_FOREACH(blk,&FreeMemBlocksList)
  802bba:	a1 40 51 80 00       	mov    0x805140,%eax
  802bbf:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802bc2:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802bc6:	74 07                	je     802bcf <alloc_block_FF+0x1a5>
  802bc8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bcb:	8b 00                	mov    (%eax),%eax
  802bcd:	eb 05                	jmp    802bd4 <alloc_block_FF+0x1aa>
  802bcf:	b8 00 00 00 00       	mov    $0x0,%eax
  802bd4:	a3 40 51 80 00       	mov    %eax,0x805140
  802bd9:	a1 40 51 80 00       	mov    0x805140,%eax
  802bde:	85 c0                	test   %eax,%eax
  802be0:	0f 85 65 fe ff ff    	jne    802a4b <alloc_block_FF+0x21>
  802be6:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802bea:	0f 85 5b fe ff ff    	jne    802a4b <alloc_block_FF+0x21>
			blk->sva+=newblk->size;
			newblk->sva = newveradd;
			return newblk;
		}
	}
	return NULL;
  802bf0:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802bf5:	c9                   	leave  
  802bf6:	c3                   	ret    

00802bf7 <alloc_block_BF>:

//=========================================
// [5] ALLOCATE BLOCK BY BEST FIT:
//=========================================
struct MemBlock *alloc_block_BF(uint32 size)
{
  802bf7:	55                   	push   %ebp
  802bf8:	89 e5                	mov    %esp,%ebp
  802bfa:	83 ec 28             	sub    $0x28,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_BF
	// Write your code here, remove the panic and write your code
	//panic("alloc_block_BF() is not implemented yet...!!");
	uint32 versize=size;
  802bfd:	8b 45 08             	mov    0x8(%ebp),%eax
  802c00:	89 45 e8             	mov    %eax,-0x18(%ebp)
	struct MemBlock* blk;
	struct MemBlock* newblk=LIST_FIRST(&AvailableMemBlocksList);
  802c03:	a1 48 51 80 00       	mov    0x805148,%eax
  802c08:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	uint32 newveradd;
	uint32 newsize;
	int size_free = LIST_SIZE(&FreeMemBlocksList);
  802c0b:	a1 44 51 80 00       	mov    0x805144,%eax
  802c10:	89 45 e0             	mov    %eax,-0x20(%ebp)

	LIST_FOREACH(blk, &FreeMemBlocksList)
  802c13:	a1 38 51 80 00       	mov    0x805138,%eax
  802c18:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802c1b:	e9 a1 00 00 00       	jmp    802cc1 <alloc_block_BF+0xca>
	{
		if(blk->size == versize)
  802c20:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c23:	8b 40 0c             	mov    0xc(%eax),%eax
  802c26:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  802c29:	0f 85 8a 00 00 00    	jne    802cb9 <alloc_block_BF+0xc2>
		{
			LIST_REMOVE(&FreeMemBlocksList, blk);
  802c2f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802c33:	75 17                	jne    802c4c <alloc_block_BF+0x55>
  802c35:	83 ec 04             	sub    $0x4,%esp
  802c38:	68 7c 41 80 00       	push   $0x80417c
  802c3d:	68 c2 00 00 00       	push   $0xc2
  802c42:	68 0b 41 80 00       	push   $0x80410b
  802c47:	e8 34 db ff ff       	call   800780 <_panic>
  802c4c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c4f:	8b 00                	mov    (%eax),%eax
  802c51:	85 c0                	test   %eax,%eax
  802c53:	74 10                	je     802c65 <alloc_block_BF+0x6e>
  802c55:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c58:	8b 00                	mov    (%eax),%eax
  802c5a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802c5d:	8b 52 04             	mov    0x4(%edx),%edx
  802c60:	89 50 04             	mov    %edx,0x4(%eax)
  802c63:	eb 0b                	jmp    802c70 <alloc_block_BF+0x79>
  802c65:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c68:	8b 40 04             	mov    0x4(%eax),%eax
  802c6b:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802c70:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c73:	8b 40 04             	mov    0x4(%eax),%eax
  802c76:	85 c0                	test   %eax,%eax
  802c78:	74 0f                	je     802c89 <alloc_block_BF+0x92>
  802c7a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c7d:	8b 40 04             	mov    0x4(%eax),%eax
  802c80:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802c83:	8b 12                	mov    (%edx),%edx
  802c85:	89 10                	mov    %edx,(%eax)
  802c87:	eb 0a                	jmp    802c93 <alloc_block_BF+0x9c>
  802c89:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c8c:	8b 00                	mov    (%eax),%eax
  802c8e:	a3 38 51 80 00       	mov    %eax,0x805138
  802c93:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c96:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802c9c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c9f:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802ca6:	a1 44 51 80 00       	mov    0x805144,%eax
  802cab:	48                   	dec    %eax
  802cac:	a3 44 51 80 00       	mov    %eax,0x805144
			return blk;
  802cb1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cb4:	e9 11 02 00 00       	jmp    802eca <alloc_block_BF+0x2d3>
	struct MemBlock* newblk=LIST_FIRST(&AvailableMemBlocksList);
	uint32 newveradd;
	uint32 newsize;
	int size_free = LIST_SIZE(&FreeMemBlocksList);

	LIST_FOREACH(blk, &FreeMemBlocksList)
  802cb9:	a1 40 51 80 00       	mov    0x805140,%eax
  802cbe:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802cc1:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802cc5:	74 07                	je     802cce <alloc_block_BF+0xd7>
  802cc7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cca:	8b 00                	mov    (%eax),%eax
  802ccc:	eb 05                	jmp    802cd3 <alloc_block_BF+0xdc>
  802cce:	b8 00 00 00 00       	mov    $0x0,%eax
  802cd3:	a3 40 51 80 00       	mov    %eax,0x805140
  802cd8:	a1 40 51 80 00       	mov    0x805140,%eax
  802cdd:	85 c0                	test   %eax,%eax
  802cdf:	0f 85 3b ff ff ff    	jne    802c20 <alloc_block_BF+0x29>
  802ce5:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802ce9:	0f 85 31 ff ff ff    	jne    802c20 <alloc_block_BF+0x29>
		{
			LIST_REMOVE(&FreeMemBlocksList, blk);
			return blk;
		}
	}
	LIST_FOREACH(blk, &FreeMemBlocksList)
  802cef:	a1 38 51 80 00       	mov    0x805138,%eax
  802cf4:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802cf7:	eb 27                	jmp    802d20 <alloc_block_BF+0x129>
	{
		if(blk->size > versize)
  802cf9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cfc:	8b 40 0c             	mov    0xc(%eax),%eax
  802cff:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  802d02:	76 14                	jbe    802d18 <alloc_block_BF+0x121>
		{
			newsize = blk->size;
  802d04:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d07:	8b 40 0c             	mov    0xc(%eax),%eax
  802d0a:	89 45 ec             	mov    %eax,-0x14(%ebp)
			newveradd = blk->sva;
  802d0d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d10:	8b 40 08             	mov    0x8(%eax),%eax
  802d13:	89 45 f0             	mov    %eax,-0x10(%ebp)
			break;
  802d16:	eb 2e                	jmp    802d46 <alloc_block_BF+0x14f>
		{
			LIST_REMOVE(&FreeMemBlocksList, blk);
			return blk;
		}
	}
	LIST_FOREACH(blk, &FreeMemBlocksList)
  802d18:	a1 40 51 80 00       	mov    0x805140,%eax
  802d1d:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802d20:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802d24:	74 07                	je     802d2d <alloc_block_BF+0x136>
  802d26:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d29:	8b 00                	mov    (%eax),%eax
  802d2b:	eb 05                	jmp    802d32 <alloc_block_BF+0x13b>
  802d2d:	b8 00 00 00 00       	mov    $0x0,%eax
  802d32:	a3 40 51 80 00       	mov    %eax,0x805140
  802d37:	a1 40 51 80 00       	mov    0x805140,%eax
  802d3c:	85 c0                	test   %eax,%eax
  802d3e:	75 b9                	jne    802cf9 <alloc_block_BF+0x102>
  802d40:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802d44:	75 b3                	jne    802cf9 <alloc_block_BF+0x102>
			newsize = blk->size;
			newveradd = blk->sva;
			break;
		}
	}
	LIST_FOREACH(blk, &FreeMemBlocksList)
  802d46:	a1 38 51 80 00       	mov    0x805138,%eax
  802d4b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802d4e:	eb 30                	jmp    802d80 <alloc_block_BF+0x189>
	{
		if(newsize > blk->size && blk->size > versize)
  802d50:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d53:	8b 40 0c             	mov    0xc(%eax),%eax
  802d56:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  802d59:	73 1d                	jae    802d78 <alloc_block_BF+0x181>
  802d5b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d5e:	8b 40 0c             	mov    0xc(%eax),%eax
  802d61:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  802d64:	76 12                	jbe    802d78 <alloc_block_BF+0x181>
		{
	       newsize = blk->size;
  802d66:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d69:	8b 40 0c             	mov    0xc(%eax),%eax
  802d6c:	89 45 ec             	mov    %eax,-0x14(%ebp)
		   newveradd = blk->sva;
  802d6f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d72:	8b 40 08             	mov    0x8(%eax),%eax
  802d75:	89 45 f0             	mov    %eax,-0x10(%ebp)
			newsize = blk->size;
			newveradd = blk->sva;
			break;
		}
	}
	LIST_FOREACH(blk, &FreeMemBlocksList)
  802d78:	a1 40 51 80 00       	mov    0x805140,%eax
  802d7d:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802d80:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802d84:	74 07                	je     802d8d <alloc_block_BF+0x196>
  802d86:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d89:	8b 00                	mov    (%eax),%eax
  802d8b:	eb 05                	jmp    802d92 <alloc_block_BF+0x19b>
  802d8d:	b8 00 00 00 00       	mov    $0x0,%eax
  802d92:	a3 40 51 80 00       	mov    %eax,0x805140
  802d97:	a1 40 51 80 00       	mov    0x805140,%eax
  802d9c:	85 c0                	test   %eax,%eax
  802d9e:	75 b0                	jne    802d50 <alloc_block_BF+0x159>
  802da0:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802da4:	75 aa                	jne    802d50 <alloc_block_BF+0x159>
		{
	       newsize = blk->size;
		   newveradd = blk->sva;
		}
	}
	LIST_FOREACH(blk, &FreeMemBlocksList)
  802da6:	a1 38 51 80 00       	mov    0x805138,%eax
  802dab:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802dae:	e9 e4 00 00 00       	jmp    802e97 <alloc_block_BF+0x2a0>
	{
		if(blk->size == newsize && blk->sva == newveradd)
  802db3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802db6:	8b 40 0c             	mov    0xc(%eax),%eax
  802db9:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  802dbc:	0f 85 cd 00 00 00    	jne    802e8f <alloc_block_BF+0x298>
  802dc2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802dc5:	8b 40 08             	mov    0x8(%eax),%eax
  802dc8:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  802dcb:	0f 85 be 00 00 00    	jne    802e8f <alloc_block_BF+0x298>
		{
			LIST_REMOVE(&AvailableMemBlocksList, newblk);
  802dd1:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  802dd5:	75 17                	jne    802dee <alloc_block_BF+0x1f7>
  802dd7:	83 ec 04             	sub    $0x4,%esp
  802dda:	68 7c 41 80 00       	push   $0x80417c
  802ddf:	68 db 00 00 00       	push   $0xdb
  802de4:	68 0b 41 80 00       	push   $0x80410b
  802de9:	e8 92 d9 ff ff       	call   800780 <_panic>
  802dee:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802df1:	8b 00                	mov    (%eax),%eax
  802df3:	85 c0                	test   %eax,%eax
  802df5:	74 10                	je     802e07 <alloc_block_BF+0x210>
  802df7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802dfa:	8b 00                	mov    (%eax),%eax
  802dfc:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802dff:	8b 52 04             	mov    0x4(%edx),%edx
  802e02:	89 50 04             	mov    %edx,0x4(%eax)
  802e05:	eb 0b                	jmp    802e12 <alloc_block_BF+0x21b>
  802e07:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802e0a:	8b 40 04             	mov    0x4(%eax),%eax
  802e0d:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802e12:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802e15:	8b 40 04             	mov    0x4(%eax),%eax
  802e18:	85 c0                	test   %eax,%eax
  802e1a:	74 0f                	je     802e2b <alloc_block_BF+0x234>
  802e1c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802e1f:	8b 40 04             	mov    0x4(%eax),%eax
  802e22:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802e25:	8b 12                	mov    (%edx),%edx
  802e27:	89 10                	mov    %edx,(%eax)
  802e29:	eb 0a                	jmp    802e35 <alloc_block_BF+0x23e>
  802e2b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802e2e:	8b 00                	mov    (%eax),%eax
  802e30:	a3 48 51 80 00       	mov    %eax,0x805148
  802e35:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802e38:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802e3e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802e41:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802e48:	a1 54 51 80 00       	mov    0x805154,%eax
  802e4d:	48                   	dec    %eax
  802e4e:	a3 54 51 80 00       	mov    %eax,0x805154
			newblk->size = versize;
  802e53:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802e56:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802e59:	89 50 0c             	mov    %edx,0xc(%eax)
			newblk->sva = newveradd;
  802e5c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802e5f:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802e62:	89 50 08             	mov    %edx,0x8(%eax)
			blk->size = blk->size - versize;
  802e65:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e68:	8b 40 0c             	mov    0xc(%eax),%eax
  802e6b:	2b 45 e8             	sub    -0x18(%ebp),%eax
  802e6e:	89 c2                	mov    %eax,%edx
  802e70:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e73:	89 50 0c             	mov    %edx,0xc(%eax)
			blk->sva+= newblk->size;
  802e76:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e79:	8b 50 08             	mov    0x8(%eax),%edx
  802e7c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802e7f:	8b 40 0c             	mov    0xc(%eax),%eax
  802e82:	01 c2                	add    %eax,%edx
  802e84:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e87:	89 50 08             	mov    %edx,0x8(%eax)
			return newblk;
  802e8a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802e8d:	eb 3b                	jmp    802eca <alloc_block_BF+0x2d3>
		{
	       newsize = blk->size;
		   newveradd = blk->sva;
		}
	}
	LIST_FOREACH(blk, &FreeMemBlocksList)
  802e8f:	a1 40 51 80 00       	mov    0x805140,%eax
  802e94:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802e97:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802e9b:	74 07                	je     802ea4 <alloc_block_BF+0x2ad>
  802e9d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ea0:	8b 00                	mov    (%eax),%eax
  802ea2:	eb 05                	jmp    802ea9 <alloc_block_BF+0x2b2>
  802ea4:	b8 00 00 00 00       	mov    $0x0,%eax
  802ea9:	a3 40 51 80 00       	mov    %eax,0x805140
  802eae:	a1 40 51 80 00       	mov    0x805140,%eax
  802eb3:	85 c0                	test   %eax,%eax
  802eb5:	0f 85 f8 fe ff ff    	jne    802db3 <alloc_block_BF+0x1bc>
  802ebb:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802ebf:	0f 85 ee fe ff ff    	jne    802db3 <alloc_block_BF+0x1bc>
			blk->size = blk->size - versize;
			blk->sva+= newblk->size;
			return newblk;
		}
	}
	return NULL;
  802ec5:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802eca:	c9                   	leave  
  802ecb:	c3                   	ret    

00802ecc <alloc_block_NF>:
//=========================================
// [7] ALLOCATE BLOCK BY NEXT FIT:
//=========================================
struct MemBlock *last_allocate;
struct MemBlock *alloc_block_NF(uint32 size)
{
  802ecc:	55                   	push   %ebp
  802ecd:	89 e5                	mov    %esp,%ebp
  802ecf:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1 - BONUS] [DYNAMIC ALLOCATOR] alloc_block_NF
	// Write your code here, remove the panic and write your code
	//panic("alloc_block_NF() is not implemented yet...!!");
	uint32 versize = size;
  802ed2:	8b 45 08             	mov    0x8(%ebp),%eax
  802ed5:	89 45 f0             	mov    %eax,-0x10(%ebp)
	struct MemBlock* blk;
	struct MemBlock* newblk = LIST_FIRST(&AvailableMemBlocksList);
  802ed8:	a1 48 51 80 00       	mov    0x805148,%eax
  802edd:	89 45 ec             	mov    %eax,-0x14(%ebp)

	LIST_FOREACH(blk,&FreeMemBlocksList)
  802ee0:	a1 38 51 80 00       	mov    0x805138,%eax
  802ee5:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802ee8:	e9 77 01 00 00       	jmp    803064 <alloc_block_NF+0x198>
	{
		if(blk->size == versize)
  802eed:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ef0:	8b 40 0c             	mov    0xc(%eax),%eax
  802ef3:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  802ef6:	0f 85 8a 00 00 00    	jne    802f86 <alloc_block_NF+0xba>
		{
			LIST_REMOVE(&FreeMemBlocksList,blk);
  802efc:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802f00:	75 17                	jne    802f19 <alloc_block_NF+0x4d>
  802f02:	83 ec 04             	sub    $0x4,%esp
  802f05:	68 7c 41 80 00       	push   $0x80417c
  802f0a:	68 f7 00 00 00       	push   $0xf7
  802f0f:	68 0b 41 80 00       	push   $0x80410b
  802f14:	e8 67 d8 ff ff       	call   800780 <_panic>
  802f19:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f1c:	8b 00                	mov    (%eax),%eax
  802f1e:	85 c0                	test   %eax,%eax
  802f20:	74 10                	je     802f32 <alloc_block_NF+0x66>
  802f22:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f25:	8b 00                	mov    (%eax),%eax
  802f27:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802f2a:	8b 52 04             	mov    0x4(%edx),%edx
  802f2d:	89 50 04             	mov    %edx,0x4(%eax)
  802f30:	eb 0b                	jmp    802f3d <alloc_block_NF+0x71>
  802f32:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f35:	8b 40 04             	mov    0x4(%eax),%eax
  802f38:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802f3d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f40:	8b 40 04             	mov    0x4(%eax),%eax
  802f43:	85 c0                	test   %eax,%eax
  802f45:	74 0f                	je     802f56 <alloc_block_NF+0x8a>
  802f47:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f4a:	8b 40 04             	mov    0x4(%eax),%eax
  802f4d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802f50:	8b 12                	mov    (%edx),%edx
  802f52:	89 10                	mov    %edx,(%eax)
  802f54:	eb 0a                	jmp    802f60 <alloc_block_NF+0x94>
  802f56:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f59:	8b 00                	mov    (%eax),%eax
  802f5b:	a3 38 51 80 00       	mov    %eax,0x805138
  802f60:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f63:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802f69:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f6c:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802f73:	a1 44 51 80 00       	mov    0x805144,%eax
  802f78:	48                   	dec    %eax
  802f79:	a3 44 51 80 00       	mov    %eax,0x805144
			return blk;
  802f7e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f81:	e9 11 01 00 00       	jmp    803097 <alloc_block_NF+0x1cb>
		}
		else if(blk->size > versize)
  802f86:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f89:	8b 40 0c             	mov    0xc(%eax),%eax
  802f8c:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  802f8f:	0f 86 c7 00 00 00    	jbe    80305c <alloc_block_NF+0x190>
		{
			LIST_REMOVE(&AvailableMemBlocksList,newblk);
  802f95:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802f99:	75 17                	jne    802fb2 <alloc_block_NF+0xe6>
  802f9b:	83 ec 04             	sub    $0x4,%esp
  802f9e:	68 7c 41 80 00       	push   $0x80417c
  802fa3:	68 fc 00 00 00       	push   $0xfc
  802fa8:	68 0b 41 80 00       	push   $0x80410b
  802fad:	e8 ce d7 ff ff       	call   800780 <_panic>
  802fb2:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802fb5:	8b 00                	mov    (%eax),%eax
  802fb7:	85 c0                	test   %eax,%eax
  802fb9:	74 10                	je     802fcb <alloc_block_NF+0xff>
  802fbb:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802fbe:	8b 00                	mov    (%eax),%eax
  802fc0:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802fc3:	8b 52 04             	mov    0x4(%edx),%edx
  802fc6:	89 50 04             	mov    %edx,0x4(%eax)
  802fc9:	eb 0b                	jmp    802fd6 <alloc_block_NF+0x10a>
  802fcb:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802fce:	8b 40 04             	mov    0x4(%eax),%eax
  802fd1:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802fd6:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802fd9:	8b 40 04             	mov    0x4(%eax),%eax
  802fdc:	85 c0                	test   %eax,%eax
  802fde:	74 0f                	je     802fef <alloc_block_NF+0x123>
  802fe0:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802fe3:	8b 40 04             	mov    0x4(%eax),%eax
  802fe6:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802fe9:	8b 12                	mov    (%edx),%edx
  802feb:	89 10                	mov    %edx,(%eax)
  802fed:	eb 0a                	jmp    802ff9 <alloc_block_NF+0x12d>
  802fef:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802ff2:	8b 00                	mov    (%eax),%eax
  802ff4:	a3 48 51 80 00       	mov    %eax,0x805148
  802ff9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802ffc:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803002:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803005:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80300c:	a1 54 51 80 00       	mov    0x805154,%eax
  803011:	48                   	dec    %eax
  803012:	a3 54 51 80 00       	mov    %eax,0x805154
			newblk->size = versize;
  803017:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80301a:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80301d:	89 50 0c             	mov    %edx,0xc(%eax)
			blk->size = blk->size-versize;
  803020:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803023:	8b 40 0c             	mov    0xc(%eax),%eax
  803026:	2b 45 f0             	sub    -0x10(%ebp),%eax
  803029:	89 c2                	mov    %eax,%edx
  80302b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80302e:	89 50 0c             	mov    %edx,0xc(%eax)
			uint32 newveradd = blk->sva;
  803031:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803034:	8b 40 08             	mov    0x8(%eax),%eax
  803037:	89 45 e8             	mov    %eax,-0x18(%ebp)
			blk->sva+=newblk->size;
  80303a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80303d:	8b 50 08             	mov    0x8(%eax),%edx
  803040:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803043:	8b 40 0c             	mov    0xc(%eax),%eax
  803046:	01 c2                	add    %eax,%edx
  803048:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80304b:	89 50 08             	mov    %edx,0x8(%eax)
			newblk->sva = newveradd;
  80304e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803051:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803054:	89 50 08             	mov    %edx,0x8(%eax)
			return newblk;
  803057:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80305a:	eb 3b                	jmp    803097 <alloc_block_NF+0x1cb>
	//panic("alloc_block_NF() is not implemented yet...!!");
	uint32 versize = size;
	struct MemBlock* blk;
	struct MemBlock* newblk = LIST_FIRST(&AvailableMemBlocksList);

	LIST_FOREACH(blk,&FreeMemBlocksList)
  80305c:	a1 40 51 80 00       	mov    0x805140,%eax
  803061:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803064:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803068:	74 07                	je     803071 <alloc_block_NF+0x1a5>
  80306a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80306d:	8b 00                	mov    (%eax),%eax
  80306f:	eb 05                	jmp    803076 <alloc_block_NF+0x1aa>
  803071:	b8 00 00 00 00       	mov    $0x0,%eax
  803076:	a3 40 51 80 00       	mov    %eax,0x805140
  80307b:	a1 40 51 80 00       	mov    0x805140,%eax
  803080:	85 c0                	test   %eax,%eax
  803082:	0f 85 65 fe ff ff    	jne    802eed <alloc_block_NF+0x21>
  803088:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80308c:	0f 85 5b fe ff ff    	jne    802eed <alloc_block_NF+0x21>
			blk->sva+=newblk->size;
			newblk->sva = newveradd;
			return newblk;
		}
	}
	return NULL;
  803092:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803097:	c9                   	leave  
  803098:	c3                   	ret    

00803099 <addToAvailMemBlocksList>:

//===================================================
// [8] INSERT BLOCK (SORTED WITH MERGE) IN FREE LIST:
//===================================================
void addToAvailMemBlocksList(struct MemBlock *blockToInsert)
{
  803099:	55                   	push   %ebp
  80309a:	89 e5                	mov    %esp,%ebp
  80309c:	83 ec 08             	sub    $0x8,%esp
	blockToInsert->sva = 0;
  80309f:	8b 45 08             	mov    0x8(%ebp),%eax
  8030a2:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
	blockToInsert->size = 0;
  8030a9:	8b 45 08             	mov    0x8(%ebp),%eax
  8030ac:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
	//add to avail
	LIST_INSERT_TAIL(&AvailableMemBlocksList, blockToInsert);
  8030b3:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8030b7:	75 17                	jne    8030d0 <addToAvailMemBlocksList+0x37>
  8030b9:	83 ec 04             	sub    $0x4,%esp
  8030bc:	68 24 41 80 00       	push   $0x804124
  8030c1:	68 10 01 00 00       	push   $0x110
  8030c6:	68 0b 41 80 00       	push   $0x80410b
  8030cb:	e8 b0 d6 ff ff       	call   800780 <_panic>
  8030d0:	8b 15 4c 51 80 00    	mov    0x80514c,%edx
  8030d6:	8b 45 08             	mov    0x8(%ebp),%eax
  8030d9:	89 50 04             	mov    %edx,0x4(%eax)
  8030dc:	8b 45 08             	mov    0x8(%ebp),%eax
  8030df:	8b 40 04             	mov    0x4(%eax),%eax
  8030e2:	85 c0                	test   %eax,%eax
  8030e4:	74 0c                	je     8030f2 <addToAvailMemBlocksList+0x59>
  8030e6:	a1 4c 51 80 00       	mov    0x80514c,%eax
  8030eb:	8b 55 08             	mov    0x8(%ebp),%edx
  8030ee:	89 10                	mov    %edx,(%eax)
  8030f0:	eb 08                	jmp    8030fa <addToAvailMemBlocksList+0x61>
  8030f2:	8b 45 08             	mov    0x8(%ebp),%eax
  8030f5:	a3 48 51 80 00       	mov    %eax,0x805148
  8030fa:	8b 45 08             	mov    0x8(%ebp),%eax
  8030fd:	a3 4c 51 80 00       	mov    %eax,0x80514c
  803102:	8b 45 08             	mov    0x8(%ebp),%eax
  803105:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80310b:	a1 54 51 80 00       	mov    0x805154,%eax
  803110:	40                   	inc    %eax
  803111:	a3 54 51 80 00       	mov    %eax,0x805154
}
  803116:	90                   	nop
  803117:	c9                   	leave  
  803118:	c3                   	ret    

00803119 <insert_sorted_with_merge_freeList>:
void insert_sorted_with_merge_freeList(struct MemBlock *blockToInsert)
{
  803119:	55                   	push   %ebp
  80311a:	89 e5                	mov    %esp,%ebp
  80311c:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] insert_sorted_with_merge_freeList
	// Write your code here, remove the panic and write your code

	struct MemBlock* last = LIST_LAST(&FreeMemBlocksList);
  80311f:	a1 3c 51 80 00       	mov    0x80513c,%eax
  803124:	89 45 f0             	mov    %eax,-0x10(%ebp)
	//check if list empty
	if (LIST_SIZE(&(FreeMemBlocksList)) == 0)
  803127:	a1 44 51 80 00       	mov    0x805144,%eax
  80312c:	85 c0                	test   %eax,%eax
  80312e:	75 68                	jne    803198 <insert_sorted_with_merge_freeList+0x7f>
		LIST_INSERT_HEAD(&FreeMemBlocksList, blockToInsert);
  803130:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803134:	75 17                	jne    80314d <insert_sorted_with_merge_freeList+0x34>
  803136:	83 ec 04             	sub    $0x4,%esp
  803139:	68 e8 40 80 00       	push   $0x8040e8
  80313e:	68 1a 01 00 00       	push   $0x11a
  803143:	68 0b 41 80 00       	push   $0x80410b
  803148:	e8 33 d6 ff ff       	call   800780 <_panic>
  80314d:	8b 15 38 51 80 00    	mov    0x805138,%edx
  803153:	8b 45 08             	mov    0x8(%ebp),%eax
  803156:	89 10                	mov    %edx,(%eax)
  803158:	8b 45 08             	mov    0x8(%ebp),%eax
  80315b:	8b 00                	mov    (%eax),%eax
  80315d:	85 c0                	test   %eax,%eax
  80315f:	74 0d                	je     80316e <insert_sorted_with_merge_freeList+0x55>
  803161:	a1 38 51 80 00       	mov    0x805138,%eax
  803166:	8b 55 08             	mov    0x8(%ebp),%edx
  803169:	89 50 04             	mov    %edx,0x4(%eax)
  80316c:	eb 08                	jmp    803176 <insert_sorted_with_merge_freeList+0x5d>
  80316e:	8b 45 08             	mov    0x8(%ebp),%eax
  803171:	a3 3c 51 80 00       	mov    %eax,0x80513c
  803176:	8b 45 08             	mov    0x8(%ebp),%eax
  803179:	a3 38 51 80 00       	mov    %eax,0x805138
  80317e:	8b 45 08             	mov    0x8(%ebp),%eax
  803181:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803188:	a1 44 51 80 00       	mov    0x805144,%eax
  80318d:	40                   	inc    %eax
  80318e:	a3 44 51 80 00       	mov    %eax,0x805144
		}
	}

	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  803193:	e9 c5 03 00 00       	jmp    80355d <insert_sorted_with_merge_freeList+0x444>
	struct MemBlock* last = LIST_LAST(&FreeMemBlocksList);
	//check if list empty
	if (LIST_SIZE(&(FreeMemBlocksList)) == 0)
		LIST_INSERT_HEAD(&FreeMemBlocksList, blockToInsert);
	//check if it's position is at last
	else if (last->sva < blockToInsert->sva) {
  803198:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80319b:	8b 50 08             	mov    0x8(%eax),%edx
  80319e:	8b 45 08             	mov    0x8(%ebp),%eax
  8031a1:	8b 40 08             	mov    0x8(%eax),%eax
  8031a4:	39 c2                	cmp    %eax,%edx
  8031a6:	0f 83 b2 00 00 00    	jae    80325e <insert_sorted_with_merge_freeList+0x145>

		//if i have to merge
		if (last->sva + last->size == blockToInsert->sva) {
  8031ac:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8031af:	8b 50 08             	mov    0x8(%eax),%edx
  8031b2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8031b5:	8b 40 0c             	mov    0xc(%eax),%eax
  8031b8:	01 c2                	add    %eax,%edx
  8031ba:	8b 45 08             	mov    0x8(%ebp),%eax
  8031bd:	8b 40 08             	mov    0x8(%eax),%eax
  8031c0:	39 c2                	cmp    %eax,%edx
  8031c2:	75 27                	jne    8031eb <insert_sorted_with_merge_freeList+0xd2>
			last->size = last->size + blockToInsert->size;
  8031c4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8031c7:	8b 50 0c             	mov    0xc(%eax),%edx
  8031ca:	8b 45 08             	mov    0x8(%ebp),%eax
  8031cd:	8b 40 0c             	mov    0xc(%eax),%eax
  8031d0:	01 c2                	add    %eax,%edx
  8031d2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8031d5:	89 50 0c             	mov    %edx,0xc(%eax)
			addToAvailMemBlocksList(blockToInsert);
  8031d8:	83 ec 0c             	sub    $0xc,%esp
  8031db:	ff 75 08             	pushl  0x8(%ebp)
  8031de:	e8 b6 fe ff ff       	call   803099 <addToAvailMemBlocksList>
  8031e3:	83 c4 10             	add    $0x10,%esp
		}
	}

	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  8031e6:	e9 72 03 00 00       	jmp    80355d <insert_sorted_with_merge_freeList+0x444>
		if (last->sva + last->size == blockToInsert->sva) {
			last->size = last->size + blockToInsert->size;
			addToAvailMemBlocksList(blockToInsert);

		} else {
			LIST_INSERT_AFTER(&FreeMemBlocksList, last, blockToInsert);
  8031eb:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8031ef:	74 06                	je     8031f7 <insert_sorted_with_merge_freeList+0xde>
  8031f1:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8031f5:	75 17                	jne    80320e <insert_sorted_with_merge_freeList+0xf5>
  8031f7:	83 ec 04             	sub    $0x4,%esp
  8031fa:	68 48 41 80 00       	push   $0x804148
  8031ff:	68 24 01 00 00       	push   $0x124
  803204:	68 0b 41 80 00       	push   $0x80410b
  803209:	e8 72 d5 ff ff       	call   800780 <_panic>
  80320e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803211:	8b 10                	mov    (%eax),%edx
  803213:	8b 45 08             	mov    0x8(%ebp),%eax
  803216:	89 10                	mov    %edx,(%eax)
  803218:	8b 45 08             	mov    0x8(%ebp),%eax
  80321b:	8b 00                	mov    (%eax),%eax
  80321d:	85 c0                	test   %eax,%eax
  80321f:	74 0b                	je     80322c <insert_sorted_with_merge_freeList+0x113>
  803221:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803224:	8b 00                	mov    (%eax),%eax
  803226:	8b 55 08             	mov    0x8(%ebp),%edx
  803229:	89 50 04             	mov    %edx,0x4(%eax)
  80322c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80322f:	8b 55 08             	mov    0x8(%ebp),%edx
  803232:	89 10                	mov    %edx,(%eax)
  803234:	8b 45 08             	mov    0x8(%ebp),%eax
  803237:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80323a:	89 50 04             	mov    %edx,0x4(%eax)
  80323d:	8b 45 08             	mov    0x8(%ebp),%eax
  803240:	8b 00                	mov    (%eax),%eax
  803242:	85 c0                	test   %eax,%eax
  803244:	75 08                	jne    80324e <insert_sorted_with_merge_freeList+0x135>
  803246:	8b 45 08             	mov    0x8(%ebp),%eax
  803249:	a3 3c 51 80 00       	mov    %eax,0x80513c
  80324e:	a1 44 51 80 00       	mov    0x805144,%eax
  803253:	40                   	inc    %eax
  803254:	a3 44 51 80 00       	mov    %eax,0x805144
		}
	}

	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  803259:	e9 ff 02 00 00       	jmp    80355d <insert_sorted_with_merge_freeList+0x444>
		} else {
			LIST_INSERT_AFTER(&FreeMemBlocksList, last, blockToInsert);
		}
	} else {
		struct MemBlock *iterator;
		LIST_FOREACH(iterator, &(FreeMemBlocksList))
  80325e:	a1 38 51 80 00       	mov    0x805138,%eax
  803263:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803266:	e9 c2 02 00 00       	jmp    80352d <insert_sorted_with_merge_freeList+0x414>
		{

			if (iterator->sva > blockToInsert->sva) {
  80326b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80326e:	8b 50 08             	mov    0x8(%eax),%edx
  803271:	8b 45 08             	mov    0x8(%ebp),%eax
  803274:	8b 40 08             	mov    0x8(%eax),%eax
  803277:	39 c2                	cmp    %eax,%edx
  803279:	0f 86 a6 02 00 00    	jbe    803525 <insert_sorted_with_merge_freeList+0x40c>

				struct MemBlock* prev = LIST_PREV(iterator);
  80327f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803282:	8b 40 04             	mov    0x4(%eax),%eax
  803285:	89 45 ec             	mov    %eax,-0x14(%ebp)
				if (prev == NULL) {
  803288:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  80328c:	0f 85 ba 00 00 00    	jne    80334c <insert_sorted_with_merge_freeList+0x233>
					//check merge
					if (blockToInsert->size + blockToInsert->sva
  803292:	8b 45 08             	mov    0x8(%ebp),%eax
  803295:	8b 50 0c             	mov    0xc(%eax),%edx
  803298:	8b 45 08             	mov    0x8(%ebp),%eax
  80329b:	8b 40 08             	mov    0x8(%eax),%eax
  80329e:	01 c2                	add    %eax,%edx
							== iterator->sva) {
  8032a0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8032a3:	8b 40 08             	mov    0x8(%eax),%eax
			if (iterator->sva > blockToInsert->sva) {

				struct MemBlock* prev = LIST_PREV(iterator);
				if (prev == NULL) {
					//check merge
					if (blockToInsert->size + blockToInsert->sva
  8032a6:	39 c2                	cmp    %eax,%edx
  8032a8:	75 33                	jne    8032dd <insert_sorted_with_merge_freeList+0x1c4>
							== iterator->sva) {
						iterator->sva = blockToInsert->sva;
  8032aa:	8b 45 08             	mov    0x8(%ebp),%eax
  8032ad:	8b 50 08             	mov    0x8(%eax),%edx
  8032b0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8032b3:	89 50 08             	mov    %edx,0x8(%eax)
						iterator->size = iterator->size + blockToInsert->size;
  8032b6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8032b9:	8b 50 0c             	mov    0xc(%eax),%edx
  8032bc:	8b 45 08             	mov    0x8(%ebp),%eax
  8032bf:	8b 40 0c             	mov    0xc(%eax),%eax
  8032c2:	01 c2                	add    %eax,%edx
  8032c4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8032c7:	89 50 0c             	mov    %edx,0xc(%eax)
						addToAvailMemBlocksList(blockToInsert);
  8032ca:	83 ec 0c             	sub    $0xc,%esp
  8032cd:	ff 75 08             	pushl  0x8(%ebp)
  8032d0:	e8 c4 fd ff ff       	call   803099 <addToAvailMemBlocksList>
  8032d5:	83 c4 10             	add    $0x10,%esp

					else {
						LIST_INSERT_BEFORE(&FreeMemBlocksList, iterator,
								blockToInsert);
					}
					break;
  8032d8:	e9 80 02 00 00       	jmp    80355d <insert_sorted_with_merge_freeList+0x444>
						addToAvailMemBlocksList(blockToInsert);

					}

					else {
						LIST_INSERT_BEFORE(&FreeMemBlocksList, iterator,
  8032dd:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8032e1:	74 06                	je     8032e9 <insert_sorted_with_merge_freeList+0x1d0>
  8032e3:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8032e7:	75 17                	jne    803300 <insert_sorted_with_merge_freeList+0x1e7>
  8032e9:	83 ec 04             	sub    $0x4,%esp
  8032ec:	68 9c 41 80 00       	push   $0x80419c
  8032f1:	68 3a 01 00 00       	push   $0x13a
  8032f6:	68 0b 41 80 00       	push   $0x80410b
  8032fb:	e8 80 d4 ff ff       	call   800780 <_panic>
  803300:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803303:	8b 50 04             	mov    0x4(%eax),%edx
  803306:	8b 45 08             	mov    0x8(%ebp),%eax
  803309:	89 50 04             	mov    %edx,0x4(%eax)
  80330c:	8b 45 08             	mov    0x8(%ebp),%eax
  80330f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803312:	89 10                	mov    %edx,(%eax)
  803314:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803317:	8b 40 04             	mov    0x4(%eax),%eax
  80331a:	85 c0                	test   %eax,%eax
  80331c:	74 0d                	je     80332b <insert_sorted_with_merge_freeList+0x212>
  80331e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803321:	8b 40 04             	mov    0x4(%eax),%eax
  803324:	8b 55 08             	mov    0x8(%ebp),%edx
  803327:	89 10                	mov    %edx,(%eax)
  803329:	eb 08                	jmp    803333 <insert_sorted_with_merge_freeList+0x21a>
  80332b:	8b 45 08             	mov    0x8(%ebp),%eax
  80332e:	a3 38 51 80 00       	mov    %eax,0x805138
  803333:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803336:	8b 55 08             	mov    0x8(%ebp),%edx
  803339:	89 50 04             	mov    %edx,0x4(%eax)
  80333c:	a1 44 51 80 00       	mov    0x805144,%eax
  803341:	40                   	inc    %eax
  803342:	a3 44 51 80 00       	mov    %eax,0x805144
								blockToInsert);
					}
					break;
  803347:	e9 11 02 00 00       	jmp    80355d <insert_sorted_with_merge_freeList+0x444>
				} else {
					//prev and next merge
					if (prev->sva + prev->size + blockToInsert->size
  80334c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80334f:	8b 50 08             	mov    0x8(%eax),%edx
  803352:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803355:	8b 40 0c             	mov    0xc(%eax),%eax
  803358:	01 c2                	add    %eax,%edx
  80335a:	8b 45 08             	mov    0x8(%ebp),%eax
  80335d:	8b 40 0c             	mov    0xc(%eax),%eax
  803360:	01 c2                	add    %eax,%edx
							== iterator->sva) {
  803362:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803365:	8b 40 08             	mov    0x8(%eax),%eax
								blockToInsert);
					}
					break;
				} else {
					//prev and next merge
					if (prev->sva + prev->size + blockToInsert->size
  803368:	39 c2                	cmp    %eax,%edx
  80336a:	0f 85 bf 00 00 00    	jne    80342f <insert_sorted_with_merge_freeList+0x316>
							== iterator->sva) {
						prev->size = prev->size + blockToInsert->size
  803370:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803373:	8b 50 0c             	mov    0xc(%eax),%edx
  803376:	8b 45 08             	mov    0x8(%ebp),%eax
  803379:	8b 40 0c             	mov    0xc(%eax),%eax
  80337c:	01 c2                	add    %eax,%edx
								+ iterator->size;
  80337e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803381:	8b 40 0c             	mov    0xc(%eax),%eax
  803384:	01 c2                	add    %eax,%edx
					break;
				} else {
					//prev and next merge
					if (prev->sva + prev->size + blockToInsert->size
							== iterator->sva) {
						prev->size = prev->size + blockToInsert->size
  803386:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803389:	89 50 0c             	mov    %edx,0xc(%eax)
								+ iterator->size;
						LIST_REMOVE(&FreeMemBlocksList, iterator);
  80338c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803390:	75 17                	jne    8033a9 <insert_sorted_with_merge_freeList+0x290>
  803392:	83 ec 04             	sub    $0x4,%esp
  803395:	68 7c 41 80 00       	push   $0x80417c
  80339a:	68 43 01 00 00       	push   $0x143
  80339f:	68 0b 41 80 00       	push   $0x80410b
  8033a4:	e8 d7 d3 ff ff       	call   800780 <_panic>
  8033a9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8033ac:	8b 00                	mov    (%eax),%eax
  8033ae:	85 c0                	test   %eax,%eax
  8033b0:	74 10                	je     8033c2 <insert_sorted_with_merge_freeList+0x2a9>
  8033b2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8033b5:	8b 00                	mov    (%eax),%eax
  8033b7:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8033ba:	8b 52 04             	mov    0x4(%edx),%edx
  8033bd:	89 50 04             	mov    %edx,0x4(%eax)
  8033c0:	eb 0b                	jmp    8033cd <insert_sorted_with_merge_freeList+0x2b4>
  8033c2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8033c5:	8b 40 04             	mov    0x4(%eax),%eax
  8033c8:	a3 3c 51 80 00       	mov    %eax,0x80513c
  8033cd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8033d0:	8b 40 04             	mov    0x4(%eax),%eax
  8033d3:	85 c0                	test   %eax,%eax
  8033d5:	74 0f                	je     8033e6 <insert_sorted_with_merge_freeList+0x2cd>
  8033d7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8033da:	8b 40 04             	mov    0x4(%eax),%eax
  8033dd:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8033e0:	8b 12                	mov    (%edx),%edx
  8033e2:	89 10                	mov    %edx,(%eax)
  8033e4:	eb 0a                	jmp    8033f0 <insert_sorted_with_merge_freeList+0x2d7>
  8033e6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8033e9:	8b 00                	mov    (%eax),%eax
  8033eb:	a3 38 51 80 00       	mov    %eax,0x805138
  8033f0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8033f3:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8033f9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8033fc:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803403:	a1 44 51 80 00       	mov    0x805144,%eax
  803408:	48                   	dec    %eax
  803409:	a3 44 51 80 00       	mov    %eax,0x805144
						addToAvailMemBlocksList(blockToInsert);
  80340e:	83 ec 0c             	sub    $0xc,%esp
  803411:	ff 75 08             	pushl  0x8(%ebp)
  803414:	e8 80 fc ff ff       	call   803099 <addToAvailMemBlocksList>
  803419:	83 c4 10             	add    $0x10,%esp
						addToAvailMemBlocksList(iterator);
  80341c:	83 ec 0c             	sub    $0xc,%esp
  80341f:	ff 75 f4             	pushl  -0xc(%ebp)
  803422:	e8 72 fc ff ff       	call   803099 <addToAvailMemBlocksList>
  803427:	83 c4 10             	add    $0x10,%esp
					//Insert
					else {
						LIST_INSERT_BEFORE(&FreeMemBlocksList, iterator,
								blockToInsert);
					}
					break;
  80342a:	e9 2e 01 00 00       	jmp    80355d <insert_sorted_with_merge_freeList+0x444>
						LIST_REMOVE(&FreeMemBlocksList, iterator);
						addToAvailMemBlocksList(blockToInsert);
						addToAvailMemBlocksList(iterator);
					}
					//previous merge
					else if (prev->sva + prev->size == blockToInsert->sva) {
  80342f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803432:	8b 50 08             	mov    0x8(%eax),%edx
  803435:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803438:	8b 40 0c             	mov    0xc(%eax),%eax
  80343b:	01 c2                	add    %eax,%edx
  80343d:	8b 45 08             	mov    0x8(%ebp),%eax
  803440:	8b 40 08             	mov    0x8(%eax),%eax
  803443:	39 c2                	cmp    %eax,%edx
  803445:	75 27                	jne    80346e <insert_sorted_with_merge_freeList+0x355>
						prev->size = prev->size + blockToInsert->size;
  803447:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80344a:	8b 50 0c             	mov    0xc(%eax),%edx
  80344d:	8b 45 08             	mov    0x8(%ebp),%eax
  803450:	8b 40 0c             	mov    0xc(%eax),%eax
  803453:	01 c2                	add    %eax,%edx
  803455:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803458:	89 50 0c             	mov    %edx,0xc(%eax)
						addToAvailMemBlocksList(blockToInsert);
  80345b:	83 ec 0c             	sub    $0xc,%esp
  80345e:	ff 75 08             	pushl  0x8(%ebp)
  803461:	e8 33 fc ff ff       	call   803099 <addToAvailMemBlocksList>
  803466:	83 c4 10             	add    $0x10,%esp
					//Insert
					else {
						LIST_INSERT_BEFORE(&FreeMemBlocksList, iterator,
								blockToInsert);
					}
					break;
  803469:	e9 ef 00 00 00       	jmp    80355d <insert_sorted_with_merge_freeList+0x444>
					else if (prev->sva + prev->size == blockToInsert->sva) {
						prev->size = prev->size + blockToInsert->size;
						addToAvailMemBlocksList(blockToInsert);
					}
					//next merge
					else if (blockToInsert->size + blockToInsert->sva
  80346e:	8b 45 08             	mov    0x8(%ebp),%eax
  803471:	8b 50 0c             	mov    0xc(%eax),%edx
  803474:	8b 45 08             	mov    0x8(%ebp),%eax
  803477:	8b 40 08             	mov    0x8(%eax),%eax
  80347a:	01 c2                	add    %eax,%edx
							== iterator->sva) {
  80347c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80347f:	8b 40 08             	mov    0x8(%eax),%eax
					else if (prev->sva + prev->size == blockToInsert->sva) {
						prev->size = prev->size + blockToInsert->size;
						addToAvailMemBlocksList(blockToInsert);
					}
					//next merge
					else if (blockToInsert->size + blockToInsert->sva
  803482:	39 c2                	cmp    %eax,%edx
  803484:	75 33                	jne    8034b9 <insert_sorted_with_merge_freeList+0x3a0>
							== iterator->sva) {
						iterator->sva = blockToInsert->sva;
  803486:	8b 45 08             	mov    0x8(%ebp),%eax
  803489:	8b 50 08             	mov    0x8(%eax),%edx
  80348c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80348f:	89 50 08             	mov    %edx,0x8(%eax)
						iterator->size = iterator->size + blockToInsert->size;
  803492:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803495:	8b 50 0c             	mov    0xc(%eax),%edx
  803498:	8b 45 08             	mov    0x8(%ebp),%eax
  80349b:	8b 40 0c             	mov    0xc(%eax),%eax
  80349e:	01 c2                	add    %eax,%edx
  8034a0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8034a3:	89 50 0c             	mov    %edx,0xc(%eax)
						addToAvailMemBlocksList(blockToInsert);
  8034a6:	83 ec 0c             	sub    $0xc,%esp
  8034a9:	ff 75 08             	pushl  0x8(%ebp)
  8034ac:	e8 e8 fb ff ff       	call   803099 <addToAvailMemBlocksList>
  8034b1:	83 c4 10             	add    $0x10,%esp
					//Insert
					else {
						LIST_INSERT_BEFORE(&FreeMemBlocksList, iterator,
								blockToInsert);
					}
					break;
  8034b4:	e9 a4 00 00 00       	jmp    80355d <insert_sorted_with_merge_freeList+0x444>
						iterator->size = iterator->size + blockToInsert->size;
						addToAvailMemBlocksList(blockToInsert);
					}
					//Insert
					else {
						LIST_INSERT_BEFORE(&FreeMemBlocksList, iterator,
  8034b9:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8034bd:	74 06                	je     8034c5 <insert_sorted_with_merge_freeList+0x3ac>
  8034bf:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8034c3:	75 17                	jne    8034dc <insert_sorted_with_merge_freeList+0x3c3>
  8034c5:	83 ec 04             	sub    $0x4,%esp
  8034c8:	68 9c 41 80 00       	push   $0x80419c
  8034cd:	68 56 01 00 00       	push   $0x156
  8034d2:	68 0b 41 80 00       	push   $0x80410b
  8034d7:	e8 a4 d2 ff ff       	call   800780 <_panic>
  8034dc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8034df:	8b 50 04             	mov    0x4(%eax),%edx
  8034e2:	8b 45 08             	mov    0x8(%ebp),%eax
  8034e5:	89 50 04             	mov    %edx,0x4(%eax)
  8034e8:	8b 45 08             	mov    0x8(%ebp),%eax
  8034eb:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8034ee:	89 10                	mov    %edx,(%eax)
  8034f0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8034f3:	8b 40 04             	mov    0x4(%eax),%eax
  8034f6:	85 c0                	test   %eax,%eax
  8034f8:	74 0d                	je     803507 <insert_sorted_with_merge_freeList+0x3ee>
  8034fa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8034fd:	8b 40 04             	mov    0x4(%eax),%eax
  803500:	8b 55 08             	mov    0x8(%ebp),%edx
  803503:	89 10                	mov    %edx,(%eax)
  803505:	eb 08                	jmp    80350f <insert_sorted_with_merge_freeList+0x3f6>
  803507:	8b 45 08             	mov    0x8(%ebp),%eax
  80350a:	a3 38 51 80 00       	mov    %eax,0x805138
  80350f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803512:	8b 55 08             	mov    0x8(%ebp),%edx
  803515:	89 50 04             	mov    %edx,0x4(%eax)
  803518:	a1 44 51 80 00       	mov    0x805144,%eax
  80351d:	40                   	inc    %eax
  80351e:	a3 44 51 80 00       	mov    %eax,0x805144
								blockToInsert);
					}
					break;
  803523:	eb 38                	jmp    80355d <insert_sorted_with_merge_freeList+0x444>
		} else {
			LIST_INSERT_AFTER(&FreeMemBlocksList, last, blockToInsert);
		}
	} else {
		struct MemBlock *iterator;
		LIST_FOREACH(iterator, &(FreeMemBlocksList))
  803525:	a1 40 51 80 00       	mov    0x805140,%eax
  80352a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80352d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803531:	74 07                	je     80353a <insert_sorted_with_merge_freeList+0x421>
  803533:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803536:	8b 00                	mov    (%eax),%eax
  803538:	eb 05                	jmp    80353f <insert_sorted_with_merge_freeList+0x426>
  80353a:	b8 00 00 00 00       	mov    $0x0,%eax
  80353f:	a3 40 51 80 00       	mov    %eax,0x805140
  803544:	a1 40 51 80 00       	mov    0x805140,%eax
  803549:	85 c0                	test   %eax,%eax
  80354b:	0f 85 1a fd ff ff    	jne    80326b <insert_sorted_with_merge_freeList+0x152>
  803551:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803555:	0f 85 10 fd ff ff    	jne    80326b <insert_sorted_with_merge_freeList+0x152>
		}
	}

	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  80355b:	eb 00                	jmp    80355d <insert_sorted_with_merge_freeList+0x444>
  80355d:	90                   	nop
  80355e:	c9                   	leave  
  80355f:	c3                   	ret    

00803560 <__udivdi3>:
  803560:	55                   	push   %ebp
  803561:	57                   	push   %edi
  803562:	56                   	push   %esi
  803563:	53                   	push   %ebx
  803564:	83 ec 1c             	sub    $0x1c,%esp
  803567:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  80356b:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  80356f:	8b 7c 24 38          	mov    0x38(%esp),%edi
  803573:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  803577:	89 ca                	mov    %ecx,%edx
  803579:	89 f8                	mov    %edi,%eax
  80357b:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  80357f:	85 f6                	test   %esi,%esi
  803581:	75 2d                	jne    8035b0 <__udivdi3+0x50>
  803583:	39 cf                	cmp    %ecx,%edi
  803585:	77 65                	ja     8035ec <__udivdi3+0x8c>
  803587:	89 fd                	mov    %edi,%ebp
  803589:	85 ff                	test   %edi,%edi
  80358b:	75 0b                	jne    803598 <__udivdi3+0x38>
  80358d:	b8 01 00 00 00       	mov    $0x1,%eax
  803592:	31 d2                	xor    %edx,%edx
  803594:	f7 f7                	div    %edi
  803596:	89 c5                	mov    %eax,%ebp
  803598:	31 d2                	xor    %edx,%edx
  80359a:	89 c8                	mov    %ecx,%eax
  80359c:	f7 f5                	div    %ebp
  80359e:	89 c1                	mov    %eax,%ecx
  8035a0:	89 d8                	mov    %ebx,%eax
  8035a2:	f7 f5                	div    %ebp
  8035a4:	89 cf                	mov    %ecx,%edi
  8035a6:	89 fa                	mov    %edi,%edx
  8035a8:	83 c4 1c             	add    $0x1c,%esp
  8035ab:	5b                   	pop    %ebx
  8035ac:	5e                   	pop    %esi
  8035ad:	5f                   	pop    %edi
  8035ae:	5d                   	pop    %ebp
  8035af:	c3                   	ret    
  8035b0:	39 ce                	cmp    %ecx,%esi
  8035b2:	77 28                	ja     8035dc <__udivdi3+0x7c>
  8035b4:	0f bd fe             	bsr    %esi,%edi
  8035b7:	83 f7 1f             	xor    $0x1f,%edi
  8035ba:	75 40                	jne    8035fc <__udivdi3+0x9c>
  8035bc:	39 ce                	cmp    %ecx,%esi
  8035be:	72 0a                	jb     8035ca <__udivdi3+0x6a>
  8035c0:	3b 44 24 08          	cmp    0x8(%esp),%eax
  8035c4:	0f 87 9e 00 00 00    	ja     803668 <__udivdi3+0x108>
  8035ca:	b8 01 00 00 00       	mov    $0x1,%eax
  8035cf:	89 fa                	mov    %edi,%edx
  8035d1:	83 c4 1c             	add    $0x1c,%esp
  8035d4:	5b                   	pop    %ebx
  8035d5:	5e                   	pop    %esi
  8035d6:	5f                   	pop    %edi
  8035d7:	5d                   	pop    %ebp
  8035d8:	c3                   	ret    
  8035d9:	8d 76 00             	lea    0x0(%esi),%esi
  8035dc:	31 ff                	xor    %edi,%edi
  8035de:	31 c0                	xor    %eax,%eax
  8035e0:	89 fa                	mov    %edi,%edx
  8035e2:	83 c4 1c             	add    $0x1c,%esp
  8035e5:	5b                   	pop    %ebx
  8035e6:	5e                   	pop    %esi
  8035e7:	5f                   	pop    %edi
  8035e8:	5d                   	pop    %ebp
  8035e9:	c3                   	ret    
  8035ea:	66 90                	xchg   %ax,%ax
  8035ec:	89 d8                	mov    %ebx,%eax
  8035ee:	f7 f7                	div    %edi
  8035f0:	31 ff                	xor    %edi,%edi
  8035f2:	89 fa                	mov    %edi,%edx
  8035f4:	83 c4 1c             	add    $0x1c,%esp
  8035f7:	5b                   	pop    %ebx
  8035f8:	5e                   	pop    %esi
  8035f9:	5f                   	pop    %edi
  8035fa:	5d                   	pop    %ebp
  8035fb:	c3                   	ret    
  8035fc:	bd 20 00 00 00       	mov    $0x20,%ebp
  803601:	89 eb                	mov    %ebp,%ebx
  803603:	29 fb                	sub    %edi,%ebx
  803605:	89 f9                	mov    %edi,%ecx
  803607:	d3 e6                	shl    %cl,%esi
  803609:	89 c5                	mov    %eax,%ebp
  80360b:	88 d9                	mov    %bl,%cl
  80360d:	d3 ed                	shr    %cl,%ebp
  80360f:	89 e9                	mov    %ebp,%ecx
  803611:	09 f1                	or     %esi,%ecx
  803613:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  803617:	89 f9                	mov    %edi,%ecx
  803619:	d3 e0                	shl    %cl,%eax
  80361b:	89 c5                	mov    %eax,%ebp
  80361d:	89 d6                	mov    %edx,%esi
  80361f:	88 d9                	mov    %bl,%cl
  803621:	d3 ee                	shr    %cl,%esi
  803623:	89 f9                	mov    %edi,%ecx
  803625:	d3 e2                	shl    %cl,%edx
  803627:	8b 44 24 08          	mov    0x8(%esp),%eax
  80362b:	88 d9                	mov    %bl,%cl
  80362d:	d3 e8                	shr    %cl,%eax
  80362f:	09 c2                	or     %eax,%edx
  803631:	89 d0                	mov    %edx,%eax
  803633:	89 f2                	mov    %esi,%edx
  803635:	f7 74 24 0c          	divl   0xc(%esp)
  803639:	89 d6                	mov    %edx,%esi
  80363b:	89 c3                	mov    %eax,%ebx
  80363d:	f7 e5                	mul    %ebp
  80363f:	39 d6                	cmp    %edx,%esi
  803641:	72 19                	jb     80365c <__udivdi3+0xfc>
  803643:	74 0b                	je     803650 <__udivdi3+0xf0>
  803645:	89 d8                	mov    %ebx,%eax
  803647:	31 ff                	xor    %edi,%edi
  803649:	e9 58 ff ff ff       	jmp    8035a6 <__udivdi3+0x46>
  80364e:	66 90                	xchg   %ax,%ax
  803650:	8b 54 24 08          	mov    0x8(%esp),%edx
  803654:	89 f9                	mov    %edi,%ecx
  803656:	d3 e2                	shl    %cl,%edx
  803658:	39 c2                	cmp    %eax,%edx
  80365a:	73 e9                	jae    803645 <__udivdi3+0xe5>
  80365c:	8d 43 ff             	lea    -0x1(%ebx),%eax
  80365f:	31 ff                	xor    %edi,%edi
  803661:	e9 40 ff ff ff       	jmp    8035a6 <__udivdi3+0x46>
  803666:	66 90                	xchg   %ax,%ax
  803668:	31 c0                	xor    %eax,%eax
  80366a:	e9 37 ff ff ff       	jmp    8035a6 <__udivdi3+0x46>
  80366f:	90                   	nop

00803670 <__umoddi3>:
  803670:	55                   	push   %ebp
  803671:	57                   	push   %edi
  803672:	56                   	push   %esi
  803673:	53                   	push   %ebx
  803674:	83 ec 1c             	sub    $0x1c,%esp
  803677:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  80367b:	8b 74 24 34          	mov    0x34(%esp),%esi
  80367f:	8b 7c 24 38          	mov    0x38(%esp),%edi
  803683:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  803687:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80368b:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  80368f:	89 f3                	mov    %esi,%ebx
  803691:	89 fa                	mov    %edi,%edx
  803693:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  803697:	89 34 24             	mov    %esi,(%esp)
  80369a:	85 c0                	test   %eax,%eax
  80369c:	75 1a                	jne    8036b8 <__umoddi3+0x48>
  80369e:	39 f7                	cmp    %esi,%edi
  8036a0:	0f 86 a2 00 00 00    	jbe    803748 <__umoddi3+0xd8>
  8036a6:	89 c8                	mov    %ecx,%eax
  8036a8:	89 f2                	mov    %esi,%edx
  8036aa:	f7 f7                	div    %edi
  8036ac:	89 d0                	mov    %edx,%eax
  8036ae:	31 d2                	xor    %edx,%edx
  8036b0:	83 c4 1c             	add    $0x1c,%esp
  8036b3:	5b                   	pop    %ebx
  8036b4:	5e                   	pop    %esi
  8036b5:	5f                   	pop    %edi
  8036b6:	5d                   	pop    %ebp
  8036b7:	c3                   	ret    
  8036b8:	39 f0                	cmp    %esi,%eax
  8036ba:	0f 87 ac 00 00 00    	ja     80376c <__umoddi3+0xfc>
  8036c0:	0f bd e8             	bsr    %eax,%ebp
  8036c3:	83 f5 1f             	xor    $0x1f,%ebp
  8036c6:	0f 84 ac 00 00 00    	je     803778 <__umoddi3+0x108>
  8036cc:	bf 20 00 00 00       	mov    $0x20,%edi
  8036d1:	29 ef                	sub    %ebp,%edi
  8036d3:	89 fe                	mov    %edi,%esi
  8036d5:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  8036d9:	89 e9                	mov    %ebp,%ecx
  8036db:	d3 e0                	shl    %cl,%eax
  8036dd:	89 d7                	mov    %edx,%edi
  8036df:	89 f1                	mov    %esi,%ecx
  8036e1:	d3 ef                	shr    %cl,%edi
  8036e3:	09 c7                	or     %eax,%edi
  8036e5:	89 e9                	mov    %ebp,%ecx
  8036e7:	d3 e2                	shl    %cl,%edx
  8036e9:	89 14 24             	mov    %edx,(%esp)
  8036ec:	89 d8                	mov    %ebx,%eax
  8036ee:	d3 e0                	shl    %cl,%eax
  8036f0:	89 c2                	mov    %eax,%edx
  8036f2:	8b 44 24 08          	mov    0x8(%esp),%eax
  8036f6:	d3 e0                	shl    %cl,%eax
  8036f8:	89 44 24 04          	mov    %eax,0x4(%esp)
  8036fc:	8b 44 24 08          	mov    0x8(%esp),%eax
  803700:	89 f1                	mov    %esi,%ecx
  803702:	d3 e8                	shr    %cl,%eax
  803704:	09 d0                	or     %edx,%eax
  803706:	d3 eb                	shr    %cl,%ebx
  803708:	89 da                	mov    %ebx,%edx
  80370a:	f7 f7                	div    %edi
  80370c:	89 d3                	mov    %edx,%ebx
  80370e:	f7 24 24             	mull   (%esp)
  803711:	89 c6                	mov    %eax,%esi
  803713:	89 d1                	mov    %edx,%ecx
  803715:	39 d3                	cmp    %edx,%ebx
  803717:	0f 82 87 00 00 00    	jb     8037a4 <__umoddi3+0x134>
  80371d:	0f 84 91 00 00 00    	je     8037b4 <__umoddi3+0x144>
  803723:	8b 54 24 04          	mov    0x4(%esp),%edx
  803727:	29 f2                	sub    %esi,%edx
  803729:	19 cb                	sbb    %ecx,%ebx
  80372b:	89 d8                	mov    %ebx,%eax
  80372d:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  803731:	d3 e0                	shl    %cl,%eax
  803733:	89 e9                	mov    %ebp,%ecx
  803735:	d3 ea                	shr    %cl,%edx
  803737:	09 d0                	or     %edx,%eax
  803739:	89 e9                	mov    %ebp,%ecx
  80373b:	d3 eb                	shr    %cl,%ebx
  80373d:	89 da                	mov    %ebx,%edx
  80373f:	83 c4 1c             	add    $0x1c,%esp
  803742:	5b                   	pop    %ebx
  803743:	5e                   	pop    %esi
  803744:	5f                   	pop    %edi
  803745:	5d                   	pop    %ebp
  803746:	c3                   	ret    
  803747:	90                   	nop
  803748:	89 fd                	mov    %edi,%ebp
  80374a:	85 ff                	test   %edi,%edi
  80374c:	75 0b                	jne    803759 <__umoddi3+0xe9>
  80374e:	b8 01 00 00 00       	mov    $0x1,%eax
  803753:	31 d2                	xor    %edx,%edx
  803755:	f7 f7                	div    %edi
  803757:	89 c5                	mov    %eax,%ebp
  803759:	89 f0                	mov    %esi,%eax
  80375b:	31 d2                	xor    %edx,%edx
  80375d:	f7 f5                	div    %ebp
  80375f:	89 c8                	mov    %ecx,%eax
  803761:	f7 f5                	div    %ebp
  803763:	89 d0                	mov    %edx,%eax
  803765:	e9 44 ff ff ff       	jmp    8036ae <__umoddi3+0x3e>
  80376a:	66 90                	xchg   %ax,%ax
  80376c:	89 c8                	mov    %ecx,%eax
  80376e:	89 f2                	mov    %esi,%edx
  803770:	83 c4 1c             	add    $0x1c,%esp
  803773:	5b                   	pop    %ebx
  803774:	5e                   	pop    %esi
  803775:	5f                   	pop    %edi
  803776:	5d                   	pop    %ebp
  803777:	c3                   	ret    
  803778:	3b 04 24             	cmp    (%esp),%eax
  80377b:	72 06                	jb     803783 <__umoddi3+0x113>
  80377d:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  803781:	77 0f                	ja     803792 <__umoddi3+0x122>
  803783:	89 f2                	mov    %esi,%edx
  803785:	29 f9                	sub    %edi,%ecx
  803787:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  80378b:	89 14 24             	mov    %edx,(%esp)
  80378e:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  803792:	8b 44 24 04          	mov    0x4(%esp),%eax
  803796:	8b 14 24             	mov    (%esp),%edx
  803799:	83 c4 1c             	add    $0x1c,%esp
  80379c:	5b                   	pop    %ebx
  80379d:	5e                   	pop    %esi
  80379e:	5f                   	pop    %edi
  80379f:	5d                   	pop    %ebp
  8037a0:	c3                   	ret    
  8037a1:	8d 76 00             	lea    0x0(%esi),%esi
  8037a4:	2b 04 24             	sub    (%esp),%eax
  8037a7:	19 fa                	sbb    %edi,%edx
  8037a9:	89 d1                	mov    %edx,%ecx
  8037ab:	89 c6                	mov    %eax,%esi
  8037ad:	e9 71 ff ff ff       	jmp    803723 <__umoddi3+0xb3>
  8037b2:	66 90                	xchg   %ax,%ax
  8037b4:	39 44 24 04          	cmp    %eax,0x4(%esp)
  8037b8:	72 ea                	jb     8037a4 <__umoddi3+0x134>
  8037ba:	89 d9                	mov    %ebx,%ecx
  8037bc:	e9 62 ff ff ff       	jmp    803723 <__umoddi3+0xb3>
