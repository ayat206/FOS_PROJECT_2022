
obj/user/mergesort_leakage:     file format elf32-i386


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
  800031:	e8 65 07 00 00       	call   80079b <libmain>
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
  800041:	e8 d6 21 00 00       	call   80221c <sys_disable_interrupt>

		cprintf("\n");
  800046:	83 ec 0c             	sub    $0xc,%esp
  800049:	68 20 39 80 00       	push   $0x803920
  80004e:	e8 38 0b 00 00       	call   800b8b <cprintf>
  800053:	83 c4 10             	add    $0x10,%esp
		cprintf("!!!!!!!!!!!!!!!!!!!!\n");
  800056:	83 ec 0c             	sub    $0xc,%esp
  800059:	68 22 39 80 00       	push   $0x803922
  80005e:	e8 28 0b 00 00       	call   800b8b <cprintf>
  800063:	83 c4 10             	add    $0x10,%esp
		cprintf("!!!! MERGE SORT !!!!\n");
  800066:	83 ec 0c             	sub    $0xc,%esp
  800069:	68 38 39 80 00       	push   $0x803938
  80006e:	e8 18 0b 00 00       	call   800b8b <cprintf>
  800073:	83 c4 10             	add    $0x10,%esp
		cprintf("!!!!!!!!!!!!!!!!!!!!\n");
  800076:	83 ec 0c             	sub    $0xc,%esp
  800079:	68 22 39 80 00       	push   $0x803922
  80007e:	e8 08 0b 00 00       	call   800b8b <cprintf>
  800083:	83 c4 10             	add    $0x10,%esp
		cprintf("\n");
  800086:	83 ec 0c             	sub    $0xc,%esp
  800089:	68 20 39 80 00       	push   $0x803920
  80008e:	e8 f8 0a 00 00       	call   800b8b <cprintf>
  800093:	83 c4 10             	add    $0x10,%esp
		readline("Enter the number of elements: ", Line);
  800096:	83 ec 08             	sub    $0x8,%esp
  800099:	8d 85 e9 fe ff ff    	lea    -0x117(%ebp),%eax
  80009f:	50                   	push   %eax
  8000a0:	68 50 39 80 00       	push   $0x803950
  8000a5:	e8 63 11 00 00       	call   80120d <readline>
  8000aa:	83 c4 10             	add    $0x10,%esp
		int NumOfElements = strtol(Line, NULL, 10) ;
  8000ad:	83 ec 04             	sub    $0x4,%esp
  8000b0:	6a 0a                	push   $0xa
  8000b2:	6a 00                	push   $0x0
  8000b4:	8d 85 e9 fe ff ff    	lea    -0x117(%ebp),%eax
  8000ba:	50                   	push   %eax
  8000bb:	e8 b3 16 00 00       	call   801773 <strtol>
  8000c0:	83 c4 10             	add    $0x10,%esp
  8000c3:	89 45 f0             	mov    %eax,-0x10(%ebp)
		int *Elements = malloc(sizeof(int) * NumOfElements) ;
  8000c6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8000c9:	c1 e0 02             	shl    $0x2,%eax
  8000cc:	83 ec 0c             	sub    $0xc,%esp
  8000cf:	50                   	push   %eax
  8000d0:	e8 4e 1c 00 00       	call   801d23 <malloc>
  8000d5:	83 c4 10             	add    $0x10,%esp
  8000d8:	89 45 ec             	mov    %eax,-0x14(%ebp)
		cprintf("Chose the initialization method:\n") ;
  8000db:	83 ec 0c             	sub    $0xc,%esp
  8000de:	68 70 39 80 00       	push   $0x803970
  8000e3:	e8 a3 0a 00 00       	call   800b8b <cprintf>
  8000e8:	83 c4 10             	add    $0x10,%esp
		cprintf("a) Ascending\n") ;
  8000eb:	83 ec 0c             	sub    $0xc,%esp
  8000ee:	68 92 39 80 00       	push   $0x803992
  8000f3:	e8 93 0a 00 00       	call   800b8b <cprintf>
  8000f8:	83 c4 10             	add    $0x10,%esp
		cprintf("b) Descending\n") ;
  8000fb:	83 ec 0c             	sub    $0xc,%esp
  8000fe:	68 a0 39 80 00       	push   $0x8039a0
  800103:	e8 83 0a 00 00       	call   800b8b <cprintf>
  800108:	83 c4 10             	add    $0x10,%esp
		cprintf("c) Semi random\n");
  80010b:	83 ec 0c             	sub    $0xc,%esp
  80010e:	68 af 39 80 00       	push   $0x8039af
  800113:	e8 73 0a 00 00       	call   800b8b <cprintf>
  800118:	83 c4 10             	add    $0x10,%esp
		do
		{
			cprintf("Select: ") ;
  80011b:	83 ec 0c             	sub    $0xc,%esp
  80011e:	68 bf 39 80 00       	push   $0x8039bf
  800123:	e8 63 0a 00 00       	call   800b8b <cprintf>
  800128:	83 c4 10             	add    $0x10,%esp
			Chose = getchar() ;
  80012b:	e8 13 06 00 00       	call   800743 <getchar>
  800130:	88 45 f7             	mov    %al,-0x9(%ebp)
			cputchar(Chose);
  800133:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
  800137:	83 ec 0c             	sub    $0xc,%esp
  80013a:	50                   	push   %eax
  80013b:	e8 bb 05 00 00       	call   8006fb <cputchar>
  800140:	83 c4 10             	add    $0x10,%esp
			cputchar('\n');
  800143:	83 ec 0c             	sub    $0xc,%esp
  800146:	6a 0a                	push   $0xa
  800148:	e8 ae 05 00 00       	call   8006fb <cputchar>
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
  800162:	e8 cf 20 00 00       	call   802236 <sys_enable_interrupt>

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
  800183:	e8 e6 01 00 00       	call   80036e <InitializeAscending>
  800188:	83 c4 10             	add    $0x10,%esp
			break ;
  80018b:	eb 37                	jmp    8001c4 <_main+0x18c>
		case 'b':
			InitializeDescending(Elements, NumOfElements);
  80018d:	83 ec 08             	sub    $0x8,%esp
  800190:	ff 75 f0             	pushl  -0x10(%ebp)
  800193:	ff 75 ec             	pushl  -0x14(%ebp)
  800196:	e8 04 02 00 00       	call   80039f <InitializeDescending>
  80019b:	83 c4 10             	add    $0x10,%esp
			break ;
  80019e:	eb 24                	jmp    8001c4 <_main+0x18c>
		case 'c':
			InitializeSemiRandom(Elements, NumOfElements);
  8001a0:	83 ec 08             	sub    $0x8,%esp
  8001a3:	ff 75 f0             	pushl  -0x10(%ebp)
  8001a6:	ff 75 ec             	pushl  -0x14(%ebp)
  8001a9:	e8 26 02 00 00       	call   8003d4 <InitializeSemiRandom>
  8001ae:	83 c4 10             	add    $0x10,%esp
			break ;
  8001b1:	eb 11                	jmp    8001c4 <_main+0x18c>
		default:
			InitializeSemiRandom(Elements, NumOfElements);
  8001b3:	83 ec 08             	sub    $0x8,%esp
  8001b6:	ff 75 f0             	pushl  -0x10(%ebp)
  8001b9:	ff 75 ec             	pushl  -0x14(%ebp)
  8001bc:	e8 13 02 00 00       	call   8003d4 <InitializeSemiRandom>
  8001c1:	83 c4 10             	add    $0x10,%esp
		}

		MSort(Elements, 1, NumOfElements);
  8001c4:	83 ec 04             	sub    $0x4,%esp
  8001c7:	ff 75 f0             	pushl  -0x10(%ebp)
  8001ca:	6a 01                	push   $0x1
  8001cc:	ff 75 ec             	pushl  -0x14(%ebp)
  8001cf:	e8 d2 02 00 00       	call   8004a6 <MSort>
  8001d4:	83 c4 10             	add    $0x10,%esp

		sys_disable_interrupt();
  8001d7:	e8 40 20 00 00       	call   80221c <sys_disable_interrupt>
		cprintf("Sorting is Finished!!!!it'll be checked now....\n") ;
  8001dc:	83 ec 0c             	sub    $0xc,%esp
  8001df:	68 c8 39 80 00       	push   $0x8039c8
  8001e4:	e8 a2 09 00 00       	call   800b8b <cprintf>
  8001e9:	83 c4 10             	add    $0x10,%esp
		//PrintElements(Elements, NumOfElements);
		sys_enable_interrupt();
  8001ec:	e8 45 20 00 00       	call   802236 <sys_enable_interrupt>

		uint32 Sorted = CheckSorted(Elements, NumOfElements);
  8001f1:	83 ec 08             	sub    $0x8,%esp
  8001f4:	ff 75 f0             	pushl  -0x10(%ebp)
  8001f7:	ff 75 ec             	pushl  -0x14(%ebp)
  8001fa:	e8 c5 00 00 00       	call   8002c4 <CheckSorted>
  8001ff:	83 c4 10             	add    $0x10,%esp
  800202:	89 45 e8             	mov    %eax,-0x18(%ebp)

		if(Sorted == 0) panic("The array is NOT sorted correctly") ;
  800205:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  800209:	75 14                	jne    80021f <_main+0x1e7>
  80020b:	83 ec 04             	sub    $0x4,%esp
  80020e:	68 fc 39 80 00       	push   $0x8039fc
  800213:	6a 4a                	push   $0x4a
  800215:	68 1e 3a 80 00       	push   $0x803a1e
  80021a:	e8 b8 06 00 00       	call   8008d7 <_panic>
		else
		{
			sys_disable_interrupt();
  80021f:	e8 f8 1f 00 00       	call   80221c <sys_disable_interrupt>
			cprintf("===============================================\n") ;
  800224:	83 ec 0c             	sub    $0xc,%esp
  800227:	68 38 3a 80 00       	push   $0x803a38
  80022c:	e8 5a 09 00 00       	call   800b8b <cprintf>
  800231:	83 c4 10             	add    $0x10,%esp
			cprintf("Congratulations!! The array is sorted correctly\n") ;
  800234:	83 ec 0c             	sub    $0xc,%esp
  800237:	68 6c 3a 80 00       	push   $0x803a6c
  80023c:	e8 4a 09 00 00       	call   800b8b <cprintf>
  800241:	83 c4 10             	add    $0x10,%esp
			cprintf("===============================================\n\n") ;
  800244:	83 ec 0c             	sub    $0xc,%esp
  800247:	68 a0 3a 80 00       	push   $0x803aa0
  80024c:	e8 3a 09 00 00       	call   800b8b <cprintf>
  800251:	83 c4 10             	add    $0x10,%esp
			sys_enable_interrupt();
  800254:	e8 dd 1f 00 00       	call   802236 <sys_enable_interrupt>
		}

		//free(Elements) ;

		sys_disable_interrupt();
  800259:	e8 be 1f 00 00       	call   80221c <sys_disable_interrupt>
			Chose = 0 ;
  80025e:	c6 45 f7 00          	movb   $0x0,-0x9(%ebp)
			while (Chose != 'y' && Chose != 'n')
  800262:	eb 42                	jmp    8002a6 <_main+0x26e>
			{
				cprintf("Do you want to repeat (y/n): ") ;
  800264:	83 ec 0c             	sub    $0xc,%esp
  800267:	68 d2 3a 80 00       	push   $0x803ad2
  80026c:	e8 1a 09 00 00       	call   800b8b <cprintf>
  800271:	83 c4 10             	add    $0x10,%esp
				Chose = getchar() ;
  800274:	e8 ca 04 00 00       	call   800743 <getchar>
  800279:	88 45 f7             	mov    %al,-0x9(%ebp)
				cputchar(Chose);
  80027c:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
  800280:	83 ec 0c             	sub    $0xc,%esp
  800283:	50                   	push   %eax
  800284:	e8 72 04 00 00       	call   8006fb <cputchar>
  800289:	83 c4 10             	add    $0x10,%esp
				cputchar('\n');
  80028c:	83 ec 0c             	sub    $0xc,%esp
  80028f:	6a 0a                	push   $0xa
  800291:	e8 65 04 00 00       	call   8006fb <cputchar>
  800296:	83 c4 10             	add    $0x10,%esp
				cputchar('\n');
  800299:	83 ec 0c             	sub    $0xc,%esp
  80029c:	6a 0a                	push   $0xa
  80029e:	e8 58 04 00 00       	call   8006fb <cputchar>
  8002a3:	83 c4 10             	add    $0x10,%esp

		//free(Elements) ;

		sys_disable_interrupt();
			Chose = 0 ;
			while (Chose != 'y' && Chose != 'n')
  8002a6:	80 7d f7 79          	cmpb   $0x79,-0x9(%ebp)
  8002aa:	74 06                	je     8002b2 <_main+0x27a>
  8002ac:	80 7d f7 6e          	cmpb   $0x6e,-0x9(%ebp)
  8002b0:	75 b2                	jne    800264 <_main+0x22c>
				Chose = getchar() ;
				cputchar(Chose);
				cputchar('\n');
				cputchar('\n');
			}
		sys_enable_interrupt();
  8002b2:	e8 7f 1f 00 00       	call   802236 <sys_enable_interrupt>

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
  800446:	68 20 39 80 00       	push   $0x803920
  80044b:	e8 3b 07 00 00       	call   800b8b <cprintf>
  800450:	83 c4 10             	add    $0x10,%esp
		cprintf("%d, ",Elements[i]);
  800453:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800456:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80045d:	8b 45 08             	mov    0x8(%ebp),%eax
  800460:	01 d0                	add    %edx,%eax
  800462:	8b 00                	mov    (%eax),%eax
  800464:	83 ec 08             	sub    $0x8,%esp
  800467:	50                   	push   %eax
  800468:	68 f0 3a 80 00       	push   $0x803af0
  80046d:	e8 19 07 00 00       	call   800b8b <cprintf>
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
  800496:	68 f5 3a 80 00       	push   $0x803af5
  80049b:	e8 eb 06 00 00       	call   800b8b <cprintf>
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
  80053c:	e8 e2 17 00 00       	call   801d23 <malloc>
  800541:	83 c4 10             	add    $0x10,%esp
  800544:	89 45 d8             	mov    %eax,-0x28(%ebp)

	int* Right = malloc(sizeof(int) * rightCapacity);
  800547:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80054a:	c1 e0 02             	shl    $0x2,%eax
  80054d:	83 ec 0c             	sub    $0xc,%esp
  800550:	50                   	push   %eax
  800551:	e8 cd 17 00 00       	call   801d23 <malloc>
  800556:	83 c4 10             	add    $0x10,%esp
  800559:	89 45 d4             	mov    %eax,-0x2c(%ebp)

	//	int Left[5000] ;
	//	int Right[5000] ;

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

	//	int Left[5000] ;
	//	int Right[5000] ;

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

}
  8006f8:	90                   	nop
  8006f9:	c9                   	leave  
  8006fa:	c3                   	ret    

008006fb <cputchar>:
#include <inc/lib.h>


