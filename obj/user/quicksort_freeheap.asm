
obj/user/quicksort_freeheap:     file format elf32-i386


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
  800031:	e8 b4 05 00 00       	call   8005ea <libmain>
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
  80003b:	53                   	push   %ebx
  80003c:	81 ec 24 01 00 00    	sub    $0x124,%esp
	char Chose ;
	char Line[255] ;
	int Iteration = 0 ;
  800042:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	do
	{
		int InitFreeFrames = sys_calculate_free_frames() + sys_calculate_modified_frames();
  800049:	e8 30 1f 00 00       	call   801f7e <sys_calculate_free_frames>
  80004e:	89 c3                	mov    %eax,%ebx
  800050:	e8 42 1f 00 00       	call   801f97 <sys_calculate_modified_frames>
  800055:	01 d8                	add    %ebx,%eax
  800057:	89 45 f0             	mov    %eax,-0x10(%ebp)

		Iteration++ ;
  80005a:	ff 45 f4             	incl   -0xc(%ebp)
		//		cprintf("Free Frames Before Allocation = %d\n", sys_calculate_free_frames()) ;

		//	sys_disable_interrupt();

		readline("Enter the number of elements: ", Line);
  80005d:	83 ec 08             	sub    $0x8,%esp
  800060:	8d 85 e1 fe ff ff    	lea    -0x11f(%ebp),%eax
  800066:	50                   	push   %eax
  800067:	68 80 37 80 00       	push   $0x803780
  80006c:	e8 eb 0f 00 00       	call   80105c <readline>
  800071:	83 c4 10             	add    $0x10,%esp
		int NumOfElements = strtol(Line, NULL, 10) ;
  800074:	83 ec 04             	sub    $0x4,%esp
  800077:	6a 0a                	push   $0xa
  800079:	6a 00                	push   $0x0
  80007b:	8d 85 e1 fe ff ff    	lea    -0x11f(%ebp),%eax
  800081:	50                   	push   %eax
  800082:	e8 3b 15 00 00       	call   8015c2 <strtol>
  800087:	83 c4 10             	add    $0x10,%esp
  80008a:	89 45 ec             	mov    %eax,-0x14(%ebp)
		int *Elements = malloc(sizeof(int) * NumOfElements) ;
  80008d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800090:	c1 e0 02             	shl    $0x2,%eax
  800093:	83 ec 0c             	sub    $0xc,%esp
  800096:	50                   	push   %eax
  800097:	e8 d6 1a 00 00       	call   801b72 <malloc>
  80009c:	83 c4 10             	add    $0x10,%esp
  80009f:	89 45 e8             	mov    %eax,-0x18(%ebp)
		cprintf("Choose the initialization method:\n") ;
  8000a2:	83 ec 0c             	sub    $0xc,%esp
  8000a5:	68 a0 37 80 00       	push   $0x8037a0
  8000aa:	e8 2b 09 00 00       	call   8009da <cprintf>
  8000af:	83 c4 10             	add    $0x10,%esp
		cprintf("a) Ascending\n") ;
  8000b2:	83 ec 0c             	sub    $0xc,%esp
  8000b5:	68 c3 37 80 00       	push   $0x8037c3
  8000ba:	e8 1b 09 00 00       	call   8009da <cprintf>
  8000bf:	83 c4 10             	add    $0x10,%esp
		cprintf("b) Descending\n") ;
  8000c2:	83 ec 0c             	sub    $0xc,%esp
  8000c5:	68 d1 37 80 00       	push   $0x8037d1
  8000ca:	e8 0b 09 00 00       	call   8009da <cprintf>
  8000cf:	83 c4 10             	add    $0x10,%esp
		cprintf("c) Semi random\n");
  8000d2:	83 ec 0c             	sub    $0xc,%esp
  8000d5:	68 e0 37 80 00       	push   $0x8037e0
  8000da:	e8 fb 08 00 00       	call   8009da <cprintf>
  8000df:	83 c4 10             	add    $0x10,%esp
		do
		{
			cprintf("Select: ") ;
  8000e2:	83 ec 0c             	sub    $0xc,%esp
  8000e5:	68 f0 37 80 00       	push   $0x8037f0
  8000ea:	e8 eb 08 00 00       	call   8009da <cprintf>
  8000ef:	83 c4 10             	add    $0x10,%esp
			Chose = getchar() ;
  8000f2:	e8 9b 04 00 00       	call   800592 <getchar>
  8000f7:	88 45 e7             	mov    %al,-0x19(%ebp)
			cputchar(Chose);
  8000fa:	0f be 45 e7          	movsbl -0x19(%ebp),%eax
  8000fe:	83 ec 0c             	sub    $0xc,%esp
  800101:	50                   	push   %eax
  800102:	e8 43 04 00 00       	call   80054a <cputchar>
  800107:	83 c4 10             	add    $0x10,%esp
			cputchar('\n');
  80010a:	83 ec 0c             	sub    $0xc,%esp
  80010d:	6a 0a                	push   $0xa
  80010f:	e8 36 04 00 00       	call   80054a <cputchar>
  800114:	83 c4 10             	add    $0x10,%esp
		} while (Chose != 'a' && Chose != 'b' && Chose != 'c');
  800117:	80 7d e7 61          	cmpb   $0x61,-0x19(%ebp)
  80011b:	74 0c                	je     800129 <_main+0xf1>
  80011d:	80 7d e7 62          	cmpb   $0x62,-0x19(%ebp)
  800121:	74 06                	je     800129 <_main+0xf1>
  800123:	80 7d e7 63          	cmpb   $0x63,-0x19(%ebp)
  800127:	75 b9                	jne    8000e2 <_main+0xaa>
		//sys_enable_interrupt();
		int  i ;
		switch (Chose)
  800129:	0f be 45 e7          	movsbl -0x19(%ebp),%eax
  80012d:	83 f8 62             	cmp    $0x62,%eax
  800130:	74 1d                	je     80014f <_main+0x117>
  800132:	83 f8 63             	cmp    $0x63,%eax
  800135:	74 2b                	je     800162 <_main+0x12a>
  800137:	83 f8 61             	cmp    $0x61,%eax
  80013a:	75 39                	jne    800175 <_main+0x13d>
		{
		case 'a':
			InitializeAscending(Elements, NumOfElements);
  80013c:	83 ec 08             	sub    $0x8,%esp
  80013f:	ff 75 ec             	pushl  -0x14(%ebp)
  800142:	ff 75 e8             	pushl  -0x18(%ebp)
  800145:	e8 c8 02 00 00       	call   800412 <InitializeAscending>
  80014a:	83 c4 10             	add    $0x10,%esp
			break ;
  80014d:	eb 37                	jmp    800186 <_main+0x14e>
		case 'b':
			InitializeDescending(Elements, NumOfElements);
  80014f:	83 ec 08             	sub    $0x8,%esp
  800152:	ff 75 ec             	pushl  -0x14(%ebp)
  800155:	ff 75 e8             	pushl  -0x18(%ebp)
  800158:	e8 e6 02 00 00       	call   800443 <InitializeDescending>
  80015d:	83 c4 10             	add    $0x10,%esp
			break ;
  800160:	eb 24                	jmp    800186 <_main+0x14e>
		case 'c':
			InitializeSemiRandom(Elements, NumOfElements);
  800162:	83 ec 08             	sub    $0x8,%esp
  800165:	ff 75 ec             	pushl  -0x14(%ebp)
  800168:	ff 75 e8             	pushl  -0x18(%ebp)
  80016b:	e8 08 03 00 00       	call   800478 <InitializeSemiRandom>
  800170:	83 c4 10             	add    $0x10,%esp
			break ;
  800173:	eb 11                	jmp    800186 <_main+0x14e>
		default:
			InitializeSemiRandom(Elements, NumOfElements);
  800175:	83 ec 08             	sub    $0x8,%esp
  800178:	ff 75 ec             	pushl  -0x14(%ebp)
  80017b:	ff 75 e8             	pushl  -0x18(%ebp)
  80017e:	e8 f5 02 00 00       	call   800478 <InitializeSemiRandom>
  800183:	83 c4 10             	add    $0x10,%esp
		}

		QuickSort(Elements, NumOfElements);
  800186:	83 ec 08             	sub    $0x8,%esp
  800189:	ff 75 ec             	pushl  -0x14(%ebp)
  80018c:	ff 75 e8             	pushl  -0x18(%ebp)
  80018f:	e8 c3 00 00 00       	call   800257 <QuickSort>
  800194:	83 c4 10             	add    $0x10,%esp

		//		PrintElements(Elements, NumOfElements);

		uint32 Sorted = CheckSorted(Elements, NumOfElements);
  800197:	83 ec 08             	sub    $0x8,%esp
  80019a:	ff 75 ec             	pushl  -0x14(%ebp)
  80019d:	ff 75 e8             	pushl  -0x18(%ebp)
  8001a0:	e8 c3 01 00 00       	call   800368 <CheckSorted>
  8001a5:	83 c4 10             	add    $0x10,%esp
  8001a8:	89 45 e0             	mov    %eax,-0x20(%ebp)

		if(Sorted == 0) panic("The array is NOT sorted correctly") ;
  8001ab:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8001af:	75 14                	jne    8001c5 <_main+0x18d>
  8001b1:	83 ec 04             	sub    $0x4,%esp
  8001b4:	68 fc 37 80 00       	push   $0x8037fc
  8001b9:	6a 45                	push   $0x45
  8001bb:	68 1e 38 80 00       	push   $0x80381e
  8001c0:	e8 61 05 00 00       	call   800726 <_panic>
		else
		{ 
			cprintf("===============================================\n") ;
  8001c5:	83 ec 0c             	sub    $0xc,%esp
  8001c8:	68 38 38 80 00       	push   $0x803838
  8001cd:	e8 08 08 00 00       	call   8009da <cprintf>
  8001d2:	83 c4 10             	add    $0x10,%esp
			cprintf("Congratulations!! The array is sorted correctly\n") ;
  8001d5:	83 ec 0c             	sub    $0xc,%esp
  8001d8:	68 6c 38 80 00       	push   $0x80386c
  8001dd:	e8 f8 07 00 00       	call   8009da <cprintf>
  8001e2:	83 c4 10             	add    $0x10,%esp
			cprintf("===============================================\n\n") ;
  8001e5:	83 ec 0c             	sub    $0xc,%esp
  8001e8:	68 a0 38 80 00       	push   $0x8038a0
  8001ed:	e8 e8 07 00 00       	call   8009da <cprintf>
  8001f2:	83 c4 10             	add    $0x10,%esp
		}

		//		cprintf("Free Frames After Calculation = %d\n", sys_calculate_free_frames()) ;

		cprintf("Freeing the Heap...\n\n") ;
  8001f5:	83 ec 0c             	sub    $0xc,%esp
  8001f8:	68 d2 38 80 00       	push   $0x8038d2
  8001fd:	e8 d8 07 00 00       	call   8009da <cprintf>
  800202:	83 c4 10             	add    $0x10,%esp

		//freeHeap() ;

		///========================================================================
		//sys_disable_interrupt();
		cprintf("Do you want to repeat (y/n): ") ;
  800205:	83 ec 0c             	sub    $0xc,%esp
  800208:	68 e8 38 80 00       	push   $0x8038e8
  80020d:	e8 c8 07 00 00       	call   8009da <cprintf>
  800212:	83 c4 10             	add    $0x10,%esp
		Chose = getchar() ;
  800215:	e8 78 03 00 00       	call   800592 <getchar>
  80021a:	88 45 e7             	mov    %al,-0x19(%ebp)
		cputchar(Chose);
  80021d:	0f be 45 e7          	movsbl -0x19(%ebp),%eax
  800221:	83 ec 0c             	sub    $0xc,%esp
  800224:	50                   	push   %eax
  800225:	e8 20 03 00 00       	call   80054a <cputchar>
  80022a:	83 c4 10             	add    $0x10,%esp
		cputchar('\n');
  80022d:	83 ec 0c             	sub    $0xc,%esp
  800230:	6a 0a                	push   $0xa
  800232:	e8 13 03 00 00       	call   80054a <cputchar>
  800237:	83 c4 10             	add    $0x10,%esp
		cputchar('\n');
  80023a:	83 ec 0c             	sub    $0xc,%esp
  80023d:	6a 0a                	push   $0xa
  80023f:	e8 06 03 00 00       	call   80054a <cputchar>
  800244:	83 c4 10             	add    $0x10,%esp
		//sys_enable_interrupt();

	} while (Chose == 'y');
  800247:	80 7d e7 79          	cmpb   $0x79,-0x19(%ebp)
  80024b:	0f 84 f8 fd ff ff    	je     800049 <_main+0x11>

}
  800251:	90                   	nop
  800252:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800255:	c9                   	leave  
  800256:	c3                   	ret    

00800257 <QuickSort>:

///Quick sort 
void QuickSort(int *Elements, int NumOfElements)
{
  800257:	55                   	push   %ebp
  800258:	89 e5                	mov    %esp,%ebp
  80025a:	83 ec 08             	sub    $0x8,%esp
	QSort(Elements, NumOfElements, 0, NumOfElements-1) ;
  80025d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800260:	48                   	dec    %eax
  800261:	50                   	push   %eax
  800262:	6a 00                	push   $0x0
  800264:	ff 75 0c             	pushl  0xc(%ebp)
  800267:	ff 75 08             	pushl  0x8(%ebp)
  80026a:	e8 06 00 00 00       	call   800275 <QSort>
  80026f:	83 c4 10             	add    $0x10,%esp
}
  800272:	90                   	nop
  800273:	c9                   	leave  
  800274:	c3                   	ret    

00800275 <QSort>:


