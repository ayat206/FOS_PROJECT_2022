
obj/user/tst_quicksort_freeHeap:     file format elf32-i386


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
  800031:	e8 30 08 00 00       	call   800866 <libmain>
1:      jmp 1b
  800036:	eb fe                	jmp    800036 <args_exist+0x5>

00800038 <_main>:
uint32 CheckSorted(int *Elements, int NumOfElements);

int CheckAndCountEmptyLocInWS(volatile struct Env *myEnv);

void _main(void)
{
  800038:	55                   	push   %ebp
  800039:	89 e5                	mov    %esp,%ebp
  80003b:	53                   	push   %ebx
  80003c:	81 ec 44 01 00 00    	sub    $0x144,%esp


	//int InitFreeFrames = sys_calculate_free_frames() ;
	char Line[255] ;
	char Chose ;
	int Iteration = 0 ;
  800042:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	do
	{

		Iteration++ ;
  800049:	ff 45 f0             	incl   -0x10(%ebp)
		//		cprintf("Free Frames Before Allocation = %d\n", sys_calculate_free_frames()) ;

	sys_disable_interrupt();
  80004c:	e8 96 22 00 00       	call   8022e7 <sys_disable_interrupt>
		readline("Enter the number of elements: ", Line);
  800051:	83 ec 08             	sub    $0x8,%esp
  800054:	8d 85 c5 fe ff ff    	lea    -0x13b(%ebp),%eax
  80005a:	50                   	push   %eax
  80005b:	68 00 3a 80 00       	push   $0x803a00
  800060:	e8 73 12 00 00       	call   8012d8 <readline>
  800065:	83 c4 10             	add    $0x10,%esp
		int NumOfElements = strtol(Line, NULL, 10) ;
  800068:	83 ec 04             	sub    $0x4,%esp
  80006b:	6a 0a                	push   $0xa
  80006d:	6a 00                	push   $0x0
  80006f:	8d 85 c5 fe ff ff    	lea    -0x13b(%ebp),%eax
  800075:	50                   	push   %eax
  800076:	e8 c3 17 00 00       	call   80183e <strtol>
  80007b:	83 c4 10             	add    $0x10,%esp
  80007e:	89 45 ec             	mov    %eax,-0x14(%ebp)

		int *Elements = malloc(sizeof(int) * NumOfElements) ;
  800081:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800084:	c1 e0 02             	shl    $0x2,%eax
  800087:	83 ec 0c             	sub    $0xc,%esp
  80008a:	50                   	push   %eax
  80008b:	e8 5e 1d 00 00       	call   801dee <malloc>
  800090:	83 c4 10             	add    $0x10,%esp
  800093:	89 45 e8             	mov    %eax,-0x18(%ebp)
		uint32 num_disk_tables = 1;  //Since it is created with the first array, so it will be decremented in the 1st case only
  800096:	c7 45 e4 01 00 00 00 	movl   $0x1,-0x1c(%ebp)
		int numOFEmptyLocInWS = CheckAndCountEmptyLocInWS(myEnv);
  80009d:	a1 24 50 80 00       	mov    0x805024,%eax
  8000a2:	83 ec 0c             	sub    $0xc,%esp
  8000a5:	50                   	push   %eax
  8000a6:	e8 88 03 00 00       	call   800433 <CheckAndCountEmptyLocInWS>
  8000ab:	83 c4 10             	add    $0x10,%esp
  8000ae:	89 45 e0             	mov    %eax,-0x20(%ebp)
		int InitFreeFrames = sys_calculate_free_frames() + sys_calculate_modified_frames() - numOFEmptyLocInWS;
  8000b1:	e8 44 21 00 00       	call   8021fa <sys_calculate_free_frames>
  8000b6:	89 c3                	mov    %eax,%ebx
  8000b8:	e8 56 21 00 00       	call   802213 <sys_calculate_modified_frames>
  8000bd:	8d 14 03             	lea    (%ebx,%eax,1),%edx
  8000c0:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8000c3:	29 c2                	sub    %eax,%edx
  8000c5:	89 d0                	mov    %edx,%eax
  8000c7:	89 45 dc             	mov    %eax,-0x24(%ebp)

		Elements[NumOfElements] = 10 ;
  8000ca:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8000cd:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8000d4:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8000d7:	01 d0                	add    %edx,%eax
  8000d9:	c7 00 0a 00 00 00    	movl   $0xa,(%eax)
		//		cprintf("Free Frames After Allocation = %d\n", sys_calculate_free_frames()) ;
		cprintf("Choose the initialization method:\n") ;
  8000df:	83 ec 0c             	sub    $0xc,%esp
  8000e2:	68 20 3a 80 00       	push   $0x803a20
  8000e7:	e8 6a 0b 00 00       	call   800c56 <cprintf>
  8000ec:	83 c4 10             	add    $0x10,%esp
		cprintf("a) Ascending\n") ;
  8000ef:	83 ec 0c             	sub    $0xc,%esp
  8000f2:	68 43 3a 80 00       	push   $0x803a43
  8000f7:	e8 5a 0b 00 00       	call   800c56 <cprintf>
  8000fc:	83 c4 10             	add    $0x10,%esp
		cprintf("b) Descending\n") ;
  8000ff:	83 ec 0c             	sub    $0xc,%esp
  800102:	68 51 3a 80 00       	push   $0x803a51
  800107:	e8 4a 0b 00 00       	call   800c56 <cprintf>
  80010c:	83 c4 10             	add    $0x10,%esp
		cprintf("c) Semi random\n") ;
  80010f:	83 ec 0c             	sub    $0xc,%esp
  800112:	68 60 3a 80 00       	push   $0x803a60
  800117:	e8 3a 0b 00 00       	call   800c56 <cprintf>
  80011c:	83 c4 10             	add    $0x10,%esp
		do
		{
			cprintf("Select: ") ;
  80011f:	83 ec 0c             	sub    $0xc,%esp
  800122:	68 70 3a 80 00       	push   $0x803a70
  800127:	e8 2a 0b 00 00       	call   800c56 <cprintf>
  80012c:	83 c4 10             	add    $0x10,%esp
			Chose = getchar() ;
  80012f:	e8 da 06 00 00       	call   80080e <getchar>
  800134:	88 45 f7             	mov    %al,-0x9(%ebp)
			cputchar(Chose);
  800137:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
  80013b:	83 ec 0c             	sub    $0xc,%esp
  80013e:	50                   	push   %eax
  80013f:	e8 82 06 00 00       	call   8007c6 <cputchar>
  800144:	83 c4 10             	add    $0x10,%esp
			cputchar('\n');
  800147:	83 ec 0c             	sub    $0xc,%esp
  80014a:	6a 0a                	push   $0xa
  80014c:	e8 75 06 00 00       	call   8007c6 <cputchar>
  800151:	83 c4 10             	add    $0x10,%esp
		} while (Chose != 'a' && Chose != 'b' && Chose != 'c');
  800154:	80 7d f7 61          	cmpb   $0x61,-0x9(%ebp)
  800158:	74 0c                	je     800166 <_main+0x12e>
  80015a:	80 7d f7 62          	cmpb   $0x62,-0x9(%ebp)
  80015e:	74 06                	je     800166 <_main+0x12e>
  800160:	80 7d f7 63          	cmpb   $0x63,-0x9(%ebp)
  800164:	75 b9                	jne    80011f <_main+0xe7>
	sys_enable_interrupt();
  800166:	e8 96 21 00 00       	call   802301 <sys_enable_interrupt>
		int  i ;
		switch (Chose)
  80016b:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
  80016f:	83 f8 62             	cmp    $0x62,%eax
  800172:	74 1d                	je     800191 <_main+0x159>
  800174:	83 f8 63             	cmp    $0x63,%eax
  800177:	74 2b                	je     8001a4 <_main+0x16c>
  800179:	83 f8 61             	cmp    $0x61,%eax
  80017c:	75 39                	jne    8001b7 <_main+0x17f>
		{
		case 'a':
			InitializeAscending(Elements, NumOfElements);
  80017e:	83 ec 08             	sub    $0x8,%esp
  800181:	ff 75 ec             	pushl  -0x14(%ebp)
  800184:	ff 75 e8             	pushl  -0x18(%ebp)
  800187:	e8 02 05 00 00       	call   80068e <InitializeAscending>
  80018c:	83 c4 10             	add    $0x10,%esp
			break ;
  80018f:	eb 37                	jmp    8001c8 <_main+0x190>
		case 'b':
			InitializeDescending(Elements, NumOfElements);
  800191:	83 ec 08             	sub    $0x8,%esp
  800194:	ff 75 ec             	pushl  -0x14(%ebp)
  800197:	ff 75 e8             	pushl  -0x18(%ebp)
  80019a:	e8 20 05 00 00       	call   8006bf <InitializeDescending>
  80019f:	83 c4 10             	add    $0x10,%esp
			break ;
  8001a2:	eb 24                	jmp    8001c8 <_main+0x190>
		case 'c':
			InitializeSemiRandom(Elements, NumOfElements);
  8001a4:	83 ec 08             	sub    $0x8,%esp
  8001a7:	ff 75 ec             	pushl  -0x14(%ebp)
  8001aa:	ff 75 e8             	pushl  -0x18(%ebp)
  8001ad:	e8 42 05 00 00       	call   8006f4 <InitializeSemiRandom>
  8001b2:	83 c4 10             	add    $0x10,%esp
			break ;
  8001b5:	eb 11                	jmp    8001c8 <_main+0x190>
		default:
			InitializeSemiRandom(Elements, NumOfElements);
  8001b7:	83 ec 08             	sub    $0x8,%esp
  8001ba:	ff 75 ec             	pushl  -0x14(%ebp)
  8001bd:	ff 75 e8             	pushl  -0x18(%ebp)
  8001c0:	e8 2f 05 00 00       	call   8006f4 <InitializeSemiRandom>
  8001c5:	83 c4 10             	add    $0x10,%esp
		}

		QuickSort(Elements, NumOfElements);
  8001c8:	83 ec 08             	sub    $0x8,%esp
  8001cb:	ff 75 ec             	pushl  -0x14(%ebp)
  8001ce:	ff 75 e8             	pushl  -0x18(%ebp)
  8001d1:	e8 fd 02 00 00       	call   8004d3 <QuickSort>
  8001d6:	83 c4 10             	add    $0x10,%esp

		//		PrintElements(Elements, NumOfElements);

		uint32 Sorted = CheckSorted(Elements, NumOfElements);
  8001d9:	83 ec 08             	sub    $0x8,%esp
  8001dc:	ff 75 ec             	pushl  -0x14(%ebp)
  8001df:	ff 75 e8             	pushl  -0x18(%ebp)
  8001e2:	e8 fd 03 00 00       	call   8005e4 <CheckSorted>
  8001e7:	83 c4 10             	add    $0x10,%esp
  8001ea:	89 45 d8             	mov    %eax,-0x28(%ebp)

		if(Sorted == 0) panic("The array is NOT sorted correctly") ;
  8001ed:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  8001f1:	75 14                	jne    800207 <_main+0x1cf>
  8001f3:	83 ec 04             	sub    $0x4,%esp
  8001f6:	68 7c 3a 80 00       	push   $0x803a7c
  8001fb:	6a 57                	push   $0x57
  8001fd:	68 9e 3a 80 00       	push   $0x803a9e
  800202:	e8 9b 07 00 00       	call   8009a2 <_panic>
		else
		{
			cprintf("===============================================\n") ;
  800207:	83 ec 0c             	sub    $0xc,%esp
  80020a:	68 bc 3a 80 00       	push   $0x803abc
  80020f:	e8 42 0a 00 00       	call   800c56 <cprintf>
  800214:	83 c4 10             	add    $0x10,%esp
			cprintf("Congratulations!! The array is sorted correctly\n") ;
  800217:	83 ec 0c             	sub    $0xc,%esp
  80021a:	68 f0 3a 80 00       	push   $0x803af0
  80021f:	e8 32 0a 00 00       	call   800c56 <cprintf>
  800224:	83 c4 10             	add    $0x10,%esp
			cprintf("===============================================\n\n") ;
  800227:	83 ec 0c             	sub    $0xc,%esp
  80022a:	68 24 3b 80 00       	push   $0x803b24
  80022f:	e8 22 0a 00 00       	call   800c56 <cprintf>
  800234:	83 c4 10             	add    $0x10,%esp
		}

		//		cprintf("Free Frames After Calculation = %d\n", sys_calculate_free_frames()) ;

		cprintf("Freeing the Heap...\n\n") ;
  800237:	83 ec 0c             	sub    $0xc,%esp
  80023a:	68 56 3b 80 00       	push   $0x803b56
  80023f:	e8 12 0a 00 00       	call   800c56 <cprintf>
  800244:	83 c4 10             	add    $0x10,%esp
		free(Elements) ;
  800247:	83 ec 0c             	sub    $0xc,%esp
  80024a:	ff 75 e8             	pushl  -0x18(%ebp)
  80024d:	e8 1d 1c 00 00       	call   801e6f <free>
  800252:	83 c4 10             	add    $0x10,%esp


		///Testing the freeHeap according to the specified scenario
		if (Iteration == 1)
  800255:	83 7d f0 01          	cmpl   $0x1,-0x10(%ebp)
  800259:	75 7b                	jne    8002d6 <_main+0x29e>
		{
			InitFreeFrames -= num_disk_tables;
  80025b:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80025e:	2b 45 e4             	sub    -0x1c(%ebp),%eax
  800261:	89 45 dc             	mov    %eax,-0x24(%ebp)
			if (!(NumOfElements == 1000 && Chose == 'a'))
  800264:	81 7d ec e8 03 00 00 	cmpl   $0x3e8,-0x14(%ebp)
  80026b:	75 06                	jne    800273 <_main+0x23b>
  80026d:	80 7d f7 61          	cmpb   $0x61,-0x9(%ebp)
  800271:	74 14                	je     800287 <_main+0x24f>
				panic("Please ensure the number of elements and the initialization method of this test");
  800273:	83 ec 04             	sub    $0x4,%esp
  800276:	68 6c 3b 80 00       	push   $0x803b6c
  80027b:	6a 6a                	push   $0x6a
  80027d:	68 9e 3a 80 00       	push   $0x803a9e
  800282:	e8 1b 07 00 00       	call   8009a2 <_panic>

			numOFEmptyLocInWS = CheckAndCountEmptyLocInWS(myEnv);
  800287:	a1 24 50 80 00       	mov    0x805024,%eax
  80028c:	83 ec 0c             	sub    $0xc,%esp
  80028f:	50                   	push   %eax
  800290:	e8 9e 01 00 00       	call   800433 <CheckAndCountEmptyLocInWS>
  800295:	83 c4 10             	add    $0x10,%esp
  800298:	89 45 e0             	mov    %eax,-0x20(%ebp)
			int CurrFreeFrames = sys_calculate_free_frames() + sys_calculate_modified_frames() - numOFEmptyLocInWS;
  80029b:	e8 5a 1f 00 00       	call   8021fa <sys_calculate_free_frames>
  8002a0:	89 c3                	mov    %eax,%ebx
  8002a2:	e8 6c 1f 00 00       	call   802213 <sys_calculate_modified_frames>
  8002a7:	8d 14 03             	lea    (%ebx,%eax,1),%edx
  8002aa:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8002ad:	29 c2                	sub    %eax,%edx
  8002af:	89 d0                	mov    %edx,%eax
  8002b1:	89 45 d4             	mov    %eax,-0x2c(%ebp)
			assert(CurrFreeFrames - InitFreeFrames == 0) ;
  8002b4:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8002b7:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  8002ba:	0f 84 05 01 00 00    	je     8003c5 <_main+0x38d>
  8002c0:	68 bc 3b 80 00       	push   $0x803bbc
  8002c5:	68 e1 3b 80 00       	push   $0x803be1
  8002ca:	6a 6e                	push   $0x6e
  8002cc:	68 9e 3a 80 00       	push   $0x803a9e
  8002d1:	e8 cc 06 00 00       	call   8009a2 <_panic>
		}
		else if (Iteration == 2 )
  8002d6:	83 7d f0 02          	cmpl   $0x2,-0x10(%ebp)
  8002da:	75 72                	jne    80034e <_main+0x316>
		{
			if (!(NumOfElements == 5000 && Chose == 'b'))
  8002dc:	81 7d ec 88 13 00 00 	cmpl   $0x1388,-0x14(%ebp)
  8002e3:	75 06                	jne    8002eb <_main+0x2b3>
  8002e5:	80 7d f7 62          	cmpb   $0x62,-0x9(%ebp)
  8002e9:	74 14                	je     8002ff <_main+0x2c7>
				panic("Please ensure the number of elements and the initialization method of this test");
  8002eb:	83 ec 04             	sub    $0x4,%esp
  8002ee:	68 6c 3b 80 00       	push   $0x803b6c
  8002f3:	6a 73                	push   $0x73
  8002f5:	68 9e 3a 80 00       	push   $0x803a9e
  8002fa:	e8 a3 06 00 00       	call   8009a2 <_panic>

			int numOFEmptyLocInWS = CheckAndCountEmptyLocInWS(myEnv);
  8002ff:	a1 24 50 80 00       	mov    0x805024,%eax
  800304:	83 ec 0c             	sub    $0xc,%esp
  800307:	50                   	push   %eax
  800308:	e8 26 01 00 00       	call   800433 <CheckAndCountEmptyLocInWS>
  80030d:	83 c4 10             	add    $0x10,%esp
  800310:	89 45 d0             	mov    %eax,-0x30(%ebp)
			int CurrFreeFrames = sys_calculate_free_frames() + sys_calculate_modified_frames() - numOFEmptyLocInWS;
  800313:	e8 e2 1e 00 00       	call   8021fa <sys_calculate_free_frames>
  800318:	89 c3                	mov    %eax,%ebx
  80031a:	e8 f4 1e 00 00       	call   802213 <sys_calculate_modified_frames>
  80031f:	8d 14 03             	lea    (%ebx,%eax,1),%edx
  800322:	8b 45 d0             	mov    -0x30(%ebp),%eax
  800325:	29 c2                	sub    %eax,%edx
  800327:	89 d0                	mov    %edx,%eax
  800329:	89 45 cc             	mov    %eax,-0x34(%ebp)
			assert(CurrFreeFrames - InitFreeFrames == 0) ;
  80032c:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80032f:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  800332:	0f 84 8d 00 00 00    	je     8003c5 <_main+0x38d>
  800338:	68 bc 3b 80 00       	push   $0x803bbc
  80033d:	68 e1 3b 80 00       	push   $0x803be1
  800342:	6a 77                	push   $0x77
  800344:	68 9e 3a 80 00       	push   $0x803a9e
  800349:	e8 54 06 00 00       	call   8009a2 <_panic>
		}
		else if (Iteration == 3 )
  80034e:	83 7d f0 03          	cmpl   $0x3,-0x10(%ebp)
  800352:	75 71                	jne    8003c5 <_main+0x38d>
		{
			if (!(NumOfElements == 300000 && Chose == 'c'))
  800354:	81 7d ec e0 93 04 00 	cmpl   $0x493e0,-0x14(%ebp)
  80035b:	75 06                	jne    800363 <_main+0x32b>
  80035d:	80 7d f7 63          	cmpb   $0x63,-0x9(%ebp)
  800361:	74 14                	je     800377 <_main+0x33f>
				panic("Please ensure the number of elements and the initialization method of this test");
  800363:	83 ec 04             	sub    $0x4,%esp
  800366:	68 6c 3b 80 00       	push   $0x803b6c
  80036b:	6a 7c                	push   $0x7c
  80036d:	68 9e 3a 80 00       	push   $0x803a9e
  800372:	e8 2b 06 00 00       	call   8009a2 <_panic>

			int numOFEmptyLocInWS = CheckAndCountEmptyLocInWS(myEnv);
  800377:	a1 24 50 80 00       	mov    0x805024,%eax
  80037c:	83 ec 0c             	sub    $0xc,%esp
  80037f:	50                   	push   %eax
  800380:	e8 ae 00 00 00       	call   800433 <CheckAndCountEmptyLocInWS>
  800385:	83 c4 10             	add    $0x10,%esp
  800388:	89 45 c8             	mov    %eax,-0x38(%ebp)
			int CurrFreeFrames = sys_calculate_free_frames() + sys_calculate_modified_frames() - numOFEmptyLocInWS;
  80038b:	e8 6a 1e 00 00       	call   8021fa <sys_calculate_free_frames>
  800390:	89 c3                	mov    %eax,%ebx
  800392:	e8 7c 1e 00 00       	call   802213 <sys_calculate_modified_frames>
  800397:	8d 14 03             	lea    (%ebx,%eax,1),%edx
  80039a:	8b 45 c8             	mov    -0x38(%ebp),%eax
  80039d:	29 c2                	sub    %eax,%edx
  80039f:	89 d0                	mov    %edx,%eax
  8003a1:	89 45 c4             	mov    %eax,-0x3c(%ebp)
			//cprintf("numOFEmptyLocInWS = %d\n", numOFEmptyLocInWS );
			assert(CurrFreeFrames - InitFreeFrames == 0) ;
  8003a4:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  8003a7:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  8003aa:	74 19                	je     8003c5 <_main+0x38d>
  8003ac:	68 bc 3b 80 00       	push   $0x803bbc
  8003b1:	68 e1 3b 80 00       	push   $0x803be1
  8003b6:	68 81 00 00 00       	push   $0x81
  8003bb:	68 9e 3a 80 00       	push   $0x803a9e
  8003c0:	e8 dd 05 00 00       	call   8009a2 <_panic>
		}
		///========================================================================
	sys_disable_interrupt();
  8003c5:	e8 1d 1f 00 00       	call   8022e7 <sys_disable_interrupt>
		Chose = 0 ;
  8003ca:	c6 45 f7 00          	movb   $0x0,-0x9(%ebp)
		while (Chose != 'y' && Chose != 'n')
  8003ce:	eb 42                	jmp    800412 <_main+0x3da>
		{
			cprintf("Do you want to repeat (y/n): ") ;
  8003d0:	83 ec 0c             	sub    $0xc,%esp
  8003d3:	68 f6 3b 80 00       	push   $0x803bf6
  8003d8:	e8 79 08 00 00       	call   800c56 <cprintf>
  8003dd:	83 c4 10             	add    $0x10,%esp
			Chose = getchar() ;
  8003e0:	e8 29 04 00 00       	call   80080e <getchar>
  8003e5:	88 45 f7             	mov    %al,-0x9(%ebp)
			cputchar(Chose);
  8003e8:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
  8003ec:	83 ec 0c             	sub    $0xc,%esp
  8003ef:	50                   	push   %eax
  8003f0:	e8 d1 03 00 00       	call   8007c6 <cputchar>
  8003f5:	83 c4 10             	add    $0x10,%esp
			cputchar('\n');
  8003f8:	83 ec 0c             	sub    $0xc,%esp
  8003fb:	6a 0a                	push   $0xa
  8003fd:	e8 c4 03 00 00       	call   8007c6 <cputchar>
  800402:	83 c4 10             	add    $0x10,%esp
			cputchar('\n');
  800405:	83 ec 0c             	sub    $0xc,%esp
  800408:	6a 0a                	push   $0xa
  80040a:	e8 b7 03 00 00       	call   8007c6 <cputchar>
  80040f:	83 c4 10             	add    $0x10,%esp
			assert(CurrFreeFrames - InitFreeFrames == 0) ;
		}
		///========================================================================
	sys_disable_interrupt();
		Chose = 0 ;
		while (Chose != 'y' && Chose != 'n')
  800412:	80 7d f7 79          	cmpb   $0x79,-0x9(%ebp)
  800416:	74 06                	je     80041e <_main+0x3e6>
  800418:	80 7d f7 6e          	cmpb   $0x6e,-0x9(%ebp)
  80041c:	75 b2                	jne    8003d0 <_main+0x398>
			Chose = getchar() ;
			cputchar(Chose);
			cputchar('\n');
			cputchar('\n');
		}
	sys_enable_interrupt();
  80041e:	e8 de 1e 00 00       	call   802301 <sys_enable_interrupt>

	} while (Chose == 'y');
  800423:	80 7d f7 79          	cmpb   $0x79,-0x9(%ebp)
  800427:	0f 84 1c fc ff ff    	je     800049 <_main+0x11>
}
  80042d:	90                   	nop
  80042e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800431:	c9                   	leave  
  800432:	c3                   	ret    

00800433 <CheckAndCountEmptyLocInWS>:

int CheckAndCountEmptyLocInWS(volatile struct Env *myEnv)
{
  800433:	55                   	push   %ebp
  800434:	89 e5                	mov    %esp,%ebp
  800436:	83 ec 18             	sub    $0x18,%esp
	int numOFEmptyLocInWS = 0, i;
  800439:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (i = 0 ; i < myEnv->page_WS_max_size; i++)
  800440:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800447:	eb 74                	jmp    8004bd <CheckAndCountEmptyLocInWS+0x8a>
	{
		if (myEnv->__uptr_pws[i].empty)
  800449:	8b 45 08             	mov    0x8(%ebp),%eax
  80044c:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  800452:	8b 55 f0             	mov    -0x10(%ebp),%edx
  800455:	89 d0                	mov    %edx,%eax
  800457:	01 c0                	add    %eax,%eax
  800459:	01 d0                	add    %edx,%eax
  80045b:	c1 e0 03             	shl    $0x3,%eax
  80045e:	01 c8                	add    %ecx,%eax
  800460:	8a 40 04             	mov    0x4(%eax),%al
  800463:	84 c0                	test   %al,%al
  800465:	74 05                	je     80046c <CheckAndCountEmptyLocInWS+0x39>
		{
			numOFEmptyLocInWS++;
  800467:	ff 45 f4             	incl   -0xc(%ebp)
  80046a:	eb 4e                	jmp    8004ba <CheckAndCountEmptyLocInWS+0x87>
		}
		else
		{
			uint32 va = ROUNDDOWN(myEnv->__uptr_pws[i].virtual_address,PAGE_SIZE) ;
  80046c:	8b 45 08             	mov    0x8(%ebp),%eax
  80046f:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  800475:	8b 55 f0             	mov    -0x10(%ebp),%edx
  800478:	89 d0                	mov    %edx,%eax
  80047a:	01 c0                	add    %eax,%eax
  80047c:	01 d0                	add    %edx,%eax
  80047e:	c1 e0 03             	shl    $0x3,%eax
  800481:	01 c8                	add    %ecx,%eax
  800483:	8b 00                	mov    (%eax),%eax
  800485:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800488:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80048b:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800490:	89 45 e8             	mov    %eax,-0x18(%ebp)
			if (va >= USER_HEAP_START && va < (USER_HEAP_MAX))
  800493:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800496:	85 c0                	test   %eax,%eax
  800498:	79 20                	jns    8004ba <CheckAndCountEmptyLocInWS+0x87>
  80049a:	81 7d e8 ff ff ff 9f 	cmpl   $0x9fffffff,-0x18(%ebp)
  8004a1:	77 17                	ja     8004ba <CheckAndCountEmptyLocInWS+0x87>
				panic("freeMem didn't remove its page(s) from the WS");
  8004a3:	83 ec 04             	sub    $0x4,%esp
  8004a6:	68 14 3c 80 00       	push   $0x803c14
  8004ab:	68 a0 00 00 00       	push   $0xa0
  8004b0:	68 9e 3a 80 00       	push   $0x803a9e
  8004b5:	e8 e8 04 00 00       	call   8009a2 <_panic>
}

int CheckAndCountEmptyLocInWS(volatile struct Env *myEnv)
{
	int numOFEmptyLocInWS = 0, i;
	for (i = 0 ; i < myEnv->page_WS_max_size; i++)
  8004ba:	ff 45 f0             	incl   -0x10(%ebp)
  8004bd:	8b 45 08             	mov    0x8(%ebp),%eax
  8004c0:	8b 50 74             	mov    0x74(%eax),%edx
  8004c3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8004c6:	39 c2                	cmp    %eax,%edx
  8004c8:	0f 87 7b ff ff ff    	ja     800449 <CheckAndCountEmptyLocInWS+0x16>
			uint32 va = ROUNDDOWN(myEnv->__uptr_pws[i].virtual_address,PAGE_SIZE) ;
			if (va >= USER_HEAP_START && va < (USER_HEAP_MAX))
				panic("freeMem didn't remove its page(s) from the WS");
		}
	}
	return numOFEmptyLocInWS;
  8004ce:	8b 45 f4             	mov    -0xc(%ebp),%eax

}
  8004d1:	c9                   	leave  
  8004d2:	c3                   	ret    

008004d3 <QuickSort>:

///Quick sort
void QuickSort(int *Elements, int NumOfElements)
{
  8004d3:	55                   	push   %ebp
  8004d4:	89 e5                	mov    %esp,%ebp
  8004d6:	83 ec 08             	sub    $0x8,%esp
	QSort(Elements, NumOfElements, 0, NumOfElements-1) ;
  8004d9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8004dc:	48                   	dec    %eax
  8004dd:	50                   	push   %eax
  8004de:	6a 00                	push   $0x0
  8004e0:	ff 75 0c             	pushl  0xc(%ebp)
  8004e3:	ff 75 08             	pushl  0x8(%ebp)
  8004e6:	e8 06 00 00 00       	call   8004f1 <QSort>
  8004eb:	83 c4 10             	add    $0x10,%esp
}
  8004ee:	90                   	nop
  8004ef:	c9                   	leave  
  8004f0:	c3                   	ret    

008004f1 <QSort>:


