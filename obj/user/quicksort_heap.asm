
obj/user/quicksort_heap:     file format elf32-i386


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
  800031:	e8 1f 06 00 00       	call   800655 <libmain>
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
  800041:	e8 90 20 00 00       	call   8020d6 <sys_disable_interrupt>
		cprintf("\n");
  800046:	83 ec 0c             	sub    $0xc,%esp
  800049:	68 e0 37 80 00       	push   $0x8037e0
  80004e:	e8 f2 09 00 00       	call   800a45 <cprintf>
  800053:	83 c4 10             	add    $0x10,%esp
		cprintf("!!!!!!!!!!!!!!!!!!!!!!!\n");
  800056:	83 ec 0c             	sub    $0xc,%esp
  800059:	68 e2 37 80 00       	push   $0x8037e2
  80005e:	e8 e2 09 00 00       	call   800a45 <cprintf>
  800063:	83 c4 10             	add    $0x10,%esp
		cprintf("!!!   QUICK SORT   !!!\n");
  800066:	83 ec 0c             	sub    $0xc,%esp
  800069:	68 fb 37 80 00       	push   $0x8037fb
  80006e:	e8 d2 09 00 00       	call   800a45 <cprintf>
  800073:	83 c4 10             	add    $0x10,%esp
		cprintf("!!!!!!!!!!!!!!!!!!!!!!!\n");
  800076:	83 ec 0c             	sub    $0xc,%esp
  800079:	68 e2 37 80 00       	push   $0x8037e2
  80007e:	e8 c2 09 00 00       	call   800a45 <cprintf>
  800083:	83 c4 10             	add    $0x10,%esp
		cprintf("\n");
  800086:	83 ec 0c             	sub    $0xc,%esp
  800089:	68 e0 37 80 00       	push   $0x8037e0
  80008e:	e8 b2 09 00 00       	call   800a45 <cprintf>
  800093:	83 c4 10             	add    $0x10,%esp

		readline("Enter the number of elements: ", Line);
  800096:	83 ec 08             	sub    $0x8,%esp
  800099:	8d 85 e9 fe ff ff    	lea    -0x117(%ebp),%eax
  80009f:	50                   	push   %eax
  8000a0:	68 14 38 80 00       	push   $0x803814
  8000a5:	e8 1d 10 00 00       	call   8010c7 <readline>
  8000aa:	83 c4 10             	add    $0x10,%esp
		int NumOfElements = strtol(Line, NULL, 10) ;
  8000ad:	83 ec 04             	sub    $0x4,%esp
  8000b0:	6a 0a                	push   $0xa
  8000b2:	6a 00                	push   $0x0
  8000b4:	8d 85 e9 fe ff ff    	lea    -0x117(%ebp),%eax
  8000ba:	50                   	push   %eax
  8000bb:	e8 6d 15 00 00       	call   80162d <strtol>
  8000c0:	83 c4 10             	add    $0x10,%esp
  8000c3:	89 45 f0             	mov    %eax,-0x10(%ebp)
		int *Elements = malloc(sizeof(int) * NumOfElements) ;
  8000c6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8000c9:	c1 e0 02             	shl    $0x2,%eax
  8000cc:	83 ec 0c             	sub    $0xc,%esp
  8000cf:	50                   	push   %eax
  8000d0:	e8 08 1b 00 00       	call   801bdd <malloc>
  8000d5:	83 c4 10             	add    $0x10,%esp
  8000d8:	89 45 ec             	mov    %eax,-0x14(%ebp)
		cprintf("Chose the initialization method:\n") ;
  8000db:	83 ec 0c             	sub    $0xc,%esp
  8000de:	68 34 38 80 00       	push   $0x803834
  8000e3:	e8 5d 09 00 00       	call   800a45 <cprintf>
  8000e8:	83 c4 10             	add    $0x10,%esp
		cprintf("a) Ascending\n") ;
  8000eb:	83 ec 0c             	sub    $0xc,%esp
  8000ee:	68 56 38 80 00       	push   $0x803856
  8000f3:	e8 4d 09 00 00       	call   800a45 <cprintf>
  8000f8:	83 c4 10             	add    $0x10,%esp
		cprintf("b) Descending\n") ;
  8000fb:	83 ec 0c             	sub    $0xc,%esp
  8000fe:	68 64 38 80 00       	push   $0x803864
  800103:	e8 3d 09 00 00       	call   800a45 <cprintf>
  800108:	83 c4 10             	add    $0x10,%esp
		cprintf("c) Semi random\n");
  80010b:	83 ec 0c             	sub    $0xc,%esp
  80010e:	68 73 38 80 00       	push   $0x803873
  800113:	e8 2d 09 00 00       	call   800a45 <cprintf>
  800118:	83 c4 10             	add    $0x10,%esp
		do
		{
			cprintf("Select: ") ;
  80011b:	83 ec 0c             	sub    $0xc,%esp
  80011e:	68 83 38 80 00       	push   $0x803883
  800123:	e8 1d 09 00 00       	call   800a45 <cprintf>
  800128:	83 c4 10             	add    $0x10,%esp
			Chose = getchar() ;
  80012b:	e8 cd 04 00 00       	call   8005fd <getchar>
  800130:	88 45 f7             	mov    %al,-0x9(%ebp)
			cputchar(Chose);
  800133:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
  800137:	83 ec 0c             	sub    $0xc,%esp
  80013a:	50                   	push   %eax
  80013b:	e8 75 04 00 00       	call   8005b5 <cputchar>
  800140:	83 c4 10             	add    $0x10,%esp
			cputchar('\n');
  800143:	83 ec 0c             	sub    $0xc,%esp
  800146:	6a 0a                	push   $0xa
  800148:	e8 68 04 00 00       	call   8005b5 <cputchar>
  80014d:	83 c4 10             	add    $0x10,%esp
		} while (Chose != 'a' && Chose != 'b' && Chose != 'c');
  800150:	80 7d f7 61          	cmpb   $0x61,-0x9(%ebp)
  800154:	74 0c                	je     800162 <_main+0x12a>
  800156:	80 7d f7 62          	cmpb   $0x62,-0x9(%ebp)
  80015a:	74 06                	je     800162 <_main+0x12a>
  80015c:	80 7d f7 63          	cmpb   $0x63,-0x9(%ebp)
  800160:	75 b9                	jne    80011b <_main+0xe3>
		//2012: lock the interrupt
		sys_enable_interrupt();
  800162:	e8 89 1f 00 00       	call   8020f0 <sys_enable_interrupt>

		int  i ;
		switch (Chose)
  800167:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
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
  80017d:	ff 75 f0             	pushl  -0x10(%ebp)
  800180:	ff 75 ec             	pushl  -0x14(%ebp)
  800183:	e8 f5 02 00 00       	call   80047d <InitializeAscending>
  800188:	83 c4 10             	add    $0x10,%esp
			break ;
  80018b:	eb 37                	jmp    8001c4 <_main+0x18c>
		case 'b':
			InitializeDescending(Elements, NumOfElements);
  80018d:	83 ec 08             	sub    $0x8,%esp
  800190:	ff 75 f0             	pushl  -0x10(%ebp)
  800193:	ff 75 ec             	pushl  -0x14(%ebp)
  800196:	e8 13 03 00 00       	call   8004ae <InitializeDescending>
  80019b:	83 c4 10             	add    $0x10,%esp
			break ;
  80019e:	eb 24                	jmp    8001c4 <_main+0x18c>
		case 'c':
			InitializeSemiRandom(Elements, NumOfElements);
  8001a0:	83 ec 08             	sub    $0x8,%esp
  8001a3:	ff 75 f0             	pushl  -0x10(%ebp)
  8001a6:	ff 75 ec             	pushl  -0x14(%ebp)
  8001a9:	e8 35 03 00 00       	call   8004e3 <InitializeSemiRandom>
  8001ae:	83 c4 10             	add    $0x10,%esp
			break ;
  8001b1:	eb 11                	jmp    8001c4 <_main+0x18c>
		default:
			InitializeSemiRandom(Elements, NumOfElements);
  8001b3:	83 ec 08             	sub    $0x8,%esp
  8001b6:	ff 75 f0             	pushl  -0x10(%ebp)
  8001b9:	ff 75 ec             	pushl  -0x14(%ebp)
  8001bc:	e8 22 03 00 00       	call   8004e3 <InitializeSemiRandom>
  8001c1:	83 c4 10             	add    $0x10,%esp
		}

		QuickSort(Elements, NumOfElements);
  8001c4:	83 ec 08             	sub    $0x8,%esp
  8001c7:	ff 75 f0             	pushl  -0x10(%ebp)
  8001ca:	ff 75 ec             	pushl  -0x14(%ebp)
  8001cd:	e8 f0 00 00 00       	call   8002c2 <QuickSort>
  8001d2:	83 c4 10             	add    $0x10,%esp

		sys_disable_interrupt();
  8001d5:	e8 fc 1e 00 00       	call   8020d6 <sys_disable_interrupt>
			cprintf("Sorting is Finished!!!!it'll be checked now....\n") ;
  8001da:	83 ec 0c             	sub    $0xc,%esp
  8001dd:	68 8c 38 80 00       	push   $0x80388c
  8001e2:	e8 5e 08 00 00       	call   800a45 <cprintf>
  8001e7:	83 c4 10             	add    $0x10,%esp
		//		PrintElements(Elements, NumOfElements);
		sys_enable_interrupt();
  8001ea:	e8 01 1f 00 00       	call   8020f0 <sys_enable_interrupt>

		uint32 Sorted = CheckSorted(Elements, NumOfElements);
  8001ef:	83 ec 08             	sub    $0x8,%esp
  8001f2:	ff 75 f0             	pushl  -0x10(%ebp)
  8001f5:	ff 75 ec             	pushl  -0x14(%ebp)
  8001f8:	e8 d6 01 00 00       	call   8003d3 <CheckSorted>
  8001fd:	83 c4 10             	add    $0x10,%esp
  800200:	89 45 e8             	mov    %eax,-0x18(%ebp)

		if(Sorted == 0) panic("The array is NOT sorted correctly") ;
  800203:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  800207:	75 14                	jne    80021d <_main+0x1e5>
  800209:	83 ec 04             	sub    $0x4,%esp
  80020c:	68 c0 38 80 00       	push   $0x8038c0
  800211:	6a 48                	push   $0x48
  800213:	68 e2 38 80 00       	push   $0x8038e2
  800218:	e8 74 05 00 00       	call   800791 <_panic>
		else
		{
			sys_disable_interrupt();
  80021d:	e8 b4 1e 00 00       	call   8020d6 <sys_disable_interrupt>
			cprintf("\n===============================================\n") ;
  800222:	83 ec 0c             	sub    $0xc,%esp
  800225:	68 f8 38 80 00       	push   $0x8038f8
  80022a:	e8 16 08 00 00       	call   800a45 <cprintf>
  80022f:	83 c4 10             	add    $0x10,%esp
			cprintf("Congratulations!! The array is sorted correctly\n") ;
  800232:	83 ec 0c             	sub    $0xc,%esp
  800235:	68 2c 39 80 00       	push   $0x80392c
  80023a:	e8 06 08 00 00       	call   800a45 <cprintf>
  80023f:	83 c4 10             	add    $0x10,%esp
			cprintf("===============================================\n\n") ;
  800242:	83 ec 0c             	sub    $0xc,%esp
  800245:	68 60 39 80 00       	push   $0x803960
  80024a:	e8 f6 07 00 00       	call   800a45 <cprintf>
  80024f:	83 c4 10             	add    $0x10,%esp
			sys_enable_interrupt();
  800252:	e8 99 1e 00 00       	call   8020f0 <sys_enable_interrupt>
		}

		sys_disable_interrupt();
  800257:	e8 7a 1e 00 00       	call   8020d6 <sys_disable_interrupt>
			Chose = 0 ;
  80025c:	c6 45 f7 00          	movb   $0x0,-0x9(%ebp)
			while (Chose != 'y' && Chose != 'n')
  800260:	eb 42                	jmp    8002a4 <_main+0x26c>
			{
				cprintf("Do you want to repeat (y/n): ") ;
  800262:	83 ec 0c             	sub    $0xc,%esp
  800265:	68 92 39 80 00       	push   $0x803992
  80026a:	e8 d6 07 00 00       	call   800a45 <cprintf>
  80026f:	83 c4 10             	add    $0x10,%esp
				Chose = getchar() ;
  800272:	e8 86 03 00 00       	call   8005fd <getchar>
  800277:	88 45 f7             	mov    %al,-0x9(%ebp)
				cputchar(Chose);
  80027a:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
  80027e:	83 ec 0c             	sub    $0xc,%esp
  800281:	50                   	push   %eax
  800282:	e8 2e 03 00 00       	call   8005b5 <cputchar>
  800287:	83 c4 10             	add    $0x10,%esp
				cputchar('\n');
  80028a:	83 ec 0c             	sub    $0xc,%esp
  80028d:	6a 0a                	push   $0xa
  80028f:	e8 21 03 00 00       	call   8005b5 <cputchar>
  800294:	83 c4 10             	add    $0x10,%esp
				cputchar('\n');
  800297:	83 ec 0c             	sub    $0xc,%esp
  80029a:	6a 0a                	push   $0xa
  80029c:	e8 14 03 00 00       	call   8005b5 <cputchar>
  8002a1:	83 c4 10             	add    $0x10,%esp
			sys_enable_interrupt();
		}

		sys_disable_interrupt();
			Chose = 0 ;
			while (Chose != 'y' && Chose != 'n')
  8002a4:	80 7d f7 79          	cmpb   $0x79,-0x9(%ebp)
  8002a8:	74 06                	je     8002b0 <_main+0x278>
  8002aa:	80 7d f7 6e          	cmpb   $0x6e,-0x9(%ebp)
  8002ae:	75 b2                	jne    800262 <_main+0x22a>
				Chose = getchar() ;
				cputchar(Chose);
				cputchar('\n');
				cputchar('\n');
			}
		sys_enable_interrupt();
  8002b0:	e8 3b 1e 00 00       	call   8020f0 <sys_enable_interrupt>

	} while (Chose == 'y');
  8002b5:	80 7d f7 79          	cmpb   $0x79,-0x9(%ebp)
  8002b9:	0f 84 82 fd ff ff    	je     800041 <_main+0x9>

}
  8002bf:	90                   	nop
  8002c0:	c9                   	leave  
  8002c1:	c3                   	ret    

008002c2 <QuickSort>:

///Quick sort
void QuickSort(int *Elements, int NumOfElements)
{
  8002c2:	55                   	push   %ebp
  8002c3:	89 e5                	mov    %esp,%ebp
  8002c5:	83 ec 08             	sub    $0x8,%esp
	QSort(Elements, NumOfElements, 0, NumOfElements-1) ;
  8002c8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8002cb:	48                   	dec    %eax
  8002cc:	50                   	push   %eax
  8002cd:	6a 00                	push   $0x0
  8002cf:	ff 75 0c             	pushl  0xc(%ebp)
  8002d2:	ff 75 08             	pushl  0x8(%ebp)
  8002d5:	e8 06 00 00 00       	call   8002e0 <QSort>
  8002da:	83 c4 10             	add    $0x10,%esp
}
  8002dd:	90                   	nop
  8002de:	c9                   	leave  
  8002df:	c3                   	ret    

008002e0 <QSort>:


void QSort(int *Elements,int NumOfElements, int startIndex, int finalIndex)
{
  8002e0:	55                   	push   %ebp
  8002e1:	89 e5                	mov    %esp,%ebp
  8002e3:	83 ec 18             	sub    $0x18,%esp
	if (startIndex >= finalIndex) return;
  8002e6:	8b 45 10             	mov    0x10(%ebp),%eax
  8002e9:	3b 45 14             	cmp    0x14(%ebp),%eax
  8002ec:	0f 8d de 00 00 00    	jge    8003d0 <QSort+0xf0>

	int i = startIndex+1, j = finalIndex;
  8002f2:	8b 45 10             	mov    0x10(%ebp),%eax
  8002f5:	40                   	inc    %eax
  8002f6:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8002f9:	8b 45 14             	mov    0x14(%ebp),%eax
  8002fc:	89 45 f0             	mov    %eax,-0x10(%ebp)

	while (i <= j)
  8002ff:	e9 80 00 00 00       	jmp    800384 <QSort+0xa4>
	{
		while (i <= finalIndex && Elements[startIndex] >= Elements[i]) i++;
  800304:	ff 45 f4             	incl   -0xc(%ebp)
  800307:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80030a:	3b 45 14             	cmp    0x14(%ebp),%eax
  80030d:	7f 2b                	jg     80033a <QSort+0x5a>
  80030f:	8b 45 10             	mov    0x10(%ebp),%eax
  800312:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800319:	8b 45 08             	mov    0x8(%ebp),%eax
  80031c:	01 d0                	add    %edx,%eax
  80031e:	8b 10                	mov    (%eax),%edx
  800320:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800323:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  80032a:	8b 45 08             	mov    0x8(%ebp),%eax
  80032d:	01 c8                	add    %ecx,%eax
  80032f:	8b 00                	mov    (%eax),%eax
  800331:	39 c2                	cmp    %eax,%edx
  800333:	7d cf                	jge    800304 <QSort+0x24>
		while (j > startIndex && Elements[startIndex] <= Elements[j]) j--;
  800335:	eb 03                	jmp    80033a <QSort+0x5a>
  800337:	ff 4d f0             	decl   -0x10(%ebp)
  80033a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80033d:	3b 45 10             	cmp    0x10(%ebp),%eax
  800340:	7e 26                	jle    800368 <QSort+0x88>
  800342:	8b 45 10             	mov    0x10(%ebp),%eax
  800345:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80034c:	8b 45 08             	mov    0x8(%ebp),%eax
  80034f:	01 d0                	add    %edx,%eax
  800351:	8b 10                	mov    (%eax),%edx
  800353:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800356:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  80035d:	8b 45 08             	mov    0x8(%ebp),%eax
  800360:	01 c8                	add    %ecx,%eax
  800362:	8b 00                	mov    (%eax),%eax
  800364:	39 c2                	cmp    %eax,%edx
  800366:	7e cf                	jle    800337 <QSort+0x57>

		if (i <= j)
  800368:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80036b:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80036e:	7f 14                	jg     800384 <QSort+0xa4>
		{
			Swap(Elements, i, j);
  800370:	83 ec 04             	sub    $0x4,%esp
  800373:	ff 75 f0             	pushl  -0x10(%ebp)
  800376:	ff 75 f4             	pushl  -0xc(%ebp)
  800379:	ff 75 08             	pushl  0x8(%ebp)
  80037c:	e8 a9 00 00 00       	call   80042a <Swap>
  800381:	83 c4 10             	add    $0x10,%esp
{
	if (startIndex >= finalIndex) return;

	int i = startIndex+1, j = finalIndex;

	while (i <= j)
  800384:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800387:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80038a:	0f 8e 77 ff ff ff    	jle    800307 <QSort+0x27>
		{
			Swap(Elements, i, j);
		}
	}

	Swap( Elements, startIndex, j);
  800390:	83 ec 04             	sub    $0x4,%esp
  800393:	ff 75 f0             	pushl  -0x10(%ebp)
  800396:	ff 75 10             	pushl  0x10(%ebp)
  800399:	ff 75 08             	pushl  0x8(%ebp)
  80039c:	e8 89 00 00 00       	call   80042a <Swap>
  8003a1:	83 c4 10             	add    $0x10,%esp

	QSort(Elements, NumOfElements, startIndex, j - 1);
  8003a4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8003a7:	48                   	dec    %eax
  8003a8:	50                   	push   %eax
  8003a9:	ff 75 10             	pushl  0x10(%ebp)
  8003ac:	ff 75 0c             	pushl  0xc(%ebp)
  8003af:	ff 75 08             	pushl  0x8(%ebp)
  8003b2:	e8 29 ff ff ff       	call   8002e0 <QSort>
  8003b7:	83 c4 10             	add    $0x10,%esp
	QSort(Elements, NumOfElements, i, finalIndex);
  8003ba:	ff 75 14             	pushl  0x14(%ebp)
  8003bd:	ff 75 f4             	pushl  -0xc(%ebp)
  8003c0:	ff 75 0c             	pushl  0xc(%ebp)
  8003c3:	ff 75 08             	pushl  0x8(%ebp)
  8003c6:	e8 15 ff ff ff       	call   8002e0 <QSort>
  8003cb:	83 c4 10             	add    $0x10,%esp
  8003ce:	eb 01                	jmp    8003d1 <QSort+0xf1>
}


void QSort(int *Elements,int NumOfElements, int startIndex, int finalIndex)
{
	if (startIndex >= finalIndex) return;
  8003d0:	90                   	nop
	QSort(Elements, NumOfElements, startIndex, j - 1);
	QSort(Elements, NumOfElements, i, finalIndex);

	//cprintf("qs,after sorting: start = %d, end = %d\n", startIndex, finalIndex);

}
  8003d1:	c9                   	leave  
  8003d2:	c3                   	ret    

008003d3 <CheckSorted>:

uint32 CheckSorted(int *Elements, int NumOfElements)
{
  8003d3:	55                   	push   %ebp
  8003d4:	89 e5                	mov    %esp,%ebp
  8003d6:	83 ec 10             	sub    $0x10,%esp
	uint32 Sorted = 1 ;
  8003d9:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
	int i ;
	for (i = 0 ; i < NumOfElements - 1; i++)
  8003e0:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  8003e7:	eb 33                	jmp    80041c <CheckSorted+0x49>
	{
		if (Elements[i] > Elements[i+1])
  8003e9:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8003ec:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8003f3:	8b 45 08             	mov    0x8(%ebp),%eax
  8003f6:	01 d0                	add    %edx,%eax
  8003f8:	8b 10                	mov    (%eax),%edx
  8003fa:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8003fd:	40                   	inc    %eax
  8003fe:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  800405:	8b 45 08             	mov    0x8(%ebp),%eax
  800408:	01 c8                	add    %ecx,%eax
  80040a:	8b 00                	mov    (%eax),%eax
  80040c:	39 c2                	cmp    %eax,%edx
  80040e:	7e 09                	jle    800419 <CheckSorted+0x46>
		{
			Sorted = 0 ;
  800410:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
			break;
  800417:	eb 0c                	jmp    800425 <CheckSorted+0x52>

uint32 CheckSorted(int *Elements, int NumOfElements)
{
	uint32 Sorted = 1 ;
	int i ;
	for (i = 0 ; i < NumOfElements - 1; i++)
  800419:	ff 45 f8             	incl   -0x8(%ebp)
  80041c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80041f:	48                   	dec    %eax
  800420:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800423:	7f c4                	jg     8003e9 <CheckSorted+0x16>
		{
			Sorted = 0 ;
			break;
		}
	}
	return Sorted ;
  800425:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800428:	c9                   	leave  
  800429:	c3                   	ret    

0080042a <Swap>:

///Private Functions


void Swap(int *Elements, int First, int Second)
{
  80042a:	55                   	push   %ebp
  80042b:	89 e5                	mov    %esp,%ebp
  80042d:	83 ec 10             	sub    $0x10,%esp
	int Tmp = Elements[First] ;
  800430:	8b 45 0c             	mov    0xc(%ebp),%eax
  800433:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80043a:	8b 45 08             	mov    0x8(%ebp),%eax
  80043d:	01 d0                	add    %edx,%eax
  80043f:	8b 00                	mov    (%eax),%eax
  800441:	89 45 fc             	mov    %eax,-0x4(%ebp)
	Elements[First] = Elements[Second] ;
  800444:	8b 45 0c             	mov    0xc(%ebp),%eax
  800447:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80044e:	8b 45 08             	mov    0x8(%ebp),%eax
  800451:	01 c2                	add    %eax,%edx
  800453:	8b 45 10             	mov    0x10(%ebp),%eax
  800456:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  80045d:	8b 45 08             	mov    0x8(%ebp),%eax
  800460:	01 c8                	add    %ecx,%eax
  800462:	8b 00                	mov    (%eax),%eax
  800464:	89 02                	mov    %eax,(%edx)
	Elements[Second] = Tmp ;
  800466:	8b 45 10             	mov    0x10(%ebp),%eax
  800469:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800470:	8b 45 08             	mov    0x8(%ebp),%eax
  800473:	01 c2                	add    %eax,%edx
  800475:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800478:	89 02                	mov    %eax,(%edx)
}
  80047a:	90                   	nop
  80047b:	c9                   	leave  
  80047c:	c3                   	ret    

0080047d <InitializeAscending>:

void InitializeAscending(int *Elements, int NumOfElements)
{
  80047d:	55                   	push   %ebp
  80047e:	89 e5                	mov    %esp,%ebp
  800480:	83 ec 10             	sub    $0x10,%esp
	int i ;
	for (i = 0 ; i < NumOfElements ; i++)
  800483:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  80048a:	eb 17                	jmp    8004a3 <InitializeAscending+0x26>
	{
		(Elements)[i] = i ;
  80048c:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80048f:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800496:	8b 45 08             	mov    0x8(%ebp),%eax
  800499:	01 c2                	add    %eax,%edx
  80049b:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80049e:	89 02                	mov    %eax,(%edx)
}

void InitializeAscending(int *Elements, int NumOfElements)
{
	int i ;
	for (i = 0 ; i < NumOfElements ; i++)
  8004a0:	ff 45 fc             	incl   -0x4(%ebp)
  8004a3:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8004a6:	3b 45 0c             	cmp    0xc(%ebp),%eax
  8004a9:	7c e1                	jl     80048c <InitializeAscending+0xf>
	{
		(Elements)[i] = i ;
	}

}
  8004ab:	90                   	nop
  8004ac:	c9                   	leave  
  8004ad:	c3                   	ret    

008004ae <InitializeDescending>:

void InitializeDescending(int *Elements, int NumOfElements)
{
  8004ae:	55                   	push   %ebp
  8004af:	89 e5                	mov    %esp,%ebp
  8004b1:	83 ec 10             	sub    $0x10,%esp
	int i ;
	for (i = 0 ; i < NumOfElements ; i++)
  8004b4:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8004bb:	eb 1b                	jmp    8004d8 <InitializeDescending+0x2a>
	{
		Elements[i] = NumOfElements - i - 1 ;
  8004bd:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8004c0:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8004c7:	8b 45 08             	mov    0x8(%ebp),%eax
  8004ca:	01 c2                	add    %eax,%edx
  8004cc:	8b 45 0c             	mov    0xc(%ebp),%eax
  8004cf:	2b 45 fc             	sub    -0x4(%ebp),%eax
  8004d2:	48                   	dec    %eax
  8004d3:	89 02                	mov    %eax,(%edx)
}

void InitializeDescending(int *Elements, int NumOfElements)
{
	int i ;
	for (i = 0 ; i < NumOfElements ; i++)
  8004d5:	ff 45 fc             	incl   -0x4(%ebp)
  8004d8:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8004db:	3b 45 0c             	cmp    0xc(%ebp),%eax
  8004de:	7c dd                	jl     8004bd <InitializeDescending+0xf>
	{
		Elements[i] = NumOfElements - i - 1 ;
	}

}
  8004e0:	90                   	nop
  8004e1:	c9                   	leave  
  8004e2:	c3                   	ret    

008004e3 <InitializeSemiRandom>:

void InitializeSemiRandom(int *Elements, int NumOfElements)
{
  8004e3:	55                   	push   %ebp
  8004e4:	89 e5                	mov    %esp,%ebp
  8004e6:	83 ec 10             	sub    $0x10,%esp
	int i ;
	int Repetition = NumOfElements / 3 ;
  8004e9:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8004ec:	b8 56 55 55 55       	mov    $0x55555556,%eax
  8004f1:	f7 e9                	imul   %ecx
  8004f3:	c1 f9 1f             	sar    $0x1f,%ecx
  8004f6:	89 d0                	mov    %edx,%eax
  8004f8:	29 c8                	sub    %ecx,%eax
  8004fa:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0 ; i < NumOfElements ; i++)
  8004fd:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800504:	eb 1e                	jmp    800524 <InitializeSemiRandom+0x41>
	{
		Elements[i] = i % Repetition ;
  800506:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800509:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800510:	8b 45 08             	mov    0x8(%ebp),%eax
  800513:	8d 0c 02             	lea    (%edx,%eax,1),%ecx
  800516:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800519:	99                   	cltd   
  80051a:	f7 7d f8             	idivl  -0x8(%ebp)
  80051d:	89 d0                	mov    %edx,%eax
  80051f:	89 01                	mov    %eax,(%ecx)

void InitializeSemiRandom(int *Elements, int NumOfElements)
{
	int i ;
	int Repetition = NumOfElements / 3 ;
	for (i = 0 ; i < NumOfElements ; i++)
  800521:	ff 45 fc             	incl   -0x4(%ebp)
  800524:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800527:	3b 45 0c             	cmp    0xc(%ebp),%eax
  80052a:	7c da                	jl     800506 <InitializeSemiRandom+0x23>
	{
		Elements[i] = i % Repetition ;
		//	cprintf("i=%d\n",i);
	}

}
  80052c:	90                   	nop
  80052d:	c9                   	leave  
  80052e:	c3                   	ret    

0080052f <PrintElements>:

void PrintElements(int *Elements, int NumOfElements)
{
  80052f:	55                   	push   %ebp
  800530:	89 e5                	mov    %esp,%ebp
  800532:	83 ec 18             	sub    $0x18,%esp
	int i ;
	int NumsPerLine = 20 ;
  800535:	c7 45 f0 14 00 00 00 	movl   $0x14,-0x10(%ebp)
	for (i = 0 ; i < NumOfElements-1 ; i++)
  80053c:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  800543:	eb 42                	jmp    800587 <PrintElements+0x58>
	{
		if (i%NumsPerLine == 0)
  800545:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800548:	99                   	cltd   
  800549:	f7 7d f0             	idivl  -0x10(%ebp)
  80054c:	89 d0                	mov    %edx,%eax
  80054e:	85 c0                	test   %eax,%eax
  800550:	75 10                	jne    800562 <PrintElements+0x33>
			cprintf("\n");
  800552:	83 ec 0c             	sub    $0xc,%esp
  800555:	68 e0 37 80 00       	push   $0x8037e0
  80055a:	e8 e6 04 00 00       	call   800a45 <cprintf>
  80055f:	83 c4 10             	add    $0x10,%esp
		cprintf("%d, ",Elements[i]);
  800562:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800565:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80056c:	8b 45 08             	mov    0x8(%ebp),%eax
  80056f:	01 d0                	add    %edx,%eax
  800571:	8b 00                	mov    (%eax),%eax
  800573:	83 ec 08             	sub    $0x8,%esp
  800576:	50                   	push   %eax
  800577:	68 b0 39 80 00       	push   $0x8039b0
  80057c:	e8 c4 04 00 00       	call   800a45 <cprintf>
  800581:	83 c4 10             	add    $0x10,%esp

void PrintElements(int *Elements, int NumOfElements)
{
	int i ;
	int NumsPerLine = 20 ;
	for (i = 0 ; i < NumOfElements-1 ; i++)
  800584:	ff 45 f4             	incl   -0xc(%ebp)
  800587:	8b 45 0c             	mov    0xc(%ebp),%eax
  80058a:	48                   	dec    %eax
  80058b:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  80058e:	7f b5                	jg     800545 <PrintElements+0x16>
	{
		if (i%NumsPerLine == 0)
			cprintf("\n");
		cprintf("%d, ",Elements[i]);
	}
	cprintf("%d\n",Elements[i]);
  800590:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800593:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80059a:	8b 45 08             	mov    0x8(%ebp),%eax
  80059d:	01 d0                	add    %edx,%eax
  80059f:	8b 00                	mov    (%eax),%eax
  8005a1:	83 ec 08             	sub    $0x8,%esp
  8005a4:	50                   	push   %eax
  8005a5:	68 b5 39 80 00       	push   $0x8039b5
  8005aa:	e8 96 04 00 00       	call   800a45 <cprintf>
  8005af:	83 c4 10             	add    $0x10,%esp

}
  8005b2:	90                   	nop
  8005b3:	c9                   	leave  
  8005b4:	c3                   	ret    

008005b5 <cputchar>:
#include <inc/lib.h>


void
cputchar(int ch)
{
  8005b5:	55                   	push   %ebp
  8005b6:	89 e5                	mov    %esp,%ebp
  8005b8:	83 ec 18             	sub    $0x18,%esp
	char c = ch;
  8005bb:	8b 45 08             	mov    0x8(%ebp),%eax
  8005be:	88 45 f7             	mov    %al,-0x9(%ebp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	//sys_cputs(&c, 1);

	sys_cputc(c);
  8005c1:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
  8005c5:	83 ec 0c             	sub    $0xc,%esp
  8005c8:	50                   	push   %eax
  8005c9:	e8 3c 1b 00 00       	call   80210a <sys_cputc>
  8005ce:	83 c4 10             	add    $0x10,%esp
}
  8005d1:	90                   	nop
  8005d2:	c9                   	leave  
  8005d3:	c3                   	ret    

008005d4 <atomic_cputchar>:


void
atomic_cputchar(int ch)
{
  8005d4:	55                   	push   %ebp
  8005d5:	89 e5                	mov    %esp,%ebp
  8005d7:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  8005da:	e8 f7 1a 00 00       	call   8020d6 <sys_disable_interrupt>
	char c = ch;
  8005df:	8b 45 08             	mov    0x8(%ebp),%eax
  8005e2:	88 45 f7             	mov    %al,-0x9(%ebp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	//sys_cputs(&c, 1);

	sys_cputc(c);
  8005e5:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
  8005e9:	83 ec 0c             	sub    $0xc,%esp
  8005ec:	50                   	push   %eax
  8005ed:	e8 18 1b 00 00       	call   80210a <sys_cputc>
  8005f2:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  8005f5:	e8 f6 1a 00 00       	call   8020f0 <sys_enable_interrupt>
}
  8005fa:	90                   	nop
  8005fb:	c9                   	leave  
  8005fc:	c3                   	ret    

008005fd <getchar>:

int
getchar(void)
{
  8005fd:	55                   	push   %ebp
  8005fe:	89 e5                	mov    %esp,%ebp
  800600:	83 ec 18             	sub    $0x18,%esp

	//return sys_cgetc();
	int c=0;
  800603:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	while(c == 0)
  80060a:	eb 08                	jmp    800614 <getchar+0x17>
	{
		c = sys_cgetc();
  80060c:	e8 40 19 00 00       	call   801f51 <sys_cgetc>
  800611:	89 45 f4             	mov    %eax,-0xc(%ebp)
getchar(void)
{

	//return sys_cgetc();
	int c=0;
	while(c == 0)
  800614:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  800618:	74 f2                	je     80060c <getchar+0xf>
	{
		c = sys_cgetc();
	}
	return c;
  80061a:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  80061d:	c9                   	leave  
  80061e:	c3                   	ret    

0080061f <atomic_getchar>:

int
atomic_getchar(void)
{
  80061f:	55                   	push   %ebp
  800620:	89 e5                	mov    %esp,%ebp
  800622:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  800625:	e8 ac 1a 00 00       	call   8020d6 <sys_disable_interrupt>
	int c=0;
  80062a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	while(c == 0)
  800631:	eb 08                	jmp    80063b <atomic_getchar+0x1c>
	{
		c = sys_cgetc();
  800633:	e8 19 19 00 00       	call   801f51 <sys_cgetc>
  800638:	89 45 f4             	mov    %eax,-0xc(%ebp)
int
atomic_getchar(void)
{
	sys_disable_interrupt();
	int c=0;
	while(c == 0)
  80063b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80063f:	74 f2                	je     800633 <atomic_getchar+0x14>
	{
		c = sys_cgetc();
	}
	sys_enable_interrupt();
  800641:	e8 aa 1a 00 00       	call   8020f0 <sys_enable_interrupt>
	return c;
  800646:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  800649:	c9                   	leave  
  80064a:	c3                   	ret    

0080064b <iscons>:

int iscons(int fdnum)
{
  80064b:	55                   	push   %ebp
  80064c:	89 e5                	mov    %esp,%ebp
	// used by readline
	return 1;
  80064e:	b8 01 00 00 00       	mov    $0x1,%eax
}
  800653:	5d                   	pop    %ebp
  800654:	c3                   	ret    

00800655 <libmain>:
volatile struct Env *myEnv = NULL;
volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";

void
libmain(int argc, char **argv)
{
  800655:	55                   	push   %ebp
  800656:	89 e5                	mov    %esp,%ebp
  800658:	83 ec 18             	sub    $0x18,%esp
	int envIndex = sys_getenvindex();
  80065b:	e8 69 1c 00 00       	call   8022c9 <sys_getenvindex>
  800660:	89 45 f4             	mov    %eax,-0xc(%ebp)
	myEnv = &(envs[envIndex]);
  800663:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800666:	89 d0                	mov    %edx,%eax
  800668:	c1 e0 03             	shl    $0x3,%eax
  80066b:	01 d0                	add    %edx,%eax
  80066d:	01 c0                	add    %eax,%eax
  80066f:	01 d0                	add    %edx,%eax
  800671:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800678:	01 d0                	add    %edx,%eax
  80067a:	c1 e0 04             	shl    $0x4,%eax
  80067d:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  800682:	a3 24 50 80 00       	mov    %eax,0x805024

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  800687:	a1 24 50 80 00       	mov    0x805024,%eax
  80068c:	8a 80 5c 05 00 00    	mov    0x55c(%eax),%al
  800692:	84 c0                	test   %al,%al
  800694:	74 0f                	je     8006a5 <libmain+0x50>
		binaryname = myEnv->prog_name;
  800696:	a1 24 50 80 00       	mov    0x805024,%eax
  80069b:	05 5c 05 00 00       	add    $0x55c,%eax
  8006a0:	a3 00 50 80 00       	mov    %eax,0x805000

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8006a5:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8006a9:	7e 0a                	jle    8006b5 <libmain+0x60>
		binaryname = argv[0];
  8006ab:	8b 45 0c             	mov    0xc(%ebp),%eax
  8006ae:	8b 00                	mov    (%eax),%eax
  8006b0:	a3 00 50 80 00       	mov    %eax,0x805000

	// call user main routine
	_main(argc, argv);
  8006b5:	83 ec 08             	sub    $0x8,%esp
  8006b8:	ff 75 0c             	pushl  0xc(%ebp)
  8006bb:	ff 75 08             	pushl  0x8(%ebp)
  8006be:	e8 75 f9 ff ff       	call   800038 <_main>
  8006c3:	83 c4 10             	add    $0x10,%esp



	sys_disable_interrupt();
  8006c6:	e8 0b 1a 00 00       	call   8020d6 <sys_disable_interrupt>
	cprintf("**************************************\n");
  8006cb:	83 ec 0c             	sub    $0xc,%esp
  8006ce:	68 d4 39 80 00       	push   $0x8039d4
  8006d3:	e8 6d 03 00 00       	call   800a45 <cprintf>
  8006d8:	83 c4 10             	add    $0x10,%esp
	cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  8006db:	a1 24 50 80 00       	mov    0x805024,%eax
  8006e0:	8b 90 44 05 00 00    	mov    0x544(%eax),%edx
  8006e6:	a1 24 50 80 00       	mov    0x805024,%eax
  8006eb:	8b 80 34 05 00 00    	mov    0x534(%eax),%eax
  8006f1:	83 ec 04             	sub    $0x4,%esp
  8006f4:	52                   	push   %edx
  8006f5:	50                   	push   %eax
  8006f6:	68 fc 39 80 00       	push   $0x8039fc
  8006fb:	e8 45 03 00 00       	call   800a45 <cprintf>
  800700:	83 c4 10             	add    $0x10,%esp
	cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  800703:	a1 24 50 80 00       	mov    0x805024,%eax
  800708:	8b 88 54 05 00 00    	mov    0x554(%eax),%ecx
  80070e:	a1 24 50 80 00       	mov    0x805024,%eax
  800713:	8b 90 50 05 00 00    	mov    0x550(%eax),%edx
  800719:	a1 24 50 80 00       	mov    0x805024,%eax
  80071e:	8b 80 4c 05 00 00    	mov    0x54c(%eax),%eax
  800724:	51                   	push   %ecx
  800725:	52                   	push   %edx
  800726:	50                   	push   %eax
  800727:	68 24 3a 80 00       	push   $0x803a24
  80072c:	e8 14 03 00 00       	call   800a45 <cprintf>
  800731:	83 c4 10             	add    $0x10,%esp
	//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
	cprintf("Num of clocks = %d\n", myEnv->nClocks);
  800734:	a1 24 50 80 00       	mov    0x805024,%eax
  800739:	8b 80 a4 05 00 00    	mov    0x5a4(%eax),%eax
  80073f:	83 ec 08             	sub    $0x8,%esp
  800742:	50                   	push   %eax
  800743:	68 7c 3a 80 00       	push   $0x803a7c
  800748:	e8 f8 02 00 00       	call   800a45 <cprintf>
  80074d:	83 c4 10             	add    $0x10,%esp
	cprintf("**************************************\n");
  800750:	83 ec 0c             	sub    $0xc,%esp
  800753:	68 d4 39 80 00       	push   $0x8039d4
  800758:	e8 e8 02 00 00       	call   800a45 <cprintf>
  80075d:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  800760:	e8 8b 19 00 00       	call   8020f0 <sys_enable_interrupt>

	// exit gracefully
	exit();
  800765:	e8 19 00 00 00       	call   800783 <exit>
}
  80076a:	90                   	nop
  80076b:	c9                   	leave  
  80076c:	c3                   	ret    

0080076d <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  80076d:	55                   	push   %ebp
  80076e:	89 e5                	mov    %esp,%ebp
  800770:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  800773:	83 ec 0c             	sub    $0xc,%esp
  800776:	6a 00                	push   $0x0
  800778:	e8 18 1b 00 00       	call   802295 <sys_destroy_env>
  80077d:	83 c4 10             	add    $0x10,%esp
}
  800780:	90                   	nop
  800781:	c9                   	leave  
  800782:	c3                   	ret    

00800783 <exit>:

void
exit(void)
{
  800783:	55                   	push   %ebp
  800784:	89 e5                	mov    %esp,%ebp
  800786:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  800789:	e8 6d 1b 00 00       	call   8022fb <sys_exit_env>
}
  80078e:	90                   	nop
  80078f:	c9                   	leave  
  800790:	c3                   	ret    

00800791 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  800791:	55                   	push   %ebp
  800792:	89 e5                	mov    %esp,%ebp
  800794:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  800797:	8d 45 10             	lea    0x10(%ebp),%eax
  80079a:	83 c0 04             	add    $0x4,%eax
  80079d:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  8007a0:	a1 5c 51 80 00       	mov    0x80515c,%eax
  8007a5:	85 c0                	test   %eax,%eax
  8007a7:	74 16                	je     8007bf <_panic+0x2e>
		cprintf("%s: ", argv0);
  8007a9:	a1 5c 51 80 00       	mov    0x80515c,%eax
  8007ae:	83 ec 08             	sub    $0x8,%esp
  8007b1:	50                   	push   %eax
  8007b2:	68 90 3a 80 00       	push   $0x803a90
  8007b7:	e8 89 02 00 00       	call   800a45 <cprintf>
  8007bc:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  8007bf:	a1 00 50 80 00       	mov    0x805000,%eax
  8007c4:	ff 75 0c             	pushl  0xc(%ebp)
  8007c7:	ff 75 08             	pushl  0x8(%ebp)
  8007ca:	50                   	push   %eax
  8007cb:	68 95 3a 80 00       	push   $0x803a95
  8007d0:	e8 70 02 00 00       	call   800a45 <cprintf>
  8007d5:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  8007d8:	8b 45 10             	mov    0x10(%ebp),%eax
  8007db:	83 ec 08             	sub    $0x8,%esp
  8007de:	ff 75 f4             	pushl  -0xc(%ebp)
  8007e1:	50                   	push   %eax
  8007e2:	e8 f3 01 00 00       	call   8009da <vcprintf>
  8007e7:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  8007ea:	83 ec 08             	sub    $0x8,%esp
  8007ed:	6a 00                	push   $0x0
  8007ef:	68 b1 3a 80 00       	push   $0x803ab1
  8007f4:	e8 e1 01 00 00       	call   8009da <vcprintf>
  8007f9:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  8007fc:	e8 82 ff ff ff       	call   800783 <exit>

	// should not return here
	while (1) ;
  800801:	eb fe                	jmp    800801 <_panic+0x70>

00800803 <CheckWSWithoutLastIndex>:
}

void CheckWSWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  800803:	55                   	push   %ebp
  800804:	89 e5                	mov    %esp,%ebp
  800806:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  800809:	a1 24 50 80 00       	mov    0x805024,%eax
  80080e:	8b 50 74             	mov    0x74(%eax),%edx
  800811:	8b 45 0c             	mov    0xc(%ebp),%eax
  800814:	39 c2                	cmp    %eax,%edx
  800816:	74 14                	je     80082c <CheckWSWithoutLastIndex+0x29>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  800818:	83 ec 04             	sub    $0x4,%esp
  80081b:	68 b4 3a 80 00       	push   $0x803ab4
  800820:	6a 26                	push   $0x26
  800822:	68 00 3b 80 00       	push   $0x803b00
  800827:	e8 65 ff ff ff       	call   800791 <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  80082c:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  800833:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  80083a:	e9 c2 00 00 00       	jmp    800901 <CheckWSWithoutLastIndex+0xfe>
		if (expectedPages[e] == 0) {
  80083f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800842:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800849:	8b 45 08             	mov    0x8(%ebp),%eax
  80084c:	01 d0                	add    %edx,%eax
  80084e:	8b 00                	mov    (%eax),%eax
  800850:	85 c0                	test   %eax,%eax
  800852:	75 08                	jne    80085c <CheckWSWithoutLastIndex+0x59>
			expectedNumOfEmptyLocs++;
  800854:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  800857:	e9 a2 00 00 00       	jmp    8008fe <CheckWSWithoutLastIndex+0xfb>
		}
		int found = 0;
  80085c:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800863:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  80086a:	eb 69                	jmp    8008d5 <CheckWSWithoutLastIndex+0xd2>
			if (myEnv->__uptr_pws[w].empty == 0) {
  80086c:	a1 24 50 80 00       	mov    0x805024,%eax
  800871:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  800877:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80087a:	89 d0                	mov    %edx,%eax
  80087c:	01 c0                	add    %eax,%eax
  80087e:	01 d0                	add    %edx,%eax
  800880:	c1 e0 03             	shl    $0x3,%eax
  800883:	01 c8                	add    %ecx,%eax
  800885:	8a 40 04             	mov    0x4(%eax),%al
  800888:	84 c0                	test   %al,%al
  80088a:	75 46                	jne    8008d2 <CheckWSWithoutLastIndex+0xcf>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  80088c:	a1 24 50 80 00       	mov    0x805024,%eax
  800891:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  800897:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80089a:	89 d0                	mov    %edx,%eax
  80089c:	01 c0                	add    %eax,%eax
  80089e:	01 d0                	add    %edx,%eax
  8008a0:	c1 e0 03             	shl    $0x3,%eax
  8008a3:	01 c8                	add    %ecx,%eax
  8008a5:	8b 00                	mov    (%eax),%eax
  8008a7:	89 45 dc             	mov    %eax,-0x24(%ebp)
  8008aa:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8008ad:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8008b2:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  8008b4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8008b7:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  8008be:	8b 45 08             	mov    0x8(%ebp),%eax
  8008c1:	01 c8                	add    %ecx,%eax
  8008c3:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  8008c5:	39 c2                	cmp    %eax,%edx
  8008c7:	75 09                	jne    8008d2 <CheckWSWithoutLastIndex+0xcf>
						== expectedPages[e]) {
					found = 1;
  8008c9:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  8008d0:	eb 12                	jmp    8008e4 <CheckWSWithoutLastIndex+0xe1>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8008d2:	ff 45 e8             	incl   -0x18(%ebp)
  8008d5:	a1 24 50 80 00       	mov    0x805024,%eax
  8008da:	8b 50 74             	mov    0x74(%eax),%edx
  8008dd:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8008e0:	39 c2                	cmp    %eax,%edx
  8008e2:	77 88                	ja     80086c <CheckWSWithoutLastIndex+0x69>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  8008e4:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8008e8:	75 14                	jne    8008fe <CheckWSWithoutLastIndex+0xfb>
			panic(
  8008ea:	83 ec 04             	sub    $0x4,%esp
  8008ed:	68 0c 3b 80 00       	push   $0x803b0c
  8008f2:	6a 3a                	push   $0x3a
  8008f4:	68 00 3b 80 00       	push   $0x803b00
  8008f9:	e8 93 fe ff ff       	call   800791 <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  8008fe:	ff 45 f0             	incl   -0x10(%ebp)
  800901:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800904:	3b 45 0c             	cmp    0xc(%ebp),%eax
  800907:	0f 8c 32 ff ff ff    	jl     80083f <CheckWSWithoutLastIndex+0x3c>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  80090d:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800914:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  80091b:	eb 26                	jmp    800943 <CheckWSWithoutLastIndex+0x140>
		if (myEnv->__uptr_pws[w].empty == 1) {
  80091d:	a1 24 50 80 00       	mov    0x805024,%eax
  800922:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  800928:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80092b:	89 d0                	mov    %edx,%eax
  80092d:	01 c0                	add    %eax,%eax
  80092f:	01 d0                	add    %edx,%eax
  800931:	c1 e0 03             	shl    $0x3,%eax
  800934:	01 c8                	add    %ecx,%eax
  800936:	8a 40 04             	mov    0x4(%eax),%al
  800939:	3c 01                	cmp    $0x1,%al
  80093b:	75 03                	jne    800940 <CheckWSWithoutLastIndex+0x13d>
			actualNumOfEmptyLocs++;
  80093d:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800940:	ff 45 e0             	incl   -0x20(%ebp)
  800943:	a1 24 50 80 00       	mov    0x805024,%eax
  800948:	8b 50 74             	mov    0x74(%eax),%edx
  80094b:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80094e:	39 c2                	cmp    %eax,%edx
  800950:	77 cb                	ja     80091d <CheckWSWithoutLastIndex+0x11a>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  800952:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800955:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  800958:	74 14                	je     80096e <CheckWSWithoutLastIndex+0x16b>
		panic(
  80095a:	83 ec 04             	sub    $0x4,%esp
  80095d:	68 60 3b 80 00       	push   $0x803b60
  800962:	6a 44                	push   $0x44
  800964:	68 00 3b 80 00       	push   $0x803b00
  800969:	e8 23 fe ff ff       	call   800791 <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  80096e:	90                   	nop
  80096f:	c9                   	leave  
  800970:	c3                   	ret    

00800971 <putch>:
};

//2017:
uint8 printProgName = 0;

static void putch(int ch, struct printbuf *b) {
  800971:	55                   	push   %ebp
  800972:	89 e5                	mov    %esp,%ebp
  800974:	83 ec 08             	sub    $0x8,%esp
	b->buf[b->idx++] = ch;
  800977:	8b 45 0c             	mov    0xc(%ebp),%eax
  80097a:	8b 00                	mov    (%eax),%eax
  80097c:	8d 48 01             	lea    0x1(%eax),%ecx
  80097f:	8b 55 0c             	mov    0xc(%ebp),%edx
  800982:	89 0a                	mov    %ecx,(%edx)
  800984:	8b 55 08             	mov    0x8(%ebp),%edx
  800987:	88 d1                	mov    %dl,%cl
  800989:	8b 55 0c             	mov    0xc(%ebp),%edx
  80098c:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  800990:	8b 45 0c             	mov    0xc(%ebp),%eax
  800993:	8b 00                	mov    (%eax),%eax
  800995:	3d ff 00 00 00       	cmp    $0xff,%eax
  80099a:	75 2c                	jne    8009c8 <putch+0x57>
		sys_cputs(b->buf, b->idx, printProgName);
  80099c:	a0 28 50 80 00       	mov    0x805028,%al
  8009a1:	0f b6 c0             	movzbl %al,%eax
  8009a4:	8b 55 0c             	mov    0xc(%ebp),%edx
  8009a7:	8b 12                	mov    (%edx),%edx
  8009a9:	89 d1                	mov    %edx,%ecx
  8009ab:	8b 55 0c             	mov    0xc(%ebp),%edx
  8009ae:	83 c2 08             	add    $0x8,%edx
  8009b1:	83 ec 04             	sub    $0x4,%esp
  8009b4:	50                   	push   %eax
  8009b5:	51                   	push   %ecx
  8009b6:	52                   	push   %edx
  8009b7:	e8 6c 15 00 00       	call   801f28 <sys_cputs>
  8009bc:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  8009bf:	8b 45 0c             	mov    0xc(%ebp),%eax
  8009c2:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  8009c8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8009cb:	8b 40 04             	mov    0x4(%eax),%eax
  8009ce:	8d 50 01             	lea    0x1(%eax),%edx
  8009d1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8009d4:	89 50 04             	mov    %edx,0x4(%eax)
}
  8009d7:	90                   	nop
  8009d8:	c9                   	leave  
  8009d9:	c3                   	ret    

008009da <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  8009da:	55                   	push   %ebp
  8009db:	89 e5                	mov    %esp,%ebp
  8009dd:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  8009e3:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  8009ea:	00 00 00 
	b.cnt = 0;
  8009ed:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  8009f4:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  8009f7:	ff 75 0c             	pushl  0xc(%ebp)
  8009fa:	ff 75 08             	pushl  0x8(%ebp)
  8009fd:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800a03:	50                   	push   %eax
  800a04:	68 71 09 80 00       	push   $0x800971
  800a09:	e8 11 02 00 00       	call   800c1f <vprintfmt>
  800a0e:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName);
  800a11:	a0 28 50 80 00       	mov    0x805028,%al
  800a16:	0f b6 c0             	movzbl %al,%eax
  800a19:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  800a1f:	83 ec 04             	sub    $0x4,%esp
  800a22:	50                   	push   %eax
  800a23:	52                   	push   %edx
  800a24:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800a2a:	83 c0 08             	add    $0x8,%eax
  800a2d:	50                   	push   %eax
  800a2e:	e8 f5 14 00 00       	call   801f28 <sys_cputs>
  800a33:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  800a36:	c6 05 28 50 80 00 00 	movb   $0x0,0x805028
	return b.cnt;
  800a3d:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  800a43:	c9                   	leave  
  800a44:	c3                   	ret    

00800a45 <cprintf>:

int cprintf(const char *fmt, ...) {
  800a45:	55                   	push   %ebp
  800a46:	89 e5                	mov    %esp,%ebp
  800a48:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  800a4b:	c6 05 28 50 80 00 01 	movb   $0x1,0x805028
	va_start(ap, fmt);
  800a52:	8d 45 0c             	lea    0xc(%ebp),%eax
  800a55:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800a58:	8b 45 08             	mov    0x8(%ebp),%eax
  800a5b:	83 ec 08             	sub    $0x8,%esp
  800a5e:	ff 75 f4             	pushl  -0xc(%ebp)
  800a61:	50                   	push   %eax
  800a62:	e8 73 ff ff ff       	call   8009da <vcprintf>
  800a67:	83 c4 10             	add    $0x10,%esp
  800a6a:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  800a6d:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800a70:	c9                   	leave  
  800a71:	c3                   	ret    

00800a72 <atomic_cprintf>:

int atomic_cprintf(const char *fmt, ...) {
  800a72:	55                   	push   %ebp
  800a73:	89 e5                	mov    %esp,%ebp
  800a75:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  800a78:	e8 59 16 00 00       	call   8020d6 <sys_disable_interrupt>
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  800a7d:	8d 45 0c             	lea    0xc(%ebp),%eax
  800a80:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800a83:	8b 45 08             	mov    0x8(%ebp),%eax
  800a86:	83 ec 08             	sub    $0x8,%esp
  800a89:	ff 75 f4             	pushl  -0xc(%ebp)
  800a8c:	50                   	push   %eax
  800a8d:	e8 48 ff ff ff       	call   8009da <vcprintf>
  800a92:	83 c4 10             	add    $0x10,%esp
  800a95:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	sys_enable_interrupt();
  800a98:	e8 53 16 00 00       	call   8020f0 <sys_enable_interrupt>
	return cnt;
  800a9d:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800aa0:	c9                   	leave  
  800aa1:	c3                   	ret    

00800aa2 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800aa2:	55                   	push   %ebp
  800aa3:	89 e5                	mov    %esp,%ebp
  800aa5:	53                   	push   %ebx
  800aa6:	83 ec 14             	sub    $0x14,%esp
  800aa9:	8b 45 10             	mov    0x10(%ebp),%eax
  800aac:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800aaf:	8b 45 14             	mov    0x14(%ebp),%eax
  800ab2:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800ab5:	8b 45 18             	mov    0x18(%ebp),%eax
  800ab8:	ba 00 00 00 00       	mov    $0x0,%edx
  800abd:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800ac0:	77 55                	ja     800b17 <printnum+0x75>
  800ac2:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800ac5:	72 05                	jb     800acc <printnum+0x2a>
  800ac7:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800aca:	77 4b                	ja     800b17 <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800acc:	8b 45 1c             	mov    0x1c(%ebp),%eax
  800acf:	8d 58 ff             	lea    -0x1(%eax),%ebx
  800ad2:	8b 45 18             	mov    0x18(%ebp),%eax
  800ad5:	ba 00 00 00 00       	mov    $0x0,%edx
  800ada:	52                   	push   %edx
  800adb:	50                   	push   %eax
  800adc:	ff 75 f4             	pushl  -0xc(%ebp)
  800adf:	ff 75 f0             	pushl  -0x10(%ebp)
  800ae2:	e8 8d 2a 00 00       	call   803574 <__udivdi3>
  800ae7:	83 c4 10             	add    $0x10,%esp
  800aea:	83 ec 04             	sub    $0x4,%esp
  800aed:	ff 75 20             	pushl  0x20(%ebp)
  800af0:	53                   	push   %ebx
  800af1:	ff 75 18             	pushl  0x18(%ebp)
  800af4:	52                   	push   %edx
  800af5:	50                   	push   %eax
  800af6:	ff 75 0c             	pushl  0xc(%ebp)
  800af9:	ff 75 08             	pushl  0x8(%ebp)
  800afc:	e8 a1 ff ff ff       	call   800aa2 <printnum>
  800b01:	83 c4 20             	add    $0x20,%esp
  800b04:	eb 1a                	jmp    800b20 <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800b06:	83 ec 08             	sub    $0x8,%esp
  800b09:	ff 75 0c             	pushl  0xc(%ebp)
  800b0c:	ff 75 20             	pushl  0x20(%ebp)
  800b0f:	8b 45 08             	mov    0x8(%ebp),%eax
  800b12:	ff d0                	call   *%eax
  800b14:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800b17:	ff 4d 1c             	decl   0x1c(%ebp)
  800b1a:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  800b1e:	7f e6                	jg     800b06 <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800b20:	8b 4d 18             	mov    0x18(%ebp),%ecx
  800b23:	bb 00 00 00 00       	mov    $0x0,%ebx
  800b28:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800b2b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800b2e:	53                   	push   %ebx
  800b2f:	51                   	push   %ecx
  800b30:	52                   	push   %edx
  800b31:	50                   	push   %eax
  800b32:	e8 4d 2b 00 00       	call   803684 <__umoddi3>
  800b37:	83 c4 10             	add    $0x10,%esp
  800b3a:	05 d4 3d 80 00       	add    $0x803dd4,%eax
  800b3f:	8a 00                	mov    (%eax),%al
  800b41:	0f be c0             	movsbl %al,%eax
  800b44:	83 ec 08             	sub    $0x8,%esp
  800b47:	ff 75 0c             	pushl  0xc(%ebp)
  800b4a:	50                   	push   %eax
  800b4b:	8b 45 08             	mov    0x8(%ebp),%eax
  800b4e:	ff d0                	call   *%eax
  800b50:	83 c4 10             	add    $0x10,%esp
}
  800b53:	90                   	nop
  800b54:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800b57:	c9                   	leave  
  800b58:	c3                   	ret    

00800b59 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  800b59:	55                   	push   %ebp
  800b5a:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800b5c:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800b60:	7e 1c                	jle    800b7e <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  800b62:	8b 45 08             	mov    0x8(%ebp),%eax
  800b65:	8b 00                	mov    (%eax),%eax
  800b67:	8d 50 08             	lea    0x8(%eax),%edx
  800b6a:	8b 45 08             	mov    0x8(%ebp),%eax
  800b6d:	89 10                	mov    %edx,(%eax)
  800b6f:	8b 45 08             	mov    0x8(%ebp),%eax
  800b72:	8b 00                	mov    (%eax),%eax
  800b74:	83 e8 08             	sub    $0x8,%eax
  800b77:	8b 50 04             	mov    0x4(%eax),%edx
  800b7a:	8b 00                	mov    (%eax),%eax
  800b7c:	eb 40                	jmp    800bbe <getuint+0x65>
	else if (lflag)
  800b7e:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800b82:	74 1e                	je     800ba2 <getuint+0x49>
		return va_arg(*ap, unsigned long);
  800b84:	8b 45 08             	mov    0x8(%ebp),%eax
  800b87:	8b 00                	mov    (%eax),%eax
  800b89:	8d 50 04             	lea    0x4(%eax),%edx
  800b8c:	8b 45 08             	mov    0x8(%ebp),%eax
  800b8f:	89 10                	mov    %edx,(%eax)
  800b91:	8b 45 08             	mov    0x8(%ebp),%eax
  800b94:	8b 00                	mov    (%eax),%eax
  800b96:	83 e8 04             	sub    $0x4,%eax
  800b99:	8b 00                	mov    (%eax),%eax
  800b9b:	ba 00 00 00 00       	mov    $0x0,%edx
  800ba0:	eb 1c                	jmp    800bbe <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  800ba2:	8b 45 08             	mov    0x8(%ebp),%eax
  800ba5:	8b 00                	mov    (%eax),%eax
  800ba7:	8d 50 04             	lea    0x4(%eax),%edx
  800baa:	8b 45 08             	mov    0x8(%ebp),%eax
  800bad:	89 10                	mov    %edx,(%eax)
  800baf:	8b 45 08             	mov    0x8(%ebp),%eax
  800bb2:	8b 00                	mov    (%eax),%eax
  800bb4:	83 e8 04             	sub    $0x4,%eax
  800bb7:	8b 00                	mov    (%eax),%eax
  800bb9:	ba 00 00 00 00       	mov    $0x0,%edx
}
  800bbe:	5d                   	pop    %ebp
  800bbf:	c3                   	ret    

00800bc0 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  800bc0:	55                   	push   %ebp
  800bc1:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800bc3:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800bc7:	7e 1c                	jle    800be5 <getint+0x25>
		return va_arg(*ap, long long);
  800bc9:	8b 45 08             	mov    0x8(%ebp),%eax
  800bcc:	8b 00                	mov    (%eax),%eax
  800bce:	8d 50 08             	lea    0x8(%eax),%edx
  800bd1:	8b 45 08             	mov    0x8(%ebp),%eax
  800bd4:	89 10                	mov    %edx,(%eax)
  800bd6:	8b 45 08             	mov    0x8(%ebp),%eax
  800bd9:	8b 00                	mov    (%eax),%eax
  800bdb:	83 e8 08             	sub    $0x8,%eax
  800bde:	8b 50 04             	mov    0x4(%eax),%edx
  800be1:	8b 00                	mov    (%eax),%eax
  800be3:	eb 38                	jmp    800c1d <getint+0x5d>
	else if (lflag)
  800be5:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800be9:	74 1a                	je     800c05 <getint+0x45>
		return va_arg(*ap, long);
  800beb:	8b 45 08             	mov    0x8(%ebp),%eax
  800bee:	8b 00                	mov    (%eax),%eax
  800bf0:	8d 50 04             	lea    0x4(%eax),%edx
  800bf3:	8b 45 08             	mov    0x8(%ebp),%eax
  800bf6:	89 10                	mov    %edx,(%eax)
  800bf8:	8b 45 08             	mov    0x8(%ebp),%eax
  800bfb:	8b 00                	mov    (%eax),%eax
  800bfd:	83 e8 04             	sub    $0x4,%eax
  800c00:	8b 00                	mov    (%eax),%eax
  800c02:	99                   	cltd   
  800c03:	eb 18                	jmp    800c1d <getint+0x5d>
	else
		return va_arg(*ap, int);
  800c05:	8b 45 08             	mov    0x8(%ebp),%eax
  800c08:	8b 00                	mov    (%eax),%eax
  800c0a:	8d 50 04             	lea    0x4(%eax),%edx
  800c0d:	8b 45 08             	mov    0x8(%ebp),%eax
  800c10:	89 10                	mov    %edx,(%eax)
  800c12:	8b 45 08             	mov    0x8(%ebp),%eax
  800c15:	8b 00                	mov    (%eax),%eax
  800c17:	83 e8 04             	sub    $0x4,%eax
  800c1a:	8b 00                	mov    (%eax),%eax
  800c1c:	99                   	cltd   
}
  800c1d:	5d                   	pop    %ebp
  800c1e:	c3                   	ret    

00800c1f <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  800c1f:	55                   	push   %ebp
  800c20:	89 e5                	mov    %esp,%ebp
  800c22:	56                   	push   %esi
  800c23:	53                   	push   %ebx
  800c24:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800c27:	eb 17                	jmp    800c40 <vprintfmt+0x21>
			if (ch == '\0')
  800c29:	85 db                	test   %ebx,%ebx
  800c2b:	0f 84 af 03 00 00    	je     800fe0 <vprintfmt+0x3c1>
				return;
			putch(ch, putdat);
  800c31:	83 ec 08             	sub    $0x8,%esp
  800c34:	ff 75 0c             	pushl  0xc(%ebp)
  800c37:	53                   	push   %ebx
  800c38:	8b 45 08             	mov    0x8(%ebp),%eax
  800c3b:	ff d0                	call   *%eax
  800c3d:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800c40:	8b 45 10             	mov    0x10(%ebp),%eax
  800c43:	8d 50 01             	lea    0x1(%eax),%edx
  800c46:	89 55 10             	mov    %edx,0x10(%ebp)
  800c49:	8a 00                	mov    (%eax),%al
  800c4b:	0f b6 d8             	movzbl %al,%ebx
  800c4e:	83 fb 25             	cmp    $0x25,%ebx
  800c51:	75 d6                	jne    800c29 <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  800c53:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  800c57:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  800c5e:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  800c65:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  800c6c:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800c73:	8b 45 10             	mov    0x10(%ebp),%eax
  800c76:	8d 50 01             	lea    0x1(%eax),%edx
  800c79:	89 55 10             	mov    %edx,0x10(%ebp)
  800c7c:	8a 00                	mov    (%eax),%al
  800c7e:	0f b6 d8             	movzbl %al,%ebx
  800c81:	8d 43 dd             	lea    -0x23(%ebx),%eax
  800c84:	83 f8 55             	cmp    $0x55,%eax
  800c87:	0f 87 2b 03 00 00    	ja     800fb8 <vprintfmt+0x399>
  800c8d:	8b 04 85 f8 3d 80 00 	mov    0x803df8(,%eax,4),%eax
  800c94:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  800c96:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  800c9a:	eb d7                	jmp    800c73 <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800c9c:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  800ca0:	eb d1                	jmp    800c73 <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800ca2:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  800ca9:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800cac:	89 d0                	mov    %edx,%eax
  800cae:	c1 e0 02             	shl    $0x2,%eax
  800cb1:	01 d0                	add    %edx,%eax
  800cb3:	01 c0                	add    %eax,%eax
  800cb5:	01 d8                	add    %ebx,%eax
  800cb7:	83 e8 30             	sub    $0x30,%eax
  800cba:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  800cbd:	8b 45 10             	mov    0x10(%ebp),%eax
  800cc0:	8a 00                	mov    (%eax),%al
  800cc2:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  800cc5:	83 fb 2f             	cmp    $0x2f,%ebx
  800cc8:	7e 3e                	jle    800d08 <vprintfmt+0xe9>
  800cca:	83 fb 39             	cmp    $0x39,%ebx
  800ccd:	7f 39                	jg     800d08 <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800ccf:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800cd2:	eb d5                	jmp    800ca9 <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  800cd4:	8b 45 14             	mov    0x14(%ebp),%eax
  800cd7:	83 c0 04             	add    $0x4,%eax
  800cda:	89 45 14             	mov    %eax,0x14(%ebp)
  800cdd:	8b 45 14             	mov    0x14(%ebp),%eax
  800ce0:	83 e8 04             	sub    $0x4,%eax
  800ce3:	8b 00                	mov    (%eax),%eax
  800ce5:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  800ce8:	eb 1f                	jmp    800d09 <vprintfmt+0xea>

		case '.':
			if (width < 0)
  800cea:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800cee:	79 83                	jns    800c73 <vprintfmt+0x54>
				width = 0;
  800cf0:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  800cf7:	e9 77 ff ff ff       	jmp    800c73 <vprintfmt+0x54>

		case '#':
			altflag = 1;
  800cfc:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  800d03:	e9 6b ff ff ff       	jmp    800c73 <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  800d08:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  800d09:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800d0d:	0f 89 60 ff ff ff    	jns    800c73 <vprintfmt+0x54>
				width = precision, precision = -1;
  800d13:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800d16:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800d19:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  800d20:	e9 4e ff ff ff       	jmp    800c73 <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  800d25:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  800d28:	e9 46 ff ff ff       	jmp    800c73 <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  800d2d:	8b 45 14             	mov    0x14(%ebp),%eax
  800d30:	83 c0 04             	add    $0x4,%eax
  800d33:	89 45 14             	mov    %eax,0x14(%ebp)
  800d36:	8b 45 14             	mov    0x14(%ebp),%eax
  800d39:	83 e8 04             	sub    $0x4,%eax
  800d3c:	8b 00                	mov    (%eax),%eax
  800d3e:	83 ec 08             	sub    $0x8,%esp
  800d41:	ff 75 0c             	pushl  0xc(%ebp)
  800d44:	50                   	push   %eax
  800d45:	8b 45 08             	mov    0x8(%ebp),%eax
  800d48:	ff d0                	call   *%eax
  800d4a:	83 c4 10             	add    $0x10,%esp
			break;
  800d4d:	e9 89 02 00 00       	jmp    800fdb <vprintfmt+0x3bc>

		// error message
		case 'e':
			err = va_arg(ap, int);
  800d52:	8b 45 14             	mov    0x14(%ebp),%eax
  800d55:	83 c0 04             	add    $0x4,%eax
  800d58:	89 45 14             	mov    %eax,0x14(%ebp)
  800d5b:	8b 45 14             	mov    0x14(%ebp),%eax
  800d5e:	83 e8 04             	sub    $0x4,%eax
  800d61:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  800d63:	85 db                	test   %ebx,%ebx
  800d65:	79 02                	jns    800d69 <vprintfmt+0x14a>
				err = -err;
  800d67:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  800d69:	83 fb 64             	cmp    $0x64,%ebx
  800d6c:	7f 0b                	jg     800d79 <vprintfmt+0x15a>
  800d6e:	8b 34 9d 40 3c 80 00 	mov    0x803c40(,%ebx,4),%esi
  800d75:	85 f6                	test   %esi,%esi
  800d77:	75 19                	jne    800d92 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  800d79:	53                   	push   %ebx
  800d7a:	68 e5 3d 80 00       	push   $0x803de5
  800d7f:	ff 75 0c             	pushl  0xc(%ebp)
  800d82:	ff 75 08             	pushl  0x8(%ebp)
  800d85:	e8 5e 02 00 00       	call   800fe8 <printfmt>
  800d8a:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800d8d:	e9 49 02 00 00       	jmp    800fdb <vprintfmt+0x3bc>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800d92:	56                   	push   %esi
  800d93:	68 ee 3d 80 00       	push   $0x803dee
  800d98:	ff 75 0c             	pushl  0xc(%ebp)
  800d9b:	ff 75 08             	pushl  0x8(%ebp)
  800d9e:	e8 45 02 00 00       	call   800fe8 <printfmt>
  800da3:	83 c4 10             	add    $0x10,%esp
			break;
  800da6:	e9 30 02 00 00       	jmp    800fdb <vprintfmt+0x3bc>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  800dab:	8b 45 14             	mov    0x14(%ebp),%eax
  800dae:	83 c0 04             	add    $0x4,%eax
  800db1:	89 45 14             	mov    %eax,0x14(%ebp)
  800db4:	8b 45 14             	mov    0x14(%ebp),%eax
  800db7:	83 e8 04             	sub    $0x4,%eax
  800dba:	8b 30                	mov    (%eax),%esi
  800dbc:	85 f6                	test   %esi,%esi
  800dbe:	75 05                	jne    800dc5 <vprintfmt+0x1a6>
				p = "(null)";
  800dc0:	be f1 3d 80 00       	mov    $0x803df1,%esi
			if (width > 0 && padc != '-')
  800dc5:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800dc9:	7e 6d                	jle    800e38 <vprintfmt+0x219>
  800dcb:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  800dcf:	74 67                	je     800e38 <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  800dd1:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800dd4:	83 ec 08             	sub    $0x8,%esp
  800dd7:	50                   	push   %eax
  800dd8:	56                   	push   %esi
  800dd9:	e8 12 05 00 00       	call   8012f0 <strnlen>
  800dde:	83 c4 10             	add    $0x10,%esp
  800de1:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  800de4:	eb 16                	jmp    800dfc <vprintfmt+0x1dd>
					putch(padc, putdat);
  800de6:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  800dea:	83 ec 08             	sub    $0x8,%esp
  800ded:	ff 75 0c             	pushl  0xc(%ebp)
  800df0:	50                   	push   %eax
  800df1:	8b 45 08             	mov    0x8(%ebp),%eax
  800df4:	ff d0                	call   *%eax
  800df6:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800df9:	ff 4d e4             	decl   -0x1c(%ebp)
  800dfc:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800e00:	7f e4                	jg     800de6 <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800e02:	eb 34                	jmp    800e38 <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  800e04:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800e08:	74 1c                	je     800e26 <vprintfmt+0x207>
  800e0a:	83 fb 1f             	cmp    $0x1f,%ebx
  800e0d:	7e 05                	jle    800e14 <vprintfmt+0x1f5>
  800e0f:	83 fb 7e             	cmp    $0x7e,%ebx
  800e12:	7e 12                	jle    800e26 <vprintfmt+0x207>
					putch('?', putdat);
  800e14:	83 ec 08             	sub    $0x8,%esp
  800e17:	ff 75 0c             	pushl  0xc(%ebp)
  800e1a:	6a 3f                	push   $0x3f
  800e1c:	8b 45 08             	mov    0x8(%ebp),%eax
  800e1f:	ff d0                	call   *%eax
  800e21:	83 c4 10             	add    $0x10,%esp
  800e24:	eb 0f                	jmp    800e35 <vprintfmt+0x216>
				else
					putch(ch, putdat);
  800e26:	83 ec 08             	sub    $0x8,%esp
  800e29:	ff 75 0c             	pushl  0xc(%ebp)
  800e2c:	53                   	push   %ebx
  800e2d:	8b 45 08             	mov    0x8(%ebp),%eax
  800e30:	ff d0                	call   *%eax
  800e32:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800e35:	ff 4d e4             	decl   -0x1c(%ebp)
  800e38:	89 f0                	mov    %esi,%eax
  800e3a:	8d 70 01             	lea    0x1(%eax),%esi
  800e3d:	8a 00                	mov    (%eax),%al
  800e3f:	0f be d8             	movsbl %al,%ebx
  800e42:	85 db                	test   %ebx,%ebx
  800e44:	74 24                	je     800e6a <vprintfmt+0x24b>
  800e46:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800e4a:	78 b8                	js     800e04 <vprintfmt+0x1e5>
  800e4c:	ff 4d e0             	decl   -0x20(%ebp)
  800e4f:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800e53:	79 af                	jns    800e04 <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800e55:	eb 13                	jmp    800e6a <vprintfmt+0x24b>
				putch(' ', putdat);
  800e57:	83 ec 08             	sub    $0x8,%esp
  800e5a:	ff 75 0c             	pushl  0xc(%ebp)
  800e5d:	6a 20                	push   $0x20
  800e5f:	8b 45 08             	mov    0x8(%ebp),%eax
  800e62:	ff d0                	call   *%eax
  800e64:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800e67:	ff 4d e4             	decl   -0x1c(%ebp)
  800e6a:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800e6e:	7f e7                	jg     800e57 <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  800e70:	e9 66 01 00 00       	jmp    800fdb <vprintfmt+0x3bc>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  800e75:	83 ec 08             	sub    $0x8,%esp
  800e78:	ff 75 e8             	pushl  -0x18(%ebp)
  800e7b:	8d 45 14             	lea    0x14(%ebp),%eax
  800e7e:	50                   	push   %eax
  800e7f:	e8 3c fd ff ff       	call   800bc0 <getint>
  800e84:	83 c4 10             	add    $0x10,%esp
  800e87:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800e8a:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  800e8d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800e90:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800e93:	85 d2                	test   %edx,%edx
  800e95:	79 23                	jns    800eba <vprintfmt+0x29b>
				putch('-', putdat);
  800e97:	83 ec 08             	sub    $0x8,%esp
  800e9a:	ff 75 0c             	pushl  0xc(%ebp)
  800e9d:	6a 2d                	push   $0x2d
  800e9f:	8b 45 08             	mov    0x8(%ebp),%eax
  800ea2:	ff d0                	call   *%eax
  800ea4:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  800ea7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800eaa:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800ead:	f7 d8                	neg    %eax
  800eaf:	83 d2 00             	adc    $0x0,%edx
  800eb2:	f7 da                	neg    %edx
  800eb4:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800eb7:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  800eba:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800ec1:	e9 bc 00 00 00       	jmp    800f82 <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  800ec6:	83 ec 08             	sub    $0x8,%esp
  800ec9:	ff 75 e8             	pushl  -0x18(%ebp)
  800ecc:	8d 45 14             	lea    0x14(%ebp),%eax
  800ecf:	50                   	push   %eax
  800ed0:	e8 84 fc ff ff       	call   800b59 <getuint>
  800ed5:	83 c4 10             	add    $0x10,%esp
  800ed8:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800edb:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  800ede:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800ee5:	e9 98 00 00 00       	jmp    800f82 <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  800eea:	83 ec 08             	sub    $0x8,%esp
  800eed:	ff 75 0c             	pushl  0xc(%ebp)
  800ef0:	6a 58                	push   $0x58
  800ef2:	8b 45 08             	mov    0x8(%ebp),%eax
  800ef5:	ff d0                	call   *%eax
  800ef7:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800efa:	83 ec 08             	sub    $0x8,%esp
  800efd:	ff 75 0c             	pushl  0xc(%ebp)
  800f00:	6a 58                	push   $0x58
  800f02:	8b 45 08             	mov    0x8(%ebp),%eax
  800f05:	ff d0                	call   *%eax
  800f07:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800f0a:	83 ec 08             	sub    $0x8,%esp
  800f0d:	ff 75 0c             	pushl  0xc(%ebp)
  800f10:	6a 58                	push   $0x58
  800f12:	8b 45 08             	mov    0x8(%ebp),%eax
  800f15:	ff d0                	call   *%eax
  800f17:	83 c4 10             	add    $0x10,%esp
			break;
  800f1a:	e9 bc 00 00 00       	jmp    800fdb <vprintfmt+0x3bc>

		// pointer
		case 'p':
			putch('0', putdat);
  800f1f:	83 ec 08             	sub    $0x8,%esp
  800f22:	ff 75 0c             	pushl  0xc(%ebp)
  800f25:	6a 30                	push   $0x30
  800f27:	8b 45 08             	mov    0x8(%ebp),%eax
  800f2a:	ff d0                	call   *%eax
  800f2c:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  800f2f:	83 ec 08             	sub    $0x8,%esp
  800f32:	ff 75 0c             	pushl  0xc(%ebp)
  800f35:	6a 78                	push   $0x78
  800f37:	8b 45 08             	mov    0x8(%ebp),%eax
  800f3a:	ff d0                	call   *%eax
  800f3c:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  800f3f:	8b 45 14             	mov    0x14(%ebp),%eax
  800f42:	83 c0 04             	add    $0x4,%eax
  800f45:	89 45 14             	mov    %eax,0x14(%ebp)
  800f48:	8b 45 14             	mov    0x14(%ebp),%eax
  800f4b:	83 e8 04             	sub    $0x4,%eax
  800f4e:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800f50:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800f53:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  800f5a:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  800f61:	eb 1f                	jmp    800f82 <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800f63:	83 ec 08             	sub    $0x8,%esp
  800f66:	ff 75 e8             	pushl  -0x18(%ebp)
  800f69:	8d 45 14             	lea    0x14(%ebp),%eax
  800f6c:	50                   	push   %eax
  800f6d:	e8 e7 fb ff ff       	call   800b59 <getuint>
  800f72:	83 c4 10             	add    $0x10,%esp
  800f75:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800f78:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  800f7b:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800f82:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  800f86:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800f89:	83 ec 04             	sub    $0x4,%esp
  800f8c:	52                   	push   %edx
  800f8d:	ff 75 e4             	pushl  -0x1c(%ebp)
  800f90:	50                   	push   %eax
  800f91:	ff 75 f4             	pushl  -0xc(%ebp)
  800f94:	ff 75 f0             	pushl  -0x10(%ebp)
  800f97:	ff 75 0c             	pushl  0xc(%ebp)
  800f9a:	ff 75 08             	pushl  0x8(%ebp)
  800f9d:	e8 00 fb ff ff       	call   800aa2 <printnum>
  800fa2:	83 c4 20             	add    $0x20,%esp
			break;
  800fa5:	eb 34                	jmp    800fdb <vprintfmt+0x3bc>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  800fa7:	83 ec 08             	sub    $0x8,%esp
  800faa:	ff 75 0c             	pushl  0xc(%ebp)
  800fad:	53                   	push   %ebx
  800fae:	8b 45 08             	mov    0x8(%ebp),%eax
  800fb1:	ff d0                	call   *%eax
  800fb3:	83 c4 10             	add    $0x10,%esp
			break;
  800fb6:	eb 23                	jmp    800fdb <vprintfmt+0x3bc>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800fb8:	83 ec 08             	sub    $0x8,%esp
  800fbb:	ff 75 0c             	pushl  0xc(%ebp)
  800fbe:	6a 25                	push   $0x25
  800fc0:	8b 45 08             	mov    0x8(%ebp),%eax
  800fc3:	ff d0                	call   *%eax
  800fc5:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  800fc8:	ff 4d 10             	decl   0x10(%ebp)
  800fcb:	eb 03                	jmp    800fd0 <vprintfmt+0x3b1>
  800fcd:	ff 4d 10             	decl   0x10(%ebp)
  800fd0:	8b 45 10             	mov    0x10(%ebp),%eax
  800fd3:	48                   	dec    %eax
  800fd4:	8a 00                	mov    (%eax),%al
  800fd6:	3c 25                	cmp    $0x25,%al
  800fd8:	75 f3                	jne    800fcd <vprintfmt+0x3ae>
				/* do nothing */;
			break;
  800fda:	90                   	nop
		}
	}
  800fdb:	e9 47 fc ff ff       	jmp    800c27 <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  800fe0:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  800fe1:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800fe4:	5b                   	pop    %ebx
  800fe5:	5e                   	pop    %esi
  800fe6:	5d                   	pop    %ebp
  800fe7:	c3                   	ret    

00800fe8 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800fe8:	55                   	push   %ebp
  800fe9:	89 e5                	mov    %esp,%ebp
  800feb:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  800fee:	8d 45 10             	lea    0x10(%ebp),%eax
  800ff1:	83 c0 04             	add    $0x4,%eax
  800ff4:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  800ff7:	8b 45 10             	mov    0x10(%ebp),%eax
  800ffa:	ff 75 f4             	pushl  -0xc(%ebp)
  800ffd:	50                   	push   %eax
  800ffe:	ff 75 0c             	pushl  0xc(%ebp)
  801001:	ff 75 08             	pushl  0x8(%ebp)
  801004:	e8 16 fc ff ff       	call   800c1f <vprintfmt>
  801009:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  80100c:	90                   	nop
  80100d:	c9                   	leave  
  80100e:	c3                   	ret    

0080100f <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  80100f:	55                   	push   %ebp
  801010:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  801012:	8b 45 0c             	mov    0xc(%ebp),%eax
  801015:	8b 40 08             	mov    0x8(%eax),%eax
  801018:	8d 50 01             	lea    0x1(%eax),%edx
  80101b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80101e:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  801021:	8b 45 0c             	mov    0xc(%ebp),%eax
  801024:	8b 10                	mov    (%eax),%edx
  801026:	8b 45 0c             	mov    0xc(%ebp),%eax
  801029:	8b 40 04             	mov    0x4(%eax),%eax
  80102c:	39 c2                	cmp    %eax,%edx
  80102e:	73 12                	jae    801042 <sprintputch+0x33>
		*b->buf++ = ch;
  801030:	8b 45 0c             	mov    0xc(%ebp),%eax
  801033:	8b 00                	mov    (%eax),%eax
  801035:	8d 48 01             	lea    0x1(%eax),%ecx
  801038:	8b 55 0c             	mov    0xc(%ebp),%edx
  80103b:	89 0a                	mov    %ecx,(%edx)
  80103d:	8b 55 08             	mov    0x8(%ebp),%edx
  801040:	88 10                	mov    %dl,(%eax)
}
  801042:	90                   	nop
  801043:	5d                   	pop    %ebp
  801044:	c3                   	ret    

00801045 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  801045:	55                   	push   %ebp
  801046:	89 e5                	mov    %esp,%ebp
  801048:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  80104b:	8b 45 08             	mov    0x8(%ebp),%eax
  80104e:	89 45 ec             	mov    %eax,-0x14(%ebp)
  801051:	8b 45 0c             	mov    0xc(%ebp),%eax
  801054:	8d 50 ff             	lea    -0x1(%eax),%edx
  801057:	8b 45 08             	mov    0x8(%ebp),%eax
  80105a:	01 d0                	add    %edx,%eax
  80105c:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80105f:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  801066:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80106a:	74 06                	je     801072 <vsnprintf+0x2d>
  80106c:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801070:	7f 07                	jg     801079 <vsnprintf+0x34>
		return -E_INVAL;
  801072:	b8 03 00 00 00       	mov    $0x3,%eax
  801077:	eb 20                	jmp    801099 <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  801079:	ff 75 14             	pushl  0x14(%ebp)
  80107c:	ff 75 10             	pushl  0x10(%ebp)
  80107f:	8d 45 ec             	lea    -0x14(%ebp),%eax
  801082:	50                   	push   %eax
  801083:	68 0f 10 80 00       	push   $0x80100f
  801088:	e8 92 fb ff ff       	call   800c1f <vprintfmt>
  80108d:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  801090:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801093:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  801096:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  801099:	c9                   	leave  
  80109a:	c3                   	ret    

0080109b <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  80109b:	55                   	push   %ebp
  80109c:	89 e5                	mov    %esp,%ebp
  80109e:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  8010a1:	8d 45 10             	lea    0x10(%ebp),%eax
  8010a4:	83 c0 04             	add    $0x4,%eax
  8010a7:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  8010aa:	8b 45 10             	mov    0x10(%ebp),%eax
  8010ad:	ff 75 f4             	pushl  -0xc(%ebp)
  8010b0:	50                   	push   %eax
  8010b1:	ff 75 0c             	pushl  0xc(%ebp)
  8010b4:	ff 75 08             	pushl  0x8(%ebp)
  8010b7:	e8 89 ff ff ff       	call   801045 <vsnprintf>
  8010bc:	83 c4 10             	add    $0x10,%esp
  8010bf:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  8010c2:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8010c5:	c9                   	leave  
  8010c6:	c3                   	ret    

008010c7 <readline>:
#include <inc/lib.h>

//static char buf[BUFLEN];

void readline(const char *prompt, char* buf)
{
  8010c7:	55                   	push   %ebp
  8010c8:	89 e5                	mov    %esp,%ebp
  8010ca:	83 ec 18             	sub    $0x18,%esp
		int i, c, echoing;

	if (prompt != NULL)
  8010cd:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8010d1:	74 13                	je     8010e6 <readline+0x1f>
		cprintf("%s", prompt);
  8010d3:	83 ec 08             	sub    $0x8,%esp
  8010d6:	ff 75 08             	pushl  0x8(%ebp)
  8010d9:	68 50 3f 80 00       	push   $0x803f50
  8010de:	e8 62 f9 ff ff       	call   800a45 <cprintf>
  8010e3:	83 c4 10             	add    $0x10,%esp

	i = 0;
  8010e6:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	echoing = iscons(0);
  8010ed:	83 ec 0c             	sub    $0xc,%esp
  8010f0:	6a 00                	push   $0x0
  8010f2:	e8 54 f5 ff ff       	call   80064b <iscons>
  8010f7:	83 c4 10             	add    $0x10,%esp
  8010fa:	89 45 f0             	mov    %eax,-0x10(%ebp)
	while (1) {
		c = getchar();
  8010fd:	e8 fb f4 ff ff       	call   8005fd <getchar>
  801102:	89 45 ec             	mov    %eax,-0x14(%ebp)
		if (c < 0) {
  801105:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  801109:	79 22                	jns    80112d <readline+0x66>
			if (c != -E_EOF)
  80110b:	83 7d ec 07          	cmpl   $0x7,-0x14(%ebp)
  80110f:	0f 84 ad 00 00 00    	je     8011c2 <readline+0xfb>
				cprintf("read error: %e\n", c);
  801115:	83 ec 08             	sub    $0x8,%esp
  801118:	ff 75 ec             	pushl  -0x14(%ebp)
  80111b:	68 53 3f 80 00       	push   $0x803f53
  801120:	e8 20 f9 ff ff       	call   800a45 <cprintf>
  801125:	83 c4 10             	add    $0x10,%esp
			return;
  801128:	e9 95 00 00 00       	jmp    8011c2 <readline+0xfb>
		} else if (c >= ' ' && i < BUFLEN-1) {
  80112d:	83 7d ec 1f          	cmpl   $0x1f,-0x14(%ebp)
  801131:	7e 34                	jle    801167 <readline+0xa0>
  801133:	81 7d f4 fe 03 00 00 	cmpl   $0x3fe,-0xc(%ebp)
  80113a:	7f 2b                	jg     801167 <readline+0xa0>
			if (echoing)
  80113c:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801140:	74 0e                	je     801150 <readline+0x89>
				cputchar(c);
  801142:	83 ec 0c             	sub    $0xc,%esp
  801145:	ff 75 ec             	pushl  -0x14(%ebp)
  801148:	e8 68 f4 ff ff       	call   8005b5 <cputchar>
  80114d:	83 c4 10             	add    $0x10,%esp
			buf[i++] = c;
  801150:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801153:	8d 50 01             	lea    0x1(%eax),%edx
  801156:	89 55 f4             	mov    %edx,-0xc(%ebp)
  801159:	89 c2                	mov    %eax,%edx
  80115b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80115e:	01 d0                	add    %edx,%eax
  801160:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801163:	88 10                	mov    %dl,(%eax)
  801165:	eb 56                	jmp    8011bd <readline+0xf6>
		} else if (c == '\b' && i > 0) {
  801167:	83 7d ec 08          	cmpl   $0x8,-0x14(%ebp)
  80116b:	75 1f                	jne    80118c <readline+0xc5>
  80116d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801171:	7e 19                	jle    80118c <readline+0xc5>
			if (echoing)
  801173:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801177:	74 0e                	je     801187 <readline+0xc0>
				cputchar(c);
  801179:	83 ec 0c             	sub    $0xc,%esp
  80117c:	ff 75 ec             	pushl  -0x14(%ebp)
  80117f:	e8 31 f4 ff ff       	call   8005b5 <cputchar>
  801184:	83 c4 10             	add    $0x10,%esp

			i--;
  801187:	ff 4d f4             	decl   -0xc(%ebp)
  80118a:	eb 31                	jmp    8011bd <readline+0xf6>
		} else if (c == '\n' || c == '\r') {
  80118c:	83 7d ec 0a          	cmpl   $0xa,-0x14(%ebp)
  801190:	74 0a                	je     80119c <readline+0xd5>
  801192:	83 7d ec 0d          	cmpl   $0xd,-0x14(%ebp)
  801196:	0f 85 61 ff ff ff    	jne    8010fd <readline+0x36>
			if (echoing)
  80119c:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8011a0:	74 0e                	je     8011b0 <readline+0xe9>
				cputchar(c);
  8011a2:	83 ec 0c             	sub    $0xc,%esp
  8011a5:	ff 75 ec             	pushl  -0x14(%ebp)
  8011a8:	e8 08 f4 ff ff       	call   8005b5 <cputchar>
  8011ad:	83 c4 10             	add    $0x10,%esp

			buf[i] = 0;
  8011b0:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8011b3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011b6:	01 d0                	add    %edx,%eax
  8011b8:	c6 00 00             	movb   $0x0,(%eax)
			return;
  8011bb:	eb 06                	jmp    8011c3 <readline+0xfc>
		}
	}
  8011bd:	e9 3b ff ff ff       	jmp    8010fd <readline+0x36>
	while (1) {
		c = getchar();
		if (c < 0) {
			if (c != -E_EOF)
				cprintf("read error: %e\n", c);
			return;
  8011c2:	90                   	nop
			buf[i] = 0;
			return;
		}
	}

}
  8011c3:	c9                   	leave  
  8011c4:	c3                   	ret    

008011c5 <atomic_readline>:

void atomic_readline(const char *prompt, char* buf)
{
  8011c5:	55                   	push   %ebp
  8011c6:	89 e5                	mov    %esp,%ebp
  8011c8:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  8011cb:	e8 06 0f 00 00       	call   8020d6 <sys_disable_interrupt>
	int i, c, echoing;

	if (prompt != NULL)
  8011d0:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8011d4:	74 13                	je     8011e9 <atomic_readline+0x24>
		cprintf("%s", prompt);
  8011d6:	83 ec 08             	sub    $0x8,%esp
  8011d9:	ff 75 08             	pushl  0x8(%ebp)
  8011dc:	68 50 3f 80 00       	push   $0x803f50
  8011e1:	e8 5f f8 ff ff       	call   800a45 <cprintf>
  8011e6:	83 c4 10             	add    $0x10,%esp

	i = 0;
  8011e9:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	echoing = iscons(0);
  8011f0:	83 ec 0c             	sub    $0xc,%esp
  8011f3:	6a 00                	push   $0x0
  8011f5:	e8 51 f4 ff ff       	call   80064b <iscons>
  8011fa:	83 c4 10             	add    $0x10,%esp
  8011fd:	89 45 f0             	mov    %eax,-0x10(%ebp)
	while (1) {
		c = getchar();
  801200:	e8 f8 f3 ff ff       	call   8005fd <getchar>
  801205:	89 45 ec             	mov    %eax,-0x14(%ebp)
		if (c < 0) {
  801208:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  80120c:	79 23                	jns    801231 <atomic_readline+0x6c>
			if (c != -E_EOF)
  80120e:	83 7d ec 07          	cmpl   $0x7,-0x14(%ebp)
  801212:	74 13                	je     801227 <atomic_readline+0x62>
				cprintf("read error: %e\n", c);
  801214:	83 ec 08             	sub    $0x8,%esp
  801217:	ff 75 ec             	pushl  -0x14(%ebp)
  80121a:	68 53 3f 80 00       	push   $0x803f53
  80121f:	e8 21 f8 ff ff       	call   800a45 <cprintf>
  801224:	83 c4 10             	add    $0x10,%esp
			sys_enable_interrupt();
  801227:	e8 c4 0e 00 00       	call   8020f0 <sys_enable_interrupt>
			return;
  80122c:	e9 9a 00 00 00       	jmp    8012cb <atomic_readline+0x106>
		} else if (c >= ' ' && i < BUFLEN-1) {
  801231:	83 7d ec 1f          	cmpl   $0x1f,-0x14(%ebp)
  801235:	7e 34                	jle    80126b <atomic_readline+0xa6>
  801237:	81 7d f4 fe 03 00 00 	cmpl   $0x3fe,-0xc(%ebp)
  80123e:	7f 2b                	jg     80126b <atomic_readline+0xa6>
			if (echoing)
  801240:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801244:	74 0e                	je     801254 <atomic_readline+0x8f>
				cputchar(c);
  801246:	83 ec 0c             	sub    $0xc,%esp
  801249:	ff 75 ec             	pushl  -0x14(%ebp)
  80124c:	e8 64 f3 ff ff       	call   8005b5 <cputchar>
  801251:	83 c4 10             	add    $0x10,%esp
			buf[i++] = c;
  801254:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801257:	8d 50 01             	lea    0x1(%eax),%edx
  80125a:	89 55 f4             	mov    %edx,-0xc(%ebp)
  80125d:	89 c2                	mov    %eax,%edx
  80125f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801262:	01 d0                	add    %edx,%eax
  801264:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801267:	88 10                	mov    %dl,(%eax)
  801269:	eb 5b                	jmp    8012c6 <atomic_readline+0x101>
		} else if (c == '\b' && i > 0) {
  80126b:	83 7d ec 08          	cmpl   $0x8,-0x14(%ebp)
  80126f:	75 1f                	jne    801290 <atomic_readline+0xcb>
  801271:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801275:	7e 19                	jle    801290 <atomic_readline+0xcb>
			if (echoing)
  801277:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80127b:	74 0e                	je     80128b <atomic_readline+0xc6>
				cputchar(c);
  80127d:	83 ec 0c             	sub    $0xc,%esp
  801280:	ff 75 ec             	pushl  -0x14(%ebp)
  801283:	e8 2d f3 ff ff       	call   8005b5 <cputchar>
  801288:	83 c4 10             	add    $0x10,%esp
			i--;
  80128b:	ff 4d f4             	decl   -0xc(%ebp)
  80128e:	eb 36                	jmp    8012c6 <atomic_readline+0x101>
		} else if (c == '\n' || c == '\r') {
  801290:	83 7d ec 0a          	cmpl   $0xa,-0x14(%ebp)
  801294:	74 0a                	je     8012a0 <atomic_readline+0xdb>
  801296:	83 7d ec 0d          	cmpl   $0xd,-0x14(%ebp)
  80129a:	0f 85 60 ff ff ff    	jne    801200 <atomic_readline+0x3b>
			if (echoing)
  8012a0:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8012a4:	74 0e                	je     8012b4 <atomic_readline+0xef>
				cputchar(c);
  8012a6:	83 ec 0c             	sub    $0xc,%esp
  8012a9:	ff 75 ec             	pushl  -0x14(%ebp)
  8012ac:	e8 04 f3 ff ff       	call   8005b5 <cputchar>
  8012b1:	83 c4 10             	add    $0x10,%esp
			buf[i] = 0;
  8012b4:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8012b7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012ba:	01 d0                	add    %edx,%eax
  8012bc:	c6 00 00             	movb   $0x0,(%eax)
			sys_enable_interrupt();
  8012bf:	e8 2c 0e 00 00       	call   8020f0 <sys_enable_interrupt>
			return;
  8012c4:	eb 05                	jmp    8012cb <atomic_readline+0x106>
		}
	}
  8012c6:	e9 35 ff ff ff       	jmp    801200 <atomic_readline+0x3b>
}
  8012cb:	c9                   	leave  
  8012cc:	c3                   	ret    

008012cd <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  8012cd:	55                   	push   %ebp
  8012ce:	89 e5                	mov    %esp,%ebp
  8012d0:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  8012d3:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8012da:	eb 06                	jmp    8012e2 <strlen+0x15>
		n++;
  8012dc:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  8012df:	ff 45 08             	incl   0x8(%ebp)
  8012e2:	8b 45 08             	mov    0x8(%ebp),%eax
  8012e5:	8a 00                	mov    (%eax),%al
  8012e7:	84 c0                	test   %al,%al
  8012e9:	75 f1                	jne    8012dc <strlen+0xf>
		n++;
	return n;
  8012eb:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  8012ee:	c9                   	leave  
  8012ef:	c3                   	ret    

008012f0 <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  8012f0:	55                   	push   %ebp
  8012f1:	89 e5                	mov    %esp,%ebp
  8012f3:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8012f6:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8012fd:	eb 09                	jmp    801308 <strnlen+0x18>
		n++;
  8012ff:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  801302:	ff 45 08             	incl   0x8(%ebp)
  801305:	ff 4d 0c             	decl   0xc(%ebp)
  801308:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80130c:	74 09                	je     801317 <strnlen+0x27>
  80130e:	8b 45 08             	mov    0x8(%ebp),%eax
  801311:	8a 00                	mov    (%eax),%al
  801313:	84 c0                	test   %al,%al
  801315:	75 e8                	jne    8012ff <strnlen+0xf>
		n++;
	return n;
  801317:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  80131a:	c9                   	leave  
  80131b:	c3                   	ret    

0080131c <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  80131c:	55                   	push   %ebp
  80131d:	89 e5                	mov    %esp,%ebp
  80131f:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  801322:	8b 45 08             	mov    0x8(%ebp),%eax
  801325:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  801328:	90                   	nop
  801329:	8b 45 08             	mov    0x8(%ebp),%eax
  80132c:	8d 50 01             	lea    0x1(%eax),%edx
  80132f:	89 55 08             	mov    %edx,0x8(%ebp)
  801332:	8b 55 0c             	mov    0xc(%ebp),%edx
  801335:	8d 4a 01             	lea    0x1(%edx),%ecx
  801338:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  80133b:	8a 12                	mov    (%edx),%dl
  80133d:	88 10                	mov    %dl,(%eax)
  80133f:	8a 00                	mov    (%eax),%al
  801341:	84 c0                	test   %al,%al
  801343:	75 e4                	jne    801329 <strcpy+0xd>
		/* do nothing */;
	return ret;
  801345:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  801348:	c9                   	leave  
  801349:	c3                   	ret    

0080134a <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  80134a:	55                   	push   %ebp
  80134b:	89 e5                	mov    %esp,%ebp
  80134d:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  801350:	8b 45 08             	mov    0x8(%ebp),%eax
  801353:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  801356:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  80135d:	eb 1f                	jmp    80137e <strncpy+0x34>
		*dst++ = *src;
  80135f:	8b 45 08             	mov    0x8(%ebp),%eax
  801362:	8d 50 01             	lea    0x1(%eax),%edx
  801365:	89 55 08             	mov    %edx,0x8(%ebp)
  801368:	8b 55 0c             	mov    0xc(%ebp),%edx
  80136b:	8a 12                	mov    (%edx),%dl
  80136d:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  80136f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801372:	8a 00                	mov    (%eax),%al
  801374:	84 c0                	test   %al,%al
  801376:	74 03                	je     80137b <strncpy+0x31>
			src++;
  801378:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  80137b:	ff 45 fc             	incl   -0x4(%ebp)
  80137e:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801381:	3b 45 10             	cmp    0x10(%ebp),%eax
  801384:	72 d9                	jb     80135f <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  801386:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  801389:	c9                   	leave  
  80138a:	c3                   	ret    

0080138b <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  80138b:	55                   	push   %ebp
  80138c:	89 e5                	mov    %esp,%ebp
  80138e:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  801391:	8b 45 08             	mov    0x8(%ebp),%eax
  801394:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  801397:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80139b:	74 30                	je     8013cd <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  80139d:	eb 16                	jmp    8013b5 <strlcpy+0x2a>
			*dst++ = *src++;
  80139f:	8b 45 08             	mov    0x8(%ebp),%eax
  8013a2:	8d 50 01             	lea    0x1(%eax),%edx
  8013a5:	89 55 08             	mov    %edx,0x8(%ebp)
  8013a8:	8b 55 0c             	mov    0xc(%ebp),%edx
  8013ab:	8d 4a 01             	lea    0x1(%edx),%ecx
  8013ae:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  8013b1:	8a 12                	mov    (%edx),%dl
  8013b3:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  8013b5:	ff 4d 10             	decl   0x10(%ebp)
  8013b8:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8013bc:	74 09                	je     8013c7 <strlcpy+0x3c>
  8013be:	8b 45 0c             	mov    0xc(%ebp),%eax
  8013c1:	8a 00                	mov    (%eax),%al
  8013c3:	84 c0                	test   %al,%al
  8013c5:	75 d8                	jne    80139f <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  8013c7:	8b 45 08             	mov    0x8(%ebp),%eax
  8013ca:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  8013cd:	8b 55 08             	mov    0x8(%ebp),%edx
  8013d0:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8013d3:	29 c2                	sub    %eax,%edx
  8013d5:	89 d0                	mov    %edx,%eax
}
  8013d7:	c9                   	leave  
  8013d8:	c3                   	ret    

008013d9 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  8013d9:	55                   	push   %ebp
  8013da:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  8013dc:	eb 06                	jmp    8013e4 <strcmp+0xb>
		p++, q++;
  8013de:	ff 45 08             	incl   0x8(%ebp)
  8013e1:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  8013e4:	8b 45 08             	mov    0x8(%ebp),%eax
  8013e7:	8a 00                	mov    (%eax),%al
  8013e9:	84 c0                	test   %al,%al
  8013eb:	74 0e                	je     8013fb <strcmp+0x22>
  8013ed:	8b 45 08             	mov    0x8(%ebp),%eax
  8013f0:	8a 10                	mov    (%eax),%dl
  8013f2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8013f5:	8a 00                	mov    (%eax),%al
  8013f7:	38 c2                	cmp    %al,%dl
  8013f9:	74 e3                	je     8013de <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  8013fb:	8b 45 08             	mov    0x8(%ebp),%eax
  8013fe:	8a 00                	mov    (%eax),%al
  801400:	0f b6 d0             	movzbl %al,%edx
  801403:	8b 45 0c             	mov    0xc(%ebp),%eax
  801406:	8a 00                	mov    (%eax),%al
  801408:	0f b6 c0             	movzbl %al,%eax
  80140b:	29 c2                	sub    %eax,%edx
  80140d:	89 d0                	mov    %edx,%eax
}
  80140f:	5d                   	pop    %ebp
  801410:	c3                   	ret    

00801411 <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  801411:	55                   	push   %ebp
  801412:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  801414:	eb 09                	jmp    80141f <strncmp+0xe>
		n--, p++, q++;
  801416:	ff 4d 10             	decl   0x10(%ebp)
  801419:	ff 45 08             	incl   0x8(%ebp)
  80141c:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  80141f:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801423:	74 17                	je     80143c <strncmp+0x2b>
  801425:	8b 45 08             	mov    0x8(%ebp),%eax
  801428:	8a 00                	mov    (%eax),%al
  80142a:	84 c0                	test   %al,%al
  80142c:	74 0e                	je     80143c <strncmp+0x2b>
  80142e:	8b 45 08             	mov    0x8(%ebp),%eax
  801431:	8a 10                	mov    (%eax),%dl
  801433:	8b 45 0c             	mov    0xc(%ebp),%eax
  801436:	8a 00                	mov    (%eax),%al
  801438:	38 c2                	cmp    %al,%dl
  80143a:	74 da                	je     801416 <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  80143c:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801440:	75 07                	jne    801449 <strncmp+0x38>
		return 0;
  801442:	b8 00 00 00 00       	mov    $0x0,%eax
  801447:	eb 14                	jmp    80145d <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  801449:	8b 45 08             	mov    0x8(%ebp),%eax
  80144c:	8a 00                	mov    (%eax),%al
  80144e:	0f b6 d0             	movzbl %al,%edx
  801451:	8b 45 0c             	mov    0xc(%ebp),%eax
  801454:	8a 00                	mov    (%eax),%al
  801456:	0f b6 c0             	movzbl %al,%eax
  801459:	29 c2                	sub    %eax,%edx
  80145b:	89 d0                	mov    %edx,%eax
}
  80145d:	5d                   	pop    %ebp
  80145e:	c3                   	ret    

0080145f <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  80145f:	55                   	push   %ebp
  801460:	89 e5                	mov    %esp,%ebp
  801462:	83 ec 04             	sub    $0x4,%esp
  801465:	8b 45 0c             	mov    0xc(%ebp),%eax
  801468:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  80146b:	eb 12                	jmp    80147f <strchr+0x20>
		if (*s == c)
  80146d:	8b 45 08             	mov    0x8(%ebp),%eax
  801470:	8a 00                	mov    (%eax),%al
  801472:	3a 45 fc             	cmp    -0x4(%ebp),%al
  801475:	75 05                	jne    80147c <strchr+0x1d>
			return (char *) s;
  801477:	8b 45 08             	mov    0x8(%ebp),%eax
  80147a:	eb 11                	jmp    80148d <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  80147c:	ff 45 08             	incl   0x8(%ebp)
  80147f:	8b 45 08             	mov    0x8(%ebp),%eax
  801482:	8a 00                	mov    (%eax),%al
  801484:	84 c0                	test   %al,%al
  801486:	75 e5                	jne    80146d <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  801488:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80148d:	c9                   	leave  
  80148e:	c3                   	ret    

0080148f <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  80148f:	55                   	push   %ebp
  801490:	89 e5                	mov    %esp,%ebp
  801492:	83 ec 04             	sub    $0x4,%esp
  801495:	8b 45 0c             	mov    0xc(%ebp),%eax
  801498:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  80149b:	eb 0d                	jmp    8014aa <strfind+0x1b>
		if (*s == c)
  80149d:	8b 45 08             	mov    0x8(%ebp),%eax
  8014a0:	8a 00                	mov    (%eax),%al
  8014a2:	3a 45 fc             	cmp    -0x4(%ebp),%al
  8014a5:	74 0e                	je     8014b5 <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  8014a7:	ff 45 08             	incl   0x8(%ebp)
  8014aa:	8b 45 08             	mov    0x8(%ebp),%eax
  8014ad:	8a 00                	mov    (%eax),%al
  8014af:	84 c0                	test   %al,%al
  8014b1:	75 ea                	jne    80149d <strfind+0xe>
  8014b3:	eb 01                	jmp    8014b6 <strfind+0x27>
		if (*s == c)
			break;
  8014b5:	90                   	nop
	return (char *) s;
  8014b6:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8014b9:	c9                   	leave  
  8014ba:	c3                   	ret    

008014bb <memset>:


void *
memset(void *v, int c, uint32 n)
{
  8014bb:	55                   	push   %ebp
  8014bc:	89 e5                	mov    %esp,%ebp
  8014be:	83 ec 10             	sub    $0x10,%esp
	char *p;
	int m;

	p = v;
  8014c1:	8b 45 08             	mov    0x8(%ebp),%eax
  8014c4:	89 45 fc             	mov    %eax,-0x4(%ebp)
	m = n;
  8014c7:	8b 45 10             	mov    0x10(%ebp),%eax
  8014ca:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (--m >= 0)
  8014cd:	eb 0e                	jmp    8014dd <memset+0x22>
		*p++ = c;
  8014cf:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8014d2:	8d 50 01             	lea    0x1(%eax),%edx
  8014d5:	89 55 fc             	mov    %edx,-0x4(%ebp)
  8014d8:	8b 55 0c             	mov    0xc(%ebp),%edx
  8014db:	88 10                	mov    %dl,(%eax)
	char *p;
	int m;

	p = v;
	m = n;
	while (--m >= 0)
  8014dd:	ff 4d f8             	decl   -0x8(%ebp)
  8014e0:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  8014e4:	79 e9                	jns    8014cf <memset+0x14>
		*p++ = c;

	return v;
  8014e6:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8014e9:	c9                   	leave  
  8014ea:	c3                   	ret    

008014eb <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  8014eb:	55                   	push   %ebp
  8014ec:	89 e5                	mov    %esp,%ebp
  8014ee:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  8014f1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8014f4:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  8014f7:	8b 45 08             	mov    0x8(%ebp),%eax
  8014fa:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (n-- > 0)
  8014fd:	eb 16                	jmp    801515 <memcpy+0x2a>
		*d++ = *s++;
  8014ff:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801502:	8d 50 01             	lea    0x1(%eax),%edx
  801505:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801508:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80150b:	8d 4a 01             	lea    0x1(%edx),%ecx
  80150e:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  801511:	8a 12                	mov    (%edx),%dl
  801513:	88 10                	mov    %dl,(%eax)
	const char *s;
	char *d;

	s = src;
	d = dst;
	while (n-- > 0)
  801515:	8b 45 10             	mov    0x10(%ebp),%eax
  801518:	8d 50 ff             	lea    -0x1(%eax),%edx
  80151b:	89 55 10             	mov    %edx,0x10(%ebp)
  80151e:	85 c0                	test   %eax,%eax
  801520:	75 dd                	jne    8014ff <memcpy+0x14>
		*d++ = *s++;

	return dst;
  801522:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801525:	c9                   	leave  
  801526:	c3                   	ret    

00801527 <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  801527:	55                   	push   %ebp
  801528:	89 e5                	mov    %esp,%ebp
  80152a:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  80152d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801530:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  801533:	8b 45 08             	mov    0x8(%ebp),%eax
  801536:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  801539:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80153c:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  80153f:	73 50                	jae    801591 <memmove+0x6a>
  801541:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801544:	8b 45 10             	mov    0x10(%ebp),%eax
  801547:	01 d0                	add    %edx,%eax
  801549:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  80154c:	76 43                	jbe    801591 <memmove+0x6a>
		s += n;
  80154e:	8b 45 10             	mov    0x10(%ebp),%eax
  801551:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  801554:	8b 45 10             	mov    0x10(%ebp),%eax
  801557:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  80155a:	eb 10                	jmp    80156c <memmove+0x45>
			*--d = *--s;
  80155c:	ff 4d f8             	decl   -0x8(%ebp)
  80155f:	ff 4d fc             	decl   -0x4(%ebp)
  801562:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801565:	8a 10                	mov    (%eax),%dl
  801567:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80156a:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  80156c:	8b 45 10             	mov    0x10(%ebp),%eax
  80156f:	8d 50 ff             	lea    -0x1(%eax),%edx
  801572:	89 55 10             	mov    %edx,0x10(%ebp)
  801575:	85 c0                	test   %eax,%eax
  801577:	75 e3                	jne    80155c <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  801579:	eb 23                	jmp    80159e <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  80157b:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80157e:	8d 50 01             	lea    0x1(%eax),%edx
  801581:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801584:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801587:	8d 4a 01             	lea    0x1(%edx),%ecx
  80158a:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  80158d:	8a 12                	mov    (%edx),%dl
  80158f:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  801591:	8b 45 10             	mov    0x10(%ebp),%eax
  801594:	8d 50 ff             	lea    -0x1(%eax),%edx
  801597:	89 55 10             	mov    %edx,0x10(%ebp)
  80159a:	85 c0                	test   %eax,%eax
  80159c:	75 dd                	jne    80157b <memmove+0x54>
			*d++ = *s++;

	return dst;
  80159e:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8015a1:	c9                   	leave  
  8015a2:	c3                   	ret    

008015a3 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  8015a3:	55                   	push   %ebp
  8015a4:	89 e5                	mov    %esp,%ebp
  8015a6:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  8015a9:	8b 45 08             	mov    0x8(%ebp),%eax
  8015ac:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  8015af:	8b 45 0c             	mov    0xc(%ebp),%eax
  8015b2:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  8015b5:	eb 2a                	jmp    8015e1 <memcmp+0x3e>
		if (*s1 != *s2)
  8015b7:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8015ba:	8a 10                	mov    (%eax),%dl
  8015bc:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8015bf:	8a 00                	mov    (%eax),%al
  8015c1:	38 c2                	cmp    %al,%dl
  8015c3:	74 16                	je     8015db <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  8015c5:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8015c8:	8a 00                	mov    (%eax),%al
  8015ca:	0f b6 d0             	movzbl %al,%edx
  8015cd:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8015d0:	8a 00                	mov    (%eax),%al
  8015d2:	0f b6 c0             	movzbl %al,%eax
  8015d5:	29 c2                	sub    %eax,%edx
  8015d7:	89 d0                	mov    %edx,%eax
  8015d9:	eb 18                	jmp    8015f3 <memcmp+0x50>
		s1++, s2++;
  8015db:	ff 45 fc             	incl   -0x4(%ebp)
  8015de:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  8015e1:	8b 45 10             	mov    0x10(%ebp),%eax
  8015e4:	8d 50 ff             	lea    -0x1(%eax),%edx
  8015e7:	89 55 10             	mov    %edx,0x10(%ebp)
  8015ea:	85 c0                	test   %eax,%eax
  8015ec:	75 c9                	jne    8015b7 <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  8015ee:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8015f3:	c9                   	leave  
  8015f4:	c3                   	ret    

008015f5 <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  8015f5:	55                   	push   %ebp
  8015f6:	89 e5                	mov    %esp,%ebp
  8015f8:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  8015fb:	8b 55 08             	mov    0x8(%ebp),%edx
  8015fe:	8b 45 10             	mov    0x10(%ebp),%eax
  801601:	01 d0                	add    %edx,%eax
  801603:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  801606:	eb 15                	jmp    80161d <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  801608:	8b 45 08             	mov    0x8(%ebp),%eax
  80160b:	8a 00                	mov    (%eax),%al
  80160d:	0f b6 d0             	movzbl %al,%edx
  801610:	8b 45 0c             	mov    0xc(%ebp),%eax
  801613:	0f b6 c0             	movzbl %al,%eax
  801616:	39 c2                	cmp    %eax,%edx
  801618:	74 0d                	je     801627 <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  80161a:	ff 45 08             	incl   0x8(%ebp)
  80161d:	8b 45 08             	mov    0x8(%ebp),%eax
  801620:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  801623:	72 e3                	jb     801608 <memfind+0x13>
  801625:	eb 01                	jmp    801628 <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  801627:	90                   	nop
	return (void *) s;
  801628:	8b 45 08             	mov    0x8(%ebp),%eax
}
  80162b:	c9                   	leave  
  80162c:	c3                   	ret    

0080162d <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  80162d:	55                   	push   %ebp
  80162e:	89 e5                	mov    %esp,%ebp
  801630:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  801633:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  80163a:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801641:	eb 03                	jmp    801646 <strtol+0x19>
		s++;
  801643:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801646:	8b 45 08             	mov    0x8(%ebp),%eax
  801649:	8a 00                	mov    (%eax),%al
  80164b:	3c 20                	cmp    $0x20,%al
  80164d:	74 f4                	je     801643 <strtol+0x16>
  80164f:	8b 45 08             	mov    0x8(%ebp),%eax
  801652:	8a 00                	mov    (%eax),%al
  801654:	3c 09                	cmp    $0x9,%al
  801656:	74 eb                	je     801643 <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  801658:	8b 45 08             	mov    0x8(%ebp),%eax
  80165b:	8a 00                	mov    (%eax),%al
  80165d:	3c 2b                	cmp    $0x2b,%al
  80165f:	75 05                	jne    801666 <strtol+0x39>
		s++;
  801661:	ff 45 08             	incl   0x8(%ebp)
  801664:	eb 13                	jmp    801679 <strtol+0x4c>
	else if (*s == '-')
  801666:	8b 45 08             	mov    0x8(%ebp),%eax
  801669:	8a 00                	mov    (%eax),%al
  80166b:	3c 2d                	cmp    $0x2d,%al
  80166d:	75 0a                	jne    801679 <strtol+0x4c>
		s++, neg = 1;
  80166f:	ff 45 08             	incl   0x8(%ebp)
  801672:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  801679:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80167d:	74 06                	je     801685 <strtol+0x58>
  80167f:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  801683:	75 20                	jne    8016a5 <strtol+0x78>
  801685:	8b 45 08             	mov    0x8(%ebp),%eax
  801688:	8a 00                	mov    (%eax),%al
  80168a:	3c 30                	cmp    $0x30,%al
  80168c:	75 17                	jne    8016a5 <strtol+0x78>
  80168e:	8b 45 08             	mov    0x8(%ebp),%eax
  801691:	40                   	inc    %eax
  801692:	8a 00                	mov    (%eax),%al
  801694:	3c 78                	cmp    $0x78,%al
  801696:	75 0d                	jne    8016a5 <strtol+0x78>
		s += 2, base = 16;
  801698:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  80169c:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  8016a3:	eb 28                	jmp    8016cd <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  8016a5:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8016a9:	75 15                	jne    8016c0 <strtol+0x93>
  8016ab:	8b 45 08             	mov    0x8(%ebp),%eax
  8016ae:	8a 00                	mov    (%eax),%al
  8016b0:	3c 30                	cmp    $0x30,%al
  8016b2:	75 0c                	jne    8016c0 <strtol+0x93>
		s++, base = 8;
  8016b4:	ff 45 08             	incl   0x8(%ebp)
  8016b7:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  8016be:	eb 0d                	jmp    8016cd <strtol+0xa0>
	else if (base == 0)
  8016c0:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8016c4:	75 07                	jne    8016cd <strtol+0xa0>
		base = 10;
  8016c6:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  8016cd:	8b 45 08             	mov    0x8(%ebp),%eax
  8016d0:	8a 00                	mov    (%eax),%al
  8016d2:	3c 2f                	cmp    $0x2f,%al
  8016d4:	7e 19                	jle    8016ef <strtol+0xc2>
  8016d6:	8b 45 08             	mov    0x8(%ebp),%eax
  8016d9:	8a 00                	mov    (%eax),%al
  8016db:	3c 39                	cmp    $0x39,%al
  8016dd:	7f 10                	jg     8016ef <strtol+0xc2>
			dig = *s - '0';
  8016df:	8b 45 08             	mov    0x8(%ebp),%eax
  8016e2:	8a 00                	mov    (%eax),%al
  8016e4:	0f be c0             	movsbl %al,%eax
  8016e7:	83 e8 30             	sub    $0x30,%eax
  8016ea:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8016ed:	eb 42                	jmp    801731 <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  8016ef:	8b 45 08             	mov    0x8(%ebp),%eax
  8016f2:	8a 00                	mov    (%eax),%al
  8016f4:	3c 60                	cmp    $0x60,%al
  8016f6:	7e 19                	jle    801711 <strtol+0xe4>
  8016f8:	8b 45 08             	mov    0x8(%ebp),%eax
  8016fb:	8a 00                	mov    (%eax),%al
  8016fd:	3c 7a                	cmp    $0x7a,%al
  8016ff:	7f 10                	jg     801711 <strtol+0xe4>
			dig = *s - 'a' + 10;
  801701:	8b 45 08             	mov    0x8(%ebp),%eax
  801704:	8a 00                	mov    (%eax),%al
  801706:	0f be c0             	movsbl %al,%eax
  801709:	83 e8 57             	sub    $0x57,%eax
  80170c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80170f:	eb 20                	jmp    801731 <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  801711:	8b 45 08             	mov    0x8(%ebp),%eax
  801714:	8a 00                	mov    (%eax),%al
  801716:	3c 40                	cmp    $0x40,%al
  801718:	7e 39                	jle    801753 <strtol+0x126>
  80171a:	8b 45 08             	mov    0x8(%ebp),%eax
  80171d:	8a 00                	mov    (%eax),%al
  80171f:	3c 5a                	cmp    $0x5a,%al
  801721:	7f 30                	jg     801753 <strtol+0x126>
			dig = *s - 'A' + 10;
  801723:	8b 45 08             	mov    0x8(%ebp),%eax
  801726:	8a 00                	mov    (%eax),%al
  801728:	0f be c0             	movsbl %al,%eax
  80172b:	83 e8 37             	sub    $0x37,%eax
  80172e:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  801731:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801734:	3b 45 10             	cmp    0x10(%ebp),%eax
  801737:	7d 19                	jge    801752 <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  801739:	ff 45 08             	incl   0x8(%ebp)
  80173c:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80173f:	0f af 45 10          	imul   0x10(%ebp),%eax
  801743:	89 c2                	mov    %eax,%edx
  801745:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801748:	01 d0                	add    %edx,%eax
  80174a:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  80174d:	e9 7b ff ff ff       	jmp    8016cd <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  801752:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  801753:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801757:	74 08                	je     801761 <strtol+0x134>
		*endptr = (char *) s;
  801759:	8b 45 0c             	mov    0xc(%ebp),%eax
  80175c:	8b 55 08             	mov    0x8(%ebp),%edx
  80175f:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  801761:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801765:	74 07                	je     80176e <strtol+0x141>
  801767:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80176a:	f7 d8                	neg    %eax
  80176c:	eb 03                	jmp    801771 <strtol+0x144>
  80176e:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  801771:	c9                   	leave  
  801772:	c3                   	ret    

00801773 <ltostr>:

void
ltostr(long value, char *str)
{
  801773:	55                   	push   %ebp
  801774:	89 e5                	mov    %esp,%ebp
  801776:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  801779:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  801780:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  801787:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80178b:	79 13                	jns    8017a0 <ltostr+0x2d>
	{
		neg = 1;
  80178d:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  801794:	8b 45 0c             	mov    0xc(%ebp),%eax
  801797:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  80179a:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  80179d:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  8017a0:	8b 45 08             	mov    0x8(%ebp),%eax
  8017a3:	b9 0a 00 00 00       	mov    $0xa,%ecx
  8017a8:	99                   	cltd   
  8017a9:	f7 f9                	idiv   %ecx
  8017ab:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  8017ae:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8017b1:	8d 50 01             	lea    0x1(%eax),%edx
  8017b4:	89 55 f8             	mov    %edx,-0x8(%ebp)
  8017b7:	89 c2                	mov    %eax,%edx
  8017b9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8017bc:	01 d0                	add    %edx,%eax
  8017be:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8017c1:	83 c2 30             	add    $0x30,%edx
  8017c4:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  8017c6:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8017c9:	b8 67 66 66 66       	mov    $0x66666667,%eax
  8017ce:	f7 e9                	imul   %ecx
  8017d0:	c1 fa 02             	sar    $0x2,%edx
  8017d3:	89 c8                	mov    %ecx,%eax
  8017d5:	c1 f8 1f             	sar    $0x1f,%eax
  8017d8:	29 c2                	sub    %eax,%edx
  8017da:	89 d0                	mov    %edx,%eax
  8017dc:	89 45 08             	mov    %eax,0x8(%ebp)
	} while (value % 10 != 0);
  8017df:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8017e2:	b8 67 66 66 66       	mov    $0x66666667,%eax
  8017e7:	f7 e9                	imul   %ecx
  8017e9:	c1 fa 02             	sar    $0x2,%edx
  8017ec:	89 c8                	mov    %ecx,%eax
  8017ee:	c1 f8 1f             	sar    $0x1f,%eax
  8017f1:	29 c2                	sub    %eax,%edx
  8017f3:	89 d0                	mov    %edx,%eax
  8017f5:	c1 e0 02             	shl    $0x2,%eax
  8017f8:	01 d0                	add    %edx,%eax
  8017fa:	01 c0                	add    %eax,%eax
  8017fc:	29 c1                	sub    %eax,%ecx
  8017fe:	89 ca                	mov    %ecx,%edx
  801800:	85 d2                	test   %edx,%edx
  801802:	75 9c                	jne    8017a0 <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  801804:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  80180b:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80180e:	48                   	dec    %eax
  80180f:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  801812:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801816:	74 3d                	je     801855 <ltostr+0xe2>
		start = 1 ;
  801818:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  80181f:	eb 34                	jmp    801855 <ltostr+0xe2>
	{
		char tmp = str[start] ;
  801821:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801824:	8b 45 0c             	mov    0xc(%ebp),%eax
  801827:	01 d0                	add    %edx,%eax
  801829:	8a 00                	mov    (%eax),%al
  80182b:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  80182e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801831:	8b 45 0c             	mov    0xc(%ebp),%eax
  801834:	01 c2                	add    %eax,%edx
  801836:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  801839:	8b 45 0c             	mov    0xc(%ebp),%eax
  80183c:	01 c8                	add    %ecx,%eax
  80183e:	8a 00                	mov    (%eax),%al
  801840:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  801842:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801845:	8b 45 0c             	mov    0xc(%ebp),%eax
  801848:	01 c2                	add    %eax,%edx
  80184a:	8a 45 eb             	mov    -0x15(%ebp),%al
  80184d:	88 02                	mov    %al,(%edx)
		start++ ;
  80184f:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  801852:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  801855:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801858:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80185b:	7c c4                	jl     801821 <ltostr+0xae>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  80185d:	8b 55 f8             	mov    -0x8(%ebp),%edx
  801860:	8b 45 0c             	mov    0xc(%ebp),%eax
  801863:	01 d0                	add    %edx,%eax
  801865:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  801868:	90                   	nop
  801869:	c9                   	leave  
  80186a:	c3                   	ret    

0080186b <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  80186b:	55                   	push   %ebp
  80186c:	89 e5                	mov    %esp,%ebp
  80186e:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  801871:	ff 75 08             	pushl  0x8(%ebp)
  801874:	e8 54 fa ff ff       	call   8012cd <strlen>
  801879:	83 c4 04             	add    $0x4,%esp
  80187c:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  80187f:	ff 75 0c             	pushl  0xc(%ebp)
  801882:	e8 46 fa ff ff       	call   8012cd <strlen>
  801887:	83 c4 04             	add    $0x4,%esp
  80188a:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  80188d:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  801894:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  80189b:	eb 17                	jmp    8018b4 <strcconcat+0x49>
		final[s] = str1[s] ;
  80189d:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8018a0:	8b 45 10             	mov    0x10(%ebp),%eax
  8018a3:	01 c2                	add    %eax,%edx
  8018a5:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  8018a8:	8b 45 08             	mov    0x8(%ebp),%eax
  8018ab:	01 c8                	add    %ecx,%eax
  8018ad:	8a 00                	mov    (%eax),%al
  8018af:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  8018b1:	ff 45 fc             	incl   -0x4(%ebp)
  8018b4:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8018b7:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  8018ba:	7c e1                	jl     80189d <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  8018bc:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  8018c3:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  8018ca:	eb 1f                	jmp    8018eb <strcconcat+0x80>
		final[s++] = str2[i] ;
  8018cc:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8018cf:	8d 50 01             	lea    0x1(%eax),%edx
  8018d2:	89 55 fc             	mov    %edx,-0x4(%ebp)
  8018d5:	89 c2                	mov    %eax,%edx
  8018d7:	8b 45 10             	mov    0x10(%ebp),%eax
  8018da:	01 c2                	add    %eax,%edx
  8018dc:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  8018df:	8b 45 0c             	mov    0xc(%ebp),%eax
  8018e2:	01 c8                	add    %ecx,%eax
  8018e4:	8a 00                	mov    (%eax),%al
  8018e6:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  8018e8:	ff 45 f8             	incl   -0x8(%ebp)
  8018eb:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8018ee:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8018f1:	7c d9                	jl     8018cc <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  8018f3:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8018f6:	8b 45 10             	mov    0x10(%ebp),%eax
  8018f9:	01 d0                	add    %edx,%eax
  8018fb:	c6 00 00             	movb   $0x0,(%eax)
}
  8018fe:	90                   	nop
  8018ff:	c9                   	leave  
  801900:	c3                   	ret    

00801901 <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  801901:	55                   	push   %ebp
  801902:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  801904:	8b 45 14             	mov    0x14(%ebp),%eax
  801907:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  80190d:	8b 45 14             	mov    0x14(%ebp),%eax
  801910:	8b 00                	mov    (%eax),%eax
  801912:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801919:	8b 45 10             	mov    0x10(%ebp),%eax
  80191c:	01 d0                	add    %edx,%eax
  80191e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801924:	eb 0c                	jmp    801932 <strsplit+0x31>
			*string++ = 0;
  801926:	8b 45 08             	mov    0x8(%ebp),%eax
  801929:	8d 50 01             	lea    0x1(%eax),%edx
  80192c:	89 55 08             	mov    %edx,0x8(%ebp)
  80192f:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801932:	8b 45 08             	mov    0x8(%ebp),%eax
  801935:	8a 00                	mov    (%eax),%al
  801937:	84 c0                	test   %al,%al
  801939:	74 18                	je     801953 <strsplit+0x52>
  80193b:	8b 45 08             	mov    0x8(%ebp),%eax
  80193e:	8a 00                	mov    (%eax),%al
  801940:	0f be c0             	movsbl %al,%eax
  801943:	50                   	push   %eax
  801944:	ff 75 0c             	pushl  0xc(%ebp)
  801947:	e8 13 fb ff ff       	call   80145f <strchr>
  80194c:	83 c4 08             	add    $0x8,%esp
  80194f:	85 c0                	test   %eax,%eax
  801951:	75 d3                	jne    801926 <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  801953:	8b 45 08             	mov    0x8(%ebp),%eax
  801956:	8a 00                	mov    (%eax),%al
  801958:	84 c0                	test   %al,%al
  80195a:	74 5a                	je     8019b6 <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  80195c:	8b 45 14             	mov    0x14(%ebp),%eax
  80195f:	8b 00                	mov    (%eax),%eax
  801961:	83 f8 0f             	cmp    $0xf,%eax
  801964:	75 07                	jne    80196d <strsplit+0x6c>
		{
			return 0;
  801966:	b8 00 00 00 00       	mov    $0x0,%eax
  80196b:	eb 66                	jmp    8019d3 <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  80196d:	8b 45 14             	mov    0x14(%ebp),%eax
  801970:	8b 00                	mov    (%eax),%eax
  801972:	8d 48 01             	lea    0x1(%eax),%ecx
  801975:	8b 55 14             	mov    0x14(%ebp),%edx
  801978:	89 0a                	mov    %ecx,(%edx)
  80197a:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801981:	8b 45 10             	mov    0x10(%ebp),%eax
  801984:	01 c2                	add    %eax,%edx
  801986:	8b 45 08             	mov    0x8(%ebp),%eax
  801989:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  80198b:	eb 03                	jmp    801990 <strsplit+0x8f>
			string++;
  80198d:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  801990:	8b 45 08             	mov    0x8(%ebp),%eax
  801993:	8a 00                	mov    (%eax),%al
  801995:	84 c0                	test   %al,%al
  801997:	74 8b                	je     801924 <strsplit+0x23>
  801999:	8b 45 08             	mov    0x8(%ebp),%eax
  80199c:	8a 00                	mov    (%eax),%al
  80199e:	0f be c0             	movsbl %al,%eax
  8019a1:	50                   	push   %eax
  8019a2:	ff 75 0c             	pushl  0xc(%ebp)
  8019a5:	e8 b5 fa ff ff       	call   80145f <strchr>
  8019aa:	83 c4 08             	add    $0x8,%esp
  8019ad:	85 c0                	test   %eax,%eax
  8019af:	74 dc                	je     80198d <strsplit+0x8c>
			string++;
	}
  8019b1:	e9 6e ff ff ff       	jmp    801924 <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  8019b6:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  8019b7:	8b 45 14             	mov    0x14(%ebp),%eax
  8019ba:	8b 00                	mov    (%eax),%eax
  8019bc:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8019c3:	8b 45 10             	mov    0x10(%ebp),%eax
  8019c6:	01 d0                	add    %edx,%eax
  8019c8:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  8019ce:	b8 01 00 00 00       	mov    $0x1,%eax
}
  8019d3:	c9                   	leave  
  8019d4:	c3                   	ret    

008019d5 <InitializeUHeap>:
//============================== GIVEN FUNCTIONS ===================================//
//==================================================================================//

int FirstTimeFlag = 1;
void InitializeUHeap()
{
  8019d5:	55                   	push   %ebp
  8019d6:	89 e5                	mov    %esp,%ebp
  8019d8:	83 ec 08             	sub    $0x8,%esp
	if(FirstTimeFlag)
  8019db:	a1 04 50 80 00       	mov    0x805004,%eax
  8019e0:	85 c0                	test   %eax,%eax
  8019e2:	74 1f                	je     801a03 <InitializeUHeap+0x2e>
	{
		initialize_dyn_block_system();
  8019e4:	e8 1d 00 00 00       	call   801a06 <initialize_dyn_block_system>
		cprintf("DYNAMIC BLOCK SYSTEM IS INITIALIZED\n");
  8019e9:	83 ec 0c             	sub    $0xc,%esp
  8019ec:	68 64 3f 80 00       	push   $0x803f64
  8019f1:	e8 4f f0 ff ff       	call   800a45 <cprintf>
  8019f6:	83 c4 10             	add    $0x10,%esp
#if UHP_USE_BUDDY
		initialize_buddy();
		cprintf("BUDDY SYSTEM IS INITIALIZED\n");
#endif
		FirstTimeFlag = 0;
  8019f9:	c7 05 04 50 80 00 00 	movl   $0x0,0x805004
  801a00:	00 00 00 
	}
}
  801a03:	90                   	nop
  801a04:	c9                   	leave  
  801a05:	c3                   	ret    

00801a06 <initialize_dyn_block_system>:

//=================================
// [1] INITIALIZE DYNAMIC ALLOCATOR:
//=================================
void initialize_dyn_block_system()
{
  801a06:	55                   	push   %ebp
  801a07:	89 e5                	mov    %esp,%ebp
  801a09:	83 ec 28             	sub    $0x28,%esp
	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] initialize_dyn_block_system
	// your code is here, remove the panic and write your code
	//panic("initialize_dyn_block_system() is not implemented yet...!!");

	LIST_INIT(&AllocMemBlocksList);
  801a0c:	c7 05 40 50 80 00 00 	movl   $0x0,0x805040
  801a13:	00 00 00 
  801a16:	c7 05 44 50 80 00 00 	movl   $0x0,0x805044
  801a1d:	00 00 00 
  801a20:	c7 05 4c 50 80 00 00 	movl   $0x0,0x80504c
  801a27:	00 00 00 
	LIST_INIT(&FreeMemBlocksList);
  801a2a:	c7 05 38 51 80 00 00 	movl   $0x0,0x805138
  801a31:	00 00 00 
  801a34:	c7 05 3c 51 80 00 00 	movl   $0x0,0x80513c
  801a3b:	00 00 00 
  801a3e:	c7 05 44 51 80 00 00 	movl   $0x0,0x805144
  801a45:	00 00 00 
	MAX_MEM_BLOCK_CNT = NUM_OF_UHEAP_PAGES;
  801a48:	c7 05 20 51 80 00 00 	movl   $0x20000,0x805120
  801a4f:	00 02 00 
	MemBlockNodes = (void*)USER_DYN_BLKS_ARRAY;
  801a52:	c7 45 f4 00 00 e0 7f 	movl   $0x7fe00000,-0xc(%ebp)
  801a59:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801a5c:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801a61:	2d 00 10 00 00       	sub    $0x1000,%eax
  801a66:	a3 50 50 80 00       	mov    %eax,0x805050
	int size_of_block = sizeof(struct MemBlock);
  801a6b:	c7 45 f0 10 00 00 00 	movl   $0x10,-0x10(%ebp)
	int size_all_struct = size_of_block*MAX_MEM_BLOCK_CNT;
  801a72:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801a75:	a1 20 51 80 00       	mov    0x805120,%eax
  801a7a:	0f af c2             	imul   %edx,%eax
  801a7d:	89 45 ec             	mov    %eax,-0x14(%ebp)
	size_all_struct = ROUNDUP(size_all_struct, PAGE_SIZE);
  801a80:	c7 45 e8 00 10 00 00 	movl   $0x1000,-0x18(%ebp)
  801a87:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801a8a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801a8d:	01 d0                	add    %edx,%eax
  801a8f:	48                   	dec    %eax
  801a90:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  801a93:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801a96:	ba 00 00 00 00       	mov    $0x0,%edx
  801a9b:	f7 75 e8             	divl   -0x18(%ebp)
  801a9e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801aa1:	29 d0                	sub    %edx,%eax
  801aa3:	89 45 ec             	mov    %eax,-0x14(%ebp)
	sys_allocate_chunk(USER_DYN_BLKS_ARRAY, size_all_struct,PERM_USER| PERM_WRITEABLE);
  801aa6:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801aa9:	c7 45 e0 00 00 e0 7f 	movl   $0x7fe00000,-0x20(%ebp)
  801ab0:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801ab3:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
  801ab9:	81 ea 00 10 00 00    	sub    $0x1000,%edx
  801abf:	83 ec 04             	sub    $0x4,%esp
  801ac2:	6a 06                	push   $0x6
  801ac4:	50                   	push   %eax
  801ac5:	52                   	push   %edx
  801ac6:	e8 a1 05 00 00       	call   80206c <sys_allocate_chunk>
  801acb:	83 c4 10             	add    $0x10,%esp
	initialize_MemBlocksList(MAX_MEM_BLOCK_CNT);
  801ace:	a1 20 51 80 00       	mov    0x805120,%eax
  801ad3:	83 ec 0c             	sub    $0xc,%esp
  801ad6:	50                   	push   %eax
  801ad7:	e8 16 0c 00 00       	call   8026f2 <initialize_MemBlocksList>
  801adc:	83 c4 10             	add    $0x10,%esp
	struct MemBlock* ourBlock =LIST_LAST(&AvailableMemBlocksList);
  801adf:	a1 4c 51 80 00       	mov    0x80514c,%eax
  801ae4:	89 45 dc             	mov    %eax,-0x24(%ebp)
	LIST_REMOVE(&AvailableMemBlocksList,ourBlock);
  801ae7:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  801aeb:	75 14                	jne    801b01 <initialize_dyn_block_system+0xfb>
  801aed:	83 ec 04             	sub    $0x4,%esp
  801af0:	68 89 3f 80 00       	push   $0x803f89
  801af5:	6a 2d                	push   $0x2d
  801af7:	68 a7 3f 80 00       	push   $0x803fa7
  801afc:	e8 90 ec ff ff       	call   800791 <_panic>
  801b01:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801b04:	8b 00                	mov    (%eax),%eax
  801b06:	85 c0                	test   %eax,%eax
  801b08:	74 10                	je     801b1a <initialize_dyn_block_system+0x114>
  801b0a:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801b0d:	8b 00                	mov    (%eax),%eax
  801b0f:	8b 55 dc             	mov    -0x24(%ebp),%edx
  801b12:	8b 52 04             	mov    0x4(%edx),%edx
  801b15:	89 50 04             	mov    %edx,0x4(%eax)
  801b18:	eb 0b                	jmp    801b25 <initialize_dyn_block_system+0x11f>
  801b1a:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801b1d:	8b 40 04             	mov    0x4(%eax),%eax
  801b20:	a3 4c 51 80 00       	mov    %eax,0x80514c
  801b25:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801b28:	8b 40 04             	mov    0x4(%eax),%eax
  801b2b:	85 c0                	test   %eax,%eax
  801b2d:	74 0f                	je     801b3e <initialize_dyn_block_system+0x138>
  801b2f:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801b32:	8b 40 04             	mov    0x4(%eax),%eax
  801b35:	8b 55 dc             	mov    -0x24(%ebp),%edx
  801b38:	8b 12                	mov    (%edx),%edx
  801b3a:	89 10                	mov    %edx,(%eax)
  801b3c:	eb 0a                	jmp    801b48 <initialize_dyn_block_system+0x142>
  801b3e:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801b41:	8b 00                	mov    (%eax),%eax
  801b43:	a3 48 51 80 00       	mov    %eax,0x805148
  801b48:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801b4b:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  801b51:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801b54:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  801b5b:	a1 54 51 80 00       	mov    0x805154,%eax
  801b60:	48                   	dec    %eax
  801b61:	a3 54 51 80 00       	mov    %eax,0x805154
	ourBlock->size = USER_HEAP_MAX-USER_HEAP_START;
  801b66:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801b69:	c7 40 0c 00 00 00 20 	movl   $0x20000000,0xc(%eax)
	ourBlock->sva=USER_HEAP_START;
  801b70:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801b73:	c7 40 08 00 00 00 80 	movl   $0x80000000,0x8(%eax)
	LIST_INSERT_TAIL(&FreeMemBlocksList, ourBlock);
  801b7a:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  801b7e:	75 14                	jne    801b94 <initialize_dyn_block_system+0x18e>
  801b80:	83 ec 04             	sub    $0x4,%esp
  801b83:	68 b4 3f 80 00       	push   $0x803fb4
  801b88:	6a 30                	push   $0x30
  801b8a:	68 a7 3f 80 00       	push   $0x803fa7
  801b8f:	e8 fd eb ff ff       	call   800791 <_panic>
  801b94:	8b 15 3c 51 80 00    	mov    0x80513c,%edx
  801b9a:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801b9d:	89 50 04             	mov    %edx,0x4(%eax)
  801ba0:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801ba3:	8b 40 04             	mov    0x4(%eax),%eax
  801ba6:	85 c0                	test   %eax,%eax
  801ba8:	74 0c                	je     801bb6 <initialize_dyn_block_system+0x1b0>
  801baa:	a1 3c 51 80 00       	mov    0x80513c,%eax
  801baf:	8b 55 dc             	mov    -0x24(%ebp),%edx
  801bb2:	89 10                	mov    %edx,(%eax)
  801bb4:	eb 08                	jmp    801bbe <initialize_dyn_block_system+0x1b8>
  801bb6:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801bb9:	a3 38 51 80 00       	mov    %eax,0x805138
  801bbe:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801bc1:	a3 3c 51 80 00       	mov    %eax,0x80513c
  801bc6:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801bc9:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  801bcf:	a1 44 51 80 00       	mov    0x805144,%eax
  801bd4:	40                   	inc    %eax
  801bd5:	a3 44 51 80 00       	mov    %eax,0x805144
	//[1] Initialize two lists (AllocMemBlocksList & FreeMemBlocksList) [Hint: use LIST_INIT()]
	//[2] Dynamically allocate the array of MemBlockNodes at VA USER_DYN_BLKS_ARRAY
	//	  (remember to set MAX_MEM_BLOCK_CNT with the chosen size of the array)
	//[3] Initialize AvailableMemBlocksList by filling it with the MemBlockNodes
	//[4] Insert a new MemBlock with the heap size into the FreeMemBlocksList
}
  801bda:	90                   	nop
  801bdb:	c9                   	leave  
  801bdc:	c3                   	ret    

00801bdd <malloc>:
//=================================
// [2] ALLOCATE SPACE IN USER HEAP:
//=================================

void* malloc(uint32 size)
{
  801bdd:	55                   	push   %ebp
  801bde:	89 e5                	mov    %esp,%ebp
  801be0:	83 ec 18             	sub    $0x18,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801be3:	e8 ed fd ff ff       	call   8019d5 <InitializeUHeap>
	if (size == 0) return NULL ;
  801be8:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801bec:	75 07                	jne    801bf5 <malloc+0x18>
  801bee:	b8 00 00 00 00       	mov    $0x0,%eax
  801bf3:	eb 67                	jmp    801c5c <malloc+0x7f>

	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] malloc
	// your code is here, remove the panic and write your code
	//panic("malloc() is not implemented yet...!!");

	size = ROUNDUP(size, PAGE_SIZE);
  801bf5:	c7 45 f4 00 10 00 00 	movl   $0x1000,-0xc(%ebp)
  801bfc:	8b 55 08             	mov    0x8(%ebp),%edx
  801bff:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801c02:	01 d0                	add    %edx,%eax
  801c04:	48                   	dec    %eax
  801c05:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801c08:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801c0b:	ba 00 00 00 00       	mov    $0x0,%edx
  801c10:	f7 75 f4             	divl   -0xc(%ebp)
  801c13:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801c16:	29 d0                	sub    %edx,%eax
  801c18:	89 45 08             	mov    %eax,0x8(%ebp)
	if(sys_isUHeapPlacementStrategyFIRSTFIT())
  801c1b:	e8 1a 08 00 00       	call   80243a <sys_isUHeapPlacementStrategyFIRSTFIT>
  801c20:	85 c0                	test   %eax,%eax
  801c22:	74 33                	je     801c57 <malloc+0x7a>
	{
		struct MemBlock * myBlock = alloc_block_FF(size);
  801c24:	83 ec 0c             	sub    $0xc,%esp
  801c27:	ff 75 08             	pushl  0x8(%ebp)
  801c2a:	e8 0c 0e 00 00       	call   802a3b <alloc_block_FF>
  801c2f:	83 c4 10             	add    $0x10,%esp
  801c32:	89 45 ec             	mov    %eax,-0x14(%ebp)
		if(myBlock != NULL)
  801c35:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  801c39:	74 1c                	je     801c57 <malloc+0x7a>
		{
			insert_sorted_allocList(myBlock);
  801c3b:	83 ec 0c             	sub    $0xc,%esp
  801c3e:	ff 75 ec             	pushl  -0x14(%ebp)
  801c41:	e8 07 0c 00 00       	call   80284d <insert_sorted_allocList>
  801c46:	83 c4 10             	add    $0x10,%esp
			uint32 ptr = myBlock->sva;
  801c49:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801c4c:	8b 40 08             	mov    0x8(%eax),%eax
  801c4f:	89 45 e8             	mov    %eax,-0x18(%ebp)
			return (void *)ptr;
  801c52:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801c55:	eb 05                	jmp    801c5c <malloc+0x7f>
		}
	}
	return NULL;
  801c57:	b8 00 00 00 00       	mov    $0x0,%eax
	//		to the required allocation size (space should be on 4 KB BOUNDARY)
	//	2) if no suitable space found, return NULL
	// 	3) Return pointer containing the virtual address of allocated space,
	//
	//Use sys_isUHeapPlacementStrategyFIRSTFIT()... to check the current strategy
}
  801c5c:	c9                   	leave  
  801c5d:	c3                   	ret    

00801c5e <free>:
//	We can use sys_free_user_mem(uint32 virtual_address, uint32 size); which
//		switches to the kernel mode, calls free_user_mem() in
//		"kern/mem/chunk_operations.c", then switch back to the user mode here
//	the free_user_mem function is empty, make sure to implement it.
void free(void* virtual_address)
{
  801c5e:	55                   	push   %ebp
  801c5f:	89 e5                	mov    %esp,%ebp
  801c61:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] free
	// your code is here, remove the panic and write your code
	//panic("free() is not implemented yet...!!");

	uint32 virtualAddress = (uint32 )(virtual_address);
  801c64:	8b 45 08             	mov    0x8(%ebp),%eax
  801c67:	89 45 f4             	mov    %eax,-0xc(%ebp)
//	virtualAddress = ROUNDDOWN(virtualAddress, PAGE_SIZE);
	struct MemBlock * myBlock = find_block(&AllocMemBlocksList, virtualAddress);
  801c6a:	83 ec 08             	sub    $0x8,%esp
  801c6d:	ff 75 f4             	pushl  -0xc(%ebp)
  801c70:	68 40 50 80 00       	push   $0x805040
  801c75:	e8 5b 0b 00 00       	call   8027d5 <find_block>
  801c7a:	83 c4 10             	add    $0x10,%esp
  801c7d:	89 45 f0             	mov    %eax,-0x10(%ebp)
//	cprintf ("ptr sva at free user side = %x \n", myBlock->sva);
	sys_free_user_mem(virtualAddress, myBlock->size);
  801c80:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801c83:	8b 40 0c             	mov    0xc(%eax),%eax
  801c86:	83 ec 08             	sub    $0x8,%esp
  801c89:	50                   	push   %eax
  801c8a:	ff 75 f4             	pushl  -0xc(%ebp)
  801c8d:	e8 a2 03 00 00       	call   802034 <sys_free_user_mem>
  801c92:	83 c4 10             	add    $0x10,%esp
	LIST_REMOVE(&AllocMemBlocksList, myBlock);
  801c95:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801c99:	75 14                	jne    801caf <free+0x51>
  801c9b:	83 ec 04             	sub    $0x4,%esp
  801c9e:	68 89 3f 80 00       	push   $0x803f89
  801ca3:	6a 76                	push   $0x76
  801ca5:	68 a7 3f 80 00       	push   $0x803fa7
  801caa:	e8 e2 ea ff ff       	call   800791 <_panic>
  801caf:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801cb2:	8b 00                	mov    (%eax),%eax
  801cb4:	85 c0                	test   %eax,%eax
  801cb6:	74 10                	je     801cc8 <free+0x6a>
  801cb8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801cbb:	8b 00                	mov    (%eax),%eax
  801cbd:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801cc0:	8b 52 04             	mov    0x4(%edx),%edx
  801cc3:	89 50 04             	mov    %edx,0x4(%eax)
  801cc6:	eb 0b                	jmp    801cd3 <free+0x75>
  801cc8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801ccb:	8b 40 04             	mov    0x4(%eax),%eax
  801cce:	a3 44 50 80 00       	mov    %eax,0x805044
  801cd3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801cd6:	8b 40 04             	mov    0x4(%eax),%eax
  801cd9:	85 c0                	test   %eax,%eax
  801cdb:	74 0f                	je     801cec <free+0x8e>
  801cdd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801ce0:	8b 40 04             	mov    0x4(%eax),%eax
  801ce3:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801ce6:	8b 12                	mov    (%edx),%edx
  801ce8:	89 10                	mov    %edx,(%eax)
  801cea:	eb 0a                	jmp    801cf6 <free+0x98>
  801cec:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801cef:	8b 00                	mov    (%eax),%eax
  801cf1:	a3 40 50 80 00       	mov    %eax,0x805040
  801cf6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801cf9:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  801cff:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801d02:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  801d09:	a1 4c 50 80 00       	mov    0x80504c,%eax
  801d0e:	48                   	dec    %eax
  801d0f:	a3 4c 50 80 00       	mov    %eax,0x80504c
	insert_sorted_with_merge_freeList(myBlock);
  801d14:	83 ec 0c             	sub    $0xc,%esp
  801d17:	ff 75 f0             	pushl  -0x10(%ebp)
  801d1a:	e8 0b 14 00 00       	call   80312a <insert_sorted_with_merge_freeList>
  801d1f:	83 c4 10             	add    $0x10,%esp

	//you should get the size of the given allocation using its address
	//you need to call sys_free_user_mem()
	//refer to the project presentation and documentation for details
}
  801d22:	90                   	nop
  801d23:	c9                   	leave  
  801d24:	c3                   	ret    

00801d25 <smalloc>:

//=================================
// [4] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
  801d25:	55                   	push   %ebp
  801d26:	89 e5                	mov    %esp,%ebp
  801d28:	83 ec 28             	sub    $0x28,%esp
  801d2b:	8b 45 10             	mov    0x10(%ebp),%eax
  801d2e:	88 45 e4             	mov    %al,-0x1c(%ebp)
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801d31:	e8 9f fc ff ff       	call   8019d5 <InitializeUHeap>
	if (size == 0) return NULL ;
  801d36:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801d3a:	75 0a                	jne    801d46 <smalloc+0x21>
  801d3c:	b8 00 00 00 00       	mov    $0x0,%eax
  801d41:	e9 8d 00 00 00       	jmp    801dd3 <smalloc+0xae>

	//This function should find the space of the required range
	// * ON 4KB BOUNDARY **** //
	//Use sys_isUHeapPlacementStrategyFIRSTFIT() to check the current strategy

	size = ROUNDUP(size, PAGE_SIZE);
  801d46:	c7 45 f4 00 10 00 00 	movl   $0x1000,-0xc(%ebp)
  801d4d:	8b 55 0c             	mov    0xc(%ebp),%edx
  801d50:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801d53:	01 d0                	add    %edx,%eax
  801d55:	48                   	dec    %eax
  801d56:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801d59:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801d5c:	ba 00 00 00 00       	mov    $0x0,%edx
  801d61:	f7 75 f4             	divl   -0xc(%ebp)
  801d64:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801d67:	29 d0                	sub    %edx,%eax
  801d69:	89 45 0c             	mov    %eax,0xc(%ebp)
		if(sys_isUHeapPlacementStrategyFIRSTFIT())
  801d6c:	e8 c9 06 00 00       	call   80243a <sys_isUHeapPlacementStrategyFIRSTFIT>
  801d71:	85 c0                	test   %eax,%eax
  801d73:	74 59                	je     801dce <smalloc+0xa9>
		{
			struct MemBlock * v1=NULL;
  801d75:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
			v1= alloc_block_FF(size);
  801d7c:	83 ec 0c             	sub    $0xc,%esp
  801d7f:	ff 75 0c             	pushl  0xc(%ebp)
  801d82:	e8 b4 0c 00 00       	call   802a3b <alloc_block_FF>
  801d87:	83 c4 10             	add    $0x10,%esp
  801d8a:	89 45 ec             	mov    %eax,-0x14(%ebp)
			if(v1==NULL)
  801d8d:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  801d91:	75 07                	jne    801d9a <smalloc+0x75>
			{
				return NULL;
  801d93:	b8 00 00 00 00       	mov    $0x0,%eax
  801d98:	eb 39                	jmp    801dd3 <smalloc+0xae>
			}
			else
			{
				int ret=sys_createSharedObject(sharedVarName,  size,  isWritable,(void*)v1->sva);
  801d9a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801d9d:	8b 40 08             	mov    0x8(%eax),%eax
  801da0:	89 c2                	mov    %eax,%edx
  801da2:	0f b6 45 e4          	movzbl -0x1c(%ebp),%eax
  801da6:	52                   	push   %edx
  801da7:	50                   	push   %eax
  801da8:	ff 75 0c             	pushl  0xc(%ebp)
  801dab:	ff 75 08             	pushl  0x8(%ebp)
  801dae:	e8 0c 04 00 00       	call   8021bf <sys_createSharedObject>
  801db3:	83 c4 10             	add    $0x10,%esp
  801db6:	89 45 e8             	mov    %eax,-0x18(%ebp)
				if(ret>=0)
  801db9:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  801dbd:	78 08                	js     801dc7 <smalloc+0xa2>
				{
					return (void*)v1->sva;
  801dbf:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801dc2:	8b 40 08             	mov    0x8(%eax),%eax
  801dc5:	eb 0c                	jmp    801dd3 <smalloc+0xae>
				}
				else
				{
					return NULL;
  801dc7:	b8 00 00 00 00       	mov    $0x0,%eax
  801dcc:	eb 05                	jmp    801dd3 <smalloc+0xae>
				}
			}

		}
		return NULL;
  801dce:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801dd3:	c9                   	leave  
  801dd4:	c3                   	ret    

00801dd5 <sget>:

//========================================
// [5] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  801dd5:	55                   	push   %ebp
  801dd6:	89 e5                	mov    %esp,%ebp
  801dd8:	83 ec 18             	sub    $0x18,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801ddb:	e8 f5 fb ff ff       	call   8019d5 <InitializeUHeap>

	//This function should find the space for sharing the variable
	// *** ON 4KB BOUNDARY ******** //

	//Use sys_isUHeapPlacementStrategyFIRSTFIT() to check the current strategy
	int ret=sys_getSizeOfSharedObject(ownerEnvID,sharedVarName);
  801de0:	83 ec 08             	sub    $0x8,%esp
  801de3:	ff 75 0c             	pushl  0xc(%ebp)
  801de6:	ff 75 08             	pushl  0x8(%ebp)
  801de9:	e8 fb 03 00 00       	call   8021e9 <sys_getSizeOfSharedObject>
  801dee:	83 c4 10             	add    $0x10,%esp
  801df1:	89 45 f4             	mov    %eax,-0xc(%ebp)
	if(ret==0)
  801df4:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801df8:	75 07                	jne    801e01 <sget+0x2c>
	{
		return NULL;
  801dfa:	b8 00 00 00 00       	mov    $0x0,%eax
  801dff:	eb 64                	jmp    801e65 <sget+0x90>
	}
	if(sys_isUHeapPlacementStrategyFIRSTFIT())
  801e01:	e8 34 06 00 00       	call   80243a <sys_isUHeapPlacementStrategyFIRSTFIT>
  801e06:	85 c0                	test   %eax,%eax
  801e08:	74 56                	je     801e60 <sget+0x8b>
	{
		struct MemBlock * v1=NULL;
  801e0a:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
		v1= alloc_block_FF(ret);
  801e11:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e14:	83 ec 0c             	sub    $0xc,%esp
  801e17:	50                   	push   %eax
  801e18:	e8 1e 0c 00 00       	call   802a3b <alloc_block_FF>
  801e1d:	83 c4 10             	add    $0x10,%esp
  801e20:	89 45 f0             	mov    %eax,-0x10(%ebp)
		if(v1==NULL)
  801e23:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801e27:	75 07                	jne    801e30 <sget+0x5b>
		{
		return NULL;
  801e29:	b8 00 00 00 00       	mov    $0x0,%eax
  801e2e:	eb 35                	jmp    801e65 <sget+0x90>
	    }
		else
		{
			int ret1=sys_getSharedObject(ownerEnvID,sharedVarName,(void*)v1->sva);
  801e30:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801e33:	8b 40 08             	mov    0x8(%eax),%eax
  801e36:	83 ec 04             	sub    $0x4,%esp
  801e39:	50                   	push   %eax
  801e3a:	ff 75 0c             	pushl  0xc(%ebp)
  801e3d:	ff 75 08             	pushl  0x8(%ebp)
  801e40:	e8 c1 03 00 00       	call   802206 <sys_getSharedObject>
  801e45:	83 c4 10             	add    $0x10,%esp
  801e48:	89 45 ec             	mov    %eax,-0x14(%ebp)
			if(ret1>=0)
  801e4b:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  801e4f:	78 08                	js     801e59 <sget+0x84>
			{
				return (void*)v1->sva;
  801e51:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801e54:	8b 40 08             	mov    0x8(%eax),%eax
  801e57:	eb 0c                	jmp    801e65 <sget+0x90>
			}
			else
			{
				return NULL;
  801e59:	b8 00 00 00 00       	mov    $0x0,%eax
  801e5e:	eb 05                	jmp    801e65 <sget+0x90>
			}
		}
	}
  return NULL;
  801e60:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801e65:	c9                   	leave  
  801e66:	c3                   	ret    

00801e67 <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  801e67:	55                   	push   %ebp
  801e68:	89 e5                	mov    %esp,%ebp
  801e6a:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801e6d:	e8 63 fb ff ff       	call   8019d5 <InitializeUHeap>
	//==============================================================
	// [USER HEAP - USER SIDE] realloc
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  801e72:	83 ec 04             	sub    $0x4,%esp
  801e75:	68 d8 3f 80 00       	push   $0x803fd8
  801e7a:	68 0e 01 00 00       	push   $0x10e
  801e7f:	68 a7 3f 80 00       	push   $0x803fa7
  801e84:	e8 08 e9 ff ff       	call   800791 <_panic>

00801e89 <sfree>:
//	use sys_freeSharedObject(...); which switches to the kernel mode,
//	calls freeSharedObject(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the freeSharedObject() function is empty, make sure to implement it.

void sfree(void* virtual_address)
{
  801e89:	55                   	push   %ebp
  801e8a:	89 e5                	mov    %esp,%ebp
  801e8c:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS3 - BONUS] [SHARING - USER SIDE] sfree()

	// Write your code here, remove the panic and write your code
	panic("sfree() is not implemented yet...!!");
  801e8f:	83 ec 04             	sub    $0x4,%esp
  801e92:	68 00 40 80 00       	push   $0x804000
  801e97:	68 22 01 00 00       	push   $0x122
  801e9c:	68 a7 3f 80 00       	push   $0x803fa7
  801ea1:	e8 eb e8 ff ff       	call   800791 <_panic>

00801ea6 <expand>:

//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//
void expand(uint32 newSize)
{
  801ea6:	55                   	push   %ebp
  801ea7:	89 e5                	mov    %esp,%ebp
  801ea9:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801eac:	83 ec 04             	sub    $0x4,%esp
  801eaf:	68 24 40 80 00       	push   $0x804024
  801eb4:	68 2d 01 00 00       	push   $0x12d
  801eb9:	68 a7 3f 80 00       	push   $0x803fa7
  801ebe:	e8 ce e8 ff ff       	call   800791 <_panic>

00801ec3 <shrink>:

}
void shrink(uint32 newSize)
{
  801ec3:	55                   	push   %ebp
  801ec4:	89 e5                	mov    %esp,%ebp
  801ec6:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801ec9:	83 ec 04             	sub    $0x4,%esp
  801ecc:	68 24 40 80 00       	push   $0x804024
  801ed1:	68 32 01 00 00       	push   $0x132
  801ed6:	68 a7 3f 80 00       	push   $0x803fa7
  801edb:	e8 b1 e8 ff ff       	call   800791 <_panic>

00801ee0 <freeHeap>:

}
void freeHeap(void* virtual_address)
{
  801ee0:	55                   	push   %ebp
  801ee1:	89 e5                	mov    %esp,%ebp
  801ee3:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801ee6:	83 ec 04             	sub    $0x4,%esp
  801ee9:	68 24 40 80 00       	push   $0x804024
  801eee:	68 37 01 00 00       	push   $0x137
  801ef3:	68 a7 3f 80 00       	push   $0x803fa7
  801ef8:	e8 94 e8 ff ff       	call   800791 <_panic>

00801efd <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  801efd:	55                   	push   %ebp
  801efe:	89 e5                	mov    %esp,%ebp
  801f00:	57                   	push   %edi
  801f01:	56                   	push   %esi
  801f02:	53                   	push   %ebx
  801f03:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801f06:	8b 45 08             	mov    0x8(%ebp),%eax
  801f09:	8b 55 0c             	mov    0xc(%ebp),%edx
  801f0c:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801f0f:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801f12:	8b 7d 18             	mov    0x18(%ebp),%edi
  801f15:	8b 75 1c             	mov    0x1c(%ebp),%esi
  801f18:	cd 30                	int    $0x30
  801f1a:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  801f1d:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801f20:	83 c4 10             	add    $0x10,%esp
  801f23:	5b                   	pop    %ebx
  801f24:	5e                   	pop    %esi
  801f25:	5f                   	pop    %edi
  801f26:	5d                   	pop    %ebp
  801f27:	c3                   	ret    

00801f28 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  801f28:	55                   	push   %ebp
  801f29:	89 e5                	mov    %esp,%ebp
  801f2b:	83 ec 04             	sub    $0x4,%esp
  801f2e:	8b 45 10             	mov    0x10(%ebp),%eax
  801f31:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  801f34:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801f38:	8b 45 08             	mov    0x8(%ebp),%eax
  801f3b:	6a 00                	push   $0x0
  801f3d:	6a 00                	push   $0x0
  801f3f:	52                   	push   %edx
  801f40:	ff 75 0c             	pushl  0xc(%ebp)
  801f43:	50                   	push   %eax
  801f44:	6a 00                	push   $0x0
  801f46:	e8 b2 ff ff ff       	call   801efd <syscall>
  801f4b:	83 c4 18             	add    $0x18,%esp
}
  801f4e:	90                   	nop
  801f4f:	c9                   	leave  
  801f50:	c3                   	ret    

00801f51 <sys_cgetc>:

int
sys_cgetc(void)
{
  801f51:	55                   	push   %ebp
  801f52:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  801f54:	6a 00                	push   $0x0
  801f56:	6a 00                	push   $0x0
  801f58:	6a 00                	push   $0x0
  801f5a:	6a 00                	push   $0x0
  801f5c:	6a 00                	push   $0x0
  801f5e:	6a 01                	push   $0x1
  801f60:	e8 98 ff ff ff       	call   801efd <syscall>
  801f65:	83 c4 18             	add    $0x18,%esp
}
  801f68:	c9                   	leave  
  801f69:	c3                   	ret    

00801f6a <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  801f6a:	55                   	push   %ebp
  801f6b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  801f6d:	8b 55 0c             	mov    0xc(%ebp),%edx
  801f70:	8b 45 08             	mov    0x8(%ebp),%eax
  801f73:	6a 00                	push   $0x0
  801f75:	6a 00                	push   $0x0
  801f77:	6a 00                	push   $0x0
  801f79:	52                   	push   %edx
  801f7a:	50                   	push   %eax
  801f7b:	6a 05                	push   $0x5
  801f7d:	e8 7b ff ff ff       	call   801efd <syscall>
  801f82:	83 c4 18             	add    $0x18,%esp
}
  801f85:	c9                   	leave  
  801f86:	c3                   	ret    

00801f87 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  801f87:	55                   	push   %ebp
  801f88:	89 e5                	mov    %esp,%ebp
  801f8a:	56                   	push   %esi
  801f8b:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  801f8c:	8b 75 18             	mov    0x18(%ebp),%esi
  801f8f:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801f92:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801f95:	8b 55 0c             	mov    0xc(%ebp),%edx
  801f98:	8b 45 08             	mov    0x8(%ebp),%eax
  801f9b:	56                   	push   %esi
  801f9c:	53                   	push   %ebx
  801f9d:	51                   	push   %ecx
  801f9e:	52                   	push   %edx
  801f9f:	50                   	push   %eax
  801fa0:	6a 06                	push   $0x6
  801fa2:	e8 56 ff ff ff       	call   801efd <syscall>
  801fa7:	83 c4 18             	add    $0x18,%esp
}
  801faa:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801fad:	5b                   	pop    %ebx
  801fae:	5e                   	pop    %esi
  801faf:	5d                   	pop    %ebp
  801fb0:	c3                   	ret    

00801fb1 <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  801fb1:	55                   	push   %ebp
  801fb2:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  801fb4:	8b 55 0c             	mov    0xc(%ebp),%edx
  801fb7:	8b 45 08             	mov    0x8(%ebp),%eax
  801fba:	6a 00                	push   $0x0
  801fbc:	6a 00                	push   $0x0
  801fbe:	6a 00                	push   $0x0
  801fc0:	52                   	push   %edx
  801fc1:	50                   	push   %eax
  801fc2:	6a 07                	push   $0x7
  801fc4:	e8 34 ff ff ff       	call   801efd <syscall>
  801fc9:	83 c4 18             	add    $0x18,%esp
}
  801fcc:	c9                   	leave  
  801fcd:	c3                   	ret    

00801fce <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  801fce:	55                   	push   %ebp
  801fcf:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  801fd1:	6a 00                	push   $0x0
  801fd3:	6a 00                	push   $0x0
  801fd5:	6a 00                	push   $0x0
  801fd7:	ff 75 0c             	pushl  0xc(%ebp)
  801fda:	ff 75 08             	pushl  0x8(%ebp)
  801fdd:	6a 08                	push   $0x8
  801fdf:	e8 19 ff ff ff       	call   801efd <syscall>
  801fe4:	83 c4 18             	add    $0x18,%esp
}
  801fe7:	c9                   	leave  
  801fe8:	c3                   	ret    

00801fe9 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  801fe9:	55                   	push   %ebp
  801fea:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  801fec:	6a 00                	push   $0x0
  801fee:	6a 00                	push   $0x0
  801ff0:	6a 00                	push   $0x0
  801ff2:	6a 00                	push   $0x0
  801ff4:	6a 00                	push   $0x0
  801ff6:	6a 09                	push   $0x9
  801ff8:	e8 00 ff ff ff       	call   801efd <syscall>
  801ffd:	83 c4 18             	add    $0x18,%esp
}
  802000:	c9                   	leave  
  802001:	c3                   	ret    

00802002 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  802002:	55                   	push   %ebp
  802003:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  802005:	6a 00                	push   $0x0
  802007:	6a 00                	push   $0x0
  802009:	6a 00                	push   $0x0
  80200b:	6a 00                	push   $0x0
  80200d:	6a 00                	push   $0x0
  80200f:	6a 0a                	push   $0xa
  802011:	e8 e7 fe ff ff       	call   801efd <syscall>
  802016:	83 c4 18             	add    $0x18,%esp
}
  802019:	c9                   	leave  
  80201a:	c3                   	ret    

0080201b <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  80201b:	55                   	push   %ebp
  80201c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  80201e:	6a 00                	push   $0x0
  802020:	6a 00                	push   $0x0
  802022:	6a 00                	push   $0x0
  802024:	6a 00                	push   $0x0
  802026:	6a 00                	push   $0x0
  802028:	6a 0b                	push   $0xb
  80202a:	e8 ce fe ff ff       	call   801efd <syscall>
  80202f:	83 c4 18             	add    $0x18,%esp
}
  802032:	c9                   	leave  
  802033:	c3                   	ret    

00802034 <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  802034:	55                   	push   %ebp
  802035:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  802037:	6a 00                	push   $0x0
  802039:	6a 00                	push   $0x0
  80203b:	6a 00                	push   $0x0
  80203d:	ff 75 0c             	pushl  0xc(%ebp)
  802040:	ff 75 08             	pushl  0x8(%ebp)
  802043:	6a 0f                	push   $0xf
  802045:	e8 b3 fe ff ff       	call   801efd <syscall>
  80204a:	83 c4 18             	add    $0x18,%esp
	return;
  80204d:	90                   	nop
}
  80204e:	c9                   	leave  
  80204f:	c3                   	ret    