void QSort(int *Elements,int NumOfElements, int startIndex, int finalIndex)
{
  800275:	55                   	push   %ebp
  800276:	89 e5                	mov    %esp,%ebp
  800278:	83 ec 18             	sub    $0x18,%esp
	if (startIndex >= finalIndex) return;
  80027b:	8b 45 10             	mov    0x10(%ebp),%eax
  80027e:	3b 45 14             	cmp    0x14(%ebp),%eax
  800281:	0f 8d de 00 00 00    	jge    800365 <QSort+0xf0>

	int i = startIndex+1, j = finalIndex;
  800287:	8b 45 10             	mov    0x10(%ebp),%eax
  80028a:	40                   	inc    %eax
  80028b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80028e:	8b 45 14             	mov    0x14(%ebp),%eax
  800291:	89 45 f0             	mov    %eax,-0x10(%ebp)

	while (i <= j)
  800294:	e9 80 00 00 00       	jmp    800319 <QSort+0xa4>
	{
		while (i <= finalIndex && Elements[startIndex] >= Elements[i]) i++;
  800299:	ff 45 f4             	incl   -0xc(%ebp)
  80029c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80029f:	3b 45 14             	cmp    0x14(%ebp),%eax
  8002a2:	7f 2b                	jg     8002cf <QSort+0x5a>
  8002a4:	8b 45 10             	mov    0x10(%ebp),%eax
  8002a7:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8002ae:	8b 45 08             	mov    0x8(%ebp),%eax
  8002b1:	01 d0                	add    %edx,%eax
  8002b3:	8b 10                	mov    (%eax),%edx
  8002b5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8002b8:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  8002bf:	8b 45 08             	mov    0x8(%ebp),%eax
  8002c2:	01 c8                	add    %ecx,%eax
  8002c4:	8b 00                	mov    (%eax),%eax
  8002c6:	39 c2                	cmp    %eax,%edx
  8002c8:	7d cf                	jge    800299 <QSort+0x24>
		while (j > startIndex && Elements[startIndex] <= Elements[j]) j--;
  8002ca:	eb 03                	jmp    8002cf <QSort+0x5a>
  8002cc:	ff 4d f0             	decl   -0x10(%ebp)
  8002cf:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8002d2:	3b 45 10             	cmp    0x10(%ebp),%eax
  8002d5:	7e 26                	jle    8002fd <QSort+0x88>
  8002d7:	8b 45 10             	mov    0x10(%ebp),%eax
  8002da:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8002e1:	8b 45 08             	mov    0x8(%ebp),%eax
  8002e4:	01 d0                	add    %edx,%eax
  8002e6:	8b 10                	mov    (%eax),%edx
  8002e8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8002eb:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  8002f2:	8b 45 08             	mov    0x8(%ebp),%eax
  8002f5:	01 c8                	add    %ecx,%eax
  8002f7:	8b 00                	mov    (%eax),%eax
  8002f9:	39 c2                	cmp    %eax,%edx
  8002fb:	7e cf                	jle    8002cc <QSort+0x57>

		if (i <= j)
  8002fd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800300:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800303:	7f 14                	jg     800319 <QSort+0xa4>
		{
			Swap(Elements, i, j);
  800305:	83 ec 04             	sub    $0x4,%esp
  800308:	ff 75 f0             	pushl  -0x10(%ebp)
  80030b:	ff 75 f4             	pushl  -0xc(%ebp)
  80030e:	ff 75 08             	pushl  0x8(%ebp)
  800311:	e8 a9 00 00 00       	call   8003bf <Swap>
  800316:	83 c4 10             	add    $0x10,%esp
{
	if (startIndex >= finalIndex) return;

	int i = startIndex+1, j = finalIndex;

	while (i <= j)
  800319:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80031c:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80031f:	0f 8e 77 ff ff ff    	jle    80029c <QSort+0x27>
		{
			Swap(Elements, i, j);
		}
	}

	Swap( Elements, startIndex, j);
  800325:	83 ec 04             	sub    $0x4,%esp
  800328:	ff 75 f0             	pushl  -0x10(%ebp)
  80032b:	ff 75 10             	pushl  0x10(%ebp)
  80032e:	ff 75 08             	pushl  0x8(%ebp)
  800331:	e8 89 00 00 00       	call   8003bf <Swap>
  800336:	83 c4 10             	add    $0x10,%esp

	QSort(Elements, NumOfElements, startIndex, j - 1);
  800339:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80033c:	48                   	dec    %eax
  80033d:	50                   	push   %eax
  80033e:	ff 75 10             	pushl  0x10(%ebp)
  800341:	ff 75 0c             	pushl  0xc(%ebp)
  800344:	ff 75 08             	pushl  0x8(%ebp)
  800347:	e8 29 ff ff ff       	call   800275 <QSort>
  80034c:	83 c4 10             	add    $0x10,%esp
	QSort(Elements, NumOfElements, i, finalIndex);
  80034f:	ff 75 14             	pushl  0x14(%ebp)
  800352:	ff 75 f4             	pushl  -0xc(%ebp)
  800355:	ff 75 0c             	pushl  0xc(%ebp)
  800358:	ff 75 08             	pushl  0x8(%ebp)
  80035b:	e8 15 ff ff ff       	call   800275 <QSort>
  800360:	83 c4 10             	add    $0x10,%esp
  800363:	eb 01                	jmp    800366 <QSort+0xf1>
}


void QSort(int *Elements,int NumOfElements, int startIndex, int finalIndex)
{
	if (startIndex >= finalIndex) return;
  800365:	90                   	nop

	Swap( Elements, startIndex, j);

	QSort(Elements, NumOfElements, startIndex, j - 1);
	QSort(Elements, NumOfElements, i, finalIndex);
}
  800366:	c9                   	leave  
  800367:	c3                   	ret    

00800368 <CheckSorted>:

uint32 CheckSorted(int *Elements, int NumOfElements)
{
  800368:	55                   	push   %ebp
  800369:	89 e5                	mov    %esp,%ebp
  80036b:	83 ec 10             	sub    $0x10,%esp
	uint32 Sorted = 1 ;
  80036e:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
	int i ;
	for (i = 0 ; i < NumOfElements - 1; i++)
  800375:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  80037c:	eb 33                	jmp    8003b1 <CheckSorted+0x49>
	{
		if (Elements[i] > Elements[i+1])
  80037e:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800381:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800388:	8b 45 08             	mov    0x8(%ebp),%eax
  80038b:	01 d0                	add    %edx,%eax
  80038d:	8b 10                	mov    (%eax),%edx
  80038f:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800392:	40                   	inc    %eax
  800393:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  80039a:	8b 45 08             	mov    0x8(%ebp),%eax
  80039d:	01 c8                	add    %ecx,%eax
  80039f:	8b 00                	mov    (%eax),%eax
  8003a1:	39 c2                	cmp    %eax,%edx
  8003a3:	7e 09                	jle    8003ae <CheckSorted+0x46>
		{
			Sorted = 0 ;
  8003a5:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
			break;
  8003ac:	eb 0c                	jmp    8003ba <CheckSorted+0x52>

uint32 CheckSorted(int *Elements, int NumOfElements)
{
	uint32 Sorted = 1 ;
	int i ;
	for (i = 0 ; i < NumOfElements - 1; i++)
  8003ae:	ff 45 f8             	incl   -0x8(%ebp)
  8003b1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8003b4:	48                   	dec    %eax
  8003b5:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  8003b8:	7f c4                	jg     80037e <CheckSorted+0x16>
		{
			Sorted = 0 ;
			break;
		}
	}
	return Sorted ;
  8003ba:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  8003bd:	c9                   	leave  
  8003be:	c3                   	ret    

008003bf <Swap>:

///Private Functions


void Swap(int *Elements, int First, int Second)
{
  8003bf:	55                   	push   %ebp
  8003c0:	89 e5                	mov    %esp,%ebp
  8003c2:	83 ec 10             	sub    $0x10,%esp
	int Tmp = Elements[First] ;
  8003c5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8003c8:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8003cf:	8b 45 08             	mov    0x8(%ebp),%eax
  8003d2:	01 d0                	add    %edx,%eax
  8003d4:	8b 00                	mov    (%eax),%eax
  8003d6:	89 45 fc             	mov    %eax,-0x4(%ebp)
	Elements[First] = Elements[Second] ;
  8003d9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8003dc:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8003e3:	8b 45 08             	mov    0x8(%ebp),%eax
  8003e6:	01 c2                	add    %eax,%edx
  8003e8:	8b 45 10             	mov    0x10(%ebp),%eax
  8003eb:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  8003f2:	8b 45 08             	mov    0x8(%ebp),%eax
  8003f5:	01 c8                	add    %ecx,%eax
  8003f7:	8b 00                	mov    (%eax),%eax
  8003f9:	89 02                	mov    %eax,(%edx)
	Elements[Second] = Tmp ;
  8003fb:	8b 45 10             	mov    0x10(%ebp),%eax
  8003fe:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800405:	8b 45 08             	mov    0x8(%ebp),%eax
  800408:	01 c2                	add    %eax,%edx
  80040a:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80040d:	89 02                	mov    %eax,(%edx)
}
  80040f:	90                   	nop
  800410:	c9                   	leave  
  800411:	c3                   	ret    

00800412 <InitializeAscending>:

void InitializeAscending(int *Elements, int NumOfElements)
{
  800412:	55                   	push   %ebp
  800413:	89 e5                	mov    %esp,%ebp
  800415:	83 ec 10             	sub    $0x10,%esp
	int i ;
	for (i = 0 ; i < NumOfElements ; i++)
  800418:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  80041f:	eb 17                	jmp    800438 <InitializeAscending+0x26>
	{
		(Elements)[i] = i ;
  800421:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800424:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80042b:	8b 45 08             	mov    0x8(%ebp),%eax
  80042e:	01 c2                	add    %eax,%edx
  800430:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800433:	89 02                	mov    %eax,(%edx)
}

void InitializeAscending(int *Elements, int NumOfElements)
{
	int i ;
	for (i = 0 ; i < NumOfElements ; i++)
  800435:	ff 45 fc             	incl   -0x4(%ebp)
  800438:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80043b:	3b 45 0c             	cmp    0xc(%ebp),%eax
  80043e:	7c e1                	jl     800421 <InitializeAscending+0xf>
	{
		(Elements)[i] = i ;
	}

}
  800440:	90                   	nop
  800441:	c9                   	leave  
  800442:	c3                   	ret    

00800443 <InitializeDescending>:

void InitializeDescending(int *Elements, int NumOfElements)
{
  800443:	55                   	push   %ebp
  800444:	89 e5                	mov    %esp,%ebp
  800446:	83 ec 10             	sub    $0x10,%esp
	int i ;
	for (i = 0 ; i < NumOfElements ; i++)
  800449:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800450:	eb 1b                	jmp    80046d <InitializeDescending+0x2a>
	{
		Elements[i] = NumOfElements - i - 1 ;
  800452:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800455:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80045c:	8b 45 08             	mov    0x8(%ebp),%eax
  80045f:	01 c2                	add    %eax,%edx
  800461:	8b 45 0c             	mov    0xc(%ebp),%eax
  800464:	2b 45 fc             	sub    -0x4(%ebp),%eax
  800467:	48                   	dec    %eax
  800468:	89 02                	mov    %eax,(%edx)
}

void InitializeDescending(int *Elements, int NumOfElements)
{
	int i ;
	for (i = 0 ; i < NumOfElements ; i++)
  80046a:	ff 45 fc             	incl   -0x4(%ebp)
  80046d:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800470:	3b 45 0c             	cmp    0xc(%ebp),%eax
  800473:	7c dd                	jl     800452 <InitializeDescending+0xf>
	{
		Elements[i] = NumOfElements - i - 1 ;
	}

}
  800475:	90                   	nop
  800476:	c9                   	leave  
  800477:	c3                   	ret    

00800478 <InitializeSemiRandom>:

void InitializeSemiRandom(int *Elements, int NumOfElements)
{
  800478:	55                   	push   %ebp
  800479:	89 e5                	mov    %esp,%ebp
  80047b:	83 ec 10             	sub    $0x10,%esp
	int i ;
	int Repetition = NumOfElements / 3 ;
  80047e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800481:	b8 56 55 55 55       	mov    $0x55555556,%eax
  800486:	f7 e9                	imul   %ecx
  800488:	c1 f9 1f             	sar    $0x1f,%ecx
  80048b:	89 d0                	mov    %edx,%eax
  80048d:	29 c8                	sub    %ecx,%eax
  80048f:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0 ; i < NumOfElements ; i++)
  800492:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800499:	eb 1e                	jmp    8004b9 <InitializeSemiRandom+0x41>
	{
		Elements[i] = i % Repetition ;
  80049b:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80049e:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8004a5:	8b 45 08             	mov    0x8(%ebp),%eax
  8004a8:	8d 0c 02             	lea    (%edx,%eax,1),%ecx
  8004ab:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8004ae:	99                   	cltd   
  8004af:	f7 7d f8             	idivl  -0x8(%ebp)
  8004b2:	89 d0                	mov    %edx,%eax
  8004b4:	89 01                	mov    %eax,(%ecx)

void InitializeSemiRandom(int *Elements, int NumOfElements)
{
	int i ;
	int Repetition = NumOfElements / 3 ;
	for (i = 0 ; i < NumOfElements ; i++)
  8004b6:	ff 45 fc             	incl   -0x4(%ebp)
  8004b9:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8004bc:	3b 45 0c             	cmp    0xc(%ebp),%eax
  8004bf:	7c da                	jl     80049b <InitializeSemiRandom+0x23>
	{
		Elements[i] = i % Repetition ;
	}

}
  8004c1:	90                   	nop
  8004c2:	c9                   	leave  
  8004c3:	c3                   	ret    

008004c4 <PrintElements>:

void PrintElements(int *Elements, int NumOfElements)
{
  8004c4:	55                   	push   %ebp
  8004c5:	89 e5                	mov    %esp,%ebp
  8004c7:	83 ec 18             	sub    $0x18,%esp
	int i ;
	int NumsPerLine = 20 ;
  8004ca:	c7 45 f0 14 00 00 00 	movl   $0x14,-0x10(%ebp)
	for (i = 0 ; i < NumOfElements-1 ; i++)
  8004d1:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  8004d8:	eb 42                	jmp    80051c <PrintElements+0x58>
	{
		if (i%NumsPerLine == 0)
  8004da:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8004dd:	99                   	cltd   
  8004de:	f7 7d f0             	idivl  -0x10(%ebp)
  8004e1:	89 d0                	mov    %edx,%eax
  8004e3:	85 c0                	test   %eax,%eax
  8004e5:	75 10                	jne    8004f7 <PrintElements+0x33>
			cprintf("\n");
  8004e7:	83 ec 0c             	sub    $0xc,%esp
  8004ea:	68 06 39 80 00       	push   $0x803906
  8004ef:	e8 e6 04 00 00       	call   8009da <cprintf>
  8004f4:	83 c4 10             	add    $0x10,%esp
		cprintf("%d, ",Elements[i]);
  8004f7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8004fa:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800501:	8b 45 08             	mov    0x8(%ebp),%eax
  800504:	01 d0                	add    %edx,%eax
  800506:	8b 00                	mov    (%eax),%eax
  800508:	83 ec 08             	sub    $0x8,%esp
  80050b:	50                   	push   %eax
  80050c:	68 08 39 80 00       	push   $0x803908
  800511:	e8 c4 04 00 00       	call   8009da <cprintf>
  800516:	83 c4 10             	add    $0x10,%esp

void PrintElements(int *Elements, int NumOfElements)
{
	int i ;
	int NumsPerLine = 20 ;
	for (i = 0 ; i < NumOfElements-1 ; i++)
  800519:	ff 45 f4             	incl   -0xc(%ebp)
  80051c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80051f:	48                   	dec    %eax
  800520:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  800523:	7f b5                	jg     8004da <PrintElements+0x16>
	{
		if (i%NumsPerLine == 0)
			cprintf("\n");
		cprintf("%d, ",Elements[i]);
	}
	cprintf("%d\n",Elements[i]);
  800525:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800528:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80052f:	8b 45 08             	mov    0x8(%ebp),%eax
  800532:	01 d0                	add    %edx,%eax
  800534:	8b 00                	mov    (%eax),%eax
  800536:	83 ec 08             	sub    $0x8,%esp
  800539:	50                   	push   %eax
  80053a:	68 0d 39 80 00       	push   $0x80390d
  80053f:	e8 96 04 00 00       	call   8009da <cprintf>
  800544:	83 c4 10             	add    $0x10,%esp
}
  800547:	90                   	nop
  800548:	c9                   	leave  
  800549:	c3                   	ret    

0080054a <cputchar>:
#include <inc/lib.h>


void
cputchar(int ch)
{
  80054a:	55                   	push   %ebp
  80054b:	89 e5                	mov    %esp,%ebp
  80054d:	83 ec 18             	sub    $0x18,%esp
	char c = ch;
  800550:	8b 45 08             	mov    0x8(%ebp),%eax
  800553:	88 45 f7             	mov    %al,-0x9(%ebp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	//sys_cputs(&c, 1);

	sys_cputc(c);
  800556:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
  80055a:	83 ec 0c             	sub    $0xc,%esp
  80055d:	50                   	push   %eax
  80055e:	e8 3c 1b 00 00       	call   80209f <sys_cputc>
  800563:	83 c4 10             	add    $0x10,%esp
}
  800566:	90                   	nop
  800567:	c9                   	leave  
  800568:	c3                   	ret    

00800569 <atomic_cputchar>:


void
atomic_cputchar(int ch)
{
  800569:	55                   	push   %ebp
  80056a:	89 e5                	mov    %esp,%ebp
  80056c:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  80056f:	e8 f7 1a 00 00       	call   80206b <sys_disable_interrupt>
	char c = ch;
  800574:	8b 45 08             	mov    0x8(%ebp),%eax
  800577:	88 45 f7             	mov    %al,-0x9(%ebp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	//sys_cputs(&c, 1);

	sys_cputc(c);
  80057a:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
  80057e:	83 ec 0c             	sub    $0xc,%esp
  800581:	50                   	push   %eax
  800582:	e8 18 1b 00 00       	call   80209f <sys_cputc>
  800587:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  80058a:	e8 f6 1a 00 00       	call   802085 <sys_enable_interrupt>
}
  80058f:	90                   	nop
  800590:	c9                   	leave  
  800591:	c3                   	ret    

00800592 <getchar>:

int
getchar(void)
{
  800592:	55                   	push   %ebp
  800593:	89 e5                	mov    %esp,%ebp
  800595:	83 ec 18             	sub    $0x18,%esp

	//return sys_cgetc();
	int c=0;
  800598:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	while(c == 0)
  80059f:	eb 08                	jmp    8005a9 <getchar+0x17>
	{
		c = sys_cgetc();
  8005a1:	e8 40 19 00 00       	call   801ee6 <sys_cgetc>
  8005a6:	89 45 f4             	mov    %eax,-0xc(%ebp)
getchar(void)
{

	//return sys_cgetc();
	int c=0;
	while(c == 0)
  8005a9:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8005ad:	74 f2                	je     8005a1 <getchar+0xf>
	{
		c = sys_cgetc();
	}
	return c;
  8005af:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  8005b2:	c9                   	leave  
  8005b3:	c3                   	ret    

008005b4 <atomic_getchar>:

int
atomic_getchar(void)
{
  8005b4:	55                   	push   %ebp
  8005b5:	89 e5                	mov    %esp,%ebp
  8005b7:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  8005ba:	e8 ac 1a 00 00       	call   80206b <sys_disable_interrupt>
	int c=0;
  8005bf:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	while(c == 0)
  8005c6:	eb 08                	jmp    8005d0 <atomic_getchar+0x1c>
	{
		c = sys_cgetc();
  8005c8:	e8 19 19 00 00       	call   801ee6 <sys_cgetc>
  8005cd:	89 45 f4             	mov    %eax,-0xc(%ebp)
int
atomic_getchar(void)
{
	sys_disable_interrupt();
	int c=0;
	while(c == 0)
  8005d0:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8005d4:	74 f2                	je     8005c8 <atomic_getchar+0x14>
	{
		c = sys_cgetc();
	}
	sys_enable_interrupt();
  8005d6:	e8 aa 1a 00 00       	call   802085 <sys_enable_interrupt>
	return c;
  8005db:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  8005de:	c9                   	leave  
  8005df:	c3                   	ret    

008005e0 <iscons>:

int iscons(int fdnum)
{
  8005e0:	55                   	push   %ebp
  8005e1:	89 e5                	mov    %esp,%ebp
	// used by readline
	return 1;
  8005e3:	b8 01 00 00 00       	mov    $0x1,%eax
}
  8005e8:	5d                   	pop    %ebp
  8005e9:	c3                   	ret    

008005ea <libmain>:
volatile struct Env *myEnv = NULL;
volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";

void
libmain(int argc, char **argv)
{
  8005ea:	55                   	push   %ebp
  8005eb:	89 e5                	mov    %esp,%ebp
  8005ed:	83 ec 18             	sub    $0x18,%esp
	int envIndex = sys_getenvindex();
  8005f0:	e8 69 1c 00 00       	call   80225e <sys_getenvindex>
  8005f5:	89 45 f4             	mov    %eax,-0xc(%ebp)
	myEnv = &(envs[envIndex]);
  8005f8:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8005fb:	89 d0                	mov    %edx,%eax
  8005fd:	c1 e0 03             	shl    $0x3,%eax
  800600:	01 d0                	add    %edx,%eax
  800602:	01 c0                	add    %eax,%eax
  800604:	01 d0                	add    %edx,%eax
  800606:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80060d:	01 d0                	add    %edx,%eax
  80060f:	c1 e0 04             	shl    $0x4,%eax
  800612:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  800617:	a3 24 50 80 00       	mov    %eax,0x805024

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  80061c:	a1 24 50 80 00       	mov    0x805024,%eax
  800621:	8a 80 5c 05 00 00    	mov    0x55c(%eax),%al
  800627:	84 c0                	test   %al,%al
  800629:	74 0f                	je     80063a <libmain+0x50>
		binaryname = myEnv->prog_name;
  80062b:	a1 24 50 80 00       	mov    0x805024,%eax
  800630:	05 5c 05 00 00       	add    $0x55c,%eax
  800635:	a3 00 50 80 00       	mov    %eax,0x805000

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  80063a:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80063e:	7e 0a                	jle    80064a <libmain+0x60>
		binaryname = argv[0];
  800640:	8b 45 0c             	mov    0xc(%ebp),%eax
  800643:	8b 00                	mov    (%eax),%eax
  800645:	a3 00 50 80 00       	mov    %eax,0x805000

	// call user main routine
	_main(argc, argv);
  80064a:	83 ec 08             	sub    $0x8,%esp
  80064d:	ff 75 0c             	pushl  0xc(%ebp)
  800650:	ff 75 08             	pushl  0x8(%ebp)
  800653:	e8 e0 f9 ff ff       	call   800038 <_main>
  800658:	83 c4 10             	add    $0x10,%esp



	sys_disable_interrupt();
  80065b:	e8 0b 1a 00 00       	call   80206b <sys_disable_interrupt>
	cprintf("**************************************\n");
  800660:	83 ec 0c             	sub    $0xc,%esp
  800663:	68 2c 39 80 00       	push   $0x80392c
  800668:	e8 6d 03 00 00       	call   8009da <cprintf>
  80066d:	83 c4 10             	add    $0x10,%esp
	cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  800670:	a1 24 50 80 00       	mov    0x805024,%eax
  800675:	8b 90 44 05 00 00    	mov    0x544(%eax),%edx
  80067b:	a1 24 50 80 00       	mov    0x805024,%eax
  800680:	8b 80 34 05 00 00    	mov    0x534(%eax),%eax
  800686:	83 ec 04             	sub    $0x4,%esp
  800689:	52                   	push   %edx
  80068a:	50                   	push   %eax
  80068b:	68 54 39 80 00       	push   $0x803954
  800690:	e8 45 03 00 00       	call   8009da <cprintf>
  800695:	83 c4 10             	add    $0x10,%esp
	cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  800698:	a1 24 50 80 00       	mov    0x805024,%eax
  80069d:	8b 88 54 05 00 00    	mov    0x554(%eax),%ecx
  8006a3:	a1 24 50 80 00       	mov    0x805024,%eax
  8006a8:	8b 90 50 05 00 00    	mov    0x550(%eax),%edx
  8006ae:	a1 24 50 80 00       	mov    0x805024,%eax
  8006b3:	8b 80 4c 05 00 00    	mov    0x54c(%eax),%eax
  8006b9:	51                   	push   %ecx
  8006ba:	52                   	push   %edx
  8006bb:	50                   	push   %eax
  8006bc:	68 7c 39 80 00       	push   $0x80397c
  8006c1:	e8 14 03 00 00       	call   8009da <cprintf>
  8006c6:	83 c4 10             	add    $0x10,%esp
	//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
	cprintf("Num of clocks = %d\n", myEnv->nClocks);
  8006c9:	a1 24 50 80 00       	mov    0x805024,%eax
  8006ce:	8b 80 a4 05 00 00    	mov    0x5a4(%eax),%eax
  8006d4:	83 ec 08             	sub    $0x8,%esp
  8006d7:	50                   	push   %eax
  8006d8:	68 d4 39 80 00       	push   $0x8039d4
  8006dd:	e8 f8 02 00 00       	call   8009da <cprintf>
  8006e2:	83 c4 10             	add    $0x10,%esp
	cprintf("**************************************\n");
  8006e5:	83 ec 0c             	sub    $0xc,%esp
  8006e8:	68 2c 39 80 00       	push   $0x80392c
  8006ed:	e8 e8 02 00 00       	call   8009da <cprintf>
  8006f2:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  8006f5:	e8 8b 19 00 00       	call   802085 <sys_enable_interrupt>

	// exit gracefully
	exit();
  8006fa:	e8 19 00 00 00       	call   800718 <exit>
}
  8006ff:	90                   	nop
  800700:	c9                   	leave  
  800701:	c3                   	ret    

00800702 <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  800702:	55                   	push   %ebp
  800703:	89 e5                	mov    %esp,%ebp
  800705:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  800708:	83 ec 0c             	sub    $0xc,%esp
  80070b:	6a 00                	push   $0x0
  80070d:	e8 18 1b 00 00       	call   80222a <sys_destroy_env>
  800712:	83 c4 10             	add    $0x10,%esp
}
  800715:	90                   	nop
  800716:	c9                   	leave  
  800717:	c3                   	ret    

00800718 <exit>:

void
exit(void)
{
  800718:	55                   	push   %ebp
  800719:	89 e5                	mov    %esp,%ebp
  80071b:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  80071e:	e8 6d 1b 00 00       	call   802290 <sys_exit_env>
}
  800723:	90                   	nop
  800724:	c9                   	leave  
  800725:	c3                   	ret    

00800726 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  800726:	55                   	push   %ebp
  800727:	89 e5                	mov    %esp,%ebp
  800729:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  80072c:	8d 45 10             	lea    0x10(%ebp),%eax
  80072f:	83 c0 04             	add    $0x4,%eax
  800732:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  800735:	a1 5c 51 80 00       	mov    0x80515c,%eax
  80073a:	85 c0                	test   %eax,%eax
  80073c:	74 16                	je     800754 <_panic+0x2e>
		cprintf("%s: ", argv0);
  80073e:	a1 5c 51 80 00       	mov    0x80515c,%eax
  800743:	83 ec 08             	sub    $0x8,%esp
  800746:	50                   	push   %eax
  800747:	68 e8 39 80 00       	push   $0x8039e8
  80074c:	e8 89 02 00 00       	call   8009da <cprintf>
  800751:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  800754:	a1 00 50 80 00       	mov    0x805000,%eax
  800759:	ff 75 0c             	pushl  0xc(%ebp)
  80075c:	ff 75 08             	pushl  0x8(%ebp)
  80075f:	50                   	push   %eax
  800760:	68 ed 39 80 00       	push   $0x8039ed
  800765:	e8 70 02 00 00       	call   8009da <cprintf>
  80076a:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  80076d:	8b 45 10             	mov    0x10(%ebp),%eax
  800770:	83 ec 08             	sub    $0x8,%esp
  800773:	ff 75 f4             	pushl  -0xc(%ebp)
  800776:	50                   	push   %eax
  800777:	e8 f3 01 00 00       	call   80096f <vcprintf>
  80077c:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  80077f:	83 ec 08             	sub    $0x8,%esp
  800782:	6a 00                	push   $0x0
  800784:	68 09 3a 80 00       	push   $0x803a09
  800789:	e8 e1 01 00 00       	call   80096f <vcprintf>
  80078e:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  800791:	e8 82 ff ff ff       	call   800718 <exit>

	// should not return here
	while (1) ;
  800796:	eb fe                	jmp    800796 <_panic+0x70>

00800798 <CheckWSWithoutLastIndex>:
}

void CheckWSWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  800798:	55                   	push   %ebp
  800799:	89 e5                	mov    %esp,%ebp
  80079b:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  80079e:	a1 24 50 80 00       	mov    0x805024,%eax
  8007a3:	8b 50 74             	mov    0x74(%eax),%edx
  8007a6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8007a9:	39 c2                	cmp    %eax,%edx
  8007ab:	74 14                	je     8007c1 <CheckWSWithoutLastIndex+0x29>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  8007ad:	83 ec 04             	sub    $0x4,%esp
  8007b0:	68 0c 3a 80 00       	push   $0x803a0c
  8007b5:	6a 26                	push   $0x26
  8007b7:	68 58 3a 80 00       	push   $0x803a58
  8007bc:	e8 65 ff ff ff       	call   800726 <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  8007c1:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  8007c8:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  8007cf:	e9 c2 00 00 00       	jmp    800896 <CheckWSWithoutLastIndex+0xfe>
		if (expectedPages[e] == 0) {
  8007d4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8007d7:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8007de:	8b 45 08             	mov    0x8(%ebp),%eax
  8007e1:	01 d0                	add    %edx,%eax
  8007e3:	8b 00                	mov    (%eax),%eax
  8007e5:	85 c0                	test   %eax,%eax
  8007e7:	75 08                	jne    8007f1 <CheckWSWithoutLastIndex+0x59>
			expectedNumOfEmptyLocs++;
  8007e9:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  8007ec:	e9 a2 00 00 00       	jmp    800893 <CheckWSWithoutLastIndex+0xfb>
		}
		int found = 0;
  8007f1:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8007f8:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  8007ff:	eb 69                	jmp    80086a <CheckWSWithoutLastIndex+0xd2>
			if (myEnv->__uptr_pws[w].empty == 0) {
  800801:	a1 24 50 80 00       	mov    0x805024,%eax
  800806:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  80080c:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80080f:	89 d0                	mov    %edx,%eax
  800811:	01 c0                	add    %eax,%eax
  800813:	01 d0                	add    %edx,%eax
  800815:	c1 e0 03             	shl    $0x3,%eax
  800818:	01 c8                	add    %ecx,%eax
  80081a:	8a 40 04             	mov    0x4(%eax),%al
  80081d:	84 c0                	test   %al,%al
  80081f:	75 46                	jne    800867 <CheckWSWithoutLastIndex+0xcf>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  800821:	a1 24 50 80 00       	mov    0x805024,%eax
  800826:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  80082c:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80082f:	89 d0                	mov    %edx,%eax
  800831:	01 c0                	add    %eax,%eax
  800833:	01 d0                	add    %edx,%eax
  800835:	c1 e0 03             	shl    $0x3,%eax
  800838:	01 c8                	add    %ecx,%eax
  80083a:	8b 00                	mov    (%eax),%eax
  80083c:	89 45 dc             	mov    %eax,-0x24(%ebp)
  80083f:	8b 45 dc             	mov    -0x24(%ebp),%eax
  800842:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800847:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  800849:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80084c:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  800853:	8b 45 08             	mov    0x8(%ebp),%eax
  800856:	01 c8                	add    %ecx,%eax
  800858:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  80085a:	39 c2                	cmp    %eax,%edx
  80085c:	75 09                	jne    800867 <CheckWSWithoutLastIndex+0xcf>
						== expectedPages[e]) {
					found = 1;
  80085e:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  800865:	eb 12                	jmp    800879 <CheckWSWithoutLastIndex+0xe1>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800867:	ff 45 e8             	incl   -0x18(%ebp)
  80086a:	a1 24 50 80 00       	mov    0x805024,%eax
  80086f:	8b 50 74             	mov    0x74(%eax),%edx
  800872:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800875:	39 c2                	cmp    %eax,%edx
  800877:	77 88                	ja     800801 <CheckWSWithoutLastIndex+0x69>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  800879:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  80087d:	75 14                	jne    800893 <CheckWSWithoutLastIndex+0xfb>
			panic(
  80087f:	83 ec 04             	sub    $0x4,%esp
  800882:	68 64 3a 80 00       	push   $0x803a64
  800887:	6a 3a                	push   $0x3a
  800889:	68 58 3a 80 00       	push   $0x803a58
  80088e:	e8 93 fe ff ff       	call   800726 <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  800893:	ff 45 f0             	incl   -0x10(%ebp)
  800896:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800899:	3b 45 0c             	cmp    0xc(%ebp),%eax
  80089c:	0f 8c 32 ff ff ff    	jl     8007d4 <CheckWSWithoutLastIndex+0x3c>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  8008a2:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8008a9:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  8008b0:	eb 26                	jmp    8008d8 <CheckWSWithoutLastIndex+0x140>
		if (myEnv->__uptr_pws[w].empty == 1) {
  8008b2:	a1 24 50 80 00       	mov    0x805024,%eax
  8008b7:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  8008bd:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8008c0:	89 d0                	mov    %edx,%eax
  8008c2:	01 c0                	add    %eax,%eax
  8008c4:	01 d0                	add    %edx,%eax
  8008c6:	c1 e0 03             	shl    $0x3,%eax
  8008c9:	01 c8                	add    %ecx,%eax
  8008cb:	8a 40 04             	mov    0x4(%eax),%al
  8008ce:	3c 01                	cmp    $0x1,%al
  8008d0:	75 03                	jne    8008d5 <CheckWSWithoutLastIndex+0x13d>
			actualNumOfEmptyLocs++;
  8008d2:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8008d5:	ff 45 e0             	incl   -0x20(%ebp)
  8008d8:	a1 24 50 80 00       	mov    0x805024,%eax
  8008dd:	8b 50 74             	mov    0x74(%eax),%edx
  8008e0:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8008e3:	39 c2                	cmp    %eax,%edx
  8008e5:	77 cb                	ja     8008b2 <CheckWSWithoutLastIndex+0x11a>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  8008e7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8008ea:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  8008ed:	74 14                	je     800903 <CheckWSWithoutLastIndex+0x16b>
		panic(
  8008ef:	83 ec 04             	sub    $0x4,%esp
  8008f2:	68 b8 3a 80 00       	push   $0x803ab8
  8008f7:	6a 44                	push   $0x44
  8008f9:	68 58 3a 80 00       	push   $0x803a58
  8008fe:	e8 23 fe ff ff       	call   800726 <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  800903:	90                   	nop
  800904:	c9                   	leave  
  800905:	c3                   	ret    

00800906 <putch>:
};

//2017:
uint8 printProgName = 0;

static void putch(int ch, struct printbuf *b) {
  800906:	55                   	push   %ebp
  800907:	89 e5                	mov    %esp,%ebp
  800909:	83 ec 08             	sub    $0x8,%esp
	b->buf[b->idx++] = ch;
  80090c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80090f:	8b 00                	mov    (%eax),%eax
  800911:	8d 48 01             	lea    0x1(%eax),%ecx
  800914:	8b 55 0c             	mov    0xc(%ebp),%edx
  800917:	89 0a                	mov    %ecx,(%edx)
  800919:	8b 55 08             	mov    0x8(%ebp),%edx
  80091c:	88 d1                	mov    %dl,%cl
  80091e:	8b 55 0c             	mov    0xc(%ebp),%edx
  800921:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  800925:	8b 45 0c             	mov    0xc(%ebp),%eax
  800928:	8b 00                	mov    (%eax),%eax
  80092a:	3d ff 00 00 00       	cmp    $0xff,%eax
  80092f:	75 2c                	jne    80095d <putch+0x57>
		sys_cputs(b->buf, b->idx, printProgName);
  800931:	a0 28 50 80 00       	mov    0x805028,%al
  800936:	0f b6 c0             	movzbl %al,%eax
  800939:	8b 55 0c             	mov    0xc(%ebp),%edx
  80093c:	8b 12                	mov    (%edx),%edx
  80093e:	89 d1                	mov    %edx,%ecx
  800940:	8b 55 0c             	mov    0xc(%ebp),%edx
  800943:	83 c2 08             	add    $0x8,%edx
  800946:	83 ec 04             	sub    $0x4,%esp
  800949:	50                   	push   %eax
  80094a:	51                   	push   %ecx
  80094b:	52                   	push   %edx
  80094c:	e8 6c 15 00 00       	call   801ebd <sys_cputs>
  800951:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  800954:	8b 45 0c             	mov    0xc(%ebp),%eax
  800957:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  80095d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800960:	8b 40 04             	mov    0x4(%eax),%eax
  800963:	8d 50 01             	lea    0x1(%eax),%edx
  800966:	8b 45 0c             	mov    0xc(%ebp),%eax
  800969:	89 50 04             	mov    %edx,0x4(%eax)
}
  80096c:	90                   	nop
  80096d:	c9                   	leave  
  80096e:	c3                   	ret    

0080096f <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  80096f:	55                   	push   %ebp
  800970:	89 e5                	mov    %esp,%ebp
  800972:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  800978:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  80097f:	00 00 00 
	b.cnt = 0;
  800982:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800989:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  80098c:	ff 75 0c             	pushl  0xc(%ebp)
  80098f:	ff 75 08             	pushl  0x8(%ebp)
  800992:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800998:	50                   	push   %eax
  800999:	68 06 09 80 00       	push   $0x800906
  80099e:	e8 11 02 00 00       	call   800bb4 <vprintfmt>
  8009a3:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName);
  8009a6:	a0 28 50 80 00       	mov    0x805028,%al
  8009ab:	0f b6 c0             	movzbl %al,%eax
  8009ae:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  8009b4:	83 ec 04             	sub    $0x4,%esp
  8009b7:	50                   	push   %eax
  8009b8:	52                   	push   %edx
  8009b9:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8009bf:	83 c0 08             	add    $0x8,%eax
  8009c2:	50                   	push   %eax
  8009c3:	e8 f5 14 00 00       	call   801ebd <sys_cputs>
  8009c8:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  8009cb:	c6 05 28 50 80 00 00 	movb   $0x0,0x805028
	return b.cnt;
  8009d2:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  8009d8:	c9                   	leave  
  8009d9:	c3                   	ret    

008009da <cprintf>:

int cprintf(const char *fmt, ...) {
  8009da:	55                   	push   %ebp
  8009db:	89 e5                	mov    %esp,%ebp
  8009dd:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  8009e0:	c6 05 28 50 80 00 01 	movb   $0x1,0x805028
	va_start(ap, fmt);
  8009e7:	8d 45 0c             	lea    0xc(%ebp),%eax
  8009ea:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  8009ed:	8b 45 08             	mov    0x8(%ebp),%eax
  8009f0:	83 ec 08             	sub    $0x8,%esp
  8009f3:	ff 75 f4             	pushl  -0xc(%ebp)
  8009f6:	50                   	push   %eax
  8009f7:	e8 73 ff ff ff       	call   80096f <vcprintf>
  8009fc:	83 c4 10             	add    $0x10,%esp
  8009ff:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  800a02:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800a05:	c9                   	leave  
  800a06:	c3                   	ret    

00800a07 <atomic_cprintf>:

int atomic_cprintf(const char *fmt, ...) {
  800a07:	55                   	push   %ebp
  800a08:	89 e5                	mov    %esp,%ebp
  800a0a:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  800a0d:	e8 59 16 00 00       	call   80206b <sys_disable_interrupt>
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  800a12:	8d 45 0c             	lea    0xc(%ebp),%eax
  800a15:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800a18:	8b 45 08             	mov    0x8(%ebp),%eax
  800a1b:	83 ec 08             	sub    $0x8,%esp
  800a1e:	ff 75 f4             	pushl  -0xc(%ebp)
  800a21:	50                   	push   %eax
  800a22:	e8 48 ff ff ff       	call   80096f <vcprintf>
  800a27:	83 c4 10             	add    $0x10,%esp
  800a2a:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	sys_enable_interrupt();
  800a2d:	e8 53 16 00 00       	call   802085 <sys_enable_interrupt>
	return cnt;
  800a32:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800a35:	c9                   	leave  
  800a36:	c3                   	ret    

00800a37 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800a37:	55                   	push   %ebp
  800a38:	89 e5                	mov    %esp,%ebp
  800a3a:	53                   	push   %ebx
  800a3b:	83 ec 14             	sub    $0x14,%esp
  800a3e:	8b 45 10             	mov    0x10(%ebp),%eax
  800a41:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800a44:	8b 45 14             	mov    0x14(%ebp),%eax
  800a47:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800a4a:	8b 45 18             	mov    0x18(%ebp),%eax
  800a4d:	ba 00 00 00 00       	mov    $0x0,%edx
  800a52:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800a55:	77 55                	ja     800aac <printnum+0x75>
  800a57:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800a5a:	72 05                	jb     800a61 <printnum+0x2a>
  800a5c:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800a5f:	77 4b                	ja     800aac <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800a61:	8b 45 1c             	mov    0x1c(%ebp),%eax
  800a64:	8d 58 ff             	lea    -0x1(%eax),%ebx
  800a67:	8b 45 18             	mov    0x18(%ebp),%eax
  800a6a:	ba 00 00 00 00       	mov    $0x0,%edx
  800a6f:	52                   	push   %edx
  800a70:	50                   	push   %eax
  800a71:	ff 75 f4             	pushl  -0xc(%ebp)
  800a74:	ff 75 f0             	pushl  -0x10(%ebp)
  800a77:	e8 8c 2a 00 00       	call   803508 <__udivdi3>
  800a7c:	83 c4 10             	add    $0x10,%esp
  800a7f:	83 ec 04             	sub    $0x4,%esp
  800a82:	ff 75 20             	pushl  0x20(%ebp)
  800a85:	53                   	push   %ebx
  800a86:	ff 75 18             	pushl  0x18(%ebp)
  800a89:	52                   	push   %edx
  800a8a:	50                   	push   %eax
  800a8b:	ff 75 0c             	pushl  0xc(%ebp)
  800a8e:	ff 75 08             	pushl  0x8(%ebp)
  800a91:	e8 a1 ff ff ff       	call   800a37 <printnum>
  800a96:	83 c4 20             	add    $0x20,%esp
  800a99:	eb 1a                	jmp    800ab5 <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800a9b:	83 ec 08             	sub    $0x8,%esp
  800a9e:	ff 75 0c             	pushl  0xc(%ebp)
  800aa1:	ff 75 20             	pushl  0x20(%ebp)
  800aa4:	8b 45 08             	mov    0x8(%ebp),%eax
  800aa7:	ff d0                	call   *%eax
  800aa9:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800aac:	ff 4d 1c             	decl   0x1c(%ebp)
  800aaf:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  800ab3:	7f e6                	jg     800a9b <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800ab5:	8b 4d 18             	mov    0x18(%ebp),%ecx
  800ab8:	bb 00 00 00 00       	mov    $0x0,%ebx
  800abd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800ac0:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800ac3:	53                   	push   %ebx
  800ac4:	51                   	push   %ecx
  800ac5:	52                   	push   %edx
  800ac6:	50                   	push   %eax
  800ac7:	e8 4c 2b 00 00       	call   803618 <__umoddi3>
  800acc:	83 c4 10             	add    $0x10,%esp
  800acf:	05 34 3d 80 00       	add    $0x803d34,%eax
  800ad4:	8a 00                	mov    (%eax),%al
  800ad6:	0f be c0             	movsbl %al,%eax
  800ad9:	83 ec 08             	sub    $0x8,%esp
  800adc:	ff 75 0c             	pushl  0xc(%ebp)
  800adf:	50                   	push   %eax
  800ae0:	8b 45 08             	mov    0x8(%ebp),%eax
  800ae3:	ff d0                	call   *%eax
  800ae5:	83 c4 10             	add    $0x10,%esp
}
  800ae8:	90                   	nop
  800ae9:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800aec:	c9                   	leave  
  800aed:	c3                   	ret    

00800aee <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  800aee:	55                   	push   %ebp
  800aef:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800af1:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800af5:	7e 1c                	jle    800b13 <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  800af7:	8b 45 08             	mov    0x8(%ebp),%eax
  800afa:	8b 00                	mov    (%eax),%eax
  800afc:	8d 50 08             	lea    0x8(%eax),%edx
  800aff:	8b 45 08             	mov    0x8(%ebp),%eax
  800b02:	89 10                	mov    %edx,(%eax)
  800b04:	8b 45 08             	mov    0x8(%ebp),%eax
  800b07:	8b 00                	mov    (%eax),%eax
  800b09:	83 e8 08             	sub    $0x8,%eax
  800b0c:	8b 50 04             	mov    0x4(%eax),%edx
  800b0f:	8b 00                	mov    (%eax),%eax
  800b11:	eb 40                	jmp    800b53 <getuint+0x65>
	else if (lflag)
  800b13:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800b17:	74 1e                	je     800b37 <getuint+0x49>
		return va_arg(*ap, unsigned long);
  800b19:	8b 45 08             	mov    0x8(%ebp),%eax
  800b1c:	8b 00                	mov    (%eax),%eax
  800b1e:	8d 50 04             	lea    0x4(%eax),%edx
  800b21:	8b 45 08             	mov    0x8(%ebp),%eax
  800b24:	89 10                	mov    %edx,(%eax)
  800b26:	8b 45 08             	mov    0x8(%ebp),%eax
  800b29:	8b 00                	mov    (%eax),%eax
  800b2b:	83 e8 04             	sub    $0x4,%eax
  800b2e:	8b 00                	mov    (%eax),%eax
  800b30:	ba 00 00 00 00       	mov    $0x0,%edx
  800b35:	eb 1c                	jmp    800b53 <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  800b37:	8b 45 08             	mov    0x8(%ebp),%eax
  800b3a:	8b 00                	mov    (%eax),%eax
  800b3c:	8d 50 04             	lea    0x4(%eax),%edx
  800b3f:	8b 45 08             	mov    0x8(%ebp),%eax
  800b42:	89 10                	mov    %edx,(%eax)
  800b44:	8b 45 08             	mov    0x8(%ebp),%eax
  800b47:	8b 00                	mov    (%eax),%eax
  800b49:	83 e8 04             	sub    $0x4,%eax
  800b4c:	8b 00                	mov    (%eax),%eax
  800b4e:	ba 00 00 00 00       	mov    $0x0,%edx
}
  800b53:	5d                   	pop    %ebp
  800b54:	c3                   	ret    

00800b55 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  800b55:	55                   	push   %ebp
  800b56:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800b58:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800b5c:	7e 1c                	jle    800b7a <getint+0x25>
		return va_arg(*ap, long long);
  800b5e:	8b 45 08             	mov    0x8(%ebp),%eax
  800b61:	8b 00                	mov    (%eax),%eax
  800b63:	8d 50 08             	lea    0x8(%eax),%edx
  800b66:	8b 45 08             	mov    0x8(%ebp),%eax
  800b69:	89 10                	mov    %edx,(%eax)
  800b6b:	8b 45 08             	mov    0x8(%ebp),%eax
  800b6e:	8b 00                	mov    (%eax),%eax
  800b70:	83 e8 08             	sub    $0x8,%eax
  800b73:	8b 50 04             	mov    0x4(%eax),%edx
  800b76:	8b 00                	mov    (%eax),%eax
  800b78:	eb 38                	jmp    800bb2 <getint+0x5d>
	else if (lflag)
  800b7a:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800b7e:	74 1a                	je     800b9a <getint+0x45>
		return va_arg(*ap, long);
  800b80:	8b 45 08             	mov    0x8(%ebp),%eax
  800b83:	8b 00                	mov    (%eax),%eax
  800b85:	8d 50 04             	lea    0x4(%eax),%edx
  800b88:	8b 45 08             	mov    0x8(%ebp),%eax
  800b8b:	89 10                	mov    %edx,(%eax)
  800b8d:	8b 45 08             	mov    0x8(%ebp),%eax
  800b90:	8b 00                	mov    (%eax),%eax
  800b92:	83 e8 04             	sub    $0x4,%eax
  800b95:	8b 00                	mov    (%eax),%eax
  800b97:	99                   	cltd   
  800b98:	eb 18                	jmp    800bb2 <getint+0x5d>
	else
		return va_arg(*ap, int);
  800b9a:	8b 45 08             	mov    0x8(%ebp),%eax
  800b9d:	8b 00                	mov    (%eax),%eax
  800b9f:	8d 50 04             	lea    0x4(%eax),%edx
  800ba2:	8b 45 08             	mov    0x8(%ebp),%eax
  800ba5:	89 10                	mov    %edx,(%eax)
  800ba7:	8b 45 08             	mov    0x8(%ebp),%eax
  800baa:	8b 00                	mov    (%eax),%eax
  800bac:	83 e8 04             	sub    $0x4,%eax
  800baf:	8b 00                	mov    (%eax),%eax
  800bb1:	99                   	cltd   
}
  800bb2:	5d                   	pop    %ebp
  800bb3:	c3                   	ret    

00800bb4 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  800bb4:	55                   	push   %ebp
  800bb5:	89 e5                	mov    %esp,%ebp
  800bb7:	56                   	push   %esi
  800bb8:	53                   	push   %ebx
  800bb9:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800bbc:	eb 17                	jmp    800bd5 <vprintfmt+0x21>
			if (ch == '\0')
  800bbe:	85 db                	test   %ebx,%ebx
  800bc0:	0f 84 af 03 00 00    	je     800f75 <vprintfmt+0x3c1>
				return;
			putch(ch, putdat);
  800bc6:	83 ec 08             	sub    $0x8,%esp
  800bc9:	ff 75 0c             	pushl  0xc(%ebp)
  800bcc:	53                   	push   %ebx
  800bcd:	8b 45 08             	mov    0x8(%ebp),%eax
  800bd0:	ff d0                	call   *%eax
  800bd2:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800bd5:	8b 45 10             	mov    0x10(%ebp),%eax
  800bd8:	8d 50 01             	lea    0x1(%eax),%edx
  800bdb:	89 55 10             	mov    %edx,0x10(%ebp)
  800bde:	8a 00                	mov    (%eax),%al
  800be0:	0f b6 d8             	movzbl %al,%ebx
  800be3:	83 fb 25             	cmp    $0x25,%ebx
  800be6:	75 d6                	jne    800bbe <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  800be8:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  800bec:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  800bf3:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  800bfa:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  800c01:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800c08:	8b 45 10             	mov    0x10(%ebp),%eax
  800c0b:	8d 50 01             	lea    0x1(%eax),%edx
  800c0e:	89 55 10             	mov    %edx,0x10(%ebp)
  800c11:	8a 00                	mov    (%eax),%al
  800c13:	0f b6 d8             	movzbl %al,%ebx
  800c16:	8d 43 dd             	lea    -0x23(%ebx),%eax
  800c19:	83 f8 55             	cmp    $0x55,%eax
  800c1c:	0f 87 2b 03 00 00    	ja     800f4d <vprintfmt+0x399>
  800c22:	8b 04 85 58 3d 80 00 	mov    0x803d58(,%eax,4),%eax
  800c29:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  800c2b:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  800c2f:	eb d7                	jmp    800c08 <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800c31:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  800c35:	eb d1                	jmp    800c08 <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800c37:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  800c3e:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800c41:	89 d0                	mov    %edx,%eax
  800c43:	c1 e0 02             	shl    $0x2,%eax
  800c46:	01 d0                	add    %edx,%eax
  800c48:	01 c0                	add    %eax,%eax
  800c4a:	01 d8                	add    %ebx,%eax
  800c4c:	83 e8 30             	sub    $0x30,%eax
  800c4f:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  800c52:	8b 45 10             	mov    0x10(%ebp),%eax
  800c55:	8a 00                	mov    (%eax),%al
  800c57:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  800c5a:	83 fb 2f             	cmp    $0x2f,%ebx
  800c5d:	7e 3e                	jle    800c9d <vprintfmt+0xe9>
  800c5f:	83 fb 39             	cmp    $0x39,%ebx
  800c62:	7f 39                	jg     800c9d <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800c64:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800c67:	eb d5                	jmp    800c3e <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  800c69:	8b 45 14             	mov    0x14(%ebp),%eax
  800c6c:	83 c0 04             	add    $0x4,%eax
  800c6f:	89 45 14             	mov    %eax,0x14(%ebp)
  800c72:	8b 45 14             	mov    0x14(%ebp),%eax
  800c75:	83 e8 04             	sub    $0x4,%eax
  800c78:	8b 00                	mov    (%eax),%eax
  800c7a:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  800c7d:	eb 1f                	jmp    800c9e <vprintfmt+0xea>

		case '.':
			if (width < 0)
  800c7f:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800c83:	79 83                	jns    800c08 <vprintfmt+0x54>
				width = 0;
  800c85:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  800c8c:	e9 77 ff ff ff       	jmp    800c08 <vprintfmt+0x54>

		case '#':
			altflag = 1;
  800c91:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  800c98:	e9 6b ff ff ff       	jmp    800c08 <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  800c9d:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  800c9e:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800ca2:	0f 89 60 ff ff ff    	jns    800c08 <vprintfmt+0x54>
				width = precision, precision = -1;
  800ca8:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800cab:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800cae:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  800cb5:	e9 4e ff ff ff       	jmp    800c08 <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  800cba:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  800cbd:	e9 46 ff ff ff       	jmp    800c08 <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  800cc2:	8b 45 14             	mov    0x14(%ebp),%eax
  800cc5:	83 c0 04             	add    $0x4,%eax
  800cc8:	89 45 14             	mov    %eax,0x14(%ebp)
  800ccb:	8b 45 14             	mov    0x14(%ebp),%eax
  800cce:	83 e8 04             	sub    $0x4,%eax
  800cd1:	8b 00                	mov    (%eax),%eax
  800cd3:	83 ec 08             	sub    $0x8,%esp
  800cd6:	ff 75 0c             	pushl  0xc(%ebp)
  800cd9:	50                   	push   %eax
  800cda:	8b 45 08             	mov    0x8(%ebp),%eax
  800cdd:	ff d0                	call   *%eax
  800cdf:	83 c4 10             	add    $0x10,%esp
			break;
  800ce2:	e9 89 02 00 00       	jmp    800f70 <vprintfmt+0x3bc>

		// error message
		case 'e':
			err = va_arg(ap, int);
  800ce7:	8b 45 14             	mov    0x14(%ebp),%eax
  800cea:	83 c0 04             	add    $0x4,%eax
  800ced:	89 45 14             	mov    %eax,0x14(%ebp)
  800cf0:	8b 45 14             	mov    0x14(%ebp),%eax
  800cf3:	83 e8 04             	sub    $0x4,%eax
  800cf6:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  800cf8:	85 db                	test   %ebx,%ebx
  800cfa:	79 02                	jns    800cfe <vprintfmt+0x14a>
				err = -err;
  800cfc:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  800cfe:	83 fb 64             	cmp    $0x64,%ebx
  800d01:	7f 0b                	jg     800d0e <vprintfmt+0x15a>
  800d03:	8b 34 9d a0 3b 80 00 	mov    0x803ba0(,%ebx,4),%esi
  800d0a:	85 f6                	test   %esi,%esi
  800d0c:	75 19                	jne    800d27 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  800d0e:	53                   	push   %ebx
  800d0f:	68 45 3d 80 00       	push   $0x803d45
  800d14:	ff 75 0c             	pushl  0xc(%ebp)
  800d17:	ff 75 08             	pushl  0x8(%ebp)
  800d1a:	e8 5e 02 00 00       	call   800f7d <printfmt>
  800d1f:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800d22:	e9 49 02 00 00       	jmp    800f70 <vprintfmt+0x3bc>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800d27:	56                   	push   %esi
  800d28:	68 4e 3d 80 00       	push   $0x803d4e
  800d2d:	ff 75 0c             	pushl  0xc(%ebp)
  800d30:	ff 75 08             	pushl  0x8(%ebp)
  800d33:	e8 45 02 00 00       	call   800f7d <printfmt>
  800d38:	83 c4 10             	add    $0x10,%esp
			break;
  800d3b:	e9 30 02 00 00       	jmp    800f70 <vprintfmt+0x3bc>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  800d40:	8b 45 14             	mov    0x14(%ebp),%eax
  800d43:	83 c0 04             	add    $0x4,%eax
  800d46:	89 45 14             	mov    %eax,0x14(%ebp)
  800d49:	8b 45 14             	mov    0x14(%ebp),%eax
  800d4c:	83 e8 04             	sub    $0x4,%eax
  800d4f:	8b 30                	mov    (%eax),%esi
  800d51:	85 f6                	test   %esi,%esi
  800d53:	75 05                	jne    800d5a <vprintfmt+0x1a6>
				p = "(null)";
  800d55:	be 51 3d 80 00       	mov    $0x803d51,%esi
			if (width > 0 && padc != '-')
  800d5a:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800d5e:	7e 6d                	jle    800dcd <vprintfmt+0x219>
  800d60:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  800d64:	74 67                	je     800dcd <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  800d66:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800d69:	83 ec 08             	sub    $0x8,%esp
  800d6c:	50                   	push   %eax
  800d6d:	56                   	push   %esi
  800d6e:	e8 12 05 00 00       	call   801285 <strnlen>
  800d73:	83 c4 10             	add    $0x10,%esp
  800d76:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  800d79:	eb 16                	jmp    800d91 <vprintfmt+0x1dd>
					putch(padc, putdat);
  800d7b:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  800d7f:	83 ec 08             	sub    $0x8,%esp
  800d82:	ff 75 0c             	pushl  0xc(%ebp)
  800d85:	50                   	push   %eax
  800d86:	8b 45 08             	mov    0x8(%ebp),%eax
  800d89:	ff d0                	call   *%eax
  800d8b:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800d8e:	ff 4d e4             	decl   -0x1c(%ebp)
  800d91:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800d95:	7f e4                	jg     800d7b <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800d97:	eb 34                	jmp    800dcd <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  800d99:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800d9d:	74 1c                	je     800dbb <vprintfmt+0x207>
  800d9f:	83 fb 1f             	cmp    $0x1f,%ebx
  800da2:	7e 05                	jle    800da9 <vprintfmt+0x1f5>
  800da4:	83 fb 7e             	cmp    $0x7e,%ebx
  800da7:	7e 12                	jle    800dbb <vprintfmt+0x207>
					putch('?', putdat);
  800da9:	83 ec 08             	sub    $0x8,%esp
  800dac:	ff 75 0c             	pushl  0xc(%ebp)
  800daf:	6a 3f                	push   $0x3f
  800db1:	8b 45 08             	mov    0x8(%ebp),%eax
  800db4:	ff d0                	call   *%eax
  800db6:	83 c4 10             	add    $0x10,%esp
  800db9:	eb 0f                	jmp    800dca <vprintfmt+0x216>
				else
					putch(ch, putdat);
  800dbb:	83 ec 08             	sub    $0x8,%esp
  800dbe:	ff 75 0c             	pushl  0xc(%ebp)
  800dc1:	53                   	push   %ebx
  800dc2:	8b 45 08             	mov    0x8(%ebp),%eax
  800dc5:	ff d0                	call   *%eax
  800dc7:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800dca:	ff 4d e4             	decl   -0x1c(%ebp)
  800dcd:	89 f0                	mov    %esi,%eax
  800dcf:	8d 70 01             	lea    0x1(%eax),%esi
  800dd2:	8a 00                	mov    (%eax),%al
  800dd4:	0f be d8             	movsbl %al,%ebx
  800dd7:	85 db                	test   %ebx,%ebx
  800dd9:	74 24                	je     800dff <vprintfmt+0x24b>
  800ddb:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800ddf:	78 b8                	js     800d99 <vprintfmt+0x1e5>
  800de1:	ff 4d e0             	decl   -0x20(%ebp)
  800de4:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800de8:	79 af                	jns    800d99 <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800dea:	eb 13                	jmp    800dff <vprintfmt+0x24b>
				putch(' ', putdat);
  800dec:	83 ec 08             	sub    $0x8,%esp
  800def:	ff 75 0c             	pushl  0xc(%ebp)
  800df2:	6a 20                	push   $0x20
  800df4:	8b 45 08             	mov    0x8(%ebp),%eax
  800df7:	ff d0                	call   *%eax
  800df9:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800dfc:	ff 4d e4             	decl   -0x1c(%ebp)
  800dff:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800e03:	7f e7                	jg     800dec <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  800e05:	e9 66 01 00 00       	jmp    800f70 <vprintfmt+0x3bc>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  800e0a:	83 ec 08             	sub    $0x8,%esp
  800e0d:	ff 75 e8             	pushl  -0x18(%ebp)
  800e10:	8d 45 14             	lea    0x14(%ebp),%eax
  800e13:	50                   	push   %eax
  800e14:	e8 3c fd ff ff       	call   800b55 <getint>
  800e19:	83 c4 10             	add    $0x10,%esp
  800e1c:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800e1f:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  800e22:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800e25:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800e28:	85 d2                	test   %edx,%edx
  800e2a:	79 23                	jns    800e4f <vprintfmt+0x29b>
				putch('-', putdat);
  800e2c:	83 ec 08             	sub    $0x8,%esp
  800e2f:	ff 75 0c             	pushl  0xc(%ebp)
  800e32:	6a 2d                	push   $0x2d
  800e34:	8b 45 08             	mov    0x8(%ebp),%eax
  800e37:	ff d0                	call   *%eax
  800e39:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  800e3c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800e3f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800e42:	f7 d8                	neg    %eax
  800e44:	83 d2 00             	adc    $0x0,%edx
  800e47:	f7 da                	neg    %edx
  800e49:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800e4c:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  800e4f:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800e56:	e9 bc 00 00 00       	jmp    800f17 <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  800e5b:	83 ec 08             	sub    $0x8,%esp
  800e5e:	ff 75 e8             	pushl  -0x18(%ebp)
  800e61:	8d 45 14             	lea    0x14(%ebp),%eax
  800e64:	50                   	push   %eax
  800e65:	e8 84 fc ff ff       	call   800aee <getuint>
  800e6a:	83 c4 10             	add    $0x10,%esp
  800e6d:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800e70:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  800e73:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800e7a:	e9 98 00 00 00       	jmp    800f17 <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  800e7f:	83 ec 08             	sub    $0x8,%esp
  800e82:	ff 75 0c             	pushl  0xc(%ebp)
  800e85:	6a 58                	push   $0x58
  800e87:	8b 45 08             	mov    0x8(%ebp),%eax
  800e8a:	ff d0                	call   *%eax
  800e8c:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800e8f:	83 ec 08             	sub    $0x8,%esp
  800e92:	ff 75 0c             	pushl  0xc(%ebp)
  800e95:	6a 58                	push   $0x58
  800e97:	8b 45 08             	mov    0x8(%ebp),%eax
  800e9a:	ff d0                	call   *%eax
  800e9c:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800e9f:	83 ec 08             	sub    $0x8,%esp
  800ea2:	ff 75 0c             	pushl  0xc(%ebp)
  800ea5:	6a 58                	push   $0x58
  800ea7:	8b 45 08             	mov    0x8(%ebp),%eax
  800eaa:	ff d0                	call   *%eax
  800eac:	83 c4 10             	add    $0x10,%esp
			break;
  800eaf:	e9 bc 00 00 00       	jmp    800f70 <vprintfmt+0x3bc>

		// pointer
		case 'p':
			putch('0', putdat);
  800eb4:	83 ec 08             	sub    $0x8,%esp
  800eb7:	ff 75 0c             	pushl  0xc(%ebp)
  800eba:	6a 30                	push   $0x30
  800ebc:	8b 45 08             	mov    0x8(%ebp),%eax
  800ebf:	ff d0                	call   *%eax
  800ec1:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  800ec4:	83 ec 08             	sub    $0x8,%esp
  800ec7:	ff 75 0c             	pushl  0xc(%ebp)
  800eca:	6a 78                	push   $0x78
  800ecc:	8b 45 08             	mov    0x8(%ebp),%eax
  800ecf:	ff d0                	call   *%eax
  800ed1:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  800ed4:	8b 45 14             	mov    0x14(%ebp),%eax
  800ed7:	83 c0 04             	add    $0x4,%eax
  800eda:	89 45 14             	mov    %eax,0x14(%ebp)
  800edd:	8b 45 14             	mov    0x14(%ebp),%eax
  800ee0:	83 e8 04             	sub    $0x4,%eax
  800ee3:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800ee5:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800ee8:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  800eef:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  800ef6:	eb 1f                	jmp    800f17 <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800ef8:	83 ec 08             	sub    $0x8,%esp
  800efb:	ff 75 e8             	pushl  -0x18(%ebp)
  800efe:	8d 45 14             	lea    0x14(%ebp),%eax
  800f01:	50                   	push   %eax
  800f02:	e8 e7 fb ff ff       	call   800aee <getuint>
  800f07:	83 c4 10             	add    $0x10,%esp
  800f0a:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800f0d:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  800f10:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800f17:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  800f1b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800f1e:	83 ec 04             	sub    $0x4,%esp
  800f21:	52                   	push   %edx
  800f22:	ff 75 e4             	pushl  -0x1c(%ebp)
  800f25:	50                   	push   %eax
  800f26:	ff 75 f4             	pushl  -0xc(%ebp)
  800f29:	ff 75 f0             	pushl  -0x10(%ebp)
  800f2c:	ff 75 0c             	pushl  0xc(%ebp)
  800f2f:	ff 75 08             	pushl  0x8(%ebp)
  800f32:	e8 00 fb ff ff       	call   800a37 <printnum>
  800f37:	83 c4 20             	add    $0x20,%esp
			break;
  800f3a:	eb 34                	jmp    800f70 <vprintfmt+0x3bc>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  800f3c:	83 ec 08             	sub    $0x8,%esp
  800f3f:	ff 75 0c             	pushl  0xc(%ebp)
  800f42:	53                   	push   %ebx
  800f43:	8b 45 08             	mov    0x8(%ebp),%eax
  800f46:	ff d0                	call   *%eax
  800f48:	83 c4 10             	add    $0x10,%esp
			break;
  800f4b:	eb 23                	jmp    800f70 <vprintfmt+0x3bc>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800f4d:	83 ec 08             	sub    $0x8,%esp
  800f50:	ff 75 0c             	pushl  0xc(%ebp)
  800f53:	6a 25                	push   $0x25
  800f55:	8b 45 08             	mov    0x8(%ebp),%eax
  800f58:	ff d0                	call   *%eax
  800f5a:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  800f5d:	ff 4d 10             	decl   0x10(%ebp)
  800f60:	eb 03                	jmp    800f65 <vprintfmt+0x3b1>
  800f62:	ff 4d 10             	decl   0x10(%ebp)
  800f65:	8b 45 10             	mov    0x10(%ebp),%eax
  800f68:	48                   	dec    %eax
  800f69:	8a 00                	mov    (%eax),%al
  800f6b:	3c 25                	cmp    $0x25,%al
  800f6d:	75 f3                	jne    800f62 <vprintfmt+0x3ae>
				/* do nothing */;
			break;
  800f6f:	90                   	nop
		}
	}
  800f70:	e9 47 fc ff ff       	jmp    800bbc <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  800f75:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  800f76:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800f79:	5b                   	pop    %ebx
  800f7a:	5e                   	pop    %esi
  800f7b:	5d                   	pop    %ebp
  800f7c:	c3                   	ret    

00800f7d <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800f7d:	55                   	push   %ebp
  800f7e:	89 e5                	mov    %esp,%ebp
  800f80:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  800f83:	8d 45 10             	lea    0x10(%ebp),%eax
  800f86:	83 c0 04             	add    $0x4,%eax
  800f89:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  800f8c:	8b 45 10             	mov    0x10(%ebp),%eax
  800f8f:	ff 75 f4             	pushl  -0xc(%ebp)
  800f92:	50                   	push   %eax
  800f93:	ff 75 0c             	pushl  0xc(%ebp)
  800f96:	ff 75 08             	pushl  0x8(%ebp)
  800f99:	e8 16 fc ff ff       	call   800bb4 <vprintfmt>
  800f9e:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  800fa1:	90                   	nop
  800fa2:	c9                   	leave  
  800fa3:	c3                   	ret    

00800fa4 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800fa4:	55                   	push   %ebp
  800fa5:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  800fa7:	8b 45 0c             	mov    0xc(%ebp),%eax
  800faa:	8b 40 08             	mov    0x8(%eax),%eax
  800fad:	8d 50 01             	lea    0x1(%eax),%edx
  800fb0:	8b 45 0c             	mov    0xc(%ebp),%eax
  800fb3:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  800fb6:	8b 45 0c             	mov    0xc(%ebp),%eax
  800fb9:	8b 10                	mov    (%eax),%edx
  800fbb:	8b 45 0c             	mov    0xc(%ebp),%eax
  800fbe:	8b 40 04             	mov    0x4(%eax),%eax
  800fc1:	39 c2                	cmp    %eax,%edx
  800fc3:	73 12                	jae    800fd7 <sprintputch+0x33>
		*b->buf++ = ch;
  800fc5:	8b 45 0c             	mov    0xc(%ebp),%eax
  800fc8:	8b 00                	mov    (%eax),%eax
  800fca:	8d 48 01             	lea    0x1(%eax),%ecx
  800fcd:	8b 55 0c             	mov    0xc(%ebp),%edx
  800fd0:	89 0a                	mov    %ecx,(%edx)
  800fd2:	8b 55 08             	mov    0x8(%ebp),%edx
  800fd5:	88 10                	mov    %dl,(%eax)
}
  800fd7:	90                   	nop
  800fd8:	5d                   	pop    %ebp
  800fd9:	c3                   	ret    

00800fda <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800fda:	55                   	push   %ebp
  800fdb:	89 e5                	mov    %esp,%ebp
  800fdd:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  800fe0:	8b 45 08             	mov    0x8(%ebp),%eax
  800fe3:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800fe6:	8b 45 0c             	mov    0xc(%ebp),%eax
  800fe9:	8d 50 ff             	lea    -0x1(%eax),%edx
  800fec:	8b 45 08             	mov    0x8(%ebp),%eax
  800fef:	01 d0                	add    %edx,%eax
  800ff1:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800ff4:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800ffb:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800fff:	74 06                	je     801007 <vsnprintf+0x2d>
  801001:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801005:	7f 07                	jg     80100e <vsnprintf+0x34>
		return -E_INVAL;
  801007:	b8 03 00 00 00       	mov    $0x3,%eax
  80100c:	eb 20                	jmp    80102e <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  80100e:	ff 75 14             	pushl  0x14(%ebp)
  801011:	ff 75 10             	pushl  0x10(%ebp)
  801014:	8d 45 ec             	lea    -0x14(%ebp),%eax
  801017:	50                   	push   %eax
  801018:	68 a4 0f 80 00       	push   $0x800fa4
  80101d:	e8 92 fb ff ff       	call   800bb4 <vprintfmt>
  801022:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  801025:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801028:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  80102b:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  80102e:	c9                   	leave  
  80102f:	c3                   	ret    

00801030 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  801030:	55                   	push   %ebp
  801031:	89 e5                	mov    %esp,%ebp
  801033:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  801036:	8d 45 10             	lea    0x10(%ebp),%eax
  801039:	83 c0 04             	add    $0x4,%eax
  80103c:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  80103f:	8b 45 10             	mov    0x10(%ebp),%eax
  801042:	ff 75 f4             	pushl  -0xc(%ebp)
  801045:	50                   	push   %eax
  801046:	ff 75 0c             	pushl  0xc(%ebp)
  801049:	ff 75 08             	pushl  0x8(%ebp)
  80104c:	e8 89 ff ff ff       	call   800fda <vsnprintf>
  801051:	83 c4 10             	add    $0x10,%esp
  801054:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  801057:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  80105a:	c9                   	leave  
  80105b:	c3                   	ret    

0080105c <readline>:
#include <inc/lib.h>

//static char buf[BUFLEN];

void readline(const char *prompt, char* buf)
{
  80105c:	55                   	push   %ebp
  80105d:	89 e5                	mov    %esp,%ebp
  80105f:	83 ec 18             	sub    $0x18,%esp
		int i, c, echoing;

	if (prompt != NULL)
  801062:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801066:	74 13                	je     80107b <readline+0x1f>
		cprintf("%s", prompt);
  801068:	83 ec 08             	sub    $0x8,%esp
  80106b:	ff 75 08             	pushl  0x8(%ebp)
  80106e:	68 b0 3e 80 00       	push   $0x803eb0
  801073:	e8 62 f9 ff ff       	call   8009da <cprintf>
  801078:	83 c4 10             	add    $0x10,%esp

	i = 0;
  80107b:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	echoing = iscons(0);
  801082:	83 ec 0c             	sub    $0xc,%esp
  801085:	6a 00                	push   $0x0
  801087:	e8 54 f5 ff ff       	call   8005e0 <iscons>
  80108c:	83 c4 10             	add    $0x10,%esp
  80108f:	89 45 f0             	mov    %eax,-0x10(%ebp)
	while (1) {
		c = getchar();
  801092:	e8 fb f4 ff ff       	call   800592 <getchar>
  801097:	89 45 ec             	mov    %eax,-0x14(%ebp)
		if (c < 0) {
  80109a:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  80109e:	79 22                	jns    8010c2 <readline+0x66>
			if (c != -E_EOF)
  8010a0:	83 7d ec 07          	cmpl   $0x7,-0x14(%ebp)
  8010a4:	0f 84 ad 00 00 00    	je     801157 <readline+0xfb>
				cprintf("read error: %e\n", c);
  8010aa:	83 ec 08             	sub    $0x8,%esp
  8010ad:	ff 75 ec             	pushl  -0x14(%ebp)
  8010b0:	68 b3 3e 80 00       	push   $0x803eb3
  8010b5:	e8 20 f9 ff ff       	call   8009da <cprintf>
  8010ba:	83 c4 10             	add    $0x10,%esp
			return;
  8010bd:	e9 95 00 00 00       	jmp    801157 <readline+0xfb>
		} else if (c >= ' ' && i < BUFLEN-1) {
  8010c2:	83 7d ec 1f          	cmpl   $0x1f,-0x14(%ebp)
  8010c6:	7e 34                	jle    8010fc <readline+0xa0>
  8010c8:	81 7d f4 fe 03 00 00 	cmpl   $0x3fe,-0xc(%ebp)
  8010cf:	7f 2b                	jg     8010fc <readline+0xa0>
			if (echoing)
  8010d1:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8010d5:	74 0e                	je     8010e5 <readline+0x89>
				cputchar(c);
  8010d7:	83 ec 0c             	sub    $0xc,%esp
  8010da:	ff 75 ec             	pushl  -0x14(%ebp)
  8010dd:	e8 68 f4 ff ff       	call   80054a <cputchar>
  8010e2:	83 c4 10             	add    $0x10,%esp
			buf[i++] = c;
  8010e5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8010e8:	8d 50 01             	lea    0x1(%eax),%edx
  8010eb:	89 55 f4             	mov    %edx,-0xc(%ebp)
  8010ee:	89 c2                	mov    %eax,%edx
  8010f0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010f3:	01 d0                	add    %edx,%eax
  8010f5:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8010f8:	88 10                	mov    %dl,(%eax)
  8010fa:	eb 56                	jmp    801152 <readline+0xf6>
		} else if (c == '\b' && i > 0) {
  8010fc:	83 7d ec 08          	cmpl   $0x8,-0x14(%ebp)
  801100:	75 1f                	jne    801121 <readline+0xc5>
  801102:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801106:	7e 19                	jle    801121 <readline+0xc5>
			if (echoing)
  801108:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80110c:	74 0e                	je     80111c <readline+0xc0>
				cputchar(c);
  80110e:	83 ec 0c             	sub    $0xc,%esp
  801111:	ff 75 ec             	pushl  -0x14(%ebp)
  801114:	e8 31 f4 ff ff       	call   80054a <cputchar>
  801119:	83 c4 10             	add    $0x10,%esp

			i--;
  80111c:	ff 4d f4             	decl   -0xc(%ebp)
  80111f:	eb 31                	jmp    801152 <readline+0xf6>
		} else if (c == '\n' || c == '\r') {
  801121:	83 7d ec 0a          	cmpl   $0xa,-0x14(%ebp)
  801125:	74 0a                	je     801131 <readline+0xd5>
  801127:	83 7d ec 0d          	cmpl   $0xd,-0x14(%ebp)
  80112b:	0f 85 61 ff ff ff    	jne    801092 <readline+0x36>
			if (echoing)
  801131:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801135:	74 0e                	je     801145 <readline+0xe9>
				cputchar(c);
  801137:	83 ec 0c             	sub    $0xc,%esp
  80113a:	ff 75 ec             	pushl  -0x14(%ebp)
  80113d:	e8 08 f4 ff ff       	call   80054a <cputchar>
  801142:	83 c4 10             	add    $0x10,%esp

			buf[i] = 0;
  801145:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801148:	8b 45 0c             	mov    0xc(%ebp),%eax
  80114b:	01 d0                	add    %edx,%eax
  80114d:	c6 00 00             	movb   $0x0,(%eax)
			return;
  801150:	eb 06                	jmp    801158 <readline+0xfc>
		}
	}
  801152:	e9 3b ff ff ff       	jmp    801092 <readline+0x36>
	while (1) {
		c = getchar();
		if (c < 0) {
			if (c != -E_EOF)
				cprintf("read error: %e\n", c);
			return;
  801157:	90                   	nop
			buf[i] = 0;
			return;
		}
	}

}
  801158:	c9                   	leave  
  801159:	c3                   	ret    

0080115a <atomic_readline>:

void atomic_readline(const char *prompt, char* buf)
{
  80115a:	55                   	push   %ebp
  80115b:	89 e5                	mov    %esp,%ebp
  80115d:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  801160:	e8 06 0f 00 00       	call   80206b <sys_disable_interrupt>
	int i, c, echoing;

	if (prompt != NULL)
  801165:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801169:	74 13                	je     80117e <atomic_readline+0x24>
		cprintf("%s", prompt);
  80116b:	83 ec 08             	sub    $0x8,%esp
  80116e:	ff 75 08             	pushl  0x8(%ebp)
  801171:	68 b0 3e 80 00       	push   $0x803eb0
  801176:	e8 5f f8 ff ff       	call   8009da <cprintf>
  80117b:	83 c4 10             	add    $0x10,%esp

	i = 0;
  80117e:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	echoing = iscons(0);
  801185:	83 ec 0c             	sub    $0xc,%esp
  801188:	6a 00                	push   $0x0
  80118a:	e8 51 f4 ff ff       	call   8005e0 <iscons>
  80118f:	83 c4 10             	add    $0x10,%esp
  801192:	89 45 f0             	mov    %eax,-0x10(%ebp)
	while (1) {
		c = getchar();
  801195:	e8 f8 f3 ff ff       	call   800592 <getchar>
  80119a:	89 45 ec             	mov    %eax,-0x14(%ebp)
		if (c < 0) {
  80119d:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8011a1:	79 23                	jns    8011c6 <atomic_readline+0x6c>
			if (c != -E_EOF)
  8011a3:	83 7d ec 07          	cmpl   $0x7,-0x14(%ebp)
  8011a7:	74 13                	je     8011bc <atomic_readline+0x62>
				cprintf("read error: %e\n", c);
  8011a9:	83 ec 08             	sub    $0x8,%esp
  8011ac:	ff 75 ec             	pushl  -0x14(%ebp)
  8011af:	68 b3 3e 80 00       	push   $0x803eb3
  8011b4:	e8 21 f8 ff ff       	call   8009da <cprintf>
  8011b9:	83 c4 10             	add    $0x10,%esp
			sys_enable_interrupt();
  8011bc:	e8 c4 0e 00 00       	call   802085 <sys_enable_interrupt>
			return;
  8011c1:	e9 9a 00 00 00       	jmp    801260 <atomic_readline+0x106>
		} else if (c >= ' ' && i < BUFLEN-1) {
  8011c6:	83 7d ec 1f          	cmpl   $0x1f,-0x14(%ebp)
  8011ca:	7e 34                	jle    801200 <atomic_readline+0xa6>
  8011cc:	81 7d f4 fe 03 00 00 	cmpl   $0x3fe,-0xc(%ebp)
  8011d3:	7f 2b                	jg     801200 <atomic_readline+0xa6>
			if (echoing)
  8011d5:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8011d9:	74 0e                	je     8011e9 <atomic_readline+0x8f>
				cputchar(c);
  8011db:	83 ec 0c             	sub    $0xc,%esp
  8011de:	ff 75 ec             	pushl  -0x14(%ebp)
  8011e1:	e8 64 f3 ff ff       	call   80054a <cputchar>
  8011e6:	83 c4 10             	add    $0x10,%esp
			buf[i++] = c;
  8011e9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8011ec:	8d 50 01             	lea    0x1(%eax),%edx
  8011ef:	89 55 f4             	mov    %edx,-0xc(%ebp)
  8011f2:	89 c2                	mov    %eax,%edx
  8011f4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011f7:	01 d0                	add    %edx,%eax
  8011f9:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8011fc:	88 10                	mov    %dl,(%eax)
  8011fe:	eb 5b                	jmp    80125b <atomic_readline+0x101>
		} else if (c == '\b' && i > 0) {
  801200:	83 7d ec 08          	cmpl   $0x8,-0x14(%ebp)
  801204:	75 1f                	jne    801225 <atomic_readline+0xcb>
  801206:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80120a:	7e 19                	jle    801225 <atomic_readline+0xcb>
			if (echoing)
  80120c:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801210:	74 0e                	je     801220 <atomic_readline+0xc6>
				cputchar(c);
  801212:	83 ec 0c             	sub    $0xc,%esp
  801215:	ff 75 ec             	pushl  -0x14(%ebp)
  801218:	e8 2d f3 ff ff       	call   80054a <cputchar>
  80121d:	83 c4 10             	add    $0x10,%esp
			i--;
  801220:	ff 4d f4             	decl   -0xc(%ebp)
  801223:	eb 36                	jmp    80125b <atomic_readline+0x101>
		} else if (c == '\n' || c == '\r') {
  801225:	83 7d ec 0a          	cmpl   $0xa,-0x14(%ebp)
  801229:	74 0a                	je     801235 <atomic_readline+0xdb>
  80122b:	83 7d ec 0d          	cmpl   $0xd,-0x14(%ebp)
  80122f:	0f 85 60 ff ff ff    	jne    801195 <atomic_readline+0x3b>
			if (echoing)
  801235:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801239:	74 0e                	je     801249 <atomic_readline+0xef>
				cputchar(c);
  80123b:	83 ec 0c             	sub    $0xc,%esp
  80123e:	ff 75 ec             	pushl  -0x14(%ebp)
  801241:	e8 04 f3 ff ff       	call   80054a <cputchar>
  801246:	83 c4 10             	add    $0x10,%esp
			buf[i] = 0;
  801249:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80124c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80124f:	01 d0                	add    %edx,%eax
  801251:	c6 00 00             	movb   $0x0,(%eax)
			sys_enable_interrupt();
  801254:	e8 2c 0e 00 00       	call   802085 <sys_enable_interrupt>
			return;
  801259:	eb 05                	jmp    801260 <atomic_readline+0x106>
		}
	}
  80125b:	e9 35 ff ff ff       	jmp    801195 <atomic_readline+0x3b>
}
  801260:	c9                   	leave  
  801261:	c3                   	ret    

00801262 <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  801262:	55                   	push   %ebp
  801263:	89 e5                	mov    %esp,%ebp
  801265:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  801268:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  80126f:	eb 06                	jmp    801277 <strlen+0x15>
		n++;
  801271:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  801274:	ff 45 08             	incl   0x8(%ebp)
  801277:	8b 45 08             	mov    0x8(%ebp),%eax
  80127a:	8a 00                	mov    (%eax),%al
  80127c:	84 c0                	test   %al,%al
  80127e:	75 f1                	jne    801271 <strlen+0xf>
		n++;
	return n;
  801280:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  801283:	c9                   	leave  
  801284:	c3                   	ret    

00801285 <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  801285:	55                   	push   %ebp
  801286:	89 e5                	mov    %esp,%ebp
  801288:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  80128b:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801292:	eb 09                	jmp    80129d <strnlen+0x18>
		n++;
  801294:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  801297:	ff 45 08             	incl   0x8(%ebp)
  80129a:	ff 4d 0c             	decl   0xc(%ebp)
  80129d:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8012a1:	74 09                	je     8012ac <strnlen+0x27>
  8012a3:	8b 45 08             	mov    0x8(%ebp),%eax
  8012a6:	8a 00                	mov    (%eax),%al
  8012a8:	84 c0                	test   %al,%al
  8012aa:	75 e8                	jne    801294 <strnlen+0xf>
		n++;
	return n;
  8012ac:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  8012af:	c9                   	leave  
  8012b0:	c3                   	ret    

008012b1 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  8012b1:	55                   	push   %ebp
  8012b2:	89 e5                	mov    %esp,%ebp
  8012b4:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  8012b7:	8b 45 08             	mov    0x8(%ebp),%eax
  8012ba:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  8012bd:	90                   	nop
  8012be:	8b 45 08             	mov    0x8(%ebp),%eax
  8012c1:	8d 50 01             	lea    0x1(%eax),%edx
  8012c4:	89 55 08             	mov    %edx,0x8(%ebp)
  8012c7:	8b 55 0c             	mov    0xc(%ebp),%edx
  8012ca:	8d 4a 01             	lea    0x1(%edx),%ecx
  8012cd:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  8012d0:	8a 12                	mov    (%edx),%dl
  8012d2:	88 10                	mov    %dl,(%eax)
  8012d4:	8a 00                	mov    (%eax),%al
  8012d6:	84 c0                	test   %al,%al
  8012d8:	75 e4                	jne    8012be <strcpy+0xd>
		/* do nothing */;
	return ret;
  8012da:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  8012dd:	c9                   	leave  
  8012de:	c3                   	ret    

008012df <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  8012df:	55                   	push   %ebp
  8012e0:	89 e5                	mov    %esp,%ebp
  8012e2:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  8012e5:	8b 45 08             	mov    0x8(%ebp),%eax
  8012e8:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  8012eb:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8012f2:	eb 1f                	jmp    801313 <strncpy+0x34>
		*dst++ = *src;
  8012f4:	8b 45 08             	mov    0x8(%ebp),%eax
  8012f7:	8d 50 01             	lea    0x1(%eax),%edx
  8012fa:	89 55 08             	mov    %edx,0x8(%ebp)
  8012fd:	8b 55 0c             	mov    0xc(%ebp),%edx
  801300:	8a 12                	mov    (%edx),%dl
  801302:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  801304:	8b 45 0c             	mov    0xc(%ebp),%eax
  801307:	8a 00                	mov    (%eax),%al
  801309:	84 c0                	test   %al,%al
  80130b:	74 03                	je     801310 <strncpy+0x31>
			src++;
  80130d:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  801310:	ff 45 fc             	incl   -0x4(%ebp)
  801313:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801316:	3b 45 10             	cmp    0x10(%ebp),%eax
  801319:	72 d9                	jb     8012f4 <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  80131b:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  80131e:	c9                   	leave  
  80131f:	c3                   	ret    

00801320 <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  801320:	55                   	push   %ebp
  801321:	89 e5                	mov    %esp,%ebp
  801323:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  801326:	8b 45 08             	mov    0x8(%ebp),%eax
  801329:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  80132c:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801330:	74 30                	je     801362 <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  801332:	eb 16                	jmp    80134a <strlcpy+0x2a>
			*dst++ = *src++;
  801334:	8b 45 08             	mov    0x8(%ebp),%eax
  801337:	8d 50 01             	lea    0x1(%eax),%edx
  80133a:	89 55 08             	mov    %edx,0x8(%ebp)
  80133d:	8b 55 0c             	mov    0xc(%ebp),%edx
  801340:	8d 4a 01             	lea    0x1(%edx),%ecx
  801343:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  801346:	8a 12                	mov    (%edx),%dl
  801348:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  80134a:	ff 4d 10             	decl   0x10(%ebp)
  80134d:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801351:	74 09                	je     80135c <strlcpy+0x3c>
  801353:	8b 45 0c             	mov    0xc(%ebp),%eax
  801356:	8a 00                	mov    (%eax),%al
  801358:	84 c0                	test   %al,%al
  80135a:	75 d8                	jne    801334 <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  80135c:	8b 45 08             	mov    0x8(%ebp),%eax
  80135f:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  801362:	8b 55 08             	mov    0x8(%ebp),%edx
  801365:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801368:	29 c2                	sub    %eax,%edx
  80136a:	89 d0                	mov    %edx,%eax
}
  80136c:	c9                   	leave  
  80136d:	c3                   	ret    

0080136e <strcmp>:

int
strcmp(const char *p, const char *q)
{
  80136e:	55                   	push   %ebp
  80136f:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  801371:	eb 06                	jmp    801379 <strcmp+0xb>
		p++, q++;
  801373:	ff 45 08             	incl   0x8(%ebp)
  801376:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  801379:	8b 45 08             	mov    0x8(%ebp),%eax
  80137c:	8a 00                	mov    (%eax),%al
  80137e:	84 c0                	test   %al,%al
  801380:	74 0e                	je     801390 <strcmp+0x22>
  801382:	8b 45 08             	mov    0x8(%ebp),%eax
  801385:	8a 10                	mov    (%eax),%dl
  801387:	8b 45 0c             	mov    0xc(%ebp),%eax
  80138a:	8a 00                	mov    (%eax),%al
  80138c:	38 c2                	cmp    %al,%dl
  80138e:	74 e3                	je     801373 <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  801390:	8b 45 08             	mov    0x8(%ebp),%eax
  801393:	8a 00                	mov    (%eax),%al
  801395:	0f b6 d0             	movzbl %al,%edx
  801398:	8b 45 0c             	mov    0xc(%ebp),%eax
  80139b:	8a 00                	mov    (%eax),%al
  80139d:	0f b6 c0             	movzbl %al,%eax
  8013a0:	29 c2                	sub    %eax,%edx
  8013a2:	89 d0                	mov    %edx,%eax
}
  8013a4:	5d                   	pop    %ebp
  8013a5:	c3                   	ret    

008013a6 <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  8013a6:	55                   	push   %ebp
  8013a7:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  8013a9:	eb 09                	jmp    8013b4 <strncmp+0xe>
		n--, p++, q++;
  8013ab:	ff 4d 10             	decl   0x10(%ebp)
  8013ae:	ff 45 08             	incl   0x8(%ebp)
  8013b1:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  8013b4:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8013b8:	74 17                	je     8013d1 <strncmp+0x2b>
  8013ba:	8b 45 08             	mov    0x8(%ebp),%eax
  8013bd:	8a 00                	mov    (%eax),%al
  8013bf:	84 c0                	test   %al,%al
  8013c1:	74 0e                	je     8013d1 <strncmp+0x2b>
  8013c3:	8b 45 08             	mov    0x8(%ebp),%eax
  8013c6:	8a 10                	mov    (%eax),%dl
  8013c8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8013cb:	8a 00                	mov    (%eax),%al
  8013cd:	38 c2                	cmp    %al,%dl
  8013cf:	74 da                	je     8013ab <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  8013d1:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8013d5:	75 07                	jne    8013de <strncmp+0x38>
		return 0;
  8013d7:	b8 00 00 00 00       	mov    $0x0,%eax
  8013dc:	eb 14                	jmp    8013f2 <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  8013de:	8b 45 08             	mov    0x8(%ebp),%eax
  8013e1:	8a 00                	mov    (%eax),%al
  8013e3:	0f b6 d0             	movzbl %al,%edx
  8013e6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8013e9:	8a 00                	mov    (%eax),%al
  8013eb:	0f b6 c0             	movzbl %al,%eax
  8013ee:	29 c2                	sub    %eax,%edx
  8013f0:	89 d0                	mov    %edx,%eax
}
  8013f2:	5d                   	pop    %ebp
  8013f3:	c3                   	ret    

008013f4 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  8013f4:	55                   	push   %ebp
  8013f5:	89 e5                	mov    %esp,%ebp
  8013f7:	83 ec 04             	sub    $0x4,%esp
  8013fa:	8b 45 0c             	mov    0xc(%ebp),%eax
  8013fd:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  801400:	eb 12                	jmp    801414 <strchr+0x20>
		if (*s == c)
  801402:	8b 45 08             	mov    0x8(%ebp),%eax
  801405:	8a 00                	mov    (%eax),%al
  801407:	3a 45 fc             	cmp    -0x4(%ebp),%al
  80140a:	75 05                	jne    801411 <strchr+0x1d>
			return (char *) s;
  80140c:	8b 45 08             	mov    0x8(%ebp),%eax
  80140f:	eb 11                	jmp    801422 <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  801411:	ff 45 08             	incl   0x8(%ebp)
  801414:	8b 45 08             	mov    0x8(%ebp),%eax
  801417:	8a 00                	mov    (%eax),%al
  801419:	84 c0                	test   %al,%al
  80141b:	75 e5                	jne    801402 <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  80141d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801422:	c9                   	leave  
  801423:	c3                   	ret    

00801424 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  801424:	55                   	push   %ebp
  801425:	89 e5                	mov    %esp,%ebp
  801427:	83 ec 04             	sub    $0x4,%esp
  80142a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80142d:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  801430:	eb 0d                	jmp    80143f <strfind+0x1b>
		if (*s == c)
  801432:	8b 45 08             	mov    0x8(%ebp),%eax
  801435:	8a 00                	mov    (%eax),%al
  801437:	3a 45 fc             	cmp    -0x4(%ebp),%al
  80143a:	74 0e                	je     80144a <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  80143c:	ff 45 08             	incl   0x8(%ebp)
  80143f:	8b 45 08             	mov    0x8(%ebp),%eax
  801442:	8a 00                	mov    (%eax),%al
  801444:	84 c0                	test   %al,%al
  801446:	75 ea                	jne    801432 <strfind+0xe>
  801448:	eb 01                	jmp    80144b <strfind+0x27>
		if (*s == c)
			break;
  80144a:	90                   	nop
	return (char *) s;
  80144b:	8b 45 08             	mov    0x8(%ebp),%eax
}
  80144e:	c9                   	leave  
  80144f:	c3                   	ret    

00801450 <memset>:


void *
memset(void *v, int c, uint32 n)
{
  801450:	55                   	push   %ebp
  801451:	89 e5                	mov    %esp,%ebp
  801453:	83 ec 10             	sub    $0x10,%esp
	char *p;
	int m;

	p = v;
  801456:	8b 45 08             	mov    0x8(%ebp),%eax
  801459:	89 45 fc             	mov    %eax,-0x4(%ebp)
	m = n;
  80145c:	8b 45 10             	mov    0x10(%ebp),%eax
  80145f:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (--m >= 0)
  801462:	eb 0e                	jmp    801472 <memset+0x22>
		*p++ = c;
  801464:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801467:	8d 50 01             	lea    0x1(%eax),%edx
  80146a:	89 55 fc             	mov    %edx,-0x4(%ebp)
  80146d:	8b 55 0c             	mov    0xc(%ebp),%edx
  801470:	88 10                	mov    %dl,(%eax)
	char *p;
	int m;

	p = v;
	m = n;
	while (--m >= 0)
  801472:	ff 4d f8             	decl   -0x8(%ebp)
  801475:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  801479:	79 e9                	jns    801464 <memset+0x14>
		*p++ = c;

	return v;
  80147b:	8b 45 08             	mov    0x8(%ebp),%eax
}
  80147e:	c9                   	leave  
  80147f:	c3                   	ret    

00801480 <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  801480:	55                   	push   %ebp
  801481:	89 e5                	mov    %esp,%ebp
  801483:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  801486:	8b 45 0c             	mov    0xc(%ebp),%eax
  801489:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  80148c:	8b 45 08             	mov    0x8(%ebp),%eax
  80148f:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (n-- > 0)
  801492:	eb 16                	jmp    8014aa <memcpy+0x2a>
		*d++ = *s++;
  801494:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801497:	8d 50 01             	lea    0x1(%eax),%edx
  80149a:	89 55 f8             	mov    %edx,-0x8(%ebp)
  80149d:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8014a0:	8d 4a 01             	lea    0x1(%edx),%ecx
  8014a3:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  8014a6:	8a 12                	mov    (%edx),%dl
  8014a8:	88 10                	mov    %dl,(%eax)
	const char *s;
	char *d;

	s = src;
	d = dst;
	while (n-- > 0)
  8014aa:	8b 45 10             	mov    0x10(%ebp),%eax
  8014ad:	8d 50 ff             	lea    -0x1(%eax),%edx
  8014b0:	89 55 10             	mov    %edx,0x10(%ebp)
  8014b3:	85 c0                	test   %eax,%eax
  8014b5:	75 dd                	jne    801494 <memcpy+0x14>
		*d++ = *s++;

	return dst;
  8014b7:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8014ba:	c9                   	leave  
  8014bb:	c3                   	ret    

008014bc <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  8014bc:	55                   	push   %ebp
  8014bd:	89 e5                	mov    %esp,%ebp
  8014bf:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  8014c2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8014c5:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  8014c8:	8b 45 08             	mov    0x8(%ebp),%eax
  8014cb:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  8014ce:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8014d1:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  8014d4:	73 50                	jae    801526 <memmove+0x6a>
  8014d6:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8014d9:	8b 45 10             	mov    0x10(%ebp),%eax
  8014dc:	01 d0                	add    %edx,%eax
  8014de:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  8014e1:	76 43                	jbe    801526 <memmove+0x6a>
		s += n;
  8014e3:	8b 45 10             	mov    0x10(%ebp),%eax
  8014e6:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  8014e9:	8b 45 10             	mov    0x10(%ebp),%eax
  8014ec:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  8014ef:	eb 10                	jmp    801501 <memmove+0x45>
			*--d = *--s;
  8014f1:	ff 4d f8             	decl   -0x8(%ebp)
  8014f4:	ff 4d fc             	decl   -0x4(%ebp)
  8014f7:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8014fa:	8a 10                	mov    (%eax),%dl
  8014fc:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8014ff:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  801501:	8b 45 10             	mov    0x10(%ebp),%eax
  801504:	8d 50 ff             	lea    -0x1(%eax),%edx
  801507:	89 55 10             	mov    %edx,0x10(%ebp)
  80150a:	85 c0                	test   %eax,%eax
  80150c:	75 e3                	jne    8014f1 <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  80150e:	eb 23                	jmp    801533 <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  801510:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801513:	8d 50 01             	lea    0x1(%eax),%edx
  801516:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801519:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80151c:	8d 4a 01             	lea    0x1(%edx),%ecx
  80151f:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  801522:	8a 12                	mov    (%edx),%dl
  801524:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  801526:	8b 45 10             	mov    0x10(%ebp),%eax
  801529:	8d 50 ff             	lea    -0x1(%eax),%edx
  80152c:	89 55 10             	mov    %edx,0x10(%ebp)
  80152f:	85 c0                	test   %eax,%eax
  801531:	75 dd                	jne    801510 <memmove+0x54>
			*d++ = *s++;

	return dst;
  801533:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801536:	c9                   	leave  
  801537:	c3                   	ret    

00801538 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  801538:	55                   	push   %ebp
  801539:	89 e5                	mov    %esp,%ebp
  80153b:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  80153e:	8b 45 08             	mov    0x8(%ebp),%eax
  801541:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  801544:	8b 45 0c             	mov    0xc(%ebp),%eax
  801547:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  80154a:	eb 2a                	jmp    801576 <memcmp+0x3e>
		if (*s1 != *s2)
  80154c:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80154f:	8a 10                	mov    (%eax),%dl
  801551:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801554:	8a 00                	mov    (%eax),%al
  801556:	38 c2                	cmp    %al,%dl
  801558:	74 16                	je     801570 <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  80155a:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80155d:	8a 00                	mov    (%eax),%al
  80155f:	0f b6 d0             	movzbl %al,%edx
  801562:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801565:	8a 00                	mov    (%eax),%al
  801567:	0f b6 c0             	movzbl %al,%eax
  80156a:	29 c2                	sub    %eax,%edx
  80156c:	89 d0                	mov    %edx,%eax
  80156e:	eb 18                	jmp    801588 <memcmp+0x50>
		s1++, s2++;
  801570:	ff 45 fc             	incl   -0x4(%ebp)
  801573:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  801576:	8b 45 10             	mov    0x10(%ebp),%eax
  801579:	8d 50 ff             	lea    -0x1(%eax),%edx
  80157c:	89 55 10             	mov    %edx,0x10(%ebp)
  80157f:	85 c0                	test   %eax,%eax
  801581:	75 c9                	jne    80154c <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  801583:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801588:	c9                   	leave  
  801589:	c3                   	ret    

0080158a <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  80158a:	55                   	push   %ebp
  80158b:	89 e5                	mov    %esp,%ebp
  80158d:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  801590:	8b 55 08             	mov    0x8(%ebp),%edx
  801593:	8b 45 10             	mov    0x10(%ebp),%eax
  801596:	01 d0                	add    %edx,%eax
  801598:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  80159b:	eb 15                	jmp    8015b2 <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  80159d:	8b 45 08             	mov    0x8(%ebp),%eax
  8015a0:	8a 00                	mov    (%eax),%al
  8015a2:	0f b6 d0             	movzbl %al,%edx
  8015a5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8015a8:	0f b6 c0             	movzbl %al,%eax
  8015ab:	39 c2                	cmp    %eax,%edx
  8015ad:	74 0d                	je     8015bc <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  8015af:	ff 45 08             	incl   0x8(%ebp)
  8015b2:	8b 45 08             	mov    0x8(%ebp),%eax
  8015b5:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  8015b8:	72 e3                	jb     80159d <memfind+0x13>
  8015ba:	eb 01                	jmp    8015bd <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  8015bc:	90                   	nop
	return (void *) s;
  8015bd:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8015c0:	c9                   	leave  
  8015c1:	c3                   	ret    

008015c2 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  8015c2:	55                   	push   %ebp
  8015c3:	89 e5                	mov    %esp,%ebp
  8015c5:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  8015c8:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  8015cf:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  8015d6:	eb 03                	jmp    8015db <strtol+0x19>
		s++;
  8015d8:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  8015db:	8b 45 08             	mov    0x8(%ebp),%eax
  8015de:	8a 00                	mov    (%eax),%al
  8015e0:	3c 20                	cmp    $0x20,%al
  8015e2:	74 f4                	je     8015d8 <strtol+0x16>
  8015e4:	8b 45 08             	mov    0x8(%ebp),%eax
  8015e7:	8a 00                	mov    (%eax),%al
  8015e9:	3c 09                	cmp    $0x9,%al
  8015eb:	74 eb                	je     8015d8 <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  8015ed:	8b 45 08             	mov    0x8(%ebp),%eax
  8015f0:	8a 00                	mov    (%eax),%al
  8015f2:	3c 2b                	cmp    $0x2b,%al
  8015f4:	75 05                	jne    8015fb <strtol+0x39>
		s++;
  8015f6:	ff 45 08             	incl   0x8(%ebp)
  8015f9:	eb 13                	jmp    80160e <strtol+0x4c>
	else if (*s == '-')
  8015fb:	8b 45 08             	mov    0x8(%ebp),%eax
  8015fe:	8a 00                	mov    (%eax),%al
  801600:	3c 2d                	cmp    $0x2d,%al
  801602:	75 0a                	jne    80160e <strtol+0x4c>
		s++, neg = 1;
  801604:	ff 45 08             	incl   0x8(%ebp)
  801607:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  80160e:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801612:	74 06                	je     80161a <strtol+0x58>
  801614:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  801618:	75 20                	jne    80163a <strtol+0x78>
  80161a:	8b 45 08             	mov    0x8(%ebp),%eax
  80161d:	8a 00                	mov    (%eax),%al
  80161f:	3c 30                	cmp    $0x30,%al
  801621:	75 17                	jne    80163a <strtol+0x78>
  801623:	8b 45 08             	mov    0x8(%ebp),%eax
  801626:	40                   	inc    %eax
  801627:	8a 00                	mov    (%eax),%al
  801629:	3c 78                	cmp    $0x78,%al
  80162b:	75 0d                	jne    80163a <strtol+0x78>
		s += 2, base = 16;
  80162d:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  801631:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  801638:	eb 28                	jmp    801662 <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  80163a:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80163e:	75 15                	jne    801655 <strtol+0x93>
  801640:	8b 45 08             	mov    0x8(%ebp),%eax
  801643:	8a 00                	mov    (%eax),%al
  801645:	3c 30                	cmp    $0x30,%al
  801647:	75 0c                	jne    801655 <strtol+0x93>
		s++, base = 8;
  801649:	ff 45 08             	incl   0x8(%ebp)
  80164c:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  801653:	eb 0d                	jmp    801662 <strtol+0xa0>
	else if (base == 0)
  801655:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801659:	75 07                	jne    801662 <strtol+0xa0>
		base = 10;
  80165b:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  801662:	8b 45 08             	mov    0x8(%ebp),%eax
  801665:	8a 00                	mov    (%eax),%al
  801667:	3c 2f                	cmp    $0x2f,%al
  801669:	7e 19                	jle    801684 <strtol+0xc2>
  80166b:	8b 45 08             	mov    0x8(%ebp),%eax
  80166e:	8a 00                	mov    (%eax),%al
  801670:	3c 39                	cmp    $0x39,%al
  801672:	7f 10                	jg     801684 <strtol+0xc2>
			dig = *s - '0';
  801674:	8b 45 08             	mov    0x8(%ebp),%eax
  801677:	8a 00                	mov    (%eax),%al
  801679:	0f be c0             	movsbl %al,%eax
  80167c:	83 e8 30             	sub    $0x30,%eax
  80167f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801682:	eb 42                	jmp    8016c6 <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  801684:	8b 45 08             	mov    0x8(%ebp),%eax
  801687:	8a 00                	mov    (%eax),%al
  801689:	3c 60                	cmp    $0x60,%al
  80168b:	7e 19                	jle    8016a6 <strtol+0xe4>
  80168d:	8b 45 08             	mov    0x8(%ebp),%eax
  801690:	8a 00                	mov    (%eax),%al
  801692:	3c 7a                	cmp    $0x7a,%al
  801694:	7f 10                	jg     8016a6 <strtol+0xe4>
			dig = *s - 'a' + 10;
  801696:	8b 45 08             	mov    0x8(%ebp),%eax
  801699:	8a 00                	mov    (%eax),%al
  80169b:	0f be c0             	movsbl %al,%eax
  80169e:	83 e8 57             	sub    $0x57,%eax
  8016a1:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8016a4:	eb 20                	jmp    8016c6 <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  8016a6:	8b 45 08             	mov    0x8(%ebp),%eax
  8016a9:	8a 00                	mov    (%eax),%al
  8016ab:	3c 40                	cmp    $0x40,%al
  8016ad:	7e 39                	jle    8016e8 <strtol+0x126>
  8016af:	8b 45 08             	mov    0x8(%ebp),%eax
  8016b2:	8a 00                	mov    (%eax),%al
  8016b4:	3c 5a                	cmp    $0x5a,%al
  8016b6:	7f 30                	jg     8016e8 <strtol+0x126>
			dig = *s - 'A' + 10;
  8016b8:	8b 45 08             	mov    0x8(%ebp),%eax
  8016bb:	8a 00                	mov    (%eax),%al
  8016bd:	0f be c0             	movsbl %al,%eax
  8016c0:	83 e8 37             	sub    $0x37,%eax
  8016c3:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  8016c6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8016c9:	3b 45 10             	cmp    0x10(%ebp),%eax
  8016cc:	7d 19                	jge    8016e7 <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  8016ce:	ff 45 08             	incl   0x8(%ebp)
  8016d1:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8016d4:	0f af 45 10          	imul   0x10(%ebp),%eax
  8016d8:	89 c2                	mov    %eax,%edx
  8016da:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8016dd:	01 d0                	add    %edx,%eax
  8016df:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  8016e2:	e9 7b ff ff ff       	jmp    801662 <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  8016e7:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  8016e8:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8016ec:	74 08                	je     8016f6 <strtol+0x134>
		*endptr = (char *) s;
  8016ee:	8b 45 0c             	mov    0xc(%ebp),%eax
  8016f1:	8b 55 08             	mov    0x8(%ebp),%edx
  8016f4:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  8016f6:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8016fa:	74 07                	je     801703 <strtol+0x141>
  8016fc:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8016ff:	f7 d8                	neg    %eax
  801701:	eb 03                	jmp    801706 <strtol+0x144>
  801703:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  801706:	c9                   	leave  
  801707:	c3                   	ret    

00801708 <ltostr>:

void
ltostr(long value, char *str)
{
  801708:	55                   	push   %ebp
  801709:	89 e5                	mov    %esp,%ebp
  80170b:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  80170e:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  801715:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  80171c:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801720:	79 13                	jns    801735 <ltostr+0x2d>
	{
		neg = 1;
  801722:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  801729:	8b 45 0c             	mov    0xc(%ebp),%eax
  80172c:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  80172f:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  801732:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  801735:	8b 45 08             	mov    0x8(%ebp),%eax
  801738:	b9 0a 00 00 00       	mov    $0xa,%ecx
  80173d:	99                   	cltd   
  80173e:	f7 f9                	idiv   %ecx
  801740:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  801743:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801746:	8d 50 01             	lea    0x1(%eax),%edx
  801749:	89 55 f8             	mov    %edx,-0x8(%ebp)
  80174c:	89 c2                	mov    %eax,%edx
  80174e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801751:	01 d0                	add    %edx,%eax
  801753:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801756:	83 c2 30             	add    $0x30,%edx
  801759:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  80175b:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80175e:	b8 67 66 66 66       	mov    $0x66666667,%eax
  801763:	f7 e9                	imul   %ecx
  801765:	c1 fa 02             	sar    $0x2,%edx
  801768:	89 c8                	mov    %ecx,%eax
  80176a:	c1 f8 1f             	sar    $0x1f,%eax
  80176d:	29 c2                	sub    %eax,%edx
  80176f:	89 d0                	mov    %edx,%eax
  801771:	89 45 08             	mov    %eax,0x8(%ebp)
	} while (value % 10 != 0);
  801774:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801777:	b8 67 66 66 66       	mov    $0x66666667,%eax
  80177c:	f7 e9                	imul   %ecx
  80177e:	c1 fa 02             	sar    $0x2,%edx
  801781:	89 c8                	mov    %ecx,%eax
  801783:	c1 f8 1f             	sar    $0x1f,%eax
  801786:	29 c2                	sub    %eax,%edx
  801788:	89 d0                	mov    %edx,%eax
  80178a:	c1 e0 02             	shl    $0x2,%eax
  80178d:	01 d0                	add    %edx,%eax
  80178f:	01 c0                	add    %eax,%eax
  801791:	29 c1                	sub    %eax,%ecx
  801793:	89 ca                	mov    %ecx,%edx
  801795:	85 d2                	test   %edx,%edx
  801797:	75 9c                	jne    801735 <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  801799:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  8017a0:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8017a3:	48                   	dec    %eax
  8017a4:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  8017a7:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8017ab:	74 3d                	je     8017ea <ltostr+0xe2>
		start = 1 ;
  8017ad:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  8017b4:	eb 34                	jmp    8017ea <ltostr+0xe2>
	{
		char tmp = str[start] ;
  8017b6:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8017b9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8017bc:	01 d0                	add    %edx,%eax
  8017be:	8a 00                	mov    (%eax),%al
  8017c0:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  8017c3:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8017c6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8017c9:	01 c2                	add    %eax,%edx
  8017cb:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  8017ce:	8b 45 0c             	mov    0xc(%ebp),%eax
  8017d1:	01 c8                	add    %ecx,%eax
  8017d3:	8a 00                	mov    (%eax),%al
  8017d5:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  8017d7:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8017da:	8b 45 0c             	mov    0xc(%ebp),%eax
  8017dd:	01 c2                	add    %eax,%edx
  8017df:	8a 45 eb             	mov    -0x15(%ebp),%al
  8017e2:	88 02                	mov    %al,(%edx)
		start++ ;
  8017e4:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  8017e7:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  8017ea:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8017ed:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8017f0:	7c c4                	jl     8017b6 <ltostr+0xae>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  8017f2:	8b 55 f8             	mov    -0x8(%ebp),%edx
  8017f5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8017f8:	01 d0                	add    %edx,%eax
  8017fa:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  8017fd:	90                   	nop
  8017fe:	c9                   	leave  
  8017ff:	c3                   	ret    

00801800 <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  801800:	55                   	push   %ebp
  801801:	89 e5                	mov    %esp,%ebp
  801803:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  801806:	ff 75 08             	pushl  0x8(%ebp)
  801809:	e8 54 fa ff ff       	call   801262 <strlen>
  80180e:	83 c4 04             	add    $0x4,%esp
  801811:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  801814:	ff 75 0c             	pushl  0xc(%ebp)
  801817:	e8 46 fa ff ff       	call   801262 <strlen>
  80181c:	83 c4 04             	add    $0x4,%esp
  80181f:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  801822:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  801829:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801830:	eb 17                	jmp    801849 <strcconcat+0x49>
		final[s] = str1[s] ;
  801832:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801835:	8b 45 10             	mov    0x10(%ebp),%eax
  801838:	01 c2                	add    %eax,%edx
  80183a:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  80183d:	8b 45 08             	mov    0x8(%ebp),%eax
  801840:	01 c8                	add    %ecx,%eax
  801842:	8a 00                	mov    (%eax),%al
  801844:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  801846:	ff 45 fc             	incl   -0x4(%ebp)
  801849:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80184c:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  80184f:	7c e1                	jl     801832 <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  801851:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  801858:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  80185f:	eb 1f                	jmp    801880 <strcconcat+0x80>
		final[s++] = str2[i] ;
  801861:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801864:	8d 50 01             	lea    0x1(%eax),%edx
  801867:	89 55 fc             	mov    %edx,-0x4(%ebp)
  80186a:	89 c2                	mov    %eax,%edx
  80186c:	8b 45 10             	mov    0x10(%ebp),%eax
  80186f:	01 c2                	add    %eax,%edx
  801871:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  801874:	8b 45 0c             	mov    0xc(%ebp),%eax
  801877:	01 c8                	add    %ecx,%eax
  801879:	8a 00                	mov    (%eax),%al
  80187b:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  80187d:	ff 45 f8             	incl   -0x8(%ebp)
  801880:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801883:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801886:	7c d9                	jl     801861 <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  801888:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80188b:	8b 45 10             	mov    0x10(%ebp),%eax
  80188e:	01 d0                	add    %edx,%eax
  801890:	c6 00 00             	movb   $0x0,(%eax)
}
  801893:	90                   	nop
  801894:	c9                   	leave  
  801895:	c3                   	ret    

00801896 <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  801896:	55                   	push   %ebp
  801897:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  801899:	8b 45 14             	mov    0x14(%ebp),%eax
  80189c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  8018a2:	8b 45 14             	mov    0x14(%ebp),%eax
  8018a5:	8b 00                	mov    (%eax),%eax
  8018a7:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8018ae:	8b 45 10             	mov    0x10(%ebp),%eax
  8018b1:	01 d0                	add    %edx,%eax
  8018b3:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  8018b9:	eb 0c                	jmp    8018c7 <strsplit+0x31>
			*string++ = 0;
  8018bb:	8b 45 08             	mov    0x8(%ebp),%eax
  8018be:	8d 50 01             	lea    0x1(%eax),%edx
  8018c1:	89 55 08             	mov    %edx,0x8(%ebp)
  8018c4:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  8018c7:	8b 45 08             	mov    0x8(%ebp),%eax
  8018ca:	8a 00                	mov    (%eax),%al
  8018cc:	84 c0                	test   %al,%al
  8018ce:	74 18                	je     8018e8 <strsplit+0x52>
  8018d0:	8b 45 08             	mov    0x8(%ebp),%eax
  8018d3:	8a 00                	mov    (%eax),%al
  8018d5:	0f be c0             	movsbl %al,%eax
  8018d8:	50                   	push   %eax
  8018d9:	ff 75 0c             	pushl  0xc(%ebp)
  8018dc:	e8 13 fb ff ff       	call   8013f4 <strchr>
  8018e1:	83 c4 08             	add    $0x8,%esp
  8018e4:	85 c0                	test   %eax,%eax
  8018e6:	75 d3                	jne    8018bb <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  8018e8:	8b 45 08             	mov    0x8(%ebp),%eax
  8018eb:	8a 00                	mov    (%eax),%al
  8018ed:	84 c0                	test   %al,%al
  8018ef:	74 5a                	je     80194b <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  8018f1:	8b 45 14             	mov    0x14(%ebp),%eax
  8018f4:	8b 00                	mov    (%eax),%eax
  8018f6:	83 f8 0f             	cmp    $0xf,%eax
  8018f9:	75 07                	jne    801902 <strsplit+0x6c>
		{
			return 0;
  8018fb:	b8 00 00 00 00       	mov    $0x0,%eax
  801900:	eb 66                	jmp    801968 <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  801902:	8b 45 14             	mov    0x14(%ebp),%eax
  801905:	8b 00                	mov    (%eax),%eax
  801907:	8d 48 01             	lea    0x1(%eax),%ecx
  80190a:	8b 55 14             	mov    0x14(%ebp),%edx
  80190d:	89 0a                	mov    %ecx,(%edx)
  80190f:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801916:	8b 45 10             	mov    0x10(%ebp),%eax
  801919:	01 c2                	add    %eax,%edx
  80191b:	8b 45 08             	mov    0x8(%ebp),%eax
  80191e:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  801920:	eb 03                	jmp    801925 <strsplit+0x8f>
			string++;
  801922:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  801925:	8b 45 08             	mov    0x8(%ebp),%eax
  801928:	8a 00                	mov    (%eax),%al
  80192a:	84 c0                	test   %al,%al
  80192c:	74 8b                	je     8018b9 <strsplit+0x23>
  80192e:	8b 45 08             	mov    0x8(%ebp),%eax
  801931:	8a 00                	mov    (%eax),%al
  801933:	0f be c0             	movsbl %al,%eax
  801936:	50                   	push   %eax
  801937:	ff 75 0c             	pushl  0xc(%ebp)
  80193a:	e8 b5 fa ff ff       	call   8013f4 <strchr>
  80193f:	83 c4 08             	add    $0x8,%esp
  801942:	85 c0                	test   %eax,%eax
  801944:	74 dc                	je     801922 <strsplit+0x8c>
			string++;
	}
  801946:	e9 6e ff ff ff       	jmp    8018b9 <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  80194b:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  80194c:	8b 45 14             	mov    0x14(%ebp),%eax
  80194f:	8b 00                	mov    (%eax),%eax
  801951:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801958:	8b 45 10             	mov    0x10(%ebp),%eax
  80195b:	01 d0                	add    %edx,%eax
  80195d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  801963:	b8 01 00 00 00       	mov    $0x1,%eax
}
  801968:	c9                   	leave  
  801969:	c3                   	ret    

0080196a <InitializeUHeap>:
//============================== GIVEN FUNCTIONS ===================================//
//==================================================================================//

int FirstTimeFlag = 1;
void InitializeUHeap()
{
  80196a:	55                   	push   %ebp
  80196b:	89 e5                	mov    %esp,%ebp
  80196d:	83 ec 08             	sub    $0x8,%esp
	if(FirstTimeFlag)
  801970:	a1 04 50 80 00       	mov    0x805004,%eax
  801975:	85 c0                	test   %eax,%eax
  801977:	74 1f                	je     801998 <InitializeUHeap+0x2e>
	{
		initialize_dyn_block_system();
  801979:	e8 1d 00 00 00       	call   80199b <initialize_dyn_block_system>
		cprintf("DYNAMIC BLOCK SYSTEM IS INITIALIZED\n");
  80197e:	83 ec 0c             	sub    $0xc,%esp
  801981:	68 c4 3e 80 00       	push   $0x803ec4
  801986:	e8 4f f0 ff ff       	call   8009da <cprintf>
  80198b:	83 c4 10             	add    $0x10,%esp
#if UHP_USE_BUDDY
		initialize_buddy();
		cprintf("BUDDY SYSTEM IS INITIALIZED\n");
#endif
		FirstTimeFlag = 0;
  80198e:	c7 05 04 50 80 00 00 	movl   $0x0,0x805004
  801995:	00 00 00 
	}
}
  801998:	90                   	nop
  801999:	c9                   	leave  
  80199a:	c3                   	ret    

0080199b <initialize_dyn_block_system>:

//=================================
// [1] INITIALIZE DYNAMIC ALLOCATOR:
//=================================
void initialize_dyn_block_system()
{
  80199b:	55                   	push   %ebp
  80199c:	89 e5                	mov    %esp,%ebp
  80199e:	83 ec 28             	sub    $0x28,%esp
	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] initialize_dyn_block_system
	// your code is here, remove the panic and write your code
	//panic("initialize_dyn_block_system() is not implemented yet...!!");

	LIST_INIT(&AllocMemBlocksList);
  8019a1:	c7 05 40 50 80 00 00 	movl   $0x0,0x805040
  8019a8:	00 00 00 
  8019ab:	c7 05 44 50 80 00 00 	movl   $0x0,0x805044
  8019b2:	00 00 00 
  8019b5:	c7 05 4c 50 80 00 00 	movl   $0x0,0x80504c
  8019bc:	00 00 00 
	LIST_INIT(&FreeMemBlocksList);
  8019bf:	c7 05 38 51 80 00 00 	movl   $0x0,0x805138
  8019c6:	00 00 00 
  8019c9:	c7 05 3c 51 80 00 00 	movl   $0x0,0x80513c
  8019d0:	00 00 00 
  8019d3:	c7 05 44 51 80 00 00 	movl   $0x0,0x805144
  8019da:	00 00 00 
	MAX_MEM_BLOCK_CNT = NUM_OF_UHEAP_PAGES;
  8019dd:	c7 05 20 51 80 00 00 	movl   $0x20000,0x805120
  8019e4:	00 02 00 
	MemBlockNodes = (void*)USER_DYN_BLKS_ARRAY;
  8019e7:	c7 45 f4 00 00 e0 7f 	movl   $0x7fe00000,-0xc(%ebp)
  8019ee:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8019f1:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8019f6:	2d 00 10 00 00       	sub    $0x1000,%eax
  8019fb:	a3 50 50 80 00       	mov    %eax,0x805050
	int size_of_block = sizeof(struct MemBlock);
  801a00:	c7 45 f0 10 00 00 00 	movl   $0x10,-0x10(%ebp)
	int size_all_struct = size_of_block*MAX_MEM_BLOCK_CNT;
  801a07:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801a0a:	a1 20 51 80 00       	mov    0x805120,%eax
  801a0f:	0f af c2             	imul   %edx,%eax
  801a12:	89 45 ec             	mov    %eax,-0x14(%ebp)
	size_all_struct = ROUNDUP(size_all_struct, PAGE_SIZE);
  801a15:	c7 45 e8 00 10 00 00 	movl   $0x1000,-0x18(%ebp)
  801a1c:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801a1f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801a22:	01 d0                	add    %edx,%eax
  801a24:	48                   	dec    %eax
  801a25:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  801a28:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801a2b:	ba 00 00 00 00       	mov    $0x0,%edx
  801a30:	f7 75 e8             	divl   -0x18(%ebp)
  801a33:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801a36:	29 d0                	sub    %edx,%eax
  801a38:	89 45 ec             	mov    %eax,-0x14(%ebp)
	sys_allocate_chunk(USER_DYN_BLKS_ARRAY, size_all_struct,PERM_USER| PERM_WRITEABLE);
  801a3b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801a3e:	c7 45 e0 00 00 e0 7f 	movl   $0x7fe00000,-0x20(%ebp)
  801a45:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801a48:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
  801a4e:	81 ea 00 10 00 00    	sub    $0x1000,%edx
  801a54:	83 ec 04             	sub    $0x4,%esp
  801a57:	6a 06                	push   $0x6
  801a59:	50                   	push   %eax
  801a5a:	52                   	push   %edx
  801a5b:	e8 a1 05 00 00       	call   802001 <sys_allocate_chunk>
  801a60:	83 c4 10             	add    $0x10,%esp
	initialize_MemBlocksList(MAX_MEM_BLOCK_CNT);
  801a63:	a1 20 51 80 00       	mov    0x805120,%eax
  801a68:	83 ec 0c             	sub    $0xc,%esp
  801a6b:	50                   	push   %eax
  801a6c:	e8 16 0c 00 00       	call   802687 <initialize_MemBlocksList>
  801a71:	83 c4 10             	add    $0x10,%esp
	struct MemBlock* ourBlock =LIST_LAST(&AvailableMemBlocksList);
  801a74:	a1 4c 51 80 00       	mov    0x80514c,%eax
  801a79:	89 45 dc             	mov    %eax,-0x24(%ebp)
	LIST_REMOVE(&AvailableMemBlocksList,ourBlock);
  801a7c:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  801a80:	75 14                	jne    801a96 <initialize_dyn_block_system+0xfb>
  801a82:	83 ec 04             	sub    $0x4,%esp
  801a85:	68 e9 3e 80 00       	push   $0x803ee9
  801a8a:	6a 2d                	push   $0x2d
  801a8c:	68 07 3f 80 00       	push   $0x803f07
  801a91:	e8 90 ec ff ff       	call   800726 <_panic>
  801a96:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801a99:	8b 00                	mov    (%eax),%eax
  801a9b:	85 c0                	test   %eax,%eax
  801a9d:	74 10                	je     801aaf <initialize_dyn_block_system+0x114>
  801a9f:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801aa2:	8b 00                	mov    (%eax),%eax
  801aa4:	8b 55 dc             	mov    -0x24(%ebp),%edx
  801aa7:	8b 52 04             	mov    0x4(%edx),%edx
  801aaa:	89 50 04             	mov    %edx,0x4(%eax)
  801aad:	eb 0b                	jmp    801aba <initialize_dyn_block_system+0x11f>
  801aaf:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801ab2:	8b 40 04             	mov    0x4(%eax),%eax
  801ab5:	a3 4c 51 80 00       	mov    %eax,0x80514c
  801aba:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801abd:	8b 40 04             	mov    0x4(%eax),%eax
  801ac0:	85 c0                	test   %eax,%eax
  801ac2:	74 0f                	je     801ad3 <initialize_dyn_block_system+0x138>
  801ac4:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801ac7:	8b 40 04             	mov    0x4(%eax),%eax
  801aca:	8b 55 dc             	mov    -0x24(%ebp),%edx
  801acd:	8b 12                	mov    (%edx),%edx
  801acf:	89 10                	mov    %edx,(%eax)
  801ad1:	eb 0a                	jmp    801add <initialize_dyn_block_system+0x142>
  801ad3:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801ad6:	8b 00                	mov    (%eax),%eax
  801ad8:	a3 48 51 80 00       	mov    %eax,0x805148
  801add:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801ae0:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  801ae6:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801ae9:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  801af0:	a1 54 51 80 00       	mov    0x805154,%eax
  801af5:	48                   	dec    %eax
  801af6:	a3 54 51 80 00       	mov    %eax,0x805154
	ourBlock->size = USER_HEAP_MAX-USER_HEAP_START;
  801afb:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801afe:	c7 40 0c 00 00 00 20 	movl   $0x20000000,0xc(%eax)
	ourBlock->sva=USER_HEAP_START;
  801b05:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801b08:	c7 40 08 00 00 00 80 	movl   $0x80000000,0x8(%eax)
	LIST_INSERT_TAIL(&FreeMemBlocksList, ourBlock);
  801b0f:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  801b13:	75 14                	jne    801b29 <initialize_dyn_block_system+0x18e>
  801b15:	83 ec 04             	sub    $0x4,%esp
  801b18:	68 14 3f 80 00       	push   $0x803f14
  801b1d:	6a 30                	push   $0x30
  801b1f:	68 07 3f 80 00       	push   $0x803f07
  801b24:	e8 fd eb ff ff       	call   800726 <_panic>
  801b29:	8b 15 3c 51 80 00    	mov    0x80513c,%edx
  801b2f:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801b32:	89 50 04             	mov    %edx,0x4(%eax)
  801b35:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801b38:	8b 40 04             	mov    0x4(%eax),%eax
  801b3b:	85 c0                	test   %eax,%eax
  801b3d:	74 0c                	je     801b4b <initialize_dyn_block_system+0x1b0>
  801b3f:	a1 3c 51 80 00       	mov    0x80513c,%eax
  801b44:	8b 55 dc             	mov    -0x24(%ebp),%edx
  801b47:	89 10                	mov    %edx,(%eax)
  801b49:	eb 08                	jmp    801b53 <initialize_dyn_block_system+0x1b8>
  801b4b:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801b4e:	a3 38 51 80 00       	mov    %eax,0x805138
  801b53:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801b56:	a3 3c 51 80 00       	mov    %eax,0x80513c
  801b5b:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801b5e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  801b64:	a1 44 51 80 00       	mov    0x805144,%eax
  801b69:	40                   	inc    %eax
  801b6a:	a3 44 51 80 00       	mov    %eax,0x805144
	//[1] Initialize two lists (AllocMemBlocksList & FreeMemBlocksList) [Hint: use LIST_INIT()]
	//[2] Dynamically allocate the array of MemBlockNodes at VA USER_DYN_BLKS_ARRAY
	//	  (remember to set MAX_MEM_BLOCK_CNT with the chosen size of the array)
	//[3] Initialize AvailableMemBlocksList by filling it with the MemBlockNodes
	//[4] Insert a new MemBlock with the heap size into the FreeMemBlocksList
}
  801b6f:	90                   	nop
  801b70:	c9                   	leave  
  801b71:	c3                   	ret    

00801b72 <malloc>:
//=================================
// [2] ALLOCATE SPACE IN USER HEAP:
//=================================

void* malloc(uint32 size)
{
  801b72:	55                   	push   %ebp
  801b73:	89 e5                	mov    %esp,%ebp
  801b75:	83 ec 18             	sub    $0x18,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801b78:	e8 ed fd ff ff       	call   80196a <InitializeUHeap>
	if (size == 0) return NULL ;
  801b7d:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801b81:	75 07                	jne    801b8a <malloc+0x18>
  801b83:	b8 00 00 00 00       	mov    $0x0,%eax
  801b88:	eb 67                	jmp    801bf1 <malloc+0x7f>

	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] malloc
	// your code is here, remove the panic and write your code
	//panic("malloc() is not implemented yet...!!");

	size = ROUNDUP(size, PAGE_SIZE);
  801b8a:	c7 45 f4 00 10 00 00 	movl   $0x1000,-0xc(%ebp)
  801b91:	8b 55 08             	mov    0x8(%ebp),%edx
  801b94:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801b97:	01 d0                	add    %edx,%eax
  801b99:	48                   	dec    %eax
  801b9a:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801b9d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801ba0:	ba 00 00 00 00       	mov    $0x0,%edx
  801ba5:	f7 75 f4             	divl   -0xc(%ebp)
  801ba8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801bab:	29 d0                	sub    %edx,%eax
  801bad:	89 45 08             	mov    %eax,0x8(%ebp)
	if(sys_isUHeapPlacementStrategyFIRSTFIT())
  801bb0:	e8 1a 08 00 00       	call   8023cf <sys_isUHeapPlacementStrategyFIRSTFIT>
  801bb5:	85 c0                	test   %eax,%eax
  801bb7:	74 33                	je     801bec <malloc+0x7a>
	{
		struct MemBlock * myBlock = alloc_block_FF(size);
  801bb9:	83 ec 0c             	sub    $0xc,%esp
  801bbc:	ff 75 08             	pushl  0x8(%ebp)
  801bbf:	e8 0c 0e 00 00       	call   8029d0 <alloc_block_FF>
  801bc4:	83 c4 10             	add    $0x10,%esp
  801bc7:	89 45 ec             	mov    %eax,-0x14(%ebp)
		if(myBlock != NULL)
  801bca:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  801bce:	74 1c                	je     801bec <malloc+0x7a>
		{
			insert_sorted_allocList(myBlock);
  801bd0:	83 ec 0c             	sub    $0xc,%esp
  801bd3:	ff 75 ec             	pushl  -0x14(%ebp)
  801bd6:	e8 07 0c 00 00       	call   8027e2 <insert_sorted_allocList>
  801bdb:	83 c4 10             	add    $0x10,%esp
			uint32 ptr = myBlock->sva;
  801bde:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801be1:	8b 40 08             	mov    0x8(%eax),%eax
  801be4:	89 45 e8             	mov    %eax,-0x18(%ebp)
			return (void *)ptr;
  801be7:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801bea:	eb 05                	jmp    801bf1 <malloc+0x7f>
		}
	}
	return NULL;
  801bec:	b8 00 00 00 00       	mov    $0x0,%eax
	//		to the required allocation size (space should be on 4 KB BOUNDARY)
	//	2) if no suitable space found, return NULL
	// 	3) Return pointer containing the virtual address of allocated space,
	//
	//Use sys_isUHeapPlacementStrategyFIRSTFIT()... to check the current strategy
}
  801bf1:	c9                   	leave  
  801bf2:	c3                   	ret    

00801bf3 <free>:
//	We can use sys_free_user_mem(uint32 virtual_address, uint32 size); which
//		switches to the kernel mode, calls free_user_mem() in
//		"kern/mem/chunk_operations.c", then switch back to the user mode here
//	the free_user_mem function is empty, make sure to implement it.
void free(void* virtual_address)
{
  801bf3:	55                   	push   %ebp
  801bf4:	89 e5                	mov    %esp,%ebp
  801bf6:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] free
	// your code is here, remove the panic and write your code
	//panic("free() is not implemented yet...!!");

	uint32 virtualAddress = (uint32 )(virtual_address);
  801bf9:	8b 45 08             	mov    0x8(%ebp),%eax
  801bfc:	89 45 f4             	mov    %eax,-0xc(%ebp)
//	virtualAddress = ROUNDDOWN(virtualAddress, PAGE_SIZE);
	struct MemBlock * myBlock = find_block(&AllocMemBlocksList, virtualAddress);
  801bff:	83 ec 08             	sub    $0x8,%esp
  801c02:	ff 75 f4             	pushl  -0xc(%ebp)
  801c05:	68 40 50 80 00       	push   $0x805040
  801c0a:	e8 5b 0b 00 00       	call   80276a <find_block>
  801c0f:	83 c4 10             	add    $0x10,%esp
  801c12:	89 45 f0             	mov    %eax,-0x10(%ebp)
//	cprintf ("ptr sva at free user side = %x \n", myBlock->sva);
	sys_free_user_mem(virtualAddress, myBlock->size);
  801c15:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801c18:	8b 40 0c             	mov    0xc(%eax),%eax
  801c1b:	83 ec 08             	sub    $0x8,%esp
  801c1e:	50                   	push   %eax
  801c1f:	ff 75 f4             	pushl  -0xc(%ebp)
  801c22:	e8 a2 03 00 00       	call   801fc9 <sys_free_user_mem>
  801c27:	83 c4 10             	add    $0x10,%esp
	LIST_REMOVE(&AllocMemBlocksList, myBlock);
  801c2a:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801c2e:	75 14                	jne    801c44 <free+0x51>
  801c30:	83 ec 04             	sub    $0x4,%esp
  801c33:	68 e9 3e 80 00       	push   $0x803ee9
  801c38:	6a 76                	push   $0x76
  801c3a:	68 07 3f 80 00       	push   $0x803f07
  801c3f:	e8 e2 ea ff ff       	call   800726 <_panic>
  801c44:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801c47:	8b 00                	mov    (%eax),%eax
  801c49:	85 c0                	test   %eax,%eax
  801c4b:	74 10                	je     801c5d <free+0x6a>
  801c4d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801c50:	8b 00                	mov    (%eax),%eax
  801c52:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801c55:	8b 52 04             	mov    0x4(%edx),%edx
  801c58:	89 50 04             	mov    %edx,0x4(%eax)
  801c5b:	eb 0b                	jmp    801c68 <free+0x75>
  801c5d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801c60:	8b 40 04             	mov    0x4(%eax),%eax
  801c63:	a3 44 50 80 00       	mov    %eax,0x805044
  801c68:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801c6b:	8b 40 04             	mov    0x4(%eax),%eax
  801c6e:	85 c0                	test   %eax,%eax
  801c70:	74 0f                	je     801c81 <free+0x8e>
  801c72:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801c75:	8b 40 04             	mov    0x4(%eax),%eax
  801c78:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801c7b:	8b 12                	mov    (%edx),%edx
  801c7d:	89 10                	mov    %edx,(%eax)
  801c7f:	eb 0a                	jmp    801c8b <free+0x98>
  801c81:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801c84:	8b 00                	mov    (%eax),%eax
  801c86:	a3 40 50 80 00       	mov    %eax,0x805040
  801c8b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801c8e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  801c94:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801c97:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  801c9e:	a1 4c 50 80 00       	mov    0x80504c,%eax
  801ca3:	48                   	dec    %eax
  801ca4:	a3 4c 50 80 00       	mov    %eax,0x80504c
	insert_sorted_with_merge_freeList(myBlock);
  801ca9:	83 ec 0c             	sub    $0xc,%esp
  801cac:	ff 75 f0             	pushl  -0x10(%ebp)
  801caf:	e8 0b 14 00 00       	call   8030bf <insert_sorted_with_merge_freeList>
  801cb4:	83 c4 10             	add    $0x10,%esp

	//you should get the size of the given allocation using its address
	//you need to call sys_free_user_mem()
	//refer to the project presentation and documentation for details
}
  801cb7:	90                   	nop
  801cb8:	c9                   	leave  
  801cb9:	c3                   	ret    

00801cba <smalloc>:

//=================================
// [4] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
  801cba:	55                   	push   %ebp
  801cbb:	89 e5                	mov    %esp,%ebp
  801cbd:	83 ec 28             	sub    $0x28,%esp
  801cc0:	8b 45 10             	mov    0x10(%ebp),%eax
  801cc3:	88 45 e4             	mov    %al,-0x1c(%ebp)
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801cc6:	e8 9f fc ff ff       	call   80196a <InitializeUHeap>
	if (size == 0) return NULL ;
  801ccb:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801ccf:	75 0a                	jne    801cdb <smalloc+0x21>
  801cd1:	b8 00 00 00 00       	mov    $0x0,%eax
  801cd6:	e9 8d 00 00 00       	jmp    801d68 <smalloc+0xae>

	//This function should find the space of the required range
	// * ON 4KB BOUNDARY **** //
	//Use sys_isUHeapPlacementStrategyFIRSTFIT() to check the current strategy

	size = ROUNDUP(size, PAGE_SIZE);
  801cdb:	c7 45 f4 00 10 00 00 	movl   $0x1000,-0xc(%ebp)
  801ce2:	8b 55 0c             	mov    0xc(%ebp),%edx
  801ce5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ce8:	01 d0                	add    %edx,%eax
  801cea:	48                   	dec    %eax
  801ceb:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801cee:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801cf1:	ba 00 00 00 00       	mov    $0x0,%edx
  801cf6:	f7 75 f4             	divl   -0xc(%ebp)
  801cf9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801cfc:	29 d0                	sub    %edx,%eax
  801cfe:	89 45 0c             	mov    %eax,0xc(%ebp)
		if(sys_isUHeapPlacementStrategyFIRSTFIT())
  801d01:	e8 c9 06 00 00       	call   8023cf <sys_isUHeapPlacementStrategyFIRSTFIT>
  801d06:	85 c0                	test   %eax,%eax
  801d08:	74 59                	je     801d63 <smalloc+0xa9>
		{
			struct MemBlock * v1=NULL;
  801d0a:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
			v1= alloc_block_FF(size);
  801d11:	83 ec 0c             	sub    $0xc,%esp
  801d14:	ff 75 0c             	pushl  0xc(%ebp)
  801d17:	e8 b4 0c 00 00       	call   8029d0 <alloc_block_FF>
  801d1c:	83 c4 10             	add    $0x10,%esp
  801d1f:	89 45 ec             	mov    %eax,-0x14(%ebp)
			if(v1==NULL)
  801d22:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  801d26:	75 07                	jne    801d2f <smalloc+0x75>
			{
				return NULL;
  801d28:	b8 00 00 00 00       	mov    $0x0,%eax
  801d2d:	eb 39                	jmp    801d68 <smalloc+0xae>
			}
			else
			{
				int ret=sys_createSharedObject(sharedVarName,  size,  isWritable,(void*)v1->sva);
  801d2f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801d32:	8b 40 08             	mov    0x8(%eax),%eax
  801d35:	89 c2                	mov    %eax,%edx
  801d37:	0f b6 45 e4          	movzbl -0x1c(%ebp),%eax
  801d3b:	52                   	push   %edx
  801d3c:	50                   	push   %eax
  801d3d:	ff 75 0c             	pushl  0xc(%ebp)
  801d40:	ff 75 08             	pushl  0x8(%ebp)
  801d43:	e8 0c 04 00 00       	call   802154 <sys_createSharedObject>
  801d48:	83 c4 10             	add    $0x10,%esp
  801d4b:	89 45 e8             	mov    %eax,-0x18(%ebp)
				if(ret>=0)
  801d4e:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  801d52:	78 08                	js     801d5c <smalloc+0xa2>
				{
					return (void*)v1->sva;
  801d54:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801d57:	8b 40 08             	mov    0x8(%eax),%eax
  801d5a:	eb 0c                	jmp    801d68 <smalloc+0xae>
				}
				else
				{
					return NULL;
  801d5c:	b8 00 00 00 00       	mov    $0x0,%eax
  801d61:	eb 05                	jmp    801d68 <smalloc+0xae>
				}
			}

		}
		return NULL;
  801d63:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801d68:	c9                   	leave  
  801d69:	c3                   	ret    

00801d6a <sget>:

//========================================
// [5] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  801d6a:	55                   	push   %ebp
  801d6b:	89 e5                	mov    %esp,%ebp
  801d6d:	83 ec 18             	sub    $0x18,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801d70:	e8 f5 fb ff ff       	call   80196a <InitializeUHeap>

	//This function should find the space for sharing the variable
	// *** ON 4KB BOUNDARY ******** //

	//Use sys_isUHeapPlacementStrategyFIRSTFIT() to check the current strategy
	int ret=sys_getSizeOfSharedObject(ownerEnvID,sharedVarName);
  801d75:	83 ec 08             	sub    $0x8,%esp
  801d78:	ff 75 0c             	pushl  0xc(%ebp)
  801d7b:	ff 75 08             	pushl  0x8(%ebp)
  801d7e:	e8 fb 03 00 00       	call   80217e <sys_getSizeOfSharedObject>
  801d83:	83 c4 10             	add    $0x10,%esp
  801d86:	89 45 f4             	mov    %eax,-0xc(%ebp)
	if(ret==0)
  801d89:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801d8d:	75 07                	jne    801d96 <sget+0x2c>
	{
		return NULL;
  801d8f:	b8 00 00 00 00       	mov    $0x0,%eax
  801d94:	eb 64                	jmp    801dfa <sget+0x90>
	}
	if(sys_isUHeapPlacementStrategyFIRSTFIT())
  801d96:	e8 34 06 00 00       	call   8023cf <sys_isUHeapPlacementStrategyFIRSTFIT>
  801d9b:	85 c0                	test   %eax,%eax
  801d9d:	74 56                	je     801df5 <sget+0x8b>
	{
		struct MemBlock * v1=NULL;
  801d9f:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
		v1= alloc_block_FF(ret);
  801da6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801da9:	83 ec 0c             	sub    $0xc,%esp
  801dac:	50                   	push   %eax
  801dad:	e8 1e 0c 00 00       	call   8029d0 <alloc_block_FF>
  801db2:	83 c4 10             	add    $0x10,%esp
  801db5:	89 45 f0             	mov    %eax,-0x10(%ebp)
		if(v1==NULL)
  801db8:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801dbc:	75 07                	jne    801dc5 <sget+0x5b>
		{
		return NULL;
  801dbe:	b8 00 00 00 00       	mov    $0x0,%eax
  801dc3:	eb 35                	jmp    801dfa <sget+0x90>
	    }
		else
		{
			int ret1=sys_getSharedObject(ownerEnvID,sharedVarName,(void*)v1->sva);
  801dc5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801dc8:	8b 40 08             	mov    0x8(%eax),%eax
  801dcb:	83 ec 04             	sub    $0x4,%esp
  801dce:	50                   	push   %eax
  801dcf:	ff 75 0c             	pushl  0xc(%ebp)
  801dd2:	ff 75 08             	pushl  0x8(%ebp)
  801dd5:	e8 c1 03 00 00       	call   80219b <sys_getSharedObject>
  801dda:	83 c4 10             	add    $0x10,%esp
  801ddd:	89 45 ec             	mov    %eax,-0x14(%ebp)
			if(ret1>=0)
  801de0:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  801de4:	78 08                	js     801dee <sget+0x84>
			{
				return (void*)v1->sva;
  801de6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801de9:	8b 40 08             	mov    0x8(%eax),%eax
  801dec:	eb 0c                	jmp    801dfa <sget+0x90>
			}
			else
			{
				return NULL;
  801dee:	b8 00 00 00 00       	mov    $0x0,%eax
  801df3:	eb 05                	jmp    801dfa <sget+0x90>
			}
		}
	}
  return NULL;
  801df5:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801dfa:	c9                   	leave  
  801dfb:	c3                   	ret    

00801dfc <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  801dfc:	55                   	push   %ebp
  801dfd:	89 e5                	mov    %esp,%ebp
  801dff:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801e02:	e8 63 fb ff ff       	call   80196a <InitializeUHeap>
	//==============================================================
	// [USER HEAP - USER SIDE] realloc
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  801e07:	83 ec 04             	sub    $0x4,%esp
  801e0a:	68 38 3f 80 00       	push   $0x803f38
  801e0f:	68 0e 01 00 00       	push   $0x10e
  801e14:	68 07 3f 80 00       	push   $0x803f07
  801e19:	e8 08 e9 ff ff       	call   800726 <_panic>

00801e1e <sfree>:
//	use sys_freeSharedObject(...); which switches to the kernel mode,
//	calls freeSharedObject(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the freeSharedObject() function is empty, make sure to implement it.

void sfree(void* virtual_address)
{
  801e1e:	55                   	push   %ebp
  801e1f:	89 e5                	mov    %esp,%ebp
  801e21:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS3 - BONUS] [SHARING - USER SIDE] sfree()

	// Write your code here, remove the panic and write your code
	panic("sfree() is not implemented yet...!!");
  801e24:	83 ec 04             	sub    $0x4,%esp
  801e27:	68 60 3f 80 00       	push   $0x803f60
  801e2c:	68 22 01 00 00       	push   $0x122
  801e31:	68 07 3f 80 00       	push   $0x803f07
  801e36:	e8 eb e8 ff ff       	call   800726 <_panic>

00801e3b <expand>:

//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//
void expand(uint32 newSize)
{
  801e3b:	55                   	push   %ebp
  801e3c:	89 e5                	mov    %esp,%ebp
  801e3e:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801e41:	83 ec 04             	sub    $0x4,%esp
  801e44:	68 84 3f 80 00       	push   $0x803f84
  801e49:	68 2d 01 00 00       	push   $0x12d
  801e4e:	68 07 3f 80 00       	push   $0x803f07
  801e53:	e8 ce e8 ff ff       	call   800726 <_panic>

00801e58 <shrink>:

}
void shrink(uint32 newSize)
{
  801e58:	55                   	push   %ebp
  801e59:	89 e5                	mov    %esp,%ebp
  801e5b:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801e5e:	83 ec 04             	sub    $0x4,%esp
  801e61:	68 84 3f 80 00       	push   $0x803f84
  801e66:	68 32 01 00 00       	push   $0x132
  801e6b:	68 07 3f 80 00       	push   $0x803f07
  801e70:	e8 b1 e8 ff ff       	call   800726 <_panic>

00801e75 <freeHeap>:

}
void freeHeap(void* virtual_address)
{
  801e75:	55                   	push   %ebp
  801e76:	89 e5                	mov    %esp,%ebp
  801e78:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801e7b:	83 ec 04             	sub    $0x4,%esp
  801e7e:	68 84 3f 80 00       	push   $0x803f84
  801e83:	68 37 01 00 00       	push   $0x137
  801e88:	68 07 3f 80 00       	push   $0x803f07
  801e8d:	e8 94 e8 ff ff       	call   800726 <_panic>

00801e92 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  801e92:	55                   	push   %ebp
  801e93:	89 e5                	mov    %esp,%ebp
  801e95:	57                   	push   %edi
  801e96:	56                   	push   %esi
  801e97:	53                   	push   %ebx
  801e98:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801e9b:	8b 45 08             	mov    0x8(%ebp),%eax
  801e9e:	8b 55 0c             	mov    0xc(%ebp),%edx
  801ea1:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801ea4:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801ea7:	8b 7d 18             	mov    0x18(%ebp),%edi
  801eaa:	8b 75 1c             	mov    0x1c(%ebp),%esi
  801ead:	cd 30                	int    $0x30
  801eaf:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  801eb2:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801eb5:	83 c4 10             	add    $0x10,%esp
  801eb8:	5b                   	pop    %ebx
  801eb9:	5e                   	pop    %esi
  801eba:	5f                   	pop    %edi
  801ebb:	5d                   	pop    %ebp
  801ebc:	c3                   	ret    

00801ebd <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  801ebd:	55                   	push   %ebp
  801ebe:	89 e5                	mov    %esp,%ebp
  801ec0:	83 ec 04             	sub    $0x4,%esp
  801ec3:	8b 45 10             	mov    0x10(%ebp),%eax
  801ec6:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  801ec9:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801ecd:	8b 45 08             	mov    0x8(%ebp),%eax
  801ed0:	6a 00                	push   $0x0
  801ed2:	6a 00                	push   $0x0
  801ed4:	52                   	push   %edx
  801ed5:	ff 75 0c             	pushl  0xc(%ebp)
  801ed8:	50                   	push   %eax
  801ed9:	6a 00                	push   $0x0
  801edb:	e8 b2 ff ff ff       	call   801e92 <syscall>
  801ee0:	83 c4 18             	add    $0x18,%esp
}
  801ee3:	90                   	nop
  801ee4:	c9                   	leave  
  801ee5:	c3                   	ret    

00801ee6 <sys_cgetc>:

int
sys_cgetc(void)
{
  801ee6:	55                   	push   %ebp
  801ee7:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  801ee9:	6a 00                	push   $0x0
  801eeb:	6a 00                	push   $0x0
  801eed:	6a 00                	push   $0x0
  801eef:	6a 00                	push   $0x0
  801ef1:	6a 00                	push   $0x0
  801ef3:	6a 01                	push   $0x1
  801ef5:	e8 98 ff ff ff       	call   801e92 <syscall>
  801efa:	83 c4 18             	add    $0x18,%esp
}
  801efd:	c9                   	leave  
  801efe:	c3                   	ret    

00801eff <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  801eff:	55                   	push   %ebp
  801f00:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  801f02:	8b 55 0c             	mov    0xc(%ebp),%edx
  801f05:	8b 45 08             	mov    0x8(%ebp),%eax
  801f08:	6a 00                	push   $0x0
  801f0a:	6a 00                	push   $0x0
  801f0c:	6a 00                	push   $0x0
  801f0e:	52                   	push   %edx
  801f0f:	50                   	push   %eax
  801f10:	6a 05                	push   $0x5
  801f12:	e8 7b ff ff ff       	call   801e92 <syscall>
  801f17:	83 c4 18             	add    $0x18,%esp
}
  801f1a:	c9                   	leave  
  801f1b:	c3                   	ret    

00801f1c <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  801f1c:	55                   	push   %ebp
  801f1d:	89 e5                	mov    %esp,%ebp
  801f1f:	56                   	push   %esi
  801f20:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  801f21:	8b 75 18             	mov    0x18(%ebp),%esi
  801f24:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801f27:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801f2a:	8b 55 0c             	mov    0xc(%ebp),%edx
  801f2d:	8b 45 08             	mov    0x8(%ebp),%eax
  801f30:	56                   	push   %esi
  801f31:	53                   	push   %ebx
  801f32:	51                   	push   %ecx
  801f33:	52                   	push   %edx
  801f34:	50                   	push   %eax
  801f35:	6a 06                	push   $0x6
  801f37:	e8 56 ff ff ff       	call   801e92 <syscall>
  801f3c:	83 c4 18             	add    $0x18,%esp
}
  801f3f:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801f42:	5b                   	pop    %ebx
  801f43:	5e                   	pop    %esi
  801f44:	5d                   	pop    %ebp
  801f45:	c3                   	ret    

00801f46 <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  801f46:	55                   	push   %ebp
  801f47:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  801f49:	8b 55 0c             	mov    0xc(%ebp),%edx
  801f4c:	8b 45 08             	mov    0x8(%ebp),%eax
  801f4f:	6a 00                	push   $0x0
  801f51:	6a 00                	push   $0x0
  801f53:	6a 00                	push   $0x0
  801f55:	52                   	push   %edx
  801f56:	50                   	push   %eax
  801f57:	6a 07                	push   $0x7
  801f59:	e8 34 ff ff ff       	call   801e92 <syscall>
  801f5e:	83 c4 18             	add    $0x18,%esp
}
  801f61:	c9                   	leave  
  801f62:	c3                   	ret    

00801f63 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  801f63:	55                   	push   %ebp
  801f64:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  801f66:	6a 00                	push   $0x0
  801f68:	6a 00                	push   $0x0
  801f6a:	6a 00                	push   $0x0
  801f6c:	ff 75 0c             	pushl  0xc(%ebp)
  801f6f:	ff 75 08             	pushl  0x8(%ebp)
  801f72:	6a 08                	push   $0x8
  801f74:	e8 19 ff ff ff       	call   801e92 <syscall>
  801f79:	83 c4 18             	add    $0x18,%esp
}
  801f7c:	c9                   	leave  
  801f7d:	c3                   	ret    

00801f7e <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  801f7e:	55                   	push   %ebp
  801f7f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  801f81:	6a 00                	push   $0x0
  801f83:	6a 00                	push   $0x0
  801f85:	6a 00                	push   $0x0
  801f87:	6a 00                	push   $0x0
  801f89:	6a 00                	push   $0x0
  801f8b:	6a 09                	push   $0x9
  801f8d:	e8 00 ff ff ff       	call   801e92 <syscall>
  801f92:	83 c4 18             	add    $0x18,%esp
}
  801f95:	c9                   	leave  
  801f96:	c3                   	ret    

00801f97 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  801f97:	55                   	push   %ebp
  801f98:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  801f9a:	6a 00                	push   $0x0
  801f9c:	6a 00                	push   $0x0
  801f9e:	6a 00                	push   $0x0
  801fa0:	6a 00                	push   $0x0
  801fa2:	6a 00                	push   $0x0
  801fa4:	6a 0a                	push   $0xa
  801fa6:	e8 e7 fe ff ff       	call   801e92 <syscall>
  801fab:	83 c4 18             	add    $0x18,%esp
}
  801fae:	c9                   	leave  
  801faf:	c3                   	ret    

00801fb0 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  801fb0:	55                   	push   %ebp
  801fb1:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  801fb3:	6a 00                	push   $0x0
  801fb5:	6a 00                	push   $0x0
  801fb7:	6a 00                	push   $0x0
  801fb9:	6a 00                	push   $0x0
  801fbb:	6a 00                	push   $0x0
  801fbd:	6a 0b                	push   $0xb
  801fbf:	e8 ce fe ff ff       	call   801e92 <syscall>
  801fc4:	83 c4 18             	add    $0x18,%esp
}
  801fc7:	c9                   	leave  
  801fc8:	c3                   	ret    

00801fc9 <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  801fc9:	55                   	push   %ebp
  801fca:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  801fcc:	6a 00                	push   $0x0
  801fce:	6a 00                	push   $0x0
  801fd0:	6a 00                	push   $0x0
  801fd2:	ff 75 0c             	pushl  0xc(%ebp)
  801fd5:	ff 75 08             	pushl  0x8(%ebp)
  801fd8:	6a 0f                	push   $0xf
  801fda:	e8 b3 fe ff ff       	call   801e92 <syscall>
  801fdf:	83 c4 18             	add    $0x18,%esp
	return;
  801fe2:	90                   	nop
}
  801fe3:	c9                   	leave  
  801fe4:	c3                   	ret    

