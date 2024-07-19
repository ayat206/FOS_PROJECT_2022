
obj/user/mergesort_noleakage:     file format elf32-i386


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
  800031:	e8 8f 07 00 00       	call   8007c5 <libmain>
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
  800041:	e8 00 22 00 00       	call   802246 <sys_disable_interrupt>

		cprintf("\n");
  800046:	83 ec 0c             	sub    $0xc,%esp
  800049:	68 60 39 80 00       	push   $0x803960
  80004e:	e8 62 0b 00 00       	call   800bb5 <cprintf>
  800053:	83 c4 10             	add    $0x10,%esp
		cprintf("!!!!!!!!!!!!!!!!!!!!\n");
  800056:	83 ec 0c             	sub    $0xc,%esp
  800059:	68 62 39 80 00       	push   $0x803962
  80005e:	e8 52 0b 00 00       	call   800bb5 <cprintf>
  800063:	83 c4 10             	add    $0x10,%esp
		cprintf("!!!! MERGE SORT !!!!\n");
  800066:	83 ec 0c             	sub    $0xc,%esp
  800069:	68 78 39 80 00       	push   $0x803978
  80006e:	e8 42 0b 00 00       	call   800bb5 <cprintf>
  800073:	83 c4 10             	add    $0x10,%esp
		cprintf("!!!!!!!!!!!!!!!!!!!!\n");
  800076:	83 ec 0c             	sub    $0xc,%esp
  800079:	68 62 39 80 00       	push   $0x803962
  80007e:	e8 32 0b 00 00       	call   800bb5 <cprintf>
  800083:	83 c4 10             	add    $0x10,%esp
		cprintf("\n");
  800086:	83 ec 0c             	sub    $0xc,%esp
  800089:	68 60 39 80 00       	push   $0x803960
  80008e:	e8 22 0b 00 00       	call   800bb5 <cprintf>
  800093:	83 c4 10             	add    $0x10,%esp
		readline("Enter the number of elements: ", Line);
  800096:	83 ec 08             	sub    $0x8,%esp
  800099:	8d 85 e9 fe ff ff    	lea    -0x117(%ebp),%eax
  80009f:	50                   	push   %eax
  8000a0:	68 90 39 80 00       	push   $0x803990
  8000a5:	e8 8d 11 00 00       	call   801237 <readline>
  8000aa:	83 c4 10             	add    $0x10,%esp
		int NumOfElements = strtol(Line, NULL, 10) ;
  8000ad:	83 ec 04             	sub    $0x4,%esp
  8000b0:	6a 0a                	push   $0xa
  8000b2:	6a 00                	push   $0x0
  8000b4:	8d 85 e9 fe ff ff    	lea    -0x117(%ebp),%eax
  8000ba:	50                   	push   %eax
  8000bb:	e8 dd 16 00 00       	call   80179d <strtol>
  8000c0:	83 c4 10             	add    $0x10,%esp
  8000c3:	89 45 f0             	mov    %eax,-0x10(%ebp)
		int *Elements = malloc(sizeof(int) * NumOfElements) ;
  8000c6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8000c9:	c1 e0 02             	shl    $0x2,%eax
  8000cc:	83 ec 0c             	sub    $0xc,%esp
  8000cf:	50                   	push   %eax
  8000d0:	e8 78 1c 00 00       	call   801d4d <malloc>
  8000d5:	83 c4 10             	add    $0x10,%esp
  8000d8:	89 45 ec             	mov    %eax,-0x14(%ebp)
		cprintf("Chose the initialization method:\n") ;
  8000db:	83 ec 0c             	sub    $0xc,%esp
  8000de:	68 b0 39 80 00       	push   $0x8039b0
  8000e3:	e8 cd 0a 00 00       	call   800bb5 <cprintf>
  8000e8:	83 c4 10             	add    $0x10,%esp
		cprintf("a) Ascending\n") ;
  8000eb:	83 ec 0c             	sub    $0xc,%esp
  8000ee:	68 d2 39 80 00       	push   $0x8039d2
  8000f3:	e8 bd 0a 00 00       	call   800bb5 <cprintf>
  8000f8:	83 c4 10             	add    $0x10,%esp
		cprintf("b) Descending\n") ;
  8000fb:	83 ec 0c             	sub    $0xc,%esp
  8000fe:	68 e0 39 80 00       	push   $0x8039e0
  800103:	e8 ad 0a 00 00       	call   800bb5 <cprintf>
  800108:	83 c4 10             	add    $0x10,%esp
		cprintf("c) Semi random\n");
  80010b:	83 ec 0c             	sub    $0xc,%esp
  80010e:	68 ef 39 80 00       	push   $0x8039ef
  800113:	e8 9d 0a 00 00       	call   800bb5 <cprintf>
  800118:	83 c4 10             	add    $0x10,%esp
		do
		{
			cprintf("Select: ") ;
  80011b:	83 ec 0c             	sub    $0xc,%esp
  80011e:	68 ff 39 80 00       	push   $0x8039ff
  800123:	e8 8d 0a 00 00       	call   800bb5 <cprintf>
  800128:	83 c4 10             	add    $0x10,%esp
			Chose = getchar() ;
  80012b:	e8 3d 06 00 00       	call   80076d <getchar>
  800130:	88 45 f7             	mov    %al,-0x9(%ebp)
			cputchar(Chose);
  800133:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
  800137:	83 ec 0c             	sub    $0xc,%esp
  80013a:	50                   	push   %eax
  80013b:	e8 e5 05 00 00       	call   800725 <cputchar>
  800140:	83 c4 10             	add    $0x10,%esp
			cputchar('\n');
  800143:	83 ec 0c             	sub    $0xc,%esp
  800146:	6a 0a                	push   $0xa
  800148:	e8 d8 05 00 00       	call   800725 <cputchar>
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
  800162:	e8 f9 20 00 00       	call   802260 <sys_enable_interrupt>

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
  800183:	e8 f4 01 00 00       	call   80037c <InitializeAscending>
  800188:	83 c4 10             	add    $0x10,%esp
			break ;
  80018b:	eb 37                	jmp    8001c4 <_main+0x18c>
		case 'b':
			InitializeDescending(Elements, NumOfElements);
  80018d:	83 ec 08             	sub    $0x8,%esp
  800190:	ff 75 f0             	pushl  -0x10(%ebp)
  800193:	ff 75 ec             	pushl  -0x14(%ebp)
  800196:	e8 12 02 00 00       	call   8003ad <InitializeDescending>
  80019b:	83 c4 10             	add    $0x10,%esp
			break ;
  80019e:	eb 24                	jmp    8001c4 <_main+0x18c>
		case 'c':
			InitializeSemiRandom(Elements, NumOfElements);
  8001a0:	83 ec 08             	sub    $0x8,%esp
  8001a3:	ff 75 f0             	pushl  -0x10(%ebp)
  8001a6:	ff 75 ec             	pushl  -0x14(%ebp)
  8001a9:	e8 34 02 00 00       	call   8003e2 <InitializeSemiRandom>
  8001ae:	83 c4 10             	add    $0x10,%esp
			break ;
  8001b1:	eb 11                	jmp    8001c4 <_main+0x18c>
		default:
			InitializeSemiRandom(Elements, NumOfElements);
  8001b3:	83 ec 08             	sub    $0x8,%esp
  8001b6:	ff 75 f0             	pushl  -0x10(%ebp)
  8001b9:	ff 75 ec             	pushl  -0x14(%ebp)
  8001bc:	e8 21 02 00 00       	call   8003e2 <InitializeSemiRandom>
  8001c1:	83 c4 10             	add    $0x10,%esp
		}

		MSort(Elements, 1, NumOfElements);
  8001c4:	83 ec 04             	sub    $0x4,%esp
  8001c7:	ff 75 f0             	pushl  -0x10(%ebp)
  8001ca:	6a 01                	push   $0x1
  8001cc:	ff 75 ec             	pushl  -0x14(%ebp)
  8001cf:	e8 e0 02 00 00       	call   8004b4 <MSort>
  8001d4:	83 c4 10             	add    $0x10,%esp

		sys_disable_interrupt();
  8001d7:	e8 6a 20 00 00       	call   802246 <sys_disable_interrupt>
		cprintf("Sorting is Finished!!!!it'll be checked now....\n") ;
  8001dc:	83 ec 0c             	sub    $0xc,%esp
  8001df:	68 08 3a 80 00       	push   $0x803a08
  8001e4:	e8 cc 09 00 00       	call   800bb5 <cprintf>
  8001e9:	83 c4 10             	add    $0x10,%esp
		//PrintElements(Elements, NumOfElements);
		sys_enable_interrupt();
  8001ec:	e8 6f 20 00 00       	call   802260 <sys_enable_interrupt>

		uint32 Sorted = CheckSorted(Elements, NumOfElements);
  8001f1:	83 ec 08             	sub    $0x8,%esp
  8001f4:	ff 75 f0             	pushl  -0x10(%ebp)
  8001f7:	ff 75 ec             	pushl  -0x14(%ebp)
  8001fa:	e8 d3 00 00 00       	call   8002d2 <CheckSorted>
  8001ff:	83 c4 10             	add    $0x10,%esp
  800202:	89 45 e8             	mov    %eax,-0x18(%ebp)

		if(Sorted == 0) panic("The array is NOT sorted correctly") ;
  800205:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  800209:	75 14                	jne    80021f <_main+0x1e7>
  80020b:	83 ec 04             	sub    $0x4,%esp
  80020e:	68 3c 3a 80 00       	push   $0x803a3c
  800213:	6a 4a                	push   $0x4a
  800215:	68 5e 3a 80 00       	push   $0x803a5e
  80021a:	e8 e2 06 00 00       	call   800901 <_panic>
		else
		{
			sys_disable_interrupt();
  80021f:	e8 22 20 00 00       	call   802246 <sys_disable_interrupt>
			cprintf("===============================================\n") ;
  800224:	83 ec 0c             	sub    $0xc,%esp
  800227:	68 7c 3a 80 00       	push   $0x803a7c
  80022c:	e8 84 09 00 00       	call   800bb5 <cprintf>
  800231:	83 c4 10             	add    $0x10,%esp
			cprintf("Congratulations!! The array is sorted correctly\n") ;
  800234:	83 ec 0c             	sub    $0xc,%esp
  800237:	68 b0 3a 80 00       	push   $0x803ab0
  80023c:	e8 74 09 00 00       	call   800bb5 <cprintf>
  800241:	83 c4 10             	add    $0x10,%esp
			cprintf("===============================================\n\n") ;
  800244:	83 ec 0c             	sub    $0xc,%esp
  800247:	68 e4 3a 80 00       	push   $0x803ae4
  80024c:	e8 64 09 00 00       	call   800bb5 <cprintf>
  800251:	83 c4 10             	add    $0x10,%esp
			sys_enable_interrupt();
  800254:	e8 07 20 00 00       	call   802260 <sys_enable_interrupt>
		}

		free(Elements) ;
  800259:	83 ec 0c             	sub    $0xc,%esp
  80025c:	ff 75 ec             	pushl  -0x14(%ebp)
  80025f:	e8 6a 1b 00 00       	call   801dce <free>
  800264:	83 c4 10             	add    $0x10,%esp

		sys_disable_interrupt();
  800267:	e8 da 1f 00 00       	call   802246 <sys_disable_interrupt>
			Chose = 0 ;
  80026c:	c6 45 f7 00          	movb   $0x0,-0x9(%ebp)
			while (Chose != 'y' && Chose != 'n')
  800270:	eb 42                	jmp    8002b4 <_main+0x27c>
			{
				cprintf("Do you want to repeat (y/n): ") ;
  800272:	83 ec 0c             	sub    $0xc,%esp
  800275:	68 16 3b 80 00       	push   $0x803b16
  80027a:	e8 36 09 00 00       	call   800bb5 <cprintf>
  80027f:	83 c4 10             	add    $0x10,%esp
				Chose = getchar() ;
  800282:	e8 e6 04 00 00       	call   80076d <getchar>
  800287:	88 45 f7             	mov    %al,-0x9(%ebp)
				cputchar(Chose);
  80028a:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
  80028e:	83 ec 0c             	sub    $0xc,%esp
  800291:	50                   	push   %eax
  800292:	e8 8e 04 00 00       	call   800725 <cputchar>
  800297:	83 c4 10             	add    $0x10,%esp
				cputchar('\n');
  80029a:	83 ec 0c             	sub    $0xc,%esp
  80029d:	6a 0a                	push   $0xa
  80029f:	e8 81 04 00 00       	call   800725 <cputchar>
  8002a4:	83 c4 10             	add    $0x10,%esp
				cputchar('\n');
  8002a7:	83 ec 0c             	sub    $0xc,%esp
  8002aa:	6a 0a                	push   $0xa
  8002ac:	e8 74 04 00 00       	call   800725 <cputchar>
  8002b1:	83 c4 10             	add    $0x10,%esp

		free(Elements) ;

		sys_disable_interrupt();
			Chose = 0 ;
			while (Chose != 'y' && Chose != 'n')
  8002b4:	80 7d f7 79          	cmpb   $0x79,-0x9(%ebp)
  8002b8:	74 06                	je     8002c0 <_main+0x288>
  8002ba:	80 7d f7 6e          	cmpb   $0x6e,-0x9(%ebp)
  8002be:	75 b2                	jne    800272 <_main+0x23a>
				Chose = getchar() ;
				cputchar(Chose);
				cputchar('\n');
				cputchar('\n');
			}
		sys_enable_interrupt();
  8002c0:	e8 9b 1f 00 00       	call   802260 <sys_enable_interrupt>

	} while (Chose == 'y');
  8002c5:	80 7d f7 79          	cmpb   $0x79,-0x9(%ebp)
  8002c9:	0f 84 72 fd ff ff    	je     800041 <_main+0x9>

}
  8002cf:	90                   	nop
  8002d0:	c9                   	leave  
  8002d1:	c3                   	ret    

008002d2 <CheckSorted>:


uint32 CheckSorted(int *Elements, int NumOfElements)
{
  8002d2:	55                   	push   %ebp
  8002d3:	89 e5                	mov    %esp,%ebp
  8002d5:	83 ec 10             	sub    $0x10,%esp
	uint32 Sorted = 1 ;
  8002d8:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
	int i ;
	for (i = 0 ; i < NumOfElements - 1; i++)
  8002df:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  8002e6:	eb 33                	jmp    80031b <CheckSorted+0x49>
	{
		if (Elements[i] > Elements[i+1])
  8002e8:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8002eb:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8002f2:	8b 45 08             	mov    0x8(%ebp),%eax
  8002f5:	01 d0                	add    %edx,%eax
  8002f7:	8b 10                	mov    (%eax),%edx
  8002f9:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8002fc:	40                   	inc    %eax
  8002fd:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  800304:	8b 45 08             	mov    0x8(%ebp),%eax
  800307:	01 c8                	add    %ecx,%eax
  800309:	8b 00                	mov    (%eax),%eax
  80030b:	39 c2                	cmp    %eax,%edx
  80030d:	7e 09                	jle    800318 <CheckSorted+0x46>
		{
			Sorted = 0 ;
  80030f:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
			break;
  800316:	eb 0c                	jmp    800324 <CheckSorted+0x52>

uint32 CheckSorted(int *Elements, int NumOfElements)
{
	uint32 Sorted = 1 ;
	int i ;
	for (i = 0 ; i < NumOfElements - 1; i++)
  800318:	ff 45 f8             	incl   -0x8(%ebp)
  80031b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80031e:	48                   	dec    %eax
  80031f:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800322:	7f c4                	jg     8002e8 <CheckSorted+0x16>
		{
			Sorted = 0 ;
			break;
		}
	}
	return Sorted ;
  800324:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800327:	c9                   	leave  
  800328:	c3                   	ret    

00800329 <Swap>:

///Private Functions


void Swap(int *Elements, int First, int Second)
{
  800329:	55                   	push   %ebp
  80032a:	89 e5                	mov    %esp,%ebp
  80032c:	83 ec 10             	sub    $0x10,%esp
	int Tmp = Elements[First] ;
  80032f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800332:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800339:	8b 45 08             	mov    0x8(%ebp),%eax
  80033c:	01 d0                	add    %edx,%eax
  80033e:	8b 00                	mov    (%eax),%eax
  800340:	89 45 fc             	mov    %eax,-0x4(%ebp)
	Elements[First] = Elements[Second] ;
  800343:	8b 45 0c             	mov    0xc(%ebp),%eax
  800346:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80034d:	8b 45 08             	mov    0x8(%ebp),%eax
  800350:	01 c2                	add    %eax,%edx
  800352:	8b 45 10             	mov    0x10(%ebp),%eax
  800355:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  80035c:	8b 45 08             	mov    0x8(%ebp),%eax
  80035f:	01 c8                	add    %ecx,%eax
  800361:	8b 00                	mov    (%eax),%eax
  800363:	89 02                	mov    %eax,(%edx)
	Elements[Second] = Tmp ;
  800365:	8b 45 10             	mov    0x10(%ebp),%eax
  800368:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80036f:	8b 45 08             	mov    0x8(%ebp),%eax
  800372:	01 c2                	add    %eax,%edx
  800374:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800377:	89 02                	mov    %eax,(%edx)
}
  800379:	90                   	nop
  80037a:	c9                   	leave  
  80037b:	c3                   	ret    

0080037c <InitializeAscending>:

void InitializeAscending(int *Elements, int NumOfElements)
{
  80037c:	55                   	push   %ebp
  80037d:	89 e5                	mov    %esp,%ebp
  80037f:	83 ec 10             	sub    $0x10,%esp
	int i ;
	for (i = 0 ; i < NumOfElements ; i++)
  800382:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800389:	eb 17                	jmp    8003a2 <InitializeAscending+0x26>
	{
		(Elements)[i] = i ;
  80038b:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80038e:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800395:	8b 45 08             	mov    0x8(%ebp),%eax
  800398:	01 c2                	add    %eax,%edx
  80039a:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80039d:	89 02                	mov    %eax,(%edx)
}

void InitializeAscending(int *Elements, int NumOfElements)
{
	int i ;
	for (i = 0 ; i < NumOfElements ; i++)
  80039f:	ff 45 fc             	incl   -0x4(%ebp)
  8003a2:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8003a5:	3b 45 0c             	cmp    0xc(%ebp),%eax
  8003a8:	7c e1                	jl     80038b <InitializeAscending+0xf>
	{
		(Elements)[i] = i ;
	}

}
  8003aa:	90                   	nop
  8003ab:	c9                   	leave  
  8003ac:	c3                   	ret    

008003ad <InitializeDescending>:

void InitializeDescending(int *Elements, int NumOfElements)
{
  8003ad:	55                   	push   %ebp
  8003ae:	89 e5                	mov    %esp,%ebp
  8003b0:	83 ec 10             	sub    $0x10,%esp
	int i ;
	for (i = 0 ; i < NumOfElements ; i++)
  8003b3:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8003ba:	eb 1b                	jmp    8003d7 <InitializeDescending+0x2a>
	{
		Elements[i] = NumOfElements - i - 1 ;
  8003bc:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8003bf:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8003c6:	8b 45 08             	mov    0x8(%ebp),%eax
  8003c9:	01 c2                	add    %eax,%edx
  8003cb:	8b 45 0c             	mov    0xc(%ebp),%eax
  8003ce:	2b 45 fc             	sub    -0x4(%ebp),%eax
  8003d1:	48                   	dec    %eax
  8003d2:	89 02                	mov    %eax,(%edx)
}

void InitializeDescending(int *Elements, int NumOfElements)
{
	int i ;
	for (i = 0 ; i < NumOfElements ; i++)
  8003d4:	ff 45 fc             	incl   -0x4(%ebp)
  8003d7:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8003da:	3b 45 0c             	cmp    0xc(%ebp),%eax
  8003dd:	7c dd                	jl     8003bc <InitializeDescending+0xf>
	{
		Elements[i] = NumOfElements - i - 1 ;
	}

}
  8003df:	90                   	nop
  8003e0:	c9                   	leave  
  8003e1:	c3                   	ret    

008003e2 <InitializeSemiRandom>:

void InitializeSemiRandom(int *Elements, int NumOfElements)
{
  8003e2:	55                   	push   %ebp
  8003e3:	89 e5                	mov    %esp,%ebp
  8003e5:	83 ec 10             	sub    $0x10,%esp
	int i ;
	int Repetition = NumOfElements / 3 ;
  8003e8:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8003eb:	b8 56 55 55 55       	mov    $0x55555556,%eax
  8003f0:	f7 e9                	imul   %ecx
  8003f2:	c1 f9 1f             	sar    $0x1f,%ecx
  8003f5:	89 d0                	mov    %edx,%eax
  8003f7:	29 c8                	sub    %ecx,%eax
  8003f9:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0 ; i < NumOfElements ; i++)
  8003fc:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800403:	eb 1e                	jmp    800423 <InitializeSemiRandom+0x41>
	{
		Elements[i] = i % Repetition ;
  800405:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800408:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80040f:	8b 45 08             	mov    0x8(%ebp),%eax
  800412:	8d 0c 02             	lea    (%edx,%eax,1),%ecx
  800415:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800418:	99                   	cltd   
  800419:	f7 7d f8             	idivl  -0x8(%ebp)
  80041c:	89 d0                	mov    %edx,%eax
  80041e:	89 01                	mov    %eax,(%ecx)

void InitializeSemiRandom(int *Elements, int NumOfElements)
{
	int i ;
	int Repetition = NumOfElements / 3 ;
	for (i = 0 ; i < NumOfElements ; i++)
  800420:	ff 45 fc             	incl   -0x4(%ebp)
  800423:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800426:	3b 45 0c             	cmp    0xc(%ebp),%eax
  800429:	7c da                	jl     800405 <InitializeSemiRandom+0x23>
	{
		Elements[i] = i % Repetition ;
			//cprintf("i=%d\n",i);
	}

}
  80042b:	90                   	nop
  80042c:	c9                   	leave  
  80042d:	c3                   	ret    

0080042e <PrintElements>:

void PrintElements(int *Elements, int NumOfElements)
{
  80042e:	55                   	push   %ebp
  80042f:	89 e5                	mov    %esp,%ebp
  800431:	83 ec 18             	sub    $0x18,%esp
	int i ;
	int NumsPerLine = 20 ;
  800434:	c7 45 f0 14 00 00 00 	movl   $0x14,-0x10(%ebp)
	for (i = 0 ; i < NumOfElements-1 ; i++)
  80043b:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  800442:	eb 42                	jmp    800486 <PrintElements+0x58>
	{
		if (i%NumsPerLine == 0)
  800444:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800447:	99                   	cltd   
  800448:	f7 7d f0             	idivl  -0x10(%ebp)
  80044b:	89 d0                	mov    %edx,%eax
  80044d:	85 c0                	test   %eax,%eax
  80044f:	75 10                	jne    800461 <PrintElements+0x33>
			cprintf("\n");
  800451:	83 ec 0c             	sub    $0xc,%esp
  800454:	68 60 39 80 00       	push   $0x803960
  800459:	e8 57 07 00 00       	call   800bb5 <cprintf>
  80045e:	83 c4 10             	add    $0x10,%esp
		cprintf("%d, ",Elements[i]);
  800461:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800464:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80046b:	8b 45 08             	mov    0x8(%ebp),%eax
  80046e:	01 d0                	add    %edx,%eax
  800470:	8b 00                	mov    (%eax),%eax
  800472:	83 ec 08             	sub    $0x8,%esp
  800475:	50                   	push   %eax
  800476:	68 34 3b 80 00       	push   $0x803b34
  80047b:	e8 35 07 00 00       	call   800bb5 <cprintf>
  800480:	83 c4 10             	add    $0x10,%esp

void PrintElements(int *Elements, int NumOfElements)
{
	int i ;
	int NumsPerLine = 20 ;
	for (i = 0 ; i < NumOfElements-1 ; i++)
  800483:	ff 45 f4             	incl   -0xc(%ebp)
  800486:	8b 45 0c             	mov    0xc(%ebp),%eax
  800489:	48                   	dec    %eax
  80048a:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  80048d:	7f b5                	jg     800444 <PrintElements+0x16>
	{
		if (i%NumsPerLine == 0)
			cprintf("\n");
		cprintf("%d, ",Elements[i]);
	}
	cprintf("%d\n",Elements[i]);
  80048f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800492:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800499:	8b 45 08             	mov    0x8(%ebp),%eax
  80049c:	01 d0                	add    %edx,%eax
  80049e:	8b 00                	mov    (%eax),%eax
  8004a0:	83 ec 08             	sub    $0x8,%esp
  8004a3:	50                   	push   %eax
  8004a4:	68 39 3b 80 00       	push   $0x803b39
  8004a9:	e8 07 07 00 00       	call   800bb5 <cprintf>
  8004ae:	83 c4 10             	add    $0x10,%esp

}
  8004b1:	90                   	nop
  8004b2:	c9                   	leave  
  8004b3:	c3                   	ret    

008004b4 <MSort>:


void MSort(int* A, int p, int r)
{
  8004b4:	55                   	push   %ebp
  8004b5:	89 e5                	mov    %esp,%ebp
  8004b7:	83 ec 18             	sub    $0x18,%esp
	if (p >= r)
  8004ba:	8b 45 0c             	mov    0xc(%ebp),%eax
  8004bd:	3b 45 10             	cmp    0x10(%ebp),%eax
  8004c0:	7d 54                	jge    800516 <MSort+0x62>
	{
		return;
	}

	int q = (p + r) / 2;
  8004c2:	8b 55 0c             	mov    0xc(%ebp),%edx
  8004c5:	8b 45 10             	mov    0x10(%ebp),%eax
  8004c8:	01 d0                	add    %edx,%eax
  8004ca:	89 c2                	mov    %eax,%edx
  8004cc:	c1 ea 1f             	shr    $0x1f,%edx
  8004cf:	01 d0                	add    %edx,%eax
  8004d1:	d1 f8                	sar    %eax
  8004d3:	89 45 f4             	mov    %eax,-0xc(%ebp)

	MSort(A, p, q);
  8004d6:	83 ec 04             	sub    $0x4,%esp
  8004d9:	ff 75 f4             	pushl  -0xc(%ebp)
  8004dc:	ff 75 0c             	pushl  0xc(%ebp)
  8004df:	ff 75 08             	pushl  0x8(%ebp)
  8004e2:	e8 cd ff ff ff       	call   8004b4 <MSort>
  8004e7:	83 c4 10             	add    $0x10,%esp

	MSort(A, q + 1, r);
  8004ea:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8004ed:	40                   	inc    %eax
  8004ee:	83 ec 04             	sub    $0x4,%esp
  8004f1:	ff 75 10             	pushl  0x10(%ebp)
  8004f4:	50                   	push   %eax
  8004f5:	ff 75 08             	pushl  0x8(%ebp)
  8004f8:	e8 b7 ff ff ff       	call   8004b4 <MSort>
  8004fd:	83 c4 10             	add    $0x10,%esp

	Merge(A, p, q, r);
  800500:	ff 75 10             	pushl  0x10(%ebp)
  800503:	ff 75 f4             	pushl  -0xc(%ebp)
  800506:	ff 75 0c             	pushl  0xc(%ebp)
  800509:	ff 75 08             	pushl  0x8(%ebp)
  80050c:	e8 08 00 00 00       	call   800519 <Merge>
  800511:	83 c4 10             	add    $0x10,%esp
  800514:	eb 01                	jmp    800517 <MSort+0x63>

void MSort(int* A, int p, int r)
{
	if (p >= r)
	{
		return;
  800516:	90                   	nop

	MSort(A, q + 1, r);

	Merge(A, p, q, r);

}
  800517:	c9                   	leave  
  800518:	c3                   	ret    

00800519 <Merge>:

void Merge(int* A, int p, int q, int r)
{
  800519:	55                   	push   %ebp
  80051a:	89 e5                	mov    %esp,%ebp
  80051c:	83 ec 38             	sub    $0x38,%esp
	int leftCapacity = q - p + 1;
  80051f:	8b 45 10             	mov    0x10(%ebp),%eax
  800522:	2b 45 0c             	sub    0xc(%ebp),%eax
  800525:	40                   	inc    %eax
  800526:	89 45 e0             	mov    %eax,-0x20(%ebp)

	int rightCapacity = r - q;
  800529:	8b 45 14             	mov    0x14(%ebp),%eax
  80052c:	2b 45 10             	sub    0x10(%ebp),%eax
  80052f:	89 45 dc             	mov    %eax,-0x24(%ebp)

	int leftIndex = 0;
  800532:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	int rightIndex = 0;
  800539:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)

	//cprintf("allocate LEFT\n");
	int* Left = malloc(sizeof(int) * leftCapacity);
  800540:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800543:	c1 e0 02             	shl    $0x2,%eax
  800546:	83 ec 0c             	sub    $0xc,%esp
  800549:	50                   	push   %eax
  80054a:	e8 fe 17 00 00       	call   801d4d <malloc>
  80054f:	83 c4 10             	add    $0x10,%esp
  800552:	89 45 d8             	mov    %eax,-0x28(%ebp)

	//cprintf("allocate RIGHT\n");
	int* Right = malloc(sizeof(int) * rightCapacity);
  800555:	8b 45 dc             	mov    -0x24(%ebp),%eax
  800558:	c1 e0 02             	shl    $0x2,%eax
  80055b:	83 ec 0c             	sub    $0xc,%esp
  80055e:	50                   	push   %eax
  80055f:	e8 e9 17 00 00       	call   801d4d <malloc>
  800564:	83 c4 10             	add    $0x10,%esp
  800567:	89 45 d4             	mov    %eax,-0x2c(%ebp)

	int i, j, k;
	for (i = 0; i < leftCapacity; i++)
  80056a:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  800571:	eb 2f                	jmp    8005a2 <Merge+0x89>
	{
		Left[i] = A[p + i - 1];
  800573:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800576:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80057d:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800580:	01 c2                	add    %eax,%edx
  800582:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800585:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800588:	01 c8                	add    %ecx,%eax
  80058a:	05 ff ff ff 3f       	add    $0x3fffffff,%eax
  80058f:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  800596:	8b 45 08             	mov    0x8(%ebp),%eax
  800599:	01 c8                	add    %ecx,%eax
  80059b:	8b 00                	mov    (%eax),%eax
  80059d:	89 02                	mov    %eax,(%edx)

	//cprintf("allocate RIGHT\n");
	int* Right = malloc(sizeof(int) * rightCapacity);

	int i, j, k;
	for (i = 0; i < leftCapacity; i++)
  80059f:	ff 45 ec             	incl   -0x14(%ebp)
  8005a2:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8005a5:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  8005a8:	7c c9                	jl     800573 <Merge+0x5a>
	{
		Left[i] = A[p + i - 1];
	}
	for (j = 0; j < rightCapacity; j++)
  8005aa:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  8005b1:	eb 2a                	jmp    8005dd <Merge+0xc4>
	{
		Right[j] = A[q + j];
  8005b3:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8005b6:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8005bd:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8005c0:	01 c2                	add    %eax,%edx
  8005c2:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8005c5:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8005c8:	01 c8                	add    %ecx,%eax
  8005ca:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  8005d1:	8b 45 08             	mov    0x8(%ebp),%eax
  8005d4:	01 c8                	add    %ecx,%eax
  8005d6:	8b 00                	mov    (%eax),%eax
  8005d8:	89 02                	mov    %eax,(%edx)
	int i, j, k;
	for (i = 0; i < leftCapacity; i++)
	{
		Left[i] = A[p + i - 1];
	}
	for (j = 0; j < rightCapacity; j++)
  8005da:	ff 45 e8             	incl   -0x18(%ebp)
  8005dd:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8005e0:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  8005e3:	7c ce                	jl     8005b3 <Merge+0x9a>
	{
		Right[j] = A[q + j];
	}

	for ( k = p; k <= r; k++)
  8005e5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8005e8:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8005eb:	e9 0a 01 00 00       	jmp    8006fa <Merge+0x1e1>
	{
		if (leftIndex < leftCapacity && rightIndex < rightCapacity)
  8005f0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8005f3:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  8005f6:	0f 8d 95 00 00 00    	jge    800691 <Merge+0x178>
  8005fc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8005ff:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  800602:	0f 8d 89 00 00 00    	jge    800691 <Merge+0x178>
		{
			if (Left[leftIndex] < Right[rightIndex] )
  800608:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80060b:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800612:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800615:	01 d0                	add    %edx,%eax
  800617:	8b 10                	mov    (%eax),%edx
  800619:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80061c:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  800623:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  800626:	01 c8                	add    %ecx,%eax
  800628:	8b 00                	mov    (%eax),%eax
  80062a:	39 c2                	cmp    %eax,%edx
  80062c:	7d 33                	jge    800661 <Merge+0x148>
			{
				A[k - 1] = Left[leftIndex++];
  80062e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800631:	05 ff ff ff 3f       	add    $0x3fffffff,%eax
  800636:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80063d:	8b 45 08             	mov    0x8(%ebp),%eax
  800640:	8d 0c 02             	lea    (%edx,%eax,1),%ecx
  800643:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800646:	8d 50 01             	lea    0x1(%eax),%edx
  800649:	89 55 f4             	mov    %edx,-0xc(%ebp)
  80064c:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800653:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800656:	01 d0                	add    %edx,%eax
  800658:	8b 00                	mov    (%eax),%eax
  80065a:	89 01                	mov    %eax,(%ecx)

	for ( k = p; k <= r; k++)
	{
		if (leftIndex < leftCapacity && rightIndex < rightCapacity)
		{
			if (Left[leftIndex] < Right[rightIndex] )
  80065c:	e9 96 00 00 00       	jmp    8006f7 <Merge+0x1de>
			{
				A[k - 1] = Left[leftIndex++];
			}
			else
			{
				A[k - 1] = Right[rightIndex++];
  800661:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800664:	05 ff ff ff 3f       	add    $0x3fffffff,%eax
  800669:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800670:	8b 45 08             	mov    0x8(%ebp),%eax
  800673:	8d 0c 02             	lea    (%edx,%eax,1),%ecx
  800676:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800679:	8d 50 01             	lea    0x1(%eax),%edx
  80067c:	89 55 f0             	mov    %edx,-0x10(%ebp)
  80067f:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800686:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  800689:	01 d0                	add    %edx,%eax
  80068b:	8b 00                	mov    (%eax),%eax
  80068d:	89 01                	mov    %eax,(%ecx)

	for ( k = p; k <= r; k++)
	{
		if (leftIndex < leftCapacity && rightIndex < rightCapacity)
		{
			if (Left[leftIndex] < Right[rightIndex] )
  80068f:	eb 66                	jmp    8006f7 <Merge+0x1de>
			else
			{
				A[k - 1] = Right[rightIndex++];
			}
		}
		else if (leftIndex < leftCapacity)
  800691:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800694:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  800697:	7d 30                	jge    8006c9 <Merge+0x1b0>
		{
			A[k - 1] = Left[leftIndex++];
  800699:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80069c:	05 ff ff ff 3f       	add    $0x3fffffff,%eax
  8006a1:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8006a8:	8b 45 08             	mov    0x8(%ebp),%eax
  8006ab:	8d 0c 02             	lea    (%edx,%eax,1),%ecx
  8006ae:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8006b1:	8d 50 01             	lea    0x1(%eax),%edx
  8006b4:	89 55 f4             	mov    %edx,-0xc(%ebp)
  8006b7:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8006be:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8006c1:	01 d0                	add    %edx,%eax
  8006c3:	8b 00                	mov    (%eax),%eax
  8006c5:	89 01                	mov    %eax,(%ecx)
  8006c7:	eb 2e                	jmp    8006f7 <Merge+0x1de>
		}
		else
		{
			A[k - 1] = Right[rightIndex++];
  8006c9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8006cc:	05 ff ff ff 3f       	add    $0x3fffffff,%eax
  8006d1:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8006d8:	8b 45 08             	mov    0x8(%ebp),%eax
  8006db:	8d 0c 02             	lea    (%edx,%eax,1),%ecx
  8006de:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8006e1:	8d 50 01             	lea    0x1(%eax),%edx
  8006e4:	89 55 f0             	mov    %edx,-0x10(%ebp)
  8006e7:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8006ee:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8006f1:	01 d0                	add    %edx,%eax
  8006f3:	8b 00                	mov    (%eax),%eax
  8006f5:	89 01                	mov    %eax,(%ecx)
	for (j = 0; j < rightCapacity; j++)
	{
		Right[j] = A[q + j];
	}

	for ( k = p; k <= r; k++)
  8006f7:	ff 45 e4             	incl   -0x1c(%ebp)
  8006fa:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8006fd:	3b 45 14             	cmp    0x14(%ebp),%eax
  800700:	0f 8e ea fe ff ff    	jle    8005f0 <Merge+0xd7>
			A[k - 1] = Right[rightIndex++];
		}
	}

	//cprintf("free LEFT\n");
	free(Left);
  800706:	83 ec 0c             	sub    $0xc,%esp
  800709:	ff 75 d8             	pushl  -0x28(%ebp)
  80070c:	e8 bd 16 00 00       	call   801dce <free>
  800711:	83 c4 10             	add    $0x10,%esp
	//cprintf("free RIGHT\n");
	free(Right);
  800714:	83 ec 0c             	sub    $0xc,%esp
  800717:	ff 75 d4             	pushl  -0x2c(%ebp)
  80071a:	e8 af 16 00 00       	call   801dce <free>
  80071f:	83 c4 10             	add    $0x10,%esp

}
  800722:	90                   	nop
  800723:	c9                   	leave  
  800724:	c3                   	ret    

00800725 <cputchar>:
#include <inc/lib.h>


void
cputchar(int ch)
{
  800725:	55                   	push   %ebp
  800726:	89 e5                	mov    %esp,%ebp
  800728:	83 ec 18             	sub    $0x18,%esp
	char c = ch;
  80072b:	8b 45 08             	mov    0x8(%ebp),%eax
  80072e:	88 45 f7             	mov    %al,-0x9(%ebp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	//sys_cputs(&c, 1);

	sys_cputc(c);
  800731:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
  800735:	83 ec 0c             	sub    $0xc,%esp
  800738:	50                   	push   %eax
  800739:	e8 3c 1b 00 00       	call   80227a <sys_cputc>
  80073e:	83 c4 10             	add    $0x10,%esp
}
  800741:	90                   	nop
  800742:	c9                   	leave  
  800743:	c3                   	ret    

00800744 <atomic_cputchar>:


void
atomic_cputchar(int ch)
{
  800744:	55                   	push   %ebp
  800745:	89 e5                	mov    %esp,%ebp
  800747:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  80074a:	e8 f7 1a 00 00       	call   802246 <sys_disable_interrupt>
	char c = ch;
  80074f:	8b 45 08             	mov    0x8(%ebp),%eax
  800752:	88 45 f7             	mov    %al,-0x9(%ebp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	//sys_cputs(&c, 1);

	sys_cputc(c);
  800755:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
  800759:	83 ec 0c             	sub    $0xc,%esp
  80075c:	50                   	push   %eax
  80075d:	e8 18 1b 00 00       	call   80227a <sys_cputc>
  800762:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  800765:	e8 f6 1a 00 00       	call   802260 <sys_enable_interrupt>
}
  80076a:	90                   	nop
  80076b:	c9                   	leave  
  80076c:	c3                   	ret    

0080076d <getchar>:

int
getchar(void)
{
  80076d:	55                   	push   %ebp
  80076e:	89 e5                	mov    %esp,%ebp
  800770:	83 ec 18             	sub    $0x18,%esp

	//return sys_cgetc();
	int c=0;
  800773:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	while(c == 0)
  80077a:	eb 08                	jmp    800784 <getchar+0x17>
	{
		c = sys_cgetc();
  80077c:	e8 40 19 00 00       	call   8020c1 <sys_cgetc>
  800781:	89 45 f4             	mov    %eax,-0xc(%ebp)
getchar(void)
{

	//return sys_cgetc();
	int c=0;
	while(c == 0)
  800784:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  800788:	74 f2                	je     80077c <getchar+0xf>
	{
		c = sys_cgetc();
	}
	return c;
  80078a:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  80078d:	c9                   	leave  
  80078e:	c3                   	ret    

0080078f <atomic_getchar>:

int
atomic_getchar(void)
{
  80078f:	55                   	push   %ebp
  800790:	89 e5                	mov    %esp,%ebp
  800792:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  800795:	e8 ac 1a 00 00       	call   802246 <sys_disable_interrupt>
	int c=0;
  80079a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	while(c == 0)
  8007a1:	eb 08                	jmp    8007ab <atomic_getchar+0x1c>
	{
		c = sys_cgetc();
  8007a3:	e8 19 19 00 00       	call   8020c1 <sys_cgetc>
  8007a8:	89 45 f4             	mov    %eax,-0xc(%ebp)
int
atomic_getchar(void)
{
	sys_disable_interrupt();
	int c=0;
	while(c == 0)
  8007ab:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8007af:	74 f2                	je     8007a3 <atomic_getchar+0x14>
	{
		c = sys_cgetc();
	}
	sys_enable_interrupt();
  8007b1:	e8 aa 1a 00 00       	call   802260 <sys_enable_interrupt>
	return c;
  8007b6:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  8007b9:	c9                   	leave  
  8007ba:	c3                   	ret    

008007bb <iscons>:

int iscons(int fdnum)
{
  8007bb:	55                   	push   %ebp
  8007bc:	89 e5                	mov    %esp,%ebp
	// used by readline
	return 1;
  8007be:	b8 01 00 00 00       	mov    $0x1,%eax
}
  8007c3:	5d                   	pop    %ebp
  8007c4:	c3                   	ret    

008007c5 <libmain>:
volatile struct Env *myEnv = NULL;
volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";

void
libmain(int argc, char **argv)
{
  8007c5:	55                   	push   %ebp
  8007c6:	89 e5                	mov    %esp,%ebp
  8007c8:	83 ec 18             	sub    $0x18,%esp
	int envIndex = sys_getenvindex();
  8007cb:	e8 69 1c 00 00       	call   802439 <sys_getenvindex>
  8007d0:	89 45 f4             	mov    %eax,-0xc(%ebp)
	myEnv = &(envs[envIndex]);
  8007d3:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8007d6:	89 d0                	mov    %edx,%eax
  8007d8:	c1 e0 03             	shl    $0x3,%eax
  8007db:	01 d0                	add    %edx,%eax
  8007dd:	01 c0                	add    %eax,%eax
  8007df:	01 d0                	add    %edx,%eax
  8007e1:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8007e8:	01 d0                	add    %edx,%eax
  8007ea:	c1 e0 04             	shl    $0x4,%eax
  8007ed:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8007f2:	a3 24 50 80 00       	mov    %eax,0x805024

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  8007f7:	a1 24 50 80 00       	mov    0x805024,%eax
  8007fc:	8a 80 5c 05 00 00    	mov    0x55c(%eax),%al
  800802:	84 c0                	test   %al,%al
  800804:	74 0f                	je     800815 <libmain+0x50>
		binaryname = myEnv->prog_name;
  800806:	a1 24 50 80 00       	mov    0x805024,%eax
  80080b:	05 5c 05 00 00       	add    $0x55c,%eax
  800810:	a3 00 50 80 00       	mov    %eax,0x805000

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800815:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800819:	7e 0a                	jle    800825 <libmain+0x60>
		binaryname = argv[0];
  80081b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80081e:	8b 00                	mov    (%eax),%eax
  800820:	a3 00 50 80 00       	mov    %eax,0x805000

	// call user main routine
	_main(argc, argv);
  800825:	83 ec 08             	sub    $0x8,%esp
  800828:	ff 75 0c             	pushl  0xc(%ebp)
  80082b:	ff 75 08             	pushl  0x8(%ebp)
  80082e:	e8 05 f8 ff ff       	call   800038 <_main>
  800833:	83 c4 10             	add    $0x10,%esp



	sys_disable_interrupt();
  800836:	e8 0b 1a 00 00       	call   802246 <sys_disable_interrupt>
	cprintf("**************************************\n");
  80083b:	83 ec 0c             	sub    $0xc,%esp
  80083e:	68 58 3b 80 00       	push   $0x803b58
  800843:	e8 6d 03 00 00       	call   800bb5 <cprintf>
  800848:	83 c4 10             	add    $0x10,%esp
	cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  80084b:	a1 24 50 80 00       	mov    0x805024,%eax
  800850:	8b 90 44 05 00 00    	mov    0x544(%eax),%edx
  800856:	a1 24 50 80 00       	mov    0x805024,%eax
  80085b:	8b 80 34 05 00 00    	mov    0x534(%eax),%eax
  800861:	83 ec 04             	sub    $0x4,%esp
  800864:	52                   	push   %edx
  800865:	50                   	push   %eax
  800866:	68 80 3b 80 00       	push   $0x803b80
  80086b:	e8 45 03 00 00       	call   800bb5 <cprintf>
  800870:	83 c4 10             	add    $0x10,%esp
	cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  800873:	a1 24 50 80 00       	mov    0x805024,%eax
  800878:	8b 88 54 05 00 00    	mov    0x554(%eax),%ecx
  80087e:	a1 24 50 80 00       	mov    0x805024,%eax
  800883:	8b 90 50 05 00 00    	mov    0x550(%eax),%edx
  800889:	a1 24 50 80 00       	mov    0x805024,%eax
  80088e:	8b 80 4c 05 00 00    	mov    0x54c(%eax),%eax
  800894:	51                   	push   %ecx
  800895:	52                   	push   %edx
  800896:	50                   	push   %eax
  800897:	68 a8 3b 80 00       	push   $0x803ba8
  80089c:	e8 14 03 00 00       	call   800bb5 <cprintf>
  8008a1:	83 c4 10             	add    $0x10,%esp
	//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
	cprintf("Num of clocks = %d\n", myEnv->nClocks);
  8008a4:	a1 24 50 80 00       	mov    0x805024,%eax
  8008a9:	8b 80 a4 05 00 00    	mov    0x5a4(%eax),%eax
  8008af:	83 ec 08             	sub    $0x8,%esp
  8008b2:	50                   	push   %eax
  8008b3:	68 00 3c 80 00       	push   $0x803c00
  8008b8:	e8 f8 02 00 00       	call   800bb5 <cprintf>
  8008bd:	83 c4 10             	add    $0x10,%esp
	cprintf("**************************************\n");
  8008c0:	83 ec 0c             	sub    $0xc,%esp
  8008c3:	68 58 3b 80 00       	push   $0x803b58
  8008c8:	e8 e8 02 00 00       	call   800bb5 <cprintf>
  8008cd:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  8008d0:	e8 8b 19 00 00       	call   802260 <sys_enable_interrupt>

	// exit gracefully
	exit();
  8008d5:	e8 19 00 00 00       	call   8008f3 <exit>
}
  8008da:	90                   	nop
  8008db:	c9                   	leave  
  8008dc:	c3                   	ret    

008008dd <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  8008dd:	55                   	push   %ebp
  8008de:	89 e5                	mov    %esp,%ebp
  8008e0:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  8008e3:	83 ec 0c             	sub    $0xc,%esp
  8008e6:	6a 00                	push   $0x0
  8008e8:	e8 18 1b 00 00       	call   802405 <sys_destroy_env>
  8008ed:	83 c4 10             	add    $0x10,%esp
}
  8008f0:	90                   	nop
  8008f1:	c9                   	leave  
  8008f2:	c3                   	ret    

008008f3 <exit>:

void
exit(void)
{
  8008f3:	55                   	push   %ebp
  8008f4:	89 e5                	mov    %esp,%ebp
  8008f6:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  8008f9:	e8 6d 1b 00 00       	call   80246b <sys_exit_env>
}
  8008fe:	90                   	nop
  8008ff:	c9                   	leave  
  800900:	c3                   	ret    

00800901 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  800901:	55                   	push   %ebp
  800902:	89 e5                	mov    %esp,%ebp
  800904:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  800907:	8d 45 10             	lea    0x10(%ebp),%eax
  80090a:	83 c0 04             	add    $0x4,%eax
  80090d:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  800910:	a1 5c 51 80 00       	mov    0x80515c,%eax
  800915:	85 c0                	test   %eax,%eax
  800917:	74 16                	je     80092f <_panic+0x2e>
		cprintf("%s: ", argv0);
  800919:	a1 5c 51 80 00       	mov    0x80515c,%eax
  80091e:	83 ec 08             	sub    $0x8,%esp
  800921:	50                   	push   %eax
  800922:	68 14 3c 80 00       	push   $0x803c14
  800927:	e8 89 02 00 00       	call   800bb5 <cprintf>
  80092c:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  80092f:	a1 00 50 80 00       	mov    0x805000,%eax
  800934:	ff 75 0c             	pushl  0xc(%ebp)
  800937:	ff 75 08             	pushl  0x8(%ebp)
  80093a:	50                   	push   %eax
  80093b:	68 19 3c 80 00       	push   $0x803c19
  800940:	e8 70 02 00 00       	call   800bb5 <cprintf>
  800945:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  800948:	8b 45 10             	mov    0x10(%ebp),%eax
  80094b:	83 ec 08             	sub    $0x8,%esp
  80094e:	ff 75 f4             	pushl  -0xc(%ebp)
  800951:	50                   	push   %eax
  800952:	e8 f3 01 00 00       	call   800b4a <vcprintf>
  800957:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  80095a:	83 ec 08             	sub    $0x8,%esp
  80095d:	6a 00                	push   $0x0
  80095f:	68 35 3c 80 00       	push   $0x803c35
  800964:	e8 e1 01 00 00       	call   800b4a <vcprintf>
  800969:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  80096c:	e8 82 ff ff ff       	call   8008f3 <exit>

	// should not return here
	while (1) ;
  800971:	eb fe                	jmp    800971 <_panic+0x70>

00800973 <CheckWSWithoutLastIndex>:
}

void CheckWSWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  800973:	55                   	push   %ebp
  800974:	89 e5                	mov    %esp,%ebp
  800976:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  800979:	a1 24 50 80 00       	mov    0x805024,%eax
  80097e:	8b 50 74             	mov    0x74(%eax),%edx
  800981:	8b 45 0c             	mov    0xc(%ebp),%eax
  800984:	39 c2                	cmp    %eax,%edx
  800986:	74 14                	je     80099c <CheckWSWithoutLastIndex+0x29>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  800988:	83 ec 04             	sub    $0x4,%esp
  80098b:	68 38 3c 80 00       	push   $0x803c38
  800990:	6a 26                	push   $0x26
  800992:	68 84 3c 80 00       	push   $0x803c84
  800997:	e8 65 ff ff ff       	call   800901 <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  80099c:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  8009a3:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  8009aa:	e9 c2 00 00 00       	jmp    800a71 <CheckWSWithoutLastIndex+0xfe>
		if (expectedPages[e] == 0) {
  8009af:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8009b2:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8009b9:	8b 45 08             	mov    0x8(%ebp),%eax
  8009bc:	01 d0                	add    %edx,%eax
  8009be:	8b 00                	mov    (%eax),%eax
  8009c0:	85 c0                	test   %eax,%eax
  8009c2:	75 08                	jne    8009cc <CheckWSWithoutLastIndex+0x59>
			expectedNumOfEmptyLocs++;
  8009c4:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  8009c7:	e9 a2 00 00 00       	jmp    800a6e <CheckWSWithoutLastIndex+0xfb>
		}
		int found = 0;
  8009cc:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8009d3:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  8009da:	eb 69                	jmp    800a45 <CheckWSWithoutLastIndex+0xd2>
			if (myEnv->__uptr_pws[w].empty == 0) {
  8009dc:	a1 24 50 80 00       	mov    0x805024,%eax
  8009e1:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  8009e7:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8009ea:	89 d0                	mov    %edx,%eax
  8009ec:	01 c0                	add    %eax,%eax
  8009ee:	01 d0                	add    %edx,%eax
  8009f0:	c1 e0 03             	shl    $0x3,%eax
  8009f3:	01 c8                	add    %ecx,%eax
  8009f5:	8a 40 04             	mov    0x4(%eax),%al
  8009f8:	84 c0                	test   %al,%al
  8009fa:	75 46                	jne    800a42 <CheckWSWithoutLastIndex+0xcf>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  8009fc:	a1 24 50 80 00       	mov    0x805024,%eax
  800a01:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  800a07:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800a0a:	89 d0                	mov    %edx,%eax
  800a0c:	01 c0                	add    %eax,%eax
  800a0e:	01 d0                	add    %edx,%eax
  800a10:	c1 e0 03             	shl    $0x3,%eax
  800a13:	01 c8                	add    %ecx,%eax
  800a15:	8b 00                	mov    (%eax),%eax
  800a17:	89 45 dc             	mov    %eax,-0x24(%ebp)
  800a1a:	8b 45 dc             	mov    -0x24(%ebp),%eax
  800a1d:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800a22:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  800a24:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800a27:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  800a2e:	8b 45 08             	mov    0x8(%ebp),%eax
  800a31:	01 c8                	add    %ecx,%eax
  800a33:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  800a35:	39 c2                	cmp    %eax,%edx
  800a37:	75 09                	jne    800a42 <CheckWSWithoutLastIndex+0xcf>
						== expectedPages[e]) {
					found = 1;
  800a39:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  800a40:	eb 12                	jmp    800a54 <CheckWSWithoutLastIndex+0xe1>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800a42:	ff 45 e8             	incl   -0x18(%ebp)
  800a45:	a1 24 50 80 00       	mov    0x805024,%eax
  800a4a:	8b 50 74             	mov    0x74(%eax),%edx
  800a4d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800a50:	39 c2                	cmp    %eax,%edx
  800a52:	77 88                	ja     8009dc <CheckWSWithoutLastIndex+0x69>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  800a54:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  800a58:	75 14                	jne    800a6e <CheckWSWithoutLastIndex+0xfb>
			panic(
  800a5a:	83 ec 04             	sub    $0x4,%esp
  800a5d:	68 90 3c 80 00       	push   $0x803c90
  800a62:	6a 3a                	push   $0x3a
  800a64:	68 84 3c 80 00       	push   $0x803c84
  800a69:	e8 93 fe ff ff       	call   800901 <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  800a6e:	ff 45 f0             	incl   -0x10(%ebp)
  800a71:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800a74:	3b 45 0c             	cmp    0xc(%ebp),%eax
  800a77:	0f 8c 32 ff ff ff    	jl     8009af <CheckWSWithoutLastIndex+0x3c>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  800a7d:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800a84:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  800a8b:	eb 26                	jmp    800ab3 <CheckWSWithoutLastIndex+0x140>
		if (myEnv->__uptr_pws[w].empty == 1) {
  800a8d:	a1 24 50 80 00       	mov    0x805024,%eax
  800a92:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  800a98:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800a9b:	89 d0                	mov    %edx,%eax
  800a9d:	01 c0                	add    %eax,%eax
  800a9f:	01 d0                	add    %edx,%eax
  800aa1:	c1 e0 03             	shl    $0x3,%eax
  800aa4:	01 c8                	add    %ecx,%eax
  800aa6:	8a 40 04             	mov    0x4(%eax),%al
  800aa9:	3c 01                	cmp    $0x1,%al
  800aab:	75 03                	jne    800ab0 <CheckWSWithoutLastIndex+0x13d>
			actualNumOfEmptyLocs++;
  800aad:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800ab0:	ff 45 e0             	incl   -0x20(%ebp)
  800ab3:	a1 24 50 80 00       	mov    0x805024,%eax
  800ab8:	8b 50 74             	mov    0x74(%eax),%edx
  800abb:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800abe:	39 c2                	cmp    %eax,%edx
  800ac0:	77 cb                	ja     800a8d <CheckWSWithoutLastIndex+0x11a>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  800ac2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800ac5:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  800ac8:	74 14                	je     800ade <CheckWSWithoutLastIndex+0x16b>
		panic(
  800aca:	83 ec 04             	sub    $0x4,%esp
  800acd:	68 e4 3c 80 00       	push   $0x803ce4
  800ad2:	6a 44                	push   $0x44
  800ad4:	68 84 3c 80 00       	push   $0x803c84
  800ad9:	e8 23 fe ff ff       	call   800901 <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  800ade:	90                   	nop
  800adf:	c9                   	leave  
  800ae0:	c3                   	ret    

00800ae1 <putch>:
};

//2017:
uint8 printProgName = 0;

static void putch(int ch, struct printbuf *b) {
  800ae1:	55                   	push   %ebp
  800ae2:	89 e5                	mov    %esp,%ebp
  800ae4:	83 ec 08             	sub    $0x8,%esp
	b->buf[b->idx++] = ch;
  800ae7:	8b 45 0c             	mov    0xc(%ebp),%eax
  800aea:	8b 00                	mov    (%eax),%eax
  800aec:	8d 48 01             	lea    0x1(%eax),%ecx
  800aef:	8b 55 0c             	mov    0xc(%ebp),%edx
  800af2:	89 0a                	mov    %ecx,(%edx)
  800af4:	8b 55 08             	mov    0x8(%ebp),%edx
  800af7:	88 d1                	mov    %dl,%cl
  800af9:	8b 55 0c             	mov    0xc(%ebp),%edx
  800afc:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  800b00:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b03:	8b 00                	mov    (%eax),%eax
  800b05:	3d ff 00 00 00       	cmp    $0xff,%eax
  800b0a:	75 2c                	jne    800b38 <putch+0x57>
		sys_cputs(b->buf, b->idx, printProgName);
  800b0c:	a0 28 50 80 00       	mov    0x805028,%al
  800b11:	0f b6 c0             	movzbl %al,%eax
  800b14:	8b 55 0c             	mov    0xc(%ebp),%edx
  800b17:	8b 12                	mov    (%edx),%edx
  800b19:	89 d1                	mov    %edx,%ecx
  800b1b:	8b 55 0c             	mov    0xc(%ebp),%edx
  800b1e:	83 c2 08             	add    $0x8,%edx
  800b21:	83 ec 04             	sub    $0x4,%esp
  800b24:	50                   	push   %eax
  800b25:	51                   	push   %ecx
  800b26:	52                   	push   %edx
  800b27:	e8 6c 15 00 00       	call   802098 <sys_cputs>
  800b2c:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  800b2f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b32:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  800b38:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b3b:	8b 40 04             	mov    0x4(%eax),%eax
  800b3e:	8d 50 01             	lea    0x1(%eax),%edx
  800b41:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b44:	89 50 04             	mov    %edx,0x4(%eax)
}
  800b47:	90                   	nop
  800b48:	c9                   	leave  
  800b49:	c3                   	ret    

00800b4a <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  800b4a:	55                   	push   %ebp
  800b4b:	89 e5                	mov    %esp,%ebp
  800b4d:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  800b53:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800b5a:	00 00 00 
	b.cnt = 0;
  800b5d:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800b64:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  800b67:	ff 75 0c             	pushl  0xc(%ebp)
  800b6a:	ff 75 08             	pushl  0x8(%ebp)
  800b6d:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800b73:	50                   	push   %eax
  800b74:	68 e1 0a 80 00       	push   $0x800ae1
  800b79:	e8 11 02 00 00       	call   800d8f <vprintfmt>
  800b7e:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName);
  800b81:	a0 28 50 80 00       	mov    0x805028,%al
  800b86:	0f b6 c0             	movzbl %al,%eax
  800b89:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  800b8f:	83 ec 04             	sub    $0x4,%esp
  800b92:	50                   	push   %eax
  800b93:	52                   	push   %edx
  800b94:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800b9a:	83 c0 08             	add    $0x8,%eax
  800b9d:	50                   	push   %eax
  800b9e:	e8 f5 14 00 00       	call   802098 <sys_cputs>
  800ba3:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  800ba6:	c6 05 28 50 80 00 00 	movb   $0x0,0x805028
	return b.cnt;
  800bad:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  800bb3:	c9                   	leave  
  800bb4:	c3                   	ret    

00800bb5 <cprintf>:

int cprintf(const char *fmt, ...) {
  800bb5:	55                   	push   %ebp
  800bb6:	89 e5                	mov    %esp,%ebp
  800bb8:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  800bbb:	c6 05 28 50 80 00 01 	movb   $0x1,0x805028
	va_start(ap, fmt);
  800bc2:	8d 45 0c             	lea    0xc(%ebp),%eax
  800bc5:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800bc8:	8b 45 08             	mov    0x8(%ebp),%eax
  800bcb:	83 ec 08             	sub    $0x8,%esp
  800bce:	ff 75 f4             	pushl  -0xc(%ebp)
  800bd1:	50                   	push   %eax
  800bd2:	e8 73 ff ff ff       	call   800b4a <vcprintf>
  800bd7:	83 c4 10             	add    $0x10,%esp
  800bda:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  800bdd:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800be0:	c9                   	leave  
  800be1:	c3                   	ret    

00800be2 <atomic_cprintf>:

int atomic_cprintf(const char *fmt, ...) {
  800be2:	55                   	push   %ebp
  800be3:	89 e5                	mov    %esp,%ebp
  800be5:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  800be8:	e8 59 16 00 00       	call   802246 <sys_disable_interrupt>
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  800bed:	8d 45 0c             	lea    0xc(%ebp),%eax
  800bf0:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800bf3:	8b 45 08             	mov    0x8(%ebp),%eax
  800bf6:	83 ec 08             	sub    $0x8,%esp
  800bf9:	ff 75 f4             	pushl  -0xc(%ebp)
  800bfc:	50                   	push   %eax
  800bfd:	e8 48 ff ff ff       	call   800b4a <vcprintf>
  800c02:	83 c4 10             	add    $0x10,%esp
  800c05:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	sys_enable_interrupt();
  800c08:	e8 53 16 00 00       	call   802260 <sys_enable_interrupt>
	return cnt;
  800c0d:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800c10:	c9                   	leave  
  800c11:	c3                   	ret    

00800c12 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800c12:	55                   	push   %ebp
  800c13:	89 e5                	mov    %esp,%ebp
  800c15:	53                   	push   %ebx
  800c16:	83 ec 14             	sub    $0x14,%esp
  800c19:	8b 45 10             	mov    0x10(%ebp),%eax
  800c1c:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800c1f:	8b 45 14             	mov    0x14(%ebp),%eax
  800c22:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800c25:	8b 45 18             	mov    0x18(%ebp),%eax
  800c28:	ba 00 00 00 00       	mov    $0x0,%edx
  800c2d:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800c30:	77 55                	ja     800c87 <printnum+0x75>
  800c32:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800c35:	72 05                	jb     800c3c <printnum+0x2a>
  800c37:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800c3a:	77 4b                	ja     800c87 <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800c3c:	8b 45 1c             	mov    0x1c(%ebp),%eax
  800c3f:	8d 58 ff             	lea    -0x1(%eax),%ebx
  800c42:	8b 45 18             	mov    0x18(%ebp),%eax
  800c45:	ba 00 00 00 00       	mov    $0x0,%edx
  800c4a:	52                   	push   %edx
  800c4b:	50                   	push   %eax
  800c4c:	ff 75 f4             	pushl  -0xc(%ebp)
  800c4f:	ff 75 f0             	pushl  -0x10(%ebp)
  800c52:	e8 8d 2a 00 00       	call   8036e4 <__udivdi3>
  800c57:	83 c4 10             	add    $0x10,%esp
  800c5a:	83 ec 04             	sub    $0x4,%esp
  800c5d:	ff 75 20             	pushl  0x20(%ebp)
  800c60:	53                   	push   %ebx
  800c61:	ff 75 18             	pushl  0x18(%ebp)
  800c64:	52                   	push   %edx
  800c65:	50                   	push   %eax
  800c66:	ff 75 0c             	pushl  0xc(%ebp)
  800c69:	ff 75 08             	pushl  0x8(%ebp)
  800c6c:	e8 a1 ff ff ff       	call   800c12 <printnum>
  800c71:	83 c4 20             	add    $0x20,%esp
  800c74:	eb 1a                	jmp    800c90 <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800c76:	83 ec 08             	sub    $0x8,%esp
  800c79:	ff 75 0c             	pushl  0xc(%ebp)
  800c7c:	ff 75 20             	pushl  0x20(%ebp)
  800c7f:	8b 45 08             	mov    0x8(%ebp),%eax
  800c82:	ff d0                	call   *%eax
  800c84:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800c87:	ff 4d 1c             	decl   0x1c(%ebp)
  800c8a:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  800c8e:	7f e6                	jg     800c76 <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800c90:	8b 4d 18             	mov    0x18(%ebp),%ecx
  800c93:	bb 00 00 00 00       	mov    $0x0,%ebx
  800c98:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800c9b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800c9e:	53                   	push   %ebx
  800c9f:	51                   	push   %ecx
  800ca0:	52                   	push   %edx
  800ca1:	50                   	push   %eax
  800ca2:	e8 4d 2b 00 00       	call   8037f4 <__umoddi3>
  800ca7:	83 c4 10             	add    $0x10,%esp
  800caa:	05 54 3f 80 00       	add    $0x803f54,%eax
  800caf:	8a 00                	mov    (%eax),%al
  800cb1:	0f be c0             	movsbl %al,%eax
  800cb4:	83 ec 08             	sub    $0x8,%esp
  800cb7:	ff 75 0c             	pushl  0xc(%ebp)
  800cba:	50                   	push   %eax
  800cbb:	8b 45 08             	mov    0x8(%ebp),%eax
  800cbe:	ff d0                	call   *%eax
  800cc0:	83 c4 10             	add    $0x10,%esp
}
  800cc3:	90                   	nop
  800cc4:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800cc7:	c9                   	leave  
  800cc8:	c3                   	ret    

00800cc9 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  800cc9:	55                   	push   %ebp
  800cca:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800ccc:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800cd0:	7e 1c                	jle    800cee <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  800cd2:	8b 45 08             	mov    0x8(%ebp),%eax
  800cd5:	8b 00                	mov    (%eax),%eax
  800cd7:	8d 50 08             	lea    0x8(%eax),%edx
  800cda:	8b 45 08             	mov    0x8(%ebp),%eax
  800cdd:	89 10                	mov    %edx,(%eax)
  800cdf:	8b 45 08             	mov    0x8(%ebp),%eax
  800ce2:	8b 00                	mov    (%eax),%eax
  800ce4:	83 e8 08             	sub    $0x8,%eax
  800ce7:	8b 50 04             	mov    0x4(%eax),%edx
  800cea:	8b 00                	mov    (%eax),%eax
  800cec:	eb 40                	jmp    800d2e <getuint+0x65>
	else if (lflag)
  800cee:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800cf2:	74 1e                	je     800d12 <getuint+0x49>
		return va_arg(*ap, unsigned long);
  800cf4:	8b 45 08             	mov    0x8(%ebp),%eax
  800cf7:	8b 00                	mov    (%eax),%eax
  800cf9:	8d 50 04             	lea    0x4(%eax),%edx
  800cfc:	8b 45 08             	mov    0x8(%ebp),%eax
  800cff:	89 10                	mov    %edx,(%eax)
  800d01:	8b 45 08             	mov    0x8(%ebp),%eax
  800d04:	8b 00                	mov    (%eax),%eax
  800d06:	83 e8 04             	sub    $0x4,%eax
  800d09:	8b 00                	mov    (%eax),%eax
  800d0b:	ba 00 00 00 00       	mov    $0x0,%edx
  800d10:	eb 1c                	jmp    800d2e <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  800d12:	8b 45 08             	mov    0x8(%ebp),%eax
  800d15:	8b 00                	mov    (%eax),%eax
  800d17:	8d 50 04             	lea    0x4(%eax),%edx
  800d1a:	8b 45 08             	mov    0x8(%ebp),%eax
  800d1d:	89 10                	mov    %edx,(%eax)
  800d1f:	8b 45 08             	mov    0x8(%ebp),%eax
  800d22:	8b 00                	mov    (%eax),%eax
  800d24:	83 e8 04             	sub    $0x4,%eax
  800d27:	8b 00                	mov    (%eax),%eax
  800d29:	ba 00 00 00 00       	mov    $0x0,%edx
}
  800d2e:	5d                   	pop    %ebp
  800d2f:	c3                   	ret    

00800d30 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  800d30:	55                   	push   %ebp
  800d31:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800d33:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800d37:	7e 1c                	jle    800d55 <getint+0x25>
		return va_arg(*ap, long long);
  800d39:	8b 45 08             	mov    0x8(%ebp),%eax
  800d3c:	8b 00                	mov    (%eax),%eax
  800d3e:	8d 50 08             	lea    0x8(%eax),%edx
  800d41:	8b 45 08             	mov    0x8(%ebp),%eax
  800d44:	89 10                	mov    %edx,(%eax)
  800d46:	8b 45 08             	mov    0x8(%ebp),%eax
  800d49:	8b 00                	mov    (%eax),%eax
  800d4b:	83 e8 08             	sub    $0x8,%eax
  800d4e:	8b 50 04             	mov    0x4(%eax),%edx
  800d51:	8b 00                	mov    (%eax),%eax
  800d53:	eb 38                	jmp    800d8d <getint+0x5d>
	else if (lflag)
  800d55:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800d59:	74 1a                	je     800d75 <getint+0x45>
		return va_arg(*ap, long);
  800d5b:	8b 45 08             	mov    0x8(%ebp),%eax
  800d5e:	8b 00                	mov    (%eax),%eax
  800d60:	8d 50 04             	lea    0x4(%eax),%edx
  800d63:	8b 45 08             	mov    0x8(%ebp),%eax
  800d66:	89 10                	mov    %edx,(%eax)
  800d68:	8b 45 08             	mov    0x8(%ebp),%eax
  800d6b:	8b 00                	mov    (%eax),%eax
  800d6d:	83 e8 04             	sub    $0x4,%eax
  800d70:	8b 00                	mov    (%eax),%eax
  800d72:	99                   	cltd   
  800d73:	eb 18                	jmp    800d8d <getint+0x5d>
	else
		return va_arg(*ap, int);
  800d75:	8b 45 08             	mov    0x8(%ebp),%eax
  800d78:	8b 00                	mov    (%eax),%eax
  800d7a:	8d 50 04             	lea    0x4(%eax),%edx
  800d7d:	8b 45 08             	mov    0x8(%ebp),%eax
  800d80:	89 10                	mov    %edx,(%eax)
  800d82:	8b 45 08             	mov    0x8(%ebp),%eax
  800d85:	8b 00                	mov    (%eax),%eax
  800d87:	83 e8 04             	sub    $0x4,%eax
  800d8a:	8b 00                	mov    (%eax),%eax
  800d8c:	99                   	cltd   
}
  800d8d:	5d                   	pop    %ebp
  800d8e:	c3                   	ret    

00800d8f <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  800d8f:	55                   	push   %ebp
  800d90:	89 e5                	mov    %esp,%ebp
  800d92:	56                   	push   %esi
  800d93:	53                   	push   %ebx
  800d94:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800d97:	eb 17                	jmp    800db0 <vprintfmt+0x21>
			if (ch == '\0')
  800d99:	85 db                	test   %ebx,%ebx
  800d9b:	0f 84 af 03 00 00    	je     801150 <vprintfmt+0x3c1>
				return;
			putch(ch, putdat);
  800da1:	83 ec 08             	sub    $0x8,%esp
  800da4:	ff 75 0c             	pushl  0xc(%ebp)
  800da7:	53                   	push   %ebx
  800da8:	8b 45 08             	mov    0x8(%ebp),%eax
  800dab:	ff d0                	call   *%eax
  800dad:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800db0:	8b 45 10             	mov    0x10(%ebp),%eax
  800db3:	8d 50 01             	lea    0x1(%eax),%edx
  800db6:	89 55 10             	mov    %edx,0x10(%ebp)
  800db9:	8a 00                	mov    (%eax),%al
  800dbb:	0f b6 d8             	movzbl %al,%ebx
  800dbe:	83 fb 25             	cmp    $0x25,%ebx
  800dc1:	75 d6                	jne    800d99 <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  800dc3:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  800dc7:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  800dce:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  800dd5:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  800ddc:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800de3:	8b 45 10             	mov    0x10(%ebp),%eax
  800de6:	8d 50 01             	lea    0x1(%eax),%edx
  800de9:	89 55 10             	mov    %edx,0x10(%ebp)
  800dec:	8a 00                	mov    (%eax),%al
  800dee:	0f b6 d8             	movzbl %al,%ebx
  800df1:	8d 43 dd             	lea    -0x23(%ebx),%eax
  800df4:	83 f8 55             	cmp    $0x55,%eax
  800df7:	0f 87 2b 03 00 00    	ja     801128 <vprintfmt+0x399>
  800dfd:	8b 04 85 78 3f 80 00 	mov    0x803f78(,%eax,4),%eax
  800e04:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  800e06:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  800e0a:	eb d7                	jmp    800de3 <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800e0c:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  800e10:	eb d1                	jmp    800de3 <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800e12:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  800e19:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800e1c:	89 d0                	mov    %edx,%eax
  800e1e:	c1 e0 02             	shl    $0x2,%eax
  800e21:	01 d0                	add    %edx,%eax
  800e23:	01 c0                	add    %eax,%eax
  800e25:	01 d8                	add    %ebx,%eax
  800e27:	83 e8 30             	sub    $0x30,%eax
  800e2a:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  800e2d:	8b 45 10             	mov    0x10(%ebp),%eax
  800e30:	8a 00                	mov    (%eax),%al
  800e32:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  800e35:	83 fb 2f             	cmp    $0x2f,%ebx
  800e38:	7e 3e                	jle    800e78 <vprintfmt+0xe9>
  800e3a:	83 fb 39             	cmp    $0x39,%ebx
  800e3d:	7f 39                	jg     800e78 <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800e3f:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800e42:	eb d5                	jmp    800e19 <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  800e44:	8b 45 14             	mov    0x14(%ebp),%eax
  800e47:	83 c0 04             	add    $0x4,%eax
  800e4a:	89 45 14             	mov    %eax,0x14(%ebp)
  800e4d:	8b 45 14             	mov    0x14(%ebp),%eax
  800e50:	83 e8 04             	sub    $0x4,%eax
  800e53:	8b 00                	mov    (%eax),%eax
  800e55:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  800e58:	eb 1f                	jmp    800e79 <vprintfmt+0xea>

		case '.':
			if (width < 0)
  800e5a:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800e5e:	79 83                	jns    800de3 <vprintfmt+0x54>
				width = 0;
  800e60:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  800e67:	e9 77 ff ff ff       	jmp    800de3 <vprintfmt+0x54>

		case '#':
			altflag = 1;
  800e6c:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  800e73:	e9 6b ff ff ff       	jmp    800de3 <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  800e78:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  800e79:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800e7d:	0f 89 60 ff ff ff    	jns    800de3 <vprintfmt+0x54>
				width = precision, precision = -1;
  800e83:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800e86:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800e89:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  800e90:	e9 4e ff ff ff       	jmp    800de3 <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  800e95:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  800e98:	e9 46 ff ff ff       	jmp    800de3 <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  800e9d:	8b 45 14             	mov    0x14(%ebp),%eax
  800ea0:	83 c0 04             	add    $0x4,%eax
  800ea3:	89 45 14             	mov    %eax,0x14(%ebp)
  800ea6:	8b 45 14             	mov    0x14(%ebp),%eax
  800ea9:	83 e8 04             	sub    $0x4,%eax
  800eac:	8b 00                	mov    (%eax),%eax
  800eae:	83 ec 08             	sub    $0x8,%esp
  800eb1:	ff 75 0c             	pushl  0xc(%ebp)
  800eb4:	50                   	push   %eax
  800eb5:	8b 45 08             	mov    0x8(%ebp),%eax
  800eb8:	ff d0                	call   *%eax
  800eba:	83 c4 10             	add    $0x10,%esp
			break;
  800ebd:	e9 89 02 00 00       	jmp    80114b <vprintfmt+0x3bc>

		// error message
		case 'e':
			err = va_arg(ap, int);
  800ec2:	8b 45 14             	mov    0x14(%ebp),%eax
  800ec5:	83 c0 04             	add    $0x4,%eax
  800ec8:	89 45 14             	mov    %eax,0x14(%ebp)
  800ecb:	8b 45 14             	mov    0x14(%ebp),%eax
  800ece:	83 e8 04             	sub    $0x4,%eax
  800ed1:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  800ed3:	85 db                	test   %ebx,%ebx
  800ed5:	79 02                	jns    800ed9 <vprintfmt+0x14a>
				err = -err;
  800ed7:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  800ed9:	83 fb 64             	cmp    $0x64,%ebx
  800edc:	7f 0b                	jg     800ee9 <vprintfmt+0x15a>
  800ede:	8b 34 9d c0 3d 80 00 	mov    0x803dc0(,%ebx,4),%esi
  800ee5:	85 f6                	test   %esi,%esi
  800ee7:	75 19                	jne    800f02 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  800ee9:	53                   	push   %ebx
  800eea:	68 65 3f 80 00       	push   $0x803f65
  800eef:	ff 75 0c             	pushl  0xc(%ebp)
  800ef2:	ff 75 08             	pushl  0x8(%ebp)
  800ef5:	e8 5e 02 00 00       	call   801158 <printfmt>
  800efa:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800efd:	e9 49 02 00 00       	jmp    80114b <vprintfmt+0x3bc>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800f02:	56                   	push   %esi
  800f03:	68 6e 3f 80 00       	push   $0x803f6e
  800f08:	ff 75 0c             	pushl  0xc(%ebp)
  800f0b:	ff 75 08             	pushl  0x8(%ebp)
  800f0e:	e8 45 02 00 00       	call   801158 <printfmt>
  800f13:	83 c4 10             	add    $0x10,%esp
			break;
  800f16:	e9 30 02 00 00       	jmp    80114b <vprintfmt+0x3bc>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  800f1b:	8b 45 14             	mov    0x14(%ebp),%eax
  800f1e:	83 c0 04             	add    $0x4,%eax
  800f21:	89 45 14             	mov    %eax,0x14(%ebp)
  800f24:	8b 45 14             	mov    0x14(%ebp),%eax
  800f27:	83 e8 04             	sub    $0x4,%eax
  800f2a:	8b 30                	mov    (%eax),%esi
  800f2c:	85 f6                	test   %esi,%esi
  800f2e:	75 05                	jne    800f35 <vprintfmt+0x1a6>
				p = "(null)";
  800f30:	be 71 3f 80 00       	mov    $0x803f71,%esi
			if (width > 0 && padc != '-')
  800f35:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800f39:	7e 6d                	jle    800fa8 <vprintfmt+0x219>
  800f3b:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  800f3f:	74 67                	je     800fa8 <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  800f41:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800f44:	83 ec 08             	sub    $0x8,%esp
  800f47:	50                   	push   %eax
  800f48:	56                   	push   %esi
  800f49:	e8 12 05 00 00       	call   801460 <strnlen>
  800f4e:	83 c4 10             	add    $0x10,%esp
  800f51:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  800f54:	eb 16                	jmp    800f6c <vprintfmt+0x1dd>
					putch(padc, putdat);
  800f56:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  800f5a:	83 ec 08             	sub    $0x8,%esp
  800f5d:	ff 75 0c             	pushl  0xc(%ebp)
  800f60:	50                   	push   %eax
  800f61:	8b 45 08             	mov    0x8(%ebp),%eax
  800f64:	ff d0                	call   *%eax
  800f66:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800f69:	ff 4d e4             	decl   -0x1c(%ebp)
  800f6c:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800f70:	7f e4                	jg     800f56 <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800f72:	eb 34                	jmp    800fa8 <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  800f74:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800f78:	74 1c                	je     800f96 <vprintfmt+0x207>
  800f7a:	83 fb 1f             	cmp    $0x1f,%ebx
  800f7d:	7e 05                	jle    800f84 <vprintfmt+0x1f5>
  800f7f:	83 fb 7e             	cmp    $0x7e,%ebx
  800f82:	7e 12                	jle    800f96 <vprintfmt+0x207>
					putch('?', putdat);
  800f84:	83 ec 08             	sub    $0x8,%esp
  800f87:	ff 75 0c             	pushl  0xc(%ebp)
  800f8a:	6a 3f                	push   $0x3f
  800f8c:	8b 45 08             	mov    0x8(%ebp),%eax
  800f8f:	ff d0                	call   *%eax
  800f91:	83 c4 10             	add    $0x10,%esp
  800f94:	eb 0f                	jmp    800fa5 <vprintfmt+0x216>
				else
					putch(ch, putdat);
  800f96:	83 ec 08             	sub    $0x8,%esp
  800f99:	ff 75 0c             	pushl  0xc(%ebp)
  800f9c:	53                   	push   %ebx
  800f9d:	8b 45 08             	mov    0x8(%ebp),%eax
  800fa0:	ff d0                	call   *%eax
  800fa2:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800fa5:	ff 4d e4             	decl   -0x1c(%ebp)
  800fa8:	89 f0                	mov    %esi,%eax
  800faa:	8d 70 01             	lea    0x1(%eax),%esi
  800fad:	8a 00                	mov    (%eax),%al
  800faf:	0f be d8             	movsbl %al,%ebx
  800fb2:	85 db                	test   %ebx,%ebx
  800fb4:	74 24                	je     800fda <vprintfmt+0x24b>
  800fb6:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800fba:	78 b8                	js     800f74 <vprintfmt+0x1e5>
  800fbc:	ff 4d e0             	decl   -0x20(%ebp)
  800fbf:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800fc3:	79 af                	jns    800f74 <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800fc5:	eb 13                	jmp    800fda <vprintfmt+0x24b>
				putch(' ', putdat);
  800fc7:	83 ec 08             	sub    $0x8,%esp
  800fca:	ff 75 0c             	pushl  0xc(%ebp)
  800fcd:	6a 20                	push   $0x20
  800fcf:	8b 45 08             	mov    0x8(%ebp),%eax
  800fd2:	ff d0                	call   *%eax
  800fd4:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800fd7:	ff 4d e4             	decl   -0x1c(%ebp)
  800fda:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800fde:	7f e7                	jg     800fc7 <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  800fe0:	e9 66 01 00 00       	jmp    80114b <vprintfmt+0x3bc>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  800fe5:	83 ec 08             	sub    $0x8,%esp
  800fe8:	ff 75 e8             	pushl  -0x18(%ebp)
  800feb:	8d 45 14             	lea    0x14(%ebp),%eax
  800fee:	50                   	push   %eax
  800fef:	e8 3c fd ff ff       	call   800d30 <getint>
  800ff4:	83 c4 10             	add    $0x10,%esp
  800ff7:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800ffa:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  800ffd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801000:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801003:	85 d2                	test   %edx,%edx
  801005:	79 23                	jns    80102a <vprintfmt+0x29b>
				putch('-', putdat);
  801007:	83 ec 08             	sub    $0x8,%esp
  80100a:	ff 75 0c             	pushl  0xc(%ebp)
  80100d:	6a 2d                	push   $0x2d
  80100f:	8b 45 08             	mov    0x8(%ebp),%eax
  801012:	ff d0                	call   *%eax
  801014:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  801017:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80101a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80101d:	f7 d8                	neg    %eax
  80101f:	83 d2 00             	adc    $0x0,%edx
  801022:	f7 da                	neg    %edx
  801024:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801027:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  80102a:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  801031:	e9 bc 00 00 00       	jmp    8010f2 <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  801036:	83 ec 08             	sub    $0x8,%esp
  801039:	ff 75 e8             	pushl  -0x18(%ebp)
  80103c:	8d 45 14             	lea    0x14(%ebp),%eax
  80103f:	50                   	push   %eax
  801040:	e8 84 fc ff ff       	call   800cc9 <getuint>
  801045:	83 c4 10             	add    $0x10,%esp
  801048:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80104b:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  80104e:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  801055:	e9 98 00 00 00       	jmp    8010f2 <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  80105a:	83 ec 08             	sub    $0x8,%esp
  80105d:	ff 75 0c             	pushl  0xc(%ebp)
  801060:	6a 58                	push   $0x58
  801062:	8b 45 08             	mov    0x8(%ebp),%eax
  801065:	ff d0                	call   *%eax
  801067:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  80106a:	83 ec 08             	sub    $0x8,%esp
  80106d:	ff 75 0c             	pushl  0xc(%ebp)
  801070:	6a 58                	push   $0x58
  801072:	8b 45 08             	mov    0x8(%ebp),%eax
  801075:	ff d0                	call   *%eax
  801077:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  80107a:	83 ec 08             	sub    $0x8,%esp
  80107d:	ff 75 0c             	pushl  0xc(%ebp)
  801080:	6a 58                	push   $0x58
  801082:	8b 45 08             	mov    0x8(%ebp),%eax
  801085:	ff d0                	call   *%eax
  801087:	83 c4 10             	add    $0x10,%esp
			break;
  80108a:	e9 bc 00 00 00       	jmp    80114b <vprintfmt+0x3bc>

		// pointer
		case 'p':
			putch('0', putdat);
  80108f:	83 ec 08             	sub    $0x8,%esp
  801092:	ff 75 0c             	pushl  0xc(%ebp)
  801095:	6a 30                	push   $0x30
  801097:	8b 45 08             	mov    0x8(%ebp),%eax
  80109a:	ff d0                	call   *%eax
  80109c:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  80109f:	83 ec 08             	sub    $0x8,%esp
  8010a2:	ff 75 0c             	pushl  0xc(%ebp)
  8010a5:	6a 78                	push   $0x78
  8010a7:	8b 45 08             	mov    0x8(%ebp),%eax
  8010aa:	ff d0                	call   *%eax
  8010ac:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  8010af:	8b 45 14             	mov    0x14(%ebp),%eax
  8010b2:	83 c0 04             	add    $0x4,%eax
  8010b5:	89 45 14             	mov    %eax,0x14(%ebp)
  8010b8:	8b 45 14             	mov    0x14(%ebp),%eax
  8010bb:	83 e8 04             	sub    $0x4,%eax
  8010be:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  8010c0:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8010c3:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  8010ca:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  8010d1:	eb 1f                	jmp    8010f2 <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  8010d3:	83 ec 08             	sub    $0x8,%esp
  8010d6:	ff 75 e8             	pushl  -0x18(%ebp)
  8010d9:	8d 45 14             	lea    0x14(%ebp),%eax
  8010dc:	50                   	push   %eax
  8010dd:	e8 e7 fb ff ff       	call   800cc9 <getuint>
  8010e2:	83 c4 10             	add    $0x10,%esp
  8010e5:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8010e8:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  8010eb:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  8010f2:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  8010f6:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8010f9:	83 ec 04             	sub    $0x4,%esp
  8010fc:	52                   	push   %edx
  8010fd:	ff 75 e4             	pushl  -0x1c(%ebp)
  801100:	50                   	push   %eax
  801101:	ff 75 f4             	pushl  -0xc(%ebp)
  801104:	ff 75 f0             	pushl  -0x10(%ebp)
  801107:	ff 75 0c             	pushl  0xc(%ebp)
  80110a:	ff 75 08             	pushl  0x8(%ebp)
  80110d:	e8 00 fb ff ff       	call   800c12 <printnum>
  801112:	83 c4 20             	add    $0x20,%esp
			break;
  801115:	eb 34                	jmp    80114b <vprintfmt+0x3bc>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  801117:	83 ec 08             	sub    $0x8,%esp
  80111a:	ff 75 0c             	pushl  0xc(%ebp)
  80111d:	53                   	push   %ebx
  80111e:	8b 45 08             	mov    0x8(%ebp),%eax
  801121:	ff d0                	call   *%eax
  801123:	83 c4 10             	add    $0x10,%esp
			break;
  801126:	eb 23                	jmp    80114b <vprintfmt+0x3bc>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  801128:	83 ec 08             	sub    $0x8,%esp
  80112b:	ff 75 0c             	pushl  0xc(%ebp)
  80112e:	6a 25                	push   $0x25
  801130:	8b 45 08             	mov    0x8(%ebp),%eax
  801133:	ff d0                	call   *%eax
  801135:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  801138:	ff 4d 10             	decl   0x10(%ebp)
  80113b:	eb 03                	jmp    801140 <vprintfmt+0x3b1>
  80113d:	ff 4d 10             	decl   0x10(%ebp)
  801140:	8b 45 10             	mov    0x10(%ebp),%eax
  801143:	48                   	dec    %eax
  801144:	8a 00                	mov    (%eax),%al
  801146:	3c 25                	cmp    $0x25,%al
  801148:	75 f3                	jne    80113d <vprintfmt+0x3ae>
				/* do nothing */;
			break;
  80114a:	90                   	nop
		}
	}
  80114b:	e9 47 fc ff ff       	jmp    800d97 <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  801150:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  801151:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801154:	5b                   	pop    %ebx
  801155:	5e                   	pop    %esi
  801156:	5d                   	pop    %ebp
  801157:	c3                   	ret    

00801158 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  801158:	55                   	push   %ebp
  801159:	89 e5                	mov    %esp,%ebp
  80115b:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  80115e:	8d 45 10             	lea    0x10(%ebp),%eax
  801161:	83 c0 04             	add    $0x4,%eax
  801164:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  801167:	8b 45 10             	mov    0x10(%ebp),%eax
  80116a:	ff 75 f4             	pushl  -0xc(%ebp)
  80116d:	50                   	push   %eax
  80116e:	ff 75 0c             	pushl  0xc(%ebp)
  801171:	ff 75 08             	pushl  0x8(%ebp)
  801174:	e8 16 fc ff ff       	call   800d8f <vprintfmt>
  801179:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  80117c:	90                   	nop
  80117d:	c9                   	leave  
  80117e:	c3                   	ret    

0080117f <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  80117f:	55                   	push   %ebp
  801180:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  801182:	8b 45 0c             	mov    0xc(%ebp),%eax
  801185:	8b 40 08             	mov    0x8(%eax),%eax
  801188:	8d 50 01             	lea    0x1(%eax),%edx
  80118b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80118e:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  801191:	8b 45 0c             	mov    0xc(%ebp),%eax
  801194:	8b 10                	mov    (%eax),%edx
  801196:	8b 45 0c             	mov    0xc(%ebp),%eax
  801199:	8b 40 04             	mov    0x4(%eax),%eax
  80119c:	39 c2                	cmp    %eax,%edx
  80119e:	73 12                	jae    8011b2 <sprintputch+0x33>
		*b->buf++ = ch;
  8011a0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011a3:	8b 00                	mov    (%eax),%eax
  8011a5:	8d 48 01             	lea    0x1(%eax),%ecx
  8011a8:	8b 55 0c             	mov    0xc(%ebp),%edx
  8011ab:	89 0a                	mov    %ecx,(%edx)
  8011ad:	8b 55 08             	mov    0x8(%ebp),%edx
  8011b0:	88 10                	mov    %dl,(%eax)
}
  8011b2:	90                   	nop
  8011b3:	5d                   	pop    %ebp
  8011b4:	c3                   	ret    

008011b5 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  8011b5:	55                   	push   %ebp
  8011b6:	89 e5                	mov    %esp,%ebp
  8011b8:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  8011bb:	8b 45 08             	mov    0x8(%ebp),%eax
  8011be:	89 45 ec             	mov    %eax,-0x14(%ebp)
  8011c1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011c4:	8d 50 ff             	lea    -0x1(%eax),%edx
  8011c7:	8b 45 08             	mov    0x8(%ebp),%eax
  8011ca:	01 d0                	add    %edx,%eax
  8011cc:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8011cf:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  8011d6:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8011da:	74 06                	je     8011e2 <vsnprintf+0x2d>
  8011dc:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8011e0:	7f 07                	jg     8011e9 <vsnprintf+0x34>
		return -E_INVAL;
  8011e2:	b8 03 00 00 00       	mov    $0x3,%eax
  8011e7:	eb 20                	jmp    801209 <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  8011e9:	ff 75 14             	pushl  0x14(%ebp)
  8011ec:	ff 75 10             	pushl  0x10(%ebp)
  8011ef:	8d 45 ec             	lea    -0x14(%ebp),%eax
  8011f2:	50                   	push   %eax
  8011f3:	68 7f 11 80 00       	push   $0x80117f
  8011f8:	e8 92 fb ff ff       	call   800d8f <vprintfmt>
  8011fd:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  801200:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801203:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  801206:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  801209:	c9                   	leave  
  80120a:	c3                   	ret    

0080120b <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  80120b:	55                   	push   %ebp
  80120c:	89 e5                	mov    %esp,%ebp
  80120e:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  801211:	8d 45 10             	lea    0x10(%ebp),%eax
  801214:	83 c0 04             	add    $0x4,%eax
  801217:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  80121a:	8b 45 10             	mov    0x10(%ebp),%eax
  80121d:	ff 75 f4             	pushl  -0xc(%ebp)
  801220:	50                   	push   %eax
  801221:	ff 75 0c             	pushl  0xc(%ebp)
  801224:	ff 75 08             	pushl  0x8(%ebp)
  801227:	e8 89 ff ff ff       	call   8011b5 <vsnprintf>
  80122c:	83 c4 10             	add    $0x10,%esp
  80122f:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  801232:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801235:	c9                   	leave  
  801236:	c3                   	ret    

00801237 <readline>:
#include <inc/lib.h>

//static char buf[BUFLEN];

void readline(const char *prompt, char* buf)
{
  801237:	55                   	push   %ebp
  801238:	89 e5                	mov    %esp,%ebp
  80123a:	83 ec 18             	sub    $0x18,%esp
		int i, c, echoing;

	if (prompt != NULL)
  80123d:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801241:	74 13                	je     801256 <readline+0x1f>
		cprintf("%s", prompt);
  801243:	83 ec 08             	sub    $0x8,%esp
  801246:	ff 75 08             	pushl  0x8(%ebp)
  801249:	68 d0 40 80 00       	push   $0x8040d0
  80124e:	e8 62 f9 ff ff       	call   800bb5 <cprintf>
  801253:	83 c4 10             	add    $0x10,%esp

	i = 0;
  801256:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	echoing = iscons(0);
  80125d:	83 ec 0c             	sub    $0xc,%esp
  801260:	6a 00                	push   $0x0
  801262:	e8 54 f5 ff ff       	call   8007bb <iscons>
  801267:	83 c4 10             	add    $0x10,%esp
  80126a:	89 45 f0             	mov    %eax,-0x10(%ebp)
	while (1) {
		c = getchar();
  80126d:	e8 fb f4 ff ff       	call   80076d <getchar>
  801272:	89 45 ec             	mov    %eax,-0x14(%ebp)
		if (c < 0) {
  801275:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  801279:	79 22                	jns    80129d <readline+0x66>
			if (c != -E_EOF)
  80127b:	83 7d ec 07          	cmpl   $0x7,-0x14(%ebp)
  80127f:	0f 84 ad 00 00 00    	je     801332 <readline+0xfb>
				cprintf("read error: %e\n", c);
  801285:	83 ec 08             	sub    $0x8,%esp
  801288:	ff 75 ec             	pushl  -0x14(%ebp)
  80128b:	68 d3 40 80 00       	push   $0x8040d3
  801290:	e8 20 f9 ff ff       	call   800bb5 <cprintf>
  801295:	83 c4 10             	add    $0x10,%esp
			return;
  801298:	e9 95 00 00 00       	jmp    801332 <readline+0xfb>
		} else if (c >= ' ' && i < BUFLEN-1) {
  80129d:	83 7d ec 1f          	cmpl   $0x1f,-0x14(%ebp)
  8012a1:	7e 34                	jle    8012d7 <readline+0xa0>
  8012a3:	81 7d f4 fe 03 00 00 	cmpl   $0x3fe,-0xc(%ebp)
  8012aa:	7f 2b                	jg     8012d7 <readline+0xa0>
			if (echoing)
  8012ac:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8012b0:	74 0e                	je     8012c0 <readline+0x89>
				cputchar(c);
  8012b2:	83 ec 0c             	sub    $0xc,%esp
  8012b5:	ff 75 ec             	pushl  -0x14(%ebp)
  8012b8:	e8 68 f4 ff ff       	call   800725 <cputchar>
  8012bd:	83 c4 10             	add    $0x10,%esp
			buf[i++] = c;
  8012c0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8012c3:	8d 50 01             	lea    0x1(%eax),%edx
  8012c6:	89 55 f4             	mov    %edx,-0xc(%ebp)
  8012c9:	89 c2                	mov    %eax,%edx
  8012cb:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012ce:	01 d0                	add    %edx,%eax
  8012d0:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8012d3:	88 10                	mov    %dl,(%eax)
  8012d5:	eb 56                	jmp    80132d <readline+0xf6>
		} else if (c == '\b' && i > 0) {
  8012d7:	83 7d ec 08          	cmpl   $0x8,-0x14(%ebp)
  8012db:	75 1f                	jne    8012fc <readline+0xc5>
  8012dd:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8012e1:	7e 19                	jle    8012fc <readline+0xc5>
			if (echoing)
  8012e3:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8012e7:	74 0e                	je     8012f7 <readline+0xc0>
				cputchar(c);
  8012e9:	83 ec 0c             	sub    $0xc,%esp
  8012ec:	ff 75 ec             	pushl  -0x14(%ebp)
  8012ef:	e8 31 f4 ff ff       	call   800725 <cputchar>
  8012f4:	83 c4 10             	add    $0x10,%esp

			i--;
  8012f7:	ff 4d f4             	decl   -0xc(%ebp)
  8012fa:	eb 31                	jmp    80132d <readline+0xf6>
		} else if (c == '\n' || c == '\r') {
  8012fc:	83 7d ec 0a          	cmpl   $0xa,-0x14(%ebp)
  801300:	74 0a                	je     80130c <readline+0xd5>
  801302:	83 7d ec 0d          	cmpl   $0xd,-0x14(%ebp)
  801306:	0f 85 61 ff ff ff    	jne    80126d <readline+0x36>
			if (echoing)
  80130c:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801310:	74 0e                	je     801320 <readline+0xe9>
				cputchar(c);
  801312:	83 ec 0c             	sub    $0xc,%esp
  801315:	ff 75 ec             	pushl  -0x14(%ebp)
  801318:	e8 08 f4 ff ff       	call   800725 <cputchar>
  80131d:	83 c4 10             	add    $0x10,%esp

			buf[i] = 0;
  801320:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801323:	8b 45 0c             	mov    0xc(%ebp),%eax
  801326:	01 d0                	add    %edx,%eax
  801328:	c6 00 00             	movb   $0x0,(%eax)
			return;
  80132b:	eb 06                	jmp    801333 <readline+0xfc>
		}
	}
  80132d:	e9 3b ff ff ff       	jmp    80126d <readline+0x36>
	while (1) {
		c = getchar();
		if (c < 0) {
			if (c != -E_EOF)
				cprintf("read error: %e\n", c);
			return;
  801332:	90                   	nop
			buf[i] = 0;
			return;
		}
	}

}
  801333:	c9                   	leave  
  801334:	c3                   	ret    

00801335 <atomic_readline>:

void atomic_readline(const char *prompt, char* buf)
{
  801335:	55                   	push   %ebp
  801336:	89 e5                	mov    %esp,%ebp
  801338:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  80133b:	e8 06 0f 00 00       	call   802246 <sys_disable_interrupt>
	int i, c, echoing;

	if (prompt != NULL)
  801340:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801344:	74 13                	je     801359 <atomic_readline+0x24>
		cprintf("%s", prompt);
  801346:	83 ec 08             	sub    $0x8,%esp
  801349:	ff 75 08             	pushl  0x8(%ebp)
  80134c:	68 d0 40 80 00       	push   $0x8040d0
  801351:	e8 5f f8 ff ff       	call   800bb5 <cprintf>
  801356:	83 c4 10             	add    $0x10,%esp

	i = 0;
  801359:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	echoing = iscons(0);
  801360:	83 ec 0c             	sub    $0xc,%esp
  801363:	6a 00                	push   $0x0
  801365:	e8 51 f4 ff ff       	call   8007bb <iscons>
  80136a:	83 c4 10             	add    $0x10,%esp
  80136d:	89 45 f0             	mov    %eax,-0x10(%ebp)
	while (1) {
		c = getchar();
  801370:	e8 f8 f3 ff ff       	call   80076d <getchar>
  801375:	89 45 ec             	mov    %eax,-0x14(%ebp)
		if (c < 0) {
  801378:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  80137c:	79 23                	jns    8013a1 <atomic_readline+0x6c>
			if (c != -E_EOF)
  80137e:	83 7d ec 07          	cmpl   $0x7,-0x14(%ebp)
  801382:	74 13                	je     801397 <atomic_readline+0x62>
				cprintf("read error: %e\n", c);
  801384:	83 ec 08             	sub    $0x8,%esp
  801387:	ff 75 ec             	pushl  -0x14(%ebp)
  80138a:	68 d3 40 80 00       	push   $0x8040d3
  80138f:	e8 21 f8 ff ff       	call   800bb5 <cprintf>
  801394:	83 c4 10             	add    $0x10,%esp
			sys_enable_interrupt();
  801397:	e8 c4 0e 00 00       	call   802260 <sys_enable_interrupt>
			return;
  80139c:	e9 9a 00 00 00       	jmp    80143b <atomic_readline+0x106>
		} else if (c >= ' ' && i < BUFLEN-1) {
  8013a1:	83 7d ec 1f          	cmpl   $0x1f,-0x14(%ebp)
  8013a5:	7e 34                	jle    8013db <atomic_readline+0xa6>
  8013a7:	81 7d f4 fe 03 00 00 	cmpl   $0x3fe,-0xc(%ebp)
  8013ae:	7f 2b                	jg     8013db <atomic_readline+0xa6>
			if (echoing)
  8013b0:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8013b4:	74 0e                	je     8013c4 <atomic_readline+0x8f>
				cputchar(c);
  8013b6:	83 ec 0c             	sub    $0xc,%esp
  8013b9:	ff 75 ec             	pushl  -0x14(%ebp)
  8013bc:	e8 64 f3 ff ff       	call   800725 <cputchar>
  8013c1:	83 c4 10             	add    $0x10,%esp
			buf[i++] = c;
  8013c4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8013c7:	8d 50 01             	lea    0x1(%eax),%edx
  8013ca:	89 55 f4             	mov    %edx,-0xc(%ebp)
  8013cd:	89 c2                	mov    %eax,%edx
  8013cf:	8b 45 0c             	mov    0xc(%ebp),%eax
  8013d2:	01 d0                	add    %edx,%eax
  8013d4:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8013d7:	88 10                	mov    %dl,(%eax)
  8013d9:	eb 5b                	jmp    801436 <atomic_readline+0x101>
		} else if (c == '\b' && i > 0) {
  8013db:	83 7d ec 08          	cmpl   $0x8,-0x14(%ebp)
  8013df:	75 1f                	jne    801400 <atomic_readline+0xcb>
  8013e1:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8013e5:	7e 19                	jle    801400 <atomic_readline+0xcb>
			if (echoing)
  8013e7:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8013eb:	74 0e                	je     8013fb <atomic_readline+0xc6>
				cputchar(c);
  8013ed:	83 ec 0c             	sub    $0xc,%esp
  8013f0:	ff 75 ec             	pushl  -0x14(%ebp)
  8013f3:	e8 2d f3 ff ff       	call   800725 <cputchar>
  8013f8:	83 c4 10             	add    $0x10,%esp
			i--;
  8013fb:	ff 4d f4             	decl   -0xc(%ebp)
  8013fe:	eb 36                	jmp    801436 <atomic_readline+0x101>
		} else if (c == '\n' || c == '\r') {
  801400:	83 7d ec 0a          	cmpl   $0xa,-0x14(%ebp)
  801404:	74 0a                	je     801410 <atomic_readline+0xdb>
  801406:	83 7d ec 0d          	cmpl   $0xd,-0x14(%ebp)
  80140a:	0f 85 60 ff ff ff    	jne    801370 <atomic_readline+0x3b>
			if (echoing)
  801410:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801414:	74 0e                	je     801424 <atomic_readline+0xef>
				cputchar(c);
  801416:	83 ec 0c             	sub    $0xc,%esp
  801419:	ff 75 ec             	pushl  -0x14(%ebp)
  80141c:	e8 04 f3 ff ff       	call   800725 <cputchar>
  801421:	83 c4 10             	add    $0x10,%esp
			buf[i] = 0;
  801424:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801427:	8b 45 0c             	mov    0xc(%ebp),%eax
  80142a:	01 d0                	add    %edx,%eax
  80142c:	c6 00 00             	movb   $0x0,(%eax)
			sys_enable_interrupt();
  80142f:	e8 2c 0e 00 00       	call   802260 <sys_enable_interrupt>
			return;
  801434:	eb 05                	jmp    80143b <atomic_readline+0x106>
		}
	}
  801436:	e9 35 ff ff ff       	jmp    801370 <atomic_readline+0x3b>
}
  80143b:	c9                   	leave  
  80143c:	c3                   	ret    

0080143d <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  80143d:	55                   	push   %ebp
  80143e:	89 e5                	mov    %esp,%ebp
  801440:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  801443:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  80144a:	eb 06                	jmp    801452 <strlen+0x15>
		n++;
  80144c:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  80144f:	ff 45 08             	incl   0x8(%ebp)
  801452:	8b 45 08             	mov    0x8(%ebp),%eax
  801455:	8a 00                	mov    (%eax),%al
  801457:	84 c0                	test   %al,%al
  801459:	75 f1                	jne    80144c <strlen+0xf>
		n++;
	return n;
  80145b:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  80145e:	c9                   	leave  
  80145f:	c3                   	ret    

00801460 <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  801460:	55                   	push   %ebp
  801461:	89 e5                	mov    %esp,%ebp
  801463:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  801466:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  80146d:	eb 09                	jmp    801478 <strnlen+0x18>
		n++;
  80146f:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  801472:	ff 45 08             	incl   0x8(%ebp)
  801475:	ff 4d 0c             	decl   0xc(%ebp)
  801478:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80147c:	74 09                	je     801487 <strnlen+0x27>
  80147e:	8b 45 08             	mov    0x8(%ebp),%eax
  801481:	8a 00                	mov    (%eax),%al
  801483:	84 c0                	test   %al,%al
  801485:	75 e8                	jne    80146f <strnlen+0xf>
		n++;
	return n;
  801487:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  80148a:	c9                   	leave  
  80148b:	c3                   	ret    

0080148c <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  80148c:	55                   	push   %ebp
  80148d:	89 e5                	mov    %esp,%ebp
  80148f:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  801492:	8b 45 08             	mov    0x8(%ebp),%eax
  801495:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  801498:	90                   	nop
  801499:	8b 45 08             	mov    0x8(%ebp),%eax
  80149c:	8d 50 01             	lea    0x1(%eax),%edx
  80149f:	89 55 08             	mov    %edx,0x8(%ebp)
  8014a2:	8b 55 0c             	mov    0xc(%ebp),%edx
  8014a5:	8d 4a 01             	lea    0x1(%edx),%ecx
  8014a8:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  8014ab:	8a 12                	mov    (%edx),%dl
  8014ad:	88 10                	mov    %dl,(%eax)
  8014af:	8a 00                	mov    (%eax),%al
  8014b1:	84 c0                	test   %al,%al
  8014b3:	75 e4                	jne    801499 <strcpy+0xd>
		/* do nothing */;
	return ret;
  8014b5:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  8014b8:	c9                   	leave  
  8014b9:	c3                   	ret    

008014ba <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  8014ba:	55                   	push   %ebp
  8014bb:	89 e5                	mov    %esp,%ebp
  8014bd:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  8014c0:	8b 45 08             	mov    0x8(%ebp),%eax
  8014c3:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  8014c6:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8014cd:	eb 1f                	jmp    8014ee <strncpy+0x34>
		*dst++ = *src;
  8014cf:	8b 45 08             	mov    0x8(%ebp),%eax
  8014d2:	8d 50 01             	lea    0x1(%eax),%edx
  8014d5:	89 55 08             	mov    %edx,0x8(%ebp)
  8014d8:	8b 55 0c             	mov    0xc(%ebp),%edx
  8014db:	8a 12                	mov    (%edx),%dl
  8014dd:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  8014df:	8b 45 0c             	mov    0xc(%ebp),%eax
  8014e2:	8a 00                	mov    (%eax),%al
  8014e4:	84 c0                	test   %al,%al
  8014e6:	74 03                	je     8014eb <strncpy+0x31>
			src++;
  8014e8:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  8014eb:	ff 45 fc             	incl   -0x4(%ebp)
  8014ee:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8014f1:	3b 45 10             	cmp    0x10(%ebp),%eax
  8014f4:	72 d9                	jb     8014cf <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  8014f6:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  8014f9:	c9                   	leave  
  8014fa:	c3                   	ret    

008014fb <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  8014fb:	55                   	push   %ebp
  8014fc:	89 e5                	mov    %esp,%ebp
  8014fe:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  801501:	8b 45 08             	mov    0x8(%ebp),%eax
  801504:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  801507:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80150b:	74 30                	je     80153d <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  80150d:	eb 16                	jmp    801525 <strlcpy+0x2a>
			*dst++ = *src++;
  80150f:	8b 45 08             	mov    0x8(%ebp),%eax
  801512:	8d 50 01             	lea    0x1(%eax),%edx
  801515:	89 55 08             	mov    %edx,0x8(%ebp)
  801518:	8b 55 0c             	mov    0xc(%ebp),%edx
  80151b:	8d 4a 01             	lea    0x1(%edx),%ecx
  80151e:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  801521:	8a 12                	mov    (%edx),%dl
  801523:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  801525:	ff 4d 10             	decl   0x10(%ebp)
  801528:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80152c:	74 09                	je     801537 <strlcpy+0x3c>
  80152e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801531:	8a 00                	mov    (%eax),%al
  801533:	84 c0                	test   %al,%al
  801535:	75 d8                	jne    80150f <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  801537:	8b 45 08             	mov    0x8(%ebp),%eax
  80153a:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  80153d:	8b 55 08             	mov    0x8(%ebp),%edx
  801540:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801543:	29 c2                	sub    %eax,%edx
  801545:	89 d0                	mov    %edx,%eax
}
  801547:	c9                   	leave  
  801548:	c3                   	ret    

00801549 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  801549:	55                   	push   %ebp
  80154a:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  80154c:	eb 06                	jmp    801554 <strcmp+0xb>
		p++, q++;
  80154e:	ff 45 08             	incl   0x8(%ebp)
  801551:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  801554:	8b 45 08             	mov    0x8(%ebp),%eax
  801557:	8a 00                	mov    (%eax),%al
  801559:	84 c0                	test   %al,%al
  80155b:	74 0e                	je     80156b <strcmp+0x22>
  80155d:	8b 45 08             	mov    0x8(%ebp),%eax
  801560:	8a 10                	mov    (%eax),%dl
  801562:	8b 45 0c             	mov    0xc(%ebp),%eax
  801565:	8a 00                	mov    (%eax),%al
  801567:	38 c2                	cmp    %al,%dl
  801569:	74 e3                	je     80154e <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  80156b:	8b 45 08             	mov    0x8(%ebp),%eax
  80156e:	8a 00                	mov    (%eax),%al
  801570:	0f b6 d0             	movzbl %al,%edx
  801573:	8b 45 0c             	mov    0xc(%ebp),%eax
  801576:	8a 00                	mov    (%eax),%al
  801578:	0f b6 c0             	movzbl %al,%eax
  80157b:	29 c2                	sub    %eax,%edx
  80157d:	89 d0                	mov    %edx,%eax
}
  80157f:	5d                   	pop    %ebp
  801580:	c3                   	ret    

00801581 <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  801581:	55                   	push   %ebp
  801582:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  801584:	eb 09                	jmp    80158f <strncmp+0xe>
		n--, p++, q++;
  801586:	ff 4d 10             	decl   0x10(%ebp)
  801589:	ff 45 08             	incl   0x8(%ebp)
  80158c:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  80158f:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801593:	74 17                	je     8015ac <strncmp+0x2b>
  801595:	8b 45 08             	mov    0x8(%ebp),%eax
  801598:	8a 00                	mov    (%eax),%al
  80159a:	84 c0                	test   %al,%al
  80159c:	74 0e                	je     8015ac <strncmp+0x2b>
  80159e:	8b 45 08             	mov    0x8(%ebp),%eax
  8015a1:	8a 10                	mov    (%eax),%dl
  8015a3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8015a6:	8a 00                	mov    (%eax),%al
  8015a8:	38 c2                	cmp    %al,%dl
  8015aa:	74 da                	je     801586 <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  8015ac:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8015b0:	75 07                	jne    8015b9 <strncmp+0x38>
		return 0;
  8015b2:	b8 00 00 00 00       	mov    $0x0,%eax
  8015b7:	eb 14                	jmp    8015cd <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  8015b9:	8b 45 08             	mov    0x8(%ebp),%eax
  8015bc:	8a 00                	mov    (%eax),%al
  8015be:	0f b6 d0             	movzbl %al,%edx
  8015c1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8015c4:	8a 00                	mov    (%eax),%al
  8015c6:	0f b6 c0             	movzbl %al,%eax
  8015c9:	29 c2                	sub    %eax,%edx
  8015cb:	89 d0                	mov    %edx,%eax
}
  8015cd:	5d                   	pop    %ebp
  8015ce:	c3                   	ret    

008015cf <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  8015cf:	55                   	push   %ebp
  8015d0:	89 e5                	mov    %esp,%ebp
  8015d2:	83 ec 04             	sub    $0x4,%esp
  8015d5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8015d8:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  8015db:	eb 12                	jmp    8015ef <strchr+0x20>
		if (*s == c)
  8015dd:	8b 45 08             	mov    0x8(%ebp),%eax
  8015e0:	8a 00                	mov    (%eax),%al
  8015e2:	3a 45 fc             	cmp    -0x4(%ebp),%al
  8015e5:	75 05                	jne    8015ec <strchr+0x1d>
			return (char *) s;
  8015e7:	8b 45 08             	mov    0x8(%ebp),%eax
  8015ea:	eb 11                	jmp    8015fd <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  8015ec:	ff 45 08             	incl   0x8(%ebp)
  8015ef:	8b 45 08             	mov    0x8(%ebp),%eax
  8015f2:	8a 00                	mov    (%eax),%al
  8015f4:	84 c0                	test   %al,%al
  8015f6:	75 e5                	jne    8015dd <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  8015f8:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8015fd:	c9                   	leave  
  8015fe:	c3                   	ret    

008015ff <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  8015ff:	55                   	push   %ebp
  801600:	89 e5                	mov    %esp,%ebp
  801602:	83 ec 04             	sub    $0x4,%esp
  801605:	8b 45 0c             	mov    0xc(%ebp),%eax
  801608:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  80160b:	eb 0d                	jmp    80161a <strfind+0x1b>
		if (*s == c)
  80160d:	8b 45 08             	mov    0x8(%ebp),%eax
  801610:	8a 00                	mov    (%eax),%al
  801612:	3a 45 fc             	cmp    -0x4(%ebp),%al
  801615:	74 0e                	je     801625 <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  801617:	ff 45 08             	incl   0x8(%ebp)
  80161a:	8b 45 08             	mov    0x8(%ebp),%eax
  80161d:	8a 00                	mov    (%eax),%al
  80161f:	84 c0                	test   %al,%al
  801621:	75 ea                	jne    80160d <strfind+0xe>
  801623:	eb 01                	jmp    801626 <strfind+0x27>
		if (*s == c)
			break;
  801625:	90                   	nop
	return (char *) s;
  801626:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801629:	c9                   	leave  
  80162a:	c3                   	ret    

0080162b <memset>:


void *
memset(void *v, int c, uint32 n)
{
  80162b:	55                   	push   %ebp
  80162c:	89 e5                	mov    %esp,%ebp
  80162e:	83 ec 10             	sub    $0x10,%esp
	char *p;
	int m;

	p = v;
  801631:	8b 45 08             	mov    0x8(%ebp),%eax
  801634:	89 45 fc             	mov    %eax,-0x4(%ebp)
	m = n;
  801637:	8b 45 10             	mov    0x10(%ebp),%eax
  80163a:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (--m >= 0)
  80163d:	eb 0e                	jmp    80164d <memset+0x22>
		*p++ = c;
  80163f:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801642:	8d 50 01             	lea    0x1(%eax),%edx
  801645:	89 55 fc             	mov    %edx,-0x4(%ebp)
  801648:	8b 55 0c             	mov    0xc(%ebp),%edx
  80164b:	88 10                	mov    %dl,(%eax)
	char *p;
	int m;

	p = v;
	m = n;
	while (--m >= 0)
  80164d:	ff 4d f8             	decl   -0x8(%ebp)
  801650:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  801654:	79 e9                	jns    80163f <memset+0x14>
		*p++ = c;

	return v;
  801656:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801659:	c9                   	leave  
  80165a:	c3                   	ret    

0080165b <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  80165b:	55                   	push   %ebp
  80165c:	89 e5                	mov    %esp,%ebp
  80165e:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  801661:	8b 45 0c             	mov    0xc(%ebp),%eax
  801664:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  801667:	8b 45 08             	mov    0x8(%ebp),%eax
  80166a:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (n-- > 0)
  80166d:	eb 16                	jmp    801685 <memcpy+0x2a>
		*d++ = *s++;
  80166f:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801672:	8d 50 01             	lea    0x1(%eax),%edx
  801675:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801678:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80167b:	8d 4a 01             	lea    0x1(%edx),%ecx
  80167e:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  801681:	8a 12                	mov    (%edx),%dl
  801683:	88 10                	mov    %dl,(%eax)
	const char *s;
	char *d;

	s = src;
	d = dst;
	while (n-- > 0)
  801685:	8b 45 10             	mov    0x10(%ebp),%eax
  801688:	8d 50 ff             	lea    -0x1(%eax),%edx
  80168b:	89 55 10             	mov    %edx,0x10(%ebp)
  80168e:	85 c0                	test   %eax,%eax
  801690:	75 dd                	jne    80166f <memcpy+0x14>
		*d++ = *s++;

	return dst;
  801692:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801695:	c9                   	leave  
  801696:	c3                   	ret    

00801697 <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  801697:	55                   	push   %ebp
  801698:	89 e5                	mov    %esp,%ebp
  80169a:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  80169d:	8b 45 0c             	mov    0xc(%ebp),%eax
  8016a0:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  8016a3:	8b 45 08             	mov    0x8(%ebp),%eax
  8016a6:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  8016a9:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8016ac:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  8016af:	73 50                	jae    801701 <memmove+0x6a>
  8016b1:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8016b4:	8b 45 10             	mov    0x10(%ebp),%eax
  8016b7:	01 d0                	add    %edx,%eax
  8016b9:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  8016bc:	76 43                	jbe    801701 <memmove+0x6a>
		s += n;
  8016be:	8b 45 10             	mov    0x10(%ebp),%eax
  8016c1:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  8016c4:	8b 45 10             	mov    0x10(%ebp),%eax
  8016c7:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  8016ca:	eb 10                	jmp    8016dc <memmove+0x45>
			*--d = *--s;
  8016cc:	ff 4d f8             	decl   -0x8(%ebp)
  8016cf:	ff 4d fc             	decl   -0x4(%ebp)
  8016d2:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8016d5:	8a 10                	mov    (%eax),%dl
  8016d7:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8016da:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  8016dc:	8b 45 10             	mov    0x10(%ebp),%eax
  8016df:	8d 50 ff             	lea    -0x1(%eax),%edx
  8016e2:	89 55 10             	mov    %edx,0x10(%ebp)
  8016e5:	85 c0                	test   %eax,%eax
  8016e7:	75 e3                	jne    8016cc <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  8016e9:	eb 23                	jmp    80170e <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  8016eb:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8016ee:	8d 50 01             	lea    0x1(%eax),%edx
  8016f1:	89 55 f8             	mov    %edx,-0x8(%ebp)
  8016f4:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8016f7:	8d 4a 01             	lea    0x1(%edx),%ecx
  8016fa:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  8016fd:	8a 12                	mov    (%edx),%dl
  8016ff:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  801701:	8b 45 10             	mov    0x10(%ebp),%eax
  801704:	8d 50 ff             	lea    -0x1(%eax),%edx
  801707:	89 55 10             	mov    %edx,0x10(%ebp)
  80170a:	85 c0                	test   %eax,%eax
  80170c:	75 dd                	jne    8016eb <memmove+0x54>
			*d++ = *s++;

	return dst;
  80170e:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801711:	c9                   	leave  
  801712:	c3                   	ret    

00801713 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  801713:	55                   	push   %ebp
  801714:	89 e5                	mov    %esp,%ebp
  801716:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  801719:	8b 45 08             	mov    0x8(%ebp),%eax
  80171c:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  80171f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801722:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  801725:	eb 2a                	jmp    801751 <memcmp+0x3e>
		if (*s1 != *s2)
  801727:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80172a:	8a 10                	mov    (%eax),%dl
  80172c:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80172f:	8a 00                	mov    (%eax),%al
  801731:	38 c2                	cmp    %al,%dl
  801733:	74 16                	je     80174b <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  801735:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801738:	8a 00                	mov    (%eax),%al
  80173a:	0f b6 d0             	movzbl %al,%edx
  80173d:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801740:	8a 00                	mov    (%eax),%al
  801742:	0f b6 c0             	movzbl %al,%eax
  801745:	29 c2                	sub    %eax,%edx
  801747:	89 d0                	mov    %edx,%eax
  801749:	eb 18                	jmp    801763 <memcmp+0x50>
		s1++, s2++;
  80174b:	ff 45 fc             	incl   -0x4(%ebp)
  80174e:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  801751:	8b 45 10             	mov    0x10(%ebp),%eax
  801754:	8d 50 ff             	lea    -0x1(%eax),%edx
  801757:	89 55 10             	mov    %edx,0x10(%ebp)
  80175a:	85 c0                	test   %eax,%eax
  80175c:	75 c9                	jne    801727 <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  80175e:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801763:	c9                   	leave  
  801764:	c3                   	ret    

00801765 <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  801765:	55                   	push   %ebp
  801766:	89 e5                	mov    %esp,%ebp
  801768:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  80176b:	8b 55 08             	mov    0x8(%ebp),%edx
  80176e:	8b 45 10             	mov    0x10(%ebp),%eax
  801771:	01 d0                	add    %edx,%eax
  801773:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  801776:	eb 15                	jmp    80178d <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  801778:	8b 45 08             	mov    0x8(%ebp),%eax
  80177b:	8a 00                	mov    (%eax),%al
  80177d:	0f b6 d0             	movzbl %al,%edx
  801780:	8b 45 0c             	mov    0xc(%ebp),%eax
  801783:	0f b6 c0             	movzbl %al,%eax
  801786:	39 c2                	cmp    %eax,%edx
  801788:	74 0d                	je     801797 <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  80178a:	ff 45 08             	incl   0x8(%ebp)
  80178d:	8b 45 08             	mov    0x8(%ebp),%eax
  801790:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  801793:	72 e3                	jb     801778 <memfind+0x13>
  801795:	eb 01                	jmp    801798 <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  801797:	90                   	nop
	return (void *) s;
  801798:	8b 45 08             	mov    0x8(%ebp),%eax
}
  80179b:	c9                   	leave  
  80179c:	c3                   	ret    

0080179d <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  80179d:	55                   	push   %ebp
  80179e:	89 e5                	mov    %esp,%ebp
  8017a0:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  8017a3:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  8017aa:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  8017b1:	eb 03                	jmp    8017b6 <strtol+0x19>
		s++;
  8017b3:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  8017b6:	8b 45 08             	mov    0x8(%ebp),%eax
  8017b9:	8a 00                	mov    (%eax),%al
  8017bb:	3c 20                	cmp    $0x20,%al
  8017bd:	74 f4                	je     8017b3 <strtol+0x16>
  8017bf:	8b 45 08             	mov    0x8(%ebp),%eax
  8017c2:	8a 00                	mov    (%eax),%al
  8017c4:	3c 09                	cmp    $0x9,%al
  8017c6:	74 eb                	je     8017b3 <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  8017c8:	8b 45 08             	mov    0x8(%ebp),%eax
  8017cb:	8a 00                	mov    (%eax),%al
  8017cd:	3c 2b                	cmp    $0x2b,%al
  8017cf:	75 05                	jne    8017d6 <strtol+0x39>
		s++;
  8017d1:	ff 45 08             	incl   0x8(%ebp)
  8017d4:	eb 13                	jmp    8017e9 <strtol+0x4c>
	else if (*s == '-')
  8017d6:	8b 45 08             	mov    0x8(%ebp),%eax
  8017d9:	8a 00                	mov    (%eax),%al
  8017db:	3c 2d                	cmp    $0x2d,%al
  8017dd:	75 0a                	jne    8017e9 <strtol+0x4c>
		s++, neg = 1;
  8017df:	ff 45 08             	incl   0x8(%ebp)
  8017e2:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  8017e9:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8017ed:	74 06                	je     8017f5 <strtol+0x58>
  8017ef:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  8017f3:	75 20                	jne    801815 <strtol+0x78>
  8017f5:	8b 45 08             	mov    0x8(%ebp),%eax
  8017f8:	8a 00                	mov    (%eax),%al
  8017fa:	3c 30                	cmp    $0x30,%al
  8017fc:	75 17                	jne    801815 <strtol+0x78>
  8017fe:	8b 45 08             	mov    0x8(%ebp),%eax
  801801:	40                   	inc    %eax
  801802:	8a 00                	mov    (%eax),%al
  801804:	3c 78                	cmp    $0x78,%al
  801806:	75 0d                	jne    801815 <strtol+0x78>
		s += 2, base = 16;
  801808:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  80180c:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  801813:	eb 28                	jmp    80183d <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  801815:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801819:	75 15                	jne    801830 <strtol+0x93>
  80181b:	8b 45 08             	mov    0x8(%ebp),%eax
  80181e:	8a 00                	mov    (%eax),%al
  801820:	3c 30                	cmp    $0x30,%al
  801822:	75 0c                	jne    801830 <strtol+0x93>
		s++, base = 8;
  801824:	ff 45 08             	incl   0x8(%ebp)
  801827:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  80182e:	eb 0d                	jmp    80183d <strtol+0xa0>
	else if (base == 0)
  801830:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801834:	75 07                	jne    80183d <strtol+0xa0>
		base = 10;
  801836:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  80183d:	8b 45 08             	mov    0x8(%ebp),%eax
  801840:	8a 00                	mov    (%eax),%al
  801842:	3c 2f                	cmp    $0x2f,%al
  801844:	7e 19                	jle    80185f <strtol+0xc2>
  801846:	8b 45 08             	mov    0x8(%ebp),%eax
  801849:	8a 00                	mov    (%eax),%al
  80184b:	3c 39                	cmp    $0x39,%al
  80184d:	7f 10                	jg     80185f <strtol+0xc2>
			dig = *s - '0';
  80184f:	8b 45 08             	mov    0x8(%ebp),%eax
  801852:	8a 00                	mov    (%eax),%al
  801854:	0f be c0             	movsbl %al,%eax
  801857:	83 e8 30             	sub    $0x30,%eax
  80185a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80185d:	eb 42                	jmp    8018a1 <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  80185f:	8b 45 08             	mov    0x8(%ebp),%eax
  801862:	8a 00                	mov    (%eax),%al
  801864:	3c 60                	cmp    $0x60,%al
  801866:	7e 19                	jle    801881 <strtol+0xe4>
  801868:	8b 45 08             	mov    0x8(%ebp),%eax
  80186b:	8a 00                	mov    (%eax),%al
  80186d:	3c 7a                	cmp    $0x7a,%al
  80186f:	7f 10                	jg     801881 <strtol+0xe4>
			dig = *s - 'a' + 10;
  801871:	8b 45 08             	mov    0x8(%ebp),%eax
  801874:	8a 00                	mov    (%eax),%al
  801876:	0f be c0             	movsbl %al,%eax
  801879:	83 e8 57             	sub    $0x57,%eax
  80187c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80187f:	eb 20                	jmp    8018a1 <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  801881:	8b 45 08             	mov    0x8(%ebp),%eax
  801884:	8a 00                	mov    (%eax),%al
  801886:	3c 40                	cmp    $0x40,%al
  801888:	7e 39                	jle    8018c3 <strtol+0x126>
  80188a:	8b 45 08             	mov    0x8(%ebp),%eax
  80188d:	8a 00                	mov    (%eax),%al
  80188f:	3c 5a                	cmp    $0x5a,%al
  801891:	7f 30                	jg     8018c3 <strtol+0x126>
			dig = *s - 'A' + 10;
  801893:	8b 45 08             	mov    0x8(%ebp),%eax
  801896:	8a 00                	mov    (%eax),%al
  801898:	0f be c0             	movsbl %al,%eax
  80189b:	83 e8 37             	sub    $0x37,%eax
  80189e:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  8018a1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8018a4:	3b 45 10             	cmp    0x10(%ebp),%eax
  8018a7:	7d 19                	jge    8018c2 <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  8018a9:	ff 45 08             	incl   0x8(%ebp)
  8018ac:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8018af:	0f af 45 10          	imul   0x10(%ebp),%eax
  8018b3:	89 c2                	mov    %eax,%edx
  8018b5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8018b8:	01 d0                	add    %edx,%eax
  8018ba:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  8018bd:	e9 7b ff ff ff       	jmp    80183d <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  8018c2:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  8018c3:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8018c7:	74 08                	je     8018d1 <strtol+0x134>
		*endptr = (char *) s;
  8018c9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8018cc:	8b 55 08             	mov    0x8(%ebp),%edx
  8018cf:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  8018d1:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8018d5:	74 07                	je     8018de <strtol+0x141>
  8018d7:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8018da:	f7 d8                	neg    %eax
  8018dc:	eb 03                	jmp    8018e1 <strtol+0x144>
  8018de:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  8018e1:	c9                   	leave  
  8018e2:	c3                   	ret    

008018e3 <ltostr>:

void
ltostr(long value, char *str)
{
  8018e3:	55                   	push   %ebp
  8018e4:	89 e5                	mov    %esp,%ebp
  8018e6:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  8018e9:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  8018f0:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  8018f7:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8018fb:	79 13                	jns    801910 <ltostr+0x2d>
	{
		neg = 1;
  8018fd:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  801904:	8b 45 0c             	mov    0xc(%ebp),%eax
  801907:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  80190a:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  80190d:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  801910:	8b 45 08             	mov    0x8(%ebp),%eax
  801913:	b9 0a 00 00 00       	mov    $0xa,%ecx
  801918:	99                   	cltd   
  801919:	f7 f9                	idiv   %ecx
  80191b:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  80191e:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801921:	8d 50 01             	lea    0x1(%eax),%edx
  801924:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801927:	89 c2                	mov    %eax,%edx
  801929:	8b 45 0c             	mov    0xc(%ebp),%eax
  80192c:	01 d0                	add    %edx,%eax
  80192e:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801931:	83 c2 30             	add    $0x30,%edx
  801934:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  801936:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801939:	b8 67 66 66 66       	mov    $0x66666667,%eax
  80193e:	f7 e9                	imul   %ecx
  801940:	c1 fa 02             	sar    $0x2,%edx
  801943:	89 c8                	mov    %ecx,%eax
  801945:	c1 f8 1f             	sar    $0x1f,%eax
  801948:	29 c2                	sub    %eax,%edx
  80194a:	89 d0                	mov    %edx,%eax
  80194c:	89 45 08             	mov    %eax,0x8(%ebp)
	} while (value % 10 != 0);
  80194f:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801952:	b8 67 66 66 66       	mov    $0x66666667,%eax
  801957:	f7 e9                	imul   %ecx
  801959:	c1 fa 02             	sar    $0x2,%edx
  80195c:	89 c8                	mov    %ecx,%eax
  80195e:	c1 f8 1f             	sar    $0x1f,%eax
  801961:	29 c2                	sub    %eax,%edx
  801963:	89 d0                	mov    %edx,%eax
  801965:	c1 e0 02             	shl    $0x2,%eax
  801968:	01 d0                	add    %edx,%eax
  80196a:	01 c0                	add    %eax,%eax
  80196c:	29 c1                	sub    %eax,%ecx
  80196e:	89 ca                	mov    %ecx,%edx
  801970:	85 d2                	test   %edx,%edx
  801972:	75 9c                	jne    801910 <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  801974:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  80197b:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80197e:	48                   	dec    %eax
  80197f:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  801982:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801986:	74 3d                	je     8019c5 <ltostr+0xe2>
		start = 1 ;
  801988:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  80198f:	eb 34                	jmp    8019c5 <ltostr+0xe2>
	{
		char tmp = str[start] ;
  801991:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801994:	8b 45 0c             	mov    0xc(%ebp),%eax
  801997:	01 d0                	add    %edx,%eax
  801999:	8a 00                	mov    (%eax),%al
  80199b:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  80199e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8019a1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8019a4:	01 c2                	add    %eax,%edx
  8019a6:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  8019a9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8019ac:	01 c8                	add    %ecx,%eax
  8019ae:	8a 00                	mov    (%eax),%al
  8019b0:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  8019b2:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8019b5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8019b8:	01 c2                	add    %eax,%edx
  8019ba:	8a 45 eb             	mov    -0x15(%ebp),%al
  8019bd:	88 02                	mov    %al,(%edx)
		start++ ;
  8019bf:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  8019c2:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  8019c5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8019c8:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8019cb:	7c c4                	jl     801991 <ltostr+0xae>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  8019cd:	8b 55 f8             	mov    -0x8(%ebp),%edx
  8019d0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8019d3:	01 d0                	add    %edx,%eax
  8019d5:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  8019d8:	90                   	nop
  8019d9:	c9                   	leave  
  8019da:	c3                   	ret    

008019db <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  8019db:	55                   	push   %ebp
  8019dc:	89 e5                	mov    %esp,%ebp
  8019de:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  8019e1:	ff 75 08             	pushl  0x8(%ebp)
  8019e4:	e8 54 fa ff ff       	call   80143d <strlen>
  8019e9:	83 c4 04             	add    $0x4,%esp
  8019ec:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  8019ef:	ff 75 0c             	pushl  0xc(%ebp)
  8019f2:	e8 46 fa ff ff       	call   80143d <strlen>
  8019f7:	83 c4 04             	add    $0x4,%esp
  8019fa:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  8019fd:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  801a04:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801a0b:	eb 17                	jmp    801a24 <strcconcat+0x49>
		final[s] = str1[s] ;
  801a0d:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801a10:	8b 45 10             	mov    0x10(%ebp),%eax
  801a13:	01 c2                	add    %eax,%edx
  801a15:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  801a18:	8b 45 08             	mov    0x8(%ebp),%eax
  801a1b:	01 c8                	add    %ecx,%eax
  801a1d:	8a 00                	mov    (%eax),%al
  801a1f:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  801a21:	ff 45 fc             	incl   -0x4(%ebp)
  801a24:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801a27:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  801a2a:	7c e1                	jl     801a0d <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  801a2c:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  801a33:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  801a3a:	eb 1f                	jmp    801a5b <strcconcat+0x80>
		final[s++] = str2[i] ;
  801a3c:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801a3f:	8d 50 01             	lea    0x1(%eax),%edx
  801a42:	89 55 fc             	mov    %edx,-0x4(%ebp)
  801a45:	89 c2                	mov    %eax,%edx
  801a47:	8b 45 10             	mov    0x10(%ebp),%eax
  801a4a:	01 c2                	add    %eax,%edx
  801a4c:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  801a4f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801a52:	01 c8                	add    %ecx,%eax
  801a54:	8a 00                	mov    (%eax),%al
  801a56:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  801a58:	ff 45 f8             	incl   -0x8(%ebp)
  801a5b:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801a5e:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801a61:	7c d9                	jl     801a3c <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  801a63:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801a66:	8b 45 10             	mov    0x10(%ebp),%eax
  801a69:	01 d0                	add    %edx,%eax
  801a6b:	c6 00 00             	movb   $0x0,(%eax)
}
  801a6e:	90                   	nop
  801a6f:	c9                   	leave  
  801a70:	c3                   	ret    

00801a71 <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  801a71:	55                   	push   %ebp
  801a72:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  801a74:	8b 45 14             	mov    0x14(%ebp),%eax
  801a77:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  801a7d:	8b 45 14             	mov    0x14(%ebp),%eax
  801a80:	8b 00                	mov    (%eax),%eax
  801a82:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801a89:	8b 45 10             	mov    0x10(%ebp),%eax
  801a8c:	01 d0                	add    %edx,%eax
  801a8e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801a94:	eb 0c                	jmp    801aa2 <strsplit+0x31>
			*string++ = 0;
  801a96:	8b 45 08             	mov    0x8(%ebp),%eax
  801a99:	8d 50 01             	lea    0x1(%eax),%edx
  801a9c:	89 55 08             	mov    %edx,0x8(%ebp)
  801a9f:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801aa2:	8b 45 08             	mov    0x8(%ebp),%eax
  801aa5:	8a 00                	mov    (%eax),%al
  801aa7:	84 c0                	test   %al,%al
  801aa9:	74 18                	je     801ac3 <strsplit+0x52>
  801aab:	8b 45 08             	mov    0x8(%ebp),%eax
  801aae:	8a 00                	mov    (%eax),%al
  801ab0:	0f be c0             	movsbl %al,%eax
  801ab3:	50                   	push   %eax
  801ab4:	ff 75 0c             	pushl  0xc(%ebp)
  801ab7:	e8 13 fb ff ff       	call   8015cf <strchr>
  801abc:	83 c4 08             	add    $0x8,%esp
  801abf:	85 c0                	test   %eax,%eax
  801ac1:	75 d3                	jne    801a96 <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  801ac3:	8b 45 08             	mov    0x8(%ebp),%eax
  801ac6:	8a 00                	mov    (%eax),%al
  801ac8:	84 c0                	test   %al,%al
  801aca:	74 5a                	je     801b26 <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  801acc:	8b 45 14             	mov    0x14(%ebp),%eax
  801acf:	8b 00                	mov    (%eax),%eax
  801ad1:	83 f8 0f             	cmp    $0xf,%eax
  801ad4:	75 07                	jne    801add <strsplit+0x6c>
		{
			return 0;
  801ad6:	b8 00 00 00 00       	mov    $0x0,%eax
  801adb:	eb 66                	jmp    801b43 <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  801add:	8b 45 14             	mov    0x14(%ebp),%eax
  801ae0:	8b 00                	mov    (%eax),%eax
  801ae2:	8d 48 01             	lea    0x1(%eax),%ecx
  801ae5:	8b 55 14             	mov    0x14(%ebp),%edx
  801ae8:	89 0a                	mov    %ecx,(%edx)
  801aea:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801af1:	8b 45 10             	mov    0x10(%ebp),%eax
  801af4:	01 c2                	add    %eax,%edx
  801af6:	8b 45 08             	mov    0x8(%ebp),%eax
  801af9:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  801afb:	eb 03                	jmp    801b00 <strsplit+0x8f>
			string++;
  801afd:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  801b00:	8b 45 08             	mov    0x8(%ebp),%eax
  801b03:	8a 00                	mov    (%eax),%al
  801b05:	84 c0                	test   %al,%al
  801b07:	74 8b                	je     801a94 <strsplit+0x23>
  801b09:	8b 45 08             	mov    0x8(%ebp),%eax
  801b0c:	8a 00                	mov    (%eax),%al
  801b0e:	0f be c0             	movsbl %al,%eax
  801b11:	50                   	push   %eax
  801b12:	ff 75 0c             	pushl  0xc(%ebp)
  801b15:	e8 b5 fa ff ff       	call   8015cf <strchr>
  801b1a:	83 c4 08             	add    $0x8,%esp
  801b1d:	85 c0                	test   %eax,%eax
  801b1f:	74 dc                	je     801afd <strsplit+0x8c>
			string++;
	}
  801b21:	e9 6e ff ff ff       	jmp    801a94 <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  801b26:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  801b27:	8b 45 14             	mov    0x14(%ebp),%eax
  801b2a:	8b 00                	mov    (%eax),%eax
  801b2c:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801b33:	8b 45 10             	mov    0x10(%ebp),%eax
  801b36:	01 d0                	add    %edx,%eax
  801b38:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  801b3e:	b8 01 00 00 00       	mov    $0x1,%eax
}
  801b43:	c9                   	leave  
  801b44:	c3                   	ret    

00801b45 <InitializeUHeap>:
//============================== GIVEN FUNCTIONS ===================================//
//==================================================================================//

int FirstTimeFlag = 1;
void InitializeUHeap()
{
  801b45:	55                   	push   %ebp
  801b46:	89 e5                	mov    %esp,%ebp
  801b48:	83 ec 08             	sub    $0x8,%esp
	if(FirstTimeFlag)
  801b4b:	a1 04 50 80 00       	mov    0x805004,%eax
  801b50:	85 c0                	test   %eax,%eax
  801b52:	74 1f                	je     801b73 <InitializeUHeap+0x2e>
	{
		initialize_dyn_block_system();
  801b54:	e8 1d 00 00 00       	call   801b76 <initialize_dyn_block_system>
		cprintf("DYNAMIC BLOCK SYSTEM IS INITIALIZED\n");
  801b59:	83 ec 0c             	sub    $0xc,%esp
  801b5c:	68 e4 40 80 00       	push   $0x8040e4
  801b61:	e8 4f f0 ff ff       	call   800bb5 <cprintf>
  801b66:	83 c4 10             	add    $0x10,%esp
#if UHP_USE_BUDDY
		initialize_buddy();
		cprintf("BUDDY SYSTEM IS INITIALIZED\n");
#endif
		FirstTimeFlag = 0;
  801b69:	c7 05 04 50 80 00 00 	movl   $0x0,0x805004
  801b70:	00 00 00 
	}
}
  801b73:	90                   	nop
  801b74:	c9                   	leave  
  801b75:	c3                   	ret    

00801b76 <initialize_dyn_block_system>:

//=================================
// [1] INITIALIZE DYNAMIC ALLOCATOR:
//=================================
void initialize_dyn_block_system()
{
  801b76:	55                   	push   %ebp
  801b77:	89 e5                	mov    %esp,%ebp
  801b79:	83 ec 28             	sub    $0x28,%esp
	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] initialize_dyn_block_system
	// your code is here, remove the panic and write your code
	//panic("initialize_dyn_block_system() is not implemented yet...!!");

	LIST_INIT(&AllocMemBlocksList);
  801b7c:	c7 05 40 50 80 00 00 	movl   $0x0,0x805040
  801b83:	00 00 00 
  801b86:	c7 05 44 50 80 00 00 	movl   $0x0,0x805044
  801b8d:	00 00 00 
  801b90:	c7 05 4c 50 80 00 00 	movl   $0x0,0x80504c
  801b97:	00 00 00 
	LIST_INIT(&FreeMemBlocksList);
  801b9a:	c7 05 38 51 80 00 00 	movl   $0x0,0x805138
  801ba1:	00 00 00 
  801ba4:	c7 05 3c 51 80 00 00 	movl   $0x0,0x80513c
  801bab:	00 00 00 
  801bae:	c7 05 44 51 80 00 00 	movl   $0x0,0x805144
  801bb5:	00 00 00 
	MAX_MEM_BLOCK_CNT = NUM_OF_UHEAP_PAGES;
  801bb8:	c7 05 20 51 80 00 00 	movl   $0x20000,0x805120
  801bbf:	00 02 00 
	MemBlockNodes = (void*)USER_DYN_BLKS_ARRAY;
  801bc2:	c7 45 f4 00 00 e0 7f 	movl   $0x7fe00000,-0xc(%ebp)
  801bc9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801bcc:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801bd1:	2d 00 10 00 00       	sub    $0x1000,%eax
  801bd6:	a3 50 50 80 00       	mov    %eax,0x805050
	int size_of_block = sizeof(struct MemBlock);
  801bdb:	c7 45 f0 10 00 00 00 	movl   $0x10,-0x10(%ebp)
	int size_all_struct = size_of_block*MAX_MEM_BLOCK_CNT;
  801be2:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801be5:	a1 20 51 80 00       	mov    0x805120,%eax
  801bea:	0f af c2             	imul   %edx,%eax
  801bed:	89 45 ec             	mov    %eax,-0x14(%ebp)
	size_all_struct = ROUNDUP(size_all_struct, PAGE_SIZE);
  801bf0:	c7 45 e8 00 10 00 00 	movl   $0x1000,-0x18(%ebp)
  801bf7:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801bfa:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801bfd:	01 d0                	add    %edx,%eax
  801bff:	48                   	dec    %eax
  801c00:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  801c03:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801c06:	ba 00 00 00 00       	mov    $0x0,%edx
  801c0b:	f7 75 e8             	divl   -0x18(%ebp)
  801c0e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801c11:	29 d0                	sub    %edx,%eax
  801c13:	89 45 ec             	mov    %eax,-0x14(%ebp)
	sys_allocate_chunk(USER_DYN_BLKS_ARRAY, size_all_struct,PERM_USER| PERM_WRITEABLE);
  801c16:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801c19:	c7 45 e0 00 00 e0 7f 	movl   $0x7fe00000,-0x20(%ebp)
  801c20:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801c23:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
  801c29:	81 ea 00 10 00 00    	sub    $0x1000,%edx
  801c2f:	83 ec 04             	sub    $0x4,%esp
  801c32:	6a 06                	push   $0x6
  801c34:	50                   	push   %eax
  801c35:	52                   	push   %edx
  801c36:	e8 a1 05 00 00       	call   8021dc <sys_allocate_chunk>
  801c3b:	83 c4 10             	add    $0x10,%esp
	initialize_MemBlocksList(MAX_MEM_BLOCK_CNT);
  801c3e:	a1 20 51 80 00       	mov    0x805120,%eax
  801c43:	83 ec 0c             	sub    $0xc,%esp
  801c46:	50                   	push   %eax
  801c47:	e8 16 0c 00 00       	call   802862 <initialize_MemBlocksList>
  801c4c:	83 c4 10             	add    $0x10,%esp
	struct MemBlock* ourBlock =LIST_LAST(&AvailableMemBlocksList);
  801c4f:	a1 4c 51 80 00       	mov    0x80514c,%eax
  801c54:	89 45 dc             	mov    %eax,-0x24(%ebp)
	LIST_REMOVE(&AvailableMemBlocksList,ourBlock);
  801c57:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  801c5b:	75 14                	jne    801c71 <initialize_dyn_block_system+0xfb>
  801c5d:	83 ec 04             	sub    $0x4,%esp
  801c60:	68 09 41 80 00       	push   $0x804109
  801c65:	6a 2d                	push   $0x2d
  801c67:	68 27 41 80 00       	push   $0x804127
  801c6c:	e8 90 ec ff ff       	call   800901 <_panic>
  801c71:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801c74:	8b 00                	mov    (%eax),%eax
  801c76:	85 c0                	test   %eax,%eax
  801c78:	74 10                	je     801c8a <initialize_dyn_block_system+0x114>
  801c7a:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801c7d:	8b 00                	mov    (%eax),%eax
  801c7f:	8b 55 dc             	mov    -0x24(%ebp),%edx
  801c82:	8b 52 04             	mov    0x4(%edx),%edx
  801c85:	89 50 04             	mov    %edx,0x4(%eax)
  801c88:	eb 0b                	jmp    801c95 <initialize_dyn_block_system+0x11f>
  801c8a:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801c8d:	8b 40 04             	mov    0x4(%eax),%eax
  801c90:	a3 4c 51 80 00       	mov    %eax,0x80514c
  801c95:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801c98:	8b 40 04             	mov    0x4(%eax),%eax
  801c9b:	85 c0                	test   %eax,%eax
  801c9d:	74 0f                	je     801cae <initialize_dyn_block_system+0x138>
  801c9f:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801ca2:	8b 40 04             	mov    0x4(%eax),%eax
  801ca5:	8b 55 dc             	mov    -0x24(%ebp),%edx
  801ca8:	8b 12                	mov    (%edx),%edx
  801caa:	89 10                	mov    %edx,(%eax)
  801cac:	eb 0a                	jmp    801cb8 <initialize_dyn_block_system+0x142>
  801cae:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801cb1:	8b 00                	mov    (%eax),%eax
  801cb3:	a3 48 51 80 00       	mov    %eax,0x805148
  801cb8:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801cbb:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  801cc1:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801cc4:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  801ccb:	a1 54 51 80 00       	mov    0x805154,%eax
  801cd0:	48                   	dec    %eax
  801cd1:	a3 54 51 80 00       	mov    %eax,0x805154
	ourBlock->size = USER_HEAP_MAX-USER_HEAP_START;
  801cd6:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801cd9:	c7 40 0c 00 00 00 20 	movl   $0x20000000,0xc(%eax)
	ourBlock->sva=USER_HEAP_START;
  801ce0:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801ce3:	c7 40 08 00 00 00 80 	movl   $0x80000000,0x8(%eax)
	LIST_INSERT_TAIL(&FreeMemBlocksList, ourBlock);
  801cea:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  801cee:	75 14                	jne    801d04 <initialize_dyn_block_system+0x18e>
  801cf0:	83 ec 04             	sub    $0x4,%esp
  801cf3:	68 34 41 80 00       	push   $0x804134
  801cf8:	6a 30                	push   $0x30
  801cfa:	68 27 41 80 00       	push   $0x804127
  801cff:	e8 fd eb ff ff       	call   800901 <_panic>
  801d04:	8b 15 3c 51 80 00    	mov    0x80513c,%edx
  801d0a:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801d0d:	89 50 04             	mov    %edx,0x4(%eax)
  801d10:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801d13:	8b 40 04             	mov    0x4(%eax),%eax
  801d16:	85 c0                	test   %eax,%eax
  801d18:	74 0c                	je     801d26 <initialize_dyn_block_system+0x1b0>
  801d1a:	a1 3c 51 80 00       	mov    0x80513c,%eax
  801d1f:	8b 55 dc             	mov    -0x24(%ebp),%edx
  801d22:	89 10                	mov    %edx,(%eax)
  801d24:	eb 08                	jmp    801d2e <initialize_dyn_block_system+0x1b8>
  801d26:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801d29:	a3 38 51 80 00       	mov    %eax,0x805138
  801d2e:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801d31:	a3 3c 51 80 00       	mov    %eax,0x80513c
  801d36:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801d39:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  801d3f:	a1 44 51 80 00       	mov    0x805144,%eax
  801d44:	40                   	inc    %eax
  801d45:	a3 44 51 80 00       	mov    %eax,0x805144
	//[1] Initialize two lists (AllocMemBlocksList & FreeMemBlocksList) [Hint: use LIST_INIT()]
	//[2] Dynamically allocate the array of MemBlockNodes at VA USER_DYN_BLKS_ARRAY
	//	  (remember to set MAX_MEM_BLOCK_CNT with the chosen size of the array)
	//[3] Initialize AvailableMemBlocksList by filling it with the MemBlockNodes
	//[4] Insert a new MemBlock with the heap size into the FreeMemBlocksList
}
  801d4a:	90                   	nop
  801d4b:	c9                   	leave  
  801d4c:	c3                   	ret    

00801d4d <malloc>:
//=================================
// [2] ALLOCATE SPACE IN USER HEAP:
//=================================

void* malloc(uint32 size)
{
  801d4d:	55                   	push   %ebp
  801d4e:	89 e5                	mov    %esp,%ebp
  801d50:	83 ec 18             	sub    $0x18,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801d53:	e8 ed fd ff ff       	call   801b45 <InitializeUHeap>
	if (size == 0) return NULL ;
  801d58:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801d5c:	75 07                	jne    801d65 <malloc+0x18>
  801d5e:	b8 00 00 00 00       	mov    $0x0,%eax
  801d63:	eb 67                	jmp    801dcc <malloc+0x7f>

	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] malloc
	// your code is here, remove the panic and write your code
	//panic("malloc() is not implemented yet...!!");

	size = ROUNDUP(size, PAGE_SIZE);
  801d65:	c7 45 f4 00 10 00 00 	movl   $0x1000,-0xc(%ebp)
  801d6c:	8b 55 08             	mov    0x8(%ebp),%edx
  801d6f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801d72:	01 d0                	add    %edx,%eax
  801d74:	48                   	dec    %eax
  801d75:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801d78:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801d7b:	ba 00 00 00 00       	mov    $0x0,%edx
  801d80:	f7 75 f4             	divl   -0xc(%ebp)
  801d83:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801d86:	29 d0                	sub    %edx,%eax
  801d88:	89 45 08             	mov    %eax,0x8(%ebp)
	if(sys_isUHeapPlacementStrategyFIRSTFIT())
  801d8b:	e8 1a 08 00 00       	call   8025aa <sys_isUHeapPlacementStrategyFIRSTFIT>
  801d90:	85 c0                	test   %eax,%eax
  801d92:	74 33                	je     801dc7 <malloc+0x7a>
	{
		struct MemBlock * myBlock = alloc_block_FF(size);
  801d94:	83 ec 0c             	sub    $0xc,%esp
  801d97:	ff 75 08             	pushl  0x8(%ebp)
  801d9a:	e8 0c 0e 00 00       	call   802bab <alloc_block_FF>
  801d9f:	83 c4 10             	add    $0x10,%esp
  801da2:	89 45 ec             	mov    %eax,-0x14(%ebp)
		if(myBlock != NULL)
  801da5:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  801da9:	74 1c                	je     801dc7 <malloc+0x7a>
		{
			insert_sorted_allocList(myBlock);
  801dab:	83 ec 0c             	sub    $0xc,%esp
  801dae:	ff 75 ec             	pushl  -0x14(%ebp)
  801db1:	e8 07 0c 00 00       	call   8029bd <insert_sorted_allocList>
  801db6:	83 c4 10             	add    $0x10,%esp
			uint32 ptr = myBlock->sva;
  801db9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801dbc:	8b 40 08             	mov    0x8(%eax),%eax
  801dbf:	89 45 e8             	mov    %eax,-0x18(%ebp)
			return (void *)ptr;
  801dc2:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801dc5:	eb 05                	jmp    801dcc <malloc+0x7f>
		}
	}
	return NULL;
  801dc7:	b8 00 00 00 00       	mov    $0x0,%eax
	//		to the required allocation size (space should be on 4 KB BOUNDARY)
	//	2) if no suitable space found, return NULL
	// 	3) Return pointer containing the virtual address of allocated space,
	//
	//Use sys_isUHeapPlacementStrategyFIRSTFIT()... to check the current strategy
}
  801dcc:	c9                   	leave  
  801dcd:	c3                   	ret    

00801dce <free>:
//	We can use sys_free_user_mem(uint32 virtual_address, uint32 size); which
//		switches to the kernel mode, calls free_user_mem() in
//		"kern/mem/chunk_operations.c", then switch back to the user mode here
//	the free_user_mem function is empty, make sure to implement it.
void free(void* virtual_address)
{
  801dce:	55                   	push   %ebp
  801dcf:	89 e5                	mov    %esp,%ebp
  801dd1:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] free
	// your code is here, remove the panic and write your code
	//panic("free() is not implemented yet...!!");

	uint32 virtualAddress = (uint32 )(virtual_address);
  801dd4:	8b 45 08             	mov    0x8(%ebp),%eax
  801dd7:	89 45 f4             	mov    %eax,-0xc(%ebp)
//	virtualAddress = ROUNDDOWN(virtualAddress, PAGE_SIZE);
	struct MemBlock * myBlock = find_block(&AllocMemBlocksList, virtualAddress);
  801dda:	83 ec 08             	sub    $0x8,%esp
  801ddd:	ff 75 f4             	pushl  -0xc(%ebp)
  801de0:	68 40 50 80 00       	push   $0x805040
  801de5:	e8 5b 0b 00 00       	call   802945 <find_block>
  801dea:	83 c4 10             	add    $0x10,%esp
  801ded:	89 45 f0             	mov    %eax,-0x10(%ebp)
//	cprintf ("ptr sva at free user side = %x \n", myBlock->sva);
	sys_free_user_mem(virtualAddress, myBlock->size);
  801df0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801df3:	8b 40 0c             	mov    0xc(%eax),%eax
  801df6:	83 ec 08             	sub    $0x8,%esp
  801df9:	50                   	push   %eax
  801dfa:	ff 75 f4             	pushl  -0xc(%ebp)
  801dfd:	e8 a2 03 00 00       	call   8021a4 <sys_free_user_mem>
  801e02:	83 c4 10             	add    $0x10,%esp
	LIST_REMOVE(&AllocMemBlocksList, myBlock);
  801e05:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801e09:	75 14                	jne    801e1f <free+0x51>
  801e0b:	83 ec 04             	sub    $0x4,%esp
  801e0e:	68 09 41 80 00       	push   $0x804109
  801e13:	6a 76                	push   $0x76
  801e15:	68 27 41 80 00       	push   $0x804127
  801e1a:	e8 e2 ea ff ff       	call   800901 <_panic>
  801e1f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801e22:	8b 00                	mov    (%eax),%eax
  801e24:	85 c0                	test   %eax,%eax
  801e26:	74 10                	je     801e38 <free+0x6a>
  801e28:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801e2b:	8b 00                	mov    (%eax),%eax
  801e2d:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801e30:	8b 52 04             	mov    0x4(%edx),%edx
  801e33:	89 50 04             	mov    %edx,0x4(%eax)
  801e36:	eb 0b                	jmp    801e43 <free+0x75>
  801e38:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801e3b:	8b 40 04             	mov    0x4(%eax),%eax
  801e3e:	a3 44 50 80 00       	mov    %eax,0x805044
  801e43:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801e46:	8b 40 04             	mov    0x4(%eax),%eax
  801e49:	85 c0                	test   %eax,%eax
  801e4b:	74 0f                	je     801e5c <free+0x8e>
  801e4d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801e50:	8b 40 04             	mov    0x4(%eax),%eax
  801e53:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801e56:	8b 12                	mov    (%edx),%edx
  801e58:	89 10                	mov    %edx,(%eax)
  801e5a:	eb 0a                	jmp    801e66 <free+0x98>
  801e5c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801e5f:	8b 00                	mov    (%eax),%eax
  801e61:	a3 40 50 80 00       	mov    %eax,0x805040
  801e66:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801e69:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  801e6f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801e72:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  801e79:	a1 4c 50 80 00       	mov    0x80504c,%eax
  801e7e:	48                   	dec    %eax
  801e7f:	a3 4c 50 80 00       	mov    %eax,0x80504c
	insert_sorted_with_merge_freeList(myBlock);
  801e84:	83 ec 0c             	sub    $0xc,%esp
  801e87:	ff 75 f0             	pushl  -0x10(%ebp)
  801e8a:	e8 0b 14 00 00       	call   80329a <insert_sorted_with_merge_freeList>
  801e8f:	83 c4 10             	add    $0x10,%esp

	//you should get the size of the given allocation using its address
	//you need to call sys_free_user_mem()
	//refer to the project presentation and documentation for details
}
  801e92:	90                   	nop
  801e93:	c9                   	leave  
  801e94:	c3                   	ret    

00801e95 <smalloc>:

//=================================
// [4] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
  801e95:	55                   	push   %ebp
  801e96:	89 e5                	mov    %esp,%ebp
  801e98:	83 ec 28             	sub    $0x28,%esp
  801e9b:	8b 45 10             	mov    0x10(%ebp),%eax
  801e9e:	88 45 e4             	mov    %al,-0x1c(%ebp)
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801ea1:	e8 9f fc ff ff       	call   801b45 <InitializeUHeap>
	if (size == 0) return NULL ;
  801ea6:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801eaa:	75 0a                	jne    801eb6 <smalloc+0x21>
  801eac:	b8 00 00 00 00       	mov    $0x0,%eax
  801eb1:	e9 8d 00 00 00       	jmp    801f43 <smalloc+0xae>

	//This function should find the space of the required range
	// * ON 4KB BOUNDARY **** //
	//Use sys_isUHeapPlacementStrategyFIRSTFIT() to check the current strategy

	size = ROUNDUP(size, PAGE_SIZE);
  801eb6:	c7 45 f4 00 10 00 00 	movl   $0x1000,-0xc(%ebp)
  801ebd:	8b 55 0c             	mov    0xc(%ebp),%edx
  801ec0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ec3:	01 d0                	add    %edx,%eax
  801ec5:	48                   	dec    %eax
  801ec6:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801ec9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801ecc:	ba 00 00 00 00       	mov    $0x0,%edx
  801ed1:	f7 75 f4             	divl   -0xc(%ebp)
  801ed4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801ed7:	29 d0                	sub    %edx,%eax
  801ed9:	89 45 0c             	mov    %eax,0xc(%ebp)
		if(sys_isUHeapPlacementStrategyFIRSTFIT())
  801edc:	e8 c9 06 00 00       	call   8025aa <sys_isUHeapPlacementStrategyFIRSTFIT>
  801ee1:	85 c0                	test   %eax,%eax
  801ee3:	74 59                	je     801f3e <smalloc+0xa9>
		{
			struct MemBlock * v1=NULL;
  801ee5:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
			v1= alloc_block_FF(size);
  801eec:	83 ec 0c             	sub    $0xc,%esp
  801eef:	ff 75 0c             	pushl  0xc(%ebp)
  801ef2:	e8 b4 0c 00 00       	call   802bab <alloc_block_FF>
  801ef7:	83 c4 10             	add    $0x10,%esp
  801efa:	89 45 ec             	mov    %eax,-0x14(%ebp)
			if(v1==NULL)
  801efd:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  801f01:	75 07                	jne    801f0a <smalloc+0x75>
			{
				return NULL;
  801f03:	b8 00 00 00 00       	mov    $0x0,%eax
  801f08:	eb 39                	jmp    801f43 <smalloc+0xae>
			}
			else
			{
				int ret=sys_createSharedObject(sharedVarName,  size,  isWritable,(void*)v1->sva);
  801f0a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801f0d:	8b 40 08             	mov    0x8(%eax),%eax
  801f10:	89 c2                	mov    %eax,%edx
  801f12:	0f b6 45 e4          	movzbl -0x1c(%ebp),%eax
  801f16:	52                   	push   %edx
  801f17:	50                   	push   %eax
  801f18:	ff 75 0c             	pushl  0xc(%ebp)
  801f1b:	ff 75 08             	pushl  0x8(%ebp)
  801f1e:	e8 0c 04 00 00       	call   80232f <sys_createSharedObject>
  801f23:	83 c4 10             	add    $0x10,%esp
  801f26:	89 45 e8             	mov    %eax,-0x18(%ebp)
				if(ret>=0)
  801f29:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  801f2d:	78 08                	js     801f37 <smalloc+0xa2>
				{
					return (void*)v1->sva;
  801f2f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801f32:	8b 40 08             	mov    0x8(%eax),%eax
  801f35:	eb 0c                	jmp    801f43 <smalloc+0xae>
				}
				else
				{
					return NULL;
  801f37:	b8 00 00 00 00       	mov    $0x0,%eax
  801f3c:	eb 05                	jmp    801f43 <smalloc+0xae>
				}
			}

		}
		return NULL;
  801f3e:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801f43:	c9                   	leave  
  801f44:	c3                   	ret    

00801f45 <sget>:

//========================================
// [5] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  801f45:	55                   	push   %ebp
  801f46:	89 e5                	mov    %esp,%ebp
  801f48:	83 ec 18             	sub    $0x18,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801f4b:	e8 f5 fb ff ff       	call   801b45 <InitializeUHeap>

	//This function should find the space for sharing the variable
	// *** ON 4KB BOUNDARY ******** //

	//Use sys_isUHeapPlacementStrategyFIRSTFIT() to check the current strategy
	int ret=sys_getSizeOfSharedObject(ownerEnvID,sharedVarName);
  801f50:	83 ec 08             	sub    $0x8,%esp
  801f53:	ff 75 0c             	pushl  0xc(%ebp)
  801f56:	ff 75 08             	pushl  0x8(%ebp)
  801f59:	e8 fb 03 00 00       	call   802359 <sys_getSizeOfSharedObject>
  801f5e:	83 c4 10             	add    $0x10,%esp
  801f61:	89 45 f4             	mov    %eax,-0xc(%ebp)
	if(ret==0)
  801f64:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801f68:	75 07                	jne    801f71 <sget+0x2c>
	{
		return NULL;
  801f6a:	b8 00 00 00 00       	mov    $0x0,%eax
  801f6f:	eb 64                	jmp    801fd5 <sget+0x90>
	}
	if(sys_isUHeapPlacementStrategyFIRSTFIT())
  801f71:	e8 34 06 00 00       	call   8025aa <sys_isUHeapPlacementStrategyFIRSTFIT>
  801f76:	85 c0                	test   %eax,%eax
  801f78:	74 56                	je     801fd0 <sget+0x8b>
	{
		struct MemBlock * v1=NULL;
  801f7a:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
		v1= alloc_block_FF(ret);
  801f81:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f84:	83 ec 0c             	sub    $0xc,%esp
  801f87:	50                   	push   %eax
  801f88:	e8 1e 0c 00 00       	call   802bab <alloc_block_FF>
  801f8d:	83 c4 10             	add    $0x10,%esp
  801f90:	89 45 f0             	mov    %eax,-0x10(%ebp)
		if(v1==NULL)
  801f93:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801f97:	75 07                	jne    801fa0 <sget+0x5b>
		{
		return NULL;
  801f99:	b8 00 00 00 00       	mov    $0x0,%eax
  801f9e:	eb 35                	jmp    801fd5 <sget+0x90>
	    }
		else
		{
			int ret1=sys_getSharedObject(ownerEnvID,sharedVarName,(void*)v1->sva);
  801fa0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801fa3:	8b 40 08             	mov    0x8(%eax),%eax
  801fa6:	83 ec 04             	sub    $0x4,%esp
  801fa9:	50                   	push   %eax
  801faa:	ff 75 0c             	pushl  0xc(%ebp)
  801fad:	ff 75 08             	pushl  0x8(%ebp)
  801fb0:	e8 c1 03 00 00       	call   802376 <sys_getSharedObject>
  801fb5:	83 c4 10             	add    $0x10,%esp
  801fb8:	89 45 ec             	mov    %eax,-0x14(%ebp)
			if(ret1>=0)
  801fbb:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  801fbf:	78 08                	js     801fc9 <sget+0x84>
			{
				return (void*)v1->sva;
  801fc1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801fc4:	8b 40 08             	mov    0x8(%eax),%eax
  801fc7:	eb 0c                	jmp    801fd5 <sget+0x90>
			}
			else
			{
				return NULL;
  801fc9:	b8 00 00 00 00       	mov    $0x0,%eax
  801fce:	eb 05                	jmp    801fd5 <sget+0x90>
			}
		}
	}
  return NULL;
  801fd0:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801fd5:	c9                   	leave  
  801fd6:	c3                   	ret    

00801fd7 <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  801fd7:	55                   	push   %ebp
  801fd8:	89 e5                	mov    %esp,%ebp
  801fda:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801fdd:	e8 63 fb ff ff       	call   801b45 <InitializeUHeap>
	//==============================================================
	// [USER HEAP - USER SIDE] realloc
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  801fe2:	83 ec 04             	sub    $0x4,%esp
  801fe5:	68 58 41 80 00       	push   $0x804158
  801fea:	68 0e 01 00 00       	push   $0x10e
  801fef:	68 27 41 80 00       	push   $0x804127
  801ff4:	e8 08 e9 ff ff       	call   800901 <_panic>

00801ff9 <sfree>:
//	use sys_freeSharedObject(...); which switches to the kernel mode,
//	calls freeSharedObject(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the freeSharedObject() function is empty, make sure to implement it.

void sfree(void* virtual_address)
{
  801ff9:	55                   	push   %ebp
  801ffa:	89 e5                	mov    %esp,%ebp
  801ffc:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS3 - BONUS] [SHARING - USER SIDE] sfree()

	// Write your code here, remove the panic and write your code
	panic("sfree() is not implemented yet...!!");
  801fff:	83 ec 04             	sub    $0x4,%esp
  802002:	68 80 41 80 00       	push   $0x804180
  802007:	68 22 01 00 00       	push   $0x122
  80200c:	68 27 41 80 00       	push   $0x804127
  802011:	e8 eb e8 ff ff       	call   800901 <_panic>

00802016 <expand>:

//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//
void expand(uint32 newSize)
{
  802016:	55                   	push   %ebp
  802017:	89 e5                	mov    %esp,%ebp
  802019:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  80201c:	83 ec 04             	sub    $0x4,%esp
  80201f:	68 a4 41 80 00       	push   $0x8041a4
  802024:	68 2d 01 00 00       	push   $0x12d
  802029:	68 27 41 80 00       	push   $0x804127
  80202e:	e8 ce e8 ff ff       	call   800901 <_panic>

00802033 <shrink>:

}
void shrink(uint32 newSize)
{
  802033:	55                   	push   %ebp
  802034:	89 e5                	mov    %esp,%ebp
  802036:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  802039:	83 ec 04             	sub    $0x4,%esp
  80203c:	68 a4 41 80 00       	push   $0x8041a4
  802041:	68 32 01 00 00       	push   $0x132
  802046:	68 27 41 80 00       	push   $0x804127
  80204b:	e8 b1 e8 ff ff       	call   800901 <_panic>

00802050 <freeHeap>:

}
void freeHeap(void* virtual_address)
{
  802050:	55                   	push   %ebp
  802051:	89 e5                	mov    %esp,%ebp
  802053:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  802056:	83 ec 04             	sub    $0x4,%esp
  802059:	68 a4 41 80 00       	push   $0x8041a4
  80205e:	68 37 01 00 00       	push   $0x137
  802063:	68 27 41 80 00       	push   $0x804127
  802068:	e8 94 e8 ff ff       	call   800901 <_panic>

0080206d <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  80206d:	55                   	push   %ebp
  80206e:	89 e5                	mov    %esp,%ebp
  802070:	57                   	push   %edi
  802071:	56                   	push   %esi
  802072:	53                   	push   %ebx
  802073:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  802076:	8b 45 08             	mov    0x8(%ebp),%eax
  802079:	8b 55 0c             	mov    0xc(%ebp),%edx
  80207c:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80207f:	8b 5d 14             	mov    0x14(%ebp),%ebx
  802082:	8b 7d 18             	mov    0x18(%ebp),%edi
  802085:	8b 75 1c             	mov    0x1c(%ebp),%esi
  802088:	cd 30                	int    $0x30
  80208a:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  80208d:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  802090:	83 c4 10             	add    $0x10,%esp
  802093:	5b                   	pop    %ebx
  802094:	5e                   	pop    %esi
  802095:	5f                   	pop    %edi
  802096:	5d                   	pop    %ebp
  802097:	c3                   	ret    

00802098 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  802098:	55                   	push   %ebp
  802099:	89 e5                	mov    %esp,%ebp
  80209b:	83 ec 04             	sub    $0x4,%esp
  80209e:	8b 45 10             	mov    0x10(%ebp),%eax
  8020a1:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  8020a4:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  8020a8:	8b 45 08             	mov    0x8(%ebp),%eax
  8020ab:	6a 00                	push   $0x0
  8020ad:	6a 00                	push   $0x0
  8020af:	52                   	push   %edx
  8020b0:	ff 75 0c             	pushl  0xc(%ebp)
  8020b3:	50                   	push   %eax
  8020b4:	6a 00                	push   $0x0
  8020b6:	e8 b2 ff ff ff       	call   80206d <syscall>
  8020bb:	83 c4 18             	add    $0x18,%esp
}
  8020be:	90                   	nop
  8020bf:	c9                   	leave  
  8020c0:	c3                   	ret    

008020c1 <sys_cgetc>:

int
sys_cgetc(void)
{
  8020c1:	55                   	push   %ebp
  8020c2:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  8020c4:	6a 00                	push   $0x0
  8020c6:	6a 00                	push   $0x0
  8020c8:	6a 00                	push   $0x0
  8020ca:	6a 00                	push   $0x0
  8020cc:	6a 00                	push   $0x0
  8020ce:	6a 01                	push   $0x1
  8020d0:	e8 98 ff ff ff       	call   80206d <syscall>
  8020d5:	83 c4 18             	add    $0x18,%esp
}
  8020d8:	c9                   	leave  
  8020d9:	c3                   	ret    

008020da <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  8020da:	55                   	push   %ebp
  8020db:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  8020dd:	8b 55 0c             	mov    0xc(%ebp),%edx
  8020e0:	8b 45 08             	mov    0x8(%ebp),%eax
  8020e3:	6a 00                	push   $0x0
  8020e5:	6a 00                	push   $0x0
  8020e7:	6a 00                	push   $0x0
  8020e9:	52                   	push   %edx
  8020ea:	50                   	push   %eax
  8020eb:	6a 05                	push   $0x5
  8020ed:	e8 7b ff ff ff       	call   80206d <syscall>
  8020f2:	83 c4 18             	add    $0x18,%esp
}
  8020f5:	c9                   	leave  
  8020f6:	c3                   	ret    

008020f7 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  8020f7:	55                   	push   %ebp
  8020f8:	89 e5                	mov    %esp,%ebp
  8020fa:	56                   	push   %esi
  8020fb:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  8020fc:	8b 75 18             	mov    0x18(%ebp),%esi
  8020ff:	8b 5d 14             	mov    0x14(%ebp),%ebx
  802102:	8b 4d 10             	mov    0x10(%ebp),%ecx
  802105:	8b 55 0c             	mov    0xc(%ebp),%edx
  802108:	8b 45 08             	mov    0x8(%ebp),%eax
  80210b:	56                   	push   %esi
  80210c:	53                   	push   %ebx
  80210d:	51                   	push   %ecx
  80210e:	52                   	push   %edx
  80210f:	50                   	push   %eax
  802110:	6a 06                	push   $0x6
  802112:	e8 56 ff ff ff       	call   80206d <syscall>
  802117:	83 c4 18             	add    $0x18,%esp
}
  80211a:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80211d:	5b                   	pop    %ebx
  80211e:	5e                   	pop    %esi
  80211f:	5d                   	pop    %ebp
  802120:	c3                   	ret    

00802121 <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  802121:	55                   	push   %ebp
  802122:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  802124:	8b 55 0c             	mov    0xc(%ebp),%edx
  802127:	8b 45 08             	mov    0x8(%ebp),%eax
  80212a:	6a 00                	push   $0x0
  80212c:	6a 00                	push   $0x0
  80212e:	6a 00                	push   $0x0
  802130:	52                   	push   %edx
  802131:	50                   	push   %eax
  802132:	6a 07                	push   $0x7
  802134:	e8 34 ff ff ff       	call   80206d <syscall>
  802139:	83 c4 18             	add    $0x18,%esp
}
  80213c:	c9                   	leave  
  80213d:	c3                   	ret    

0080213e <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  80213e:	55                   	push   %ebp
  80213f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  802141:	6a 00                	push   $0x0
  802143:	6a 00                	push   $0x0
  802145:	6a 00                	push   $0x0
  802147:	ff 75 0c             	pushl  0xc(%ebp)
  80214a:	ff 75 08             	pushl  0x8(%ebp)
  80214d:	6a 08                	push   $0x8
  80214f:	e8 19 ff ff ff       	call   80206d <syscall>
  802154:	83 c4 18             	add    $0x18,%esp
}
  802157:	c9                   	leave  
  802158:	c3                   	ret    

00802159 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  802159:	55                   	push   %ebp
  80215a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  80215c:	6a 00                	push   $0x0
  80215e:	6a 00                	push   $0x0
  802160:	6a 00                	push   $0x0
  802162:	6a 00                	push   $0x0
  802164:	6a 00                	push   $0x0
  802166:	6a 09                	push   $0x9
  802168:	e8 00 ff ff ff       	call   80206d <syscall>
  80216d:	83 c4 18             	add    $0x18,%esp
}
  802170:	c9                   	leave  
  802171:	c3                   	ret    

00802172 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  802172:	55                   	push   %ebp
  802173:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  802175:	6a 00                	push   $0x0
  802177:	6a 00                	push   $0x0
  802179:	6a 00                	push   $0x0
  80217b:	6a 00                	push   $0x0
  80217d:	6a 00                	push   $0x0
  80217f:	6a 0a                	push   $0xa
  802181:	e8 e7 fe ff ff       	call   80206d <syscall>
  802186:	83 c4 18             	add    $0x18,%esp
}
  802189:	c9                   	leave  
  80218a:	c3                   	ret    

0080218b <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  80218b:	55                   	push   %ebp
  80218c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  80218e:	6a 00                	push   $0x0
  802190:	6a 00                	push   $0x0
  802192:	6a 00                	push   $0x0
  802194:	6a 00                	push   $0x0
  802196:	6a 00                	push   $0x0
  802198:	6a 0b                	push   $0xb
  80219a:	e8 ce fe ff ff       	call   80206d <syscall>
  80219f:	83 c4 18             	add    $0x18,%esp
}
  8021a2:	c9                   	leave  
  8021a3:	c3                   	ret    

008021a4 <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  8021a4:	55                   	push   %ebp
  8021a5:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  8021a7:	6a 00                	push   $0x0
  8021a9:	6a 00                	push   $0x0
  8021ab:	6a 00                	push   $0x0
  8021ad:	ff 75 0c             	pushl  0xc(%ebp)
  8021b0:	ff 75 08             	pushl  0x8(%ebp)
  8021b3:	6a 0f                	push   $0xf
  8021b5:	e8 b3 fe ff ff       	call   80206d <syscall>
  8021ba:	83 c4 18             	add    $0x18,%esp
	return;
  8021bd:	90                   	nop
}
  8021be:	c9                   	leave  
  8021bf:	c3                   	ret    

008021c0 <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  8021c0:	55                   	push   %ebp
  8021c1:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  8021c3:	6a 00                	push   $0x0
  8021c5:	6a 00                	push   $0x0
  8021c7:	6a 00                	push   $0x0
  8021c9:	ff 75 0c             	pushl  0xc(%ebp)
  8021cc:	ff 75 08             	pushl  0x8(%ebp)
  8021cf:	6a 10                	push   $0x10
  8021d1:	e8 97 fe ff ff       	call   80206d <syscall>
  8021d6:	83 c4 18             	add    $0x18,%esp
	return ;
  8021d9:	90                   	nop
}
  8021da:	c9                   	leave  
  8021db:	c3                   	ret    

008021dc <sys_allocate_chunk>:

void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  8021dc:	55                   	push   %ebp
  8021dd:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  8021df:	6a 00                	push   $0x0
  8021e1:	6a 00                	push   $0x0
  8021e3:	ff 75 10             	pushl  0x10(%ebp)
  8021e6:	ff 75 0c             	pushl  0xc(%ebp)
  8021e9:	ff 75 08             	pushl  0x8(%ebp)
  8021ec:	6a 11                	push   $0x11
  8021ee:	e8 7a fe ff ff       	call   80206d <syscall>
  8021f3:	83 c4 18             	add    $0x18,%esp
	return ;
  8021f6:	90                   	nop
}
  8021f7:	c9                   	leave  
  8021f8:	c3                   	ret    

008021f9 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  8021f9:	55                   	push   %ebp
  8021fa:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  8021fc:	6a 00                	push   $0x0
  8021fe:	6a 00                	push   $0x0
  802200:	6a 00                	push   $0x0
  802202:	6a 00                	push   $0x0
  802204:	6a 00                	push   $0x0
  802206:	6a 0c                	push   $0xc
  802208:	e8 60 fe ff ff       	call   80206d <syscall>
  80220d:	83 c4 18             	add    $0x18,%esp
}
  802210:	c9                   	leave  
  802211:	c3                   	ret    

00802212 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  802212:	55                   	push   %ebp
  802213:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  802215:	6a 00                	push   $0x0
  802217:	6a 00                	push   $0x0
  802219:	6a 00                	push   $0x0
  80221b:	6a 00                	push   $0x0
  80221d:	ff 75 08             	pushl  0x8(%ebp)
  802220:	6a 0d                	push   $0xd
  802222:	e8 46 fe ff ff       	call   80206d <syscall>
  802227:	83 c4 18             	add    $0x18,%esp
}
  80222a:	c9                   	leave  
  80222b:	c3                   	ret    

0080222c <sys_scarce_memory>:

void sys_scarce_memory()
{
  80222c:	55                   	push   %ebp
  80222d:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  80222f:	6a 00                	push   $0x0
  802231:	6a 00                	push   $0x0
  802233:	6a 00                	push   $0x0
  802235:	6a 00                	push   $0x0
  802237:	6a 00                	push   $0x0
  802239:	6a 0e                	push   $0xe
  80223b:	e8 2d fe ff ff       	call   80206d <syscall>
  802240:	83 c4 18             	add    $0x18,%esp
}
  802243:	90                   	nop
  802244:	c9                   	leave  
  802245:	c3                   	ret    

00802246 <sys_disable_interrupt>:

//NEW !! 2012...
void
sys_disable_interrupt()
{
  802246:	55                   	push   %ebp
  802247:	89 e5                	mov    %esp,%ebp
	syscall(SYS_disableINTR,0, 0, 0, 0, 0);
  802249:	6a 00                	push   $0x0
  80224b:	6a 00                	push   $0x0
  80224d:	6a 00                	push   $0x0
  80224f:	6a 00                	push   $0x0
  802251:	6a 00                	push   $0x0
  802253:	6a 13                	push   $0x13
  802255:	e8 13 fe ff ff       	call   80206d <syscall>
  80225a:	83 c4 18             	add    $0x18,%esp
}
  80225d:	90                   	nop
  80225e:	c9                   	leave  
  80225f:	c3                   	ret    

00802260 <sys_enable_interrupt>:


void
sys_enable_interrupt()
{
  802260:	55                   	push   %ebp
  802261:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enableINTR,0, 0, 0, 0, 0);
  802263:	6a 00                	push   $0x0
  802265:	6a 00                	push   $0x0
  802267:	6a 00                	push   $0x0
  802269:	6a 00                	push   $0x0
  80226b:	6a 00                	push   $0x0
  80226d:	6a 14                	push   $0x14
  80226f:	e8 f9 fd ff ff       	call   80206d <syscall>
  802274:	83 c4 18             	add    $0x18,%esp
}
  802277:	90                   	nop
  802278:	c9                   	leave  
  802279:	c3                   	ret    

0080227a <sys_cputc>:


void
sys_cputc(const char c)
{
  80227a:	55                   	push   %ebp
  80227b:	89 e5                	mov    %esp,%ebp
  80227d:	83 ec 04             	sub    $0x4,%esp
  802280:	8b 45 08             	mov    0x8(%ebp),%eax
  802283:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  802286:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  80228a:	6a 00                	push   $0x0
  80228c:	6a 00                	push   $0x0
  80228e:	6a 00                	push   $0x0
  802290:	6a 00                	push   $0x0
  802292:	50                   	push   %eax
  802293:	6a 15                	push   $0x15
  802295:	e8 d3 fd ff ff       	call   80206d <syscall>
  80229a:	83 c4 18             	add    $0x18,%esp
}
  80229d:	90                   	nop
  80229e:	c9                   	leave  
  80229f:	c3                   	ret    

008022a0 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  8022a0:	55                   	push   %ebp
  8022a1:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  8022a3:	6a 00                	push   $0x0
  8022a5:	6a 00                	push   $0x0
  8022a7:	6a 00                	push   $0x0
  8022a9:	6a 00                	push   $0x0
  8022ab:	6a 00                	push   $0x0
  8022ad:	6a 16                	push   $0x16
  8022af:	e8 b9 fd ff ff       	call   80206d <syscall>
  8022b4:	83 c4 18             	add    $0x18,%esp
}
  8022b7:	90                   	nop
  8022b8:	c9                   	leave  
  8022b9:	c3                   	ret    

008022ba <sys_createSemaphore>:

int
sys_createSemaphore(char* semaphoreName, uint32 initialValue)
{
  8022ba:	55                   	push   %ebp
  8022bb:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_semaphore,(uint32)semaphoreName, (uint32)initialValue, 0, 0, 0);
  8022bd:	8b 45 08             	mov    0x8(%ebp),%eax
  8022c0:	6a 00                	push   $0x0
  8022c2:	6a 00                	push   $0x0
  8022c4:	6a 00                	push   $0x0
  8022c6:	ff 75 0c             	pushl  0xc(%ebp)
  8022c9:	50                   	push   %eax
  8022ca:	6a 17                	push   $0x17
  8022cc:	e8 9c fd ff ff       	call   80206d <syscall>
  8022d1:	83 c4 18             	add    $0x18,%esp
}
  8022d4:	c9                   	leave  
  8022d5:	c3                   	ret    