void
cputchar(int ch)
{
  8006fb:	55                   	push   %ebp
  8006fc:	89 e5                	mov    %esp,%ebp
  8006fe:	83 ec 18             	sub    $0x18,%esp
	char c = ch;
  800701:	8b 45 08             	mov    0x8(%ebp),%eax
  800704:	88 45 f7             	mov    %al,-0x9(%ebp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	//sys_cputs(&c, 1);

	sys_cputc(c);
  800707:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
  80070b:	83 ec 0c             	sub    $0xc,%esp
  80070e:	50                   	push   %eax
  80070f:	e8 3c 1b 00 00       	call   802250 <sys_cputc>
  800714:	83 c4 10             	add    $0x10,%esp
}
  800717:	90                   	nop
  800718:	c9                   	leave  
  800719:	c3                   	ret    

0080071a <atomic_cputchar>:


void
atomic_cputchar(int ch)
{
  80071a:	55                   	push   %ebp
  80071b:	89 e5                	mov    %esp,%ebp
  80071d:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  800720:	e8 f7 1a 00 00       	call   80221c <sys_disable_interrupt>
	char c = ch;
  800725:	8b 45 08             	mov    0x8(%ebp),%eax
  800728:	88 45 f7             	mov    %al,-0x9(%ebp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	//sys_cputs(&c, 1);

	sys_cputc(c);
  80072b:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
  80072f:	83 ec 0c             	sub    $0xc,%esp
  800732:	50                   	push   %eax
  800733:	e8 18 1b 00 00       	call   802250 <sys_cputc>
  800738:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  80073b:	e8 f6 1a 00 00       	call   802236 <sys_enable_interrupt>
}
  800740:	90                   	nop
  800741:	c9                   	leave  
  800742:	c3                   	ret    

00800743 <getchar>:

int
getchar(void)
{
  800743:	55                   	push   %ebp
  800744:	89 e5                	mov    %esp,%ebp
  800746:	83 ec 18             	sub    $0x18,%esp

	//return sys_cgetc();
	int c=0;
  800749:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	while(c == 0)
  800750:	eb 08                	jmp    80075a <getchar+0x17>
	{
		c = sys_cgetc();
  800752:	e8 40 19 00 00       	call   802097 <sys_cgetc>
  800757:	89 45 f4             	mov    %eax,-0xc(%ebp)
getchar(void)
{

	//return sys_cgetc();
	int c=0;
	while(c == 0)
  80075a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80075e:	74 f2                	je     800752 <getchar+0xf>
	{
		c = sys_cgetc();
	}
	return c;
  800760:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  800763:	c9                   	leave  
  800764:	c3                   	ret    

00800765 <atomic_getchar>:

int
atomic_getchar(void)
{
  800765:	55                   	push   %ebp
  800766:	89 e5                	mov    %esp,%ebp
  800768:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  80076b:	e8 ac 1a 00 00       	call   80221c <sys_disable_interrupt>
	int c=0;
  800770:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	while(c == 0)
  800777:	eb 08                	jmp    800781 <atomic_getchar+0x1c>
	{
		c = sys_cgetc();
  800779:	e8 19 19 00 00       	call   802097 <sys_cgetc>
  80077e:	89 45 f4             	mov    %eax,-0xc(%ebp)
int
atomic_getchar(void)
{
	sys_disable_interrupt();
	int c=0;
	while(c == 0)
  800781:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  800785:	74 f2                	je     800779 <atomic_getchar+0x14>
	{
		c = sys_cgetc();
	}
	sys_enable_interrupt();
  800787:	e8 aa 1a 00 00       	call   802236 <sys_enable_interrupt>
	return c;
  80078c:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  80078f:	c9                   	leave  
  800790:	c3                   	ret    

00800791 <iscons>:

int iscons(int fdnum)
{
  800791:	55                   	push   %ebp
  800792:	89 e5                	mov    %esp,%ebp
	// used by readline
	return 1;
  800794:	b8 01 00 00 00       	mov    $0x1,%eax
}
  800799:	5d                   	pop    %ebp
  80079a:	c3                   	ret    

0080079b <libmain>:
volatile struct Env *myEnv = NULL;
volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";

void
libmain(int argc, char **argv)
{
  80079b:	55                   	push   %ebp
  80079c:	89 e5                	mov    %esp,%ebp
  80079e:	83 ec 18             	sub    $0x18,%esp
	int envIndex = sys_getenvindex();
  8007a1:	e8 69 1c 00 00       	call   80240f <sys_getenvindex>
  8007a6:	89 45 f4             	mov    %eax,-0xc(%ebp)
	myEnv = &(envs[envIndex]);
  8007a9:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8007ac:	89 d0                	mov    %edx,%eax
  8007ae:	c1 e0 03             	shl    $0x3,%eax
  8007b1:	01 d0                	add    %edx,%eax
  8007b3:	01 c0                	add    %eax,%eax
  8007b5:	01 d0                	add    %edx,%eax
  8007b7:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8007be:	01 d0                	add    %edx,%eax
  8007c0:	c1 e0 04             	shl    $0x4,%eax
  8007c3:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8007c8:	a3 24 50 80 00       	mov    %eax,0x805024

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  8007cd:	a1 24 50 80 00       	mov    0x805024,%eax
  8007d2:	8a 80 5c 05 00 00    	mov    0x55c(%eax),%al
  8007d8:	84 c0                	test   %al,%al
  8007da:	74 0f                	je     8007eb <libmain+0x50>
		binaryname = myEnv->prog_name;
  8007dc:	a1 24 50 80 00       	mov    0x805024,%eax
  8007e1:	05 5c 05 00 00       	add    $0x55c,%eax
  8007e6:	a3 00 50 80 00       	mov    %eax,0x805000

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8007eb:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8007ef:	7e 0a                	jle    8007fb <libmain+0x60>
		binaryname = argv[0];
  8007f1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8007f4:	8b 00                	mov    (%eax),%eax
  8007f6:	a3 00 50 80 00       	mov    %eax,0x805000

	// call user main routine
	_main(argc, argv);
  8007fb:	83 ec 08             	sub    $0x8,%esp
  8007fe:	ff 75 0c             	pushl  0xc(%ebp)
  800801:	ff 75 08             	pushl  0x8(%ebp)
  800804:	e8 2f f8 ff ff       	call   800038 <_main>
  800809:	83 c4 10             	add    $0x10,%esp



	sys_disable_interrupt();
  80080c:	e8 0b 1a 00 00       	call   80221c <sys_disable_interrupt>
	cprintf("**************************************\n");
  800811:	83 ec 0c             	sub    $0xc,%esp
  800814:	68 14 3b 80 00       	push   $0x803b14
  800819:	e8 6d 03 00 00       	call   800b8b <cprintf>
  80081e:	83 c4 10             	add    $0x10,%esp
	cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  800821:	a1 24 50 80 00       	mov    0x805024,%eax
  800826:	8b 90 44 05 00 00    	mov    0x544(%eax),%edx
  80082c:	a1 24 50 80 00       	mov    0x805024,%eax
  800831:	8b 80 34 05 00 00    	mov    0x534(%eax),%eax
  800837:	83 ec 04             	sub    $0x4,%esp
  80083a:	52                   	push   %edx
  80083b:	50                   	push   %eax
  80083c:	68 3c 3b 80 00       	push   $0x803b3c
  800841:	e8 45 03 00 00       	call   800b8b <cprintf>
  800846:	83 c4 10             	add    $0x10,%esp
	cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  800849:	a1 24 50 80 00       	mov    0x805024,%eax
  80084e:	8b 88 54 05 00 00    	mov    0x554(%eax),%ecx
  800854:	a1 24 50 80 00       	mov    0x805024,%eax
  800859:	8b 90 50 05 00 00    	mov    0x550(%eax),%edx
  80085f:	a1 24 50 80 00       	mov    0x805024,%eax
  800864:	8b 80 4c 05 00 00    	mov    0x54c(%eax),%eax
  80086a:	51                   	push   %ecx
  80086b:	52                   	push   %edx
  80086c:	50                   	push   %eax
  80086d:	68 64 3b 80 00       	push   $0x803b64
  800872:	e8 14 03 00 00       	call   800b8b <cprintf>
  800877:	83 c4 10             	add    $0x10,%esp
	//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
	cprintf("Num of clocks = %d\n", myEnv->nClocks);
  80087a:	a1 24 50 80 00       	mov    0x805024,%eax
  80087f:	8b 80 a4 05 00 00    	mov    0x5a4(%eax),%eax
  800885:	83 ec 08             	sub    $0x8,%esp
  800888:	50                   	push   %eax
  800889:	68 bc 3b 80 00       	push   $0x803bbc
  80088e:	e8 f8 02 00 00       	call   800b8b <cprintf>
  800893:	83 c4 10             	add    $0x10,%esp
	cprintf("**************************************\n");
  800896:	83 ec 0c             	sub    $0xc,%esp
  800899:	68 14 3b 80 00       	push   $0x803b14
  80089e:	e8 e8 02 00 00       	call   800b8b <cprintf>
  8008a3:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  8008a6:	e8 8b 19 00 00       	call   802236 <sys_enable_interrupt>

	// exit gracefully
	exit();
  8008ab:	e8 19 00 00 00       	call   8008c9 <exit>
}
  8008b0:	90                   	nop
  8008b1:	c9                   	leave  
  8008b2:	c3                   	ret    

008008b3 <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  8008b3:	55                   	push   %ebp
  8008b4:	89 e5                	mov    %esp,%ebp
  8008b6:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  8008b9:	83 ec 0c             	sub    $0xc,%esp
  8008bc:	6a 00                	push   $0x0
  8008be:	e8 18 1b 00 00       	call   8023db <sys_destroy_env>
  8008c3:	83 c4 10             	add    $0x10,%esp
}
  8008c6:	90                   	nop
  8008c7:	c9                   	leave  
  8008c8:	c3                   	ret    

008008c9 <exit>:

void
exit(void)
{
  8008c9:	55                   	push   %ebp
  8008ca:	89 e5                	mov    %esp,%ebp
  8008cc:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  8008cf:	e8 6d 1b 00 00       	call   802441 <sys_exit_env>
}
  8008d4:	90                   	nop
  8008d5:	c9                   	leave  
  8008d6:	c3                   	ret    

008008d7 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  8008d7:	55                   	push   %ebp
  8008d8:	89 e5                	mov    %esp,%ebp
  8008da:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  8008dd:	8d 45 10             	lea    0x10(%ebp),%eax
  8008e0:	83 c0 04             	add    $0x4,%eax
  8008e3:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  8008e6:	a1 5c 51 80 00       	mov    0x80515c,%eax
  8008eb:	85 c0                	test   %eax,%eax
  8008ed:	74 16                	je     800905 <_panic+0x2e>
		cprintf("%s: ", argv0);
  8008ef:	a1 5c 51 80 00       	mov    0x80515c,%eax
  8008f4:	83 ec 08             	sub    $0x8,%esp
  8008f7:	50                   	push   %eax
  8008f8:	68 d0 3b 80 00       	push   $0x803bd0
  8008fd:	e8 89 02 00 00       	call   800b8b <cprintf>
  800902:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  800905:	a1 00 50 80 00       	mov    0x805000,%eax
  80090a:	ff 75 0c             	pushl  0xc(%ebp)
  80090d:	ff 75 08             	pushl  0x8(%ebp)
  800910:	50                   	push   %eax
  800911:	68 d5 3b 80 00       	push   $0x803bd5
  800916:	e8 70 02 00 00       	call   800b8b <cprintf>
  80091b:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  80091e:	8b 45 10             	mov    0x10(%ebp),%eax
  800921:	83 ec 08             	sub    $0x8,%esp
  800924:	ff 75 f4             	pushl  -0xc(%ebp)
  800927:	50                   	push   %eax
  800928:	e8 f3 01 00 00       	call   800b20 <vcprintf>
  80092d:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  800930:	83 ec 08             	sub    $0x8,%esp
  800933:	6a 00                	push   $0x0
  800935:	68 f1 3b 80 00       	push   $0x803bf1
  80093a:	e8 e1 01 00 00       	call   800b20 <vcprintf>
  80093f:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  800942:	e8 82 ff ff ff       	call   8008c9 <exit>

	// should not return here
	while (1) ;
  800947:	eb fe                	jmp    800947 <_panic+0x70>

00800949 <CheckWSWithoutLastIndex>:
}

void CheckWSWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  800949:	55                   	push   %ebp
  80094a:	89 e5                	mov    %esp,%ebp
  80094c:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  80094f:	a1 24 50 80 00       	mov    0x805024,%eax
  800954:	8b 50 74             	mov    0x74(%eax),%edx
  800957:	8b 45 0c             	mov    0xc(%ebp),%eax
  80095a:	39 c2                	cmp    %eax,%edx
  80095c:	74 14                	je     800972 <CheckWSWithoutLastIndex+0x29>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  80095e:	83 ec 04             	sub    $0x4,%esp
  800961:	68 f4 3b 80 00       	push   $0x803bf4
  800966:	6a 26                	push   $0x26
  800968:	68 40 3c 80 00       	push   $0x803c40
  80096d:	e8 65 ff ff ff       	call   8008d7 <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  800972:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  800979:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800980:	e9 c2 00 00 00       	jmp    800a47 <CheckWSWithoutLastIndex+0xfe>
		if (expectedPages[e] == 0) {
  800985:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800988:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80098f:	8b 45 08             	mov    0x8(%ebp),%eax
  800992:	01 d0                	add    %edx,%eax
  800994:	8b 00                	mov    (%eax),%eax
  800996:	85 c0                	test   %eax,%eax
  800998:	75 08                	jne    8009a2 <CheckWSWithoutLastIndex+0x59>
			expectedNumOfEmptyLocs++;
  80099a:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  80099d:	e9 a2 00 00 00       	jmp    800a44 <CheckWSWithoutLastIndex+0xfb>
		}
		int found = 0;
  8009a2:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8009a9:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  8009b0:	eb 69                	jmp    800a1b <CheckWSWithoutLastIndex+0xd2>
			if (myEnv->__uptr_pws[w].empty == 0) {
  8009b2:	a1 24 50 80 00       	mov    0x805024,%eax
  8009b7:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  8009bd:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8009c0:	89 d0                	mov    %edx,%eax
  8009c2:	01 c0                	add    %eax,%eax
  8009c4:	01 d0                	add    %edx,%eax
  8009c6:	c1 e0 03             	shl    $0x3,%eax
  8009c9:	01 c8                	add    %ecx,%eax
  8009cb:	8a 40 04             	mov    0x4(%eax),%al
  8009ce:	84 c0                	test   %al,%al
  8009d0:	75 46                	jne    800a18 <CheckWSWithoutLastIndex+0xcf>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  8009d2:	a1 24 50 80 00       	mov    0x805024,%eax
  8009d7:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  8009dd:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8009e0:	89 d0                	mov    %edx,%eax
  8009e2:	01 c0                	add    %eax,%eax
  8009e4:	01 d0                	add    %edx,%eax
  8009e6:	c1 e0 03             	shl    $0x3,%eax
  8009e9:	01 c8                	add    %ecx,%eax
  8009eb:	8b 00                	mov    (%eax),%eax
  8009ed:	89 45 dc             	mov    %eax,-0x24(%ebp)
  8009f0:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8009f3:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8009f8:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  8009fa:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8009fd:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  800a04:	8b 45 08             	mov    0x8(%ebp),%eax
  800a07:	01 c8                	add    %ecx,%eax
  800a09:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  800a0b:	39 c2                	cmp    %eax,%edx
  800a0d:	75 09                	jne    800a18 <CheckWSWithoutLastIndex+0xcf>
						== expectedPages[e]) {
					found = 1;
  800a0f:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  800a16:	eb 12                	jmp    800a2a <CheckWSWithoutLastIndex+0xe1>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800a18:	ff 45 e8             	incl   -0x18(%ebp)
  800a1b:	a1 24 50 80 00       	mov    0x805024,%eax
  800a20:	8b 50 74             	mov    0x74(%eax),%edx
  800a23:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800a26:	39 c2                	cmp    %eax,%edx
  800a28:	77 88                	ja     8009b2 <CheckWSWithoutLastIndex+0x69>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  800a2a:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  800a2e:	75 14                	jne    800a44 <CheckWSWithoutLastIndex+0xfb>
			panic(
  800a30:	83 ec 04             	sub    $0x4,%esp
  800a33:	68 4c 3c 80 00       	push   $0x803c4c
  800a38:	6a 3a                	push   $0x3a
  800a3a:	68 40 3c 80 00       	push   $0x803c40
  800a3f:	e8 93 fe ff ff       	call   8008d7 <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  800a44:	ff 45 f0             	incl   -0x10(%ebp)
  800a47:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800a4a:	3b 45 0c             	cmp    0xc(%ebp),%eax
  800a4d:	0f 8c 32 ff ff ff    	jl     800985 <CheckWSWithoutLastIndex+0x3c>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  800a53:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800a5a:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  800a61:	eb 26                	jmp    800a89 <CheckWSWithoutLastIndex+0x140>
		if (myEnv->__uptr_pws[w].empty == 1) {
  800a63:	a1 24 50 80 00       	mov    0x805024,%eax
  800a68:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  800a6e:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800a71:	89 d0                	mov    %edx,%eax
  800a73:	01 c0                	add    %eax,%eax
  800a75:	01 d0                	add    %edx,%eax
  800a77:	c1 e0 03             	shl    $0x3,%eax
  800a7a:	01 c8                	add    %ecx,%eax
  800a7c:	8a 40 04             	mov    0x4(%eax),%al
  800a7f:	3c 01                	cmp    $0x1,%al
  800a81:	75 03                	jne    800a86 <CheckWSWithoutLastIndex+0x13d>
			actualNumOfEmptyLocs++;
  800a83:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800a86:	ff 45 e0             	incl   -0x20(%ebp)
  800a89:	a1 24 50 80 00       	mov    0x805024,%eax
  800a8e:	8b 50 74             	mov    0x74(%eax),%edx
  800a91:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800a94:	39 c2                	cmp    %eax,%edx
  800a96:	77 cb                	ja     800a63 <CheckWSWithoutLastIndex+0x11a>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  800a98:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800a9b:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  800a9e:	74 14                	je     800ab4 <CheckWSWithoutLastIndex+0x16b>
		panic(
  800aa0:	83 ec 04             	sub    $0x4,%esp
  800aa3:	68 a0 3c 80 00       	push   $0x803ca0
  800aa8:	6a 44                	push   $0x44
  800aaa:	68 40 3c 80 00       	push   $0x803c40
  800aaf:	e8 23 fe ff ff       	call   8008d7 <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  800ab4:	90                   	nop
  800ab5:	c9                   	leave  
  800ab6:	c3                   	ret    

00800ab7 <putch>:
};

//2017:
uint8 printProgName = 0;

static void putch(int ch, struct printbuf *b) {
  800ab7:	55                   	push   %ebp
  800ab8:	89 e5                	mov    %esp,%ebp
  800aba:	83 ec 08             	sub    $0x8,%esp
	b->buf[b->idx++] = ch;
  800abd:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ac0:	8b 00                	mov    (%eax),%eax
  800ac2:	8d 48 01             	lea    0x1(%eax),%ecx
  800ac5:	8b 55 0c             	mov    0xc(%ebp),%edx
  800ac8:	89 0a                	mov    %ecx,(%edx)
  800aca:	8b 55 08             	mov    0x8(%ebp),%edx
  800acd:	88 d1                	mov    %dl,%cl
  800acf:	8b 55 0c             	mov    0xc(%ebp),%edx
  800ad2:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  800ad6:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ad9:	8b 00                	mov    (%eax),%eax
  800adb:	3d ff 00 00 00       	cmp    $0xff,%eax
  800ae0:	75 2c                	jne    800b0e <putch+0x57>
		sys_cputs(b->buf, b->idx, printProgName);
  800ae2:	a0 28 50 80 00       	mov    0x805028,%al
  800ae7:	0f b6 c0             	movzbl %al,%eax
  800aea:	8b 55 0c             	mov    0xc(%ebp),%edx
  800aed:	8b 12                	mov    (%edx),%edx
  800aef:	89 d1                	mov    %edx,%ecx
  800af1:	8b 55 0c             	mov    0xc(%ebp),%edx
  800af4:	83 c2 08             	add    $0x8,%edx
  800af7:	83 ec 04             	sub    $0x4,%esp
  800afa:	50                   	push   %eax
  800afb:	51                   	push   %ecx
  800afc:	52                   	push   %edx
  800afd:	e8 6c 15 00 00       	call   80206e <sys_cputs>
  800b02:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  800b05:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b08:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  800b0e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b11:	8b 40 04             	mov    0x4(%eax),%eax
  800b14:	8d 50 01             	lea    0x1(%eax),%edx
  800b17:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b1a:	89 50 04             	mov    %edx,0x4(%eax)
}
  800b1d:	90                   	nop
  800b1e:	c9                   	leave  
  800b1f:	c3                   	ret    

00800b20 <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  800b20:	55                   	push   %ebp
  800b21:	89 e5                	mov    %esp,%ebp
  800b23:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  800b29:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800b30:	00 00 00 
	b.cnt = 0;
  800b33:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800b3a:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  800b3d:	ff 75 0c             	pushl  0xc(%ebp)
  800b40:	ff 75 08             	pushl  0x8(%ebp)
  800b43:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800b49:	50                   	push   %eax
  800b4a:	68 b7 0a 80 00       	push   $0x800ab7
  800b4f:	e8 11 02 00 00       	call   800d65 <vprintfmt>
  800b54:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName);
  800b57:	a0 28 50 80 00       	mov    0x805028,%al
  800b5c:	0f b6 c0             	movzbl %al,%eax
  800b5f:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  800b65:	83 ec 04             	sub    $0x4,%esp
  800b68:	50                   	push   %eax
  800b69:	52                   	push   %edx
  800b6a:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800b70:	83 c0 08             	add    $0x8,%eax
  800b73:	50                   	push   %eax
  800b74:	e8 f5 14 00 00       	call   80206e <sys_cputs>
  800b79:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  800b7c:	c6 05 28 50 80 00 00 	movb   $0x0,0x805028
	return b.cnt;
  800b83:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  800b89:	c9                   	leave  
  800b8a:	c3                   	ret    

00800b8b <cprintf>:

int cprintf(const char *fmt, ...) {
  800b8b:	55                   	push   %ebp
  800b8c:	89 e5                	mov    %esp,%ebp
  800b8e:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  800b91:	c6 05 28 50 80 00 01 	movb   $0x1,0x805028
	va_start(ap, fmt);
  800b98:	8d 45 0c             	lea    0xc(%ebp),%eax
  800b9b:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800b9e:	8b 45 08             	mov    0x8(%ebp),%eax
  800ba1:	83 ec 08             	sub    $0x8,%esp
  800ba4:	ff 75 f4             	pushl  -0xc(%ebp)
  800ba7:	50                   	push   %eax
  800ba8:	e8 73 ff ff ff       	call   800b20 <vcprintf>
  800bad:	83 c4 10             	add    $0x10,%esp
  800bb0:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  800bb3:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800bb6:	c9                   	leave  
  800bb7:	c3                   	ret    

00800bb8 <atomic_cprintf>:

int atomic_cprintf(const char *fmt, ...) {
  800bb8:	55                   	push   %ebp
  800bb9:	89 e5                	mov    %esp,%ebp
  800bbb:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  800bbe:	e8 59 16 00 00       	call   80221c <sys_disable_interrupt>
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  800bc3:	8d 45 0c             	lea    0xc(%ebp),%eax
  800bc6:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800bc9:	8b 45 08             	mov    0x8(%ebp),%eax
  800bcc:	83 ec 08             	sub    $0x8,%esp
  800bcf:	ff 75 f4             	pushl  -0xc(%ebp)
  800bd2:	50                   	push   %eax
  800bd3:	e8 48 ff ff ff       	call   800b20 <vcprintf>
  800bd8:	83 c4 10             	add    $0x10,%esp
  800bdb:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	sys_enable_interrupt();
  800bde:	e8 53 16 00 00       	call   802236 <sys_enable_interrupt>
	return cnt;
  800be3:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800be6:	c9                   	leave  
  800be7:	c3                   	ret    

00800be8 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800be8:	55                   	push   %ebp
  800be9:	89 e5                	mov    %esp,%ebp
  800beb:	53                   	push   %ebx
  800bec:	83 ec 14             	sub    $0x14,%esp
  800bef:	8b 45 10             	mov    0x10(%ebp),%eax
  800bf2:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800bf5:	8b 45 14             	mov    0x14(%ebp),%eax
  800bf8:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800bfb:	8b 45 18             	mov    0x18(%ebp),%eax
  800bfe:	ba 00 00 00 00       	mov    $0x0,%edx
  800c03:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800c06:	77 55                	ja     800c5d <printnum+0x75>
  800c08:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800c0b:	72 05                	jb     800c12 <printnum+0x2a>
  800c0d:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800c10:	77 4b                	ja     800c5d <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800c12:	8b 45 1c             	mov    0x1c(%ebp),%eax
  800c15:	8d 58 ff             	lea    -0x1(%eax),%ebx
  800c18:	8b 45 18             	mov    0x18(%ebp),%eax
  800c1b:	ba 00 00 00 00       	mov    $0x0,%edx
  800c20:	52                   	push   %edx
  800c21:	50                   	push   %eax
  800c22:	ff 75 f4             	pushl  -0xc(%ebp)
  800c25:	ff 75 f0             	pushl  -0x10(%ebp)
  800c28:	e8 8b 2a 00 00       	call   8036b8 <__udivdi3>
  800c2d:	83 c4 10             	add    $0x10,%esp
  800c30:	83 ec 04             	sub    $0x4,%esp
  800c33:	ff 75 20             	pushl  0x20(%ebp)
  800c36:	53                   	push   %ebx
  800c37:	ff 75 18             	pushl  0x18(%ebp)
  800c3a:	52                   	push   %edx
  800c3b:	50                   	push   %eax
  800c3c:	ff 75 0c             	pushl  0xc(%ebp)
  800c3f:	ff 75 08             	pushl  0x8(%ebp)
  800c42:	e8 a1 ff ff ff       	call   800be8 <printnum>
  800c47:	83 c4 20             	add    $0x20,%esp
  800c4a:	eb 1a                	jmp    800c66 <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800c4c:	83 ec 08             	sub    $0x8,%esp
  800c4f:	ff 75 0c             	pushl  0xc(%ebp)
  800c52:	ff 75 20             	pushl  0x20(%ebp)
  800c55:	8b 45 08             	mov    0x8(%ebp),%eax
  800c58:	ff d0                	call   *%eax
  800c5a:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800c5d:	ff 4d 1c             	decl   0x1c(%ebp)
  800c60:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  800c64:	7f e6                	jg     800c4c <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800c66:	8b 4d 18             	mov    0x18(%ebp),%ecx
  800c69:	bb 00 00 00 00       	mov    $0x0,%ebx
  800c6e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800c71:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800c74:	53                   	push   %ebx
  800c75:	51                   	push   %ecx
  800c76:	52                   	push   %edx
  800c77:	50                   	push   %eax
  800c78:	e8 4b 2b 00 00       	call   8037c8 <__umoddi3>
  800c7d:	83 c4 10             	add    $0x10,%esp
  800c80:	05 14 3f 80 00       	add    $0x803f14,%eax
  800c85:	8a 00                	mov    (%eax),%al
  800c87:	0f be c0             	movsbl %al,%eax
  800c8a:	83 ec 08             	sub    $0x8,%esp
  800c8d:	ff 75 0c             	pushl  0xc(%ebp)
  800c90:	50                   	push   %eax
  800c91:	8b 45 08             	mov    0x8(%ebp),%eax
  800c94:	ff d0                	call   *%eax
  800c96:	83 c4 10             	add    $0x10,%esp
}
  800c99:	90                   	nop
  800c9a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800c9d:	c9                   	leave  
  800c9e:	c3                   	ret    

00800c9f <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  800c9f:	55                   	push   %ebp
  800ca0:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800ca2:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800ca6:	7e 1c                	jle    800cc4 <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  800ca8:	8b 45 08             	mov    0x8(%ebp),%eax
  800cab:	8b 00                	mov    (%eax),%eax
  800cad:	8d 50 08             	lea    0x8(%eax),%edx
  800cb0:	8b 45 08             	mov    0x8(%ebp),%eax
  800cb3:	89 10                	mov    %edx,(%eax)
  800cb5:	8b 45 08             	mov    0x8(%ebp),%eax
  800cb8:	8b 00                	mov    (%eax),%eax
  800cba:	83 e8 08             	sub    $0x8,%eax
  800cbd:	8b 50 04             	mov    0x4(%eax),%edx
  800cc0:	8b 00                	mov    (%eax),%eax
  800cc2:	eb 40                	jmp    800d04 <getuint+0x65>
	else if (lflag)
  800cc4:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800cc8:	74 1e                	je     800ce8 <getuint+0x49>
		return va_arg(*ap, unsigned long);
  800cca:	8b 45 08             	mov    0x8(%ebp),%eax
  800ccd:	8b 00                	mov    (%eax),%eax
  800ccf:	8d 50 04             	lea    0x4(%eax),%edx
  800cd2:	8b 45 08             	mov    0x8(%ebp),%eax
  800cd5:	89 10                	mov    %edx,(%eax)
  800cd7:	8b 45 08             	mov    0x8(%ebp),%eax
  800cda:	8b 00                	mov    (%eax),%eax
  800cdc:	83 e8 04             	sub    $0x4,%eax
  800cdf:	8b 00                	mov    (%eax),%eax
  800ce1:	ba 00 00 00 00       	mov    $0x0,%edx
  800ce6:	eb 1c                	jmp    800d04 <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  800ce8:	8b 45 08             	mov    0x8(%ebp),%eax
  800ceb:	8b 00                	mov    (%eax),%eax
  800ced:	8d 50 04             	lea    0x4(%eax),%edx
  800cf0:	8b 45 08             	mov    0x8(%ebp),%eax
  800cf3:	89 10                	mov    %edx,(%eax)
  800cf5:	8b 45 08             	mov    0x8(%ebp),%eax
  800cf8:	8b 00                	mov    (%eax),%eax
  800cfa:	83 e8 04             	sub    $0x4,%eax
  800cfd:	8b 00                	mov    (%eax),%eax
  800cff:	ba 00 00 00 00       	mov    $0x0,%edx
}
  800d04:	5d                   	pop    %ebp
  800d05:	c3                   	ret    

00800d06 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  800d06:	55                   	push   %ebp
  800d07:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800d09:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800d0d:	7e 1c                	jle    800d2b <getint+0x25>
		return va_arg(*ap, long long);
  800d0f:	8b 45 08             	mov    0x8(%ebp),%eax
  800d12:	8b 00                	mov    (%eax),%eax
  800d14:	8d 50 08             	lea    0x8(%eax),%edx
  800d17:	8b 45 08             	mov    0x8(%ebp),%eax
  800d1a:	89 10                	mov    %edx,(%eax)
  800d1c:	8b 45 08             	mov    0x8(%ebp),%eax
  800d1f:	8b 00                	mov    (%eax),%eax
  800d21:	83 e8 08             	sub    $0x8,%eax
  800d24:	8b 50 04             	mov    0x4(%eax),%edx
  800d27:	8b 00                	mov    (%eax),%eax
  800d29:	eb 38                	jmp    800d63 <getint+0x5d>
	else if (lflag)
  800d2b:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800d2f:	74 1a                	je     800d4b <getint+0x45>
		return va_arg(*ap, long);
  800d31:	8b 45 08             	mov    0x8(%ebp),%eax
  800d34:	8b 00                	mov    (%eax),%eax
  800d36:	8d 50 04             	lea    0x4(%eax),%edx
  800d39:	8b 45 08             	mov    0x8(%ebp),%eax
  800d3c:	89 10                	mov    %edx,(%eax)
  800d3e:	8b 45 08             	mov    0x8(%ebp),%eax
  800d41:	8b 00                	mov    (%eax),%eax
  800d43:	83 e8 04             	sub    $0x4,%eax
  800d46:	8b 00                	mov    (%eax),%eax
  800d48:	99                   	cltd   
  800d49:	eb 18                	jmp    800d63 <getint+0x5d>
	else
		return va_arg(*ap, int);
  800d4b:	8b 45 08             	mov    0x8(%ebp),%eax
  800d4e:	8b 00                	mov    (%eax),%eax
  800d50:	8d 50 04             	lea    0x4(%eax),%edx
  800d53:	8b 45 08             	mov    0x8(%ebp),%eax
  800d56:	89 10                	mov    %edx,(%eax)
  800d58:	8b 45 08             	mov    0x8(%ebp),%eax
  800d5b:	8b 00                	mov    (%eax),%eax
  800d5d:	83 e8 04             	sub    $0x4,%eax
  800d60:	8b 00                	mov    (%eax),%eax
  800d62:	99                   	cltd   
}
  800d63:	5d                   	pop    %ebp
  800d64:	c3                   	ret    

00800d65 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  800d65:	55                   	push   %ebp
  800d66:	89 e5                	mov    %esp,%ebp
  800d68:	56                   	push   %esi
  800d69:	53                   	push   %ebx
  800d6a:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800d6d:	eb 17                	jmp    800d86 <vprintfmt+0x21>
			if (ch == '\0')
  800d6f:	85 db                	test   %ebx,%ebx
  800d71:	0f 84 af 03 00 00    	je     801126 <vprintfmt+0x3c1>
				return;
			putch(ch, putdat);
  800d77:	83 ec 08             	sub    $0x8,%esp
  800d7a:	ff 75 0c             	pushl  0xc(%ebp)
  800d7d:	53                   	push   %ebx
  800d7e:	8b 45 08             	mov    0x8(%ebp),%eax
  800d81:	ff d0                	call   *%eax
  800d83:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800d86:	8b 45 10             	mov    0x10(%ebp),%eax
  800d89:	8d 50 01             	lea    0x1(%eax),%edx
  800d8c:	89 55 10             	mov    %edx,0x10(%ebp)
  800d8f:	8a 00                	mov    (%eax),%al
  800d91:	0f b6 d8             	movzbl %al,%ebx
  800d94:	83 fb 25             	cmp    $0x25,%ebx
  800d97:	75 d6                	jne    800d6f <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  800d99:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  800d9d:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  800da4:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  800dab:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  800db2:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800db9:	8b 45 10             	mov    0x10(%ebp),%eax
  800dbc:	8d 50 01             	lea    0x1(%eax),%edx
  800dbf:	89 55 10             	mov    %edx,0x10(%ebp)
  800dc2:	8a 00                	mov    (%eax),%al
  800dc4:	0f b6 d8             	movzbl %al,%ebx
  800dc7:	8d 43 dd             	lea    -0x23(%ebx),%eax
  800dca:	83 f8 55             	cmp    $0x55,%eax
  800dcd:	0f 87 2b 03 00 00    	ja     8010fe <vprintfmt+0x399>
  800dd3:	8b 04 85 38 3f 80 00 	mov    0x803f38(,%eax,4),%eax
  800dda:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  800ddc:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  800de0:	eb d7                	jmp    800db9 <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800de2:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  800de6:	eb d1                	jmp    800db9 <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800de8:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  800def:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800df2:	89 d0                	mov    %edx,%eax
  800df4:	c1 e0 02             	shl    $0x2,%eax
  800df7:	01 d0                	add    %edx,%eax
  800df9:	01 c0                	add    %eax,%eax
  800dfb:	01 d8                	add    %ebx,%eax
  800dfd:	83 e8 30             	sub    $0x30,%eax
  800e00:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  800e03:	8b 45 10             	mov    0x10(%ebp),%eax
  800e06:	8a 00                	mov    (%eax),%al
  800e08:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  800e0b:	83 fb 2f             	cmp    $0x2f,%ebx
  800e0e:	7e 3e                	jle    800e4e <vprintfmt+0xe9>
  800e10:	83 fb 39             	cmp    $0x39,%ebx
  800e13:	7f 39                	jg     800e4e <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800e15:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800e18:	eb d5                	jmp    800def <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  800e1a:	8b 45 14             	mov    0x14(%ebp),%eax
  800e1d:	83 c0 04             	add    $0x4,%eax
  800e20:	89 45 14             	mov    %eax,0x14(%ebp)
  800e23:	8b 45 14             	mov    0x14(%ebp),%eax
  800e26:	83 e8 04             	sub    $0x4,%eax
  800e29:	8b 00                	mov    (%eax),%eax
  800e2b:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  800e2e:	eb 1f                	jmp    800e4f <vprintfmt+0xea>

		case '.':
			if (width < 0)
  800e30:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800e34:	79 83                	jns    800db9 <vprintfmt+0x54>
				width = 0;
  800e36:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  800e3d:	e9 77 ff ff ff       	jmp    800db9 <vprintfmt+0x54>

		case '#':
			altflag = 1;
  800e42:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  800e49:	e9 6b ff ff ff       	jmp    800db9 <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  800e4e:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  800e4f:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800e53:	0f 89 60 ff ff ff    	jns    800db9 <vprintfmt+0x54>
				width = precision, precision = -1;
  800e59:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800e5c:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800e5f:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  800e66:	e9 4e ff ff ff       	jmp    800db9 <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  800e6b:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  800e6e:	e9 46 ff ff ff       	jmp    800db9 <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  800e73:	8b 45 14             	mov    0x14(%ebp),%eax
  800e76:	83 c0 04             	add    $0x4,%eax
  800e79:	89 45 14             	mov    %eax,0x14(%ebp)
  800e7c:	8b 45 14             	mov    0x14(%ebp),%eax
  800e7f:	83 e8 04             	sub    $0x4,%eax
  800e82:	8b 00                	mov    (%eax),%eax
  800e84:	83 ec 08             	sub    $0x8,%esp
  800e87:	ff 75 0c             	pushl  0xc(%ebp)
  800e8a:	50                   	push   %eax
  800e8b:	8b 45 08             	mov    0x8(%ebp),%eax
  800e8e:	ff d0                	call   *%eax
  800e90:	83 c4 10             	add    $0x10,%esp
			break;
  800e93:	e9 89 02 00 00       	jmp    801121 <vprintfmt+0x3bc>

		// error message
		case 'e':
			err = va_arg(ap, int);
  800e98:	8b 45 14             	mov    0x14(%ebp),%eax
  800e9b:	83 c0 04             	add    $0x4,%eax
  800e9e:	89 45 14             	mov    %eax,0x14(%ebp)
  800ea1:	8b 45 14             	mov    0x14(%ebp),%eax
  800ea4:	83 e8 04             	sub    $0x4,%eax
  800ea7:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  800ea9:	85 db                	test   %ebx,%ebx
  800eab:	79 02                	jns    800eaf <vprintfmt+0x14a>
				err = -err;
  800ead:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  800eaf:	83 fb 64             	cmp    $0x64,%ebx
  800eb2:	7f 0b                	jg     800ebf <vprintfmt+0x15a>
  800eb4:	8b 34 9d 80 3d 80 00 	mov    0x803d80(,%ebx,4),%esi
  800ebb:	85 f6                	test   %esi,%esi
  800ebd:	75 19                	jne    800ed8 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  800ebf:	53                   	push   %ebx
  800ec0:	68 25 3f 80 00       	push   $0x803f25
  800ec5:	ff 75 0c             	pushl  0xc(%ebp)
  800ec8:	ff 75 08             	pushl  0x8(%ebp)
  800ecb:	e8 5e 02 00 00       	call   80112e <printfmt>
  800ed0:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800ed3:	e9 49 02 00 00       	jmp    801121 <vprintfmt+0x3bc>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800ed8:	56                   	push   %esi
  800ed9:	68 2e 3f 80 00       	push   $0x803f2e
  800ede:	ff 75 0c             	pushl  0xc(%ebp)
  800ee1:	ff 75 08             	pushl  0x8(%ebp)
  800ee4:	e8 45 02 00 00       	call   80112e <printfmt>
  800ee9:	83 c4 10             	add    $0x10,%esp
			break;
  800eec:	e9 30 02 00 00       	jmp    801121 <vprintfmt+0x3bc>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  800ef1:	8b 45 14             	mov    0x14(%ebp),%eax
  800ef4:	83 c0 04             	add    $0x4,%eax
  800ef7:	89 45 14             	mov    %eax,0x14(%ebp)
  800efa:	8b 45 14             	mov    0x14(%ebp),%eax
  800efd:	83 e8 04             	sub    $0x4,%eax
  800f00:	8b 30                	mov    (%eax),%esi
  800f02:	85 f6                	test   %esi,%esi
  800f04:	75 05                	jne    800f0b <vprintfmt+0x1a6>
				p = "(null)";
  800f06:	be 31 3f 80 00       	mov    $0x803f31,%esi
			if (width > 0 && padc != '-')
  800f0b:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800f0f:	7e 6d                	jle    800f7e <vprintfmt+0x219>
  800f11:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  800f15:	74 67                	je     800f7e <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  800f17:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800f1a:	83 ec 08             	sub    $0x8,%esp
  800f1d:	50                   	push   %eax
  800f1e:	56                   	push   %esi
  800f1f:	e8 12 05 00 00       	call   801436 <strnlen>
  800f24:	83 c4 10             	add    $0x10,%esp
  800f27:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  800f2a:	eb 16                	jmp    800f42 <vprintfmt+0x1dd>
					putch(padc, putdat);
  800f2c:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  800f30:	83 ec 08             	sub    $0x8,%esp
  800f33:	ff 75 0c             	pushl  0xc(%ebp)
  800f36:	50                   	push   %eax
  800f37:	8b 45 08             	mov    0x8(%ebp),%eax
  800f3a:	ff d0                	call   *%eax
  800f3c:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800f3f:	ff 4d e4             	decl   -0x1c(%ebp)
  800f42:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800f46:	7f e4                	jg     800f2c <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800f48:	eb 34                	jmp    800f7e <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  800f4a:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800f4e:	74 1c                	je     800f6c <vprintfmt+0x207>
  800f50:	83 fb 1f             	cmp    $0x1f,%ebx
  800f53:	7e 05                	jle    800f5a <vprintfmt+0x1f5>
  800f55:	83 fb 7e             	cmp    $0x7e,%ebx
  800f58:	7e 12                	jle    800f6c <vprintfmt+0x207>
					putch('?', putdat);
  800f5a:	83 ec 08             	sub    $0x8,%esp
  800f5d:	ff 75 0c             	pushl  0xc(%ebp)
  800f60:	6a 3f                	push   $0x3f
  800f62:	8b 45 08             	mov    0x8(%ebp),%eax
  800f65:	ff d0                	call   *%eax
  800f67:	83 c4 10             	add    $0x10,%esp
  800f6a:	eb 0f                	jmp    800f7b <vprintfmt+0x216>
				else
					putch(ch, putdat);
  800f6c:	83 ec 08             	sub    $0x8,%esp
  800f6f:	ff 75 0c             	pushl  0xc(%ebp)
  800f72:	53                   	push   %ebx
  800f73:	8b 45 08             	mov    0x8(%ebp),%eax
  800f76:	ff d0                	call   *%eax
  800f78:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800f7b:	ff 4d e4             	decl   -0x1c(%ebp)
  800f7e:	89 f0                	mov    %esi,%eax
  800f80:	8d 70 01             	lea    0x1(%eax),%esi
  800f83:	8a 00                	mov    (%eax),%al
  800f85:	0f be d8             	movsbl %al,%ebx
  800f88:	85 db                	test   %ebx,%ebx
  800f8a:	74 24                	je     800fb0 <vprintfmt+0x24b>
  800f8c:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800f90:	78 b8                	js     800f4a <vprintfmt+0x1e5>
  800f92:	ff 4d e0             	decl   -0x20(%ebp)
  800f95:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800f99:	79 af                	jns    800f4a <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800f9b:	eb 13                	jmp    800fb0 <vprintfmt+0x24b>
				putch(' ', putdat);
  800f9d:	83 ec 08             	sub    $0x8,%esp
  800fa0:	ff 75 0c             	pushl  0xc(%ebp)
  800fa3:	6a 20                	push   $0x20
  800fa5:	8b 45 08             	mov    0x8(%ebp),%eax
  800fa8:	ff d0                	call   *%eax
  800faa:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800fad:	ff 4d e4             	decl   -0x1c(%ebp)
  800fb0:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800fb4:	7f e7                	jg     800f9d <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  800fb6:	e9 66 01 00 00       	jmp    801121 <vprintfmt+0x3bc>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  800fbb:	83 ec 08             	sub    $0x8,%esp
  800fbe:	ff 75 e8             	pushl  -0x18(%ebp)
  800fc1:	8d 45 14             	lea    0x14(%ebp),%eax
  800fc4:	50                   	push   %eax
  800fc5:	e8 3c fd ff ff       	call   800d06 <getint>
  800fca:	83 c4 10             	add    $0x10,%esp
  800fcd:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800fd0:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  800fd3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800fd6:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800fd9:	85 d2                	test   %edx,%edx
  800fdb:	79 23                	jns    801000 <vprintfmt+0x29b>
				putch('-', putdat);
  800fdd:	83 ec 08             	sub    $0x8,%esp
  800fe0:	ff 75 0c             	pushl  0xc(%ebp)
  800fe3:	6a 2d                	push   $0x2d
  800fe5:	8b 45 08             	mov    0x8(%ebp),%eax
  800fe8:	ff d0                	call   *%eax
  800fea:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  800fed:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800ff0:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800ff3:	f7 d8                	neg    %eax
  800ff5:	83 d2 00             	adc    $0x0,%edx
  800ff8:	f7 da                	neg    %edx
  800ffa:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800ffd:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  801000:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  801007:	e9 bc 00 00 00       	jmp    8010c8 <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  80100c:	83 ec 08             	sub    $0x8,%esp
  80100f:	ff 75 e8             	pushl  -0x18(%ebp)
  801012:	8d 45 14             	lea    0x14(%ebp),%eax
  801015:	50                   	push   %eax
  801016:	e8 84 fc ff ff       	call   800c9f <getuint>
  80101b:	83 c4 10             	add    $0x10,%esp
  80101e:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801021:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  801024:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  80102b:	e9 98 00 00 00       	jmp    8010c8 <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  801030:	83 ec 08             	sub    $0x8,%esp
  801033:	ff 75 0c             	pushl  0xc(%ebp)
  801036:	6a 58                	push   $0x58
  801038:	8b 45 08             	mov    0x8(%ebp),%eax
  80103b:	ff d0                	call   *%eax
  80103d:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  801040:	83 ec 08             	sub    $0x8,%esp
  801043:	ff 75 0c             	pushl  0xc(%ebp)
  801046:	6a 58                	push   $0x58
  801048:	8b 45 08             	mov    0x8(%ebp),%eax
  80104b:	ff d0                	call   *%eax
  80104d:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  801050:	83 ec 08             	sub    $0x8,%esp
  801053:	ff 75 0c             	pushl  0xc(%ebp)
  801056:	6a 58                	push   $0x58
  801058:	8b 45 08             	mov    0x8(%ebp),%eax
  80105b:	ff d0                	call   *%eax
  80105d:	83 c4 10             	add    $0x10,%esp
			break;
  801060:	e9 bc 00 00 00       	jmp    801121 <vprintfmt+0x3bc>

		// pointer
		case 'p':
			putch('0', putdat);
  801065:	83 ec 08             	sub    $0x8,%esp
  801068:	ff 75 0c             	pushl  0xc(%ebp)
  80106b:	6a 30                	push   $0x30
  80106d:	8b 45 08             	mov    0x8(%ebp),%eax
  801070:	ff d0                	call   *%eax
  801072:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  801075:	83 ec 08             	sub    $0x8,%esp
  801078:	ff 75 0c             	pushl  0xc(%ebp)
  80107b:	6a 78                	push   $0x78
  80107d:	8b 45 08             	mov    0x8(%ebp),%eax
  801080:	ff d0                	call   *%eax
  801082:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  801085:	8b 45 14             	mov    0x14(%ebp),%eax
  801088:	83 c0 04             	add    $0x4,%eax
  80108b:	89 45 14             	mov    %eax,0x14(%ebp)
  80108e:	8b 45 14             	mov    0x14(%ebp),%eax
  801091:	83 e8 04             	sub    $0x4,%eax
  801094:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  801096:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801099:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  8010a0:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  8010a7:	eb 1f                	jmp    8010c8 <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  8010a9:	83 ec 08             	sub    $0x8,%esp
  8010ac:	ff 75 e8             	pushl  -0x18(%ebp)
  8010af:	8d 45 14             	lea    0x14(%ebp),%eax
  8010b2:	50                   	push   %eax
  8010b3:	e8 e7 fb ff ff       	call   800c9f <getuint>
  8010b8:	83 c4 10             	add    $0x10,%esp
  8010bb:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8010be:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  8010c1:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  8010c8:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  8010cc:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8010cf:	83 ec 04             	sub    $0x4,%esp
  8010d2:	52                   	push   %edx
  8010d3:	ff 75 e4             	pushl  -0x1c(%ebp)
  8010d6:	50                   	push   %eax
  8010d7:	ff 75 f4             	pushl  -0xc(%ebp)
  8010da:	ff 75 f0             	pushl  -0x10(%ebp)
  8010dd:	ff 75 0c             	pushl  0xc(%ebp)
  8010e0:	ff 75 08             	pushl  0x8(%ebp)
  8010e3:	e8 00 fb ff ff       	call   800be8 <printnum>
  8010e8:	83 c4 20             	add    $0x20,%esp
			break;
  8010eb:	eb 34                	jmp    801121 <vprintfmt+0x3bc>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  8010ed:	83 ec 08             	sub    $0x8,%esp
  8010f0:	ff 75 0c             	pushl  0xc(%ebp)
  8010f3:	53                   	push   %ebx
  8010f4:	8b 45 08             	mov    0x8(%ebp),%eax
  8010f7:	ff d0                	call   *%eax
  8010f9:	83 c4 10             	add    $0x10,%esp
			break;
  8010fc:	eb 23                	jmp    801121 <vprintfmt+0x3bc>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  8010fe:	83 ec 08             	sub    $0x8,%esp
  801101:	ff 75 0c             	pushl  0xc(%ebp)
  801104:	6a 25                	push   $0x25
  801106:	8b 45 08             	mov    0x8(%ebp),%eax
  801109:	ff d0                	call   *%eax
  80110b:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  80110e:	ff 4d 10             	decl   0x10(%ebp)
  801111:	eb 03                	jmp    801116 <vprintfmt+0x3b1>
  801113:	ff 4d 10             	decl   0x10(%ebp)
  801116:	8b 45 10             	mov    0x10(%ebp),%eax
  801119:	48                   	dec    %eax
  80111a:	8a 00                	mov    (%eax),%al
  80111c:	3c 25                	cmp    $0x25,%al
  80111e:	75 f3                	jne    801113 <vprintfmt+0x3ae>
				/* do nothing */;
			break;
  801120:	90                   	nop
		}
	}
  801121:	e9 47 fc ff ff       	jmp    800d6d <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  801126:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  801127:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80112a:	5b                   	pop    %ebx
  80112b:	5e                   	pop    %esi
  80112c:	5d                   	pop    %ebp
  80112d:	c3                   	ret    

0080112e <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  80112e:	55                   	push   %ebp
  80112f:	89 e5                	mov    %esp,%ebp
  801131:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  801134:	8d 45 10             	lea    0x10(%ebp),%eax
  801137:	83 c0 04             	add    $0x4,%eax
  80113a:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  80113d:	8b 45 10             	mov    0x10(%ebp),%eax
  801140:	ff 75 f4             	pushl  -0xc(%ebp)
  801143:	50                   	push   %eax
  801144:	ff 75 0c             	pushl  0xc(%ebp)
  801147:	ff 75 08             	pushl  0x8(%ebp)
  80114a:	e8 16 fc ff ff       	call   800d65 <vprintfmt>
  80114f:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  801152:	90                   	nop
  801153:	c9                   	leave  
  801154:	c3                   	ret    

00801155 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  801155:	55                   	push   %ebp
  801156:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  801158:	8b 45 0c             	mov    0xc(%ebp),%eax
  80115b:	8b 40 08             	mov    0x8(%eax),%eax
  80115e:	8d 50 01             	lea    0x1(%eax),%edx
  801161:	8b 45 0c             	mov    0xc(%ebp),%eax
  801164:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  801167:	8b 45 0c             	mov    0xc(%ebp),%eax
  80116a:	8b 10                	mov    (%eax),%edx
  80116c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80116f:	8b 40 04             	mov    0x4(%eax),%eax
  801172:	39 c2                	cmp    %eax,%edx
  801174:	73 12                	jae    801188 <sprintputch+0x33>
		*b->buf++ = ch;
  801176:	8b 45 0c             	mov    0xc(%ebp),%eax
  801179:	8b 00                	mov    (%eax),%eax
  80117b:	8d 48 01             	lea    0x1(%eax),%ecx
  80117e:	8b 55 0c             	mov    0xc(%ebp),%edx
  801181:	89 0a                	mov    %ecx,(%edx)
  801183:	8b 55 08             	mov    0x8(%ebp),%edx
  801186:	88 10                	mov    %dl,(%eax)
}
  801188:	90                   	nop
  801189:	5d                   	pop    %ebp
  80118a:	c3                   	ret    

0080118b <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  80118b:	55                   	push   %ebp
  80118c:	89 e5                	mov    %esp,%ebp
  80118e:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  801191:	8b 45 08             	mov    0x8(%ebp),%eax
  801194:	89 45 ec             	mov    %eax,-0x14(%ebp)
  801197:	8b 45 0c             	mov    0xc(%ebp),%eax
  80119a:	8d 50 ff             	lea    -0x1(%eax),%edx
  80119d:	8b 45 08             	mov    0x8(%ebp),%eax
  8011a0:	01 d0                	add    %edx,%eax
  8011a2:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8011a5:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  8011ac:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8011b0:	74 06                	je     8011b8 <vsnprintf+0x2d>
  8011b2:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8011b6:	7f 07                	jg     8011bf <vsnprintf+0x34>
		return -E_INVAL;
  8011b8:	b8 03 00 00 00       	mov    $0x3,%eax
  8011bd:	eb 20                	jmp    8011df <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  8011bf:	ff 75 14             	pushl  0x14(%ebp)
  8011c2:	ff 75 10             	pushl  0x10(%ebp)
  8011c5:	8d 45 ec             	lea    -0x14(%ebp),%eax
  8011c8:	50                   	push   %eax
  8011c9:	68 55 11 80 00       	push   $0x801155
  8011ce:	e8 92 fb ff ff       	call   800d65 <vprintfmt>
  8011d3:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  8011d6:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8011d9:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  8011dc:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  8011df:	c9                   	leave  
  8011e0:	c3                   	ret    

008011e1 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  8011e1:	55                   	push   %ebp
  8011e2:	89 e5                	mov    %esp,%ebp
  8011e4:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  8011e7:	8d 45 10             	lea    0x10(%ebp),%eax
  8011ea:	83 c0 04             	add    $0x4,%eax
  8011ed:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  8011f0:	8b 45 10             	mov    0x10(%ebp),%eax
  8011f3:	ff 75 f4             	pushl  -0xc(%ebp)
  8011f6:	50                   	push   %eax
  8011f7:	ff 75 0c             	pushl  0xc(%ebp)
  8011fa:	ff 75 08             	pushl  0x8(%ebp)
  8011fd:	e8 89 ff ff ff       	call   80118b <vsnprintf>
  801202:	83 c4 10             	add    $0x10,%esp
  801205:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  801208:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  80120b:	c9                   	leave  
  80120c:	c3                   	ret    

0080120d <readline>:
#include <inc/lib.h>

//static char buf[BUFLEN];

void readline(const char *prompt, char* buf)
{
  80120d:	55                   	push   %ebp
  80120e:	89 e5                	mov    %esp,%ebp
  801210:	83 ec 18             	sub    $0x18,%esp
		int i, c, echoing;

	if (prompt != NULL)
  801213:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801217:	74 13                	je     80122c <readline+0x1f>
		cprintf("%s", prompt);
  801219:	83 ec 08             	sub    $0x8,%esp
  80121c:	ff 75 08             	pushl  0x8(%ebp)
  80121f:	68 90 40 80 00       	push   $0x804090
  801224:	e8 62 f9 ff ff       	call   800b8b <cprintf>
  801229:	83 c4 10             	add    $0x10,%esp

	i = 0;
  80122c:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	echoing = iscons(0);
  801233:	83 ec 0c             	sub    $0xc,%esp
  801236:	6a 00                	push   $0x0
  801238:	e8 54 f5 ff ff       	call   800791 <iscons>
  80123d:	83 c4 10             	add    $0x10,%esp
  801240:	89 45 f0             	mov    %eax,-0x10(%ebp)
	while (1) {
		c = getchar();
  801243:	e8 fb f4 ff ff       	call   800743 <getchar>
  801248:	89 45 ec             	mov    %eax,-0x14(%ebp)
		if (c < 0) {
  80124b:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  80124f:	79 22                	jns    801273 <readline+0x66>
			if (c != -E_EOF)
  801251:	83 7d ec 07          	cmpl   $0x7,-0x14(%ebp)
  801255:	0f 84 ad 00 00 00    	je     801308 <readline+0xfb>
				cprintf("read error: %e\n", c);
  80125b:	83 ec 08             	sub    $0x8,%esp
  80125e:	ff 75 ec             	pushl  -0x14(%ebp)
  801261:	68 93 40 80 00       	push   $0x804093
  801266:	e8 20 f9 ff ff       	call   800b8b <cprintf>
  80126b:	83 c4 10             	add    $0x10,%esp
			return;
  80126e:	e9 95 00 00 00       	jmp    801308 <readline+0xfb>
		} else if (c >= ' ' && i < BUFLEN-1) {
  801273:	83 7d ec 1f          	cmpl   $0x1f,-0x14(%ebp)
  801277:	7e 34                	jle    8012ad <readline+0xa0>
  801279:	81 7d f4 fe 03 00 00 	cmpl   $0x3fe,-0xc(%ebp)
  801280:	7f 2b                	jg     8012ad <readline+0xa0>
			if (echoing)
  801282:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801286:	74 0e                	je     801296 <readline+0x89>
				cputchar(c);
  801288:	83 ec 0c             	sub    $0xc,%esp
  80128b:	ff 75 ec             	pushl  -0x14(%ebp)
  80128e:	e8 68 f4 ff ff       	call   8006fb <cputchar>
  801293:	83 c4 10             	add    $0x10,%esp
			buf[i++] = c;
  801296:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801299:	8d 50 01             	lea    0x1(%eax),%edx
  80129c:	89 55 f4             	mov    %edx,-0xc(%ebp)
  80129f:	89 c2                	mov    %eax,%edx
  8012a1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012a4:	01 d0                	add    %edx,%eax
  8012a6:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8012a9:	88 10                	mov    %dl,(%eax)
  8012ab:	eb 56                	jmp    801303 <readline+0xf6>
		} else if (c == '\b' && i > 0) {
  8012ad:	83 7d ec 08          	cmpl   $0x8,-0x14(%ebp)
  8012b1:	75 1f                	jne    8012d2 <readline+0xc5>
  8012b3:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8012b7:	7e 19                	jle    8012d2 <readline+0xc5>
			if (echoing)
  8012b9:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8012bd:	74 0e                	je     8012cd <readline+0xc0>
				cputchar(c);
  8012bf:	83 ec 0c             	sub    $0xc,%esp
  8012c2:	ff 75 ec             	pushl  -0x14(%ebp)
  8012c5:	e8 31 f4 ff ff       	call   8006fb <cputchar>
  8012ca:	83 c4 10             	add    $0x10,%esp

			i--;
  8012cd:	ff 4d f4             	decl   -0xc(%ebp)
  8012d0:	eb 31                	jmp    801303 <readline+0xf6>
		} else if (c == '\n' || c == '\r') {
  8012d2:	83 7d ec 0a          	cmpl   $0xa,-0x14(%ebp)
  8012d6:	74 0a                	je     8012e2 <readline+0xd5>
  8012d8:	83 7d ec 0d          	cmpl   $0xd,-0x14(%ebp)
  8012dc:	0f 85 61 ff ff ff    	jne    801243 <readline+0x36>
			if (echoing)
  8012e2:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8012e6:	74 0e                	je     8012f6 <readline+0xe9>
				cputchar(c);
  8012e8:	83 ec 0c             	sub    $0xc,%esp
  8012eb:	ff 75 ec             	pushl  -0x14(%ebp)
  8012ee:	e8 08 f4 ff ff       	call   8006fb <cputchar>
  8012f3:	83 c4 10             	add    $0x10,%esp

			buf[i] = 0;
  8012f6:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8012f9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012fc:	01 d0                	add    %edx,%eax
  8012fe:	c6 00 00             	movb   $0x0,(%eax)
			return;
  801301:	eb 06                	jmp    801309 <readline+0xfc>
		}
	}
  801303:	e9 3b ff ff ff       	jmp    801243 <readline+0x36>
	while (1) {
		c = getchar();
		if (c < 0) {
			if (c != -E_EOF)
				cprintf("read error: %e\n", c);
			return;
  801308:	90                   	nop
			buf[i] = 0;
			return;
		}
	}

}
  801309:	c9                   	leave  
  80130a:	c3                   	ret    

0080130b <atomic_readline>:

void atomic_readline(const char *prompt, char* buf)
{
  80130b:	55                   	push   %ebp
  80130c:	89 e5                	mov    %esp,%ebp
  80130e:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  801311:	e8 06 0f 00 00       	call   80221c <sys_disable_interrupt>
	int i, c, echoing;

	if (prompt != NULL)
  801316:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80131a:	74 13                	je     80132f <atomic_readline+0x24>
		cprintf("%s", prompt);
  80131c:	83 ec 08             	sub    $0x8,%esp
  80131f:	ff 75 08             	pushl  0x8(%ebp)
  801322:	68 90 40 80 00       	push   $0x804090
  801327:	e8 5f f8 ff ff       	call   800b8b <cprintf>
  80132c:	83 c4 10             	add    $0x10,%esp

	i = 0;
  80132f:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	echoing = iscons(0);
  801336:	83 ec 0c             	sub    $0xc,%esp
  801339:	6a 00                	push   $0x0
  80133b:	e8 51 f4 ff ff       	call   800791 <iscons>
  801340:	83 c4 10             	add    $0x10,%esp
  801343:	89 45 f0             	mov    %eax,-0x10(%ebp)
	while (1) {
		c = getchar();
  801346:	e8 f8 f3 ff ff       	call   800743 <getchar>
  80134b:	89 45 ec             	mov    %eax,-0x14(%ebp)
		if (c < 0) {
  80134e:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  801352:	79 23                	jns    801377 <atomic_readline+0x6c>
			if (c != -E_EOF)
  801354:	83 7d ec 07          	cmpl   $0x7,-0x14(%ebp)
  801358:	74 13                	je     80136d <atomic_readline+0x62>
				cprintf("read error: %e\n", c);
  80135a:	83 ec 08             	sub    $0x8,%esp
  80135d:	ff 75 ec             	pushl  -0x14(%ebp)
  801360:	68 93 40 80 00       	push   $0x804093
  801365:	e8 21 f8 ff ff       	call   800b8b <cprintf>
  80136a:	83 c4 10             	add    $0x10,%esp
			sys_enable_interrupt();
  80136d:	e8 c4 0e 00 00       	call   802236 <sys_enable_interrupt>
			return;
  801372:	e9 9a 00 00 00       	jmp    801411 <atomic_readline+0x106>
		} else if (c >= ' ' && i < BUFLEN-1) {
  801377:	83 7d ec 1f          	cmpl   $0x1f,-0x14(%ebp)
  80137b:	7e 34                	jle    8013b1 <atomic_readline+0xa6>
  80137d:	81 7d f4 fe 03 00 00 	cmpl   $0x3fe,-0xc(%ebp)
  801384:	7f 2b                	jg     8013b1 <atomic_readline+0xa6>
			if (echoing)
  801386:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80138a:	74 0e                	je     80139a <atomic_readline+0x8f>
				cputchar(c);
  80138c:	83 ec 0c             	sub    $0xc,%esp
  80138f:	ff 75 ec             	pushl  -0x14(%ebp)
  801392:	e8 64 f3 ff ff       	call   8006fb <cputchar>
  801397:	83 c4 10             	add    $0x10,%esp
			buf[i++] = c;
  80139a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80139d:	8d 50 01             	lea    0x1(%eax),%edx
  8013a0:	89 55 f4             	mov    %edx,-0xc(%ebp)
  8013a3:	89 c2                	mov    %eax,%edx
  8013a5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8013a8:	01 d0                	add    %edx,%eax
  8013aa:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8013ad:	88 10                	mov    %dl,(%eax)
  8013af:	eb 5b                	jmp    80140c <atomic_readline+0x101>
		} else if (c == '\b' && i > 0) {
  8013b1:	83 7d ec 08          	cmpl   $0x8,-0x14(%ebp)
  8013b5:	75 1f                	jne    8013d6 <atomic_readline+0xcb>
  8013b7:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8013bb:	7e 19                	jle    8013d6 <atomic_readline+0xcb>
			if (echoing)
  8013bd:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8013c1:	74 0e                	je     8013d1 <atomic_readline+0xc6>
				cputchar(c);
  8013c3:	83 ec 0c             	sub    $0xc,%esp
  8013c6:	ff 75 ec             	pushl  -0x14(%ebp)
  8013c9:	e8 2d f3 ff ff       	call   8006fb <cputchar>
  8013ce:	83 c4 10             	add    $0x10,%esp
			i--;
  8013d1:	ff 4d f4             	decl   -0xc(%ebp)
  8013d4:	eb 36                	jmp    80140c <atomic_readline+0x101>
		} else if (c == '\n' || c == '\r') {
  8013d6:	83 7d ec 0a          	cmpl   $0xa,-0x14(%ebp)
  8013da:	74 0a                	je     8013e6 <atomic_readline+0xdb>
  8013dc:	83 7d ec 0d          	cmpl   $0xd,-0x14(%ebp)
  8013e0:	0f 85 60 ff ff ff    	jne    801346 <atomic_readline+0x3b>
			if (echoing)
  8013e6:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8013ea:	74 0e                	je     8013fa <atomic_readline+0xef>
				cputchar(c);
  8013ec:	83 ec 0c             	sub    $0xc,%esp
  8013ef:	ff 75 ec             	pushl  -0x14(%ebp)
  8013f2:	e8 04 f3 ff ff       	call   8006fb <cputchar>
  8013f7:	83 c4 10             	add    $0x10,%esp
			buf[i] = 0;
  8013fa:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8013fd:	8b 45 0c             	mov    0xc(%ebp),%eax
  801400:	01 d0                	add    %edx,%eax
  801402:	c6 00 00             	movb   $0x0,(%eax)
			sys_enable_interrupt();
  801405:	e8 2c 0e 00 00       	call   802236 <sys_enable_interrupt>
			return;
  80140a:	eb 05                	jmp    801411 <atomic_readline+0x106>
		}
	}
  80140c:	e9 35 ff ff ff       	jmp    801346 <atomic_readline+0x3b>
}
  801411:	c9                   	leave  
  801412:	c3                   	ret    

00801413 <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  801413:	55                   	push   %ebp
  801414:	89 e5                	mov    %esp,%ebp
  801416:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  801419:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801420:	eb 06                	jmp    801428 <strlen+0x15>
		n++;
  801422:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  801425:	ff 45 08             	incl   0x8(%ebp)
  801428:	8b 45 08             	mov    0x8(%ebp),%eax
  80142b:	8a 00                	mov    (%eax),%al
  80142d:	84 c0                	test   %al,%al
  80142f:	75 f1                	jne    801422 <strlen+0xf>
		n++;
	return n;
  801431:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  801434:	c9                   	leave  
  801435:	c3                   	ret    

00801436 <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  801436:	55                   	push   %ebp
  801437:	89 e5                	mov    %esp,%ebp
  801439:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  80143c:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801443:	eb 09                	jmp    80144e <strnlen+0x18>
		n++;
  801445:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  801448:	ff 45 08             	incl   0x8(%ebp)
  80144b:	ff 4d 0c             	decl   0xc(%ebp)
  80144e:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801452:	74 09                	je     80145d <strnlen+0x27>
  801454:	8b 45 08             	mov    0x8(%ebp),%eax
  801457:	8a 00                	mov    (%eax),%al
  801459:	84 c0                	test   %al,%al
  80145b:	75 e8                	jne    801445 <strnlen+0xf>
		n++;
	return n;
  80145d:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  801460:	c9                   	leave  
  801461:	c3                   	ret    

00801462 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  801462:	55                   	push   %ebp
  801463:	89 e5                	mov    %esp,%ebp
  801465:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  801468:	8b 45 08             	mov    0x8(%ebp),%eax
  80146b:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  80146e:	90                   	nop
  80146f:	8b 45 08             	mov    0x8(%ebp),%eax
  801472:	8d 50 01             	lea    0x1(%eax),%edx
  801475:	89 55 08             	mov    %edx,0x8(%ebp)
  801478:	8b 55 0c             	mov    0xc(%ebp),%edx
  80147b:	8d 4a 01             	lea    0x1(%edx),%ecx
  80147e:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  801481:	8a 12                	mov    (%edx),%dl
  801483:	88 10                	mov    %dl,(%eax)
  801485:	8a 00                	mov    (%eax),%al
  801487:	84 c0                	test   %al,%al
  801489:	75 e4                	jne    80146f <strcpy+0xd>
		/* do nothing */;
	return ret;
  80148b:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  80148e:	c9                   	leave  
  80148f:	c3                   	ret    

00801490 <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  801490:	55                   	push   %ebp
  801491:	89 e5                	mov    %esp,%ebp
  801493:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  801496:	8b 45 08             	mov    0x8(%ebp),%eax
  801499:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  80149c:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8014a3:	eb 1f                	jmp    8014c4 <strncpy+0x34>
		*dst++ = *src;
  8014a5:	8b 45 08             	mov    0x8(%ebp),%eax
  8014a8:	8d 50 01             	lea    0x1(%eax),%edx
  8014ab:	89 55 08             	mov    %edx,0x8(%ebp)
  8014ae:	8b 55 0c             	mov    0xc(%ebp),%edx
  8014b1:	8a 12                	mov    (%edx),%dl
  8014b3:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  8014b5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8014b8:	8a 00                	mov    (%eax),%al
  8014ba:	84 c0                	test   %al,%al
  8014bc:	74 03                	je     8014c1 <strncpy+0x31>
			src++;
  8014be:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  8014c1:	ff 45 fc             	incl   -0x4(%ebp)
  8014c4:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8014c7:	3b 45 10             	cmp    0x10(%ebp),%eax
  8014ca:	72 d9                	jb     8014a5 <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  8014cc:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  8014cf:	c9                   	leave  
  8014d0:	c3                   	ret    

008014d1 <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  8014d1:	55                   	push   %ebp
  8014d2:	89 e5                	mov    %esp,%ebp
  8014d4:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  8014d7:	8b 45 08             	mov    0x8(%ebp),%eax
  8014da:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  8014dd:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8014e1:	74 30                	je     801513 <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  8014e3:	eb 16                	jmp    8014fb <strlcpy+0x2a>
			*dst++ = *src++;
  8014e5:	8b 45 08             	mov    0x8(%ebp),%eax
  8014e8:	8d 50 01             	lea    0x1(%eax),%edx
  8014eb:	89 55 08             	mov    %edx,0x8(%ebp)
  8014ee:	8b 55 0c             	mov    0xc(%ebp),%edx
  8014f1:	8d 4a 01             	lea    0x1(%edx),%ecx
  8014f4:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  8014f7:	8a 12                	mov    (%edx),%dl
  8014f9:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  8014fb:	ff 4d 10             	decl   0x10(%ebp)
  8014fe:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801502:	74 09                	je     80150d <strlcpy+0x3c>
  801504:	8b 45 0c             	mov    0xc(%ebp),%eax
  801507:	8a 00                	mov    (%eax),%al
  801509:	84 c0                	test   %al,%al
  80150b:	75 d8                	jne    8014e5 <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  80150d:	8b 45 08             	mov    0x8(%ebp),%eax
  801510:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  801513:	8b 55 08             	mov    0x8(%ebp),%edx
  801516:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801519:	29 c2                	sub    %eax,%edx
  80151b:	89 d0                	mov    %edx,%eax
}
  80151d:	c9                   	leave  
  80151e:	c3                   	ret    

0080151f <strcmp>:

int
strcmp(const char *p, const char *q)
{
  80151f:	55                   	push   %ebp
  801520:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  801522:	eb 06                	jmp    80152a <strcmp+0xb>
		p++, q++;
  801524:	ff 45 08             	incl   0x8(%ebp)
  801527:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  80152a:	8b 45 08             	mov    0x8(%ebp),%eax
  80152d:	8a 00                	mov    (%eax),%al
  80152f:	84 c0                	test   %al,%al
  801531:	74 0e                	je     801541 <strcmp+0x22>
  801533:	8b 45 08             	mov    0x8(%ebp),%eax
  801536:	8a 10                	mov    (%eax),%dl
  801538:	8b 45 0c             	mov    0xc(%ebp),%eax
  80153b:	8a 00                	mov    (%eax),%al
  80153d:	38 c2                	cmp    %al,%dl
  80153f:	74 e3                	je     801524 <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  801541:	8b 45 08             	mov    0x8(%ebp),%eax
  801544:	8a 00                	mov    (%eax),%al
  801546:	0f b6 d0             	movzbl %al,%edx
  801549:	8b 45 0c             	mov    0xc(%ebp),%eax
  80154c:	8a 00                	mov    (%eax),%al
  80154e:	0f b6 c0             	movzbl %al,%eax
  801551:	29 c2                	sub    %eax,%edx
  801553:	89 d0                	mov    %edx,%eax
}
  801555:	5d                   	pop    %ebp
  801556:	c3                   	ret    

00801557 <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  801557:	55                   	push   %ebp
  801558:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  80155a:	eb 09                	jmp    801565 <strncmp+0xe>
		n--, p++, q++;
  80155c:	ff 4d 10             	decl   0x10(%ebp)
  80155f:	ff 45 08             	incl   0x8(%ebp)
  801562:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  801565:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801569:	74 17                	je     801582 <strncmp+0x2b>
  80156b:	8b 45 08             	mov    0x8(%ebp),%eax
  80156e:	8a 00                	mov    (%eax),%al
  801570:	84 c0                	test   %al,%al
  801572:	74 0e                	je     801582 <strncmp+0x2b>
  801574:	8b 45 08             	mov    0x8(%ebp),%eax
  801577:	8a 10                	mov    (%eax),%dl
  801579:	8b 45 0c             	mov    0xc(%ebp),%eax
  80157c:	8a 00                	mov    (%eax),%al
  80157e:	38 c2                	cmp    %al,%dl
  801580:	74 da                	je     80155c <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  801582:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801586:	75 07                	jne    80158f <strncmp+0x38>
		return 0;
  801588:	b8 00 00 00 00       	mov    $0x0,%eax
  80158d:	eb 14                	jmp    8015a3 <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  80158f:	8b 45 08             	mov    0x8(%ebp),%eax
  801592:	8a 00                	mov    (%eax),%al
  801594:	0f b6 d0             	movzbl %al,%edx
  801597:	8b 45 0c             	mov    0xc(%ebp),%eax
  80159a:	8a 00                	mov    (%eax),%al
  80159c:	0f b6 c0             	movzbl %al,%eax
  80159f:	29 c2                	sub    %eax,%edx
  8015a1:	89 d0                	mov    %edx,%eax
}
  8015a3:	5d                   	pop    %ebp
  8015a4:	c3                   	ret    

008015a5 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  8015a5:	55                   	push   %ebp
  8015a6:	89 e5                	mov    %esp,%ebp
  8015a8:	83 ec 04             	sub    $0x4,%esp
  8015ab:	8b 45 0c             	mov    0xc(%ebp),%eax
  8015ae:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  8015b1:	eb 12                	jmp    8015c5 <strchr+0x20>
		if (*s == c)
  8015b3:	8b 45 08             	mov    0x8(%ebp),%eax
  8015b6:	8a 00                	mov    (%eax),%al
  8015b8:	3a 45 fc             	cmp    -0x4(%ebp),%al
  8015bb:	75 05                	jne    8015c2 <strchr+0x1d>
			return (char *) s;
  8015bd:	8b 45 08             	mov    0x8(%ebp),%eax
  8015c0:	eb 11                	jmp    8015d3 <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  8015c2:	ff 45 08             	incl   0x8(%ebp)
  8015c5:	8b 45 08             	mov    0x8(%ebp),%eax
  8015c8:	8a 00                	mov    (%eax),%al
  8015ca:	84 c0                	test   %al,%al
  8015cc:	75 e5                	jne    8015b3 <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  8015ce:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8015d3:	c9                   	leave  
  8015d4:	c3                   	ret    

008015d5 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  8015d5:	55                   	push   %ebp
  8015d6:	89 e5                	mov    %esp,%ebp
  8015d8:	83 ec 04             	sub    $0x4,%esp
  8015db:	8b 45 0c             	mov    0xc(%ebp),%eax
  8015de:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  8015e1:	eb 0d                	jmp    8015f0 <strfind+0x1b>
		if (*s == c)
  8015e3:	8b 45 08             	mov    0x8(%ebp),%eax
  8015e6:	8a 00                	mov    (%eax),%al
  8015e8:	3a 45 fc             	cmp    -0x4(%ebp),%al
  8015eb:	74 0e                	je     8015fb <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  8015ed:	ff 45 08             	incl   0x8(%ebp)
  8015f0:	8b 45 08             	mov    0x8(%ebp),%eax
  8015f3:	8a 00                	mov    (%eax),%al
  8015f5:	84 c0                	test   %al,%al
  8015f7:	75 ea                	jne    8015e3 <strfind+0xe>
  8015f9:	eb 01                	jmp    8015fc <strfind+0x27>
		if (*s == c)
			break;
  8015fb:	90                   	nop
	return (char *) s;
  8015fc:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8015ff:	c9                   	leave  
  801600:	c3                   	ret    

00801601 <memset>:


void *
memset(void *v, int c, uint32 n)
{
  801601:	55                   	push   %ebp
  801602:	89 e5                	mov    %esp,%ebp
  801604:	83 ec 10             	sub    $0x10,%esp
	char *p;
	int m;

	p = v;
  801607:	8b 45 08             	mov    0x8(%ebp),%eax
  80160a:	89 45 fc             	mov    %eax,-0x4(%ebp)
	m = n;
  80160d:	8b 45 10             	mov    0x10(%ebp),%eax
  801610:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (--m >= 0)
  801613:	eb 0e                	jmp    801623 <memset+0x22>
		*p++ = c;
  801615:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801618:	8d 50 01             	lea    0x1(%eax),%edx
  80161b:	89 55 fc             	mov    %edx,-0x4(%ebp)
  80161e:	8b 55 0c             	mov    0xc(%ebp),%edx
  801621:	88 10                	mov    %dl,(%eax)
	char *p;
	int m;

	p = v;
	m = n;
	while (--m >= 0)
  801623:	ff 4d f8             	decl   -0x8(%ebp)
  801626:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  80162a:	79 e9                	jns    801615 <memset+0x14>
		*p++ = c;

	return v;
  80162c:	8b 45 08             	mov    0x8(%ebp),%eax
}
  80162f:	c9                   	leave  
  801630:	c3                   	ret    

00801631 <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  801631:	55                   	push   %ebp
  801632:	89 e5                	mov    %esp,%ebp
  801634:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  801637:	8b 45 0c             	mov    0xc(%ebp),%eax
  80163a:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  80163d:	8b 45 08             	mov    0x8(%ebp),%eax
  801640:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (n-- > 0)
  801643:	eb 16                	jmp    80165b <memcpy+0x2a>
		*d++ = *s++;
  801645:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801648:	8d 50 01             	lea    0x1(%eax),%edx
  80164b:	89 55 f8             	mov    %edx,-0x8(%ebp)
  80164e:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801651:	8d 4a 01             	lea    0x1(%edx),%ecx
  801654:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  801657:	8a 12                	mov    (%edx),%dl
  801659:	88 10                	mov    %dl,(%eax)
	const char *s;
	char *d;

	s = src;
	d = dst;
	while (n-- > 0)
  80165b:	8b 45 10             	mov    0x10(%ebp),%eax
  80165e:	8d 50 ff             	lea    -0x1(%eax),%edx
  801661:	89 55 10             	mov    %edx,0x10(%ebp)
  801664:	85 c0                	test   %eax,%eax
  801666:	75 dd                	jne    801645 <memcpy+0x14>
		*d++ = *s++;

	return dst;
  801668:	8b 45 08             	mov    0x8(%ebp),%eax
}
  80166b:	c9                   	leave  
  80166c:	c3                   	ret    

0080166d <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  80166d:	55                   	push   %ebp
  80166e:	89 e5                	mov    %esp,%ebp
  801670:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  801673:	8b 45 0c             	mov    0xc(%ebp),%eax
  801676:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  801679:	8b 45 08             	mov    0x8(%ebp),%eax
  80167c:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  80167f:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801682:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  801685:	73 50                	jae    8016d7 <memmove+0x6a>
  801687:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80168a:	8b 45 10             	mov    0x10(%ebp),%eax
  80168d:	01 d0                	add    %edx,%eax
  80168f:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  801692:	76 43                	jbe    8016d7 <memmove+0x6a>
		s += n;
  801694:	8b 45 10             	mov    0x10(%ebp),%eax
  801697:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  80169a:	8b 45 10             	mov    0x10(%ebp),%eax
  80169d:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  8016a0:	eb 10                	jmp    8016b2 <memmove+0x45>
			*--d = *--s;
  8016a2:	ff 4d f8             	decl   -0x8(%ebp)
  8016a5:	ff 4d fc             	decl   -0x4(%ebp)
  8016a8:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8016ab:	8a 10                	mov    (%eax),%dl
  8016ad:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8016b0:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  8016b2:	8b 45 10             	mov    0x10(%ebp),%eax
  8016b5:	8d 50 ff             	lea    -0x1(%eax),%edx
  8016b8:	89 55 10             	mov    %edx,0x10(%ebp)
  8016bb:	85 c0                	test   %eax,%eax
  8016bd:	75 e3                	jne    8016a2 <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  8016bf:	eb 23                	jmp    8016e4 <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  8016c1:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8016c4:	8d 50 01             	lea    0x1(%eax),%edx
  8016c7:	89 55 f8             	mov    %edx,-0x8(%ebp)
  8016ca:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8016cd:	8d 4a 01             	lea    0x1(%edx),%ecx
  8016d0:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  8016d3:	8a 12                	mov    (%edx),%dl
  8016d5:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  8016d7:	8b 45 10             	mov    0x10(%ebp),%eax
  8016da:	8d 50 ff             	lea    -0x1(%eax),%edx
  8016dd:	89 55 10             	mov    %edx,0x10(%ebp)
  8016e0:	85 c0                	test   %eax,%eax
  8016e2:	75 dd                	jne    8016c1 <memmove+0x54>
			*d++ = *s++;

	return dst;
  8016e4:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8016e7:	c9                   	leave  
  8016e8:	c3                   	ret    

008016e9 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  8016e9:	55                   	push   %ebp
  8016ea:	89 e5                	mov    %esp,%ebp
  8016ec:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  8016ef:	8b 45 08             	mov    0x8(%ebp),%eax
  8016f2:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  8016f5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8016f8:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  8016fb:	eb 2a                	jmp    801727 <memcmp+0x3e>
		if (*s1 != *s2)
  8016fd:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801700:	8a 10                	mov    (%eax),%dl
  801702:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801705:	8a 00                	mov    (%eax),%al
  801707:	38 c2                	cmp    %al,%dl
  801709:	74 16                	je     801721 <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  80170b:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80170e:	8a 00                	mov    (%eax),%al
  801710:	0f b6 d0             	movzbl %al,%edx
  801713:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801716:	8a 00                	mov    (%eax),%al
  801718:	0f b6 c0             	movzbl %al,%eax
  80171b:	29 c2                	sub    %eax,%edx
  80171d:	89 d0                	mov    %edx,%eax
  80171f:	eb 18                	jmp    801739 <memcmp+0x50>
		s1++, s2++;
  801721:	ff 45 fc             	incl   -0x4(%ebp)
  801724:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  801727:	8b 45 10             	mov    0x10(%ebp),%eax
  80172a:	8d 50 ff             	lea    -0x1(%eax),%edx
  80172d:	89 55 10             	mov    %edx,0x10(%ebp)
  801730:	85 c0                	test   %eax,%eax
  801732:	75 c9                	jne    8016fd <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  801734:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801739:	c9                   	leave  
  80173a:	c3                   	ret    

0080173b <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  80173b:	55                   	push   %ebp
  80173c:	89 e5                	mov    %esp,%ebp
  80173e:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  801741:	8b 55 08             	mov    0x8(%ebp),%edx
  801744:	8b 45 10             	mov    0x10(%ebp),%eax
  801747:	01 d0                	add    %edx,%eax
  801749:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  80174c:	eb 15                	jmp    801763 <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  80174e:	8b 45 08             	mov    0x8(%ebp),%eax
  801751:	8a 00                	mov    (%eax),%al
  801753:	0f b6 d0             	movzbl %al,%edx
  801756:	8b 45 0c             	mov    0xc(%ebp),%eax
  801759:	0f b6 c0             	movzbl %al,%eax
  80175c:	39 c2                	cmp    %eax,%edx
  80175e:	74 0d                	je     80176d <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  801760:	ff 45 08             	incl   0x8(%ebp)
  801763:	8b 45 08             	mov    0x8(%ebp),%eax
  801766:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  801769:	72 e3                	jb     80174e <memfind+0x13>
  80176b:	eb 01                	jmp    80176e <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  80176d:	90                   	nop
	return (void *) s;
  80176e:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801771:	c9                   	leave  
  801772:	c3                   	ret    

00801773 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  801773:	55                   	push   %ebp
  801774:	89 e5                	mov    %esp,%ebp
  801776:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  801779:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  801780:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801787:	eb 03                	jmp    80178c <strtol+0x19>
		s++;
  801789:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  80178c:	8b 45 08             	mov    0x8(%ebp),%eax
  80178f:	8a 00                	mov    (%eax),%al
  801791:	3c 20                	cmp    $0x20,%al
  801793:	74 f4                	je     801789 <strtol+0x16>
  801795:	8b 45 08             	mov    0x8(%ebp),%eax
  801798:	8a 00                	mov    (%eax),%al
  80179a:	3c 09                	cmp    $0x9,%al
  80179c:	74 eb                	je     801789 <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  80179e:	8b 45 08             	mov    0x8(%ebp),%eax
  8017a1:	8a 00                	mov    (%eax),%al
  8017a3:	3c 2b                	cmp    $0x2b,%al
  8017a5:	75 05                	jne    8017ac <strtol+0x39>
		s++;
  8017a7:	ff 45 08             	incl   0x8(%ebp)
  8017aa:	eb 13                	jmp    8017bf <strtol+0x4c>
	else if (*s == '-')
  8017ac:	8b 45 08             	mov    0x8(%ebp),%eax
  8017af:	8a 00                	mov    (%eax),%al
  8017b1:	3c 2d                	cmp    $0x2d,%al
  8017b3:	75 0a                	jne    8017bf <strtol+0x4c>
		s++, neg = 1;
  8017b5:	ff 45 08             	incl   0x8(%ebp)
  8017b8:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  8017bf:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8017c3:	74 06                	je     8017cb <strtol+0x58>
  8017c5:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  8017c9:	75 20                	jne    8017eb <strtol+0x78>
  8017cb:	8b 45 08             	mov    0x8(%ebp),%eax
  8017ce:	8a 00                	mov    (%eax),%al
  8017d0:	3c 30                	cmp    $0x30,%al
  8017d2:	75 17                	jne    8017eb <strtol+0x78>
  8017d4:	8b 45 08             	mov    0x8(%ebp),%eax
  8017d7:	40                   	inc    %eax
  8017d8:	8a 00                	mov    (%eax),%al
  8017da:	3c 78                	cmp    $0x78,%al
  8017dc:	75 0d                	jne    8017eb <strtol+0x78>
		s += 2, base = 16;
  8017de:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  8017e2:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  8017e9:	eb 28                	jmp    801813 <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  8017eb:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8017ef:	75 15                	jne    801806 <strtol+0x93>
  8017f1:	8b 45 08             	mov    0x8(%ebp),%eax
  8017f4:	8a 00                	mov    (%eax),%al
  8017f6:	3c 30                	cmp    $0x30,%al
  8017f8:	75 0c                	jne    801806 <strtol+0x93>
		s++, base = 8;
  8017fa:	ff 45 08             	incl   0x8(%ebp)
  8017fd:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  801804:	eb 0d                	jmp    801813 <strtol+0xa0>
	else if (base == 0)
  801806:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80180a:	75 07                	jne    801813 <strtol+0xa0>
		base = 10;
  80180c:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  801813:	8b 45 08             	mov    0x8(%ebp),%eax
  801816:	8a 00                	mov    (%eax),%al
  801818:	3c 2f                	cmp    $0x2f,%al
  80181a:	7e 19                	jle    801835 <strtol+0xc2>
  80181c:	8b 45 08             	mov    0x8(%ebp),%eax
  80181f:	8a 00                	mov    (%eax),%al
  801821:	3c 39                	cmp    $0x39,%al
  801823:	7f 10                	jg     801835 <strtol+0xc2>
			dig = *s - '0';
  801825:	8b 45 08             	mov    0x8(%ebp),%eax
  801828:	8a 00                	mov    (%eax),%al
  80182a:	0f be c0             	movsbl %al,%eax
  80182d:	83 e8 30             	sub    $0x30,%eax
  801830:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801833:	eb 42                	jmp    801877 <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  801835:	8b 45 08             	mov    0x8(%ebp),%eax
  801838:	8a 00                	mov    (%eax),%al
  80183a:	3c 60                	cmp    $0x60,%al
  80183c:	7e 19                	jle    801857 <strtol+0xe4>
  80183e:	8b 45 08             	mov    0x8(%ebp),%eax
  801841:	8a 00                	mov    (%eax),%al
  801843:	3c 7a                	cmp    $0x7a,%al
  801845:	7f 10                	jg     801857 <strtol+0xe4>
			dig = *s - 'a' + 10;
  801847:	8b 45 08             	mov    0x8(%ebp),%eax
  80184a:	8a 00                	mov    (%eax),%al
  80184c:	0f be c0             	movsbl %al,%eax
  80184f:	83 e8 57             	sub    $0x57,%eax
  801852:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801855:	eb 20                	jmp    801877 <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  801857:	8b 45 08             	mov    0x8(%ebp),%eax
  80185a:	8a 00                	mov    (%eax),%al
  80185c:	3c 40                	cmp    $0x40,%al
  80185e:	7e 39                	jle    801899 <strtol+0x126>
  801860:	8b 45 08             	mov    0x8(%ebp),%eax
  801863:	8a 00                	mov    (%eax),%al
  801865:	3c 5a                	cmp    $0x5a,%al
  801867:	7f 30                	jg     801899 <strtol+0x126>
			dig = *s - 'A' + 10;
  801869:	8b 45 08             	mov    0x8(%ebp),%eax
  80186c:	8a 00                	mov    (%eax),%al
  80186e:	0f be c0             	movsbl %al,%eax
  801871:	83 e8 37             	sub    $0x37,%eax
  801874:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  801877:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80187a:	3b 45 10             	cmp    0x10(%ebp),%eax
  80187d:	7d 19                	jge    801898 <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  80187f:	ff 45 08             	incl   0x8(%ebp)
  801882:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801885:	0f af 45 10          	imul   0x10(%ebp),%eax
  801889:	89 c2                	mov    %eax,%edx
  80188b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80188e:	01 d0                	add    %edx,%eax
  801890:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  801893:	e9 7b ff ff ff       	jmp    801813 <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  801898:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  801899:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80189d:	74 08                	je     8018a7 <strtol+0x134>
		*endptr = (char *) s;
  80189f:	8b 45 0c             	mov    0xc(%ebp),%eax
  8018a2:	8b 55 08             	mov    0x8(%ebp),%edx
  8018a5:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  8018a7:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8018ab:	74 07                	je     8018b4 <strtol+0x141>
  8018ad:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8018b0:	f7 d8                	neg    %eax
  8018b2:	eb 03                	jmp    8018b7 <strtol+0x144>
  8018b4:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  8018b7:	c9                   	leave  
  8018b8:	c3                   	ret    

008018b9 <ltostr>:

void
ltostr(long value, char *str)
{
  8018b9:	55                   	push   %ebp
  8018ba:	89 e5                	mov    %esp,%ebp
  8018bc:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  8018bf:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  8018c6:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  8018cd:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8018d1:	79 13                	jns    8018e6 <ltostr+0x2d>
	{
		neg = 1;
  8018d3:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  8018da:	8b 45 0c             	mov    0xc(%ebp),%eax
  8018dd:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  8018e0:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  8018e3:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  8018e6:	8b 45 08             	mov    0x8(%ebp),%eax
  8018e9:	b9 0a 00 00 00       	mov    $0xa,%ecx
  8018ee:	99                   	cltd   
  8018ef:	f7 f9                	idiv   %ecx
  8018f1:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  8018f4:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8018f7:	8d 50 01             	lea    0x1(%eax),%edx
  8018fa:	89 55 f8             	mov    %edx,-0x8(%ebp)
  8018fd:	89 c2                	mov    %eax,%edx
  8018ff:	8b 45 0c             	mov    0xc(%ebp),%eax
  801902:	01 d0                	add    %edx,%eax
  801904:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801907:	83 c2 30             	add    $0x30,%edx
  80190a:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  80190c:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80190f:	b8 67 66 66 66       	mov    $0x66666667,%eax
  801914:	f7 e9                	imul   %ecx
  801916:	c1 fa 02             	sar    $0x2,%edx
  801919:	89 c8                	mov    %ecx,%eax
  80191b:	c1 f8 1f             	sar    $0x1f,%eax
  80191e:	29 c2                	sub    %eax,%edx
  801920:	89 d0                	mov    %edx,%eax
  801922:	89 45 08             	mov    %eax,0x8(%ebp)
	} while (value % 10 != 0);
  801925:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801928:	b8 67 66 66 66       	mov    $0x66666667,%eax
  80192d:	f7 e9                	imul   %ecx
  80192f:	c1 fa 02             	sar    $0x2,%edx
  801932:	89 c8                	mov    %ecx,%eax
  801934:	c1 f8 1f             	sar    $0x1f,%eax
  801937:	29 c2                	sub    %eax,%edx
  801939:	89 d0                	mov    %edx,%eax
  80193b:	c1 e0 02             	shl    $0x2,%eax
  80193e:	01 d0                	add    %edx,%eax
  801940:	01 c0                	add    %eax,%eax
  801942:	29 c1                	sub    %eax,%ecx
  801944:	89 ca                	mov    %ecx,%edx
  801946:	85 d2                	test   %edx,%edx
  801948:	75 9c                	jne    8018e6 <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  80194a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  801951:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801954:	48                   	dec    %eax
  801955:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  801958:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  80195c:	74 3d                	je     80199b <ltostr+0xe2>
		start = 1 ;
  80195e:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  801965:	eb 34                	jmp    80199b <ltostr+0xe2>
	{
		char tmp = str[start] ;
  801967:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80196a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80196d:	01 d0                	add    %edx,%eax
  80196f:	8a 00                	mov    (%eax),%al
  801971:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  801974:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801977:	8b 45 0c             	mov    0xc(%ebp),%eax
  80197a:	01 c2                	add    %eax,%edx
  80197c:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  80197f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801982:	01 c8                	add    %ecx,%eax
  801984:	8a 00                	mov    (%eax),%al
  801986:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  801988:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80198b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80198e:	01 c2                	add    %eax,%edx
  801990:	8a 45 eb             	mov    -0x15(%ebp),%al
  801993:	88 02                	mov    %al,(%edx)
		start++ ;
  801995:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  801998:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  80199b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80199e:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8019a1:	7c c4                	jl     801967 <ltostr+0xae>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  8019a3:	8b 55 f8             	mov    -0x8(%ebp),%edx
  8019a6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8019a9:	01 d0                	add    %edx,%eax
  8019ab:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  8019ae:	90                   	nop
  8019af:	c9                   	leave  
  8019b0:	c3                   	ret    

008019b1 <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  8019b1:	55                   	push   %ebp
  8019b2:	89 e5                	mov    %esp,%ebp
  8019b4:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  8019b7:	ff 75 08             	pushl  0x8(%ebp)
  8019ba:	e8 54 fa ff ff       	call   801413 <strlen>
  8019bf:	83 c4 04             	add    $0x4,%esp
  8019c2:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  8019c5:	ff 75 0c             	pushl  0xc(%ebp)
  8019c8:	e8 46 fa ff ff       	call   801413 <strlen>
  8019cd:	83 c4 04             	add    $0x4,%esp
  8019d0:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  8019d3:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  8019da:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8019e1:	eb 17                	jmp    8019fa <strcconcat+0x49>
		final[s] = str1[s] ;
  8019e3:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8019e6:	8b 45 10             	mov    0x10(%ebp),%eax
  8019e9:	01 c2                	add    %eax,%edx
  8019eb:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  8019ee:	8b 45 08             	mov    0x8(%ebp),%eax
  8019f1:	01 c8                	add    %ecx,%eax
  8019f3:	8a 00                	mov    (%eax),%al
  8019f5:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  8019f7:	ff 45 fc             	incl   -0x4(%ebp)
  8019fa:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8019fd:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  801a00:	7c e1                	jl     8019e3 <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  801a02:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  801a09:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  801a10:	eb 1f                	jmp    801a31 <strcconcat+0x80>
		final[s++] = str2[i] ;
  801a12:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801a15:	8d 50 01             	lea    0x1(%eax),%edx
  801a18:	89 55 fc             	mov    %edx,-0x4(%ebp)
  801a1b:	89 c2                	mov    %eax,%edx
  801a1d:	8b 45 10             	mov    0x10(%ebp),%eax
  801a20:	01 c2                	add    %eax,%edx
  801a22:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  801a25:	8b 45 0c             	mov    0xc(%ebp),%eax
  801a28:	01 c8                	add    %ecx,%eax
  801a2a:	8a 00                	mov    (%eax),%al
  801a2c:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  801a2e:	ff 45 f8             	incl   -0x8(%ebp)
  801a31:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801a34:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801a37:	7c d9                	jl     801a12 <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  801a39:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801a3c:	8b 45 10             	mov    0x10(%ebp),%eax
  801a3f:	01 d0                	add    %edx,%eax
  801a41:	c6 00 00             	movb   $0x0,(%eax)
}
  801a44:	90                   	nop
  801a45:	c9                   	leave  
  801a46:	c3                   	ret    

00801a47 <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  801a47:	55                   	push   %ebp
  801a48:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  801a4a:	8b 45 14             	mov    0x14(%ebp),%eax
  801a4d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  801a53:	8b 45 14             	mov    0x14(%ebp),%eax
  801a56:	8b 00                	mov    (%eax),%eax
  801a58:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801a5f:	8b 45 10             	mov    0x10(%ebp),%eax
  801a62:	01 d0                	add    %edx,%eax
  801a64:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801a6a:	eb 0c                	jmp    801a78 <strsplit+0x31>
			*string++ = 0;
  801a6c:	8b 45 08             	mov    0x8(%ebp),%eax
  801a6f:	8d 50 01             	lea    0x1(%eax),%edx
  801a72:	89 55 08             	mov    %edx,0x8(%ebp)
  801a75:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801a78:	8b 45 08             	mov    0x8(%ebp),%eax
  801a7b:	8a 00                	mov    (%eax),%al
  801a7d:	84 c0                	test   %al,%al
  801a7f:	74 18                	je     801a99 <strsplit+0x52>
  801a81:	8b 45 08             	mov    0x8(%ebp),%eax
  801a84:	8a 00                	mov    (%eax),%al
  801a86:	0f be c0             	movsbl %al,%eax
  801a89:	50                   	push   %eax
  801a8a:	ff 75 0c             	pushl  0xc(%ebp)
  801a8d:	e8 13 fb ff ff       	call   8015a5 <strchr>
  801a92:	83 c4 08             	add    $0x8,%esp
  801a95:	85 c0                	test   %eax,%eax
  801a97:	75 d3                	jne    801a6c <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  801a99:	8b 45 08             	mov    0x8(%ebp),%eax
  801a9c:	8a 00                	mov    (%eax),%al
  801a9e:	84 c0                	test   %al,%al
  801aa0:	74 5a                	je     801afc <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  801aa2:	8b 45 14             	mov    0x14(%ebp),%eax
  801aa5:	8b 00                	mov    (%eax),%eax
  801aa7:	83 f8 0f             	cmp    $0xf,%eax
  801aaa:	75 07                	jne    801ab3 <strsplit+0x6c>
		{
			return 0;
  801aac:	b8 00 00 00 00       	mov    $0x0,%eax
  801ab1:	eb 66                	jmp    801b19 <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  801ab3:	8b 45 14             	mov    0x14(%ebp),%eax
  801ab6:	8b 00                	mov    (%eax),%eax
  801ab8:	8d 48 01             	lea    0x1(%eax),%ecx
  801abb:	8b 55 14             	mov    0x14(%ebp),%edx
  801abe:	89 0a                	mov    %ecx,(%edx)
  801ac0:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801ac7:	8b 45 10             	mov    0x10(%ebp),%eax
  801aca:	01 c2                	add    %eax,%edx
  801acc:	8b 45 08             	mov    0x8(%ebp),%eax
  801acf:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  801ad1:	eb 03                	jmp    801ad6 <strsplit+0x8f>
			string++;
  801ad3:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  801ad6:	8b 45 08             	mov    0x8(%ebp),%eax
  801ad9:	8a 00                	mov    (%eax),%al
  801adb:	84 c0                	test   %al,%al
  801add:	74 8b                	je     801a6a <strsplit+0x23>
  801adf:	8b 45 08             	mov    0x8(%ebp),%eax
  801ae2:	8a 00                	mov    (%eax),%al
  801ae4:	0f be c0             	movsbl %al,%eax
  801ae7:	50                   	push   %eax
  801ae8:	ff 75 0c             	pushl  0xc(%ebp)
  801aeb:	e8 b5 fa ff ff       	call   8015a5 <strchr>
  801af0:	83 c4 08             	add    $0x8,%esp
  801af3:	85 c0                	test   %eax,%eax
  801af5:	74 dc                	je     801ad3 <strsplit+0x8c>
			string++;
	}
  801af7:	e9 6e ff ff ff       	jmp    801a6a <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  801afc:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  801afd:	8b 45 14             	mov    0x14(%ebp),%eax
  801b00:	8b 00                	mov    (%eax),%eax
  801b02:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801b09:	8b 45 10             	mov    0x10(%ebp),%eax
  801b0c:	01 d0                	add    %edx,%eax
  801b0e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  801b14:	b8 01 00 00 00       	mov    $0x1,%eax
}
  801b19:	c9                   	leave  
  801b1a:	c3                   	ret    

00801b1b <InitializeUHeap>:
//============================== GIVEN FUNCTIONS ===================================//
//==================================================================================//

int FirstTimeFlag = 1;
void InitializeUHeap()
{
  801b1b:	55                   	push   %ebp
  801b1c:	89 e5                	mov    %esp,%ebp
  801b1e:	83 ec 08             	sub    $0x8,%esp
	if(FirstTimeFlag)
  801b21:	a1 04 50 80 00       	mov    0x805004,%eax
  801b26:	85 c0                	test   %eax,%eax
  801b28:	74 1f                	je     801b49 <InitializeUHeap+0x2e>
	{
		initialize_dyn_block_system();
  801b2a:	e8 1d 00 00 00       	call   801b4c <initialize_dyn_block_system>
		cprintf("DYNAMIC BLOCK SYSTEM IS INITIALIZED\n");
  801b2f:	83 ec 0c             	sub    $0xc,%esp
  801b32:	68 a4 40 80 00       	push   $0x8040a4
  801b37:	e8 4f f0 ff ff       	call   800b8b <cprintf>
  801b3c:	83 c4 10             	add    $0x10,%esp
#if UHP_USE_BUDDY
		initialize_buddy();
		cprintf("BUDDY SYSTEM IS INITIALIZED\n");
#endif
		FirstTimeFlag = 0;
  801b3f:	c7 05 04 50 80 00 00 	movl   $0x0,0x805004
  801b46:	00 00 00 
	}
}
  801b49:	90                   	nop
  801b4a:	c9                   	leave  
  801b4b:	c3                   	ret    

00801b4c <initialize_dyn_block_system>:

//=================================
// [1] INITIALIZE DYNAMIC ALLOCATOR:
//=================================
void initialize_dyn_block_system()
{
  801b4c:	55                   	push   %ebp
  801b4d:	89 e5                	mov    %esp,%ebp
  801b4f:	83 ec 28             	sub    $0x28,%esp
	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] initialize_dyn_block_system
	// your code is here, remove the panic and write your code
	//panic("initialize_dyn_block_system() is not implemented yet...!!");

	LIST_INIT(&AllocMemBlocksList);
  801b52:	c7 05 40 50 80 00 00 	movl   $0x0,0x805040
  801b59:	00 00 00 
  801b5c:	c7 05 44 50 80 00 00 	movl   $0x0,0x805044
  801b63:	00 00 00 
  801b66:	c7 05 4c 50 80 00 00 	movl   $0x0,0x80504c
  801b6d:	00 00 00 
	LIST_INIT(&FreeMemBlocksList);
  801b70:	c7 05 38 51 80 00 00 	movl   $0x0,0x805138
  801b77:	00 00 00 
  801b7a:	c7 05 3c 51 80 00 00 	movl   $0x0,0x80513c
  801b81:	00 00 00 
  801b84:	c7 05 44 51 80 00 00 	movl   $0x0,0x805144
  801b8b:	00 00 00 
	MAX_MEM_BLOCK_CNT = NUM_OF_UHEAP_PAGES;
  801b8e:	c7 05 20 51 80 00 00 	movl   $0x20000,0x805120
  801b95:	00 02 00 
	MemBlockNodes = (void*)USER_DYN_BLKS_ARRAY;
  801b98:	c7 45 f4 00 00 e0 7f 	movl   $0x7fe00000,-0xc(%ebp)
  801b9f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ba2:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801ba7:	2d 00 10 00 00       	sub    $0x1000,%eax
  801bac:	a3 50 50 80 00       	mov    %eax,0x805050
	int size_of_block = sizeof(struct MemBlock);
  801bb1:	c7 45 f0 10 00 00 00 	movl   $0x10,-0x10(%ebp)
	int size_all_struct = size_of_block*MAX_MEM_BLOCK_CNT;
  801bb8:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801bbb:	a1 20 51 80 00       	mov    0x805120,%eax
  801bc0:	0f af c2             	imul   %edx,%eax
  801bc3:	89 45 ec             	mov    %eax,-0x14(%ebp)
	size_all_struct = ROUNDUP(size_all_struct, PAGE_SIZE);
  801bc6:	c7 45 e8 00 10 00 00 	movl   $0x1000,-0x18(%ebp)
  801bcd:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801bd0:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801bd3:	01 d0                	add    %edx,%eax
  801bd5:	48                   	dec    %eax
  801bd6:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  801bd9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801bdc:	ba 00 00 00 00       	mov    $0x0,%edx
  801be1:	f7 75 e8             	divl   -0x18(%ebp)
  801be4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801be7:	29 d0                	sub    %edx,%eax
  801be9:	89 45 ec             	mov    %eax,-0x14(%ebp)
	sys_allocate_chunk(USER_DYN_BLKS_ARRAY, size_all_struct,PERM_USER| PERM_WRITEABLE);
  801bec:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801bef:	c7 45 e0 00 00 e0 7f 	movl   $0x7fe00000,-0x20(%ebp)
  801bf6:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801bf9:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
  801bff:	81 ea 00 10 00 00    	sub    $0x1000,%edx
  801c05:	83 ec 04             	sub    $0x4,%esp
  801c08:	6a 06                	push   $0x6
  801c0a:	50                   	push   %eax
  801c0b:	52                   	push   %edx
  801c0c:	e8 a1 05 00 00       	call   8021b2 <sys_allocate_chunk>
  801c11:	83 c4 10             	add    $0x10,%esp
	initialize_MemBlocksList(MAX_MEM_BLOCK_CNT);
  801c14:	a1 20 51 80 00       	mov    0x805120,%eax
  801c19:	83 ec 0c             	sub    $0xc,%esp
  801c1c:	50                   	push   %eax
  801c1d:	e8 16 0c 00 00       	call   802838 <initialize_MemBlocksList>
  801c22:	83 c4 10             	add    $0x10,%esp
	struct MemBlock* ourBlock =LIST_LAST(&AvailableMemBlocksList);
  801c25:	a1 4c 51 80 00       	mov    0x80514c,%eax
  801c2a:	89 45 dc             	mov    %eax,-0x24(%ebp)
	LIST_REMOVE(&AvailableMemBlocksList,ourBlock);
  801c2d:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  801c31:	75 14                	jne    801c47 <initialize_dyn_block_system+0xfb>
  801c33:	83 ec 04             	sub    $0x4,%esp
  801c36:	68 c9 40 80 00       	push   $0x8040c9
  801c3b:	6a 2d                	push   $0x2d
  801c3d:	68 e7 40 80 00       	push   $0x8040e7
  801c42:	e8 90 ec ff ff       	call   8008d7 <_panic>
  801c47:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801c4a:	8b 00                	mov    (%eax),%eax
  801c4c:	85 c0                	test   %eax,%eax
  801c4e:	74 10                	je     801c60 <initialize_dyn_block_system+0x114>
  801c50:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801c53:	8b 00                	mov    (%eax),%eax
  801c55:	8b 55 dc             	mov    -0x24(%ebp),%edx
  801c58:	8b 52 04             	mov    0x4(%edx),%edx
  801c5b:	89 50 04             	mov    %edx,0x4(%eax)
  801c5e:	eb 0b                	jmp    801c6b <initialize_dyn_block_system+0x11f>
  801c60:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801c63:	8b 40 04             	mov    0x4(%eax),%eax
  801c66:	a3 4c 51 80 00       	mov    %eax,0x80514c
  801c6b:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801c6e:	8b 40 04             	mov    0x4(%eax),%eax
  801c71:	85 c0                	test   %eax,%eax
  801c73:	74 0f                	je     801c84 <initialize_dyn_block_system+0x138>
  801c75:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801c78:	8b 40 04             	mov    0x4(%eax),%eax
  801c7b:	8b 55 dc             	mov    -0x24(%ebp),%edx
  801c7e:	8b 12                	mov    (%edx),%edx
  801c80:	89 10                	mov    %edx,(%eax)
  801c82:	eb 0a                	jmp    801c8e <initialize_dyn_block_system+0x142>
  801c84:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801c87:	8b 00                	mov    (%eax),%eax
  801c89:	a3 48 51 80 00       	mov    %eax,0x805148
  801c8e:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801c91:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  801c97:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801c9a:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  801ca1:	a1 54 51 80 00       	mov    0x805154,%eax
  801ca6:	48                   	dec    %eax
  801ca7:	a3 54 51 80 00       	mov    %eax,0x805154
	ourBlock->size = USER_HEAP_MAX-USER_HEAP_START;
  801cac:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801caf:	c7 40 0c 00 00 00 20 	movl   $0x20000000,0xc(%eax)
	ourBlock->sva=USER_HEAP_START;
  801cb6:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801cb9:	c7 40 08 00 00 00 80 	movl   $0x80000000,0x8(%eax)
	LIST_INSERT_TAIL(&FreeMemBlocksList, ourBlock);
  801cc0:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  801cc4:	75 14                	jne    801cda <initialize_dyn_block_system+0x18e>
  801cc6:	83 ec 04             	sub    $0x4,%esp
  801cc9:	68 f4 40 80 00       	push   $0x8040f4
  801cce:	6a 30                	push   $0x30
  801cd0:	68 e7 40 80 00       	push   $0x8040e7
  801cd5:	e8 fd eb ff ff       	call   8008d7 <_panic>
  801cda:	8b 15 3c 51 80 00    	mov    0x80513c,%edx
  801ce0:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801ce3:	89 50 04             	mov    %edx,0x4(%eax)
  801ce6:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801ce9:	8b 40 04             	mov    0x4(%eax),%eax
  801cec:	85 c0                	test   %eax,%eax
  801cee:	74 0c                	je     801cfc <initialize_dyn_block_system+0x1b0>
  801cf0:	a1 3c 51 80 00       	mov    0x80513c,%eax
  801cf5:	8b 55 dc             	mov    -0x24(%ebp),%edx
  801cf8:	89 10                	mov    %edx,(%eax)
  801cfa:	eb 08                	jmp    801d04 <initialize_dyn_block_system+0x1b8>
  801cfc:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801cff:	a3 38 51 80 00       	mov    %eax,0x805138
  801d04:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801d07:	a3 3c 51 80 00       	mov    %eax,0x80513c
  801d0c:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801d0f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  801d15:	a1 44 51 80 00       	mov    0x805144,%eax
  801d1a:	40                   	inc    %eax
  801d1b:	a3 44 51 80 00       	mov    %eax,0x805144
	//[1] Initialize two lists (AllocMemBlocksList & FreeMemBlocksList) [Hint: use LIST_INIT()]
	//[2] Dynamically allocate the array of MemBlockNodes at VA USER_DYN_BLKS_ARRAY
	//	  (remember to set MAX_MEM_BLOCK_CNT with the chosen size of the array)
	//[3] Initialize AvailableMemBlocksList by filling it with the MemBlockNodes
	//[4] Insert a new MemBlock with the heap size into the FreeMemBlocksList
}
  801d20:	90                   	nop
  801d21:	c9                   	leave  
  801d22:	c3                   	ret    