00801fe5 <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  801fe5:	55                   	push   %ebp
  801fe6:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  801fe8:	6a 00                	push   $0x0
  801fea:	6a 00                	push   $0x0
  801fec:	6a 00                	push   $0x0
  801fee:	ff 75 0c             	pushl  0xc(%ebp)
  801ff1:	ff 75 08             	pushl  0x8(%ebp)
  801ff4:	6a 10                	push   $0x10
  801ff6:	e8 97 fe ff ff       	call   801e92 <syscall>
  801ffb:	83 c4 18             	add    $0x18,%esp
	return ;
  801ffe:	90                   	nop
}
  801fff:	c9                   	leave  
  802000:	c3                   	ret    

00802001 <sys_allocate_chunk>:

void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  802001:	55                   	push   %ebp
  802002:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  802004:	6a 00                	push   $0x0
  802006:	6a 00                	push   $0x0
  802008:	ff 75 10             	pushl  0x10(%ebp)
  80200b:	ff 75 0c             	pushl  0xc(%ebp)
  80200e:	ff 75 08             	pushl  0x8(%ebp)
  802011:	6a 11                	push   $0x11
  802013:	e8 7a fe ff ff       	call   801e92 <syscall>
  802018:	83 c4 18             	add    $0x18,%esp
	return ;
  80201b:	90                   	nop
}
  80201c:	c9                   	leave  
  80201d:	c3                   	ret    