void QSort(int *Elements,int NumOfElements, int startIndex, int finalIndex)
{
  8004f1:	55                   	push   %ebp
  8004f2:	89 e5                	mov    %esp,%ebp
  8004f4:	83 ec 18             	sub    $0x18,%esp
	if (startIndex >= finalIndex) return;
  8004f7:	8b 45 10             	mov    0x10(%ebp),%eax
  8004fa:	3b 45 14             	cmp    0x14(%ebp),%eax
  8004fd:	0f 8d de 00 00 00    	jge    8005e1 <QSort+0xf0>

	int i = startIndex+1, j = finalIndex;
  800503:	8b 45 10             	mov    0x10(%ebp),%eax
  800506:	40                   	inc    %eax
  800507:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80050a:	8b 45 14             	mov    0x14(%ebp),%eax
  80050d:	89 45 f0             	mov    %eax,-0x10(%ebp)

	while (i <= j)
  800510:	e9 80 00 00 00       	jmp    800595 <QSort+0xa4>
	{
		while (i <= finalIndex && Elements[startIndex] >= Elements[i]) i++;
  800515:	ff 45 f4             	incl   -0xc(%ebp)
  800518:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80051b:	3b 45 14             	cmp    0x14(%ebp),%eax
  80051e:	7f 2b                	jg     80054b <QSort+0x5a>
  800520:	8b 45 10             	mov    0x10(%ebp),%eax
  800523:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80052a:	8b 45 08             	mov    0x8(%ebp),%eax
  80052d:	01 d0                	add    %edx,%eax
  80052f:	8b 10                	mov    (%eax),%edx
  800531:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800534:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  80053b:	8b 45 08             	mov    0x8(%ebp),%eax
  80053e:	01 c8                	add    %ecx,%eax
  800540:	8b 00                	mov    (%eax),%eax
  800542:	39 c2                	cmp    %eax,%edx
  800544:	7d cf                	jge    800515 <QSort+0x24>
		while (j > startIndex && Elements[startIndex] <= Elements[j]) j--;
  800546:	eb 03                	jmp    80054b <QSort+0x5a>
  800548:	ff 4d f0             	decl   -0x10(%ebp)
  80054b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80054e:	3b 45 10             	cmp    0x10(%ebp),%eax
  800551:	7e 26                	jle    800579 <QSort+0x88>
  800553:	8b 45 10             	mov    0x10(%ebp),%eax
  800556:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80055d:	8b 45 08             	mov    0x8(%ebp),%eax
  800560:	01 d0                	add    %edx,%eax
  800562:	8b 10                	mov    (%eax),%edx
  800564:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800567:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  80056e:	8b 45 08             	mov    0x8(%ebp),%eax
  800571:	01 c8                	add    %ecx,%eax
  800573:	8b 00                	mov    (%eax),%eax
  800575:	39 c2                	cmp    %eax,%edx
  800577:	7e cf                	jle    800548 <QSort+0x57>

		if (i <= j)
  800579:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80057c:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80057f:	7f 14                	jg     800595 <QSort+0xa4>
		{
			Swap(Elements, i, j);
  800581:	83 ec 04             	sub    $0x4,%esp
  800584:	ff 75 f0             	pushl  -0x10(%ebp)
  800587:	ff 75 f4             	pushl  -0xc(%ebp)
  80058a:	ff 75 08             	pushl  0x8(%ebp)
  80058d:	e8 a9 00 00 00       	call   80063b <Swap>
  800592:	83 c4 10             	add    $0x10,%esp
{
	if (startIndex >= finalIndex) return;

	int i = startIndex+1, j = finalIndex;

	while (i <= j)
  800595:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800598:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80059b:	0f 8e 77 ff ff ff    	jle    800518 <QSort+0x27>
		{
			Swap(Elements, i, j);
		}
	}

	Swap( Elements, startIndex, j);
  8005a1:	83 ec 04             	sub    $0x4,%esp
  8005a4:	ff 75 f0             	pushl  -0x10(%ebp)
  8005a7:	ff 75 10             	pushl  0x10(%ebp)
  8005aa:	ff 75 08             	pushl  0x8(%ebp)
  8005ad:	e8 89 00 00 00       	call   80063b <Swap>
  8005b2:	83 c4 10             	add    $0x10,%esp

	QSort(Elements, NumOfElements, startIndex, j - 1);
  8005b5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8005b8:	48                   	dec    %eax
  8005b9:	50                   	push   %eax
  8005ba:	ff 75 10             	pushl  0x10(%ebp)
  8005bd:	ff 75 0c             	pushl  0xc(%ebp)
  8005c0:	ff 75 08             	pushl  0x8(%ebp)
  8005c3:	e8 29 ff ff ff       	call   8004f1 <QSort>
  8005c8:	83 c4 10             	add    $0x10,%esp
	QSort(Elements, NumOfElements, i, finalIndex);
  8005cb:	ff 75 14             	pushl  0x14(%ebp)
  8005ce:	ff 75 f4             	pushl  -0xc(%ebp)
  8005d1:	ff 75 0c             	pushl  0xc(%ebp)
  8005d4:	ff 75 08             	pushl  0x8(%ebp)
  8005d7:	e8 15 ff ff ff       	call   8004f1 <QSort>
  8005dc:	83 c4 10             	add    $0x10,%esp
  8005df:	eb 01                	jmp    8005e2 <QSort+0xf1>
}


void QSort(int *Elements,int NumOfElements, int startIndex, int finalIndex)
{
	if (startIndex >= finalIndex) return;
  8005e1:	90                   	nop

	Swap( Elements, startIndex, j);

	QSort(Elements, NumOfElements, startIndex, j - 1);
	QSort(Elements, NumOfElements, i, finalIndex);
}
  8005e2:	c9                   	leave  
  8005e3:	c3                   	ret    

008005e4 <CheckSorted>:

uint32 CheckSorted(int *Elements, int NumOfElements)
{
  8005e4:	55                   	push   %ebp
  8005e5:	89 e5                	mov    %esp,%ebp
  8005e7:	83 ec 10             	sub    $0x10,%esp
	uint32 Sorted = 1 ;
  8005ea:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
	int i ;
	for (i = 0 ; i < NumOfElements - 1; i++)
  8005f1:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  8005f8:	eb 33                	jmp    80062d <CheckSorted+0x49>
	{
		if (Elements[i] > Elements[i+1])
  8005fa:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8005fd:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800604:	8b 45 08             	mov    0x8(%ebp),%eax
  800607:	01 d0                	add    %edx,%eax
  800609:	8b 10                	mov    (%eax),%edx
  80060b:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80060e:	40                   	inc    %eax
  80060f:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  800616:	8b 45 08             	mov    0x8(%ebp),%eax
  800619:	01 c8                	add    %ecx,%eax
  80061b:	8b 00                	mov    (%eax),%eax
  80061d:	39 c2                	cmp    %eax,%edx
  80061f:	7e 09                	jle    80062a <CheckSorted+0x46>
		{
			Sorted = 0 ;
  800621:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
			break;
  800628:	eb 0c                	jmp    800636 <CheckSorted+0x52>

uint32 CheckSorted(int *Elements, int NumOfElements)
{
	uint32 Sorted = 1 ;
	int i ;
	for (i = 0 ; i < NumOfElements - 1; i++)
  80062a:	ff 45 f8             	incl   -0x8(%ebp)
  80062d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800630:	48                   	dec    %eax
  800631:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800634:	7f c4                	jg     8005fa <CheckSorted+0x16>
		{
			Sorted = 0 ;
			break;
		}
	}
	return Sorted ;
  800636:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800639:	c9                   	leave  
  80063a:	c3                   	ret    

0080063b <Swap>:

///Private Functions


void Swap(int *Elements, int First, int Second)
{
  80063b:	55                   	push   %ebp
  80063c:	89 e5                	mov    %esp,%ebp
  80063e:	83 ec 10             	sub    $0x10,%esp
	int Tmp = Elements[First] ;
  800641:	8b 45 0c             	mov    0xc(%ebp),%eax
  800644:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80064b:	8b 45 08             	mov    0x8(%ebp),%eax
  80064e:	01 d0                	add    %edx,%eax
  800650:	8b 00                	mov    (%eax),%eax
  800652:	89 45 fc             	mov    %eax,-0x4(%ebp)
	Elements[First] = Elements[Second] ;
  800655:	8b 45 0c             	mov    0xc(%ebp),%eax
  800658:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80065f:	8b 45 08             	mov    0x8(%ebp),%eax
  800662:	01 c2                	add    %eax,%edx
  800664:	8b 45 10             	mov    0x10(%ebp),%eax
  800667:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  80066e:	8b 45 08             	mov    0x8(%ebp),%eax
  800671:	01 c8                	add    %ecx,%eax
  800673:	8b 00                	mov    (%eax),%eax
  800675:	89 02                	mov    %eax,(%edx)
	Elements[Second] = Tmp ;
  800677:	8b 45 10             	mov    0x10(%ebp),%eax
  80067a:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800681:	8b 45 08             	mov    0x8(%ebp),%eax
  800684:	01 c2                	add    %eax,%edx
  800686:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800689:	89 02                	mov    %eax,(%edx)
}
  80068b:	90                   	nop
  80068c:	c9                   	leave  
  80068d:	c3                   	ret    

0080068e <InitializeAscending>:

void InitializeAscending(int *Elements, int NumOfElements)
{
  80068e:	55                   	push   %ebp
  80068f:	89 e5                	mov    %esp,%ebp
  800691:	83 ec 10             	sub    $0x10,%esp
	int i ;
	for (i = 0 ; i < NumOfElements ; i++)
  800694:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  80069b:	eb 17                	jmp    8006b4 <InitializeAscending+0x26>
	{
		(Elements)[i] = i ;
  80069d:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8006a0:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8006a7:	8b 45 08             	mov    0x8(%ebp),%eax
  8006aa:	01 c2                	add    %eax,%edx
  8006ac:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8006af:	89 02                	mov    %eax,(%edx)
}

void InitializeAscending(int *Elements, int NumOfElements)
{
	int i ;
	for (i = 0 ; i < NumOfElements ; i++)
  8006b1:	ff 45 fc             	incl   -0x4(%ebp)
  8006b4:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8006b7:	3b 45 0c             	cmp    0xc(%ebp),%eax
  8006ba:	7c e1                	jl     80069d <InitializeAscending+0xf>
	{
		(Elements)[i] = i ;
	}

}
  8006bc:	90                   	nop
  8006bd:	c9                   	leave  
  8006be:	c3                   	ret    

008006bf <InitializeDescending>:

void InitializeDescending(int *Elements, int NumOfElements)
{
  8006bf:	55                   	push   %ebp
  8006c0:	89 e5                	mov    %esp,%ebp
  8006c2:	83 ec 10             	sub    $0x10,%esp
	int i ;
	for (i = 0 ; i < NumOfElements ; i++)
  8006c5:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8006cc:	eb 1b                	jmp    8006e9 <InitializeDescending+0x2a>
	{
		Elements[i] = NumOfElements - i - 1 ;
  8006ce:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8006d1:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8006d8:	8b 45 08             	mov    0x8(%ebp),%eax
  8006db:	01 c2                	add    %eax,%edx
  8006dd:	8b 45 0c             	mov    0xc(%ebp),%eax
  8006e0:	2b 45 fc             	sub    -0x4(%ebp),%eax
  8006e3:	48                   	dec    %eax
  8006e4:	89 02                	mov    %eax,(%edx)
}

void InitializeDescending(int *Elements, int NumOfElements)
{
	int i ;
	for (i = 0 ; i < NumOfElements ; i++)
  8006e6:	ff 45 fc             	incl   -0x4(%ebp)
  8006e9:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8006ec:	3b 45 0c             	cmp    0xc(%ebp),%eax
  8006ef:	7c dd                	jl     8006ce <InitializeDescending+0xf>
	{
		Elements[i] = NumOfElements - i - 1 ;
	}

}
  8006f1:	90                   	nop
  8006f2:	c9                   	leave  
  8006f3:	c3                   	ret    

008006f4 <InitializeSemiRandom>:

void InitializeSemiRandom(int *Elements, int NumOfElements)
{
  8006f4:	55                   	push   %ebp
  8006f5:	89 e5                	mov    %esp,%ebp
  8006f7:	83 ec 10             	sub    $0x10,%esp
	int i ;
	int Repetition = NumOfElements / 3 ;
  8006fa:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8006fd:	b8 56 55 55 55       	mov    $0x55555556,%eax
  800702:	f7 e9                	imul   %ecx
  800704:	c1 f9 1f             	sar    $0x1f,%ecx
  800707:	89 d0                	mov    %edx,%eax
  800709:	29 c8                	sub    %ecx,%eax
  80070b:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0 ; i < NumOfElements ; i++)
  80070e:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800715:	eb 1e                	jmp    800735 <InitializeSemiRandom+0x41>
	{
		Elements[i] = i % Repetition ;
  800717:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80071a:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800721:	8b 45 08             	mov    0x8(%ebp),%eax
  800724:	8d 0c 02             	lea    (%edx,%eax,1),%ecx
  800727:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80072a:	99                   	cltd   
  80072b:	f7 7d f8             	idivl  -0x8(%ebp)
  80072e:	89 d0                	mov    %edx,%eax
  800730:	89 01                	mov    %eax,(%ecx)

void InitializeSemiRandom(int *Elements, int NumOfElements)
{
	int i ;
	int Repetition = NumOfElements / 3 ;
	for (i = 0 ; i < NumOfElements ; i++)
  800732:	ff 45 fc             	incl   -0x4(%ebp)
  800735:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800738:	3b 45 0c             	cmp    0xc(%ebp),%eax
  80073b:	7c da                	jl     800717 <InitializeSemiRandom+0x23>
	{
		Elements[i] = i % Repetition ;
	}

}
  80073d:	90                   	nop
  80073e:	c9                   	leave  
  80073f:	c3                   	ret    

00800740 <PrintElements>:

void PrintElements(int *Elements, int NumOfElements)
{
  800740:	55                   	push   %ebp
  800741:	89 e5                	mov    %esp,%ebp
  800743:	83 ec 18             	sub    $0x18,%esp
	int i ;
	int NumsPerLine = 20 ;
  800746:	c7 45 f0 14 00 00 00 	movl   $0x14,-0x10(%ebp)
	for (i = 0 ; i < NumOfElements-1 ; i++)
  80074d:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  800754:	eb 42                	jmp    800798 <PrintElements+0x58>
	{
		if (i%NumsPerLine == 0)
  800756:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800759:	99                   	cltd   
  80075a:	f7 7d f0             	idivl  -0x10(%ebp)
  80075d:	89 d0                	mov    %edx,%eax
  80075f:	85 c0                	test   %eax,%eax
  800761:	75 10                	jne    800773 <PrintElements+0x33>
			cprintf("\n");
  800763:	83 ec 0c             	sub    $0xc,%esp
  800766:	68 42 3c 80 00       	push   $0x803c42
  80076b:	e8 e6 04 00 00       	call   800c56 <cprintf>
  800770:	83 c4 10             	add    $0x10,%esp
		cprintf("%d, ",Elements[i]);
  800773:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800776:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80077d:	8b 45 08             	mov    0x8(%ebp),%eax
  800780:	01 d0                	add    %edx,%eax
  800782:	8b 00                	mov    (%eax),%eax
  800784:	83 ec 08             	sub    $0x8,%esp
  800787:	50                   	push   %eax
  800788:	68 44 3c 80 00       	push   $0x803c44
  80078d:	e8 c4 04 00 00       	call   800c56 <cprintf>
  800792:	83 c4 10             	add    $0x10,%esp

void PrintElements(int *Elements, int NumOfElements)
{
	int i ;
	int NumsPerLine = 20 ;
	for (i = 0 ; i < NumOfElements-1 ; i++)
  800795:	ff 45 f4             	incl   -0xc(%ebp)
  800798:	8b 45 0c             	mov    0xc(%ebp),%eax
  80079b:	48                   	dec    %eax
  80079c:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  80079f:	7f b5                	jg     800756 <PrintElements+0x16>
	{
		if (i%NumsPerLine == 0)
			cprintf("\n");
		cprintf("%d, ",Elements[i]);
	}
	cprintf("%d\n",Elements[i]);
  8007a1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8007a4:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8007ab:	8b 45 08             	mov    0x8(%ebp),%eax
  8007ae:	01 d0                	add    %edx,%eax
  8007b0:	8b 00                	mov    (%eax),%eax
  8007b2:	83 ec 08             	sub    $0x8,%esp
  8007b5:	50                   	push   %eax
  8007b6:	68 49 3c 80 00       	push   $0x803c49
  8007bb:	e8 96 04 00 00       	call   800c56 <cprintf>
  8007c0:	83 c4 10             	add    $0x10,%esp

}
  8007c3:	90                   	nop
  8007c4:	c9                   	leave  
  8007c5:	c3                   	ret    

008007c6 <cputchar>:
#include <inc/lib.h>


void
cputchar(int ch)
{
  8007c6:	55                   	push   %ebp
  8007c7:	89 e5                	mov    %esp,%ebp
  8007c9:	83 ec 18             	sub    $0x18,%esp
	char c = ch;
  8007cc:	8b 45 08             	mov    0x8(%ebp),%eax
  8007cf:	88 45 f7             	mov    %al,-0x9(%ebp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	//sys_cputs(&c, 1);

	sys_cputc(c);
  8007d2:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
  8007d6:	83 ec 0c             	sub    $0xc,%esp
  8007d9:	50                   	push   %eax
  8007da:	e8 3c 1b 00 00       	call   80231b <sys_cputc>
  8007df:	83 c4 10             	add    $0x10,%esp
}
  8007e2:	90                   	nop
  8007e3:	c9                   	leave  
  8007e4:	c3                   	ret    

008007e5 <atomic_cputchar>:


void
atomic_cputchar(int ch)
{
  8007e5:	55                   	push   %ebp
  8007e6:	89 e5                	mov    %esp,%ebp
  8007e8:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  8007eb:	e8 f7 1a 00 00       	call   8022e7 <sys_disable_interrupt>
	char c = ch;
  8007f0:	8b 45 08             	mov    0x8(%ebp),%eax
  8007f3:	88 45 f7             	mov    %al,-0x9(%ebp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	//sys_cputs(&c, 1);

	sys_cputc(c);
  8007f6:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
  8007fa:	83 ec 0c             	sub    $0xc,%esp
  8007fd:	50                   	push   %eax
  8007fe:	e8 18 1b 00 00       	call   80231b <sys_cputc>
  800803:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  800806:	e8 f6 1a 00 00       	call   802301 <sys_enable_interrupt>
}
  80080b:	90                   	nop
  80080c:	c9                   	leave  
  80080d:	c3                   	ret    

0080080e <getchar>:

int
getchar(void)
{
  80080e:	55                   	push   %ebp
  80080f:	89 e5                	mov    %esp,%ebp
  800811:	83 ec 18             	sub    $0x18,%esp

	//return sys_cgetc();
	int c=0;
  800814:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	while(c == 0)
  80081b:	eb 08                	jmp    800825 <getchar+0x17>
	{
		c = sys_cgetc();
  80081d:	e8 40 19 00 00       	call   802162 <sys_cgetc>
  800822:	89 45 f4             	mov    %eax,-0xc(%ebp)
getchar(void)
{

	//return sys_cgetc();
	int c=0;
	while(c == 0)
  800825:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  800829:	74 f2                	je     80081d <getchar+0xf>
	{
		c = sys_cgetc();
	}
	return c;
  80082b:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  80082e:	c9                   	leave  
  80082f:	c3                   	ret    

00800830 <atomic_getchar>:

int
atomic_getchar(void)
{
  800830:	55                   	push   %ebp
  800831:	89 e5                	mov    %esp,%ebp
  800833:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  800836:	e8 ac 1a 00 00       	call   8022e7 <sys_disable_interrupt>
	int c=0;
  80083b:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	while(c == 0)
  800842:	eb 08                	jmp    80084c <atomic_getchar+0x1c>
	{
		c = sys_cgetc();
  800844:	e8 19 19 00 00       	call   802162 <sys_cgetc>
  800849:	89 45 f4             	mov    %eax,-0xc(%ebp)
int
atomic_getchar(void)
{
	sys_disable_interrupt();
	int c=0;
	while(c == 0)
  80084c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  800850:	74 f2                	je     800844 <atomic_getchar+0x14>
	{
		c = sys_cgetc();
	}
	sys_enable_interrupt();
  800852:	e8 aa 1a 00 00       	call   802301 <sys_enable_interrupt>
	return c;
  800857:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  80085a:	c9                   	leave  
  80085b:	c3                   	ret    

0080085c <iscons>:

int iscons(int fdnum)
{
  80085c:	55                   	push   %ebp
  80085d:	89 e5                	mov    %esp,%ebp
	// used by readline
	return 1;
  80085f:	b8 01 00 00 00       	mov    $0x1,%eax
}
  800864:	5d                   	pop    %ebp
  800865:	c3                   	ret    

00800866 <libmain>:
volatile struct Env *myEnv = NULL;
volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";

void
libmain(int argc, char **argv)
{
  800866:	55                   	push   %ebp
  800867:	89 e5                	mov    %esp,%ebp
  800869:	83 ec 18             	sub    $0x18,%esp
	int envIndex = sys_getenvindex();
  80086c:	e8 69 1c 00 00       	call   8024da <sys_getenvindex>
  800871:	89 45 f4             	mov    %eax,-0xc(%ebp)
	myEnv = &(envs[envIndex]);
  800874:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800877:	89 d0                	mov    %edx,%eax
  800879:	c1 e0 03             	shl    $0x3,%eax
  80087c:	01 d0                	add    %edx,%eax
  80087e:	01 c0                	add    %eax,%eax
  800880:	01 d0                	add    %edx,%eax
  800882:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800889:	01 d0                	add    %edx,%eax
  80088b:	c1 e0 04             	shl    $0x4,%eax
  80088e:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  800893:	a3 24 50 80 00       	mov    %eax,0x805024

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  800898:	a1 24 50 80 00       	mov    0x805024,%eax
  80089d:	8a 80 5c 05 00 00    	mov    0x55c(%eax),%al
  8008a3:	84 c0                	test   %al,%al
  8008a5:	74 0f                	je     8008b6 <libmain+0x50>
		binaryname = myEnv->prog_name;
  8008a7:	a1 24 50 80 00       	mov    0x805024,%eax
  8008ac:	05 5c 05 00 00       	add    $0x55c,%eax
  8008b1:	a3 00 50 80 00       	mov    %eax,0x805000

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8008b6:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8008ba:	7e 0a                	jle    8008c6 <libmain+0x60>
		binaryname = argv[0];
  8008bc:	8b 45 0c             	mov    0xc(%ebp),%eax
  8008bf:	8b 00                	mov    (%eax),%eax
  8008c1:	a3 00 50 80 00       	mov    %eax,0x805000

	// call user main routine
	_main(argc, argv);
  8008c6:	83 ec 08             	sub    $0x8,%esp
  8008c9:	ff 75 0c             	pushl  0xc(%ebp)
  8008cc:	ff 75 08             	pushl  0x8(%ebp)
  8008cf:	e8 64 f7 ff ff       	call   800038 <_main>
  8008d4:	83 c4 10             	add    $0x10,%esp



	sys_disable_interrupt();
  8008d7:	e8 0b 1a 00 00       	call   8022e7 <sys_disable_interrupt>
	cprintf("**************************************\n");
  8008dc:	83 ec 0c             	sub    $0xc,%esp
  8008df:	68 68 3c 80 00       	push   $0x803c68
  8008e4:	e8 6d 03 00 00       	call   800c56 <cprintf>
  8008e9:	83 c4 10             	add    $0x10,%esp
	cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  8008ec:	a1 24 50 80 00       	mov    0x805024,%eax
  8008f1:	8b 90 44 05 00 00    	mov    0x544(%eax),%edx
  8008f7:	a1 24 50 80 00       	mov    0x805024,%eax
  8008fc:	8b 80 34 05 00 00    	mov    0x534(%eax),%eax
  800902:	83 ec 04             	sub    $0x4,%esp
  800905:	52                   	push   %edx
  800906:	50                   	push   %eax
  800907:	68 90 3c 80 00       	push   $0x803c90
  80090c:	e8 45 03 00 00       	call   800c56 <cprintf>
  800911:	83 c4 10             	add    $0x10,%esp
	cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  800914:	a1 24 50 80 00       	mov    0x805024,%eax
  800919:	8b 88 54 05 00 00    	mov    0x554(%eax),%ecx
  80091f:	a1 24 50 80 00       	mov    0x805024,%eax
  800924:	8b 90 50 05 00 00    	mov    0x550(%eax),%edx
  80092a:	a1 24 50 80 00       	mov    0x805024,%eax
  80092f:	8b 80 4c 05 00 00    	mov    0x54c(%eax),%eax
  800935:	51                   	push   %ecx
  800936:	52                   	push   %edx
  800937:	50                   	push   %eax
  800938:	68 b8 3c 80 00       	push   $0x803cb8
  80093d:	e8 14 03 00 00       	call   800c56 <cprintf>
  800942:	83 c4 10             	add    $0x10,%esp
	//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
	cprintf("Num of clocks = %d\n", myEnv->nClocks);
  800945:	a1 24 50 80 00       	mov    0x805024,%eax
  80094a:	8b 80 a4 05 00 00    	mov    0x5a4(%eax),%eax
  800950:	83 ec 08             	sub    $0x8,%esp
  800953:	50                   	push   %eax
  800954:	68 10 3d 80 00       	push   $0x803d10
  800959:	e8 f8 02 00 00       	call   800c56 <cprintf>
  80095e:	83 c4 10             	add    $0x10,%esp
	cprintf("**************************************\n");
  800961:	83 ec 0c             	sub    $0xc,%esp
  800964:	68 68 3c 80 00       	push   $0x803c68
  800969:	e8 e8 02 00 00       	call   800c56 <cprintf>
  80096e:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  800971:	e8 8b 19 00 00       	call   802301 <sys_enable_interrupt>

	// exit gracefully
	exit();
  800976:	e8 19 00 00 00       	call   800994 <exit>
}
  80097b:	90                   	nop
  80097c:	c9                   	leave  
  80097d:	c3                   	ret    

0080097e <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  80097e:	55                   	push   %ebp
  80097f:	89 e5                	mov    %esp,%ebp
  800981:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  800984:	83 ec 0c             	sub    $0xc,%esp
  800987:	6a 00                	push   $0x0
  800989:	e8 18 1b 00 00       	call   8024a6 <sys_destroy_env>
  80098e:	83 c4 10             	add    $0x10,%esp
}
  800991:	90                   	nop
  800992:	c9                   	leave  
  800993:	c3                   	ret    

00800994 <exit>:

void
exit(void)
{
  800994:	55                   	push   %ebp
  800995:	89 e5                	mov    %esp,%ebp
  800997:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  80099a:	e8 6d 1b 00 00       	call   80250c <sys_exit_env>
}
  80099f:	90                   	nop
  8009a0:	c9                   	leave  
  8009a1:	c3                   	ret    

008009a2 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  8009a2:	55                   	push   %ebp
  8009a3:	89 e5                	mov    %esp,%ebp
  8009a5:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  8009a8:	8d 45 10             	lea    0x10(%ebp),%eax
  8009ab:	83 c0 04             	add    $0x4,%eax
  8009ae:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  8009b1:	a1 5c 51 80 00       	mov    0x80515c,%eax
  8009b6:	85 c0                	test   %eax,%eax
  8009b8:	74 16                	je     8009d0 <_panic+0x2e>
		cprintf("%s: ", argv0);
  8009ba:	a1 5c 51 80 00       	mov    0x80515c,%eax
  8009bf:	83 ec 08             	sub    $0x8,%esp
  8009c2:	50                   	push   %eax
  8009c3:	68 24 3d 80 00       	push   $0x803d24
  8009c8:	e8 89 02 00 00       	call   800c56 <cprintf>
  8009cd:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  8009d0:	a1 00 50 80 00       	mov    0x805000,%eax
  8009d5:	ff 75 0c             	pushl  0xc(%ebp)
  8009d8:	ff 75 08             	pushl  0x8(%ebp)
  8009db:	50                   	push   %eax
  8009dc:	68 29 3d 80 00       	push   $0x803d29
  8009e1:	e8 70 02 00 00       	call   800c56 <cprintf>
  8009e6:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  8009e9:	8b 45 10             	mov    0x10(%ebp),%eax
  8009ec:	83 ec 08             	sub    $0x8,%esp
  8009ef:	ff 75 f4             	pushl  -0xc(%ebp)
  8009f2:	50                   	push   %eax
  8009f3:	e8 f3 01 00 00       	call   800beb <vcprintf>
  8009f8:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  8009fb:	83 ec 08             	sub    $0x8,%esp
  8009fe:	6a 00                	push   $0x0
  800a00:	68 45 3d 80 00       	push   $0x803d45
  800a05:	e8 e1 01 00 00       	call   800beb <vcprintf>
  800a0a:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  800a0d:	e8 82 ff ff ff       	call   800994 <exit>

	// should not return here
	while (1) ;
  800a12:	eb fe                	jmp    800a12 <_panic+0x70>

00800a14 <CheckWSWithoutLastIndex>:
}

void CheckWSWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  800a14:	55                   	push   %ebp
  800a15:	89 e5                	mov    %esp,%ebp
  800a17:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  800a1a:	a1 24 50 80 00       	mov    0x805024,%eax
  800a1f:	8b 50 74             	mov    0x74(%eax),%edx
  800a22:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a25:	39 c2                	cmp    %eax,%edx
  800a27:	74 14                	je     800a3d <CheckWSWithoutLastIndex+0x29>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  800a29:	83 ec 04             	sub    $0x4,%esp
  800a2c:	68 48 3d 80 00       	push   $0x803d48
  800a31:	6a 26                	push   $0x26
  800a33:	68 94 3d 80 00       	push   $0x803d94
  800a38:	e8 65 ff ff ff       	call   8009a2 <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  800a3d:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  800a44:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800a4b:	e9 c2 00 00 00       	jmp    800b12 <CheckWSWithoutLastIndex+0xfe>
		if (expectedPages[e] == 0) {
  800a50:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800a53:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800a5a:	8b 45 08             	mov    0x8(%ebp),%eax
  800a5d:	01 d0                	add    %edx,%eax
  800a5f:	8b 00                	mov    (%eax),%eax
  800a61:	85 c0                	test   %eax,%eax
  800a63:	75 08                	jne    800a6d <CheckWSWithoutLastIndex+0x59>
			expectedNumOfEmptyLocs++;
  800a65:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  800a68:	e9 a2 00 00 00       	jmp    800b0f <CheckWSWithoutLastIndex+0xfb>
		}
		int found = 0;
  800a6d:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800a74:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  800a7b:	eb 69                	jmp    800ae6 <CheckWSWithoutLastIndex+0xd2>
			if (myEnv->__uptr_pws[w].empty == 0) {
  800a7d:	a1 24 50 80 00       	mov    0x805024,%eax
  800a82:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  800a88:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800a8b:	89 d0                	mov    %edx,%eax
  800a8d:	01 c0                	add    %eax,%eax
  800a8f:	01 d0                	add    %edx,%eax
  800a91:	c1 e0 03             	shl    $0x3,%eax
  800a94:	01 c8                	add    %ecx,%eax
  800a96:	8a 40 04             	mov    0x4(%eax),%al
  800a99:	84 c0                	test   %al,%al
  800a9b:	75 46                	jne    800ae3 <CheckWSWithoutLastIndex+0xcf>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  800a9d:	a1 24 50 80 00       	mov    0x805024,%eax
  800aa2:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  800aa8:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800aab:	89 d0                	mov    %edx,%eax
  800aad:	01 c0                	add    %eax,%eax
  800aaf:	01 d0                	add    %edx,%eax
  800ab1:	c1 e0 03             	shl    $0x3,%eax
  800ab4:	01 c8                	add    %ecx,%eax
  800ab6:	8b 00                	mov    (%eax),%eax
  800ab8:	89 45 dc             	mov    %eax,-0x24(%ebp)
  800abb:	8b 45 dc             	mov    -0x24(%ebp),%eax
  800abe:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800ac3:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  800ac5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800ac8:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  800acf:	8b 45 08             	mov    0x8(%ebp),%eax
  800ad2:	01 c8                	add    %ecx,%eax
  800ad4:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  800ad6:	39 c2                	cmp    %eax,%edx
  800ad8:	75 09                	jne    800ae3 <CheckWSWithoutLastIndex+0xcf>
						== expectedPages[e]) {
					found = 1;
  800ada:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  800ae1:	eb 12                	jmp    800af5 <CheckWSWithoutLastIndex+0xe1>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800ae3:	ff 45 e8             	incl   -0x18(%ebp)
  800ae6:	a1 24 50 80 00       	mov    0x805024,%eax
  800aeb:	8b 50 74             	mov    0x74(%eax),%edx
  800aee:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800af1:	39 c2                	cmp    %eax,%edx
  800af3:	77 88                	ja     800a7d <CheckWSWithoutLastIndex+0x69>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  800af5:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  800af9:	75 14                	jne    800b0f <CheckWSWithoutLastIndex+0xfb>
			panic(
  800afb:	83 ec 04             	sub    $0x4,%esp
  800afe:	68 a0 3d 80 00       	push   $0x803da0
  800b03:	6a 3a                	push   $0x3a
  800b05:	68 94 3d 80 00       	push   $0x803d94
  800b0a:	e8 93 fe ff ff       	call   8009a2 <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  800b0f:	ff 45 f0             	incl   -0x10(%ebp)
  800b12:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800b15:	3b 45 0c             	cmp    0xc(%ebp),%eax
  800b18:	0f 8c 32 ff ff ff    	jl     800a50 <CheckWSWithoutLastIndex+0x3c>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  800b1e:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800b25:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  800b2c:	eb 26                	jmp    800b54 <CheckWSWithoutLastIndex+0x140>
		if (myEnv->__uptr_pws[w].empty == 1) {
  800b2e:	a1 24 50 80 00       	mov    0x805024,%eax
  800b33:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  800b39:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800b3c:	89 d0                	mov    %edx,%eax
  800b3e:	01 c0                	add    %eax,%eax
  800b40:	01 d0                	add    %edx,%eax
  800b42:	c1 e0 03             	shl    $0x3,%eax
  800b45:	01 c8                	add    %ecx,%eax
  800b47:	8a 40 04             	mov    0x4(%eax),%al
  800b4a:	3c 01                	cmp    $0x1,%al
  800b4c:	75 03                	jne    800b51 <CheckWSWithoutLastIndex+0x13d>
			actualNumOfEmptyLocs++;
  800b4e:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800b51:	ff 45 e0             	incl   -0x20(%ebp)
  800b54:	a1 24 50 80 00       	mov    0x805024,%eax
  800b59:	8b 50 74             	mov    0x74(%eax),%edx
  800b5c:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800b5f:	39 c2                	cmp    %eax,%edx
  800b61:	77 cb                	ja     800b2e <CheckWSWithoutLastIndex+0x11a>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  800b63:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800b66:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  800b69:	74 14                	je     800b7f <CheckWSWithoutLastIndex+0x16b>
		panic(
  800b6b:	83 ec 04             	sub    $0x4,%esp
  800b6e:	68 f4 3d 80 00       	push   $0x803df4
  800b73:	6a 44                	push   $0x44
  800b75:	68 94 3d 80 00       	push   $0x803d94
  800b7a:	e8 23 fe ff ff       	call   8009a2 <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  800b7f:	90                   	nop
  800b80:	c9                   	leave  
  800b81:	c3                   	ret    

00800b82 <putch>:
};

//2017:
uint8 printProgName = 0;

static void putch(int ch, struct printbuf *b) {
  800b82:	55                   	push   %ebp
  800b83:	89 e5                	mov    %esp,%ebp
  800b85:	83 ec 08             	sub    $0x8,%esp
	b->buf[b->idx++] = ch;
  800b88:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b8b:	8b 00                	mov    (%eax),%eax
  800b8d:	8d 48 01             	lea    0x1(%eax),%ecx
  800b90:	8b 55 0c             	mov    0xc(%ebp),%edx
  800b93:	89 0a                	mov    %ecx,(%edx)
  800b95:	8b 55 08             	mov    0x8(%ebp),%edx
  800b98:	88 d1                	mov    %dl,%cl
  800b9a:	8b 55 0c             	mov    0xc(%ebp),%edx
  800b9d:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  800ba1:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ba4:	8b 00                	mov    (%eax),%eax
  800ba6:	3d ff 00 00 00       	cmp    $0xff,%eax
  800bab:	75 2c                	jne    800bd9 <putch+0x57>
		sys_cputs(b->buf, b->idx, printProgName);
  800bad:	a0 28 50 80 00       	mov    0x805028,%al
  800bb2:	0f b6 c0             	movzbl %al,%eax
  800bb5:	8b 55 0c             	mov    0xc(%ebp),%edx
  800bb8:	8b 12                	mov    (%edx),%edx
  800bba:	89 d1                	mov    %edx,%ecx
  800bbc:	8b 55 0c             	mov    0xc(%ebp),%edx
  800bbf:	83 c2 08             	add    $0x8,%edx
  800bc2:	83 ec 04             	sub    $0x4,%esp
  800bc5:	50                   	push   %eax
  800bc6:	51                   	push   %ecx
  800bc7:	52                   	push   %edx
  800bc8:	e8 6c 15 00 00       	call   802139 <sys_cputs>
  800bcd:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  800bd0:	8b 45 0c             	mov    0xc(%ebp),%eax
  800bd3:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  800bd9:	8b 45 0c             	mov    0xc(%ebp),%eax
  800bdc:	8b 40 04             	mov    0x4(%eax),%eax
  800bdf:	8d 50 01             	lea    0x1(%eax),%edx
  800be2:	8b 45 0c             	mov    0xc(%ebp),%eax
  800be5:	89 50 04             	mov    %edx,0x4(%eax)
}
  800be8:	90                   	nop
  800be9:	c9                   	leave  
  800bea:	c3                   	ret    

00800beb <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  800beb:	55                   	push   %ebp
  800bec:	89 e5                	mov    %esp,%ebp
  800bee:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  800bf4:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800bfb:	00 00 00 
	b.cnt = 0;
  800bfe:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800c05:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  800c08:	ff 75 0c             	pushl  0xc(%ebp)
  800c0b:	ff 75 08             	pushl  0x8(%ebp)
  800c0e:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800c14:	50                   	push   %eax
  800c15:	68 82 0b 80 00       	push   $0x800b82
  800c1a:	e8 11 02 00 00       	call   800e30 <vprintfmt>
  800c1f:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName);
  800c22:	a0 28 50 80 00       	mov    0x805028,%al
  800c27:	0f b6 c0             	movzbl %al,%eax
  800c2a:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  800c30:	83 ec 04             	sub    $0x4,%esp
  800c33:	50                   	push   %eax
  800c34:	52                   	push   %edx
  800c35:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800c3b:	83 c0 08             	add    $0x8,%eax
  800c3e:	50                   	push   %eax
  800c3f:	e8 f5 14 00 00       	call   802139 <sys_cputs>
  800c44:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  800c47:	c6 05 28 50 80 00 00 	movb   $0x0,0x805028
	return b.cnt;
  800c4e:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  800c54:	c9                   	leave  
  800c55:	c3                   	ret    

00800c56 <cprintf>:

int cprintf(const char *fmt, ...) {
  800c56:	55                   	push   %ebp
  800c57:	89 e5                	mov    %esp,%ebp
  800c59:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  800c5c:	c6 05 28 50 80 00 01 	movb   $0x1,0x805028
	va_start(ap, fmt);
  800c63:	8d 45 0c             	lea    0xc(%ebp),%eax
  800c66:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800c69:	8b 45 08             	mov    0x8(%ebp),%eax
  800c6c:	83 ec 08             	sub    $0x8,%esp
  800c6f:	ff 75 f4             	pushl  -0xc(%ebp)
  800c72:	50                   	push   %eax
  800c73:	e8 73 ff ff ff       	call   800beb <vcprintf>
  800c78:	83 c4 10             	add    $0x10,%esp
  800c7b:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  800c7e:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800c81:	c9                   	leave  
  800c82:	c3                   	ret    

00800c83 <atomic_cprintf>:

int atomic_cprintf(const char *fmt, ...) {
  800c83:	55                   	push   %ebp
  800c84:	89 e5                	mov    %esp,%ebp
  800c86:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  800c89:	e8 59 16 00 00       	call   8022e7 <sys_disable_interrupt>
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  800c8e:	8d 45 0c             	lea    0xc(%ebp),%eax
  800c91:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800c94:	8b 45 08             	mov    0x8(%ebp),%eax
  800c97:	83 ec 08             	sub    $0x8,%esp
  800c9a:	ff 75 f4             	pushl  -0xc(%ebp)
  800c9d:	50                   	push   %eax
  800c9e:	e8 48 ff ff ff       	call   800beb <vcprintf>
  800ca3:	83 c4 10             	add    $0x10,%esp
  800ca6:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	sys_enable_interrupt();
  800ca9:	e8 53 16 00 00       	call   802301 <sys_enable_interrupt>
	return cnt;
  800cae:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800cb1:	c9                   	leave  
  800cb2:	c3                   	ret    

00800cb3 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800cb3:	55                   	push   %ebp
  800cb4:	89 e5                	mov    %esp,%ebp
  800cb6:	53                   	push   %ebx
  800cb7:	83 ec 14             	sub    $0x14,%esp
  800cba:	8b 45 10             	mov    0x10(%ebp),%eax
  800cbd:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800cc0:	8b 45 14             	mov    0x14(%ebp),%eax
  800cc3:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800cc6:	8b 45 18             	mov    0x18(%ebp),%eax
  800cc9:	ba 00 00 00 00       	mov    $0x0,%edx
  800cce:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800cd1:	77 55                	ja     800d28 <printnum+0x75>
  800cd3:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800cd6:	72 05                	jb     800cdd <printnum+0x2a>
  800cd8:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800cdb:	77 4b                	ja     800d28 <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800cdd:	8b 45 1c             	mov    0x1c(%ebp),%eax
  800ce0:	8d 58 ff             	lea    -0x1(%eax),%ebx
  800ce3:	8b 45 18             	mov    0x18(%ebp),%eax
  800ce6:	ba 00 00 00 00       	mov    $0x0,%edx
  800ceb:	52                   	push   %edx
  800cec:	50                   	push   %eax
  800ced:	ff 75 f4             	pushl  -0xc(%ebp)
  800cf0:	ff 75 f0             	pushl  -0x10(%ebp)
  800cf3:	e8 8c 2a 00 00       	call   803784 <__udivdi3>
  800cf8:	83 c4 10             	add    $0x10,%esp
  800cfb:	83 ec 04             	sub    $0x4,%esp
  800cfe:	ff 75 20             	pushl  0x20(%ebp)
  800d01:	53                   	push   %ebx
  800d02:	ff 75 18             	pushl  0x18(%ebp)
  800d05:	52                   	push   %edx
  800d06:	50                   	push   %eax
  800d07:	ff 75 0c             	pushl  0xc(%ebp)
  800d0a:	ff 75 08             	pushl  0x8(%ebp)
  800d0d:	e8 a1 ff ff ff       	call   800cb3 <printnum>
  800d12:	83 c4 20             	add    $0x20,%esp
  800d15:	eb 1a                	jmp    800d31 <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800d17:	83 ec 08             	sub    $0x8,%esp
  800d1a:	ff 75 0c             	pushl  0xc(%ebp)
  800d1d:	ff 75 20             	pushl  0x20(%ebp)
  800d20:	8b 45 08             	mov    0x8(%ebp),%eax
  800d23:	ff d0                	call   *%eax
  800d25:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800d28:	ff 4d 1c             	decl   0x1c(%ebp)
  800d2b:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  800d2f:	7f e6                	jg     800d17 <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800d31:	8b 4d 18             	mov    0x18(%ebp),%ecx
  800d34:	bb 00 00 00 00       	mov    $0x0,%ebx
  800d39:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800d3c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800d3f:	53                   	push   %ebx
  800d40:	51                   	push   %ecx
  800d41:	52                   	push   %edx
  800d42:	50                   	push   %eax
  800d43:	e8 4c 2b 00 00       	call   803894 <__umoddi3>
  800d48:	83 c4 10             	add    $0x10,%esp
  800d4b:	05 54 40 80 00       	add    $0x804054,%eax
  800d50:	8a 00                	mov    (%eax),%al
  800d52:	0f be c0             	movsbl %al,%eax
  800d55:	83 ec 08             	sub    $0x8,%esp
  800d58:	ff 75 0c             	pushl  0xc(%ebp)
  800d5b:	50                   	push   %eax
  800d5c:	8b 45 08             	mov    0x8(%ebp),%eax
  800d5f:	ff d0                	call   *%eax
  800d61:	83 c4 10             	add    $0x10,%esp
}
  800d64:	90                   	nop
  800d65:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800d68:	c9                   	leave  
  800d69:	c3                   	ret    

00800d6a <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  800d6a:	55                   	push   %ebp
  800d6b:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800d6d:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800d71:	7e 1c                	jle    800d8f <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  800d73:	8b 45 08             	mov    0x8(%ebp),%eax
  800d76:	8b 00                	mov    (%eax),%eax
  800d78:	8d 50 08             	lea    0x8(%eax),%edx
  800d7b:	8b 45 08             	mov    0x8(%ebp),%eax
  800d7e:	89 10                	mov    %edx,(%eax)
  800d80:	8b 45 08             	mov    0x8(%ebp),%eax
  800d83:	8b 00                	mov    (%eax),%eax
  800d85:	83 e8 08             	sub    $0x8,%eax
  800d88:	8b 50 04             	mov    0x4(%eax),%edx
  800d8b:	8b 00                	mov    (%eax),%eax
  800d8d:	eb 40                	jmp    800dcf <getuint+0x65>
	else if (lflag)
  800d8f:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800d93:	74 1e                	je     800db3 <getuint+0x49>
		return va_arg(*ap, unsigned long);
  800d95:	8b 45 08             	mov    0x8(%ebp),%eax
  800d98:	8b 00                	mov    (%eax),%eax
  800d9a:	8d 50 04             	lea    0x4(%eax),%edx
  800d9d:	8b 45 08             	mov    0x8(%ebp),%eax
  800da0:	89 10                	mov    %edx,(%eax)
  800da2:	8b 45 08             	mov    0x8(%ebp),%eax
  800da5:	8b 00                	mov    (%eax),%eax
  800da7:	83 e8 04             	sub    $0x4,%eax
  800daa:	8b 00                	mov    (%eax),%eax
  800dac:	ba 00 00 00 00       	mov    $0x0,%edx
  800db1:	eb 1c                	jmp    800dcf <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  800db3:	8b 45 08             	mov    0x8(%ebp),%eax
  800db6:	8b 00                	mov    (%eax),%eax
  800db8:	8d 50 04             	lea    0x4(%eax),%edx
  800dbb:	8b 45 08             	mov    0x8(%ebp),%eax
  800dbe:	89 10                	mov    %edx,(%eax)
  800dc0:	8b 45 08             	mov    0x8(%ebp),%eax
  800dc3:	8b 00                	mov    (%eax),%eax
  800dc5:	83 e8 04             	sub    $0x4,%eax
  800dc8:	8b 00                	mov    (%eax),%eax
  800dca:	ba 00 00 00 00       	mov    $0x0,%edx
}
  800dcf:	5d                   	pop    %ebp
  800dd0:	c3                   	ret    

00800dd1 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  800dd1:	55                   	push   %ebp
  800dd2:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800dd4:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800dd8:	7e 1c                	jle    800df6 <getint+0x25>
		return va_arg(*ap, long long);
  800dda:	8b 45 08             	mov    0x8(%ebp),%eax
  800ddd:	8b 00                	mov    (%eax),%eax
  800ddf:	8d 50 08             	lea    0x8(%eax),%edx
  800de2:	8b 45 08             	mov    0x8(%ebp),%eax
  800de5:	89 10                	mov    %edx,(%eax)
  800de7:	8b 45 08             	mov    0x8(%ebp),%eax
  800dea:	8b 00                	mov    (%eax),%eax
  800dec:	83 e8 08             	sub    $0x8,%eax
  800def:	8b 50 04             	mov    0x4(%eax),%edx
  800df2:	8b 00                	mov    (%eax),%eax
  800df4:	eb 38                	jmp    800e2e <getint+0x5d>
	else if (lflag)
  800df6:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800dfa:	74 1a                	je     800e16 <getint+0x45>
		return va_arg(*ap, long);
  800dfc:	8b 45 08             	mov    0x8(%ebp),%eax
  800dff:	8b 00                	mov    (%eax),%eax
  800e01:	8d 50 04             	lea    0x4(%eax),%edx
  800e04:	8b 45 08             	mov    0x8(%ebp),%eax
  800e07:	89 10                	mov    %edx,(%eax)
  800e09:	8b 45 08             	mov    0x8(%ebp),%eax
  800e0c:	8b 00                	mov    (%eax),%eax
  800e0e:	83 e8 04             	sub    $0x4,%eax
  800e11:	8b 00                	mov    (%eax),%eax
  800e13:	99                   	cltd   
  800e14:	eb 18                	jmp    800e2e <getint+0x5d>
	else
		return va_arg(*ap, int);
  800e16:	8b 45 08             	mov    0x8(%ebp),%eax
  800e19:	8b 00                	mov    (%eax),%eax
  800e1b:	8d 50 04             	lea    0x4(%eax),%edx
  800e1e:	8b 45 08             	mov    0x8(%ebp),%eax
  800e21:	89 10                	mov    %edx,(%eax)
  800e23:	8b 45 08             	mov    0x8(%ebp),%eax
  800e26:	8b 00                	mov    (%eax),%eax
  800e28:	83 e8 04             	sub    $0x4,%eax
  800e2b:	8b 00                	mov    (%eax),%eax
  800e2d:	99                   	cltd   
}
  800e2e:	5d                   	pop    %ebp
  800e2f:	c3                   	ret    

00800e30 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  800e30:	55                   	push   %ebp
  800e31:	89 e5                	mov    %esp,%ebp
  800e33:	56                   	push   %esi
  800e34:	53                   	push   %ebx
  800e35:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800e38:	eb 17                	jmp    800e51 <vprintfmt+0x21>
			if (ch == '\0')
  800e3a:	85 db                	test   %ebx,%ebx
  800e3c:	0f 84 af 03 00 00    	je     8011f1 <vprintfmt+0x3c1>
				return;
			putch(ch, putdat);
  800e42:	83 ec 08             	sub    $0x8,%esp
  800e45:	ff 75 0c             	pushl  0xc(%ebp)
  800e48:	53                   	push   %ebx
  800e49:	8b 45 08             	mov    0x8(%ebp),%eax
  800e4c:	ff d0                	call   *%eax
  800e4e:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800e51:	8b 45 10             	mov    0x10(%ebp),%eax
  800e54:	8d 50 01             	lea    0x1(%eax),%edx
  800e57:	89 55 10             	mov    %edx,0x10(%ebp)
  800e5a:	8a 00                	mov    (%eax),%al
  800e5c:	0f b6 d8             	movzbl %al,%ebx
  800e5f:	83 fb 25             	cmp    $0x25,%ebx
  800e62:	75 d6                	jne    800e3a <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  800e64:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  800e68:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  800e6f:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  800e76:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  800e7d:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800e84:	8b 45 10             	mov    0x10(%ebp),%eax
  800e87:	8d 50 01             	lea    0x1(%eax),%edx
  800e8a:	89 55 10             	mov    %edx,0x10(%ebp)
  800e8d:	8a 00                	mov    (%eax),%al
  800e8f:	0f b6 d8             	movzbl %al,%ebx
  800e92:	8d 43 dd             	lea    -0x23(%ebx),%eax
  800e95:	83 f8 55             	cmp    $0x55,%eax
  800e98:	0f 87 2b 03 00 00    	ja     8011c9 <vprintfmt+0x399>
  800e9e:	8b 04 85 78 40 80 00 	mov    0x804078(,%eax,4),%eax
  800ea5:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  800ea7:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  800eab:	eb d7                	jmp    800e84 <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800ead:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  800eb1:	eb d1                	jmp    800e84 <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800eb3:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  800eba:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800ebd:	89 d0                	mov    %edx,%eax
  800ebf:	c1 e0 02             	shl    $0x2,%eax
  800ec2:	01 d0                	add    %edx,%eax
  800ec4:	01 c0                	add    %eax,%eax
  800ec6:	01 d8                	add    %ebx,%eax
  800ec8:	83 e8 30             	sub    $0x30,%eax
  800ecb:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  800ece:	8b 45 10             	mov    0x10(%ebp),%eax
  800ed1:	8a 00                	mov    (%eax),%al
  800ed3:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  800ed6:	83 fb 2f             	cmp    $0x2f,%ebx
  800ed9:	7e 3e                	jle    800f19 <vprintfmt+0xe9>
  800edb:	83 fb 39             	cmp    $0x39,%ebx
  800ede:	7f 39                	jg     800f19 <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800ee0:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800ee3:	eb d5                	jmp    800eba <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  800ee5:	8b 45 14             	mov    0x14(%ebp),%eax
  800ee8:	83 c0 04             	add    $0x4,%eax
  800eeb:	89 45 14             	mov    %eax,0x14(%ebp)
  800eee:	8b 45 14             	mov    0x14(%ebp),%eax
  800ef1:	83 e8 04             	sub    $0x4,%eax
  800ef4:	8b 00                	mov    (%eax),%eax
  800ef6:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  800ef9:	eb 1f                	jmp    800f1a <vprintfmt+0xea>

		case '.':
			if (width < 0)
  800efb:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800eff:	79 83                	jns    800e84 <vprintfmt+0x54>
				width = 0;
  800f01:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  800f08:	e9 77 ff ff ff       	jmp    800e84 <vprintfmt+0x54>

		case '#':
			altflag = 1;
  800f0d:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  800f14:	e9 6b ff ff ff       	jmp    800e84 <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  800f19:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  800f1a:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800f1e:	0f 89 60 ff ff ff    	jns    800e84 <vprintfmt+0x54>
				width = precision, precision = -1;
  800f24:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800f27:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800f2a:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  800f31:	e9 4e ff ff ff       	jmp    800e84 <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  800f36:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  800f39:	e9 46 ff ff ff       	jmp    800e84 <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  800f3e:	8b 45 14             	mov    0x14(%ebp),%eax
  800f41:	83 c0 04             	add    $0x4,%eax
  800f44:	89 45 14             	mov    %eax,0x14(%ebp)
  800f47:	8b 45 14             	mov    0x14(%ebp),%eax
  800f4a:	83 e8 04             	sub    $0x4,%eax
  800f4d:	8b 00                	mov    (%eax),%eax
  800f4f:	83 ec 08             	sub    $0x8,%esp
  800f52:	ff 75 0c             	pushl  0xc(%ebp)
  800f55:	50                   	push   %eax
  800f56:	8b 45 08             	mov    0x8(%ebp),%eax
  800f59:	ff d0                	call   *%eax
  800f5b:	83 c4 10             	add    $0x10,%esp
			break;
  800f5e:	e9 89 02 00 00       	jmp    8011ec <vprintfmt+0x3bc>

		// error message
		case 'e':
			err = va_arg(ap, int);
  800f63:	8b 45 14             	mov    0x14(%ebp),%eax
  800f66:	83 c0 04             	add    $0x4,%eax
  800f69:	89 45 14             	mov    %eax,0x14(%ebp)
  800f6c:	8b 45 14             	mov    0x14(%ebp),%eax
  800f6f:	83 e8 04             	sub    $0x4,%eax
  800f72:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  800f74:	85 db                	test   %ebx,%ebx
  800f76:	79 02                	jns    800f7a <vprintfmt+0x14a>
				err = -err;
  800f78:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  800f7a:	83 fb 64             	cmp    $0x64,%ebx
  800f7d:	7f 0b                	jg     800f8a <vprintfmt+0x15a>
  800f7f:	8b 34 9d c0 3e 80 00 	mov    0x803ec0(,%ebx,4),%esi
  800f86:	85 f6                	test   %esi,%esi
  800f88:	75 19                	jne    800fa3 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  800f8a:	53                   	push   %ebx
  800f8b:	68 65 40 80 00       	push   $0x804065
  800f90:	ff 75 0c             	pushl  0xc(%ebp)
  800f93:	ff 75 08             	pushl  0x8(%ebp)
  800f96:	e8 5e 02 00 00       	call   8011f9 <printfmt>
  800f9b:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800f9e:	e9 49 02 00 00       	jmp    8011ec <vprintfmt+0x3bc>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800fa3:	56                   	push   %esi
  800fa4:	68 6e 40 80 00       	push   $0x80406e
  800fa9:	ff 75 0c             	pushl  0xc(%ebp)
  800fac:	ff 75 08             	pushl  0x8(%ebp)
  800faf:	e8 45 02 00 00       	call   8011f9 <printfmt>
  800fb4:	83 c4 10             	add    $0x10,%esp
			break;
  800fb7:	e9 30 02 00 00       	jmp    8011ec <vprintfmt+0x3bc>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  800fbc:	8b 45 14             	mov    0x14(%ebp),%eax
  800fbf:	83 c0 04             	add    $0x4,%eax
  800fc2:	89 45 14             	mov    %eax,0x14(%ebp)
  800fc5:	8b 45 14             	mov    0x14(%ebp),%eax
  800fc8:	83 e8 04             	sub    $0x4,%eax
  800fcb:	8b 30                	mov    (%eax),%esi
  800fcd:	85 f6                	test   %esi,%esi
  800fcf:	75 05                	jne    800fd6 <vprintfmt+0x1a6>
				p = "(null)";
  800fd1:	be 71 40 80 00       	mov    $0x804071,%esi
			if (width > 0 && padc != '-')
  800fd6:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800fda:	7e 6d                	jle    801049 <vprintfmt+0x219>
  800fdc:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  800fe0:	74 67                	je     801049 <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  800fe2:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800fe5:	83 ec 08             	sub    $0x8,%esp
  800fe8:	50                   	push   %eax
  800fe9:	56                   	push   %esi
  800fea:	e8 12 05 00 00       	call   801501 <strnlen>
  800fef:	83 c4 10             	add    $0x10,%esp
  800ff2:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  800ff5:	eb 16                	jmp    80100d <vprintfmt+0x1dd>
					putch(padc, putdat);
  800ff7:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  800ffb:	83 ec 08             	sub    $0x8,%esp
  800ffe:	ff 75 0c             	pushl  0xc(%ebp)
  801001:	50                   	push   %eax
  801002:	8b 45 08             	mov    0x8(%ebp),%eax
  801005:	ff d0                	call   *%eax
  801007:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  80100a:	ff 4d e4             	decl   -0x1c(%ebp)
  80100d:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  801011:	7f e4                	jg     800ff7 <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  801013:	eb 34                	jmp    801049 <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  801015:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  801019:	74 1c                	je     801037 <vprintfmt+0x207>
  80101b:	83 fb 1f             	cmp    $0x1f,%ebx
  80101e:	7e 05                	jle    801025 <vprintfmt+0x1f5>
  801020:	83 fb 7e             	cmp    $0x7e,%ebx
  801023:	7e 12                	jle    801037 <vprintfmt+0x207>
					putch('?', putdat);
  801025:	83 ec 08             	sub    $0x8,%esp
  801028:	ff 75 0c             	pushl  0xc(%ebp)
  80102b:	6a 3f                	push   $0x3f
  80102d:	8b 45 08             	mov    0x8(%ebp),%eax
  801030:	ff d0                	call   *%eax
  801032:	83 c4 10             	add    $0x10,%esp
  801035:	eb 0f                	jmp    801046 <vprintfmt+0x216>
				else
					putch(ch, putdat);
  801037:	83 ec 08             	sub    $0x8,%esp
  80103a:	ff 75 0c             	pushl  0xc(%ebp)
  80103d:	53                   	push   %ebx
  80103e:	8b 45 08             	mov    0x8(%ebp),%eax
  801041:	ff d0                	call   *%eax
  801043:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  801046:	ff 4d e4             	decl   -0x1c(%ebp)
  801049:	89 f0                	mov    %esi,%eax
  80104b:	8d 70 01             	lea    0x1(%eax),%esi
  80104e:	8a 00                	mov    (%eax),%al
  801050:	0f be d8             	movsbl %al,%ebx
  801053:	85 db                	test   %ebx,%ebx
  801055:	74 24                	je     80107b <vprintfmt+0x24b>
  801057:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80105b:	78 b8                	js     801015 <vprintfmt+0x1e5>
  80105d:	ff 4d e0             	decl   -0x20(%ebp)
  801060:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  801064:	79 af                	jns    801015 <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  801066:	eb 13                	jmp    80107b <vprintfmt+0x24b>
				putch(' ', putdat);
  801068:	83 ec 08             	sub    $0x8,%esp
  80106b:	ff 75 0c             	pushl  0xc(%ebp)
  80106e:	6a 20                	push   $0x20
  801070:	8b 45 08             	mov    0x8(%ebp),%eax
  801073:	ff d0                	call   *%eax
  801075:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  801078:	ff 4d e4             	decl   -0x1c(%ebp)
  80107b:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80107f:	7f e7                	jg     801068 <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  801081:	e9 66 01 00 00       	jmp    8011ec <vprintfmt+0x3bc>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  801086:	83 ec 08             	sub    $0x8,%esp
  801089:	ff 75 e8             	pushl  -0x18(%ebp)
  80108c:	8d 45 14             	lea    0x14(%ebp),%eax
  80108f:	50                   	push   %eax
  801090:	e8 3c fd ff ff       	call   800dd1 <getint>
  801095:	83 c4 10             	add    $0x10,%esp
  801098:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80109b:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  80109e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8010a1:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8010a4:	85 d2                	test   %edx,%edx
  8010a6:	79 23                	jns    8010cb <vprintfmt+0x29b>
				putch('-', putdat);
  8010a8:	83 ec 08             	sub    $0x8,%esp
  8010ab:	ff 75 0c             	pushl  0xc(%ebp)
  8010ae:	6a 2d                	push   $0x2d
  8010b0:	8b 45 08             	mov    0x8(%ebp),%eax
  8010b3:	ff d0                	call   *%eax
  8010b5:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  8010b8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8010bb:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8010be:	f7 d8                	neg    %eax
  8010c0:	83 d2 00             	adc    $0x0,%edx
  8010c3:	f7 da                	neg    %edx
  8010c5:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8010c8:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  8010cb:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  8010d2:	e9 bc 00 00 00       	jmp    801193 <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  8010d7:	83 ec 08             	sub    $0x8,%esp
  8010da:	ff 75 e8             	pushl  -0x18(%ebp)
  8010dd:	8d 45 14             	lea    0x14(%ebp),%eax
  8010e0:	50                   	push   %eax
  8010e1:	e8 84 fc ff ff       	call   800d6a <getuint>
  8010e6:	83 c4 10             	add    $0x10,%esp
  8010e9:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8010ec:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  8010ef:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  8010f6:	e9 98 00 00 00       	jmp    801193 <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  8010fb:	83 ec 08             	sub    $0x8,%esp
  8010fe:	ff 75 0c             	pushl  0xc(%ebp)
  801101:	6a 58                	push   $0x58
  801103:	8b 45 08             	mov    0x8(%ebp),%eax
  801106:	ff d0                	call   *%eax
  801108:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  80110b:	83 ec 08             	sub    $0x8,%esp
  80110e:	ff 75 0c             	pushl  0xc(%ebp)
  801111:	6a 58                	push   $0x58
  801113:	8b 45 08             	mov    0x8(%ebp),%eax
  801116:	ff d0                	call   *%eax
  801118:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  80111b:	83 ec 08             	sub    $0x8,%esp
  80111e:	ff 75 0c             	pushl  0xc(%ebp)
  801121:	6a 58                	push   $0x58
  801123:	8b 45 08             	mov    0x8(%ebp),%eax
  801126:	ff d0                	call   *%eax
  801128:	83 c4 10             	add    $0x10,%esp
			break;
  80112b:	e9 bc 00 00 00       	jmp    8011ec <vprintfmt+0x3bc>

		// pointer
		case 'p':
			putch('0', putdat);
  801130:	83 ec 08             	sub    $0x8,%esp
  801133:	ff 75 0c             	pushl  0xc(%ebp)
  801136:	6a 30                	push   $0x30
  801138:	8b 45 08             	mov    0x8(%ebp),%eax
  80113b:	ff d0                	call   *%eax
  80113d:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  801140:	83 ec 08             	sub    $0x8,%esp
  801143:	ff 75 0c             	pushl  0xc(%ebp)
  801146:	6a 78                	push   $0x78
  801148:	8b 45 08             	mov    0x8(%ebp),%eax
  80114b:	ff d0                	call   *%eax
  80114d:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  801150:	8b 45 14             	mov    0x14(%ebp),%eax
  801153:	83 c0 04             	add    $0x4,%eax
  801156:	89 45 14             	mov    %eax,0x14(%ebp)
  801159:	8b 45 14             	mov    0x14(%ebp),%eax
  80115c:	83 e8 04             	sub    $0x4,%eax
  80115f:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  801161:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801164:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  80116b:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  801172:	eb 1f                	jmp    801193 <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  801174:	83 ec 08             	sub    $0x8,%esp
  801177:	ff 75 e8             	pushl  -0x18(%ebp)
  80117a:	8d 45 14             	lea    0x14(%ebp),%eax
  80117d:	50                   	push   %eax
  80117e:	e8 e7 fb ff ff       	call   800d6a <getuint>
  801183:	83 c4 10             	add    $0x10,%esp
  801186:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801189:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  80118c:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  801193:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  801197:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80119a:	83 ec 04             	sub    $0x4,%esp
  80119d:	52                   	push   %edx
  80119e:	ff 75 e4             	pushl  -0x1c(%ebp)
  8011a1:	50                   	push   %eax
  8011a2:	ff 75 f4             	pushl  -0xc(%ebp)
  8011a5:	ff 75 f0             	pushl  -0x10(%ebp)
  8011a8:	ff 75 0c             	pushl  0xc(%ebp)
  8011ab:	ff 75 08             	pushl  0x8(%ebp)
  8011ae:	e8 00 fb ff ff       	call   800cb3 <printnum>
  8011b3:	83 c4 20             	add    $0x20,%esp
			break;
  8011b6:	eb 34                	jmp    8011ec <vprintfmt+0x3bc>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  8011b8:	83 ec 08             	sub    $0x8,%esp
  8011bb:	ff 75 0c             	pushl  0xc(%ebp)
  8011be:	53                   	push   %ebx
  8011bf:	8b 45 08             	mov    0x8(%ebp),%eax
  8011c2:	ff d0                	call   *%eax
  8011c4:	83 c4 10             	add    $0x10,%esp
			break;
  8011c7:	eb 23                	jmp    8011ec <vprintfmt+0x3bc>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  8011c9:	83 ec 08             	sub    $0x8,%esp
  8011cc:	ff 75 0c             	pushl  0xc(%ebp)
  8011cf:	6a 25                	push   $0x25
  8011d1:	8b 45 08             	mov    0x8(%ebp),%eax
  8011d4:	ff d0                	call   *%eax
  8011d6:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  8011d9:	ff 4d 10             	decl   0x10(%ebp)
  8011dc:	eb 03                	jmp    8011e1 <vprintfmt+0x3b1>
  8011de:	ff 4d 10             	decl   0x10(%ebp)
  8011e1:	8b 45 10             	mov    0x10(%ebp),%eax
  8011e4:	48                   	dec    %eax
  8011e5:	8a 00                	mov    (%eax),%al
  8011e7:	3c 25                	cmp    $0x25,%al
  8011e9:	75 f3                	jne    8011de <vprintfmt+0x3ae>
				/* do nothing */;
			break;
  8011eb:	90                   	nop
		}
	}
  8011ec:	e9 47 fc ff ff       	jmp    800e38 <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  8011f1:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  8011f2:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8011f5:	5b                   	pop    %ebx
  8011f6:	5e                   	pop    %esi
  8011f7:	5d                   	pop    %ebp
  8011f8:	c3                   	ret    

008011f9 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  8011f9:	55                   	push   %ebp
  8011fa:	89 e5                	mov    %esp,%ebp
  8011fc:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  8011ff:	8d 45 10             	lea    0x10(%ebp),%eax
  801202:	83 c0 04             	add    $0x4,%eax
  801205:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  801208:	8b 45 10             	mov    0x10(%ebp),%eax
  80120b:	ff 75 f4             	pushl  -0xc(%ebp)
  80120e:	50                   	push   %eax
  80120f:	ff 75 0c             	pushl  0xc(%ebp)
  801212:	ff 75 08             	pushl  0x8(%ebp)
  801215:	e8 16 fc ff ff       	call   800e30 <vprintfmt>
  80121a:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  80121d:	90                   	nop
  80121e:	c9                   	leave  
  80121f:	c3                   	ret    

00801220 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  801220:	55                   	push   %ebp
  801221:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  801223:	8b 45 0c             	mov    0xc(%ebp),%eax
  801226:	8b 40 08             	mov    0x8(%eax),%eax
  801229:	8d 50 01             	lea    0x1(%eax),%edx
  80122c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80122f:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  801232:	8b 45 0c             	mov    0xc(%ebp),%eax
  801235:	8b 10                	mov    (%eax),%edx
  801237:	8b 45 0c             	mov    0xc(%ebp),%eax
  80123a:	8b 40 04             	mov    0x4(%eax),%eax
  80123d:	39 c2                	cmp    %eax,%edx
  80123f:	73 12                	jae    801253 <sprintputch+0x33>
		*b->buf++ = ch;
  801241:	8b 45 0c             	mov    0xc(%ebp),%eax
  801244:	8b 00                	mov    (%eax),%eax
  801246:	8d 48 01             	lea    0x1(%eax),%ecx
  801249:	8b 55 0c             	mov    0xc(%ebp),%edx
  80124c:	89 0a                	mov    %ecx,(%edx)
  80124e:	8b 55 08             	mov    0x8(%ebp),%edx
  801251:	88 10                	mov    %dl,(%eax)
}
  801253:	90                   	nop
  801254:	5d                   	pop    %ebp
  801255:	c3                   	ret    

00801256 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  801256:	55                   	push   %ebp
  801257:	89 e5                	mov    %esp,%ebp
  801259:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  80125c:	8b 45 08             	mov    0x8(%ebp),%eax
  80125f:	89 45 ec             	mov    %eax,-0x14(%ebp)
  801262:	8b 45 0c             	mov    0xc(%ebp),%eax
  801265:	8d 50 ff             	lea    -0x1(%eax),%edx
  801268:	8b 45 08             	mov    0x8(%ebp),%eax
  80126b:	01 d0                	add    %edx,%eax
  80126d:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801270:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  801277:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80127b:	74 06                	je     801283 <vsnprintf+0x2d>
  80127d:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801281:	7f 07                	jg     80128a <vsnprintf+0x34>
		return -E_INVAL;
  801283:	b8 03 00 00 00       	mov    $0x3,%eax
  801288:	eb 20                	jmp    8012aa <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  80128a:	ff 75 14             	pushl  0x14(%ebp)
  80128d:	ff 75 10             	pushl  0x10(%ebp)
  801290:	8d 45 ec             	lea    -0x14(%ebp),%eax
  801293:	50                   	push   %eax
  801294:	68 20 12 80 00       	push   $0x801220
  801299:	e8 92 fb ff ff       	call   800e30 <vprintfmt>
  80129e:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  8012a1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8012a4:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  8012a7:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  8012aa:	c9                   	leave  
  8012ab:	c3                   	ret    

008012ac <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  8012ac:	55                   	push   %ebp
  8012ad:	89 e5                	mov    %esp,%ebp
  8012af:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  8012b2:	8d 45 10             	lea    0x10(%ebp),%eax
  8012b5:	83 c0 04             	add    $0x4,%eax
  8012b8:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  8012bb:	8b 45 10             	mov    0x10(%ebp),%eax
  8012be:	ff 75 f4             	pushl  -0xc(%ebp)
  8012c1:	50                   	push   %eax
  8012c2:	ff 75 0c             	pushl  0xc(%ebp)
  8012c5:	ff 75 08             	pushl  0x8(%ebp)
  8012c8:	e8 89 ff ff ff       	call   801256 <vsnprintf>
  8012cd:	83 c4 10             	add    $0x10,%esp
  8012d0:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  8012d3:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8012d6:	c9                   	leave  
  8012d7:	c3                   	ret    

008012d8 <readline>:
#include <inc/lib.h>

//static char buf[BUFLEN];

void readline(const char *prompt, char* buf)
{
  8012d8:	55                   	push   %ebp
  8012d9:	89 e5                	mov    %esp,%ebp
  8012db:	83 ec 18             	sub    $0x18,%esp
		int i, c, echoing;

	if (prompt != NULL)
  8012de:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8012e2:	74 13                	je     8012f7 <readline+0x1f>
		cprintf("%s", prompt);
  8012e4:	83 ec 08             	sub    $0x8,%esp
  8012e7:	ff 75 08             	pushl  0x8(%ebp)
  8012ea:	68 d0 41 80 00       	push   $0x8041d0
  8012ef:	e8 62 f9 ff ff       	call   800c56 <cprintf>
  8012f4:	83 c4 10             	add    $0x10,%esp

	i = 0;
  8012f7:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	echoing = iscons(0);
  8012fe:	83 ec 0c             	sub    $0xc,%esp
  801301:	6a 00                	push   $0x0
  801303:	e8 54 f5 ff ff       	call   80085c <iscons>
  801308:	83 c4 10             	add    $0x10,%esp
  80130b:	89 45 f0             	mov    %eax,-0x10(%ebp)
	while (1) {
		c = getchar();
  80130e:	e8 fb f4 ff ff       	call   80080e <getchar>
  801313:	89 45 ec             	mov    %eax,-0x14(%ebp)
		if (c < 0) {
  801316:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  80131a:	79 22                	jns    80133e <readline+0x66>
			if (c != -E_EOF)
  80131c:	83 7d ec 07          	cmpl   $0x7,-0x14(%ebp)
  801320:	0f 84 ad 00 00 00    	je     8013d3 <readline+0xfb>
				cprintf("read error: %e\n", c);
  801326:	83 ec 08             	sub    $0x8,%esp
  801329:	ff 75 ec             	pushl  -0x14(%ebp)
  80132c:	68 d3 41 80 00       	push   $0x8041d3
  801331:	e8 20 f9 ff ff       	call   800c56 <cprintf>
  801336:	83 c4 10             	add    $0x10,%esp
			return;
  801339:	e9 95 00 00 00       	jmp    8013d3 <readline+0xfb>
		} else if (c >= ' ' && i < BUFLEN-1) {
  80133e:	83 7d ec 1f          	cmpl   $0x1f,-0x14(%ebp)
  801342:	7e 34                	jle    801378 <readline+0xa0>
  801344:	81 7d f4 fe 03 00 00 	cmpl   $0x3fe,-0xc(%ebp)
  80134b:	7f 2b                	jg     801378 <readline+0xa0>
			if (echoing)
  80134d:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801351:	74 0e                	je     801361 <readline+0x89>
				cputchar(c);
  801353:	83 ec 0c             	sub    $0xc,%esp
  801356:	ff 75 ec             	pushl  -0x14(%ebp)
  801359:	e8 68 f4 ff ff       	call   8007c6 <cputchar>
  80135e:	83 c4 10             	add    $0x10,%esp
			buf[i++] = c;
  801361:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801364:	8d 50 01             	lea    0x1(%eax),%edx
  801367:	89 55 f4             	mov    %edx,-0xc(%ebp)
  80136a:	89 c2                	mov    %eax,%edx
  80136c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80136f:	01 d0                	add    %edx,%eax
  801371:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801374:	88 10                	mov    %dl,(%eax)
  801376:	eb 56                	jmp    8013ce <readline+0xf6>
		} else if (c == '\b' && i > 0) {
  801378:	83 7d ec 08          	cmpl   $0x8,-0x14(%ebp)
  80137c:	75 1f                	jne    80139d <readline+0xc5>
  80137e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801382:	7e 19                	jle    80139d <readline+0xc5>
			if (echoing)
  801384:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801388:	74 0e                	je     801398 <readline+0xc0>
				cputchar(c);
  80138a:	83 ec 0c             	sub    $0xc,%esp
  80138d:	ff 75 ec             	pushl  -0x14(%ebp)
  801390:	e8 31 f4 ff ff       	call   8007c6 <cputchar>
  801395:	83 c4 10             	add    $0x10,%esp

			i--;
  801398:	ff 4d f4             	decl   -0xc(%ebp)
  80139b:	eb 31                	jmp    8013ce <readline+0xf6>
		} else if (c == '\n' || c == '\r') {
  80139d:	83 7d ec 0a          	cmpl   $0xa,-0x14(%ebp)
  8013a1:	74 0a                	je     8013ad <readline+0xd5>
  8013a3:	83 7d ec 0d          	cmpl   $0xd,-0x14(%ebp)
  8013a7:	0f 85 61 ff ff ff    	jne    80130e <readline+0x36>
			if (echoing)
  8013ad:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8013b1:	74 0e                	je     8013c1 <readline+0xe9>
				cputchar(c);
  8013b3:	83 ec 0c             	sub    $0xc,%esp
  8013b6:	ff 75 ec             	pushl  -0x14(%ebp)
  8013b9:	e8 08 f4 ff ff       	call   8007c6 <cputchar>
  8013be:	83 c4 10             	add    $0x10,%esp

			buf[i] = 0;
  8013c1:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8013c4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8013c7:	01 d0                	add    %edx,%eax
  8013c9:	c6 00 00             	movb   $0x0,(%eax)
			return;
  8013cc:	eb 06                	jmp    8013d4 <readline+0xfc>
		}
	}
  8013ce:	e9 3b ff ff ff       	jmp    80130e <readline+0x36>
	while (1) {
		c = getchar();
		if (c < 0) {
			if (c != -E_EOF)
				cprintf("read error: %e\n", c);
			return;
  8013d3:	90                   	nop
			buf[i] = 0;
			return;
		}
	}

}
  8013d4:	c9                   	leave  
  8013d5:	c3                   	ret    

008013d6 <atomic_readline>:

void atomic_readline(const char *prompt, char* buf)
{
  8013d6:	55                   	push   %ebp
  8013d7:	89 e5                	mov    %esp,%ebp
  8013d9:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  8013dc:	e8 06 0f 00 00       	call   8022e7 <sys_disable_interrupt>
	int i, c, echoing;

	if (prompt != NULL)
  8013e1:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8013e5:	74 13                	je     8013fa <atomic_readline+0x24>
		cprintf("%s", prompt);
  8013e7:	83 ec 08             	sub    $0x8,%esp
  8013ea:	ff 75 08             	pushl  0x8(%ebp)
  8013ed:	68 d0 41 80 00       	push   $0x8041d0
  8013f2:	e8 5f f8 ff ff       	call   800c56 <cprintf>
  8013f7:	83 c4 10             	add    $0x10,%esp

	i = 0;
  8013fa:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	echoing = iscons(0);
  801401:	83 ec 0c             	sub    $0xc,%esp
  801404:	6a 00                	push   $0x0
  801406:	e8 51 f4 ff ff       	call   80085c <iscons>
  80140b:	83 c4 10             	add    $0x10,%esp
  80140e:	89 45 f0             	mov    %eax,-0x10(%ebp)
	while (1) {
		c = getchar();
  801411:	e8 f8 f3 ff ff       	call   80080e <getchar>
  801416:	89 45 ec             	mov    %eax,-0x14(%ebp)
		if (c < 0) {
  801419:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  80141d:	79 23                	jns    801442 <atomic_readline+0x6c>
			if (c != -E_EOF)
  80141f:	83 7d ec 07          	cmpl   $0x7,-0x14(%ebp)
  801423:	74 13                	je     801438 <atomic_readline+0x62>
				cprintf("read error: %e\n", c);
  801425:	83 ec 08             	sub    $0x8,%esp
  801428:	ff 75 ec             	pushl  -0x14(%ebp)
  80142b:	68 d3 41 80 00       	push   $0x8041d3
  801430:	e8 21 f8 ff ff       	call   800c56 <cprintf>
  801435:	83 c4 10             	add    $0x10,%esp
			sys_enable_interrupt();
  801438:	e8 c4 0e 00 00       	call   802301 <sys_enable_interrupt>
			return;
  80143d:	e9 9a 00 00 00       	jmp    8014dc <atomic_readline+0x106>
		} else if (c >= ' ' && i < BUFLEN-1) {
  801442:	83 7d ec 1f          	cmpl   $0x1f,-0x14(%ebp)
  801446:	7e 34                	jle    80147c <atomic_readline+0xa6>
  801448:	81 7d f4 fe 03 00 00 	cmpl   $0x3fe,-0xc(%ebp)
  80144f:	7f 2b                	jg     80147c <atomic_readline+0xa6>
			if (echoing)
  801451:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801455:	74 0e                	je     801465 <atomic_readline+0x8f>
				cputchar(c);
  801457:	83 ec 0c             	sub    $0xc,%esp
  80145a:	ff 75 ec             	pushl  -0x14(%ebp)
  80145d:	e8 64 f3 ff ff       	call   8007c6 <cputchar>
  801462:	83 c4 10             	add    $0x10,%esp
			buf[i++] = c;
  801465:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801468:	8d 50 01             	lea    0x1(%eax),%edx
  80146b:	89 55 f4             	mov    %edx,-0xc(%ebp)
  80146e:	89 c2                	mov    %eax,%edx
  801470:	8b 45 0c             	mov    0xc(%ebp),%eax
  801473:	01 d0                	add    %edx,%eax
  801475:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801478:	88 10                	mov    %dl,(%eax)
  80147a:	eb 5b                	jmp    8014d7 <atomic_readline+0x101>
		} else if (c == '\b' && i > 0) {
  80147c:	83 7d ec 08          	cmpl   $0x8,-0x14(%ebp)
  801480:	75 1f                	jne    8014a1 <atomic_readline+0xcb>
  801482:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801486:	7e 19                	jle    8014a1 <atomic_readline+0xcb>
			if (echoing)
  801488:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80148c:	74 0e                	je     80149c <atomic_readline+0xc6>
				cputchar(c);
  80148e:	83 ec 0c             	sub    $0xc,%esp
  801491:	ff 75 ec             	pushl  -0x14(%ebp)
  801494:	e8 2d f3 ff ff       	call   8007c6 <cputchar>
  801499:	83 c4 10             	add    $0x10,%esp
			i--;
  80149c:	ff 4d f4             	decl   -0xc(%ebp)
  80149f:	eb 36                	jmp    8014d7 <atomic_readline+0x101>
		} else if (c == '\n' || c == '\r') {
  8014a1:	83 7d ec 0a          	cmpl   $0xa,-0x14(%ebp)
  8014a5:	74 0a                	je     8014b1 <atomic_readline+0xdb>
  8014a7:	83 7d ec 0d          	cmpl   $0xd,-0x14(%ebp)
  8014ab:	0f 85 60 ff ff ff    	jne    801411 <atomic_readline+0x3b>
			if (echoing)
  8014b1:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8014b5:	74 0e                	je     8014c5 <atomic_readline+0xef>
				cputchar(c);
  8014b7:	83 ec 0c             	sub    $0xc,%esp
  8014ba:	ff 75 ec             	pushl  -0x14(%ebp)
  8014bd:	e8 04 f3 ff ff       	call   8007c6 <cputchar>
  8014c2:	83 c4 10             	add    $0x10,%esp
			buf[i] = 0;
  8014c5:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8014c8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8014cb:	01 d0                	add    %edx,%eax
  8014cd:	c6 00 00             	movb   $0x0,(%eax)
			sys_enable_interrupt();
  8014d0:	e8 2c 0e 00 00       	call   802301 <sys_enable_interrupt>
			return;
  8014d5:	eb 05                	jmp    8014dc <atomic_readline+0x106>
		}
	}
  8014d7:	e9 35 ff ff ff       	jmp    801411 <atomic_readline+0x3b>
}
  8014dc:	c9                   	leave  
  8014dd:	c3                   	ret    

008014de <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  8014de:	55                   	push   %ebp
  8014df:	89 e5                	mov    %esp,%ebp
  8014e1:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  8014e4:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8014eb:	eb 06                	jmp    8014f3 <strlen+0x15>
		n++;
  8014ed:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  8014f0:	ff 45 08             	incl   0x8(%ebp)
  8014f3:	8b 45 08             	mov    0x8(%ebp),%eax
  8014f6:	8a 00                	mov    (%eax),%al
  8014f8:	84 c0                	test   %al,%al
  8014fa:	75 f1                	jne    8014ed <strlen+0xf>
		n++;
	return n;
  8014fc:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  8014ff:	c9                   	leave  
  801500:	c3                   	ret    

00801501 <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  801501:	55                   	push   %ebp
  801502:	89 e5                	mov    %esp,%ebp
  801504:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  801507:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  80150e:	eb 09                	jmp    801519 <strnlen+0x18>
		n++;
  801510:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  801513:	ff 45 08             	incl   0x8(%ebp)
  801516:	ff 4d 0c             	decl   0xc(%ebp)
  801519:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80151d:	74 09                	je     801528 <strnlen+0x27>
  80151f:	8b 45 08             	mov    0x8(%ebp),%eax
  801522:	8a 00                	mov    (%eax),%al
  801524:	84 c0                	test   %al,%al
  801526:	75 e8                	jne    801510 <strnlen+0xf>
		n++;
	return n;
  801528:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  80152b:	c9                   	leave  
  80152c:	c3                   	ret    

0080152d <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  80152d:	55                   	push   %ebp
  80152e:	89 e5                	mov    %esp,%ebp
  801530:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  801533:	8b 45 08             	mov    0x8(%ebp),%eax
  801536:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  801539:	90                   	nop
  80153a:	8b 45 08             	mov    0x8(%ebp),%eax
  80153d:	8d 50 01             	lea    0x1(%eax),%edx
  801540:	89 55 08             	mov    %edx,0x8(%ebp)
  801543:	8b 55 0c             	mov    0xc(%ebp),%edx
  801546:	8d 4a 01             	lea    0x1(%edx),%ecx
  801549:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  80154c:	8a 12                	mov    (%edx),%dl
  80154e:	88 10                	mov    %dl,(%eax)
  801550:	8a 00                	mov    (%eax),%al
  801552:	84 c0                	test   %al,%al
  801554:	75 e4                	jne    80153a <strcpy+0xd>
		/* do nothing */;
	return ret;
  801556:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  801559:	c9                   	leave  
  80155a:	c3                   	ret    

0080155b <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  80155b:	55                   	push   %ebp
  80155c:	89 e5                	mov    %esp,%ebp
  80155e:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  801561:	8b 45 08             	mov    0x8(%ebp),%eax
  801564:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  801567:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  80156e:	eb 1f                	jmp    80158f <strncpy+0x34>
		*dst++ = *src;
  801570:	8b 45 08             	mov    0x8(%ebp),%eax
  801573:	8d 50 01             	lea    0x1(%eax),%edx
  801576:	89 55 08             	mov    %edx,0x8(%ebp)
  801579:	8b 55 0c             	mov    0xc(%ebp),%edx
  80157c:	8a 12                	mov    (%edx),%dl
  80157e:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  801580:	8b 45 0c             	mov    0xc(%ebp),%eax
  801583:	8a 00                	mov    (%eax),%al
  801585:	84 c0                	test   %al,%al
  801587:	74 03                	je     80158c <strncpy+0x31>
			src++;
  801589:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  80158c:	ff 45 fc             	incl   -0x4(%ebp)
  80158f:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801592:	3b 45 10             	cmp    0x10(%ebp),%eax
  801595:	72 d9                	jb     801570 <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  801597:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  80159a:	c9                   	leave  
  80159b:	c3                   	ret    

0080159c <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  80159c:	55                   	push   %ebp
  80159d:	89 e5                	mov    %esp,%ebp
  80159f:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  8015a2:	8b 45 08             	mov    0x8(%ebp),%eax
  8015a5:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  8015a8:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8015ac:	74 30                	je     8015de <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  8015ae:	eb 16                	jmp    8015c6 <strlcpy+0x2a>
			*dst++ = *src++;
  8015b0:	8b 45 08             	mov    0x8(%ebp),%eax
  8015b3:	8d 50 01             	lea    0x1(%eax),%edx
  8015b6:	89 55 08             	mov    %edx,0x8(%ebp)
  8015b9:	8b 55 0c             	mov    0xc(%ebp),%edx
  8015bc:	8d 4a 01             	lea    0x1(%edx),%ecx
  8015bf:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  8015c2:	8a 12                	mov    (%edx),%dl
  8015c4:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  8015c6:	ff 4d 10             	decl   0x10(%ebp)
  8015c9:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8015cd:	74 09                	je     8015d8 <strlcpy+0x3c>
  8015cf:	8b 45 0c             	mov    0xc(%ebp),%eax
  8015d2:	8a 00                	mov    (%eax),%al
  8015d4:	84 c0                	test   %al,%al
  8015d6:	75 d8                	jne    8015b0 <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  8015d8:	8b 45 08             	mov    0x8(%ebp),%eax
  8015db:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  8015de:	8b 55 08             	mov    0x8(%ebp),%edx
  8015e1:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8015e4:	29 c2                	sub    %eax,%edx
  8015e6:	89 d0                	mov    %edx,%eax
}
  8015e8:	c9                   	leave  
  8015e9:	c3                   	ret    

008015ea <strcmp>:

int
strcmp(const char *p, const char *q)
{
  8015ea:	55                   	push   %ebp
  8015eb:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  8015ed:	eb 06                	jmp    8015f5 <strcmp+0xb>
		p++, q++;
  8015ef:	ff 45 08             	incl   0x8(%ebp)
  8015f2:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  8015f5:	8b 45 08             	mov    0x8(%ebp),%eax
  8015f8:	8a 00                	mov    (%eax),%al
  8015fa:	84 c0                	test   %al,%al
  8015fc:	74 0e                	je     80160c <strcmp+0x22>
  8015fe:	8b 45 08             	mov    0x8(%ebp),%eax
  801601:	8a 10                	mov    (%eax),%dl
  801603:	8b 45 0c             	mov    0xc(%ebp),%eax
  801606:	8a 00                	mov    (%eax),%al
  801608:	38 c2                	cmp    %al,%dl
  80160a:	74 e3                	je     8015ef <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  80160c:	8b 45 08             	mov    0x8(%ebp),%eax
  80160f:	8a 00                	mov    (%eax),%al
  801611:	0f b6 d0             	movzbl %al,%edx
  801614:	8b 45 0c             	mov    0xc(%ebp),%eax
  801617:	8a 00                	mov    (%eax),%al
  801619:	0f b6 c0             	movzbl %al,%eax
  80161c:	29 c2                	sub    %eax,%edx
  80161e:	89 d0                	mov    %edx,%eax
}
  801620:	5d                   	pop    %ebp
  801621:	c3                   	ret    

00801622 <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  801622:	55                   	push   %ebp
  801623:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  801625:	eb 09                	jmp    801630 <strncmp+0xe>
		n--, p++, q++;
  801627:	ff 4d 10             	decl   0x10(%ebp)
  80162a:	ff 45 08             	incl   0x8(%ebp)
  80162d:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  801630:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801634:	74 17                	je     80164d <strncmp+0x2b>
  801636:	8b 45 08             	mov    0x8(%ebp),%eax
  801639:	8a 00                	mov    (%eax),%al
  80163b:	84 c0                	test   %al,%al
  80163d:	74 0e                	je     80164d <strncmp+0x2b>
  80163f:	8b 45 08             	mov    0x8(%ebp),%eax
  801642:	8a 10                	mov    (%eax),%dl
  801644:	8b 45 0c             	mov    0xc(%ebp),%eax
  801647:	8a 00                	mov    (%eax),%al
  801649:	38 c2                	cmp    %al,%dl
  80164b:	74 da                	je     801627 <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  80164d:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801651:	75 07                	jne    80165a <strncmp+0x38>
		return 0;
  801653:	b8 00 00 00 00       	mov    $0x0,%eax
  801658:	eb 14                	jmp    80166e <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  80165a:	8b 45 08             	mov    0x8(%ebp),%eax
  80165d:	8a 00                	mov    (%eax),%al
  80165f:	0f b6 d0             	movzbl %al,%edx
  801662:	8b 45 0c             	mov    0xc(%ebp),%eax
  801665:	8a 00                	mov    (%eax),%al
  801667:	0f b6 c0             	movzbl %al,%eax
  80166a:	29 c2                	sub    %eax,%edx
  80166c:	89 d0                	mov    %edx,%eax
}
  80166e:	5d                   	pop    %ebp
  80166f:	c3                   	ret    

00801670 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  801670:	55                   	push   %ebp
  801671:	89 e5                	mov    %esp,%ebp
  801673:	83 ec 04             	sub    $0x4,%esp
  801676:	8b 45 0c             	mov    0xc(%ebp),%eax
  801679:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  80167c:	eb 12                	jmp    801690 <strchr+0x20>
		if (*s == c)
  80167e:	8b 45 08             	mov    0x8(%ebp),%eax
  801681:	8a 00                	mov    (%eax),%al
  801683:	3a 45 fc             	cmp    -0x4(%ebp),%al
  801686:	75 05                	jne    80168d <strchr+0x1d>
			return (char *) s;
  801688:	8b 45 08             	mov    0x8(%ebp),%eax
  80168b:	eb 11                	jmp    80169e <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  80168d:	ff 45 08             	incl   0x8(%ebp)
  801690:	8b 45 08             	mov    0x8(%ebp),%eax
  801693:	8a 00                	mov    (%eax),%al
  801695:	84 c0                	test   %al,%al
  801697:	75 e5                	jne    80167e <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  801699:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80169e:	c9                   	leave  
  80169f:	c3                   	ret    

008016a0 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  8016a0:	55                   	push   %ebp
  8016a1:	89 e5                	mov    %esp,%ebp
  8016a3:	83 ec 04             	sub    $0x4,%esp
  8016a6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8016a9:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  8016ac:	eb 0d                	jmp    8016bb <strfind+0x1b>
		if (*s == c)
  8016ae:	8b 45 08             	mov    0x8(%ebp),%eax
  8016b1:	8a 00                	mov    (%eax),%al
  8016b3:	3a 45 fc             	cmp    -0x4(%ebp),%al
  8016b6:	74 0e                	je     8016c6 <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  8016b8:	ff 45 08             	incl   0x8(%ebp)
  8016bb:	8b 45 08             	mov    0x8(%ebp),%eax
  8016be:	8a 00                	mov    (%eax),%al
  8016c0:	84 c0                	test   %al,%al
  8016c2:	75 ea                	jne    8016ae <strfind+0xe>
  8016c4:	eb 01                	jmp    8016c7 <strfind+0x27>
		if (*s == c)
			break;
  8016c6:	90                   	nop
	return (char *) s;
  8016c7:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8016ca:	c9                   	leave  
  8016cb:	c3                   	ret    

008016cc <memset>:


void *
memset(void *v, int c, uint32 n)
{
  8016cc:	55                   	push   %ebp
  8016cd:	89 e5                	mov    %esp,%ebp
  8016cf:	83 ec 10             	sub    $0x10,%esp
	char *p;
	int m;

	p = v;
  8016d2:	8b 45 08             	mov    0x8(%ebp),%eax
  8016d5:	89 45 fc             	mov    %eax,-0x4(%ebp)
	m = n;
  8016d8:	8b 45 10             	mov    0x10(%ebp),%eax
  8016db:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (--m >= 0)
  8016de:	eb 0e                	jmp    8016ee <memset+0x22>
		*p++ = c;
  8016e0:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8016e3:	8d 50 01             	lea    0x1(%eax),%edx
  8016e6:	89 55 fc             	mov    %edx,-0x4(%ebp)
  8016e9:	8b 55 0c             	mov    0xc(%ebp),%edx
  8016ec:	88 10                	mov    %dl,(%eax)
	char *p;
	int m;

	p = v;
	m = n;
	while (--m >= 0)
  8016ee:	ff 4d f8             	decl   -0x8(%ebp)
  8016f1:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  8016f5:	79 e9                	jns    8016e0 <memset+0x14>
		*p++ = c;

	return v;
  8016f7:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8016fa:	c9                   	leave  
  8016fb:	c3                   	ret    

008016fc <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  8016fc:	55                   	push   %ebp
  8016fd:	89 e5                	mov    %esp,%ebp
  8016ff:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  801702:	8b 45 0c             	mov    0xc(%ebp),%eax
  801705:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  801708:	8b 45 08             	mov    0x8(%ebp),%eax
  80170b:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (n-- > 0)
  80170e:	eb 16                	jmp    801726 <memcpy+0x2a>
		*d++ = *s++;
  801710:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801713:	8d 50 01             	lea    0x1(%eax),%edx
  801716:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801719:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80171c:	8d 4a 01             	lea    0x1(%edx),%ecx
  80171f:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  801722:	8a 12                	mov    (%edx),%dl
  801724:	88 10                	mov    %dl,(%eax)
	const char *s;
	char *d;

	s = src;
	d = dst;
	while (n-- > 0)
  801726:	8b 45 10             	mov    0x10(%ebp),%eax
  801729:	8d 50 ff             	lea    -0x1(%eax),%edx
  80172c:	89 55 10             	mov    %edx,0x10(%ebp)
  80172f:	85 c0                	test   %eax,%eax
  801731:	75 dd                	jne    801710 <memcpy+0x14>
		*d++ = *s++;

	return dst;
  801733:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801736:	c9                   	leave  
  801737:	c3                   	ret    

00801738 <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  801738:	55                   	push   %ebp
  801739:	89 e5                	mov    %esp,%ebp
  80173b:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  80173e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801741:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  801744:	8b 45 08             	mov    0x8(%ebp),%eax
  801747:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  80174a:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80174d:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  801750:	73 50                	jae    8017a2 <memmove+0x6a>
  801752:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801755:	8b 45 10             	mov    0x10(%ebp),%eax
  801758:	01 d0                	add    %edx,%eax
  80175a:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  80175d:	76 43                	jbe    8017a2 <memmove+0x6a>
		s += n;
  80175f:	8b 45 10             	mov    0x10(%ebp),%eax
  801762:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  801765:	8b 45 10             	mov    0x10(%ebp),%eax
  801768:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  80176b:	eb 10                	jmp    80177d <memmove+0x45>
			*--d = *--s;
  80176d:	ff 4d f8             	decl   -0x8(%ebp)
  801770:	ff 4d fc             	decl   -0x4(%ebp)
  801773:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801776:	8a 10                	mov    (%eax),%dl
  801778:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80177b:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  80177d:	8b 45 10             	mov    0x10(%ebp),%eax
  801780:	8d 50 ff             	lea    -0x1(%eax),%edx
  801783:	89 55 10             	mov    %edx,0x10(%ebp)
  801786:	85 c0                	test   %eax,%eax
  801788:	75 e3                	jne    80176d <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  80178a:	eb 23                	jmp    8017af <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  80178c:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80178f:	8d 50 01             	lea    0x1(%eax),%edx
  801792:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801795:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801798:	8d 4a 01             	lea    0x1(%edx),%ecx
  80179b:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  80179e:	8a 12                	mov    (%edx),%dl
  8017a0:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  8017a2:	8b 45 10             	mov    0x10(%ebp),%eax
  8017a5:	8d 50 ff             	lea    -0x1(%eax),%edx
  8017a8:	89 55 10             	mov    %edx,0x10(%ebp)
  8017ab:	85 c0                	test   %eax,%eax
  8017ad:	75 dd                	jne    80178c <memmove+0x54>
			*d++ = *s++;

	return dst;
  8017af:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8017b2:	c9                   	leave  
  8017b3:	c3                   	ret    

008017b4 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  8017b4:	55                   	push   %ebp
  8017b5:	89 e5                	mov    %esp,%ebp
  8017b7:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  8017ba:	8b 45 08             	mov    0x8(%ebp),%eax
  8017bd:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  8017c0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8017c3:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  8017c6:	eb 2a                	jmp    8017f2 <memcmp+0x3e>
		if (*s1 != *s2)
  8017c8:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8017cb:	8a 10                	mov    (%eax),%dl
  8017cd:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8017d0:	8a 00                	mov    (%eax),%al
  8017d2:	38 c2                	cmp    %al,%dl
  8017d4:	74 16                	je     8017ec <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  8017d6:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8017d9:	8a 00                	mov    (%eax),%al
  8017db:	0f b6 d0             	movzbl %al,%edx
  8017de:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8017e1:	8a 00                	mov    (%eax),%al
  8017e3:	0f b6 c0             	movzbl %al,%eax
  8017e6:	29 c2                	sub    %eax,%edx
  8017e8:	89 d0                	mov    %edx,%eax
  8017ea:	eb 18                	jmp    801804 <memcmp+0x50>
		s1++, s2++;
  8017ec:	ff 45 fc             	incl   -0x4(%ebp)
  8017ef:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  8017f2:	8b 45 10             	mov    0x10(%ebp),%eax
  8017f5:	8d 50 ff             	lea    -0x1(%eax),%edx
  8017f8:	89 55 10             	mov    %edx,0x10(%ebp)
  8017fb:	85 c0                	test   %eax,%eax
  8017fd:	75 c9                	jne    8017c8 <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  8017ff:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801804:	c9                   	leave  
  801805:	c3                   	ret    

00801806 <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  801806:	55                   	push   %ebp
  801807:	89 e5                	mov    %esp,%ebp
  801809:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  80180c:	8b 55 08             	mov    0x8(%ebp),%edx
  80180f:	8b 45 10             	mov    0x10(%ebp),%eax
  801812:	01 d0                	add    %edx,%eax
  801814:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  801817:	eb 15                	jmp    80182e <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  801819:	8b 45 08             	mov    0x8(%ebp),%eax
  80181c:	8a 00                	mov    (%eax),%al
  80181e:	0f b6 d0             	movzbl %al,%edx
  801821:	8b 45 0c             	mov    0xc(%ebp),%eax
  801824:	0f b6 c0             	movzbl %al,%eax
  801827:	39 c2                	cmp    %eax,%edx
  801829:	74 0d                	je     801838 <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  80182b:	ff 45 08             	incl   0x8(%ebp)
  80182e:	8b 45 08             	mov    0x8(%ebp),%eax
  801831:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  801834:	72 e3                	jb     801819 <memfind+0x13>
  801836:	eb 01                	jmp    801839 <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  801838:	90                   	nop
	return (void *) s;
  801839:	8b 45 08             	mov    0x8(%ebp),%eax
}
  80183c:	c9                   	leave  
  80183d:	c3                   	ret    

0080183e <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  80183e:	55                   	push   %ebp
  80183f:	89 e5                	mov    %esp,%ebp
  801841:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  801844:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  80184b:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801852:	eb 03                	jmp    801857 <strtol+0x19>
		s++;
  801854:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801857:	8b 45 08             	mov    0x8(%ebp),%eax
  80185a:	8a 00                	mov    (%eax),%al
  80185c:	3c 20                	cmp    $0x20,%al
  80185e:	74 f4                	je     801854 <strtol+0x16>
  801860:	8b 45 08             	mov    0x8(%ebp),%eax
  801863:	8a 00                	mov    (%eax),%al
  801865:	3c 09                	cmp    $0x9,%al
  801867:	74 eb                	je     801854 <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  801869:	8b 45 08             	mov    0x8(%ebp),%eax
  80186c:	8a 00                	mov    (%eax),%al
  80186e:	3c 2b                	cmp    $0x2b,%al
  801870:	75 05                	jne    801877 <strtol+0x39>
		s++;
  801872:	ff 45 08             	incl   0x8(%ebp)
  801875:	eb 13                	jmp    80188a <strtol+0x4c>
	else if (*s == '-')
  801877:	8b 45 08             	mov    0x8(%ebp),%eax
  80187a:	8a 00                	mov    (%eax),%al
  80187c:	3c 2d                	cmp    $0x2d,%al
  80187e:	75 0a                	jne    80188a <strtol+0x4c>
		s++, neg = 1;
  801880:	ff 45 08             	incl   0x8(%ebp)
  801883:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  80188a:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80188e:	74 06                	je     801896 <strtol+0x58>
  801890:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  801894:	75 20                	jne    8018b6 <strtol+0x78>
  801896:	8b 45 08             	mov    0x8(%ebp),%eax
  801899:	8a 00                	mov    (%eax),%al
  80189b:	3c 30                	cmp    $0x30,%al
  80189d:	75 17                	jne    8018b6 <strtol+0x78>
  80189f:	8b 45 08             	mov    0x8(%ebp),%eax
  8018a2:	40                   	inc    %eax
  8018a3:	8a 00                	mov    (%eax),%al
  8018a5:	3c 78                	cmp    $0x78,%al
  8018a7:	75 0d                	jne    8018b6 <strtol+0x78>
		s += 2, base = 16;
  8018a9:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  8018ad:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  8018b4:	eb 28                	jmp    8018de <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  8018b6:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8018ba:	75 15                	jne    8018d1 <strtol+0x93>
  8018bc:	8b 45 08             	mov    0x8(%ebp),%eax
  8018bf:	8a 00                	mov    (%eax),%al
  8018c1:	3c 30                	cmp    $0x30,%al
  8018c3:	75 0c                	jne    8018d1 <strtol+0x93>
		s++, base = 8;
  8018c5:	ff 45 08             	incl   0x8(%ebp)
  8018c8:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  8018cf:	eb 0d                	jmp    8018de <strtol+0xa0>
	else if (base == 0)
  8018d1:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8018d5:	75 07                	jne    8018de <strtol+0xa0>
		base = 10;
  8018d7:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  8018de:	8b 45 08             	mov    0x8(%ebp),%eax
  8018e1:	8a 00                	mov    (%eax),%al
  8018e3:	3c 2f                	cmp    $0x2f,%al
  8018e5:	7e 19                	jle    801900 <strtol+0xc2>
  8018e7:	8b 45 08             	mov    0x8(%ebp),%eax
  8018ea:	8a 00                	mov    (%eax),%al
  8018ec:	3c 39                	cmp    $0x39,%al
  8018ee:	7f 10                	jg     801900 <strtol+0xc2>
			dig = *s - '0';
  8018f0:	8b 45 08             	mov    0x8(%ebp),%eax
  8018f3:	8a 00                	mov    (%eax),%al
  8018f5:	0f be c0             	movsbl %al,%eax
  8018f8:	83 e8 30             	sub    $0x30,%eax
  8018fb:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8018fe:	eb 42                	jmp    801942 <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  801900:	8b 45 08             	mov    0x8(%ebp),%eax
  801903:	8a 00                	mov    (%eax),%al
  801905:	3c 60                	cmp    $0x60,%al
  801907:	7e 19                	jle    801922 <strtol+0xe4>
  801909:	8b 45 08             	mov    0x8(%ebp),%eax
  80190c:	8a 00                	mov    (%eax),%al
  80190e:	3c 7a                	cmp    $0x7a,%al
  801910:	7f 10                	jg     801922 <strtol+0xe4>
			dig = *s - 'a' + 10;
  801912:	8b 45 08             	mov    0x8(%ebp),%eax
  801915:	8a 00                	mov    (%eax),%al
  801917:	0f be c0             	movsbl %al,%eax
  80191a:	83 e8 57             	sub    $0x57,%eax
  80191d:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801920:	eb 20                	jmp    801942 <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  801922:	8b 45 08             	mov    0x8(%ebp),%eax
  801925:	8a 00                	mov    (%eax),%al
  801927:	3c 40                	cmp    $0x40,%al
  801929:	7e 39                	jle    801964 <strtol+0x126>
  80192b:	8b 45 08             	mov    0x8(%ebp),%eax
  80192e:	8a 00                	mov    (%eax),%al
  801930:	3c 5a                	cmp    $0x5a,%al
  801932:	7f 30                	jg     801964 <strtol+0x126>
			dig = *s - 'A' + 10;
  801934:	8b 45 08             	mov    0x8(%ebp),%eax
  801937:	8a 00                	mov    (%eax),%al
  801939:	0f be c0             	movsbl %al,%eax
  80193c:	83 e8 37             	sub    $0x37,%eax
  80193f:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  801942:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801945:	3b 45 10             	cmp    0x10(%ebp),%eax
  801948:	7d 19                	jge    801963 <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  80194a:	ff 45 08             	incl   0x8(%ebp)
  80194d:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801950:	0f af 45 10          	imul   0x10(%ebp),%eax
  801954:	89 c2                	mov    %eax,%edx
  801956:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801959:	01 d0                	add    %edx,%eax
  80195b:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  80195e:	e9 7b ff ff ff       	jmp    8018de <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  801963:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  801964:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801968:	74 08                	je     801972 <strtol+0x134>
		*endptr = (char *) s;
  80196a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80196d:	8b 55 08             	mov    0x8(%ebp),%edx
  801970:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  801972:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801976:	74 07                	je     80197f <strtol+0x141>
  801978:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80197b:	f7 d8                	neg    %eax
  80197d:	eb 03                	jmp    801982 <strtol+0x144>
  80197f:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  801982:	c9                   	leave  
  801983:	c3                   	ret    

00801984 <ltostr>:

void
ltostr(long value, char *str)
{
  801984:	55                   	push   %ebp
  801985:	89 e5                	mov    %esp,%ebp
  801987:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  80198a:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  801991:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  801998:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80199c:	79 13                	jns    8019b1 <ltostr+0x2d>
	{
		neg = 1;
  80199e:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  8019a5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8019a8:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  8019ab:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  8019ae:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  8019b1:	8b 45 08             	mov    0x8(%ebp),%eax
  8019b4:	b9 0a 00 00 00       	mov    $0xa,%ecx
  8019b9:	99                   	cltd   
  8019ba:	f7 f9                	idiv   %ecx
  8019bc:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  8019bf:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8019c2:	8d 50 01             	lea    0x1(%eax),%edx
  8019c5:	89 55 f8             	mov    %edx,-0x8(%ebp)
  8019c8:	89 c2                	mov    %eax,%edx
  8019ca:	8b 45 0c             	mov    0xc(%ebp),%eax
  8019cd:	01 d0                	add    %edx,%eax
  8019cf:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8019d2:	83 c2 30             	add    $0x30,%edx
  8019d5:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  8019d7:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8019da:	b8 67 66 66 66       	mov    $0x66666667,%eax
  8019df:	f7 e9                	imul   %ecx
  8019e1:	c1 fa 02             	sar    $0x2,%edx
  8019e4:	89 c8                	mov    %ecx,%eax
  8019e6:	c1 f8 1f             	sar    $0x1f,%eax
  8019e9:	29 c2                	sub    %eax,%edx
  8019eb:	89 d0                	mov    %edx,%eax
  8019ed:	89 45 08             	mov    %eax,0x8(%ebp)
	} while (value % 10 != 0);
  8019f0:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8019f3:	b8 67 66 66 66       	mov    $0x66666667,%eax
  8019f8:	f7 e9                	imul   %ecx
  8019fa:	c1 fa 02             	sar    $0x2,%edx
  8019fd:	89 c8                	mov    %ecx,%eax
  8019ff:	c1 f8 1f             	sar    $0x1f,%eax
  801a02:	29 c2                	sub    %eax,%edx
  801a04:	89 d0                	mov    %edx,%eax
  801a06:	c1 e0 02             	shl    $0x2,%eax
  801a09:	01 d0                	add    %edx,%eax
  801a0b:	01 c0                	add    %eax,%eax
  801a0d:	29 c1                	sub    %eax,%ecx
  801a0f:	89 ca                	mov    %ecx,%edx
  801a11:	85 d2                	test   %edx,%edx
  801a13:	75 9c                	jne    8019b1 <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  801a15:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  801a1c:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801a1f:	48                   	dec    %eax
  801a20:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  801a23:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801a27:	74 3d                	je     801a66 <ltostr+0xe2>
		start = 1 ;
  801a29:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  801a30:	eb 34                	jmp    801a66 <ltostr+0xe2>
	{
		char tmp = str[start] ;
  801a32:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801a35:	8b 45 0c             	mov    0xc(%ebp),%eax
  801a38:	01 d0                	add    %edx,%eax
  801a3a:	8a 00                	mov    (%eax),%al
  801a3c:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  801a3f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801a42:	8b 45 0c             	mov    0xc(%ebp),%eax
  801a45:	01 c2                	add    %eax,%edx
  801a47:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  801a4a:	8b 45 0c             	mov    0xc(%ebp),%eax
  801a4d:	01 c8                	add    %ecx,%eax
  801a4f:	8a 00                	mov    (%eax),%al
  801a51:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  801a53:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801a56:	8b 45 0c             	mov    0xc(%ebp),%eax
  801a59:	01 c2                	add    %eax,%edx
  801a5b:	8a 45 eb             	mov    -0x15(%ebp),%al
  801a5e:	88 02                	mov    %al,(%edx)
		start++ ;
  801a60:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  801a63:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  801a66:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801a69:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801a6c:	7c c4                	jl     801a32 <ltostr+0xae>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  801a6e:	8b 55 f8             	mov    -0x8(%ebp),%edx
  801a71:	8b 45 0c             	mov    0xc(%ebp),%eax
  801a74:	01 d0                	add    %edx,%eax
  801a76:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  801a79:	90                   	nop
  801a7a:	c9                   	leave  
  801a7b:	c3                   	ret    

00801a7c <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  801a7c:	55                   	push   %ebp
  801a7d:	89 e5                	mov    %esp,%ebp
  801a7f:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  801a82:	ff 75 08             	pushl  0x8(%ebp)
  801a85:	e8 54 fa ff ff       	call   8014de <strlen>
  801a8a:	83 c4 04             	add    $0x4,%esp
  801a8d:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  801a90:	ff 75 0c             	pushl  0xc(%ebp)
  801a93:	e8 46 fa ff ff       	call   8014de <strlen>
  801a98:	83 c4 04             	add    $0x4,%esp
  801a9b:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  801a9e:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  801aa5:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801aac:	eb 17                	jmp    801ac5 <strcconcat+0x49>
		final[s] = str1[s] ;
  801aae:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801ab1:	8b 45 10             	mov    0x10(%ebp),%eax
  801ab4:	01 c2                	add    %eax,%edx
  801ab6:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  801ab9:	8b 45 08             	mov    0x8(%ebp),%eax
  801abc:	01 c8                	add    %ecx,%eax
  801abe:	8a 00                	mov    (%eax),%al
  801ac0:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  801ac2:	ff 45 fc             	incl   -0x4(%ebp)
  801ac5:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801ac8:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  801acb:	7c e1                	jl     801aae <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  801acd:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  801ad4:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  801adb:	eb 1f                	jmp    801afc <strcconcat+0x80>
		final[s++] = str2[i] ;
  801add:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801ae0:	8d 50 01             	lea    0x1(%eax),%edx
  801ae3:	89 55 fc             	mov    %edx,-0x4(%ebp)
  801ae6:	89 c2                	mov    %eax,%edx
  801ae8:	8b 45 10             	mov    0x10(%ebp),%eax
  801aeb:	01 c2                	add    %eax,%edx
  801aed:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  801af0:	8b 45 0c             	mov    0xc(%ebp),%eax
  801af3:	01 c8                	add    %ecx,%eax
  801af5:	8a 00                	mov    (%eax),%al
  801af7:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  801af9:	ff 45 f8             	incl   -0x8(%ebp)
  801afc:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801aff:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801b02:	7c d9                	jl     801add <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  801b04:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801b07:	8b 45 10             	mov    0x10(%ebp),%eax
  801b0a:	01 d0                	add    %edx,%eax
  801b0c:	c6 00 00             	movb   $0x0,(%eax)
}
  801b0f:	90                   	nop
  801b10:	c9                   	leave  
  801b11:	c3                   	ret    

00801b12 <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  801b12:	55                   	push   %ebp
  801b13:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  801b15:	8b 45 14             	mov    0x14(%ebp),%eax
  801b18:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  801b1e:	8b 45 14             	mov    0x14(%ebp),%eax
  801b21:	8b 00                	mov    (%eax),%eax
  801b23:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801b2a:	8b 45 10             	mov    0x10(%ebp),%eax
  801b2d:	01 d0                	add    %edx,%eax
  801b2f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801b35:	eb 0c                	jmp    801b43 <strsplit+0x31>
			*string++ = 0;
  801b37:	8b 45 08             	mov    0x8(%ebp),%eax
  801b3a:	8d 50 01             	lea    0x1(%eax),%edx
  801b3d:	89 55 08             	mov    %edx,0x8(%ebp)
  801b40:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801b43:	8b 45 08             	mov    0x8(%ebp),%eax
  801b46:	8a 00                	mov    (%eax),%al
  801b48:	84 c0                	test   %al,%al
  801b4a:	74 18                	je     801b64 <strsplit+0x52>
  801b4c:	8b 45 08             	mov    0x8(%ebp),%eax
  801b4f:	8a 00                	mov    (%eax),%al
  801b51:	0f be c0             	movsbl %al,%eax
  801b54:	50                   	push   %eax
  801b55:	ff 75 0c             	pushl  0xc(%ebp)
  801b58:	e8 13 fb ff ff       	call   801670 <strchr>
  801b5d:	83 c4 08             	add    $0x8,%esp
  801b60:	85 c0                	test   %eax,%eax
  801b62:	75 d3                	jne    801b37 <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  801b64:	8b 45 08             	mov    0x8(%ebp),%eax
  801b67:	8a 00                	mov    (%eax),%al
  801b69:	84 c0                	test   %al,%al
  801b6b:	74 5a                	je     801bc7 <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  801b6d:	8b 45 14             	mov    0x14(%ebp),%eax
  801b70:	8b 00                	mov    (%eax),%eax
  801b72:	83 f8 0f             	cmp    $0xf,%eax
  801b75:	75 07                	jne    801b7e <strsplit+0x6c>
		{
			return 0;
  801b77:	b8 00 00 00 00       	mov    $0x0,%eax
  801b7c:	eb 66                	jmp    801be4 <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  801b7e:	8b 45 14             	mov    0x14(%ebp),%eax
  801b81:	8b 00                	mov    (%eax),%eax
  801b83:	8d 48 01             	lea    0x1(%eax),%ecx
  801b86:	8b 55 14             	mov    0x14(%ebp),%edx
  801b89:	89 0a                	mov    %ecx,(%edx)
  801b8b:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801b92:	8b 45 10             	mov    0x10(%ebp),%eax
  801b95:	01 c2                	add    %eax,%edx
  801b97:	8b 45 08             	mov    0x8(%ebp),%eax
  801b9a:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  801b9c:	eb 03                	jmp    801ba1 <strsplit+0x8f>
			string++;
  801b9e:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  801ba1:	8b 45 08             	mov    0x8(%ebp),%eax
  801ba4:	8a 00                	mov    (%eax),%al
  801ba6:	84 c0                	test   %al,%al
  801ba8:	74 8b                	je     801b35 <strsplit+0x23>
  801baa:	8b 45 08             	mov    0x8(%ebp),%eax
  801bad:	8a 00                	mov    (%eax),%al
  801baf:	0f be c0             	movsbl %al,%eax
  801bb2:	50                   	push   %eax
  801bb3:	ff 75 0c             	pushl  0xc(%ebp)
  801bb6:	e8 b5 fa ff ff       	call   801670 <strchr>
  801bbb:	83 c4 08             	add    $0x8,%esp
  801bbe:	85 c0                	test   %eax,%eax
  801bc0:	74 dc                	je     801b9e <strsplit+0x8c>
			string++;
	}
  801bc2:	e9 6e ff ff ff       	jmp    801b35 <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  801bc7:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  801bc8:	8b 45 14             	mov    0x14(%ebp),%eax
  801bcb:	8b 00                	mov    (%eax),%eax
  801bcd:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801bd4:	8b 45 10             	mov    0x10(%ebp),%eax
  801bd7:	01 d0                	add    %edx,%eax
  801bd9:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  801bdf:	b8 01 00 00 00       	mov    $0x1,%eax
}
  801be4:	c9                   	leave  
  801be5:	c3                   	ret    

00801be6 <InitializeUHeap>:
//============================== GIVEN FUNCTIONS ===================================//
//==================================================================================//

int FirstTimeFlag = 1;
void InitializeUHeap()
{
  801be6:	55                   	push   %ebp
  801be7:	89 e5                	mov    %esp,%ebp
  801be9:	83 ec 08             	sub    $0x8,%esp
	if(FirstTimeFlag)
  801bec:	a1 04 50 80 00       	mov    0x805004,%eax
  801bf1:	85 c0                	test   %eax,%eax
  801bf3:	74 1f                	je     801c14 <InitializeUHeap+0x2e>
	{
		initialize_dyn_block_system();
  801bf5:	e8 1d 00 00 00       	call   801c17 <initialize_dyn_block_system>
		cprintf("DYNAMIC BLOCK SYSTEM IS INITIALIZED\n");
  801bfa:	83 ec 0c             	sub    $0xc,%esp
  801bfd:	68 e4 41 80 00       	push   $0x8041e4
  801c02:	e8 4f f0 ff ff       	call   800c56 <cprintf>
  801c07:	83 c4 10             	add    $0x10,%esp
#if UHP_USE_BUDDY
		initialize_buddy();
		cprintf("BUDDY SYSTEM IS INITIALIZED\n");
#endif
		FirstTimeFlag = 0;
  801c0a:	c7 05 04 50 80 00 00 	movl   $0x0,0x805004
  801c11:	00 00 00 
	}
}
  801c14:	90                   	nop
  801c15:	c9                   	leave  
  801c16:	c3                   	ret    

00801c17 <initialize_dyn_block_system>:

//=================================
// [1] INITIALIZE DYNAMIC ALLOCATOR:
//=================================
void initialize_dyn_block_system()
{
  801c17:	55                   	push   %ebp
  801c18:	89 e5                	mov    %esp,%ebp
  801c1a:	83 ec 28             	sub    $0x28,%esp
	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] initialize_dyn_block_system
	// your code is here, remove the panic and write your code
	//panic("initialize_dyn_block_system() is not implemented yet...!!");

	LIST_INIT(&AllocMemBlocksList);
  801c1d:	c7 05 40 50 80 00 00 	movl   $0x0,0x805040
  801c24:	00 00 00 
  801c27:	c7 05 44 50 80 00 00 	movl   $0x0,0x805044
  801c2e:	00 00 00 
  801c31:	c7 05 4c 50 80 00 00 	movl   $0x0,0x80504c
  801c38:	00 00 00 
	LIST_INIT(&FreeMemBlocksList);
  801c3b:	c7 05 38 51 80 00 00 	movl   $0x0,0x805138
  801c42:	00 00 00 
  801c45:	c7 05 3c 51 80 00 00 	movl   $0x0,0x80513c
  801c4c:	00 00 00 
  801c4f:	c7 05 44 51 80 00 00 	movl   $0x0,0x805144
  801c56:	00 00 00 
	MAX_MEM_BLOCK_CNT = NUM_OF_UHEAP_PAGES;
  801c59:	c7 05 20 51 80 00 00 	movl   $0x20000,0x805120
  801c60:	00 02 00 
	MemBlockNodes = (void*)USER_DYN_BLKS_ARRAY;
  801c63:	c7 45 f4 00 00 e0 7f 	movl   $0x7fe00000,-0xc(%ebp)
  801c6a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801c6d:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801c72:	2d 00 10 00 00       	sub    $0x1000,%eax
  801c77:	a3 50 50 80 00       	mov    %eax,0x805050
	int size_of_block = sizeof(struct MemBlock);
  801c7c:	c7 45 f0 10 00 00 00 	movl   $0x10,-0x10(%ebp)
	int size_all_struct = size_of_block*MAX_MEM_BLOCK_CNT;
  801c83:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801c86:	a1 20 51 80 00       	mov    0x805120,%eax
  801c8b:	0f af c2             	imul   %edx,%eax
  801c8e:	89 45 ec             	mov    %eax,-0x14(%ebp)
	size_all_struct = ROUNDUP(size_all_struct, PAGE_SIZE);
  801c91:	c7 45 e8 00 10 00 00 	movl   $0x1000,-0x18(%ebp)
  801c98:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801c9b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801c9e:	01 d0                	add    %edx,%eax
  801ca0:	48                   	dec    %eax
  801ca1:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  801ca4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801ca7:	ba 00 00 00 00       	mov    $0x0,%edx
  801cac:	f7 75 e8             	divl   -0x18(%ebp)
  801caf:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801cb2:	29 d0                	sub    %edx,%eax
  801cb4:	89 45 ec             	mov    %eax,-0x14(%ebp)
	sys_allocate_chunk(USER_DYN_BLKS_ARRAY, size_all_struct,PERM_USER| PERM_WRITEABLE);
  801cb7:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801cba:	c7 45 e0 00 00 e0 7f 	movl   $0x7fe00000,-0x20(%ebp)
  801cc1:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801cc4:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
  801cca:	81 ea 00 10 00 00    	sub    $0x1000,%edx
  801cd0:	83 ec 04             	sub    $0x4,%esp
  801cd3:	6a 06                	push   $0x6
  801cd5:	50                   	push   %eax
  801cd6:	52                   	push   %edx
  801cd7:	e8 a1 05 00 00       	call   80227d <sys_allocate_chunk>
  801cdc:	83 c4 10             	add    $0x10,%esp
	initialize_MemBlocksList(MAX_MEM_BLOCK_CNT);
  801cdf:	a1 20 51 80 00       	mov    0x805120,%eax
  801ce4:	83 ec 0c             	sub    $0xc,%esp
  801ce7:	50                   	push   %eax
  801ce8:	e8 16 0c 00 00       	call   802903 <initialize_MemBlocksList>
  801ced:	83 c4 10             	add    $0x10,%esp
	struct MemBlock* ourBlock =LIST_LAST(&AvailableMemBlocksList);
  801cf0:	a1 4c 51 80 00       	mov    0x80514c,%eax
  801cf5:	89 45 dc             	mov    %eax,-0x24(%ebp)
	LIST_REMOVE(&AvailableMemBlocksList,ourBlock);
  801cf8:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  801cfc:	75 14                	jne    801d12 <initialize_dyn_block_system+0xfb>
  801cfe:	83 ec 04             	sub    $0x4,%esp
  801d01:	68 09 42 80 00       	push   $0x804209
  801d06:	6a 2d                	push   $0x2d
  801d08:	68 27 42 80 00       	push   $0x804227
  801d0d:	e8 90 ec ff ff       	call   8009a2 <_panic>
  801d12:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801d15:	8b 00                	mov    (%eax),%eax
  801d17:	85 c0                	test   %eax,%eax
  801d19:	74 10                	je     801d2b <initialize_dyn_block_system+0x114>
  801d1b:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801d1e:	8b 00                	mov    (%eax),%eax
  801d20:	8b 55 dc             	mov    -0x24(%ebp),%edx
  801d23:	8b 52 04             	mov    0x4(%edx),%edx
  801d26:	89 50 04             	mov    %edx,0x4(%eax)
  801d29:	eb 0b                	jmp    801d36 <initialize_dyn_block_system+0x11f>
  801d2b:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801d2e:	8b 40 04             	mov    0x4(%eax),%eax
  801d31:	a3 4c 51 80 00       	mov    %eax,0x80514c
  801d36:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801d39:	8b 40 04             	mov    0x4(%eax),%eax
  801d3c:	85 c0                	test   %eax,%eax
  801d3e:	74 0f                	je     801d4f <initialize_dyn_block_system+0x138>
  801d40:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801d43:	8b 40 04             	mov    0x4(%eax),%eax
  801d46:	8b 55 dc             	mov    -0x24(%ebp),%edx
  801d49:	8b 12                	mov    (%edx),%edx
  801d4b:	89 10                	mov    %edx,(%eax)
  801d4d:	eb 0a                	jmp    801d59 <initialize_dyn_block_system+0x142>
  801d4f:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801d52:	8b 00                	mov    (%eax),%eax
  801d54:	a3 48 51 80 00       	mov    %eax,0x805148
  801d59:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801d5c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  801d62:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801d65:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  801d6c:	a1 54 51 80 00       	mov    0x805154,%eax
  801d71:	48                   	dec    %eax
  801d72:	a3 54 51 80 00       	mov    %eax,0x805154
	ourBlock->size = USER_HEAP_MAX-USER_HEAP_START;
  801d77:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801d7a:	c7 40 0c 00 00 00 20 	movl   $0x20000000,0xc(%eax)
	ourBlock->sva=USER_HEAP_START;
  801d81:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801d84:	c7 40 08 00 00 00 80 	movl   $0x80000000,0x8(%eax)
	LIST_INSERT_TAIL(&FreeMemBlocksList, ourBlock);
  801d8b:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  801d8f:	75 14                	jne    801da5 <initialize_dyn_block_system+0x18e>
  801d91:	83 ec 04             	sub    $0x4,%esp
  801d94:	68 34 42 80 00       	push   $0x804234
  801d99:	6a 30                	push   $0x30
  801d9b:	68 27 42 80 00       	push   $0x804227
  801da0:	e8 fd eb ff ff       	call   8009a2 <_panic>
  801da5:	8b 15 3c 51 80 00    	mov    0x80513c,%edx
  801dab:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801dae:	89 50 04             	mov    %edx,0x4(%eax)
  801db1:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801db4:	8b 40 04             	mov    0x4(%eax),%eax
  801db7:	85 c0                	test   %eax,%eax
  801db9:	74 0c                	je     801dc7 <initialize_dyn_block_system+0x1b0>
  801dbb:	a1 3c 51 80 00       	mov    0x80513c,%eax
  801dc0:	8b 55 dc             	mov    -0x24(%ebp),%edx
  801dc3:	89 10                	mov    %edx,(%eax)
  801dc5:	eb 08                	jmp    801dcf <initialize_dyn_block_system+0x1b8>
  801dc7:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801dca:	a3 38 51 80 00       	mov    %eax,0x805138
  801dcf:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801dd2:	a3 3c 51 80 00       	mov    %eax,0x80513c
  801dd7:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801dda:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  801de0:	a1 44 51 80 00       	mov    0x805144,%eax
  801de5:	40                   	inc    %eax
  801de6:	a3 44 51 80 00       	mov    %eax,0x805144
	//[1] Initialize two lists (AllocMemBlocksList & FreeMemBlocksList) [Hint: use LIST_INIT()]
	//[2] Dynamically allocate the array of MemBlockNodes at VA USER_DYN_BLKS_ARRAY
	//	  (remember to set MAX_MEM_BLOCK_CNT with the chosen size of the array)
	//[3] Initialize AvailableMemBlocksList by filling it with the MemBlockNodes
	//[4] Insert a new MemBlock with the heap size into the FreeMemBlocksList
}
  801deb:	90                   	nop
  801dec:	c9                   	leave  
  801ded:	c3                   	ret    

00801dee <malloc>:
//=================================
// [2] ALLOCATE SPACE IN USER HEAP:
//=================================

void* malloc(uint32 size)
{
  801dee:	55                   	push   %ebp
  801def:	89 e5                	mov    %esp,%ebp
  801df1:	83 ec 18             	sub    $0x18,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801df4:	e8 ed fd ff ff       	call   801be6 <InitializeUHeap>
	if (size == 0) return NULL ;
  801df9:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801dfd:	75 07                	jne    801e06 <malloc+0x18>
  801dff:	b8 00 00 00 00       	mov    $0x0,%eax
  801e04:	eb 67                	jmp    801e6d <malloc+0x7f>

	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] malloc
	// your code is here, remove the panic and write your code
	//panic("malloc() is not implemented yet...!!");

	size = ROUNDUP(size, PAGE_SIZE);
  801e06:	c7 45 f4 00 10 00 00 	movl   $0x1000,-0xc(%ebp)
  801e0d:	8b 55 08             	mov    0x8(%ebp),%edx
  801e10:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e13:	01 d0                	add    %edx,%eax
  801e15:	48                   	dec    %eax
  801e16:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801e19:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801e1c:	ba 00 00 00 00       	mov    $0x0,%edx
  801e21:	f7 75 f4             	divl   -0xc(%ebp)
  801e24:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801e27:	29 d0                	sub    %edx,%eax
  801e29:	89 45 08             	mov    %eax,0x8(%ebp)
	if(sys_isUHeapPlacementStrategyFIRSTFIT())
  801e2c:	e8 1a 08 00 00       	call   80264b <sys_isUHeapPlacementStrategyFIRSTFIT>
  801e31:	85 c0                	test   %eax,%eax
  801e33:	74 33                	je     801e68 <malloc+0x7a>
	{
		struct MemBlock * myBlock = alloc_block_FF(size);
  801e35:	83 ec 0c             	sub    $0xc,%esp
  801e38:	ff 75 08             	pushl  0x8(%ebp)
  801e3b:	e8 0c 0e 00 00       	call   802c4c <alloc_block_FF>
  801e40:	83 c4 10             	add    $0x10,%esp
  801e43:	89 45 ec             	mov    %eax,-0x14(%ebp)
		if(myBlock != NULL)
  801e46:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  801e4a:	74 1c                	je     801e68 <malloc+0x7a>
		{
			insert_sorted_allocList(myBlock);
  801e4c:	83 ec 0c             	sub    $0xc,%esp
  801e4f:	ff 75 ec             	pushl  -0x14(%ebp)
  801e52:	e8 07 0c 00 00       	call   802a5e <insert_sorted_allocList>
  801e57:	83 c4 10             	add    $0x10,%esp
			uint32 ptr = myBlock->sva;
  801e5a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801e5d:	8b 40 08             	mov    0x8(%eax),%eax
  801e60:	89 45 e8             	mov    %eax,-0x18(%ebp)
			return (void *)ptr;
  801e63:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801e66:	eb 05                	jmp    801e6d <malloc+0x7f>
		}
	}
	return NULL;
  801e68:	b8 00 00 00 00       	mov    $0x0,%eax
	//		to the required allocation size (space should be on 4 KB BOUNDARY)
	//	2) if no suitable space found, return NULL
	// 	3) Return pointer containing the virtual address of allocated space,
	//
	//Use sys_isUHeapPlacementStrategyFIRSTFIT()... to check the current strategy
}
  801e6d:	c9                   	leave  
  801e6e:	c3                   	ret    

00801e6f <free>:
//	We can use sys_free_user_mem(uint32 virtual_address, uint32 size); which
//		switches to the kernel mode, calls free_user_mem() in
//		"kern/mem/chunk_operations.c", then switch back to the user mode here
//	the free_user_mem function is empty, make sure to implement it.
void free(void* virtual_address)
{
  801e6f:	55                   	push   %ebp
  801e70:	89 e5                	mov    %esp,%ebp
  801e72:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] free
	// your code is here, remove the panic and write your code
	//panic("free() is not implemented yet...!!");

	uint32 virtualAddress = (uint32 )(virtual_address);
  801e75:	8b 45 08             	mov    0x8(%ebp),%eax
  801e78:	89 45 f4             	mov    %eax,-0xc(%ebp)
//	virtualAddress = ROUNDDOWN(virtualAddress, PAGE_SIZE);
	struct MemBlock * myBlock = find_block(&AllocMemBlocksList, virtualAddress);
  801e7b:	83 ec 08             	sub    $0x8,%esp
  801e7e:	ff 75 f4             	pushl  -0xc(%ebp)
  801e81:	68 40 50 80 00       	push   $0x805040
  801e86:	e8 5b 0b 00 00       	call   8029e6 <find_block>
  801e8b:	83 c4 10             	add    $0x10,%esp
  801e8e:	89 45 f0             	mov    %eax,-0x10(%ebp)
//	cprintf ("ptr sva at free user side = %x \n", myBlock->sva);
	sys_free_user_mem(virtualAddress, myBlock->size);
  801e91:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801e94:	8b 40 0c             	mov    0xc(%eax),%eax
  801e97:	83 ec 08             	sub    $0x8,%esp
  801e9a:	50                   	push   %eax
  801e9b:	ff 75 f4             	pushl  -0xc(%ebp)
  801e9e:	e8 a2 03 00 00       	call   802245 <sys_free_user_mem>
  801ea3:	83 c4 10             	add    $0x10,%esp
	LIST_REMOVE(&AllocMemBlocksList, myBlock);
  801ea6:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801eaa:	75 14                	jne    801ec0 <free+0x51>
  801eac:	83 ec 04             	sub    $0x4,%esp
  801eaf:	68 09 42 80 00       	push   $0x804209
  801eb4:	6a 76                	push   $0x76
  801eb6:	68 27 42 80 00       	push   $0x804227
  801ebb:	e8 e2 ea ff ff       	call   8009a2 <_panic>
  801ec0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801ec3:	8b 00                	mov    (%eax),%eax
  801ec5:	85 c0                	test   %eax,%eax
  801ec7:	74 10                	je     801ed9 <free+0x6a>
  801ec9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801ecc:	8b 00                	mov    (%eax),%eax
  801ece:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801ed1:	8b 52 04             	mov    0x4(%edx),%edx
  801ed4:	89 50 04             	mov    %edx,0x4(%eax)
  801ed7:	eb 0b                	jmp    801ee4 <free+0x75>
  801ed9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801edc:	8b 40 04             	mov    0x4(%eax),%eax
  801edf:	a3 44 50 80 00       	mov    %eax,0x805044
  801ee4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801ee7:	8b 40 04             	mov    0x4(%eax),%eax
  801eea:	85 c0                	test   %eax,%eax
  801eec:	74 0f                	je     801efd <free+0x8e>
  801eee:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801ef1:	8b 40 04             	mov    0x4(%eax),%eax
  801ef4:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801ef7:	8b 12                	mov    (%edx),%edx
  801ef9:	89 10                	mov    %edx,(%eax)
  801efb:	eb 0a                	jmp    801f07 <free+0x98>
  801efd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801f00:	8b 00                	mov    (%eax),%eax
  801f02:	a3 40 50 80 00       	mov    %eax,0x805040
  801f07:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801f0a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  801f10:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801f13:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  801f1a:	a1 4c 50 80 00       	mov    0x80504c,%eax
  801f1f:	48                   	dec    %eax
  801f20:	a3 4c 50 80 00       	mov    %eax,0x80504c
	insert_sorted_with_merge_freeList(myBlock);
  801f25:	83 ec 0c             	sub    $0xc,%esp
  801f28:	ff 75 f0             	pushl  -0x10(%ebp)
  801f2b:	e8 0b 14 00 00       	call   80333b <insert_sorted_with_merge_freeList>
  801f30:	83 c4 10             	add    $0x10,%esp

	//you should get the size of the given allocation using its address
	//you need to call sys_free_user_mem()
	//refer to the project presentation and documentation for details
}
  801f33:	90                   	nop
  801f34:	c9                   	leave  
  801f35:	c3                   	ret    

00801f36 <smalloc>:

//=================================
// [4] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
  801f36:	55                   	push   %ebp
  801f37:	89 e5                	mov    %esp,%ebp
  801f39:	83 ec 28             	sub    $0x28,%esp
  801f3c:	8b 45 10             	mov    0x10(%ebp),%eax
  801f3f:	88 45 e4             	mov    %al,-0x1c(%ebp)
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801f42:	e8 9f fc ff ff       	call   801be6 <InitializeUHeap>
	if (size == 0) return NULL ;
  801f47:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801f4b:	75 0a                	jne    801f57 <smalloc+0x21>
  801f4d:	b8 00 00 00 00       	mov    $0x0,%eax
  801f52:	e9 8d 00 00 00       	jmp    801fe4 <smalloc+0xae>

	//This function should find the space of the required range
	// * ON 4KB BOUNDARY **** //
	//Use sys_isUHeapPlacementStrategyFIRSTFIT() to check the current strategy

	size = ROUNDUP(size, PAGE_SIZE);
  801f57:	c7 45 f4 00 10 00 00 	movl   $0x1000,-0xc(%ebp)
  801f5e:	8b 55 0c             	mov    0xc(%ebp),%edx
  801f61:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f64:	01 d0                	add    %edx,%eax
  801f66:	48                   	dec    %eax
  801f67:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801f6a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801f6d:	ba 00 00 00 00       	mov    $0x0,%edx
  801f72:	f7 75 f4             	divl   -0xc(%ebp)
  801f75:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801f78:	29 d0                	sub    %edx,%eax
  801f7a:	89 45 0c             	mov    %eax,0xc(%ebp)
		if(sys_isUHeapPlacementStrategyFIRSTFIT())
  801f7d:	e8 c9 06 00 00       	call   80264b <sys_isUHeapPlacementStrategyFIRSTFIT>
  801f82:	85 c0                	test   %eax,%eax
  801f84:	74 59                	je     801fdf <smalloc+0xa9>
		{
			struct MemBlock * v1=NULL;
  801f86:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
			v1= alloc_block_FF(size);
  801f8d:	83 ec 0c             	sub    $0xc,%esp
  801f90:	ff 75 0c             	pushl  0xc(%ebp)
  801f93:	e8 b4 0c 00 00       	call   802c4c <alloc_block_FF>
  801f98:	83 c4 10             	add    $0x10,%esp
  801f9b:	89 45 ec             	mov    %eax,-0x14(%ebp)
			if(v1==NULL)
  801f9e:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  801fa2:	75 07                	jne    801fab <smalloc+0x75>
			{
				return NULL;
  801fa4:	b8 00 00 00 00       	mov    $0x0,%eax
  801fa9:	eb 39                	jmp    801fe4 <smalloc+0xae>
			}
			else
			{
				int ret=sys_createSharedObject(sharedVarName,  size,  isWritable,(void*)v1->sva);
  801fab:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801fae:	8b 40 08             	mov    0x8(%eax),%eax
  801fb1:	89 c2                	mov    %eax,%edx
  801fb3:	0f b6 45 e4          	movzbl -0x1c(%ebp),%eax
  801fb7:	52                   	push   %edx
  801fb8:	50                   	push   %eax
  801fb9:	ff 75 0c             	pushl  0xc(%ebp)
  801fbc:	ff 75 08             	pushl  0x8(%ebp)
  801fbf:	e8 0c 04 00 00       	call   8023d0 <sys_createSharedObject>
  801fc4:	83 c4 10             	add    $0x10,%esp
  801fc7:	89 45 e8             	mov    %eax,-0x18(%ebp)
				if(ret>=0)
  801fca:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  801fce:	78 08                	js     801fd8 <smalloc+0xa2>
				{
					return (void*)v1->sva;
  801fd0:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801fd3:	8b 40 08             	mov    0x8(%eax),%eax
  801fd6:	eb 0c                	jmp    801fe4 <smalloc+0xae>
				}
				else
				{
					return NULL;
  801fd8:	b8 00 00 00 00       	mov    $0x0,%eax
  801fdd:	eb 05                	jmp    801fe4 <smalloc+0xae>
				}
			}

		}
		return NULL;
  801fdf:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801fe4:	c9                   	leave  
  801fe5:	c3                   	ret    

00801fe6 <sget>:

//========================================
// [5] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  801fe6:	55                   	push   %ebp
  801fe7:	89 e5                	mov    %esp,%ebp
  801fe9:	83 ec 18             	sub    $0x18,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801fec:	e8 f5 fb ff ff       	call   801be6 <InitializeUHeap>

	//This function should find the space for sharing the variable
	// *** ON 4KB BOUNDARY ******** //

	//Use sys_isUHeapPlacementStrategyFIRSTFIT() to check the current strategy
	int ret=sys_getSizeOfSharedObject(ownerEnvID,sharedVarName);
  801ff1:	83 ec 08             	sub    $0x8,%esp
  801ff4:	ff 75 0c             	pushl  0xc(%ebp)
  801ff7:	ff 75 08             	pushl  0x8(%ebp)
  801ffa:	e8 fb 03 00 00       	call   8023fa <sys_getSizeOfSharedObject>
  801fff:	83 c4 10             	add    $0x10,%esp
  802002:	89 45 f4             	mov    %eax,-0xc(%ebp)
	if(ret==0)
  802005:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802009:	75 07                	jne    802012 <sget+0x2c>
	{
		return NULL;
  80200b:	b8 00 00 00 00       	mov    $0x0,%eax
  802010:	eb 64                	jmp    802076 <sget+0x90>
	}
	if(sys_isUHeapPlacementStrategyFIRSTFIT())
  802012:	e8 34 06 00 00       	call   80264b <sys_isUHeapPlacementStrategyFIRSTFIT>
  802017:	85 c0                	test   %eax,%eax
  802019:	74 56                	je     802071 <sget+0x8b>
	{
		struct MemBlock * v1=NULL;
  80201b:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
		v1= alloc_block_FF(ret);
  802022:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802025:	83 ec 0c             	sub    $0xc,%esp
  802028:	50                   	push   %eax
  802029:	e8 1e 0c 00 00       	call   802c4c <alloc_block_FF>
  80202e:	83 c4 10             	add    $0x10,%esp
  802031:	89 45 f0             	mov    %eax,-0x10(%ebp)
		if(v1==NULL)
  802034:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802038:	75 07                	jne    802041 <sget+0x5b>
		{
		return NULL;
  80203a:	b8 00 00 00 00       	mov    $0x0,%eax
  80203f:	eb 35                	jmp    802076 <sget+0x90>
	    }
		else
		{
			int ret1=sys_getSharedObject(ownerEnvID,sharedVarName,(void*)v1->sva);
  802041:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802044:	8b 40 08             	mov    0x8(%eax),%eax
  802047:	83 ec 04             	sub    $0x4,%esp
  80204a:	50                   	push   %eax
  80204b:	ff 75 0c             	pushl  0xc(%ebp)
  80204e:	ff 75 08             	pushl  0x8(%ebp)
  802051:	e8 c1 03 00 00       	call   802417 <sys_getSharedObject>
  802056:	83 c4 10             	add    $0x10,%esp
  802059:	89 45 ec             	mov    %eax,-0x14(%ebp)
			if(ret1>=0)
  80205c:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802060:	78 08                	js     80206a <sget+0x84>
			{
				return (void*)v1->sva;
  802062:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802065:	8b 40 08             	mov    0x8(%eax),%eax
  802068:	eb 0c                	jmp    802076 <sget+0x90>
			}
			else
			{
				return NULL;
  80206a:	b8 00 00 00 00       	mov    $0x0,%eax
  80206f:	eb 05                	jmp    802076 <sget+0x90>
			}
		}
	}
  return NULL;
  802071:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802076:	c9                   	leave  
  802077:	c3                   	ret    

00802078 <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  802078:	55                   	push   %ebp
  802079:	89 e5                	mov    %esp,%ebp
  80207b:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  80207e:	e8 63 fb ff ff       	call   801be6 <InitializeUHeap>
	//==============================================================
	// [USER HEAP - USER SIDE] realloc
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  802083:	83 ec 04             	sub    $0x4,%esp
  802086:	68 58 42 80 00       	push   $0x804258
  80208b:	68 0e 01 00 00       	push   $0x10e
  802090:	68 27 42 80 00       	push   $0x804227
  802095:	e8 08 e9 ff ff       	call   8009a2 <_panic>

0080209a <sfree>:
//	use sys_freeSharedObject(...); which switches to the kernel mode,
//	calls freeSharedObject(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the freeSharedObject() function is empty, make sure to implement it.

void sfree(void* virtual_address)
{
  80209a:	55                   	push   %ebp
  80209b:	89 e5                	mov    %esp,%ebp
  80209d:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS3 - BONUS] [SHARING - USER SIDE] sfree()

	// Write your code here, remove the panic and write your code
	panic("sfree() is not implemented yet...!!");
  8020a0:	83 ec 04             	sub    $0x4,%esp
  8020a3:	68 80 42 80 00       	push   $0x804280
  8020a8:	68 22 01 00 00       	push   $0x122
  8020ad:	68 27 42 80 00       	push   $0x804227
  8020b2:	e8 eb e8 ff ff       	call   8009a2 <_panic>

008020b7 <expand>:

//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//
void expand(uint32 newSize)
{
  8020b7:	55                   	push   %ebp
  8020b8:	89 e5                	mov    %esp,%ebp
  8020ba:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  8020bd:	83 ec 04             	sub    $0x4,%esp
  8020c0:	68 a4 42 80 00       	push   $0x8042a4
  8020c5:	68 2d 01 00 00       	push   $0x12d
  8020ca:	68 27 42 80 00       	push   $0x804227
  8020cf:	e8 ce e8 ff ff       	call   8009a2 <_panic>

008020d4 <shrink>:

}
void shrink(uint32 newSize)
{
  8020d4:	55                   	push   %ebp
  8020d5:	89 e5                	mov    %esp,%ebp
  8020d7:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  8020da:	83 ec 04             	sub    $0x4,%esp
  8020dd:	68 a4 42 80 00       	push   $0x8042a4
  8020e2:	68 32 01 00 00       	push   $0x132
  8020e7:	68 27 42 80 00       	push   $0x804227
  8020ec:	e8 b1 e8 ff ff       	call   8009a2 <_panic>

008020f1 <freeHeap>:

}
void freeHeap(void* virtual_address)
{
  8020f1:	55                   	push   %ebp
  8020f2:	89 e5                	mov    %esp,%ebp
  8020f4:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  8020f7:	83 ec 04             	sub    $0x4,%esp
  8020fa:	68 a4 42 80 00       	push   $0x8042a4
  8020ff:	68 37 01 00 00       	push   $0x137
  802104:	68 27 42 80 00       	push   $0x804227
  802109:	e8 94 e8 ff ff       	call   8009a2 <_panic>

0080210e <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  80210e:	55                   	push   %ebp
  80210f:	89 e5                	mov    %esp,%ebp
  802111:	57                   	push   %edi
  802112:	56                   	push   %esi
  802113:	53                   	push   %ebx
  802114:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  802117:	8b 45 08             	mov    0x8(%ebp),%eax
  80211a:	8b 55 0c             	mov    0xc(%ebp),%edx
  80211d:	8b 4d 10             	mov    0x10(%ebp),%ecx
  802120:	8b 5d 14             	mov    0x14(%ebp),%ebx
  802123:	8b 7d 18             	mov    0x18(%ebp),%edi
  802126:	8b 75 1c             	mov    0x1c(%ebp),%esi
  802129:	cd 30                	int    $0x30
  80212b:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  80212e:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  802131:	83 c4 10             	add    $0x10,%esp
  802134:	5b                   	pop    %ebx
  802135:	5e                   	pop    %esi
  802136:	5f                   	pop    %edi
  802137:	5d                   	pop    %ebp
  802138:	c3                   	ret    

00802139 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  802139:	55                   	push   %ebp
  80213a:	89 e5                	mov    %esp,%ebp
  80213c:	83 ec 04             	sub    $0x4,%esp
  80213f:	8b 45 10             	mov    0x10(%ebp),%eax
  802142:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  802145:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  802149:	8b 45 08             	mov    0x8(%ebp),%eax
  80214c:	6a 00                	push   $0x0
  80214e:	6a 00                	push   $0x0
  802150:	52                   	push   %edx
  802151:	ff 75 0c             	pushl  0xc(%ebp)
  802154:	50                   	push   %eax
  802155:	6a 00                	push   $0x0
  802157:	e8 b2 ff ff ff       	call   80210e <syscall>
  80215c:	83 c4 18             	add    $0x18,%esp
}
  80215f:	90                   	nop
  802160:	c9                   	leave  
  802161:	c3                   	ret    

00802162 <sys_cgetc>:

int
sys_cgetc(void)
{
  802162:	55                   	push   %ebp
  802163:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  802165:	6a 00                	push   $0x0
  802167:	6a 00                	push   $0x0
  802169:	6a 00                	push   $0x0
  80216b:	6a 00                	push   $0x0
  80216d:	6a 00                	push   $0x0
  80216f:	6a 01                	push   $0x1
  802171:	e8 98 ff ff ff       	call   80210e <syscall>
  802176:	83 c4 18             	add    $0x18,%esp
}
  802179:	c9                   	leave  
  80217a:	c3                   	ret    

0080217b <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  80217b:	55                   	push   %ebp
  80217c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  80217e:	8b 55 0c             	mov    0xc(%ebp),%edx
  802181:	8b 45 08             	mov    0x8(%ebp),%eax
  802184:	6a 00                	push   $0x0
  802186:	6a 00                	push   $0x0
  802188:	6a 00                	push   $0x0
  80218a:	52                   	push   %edx
  80218b:	50                   	push   %eax
  80218c:	6a 05                	push   $0x5
  80218e:	e8 7b ff ff ff       	call   80210e <syscall>
  802193:	83 c4 18             	add    $0x18,%esp
}
  802196:	c9                   	leave  
  802197:	c3                   	ret    

00802198 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  802198:	55                   	push   %ebp
  802199:	89 e5                	mov    %esp,%ebp
  80219b:	56                   	push   %esi
  80219c:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  80219d:	8b 75 18             	mov    0x18(%ebp),%esi
  8021a0:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8021a3:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8021a6:	8b 55 0c             	mov    0xc(%ebp),%edx
  8021a9:	8b 45 08             	mov    0x8(%ebp),%eax
  8021ac:	56                   	push   %esi
  8021ad:	53                   	push   %ebx
  8021ae:	51                   	push   %ecx
  8021af:	52                   	push   %edx
  8021b0:	50                   	push   %eax
  8021b1:	6a 06                	push   $0x6
  8021b3:	e8 56 ff ff ff       	call   80210e <syscall>
  8021b8:	83 c4 18             	add    $0x18,%esp
}
  8021bb:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8021be:	5b                   	pop    %ebx
  8021bf:	5e                   	pop    %esi
  8021c0:	5d                   	pop    %ebp
  8021c1:	c3                   	ret    

008021c2 <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  8021c2:	55                   	push   %ebp
  8021c3:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  8021c5:	8b 55 0c             	mov    0xc(%ebp),%edx
  8021c8:	8b 45 08             	mov    0x8(%ebp),%eax
  8021cb:	6a 00                	push   $0x0
  8021cd:	6a 00                	push   $0x0
  8021cf:	6a 00                	push   $0x0
  8021d1:	52                   	push   %edx
  8021d2:	50                   	push   %eax
  8021d3:	6a 07                	push   $0x7
  8021d5:	e8 34 ff ff ff       	call   80210e <syscall>
  8021da:	83 c4 18             	add    $0x18,%esp
}
  8021dd:	c9                   	leave  
  8021de:	c3                   	ret    

008021df <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  8021df:	55                   	push   %ebp
  8021e0:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  8021e2:	6a 00                	push   $0x0
  8021e4:	6a 00                	push   $0x0
  8021e6:	6a 00                	push   $0x0
  8021e8:	ff 75 0c             	pushl  0xc(%ebp)
  8021eb:	ff 75 08             	pushl  0x8(%ebp)
  8021ee:	6a 08                	push   $0x8
  8021f0:	e8 19 ff ff ff       	call   80210e <syscall>
  8021f5:	83 c4 18             	add    $0x18,%esp
}
  8021f8:	c9                   	leave  
  8021f9:	c3                   	ret    

008021fa <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  8021fa:	55                   	push   %ebp
  8021fb:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  8021fd:	6a 00                	push   $0x0
  8021ff:	6a 00                	push   $0x0
  802201:	6a 00                	push   $0x0
  802203:	6a 00                	push   $0x0
  802205:	6a 00                	push   $0x0
  802207:	6a 09                	push   $0x9
  802209:	e8 00 ff ff ff       	call   80210e <syscall>
  80220e:	83 c4 18             	add    $0x18,%esp
}
  802211:	c9                   	leave  
  802212:	c3                   	ret    

00802213 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  802213:	55                   	push   %ebp
  802214:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  802216:	6a 00                	push   $0x0
  802218:	6a 00                	push   $0x0
  80221a:	6a 00                	push   $0x0
  80221c:	6a 00                	push   $0x0
  80221e:	6a 00                	push   $0x0
  802220:	6a 0a                	push   $0xa
  802222:	e8 e7 fe ff ff       	call   80210e <syscall>
  802227:	83 c4 18             	add    $0x18,%esp
}
  80222a:	c9                   	leave  
  80222b:	c3                   	ret    

0080222c <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  80222c:	55                   	push   %ebp
  80222d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  80222f:	6a 00                	push   $0x0
  802231:	6a 00                	push   $0x0
  802233:	6a 00                	push   $0x0
  802235:	6a 00                	push   $0x0
  802237:	6a 00                	push   $0x0
  802239:	6a 0b                	push   $0xb
  80223b:	e8 ce fe ff ff       	call   80210e <syscall>
  802240:	83 c4 18             	add    $0x18,%esp
}
  802243:	c9                   	leave  
  802244:	c3                   	ret    

00802245 <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  802245:	55                   	push   %ebp
  802246:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  802248:	6a 00                	push   $0x0
  80224a:	6a 00                	push   $0x0
  80224c:	6a 00                	push   $0x0
  80224e:	ff 75 0c             	pushl  0xc(%ebp)
  802251:	ff 75 08             	pushl  0x8(%ebp)
  802254:	6a 0f                	push   $0xf
  802256:	e8 b3 fe ff ff       	call   80210e <syscall>
  80225b:	83 c4 18             	add    $0x18,%esp
	return;
  80225e:	90                   	nop
}
  80225f:	c9                   	leave  
  802260:	c3                   	ret    

00802261 <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  802261:	55                   	push   %ebp
  802262:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  802264:	6a 00                	push   $0x0
  802266:	6a 00                	push   $0x0
  802268:	6a 00                	push   $0x0
  80226a:	ff 75 0c             	pushl  0xc(%ebp)
  80226d:	ff 75 08             	pushl  0x8(%ebp)
  802270:	6a 10                	push   $0x10
  802272:	e8 97 fe ff ff       	call   80210e <syscall>
  802277:	83 c4 18             	add    $0x18,%esp
	return ;
  80227a:	90                   	nop
}
  80227b:	c9                   	leave  
  80227c:	c3                   	ret    