00801d23 <malloc>:
//=================================
// [2] ALLOCATE SPACE IN USER HEAP:
//=================================

void* malloc(uint32 size)
{
  801d23:	55                   	push   %ebp
  801d24:	89 e5                	mov    %esp,%ebp
  801d26:	83 ec 18             	sub    $0x18,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801d29:	e8 ed fd ff ff       	call   801b1b <InitializeUHeap>
	if (size == 0) return NULL ;
  801d2e:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801d32:	75 07                	jne    801d3b <malloc+0x18>
  801d34:	b8 00 00 00 00       	mov    $0x0,%eax
  801d39:	eb 67                	jmp    801da2 <malloc+0x7f>

	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] malloc
	// your code is here, remove the panic and write your code
	//panic("malloc() is not implemented yet...!!");

	size = ROUNDUP(size, PAGE_SIZE);
  801d3b:	c7 45 f4 00 10 00 00 	movl   $0x1000,-0xc(%ebp)
  801d42:	8b 55 08             	mov    0x8(%ebp),%edx
  801d45:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801d48:	01 d0                	add    %edx,%eax
  801d4a:	48                   	dec    %eax
  801d4b:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801d4e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801d51:	ba 00 00 00 00       	mov    $0x0,%edx
  801d56:	f7 75 f4             	divl   -0xc(%ebp)
  801d59:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801d5c:	29 d0                	sub    %edx,%eax
  801d5e:	89 45 08             	mov    %eax,0x8(%ebp)
	if(sys_isUHeapPlacementStrategyFIRSTFIT())
  801d61:	e8 1a 08 00 00       	call   802580 <sys_isUHeapPlacementStrategyFIRSTFIT>
  801d66:	85 c0                	test   %eax,%eax
  801d68:	74 33                	je     801d9d <malloc+0x7a>
	{
		struct MemBlock * myBlock = alloc_block_FF(size);
  801d6a:	83 ec 0c             	sub    $0xc,%esp
  801d6d:	ff 75 08             	pushl  0x8(%ebp)
  801d70:	e8 0c 0e 00 00       	call   802b81 <alloc_block_FF>
  801d75:	83 c4 10             	add    $0x10,%esp
  801d78:	89 45 ec             	mov    %eax,-0x14(%ebp)
		if(myBlock != NULL)
  801d7b:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  801d7f:	74 1c                	je     801d9d <malloc+0x7a>
		{
			insert_sorted_allocList(myBlock);
  801d81:	83 ec 0c             	sub    $0xc,%esp
  801d84:	ff 75 ec             	pushl  -0x14(%ebp)
  801d87:	e8 07 0c 00 00       	call   802993 <insert_sorted_allocList>
  801d8c:	83 c4 10             	add    $0x10,%esp
			uint32 ptr = myBlock->sva;
  801d8f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801d92:	8b 40 08             	mov    0x8(%eax),%eax
  801d95:	89 45 e8             	mov    %eax,-0x18(%ebp)
			return (void *)ptr;
  801d98:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801d9b:	eb 05                	jmp    801da2 <malloc+0x7f>
		}
	}
	return NULL;
  801d9d:	b8 00 00 00 00       	mov    $0x0,%eax
	//		to the required allocation size (space should be on 4 KB BOUNDARY)
	//	2) if no suitable space found, return NULL
	// 	3) Return pointer containing the virtual address of allocated space,
	//
	//Use sys_isUHeapPlacementStrategyFIRSTFIT()... to check the current strategy
}
  801da2:	c9                   	leave  
  801da3:	c3                   	ret    