0080201e <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  80201e:	55                   	push   %ebp
  80201f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  802021:	6a 00                	push   $0x0
  802023:	6a 00                	push   $0x0
  802025:	6a 00                	push   $0x0
  802027:	6a 00                	push   $0x0
  802029:	6a 00                	push   $0x0
  80202b:	6a 0c                	push   $0xc
  80202d:	e8 60 fe ff ff       	call   801e92 <syscall>
  802032:	83 c4 18             	add    $0x18,%esp
}
  802035:	c9                   	leave  
  802036:	c3                   	ret    

00802037 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  802037:	55                   	push   %ebp
  802038:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  80203a:	6a 00                	push   $0x0
  80203c:	6a 00                	push   $0x0
  80203e:	6a 00                	push   $0x0
  802040:	6a 00                	push   $0x0
  802042:	ff 75 08             	pushl  0x8(%ebp)
  802045:	6a 0d                	push   $0xd
  802047:	e8 46 fe ff ff       	call   801e92 <syscall>
  80204c:	83 c4 18             	add    $0x18,%esp
}
  80204f:	c9                   	leave  
  802050:	c3                   	ret    

00802051 <sys_scarce_memory>:

void sys_scarce_memory()
{
  802051:	55                   	push   %ebp
  802052:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  802054:	6a 00                	push   $0x0
  802056:	6a 00                	push   $0x0
  802058:	6a 00                	push   $0x0
  80205a:	6a 00                	push   $0x0
  80205c:	6a 00                	push   $0x0
  80205e:	6a 0e                	push   $0xe
  802060:	e8 2d fe ff ff       	call   801e92 <syscall>
  802065:	83 c4 18             	add    $0x18,%esp
}
  802068:	90                   	nop
  802069:	c9                   	leave  
  80206a:	c3                   	ret    