00802050 <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  802050:	55                   	push   %ebp
  802051:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  802053:	6a 00                	push   $0x0
  802055:	6a 00                	push   $0x0
  802057:	6a 00                	push   $0x0
  802059:	ff 75 0c             	pushl  0xc(%ebp)
  80205c:	ff 75 08             	pushl  0x8(%ebp)
  80205f:	6a 10                	push   $0x10
  802061:	e8 97 fe ff ff       	call   801efd <syscall>
  802066:	83 c4 18             	add    $0x18,%esp
	return ;
  802069:	90                   	nop
}
  80206a:	c9                   	leave  
  80206b:	c3                   	ret    

0080206c <sys_allocate_chunk>:

void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  80206c:	55                   	push   %ebp
  80206d:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  80206f:	6a 00                	push   $0x0
  802071:	6a 00                	push   $0x0
  802073:	ff 75 10             	pushl  0x10(%ebp)
  802076:	ff 75 0c             	pushl  0xc(%ebp)
  802079:	ff 75 08             	pushl  0x8(%ebp)
  80207c:	6a 11                	push   $0x11
  80207e:	e8 7a fe ff ff       	call   801efd <syscall>
  802083:	83 c4 18             	add    $0x18,%esp
	return ;
  802086:	90                   	nop
}
  802087:	c9                   	leave  
  802088:	c3                   	ret    