00801da4 <free>:
//	We can use sys_free_user_mem(uint32 virtual_address, uint32 size); which
//		switches to the kernel mode, calls free_user_mem() in
//		"kern/mem/chunk_operations.c", then switch back to the user mode here
//	the free_user_mem function is empty, make sure to implement it.
void free(void* virtual_address)
{
  801da4:	55                   	push   %ebp
  801da5:	89 e5                	mov    %esp,%ebp
  801da7:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] free
	// your code is here, remove the panic and write your code
	//panic("free() is not implemented yet...!!");

	uint32 virtualAddress = (uint32 )(virtual_address);
  801daa:	8b 45 08             	mov    0x8(%ebp),%eax
  801dad:	89 45 f4             	mov    %eax,-0xc(%ebp)
//	virtualAddress = ROUNDDOWN(virtualAddress, PAGE_SIZE);
	struct MemBlock * myBlock = find_block(&AllocMemBlocksList, virtualAddress);
  801db0:	83 ec 08             	sub    $0x8,%esp
  801db3:	ff 75 f4             	pushl  -0xc(%ebp)
  801db6:	68 40 50 80 00       	push   $0x805040
  801dbb:	e8 5b 0b 00 00       	call   80291b <find_block>
  801dc0:	83 c4 10             	add    $0x10,%esp
  801dc3:	89 45 f0             	mov    %eax,-0x10(%ebp)
//	cprintf ("ptr sva at free user side = %x \n", myBlock->sva);
	sys_free_user_mem(virtualAddress, myBlock->size);
  801dc6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801dc9:	8b 40 0c             	mov    0xc(%eax),%eax
  801dcc:	83 ec 08             	sub    $0x8,%esp
  801dcf:	50                   	push   %eax
  801dd0:	ff 75 f4             	pushl  -0xc(%ebp)
  801dd3:	e8 a2 03 00 00       	call   80217a <sys_free_user_mem>
  801dd8:	83 c4 10             	add    $0x10,%esp
	LIST_REMOVE(&AllocMemBlocksList, myBlock);
  801ddb:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801ddf:	75 14                	jne    801df5 <free+0x51>
  801de1:	83 ec 04             	sub    $0x4,%esp
  801de4:	68 c9 40 80 00       	push   $0x8040c9
  801de9:	6a 76                	push   $0x76
  801deb:	68 e7 40 80 00       	push   $0x8040e7
  801df0:	e8 e2 ea ff ff       	call   8008d7 <_panic>
  801df5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801df8:	8b 00                	mov    (%eax),%eax
  801dfa:	85 c0                	test   %eax,%eax
  801dfc:	74 10                	je     801e0e <free+0x6a>
  801dfe:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801e01:	8b 00                	mov    (%eax),%eax
  801e03:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801e06:	8b 52 04             	mov    0x4(%edx),%edx
  801e09:	89 50 04             	mov    %edx,0x4(%eax)
  801e0c:	eb 0b                	jmp    801e19 <free+0x75>
  801e0e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801e11:	8b 40 04             	mov    0x4(%eax),%eax
  801e14:	a3 44 50 80 00       	mov    %eax,0x805044
  801e19:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801e1c:	8b 40 04             	mov    0x4(%eax),%eax
  801e1f:	85 c0                	test   %eax,%eax
  801e21:	74 0f                	je     801e32 <free+0x8e>
  801e23:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801e26:	8b 40 04             	mov    0x4(%eax),%eax
  801e29:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801e2c:	8b 12                	mov    (%edx),%edx
  801e2e:	89 10                	mov    %edx,(%eax)
  801e30:	eb 0a                	jmp    801e3c <free+0x98>
  801e32:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801e35:	8b 00                	mov    (%eax),%eax
  801e37:	a3 40 50 80 00       	mov    %eax,0x805040
  801e3c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801e3f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  801e45:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801e48:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  801e4f:	a1 4c 50 80 00       	mov    0x80504c,%eax
  801e54:	48                   	dec    %eax
  801e55:	a3 4c 50 80 00       	mov    %eax,0x80504c
	insert_sorted_with_merge_freeList(myBlock);
  801e5a:	83 ec 0c             	sub    $0xc,%esp
  801e5d:	ff 75 f0             	pushl  -0x10(%ebp)
  801e60:	e8 0b 14 00 00       	call   803270 <insert_sorted_with_merge_freeList>
  801e65:	83 c4 10             	add    $0x10,%esp

	//you should get the size of the given allocation using its address
	//you need to call sys_free_user_mem()
	//refer to the project presentation and documentation for details
}
  801e68:	90                   	nop
  801e69:	c9                   	leave  
  801e6a:	c3                   	ret    

00801e6b <smalloc>:

//=================================
// [4] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
  801e6b:	55                   	push   %ebp
  801e6c:	89 e5                	mov    %esp,%ebp
  801e6e:	83 ec 28             	sub    $0x28,%esp
  801e71:	8b 45 10             	mov    0x10(%ebp),%eax
  801e74:	88 45 e4             	mov    %al,-0x1c(%ebp)
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801e77:	e8 9f fc ff ff       	call   801b1b <InitializeUHeap>
	if (size == 0) return NULL ;
  801e7c:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801e80:	75 0a                	jne    801e8c <smalloc+0x21>
  801e82:	b8 00 00 00 00       	mov    $0x0,%eax
  801e87:	e9 8d 00 00 00       	jmp    801f19 <smalloc+0xae>

	//This function should find the space of the required range
	// * ON 4KB BOUNDARY **** //
	//Use sys_isUHeapPlacementStrategyFIRSTFIT() to check the current strategy

	size = ROUNDUP(size, PAGE_SIZE);
  801e8c:	c7 45 f4 00 10 00 00 	movl   $0x1000,-0xc(%ebp)
  801e93:	8b 55 0c             	mov    0xc(%ebp),%edx
  801e96:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e99:	01 d0                	add    %edx,%eax
  801e9b:	48                   	dec    %eax
  801e9c:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801e9f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801ea2:	ba 00 00 00 00       	mov    $0x0,%edx
  801ea7:	f7 75 f4             	divl   -0xc(%ebp)
  801eaa:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801ead:	29 d0                	sub    %edx,%eax
  801eaf:	89 45 0c             	mov    %eax,0xc(%ebp)
		if(sys_isUHeapPlacementStrategyFIRSTFIT())
  801eb2:	e8 c9 06 00 00       	call   802580 <sys_isUHeapPlacementStrategyFIRSTFIT>
  801eb7:	85 c0                	test   %eax,%eax
  801eb9:	74 59                	je     801f14 <smalloc+0xa9>
		{
			struct MemBlock * v1=NULL;
  801ebb:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
			v1= alloc_block_FF(size);
  801ec2:	83 ec 0c             	sub    $0xc,%esp
  801ec5:	ff 75 0c             	pushl  0xc(%ebp)
  801ec8:	e8 b4 0c 00 00       	call   802b81 <alloc_block_FF>
  801ecd:	83 c4 10             	add    $0x10,%esp
  801ed0:	89 45 ec             	mov    %eax,-0x14(%ebp)
			if(v1==NULL)
  801ed3:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  801ed7:	75 07                	jne    801ee0 <smalloc+0x75>
			{
				return NULL;
  801ed9:	b8 00 00 00 00       	mov    $0x0,%eax
  801ede:	eb 39                	jmp    801f19 <smalloc+0xae>
			}
			else
			{
				int ret=sys_createSharedObject(sharedVarName,  size,  isWritable,(void*)v1->sva);
  801ee0:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801ee3:	8b 40 08             	mov    0x8(%eax),%eax
  801ee6:	89 c2                	mov    %eax,%edx
  801ee8:	0f b6 45 e4          	movzbl -0x1c(%ebp),%eax
  801eec:	52                   	push   %edx
  801eed:	50                   	push   %eax
  801eee:	ff 75 0c             	pushl  0xc(%ebp)
  801ef1:	ff 75 08             	pushl  0x8(%ebp)
  801ef4:	e8 0c 04 00 00       	call   802305 <sys_createSharedObject>
  801ef9:	83 c4 10             	add    $0x10,%esp
  801efc:	89 45 e8             	mov    %eax,-0x18(%ebp)
				if(ret>=0)
  801eff:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  801f03:	78 08                	js     801f0d <smalloc+0xa2>
				{
					return (void*)v1->sva;
  801f05:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801f08:	8b 40 08             	mov    0x8(%eax),%eax
  801f0b:	eb 0c                	jmp    801f19 <smalloc+0xae>
				}
				else
				{
					return NULL;
  801f0d:	b8 00 00 00 00       	mov    $0x0,%eax
  801f12:	eb 05                	jmp    801f19 <smalloc+0xae>
				}
			}

		}
		return NULL;
  801f14:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801f19:	c9                   	leave  
  801f1a:	c3                   	ret    

00801f1b <sget>:

//========================================
// [5] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  801f1b:	55                   	push   %ebp
  801f1c:	89 e5                	mov    %esp,%ebp
  801f1e:	83 ec 18             	sub    $0x18,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801f21:	e8 f5 fb ff ff       	call   801b1b <InitializeUHeap>

	//This function should find the space for sharing the variable
	// *** ON 4KB BOUNDARY ******** //

	//Use sys_isUHeapPlacementStrategyFIRSTFIT() to check the current strategy
	int ret=sys_getSizeOfSharedObject(ownerEnvID,sharedVarName);
  801f26:	83 ec 08             	sub    $0x8,%esp
  801f29:	ff 75 0c             	pushl  0xc(%ebp)
  801f2c:	ff 75 08             	pushl  0x8(%ebp)
  801f2f:	e8 fb 03 00 00       	call   80232f <sys_getSizeOfSharedObject>
  801f34:	83 c4 10             	add    $0x10,%esp
  801f37:	89 45 f4             	mov    %eax,-0xc(%ebp)
	if(ret==0)
  801f3a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801f3e:	75 07                	jne    801f47 <sget+0x2c>
	{
		return NULL;
  801f40:	b8 00 00 00 00       	mov    $0x0,%eax
  801f45:	eb 64                	jmp    801fab <sget+0x90>
	}
	if(sys_isUHeapPlacementStrategyFIRSTFIT())
  801f47:	e8 34 06 00 00       	call   802580 <sys_isUHeapPlacementStrategyFIRSTFIT>
  801f4c:	85 c0                	test   %eax,%eax
  801f4e:	74 56                	je     801fa6 <sget+0x8b>
	{
		struct MemBlock * v1=NULL;
  801f50:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
		v1= alloc_block_FF(ret);
  801f57:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f5a:	83 ec 0c             	sub    $0xc,%esp
  801f5d:	50                   	push   %eax
  801f5e:	e8 1e 0c 00 00       	call   802b81 <alloc_block_FF>
  801f63:	83 c4 10             	add    $0x10,%esp
  801f66:	89 45 f0             	mov    %eax,-0x10(%ebp)
		if(v1==NULL)
  801f69:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801f6d:	75 07                	jne    801f76 <sget+0x5b>
		{
		return NULL;
  801f6f:	b8 00 00 00 00       	mov    $0x0,%eax
  801f74:	eb 35                	jmp    801fab <sget+0x90>
	    }
		else
		{
			int ret1=sys_getSharedObject(ownerEnvID,sharedVarName,(void*)v1->sva);
  801f76:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801f79:	8b 40 08             	mov    0x8(%eax),%eax
  801f7c:	83 ec 04             	sub    $0x4,%esp
  801f7f:	50                   	push   %eax
  801f80:	ff 75 0c             	pushl  0xc(%ebp)
  801f83:	ff 75 08             	pushl  0x8(%ebp)
  801f86:	e8 c1 03 00 00       	call   80234c <sys_getSharedObject>
  801f8b:	83 c4 10             	add    $0x10,%esp
  801f8e:	89 45 ec             	mov    %eax,-0x14(%ebp)
			if(ret1>=0)
  801f91:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  801f95:	78 08                	js     801f9f <sget+0x84>
			{
				return (void*)v1->sva;
  801f97:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801f9a:	8b 40 08             	mov    0x8(%eax),%eax
  801f9d:	eb 0c                	jmp    801fab <sget+0x90>
			}
			else
			{
				return NULL;
  801f9f:	b8 00 00 00 00       	mov    $0x0,%eax
  801fa4:	eb 05                	jmp    801fab <sget+0x90>
			}
		}
	}
  return NULL;
  801fa6:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801fab:	c9                   	leave  
  801fac:	c3                   	ret    