008022d6 <sys_getSemaphoreValue>:

int
sys_getSemaphoreValue(int32 ownerEnvID, char* semaphoreName)
{
  8022d6:	55                   	push   %ebp
  8022d7:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_semaphore_value,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  8022d9:	8b 55 0c             	mov    0xc(%ebp),%edx
  8022dc:	8b 45 08             	mov    0x8(%ebp),%eax
  8022df:	6a 00                	push   $0x0
  8022e1:	6a 00                	push   $0x0
  8022e3:	6a 00                	push   $0x0
  8022e5:	52                   	push   %edx
  8022e6:	50                   	push   %eax
  8022e7:	6a 1a                	push   $0x1a
  8022e9:	e8 7f fd ff ff       	call   80206d <syscall>
  8022ee:	83 c4 18             	add    $0x18,%esp
}
  8022f1:	c9                   	leave  
  8022f2:	c3                   	ret    

008022f3 <sys_waitSemaphore>:

void
sys_waitSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  8022f3:	55                   	push   %ebp
  8022f4:	89 e5                	mov    %esp,%ebp
	syscall(SYS_wait_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  8022f6:	8b 55 0c             	mov    0xc(%ebp),%edx
  8022f9:	8b 45 08             	mov    0x8(%ebp),%eax
  8022fc:	6a 00                	push   $0x0
  8022fe:	6a 00                	push   $0x0
  802300:	6a 00                	push   $0x0
  802302:	52                   	push   %edx
  802303:	50                   	push   %eax
  802304:	6a 18                	push   $0x18
  802306:	e8 62 fd ff ff       	call   80206d <syscall>
  80230b:	83 c4 18             	add    $0x18,%esp
}
  80230e:	90                   	nop
  80230f:	c9                   	leave  
  802310:	c3                   	ret    