00802089 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  802089:	55                   	push   %ebp
  80208a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  80208c:	6a 00                	push   $0x0
  80208e:	6a 00                	push   $0x0
  802090:	6a 00                	push   $0x0
  802092:	6a 00                	push   $0x0
  802094:	6a 00                	push   $0x0
  802096:	6a 0c                	push   $0xc
  802098:	e8 60 fe ff ff       	call   801efd <syscall>
  80209d:	83 c4 18             	add    $0x18,%esp
}
  8020a0:	c9                   	leave  
  8020a1:	c3                   	ret    

008020a2 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  8020a2:	55                   	push   %ebp
  8020a3:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  8020a5:	6a 00                	push   $0x0
  8020a7:	6a 00                	push   $0x0
  8020a9:	6a 00                	push   $0x0
  8020ab:	6a 00                	push   $0x0
  8020ad:	ff 75 08             	pushl  0x8(%ebp)
  8020b0:	6a 0d                	push   $0xd
  8020b2:	e8 46 fe ff ff       	call   801efd <syscall>
  8020b7:	83 c4 18             	add    $0x18,%esp
}
  8020ba:	c9                   	leave  
  8020bb:	c3                   	ret    

008020bc <sys_scarce_memory>:

void sys_scarce_memory()
{
  8020bc:	55                   	push   %ebp
  8020bd:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  8020bf:	6a 00                	push   $0x0
  8020c1:	6a 00                	push   $0x0
  8020c3:	6a 00                	push   $0x0
  8020c5:	6a 00                	push   $0x0
  8020c7:	6a 00                	push   $0x0
  8020c9:	6a 0e                	push   $0xe
  8020cb:	e8 2d fe ff ff       	call   801efd <syscall>
  8020d0:	83 c4 18             	add    $0x18,%esp
}
  8020d3:	90                   	nop
  8020d4:	c9                   	leave  
  8020d5:	c3                   	ret    