00801fad <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  801fad:	55                   	push   %ebp
  801fae:	89 e5                	mov    %esp,%ebp
  801fb0:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801fb3:	e8 63 fb ff ff       	call   801b1b <InitializeUHeap>
	//==============================================================
	// [USER HEAP - USER SIDE] realloc
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  801fb8:	83 ec 04             	sub    $0x4,%esp
  801fbb:	68 18 41 80 00       	push   $0x804118
  801fc0:	68 0e 01 00 00       	push   $0x10e
  801fc5:	68 e7 40 80 00       	push   $0x8040e7
  801fca:	e8 08 e9 ff ff       	call   8008d7 <_panic>

00801fcf <sfree>:
//	use sys_freeSharedObject(...); which switches to the kernel mode,
//	calls freeSharedObject(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the freeSharedObject() function is empty, make sure to implement it.

void sfree(void* virtual_address)
{
  801fcf:	55                   	push   %ebp
  801fd0:	89 e5                	mov    %esp,%ebp
  801fd2:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS3 - BONUS] [SHARING - USER SIDE] sfree()

	// Write your code here, remove the panic and write your code
	panic("sfree() is not implemented yet...!!");
  801fd5:	83 ec 04             	sub    $0x4,%esp
  801fd8:	68 40 41 80 00       	push   $0x804140
  801fdd:	68 22 01 00 00       	push   $0x122
  801fe2:	68 e7 40 80 00       	push   $0x8040e7
  801fe7:	e8 eb e8 ff ff       	call   8008d7 <_panic>

00801fec <expand>:

//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//
void expand(uint32 newSize)
{
  801fec:	55                   	push   %ebp
  801fed:	89 e5                	mov    %esp,%ebp
  801fef:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801ff2:	83 ec 04             	sub    $0x4,%esp
  801ff5:	68 64 41 80 00       	push   $0x804164
  801ffa:	68 2d 01 00 00       	push   $0x12d
  801fff:	68 e7 40 80 00       	push   $0x8040e7
  802004:	e8 ce e8 ff ff       	call   8008d7 <_panic>

00802009 <shrink>:

}
void shrink(uint32 newSize)
{
  802009:	55                   	push   %ebp
  80200a:	89 e5                	mov    %esp,%ebp
  80200c:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  80200f:	83 ec 04             	sub    $0x4,%esp
  802012:	68 64 41 80 00       	push   $0x804164
  802017:	68 32 01 00 00       	push   $0x132
  80201c:	68 e7 40 80 00       	push   $0x8040e7
  802021:	e8 b1 e8 ff ff       	call   8008d7 <_panic>

00802026 <freeHeap>:

}
void freeHeap(void* virtual_address)
{
  802026:	55                   	push   %ebp
  802027:	89 e5                	mov    %esp,%ebp
  802029:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  80202c:	83 ec 04             	sub    $0x4,%esp
  80202f:	68 64 41 80 00       	push   $0x804164
  802034:	68 37 01 00 00       	push   $0x137
  802039:	68 e7 40 80 00       	push   $0x8040e7
  80203e:	e8 94 e8 ff ff       	call   8008d7 <_panic>

00802043 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  802043:	55                   	push   %ebp
  802044:	89 e5                	mov    %esp,%ebp
  802046:	57                   	push   %edi
  802047:	56                   	push   %esi
  802048:	53                   	push   %ebx
  802049:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  80204c:	8b 45 08             	mov    0x8(%ebp),%eax
  80204f:	8b 55 0c             	mov    0xc(%ebp),%edx
  802052:	8b 4d 10             	mov    0x10(%ebp),%ecx
  802055:	8b 5d 14             	mov    0x14(%ebp),%ebx
  802058:	8b 7d 18             	mov    0x18(%ebp),%edi
  80205b:	8b 75 1c             	mov    0x1c(%ebp),%esi
  80205e:	cd 30                	int    $0x30
  802060:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  802063:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  802066:	83 c4 10             	add    $0x10,%esp
  802069:	5b                   	pop    %ebx
  80206a:	5e                   	pop    %esi
  80206b:	5f                   	pop    %edi
  80206c:	5d                   	pop    %ebp
  80206d:	c3                   	ret    

0080206e <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  80206e:	55                   	push   %ebp
  80206f:	89 e5                	mov    %esp,%ebp
  802071:	83 ec 04             	sub    $0x4,%esp
  802074:	8b 45 10             	mov    0x10(%ebp),%eax
  802077:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  80207a:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  80207e:	8b 45 08             	mov    0x8(%ebp),%eax
  802081:	6a 00                	push   $0x0
  802083:	6a 00                	push   $0x0
  802085:	52                   	push   %edx
  802086:	ff 75 0c             	pushl  0xc(%ebp)
  802089:	50                   	push   %eax
  80208a:	6a 00                	push   $0x0
  80208c:	e8 b2 ff ff ff       	call   802043 <syscall>
  802091:	83 c4 18             	add    $0x18,%esp
}
  802094:	90                   	nop
  802095:	c9                   	leave  
  802096:	c3                   	ret    

00802097 <sys_cgetc>:

int
sys_cgetc(void)
{
  802097:	55                   	push   %ebp
  802098:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  80209a:	6a 00                	push   $0x0
  80209c:	6a 00                	push   $0x0
  80209e:	6a 00                	push   $0x0
  8020a0:	6a 00                	push   $0x0
  8020a2:	6a 00                	push   $0x0
  8020a4:	6a 01                	push   $0x1
  8020a6:	e8 98 ff ff ff       	call   802043 <syscall>
  8020ab:	83 c4 18             	add    $0x18,%esp
}
  8020ae:	c9                   	leave  
  8020af:	c3                   	ret    

008020b0 <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  8020b0:	55                   	push   %ebp
  8020b1:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  8020b3:	8b 55 0c             	mov    0xc(%ebp),%edx
  8020b6:	8b 45 08             	mov    0x8(%ebp),%eax
  8020b9:	6a 00                	push   $0x0
  8020bb:	6a 00                	push   $0x0
  8020bd:	6a 00                	push   $0x0
  8020bf:	52                   	push   %edx
  8020c0:	50                   	push   %eax
  8020c1:	6a 05                	push   $0x5
  8020c3:	e8 7b ff ff ff       	call   802043 <syscall>
  8020c8:	83 c4 18             	add    $0x18,%esp
}
  8020cb:	c9                   	leave  
  8020cc:	c3                   	ret    

008020cd <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  8020cd:	55                   	push   %ebp
  8020ce:	89 e5                	mov    %esp,%ebp
  8020d0:	56                   	push   %esi
  8020d1:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  8020d2:	8b 75 18             	mov    0x18(%ebp),%esi
  8020d5:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8020d8:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8020db:	8b 55 0c             	mov    0xc(%ebp),%edx
  8020de:	8b 45 08             	mov    0x8(%ebp),%eax
  8020e1:	56                   	push   %esi
  8020e2:	53                   	push   %ebx
  8020e3:	51                   	push   %ecx
  8020e4:	52                   	push   %edx
  8020e5:	50                   	push   %eax
  8020e6:	6a 06                	push   $0x6
  8020e8:	e8 56 ff ff ff       	call   802043 <syscall>
  8020ed:	83 c4 18             	add    $0x18,%esp
}
  8020f0:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8020f3:	5b                   	pop    %ebx
  8020f4:	5e                   	pop    %esi
  8020f5:	5d                   	pop    %ebp
  8020f6:	c3                   	ret    

008020f7 <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  8020f7:	55                   	push   %ebp
  8020f8:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  8020fa:	8b 55 0c             	mov    0xc(%ebp),%edx
  8020fd:	8b 45 08             	mov    0x8(%ebp),%eax
  802100:	6a 00                	push   $0x0
  802102:	6a 00                	push   $0x0
  802104:	6a 00                	push   $0x0
  802106:	52                   	push   %edx
  802107:	50                   	push   %eax
  802108:	6a 07                	push   $0x7
  80210a:	e8 34 ff ff ff       	call   802043 <syscall>
  80210f:	83 c4 18             	add    $0x18,%esp
}
  802112:	c9                   	leave  
  802113:	c3                   	ret    

00802114 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  802114:	55                   	push   %ebp
  802115:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  802117:	6a 00                	push   $0x0
  802119:	6a 00                	push   $0x0
  80211b:	6a 00                	push   $0x0
  80211d:	ff 75 0c             	pushl  0xc(%ebp)
  802120:	ff 75 08             	pushl  0x8(%ebp)
  802123:	6a 08                	push   $0x8
  802125:	e8 19 ff ff ff       	call   802043 <syscall>
  80212a:	83 c4 18             	add    $0x18,%esp
}
  80212d:	c9                   	leave  
  80212e:	c3                   	ret    

0080212f <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  80212f:	55                   	push   %ebp
  802130:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  802132:	6a 00                	push   $0x0
  802134:	6a 00                	push   $0x0
  802136:	6a 00                	push   $0x0
  802138:	6a 00                	push   $0x0
  80213a:	6a 00                	push   $0x0
  80213c:	6a 09                	push   $0x9
  80213e:	e8 00 ff ff ff       	call   802043 <syscall>
  802143:	83 c4 18             	add    $0x18,%esp
}
  802146:	c9                   	leave  
  802147:	c3                   	ret    

00802148 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  802148:	55                   	push   %ebp
  802149:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  80214b:	6a 00                	push   $0x0
  80214d:	6a 00                	push   $0x0
  80214f:	6a 00                	push   $0x0
  802151:	6a 00                	push   $0x0
  802153:	6a 00                	push   $0x0
  802155:	6a 0a                	push   $0xa
  802157:	e8 e7 fe ff ff       	call   802043 <syscall>
  80215c:	83 c4 18             	add    $0x18,%esp
}
  80215f:	c9                   	leave  
  802160:	c3                   	ret    

00802161 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  802161:	55                   	push   %ebp
  802162:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  802164:	6a 00                	push   $0x0
  802166:	6a 00                	push   $0x0
  802168:	6a 00                	push   $0x0
  80216a:	6a 00                	push   $0x0
  80216c:	6a 00                	push   $0x0
  80216e:	6a 0b                	push   $0xb
  802170:	e8 ce fe ff ff       	call   802043 <syscall>
  802175:	83 c4 18             	add    $0x18,%esp
}
  802178:	c9                   	leave  
  802179:	c3                   	ret    

0080217a <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  80217a:	55                   	push   %ebp
  80217b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  80217d:	6a 00                	push   $0x0
  80217f:	6a 00                	push   $0x0
  802181:	6a 00                	push   $0x0
  802183:	ff 75 0c             	pushl  0xc(%ebp)
  802186:	ff 75 08             	pushl  0x8(%ebp)
  802189:	6a 0f                	push   $0xf
  80218b:	e8 b3 fe ff ff       	call   802043 <syscall>
  802190:	83 c4 18             	add    $0x18,%esp
	return;
  802193:	90                   	nop
}
  802194:	c9                   	leave  
  802195:	c3                   	ret    

00802196 <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  802196:	55                   	push   %ebp
  802197:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  802199:	6a 00                	push   $0x0
  80219b:	6a 00                	push   $0x0
  80219d:	6a 00                	push   $0x0
  80219f:	ff 75 0c             	pushl  0xc(%ebp)
  8021a2:	ff 75 08             	pushl  0x8(%ebp)
  8021a5:	6a 10                	push   $0x10
  8021a7:	e8 97 fe ff ff       	call   802043 <syscall>
  8021ac:	83 c4 18             	add    $0x18,%esp
	return ;
  8021af:	90                   	nop
}
  8021b0:	c9                   	leave  
  8021b1:	c3                   	ret    

008021b2 <sys_allocate_chunk>:

void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  8021b2:	55                   	push   %ebp
  8021b3:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  8021b5:	6a 00                	push   $0x0
  8021b7:	6a 00                	push   $0x0
  8021b9:	ff 75 10             	pushl  0x10(%ebp)
  8021bc:	ff 75 0c             	pushl  0xc(%ebp)
  8021bf:	ff 75 08             	pushl  0x8(%ebp)
  8021c2:	6a 11                	push   $0x11
  8021c4:	e8 7a fe ff ff       	call   802043 <syscall>
  8021c9:	83 c4 18             	add    $0x18,%esp
	return ;
  8021cc:	90                   	nop
}
  8021cd:	c9                   	leave  
  8021ce:	c3                   	ret    

008021cf <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  8021cf:	55                   	push   %ebp
  8021d0:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  8021d2:	6a 00                	push   $0x0
  8021d4:	6a 00                	push   $0x0
  8021d6:	6a 00                	push   $0x0
  8021d8:	6a 00                	push   $0x0
  8021da:	6a 00                	push   $0x0
  8021dc:	6a 0c                	push   $0xc
  8021de:	e8 60 fe ff ff       	call   802043 <syscall>
  8021e3:	83 c4 18             	add    $0x18,%esp
}
  8021e6:	c9                   	leave  
  8021e7:	c3                   	ret    

008021e8 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  8021e8:	55                   	push   %ebp
  8021e9:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  8021eb:	6a 00                	push   $0x0
  8021ed:	6a 00                	push   $0x0
  8021ef:	6a 00                	push   $0x0
  8021f1:	6a 00                	push   $0x0
  8021f3:	ff 75 08             	pushl  0x8(%ebp)
  8021f6:	6a 0d                	push   $0xd
  8021f8:	e8 46 fe ff ff       	call   802043 <syscall>
  8021fd:	83 c4 18             	add    $0x18,%esp
}
  802200:	c9                   	leave  
  802201:	c3                   	ret    

00802202 <sys_scarce_memory>:

void sys_scarce_memory()
{
  802202:	55                   	push   %ebp
  802203:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  802205:	6a 00                	push   $0x0
  802207:	6a 00                	push   $0x0
  802209:	6a 00                	push   $0x0
  80220b:	6a 00                	push   $0x0
  80220d:	6a 00                	push   $0x0
  80220f:	6a 0e                	push   $0xe
  802211:	e8 2d fe ff ff       	call   802043 <syscall>
  802216:	83 c4 18             	add    $0x18,%esp
}
  802219:	90                   	nop
  80221a:	c9                   	leave  
  80221b:	c3                   	ret    

0080221c <sys_disable_interrupt>:

//NEW !! 2012...
void
sys_disable_interrupt()
{
  80221c:	55                   	push   %ebp
  80221d:	89 e5                	mov    %esp,%ebp
	syscall(SYS_disableINTR,0, 0, 0, 0, 0);
  80221f:	6a 00                	push   $0x0
  802221:	6a 00                	push   $0x0
  802223:	6a 00                	push   $0x0
  802225:	6a 00                	push   $0x0
  802227:	6a 00                	push   $0x0
  802229:	6a 13                	push   $0x13
  80222b:	e8 13 fe ff ff       	call   802043 <syscall>
  802230:	83 c4 18             	add    $0x18,%esp
}
  802233:	90                   	nop
  802234:	c9                   	leave  
  802235:	c3                   	ret    

00802236 <sys_enable_interrupt>:


void
sys_enable_interrupt()
{
  802236:	55                   	push   %ebp
  802237:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enableINTR,0, 0, 0, 0, 0);
  802239:	6a 00                	push   $0x0
  80223b:	6a 00                	push   $0x0
  80223d:	6a 00                	push   $0x0
  80223f:	6a 00                	push   $0x0
  802241:	6a 00                	push   $0x0
  802243:	6a 14                	push   $0x14
  802245:	e8 f9 fd ff ff       	call   802043 <syscall>
  80224a:	83 c4 18             	add    $0x18,%esp
}
  80224d:	90                   	nop
  80224e:	c9                   	leave  
  80224f:	c3                   	ret    

00802250 <sys_cputc>:


void
sys_cputc(const char c)
{
  802250:	55                   	push   %ebp
  802251:	89 e5                	mov    %esp,%ebp
  802253:	83 ec 04             	sub    $0x4,%esp
  802256:	8b 45 08             	mov    0x8(%ebp),%eax
  802259:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  80225c:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  802260:	6a 00                	push   $0x0
  802262:	6a 00                	push   $0x0
  802264:	6a 00                	push   $0x0
  802266:	6a 00                	push   $0x0
  802268:	50                   	push   %eax
  802269:	6a 15                	push   $0x15
  80226b:	e8 d3 fd ff ff       	call   802043 <syscall>
  802270:	83 c4 18             	add    $0x18,%esp
}
  802273:	90                   	nop
  802274:	c9                   	leave  
  802275:	c3                   	ret    

00802276 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  802276:	55                   	push   %ebp
  802277:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  802279:	6a 00                	push   $0x0
  80227b:	6a 00                	push   $0x0
  80227d:	6a 00                	push   $0x0
  80227f:	6a 00                	push   $0x0
  802281:	6a 00                	push   $0x0
  802283:	6a 16                	push   $0x16
  802285:	e8 b9 fd ff ff       	call   802043 <syscall>
  80228a:	83 c4 18             	add    $0x18,%esp
}
  80228d:	90                   	nop
  80228e:	c9                   	leave  
  80228f:	c3                   	ret    

00802290 <sys_createSemaphore>:

int
sys_createSemaphore(char* semaphoreName, uint32 initialValue)
{
  802290:	55                   	push   %ebp
  802291:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_semaphore,(uint32)semaphoreName, (uint32)initialValue, 0, 0, 0);
  802293:	8b 45 08             	mov    0x8(%ebp),%eax
  802296:	6a 00                	push   $0x0
  802298:	6a 00                	push   $0x0
  80229a:	6a 00                	push   $0x0
  80229c:	ff 75 0c             	pushl  0xc(%ebp)
  80229f:	50                   	push   %eax
  8022a0:	6a 17                	push   $0x17
  8022a2:	e8 9c fd ff ff       	call   802043 <syscall>
  8022a7:	83 c4 18             	add    $0x18,%esp
}
  8022aa:	c9                   	leave  
  8022ab:	c3                   	ret    

008022ac <sys_getSemaphoreValue>:

int
sys_getSemaphoreValue(int32 ownerEnvID, char* semaphoreName)
{
  8022ac:	55                   	push   %ebp
  8022ad:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_semaphore_value,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  8022af:	8b 55 0c             	mov    0xc(%ebp),%edx
  8022b2:	8b 45 08             	mov    0x8(%ebp),%eax
  8022b5:	6a 00                	push   $0x0
  8022b7:	6a 00                	push   $0x0
  8022b9:	6a 00                	push   $0x0
  8022bb:	52                   	push   %edx
  8022bc:	50                   	push   %eax
  8022bd:	6a 1a                	push   $0x1a
  8022bf:	e8 7f fd ff ff       	call   802043 <syscall>
  8022c4:	83 c4 18             	add    $0x18,%esp
}
  8022c7:	c9                   	leave  
  8022c8:	c3                   	ret    

008022c9 <sys_waitSemaphore>:

void
sys_waitSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  8022c9:	55                   	push   %ebp
  8022ca:	89 e5                	mov    %esp,%ebp
	syscall(SYS_wait_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  8022cc:	8b 55 0c             	mov    0xc(%ebp),%edx
  8022cf:	8b 45 08             	mov    0x8(%ebp),%eax
  8022d2:	6a 00                	push   $0x0
  8022d4:	6a 00                	push   $0x0
  8022d6:	6a 00                	push   $0x0
  8022d8:	52                   	push   %edx
  8022d9:	50                   	push   %eax
  8022da:	6a 18                	push   $0x18
  8022dc:	e8 62 fd ff ff       	call   802043 <syscall>
  8022e1:	83 c4 18             	add    $0x18,%esp
}
  8022e4:	90                   	nop
  8022e5:	c9                   	leave  
  8022e6:	c3                   	ret    

008022e7 <sys_signalSemaphore>:

void
sys_signalSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  8022e7:	55                   	push   %ebp
  8022e8:	89 e5                	mov    %esp,%ebp
	syscall(SYS_signal_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  8022ea:	8b 55 0c             	mov    0xc(%ebp),%edx
  8022ed:	8b 45 08             	mov    0x8(%ebp),%eax
  8022f0:	6a 00                	push   $0x0
  8022f2:	6a 00                	push   $0x0
  8022f4:	6a 00                	push   $0x0
  8022f6:	52                   	push   %edx
  8022f7:	50                   	push   %eax
  8022f8:	6a 19                	push   $0x19
  8022fa:	e8 44 fd ff ff       	call   802043 <syscall>
  8022ff:	83 c4 18             	add    $0x18,%esp
}
  802302:	90                   	nop
  802303:	c9                   	leave  
  802304:	c3                   	ret    

00802305 <sys_createSharedObject>:

int
sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  802305:	55                   	push   %ebp
  802306:	89 e5                	mov    %esp,%ebp
  802308:	83 ec 04             	sub    $0x4,%esp
  80230b:	8b 45 10             	mov    0x10(%ebp),%eax
  80230e:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  802311:	8b 4d 14             	mov    0x14(%ebp),%ecx
  802314:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  802318:	8b 45 08             	mov    0x8(%ebp),%eax
  80231b:	6a 00                	push   $0x0
  80231d:	51                   	push   %ecx
  80231e:	52                   	push   %edx
  80231f:	ff 75 0c             	pushl  0xc(%ebp)
  802322:	50                   	push   %eax
  802323:	6a 1b                	push   $0x1b
  802325:	e8 19 fd ff ff       	call   802043 <syscall>
  80232a:	83 c4 18             	add    $0x18,%esp
}
  80232d:	c9                   	leave  
  80232e:	c3                   	ret    

0080232f <sys_getSizeOfSharedObject>:

//2017:
int
sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  80232f:	55                   	push   %ebp
  802330:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  802332:	8b 55 0c             	mov    0xc(%ebp),%edx
  802335:	8b 45 08             	mov    0x8(%ebp),%eax
  802338:	6a 00                	push   $0x0
  80233a:	6a 00                	push   $0x0
  80233c:	6a 00                	push   $0x0
  80233e:	52                   	push   %edx
  80233f:	50                   	push   %eax
  802340:	6a 1c                	push   $0x1c
  802342:	e8 fc fc ff ff       	call   802043 <syscall>
  802347:	83 c4 18             	add    $0x18,%esp
}
  80234a:	c9                   	leave  
  80234b:	c3                   	ret    

0080234c <sys_getSharedObject>:
//==========

int
sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  80234c:	55                   	push   %ebp
  80234d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  80234f:	8b 4d 10             	mov    0x10(%ebp),%ecx
  802352:	8b 55 0c             	mov    0xc(%ebp),%edx
  802355:	8b 45 08             	mov    0x8(%ebp),%eax
  802358:	6a 00                	push   $0x0
  80235a:	6a 00                	push   $0x0
  80235c:	51                   	push   %ecx
  80235d:	52                   	push   %edx
  80235e:	50                   	push   %eax
  80235f:	6a 1d                	push   $0x1d
  802361:	e8 dd fc ff ff       	call   802043 <syscall>
  802366:	83 c4 18             	add    $0x18,%esp
}
  802369:	c9                   	leave  
  80236a:	c3                   	ret    

0080236b <sys_freeSharedObject>:

int
sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  80236b:	55                   	push   %ebp
  80236c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  80236e:	8b 55 0c             	mov    0xc(%ebp),%edx
  802371:	8b 45 08             	mov    0x8(%ebp),%eax
  802374:	6a 00                	push   $0x0
  802376:	6a 00                	push   $0x0
  802378:	6a 00                	push   $0x0
  80237a:	52                   	push   %edx
  80237b:	50                   	push   %eax
  80237c:	6a 1e                	push   $0x1e
  80237e:	e8 c0 fc ff ff       	call   802043 <syscall>
  802383:	83 c4 18             	add    $0x18,%esp
}
  802386:	c9                   	leave  
  802387:	c3                   	ret    

00802388 <sys_getMaxShares>:

uint32 	sys_getMaxShares()
{
  802388:	55                   	push   %ebp
  802389:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_max_shares,0, 0, 0, 0, 0);
  80238b:	6a 00                	push   $0x0
  80238d:	6a 00                	push   $0x0
  80238f:	6a 00                	push   $0x0
  802391:	6a 00                	push   $0x0
  802393:	6a 00                	push   $0x0
  802395:	6a 1f                	push   $0x1f
  802397:	e8 a7 fc ff ff       	call   802043 <syscall>
  80239c:	83 c4 18             	add    $0x18,%esp
}
  80239f:	c9                   	leave  
  8023a0:	c3                   	ret    

008023a1 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  8023a1:	55                   	push   %ebp
  8023a2:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  8023a4:	8b 45 08             	mov    0x8(%ebp),%eax
  8023a7:	6a 00                	push   $0x0
  8023a9:	ff 75 14             	pushl  0x14(%ebp)
  8023ac:	ff 75 10             	pushl  0x10(%ebp)
  8023af:	ff 75 0c             	pushl  0xc(%ebp)
  8023b2:	50                   	push   %eax
  8023b3:	6a 20                	push   $0x20
  8023b5:	e8 89 fc ff ff       	call   802043 <syscall>
  8023ba:	83 c4 18             	add    $0x18,%esp
}
  8023bd:	c9                   	leave  
  8023be:	c3                   	ret    

008023bf <sys_run_env>:

void
sys_run_env(int32 envId)
{
  8023bf:	55                   	push   %ebp
  8023c0:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  8023c2:	8b 45 08             	mov    0x8(%ebp),%eax
  8023c5:	6a 00                	push   $0x0
  8023c7:	6a 00                	push   $0x0
  8023c9:	6a 00                	push   $0x0
  8023cb:	6a 00                	push   $0x0
  8023cd:	50                   	push   %eax
  8023ce:	6a 21                	push   $0x21
  8023d0:	e8 6e fc ff ff       	call   802043 <syscall>
  8023d5:	83 c4 18             	add    $0x18,%esp
}
  8023d8:	90                   	nop
  8023d9:	c9                   	leave  
  8023da:	c3                   	ret    

008023db <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  8023db:	55                   	push   %ebp
  8023dc:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  8023de:	8b 45 08             	mov    0x8(%ebp),%eax
  8023e1:	6a 00                	push   $0x0
  8023e3:	6a 00                	push   $0x0
  8023e5:	6a 00                	push   $0x0
  8023e7:	6a 00                	push   $0x0
  8023e9:	50                   	push   %eax
  8023ea:	6a 22                	push   $0x22
  8023ec:	e8 52 fc ff ff       	call   802043 <syscall>
  8023f1:	83 c4 18             	add    $0x18,%esp
}
  8023f4:	c9                   	leave  
  8023f5:	c3                   	ret    

008023f6 <sys_getenvid>:

int32 sys_getenvid(void)
{
  8023f6:	55                   	push   %ebp
  8023f7:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  8023f9:	6a 00                	push   $0x0
  8023fb:	6a 00                	push   $0x0
  8023fd:	6a 00                	push   $0x0
  8023ff:	6a 00                	push   $0x0
  802401:	6a 00                	push   $0x0
  802403:	6a 02                	push   $0x2
  802405:	e8 39 fc ff ff       	call   802043 <syscall>
  80240a:	83 c4 18             	add    $0x18,%esp
}
  80240d:	c9                   	leave  
  80240e:	c3                   	ret    

0080240f <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  80240f:	55                   	push   %ebp
  802410:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  802412:	6a 00                	push   $0x0
  802414:	6a 00                	push   $0x0
  802416:	6a 00                	push   $0x0
  802418:	6a 00                	push   $0x0
  80241a:	6a 00                	push   $0x0
  80241c:	6a 03                	push   $0x3
  80241e:	e8 20 fc ff ff       	call   802043 <syscall>
  802423:	83 c4 18             	add    $0x18,%esp
}
  802426:	c9                   	leave  
  802427:	c3                   	ret    

00802428 <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  802428:	55                   	push   %ebp
  802429:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  80242b:	6a 00                	push   $0x0
  80242d:	6a 00                	push   $0x0
  80242f:	6a 00                	push   $0x0
  802431:	6a 00                	push   $0x0
  802433:	6a 00                	push   $0x0
  802435:	6a 04                	push   $0x4
  802437:	e8 07 fc ff ff       	call   802043 <syscall>
  80243c:	83 c4 18             	add    $0x18,%esp
}
  80243f:	c9                   	leave  
  802440:	c3                   	ret    

00802441 <sys_exit_env>:


void sys_exit_env(void)
{
  802441:	55                   	push   %ebp
  802442:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  802444:	6a 00                	push   $0x0
  802446:	6a 00                	push   $0x0
  802448:	6a 00                	push   $0x0
  80244a:	6a 00                	push   $0x0
  80244c:	6a 00                	push   $0x0
  80244e:	6a 23                	push   $0x23
  802450:	e8 ee fb ff ff       	call   802043 <syscall>
  802455:	83 c4 18             	add    $0x18,%esp
}
  802458:	90                   	nop
  802459:	c9                   	leave  
  80245a:	c3                   	ret    

0080245b <sys_get_virtual_time>:


struct uint64
sys_get_virtual_time()
{
  80245b:	55                   	push   %ebp
  80245c:	89 e5                	mov    %esp,%ebp
  80245e:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  802461:	8d 45 f8             	lea    -0x8(%ebp),%eax
  802464:	8d 50 04             	lea    0x4(%eax),%edx
  802467:	8d 45 f8             	lea    -0x8(%ebp),%eax
  80246a:	6a 00                	push   $0x0
  80246c:	6a 00                	push   $0x0
  80246e:	6a 00                	push   $0x0
  802470:	52                   	push   %edx
  802471:	50                   	push   %eax
  802472:	6a 24                	push   $0x24
  802474:	e8 ca fb ff ff       	call   802043 <syscall>
  802479:	83 c4 18             	add    $0x18,%esp
	return result;
  80247c:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80247f:	8b 45 f8             	mov    -0x8(%ebp),%eax
  802482:	8b 55 fc             	mov    -0x4(%ebp),%edx
  802485:	89 01                	mov    %eax,(%ecx)
  802487:	89 51 04             	mov    %edx,0x4(%ecx)
}
  80248a:	8b 45 08             	mov    0x8(%ebp),%eax
  80248d:	c9                   	leave  
  80248e:	c2 04 00             	ret    $0x4

00802491 <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  802491:	55                   	push   %ebp
  802492:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  802494:	6a 00                	push   $0x0
  802496:	6a 00                	push   $0x0
  802498:	ff 75 10             	pushl  0x10(%ebp)
  80249b:	ff 75 0c             	pushl  0xc(%ebp)
  80249e:	ff 75 08             	pushl  0x8(%ebp)
  8024a1:	6a 12                	push   $0x12
  8024a3:	e8 9b fb ff ff       	call   802043 <syscall>
  8024a8:	83 c4 18             	add    $0x18,%esp
	return ;
  8024ab:	90                   	nop
}
  8024ac:	c9                   	leave  
  8024ad:	c3                   	ret    

008024ae <sys_rcr2>:
uint32 sys_rcr2()
{
  8024ae:	55                   	push   %ebp
  8024af:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  8024b1:	6a 00                	push   $0x0
  8024b3:	6a 00                	push   $0x0
  8024b5:	6a 00                	push   $0x0
  8024b7:	6a 00                	push   $0x0
  8024b9:	6a 00                	push   $0x0
  8024bb:	6a 25                	push   $0x25
  8024bd:	e8 81 fb ff ff       	call   802043 <syscall>
  8024c2:	83 c4 18             	add    $0x18,%esp
}
  8024c5:	c9                   	leave  
  8024c6:	c3                   	ret    

008024c7 <sys_bypassPageFault>:
void sys_bypassPageFault(uint8 instrLength)
{
  8024c7:	55                   	push   %ebp
  8024c8:	89 e5                	mov    %esp,%ebp
  8024ca:	83 ec 04             	sub    $0x4,%esp
  8024cd:	8b 45 08             	mov    0x8(%ebp),%eax
  8024d0:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  8024d3:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  8024d7:	6a 00                	push   $0x0
  8024d9:	6a 00                	push   $0x0
  8024db:	6a 00                	push   $0x0
  8024dd:	6a 00                	push   $0x0
  8024df:	50                   	push   %eax
  8024e0:	6a 26                	push   $0x26
  8024e2:	e8 5c fb ff ff       	call   802043 <syscall>
  8024e7:	83 c4 18             	add    $0x18,%esp
	return ;
  8024ea:	90                   	nop
}
  8024eb:	c9                   	leave  
  8024ec:	c3                   	ret    

008024ed <rsttst>:
void rsttst()
{
  8024ed:	55                   	push   %ebp
  8024ee:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  8024f0:	6a 00                	push   $0x0
  8024f2:	6a 00                	push   $0x0
  8024f4:	6a 00                	push   $0x0
  8024f6:	6a 00                	push   $0x0
  8024f8:	6a 00                	push   $0x0
  8024fa:	6a 28                	push   $0x28
  8024fc:	e8 42 fb ff ff       	call   802043 <syscall>
  802501:	83 c4 18             	add    $0x18,%esp
	return ;
  802504:	90                   	nop
}
  802505:	c9                   	leave  
  802506:	c3                   	ret    

00802507 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  802507:	55                   	push   %ebp
  802508:	89 e5                	mov    %esp,%ebp
  80250a:	83 ec 04             	sub    $0x4,%esp
  80250d:	8b 45 14             	mov    0x14(%ebp),%eax
  802510:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  802513:	8b 55 18             	mov    0x18(%ebp),%edx
  802516:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  80251a:	52                   	push   %edx
  80251b:	50                   	push   %eax
  80251c:	ff 75 10             	pushl  0x10(%ebp)
  80251f:	ff 75 0c             	pushl  0xc(%ebp)
  802522:	ff 75 08             	pushl  0x8(%ebp)
  802525:	6a 27                	push   $0x27
  802527:	e8 17 fb ff ff       	call   802043 <syscall>
  80252c:	83 c4 18             	add    $0x18,%esp
	return ;
  80252f:	90                   	nop
}
  802530:	c9                   	leave  
  802531:	c3                   	ret    