00802311 <sys_signalSemaphore>:

void
sys_signalSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  802311:	55                   	push   %ebp
  802312:	89 e5                	mov    %esp,%ebp
	syscall(SYS_signal_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  802314:	8b 55 0c             	mov    0xc(%ebp),%edx
  802317:	8b 45 08             	mov    0x8(%ebp),%eax
  80231a:	6a 00                	push   $0x0
  80231c:	6a 00                	push   $0x0
  80231e:	6a 00                	push   $0x0
  802320:	52                   	push   %edx
  802321:	50                   	push   %eax
  802322:	6a 19                	push   $0x19
  802324:	e8 44 fd ff ff       	call   80206d <syscall>
  802329:	83 c4 18             	add    $0x18,%esp
}
  80232c:	90                   	nop
  80232d:	c9                   	leave  
  80232e:	c3                   	ret    

0080232f <sys_createSharedObject>:

int
sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  80232f:	55                   	push   %ebp
  802330:	89 e5                	mov    %esp,%ebp
  802332:	83 ec 04             	sub    $0x4,%esp
  802335:	8b 45 10             	mov    0x10(%ebp),%eax
  802338:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  80233b:	8b 4d 14             	mov    0x14(%ebp),%ecx
  80233e:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  802342:	8b 45 08             	mov    0x8(%ebp),%eax
  802345:	6a 00                	push   $0x0
  802347:	51                   	push   %ecx
  802348:	52                   	push   %edx
  802349:	ff 75 0c             	pushl  0xc(%ebp)
  80234c:	50                   	push   %eax
  80234d:	6a 1b                	push   $0x1b
  80234f:	e8 19 fd ff ff       	call   80206d <syscall>
  802354:	83 c4 18             	add    $0x18,%esp
}
  802357:	c9                   	leave  
  802358:	c3                   	ret    