008020d6 <sys_disable_interrupt>:

//NEW !! 2012...
void
sys_disable_interrupt()
{
  8020d6:	55                   	push   %ebp
  8020d7:	89 e5                	mov    %esp,%ebp
	syscall(SYS_disableINTR,0, 0, 0, 0, 0);
  8020d9:	6a 00                	push   $0x0
  8020db:	6a 00                	push   $0x0
  8020dd:	6a 00                	push   $0x0
  8020df:	6a 00                	push   $0x0
  8020e1:	6a 00                	push   $0x0
  8020e3:	6a 13                	push   $0x13
  8020e5:	e8 13 fe ff ff       	call   801efd <syscall>
  8020ea:	83 c4 18             	add    $0x18,%esp
}
  8020ed:	90                   	nop
  8020ee:	c9                   	leave  
  8020ef:	c3                   	ret    

008020f0 <sys_enable_interrupt>:


void
sys_enable_interrupt()
{
  8020f0:	55                   	push   %ebp
  8020f1:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enableINTR,0, 0, 0, 0, 0);
  8020f3:	6a 00                	push   $0x0
  8020f5:	6a 00                	push   $0x0
  8020f7:	6a 00                	push   $0x0
  8020f9:	6a 00                	push   $0x0
  8020fb:	6a 00                	push   $0x0
  8020fd:	6a 14                	push   $0x14
  8020ff:	e8 f9 fd ff ff       	call   801efd <syscall>
  802104:	83 c4 18             	add    $0x18,%esp
}
  802107:	90                   	nop
  802108:	c9                   	leave  
  802109:	c3                   	ret    

0080210a <sys_cputc>:


void
sys_cputc(const char c)
{
  80210a:	55                   	push   %ebp
  80210b:	89 e5                	mov    %esp,%ebp
  80210d:	83 ec 04             	sub    $0x4,%esp
  802110:	8b 45 08             	mov    0x8(%ebp),%eax
  802113:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  802116:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  80211a:	6a 00                	push   $0x0
  80211c:	6a 00                	push   $0x0
  80211e:	6a 00                	push   $0x0
  802120:	6a 00                	push   $0x0
  802122:	50                   	push   %eax
  802123:	6a 15                	push   $0x15
  802125:	e8 d3 fd ff ff       	call   801efd <syscall>
  80212a:	83 c4 18             	add    $0x18,%esp
}
  80212d:	90                   	nop
  80212e:	c9                   	leave  
  80212f:	c3                   	ret    

00802130 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  802130:	55                   	push   %ebp
  802131:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  802133:	6a 00                	push   $0x0
  802135:	6a 00                	push   $0x0
  802137:	6a 00                	push   $0x0
  802139:	6a 00                	push   $0x0
  80213b:	6a 00                	push   $0x0
  80213d:	6a 16                	push   $0x16
  80213f:	e8 b9 fd ff ff       	call   801efd <syscall>
  802144:	83 c4 18             	add    $0x18,%esp
}
  802147:	90                   	nop
  802148:	c9                   	leave  
  802149:	c3                   	ret    

0080214a <sys_createSemaphore>:

int
sys_createSemaphore(char* semaphoreName, uint32 initialValue)
{
  80214a:	55                   	push   %ebp
  80214b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_semaphore,(uint32)semaphoreName, (uint32)initialValue, 0, 0, 0);
  80214d:	8b 45 08             	mov    0x8(%ebp),%eax
  802150:	6a 00                	push   $0x0
  802152:	6a 00                	push   $0x0
  802154:	6a 00                	push   $0x0
  802156:	ff 75 0c             	pushl  0xc(%ebp)
  802159:	50                   	push   %eax
  80215a:	6a 17                	push   $0x17
  80215c:	e8 9c fd ff ff       	call   801efd <syscall>
  802161:	83 c4 18             	add    $0x18,%esp
}
  802164:	c9                   	leave  
  802165:	c3                   	ret    

00802166 <sys_getSemaphoreValue>:

int
sys_getSemaphoreValue(int32 ownerEnvID, char* semaphoreName)
{
  802166:	55                   	push   %ebp
  802167:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_semaphore_value,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  802169:	8b 55 0c             	mov    0xc(%ebp),%edx
  80216c:	8b 45 08             	mov    0x8(%ebp),%eax
  80216f:	6a 00                	push   $0x0
  802171:	6a 00                	push   $0x0
  802173:	6a 00                	push   $0x0
  802175:	52                   	push   %edx
  802176:	50                   	push   %eax
  802177:	6a 1a                	push   $0x1a
  802179:	e8 7f fd ff ff       	call   801efd <syscall>
  80217e:	83 c4 18             	add    $0x18,%esp
}
  802181:	c9                   	leave  
  802182:	c3                   	ret    

00802183 <sys_waitSemaphore>:

void
sys_waitSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  802183:	55                   	push   %ebp
  802184:	89 e5                	mov    %esp,%ebp
	syscall(SYS_wait_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  802186:	8b 55 0c             	mov    0xc(%ebp),%edx
  802189:	8b 45 08             	mov    0x8(%ebp),%eax
  80218c:	6a 00                	push   $0x0
  80218e:	6a 00                	push   $0x0
  802190:	6a 00                	push   $0x0
  802192:	52                   	push   %edx
  802193:	50                   	push   %eax
  802194:	6a 18                	push   $0x18
  802196:	e8 62 fd ff ff       	call   801efd <syscall>
  80219b:	83 c4 18             	add    $0x18,%esp
}
  80219e:	90                   	nop
  80219f:	c9                   	leave  
  8021a0:	c3                   	ret    

008021a1 <sys_signalSemaphore>:

void
sys_signalSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  8021a1:	55                   	push   %ebp
  8021a2:	89 e5                	mov    %esp,%ebp
	syscall(SYS_signal_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  8021a4:	8b 55 0c             	mov    0xc(%ebp),%edx
  8021a7:	8b 45 08             	mov    0x8(%ebp),%eax
  8021aa:	6a 00                	push   $0x0
  8021ac:	6a 00                	push   $0x0
  8021ae:	6a 00                	push   $0x0
  8021b0:	52                   	push   %edx
  8021b1:	50                   	push   %eax
  8021b2:	6a 19                	push   $0x19
  8021b4:	e8 44 fd ff ff       	call   801efd <syscall>
  8021b9:	83 c4 18             	add    $0x18,%esp
}
  8021bc:	90                   	nop
  8021bd:	c9                   	leave  
  8021be:	c3                   	ret    

008021bf <sys_createSharedObject>:

int
sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  8021bf:	55                   	push   %ebp
  8021c0:	89 e5                	mov    %esp,%ebp
  8021c2:	83 ec 04             	sub    $0x4,%esp
  8021c5:	8b 45 10             	mov    0x10(%ebp),%eax
  8021c8:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  8021cb:	8b 4d 14             	mov    0x14(%ebp),%ecx
  8021ce:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  8021d2:	8b 45 08             	mov    0x8(%ebp),%eax
  8021d5:	6a 00                	push   $0x0
  8021d7:	51                   	push   %ecx
  8021d8:	52                   	push   %edx
  8021d9:	ff 75 0c             	pushl  0xc(%ebp)
  8021dc:	50                   	push   %eax
  8021dd:	6a 1b                	push   $0x1b
  8021df:	e8 19 fd ff ff       	call   801efd <syscall>
  8021e4:	83 c4 18             	add    $0x18,%esp
}
  8021e7:	c9                   	leave  
  8021e8:	c3                   	ret    

008021e9 <sys_getSizeOfSharedObject>:

//2017:
int
sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  8021e9:	55                   	push   %ebp
  8021ea:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  8021ec:	8b 55 0c             	mov    0xc(%ebp),%edx
  8021ef:	8b 45 08             	mov    0x8(%ebp),%eax
  8021f2:	6a 00                	push   $0x0
  8021f4:	6a 00                	push   $0x0
  8021f6:	6a 00                	push   $0x0
  8021f8:	52                   	push   %edx
  8021f9:	50                   	push   %eax
  8021fa:	6a 1c                	push   $0x1c
  8021fc:	e8 fc fc ff ff       	call   801efd <syscall>
  802201:	83 c4 18             	add    $0x18,%esp
}
  802204:	c9                   	leave  
  802205:	c3                   	ret    

00802206 <sys_getSharedObject>:
//==========

int
sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  802206:	55                   	push   %ebp
  802207:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  802209:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80220c:	8b 55 0c             	mov    0xc(%ebp),%edx
  80220f:	8b 45 08             	mov    0x8(%ebp),%eax
  802212:	6a 00                	push   $0x0
  802214:	6a 00                	push   $0x0
  802216:	51                   	push   %ecx
  802217:	52                   	push   %edx
  802218:	50                   	push   %eax
  802219:	6a 1d                	push   $0x1d
  80221b:	e8 dd fc ff ff       	call   801efd <syscall>
  802220:	83 c4 18             	add    $0x18,%esp
}
  802223:	c9                   	leave  
  802224:	c3                   	ret    

00802225 <sys_freeSharedObject>:

int
sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  802225:	55                   	push   %ebp
  802226:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  802228:	8b 55 0c             	mov    0xc(%ebp),%edx
  80222b:	8b 45 08             	mov    0x8(%ebp),%eax
  80222e:	6a 00                	push   $0x0
  802230:	6a 00                	push   $0x0
  802232:	6a 00                	push   $0x0
  802234:	52                   	push   %edx
  802235:	50                   	push   %eax
  802236:	6a 1e                	push   $0x1e
  802238:	e8 c0 fc ff ff       	call   801efd <syscall>
  80223d:	83 c4 18             	add    $0x18,%esp
}
  802240:	c9                   	leave  
  802241:	c3                   	ret    

00802242 <sys_getMaxShares>:

uint32 	sys_getMaxShares()
{
  802242:	55                   	push   %ebp
  802243:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_max_shares,0, 0, 0, 0, 0);
  802245:	6a 00                	push   $0x0
  802247:	6a 00                	push   $0x0
  802249:	6a 00                	push   $0x0
  80224b:	6a 00                	push   $0x0
  80224d:	6a 00                	push   $0x0
  80224f:	6a 1f                	push   $0x1f
  802251:	e8 a7 fc ff ff       	call   801efd <syscall>
  802256:	83 c4 18             	add    $0x18,%esp
}
  802259:	c9                   	leave  
  80225a:	c3                   	ret    

0080225b <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  80225b:	55                   	push   %ebp
  80225c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  80225e:	8b 45 08             	mov    0x8(%ebp),%eax
  802261:	6a 00                	push   $0x0
  802263:	ff 75 14             	pushl  0x14(%ebp)
  802266:	ff 75 10             	pushl  0x10(%ebp)
  802269:	ff 75 0c             	pushl  0xc(%ebp)
  80226c:	50                   	push   %eax
  80226d:	6a 20                	push   $0x20
  80226f:	e8 89 fc ff ff       	call   801efd <syscall>
  802274:	83 c4 18             	add    $0x18,%esp
}
  802277:	c9                   	leave  
  802278:	c3                   	ret    

00802279 <sys_run_env>:

void
sys_run_env(int32 envId)
{
  802279:	55                   	push   %ebp
  80227a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  80227c:	8b 45 08             	mov    0x8(%ebp),%eax
  80227f:	6a 00                	push   $0x0
  802281:	6a 00                	push   $0x0
  802283:	6a 00                	push   $0x0
  802285:	6a 00                	push   $0x0
  802287:	50                   	push   %eax
  802288:	6a 21                	push   $0x21
  80228a:	e8 6e fc ff ff       	call   801efd <syscall>
  80228f:	83 c4 18             	add    $0x18,%esp
}
  802292:	90                   	nop
  802293:	c9                   	leave  
  802294:	c3                   	ret    

00802295 <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  802295:	55                   	push   %ebp
  802296:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  802298:	8b 45 08             	mov    0x8(%ebp),%eax
  80229b:	6a 00                	push   $0x0
  80229d:	6a 00                	push   $0x0
  80229f:	6a 00                	push   $0x0
  8022a1:	6a 00                	push   $0x0
  8022a3:	50                   	push   %eax
  8022a4:	6a 22                	push   $0x22
  8022a6:	e8 52 fc ff ff       	call   801efd <syscall>
  8022ab:	83 c4 18             	add    $0x18,%esp
}
  8022ae:	c9                   	leave  
  8022af:	c3                   	ret    

008022b0 <sys_getenvid>:

int32 sys_getenvid(void)
{
  8022b0:	55                   	push   %ebp
  8022b1:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  8022b3:	6a 00                	push   $0x0
  8022b5:	6a 00                	push   $0x0
  8022b7:	6a 00                	push   $0x0
  8022b9:	6a 00                	push   $0x0
  8022bb:	6a 00                	push   $0x0
  8022bd:	6a 02                	push   $0x2
  8022bf:	e8 39 fc ff ff       	call   801efd <syscall>
  8022c4:	83 c4 18             	add    $0x18,%esp
}
  8022c7:	c9                   	leave  
  8022c8:	c3                   	ret    

008022c9 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  8022c9:	55                   	push   %ebp
  8022ca:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  8022cc:	6a 00                	push   $0x0
  8022ce:	6a 00                	push   $0x0
  8022d0:	6a 00                	push   $0x0
  8022d2:	6a 00                	push   $0x0
  8022d4:	6a 00                	push   $0x0
  8022d6:	6a 03                	push   $0x3
  8022d8:	e8 20 fc ff ff       	call   801efd <syscall>
  8022dd:	83 c4 18             	add    $0x18,%esp
}
  8022e0:	c9                   	leave  
  8022e1:	c3                   	ret    