0080227d <sys_allocate_chunk>:

void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  80227d:	55                   	push   %ebp
  80227e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  802280:	6a 00                	push   $0x0
  802282:	6a 00                	push   $0x0
  802284:	ff 75 10             	pushl  0x10(%ebp)
  802287:	ff 75 0c             	pushl  0xc(%ebp)
  80228a:	ff 75 08             	pushl  0x8(%ebp)
  80228d:	6a 11                	push   $0x11
  80228f:	e8 7a fe ff ff       	call   80210e <syscall>
  802294:	83 c4 18             	add    $0x18,%esp
	return ;
  802297:	90                   	nop
}
  802298:	c9                   	leave  
  802299:	c3                   	ret    

0080229a <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  80229a:	55                   	push   %ebp
  80229b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  80229d:	6a 00                	push   $0x0
  80229f:	6a 00                	push   $0x0
  8022a1:	6a 00                	push   $0x0
  8022a3:	6a 00                	push   $0x0
  8022a5:	6a 00                	push   $0x0
  8022a7:	6a 0c                	push   $0xc
  8022a9:	e8 60 fe ff ff       	call   80210e <syscall>
  8022ae:	83 c4 18             	add    $0x18,%esp
}
  8022b1:	c9                   	leave  
  8022b2:	c3                   	ret    