00802359 <sys_getSizeOfSharedObject>:

//2017:
int
sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  802359:	55                   	push   %ebp
  80235a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  80235c:	8b 55 0c             	mov    0xc(%ebp),%edx
  80235f:	8b 45 08             	mov    0x8(%ebp),%eax
  802362:	6a 00                	push   $0x0
  802364:	6a 00                	push   $0x0
  802366:	6a 00                	push   $0x0
  802368:	52                   	push   %edx
  802369:	50                   	push   %eax
  80236a:	6a 1c                	push   $0x1c
  80236c:	e8 fc fc ff ff       	call   80206d <syscall>
  802371:	83 c4 18             	add    $0x18,%esp
}
  802374:	c9                   	leave  
  802375:	c3                   	ret    

00802376 <sys_getSharedObject>:
//==========

int
sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  802376:	55                   	push   %ebp
  802377:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  802379:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80237c:	8b 55 0c             	mov    0xc(%ebp),%edx
  80237f:	8b 45 08             	mov    0x8(%ebp),%eax
  802382:	6a 00                	push   $0x0
  802384:	6a 00                	push   $0x0
  802386:	51                   	push   %ecx
  802387:	52                   	push   %edx
  802388:	50                   	push   %eax
  802389:	6a 1d                	push   $0x1d
  80238b:	e8 dd fc ff ff       	call   80206d <syscall>
  802390:	83 c4 18             	add    $0x18,%esp
}
  802393:	c9                   	leave  
  802394:	c3                   	ret    

00802395 <sys_freeSharedObject>:

int
sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  802395:	55                   	push   %ebp
  802396:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  802398:	8b 55 0c             	mov    0xc(%ebp),%edx
  80239b:	8b 45 08             	mov    0x8(%ebp),%eax
  80239e:	6a 00                	push   $0x0
  8023a0:	6a 00                	push   $0x0
  8023a2:	6a 00                	push   $0x0
  8023a4:	52                   	push   %edx
  8023a5:	50                   	push   %eax
  8023a6:	6a 1e                	push   $0x1e
  8023a8:	e8 c0 fc ff ff       	call   80206d <syscall>
  8023ad:	83 c4 18             	add    $0x18,%esp
}
  8023b0:	c9                   	leave  
  8023b1:	c3                   	ret    

008023b2 <sys_getMaxShares>:

uint32 	sys_getMaxShares()
{
  8023b2:	55                   	push   %ebp
  8023b3:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_max_shares,0, 0, 0, 0, 0);
  8023b5:	6a 00                	push   $0x0
  8023b7:	6a 00                	push   $0x0
  8023b9:	6a 00                	push   $0x0
  8023bb:	6a 00                	push   $0x0
  8023bd:	6a 00                	push   $0x0
  8023bf:	6a 1f                	push   $0x1f
  8023c1:	e8 a7 fc ff ff       	call   80206d <syscall>
  8023c6:	83 c4 18             	add    $0x18,%esp
}
  8023c9:	c9                   	leave  
  8023ca:	c3                   	ret    

008023cb <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  8023cb:	55                   	push   %ebp
  8023cc:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  8023ce:	8b 45 08             	mov    0x8(%ebp),%eax
  8023d1:	6a 00                	push   $0x0
  8023d3:	ff 75 14             	pushl  0x14(%ebp)
  8023d6:	ff 75 10             	pushl  0x10(%ebp)
  8023d9:	ff 75 0c             	pushl  0xc(%ebp)
  8023dc:	50                   	push   %eax
  8023dd:	6a 20                	push   $0x20
  8023df:	e8 89 fc ff ff       	call   80206d <syscall>
  8023e4:	83 c4 18             	add    $0x18,%esp
}
  8023e7:	c9                   	leave  
  8023e8:	c3                   	ret    

008023e9 <sys_run_env>:

void
sys_run_env(int32 envId)
{
  8023e9:	55                   	push   %ebp
  8023ea:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  8023ec:	8b 45 08             	mov    0x8(%ebp),%eax
  8023ef:	6a 00                	push   $0x0
  8023f1:	6a 00                	push   $0x0
  8023f3:	6a 00                	push   $0x0
  8023f5:	6a 00                	push   $0x0
  8023f7:	50                   	push   %eax
  8023f8:	6a 21                	push   $0x21
  8023fa:	e8 6e fc ff ff       	call   80206d <syscall>
  8023ff:	83 c4 18             	add    $0x18,%esp
}
  802402:	90                   	nop
  802403:	c9                   	leave  
  802404:	c3                   	ret    