008022e2 <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  8022e2:	55                   	push   %ebp
  8022e3:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  8022e5:	6a 00                	push   $0x0
  8022e7:	6a 00                	push   $0x0
  8022e9:	6a 00                	push   $0x0
  8022eb:	6a 00                	push   $0x0
  8022ed:	6a 00                	push   $0x0
  8022ef:	6a 04                	push   $0x4
  8022f1:	e8 07 fc ff ff       	call   801efd <syscall>
  8022f6:	83 c4 18             	add    $0x18,%esp
}
  8022f9:	c9                   	leave  
  8022fa:	c3                   	ret    

008022fb <sys_exit_env>:


void sys_exit_env(void)
{
  8022fb:	55                   	push   %ebp
  8022fc:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  8022fe:	6a 00                	push   $0x0
  802300:	6a 00                	push   $0x0
  802302:	6a 00                	push   $0x0
  802304:	6a 00                	push   $0x0
  802306:	6a 00                	push   $0x0
  802308:	6a 23                	push   $0x23
  80230a:	e8 ee fb ff ff       	call   801efd <syscall>
  80230f:	83 c4 18             	add    $0x18,%esp
}
  802312:	90                   	nop
  802313:	c9                   	leave  
  802314:	c3                   	ret    

00802315 <sys_get_virtual_time>:


struct uint64
sys_get_virtual_time()
{
  802315:	55                   	push   %ebp
  802316:	89 e5                	mov    %esp,%ebp
  802318:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  80231b:	8d 45 f8             	lea    -0x8(%ebp),%eax
  80231e:	8d 50 04             	lea    0x4(%eax),%edx
  802321:	8d 45 f8             	lea    -0x8(%ebp),%eax
  802324:	6a 00                	push   $0x0
  802326:	6a 00                	push   $0x0
  802328:	6a 00                	push   $0x0
  80232a:	52                   	push   %edx
  80232b:	50                   	push   %eax
  80232c:	6a 24                	push   $0x24
  80232e:	e8 ca fb ff ff       	call   801efd <syscall>
  802333:	83 c4 18             	add    $0x18,%esp
	return result;
  802336:	8b 4d 08             	mov    0x8(%ebp),%ecx
  802339:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80233c:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80233f:	89 01                	mov    %eax,(%ecx)
  802341:	89 51 04             	mov    %edx,0x4(%ecx)
}
  802344:	8b 45 08             	mov    0x8(%ebp),%eax
  802347:	c9                   	leave  
  802348:	c2 04 00             	ret    $0x4

0080234b <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  80234b:	55                   	push   %ebp
  80234c:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  80234e:	6a 00                	push   $0x0
  802350:	6a 00                	push   $0x0
  802352:	ff 75 10             	pushl  0x10(%ebp)
  802355:	ff 75 0c             	pushl  0xc(%ebp)
  802358:	ff 75 08             	pushl  0x8(%ebp)
  80235b:	6a 12                	push   $0x12
  80235d:	e8 9b fb ff ff       	call   801efd <syscall>
  802362:	83 c4 18             	add    $0x18,%esp
	return ;
  802365:	90                   	nop
}
  802366:	c9                   	leave  
  802367:	c3                   	ret    

00802368 <sys_rcr2>:
uint32 sys_rcr2()
{
  802368:	55                   	push   %ebp
  802369:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  80236b:	6a 00                	push   $0x0
  80236d:	6a 00                	push   $0x0
  80236f:	6a 00                	push   $0x0
  802371:	6a 00                	push   $0x0
  802373:	6a 00                	push   $0x0
  802375:	6a 25                	push   $0x25
  802377:	e8 81 fb ff ff       	call   801efd <syscall>
  80237c:	83 c4 18             	add    $0x18,%esp
}
  80237f:	c9                   	leave  
  802380:	c3                   	ret    

00802381 <sys_bypassPageFault>:
void sys_bypassPageFault(uint8 instrLength)
{
  802381:	55                   	push   %ebp
  802382:	89 e5                	mov    %esp,%ebp
  802384:	83 ec 04             	sub    $0x4,%esp
  802387:	8b 45 08             	mov    0x8(%ebp),%eax
  80238a:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  80238d:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  802391:	6a 00                	push   $0x0
  802393:	6a 00                	push   $0x0
  802395:	6a 00                	push   $0x0
  802397:	6a 00                	push   $0x0
  802399:	50                   	push   %eax
  80239a:	6a 26                	push   $0x26
  80239c:	e8 5c fb ff ff       	call   801efd <syscall>
  8023a1:	83 c4 18             	add    $0x18,%esp
	return ;
  8023a4:	90                   	nop
}
  8023a5:	c9                   	leave  
  8023a6:	c3                   	ret    

008023a7 <rsttst>:
void rsttst()
{
  8023a7:	55                   	push   %ebp
  8023a8:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  8023aa:	6a 00                	push   $0x0
  8023ac:	6a 00                	push   $0x0
  8023ae:	6a 00                	push   $0x0
  8023b0:	6a 00                	push   $0x0
  8023b2:	6a 00                	push   $0x0
  8023b4:	6a 28                	push   $0x28
  8023b6:	e8 42 fb ff ff       	call   801efd <syscall>
  8023bb:	83 c4 18             	add    $0x18,%esp
	return ;
  8023be:	90                   	nop
}
  8023bf:	c9                   	leave  
  8023c0:	c3                   	ret    

008023c1 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  8023c1:	55                   	push   %ebp
  8023c2:	89 e5                	mov    %esp,%ebp
  8023c4:	83 ec 04             	sub    $0x4,%esp
  8023c7:	8b 45 14             	mov    0x14(%ebp),%eax
  8023ca:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  8023cd:	8b 55 18             	mov    0x18(%ebp),%edx
  8023d0:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  8023d4:	52                   	push   %edx
  8023d5:	50                   	push   %eax
  8023d6:	ff 75 10             	pushl  0x10(%ebp)
  8023d9:	ff 75 0c             	pushl  0xc(%ebp)
  8023dc:	ff 75 08             	pushl  0x8(%ebp)
  8023df:	6a 27                	push   $0x27
  8023e1:	e8 17 fb ff ff       	call   801efd <syscall>
  8023e6:	83 c4 18             	add    $0x18,%esp
	return ;
  8023e9:	90                   	nop
}
  8023ea:	c9                   	leave  
  8023eb:	c3                   	ret    

008023ec <chktst>:
void chktst(uint32 n)
{
  8023ec:	55                   	push   %ebp
  8023ed:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  8023ef:	6a 00                	push   $0x0
  8023f1:	6a 00                	push   $0x0
  8023f3:	6a 00                	push   $0x0
  8023f5:	6a 00                	push   $0x0
  8023f7:	ff 75 08             	pushl  0x8(%ebp)
  8023fa:	6a 29                	push   $0x29
  8023fc:	e8 fc fa ff ff       	call   801efd <syscall>
  802401:	83 c4 18             	add    $0x18,%esp
	return ;
  802404:	90                   	nop
}
  802405:	c9                   	leave  
  802406:	c3                   	ret    

00802407 <inctst>:

void inctst()
{
  802407:	55                   	push   %ebp
  802408:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  80240a:	6a 00                	push   $0x0
  80240c:	6a 00                	push   $0x0
  80240e:	6a 00                	push   $0x0
  802410:	6a 00                	push   $0x0
  802412:	6a 00                	push   $0x0
  802414:	6a 2a                	push   $0x2a
  802416:	e8 e2 fa ff ff       	call   801efd <syscall>
  80241b:	83 c4 18             	add    $0x18,%esp
	return ;
  80241e:	90                   	nop
}
  80241f:	c9                   	leave  
  802420:	c3                   	ret    

00802421 <gettst>:
uint32 gettst()
{
  802421:	55                   	push   %ebp
  802422:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  802424:	6a 00                	push   $0x0
  802426:	6a 00                	push   $0x0
  802428:	6a 00                	push   $0x0
  80242a:	6a 00                	push   $0x0
  80242c:	6a 00                	push   $0x0
  80242e:	6a 2b                	push   $0x2b
  802430:	e8 c8 fa ff ff       	call   801efd <syscall>
  802435:	83 c4 18             	add    $0x18,%esp
}
  802438:	c9                   	leave  
  802439:	c3                   	ret    

0080243a <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  80243a:	55                   	push   %ebp
  80243b:	89 e5                	mov    %esp,%ebp
  80243d:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  802440:	6a 00                	push   $0x0
  802442:	6a 00                	push   $0x0
  802444:	6a 00                	push   $0x0
  802446:	6a 00                	push   $0x0
  802448:	6a 00                	push   $0x0
  80244a:	6a 2c                	push   $0x2c
  80244c:	e8 ac fa ff ff       	call   801efd <syscall>
  802451:	83 c4 18             	add    $0x18,%esp
  802454:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  802457:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  80245b:	75 07                	jne    802464 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  80245d:	b8 01 00 00 00       	mov    $0x1,%eax
  802462:	eb 05                	jmp    802469 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  802464:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802469:	c9                   	leave  
  80246a:	c3                   	ret    

0080246b <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  80246b:	55                   	push   %ebp
  80246c:	89 e5                	mov    %esp,%ebp
  80246e:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  802471:	6a 00                	push   $0x0
  802473:	6a 00                	push   $0x0
  802475:	6a 00                	push   $0x0
  802477:	6a 00                	push   $0x0
  802479:	6a 00                	push   $0x0
  80247b:	6a 2c                	push   $0x2c
  80247d:	e8 7b fa ff ff       	call   801efd <syscall>
  802482:	83 c4 18             	add    $0x18,%esp
  802485:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  802488:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  80248c:	75 07                	jne    802495 <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  80248e:	b8 01 00 00 00       	mov    $0x1,%eax
  802493:	eb 05                	jmp    80249a <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  802495:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80249a:	c9                   	leave  
  80249b:	c3                   	ret    

0080249c <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  80249c:	55                   	push   %ebp
  80249d:	89 e5                	mov    %esp,%ebp
  80249f:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8024a2:	6a 00                	push   $0x0
  8024a4:	6a 00                	push   $0x0
  8024a6:	6a 00                	push   $0x0
  8024a8:	6a 00                	push   $0x0
  8024aa:	6a 00                	push   $0x0
  8024ac:	6a 2c                	push   $0x2c
  8024ae:	e8 4a fa ff ff       	call   801efd <syscall>
  8024b3:	83 c4 18             	add    $0x18,%esp
  8024b6:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  8024b9:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  8024bd:	75 07                	jne    8024c6 <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  8024bf:	b8 01 00 00 00       	mov    $0x1,%eax
  8024c4:	eb 05                	jmp    8024cb <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  8024c6:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8024cb:	c9                   	leave  
  8024cc:	c3                   	ret    

008024cd <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  8024cd:	55                   	push   %ebp
  8024ce:	89 e5                	mov    %esp,%ebp
  8024d0:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8024d3:	6a 00                	push   $0x0
  8024d5:	6a 00                	push   $0x0
  8024d7:	6a 00                	push   $0x0
  8024d9:	6a 00                	push   $0x0
  8024db:	6a 00                	push   $0x0
  8024dd:	6a 2c                	push   $0x2c
  8024df:	e8 19 fa ff ff       	call   801efd <syscall>
  8024e4:	83 c4 18             	add    $0x18,%esp
  8024e7:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  8024ea:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  8024ee:	75 07                	jne    8024f7 <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  8024f0:	b8 01 00 00 00       	mov    $0x1,%eax
  8024f5:	eb 05                	jmp    8024fc <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  8024f7:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8024fc:	c9                   	leave  
  8024fd:	c3                   	ret    

008024fe <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  8024fe:	55                   	push   %ebp
  8024ff:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  802501:	6a 00                	push   $0x0
  802503:	6a 00                	push   $0x0
  802505:	6a 00                	push   $0x0
  802507:	6a 00                	push   $0x0
  802509:	ff 75 08             	pushl  0x8(%ebp)
  80250c:	6a 2d                	push   $0x2d
  80250e:	e8 ea f9 ff ff       	call   801efd <syscall>
  802513:	83 c4 18             	add    $0x18,%esp
	return ;
  802516:	90                   	nop
}
  802517:	c9                   	leave  
  802518:	c3                   	ret    

00802519 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  802519:	55                   	push   %ebp
  80251a:	89 e5                	mov    %esp,%ebp
  80251c:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  80251d:	8b 5d 14             	mov    0x14(%ebp),%ebx
  802520:	8b 4d 10             	mov    0x10(%ebp),%ecx
  802523:	8b 55 0c             	mov    0xc(%ebp),%edx
  802526:	8b 45 08             	mov    0x8(%ebp),%eax
  802529:	6a 00                	push   $0x0
  80252b:	53                   	push   %ebx
  80252c:	51                   	push   %ecx
  80252d:	52                   	push   %edx
  80252e:	50                   	push   %eax
  80252f:	6a 2e                	push   $0x2e
  802531:	e8 c7 f9 ff ff       	call   801efd <syscall>
  802536:	83 c4 18             	add    $0x18,%esp
}
  802539:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80253c:	c9                   	leave  
  80253d:	c3                   	ret    

0080253e <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  80253e:	55                   	push   %ebp
  80253f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  802541:	8b 55 0c             	mov    0xc(%ebp),%edx
  802544:	8b 45 08             	mov    0x8(%ebp),%eax
  802547:	6a 00                	push   $0x0
  802549:	6a 00                	push   $0x0
  80254b:	6a 00                	push   $0x0
  80254d:	52                   	push   %edx
  80254e:	50                   	push   %eax
  80254f:	6a 2f                	push   $0x2f
  802551:	e8 a7 f9 ff ff       	call   801efd <syscall>
  802556:	83 c4 18             	add    $0x18,%esp
}
  802559:	c9                   	leave  
  80255a:	c3                   	ret    

0080255b <print_mem_block_lists>:
//===========================
// PRINT MEM BLOCK LISTS:
//===========================

void print_mem_block_lists()
{
  80255b:	55                   	push   %ebp
  80255c:	89 e5                	mov    %esp,%ebp
  80255e:	83 ec 18             	sub    $0x18,%esp
	cprintf("\n=========================================\n");
  802561:	83 ec 0c             	sub    $0xc,%esp
  802564:	68 34 40 80 00       	push   $0x804034
  802569:	e8 d7 e4 ff ff       	call   800a45 <cprintf>
  80256e:	83 c4 10             	add    $0x10,%esp
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
  802571:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nFreeMemBlocksList:\n");
  802578:	83 ec 0c             	sub    $0xc,%esp
  80257b:	68 60 40 80 00       	push   $0x804060
  802580:	e8 c0 e4 ff ff       	call   800a45 <cprintf>
  802585:	83 c4 10             	add    $0x10,%esp
	uint8 sorted = 1 ;
  802588:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &FreeMemBlocksList)
  80258c:	a1 38 51 80 00       	mov    0x805138,%eax
  802591:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802594:	eb 56                	jmp    8025ec <print_mem_block_lists+0x91>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  802596:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80259a:	74 1c                	je     8025b8 <print_mem_block_lists+0x5d>
  80259c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80259f:	8b 50 08             	mov    0x8(%eax),%edx
  8025a2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8025a5:	8b 48 08             	mov    0x8(%eax),%ecx
  8025a8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8025ab:	8b 40 0c             	mov    0xc(%eax),%eax
  8025ae:	01 c8                	add    %ecx,%eax
  8025b0:	39 c2                	cmp    %eax,%edx
  8025b2:	73 04                	jae    8025b8 <print_mem_block_lists+0x5d>
			sorted = 0 ;
  8025b4:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  8025b8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025bb:	8b 50 08             	mov    0x8(%eax),%edx
  8025be:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025c1:	8b 40 0c             	mov    0xc(%eax),%eax
  8025c4:	01 c2                	add    %eax,%edx
  8025c6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025c9:	8b 40 08             	mov    0x8(%eax),%eax
  8025cc:	83 ec 04             	sub    $0x4,%esp
  8025cf:	52                   	push   %edx
  8025d0:	50                   	push   %eax
  8025d1:	68 75 40 80 00       	push   $0x804075
  8025d6:	e8 6a e4 ff ff       	call   800a45 <cprintf>
  8025db:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  8025de:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025e1:	89 45 f0             	mov    %eax,-0x10(%ebp)
	cprintf("\n=========================================\n");
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
	cprintf("\nFreeMemBlocksList:\n");
	uint8 sorted = 1 ;
	LIST_FOREACH(blk, &FreeMemBlocksList)
  8025e4:	a1 40 51 80 00       	mov    0x805140,%eax
  8025e9:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8025ec:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8025f0:	74 07                	je     8025f9 <print_mem_block_lists+0x9e>
  8025f2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025f5:	8b 00                	mov    (%eax),%eax
  8025f7:	eb 05                	jmp    8025fe <print_mem_block_lists+0xa3>
  8025f9:	b8 00 00 00 00       	mov    $0x0,%eax
  8025fe:	a3 40 51 80 00       	mov    %eax,0x805140
  802603:	a1 40 51 80 00       	mov    0x805140,%eax
  802608:	85 c0                	test   %eax,%eax
  80260a:	75 8a                	jne    802596 <print_mem_block_lists+0x3b>
  80260c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802610:	75 84                	jne    802596 <print_mem_block_lists+0x3b>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;
  802612:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  802616:	75 10                	jne    802628 <print_mem_block_lists+0xcd>
  802618:	83 ec 0c             	sub    $0xc,%esp
  80261b:	68 84 40 80 00       	push   $0x804084
  802620:	e8 20 e4 ff ff       	call   800a45 <cprintf>
  802625:	83 c4 10             	add    $0x10,%esp

	lastBlk = NULL ;
  802628:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nAllocMemBlocksList:\n");
  80262f:	83 ec 0c             	sub    $0xc,%esp
  802632:	68 a8 40 80 00       	push   $0x8040a8
  802637:	e8 09 e4 ff ff       	call   800a45 <cprintf>
  80263c:	83 c4 10             	add    $0x10,%esp
	sorted = 1 ;
  80263f:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &AllocMemBlocksList)
  802643:	a1 40 50 80 00       	mov    0x805040,%eax
  802648:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80264b:	eb 56                	jmp    8026a3 <print_mem_block_lists+0x148>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  80264d:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802651:	74 1c                	je     80266f <print_mem_block_lists+0x114>
  802653:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802656:	8b 50 08             	mov    0x8(%eax),%edx
  802659:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80265c:	8b 48 08             	mov    0x8(%eax),%ecx
  80265f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802662:	8b 40 0c             	mov    0xc(%eax),%eax
  802665:	01 c8                	add    %ecx,%eax
  802667:	39 c2                	cmp    %eax,%edx
  802669:	73 04                	jae    80266f <print_mem_block_lists+0x114>
			sorted = 0 ;
  80266b:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  80266f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802672:	8b 50 08             	mov    0x8(%eax),%edx
  802675:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802678:	8b 40 0c             	mov    0xc(%eax),%eax
  80267b:	01 c2                	add    %eax,%edx
  80267d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802680:	8b 40 08             	mov    0x8(%eax),%eax
  802683:	83 ec 04             	sub    $0x4,%esp
  802686:	52                   	push   %edx
  802687:	50                   	push   %eax
  802688:	68 75 40 80 00       	push   $0x804075
  80268d:	e8 b3 e3 ff ff       	call   800a45 <cprintf>
  802692:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  802695:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802698:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;

	lastBlk = NULL ;
	cprintf("\nAllocMemBlocksList:\n");
	sorted = 1 ;
	LIST_FOREACH(blk, &AllocMemBlocksList)
  80269b:	a1 48 50 80 00       	mov    0x805048,%eax
  8026a0:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8026a3:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8026a7:	74 07                	je     8026b0 <print_mem_block_lists+0x155>
  8026a9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026ac:	8b 00                	mov    (%eax),%eax
  8026ae:	eb 05                	jmp    8026b5 <print_mem_block_lists+0x15a>
  8026b0:	b8 00 00 00 00       	mov    $0x0,%eax
  8026b5:	a3 48 50 80 00       	mov    %eax,0x805048
  8026ba:	a1 48 50 80 00       	mov    0x805048,%eax
  8026bf:	85 c0                	test   %eax,%eax
  8026c1:	75 8a                	jne    80264d <print_mem_block_lists+0xf2>
  8026c3:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8026c7:	75 84                	jne    80264d <print_mem_block_lists+0xf2>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nAllocMemBlocksList is NOT SORTED!!\n") ;
  8026c9:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  8026cd:	75 10                	jne    8026df <print_mem_block_lists+0x184>
  8026cf:	83 ec 0c             	sub    $0xc,%esp
  8026d2:	68 c0 40 80 00       	push   $0x8040c0
  8026d7:	e8 69 e3 ff ff       	call   800a45 <cprintf>
  8026dc:	83 c4 10             	add    $0x10,%esp
	cprintf("\n=========================================\n");
  8026df:	83 ec 0c             	sub    $0xc,%esp
  8026e2:	68 34 40 80 00       	push   $0x804034
  8026e7:	e8 59 e3 ff ff       	call   800a45 <cprintf>
  8026ec:	83 c4 10             	add    $0x10,%esp

}
  8026ef:	90                   	nop
  8026f0:	c9                   	leave  
  8026f1:	c3                   	ret    

008026f2 <initialize_MemBlocksList>:

//===============================
// [1] INITIALIZE AVAILABLE LIST:
//===============================
void initialize_MemBlocksList(uint32 numOfBlocks)
{
  8026f2:	55                   	push   %ebp
  8026f3:	89 e5                	mov    %esp,%ebp
  8026f5:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] initialize_MemBlocksList
	// Write your code here, remove the panic and write your code
	//panic("initialize_MemBlocksList() is not implemented yet...!!");
	uint32 n = numOfBlocks;
  8026f8:	8b 45 08             	mov    0x8(%ebp),%eax
  8026fb:	89 45 f0             	mov    %eax,-0x10(%ebp)

	LIST_INIT(&AvailableMemBlocksList);
  8026fe:	c7 05 48 51 80 00 00 	movl   $0x0,0x805148
  802705:	00 00 00 
  802708:	c7 05 4c 51 80 00 00 	movl   $0x0,0x80514c
  80270f:	00 00 00 
  802712:	c7 05 54 51 80 00 00 	movl   $0x0,0x805154
  802719:	00 00 00 
	for(int i = 0; i<n;i++)
  80271c:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  802723:	e9 9e 00 00 00       	jmp    8027c6 <initialize_MemBlocksList+0xd4>
	{
		LIST_INSERT_HEAD(&AvailableMemBlocksList, &(MemBlockNodes[i]));
  802728:	a1 50 50 80 00       	mov    0x805050,%eax
  80272d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802730:	c1 e2 04             	shl    $0x4,%edx
  802733:	01 d0                	add    %edx,%eax
  802735:	85 c0                	test   %eax,%eax
  802737:	75 14                	jne    80274d <initialize_MemBlocksList+0x5b>
  802739:	83 ec 04             	sub    $0x4,%esp
  80273c:	68 e8 40 80 00       	push   $0x8040e8
  802741:	6a 47                	push   $0x47
  802743:	68 0b 41 80 00       	push   $0x80410b
  802748:	e8 44 e0 ff ff       	call   800791 <_panic>
  80274d:	a1 50 50 80 00       	mov    0x805050,%eax
  802752:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802755:	c1 e2 04             	shl    $0x4,%edx
  802758:	01 d0                	add    %edx,%eax
  80275a:	8b 15 48 51 80 00    	mov    0x805148,%edx
  802760:	89 10                	mov    %edx,(%eax)
  802762:	8b 00                	mov    (%eax),%eax
  802764:	85 c0                	test   %eax,%eax
  802766:	74 18                	je     802780 <initialize_MemBlocksList+0x8e>
  802768:	a1 48 51 80 00       	mov    0x805148,%eax
  80276d:	8b 15 50 50 80 00    	mov    0x805050,%edx
  802773:	8b 4d f4             	mov    -0xc(%ebp),%ecx
  802776:	c1 e1 04             	shl    $0x4,%ecx
  802779:	01 ca                	add    %ecx,%edx
  80277b:	89 50 04             	mov    %edx,0x4(%eax)
  80277e:	eb 12                	jmp    802792 <initialize_MemBlocksList+0xa0>
  802780:	a1 50 50 80 00       	mov    0x805050,%eax
  802785:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802788:	c1 e2 04             	shl    $0x4,%edx
  80278b:	01 d0                	add    %edx,%eax
  80278d:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802792:	a1 50 50 80 00       	mov    0x805050,%eax
  802797:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80279a:	c1 e2 04             	shl    $0x4,%edx
  80279d:	01 d0                	add    %edx,%eax
  80279f:	a3 48 51 80 00       	mov    %eax,0x805148
  8027a4:	a1 50 50 80 00       	mov    0x805050,%eax
  8027a9:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8027ac:	c1 e2 04             	shl    $0x4,%edx
  8027af:	01 d0                	add    %edx,%eax
  8027b1:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8027b8:	a1 54 51 80 00       	mov    0x805154,%eax
  8027bd:	40                   	inc    %eax
  8027be:	a3 54 51 80 00       	mov    %eax,0x805154
	// Write your code here, remove the panic and write your code
	//panic("initialize_MemBlocksList() is not implemented yet...!!");
	uint32 n = numOfBlocks;

	LIST_INIT(&AvailableMemBlocksList);
	for(int i = 0; i<n;i++)
  8027c3:	ff 45 f4             	incl   -0xc(%ebp)
  8027c6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027c9:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8027cc:	0f 82 56 ff ff ff    	jb     802728 <initialize_MemBlocksList+0x36>
	{
		LIST_INSERT_HEAD(&AvailableMemBlocksList, &(MemBlockNodes[i]));
	}
}
  8027d2:	90                   	nop
  8027d3:	c9                   	leave  
  8027d4:	c3                   	ret    

008027d5 <find_block>:

//===============================
// [2] FIND BLOCK:
//===============================
struct MemBlock *find_block(struct MemBlock_List *blockList, uint32 va)
{
  8027d5:	55                   	push   %ebp
  8027d6:	89 e5                	mov    %esp,%ebp
  8027d8:	83 ec 10             	sub    $0x10,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] find_block
	// Write your code here, remove the panic and write your code
	//panic("find_block() is not implemented yet...!!");
	uint32 virAddress = va;
  8027db:	8b 45 0c             	mov    0xc(%ebp),%eax
  8027de:	89 45 f4             	mov    %eax,-0xc(%ebp)
	struct MemBlock* blk;
	int found = 0;
  8027e1:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	LIST_FOREACH(blk, &(AllocMemBlocksList))
  8027e8:	a1 40 50 80 00       	mov    0x805040,%eax
  8027ed:	89 45 fc             	mov    %eax,-0x4(%ebp)
  8027f0:	eb 23                	jmp    802815 <find_block+0x40>
	{
		if(blk->sva == virAddress)
  8027f2:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8027f5:	8b 40 08             	mov    0x8(%eax),%eax
  8027f8:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  8027fb:	75 09                	jne    802806 <find_block+0x31>
		{
			found = 1;
  8027fd:	c7 45 f8 01 00 00 00 	movl   $0x1,-0x8(%ebp)
			break;
  802804:	eb 35                	jmp    80283b <find_block+0x66>
		}
		else
		{
			found = 0;
  802806:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	//panic("find_block() is not implemented yet...!!");
	uint32 virAddress = va;
	struct MemBlock* blk;
	int found = 0;

	LIST_FOREACH(blk, &(AllocMemBlocksList))
  80280d:	a1 48 50 80 00       	mov    0x805048,%eax
  802812:	89 45 fc             	mov    %eax,-0x4(%ebp)
  802815:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  802819:	74 07                	je     802822 <find_block+0x4d>
  80281b:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80281e:	8b 00                	mov    (%eax),%eax
  802820:	eb 05                	jmp    802827 <find_block+0x52>
  802822:	b8 00 00 00 00       	mov    $0x0,%eax
  802827:	a3 48 50 80 00       	mov    %eax,0x805048
  80282c:	a1 48 50 80 00       	mov    0x805048,%eax
  802831:	85 c0                	test   %eax,%eax
  802833:	75 bd                	jne    8027f2 <find_block+0x1d>
  802835:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  802839:	75 b7                	jne    8027f2 <find_block+0x1d>
		{
			found = 0;
			continue;
		}
	}
	if(found == 1)
  80283b:	83 7d f8 01          	cmpl   $0x1,-0x8(%ebp)
  80283f:	75 05                	jne    802846 <find_block+0x71>
	{
		return blk;
  802841:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802844:	eb 05                	jmp    80284b <find_block+0x76>
	}
	else
	{
		return NULL;
  802846:	b8 00 00 00 00       	mov    $0x0,%eax
	}
}
  80284b:	c9                   	leave  
  80284c:	c3                   	ret    

0080284d <insert_sorted_allocList>:

//=========================================
// [3] INSERT BLOCK IN ALLOC LIST [SORTED]:
//=========================================
void insert_sorted_allocList(struct MemBlock *blockToInsert)
{
  80284d:	55                   	push   %ebp
  80284e:	89 e5                	mov    %esp,%ebp
  802850:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] insert_sorted_allocList
	// Write your code here, remove the panic and write your code
	//panic("insert_sorted_allocList() is not implemented yet...!!");
	struct MemBlock* blk;
	struct MemBlock* newblk = blockToInsert;
  802853:	8b 45 08             	mov    0x8(%ebp),%eax
  802856:	89 45 f0             	mov    %eax,-0x10(%ebp)

	if((LIST_EMPTY(&AllocMemBlocksList)) || (newblk->sva < LIST_FIRST(&AllocMemBlocksList)->sva))
  802859:	a1 40 50 80 00       	mov    0x805040,%eax
  80285e:	85 c0                	test   %eax,%eax
  802860:	74 12                	je     802874 <insert_sorted_allocList+0x27>
  802862:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802865:	8b 50 08             	mov    0x8(%eax),%edx
  802868:	a1 40 50 80 00       	mov    0x805040,%eax
  80286d:	8b 40 08             	mov    0x8(%eax),%eax
  802870:	39 c2                	cmp    %eax,%edx
  802872:	73 65                	jae    8028d9 <insert_sorted_allocList+0x8c>
	{
		LIST_INSERT_HEAD(&(AllocMemBlocksList), newblk);
  802874:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802878:	75 14                	jne    80288e <insert_sorted_allocList+0x41>
  80287a:	83 ec 04             	sub    $0x4,%esp
  80287d:	68 e8 40 80 00       	push   $0x8040e8
  802882:	6a 7b                	push   $0x7b
  802884:	68 0b 41 80 00       	push   $0x80410b
  802889:	e8 03 df ff ff       	call   800791 <_panic>
  80288e:	8b 15 40 50 80 00    	mov    0x805040,%edx
  802894:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802897:	89 10                	mov    %edx,(%eax)
  802899:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80289c:	8b 00                	mov    (%eax),%eax
  80289e:	85 c0                	test   %eax,%eax
  8028a0:	74 0d                	je     8028af <insert_sorted_allocList+0x62>
  8028a2:	a1 40 50 80 00       	mov    0x805040,%eax
  8028a7:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8028aa:	89 50 04             	mov    %edx,0x4(%eax)
  8028ad:	eb 08                	jmp    8028b7 <insert_sorted_allocList+0x6a>
  8028af:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8028b2:	a3 44 50 80 00       	mov    %eax,0x805044
  8028b7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8028ba:	a3 40 50 80 00       	mov    %eax,0x805040
  8028bf:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8028c2:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8028c9:	a1 4c 50 80 00       	mov    0x80504c,%eax
  8028ce:	40                   	inc    %eax
  8028cf:	a3 4c 50 80 00       	mov    %eax,0x80504c
  8028d4:	e9 5f 01 00 00       	jmp    802a38 <insert_sorted_allocList+0x1eb>
	}
	else if(newblk->sva > LIST_LAST(&AllocMemBlocksList)->sva)
  8028d9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8028dc:	8b 50 08             	mov    0x8(%eax),%edx
  8028df:	a1 44 50 80 00       	mov    0x805044,%eax
  8028e4:	8b 40 08             	mov    0x8(%eax),%eax
  8028e7:	39 c2                	cmp    %eax,%edx
  8028e9:	76 65                	jbe    802950 <insert_sorted_allocList+0x103>
	{
		LIST_INSERT_TAIL(&AllocMemBlocksList, newblk);
  8028eb:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8028ef:	75 14                	jne    802905 <insert_sorted_allocList+0xb8>
  8028f1:	83 ec 04             	sub    $0x4,%esp
  8028f4:	68 24 41 80 00       	push   $0x804124
  8028f9:	6a 7f                	push   $0x7f
  8028fb:	68 0b 41 80 00       	push   $0x80410b
  802900:	e8 8c de ff ff       	call   800791 <_panic>
  802905:	8b 15 44 50 80 00    	mov    0x805044,%edx
  80290b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80290e:	89 50 04             	mov    %edx,0x4(%eax)
  802911:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802914:	8b 40 04             	mov    0x4(%eax),%eax
  802917:	85 c0                	test   %eax,%eax
  802919:	74 0c                	je     802927 <insert_sorted_allocList+0xda>
  80291b:	a1 44 50 80 00       	mov    0x805044,%eax
  802920:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802923:	89 10                	mov    %edx,(%eax)
  802925:	eb 08                	jmp    80292f <insert_sorted_allocList+0xe2>
  802927:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80292a:	a3 40 50 80 00       	mov    %eax,0x805040
  80292f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802932:	a3 44 50 80 00       	mov    %eax,0x805044
  802937:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80293a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802940:	a1 4c 50 80 00       	mov    0x80504c,%eax
  802945:	40                   	inc    %eax
  802946:	a3 4c 50 80 00       	mov    %eax,0x80504c
				LIST_INSERT_AFTER(&AllocMemBlocksList, blk, newblk);
				break;
			}
		}
	}
}
  80294b:	e9 e8 00 00 00       	jmp    802a38 <insert_sorted_allocList+0x1eb>
	{
		LIST_INSERT_TAIL(&AllocMemBlocksList, newblk);
	}
	else
	{
		LIST_FOREACH(blk, &AllocMemBlocksList)
  802950:	a1 40 50 80 00       	mov    0x805040,%eax
  802955:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802958:	e9 ab 00 00 00       	jmp    802a08 <insert_sorted_allocList+0x1bb>
		{
			if(blk->prev_next_info.le_next != NULL && newblk->sva > blk->sva  && newblk->sva < blk->prev_next_info.le_next->sva)
  80295d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802960:	8b 00                	mov    (%eax),%eax
  802962:	85 c0                	test   %eax,%eax
  802964:	0f 84 96 00 00 00    	je     802a00 <insert_sorted_allocList+0x1b3>
  80296a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80296d:	8b 50 08             	mov    0x8(%eax),%edx
  802970:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802973:	8b 40 08             	mov    0x8(%eax),%eax
  802976:	39 c2                	cmp    %eax,%edx
  802978:	0f 86 82 00 00 00    	jbe    802a00 <insert_sorted_allocList+0x1b3>
  80297e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802981:	8b 50 08             	mov    0x8(%eax),%edx
  802984:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802987:	8b 00                	mov    (%eax),%eax
  802989:	8b 40 08             	mov    0x8(%eax),%eax
  80298c:	39 c2                	cmp    %eax,%edx
  80298e:	73 70                	jae    802a00 <insert_sorted_allocList+0x1b3>
			{
				LIST_INSERT_AFTER(&AllocMemBlocksList, blk, newblk);
  802990:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802994:	74 06                	je     80299c <insert_sorted_allocList+0x14f>
  802996:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80299a:	75 17                	jne    8029b3 <insert_sorted_allocList+0x166>
  80299c:	83 ec 04             	sub    $0x4,%esp
  80299f:	68 48 41 80 00       	push   $0x804148
  8029a4:	68 87 00 00 00       	push   $0x87
  8029a9:	68 0b 41 80 00       	push   $0x80410b
  8029ae:	e8 de dd ff ff       	call   800791 <_panic>
  8029b3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029b6:	8b 10                	mov    (%eax),%edx
  8029b8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8029bb:	89 10                	mov    %edx,(%eax)
  8029bd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8029c0:	8b 00                	mov    (%eax),%eax
  8029c2:	85 c0                	test   %eax,%eax
  8029c4:	74 0b                	je     8029d1 <insert_sorted_allocList+0x184>
  8029c6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029c9:	8b 00                	mov    (%eax),%eax
  8029cb:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8029ce:	89 50 04             	mov    %edx,0x4(%eax)
  8029d1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029d4:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8029d7:	89 10                	mov    %edx,(%eax)
  8029d9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8029dc:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8029df:	89 50 04             	mov    %edx,0x4(%eax)
  8029e2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8029e5:	8b 00                	mov    (%eax),%eax
  8029e7:	85 c0                	test   %eax,%eax
  8029e9:	75 08                	jne    8029f3 <insert_sorted_allocList+0x1a6>
  8029eb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8029ee:	a3 44 50 80 00       	mov    %eax,0x805044
  8029f3:	a1 4c 50 80 00       	mov    0x80504c,%eax
  8029f8:	40                   	inc    %eax
  8029f9:	a3 4c 50 80 00       	mov    %eax,0x80504c
				break;
  8029fe:	eb 38                	jmp    802a38 <insert_sorted_allocList+0x1eb>
	{
		LIST_INSERT_TAIL(&AllocMemBlocksList, newblk);
	}
	else
	{
		LIST_FOREACH(blk, &AllocMemBlocksList)
  802a00:	a1 48 50 80 00       	mov    0x805048,%eax
  802a05:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802a08:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802a0c:	74 07                	je     802a15 <insert_sorted_allocList+0x1c8>
  802a0e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a11:	8b 00                	mov    (%eax),%eax
  802a13:	eb 05                	jmp    802a1a <insert_sorted_allocList+0x1cd>
  802a15:	b8 00 00 00 00       	mov    $0x0,%eax
  802a1a:	a3 48 50 80 00       	mov    %eax,0x805048
  802a1f:	a1 48 50 80 00       	mov    0x805048,%eax
  802a24:	85 c0                	test   %eax,%eax
  802a26:	0f 85 31 ff ff ff    	jne    80295d <insert_sorted_allocList+0x110>
  802a2c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802a30:	0f 85 27 ff ff ff    	jne    80295d <insert_sorted_allocList+0x110>
				LIST_INSERT_AFTER(&AllocMemBlocksList, blk, newblk);
				break;
			}
		}
	}
}
  802a36:	eb 00                	jmp    802a38 <insert_sorted_allocList+0x1eb>
  802a38:	90                   	nop
  802a39:	c9                   	leave  
  802a3a:	c3                   	ret    