0080206b <sys_disable_interrupt>:

//NEW !! 2012...
void
sys_disable_interrupt()
{
  80206b:	55                   	push   %ebp
  80206c:	89 e5                	mov    %esp,%ebp
	syscall(SYS_disableINTR,0, 0, 0, 0, 0);
  80206e:	6a 00                	push   $0x0
  802070:	6a 00                	push   $0x0
  802072:	6a 00                	push   $0x0
  802074:	6a 00                	push   $0x0
  802076:	6a 00                	push   $0x0
  802078:	6a 13                	push   $0x13
  80207a:	e8 13 fe ff ff       	call   801e92 <syscall>
  80207f:	83 c4 18             	add    $0x18,%esp
}
  802082:	90                   	nop
  802083:	c9                   	leave  
  802084:	c3                   	ret    

00802085 <sys_enable_interrupt>:


void
sys_enable_interrupt()
{
  802085:	55                   	push   %ebp
  802086:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enableINTR,0, 0, 0, 0, 0);
  802088:	6a 00                	push   $0x0
  80208a:	6a 00                	push   $0x0
  80208c:	6a 00                	push   $0x0
  80208e:	6a 00                	push   $0x0
  802090:	6a 00                	push   $0x0
  802092:	6a 14                	push   $0x14
  802094:	e8 f9 fd ff ff       	call   801e92 <syscall>
  802099:	83 c4 18             	add    $0x18,%esp
}
  80209c:	90                   	nop
  80209d:	c9                   	leave  
  80209e:	c3                   	ret    

0080209f <sys_cputc>:


void
sys_cputc(const char c)
{
  80209f:	55                   	push   %ebp
  8020a0:	89 e5                	mov    %esp,%ebp
  8020a2:	83 ec 04             	sub    $0x4,%esp
  8020a5:	8b 45 08             	mov    0x8(%ebp),%eax
  8020a8:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  8020ab:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  8020af:	6a 00                	push   $0x0
  8020b1:	6a 00                	push   $0x0
  8020b3:	6a 00                	push   $0x0
  8020b5:	6a 00                	push   $0x0
  8020b7:	50                   	push   %eax
  8020b8:	6a 15                	push   $0x15
  8020ba:	e8 d3 fd ff ff       	call   801e92 <syscall>
  8020bf:	83 c4 18             	add    $0x18,%esp
}
  8020c2:	90                   	nop
  8020c3:	c9                   	leave  
  8020c4:	c3                   	ret    

008020c5 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  8020c5:	55                   	push   %ebp
  8020c6:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  8020c8:	6a 00                	push   $0x0
  8020ca:	6a 00                	push   $0x0
  8020cc:	6a 00                	push   $0x0
  8020ce:	6a 00                	push   $0x0
  8020d0:	6a 00                	push   $0x0
  8020d2:	6a 16                	push   $0x16
  8020d4:	e8 b9 fd ff ff       	call   801e92 <syscall>
  8020d9:	83 c4 18             	add    $0x18,%esp
}
  8020dc:	90                   	nop
  8020dd:	c9                   	leave  
  8020de:	c3                   	ret    

008020df <sys_createSemaphore>:

int
sys_createSemaphore(char* semaphoreName, uint32 initialValue)
{
  8020df:	55                   	push   %ebp
  8020e0:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_semaphore,(uint32)semaphoreName, (uint32)initialValue, 0, 0, 0);
  8020e2:	8b 45 08             	mov    0x8(%ebp),%eax
  8020e5:	6a 00                	push   $0x0
  8020e7:	6a 00                	push   $0x0
  8020e9:	6a 00                	push   $0x0
  8020eb:	ff 75 0c             	pushl  0xc(%ebp)
  8020ee:	50                   	push   %eax
  8020ef:	6a 17                	push   $0x17
  8020f1:	e8 9c fd ff ff       	call   801e92 <syscall>
  8020f6:	83 c4 18             	add    $0x18,%esp
}
  8020f9:	c9                   	leave  
  8020fa:	c3                   	ret    

008020fb <sys_getSemaphoreValue>:

int
sys_getSemaphoreValue(int32 ownerEnvID, char* semaphoreName)
{
  8020fb:	55                   	push   %ebp
  8020fc:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_semaphore_value,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  8020fe:	8b 55 0c             	mov    0xc(%ebp),%edx
  802101:	8b 45 08             	mov    0x8(%ebp),%eax
  802104:	6a 00                	push   $0x0
  802106:	6a 00                	push   $0x0
  802108:	6a 00                	push   $0x0
  80210a:	52                   	push   %edx
  80210b:	50                   	push   %eax
  80210c:	6a 1a                	push   $0x1a
  80210e:	e8 7f fd ff ff       	call   801e92 <syscall>
  802113:	83 c4 18             	add    $0x18,%esp
}
  802116:	c9                   	leave  
  802117:	c3                   	ret    

00802118 <sys_waitSemaphore>:

void
sys_waitSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  802118:	55                   	push   %ebp
  802119:	89 e5                	mov    %esp,%ebp
	syscall(SYS_wait_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  80211b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80211e:	8b 45 08             	mov    0x8(%ebp),%eax
  802121:	6a 00                	push   $0x0
  802123:	6a 00                	push   $0x0
  802125:	6a 00                	push   $0x0
  802127:	52                   	push   %edx
  802128:	50                   	push   %eax
  802129:	6a 18                	push   $0x18
  80212b:	e8 62 fd ff ff       	call   801e92 <syscall>
  802130:	83 c4 18             	add    $0x18,%esp
}
  802133:	90                   	nop
  802134:	c9                   	leave  
  802135:	c3                   	ret    

00802136 <sys_signalSemaphore>:

void
sys_signalSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  802136:	55                   	push   %ebp
  802137:	89 e5                	mov    %esp,%ebp
	syscall(SYS_signal_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  802139:	8b 55 0c             	mov    0xc(%ebp),%edx
  80213c:	8b 45 08             	mov    0x8(%ebp),%eax
  80213f:	6a 00                	push   $0x0
  802141:	6a 00                	push   $0x0
  802143:	6a 00                	push   $0x0
  802145:	52                   	push   %edx
  802146:	50                   	push   %eax
  802147:	6a 19                	push   $0x19
  802149:	e8 44 fd ff ff       	call   801e92 <syscall>
  80214e:	83 c4 18             	add    $0x18,%esp
}
  802151:	90                   	nop
  802152:	c9                   	leave  
  802153:	c3                   	ret    

00802154 <sys_createSharedObject>:

int
sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  802154:	55                   	push   %ebp
  802155:	89 e5                	mov    %esp,%ebp
  802157:	83 ec 04             	sub    $0x4,%esp
  80215a:	8b 45 10             	mov    0x10(%ebp),%eax
  80215d:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  802160:	8b 4d 14             	mov    0x14(%ebp),%ecx
  802163:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  802167:	8b 45 08             	mov    0x8(%ebp),%eax
  80216a:	6a 00                	push   $0x0
  80216c:	51                   	push   %ecx
  80216d:	52                   	push   %edx
  80216e:	ff 75 0c             	pushl  0xc(%ebp)
  802171:	50                   	push   %eax
  802172:	6a 1b                	push   $0x1b
  802174:	e8 19 fd ff ff       	call   801e92 <syscall>
  802179:	83 c4 18             	add    $0x18,%esp
}
  80217c:	c9                   	leave  
  80217d:	c3                   	ret    

0080217e <sys_getSizeOfSharedObject>:

//2017:
int
sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  80217e:	55                   	push   %ebp
  80217f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  802181:	8b 55 0c             	mov    0xc(%ebp),%edx
  802184:	8b 45 08             	mov    0x8(%ebp),%eax
  802187:	6a 00                	push   $0x0
  802189:	6a 00                	push   $0x0
  80218b:	6a 00                	push   $0x0
  80218d:	52                   	push   %edx
  80218e:	50                   	push   %eax
  80218f:	6a 1c                	push   $0x1c
  802191:	e8 fc fc ff ff       	call   801e92 <syscall>
  802196:	83 c4 18             	add    $0x18,%esp
}
  802199:	c9                   	leave  
  80219a:	c3                   	ret    

0080219b <sys_getSharedObject>:
//==========

int
sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  80219b:	55                   	push   %ebp
  80219c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  80219e:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8021a1:	8b 55 0c             	mov    0xc(%ebp),%edx
  8021a4:	8b 45 08             	mov    0x8(%ebp),%eax
  8021a7:	6a 00                	push   $0x0
  8021a9:	6a 00                	push   $0x0
  8021ab:	51                   	push   %ecx
  8021ac:	52                   	push   %edx
  8021ad:	50                   	push   %eax
  8021ae:	6a 1d                	push   $0x1d
  8021b0:	e8 dd fc ff ff       	call   801e92 <syscall>
  8021b5:	83 c4 18             	add    $0x18,%esp
}
  8021b8:	c9                   	leave  
  8021b9:	c3                   	ret    

008021ba <sys_freeSharedObject>:

int
sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  8021ba:	55                   	push   %ebp
  8021bb:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  8021bd:	8b 55 0c             	mov    0xc(%ebp),%edx
  8021c0:	8b 45 08             	mov    0x8(%ebp),%eax
  8021c3:	6a 00                	push   $0x0
  8021c5:	6a 00                	push   $0x0
  8021c7:	6a 00                	push   $0x0
  8021c9:	52                   	push   %edx
  8021ca:	50                   	push   %eax
  8021cb:	6a 1e                	push   $0x1e
  8021cd:	e8 c0 fc ff ff       	call   801e92 <syscall>
  8021d2:	83 c4 18             	add    $0x18,%esp
}
  8021d5:	c9                   	leave  
  8021d6:	c3                   	ret    

008021d7 <sys_getMaxShares>:

uint32 	sys_getMaxShares()
{
  8021d7:	55                   	push   %ebp
  8021d8:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_max_shares,0, 0, 0, 0, 0);
  8021da:	6a 00                	push   $0x0
  8021dc:	6a 00                	push   $0x0
  8021de:	6a 00                	push   $0x0
  8021e0:	6a 00                	push   $0x0
  8021e2:	6a 00                	push   $0x0
  8021e4:	6a 1f                	push   $0x1f
  8021e6:	e8 a7 fc ff ff       	call   801e92 <syscall>
  8021eb:	83 c4 18             	add    $0x18,%esp
}
  8021ee:	c9                   	leave  
  8021ef:	c3                   	ret    

008021f0 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  8021f0:	55                   	push   %ebp
  8021f1:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  8021f3:	8b 45 08             	mov    0x8(%ebp),%eax
  8021f6:	6a 00                	push   $0x0
  8021f8:	ff 75 14             	pushl  0x14(%ebp)
  8021fb:	ff 75 10             	pushl  0x10(%ebp)
  8021fe:	ff 75 0c             	pushl  0xc(%ebp)
  802201:	50                   	push   %eax
  802202:	6a 20                	push   $0x20
  802204:	e8 89 fc ff ff       	call   801e92 <syscall>
  802209:	83 c4 18             	add    $0x18,%esp
}
  80220c:	c9                   	leave  
  80220d:	c3                   	ret    

0080220e <sys_run_env>:

void
sys_run_env(int32 envId)
{
  80220e:	55                   	push   %ebp
  80220f:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  802211:	8b 45 08             	mov    0x8(%ebp),%eax
  802214:	6a 00                	push   $0x0
  802216:	6a 00                	push   $0x0
  802218:	6a 00                	push   $0x0
  80221a:	6a 00                	push   $0x0
  80221c:	50                   	push   %eax
  80221d:	6a 21                	push   $0x21
  80221f:	e8 6e fc ff ff       	call   801e92 <syscall>
  802224:	83 c4 18             	add    $0x18,%esp
}
  802227:	90                   	nop
  802228:	c9                   	leave  
  802229:	c3                   	ret    

0080222a <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  80222a:	55                   	push   %ebp
  80222b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  80222d:	8b 45 08             	mov    0x8(%ebp),%eax
  802230:	6a 00                	push   $0x0
  802232:	6a 00                	push   $0x0
  802234:	6a 00                	push   $0x0
  802236:	6a 00                	push   $0x0
  802238:	50                   	push   %eax
  802239:	6a 22                	push   $0x22
  80223b:	e8 52 fc ff ff       	call   801e92 <syscall>
  802240:	83 c4 18             	add    $0x18,%esp
}
  802243:	c9                   	leave  
  802244:	c3                   	ret    

00802245 <sys_getenvid>:

int32 sys_getenvid(void)
{
  802245:	55                   	push   %ebp
  802246:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  802248:	6a 00                	push   $0x0
  80224a:	6a 00                	push   $0x0
  80224c:	6a 00                	push   $0x0
  80224e:	6a 00                	push   $0x0
  802250:	6a 00                	push   $0x0
  802252:	6a 02                	push   $0x2
  802254:	e8 39 fc ff ff       	call   801e92 <syscall>
  802259:	83 c4 18             	add    $0x18,%esp
}
  80225c:	c9                   	leave  
  80225d:	c3                   	ret    

0080225e <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  80225e:	55                   	push   %ebp
  80225f:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  802261:	6a 00                	push   $0x0
  802263:	6a 00                	push   $0x0
  802265:	6a 00                	push   $0x0
  802267:	6a 00                	push   $0x0
  802269:	6a 00                	push   $0x0
  80226b:	6a 03                	push   $0x3
  80226d:	e8 20 fc ff ff       	call   801e92 <syscall>
  802272:	83 c4 18             	add    $0x18,%esp
}
  802275:	c9                   	leave  
  802276:	c3                   	ret    

00802277 <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  802277:	55                   	push   %ebp
  802278:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  80227a:	6a 00                	push   $0x0
  80227c:	6a 00                	push   $0x0
  80227e:	6a 00                	push   $0x0
  802280:	6a 00                	push   $0x0
  802282:	6a 00                	push   $0x0
  802284:	6a 04                	push   $0x4
  802286:	e8 07 fc ff ff       	call   801e92 <syscall>
  80228b:	83 c4 18             	add    $0x18,%esp
}
  80228e:	c9                   	leave  
  80228f:	c3                   	ret    

00802290 <sys_exit_env>:


void sys_exit_env(void)
{
  802290:	55                   	push   %ebp
  802291:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  802293:	6a 00                	push   $0x0
  802295:	6a 00                	push   $0x0
  802297:	6a 00                	push   $0x0
  802299:	6a 00                	push   $0x0
  80229b:	6a 00                	push   $0x0
  80229d:	6a 23                	push   $0x23
  80229f:	e8 ee fb ff ff       	call   801e92 <syscall>
  8022a4:	83 c4 18             	add    $0x18,%esp
}
  8022a7:	90                   	nop
  8022a8:	c9                   	leave  
  8022a9:	c3                   	ret    

008022aa <sys_get_virtual_time>:


struct uint64
sys_get_virtual_time()
{
  8022aa:	55                   	push   %ebp
  8022ab:	89 e5                	mov    %esp,%ebp
  8022ad:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  8022b0:	8d 45 f8             	lea    -0x8(%ebp),%eax
  8022b3:	8d 50 04             	lea    0x4(%eax),%edx
  8022b6:	8d 45 f8             	lea    -0x8(%ebp),%eax
  8022b9:	6a 00                	push   $0x0
  8022bb:	6a 00                	push   $0x0
  8022bd:	6a 00                	push   $0x0
  8022bf:	52                   	push   %edx
  8022c0:	50                   	push   %eax
  8022c1:	6a 24                	push   $0x24
  8022c3:	e8 ca fb ff ff       	call   801e92 <syscall>
  8022c8:	83 c4 18             	add    $0x18,%esp
	return result;
  8022cb:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8022ce:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8022d1:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8022d4:	89 01                	mov    %eax,(%ecx)
  8022d6:	89 51 04             	mov    %edx,0x4(%ecx)
}
  8022d9:	8b 45 08             	mov    0x8(%ebp),%eax
  8022dc:	c9                   	leave  
  8022dd:	c2 04 00             	ret    $0x4

008022e0 <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  8022e0:	55                   	push   %ebp
  8022e1:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  8022e3:	6a 00                	push   $0x0
  8022e5:	6a 00                	push   $0x0
  8022e7:	ff 75 10             	pushl  0x10(%ebp)
  8022ea:	ff 75 0c             	pushl  0xc(%ebp)
  8022ed:	ff 75 08             	pushl  0x8(%ebp)
  8022f0:	6a 12                	push   $0x12
  8022f2:	e8 9b fb ff ff       	call   801e92 <syscall>
  8022f7:	83 c4 18             	add    $0x18,%esp
	return ;
  8022fa:	90                   	nop
}
  8022fb:	c9                   	leave  
  8022fc:	c3                   	ret    

008022fd <sys_rcr2>:
uint32 sys_rcr2()
{
  8022fd:	55                   	push   %ebp
  8022fe:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  802300:	6a 00                	push   $0x0
  802302:	6a 00                	push   $0x0
  802304:	6a 00                	push   $0x0
  802306:	6a 00                	push   $0x0
  802308:	6a 00                	push   $0x0
  80230a:	6a 25                	push   $0x25
  80230c:	e8 81 fb ff ff       	call   801e92 <syscall>
  802311:	83 c4 18             	add    $0x18,%esp
}
  802314:	c9                   	leave  
  802315:	c3                   	ret    

00802316 <sys_bypassPageFault>:
void sys_bypassPageFault(uint8 instrLength)
{
  802316:	55                   	push   %ebp
  802317:	89 e5                	mov    %esp,%ebp
  802319:	83 ec 04             	sub    $0x4,%esp
  80231c:	8b 45 08             	mov    0x8(%ebp),%eax
  80231f:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  802322:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  802326:	6a 00                	push   $0x0
  802328:	6a 00                	push   $0x0
  80232a:	6a 00                	push   $0x0
  80232c:	6a 00                	push   $0x0
  80232e:	50                   	push   %eax
  80232f:	6a 26                	push   $0x26
  802331:	e8 5c fb ff ff       	call   801e92 <syscall>
  802336:	83 c4 18             	add    $0x18,%esp
	return ;
  802339:	90                   	nop
}
  80233a:	c9                   	leave  
  80233b:	c3                   	ret    

0080233c <rsttst>:
void rsttst()
{
  80233c:	55                   	push   %ebp
  80233d:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  80233f:	6a 00                	push   $0x0
  802341:	6a 00                	push   $0x0
  802343:	6a 00                	push   $0x0
  802345:	6a 00                	push   $0x0
  802347:	6a 00                	push   $0x0
  802349:	6a 28                	push   $0x28
  80234b:	e8 42 fb ff ff       	call   801e92 <syscall>
  802350:	83 c4 18             	add    $0x18,%esp
	return ;
  802353:	90                   	nop
}
  802354:	c9                   	leave  
  802355:	c3                   	ret    

00802356 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  802356:	55                   	push   %ebp
  802357:	89 e5                	mov    %esp,%ebp
  802359:	83 ec 04             	sub    $0x4,%esp
  80235c:	8b 45 14             	mov    0x14(%ebp),%eax
  80235f:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  802362:	8b 55 18             	mov    0x18(%ebp),%edx
  802365:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  802369:	52                   	push   %edx
  80236a:	50                   	push   %eax
  80236b:	ff 75 10             	pushl  0x10(%ebp)
  80236e:	ff 75 0c             	pushl  0xc(%ebp)
  802371:	ff 75 08             	pushl  0x8(%ebp)
  802374:	6a 27                	push   $0x27
  802376:	e8 17 fb ff ff       	call   801e92 <syscall>
  80237b:	83 c4 18             	add    $0x18,%esp
	return ;
  80237e:	90                   	nop
}
  80237f:	c9                   	leave  
  802380:	c3                   	ret    

00802381 <chktst>:
void chktst(uint32 n)
{
  802381:	55                   	push   %ebp
  802382:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  802384:	6a 00                	push   $0x0
  802386:	6a 00                	push   $0x0
  802388:	6a 00                	push   $0x0
  80238a:	6a 00                	push   $0x0
  80238c:	ff 75 08             	pushl  0x8(%ebp)
  80238f:	6a 29                	push   $0x29
  802391:	e8 fc fa ff ff       	call   801e92 <syscall>
  802396:	83 c4 18             	add    $0x18,%esp
	return ;
  802399:	90                   	nop
}
  80239a:	c9                   	leave  
  80239b:	c3                   	ret    

0080239c <inctst>:

void inctst()
{
  80239c:	55                   	push   %ebp
  80239d:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  80239f:	6a 00                	push   $0x0
  8023a1:	6a 00                	push   $0x0
  8023a3:	6a 00                	push   $0x0
  8023a5:	6a 00                	push   $0x0
  8023a7:	6a 00                	push   $0x0
  8023a9:	6a 2a                	push   $0x2a
  8023ab:	e8 e2 fa ff ff       	call   801e92 <syscall>
  8023b0:	83 c4 18             	add    $0x18,%esp
	return ;
  8023b3:	90                   	nop
}
  8023b4:	c9                   	leave  
  8023b5:	c3                   	ret    

008023b6 <gettst>:
uint32 gettst()
{
  8023b6:	55                   	push   %ebp
  8023b7:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  8023b9:	6a 00                	push   $0x0
  8023bb:	6a 00                	push   $0x0
  8023bd:	6a 00                	push   $0x0
  8023bf:	6a 00                	push   $0x0
  8023c1:	6a 00                	push   $0x0
  8023c3:	6a 2b                	push   $0x2b
  8023c5:	e8 c8 fa ff ff       	call   801e92 <syscall>
  8023ca:	83 c4 18             	add    $0x18,%esp
}
  8023cd:	c9                   	leave  
  8023ce:	c3                   	ret    

008023cf <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  8023cf:	55                   	push   %ebp
  8023d0:	89 e5                	mov    %esp,%ebp
  8023d2:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8023d5:	6a 00                	push   $0x0
  8023d7:	6a 00                	push   $0x0
  8023d9:	6a 00                	push   $0x0
  8023db:	6a 00                	push   $0x0
  8023dd:	6a 00                	push   $0x0
  8023df:	6a 2c                	push   $0x2c
  8023e1:	e8 ac fa ff ff       	call   801e92 <syscall>
  8023e6:	83 c4 18             	add    $0x18,%esp
  8023e9:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  8023ec:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  8023f0:	75 07                	jne    8023f9 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  8023f2:	b8 01 00 00 00       	mov    $0x1,%eax
  8023f7:	eb 05                	jmp    8023fe <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  8023f9:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8023fe:	c9                   	leave  
  8023ff:	c3                   	ret    

00802400 <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  802400:	55                   	push   %ebp
  802401:	89 e5                	mov    %esp,%ebp
  802403:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  802406:	6a 00                	push   $0x0
  802408:	6a 00                	push   $0x0
  80240a:	6a 00                	push   $0x0
  80240c:	6a 00                	push   $0x0
  80240e:	6a 00                	push   $0x0
  802410:	6a 2c                	push   $0x2c
  802412:	e8 7b fa ff ff       	call   801e92 <syscall>
  802417:	83 c4 18             	add    $0x18,%esp
  80241a:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  80241d:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  802421:	75 07                	jne    80242a <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  802423:	b8 01 00 00 00       	mov    $0x1,%eax
  802428:	eb 05                	jmp    80242f <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  80242a:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80242f:	c9                   	leave  
  802430:	c3                   	ret    

00802431 <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  802431:	55                   	push   %ebp
  802432:	89 e5                	mov    %esp,%ebp
  802434:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  802437:	6a 00                	push   $0x0
  802439:	6a 00                	push   $0x0
  80243b:	6a 00                	push   $0x0
  80243d:	6a 00                	push   $0x0
  80243f:	6a 00                	push   $0x0
  802441:	6a 2c                	push   $0x2c
  802443:	e8 4a fa ff ff       	call   801e92 <syscall>
  802448:	83 c4 18             	add    $0x18,%esp
  80244b:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  80244e:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  802452:	75 07                	jne    80245b <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  802454:	b8 01 00 00 00       	mov    $0x1,%eax
  802459:	eb 05                	jmp    802460 <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  80245b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802460:	c9                   	leave  
  802461:	c3                   	ret    

00802462 <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  802462:	55                   	push   %ebp
  802463:	89 e5                	mov    %esp,%ebp
  802465:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  802468:	6a 00                	push   $0x0
  80246a:	6a 00                	push   $0x0
  80246c:	6a 00                	push   $0x0
  80246e:	6a 00                	push   $0x0
  802470:	6a 00                	push   $0x0
  802472:	6a 2c                	push   $0x2c
  802474:	e8 19 fa ff ff       	call   801e92 <syscall>
  802479:	83 c4 18             	add    $0x18,%esp
  80247c:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  80247f:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  802483:	75 07                	jne    80248c <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  802485:	b8 01 00 00 00       	mov    $0x1,%eax
  80248a:	eb 05                	jmp    802491 <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  80248c:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802491:	c9                   	leave  
  802492:	c3                   	ret    

00802493 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  802493:	55                   	push   %ebp
  802494:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  802496:	6a 00                	push   $0x0
  802498:	6a 00                	push   $0x0
  80249a:	6a 00                	push   $0x0
  80249c:	6a 00                	push   $0x0
  80249e:	ff 75 08             	pushl  0x8(%ebp)
  8024a1:	6a 2d                	push   $0x2d
  8024a3:	e8 ea f9 ff ff       	call   801e92 <syscall>
  8024a8:	83 c4 18             	add    $0x18,%esp
	return ;
  8024ab:	90                   	nop
}
  8024ac:	c9                   	leave  
  8024ad:	c3                   	ret    

008024ae <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  8024ae:	55                   	push   %ebp
  8024af:	89 e5                	mov    %esp,%ebp
  8024b1:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  8024b2:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8024b5:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8024b8:	8b 55 0c             	mov    0xc(%ebp),%edx
  8024bb:	8b 45 08             	mov    0x8(%ebp),%eax
  8024be:	6a 00                	push   $0x0
  8024c0:	53                   	push   %ebx
  8024c1:	51                   	push   %ecx
  8024c2:	52                   	push   %edx
  8024c3:	50                   	push   %eax
  8024c4:	6a 2e                	push   $0x2e
  8024c6:	e8 c7 f9 ff ff       	call   801e92 <syscall>
  8024cb:	83 c4 18             	add    $0x18,%esp
}
  8024ce:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8024d1:	c9                   	leave  
  8024d2:	c3                   	ret    

008024d3 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  8024d3:	55                   	push   %ebp
  8024d4:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  8024d6:	8b 55 0c             	mov    0xc(%ebp),%edx
  8024d9:	8b 45 08             	mov    0x8(%ebp),%eax
  8024dc:	6a 00                	push   $0x0
  8024de:	6a 00                	push   $0x0
  8024e0:	6a 00                	push   $0x0
  8024e2:	52                   	push   %edx
  8024e3:	50                   	push   %eax
  8024e4:	6a 2f                	push   $0x2f
  8024e6:	e8 a7 f9 ff ff       	call   801e92 <syscall>
  8024eb:	83 c4 18             	add    $0x18,%esp
}
  8024ee:	c9                   	leave  
  8024ef:	c3                   	ret    

008024f0 <print_mem_block_lists>:
//===========================
// PRINT MEM BLOCK LISTS:
//===========================

void print_mem_block_lists()
{
  8024f0:	55                   	push   %ebp
  8024f1:	89 e5                	mov    %esp,%ebp
  8024f3:	83 ec 18             	sub    $0x18,%esp
	cprintf("\n=========================================\n");
  8024f6:	83 ec 0c             	sub    $0xc,%esp
  8024f9:	68 94 3f 80 00       	push   $0x803f94
  8024fe:	e8 d7 e4 ff ff       	call   8009da <cprintf>
  802503:	83 c4 10             	add    $0x10,%esp
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
  802506:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nFreeMemBlocksList:\n");
  80250d:	83 ec 0c             	sub    $0xc,%esp
  802510:	68 c0 3f 80 00       	push   $0x803fc0
  802515:	e8 c0 e4 ff ff       	call   8009da <cprintf>
  80251a:	83 c4 10             	add    $0x10,%esp
	uint8 sorted = 1 ;
  80251d:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &FreeMemBlocksList)
  802521:	a1 38 51 80 00       	mov    0x805138,%eax
  802526:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802529:	eb 56                	jmp    802581 <print_mem_block_lists+0x91>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  80252b:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80252f:	74 1c                	je     80254d <print_mem_block_lists+0x5d>
  802531:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802534:	8b 50 08             	mov    0x8(%eax),%edx
  802537:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80253a:	8b 48 08             	mov    0x8(%eax),%ecx
  80253d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802540:	8b 40 0c             	mov    0xc(%eax),%eax
  802543:	01 c8                	add    %ecx,%eax
  802545:	39 c2                	cmp    %eax,%edx
  802547:	73 04                	jae    80254d <print_mem_block_lists+0x5d>
			sorted = 0 ;
  802549:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  80254d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802550:	8b 50 08             	mov    0x8(%eax),%edx
  802553:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802556:	8b 40 0c             	mov    0xc(%eax),%eax
  802559:	01 c2                	add    %eax,%edx
  80255b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80255e:	8b 40 08             	mov    0x8(%eax),%eax
  802561:	83 ec 04             	sub    $0x4,%esp
  802564:	52                   	push   %edx
  802565:	50                   	push   %eax
  802566:	68 d5 3f 80 00       	push   $0x803fd5
  80256b:	e8 6a e4 ff ff       	call   8009da <cprintf>
  802570:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  802573:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802576:	89 45 f0             	mov    %eax,-0x10(%ebp)
	cprintf("\n=========================================\n");
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
	cprintf("\nFreeMemBlocksList:\n");
	uint8 sorted = 1 ;
	LIST_FOREACH(blk, &FreeMemBlocksList)
  802579:	a1 40 51 80 00       	mov    0x805140,%eax
  80257e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802581:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802585:	74 07                	je     80258e <print_mem_block_lists+0x9e>
  802587:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80258a:	8b 00                	mov    (%eax),%eax
  80258c:	eb 05                	jmp    802593 <print_mem_block_lists+0xa3>
  80258e:	b8 00 00 00 00       	mov    $0x0,%eax
  802593:	a3 40 51 80 00       	mov    %eax,0x805140
  802598:	a1 40 51 80 00       	mov    0x805140,%eax
  80259d:	85 c0                	test   %eax,%eax
  80259f:	75 8a                	jne    80252b <print_mem_block_lists+0x3b>
  8025a1:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8025a5:	75 84                	jne    80252b <print_mem_block_lists+0x3b>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;
  8025a7:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  8025ab:	75 10                	jne    8025bd <print_mem_block_lists+0xcd>
  8025ad:	83 ec 0c             	sub    $0xc,%esp
  8025b0:	68 e4 3f 80 00       	push   $0x803fe4
  8025b5:	e8 20 e4 ff ff       	call   8009da <cprintf>
  8025ba:	83 c4 10             	add    $0x10,%esp

	lastBlk = NULL ;
  8025bd:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nAllocMemBlocksList:\n");
  8025c4:	83 ec 0c             	sub    $0xc,%esp
  8025c7:	68 08 40 80 00       	push   $0x804008
  8025cc:	e8 09 e4 ff ff       	call   8009da <cprintf>
  8025d1:	83 c4 10             	add    $0x10,%esp
	sorted = 1 ;
  8025d4:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &AllocMemBlocksList)
  8025d8:	a1 40 50 80 00       	mov    0x805040,%eax
  8025dd:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8025e0:	eb 56                	jmp    802638 <print_mem_block_lists+0x148>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  8025e2:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8025e6:	74 1c                	je     802604 <print_mem_block_lists+0x114>
  8025e8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025eb:	8b 50 08             	mov    0x8(%eax),%edx
  8025ee:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8025f1:	8b 48 08             	mov    0x8(%eax),%ecx
  8025f4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8025f7:	8b 40 0c             	mov    0xc(%eax),%eax
  8025fa:	01 c8                	add    %ecx,%eax
  8025fc:	39 c2                	cmp    %eax,%edx
  8025fe:	73 04                	jae    802604 <print_mem_block_lists+0x114>
			sorted = 0 ;
  802600:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  802604:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802607:	8b 50 08             	mov    0x8(%eax),%edx
  80260a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80260d:	8b 40 0c             	mov    0xc(%eax),%eax
  802610:	01 c2                	add    %eax,%edx
  802612:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802615:	8b 40 08             	mov    0x8(%eax),%eax
  802618:	83 ec 04             	sub    $0x4,%esp
  80261b:	52                   	push   %edx
  80261c:	50                   	push   %eax
  80261d:	68 d5 3f 80 00       	push   $0x803fd5
  802622:	e8 b3 e3 ff ff       	call   8009da <cprintf>
  802627:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  80262a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80262d:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;

	lastBlk = NULL ;
	cprintf("\nAllocMemBlocksList:\n");
	sorted = 1 ;
	LIST_FOREACH(blk, &AllocMemBlocksList)
  802630:	a1 48 50 80 00       	mov    0x805048,%eax
  802635:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802638:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80263c:	74 07                	je     802645 <print_mem_block_lists+0x155>
  80263e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802641:	8b 00                	mov    (%eax),%eax
  802643:	eb 05                	jmp    80264a <print_mem_block_lists+0x15a>
  802645:	b8 00 00 00 00       	mov    $0x0,%eax
  80264a:	a3 48 50 80 00       	mov    %eax,0x805048
  80264f:	a1 48 50 80 00       	mov    0x805048,%eax
  802654:	85 c0                	test   %eax,%eax
  802656:	75 8a                	jne    8025e2 <print_mem_block_lists+0xf2>
  802658:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80265c:	75 84                	jne    8025e2 <print_mem_block_lists+0xf2>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nAllocMemBlocksList is NOT SORTED!!\n") ;
  80265e:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  802662:	75 10                	jne    802674 <print_mem_block_lists+0x184>
  802664:	83 ec 0c             	sub    $0xc,%esp
  802667:	68 20 40 80 00       	push   $0x804020
  80266c:	e8 69 e3 ff ff       	call   8009da <cprintf>
  802671:	83 c4 10             	add    $0x10,%esp
	cprintf("\n=========================================\n");
  802674:	83 ec 0c             	sub    $0xc,%esp
  802677:	68 94 3f 80 00       	push   $0x803f94
  80267c:	e8 59 e3 ff ff       	call   8009da <cprintf>
  802681:	83 c4 10             	add    $0x10,%esp

}
  802684:	90                   	nop
  802685:	c9                   	leave  
  802686:	c3                   	ret    

00802687 <initialize_MemBlocksList>:

//===============================
// [1] INITIALIZE AVAILABLE LIST:
//===============================
void initialize_MemBlocksList(uint32 numOfBlocks)
{
  802687:	55                   	push   %ebp
  802688:	89 e5                	mov    %esp,%ebp
  80268a:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] initialize_MemBlocksList
	// Write your code here, remove the panic and write your code
	//panic("initialize_MemBlocksList() is not implemented yet...!!");
	uint32 n = numOfBlocks;
  80268d:	8b 45 08             	mov    0x8(%ebp),%eax
  802690:	89 45 f0             	mov    %eax,-0x10(%ebp)

	LIST_INIT(&AvailableMemBlocksList);
  802693:	c7 05 48 51 80 00 00 	movl   $0x0,0x805148
  80269a:	00 00 00 
  80269d:	c7 05 4c 51 80 00 00 	movl   $0x0,0x80514c
  8026a4:	00 00 00 
  8026a7:	c7 05 54 51 80 00 00 	movl   $0x0,0x805154
  8026ae:	00 00 00 
	for(int i = 0; i<n;i++)
  8026b1:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  8026b8:	e9 9e 00 00 00       	jmp    80275b <initialize_MemBlocksList+0xd4>
	{
		LIST_INSERT_HEAD(&AvailableMemBlocksList, &(MemBlockNodes[i]));
  8026bd:	a1 50 50 80 00       	mov    0x805050,%eax
  8026c2:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8026c5:	c1 e2 04             	shl    $0x4,%edx
  8026c8:	01 d0                	add    %edx,%eax
  8026ca:	85 c0                	test   %eax,%eax
  8026cc:	75 14                	jne    8026e2 <initialize_MemBlocksList+0x5b>
  8026ce:	83 ec 04             	sub    $0x4,%esp
  8026d1:	68 48 40 80 00       	push   $0x804048
  8026d6:	6a 47                	push   $0x47
  8026d8:	68 6b 40 80 00       	push   $0x80406b
  8026dd:	e8 44 e0 ff ff       	call   800726 <_panic>
  8026e2:	a1 50 50 80 00       	mov    0x805050,%eax
  8026e7:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8026ea:	c1 e2 04             	shl    $0x4,%edx
  8026ed:	01 d0                	add    %edx,%eax
  8026ef:	8b 15 48 51 80 00    	mov    0x805148,%edx
  8026f5:	89 10                	mov    %edx,(%eax)
  8026f7:	8b 00                	mov    (%eax),%eax
  8026f9:	85 c0                	test   %eax,%eax
  8026fb:	74 18                	je     802715 <initialize_MemBlocksList+0x8e>
  8026fd:	a1 48 51 80 00       	mov    0x805148,%eax
  802702:	8b 15 50 50 80 00    	mov    0x805050,%edx
  802708:	8b 4d f4             	mov    -0xc(%ebp),%ecx
  80270b:	c1 e1 04             	shl    $0x4,%ecx
  80270e:	01 ca                	add    %ecx,%edx
  802710:	89 50 04             	mov    %edx,0x4(%eax)
  802713:	eb 12                	jmp    802727 <initialize_MemBlocksList+0xa0>
  802715:	a1 50 50 80 00       	mov    0x805050,%eax
  80271a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80271d:	c1 e2 04             	shl    $0x4,%edx
  802720:	01 d0                	add    %edx,%eax
  802722:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802727:	a1 50 50 80 00       	mov    0x805050,%eax
  80272c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80272f:	c1 e2 04             	shl    $0x4,%edx
  802732:	01 d0                	add    %edx,%eax
  802734:	a3 48 51 80 00       	mov    %eax,0x805148
  802739:	a1 50 50 80 00       	mov    0x805050,%eax
  80273e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802741:	c1 e2 04             	shl    $0x4,%edx
  802744:	01 d0                	add    %edx,%eax
  802746:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80274d:	a1 54 51 80 00       	mov    0x805154,%eax
  802752:	40                   	inc    %eax
  802753:	a3 54 51 80 00       	mov    %eax,0x805154
	// Write your code here, remove the panic and write your code
	//panic("initialize_MemBlocksList() is not implemented yet...!!");
	uint32 n = numOfBlocks;

	LIST_INIT(&AvailableMemBlocksList);
	for(int i = 0; i<n;i++)
  802758:	ff 45 f4             	incl   -0xc(%ebp)
  80275b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80275e:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  802761:	0f 82 56 ff ff ff    	jb     8026bd <initialize_MemBlocksList+0x36>
	{
		LIST_INSERT_HEAD(&AvailableMemBlocksList, &(MemBlockNodes[i]));
	}
}
  802767:	90                   	nop
  802768:	c9                   	leave  
  802769:	c3                   	ret    

0080276a <find_block>:

//===============================
// [2] FIND BLOCK:
//===============================
struct MemBlock *find_block(struct MemBlock_List *blockList, uint32 va)
{
  80276a:	55                   	push   %ebp
  80276b:	89 e5                	mov    %esp,%ebp
  80276d:	83 ec 10             	sub    $0x10,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] find_block
	// Write your code here, remove the panic and write your code
	//panic("find_block() is not implemented yet...!!");
	uint32 virAddress = va;
  802770:	8b 45 0c             	mov    0xc(%ebp),%eax
  802773:	89 45 f4             	mov    %eax,-0xc(%ebp)
	struct MemBlock* blk;
	int found = 0;
  802776:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	LIST_FOREACH(blk, &(AllocMemBlocksList))
  80277d:	a1 40 50 80 00       	mov    0x805040,%eax
  802782:	89 45 fc             	mov    %eax,-0x4(%ebp)
  802785:	eb 23                	jmp    8027aa <find_block+0x40>
	{
		if(blk->sva == virAddress)
  802787:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80278a:	8b 40 08             	mov    0x8(%eax),%eax
  80278d:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  802790:	75 09                	jne    80279b <find_block+0x31>
		{
			found = 1;
  802792:	c7 45 f8 01 00 00 00 	movl   $0x1,-0x8(%ebp)
			break;
  802799:	eb 35                	jmp    8027d0 <find_block+0x66>
		}
		else
		{
			found = 0;
  80279b:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	//panic("find_block() is not implemented yet...!!");
	uint32 virAddress = va;
	struct MemBlock* blk;
	int found = 0;

	LIST_FOREACH(blk, &(AllocMemBlocksList))
  8027a2:	a1 48 50 80 00       	mov    0x805048,%eax
  8027a7:	89 45 fc             	mov    %eax,-0x4(%ebp)
  8027aa:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8027ae:	74 07                	je     8027b7 <find_block+0x4d>
  8027b0:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8027b3:	8b 00                	mov    (%eax),%eax
  8027b5:	eb 05                	jmp    8027bc <find_block+0x52>
  8027b7:	b8 00 00 00 00       	mov    $0x0,%eax
  8027bc:	a3 48 50 80 00       	mov    %eax,0x805048
  8027c1:	a1 48 50 80 00       	mov    0x805048,%eax
  8027c6:	85 c0                	test   %eax,%eax
  8027c8:	75 bd                	jne    802787 <find_block+0x1d>
  8027ca:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8027ce:	75 b7                	jne    802787 <find_block+0x1d>
		{
			found = 0;
			continue;
		}
	}
	if(found == 1)
  8027d0:	83 7d f8 01          	cmpl   $0x1,-0x8(%ebp)
  8027d4:	75 05                	jne    8027db <find_block+0x71>
	{
		return blk;
  8027d6:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8027d9:	eb 05                	jmp    8027e0 <find_block+0x76>
	}
	else
	{
		return NULL;
  8027db:	b8 00 00 00 00       	mov    $0x0,%eax
	}
}
  8027e0:	c9                   	leave  
  8027e1:	c3                   	ret    

008027e2 <insert_sorted_allocList>:

//=========================================
// [3] INSERT BLOCK IN ALLOC LIST [SORTED]:
//=========================================
void insert_sorted_allocList(struct MemBlock *blockToInsert)
{
  8027e2:	55                   	push   %ebp
  8027e3:	89 e5                	mov    %esp,%ebp
  8027e5:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] insert_sorted_allocList
	// Write your code here, remove the panic and write your code
	//panic("insert_sorted_allocList() is not implemented yet...!!");
	struct MemBlock* blk;
	struct MemBlock* newblk = blockToInsert;
  8027e8:	8b 45 08             	mov    0x8(%ebp),%eax
  8027eb:	89 45 f0             	mov    %eax,-0x10(%ebp)

	if((LIST_EMPTY(&AllocMemBlocksList)) || (newblk->sva < LIST_FIRST(&AllocMemBlocksList)->sva))
  8027ee:	a1 40 50 80 00       	mov    0x805040,%eax
  8027f3:	85 c0                	test   %eax,%eax
  8027f5:	74 12                	je     802809 <insert_sorted_allocList+0x27>
  8027f7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8027fa:	8b 50 08             	mov    0x8(%eax),%edx
  8027fd:	a1 40 50 80 00       	mov    0x805040,%eax
  802802:	8b 40 08             	mov    0x8(%eax),%eax
  802805:	39 c2                	cmp    %eax,%edx
  802807:	73 65                	jae    80286e <insert_sorted_allocList+0x8c>
	{
		LIST_INSERT_HEAD(&(AllocMemBlocksList), newblk);
  802809:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80280d:	75 14                	jne    802823 <insert_sorted_allocList+0x41>
  80280f:	83 ec 04             	sub    $0x4,%esp
  802812:	68 48 40 80 00       	push   $0x804048
  802817:	6a 7b                	push   $0x7b
  802819:	68 6b 40 80 00       	push   $0x80406b
  80281e:	e8 03 df ff ff       	call   800726 <_panic>
  802823:	8b 15 40 50 80 00    	mov    0x805040,%edx
  802829:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80282c:	89 10                	mov    %edx,(%eax)
  80282e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802831:	8b 00                	mov    (%eax),%eax
  802833:	85 c0                	test   %eax,%eax
  802835:	74 0d                	je     802844 <insert_sorted_allocList+0x62>
  802837:	a1 40 50 80 00       	mov    0x805040,%eax
  80283c:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80283f:	89 50 04             	mov    %edx,0x4(%eax)
  802842:	eb 08                	jmp    80284c <insert_sorted_allocList+0x6a>
  802844:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802847:	a3 44 50 80 00       	mov    %eax,0x805044
  80284c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80284f:	a3 40 50 80 00       	mov    %eax,0x805040
  802854:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802857:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80285e:	a1 4c 50 80 00       	mov    0x80504c,%eax
  802863:	40                   	inc    %eax
  802864:	a3 4c 50 80 00       	mov    %eax,0x80504c
  802869:	e9 5f 01 00 00       	jmp    8029cd <insert_sorted_allocList+0x1eb>
	}
	else if(newblk->sva > LIST_LAST(&AllocMemBlocksList)->sva)
  80286e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802871:	8b 50 08             	mov    0x8(%eax),%edx
  802874:	a1 44 50 80 00       	mov    0x805044,%eax
  802879:	8b 40 08             	mov    0x8(%eax),%eax
  80287c:	39 c2                	cmp    %eax,%edx
  80287e:	76 65                	jbe    8028e5 <insert_sorted_allocList+0x103>
	{
		LIST_INSERT_TAIL(&AllocMemBlocksList, newblk);
  802880:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802884:	75 14                	jne    80289a <insert_sorted_allocList+0xb8>
  802886:	83 ec 04             	sub    $0x4,%esp
  802889:	68 84 40 80 00       	push   $0x804084
  80288e:	6a 7f                	push   $0x7f
  802890:	68 6b 40 80 00       	push   $0x80406b
  802895:	e8 8c de ff ff       	call   800726 <_panic>
  80289a:	8b 15 44 50 80 00    	mov    0x805044,%edx
  8028a0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8028a3:	89 50 04             	mov    %edx,0x4(%eax)
  8028a6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8028a9:	8b 40 04             	mov    0x4(%eax),%eax
  8028ac:	85 c0                	test   %eax,%eax
  8028ae:	74 0c                	je     8028bc <insert_sorted_allocList+0xda>
  8028b0:	a1 44 50 80 00       	mov    0x805044,%eax
  8028b5:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8028b8:	89 10                	mov    %edx,(%eax)
  8028ba:	eb 08                	jmp    8028c4 <insert_sorted_allocList+0xe2>
  8028bc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8028bf:	a3 40 50 80 00       	mov    %eax,0x805040
  8028c4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8028c7:	a3 44 50 80 00       	mov    %eax,0x805044
  8028cc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8028cf:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8028d5:	a1 4c 50 80 00       	mov    0x80504c,%eax
  8028da:	40                   	inc    %eax
  8028db:	a3 4c 50 80 00       	mov    %eax,0x80504c
				LIST_INSERT_AFTER(&AllocMemBlocksList, blk, newblk);
				break;
			}
		}
	}
}
  8028e0:	e9 e8 00 00 00       	jmp    8029cd <insert_sorted_allocList+0x1eb>
	{
		LIST_INSERT_TAIL(&AllocMemBlocksList, newblk);
	}
	else
	{
		LIST_FOREACH(blk, &AllocMemBlocksList)
  8028e5:	a1 40 50 80 00       	mov    0x805040,%eax
  8028ea:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8028ed:	e9 ab 00 00 00       	jmp    80299d <insert_sorted_allocList+0x1bb>
		{
			if(blk->prev_next_info.le_next != NULL && newblk->sva > blk->sva  && newblk->sva < blk->prev_next_info.le_next->sva)
  8028f2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028f5:	8b 00                	mov    (%eax),%eax
  8028f7:	85 c0                	test   %eax,%eax
  8028f9:	0f 84 96 00 00 00    	je     802995 <insert_sorted_allocList+0x1b3>
  8028ff:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802902:	8b 50 08             	mov    0x8(%eax),%edx
  802905:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802908:	8b 40 08             	mov    0x8(%eax),%eax
  80290b:	39 c2                	cmp    %eax,%edx
  80290d:	0f 86 82 00 00 00    	jbe    802995 <insert_sorted_allocList+0x1b3>
  802913:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802916:	8b 50 08             	mov    0x8(%eax),%edx
  802919:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80291c:	8b 00                	mov    (%eax),%eax
  80291e:	8b 40 08             	mov    0x8(%eax),%eax
  802921:	39 c2                	cmp    %eax,%edx
  802923:	73 70                	jae    802995 <insert_sorted_allocList+0x1b3>
			{
				LIST_INSERT_AFTER(&AllocMemBlocksList, blk, newblk);
  802925:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802929:	74 06                	je     802931 <insert_sorted_allocList+0x14f>
  80292b:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80292f:	75 17                	jne    802948 <insert_sorted_allocList+0x166>
  802931:	83 ec 04             	sub    $0x4,%esp
  802934:	68 a8 40 80 00       	push   $0x8040a8
  802939:	68 87 00 00 00       	push   $0x87
  80293e:	68 6b 40 80 00       	push   $0x80406b
  802943:	e8 de dd ff ff       	call   800726 <_panic>
  802948:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80294b:	8b 10                	mov    (%eax),%edx
  80294d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802950:	89 10                	mov    %edx,(%eax)
  802952:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802955:	8b 00                	mov    (%eax),%eax
  802957:	85 c0                	test   %eax,%eax
  802959:	74 0b                	je     802966 <insert_sorted_allocList+0x184>
  80295b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80295e:	8b 00                	mov    (%eax),%eax
  802960:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802963:	89 50 04             	mov    %edx,0x4(%eax)
  802966:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802969:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80296c:	89 10                	mov    %edx,(%eax)
  80296e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802971:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802974:	89 50 04             	mov    %edx,0x4(%eax)
  802977:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80297a:	8b 00                	mov    (%eax),%eax
  80297c:	85 c0                	test   %eax,%eax
  80297e:	75 08                	jne    802988 <insert_sorted_allocList+0x1a6>
  802980:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802983:	a3 44 50 80 00       	mov    %eax,0x805044
  802988:	a1 4c 50 80 00       	mov    0x80504c,%eax
  80298d:	40                   	inc    %eax
  80298e:	a3 4c 50 80 00       	mov    %eax,0x80504c
				break;
  802993:	eb 38                	jmp    8029cd <insert_sorted_allocList+0x1eb>
	{
		LIST_INSERT_TAIL(&AllocMemBlocksList, newblk);
	}
	else
	{
		LIST_FOREACH(blk, &AllocMemBlocksList)
  802995:	a1 48 50 80 00       	mov    0x805048,%eax
  80299a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80299d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8029a1:	74 07                	je     8029aa <insert_sorted_allocList+0x1c8>
  8029a3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029a6:	8b 00                	mov    (%eax),%eax
  8029a8:	eb 05                	jmp    8029af <insert_sorted_allocList+0x1cd>
  8029aa:	b8 00 00 00 00       	mov    $0x0,%eax
  8029af:	a3 48 50 80 00       	mov    %eax,0x805048
  8029b4:	a1 48 50 80 00       	mov    0x805048,%eax
  8029b9:	85 c0                	test   %eax,%eax
  8029bb:	0f 85 31 ff ff ff    	jne    8028f2 <insert_sorted_allocList+0x110>
  8029c1:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8029c5:	0f 85 27 ff ff ff    	jne    8028f2 <insert_sorted_allocList+0x110>
				LIST_INSERT_AFTER(&AllocMemBlocksList, blk, newblk);
				break;
			}
		}
	}
}
  8029cb:	eb 00                	jmp    8029cd <insert_sorted_allocList+0x1eb>
  8029cd:	90                   	nop
  8029ce:	c9                   	leave  
  8029cf:	c3                   	ret    