008022b3 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  8022b3:	55                   	push   %ebp
  8022b4:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  8022b6:	6a 00                	push   $0x0
  8022b8:	6a 00                	push   $0x0
  8022ba:	6a 00                	push   $0x0
  8022bc:	6a 00                	push   $0x0
  8022be:	ff 75 08             	pushl  0x8(%ebp)
  8022c1:	6a 0d                	push   $0xd
  8022c3:	e8 46 fe ff ff       	call   80210e <syscall>
  8022c8:	83 c4 18             	add    $0x18,%esp
}
  8022cb:	c9                   	leave  
  8022cc:	c3                   	ret    

008022cd <sys_scarce_memory>:

void sys_scarce_memory()
{
  8022cd:	55                   	push   %ebp
  8022ce:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  8022d0:	6a 00                	push   $0x0
  8022d2:	6a 00                	push   $0x0
  8022d4:	6a 00                	push   $0x0
  8022d6:	6a 00                	push   $0x0
  8022d8:	6a 00                	push   $0x0
  8022da:	6a 0e                	push   $0xe
  8022dc:	e8 2d fe ff ff       	call   80210e <syscall>
  8022e1:	83 c4 18             	add    $0x18,%esp
}
  8022e4:	90                   	nop
  8022e5:	c9                   	leave  
  8022e6:	c3                   	ret    