00802a3b <alloc_block_FF>:

//=========================================
// [4] ALLOCATE BLOCK BY FIRST FIT:
//=========================================
struct MemBlock *alloc_block_FF(uint32 size)
{
  802a3b:	55                   	push   %ebp
  802a3c:	89 e5                	mov    %esp,%ebp
  802a3e:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_FF
	// Write your code here, remove the panic and write your code
	//panic("alloc_block_FF() is not implemented yet...!!");
	uint32 versize = size;
  802a41:	8b 45 08             	mov    0x8(%ebp),%eax
  802a44:	89 45 f0             	mov    %eax,-0x10(%ebp)
	struct MemBlock* blk;
	struct MemBlock* newblk = LIST_FIRST(&AvailableMemBlocksList);
  802a47:	a1 48 51 80 00       	mov    0x805148,%eax
  802a4c:	89 45 ec             	mov    %eax,-0x14(%ebp)

	LIST_FOREACH(blk,&FreeMemBlocksList)
  802a4f:	a1 38 51 80 00       	mov    0x805138,%eax
  802a54:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802a57:	e9 77 01 00 00       	jmp    802bd3 <alloc_block_FF+0x198>
	{
		if(blk->size == versize)
  802a5c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a5f:	8b 40 0c             	mov    0xc(%eax),%eax
  802a62:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  802a65:	0f 85 8a 00 00 00    	jne    802af5 <alloc_block_FF+0xba>
		{
			LIST_REMOVE(&FreeMemBlocksList,blk);
  802a6b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802a6f:	75 17                	jne    802a88 <alloc_block_FF+0x4d>
  802a71:	83 ec 04             	sub    $0x4,%esp
  802a74:	68 7c 41 80 00       	push   $0x80417c
  802a79:	68 9e 00 00 00       	push   $0x9e
  802a7e:	68 0b 41 80 00       	push   $0x80410b
  802a83:	e8 09 dd ff ff       	call   800791 <_panic>
  802a88:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a8b:	8b 00                	mov    (%eax),%eax
  802a8d:	85 c0                	test   %eax,%eax
  802a8f:	74 10                	je     802aa1 <alloc_block_FF+0x66>
  802a91:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a94:	8b 00                	mov    (%eax),%eax
  802a96:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802a99:	8b 52 04             	mov    0x4(%edx),%edx
  802a9c:	89 50 04             	mov    %edx,0x4(%eax)
  802a9f:	eb 0b                	jmp    802aac <alloc_block_FF+0x71>
  802aa1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802aa4:	8b 40 04             	mov    0x4(%eax),%eax
  802aa7:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802aac:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802aaf:	8b 40 04             	mov    0x4(%eax),%eax
  802ab2:	85 c0                	test   %eax,%eax
  802ab4:	74 0f                	je     802ac5 <alloc_block_FF+0x8a>
  802ab6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ab9:	8b 40 04             	mov    0x4(%eax),%eax
  802abc:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802abf:	8b 12                	mov    (%edx),%edx
  802ac1:	89 10                	mov    %edx,(%eax)
  802ac3:	eb 0a                	jmp    802acf <alloc_block_FF+0x94>
  802ac5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ac8:	8b 00                	mov    (%eax),%eax
  802aca:	a3 38 51 80 00       	mov    %eax,0x805138
  802acf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ad2:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802ad8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802adb:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802ae2:	a1 44 51 80 00       	mov    0x805144,%eax
  802ae7:	48                   	dec    %eax
  802ae8:	a3 44 51 80 00       	mov    %eax,0x805144
			return blk;
  802aed:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802af0:	e9 11 01 00 00       	jmp    802c06 <alloc_block_FF+0x1cb>
		}
		else if(blk->size > versize)
  802af5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802af8:	8b 40 0c             	mov    0xc(%eax),%eax
  802afb:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  802afe:	0f 86 c7 00 00 00    	jbe    802bcb <alloc_block_FF+0x190>
		{
			LIST_REMOVE(&AvailableMemBlocksList,newblk);
  802b04:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802b08:	75 17                	jne    802b21 <alloc_block_FF+0xe6>
  802b0a:	83 ec 04             	sub    $0x4,%esp
  802b0d:	68 7c 41 80 00       	push   $0x80417c
  802b12:	68 a3 00 00 00       	push   $0xa3
  802b17:	68 0b 41 80 00       	push   $0x80410b
  802b1c:	e8 70 dc ff ff       	call   800791 <_panic>
  802b21:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802b24:	8b 00                	mov    (%eax),%eax
  802b26:	85 c0                	test   %eax,%eax
  802b28:	74 10                	je     802b3a <alloc_block_FF+0xff>
  802b2a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802b2d:	8b 00                	mov    (%eax),%eax
  802b2f:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802b32:	8b 52 04             	mov    0x4(%edx),%edx
  802b35:	89 50 04             	mov    %edx,0x4(%eax)
  802b38:	eb 0b                	jmp    802b45 <alloc_block_FF+0x10a>
  802b3a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802b3d:	8b 40 04             	mov    0x4(%eax),%eax
  802b40:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802b45:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802b48:	8b 40 04             	mov    0x4(%eax),%eax
  802b4b:	85 c0                	test   %eax,%eax
  802b4d:	74 0f                	je     802b5e <alloc_block_FF+0x123>
  802b4f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802b52:	8b 40 04             	mov    0x4(%eax),%eax
  802b55:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802b58:	8b 12                	mov    (%edx),%edx
  802b5a:	89 10                	mov    %edx,(%eax)
  802b5c:	eb 0a                	jmp    802b68 <alloc_block_FF+0x12d>
  802b5e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802b61:	8b 00                	mov    (%eax),%eax
  802b63:	a3 48 51 80 00       	mov    %eax,0x805148
  802b68:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802b6b:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802b71:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802b74:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802b7b:	a1 54 51 80 00       	mov    0x805154,%eax
  802b80:	48                   	dec    %eax
  802b81:	a3 54 51 80 00       	mov    %eax,0x805154
			newblk->size = versize;
  802b86:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802b89:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802b8c:	89 50 0c             	mov    %edx,0xc(%eax)
			blk->size = blk->size-versize;
  802b8f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b92:	8b 40 0c             	mov    0xc(%eax),%eax
  802b95:	2b 45 f0             	sub    -0x10(%ebp),%eax
  802b98:	89 c2                	mov    %eax,%edx
  802b9a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b9d:	89 50 0c             	mov    %edx,0xc(%eax)
			uint32 newveradd = blk->sva;
  802ba0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ba3:	8b 40 08             	mov    0x8(%eax),%eax
  802ba6:	89 45 e8             	mov    %eax,-0x18(%ebp)
			blk->sva+=newblk->size;
  802ba9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bac:	8b 50 08             	mov    0x8(%eax),%edx
  802baf:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802bb2:	8b 40 0c             	mov    0xc(%eax),%eax
  802bb5:	01 c2                	add    %eax,%edx
  802bb7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bba:	89 50 08             	mov    %edx,0x8(%eax)
			newblk->sva = newveradd;
  802bbd:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802bc0:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802bc3:	89 50 08             	mov    %edx,0x8(%eax)
			return newblk;
  802bc6:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802bc9:	eb 3b                	jmp    802c06 <alloc_block_FF+0x1cb>
	//panic("alloc_block_FF() is not implemented yet...!!");
	uint32 versize = size;
	struct MemBlock* blk;
	struct MemBlock* newblk = LIST_FIRST(&AvailableMemBlocksList);

	LIST_FOREACH(blk,&FreeMemBlocksList)
  802bcb:	a1 40 51 80 00       	mov    0x805140,%eax
  802bd0:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802bd3:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802bd7:	74 07                	je     802be0 <alloc_block_FF+0x1a5>
  802bd9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bdc:	8b 00                	mov    (%eax),%eax
  802bde:	eb 05                	jmp    802be5 <alloc_block_FF+0x1aa>
  802be0:	b8 00 00 00 00       	mov    $0x0,%eax
  802be5:	a3 40 51 80 00       	mov    %eax,0x805140
  802bea:	a1 40 51 80 00       	mov    0x805140,%eax
  802bef:	85 c0                	test   %eax,%eax
  802bf1:	0f 85 65 fe ff ff    	jne    802a5c <alloc_block_FF+0x21>
  802bf7:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802bfb:	0f 85 5b fe ff ff    	jne    802a5c <alloc_block_FF+0x21>
			blk->sva+=newblk->size;
			newblk->sva = newveradd;
			return newblk;
		}
	}
	return NULL;
  802c01:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802c06:	c9                   	leave  
  802c07:	c3                   	ret    

00802c08 <alloc_block_BF>:

//=========================================
// [5] ALLOCATE BLOCK BY BEST FIT:
//=========================================
struct MemBlock *alloc_block_BF(uint32 size)
{
  802c08:	55                   	push   %ebp
  802c09:	89 e5                	mov    %esp,%ebp
  802c0b:	83 ec 28             	sub    $0x28,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_BF
	// Write your code here, remove the panic and write your code
	//panic("alloc_block_BF() is not implemented yet...!!");
	uint32 versize=size;
  802c0e:	8b 45 08             	mov    0x8(%ebp),%eax
  802c11:	89 45 e8             	mov    %eax,-0x18(%ebp)
	struct MemBlock* blk;
	struct MemBlock* newblk=LIST_FIRST(&AvailableMemBlocksList);
  802c14:	a1 48 51 80 00       	mov    0x805148,%eax
  802c19:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	uint32 newveradd;
	uint32 newsize;
	int size_free = LIST_SIZE(&FreeMemBlocksList);
  802c1c:	a1 44 51 80 00       	mov    0x805144,%eax
  802c21:	89 45 e0             	mov    %eax,-0x20(%ebp)

	LIST_FOREACH(blk, &FreeMemBlocksList)
  802c24:	a1 38 51 80 00       	mov    0x805138,%eax
  802c29:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802c2c:	e9 a1 00 00 00       	jmp    802cd2 <alloc_block_BF+0xca>
	{
		if(blk->size == versize)
  802c31:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c34:	8b 40 0c             	mov    0xc(%eax),%eax
  802c37:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  802c3a:	0f 85 8a 00 00 00    	jne    802cca <alloc_block_BF+0xc2>
		{
			LIST_REMOVE(&FreeMemBlocksList, blk);
  802c40:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802c44:	75 17                	jne    802c5d <alloc_block_BF+0x55>
  802c46:	83 ec 04             	sub    $0x4,%esp
  802c49:	68 7c 41 80 00       	push   $0x80417c
  802c4e:	68 c2 00 00 00       	push   $0xc2
  802c53:	68 0b 41 80 00       	push   $0x80410b
  802c58:	e8 34 db ff ff       	call   800791 <_panic>
  802c5d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c60:	8b 00                	mov    (%eax),%eax
  802c62:	85 c0                	test   %eax,%eax
  802c64:	74 10                	je     802c76 <alloc_block_BF+0x6e>
  802c66:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c69:	8b 00                	mov    (%eax),%eax
  802c6b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802c6e:	8b 52 04             	mov    0x4(%edx),%edx
  802c71:	89 50 04             	mov    %edx,0x4(%eax)
  802c74:	eb 0b                	jmp    802c81 <alloc_block_BF+0x79>
  802c76:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c79:	8b 40 04             	mov    0x4(%eax),%eax
  802c7c:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802c81:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c84:	8b 40 04             	mov    0x4(%eax),%eax
  802c87:	85 c0                	test   %eax,%eax
  802c89:	74 0f                	je     802c9a <alloc_block_BF+0x92>
  802c8b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c8e:	8b 40 04             	mov    0x4(%eax),%eax
  802c91:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802c94:	8b 12                	mov    (%edx),%edx
  802c96:	89 10                	mov    %edx,(%eax)
  802c98:	eb 0a                	jmp    802ca4 <alloc_block_BF+0x9c>
  802c9a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c9d:	8b 00                	mov    (%eax),%eax
  802c9f:	a3 38 51 80 00       	mov    %eax,0x805138
  802ca4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ca7:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802cad:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cb0:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802cb7:	a1 44 51 80 00       	mov    0x805144,%eax
  802cbc:	48                   	dec    %eax
  802cbd:	a3 44 51 80 00       	mov    %eax,0x805144
			return blk;
  802cc2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cc5:	e9 11 02 00 00       	jmp    802edb <alloc_block_BF+0x2d3>
	struct MemBlock* newblk=LIST_FIRST(&AvailableMemBlocksList);
	uint32 newveradd;
	uint32 newsize;
	int size_free = LIST_SIZE(&FreeMemBlocksList);

	LIST_FOREACH(blk, &FreeMemBlocksList)
  802cca:	a1 40 51 80 00       	mov    0x805140,%eax
  802ccf:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802cd2:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802cd6:	74 07                	je     802cdf <alloc_block_BF+0xd7>
  802cd8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cdb:	8b 00                	mov    (%eax),%eax
  802cdd:	eb 05                	jmp    802ce4 <alloc_block_BF+0xdc>
  802cdf:	b8 00 00 00 00       	mov    $0x0,%eax
  802ce4:	a3 40 51 80 00       	mov    %eax,0x805140
  802ce9:	a1 40 51 80 00       	mov    0x805140,%eax
  802cee:	85 c0                	test   %eax,%eax
  802cf0:	0f 85 3b ff ff ff    	jne    802c31 <alloc_block_BF+0x29>
  802cf6:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802cfa:	0f 85 31 ff ff ff    	jne    802c31 <alloc_block_BF+0x29>
		{
			LIST_REMOVE(&FreeMemBlocksList, blk);
			return blk;
		}
	}
	LIST_FOREACH(blk, &FreeMemBlocksList)
  802d00:	a1 38 51 80 00       	mov    0x805138,%eax
  802d05:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802d08:	eb 27                	jmp    802d31 <alloc_block_BF+0x129>
	{
		if(blk->size > versize)
  802d0a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d0d:	8b 40 0c             	mov    0xc(%eax),%eax
  802d10:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  802d13:	76 14                	jbe    802d29 <alloc_block_BF+0x121>
		{
			newsize = blk->size;
  802d15:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d18:	8b 40 0c             	mov    0xc(%eax),%eax
  802d1b:	89 45 ec             	mov    %eax,-0x14(%ebp)
			newveradd = blk->sva;
  802d1e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d21:	8b 40 08             	mov    0x8(%eax),%eax
  802d24:	89 45 f0             	mov    %eax,-0x10(%ebp)
			break;
  802d27:	eb 2e                	jmp    802d57 <alloc_block_BF+0x14f>
		{
			LIST_REMOVE(&FreeMemBlocksList, blk);
			return blk;
		}
	}
	LIST_FOREACH(blk, &FreeMemBlocksList)
  802d29:	a1 40 51 80 00       	mov    0x805140,%eax
  802d2e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802d31:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802d35:	74 07                	je     802d3e <alloc_block_BF+0x136>
  802d37:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d3a:	8b 00                	mov    (%eax),%eax
  802d3c:	eb 05                	jmp    802d43 <alloc_block_BF+0x13b>
  802d3e:	b8 00 00 00 00       	mov    $0x0,%eax
  802d43:	a3 40 51 80 00       	mov    %eax,0x805140
  802d48:	a1 40 51 80 00       	mov    0x805140,%eax
  802d4d:	85 c0                	test   %eax,%eax
  802d4f:	75 b9                	jne    802d0a <alloc_block_BF+0x102>
  802d51:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802d55:	75 b3                	jne    802d0a <alloc_block_BF+0x102>
			newsize = blk->size;
			newveradd = blk->sva;
			break;
		}
	}
	LIST_FOREACH(blk, &FreeMemBlocksList)
  802d57:	a1 38 51 80 00       	mov    0x805138,%eax
  802d5c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802d5f:	eb 30                	jmp    802d91 <alloc_block_BF+0x189>
	{
		if(newsize > blk->size && blk->size > versize)
  802d61:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d64:	8b 40 0c             	mov    0xc(%eax),%eax
  802d67:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  802d6a:	73 1d                	jae    802d89 <alloc_block_BF+0x181>
  802d6c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d6f:	8b 40 0c             	mov    0xc(%eax),%eax
  802d72:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  802d75:	76 12                	jbe    802d89 <alloc_block_BF+0x181>
		{
	       newsize = blk->size;
  802d77:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d7a:	8b 40 0c             	mov    0xc(%eax),%eax
  802d7d:	89 45 ec             	mov    %eax,-0x14(%ebp)
		   newveradd = blk->sva;
  802d80:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d83:	8b 40 08             	mov    0x8(%eax),%eax
  802d86:	89 45 f0             	mov    %eax,-0x10(%ebp)
			newsize = blk->size;
			newveradd = blk->sva;
			break;
		}
	}
	LIST_FOREACH(blk, &FreeMemBlocksList)
  802d89:	a1 40 51 80 00       	mov    0x805140,%eax
  802d8e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802d91:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802d95:	74 07                	je     802d9e <alloc_block_BF+0x196>
  802d97:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d9a:	8b 00                	mov    (%eax),%eax
  802d9c:	eb 05                	jmp    802da3 <alloc_block_BF+0x19b>
  802d9e:	b8 00 00 00 00       	mov    $0x0,%eax
  802da3:	a3 40 51 80 00       	mov    %eax,0x805140
  802da8:	a1 40 51 80 00       	mov    0x805140,%eax
  802dad:	85 c0                	test   %eax,%eax
  802daf:	75 b0                	jne    802d61 <alloc_block_BF+0x159>
  802db1:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802db5:	75 aa                	jne    802d61 <alloc_block_BF+0x159>
		{
	       newsize = blk->size;
		   newveradd = blk->sva;
		}
	}
	LIST_FOREACH(blk, &FreeMemBlocksList)
  802db7:	a1 38 51 80 00       	mov    0x805138,%eax
  802dbc:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802dbf:	e9 e4 00 00 00       	jmp    802ea8 <alloc_block_BF+0x2a0>
	{
		if(blk->size == newsize && blk->sva == newveradd)
  802dc4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802dc7:	8b 40 0c             	mov    0xc(%eax),%eax
  802dca:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  802dcd:	0f 85 cd 00 00 00    	jne    802ea0 <alloc_block_BF+0x298>
  802dd3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802dd6:	8b 40 08             	mov    0x8(%eax),%eax
  802dd9:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  802ddc:	0f 85 be 00 00 00    	jne    802ea0 <alloc_block_BF+0x298>
		{
			LIST_REMOVE(&AvailableMemBlocksList, newblk);
  802de2:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  802de6:	75 17                	jne    802dff <alloc_block_BF+0x1f7>
  802de8:	83 ec 04             	sub    $0x4,%esp
  802deb:	68 7c 41 80 00       	push   $0x80417c
  802df0:	68 db 00 00 00       	push   $0xdb
  802df5:	68 0b 41 80 00       	push   $0x80410b
  802dfa:	e8 92 d9 ff ff       	call   800791 <_panic>
  802dff:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802e02:	8b 00                	mov    (%eax),%eax
  802e04:	85 c0                	test   %eax,%eax
  802e06:	74 10                	je     802e18 <alloc_block_BF+0x210>
  802e08:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802e0b:	8b 00                	mov    (%eax),%eax
  802e0d:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802e10:	8b 52 04             	mov    0x4(%edx),%edx
  802e13:	89 50 04             	mov    %edx,0x4(%eax)
  802e16:	eb 0b                	jmp    802e23 <alloc_block_BF+0x21b>
  802e18:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802e1b:	8b 40 04             	mov    0x4(%eax),%eax
  802e1e:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802e23:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802e26:	8b 40 04             	mov    0x4(%eax),%eax
  802e29:	85 c0                	test   %eax,%eax
  802e2b:	74 0f                	je     802e3c <alloc_block_BF+0x234>
  802e2d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802e30:	8b 40 04             	mov    0x4(%eax),%eax
  802e33:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802e36:	8b 12                	mov    (%edx),%edx
  802e38:	89 10                	mov    %edx,(%eax)
  802e3a:	eb 0a                	jmp    802e46 <alloc_block_BF+0x23e>
  802e3c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802e3f:	8b 00                	mov    (%eax),%eax
  802e41:	a3 48 51 80 00       	mov    %eax,0x805148
  802e46:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802e49:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802e4f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802e52:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802e59:	a1 54 51 80 00       	mov    0x805154,%eax
  802e5e:	48                   	dec    %eax
  802e5f:	a3 54 51 80 00       	mov    %eax,0x805154
			newblk->size = versize;
  802e64:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802e67:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802e6a:	89 50 0c             	mov    %edx,0xc(%eax)
			newblk->sva = newveradd;
  802e6d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802e70:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802e73:	89 50 08             	mov    %edx,0x8(%eax)
			blk->size = blk->size - versize;
  802e76:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e79:	8b 40 0c             	mov    0xc(%eax),%eax
  802e7c:	2b 45 e8             	sub    -0x18(%ebp),%eax
  802e7f:	89 c2                	mov    %eax,%edx
  802e81:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e84:	89 50 0c             	mov    %edx,0xc(%eax)
			blk->sva+= newblk->size;
  802e87:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e8a:	8b 50 08             	mov    0x8(%eax),%edx
  802e8d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802e90:	8b 40 0c             	mov    0xc(%eax),%eax
  802e93:	01 c2                	add    %eax,%edx
  802e95:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e98:	89 50 08             	mov    %edx,0x8(%eax)
			return newblk;
  802e9b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802e9e:	eb 3b                	jmp    802edb <alloc_block_BF+0x2d3>
		{
	       newsize = blk->size;
		   newveradd = blk->sva;
		}
	}
	LIST_FOREACH(blk, &FreeMemBlocksList)
  802ea0:	a1 40 51 80 00       	mov    0x805140,%eax
  802ea5:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802ea8:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802eac:	74 07                	je     802eb5 <alloc_block_BF+0x2ad>
  802eae:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802eb1:	8b 00                	mov    (%eax),%eax
  802eb3:	eb 05                	jmp    802eba <alloc_block_BF+0x2b2>
  802eb5:	b8 00 00 00 00       	mov    $0x0,%eax
  802eba:	a3 40 51 80 00       	mov    %eax,0x805140
  802ebf:	a1 40 51 80 00       	mov    0x805140,%eax
  802ec4:	85 c0                	test   %eax,%eax
  802ec6:	0f 85 f8 fe ff ff    	jne    802dc4 <alloc_block_BF+0x1bc>
  802ecc:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802ed0:	0f 85 ee fe ff ff    	jne    802dc4 <alloc_block_BF+0x1bc>
			blk->size = blk->size - versize;
			blk->sva+= newblk->size;
			return newblk;
		}
	}
	return NULL;
  802ed6:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802edb:	c9                   	leave  
  802edc:	c3                   	ret    

00802edd <alloc_block_NF>:
//=========================================
// [7] ALLOCATE BLOCK BY NEXT FIT:
//=========================================
struct MemBlock *last_allocate;
struct MemBlock *alloc_block_NF(uint32 size)
{
  802edd:	55                   	push   %ebp
  802ede:	89 e5                	mov    %esp,%ebp
  802ee0:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1 - BONUS] [DYNAMIC ALLOCATOR] alloc_block_NF
	// Write your code here, remove the panic and write your code
	//panic("alloc_block_NF() is not implemented yet...!!");
	uint32 versize = size;
  802ee3:	8b 45 08             	mov    0x8(%ebp),%eax
  802ee6:	89 45 f0             	mov    %eax,-0x10(%ebp)
	struct MemBlock* blk;
	struct MemBlock* newblk = LIST_FIRST(&AvailableMemBlocksList);
  802ee9:	a1 48 51 80 00       	mov    0x805148,%eax
  802eee:	89 45 ec             	mov    %eax,-0x14(%ebp)

	LIST_FOREACH(blk,&FreeMemBlocksList)
  802ef1:	a1 38 51 80 00       	mov    0x805138,%eax
  802ef6:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802ef9:	e9 77 01 00 00       	jmp    803075 <alloc_block_NF+0x198>
	{
		if(blk->size == versize)
  802efe:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f01:	8b 40 0c             	mov    0xc(%eax),%eax
  802f04:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  802f07:	0f 85 8a 00 00 00    	jne    802f97 <alloc_block_NF+0xba>
		{
			LIST_REMOVE(&FreeMemBlocksList,blk);
  802f0d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802f11:	75 17                	jne    802f2a <alloc_block_NF+0x4d>
  802f13:	83 ec 04             	sub    $0x4,%esp
  802f16:	68 7c 41 80 00       	push   $0x80417c
  802f1b:	68 f7 00 00 00       	push   $0xf7
  802f20:	68 0b 41 80 00       	push   $0x80410b
  802f25:	e8 67 d8 ff ff       	call   800791 <_panic>
  802f2a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f2d:	8b 00                	mov    (%eax),%eax
  802f2f:	85 c0                	test   %eax,%eax
  802f31:	74 10                	je     802f43 <alloc_block_NF+0x66>
  802f33:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f36:	8b 00                	mov    (%eax),%eax
  802f38:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802f3b:	8b 52 04             	mov    0x4(%edx),%edx
  802f3e:	89 50 04             	mov    %edx,0x4(%eax)
  802f41:	eb 0b                	jmp    802f4e <alloc_block_NF+0x71>
  802f43:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f46:	8b 40 04             	mov    0x4(%eax),%eax
  802f49:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802f4e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f51:	8b 40 04             	mov    0x4(%eax),%eax
  802f54:	85 c0                	test   %eax,%eax
  802f56:	74 0f                	je     802f67 <alloc_block_NF+0x8a>
  802f58:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f5b:	8b 40 04             	mov    0x4(%eax),%eax
  802f5e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802f61:	8b 12                	mov    (%edx),%edx
  802f63:	89 10                	mov    %edx,(%eax)
  802f65:	eb 0a                	jmp    802f71 <alloc_block_NF+0x94>
  802f67:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f6a:	8b 00                	mov    (%eax),%eax
  802f6c:	a3 38 51 80 00       	mov    %eax,0x805138
  802f71:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f74:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802f7a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f7d:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802f84:	a1 44 51 80 00       	mov    0x805144,%eax
  802f89:	48                   	dec    %eax
  802f8a:	a3 44 51 80 00       	mov    %eax,0x805144
			return blk;
  802f8f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f92:	e9 11 01 00 00       	jmp    8030a8 <alloc_block_NF+0x1cb>
		}
		else if(blk->size > versize)
  802f97:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f9a:	8b 40 0c             	mov    0xc(%eax),%eax
  802f9d:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  802fa0:	0f 86 c7 00 00 00    	jbe    80306d <alloc_block_NF+0x190>
		{
			LIST_REMOVE(&AvailableMemBlocksList,newblk);
  802fa6:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802faa:	75 17                	jne    802fc3 <alloc_block_NF+0xe6>
  802fac:	83 ec 04             	sub    $0x4,%esp
  802faf:	68 7c 41 80 00       	push   $0x80417c
  802fb4:	68 fc 00 00 00       	push   $0xfc
  802fb9:	68 0b 41 80 00       	push   $0x80410b
  802fbe:	e8 ce d7 ff ff       	call   800791 <_panic>
  802fc3:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802fc6:	8b 00                	mov    (%eax),%eax
  802fc8:	85 c0                	test   %eax,%eax
  802fca:	74 10                	je     802fdc <alloc_block_NF+0xff>
  802fcc:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802fcf:	8b 00                	mov    (%eax),%eax
  802fd1:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802fd4:	8b 52 04             	mov    0x4(%edx),%edx
  802fd7:	89 50 04             	mov    %edx,0x4(%eax)
  802fda:	eb 0b                	jmp    802fe7 <alloc_block_NF+0x10a>
  802fdc:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802fdf:	8b 40 04             	mov    0x4(%eax),%eax
  802fe2:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802fe7:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802fea:	8b 40 04             	mov    0x4(%eax),%eax
  802fed:	85 c0                	test   %eax,%eax
  802fef:	74 0f                	je     803000 <alloc_block_NF+0x123>
  802ff1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802ff4:	8b 40 04             	mov    0x4(%eax),%eax
  802ff7:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802ffa:	8b 12                	mov    (%edx),%edx
  802ffc:	89 10                	mov    %edx,(%eax)
  802ffe:	eb 0a                	jmp    80300a <alloc_block_NF+0x12d>
  803000:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803003:	8b 00                	mov    (%eax),%eax
  803005:	a3 48 51 80 00       	mov    %eax,0x805148
  80300a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80300d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803013:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803016:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80301d:	a1 54 51 80 00       	mov    0x805154,%eax
  803022:	48                   	dec    %eax
  803023:	a3 54 51 80 00       	mov    %eax,0x805154
			newblk->size = versize;
  803028:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80302b:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80302e:	89 50 0c             	mov    %edx,0xc(%eax)
			blk->size = blk->size-versize;
  803031:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803034:	8b 40 0c             	mov    0xc(%eax),%eax
  803037:	2b 45 f0             	sub    -0x10(%ebp),%eax
  80303a:	89 c2                	mov    %eax,%edx
  80303c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80303f:	89 50 0c             	mov    %edx,0xc(%eax)
			uint32 newveradd = blk->sva;
  803042:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803045:	8b 40 08             	mov    0x8(%eax),%eax
  803048:	89 45 e8             	mov    %eax,-0x18(%ebp)
			blk->sva+=newblk->size;
  80304b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80304e:	8b 50 08             	mov    0x8(%eax),%edx
  803051:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803054:	8b 40 0c             	mov    0xc(%eax),%eax
  803057:	01 c2                	add    %eax,%edx
  803059:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80305c:	89 50 08             	mov    %edx,0x8(%eax)
			newblk->sva = newveradd;
  80305f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803062:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803065:	89 50 08             	mov    %edx,0x8(%eax)
			return newblk;
  803068:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80306b:	eb 3b                	jmp    8030a8 <alloc_block_NF+0x1cb>
	//panic("alloc_block_NF() is not implemented yet...!!");
	uint32 versize = size;
	struct MemBlock* blk;
	struct MemBlock* newblk = LIST_FIRST(&AvailableMemBlocksList);

	LIST_FOREACH(blk,&FreeMemBlocksList)
  80306d:	a1 40 51 80 00       	mov    0x805140,%eax
  803072:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803075:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803079:	74 07                	je     803082 <alloc_block_NF+0x1a5>
  80307b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80307e:	8b 00                	mov    (%eax),%eax
  803080:	eb 05                	jmp    803087 <alloc_block_NF+0x1aa>
  803082:	b8 00 00 00 00       	mov    $0x0,%eax
  803087:	a3 40 51 80 00       	mov    %eax,0x805140
  80308c:	a1 40 51 80 00       	mov    0x805140,%eax
  803091:	85 c0                	test   %eax,%eax
  803093:	0f 85 65 fe ff ff    	jne    802efe <alloc_block_NF+0x21>
  803099:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80309d:	0f 85 5b fe ff ff    	jne    802efe <alloc_block_NF+0x21>
			blk->sva+=newblk->size;
			newblk->sva = newveradd;
			return newblk;
		}
	}
	return NULL;
  8030a3:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8030a8:	c9                   	leave  
  8030a9:	c3                   	ret    

008030aa <addToAvailMemBlocksList>:

//===================================================
// [8] INSERT BLOCK (SORTED WITH MERGE) IN FREE LIST:
//===================================================
void addToAvailMemBlocksList(struct MemBlock *blockToInsert)
{
  8030aa:	55                   	push   %ebp
  8030ab:	89 e5                	mov    %esp,%ebp
  8030ad:	83 ec 08             	sub    $0x8,%esp
	blockToInsert->sva = 0;
  8030b0:	8b 45 08             	mov    0x8(%ebp),%eax
  8030b3:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
	blockToInsert->size = 0;
  8030ba:	8b 45 08             	mov    0x8(%ebp),%eax
  8030bd:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
	//add to avail
	LIST_INSERT_TAIL(&AvailableMemBlocksList, blockToInsert);
  8030c4:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8030c8:	75 17                	jne    8030e1 <addToAvailMemBlocksList+0x37>
  8030ca:	83 ec 04             	sub    $0x4,%esp
  8030cd:	68 24 41 80 00       	push   $0x804124
  8030d2:	68 10 01 00 00       	push   $0x110
  8030d7:	68 0b 41 80 00       	push   $0x80410b
  8030dc:	e8 b0 d6 ff ff       	call   800791 <_panic>
  8030e1:	8b 15 4c 51 80 00    	mov    0x80514c,%edx
  8030e7:	8b 45 08             	mov    0x8(%ebp),%eax
  8030ea:	89 50 04             	mov    %edx,0x4(%eax)
  8030ed:	8b 45 08             	mov    0x8(%ebp),%eax
  8030f0:	8b 40 04             	mov    0x4(%eax),%eax
  8030f3:	85 c0                	test   %eax,%eax
  8030f5:	74 0c                	je     803103 <addToAvailMemBlocksList+0x59>
  8030f7:	a1 4c 51 80 00       	mov    0x80514c,%eax
  8030fc:	8b 55 08             	mov    0x8(%ebp),%edx
  8030ff:	89 10                	mov    %edx,(%eax)
  803101:	eb 08                	jmp    80310b <addToAvailMemBlocksList+0x61>
  803103:	8b 45 08             	mov    0x8(%ebp),%eax
  803106:	a3 48 51 80 00       	mov    %eax,0x805148
  80310b:	8b 45 08             	mov    0x8(%ebp),%eax
  80310e:	a3 4c 51 80 00       	mov    %eax,0x80514c
  803113:	8b 45 08             	mov    0x8(%ebp),%eax
  803116:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80311c:	a1 54 51 80 00       	mov    0x805154,%eax
  803121:	40                   	inc    %eax
  803122:	a3 54 51 80 00       	mov    %eax,0x805154
}
  803127:	90                   	nop
  803128:	c9                   	leave  
  803129:	c3                   	ret    