008029d0 <alloc_block_FF>:

//=========================================
// [4] ALLOCATE BLOCK BY FIRST FIT:
//=========================================
struct MemBlock *alloc_block_FF(uint32 size)
{
  8029d0:	55                   	push   %ebp
  8029d1:	89 e5                	mov    %esp,%ebp
  8029d3:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_FF
	// Write your code here, remove the panic and write your code
	//panic("alloc_block_FF() is not implemented yet...!!");
	uint32 versize = size;
  8029d6:	8b 45 08             	mov    0x8(%ebp),%eax
  8029d9:	89 45 f0             	mov    %eax,-0x10(%ebp)
	struct MemBlock* blk;
	struct MemBlock* newblk = LIST_FIRST(&AvailableMemBlocksList);
  8029dc:	a1 48 51 80 00       	mov    0x805148,%eax
  8029e1:	89 45 ec             	mov    %eax,-0x14(%ebp)

	LIST_FOREACH(blk,&FreeMemBlocksList)
  8029e4:	a1 38 51 80 00       	mov    0x805138,%eax
  8029e9:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8029ec:	e9 77 01 00 00       	jmp    802b68 <alloc_block_FF+0x198>
	{
		if(blk->size == versize)
  8029f1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029f4:	8b 40 0c             	mov    0xc(%eax),%eax
  8029f7:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8029fa:	0f 85 8a 00 00 00    	jne    802a8a <alloc_block_FF+0xba>
		{
			LIST_REMOVE(&FreeMemBlocksList,blk);
  802a00:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802a04:	75 17                	jne    802a1d <alloc_block_FF+0x4d>
  802a06:	83 ec 04             	sub    $0x4,%esp
  802a09:	68 dc 40 80 00       	push   $0x8040dc
  802a0e:	68 9e 00 00 00       	push   $0x9e
  802a13:	68 6b 40 80 00       	push   $0x80406b
  802a18:	e8 09 dd ff ff       	call   800726 <_panic>
  802a1d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a20:	8b 00                	mov    (%eax),%eax
  802a22:	85 c0                	test   %eax,%eax
  802a24:	74 10                	je     802a36 <alloc_block_FF+0x66>
  802a26:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a29:	8b 00                	mov    (%eax),%eax
  802a2b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802a2e:	8b 52 04             	mov    0x4(%edx),%edx
  802a31:	89 50 04             	mov    %edx,0x4(%eax)
  802a34:	eb 0b                	jmp    802a41 <alloc_block_FF+0x71>
  802a36:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a39:	8b 40 04             	mov    0x4(%eax),%eax
  802a3c:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802a41:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a44:	8b 40 04             	mov    0x4(%eax),%eax
  802a47:	85 c0                	test   %eax,%eax
  802a49:	74 0f                	je     802a5a <alloc_block_FF+0x8a>
  802a4b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a4e:	8b 40 04             	mov    0x4(%eax),%eax
  802a51:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802a54:	8b 12                	mov    (%edx),%edx
  802a56:	89 10                	mov    %edx,(%eax)
  802a58:	eb 0a                	jmp    802a64 <alloc_block_FF+0x94>
  802a5a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a5d:	8b 00                	mov    (%eax),%eax
  802a5f:	a3 38 51 80 00       	mov    %eax,0x805138
  802a64:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a67:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802a6d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a70:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802a77:	a1 44 51 80 00       	mov    0x805144,%eax
  802a7c:	48                   	dec    %eax
  802a7d:	a3 44 51 80 00       	mov    %eax,0x805144
			return blk;
  802a82:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a85:	e9 11 01 00 00       	jmp    802b9b <alloc_block_FF+0x1cb>
		}
		else if(blk->size > versize)
  802a8a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a8d:	8b 40 0c             	mov    0xc(%eax),%eax
  802a90:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  802a93:	0f 86 c7 00 00 00    	jbe    802b60 <alloc_block_FF+0x190>
		{
			LIST_REMOVE(&AvailableMemBlocksList,newblk);
  802a99:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802a9d:	75 17                	jne    802ab6 <alloc_block_FF+0xe6>
  802a9f:	83 ec 04             	sub    $0x4,%esp
  802aa2:	68 dc 40 80 00       	push   $0x8040dc
  802aa7:	68 a3 00 00 00       	push   $0xa3
  802aac:	68 6b 40 80 00       	push   $0x80406b
  802ab1:	e8 70 dc ff ff       	call   800726 <_panic>
  802ab6:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802ab9:	8b 00                	mov    (%eax),%eax
  802abb:	85 c0                	test   %eax,%eax
  802abd:	74 10                	je     802acf <alloc_block_FF+0xff>
  802abf:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802ac2:	8b 00                	mov    (%eax),%eax
  802ac4:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802ac7:	8b 52 04             	mov    0x4(%edx),%edx
  802aca:	89 50 04             	mov    %edx,0x4(%eax)
  802acd:	eb 0b                	jmp    802ada <alloc_block_FF+0x10a>
  802acf:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802ad2:	8b 40 04             	mov    0x4(%eax),%eax
  802ad5:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802ada:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802add:	8b 40 04             	mov    0x4(%eax),%eax
  802ae0:	85 c0                	test   %eax,%eax
  802ae2:	74 0f                	je     802af3 <alloc_block_FF+0x123>
  802ae4:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802ae7:	8b 40 04             	mov    0x4(%eax),%eax
  802aea:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802aed:	8b 12                	mov    (%edx),%edx
  802aef:	89 10                	mov    %edx,(%eax)
  802af1:	eb 0a                	jmp    802afd <alloc_block_FF+0x12d>
  802af3:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802af6:	8b 00                	mov    (%eax),%eax
  802af8:	a3 48 51 80 00       	mov    %eax,0x805148
  802afd:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802b00:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802b06:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802b09:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802b10:	a1 54 51 80 00       	mov    0x805154,%eax
  802b15:	48                   	dec    %eax
  802b16:	a3 54 51 80 00       	mov    %eax,0x805154
			newblk->size = versize;
  802b1b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802b1e:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802b21:	89 50 0c             	mov    %edx,0xc(%eax)
			blk->size = blk->size-versize;
  802b24:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b27:	8b 40 0c             	mov    0xc(%eax),%eax
  802b2a:	2b 45 f0             	sub    -0x10(%ebp),%eax
  802b2d:	89 c2                	mov    %eax,%edx
  802b2f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b32:	89 50 0c             	mov    %edx,0xc(%eax)
			uint32 newveradd = blk->sva;
  802b35:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b38:	8b 40 08             	mov    0x8(%eax),%eax
  802b3b:	89 45 e8             	mov    %eax,-0x18(%ebp)
			blk->sva+=newblk->size;
  802b3e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b41:	8b 50 08             	mov    0x8(%eax),%edx
  802b44:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802b47:	8b 40 0c             	mov    0xc(%eax),%eax
  802b4a:	01 c2                	add    %eax,%edx
  802b4c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b4f:	89 50 08             	mov    %edx,0x8(%eax)
			newblk->sva = newveradd;
  802b52:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802b55:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802b58:	89 50 08             	mov    %edx,0x8(%eax)
			return newblk;
  802b5b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802b5e:	eb 3b                	jmp    802b9b <alloc_block_FF+0x1cb>
	//panic("alloc_block_FF() is not implemented yet...!!");
	uint32 versize = size;
	struct MemBlock* blk;
	struct MemBlock* newblk = LIST_FIRST(&AvailableMemBlocksList);

	LIST_FOREACH(blk,&FreeMemBlocksList)
  802b60:	a1 40 51 80 00       	mov    0x805140,%eax
  802b65:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802b68:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802b6c:	74 07                	je     802b75 <alloc_block_FF+0x1a5>
  802b6e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b71:	8b 00                	mov    (%eax),%eax
  802b73:	eb 05                	jmp    802b7a <alloc_block_FF+0x1aa>
  802b75:	b8 00 00 00 00       	mov    $0x0,%eax
  802b7a:	a3 40 51 80 00       	mov    %eax,0x805140
  802b7f:	a1 40 51 80 00       	mov    0x805140,%eax
  802b84:	85 c0                	test   %eax,%eax
  802b86:	0f 85 65 fe ff ff    	jne    8029f1 <alloc_block_FF+0x21>
  802b8c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802b90:	0f 85 5b fe ff ff    	jne    8029f1 <alloc_block_FF+0x21>
			blk->sva+=newblk->size;
			newblk->sva = newveradd;
			return newblk;
		}
	}
	return NULL;
  802b96:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802b9b:	c9                   	leave  
  802b9c:	c3                   	ret    

00802b9d <alloc_block_BF>:

//=========================================
// [5] ALLOCATE BLOCK BY BEST FIT:
//=========================================
struct MemBlock *alloc_block_BF(uint32 size)
{
  802b9d:	55                   	push   %ebp
  802b9e:	89 e5                	mov    %esp,%ebp
  802ba0:	83 ec 28             	sub    $0x28,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_BF
	// Write your code here, remove the panic and write your code
	//panic("alloc_block_BF() is not implemented yet...!!");
	uint32 versize=size;
  802ba3:	8b 45 08             	mov    0x8(%ebp),%eax
  802ba6:	89 45 e8             	mov    %eax,-0x18(%ebp)
	struct MemBlock* blk;
	struct MemBlock* newblk=LIST_FIRST(&AvailableMemBlocksList);
  802ba9:	a1 48 51 80 00       	mov    0x805148,%eax
  802bae:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	uint32 newveradd;
	uint32 newsize;
	int size_free = LIST_SIZE(&FreeMemBlocksList);
  802bb1:	a1 44 51 80 00       	mov    0x805144,%eax
  802bb6:	89 45 e0             	mov    %eax,-0x20(%ebp)

	LIST_FOREACH(blk, &FreeMemBlocksList)
  802bb9:	a1 38 51 80 00       	mov    0x805138,%eax
  802bbe:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802bc1:	e9 a1 00 00 00       	jmp    802c67 <alloc_block_BF+0xca>
	{
		if(blk->size == versize)
  802bc6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bc9:	8b 40 0c             	mov    0xc(%eax),%eax
  802bcc:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  802bcf:	0f 85 8a 00 00 00    	jne    802c5f <alloc_block_BF+0xc2>
		{
			LIST_REMOVE(&FreeMemBlocksList, blk);
  802bd5:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802bd9:	75 17                	jne    802bf2 <alloc_block_BF+0x55>
  802bdb:	83 ec 04             	sub    $0x4,%esp
  802bde:	68 dc 40 80 00       	push   $0x8040dc
  802be3:	68 c2 00 00 00       	push   $0xc2
  802be8:	68 6b 40 80 00       	push   $0x80406b
  802bed:	e8 34 db ff ff       	call   800726 <_panic>
  802bf2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bf5:	8b 00                	mov    (%eax),%eax
  802bf7:	85 c0                	test   %eax,%eax
  802bf9:	74 10                	je     802c0b <alloc_block_BF+0x6e>
  802bfb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bfe:	8b 00                	mov    (%eax),%eax
  802c00:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802c03:	8b 52 04             	mov    0x4(%edx),%edx
  802c06:	89 50 04             	mov    %edx,0x4(%eax)
  802c09:	eb 0b                	jmp    802c16 <alloc_block_BF+0x79>
  802c0b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c0e:	8b 40 04             	mov    0x4(%eax),%eax
  802c11:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802c16:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c19:	8b 40 04             	mov    0x4(%eax),%eax
  802c1c:	85 c0                	test   %eax,%eax
  802c1e:	74 0f                	je     802c2f <alloc_block_BF+0x92>
  802c20:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c23:	8b 40 04             	mov    0x4(%eax),%eax
  802c26:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802c29:	8b 12                	mov    (%edx),%edx
  802c2b:	89 10                	mov    %edx,(%eax)
  802c2d:	eb 0a                	jmp    802c39 <alloc_block_BF+0x9c>
  802c2f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c32:	8b 00                	mov    (%eax),%eax
  802c34:	a3 38 51 80 00       	mov    %eax,0x805138
  802c39:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c3c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802c42:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c45:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802c4c:	a1 44 51 80 00       	mov    0x805144,%eax
  802c51:	48                   	dec    %eax
  802c52:	a3 44 51 80 00       	mov    %eax,0x805144
			return blk;
  802c57:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c5a:	e9 11 02 00 00       	jmp    802e70 <alloc_block_BF+0x2d3>
	struct MemBlock* newblk=LIST_FIRST(&AvailableMemBlocksList);
	uint32 newveradd;
	uint32 newsize;
	int size_free = LIST_SIZE(&FreeMemBlocksList);

	LIST_FOREACH(blk, &FreeMemBlocksList)
  802c5f:	a1 40 51 80 00       	mov    0x805140,%eax
  802c64:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802c67:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802c6b:	74 07                	je     802c74 <alloc_block_BF+0xd7>
  802c6d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c70:	8b 00                	mov    (%eax),%eax
  802c72:	eb 05                	jmp    802c79 <alloc_block_BF+0xdc>
  802c74:	b8 00 00 00 00       	mov    $0x0,%eax
  802c79:	a3 40 51 80 00       	mov    %eax,0x805140
  802c7e:	a1 40 51 80 00       	mov    0x805140,%eax
  802c83:	85 c0                	test   %eax,%eax
  802c85:	0f 85 3b ff ff ff    	jne    802bc6 <alloc_block_BF+0x29>
  802c8b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802c8f:	0f 85 31 ff ff ff    	jne    802bc6 <alloc_block_BF+0x29>
		{
			LIST_REMOVE(&FreeMemBlocksList, blk);
			return blk;
		}
	}
	LIST_FOREACH(blk, &FreeMemBlocksList)
  802c95:	a1 38 51 80 00       	mov    0x805138,%eax
  802c9a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802c9d:	eb 27                	jmp    802cc6 <alloc_block_BF+0x129>
	{
		if(blk->size > versize)
  802c9f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ca2:	8b 40 0c             	mov    0xc(%eax),%eax
  802ca5:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  802ca8:	76 14                	jbe    802cbe <alloc_block_BF+0x121>
		{
			newsize = blk->size;
  802caa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cad:	8b 40 0c             	mov    0xc(%eax),%eax
  802cb0:	89 45 ec             	mov    %eax,-0x14(%ebp)
			newveradd = blk->sva;
  802cb3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cb6:	8b 40 08             	mov    0x8(%eax),%eax
  802cb9:	89 45 f0             	mov    %eax,-0x10(%ebp)
			break;
  802cbc:	eb 2e                	jmp    802cec <alloc_block_BF+0x14f>
		{
			LIST_REMOVE(&FreeMemBlocksList, blk);
			return blk;
		}
	}
	LIST_FOREACH(blk, &FreeMemBlocksList)
  802cbe:	a1 40 51 80 00       	mov    0x805140,%eax
  802cc3:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802cc6:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802cca:	74 07                	je     802cd3 <alloc_block_BF+0x136>
  802ccc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ccf:	8b 00                	mov    (%eax),%eax
  802cd1:	eb 05                	jmp    802cd8 <alloc_block_BF+0x13b>
  802cd3:	b8 00 00 00 00       	mov    $0x0,%eax
  802cd8:	a3 40 51 80 00       	mov    %eax,0x805140
  802cdd:	a1 40 51 80 00       	mov    0x805140,%eax
  802ce2:	85 c0                	test   %eax,%eax
  802ce4:	75 b9                	jne    802c9f <alloc_block_BF+0x102>
  802ce6:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802cea:	75 b3                	jne    802c9f <alloc_block_BF+0x102>
			newsize = blk->size;
			newveradd = blk->sva;
			break;
		}
	}
	LIST_FOREACH(blk, &FreeMemBlocksList)
  802cec:	a1 38 51 80 00       	mov    0x805138,%eax
  802cf1:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802cf4:	eb 30                	jmp    802d26 <alloc_block_BF+0x189>
	{
		if(newsize > blk->size && blk->size > versize)
  802cf6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cf9:	8b 40 0c             	mov    0xc(%eax),%eax
  802cfc:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  802cff:	73 1d                	jae    802d1e <alloc_block_BF+0x181>
  802d01:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d04:	8b 40 0c             	mov    0xc(%eax),%eax
  802d07:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  802d0a:	76 12                	jbe    802d1e <alloc_block_BF+0x181>
		{
	       newsize = blk->size;
  802d0c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d0f:	8b 40 0c             	mov    0xc(%eax),%eax
  802d12:	89 45 ec             	mov    %eax,-0x14(%ebp)
		   newveradd = blk->sva;
  802d15:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d18:	8b 40 08             	mov    0x8(%eax),%eax
  802d1b:	89 45 f0             	mov    %eax,-0x10(%ebp)
			newsize = blk->size;
			newveradd = blk->sva;
			break;
		}
	}
	LIST_FOREACH(blk, &FreeMemBlocksList)
  802d1e:	a1 40 51 80 00       	mov    0x805140,%eax
  802d23:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802d26:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802d2a:	74 07                	je     802d33 <alloc_block_BF+0x196>
  802d2c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d2f:	8b 00                	mov    (%eax),%eax
  802d31:	eb 05                	jmp    802d38 <alloc_block_BF+0x19b>
  802d33:	b8 00 00 00 00       	mov    $0x0,%eax
  802d38:	a3 40 51 80 00       	mov    %eax,0x805140
  802d3d:	a1 40 51 80 00       	mov    0x805140,%eax
  802d42:	85 c0                	test   %eax,%eax
  802d44:	75 b0                	jne    802cf6 <alloc_block_BF+0x159>
  802d46:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802d4a:	75 aa                	jne    802cf6 <alloc_block_BF+0x159>
		{
	       newsize = blk->size;
		   newveradd = blk->sva;
		}
	}
	LIST_FOREACH(blk, &FreeMemBlocksList)
  802d4c:	a1 38 51 80 00       	mov    0x805138,%eax
  802d51:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802d54:	e9 e4 00 00 00       	jmp    802e3d <alloc_block_BF+0x2a0>
	{
		if(blk->size == newsize && blk->sva == newveradd)
  802d59:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d5c:	8b 40 0c             	mov    0xc(%eax),%eax
  802d5f:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  802d62:	0f 85 cd 00 00 00    	jne    802e35 <alloc_block_BF+0x298>
  802d68:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d6b:	8b 40 08             	mov    0x8(%eax),%eax
  802d6e:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  802d71:	0f 85 be 00 00 00    	jne    802e35 <alloc_block_BF+0x298>
		{
			LIST_REMOVE(&AvailableMemBlocksList, newblk);
  802d77:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  802d7b:	75 17                	jne    802d94 <alloc_block_BF+0x1f7>
  802d7d:	83 ec 04             	sub    $0x4,%esp
  802d80:	68 dc 40 80 00       	push   $0x8040dc
  802d85:	68 db 00 00 00       	push   $0xdb
  802d8a:	68 6b 40 80 00       	push   $0x80406b
  802d8f:	e8 92 d9 ff ff       	call   800726 <_panic>
  802d94:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802d97:	8b 00                	mov    (%eax),%eax
  802d99:	85 c0                	test   %eax,%eax
  802d9b:	74 10                	je     802dad <alloc_block_BF+0x210>
  802d9d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802da0:	8b 00                	mov    (%eax),%eax
  802da2:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802da5:	8b 52 04             	mov    0x4(%edx),%edx
  802da8:	89 50 04             	mov    %edx,0x4(%eax)
  802dab:	eb 0b                	jmp    802db8 <alloc_block_BF+0x21b>
  802dad:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802db0:	8b 40 04             	mov    0x4(%eax),%eax
  802db3:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802db8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802dbb:	8b 40 04             	mov    0x4(%eax),%eax
  802dbe:	85 c0                	test   %eax,%eax
  802dc0:	74 0f                	je     802dd1 <alloc_block_BF+0x234>
  802dc2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802dc5:	8b 40 04             	mov    0x4(%eax),%eax
  802dc8:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802dcb:	8b 12                	mov    (%edx),%edx
  802dcd:	89 10                	mov    %edx,(%eax)
  802dcf:	eb 0a                	jmp    802ddb <alloc_block_BF+0x23e>
  802dd1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802dd4:	8b 00                	mov    (%eax),%eax
  802dd6:	a3 48 51 80 00       	mov    %eax,0x805148
  802ddb:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802dde:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802de4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802de7:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802dee:	a1 54 51 80 00       	mov    0x805154,%eax
  802df3:	48                   	dec    %eax
  802df4:	a3 54 51 80 00       	mov    %eax,0x805154
			newblk->size = versize;
  802df9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802dfc:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802dff:	89 50 0c             	mov    %edx,0xc(%eax)
			newblk->sva = newveradd;
  802e02:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802e05:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802e08:	89 50 08             	mov    %edx,0x8(%eax)
			blk->size = blk->size - versize;
  802e0b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e0e:	8b 40 0c             	mov    0xc(%eax),%eax
  802e11:	2b 45 e8             	sub    -0x18(%ebp),%eax
  802e14:	89 c2                	mov    %eax,%edx
  802e16:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e19:	89 50 0c             	mov    %edx,0xc(%eax)
			blk->sva+= newblk->size;
  802e1c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e1f:	8b 50 08             	mov    0x8(%eax),%edx
  802e22:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802e25:	8b 40 0c             	mov    0xc(%eax),%eax
  802e28:	01 c2                	add    %eax,%edx
  802e2a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e2d:	89 50 08             	mov    %edx,0x8(%eax)
			return newblk;
  802e30:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802e33:	eb 3b                	jmp    802e70 <alloc_block_BF+0x2d3>
		{
	       newsize = blk->size;
		   newveradd = blk->sva;
		}
	}
	LIST_FOREACH(blk, &FreeMemBlocksList)
  802e35:	a1 40 51 80 00       	mov    0x805140,%eax
  802e3a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802e3d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802e41:	74 07                	je     802e4a <alloc_block_BF+0x2ad>
  802e43:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e46:	8b 00                	mov    (%eax),%eax
  802e48:	eb 05                	jmp    802e4f <alloc_block_BF+0x2b2>
  802e4a:	b8 00 00 00 00       	mov    $0x0,%eax
  802e4f:	a3 40 51 80 00       	mov    %eax,0x805140
  802e54:	a1 40 51 80 00       	mov    0x805140,%eax
  802e59:	85 c0                	test   %eax,%eax
  802e5b:	0f 85 f8 fe ff ff    	jne    802d59 <alloc_block_BF+0x1bc>
  802e61:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802e65:	0f 85 ee fe ff ff    	jne    802d59 <alloc_block_BF+0x1bc>
			blk->size = blk->size - versize;
			blk->sva+= newblk->size;
			return newblk;
		}
	}
	return NULL;
  802e6b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802e70:	c9                   	leave  
  802e71:	c3                   	ret    

00802e72 <alloc_block_NF>:
//=========================================
// [7] ALLOCATE BLOCK BY NEXT FIT:
//=========================================
struct MemBlock *last_allocate;
struct MemBlock *alloc_block_NF(uint32 size)
{
  802e72:	55                   	push   %ebp
  802e73:	89 e5                	mov    %esp,%ebp
  802e75:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1 - BONUS] [DYNAMIC ALLOCATOR] alloc_block_NF
	// Write your code here, remove the panic and write your code
	//panic("alloc_block_NF() is not implemented yet...!!");
	uint32 versize = size;
  802e78:	8b 45 08             	mov    0x8(%ebp),%eax
  802e7b:	89 45 f0             	mov    %eax,-0x10(%ebp)
	struct MemBlock* blk;
	struct MemBlock* newblk = LIST_FIRST(&AvailableMemBlocksList);
  802e7e:	a1 48 51 80 00       	mov    0x805148,%eax
  802e83:	89 45 ec             	mov    %eax,-0x14(%ebp)

	LIST_FOREACH(blk,&FreeMemBlocksList)
  802e86:	a1 38 51 80 00       	mov    0x805138,%eax
  802e8b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802e8e:	e9 77 01 00 00       	jmp    80300a <alloc_block_NF+0x198>
	{
		if(blk->size == versize)
  802e93:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e96:	8b 40 0c             	mov    0xc(%eax),%eax
  802e99:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  802e9c:	0f 85 8a 00 00 00    	jne    802f2c <alloc_block_NF+0xba>
		{
			LIST_REMOVE(&FreeMemBlocksList,blk);
  802ea2:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802ea6:	75 17                	jne    802ebf <alloc_block_NF+0x4d>
  802ea8:	83 ec 04             	sub    $0x4,%esp
  802eab:	68 dc 40 80 00       	push   $0x8040dc
  802eb0:	68 f7 00 00 00       	push   $0xf7
  802eb5:	68 6b 40 80 00       	push   $0x80406b
  802eba:	e8 67 d8 ff ff       	call   800726 <_panic>
  802ebf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ec2:	8b 00                	mov    (%eax),%eax
  802ec4:	85 c0                	test   %eax,%eax
  802ec6:	74 10                	je     802ed8 <alloc_block_NF+0x66>
  802ec8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ecb:	8b 00                	mov    (%eax),%eax
  802ecd:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802ed0:	8b 52 04             	mov    0x4(%edx),%edx
  802ed3:	89 50 04             	mov    %edx,0x4(%eax)
  802ed6:	eb 0b                	jmp    802ee3 <alloc_block_NF+0x71>
  802ed8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802edb:	8b 40 04             	mov    0x4(%eax),%eax
  802ede:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802ee3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ee6:	8b 40 04             	mov    0x4(%eax),%eax
  802ee9:	85 c0                	test   %eax,%eax
  802eeb:	74 0f                	je     802efc <alloc_block_NF+0x8a>
  802eed:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ef0:	8b 40 04             	mov    0x4(%eax),%eax
  802ef3:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802ef6:	8b 12                	mov    (%edx),%edx
  802ef8:	89 10                	mov    %edx,(%eax)
  802efa:	eb 0a                	jmp    802f06 <alloc_block_NF+0x94>
  802efc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802eff:	8b 00                	mov    (%eax),%eax
  802f01:	a3 38 51 80 00       	mov    %eax,0x805138
  802f06:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f09:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802f0f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f12:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802f19:	a1 44 51 80 00       	mov    0x805144,%eax
  802f1e:	48                   	dec    %eax
  802f1f:	a3 44 51 80 00       	mov    %eax,0x805144
			return blk;
  802f24:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f27:	e9 11 01 00 00       	jmp    80303d <alloc_block_NF+0x1cb>
		}
		else if(blk->size > versize)
  802f2c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f2f:	8b 40 0c             	mov    0xc(%eax),%eax
  802f32:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  802f35:	0f 86 c7 00 00 00    	jbe    803002 <alloc_block_NF+0x190>
		{
			LIST_REMOVE(&AvailableMemBlocksList,newblk);
  802f3b:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802f3f:	75 17                	jne    802f58 <alloc_block_NF+0xe6>
  802f41:	83 ec 04             	sub    $0x4,%esp
  802f44:	68 dc 40 80 00       	push   $0x8040dc
  802f49:	68 fc 00 00 00       	push   $0xfc
  802f4e:	68 6b 40 80 00       	push   $0x80406b
  802f53:	e8 ce d7 ff ff       	call   800726 <_panic>
  802f58:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802f5b:	8b 00                	mov    (%eax),%eax
  802f5d:	85 c0                	test   %eax,%eax
  802f5f:	74 10                	je     802f71 <alloc_block_NF+0xff>
  802f61:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802f64:	8b 00                	mov    (%eax),%eax
  802f66:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802f69:	8b 52 04             	mov    0x4(%edx),%edx
  802f6c:	89 50 04             	mov    %edx,0x4(%eax)
  802f6f:	eb 0b                	jmp    802f7c <alloc_block_NF+0x10a>
  802f71:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802f74:	8b 40 04             	mov    0x4(%eax),%eax
  802f77:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802f7c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802f7f:	8b 40 04             	mov    0x4(%eax),%eax
  802f82:	85 c0                	test   %eax,%eax
  802f84:	74 0f                	je     802f95 <alloc_block_NF+0x123>
  802f86:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802f89:	8b 40 04             	mov    0x4(%eax),%eax
  802f8c:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802f8f:	8b 12                	mov    (%edx),%edx
  802f91:	89 10                	mov    %edx,(%eax)
  802f93:	eb 0a                	jmp    802f9f <alloc_block_NF+0x12d>
  802f95:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802f98:	8b 00                	mov    (%eax),%eax
  802f9a:	a3 48 51 80 00       	mov    %eax,0x805148
  802f9f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802fa2:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802fa8:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802fab:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802fb2:	a1 54 51 80 00       	mov    0x805154,%eax
  802fb7:	48                   	dec    %eax
  802fb8:	a3 54 51 80 00       	mov    %eax,0x805154
			newblk->size = versize;
  802fbd:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802fc0:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802fc3:	89 50 0c             	mov    %edx,0xc(%eax)
			blk->size = blk->size-versize;
  802fc6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802fc9:	8b 40 0c             	mov    0xc(%eax),%eax
  802fcc:	2b 45 f0             	sub    -0x10(%ebp),%eax
  802fcf:	89 c2                	mov    %eax,%edx
  802fd1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802fd4:	89 50 0c             	mov    %edx,0xc(%eax)
			uint32 newveradd = blk->sva;
  802fd7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802fda:	8b 40 08             	mov    0x8(%eax),%eax
  802fdd:	89 45 e8             	mov    %eax,-0x18(%ebp)
			blk->sva+=newblk->size;
  802fe0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802fe3:	8b 50 08             	mov    0x8(%eax),%edx
  802fe6:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802fe9:	8b 40 0c             	mov    0xc(%eax),%eax
  802fec:	01 c2                	add    %eax,%edx
  802fee:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ff1:	89 50 08             	mov    %edx,0x8(%eax)
			newblk->sva = newveradd;
  802ff4:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802ff7:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802ffa:	89 50 08             	mov    %edx,0x8(%eax)
			return newblk;
  802ffd:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803000:	eb 3b                	jmp    80303d <alloc_block_NF+0x1cb>
	//panic("alloc_block_NF() is not implemented yet...!!");
	uint32 versize = size;
	struct MemBlock* blk;
	struct MemBlock* newblk = LIST_FIRST(&AvailableMemBlocksList);

	LIST_FOREACH(blk,&FreeMemBlocksList)
  803002:	a1 40 51 80 00       	mov    0x805140,%eax
  803007:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80300a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80300e:	74 07                	je     803017 <alloc_block_NF+0x1a5>
  803010:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803013:	8b 00                	mov    (%eax),%eax
  803015:	eb 05                	jmp    80301c <alloc_block_NF+0x1aa>
  803017:	b8 00 00 00 00       	mov    $0x0,%eax
  80301c:	a3 40 51 80 00       	mov    %eax,0x805140
  803021:	a1 40 51 80 00       	mov    0x805140,%eax
  803026:	85 c0                	test   %eax,%eax
  803028:	0f 85 65 fe ff ff    	jne    802e93 <alloc_block_NF+0x21>
  80302e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803032:	0f 85 5b fe ff ff    	jne    802e93 <alloc_block_NF+0x21>
			blk->sva+=newblk->size;
			newblk->sva = newveradd;
			return newblk;
		}
	}
	return NULL;
  803038:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80303d:	c9                   	leave  
  80303e:	c3                   	ret    

0080303f <addToAvailMemBlocksList>:

//===================================================
// [8] INSERT BLOCK (SORTED WITH MERGE) IN FREE LIST:
//===================================================
void addToAvailMemBlocksList(struct MemBlock *blockToInsert)
{
  80303f:	55                   	push   %ebp
  803040:	89 e5                	mov    %esp,%ebp
  803042:	83 ec 08             	sub    $0x8,%esp
	blockToInsert->sva = 0;
  803045:	8b 45 08             	mov    0x8(%ebp),%eax
  803048:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
	blockToInsert->size = 0;
  80304f:	8b 45 08             	mov    0x8(%ebp),%eax
  803052:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
	//add to avail
	LIST_INSERT_TAIL(&AvailableMemBlocksList, blockToInsert);
  803059:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80305d:	75 17                	jne    803076 <addToAvailMemBlocksList+0x37>
  80305f:	83 ec 04             	sub    $0x4,%esp
  803062:	68 84 40 80 00       	push   $0x804084
  803067:	68 10 01 00 00       	push   $0x110
  80306c:	68 6b 40 80 00       	push   $0x80406b
  803071:	e8 b0 d6 ff ff       	call   800726 <_panic>
  803076:	8b 15 4c 51 80 00    	mov    0x80514c,%edx
  80307c:	8b 45 08             	mov    0x8(%ebp),%eax
  80307f:	89 50 04             	mov    %edx,0x4(%eax)
  803082:	8b 45 08             	mov    0x8(%ebp),%eax
  803085:	8b 40 04             	mov    0x4(%eax),%eax
  803088:	85 c0                	test   %eax,%eax
  80308a:	74 0c                	je     803098 <addToAvailMemBlocksList+0x59>
  80308c:	a1 4c 51 80 00       	mov    0x80514c,%eax
  803091:	8b 55 08             	mov    0x8(%ebp),%edx
  803094:	89 10                	mov    %edx,(%eax)
  803096:	eb 08                	jmp    8030a0 <addToAvailMemBlocksList+0x61>
  803098:	8b 45 08             	mov    0x8(%ebp),%eax
  80309b:	a3 48 51 80 00       	mov    %eax,0x805148
  8030a0:	8b 45 08             	mov    0x8(%ebp),%eax
  8030a3:	a3 4c 51 80 00       	mov    %eax,0x80514c
  8030a8:	8b 45 08             	mov    0x8(%ebp),%eax
  8030ab:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8030b1:	a1 54 51 80 00       	mov    0x805154,%eax
  8030b6:	40                   	inc    %eax
  8030b7:	a3 54 51 80 00       	mov    %eax,0x805154
}
  8030bc:	90                   	nop
  8030bd:	c9                   	leave  
  8030be:	c3                   	ret    