008022e7 <sys_disable_interrupt>:

//NEW !! 2012...
void
sys_disable_interrupt()
{
  8022e7:	55                   	push   %ebp
  8022e8:	89 e5                	mov    %esp,%ebp
	syscall(SYS_disableINTR,0, 0, 0, 0, 0);
  8022ea:	6a 00                	push   $0x0
  8022ec:	6a 00                	push   $0x0
  8022ee:	6a 00                	push   $0x0
  8022f0:	6a 00                	push   $0x0
  8022f2:	6a 00                	push   $0x0
  8022f4:	6a 13                	push   $0x13
  8022f6:	e8 13 fe ff ff       	call   80210e <syscall>
  8022fb:	83 c4 18             	add    $0x18,%esp
}
  8022fe:	90                   	nop
  8022ff:	c9                   	leave  
  802300:	c3                   	ret    

00802301 <sys_enable_interrupt>:


void
sys_enable_interrupt()
{
  802301:	55                   	push   %ebp
  802302:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enableINTR,0, 0, 0, 0, 0);
  802304:	6a 00                	push   $0x0
  802306:	6a 00                	push   $0x0
  802308:	6a 00                	push   $0x0
  80230a:	6a 00                	push   $0x0
  80230c:	6a 00                	push   $0x0
  80230e:	6a 14                	push   $0x14
  802310:	e8 f9 fd ff ff       	call   80210e <syscall>
  802315:	83 c4 18             	add    $0x18,%esp
}
  802318:	90                   	nop
  802319:	c9                   	leave  
  80231a:	c3                   	ret    

0080231b <sys_cputc>:


void
sys_cputc(const char c)
{
  80231b:	55                   	push   %ebp
  80231c:	89 e5                	mov    %esp,%ebp
  80231e:	83 ec 04             	sub    $0x4,%esp
  802321:	8b 45 08             	mov    0x8(%ebp),%eax
  802324:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  802327:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  80232b:	6a 00                	push   $0x0
  80232d:	6a 00                	push   $0x0
  80232f:	6a 00                	push   $0x0
  802331:	6a 00                	push   $0x0
  802333:	50                   	push   %eax
  802334:	6a 15                	push   $0x15
  802336:	e8 d3 fd ff ff       	call   80210e <syscall>
  80233b:	83 c4 18             	add    $0x18,%esp
}
  80233e:	90                   	nop
  80233f:	c9                   	leave  
  802340:	c3                   	ret    

00802341 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  802341:	55                   	push   %ebp
  802342:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  802344:	6a 00                	push   $0x0
  802346:	6a 00                	push   $0x0
  802348:	6a 00                	push   $0x0
  80234a:	6a 00                	push   $0x0
  80234c:	6a 00                	push   $0x0
  80234e:	6a 16                	push   $0x16
  802350:	e8 b9 fd ff ff       	call   80210e <syscall>
  802355:	83 c4 18             	add    $0x18,%esp
}
  802358:	90                   	nop
  802359:	c9                   	leave  
  80235a:	c3                   	ret    

0080235b <sys_createSemaphore>:

int
sys_createSemaphore(char* semaphoreName, uint32 initialValue)
{
  80235b:	55                   	push   %ebp
  80235c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_semaphore,(uint32)semaphoreName, (uint32)initialValue, 0, 0, 0);
  80235e:	8b 45 08             	mov    0x8(%ebp),%eax
  802361:	6a 00                	push   $0x0
  802363:	6a 00                	push   $0x0
  802365:	6a 00                	push   $0x0
  802367:	ff 75 0c             	pushl  0xc(%ebp)
  80236a:	50                   	push   %eax
  80236b:	6a 17                	push   $0x17
  80236d:	e8 9c fd ff ff       	call   80210e <syscall>
  802372:	83 c4 18             	add    $0x18,%esp
}
  802375:	c9                   	leave  
  802376:	c3                   	ret    

00802377 <sys_getSemaphoreValue>:

int
sys_getSemaphoreValue(int32 ownerEnvID, char* semaphoreName)
{
  802377:	55                   	push   %ebp
  802378:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_semaphore_value,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  80237a:	8b 55 0c             	mov    0xc(%ebp),%edx
  80237d:	8b 45 08             	mov    0x8(%ebp),%eax
  802380:	6a 00                	push   $0x0
  802382:	6a 00                	push   $0x0
  802384:	6a 00                	push   $0x0
  802386:	52                   	push   %edx
  802387:	50                   	push   %eax
  802388:	6a 1a                	push   $0x1a
  80238a:	e8 7f fd ff ff       	call   80210e <syscall>
  80238f:	83 c4 18             	add    $0x18,%esp
}
  802392:	c9                   	leave  
  802393:	c3                   	ret    

00802394 <sys_waitSemaphore>:

void
sys_waitSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  802394:	55                   	push   %ebp
  802395:	89 e5                	mov    %esp,%ebp
	syscall(SYS_wait_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  802397:	8b 55 0c             	mov    0xc(%ebp),%edx
  80239a:	8b 45 08             	mov    0x8(%ebp),%eax
  80239d:	6a 00                	push   $0x0
  80239f:	6a 00                	push   $0x0
  8023a1:	6a 00                	push   $0x0
  8023a3:	52                   	push   %edx
  8023a4:	50                   	push   %eax
  8023a5:	6a 18                	push   $0x18
  8023a7:	e8 62 fd ff ff       	call   80210e <syscall>
  8023ac:	83 c4 18             	add    $0x18,%esp
}
  8023af:	90                   	nop
  8023b0:	c9                   	leave  
  8023b1:	c3                   	ret    

008023b2 <sys_signalSemaphore>:

void
sys_signalSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  8023b2:	55                   	push   %ebp
  8023b3:	89 e5                	mov    %esp,%ebp
	syscall(SYS_signal_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  8023b5:	8b 55 0c             	mov    0xc(%ebp),%edx
  8023b8:	8b 45 08             	mov    0x8(%ebp),%eax
  8023bb:	6a 00                	push   $0x0
  8023bd:	6a 00                	push   $0x0
  8023bf:	6a 00                	push   $0x0
  8023c1:	52                   	push   %edx
  8023c2:	50                   	push   %eax
  8023c3:	6a 19                	push   $0x19
  8023c5:	e8 44 fd ff ff       	call   80210e <syscall>
  8023ca:	83 c4 18             	add    $0x18,%esp
}
  8023cd:	90                   	nop
  8023ce:	c9                   	leave  
  8023cf:	c3                   	ret    

008023d0 <sys_createSharedObject>:

int
sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  8023d0:	55                   	push   %ebp
  8023d1:	89 e5                	mov    %esp,%ebp
  8023d3:	83 ec 04             	sub    $0x4,%esp
  8023d6:	8b 45 10             	mov    0x10(%ebp),%eax
  8023d9:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  8023dc:	8b 4d 14             	mov    0x14(%ebp),%ecx
  8023df:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  8023e3:	8b 45 08             	mov    0x8(%ebp),%eax
  8023e6:	6a 00                	push   $0x0
  8023e8:	51                   	push   %ecx
  8023e9:	52                   	push   %edx
  8023ea:	ff 75 0c             	pushl  0xc(%ebp)
  8023ed:	50                   	push   %eax
  8023ee:	6a 1b                	push   $0x1b
  8023f0:	e8 19 fd ff ff       	call   80210e <syscall>
  8023f5:	83 c4 18             	add    $0x18,%esp
}
  8023f8:	c9                   	leave  
  8023f9:	c3                   	ret    

008023fa <sys_getSizeOfSharedObject>:

//2017:
int
sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  8023fa:	55                   	push   %ebp
  8023fb:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  8023fd:	8b 55 0c             	mov    0xc(%ebp),%edx
  802400:	8b 45 08             	mov    0x8(%ebp),%eax
  802403:	6a 00                	push   $0x0
  802405:	6a 00                	push   $0x0
  802407:	6a 00                	push   $0x0
  802409:	52                   	push   %edx
  80240a:	50                   	push   %eax
  80240b:	6a 1c                	push   $0x1c
  80240d:	e8 fc fc ff ff       	call   80210e <syscall>
  802412:	83 c4 18             	add    $0x18,%esp
}
  802415:	c9                   	leave  
  802416:	c3                   	ret    