0080312a <insert_sorted_with_merge_freeList>:
void insert_sorted_with_merge_freeList(struct MemBlock *blockToInsert)
{
  80312a:	55                   	push   %ebp
  80312b:	89 e5                	mov    %esp,%ebp
  80312d:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] insert_sorted_with_merge_freeList
	// Write your code here, remove the panic and write your code

	struct MemBlock* last = LIST_LAST(&FreeMemBlocksList);
  803130:	a1 3c 51 80 00       	mov    0x80513c,%eax
  803135:	89 45 f0             	mov    %eax,-0x10(%ebp)
	//check if list empty
	if (LIST_SIZE(&(FreeMemBlocksList)) == 0)
  803138:	a1 44 51 80 00       	mov    0x805144,%eax
  80313d:	85 c0                	test   %eax,%eax
  80313f:	75 68                	jne    8031a9 <insert_sorted_with_merge_freeList+0x7f>
		LIST_INSERT_HEAD(&FreeMemBlocksList, blockToInsert);
  803141:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803145:	75 17                	jne    80315e <insert_sorted_with_merge_freeList+0x34>
  803147:	83 ec 04             	sub    $0x4,%esp
  80314a:	68 e8 40 80 00       	push   $0x8040e8
  80314f:	68 1a 01 00 00       	push   $0x11a
  803154:	68 0b 41 80 00       	push   $0x80410b
  803159:	e8 33 d6 ff ff       	call   800791 <_panic>
  80315e:	8b 15 38 51 80 00    	mov    0x805138,%edx
  803164:	8b 45 08             	mov    0x8(%ebp),%eax
  803167:	89 10                	mov    %edx,(%eax)
  803169:	8b 45 08             	mov    0x8(%ebp),%eax
  80316c:	8b 00                	mov    (%eax),%eax
  80316e:	85 c0                	test   %eax,%eax
  803170:	74 0d                	je     80317f <insert_sorted_with_merge_freeList+0x55>
  803172:	a1 38 51 80 00       	mov    0x805138,%eax
  803177:	8b 55 08             	mov    0x8(%ebp),%edx
  80317a:	89 50 04             	mov    %edx,0x4(%eax)
  80317d:	eb 08                	jmp    803187 <insert_sorted_with_merge_freeList+0x5d>
  80317f:	8b 45 08             	mov    0x8(%ebp),%eax
  803182:	a3 3c 51 80 00       	mov    %eax,0x80513c
  803187:	8b 45 08             	mov    0x8(%ebp),%eax
  80318a:	a3 38 51 80 00       	mov    %eax,0x805138
  80318f:	8b 45 08             	mov    0x8(%ebp),%eax
  803192:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803199:	a1 44 51 80 00       	mov    0x805144,%eax
  80319e:	40                   	inc    %eax
  80319f:	a3 44 51 80 00       	mov    %eax,0x805144
		}
	}

	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  8031a4:	e9 c5 03 00 00       	jmp    80356e <insert_sorted_with_merge_freeList+0x444>
	struct MemBlock* last = LIST_LAST(&FreeMemBlocksList);
	//check if list empty
	if (LIST_SIZE(&(FreeMemBlocksList)) == 0)
		LIST_INSERT_HEAD(&FreeMemBlocksList, blockToInsert);
	//check if it's position is at last
	else if (last->sva < blockToInsert->sva) {
  8031a9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8031ac:	8b 50 08             	mov    0x8(%eax),%edx
  8031af:	8b 45 08             	mov    0x8(%ebp),%eax
  8031b2:	8b 40 08             	mov    0x8(%eax),%eax
  8031b5:	39 c2                	cmp    %eax,%edx
  8031b7:	0f 83 b2 00 00 00    	jae    80326f <insert_sorted_with_merge_freeList+0x145>

		//if i have to merge
		if (last->sva + last->size == blockToInsert->sva) {
  8031bd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8031c0:	8b 50 08             	mov    0x8(%eax),%edx
  8031c3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8031c6:	8b 40 0c             	mov    0xc(%eax),%eax
  8031c9:	01 c2                	add    %eax,%edx
  8031cb:	8b 45 08             	mov    0x8(%ebp),%eax
  8031ce:	8b 40 08             	mov    0x8(%eax),%eax
  8031d1:	39 c2                	cmp    %eax,%edx
  8031d3:	75 27                	jne    8031fc <insert_sorted_with_merge_freeList+0xd2>
			last->size = last->size + blockToInsert->size;
  8031d5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8031d8:	8b 50 0c             	mov    0xc(%eax),%edx
  8031db:	8b 45 08             	mov    0x8(%ebp),%eax
  8031de:	8b 40 0c             	mov    0xc(%eax),%eax
  8031e1:	01 c2                	add    %eax,%edx
  8031e3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8031e6:	89 50 0c             	mov    %edx,0xc(%eax)
			addToAvailMemBlocksList(blockToInsert);
  8031e9:	83 ec 0c             	sub    $0xc,%esp
  8031ec:	ff 75 08             	pushl  0x8(%ebp)
  8031ef:	e8 b6 fe ff ff       	call   8030aa <addToAvailMemBlocksList>
  8031f4:	83 c4 10             	add    $0x10,%esp
		}
	}

	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  8031f7:	e9 72 03 00 00       	jmp    80356e <insert_sorted_with_merge_freeList+0x444>
		if (last->sva + last->size == blockToInsert->sva) {
			last->size = last->size + blockToInsert->size;
			addToAvailMemBlocksList(blockToInsert);

		} else {
			LIST_INSERT_AFTER(&FreeMemBlocksList, last, blockToInsert);
  8031fc:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  803200:	74 06                	je     803208 <insert_sorted_with_merge_freeList+0xde>
  803202:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803206:	75 17                	jne    80321f <insert_sorted_with_merge_freeList+0xf5>
  803208:	83 ec 04             	sub    $0x4,%esp
  80320b:	68 48 41 80 00       	push   $0x804148
  803210:	68 24 01 00 00       	push   $0x124
  803215:	68 0b 41 80 00       	push   $0x80410b
  80321a:	e8 72 d5 ff ff       	call   800791 <_panic>
  80321f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803222:	8b 10                	mov    (%eax),%edx
  803224:	8b 45 08             	mov    0x8(%ebp),%eax
  803227:	89 10                	mov    %edx,(%eax)
  803229:	8b 45 08             	mov    0x8(%ebp),%eax
  80322c:	8b 00                	mov    (%eax),%eax
  80322e:	85 c0                	test   %eax,%eax
  803230:	74 0b                	je     80323d <insert_sorted_with_merge_freeList+0x113>
  803232:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803235:	8b 00                	mov    (%eax),%eax
  803237:	8b 55 08             	mov    0x8(%ebp),%edx
  80323a:	89 50 04             	mov    %edx,0x4(%eax)
  80323d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803240:	8b 55 08             	mov    0x8(%ebp),%edx
  803243:	89 10                	mov    %edx,(%eax)
  803245:	8b 45 08             	mov    0x8(%ebp),%eax
  803248:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80324b:	89 50 04             	mov    %edx,0x4(%eax)
  80324e:	8b 45 08             	mov    0x8(%ebp),%eax
  803251:	8b 00                	mov    (%eax),%eax
  803253:	85 c0                	test   %eax,%eax
  803255:	75 08                	jne    80325f <insert_sorted_with_merge_freeList+0x135>
  803257:	8b 45 08             	mov    0x8(%ebp),%eax
  80325a:	a3 3c 51 80 00       	mov    %eax,0x80513c
  80325f:	a1 44 51 80 00       	mov    0x805144,%eax
  803264:	40                   	inc    %eax
  803265:	a3 44 51 80 00       	mov    %eax,0x805144
		}
	}

	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  80326a:	e9 ff 02 00 00       	jmp    80356e <insert_sorted_with_merge_freeList+0x444>
		} else {
			LIST_INSERT_AFTER(&FreeMemBlocksList, last, blockToInsert);
		}
	} else {
		struct MemBlock *iterator;
		LIST_FOREACH(iterator, &(FreeMemBlocksList))
  80326f:	a1 38 51 80 00       	mov    0x805138,%eax
  803274:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803277:	e9 c2 02 00 00       	jmp    80353e <insert_sorted_with_merge_freeList+0x414>
		{

			if (iterator->sva > blockToInsert->sva) {
  80327c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80327f:	8b 50 08             	mov    0x8(%eax),%edx
  803282:	8b 45 08             	mov    0x8(%ebp),%eax
  803285:	8b 40 08             	mov    0x8(%eax),%eax
  803288:	39 c2                	cmp    %eax,%edx
  80328a:	0f 86 a6 02 00 00    	jbe    803536 <insert_sorted_with_merge_freeList+0x40c>

				struct MemBlock* prev = LIST_PREV(iterator);
  803290:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803293:	8b 40 04             	mov    0x4(%eax),%eax
  803296:	89 45 ec             	mov    %eax,-0x14(%ebp)
				if (prev == NULL) {
  803299:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  80329d:	0f 85 ba 00 00 00    	jne    80335d <insert_sorted_with_merge_freeList+0x233>
					//check merge
					if (blockToInsert->size + blockToInsert->sva
  8032a3:	8b 45 08             	mov    0x8(%ebp),%eax
  8032a6:	8b 50 0c             	mov    0xc(%eax),%edx
  8032a9:	8b 45 08             	mov    0x8(%ebp),%eax
  8032ac:	8b 40 08             	mov    0x8(%eax),%eax
  8032af:	01 c2                	add    %eax,%edx
							== iterator->sva) {
  8032b1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8032b4:	8b 40 08             	mov    0x8(%eax),%eax
			if (iterator->sva > blockToInsert->sva) {

				struct MemBlock* prev = LIST_PREV(iterator);
				if (prev == NULL) {
					//check merge
					if (blockToInsert->size + blockToInsert->sva
  8032b7:	39 c2                	cmp    %eax,%edx
  8032b9:	75 33                	jne    8032ee <insert_sorted_with_merge_freeList+0x1c4>
							== iterator->sva) {
						iterator->sva = blockToInsert->sva;
  8032bb:	8b 45 08             	mov    0x8(%ebp),%eax
  8032be:	8b 50 08             	mov    0x8(%eax),%edx
  8032c1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8032c4:	89 50 08             	mov    %edx,0x8(%eax)
						iterator->size = iterator->size + blockToInsert->size;
  8032c7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8032ca:	8b 50 0c             	mov    0xc(%eax),%edx
  8032cd:	8b 45 08             	mov    0x8(%ebp),%eax
  8032d0:	8b 40 0c             	mov    0xc(%eax),%eax
  8032d3:	01 c2                	add    %eax,%edx
  8032d5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8032d8:	89 50 0c             	mov    %edx,0xc(%eax)
						addToAvailMemBlocksList(blockToInsert);
  8032db:	83 ec 0c             	sub    $0xc,%esp
  8032de:	ff 75 08             	pushl  0x8(%ebp)
  8032e1:	e8 c4 fd ff ff       	call   8030aa <addToAvailMemBlocksList>
  8032e6:	83 c4 10             	add    $0x10,%esp

					else {
						LIST_INSERT_BEFORE(&FreeMemBlocksList, iterator,
								blockToInsert);
					}
					break;
  8032e9:	e9 80 02 00 00       	jmp    80356e <insert_sorted_with_merge_freeList+0x444>
						addToAvailMemBlocksList(blockToInsert);

					}

					else {
						LIST_INSERT_BEFORE(&FreeMemBlocksList, iterator,
  8032ee:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8032f2:	74 06                	je     8032fa <insert_sorted_with_merge_freeList+0x1d0>
  8032f4:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8032f8:	75 17                	jne    803311 <insert_sorted_with_merge_freeList+0x1e7>
  8032fa:	83 ec 04             	sub    $0x4,%esp
  8032fd:	68 9c 41 80 00       	push   $0x80419c
  803302:	68 3a 01 00 00       	push   $0x13a
  803307:	68 0b 41 80 00       	push   $0x80410b
  80330c:	e8 80 d4 ff ff       	call   800791 <_panic>
  803311:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803314:	8b 50 04             	mov    0x4(%eax),%edx
  803317:	8b 45 08             	mov    0x8(%ebp),%eax
  80331a:	89 50 04             	mov    %edx,0x4(%eax)
  80331d:	8b 45 08             	mov    0x8(%ebp),%eax
  803320:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803323:	89 10                	mov    %edx,(%eax)
  803325:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803328:	8b 40 04             	mov    0x4(%eax),%eax
  80332b:	85 c0                	test   %eax,%eax
  80332d:	74 0d                	je     80333c <insert_sorted_with_merge_freeList+0x212>
  80332f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803332:	8b 40 04             	mov    0x4(%eax),%eax
  803335:	8b 55 08             	mov    0x8(%ebp),%edx
  803338:	89 10                	mov    %edx,(%eax)
  80333a:	eb 08                	jmp    803344 <insert_sorted_with_merge_freeList+0x21a>
  80333c:	8b 45 08             	mov    0x8(%ebp),%eax
  80333f:	a3 38 51 80 00       	mov    %eax,0x805138
  803344:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803347:	8b 55 08             	mov    0x8(%ebp),%edx
  80334a:	89 50 04             	mov    %edx,0x4(%eax)
  80334d:	a1 44 51 80 00       	mov    0x805144,%eax
  803352:	40                   	inc    %eax
  803353:	a3 44 51 80 00       	mov    %eax,0x805144
								blockToInsert);
					}
					break;
  803358:	e9 11 02 00 00       	jmp    80356e <insert_sorted_with_merge_freeList+0x444>
				} else {
					//prev and next merge
					if (prev->sva + prev->size + blockToInsert->size
  80335d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803360:	8b 50 08             	mov    0x8(%eax),%edx
  803363:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803366:	8b 40 0c             	mov    0xc(%eax),%eax
  803369:	01 c2                	add    %eax,%edx
  80336b:	8b 45 08             	mov    0x8(%ebp),%eax
  80336e:	8b 40 0c             	mov    0xc(%eax),%eax
  803371:	01 c2                	add    %eax,%edx
							== iterator->sva) {
  803373:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803376:	8b 40 08             	mov    0x8(%eax),%eax
								blockToInsert);
					}
					break;
				} else {
					//prev and next merge
					if (prev->sva + prev->size + blockToInsert->size
  803379:	39 c2                	cmp    %eax,%edx
  80337b:	0f 85 bf 00 00 00    	jne    803440 <insert_sorted_with_merge_freeList+0x316>
							== iterator->sva) {
						prev->size = prev->size + blockToInsert->size
  803381:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803384:	8b 50 0c             	mov    0xc(%eax),%edx
  803387:	8b 45 08             	mov    0x8(%ebp),%eax
  80338a:	8b 40 0c             	mov    0xc(%eax),%eax
  80338d:	01 c2                	add    %eax,%edx
								+ iterator->size;
  80338f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803392:	8b 40 0c             	mov    0xc(%eax),%eax
  803395:	01 c2                	add    %eax,%edx
					break;
				} else {
					//prev and next merge
					if (prev->sva + prev->size + blockToInsert->size
							== iterator->sva) {
						prev->size = prev->size + blockToInsert->size
  803397:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80339a:	89 50 0c             	mov    %edx,0xc(%eax)
								+ iterator->size;
						LIST_REMOVE(&FreeMemBlocksList, iterator);
  80339d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8033a1:	75 17                	jne    8033ba <insert_sorted_with_merge_freeList+0x290>
  8033a3:	83 ec 04             	sub    $0x4,%esp
  8033a6:	68 7c 41 80 00       	push   $0x80417c
  8033ab:	68 43 01 00 00       	push   $0x143
  8033b0:	68 0b 41 80 00       	push   $0x80410b
  8033b5:	e8 d7 d3 ff ff       	call   800791 <_panic>
  8033ba:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8033bd:	8b 00                	mov    (%eax),%eax
  8033bf:	85 c0                	test   %eax,%eax
  8033c1:	74 10                	je     8033d3 <insert_sorted_with_merge_freeList+0x2a9>
  8033c3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8033c6:	8b 00                	mov    (%eax),%eax
  8033c8:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8033cb:	8b 52 04             	mov    0x4(%edx),%edx
  8033ce:	89 50 04             	mov    %edx,0x4(%eax)
  8033d1:	eb 0b                	jmp    8033de <insert_sorted_with_merge_freeList+0x2b4>
  8033d3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8033d6:	8b 40 04             	mov    0x4(%eax),%eax
  8033d9:	a3 3c 51 80 00       	mov    %eax,0x80513c
  8033de:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8033e1:	8b 40 04             	mov    0x4(%eax),%eax
  8033e4:	85 c0                	test   %eax,%eax
  8033e6:	74 0f                	je     8033f7 <insert_sorted_with_merge_freeList+0x2cd>
  8033e8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8033eb:	8b 40 04             	mov    0x4(%eax),%eax
  8033ee:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8033f1:	8b 12                	mov    (%edx),%edx
  8033f3:	89 10                	mov    %edx,(%eax)
  8033f5:	eb 0a                	jmp    803401 <insert_sorted_with_merge_freeList+0x2d7>
  8033f7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8033fa:	8b 00                	mov    (%eax),%eax
  8033fc:	a3 38 51 80 00       	mov    %eax,0x805138
  803401:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803404:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80340a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80340d:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803414:	a1 44 51 80 00       	mov    0x805144,%eax
  803419:	48                   	dec    %eax
  80341a:	a3 44 51 80 00       	mov    %eax,0x805144
						addToAvailMemBlocksList(blockToInsert);
  80341f:	83 ec 0c             	sub    $0xc,%esp
  803422:	ff 75 08             	pushl  0x8(%ebp)
  803425:	e8 80 fc ff ff       	call   8030aa <addToAvailMemBlocksList>
  80342a:	83 c4 10             	add    $0x10,%esp
						addToAvailMemBlocksList(iterator);
  80342d:	83 ec 0c             	sub    $0xc,%esp
  803430:	ff 75 f4             	pushl  -0xc(%ebp)
  803433:	e8 72 fc ff ff       	call   8030aa <addToAvailMemBlocksList>
  803438:	83 c4 10             	add    $0x10,%esp
					//Insert
					else {
						LIST_INSERT_BEFORE(&FreeMemBlocksList, iterator,
								blockToInsert);
					}
					break;
  80343b:	e9 2e 01 00 00       	jmp    80356e <insert_sorted_with_merge_freeList+0x444>
						LIST_REMOVE(&FreeMemBlocksList, iterator);
						addToAvailMemBlocksList(blockToInsert);
						addToAvailMemBlocksList(iterator);
					}
					//previous merge
					else if (prev->sva + prev->size == blockToInsert->sva) {
  803440:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803443:	8b 50 08             	mov    0x8(%eax),%edx
  803446:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803449:	8b 40 0c             	mov    0xc(%eax),%eax
  80344c:	01 c2                	add    %eax,%edx
  80344e:	8b 45 08             	mov    0x8(%ebp),%eax
  803451:	8b 40 08             	mov    0x8(%eax),%eax
  803454:	39 c2                	cmp    %eax,%edx
  803456:	75 27                	jne    80347f <insert_sorted_with_merge_freeList+0x355>
						prev->size = prev->size + blockToInsert->size;
  803458:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80345b:	8b 50 0c             	mov    0xc(%eax),%edx
  80345e:	8b 45 08             	mov    0x8(%ebp),%eax
  803461:	8b 40 0c             	mov    0xc(%eax),%eax
  803464:	01 c2                	add    %eax,%edx
  803466:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803469:	89 50 0c             	mov    %edx,0xc(%eax)
						addToAvailMemBlocksList(blockToInsert);
  80346c:	83 ec 0c             	sub    $0xc,%esp
  80346f:	ff 75 08             	pushl  0x8(%ebp)
  803472:	e8 33 fc ff ff       	call   8030aa <addToAvailMemBlocksList>
  803477:	83 c4 10             	add    $0x10,%esp
					//Insert
					else {
						LIST_INSERT_BEFORE(&FreeMemBlocksList, iterator,
								blockToInsert);
					}
					break;
  80347a:	e9 ef 00 00 00       	jmp    80356e <insert_sorted_with_merge_freeList+0x444>
					else if (prev->sva + prev->size == blockToInsert->sva) {
						prev->size = prev->size + blockToInsert->size;
						addToAvailMemBlocksList(blockToInsert);
					}
					//next merge
					else if (blockToInsert->size + blockToInsert->sva
  80347f:	8b 45 08             	mov    0x8(%ebp),%eax
  803482:	8b 50 0c             	mov    0xc(%eax),%edx
  803485:	8b 45 08             	mov    0x8(%ebp),%eax
  803488:	8b 40 08             	mov    0x8(%eax),%eax
  80348b:	01 c2                	add    %eax,%edx
							== iterator->sva) {
  80348d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803490:	8b 40 08             	mov    0x8(%eax),%eax
					else if (prev->sva + prev->size == blockToInsert->sva) {
						prev->size = prev->size + blockToInsert->size;
						addToAvailMemBlocksList(blockToInsert);
					}
					//next merge
					else if (blockToInsert->size + blockToInsert->sva
  803493:	39 c2                	cmp    %eax,%edx
  803495:	75 33                	jne    8034ca <insert_sorted_with_merge_freeList+0x3a0>
							== iterator->sva) {
						iterator->sva = blockToInsert->sva;
  803497:	8b 45 08             	mov    0x8(%ebp),%eax
  80349a:	8b 50 08             	mov    0x8(%eax),%edx
  80349d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8034a0:	89 50 08             	mov    %edx,0x8(%eax)
						iterator->size = iterator->size + blockToInsert->size;
  8034a3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8034a6:	8b 50 0c             	mov    0xc(%eax),%edx
  8034a9:	8b 45 08             	mov    0x8(%ebp),%eax
  8034ac:	8b 40 0c             	mov    0xc(%eax),%eax
  8034af:	01 c2                	add    %eax,%edx
  8034b1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8034b4:	89 50 0c             	mov    %edx,0xc(%eax)
						addToAvailMemBlocksList(blockToInsert);
  8034b7:	83 ec 0c             	sub    $0xc,%esp
  8034ba:	ff 75 08             	pushl  0x8(%ebp)
  8034bd:	e8 e8 fb ff ff       	call   8030aa <addToAvailMemBlocksList>
  8034c2:	83 c4 10             	add    $0x10,%esp
					//Insert
					else {
						LIST_INSERT_BEFORE(&FreeMemBlocksList, iterator,
								blockToInsert);
					}
					break;
  8034c5:	e9 a4 00 00 00       	jmp    80356e <insert_sorted_with_merge_freeList+0x444>
						iterator->size = iterator->size + blockToInsert->size;
						addToAvailMemBlocksList(blockToInsert);
					}
					//Insert
					else {
						LIST_INSERT_BEFORE(&FreeMemBlocksList, iterator,
  8034ca:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8034ce:	74 06                	je     8034d6 <insert_sorted_with_merge_freeList+0x3ac>
  8034d0:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8034d4:	75 17                	jne    8034ed <insert_sorted_with_merge_freeList+0x3c3>
  8034d6:	83 ec 04             	sub    $0x4,%esp
  8034d9:	68 9c 41 80 00       	push   $0x80419c
  8034de:	68 56 01 00 00       	push   $0x156
  8034e3:	68 0b 41 80 00       	push   $0x80410b
  8034e8:	e8 a4 d2 ff ff       	call   800791 <_panic>
  8034ed:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8034f0:	8b 50 04             	mov    0x4(%eax),%edx
  8034f3:	8b 45 08             	mov    0x8(%ebp),%eax
  8034f6:	89 50 04             	mov    %edx,0x4(%eax)
  8034f9:	8b 45 08             	mov    0x8(%ebp),%eax
  8034fc:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8034ff:	89 10                	mov    %edx,(%eax)
  803501:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803504:	8b 40 04             	mov    0x4(%eax),%eax
  803507:	85 c0                	test   %eax,%eax
  803509:	74 0d                	je     803518 <insert_sorted_with_merge_freeList+0x3ee>
  80350b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80350e:	8b 40 04             	mov    0x4(%eax),%eax
  803511:	8b 55 08             	mov    0x8(%ebp),%edx
  803514:	89 10                	mov    %edx,(%eax)
  803516:	eb 08                	jmp    803520 <insert_sorted_with_merge_freeList+0x3f6>
  803518:	8b 45 08             	mov    0x8(%ebp),%eax
  80351b:	a3 38 51 80 00       	mov    %eax,0x805138
  803520:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803523:	8b 55 08             	mov    0x8(%ebp),%edx
  803526:	89 50 04             	mov    %edx,0x4(%eax)
  803529:	a1 44 51 80 00       	mov    0x805144,%eax
  80352e:	40                   	inc    %eax
  80352f:	a3 44 51 80 00       	mov    %eax,0x805144
								blockToInsert);
					}
					break;
  803534:	eb 38                	jmp    80356e <insert_sorted_with_merge_freeList+0x444>
		} else {
			LIST_INSERT_AFTER(&FreeMemBlocksList, last, blockToInsert);
		}
	} else {
		struct MemBlock *iterator;
		LIST_FOREACH(iterator, &(FreeMemBlocksList))
  803536:	a1 40 51 80 00       	mov    0x805140,%eax
  80353b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80353e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803542:	74 07                	je     80354b <insert_sorted_with_merge_freeList+0x421>
  803544:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803547:	8b 00                	mov    (%eax),%eax
  803549:	eb 05                	jmp    803550 <insert_sorted_with_merge_freeList+0x426>
  80354b:	b8 00 00 00 00       	mov    $0x0,%eax
  803550:	a3 40 51 80 00       	mov    %eax,0x805140
  803555:	a1 40 51 80 00       	mov    0x805140,%eax
  80355a:	85 c0                	test   %eax,%eax
  80355c:	0f 85 1a fd ff ff    	jne    80327c <insert_sorted_with_merge_freeList+0x152>
  803562:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803566:	0f 85 10 fd ff ff    	jne    80327c <insert_sorted_with_merge_freeList+0x152>
		}
	}

	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  80356c:	eb 00                	jmp    80356e <insert_sorted_with_merge_freeList+0x444>
  80356e:	90                   	nop
  80356f:	c9                   	leave  
  803570:	c3                   	ret    
  803571:	66 90                	xchg   %ax,%ax
  803573:	90                   	nop

00803574 <__udivdi3>:
  803574:	55                   	push   %ebp
  803575:	57                   	push   %edi
  803576:	56                   	push   %esi
  803577:	53                   	push   %ebx
  803578:	83 ec 1c             	sub    $0x1c,%esp
  80357b:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  80357f:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  803583:	8b 7c 24 38          	mov    0x38(%esp),%edi
  803587:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  80358b:	89 ca                	mov    %ecx,%edx
  80358d:	89 f8                	mov    %edi,%eax
  80358f:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  803593:	85 f6                	test   %esi,%esi
  803595:	75 2d                	jne    8035c4 <__udivdi3+0x50>
  803597:	39 cf                	cmp    %ecx,%edi
  803599:	77 65                	ja     803600 <__udivdi3+0x8c>
  80359b:	89 fd                	mov    %edi,%ebp
  80359d:	85 ff                	test   %edi,%edi
  80359f:	75 0b                	jne    8035ac <__udivdi3+0x38>
  8035a1:	b8 01 00 00 00       	mov    $0x1,%eax
  8035a6:	31 d2                	xor    %edx,%edx
  8035a8:	f7 f7                	div    %edi
  8035aa:	89 c5                	mov    %eax,%ebp
  8035ac:	31 d2                	xor    %edx,%edx
  8035ae:	89 c8                	mov    %ecx,%eax
  8035b0:	f7 f5                	div    %ebp
  8035b2:	89 c1                	mov    %eax,%ecx
  8035b4:	89 d8                	mov    %ebx,%eax
  8035b6:	f7 f5                	div    %ebp
  8035b8:	89 cf                	mov    %ecx,%edi
  8035ba:	89 fa                	mov    %edi,%edx
  8035bc:	83 c4 1c             	add    $0x1c,%esp
  8035bf:	5b                   	pop    %ebx
  8035c0:	5e                   	pop    %esi
  8035c1:	5f                   	pop    %edi
  8035c2:	5d                   	pop    %ebp
  8035c3:	c3                   	ret    
  8035c4:	39 ce                	cmp    %ecx,%esi
  8035c6:	77 28                	ja     8035f0 <__udivdi3+0x7c>
  8035c8:	0f bd fe             	bsr    %esi,%edi
  8035cb:	83 f7 1f             	xor    $0x1f,%edi
  8035ce:	75 40                	jne    803610 <__udivdi3+0x9c>
  8035d0:	39 ce                	cmp    %ecx,%esi
  8035d2:	72 0a                	jb     8035de <__udivdi3+0x6a>
  8035d4:	3b 44 24 08          	cmp    0x8(%esp),%eax
  8035d8:	0f 87 9e 00 00 00    	ja     80367c <__udivdi3+0x108>
  8035de:	b8 01 00 00 00       	mov    $0x1,%eax
  8035e3:	89 fa                	mov    %edi,%edx
  8035e5:	83 c4 1c             	add    $0x1c,%esp
  8035e8:	5b                   	pop    %ebx
  8035e9:	5e                   	pop    %esi
  8035ea:	5f                   	pop    %edi
  8035eb:	5d                   	pop    %ebp
  8035ec:	c3                   	ret    
  8035ed:	8d 76 00             	lea    0x0(%esi),%esi
  8035f0:	31 ff                	xor    %edi,%edi
  8035f2:	31 c0                	xor    %eax,%eax
  8035f4:	89 fa                	mov    %edi,%edx
  8035f6:	83 c4 1c             	add    $0x1c,%esp
  8035f9:	5b                   	pop    %ebx
  8035fa:	5e                   	pop    %esi
  8035fb:	5f                   	pop    %edi
  8035fc:	5d                   	pop    %ebp
  8035fd:	c3                   	ret    
  8035fe:	66 90                	xchg   %ax,%ax
  803600:	89 d8                	mov    %ebx,%eax
  803602:	f7 f7                	div    %edi
  803604:	31 ff                	xor    %edi,%edi
  803606:	89 fa                	mov    %edi,%edx
  803608:	83 c4 1c             	add    $0x1c,%esp
  80360b:	5b                   	pop    %ebx
  80360c:	5e                   	pop    %esi
  80360d:	5f                   	pop    %edi
  80360e:	5d                   	pop    %ebp
  80360f:	c3                   	ret    
  803610:	bd 20 00 00 00       	mov    $0x20,%ebp
  803615:	89 eb                	mov    %ebp,%ebx
  803617:	29 fb                	sub    %edi,%ebx
  803619:	89 f9                	mov    %edi,%ecx
  80361b:	d3 e6                	shl    %cl,%esi
  80361d:	89 c5                	mov    %eax,%ebp
  80361f:	88 d9                	mov    %bl,%cl
  803621:	d3 ed                	shr    %cl,%ebp
  803623:	89 e9                	mov    %ebp,%ecx
  803625:	09 f1                	or     %esi,%ecx
  803627:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  80362b:	89 f9                	mov    %edi,%ecx
  80362d:	d3 e0                	shl    %cl,%eax
  80362f:	89 c5                	mov    %eax,%ebp
  803631:	89 d6                	mov    %edx,%esi
  803633:	88 d9                	mov    %bl,%cl
  803635:	d3 ee                	shr    %cl,%esi
  803637:	89 f9                	mov    %edi,%ecx
  803639:	d3 e2                	shl    %cl,%edx
  80363b:	8b 44 24 08          	mov    0x8(%esp),%eax
  80363f:	88 d9                	mov    %bl,%cl
  803641:	d3 e8                	shr    %cl,%eax
  803643:	09 c2                	or     %eax,%edx
  803645:	89 d0                	mov    %edx,%eax
  803647:	89 f2                	mov    %esi,%edx
  803649:	f7 74 24 0c          	divl   0xc(%esp)
  80364d:	89 d6                	mov    %edx,%esi
  80364f:	89 c3                	mov    %eax,%ebx
  803651:	f7 e5                	mul    %ebp
  803653:	39 d6                	cmp    %edx,%esi
  803655:	72 19                	jb     803670 <__udivdi3+0xfc>
  803657:	74 0b                	je     803664 <__udivdi3+0xf0>
  803659:	89 d8                	mov    %ebx,%eax
  80365b:	31 ff                	xor    %edi,%edi
  80365d:	e9 58 ff ff ff       	jmp    8035ba <__udivdi3+0x46>
  803662:	66 90                	xchg   %ax,%ax
  803664:	8b 54 24 08          	mov    0x8(%esp),%edx
  803668:	89 f9                	mov    %edi,%ecx
  80366a:	d3 e2                	shl    %cl,%edx
  80366c:	39 c2                	cmp    %eax,%edx
  80366e:	73 e9                	jae    803659 <__udivdi3+0xe5>
  803670:	8d 43 ff             	lea    -0x1(%ebx),%eax
  803673:	31 ff                	xor    %edi,%edi
  803675:	e9 40 ff ff ff       	jmp    8035ba <__udivdi3+0x46>
  80367a:	66 90                	xchg   %ax,%ax
  80367c:	31 c0                	xor    %eax,%eax
  80367e:	e9 37 ff ff ff       	jmp    8035ba <__udivdi3+0x46>
  803683:	90                   	nop

00803684 <__umoddi3>:
  803684:	55                   	push   %ebp
  803685:	57                   	push   %edi
  803686:	56                   	push   %esi
  803687:	53                   	push   %ebx
  803688:	83 ec 1c             	sub    $0x1c,%esp
  80368b:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  80368f:	8b 74 24 34          	mov    0x34(%esp),%esi
  803693:	8b 7c 24 38          	mov    0x38(%esp),%edi
  803697:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  80369b:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80369f:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8036a3:	89 f3                	mov    %esi,%ebx
  8036a5:	89 fa                	mov    %edi,%edx
  8036a7:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8036ab:	89 34 24             	mov    %esi,(%esp)
  8036ae:	85 c0                	test   %eax,%eax
  8036b0:	75 1a                	jne    8036cc <__umoddi3+0x48>
  8036b2:	39 f7                	cmp    %esi,%edi
  8036b4:	0f 86 a2 00 00 00    	jbe    80375c <__umoddi3+0xd8>
  8036ba:	89 c8                	mov    %ecx,%eax
  8036bc:	89 f2                	mov    %esi,%edx
  8036be:	f7 f7                	div    %edi
  8036c0:	89 d0                	mov    %edx,%eax
  8036c2:	31 d2                	xor    %edx,%edx
  8036c4:	83 c4 1c             	add    $0x1c,%esp
  8036c7:	5b                   	pop    %ebx
  8036c8:	5e                   	pop    %esi
  8036c9:	5f                   	pop    %edi
  8036ca:	5d                   	pop    %ebp
  8036cb:	c3                   	ret    
  8036cc:	39 f0                	cmp    %esi,%eax
  8036ce:	0f 87 ac 00 00 00    	ja     803780 <__umoddi3+0xfc>
  8036d4:	0f bd e8             	bsr    %eax,%ebp
  8036d7:	83 f5 1f             	xor    $0x1f,%ebp
  8036da:	0f 84 ac 00 00 00    	je     80378c <__umoddi3+0x108>
  8036e0:	bf 20 00 00 00       	mov    $0x20,%edi
  8036e5:	29 ef                	sub    %ebp,%edi
  8036e7:	89 fe                	mov    %edi,%esi
  8036e9:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  8036ed:	89 e9                	mov    %ebp,%ecx
  8036ef:	d3 e0                	shl    %cl,%eax
  8036f1:	89 d7                	mov    %edx,%edi
  8036f3:	89 f1                	mov    %esi,%ecx
  8036f5:	d3 ef                	shr    %cl,%edi
  8036f7:	09 c7                	or     %eax,%edi
  8036f9:	89 e9                	mov    %ebp,%ecx
  8036fb:	d3 e2                	shl    %cl,%edx
  8036fd:	89 14 24             	mov    %edx,(%esp)
  803700:	89 d8                	mov    %ebx,%eax
  803702:	d3 e0                	shl    %cl,%eax
  803704:	89 c2                	mov    %eax,%edx
  803706:	8b 44 24 08          	mov    0x8(%esp),%eax
  80370a:	d3 e0                	shl    %cl,%eax
  80370c:	89 44 24 04          	mov    %eax,0x4(%esp)
  803710:	8b 44 24 08          	mov    0x8(%esp),%eax
  803714:	89 f1                	mov    %esi,%ecx
  803716:	d3 e8                	shr    %cl,%eax
  803718:	09 d0                	or     %edx,%eax
  80371a:	d3 eb                	shr    %cl,%ebx
  80371c:	89 da                	mov    %ebx,%edx
  80371e:	f7 f7                	div    %edi
  803720:	89 d3                	mov    %edx,%ebx
  803722:	f7 24 24             	mull   (%esp)
  803725:	89 c6                	mov    %eax,%esi
  803727:	89 d1                	mov    %edx,%ecx
  803729:	39 d3                	cmp    %edx,%ebx
  80372b:	0f 82 87 00 00 00    	jb     8037b8 <__umoddi3+0x134>
  803731:	0f 84 91 00 00 00    	je     8037c8 <__umoddi3+0x144>
  803737:	8b 54 24 04          	mov    0x4(%esp),%edx
  80373b:	29 f2                	sub    %esi,%edx
  80373d:	19 cb                	sbb    %ecx,%ebx
  80373f:	89 d8                	mov    %ebx,%eax
  803741:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  803745:	d3 e0                	shl    %cl,%eax
  803747:	89 e9                	mov    %ebp,%ecx
  803749:	d3 ea                	shr    %cl,%edx
  80374b:	09 d0                	or     %edx,%eax
  80374d:	89 e9                	mov    %ebp,%ecx
  80374f:	d3 eb                	shr    %cl,%ebx
  803751:	89 da                	mov    %ebx,%edx
  803753:	83 c4 1c             	add    $0x1c,%esp
  803756:	5b                   	pop    %ebx
  803757:	5e                   	pop    %esi
  803758:	5f                   	pop    %edi
  803759:	5d                   	pop    %ebp
  80375a:	c3                   	ret    
  80375b:	90                   	nop
  80375c:	89 fd                	mov    %edi,%ebp
  80375e:	85 ff                	test   %edi,%edi
  803760:	75 0b                	jne    80376d <__umoddi3+0xe9>
  803762:	b8 01 00 00 00       	mov    $0x1,%eax
  803767:	31 d2                	xor    %edx,%edx
  803769:	f7 f7                	div    %edi
  80376b:	89 c5                	mov    %eax,%ebp
  80376d:	89 f0                	mov    %esi,%eax
  80376f:	31 d2                	xor    %edx,%edx
  803771:	f7 f5                	div    %ebp
  803773:	89 c8                	mov    %ecx,%eax
  803775:	f7 f5                	div    %ebp
  803777:	89 d0                	mov    %edx,%eax
  803779:	e9 44 ff ff ff       	jmp    8036c2 <__umoddi3+0x3e>
  80377e:	66 90                	xchg   %ax,%ax
  803780:	89 c8                	mov    %ecx,%eax
  803782:	89 f2                	mov    %esi,%edx
  803784:	83 c4 1c             	add    $0x1c,%esp
  803787:	5b                   	pop    %ebx
  803788:	5e                   	pop    %esi
  803789:	5f                   	pop    %edi
  80378a:	5d                   	pop    %ebp
  80378b:	c3                   	ret    
  80378c:	3b 04 24             	cmp    (%esp),%eax
  80378f:	72 06                	jb     803797 <__umoddi3+0x113>
  803791:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  803795:	77 0f                	ja     8037a6 <__umoddi3+0x122>
  803797:	89 f2                	mov    %esi,%edx
  803799:	29 f9                	sub    %edi,%ecx
  80379b:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  80379f:	89 14 24             	mov    %edx,(%esp)
  8037a2:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8037a6:	8b 44 24 04          	mov    0x4(%esp),%eax
  8037aa:	8b 14 24             	mov    (%esp),%edx
  8037ad:	83 c4 1c             	add    $0x1c,%esp
  8037b0:	5b                   	pop    %ebx
  8037b1:	5e                   	pop    %esi
  8037b2:	5f                   	pop    %edi
  8037b3:	5d                   	pop    %ebp
  8037b4:	c3                   	ret    
  8037b5:	8d 76 00             	lea    0x0(%esi),%esi
  8037b8:	2b 04 24             	sub    (%esp),%eax
  8037bb:	19 fa                	sbb    %edi,%edx
  8037bd:	89 d1                	mov    %edx,%ecx
  8037bf:	89 c6                	mov    %eax,%esi
  8037c1:	e9 71 ff ff ff       	jmp    803737 <__umoddi3+0xb3>
  8037c6:	66 90                	xchg   %ax,%ax
  8037c8:	39 44 24 04          	cmp    %eax,0x4(%esp)
  8037cc:	72 ea                	jb     8037b8 <__umoddi3+0x134>
  8037ce:	89 d9                	mov    %ebx,%ecx
  8037d0:	e9 62 ff ff ff       	jmp    803737 <__umoddi3+0xb3>