008030bf <insert_sorted_with_merge_freeList>:
void insert_sorted_with_merge_freeList(struct MemBlock *blockToInsert)
{
  8030bf:	55                   	push   %ebp
  8030c0:	89 e5                	mov    %esp,%ebp
  8030c2:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] insert_sorted_with_merge_freeList
	// Write your code here, remove the panic and write your code

	struct MemBlock* last = LIST_LAST(&FreeMemBlocksList);
  8030c5:	a1 3c 51 80 00       	mov    0x80513c,%eax
  8030ca:	89 45 f0             	mov    %eax,-0x10(%ebp)
	//check if list empty
	if (LIST_SIZE(&(FreeMemBlocksList)) == 0)
  8030cd:	a1 44 51 80 00       	mov    0x805144,%eax
  8030d2:	85 c0                	test   %eax,%eax
  8030d4:	75 68                	jne    80313e <insert_sorted_with_merge_freeList+0x7f>
		LIST_INSERT_HEAD(&FreeMemBlocksList, blockToInsert);
  8030d6:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8030da:	75 17                	jne    8030f3 <insert_sorted_with_merge_freeList+0x34>
  8030dc:	83 ec 04             	sub    $0x4,%esp
  8030df:	68 48 40 80 00       	push   $0x804048
  8030e4:	68 1a 01 00 00       	push   $0x11a
  8030e9:	68 6b 40 80 00       	push   $0x80406b
  8030ee:	e8 33 d6 ff ff       	call   800726 <_panic>
  8030f3:	8b 15 38 51 80 00    	mov    0x805138,%edx
  8030f9:	8b 45 08             	mov    0x8(%ebp),%eax
  8030fc:	89 10                	mov    %edx,(%eax)
  8030fe:	8b 45 08             	mov    0x8(%ebp),%eax
  803101:	8b 00                	mov    (%eax),%eax
  803103:	85 c0                	test   %eax,%eax
  803105:	74 0d                	je     803114 <insert_sorted_with_merge_freeList+0x55>
  803107:	a1 38 51 80 00       	mov    0x805138,%eax
  80310c:	8b 55 08             	mov    0x8(%ebp),%edx
  80310f:	89 50 04             	mov    %edx,0x4(%eax)
  803112:	eb 08                	jmp    80311c <insert_sorted_with_merge_freeList+0x5d>
  803114:	8b 45 08             	mov    0x8(%ebp),%eax
  803117:	a3 3c 51 80 00       	mov    %eax,0x80513c
  80311c:	8b 45 08             	mov    0x8(%ebp),%eax
  80311f:	a3 38 51 80 00       	mov    %eax,0x805138
  803124:	8b 45 08             	mov    0x8(%ebp),%eax
  803127:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80312e:	a1 44 51 80 00       	mov    0x805144,%eax
  803133:	40                   	inc    %eax
  803134:	a3 44 51 80 00       	mov    %eax,0x805144
		}
	}

	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  803139:	e9 c5 03 00 00       	jmp    803503 <insert_sorted_with_merge_freeList+0x444>
	struct MemBlock* last = LIST_LAST(&FreeMemBlocksList);
	//check if list empty
	if (LIST_SIZE(&(FreeMemBlocksList)) == 0)
		LIST_INSERT_HEAD(&FreeMemBlocksList, blockToInsert);
	//check if it's position is at last
	else if (last->sva < blockToInsert->sva) {
  80313e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803141:	8b 50 08             	mov    0x8(%eax),%edx
  803144:	8b 45 08             	mov    0x8(%ebp),%eax
  803147:	8b 40 08             	mov    0x8(%eax),%eax
  80314a:	39 c2                	cmp    %eax,%edx
  80314c:	0f 83 b2 00 00 00    	jae    803204 <insert_sorted_with_merge_freeList+0x145>

		//if i have to merge
		if (last->sva + last->size == blockToInsert->sva) {
  803152:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803155:	8b 50 08             	mov    0x8(%eax),%edx
  803158:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80315b:	8b 40 0c             	mov    0xc(%eax),%eax
  80315e:	01 c2                	add    %eax,%edx
  803160:	8b 45 08             	mov    0x8(%ebp),%eax
  803163:	8b 40 08             	mov    0x8(%eax),%eax
  803166:	39 c2                	cmp    %eax,%edx
  803168:	75 27                	jne    803191 <insert_sorted_with_merge_freeList+0xd2>
			last->size = last->size + blockToInsert->size;
  80316a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80316d:	8b 50 0c             	mov    0xc(%eax),%edx
  803170:	8b 45 08             	mov    0x8(%ebp),%eax
  803173:	8b 40 0c             	mov    0xc(%eax),%eax
  803176:	01 c2                	add    %eax,%edx
  803178:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80317b:	89 50 0c             	mov    %edx,0xc(%eax)
			addToAvailMemBlocksList(blockToInsert);
  80317e:	83 ec 0c             	sub    $0xc,%esp
  803181:	ff 75 08             	pushl  0x8(%ebp)
  803184:	e8 b6 fe ff ff       	call   80303f <addToAvailMemBlocksList>
  803189:	83 c4 10             	add    $0x10,%esp
		}
	}

	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  80318c:	e9 72 03 00 00       	jmp    803503 <insert_sorted_with_merge_freeList+0x444>
		if (last->sva + last->size == blockToInsert->sva) {
			last->size = last->size + blockToInsert->size;
			addToAvailMemBlocksList(blockToInsert);

		} else {
			LIST_INSERT_AFTER(&FreeMemBlocksList, last, blockToInsert);
  803191:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  803195:	74 06                	je     80319d <insert_sorted_with_merge_freeList+0xde>
  803197:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80319b:	75 17                	jne    8031b4 <insert_sorted_with_merge_freeList+0xf5>
  80319d:	83 ec 04             	sub    $0x4,%esp
  8031a0:	68 a8 40 80 00       	push   $0x8040a8
  8031a5:	68 24 01 00 00       	push   $0x124
  8031aa:	68 6b 40 80 00       	push   $0x80406b
  8031af:	e8 72 d5 ff ff       	call   800726 <_panic>
  8031b4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8031b7:	8b 10                	mov    (%eax),%edx
  8031b9:	8b 45 08             	mov    0x8(%ebp),%eax
  8031bc:	89 10                	mov    %edx,(%eax)
  8031be:	8b 45 08             	mov    0x8(%ebp),%eax
  8031c1:	8b 00                	mov    (%eax),%eax
  8031c3:	85 c0                	test   %eax,%eax
  8031c5:	74 0b                	je     8031d2 <insert_sorted_with_merge_freeList+0x113>
  8031c7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8031ca:	8b 00                	mov    (%eax),%eax
  8031cc:	8b 55 08             	mov    0x8(%ebp),%edx
  8031cf:	89 50 04             	mov    %edx,0x4(%eax)
  8031d2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8031d5:	8b 55 08             	mov    0x8(%ebp),%edx
  8031d8:	89 10                	mov    %edx,(%eax)
  8031da:	8b 45 08             	mov    0x8(%ebp),%eax
  8031dd:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8031e0:	89 50 04             	mov    %edx,0x4(%eax)
  8031e3:	8b 45 08             	mov    0x8(%ebp),%eax
  8031e6:	8b 00                	mov    (%eax),%eax
  8031e8:	85 c0                	test   %eax,%eax
  8031ea:	75 08                	jne    8031f4 <insert_sorted_with_merge_freeList+0x135>
  8031ec:	8b 45 08             	mov    0x8(%ebp),%eax
  8031ef:	a3 3c 51 80 00       	mov    %eax,0x80513c
  8031f4:	a1 44 51 80 00       	mov    0x805144,%eax
  8031f9:	40                   	inc    %eax
  8031fa:	a3 44 51 80 00       	mov    %eax,0x805144
		}
	}

	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  8031ff:	e9 ff 02 00 00       	jmp    803503 <insert_sorted_with_merge_freeList+0x444>
		} else {
			LIST_INSERT_AFTER(&FreeMemBlocksList, last, blockToInsert);
		}
	} else {
		struct MemBlock *iterator;
		LIST_FOREACH(iterator, &(FreeMemBlocksList))
  803204:	a1 38 51 80 00       	mov    0x805138,%eax
  803209:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80320c:	e9 c2 02 00 00       	jmp    8034d3 <insert_sorted_with_merge_freeList+0x414>
		{

			if (iterator->sva > blockToInsert->sva) {
  803211:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803214:	8b 50 08             	mov    0x8(%eax),%edx
  803217:	8b 45 08             	mov    0x8(%ebp),%eax
  80321a:	8b 40 08             	mov    0x8(%eax),%eax
  80321d:	39 c2                	cmp    %eax,%edx
  80321f:	0f 86 a6 02 00 00    	jbe    8034cb <insert_sorted_with_merge_freeList+0x40c>

				struct MemBlock* prev = LIST_PREV(iterator);
  803225:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803228:	8b 40 04             	mov    0x4(%eax),%eax
  80322b:	89 45 ec             	mov    %eax,-0x14(%ebp)
				if (prev == NULL) {
  80322e:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  803232:	0f 85 ba 00 00 00    	jne    8032f2 <insert_sorted_with_merge_freeList+0x233>
					//check merge
					if (blockToInsert->size + blockToInsert->sva
  803238:	8b 45 08             	mov    0x8(%ebp),%eax
  80323b:	8b 50 0c             	mov    0xc(%eax),%edx
  80323e:	8b 45 08             	mov    0x8(%ebp),%eax
  803241:	8b 40 08             	mov    0x8(%eax),%eax
  803244:	01 c2                	add    %eax,%edx
							== iterator->sva) {
  803246:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803249:	8b 40 08             	mov    0x8(%eax),%eax
			if (iterator->sva > blockToInsert->sva) {

				struct MemBlock* prev = LIST_PREV(iterator);
				if (prev == NULL) {
					//check merge
					if (blockToInsert->size + blockToInsert->sva
  80324c:	39 c2                	cmp    %eax,%edx
  80324e:	75 33                	jne    803283 <insert_sorted_with_merge_freeList+0x1c4>
							== iterator->sva) {
						iterator->sva = blockToInsert->sva;
  803250:	8b 45 08             	mov    0x8(%ebp),%eax
  803253:	8b 50 08             	mov    0x8(%eax),%edx
  803256:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803259:	89 50 08             	mov    %edx,0x8(%eax)
						iterator->size = iterator->size + blockToInsert->size;
  80325c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80325f:	8b 50 0c             	mov    0xc(%eax),%edx
  803262:	8b 45 08             	mov    0x8(%ebp),%eax
  803265:	8b 40 0c             	mov    0xc(%eax),%eax
  803268:	01 c2                	add    %eax,%edx
  80326a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80326d:	89 50 0c             	mov    %edx,0xc(%eax)
						addToAvailMemBlocksList(blockToInsert);
  803270:	83 ec 0c             	sub    $0xc,%esp
  803273:	ff 75 08             	pushl  0x8(%ebp)
  803276:	e8 c4 fd ff ff       	call   80303f <addToAvailMemBlocksList>
  80327b:	83 c4 10             	add    $0x10,%esp

					else {
						LIST_INSERT_BEFORE(&FreeMemBlocksList, iterator,
								blockToInsert);
					}
					break;
  80327e:	e9 80 02 00 00       	jmp    803503 <insert_sorted_with_merge_freeList+0x444>
						addToAvailMemBlocksList(blockToInsert);

					}

					else {
						LIST_INSERT_BEFORE(&FreeMemBlocksList, iterator,
  803283:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803287:	74 06                	je     80328f <insert_sorted_with_merge_freeList+0x1d0>
  803289:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80328d:	75 17                	jne    8032a6 <insert_sorted_with_merge_freeList+0x1e7>
  80328f:	83 ec 04             	sub    $0x4,%esp
  803292:	68 fc 40 80 00       	push   $0x8040fc
  803297:	68 3a 01 00 00       	push   $0x13a
  80329c:	68 6b 40 80 00       	push   $0x80406b
  8032a1:	e8 80 d4 ff ff       	call   800726 <_panic>
  8032a6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8032a9:	8b 50 04             	mov    0x4(%eax),%edx
  8032ac:	8b 45 08             	mov    0x8(%ebp),%eax
  8032af:	89 50 04             	mov    %edx,0x4(%eax)
  8032b2:	8b 45 08             	mov    0x8(%ebp),%eax
  8032b5:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8032b8:	89 10                	mov    %edx,(%eax)
  8032ba:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8032bd:	8b 40 04             	mov    0x4(%eax),%eax
  8032c0:	85 c0                	test   %eax,%eax
  8032c2:	74 0d                	je     8032d1 <insert_sorted_with_merge_freeList+0x212>
  8032c4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8032c7:	8b 40 04             	mov    0x4(%eax),%eax
  8032ca:	8b 55 08             	mov    0x8(%ebp),%edx
  8032cd:	89 10                	mov    %edx,(%eax)
  8032cf:	eb 08                	jmp    8032d9 <insert_sorted_with_merge_freeList+0x21a>
  8032d1:	8b 45 08             	mov    0x8(%ebp),%eax
  8032d4:	a3 38 51 80 00       	mov    %eax,0x805138
  8032d9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8032dc:	8b 55 08             	mov    0x8(%ebp),%edx
  8032df:	89 50 04             	mov    %edx,0x4(%eax)
  8032e2:	a1 44 51 80 00       	mov    0x805144,%eax
  8032e7:	40                   	inc    %eax
  8032e8:	a3 44 51 80 00       	mov    %eax,0x805144
								blockToInsert);
					}
					break;
  8032ed:	e9 11 02 00 00       	jmp    803503 <insert_sorted_with_merge_freeList+0x444>
				} else {
					//prev and next merge
					if (prev->sva + prev->size + blockToInsert->size
  8032f2:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8032f5:	8b 50 08             	mov    0x8(%eax),%edx
  8032f8:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8032fb:	8b 40 0c             	mov    0xc(%eax),%eax
  8032fe:	01 c2                	add    %eax,%edx
  803300:	8b 45 08             	mov    0x8(%ebp),%eax
  803303:	8b 40 0c             	mov    0xc(%eax),%eax
  803306:	01 c2                	add    %eax,%edx
							== iterator->sva) {
  803308:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80330b:	8b 40 08             	mov    0x8(%eax),%eax
								blockToInsert);
					}
					break;
				} else {
					//prev and next merge
					if (prev->sva + prev->size + blockToInsert->size
  80330e:	39 c2                	cmp    %eax,%edx
  803310:	0f 85 bf 00 00 00    	jne    8033d5 <insert_sorted_with_merge_freeList+0x316>
							== iterator->sva) {
						prev->size = prev->size + blockToInsert->size
  803316:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803319:	8b 50 0c             	mov    0xc(%eax),%edx
  80331c:	8b 45 08             	mov    0x8(%ebp),%eax
  80331f:	8b 40 0c             	mov    0xc(%eax),%eax
  803322:	01 c2                	add    %eax,%edx
								+ iterator->size;
  803324:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803327:	8b 40 0c             	mov    0xc(%eax),%eax
  80332a:	01 c2                	add    %eax,%edx
					break;
				} else {
					//prev and next merge
					if (prev->sva + prev->size + blockToInsert->size
							== iterator->sva) {
						prev->size = prev->size + blockToInsert->size
  80332c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80332f:	89 50 0c             	mov    %edx,0xc(%eax)
								+ iterator->size;
						LIST_REMOVE(&FreeMemBlocksList, iterator);
  803332:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803336:	75 17                	jne    80334f <insert_sorted_with_merge_freeList+0x290>
  803338:	83 ec 04             	sub    $0x4,%esp
  80333b:	68 dc 40 80 00       	push   $0x8040dc
  803340:	68 43 01 00 00       	push   $0x143
  803345:	68 6b 40 80 00       	push   $0x80406b
  80334a:	e8 d7 d3 ff ff       	call   800726 <_panic>
  80334f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803352:	8b 00                	mov    (%eax),%eax
  803354:	85 c0                	test   %eax,%eax
  803356:	74 10                	je     803368 <insert_sorted_with_merge_freeList+0x2a9>
  803358:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80335b:	8b 00                	mov    (%eax),%eax
  80335d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803360:	8b 52 04             	mov    0x4(%edx),%edx
  803363:	89 50 04             	mov    %edx,0x4(%eax)
  803366:	eb 0b                	jmp    803373 <insert_sorted_with_merge_freeList+0x2b4>
  803368:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80336b:	8b 40 04             	mov    0x4(%eax),%eax
  80336e:	a3 3c 51 80 00       	mov    %eax,0x80513c
  803373:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803376:	8b 40 04             	mov    0x4(%eax),%eax
  803379:	85 c0                	test   %eax,%eax
  80337b:	74 0f                	je     80338c <insert_sorted_with_merge_freeList+0x2cd>
  80337d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803380:	8b 40 04             	mov    0x4(%eax),%eax
  803383:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803386:	8b 12                	mov    (%edx),%edx
  803388:	89 10                	mov    %edx,(%eax)
  80338a:	eb 0a                	jmp    803396 <insert_sorted_with_merge_freeList+0x2d7>
  80338c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80338f:	8b 00                	mov    (%eax),%eax
  803391:	a3 38 51 80 00       	mov    %eax,0x805138
  803396:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803399:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80339f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8033a2:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8033a9:	a1 44 51 80 00       	mov    0x805144,%eax
  8033ae:	48                   	dec    %eax
  8033af:	a3 44 51 80 00       	mov    %eax,0x805144
						addToAvailMemBlocksList(blockToInsert);
  8033b4:	83 ec 0c             	sub    $0xc,%esp
  8033b7:	ff 75 08             	pushl  0x8(%ebp)
  8033ba:	e8 80 fc ff ff       	call   80303f <addToAvailMemBlocksList>
  8033bf:	83 c4 10             	add    $0x10,%esp
						addToAvailMemBlocksList(iterator);
  8033c2:	83 ec 0c             	sub    $0xc,%esp
  8033c5:	ff 75 f4             	pushl  -0xc(%ebp)
  8033c8:	e8 72 fc ff ff       	call   80303f <addToAvailMemBlocksList>
  8033cd:	83 c4 10             	add    $0x10,%esp
					//Insert
					else {
						LIST_INSERT_BEFORE(&FreeMemBlocksList, iterator,
								blockToInsert);
					}
					break;
  8033d0:	e9 2e 01 00 00       	jmp    803503 <insert_sorted_with_merge_freeList+0x444>
						LIST_REMOVE(&FreeMemBlocksList, iterator);
						addToAvailMemBlocksList(blockToInsert);
						addToAvailMemBlocksList(iterator);
					}
					//previous merge
					else if (prev->sva + prev->size == blockToInsert->sva) {
  8033d5:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8033d8:	8b 50 08             	mov    0x8(%eax),%edx
  8033db:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8033de:	8b 40 0c             	mov    0xc(%eax),%eax
  8033e1:	01 c2                	add    %eax,%edx
  8033e3:	8b 45 08             	mov    0x8(%ebp),%eax
  8033e6:	8b 40 08             	mov    0x8(%eax),%eax
  8033e9:	39 c2                	cmp    %eax,%edx
  8033eb:	75 27                	jne    803414 <insert_sorted_with_merge_freeList+0x355>
						prev->size = prev->size + blockToInsert->size;
  8033ed:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8033f0:	8b 50 0c             	mov    0xc(%eax),%edx
  8033f3:	8b 45 08             	mov    0x8(%ebp),%eax
  8033f6:	8b 40 0c             	mov    0xc(%eax),%eax
  8033f9:	01 c2                	add    %eax,%edx
  8033fb:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8033fe:	89 50 0c             	mov    %edx,0xc(%eax)
						addToAvailMemBlocksList(blockToInsert);
  803401:	83 ec 0c             	sub    $0xc,%esp
  803404:	ff 75 08             	pushl  0x8(%ebp)
  803407:	e8 33 fc ff ff       	call   80303f <addToAvailMemBlocksList>
  80340c:	83 c4 10             	add    $0x10,%esp
					//Insert
					else {
						LIST_INSERT_BEFORE(&FreeMemBlocksList, iterator,
								blockToInsert);
					}
					break;
  80340f:	e9 ef 00 00 00       	jmp    803503 <insert_sorted_with_merge_freeList+0x444>
					else if (prev->sva + prev->size == blockToInsert->sva) {
						prev->size = prev->size + blockToInsert->size;
						addToAvailMemBlocksList(blockToInsert);
					}
					//next merge
					else if (blockToInsert->size + blockToInsert->sva
  803414:	8b 45 08             	mov    0x8(%ebp),%eax
  803417:	8b 50 0c             	mov    0xc(%eax),%edx
  80341a:	8b 45 08             	mov    0x8(%ebp),%eax
  80341d:	8b 40 08             	mov    0x8(%eax),%eax
  803420:	01 c2                	add    %eax,%edx
							== iterator->sva) {
  803422:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803425:	8b 40 08             	mov    0x8(%eax),%eax
					else if (prev->sva + prev->size == blockToInsert->sva) {
						prev->size = prev->size + blockToInsert->size;
						addToAvailMemBlocksList(blockToInsert);
					}
					//next merge
					else if (blockToInsert->size + blockToInsert->sva
  803428:	39 c2                	cmp    %eax,%edx
  80342a:	75 33                	jne    80345f <insert_sorted_with_merge_freeList+0x3a0>
							== iterator->sva) {
						iterator->sva = blockToInsert->sva;
  80342c:	8b 45 08             	mov    0x8(%ebp),%eax
  80342f:	8b 50 08             	mov    0x8(%eax),%edx
  803432:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803435:	89 50 08             	mov    %edx,0x8(%eax)
						iterator->size = iterator->size + blockToInsert->size;
  803438:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80343b:	8b 50 0c             	mov    0xc(%eax),%edx
  80343e:	8b 45 08             	mov    0x8(%ebp),%eax
  803441:	8b 40 0c             	mov    0xc(%eax),%eax
  803444:	01 c2                	add    %eax,%edx
  803446:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803449:	89 50 0c             	mov    %edx,0xc(%eax)
						addToAvailMemBlocksList(blockToInsert);
  80344c:	83 ec 0c             	sub    $0xc,%esp
  80344f:	ff 75 08             	pushl  0x8(%ebp)
  803452:	e8 e8 fb ff ff       	call   80303f <addToAvailMemBlocksList>
  803457:	83 c4 10             	add    $0x10,%esp
					//Insert
					else {
						LIST_INSERT_BEFORE(&FreeMemBlocksList, iterator,
								blockToInsert);
					}
					break;
  80345a:	e9 a4 00 00 00       	jmp    803503 <insert_sorted_with_merge_freeList+0x444>
						iterator->size = iterator->size + blockToInsert->size;
						addToAvailMemBlocksList(blockToInsert);
					}
					//Insert
					else {
						LIST_INSERT_BEFORE(&FreeMemBlocksList, iterator,
  80345f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803463:	74 06                	je     80346b <insert_sorted_with_merge_freeList+0x3ac>
  803465:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803469:	75 17                	jne    803482 <insert_sorted_with_merge_freeList+0x3c3>
  80346b:	83 ec 04             	sub    $0x4,%esp
  80346e:	68 fc 40 80 00       	push   $0x8040fc
  803473:	68 56 01 00 00       	push   $0x156
  803478:	68 6b 40 80 00       	push   $0x80406b
  80347d:	e8 a4 d2 ff ff       	call   800726 <_panic>
  803482:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803485:	8b 50 04             	mov    0x4(%eax),%edx
  803488:	8b 45 08             	mov    0x8(%ebp),%eax
  80348b:	89 50 04             	mov    %edx,0x4(%eax)
  80348e:	8b 45 08             	mov    0x8(%ebp),%eax
  803491:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803494:	89 10                	mov    %edx,(%eax)
  803496:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803499:	8b 40 04             	mov    0x4(%eax),%eax
  80349c:	85 c0                	test   %eax,%eax
  80349e:	74 0d                	je     8034ad <insert_sorted_with_merge_freeList+0x3ee>
  8034a0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8034a3:	8b 40 04             	mov    0x4(%eax),%eax
  8034a6:	8b 55 08             	mov    0x8(%ebp),%edx
  8034a9:	89 10                	mov    %edx,(%eax)
  8034ab:	eb 08                	jmp    8034b5 <insert_sorted_with_merge_freeList+0x3f6>
  8034ad:	8b 45 08             	mov    0x8(%ebp),%eax
  8034b0:	a3 38 51 80 00       	mov    %eax,0x805138
  8034b5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8034b8:	8b 55 08             	mov    0x8(%ebp),%edx
  8034bb:	89 50 04             	mov    %edx,0x4(%eax)
  8034be:	a1 44 51 80 00       	mov    0x805144,%eax
  8034c3:	40                   	inc    %eax
  8034c4:	a3 44 51 80 00       	mov    %eax,0x805144
								blockToInsert);
					}
					break;
  8034c9:	eb 38                	jmp    803503 <insert_sorted_with_merge_freeList+0x444>
		} else {
			LIST_INSERT_AFTER(&FreeMemBlocksList, last, blockToInsert);
		}
	} else {
		struct MemBlock *iterator;
		LIST_FOREACH(iterator, &(FreeMemBlocksList))
  8034cb:	a1 40 51 80 00       	mov    0x805140,%eax
  8034d0:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8034d3:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8034d7:	74 07                	je     8034e0 <insert_sorted_with_merge_freeList+0x421>
  8034d9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8034dc:	8b 00                	mov    (%eax),%eax
  8034de:	eb 05                	jmp    8034e5 <insert_sorted_with_merge_freeList+0x426>
  8034e0:	b8 00 00 00 00       	mov    $0x0,%eax
  8034e5:	a3 40 51 80 00       	mov    %eax,0x805140
  8034ea:	a1 40 51 80 00       	mov    0x805140,%eax
  8034ef:	85 c0                	test   %eax,%eax
  8034f1:	0f 85 1a fd ff ff    	jne    803211 <insert_sorted_with_merge_freeList+0x152>
  8034f7:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8034fb:	0f 85 10 fd ff ff    	jne    803211 <insert_sorted_with_merge_freeList+0x152>
		}
	}

	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  803501:	eb 00                	jmp    803503 <insert_sorted_with_merge_freeList+0x444>
  803503:	90                   	nop
  803504:	c9                   	leave  
  803505:	c3                   	ret    
  803506:	66 90                	xchg   %ax,%ax

00803508 <__udivdi3>:
  803508:	55                   	push   %ebp
  803509:	57                   	push   %edi
  80350a:	56                   	push   %esi
  80350b:	53                   	push   %ebx
  80350c:	83 ec 1c             	sub    $0x1c,%esp
  80350f:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  803513:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  803517:	8b 7c 24 38          	mov    0x38(%esp),%edi
  80351b:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  80351f:	89 ca                	mov    %ecx,%edx
  803521:	89 f8                	mov    %edi,%eax
  803523:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  803527:	85 f6                	test   %esi,%esi
  803529:	75 2d                	jne    803558 <__udivdi3+0x50>
  80352b:	39 cf                	cmp    %ecx,%edi
  80352d:	77 65                	ja     803594 <__udivdi3+0x8c>
  80352f:	89 fd                	mov    %edi,%ebp
  803531:	85 ff                	test   %edi,%edi
  803533:	75 0b                	jne    803540 <__udivdi3+0x38>
  803535:	b8 01 00 00 00       	mov    $0x1,%eax
  80353a:	31 d2                	xor    %edx,%edx
  80353c:	f7 f7                	div    %edi
  80353e:	89 c5                	mov    %eax,%ebp
  803540:	31 d2                	xor    %edx,%edx
  803542:	89 c8                	mov    %ecx,%eax
  803544:	f7 f5                	div    %ebp
  803546:	89 c1                	mov    %eax,%ecx
  803548:	89 d8                	mov    %ebx,%eax
  80354a:	f7 f5                	div    %ebp
  80354c:	89 cf                	mov    %ecx,%edi
  80354e:	89 fa                	mov    %edi,%edx
  803550:	83 c4 1c             	add    $0x1c,%esp
  803553:	5b                   	pop    %ebx
  803554:	5e                   	pop    %esi
  803555:	5f                   	pop    %edi
  803556:	5d                   	pop    %ebp
  803557:	c3                   	ret    
  803558:	39 ce                	cmp    %ecx,%esi
  80355a:	77 28                	ja     803584 <__udivdi3+0x7c>
  80355c:	0f bd fe             	bsr    %esi,%edi
  80355f:	83 f7 1f             	xor    $0x1f,%edi
  803562:	75 40                	jne    8035a4 <__udivdi3+0x9c>
  803564:	39 ce                	cmp    %ecx,%esi
  803566:	72 0a                	jb     803572 <__udivdi3+0x6a>
  803568:	3b 44 24 08          	cmp    0x8(%esp),%eax
  80356c:	0f 87 9e 00 00 00    	ja     803610 <__udivdi3+0x108>
  803572:	b8 01 00 00 00       	mov    $0x1,%eax
  803577:	89 fa                	mov    %edi,%edx
  803579:	83 c4 1c             	add    $0x1c,%esp
  80357c:	5b                   	pop    %ebx
  80357d:	5e                   	pop    %esi
  80357e:	5f                   	pop    %edi
  80357f:	5d                   	pop    %ebp
  803580:	c3                   	ret    
  803581:	8d 76 00             	lea    0x0(%esi),%esi
  803584:	31 ff                	xor    %edi,%edi
  803586:	31 c0                	xor    %eax,%eax
  803588:	89 fa                	mov    %edi,%edx
  80358a:	83 c4 1c             	add    $0x1c,%esp
  80358d:	5b                   	pop    %ebx
  80358e:	5e                   	pop    %esi
  80358f:	5f                   	pop    %edi
  803590:	5d                   	pop    %ebp
  803591:	c3                   	ret    
  803592:	66 90                	xchg   %ax,%ax
  803594:	89 d8                	mov    %ebx,%eax
  803596:	f7 f7                	div    %edi
  803598:	31 ff                	xor    %edi,%edi
  80359a:	89 fa                	mov    %edi,%edx
  80359c:	83 c4 1c             	add    $0x1c,%esp
  80359f:	5b                   	pop    %ebx
  8035a0:	5e                   	pop    %esi
  8035a1:	5f                   	pop    %edi
  8035a2:	5d                   	pop    %ebp
  8035a3:	c3                   	ret    
  8035a4:	bd 20 00 00 00       	mov    $0x20,%ebp
  8035a9:	89 eb                	mov    %ebp,%ebx
  8035ab:	29 fb                	sub    %edi,%ebx
  8035ad:	89 f9                	mov    %edi,%ecx
  8035af:	d3 e6                	shl    %cl,%esi
  8035b1:	89 c5                	mov    %eax,%ebp
  8035b3:	88 d9                	mov    %bl,%cl
  8035b5:	d3 ed                	shr    %cl,%ebp
  8035b7:	89 e9                	mov    %ebp,%ecx
  8035b9:	09 f1                	or     %esi,%ecx
  8035bb:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  8035bf:	89 f9                	mov    %edi,%ecx
  8035c1:	d3 e0                	shl    %cl,%eax
  8035c3:	89 c5                	mov    %eax,%ebp
  8035c5:	89 d6                	mov    %edx,%esi
  8035c7:	88 d9                	mov    %bl,%cl
  8035c9:	d3 ee                	shr    %cl,%esi
  8035cb:	89 f9                	mov    %edi,%ecx
  8035cd:	d3 e2                	shl    %cl,%edx
  8035cf:	8b 44 24 08          	mov    0x8(%esp),%eax
  8035d3:	88 d9                	mov    %bl,%cl
  8035d5:	d3 e8                	shr    %cl,%eax
  8035d7:	09 c2                	or     %eax,%edx
  8035d9:	89 d0                	mov    %edx,%eax
  8035db:	89 f2                	mov    %esi,%edx
  8035dd:	f7 74 24 0c          	divl   0xc(%esp)
  8035e1:	89 d6                	mov    %edx,%esi
  8035e3:	89 c3                	mov    %eax,%ebx
  8035e5:	f7 e5                	mul    %ebp
  8035e7:	39 d6                	cmp    %edx,%esi
  8035e9:	72 19                	jb     803604 <__udivdi3+0xfc>
  8035eb:	74 0b                	je     8035f8 <__udivdi3+0xf0>
  8035ed:	89 d8                	mov    %ebx,%eax
  8035ef:	31 ff                	xor    %edi,%edi
  8035f1:	e9 58 ff ff ff       	jmp    80354e <__udivdi3+0x46>
  8035f6:	66 90                	xchg   %ax,%ax
  8035f8:	8b 54 24 08          	mov    0x8(%esp),%edx
  8035fc:	89 f9                	mov    %edi,%ecx
  8035fe:	d3 e2                	shl    %cl,%edx
  803600:	39 c2                	cmp    %eax,%edx
  803602:	73 e9                	jae    8035ed <__udivdi3+0xe5>
  803604:	8d 43 ff             	lea    -0x1(%ebx),%eax
  803607:	31 ff                	xor    %edi,%edi
  803609:	e9 40 ff ff ff       	jmp    80354e <__udivdi3+0x46>
  80360e:	66 90                	xchg   %ax,%ax
  803610:	31 c0                	xor    %eax,%eax
  803612:	e9 37 ff ff ff       	jmp    80354e <__udivdi3+0x46>
  803617:	90                   	nop

00803618 <__umoddi3>:
  803618:	55                   	push   %ebp
  803619:	57                   	push   %edi
  80361a:	56                   	push   %esi
  80361b:	53                   	push   %ebx
  80361c:	83 ec 1c             	sub    $0x1c,%esp
  80361f:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  803623:	8b 74 24 34          	mov    0x34(%esp),%esi
  803627:	8b 7c 24 38          	mov    0x38(%esp),%edi
  80362b:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  80362f:	89 44 24 0c          	mov    %eax,0xc(%esp)
  803633:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  803637:	89 f3                	mov    %esi,%ebx
  803639:	89 fa                	mov    %edi,%edx
  80363b:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  80363f:	89 34 24             	mov    %esi,(%esp)
  803642:	85 c0                	test   %eax,%eax
  803644:	75 1a                	jne    803660 <__umoddi3+0x48>
  803646:	39 f7                	cmp    %esi,%edi
  803648:	0f 86 a2 00 00 00    	jbe    8036f0 <__umoddi3+0xd8>
  80364e:	89 c8                	mov    %ecx,%eax
  803650:	89 f2                	mov    %esi,%edx
  803652:	f7 f7                	div    %edi
  803654:	89 d0                	mov    %edx,%eax
  803656:	31 d2                	xor    %edx,%edx
  803658:	83 c4 1c             	add    $0x1c,%esp
  80365b:	5b                   	pop    %ebx
  80365c:	5e                   	pop    %esi
  80365d:	5f                   	pop    %edi
  80365e:	5d                   	pop    %ebp
  80365f:	c3                   	ret    
  803660:	39 f0                	cmp    %esi,%eax
  803662:	0f 87 ac 00 00 00    	ja     803714 <__umoddi3+0xfc>
  803668:	0f bd e8             	bsr    %eax,%ebp
  80366b:	83 f5 1f             	xor    $0x1f,%ebp
  80366e:	0f 84 ac 00 00 00    	je     803720 <__umoddi3+0x108>
  803674:	bf 20 00 00 00       	mov    $0x20,%edi
  803679:	29 ef                	sub    %ebp,%edi
  80367b:	89 fe                	mov    %edi,%esi
  80367d:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  803681:	89 e9                	mov    %ebp,%ecx
  803683:	d3 e0                	shl    %cl,%eax
  803685:	89 d7                	mov    %edx,%edi
  803687:	89 f1                	mov    %esi,%ecx
  803689:	d3 ef                	shr    %cl,%edi
  80368b:	09 c7                	or     %eax,%edi
  80368d:	89 e9                	mov    %ebp,%ecx
  80368f:	d3 e2                	shl    %cl,%edx
  803691:	89 14 24             	mov    %edx,(%esp)
  803694:	89 d8                	mov    %ebx,%eax
  803696:	d3 e0                	shl    %cl,%eax
  803698:	89 c2                	mov    %eax,%edx
  80369a:	8b 44 24 08          	mov    0x8(%esp),%eax
  80369e:	d3 e0                	shl    %cl,%eax
  8036a0:	89 44 24 04          	mov    %eax,0x4(%esp)
  8036a4:	8b 44 24 08          	mov    0x8(%esp),%eax
  8036a8:	89 f1                	mov    %esi,%ecx
  8036aa:	d3 e8                	shr    %cl,%eax
  8036ac:	09 d0                	or     %edx,%eax
  8036ae:	d3 eb                	shr    %cl,%ebx
  8036b0:	89 da                	mov    %ebx,%edx
  8036b2:	f7 f7                	div    %edi
  8036b4:	89 d3                	mov    %edx,%ebx
  8036b6:	f7 24 24             	mull   (%esp)
  8036b9:	89 c6                	mov    %eax,%esi
  8036bb:	89 d1                	mov    %edx,%ecx
  8036bd:	39 d3                	cmp    %edx,%ebx
  8036bf:	0f 82 87 00 00 00    	jb     80374c <__umoddi3+0x134>
  8036c5:	0f 84 91 00 00 00    	je     80375c <__umoddi3+0x144>
  8036cb:	8b 54 24 04          	mov    0x4(%esp),%edx
  8036cf:	29 f2                	sub    %esi,%edx
  8036d1:	19 cb                	sbb    %ecx,%ebx
  8036d3:	89 d8                	mov    %ebx,%eax
  8036d5:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  8036d9:	d3 e0                	shl    %cl,%eax
  8036db:	89 e9                	mov    %ebp,%ecx
  8036dd:	d3 ea                	shr    %cl,%edx
  8036df:	09 d0                	or     %edx,%eax
  8036e1:	89 e9                	mov    %ebp,%ecx
  8036e3:	d3 eb                	shr    %cl,%ebx
  8036e5:	89 da                	mov    %ebx,%edx
  8036e7:	83 c4 1c             	add    $0x1c,%esp
  8036ea:	5b                   	pop    %ebx
  8036eb:	5e                   	pop    %esi
  8036ec:	5f                   	pop    %edi
  8036ed:	5d                   	pop    %ebp
  8036ee:	c3                   	ret    
  8036ef:	90                   	nop
  8036f0:	89 fd                	mov    %edi,%ebp
  8036f2:	85 ff                	test   %edi,%edi
  8036f4:	75 0b                	jne    803701 <__umoddi3+0xe9>
  8036f6:	b8 01 00 00 00       	mov    $0x1,%eax
  8036fb:	31 d2                	xor    %edx,%edx
  8036fd:	f7 f7                	div    %edi
  8036ff:	89 c5                	mov    %eax,%ebp
  803701:	89 f0                	mov    %esi,%eax
  803703:	31 d2                	xor    %edx,%edx
  803705:	f7 f5                	div    %ebp
  803707:	89 c8                	mov    %ecx,%eax
  803709:	f7 f5                	div    %ebp
  80370b:	89 d0                	mov    %edx,%eax
  80370d:	e9 44 ff ff ff       	jmp    803656 <__umoddi3+0x3e>
  803712:	66 90                	xchg   %ax,%ax
  803714:	89 c8                	mov    %ecx,%eax
  803716:	89 f2                	mov    %esi,%edx
  803718:	83 c4 1c             	add    $0x1c,%esp
  80371b:	5b                   	pop    %ebx
  80371c:	5e                   	pop    %esi
  80371d:	5f                   	pop    %edi
  80371e:	5d                   	pop    %ebp
  80371f:	c3                   	ret    
  803720:	3b 04 24             	cmp    (%esp),%eax
  803723:	72 06                	jb     80372b <__umoddi3+0x113>
  803725:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  803729:	77 0f                	ja     80373a <__umoddi3+0x122>
  80372b:	89 f2                	mov    %esi,%edx
  80372d:	29 f9                	sub    %edi,%ecx
  80372f:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  803733:	89 14 24             	mov    %edx,(%esp)
  803736:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  80373a:	8b 44 24 04          	mov    0x4(%esp),%eax
  80373e:	8b 14 24             	mov    (%esp),%edx
  803741:	83 c4 1c             	add    $0x1c,%esp
  803744:	5b                   	pop    %ebx
  803745:	5e                   	pop    %esi
  803746:	5f                   	pop    %edi
  803747:	5d                   	pop    %ebp
  803748:	c3                   	ret    
  803749:	8d 76 00             	lea    0x0(%esi),%esi
  80374c:	2b 04 24             	sub    (%esp),%eax
  80374f:	19 fa                	sbb    %edi,%edx
  803751:	89 d1                	mov    %edx,%ecx
  803753:	89 c6                	mov    %eax,%esi
  803755:	e9 71 ff ff ff       	jmp    8036cb <__umoddi3+0xb3>
  80375a:	66 90                	xchg   %ax,%ax
  80375c:	39 44 24 04          	cmp    %eax,0x4(%esp)
  803760:	72 ea                	jb     80374c <__umoddi3+0x134>
  803762:	89 d9                	mov    %ebx,%ecx
  803764:	e9 62 ff ff ff       	jmp    8036cb <__umoddi3+0xb3>