00802405 <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  802405:	55                   	push   %ebp
  802406:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  802408:	8b 45 08             	mov    0x8(%ebp),%eax
  80240b:	6a 00                	push   $0x0
  80240d:	6a 00                	push   $0x0
  80240f:	6a 00                	push   $0x0
  802411:	6a 00                	push   $0x0
  802413:	50                   	push   %eax
  802414:	6a 22                	push   $0x22
  802416:	e8 52 fc ff ff       	call   80206d <syscall>
  80241b:	83 c4 18             	add    $0x18,%esp
}
  80241e:	c9                   	leave  
  80241f:	c3                   	ret    

00802420 <sys_getenvid>:

int32 sys_getenvid(void)
{
  802420:	55                   	push   %ebp
  802421:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  802423:	6a 00                	push   $0x0
  802425:	6a 00                	push   $0x0
  802427:	6a 00                	push   $0x0
  802429:	6a 00                	push   $0x0
  80242b:	6a 00                	push   $0x0
  80242d:	6a 02                	push   $0x2
  80242f:	e8 39 fc ff ff       	call   80206d <syscall>
  802434:	83 c4 18             	add    $0x18,%esp
}
  802437:	c9                   	leave  
  802438:	c3                   	ret    

00802439 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  802439:	55                   	push   %ebp
  80243a:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  80243c:	6a 00                	push   $0x0
  80243e:	6a 00                	push   $0x0
  802440:	6a 00                	push   $0x0
  802442:	6a 00                	push   $0x0
  802444:	6a 00                	push   $0x0
  802446:	6a 03                	push   $0x3
  802448:	e8 20 fc ff ff       	call   80206d <syscall>
  80244d:	83 c4 18             	add    $0x18,%esp
}
  802450:	c9                   	leave  
  802451:	c3                   	ret    

00802452 <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  802452:	55                   	push   %ebp
  802453:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  802455:	6a 00                	push   $0x0
  802457:	6a 00                	push   $0x0
  802459:	6a 00                	push   $0x0
  80245b:	6a 00                	push   $0x0
  80245d:	6a 00                	push   $0x0
  80245f:	6a 04                	push   $0x4
  802461:	e8 07 fc ff ff       	call   80206d <syscall>
  802466:	83 c4 18             	add    $0x18,%esp
}
  802469:	c9                   	leave  
  80246a:	c3                   	ret    

0080246b <sys_exit_env>:


void sys_exit_env(void)
{
  80246b:	55                   	push   %ebp
  80246c:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  80246e:	6a 00                	push   $0x0
  802470:	6a 00                	push   $0x0
  802472:	6a 00                	push   $0x0
  802474:	6a 00                	push   $0x0
  802476:	6a 00                	push   $0x0
  802478:	6a 23                	push   $0x23
  80247a:	e8 ee fb ff ff       	call   80206d <syscall>
  80247f:	83 c4 18             	add    $0x18,%esp
}
  802482:	90                   	nop
  802483:	c9                   	leave  
  802484:	c3                   	ret    

00802485 <sys_get_virtual_time>:


struct uint64
sys_get_virtual_time()
{
  802485:	55                   	push   %ebp
  802486:	89 e5                	mov    %esp,%ebp
  802488:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  80248b:	8d 45 f8             	lea    -0x8(%ebp),%eax
  80248e:	8d 50 04             	lea    0x4(%eax),%edx
  802491:	8d 45 f8             	lea    -0x8(%ebp),%eax
  802494:	6a 00                	push   $0x0
  802496:	6a 00                	push   $0x0
  802498:	6a 00                	push   $0x0
  80249a:	52                   	push   %edx
  80249b:	50                   	push   %eax
  80249c:	6a 24                	push   $0x24
  80249e:	e8 ca fb ff ff       	call   80206d <syscall>
  8024a3:	83 c4 18             	add    $0x18,%esp
	return result;
  8024a6:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8024a9:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8024ac:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8024af:	89 01                	mov    %eax,(%ecx)
  8024b1:	89 51 04             	mov    %edx,0x4(%ecx)
}
  8024b4:	8b 45 08             	mov    0x8(%ebp),%eax
  8024b7:	c9                   	leave  
  8024b8:	c2 04 00             	ret    $0x4

008024bb <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  8024bb:	55                   	push   %ebp
  8024bc:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  8024be:	6a 00                	push   $0x0
  8024c0:	6a 00                	push   $0x0
  8024c2:	ff 75 10             	pushl  0x10(%ebp)
  8024c5:	ff 75 0c             	pushl  0xc(%ebp)
  8024c8:	ff 75 08             	pushl  0x8(%ebp)
  8024cb:	6a 12                	push   $0x12
  8024cd:	e8 9b fb ff ff       	call   80206d <syscall>
  8024d2:	83 c4 18             	add    $0x18,%esp
	return ;
  8024d5:	90                   	nop
}
  8024d6:	c9                   	leave  
  8024d7:	c3                   	ret    

008024d8 <sys_rcr2>:
uint32 sys_rcr2()
{
  8024d8:	55                   	push   %ebp
  8024d9:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  8024db:	6a 00                	push   $0x0
  8024dd:	6a 00                	push   $0x0
  8024df:	6a 00                	push   $0x0
  8024e1:	6a 00                	push   $0x0
  8024e3:	6a 00                	push   $0x0
  8024e5:	6a 25                	push   $0x25
  8024e7:	e8 81 fb ff ff       	call   80206d <syscall>
  8024ec:	83 c4 18             	add    $0x18,%esp
}
  8024ef:	c9                   	leave  
  8024f0:	c3                   	ret    

008024f1 <sys_bypassPageFault>:
void sys_bypassPageFault(uint8 instrLength)
{
  8024f1:	55                   	push   %ebp
  8024f2:	89 e5                	mov    %esp,%ebp
  8024f4:	83 ec 04             	sub    $0x4,%esp
  8024f7:	8b 45 08             	mov    0x8(%ebp),%eax
  8024fa:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  8024fd:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  802501:	6a 00                	push   $0x0
  802503:	6a 00                	push   $0x0
  802505:	6a 00                	push   $0x0
  802507:	6a 00                	push   $0x0
  802509:	50                   	push   %eax
  80250a:	6a 26                	push   $0x26
  80250c:	e8 5c fb ff ff       	call   80206d <syscall>
  802511:	83 c4 18             	add    $0x18,%esp
	return ;
  802514:	90                   	nop
}
  802515:	c9                   	leave  
  802516:	c3                   	ret    

00802517 <rsttst>:
void rsttst()
{
  802517:	55                   	push   %ebp
  802518:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  80251a:	6a 00                	push   $0x0
  80251c:	6a 00                	push   $0x0
  80251e:	6a 00                	push   $0x0
  802520:	6a 00                	push   $0x0
  802522:	6a 00                	push   $0x0
  802524:	6a 28                	push   $0x28
  802526:	e8 42 fb ff ff       	call   80206d <syscall>
  80252b:	83 c4 18             	add    $0x18,%esp
	return ;
  80252e:	90                   	nop
}
  80252f:	c9                   	leave  
  802530:	c3                   	ret    

00802531 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  802531:	55                   	push   %ebp
  802532:	89 e5                	mov    %esp,%ebp
  802534:	83 ec 04             	sub    $0x4,%esp
  802537:	8b 45 14             	mov    0x14(%ebp),%eax
  80253a:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  80253d:	8b 55 18             	mov    0x18(%ebp),%edx
  802540:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  802544:	52                   	push   %edx
  802545:	50                   	push   %eax
  802546:	ff 75 10             	pushl  0x10(%ebp)
  802549:	ff 75 0c             	pushl  0xc(%ebp)
  80254c:	ff 75 08             	pushl  0x8(%ebp)
  80254f:	6a 27                	push   $0x27
  802551:	e8 17 fb ff ff       	call   80206d <syscall>
  802556:	83 c4 18             	add    $0x18,%esp
	return ;
  802559:	90                   	nop
}
  80255a:	c9                   	leave  
  80255b:	c3                   	ret    

0080255c <chktst>:
void chktst(uint32 n)
{
  80255c:	55                   	push   %ebp
  80255d:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  80255f:	6a 00                	push   $0x0
  802561:	6a 00                	push   $0x0
  802563:	6a 00                	push   $0x0
  802565:	6a 00                	push   $0x0
  802567:	ff 75 08             	pushl  0x8(%ebp)
  80256a:	6a 29                	push   $0x29
  80256c:	e8 fc fa ff ff       	call   80206d <syscall>
  802571:	83 c4 18             	add    $0x18,%esp
	return ;
  802574:	90                   	nop
}
  802575:	c9                   	leave  
  802576:	c3                   	ret    

00802577 <inctst>:

void inctst()
{
  802577:	55                   	push   %ebp
  802578:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  80257a:	6a 00                	push   $0x0
  80257c:	6a 00                	push   $0x0
  80257e:	6a 00                	push   $0x0
  802580:	6a 00                	push   $0x0
  802582:	6a 00                	push   $0x0
  802584:	6a 2a                	push   $0x2a
  802586:	e8 e2 fa ff ff       	call   80206d <syscall>
  80258b:	83 c4 18             	add    $0x18,%esp
	return ;
  80258e:	90                   	nop
}
  80258f:	c9                   	leave  
  802590:	c3                   	ret    

00802591 <gettst>:
uint32 gettst()
{
  802591:	55                   	push   %ebp
  802592:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  802594:	6a 00                	push   $0x0
  802596:	6a 00                	push   $0x0
  802598:	6a 00                	push   $0x0
  80259a:	6a 00                	push   $0x0
  80259c:	6a 00                	push   $0x0
  80259e:	6a 2b                	push   $0x2b
  8025a0:	e8 c8 fa ff ff       	call   80206d <syscall>
  8025a5:	83 c4 18             	add    $0x18,%esp
}
  8025a8:	c9                   	leave  
  8025a9:	c3                   	ret    

008025aa <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  8025aa:	55                   	push   %ebp
  8025ab:	89 e5                	mov    %esp,%ebp
  8025ad:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8025b0:	6a 00                	push   $0x0
  8025b2:	6a 00                	push   $0x0
  8025b4:	6a 00                	push   $0x0
  8025b6:	6a 00                	push   $0x0
  8025b8:	6a 00                	push   $0x0
  8025ba:	6a 2c                	push   $0x2c
  8025bc:	e8 ac fa ff ff       	call   80206d <syscall>
  8025c1:	83 c4 18             	add    $0x18,%esp
  8025c4:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  8025c7:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  8025cb:	75 07                	jne    8025d4 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  8025cd:	b8 01 00 00 00       	mov    $0x1,%eax
  8025d2:	eb 05                	jmp    8025d9 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  8025d4:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8025d9:	c9                   	leave  
  8025da:	c3                   	ret    

008025db <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  8025db:	55                   	push   %ebp
  8025dc:	89 e5                	mov    %esp,%ebp
  8025de:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8025e1:	6a 00                	push   $0x0
  8025e3:	6a 00                	push   $0x0
  8025e5:	6a 00                	push   $0x0
  8025e7:	6a 00                	push   $0x0
  8025e9:	6a 00                	push   $0x0
  8025eb:	6a 2c                	push   $0x2c
  8025ed:	e8 7b fa ff ff       	call   80206d <syscall>
  8025f2:	83 c4 18             	add    $0x18,%esp
  8025f5:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  8025f8:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  8025fc:	75 07                	jne    802605 <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  8025fe:	b8 01 00 00 00       	mov    $0x1,%eax
  802603:	eb 05                	jmp    80260a <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  802605:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80260a:	c9                   	leave  
  80260b:	c3                   	ret    

0080260c <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  80260c:	55                   	push   %ebp
  80260d:	89 e5                	mov    %esp,%ebp
  80260f:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  802612:	6a 00                	push   $0x0
  802614:	6a 00                	push   $0x0
  802616:	6a 00                	push   $0x0
  802618:	6a 00                	push   $0x0
  80261a:	6a 00                	push   $0x0
  80261c:	6a 2c                	push   $0x2c
  80261e:	e8 4a fa ff ff       	call   80206d <syscall>
  802623:	83 c4 18             	add    $0x18,%esp
  802626:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  802629:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  80262d:	75 07                	jne    802636 <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  80262f:	b8 01 00 00 00       	mov    $0x1,%eax
  802634:	eb 05                	jmp    80263b <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  802636:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80263b:	c9                   	leave  
  80263c:	c3                   	ret    

0080263d <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  80263d:	55                   	push   %ebp
  80263e:	89 e5                	mov    %esp,%ebp
  802640:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  802643:	6a 00                	push   $0x0
  802645:	6a 00                	push   $0x0
  802647:	6a 00                	push   $0x0
  802649:	6a 00                	push   $0x0
  80264b:	6a 00                	push   $0x0
  80264d:	6a 2c                	push   $0x2c
  80264f:	e8 19 fa ff ff       	call   80206d <syscall>
  802654:	83 c4 18             	add    $0x18,%esp
  802657:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  80265a:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  80265e:	75 07                	jne    802667 <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  802660:	b8 01 00 00 00       	mov    $0x1,%eax
  802665:	eb 05                	jmp    80266c <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  802667:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80266c:	c9                   	leave  
  80266d:	c3                   	ret    

0080266e <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  80266e:	55                   	push   %ebp
  80266f:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  802671:	6a 00                	push   $0x0
  802673:	6a 00                	push   $0x0
  802675:	6a 00                	push   $0x0
  802677:	6a 00                	push   $0x0
  802679:	ff 75 08             	pushl  0x8(%ebp)
  80267c:	6a 2d                	push   $0x2d
  80267e:	e8 ea f9 ff ff       	call   80206d <syscall>
  802683:	83 c4 18             	add    $0x18,%esp
	return ;
  802686:	90                   	nop
}
  802687:	c9                   	leave  
  802688:	c3                   	ret    

00802689 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  802689:	55                   	push   %ebp
  80268a:	89 e5                	mov    %esp,%ebp
  80268c:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  80268d:	8b 5d 14             	mov    0x14(%ebp),%ebx
  802690:	8b 4d 10             	mov    0x10(%ebp),%ecx
  802693:	8b 55 0c             	mov    0xc(%ebp),%edx
  802696:	8b 45 08             	mov    0x8(%ebp),%eax
  802699:	6a 00                	push   $0x0
  80269b:	53                   	push   %ebx
  80269c:	51                   	push   %ecx
  80269d:	52                   	push   %edx
  80269e:	50                   	push   %eax
  80269f:	6a 2e                	push   $0x2e
  8026a1:	e8 c7 f9 ff ff       	call   80206d <syscall>
  8026a6:	83 c4 18             	add    $0x18,%esp
}
  8026a9:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8026ac:	c9                   	leave  
  8026ad:	c3                   	ret    

008026ae <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  8026ae:	55                   	push   %ebp
  8026af:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  8026b1:	8b 55 0c             	mov    0xc(%ebp),%edx
  8026b4:	8b 45 08             	mov    0x8(%ebp),%eax
  8026b7:	6a 00                	push   $0x0
  8026b9:	6a 00                	push   $0x0
  8026bb:	6a 00                	push   $0x0
  8026bd:	52                   	push   %edx
  8026be:	50                   	push   %eax
  8026bf:	6a 2f                	push   $0x2f
  8026c1:	e8 a7 f9 ff ff       	call   80206d <syscall>
  8026c6:	83 c4 18             	add    $0x18,%esp
}
  8026c9:	c9                   	leave  
  8026ca:	c3                   	ret    

008026cb <print_mem_block_lists>:
//===========================
// PRINT MEM BLOCK LISTS:
//===========================

void print_mem_block_lists()
{
  8026cb:	55                   	push   %ebp
  8026cc:	89 e5                	mov    %esp,%ebp
  8026ce:	83 ec 18             	sub    $0x18,%esp
	cprintf("\n=========================================\n");
  8026d1:	83 ec 0c             	sub    $0xc,%esp
  8026d4:	68 b4 41 80 00       	push   $0x8041b4
  8026d9:	e8 d7 e4 ff ff       	call   800bb5 <cprintf>
  8026de:	83 c4 10             	add    $0x10,%esp
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
  8026e1:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nFreeMemBlocksList:\n");
  8026e8:	83 ec 0c             	sub    $0xc,%esp
  8026eb:	68 e0 41 80 00       	push   $0x8041e0
  8026f0:	e8 c0 e4 ff ff       	call   800bb5 <cprintf>
  8026f5:	83 c4 10             	add    $0x10,%esp
	uint8 sorted = 1 ;
  8026f8:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &FreeMemBlocksList)
  8026fc:	a1 38 51 80 00       	mov    0x805138,%eax
  802701:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802704:	eb 56                	jmp    80275c <print_mem_block_lists+0x91>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  802706:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80270a:	74 1c                	je     802728 <print_mem_block_lists+0x5d>
  80270c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80270f:	8b 50 08             	mov    0x8(%eax),%edx
  802712:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802715:	8b 48 08             	mov    0x8(%eax),%ecx
  802718:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80271b:	8b 40 0c             	mov    0xc(%eax),%eax
  80271e:	01 c8                	add    %ecx,%eax
  802720:	39 c2                	cmp    %eax,%edx
  802722:	73 04                	jae    802728 <print_mem_block_lists+0x5d>
			sorted = 0 ;
  802724:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  802728:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80272b:	8b 50 08             	mov    0x8(%eax),%edx
  80272e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802731:	8b 40 0c             	mov    0xc(%eax),%eax
  802734:	01 c2                	add    %eax,%edx
  802736:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802739:	8b 40 08             	mov    0x8(%eax),%eax
  80273c:	83 ec 04             	sub    $0x4,%esp
  80273f:	52                   	push   %edx
  802740:	50                   	push   %eax
  802741:	68 f5 41 80 00       	push   $0x8041f5
  802746:	e8 6a e4 ff ff       	call   800bb5 <cprintf>
  80274b:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  80274e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802751:	89 45 f0             	mov    %eax,-0x10(%ebp)
	cprintf("\n=========================================\n");
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
	cprintf("\nFreeMemBlocksList:\n");
	uint8 sorted = 1 ;
	LIST_FOREACH(blk, &FreeMemBlocksList)
  802754:	a1 40 51 80 00       	mov    0x805140,%eax
  802759:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80275c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802760:	74 07                	je     802769 <print_mem_block_lists+0x9e>
  802762:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802765:	8b 00                	mov    (%eax),%eax
  802767:	eb 05                	jmp    80276e <print_mem_block_lists+0xa3>
  802769:	b8 00 00 00 00       	mov    $0x0,%eax
  80276e:	a3 40 51 80 00       	mov    %eax,0x805140
  802773:	a1 40 51 80 00       	mov    0x805140,%eax
  802778:	85 c0                	test   %eax,%eax
  80277a:	75 8a                	jne    802706 <print_mem_block_lists+0x3b>
  80277c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802780:	75 84                	jne    802706 <print_mem_block_lists+0x3b>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;
  802782:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  802786:	75 10                	jne    802798 <print_mem_block_lists+0xcd>
  802788:	83 ec 0c             	sub    $0xc,%esp
  80278b:	68 04 42 80 00       	push   $0x804204
  802790:	e8 20 e4 ff ff       	call   800bb5 <cprintf>
  802795:	83 c4 10             	add    $0x10,%esp

	lastBlk = NULL ;
  802798:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nAllocMemBlocksList:\n");
  80279f:	83 ec 0c             	sub    $0xc,%esp
  8027a2:	68 28 42 80 00       	push   $0x804228
  8027a7:	e8 09 e4 ff ff       	call   800bb5 <cprintf>
  8027ac:	83 c4 10             	add    $0x10,%esp
	sorted = 1 ;
  8027af:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &AllocMemBlocksList)
  8027b3:	a1 40 50 80 00       	mov    0x805040,%eax
  8027b8:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8027bb:	eb 56                	jmp    802813 <print_mem_block_lists+0x148>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  8027bd:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8027c1:	74 1c                	je     8027df <print_mem_block_lists+0x114>
  8027c3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027c6:	8b 50 08             	mov    0x8(%eax),%edx
  8027c9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8027cc:	8b 48 08             	mov    0x8(%eax),%ecx
  8027cf:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8027d2:	8b 40 0c             	mov    0xc(%eax),%eax
  8027d5:	01 c8                	add    %ecx,%eax
  8027d7:	39 c2                	cmp    %eax,%edx
  8027d9:	73 04                	jae    8027df <print_mem_block_lists+0x114>
			sorted = 0 ;
  8027db:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  8027df:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027e2:	8b 50 08             	mov    0x8(%eax),%edx
  8027e5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027e8:	8b 40 0c             	mov    0xc(%eax),%eax
  8027eb:	01 c2                	add    %eax,%edx
  8027ed:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027f0:	8b 40 08             	mov    0x8(%eax),%eax
  8027f3:	83 ec 04             	sub    $0x4,%esp
  8027f6:	52                   	push   %edx
  8027f7:	50                   	push   %eax
  8027f8:	68 f5 41 80 00       	push   $0x8041f5
  8027fd:	e8 b3 e3 ff ff       	call   800bb5 <cprintf>
  802802:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  802805:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802808:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;

	lastBlk = NULL ;
	cprintf("\nAllocMemBlocksList:\n");
	sorted = 1 ;
	LIST_FOREACH(blk, &AllocMemBlocksList)
  80280b:	a1 48 50 80 00       	mov    0x805048,%eax
  802810:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802813:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802817:	74 07                	je     802820 <print_mem_block_lists+0x155>
  802819:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80281c:	8b 00                	mov    (%eax),%eax
  80281e:	eb 05                	jmp    802825 <print_mem_block_lists+0x15a>
  802820:	b8 00 00 00 00       	mov    $0x0,%eax
  802825:	a3 48 50 80 00       	mov    %eax,0x805048
  80282a:	a1 48 50 80 00       	mov    0x805048,%eax
  80282f:	85 c0                	test   %eax,%eax
  802831:	75 8a                	jne    8027bd <print_mem_block_lists+0xf2>
  802833:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802837:	75 84                	jne    8027bd <print_mem_block_lists+0xf2>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nAllocMemBlocksList is NOT SORTED!!\n") ;
  802839:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  80283d:	75 10                	jne    80284f <print_mem_block_lists+0x184>
  80283f:	83 ec 0c             	sub    $0xc,%esp
  802842:	68 40 42 80 00       	push   $0x804240
  802847:	e8 69 e3 ff ff       	call   800bb5 <cprintf>
  80284c:	83 c4 10             	add    $0x10,%esp
	cprintf("\n=========================================\n");
  80284f:	83 ec 0c             	sub    $0xc,%esp
  802852:	68 b4 41 80 00       	push   $0x8041b4
  802857:	e8 59 e3 ff ff       	call   800bb5 <cprintf>
  80285c:	83 c4 10             	add    $0x10,%esp

}
  80285f:	90                   	nop
  802860:	c9                   	leave  
  802861:	c3                   	ret    

00802862 <initialize_MemBlocksList>:

//===============================
// [1] INITIALIZE AVAILABLE LIST:
//===============================
void initialize_MemBlocksList(uint32 numOfBlocks)
{
  802862:	55                   	push   %ebp
  802863:	89 e5                	mov    %esp,%ebp
  802865:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] initialize_MemBlocksList
	// Write your code here, remove the panic and write your code
	//panic("initialize_MemBlocksList() is not implemented yet...!!");
	uint32 n = numOfBlocks;
  802868:	8b 45 08             	mov    0x8(%ebp),%eax
  80286b:	89 45 f0             	mov    %eax,-0x10(%ebp)

	LIST_INIT(&AvailableMemBlocksList);
  80286e:	c7 05 48 51 80 00 00 	movl   $0x0,0x805148
  802875:	00 00 00 
  802878:	c7 05 4c 51 80 00 00 	movl   $0x0,0x80514c
  80287f:	00 00 00 
  802882:	c7 05 54 51 80 00 00 	movl   $0x0,0x805154
  802889:	00 00 00 
	for(int i = 0; i<n;i++)
  80288c:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  802893:	e9 9e 00 00 00       	jmp    802936 <initialize_MemBlocksList+0xd4>
	{
		LIST_INSERT_HEAD(&AvailableMemBlocksList, &(MemBlockNodes[i]));
  802898:	a1 50 50 80 00       	mov    0x805050,%eax
  80289d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8028a0:	c1 e2 04             	shl    $0x4,%edx
  8028a3:	01 d0                	add    %edx,%eax
  8028a5:	85 c0                	test   %eax,%eax
  8028a7:	75 14                	jne    8028bd <initialize_MemBlocksList+0x5b>
  8028a9:	83 ec 04             	sub    $0x4,%esp
  8028ac:	68 68 42 80 00       	push   $0x804268
  8028b1:	6a 47                	push   $0x47
  8028b3:	68 8b 42 80 00       	push   $0x80428b
  8028b8:	e8 44 e0 ff ff       	call   800901 <_panic>
  8028bd:	a1 50 50 80 00       	mov    0x805050,%eax
  8028c2:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8028c5:	c1 e2 04             	shl    $0x4,%edx
  8028c8:	01 d0                	add    %edx,%eax
  8028ca:	8b 15 48 51 80 00    	mov    0x805148,%edx
  8028d0:	89 10                	mov    %edx,(%eax)
  8028d2:	8b 00                	mov    (%eax),%eax
  8028d4:	85 c0                	test   %eax,%eax
  8028d6:	74 18                	je     8028f0 <initialize_MemBlocksList+0x8e>
  8028d8:	a1 48 51 80 00       	mov    0x805148,%eax
  8028dd:	8b 15 50 50 80 00    	mov    0x805050,%edx
  8028e3:	8b 4d f4             	mov    -0xc(%ebp),%ecx
  8028e6:	c1 e1 04             	shl    $0x4,%ecx
  8028e9:	01 ca                	add    %ecx,%edx
  8028eb:	89 50 04             	mov    %edx,0x4(%eax)
  8028ee:	eb 12                	jmp    802902 <initialize_MemBlocksList+0xa0>
  8028f0:	a1 50 50 80 00       	mov    0x805050,%eax
  8028f5:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8028f8:	c1 e2 04             	shl    $0x4,%edx
  8028fb:	01 d0                	add    %edx,%eax
  8028fd:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802902:	a1 50 50 80 00       	mov    0x805050,%eax
  802907:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80290a:	c1 e2 04             	shl    $0x4,%edx
  80290d:	01 d0                	add    %edx,%eax
  80290f:	a3 48 51 80 00       	mov    %eax,0x805148
  802914:	a1 50 50 80 00       	mov    0x805050,%eax
  802919:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80291c:	c1 e2 04             	shl    $0x4,%edx
  80291f:	01 d0                	add    %edx,%eax
  802921:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802928:	a1 54 51 80 00       	mov    0x805154,%eax
  80292d:	40                   	inc    %eax
  80292e:	a3 54 51 80 00       	mov    %eax,0x805154
	// Write your code here, remove the panic and write your code
	//panic("initialize_MemBlocksList() is not implemented yet...!!");
	uint32 n = numOfBlocks;

	LIST_INIT(&AvailableMemBlocksList);
	for(int i = 0; i<n;i++)
  802933:	ff 45 f4             	incl   -0xc(%ebp)
  802936:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802939:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80293c:	0f 82 56 ff ff ff    	jb     802898 <initialize_MemBlocksList+0x36>
	{
		LIST_INSERT_HEAD(&AvailableMemBlocksList, &(MemBlockNodes[i]));
	}
}
  802942:	90                   	nop
  802943:	c9                   	leave  
  802944:	c3                   	ret    

00802945 <find_block>:

//===============================
// [2] FIND BLOCK:
//===============================
struct MemBlock *find_block(struct MemBlock_List *blockList, uint32 va)
{
  802945:	55                   	push   %ebp
  802946:	89 e5                	mov    %esp,%ebp
  802948:	83 ec 10             	sub    $0x10,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] find_block
	// Write your code here, remove the panic and write your code
	//panic("find_block() is not implemented yet...!!");
	uint32 virAddress = va;
  80294b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80294e:	89 45 f4             	mov    %eax,-0xc(%ebp)
	struct MemBlock* blk;
	int found = 0;
  802951:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	LIST_FOREACH(blk, &(AllocMemBlocksList))
  802958:	a1 40 50 80 00       	mov    0x805040,%eax
  80295d:	89 45 fc             	mov    %eax,-0x4(%ebp)
  802960:	eb 23                	jmp    802985 <find_block+0x40>
	{
		if(blk->sva == virAddress)
  802962:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802965:	8b 40 08             	mov    0x8(%eax),%eax
  802968:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  80296b:	75 09                	jne    802976 <find_block+0x31>
		{
			found = 1;
  80296d:	c7 45 f8 01 00 00 00 	movl   $0x1,-0x8(%ebp)
			break;
  802974:	eb 35                	jmp    8029ab <find_block+0x66>
		}
		else
		{
			found = 0;
  802976:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	//panic("find_block() is not implemented yet...!!");
	uint32 virAddress = va;
	struct MemBlock* blk;
	int found = 0;

	LIST_FOREACH(blk, &(AllocMemBlocksList))
  80297d:	a1 48 50 80 00       	mov    0x805048,%eax
  802982:	89 45 fc             	mov    %eax,-0x4(%ebp)
  802985:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  802989:	74 07                	je     802992 <find_block+0x4d>
  80298b:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80298e:	8b 00                	mov    (%eax),%eax
  802990:	eb 05                	jmp    802997 <find_block+0x52>
  802992:	b8 00 00 00 00       	mov    $0x0,%eax
  802997:	a3 48 50 80 00       	mov    %eax,0x805048
  80299c:	a1 48 50 80 00       	mov    0x805048,%eax
  8029a1:	85 c0                	test   %eax,%eax
  8029a3:	75 bd                	jne    802962 <find_block+0x1d>
  8029a5:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8029a9:	75 b7                	jne    802962 <find_block+0x1d>
		{
			found = 0;
			continue;
		}
	}
	if(found == 1)
  8029ab:	83 7d f8 01          	cmpl   $0x1,-0x8(%ebp)
  8029af:	75 05                	jne    8029b6 <find_block+0x71>
	{
		return blk;
  8029b1:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8029b4:	eb 05                	jmp    8029bb <find_block+0x76>
	}
	else
	{
		return NULL;
  8029b6:	b8 00 00 00 00       	mov    $0x0,%eax
	}
}
  8029bb:	c9                   	leave  
  8029bc:	c3                   	ret    

008029bd <insert_sorted_allocList>:

//=========================================
// [3] INSERT BLOCK IN ALLOC LIST [SORTED]:
//=========================================
void insert_sorted_allocList(struct MemBlock *blockToInsert)
{
  8029bd:	55                   	push   %ebp
  8029be:	89 e5                	mov    %esp,%ebp
  8029c0:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] insert_sorted_allocList
	// Write your code here, remove the panic and write your code
	//panic("insert_sorted_allocList() is not implemented yet...!!");
	struct MemBlock* blk;
	struct MemBlock* newblk = blockToInsert;
  8029c3:	8b 45 08             	mov    0x8(%ebp),%eax
  8029c6:	89 45 f0             	mov    %eax,-0x10(%ebp)

	if((LIST_EMPTY(&AllocMemBlocksList)) || (newblk->sva < LIST_FIRST(&AllocMemBlocksList)->sva))
  8029c9:	a1 40 50 80 00       	mov    0x805040,%eax
  8029ce:	85 c0                	test   %eax,%eax
  8029d0:	74 12                	je     8029e4 <insert_sorted_allocList+0x27>
  8029d2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8029d5:	8b 50 08             	mov    0x8(%eax),%edx
  8029d8:	a1 40 50 80 00       	mov    0x805040,%eax
  8029dd:	8b 40 08             	mov    0x8(%eax),%eax
  8029e0:	39 c2                	cmp    %eax,%edx
  8029e2:	73 65                	jae    802a49 <insert_sorted_allocList+0x8c>
	{
		LIST_INSERT_HEAD(&(AllocMemBlocksList), newblk);
  8029e4:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8029e8:	75 14                	jne    8029fe <insert_sorted_allocList+0x41>
  8029ea:	83 ec 04             	sub    $0x4,%esp
  8029ed:	68 68 42 80 00       	push   $0x804268
  8029f2:	6a 7b                	push   $0x7b
  8029f4:	68 8b 42 80 00       	push   $0x80428b
  8029f9:	e8 03 df ff ff       	call   800901 <_panic>
  8029fe:	8b 15 40 50 80 00    	mov    0x805040,%edx
  802a04:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a07:	89 10                	mov    %edx,(%eax)
  802a09:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a0c:	8b 00                	mov    (%eax),%eax
  802a0e:	85 c0                	test   %eax,%eax
  802a10:	74 0d                	je     802a1f <insert_sorted_allocList+0x62>
  802a12:	a1 40 50 80 00       	mov    0x805040,%eax
  802a17:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802a1a:	89 50 04             	mov    %edx,0x4(%eax)
  802a1d:	eb 08                	jmp    802a27 <insert_sorted_allocList+0x6a>
  802a1f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a22:	a3 44 50 80 00       	mov    %eax,0x805044
  802a27:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a2a:	a3 40 50 80 00       	mov    %eax,0x805040
  802a2f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a32:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802a39:	a1 4c 50 80 00       	mov    0x80504c,%eax
  802a3e:	40                   	inc    %eax
  802a3f:	a3 4c 50 80 00       	mov    %eax,0x80504c
  802a44:	e9 5f 01 00 00       	jmp    802ba8 <insert_sorted_allocList+0x1eb>
	}
	else if(newblk->sva > LIST_LAST(&AllocMemBlocksList)->sva)
  802a49:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a4c:	8b 50 08             	mov    0x8(%eax),%edx
  802a4f:	a1 44 50 80 00       	mov    0x805044,%eax
  802a54:	8b 40 08             	mov    0x8(%eax),%eax
  802a57:	39 c2                	cmp    %eax,%edx
  802a59:	76 65                	jbe    802ac0 <insert_sorted_allocList+0x103>
	{
		LIST_INSERT_TAIL(&AllocMemBlocksList, newblk);
  802a5b:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802a5f:	75 14                	jne    802a75 <insert_sorted_allocList+0xb8>
  802a61:	83 ec 04             	sub    $0x4,%esp
  802a64:	68 a4 42 80 00       	push   $0x8042a4
  802a69:	6a 7f                	push   $0x7f
  802a6b:	68 8b 42 80 00       	push   $0x80428b
  802a70:	e8 8c de ff ff       	call   800901 <_panic>
  802a75:	8b 15 44 50 80 00    	mov    0x805044,%edx
  802a7b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a7e:	89 50 04             	mov    %edx,0x4(%eax)
  802a81:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a84:	8b 40 04             	mov    0x4(%eax),%eax
  802a87:	85 c0                	test   %eax,%eax
  802a89:	74 0c                	je     802a97 <insert_sorted_allocList+0xda>
  802a8b:	a1 44 50 80 00       	mov    0x805044,%eax
  802a90:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802a93:	89 10                	mov    %edx,(%eax)
  802a95:	eb 08                	jmp    802a9f <insert_sorted_allocList+0xe2>
  802a97:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a9a:	a3 40 50 80 00       	mov    %eax,0x805040
  802a9f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802aa2:	a3 44 50 80 00       	mov    %eax,0x805044
  802aa7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802aaa:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802ab0:	a1 4c 50 80 00       	mov    0x80504c,%eax
  802ab5:	40                   	inc    %eax
  802ab6:	a3 4c 50 80 00       	mov    %eax,0x80504c
				LIST_INSERT_AFTER(&AllocMemBlocksList, blk, newblk);
				break;
			}
		}
	}
}
  802abb:	e9 e8 00 00 00       	jmp    802ba8 <insert_sorted_allocList+0x1eb>
	{
		LIST_INSERT_TAIL(&AllocMemBlocksList, newblk);
	}
	else
	{
		LIST_FOREACH(blk, &AllocMemBlocksList)
  802ac0:	a1 40 50 80 00       	mov    0x805040,%eax
  802ac5:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802ac8:	e9 ab 00 00 00       	jmp    802b78 <insert_sorted_allocList+0x1bb>
		{
			if(blk->prev_next_info.le_next != NULL && newblk->sva > blk->sva  && newblk->sva < blk->prev_next_info.le_next->sva)
  802acd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ad0:	8b 00                	mov    (%eax),%eax
  802ad2:	85 c0                	test   %eax,%eax
  802ad4:	0f 84 96 00 00 00    	je     802b70 <insert_sorted_allocList+0x1b3>
  802ada:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802add:	8b 50 08             	mov    0x8(%eax),%edx
  802ae0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ae3:	8b 40 08             	mov    0x8(%eax),%eax
  802ae6:	39 c2                	cmp    %eax,%edx
  802ae8:	0f 86 82 00 00 00    	jbe    802b70 <insert_sorted_allocList+0x1b3>
  802aee:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802af1:	8b 50 08             	mov    0x8(%eax),%edx
  802af4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802af7:	8b 00                	mov    (%eax),%eax
  802af9:	8b 40 08             	mov    0x8(%eax),%eax
  802afc:	39 c2                	cmp    %eax,%edx
  802afe:	73 70                	jae    802b70 <insert_sorted_allocList+0x1b3>
			{
				LIST_INSERT_AFTER(&AllocMemBlocksList, blk, newblk);
  802b00:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802b04:	74 06                	je     802b0c <insert_sorted_allocList+0x14f>
  802b06:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802b0a:	75 17                	jne    802b23 <insert_sorted_allocList+0x166>
  802b0c:	83 ec 04             	sub    $0x4,%esp
  802b0f:	68 c8 42 80 00       	push   $0x8042c8
  802b14:	68 87 00 00 00       	push   $0x87
  802b19:	68 8b 42 80 00       	push   $0x80428b
  802b1e:	e8 de dd ff ff       	call   800901 <_panic>
  802b23:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b26:	8b 10                	mov    (%eax),%edx
  802b28:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b2b:	89 10                	mov    %edx,(%eax)
  802b2d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b30:	8b 00                	mov    (%eax),%eax
  802b32:	85 c0                	test   %eax,%eax
  802b34:	74 0b                	je     802b41 <insert_sorted_allocList+0x184>
  802b36:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b39:	8b 00                	mov    (%eax),%eax
  802b3b:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802b3e:	89 50 04             	mov    %edx,0x4(%eax)
  802b41:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b44:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802b47:	89 10                	mov    %edx,(%eax)
  802b49:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b4c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802b4f:	89 50 04             	mov    %edx,0x4(%eax)
  802b52:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b55:	8b 00                	mov    (%eax),%eax
  802b57:	85 c0                	test   %eax,%eax
  802b59:	75 08                	jne    802b63 <insert_sorted_allocList+0x1a6>
  802b5b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b5e:	a3 44 50 80 00       	mov    %eax,0x805044
  802b63:	a1 4c 50 80 00       	mov    0x80504c,%eax
  802b68:	40                   	inc    %eax
  802b69:	a3 4c 50 80 00       	mov    %eax,0x80504c
				break;
  802b6e:	eb 38                	jmp    802ba8 <insert_sorted_allocList+0x1eb>
	{
		LIST_INSERT_TAIL(&AllocMemBlocksList, newblk);
	}
	else
	{
		LIST_FOREACH(blk, &AllocMemBlocksList)
  802b70:	a1 48 50 80 00       	mov    0x805048,%eax
  802b75:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802b78:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802b7c:	74 07                	je     802b85 <insert_sorted_allocList+0x1c8>
  802b7e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b81:	8b 00                	mov    (%eax),%eax
  802b83:	eb 05                	jmp    802b8a <insert_sorted_allocList+0x1cd>
  802b85:	b8 00 00 00 00       	mov    $0x0,%eax
  802b8a:	a3 48 50 80 00       	mov    %eax,0x805048
  802b8f:	a1 48 50 80 00       	mov    0x805048,%eax
  802b94:	85 c0                	test   %eax,%eax
  802b96:	0f 85 31 ff ff ff    	jne    802acd <insert_sorted_allocList+0x110>
  802b9c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802ba0:	0f 85 27 ff ff ff    	jne    802acd <insert_sorted_allocList+0x110>
				LIST_INSERT_AFTER(&AllocMemBlocksList, blk, newblk);
				break;
			}
		}
	}
}
  802ba6:	eb 00                	jmp    802ba8 <insert_sorted_allocList+0x1eb>
  802ba8:	90                   	nop
  802ba9:	c9                   	leave  
  802baa:	c3                   	ret    