00802417 <sys_getSharedObject>:
//==========

int
sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  802417:	55                   	push   %ebp
  802418:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  80241a:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80241d:	8b 55 0c             	mov    0xc(%ebp),%edx
  802420:	8b 45 08             	mov    0x8(%ebp),%eax
  802423:	6a 00                	push   $0x0
  802425:	6a 00                	push   $0x0
  802427:	51                   	push   %ecx
  802428:	52                   	push   %edx
  802429:	50                   	push   %eax
  80242a:	6a 1d                	push   $0x1d
  80242c:	e8 dd fc ff ff       	call   80210e <syscall>
  802431:	83 c4 18             	add    $0x18,%esp
}
  802434:	c9                   	leave  
  802435:	c3                   	ret    

00802436 <sys_freeSharedObject>:

int
sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  802436:	55                   	push   %ebp
  802437:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  802439:	8b 55 0c             	mov    0xc(%ebp),%edx
  80243c:	8b 45 08             	mov    0x8(%ebp),%eax
  80243f:	6a 00                	push   $0x0
  802441:	6a 00                	push   $0x0
  802443:	6a 00                	push   $0x0
  802445:	52                   	push   %edx
  802446:	50                   	push   %eax
  802447:	6a 1e                	push   $0x1e
  802449:	e8 c0 fc ff ff       	call   80210e <syscall>
  80244e:	83 c4 18             	add    $0x18,%esp
}
  802451:	c9                   	leave  
  802452:	c3                   	ret    

00802453 <sys_getMaxShares>:

uint32 	sys_getMaxShares()
{
  802453:	55                   	push   %ebp
  802454:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_max_shares,0, 0, 0, 0, 0);
  802456:	6a 00                	push   $0x0
  802458:	6a 00                	push   $0x0
  80245a:	6a 00                	push   $0x0
  80245c:	6a 00                	push   $0x0
  80245e:	6a 00                	push   $0x0
  802460:	6a 1f                	push   $0x1f
  802462:	e8 a7 fc ff ff       	call   80210e <syscall>
  802467:	83 c4 18             	add    $0x18,%esp
}
  80246a:	c9                   	leave  
  80246b:	c3                   	ret    

0080246c <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  80246c:	55                   	push   %ebp
  80246d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  80246f:	8b 45 08             	mov    0x8(%ebp),%eax
  802472:	6a 00                	push   $0x0
  802474:	ff 75 14             	pushl  0x14(%ebp)
  802477:	ff 75 10             	pushl  0x10(%ebp)
  80247a:	ff 75 0c             	pushl  0xc(%ebp)
  80247d:	50                   	push   %eax
  80247e:	6a 20                	push   $0x20
  802480:	e8 89 fc ff ff       	call   80210e <syscall>
  802485:	83 c4 18             	add    $0x18,%esp
}
  802488:	c9                   	leave  
  802489:	c3                   	ret    

0080248a <sys_run_env>:

void
sys_run_env(int32 envId)
{
  80248a:	55                   	push   %ebp
  80248b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  80248d:	8b 45 08             	mov    0x8(%ebp),%eax
  802490:	6a 00                	push   $0x0
  802492:	6a 00                	push   $0x0
  802494:	6a 00                	push   $0x0
  802496:	6a 00                	push   $0x0
  802498:	50                   	push   %eax
  802499:	6a 21                	push   $0x21
  80249b:	e8 6e fc ff ff       	call   80210e <syscall>
  8024a0:	83 c4 18             	add    $0x18,%esp
}
  8024a3:	90                   	nop
  8024a4:	c9                   	leave  
  8024a5:	c3                   	ret    

008024a6 <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  8024a6:	55                   	push   %ebp
  8024a7:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  8024a9:	8b 45 08             	mov    0x8(%ebp),%eax
  8024ac:	6a 00                	push   $0x0
  8024ae:	6a 00                	push   $0x0
  8024b0:	6a 00                	push   $0x0
  8024b2:	6a 00                	push   $0x0
  8024b4:	50                   	push   %eax
  8024b5:	6a 22                	push   $0x22
  8024b7:	e8 52 fc ff ff       	call   80210e <syscall>
  8024bc:	83 c4 18             	add    $0x18,%esp
}
  8024bf:	c9                   	leave  
  8024c0:	c3                   	ret    

008024c1 <sys_getenvid>:

int32 sys_getenvid(void)
{
  8024c1:	55                   	push   %ebp
  8024c2:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  8024c4:	6a 00                	push   $0x0
  8024c6:	6a 00                	push   $0x0
  8024c8:	6a 00                	push   $0x0
  8024ca:	6a 00                	push   $0x0
  8024cc:	6a 00                	push   $0x0
  8024ce:	6a 02                	push   $0x2
  8024d0:	e8 39 fc ff ff       	call   80210e <syscall>
  8024d5:	83 c4 18             	add    $0x18,%esp
}
  8024d8:	c9                   	leave  
  8024d9:	c3                   	ret    

008024da <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  8024da:	55                   	push   %ebp
  8024db:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  8024dd:	6a 00                	push   $0x0
  8024df:	6a 00                	push   $0x0
  8024e1:	6a 00                	push   $0x0
  8024e3:	6a 00                	push   $0x0
  8024e5:	6a 00                	push   $0x0
  8024e7:	6a 03                	push   $0x3
  8024e9:	e8 20 fc ff ff       	call   80210e <syscall>
  8024ee:	83 c4 18             	add    $0x18,%esp
}
  8024f1:	c9                   	leave  
  8024f2:	c3                   	ret    

008024f3 <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  8024f3:	55                   	push   %ebp
  8024f4:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  8024f6:	6a 00                	push   $0x0
  8024f8:	6a 00                	push   $0x0
  8024fa:	6a 00                	push   $0x0
  8024fc:	6a 00                	push   $0x0
  8024fe:	6a 00                	push   $0x0
  802500:	6a 04                	push   $0x4
  802502:	e8 07 fc ff ff       	call   80210e <syscall>
  802507:	83 c4 18             	add    $0x18,%esp
}
  80250a:	c9                   	leave  
  80250b:	c3                   	ret    

0080250c <sys_exit_env>:


void sys_exit_env(void)
{
  80250c:	55                   	push   %ebp
  80250d:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  80250f:	6a 00                	push   $0x0
  802511:	6a 00                	push   $0x0
  802513:	6a 00                	push   $0x0
  802515:	6a 00                	push   $0x0
  802517:	6a 00                	push   $0x0
  802519:	6a 23                	push   $0x23
  80251b:	e8 ee fb ff ff       	call   80210e <syscall>
  802520:	83 c4 18             	add    $0x18,%esp
}
  802523:	90                   	nop
  802524:	c9                   	leave  
  802525:	c3                   	ret    

00802526 <sys_get_virtual_time>:


struct uint64
sys_get_virtual_time()
{
  802526:	55                   	push   %ebp
  802527:	89 e5                	mov    %esp,%ebp
  802529:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  80252c:	8d 45 f8             	lea    -0x8(%ebp),%eax
  80252f:	8d 50 04             	lea    0x4(%eax),%edx
  802532:	8d 45 f8             	lea    -0x8(%ebp),%eax
  802535:	6a 00                	push   $0x0
  802537:	6a 00                	push   $0x0
  802539:	6a 00                	push   $0x0
  80253b:	52                   	push   %edx
  80253c:	50                   	push   %eax
  80253d:	6a 24                	push   $0x24
  80253f:	e8 ca fb ff ff       	call   80210e <syscall>
  802544:	83 c4 18             	add    $0x18,%esp
	return result;
  802547:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80254a:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80254d:	8b 55 fc             	mov    -0x4(%ebp),%edx
  802550:	89 01                	mov    %eax,(%ecx)
  802552:	89 51 04             	mov    %edx,0x4(%ecx)
}
  802555:	8b 45 08             	mov    0x8(%ebp),%eax
  802558:	c9                   	leave  
  802559:	c2 04 00             	ret    $0x4

0080255c <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  80255c:	55                   	push   %ebp
  80255d:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  80255f:	6a 00                	push   $0x0
  802561:	6a 00                	push   $0x0
  802563:	ff 75 10             	pushl  0x10(%ebp)
  802566:	ff 75 0c             	pushl  0xc(%ebp)
  802569:	ff 75 08             	pushl  0x8(%ebp)
  80256c:	6a 12                	push   $0x12
  80256e:	e8 9b fb ff ff       	call   80210e <syscall>
  802573:	83 c4 18             	add    $0x18,%esp
	return ;
  802576:	90                   	nop
}
  802577:	c9                   	leave  
  802578:	c3                   	ret    

00802579 <sys_rcr2>:
uint32 sys_rcr2()
{
  802579:	55                   	push   %ebp
  80257a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  80257c:	6a 00                	push   $0x0
  80257e:	6a 00                	push   $0x0
  802580:	6a 00                	push   $0x0
  802582:	6a 00                	push   $0x0
  802584:	6a 00                	push   $0x0
  802586:	6a 25                	push   $0x25
  802588:	e8 81 fb ff ff       	call   80210e <syscall>
  80258d:	83 c4 18             	add    $0x18,%esp
}
  802590:	c9                   	leave  
  802591:	c3                   	ret    

00802592 <sys_bypassPageFault>:
void sys_bypassPageFault(uint8 instrLength)
{
  802592:	55                   	push   %ebp
  802593:	89 e5                	mov    %esp,%ebp
  802595:	83 ec 04             	sub    $0x4,%esp
  802598:	8b 45 08             	mov    0x8(%ebp),%eax
  80259b:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  80259e:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  8025a2:	6a 00                	push   $0x0
  8025a4:	6a 00                	push   $0x0
  8025a6:	6a 00                	push   $0x0
  8025a8:	6a 00                	push   $0x0
  8025aa:	50                   	push   %eax
  8025ab:	6a 26                	push   $0x26
  8025ad:	e8 5c fb ff ff       	call   80210e <syscall>
  8025b2:	83 c4 18             	add    $0x18,%esp
	return ;
  8025b5:	90                   	nop
}
  8025b6:	c9                   	leave  
  8025b7:	c3                   	ret    

008025b8 <rsttst>:
void rsttst()
{
  8025b8:	55                   	push   %ebp
  8025b9:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  8025bb:	6a 00                	push   $0x0
  8025bd:	6a 00                	push   $0x0
  8025bf:	6a 00                	push   $0x0
  8025c1:	6a 00                	push   $0x0
  8025c3:	6a 00                	push   $0x0
  8025c5:	6a 28                	push   $0x28
  8025c7:	e8 42 fb ff ff       	call   80210e <syscall>
  8025cc:	83 c4 18             	add    $0x18,%esp
	return ;
  8025cf:	90                   	nop
}
  8025d0:	c9                   	leave  
  8025d1:	c3                   	ret    

008025d2 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  8025d2:	55                   	push   %ebp
  8025d3:	89 e5                	mov    %esp,%ebp
  8025d5:	83 ec 04             	sub    $0x4,%esp
  8025d8:	8b 45 14             	mov    0x14(%ebp),%eax
  8025db:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  8025de:	8b 55 18             	mov    0x18(%ebp),%edx
  8025e1:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  8025e5:	52                   	push   %edx
  8025e6:	50                   	push   %eax
  8025e7:	ff 75 10             	pushl  0x10(%ebp)
  8025ea:	ff 75 0c             	pushl  0xc(%ebp)
  8025ed:	ff 75 08             	pushl  0x8(%ebp)
  8025f0:	6a 27                	push   $0x27
  8025f2:	e8 17 fb ff ff       	call   80210e <syscall>
  8025f7:	83 c4 18             	add    $0x18,%esp
	return ;
  8025fa:	90                   	nop
}
  8025fb:	c9                   	leave  
  8025fc:	c3                   	ret    

008025fd <chktst>:
void chktst(uint32 n)
{
  8025fd:	55                   	push   %ebp
  8025fe:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  802600:	6a 00                	push   $0x0
  802602:	6a 00                	push   $0x0
  802604:	6a 00                	push   $0x0
  802606:	6a 00                	push   $0x0
  802608:	ff 75 08             	pushl  0x8(%ebp)
  80260b:	6a 29                	push   $0x29
  80260d:	e8 fc fa ff ff       	call   80210e <syscall>
  802612:	83 c4 18             	add    $0x18,%esp
	return ;
  802615:	90                   	nop
}
  802616:	c9                   	leave  
  802617:	c3                   	ret    

00802618 <inctst>:

void inctst()
{
  802618:	55                   	push   %ebp
  802619:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  80261b:	6a 00                	push   $0x0
  80261d:	6a 00                	push   $0x0
  80261f:	6a 00                	push   $0x0
  802621:	6a 00                	push   $0x0
  802623:	6a 00                	push   $0x0
  802625:	6a 2a                	push   $0x2a
  802627:	e8 e2 fa ff ff       	call   80210e <syscall>
  80262c:	83 c4 18             	add    $0x18,%esp
	return ;
  80262f:	90                   	nop
}
  802630:	c9                   	leave  
  802631:	c3                   	ret    

00802632 <gettst>:
uint32 gettst()
{
  802632:	55                   	push   %ebp
  802633:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  802635:	6a 00                	push   $0x0
  802637:	6a 00                	push   $0x0
  802639:	6a 00                	push   $0x0
  80263b:	6a 00                	push   $0x0
  80263d:	6a 00                	push   $0x0
  80263f:	6a 2b                	push   $0x2b
  802641:	e8 c8 fa ff ff       	call   80210e <syscall>
  802646:	83 c4 18             	add    $0x18,%esp
}
  802649:	c9                   	leave  
  80264a:	c3                   	ret    

0080264b <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  80264b:	55                   	push   %ebp
  80264c:	89 e5                	mov    %esp,%ebp
  80264e:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  802651:	6a 00                	push   $0x0
  802653:	6a 00                	push   $0x0
  802655:	6a 00                	push   $0x0
  802657:	6a 00                	push   $0x0
  802659:	6a 00                	push   $0x0
  80265b:	6a 2c                	push   $0x2c
  80265d:	e8 ac fa ff ff       	call   80210e <syscall>
  802662:	83 c4 18             	add    $0x18,%esp
  802665:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  802668:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  80266c:	75 07                	jne    802675 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  80266e:	b8 01 00 00 00       	mov    $0x1,%eax
  802673:	eb 05                	jmp    80267a <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  802675:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80267a:	c9                   	leave  
  80267b:	c3                   	ret    

0080267c <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  80267c:	55                   	push   %ebp
  80267d:	89 e5                	mov    %esp,%ebp
  80267f:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  802682:	6a 00                	push   $0x0
  802684:	6a 00                	push   $0x0
  802686:	6a 00                	push   $0x0
  802688:	6a 00                	push   $0x0
  80268a:	6a 00                	push   $0x0
  80268c:	6a 2c                	push   $0x2c
  80268e:	e8 7b fa ff ff       	call   80210e <syscall>
  802693:	83 c4 18             	add    $0x18,%esp
  802696:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  802699:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  80269d:	75 07                	jne    8026a6 <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  80269f:	b8 01 00 00 00       	mov    $0x1,%eax
  8026a4:	eb 05                	jmp    8026ab <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  8026a6:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8026ab:	c9                   	leave  
  8026ac:	c3                   	ret    

008026ad <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  8026ad:	55                   	push   %ebp
  8026ae:	89 e5                	mov    %esp,%ebp
  8026b0:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8026b3:	6a 00                	push   $0x0
  8026b5:	6a 00                	push   $0x0
  8026b7:	6a 00                	push   $0x0
  8026b9:	6a 00                	push   $0x0
  8026bb:	6a 00                	push   $0x0
  8026bd:	6a 2c                	push   $0x2c
  8026bf:	e8 4a fa ff ff       	call   80210e <syscall>
  8026c4:	83 c4 18             	add    $0x18,%esp
  8026c7:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  8026ca:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  8026ce:	75 07                	jne    8026d7 <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  8026d0:	b8 01 00 00 00       	mov    $0x1,%eax
  8026d5:	eb 05                	jmp    8026dc <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  8026d7:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8026dc:	c9                   	leave  
  8026dd:	c3                   	ret    

008026de <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  8026de:	55                   	push   %ebp
  8026df:	89 e5                	mov    %esp,%ebp
  8026e1:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8026e4:	6a 00                	push   $0x0
  8026e6:	6a 00                	push   $0x0
  8026e8:	6a 00                	push   $0x0
  8026ea:	6a 00                	push   $0x0
  8026ec:	6a 00                	push   $0x0
  8026ee:	6a 2c                	push   $0x2c
  8026f0:	e8 19 fa ff ff       	call   80210e <syscall>
  8026f5:	83 c4 18             	add    $0x18,%esp
  8026f8:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  8026fb:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  8026ff:	75 07                	jne    802708 <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  802701:	b8 01 00 00 00       	mov    $0x1,%eax
  802706:	eb 05                	jmp    80270d <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  802708:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80270d:	c9                   	leave  
  80270e:	c3                   	ret    

0080270f <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  80270f:	55                   	push   %ebp
  802710:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  802712:	6a 00                	push   $0x0
  802714:	6a 00                	push   $0x0
  802716:	6a 00                	push   $0x0
  802718:	6a 00                	push   $0x0
  80271a:	ff 75 08             	pushl  0x8(%ebp)
  80271d:	6a 2d                	push   $0x2d
  80271f:	e8 ea f9 ff ff       	call   80210e <syscall>
  802724:	83 c4 18             	add    $0x18,%esp
	return ;
  802727:	90                   	nop
}
  802728:	c9                   	leave  
  802729:	c3                   	ret    

0080272a <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  80272a:	55                   	push   %ebp
  80272b:	89 e5                	mov    %esp,%ebp
  80272d:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  80272e:	8b 5d 14             	mov    0x14(%ebp),%ebx
  802731:	8b 4d 10             	mov    0x10(%ebp),%ecx
  802734:	8b 55 0c             	mov    0xc(%ebp),%edx
  802737:	8b 45 08             	mov    0x8(%ebp),%eax
  80273a:	6a 00                	push   $0x0
  80273c:	53                   	push   %ebx
  80273d:	51                   	push   %ecx
  80273e:	52                   	push   %edx
  80273f:	50                   	push   %eax
  802740:	6a 2e                	push   $0x2e
  802742:	e8 c7 f9 ff ff       	call   80210e <syscall>
  802747:	83 c4 18             	add    $0x18,%esp
}
  80274a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80274d:	c9                   	leave  
  80274e:	c3                   	ret    

0080274f <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  80274f:	55                   	push   %ebp
  802750:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  802752:	8b 55 0c             	mov    0xc(%ebp),%edx
  802755:	8b 45 08             	mov    0x8(%ebp),%eax
  802758:	6a 00                	push   $0x0
  80275a:	6a 00                	push   $0x0
  80275c:	6a 00                	push   $0x0
  80275e:	52                   	push   %edx
  80275f:	50                   	push   %eax
  802760:	6a 2f                	push   $0x2f
  802762:	e8 a7 f9 ff ff       	call   80210e <syscall>
  802767:	83 c4 18             	add    $0x18,%esp
}
  80276a:	c9                   	leave  
  80276b:	c3                   	ret    

0080276c <print_mem_block_lists>:
//===========================
// PRINT MEM BLOCK LISTS:
//===========================

void print_mem_block_lists()
{
  80276c:	55                   	push   %ebp
  80276d:	89 e5                	mov    %esp,%ebp
  80276f:	83 ec 18             	sub    $0x18,%esp
	cprintf("\n=========================================\n");
  802772:	83 ec 0c             	sub    $0xc,%esp
  802775:	68 b4 42 80 00       	push   $0x8042b4
  80277a:	e8 d7 e4 ff ff       	call   800c56 <cprintf>
  80277f:	83 c4 10             	add    $0x10,%esp
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
  802782:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nFreeMemBlocksList:\n");
  802789:	83 ec 0c             	sub    $0xc,%esp
  80278c:	68 e0 42 80 00       	push   $0x8042e0
  802791:	e8 c0 e4 ff ff       	call   800c56 <cprintf>
  802796:	83 c4 10             	add    $0x10,%esp
	uint8 sorted = 1 ;
  802799:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &FreeMemBlocksList)
  80279d:	a1 38 51 80 00       	mov    0x805138,%eax
  8027a2:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8027a5:	eb 56                	jmp    8027fd <print_mem_block_lists+0x91>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  8027a7:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8027ab:	74 1c                	je     8027c9 <print_mem_block_lists+0x5d>
  8027ad:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027b0:	8b 50 08             	mov    0x8(%eax),%edx
  8027b3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8027b6:	8b 48 08             	mov    0x8(%eax),%ecx
  8027b9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8027bc:	8b 40 0c             	mov    0xc(%eax),%eax
  8027bf:	01 c8                	add    %ecx,%eax
  8027c1:	39 c2                	cmp    %eax,%edx
  8027c3:	73 04                	jae    8027c9 <print_mem_block_lists+0x5d>
			sorted = 0 ;
  8027c5:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  8027c9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027cc:	8b 50 08             	mov    0x8(%eax),%edx
  8027cf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027d2:	8b 40 0c             	mov    0xc(%eax),%eax
  8027d5:	01 c2                	add    %eax,%edx
  8027d7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027da:	8b 40 08             	mov    0x8(%eax),%eax
  8027dd:	83 ec 04             	sub    $0x4,%esp
  8027e0:	52                   	push   %edx
  8027e1:	50                   	push   %eax
  8027e2:	68 f5 42 80 00       	push   $0x8042f5
  8027e7:	e8 6a e4 ff ff       	call   800c56 <cprintf>
  8027ec:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  8027ef:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027f2:	89 45 f0             	mov    %eax,-0x10(%ebp)
	cprintf("\n=========================================\n");
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
	cprintf("\nFreeMemBlocksList:\n");
	uint8 sorted = 1 ;
	LIST_FOREACH(blk, &FreeMemBlocksList)
  8027f5:	a1 40 51 80 00       	mov    0x805140,%eax
  8027fa:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8027fd:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802801:	74 07                	je     80280a <print_mem_block_lists+0x9e>
  802803:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802806:	8b 00                	mov    (%eax),%eax
  802808:	eb 05                	jmp    80280f <print_mem_block_lists+0xa3>
  80280a:	b8 00 00 00 00       	mov    $0x0,%eax
  80280f:	a3 40 51 80 00       	mov    %eax,0x805140
  802814:	a1 40 51 80 00       	mov    0x805140,%eax
  802819:	85 c0                	test   %eax,%eax
  80281b:	75 8a                	jne    8027a7 <print_mem_block_lists+0x3b>
  80281d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802821:	75 84                	jne    8027a7 <print_mem_block_lists+0x3b>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;
  802823:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  802827:	75 10                	jne    802839 <print_mem_block_lists+0xcd>
  802829:	83 ec 0c             	sub    $0xc,%esp
  80282c:	68 04 43 80 00       	push   $0x804304
  802831:	e8 20 e4 ff ff       	call   800c56 <cprintf>
  802836:	83 c4 10             	add    $0x10,%esp

	lastBlk = NULL ;
  802839:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nAllocMemBlocksList:\n");
  802840:	83 ec 0c             	sub    $0xc,%esp
  802843:	68 28 43 80 00       	push   $0x804328
  802848:	e8 09 e4 ff ff       	call   800c56 <cprintf>
  80284d:	83 c4 10             	add    $0x10,%esp
	sorted = 1 ;
  802850:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &AllocMemBlocksList)
  802854:	a1 40 50 80 00       	mov    0x805040,%eax
  802859:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80285c:	eb 56                	jmp    8028b4 <print_mem_block_lists+0x148>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  80285e:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802862:	74 1c                	je     802880 <print_mem_block_lists+0x114>
  802864:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802867:	8b 50 08             	mov    0x8(%eax),%edx
  80286a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80286d:	8b 48 08             	mov    0x8(%eax),%ecx
  802870:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802873:	8b 40 0c             	mov    0xc(%eax),%eax
  802876:	01 c8                	add    %ecx,%eax
  802878:	39 c2                	cmp    %eax,%edx
  80287a:	73 04                	jae    802880 <print_mem_block_lists+0x114>
			sorted = 0 ;
  80287c:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  802880:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802883:	8b 50 08             	mov    0x8(%eax),%edx
  802886:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802889:	8b 40 0c             	mov    0xc(%eax),%eax
  80288c:	01 c2                	add    %eax,%edx
  80288e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802891:	8b 40 08             	mov    0x8(%eax),%eax
  802894:	83 ec 04             	sub    $0x4,%esp
  802897:	52                   	push   %edx
  802898:	50                   	push   %eax
  802899:	68 f5 42 80 00       	push   $0x8042f5
  80289e:	e8 b3 e3 ff ff       	call   800c56 <cprintf>
  8028a3:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  8028a6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028a9:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;

	lastBlk = NULL ;
	cprintf("\nAllocMemBlocksList:\n");
	sorted = 1 ;
	LIST_FOREACH(blk, &AllocMemBlocksList)
  8028ac:	a1 48 50 80 00       	mov    0x805048,%eax
  8028b1:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8028b4:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8028b8:	74 07                	je     8028c1 <print_mem_block_lists+0x155>
  8028ba:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028bd:	8b 00                	mov    (%eax),%eax
  8028bf:	eb 05                	jmp    8028c6 <print_mem_block_lists+0x15a>
  8028c1:	b8 00 00 00 00       	mov    $0x0,%eax
  8028c6:	a3 48 50 80 00       	mov    %eax,0x805048
  8028cb:	a1 48 50 80 00       	mov    0x805048,%eax
  8028d0:	85 c0                	test   %eax,%eax
  8028d2:	75 8a                	jne    80285e <print_mem_block_lists+0xf2>
  8028d4:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8028d8:	75 84                	jne    80285e <print_mem_block_lists+0xf2>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nAllocMemBlocksList is NOT SORTED!!\n") ;
  8028da:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  8028de:	75 10                	jne    8028f0 <print_mem_block_lists+0x184>
  8028e0:	83 ec 0c             	sub    $0xc,%esp
  8028e3:	68 40 43 80 00       	push   $0x804340
  8028e8:	e8 69 e3 ff ff       	call   800c56 <cprintf>
  8028ed:	83 c4 10             	add    $0x10,%esp
	cprintf("\n=========================================\n");
  8028f0:	83 ec 0c             	sub    $0xc,%esp
  8028f3:	68 b4 42 80 00       	push   $0x8042b4
  8028f8:	e8 59 e3 ff ff       	call   800c56 <cprintf>
  8028fd:	83 c4 10             	add    $0x10,%esp

}
  802900:	90                   	nop
  802901:	c9                   	leave  
  802902:	c3                   	ret    

00802903 <initialize_MemBlocksList>:

//===============================
// [1] INITIALIZE AVAILABLE LIST:
//===============================
void initialize_MemBlocksList(uint32 numOfBlocks)
{
  802903:	55                   	push   %ebp
  802904:	89 e5                	mov    %esp,%ebp
  802906:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] initialize_MemBlocksList
	// Write your code here, remove the panic and write your code
	//panic("initialize_MemBlocksList() is not implemented yet...!!");
	uint32 n = numOfBlocks;
  802909:	8b 45 08             	mov    0x8(%ebp),%eax
  80290c:	89 45 f0             	mov    %eax,-0x10(%ebp)

	LIST_INIT(&AvailableMemBlocksList);
  80290f:	c7 05 48 51 80 00 00 	movl   $0x0,0x805148
  802916:	00 00 00 
  802919:	c7 05 4c 51 80 00 00 	movl   $0x0,0x80514c
  802920:	00 00 00 
  802923:	c7 05 54 51 80 00 00 	movl   $0x0,0x805154
  80292a:	00 00 00 
	for(int i = 0; i<n;i++)
  80292d:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  802934:	e9 9e 00 00 00       	jmp    8029d7 <initialize_MemBlocksList+0xd4>
	{
		LIST_INSERT_HEAD(&AvailableMemBlocksList, &(MemBlockNodes[i]));
  802939:	a1 50 50 80 00       	mov    0x805050,%eax
  80293e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802941:	c1 e2 04             	shl    $0x4,%edx
  802944:	01 d0                	add    %edx,%eax
  802946:	85 c0                	test   %eax,%eax
  802948:	75 14                	jne    80295e <initialize_MemBlocksList+0x5b>
  80294a:	83 ec 04             	sub    $0x4,%esp
  80294d:	68 68 43 80 00       	push   $0x804368
  802952:	6a 47                	push   $0x47
  802954:	68 8b 43 80 00       	push   $0x80438b
  802959:	e8 44 e0 ff ff       	call   8009a2 <_panic>
  80295e:	a1 50 50 80 00       	mov    0x805050,%eax
  802963:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802966:	c1 e2 04             	shl    $0x4,%edx
  802969:	01 d0                	add    %edx,%eax
  80296b:	8b 15 48 51 80 00    	mov    0x805148,%edx
  802971:	89 10                	mov    %edx,(%eax)
  802973:	8b 00                	mov    (%eax),%eax
  802975:	85 c0                	test   %eax,%eax
  802977:	74 18                	je     802991 <initialize_MemBlocksList+0x8e>
  802979:	a1 48 51 80 00       	mov    0x805148,%eax
  80297e:	8b 15 50 50 80 00    	mov    0x805050,%edx
  802984:	8b 4d f4             	mov    -0xc(%ebp),%ecx
  802987:	c1 e1 04             	shl    $0x4,%ecx
  80298a:	01 ca                	add    %ecx,%edx
  80298c:	89 50 04             	mov    %edx,0x4(%eax)
  80298f:	eb 12                	jmp    8029a3 <initialize_MemBlocksList+0xa0>
  802991:	a1 50 50 80 00       	mov    0x805050,%eax
  802996:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802999:	c1 e2 04             	shl    $0x4,%edx
  80299c:	01 d0                	add    %edx,%eax
  80299e:	a3 4c 51 80 00       	mov    %eax,0x80514c
  8029a3:	a1 50 50 80 00       	mov    0x805050,%eax
  8029a8:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8029ab:	c1 e2 04             	shl    $0x4,%edx
  8029ae:	01 d0                	add    %edx,%eax
  8029b0:	a3 48 51 80 00       	mov    %eax,0x805148
  8029b5:	a1 50 50 80 00       	mov    0x805050,%eax
  8029ba:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8029bd:	c1 e2 04             	shl    $0x4,%edx
  8029c0:	01 d0                	add    %edx,%eax
  8029c2:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8029c9:	a1 54 51 80 00       	mov    0x805154,%eax
  8029ce:	40                   	inc    %eax
  8029cf:	a3 54 51 80 00       	mov    %eax,0x805154
	// Write your code here, remove the panic and write your code
	//panic("initialize_MemBlocksList() is not implemented yet...!!");
	uint32 n = numOfBlocks;

	LIST_INIT(&AvailableMemBlocksList);
	for(int i = 0; i<n;i++)
  8029d4:	ff 45 f4             	incl   -0xc(%ebp)
  8029d7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029da:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8029dd:	0f 82 56 ff ff ff    	jb     802939 <initialize_MemBlocksList+0x36>
	{
		LIST_INSERT_HEAD(&AvailableMemBlocksList, &(MemBlockNodes[i]));
	}
}
  8029e3:	90                   	nop
  8029e4:	c9                   	leave  
  8029e5:	c3                   	ret    

008029e6 <find_block>:

//===============================
// [2] FIND BLOCK:
//===============================
struct MemBlock *find_block(struct MemBlock_List *blockList, uint32 va)
{
  8029e6:	55                   	push   %ebp
  8029e7:	89 e5                	mov    %esp,%ebp
  8029e9:	83 ec 10             	sub    $0x10,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] find_block
	// Write your code here, remove the panic and write your code
	//panic("find_block() is not implemented yet...!!");
	uint32 virAddress = va;
  8029ec:	8b 45 0c             	mov    0xc(%ebp),%eax
  8029ef:	89 45 f4             	mov    %eax,-0xc(%ebp)
	struct MemBlock* blk;
	int found = 0;
  8029f2:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	LIST_FOREACH(blk, &(AllocMemBlocksList))
  8029f9:	a1 40 50 80 00       	mov    0x805040,%eax
  8029fe:	89 45 fc             	mov    %eax,-0x4(%ebp)
  802a01:	eb 23                	jmp    802a26 <find_block+0x40>
	{
		if(blk->sva == virAddress)
  802a03:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802a06:	8b 40 08             	mov    0x8(%eax),%eax
  802a09:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  802a0c:	75 09                	jne    802a17 <find_block+0x31>
		{
			found = 1;
  802a0e:	c7 45 f8 01 00 00 00 	movl   $0x1,-0x8(%ebp)
			break;
  802a15:	eb 35                	jmp    802a4c <find_block+0x66>
		}
		else
		{
			found = 0;
  802a17:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	//panic("find_block() is not implemented yet...!!");
	uint32 virAddress = va;
	struct MemBlock* blk;
	int found = 0;

	LIST_FOREACH(blk, &(AllocMemBlocksList))
  802a1e:	a1 48 50 80 00       	mov    0x805048,%eax
  802a23:	89 45 fc             	mov    %eax,-0x4(%ebp)
  802a26:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  802a2a:	74 07                	je     802a33 <find_block+0x4d>
  802a2c:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802a2f:	8b 00                	mov    (%eax),%eax
  802a31:	eb 05                	jmp    802a38 <find_block+0x52>
  802a33:	b8 00 00 00 00       	mov    $0x0,%eax
  802a38:	a3 48 50 80 00       	mov    %eax,0x805048
  802a3d:	a1 48 50 80 00       	mov    0x805048,%eax
  802a42:	85 c0                	test   %eax,%eax
  802a44:	75 bd                	jne    802a03 <find_block+0x1d>
  802a46:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  802a4a:	75 b7                	jne    802a03 <find_block+0x1d>
		{
			found = 0;
			continue;
		}
	}
	if(found == 1)
  802a4c:	83 7d f8 01          	cmpl   $0x1,-0x8(%ebp)
  802a50:	75 05                	jne    802a57 <find_block+0x71>
	{
		return blk;
  802a52:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802a55:	eb 05                	jmp    802a5c <find_block+0x76>
	}
	else
	{
		return NULL;
  802a57:	b8 00 00 00 00       	mov    $0x0,%eax
	}
}
  802a5c:	c9                   	leave  
  802a5d:	c3                   	ret    

00802a5e <insert_sorted_allocList>:

//=========================================
// [3] INSERT BLOCK IN ALLOC LIST [SORTED]:
//=========================================
void insert_sorted_allocList(struct MemBlock *blockToInsert)
{
  802a5e:	55                   	push   %ebp
  802a5f:	89 e5                	mov    %esp,%ebp
  802a61:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] insert_sorted_allocList
	// Write your code here, remove the panic and write your code
	//panic("insert_sorted_allocList() is not implemented yet...!!");
	struct MemBlock* blk;
	struct MemBlock* newblk = blockToInsert;
  802a64:	8b 45 08             	mov    0x8(%ebp),%eax
  802a67:	89 45 f0             	mov    %eax,-0x10(%ebp)

	if((LIST_EMPTY(&AllocMemBlocksList)) || (newblk->sva < LIST_FIRST(&AllocMemBlocksList)->sva))
  802a6a:	a1 40 50 80 00       	mov    0x805040,%eax
  802a6f:	85 c0                	test   %eax,%eax
  802a71:	74 12                	je     802a85 <insert_sorted_allocList+0x27>
  802a73:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a76:	8b 50 08             	mov    0x8(%eax),%edx
  802a79:	a1 40 50 80 00       	mov    0x805040,%eax
  802a7e:	8b 40 08             	mov    0x8(%eax),%eax
  802a81:	39 c2                	cmp    %eax,%edx
  802a83:	73 65                	jae    802aea <insert_sorted_allocList+0x8c>
	{
		LIST_INSERT_HEAD(&(AllocMemBlocksList), newblk);
  802a85:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802a89:	75 14                	jne    802a9f <insert_sorted_allocList+0x41>
  802a8b:	83 ec 04             	sub    $0x4,%esp
  802a8e:	68 68 43 80 00       	push   $0x804368
  802a93:	6a 7b                	push   $0x7b
  802a95:	68 8b 43 80 00       	push   $0x80438b
  802a9a:	e8 03 df ff ff       	call   8009a2 <_panic>
  802a9f:	8b 15 40 50 80 00    	mov    0x805040,%edx
  802aa5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802aa8:	89 10                	mov    %edx,(%eax)
  802aaa:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802aad:	8b 00                	mov    (%eax),%eax
  802aaf:	85 c0                	test   %eax,%eax
  802ab1:	74 0d                	je     802ac0 <insert_sorted_allocList+0x62>
  802ab3:	a1 40 50 80 00       	mov    0x805040,%eax
  802ab8:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802abb:	89 50 04             	mov    %edx,0x4(%eax)
  802abe:	eb 08                	jmp    802ac8 <insert_sorted_allocList+0x6a>
  802ac0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ac3:	a3 44 50 80 00       	mov    %eax,0x805044
  802ac8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802acb:	a3 40 50 80 00       	mov    %eax,0x805040
  802ad0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ad3:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802ada:	a1 4c 50 80 00       	mov    0x80504c,%eax
  802adf:	40                   	inc    %eax
  802ae0:	a3 4c 50 80 00       	mov    %eax,0x80504c
  802ae5:	e9 5f 01 00 00       	jmp    802c49 <insert_sorted_allocList+0x1eb>
	}
	else if(newblk->sva > LIST_LAST(&AllocMemBlocksList)->sva)
  802aea:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802aed:	8b 50 08             	mov    0x8(%eax),%edx
  802af0:	a1 44 50 80 00       	mov    0x805044,%eax
  802af5:	8b 40 08             	mov    0x8(%eax),%eax
  802af8:	39 c2                	cmp    %eax,%edx
  802afa:	76 65                	jbe    802b61 <insert_sorted_allocList+0x103>
	{
		LIST_INSERT_TAIL(&AllocMemBlocksList, newblk);
  802afc:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802b00:	75 14                	jne    802b16 <insert_sorted_allocList+0xb8>
  802b02:	83 ec 04             	sub    $0x4,%esp
  802b05:	68 a4 43 80 00       	push   $0x8043a4
  802b0a:	6a 7f                	push   $0x7f
  802b0c:	68 8b 43 80 00       	push   $0x80438b
  802b11:	e8 8c de ff ff       	call   8009a2 <_panic>
  802b16:	8b 15 44 50 80 00    	mov    0x805044,%edx
  802b1c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b1f:	89 50 04             	mov    %edx,0x4(%eax)
  802b22:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b25:	8b 40 04             	mov    0x4(%eax),%eax
  802b28:	85 c0                	test   %eax,%eax
  802b2a:	74 0c                	je     802b38 <insert_sorted_allocList+0xda>
  802b2c:	a1 44 50 80 00       	mov    0x805044,%eax
  802b31:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802b34:	89 10                	mov    %edx,(%eax)
  802b36:	eb 08                	jmp    802b40 <insert_sorted_allocList+0xe2>
  802b38:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b3b:	a3 40 50 80 00       	mov    %eax,0x805040
  802b40:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b43:	a3 44 50 80 00       	mov    %eax,0x805044
  802b48:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b4b:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802b51:	a1 4c 50 80 00       	mov    0x80504c,%eax
  802b56:	40                   	inc    %eax
  802b57:	a3 4c 50 80 00       	mov    %eax,0x80504c
				LIST_INSERT_AFTER(&AllocMemBlocksList, blk, newblk);
				break;
			}
		}
	}
}
  802b5c:	e9 e8 00 00 00       	jmp    802c49 <insert_sorted_allocList+0x1eb>
	{
		LIST_INSERT_TAIL(&AllocMemBlocksList, newblk);
	}
	else
	{
		LIST_FOREACH(blk, &AllocMemBlocksList)
  802b61:	a1 40 50 80 00       	mov    0x805040,%eax
  802b66:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802b69:	e9 ab 00 00 00       	jmp    802c19 <insert_sorted_allocList+0x1bb>
		{
			if(blk->prev_next_info.le_next != NULL && newblk->sva > blk->sva  && newblk->sva < blk->prev_next_info.le_next->sva)
  802b6e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b71:	8b 00                	mov    (%eax),%eax
  802b73:	85 c0                	test   %eax,%eax
  802b75:	0f 84 96 00 00 00    	je     802c11 <insert_sorted_allocList+0x1b3>
  802b7b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b7e:	8b 50 08             	mov    0x8(%eax),%edx
  802b81:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b84:	8b 40 08             	mov    0x8(%eax),%eax
  802b87:	39 c2                	cmp    %eax,%edx
  802b89:	0f 86 82 00 00 00    	jbe    802c11 <insert_sorted_allocList+0x1b3>
  802b8f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b92:	8b 50 08             	mov    0x8(%eax),%edx
  802b95:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b98:	8b 00                	mov    (%eax),%eax
  802b9a:	8b 40 08             	mov    0x8(%eax),%eax
  802b9d:	39 c2                	cmp    %eax,%edx
  802b9f:	73 70                	jae    802c11 <insert_sorted_allocList+0x1b3>
			{
				LIST_INSERT_AFTER(&AllocMemBlocksList, blk, newblk);
  802ba1:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802ba5:	74 06                	je     802bad <insert_sorted_allocList+0x14f>
  802ba7:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802bab:	75 17                	jne    802bc4 <insert_sorted_allocList+0x166>
  802bad:	83 ec 04             	sub    $0x4,%esp
  802bb0:	68 c8 43 80 00       	push   $0x8043c8
  802bb5:	68 87 00 00 00       	push   $0x87
  802bba:	68 8b 43 80 00       	push   $0x80438b
  802bbf:	e8 de dd ff ff       	call   8009a2 <_panic>
  802bc4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bc7:	8b 10                	mov    (%eax),%edx
  802bc9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802bcc:	89 10                	mov    %edx,(%eax)
  802bce:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802bd1:	8b 00                	mov    (%eax),%eax
  802bd3:	85 c0                	test   %eax,%eax
  802bd5:	74 0b                	je     802be2 <insert_sorted_allocList+0x184>
  802bd7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bda:	8b 00                	mov    (%eax),%eax
  802bdc:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802bdf:	89 50 04             	mov    %edx,0x4(%eax)
  802be2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802be5:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802be8:	89 10                	mov    %edx,(%eax)
  802bea:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802bed:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802bf0:	89 50 04             	mov    %edx,0x4(%eax)
  802bf3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802bf6:	8b 00                	mov    (%eax),%eax
  802bf8:	85 c0                	test   %eax,%eax
  802bfa:	75 08                	jne    802c04 <insert_sorted_allocList+0x1a6>
  802bfc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802bff:	a3 44 50 80 00       	mov    %eax,0x805044
  802c04:	a1 4c 50 80 00       	mov    0x80504c,%eax
  802c09:	40                   	inc    %eax
  802c0a:	a3 4c 50 80 00       	mov    %eax,0x80504c
				break;
  802c0f:	eb 38                	jmp    802c49 <insert_sorted_allocList+0x1eb>
	{
		LIST_INSERT_TAIL(&AllocMemBlocksList, newblk);
	}
	else
	{
		LIST_FOREACH(blk, &AllocMemBlocksList)
  802c11:	a1 48 50 80 00       	mov    0x805048,%eax
  802c16:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802c19:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802c1d:	74 07                	je     802c26 <insert_sorted_allocList+0x1c8>
  802c1f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c22:	8b 00                	mov    (%eax),%eax
  802c24:	eb 05                	jmp    802c2b <insert_sorted_allocList+0x1cd>
  802c26:	b8 00 00 00 00       	mov    $0x0,%eax
  802c2b:	a3 48 50 80 00       	mov    %eax,0x805048
  802c30:	a1 48 50 80 00       	mov    0x805048,%eax
  802c35:	85 c0                	test   %eax,%eax
  802c37:	0f 85 31 ff ff ff    	jne    802b6e <insert_sorted_allocList+0x110>
  802c3d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802c41:	0f 85 27 ff ff ff    	jne    802b6e <insert_sorted_allocList+0x110>
				LIST_INSERT_AFTER(&AllocMemBlocksList, blk, newblk);
				break;
			}
		}
	}
}
  802c47:	eb 00                	jmp    802c49 <insert_sorted_allocList+0x1eb>
  802c49:	90                   	nop
  802c4a:	c9                   	leave  
  802c4b:	c3                   	ret    