00802532 <chktst>:
void chktst(uint32 n)
{
  802532:	55                   	push   %ebp
  802533:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  802535:	6a 00                	push   $0x0
  802537:	6a 00                	push   $0x0
  802539:	6a 00                	push   $0x0
  80253b:	6a 00                	push   $0x0
  80253d:	ff 75 08             	pushl  0x8(%ebp)
  802540:	6a 29                	push   $0x29
  802542:	e8 fc fa ff ff       	call   802043 <syscall>
  802547:	83 c4 18             	add    $0x18,%esp
	return ;
  80254a:	90                   	nop
}
  80254b:	c9                   	leave  
  80254c:	c3                   	ret    

0080254d <inctst>:

void inctst()
{
  80254d:	55                   	push   %ebp
  80254e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  802550:	6a 00                	push   $0x0
  802552:	6a 00                	push   $0x0
  802554:	6a 00                	push   $0x0
  802556:	6a 00                	push   $0x0
  802558:	6a 00                	push   $0x0
  80255a:	6a 2a                	push   $0x2a
  80255c:	e8 e2 fa ff ff       	call   802043 <syscall>
  802561:	83 c4 18             	add    $0x18,%esp
	return ;
  802564:	90                   	nop
}
  802565:	c9                   	leave  
  802566:	c3                   	ret    

00802567 <gettst>:
uint32 gettst()
{
  802567:	55                   	push   %ebp
  802568:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  80256a:	6a 00                	push   $0x0
  80256c:	6a 00                	push   $0x0
  80256e:	6a 00                	push   $0x0
  802570:	6a 00                	push   $0x0
  802572:	6a 00                	push   $0x0
  802574:	6a 2b                	push   $0x2b
  802576:	e8 c8 fa ff ff       	call   802043 <syscall>
  80257b:	83 c4 18             	add    $0x18,%esp
}
  80257e:	c9                   	leave  
  80257f:	c3                   	ret    

00802580 <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  802580:	55                   	push   %ebp
  802581:	89 e5                	mov    %esp,%ebp
  802583:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  802586:	6a 00                	push   $0x0
  802588:	6a 00                	push   $0x0
  80258a:	6a 00                	push   $0x0
  80258c:	6a 00                	push   $0x0
  80258e:	6a 00                	push   $0x0
  802590:	6a 2c                	push   $0x2c
  802592:	e8 ac fa ff ff       	call   802043 <syscall>
  802597:	83 c4 18             	add    $0x18,%esp
  80259a:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  80259d:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  8025a1:	75 07                	jne    8025aa <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  8025a3:	b8 01 00 00 00       	mov    $0x1,%eax
  8025a8:	eb 05                	jmp    8025af <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  8025aa:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8025af:	c9                   	leave  
  8025b0:	c3                   	ret    

008025b1 <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  8025b1:	55                   	push   %ebp
  8025b2:	89 e5                	mov    %esp,%ebp
  8025b4:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8025b7:	6a 00                	push   $0x0
  8025b9:	6a 00                	push   $0x0
  8025bb:	6a 00                	push   $0x0
  8025bd:	6a 00                	push   $0x0
  8025bf:	6a 00                	push   $0x0
  8025c1:	6a 2c                	push   $0x2c
  8025c3:	e8 7b fa ff ff       	call   802043 <syscall>
  8025c8:	83 c4 18             	add    $0x18,%esp
  8025cb:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  8025ce:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  8025d2:	75 07                	jne    8025db <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  8025d4:	b8 01 00 00 00       	mov    $0x1,%eax
  8025d9:	eb 05                	jmp    8025e0 <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  8025db:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8025e0:	c9                   	leave  
  8025e1:	c3                   	ret    

008025e2 <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  8025e2:	55                   	push   %ebp
  8025e3:	89 e5                	mov    %esp,%ebp
  8025e5:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8025e8:	6a 00                	push   $0x0
  8025ea:	6a 00                	push   $0x0
  8025ec:	6a 00                	push   $0x0
  8025ee:	6a 00                	push   $0x0
  8025f0:	6a 00                	push   $0x0
  8025f2:	6a 2c                	push   $0x2c
  8025f4:	e8 4a fa ff ff       	call   802043 <syscall>
  8025f9:	83 c4 18             	add    $0x18,%esp
  8025fc:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  8025ff:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  802603:	75 07                	jne    80260c <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  802605:	b8 01 00 00 00       	mov    $0x1,%eax
  80260a:	eb 05                	jmp    802611 <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  80260c:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802611:	c9                   	leave  
  802612:	c3                   	ret    

00802613 <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  802613:	55                   	push   %ebp
  802614:	89 e5                	mov    %esp,%ebp
  802616:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  802619:	6a 00                	push   $0x0
  80261b:	6a 00                	push   $0x0
  80261d:	6a 00                	push   $0x0
  80261f:	6a 00                	push   $0x0
  802621:	6a 00                	push   $0x0
  802623:	6a 2c                	push   $0x2c
  802625:	e8 19 fa ff ff       	call   802043 <syscall>
  80262a:	83 c4 18             	add    $0x18,%esp
  80262d:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  802630:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  802634:	75 07                	jne    80263d <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  802636:	b8 01 00 00 00       	mov    $0x1,%eax
  80263b:	eb 05                	jmp    802642 <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  80263d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802642:	c9                   	leave  
  802643:	c3                   	ret    

00802644 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  802644:	55                   	push   %ebp
  802645:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  802647:	6a 00                	push   $0x0
  802649:	6a 00                	push   $0x0
  80264b:	6a 00                	push   $0x0
  80264d:	6a 00                	push   $0x0
  80264f:	ff 75 08             	pushl  0x8(%ebp)
  802652:	6a 2d                	push   $0x2d
  802654:	e8 ea f9 ff ff       	call   802043 <syscall>
  802659:	83 c4 18             	add    $0x18,%esp
	return ;
  80265c:	90                   	nop
}
  80265d:	c9                   	leave  
  80265e:	c3                   	ret    

0080265f <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  80265f:	55                   	push   %ebp
  802660:	89 e5                	mov    %esp,%ebp
  802662:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  802663:	8b 5d 14             	mov    0x14(%ebp),%ebx
  802666:	8b 4d 10             	mov    0x10(%ebp),%ecx
  802669:	8b 55 0c             	mov    0xc(%ebp),%edx
  80266c:	8b 45 08             	mov    0x8(%ebp),%eax
  80266f:	6a 00                	push   $0x0
  802671:	53                   	push   %ebx
  802672:	51                   	push   %ecx
  802673:	52                   	push   %edx
  802674:	50                   	push   %eax
  802675:	6a 2e                	push   $0x2e
  802677:	e8 c7 f9 ff ff       	call   802043 <syscall>
  80267c:	83 c4 18             	add    $0x18,%esp
}
  80267f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802682:	c9                   	leave  
  802683:	c3                   	ret    

00802684 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  802684:	55                   	push   %ebp
  802685:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  802687:	8b 55 0c             	mov    0xc(%ebp),%edx
  80268a:	8b 45 08             	mov    0x8(%ebp),%eax
  80268d:	6a 00                	push   $0x0
  80268f:	6a 00                	push   $0x0
  802691:	6a 00                	push   $0x0
  802693:	52                   	push   %edx
  802694:	50                   	push   %eax
  802695:	6a 2f                	push   $0x2f
  802697:	e8 a7 f9 ff ff       	call   802043 <syscall>
  80269c:	83 c4 18             	add    $0x18,%esp
}
  80269f:	c9                   	leave  
  8026a0:	c3                   	ret    

008026a1 <print_mem_block_lists>:
//===========================
// PRINT MEM BLOCK LISTS:
//===========================

void print_mem_block_lists()
{
  8026a1:	55                   	push   %ebp
  8026a2:	89 e5                	mov    %esp,%ebp
  8026a4:	83 ec 18             	sub    $0x18,%esp
	cprintf("\n=========================================\n");
  8026a7:	83 ec 0c             	sub    $0xc,%esp
  8026aa:	68 74 41 80 00       	push   $0x804174
  8026af:	e8 d7 e4 ff ff       	call   800b8b <cprintf>
  8026b4:	83 c4 10             	add    $0x10,%esp
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
  8026b7:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nFreeMemBlocksList:\n");
  8026be:	83 ec 0c             	sub    $0xc,%esp
  8026c1:	68 a0 41 80 00       	push   $0x8041a0
  8026c6:	e8 c0 e4 ff ff       	call   800b8b <cprintf>
  8026cb:	83 c4 10             	add    $0x10,%esp
	uint8 sorted = 1 ;
  8026ce:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &FreeMemBlocksList)
  8026d2:	a1 38 51 80 00       	mov    0x805138,%eax
  8026d7:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8026da:	eb 56                	jmp    802732 <print_mem_block_lists+0x91>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  8026dc:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8026e0:	74 1c                	je     8026fe <print_mem_block_lists+0x5d>
  8026e2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026e5:	8b 50 08             	mov    0x8(%eax),%edx
  8026e8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8026eb:	8b 48 08             	mov    0x8(%eax),%ecx
  8026ee:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8026f1:	8b 40 0c             	mov    0xc(%eax),%eax
  8026f4:	01 c8                	add    %ecx,%eax
  8026f6:	39 c2                	cmp    %eax,%edx
  8026f8:	73 04                	jae    8026fe <print_mem_block_lists+0x5d>
			sorted = 0 ;
  8026fa:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  8026fe:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802701:	8b 50 08             	mov    0x8(%eax),%edx
  802704:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802707:	8b 40 0c             	mov    0xc(%eax),%eax
  80270a:	01 c2                	add    %eax,%edx
  80270c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80270f:	8b 40 08             	mov    0x8(%eax),%eax
  802712:	83 ec 04             	sub    $0x4,%esp
  802715:	52                   	push   %edx
  802716:	50                   	push   %eax
  802717:	68 b5 41 80 00       	push   $0x8041b5
  80271c:	e8 6a e4 ff ff       	call   800b8b <cprintf>
  802721:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  802724:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802727:	89 45 f0             	mov    %eax,-0x10(%ebp)
	cprintf("\n=========================================\n");
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
	cprintf("\nFreeMemBlocksList:\n");
	uint8 sorted = 1 ;
	LIST_FOREACH(blk, &FreeMemBlocksList)
  80272a:	a1 40 51 80 00       	mov    0x805140,%eax
  80272f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802732:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802736:	74 07                	je     80273f <print_mem_block_lists+0x9e>
  802738:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80273b:	8b 00                	mov    (%eax),%eax
  80273d:	eb 05                	jmp    802744 <print_mem_block_lists+0xa3>
  80273f:	b8 00 00 00 00       	mov    $0x0,%eax
  802744:	a3 40 51 80 00       	mov    %eax,0x805140
  802749:	a1 40 51 80 00       	mov    0x805140,%eax
  80274e:	85 c0                	test   %eax,%eax
  802750:	75 8a                	jne    8026dc <print_mem_block_lists+0x3b>
  802752:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802756:	75 84                	jne    8026dc <print_mem_block_lists+0x3b>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;
  802758:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  80275c:	75 10                	jne    80276e <print_mem_block_lists+0xcd>
  80275e:	83 ec 0c             	sub    $0xc,%esp
  802761:	68 c4 41 80 00       	push   $0x8041c4
  802766:	e8 20 e4 ff ff       	call   800b8b <cprintf>
  80276b:	83 c4 10             	add    $0x10,%esp

	lastBlk = NULL ;
  80276e:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nAllocMemBlocksList:\n");
  802775:	83 ec 0c             	sub    $0xc,%esp
  802778:	68 e8 41 80 00       	push   $0x8041e8
  80277d:	e8 09 e4 ff ff       	call   800b8b <cprintf>
  802782:	83 c4 10             	add    $0x10,%esp
	sorted = 1 ;
  802785:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &AllocMemBlocksList)
  802789:	a1 40 50 80 00       	mov    0x805040,%eax
  80278e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802791:	eb 56                	jmp    8027e9 <print_mem_block_lists+0x148>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  802793:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802797:	74 1c                	je     8027b5 <print_mem_block_lists+0x114>
  802799:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80279c:	8b 50 08             	mov    0x8(%eax),%edx
  80279f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8027a2:	8b 48 08             	mov    0x8(%eax),%ecx
  8027a5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8027a8:	8b 40 0c             	mov    0xc(%eax),%eax
  8027ab:	01 c8                	add    %ecx,%eax
  8027ad:	39 c2                	cmp    %eax,%edx
  8027af:	73 04                	jae    8027b5 <print_mem_block_lists+0x114>
			sorted = 0 ;
  8027b1:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  8027b5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027b8:	8b 50 08             	mov    0x8(%eax),%edx
  8027bb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027be:	8b 40 0c             	mov    0xc(%eax),%eax
  8027c1:	01 c2                	add    %eax,%edx
  8027c3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027c6:	8b 40 08             	mov    0x8(%eax),%eax
  8027c9:	83 ec 04             	sub    $0x4,%esp
  8027cc:	52                   	push   %edx
  8027cd:	50                   	push   %eax
  8027ce:	68 b5 41 80 00       	push   $0x8041b5
  8027d3:	e8 b3 e3 ff ff       	call   800b8b <cprintf>
  8027d8:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  8027db:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027de:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;

	lastBlk = NULL ;
	cprintf("\nAllocMemBlocksList:\n");
	sorted = 1 ;
	LIST_FOREACH(blk, &AllocMemBlocksList)
  8027e1:	a1 48 50 80 00       	mov    0x805048,%eax
  8027e6:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8027e9:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8027ed:	74 07                	je     8027f6 <print_mem_block_lists+0x155>
  8027ef:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027f2:	8b 00                	mov    (%eax),%eax
  8027f4:	eb 05                	jmp    8027fb <print_mem_block_lists+0x15a>
  8027f6:	b8 00 00 00 00       	mov    $0x0,%eax
  8027fb:	a3 48 50 80 00       	mov    %eax,0x805048
  802800:	a1 48 50 80 00       	mov    0x805048,%eax
  802805:	85 c0                	test   %eax,%eax
  802807:	75 8a                	jne    802793 <print_mem_block_lists+0xf2>
  802809:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80280d:	75 84                	jne    802793 <print_mem_block_lists+0xf2>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nAllocMemBlocksList is NOT SORTED!!\n") ;
  80280f:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  802813:	75 10                	jne    802825 <print_mem_block_lists+0x184>
  802815:	83 ec 0c             	sub    $0xc,%esp
  802818:	68 00 42 80 00       	push   $0x804200
  80281d:	e8 69 e3 ff ff       	call   800b8b <cprintf>
  802822:	83 c4 10             	add    $0x10,%esp
	cprintf("\n=========================================\n");
  802825:	83 ec 0c             	sub    $0xc,%esp
  802828:	68 74 41 80 00       	push   $0x804174
  80282d:	e8 59 e3 ff ff       	call   800b8b <cprintf>
  802832:	83 c4 10             	add    $0x10,%esp

}
  802835:	90                   	nop
  802836:	c9                   	leave  
  802837:	c3                   	ret    

00802838 <initialize_MemBlocksList>:

//===============================
// [1] INITIALIZE AVAILABLE LIST:
//===============================
void initialize_MemBlocksList(uint32 numOfBlocks)
{
  802838:	55                   	push   %ebp
  802839:	89 e5                	mov    %esp,%ebp
  80283b:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] initialize_MemBlocksList
	// Write your code here, remove the panic and write your code
	//panic("initialize_MemBlocksList() is not implemented yet...!!");
	uint32 n = numOfBlocks;
  80283e:	8b 45 08             	mov    0x8(%ebp),%eax
  802841:	89 45 f0             	mov    %eax,-0x10(%ebp)

	LIST_INIT(&AvailableMemBlocksList);
  802844:	c7 05 48 51 80 00 00 	movl   $0x0,0x805148
  80284b:	00 00 00 
  80284e:	c7 05 4c 51 80 00 00 	movl   $0x0,0x80514c
  802855:	00 00 00 
  802858:	c7 05 54 51 80 00 00 	movl   $0x0,0x805154
  80285f:	00 00 00 
	for(int i = 0; i<n;i++)
  802862:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  802869:	e9 9e 00 00 00       	jmp    80290c <initialize_MemBlocksList+0xd4>
	{
		LIST_INSERT_HEAD(&AvailableMemBlocksList, &(MemBlockNodes[i]));
  80286e:	a1 50 50 80 00       	mov    0x805050,%eax
  802873:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802876:	c1 e2 04             	shl    $0x4,%edx
  802879:	01 d0                	add    %edx,%eax
  80287b:	85 c0                	test   %eax,%eax
  80287d:	75 14                	jne    802893 <initialize_MemBlocksList+0x5b>
  80287f:	83 ec 04             	sub    $0x4,%esp
  802882:	68 28 42 80 00       	push   $0x804228
  802887:	6a 47                	push   $0x47
  802889:	68 4b 42 80 00       	push   $0x80424b
  80288e:	e8 44 e0 ff ff       	call   8008d7 <_panic>
  802893:	a1 50 50 80 00       	mov    0x805050,%eax
  802898:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80289b:	c1 e2 04             	shl    $0x4,%edx
  80289e:	01 d0                	add    %edx,%eax
  8028a0:	8b 15 48 51 80 00    	mov    0x805148,%edx
  8028a6:	89 10                	mov    %edx,(%eax)
  8028a8:	8b 00                	mov    (%eax),%eax
  8028aa:	85 c0                	test   %eax,%eax
  8028ac:	74 18                	je     8028c6 <initialize_MemBlocksList+0x8e>
  8028ae:	a1 48 51 80 00       	mov    0x805148,%eax
  8028b3:	8b 15 50 50 80 00    	mov    0x805050,%edx
  8028b9:	8b 4d f4             	mov    -0xc(%ebp),%ecx
  8028bc:	c1 e1 04             	shl    $0x4,%ecx
  8028bf:	01 ca                	add    %ecx,%edx
  8028c1:	89 50 04             	mov    %edx,0x4(%eax)
  8028c4:	eb 12                	jmp    8028d8 <initialize_MemBlocksList+0xa0>
  8028c6:	a1 50 50 80 00       	mov    0x805050,%eax
  8028cb:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8028ce:	c1 e2 04             	shl    $0x4,%edx
  8028d1:	01 d0                	add    %edx,%eax
  8028d3:	a3 4c 51 80 00       	mov    %eax,0x80514c
  8028d8:	a1 50 50 80 00       	mov    0x805050,%eax
  8028dd:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8028e0:	c1 e2 04             	shl    $0x4,%edx
  8028e3:	01 d0                	add    %edx,%eax
  8028e5:	a3 48 51 80 00       	mov    %eax,0x805148
  8028ea:	a1 50 50 80 00       	mov    0x805050,%eax
  8028ef:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8028f2:	c1 e2 04             	shl    $0x4,%edx
  8028f5:	01 d0                	add    %edx,%eax
  8028f7:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8028fe:	a1 54 51 80 00       	mov    0x805154,%eax
  802903:	40                   	inc    %eax
  802904:	a3 54 51 80 00       	mov    %eax,0x805154
	// Write your code here, remove the panic and write your code
	//panic("initialize_MemBlocksList() is not implemented yet...!!");
	uint32 n = numOfBlocks;

	LIST_INIT(&AvailableMemBlocksList);
	for(int i = 0; i<n;i++)
  802909:	ff 45 f4             	incl   -0xc(%ebp)
  80290c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80290f:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  802912:	0f 82 56 ff ff ff    	jb     80286e <initialize_MemBlocksList+0x36>
	{
		LIST_INSERT_HEAD(&AvailableMemBlocksList, &(MemBlockNodes[i]));
	}
}
  802918:	90                   	nop
  802919:	c9                   	leave  
  80291a:	c3                   	ret    

0080291b <find_block>:

//===============================
// [2] FIND BLOCK:
//===============================
struct MemBlock *find_block(struct MemBlock_List *blockList, uint32 va)
{
  80291b:	55                   	push   %ebp
  80291c:	89 e5                	mov    %esp,%ebp
  80291e:	83 ec 10             	sub    $0x10,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] find_block
	// Write your code here, remove the panic and write your code
	//panic("find_block() is not implemented yet...!!");
	uint32 virAddress = va;
  802921:	8b 45 0c             	mov    0xc(%ebp),%eax
  802924:	89 45 f4             	mov    %eax,-0xc(%ebp)
	struct MemBlock* blk;
	int found = 0;
  802927:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	LIST_FOREACH(blk, &(AllocMemBlocksList))
  80292e:	a1 40 50 80 00       	mov    0x805040,%eax
  802933:	89 45 fc             	mov    %eax,-0x4(%ebp)
  802936:	eb 23                	jmp    80295b <find_block+0x40>
	{
		if(blk->sva == virAddress)
  802938:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80293b:	8b 40 08             	mov    0x8(%eax),%eax
  80293e:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  802941:	75 09                	jne    80294c <find_block+0x31>
		{
			found = 1;
  802943:	c7 45 f8 01 00 00 00 	movl   $0x1,-0x8(%ebp)
			break;
  80294a:	eb 35                	jmp    802981 <find_block+0x66>
		}
		else
		{
			found = 0;
  80294c:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	//panic("find_block() is not implemented yet...!!");
	uint32 virAddress = va;
	struct MemBlock* blk;
	int found = 0;

	LIST_FOREACH(blk, &(AllocMemBlocksList))
  802953:	a1 48 50 80 00       	mov    0x805048,%eax
  802958:	89 45 fc             	mov    %eax,-0x4(%ebp)
  80295b:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  80295f:	74 07                	je     802968 <find_block+0x4d>
  802961:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802964:	8b 00                	mov    (%eax),%eax
  802966:	eb 05                	jmp    80296d <find_block+0x52>
  802968:	b8 00 00 00 00       	mov    $0x0,%eax
  80296d:	a3 48 50 80 00       	mov    %eax,0x805048
  802972:	a1 48 50 80 00       	mov    0x805048,%eax
  802977:	85 c0                	test   %eax,%eax
  802979:	75 bd                	jne    802938 <find_block+0x1d>
  80297b:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  80297f:	75 b7                	jne    802938 <find_block+0x1d>
		{
			found = 0;
			continue;
		}
	}
	if(found == 1)
  802981:	83 7d f8 01          	cmpl   $0x1,-0x8(%ebp)
  802985:	75 05                	jne    80298c <find_block+0x71>
	{
		return blk;
  802987:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80298a:	eb 05                	jmp    802991 <find_block+0x76>
	}
	else
	{
		return NULL;
  80298c:	b8 00 00 00 00       	mov    $0x0,%eax
	}
}
  802991:	c9                   	leave  
  802992:	c3                   	ret    

00802993 <insert_sorted_allocList>:

//=========================================
// [3] INSERT BLOCK IN ALLOC LIST [SORTED]:
//=========================================
void insert_sorted_allocList(struct MemBlock *blockToInsert)
{
  802993:	55                   	push   %ebp
  802994:	89 e5                	mov    %esp,%ebp
  802996:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] insert_sorted_allocList
	// Write your code here, remove the panic and write your code
	//panic("insert_sorted_allocList() is not implemented yet...!!");
	struct MemBlock* blk;
	struct MemBlock* newblk = blockToInsert;
  802999:	8b 45 08             	mov    0x8(%ebp),%eax
  80299c:	89 45 f0             	mov    %eax,-0x10(%ebp)

	if((LIST_EMPTY(&AllocMemBlocksList)) || (newblk->sva < LIST_FIRST(&AllocMemBlocksList)->sva))
  80299f:	a1 40 50 80 00       	mov    0x805040,%eax
  8029a4:	85 c0                	test   %eax,%eax
  8029a6:	74 12                	je     8029ba <insert_sorted_allocList+0x27>
  8029a8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8029ab:	8b 50 08             	mov    0x8(%eax),%edx
  8029ae:	a1 40 50 80 00       	mov    0x805040,%eax
  8029b3:	8b 40 08             	mov    0x8(%eax),%eax
  8029b6:	39 c2                	cmp    %eax,%edx
  8029b8:	73 65                	jae    802a1f <insert_sorted_allocList+0x8c>
	{
		LIST_INSERT_HEAD(&(AllocMemBlocksList), newblk);
  8029ba:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8029be:	75 14                	jne    8029d4 <insert_sorted_allocList+0x41>
  8029c0:	83 ec 04             	sub    $0x4,%esp
  8029c3:	68 28 42 80 00       	push   $0x804228
  8029c8:	6a 7b                	push   $0x7b
  8029ca:	68 4b 42 80 00       	push   $0x80424b
  8029cf:	e8 03 df ff ff       	call   8008d7 <_panic>
  8029d4:	8b 15 40 50 80 00    	mov    0x805040,%edx
  8029da:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8029dd:	89 10                	mov    %edx,(%eax)
  8029df:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8029e2:	8b 00                	mov    (%eax),%eax
  8029e4:	85 c0                	test   %eax,%eax
  8029e6:	74 0d                	je     8029f5 <insert_sorted_allocList+0x62>
  8029e8:	a1 40 50 80 00       	mov    0x805040,%eax
  8029ed:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8029f0:	89 50 04             	mov    %edx,0x4(%eax)
  8029f3:	eb 08                	jmp    8029fd <insert_sorted_allocList+0x6a>
  8029f5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8029f8:	a3 44 50 80 00       	mov    %eax,0x805044
  8029fd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a00:	a3 40 50 80 00       	mov    %eax,0x805040
  802a05:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a08:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802a0f:	a1 4c 50 80 00       	mov    0x80504c,%eax
  802a14:	40                   	inc    %eax
  802a15:	a3 4c 50 80 00       	mov    %eax,0x80504c
  802a1a:	e9 5f 01 00 00       	jmp    802b7e <insert_sorted_allocList+0x1eb>
	}
	else if(newblk->sva > LIST_LAST(&AllocMemBlocksList)->sva)
  802a1f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a22:	8b 50 08             	mov    0x8(%eax),%edx
  802a25:	a1 44 50 80 00       	mov    0x805044,%eax
  802a2a:	8b 40 08             	mov    0x8(%eax),%eax
  802a2d:	39 c2                	cmp    %eax,%edx
  802a2f:	76 65                	jbe    802a96 <insert_sorted_allocList+0x103>
	{
		LIST_INSERT_TAIL(&AllocMemBlocksList, newblk);
  802a31:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802a35:	75 14                	jne    802a4b <insert_sorted_allocList+0xb8>
  802a37:	83 ec 04             	sub    $0x4,%esp
  802a3a:	68 64 42 80 00       	push   $0x804264
  802a3f:	6a 7f                	push   $0x7f
  802a41:	68 4b 42 80 00       	push   $0x80424b
  802a46:	e8 8c de ff ff       	call   8008d7 <_panic>
  802a4b:	8b 15 44 50 80 00    	mov    0x805044,%edx
  802a51:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a54:	89 50 04             	mov    %edx,0x4(%eax)
  802a57:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a5a:	8b 40 04             	mov    0x4(%eax),%eax
  802a5d:	85 c0                	test   %eax,%eax
  802a5f:	74 0c                	je     802a6d <insert_sorted_allocList+0xda>
  802a61:	a1 44 50 80 00       	mov    0x805044,%eax
  802a66:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802a69:	89 10                	mov    %edx,(%eax)
  802a6b:	eb 08                	jmp    802a75 <insert_sorted_allocList+0xe2>
  802a6d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a70:	a3 40 50 80 00       	mov    %eax,0x805040
  802a75:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a78:	a3 44 50 80 00       	mov    %eax,0x805044
  802a7d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a80:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802a86:	a1 4c 50 80 00       	mov    0x80504c,%eax
  802a8b:	40                   	inc    %eax
  802a8c:	a3 4c 50 80 00       	mov    %eax,0x80504c
				LIST_INSERT_AFTER(&AllocMemBlocksList, blk, newblk);
				break;
			}
		}
	}
}
  802a91:	e9 e8 00 00 00       	jmp    802b7e <insert_sorted_allocList+0x1eb>
	{
		LIST_INSERT_TAIL(&AllocMemBlocksList, newblk);
	}
	else
	{
		LIST_FOREACH(blk, &AllocMemBlocksList)
  802a96:	a1 40 50 80 00       	mov    0x805040,%eax
  802a9b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802a9e:	e9 ab 00 00 00       	jmp    802b4e <insert_sorted_allocList+0x1bb>
		{
			if(blk->prev_next_info.le_next != NULL && newblk->sva > blk->sva  && newblk->sva < blk->prev_next_info.le_next->sva)
  802aa3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802aa6:	8b 00                	mov    (%eax),%eax
  802aa8:	85 c0                	test   %eax,%eax
  802aaa:	0f 84 96 00 00 00    	je     802b46 <insert_sorted_allocList+0x1b3>
  802ab0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ab3:	8b 50 08             	mov    0x8(%eax),%edx
  802ab6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ab9:	8b 40 08             	mov    0x8(%eax),%eax
  802abc:	39 c2                	cmp    %eax,%edx
  802abe:	0f 86 82 00 00 00    	jbe    802b46 <insert_sorted_allocList+0x1b3>
  802ac4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ac7:	8b 50 08             	mov    0x8(%eax),%edx
  802aca:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802acd:	8b 00                	mov    (%eax),%eax
  802acf:	8b 40 08             	mov    0x8(%eax),%eax
  802ad2:	39 c2                	cmp    %eax,%edx
  802ad4:	73 70                	jae    802b46 <insert_sorted_allocList+0x1b3>
			{
				LIST_INSERT_AFTER(&AllocMemBlocksList, blk, newblk);
  802ad6:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802ada:	74 06                	je     802ae2 <insert_sorted_allocList+0x14f>
  802adc:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802ae0:	75 17                	jne    802af9 <insert_sorted_allocList+0x166>
  802ae2:	83 ec 04             	sub    $0x4,%esp
  802ae5:	68 88 42 80 00       	push   $0x804288
  802aea:	68 87 00 00 00       	push   $0x87
  802aef:	68 4b 42 80 00       	push   $0x80424b
  802af4:	e8 de dd ff ff       	call   8008d7 <_panic>
  802af9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802afc:	8b 10                	mov    (%eax),%edx
  802afe:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b01:	89 10                	mov    %edx,(%eax)
  802b03:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b06:	8b 00                	mov    (%eax),%eax
  802b08:	85 c0                	test   %eax,%eax
  802b0a:	74 0b                	je     802b17 <insert_sorted_allocList+0x184>
  802b0c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b0f:	8b 00                	mov    (%eax),%eax
  802b11:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802b14:	89 50 04             	mov    %edx,0x4(%eax)
  802b17:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b1a:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802b1d:	89 10                	mov    %edx,(%eax)
  802b1f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b22:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802b25:	89 50 04             	mov    %edx,0x4(%eax)
  802b28:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b2b:	8b 00                	mov    (%eax),%eax
  802b2d:	85 c0                	test   %eax,%eax
  802b2f:	75 08                	jne    802b39 <insert_sorted_allocList+0x1a6>
  802b31:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b34:	a3 44 50 80 00       	mov    %eax,0x805044
  802b39:	a1 4c 50 80 00       	mov    0x80504c,%eax
  802b3e:	40                   	inc    %eax
  802b3f:	a3 4c 50 80 00       	mov    %eax,0x80504c
				break;
  802b44:	eb 38                	jmp    802b7e <insert_sorted_allocList+0x1eb>
	{
		LIST_INSERT_TAIL(&AllocMemBlocksList, newblk);
	}
	else
	{
		LIST_FOREACH(blk, &AllocMemBlocksList)
  802b46:	a1 48 50 80 00       	mov    0x805048,%eax
  802b4b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802b4e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802b52:	74 07                	je     802b5b <insert_sorted_allocList+0x1c8>
  802b54:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b57:	8b 00                	mov    (%eax),%eax
  802b59:	eb 05                	jmp    802b60 <insert_sorted_allocList+0x1cd>
  802b5b:	b8 00 00 00 00       	mov    $0x0,%eax
  802b60:	a3 48 50 80 00       	mov    %eax,0x805048
  802b65:	a1 48 50 80 00       	mov    0x805048,%eax
  802b6a:	85 c0                	test   %eax,%eax
  802b6c:	0f 85 31 ff ff ff    	jne    802aa3 <insert_sorted_allocList+0x110>
  802b72:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802b76:	0f 85 27 ff ff ff    	jne    802aa3 <insert_sorted_allocList+0x110>
				LIST_INSERT_AFTER(&AllocMemBlocksList, blk, newblk);
				break;
			}
		}
	}
}
  802b7c:	eb 00                	jmp    802b7e <insert_sorted_allocList+0x1eb>
  802b7e:	90                   	nop
  802b7f:	c9                   	leave  
  802b80:	c3                   	ret    

00802b81 <alloc_block_FF>:

//=========================================
// [4] ALLOCATE BLOCK BY FIRST FIT:
//=========================================
struct MemBlock *alloc_block_FF(uint32 size)
{
  802b81:	55                   	push   %ebp
  802b82:	89 e5                	mov    %esp,%ebp
  802b84:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_FF
	// Write your code here, remove the panic and write your code
	//panic("alloc_block_FF() is not implemented yet...!!");
	uint32 versize = size;
  802b87:	8b 45 08             	mov    0x8(%ebp),%eax
  802b8a:	89 45 f0             	mov    %eax,-0x10(%ebp)
	struct MemBlock* blk;
	struct MemBlock* newblk = LIST_FIRST(&AvailableMemBlocksList);
  802b8d:	a1 48 51 80 00       	mov    0x805148,%eax
  802b92:	89 45 ec             	mov    %eax,-0x14(%ebp)