00802bab <alloc_block_FF>:

//=========================================
// [4] ALLOCATE BLOCK BY FIRST FIT:
//=========================================
struct MemBlock *alloc_block_FF(uint32 size)
{
  802bab:	55                   	push   %ebp
  802bac:	89 e5                	mov    %esp,%ebp
  802bae:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_FF
	// Write your code here, remove the panic and write your code
	//panic("alloc_block_FF() is not implemented yet...!!");
	uint32 versize = size;
  802bb1:	8b 45 08             	mov    0x8(%ebp),%eax
  802bb4:	89 45 f0             	mov    %eax,-0x10(%ebp)
	struct MemBlock* blk;
	struct MemBlock* newblk = LIST_FIRST(&AvailableMemBlocksList);
  802bb7:	a1 48 51 80 00       	mov    0x805148,%eax
  802bbc:	89 45 ec             	mov    %eax,-0x14(%ebp)

	LIST_FOREACH(blk,&FreeMemBlocksList)
  802bbf:	a1 38 51 80 00       	mov    0x805138,%eax
  802bc4:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802bc7:	e9 77 01 00 00       	jmp    802d43 <alloc_block_FF+0x198>
	{
		if(blk->size == versize)
  802bcc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bcf:	8b 40 0c             	mov    0xc(%eax),%eax
  802bd2:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  802bd5:	0f 85 8a 00 00 00    	jne    802c65 <alloc_block_FF+0xba>
		{
			LIST_REMOVE(&FreeMemBlocksList,blk);
  802bdb:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802bdf:	75 17                	jne    802bf8 <alloc_block_FF+0x4d>
  802be1:	83 ec 04             	sub    $0x4,%esp
  802be4:	68 fc 42 80 00       	push   $0x8042fc
  802be9:	68 9e 00 00 00       	push   $0x9e
  802bee:	68 8b 42 80 00       	push   $0x80428b
  802bf3:	e8 09 dd ff ff       	call   800901 <_panic>
  802bf8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bfb:	8b 00                	mov    (%eax),%eax
  802bfd:	85 c0                	test   %eax,%eax
  802bff:	74 10                	je     802c11 <alloc_block_FF+0x66>
  802c01:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c04:	8b 00                	mov    (%eax),%eax
  802c06:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802c09:	8b 52 04             	mov    0x4(%edx),%edx
  802c0c:	89 50 04             	mov    %edx,0x4(%eax)
  802c0f:	eb 0b                	jmp    802c1c <alloc_block_FF+0x71>
  802c11:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c14:	8b 40 04             	mov    0x4(%eax),%eax
  802c17:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802c1c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c1f:	8b 40 04             	mov    0x4(%eax),%eax
  802c22:	85 c0                	test   %eax,%eax
  802c24:	74 0f                	je     802c35 <alloc_block_FF+0x8a>
  802c26:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c29:	8b 40 04             	mov    0x4(%eax),%eax
  802c2c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802c2f:	8b 12                	mov    (%edx),%edx
  802c31:	89 10                	mov    %edx,(%eax)
  802c33:	eb 0a                	jmp    802c3f <alloc_block_FF+0x94>
  802c35:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c38:	8b 00                	mov    (%eax),%eax
  802c3a:	a3 38 51 80 00       	mov    %eax,0x805138
  802c3f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c42:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802c48:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c4b:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802c52:	a1 44 51 80 00       	mov    0x805144,%eax
  802c57:	48                   	dec    %eax
  802c58:	a3 44 51 80 00       	mov    %eax,0x805144
			return blk;
  802c5d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c60:	e9 11 01 00 00       	jmp    802d76 <alloc_block_FF+0x1cb>
		}
		else if(blk->size > versize)
  802c65:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c68:	8b 40 0c             	mov    0xc(%eax),%eax
  802c6b:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  802c6e:	0f 86 c7 00 00 00    	jbe    802d3b <alloc_block_FF+0x190>
		{
			LIST_REMOVE(&AvailableMemBlocksList,newblk);
  802c74:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802c78:	75 17                	jne    802c91 <alloc_block_FF+0xe6>
  802c7a:	83 ec 04             	sub    $0x4,%esp
  802c7d:	68 fc 42 80 00       	push   $0x8042fc
  802c82:	68 a3 00 00 00       	push   $0xa3
  802c87:	68 8b 42 80 00       	push   $0x80428b
  802c8c:	e8 70 dc ff ff       	call   800901 <_panic>
  802c91:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802c94:	8b 00                	mov    (%eax),%eax
  802c96:	85 c0                	test   %eax,%eax
  802c98:	74 10                	je     802caa <alloc_block_FF+0xff>
  802c9a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802c9d:	8b 00                	mov    (%eax),%eax
  802c9f:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802ca2:	8b 52 04             	mov    0x4(%edx),%edx
  802ca5:	89 50 04             	mov    %edx,0x4(%eax)
  802ca8:	eb 0b                	jmp    802cb5 <alloc_block_FF+0x10a>
  802caa:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802cad:	8b 40 04             	mov    0x4(%eax),%eax
  802cb0:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802cb5:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802cb8:	8b 40 04             	mov    0x4(%eax),%eax
  802cbb:	85 c0                	test   %eax,%eax
  802cbd:	74 0f                	je     802cce <alloc_block_FF+0x123>
  802cbf:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802cc2:	8b 40 04             	mov    0x4(%eax),%eax
  802cc5:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802cc8:	8b 12                	mov    (%edx),%edx
  802cca:	89 10                	mov    %edx,(%eax)
  802ccc:	eb 0a                	jmp    802cd8 <alloc_block_FF+0x12d>
  802cce:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802cd1:	8b 00                	mov    (%eax),%eax
  802cd3:	a3 48 51 80 00       	mov    %eax,0x805148
  802cd8:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802cdb:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802ce1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802ce4:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802ceb:	a1 54 51 80 00       	mov    0x805154,%eax
  802cf0:	48                   	dec    %eax
  802cf1:	a3 54 51 80 00       	mov    %eax,0x805154
			newblk->size = versize;
  802cf6:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802cf9:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802cfc:	89 50 0c             	mov    %edx,0xc(%eax)
			blk->size = blk->size-versize;
  802cff:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d02:	8b 40 0c             	mov    0xc(%eax),%eax
  802d05:	2b 45 f0             	sub    -0x10(%ebp),%eax
  802d08:	89 c2                	mov    %eax,%edx
  802d0a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d0d:	89 50 0c             	mov    %edx,0xc(%eax)
			uint32 newveradd = blk->sva;
  802d10:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d13:	8b 40 08             	mov    0x8(%eax),%eax
  802d16:	89 45 e8             	mov    %eax,-0x18(%ebp)
			blk->sva+=newblk->size;
  802d19:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d1c:	8b 50 08             	mov    0x8(%eax),%edx
  802d1f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802d22:	8b 40 0c             	mov    0xc(%eax),%eax
  802d25:	01 c2                	add    %eax,%edx
  802d27:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d2a:	89 50 08             	mov    %edx,0x8(%eax)
			newblk->sva = newveradd;
  802d2d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802d30:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802d33:	89 50 08             	mov    %edx,0x8(%eax)
			return newblk;
  802d36:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802d39:	eb 3b                	jmp    802d76 <alloc_block_FF+0x1cb>
	//panic("alloc_block_FF() is not implemented yet...!!");
	uint32 versize = size;
	struct MemBlock* blk;
	struct MemBlock* newblk = LIST_FIRST(&AvailableMemBlocksList);

	LIST_FOREACH(blk,&FreeMemBlocksList)
  802d3b:	a1 40 51 80 00       	mov    0x805140,%eax
  802d40:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802d43:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802d47:	74 07                	je     802d50 <alloc_block_FF+0x1a5>
  802d49:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d4c:	8b 00                	mov    (%eax),%eax
  802d4e:	eb 05                	jmp    802d55 <alloc_block_FF+0x1aa>
  802d50:	b8 00 00 00 00       	mov    $0x0,%eax
  802d55:	a3 40 51 80 00       	mov    %eax,0x805140
  802d5a:	a1 40 51 80 00       	mov    0x805140,%eax
  802d5f:	85 c0                	test   %eax,%eax
  802d61:	0f 85 65 fe ff ff    	jne    802bcc <alloc_block_FF+0x21>
  802d67:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802d6b:	0f 85 5b fe ff ff    	jne    802bcc <alloc_block_FF+0x21>
			blk->sva+=newblk->size;
			newblk->sva = newveradd;
			return newblk;
		}
	}
	return NULL;
  802d71:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802d76:	c9                   	leave  
  802d77:	c3                   	ret    

00802d78 <alloc_block_BF>:

//=========================================
// [5] ALLOCATE BLOCK BY BEST FIT:
//=========================================
struct MemBlock *alloc_block_BF(uint32 size)
{
  802d78:	55                   	push   %ebp
  802d79:	89 e5                	mov    %esp,%ebp
  802d7b:	83 ec 28             	sub    $0x28,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_BF
	// Write your code here, remove the panic and write your code
	//panic("alloc_block_BF() is not implemented yet...!!");
	uint32 versize=size;
  802d7e:	8b 45 08             	mov    0x8(%ebp),%eax
  802d81:	89 45 e8             	mov    %eax,-0x18(%ebp)
	struct MemBlock* blk;
	struct MemBlock* newblk=LIST_FIRST(&AvailableMemBlocksList);
  802d84:	a1 48 51 80 00       	mov    0x805148,%eax
  802d89:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	uint32 newveradd;
	uint32 newsize;
	int size_free = LIST_SIZE(&FreeMemBlocksList);
  802d8c:	a1 44 51 80 00       	mov    0x805144,%eax
  802d91:	89 45 e0             	mov    %eax,-0x20(%ebp)

	LIST_FOREACH(blk, &FreeMemBlocksList)
  802d94:	a1 38 51 80 00       	mov    0x805138,%eax
  802d99:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802d9c:	e9 a1 00 00 00       	jmp    802e42 <alloc_block_BF+0xca>
	{
		if(blk->size == versize)
  802da1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802da4:	8b 40 0c             	mov    0xc(%eax),%eax
  802da7:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  802daa:	0f 85 8a 00 00 00    	jne    802e3a <alloc_block_BF+0xc2>
		{
			LIST_REMOVE(&FreeMemBlocksList, blk);
  802db0:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802db4:	75 17                	jne    802dcd <alloc_block_BF+0x55>
  802db6:	83 ec 04             	sub    $0x4,%esp
  802db9:	68 fc 42 80 00       	push   $0x8042fc
  802dbe:	68 c2 00 00 00       	push   $0xc2
  802dc3:	68 8b 42 80 00       	push   $0x80428b
  802dc8:	e8 34 db ff ff       	call   800901 <_panic>
  802dcd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802dd0:	8b 00                	mov    (%eax),%eax
  802dd2:	85 c0                	test   %eax,%eax
  802dd4:	74 10                	je     802de6 <alloc_block_BF+0x6e>
  802dd6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802dd9:	8b 00                	mov    (%eax),%eax
  802ddb:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802dde:	8b 52 04             	mov    0x4(%edx),%edx
  802de1:	89 50 04             	mov    %edx,0x4(%eax)
  802de4:	eb 0b                	jmp    802df1 <alloc_block_BF+0x79>
  802de6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802de9:	8b 40 04             	mov    0x4(%eax),%eax
  802dec:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802df1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802df4:	8b 40 04             	mov    0x4(%eax),%eax
  802df7:	85 c0                	test   %eax,%eax
  802df9:	74 0f                	je     802e0a <alloc_block_BF+0x92>
  802dfb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802dfe:	8b 40 04             	mov    0x4(%eax),%eax
  802e01:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802e04:	8b 12                	mov    (%edx),%edx
  802e06:	89 10                	mov    %edx,(%eax)
  802e08:	eb 0a                	jmp    802e14 <alloc_block_BF+0x9c>
  802e0a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e0d:	8b 00                	mov    (%eax),%eax
  802e0f:	a3 38 51 80 00       	mov    %eax,0x805138
  802e14:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e17:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802e1d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e20:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802e27:	a1 44 51 80 00       	mov    0x805144,%eax
  802e2c:	48                   	dec    %eax
  802e2d:	a3 44 51 80 00       	mov    %eax,0x805144
			return blk;
  802e32:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e35:	e9 11 02 00 00       	jmp    80304b <alloc_block_BF+0x2d3>
	struct MemBlock* newblk=LIST_FIRST(&AvailableMemBlocksList);
	uint32 newveradd;
	uint32 newsize;
	int size_free = LIST_SIZE(&FreeMemBlocksList);

	LIST_FOREACH(blk, &FreeMemBlocksList)
  802e3a:	a1 40 51 80 00       	mov    0x805140,%eax
  802e3f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802e42:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802e46:	74 07                	je     802e4f <alloc_block_BF+0xd7>
  802e48:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e4b:	8b 00                	mov    (%eax),%eax
  802e4d:	eb 05                	jmp    802e54 <alloc_block_BF+0xdc>
  802e4f:	b8 00 00 00 00       	mov    $0x0,%eax
  802e54:	a3 40 51 80 00       	mov    %eax,0x805140
  802e59:	a1 40 51 80 00       	mov    0x805140,%eax
  802e5e:	85 c0                	test   %eax,%eax
  802e60:	0f 85 3b ff ff ff    	jne    802da1 <alloc_block_BF+0x29>
  802e66:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802e6a:	0f 85 31 ff ff ff    	jne    802da1 <alloc_block_BF+0x29>
		{
			LIST_REMOVE(&FreeMemBlocksList, blk);
			return blk;
		}
	}
	LIST_FOREACH(blk, &FreeMemBlocksList)
  802e70:	a1 38 51 80 00       	mov    0x805138,%eax
  802e75:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802e78:	eb 27                	jmp    802ea1 <alloc_block_BF+0x129>
	{
		if(blk->size > versize)
  802e7a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e7d:	8b 40 0c             	mov    0xc(%eax),%eax
  802e80:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  802e83:	76 14                	jbe    802e99 <alloc_block_BF+0x121>
		{
			newsize = blk->size;
  802e85:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e88:	8b 40 0c             	mov    0xc(%eax),%eax
  802e8b:	89 45 ec             	mov    %eax,-0x14(%ebp)
			newveradd = blk->sva;
  802e8e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e91:	8b 40 08             	mov    0x8(%eax),%eax
  802e94:	89 45 f0             	mov    %eax,-0x10(%ebp)
			break;
  802e97:	eb 2e                	jmp    802ec7 <alloc_block_BF+0x14f>
		{
			LIST_REMOVE(&FreeMemBlocksList, blk);
			return blk;
		}
	}
	LIST_FOREACH(blk, &FreeMemBlocksList)
  802e99:	a1 40 51 80 00       	mov    0x805140,%eax
  802e9e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802ea1:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802ea5:	74 07                	je     802eae <alloc_block_BF+0x136>
  802ea7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802eaa:	8b 00                	mov    (%eax),%eax
  802eac:	eb 05                	jmp    802eb3 <alloc_block_BF+0x13b>
  802eae:	b8 00 00 00 00       	mov    $0x0,%eax
  802eb3:	a3 40 51 80 00       	mov    %eax,0x805140
  802eb8:	a1 40 51 80 00       	mov    0x805140,%eax
  802ebd:	85 c0                	test   %eax,%eax
  802ebf:	75 b9                	jne    802e7a <alloc_block_BF+0x102>
  802ec1:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802ec5:	75 b3                	jne    802e7a <alloc_block_BF+0x102>
			newsize = blk->size;
			newveradd = blk->sva;
			break;
		}
	}
	LIST_FOREACH(blk, &FreeMemBlocksList)
  802ec7:	a1 38 51 80 00       	mov    0x805138,%eax
  802ecc:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802ecf:	eb 30                	jmp    802f01 <alloc_block_BF+0x189>
	{
		if(newsize > blk->size && blk->size > versize)
  802ed1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ed4:	8b 40 0c             	mov    0xc(%eax),%eax
  802ed7:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  802eda:	73 1d                	jae    802ef9 <alloc_block_BF+0x181>
  802edc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802edf:	8b 40 0c             	mov    0xc(%eax),%eax
  802ee2:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  802ee5:	76 12                	jbe    802ef9 <alloc_block_BF+0x181>
		{
	       newsize = blk->size;
  802ee7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802eea:	8b 40 0c             	mov    0xc(%eax),%eax
  802eed:	89 45 ec             	mov    %eax,-0x14(%ebp)
		   newveradd = blk->sva;
  802ef0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ef3:	8b 40 08             	mov    0x8(%eax),%eax
  802ef6:	89 45 f0             	mov    %eax,-0x10(%ebp)
			newsize = blk->size;
			newveradd = blk->sva;
			break;
		}
	}
	LIST_FOREACH(blk, &FreeMemBlocksList)
  802ef9:	a1 40 51 80 00       	mov    0x805140,%eax
  802efe:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802f01:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802f05:	74 07                	je     802f0e <alloc_block_BF+0x196>
  802f07:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f0a:	8b 00                	mov    (%eax),%eax
  802f0c:	eb 05                	jmp    802f13 <alloc_block_BF+0x19b>
  802f0e:	b8 00 00 00 00       	mov    $0x0,%eax
  802f13:	a3 40 51 80 00       	mov    %eax,0x805140
  802f18:	a1 40 51 80 00       	mov    0x805140,%eax
  802f1d:	85 c0                	test   %eax,%eax
  802f1f:	75 b0                	jne    802ed1 <alloc_block_BF+0x159>
  802f21:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802f25:	75 aa                	jne    802ed1 <alloc_block_BF+0x159>
		{
	       newsize = blk->size;
		   newveradd = blk->sva;
		}
	}
	LIST_FOREACH(blk, &FreeMemBlocksList)
  802f27:	a1 38 51 80 00       	mov    0x805138,%eax
  802f2c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802f2f:	e9 e4 00 00 00       	jmp    803018 <alloc_block_BF+0x2a0>
	{
		if(blk->size == newsize && blk->sva == newveradd)
  802f34:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f37:	8b 40 0c             	mov    0xc(%eax),%eax
  802f3a:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  802f3d:	0f 85 cd 00 00 00    	jne    803010 <alloc_block_BF+0x298>
  802f43:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f46:	8b 40 08             	mov    0x8(%eax),%eax
  802f49:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  802f4c:	0f 85 be 00 00 00    	jne    803010 <alloc_block_BF+0x298>
		{
			LIST_REMOVE(&AvailableMemBlocksList, newblk);
  802f52:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  802f56:	75 17                	jne    802f6f <alloc_block_BF+0x1f7>
  802f58:	83 ec 04             	sub    $0x4,%esp
  802f5b:	68 fc 42 80 00       	push   $0x8042fc
  802f60:	68 db 00 00 00       	push   $0xdb
  802f65:	68 8b 42 80 00       	push   $0x80428b
  802f6a:	e8 92 d9 ff ff       	call   800901 <_panic>
  802f6f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802f72:	8b 00                	mov    (%eax),%eax
  802f74:	85 c0                	test   %eax,%eax
  802f76:	74 10                	je     802f88 <alloc_block_BF+0x210>
  802f78:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802f7b:	8b 00                	mov    (%eax),%eax
  802f7d:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802f80:	8b 52 04             	mov    0x4(%edx),%edx
  802f83:	89 50 04             	mov    %edx,0x4(%eax)
  802f86:	eb 0b                	jmp    802f93 <alloc_block_BF+0x21b>
  802f88:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802f8b:	8b 40 04             	mov    0x4(%eax),%eax
  802f8e:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802f93:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802f96:	8b 40 04             	mov    0x4(%eax),%eax
  802f99:	85 c0                	test   %eax,%eax
  802f9b:	74 0f                	je     802fac <alloc_block_BF+0x234>
  802f9d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802fa0:	8b 40 04             	mov    0x4(%eax),%eax
  802fa3:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802fa6:	8b 12                	mov    (%edx),%edx
  802fa8:	89 10                	mov    %edx,(%eax)
  802faa:	eb 0a                	jmp    802fb6 <alloc_block_BF+0x23e>
  802fac:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802faf:	8b 00                	mov    (%eax),%eax
  802fb1:	a3 48 51 80 00       	mov    %eax,0x805148
  802fb6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802fb9:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802fbf:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802fc2:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802fc9:	a1 54 51 80 00       	mov    0x805154,%eax
  802fce:	48                   	dec    %eax
  802fcf:	a3 54 51 80 00       	mov    %eax,0x805154
			newblk->size = versize;
  802fd4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802fd7:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802fda:	89 50 0c             	mov    %edx,0xc(%eax)
			newblk->sva = newveradd;
  802fdd:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802fe0:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802fe3:	89 50 08             	mov    %edx,0x8(%eax)
			blk->size = blk->size - versize;
  802fe6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802fe9:	8b 40 0c             	mov    0xc(%eax),%eax
  802fec:	2b 45 e8             	sub    -0x18(%ebp),%eax
  802fef:	89 c2                	mov    %eax,%edx
  802ff1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ff4:	89 50 0c             	mov    %edx,0xc(%eax)
			blk->sva+= newblk->size;
  802ff7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ffa:	8b 50 08             	mov    0x8(%eax),%edx
  802ffd:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803000:	8b 40 0c             	mov    0xc(%eax),%eax
  803003:	01 c2                	add    %eax,%edx
  803005:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803008:	89 50 08             	mov    %edx,0x8(%eax)
			return newblk;
  80300b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80300e:	eb 3b                	jmp    80304b <alloc_block_BF+0x2d3>
		{
	       newsize = blk->size;
		   newveradd = blk->sva;
		}
	}
	LIST_FOREACH(blk, &FreeMemBlocksList)
  803010:	a1 40 51 80 00       	mov    0x805140,%eax
  803015:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803018:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80301c:	74 07                	je     803025 <alloc_block_BF+0x2ad>
  80301e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803021:	8b 00                	mov    (%eax),%eax
  803023:	eb 05                	jmp    80302a <alloc_block_BF+0x2b2>
  803025:	b8 00 00 00 00       	mov    $0x0,%eax
  80302a:	a3 40 51 80 00       	mov    %eax,0x805140
  80302f:	a1 40 51 80 00       	mov    0x805140,%eax
  803034:	85 c0                	test   %eax,%eax
  803036:	0f 85 f8 fe ff ff    	jne    802f34 <alloc_block_BF+0x1bc>
  80303c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803040:	0f 85 ee fe ff ff    	jne    802f34 <alloc_block_BF+0x1bc>
			blk->size = blk->size - versize;
			blk->sva+= newblk->size;
			return newblk;
		}
	}
	return NULL;
  803046:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80304b:	c9                   	leave  
  80304c:	c3                   	ret    

0080304d <alloc_block_NF>:
//=========================================
// [7] ALLOCATE BLOCK BY NEXT FIT:
//=========================================
struct MemBlock *last_allocate;
struct MemBlock *alloc_block_NF(uint32 size)
{
  80304d:	55                   	push   %ebp
  80304e:	89 e5                	mov    %esp,%ebp
  803050:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1 - BONUS] [DYNAMIC ALLOCATOR] alloc_block_NF
	// Write your code here, remove the panic and write your code
	//panic("alloc_block_NF() is not implemented yet...!!");
	uint32 versize = size;
  803053:	8b 45 08             	mov    0x8(%ebp),%eax
  803056:	89 45 f0             	mov    %eax,-0x10(%ebp)
	struct MemBlock* blk;
	struct MemBlock* newblk = LIST_FIRST(&AvailableMemBlocksList);
  803059:	a1 48 51 80 00       	mov    0x805148,%eax
  80305e:	89 45 ec             	mov    %eax,-0x14(%ebp)

	LIST_FOREACH(blk,&FreeMemBlocksList)
  803061:	a1 38 51 80 00       	mov    0x805138,%eax
  803066:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803069:	e9 77 01 00 00       	jmp    8031e5 <alloc_block_NF+0x198>
	{
		if(blk->size == versize)
  80306e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803071:	8b 40 0c             	mov    0xc(%eax),%eax
  803074:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  803077:	0f 85 8a 00 00 00    	jne    803107 <alloc_block_NF+0xba>
		{
			LIST_REMOVE(&FreeMemBlocksList,blk);
  80307d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803081:	75 17                	jne    80309a <alloc_block_NF+0x4d>
  803083:	83 ec 04             	sub    $0x4,%esp
  803086:	68 fc 42 80 00       	push   $0x8042fc
  80308b:	68 f7 00 00 00       	push   $0xf7
  803090:	68 8b 42 80 00       	push   $0x80428b
  803095:	e8 67 d8 ff ff       	call   800901 <_panic>
  80309a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80309d:	8b 00                	mov    (%eax),%eax
  80309f:	85 c0                	test   %eax,%eax
  8030a1:	74 10                	je     8030b3 <alloc_block_NF+0x66>
  8030a3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030a6:	8b 00                	mov    (%eax),%eax
  8030a8:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8030ab:	8b 52 04             	mov    0x4(%edx),%edx
  8030ae:	89 50 04             	mov    %edx,0x4(%eax)
  8030b1:	eb 0b                	jmp    8030be <alloc_block_NF+0x71>
  8030b3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030b6:	8b 40 04             	mov    0x4(%eax),%eax
  8030b9:	a3 3c 51 80 00       	mov    %eax,0x80513c
  8030be:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030c1:	8b 40 04             	mov    0x4(%eax),%eax
  8030c4:	85 c0                	test   %eax,%eax
  8030c6:	74 0f                	je     8030d7 <alloc_block_NF+0x8a>
  8030c8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030cb:	8b 40 04             	mov    0x4(%eax),%eax
  8030ce:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8030d1:	8b 12                	mov    (%edx),%edx
  8030d3:	89 10                	mov    %edx,(%eax)
  8030d5:	eb 0a                	jmp    8030e1 <alloc_block_NF+0x94>
  8030d7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030da:	8b 00                	mov    (%eax),%eax
  8030dc:	a3 38 51 80 00       	mov    %eax,0x805138
  8030e1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030e4:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8030ea:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030ed:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8030f4:	a1 44 51 80 00       	mov    0x805144,%eax
  8030f9:	48                   	dec    %eax
  8030fa:	a3 44 51 80 00       	mov    %eax,0x805144
			return blk;
  8030ff:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803102:	e9 11 01 00 00       	jmp    803218 <alloc_block_NF+0x1cb>
		}
		else if(blk->size > versize)
  803107:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80310a:	8b 40 0c             	mov    0xc(%eax),%eax
  80310d:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  803110:	0f 86 c7 00 00 00    	jbe    8031dd <alloc_block_NF+0x190>
		{
			LIST_REMOVE(&AvailableMemBlocksList,newblk);
  803116:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  80311a:	75 17                	jne    803133 <alloc_block_NF+0xe6>
  80311c:	83 ec 04             	sub    $0x4,%esp
  80311f:	68 fc 42 80 00       	push   $0x8042fc
  803124:	68 fc 00 00 00       	push   $0xfc
  803129:	68 8b 42 80 00       	push   $0x80428b
  80312e:	e8 ce d7 ff ff       	call   800901 <_panic>
  803133:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803136:	8b 00                	mov    (%eax),%eax
  803138:	85 c0                	test   %eax,%eax
  80313a:	74 10                	je     80314c <alloc_block_NF+0xff>
  80313c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80313f:	8b 00                	mov    (%eax),%eax
  803141:	8b 55 ec             	mov    -0x14(%ebp),%edx
  803144:	8b 52 04             	mov    0x4(%edx),%edx
  803147:	89 50 04             	mov    %edx,0x4(%eax)
  80314a:	eb 0b                	jmp    803157 <alloc_block_NF+0x10a>
  80314c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80314f:	8b 40 04             	mov    0x4(%eax),%eax
  803152:	a3 4c 51 80 00       	mov    %eax,0x80514c
  803157:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80315a:	8b 40 04             	mov    0x4(%eax),%eax
  80315d:	85 c0                	test   %eax,%eax
  80315f:	74 0f                	je     803170 <alloc_block_NF+0x123>
  803161:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803164:	8b 40 04             	mov    0x4(%eax),%eax
  803167:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80316a:	8b 12                	mov    (%edx),%edx
  80316c:	89 10                	mov    %edx,(%eax)
  80316e:	eb 0a                	jmp    80317a <alloc_block_NF+0x12d>
  803170:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803173:	8b 00                	mov    (%eax),%eax
  803175:	a3 48 51 80 00       	mov    %eax,0x805148
  80317a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80317d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803183:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803186:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80318d:	a1 54 51 80 00       	mov    0x805154,%eax
  803192:	48                   	dec    %eax
  803193:	a3 54 51 80 00       	mov    %eax,0x805154
			newblk->size = versize;
  803198:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80319b:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80319e:	89 50 0c             	mov    %edx,0xc(%eax)
			blk->size = blk->size-versize;
  8031a1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8031a4:	8b 40 0c             	mov    0xc(%eax),%eax
  8031a7:	2b 45 f0             	sub    -0x10(%ebp),%eax
  8031aa:	89 c2                	mov    %eax,%edx
  8031ac:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8031af:	89 50 0c             	mov    %edx,0xc(%eax)
			uint32 newveradd = blk->sva;
  8031b2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8031b5:	8b 40 08             	mov    0x8(%eax),%eax
  8031b8:	89 45 e8             	mov    %eax,-0x18(%ebp)
			blk->sva+=newblk->size;
  8031bb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8031be:	8b 50 08             	mov    0x8(%eax),%edx
  8031c1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8031c4:	8b 40 0c             	mov    0xc(%eax),%eax
  8031c7:	01 c2                	add    %eax,%edx
  8031c9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8031cc:	89 50 08             	mov    %edx,0x8(%eax)
			newblk->sva = newveradd;
  8031cf:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8031d2:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8031d5:	89 50 08             	mov    %edx,0x8(%eax)
			return newblk;
  8031d8:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8031db:	eb 3b                	jmp    803218 <alloc_block_NF+0x1cb>
	//panic("alloc_block_NF() is not implemented yet...!!");
	uint32 versize = size;
	struct MemBlock* blk;
	struct MemBlock* newblk = LIST_FIRST(&AvailableMemBlocksList);

	LIST_FOREACH(blk,&FreeMemBlocksList)
  8031dd:	a1 40 51 80 00       	mov    0x805140,%eax
  8031e2:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8031e5:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8031e9:	74 07                	je     8031f2 <alloc_block_NF+0x1a5>
  8031eb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8031ee:	8b 00                	mov    (%eax),%eax
  8031f0:	eb 05                	jmp    8031f7 <alloc_block_NF+0x1aa>
  8031f2:	b8 00 00 00 00       	mov    $0x0,%eax
  8031f7:	a3 40 51 80 00       	mov    %eax,0x805140
  8031fc:	a1 40 51 80 00       	mov    0x805140,%eax
  803201:	85 c0                	test   %eax,%eax
  803203:	0f 85 65 fe ff ff    	jne    80306e <alloc_block_NF+0x21>
  803209:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80320d:	0f 85 5b fe ff ff    	jne    80306e <alloc_block_NF+0x21>
			blk->sva+=newblk->size;
			newblk->sva = newveradd;
			return newblk;
		}
	}
	return NULL;
  803213:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803218:	c9                   	leave  
  803219:	c3                   	ret    

0080321a <addToAvailMemBlocksList>:

//===================================================
// [8] INSERT BLOCK (SORTED WITH MERGE) IN FREE LIST:
//===================================================
void addToAvailMemBlocksList(struct MemBlock *blockToInsert)
{
  80321a:	55                   	push   %ebp
  80321b:	89 e5                	mov    %esp,%ebp
  80321d:	83 ec 08             	sub    $0x8,%esp
	blockToInsert->sva = 0;
  803220:	8b 45 08             	mov    0x8(%ebp),%eax
  803223:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
	blockToInsert->size = 0;
  80322a:	8b 45 08             	mov    0x8(%ebp),%eax
  80322d:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
	//add to avail
	LIST_INSERT_TAIL(&AvailableMemBlocksList, blockToInsert);
  803234:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803238:	75 17                	jne    803251 <addToAvailMemBlocksList+0x37>
  80323a:	83 ec 04             	sub    $0x4,%esp
  80323d:	68 a4 42 80 00       	push   $0x8042a4
  803242:	68 10 01 00 00       	push   $0x110
  803247:	68 8b 42 80 00       	push   $0x80428b
  80324c:	e8 b0 d6 ff ff       	call   800901 <_panic>
  803251:	8b 15 4c 51 80 00    	mov    0x80514c,%edx
  803257:	8b 45 08             	mov    0x8(%ebp),%eax
  80325a:	89 50 04             	mov    %edx,0x4(%eax)
  80325d:	8b 45 08             	mov    0x8(%ebp),%eax
  803260:	8b 40 04             	mov    0x4(%eax),%eax
  803263:	85 c0                	test   %eax,%eax
  803265:	74 0c                	je     803273 <addToAvailMemBlocksList+0x59>
  803267:	a1 4c 51 80 00       	mov    0x80514c,%eax
  80326c:	8b 55 08             	mov    0x8(%ebp),%edx
  80326f:	89 10                	mov    %edx,(%eax)
  803271:	eb 08                	jmp    80327b <addToAvailMemBlocksList+0x61>
  803273:	8b 45 08             	mov    0x8(%ebp),%eax
  803276:	a3 48 51 80 00       	mov    %eax,0x805148
  80327b:	8b 45 08             	mov    0x8(%ebp),%eax
  80327e:	a3 4c 51 80 00       	mov    %eax,0x80514c
  803283:	8b 45 08             	mov    0x8(%ebp),%eax
  803286:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80328c:	a1 54 51 80 00       	mov    0x805154,%eax
  803291:	40                   	inc    %eax
  803292:	a3 54 51 80 00       	mov    %eax,0x805154
}
  803297:	90                   	nop
  803298:	c9                   	leave  
  803299:	c3                   	ret    