00802c4c <alloc_block_FF>:

//=========================================
// [4] ALLOCATE BLOCK BY FIRST FIT:
//=========================================
struct MemBlock *alloc_block_FF(uint32 size)
{
  802c4c:	55                   	push   %ebp
  802c4d:	89 e5                	mov    %esp,%ebp
  802c4f:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_FF
	// Write your code here, remove the panic and write your code
	//panic("alloc_block_FF() is not implemented yet...!!");
	uint32 versize = size;
  802c52:	8b 45 08             	mov    0x8(%ebp),%eax
  802c55:	89 45 f0             	mov    %eax,-0x10(%ebp)
	struct MemBlock* blk;
	struct MemBlock* newblk = LIST_FIRST(&AvailableMemBlocksList);
  802c58:	a1 48 51 80 00       	mov    0x805148,%eax
  802c5d:	89 45 ec             	mov    %eax,-0x14(%ebp)

	LIST_FOREACH(blk,&FreeMemBlocksList)
  802c60:	a1 38 51 80 00       	mov    0x805138,%eax
  802c65:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802c68:	e9 77 01 00 00       	jmp    802de4 <alloc_block_FF+0x198>
	{
		if(blk->size == versize)
  802c6d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c70:	8b 40 0c             	mov    0xc(%eax),%eax
  802c73:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  802c76:	0f 85 8a 00 00 00    	jne    802d06 <alloc_block_FF+0xba>
		{
			LIST_REMOVE(&FreeMemBlocksList,blk);
  802c7c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802c80:	75 17                	jne    802c99 <alloc_block_FF+0x4d>
  802c82:	83 ec 04             	sub    $0x4,%esp
  802c85:	68 fc 43 80 00       	push   $0x8043fc
  802c8a:	68 9e 00 00 00       	push   $0x9e
  802c8f:	68 8b 43 80 00       	push   $0x80438b
  802c94:	e8 09 dd ff ff       	call   8009a2 <_panic>
  802c99:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c9c:	8b 00                	mov    (%eax),%eax
  802c9e:	85 c0                	test   %eax,%eax
  802ca0:	74 10                	je     802cb2 <alloc_block_FF+0x66>
  802ca2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ca5:	8b 00                	mov    (%eax),%eax
  802ca7:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802caa:	8b 52 04             	mov    0x4(%edx),%edx
  802cad:	89 50 04             	mov    %edx,0x4(%eax)
  802cb0:	eb 0b                	jmp    802cbd <alloc_block_FF+0x71>
  802cb2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cb5:	8b 40 04             	mov    0x4(%eax),%eax
  802cb8:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802cbd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cc0:	8b 40 04             	mov    0x4(%eax),%eax
  802cc3:	85 c0                	test   %eax,%eax
  802cc5:	74 0f                	je     802cd6 <alloc_block_FF+0x8a>
  802cc7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cca:	8b 40 04             	mov    0x4(%eax),%eax
  802ccd:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802cd0:	8b 12                	mov    (%edx),%edx
  802cd2:	89 10                	mov    %edx,(%eax)
  802cd4:	eb 0a                	jmp    802ce0 <alloc_block_FF+0x94>
  802cd6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cd9:	8b 00                	mov    (%eax),%eax
  802cdb:	a3 38 51 80 00       	mov    %eax,0x805138
  802ce0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ce3:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802ce9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cec:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802cf3:	a1 44 51 80 00       	mov    0x805144,%eax
  802cf8:	48                   	dec    %eax
  802cf9:	a3 44 51 80 00       	mov    %eax,0x805144
			return blk;
  802cfe:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d01:	e9 11 01 00 00       	jmp    802e17 <alloc_block_FF+0x1cb>
		}
		else if(blk->size > versize)
  802d06:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d09:	8b 40 0c             	mov    0xc(%eax),%eax
  802d0c:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  802d0f:	0f 86 c7 00 00 00    	jbe    802ddc <alloc_block_FF+0x190>
		{
			LIST_REMOVE(&AvailableMemBlocksList,newblk);
  802d15:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802d19:	75 17                	jne    802d32 <alloc_block_FF+0xe6>
  802d1b:	83 ec 04             	sub    $0x4,%esp
  802d1e:	68 fc 43 80 00       	push   $0x8043fc
  802d23:	68 a3 00 00 00       	push   $0xa3
  802d28:	68 8b 43 80 00       	push   $0x80438b
  802d2d:	e8 70 dc ff ff       	call   8009a2 <_panic>
  802d32:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802d35:	8b 00                	mov    (%eax),%eax
  802d37:	85 c0                	test   %eax,%eax
  802d39:	74 10                	je     802d4b <alloc_block_FF+0xff>
  802d3b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802d3e:	8b 00                	mov    (%eax),%eax
  802d40:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802d43:	8b 52 04             	mov    0x4(%edx),%edx
  802d46:	89 50 04             	mov    %edx,0x4(%eax)
  802d49:	eb 0b                	jmp    802d56 <alloc_block_FF+0x10a>
  802d4b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802d4e:	8b 40 04             	mov    0x4(%eax),%eax
  802d51:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802d56:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802d59:	8b 40 04             	mov    0x4(%eax),%eax
  802d5c:	85 c0                	test   %eax,%eax
  802d5e:	74 0f                	je     802d6f <alloc_block_FF+0x123>
  802d60:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802d63:	8b 40 04             	mov    0x4(%eax),%eax
  802d66:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802d69:	8b 12                	mov    (%edx),%edx
  802d6b:	89 10                	mov    %edx,(%eax)
  802d6d:	eb 0a                	jmp    802d79 <alloc_block_FF+0x12d>
  802d6f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802d72:	8b 00                	mov    (%eax),%eax
  802d74:	a3 48 51 80 00       	mov    %eax,0x805148
  802d79:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802d7c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802d82:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802d85:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802d8c:	a1 54 51 80 00       	mov    0x805154,%eax
  802d91:	48                   	dec    %eax
  802d92:	a3 54 51 80 00       	mov    %eax,0x805154
			newblk->size = versize;
  802d97:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802d9a:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802d9d:	89 50 0c             	mov    %edx,0xc(%eax)
			blk->size = blk->size-versize;
  802da0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802da3:	8b 40 0c             	mov    0xc(%eax),%eax
  802da6:	2b 45 f0             	sub    -0x10(%ebp),%eax
  802da9:	89 c2                	mov    %eax,%edx
  802dab:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802dae:	89 50 0c             	mov    %edx,0xc(%eax)
			uint32 newveradd = blk->sva;
  802db1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802db4:	8b 40 08             	mov    0x8(%eax),%eax
  802db7:	89 45 e8             	mov    %eax,-0x18(%ebp)
			blk->sva+=newblk->size;
  802dba:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802dbd:	8b 50 08             	mov    0x8(%eax),%edx
  802dc0:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802dc3:	8b 40 0c             	mov    0xc(%eax),%eax
  802dc6:	01 c2                	add    %eax,%edx
  802dc8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802dcb:	89 50 08             	mov    %edx,0x8(%eax)
			newblk->sva = newveradd;
  802dce:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802dd1:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802dd4:	89 50 08             	mov    %edx,0x8(%eax)
			return newblk;
  802dd7:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802dda:	eb 3b                	jmp    802e17 <alloc_block_FF+0x1cb>
	//panic("alloc_block_FF() is not implemented yet...!!");
	uint32 versize = size;
	struct MemBlock* blk;
	struct MemBlock* newblk = LIST_FIRST(&AvailableMemBlocksList);

	LIST_FOREACH(blk,&FreeMemBlocksList)
  802ddc:	a1 40 51 80 00       	mov    0x805140,%eax
  802de1:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802de4:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802de8:	74 07                	je     802df1 <alloc_block_FF+0x1a5>
  802dea:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ded:	8b 00                	mov    (%eax),%eax
  802def:	eb 05                	jmp    802df6 <alloc_block_FF+0x1aa>
  802df1:	b8 00 00 00 00       	mov    $0x0,%eax
  802df6:	a3 40 51 80 00       	mov    %eax,0x805140
  802dfb:	a1 40 51 80 00       	mov    0x805140,%eax
  802e00:	85 c0                	test   %eax,%eax
  802e02:	0f 85 65 fe ff ff    	jne    802c6d <alloc_block_FF+0x21>
  802e08:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802e0c:	0f 85 5b fe ff ff    	jne    802c6d <alloc_block_FF+0x21>
			blk->sva+=newblk->size;
			newblk->sva = newveradd;
			return newblk;
		}
	}
	return NULL;
  802e12:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802e17:	c9                   	leave  
  802e18:	c3                   	ret    

00802e19 <alloc_block_BF>:

//=========================================
// [5] ALLOCATE BLOCK BY BEST FIT:
//=========================================
struct MemBlock *alloc_block_BF(uint32 size)
{
  802e19:	55                   	push   %ebp
  802e1a:	89 e5                	mov    %esp,%ebp
  802e1c:	83 ec 28             	sub    $0x28,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_BF
	// Write your code here, remove the panic and write your code
	//panic("alloc_block_BF() is not implemented yet...!!");
	uint32 versize=size;
  802e1f:	8b 45 08             	mov    0x8(%ebp),%eax
  802e22:	89 45 e8             	mov    %eax,-0x18(%ebp)
	struct MemBlock* blk;
	struct MemBlock* newblk=LIST_FIRST(&AvailableMemBlocksList);
  802e25:	a1 48 51 80 00       	mov    0x805148,%eax
  802e2a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	uint32 newveradd;
	uint32 newsize;
	int size_free = LIST_SIZE(&FreeMemBlocksList);
  802e2d:	a1 44 51 80 00       	mov    0x805144,%eax
  802e32:	89 45 e0             	mov    %eax,-0x20(%ebp)

	LIST_FOREACH(blk, &FreeMemBlocksList)
  802e35:	a1 38 51 80 00       	mov    0x805138,%eax
  802e3a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802e3d:	e9 a1 00 00 00       	jmp    802ee3 <alloc_block_BF+0xca>
	{
		if(blk->size == versize)
  802e42:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e45:	8b 40 0c             	mov    0xc(%eax),%eax
  802e48:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  802e4b:	0f 85 8a 00 00 00    	jne    802edb <alloc_block_BF+0xc2>
		{
			LIST_REMOVE(&FreeMemBlocksList, blk);
  802e51:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802e55:	75 17                	jne    802e6e <alloc_block_BF+0x55>
  802e57:	83 ec 04             	sub    $0x4,%esp
  802e5a:	68 fc 43 80 00       	push   $0x8043fc
  802e5f:	68 c2 00 00 00       	push   $0xc2
  802e64:	68 8b 43 80 00       	push   $0x80438b
  802e69:	e8 34 db ff ff       	call   8009a2 <_panic>
  802e6e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e71:	8b 00                	mov    (%eax),%eax
  802e73:	85 c0                	test   %eax,%eax
  802e75:	74 10                	je     802e87 <alloc_block_BF+0x6e>
  802e77:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e7a:	8b 00                	mov    (%eax),%eax
  802e7c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802e7f:	8b 52 04             	mov    0x4(%edx),%edx
  802e82:	89 50 04             	mov    %edx,0x4(%eax)
  802e85:	eb 0b                	jmp    802e92 <alloc_block_BF+0x79>
  802e87:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e8a:	8b 40 04             	mov    0x4(%eax),%eax
  802e8d:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802e92:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e95:	8b 40 04             	mov    0x4(%eax),%eax
  802e98:	85 c0                	test   %eax,%eax
  802e9a:	74 0f                	je     802eab <alloc_block_BF+0x92>
  802e9c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e9f:	8b 40 04             	mov    0x4(%eax),%eax
  802ea2:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802ea5:	8b 12                	mov    (%edx),%edx
  802ea7:	89 10                	mov    %edx,(%eax)
  802ea9:	eb 0a                	jmp    802eb5 <alloc_block_BF+0x9c>
  802eab:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802eae:	8b 00                	mov    (%eax),%eax
  802eb0:	a3 38 51 80 00       	mov    %eax,0x805138
  802eb5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802eb8:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802ebe:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ec1:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802ec8:	a1 44 51 80 00       	mov    0x805144,%eax
  802ecd:	48                   	dec    %eax
  802ece:	a3 44 51 80 00       	mov    %eax,0x805144
			return blk;
  802ed3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ed6:	e9 11 02 00 00       	jmp    8030ec <alloc_block_BF+0x2d3>
	struct MemBlock* newblk=LIST_FIRST(&AvailableMemBlocksList);
	uint32 newveradd;
	uint32 newsize;
	int size_free = LIST_SIZE(&FreeMemBlocksList);

	LIST_FOREACH(blk, &FreeMemBlocksList)
  802edb:	a1 40 51 80 00       	mov    0x805140,%eax
  802ee0:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802ee3:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802ee7:	74 07                	je     802ef0 <alloc_block_BF+0xd7>
  802ee9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802eec:	8b 00                	mov    (%eax),%eax
  802eee:	eb 05                	jmp    802ef5 <alloc_block_BF+0xdc>
  802ef0:	b8 00 00 00 00       	mov    $0x0,%eax
  802ef5:	a3 40 51 80 00       	mov    %eax,0x805140
  802efa:	a1 40 51 80 00       	mov    0x805140,%eax
  802eff:	85 c0                	test   %eax,%eax
  802f01:	0f 85 3b ff ff ff    	jne    802e42 <alloc_block_BF+0x29>
  802f07:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802f0b:	0f 85 31 ff ff ff    	jne    802e42 <alloc_block_BF+0x29>
		{
			LIST_REMOVE(&FreeMemBlocksList, blk);
			return blk;
		}
	}
	LIST_FOREACH(blk, &FreeMemBlocksList)
  802f11:	a1 38 51 80 00       	mov    0x805138,%eax
  802f16:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802f19:	eb 27                	jmp    802f42 <alloc_block_BF+0x129>
	{
		if(blk->size > versize)
  802f1b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f1e:	8b 40 0c             	mov    0xc(%eax),%eax
  802f21:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  802f24:	76 14                	jbe    802f3a <alloc_block_BF+0x121>
		{
			newsize = blk->size;
  802f26:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f29:	8b 40 0c             	mov    0xc(%eax),%eax
  802f2c:	89 45 ec             	mov    %eax,-0x14(%ebp)
			newveradd = blk->sva;
  802f2f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f32:	8b 40 08             	mov    0x8(%eax),%eax
  802f35:	89 45 f0             	mov    %eax,-0x10(%ebp)
			break;
  802f38:	eb 2e                	jmp    802f68 <alloc_block_BF+0x14f>
		{
			LIST_REMOVE(&FreeMemBlocksList, blk);
			return blk;
		}
	}
	LIST_FOREACH(blk, &FreeMemBlocksList)
  802f3a:	a1 40 51 80 00       	mov    0x805140,%eax
  802f3f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802f42:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802f46:	74 07                	je     802f4f <alloc_block_BF+0x136>
  802f48:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f4b:	8b 00                	mov    (%eax),%eax
  802f4d:	eb 05                	jmp    802f54 <alloc_block_BF+0x13b>
  802f4f:	b8 00 00 00 00       	mov    $0x0,%eax
  802f54:	a3 40 51 80 00       	mov    %eax,0x805140
  802f59:	a1 40 51 80 00       	mov    0x805140,%eax
  802f5e:	85 c0                	test   %eax,%eax
  802f60:	75 b9                	jne    802f1b <alloc_block_BF+0x102>
  802f62:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802f66:	75 b3                	jne    802f1b <alloc_block_BF+0x102>
			newsize = blk->size;
			newveradd = blk->sva;
			break;
		}
	}
	LIST_FOREACH(blk, &FreeMemBlocksList)
  802f68:	a1 38 51 80 00       	mov    0x805138,%eax
  802f6d:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802f70:	eb 30                	jmp    802fa2 <alloc_block_BF+0x189>
	{
		if(newsize > blk->size && blk->size > versize)
  802f72:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f75:	8b 40 0c             	mov    0xc(%eax),%eax
  802f78:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  802f7b:	73 1d                	jae    802f9a <alloc_block_BF+0x181>
  802f7d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f80:	8b 40 0c             	mov    0xc(%eax),%eax
  802f83:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  802f86:	76 12                	jbe    802f9a <alloc_block_BF+0x181>
		{
	       newsize = blk->size;
  802f88:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f8b:	8b 40 0c             	mov    0xc(%eax),%eax
  802f8e:	89 45 ec             	mov    %eax,-0x14(%ebp)
		   newveradd = blk->sva;
  802f91:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f94:	8b 40 08             	mov    0x8(%eax),%eax
  802f97:	89 45 f0             	mov    %eax,-0x10(%ebp)
			newsize = blk->size;
			newveradd = blk->sva;
			break;
		}
	}
	LIST_FOREACH(blk, &FreeMemBlocksList)
  802f9a:	a1 40 51 80 00       	mov    0x805140,%eax
  802f9f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802fa2:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802fa6:	74 07                	je     802faf <alloc_block_BF+0x196>
  802fa8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802fab:	8b 00                	mov    (%eax),%eax
  802fad:	eb 05                	jmp    802fb4 <alloc_block_BF+0x19b>
  802faf:	b8 00 00 00 00       	mov    $0x0,%eax
  802fb4:	a3 40 51 80 00       	mov    %eax,0x805140
  802fb9:	a1 40 51 80 00       	mov    0x805140,%eax
  802fbe:	85 c0                	test   %eax,%eax
  802fc0:	75 b0                	jne    802f72 <alloc_block_BF+0x159>
  802fc2:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802fc6:	75 aa                	jne    802f72 <alloc_block_BF+0x159>
		{
	       newsize = blk->size;
		   newveradd = blk->sva;
		}
	}
	LIST_FOREACH(blk, &FreeMemBlocksList)
  802fc8:	a1 38 51 80 00       	mov    0x805138,%eax
  802fcd:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802fd0:	e9 e4 00 00 00       	jmp    8030b9 <alloc_block_BF+0x2a0>
	{
		if(blk->size == newsize && blk->sva == newveradd)
  802fd5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802fd8:	8b 40 0c             	mov    0xc(%eax),%eax
  802fdb:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  802fde:	0f 85 cd 00 00 00    	jne    8030b1 <alloc_block_BF+0x298>
  802fe4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802fe7:	8b 40 08             	mov    0x8(%eax),%eax
  802fea:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  802fed:	0f 85 be 00 00 00    	jne    8030b1 <alloc_block_BF+0x298>
		{
			LIST_REMOVE(&AvailableMemBlocksList, newblk);
  802ff3:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  802ff7:	75 17                	jne    803010 <alloc_block_BF+0x1f7>
  802ff9:	83 ec 04             	sub    $0x4,%esp
  802ffc:	68 fc 43 80 00       	push   $0x8043fc
  803001:	68 db 00 00 00       	push   $0xdb
  803006:	68 8b 43 80 00       	push   $0x80438b
  80300b:	e8 92 d9 ff ff       	call   8009a2 <_panic>
  803010:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803013:	8b 00                	mov    (%eax),%eax
  803015:	85 c0                	test   %eax,%eax
  803017:	74 10                	je     803029 <alloc_block_BF+0x210>
  803019:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80301c:	8b 00                	mov    (%eax),%eax
  80301e:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803021:	8b 52 04             	mov    0x4(%edx),%edx
  803024:	89 50 04             	mov    %edx,0x4(%eax)
  803027:	eb 0b                	jmp    803034 <alloc_block_BF+0x21b>
  803029:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80302c:	8b 40 04             	mov    0x4(%eax),%eax
  80302f:	a3 4c 51 80 00       	mov    %eax,0x80514c
  803034:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803037:	8b 40 04             	mov    0x4(%eax),%eax
  80303a:	85 c0                	test   %eax,%eax
  80303c:	74 0f                	je     80304d <alloc_block_BF+0x234>
  80303e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803041:	8b 40 04             	mov    0x4(%eax),%eax
  803044:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803047:	8b 12                	mov    (%edx),%edx
  803049:	89 10                	mov    %edx,(%eax)
  80304b:	eb 0a                	jmp    803057 <alloc_block_BF+0x23e>
  80304d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803050:	8b 00                	mov    (%eax),%eax
  803052:	a3 48 51 80 00       	mov    %eax,0x805148
  803057:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80305a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803060:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803063:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80306a:	a1 54 51 80 00       	mov    0x805154,%eax
  80306f:	48                   	dec    %eax
  803070:	a3 54 51 80 00       	mov    %eax,0x805154
			newblk->size = versize;
  803075:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803078:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80307b:	89 50 0c             	mov    %edx,0xc(%eax)
			newblk->sva = newveradd;
  80307e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803081:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803084:	89 50 08             	mov    %edx,0x8(%eax)
			blk->size = blk->size - versize;
  803087:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80308a:	8b 40 0c             	mov    0xc(%eax),%eax
  80308d:	2b 45 e8             	sub    -0x18(%ebp),%eax
  803090:	89 c2                	mov    %eax,%edx
  803092:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803095:	89 50 0c             	mov    %edx,0xc(%eax)
			blk->sva+= newblk->size;
  803098:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80309b:	8b 50 08             	mov    0x8(%eax),%edx
  80309e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8030a1:	8b 40 0c             	mov    0xc(%eax),%eax
  8030a4:	01 c2                	add    %eax,%edx
  8030a6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030a9:	89 50 08             	mov    %edx,0x8(%eax)
			return newblk;
  8030ac:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8030af:	eb 3b                	jmp    8030ec <alloc_block_BF+0x2d3>
		{
	       newsize = blk->size;
		   newveradd = blk->sva;
		}
	}
	LIST_FOREACH(blk, &FreeMemBlocksList)
  8030b1:	a1 40 51 80 00       	mov    0x805140,%eax
  8030b6:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8030b9:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8030bd:	74 07                	je     8030c6 <alloc_block_BF+0x2ad>
  8030bf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030c2:	8b 00                	mov    (%eax),%eax
  8030c4:	eb 05                	jmp    8030cb <alloc_block_BF+0x2b2>
  8030c6:	b8 00 00 00 00       	mov    $0x0,%eax
  8030cb:	a3 40 51 80 00       	mov    %eax,0x805140
  8030d0:	a1 40 51 80 00       	mov    0x805140,%eax
  8030d5:	85 c0                	test   %eax,%eax
  8030d7:	0f 85 f8 fe ff ff    	jne    802fd5 <alloc_block_BF+0x1bc>
  8030dd:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8030e1:	0f 85 ee fe ff ff    	jne    802fd5 <alloc_block_BF+0x1bc>
			blk->size = blk->size - versize;
			blk->sva+= newblk->size;
			return newblk;
		}
	}
	return NULL;
  8030e7:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8030ec:	c9                   	leave  
  8030ed:	c3                   	ret    

008030ee <alloc_block_NF>:
//=========================================
// [7] ALLOCATE BLOCK BY NEXT FIT:
//=========================================
struct MemBlock *last_allocate;
struct MemBlock *alloc_block_NF(uint32 size)
{
  8030ee:	55                   	push   %ebp
  8030ef:	89 e5                	mov    %esp,%ebp
  8030f1:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1 - BONUS] [DYNAMIC ALLOCATOR] alloc_block_NF
	// Write your code here, remove the panic and write your code
	//panic("alloc_block_NF() is not implemented yet...!!");
	uint32 versize = size;
  8030f4:	8b 45 08             	mov    0x8(%ebp),%eax
  8030f7:	89 45 f0             	mov    %eax,-0x10(%ebp)
	struct MemBlock* blk;
	struct MemBlock* newblk = LIST_FIRST(&AvailableMemBlocksList);
  8030fa:	a1 48 51 80 00       	mov    0x805148,%eax
  8030ff:	89 45 ec             	mov    %eax,-0x14(%ebp)

	LIST_FOREACH(blk,&FreeMemBlocksList)
  803102:	a1 38 51 80 00       	mov    0x805138,%eax
  803107:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80310a:	e9 77 01 00 00       	jmp    803286 <alloc_block_NF+0x198>
	{
		if(blk->size == versize)
  80310f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803112:	8b 40 0c             	mov    0xc(%eax),%eax
  803115:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  803118:	0f 85 8a 00 00 00    	jne    8031a8 <alloc_block_NF+0xba>
		{
			LIST_REMOVE(&FreeMemBlocksList,blk);
  80311e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803122:	75 17                	jne    80313b <alloc_block_NF+0x4d>
  803124:	83 ec 04             	sub    $0x4,%esp
  803127:	68 fc 43 80 00       	push   $0x8043fc
  80312c:	68 f7 00 00 00       	push   $0xf7
  803131:	68 8b 43 80 00       	push   $0x80438b
  803136:	e8 67 d8 ff ff       	call   8009a2 <_panic>
  80313b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80313e:	8b 00                	mov    (%eax),%eax
  803140:	85 c0                	test   %eax,%eax
  803142:	74 10                	je     803154 <alloc_block_NF+0x66>
  803144:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803147:	8b 00                	mov    (%eax),%eax
  803149:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80314c:	8b 52 04             	mov    0x4(%edx),%edx
  80314f:	89 50 04             	mov    %edx,0x4(%eax)
  803152:	eb 0b                	jmp    80315f <alloc_block_NF+0x71>
  803154:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803157:	8b 40 04             	mov    0x4(%eax),%eax
  80315a:	a3 3c 51 80 00       	mov    %eax,0x80513c
  80315f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803162:	8b 40 04             	mov    0x4(%eax),%eax
  803165:	85 c0                	test   %eax,%eax
  803167:	74 0f                	je     803178 <alloc_block_NF+0x8a>
  803169:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80316c:	8b 40 04             	mov    0x4(%eax),%eax
  80316f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803172:	8b 12                	mov    (%edx),%edx
  803174:	89 10                	mov    %edx,(%eax)
  803176:	eb 0a                	jmp    803182 <alloc_block_NF+0x94>
  803178:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80317b:	8b 00                	mov    (%eax),%eax
  80317d:	a3 38 51 80 00       	mov    %eax,0x805138
  803182:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803185:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80318b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80318e:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803195:	a1 44 51 80 00       	mov    0x805144,%eax
  80319a:	48                   	dec    %eax
  80319b:	a3 44 51 80 00       	mov    %eax,0x805144
			return blk;
  8031a0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8031a3:	e9 11 01 00 00       	jmp    8032b9 <alloc_block_NF+0x1cb>
		}
		else if(blk->size > versize)
  8031a8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8031ab:	8b 40 0c             	mov    0xc(%eax),%eax
  8031ae:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8031b1:	0f 86 c7 00 00 00    	jbe    80327e <alloc_block_NF+0x190>
		{
			LIST_REMOVE(&AvailableMemBlocksList,newblk);
  8031b7:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8031bb:	75 17                	jne    8031d4 <alloc_block_NF+0xe6>
  8031bd:	83 ec 04             	sub    $0x4,%esp
  8031c0:	68 fc 43 80 00       	push   $0x8043fc
  8031c5:	68 fc 00 00 00       	push   $0xfc
  8031ca:	68 8b 43 80 00       	push   $0x80438b
  8031cf:	e8 ce d7 ff ff       	call   8009a2 <_panic>
  8031d4:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8031d7:	8b 00                	mov    (%eax),%eax
  8031d9:	85 c0                	test   %eax,%eax
  8031db:	74 10                	je     8031ed <alloc_block_NF+0xff>
  8031dd:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8031e0:	8b 00                	mov    (%eax),%eax
  8031e2:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8031e5:	8b 52 04             	mov    0x4(%edx),%edx
  8031e8:	89 50 04             	mov    %edx,0x4(%eax)
  8031eb:	eb 0b                	jmp    8031f8 <alloc_block_NF+0x10a>
  8031ed:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8031f0:	8b 40 04             	mov    0x4(%eax),%eax
  8031f3:	a3 4c 51 80 00       	mov    %eax,0x80514c
  8031f8:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8031fb:	8b 40 04             	mov    0x4(%eax),%eax
  8031fe:	85 c0                	test   %eax,%eax
  803200:	74 0f                	je     803211 <alloc_block_NF+0x123>
  803202:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803205:	8b 40 04             	mov    0x4(%eax),%eax
  803208:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80320b:	8b 12                	mov    (%edx),%edx
  80320d:	89 10                	mov    %edx,(%eax)
  80320f:	eb 0a                	jmp    80321b <alloc_block_NF+0x12d>
  803211:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803214:	8b 00                	mov    (%eax),%eax
  803216:	a3 48 51 80 00       	mov    %eax,0x805148
  80321b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80321e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803224:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803227:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80322e:	a1 54 51 80 00       	mov    0x805154,%eax
  803233:	48                   	dec    %eax
  803234:	a3 54 51 80 00       	mov    %eax,0x805154
			newblk->size = versize;
  803239:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80323c:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80323f:	89 50 0c             	mov    %edx,0xc(%eax)
			blk->size = blk->size-versize;
  803242:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803245:	8b 40 0c             	mov    0xc(%eax),%eax
  803248:	2b 45 f0             	sub    -0x10(%ebp),%eax
  80324b:	89 c2                	mov    %eax,%edx
  80324d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803250:	89 50 0c             	mov    %edx,0xc(%eax)
			uint32 newveradd = blk->sva;
  803253:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803256:	8b 40 08             	mov    0x8(%eax),%eax
  803259:	89 45 e8             	mov    %eax,-0x18(%ebp)
			blk->sva+=newblk->size;
  80325c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80325f:	8b 50 08             	mov    0x8(%eax),%edx
  803262:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803265:	8b 40 0c             	mov    0xc(%eax),%eax
  803268:	01 c2                	add    %eax,%edx
  80326a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80326d:	89 50 08             	mov    %edx,0x8(%eax)
			newblk->sva = newveradd;
  803270:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803273:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803276:	89 50 08             	mov    %edx,0x8(%eax)
			return newblk;
  803279:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80327c:	eb 3b                	jmp    8032b9 <alloc_block_NF+0x1cb>
	//panic("alloc_block_NF() is not implemented yet...!!");
	uint32 versize = size;
	struct MemBlock* blk;
	struct MemBlock* newblk = LIST_FIRST(&AvailableMemBlocksList);

	LIST_FOREACH(blk,&FreeMemBlocksList)
  80327e:	a1 40 51 80 00       	mov    0x805140,%eax
  803283:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803286:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80328a:	74 07                	je     803293 <alloc_block_NF+0x1a5>
  80328c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80328f:	8b 00                	mov    (%eax),%eax
  803291:	eb 05                	jmp    803298 <alloc_block_NF+0x1aa>
  803293:	b8 00 00 00 00       	mov    $0x0,%eax
  803298:	a3 40 51 80 00       	mov    %eax,0x805140
  80329d:	a1 40 51 80 00       	mov    0x805140,%eax
  8032a2:	85 c0                	test   %eax,%eax
  8032a4:	0f 85 65 fe ff ff    	jne    80310f <alloc_block_NF+0x21>
  8032aa:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8032ae:	0f 85 5b fe ff ff    	jne    80310f <alloc_block_NF+0x21>
			blk->sva+=newblk->size;
			newblk->sva = newveradd;
			return newblk;
		}
	}
	return NULL;
  8032b4:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8032b9:	c9                   	leave  
  8032ba:	c3                   	ret    

008032bb <addToAvailMemBlocksList>:

//===================================================
// [8] INSERT BLOCK (SORTED WITH MERGE) IN FREE LIST:
//===================================================
void addToAvailMemBlocksList(struct MemBlock *blockToInsert)
{
  8032bb:	55                   	push   %ebp
  8032bc:	89 e5                	mov    %esp,%ebp
  8032be:	83 ec 08             	sub    $0x8,%esp
	blockToInsert->sva = 0;
  8032c1:	8b 45 08             	mov    0x8(%ebp),%eax
  8032c4:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
	blockToInsert->size = 0;
  8032cb:	8b 45 08             	mov    0x8(%ebp),%eax
  8032ce:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
	//add to avail
	LIST_INSERT_TAIL(&AvailableMemBlocksList, blockToInsert);
  8032d5:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8032d9:	75 17                	jne    8032f2 <addToAvailMemBlocksList+0x37>
  8032db:	83 ec 04             	sub    $0x4,%esp
  8032de:	68 a4 43 80 00       	push   $0x8043a4
  8032e3:	68 10 01 00 00       	push   $0x110
  8032e8:	68 8b 43 80 00       	push   $0x80438b
  8032ed:	e8 b0 d6 ff ff       	call   8009a2 <_panic>
  8032f2:	8b 15 4c 51 80 00    	mov    0x80514c,%edx
  8032f8:	8b 45 08             	mov    0x8(%ebp),%eax
  8032fb:	89 50 04             	mov    %edx,0x4(%eax)
  8032fe:	8b 45 08             	mov    0x8(%ebp),%eax
  803301:	8b 40 04             	mov    0x4(%eax),%eax
  803304:	85 c0                	test   %eax,%eax
  803306:	74 0c                	je     803314 <addToAvailMemBlocksList+0x59>
  803308:	a1 4c 51 80 00       	mov    0x80514c,%eax
  80330d:	8b 55 08             	mov    0x8(%ebp),%edx
  803310:	89 10                	mov    %edx,(%eax)
  803312:	eb 08                	jmp    80331c <addToAvailMemBlocksList+0x61>
  803314:	8b 45 08             	mov    0x8(%ebp),%eax
  803317:	a3 48 51 80 00       	mov    %eax,0x805148
  80331c:	8b 45 08             	mov    0x8(%ebp),%eax
  80331f:	a3 4c 51 80 00       	mov    %eax,0x80514c
  803324:	8b 45 08             	mov    0x8(%ebp),%eax
  803327:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80332d:	a1 54 51 80 00       	mov    0x805154,%eax
  803332:	40                   	inc    %eax
  803333:	a3 54 51 80 00       	mov    %eax,0x805154
}
  803338:	90                   	nop
  803339:	c9                   	leave  
  80333a:	c3                   	ret    