	LIST_FOREACH(blk,&FreeMemBlocksList)
  802b95:	a1 38 51 80 00       	mov    0x805138,%eax
  802b9a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802b9d:	e9 77 01 00 00       	jmp    802d19 <alloc_block_FF+0x198>
	{
		if(blk->size == versize)
  802ba2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ba5:	8b 40 0c             	mov    0xc(%eax),%eax
  802ba8:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  802bab:	0f 85 8a 00 00 00    	jne    802c3b <alloc_block_FF+0xba>
		{
			LIST_REMOVE(&FreeMemBlocksList,blk);
  802bb1:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802bb5:	75 17                	jne    802bce <alloc_block_FF+0x4d>
  802bb7:	83 ec 04             	sub    $0x4,%esp
  802bba:	68 bc 42 80 00       	push   $0x8042bc
  802bbf:	68 9e 00 00 00       	push   $0x9e
  802bc4:	68 4b 42 80 00       	push   $0x80424b
  802bc9:	e8 09 dd ff ff       	call   8008d7 <_panic>
  802bce:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bd1:	8b 00                	mov    (%eax),%eax
  802bd3:	85 c0                	test   %eax,%eax
  802bd5:	74 10                	je     802be7 <alloc_block_FF+0x66>
  802bd7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bda:	8b 00                	mov    (%eax),%eax
  802bdc:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802bdf:	8b 52 04             	mov    0x4(%edx),%edx
  802be2:	89 50 04             	mov    %edx,0x4(%eax)
  802be5:	eb 0b                	jmp    802bf2 <alloc_block_FF+0x71>
  802be7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bea:	8b 40 04             	mov    0x4(%eax),%eax
  802bed:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802bf2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bf5:	8b 40 04             	mov    0x4(%eax),%eax
  802bf8:	85 c0                	test   %eax,%eax
  802bfa:	74 0f                	je     802c0b <alloc_block_FF+0x8a>
  802bfc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bff:	8b 40 04             	mov    0x4(%eax),%eax
  802c02:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802c05:	8b 12                	mov    (%edx),%edx
  802c07:	89 10                	mov    %edx,(%eax)
  802c09:	eb 0a                	jmp    802c15 <alloc_block_FF+0x94>
  802c0b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c0e:	8b 00                	mov    (%eax),%eax
  802c10:	a3 38 51 80 00       	mov    %eax,0x805138
  802c15:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c18:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802c1e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c21:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802c28:	a1 44 51 80 00       	mov    0x805144,%eax
  802c2d:	48                   	dec    %eax
  802c2e:	a3 44 51 80 00       	mov    %eax,0x805144
			return blk;
  802c33:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c36:	e9 11 01 00 00       	jmp    802d4c <alloc_block_FF+0x1cb>
		}
		else if(blk->size > versize)
  802c3b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c3e:	8b 40 0c             	mov    0xc(%eax),%eax
  802c41:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  802c44:	0f 86 c7 00 00 00    	jbe    802d11 <alloc_block_FF+0x190>
		{
			LIST_REMOVE(&AvailableMemBlocksList,newblk);
  802c4a:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802c4e:	75 17                	jne    802c67 <alloc_block_FF+0xe6>
  802c50:	83 ec 04             	sub    $0x4,%esp
  802c53:	68 bc 42 80 00       	push   $0x8042bc
  802c58:	68 a3 00 00 00       	push   $0xa3
  802c5d:	68 4b 42 80 00       	push   $0x80424b
  802c62:	e8 70 dc ff ff       	call   8008d7 <_panic>
  802c67:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802c6a:	8b 00                	mov    (%eax),%eax
  802c6c:	85 c0                	test   %eax,%eax
  802c6e:	74 10                	je     802c80 <alloc_block_FF+0xff>
  802c70:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802c73:	8b 00                	mov    (%eax),%eax
  802c75:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802c78:	8b 52 04             	mov    0x4(%edx),%edx
  802c7b:	89 50 04             	mov    %edx,0x4(%eax)
  802c7e:	eb 0b                	jmp    802c8b <alloc_block_FF+0x10a>
  802c80:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802c83:	8b 40 04             	mov    0x4(%eax),%eax
  802c86:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802c8b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802c8e:	8b 40 04             	mov    0x4(%eax),%eax
  802c91:	85 c0                	test   %eax,%eax
  802c93:	74 0f                	je     802ca4 <alloc_block_FF+0x123>
  802c95:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802c98:	8b 40 04             	mov    0x4(%eax),%eax
  802c9b:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802c9e:	8b 12                	mov    (%edx),%edx
  802ca0:	89 10                	mov    %edx,(%eax)
  802ca2:	eb 0a                	jmp    802cae <alloc_block_FF+0x12d>
  802ca4:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802ca7:	8b 00                	mov    (%eax),%eax
  802ca9:	a3 48 51 80 00       	mov    %eax,0x805148
  802cae:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802cb1:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802cb7:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802cba:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802cc1:	a1 54 51 80 00       	mov    0x805154,%eax
  802cc6:	48                   	dec    %eax
  802cc7:	a3 54 51 80 00       	mov    %eax,0x805154
			newblk->size = versize;
  802ccc:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802ccf:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802cd2:	89 50 0c             	mov    %edx,0xc(%eax)
			blk->size = blk->size-versize;
  802cd5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cd8:	8b 40 0c             	mov    0xc(%eax),%eax
  802cdb:	2b 45 f0             	sub    -0x10(%ebp),%eax
  802cde:	89 c2                	mov    %eax,%edx
  802ce0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ce3:	89 50 0c             	mov    %edx,0xc(%eax)
			uint32 newveradd = blk->sva;
  802ce6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ce9:	8b 40 08             	mov    0x8(%eax),%eax
  802cec:	89 45 e8             	mov    %eax,-0x18(%ebp)
			blk->sva+=newblk->size;
  802cef:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cf2:	8b 50 08             	mov    0x8(%eax),%edx
  802cf5:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802cf8:	8b 40 0c             	mov    0xc(%eax),%eax
  802cfb:	01 c2                	add    %eax,%edx
  802cfd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d00:	89 50 08             	mov    %edx,0x8(%eax)
			newblk->sva = newveradd;
  802d03:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802d06:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802d09:	89 50 08             	mov    %edx,0x8(%eax)
			return newblk;
  802d0c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802d0f:	eb 3b                	jmp    802d4c <alloc_block_FF+0x1cb>
	//panic("alloc_block_FF() is not implemented yet...!!");
	uint32 versize = size;
	struct MemBlock* blk;
	struct MemBlock* newblk = LIST_FIRST(&AvailableMemBlocksList);

	LIST_FOREACH(blk,&FreeMemBlocksList)
  802d11:	a1 40 51 80 00       	mov    0x805140,%eax
  802d16:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802d19:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802d1d:	74 07                	je     802d26 <alloc_block_FF+0x1a5>
  802d1f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d22:	8b 00                	mov    (%eax),%eax
  802d24:	eb 05                	jmp    802d2b <alloc_block_FF+0x1aa>
  802d26:	b8 00 00 00 00       	mov    $0x0,%eax
  802d2b:	a3 40 51 80 00       	mov    %eax,0x805140
  802d30:	a1 40 51 80 00       	mov    0x805140,%eax
  802d35:	85 c0                	test   %eax,%eax
  802d37:	0f 85 65 fe ff ff    	jne    802ba2 <alloc_block_FF+0x21>
  802d3d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802d41:	0f 85 5b fe ff ff    	jne    802ba2 <alloc_block_FF+0x21>
			blk->sva+=newblk->size;
			newblk->sva = newveradd;
			return newblk;
		}
	}
	return NULL;
  802d47:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802d4c:	c9                   	leave  
  802d4d:	c3                   	ret    

00802d4e <alloc_block_BF>:

//=========================================
// [5] ALLOCATE BLOCK BY BEST FIT:
//=========================================
struct MemBlock *alloc_block_BF(uint32 size)
{
  802d4e:	55                   	push   %ebp
  802d4f:	89 e5                	mov    %esp,%ebp
  802d51:	83 ec 28             	sub    $0x28,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_BF
	// Write your code here, remove the panic and write your code
	//panic("alloc_block_BF() is not implemented yet...!!");
	uint32 versize=size;
  802d54:	8b 45 08             	mov    0x8(%ebp),%eax
  802d57:	89 45 e8             	mov    %eax,-0x18(%ebp)
	struct MemBlock* blk;
	struct MemBlock* newblk=LIST_FIRST(&AvailableMemBlocksList);
  802d5a:	a1 48 51 80 00       	mov    0x805148,%eax
  802d5f:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	uint32 newveradd;
	uint32 newsize;
	int size_free = LIST_SIZE(&FreeMemBlocksList);
  802d62:	a1 44 51 80 00       	mov    0x805144,%eax
  802d67:	89 45 e0             	mov    %eax,-0x20(%ebp)

	LIST_FOREACH(blk, &FreeMemBlocksList)
  802d6a:	a1 38 51 80 00       	mov    0x805138,%eax
  802d6f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802d72:	e9 a1 00 00 00       	jmp    802e18 <alloc_block_BF+0xca>
	{
		if(blk->size == versize)
  802d77:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d7a:	8b 40 0c             	mov    0xc(%eax),%eax
  802d7d:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  802d80:	0f 85 8a 00 00 00    	jne    802e10 <alloc_block_BF+0xc2>
		{
			LIST_REMOVE(&FreeMemBlocksList, blk);
  802d86:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802d8a:	75 17                	jne    802da3 <alloc_block_BF+0x55>
  802d8c:	83 ec 04             	sub    $0x4,%esp
  802d8f:	68 bc 42 80 00       	push   $0x8042bc
  802d94:	68 c2 00 00 00       	push   $0xc2
  802d99:	68 4b 42 80 00       	push   $0x80424b
  802d9e:	e8 34 db ff ff       	call   8008d7 <_panic>
  802da3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802da6:	8b 00                	mov    (%eax),%eax
  802da8:	85 c0                	test   %eax,%eax
  802daa:	74 10                	je     802dbc <alloc_block_BF+0x6e>
  802dac:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802daf:	8b 00                	mov    (%eax),%eax
  802db1:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802db4:	8b 52 04             	mov    0x4(%edx),%edx
  802db7:	89 50 04             	mov    %edx,0x4(%eax)
  802dba:	eb 0b                	jmp    802dc7 <alloc_block_BF+0x79>
  802dbc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802dbf:	8b 40 04             	mov    0x4(%eax),%eax
  802dc2:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802dc7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802dca:	8b 40 04             	mov    0x4(%eax),%eax
  802dcd:	85 c0                	test   %eax,%eax
  802dcf:	74 0f                	je     802de0 <alloc_block_BF+0x92>
  802dd1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802dd4:	8b 40 04             	mov    0x4(%eax),%eax
  802dd7:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802dda:	8b 12                	mov    (%edx),%edx
  802ddc:	89 10                	mov    %edx,(%eax)
  802dde:	eb 0a                	jmp    802dea <alloc_block_BF+0x9c>
  802de0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802de3:	8b 00                	mov    (%eax),%eax
  802de5:	a3 38 51 80 00       	mov    %eax,0x805138
  802dea:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ded:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802df3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802df6:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802dfd:	a1 44 51 80 00       	mov    0x805144,%eax
  802e02:	48                   	dec    %eax
  802e03:	a3 44 51 80 00       	mov    %eax,0x805144
			return blk;
  802e08:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e0b:	e9 11 02 00 00       	jmp    803021 <alloc_block_BF+0x2d3>
	struct MemBlock* newblk=LIST_FIRST(&AvailableMemBlocksList);
	uint32 newveradd;
	uint32 newsize;
	int size_free = LIST_SIZE(&FreeMemBlocksList);

	LIST_FOREACH(blk, &FreeMemBlocksList)
  802e10:	a1 40 51 80 00       	mov    0x805140,%eax
  802e15:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802e18:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802e1c:	74 07                	je     802e25 <alloc_block_BF+0xd7>
  802e1e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e21:	8b 00                	mov    (%eax),%eax
  802e23:	eb 05                	jmp    802e2a <alloc_block_BF+0xdc>
  802e25:	b8 00 00 00 00       	mov    $0x0,%eax
  802e2a:	a3 40 51 80 00       	mov    %eax,0x805140
  802e2f:	a1 40 51 80 00       	mov    0x805140,%eax
  802e34:	85 c0                	test   %eax,%eax
  802e36:	0f 85 3b ff ff ff    	jne    802d77 <alloc_block_BF+0x29>
  802e3c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802e40:	0f 85 31 ff ff ff    	jne    802d77 <alloc_block_BF+0x29>
		{
			LIST_REMOVE(&FreeMemBlocksList, blk);
			return blk;
		}
	}
	LIST_FOREACH(blk, &FreeMemBlocksList)
  802e46:	a1 38 51 80 00       	mov    0x805138,%eax
  802e4b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802e4e:	eb 27                	jmp    802e77 <alloc_block_BF+0x129>
	{
		if(blk->size > versize)
  802e50:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e53:	8b 40 0c             	mov    0xc(%eax),%eax
  802e56:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  802e59:	76 14                	jbe    802e6f <alloc_block_BF+0x121>
		{
			newsize = blk->size;
  802e5b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e5e:	8b 40 0c             	mov    0xc(%eax),%eax
  802e61:	89 45 ec             	mov    %eax,-0x14(%ebp)
			newveradd = blk->sva;
  802e64:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e67:	8b 40 08             	mov    0x8(%eax),%eax
  802e6a:	89 45 f0             	mov    %eax,-0x10(%ebp)
			break;
  802e6d:	eb 2e                	jmp    802e9d <alloc_block_BF+0x14f>
		{
			LIST_REMOVE(&FreeMemBlocksList, blk);
			return blk;
		}
	}
	LIST_FOREACH(blk, &FreeMemBlocksList)
  802e6f:	a1 40 51 80 00       	mov    0x805140,%eax
  802e74:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802e77:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802e7b:	74 07                	je     802e84 <alloc_block_BF+0x136>
  802e7d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e80:	8b 00                	mov    (%eax),%eax
  802e82:	eb 05                	jmp    802e89 <alloc_block_BF+0x13b>
  802e84:	b8 00 00 00 00       	mov    $0x0,%eax
  802e89:	a3 40 51 80 00       	mov    %eax,0x805140
  802e8e:	a1 40 51 80 00       	mov    0x805140,%eax
  802e93:	85 c0                	test   %eax,%eax
  802e95:	75 b9                	jne    802e50 <alloc_block_BF+0x102>
  802e97:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802e9b:	75 b3                	jne    802e50 <alloc_block_BF+0x102>
			newsize = blk->size;
			newveradd = blk->sva;
			break;
		}
	}
	LIST_FOREACH(blk, &FreeMemBlocksList)
  802e9d:	a1 38 51 80 00       	mov    0x805138,%eax
  802ea2:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802ea5:	eb 30                	jmp    802ed7 <alloc_block_BF+0x189>
	{
		if(newsize > blk->size && blk->size > versize)
  802ea7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802eaa:	8b 40 0c             	mov    0xc(%eax),%eax
  802ead:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  802eb0:	73 1d                	jae    802ecf <alloc_block_BF+0x181>
  802eb2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802eb5:	8b 40 0c             	mov    0xc(%eax),%eax
  802eb8:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  802ebb:	76 12                	jbe    802ecf <alloc_block_BF+0x181>
		{
	       newsize = blk->size;
  802ebd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ec0:	8b 40 0c             	mov    0xc(%eax),%eax
  802ec3:	89 45 ec             	mov    %eax,-0x14(%ebp)
		   newveradd = blk->sva;
  802ec6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ec9:	8b 40 08             	mov    0x8(%eax),%eax
  802ecc:	89 45 f0             	mov    %eax,-0x10(%ebp)
			newsize = blk->size;
			newveradd = blk->sva;
			break;
		}
	}
	LIST_FOREACH(blk, &FreeMemBlocksList)
  802ecf:	a1 40 51 80 00       	mov    0x805140,%eax
  802ed4:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802ed7:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802edb:	74 07                	je     802ee4 <alloc_block_BF+0x196>
  802edd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ee0:	8b 00                	mov    (%eax),%eax
  802ee2:	eb 05                	jmp    802ee9 <alloc_block_BF+0x19b>
  802ee4:	b8 00 00 00 00       	mov    $0x0,%eax
  802ee9:	a3 40 51 80 00       	mov    %eax,0x805140
  802eee:	a1 40 51 80 00       	mov    0x805140,%eax
  802ef3:	85 c0                	test   %eax,%eax
  802ef5:	75 b0                	jne    802ea7 <alloc_block_BF+0x159>
  802ef7:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802efb:	75 aa                	jne    802ea7 <alloc_block_BF+0x159>
		{
	       newsize = blk->size;
		   newveradd = blk->sva;
		}
	}
	LIST_FOREACH(blk, &FreeMemBlocksList)
  802efd:	a1 38 51 80 00       	mov    0x805138,%eax
  802f02:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802f05:	e9 e4 00 00 00       	jmp    802fee <alloc_block_BF+0x2a0>
	{
		if(blk->size == newsize && blk->sva == newveradd)
  802f0a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f0d:	8b 40 0c             	mov    0xc(%eax),%eax
  802f10:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  802f13:	0f 85 cd 00 00 00    	jne    802fe6 <alloc_block_BF+0x298>
  802f19:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f1c:	8b 40 08             	mov    0x8(%eax),%eax
  802f1f:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  802f22:	0f 85 be 00 00 00    	jne    802fe6 <alloc_block_BF+0x298>
		{
			LIST_REMOVE(&AvailableMemBlocksList, newblk);
  802f28:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  802f2c:	75 17                	jne    802f45 <alloc_block_BF+0x1f7>
  802f2e:	83 ec 04             	sub    $0x4,%esp
  802f31:	68 bc 42 80 00       	push   $0x8042bc
  802f36:	68 db 00 00 00       	push   $0xdb
  802f3b:	68 4b 42 80 00       	push   $0x80424b
  802f40:	e8 92 d9 ff ff       	call   8008d7 <_panic>
  802f45:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802f48:	8b 00                	mov    (%eax),%eax
  802f4a:	85 c0                	test   %eax,%eax
  802f4c:	74 10                	je     802f5e <alloc_block_BF+0x210>
  802f4e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802f51:	8b 00                	mov    (%eax),%eax
  802f53:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802f56:	8b 52 04             	mov    0x4(%edx),%edx
  802f59:	89 50 04             	mov    %edx,0x4(%eax)
  802f5c:	eb 0b                	jmp    802f69 <alloc_block_BF+0x21b>
  802f5e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802f61:	8b 40 04             	mov    0x4(%eax),%eax
  802f64:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802f69:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802f6c:	8b 40 04             	mov    0x4(%eax),%eax
  802f6f:	85 c0                	test   %eax,%eax
  802f71:	74 0f                	je     802f82 <alloc_block_BF+0x234>
  802f73:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802f76:	8b 40 04             	mov    0x4(%eax),%eax
  802f79:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802f7c:	8b 12                	mov    (%edx),%edx
  802f7e:	89 10                	mov    %edx,(%eax)
  802f80:	eb 0a                	jmp    802f8c <alloc_block_BF+0x23e>
  802f82:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802f85:	8b 00                	mov    (%eax),%eax
  802f87:	a3 48 51 80 00       	mov    %eax,0x805148
  802f8c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802f8f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802f95:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802f98:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802f9f:	a1 54 51 80 00       	mov    0x805154,%eax
  802fa4:	48                   	dec    %eax
  802fa5:	a3 54 51 80 00       	mov    %eax,0x805154
			newblk->size = versize;
  802faa:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802fad:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802fb0:	89 50 0c             	mov    %edx,0xc(%eax)
			newblk->sva = newveradd;
  802fb3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802fb6:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802fb9:	89 50 08             	mov    %edx,0x8(%eax)
			blk->size = blk->size - versize;
  802fbc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802fbf:	8b 40 0c             	mov    0xc(%eax),%eax
  802fc2:	2b 45 e8             	sub    -0x18(%ebp),%eax
  802fc5:	89 c2                	mov    %eax,%edx
  802fc7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802fca:	89 50 0c             	mov    %edx,0xc(%eax)
			blk->sva+= newblk->size;
  802fcd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802fd0:	8b 50 08             	mov    0x8(%eax),%edx
  802fd3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802fd6:	8b 40 0c             	mov    0xc(%eax),%eax
  802fd9:	01 c2                	add    %eax,%edx
  802fdb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802fde:	89 50 08             	mov    %edx,0x8(%eax)
			return newblk;
  802fe1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802fe4:	eb 3b                	jmp    803021 <alloc_block_BF+0x2d3>
		{
	       newsize = blk->size;
		   newveradd = blk->sva;
		}
	}
	LIST_FOREACH(blk, &FreeMemBlocksList)
  802fe6:	a1 40 51 80 00       	mov    0x805140,%eax
  802feb:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802fee:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802ff2:	74 07                	je     802ffb <alloc_block_BF+0x2ad>
  802ff4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ff7:	8b 00                	mov    (%eax),%eax
  802ff9:	eb 05                	jmp    803000 <alloc_block_BF+0x2b2>
  802ffb:	b8 00 00 00 00       	mov    $0x0,%eax
  803000:	a3 40 51 80 00       	mov    %eax,0x805140
  803005:	a1 40 51 80 00       	mov    0x805140,%eax
  80300a:	85 c0                	test   %eax,%eax
  80300c:	0f 85 f8 fe ff ff    	jne    802f0a <alloc_block_BF+0x1bc>
  803012:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803016:	0f 85 ee fe ff ff    	jne    802f0a <alloc_block_BF+0x1bc>
			blk->size = blk->size - versize;
			blk->sva+= newblk->size;
			return newblk;
		}
	}
	return NULL;
  80301c:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803021:	c9                   	leave  
  803022:	c3                   	ret    

00803023 <alloc_block_NF>:
//=========================================
// [7] ALLOCATE BLOCK BY NEXT FIT:
//=========================================
struct MemBlock *last_allocate;
struct MemBlock *alloc_block_NF(uint32 size)
{
  803023:	55                   	push   %ebp
  803024:	89 e5                	mov    %esp,%ebp
  803026:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1 - BONUS] [DYNAMIC ALLOCATOR] alloc_block_NF
	// Write your code here, remove the panic and write your code
	//panic("alloc_block_NF() is not implemented yet...!!");
	uint32 versize = size;
  803029:	8b 45 08             	mov    0x8(%ebp),%eax
  80302c:	89 45 f0             	mov    %eax,-0x10(%ebp)
	struct MemBlock* blk;
	struct MemBlock* newblk = LIST_FIRST(&AvailableMemBlocksList);
  80302f:	a1 48 51 80 00       	mov    0x805148,%eax
  803034:	89 45 ec             	mov    %eax,-0x14(%ebp)

	LIST_FOREACH(blk,&FreeMemBlocksList)
  803037:	a1 38 51 80 00       	mov    0x805138,%eax
  80303c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80303f:	e9 77 01 00 00       	jmp    8031bb <alloc_block_NF+0x198>
	{
		if(blk->size == versize)
  803044:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803047:	8b 40 0c             	mov    0xc(%eax),%eax
  80304a:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80304d:	0f 85 8a 00 00 00    	jne    8030dd <alloc_block_NF+0xba>
		{
			LIST_REMOVE(&FreeMemBlocksList,blk);
  803053:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803057:	75 17                	jne    803070 <alloc_block_NF+0x4d>
  803059:	83 ec 04             	sub    $0x4,%esp
  80305c:	68 bc 42 80 00       	push   $0x8042bc
  803061:	68 f7 00 00 00       	push   $0xf7
  803066:	68 4b 42 80 00       	push   $0x80424b
  80306b:	e8 67 d8 ff ff       	call   8008d7 <_panic>
  803070:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803073:	8b 00                	mov    (%eax),%eax
  803075:	85 c0                	test   %eax,%eax
  803077:	74 10                	je     803089 <alloc_block_NF+0x66>
  803079:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80307c:	8b 00                	mov    (%eax),%eax
  80307e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803081:	8b 52 04             	mov    0x4(%edx),%edx
  803084:	89 50 04             	mov    %edx,0x4(%eax)
  803087:	eb 0b                	jmp    803094 <alloc_block_NF+0x71>
  803089:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80308c:	8b 40 04             	mov    0x4(%eax),%eax
  80308f:	a3 3c 51 80 00       	mov    %eax,0x80513c
  803094:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803097:	8b 40 04             	mov    0x4(%eax),%eax
  80309a:	85 c0                	test   %eax,%eax
  80309c:	74 0f                	je     8030ad <alloc_block_NF+0x8a>
  80309e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030a1:	8b 40 04             	mov    0x4(%eax),%eax
  8030a4:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8030a7:	8b 12                	mov    (%edx),%edx
  8030a9:	89 10                	mov    %edx,(%eax)
  8030ab:	eb 0a                	jmp    8030b7 <alloc_block_NF+0x94>
  8030ad:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030b0:	8b 00                	mov    (%eax),%eax
  8030b2:	a3 38 51 80 00       	mov    %eax,0x805138
  8030b7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030ba:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8030c0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030c3:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8030ca:	a1 44 51 80 00       	mov    0x805144,%eax
  8030cf:	48                   	dec    %eax
  8030d0:	a3 44 51 80 00       	mov    %eax,0x805144
			return blk;
  8030d5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030d8:	e9 11 01 00 00       	jmp    8031ee <alloc_block_NF+0x1cb>
		}
		else if(blk->size > versize)
  8030dd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030e0:	8b 40 0c             	mov    0xc(%eax),%eax
  8030e3:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8030e6:	0f 86 c7 00 00 00    	jbe    8031b3 <alloc_block_NF+0x190>
		{
			LIST_REMOVE(&AvailableMemBlocksList,newblk);
  8030ec:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8030f0:	75 17                	jne    803109 <alloc_block_NF+0xe6>
  8030f2:	83 ec 04             	sub    $0x4,%esp
  8030f5:	68 bc 42 80 00       	push   $0x8042bc
  8030fa:	68 fc 00 00 00       	push   $0xfc
  8030ff:	68 4b 42 80 00       	push   $0x80424b
  803104:	e8 ce d7 ff ff       	call   8008d7 <_panic>
  803109:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80310c:	8b 00                	mov    (%eax),%eax
  80310e:	85 c0                	test   %eax,%eax
  803110:	74 10                	je     803122 <alloc_block_NF+0xff>
  803112:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803115:	8b 00                	mov    (%eax),%eax
  803117:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80311a:	8b 52 04             	mov    0x4(%edx),%edx
  80311d:	89 50 04             	mov    %edx,0x4(%eax)
  803120:	eb 0b                	jmp    80312d <alloc_block_NF+0x10a>
  803122:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803125:	8b 40 04             	mov    0x4(%eax),%eax
  803128:	a3 4c 51 80 00       	mov    %eax,0x80514c
  80312d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803130:	8b 40 04             	mov    0x4(%eax),%eax
  803133:	85 c0                	test   %eax,%eax
  803135:	74 0f                	je     803146 <alloc_block_NF+0x123>
  803137:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80313a:	8b 40 04             	mov    0x4(%eax),%eax
  80313d:	8b 55 ec             	mov    -0x14(%ebp),%edx
  803140:	8b 12                	mov    (%edx),%edx
  803142:	89 10                	mov    %edx,(%eax)
  803144:	eb 0a                	jmp    803150 <alloc_block_NF+0x12d>
  803146:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803149:	8b 00                	mov    (%eax),%eax
  80314b:	a3 48 51 80 00       	mov    %eax,0x805148
  803150:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803153:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803159:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80315c:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803163:	a1 54 51 80 00       	mov    0x805154,%eax
  803168:	48                   	dec    %eax
  803169:	a3 54 51 80 00       	mov    %eax,0x805154
			newblk->size = versize;
  80316e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803171:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803174:	89 50 0c             	mov    %edx,0xc(%eax)
			blk->size = blk->size-versize;
  803177:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80317a:	8b 40 0c             	mov    0xc(%eax),%eax
  80317d:	2b 45 f0             	sub    -0x10(%ebp),%eax
  803180:	89 c2                	mov    %eax,%edx
  803182:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803185:	89 50 0c             	mov    %edx,0xc(%eax)
			uint32 newveradd = blk->sva;
  803188:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80318b:	8b 40 08             	mov    0x8(%eax),%eax
  80318e:	89 45 e8             	mov    %eax,-0x18(%ebp)
			blk->sva+=newblk->size;
  803191:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803194:	8b 50 08             	mov    0x8(%eax),%edx
  803197:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80319a:	8b 40 0c             	mov    0xc(%eax),%eax
  80319d:	01 c2                	add    %eax,%edx
  80319f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8031a2:	89 50 08             	mov    %edx,0x8(%eax)
			newblk->sva = newveradd;
  8031a5:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8031a8:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8031ab:	89 50 08             	mov    %edx,0x8(%eax)
			return newblk;
  8031ae:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8031b1:	eb 3b                	jmp    8031ee <alloc_block_NF+0x1cb>
	//panic("alloc_block_NF() is not implemented yet...!!");
	uint32 versize = size;
	struct MemBlock* blk;
	struct MemBlock* newblk = LIST_FIRST(&AvailableMemBlocksList);

	LIST_FOREACH(blk,&FreeMemBlocksList)
  8031b3:	a1 40 51 80 00       	mov    0x805140,%eax
  8031b8:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8031bb:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8031bf:	74 07                	je     8031c8 <alloc_block_NF+0x1a5>
  8031c1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8031c4:	8b 00                	mov    (%eax),%eax
  8031c6:	eb 05                	jmp    8031cd <alloc_block_NF+0x1aa>
  8031c8:	b8 00 00 00 00       	mov    $0x0,%eax
  8031cd:	a3 40 51 80 00       	mov    %eax,0x805140
  8031d2:	a1 40 51 80 00       	mov    0x805140,%eax
  8031d7:	85 c0                	test   %eax,%eax
  8031d9:	0f 85 65 fe ff ff    	jne    803044 <alloc_block_NF+0x21>
  8031df:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8031e3:	0f 85 5b fe ff ff    	jne    803044 <alloc_block_NF+0x21>
			blk->sva+=newblk->size;
			newblk->sva = newveradd;
			return newblk;
		}
	}
	return NULL;
  8031e9:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8031ee:	c9                   	leave  
  8031ef:	c3                   	ret    

008031f0 <addToAvailMemBlocksList>:

//===================================================
// [8] INSERT BLOCK (SORTED WITH MERGE) IN FREE LIST:
//===================================================
void addToAvailMemBlocksList(struct MemBlock *blockToInsert)
{
  8031f0:	55                   	push   %ebp
  8031f1:	89 e5                	mov    %esp,%ebp
  8031f3:	83 ec 08             	sub    $0x8,%esp
	blockToInsert->sva = 0;
  8031f6:	8b 45 08             	mov    0x8(%ebp),%eax
  8031f9:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
	blockToInsert->size = 0;
  803200:	8b 45 08             	mov    0x8(%ebp),%eax
  803203:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
	//add to avail
	LIST_INSERT_TAIL(&AvailableMemBlocksList, blockToInsert);
  80320a:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80320e:	75 17                	jne    803227 <addToAvailMemBlocksList+0x37>
  803210:	83 ec 04             	sub    $0x4,%esp
  803213:	68 64 42 80 00       	push   $0x804264
  803218:	68 10 01 00 00       	push   $0x110
  80321d:	68 4b 42 80 00       	push   $0x80424b
  803222:	e8 b0 d6 ff ff       	call   8008d7 <_panic>
  803227:	8b 15 4c 51 80 00    	mov    0x80514c,%edx
  80322d:	8b 45 08             	mov    0x8(%ebp),%eax
  803230:	89 50 04             	mov    %edx,0x4(%eax)
  803233:	8b 45 08             	mov    0x8(%ebp),%eax
  803236:	8b 40 04             	mov    0x4(%eax),%eax
  803239:	85 c0                	test   %eax,%eax
  80323b:	74 0c                	je     803249 <addToAvailMemBlocksList+0x59>
  80323d:	a1 4c 51 80 00       	mov    0x80514c,%eax
  803242:	8b 55 08             	mov    0x8(%ebp),%edx
  803245:	89 10                	mov    %edx,(%eax)
  803247:	eb 08                	jmp    803251 <addToAvailMemBlocksList+0x61>
  803249:	8b 45 08             	mov    0x8(%ebp),%eax
  80324c:	a3 48 51 80 00       	mov    %eax,0x805148
  803251:	8b 45 08             	mov    0x8(%ebp),%eax
  803254:	a3 4c 51 80 00       	mov    %eax,0x80514c
  803259:	8b 45 08             	mov    0x8(%ebp),%eax
  80325c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803262:	a1 54 51 80 00       	mov    0x805154,%eax
  803267:	40                   	inc    %eax
  803268:	a3 54 51 80 00       	mov    %eax,0x805154
}
  80326d:	90                   	nop
  80326e:	c9                   	leave  
  80326f:	c3                   	ret    