0080329a <insert_sorted_with_merge_freeList>:
void insert_sorted_with_merge_freeList(struct MemBlock *blockToInsert)
{
  80329a:	55                   	push   %ebp
  80329b:	89 e5                	mov    %esp,%ebp
  80329d:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] insert_sorted_with_merge_freeList
	// Write your code here, remove the panic and write your code

	struct MemBlock* last = LIST_LAST(&FreeMemBlocksList);
  8032a0:	a1 3c 51 80 00       	mov    0x80513c,%eax
  8032a5:	89 45 f0             	mov    %eax,-0x10(%ebp)
	//check if list empty
	if (LIST_SIZE(&(FreeMemBlocksList)) == 0)
  8032a8:	a1 44 51 80 00       	mov    0x805144,%eax
  8032ad:	85 c0                	test   %eax,%eax
  8032af:	75 68                	jne    803319 <insert_sorted_with_merge_freeList+0x7f>
		LIST_INSERT_HEAD(&FreeMemBlocksList, blockToInsert);
  8032b1:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8032b5:	75 17                	jne    8032ce <insert_sorted_with_merge_freeList+0x34>
  8032b7:	83 ec 04             	sub    $0x4,%esp
  8032ba:	68 68 42 80 00       	push   $0x804268
  8032bf:	68 1a 01 00 00       	push   $0x11a
  8032c4:	68 8b 42 80 00       	push   $0x80428b
  8032c9:	e8 33 d6 ff ff       	call   800901 <_panic>
  8032ce:	8b 15 38 51 80 00    	mov    0x805138,%edx
  8032d4:	8b 45 08             	mov    0x8(%ebp),%eax
  8032d7:	89 10                	mov    %edx,(%eax)
  8032d9:	8b 45 08             	mov    0x8(%ebp),%eax
  8032dc:	8b 00                	mov    (%eax),%eax
  8032de:	85 c0                	test   %eax,%eax
  8032e0:	74 0d                	je     8032ef <insert_sorted_with_merge_freeList+0x55>
  8032e2:	a1 38 51 80 00       	mov    0x805138,%eax
  8032e7:	8b 55 08             	mov    0x8(%ebp),%edx
  8032ea:	89 50 04             	mov    %edx,0x4(%eax)
  8032ed:	eb 08                	jmp    8032f7 <insert_sorted_with_merge_freeList+0x5d>
  8032ef:	8b 45 08             	mov    0x8(%ebp),%eax
  8032f2:	a3 3c 51 80 00       	mov    %eax,0x80513c
  8032f7:	8b 45 08             	mov    0x8(%ebp),%eax
  8032fa:	a3 38 51 80 00       	mov    %eax,0x805138
  8032ff:	8b 45 08             	mov    0x8(%ebp),%eax
  803302:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803309:	a1 44 51 80 00       	mov    0x805144,%eax
  80330e:	40                   	inc    %eax
  80330f:	a3 44 51 80 00       	mov    %eax,0x805144
		}
	}

	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  803314:	e9 c5 03 00 00       	jmp    8036de <insert_sorted_with_merge_freeList+0x444>
	struct MemBlock* last = LIST_LAST(&FreeMemBlocksList);
	//check if list empty
	if (LIST_SIZE(&(FreeMemBlocksList)) == 0)
		LIST_INSERT_HEAD(&FreeMemBlocksList, blockToInsert);
	//check if it's position is at last
	else if (last->sva < blockToInsert->sva) {
  803319:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80331c:	8b 50 08             	mov    0x8(%eax),%edx
  80331f:	8b 45 08             	mov    0x8(%ebp),%eax
  803322:	8b 40 08             	mov    0x8(%eax),%eax
  803325:	39 c2                	cmp    %eax,%edx
  803327:	0f 83 b2 00 00 00    	jae    8033df <insert_sorted_with_merge_freeList+0x145>

		//if i have to merge
		if (last->sva + last->size == blockToInsert->sva) {
  80332d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803330:	8b 50 08             	mov    0x8(%eax),%edx
  803333:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803336:	8b 40 0c             	mov    0xc(%eax),%eax
  803339:	01 c2                	add    %eax,%edx
  80333b:	8b 45 08             	mov    0x8(%ebp),%eax
  80333e:	8b 40 08             	mov    0x8(%eax),%eax
  803341:	39 c2                	cmp    %eax,%edx
  803343:	75 27                	jne    80336c <insert_sorted_with_merge_freeList+0xd2>
			last->size = last->size + blockToInsert->size;
  803345:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803348:	8b 50 0c             	mov    0xc(%eax),%edx
  80334b:	8b 45 08             	mov    0x8(%ebp),%eax
  80334e:	8b 40 0c             	mov    0xc(%eax),%eax
  803351:	01 c2                	add    %eax,%edx
  803353:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803356:	89 50 0c             	mov    %edx,0xc(%eax)
			addToAvailMemBlocksList(blockToInsert);
  803359:	83 ec 0c             	sub    $0xc,%esp
  80335c:	ff 75 08             	pushl  0x8(%ebp)
  80335f:	e8 b6 fe ff ff       	call   80321a <addToAvailMemBlocksList>
  803364:	83 c4 10             	add    $0x10,%esp
		}
	}

	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  803367:	e9 72 03 00 00       	jmp    8036de <insert_sorted_with_merge_freeList+0x444>
		if (last->sva + last->size == blockToInsert->sva) {
			last->size = last->size + blockToInsert->size;
			addToAvailMemBlocksList(blockToInsert);

		} else {
			LIST_INSERT_AFTER(&FreeMemBlocksList, last, blockToInsert);
  80336c:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  803370:	74 06                	je     803378 <insert_sorted_with_merge_freeList+0xde>
  803372:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803376:	75 17                	jne    80338f <insert_sorted_with_merge_freeList+0xf5>
  803378:	83 ec 04             	sub    $0x4,%esp
  80337b:	68 c8 42 80 00       	push   $0x8042c8
  803380:	68 24 01 00 00       	push   $0x124
  803385:	68 8b 42 80 00       	push   $0x80428b
  80338a:	e8 72 d5 ff ff       	call   800901 <_panic>
  80338f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803392:	8b 10                	mov    (%eax),%edx
  803394:	8b 45 08             	mov    0x8(%ebp),%eax
  803397:	89 10                	mov    %edx,(%eax)
  803399:	8b 45 08             	mov    0x8(%ebp),%eax
  80339c:	8b 00                	mov    (%eax),%eax
  80339e:	85 c0                	test   %eax,%eax
  8033a0:	74 0b                	je     8033ad <insert_sorted_with_merge_freeList+0x113>
  8033a2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8033a5:	8b 00                	mov    (%eax),%eax
  8033a7:	8b 55 08             	mov    0x8(%ebp),%edx
  8033aa:	89 50 04             	mov    %edx,0x4(%eax)
  8033ad:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8033b0:	8b 55 08             	mov    0x8(%ebp),%edx
  8033b3:	89 10                	mov    %edx,(%eax)
  8033b5:	8b 45 08             	mov    0x8(%ebp),%eax
  8033b8:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8033bb:	89 50 04             	mov    %edx,0x4(%eax)
  8033be:	8b 45 08             	mov    0x8(%ebp),%eax
  8033c1:	8b 00                	mov    (%eax),%eax
  8033c3:	85 c0                	test   %eax,%eax
  8033c5:	75 08                	jne    8033cf <insert_sorted_with_merge_freeList+0x135>
  8033c7:	8b 45 08             	mov    0x8(%ebp),%eax
  8033ca:	a3 3c 51 80 00       	mov    %eax,0x80513c
  8033cf:	a1 44 51 80 00       	mov    0x805144,%eax
  8033d4:	40                   	inc    %eax
  8033d5:	a3 44 51 80 00       	mov    %eax,0x805144
		}
	}

	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  8033da:	e9 ff 02 00 00       	jmp    8036de <insert_sorted_with_merge_freeList+0x444>
		} else {
			LIST_INSERT_AFTER(&FreeMemBlocksList, last, blockToInsert);
		}
	} else {
		struct MemBlock *iterator;
		LIST_FOREACH(iterator, &(FreeMemBlocksList))
  8033df:	a1 38 51 80 00       	mov    0x805138,%eax
  8033e4:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8033e7:	e9 c2 02 00 00       	jmp    8036ae <insert_sorted_with_merge_freeList+0x414>
		{

			if (iterator->sva > blockToInsert->sva) {
  8033ec:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8033ef:	8b 50 08             	mov    0x8(%eax),%edx
  8033f2:	8b 45 08             	mov    0x8(%ebp),%eax
  8033f5:	8b 40 08             	mov    0x8(%eax),%eax
  8033f8:	39 c2                	cmp    %eax,%edx
  8033fa:	0f 86 a6 02 00 00    	jbe    8036a6 <insert_sorted_with_merge_freeList+0x40c>

				struct MemBlock* prev = LIST_PREV(iterator);
  803400:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803403:	8b 40 04             	mov    0x4(%eax),%eax
  803406:	89 45 ec             	mov    %eax,-0x14(%ebp)
				if (prev == NULL) {
  803409:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  80340d:	0f 85 ba 00 00 00    	jne    8034cd <insert_sorted_with_merge_freeList+0x233>
					//check merge
					if (blockToInsert->size + blockToInsert->sva
  803413:	8b 45 08             	mov    0x8(%ebp),%eax
  803416:	8b 50 0c             	mov    0xc(%eax),%edx
  803419:	8b 45 08             	mov    0x8(%ebp),%eax
  80341c:	8b 40 08             	mov    0x8(%eax),%eax
  80341f:	01 c2                	add    %eax,%edx
							== iterator->sva) {
  803421:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803424:	8b 40 08             	mov    0x8(%eax),%eax
			if (iterator->sva > blockToInsert->sva) {

				struct MemBlock* prev = LIST_PREV(iterator);
				if (prev == NULL) {
					//check merge
					if (blockToInsert->size + blockToInsert->sva
  803427:	39 c2                	cmp    %eax,%edx
  803429:	75 33                	jne    80345e <insert_sorted_with_merge_freeList+0x1c4>
							== iterator->sva) {
						iterator->sva = blockToInsert->sva;
  80342b:	8b 45 08             	mov    0x8(%ebp),%eax
  80342e:	8b 50 08             	mov    0x8(%eax),%edx
  803431:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803434:	89 50 08             	mov    %edx,0x8(%eax)
						iterator->size = iterator->size + blockToInsert->size;
  803437:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80343a:	8b 50 0c             	mov    0xc(%eax),%edx
  80343d:	8b 45 08             	mov    0x8(%ebp),%eax
  803440:	8b 40 0c             	mov    0xc(%eax),%eax
  803443:	01 c2                	add    %eax,%edx
  803445:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803448:	89 50 0c             	mov    %edx,0xc(%eax)
						addToAvailMemBlocksList(blockToInsert);
  80344b:	83 ec 0c             	sub    $0xc,%esp
  80344e:	ff 75 08             	pushl  0x8(%ebp)
  803451:	e8 c4 fd ff ff       	call   80321a <addToAvailMemBlocksList>
  803456:	83 c4 10             	add    $0x10,%esp

					else {
						LIST_INSERT_BEFORE(&FreeMemBlocksList, iterator,
								blockToInsert);
					}
					break;
  803459:	e9 80 02 00 00       	jmp    8036de <insert_sorted_with_merge_freeList+0x444>
						addToAvailMemBlocksList(blockToInsert);

					}

					else {
						LIST_INSERT_BEFORE(&FreeMemBlocksList, iterator,
  80345e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803462:	74 06                	je     80346a <insert_sorted_with_merge_freeList+0x1d0>
  803464:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803468:	75 17                	jne    803481 <insert_sorted_with_merge_freeList+0x1e7>
  80346a:	83 ec 04             	sub    $0x4,%esp
  80346d:	68 1c 43 80 00       	push   $0x80431c
  803472:	68 3a 01 00 00       	push   $0x13a
  803477:	68 8b 42 80 00       	push   $0x80428b
  80347c:	e8 80 d4 ff ff       	call   800901 <_panic>
  803481:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803484:	8b 50 04             	mov    0x4(%eax),%edx
  803487:	8b 45 08             	mov    0x8(%ebp),%eax
  80348a:	89 50 04             	mov    %edx,0x4(%eax)
  80348d:	8b 45 08             	mov    0x8(%ebp),%eax
  803490:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803493:	89 10                	mov    %edx,(%eax)
  803495:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803498:	8b 40 04             	mov    0x4(%eax),%eax
  80349b:	85 c0                	test   %eax,%eax
  80349d:	74 0d                	je     8034ac <insert_sorted_with_merge_freeList+0x212>
  80349f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8034a2:	8b 40 04             	mov    0x4(%eax),%eax
  8034a5:	8b 55 08             	mov    0x8(%ebp),%edx
  8034a8:	89 10                	mov    %edx,(%eax)
  8034aa:	eb 08                	jmp    8034b4 <insert_sorted_with_merge_freeList+0x21a>
  8034ac:	8b 45 08             	mov    0x8(%ebp),%eax
  8034af:	a3 38 51 80 00       	mov    %eax,0x805138
  8034b4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8034b7:	8b 55 08             	mov    0x8(%ebp),%edx
  8034ba:	89 50 04             	mov    %edx,0x4(%eax)
  8034bd:	a1 44 51 80 00       	mov    0x805144,%eax
  8034c2:	40                   	inc    %eax
  8034c3:	a3 44 51 80 00       	mov    %eax,0x805144
								blockToInsert);
					}
					break;
  8034c8:	e9 11 02 00 00       	jmp    8036de <insert_sorted_with_merge_freeList+0x444>
				} else {
					//prev and next merge
					if (prev->sva + prev->size + blockToInsert->size
  8034cd:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8034d0:	8b 50 08             	mov    0x8(%eax),%edx
  8034d3:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8034d6:	8b 40 0c             	mov    0xc(%eax),%eax
  8034d9:	01 c2                	add    %eax,%edx
  8034db:	8b 45 08             	mov    0x8(%ebp),%eax
  8034de:	8b 40 0c             	mov    0xc(%eax),%eax
  8034e1:	01 c2                	add    %eax,%edx
							== iterator->sva) {
  8034e3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8034e6:	8b 40 08             	mov    0x8(%eax),%eax
								blockToInsert);
					}
					break;
				} else {
					//prev and next merge
					if (prev->sva + prev->size + blockToInsert->size
  8034e9:	39 c2                	cmp    %eax,%edx
  8034eb:	0f 85 bf 00 00 00    	jne    8035b0 <insert_sorted_with_merge_freeList+0x316>
							== iterator->sva) {
						prev->size = prev->size + blockToInsert->size
  8034f1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8034f4:	8b 50 0c             	mov    0xc(%eax),%edx
  8034f7:	8b 45 08             	mov    0x8(%ebp),%eax
  8034fa:	8b 40 0c             	mov    0xc(%eax),%eax
  8034fd:	01 c2                	add    %eax,%edx
								+ iterator->size;
  8034ff:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803502:	8b 40 0c             	mov    0xc(%eax),%eax
  803505:	01 c2                	add    %eax,%edx
					break;
				} else {
					//prev and next merge
					if (prev->sva + prev->size + blockToInsert->size
							== iterator->sva) {
						prev->size = prev->size + blockToInsert->size
  803507:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80350a:	89 50 0c             	mov    %edx,0xc(%eax)
								+ iterator->size;
						LIST_REMOVE(&FreeMemBlocksList, iterator);
  80350d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803511:	75 17                	jne    80352a <insert_sorted_with_merge_freeList+0x290>
  803513:	83 ec 04             	sub    $0x4,%esp
  803516:	68 fc 42 80 00       	push   $0x8042fc
  80351b:	68 43 01 00 00       	push   $0x143
  803520:	68 8b 42 80 00       	push   $0x80428b
  803525:	e8 d7 d3 ff ff       	call   800901 <_panic>
  80352a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80352d:	8b 00                	mov    (%eax),%eax
  80352f:	85 c0                	test   %eax,%eax
  803531:	74 10                	je     803543 <insert_sorted_with_merge_freeList+0x2a9>
  803533:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803536:	8b 00                	mov    (%eax),%eax
  803538:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80353b:	8b 52 04             	mov    0x4(%edx),%edx
  80353e:	89 50 04             	mov    %edx,0x4(%eax)
  803541:	eb 0b                	jmp    80354e <insert_sorted_with_merge_freeList+0x2b4>
  803543:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803546:	8b 40 04             	mov    0x4(%eax),%eax
  803549:	a3 3c 51 80 00       	mov    %eax,0x80513c
  80354e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803551:	8b 40 04             	mov    0x4(%eax),%eax
  803554:	85 c0                	test   %eax,%eax
  803556:	74 0f                	je     803567 <insert_sorted_with_merge_freeList+0x2cd>
  803558:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80355b:	8b 40 04             	mov    0x4(%eax),%eax
  80355e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803561:	8b 12                	mov    (%edx),%edx
  803563:	89 10                	mov    %edx,(%eax)
  803565:	eb 0a                	jmp    803571 <insert_sorted_with_merge_freeList+0x2d7>
  803567:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80356a:	8b 00                	mov    (%eax),%eax
  80356c:	a3 38 51 80 00       	mov    %eax,0x805138
  803571:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803574:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80357a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80357d:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803584:	a1 44 51 80 00       	mov    0x805144,%eax
  803589:	48                   	dec    %eax
  80358a:	a3 44 51 80 00       	mov    %eax,0x805144
						addToAvailMemBlocksList(blockToInsert);
  80358f:	83 ec 0c             	sub    $0xc,%esp
  803592:	ff 75 08             	pushl  0x8(%ebp)
  803595:	e8 80 fc ff ff       	call   80321a <addToAvailMemBlocksList>
  80359a:	83 c4 10             	add    $0x10,%esp
						addToAvailMemBlocksList(iterator);
  80359d:	83 ec 0c             	sub    $0xc,%esp
  8035a0:	ff 75 f4             	pushl  -0xc(%ebp)
  8035a3:	e8 72 fc ff ff       	call   80321a <addToAvailMemBlocksList>
  8035a8:	83 c4 10             	add    $0x10,%esp
					//Insert
					else {
						LIST_INSERT_BEFORE(&FreeMemBlocksList, iterator,
								blockToInsert);
					}
					break;
  8035ab:	e9 2e 01 00 00       	jmp    8036de <insert_sorted_with_merge_freeList+0x444>
						LIST_REMOVE(&FreeMemBlocksList, iterator);
						addToAvailMemBlocksList(blockToInsert);
						addToAvailMemBlocksList(iterator);
					}
					//previous merge
					else if (prev->sva + prev->size == blockToInsert->sva) {
  8035b0:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8035b3:	8b 50 08             	mov    0x8(%eax),%edx
  8035b6:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8035b9:	8b 40 0c             	mov    0xc(%eax),%eax
  8035bc:	01 c2                	add    %eax,%edx
  8035be:	8b 45 08             	mov    0x8(%ebp),%eax
  8035c1:	8b 40 08             	mov    0x8(%eax),%eax
  8035c4:	39 c2                	cmp    %eax,%edx
  8035c6:	75 27                	jne    8035ef <insert_sorted_with_merge_freeList+0x355>
						prev->size = prev->size + blockToInsert->size;
  8035c8:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8035cb:	8b 50 0c             	mov    0xc(%eax),%edx
  8035ce:	8b 45 08             	mov    0x8(%ebp),%eax
  8035d1:	8b 40 0c             	mov    0xc(%eax),%eax
  8035d4:	01 c2                	add    %eax,%edx
  8035d6:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8035d9:	89 50 0c             	mov    %edx,0xc(%eax)
						addToAvailMemBlocksList(blockToInsert);
  8035dc:	83 ec 0c             	sub    $0xc,%esp
  8035df:	ff 75 08             	pushl  0x8(%ebp)
  8035e2:	e8 33 fc ff ff       	call   80321a <addToAvailMemBlocksList>
  8035e7:	83 c4 10             	add    $0x10,%esp
					//Insert
					else {
						LIST_INSERT_BEFORE(&FreeMemBlocksList, iterator,
								blockToInsert);
					}
					break;
  8035ea:	e9 ef 00 00 00       	jmp    8036de <insert_sorted_with_merge_freeList+0x444>
					else if (prev->sva + prev->size == blockToInsert->sva) {
						prev->size = prev->size + blockToInsert->size;
						addToAvailMemBlocksList(blockToInsert);
					}
					//next merge
					else if (blockToInsert->size + blockToInsert->sva
  8035ef:	8b 45 08             	mov    0x8(%ebp),%eax
  8035f2:	8b 50 0c             	mov    0xc(%eax),%edx
  8035f5:	8b 45 08             	mov    0x8(%ebp),%eax
  8035f8:	8b 40 08             	mov    0x8(%eax),%eax
  8035fb:	01 c2                	add    %eax,%edx
							== iterator->sva) {
  8035fd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803600:	8b 40 08             	mov    0x8(%eax),%eax
					else if (prev->sva + prev->size == blockToInsert->sva) {
						prev->size = prev->size + blockToInsert->size;
						addToAvailMemBlocksList(blockToInsert);
					}
					//next merge
					else if (blockToInsert->size + blockToInsert->sva
  803603:	39 c2                	cmp    %eax,%edx
  803605:	75 33                	jne    80363a <insert_sorted_with_merge_freeList+0x3a0>
							== iterator->sva) {
						iterator->sva = blockToInsert->sva;
  803607:	8b 45 08             	mov    0x8(%ebp),%eax
  80360a:	8b 50 08             	mov    0x8(%eax),%edx
  80360d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803610:	89 50 08             	mov    %edx,0x8(%eax)
						iterator->size = iterator->size + blockToInsert->size;
  803613:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803616:	8b 50 0c             	mov    0xc(%eax),%edx
  803619:	8b 45 08             	mov    0x8(%ebp),%eax
  80361c:	8b 40 0c             	mov    0xc(%eax),%eax
  80361f:	01 c2                	add    %eax,%edx
  803621:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803624:	89 50 0c             	mov    %edx,0xc(%eax)
						addToAvailMemBlocksList(blockToInsert);
  803627:	83 ec 0c             	sub    $0xc,%esp
  80362a:	ff 75 08             	pushl  0x8(%ebp)
  80362d:	e8 e8 fb ff ff       	call   80321a <addToAvailMemBlocksList>
  803632:	83 c4 10             	add    $0x10,%esp
					//Insert
					else {
						LIST_INSERT_BEFORE(&FreeMemBlocksList, iterator,
								blockToInsert);
					}
					break;
  803635:	e9 a4 00 00 00       	jmp    8036de <insert_sorted_with_merge_freeList+0x444>
						iterator->size = iterator->size + blockToInsert->size;
						addToAvailMemBlocksList(blockToInsert);
					}
					//Insert
					else {
						LIST_INSERT_BEFORE(&FreeMemBlocksList, iterator,
  80363a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80363e:	74 06                	je     803646 <insert_sorted_with_merge_freeList+0x3ac>
  803640:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803644:	75 17                	jne    80365d <insert_sorted_with_merge_freeList+0x3c3>
  803646:	83 ec 04             	sub    $0x4,%esp
  803649:	68 1c 43 80 00       	push   $0x80431c
  80364e:	68 56 01 00 00       	push   $0x156
  803653:	68 8b 42 80 00       	push   $0x80428b
  803658:	e8 a4 d2 ff ff       	call   800901 <_panic>
  80365d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803660:	8b 50 04             	mov    0x4(%eax),%edx
  803663:	8b 45 08             	mov    0x8(%ebp),%eax
  803666:	89 50 04             	mov    %edx,0x4(%eax)
  803669:	8b 45 08             	mov    0x8(%ebp),%eax
  80366c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80366f:	89 10                	mov    %edx,(%eax)
  803671:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803674:	8b 40 04             	mov    0x4(%eax),%eax
  803677:	85 c0                	test   %eax,%eax
  803679:	74 0d                	je     803688 <insert_sorted_with_merge_freeList+0x3ee>
  80367b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80367e:	8b 40 04             	mov    0x4(%eax),%eax
  803681:	8b 55 08             	mov    0x8(%ebp),%edx
  803684:	89 10                	mov    %edx,(%eax)
  803686:	eb 08                	jmp    803690 <insert_sorted_with_merge_freeList+0x3f6>
  803688:	8b 45 08             	mov    0x8(%ebp),%eax
  80368b:	a3 38 51 80 00       	mov    %eax,0x805138
  803690:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803693:	8b 55 08             	mov    0x8(%ebp),%edx
  803696:	89 50 04             	mov    %edx,0x4(%eax)
  803699:	a1 44 51 80 00       	mov    0x805144,%eax
  80369e:	40                   	inc    %eax
  80369f:	a3 44 51 80 00       	mov    %eax,0x805144
								blockToInsert);
					}
					break;
  8036a4:	eb 38                	jmp    8036de <insert_sorted_with_merge_freeList+0x444>
		} else {
			LIST_INSERT_AFTER(&FreeMemBlocksList, last, blockToInsert);
		}
	} else {
		struct MemBlock *iterator;
		LIST_FOREACH(iterator, &(FreeMemBlocksList))
  8036a6:	a1 40 51 80 00       	mov    0x805140,%eax
  8036ab:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8036ae:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8036b2:	74 07                	je     8036bb <insert_sorted_with_merge_freeList+0x421>
  8036b4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8036b7:	8b 00                	mov    (%eax),%eax
  8036b9:	eb 05                	jmp    8036c0 <insert_sorted_with_merge_freeList+0x426>
  8036bb:	b8 00 00 00 00       	mov    $0x0,%eax
  8036c0:	a3 40 51 80 00       	mov    %eax,0x805140
  8036c5:	a1 40 51 80 00       	mov    0x805140,%eax
  8036ca:	85 c0                	test   %eax,%eax
  8036cc:	0f 85 1a fd ff ff    	jne    8033ec <insert_sorted_with_merge_freeList+0x152>
  8036d2:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8036d6:	0f 85 10 fd ff ff    	jne    8033ec <insert_sorted_with_merge_freeList+0x152>
		}
	}

	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  8036dc:	eb 00                	jmp    8036de <insert_sorted_with_merge_freeList+0x444>
  8036de:	90                   	nop
  8036df:	c9                   	leave  
  8036e0:	c3                   	ret    
  8036e1:	66 90                	xchg   %ax,%ax
  8036e3:	90                   	nop

008036e4 <__udivdi3>:
  8036e4:	55                   	push   %ebp
  8036e5:	57                   	push   %edi
  8036e6:	56                   	push   %esi
  8036e7:	53                   	push   %ebx
  8036e8:	83 ec 1c             	sub    $0x1c,%esp
  8036eb:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  8036ef:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  8036f3:	8b 7c 24 38          	mov    0x38(%esp),%edi
  8036f7:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8036fb:	89 ca                	mov    %ecx,%edx
  8036fd:	89 f8                	mov    %edi,%eax
  8036ff:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  803703:	85 f6                	test   %esi,%esi
  803705:	75 2d                	jne    803734 <__udivdi3+0x50>
  803707:	39 cf                	cmp    %ecx,%edi
  803709:	77 65                	ja     803770 <__udivdi3+0x8c>
  80370b:	89 fd                	mov    %edi,%ebp
  80370d:	85 ff                	test   %edi,%edi
  80370f:	75 0b                	jne    80371c <__udivdi3+0x38>
  803711:	b8 01 00 00 00       	mov    $0x1,%eax
  803716:	31 d2                	xor    %edx,%edx
  803718:	f7 f7                	div    %edi
  80371a:	89 c5                	mov    %eax,%ebp
  80371c:	31 d2                	xor    %edx,%edx
  80371e:	89 c8                	mov    %ecx,%eax
  803720:	f7 f5                	div    %ebp
  803722:	89 c1                	mov    %eax,%ecx
  803724:	89 d8                	mov    %ebx,%eax
  803726:	f7 f5                	div    %ebp
  803728:	89 cf                	mov    %ecx,%edi
  80372a:	89 fa                	mov    %edi,%edx
  80372c:	83 c4 1c             	add    $0x1c,%esp
  80372f:	5b                   	pop    %ebx
  803730:	5e                   	pop    %esi
  803731:	5f                   	pop    %edi
  803732:	5d                   	pop    %ebp
  803733:	c3                   	ret    
  803734:	39 ce                	cmp    %ecx,%esi
  803736:	77 28                	ja     803760 <__udivdi3+0x7c>
  803738:	0f bd fe             	bsr    %esi,%edi
  80373b:	83 f7 1f             	xor    $0x1f,%edi
  80373e:	75 40                	jne    803780 <__udivdi3+0x9c>
  803740:	39 ce                	cmp    %ecx,%esi
  803742:	72 0a                	jb     80374e <__udivdi3+0x6a>
  803744:	3b 44 24 08          	cmp    0x8(%esp),%eax
  803748:	0f 87 9e 00 00 00    	ja     8037ec <__udivdi3+0x108>
  80374e:	b8 01 00 00 00       	mov    $0x1,%eax
  803753:	89 fa                	mov    %edi,%edx
  803755:	83 c4 1c             	add    $0x1c,%esp
  803758:	5b                   	pop    %ebx
  803759:	5e                   	pop    %esi
  80375a:	5f                   	pop    %edi
  80375b:	5d                   	pop    %ebp
  80375c:	c3                   	ret    
  80375d:	8d 76 00             	lea    0x0(%esi),%esi
  803760:	31 ff                	xor    %edi,%edi
  803762:	31 c0                	xor    %eax,%eax
  803764:	89 fa                	mov    %edi,%edx
  803766:	83 c4 1c             	add    $0x1c,%esp
  803769:	5b                   	pop    %ebx
  80376a:	5e                   	pop    %esi
  80376b:	5f                   	pop    %edi
  80376c:	5d                   	pop    %ebp
  80376d:	c3                   	ret    
  80376e:	66 90                	xchg   %ax,%ax
  803770:	89 d8                	mov    %ebx,%eax
  803772:	f7 f7                	div    %edi
  803774:	31 ff                	xor    %edi,%edi
  803776:	89 fa                	mov    %edi,%edx
  803778:	83 c4 1c             	add    $0x1c,%esp
  80377b:	5b                   	pop    %ebx
  80377c:	5e                   	pop    %esi
  80377d:	5f                   	pop    %edi
  80377e:	5d                   	pop    %ebp
  80377f:	c3                   	ret    
  803780:	bd 20 00 00 00       	mov    $0x20,%ebp
  803785:	89 eb                	mov    %ebp,%ebx
  803787:	29 fb                	sub    %edi,%ebx
  803789:	89 f9                	mov    %edi,%ecx
  80378b:	d3 e6                	shl    %cl,%esi
  80378d:	89 c5                	mov    %eax,%ebp
  80378f:	88 d9                	mov    %bl,%cl
  803791:	d3 ed                	shr    %cl,%ebp
  803793:	89 e9                	mov    %ebp,%ecx
  803795:	09 f1                	or     %esi,%ecx
  803797:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  80379b:	89 f9                	mov    %edi,%ecx
  80379d:	d3 e0                	shl    %cl,%eax
  80379f:	89 c5                	mov    %eax,%ebp
  8037a1:	89 d6                	mov    %edx,%esi
  8037a3:	88 d9                	mov    %bl,%cl
  8037a5:	d3 ee                	shr    %cl,%esi
  8037a7:	89 f9                	mov    %edi,%ecx
  8037a9:	d3 e2                	shl    %cl,%edx
  8037ab:	8b 44 24 08          	mov    0x8(%esp),%eax
  8037af:	88 d9                	mov    %bl,%cl
  8037b1:	d3 e8                	shr    %cl,%eax
  8037b3:	09 c2                	or     %eax,%edx
  8037b5:	89 d0                	mov    %edx,%eax
  8037b7:	89 f2                	mov    %esi,%edx
  8037b9:	f7 74 24 0c          	divl   0xc(%esp)
  8037bd:	89 d6                	mov    %edx,%esi
  8037bf:	89 c3                	mov    %eax,%ebx
  8037c1:	f7 e5                	mul    %ebp
  8037c3:	39 d6                	cmp    %edx,%esi
  8037c5:	72 19                	jb     8037e0 <__udivdi3+0xfc>
  8037c7:	74 0b                	je     8037d4 <__udivdi3+0xf0>
  8037c9:	89 d8                	mov    %ebx,%eax
  8037cb:	31 ff                	xor    %edi,%edi
  8037cd:	e9 58 ff ff ff       	jmp    80372a <__udivdi3+0x46>
  8037d2:	66 90                	xchg   %ax,%ax
  8037d4:	8b 54 24 08          	mov    0x8(%esp),%edx
  8037d8:	89 f9                	mov    %edi,%ecx
  8037da:	d3 e2                	shl    %cl,%edx
  8037dc:	39 c2                	cmp    %eax,%edx
  8037de:	73 e9                	jae    8037c9 <__udivdi3+0xe5>
  8037e0:	8d 43 ff             	lea    -0x1(%ebx),%eax
  8037e3:	31 ff                	xor    %edi,%edi
  8037e5:	e9 40 ff ff ff       	jmp    80372a <__udivdi3+0x46>
  8037ea:	66 90                	xchg   %ax,%ax
  8037ec:	31 c0                	xor    %eax,%eax
  8037ee:	e9 37 ff ff ff       	jmp    80372a <__udivdi3+0x46>
  8037f3:	90                   	nop

008037f4 <__umoddi3>:
  8037f4:	55                   	push   %ebp
  8037f5:	57                   	push   %edi
  8037f6:	56                   	push   %esi
  8037f7:	53                   	push   %ebx
  8037f8:	83 ec 1c             	sub    $0x1c,%esp
  8037fb:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  8037ff:	8b 74 24 34          	mov    0x34(%esp),%esi
  803803:	8b 7c 24 38          	mov    0x38(%esp),%edi
  803807:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  80380b:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80380f:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  803813:	89 f3                	mov    %esi,%ebx
  803815:	89 fa                	mov    %edi,%edx
  803817:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  80381b:	89 34 24             	mov    %esi,(%esp)
  80381e:	85 c0                	test   %eax,%eax
  803820:	75 1a                	jne    80383c <__umoddi3+0x48>
  803822:	39 f7                	cmp    %esi,%edi
  803824:	0f 86 a2 00 00 00    	jbe    8038cc <__umoddi3+0xd8>
  80382a:	89 c8                	mov    %ecx,%eax
  80382c:	89 f2                	mov    %esi,%edx
  80382e:	f7 f7                	div    %edi
  803830:	89 d0                	mov    %edx,%eax
  803832:	31 d2                	xor    %edx,%edx
  803834:	83 c4 1c             	add    $0x1c,%esp
  803837:	5b                   	pop    %ebx
  803838:	5e                   	pop    %esi
  803839:	5f                   	pop    %edi
  80383a:	5d                   	pop    %ebp
  80383b:	c3                   	ret    
  80383c:	39 f0                	cmp    %esi,%eax
  80383e:	0f 87 ac 00 00 00    	ja     8038f0 <__umoddi3+0xfc>
  803844:	0f bd e8             	bsr    %eax,%ebp
  803847:	83 f5 1f             	xor    $0x1f,%ebp
  80384a:	0f 84 ac 00 00 00    	je     8038fc <__umoddi3+0x108>
  803850:	bf 20 00 00 00       	mov    $0x20,%edi
  803855:	29 ef                	sub    %ebp,%edi
  803857:	89 fe                	mov    %edi,%esi
  803859:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  80385d:	89 e9                	mov    %ebp,%ecx
  80385f:	d3 e0                	shl    %cl,%eax
  803861:	89 d7                	mov    %edx,%edi
  803863:	89 f1                	mov    %esi,%ecx
  803865:	d3 ef                	shr    %cl,%edi
  803867:	09 c7                	or     %eax,%edi
  803869:	89 e9                	mov    %ebp,%ecx
  80386b:	d3 e2                	shl    %cl,%edx
  80386d:	89 14 24             	mov    %edx,(%esp)
  803870:	89 d8                	mov    %ebx,%eax
  803872:	d3 e0                	shl    %cl,%eax
  803874:	89 c2                	mov    %eax,%edx
  803876:	8b 44 24 08          	mov    0x8(%esp),%eax
  80387a:	d3 e0                	shl    %cl,%eax
  80387c:	89 44 24 04          	mov    %eax,0x4(%esp)
  803880:	8b 44 24 08          	mov    0x8(%esp),%eax
  803884:	89 f1                	mov    %esi,%ecx
  803886:	d3 e8                	shr    %cl,%eax
  803888:	09 d0                	or     %edx,%eax
  80388a:	d3 eb                	shr    %cl,%ebx
  80388c:	89 da                	mov    %ebx,%edx
  80388e:	f7 f7                	div    %edi
  803890:	89 d3                	mov    %edx,%ebx
  803892:	f7 24 24             	mull   (%esp)
  803895:	89 c6                	mov    %eax,%esi
  803897:	89 d1                	mov    %edx,%ecx
  803899:	39 d3                	cmp    %edx,%ebx
  80389b:	0f 82 87 00 00 00    	jb     803928 <__umoddi3+0x134>
  8038a1:	0f 84 91 00 00 00    	je     803938 <__umoddi3+0x144>
  8038a7:	8b 54 24 04          	mov    0x4(%esp),%edx
  8038ab:	29 f2                	sub    %esi,%edx
  8038ad:	19 cb                	sbb    %ecx,%ebx
  8038af:	89 d8                	mov    %ebx,%eax
  8038b1:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  8038b5:	d3 e0                	shl    %cl,%eax
  8038b7:	89 e9                	mov    %ebp,%ecx
  8038b9:	d3 ea                	shr    %cl,%edx
  8038bb:	09 d0                	or     %edx,%eax
  8038bd:	89 e9                	mov    %ebp,%ecx
  8038bf:	d3 eb                	shr    %cl,%ebx
  8038c1:	89 da                	mov    %ebx,%edx
  8038c3:	83 c4 1c             	add    $0x1c,%esp
  8038c6:	5b                   	pop    %ebx
  8038c7:	5e                   	pop    %esi
  8038c8:	5f                   	pop    %edi
  8038c9:	5d                   	pop    %ebp
  8038ca:	c3                   	ret    
  8038cb:	90                   	nop
  8038cc:	89 fd                	mov    %edi,%ebp
  8038ce:	85 ff                	test   %edi,%edi
  8038d0:	75 0b                	jne    8038dd <__umoddi3+0xe9>
  8038d2:	b8 01 00 00 00       	mov    $0x1,%eax
  8038d7:	31 d2                	xor    %edx,%edx
  8038d9:	f7 f7                	div    %edi
  8038db:	89 c5                	mov    %eax,%ebp
  8038dd:	89 f0                	mov    %esi,%eax
  8038df:	31 d2                	xor    %edx,%edx
  8038e1:	f7 f5                	div    %ebp
  8038e3:	89 c8                	mov    %ecx,%eax
  8038e5:	f7 f5                	div    %ebp
  8038e7:	89 d0                	mov    %edx,%eax
  8038e9:	e9 44 ff ff ff       	jmp    803832 <__umoddi3+0x3e>
  8038ee:	66 90                	xchg   %ax,%ax
  8038f0:	89 c8                	mov    %ecx,%eax
  8038f2:	89 f2                	mov    %esi,%edx
  8038f4:	83 c4 1c             	add    $0x1c,%esp
  8038f7:	5b                   	pop    %ebx
  8038f8:	5e                   	pop    %esi
  8038f9:	5f                   	pop    %edi
  8038fa:	5d                   	pop    %ebp
  8038fb:	c3                   	ret    
  8038fc:	3b 04 24             	cmp    (%esp),%eax
  8038ff:	72 06                	jb     803907 <__umoddi3+0x113>
  803901:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  803905:	77 0f                	ja     803916 <__umoddi3+0x122>
  803907:	89 f2                	mov    %esi,%edx
  803909:	29 f9                	sub    %edi,%ecx
  80390b:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  80390f:	89 14 24             	mov    %edx,(%esp)
  803912:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  803916:	8b 44 24 04          	mov    0x4(%esp),%eax
  80391a:	8b 14 24             	mov    (%esp),%edx
  80391d:	83 c4 1c             	add    $0x1c,%esp
  803920:	5b                   	pop    %ebx
  803921:	5e                   	pop    %esi
  803922:	5f                   	pop    %edi
  803923:	5d                   	pop    %ebp
  803924:	c3                   	ret    
  803925:	8d 76 00             	lea    0x0(%esi),%esi
  803928:	2b 04 24             	sub    (%esp),%eax
  80392b:	19 fa                	sbb    %edi,%edx
  80392d:	89 d1                	mov    %edx,%ecx
  80392f:	89 c6                	mov    %eax,%esi
  803931:	e9 71 ff ff ff       	jmp    8038a7 <__umoddi3+0xb3>
  803936:	66 90                	xchg   %ax,%ax
  803938:	39 44 24 04          	cmp    %eax,0x4(%esp)
  80393c:	72 ea                	jb     803928 <__umoddi3+0x134>
  80393e:	89 d9                	mov    %ebx,%ecx
  803940:	e9 62 ff ff ff       	jmp    8038a7 <__umoddi3+0xb3>