0080333b <insert_sorted_with_merge_freeList>:
void insert_sorted_with_merge_freeList(struct MemBlock *blockToInsert)
{
  80333b:	55                   	push   %ebp
  80333c:	89 e5                	mov    %esp,%ebp
  80333e:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] insert_sorted_with_merge_freeList
	// Write your code here, remove the panic and write your code

	struct MemBlock* last = LIST_LAST(&FreeMemBlocksList);
  803341:	a1 3c 51 80 00       	mov    0x80513c,%eax
  803346:	89 45 f0             	mov    %eax,-0x10(%ebp)
	//check if list empty
	if (LIST_SIZE(&(FreeMemBlocksList)) == 0)
  803349:	a1 44 51 80 00       	mov    0x805144,%eax
  80334e:	85 c0                	test   %eax,%eax
  803350:	75 68                	jne    8033ba <insert_sorted_with_merge_freeList+0x7f>
		LIST_INSERT_HEAD(&FreeMemBlocksList, blockToInsert);
  803352:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803356:	75 17                	jne    80336f <insert_sorted_with_merge_freeList+0x34>
  803358:	83 ec 04             	sub    $0x4,%esp
  80335b:	68 68 43 80 00       	push   $0x804368
  803360:	68 1a 01 00 00       	push   $0x11a
  803365:	68 8b 43 80 00       	push   $0x80438b
  80336a:	e8 33 d6 ff ff       	call   8009a2 <_panic>
  80336f:	8b 15 38 51 80 00    	mov    0x805138,%edx
  803375:	8b 45 08             	mov    0x8(%ebp),%eax
  803378:	89 10                	mov    %edx,(%eax)
  80337a:	8b 45 08             	mov    0x8(%ebp),%eax
  80337d:	8b 00                	mov    (%eax),%eax
  80337f:	85 c0                	test   %eax,%eax
  803381:	74 0d                	je     803390 <insert_sorted_with_merge_freeList+0x55>
  803383:	a1 38 51 80 00       	mov    0x805138,%eax
  803388:	8b 55 08             	mov    0x8(%ebp),%edx
  80338b:	89 50 04             	mov    %edx,0x4(%eax)
  80338e:	eb 08                	jmp    803398 <insert_sorted_with_merge_freeList+0x5d>
  803390:	8b 45 08             	mov    0x8(%ebp),%eax
  803393:	a3 3c 51 80 00       	mov    %eax,0x80513c
  803398:	8b 45 08             	mov    0x8(%ebp),%eax
  80339b:	a3 38 51 80 00       	mov    %eax,0x805138
  8033a0:	8b 45 08             	mov    0x8(%ebp),%eax
  8033a3:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8033aa:	a1 44 51 80 00       	mov    0x805144,%eax
  8033af:	40                   	inc    %eax
  8033b0:	a3 44 51 80 00       	mov    %eax,0x805144
		}
	}

	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  8033b5:	e9 c5 03 00 00       	jmp    80377f <insert_sorted_with_merge_freeList+0x444>
	struct MemBlock* last = LIST_LAST(&FreeMemBlocksList);
	//check if list empty
	if (LIST_SIZE(&(FreeMemBlocksList)) == 0)
		LIST_INSERT_HEAD(&FreeMemBlocksList, blockToInsert);
	//check if it's position is at last
	else if (last->sva < blockToInsert->sva) {
  8033ba:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8033bd:	8b 50 08             	mov    0x8(%eax),%edx
  8033c0:	8b 45 08             	mov    0x8(%ebp),%eax
  8033c3:	8b 40 08             	mov    0x8(%eax),%eax
  8033c6:	39 c2                	cmp    %eax,%edx
  8033c8:	0f 83 b2 00 00 00    	jae    803480 <insert_sorted_with_merge_freeList+0x145>

		//if i have to merge
		if (last->sva + last->size == blockToInsert->sva) {
  8033ce:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8033d1:	8b 50 08             	mov    0x8(%eax),%edx
  8033d4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8033d7:	8b 40 0c             	mov    0xc(%eax),%eax
  8033da:	01 c2                	add    %eax,%edx
  8033dc:	8b 45 08             	mov    0x8(%ebp),%eax
  8033df:	8b 40 08             	mov    0x8(%eax),%eax
  8033e2:	39 c2                	cmp    %eax,%edx
  8033e4:	75 27                	jne    80340d <insert_sorted_with_merge_freeList+0xd2>
			last->size = last->size + blockToInsert->size;
  8033e6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8033e9:	8b 50 0c             	mov    0xc(%eax),%edx
  8033ec:	8b 45 08             	mov    0x8(%ebp),%eax
  8033ef:	8b 40 0c             	mov    0xc(%eax),%eax
  8033f2:	01 c2                	add    %eax,%edx
  8033f4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8033f7:	89 50 0c             	mov    %edx,0xc(%eax)
			addToAvailMemBlocksList(blockToInsert);
  8033fa:	83 ec 0c             	sub    $0xc,%esp
  8033fd:	ff 75 08             	pushl  0x8(%ebp)
  803400:	e8 b6 fe ff ff       	call   8032bb <addToAvailMemBlocksList>
  803405:	83 c4 10             	add    $0x10,%esp
		}
	}

	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  803408:	e9 72 03 00 00       	jmp    80377f <insert_sorted_with_merge_freeList+0x444>
		if (last->sva + last->size == blockToInsert->sva) {
			last->size = last->size + blockToInsert->size;
			addToAvailMemBlocksList(blockToInsert);

		} else {
			LIST_INSERT_AFTER(&FreeMemBlocksList, last, blockToInsert);
  80340d:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  803411:	74 06                	je     803419 <insert_sorted_with_merge_freeList+0xde>
  803413:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803417:	75 17                	jne    803430 <insert_sorted_with_merge_freeList+0xf5>
  803419:	83 ec 04             	sub    $0x4,%esp
  80341c:	68 c8 43 80 00       	push   $0x8043c8
  803421:	68 24 01 00 00       	push   $0x124
  803426:	68 8b 43 80 00       	push   $0x80438b
  80342b:	e8 72 d5 ff ff       	call   8009a2 <_panic>
  803430:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803433:	8b 10                	mov    (%eax),%edx
  803435:	8b 45 08             	mov    0x8(%ebp),%eax
  803438:	89 10                	mov    %edx,(%eax)
  80343a:	8b 45 08             	mov    0x8(%ebp),%eax
  80343d:	8b 00                	mov    (%eax),%eax
  80343f:	85 c0                	test   %eax,%eax
  803441:	74 0b                	je     80344e <insert_sorted_with_merge_freeList+0x113>
  803443:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803446:	8b 00                	mov    (%eax),%eax
  803448:	8b 55 08             	mov    0x8(%ebp),%edx
  80344b:	89 50 04             	mov    %edx,0x4(%eax)
  80344e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803451:	8b 55 08             	mov    0x8(%ebp),%edx
  803454:	89 10                	mov    %edx,(%eax)
  803456:	8b 45 08             	mov    0x8(%ebp),%eax
  803459:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80345c:	89 50 04             	mov    %edx,0x4(%eax)
  80345f:	8b 45 08             	mov    0x8(%ebp),%eax
  803462:	8b 00                	mov    (%eax),%eax
  803464:	85 c0                	test   %eax,%eax
  803466:	75 08                	jne    803470 <insert_sorted_with_merge_freeList+0x135>
  803468:	8b 45 08             	mov    0x8(%ebp),%eax
  80346b:	a3 3c 51 80 00       	mov    %eax,0x80513c
  803470:	a1 44 51 80 00       	mov    0x805144,%eax
  803475:	40                   	inc    %eax
  803476:	a3 44 51 80 00       	mov    %eax,0x805144
		}
	}

	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  80347b:	e9 ff 02 00 00       	jmp    80377f <insert_sorted_with_merge_freeList+0x444>
		} else {
			LIST_INSERT_AFTER(&FreeMemBlocksList, last, blockToInsert);
		}
	} else {
		struct MemBlock *iterator;
		LIST_FOREACH(iterator, &(FreeMemBlocksList))
  803480:	a1 38 51 80 00       	mov    0x805138,%eax
  803485:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803488:	e9 c2 02 00 00       	jmp    80374f <insert_sorted_with_merge_freeList+0x414>
		{

			if (iterator->sva > blockToInsert->sva) {
  80348d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803490:	8b 50 08             	mov    0x8(%eax),%edx
  803493:	8b 45 08             	mov    0x8(%ebp),%eax
  803496:	8b 40 08             	mov    0x8(%eax),%eax
  803499:	39 c2                	cmp    %eax,%edx
  80349b:	0f 86 a6 02 00 00    	jbe    803747 <insert_sorted_with_merge_freeList+0x40c>

				struct MemBlock* prev = LIST_PREV(iterator);
  8034a1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8034a4:	8b 40 04             	mov    0x4(%eax),%eax
  8034a7:	89 45 ec             	mov    %eax,-0x14(%ebp)
				if (prev == NULL) {
  8034aa:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8034ae:	0f 85 ba 00 00 00    	jne    80356e <insert_sorted_with_merge_freeList+0x233>
					//check merge
					if (blockToInsert->size + blockToInsert->sva
  8034b4:	8b 45 08             	mov    0x8(%ebp),%eax
  8034b7:	8b 50 0c             	mov    0xc(%eax),%edx
  8034ba:	8b 45 08             	mov    0x8(%ebp),%eax
  8034bd:	8b 40 08             	mov    0x8(%eax),%eax
  8034c0:	01 c2                	add    %eax,%edx
							== iterator->sva) {
  8034c2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8034c5:	8b 40 08             	mov    0x8(%eax),%eax
			if (iterator->sva > blockToInsert->sva) {

				struct MemBlock* prev = LIST_PREV(iterator);
				if (prev == NULL) {
					//check merge
					if (blockToInsert->size + blockToInsert->sva
  8034c8:	39 c2                	cmp    %eax,%edx
  8034ca:	75 33                	jne    8034ff <insert_sorted_with_merge_freeList+0x1c4>
							== iterator->sva) {
						iterator->sva = blockToInsert->sva;
  8034cc:	8b 45 08             	mov    0x8(%ebp),%eax
  8034cf:	8b 50 08             	mov    0x8(%eax),%edx
  8034d2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8034d5:	89 50 08             	mov    %edx,0x8(%eax)
						iterator->size = iterator->size + blockToInsert->size;
  8034d8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8034db:	8b 50 0c             	mov    0xc(%eax),%edx
  8034de:	8b 45 08             	mov    0x8(%ebp),%eax
  8034e1:	8b 40 0c             	mov    0xc(%eax),%eax
  8034e4:	01 c2                	add    %eax,%edx
  8034e6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8034e9:	89 50 0c             	mov    %edx,0xc(%eax)
						addToAvailMemBlocksList(blockToInsert);
  8034ec:	83 ec 0c             	sub    $0xc,%esp
  8034ef:	ff 75 08             	pushl  0x8(%ebp)
  8034f2:	e8 c4 fd ff ff       	call   8032bb <addToAvailMemBlocksList>
  8034f7:	83 c4 10             	add    $0x10,%esp

					else {
						LIST_INSERT_BEFORE(&FreeMemBlocksList, iterator,
								blockToInsert);
					}
					break;
  8034fa:	e9 80 02 00 00       	jmp    80377f <insert_sorted_with_merge_freeList+0x444>
						addToAvailMemBlocksList(blockToInsert);

					}

					else {
						LIST_INSERT_BEFORE(&FreeMemBlocksList, iterator,
  8034ff:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803503:	74 06                	je     80350b <insert_sorted_with_merge_freeList+0x1d0>
  803505:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803509:	75 17                	jne    803522 <insert_sorted_with_merge_freeList+0x1e7>
  80350b:	83 ec 04             	sub    $0x4,%esp
  80350e:	68 1c 44 80 00       	push   $0x80441c
  803513:	68 3a 01 00 00       	push   $0x13a
  803518:	68 8b 43 80 00       	push   $0x80438b
  80351d:	e8 80 d4 ff ff       	call   8009a2 <_panic>
  803522:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803525:	8b 50 04             	mov    0x4(%eax),%edx
  803528:	8b 45 08             	mov    0x8(%ebp),%eax
  80352b:	89 50 04             	mov    %edx,0x4(%eax)
  80352e:	8b 45 08             	mov    0x8(%ebp),%eax
  803531:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803534:	89 10                	mov    %edx,(%eax)
  803536:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803539:	8b 40 04             	mov    0x4(%eax),%eax
  80353c:	85 c0                	test   %eax,%eax
  80353e:	74 0d                	je     80354d <insert_sorted_with_merge_freeList+0x212>
  803540:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803543:	8b 40 04             	mov    0x4(%eax),%eax
  803546:	8b 55 08             	mov    0x8(%ebp),%edx
  803549:	89 10                	mov    %edx,(%eax)
  80354b:	eb 08                	jmp    803555 <insert_sorted_with_merge_freeList+0x21a>
  80354d:	8b 45 08             	mov    0x8(%ebp),%eax
  803550:	a3 38 51 80 00       	mov    %eax,0x805138
  803555:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803558:	8b 55 08             	mov    0x8(%ebp),%edx
  80355b:	89 50 04             	mov    %edx,0x4(%eax)
  80355e:	a1 44 51 80 00       	mov    0x805144,%eax
  803563:	40                   	inc    %eax
  803564:	a3 44 51 80 00       	mov    %eax,0x805144
								blockToInsert);
					}
					break;
  803569:	e9 11 02 00 00       	jmp    80377f <insert_sorted_with_merge_freeList+0x444>
				} else {
					//prev and next merge
					if (prev->sva + prev->size + blockToInsert->size
  80356e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803571:	8b 50 08             	mov    0x8(%eax),%edx
  803574:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803577:	8b 40 0c             	mov    0xc(%eax),%eax
  80357a:	01 c2                	add    %eax,%edx
  80357c:	8b 45 08             	mov    0x8(%ebp),%eax
  80357f:	8b 40 0c             	mov    0xc(%eax),%eax
  803582:	01 c2                	add    %eax,%edx
							== iterator->sva) {
  803584:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803587:	8b 40 08             	mov    0x8(%eax),%eax
								blockToInsert);
					}
					break;
				} else {
					//prev and next merge
					if (prev->sva + prev->size + blockToInsert->size
  80358a:	39 c2                	cmp    %eax,%edx
  80358c:	0f 85 bf 00 00 00    	jne    803651 <insert_sorted_with_merge_freeList+0x316>
							== iterator->sva) {
						prev->size = prev->size + blockToInsert->size
  803592:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803595:	8b 50 0c             	mov    0xc(%eax),%edx
  803598:	8b 45 08             	mov    0x8(%ebp),%eax
  80359b:	8b 40 0c             	mov    0xc(%eax),%eax
  80359e:	01 c2                	add    %eax,%edx
								+ iterator->size;
  8035a0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8035a3:	8b 40 0c             	mov    0xc(%eax),%eax
  8035a6:	01 c2                	add    %eax,%edx
					break;
				} else {
					//prev and next merge
					if (prev->sva + prev->size + blockToInsert->size
							== iterator->sva) {
						prev->size = prev->size + blockToInsert->size
  8035a8:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8035ab:	89 50 0c             	mov    %edx,0xc(%eax)
								+ iterator->size;
						LIST_REMOVE(&FreeMemBlocksList, iterator);
  8035ae:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8035b2:	75 17                	jne    8035cb <insert_sorted_with_merge_freeList+0x290>
  8035b4:	83 ec 04             	sub    $0x4,%esp
  8035b7:	68 fc 43 80 00       	push   $0x8043fc
  8035bc:	68 43 01 00 00       	push   $0x143
  8035c1:	68 8b 43 80 00       	push   $0x80438b
  8035c6:	e8 d7 d3 ff ff       	call   8009a2 <_panic>
  8035cb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8035ce:	8b 00                	mov    (%eax),%eax
  8035d0:	85 c0                	test   %eax,%eax
  8035d2:	74 10                	je     8035e4 <insert_sorted_with_merge_freeList+0x2a9>
  8035d4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8035d7:	8b 00                	mov    (%eax),%eax
  8035d9:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8035dc:	8b 52 04             	mov    0x4(%edx),%edx
  8035df:	89 50 04             	mov    %edx,0x4(%eax)
  8035e2:	eb 0b                	jmp    8035ef <insert_sorted_with_merge_freeList+0x2b4>
  8035e4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8035e7:	8b 40 04             	mov    0x4(%eax),%eax
  8035ea:	a3 3c 51 80 00       	mov    %eax,0x80513c
  8035ef:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8035f2:	8b 40 04             	mov    0x4(%eax),%eax
  8035f5:	85 c0                	test   %eax,%eax
  8035f7:	74 0f                	je     803608 <insert_sorted_with_merge_freeList+0x2cd>
  8035f9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8035fc:	8b 40 04             	mov    0x4(%eax),%eax
  8035ff:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803602:	8b 12                	mov    (%edx),%edx
  803604:	89 10                	mov    %edx,(%eax)
  803606:	eb 0a                	jmp    803612 <insert_sorted_with_merge_freeList+0x2d7>
  803608:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80360b:	8b 00                	mov    (%eax),%eax
  80360d:	a3 38 51 80 00       	mov    %eax,0x805138
  803612:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803615:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80361b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80361e:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803625:	a1 44 51 80 00       	mov    0x805144,%eax
  80362a:	48                   	dec    %eax
  80362b:	a3 44 51 80 00       	mov    %eax,0x805144
						addToAvailMemBlocksList(blockToInsert);
  803630:	83 ec 0c             	sub    $0xc,%esp
  803633:	ff 75 08             	pushl  0x8(%ebp)
  803636:	e8 80 fc ff ff       	call   8032bb <addToAvailMemBlocksList>
  80363b:	83 c4 10             	add    $0x10,%esp
						addToAvailMemBlocksList(iterator);
  80363e:	83 ec 0c             	sub    $0xc,%esp
  803641:	ff 75 f4             	pushl  -0xc(%ebp)
  803644:	e8 72 fc ff ff       	call   8032bb <addToAvailMemBlocksList>
  803649:	83 c4 10             	add    $0x10,%esp
					//Insert
					else {
						LIST_INSERT_BEFORE(&FreeMemBlocksList, iterator,
								blockToInsert);
					}
					break;
  80364c:	e9 2e 01 00 00       	jmp    80377f <insert_sorted_with_merge_freeList+0x444>
						LIST_REMOVE(&FreeMemBlocksList, iterator);
						addToAvailMemBlocksList(blockToInsert);
						addToAvailMemBlocksList(iterator);
					}
					//previous merge
					else if (prev->sva + prev->size == blockToInsert->sva) {
  803651:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803654:	8b 50 08             	mov    0x8(%eax),%edx
  803657:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80365a:	8b 40 0c             	mov    0xc(%eax),%eax
  80365d:	01 c2                	add    %eax,%edx
  80365f:	8b 45 08             	mov    0x8(%ebp),%eax
  803662:	8b 40 08             	mov    0x8(%eax),%eax
  803665:	39 c2                	cmp    %eax,%edx
  803667:	75 27                	jne    803690 <insert_sorted_with_merge_freeList+0x355>
						prev->size = prev->size + blockToInsert->size;
  803669:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80366c:	8b 50 0c             	mov    0xc(%eax),%edx
  80366f:	8b 45 08             	mov    0x8(%ebp),%eax
  803672:	8b 40 0c             	mov    0xc(%eax),%eax
  803675:	01 c2                	add    %eax,%edx
  803677:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80367a:	89 50 0c             	mov    %edx,0xc(%eax)
						addToAvailMemBlocksList(blockToInsert);
  80367d:	83 ec 0c             	sub    $0xc,%esp
  803680:	ff 75 08             	pushl  0x8(%ebp)
  803683:	e8 33 fc ff ff       	call   8032bb <addToAvailMemBlocksList>
  803688:	83 c4 10             	add    $0x10,%esp
					//Insert
					else {
						LIST_INSERT_BEFORE(&FreeMemBlocksList, iterator,
								blockToInsert);
					}
					break;
  80368b:	e9 ef 00 00 00       	jmp    80377f <insert_sorted_with_merge_freeList+0x444>
					else if (prev->sva + prev->size == blockToInsert->sva) {
						prev->size = prev->size + blockToInsert->size;
						addToAvailMemBlocksList(blockToInsert);
					}
					//next merge
					else if (blockToInsert->size + blockToInsert->sva
  803690:	8b 45 08             	mov    0x8(%ebp),%eax
  803693:	8b 50 0c             	mov    0xc(%eax),%edx
  803696:	8b 45 08             	mov    0x8(%ebp),%eax
  803699:	8b 40 08             	mov    0x8(%eax),%eax
  80369c:	01 c2                	add    %eax,%edx
							== iterator->sva) {
  80369e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8036a1:	8b 40 08             	mov    0x8(%eax),%eax
					else if (prev->sva + prev->size == blockToInsert->sva) {
						prev->size = prev->size + blockToInsert->size;
						addToAvailMemBlocksList(blockToInsert);
					}
					//next merge
					else if (blockToInsert->size + blockToInsert->sva
  8036a4:	39 c2                	cmp    %eax,%edx
  8036a6:	75 33                	jne    8036db <insert_sorted_with_merge_freeList+0x3a0>
							== iterator->sva) {
						iterator->sva = blockToInsert->sva;
  8036a8:	8b 45 08             	mov    0x8(%ebp),%eax
  8036ab:	8b 50 08             	mov    0x8(%eax),%edx
  8036ae:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8036b1:	89 50 08             	mov    %edx,0x8(%eax)
						iterator->size = iterator->size + blockToInsert->size;
  8036b4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8036b7:	8b 50 0c             	mov    0xc(%eax),%edx
  8036ba:	8b 45 08             	mov    0x8(%ebp),%eax
  8036bd:	8b 40 0c             	mov    0xc(%eax),%eax
  8036c0:	01 c2                	add    %eax,%edx
  8036c2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8036c5:	89 50 0c             	mov    %edx,0xc(%eax)
						addToAvailMemBlocksList(blockToInsert);
  8036c8:	83 ec 0c             	sub    $0xc,%esp
  8036cb:	ff 75 08             	pushl  0x8(%ebp)
  8036ce:	e8 e8 fb ff ff       	call   8032bb <addToAvailMemBlocksList>
  8036d3:	83 c4 10             	add    $0x10,%esp
					//Insert
					else {
						LIST_INSERT_BEFORE(&FreeMemBlocksList, iterator,
								blockToInsert);
					}
					break;
  8036d6:	e9 a4 00 00 00       	jmp    80377f <insert_sorted_with_merge_freeList+0x444>
						iterator->size = iterator->size + blockToInsert->size;
						addToAvailMemBlocksList(blockToInsert);
					}
					//Insert
					else {
						LIST_INSERT_BEFORE(&FreeMemBlocksList, iterator,
  8036db:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8036df:	74 06                	je     8036e7 <insert_sorted_with_merge_freeList+0x3ac>
  8036e1:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8036e5:	75 17                	jne    8036fe <insert_sorted_with_merge_freeList+0x3c3>
  8036e7:	83 ec 04             	sub    $0x4,%esp
  8036ea:	68 1c 44 80 00       	push   $0x80441c
  8036ef:	68 56 01 00 00       	push   $0x156
  8036f4:	68 8b 43 80 00       	push   $0x80438b
  8036f9:	e8 a4 d2 ff ff       	call   8009a2 <_panic>
  8036fe:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803701:	8b 50 04             	mov    0x4(%eax),%edx
  803704:	8b 45 08             	mov    0x8(%ebp),%eax
  803707:	89 50 04             	mov    %edx,0x4(%eax)
  80370a:	8b 45 08             	mov    0x8(%ebp),%eax
  80370d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803710:	89 10                	mov    %edx,(%eax)
  803712:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803715:	8b 40 04             	mov    0x4(%eax),%eax
  803718:	85 c0                	test   %eax,%eax
  80371a:	74 0d                	je     803729 <insert_sorted_with_merge_freeList+0x3ee>
  80371c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80371f:	8b 40 04             	mov    0x4(%eax),%eax
  803722:	8b 55 08             	mov    0x8(%ebp),%edx
  803725:	89 10                	mov    %edx,(%eax)
  803727:	eb 08                	jmp    803731 <insert_sorted_with_merge_freeList+0x3f6>
  803729:	8b 45 08             	mov    0x8(%ebp),%eax
  80372c:	a3 38 51 80 00       	mov    %eax,0x805138
  803731:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803734:	8b 55 08             	mov    0x8(%ebp),%edx
  803737:	89 50 04             	mov    %edx,0x4(%eax)
  80373a:	a1 44 51 80 00       	mov    0x805144,%eax
  80373f:	40                   	inc    %eax
  803740:	a3 44 51 80 00       	mov    %eax,0x805144
								blockToInsert);
					}
					break;
  803745:	eb 38                	jmp    80377f <insert_sorted_with_merge_freeList+0x444>
		} else {
			LIST_INSERT_AFTER(&FreeMemBlocksList, last, blockToInsert);
		}
	} else {
		struct MemBlock *iterator;
		LIST_FOREACH(iterator, &(FreeMemBlocksList))
  803747:	a1 40 51 80 00       	mov    0x805140,%eax
  80374c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80374f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803753:	74 07                	je     80375c <insert_sorted_with_merge_freeList+0x421>
  803755:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803758:	8b 00                	mov    (%eax),%eax
  80375a:	eb 05                	jmp    803761 <insert_sorted_with_merge_freeList+0x426>
  80375c:	b8 00 00 00 00       	mov    $0x0,%eax
  803761:	a3 40 51 80 00       	mov    %eax,0x805140
  803766:	a1 40 51 80 00       	mov    0x805140,%eax
  80376b:	85 c0                	test   %eax,%eax
  80376d:	0f 85 1a fd ff ff    	jne    80348d <insert_sorted_with_merge_freeList+0x152>
  803773:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803777:	0f 85 10 fd ff ff    	jne    80348d <insert_sorted_with_merge_freeList+0x152>
		}
	}

	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  80377d:	eb 00                	jmp    80377f <insert_sorted_with_merge_freeList+0x444>
  80377f:	90                   	nop
  803780:	c9                   	leave  
  803781:	c3                   	ret    
  803782:	66 90                	xchg   %ax,%ax

00803784 <__udivdi3>:
  803784:	55                   	push   %ebp
  803785:	57                   	push   %edi
  803786:	56                   	push   %esi
  803787:	53                   	push   %ebx
  803788:	83 ec 1c             	sub    $0x1c,%esp
  80378b:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  80378f:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  803793:	8b 7c 24 38          	mov    0x38(%esp),%edi
  803797:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  80379b:	89 ca                	mov    %ecx,%edx
  80379d:	89 f8                	mov    %edi,%eax
  80379f:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  8037a3:	85 f6                	test   %esi,%esi
  8037a5:	75 2d                	jne    8037d4 <__udivdi3+0x50>
  8037a7:	39 cf                	cmp    %ecx,%edi
  8037a9:	77 65                	ja     803810 <__udivdi3+0x8c>
  8037ab:	89 fd                	mov    %edi,%ebp
  8037ad:	85 ff                	test   %edi,%edi
  8037af:	75 0b                	jne    8037bc <__udivdi3+0x38>
  8037b1:	b8 01 00 00 00       	mov    $0x1,%eax
  8037b6:	31 d2                	xor    %edx,%edx
  8037b8:	f7 f7                	div    %edi
  8037ba:	89 c5                	mov    %eax,%ebp
  8037bc:	31 d2                	xor    %edx,%edx
  8037be:	89 c8                	mov    %ecx,%eax
  8037c0:	f7 f5                	div    %ebp
  8037c2:	89 c1                	mov    %eax,%ecx
  8037c4:	89 d8                	mov    %ebx,%eax
  8037c6:	f7 f5                	div    %ebp
  8037c8:	89 cf                	mov    %ecx,%edi
  8037ca:	89 fa                	mov    %edi,%edx
  8037cc:	83 c4 1c             	add    $0x1c,%esp
  8037cf:	5b                   	pop    %ebx
  8037d0:	5e                   	pop    %esi
  8037d1:	5f                   	pop    %edi
  8037d2:	5d                   	pop    %ebp
  8037d3:	c3                   	ret    
  8037d4:	39 ce                	cmp    %ecx,%esi
  8037d6:	77 28                	ja     803800 <__udivdi3+0x7c>
  8037d8:	0f bd fe             	bsr    %esi,%edi
  8037db:	83 f7 1f             	xor    $0x1f,%edi
  8037de:	75 40                	jne    803820 <__udivdi3+0x9c>
  8037e0:	39 ce                	cmp    %ecx,%esi
  8037e2:	72 0a                	jb     8037ee <__udivdi3+0x6a>
  8037e4:	3b 44 24 08          	cmp    0x8(%esp),%eax
  8037e8:	0f 87 9e 00 00 00    	ja     80388c <__udivdi3+0x108>
  8037ee:	b8 01 00 00 00       	mov    $0x1,%eax
  8037f3:	89 fa                	mov    %edi,%edx
  8037f5:	83 c4 1c             	add    $0x1c,%esp
  8037f8:	5b                   	pop    %ebx
  8037f9:	5e                   	pop    %esi
  8037fa:	5f                   	pop    %edi
  8037fb:	5d                   	pop    %ebp
  8037fc:	c3                   	ret    
  8037fd:	8d 76 00             	lea    0x0(%esi),%esi
  803800:	31 ff                	xor    %edi,%edi
  803802:	31 c0                	xor    %eax,%eax
  803804:	89 fa                	mov    %edi,%edx
  803806:	83 c4 1c             	add    $0x1c,%esp
  803809:	5b                   	pop    %ebx
  80380a:	5e                   	pop    %esi
  80380b:	5f                   	pop    %edi
  80380c:	5d                   	pop    %ebp
  80380d:	c3                   	ret    
  80380e:	66 90                	xchg   %ax,%ax
  803810:	89 d8                	mov    %ebx,%eax
  803812:	f7 f7                	div    %edi
  803814:	31 ff                	xor    %edi,%edi
  803816:	89 fa                	mov    %edi,%edx
  803818:	83 c4 1c             	add    $0x1c,%esp
  80381b:	5b                   	pop    %ebx
  80381c:	5e                   	pop    %esi
  80381d:	5f                   	pop    %edi
  80381e:	5d                   	pop    %ebp
  80381f:	c3                   	ret    
  803820:	bd 20 00 00 00       	mov    $0x20,%ebp
  803825:	89 eb                	mov    %ebp,%ebx
  803827:	29 fb                	sub    %edi,%ebx
  803829:	89 f9                	mov    %edi,%ecx
  80382b:	d3 e6                	shl    %cl,%esi
  80382d:	89 c5                	mov    %eax,%ebp
  80382f:	88 d9                	mov    %bl,%cl
  803831:	d3 ed                	shr    %cl,%ebp
  803833:	89 e9                	mov    %ebp,%ecx
  803835:	09 f1                	or     %esi,%ecx
  803837:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  80383b:	89 f9                	mov    %edi,%ecx
  80383d:	d3 e0                	shl    %cl,%eax
  80383f:	89 c5                	mov    %eax,%ebp
  803841:	89 d6                	mov    %edx,%esi
  803843:	88 d9                	mov    %bl,%cl
  803845:	d3 ee                	shr    %cl,%esi
  803847:	89 f9                	mov    %edi,%ecx
  803849:	d3 e2                	shl    %cl,%edx
  80384b:	8b 44 24 08          	mov    0x8(%esp),%eax
  80384f:	88 d9                	mov    %bl,%cl
  803851:	d3 e8                	shr    %cl,%eax
  803853:	09 c2                	or     %eax,%edx
  803855:	89 d0                	mov    %edx,%eax
  803857:	89 f2                	mov    %esi,%edx
  803859:	f7 74 24 0c          	divl   0xc(%esp)
  80385d:	89 d6                	mov    %edx,%esi
  80385f:	89 c3                	mov    %eax,%ebx
  803861:	f7 e5                	mul    %ebp
  803863:	39 d6                	cmp    %edx,%esi
  803865:	72 19                	jb     803880 <__udivdi3+0xfc>
  803867:	74 0b                	je     803874 <__udivdi3+0xf0>
  803869:	89 d8                	mov    %ebx,%eax
  80386b:	31 ff                	xor    %edi,%edi
  80386d:	e9 58 ff ff ff       	jmp    8037ca <__udivdi3+0x46>
  803872:	66 90                	xchg   %ax,%ax
  803874:	8b 54 24 08          	mov    0x8(%esp),%edx
  803878:	89 f9                	mov    %edi,%ecx
  80387a:	d3 e2                	shl    %cl,%edx
  80387c:	39 c2                	cmp    %eax,%edx
  80387e:	73 e9                	jae    803869 <__udivdi3+0xe5>
  803880:	8d 43 ff             	lea    -0x1(%ebx),%eax
  803883:	31 ff                	xor    %edi,%edi
  803885:	e9 40 ff ff ff       	jmp    8037ca <__udivdi3+0x46>
  80388a:	66 90                	xchg   %ax,%ax
  80388c:	31 c0                	xor    %eax,%eax
  80388e:	e9 37 ff ff ff       	jmp    8037ca <__udivdi3+0x46>
  803893:	90                   	nop

00803894 <__umoddi3>:
  803894:	55                   	push   %ebp
  803895:	57                   	push   %edi
  803896:	56                   	push   %esi
  803897:	53                   	push   %ebx
  803898:	83 ec 1c             	sub    $0x1c,%esp
  80389b:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  80389f:	8b 74 24 34          	mov    0x34(%esp),%esi
  8038a3:	8b 7c 24 38          	mov    0x38(%esp),%edi
  8038a7:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  8038ab:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8038af:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8038b3:	89 f3                	mov    %esi,%ebx
  8038b5:	89 fa                	mov    %edi,%edx
  8038b7:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8038bb:	89 34 24             	mov    %esi,(%esp)
  8038be:	85 c0                	test   %eax,%eax
  8038c0:	75 1a                	jne    8038dc <__umoddi3+0x48>
  8038c2:	39 f7                	cmp    %esi,%edi
  8038c4:	0f 86 a2 00 00 00    	jbe    80396c <__umoddi3+0xd8>
  8038ca:	89 c8                	mov    %ecx,%eax
  8038cc:	89 f2                	mov    %esi,%edx
  8038ce:	f7 f7                	div    %edi
  8038d0:	89 d0                	mov    %edx,%eax
  8038d2:	31 d2                	xor    %edx,%edx
  8038d4:	83 c4 1c             	add    $0x1c,%esp
  8038d7:	5b                   	pop    %ebx
  8038d8:	5e                   	pop    %esi
  8038d9:	5f                   	pop    %edi
  8038da:	5d                   	pop    %ebp
  8038db:	c3                   	ret    
  8038dc:	39 f0                	cmp    %esi,%eax
  8038de:	0f 87 ac 00 00 00    	ja     803990 <__umoddi3+0xfc>
  8038e4:	0f bd e8             	bsr    %eax,%ebp
  8038e7:	83 f5 1f             	xor    $0x1f,%ebp
  8038ea:	0f 84 ac 00 00 00    	je     80399c <__umoddi3+0x108>
  8038f0:	bf 20 00 00 00       	mov    $0x20,%edi
  8038f5:	29 ef                	sub    %ebp,%edi
  8038f7:	89 fe                	mov    %edi,%esi
  8038f9:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  8038fd:	89 e9                	mov    %ebp,%ecx
  8038ff:	d3 e0                	shl    %cl,%eax
  803901:	89 d7                	mov    %edx,%edi
  803903:	89 f1                	mov    %esi,%ecx
  803905:	d3 ef                	shr    %cl,%edi
  803907:	09 c7                	or     %eax,%edi
  803909:	89 e9                	mov    %ebp,%ecx
  80390b:	d3 e2                	shl    %cl,%edx
  80390d:	89 14 24             	mov    %edx,(%esp)
  803910:	89 d8                	mov    %ebx,%eax
  803912:	d3 e0                	shl    %cl,%eax
  803914:	89 c2                	mov    %eax,%edx
  803916:	8b 44 24 08          	mov    0x8(%esp),%eax
  80391a:	d3 e0                	shl    %cl,%eax
  80391c:	89 44 24 04          	mov    %eax,0x4(%esp)
  803920:	8b 44 24 08          	mov    0x8(%esp),%eax
  803924:	89 f1                	mov    %esi,%ecx
  803926:	d3 e8                	shr    %cl,%eax
  803928:	09 d0                	or     %edx,%eax
  80392a:	d3 eb                	shr    %cl,%ebx
  80392c:	89 da                	mov    %ebx,%edx
  80392e:	f7 f7                	div    %edi
  803930:	89 d3                	mov    %edx,%ebx
  803932:	f7 24 24             	mull   (%esp)
  803935:	89 c6                	mov    %eax,%esi
  803937:	89 d1                	mov    %edx,%ecx
  803939:	39 d3                	cmp    %edx,%ebx
  80393b:	0f 82 87 00 00 00    	jb     8039c8 <__umoddi3+0x134>
  803941:	0f 84 91 00 00 00    	je     8039d8 <__umoddi3+0x144>
  803947:	8b 54 24 04          	mov    0x4(%esp),%edx
  80394b:	29 f2                	sub    %esi,%edx
  80394d:	19 cb                	sbb    %ecx,%ebx
  80394f:	89 d8                	mov    %ebx,%eax
  803951:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  803955:	d3 e0                	shl    %cl,%eax
  803957:	89 e9                	mov    %ebp,%ecx
  803959:	d3 ea                	shr    %cl,%edx
  80395b:	09 d0                	or     %edx,%eax
  80395d:	89 e9                	mov    %ebp,%ecx
  80395f:	d3 eb                	shr    %cl,%ebx
  803961:	89 da                	mov    %ebx,%edx
  803963:	83 c4 1c             	add    $0x1c,%esp
  803966:	5b                   	pop    %ebx
  803967:	5e                   	pop    %esi
  803968:	5f                   	pop    %edi
  803969:	5d                   	pop    %ebp
  80396a:	c3                   	ret    
  80396b:	90                   	nop
  80396c:	89 fd                	mov    %edi,%ebp
  80396e:	85 ff                	test   %edi,%edi
  803970:	75 0b                	jne    80397d <__umoddi3+0xe9>
  803972:	b8 01 00 00 00       	mov    $0x1,%eax
  803977:	31 d2                	xor    %edx,%edx
  803979:	f7 f7                	div    %edi
  80397b:	89 c5                	mov    %eax,%ebp
  80397d:	89 f0                	mov    %esi,%eax
  80397f:	31 d2                	xor    %edx,%edx
  803981:	f7 f5                	div    %ebp
  803983:	89 c8                	mov    %ecx,%eax
  803985:	f7 f5                	div    %ebp
  803987:	89 d0                	mov    %edx,%eax
  803989:	e9 44 ff ff ff       	jmp    8038d2 <__umoddi3+0x3e>
  80398e:	66 90                	xchg   %ax,%ax
  803990:	89 c8                	mov    %ecx,%eax
  803992:	89 f2                	mov    %esi,%edx
  803994:	83 c4 1c             	add    $0x1c,%esp
  803997:	5b                   	pop    %ebx
  803998:	5e                   	pop    %esi
  803999:	5f                   	pop    %edi
  80399a:	5d                   	pop    %ebp
  80399b:	c3                   	ret    
  80399c:	3b 04 24             	cmp    (%esp),%eax
  80399f:	72 06                	jb     8039a7 <__umoddi3+0x113>
  8039a1:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  8039a5:	77 0f                	ja     8039b6 <__umoddi3+0x122>
  8039a7:	89 f2                	mov    %esi,%edx
  8039a9:	29 f9                	sub    %edi,%ecx
  8039ab:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  8039af:	89 14 24             	mov    %edx,(%esp)
  8039b2:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8039b6:	8b 44 24 04          	mov    0x4(%esp),%eax
  8039ba:	8b 14 24             	mov    (%esp),%edx
  8039bd:	83 c4 1c             	add    $0x1c,%esp
  8039c0:	5b                   	pop    %ebx
  8039c1:	5e                   	pop    %esi
  8039c2:	5f                   	pop    %edi
  8039c3:	5d                   	pop    %ebp
  8039c4:	c3                   	ret    
  8039c5:	8d 76 00             	lea    0x0(%esi),%esi
  8039c8:	2b 04 24             	sub    (%esp),%eax
  8039cb:	19 fa                	sbb    %edi,%edx
  8039cd:	89 d1                	mov    %edx,%ecx
  8039cf:	89 c6                	mov    %eax,%esi
  8039d1:	e9 71 ff ff ff       	jmp    803947 <__umoddi3+0xb3>
  8039d6:	66 90                	xchg   %ax,%ax
  8039d8:	39 44 24 04          	cmp    %eax,0x4(%esp)
  8039dc:	72 ea                	jb     8039c8 <__umoddi3+0x134>
  8039de:	89 d9                	mov    %ebx,%ecx
  8039e0:	e9 62 ff ff ff       	jmp    803947 <__umoddi3+0xb3>