00803270 <insert_sorted_with_merge_freeList>:
void insert_sorted_with_merge_freeList(struct MemBlock *blockToInsert)
{
  803270:	55                   	push   %ebp
  803271:	89 e5                	mov    %esp,%ebp
  803273:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] insert_sorted_with_merge_freeList
	// Write your code here, remove the panic and write your code

	struct MemBlock* last = LIST_LAST(&FreeMemBlocksList);
  803276:	a1 3c 51 80 00       	mov    0x80513c,%eax
  80327b:	89 45 f0             	mov    %eax,-0x10(%ebp)
	//check if list empty
	if (LIST_SIZE(&(FreeMemBlocksList)) == 0)
  80327e:	a1 44 51 80 00       	mov    0x805144,%eax
  803283:	85 c0                	test   %eax,%eax
  803285:	75 68                	jne    8032ef <insert_sorted_with_merge_freeList+0x7f>
		LIST_INSERT_HEAD(&FreeMemBlocksList, blockToInsert);
  803287:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80328b:	75 17                	jne    8032a4 <insert_sorted_with_merge_freeList+0x34>
  80328d:	83 ec 04             	sub    $0x4,%esp
  803290:	68 28 42 80 00       	push   $0x804228
  803295:	68 1a 01 00 00       	push   $0x11a
  80329a:	68 4b 42 80 00       	push   $0x80424b
  80329f:	e8 33 d6 ff ff       	call   8008d7 <_panic>
  8032a4:	8b 15 38 51 80 00    	mov    0x805138,%edx
  8032aa:	8b 45 08             	mov    0x8(%ebp),%eax
  8032ad:	89 10                	mov    %edx,(%eax)
  8032af:	8b 45 08             	mov    0x8(%ebp),%eax
  8032b2:	8b 00                	mov    (%eax),%eax
  8032b4:	85 c0                	test   %eax,%eax
  8032b6:	74 0d                	je     8032c5 <insert_sorted_with_merge_freeList+0x55>
  8032b8:	a1 38 51 80 00       	mov    0x805138,%eax
  8032bd:	8b 55 08             	mov    0x8(%ebp),%edx
  8032c0:	89 50 04             	mov    %edx,0x4(%eax)
  8032c3:	eb 08                	jmp    8032cd <insert_sorted_with_merge_freeList+0x5d>
  8032c5:	8b 45 08             	mov    0x8(%ebp),%eax
  8032c8:	a3 3c 51 80 00       	mov    %eax,0x80513c
  8032cd:	8b 45 08             	mov    0x8(%ebp),%eax
  8032d0:	a3 38 51 80 00       	mov    %eax,0x805138
  8032d5:	8b 45 08             	mov    0x8(%ebp),%eax
  8032d8:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8032df:	a1 44 51 80 00       	mov    0x805144,%eax
  8032e4:	40                   	inc    %eax
  8032e5:	a3 44 51 80 00       	mov    %eax,0x805144
		}
	}

	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  8032ea:	e9 c5 03 00 00       	jmp    8036b4 <insert_sorted_with_merge_freeList+0x444>
	struct MemBlock* last = LIST_LAST(&FreeMemBlocksList);
	//check if list empty
	if (LIST_SIZE(&(FreeMemBlocksList)) == 0)
		LIST_INSERT_HEAD(&FreeMemBlocksList, blockToInsert);
	//check if it's position is at last
	else if (last->sva < blockToInsert->sva) {
  8032ef:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8032f2:	8b 50 08             	mov    0x8(%eax),%edx
  8032f5:	8b 45 08             	mov    0x8(%ebp),%eax
  8032f8:	8b 40 08             	mov    0x8(%eax),%eax
  8032fb:	39 c2                	cmp    %eax,%edx
  8032fd:	0f 83 b2 00 00 00    	jae    8033b5 <insert_sorted_with_merge_freeList+0x145>

		//if i have to merge
		if (last->sva + last->size == blockToInsert->sva) {
  803303:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803306:	8b 50 08             	mov    0x8(%eax),%edx
  803309:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80330c:	8b 40 0c             	mov    0xc(%eax),%eax
  80330f:	01 c2                	add    %eax,%edx
  803311:	8b 45 08             	mov    0x8(%ebp),%eax
  803314:	8b 40 08             	mov    0x8(%eax),%eax
  803317:	39 c2                	cmp    %eax,%edx
  803319:	75 27                	jne    803342 <insert_sorted_with_merge_freeList+0xd2>
			last->size = last->size + blockToInsert->size;
  80331b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80331e:	8b 50 0c             	mov    0xc(%eax),%edx
  803321:	8b 45 08             	mov    0x8(%ebp),%eax
  803324:	8b 40 0c             	mov    0xc(%eax),%eax
  803327:	01 c2                	add    %eax,%edx
  803329:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80332c:	89 50 0c             	mov    %edx,0xc(%eax)
			addToAvailMemBlocksList(blockToInsert);
  80332f:	83 ec 0c             	sub    $0xc,%esp
  803332:	ff 75 08             	pushl  0x8(%ebp)
  803335:	e8 b6 fe ff ff       	call   8031f0 <addToAvailMemBlocksList>
  80333a:	83 c4 10             	add    $0x10,%esp
		}
	}

	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  80333d:	e9 72 03 00 00       	jmp    8036b4 <insert_sorted_with_merge_freeList+0x444>
		if (last->sva + last->size == blockToInsert->sva) {
			last->size = last->size + blockToInsert->size;
			addToAvailMemBlocksList(blockToInsert);

		} else {
			LIST_INSERT_AFTER(&FreeMemBlocksList, last, blockToInsert);
  803342:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  803346:	74 06                	je     80334e <insert_sorted_with_merge_freeList+0xde>
  803348:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80334c:	75 17                	jne    803365 <insert_sorted_with_merge_freeList+0xf5>
  80334e:	83 ec 04             	sub    $0x4,%esp
  803351:	68 88 42 80 00       	push   $0x804288
  803356:	68 24 01 00 00       	push   $0x124
  80335b:	68 4b 42 80 00       	push   $0x80424b
  803360:	e8 72 d5 ff ff       	call   8008d7 <_panic>
  803365:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803368:	8b 10                	mov    (%eax),%edx
  80336a:	8b 45 08             	mov    0x8(%ebp),%eax
  80336d:	89 10                	mov    %edx,(%eax)
  80336f:	8b 45 08             	mov    0x8(%ebp),%eax
  803372:	8b 00                	mov    (%eax),%eax
  803374:	85 c0                	test   %eax,%eax
  803376:	74 0b                	je     803383 <insert_sorted_with_merge_freeList+0x113>
  803378:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80337b:	8b 00                	mov    (%eax),%eax
  80337d:	8b 55 08             	mov    0x8(%ebp),%edx
  803380:	89 50 04             	mov    %edx,0x4(%eax)
  803383:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803386:	8b 55 08             	mov    0x8(%ebp),%edx
  803389:	89 10                	mov    %edx,(%eax)
  80338b:	8b 45 08             	mov    0x8(%ebp),%eax
  80338e:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803391:	89 50 04             	mov    %edx,0x4(%eax)
  803394:	8b 45 08             	mov    0x8(%ebp),%eax
  803397:	8b 00                	mov    (%eax),%eax
  803399:	85 c0                	test   %eax,%eax
  80339b:	75 08                	jne    8033a5 <insert_sorted_with_merge_freeList+0x135>
  80339d:	8b 45 08             	mov    0x8(%ebp),%eax
  8033a0:	a3 3c 51 80 00       	mov    %eax,0x80513c
  8033a5:	a1 44 51 80 00       	mov    0x805144,%eax
  8033aa:	40                   	inc    %eax
  8033ab:	a3 44 51 80 00       	mov    %eax,0x805144
		}
	}

	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  8033b0:	e9 ff 02 00 00       	jmp    8036b4 <insert_sorted_with_merge_freeList+0x444>
		} else {
			LIST_INSERT_AFTER(&FreeMemBlocksList, last, blockToInsert);
		}
	} else {
		struct MemBlock *iterator;
		LIST_FOREACH(iterator, &(FreeMemBlocksList))
  8033b5:	a1 38 51 80 00       	mov    0x805138,%eax
  8033ba:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8033bd:	e9 c2 02 00 00       	jmp    803684 <insert_sorted_with_merge_freeList+0x414>
		{

			if (iterator->sva > blockToInsert->sva) {
  8033c2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8033c5:	8b 50 08             	mov    0x8(%eax),%edx
  8033c8:	8b 45 08             	mov    0x8(%ebp),%eax
  8033cb:	8b 40 08             	mov    0x8(%eax),%eax
  8033ce:	39 c2                	cmp    %eax,%edx
  8033d0:	0f 86 a6 02 00 00    	jbe    80367c <insert_sorted_with_merge_freeList+0x40c>

				struct MemBlock* prev = LIST_PREV(iterator);
  8033d6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8033d9:	8b 40 04             	mov    0x4(%eax),%eax
  8033dc:	89 45 ec             	mov    %eax,-0x14(%ebp)
				if (prev == NULL) {
  8033df:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8033e3:	0f 85 ba 00 00 00    	jne    8034a3 <insert_sorted_with_merge_freeList+0x233>
					//check merge
					if (blockToInsert->size + blockToInsert->sva
  8033e9:	8b 45 08             	mov    0x8(%ebp),%eax
  8033ec:	8b 50 0c             	mov    0xc(%eax),%edx
  8033ef:	8b 45 08             	mov    0x8(%ebp),%eax
  8033f2:	8b 40 08             	mov    0x8(%eax),%eax
  8033f5:	01 c2                	add    %eax,%edx
							== iterator->sva) {
  8033f7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8033fa:	8b 40 08             	mov    0x8(%eax),%eax
			if (iterator->sva > blockToInsert->sva) {

				struct MemBlock* prev = LIST_PREV(iterator);
				if (prev == NULL) {
					//check merge
					if (blockToInsert->size + blockToInsert->sva
  8033fd:	39 c2                	cmp    %eax,%edx
  8033ff:	75 33                	jne    803434 <insert_sorted_with_merge_freeList+0x1c4>
							== iterator->sva) {
						iterator->sva = blockToInsert->sva;
  803401:	8b 45 08             	mov    0x8(%ebp),%eax
  803404:	8b 50 08             	mov    0x8(%eax),%edx
  803407:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80340a:	89 50 08             	mov    %edx,0x8(%eax)
						iterator->size = iterator->size + blockToInsert->size;
  80340d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803410:	8b 50 0c             	mov    0xc(%eax),%edx
  803413:	8b 45 08             	mov    0x8(%ebp),%eax
  803416:	8b 40 0c             	mov    0xc(%eax),%eax
  803419:	01 c2                	add    %eax,%edx
  80341b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80341e:	89 50 0c             	mov    %edx,0xc(%eax)
						addToAvailMemBlocksList(blockToInsert);
  803421:	83 ec 0c             	sub    $0xc,%esp
  803424:	ff 75 08             	pushl  0x8(%ebp)
  803427:	e8 c4 fd ff ff       	call   8031f0 <addToAvailMemBlocksList>
  80342c:	83 c4 10             	add    $0x10,%esp

					else {
						LIST_INSERT_BEFORE(&FreeMemBlocksList, iterator,
								blockToInsert);
					}
					break;
  80342f:	e9 80 02 00 00       	jmp    8036b4 <insert_sorted_with_merge_freeList+0x444>
						addToAvailMemBlocksList(blockToInsert);

					}

					else {
						LIST_INSERT_BEFORE(&FreeMemBlocksList, iterator,
  803434:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803438:	74 06                	je     803440 <insert_sorted_with_merge_freeList+0x1d0>
  80343a:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80343e:	75 17                	jne    803457 <insert_sorted_with_merge_freeList+0x1e7>
  803440:	83 ec 04             	sub    $0x4,%esp
  803443:	68 dc 42 80 00       	push   $0x8042dc
  803448:	68 3a 01 00 00       	push   $0x13a
  80344d:	68 4b 42 80 00       	push   $0x80424b
  803452:	e8 80 d4 ff ff       	call   8008d7 <_panic>
  803457:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80345a:	8b 50 04             	mov    0x4(%eax),%edx
  80345d:	8b 45 08             	mov    0x8(%ebp),%eax
  803460:	89 50 04             	mov    %edx,0x4(%eax)
  803463:	8b 45 08             	mov    0x8(%ebp),%eax
  803466:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803469:	89 10                	mov    %edx,(%eax)
  80346b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80346e:	8b 40 04             	mov    0x4(%eax),%eax
  803471:	85 c0                	test   %eax,%eax
  803473:	74 0d                	je     803482 <insert_sorted_with_merge_freeList+0x212>
  803475:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803478:	8b 40 04             	mov    0x4(%eax),%eax
  80347b:	8b 55 08             	mov    0x8(%ebp),%edx
  80347e:	89 10                	mov    %edx,(%eax)
  803480:	eb 08                	jmp    80348a <insert_sorted_with_merge_freeList+0x21a>
  803482:	8b 45 08             	mov    0x8(%ebp),%eax
  803485:	a3 38 51 80 00       	mov    %eax,0x805138
  80348a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80348d:	8b 55 08             	mov    0x8(%ebp),%edx
  803490:	89 50 04             	mov    %edx,0x4(%eax)
  803493:	a1 44 51 80 00       	mov    0x805144,%eax
  803498:	40                   	inc    %eax
  803499:	a3 44 51 80 00       	mov    %eax,0x805144
								blockToInsert);
					}
					break;
  80349e:	e9 11 02 00 00       	jmp    8036b4 <insert_sorted_with_merge_freeList+0x444>
				} else {
					//prev and next merge
					if (prev->sva + prev->size + blockToInsert->size
  8034a3:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8034a6:	8b 50 08             	mov    0x8(%eax),%edx
  8034a9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8034ac:	8b 40 0c             	mov    0xc(%eax),%eax
  8034af:	01 c2                	add    %eax,%edx
  8034b1:	8b 45 08             	mov    0x8(%ebp),%eax
  8034b4:	8b 40 0c             	mov    0xc(%eax),%eax
  8034b7:	01 c2                	add    %eax,%edx
							== iterator->sva) {
  8034b9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8034bc:	8b 40 08             	mov    0x8(%eax),%eax
								blockToInsert);
					}
					break;
				} else {
					//prev and next merge
					if (prev->sva + prev->size + blockToInsert->size
  8034bf:	39 c2                	cmp    %eax,%edx
  8034c1:	0f 85 bf 00 00 00    	jne    803586 <insert_sorted_with_merge_freeList+0x316>
							== iterator->sva) {
						prev->size = prev->size + blockToInsert->size
  8034c7:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8034ca:	8b 50 0c             	mov    0xc(%eax),%edx
  8034cd:	8b 45 08             	mov    0x8(%ebp),%eax
  8034d0:	8b 40 0c             	mov    0xc(%eax),%eax
  8034d3:	01 c2                	add    %eax,%edx
								+ iterator->size;
  8034d5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8034d8:	8b 40 0c             	mov    0xc(%eax),%eax
  8034db:	01 c2                	add    %eax,%edx
					break;
				} else {
					//prev and next merge
					if (prev->sva + prev->size + blockToInsert->size
							== iterator->sva) {
						prev->size = prev->size + blockToInsert->size
  8034dd:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8034e0:	89 50 0c             	mov    %edx,0xc(%eax)
								+ iterator->size;
						LIST_REMOVE(&FreeMemBlocksList, iterator);
  8034e3:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8034e7:	75 17                	jne    803500 <insert_sorted_with_merge_freeList+0x290>
  8034e9:	83 ec 04             	sub    $0x4,%esp
  8034ec:	68 bc 42 80 00       	push   $0x8042bc
  8034f1:	68 43 01 00 00       	push   $0x143
  8034f6:	68 4b 42 80 00       	push   $0x80424b
  8034fb:	e8 d7 d3 ff ff       	call   8008d7 <_panic>
  803500:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803503:	8b 00                	mov    (%eax),%eax
  803505:	85 c0                	test   %eax,%eax
  803507:	74 10                	je     803519 <insert_sorted_with_merge_freeList+0x2a9>
  803509:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80350c:	8b 00                	mov    (%eax),%eax
  80350e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803511:	8b 52 04             	mov    0x4(%edx),%edx
  803514:	89 50 04             	mov    %edx,0x4(%eax)
  803517:	eb 0b                	jmp    803524 <insert_sorted_with_merge_freeList+0x2b4>
  803519:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80351c:	8b 40 04             	mov    0x4(%eax),%eax
  80351f:	a3 3c 51 80 00       	mov    %eax,0x80513c
  803524:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803527:	8b 40 04             	mov    0x4(%eax),%eax
  80352a:	85 c0                	test   %eax,%eax
  80352c:	74 0f                	je     80353d <insert_sorted_with_merge_freeList+0x2cd>
  80352e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803531:	8b 40 04             	mov    0x4(%eax),%eax
  803534:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803537:	8b 12                	mov    (%edx),%edx
  803539:	89 10                	mov    %edx,(%eax)
  80353b:	eb 0a                	jmp    803547 <insert_sorted_with_merge_freeList+0x2d7>
  80353d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803540:	8b 00                	mov    (%eax),%eax
  803542:	a3 38 51 80 00       	mov    %eax,0x805138
  803547:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80354a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803550:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803553:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80355a:	a1 44 51 80 00       	mov    0x805144,%eax
  80355f:	48                   	dec    %eax
  803560:	a3 44 51 80 00       	mov    %eax,0x805144
						addToAvailMemBlocksList(blockToInsert);
  803565:	83 ec 0c             	sub    $0xc,%esp
  803568:	ff 75 08             	pushl  0x8(%ebp)
  80356b:	e8 80 fc ff ff       	call   8031f0 <addToAvailMemBlocksList>
  803570:	83 c4 10             	add    $0x10,%esp
						addToAvailMemBlocksList(iterator);
  803573:	83 ec 0c             	sub    $0xc,%esp
  803576:	ff 75 f4             	pushl  -0xc(%ebp)
  803579:	e8 72 fc ff ff       	call   8031f0 <addToAvailMemBlocksList>
  80357e:	83 c4 10             	add    $0x10,%esp
					//Insert
					else {
						LIST_INSERT_BEFORE(&FreeMemBlocksList, iterator,
								blockToInsert);
					}
					break;
  803581:	e9 2e 01 00 00       	jmp    8036b4 <insert_sorted_with_merge_freeList+0x444>
						LIST_REMOVE(&FreeMemBlocksList, iterator);
						addToAvailMemBlocksList(blockToInsert);
						addToAvailMemBlocksList(iterator);
					}
					//previous merge
					else if (prev->sva + prev->size == blockToInsert->sva) {
  803586:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803589:	8b 50 08             	mov    0x8(%eax),%edx
  80358c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80358f:	8b 40 0c             	mov    0xc(%eax),%eax
  803592:	01 c2                	add    %eax,%edx
  803594:	8b 45 08             	mov    0x8(%ebp),%eax
  803597:	8b 40 08             	mov    0x8(%eax),%eax
  80359a:	39 c2                	cmp    %eax,%edx
  80359c:	75 27                	jne    8035c5 <insert_sorted_with_merge_freeList+0x355>
						prev->size = prev->size + blockToInsert->size;
  80359e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8035a1:	8b 50 0c             	mov    0xc(%eax),%edx
  8035a4:	8b 45 08             	mov    0x8(%ebp),%eax
  8035a7:	8b 40 0c             	mov    0xc(%eax),%eax
  8035aa:	01 c2                	add    %eax,%edx
  8035ac:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8035af:	89 50 0c             	mov    %edx,0xc(%eax)
						addToAvailMemBlocksList(blockToInsert);
  8035b2:	83 ec 0c             	sub    $0xc,%esp
  8035b5:	ff 75 08             	pushl  0x8(%ebp)
  8035b8:	e8 33 fc ff ff       	call   8031f0 <addToAvailMemBlocksList>
  8035bd:	83 c4 10             	add    $0x10,%esp
					//Insert
					else {
						LIST_INSERT_BEFORE(&FreeMemBlocksList, iterator,
								blockToInsert);
					}
					break;
  8035c0:	e9 ef 00 00 00       	jmp    8036b4 <insert_sorted_with_merge_freeList+0x444>
					else if (prev->sva + prev->size == blockToInsert->sva) {
						prev->size = prev->size + blockToInsert->size;
						addToAvailMemBlocksList(blockToInsert);
					}
					//next merge
					else if (blockToInsert->size + blockToInsert->sva
  8035c5:	8b 45 08             	mov    0x8(%ebp),%eax
  8035c8:	8b 50 0c             	mov    0xc(%eax),%edx
  8035cb:	8b 45 08             	mov    0x8(%ebp),%eax
  8035ce:	8b 40 08             	mov    0x8(%eax),%eax
  8035d1:	01 c2                	add    %eax,%edx
							== iterator->sva) {
  8035d3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8035d6:	8b 40 08             	mov    0x8(%eax),%eax
					else if (prev->sva + prev->size == blockToInsert->sva) {
						prev->size = prev->size + blockToInsert->size;
						addToAvailMemBlocksList(blockToInsert);
					}
					//next merge
					else if (blockToInsert->size + blockToInsert->sva
  8035d9:	39 c2                	cmp    %eax,%edx
  8035db:	75 33                	jne    803610 <insert_sorted_with_merge_freeList+0x3a0>
							== iterator->sva) {
						iterator->sva = blockToInsert->sva;
  8035dd:	8b 45 08             	mov    0x8(%ebp),%eax
  8035e0:	8b 50 08             	mov    0x8(%eax),%edx
  8035e3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8035e6:	89 50 08             	mov    %edx,0x8(%eax)
						iterator->size = iterator->size + blockToInsert->size;
  8035e9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8035ec:	8b 50 0c             	mov    0xc(%eax),%edx
  8035ef:	8b 45 08             	mov    0x8(%ebp),%eax
  8035f2:	8b 40 0c             	mov    0xc(%eax),%eax
  8035f5:	01 c2                	add    %eax,%edx
  8035f7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8035fa:	89 50 0c             	mov    %edx,0xc(%eax)
						addToAvailMemBlocksList(blockToInsert);
  8035fd:	83 ec 0c             	sub    $0xc,%esp
  803600:	ff 75 08             	pushl  0x8(%ebp)
  803603:	e8 e8 fb ff ff       	call   8031f0 <addToAvailMemBlocksList>
  803608:	83 c4 10             	add    $0x10,%esp
					//Insert
					else {
						LIST_INSERT_BEFORE(&FreeMemBlocksList, iterator,
								blockToInsert);
					}
					break;
  80360b:	e9 a4 00 00 00       	jmp    8036b4 <insert_sorted_with_merge_freeList+0x444>
						iterator->size = iterator->size + blockToInsert->size;
						addToAvailMemBlocksList(blockToInsert);
					}
					//Insert
					else {
						LIST_INSERT_BEFORE(&FreeMemBlocksList, iterator,
  803610:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803614:	74 06                	je     80361c <insert_sorted_with_merge_freeList+0x3ac>
  803616:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80361a:	75 17                	jne    803633 <insert_sorted_with_merge_freeList+0x3c3>
  80361c:	83 ec 04             	sub    $0x4,%esp
  80361f:	68 dc 42 80 00       	push   $0x8042dc
  803624:	68 56 01 00 00       	push   $0x156
  803629:	68 4b 42 80 00       	push   $0x80424b
  80362e:	e8 a4 d2 ff ff       	call   8008d7 <_panic>
  803633:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803636:	8b 50 04             	mov    0x4(%eax),%edx
  803639:	8b 45 08             	mov    0x8(%ebp),%eax
  80363c:	89 50 04             	mov    %edx,0x4(%eax)
  80363f:	8b 45 08             	mov    0x8(%ebp),%eax
  803642:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803645:	89 10                	mov    %edx,(%eax)
  803647:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80364a:	8b 40 04             	mov    0x4(%eax),%eax
  80364d:	85 c0                	test   %eax,%eax
  80364f:	74 0d                	je     80365e <insert_sorted_with_merge_freeList+0x3ee>
  803651:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803654:	8b 40 04             	mov    0x4(%eax),%eax
  803657:	8b 55 08             	mov    0x8(%ebp),%edx
  80365a:	89 10                	mov    %edx,(%eax)
  80365c:	eb 08                	jmp    803666 <insert_sorted_with_merge_freeList+0x3f6>
  80365e:	8b 45 08             	mov    0x8(%ebp),%eax
  803661:	a3 38 51 80 00       	mov    %eax,0x805138
  803666:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803669:	8b 55 08             	mov    0x8(%ebp),%edx
  80366c:	89 50 04             	mov    %edx,0x4(%eax)
  80366f:	a1 44 51 80 00       	mov    0x805144,%eax
  803674:	40                   	inc    %eax
  803675:	a3 44 51 80 00       	mov    %eax,0x805144
								blockToInsert);
					}
					break;
  80367a:	eb 38                	jmp    8036b4 <insert_sorted_with_merge_freeList+0x444>
		} else {
			LIST_INSERT_AFTER(&FreeMemBlocksList, last, blockToInsert);
		}
	} else {
		struct MemBlock *iterator;
		LIST_FOREACH(iterator, &(FreeMemBlocksList))
  80367c:	a1 40 51 80 00       	mov    0x805140,%eax
  803681:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803684:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803688:	74 07                	je     803691 <insert_sorted_with_merge_freeList+0x421>
  80368a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80368d:	8b 00                	mov    (%eax),%eax
  80368f:	eb 05                	jmp    803696 <insert_sorted_with_merge_freeList+0x426>
  803691:	b8 00 00 00 00       	mov    $0x0,%eax
  803696:	a3 40 51 80 00       	mov    %eax,0x805140
  80369b:	a1 40 51 80 00       	mov    0x805140,%eax
  8036a0:	85 c0                	test   %eax,%eax
  8036a2:	0f 85 1a fd ff ff    	jne    8033c2 <insert_sorted_with_merge_freeList+0x152>
  8036a8:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8036ac:	0f 85 10 fd ff ff    	jne    8033c2 <insert_sorted_with_merge_freeList+0x152>
		}
	}

	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  8036b2:	eb 00                	jmp    8036b4 <insert_sorted_with_merge_freeList+0x444>
  8036b4:	90                   	nop
  8036b5:	c9                   	leave  
  8036b6:	c3                   	ret    
  8036b7:	90                   	nop

008036b8 <__udivdi3>:
  8036b8:	55                   	push   %ebp
  8036b9:	57                   	push   %edi
  8036ba:	56                   	push   %esi
  8036bb:	53                   	push   %ebx
  8036bc:	83 ec 1c             	sub    $0x1c,%esp
  8036bf:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  8036c3:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  8036c7:	8b 7c 24 38          	mov    0x38(%esp),%edi
  8036cb:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8036cf:	89 ca                	mov    %ecx,%edx
  8036d1:	89 f8                	mov    %edi,%eax
  8036d3:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  8036d7:	85 f6                	test   %esi,%esi
  8036d9:	75 2d                	jne    803708 <__udivdi3+0x50>
  8036db:	39 cf                	cmp    %ecx,%edi
  8036dd:	77 65                	ja     803744 <__udivdi3+0x8c>
  8036df:	89 fd                	mov    %edi,%ebp
  8036e1:	85 ff                	test   %edi,%edi
  8036e3:	75 0b                	jne    8036f0 <__udivdi3+0x38>
  8036e5:	b8 01 00 00 00       	mov    $0x1,%eax
  8036ea:	31 d2                	xor    %edx,%edx
  8036ec:	f7 f7                	div    %edi
  8036ee:	89 c5                	mov    %eax,%ebp
  8036f0:	31 d2                	xor    %edx,%edx
  8036f2:	89 c8                	mov    %ecx,%eax
  8036f4:	f7 f5                	div    %ebp
  8036f6:	89 c1                	mov    %eax,%ecx
  8036f8:	89 d8                	mov    %ebx,%eax
  8036fa:	f7 f5                	div    %ebp
  8036fc:	89 cf                	mov    %ecx,%edi
  8036fe:	89 fa                	mov    %edi,%edx
  803700:	83 c4 1c             	add    $0x1c,%esp
  803703:	5b                   	pop    %ebx
  803704:	5e                   	pop    %esi
  803705:	5f                   	pop    %edi
  803706:	5d                   	pop    %ebp
  803707:	c3                   	ret    
  803708:	39 ce                	cmp    %ecx,%esi
  80370a:	77 28                	ja     803734 <__udivdi3+0x7c>
  80370c:	0f bd fe             	bsr    %esi,%edi
  80370f:	83 f7 1f             	xor    $0x1f,%edi
  803712:	75 40                	jne    803754 <__udivdi3+0x9c>
  803714:	39 ce                	cmp    %ecx,%esi
  803716:	72 0a                	jb     803722 <__udivdi3+0x6a>
  803718:	3b 44 24 08          	cmp    0x8(%esp),%eax
  80371c:	0f 87 9e 00 00 00    	ja     8037c0 <__udivdi3+0x108>
  803722:	b8 01 00 00 00       	mov    $0x1,%eax
  803727:	89 fa                	mov    %edi,%edx
  803729:	83 c4 1c             	add    $0x1c,%esp
  80372c:	5b                   	pop    %ebx
  80372d:	5e                   	pop    %esi
  80372e:	5f                   	pop    %edi
  80372f:	5d                   	pop    %ebp
  803730:	c3                   	ret    
  803731:	8d 76 00             	lea    0x0(%esi),%esi
  803734:	31 ff                	xor    %edi,%edi
  803736:	31 c0                	xor    %eax,%eax
  803738:	89 fa                	mov    %edi,%edx
  80373a:	83 c4 1c             	add    $0x1c,%esp
  80373d:	5b                   	pop    %ebx
  80373e:	5e                   	pop    %esi
  80373f:	5f                   	pop    %edi
  803740:	5d                   	pop    %ebp
  803741:	c3                   	ret    
  803742:	66 90                	xchg   %ax,%ax
  803744:	89 d8                	mov    %ebx,%eax
  803746:	f7 f7                	div    %edi
  803748:	31 ff                	xor    %edi,%edi
  80374a:	89 fa                	mov    %edi,%edx
  80374c:	83 c4 1c             	add    $0x1c,%esp
  80374f:	5b                   	pop    %ebx
  803750:	5e                   	pop    %esi
  803751:	5f                   	pop    %edi
  803752:	5d                   	pop    %ebp
  803753:	c3                   	ret    
  803754:	bd 20 00 00 00       	mov    $0x20,%ebp
  803759:	89 eb                	mov    %ebp,%ebx
  80375b:	29 fb                	sub    %edi,%ebx
  80375d:	89 f9                	mov    %edi,%ecx
  80375f:	d3 e6                	shl    %cl,%esi
  803761:	89 c5                	mov    %eax,%ebp
  803763:	88 d9                	mov    %bl,%cl
  803765:	d3 ed                	shr    %cl,%ebp
  803767:	89 e9                	mov    %ebp,%ecx
  803769:	09 f1                	or     %esi,%ecx
  80376b:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  80376f:	89 f9                	mov    %edi,%ecx
  803771:	d3 e0                	shl    %cl,%eax
  803773:	89 c5                	mov    %eax,%ebp
  803775:	89 d6                	mov    %edx,%esi
  803777:	88 d9                	mov    %bl,%cl
  803779:	d3 ee                	shr    %cl,%esi
  80377b:	89 f9                	mov    %edi,%ecx
  80377d:	d3 e2                	shl    %cl,%edx
  80377f:	8b 44 24 08          	mov    0x8(%esp),%eax
  803783:	88 d9                	mov    %bl,%cl
  803785:	d3 e8                	shr    %cl,%eax
  803787:	09 c2                	or     %eax,%edx
  803789:	89 d0                	mov    %edx,%eax
  80378b:	89 f2                	mov    %esi,%edx
  80378d:	f7 74 24 0c          	divl   0xc(%esp)
  803791:	89 d6                	mov    %edx,%esi
  803793:	89 c3                	mov    %eax,%ebx
  803795:	f7 e5                	mul    %ebp
  803797:	39 d6                	cmp    %edx,%esi
  803799:	72 19                	jb     8037b4 <__udivdi3+0xfc>
  80379b:	74 0b                	je     8037a8 <__udivdi3+0xf0>
  80379d:	89 d8                	mov    %ebx,%eax
  80379f:	31 ff                	xor    %edi,%edi
  8037a1:	e9 58 ff ff ff       	jmp    8036fe <__udivdi3+0x46>
  8037a6:	66 90                	xchg   %ax,%ax
  8037a8:	8b 54 24 08          	mov    0x8(%esp),%edx
  8037ac:	89 f9                	mov    %edi,%ecx
  8037ae:	d3 e2                	shl    %cl,%edx
  8037b0:	39 c2                	cmp    %eax,%edx
  8037b2:	73 e9                	jae    80379d <__udivdi3+0xe5>
  8037b4:	8d 43 ff             	lea    -0x1(%ebx),%eax
  8037b7:	31 ff                	xor    %edi,%edi
  8037b9:	e9 40 ff ff ff       	jmp    8036fe <__udivdi3+0x46>
  8037be:	66 90                	xchg   %ax,%ax
  8037c0:	31 c0                	xor    %eax,%eax
  8037c2:	e9 37 ff ff ff       	jmp    8036fe <__udivdi3+0x46>
  8037c7:	90                   	nop

008037c8 <__umoddi3>:
  8037c8:	55                   	push   %ebp
  8037c9:	57                   	push   %edi
  8037ca:	56                   	push   %esi
  8037cb:	53                   	push   %ebx
  8037cc:	83 ec 1c             	sub    $0x1c,%esp
  8037cf:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  8037d3:	8b 74 24 34          	mov    0x34(%esp),%esi
  8037d7:	8b 7c 24 38          	mov    0x38(%esp),%edi
  8037db:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  8037df:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8037e3:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8037e7:	89 f3                	mov    %esi,%ebx
  8037e9:	89 fa                	mov    %edi,%edx
  8037eb:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8037ef:	89 34 24             	mov    %esi,(%esp)
  8037f2:	85 c0                	test   %eax,%eax
  8037f4:	75 1a                	jne    803810 <__umoddi3+0x48>
  8037f6:	39 f7                	cmp    %esi,%edi
  8037f8:	0f 86 a2 00 00 00    	jbe    8038a0 <__umoddi3+0xd8>
  8037fe:	89 c8                	mov    %ecx,%eax
  803800:	89 f2                	mov    %esi,%edx
  803802:	f7 f7                	div    %edi
  803804:	89 d0                	mov    %edx,%eax
  803806:	31 d2                	xor    %edx,%edx
  803808:	83 c4 1c             	add    $0x1c,%esp
  80380b:	5b                   	pop    %ebx
  80380c:	5e                   	pop    %esi
  80380d:	5f                   	pop    %edi
  80380e:	5d                   	pop    %ebp
  80380f:	c3                   	ret    
  803810:	39 f0                	cmp    %esi,%eax
  803812:	0f 87 ac 00 00 00    	ja     8038c4 <__umoddi3+0xfc>
  803818:	0f bd e8             	bsr    %eax,%ebp
  80381b:	83 f5 1f             	xor    $0x1f,%ebp
  80381e:	0f 84 ac 00 00 00    	je     8038d0 <__umoddi3+0x108>
  803824:	bf 20 00 00 00       	mov    $0x20,%edi
  803829:	29 ef                	sub    %ebp,%edi
  80382b:	89 fe                	mov    %edi,%esi
  80382d:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  803831:	89 e9                	mov    %ebp,%ecx
  803833:	d3 e0                	shl    %cl,%eax
  803835:	89 d7                	mov    %edx,%edi
  803837:	89 f1                	mov    %esi,%ecx
  803839:	d3 ef                	shr    %cl,%edi
  80383b:	09 c7                	or     %eax,%edi
  80383d:	89 e9                	mov    %ebp,%ecx
  80383f:	d3 e2                	shl    %cl,%edx
  803841:	89 14 24             	mov    %edx,(%esp)
  803844:	89 d8                	mov    %ebx,%eax
  803846:	d3 e0                	shl    %cl,%eax
  803848:	89 c2                	mov    %eax,%edx
  80384a:	8b 44 24 08          	mov    0x8(%esp),%eax
  80384e:	d3 e0                	shl    %cl,%eax
  803850:	89 44 24 04          	mov    %eax,0x4(%esp)
  803854:	8b 44 24 08          	mov    0x8(%esp),%eax
  803858:	89 f1                	mov    %esi,%ecx
  80385a:	d3 e8                	shr    %cl,%eax
  80385c:	09 d0                	or     %edx,%eax
  80385e:	d3 eb                	shr    %cl,%ebx
  803860:	89 da                	mov    %ebx,%edx
  803862:	f7 f7                	div    %edi
  803864:	89 d3                	mov    %edx,%ebx
  803866:	f7 24 24             	mull   (%esp)
  803869:	89 c6                	mov    %eax,%esi
  80386b:	89 d1                	mov    %edx,%ecx
  80386d:	39 d3                	cmp    %edx,%ebx
  80386f:	0f 82 87 00 00 00    	jb     8038fc <__umoddi3+0x134>
  803875:	0f 84 91 00 00 00    	je     80390c <__umoddi3+0x144>
  80387b:	8b 54 24 04          	mov    0x4(%esp),%edx
  80387f:	29 f2                	sub    %esi,%edx
  803881:	19 cb                	sbb    %ecx,%ebx
  803883:	89 d8                	mov    %ebx,%eax
  803885:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  803889:	d3 e0                	shl    %cl,%eax
  80388b:	89 e9                	mov    %ebp,%ecx
  80388d:	d3 ea                	shr    %cl,%edx
  80388f:	09 d0                	or     %edx,%eax
  803891:	89 e9                	mov    %ebp,%ecx
  803893:	d3 eb                	shr    %cl,%ebx
  803895:	89 da                	mov    %ebx,%edx
  803897:	83 c4 1c             	add    $0x1c,%esp
  80389a:	5b                   	pop    %ebx
  80389b:	5e                   	pop    %esi
  80389c:	5f                   	pop    %edi
  80389d:	5d                   	pop    %ebp
  80389e:	c3                   	ret    
  80389f:	90                   	nop
  8038a0:	89 fd                	mov    %edi,%ebp
  8038a2:	85 ff                	test   %edi,%edi
  8038a4:	75 0b                	jne    8038b1 <__umoddi3+0xe9>
  8038a6:	b8 01 00 00 00       	mov    $0x1,%eax
  8038ab:	31 d2                	xor    %edx,%edx
  8038ad:	f7 f7                	div    %edi
  8038af:	89 c5                	mov    %eax,%ebp
  8038b1:	89 f0                	mov    %esi,%eax
  8038b3:	31 d2                	xor    %edx,%edx
  8038b5:	f7 f5                	div    %ebp
  8038b7:	89 c8                	mov    %ecx,%eax
  8038b9:	f7 f5                	div    %ebp
  8038bb:	89 d0                	mov    %edx,%eax
  8038bd:	e9 44 ff ff ff       	jmp    803806 <__umoddi3+0x3e>
  8038c2:	66 90                	xchg   %ax,%ax
  8038c4:	89 c8                	mov    %ecx,%eax
  8038c6:	89 f2                	mov    %esi,%edx
  8038c8:	83 c4 1c             	add    $0x1c,%esp
  8038cb:	5b                   	pop    %ebx
  8038cc:	5e                   	pop    %esi
  8038cd:	5f                   	pop    %edi
  8038ce:	5d                   	pop    %ebp
  8038cf:	c3                   	ret    
  8038d0:	3b 04 24             	cmp    (%esp),%eax
  8038d3:	72 06                	jb     8038db <__umoddi3+0x113>
  8038d5:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  8038d9:	77 0f                	ja     8038ea <__umoddi3+0x122>
  8038db:	89 f2                	mov    %esi,%edx
  8038dd:	29 f9                	sub    %edi,%ecx
  8038df:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  8038e3:	89 14 24             	mov    %edx,(%esp)
  8038e6:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8038ea:	8b 44 24 04          	mov    0x4(%esp),%eax
  8038ee:	8b 14 24             	mov    (%esp),%edx
  8038f1:	83 c4 1c             	add    $0x1c,%esp
  8038f4:	5b                   	pop    %ebx
  8038f5:	5e                   	pop    %esi
  8038f6:	5f                   	pop    %edi
  8038f7:	5d                   	pop    %ebp
  8038f8:	c3                   	ret    
  8038f9:	8d 76 00             	lea    0x0(%esi),%esi
  8038fc:	2b 04 24             	sub    (%esp),%eax
  8038ff:	19 fa                	sbb    %edi,%edx
  803901:	89 d1                	mov    %edx,%ecx
  803903:	89 c6                	mov    %eax,%esi
  803905:	e9 71 ff ff ff       	jmp    80387b <__umoddi3+0xb3>
  80390a:	66 90                	xchg   %ax,%ax
  80390c:	39 44 24 04          	cmp    %eax,0x4(%esp)
  803910:	72 ea                	jb     8038fc <__umoddi3+0x134>
  803912:	89 d9                	mov    %ebx,%ecx
  803914:	e9 62 ff ff ff       	jmp    80387b <__umoddi3+0xb3>
