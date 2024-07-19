
obj/user/tst_malloc_2:     file format elf32-i386


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
  800031:	e8 80 03 00 00       	call   8003b6 <libmain>
1:      jmp 1b
  800036:	eb fe                	jmp    800036 <args_exist+0x5>

00800038 <_main>:
	char a;
	short b;
	int c;
};
void _main(void)
{
  800038:	55                   	push   %ebp
  800039:	89 e5                	mov    %esp,%ebp
  80003b:	57                   	push   %edi
  80003c:	81 ec 94 00 00 00    	sub    $0x94,%esp
	//Initial test to ensure it works on "PLACEMENT" not "REPLACEMENT"
	{
		uint8 fullWS = 1;
  800042:	c6 45 f7 01          	movb   $0x1,-0x9(%ebp)
		for (int i = 0; i < myEnv->page_WS_max_size; ++i)
  800046:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  80004d:	eb 29                	jmp    800078 <_main+0x40>
		{
			if (myEnv->__uptr_pws[i].empty)
  80004f:	a1 20 40 80 00       	mov    0x804020,%eax
  800054:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  80005a:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80005d:	89 d0                	mov    %edx,%eax
  80005f:	01 c0                	add    %eax,%eax
  800061:	01 d0                	add    %edx,%eax
  800063:	c1 e0 03             	shl    $0x3,%eax
  800066:	01 c8                	add    %ecx,%eax
  800068:	8a 40 04             	mov    0x4(%eax),%al
  80006b:	84 c0                	test   %al,%al
  80006d:	74 06                	je     800075 <_main+0x3d>
			{
				fullWS = 0;
  80006f:	c6 45 f7 00          	movb   $0x0,-0x9(%ebp)
				break;
  800073:	eb 12                	jmp    800087 <_main+0x4f>
void _main(void)
{
	//Initial test to ensure it works on "PLACEMENT" not "REPLACEMENT"
	{
		uint8 fullWS = 1;
		for (int i = 0; i < myEnv->page_WS_max_size; ++i)
  800075:	ff 45 f0             	incl   -0x10(%ebp)
  800078:	a1 20 40 80 00       	mov    0x804020,%eax
  80007d:	8b 50 74             	mov    0x74(%eax),%edx
  800080:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800083:	39 c2                	cmp    %eax,%edx
  800085:	77 c8                	ja     80004f <_main+0x17>
			{
				fullWS = 0;
				break;
			}
		}
		if (fullWS) panic("Please increase the WS size");
  800087:	80 7d f7 00          	cmpb   $0x0,-0x9(%ebp)
  80008b:	74 14                	je     8000a1 <_main+0x69>
  80008d:	83 ec 04             	sub    $0x4,%esp
  800090:	68 40 33 80 00       	push   $0x803340
  800095:	6a 1a                	push   $0x1a
  800097:	68 5c 33 80 00       	push   $0x80335c
  80009c:	e8 51 04 00 00       	call   8004f2 <_panic>
	}
	/*Dummy malloc to enforce the UHEAP initializations*/
	malloc(0);
  8000a1:	83 ec 0c             	sub    $0xc,%esp
  8000a4:	6a 00                	push   $0x0
  8000a6:	e8 8d 16 00 00       	call   801738 <malloc>
  8000ab:	83 c4 10             	add    $0x10,%esp
	/*=================================================*/


	int Mega = 1024*1024;
  8000ae:	c7 45 ec 00 00 10 00 	movl   $0x100000,-0x14(%ebp)
	int kilo = 1024;
  8000b5:	c7 45 e8 00 04 00 00 	movl   $0x400,-0x18(%ebp)
	char minByte = 1<<7;
  8000bc:	c6 45 e7 80          	movb   $0x80,-0x19(%ebp)
	char maxByte = 0x7F;
  8000c0:	c6 45 e6 7f          	movb   $0x7f,-0x1a(%ebp)
	short minShort = 1<<15 ;
  8000c4:	66 c7 45 e4 00 80    	movw   $0x8000,-0x1c(%ebp)
	short maxShort = 0x7FFF;
  8000ca:	66 c7 45 e2 ff 7f    	movw   $0x7fff,-0x1e(%ebp)
	int minInt = 1<<31 ;
  8000d0:	c7 45 dc 00 00 00 80 	movl   $0x80000000,-0x24(%ebp)
	int maxInt = 0x7FFFFFFF;
  8000d7:	c7 45 d8 ff ff ff 7f 	movl   $0x7fffffff,-0x28(%ebp)

	void* ptr_allocations[20] = {0};
  8000de:	8d 95 68 ff ff ff    	lea    -0x98(%ebp),%edx
  8000e4:	b9 14 00 00 00       	mov    $0x14,%ecx
  8000e9:	b8 00 00 00 00       	mov    $0x0,%eax
  8000ee:	89 d7                	mov    %edx,%edi
  8000f0:	f3 ab                	rep stos %eax,%es:(%edi)
	{
		ptr_allocations[0] = malloc(2*Mega-kilo);
  8000f2:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8000f5:	01 c0                	add    %eax,%eax
  8000f7:	2b 45 e8             	sub    -0x18(%ebp),%eax
  8000fa:	83 ec 0c             	sub    $0xc,%esp
  8000fd:	50                   	push   %eax
  8000fe:	e8 35 16 00 00       	call   801738 <malloc>
  800103:	83 c4 10             	add    $0x10,%esp
  800106:	89 85 68 ff ff ff    	mov    %eax,-0x98(%ebp)
		char *byteArr = (char *) ptr_allocations[0];
  80010c:	8b 85 68 ff ff ff    	mov    -0x98(%ebp),%eax
  800112:	89 45 d4             	mov    %eax,-0x2c(%ebp)
		int lastIndexOfByte = (2*Mega-kilo)/sizeof(char) - 1;
  800115:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800118:	01 c0                	add    %eax,%eax
  80011a:	2b 45 e8             	sub    -0x18(%ebp),%eax
  80011d:	48                   	dec    %eax
  80011e:	89 45 d0             	mov    %eax,-0x30(%ebp)
		byteArr[0] = minByte ;
  800121:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  800124:	8a 55 e7             	mov    -0x19(%ebp),%dl
  800127:	88 10                	mov    %dl,(%eax)
		byteArr[lastIndexOfByte] = maxByte ;
  800129:	8b 55 d0             	mov    -0x30(%ebp),%edx
  80012c:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80012f:	01 c2                	add    %eax,%edx
  800131:	8a 45 e6             	mov    -0x1a(%ebp),%al
  800134:	88 02                	mov    %al,(%edx)

		ptr_allocations[1] = malloc(2*Mega-kilo);
  800136:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800139:	01 c0                	add    %eax,%eax
  80013b:	2b 45 e8             	sub    -0x18(%ebp),%eax
  80013e:	83 ec 0c             	sub    $0xc,%esp
  800141:	50                   	push   %eax
  800142:	e8 f1 15 00 00       	call   801738 <malloc>
  800147:	83 c4 10             	add    $0x10,%esp
  80014a:	89 85 6c ff ff ff    	mov    %eax,-0x94(%ebp)
		short *shortArr = (short *) ptr_allocations[1];
  800150:	8b 85 6c ff ff ff    	mov    -0x94(%ebp),%eax
  800156:	89 45 cc             	mov    %eax,-0x34(%ebp)
		int lastIndexOfShort = (2*Mega-kilo)/sizeof(short) - 1;
  800159:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80015c:	01 c0                	add    %eax,%eax
  80015e:	2b 45 e8             	sub    -0x18(%ebp),%eax
  800161:	d1 e8                	shr    %eax
  800163:	48                   	dec    %eax
  800164:	89 45 c8             	mov    %eax,-0x38(%ebp)
		shortArr[0] = minShort;
  800167:	8b 55 cc             	mov    -0x34(%ebp),%edx
  80016a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80016d:	66 89 02             	mov    %ax,(%edx)
		shortArr[lastIndexOfShort] = maxShort;
  800170:	8b 45 c8             	mov    -0x38(%ebp),%eax
  800173:	01 c0                	add    %eax,%eax
  800175:	89 c2                	mov    %eax,%edx
  800177:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80017a:	01 c2                	add    %eax,%edx
  80017c:	66 8b 45 e2          	mov    -0x1e(%ebp),%ax
  800180:	66 89 02             	mov    %ax,(%edx)

		ptr_allocations[2] = malloc(3*kilo);
  800183:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800186:	89 c2                	mov    %eax,%edx
  800188:	01 d2                	add    %edx,%edx
  80018a:	01 d0                	add    %edx,%eax
  80018c:	83 ec 0c             	sub    $0xc,%esp
  80018f:	50                   	push   %eax
  800190:	e8 a3 15 00 00       	call   801738 <malloc>
  800195:	83 c4 10             	add    $0x10,%esp
  800198:	89 85 70 ff ff ff    	mov    %eax,-0x90(%ebp)
		int *intArr = (int *) ptr_allocations[2];
  80019e:	8b 85 70 ff ff ff    	mov    -0x90(%ebp),%eax
  8001a4:	89 45 c4             	mov    %eax,-0x3c(%ebp)
		int lastIndexOfInt = (2*kilo)/sizeof(int) - 1;
  8001a7:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8001aa:	01 c0                	add    %eax,%eax
  8001ac:	c1 e8 02             	shr    $0x2,%eax
  8001af:	48                   	dec    %eax
  8001b0:	89 45 c0             	mov    %eax,-0x40(%ebp)
		intArr[0] = minInt;
  8001b3:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  8001b6:	8b 55 dc             	mov    -0x24(%ebp),%edx
  8001b9:	89 10                	mov    %edx,(%eax)
		intArr[lastIndexOfInt] = maxInt;
  8001bb:	8b 45 c0             	mov    -0x40(%ebp),%eax
  8001be:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8001c5:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  8001c8:	01 c2                	add    %eax,%edx
  8001ca:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8001cd:	89 02                	mov    %eax,(%edx)

		ptr_allocations[3] = malloc(7*kilo);
  8001cf:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8001d2:	89 d0                	mov    %edx,%eax
  8001d4:	01 c0                	add    %eax,%eax
  8001d6:	01 d0                	add    %edx,%eax
  8001d8:	01 c0                	add    %eax,%eax
  8001da:	01 d0                	add    %edx,%eax
  8001dc:	83 ec 0c             	sub    $0xc,%esp
  8001df:	50                   	push   %eax
  8001e0:	e8 53 15 00 00       	call   801738 <malloc>
  8001e5:	83 c4 10             	add    $0x10,%esp
  8001e8:	89 85 74 ff ff ff    	mov    %eax,-0x8c(%ebp)
		struct MyStruct *structArr = (struct MyStruct *) ptr_allocations[3];
  8001ee:	8b 85 74 ff ff ff    	mov    -0x8c(%ebp),%eax
  8001f4:	89 45 bc             	mov    %eax,-0x44(%ebp)
		int lastIndexOfStruct = (7*kilo)/sizeof(struct MyStruct) - 1;
  8001f7:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8001fa:	89 d0                	mov    %edx,%eax
  8001fc:	01 c0                	add    %eax,%eax
  8001fe:	01 d0                	add    %edx,%eax
  800200:	01 c0                	add    %eax,%eax
  800202:	01 d0                	add    %edx,%eax
  800204:	c1 e8 03             	shr    $0x3,%eax
  800207:	48                   	dec    %eax
  800208:	89 45 b8             	mov    %eax,-0x48(%ebp)
		structArr[0].a = minByte; structArr[0].b = minShort; structArr[0].c = minInt;
  80020b:	8b 45 bc             	mov    -0x44(%ebp),%eax
  80020e:	8a 55 e7             	mov    -0x19(%ebp),%dl
  800211:	88 10                	mov    %dl,(%eax)
  800213:	8b 55 bc             	mov    -0x44(%ebp),%edx
  800216:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800219:	66 89 42 02          	mov    %ax,0x2(%edx)
  80021d:	8b 45 bc             	mov    -0x44(%ebp),%eax
  800220:	8b 55 dc             	mov    -0x24(%ebp),%edx
  800223:	89 50 04             	mov    %edx,0x4(%eax)
		structArr[lastIndexOfStruct].a = maxByte; structArr[lastIndexOfStruct].b = maxShort; structArr[lastIndexOfStruct].c = maxInt;
  800226:	8b 45 b8             	mov    -0x48(%ebp),%eax
  800229:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
  800230:	8b 45 bc             	mov    -0x44(%ebp),%eax
  800233:	01 c2                	add    %eax,%edx
  800235:	8a 45 e6             	mov    -0x1a(%ebp),%al
  800238:	88 02                	mov    %al,(%edx)
  80023a:	8b 45 b8             	mov    -0x48(%ebp),%eax
  80023d:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
  800244:	8b 45 bc             	mov    -0x44(%ebp),%eax
  800247:	01 c2                	add    %eax,%edx
  800249:	66 8b 45 e2          	mov    -0x1e(%ebp),%ax
  80024d:	66 89 42 02          	mov    %ax,0x2(%edx)
  800251:	8b 45 b8             	mov    -0x48(%ebp),%eax
  800254:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
  80025b:	8b 45 bc             	mov    -0x44(%ebp),%eax
  80025e:	01 c2                	add    %eax,%edx
  800260:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800263:	89 42 04             	mov    %eax,0x4(%edx)

		//Check that the values are successfully stored
		if (byteArr[0] 	!= minByte 	|| byteArr[lastIndexOfByte] 	!= maxByte) panic("Wrong allocation: stored values are wrongly changed!");
  800266:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  800269:	8a 00                	mov    (%eax),%al
  80026b:	3a 45 e7             	cmp    -0x19(%ebp),%al
  80026e:	75 0f                	jne    80027f <_main+0x247>
  800270:	8b 55 d0             	mov    -0x30(%ebp),%edx
  800273:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  800276:	01 d0                	add    %edx,%eax
  800278:	8a 00                	mov    (%eax),%al
  80027a:	3a 45 e6             	cmp    -0x1a(%ebp),%al
  80027d:	74 14                	je     800293 <_main+0x25b>
  80027f:	83 ec 04             	sub    $0x4,%esp
  800282:	68 70 33 80 00       	push   $0x803370
  800287:	6a 45                	push   $0x45
  800289:	68 5c 33 80 00       	push   $0x80335c
  80028e:	e8 5f 02 00 00       	call   8004f2 <_panic>
		if (shortArr[0] != minShort || shortArr[lastIndexOfShort] 	!= maxShort) panic("Wrong allocation: stored values are wrongly changed!");
  800293:	8b 45 cc             	mov    -0x34(%ebp),%eax
  800296:	66 8b 00             	mov    (%eax),%ax
  800299:	66 3b 45 e4          	cmp    -0x1c(%ebp),%ax
  80029d:	75 15                	jne    8002b4 <_main+0x27c>
  80029f:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8002a2:	01 c0                	add    %eax,%eax
  8002a4:	89 c2                	mov    %eax,%edx
  8002a6:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8002a9:	01 d0                	add    %edx,%eax
  8002ab:	66 8b 00             	mov    (%eax),%ax
  8002ae:	66 3b 45 e2          	cmp    -0x1e(%ebp),%ax
  8002b2:	74 14                	je     8002c8 <_main+0x290>
  8002b4:	83 ec 04             	sub    $0x4,%esp
  8002b7:	68 70 33 80 00       	push   $0x803370
  8002bc:	6a 46                	push   $0x46
  8002be:	68 5c 33 80 00       	push   $0x80335c
  8002c3:	e8 2a 02 00 00       	call   8004f2 <_panic>
		if (intArr[0] 	!= minInt 	|| intArr[lastIndexOfInt] 		!= maxInt) panic("Wrong allocation: stored values are wrongly changed!");
  8002c8:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  8002cb:	8b 00                	mov    (%eax),%eax
  8002cd:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  8002d0:	75 16                	jne    8002e8 <_main+0x2b0>
  8002d2:	8b 45 c0             	mov    -0x40(%ebp),%eax
  8002d5:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8002dc:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  8002df:	01 d0                	add    %edx,%eax
  8002e1:	8b 00                	mov    (%eax),%eax
  8002e3:	3b 45 d8             	cmp    -0x28(%ebp),%eax
  8002e6:	74 14                	je     8002fc <_main+0x2c4>
  8002e8:	83 ec 04             	sub    $0x4,%esp
  8002eb:	68 70 33 80 00       	push   $0x803370
  8002f0:	6a 47                	push   $0x47
  8002f2:	68 5c 33 80 00       	push   $0x80335c
  8002f7:	e8 f6 01 00 00       	call   8004f2 <_panic>

		if (structArr[0].a != minByte 	|| structArr[lastIndexOfStruct].a != maxByte) 	panic("Wrong allocation: stored values are wrongly changed!");
  8002fc:	8b 45 bc             	mov    -0x44(%ebp),%eax
  8002ff:	8a 00                	mov    (%eax),%al
  800301:	3a 45 e7             	cmp    -0x19(%ebp),%al
  800304:	75 16                	jne    80031c <_main+0x2e4>
  800306:	8b 45 b8             	mov    -0x48(%ebp),%eax
  800309:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
  800310:	8b 45 bc             	mov    -0x44(%ebp),%eax
  800313:	01 d0                	add    %edx,%eax
  800315:	8a 00                	mov    (%eax),%al
  800317:	3a 45 e6             	cmp    -0x1a(%ebp),%al
  80031a:	74 14                	je     800330 <_main+0x2f8>
  80031c:	83 ec 04             	sub    $0x4,%esp
  80031f:	68 70 33 80 00       	push   $0x803370
  800324:	6a 49                	push   $0x49
  800326:	68 5c 33 80 00       	push   $0x80335c
  80032b:	e8 c2 01 00 00       	call   8004f2 <_panic>
		if (structArr[0].b != minShort 	|| structArr[lastIndexOfStruct].b != maxShort) 	panic("Wrong allocation: stored values are wrongly changed!");
  800330:	8b 45 bc             	mov    -0x44(%ebp),%eax
  800333:	66 8b 40 02          	mov    0x2(%eax),%ax
  800337:	66 3b 45 e4          	cmp    -0x1c(%ebp),%ax
  80033b:	75 19                	jne    800356 <_main+0x31e>
  80033d:	8b 45 b8             	mov    -0x48(%ebp),%eax
  800340:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
  800347:	8b 45 bc             	mov    -0x44(%ebp),%eax
  80034a:	01 d0                	add    %edx,%eax
  80034c:	66 8b 40 02          	mov    0x2(%eax),%ax
  800350:	66 3b 45 e2          	cmp    -0x1e(%ebp),%ax
  800354:	74 14                	je     80036a <_main+0x332>
  800356:	83 ec 04             	sub    $0x4,%esp
  800359:	68 70 33 80 00       	push   $0x803370
  80035e:	6a 4a                	push   $0x4a
  800360:	68 5c 33 80 00       	push   $0x80335c
  800365:	e8 88 01 00 00       	call   8004f2 <_panic>
		if (structArr[0].c != minInt 	|| structArr[lastIndexOfStruct].c != maxInt) 	panic("Wrong allocation: stored values are wrongly changed!");
  80036a:	8b 45 bc             	mov    -0x44(%ebp),%eax
  80036d:	8b 40 04             	mov    0x4(%eax),%eax
  800370:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  800373:	75 17                	jne    80038c <_main+0x354>
  800375:	8b 45 b8             	mov    -0x48(%ebp),%eax
  800378:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
  80037f:	8b 45 bc             	mov    -0x44(%ebp),%eax
  800382:	01 d0                	add    %edx,%eax
  800384:	8b 40 04             	mov    0x4(%eax),%eax
  800387:	3b 45 d8             	cmp    -0x28(%ebp),%eax
  80038a:	74 14                	je     8003a0 <_main+0x368>
  80038c:	83 ec 04             	sub    $0x4,%esp
  80038f:	68 70 33 80 00       	push   $0x803370
  800394:	6a 4b                	push   $0x4b
  800396:	68 5c 33 80 00       	push   $0x80335c
  80039b:	e8 52 01 00 00       	call   8004f2 <_panic>


	}

	cprintf("Congratulations!! test malloc (2) completed successfully.\n");
  8003a0:	83 ec 0c             	sub    $0xc,%esp
  8003a3:	68 a8 33 80 00       	push   $0x8033a8
  8003a8:	e8 f9 03 00 00       	call   8007a6 <cprintf>
  8003ad:	83 c4 10             	add    $0x10,%esp

	return;
  8003b0:	90                   	nop
}
  8003b1:	8b 7d fc             	mov    -0x4(%ebp),%edi
  8003b4:	c9                   	leave  
  8003b5:	c3                   	ret    

008003b6 <libmain>:
volatile struct Env *myEnv = NULL;
volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";

void
libmain(int argc, char **argv)
{
  8003b6:	55                   	push   %ebp
  8003b7:	89 e5                	mov    %esp,%ebp
  8003b9:	83 ec 18             	sub    $0x18,%esp
	int envIndex = sys_getenvindex();
  8003bc:	e8 63 1a 00 00       	call   801e24 <sys_getenvindex>
  8003c1:	89 45 f4             	mov    %eax,-0xc(%ebp)
	myEnv = &(envs[envIndex]);
  8003c4:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8003c7:	89 d0                	mov    %edx,%eax
  8003c9:	c1 e0 03             	shl    $0x3,%eax
  8003cc:	01 d0                	add    %edx,%eax
  8003ce:	01 c0                	add    %eax,%eax
  8003d0:	01 d0                	add    %edx,%eax
  8003d2:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8003d9:	01 d0                	add    %edx,%eax
  8003db:	c1 e0 04             	shl    $0x4,%eax
  8003de:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8003e3:	a3 20 40 80 00       	mov    %eax,0x804020

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  8003e8:	a1 20 40 80 00       	mov    0x804020,%eax
  8003ed:	8a 80 5c 05 00 00    	mov    0x55c(%eax),%al
  8003f3:	84 c0                	test   %al,%al
  8003f5:	74 0f                	je     800406 <libmain+0x50>
		binaryname = myEnv->prog_name;
  8003f7:	a1 20 40 80 00       	mov    0x804020,%eax
  8003fc:	05 5c 05 00 00       	add    $0x55c,%eax
  800401:	a3 00 40 80 00       	mov    %eax,0x804000

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800406:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80040a:	7e 0a                	jle    800416 <libmain+0x60>
		binaryname = argv[0];
  80040c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80040f:	8b 00                	mov    (%eax),%eax
  800411:	a3 00 40 80 00       	mov    %eax,0x804000

	// call user main routine
	_main(argc, argv);
  800416:	83 ec 08             	sub    $0x8,%esp
  800419:	ff 75 0c             	pushl  0xc(%ebp)
  80041c:	ff 75 08             	pushl  0x8(%ebp)
  80041f:	e8 14 fc ff ff       	call   800038 <_main>
  800424:	83 c4 10             	add    $0x10,%esp



	sys_disable_interrupt();
  800427:	e8 05 18 00 00       	call   801c31 <sys_disable_interrupt>
	cprintf("**************************************\n");
  80042c:	83 ec 0c             	sub    $0xc,%esp
  80042f:	68 fc 33 80 00       	push   $0x8033fc
  800434:	e8 6d 03 00 00       	call   8007a6 <cprintf>
  800439:	83 c4 10             	add    $0x10,%esp
	cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  80043c:	a1 20 40 80 00       	mov    0x804020,%eax
  800441:	8b 90 44 05 00 00    	mov    0x544(%eax),%edx
  800447:	a1 20 40 80 00       	mov    0x804020,%eax
  80044c:	8b 80 34 05 00 00    	mov    0x534(%eax),%eax
  800452:	83 ec 04             	sub    $0x4,%esp
  800455:	52                   	push   %edx
  800456:	50                   	push   %eax
  800457:	68 24 34 80 00       	push   $0x803424
  80045c:	e8 45 03 00 00       	call   8007a6 <cprintf>
  800461:	83 c4 10             	add    $0x10,%esp
	cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  800464:	a1 20 40 80 00       	mov    0x804020,%eax
  800469:	8b 88 54 05 00 00    	mov    0x554(%eax),%ecx
  80046f:	a1 20 40 80 00       	mov    0x804020,%eax
  800474:	8b 90 50 05 00 00    	mov    0x550(%eax),%edx
  80047a:	a1 20 40 80 00       	mov    0x804020,%eax
  80047f:	8b 80 4c 05 00 00    	mov    0x54c(%eax),%eax
  800485:	51                   	push   %ecx
  800486:	52                   	push   %edx
  800487:	50                   	push   %eax
  800488:	68 4c 34 80 00       	push   $0x80344c
  80048d:	e8 14 03 00 00       	call   8007a6 <cprintf>
  800492:	83 c4 10             	add    $0x10,%esp
	//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
	cprintf("Num of clocks = %d\n", myEnv->nClocks);
  800495:	a1 20 40 80 00       	mov    0x804020,%eax
  80049a:	8b 80 a4 05 00 00    	mov    0x5a4(%eax),%eax
  8004a0:	83 ec 08             	sub    $0x8,%esp
  8004a3:	50                   	push   %eax
  8004a4:	68 a4 34 80 00       	push   $0x8034a4
  8004a9:	e8 f8 02 00 00       	call   8007a6 <cprintf>
  8004ae:	83 c4 10             	add    $0x10,%esp
	cprintf("**************************************\n");
  8004b1:	83 ec 0c             	sub    $0xc,%esp
  8004b4:	68 fc 33 80 00       	push   $0x8033fc
  8004b9:	e8 e8 02 00 00       	call   8007a6 <cprintf>
  8004be:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  8004c1:	e8 85 17 00 00       	call   801c4b <sys_enable_interrupt>

	// exit gracefully
	exit();
  8004c6:	e8 19 00 00 00       	call   8004e4 <exit>
}
  8004cb:	90                   	nop
  8004cc:	c9                   	leave  
  8004cd:	c3                   	ret    

008004ce <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  8004ce:	55                   	push   %ebp
  8004cf:	89 e5                	mov    %esp,%ebp
  8004d1:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  8004d4:	83 ec 0c             	sub    $0xc,%esp
  8004d7:	6a 00                	push   $0x0
  8004d9:	e8 12 19 00 00       	call   801df0 <sys_destroy_env>
  8004de:	83 c4 10             	add    $0x10,%esp
}
  8004e1:	90                   	nop
  8004e2:	c9                   	leave  
  8004e3:	c3                   	ret    

008004e4 <exit>:

void
exit(void)
{
  8004e4:	55                   	push   %ebp
  8004e5:	89 e5                	mov    %esp,%ebp
  8004e7:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  8004ea:	e8 67 19 00 00       	call   801e56 <sys_exit_env>
}
  8004ef:	90                   	nop
  8004f0:	c9                   	leave  
  8004f1:	c3                   	ret    

008004f2 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  8004f2:	55                   	push   %ebp
  8004f3:	89 e5                	mov    %esp,%ebp
  8004f5:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  8004f8:	8d 45 10             	lea    0x10(%ebp),%eax
  8004fb:	83 c0 04             	add    $0x4,%eax
  8004fe:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  800501:	a1 5c 41 80 00       	mov    0x80415c,%eax
  800506:	85 c0                	test   %eax,%eax
  800508:	74 16                	je     800520 <_panic+0x2e>
		cprintf("%s: ", argv0);
  80050a:	a1 5c 41 80 00       	mov    0x80415c,%eax
  80050f:	83 ec 08             	sub    $0x8,%esp
  800512:	50                   	push   %eax
  800513:	68 b8 34 80 00       	push   $0x8034b8
  800518:	e8 89 02 00 00       	call   8007a6 <cprintf>
  80051d:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  800520:	a1 00 40 80 00       	mov    0x804000,%eax
  800525:	ff 75 0c             	pushl  0xc(%ebp)
  800528:	ff 75 08             	pushl  0x8(%ebp)
  80052b:	50                   	push   %eax
  80052c:	68 bd 34 80 00       	push   $0x8034bd
  800531:	e8 70 02 00 00       	call   8007a6 <cprintf>
  800536:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  800539:	8b 45 10             	mov    0x10(%ebp),%eax
  80053c:	83 ec 08             	sub    $0x8,%esp
  80053f:	ff 75 f4             	pushl  -0xc(%ebp)
  800542:	50                   	push   %eax
  800543:	e8 f3 01 00 00       	call   80073b <vcprintf>
  800548:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  80054b:	83 ec 08             	sub    $0x8,%esp
  80054e:	6a 00                	push   $0x0
  800550:	68 d9 34 80 00       	push   $0x8034d9
  800555:	e8 e1 01 00 00       	call   80073b <vcprintf>
  80055a:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  80055d:	e8 82 ff ff ff       	call   8004e4 <exit>

	// should not return here
	while (1) ;
  800562:	eb fe                	jmp    800562 <_panic+0x70>

00800564 <CheckWSWithoutLastIndex>:
}

void CheckWSWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  800564:	55                   	push   %ebp
  800565:	89 e5                	mov    %esp,%ebp
  800567:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  80056a:	a1 20 40 80 00       	mov    0x804020,%eax
  80056f:	8b 50 74             	mov    0x74(%eax),%edx
  800572:	8b 45 0c             	mov    0xc(%ebp),%eax
  800575:	39 c2                	cmp    %eax,%edx
  800577:	74 14                	je     80058d <CheckWSWithoutLastIndex+0x29>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  800579:	83 ec 04             	sub    $0x4,%esp
  80057c:	68 dc 34 80 00       	push   $0x8034dc
  800581:	6a 26                	push   $0x26
  800583:	68 28 35 80 00       	push   $0x803528
  800588:	e8 65 ff ff ff       	call   8004f2 <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  80058d:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  800594:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  80059b:	e9 c2 00 00 00       	jmp    800662 <CheckWSWithoutLastIndex+0xfe>
		if (expectedPages[e] == 0) {
  8005a0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8005a3:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8005aa:	8b 45 08             	mov    0x8(%ebp),%eax
  8005ad:	01 d0                	add    %edx,%eax
  8005af:	8b 00                	mov    (%eax),%eax
  8005b1:	85 c0                	test   %eax,%eax
  8005b3:	75 08                	jne    8005bd <CheckWSWithoutLastIndex+0x59>
			expectedNumOfEmptyLocs++;
  8005b5:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  8005b8:	e9 a2 00 00 00       	jmp    80065f <CheckWSWithoutLastIndex+0xfb>
		}
		int found = 0;
  8005bd:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8005c4:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  8005cb:	eb 69                	jmp    800636 <CheckWSWithoutLastIndex+0xd2>
			if (myEnv->__uptr_pws[w].empty == 0) {
  8005cd:	a1 20 40 80 00       	mov    0x804020,%eax
  8005d2:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  8005d8:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8005db:	89 d0                	mov    %edx,%eax
  8005dd:	01 c0                	add    %eax,%eax
  8005df:	01 d0                	add    %edx,%eax
  8005e1:	c1 e0 03             	shl    $0x3,%eax
  8005e4:	01 c8                	add    %ecx,%eax
  8005e6:	8a 40 04             	mov    0x4(%eax),%al
  8005e9:	84 c0                	test   %al,%al
  8005eb:	75 46                	jne    800633 <CheckWSWithoutLastIndex+0xcf>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  8005ed:	a1 20 40 80 00       	mov    0x804020,%eax
  8005f2:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  8005f8:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8005fb:	89 d0                	mov    %edx,%eax
  8005fd:	01 c0                	add    %eax,%eax
  8005ff:	01 d0                	add    %edx,%eax
  800601:	c1 e0 03             	shl    $0x3,%eax
  800604:	01 c8                	add    %ecx,%eax
  800606:	8b 00                	mov    (%eax),%eax
  800608:	89 45 dc             	mov    %eax,-0x24(%ebp)
  80060b:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80060e:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800613:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  800615:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800618:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  80061f:	8b 45 08             	mov    0x8(%ebp),%eax
  800622:	01 c8                	add    %ecx,%eax
  800624:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  800626:	39 c2                	cmp    %eax,%edx
  800628:	75 09                	jne    800633 <CheckWSWithoutLastIndex+0xcf>
						== expectedPages[e]) {
					found = 1;
  80062a:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  800631:	eb 12                	jmp    800645 <CheckWSWithoutLastIndex+0xe1>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800633:	ff 45 e8             	incl   -0x18(%ebp)
  800636:	a1 20 40 80 00       	mov    0x804020,%eax
  80063b:	8b 50 74             	mov    0x74(%eax),%edx
  80063e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800641:	39 c2                	cmp    %eax,%edx
  800643:	77 88                	ja     8005cd <CheckWSWithoutLastIndex+0x69>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  800645:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  800649:	75 14                	jne    80065f <CheckWSWithoutLastIndex+0xfb>
			panic(
  80064b:	83 ec 04             	sub    $0x4,%esp
  80064e:	68 34 35 80 00       	push   $0x803534
  800653:	6a 3a                	push   $0x3a
  800655:	68 28 35 80 00       	push   $0x803528
  80065a:	e8 93 fe ff ff       	call   8004f2 <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  80065f:	ff 45 f0             	incl   -0x10(%ebp)
  800662:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800665:	3b 45 0c             	cmp    0xc(%ebp),%eax
  800668:	0f 8c 32 ff ff ff    	jl     8005a0 <CheckWSWithoutLastIndex+0x3c>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  80066e:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800675:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  80067c:	eb 26                	jmp    8006a4 <CheckWSWithoutLastIndex+0x140>
		if (myEnv->__uptr_pws[w].empty == 1) {
  80067e:	a1 20 40 80 00       	mov    0x804020,%eax
  800683:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  800689:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80068c:	89 d0                	mov    %edx,%eax
  80068e:	01 c0                	add    %eax,%eax
  800690:	01 d0                	add    %edx,%eax
  800692:	c1 e0 03             	shl    $0x3,%eax
  800695:	01 c8                	add    %ecx,%eax
  800697:	8a 40 04             	mov    0x4(%eax),%al
  80069a:	3c 01                	cmp    $0x1,%al
  80069c:	75 03                	jne    8006a1 <CheckWSWithoutLastIndex+0x13d>
			actualNumOfEmptyLocs++;
  80069e:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8006a1:	ff 45 e0             	incl   -0x20(%ebp)
  8006a4:	a1 20 40 80 00       	mov    0x804020,%eax
  8006a9:	8b 50 74             	mov    0x74(%eax),%edx
  8006ac:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8006af:	39 c2                	cmp    %eax,%edx
  8006b1:	77 cb                	ja     80067e <CheckWSWithoutLastIndex+0x11a>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  8006b3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8006b6:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  8006b9:	74 14                	je     8006cf <CheckWSWithoutLastIndex+0x16b>
		panic(
  8006bb:	83 ec 04             	sub    $0x4,%esp
  8006be:	68 88 35 80 00       	push   $0x803588
  8006c3:	6a 44                	push   $0x44
  8006c5:	68 28 35 80 00       	push   $0x803528
  8006ca:	e8 23 fe ff ff       	call   8004f2 <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  8006cf:	90                   	nop
  8006d0:	c9                   	leave  
  8006d1:	c3                   	ret    

008006d2 <putch>:
};

//2017:
uint8 printProgName = 0;

static void putch(int ch, struct printbuf *b) {
  8006d2:	55                   	push   %ebp
  8006d3:	89 e5                	mov    %esp,%ebp
  8006d5:	83 ec 08             	sub    $0x8,%esp
	b->buf[b->idx++] = ch;
  8006d8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8006db:	8b 00                	mov    (%eax),%eax
  8006dd:	8d 48 01             	lea    0x1(%eax),%ecx
  8006e0:	8b 55 0c             	mov    0xc(%ebp),%edx
  8006e3:	89 0a                	mov    %ecx,(%edx)
  8006e5:	8b 55 08             	mov    0x8(%ebp),%edx
  8006e8:	88 d1                	mov    %dl,%cl
  8006ea:	8b 55 0c             	mov    0xc(%ebp),%edx
  8006ed:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  8006f1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8006f4:	8b 00                	mov    (%eax),%eax
  8006f6:	3d ff 00 00 00       	cmp    $0xff,%eax
  8006fb:	75 2c                	jne    800729 <putch+0x57>
		sys_cputs(b->buf, b->idx, printProgName);
  8006fd:	a0 24 40 80 00       	mov    0x804024,%al
  800702:	0f b6 c0             	movzbl %al,%eax
  800705:	8b 55 0c             	mov    0xc(%ebp),%edx
  800708:	8b 12                	mov    (%edx),%edx
  80070a:	89 d1                	mov    %edx,%ecx
  80070c:	8b 55 0c             	mov    0xc(%ebp),%edx
  80070f:	83 c2 08             	add    $0x8,%edx
  800712:	83 ec 04             	sub    $0x4,%esp
  800715:	50                   	push   %eax
  800716:	51                   	push   %ecx
  800717:	52                   	push   %edx
  800718:	e8 66 13 00 00       	call   801a83 <sys_cputs>
  80071d:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  800720:	8b 45 0c             	mov    0xc(%ebp),%eax
  800723:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  800729:	8b 45 0c             	mov    0xc(%ebp),%eax
  80072c:	8b 40 04             	mov    0x4(%eax),%eax
  80072f:	8d 50 01             	lea    0x1(%eax),%edx
  800732:	8b 45 0c             	mov    0xc(%ebp),%eax
  800735:	89 50 04             	mov    %edx,0x4(%eax)
}
  800738:	90                   	nop
  800739:	c9                   	leave  
  80073a:	c3                   	ret    

0080073b <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  80073b:	55                   	push   %ebp
  80073c:	89 e5                	mov    %esp,%ebp
  80073e:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  800744:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  80074b:	00 00 00 
	b.cnt = 0;
  80074e:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800755:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  800758:	ff 75 0c             	pushl  0xc(%ebp)
  80075b:	ff 75 08             	pushl  0x8(%ebp)
  80075e:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800764:	50                   	push   %eax
  800765:	68 d2 06 80 00       	push   $0x8006d2
  80076a:	e8 11 02 00 00       	call   800980 <vprintfmt>
  80076f:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName);
  800772:	a0 24 40 80 00       	mov    0x804024,%al
  800777:	0f b6 c0             	movzbl %al,%eax
  80077a:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  800780:	83 ec 04             	sub    $0x4,%esp
  800783:	50                   	push   %eax
  800784:	52                   	push   %edx
  800785:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  80078b:	83 c0 08             	add    $0x8,%eax
  80078e:	50                   	push   %eax
  80078f:	e8 ef 12 00 00       	call   801a83 <sys_cputs>
  800794:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  800797:	c6 05 24 40 80 00 00 	movb   $0x0,0x804024
	return b.cnt;
  80079e:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  8007a4:	c9                   	leave  
  8007a5:	c3                   	ret    

008007a6 <cprintf>:

int cprintf(const char *fmt, ...) {
  8007a6:	55                   	push   %ebp
  8007a7:	89 e5                	mov    %esp,%ebp
  8007a9:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  8007ac:	c6 05 24 40 80 00 01 	movb   $0x1,0x804024
	va_start(ap, fmt);
  8007b3:	8d 45 0c             	lea    0xc(%ebp),%eax
  8007b6:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  8007b9:	8b 45 08             	mov    0x8(%ebp),%eax
  8007bc:	83 ec 08             	sub    $0x8,%esp
  8007bf:	ff 75 f4             	pushl  -0xc(%ebp)
  8007c2:	50                   	push   %eax
  8007c3:	e8 73 ff ff ff       	call   80073b <vcprintf>
  8007c8:	83 c4 10             	add    $0x10,%esp
  8007cb:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  8007ce:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8007d1:	c9                   	leave  
  8007d2:	c3                   	ret    

008007d3 <atomic_cprintf>:

int atomic_cprintf(const char *fmt, ...) {
  8007d3:	55                   	push   %ebp
  8007d4:	89 e5                	mov    %esp,%ebp
  8007d6:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  8007d9:	e8 53 14 00 00       	call   801c31 <sys_disable_interrupt>
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  8007de:	8d 45 0c             	lea    0xc(%ebp),%eax
  8007e1:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  8007e4:	8b 45 08             	mov    0x8(%ebp),%eax
  8007e7:	83 ec 08             	sub    $0x8,%esp
  8007ea:	ff 75 f4             	pushl  -0xc(%ebp)
  8007ed:	50                   	push   %eax
  8007ee:	e8 48 ff ff ff       	call   80073b <vcprintf>
  8007f3:	83 c4 10             	add    $0x10,%esp
  8007f6:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	sys_enable_interrupt();
  8007f9:	e8 4d 14 00 00       	call   801c4b <sys_enable_interrupt>
	return cnt;
  8007fe:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800801:	c9                   	leave  
  800802:	c3                   	ret    

00800803 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800803:	55                   	push   %ebp
  800804:	89 e5                	mov    %esp,%ebp
  800806:	53                   	push   %ebx
  800807:	83 ec 14             	sub    $0x14,%esp
  80080a:	8b 45 10             	mov    0x10(%ebp),%eax
  80080d:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800810:	8b 45 14             	mov    0x14(%ebp),%eax
  800813:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800816:	8b 45 18             	mov    0x18(%ebp),%eax
  800819:	ba 00 00 00 00       	mov    $0x0,%edx
  80081e:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800821:	77 55                	ja     800878 <printnum+0x75>
  800823:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800826:	72 05                	jb     80082d <printnum+0x2a>
  800828:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80082b:	77 4b                	ja     800878 <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  80082d:	8b 45 1c             	mov    0x1c(%ebp),%eax
  800830:	8d 58 ff             	lea    -0x1(%eax),%ebx
  800833:	8b 45 18             	mov    0x18(%ebp),%eax
  800836:	ba 00 00 00 00       	mov    $0x0,%edx
  80083b:	52                   	push   %edx
  80083c:	50                   	push   %eax
  80083d:	ff 75 f4             	pushl  -0xc(%ebp)
  800840:	ff 75 f0             	pushl  -0x10(%ebp)
  800843:	e8 84 28 00 00       	call   8030cc <__udivdi3>
  800848:	83 c4 10             	add    $0x10,%esp
  80084b:	83 ec 04             	sub    $0x4,%esp
  80084e:	ff 75 20             	pushl  0x20(%ebp)
  800851:	53                   	push   %ebx
  800852:	ff 75 18             	pushl  0x18(%ebp)
  800855:	52                   	push   %edx
  800856:	50                   	push   %eax
  800857:	ff 75 0c             	pushl  0xc(%ebp)
  80085a:	ff 75 08             	pushl  0x8(%ebp)
  80085d:	e8 a1 ff ff ff       	call   800803 <printnum>
  800862:	83 c4 20             	add    $0x20,%esp
  800865:	eb 1a                	jmp    800881 <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800867:	83 ec 08             	sub    $0x8,%esp
  80086a:	ff 75 0c             	pushl  0xc(%ebp)
  80086d:	ff 75 20             	pushl  0x20(%ebp)
  800870:	8b 45 08             	mov    0x8(%ebp),%eax
  800873:	ff d0                	call   *%eax
  800875:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800878:	ff 4d 1c             	decl   0x1c(%ebp)
  80087b:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  80087f:	7f e6                	jg     800867 <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800881:	8b 4d 18             	mov    0x18(%ebp),%ecx
  800884:	bb 00 00 00 00       	mov    $0x0,%ebx
  800889:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80088c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80088f:	53                   	push   %ebx
  800890:	51                   	push   %ecx
  800891:	52                   	push   %edx
  800892:	50                   	push   %eax
  800893:	e8 44 29 00 00       	call   8031dc <__umoddi3>
  800898:	83 c4 10             	add    $0x10,%esp
  80089b:	05 f4 37 80 00       	add    $0x8037f4,%eax
  8008a0:	8a 00                	mov    (%eax),%al
  8008a2:	0f be c0             	movsbl %al,%eax
  8008a5:	83 ec 08             	sub    $0x8,%esp
  8008a8:	ff 75 0c             	pushl  0xc(%ebp)
  8008ab:	50                   	push   %eax
  8008ac:	8b 45 08             	mov    0x8(%ebp),%eax
  8008af:	ff d0                	call   *%eax
  8008b1:	83 c4 10             	add    $0x10,%esp
}
  8008b4:	90                   	nop
  8008b5:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8008b8:	c9                   	leave  
  8008b9:	c3                   	ret    

008008ba <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  8008ba:	55                   	push   %ebp
  8008bb:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  8008bd:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  8008c1:	7e 1c                	jle    8008df <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  8008c3:	8b 45 08             	mov    0x8(%ebp),%eax
  8008c6:	8b 00                	mov    (%eax),%eax
  8008c8:	8d 50 08             	lea    0x8(%eax),%edx
  8008cb:	8b 45 08             	mov    0x8(%ebp),%eax
  8008ce:	89 10                	mov    %edx,(%eax)
  8008d0:	8b 45 08             	mov    0x8(%ebp),%eax
  8008d3:	8b 00                	mov    (%eax),%eax
  8008d5:	83 e8 08             	sub    $0x8,%eax
  8008d8:	8b 50 04             	mov    0x4(%eax),%edx
  8008db:	8b 00                	mov    (%eax),%eax
  8008dd:	eb 40                	jmp    80091f <getuint+0x65>
	else if (lflag)
  8008df:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8008e3:	74 1e                	je     800903 <getuint+0x49>
		return va_arg(*ap, unsigned long);
  8008e5:	8b 45 08             	mov    0x8(%ebp),%eax
  8008e8:	8b 00                	mov    (%eax),%eax
  8008ea:	8d 50 04             	lea    0x4(%eax),%edx
  8008ed:	8b 45 08             	mov    0x8(%ebp),%eax
  8008f0:	89 10                	mov    %edx,(%eax)
  8008f2:	8b 45 08             	mov    0x8(%ebp),%eax
  8008f5:	8b 00                	mov    (%eax),%eax
  8008f7:	83 e8 04             	sub    $0x4,%eax
  8008fa:	8b 00                	mov    (%eax),%eax
  8008fc:	ba 00 00 00 00       	mov    $0x0,%edx
  800901:	eb 1c                	jmp    80091f <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  800903:	8b 45 08             	mov    0x8(%ebp),%eax
  800906:	8b 00                	mov    (%eax),%eax
  800908:	8d 50 04             	lea    0x4(%eax),%edx
  80090b:	8b 45 08             	mov    0x8(%ebp),%eax
  80090e:	89 10                	mov    %edx,(%eax)
  800910:	8b 45 08             	mov    0x8(%ebp),%eax
  800913:	8b 00                	mov    (%eax),%eax
  800915:	83 e8 04             	sub    $0x4,%eax
  800918:	8b 00                	mov    (%eax),%eax
  80091a:	ba 00 00 00 00       	mov    $0x0,%edx
}
  80091f:	5d                   	pop    %ebp
  800920:	c3                   	ret    

00800921 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  800921:	55                   	push   %ebp
  800922:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800924:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800928:	7e 1c                	jle    800946 <getint+0x25>
		return va_arg(*ap, long long);
  80092a:	8b 45 08             	mov    0x8(%ebp),%eax
  80092d:	8b 00                	mov    (%eax),%eax
  80092f:	8d 50 08             	lea    0x8(%eax),%edx
  800932:	8b 45 08             	mov    0x8(%ebp),%eax
  800935:	89 10                	mov    %edx,(%eax)
  800937:	8b 45 08             	mov    0x8(%ebp),%eax
  80093a:	8b 00                	mov    (%eax),%eax
  80093c:	83 e8 08             	sub    $0x8,%eax
  80093f:	8b 50 04             	mov    0x4(%eax),%edx
  800942:	8b 00                	mov    (%eax),%eax
  800944:	eb 38                	jmp    80097e <getint+0x5d>
	else if (lflag)
  800946:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80094a:	74 1a                	je     800966 <getint+0x45>
		return va_arg(*ap, long);
  80094c:	8b 45 08             	mov    0x8(%ebp),%eax
  80094f:	8b 00                	mov    (%eax),%eax
  800951:	8d 50 04             	lea    0x4(%eax),%edx
  800954:	8b 45 08             	mov    0x8(%ebp),%eax
  800957:	89 10                	mov    %edx,(%eax)
  800959:	8b 45 08             	mov    0x8(%ebp),%eax
  80095c:	8b 00                	mov    (%eax),%eax
  80095e:	83 e8 04             	sub    $0x4,%eax
  800961:	8b 00                	mov    (%eax),%eax
  800963:	99                   	cltd   
  800964:	eb 18                	jmp    80097e <getint+0x5d>
	else
		return va_arg(*ap, int);
  800966:	8b 45 08             	mov    0x8(%ebp),%eax
  800969:	8b 00                	mov    (%eax),%eax
  80096b:	8d 50 04             	lea    0x4(%eax),%edx
  80096e:	8b 45 08             	mov    0x8(%ebp),%eax
  800971:	89 10                	mov    %edx,(%eax)
  800973:	8b 45 08             	mov    0x8(%ebp),%eax
  800976:	8b 00                	mov    (%eax),%eax
  800978:	83 e8 04             	sub    $0x4,%eax
  80097b:	8b 00                	mov    (%eax),%eax
  80097d:	99                   	cltd   
}
  80097e:	5d                   	pop    %ebp
  80097f:	c3                   	ret    

00800980 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  800980:	55                   	push   %ebp
  800981:	89 e5                	mov    %esp,%ebp
  800983:	56                   	push   %esi
  800984:	53                   	push   %ebx
  800985:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800988:	eb 17                	jmp    8009a1 <vprintfmt+0x21>
			if (ch == '\0')
  80098a:	85 db                	test   %ebx,%ebx
  80098c:	0f 84 af 03 00 00    	je     800d41 <vprintfmt+0x3c1>
				return;
			putch(ch, putdat);
  800992:	83 ec 08             	sub    $0x8,%esp
  800995:	ff 75 0c             	pushl  0xc(%ebp)
  800998:	53                   	push   %ebx
  800999:	8b 45 08             	mov    0x8(%ebp),%eax
  80099c:	ff d0                	call   *%eax
  80099e:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8009a1:	8b 45 10             	mov    0x10(%ebp),%eax
  8009a4:	8d 50 01             	lea    0x1(%eax),%edx
  8009a7:	89 55 10             	mov    %edx,0x10(%ebp)
  8009aa:	8a 00                	mov    (%eax),%al
  8009ac:	0f b6 d8             	movzbl %al,%ebx
  8009af:	83 fb 25             	cmp    $0x25,%ebx
  8009b2:	75 d6                	jne    80098a <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  8009b4:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  8009b8:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  8009bf:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  8009c6:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  8009cd:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8009d4:	8b 45 10             	mov    0x10(%ebp),%eax
  8009d7:	8d 50 01             	lea    0x1(%eax),%edx
  8009da:	89 55 10             	mov    %edx,0x10(%ebp)
  8009dd:	8a 00                	mov    (%eax),%al
  8009df:	0f b6 d8             	movzbl %al,%ebx
  8009e2:	8d 43 dd             	lea    -0x23(%ebx),%eax
  8009e5:	83 f8 55             	cmp    $0x55,%eax
  8009e8:	0f 87 2b 03 00 00    	ja     800d19 <vprintfmt+0x399>
  8009ee:	8b 04 85 18 38 80 00 	mov    0x803818(,%eax,4),%eax
  8009f5:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  8009f7:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  8009fb:	eb d7                	jmp    8009d4 <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  8009fd:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  800a01:	eb d1                	jmp    8009d4 <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800a03:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  800a0a:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800a0d:	89 d0                	mov    %edx,%eax
  800a0f:	c1 e0 02             	shl    $0x2,%eax
  800a12:	01 d0                	add    %edx,%eax
  800a14:	01 c0                	add    %eax,%eax
  800a16:	01 d8                	add    %ebx,%eax
  800a18:	83 e8 30             	sub    $0x30,%eax
  800a1b:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  800a1e:	8b 45 10             	mov    0x10(%ebp),%eax
  800a21:	8a 00                	mov    (%eax),%al
  800a23:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  800a26:	83 fb 2f             	cmp    $0x2f,%ebx
  800a29:	7e 3e                	jle    800a69 <vprintfmt+0xe9>
  800a2b:	83 fb 39             	cmp    $0x39,%ebx
  800a2e:	7f 39                	jg     800a69 <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800a30:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800a33:	eb d5                	jmp    800a0a <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  800a35:	8b 45 14             	mov    0x14(%ebp),%eax
  800a38:	83 c0 04             	add    $0x4,%eax
  800a3b:	89 45 14             	mov    %eax,0x14(%ebp)
  800a3e:	8b 45 14             	mov    0x14(%ebp),%eax
  800a41:	83 e8 04             	sub    $0x4,%eax
  800a44:	8b 00                	mov    (%eax),%eax
  800a46:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  800a49:	eb 1f                	jmp    800a6a <vprintfmt+0xea>

		case '.':
			if (width < 0)
  800a4b:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800a4f:	79 83                	jns    8009d4 <vprintfmt+0x54>
				width = 0;
  800a51:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  800a58:	e9 77 ff ff ff       	jmp    8009d4 <vprintfmt+0x54>

		case '#':
			altflag = 1;
  800a5d:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  800a64:	e9 6b ff ff ff       	jmp    8009d4 <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  800a69:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  800a6a:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800a6e:	0f 89 60 ff ff ff    	jns    8009d4 <vprintfmt+0x54>
				width = precision, precision = -1;
  800a74:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800a77:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800a7a:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  800a81:	e9 4e ff ff ff       	jmp    8009d4 <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  800a86:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  800a89:	e9 46 ff ff ff       	jmp    8009d4 <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  800a8e:	8b 45 14             	mov    0x14(%ebp),%eax
  800a91:	83 c0 04             	add    $0x4,%eax
  800a94:	89 45 14             	mov    %eax,0x14(%ebp)
  800a97:	8b 45 14             	mov    0x14(%ebp),%eax
  800a9a:	83 e8 04             	sub    $0x4,%eax
  800a9d:	8b 00                	mov    (%eax),%eax
  800a9f:	83 ec 08             	sub    $0x8,%esp
  800aa2:	ff 75 0c             	pushl  0xc(%ebp)
  800aa5:	50                   	push   %eax
  800aa6:	8b 45 08             	mov    0x8(%ebp),%eax
  800aa9:	ff d0                	call   *%eax
  800aab:	83 c4 10             	add    $0x10,%esp
			break;
  800aae:	e9 89 02 00 00       	jmp    800d3c <vprintfmt+0x3bc>

		// error message
		case 'e':
			err = va_arg(ap, int);
  800ab3:	8b 45 14             	mov    0x14(%ebp),%eax
  800ab6:	83 c0 04             	add    $0x4,%eax
  800ab9:	89 45 14             	mov    %eax,0x14(%ebp)
  800abc:	8b 45 14             	mov    0x14(%ebp),%eax
  800abf:	83 e8 04             	sub    $0x4,%eax
  800ac2:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  800ac4:	85 db                	test   %ebx,%ebx
  800ac6:	79 02                	jns    800aca <vprintfmt+0x14a>
				err = -err;
  800ac8:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  800aca:	83 fb 64             	cmp    $0x64,%ebx
  800acd:	7f 0b                	jg     800ada <vprintfmt+0x15a>
  800acf:	8b 34 9d 60 36 80 00 	mov    0x803660(,%ebx,4),%esi
  800ad6:	85 f6                	test   %esi,%esi
  800ad8:	75 19                	jne    800af3 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  800ada:	53                   	push   %ebx
  800adb:	68 05 38 80 00       	push   $0x803805
  800ae0:	ff 75 0c             	pushl  0xc(%ebp)
  800ae3:	ff 75 08             	pushl  0x8(%ebp)
  800ae6:	e8 5e 02 00 00       	call   800d49 <printfmt>
  800aeb:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800aee:	e9 49 02 00 00       	jmp    800d3c <vprintfmt+0x3bc>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800af3:	56                   	push   %esi
  800af4:	68 0e 38 80 00       	push   $0x80380e
  800af9:	ff 75 0c             	pushl  0xc(%ebp)
  800afc:	ff 75 08             	pushl  0x8(%ebp)
  800aff:	e8 45 02 00 00       	call   800d49 <printfmt>
  800b04:	83 c4 10             	add    $0x10,%esp
			break;
  800b07:	e9 30 02 00 00       	jmp    800d3c <vprintfmt+0x3bc>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  800b0c:	8b 45 14             	mov    0x14(%ebp),%eax
  800b0f:	83 c0 04             	add    $0x4,%eax
  800b12:	89 45 14             	mov    %eax,0x14(%ebp)
  800b15:	8b 45 14             	mov    0x14(%ebp),%eax
  800b18:	83 e8 04             	sub    $0x4,%eax
  800b1b:	8b 30                	mov    (%eax),%esi
  800b1d:	85 f6                	test   %esi,%esi
  800b1f:	75 05                	jne    800b26 <vprintfmt+0x1a6>
				p = "(null)";
  800b21:	be 11 38 80 00       	mov    $0x803811,%esi
			if (width > 0 && padc != '-')
  800b26:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800b2a:	7e 6d                	jle    800b99 <vprintfmt+0x219>
  800b2c:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  800b30:	74 67                	je     800b99 <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  800b32:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800b35:	83 ec 08             	sub    $0x8,%esp
  800b38:	50                   	push   %eax
  800b39:	56                   	push   %esi
  800b3a:	e8 0c 03 00 00       	call   800e4b <strnlen>
  800b3f:	83 c4 10             	add    $0x10,%esp
  800b42:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  800b45:	eb 16                	jmp    800b5d <vprintfmt+0x1dd>
					putch(padc, putdat);
  800b47:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  800b4b:	83 ec 08             	sub    $0x8,%esp
  800b4e:	ff 75 0c             	pushl  0xc(%ebp)
  800b51:	50                   	push   %eax
  800b52:	8b 45 08             	mov    0x8(%ebp),%eax
  800b55:	ff d0                	call   *%eax
  800b57:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800b5a:	ff 4d e4             	decl   -0x1c(%ebp)
  800b5d:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800b61:	7f e4                	jg     800b47 <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800b63:	eb 34                	jmp    800b99 <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  800b65:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800b69:	74 1c                	je     800b87 <vprintfmt+0x207>
  800b6b:	83 fb 1f             	cmp    $0x1f,%ebx
  800b6e:	7e 05                	jle    800b75 <vprintfmt+0x1f5>
  800b70:	83 fb 7e             	cmp    $0x7e,%ebx
  800b73:	7e 12                	jle    800b87 <vprintfmt+0x207>
					putch('?', putdat);
  800b75:	83 ec 08             	sub    $0x8,%esp
  800b78:	ff 75 0c             	pushl  0xc(%ebp)
  800b7b:	6a 3f                	push   $0x3f
  800b7d:	8b 45 08             	mov    0x8(%ebp),%eax
  800b80:	ff d0                	call   *%eax
  800b82:	83 c4 10             	add    $0x10,%esp
  800b85:	eb 0f                	jmp    800b96 <vprintfmt+0x216>
				else
					putch(ch, putdat);
  800b87:	83 ec 08             	sub    $0x8,%esp
  800b8a:	ff 75 0c             	pushl  0xc(%ebp)
  800b8d:	53                   	push   %ebx
  800b8e:	8b 45 08             	mov    0x8(%ebp),%eax
  800b91:	ff d0                	call   *%eax
  800b93:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800b96:	ff 4d e4             	decl   -0x1c(%ebp)
  800b99:	89 f0                	mov    %esi,%eax
  800b9b:	8d 70 01             	lea    0x1(%eax),%esi
  800b9e:	8a 00                	mov    (%eax),%al
  800ba0:	0f be d8             	movsbl %al,%ebx
  800ba3:	85 db                	test   %ebx,%ebx
  800ba5:	74 24                	je     800bcb <vprintfmt+0x24b>
  800ba7:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800bab:	78 b8                	js     800b65 <vprintfmt+0x1e5>
  800bad:	ff 4d e0             	decl   -0x20(%ebp)
  800bb0:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800bb4:	79 af                	jns    800b65 <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800bb6:	eb 13                	jmp    800bcb <vprintfmt+0x24b>
				putch(' ', putdat);
  800bb8:	83 ec 08             	sub    $0x8,%esp
  800bbb:	ff 75 0c             	pushl  0xc(%ebp)
  800bbe:	6a 20                	push   $0x20
  800bc0:	8b 45 08             	mov    0x8(%ebp),%eax
  800bc3:	ff d0                	call   *%eax
  800bc5:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800bc8:	ff 4d e4             	decl   -0x1c(%ebp)
  800bcb:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800bcf:	7f e7                	jg     800bb8 <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  800bd1:	e9 66 01 00 00       	jmp    800d3c <vprintfmt+0x3bc>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  800bd6:	83 ec 08             	sub    $0x8,%esp
  800bd9:	ff 75 e8             	pushl  -0x18(%ebp)
  800bdc:	8d 45 14             	lea    0x14(%ebp),%eax
  800bdf:	50                   	push   %eax
  800be0:	e8 3c fd ff ff       	call   800921 <getint>
  800be5:	83 c4 10             	add    $0x10,%esp
  800be8:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800beb:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  800bee:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800bf1:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800bf4:	85 d2                	test   %edx,%edx
  800bf6:	79 23                	jns    800c1b <vprintfmt+0x29b>
				putch('-', putdat);
  800bf8:	83 ec 08             	sub    $0x8,%esp
  800bfb:	ff 75 0c             	pushl  0xc(%ebp)
  800bfe:	6a 2d                	push   $0x2d
  800c00:	8b 45 08             	mov    0x8(%ebp),%eax
  800c03:	ff d0                	call   *%eax
  800c05:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  800c08:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800c0b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800c0e:	f7 d8                	neg    %eax
  800c10:	83 d2 00             	adc    $0x0,%edx
  800c13:	f7 da                	neg    %edx
  800c15:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800c18:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  800c1b:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800c22:	e9 bc 00 00 00       	jmp    800ce3 <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  800c27:	83 ec 08             	sub    $0x8,%esp
  800c2a:	ff 75 e8             	pushl  -0x18(%ebp)
  800c2d:	8d 45 14             	lea    0x14(%ebp),%eax
  800c30:	50                   	push   %eax
  800c31:	e8 84 fc ff ff       	call   8008ba <getuint>
  800c36:	83 c4 10             	add    $0x10,%esp
  800c39:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800c3c:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  800c3f:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800c46:	e9 98 00 00 00       	jmp    800ce3 <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  800c4b:	83 ec 08             	sub    $0x8,%esp
  800c4e:	ff 75 0c             	pushl  0xc(%ebp)
  800c51:	6a 58                	push   $0x58
  800c53:	8b 45 08             	mov    0x8(%ebp),%eax
  800c56:	ff d0                	call   *%eax
  800c58:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800c5b:	83 ec 08             	sub    $0x8,%esp
  800c5e:	ff 75 0c             	pushl  0xc(%ebp)
  800c61:	6a 58                	push   $0x58
  800c63:	8b 45 08             	mov    0x8(%ebp),%eax
  800c66:	ff d0                	call   *%eax
  800c68:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800c6b:	83 ec 08             	sub    $0x8,%esp
  800c6e:	ff 75 0c             	pushl  0xc(%ebp)
  800c71:	6a 58                	push   $0x58
  800c73:	8b 45 08             	mov    0x8(%ebp),%eax
  800c76:	ff d0                	call   *%eax
  800c78:	83 c4 10             	add    $0x10,%esp
			break;
  800c7b:	e9 bc 00 00 00       	jmp    800d3c <vprintfmt+0x3bc>

		// pointer
		case 'p':
			putch('0', putdat);
  800c80:	83 ec 08             	sub    $0x8,%esp
  800c83:	ff 75 0c             	pushl  0xc(%ebp)
  800c86:	6a 30                	push   $0x30
  800c88:	8b 45 08             	mov    0x8(%ebp),%eax
  800c8b:	ff d0                	call   *%eax
  800c8d:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  800c90:	83 ec 08             	sub    $0x8,%esp
  800c93:	ff 75 0c             	pushl  0xc(%ebp)
  800c96:	6a 78                	push   $0x78
  800c98:	8b 45 08             	mov    0x8(%ebp),%eax
  800c9b:	ff d0                	call   *%eax
  800c9d:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  800ca0:	8b 45 14             	mov    0x14(%ebp),%eax
  800ca3:	83 c0 04             	add    $0x4,%eax
  800ca6:	89 45 14             	mov    %eax,0x14(%ebp)
  800ca9:	8b 45 14             	mov    0x14(%ebp),%eax
  800cac:	83 e8 04             	sub    $0x4,%eax
  800caf:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800cb1:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800cb4:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  800cbb:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  800cc2:	eb 1f                	jmp    800ce3 <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800cc4:	83 ec 08             	sub    $0x8,%esp
  800cc7:	ff 75 e8             	pushl  -0x18(%ebp)
  800cca:	8d 45 14             	lea    0x14(%ebp),%eax
  800ccd:	50                   	push   %eax
  800cce:	e8 e7 fb ff ff       	call   8008ba <getuint>
  800cd3:	83 c4 10             	add    $0x10,%esp
  800cd6:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800cd9:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  800cdc:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800ce3:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  800ce7:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800cea:	83 ec 04             	sub    $0x4,%esp
  800ced:	52                   	push   %edx
  800cee:	ff 75 e4             	pushl  -0x1c(%ebp)
  800cf1:	50                   	push   %eax
  800cf2:	ff 75 f4             	pushl  -0xc(%ebp)
  800cf5:	ff 75 f0             	pushl  -0x10(%ebp)
  800cf8:	ff 75 0c             	pushl  0xc(%ebp)
  800cfb:	ff 75 08             	pushl  0x8(%ebp)
  800cfe:	e8 00 fb ff ff       	call   800803 <printnum>
  800d03:	83 c4 20             	add    $0x20,%esp
			break;
  800d06:	eb 34                	jmp    800d3c <vprintfmt+0x3bc>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  800d08:	83 ec 08             	sub    $0x8,%esp
  800d0b:	ff 75 0c             	pushl  0xc(%ebp)
  800d0e:	53                   	push   %ebx
  800d0f:	8b 45 08             	mov    0x8(%ebp),%eax
  800d12:	ff d0                	call   *%eax
  800d14:	83 c4 10             	add    $0x10,%esp
			break;
  800d17:	eb 23                	jmp    800d3c <vprintfmt+0x3bc>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800d19:	83 ec 08             	sub    $0x8,%esp
  800d1c:	ff 75 0c             	pushl  0xc(%ebp)
  800d1f:	6a 25                	push   $0x25
  800d21:	8b 45 08             	mov    0x8(%ebp),%eax
  800d24:	ff d0                	call   *%eax
  800d26:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  800d29:	ff 4d 10             	decl   0x10(%ebp)
  800d2c:	eb 03                	jmp    800d31 <vprintfmt+0x3b1>
  800d2e:	ff 4d 10             	decl   0x10(%ebp)
  800d31:	8b 45 10             	mov    0x10(%ebp),%eax
  800d34:	48                   	dec    %eax
  800d35:	8a 00                	mov    (%eax),%al
  800d37:	3c 25                	cmp    $0x25,%al
  800d39:	75 f3                	jne    800d2e <vprintfmt+0x3ae>
				/* do nothing */;
			break;
  800d3b:	90                   	nop
		}
	}
  800d3c:	e9 47 fc ff ff       	jmp    800988 <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  800d41:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  800d42:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800d45:	5b                   	pop    %ebx
  800d46:	5e                   	pop    %esi
  800d47:	5d                   	pop    %ebp
  800d48:	c3                   	ret    

00800d49 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800d49:	55                   	push   %ebp
  800d4a:	89 e5                	mov    %esp,%ebp
  800d4c:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  800d4f:	8d 45 10             	lea    0x10(%ebp),%eax
  800d52:	83 c0 04             	add    $0x4,%eax
  800d55:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  800d58:	8b 45 10             	mov    0x10(%ebp),%eax
  800d5b:	ff 75 f4             	pushl  -0xc(%ebp)
  800d5e:	50                   	push   %eax
  800d5f:	ff 75 0c             	pushl  0xc(%ebp)
  800d62:	ff 75 08             	pushl  0x8(%ebp)
  800d65:	e8 16 fc ff ff       	call   800980 <vprintfmt>
  800d6a:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  800d6d:	90                   	nop
  800d6e:	c9                   	leave  
  800d6f:	c3                   	ret    

00800d70 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800d70:	55                   	push   %ebp
  800d71:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  800d73:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d76:	8b 40 08             	mov    0x8(%eax),%eax
  800d79:	8d 50 01             	lea    0x1(%eax),%edx
  800d7c:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d7f:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  800d82:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d85:	8b 10                	mov    (%eax),%edx
  800d87:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d8a:	8b 40 04             	mov    0x4(%eax),%eax
  800d8d:	39 c2                	cmp    %eax,%edx
  800d8f:	73 12                	jae    800da3 <sprintputch+0x33>
		*b->buf++ = ch;
  800d91:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d94:	8b 00                	mov    (%eax),%eax
  800d96:	8d 48 01             	lea    0x1(%eax),%ecx
  800d99:	8b 55 0c             	mov    0xc(%ebp),%edx
  800d9c:	89 0a                	mov    %ecx,(%edx)
  800d9e:	8b 55 08             	mov    0x8(%ebp),%edx
  800da1:	88 10                	mov    %dl,(%eax)
}
  800da3:	90                   	nop
  800da4:	5d                   	pop    %ebp
  800da5:	c3                   	ret    

00800da6 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800da6:	55                   	push   %ebp
  800da7:	89 e5                	mov    %esp,%ebp
  800da9:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  800dac:	8b 45 08             	mov    0x8(%ebp),%eax
  800daf:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800db2:	8b 45 0c             	mov    0xc(%ebp),%eax
  800db5:	8d 50 ff             	lea    -0x1(%eax),%edx
  800db8:	8b 45 08             	mov    0x8(%ebp),%eax
  800dbb:	01 d0                	add    %edx,%eax
  800dbd:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800dc0:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800dc7:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800dcb:	74 06                	je     800dd3 <vsnprintf+0x2d>
  800dcd:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800dd1:	7f 07                	jg     800dda <vsnprintf+0x34>
		return -E_INVAL;
  800dd3:	b8 03 00 00 00       	mov    $0x3,%eax
  800dd8:	eb 20                	jmp    800dfa <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800dda:	ff 75 14             	pushl  0x14(%ebp)
  800ddd:	ff 75 10             	pushl  0x10(%ebp)
  800de0:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800de3:	50                   	push   %eax
  800de4:	68 70 0d 80 00       	push   $0x800d70
  800de9:	e8 92 fb ff ff       	call   800980 <vprintfmt>
  800dee:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  800df1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800df4:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800df7:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  800dfa:	c9                   	leave  
  800dfb:	c3                   	ret    

00800dfc <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800dfc:	55                   	push   %ebp
  800dfd:	89 e5                	mov    %esp,%ebp
  800dff:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800e02:	8d 45 10             	lea    0x10(%ebp),%eax
  800e05:	83 c0 04             	add    $0x4,%eax
  800e08:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  800e0b:	8b 45 10             	mov    0x10(%ebp),%eax
  800e0e:	ff 75 f4             	pushl  -0xc(%ebp)
  800e11:	50                   	push   %eax
  800e12:	ff 75 0c             	pushl  0xc(%ebp)
  800e15:	ff 75 08             	pushl  0x8(%ebp)
  800e18:	e8 89 ff ff ff       	call   800da6 <vsnprintf>
  800e1d:	83 c4 10             	add    $0x10,%esp
  800e20:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  800e23:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800e26:	c9                   	leave  
  800e27:	c3                   	ret    

00800e28 <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  800e28:	55                   	push   %ebp
  800e29:	89 e5                	mov    %esp,%ebp
  800e2b:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  800e2e:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800e35:	eb 06                	jmp    800e3d <strlen+0x15>
		n++;
  800e37:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800e3a:	ff 45 08             	incl   0x8(%ebp)
  800e3d:	8b 45 08             	mov    0x8(%ebp),%eax
  800e40:	8a 00                	mov    (%eax),%al
  800e42:	84 c0                	test   %al,%al
  800e44:	75 f1                	jne    800e37 <strlen+0xf>
		n++;
	return n;
  800e46:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800e49:	c9                   	leave  
  800e4a:	c3                   	ret    

00800e4b <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  800e4b:	55                   	push   %ebp
  800e4c:	89 e5                	mov    %esp,%ebp
  800e4e:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800e51:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800e58:	eb 09                	jmp    800e63 <strnlen+0x18>
		n++;
  800e5a:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800e5d:	ff 45 08             	incl   0x8(%ebp)
  800e60:	ff 4d 0c             	decl   0xc(%ebp)
  800e63:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800e67:	74 09                	je     800e72 <strnlen+0x27>
  800e69:	8b 45 08             	mov    0x8(%ebp),%eax
  800e6c:	8a 00                	mov    (%eax),%al
  800e6e:	84 c0                	test   %al,%al
  800e70:	75 e8                	jne    800e5a <strnlen+0xf>
		n++;
	return n;
  800e72:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800e75:	c9                   	leave  
  800e76:	c3                   	ret    

00800e77 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800e77:	55                   	push   %ebp
  800e78:	89 e5                	mov    %esp,%ebp
  800e7a:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  800e7d:	8b 45 08             	mov    0x8(%ebp),%eax
  800e80:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  800e83:	90                   	nop
  800e84:	8b 45 08             	mov    0x8(%ebp),%eax
  800e87:	8d 50 01             	lea    0x1(%eax),%edx
  800e8a:	89 55 08             	mov    %edx,0x8(%ebp)
  800e8d:	8b 55 0c             	mov    0xc(%ebp),%edx
  800e90:	8d 4a 01             	lea    0x1(%edx),%ecx
  800e93:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800e96:	8a 12                	mov    (%edx),%dl
  800e98:	88 10                	mov    %dl,(%eax)
  800e9a:	8a 00                	mov    (%eax),%al
  800e9c:	84 c0                	test   %al,%al
  800e9e:	75 e4                	jne    800e84 <strcpy+0xd>
		/* do nothing */;
	return ret;
  800ea0:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800ea3:	c9                   	leave  
  800ea4:	c3                   	ret    

00800ea5 <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  800ea5:	55                   	push   %ebp
  800ea6:	89 e5                	mov    %esp,%ebp
  800ea8:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  800eab:	8b 45 08             	mov    0x8(%ebp),%eax
  800eae:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  800eb1:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800eb8:	eb 1f                	jmp    800ed9 <strncpy+0x34>
		*dst++ = *src;
  800eba:	8b 45 08             	mov    0x8(%ebp),%eax
  800ebd:	8d 50 01             	lea    0x1(%eax),%edx
  800ec0:	89 55 08             	mov    %edx,0x8(%ebp)
  800ec3:	8b 55 0c             	mov    0xc(%ebp),%edx
  800ec6:	8a 12                	mov    (%edx),%dl
  800ec8:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  800eca:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ecd:	8a 00                	mov    (%eax),%al
  800ecf:	84 c0                	test   %al,%al
  800ed1:	74 03                	je     800ed6 <strncpy+0x31>
			src++;
  800ed3:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800ed6:	ff 45 fc             	incl   -0x4(%ebp)
  800ed9:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800edc:	3b 45 10             	cmp    0x10(%ebp),%eax
  800edf:	72 d9                	jb     800eba <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  800ee1:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  800ee4:	c9                   	leave  
  800ee5:	c3                   	ret    

00800ee6 <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  800ee6:	55                   	push   %ebp
  800ee7:	89 e5                	mov    %esp,%ebp
  800ee9:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  800eec:	8b 45 08             	mov    0x8(%ebp),%eax
  800eef:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  800ef2:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800ef6:	74 30                	je     800f28 <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  800ef8:	eb 16                	jmp    800f10 <strlcpy+0x2a>
			*dst++ = *src++;
  800efa:	8b 45 08             	mov    0x8(%ebp),%eax
  800efd:	8d 50 01             	lea    0x1(%eax),%edx
  800f00:	89 55 08             	mov    %edx,0x8(%ebp)
  800f03:	8b 55 0c             	mov    0xc(%ebp),%edx
  800f06:	8d 4a 01             	lea    0x1(%edx),%ecx
  800f09:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800f0c:	8a 12                	mov    (%edx),%dl
  800f0e:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800f10:	ff 4d 10             	decl   0x10(%ebp)
  800f13:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800f17:	74 09                	je     800f22 <strlcpy+0x3c>
  800f19:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f1c:	8a 00                	mov    (%eax),%al
  800f1e:	84 c0                	test   %al,%al
  800f20:	75 d8                	jne    800efa <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  800f22:	8b 45 08             	mov    0x8(%ebp),%eax
  800f25:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800f28:	8b 55 08             	mov    0x8(%ebp),%edx
  800f2b:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800f2e:	29 c2                	sub    %eax,%edx
  800f30:	89 d0                	mov    %edx,%eax
}
  800f32:	c9                   	leave  
  800f33:	c3                   	ret    

00800f34 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800f34:	55                   	push   %ebp
  800f35:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  800f37:	eb 06                	jmp    800f3f <strcmp+0xb>
		p++, q++;
  800f39:	ff 45 08             	incl   0x8(%ebp)
  800f3c:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  800f3f:	8b 45 08             	mov    0x8(%ebp),%eax
  800f42:	8a 00                	mov    (%eax),%al
  800f44:	84 c0                	test   %al,%al
  800f46:	74 0e                	je     800f56 <strcmp+0x22>
  800f48:	8b 45 08             	mov    0x8(%ebp),%eax
  800f4b:	8a 10                	mov    (%eax),%dl
  800f4d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f50:	8a 00                	mov    (%eax),%al
  800f52:	38 c2                	cmp    %al,%dl
  800f54:	74 e3                	je     800f39 <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800f56:	8b 45 08             	mov    0x8(%ebp),%eax
  800f59:	8a 00                	mov    (%eax),%al
  800f5b:	0f b6 d0             	movzbl %al,%edx
  800f5e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f61:	8a 00                	mov    (%eax),%al
  800f63:	0f b6 c0             	movzbl %al,%eax
  800f66:	29 c2                	sub    %eax,%edx
  800f68:	89 d0                	mov    %edx,%eax
}
  800f6a:	5d                   	pop    %ebp
  800f6b:	c3                   	ret    

00800f6c <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  800f6c:	55                   	push   %ebp
  800f6d:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  800f6f:	eb 09                	jmp    800f7a <strncmp+0xe>
		n--, p++, q++;
  800f71:	ff 4d 10             	decl   0x10(%ebp)
  800f74:	ff 45 08             	incl   0x8(%ebp)
  800f77:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  800f7a:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800f7e:	74 17                	je     800f97 <strncmp+0x2b>
  800f80:	8b 45 08             	mov    0x8(%ebp),%eax
  800f83:	8a 00                	mov    (%eax),%al
  800f85:	84 c0                	test   %al,%al
  800f87:	74 0e                	je     800f97 <strncmp+0x2b>
  800f89:	8b 45 08             	mov    0x8(%ebp),%eax
  800f8c:	8a 10                	mov    (%eax),%dl
  800f8e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f91:	8a 00                	mov    (%eax),%al
  800f93:	38 c2                	cmp    %al,%dl
  800f95:	74 da                	je     800f71 <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  800f97:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800f9b:	75 07                	jne    800fa4 <strncmp+0x38>
		return 0;
  800f9d:	b8 00 00 00 00       	mov    $0x0,%eax
  800fa2:	eb 14                	jmp    800fb8 <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800fa4:	8b 45 08             	mov    0x8(%ebp),%eax
  800fa7:	8a 00                	mov    (%eax),%al
  800fa9:	0f b6 d0             	movzbl %al,%edx
  800fac:	8b 45 0c             	mov    0xc(%ebp),%eax
  800faf:	8a 00                	mov    (%eax),%al
  800fb1:	0f b6 c0             	movzbl %al,%eax
  800fb4:	29 c2                	sub    %eax,%edx
  800fb6:	89 d0                	mov    %edx,%eax
}
  800fb8:	5d                   	pop    %ebp
  800fb9:	c3                   	ret    

00800fba <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800fba:	55                   	push   %ebp
  800fbb:	89 e5                	mov    %esp,%ebp
  800fbd:	83 ec 04             	sub    $0x4,%esp
  800fc0:	8b 45 0c             	mov    0xc(%ebp),%eax
  800fc3:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800fc6:	eb 12                	jmp    800fda <strchr+0x20>
		if (*s == c)
  800fc8:	8b 45 08             	mov    0x8(%ebp),%eax
  800fcb:	8a 00                	mov    (%eax),%al
  800fcd:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800fd0:	75 05                	jne    800fd7 <strchr+0x1d>
			return (char *) s;
  800fd2:	8b 45 08             	mov    0x8(%ebp),%eax
  800fd5:	eb 11                	jmp    800fe8 <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  800fd7:	ff 45 08             	incl   0x8(%ebp)
  800fda:	8b 45 08             	mov    0x8(%ebp),%eax
  800fdd:	8a 00                	mov    (%eax),%al
  800fdf:	84 c0                	test   %al,%al
  800fe1:	75 e5                	jne    800fc8 <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  800fe3:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800fe8:	c9                   	leave  
  800fe9:	c3                   	ret    

00800fea <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800fea:	55                   	push   %ebp
  800feb:	89 e5                	mov    %esp,%ebp
  800fed:	83 ec 04             	sub    $0x4,%esp
  800ff0:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ff3:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800ff6:	eb 0d                	jmp    801005 <strfind+0x1b>
		if (*s == c)
  800ff8:	8b 45 08             	mov    0x8(%ebp),%eax
  800ffb:	8a 00                	mov    (%eax),%al
  800ffd:	3a 45 fc             	cmp    -0x4(%ebp),%al
  801000:	74 0e                	je     801010 <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  801002:	ff 45 08             	incl   0x8(%ebp)
  801005:	8b 45 08             	mov    0x8(%ebp),%eax
  801008:	8a 00                	mov    (%eax),%al
  80100a:	84 c0                	test   %al,%al
  80100c:	75 ea                	jne    800ff8 <strfind+0xe>
  80100e:	eb 01                	jmp    801011 <strfind+0x27>
		if (*s == c)
			break;
  801010:	90                   	nop
	return (char *) s;
  801011:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801014:	c9                   	leave  
  801015:	c3                   	ret    

00801016 <memset>:


void *
memset(void *v, int c, uint32 n)
{
  801016:	55                   	push   %ebp
  801017:	89 e5                	mov    %esp,%ebp
  801019:	83 ec 10             	sub    $0x10,%esp
	char *p;
	int m;

	p = v;
  80101c:	8b 45 08             	mov    0x8(%ebp),%eax
  80101f:	89 45 fc             	mov    %eax,-0x4(%ebp)
	m = n;
  801022:	8b 45 10             	mov    0x10(%ebp),%eax
  801025:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (--m >= 0)
  801028:	eb 0e                	jmp    801038 <memset+0x22>
		*p++ = c;
  80102a:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80102d:	8d 50 01             	lea    0x1(%eax),%edx
  801030:	89 55 fc             	mov    %edx,-0x4(%ebp)
  801033:	8b 55 0c             	mov    0xc(%ebp),%edx
  801036:	88 10                	mov    %dl,(%eax)
	char *p;
	int m;

	p = v;
	m = n;
	while (--m >= 0)
  801038:	ff 4d f8             	decl   -0x8(%ebp)
  80103b:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  80103f:	79 e9                	jns    80102a <memset+0x14>
		*p++ = c;

	return v;
  801041:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801044:	c9                   	leave  
  801045:	c3                   	ret    

00801046 <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  801046:	55                   	push   %ebp
  801047:	89 e5                	mov    %esp,%ebp
  801049:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  80104c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80104f:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  801052:	8b 45 08             	mov    0x8(%ebp),%eax
  801055:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (n-- > 0)
  801058:	eb 16                	jmp    801070 <memcpy+0x2a>
		*d++ = *s++;
  80105a:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80105d:	8d 50 01             	lea    0x1(%eax),%edx
  801060:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801063:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801066:	8d 4a 01             	lea    0x1(%edx),%ecx
  801069:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  80106c:	8a 12                	mov    (%edx),%dl
  80106e:	88 10                	mov    %dl,(%eax)
	const char *s;
	char *d;

	s = src;
	d = dst;
	while (n-- > 0)
  801070:	8b 45 10             	mov    0x10(%ebp),%eax
  801073:	8d 50 ff             	lea    -0x1(%eax),%edx
  801076:	89 55 10             	mov    %edx,0x10(%ebp)
  801079:	85 c0                	test   %eax,%eax
  80107b:	75 dd                	jne    80105a <memcpy+0x14>
		*d++ = *s++;

	return dst;
  80107d:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801080:	c9                   	leave  
  801081:	c3                   	ret    

00801082 <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  801082:	55                   	push   %ebp
  801083:	89 e5                	mov    %esp,%ebp
  801085:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  801088:	8b 45 0c             	mov    0xc(%ebp),%eax
  80108b:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  80108e:	8b 45 08             	mov    0x8(%ebp),%eax
  801091:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  801094:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801097:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  80109a:	73 50                	jae    8010ec <memmove+0x6a>
  80109c:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80109f:	8b 45 10             	mov    0x10(%ebp),%eax
  8010a2:	01 d0                	add    %edx,%eax
  8010a4:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  8010a7:	76 43                	jbe    8010ec <memmove+0x6a>
		s += n;
  8010a9:	8b 45 10             	mov    0x10(%ebp),%eax
  8010ac:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  8010af:	8b 45 10             	mov    0x10(%ebp),%eax
  8010b2:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  8010b5:	eb 10                	jmp    8010c7 <memmove+0x45>
			*--d = *--s;
  8010b7:	ff 4d f8             	decl   -0x8(%ebp)
  8010ba:	ff 4d fc             	decl   -0x4(%ebp)
  8010bd:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8010c0:	8a 10                	mov    (%eax),%dl
  8010c2:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8010c5:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  8010c7:	8b 45 10             	mov    0x10(%ebp),%eax
  8010ca:	8d 50 ff             	lea    -0x1(%eax),%edx
  8010cd:	89 55 10             	mov    %edx,0x10(%ebp)
  8010d0:	85 c0                	test   %eax,%eax
  8010d2:	75 e3                	jne    8010b7 <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  8010d4:	eb 23                	jmp    8010f9 <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  8010d6:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8010d9:	8d 50 01             	lea    0x1(%eax),%edx
  8010dc:	89 55 f8             	mov    %edx,-0x8(%ebp)
  8010df:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8010e2:	8d 4a 01             	lea    0x1(%edx),%ecx
  8010e5:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  8010e8:	8a 12                	mov    (%edx),%dl
  8010ea:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  8010ec:	8b 45 10             	mov    0x10(%ebp),%eax
  8010ef:	8d 50 ff             	lea    -0x1(%eax),%edx
  8010f2:	89 55 10             	mov    %edx,0x10(%ebp)
  8010f5:	85 c0                	test   %eax,%eax
  8010f7:	75 dd                	jne    8010d6 <memmove+0x54>
			*d++ = *s++;

	return dst;
  8010f9:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8010fc:	c9                   	leave  
  8010fd:	c3                   	ret    

008010fe <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  8010fe:	55                   	push   %ebp
  8010ff:	89 e5                	mov    %esp,%ebp
  801101:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  801104:	8b 45 08             	mov    0x8(%ebp),%eax
  801107:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  80110a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80110d:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  801110:	eb 2a                	jmp    80113c <memcmp+0x3e>
		if (*s1 != *s2)
  801112:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801115:	8a 10                	mov    (%eax),%dl
  801117:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80111a:	8a 00                	mov    (%eax),%al
  80111c:	38 c2                	cmp    %al,%dl
  80111e:	74 16                	je     801136 <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  801120:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801123:	8a 00                	mov    (%eax),%al
  801125:	0f b6 d0             	movzbl %al,%edx
  801128:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80112b:	8a 00                	mov    (%eax),%al
  80112d:	0f b6 c0             	movzbl %al,%eax
  801130:	29 c2                	sub    %eax,%edx
  801132:	89 d0                	mov    %edx,%eax
  801134:	eb 18                	jmp    80114e <memcmp+0x50>
		s1++, s2++;
  801136:	ff 45 fc             	incl   -0x4(%ebp)
  801139:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  80113c:	8b 45 10             	mov    0x10(%ebp),%eax
  80113f:	8d 50 ff             	lea    -0x1(%eax),%edx
  801142:	89 55 10             	mov    %edx,0x10(%ebp)
  801145:	85 c0                	test   %eax,%eax
  801147:	75 c9                	jne    801112 <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  801149:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80114e:	c9                   	leave  
  80114f:	c3                   	ret    

00801150 <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  801150:	55                   	push   %ebp
  801151:	89 e5                	mov    %esp,%ebp
  801153:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  801156:	8b 55 08             	mov    0x8(%ebp),%edx
  801159:	8b 45 10             	mov    0x10(%ebp),%eax
  80115c:	01 d0                	add    %edx,%eax
  80115e:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  801161:	eb 15                	jmp    801178 <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  801163:	8b 45 08             	mov    0x8(%ebp),%eax
  801166:	8a 00                	mov    (%eax),%al
  801168:	0f b6 d0             	movzbl %al,%edx
  80116b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80116e:	0f b6 c0             	movzbl %al,%eax
  801171:	39 c2                	cmp    %eax,%edx
  801173:	74 0d                	je     801182 <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  801175:	ff 45 08             	incl   0x8(%ebp)
  801178:	8b 45 08             	mov    0x8(%ebp),%eax
  80117b:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  80117e:	72 e3                	jb     801163 <memfind+0x13>
  801180:	eb 01                	jmp    801183 <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  801182:	90                   	nop
	return (void *) s;
  801183:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801186:	c9                   	leave  
  801187:	c3                   	ret    

00801188 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  801188:	55                   	push   %ebp
  801189:	89 e5                	mov    %esp,%ebp
  80118b:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  80118e:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  801195:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  80119c:	eb 03                	jmp    8011a1 <strtol+0x19>
		s++;
  80119e:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  8011a1:	8b 45 08             	mov    0x8(%ebp),%eax
  8011a4:	8a 00                	mov    (%eax),%al
  8011a6:	3c 20                	cmp    $0x20,%al
  8011a8:	74 f4                	je     80119e <strtol+0x16>
  8011aa:	8b 45 08             	mov    0x8(%ebp),%eax
  8011ad:	8a 00                	mov    (%eax),%al
  8011af:	3c 09                	cmp    $0x9,%al
  8011b1:	74 eb                	je     80119e <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  8011b3:	8b 45 08             	mov    0x8(%ebp),%eax
  8011b6:	8a 00                	mov    (%eax),%al
  8011b8:	3c 2b                	cmp    $0x2b,%al
  8011ba:	75 05                	jne    8011c1 <strtol+0x39>
		s++;
  8011bc:	ff 45 08             	incl   0x8(%ebp)
  8011bf:	eb 13                	jmp    8011d4 <strtol+0x4c>
	else if (*s == '-')
  8011c1:	8b 45 08             	mov    0x8(%ebp),%eax
  8011c4:	8a 00                	mov    (%eax),%al
  8011c6:	3c 2d                	cmp    $0x2d,%al
  8011c8:	75 0a                	jne    8011d4 <strtol+0x4c>
		s++, neg = 1;
  8011ca:	ff 45 08             	incl   0x8(%ebp)
  8011cd:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  8011d4:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8011d8:	74 06                	je     8011e0 <strtol+0x58>
  8011da:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  8011de:	75 20                	jne    801200 <strtol+0x78>
  8011e0:	8b 45 08             	mov    0x8(%ebp),%eax
  8011e3:	8a 00                	mov    (%eax),%al
  8011e5:	3c 30                	cmp    $0x30,%al
  8011e7:	75 17                	jne    801200 <strtol+0x78>
  8011e9:	8b 45 08             	mov    0x8(%ebp),%eax
  8011ec:	40                   	inc    %eax
  8011ed:	8a 00                	mov    (%eax),%al
  8011ef:	3c 78                	cmp    $0x78,%al
  8011f1:	75 0d                	jne    801200 <strtol+0x78>
		s += 2, base = 16;
  8011f3:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  8011f7:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  8011fe:	eb 28                	jmp    801228 <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  801200:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801204:	75 15                	jne    80121b <strtol+0x93>
  801206:	8b 45 08             	mov    0x8(%ebp),%eax
  801209:	8a 00                	mov    (%eax),%al
  80120b:	3c 30                	cmp    $0x30,%al
  80120d:	75 0c                	jne    80121b <strtol+0x93>
		s++, base = 8;
  80120f:	ff 45 08             	incl   0x8(%ebp)
  801212:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  801219:	eb 0d                	jmp    801228 <strtol+0xa0>
	else if (base == 0)
  80121b:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80121f:	75 07                	jne    801228 <strtol+0xa0>
		base = 10;
  801221:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  801228:	8b 45 08             	mov    0x8(%ebp),%eax
  80122b:	8a 00                	mov    (%eax),%al
  80122d:	3c 2f                	cmp    $0x2f,%al
  80122f:	7e 19                	jle    80124a <strtol+0xc2>
  801231:	8b 45 08             	mov    0x8(%ebp),%eax
  801234:	8a 00                	mov    (%eax),%al
  801236:	3c 39                	cmp    $0x39,%al
  801238:	7f 10                	jg     80124a <strtol+0xc2>
			dig = *s - '0';
  80123a:	8b 45 08             	mov    0x8(%ebp),%eax
  80123d:	8a 00                	mov    (%eax),%al
  80123f:	0f be c0             	movsbl %al,%eax
  801242:	83 e8 30             	sub    $0x30,%eax
  801245:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801248:	eb 42                	jmp    80128c <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  80124a:	8b 45 08             	mov    0x8(%ebp),%eax
  80124d:	8a 00                	mov    (%eax),%al
  80124f:	3c 60                	cmp    $0x60,%al
  801251:	7e 19                	jle    80126c <strtol+0xe4>
  801253:	8b 45 08             	mov    0x8(%ebp),%eax
  801256:	8a 00                	mov    (%eax),%al
  801258:	3c 7a                	cmp    $0x7a,%al
  80125a:	7f 10                	jg     80126c <strtol+0xe4>
			dig = *s - 'a' + 10;
  80125c:	8b 45 08             	mov    0x8(%ebp),%eax
  80125f:	8a 00                	mov    (%eax),%al
  801261:	0f be c0             	movsbl %al,%eax
  801264:	83 e8 57             	sub    $0x57,%eax
  801267:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80126a:	eb 20                	jmp    80128c <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  80126c:	8b 45 08             	mov    0x8(%ebp),%eax
  80126f:	8a 00                	mov    (%eax),%al
  801271:	3c 40                	cmp    $0x40,%al
  801273:	7e 39                	jle    8012ae <strtol+0x126>
  801275:	8b 45 08             	mov    0x8(%ebp),%eax
  801278:	8a 00                	mov    (%eax),%al
  80127a:	3c 5a                	cmp    $0x5a,%al
  80127c:	7f 30                	jg     8012ae <strtol+0x126>
			dig = *s - 'A' + 10;
  80127e:	8b 45 08             	mov    0x8(%ebp),%eax
  801281:	8a 00                	mov    (%eax),%al
  801283:	0f be c0             	movsbl %al,%eax
  801286:	83 e8 37             	sub    $0x37,%eax
  801289:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  80128c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80128f:	3b 45 10             	cmp    0x10(%ebp),%eax
  801292:	7d 19                	jge    8012ad <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  801294:	ff 45 08             	incl   0x8(%ebp)
  801297:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80129a:	0f af 45 10          	imul   0x10(%ebp),%eax
  80129e:	89 c2                	mov    %eax,%edx
  8012a0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8012a3:	01 d0                	add    %edx,%eax
  8012a5:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  8012a8:	e9 7b ff ff ff       	jmp    801228 <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  8012ad:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  8012ae:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8012b2:	74 08                	je     8012bc <strtol+0x134>
		*endptr = (char *) s;
  8012b4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012b7:	8b 55 08             	mov    0x8(%ebp),%edx
  8012ba:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  8012bc:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8012c0:	74 07                	je     8012c9 <strtol+0x141>
  8012c2:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8012c5:	f7 d8                	neg    %eax
  8012c7:	eb 03                	jmp    8012cc <strtol+0x144>
  8012c9:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  8012cc:	c9                   	leave  
  8012cd:	c3                   	ret    

008012ce <ltostr>:

void
ltostr(long value, char *str)
{
  8012ce:	55                   	push   %ebp
  8012cf:	89 e5                	mov    %esp,%ebp
  8012d1:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  8012d4:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  8012db:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  8012e2:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8012e6:	79 13                	jns    8012fb <ltostr+0x2d>
	{
		neg = 1;
  8012e8:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  8012ef:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012f2:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  8012f5:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  8012f8:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  8012fb:	8b 45 08             	mov    0x8(%ebp),%eax
  8012fe:	b9 0a 00 00 00       	mov    $0xa,%ecx
  801303:	99                   	cltd   
  801304:	f7 f9                	idiv   %ecx
  801306:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  801309:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80130c:	8d 50 01             	lea    0x1(%eax),%edx
  80130f:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801312:	89 c2                	mov    %eax,%edx
  801314:	8b 45 0c             	mov    0xc(%ebp),%eax
  801317:	01 d0                	add    %edx,%eax
  801319:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80131c:	83 c2 30             	add    $0x30,%edx
  80131f:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  801321:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801324:	b8 67 66 66 66       	mov    $0x66666667,%eax
  801329:	f7 e9                	imul   %ecx
  80132b:	c1 fa 02             	sar    $0x2,%edx
  80132e:	89 c8                	mov    %ecx,%eax
  801330:	c1 f8 1f             	sar    $0x1f,%eax
  801333:	29 c2                	sub    %eax,%edx
  801335:	89 d0                	mov    %edx,%eax
  801337:	89 45 08             	mov    %eax,0x8(%ebp)
	} while (value % 10 != 0);
  80133a:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80133d:	b8 67 66 66 66       	mov    $0x66666667,%eax
  801342:	f7 e9                	imul   %ecx
  801344:	c1 fa 02             	sar    $0x2,%edx
  801347:	89 c8                	mov    %ecx,%eax
  801349:	c1 f8 1f             	sar    $0x1f,%eax
  80134c:	29 c2                	sub    %eax,%edx
  80134e:	89 d0                	mov    %edx,%eax
  801350:	c1 e0 02             	shl    $0x2,%eax
  801353:	01 d0                	add    %edx,%eax
  801355:	01 c0                	add    %eax,%eax
  801357:	29 c1                	sub    %eax,%ecx
  801359:	89 ca                	mov    %ecx,%edx
  80135b:	85 d2                	test   %edx,%edx
  80135d:	75 9c                	jne    8012fb <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  80135f:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  801366:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801369:	48                   	dec    %eax
  80136a:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  80136d:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801371:	74 3d                	je     8013b0 <ltostr+0xe2>
		start = 1 ;
  801373:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  80137a:	eb 34                	jmp    8013b0 <ltostr+0xe2>
	{
		char tmp = str[start] ;
  80137c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80137f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801382:	01 d0                	add    %edx,%eax
  801384:	8a 00                	mov    (%eax),%al
  801386:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  801389:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80138c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80138f:	01 c2                	add    %eax,%edx
  801391:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  801394:	8b 45 0c             	mov    0xc(%ebp),%eax
  801397:	01 c8                	add    %ecx,%eax
  801399:	8a 00                	mov    (%eax),%al
  80139b:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  80139d:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8013a0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8013a3:	01 c2                	add    %eax,%edx
  8013a5:	8a 45 eb             	mov    -0x15(%ebp),%al
  8013a8:	88 02                	mov    %al,(%edx)
		start++ ;
  8013aa:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  8013ad:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  8013b0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8013b3:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8013b6:	7c c4                	jl     80137c <ltostr+0xae>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  8013b8:	8b 55 f8             	mov    -0x8(%ebp),%edx
  8013bb:	8b 45 0c             	mov    0xc(%ebp),%eax
  8013be:	01 d0                	add    %edx,%eax
  8013c0:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  8013c3:	90                   	nop
  8013c4:	c9                   	leave  
  8013c5:	c3                   	ret    

008013c6 <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  8013c6:	55                   	push   %ebp
  8013c7:	89 e5                	mov    %esp,%ebp
  8013c9:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  8013cc:	ff 75 08             	pushl  0x8(%ebp)
  8013cf:	e8 54 fa ff ff       	call   800e28 <strlen>
  8013d4:	83 c4 04             	add    $0x4,%esp
  8013d7:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  8013da:	ff 75 0c             	pushl  0xc(%ebp)
  8013dd:	e8 46 fa ff ff       	call   800e28 <strlen>
  8013e2:	83 c4 04             	add    $0x4,%esp
  8013e5:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  8013e8:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  8013ef:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8013f6:	eb 17                	jmp    80140f <strcconcat+0x49>
		final[s] = str1[s] ;
  8013f8:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8013fb:	8b 45 10             	mov    0x10(%ebp),%eax
  8013fe:	01 c2                	add    %eax,%edx
  801400:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  801403:	8b 45 08             	mov    0x8(%ebp),%eax
  801406:	01 c8                	add    %ecx,%eax
  801408:	8a 00                	mov    (%eax),%al
  80140a:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  80140c:	ff 45 fc             	incl   -0x4(%ebp)
  80140f:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801412:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  801415:	7c e1                	jl     8013f8 <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  801417:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  80141e:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  801425:	eb 1f                	jmp    801446 <strcconcat+0x80>
		final[s++] = str2[i] ;
  801427:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80142a:	8d 50 01             	lea    0x1(%eax),%edx
  80142d:	89 55 fc             	mov    %edx,-0x4(%ebp)
  801430:	89 c2                	mov    %eax,%edx
  801432:	8b 45 10             	mov    0x10(%ebp),%eax
  801435:	01 c2                	add    %eax,%edx
  801437:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  80143a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80143d:	01 c8                	add    %ecx,%eax
  80143f:	8a 00                	mov    (%eax),%al
  801441:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  801443:	ff 45 f8             	incl   -0x8(%ebp)
  801446:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801449:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80144c:	7c d9                	jl     801427 <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  80144e:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801451:	8b 45 10             	mov    0x10(%ebp),%eax
  801454:	01 d0                	add    %edx,%eax
  801456:	c6 00 00             	movb   $0x0,(%eax)
}
  801459:	90                   	nop
  80145a:	c9                   	leave  
  80145b:	c3                   	ret    

0080145c <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  80145c:	55                   	push   %ebp
  80145d:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  80145f:	8b 45 14             	mov    0x14(%ebp),%eax
  801462:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  801468:	8b 45 14             	mov    0x14(%ebp),%eax
  80146b:	8b 00                	mov    (%eax),%eax
  80146d:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801474:	8b 45 10             	mov    0x10(%ebp),%eax
  801477:	01 d0                	add    %edx,%eax
  801479:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  80147f:	eb 0c                	jmp    80148d <strsplit+0x31>
			*string++ = 0;
  801481:	8b 45 08             	mov    0x8(%ebp),%eax
  801484:	8d 50 01             	lea    0x1(%eax),%edx
  801487:	89 55 08             	mov    %edx,0x8(%ebp)
  80148a:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  80148d:	8b 45 08             	mov    0x8(%ebp),%eax
  801490:	8a 00                	mov    (%eax),%al
  801492:	84 c0                	test   %al,%al
  801494:	74 18                	je     8014ae <strsplit+0x52>
  801496:	8b 45 08             	mov    0x8(%ebp),%eax
  801499:	8a 00                	mov    (%eax),%al
  80149b:	0f be c0             	movsbl %al,%eax
  80149e:	50                   	push   %eax
  80149f:	ff 75 0c             	pushl  0xc(%ebp)
  8014a2:	e8 13 fb ff ff       	call   800fba <strchr>
  8014a7:	83 c4 08             	add    $0x8,%esp
  8014aa:	85 c0                	test   %eax,%eax
  8014ac:	75 d3                	jne    801481 <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  8014ae:	8b 45 08             	mov    0x8(%ebp),%eax
  8014b1:	8a 00                	mov    (%eax),%al
  8014b3:	84 c0                	test   %al,%al
  8014b5:	74 5a                	je     801511 <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  8014b7:	8b 45 14             	mov    0x14(%ebp),%eax
  8014ba:	8b 00                	mov    (%eax),%eax
  8014bc:	83 f8 0f             	cmp    $0xf,%eax
  8014bf:	75 07                	jne    8014c8 <strsplit+0x6c>
		{
			return 0;
  8014c1:	b8 00 00 00 00       	mov    $0x0,%eax
  8014c6:	eb 66                	jmp    80152e <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  8014c8:	8b 45 14             	mov    0x14(%ebp),%eax
  8014cb:	8b 00                	mov    (%eax),%eax
  8014cd:	8d 48 01             	lea    0x1(%eax),%ecx
  8014d0:	8b 55 14             	mov    0x14(%ebp),%edx
  8014d3:	89 0a                	mov    %ecx,(%edx)
  8014d5:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8014dc:	8b 45 10             	mov    0x10(%ebp),%eax
  8014df:	01 c2                	add    %eax,%edx
  8014e1:	8b 45 08             	mov    0x8(%ebp),%eax
  8014e4:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  8014e6:	eb 03                	jmp    8014eb <strsplit+0x8f>
			string++;
  8014e8:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  8014eb:	8b 45 08             	mov    0x8(%ebp),%eax
  8014ee:	8a 00                	mov    (%eax),%al
  8014f0:	84 c0                	test   %al,%al
  8014f2:	74 8b                	je     80147f <strsplit+0x23>
  8014f4:	8b 45 08             	mov    0x8(%ebp),%eax
  8014f7:	8a 00                	mov    (%eax),%al
  8014f9:	0f be c0             	movsbl %al,%eax
  8014fc:	50                   	push   %eax
  8014fd:	ff 75 0c             	pushl  0xc(%ebp)
  801500:	e8 b5 fa ff ff       	call   800fba <strchr>
  801505:	83 c4 08             	add    $0x8,%esp
  801508:	85 c0                	test   %eax,%eax
  80150a:	74 dc                	je     8014e8 <strsplit+0x8c>
			string++;
	}
  80150c:	e9 6e ff ff ff       	jmp    80147f <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  801511:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  801512:	8b 45 14             	mov    0x14(%ebp),%eax
  801515:	8b 00                	mov    (%eax),%eax
  801517:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80151e:	8b 45 10             	mov    0x10(%ebp),%eax
  801521:	01 d0                	add    %edx,%eax
  801523:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  801529:	b8 01 00 00 00       	mov    $0x1,%eax
}
  80152e:	c9                   	leave  
  80152f:	c3                   	ret    

00801530 <InitializeUHeap>:
//============================== GIVEN FUNCTIONS ===================================//
//==================================================================================//

int FirstTimeFlag = 1;
void InitializeUHeap()
{
  801530:	55                   	push   %ebp
  801531:	89 e5                	mov    %esp,%ebp
  801533:	83 ec 08             	sub    $0x8,%esp
	if(FirstTimeFlag)
  801536:	a1 04 40 80 00       	mov    0x804004,%eax
  80153b:	85 c0                	test   %eax,%eax
  80153d:	74 1f                	je     80155e <InitializeUHeap+0x2e>
	{
		initialize_dyn_block_system();
  80153f:	e8 1d 00 00 00       	call   801561 <initialize_dyn_block_system>
		cprintf("DYNAMIC BLOCK SYSTEM IS INITIALIZED\n");
  801544:	83 ec 0c             	sub    $0xc,%esp
  801547:	68 70 39 80 00       	push   $0x803970
  80154c:	e8 55 f2 ff ff       	call   8007a6 <cprintf>
  801551:	83 c4 10             	add    $0x10,%esp
#if UHP_USE_BUDDY
		initialize_buddy();
		cprintf("BUDDY SYSTEM IS INITIALIZED\n");
#endif
		FirstTimeFlag = 0;
  801554:	c7 05 04 40 80 00 00 	movl   $0x0,0x804004
  80155b:	00 00 00 
	}
}
  80155e:	90                   	nop
  80155f:	c9                   	leave  
  801560:	c3                   	ret    

00801561 <initialize_dyn_block_system>:

//=================================
// [1] INITIALIZE DYNAMIC ALLOCATOR:
//=================================
void initialize_dyn_block_system()
{
  801561:	55                   	push   %ebp
  801562:	89 e5                	mov    %esp,%ebp
  801564:	83 ec 28             	sub    $0x28,%esp
	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] initialize_dyn_block_system
	// your code is here, remove the panic and write your code
	//panic("initialize_dyn_block_system() is not implemented yet...!!");

	LIST_INIT(&AllocMemBlocksList);
  801567:	c7 05 40 40 80 00 00 	movl   $0x0,0x804040
  80156e:	00 00 00 
  801571:	c7 05 44 40 80 00 00 	movl   $0x0,0x804044
  801578:	00 00 00 
  80157b:	c7 05 4c 40 80 00 00 	movl   $0x0,0x80404c
  801582:	00 00 00 
	LIST_INIT(&FreeMemBlocksList);
  801585:	c7 05 38 41 80 00 00 	movl   $0x0,0x804138
  80158c:	00 00 00 
  80158f:	c7 05 3c 41 80 00 00 	movl   $0x0,0x80413c
  801596:	00 00 00 
  801599:	c7 05 44 41 80 00 00 	movl   $0x0,0x804144
  8015a0:	00 00 00 
	MAX_MEM_BLOCK_CNT = NUM_OF_UHEAP_PAGES;
  8015a3:	c7 05 20 41 80 00 00 	movl   $0x20000,0x804120
  8015aa:	00 02 00 
	MemBlockNodes = (void*)USER_DYN_BLKS_ARRAY;
  8015ad:	c7 45 f4 00 00 e0 7f 	movl   $0x7fe00000,-0xc(%ebp)
  8015b4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8015b7:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8015bc:	2d 00 10 00 00       	sub    $0x1000,%eax
  8015c1:	a3 50 40 80 00       	mov    %eax,0x804050
	int size_of_block = sizeof(struct MemBlock);
  8015c6:	c7 45 f0 10 00 00 00 	movl   $0x10,-0x10(%ebp)
	int size_all_struct = size_of_block*MAX_MEM_BLOCK_CNT;
  8015cd:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8015d0:	a1 20 41 80 00       	mov    0x804120,%eax
  8015d5:	0f af c2             	imul   %edx,%eax
  8015d8:	89 45 ec             	mov    %eax,-0x14(%ebp)
	size_all_struct = ROUNDUP(size_all_struct, PAGE_SIZE);
  8015db:	c7 45 e8 00 10 00 00 	movl   $0x1000,-0x18(%ebp)
  8015e2:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8015e5:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8015e8:	01 d0                	add    %edx,%eax
  8015ea:	48                   	dec    %eax
  8015eb:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8015ee:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8015f1:	ba 00 00 00 00       	mov    $0x0,%edx
  8015f6:	f7 75 e8             	divl   -0x18(%ebp)
  8015f9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8015fc:	29 d0                	sub    %edx,%eax
  8015fe:	89 45 ec             	mov    %eax,-0x14(%ebp)
	sys_allocate_chunk(USER_DYN_BLKS_ARRAY, size_all_struct,PERM_USER| PERM_WRITEABLE);
  801601:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801604:	c7 45 e0 00 00 e0 7f 	movl   $0x7fe00000,-0x20(%ebp)
  80160b:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80160e:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
  801614:	81 ea 00 10 00 00    	sub    $0x1000,%edx
  80161a:	83 ec 04             	sub    $0x4,%esp
  80161d:	6a 06                	push   $0x6
  80161f:	50                   	push   %eax
  801620:	52                   	push   %edx
  801621:	e8 a1 05 00 00       	call   801bc7 <sys_allocate_chunk>
  801626:	83 c4 10             	add    $0x10,%esp
	initialize_MemBlocksList(MAX_MEM_BLOCK_CNT);
  801629:	a1 20 41 80 00       	mov    0x804120,%eax
  80162e:	83 ec 0c             	sub    $0xc,%esp
  801631:	50                   	push   %eax
  801632:	e8 16 0c 00 00       	call   80224d <initialize_MemBlocksList>
  801637:	83 c4 10             	add    $0x10,%esp
	struct MemBlock* ourBlock =LIST_LAST(&AvailableMemBlocksList);
  80163a:	a1 4c 41 80 00       	mov    0x80414c,%eax
  80163f:	89 45 dc             	mov    %eax,-0x24(%ebp)
	LIST_REMOVE(&AvailableMemBlocksList,ourBlock);
  801642:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  801646:	75 14                	jne    80165c <initialize_dyn_block_system+0xfb>
  801648:	83 ec 04             	sub    $0x4,%esp
  80164b:	68 95 39 80 00       	push   $0x803995
  801650:	6a 2d                	push   $0x2d
  801652:	68 b3 39 80 00       	push   $0x8039b3
  801657:	e8 96 ee ff ff       	call   8004f2 <_panic>
  80165c:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80165f:	8b 00                	mov    (%eax),%eax
  801661:	85 c0                	test   %eax,%eax
  801663:	74 10                	je     801675 <initialize_dyn_block_system+0x114>
  801665:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801668:	8b 00                	mov    (%eax),%eax
  80166a:	8b 55 dc             	mov    -0x24(%ebp),%edx
  80166d:	8b 52 04             	mov    0x4(%edx),%edx
  801670:	89 50 04             	mov    %edx,0x4(%eax)
  801673:	eb 0b                	jmp    801680 <initialize_dyn_block_system+0x11f>
  801675:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801678:	8b 40 04             	mov    0x4(%eax),%eax
  80167b:	a3 4c 41 80 00       	mov    %eax,0x80414c
  801680:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801683:	8b 40 04             	mov    0x4(%eax),%eax
  801686:	85 c0                	test   %eax,%eax
  801688:	74 0f                	je     801699 <initialize_dyn_block_system+0x138>
  80168a:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80168d:	8b 40 04             	mov    0x4(%eax),%eax
  801690:	8b 55 dc             	mov    -0x24(%ebp),%edx
  801693:	8b 12                	mov    (%edx),%edx
  801695:	89 10                	mov    %edx,(%eax)
  801697:	eb 0a                	jmp    8016a3 <initialize_dyn_block_system+0x142>
  801699:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80169c:	8b 00                	mov    (%eax),%eax
  80169e:	a3 48 41 80 00       	mov    %eax,0x804148
  8016a3:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8016a6:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8016ac:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8016af:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8016b6:	a1 54 41 80 00       	mov    0x804154,%eax
  8016bb:	48                   	dec    %eax
  8016bc:	a3 54 41 80 00       	mov    %eax,0x804154
	ourBlock->size = USER_HEAP_MAX-USER_HEAP_START;
  8016c1:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8016c4:	c7 40 0c 00 00 00 20 	movl   $0x20000000,0xc(%eax)
	ourBlock->sva=USER_HEAP_START;
  8016cb:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8016ce:	c7 40 08 00 00 00 80 	movl   $0x80000000,0x8(%eax)
	LIST_INSERT_TAIL(&FreeMemBlocksList, ourBlock);
  8016d5:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  8016d9:	75 14                	jne    8016ef <initialize_dyn_block_system+0x18e>
  8016db:	83 ec 04             	sub    $0x4,%esp
  8016de:	68 c0 39 80 00       	push   $0x8039c0
  8016e3:	6a 30                	push   $0x30
  8016e5:	68 b3 39 80 00       	push   $0x8039b3
  8016ea:	e8 03 ee ff ff       	call   8004f2 <_panic>
  8016ef:	8b 15 3c 41 80 00    	mov    0x80413c,%edx
  8016f5:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8016f8:	89 50 04             	mov    %edx,0x4(%eax)
  8016fb:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8016fe:	8b 40 04             	mov    0x4(%eax),%eax
  801701:	85 c0                	test   %eax,%eax
  801703:	74 0c                	je     801711 <initialize_dyn_block_system+0x1b0>
  801705:	a1 3c 41 80 00       	mov    0x80413c,%eax
  80170a:	8b 55 dc             	mov    -0x24(%ebp),%edx
  80170d:	89 10                	mov    %edx,(%eax)
  80170f:	eb 08                	jmp    801719 <initialize_dyn_block_system+0x1b8>
  801711:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801714:	a3 38 41 80 00       	mov    %eax,0x804138
  801719:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80171c:	a3 3c 41 80 00       	mov    %eax,0x80413c
  801721:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801724:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80172a:	a1 44 41 80 00       	mov    0x804144,%eax
  80172f:	40                   	inc    %eax
  801730:	a3 44 41 80 00       	mov    %eax,0x804144
	//[1] Initialize two lists (AllocMemBlocksList & FreeMemBlocksList) [Hint: use LIST_INIT()]
	//[2] Dynamically allocate the array of MemBlockNodes at VA USER_DYN_BLKS_ARRAY
	//	  (remember to set MAX_MEM_BLOCK_CNT with the chosen size of the array)
	//[3] Initialize AvailableMemBlocksList by filling it with the MemBlockNodes
	//[4] Insert a new MemBlock with the heap size into the FreeMemBlocksList
}
  801735:	90                   	nop
  801736:	c9                   	leave  
  801737:	c3                   	ret    

00801738 <malloc>:
//=================================
// [2] ALLOCATE SPACE IN USER HEAP:
//=================================

void* malloc(uint32 size)
{
  801738:	55                   	push   %ebp
  801739:	89 e5                	mov    %esp,%ebp
  80173b:	83 ec 18             	sub    $0x18,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  80173e:	e8 ed fd ff ff       	call   801530 <InitializeUHeap>
	if (size == 0) return NULL ;
  801743:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801747:	75 07                	jne    801750 <malloc+0x18>
  801749:	b8 00 00 00 00       	mov    $0x0,%eax
  80174e:	eb 67                	jmp    8017b7 <malloc+0x7f>

	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] malloc
	// your code is here, remove the panic and write your code
	//panic("malloc() is not implemented yet...!!");

	size = ROUNDUP(size, PAGE_SIZE);
  801750:	c7 45 f4 00 10 00 00 	movl   $0x1000,-0xc(%ebp)
  801757:	8b 55 08             	mov    0x8(%ebp),%edx
  80175a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80175d:	01 d0                	add    %edx,%eax
  80175f:	48                   	dec    %eax
  801760:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801763:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801766:	ba 00 00 00 00       	mov    $0x0,%edx
  80176b:	f7 75 f4             	divl   -0xc(%ebp)
  80176e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801771:	29 d0                	sub    %edx,%eax
  801773:	89 45 08             	mov    %eax,0x8(%ebp)
	if(sys_isUHeapPlacementStrategyFIRSTFIT())
  801776:	e8 1a 08 00 00       	call   801f95 <sys_isUHeapPlacementStrategyFIRSTFIT>
  80177b:	85 c0                	test   %eax,%eax
  80177d:	74 33                	je     8017b2 <malloc+0x7a>
	{
		struct MemBlock * myBlock = alloc_block_FF(size);
  80177f:	83 ec 0c             	sub    $0xc,%esp
  801782:	ff 75 08             	pushl  0x8(%ebp)
  801785:	e8 0c 0e 00 00       	call   802596 <alloc_block_FF>
  80178a:	83 c4 10             	add    $0x10,%esp
  80178d:	89 45 ec             	mov    %eax,-0x14(%ebp)
		if(myBlock != NULL)
  801790:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  801794:	74 1c                	je     8017b2 <malloc+0x7a>
		{
			insert_sorted_allocList(myBlock);
  801796:	83 ec 0c             	sub    $0xc,%esp
  801799:	ff 75 ec             	pushl  -0x14(%ebp)
  80179c:	e8 07 0c 00 00       	call   8023a8 <insert_sorted_allocList>
  8017a1:	83 c4 10             	add    $0x10,%esp
			uint32 ptr = myBlock->sva;
  8017a4:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8017a7:	8b 40 08             	mov    0x8(%eax),%eax
  8017aa:	89 45 e8             	mov    %eax,-0x18(%ebp)
			return (void *)ptr;
  8017ad:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8017b0:	eb 05                	jmp    8017b7 <malloc+0x7f>
		}
	}
	return NULL;
  8017b2:	b8 00 00 00 00       	mov    $0x0,%eax
	//		to the required allocation size (space should be on 4 KB BOUNDARY)
	//	2) if no suitable space found, return NULL
	// 	3) Return pointer containing the virtual address of allocated space,
	//
	//Use sys_isUHeapPlacementStrategyFIRSTFIT()... to check the current strategy
}
  8017b7:	c9                   	leave  
  8017b8:	c3                   	ret    

008017b9 <free>:
//	We can use sys_free_user_mem(uint32 virtual_address, uint32 size); which
//		switches to the kernel mode, calls free_user_mem() in
//		"kern/mem/chunk_operations.c", then switch back to the user mode here
//	the free_user_mem function is empty, make sure to implement it.
void free(void* virtual_address)
{
  8017b9:	55                   	push   %ebp
  8017ba:	89 e5                	mov    %esp,%ebp
  8017bc:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] free
	// your code is here, remove the panic and write your code
	//panic("free() is not implemented yet...!!");

	uint32 virtualAddress = (uint32 )(virtual_address);
  8017bf:	8b 45 08             	mov    0x8(%ebp),%eax
  8017c2:	89 45 f4             	mov    %eax,-0xc(%ebp)
//	virtualAddress = ROUNDDOWN(virtualAddress, PAGE_SIZE);
	struct MemBlock * myBlock = find_block(&AllocMemBlocksList, virtualAddress);
  8017c5:	83 ec 08             	sub    $0x8,%esp
  8017c8:	ff 75 f4             	pushl  -0xc(%ebp)
  8017cb:	68 40 40 80 00       	push   $0x804040
  8017d0:	e8 5b 0b 00 00       	call   802330 <find_block>
  8017d5:	83 c4 10             	add    $0x10,%esp
  8017d8:	89 45 f0             	mov    %eax,-0x10(%ebp)
//	cprintf ("ptr sva at free user side = %x \n", myBlock->sva);
	sys_free_user_mem(virtualAddress, myBlock->size);
  8017db:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8017de:	8b 40 0c             	mov    0xc(%eax),%eax
  8017e1:	83 ec 08             	sub    $0x8,%esp
  8017e4:	50                   	push   %eax
  8017e5:	ff 75 f4             	pushl  -0xc(%ebp)
  8017e8:	e8 a2 03 00 00       	call   801b8f <sys_free_user_mem>
  8017ed:	83 c4 10             	add    $0x10,%esp
	LIST_REMOVE(&AllocMemBlocksList, myBlock);
  8017f0:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8017f4:	75 14                	jne    80180a <free+0x51>
  8017f6:	83 ec 04             	sub    $0x4,%esp
  8017f9:	68 95 39 80 00       	push   $0x803995
  8017fe:	6a 76                	push   $0x76
  801800:	68 b3 39 80 00       	push   $0x8039b3
  801805:	e8 e8 ec ff ff       	call   8004f2 <_panic>
  80180a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80180d:	8b 00                	mov    (%eax),%eax
  80180f:	85 c0                	test   %eax,%eax
  801811:	74 10                	je     801823 <free+0x6a>
  801813:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801816:	8b 00                	mov    (%eax),%eax
  801818:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80181b:	8b 52 04             	mov    0x4(%edx),%edx
  80181e:	89 50 04             	mov    %edx,0x4(%eax)
  801821:	eb 0b                	jmp    80182e <free+0x75>
  801823:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801826:	8b 40 04             	mov    0x4(%eax),%eax
  801829:	a3 44 40 80 00       	mov    %eax,0x804044
  80182e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801831:	8b 40 04             	mov    0x4(%eax),%eax
  801834:	85 c0                	test   %eax,%eax
  801836:	74 0f                	je     801847 <free+0x8e>
  801838:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80183b:	8b 40 04             	mov    0x4(%eax),%eax
  80183e:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801841:	8b 12                	mov    (%edx),%edx
  801843:	89 10                	mov    %edx,(%eax)
  801845:	eb 0a                	jmp    801851 <free+0x98>
  801847:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80184a:	8b 00                	mov    (%eax),%eax
  80184c:	a3 40 40 80 00       	mov    %eax,0x804040
  801851:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801854:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80185a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80185d:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  801864:	a1 4c 40 80 00       	mov    0x80404c,%eax
  801869:	48                   	dec    %eax
  80186a:	a3 4c 40 80 00       	mov    %eax,0x80404c
	insert_sorted_with_merge_freeList(myBlock);
  80186f:	83 ec 0c             	sub    $0xc,%esp
  801872:	ff 75 f0             	pushl  -0x10(%ebp)
  801875:	e8 0b 14 00 00       	call   802c85 <insert_sorted_with_merge_freeList>
  80187a:	83 c4 10             	add    $0x10,%esp

	//you should get the size of the given allocation using its address
	//you need to call sys_free_user_mem()
	//refer to the project presentation and documentation for details
}
  80187d:	90                   	nop
  80187e:	c9                   	leave  
  80187f:	c3                   	ret    

00801880 <smalloc>:

//=================================
// [4] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
  801880:	55                   	push   %ebp
  801881:	89 e5                	mov    %esp,%ebp
  801883:	83 ec 28             	sub    $0x28,%esp
  801886:	8b 45 10             	mov    0x10(%ebp),%eax
  801889:	88 45 e4             	mov    %al,-0x1c(%ebp)
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  80188c:	e8 9f fc ff ff       	call   801530 <InitializeUHeap>
	if (size == 0) return NULL ;
  801891:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801895:	75 0a                	jne    8018a1 <smalloc+0x21>
  801897:	b8 00 00 00 00       	mov    $0x0,%eax
  80189c:	e9 8d 00 00 00       	jmp    80192e <smalloc+0xae>

	//This function should find the space of the required range
	// * ON 4KB BOUNDARY **** //
	//Use sys_isUHeapPlacementStrategyFIRSTFIT() to check the current strategy

	size = ROUNDUP(size, PAGE_SIZE);
  8018a1:	c7 45 f4 00 10 00 00 	movl   $0x1000,-0xc(%ebp)
  8018a8:	8b 55 0c             	mov    0xc(%ebp),%edx
  8018ab:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8018ae:	01 d0                	add    %edx,%eax
  8018b0:	48                   	dec    %eax
  8018b1:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8018b4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8018b7:	ba 00 00 00 00       	mov    $0x0,%edx
  8018bc:	f7 75 f4             	divl   -0xc(%ebp)
  8018bf:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8018c2:	29 d0                	sub    %edx,%eax
  8018c4:	89 45 0c             	mov    %eax,0xc(%ebp)
		if(sys_isUHeapPlacementStrategyFIRSTFIT())
  8018c7:	e8 c9 06 00 00       	call   801f95 <sys_isUHeapPlacementStrategyFIRSTFIT>
  8018cc:	85 c0                	test   %eax,%eax
  8018ce:	74 59                	je     801929 <smalloc+0xa9>
		{
			struct MemBlock * v1=NULL;
  8018d0:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
			v1= alloc_block_FF(size);
  8018d7:	83 ec 0c             	sub    $0xc,%esp
  8018da:	ff 75 0c             	pushl  0xc(%ebp)
  8018dd:	e8 b4 0c 00 00       	call   802596 <alloc_block_FF>
  8018e2:	83 c4 10             	add    $0x10,%esp
  8018e5:	89 45 ec             	mov    %eax,-0x14(%ebp)
			if(v1==NULL)
  8018e8:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8018ec:	75 07                	jne    8018f5 <smalloc+0x75>
			{
				return NULL;
  8018ee:	b8 00 00 00 00       	mov    $0x0,%eax
  8018f3:	eb 39                	jmp    80192e <smalloc+0xae>
			}
			else
			{
				int ret=sys_createSharedObject(sharedVarName,  size,  isWritable,(void*)v1->sva);
  8018f5:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8018f8:	8b 40 08             	mov    0x8(%eax),%eax
  8018fb:	89 c2                	mov    %eax,%edx
  8018fd:	0f b6 45 e4          	movzbl -0x1c(%ebp),%eax
  801901:	52                   	push   %edx
  801902:	50                   	push   %eax
  801903:	ff 75 0c             	pushl  0xc(%ebp)
  801906:	ff 75 08             	pushl  0x8(%ebp)
  801909:	e8 0c 04 00 00       	call   801d1a <sys_createSharedObject>
  80190e:	83 c4 10             	add    $0x10,%esp
  801911:	89 45 e8             	mov    %eax,-0x18(%ebp)
				if(ret>=0)
  801914:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  801918:	78 08                	js     801922 <smalloc+0xa2>
				{
					return (void*)v1->sva;
  80191a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80191d:	8b 40 08             	mov    0x8(%eax),%eax
  801920:	eb 0c                	jmp    80192e <smalloc+0xae>
				}
				else
				{
					return NULL;
  801922:	b8 00 00 00 00       	mov    $0x0,%eax
  801927:	eb 05                	jmp    80192e <smalloc+0xae>
				}
			}

		}
		return NULL;
  801929:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80192e:	c9                   	leave  
  80192f:	c3                   	ret    

00801930 <sget>:

//========================================
// [5] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  801930:	55                   	push   %ebp
  801931:	89 e5                	mov    %esp,%ebp
  801933:	83 ec 18             	sub    $0x18,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801936:	e8 f5 fb ff ff       	call   801530 <InitializeUHeap>

	//This function should find the space for sharing the variable
	// *** ON 4KB BOUNDARY ******** //

	//Use sys_isUHeapPlacementStrategyFIRSTFIT() to check the current strategy
	int ret=sys_getSizeOfSharedObject(ownerEnvID,sharedVarName);
  80193b:	83 ec 08             	sub    $0x8,%esp
  80193e:	ff 75 0c             	pushl  0xc(%ebp)
  801941:	ff 75 08             	pushl  0x8(%ebp)
  801944:	e8 fb 03 00 00       	call   801d44 <sys_getSizeOfSharedObject>
  801949:	83 c4 10             	add    $0x10,%esp
  80194c:	89 45 f4             	mov    %eax,-0xc(%ebp)
	if(ret==0)
  80194f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801953:	75 07                	jne    80195c <sget+0x2c>
	{
		return NULL;
  801955:	b8 00 00 00 00       	mov    $0x0,%eax
  80195a:	eb 64                	jmp    8019c0 <sget+0x90>
	}
	if(sys_isUHeapPlacementStrategyFIRSTFIT())
  80195c:	e8 34 06 00 00       	call   801f95 <sys_isUHeapPlacementStrategyFIRSTFIT>
  801961:	85 c0                	test   %eax,%eax
  801963:	74 56                	je     8019bb <sget+0x8b>
	{
		struct MemBlock * v1=NULL;
  801965:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
		v1= alloc_block_FF(ret);
  80196c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80196f:	83 ec 0c             	sub    $0xc,%esp
  801972:	50                   	push   %eax
  801973:	e8 1e 0c 00 00       	call   802596 <alloc_block_FF>
  801978:	83 c4 10             	add    $0x10,%esp
  80197b:	89 45 f0             	mov    %eax,-0x10(%ebp)
		if(v1==NULL)
  80197e:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801982:	75 07                	jne    80198b <sget+0x5b>
		{
		return NULL;
  801984:	b8 00 00 00 00       	mov    $0x0,%eax
  801989:	eb 35                	jmp    8019c0 <sget+0x90>
	    }
		else
		{
			int ret1=sys_getSharedObject(ownerEnvID,sharedVarName,(void*)v1->sva);
  80198b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80198e:	8b 40 08             	mov    0x8(%eax),%eax
  801991:	83 ec 04             	sub    $0x4,%esp
  801994:	50                   	push   %eax
  801995:	ff 75 0c             	pushl  0xc(%ebp)
  801998:	ff 75 08             	pushl  0x8(%ebp)
  80199b:	e8 c1 03 00 00       	call   801d61 <sys_getSharedObject>
  8019a0:	83 c4 10             	add    $0x10,%esp
  8019a3:	89 45 ec             	mov    %eax,-0x14(%ebp)
			if(ret1>=0)
  8019a6:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8019aa:	78 08                	js     8019b4 <sget+0x84>
			{
				return (void*)v1->sva;
  8019ac:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8019af:	8b 40 08             	mov    0x8(%eax),%eax
  8019b2:	eb 0c                	jmp    8019c0 <sget+0x90>
			}
			else
			{
				return NULL;
  8019b4:	b8 00 00 00 00       	mov    $0x0,%eax
  8019b9:	eb 05                	jmp    8019c0 <sget+0x90>
			}
		}
	}
  return NULL;
  8019bb:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8019c0:	c9                   	leave  
  8019c1:	c3                   	ret    

008019c2 <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  8019c2:	55                   	push   %ebp
  8019c3:	89 e5                	mov    %esp,%ebp
  8019c5:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  8019c8:	e8 63 fb ff ff       	call   801530 <InitializeUHeap>
	//==============================================================
	// [USER HEAP - USER SIDE] realloc
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  8019cd:	83 ec 04             	sub    $0x4,%esp
  8019d0:	68 e4 39 80 00       	push   $0x8039e4
  8019d5:	68 0e 01 00 00       	push   $0x10e
  8019da:	68 b3 39 80 00       	push   $0x8039b3
  8019df:	e8 0e eb ff ff       	call   8004f2 <_panic>

008019e4 <sfree>:
//	use sys_freeSharedObject(...); which switches to the kernel mode,
//	calls freeSharedObject(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the freeSharedObject() function is empty, make sure to implement it.

void sfree(void* virtual_address)
{
  8019e4:	55                   	push   %ebp
  8019e5:	89 e5                	mov    %esp,%ebp
  8019e7:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS3 - BONUS] [SHARING - USER SIDE] sfree()

	// Write your code here, remove the panic and write your code
	panic("sfree() is not implemented yet...!!");
  8019ea:	83 ec 04             	sub    $0x4,%esp
  8019ed:	68 0c 3a 80 00       	push   $0x803a0c
  8019f2:	68 22 01 00 00       	push   $0x122
  8019f7:	68 b3 39 80 00       	push   $0x8039b3
  8019fc:	e8 f1 ea ff ff       	call   8004f2 <_panic>

00801a01 <expand>:

//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//
void expand(uint32 newSize)
{
  801a01:	55                   	push   %ebp
  801a02:	89 e5                	mov    %esp,%ebp
  801a04:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801a07:	83 ec 04             	sub    $0x4,%esp
  801a0a:	68 30 3a 80 00       	push   $0x803a30
  801a0f:	68 2d 01 00 00       	push   $0x12d
  801a14:	68 b3 39 80 00       	push   $0x8039b3
  801a19:	e8 d4 ea ff ff       	call   8004f2 <_panic>

00801a1e <shrink>:

}
void shrink(uint32 newSize)
{
  801a1e:	55                   	push   %ebp
  801a1f:	89 e5                	mov    %esp,%ebp
  801a21:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801a24:	83 ec 04             	sub    $0x4,%esp
  801a27:	68 30 3a 80 00       	push   $0x803a30
  801a2c:	68 32 01 00 00       	push   $0x132
  801a31:	68 b3 39 80 00       	push   $0x8039b3
  801a36:	e8 b7 ea ff ff       	call   8004f2 <_panic>

00801a3b <freeHeap>:

}
void freeHeap(void* virtual_address)
{
  801a3b:	55                   	push   %ebp
  801a3c:	89 e5                	mov    %esp,%ebp
  801a3e:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801a41:	83 ec 04             	sub    $0x4,%esp
  801a44:	68 30 3a 80 00       	push   $0x803a30
  801a49:	68 37 01 00 00       	push   $0x137
  801a4e:	68 b3 39 80 00       	push   $0x8039b3
  801a53:	e8 9a ea ff ff       	call   8004f2 <_panic>

00801a58 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  801a58:	55                   	push   %ebp
  801a59:	89 e5                	mov    %esp,%ebp
  801a5b:	57                   	push   %edi
  801a5c:	56                   	push   %esi
  801a5d:	53                   	push   %ebx
  801a5e:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801a61:	8b 45 08             	mov    0x8(%ebp),%eax
  801a64:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a67:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801a6a:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801a6d:	8b 7d 18             	mov    0x18(%ebp),%edi
  801a70:	8b 75 1c             	mov    0x1c(%ebp),%esi
  801a73:	cd 30                	int    $0x30
  801a75:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  801a78:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801a7b:	83 c4 10             	add    $0x10,%esp
  801a7e:	5b                   	pop    %ebx
  801a7f:	5e                   	pop    %esi
  801a80:	5f                   	pop    %edi
  801a81:	5d                   	pop    %ebp
  801a82:	c3                   	ret    

00801a83 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  801a83:	55                   	push   %ebp
  801a84:	89 e5                	mov    %esp,%ebp
  801a86:	83 ec 04             	sub    $0x4,%esp
  801a89:	8b 45 10             	mov    0x10(%ebp),%eax
  801a8c:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  801a8f:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801a93:	8b 45 08             	mov    0x8(%ebp),%eax
  801a96:	6a 00                	push   $0x0
  801a98:	6a 00                	push   $0x0
  801a9a:	52                   	push   %edx
  801a9b:	ff 75 0c             	pushl  0xc(%ebp)
  801a9e:	50                   	push   %eax
  801a9f:	6a 00                	push   $0x0
  801aa1:	e8 b2 ff ff ff       	call   801a58 <syscall>
  801aa6:	83 c4 18             	add    $0x18,%esp
}
  801aa9:	90                   	nop
  801aaa:	c9                   	leave  
  801aab:	c3                   	ret    

00801aac <sys_cgetc>:

int
sys_cgetc(void)
{
  801aac:	55                   	push   %ebp
  801aad:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  801aaf:	6a 00                	push   $0x0
  801ab1:	6a 00                	push   $0x0
  801ab3:	6a 00                	push   $0x0
  801ab5:	6a 00                	push   $0x0
  801ab7:	6a 00                	push   $0x0
  801ab9:	6a 01                	push   $0x1
  801abb:	e8 98 ff ff ff       	call   801a58 <syscall>
  801ac0:	83 c4 18             	add    $0x18,%esp
}
  801ac3:	c9                   	leave  
  801ac4:	c3                   	ret    

00801ac5 <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  801ac5:	55                   	push   %ebp
  801ac6:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  801ac8:	8b 55 0c             	mov    0xc(%ebp),%edx
  801acb:	8b 45 08             	mov    0x8(%ebp),%eax
  801ace:	6a 00                	push   $0x0
  801ad0:	6a 00                	push   $0x0
  801ad2:	6a 00                	push   $0x0
  801ad4:	52                   	push   %edx
  801ad5:	50                   	push   %eax
  801ad6:	6a 05                	push   $0x5
  801ad8:	e8 7b ff ff ff       	call   801a58 <syscall>
  801add:	83 c4 18             	add    $0x18,%esp
}
  801ae0:	c9                   	leave  
  801ae1:	c3                   	ret    

00801ae2 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  801ae2:	55                   	push   %ebp
  801ae3:	89 e5                	mov    %esp,%ebp
  801ae5:	56                   	push   %esi
  801ae6:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  801ae7:	8b 75 18             	mov    0x18(%ebp),%esi
  801aea:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801aed:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801af0:	8b 55 0c             	mov    0xc(%ebp),%edx
  801af3:	8b 45 08             	mov    0x8(%ebp),%eax
  801af6:	56                   	push   %esi
  801af7:	53                   	push   %ebx
  801af8:	51                   	push   %ecx
  801af9:	52                   	push   %edx
  801afa:	50                   	push   %eax
  801afb:	6a 06                	push   $0x6
  801afd:	e8 56 ff ff ff       	call   801a58 <syscall>
  801b02:	83 c4 18             	add    $0x18,%esp
}
  801b05:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801b08:	5b                   	pop    %ebx
  801b09:	5e                   	pop    %esi
  801b0a:	5d                   	pop    %ebp
  801b0b:	c3                   	ret    

00801b0c <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  801b0c:	55                   	push   %ebp
  801b0d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  801b0f:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b12:	8b 45 08             	mov    0x8(%ebp),%eax
  801b15:	6a 00                	push   $0x0
  801b17:	6a 00                	push   $0x0
  801b19:	6a 00                	push   $0x0
  801b1b:	52                   	push   %edx
  801b1c:	50                   	push   %eax
  801b1d:	6a 07                	push   $0x7
  801b1f:	e8 34 ff ff ff       	call   801a58 <syscall>
  801b24:	83 c4 18             	add    $0x18,%esp
}
  801b27:	c9                   	leave  
  801b28:	c3                   	ret    

00801b29 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  801b29:	55                   	push   %ebp
  801b2a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  801b2c:	6a 00                	push   $0x0
  801b2e:	6a 00                	push   $0x0
  801b30:	6a 00                	push   $0x0
  801b32:	ff 75 0c             	pushl  0xc(%ebp)
  801b35:	ff 75 08             	pushl  0x8(%ebp)
  801b38:	6a 08                	push   $0x8
  801b3a:	e8 19 ff ff ff       	call   801a58 <syscall>
  801b3f:	83 c4 18             	add    $0x18,%esp
}
  801b42:	c9                   	leave  
  801b43:	c3                   	ret    

00801b44 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  801b44:	55                   	push   %ebp
  801b45:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  801b47:	6a 00                	push   $0x0
  801b49:	6a 00                	push   $0x0
  801b4b:	6a 00                	push   $0x0
  801b4d:	6a 00                	push   $0x0
  801b4f:	6a 00                	push   $0x0
  801b51:	6a 09                	push   $0x9
  801b53:	e8 00 ff ff ff       	call   801a58 <syscall>
  801b58:	83 c4 18             	add    $0x18,%esp
}
  801b5b:	c9                   	leave  
  801b5c:	c3                   	ret    

00801b5d <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  801b5d:	55                   	push   %ebp
  801b5e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  801b60:	6a 00                	push   $0x0
  801b62:	6a 00                	push   $0x0
  801b64:	6a 00                	push   $0x0
  801b66:	6a 00                	push   $0x0
  801b68:	6a 00                	push   $0x0
  801b6a:	6a 0a                	push   $0xa
  801b6c:	e8 e7 fe ff ff       	call   801a58 <syscall>
  801b71:	83 c4 18             	add    $0x18,%esp
}
  801b74:	c9                   	leave  
  801b75:	c3                   	ret    

00801b76 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  801b76:	55                   	push   %ebp
  801b77:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  801b79:	6a 00                	push   $0x0
  801b7b:	6a 00                	push   $0x0
  801b7d:	6a 00                	push   $0x0
  801b7f:	6a 00                	push   $0x0
  801b81:	6a 00                	push   $0x0
  801b83:	6a 0b                	push   $0xb
  801b85:	e8 ce fe ff ff       	call   801a58 <syscall>
  801b8a:	83 c4 18             	add    $0x18,%esp
}
  801b8d:	c9                   	leave  
  801b8e:	c3                   	ret    

00801b8f <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  801b8f:	55                   	push   %ebp
  801b90:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  801b92:	6a 00                	push   $0x0
  801b94:	6a 00                	push   $0x0
  801b96:	6a 00                	push   $0x0
  801b98:	ff 75 0c             	pushl  0xc(%ebp)
  801b9b:	ff 75 08             	pushl  0x8(%ebp)
  801b9e:	6a 0f                	push   $0xf
  801ba0:	e8 b3 fe ff ff       	call   801a58 <syscall>
  801ba5:	83 c4 18             	add    $0x18,%esp
	return;
  801ba8:	90                   	nop
}
  801ba9:	c9                   	leave  
  801baa:	c3                   	ret    

00801bab <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  801bab:	55                   	push   %ebp
  801bac:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  801bae:	6a 00                	push   $0x0
  801bb0:	6a 00                	push   $0x0
  801bb2:	6a 00                	push   $0x0
  801bb4:	ff 75 0c             	pushl  0xc(%ebp)
  801bb7:	ff 75 08             	pushl  0x8(%ebp)
  801bba:	6a 10                	push   $0x10
  801bbc:	e8 97 fe ff ff       	call   801a58 <syscall>
  801bc1:	83 c4 18             	add    $0x18,%esp
	return ;
  801bc4:	90                   	nop
}
  801bc5:	c9                   	leave  
  801bc6:	c3                   	ret    

00801bc7 <sys_allocate_chunk>:

void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  801bc7:	55                   	push   %ebp
  801bc8:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  801bca:	6a 00                	push   $0x0
  801bcc:	6a 00                	push   $0x0
  801bce:	ff 75 10             	pushl  0x10(%ebp)
  801bd1:	ff 75 0c             	pushl  0xc(%ebp)
  801bd4:	ff 75 08             	pushl  0x8(%ebp)
  801bd7:	6a 11                	push   $0x11
  801bd9:	e8 7a fe ff ff       	call   801a58 <syscall>
  801bde:	83 c4 18             	add    $0x18,%esp
	return ;
  801be1:	90                   	nop
}
  801be2:	c9                   	leave  
  801be3:	c3                   	ret    

00801be4 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  801be4:	55                   	push   %ebp
  801be5:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  801be7:	6a 00                	push   $0x0
  801be9:	6a 00                	push   $0x0
  801beb:	6a 00                	push   $0x0
  801bed:	6a 00                	push   $0x0
  801bef:	6a 00                	push   $0x0
  801bf1:	6a 0c                	push   $0xc
  801bf3:	e8 60 fe ff ff       	call   801a58 <syscall>
  801bf8:	83 c4 18             	add    $0x18,%esp
}
  801bfb:	c9                   	leave  
  801bfc:	c3                   	ret    

00801bfd <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  801bfd:	55                   	push   %ebp
  801bfe:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  801c00:	6a 00                	push   $0x0
  801c02:	6a 00                	push   $0x0
  801c04:	6a 00                	push   $0x0
  801c06:	6a 00                	push   $0x0
  801c08:	ff 75 08             	pushl  0x8(%ebp)
  801c0b:	6a 0d                	push   $0xd
  801c0d:	e8 46 fe ff ff       	call   801a58 <syscall>
  801c12:	83 c4 18             	add    $0x18,%esp
}
  801c15:	c9                   	leave  
  801c16:	c3                   	ret    

00801c17 <sys_scarce_memory>:

void sys_scarce_memory()
{
  801c17:	55                   	push   %ebp
  801c18:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  801c1a:	6a 00                	push   $0x0
  801c1c:	6a 00                	push   $0x0
  801c1e:	6a 00                	push   $0x0
  801c20:	6a 00                	push   $0x0
  801c22:	6a 00                	push   $0x0
  801c24:	6a 0e                	push   $0xe
  801c26:	e8 2d fe ff ff       	call   801a58 <syscall>
  801c2b:	83 c4 18             	add    $0x18,%esp
}
  801c2e:	90                   	nop
  801c2f:	c9                   	leave  
  801c30:	c3                   	ret    

00801c31 <sys_disable_interrupt>:

//NEW !! 2012...
void
sys_disable_interrupt()
{
  801c31:	55                   	push   %ebp
  801c32:	89 e5                	mov    %esp,%ebp
	syscall(SYS_disableINTR,0, 0, 0, 0, 0);
  801c34:	6a 00                	push   $0x0
  801c36:	6a 00                	push   $0x0
  801c38:	6a 00                	push   $0x0
  801c3a:	6a 00                	push   $0x0
  801c3c:	6a 00                	push   $0x0
  801c3e:	6a 13                	push   $0x13
  801c40:	e8 13 fe ff ff       	call   801a58 <syscall>
  801c45:	83 c4 18             	add    $0x18,%esp
}
  801c48:	90                   	nop
  801c49:	c9                   	leave  
  801c4a:	c3                   	ret    

00801c4b <sys_enable_interrupt>:


void
sys_enable_interrupt()
{
  801c4b:	55                   	push   %ebp
  801c4c:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enableINTR,0, 0, 0, 0, 0);
  801c4e:	6a 00                	push   $0x0
  801c50:	6a 00                	push   $0x0
  801c52:	6a 00                	push   $0x0
  801c54:	6a 00                	push   $0x0
  801c56:	6a 00                	push   $0x0
  801c58:	6a 14                	push   $0x14
  801c5a:	e8 f9 fd ff ff       	call   801a58 <syscall>
  801c5f:	83 c4 18             	add    $0x18,%esp
}
  801c62:	90                   	nop
  801c63:	c9                   	leave  
  801c64:	c3                   	ret    

00801c65 <sys_cputc>:


void
sys_cputc(const char c)
{
  801c65:	55                   	push   %ebp
  801c66:	89 e5                	mov    %esp,%ebp
  801c68:	83 ec 04             	sub    $0x4,%esp
  801c6b:	8b 45 08             	mov    0x8(%ebp),%eax
  801c6e:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  801c71:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801c75:	6a 00                	push   $0x0
  801c77:	6a 00                	push   $0x0
  801c79:	6a 00                	push   $0x0
  801c7b:	6a 00                	push   $0x0
  801c7d:	50                   	push   %eax
  801c7e:	6a 15                	push   $0x15
  801c80:	e8 d3 fd ff ff       	call   801a58 <syscall>
  801c85:	83 c4 18             	add    $0x18,%esp
}
  801c88:	90                   	nop
  801c89:	c9                   	leave  
  801c8a:	c3                   	ret    

00801c8b <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  801c8b:	55                   	push   %ebp
  801c8c:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  801c8e:	6a 00                	push   $0x0
  801c90:	6a 00                	push   $0x0
  801c92:	6a 00                	push   $0x0
  801c94:	6a 00                	push   $0x0
  801c96:	6a 00                	push   $0x0
  801c98:	6a 16                	push   $0x16
  801c9a:	e8 b9 fd ff ff       	call   801a58 <syscall>
  801c9f:	83 c4 18             	add    $0x18,%esp
}
  801ca2:	90                   	nop
  801ca3:	c9                   	leave  
  801ca4:	c3                   	ret    

00801ca5 <sys_createSemaphore>:

int
sys_createSemaphore(char* semaphoreName, uint32 initialValue)
{
  801ca5:	55                   	push   %ebp
  801ca6:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_semaphore,(uint32)semaphoreName, (uint32)initialValue, 0, 0, 0);
  801ca8:	8b 45 08             	mov    0x8(%ebp),%eax
  801cab:	6a 00                	push   $0x0
  801cad:	6a 00                	push   $0x0
  801caf:	6a 00                	push   $0x0
  801cb1:	ff 75 0c             	pushl  0xc(%ebp)
  801cb4:	50                   	push   %eax
  801cb5:	6a 17                	push   $0x17
  801cb7:	e8 9c fd ff ff       	call   801a58 <syscall>
  801cbc:	83 c4 18             	add    $0x18,%esp
}
  801cbf:	c9                   	leave  
  801cc0:	c3                   	ret    

00801cc1 <sys_getSemaphoreValue>:

int
sys_getSemaphoreValue(int32 ownerEnvID, char* semaphoreName)
{
  801cc1:	55                   	push   %ebp
  801cc2:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_semaphore_value,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801cc4:	8b 55 0c             	mov    0xc(%ebp),%edx
  801cc7:	8b 45 08             	mov    0x8(%ebp),%eax
  801cca:	6a 00                	push   $0x0
  801ccc:	6a 00                	push   $0x0
  801cce:	6a 00                	push   $0x0
  801cd0:	52                   	push   %edx
  801cd1:	50                   	push   %eax
  801cd2:	6a 1a                	push   $0x1a
  801cd4:	e8 7f fd ff ff       	call   801a58 <syscall>
  801cd9:	83 c4 18             	add    $0x18,%esp
}
  801cdc:	c9                   	leave  
  801cdd:	c3                   	ret    

00801cde <sys_waitSemaphore>:

void
sys_waitSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801cde:	55                   	push   %ebp
  801cdf:	89 e5                	mov    %esp,%ebp
	syscall(SYS_wait_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801ce1:	8b 55 0c             	mov    0xc(%ebp),%edx
  801ce4:	8b 45 08             	mov    0x8(%ebp),%eax
  801ce7:	6a 00                	push   $0x0
  801ce9:	6a 00                	push   $0x0
  801ceb:	6a 00                	push   $0x0
  801ced:	52                   	push   %edx
  801cee:	50                   	push   %eax
  801cef:	6a 18                	push   $0x18
  801cf1:	e8 62 fd ff ff       	call   801a58 <syscall>
  801cf6:	83 c4 18             	add    $0x18,%esp
}
  801cf9:	90                   	nop
  801cfa:	c9                   	leave  
  801cfb:	c3                   	ret    

00801cfc <sys_signalSemaphore>:

void
sys_signalSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801cfc:	55                   	push   %ebp
  801cfd:	89 e5                	mov    %esp,%ebp
	syscall(SYS_signal_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801cff:	8b 55 0c             	mov    0xc(%ebp),%edx
  801d02:	8b 45 08             	mov    0x8(%ebp),%eax
  801d05:	6a 00                	push   $0x0
  801d07:	6a 00                	push   $0x0
  801d09:	6a 00                	push   $0x0
  801d0b:	52                   	push   %edx
  801d0c:	50                   	push   %eax
  801d0d:	6a 19                	push   $0x19
  801d0f:	e8 44 fd ff ff       	call   801a58 <syscall>
  801d14:	83 c4 18             	add    $0x18,%esp
}
  801d17:	90                   	nop
  801d18:	c9                   	leave  
  801d19:	c3                   	ret    

00801d1a <sys_createSharedObject>:

int
sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  801d1a:	55                   	push   %ebp
  801d1b:	89 e5                	mov    %esp,%ebp
  801d1d:	83 ec 04             	sub    $0x4,%esp
  801d20:	8b 45 10             	mov    0x10(%ebp),%eax
  801d23:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  801d26:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801d29:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801d2d:	8b 45 08             	mov    0x8(%ebp),%eax
  801d30:	6a 00                	push   $0x0
  801d32:	51                   	push   %ecx
  801d33:	52                   	push   %edx
  801d34:	ff 75 0c             	pushl  0xc(%ebp)
  801d37:	50                   	push   %eax
  801d38:	6a 1b                	push   $0x1b
  801d3a:	e8 19 fd ff ff       	call   801a58 <syscall>
  801d3f:	83 c4 18             	add    $0x18,%esp
}
  801d42:	c9                   	leave  
  801d43:	c3                   	ret    

00801d44 <sys_getSizeOfSharedObject>:

//2017:
int
sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  801d44:	55                   	push   %ebp
  801d45:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  801d47:	8b 55 0c             	mov    0xc(%ebp),%edx
  801d4a:	8b 45 08             	mov    0x8(%ebp),%eax
  801d4d:	6a 00                	push   $0x0
  801d4f:	6a 00                	push   $0x0
  801d51:	6a 00                	push   $0x0
  801d53:	52                   	push   %edx
  801d54:	50                   	push   %eax
  801d55:	6a 1c                	push   $0x1c
  801d57:	e8 fc fc ff ff       	call   801a58 <syscall>
  801d5c:	83 c4 18             	add    $0x18,%esp
}
  801d5f:	c9                   	leave  
  801d60:	c3                   	ret    

00801d61 <sys_getSharedObject>:
//==========

int
sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  801d61:	55                   	push   %ebp
  801d62:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  801d64:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801d67:	8b 55 0c             	mov    0xc(%ebp),%edx
  801d6a:	8b 45 08             	mov    0x8(%ebp),%eax
  801d6d:	6a 00                	push   $0x0
  801d6f:	6a 00                	push   $0x0
  801d71:	51                   	push   %ecx
  801d72:	52                   	push   %edx
  801d73:	50                   	push   %eax
  801d74:	6a 1d                	push   $0x1d
  801d76:	e8 dd fc ff ff       	call   801a58 <syscall>
  801d7b:	83 c4 18             	add    $0x18,%esp
}
  801d7e:	c9                   	leave  
  801d7f:	c3                   	ret    

00801d80 <sys_freeSharedObject>:

int
sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  801d80:	55                   	push   %ebp
  801d81:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  801d83:	8b 55 0c             	mov    0xc(%ebp),%edx
  801d86:	8b 45 08             	mov    0x8(%ebp),%eax
  801d89:	6a 00                	push   $0x0
  801d8b:	6a 00                	push   $0x0
  801d8d:	6a 00                	push   $0x0
  801d8f:	52                   	push   %edx
  801d90:	50                   	push   %eax
  801d91:	6a 1e                	push   $0x1e
  801d93:	e8 c0 fc ff ff       	call   801a58 <syscall>
  801d98:	83 c4 18             	add    $0x18,%esp
}
  801d9b:	c9                   	leave  
  801d9c:	c3                   	ret    

00801d9d <sys_getMaxShares>:

uint32 	sys_getMaxShares()
{
  801d9d:	55                   	push   %ebp
  801d9e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_max_shares,0, 0, 0, 0, 0);
  801da0:	6a 00                	push   $0x0
  801da2:	6a 00                	push   $0x0
  801da4:	6a 00                	push   $0x0
  801da6:	6a 00                	push   $0x0
  801da8:	6a 00                	push   $0x0
  801daa:	6a 1f                	push   $0x1f
  801dac:	e8 a7 fc ff ff       	call   801a58 <syscall>
  801db1:	83 c4 18             	add    $0x18,%esp
}
  801db4:	c9                   	leave  
  801db5:	c3                   	ret    

00801db6 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  801db6:	55                   	push   %ebp
  801db7:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  801db9:	8b 45 08             	mov    0x8(%ebp),%eax
  801dbc:	6a 00                	push   $0x0
  801dbe:	ff 75 14             	pushl  0x14(%ebp)
  801dc1:	ff 75 10             	pushl  0x10(%ebp)
  801dc4:	ff 75 0c             	pushl  0xc(%ebp)
  801dc7:	50                   	push   %eax
  801dc8:	6a 20                	push   $0x20
  801dca:	e8 89 fc ff ff       	call   801a58 <syscall>
  801dcf:	83 c4 18             	add    $0x18,%esp
}
  801dd2:	c9                   	leave  
  801dd3:	c3                   	ret    

00801dd4 <sys_run_env>:

void
sys_run_env(int32 envId)
{
  801dd4:	55                   	push   %ebp
  801dd5:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  801dd7:	8b 45 08             	mov    0x8(%ebp),%eax
  801dda:	6a 00                	push   $0x0
  801ddc:	6a 00                	push   $0x0
  801dde:	6a 00                	push   $0x0
  801de0:	6a 00                	push   $0x0
  801de2:	50                   	push   %eax
  801de3:	6a 21                	push   $0x21
  801de5:	e8 6e fc ff ff       	call   801a58 <syscall>
  801dea:	83 c4 18             	add    $0x18,%esp
}
  801ded:	90                   	nop
  801dee:	c9                   	leave  
  801def:	c3                   	ret    

00801df0 <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  801df0:	55                   	push   %ebp
  801df1:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  801df3:	8b 45 08             	mov    0x8(%ebp),%eax
  801df6:	6a 00                	push   $0x0
  801df8:	6a 00                	push   $0x0
  801dfa:	6a 00                	push   $0x0
  801dfc:	6a 00                	push   $0x0
  801dfe:	50                   	push   %eax
  801dff:	6a 22                	push   $0x22
  801e01:	e8 52 fc ff ff       	call   801a58 <syscall>
  801e06:	83 c4 18             	add    $0x18,%esp
}
  801e09:	c9                   	leave  
  801e0a:	c3                   	ret    

00801e0b <sys_getenvid>:

int32 sys_getenvid(void)
{
  801e0b:	55                   	push   %ebp
  801e0c:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  801e0e:	6a 00                	push   $0x0
  801e10:	6a 00                	push   $0x0
  801e12:	6a 00                	push   $0x0
  801e14:	6a 00                	push   $0x0
  801e16:	6a 00                	push   $0x0
  801e18:	6a 02                	push   $0x2
  801e1a:	e8 39 fc ff ff       	call   801a58 <syscall>
  801e1f:	83 c4 18             	add    $0x18,%esp
}
  801e22:	c9                   	leave  
  801e23:	c3                   	ret    

00801e24 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  801e24:	55                   	push   %ebp
  801e25:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  801e27:	6a 00                	push   $0x0
  801e29:	6a 00                	push   $0x0
  801e2b:	6a 00                	push   $0x0
  801e2d:	6a 00                	push   $0x0
  801e2f:	6a 00                	push   $0x0
  801e31:	6a 03                	push   $0x3
  801e33:	e8 20 fc ff ff       	call   801a58 <syscall>
  801e38:	83 c4 18             	add    $0x18,%esp
}
  801e3b:	c9                   	leave  
  801e3c:	c3                   	ret    

00801e3d <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  801e3d:	55                   	push   %ebp
  801e3e:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  801e40:	6a 00                	push   $0x0
  801e42:	6a 00                	push   $0x0
  801e44:	6a 00                	push   $0x0
  801e46:	6a 00                	push   $0x0
  801e48:	6a 00                	push   $0x0
  801e4a:	6a 04                	push   $0x4
  801e4c:	e8 07 fc ff ff       	call   801a58 <syscall>
  801e51:	83 c4 18             	add    $0x18,%esp
}
  801e54:	c9                   	leave  
  801e55:	c3                   	ret    

00801e56 <sys_exit_env>:


void sys_exit_env(void)
{
  801e56:	55                   	push   %ebp
  801e57:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  801e59:	6a 00                	push   $0x0
  801e5b:	6a 00                	push   $0x0
  801e5d:	6a 00                	push   $0x0
  801e5f:	6a 00                	push   $0x0
  801e61:	6a 00                	push   $0x0
  801e63:	6a 23                	push   $0x23
  801e65:	e8 ee fb ff ff       	call   801a58 <syscall>
  801e6a:	83 c4 18             	add    $0x18,%esp
}
  801e6d:	90                   	nop
  801e6e:	c9                   	leave  
  801e6f:	c3                   	ret    

00801e70 <sys_get_virtual_time>:


struct uint64
sys_get_virtual_time()
{
  801e70:	55                   	push   %ebp
  801e71:	89 e5                	mov    %esp,%ebp
  801e73:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  801e76:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801e79:	8d 50 04             	lea    0x4(%eax),%edx
  801e7c:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801e7f:	6a 00                	push   $0x0
  801e81:	6a 00                	push   $0x0
  801e83:	6a 00                	push   $0x0
  801e85:	52                   	push   %edx
  801e86:	50                   	push   %eax
  801e87:	6a 24                	push   $0x24
  801e89:	e8 ca fb ff ff       	call   801a58 <syscall>
  801e8e:	83 c4 18             	add    $0x18,%esp
	return result;
  801e91:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801e94:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801e97:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801e9a:	89 01                	mov    %eax,(%ecx)
  801e9c:	89 51 04             	mov    %edx,0x4(%ecx)
}
  801e9f:	8b 45 08             	mov    0x8(%ebp),%eax
  801ea2:	c9                   	leave  
  801ea3:	c2 04 00             	ret    $0x4

00801ea6 <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  801ea6:	55                   	push   %ebp
  801ea7:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  801ea9:	6a 00                	push   $0x0
  801eab:	6a 00                	push   $0x0
  801ead:	ff 75 10             	pushl  0x10(%ebp)
  801eb0:	ff 75 0c             	pushl  0xc(%ebp)
  801eb3:	ff 75 08             	pushl  0x8(%ebp)
  801eb6:	6a 12                	push   $0x12
  801eb8:	e8 9b fb ff ff       	call   801a58 <syscall>
  801ebd:	83 c4 18             	add    $0x18,%esp
	return ;
  801ec0:	90                   	nop
}
  801ec1:	c9                   	leave  
  801ec2:	c3                   	ret    

00801ec3 <sys_rcr2>:
uint32 sys_rcr2()
{
  801ec3:	55                   	push   %ebp
  801ec4:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  801ec6:	6a 00                	push   $0x0
  801ec8:	6a 00                	push   $0x0
  801eca:	6a 00                	push   $0x0
  801ecc:	6a 00                	push   $0x0
  801ece:	6a 00                	push   $0x0
  801ed0:	6a 25                	push   $0x25
  801ed2:	e8 81 fb ff ff       	call   801a58 <syscall>
  801ed7:	83 c4 18             	add    $0x18,%esp
}
  801eda:	c9                   	leave  
  801edb:	c3                   	ret    

00801edc <sys_bypassPageFault>:
void sys_bypassPageFault(uint8 instrLength)
{
  801edc:	55                   	push   %ebp
  801edd:	89 e5                	mov    %esp,%ebp
  801edf:	83 ec 04             	sub    $0x4,%esp
  801ee2:	8b 45 08             	mov    0x8(%ebp),%eax
  801ee5:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  801ee8:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  801eec:	6a 00                	push   $0x0
  801eee:	6a 00                	push   $0x0
  801ef0:	6a 00                	push   $0x0
  801ef2:	6a 00                	push   $0x0
  801ef4:	50                   	push   %eax
  801ef5:	6a 26                	push   $0x26
  801ef7:	e8 5c fb ff ff       	call   801a58 <syscall>
  801efc:	83 c4 18             	add    $0x18,%esp
	return ;
  801eff:	90                   	nop
}
  801f00:	c9                   	leave  
  801f01:	c3                   	ret    

00801f02 <rsttst>:
void rsttst()
{
  801f02:	55                   	push   %ebp
  801f03:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  801f05:	6a 00                	push   $0x0
  801f07:	6a 00                	push   $0x0
  801f09:	6a 00                	push   $0x0
  801f0b:	6a 00                	push   $0x0
  801f0d:	6a 00                	push   $0x0
  801f0f:	6a 28                	push   $0x28
  801f11:	e8 42 fb ff ff       	call   801a58 <syscall>
  801f16:	83 c4 18             	add    $0x18,%esp
	return ;
  801f19:	90                   	nop
}
  801f1a:	c9                   	leave  
  801f1b:	c3                   	ret    

00801f1c <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  801f1c:	55                   	push   %ebp
  801f1d:	89 e5                	mov    %esp,%ebp
  801f1f:	83 ec 04             	sub    $0x4,%esp
  801f22:	8b 45 14             	mov    0x14(%ebp),%eax
  801f25:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  801f28:	8b 55 18             	mov    0x18(%ebp),%edx
  801f2b:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801f2f:	52                   	push   %edx
  801f30:	50                   	push   %eax
  801f31:	ff 75 10             	pushl  0x10(%ebp)
  801f34:	ff 75 0c             	pushl  0xc(%ebp)
  801f37:	ff 75 08             	pushl  0x8(%ebp)
  801f3a:	6a 27                	push   $0x27
  801f3c:	e8 17 fb ff ff       	call   801a58 <syscall>
  801f41:	83 c4 18             	add    $0x18,%esp
	return ;
  801f44:	90                   	nop
}
  801f45:	c9                   	leave  
  801f46:	c3                   	ret    

00801f47 <chktst>:
void chktst(uint32 n)
{
  801f47:	55                   	push   %ebp
  801f48:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  801f4a:	6a 00                	push   $0x0
  801f4c:	6a 00                	push   $0x0
  801f4e:	6a 00                	push   $0x0
  801f50:	6a 00                	push   $0x0
  801f52:	ff 75 08             	pushl  0x8(%ebp)
  801f55:	6a 29                	push   $0x29
  801f57:	e8 fc fa ff ff       	call   801a58 <syscall>
  801f5c:	83 c4 18             	add    $0x18,%esp
	return ;
  801f5f:	90                   	nop
}
  801f60:	c9                   	leave  
  801f61:	c3                   	ret    

00801f62 <inctst>:

void inctst()
{
  801f62:	55                   	push   %ebp
  801f63:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  801f65:	6a 00                	push   $0x0
  801f67:	6a 00                	push   $0x0
  801f69:	6a 00                	push   $0x0
  801f6b:	6a 00                	push   $0x0
  801f6d:	6a 00                	push   $0x0
  801f6f:	6a 2a                	push   $0x2a
  801f71:	e8 e2 fa ff ff       	call   801a58 <syscall>
  801f76:	83 c4 18             	add    $0x18,%esp
	return ;
  801f79:	90                   	nop
}
  801f7a:	c9                   	leave  
  801f7b:	c3                   	ret    

00801f7c <gettst>:
uint32 gettst()
{
  801f7c:	55                   	push   %ebp
  801f7d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  801f7f:	6a 00                	push   $0x0
  801f81:	6a 00                	push   $0x0
  801f83:	6a 00                	push   $0x0
  801f85:	6a 00                	push   $0x0
  801f87:	6a 00                	push   $0x0
  801f89:	6a 2b                	push   $0x2b
  801f8b:	e8 c8 fa ff ff       	call   801a58 <syscall>
  801f90:	83 c4 18             	add    $0x18,%esp
}
  801f93:	c9                   	leave  
  801f94:	c3                   	ret    

00801f95 <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  801f95:	55                   	push   %ebp
  801f96:	89 e5                	mov    %esp,%ebp
  801f98:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801f9b:	6a 00                	push   $0x0
  801f9d:	6a 00                	push   $0x0
  801f9f:	6a 00                	push   $0x0
  801fa1:	6a 00                	push   $0x0
  801fa3:	6a 00                	push   $0x0
  801fa5:	6a 2c                	push   $0x2c
  801fa7:	e8 ac fa ff ff       	call   801a58 <syscall>
  801fac:	83 c4 18             	add    $0x18,%esp
  801faf:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  801fb2:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  801fb6:	75 07                	jne    801fbf <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  801fb8:	b8 01 00 00 00       	mov    $0x1,%eax
  801fbd:	eb 05                	jmp    801fc4 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  801fbf:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801fc4:	c9                   	leave  
  801fc5:	c3                   	ret    

00801fc6 <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  801fc6:	55                   	push   %ebp
  801fc7:	89 e5                	mov    %esp,%ebp
  801fc9:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801fcc:	6a 00                	push   $0x0
  801fce:	6a 00                	push   $0x0
  801fd0:	6a 00                	push   $0x0
  801fd2:	6a 00                	push   $0x0
  801fd4:	6a 00                	push   $0x0
  801fd6:	6a 2c                	push   $0x2c
  801fd8:	e8 7b fa ff ff       	call   801a58 <syscall>
  801fdd:	83 c4 18             	add    $0x18,%esp
  801fe0:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  801fe3:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  801fe7:	75 07                	jne    801ff0 <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  801fe9:	b8 01 00 00 00       	mov    $0x1,%eax
  801fee:	eb 05                	jmp    801ff5 <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  801ff0:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801ff5:	c9                   	leave  
  801ff6:	c3                   	ret    

00801ff7 <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  801ff7:	55                   	push   %ebp
  801ff8:	89 e5                	mov    %esp,%ebp
  801ffa:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801ffd:	6a 00                	push   $0x0
  801fff:	6a 00                	push   $0x0
  802001:	6a 00                	push   $0x0
  802003:	6a 00                	push   $0x0
  802005:	6a 00                	push   $0x0
  802007:	6a 2c                	push   $0x2c
  802009:	e8 4a fa ff ff       	call   801a58 <syscall>
  80200e:	83 c4 18             	add    $0x18,%esp
  802011:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  802014:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  802018:	75 07                	jne    802021 <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  80201a:	b8 01 00 00 00       	mov    $0x1,%eax
  80201f:	eb 05                	jmp    802026 <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  802021:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802026:	c9                   	leave  
  802027:	c3                   	ret    

00802028 <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  802028:	55                   	push   %ebp
  802029:	89 e5                	mov    %esp,%ebp
  80202b:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  80202e:	6a 00                	push   $0x0
  802030:	6a 00                	push   $0x0
  802032:	6a 00                	push   $0x0
  802034:	6a 00                	push   $0x0
  802036:	6a 00                	push   $0x0
  802038:	6a 2c                	push   $0x2c
  80203a:	e8 19 fa ff ff       	call   801a58 <syscall>
  80203f:	83 c4 18             	add    $0x18,%esp
  802042:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  802045:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  802049:	75 07                	jne    802052 <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  80204b:	b8 01 00 00 00       	mov    $0x1,%eax
  802050:	eb 05                	jmp    802057 <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  802052:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802057:	c9                   	leave  
  802058:	c3                   	ret    

00802059 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  802059:	55                   	push   %ebp
  80205a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  80205c:	6a 00                	push   $0x0
  80205e:	6a 00                	push   $0x0
  802060:	6a 00                	push   $0x0
  802062:	6a 00                	push   $0x0
  802064:	ff 75 08             	pushl  0x8(%ebp)
  802067:	6a 2d                	push   $0x2d
  802069:	e8 ea f9 ff ff       	call   801a58 <syscall>
  80206e:	83 c4 18             	add    $0x18,%esp
	return ;
  802071:	90                   	nop
}
  802072:	c9                   	leave  
  802073:	c3                   	ret    

00802074 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  802074:	55                   	push   %ebp
  802075:	89 e5                	mov    %esp,%ebp
  802077:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  802078:	8b 5d 14             	mov    0x14(%ebp),%ebx
  80207b:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80207e:	8b 55 0c             	mov    0xc(%ebp),%edx
  802081:	8b 45 08             	mov    0x8(%ebp),%eax
  802084:	6a 00                	push   $0x0
  802086:	53                   	push   %ebx
  802087:	51                   	push   %ecx
  802088:	52                   	push   %edx
  802089:	50                   	push   %eax
  80208a:	6a 2e                	push   $0x2e
  80208c:	e8 c7 f9 ff ff       	call   801a58 <syscall>
  802091:	83 c4 18             	add    $0x18,%esp
}
  802094:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802097:	c9                   	leave  
  802098:	c3                   	ret    

00802099 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  802099:	55                   	push   %ebp
  80209a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  80209c:	8b 55 0c             	mov    0xc(%ebp),%edx
  80209f:	8b 45 08             	mov    0x8(%ebp),%eax
  8020a2:	6a 00                	push   $0x0
  8020a4:	6a 00                	push   $0x0
  8020a6:	6a 00                	push   $0x0
  8020a8:	52                   	push   %edx
  8020a9:	50                   	push   %eax
  8020aa:	6a 2f                	push   $0x2f
  8020ac:	e8 a7 f9 ff ff       	call   801a58 <syscall>
  8020b1:	83 c4 18             	add    $0x18,%esp
}
  8020b4:	c9                   	leave  
  8020b5:	c3                   	ret    

008020b6 <print_mem_block_lists>:
//===========================
// PRINT MEM BLOCK LISTS:
//===========================

void print_mem_block_lists()
{
  8020b6:	55                   	push   %ebp
  8020b7:	89 e5                	mov    %esp,%ebp
  8020b9:	83 ec 18             	sub    $0x18,%esp
	cprintf("\n=========================================\n");
  8020bc:	83 ec 0c             	sub    $0xc,%esp
  8020bf:	68 40 3a 80 00       	push   $0x803a40
  8020c4:	e8 dd e6 ff ff       	call   8007a6 <cprintf>
  8020c9:	83 c4 10             	add    $0x10,%esp
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
  8020cc:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nFreeMemBlocksList:\n");
  8020d3:	83 ec 0c             	sub    $0xc,%esp
  8020d6:	68 6c 3a 80 00       	push   $0x803a6c
  8020db:	e8 c6 e6 ff ff       	call   8007a6 <cprintf>
  8020e0:	83 c4 10             	add    $0x10,%esp
	uint8 sorted = 1 ;
  8020e3:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &FreeMemBlocksList)
  8020e7:	a1 38 41 80 00       	mov    0x804138,%eax
  8020ec:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8020ef:	eb 56                	jmp    802147 <print_mem_block_lists+0x91>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  8020f1:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8020f5:	74 1c                	je     802113 <print_mem_block_lists+0x5d>
  8020f7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020fa:	8b 50 08             	mov    0x8(%eax),%edx
  8020fd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802100:	8b 48 08             	mov    0x8(%eax),%ecx
  802103:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802106:	8b 40 0c             	mov    0xc(%eax),%eax
  802109:	01 c8                	add    %ecx,%eax
  80210b:	39 c2                	cmp    %eax,%edx
  80210d:	73 04                	jae    802113 <print_mem_block_lists+0x5d>
			sorted = 0 ;
  80210f:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  802113:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802116:	8b 50 08             	mov    0x8(%eax),%edx
  802119:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80211c:	8b 40 0c             	mov    0xc(%eax),%eax
  80211f:	01 c2                	add    %eax,%edx
  802121:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802124:	8b 40 08             	mov    0x8(%eax),%eax
  802127:	83 ec 04             	sub    $0x4,%esp
  80212a:	52                   	push   %edx
  80212b:	50                   	push   %eax
  80212c:	68 81 3a 80 00       	push   $0x803a81
  802131:	e8 70 e6 ff ff       	call   8007a6 <cprintf>
  802136:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  802139:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80213c:	89 45 f0             	mov    %eax,-0x10(%ebp)
	cprintf("\n=========================================\n");
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
	cprintf("\nFreeMemBlocksList:\n");
	uint8 sorted = 1 ;
	LIST_FOREACH(blk, &FreeMemBlocksList)
  80213f:	a1 40 41 80 00       	mov    0x804140,%eax
  802144:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802147:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80214b:	74 07                	je     802154 <print_mem_block_lists+0x9e>
  80214d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802150:	8b 00                	mov    (%eax),%eax
  802152:	eb 05                	jmp    802159 <print_mem_block_lists+0xa3>
  802154:	b8 00 00 00 00       	mov    $0x0,%eax
  802159:	a3 40 41 80 00       	mov    %eax,0x804140
  80215e:	a1 40 41 80 00       	mov    0x804140,%eax
  802163:	85 c0                	test   %eax,%eax
  802165:	75 8a                	jne    8020f1 <print_mem_block_lists+0x3b>
  802167:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80216b:	75 84                	jne    8020f1 <print_mem_block_lists+0x3b>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;
  80216d:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  802171:	75 10                	jne    802183 <print_mem_block_lists+0xcd>
  802173:	83 ec 0c             	sub    $0xc,%esp
  802176:	68 90 3a 80 00       	push   $0x803a90
  80217b:	e8 26 e6 ff ff       	call   8007a6 <cprintf>
  802180:	83 c4 10             	add    $0x10,%esp

	lastBlk = NULL ;
  802183:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nAllocMemBlocksList:\n");
  80218a:	83 ec 0c             	sub    $0xc,%esp
  80218d:	68 b4 3a 80 00       	push   $0x803ab4
  802192:	e8 0f e6 ff ff       	call   8007a6 <cprintf>
  802197:	83 c4 10             	add    $0x10,%esp
	sorted = 1 ;
  80219a:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &AllocMemBlocksList)
  80219e:	a1 40 40 80 00       	mov    0x804040,%eax
  8021a3:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8021a6:	eb 56                	jmp    8021fe <print_mem_block_lists+0x148>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  8021a8:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8021ac:	74 1c                	je     8021ca <print_mem_block_lists+0x114>
  8021ae:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021b1:	8b 50 08             	mov    0x8(%eax),%edx
  8021b4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8021b7:	8b 48 08             	mov    0x8(%eax),%ecx
  8021ba:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8021bd:	8b 40 0c             	mov    0xc(%eax),%eax
  8021c0:	01 c8                	add    %ecx,%eax
  8021c2:	39 c2                	cmp    %eax,%edx
  8021c4:	73 04                	jae    8021ca <print_mem_block_lists+0x114>
			sorted = 0 ;
  8021c6:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  8021ca:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021cd:	8b 50 08             	mov    0x8(%eax),%edx
  8021d0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021d3:	8b 40 0c             	mov    0xc(%eax),%eax
  8021d6:	01 c2                	add    %eax,%edx
  8021d8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021db:	8b 40 08             	mov    0x8(%eax),%eax
  8021de:	83 ec 04             	sub    $0x4,%esp
  8021e1:	52                   	push   %edx
  8021e2:	50                   	push   %eax
  8021e3:	68 81 3a 80 00       	push   $0x803a81
  8021e8:	e8 b9 e5 ff ff       	call   8007a6 <cprintf>
  8021ed:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  8021f0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021f3:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;

	lastBlk = NULL ;
	cprintf("\nAllocMemBlocksList:\n");
	sorted = 1 ;
	LIST_FOREACH(blk, &AllocMemBlocksList)
  8021f6:	a1 48 40 80 00       	mov    0x804048,%eax
  8021fb:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8021fe:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802202:	74 07                	je     80220b <print_mem_block_lists+0x155>
  802204:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802207:	8b 00                	mov    (%eax),%eax
  802209:	eb 05                	jmp    802210 <print_mem_block_lists+0x15a>
  80220b:	b8 00 00 00 00       	mov    $0x0,%eax
  802210:	a3 48 40 80 00       	mov    %eax,0x804048
  802215:	a1 48 40 80 00       	mov    0x804048,%eax
  80221a:	85 c0                	test   %eax,%eax
  80221c:	75 8a                	jne    8021a8 <print_mem_block_lists+0xf2>
  80221e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802222:	75 84                	jne    8021a8 <print_mem_block_lists+0xf2>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nAllocMemBlocksList is NOT SORTED!!\n") ;
  802224:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  802228:	75 10                	jne    80223a <print_mem_block_lists+0x184>
  80222a:	83 ec 0c             	sub    $0xc,%esp
  80222d:	68 cc 3a 80 00       	push   $0x803acc
  802232:	e8 6f e5 ff ff       	call   8007a6 <cprintf>
  802237:	83 c4 10             	add    $0x10,%esp
	cprintf("\n=========================================\n");
  80223a:	83 ec 0c             	sub    $0xc,%esp
  80223d:	68 40 3a 80 00       	push   $0x803a40
  802242:	e8 5f e5 ff ff       	call   8007a6 <cprintf>
  802247:	83 c4 10             	add    $0x10,%esp

}
  80224a:	90                   	nop
  80224b:	c9                   	leave  
  80224c:	c3                   	ret    

0080224d <initialize_MemBlocksList>:

//===============================
// [1] INITIALIZE AVAILABLE LIST:
//===============================
void initialize_MemBlocksList(uint32 numOfBlocks)
{
  80224d:	55                   	push   %ebp
  80224e:	89 e5                	mov    %esp,%ebp
  802250:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] initialize_MemBlocksList
	// Write your code here, remove the panic and write your code
	//panic("initialize_MemBlocksList() is not implemented yet...!!");
	uint32 n = numOfBlocks;
  802253:	8b 45 08             	mov    0x8(%ebp),%eax
  802256:	89 45 f0             	mov    %eax,-0x10(%ebp)

	LIST_INIT(&AvailableMemBlocksList);
  802259:	c7 05 48 41 80 00 00 	movl   $0x0,0x804148
  802260:	00 00 00 
  802263:	c7 05 4c 41 80 00 00 	movl   $0x0,0x80414c
  80226a:	00 00 00 
  80226d:	c7 05 54 41 80 00 00 	movl   $0x0,0x804154
  802274:	00 00 00 
	for(int i = 0; i<n;i++)
  802277:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  80227e:	e9 9e 00 00 00       	jmp    802321 <initialize_MemBlocksList+0xd4>
	{
		LIST_INSERT_HEAD(&AvailableMemBlocksList, &(MemBlockNodes[i]));
  802283:	a1 50 40 80 00       	mov    0x804050,%eax
  802288:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80228b:	c1 e2 04             	shl    $0x4,%edx
  80228e:	01 d0                	add    %edx,%eax
  802290:	85 c0                	test   %eax,%eax
  802292:	75 14                	jne    8022a8 <initialize_MemBlocksList+0x5b>
  802294:	83 ec 04             	sub    $0x4,%esp
  802297:	68 f4 3a 80 00       	push   $0x803af4
  80229c:	6a 47                	push   $0x47
  80229e:	68 17 3b 80 00       	push   $0x803b17
  8022a3:	e8 4a e2 ff ff       	call   8004f2 <_panic>
  8022a8:	a1 50 40 80 00       	mov    0x804050,%eax
  8022ad:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8022b0:	c1 e2 04             	shl    $0x4,%edx
  8022b3:	01 d0                	add    %edx,%eax
  8022b5:	8b 15 48 41 80 00    	mov    0x804148,%edx
  8022bb:	89 10                	mov    %edx,(%eax)
  8022bd:	8b 00                	mov    (%eax),%eax
  8022bf:	85 c0                	test   %eax,%eax
  8022c1:	74 18                	je     8022db <initialize_MemBlocksList+0x8e>
  8022c3:	a1 48 41 80 00       	mov    0x804148,%eax
  8022c8:	8b 15 50 40 80 00    	mov    0x804050,%edx
  8022ce:	8b 4d f4             	mov    -0xc(%ebp),%ecx
  8022d1:	c1 e1 04             	shl    $0x4,%ecx
  8022d4:	01 ca                	add    %ecx,%edx
  8022d6:	89 50 04             	mov    %edx,0x4(%eax)
  8022d9:	eb 12                	jmp    8022ed <initialize_MemBlocksList+0xa0>
  8022db:	a1 50 40 80 00       	mov    0x804050,%eax
  8022e0:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8022e3:	c1 e2 04             	shl    $0x4,%edx
  8022e6:	01 d0                	add    %edx,%eax
  8022e8:	a3 4c 41 80 00       	mov    %eax,0x80414c
  8022ed:	a1 50 40 80 00       	mov    0x804050,%eax
  8022f2:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8022f5:	c1 e2 04             	shl    $0x4,%edx
  8022f8:	01 d0                	add    %edx,%eax
  8022fa:	a3 48 41 80 00       	mov    %eax,0x804148
  8022ff:	a1 50 40 80 00       	mov    0x804050,%eax
  802304:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802307:	c1 e2 04             	shl    $0x4,%edx
  80230a:	01 d0                	add    %edx,%eax
  80230c:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802313:	a1 54 41 80 00       	mov    0x804154,%eax
  802318:	40                   	inc    %eax
  802319:	a3 54 41 80 00       	mov    %eax,0x804154
	// Write your code here, remove the panic and write your code
	//panic("initialize_MemBlocksList() is not implemented yet...!!");
	uint32 n = numOfBlocks;

	LIST_INIT(&AvailableMemBlocksList);
	for(int i = 0; i<n;i++)
  80231e:	ff 45 f4             	incl   -0xc(%ebp)
  802321:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802324:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  802327:	0f 82 56 ff ff ff    	jb     802283 <initialize_MemBlocksList+0x36>
	{
		LIST_INSERT_HEAD(&AvailableMemBlocksList, &(MemBlockNodes[i]));
	}
}
  80232d:	90                   	nop
  80232e:	c9                   	leave  
  80232f:	c3                   	ret    

00802330 <find_block>:

//===============================
// [2] FIND BLOCK:
//===============================
struct MemBlock *find_block(struct MemBlock_List *blockList, uint32 va)
{
  802330:	55                   	push   %ebp
  802331:	89 e5                	mov    %esp,%ebp
  802333:	83 ec 10             	sub    $0x10,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] find_block
	// Write your code here, remove the panic and write your code
	//panic("find_block() is not implemented yet...!!");
	uint32 virAddress = va;
  802336:	8b 45 0c             	mov    0xc(%ebp),%eax
  802339:	89 45 f4             	mov    %eax,-0xc(%ebp)
	struct MemBlock* blk;
	int found = 0;
  80233c:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	LIST_FOREACH(blk, &(AllocMemBlocksList))
  802343:	a1 40 40 80 00       	mov    0x804040,%eax
  802348:	89 45 fc             	mov    %eax,-0x4(%ebp)
  80234b:	eb 23                	jmp    802370 <find_block+0x40>
	{
		if(blk->sva == virAddress)
  80234d:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802350:	8b 40 08             	mov    0x8(%eax),%eax
  802353:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  802356:	75 09                	jne    802361 <find_block+0x31>
		{
			found = 1;
  802358:	c7 45 f8 01 00 00 00 	movl   $0x1,-0x8(%ebp)
			break;
  80235f:	eb 35                	jmp    802396 <find_block+0x66>
		}
		else
		{
			found = 0;
  802361:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	//panic("find_block() is not implemented yet...!!");
	uint32 virAddress = va;
	struct MemBlock* blk;
	int found = 0;

	LIST_FOREACH(blk, &(AllocMemBlocksList))
  802368:	a1 48 40 80 00       	mov    0x804048,%eax
  80236d:	89 45 fc             	mov    %eax,-0x4(%ebp)
  802370:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  802374:	74 07                	je     80237d <find_block+0x4d>
  802376:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802379:	8b 00                	mov    (%eax),%eax
  80237b:	eb 05                	jmp    802382 <find_block+0x52>
  80237d:	b8 00 00 00 00       	mov    $0x0,%eax
  802382:	a3 48 40 80 00       	mov    %eax,0x804048
  802387:	a1 48 40 80 00       	mov    0x804048,%eax
  80238c:	85 c0                	test   %eax,%eax
  80238e:	75 bd                	jne    80234d <find_block+0x1d>
  802390:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  802394:	75 b7                	jne    80234d <find_block+0x1d>
		{
			found = 0;
			continue;
		}
	}
	if(found == 1)
  802396:	83 7d f8 01          	cmpl   $0x1,-0x8(%ebp)
  80239a:	75 05                	jne    8023a1 <find_block+0x71>
	{
		return blk;
  80239c:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80239f:	eb 05                	jmp    8023a6 <find_block+0x76>
	}
	else
	{
		return NULL;
  8023a1:	b8 00 00 00 00       	mov    $0x0,%eax
	}
}
  8023a6:	c9                   	leave  
  8023a7:	c3                   	ret    

008023a8 <insert_sorted_allocList>:

//=========================================
// [3] INSERT BLOCK IN ALLOC LIST [SORTED]:
//=========================================
void insert_sorted_allocList(struct MemBlock *blockToInsert)
{
  8023a8:	55                   	push   %ebp
  8023a9:	89 e5                	mov    %esp,%ebp
  8023ab:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] insert_sorted_allocList
	// Write your code here, remove the panic and write your code
	//panic("insert_sorted_allocList() is not implemented yet...!!");
	struct MemBlock* blk;
	struct MemBlock* newblk = blockToInsert;
  8023ae:	8b 45 08             	mov    0x8(%ebp),%eax
  8023b1:	89 45 f0             	mov    %eax,-0x10(%ebp)

	if((LIST_EMPTY(&AllocMemBlocksList)) || (newblk->sva < LIST_FIRST(&AllocMemBlocksList)->sva))
  8023b4:	a1 40 40 80 00       	mov    0x804040,%eax
  8023b9:	85 c0                	test   %eax,%eax
  8023bb:	74 12                	je     8023cf <insert_sorted_allocList+0x27>
  8023bd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8023c0:	8b 50 08             	mov    0x8(%eax),%edx
  8023c3:	a1 40 40 80 00       	mov    0x804040,%eax
  8023c8:	8b 40 08             	mov    0x8(%eax),%eax
  8023cb:	39 c2                	cmp    %eax,%edx
  8023cd:	73 65                	jae    802434 <insert_sorted_allocList+0x8c>
	{
		LIST_INSERT_HEAD(&(AllocMemBlocksList), newblk);
  8023cf:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8023d3:	75 14                	jne    8023e9 <insert_sorted_allocList+0x41>
  8023d5:	83 ec 04             	sub    $0x4,%esp
  8023d8:	68 f4 3a 80 00       	push   $0x803af4
  8023dd:	6a 7b                	push   $0x7b
  8023df:	68 17 3b 80 00       	push   $0x803b17
  8023e4:	e8 09 e1 ff ff       	call   8004f2 <_panic>
  8023e9:	8b 15 40 40 80 00    	mov    0x804040,%edx
  8023ef:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8023f2:	89 10                	mov    %edx,(%eax)
  8023f4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8023f7:	8b 00                	mov    (%eax),%eax
  8023f9:	85 c0                	test   %eax,%eax
  8023fb:	74 0d                	je     80240a <insert_sorted_allocList+0x62>
  8023fd:	a1 40 40 80 00       	mov    0x804040,%eax
  802402:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802405:	89 50 04             	mov    %edx,0x4(%eax)
  802408:	eb 08                	jmp    802412 <insert_sorted_allocList+0x6a>
  80240a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80240d:	a3 44 40 80 00       	mov    %eax,0x804044
  802412:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802415:	a3 40 40 80 00       	mov    %eax,0x804040
  80241a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80241d:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802424:	a1 4c 40 80 00       	mov    0x80404c,%eax
  802429:	40                   	inc    %eax
  80242a:	a3 4c 40 80 00       	mov    %eax,0x80404c
  80242f:	e9 5f 01 00 00       	jmp    802593 <insert_sorted_allocList+0x1eb>
	}
	else if(newblk->sva > LIST_LAST(&AllocMemBlocksList)->sva)
  802434:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802437:	8b 50 08             	mov    0x8(%eax),%edx
  80243a:	a1 44 40 80 00       	mov    0x804044,%eax
  80243f:	8b 40 08             	mov    0x8(%eax),%eax
  802442:	39 c2                	cmp    %eax,%edx
  802444:	76 65                	jbe    8024ab <insert_sorted_allocList+0x103>
	{
		LIST_INSERT_TAIL(&AllocMemBlocksList, newblk);
  802446:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80244a:	75 14                	jne    802460 <insert_sorted_allocList+0xb8>
  80244c:	83 ec 04             	sub    $0x4,%esp
  80244f:	68 30 3b 80 00       	push   $0x803b30
  802454:	6a 7f                	push   $0x7f
  802456:	68 17 3b 80 00       	push   $0x803b17
  80245b:	e8 92 e0 ff ff       	call   8004f2 <_panic>
  802460:	8b 15 44 40 80 00    	mov    0x804044,%edx
  802466:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802469:	89 50 04             	mov    %edx,0x4(%eax)
  80246c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80246f:	8b 40 04             	mov    0x4(%eax),%eax
  802472:	85 c0                	test   %eax,%eax
  802474:	74 0c                	je     802482 <insert_sorted_allocList+0xda>
  802476:	a1 44 40 80 00       	mov    0x804044,%eax
  80247b:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80247e:	89 10                	mov    %edx,(%eax)
  802480:	eb 08                	jmp    80248a <insert_sorted_allocList+0xe2>
  802482:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802485:	a3 40 40 80 00       	mov    %eax,0x804040
  80248a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80248d:	a3 44 40 80 00       	mov    %eax,0x804044
  802492:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802495:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80249b:	a1 4c 40 80 00       	mov    0x80404c,%eax
  8024a0:	40                   	inc    %eax
  8024a1:	a3 4c 40 80 00       	mov    %eax,0x80404c
				LIST_INSERT_AFTER(&AllocMemBlocksList, blk, newblk);
				break;
			}
		}
	}
}
  8024a6:	e9 e8 00 00 00       	jmp    802593 <insert_sorted_allocList+0x1eb>
	{
		LIST_INSERT_TAIL(&AllocMemBlocksList, newblk);
	}
	else
	{
		LIST_FOREACH(blk, &AllocMemBlocksList)
  8024ab:	a1 40 40 80 00       	mov    0x804040,%eax
  8024b0:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8024b3:	e9 ab 00 00 00       	jmp    802563 <insert_sorted_allocList+0x1bb>
		{
			if(blk->prev_next_info.le_next != NULL && newblk->sva > blk->sva  && newblk->sva < blk->prev_next_info.le_next->sva)
  8024b8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024bb:	8b 00                	mov    (%eax),%eax
  8024bd:	85 c0                	test   %eax,%eax
  8024bf:	0f 84 96 00 00 00    	je     80255b <insert_sorted_allocList+0x1b3>
  8024c5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8024c8:	8b 50 08             	mov    0x8(%eax),%edx
  8024cb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024ce:	8b 40 08             	mov    0x8(%eax),%eax
  8024d1:	39 c2                	cmp    %eax,%edx
  8024d3:	0f 86 82 00 00 00    	jbe    80255b <insert_sorted_allocList+0x1b3>
  8024d9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8024dc:	8b 50 08             	mov    0x8(%eax),%edx
  8024df:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024e2:	8b 00                	mov    (%eax),%eax
  8024e4:	8b 40 08             	mov    0x8(%eax),%eax
  8024e7:	39 c2                	cmp    %eax,%edx
  8024e9:	73 70                	jae    80255b <insert_sorted_allocList+0x1b3>
			{
				LIST_INSERT_AFTER(&AllocMemBlocksList, blk, newblk);
  8024eb:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8024ef:	74 06                	je     8024f7 <insert_sorted_allocList+0x14f>
  8024f1:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8024f5:	75 17                	jne    80250e <insert_sorted_allocList+0x166>
  8024f7:	83 ec 04             	sub    $0x4,%esp
  8024fa:	68 54 3b 80 00       	push   $0x803b54
  8024ff:	68 87 00 00 00       	push   $0x87
  802504:	68 17 3b 80 00       	push   $0x803b17
  802509:	e8 e4 df ff ff       	call   8004f2 <_panic>
  80250e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802511:	8b 10                	mov    (%eax),%edx
  802513:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802516:	89 10                	mov    %edx,(%eax)
  802518:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80251b:	8b 00                	mov    (%eax),%eax
  80251d:	85 c0                	test   %eax,%eax
  80251f:	74 0b                	je     80252c <insert_sorted_allocList+0x184>
  802521:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802524:	8b 00                	mov    (%eax),%eax
  802526:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802529:	89 50 04             	mov    %edx,0x4(%eax)
  80252c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80252f:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802532:	89 10                	mov    %edx,(%eax)
  802534:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802537:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80253a:	89 50 04             	mov    %edx,0x4(%eax)
  80253d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802540:	8b 00                	mov    (%eax),%eax
  802542:	85 c0                	test   %eax,%eax
  802544:	75 08                	jne    80254e <insert_sorted_allocList+0x1a6>
  802546:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802549:	a3 44 40 80 00       	mov    %eax,0x804044
  80254e:	a1 4c 40 80 00       	mov    0x80404c,%eax
  802553:	40                   	inc    %eax
  802554:	a3 4c 40 80 00       	mov    %eax,0x80404c
				break;
  802559:	eb 38                	jmp    802593 <insert_sorted_allocList+0x1eb>
	{
		LIST_INSERT_TAIL(&AllocMemBlocksList, newblk);
	}
	else
	{
		LIST_FOREACH(blk, &AllocMemBlocksList)
  80255b:	a1 48 40 80 00       	mov    0x804048,%eax
  802560:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802563:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802567:	74 07                	je     802570 <insert_sorted_allocList+0x1c8>
  802569:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80256c:	8b 00                	mov    (%eax),%eax
  80256e:	eb 05                	jmp    802575 <insert_sorted_allocList+0x1cd>
  802570:	b8 00 00 00 00       	mov    $0x0,%eax
  802575:	a3 48 40 80 00       	mov    %eax,0x804048
  80257a:	a1 48 40 80 00       	mov    0x804048,%eax
  80257f:	85 c0                	test   %eax,%eax
  802581:	0f 85 31 ff ff ff    	jne    8024b8 <insert_sorted_allocList+0x110>
  802587:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80258b:	0f 85 27 ff ff ff    	jne    8024b8 <insert_sorted_allocList+0x110>
				LIST_INSERT_AFTER(&AllocMemBlocksList, blk, newblk);
				break;
			}
		}
	}
}
  802591:	eb 00                	jmp    802593 <insert_sorted_allocList+0x1eb>
  802593:	90                   	nop
  802594:	c9                   	leave  
  802595:	c3                   	ret    

00802596 <alloc_block_FF>:

//=========================================
// [4] ALLOCATE BLOCK BY FIRST FIT:
//=========================================
struct MemBlock *alloc_block_FF(uint32 size)
{
  802596:	55                   	push   %ebp
  802597:	89 e5                	mov    %esp,%ebp
  802599:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_FF
	// Write your code here, remove the panic and write your code
	//panic("alloc_block_FF() is not implemented yet...!!");
	uint32 versize = size;
  80259c:	8b 45 08             	mov    0x8(%ebp),%eax
  80259f:	89 45 f0             	mov    %eax,-0x10(%ebp)
	struct MemBlock* blk;
	struct MemBlock* newblk = LIST_FIRST(&AvailableMemBlocksList);
  8025a2:	a1 48 41 80 00       	mov    0x804148,%eax
  8025a7:	89 45 ec             	mov    %eax,-0x14(%ebp)

	LIST_FOREACH(blk,&FreeMemBlocksList)
  8025aa:	a1 38 41 80 00       	mov    0x804138,%eax
  8025af:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8025b2:	e9 77 01 00 00       	jmp    80272e <alloc_block_FF+0x198>
	{
		if(blk->size == versize)
  8025b7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025ba:	8b 40 0c             	mov    0xc(%eax),%eax
  8025bd:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8025c0:	0f 85 8a 00 00 00    	jne    802650 <alloc_block_FF+0xba>
		{
			LIST_REMOVE(&FreeMemBlocksList,blk);
  8025c6:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8025ca:	75 17                	jne    8025e3 <alloc_block_FF+0x4d>
  8025cc:	83 ec 04             	sub    $0x4,%esp
  8025cf:	68 88 3b 80 00       	push   $0x803b88
  8025d4:	68 9e 00 00 00       	push   $0x9e
  8025d9:	68 17 3b 80 00       	push   $0x803b17
  8025de:	e8 0f df ff ff       	call   8004f2 <_panic>
  8025e3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025e6:	8b 00                	mov    (%eax),%eax
  8025e8:	85 c0                	test   %eax,%eax
  8025ea:	74 10                	je     8025fc <alloc_block_FF+0x66>
  8025ec:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025ef:	8b 00                	mov    (%eax),%eax
  8025f1:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8025f4:	8b 52 04             	mov    0x4(%edx),%edx
  8025f7:	89 50 04             	mov    %edx,0x4(%eax)
  8025fa:	eb 0b                	jmp    802607 <alloc_block_FF+0x71>
  8025fc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025ff:	8b 40 04             	mov    0x4(%eax),%eax
  802602:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802607:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80260a:	8b 40 04             	mov    0x4(%eax),%eax
  80260d:	85 c0                	test   %eax,%eax
  80260f:	74 0f                	je     802620 <alloc_block_FF+0x8a>
  802611:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802614:	8b 40 04             	mov    0x4(%eax),%eax
  802617:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80261a:	8b 12                	mov    (%edx),%edx
  80261c:	89 10                	mov    %edx,(%eax)
  80261e:	eb 0a                	jmp    80262a <alloc_block_FF+0x94>
  802620:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802623:	8b 00                	mov    (%eax),%eax
  802625:	a3 38 41 80 00       	mov    %eax,0x804138
  80262a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80262d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802633:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802636:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80263d:	a1 44 41 80 00       	mov    0x804144,%eax
  802642:	48                   	dec    %eax
  802643:	a3 44 41 80 00       	mov    %eax,0x804144
			return blk;
  802648:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80264b:	e9 11 01 00 00       	jmp    802761 <alloc_block_FF+0x1cb>
		}
		else if(blk->size > versize)
  802650:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802653:	8b 40 0c             	mov    0xc(%eax),%eax
  802656:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  802659:	0f 86 c7 00 00 00    	jbe    802726 <alloc_block_FF+0x190>
		{
			LIST_REMOVE(&AvailableMemBlocksList,newblk);
  80265f:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802663:	75 17                	jne    80267c <alloc_block_FF+0xe6>
  802665:	83 ec 04             	sub    $0x4,%esp
  802668:	68 88 3b 80 00       	push   $0x803b88
  80266d:	68 a3 00 00 00       	push   $0xa3
  802672:	68 17 3b 80 00       	push   $0x803b17
  802677:	e8 76 de ff ff       	call   8004f2 <_panic>
  80267c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80267f:	8b 00                	mov    (%eax),%eax
  802681:	85 c0                	test   %eax,%eax
  802683:	74 10                	je     802695 <alloc_block_FF+0xff>
  802685:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802688:	8b 00                	mov    (%eax),%eax
  80268a:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80268d:	8b 52 04             	mov    0x4(%edx),%edx
  802690:	89 50 04             	mov    %edx,0x4(%eax)
  802693:	eb 0b                	jmp    8026a0 <alloc_block_FF+0x10a>
  802695:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802698:	8b 40 04             	mov    0x4(%eax),%eax
  80269b:	a3 4c 41 80 00       	mov    %eax,0x80414c
  8026a0:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8026a3:	8b 40 04             	mov    0x4(%eax),%eax
  8026a6:	85 c0                	test   %eax,%eax
  8026a8:	74 0f                	je     8026b9 <alloc_block_FF+0x123>
  8026aa:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8026ad:	8b 40 04             	mov    0x4(%eax),%eax
  8026b0:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8026b3:	8b 12                	mov    (%edx),%edx
  8026b5:	89 10                	mov    %edx,(%eax)
  8026b7:	eb 0a                	jmp    8026c3 <alloc_block_FF+0x12d>
  8026b9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8026bc:	8b 00                	mov    (%eax),%eax
  8026be:	a3 48 41 80 00       	mov    %eax,0x804148
  8026c3:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8026c6:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8026cc:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8026cf:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8026d6:	a1 54 41 80 00       	mov    0x804154,%eax
  8026db:	48                   	dec    %eax
  8026dc:	a3 54 41 80 00       	mov    %eax,0x804154
			newblk->size = versize;
  8026e1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8026e4:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8026e7:	89 50 0c             	mov    %edx,0xc(%eax)
			blk->size = blk->size-versize;
  8026ea:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026ed:	8b 40 0c             	mov    0xc(%eax),%eax
  8026f0:	2b 45 f0             	sub    -0x10(%ebp),%eax
  8026f3:	89 c2                	mov    %eax,%edx
  8026f5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026f8:	89 50 0c             	mov    %edx,0xc(%eax)
			uint32 newveradd = blk->sva;
  8026fb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026fe:	8b 40 08             	mov    0x8(%eax),%eax
  802701:	89 45 e8             	mov    %eax,-0x18(%ebp)
			blk->sva+=newblk->size;
  802704:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802707:	8b 50 08             	mov    0x8(%eax),%edx
  80270a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80270d:	8b 40 0c             	mov    0xc(%eax),%eax
  802710:	01 c2                	add    %eax,%edx
  802712:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802715:	89 50 08             	mov    %edx,0x8(%eax)
			newblk->sva = newveradd;
  802718:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80271b:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80271e:	89 50 08             	mov    %edx,0x8(%eax)
			return newblk;
  802721:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802724:	eb 3b                	jmp    802761 <alloc_block_FF+0x1cb>
	//panic("alloc_block_FF() is not implemented yet...!!");
	uint32 versize = size;
	struct MemBlock* blk;
	struct MemBlock* newblk = LIST_FIRST(&AvailableMemBlocksList);

	LIST_FOREACH(blk,&FreeMemBlocksList)
  802726:	a1 40 41 80 00       	mov    0x804140,%eax
  80272b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80272e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802732:	74 07                	je     80273b <alloc_block_FF+0x1a5>
  802734:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802737:	8b 00                	mov    (%eax),%eax
  802739:	eb 05                	jmp    802740 <alloc_block_FF+0x1aa>
  80273b:	b8 00 00 00 00       	mov    $0x0,%eax
  802740:	a3 40 41 80 00       	mov    %eax,0x804140
  802745:	a1 40 41 80 00       	mov    0x804140,%eax
  80274a:	85 c0                	test   %eax,%eax
  80274c:	0f 85 65 fe ff ff    	jne    8025b7 <alloc_block_FF+0x21>
  802752:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802756:	0f 85 5b fe ff ff    	jne    8025b7 <alloc_block_FF+0x21>
			blk->sva+=newblk->size;
			newblk->sva = newveradd;
			return newblk;
		}
	}
	return NULL;
  80275c:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802761:	c9                   	leave  
  802762:	c3                   	ret    

00802763 <alloc_block_BF>:

//=========================================
// [5] ALLOCATE BLOCK BY BEST FIT:
//=========================================
struct MemBlock *alloc_block_BF(uint32 size)
{
  802763:	55                   	push   %ebp
  802764:	89 e5                	mov    %esp,%ebp
  802766:	83 ec 28             	sub    $0x28,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_BF
	// Write your code here, remove the panic and write your code
	//panic("alloc_block_BF() is not implemented yet...!!");
	uint32 versize=size;
  802769:	8b 45 08             	mov    0x8(%ebp),%eax
  80276c:	89 45 e8             	mov    %eax,-0x18(%ebp)
	struct MemBlock* blk;
	struct MemBlock* newblk=LIST_FIRST(&AvailableMemBlocksList);
  80276f:	a1 48 41 80 00       	mov    0x804148,%eax
  802774:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	uint32 newveradd;
	uint32 newsize;
	int size_free = LIST_SIZE(&FreeMemBlocksList);
  802777:	a1 44 41 80 00       	mov    0x804144,%eax
  80277c:	89 45 e0             	mov    %eax,-0x20(%ebp)

	LIST_FOREACH(blk, &FreeMemBlocksList)
  80277f:	a1 38 41 80 00       	mov    0x804138,%eax
  802784:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802787:	e9 a1 00 00 00       	jmp    80282d <alloc_block_BF+0xca>
	{
		if(blk->size == versize)
  80278c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80278f:	8b 40 0c             	mov    0xc(%eax),%eax
  802792:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  802795:	0f 85 8a 00 00 00    	jne    802825 <alloc_block_BF+0xc2>
		{
			LIST_REMOVE(&FreeMemBlocksList, blk);
  80279b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80279f:	75 17                	jne    8027b8 <alloc_block_BF+0x55>
  8027a1:	83 ec 04             	sub    $0x4,%esp
  8027a4:	68 88 3b 80 00       	push   $0x803b88
  8027a9:	68 c2 00 00 00       	push   $0xc2
  8027ae:	68 17 3b 80 00       	push   $0x803b17
  8027b3:	e8 3a dd ff ff       	call   8004f2 <_panic>
  8027b8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027bb:	8b 00                	mov    (%eax),%eax
  8027bd:	85 c0                	test   %eax,%eax
  8027bf:	74 10                	je     8027d1 <alloc_block_BF+0x6e>
  8027c1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027c4:	8b 00                	mov    (%eax),%eax
  8027c6:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8027c9:	8b 52 04             	mov    0x4(%edx),%edx
  8027cc:	89 50 04             	mov    %edx,0x4(%eax)
  8027cf:	eb 0b                	jmp    8027dc <alloc_block_BF+0x79>
  8027d1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027d4:	8b 40 04             	mov    0x4(%eax),%eax
  8027d7:	a3 3c 41 80 00       	mov    %eax,0x80413c
  8027dc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027df:	8b 40 04             	mov    0x4(%eax),%eax
  8027e2:	85 c0                	test   %eax,%eax
  8027e4:	74 0f                	je     8027f5 <alloc_block_BF+0x92>
  8027e6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027e9:	8b 40 04             	mov    0x4(%eax),%eax
  8027ec:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8027ef:	8b 12                	mov    (%edx),%edx
  8027f1:	89 10                	mov    %edx,(%eax)
  8027f3:	eb 0a                	jmp    8027ff <alloc_block_BF+0x9c>
  8027f5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027f8:	8b 00                	mov    (%eax),%eax
  8027fa:	a3 38 41 80 00       	mov    %eax,0x804138
  8027ff:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802802:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802808:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80280b:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802812:	a1 44 41 80 00       	mov    0x804144,%eax
  802817:	48                   	dec    %eax
  802818:	a3 44 41 80 00       	mov    %eax,0x804144
			return blk;
  80281d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802820:	e9 11 02 00 00       	jmp    802a36 <alloc_block_BF+0x2d3>
	struct MemBlock* newblk=LIST_FIRST(&AvailableMemBlocksList);
	uint32 newveradd;
	uint32 newsize;
	int size_free = LIST_SIZE(&FreeMemBlocksList);

	LIST_FOREACH(blk, &FreeMemBlocksList)
  802825:	a1 40 41 80 00       	mov    0x804140,%eax
  80282a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80282d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802831:	74 07                	je     80283a <alloc_block_BF+0xd7>
  802833:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802836:	8b 00                	mov    (%eax),%eax
  802838:	eb 05                	jmp    80283f <alloc_block_BF+0xdc>
  80283a:	b8 00 00 00 00       	mov    $0x0,%eax
  80283f:	a3 40 41 80 00       	mov    %eax,0x804140
  802844:	a1 40 41 80 00       	mov    0x804140,%eax
  802849:	85 c0                	test   %eax,%eax
  80284b:	0f 85 3b ff ff ff    	jne    80278c <alloc_block_BF+0x29>
  802851:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802855:	0f 85 31 ff ff ff    	jne    80278c <alloc_block_BF+0x29>
		{
			LIST_REMOVE(&FreeMemBlocksList, blk);
			return blk;
		}
	}
	LIST_FOREACH(blk, &FreeMemBlocksList)
  80285b:	a1 38 41 80 00       	mov    0x804138,%eax
  802860:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802863:	eb 27                	jmp    80288c <alloc_block_BF+0x129>
	{
		if(blk->size > versize)
  802865:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802868:	8b 40 0c             	mov    0xc(%eax),%eax
  80286b:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  80286e:	76 14                	jbe    802884 <alloc_block_BF+0x121>
		{
			newsize = blk->size;
  802870:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802873:	8b 40 0c             	mov    0xc(%eax),%eax
  802876:	89 45 ec             	mov    %eax,-0x14(%ebp)
			newveradd = blk->sva;
  802879:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80287c:	8b 40 08             	mov    0x8(%eax),%eax
  80287f:	89 45 f0             	mov    %eax,-0x10(%ebp)
			break;
  802882:	eb 2e                	jmp    8028b2 <alloc_block_BF+0x14f>
		{
			LIST_REMOVE(&FreeMemBlocksList, blk);
			return blk;
		}
	}
	LIST_FOREACH(blk, &FreeMemBlocksList)
  802884:	a1 40 41 80 00       	mov    0x804140,%eax
  802889:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80288c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802890:	74 07                	je     802899 <alloc_block_BF+0x136>
  802892:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802895:	8b 00                	mov    (%eax),%eax
  802897:	eb 05                	jmp    80289e <alloc_block_BF+0x13b>
  802899:	b8 00 00 00 00       	mov    $0x0,%eax
  80289e:	a3 40 41 80 00       	mov    %eax,0x804140
  8028a3:	a1 40 41 80 00       	mov    0x804140,%eax
  8028a8:	85 c0                	test   %eax,%eax
  8028aa:	75 b9                	jne    802865 <alloc_block_BF+0x102>
  8028ac:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8028b0:	75 b3                	jne    802865 <alloc_block_BF+0x102>
			newsize = blk->size;
			newveradd = blk->sva;
			break;
		}
	}
	LIST_FOREACH(blk, &FreeMemBlocksList)
  8028b2:	a1 38 41 80 00       	mov    0x804138,%eax
  8028b7:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8028ba:	eb 30                	jmp    8028ec <alloc_block_BF+0x189>
	{
		if(newsize > blk->size && blk->size > versize)
  8028bc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028bf:	8b 40 0c             	mov    0xc(%eax),%eax
  8028c2:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  8028c5:	73 1d                	jae    8028e4 <alloc_block_BF+0x181>
  8028c7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028ca:	8b 40 0c             	mov    0xc(%eax),%eax
  8028cd:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  8028d0:	76 12                	jbe    8028e4 <alloc_block_BF+0x181>
		{
	       newsize = blk->size;
  8028d2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028d5:	8b 40 0c             	mov    0xc(%eax),%eax
  8028d8:	89 45 ec             	mov    %eax,-0x14(%ebp)
		   newveradd = blk->sva;
  8028db:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028de:	8b 40 08             	mov    0x8(%eax),%eax
  8028e1:	89 45 f0             	mov    %eax,-0x10(%ebp)
			newsize = blk->size;
			newveradd = blk->sva;
			break;
		}
	}
	LIST_FOREACH(blk, &FreeMemBlocksList)
  8028e4:	a1 40 41 80 00       	mov    0x804140,%eax
  8028e9:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8028ec:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8028f0:	74 07                	je     8028f9 <alloc_block_BF+0x196>
  8028f2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028f5:	8b 00                	mov    (%eax),%eax
  8028f7:	eb 05                	jmp    8028fe <alloc_block_BF+0x19b>
  8028f9:	b8 00 00 00 00       	mov    $0x0,%eax
  8028fe:	a3 40 41 80 00       	mov    %eax,0x804140
  802903:	a1 40 41 80 00       	mov    0x804140,%eax
  802908:	85 c0                	test   %eax,%eax
  80290a:	75 b0                	jne    8028bc <alloc_block_BF+0x159>
  80290c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802910:	75 aa                	jne    8028bc <alloc_block_BF+0x159>
		{
	       newsize = blk->size;
		   newveradd = blk->sva;
		}
	}
	LIST_FOREACH(blk, &FreeMemBlocksList)
  802912:	a1 38 41 80 00       	mov    0x804138,%eax
  802917:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80291a:	e9 e4 00 00 00       	jmp    802a03 <alloc_block_BF+0x2a0>
	{
		if(blk->size == newsize && blk->sva == newveradd)
  80291f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802922:	8b 40 0c             	mov    0xc(%eax),%eax
  802925:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  802928:	0f 85 cd 00 00 00    	jne    8029fb <alloc_block_BF+0x298>
  80292e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802931:	8b 40 08             	mov    0x8(%eax),%eax
  802934:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  802937:	0f 85 be 00 00 00    	jne    8029fb <alloc_block_BF+0x298>
		{
			LIST_REMOVE(&AvailableMemBlocksList, newblk);
  80293d:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  802941:	75 17                	jne    80295a <alloc_block_BF+0x1f7>
  802943:	83 ec 04             	sub    $0x4,%esp
  802946:	68 88 3b 80 00       	push   $0x803b88
  80294b:	68 db 00 00 00       	push   $0xdb
  802950:	68 17 3b 80 00       	push   $0x803b17
  802955:	e8 98 db ff ff       	call   8004f2 <_panic>
  80295a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80295d:	8b 00                	mov    (%eax),%eax
  80295f:	85 c0                	test   %eax,%eax
  802961:	74 10                	je     802973 <alloc_block_BF+0x210>
  802963:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802966:	8b 00                	mov    (%eax),%eax
  802968:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80296b:	8b 52 04             	mov    0x4(%edx),%edx
  80296e:	89 50 04             	mov    %edx,0x4(%eax)
  802971:	eb 0b                	jmp    80297e <alloc_block_BF+0x21b>
  802973:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802976:	8b 40 04             	mov    0x4(%eax),%eax
  802979:	a3 4c 41 80 00       	mov    %eax,0x80414c
  80297e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802981:	8b 40 04             	mov    0x4(%eax),%eax
  802984:	85 c0                	test   %eax,%eax
  802986:	74 0f                	je     802997 <alloc_block_BF+0x234>
  802988:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80298b:	8b 40 04             	mov    0x4(%eax),%eax
  80298e:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802991:	8b 12                	mov    (%edx),%edx
  802993:	89 10                	mov    %edx,(%eax)
  802995:	eb 0a                	jmp    8029a1 <alloc_block_BF+0x23e>
  802997:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80299a:	8b 00                	mov    (%eax),%eax
  80299c:	a3 48 41 80 00       	mov    %eax,0x804148
  8029a1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8029a4:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8029aa:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8029ad:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8029b4:	a1 54 41 80 00       	mov    0x804154,%eax
  8029b9:	48                   	dec    %eax
  8029ba:	a3 54 41 80 00       	mov    %eax,0x804154
			newblk->size = versize;
  8029bf:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8029c2:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8029c5:	89 50 0c             	mov    %edx,0xc(%eax)
			newblk->sva = newveradd;
  8029c8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8029cb:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8029ce:	89 50 08             	mov    %edx,0x8(%eax)
			blk->size = blk->size - versize;
  8029d1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029d4:	8b 40 0c             	mov    0xc(%eax),%eax
  8029d7:	2b 45 e8             	sub    -0x18(%ebp),%eax
  8029da:	89 c2                	mov    %eax,%edx
  8029dc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029df:	89 50 0c             	mov    %edx,0xc(%eax)
			blk->sva+= newblk->size;
  8029e2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029e5:	8b 50 08             	mov    0x8(%eax),%edx
  8029e8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8029eb:	8b 40 0c             	mov    0xc(%eax),%eax
  8029ee:	01 c2                	add    %eax,%edx
  8029f0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029f3:	89 50 08             	mov    %edx,0x8(%eax)
			return newblk;
  8029f6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8029f9:	eb 3b                	jmp    802a36 <alloc_block_BF+0x2d3>
		{
	       newsize = blk->size;
		   newveradd = blk->sva;
		}
	}
	LIST_FOREACH(blk, &FreeMemBlocksList)
  8029fb:	a1 40 41 80 00       	mov    0x804140,%eax
  802a00:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802a03:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802a07:	74 07                	je     802a10 <alloc_block_BF+0x2ad>
  802a09:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a0c:	8b 00                	mov    (%eax),%eax
  802a0e:	eb 05                	jmp    802a15 <alloc_block_BF+0x2b2>
  802a10:	b8 00 00 00 00       	mov    $0x0,%eax
  802a15:	a3 40 41 80 00       	mov    %eax,0x804140
  802a1a:	a1 40 41 80 00       	mov    0x804140,%eax
  802a1f:	85 c0                	test   %eax,%eax
  802a21:	0f 85 f8 fe ff ff    	jne    80291f <alloc_block_BF+0x1bc>
  802a27:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802a2b:	0f 85 ee fe ff ff    	jne    80291f <alloc_block_BF+0x1bc>
			blk->size = blk->size - versize;
			blk->sva+= newblk->size;
			return newblk;
		}
	}
	return NULL;
  802a31:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802a36:	c9                   	leave  
  802a37:	c3                   	ret    

00802a38 <alloc_block_NF>:
//=========================================
// [7] ALLOCATE BLOCK BY NEXT FIT:
//=========================================
struct MemBlock *last_allocate;
struct MemBlock *alloc_block_NF(uint32 size)
{
  802a38:	55                   	push   %ebp
  802a39:	89 e5                	mov    %esp,%ebp
  802a3b:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1 - BONUS] [DYNAMIC ALLOCATOR] alloc_block_NF
	// Write your code here, remove the panic and write your code
	//panic("alloc_block_NF() is not implemented yet...!!");
	uint32 versize = size;
  802a3e:	8b 45 08             	mov    0x8(%ebp),%eax
  802a41:	89 45 f0             	mov    %eax,-0x10(%ebp)
	struct MemBlock* blk;
	struct MemBlock* newblk = LIST_FIRST(&AvailableMemBlocksList);
  802a44:	a1 48 41 80 00       	mov    0x804148,%eax
  802a49:	89 45 ec             	mov    %eax,-0x14(%ebp)

	LIST_FOREACH(blk,&FreeMemBlocksList)
  802a4c:	a1 38 41 80 00       	mov    0x804138,%eax
  802a51:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802a54:	e9 77 01 00 00       	jmp    802bd0 <alloc_block_NF+0x198>
	{
		if(blk->size == versize)
  802a59:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a5c:	8b 40 0c             	mov    0xc(%eax),%eax
  802a5f:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  802a62:	0f 85 8a 00 00 00    	jne    802af2 <alloc_block_NF+0xba>
		{
			LIST_REMOVE(&FreeMemBlocksList,blk);
  802a68:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802a6c:	75 17                	jne    802a85 <alloc_block_NF+0x4d>
  802a6e:	83 ec 04             	sub    $0x4,%esp
  802a71:	68 88 3b 80 00       	push   $0x803b88
  802a76:	68 f7 00 00 00       	push   $0xf7
  802a7b:	68 17 3b 80 00       	push   $0x803b17
  802a80:	e8 6d da ff ff       	call   8004f2 <_panic>
  802a85:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a88:	8b 00                	mov    (%eax),%eax
  802a8a:	85 c0                	test   %eax,%eax
  802a8c:	74 10                	je     802a9e <alloc_block_NF+0x66>
  802a8e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a91:	8b 00                	mov    (%eax),%eax
  802a93:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802a96:	8b 52 04             	mov    0x4(%edx),%edx
  802a99:	89 50 04             	mov    %edx,0x4(%eax)
  802a9c:	eb 0b                	jmp    802aa9 <alloc_block_NF+0x71>
  802a9e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802aa1:	8b 40 04             	mov    0x4(%eax),%eax
  802aa4:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802aa9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802aac:	8b 40 04             	mov    0x4(%eax),%eax
  802aaf:	85 c0                	test   %eax,%eax
  802ab1:	74 0f                	je     802ac2 <alloc_block_NF+0x8a>
  802ab3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ab6:	8b 40 04             	mov    0x4(%eax),%eax
  802ab9:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802abc:	8b 12                	mov    (%edx),%edx
  802abe:	89 10                	mov    %edx,(%eax)
  802ac0:	eb 0a                	jmp    802acc <alloc_block_NF+0x94>
  802ac2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ac5:	8b 00                	mov    (%eax),%eax
  802ac7:	a3 38 41 80 00       	mov    %eax,0x804138
  802acc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802acf:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802ad5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ad8:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802adf:	a1 44 41 80 00       	mov    0x804144,%eax
  802ae4:	48                   	dec    %eax
  802ae5:	a3 44 41 80 00       	mov    %eax,0x804144
			return blk;
  802aea:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802aed:	e9 11 01 00 00       	jmp    802c03 <alloc_block_NF+0x1cb>
		}
		else if(blk->size > versize)
  802af2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802af5:	8b 40 0c             	mov    0xc(%eax),%eax
  802af8:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  802afb:	0f 86 c7 00 00 00    	jbe    802bc8 <alloc_block_NF+0x190>
		{
			LIST_REMOVE(&AvailableMemBlocksList,newblk);
  802b01:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802b05:	75 17                	jne    802b1e <alloc_block_NF+0xe6>
  802b07:	83 ec 04             	sub    $0x4,%esp
  802b0a:	68 88 3b 80 00       	push   $0x803b88
  802b0f:	68 fc 00 00 00       	push   $0xfc
  802b14:	68 17 3b 80 00       	push   $0x803b17
  802b19:	e8 d4 d9 ff ff       	call   8004f2 <_panic>
  802b1e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802b21:	8b 00                	mov    (%eax),%eax
  802b23:	85 c0                	test   %eax,%eax
  802b25:	74 10                	je     802b37 <alloc_block_NF+0xff>
  802b27:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802b2a:	8b 00                	mov    (%eax),%eax
  802b2c:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802b2f:	8b 52 04             	mov    0x4(%edx),%edx
  802b32:	89 50 04             	mov    %edx,0x4(%eax)
  802b35:	eb 0b                	jmp    802b42 <alloc_block_NF+0x10a>
  802b37:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802b3a:	8b 40 04             	mov    0x4(%eax),%eax
  802b3d:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802b42:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802b45:	8b 40 04             	mov    0x4(%eax),%eax
  802b48:	85 c0                	test   %eax,%eax
  802b4a:	74 0f                	je     802b5b <alloc_block_NF+0x123>
  802b4c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802b4f:	8b 40 04             	mov    0x4(%eax),%eax
  802b52:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802b55:	8b 12                	mov    (%edx),%edx
  802b57:	89 10                	mov    %edx,(%eax)
  802b59:	eb 0a                	jmp    802b65 <alloc_block_NF+0x12d>
  802b5b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802b5e:	8b 00                	mov    (%eax),%eax
  802b60:	a3 48 41 80 00       	mov    %eax,0x804148
  802b65:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802b68:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802b6e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802b71:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802b78:	a1 54 41 80 00       	mov    0x804154,%eax
  802b7d:	48                   	dec    %eax
  802b7e:	a3 54 41 80 00       	mov    %eax,0x804154
			newblk->size = versize;
  802b83:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802b86:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802b89:	89 50 0c             	mov    %edx,0xc(%eax)
			blk->size = blk->size-versize;
  802b8c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b8f:	8b 40 0c             	mov    0xc(%eax),%eax
  802b92:	2b 45 f0             	sub    -0x10(%ebp),%eax
  802b95:	89 c2                	mov    %eax,%edx
  802b97:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b9a:	89 50 0c             	mov    %edx,0xc(%eax)
			uint32 newveradd = blk->sva;
  802b9d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ba0:	8b 40 08             	mov    0x8(%eax),%eax
  802ba3:	89 45 e8             	mov    %eax,-0x18(%ebp)
			blk->sva+=newblk->size;
  802ba6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ba9:	8b 50 08             	mov    0x8(%eax),%edx
  802bac:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802baf:	8b 40 0c             	mov    0xc(%eax),%eax
  802bb2:	01 c2                	add    %eax,%edx
  802bb4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bb7:	89 50 08             	mov    %edx,0x8(%eax)
			newblk->sva = newveradd;
  802bba:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802bbd:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802bc0:	89 50 08             	mov    %edx,0x8(%eax)
			return newblk;
  802bc3:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802bc6:	eb 3b                	jmp    802c03 <alloc_block_NF+0x1cb>
	//panic("alloc_block_NF() is not implemented yet...!!");
	uint32 versize = size;
	struct MemBlock* blk;
	struct MemBlock* newblk = LIST_FIRST(&AvailableMemBlocksList);

	LIST_FOREACH(blk,&FreeMemBlocksList)
  802bc8:	a1 40 41 80 00       	mov    0x804140,%eax
  802bcd:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802bd0:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802bd4:	74 07                	je     802bdd <alloc_block_NF+0x1a5>
  802bd6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bd9:	8b 00                	mov    (%eax),%eax
  802bdb:	eb 05                	jmp    802be2 <alloc_block_NF+0x1aa>
  802bdd:	b8 00 00 00 00       	mov    $0x0,%eax
  802be2:	a3 40 41 80 00       	mov    %eax,0x804140
  802be7:	a1 40 41 80 00       	mov    0x804140,%eax
  802bec:	85 c0                	test   %eax,%eax
  802bee:	0f 85 65 fe ff ff    	jne    802a59 <alloc_block_NF+0x21>
  802bf4:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802bf8:	0f 85 5b fe ff ff    	jne    802a59 <alloc_block_NF+0x21>
			blk->sva+=newblk->size;
			newblk->sva = newveradd;
			return newblk;
		}
	}
	return NULL;
  802bfe:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802c03:	c9                   	leave  
  802c04:	c3                   	ret    

00802c05 <addToAvailMemBlocksList>:

//===================================================
// [8] INSERT BLOCK (SORTED WITH MERGE) IN FREE LIST:
//===================================================
void addToAvailMemBlocksList(struct MemBlock *blockToInsert)
{
  802c05:	55                   	push   %ebp
  802c06:	89 e5                	mov    %esp,%ebp
  802c08:	83 ec 08             	sub    $0x8,%esp
	blockToInsert->sva = 0;
  802c0b:	8b 45 08             	mov    0x8(%ebp),%eax
  802c0e:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
	blockToInsert->size = 0;
  802c15:	8b 45 08             	mov    0x8(%ebp),%eax
  802c18:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
	//add to avail
	LIST_INSERT_TAIL(&AvailableMemBlocksList, blockToInsert);
  802c1f:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802c23:	75 17                	jne    802c3c <addToAvailMemBlocksList+0x37>
  802c25:	83 ec 04             	sub    $0x4,%esp
  802c28:	68 30 3b 80 00       	push   $0x803b30
  802c2d:	68 10 01 00 00       	push   $0x110
  802c32:	68 17 3b 80 00       	push   $0x803b17
  802c37:	e8 b6 d8 ff ff       	call   8004f2 <_panic>
  802c3c:	8b 15 4c 41 80 00    	mov    0x80414c,%edx
  802c42:	8b 45 08             	mov    0x8(%ebp),%eax
  802c45:	89 50 04             	mov    %edx,0x4(%eax)
  802c48:	8b 45 08             	mov    0x8(%ebp),%eax
  802c4b:	8b 40 04             	mov    0x4(%eax),%eax
  802c4e:	85 c0                	test   %eax,%eax
  802c50:	74 0c                	je     802c5e <addToAvailMemBlocksList+0x59>
  802c52:	a1 4c 41 80 00       	mov    0x80414c,%eax
  802c57:	8b 55 08             	mov    0x8(%ebp),%edx
  802c5a:	89 10                	mov    %edx,(%eax)
  802c5c:	eb 08                	jmp    802c66 <addToAvailMemBlocksList+0x61>
  802c5e:	8b 45 08             	mov    0x8(%ebp),%eax
  802c61:	a3 48 41 80 00       	mov    %eax,0x804148
  802c66:	8b 45 08             	mov    0x8(%ebp),%eax
  802c69:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802c6e:	8b 45 08             	mov    0x8(%ebp),%eax
  802c71:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802c77:	a1 54 41 80 00       	mov    0x804154,%eax
  802c7c:	40                   	inc    %eax
  802c7d:	a3 54 41 80 00       	mov    %eax,0x804154
}
  802c82:	90                   	nop
  802c83:	c9                   	leave  
  802c84:	c3                   	ret    

00802c85 <insert_sorted_with_merge_freeList>:
void insert_sorted_with_merge_freeList(struct MemBlock *blockToInsert)
{
  802c85:	55                   	push   %ebp
  802c86:	89 e5                	mov    %esp,%ebp
  802c88:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] insert_sorted_with_merge_freeList
	// Write your code here, remove the panic and write your code

	struct MemBlock* last = LIST_LAST(&FreeMemBlocksList);
  802c8b:	a1 3c 41 80 00       	mov    0x80413c,%eax
  802c90:	89 45 f0             	mov    %eax,-0x10(%ebp)
	//check if list empty
	if (LIST_SIZE(&(FreeMemBlocksList)) == 0)
  802c93:	a1 44 41 80 00       	mov    0x804144,%eax
  802c98:	85 c0                	test   %eax,%eax
  802c9a:	75 68                	jne    802d04 <insert_sorted_with_merge_freeList+0x7f>
		LIST_INSERT_HEAD(&FreeMemBlocksList, blockToInsert);
  802c9c:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802ca0:	75 17                	jne    802cb9 <insert_sorted_with_merge_freeList+0x34>
  802ca2:	83 ec 04             	sub    $0x4,%esp
  802ca5:	68 f4 3a 80 00       	push   $0x803af4
  802caa:	68 1a 01 00 00       	push   $0x11a
  802caf:	68 17 3b 80 00       	push   $0x803b17
  802cb4:	e8 39 d8 ff ff       	call   8004f2 <_panic>
  802cb9:	8b 15 38 41 80 00    	mov    0x804138,%edx
  802cbf:	8b 45 08             	mov    0x8(%ebp),%eax
  802cc2:	89 10                	mov    %edx,(%eax)
  802cc4:	8b 45 08             	mov    0x8(%ebp),%eax
  802cc7:	8b 00                	mov    (%eax),%eax
  802cc9:	85 c0                	test   %eax,%eax
  802ccb:	74 0d                	je     802cda <insert_sorted_with_merge_freeList+0x55>
  802ccd:	a1 38 41 80 00       	mov    0x804138,%eax
  802cd2:	8b 55 08             	mov    0x8(%ebp),%edx
  802cd5:	89 50 04             	mov    %edx,0x4(%eax)
  802cd8:	eb 08                	jmp    802ce2 <insert_sorted_with_merge_freeList+0x5d>
  802cda:	8b 45 08             	mov    0x8(%ebp),%eax
  802cdd:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802ce2:	8b 45 08             	mov    0x8(%ebp),%eax
  802ce5:	a3 38 41 80 00       	mov    %eax,0x804138
  802cea:	8b 45 08             	mov    0x8(%ebp),%eax
  802ced:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802cf4:	a1 44 41 80 00       	mov    0x804144,%eax
  802cf9:	40                   	inc    %eax
  802cfa:	a3 44 41 80 00       	mov    %eax,0x804144
		}
	}

	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  802cff:	e9 c5 03 00 00       	jmp    8030c9 <insert_sorted_with_merge_freeList+0x444>
	struct MemBlock* last = LIST_LAST(&FreeMemBlocksList);
	//check if list empty
	if (LIST_SIZE(&(FreeMemBlocksList)) == 0)
		LIST_INSERT_HEAD(&FreeMemBlocksList, blockToInsert);
	//check if it's position is at last
	else if (last->sva < blockToInsert->sva) {
  802d04:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d07:	8b 50 08             	mov    0x8(%eax),%edx
  802d0a:	8b 45 08             	mov    0x8(%ebp),%eax
  802d0d:	8b 40 08             	mov    0x8(%eax),%eax
  802d10:	39 c2                	cmp    %eax,%edx
  802d12:	0f 83 b2 00 00 00    	jae    802dca <insert_sorted_with_merge_freeList+0x145>

		//if i have to merge
		if (last->sva + last->size == blockToInsert->sva) {
  802d18:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d1b:	8b 50 08             	mov    0x8(%eax),%edx
  802d1e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d21:	8b 40 0c             	mov    0xc(%eax),%eax
  802d24:	01 c2                	add    %eax,%edx
  802d26:	8b 45 08             	mov    0x8(%ebp),%eax
  802d29:	8b 40 08             	mov    0x8(%eax),%eax
  802d2c:	39 c2                	cmp    %eax,%edx
  802d2e:	75 27                	jne    802d57 <insert_sorted_with_merge_freeList+0xd2>
			last->size = last->size + blockToInsert->size;
  802d30:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d33:	8b 50 0c             	mov    0xc(%eax),%edx
  802d36:	8b 45 08             	mov    0x8(%ebp),%eax
  802d39:	8b 40 0c             	mov    0xc(%eax),%eax
  802d3c:	01 c2                	add    %eax,%edx
  802d3e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d41:	89 50 0c             	mov    %edx,0xc(%eax)
			addToAvailMemBlocksList(blockToInsert);
  802d44:	83 ec 0c             	sub    $0xc,%esp
  802d47:	ff 75 08             	pushl  0x8(%ebp)
  802d4a:	e8 b6 fe ff ff       	call   802c05 <addToAvailMemBlocksList>
  802d4f:	83 c4 10             	add    $0x10,%esp
		}
	}

	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  802d52:	e9 72 03 00 00       	jmp    8030c9 <insert_sorted_with_merge_freeList+0x444>
		if (last->sva + last->size == blockToInsert->sva) {
			last->size = last->size + blockToInsert->size;
			addToAvailMemBlocksList(blockToInsert);

		} else {
			LIST_INSERT_AFTER(&FreeMemBlocksList, last, blockToInsert);
  802d57:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802d5b:	74 06                	je     802d63 <insert_sorted_with_merge_freeList+0xde>
  802d5d:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802d61:	75 17                	jne    802d7a <insert_sorted_with_merge_freeList+0xf5>
  802d63:	83 ec 04             	sub    $0x4,%esp
  802d66:	68 54 3b 80 00       	push   $0x803b54
  802d6b:	68 24 01 00 00       	push   $0x124
  802d70:	68 17 3b 80 00       	push   $0x803b17
  802d75:	e8 78 d7 ff ff       	call   8004f2 <_panic>
  802d7a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d7d:	8b 10                	mov    (%eax),%edx
  802d7f:	8b 45 08             	mov    0x8(%ebp),%eax
  802d82:	89 10                	mov    %edx,(%eax)
  802d84:	8b 45 08             	mov    0x8(%ebp),%eax
  802d87:	8b 00                	mov    (%eax),%eax
  802d89:	85 c0                	test   %eax,%eax
  802d8b:	74 0b                	je     802d98 <insert_sorted_with_merge_freeList+0x113>
  802d8d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d90:	8b 00                	mov    (%eax),%eax
  802d92:	8b 55 08             	mov    0x8(%ebp),%edx
  802d95:	89 50 04             	mov    %edx,0x4(%eax)
  802d98:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d9b:	8b 55 08             	mov    0x8(%ebp),%edx
  802d9e:	89 10                	mov    %edx,(%eax)
  802da0:	8b 45 08             	mov    0x8(%ebp),%eax
  802da3:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802da6:	89 50 04             	mov    %edx,0x4(%eax)
  802da9:	8b 45 08             	mov    0x8(%ebp),%eax
  802dac:	8b 00                	mov    (%eax),%eax
  802dae:	85 c0                	test   %eax,%eax
  802db0:	75 08                	jne    802dba <insert_sorted_with_merge_freeList+0x135>
  802db2:	8b 45 08             	mov    0x8(%ebp),%eax
  802db5:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802dba:	a1 44 41 80 00       	mov    0x804144,%eax
  802dbf:	40                   	inc    %eax
  802dc0:	a3 44 41 80 00       	mov    %eax,0x804144
		}
	}

	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  802dc5:	e9 ff 02 00 00       	jmp    8030c9 <insert_sorted_with_merge_freeList+0x444>
		} else {
			LIST_INSERT_AFTER(&FreeMemBlocksList, last, blockToInsert);
		}
	} else {
		struct MemBlock *iterator;
		LIST_FOREACH(iterator, &(FreeMemBlocksList))
  802dca:	a1 38 41 80 00       	mov    0x804138,%eax
  802dcf:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802dd2:	e9 c2 02 00 00       	jmp    803099 <insert_sorted_with_merge_freeList+0x414>
		{

			if (iterator->sva > blockToInsert->sva) {
  802dd7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802dda:	8b 50 08             	mov    0x8(%eax),%edx
  802ddd:	8b 45 08             	mov    0x8(%ebp),%eax
  802de0:	8b 40 08             	mov    0x8(%eax),%eax
  802de3:	39 c2                	cmp    %eax,%edx
  802de5:	0f 86 a6 02 00 00    	jbe    803091 <insert_sorted_with_merge_freeList+0x40c>

				struct MemBlock* prev = LIST_PREV(iterator);
  802deb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802dee:	8b 40 04             	mov    0x4(%eax),%eax
  802df1:	89 45 ec             	mov    %eax,-0x14(%ebp)
				if (prev == NULL) {
  802df4:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802df8:	0f 85 ba 00 00 00    	jne    802eb8 <insert_sorted_with_merge_freeList+0x233>
					//check merge
					if (blockToInsert->size + blockToInsert->sva
  802dfe:	8b 45 08             	mov    0x8(%ebp),%eax
  802e01:	8b 50 0c             	mov    0xc(%eax),%edx
  802e04:	8b 45 08             	mov    0x8(%ebp),%eax
  802e07:	8b 40 08             	mov    0x8(%eax),%eax
  802e0a:	01 c2                	add    %eax,%edx
							== iterator->sva) {
  802e0c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e0f:	8b 40 08             	mov    0x8(%eax),%eax
			if (iterator->sva > blockToInsert->sva) {

				struct MemBlock* prev = LIST_PREV(iterator);
				if (prev == NULL) {
					//check merge
					if (blockToInsert->size + blockToInsert->sva
  802e12:	39 c2                	cmp    %eax,%edx
  802e14:	75 33                	jne    802e49 <insert_sorted_with_merge_freeList+0x1c4>
							== iterator->sva) {
						iterator->sva = blockToInsert->sva;
  802e16:	8b 45 08             	mov    0x8(%ebp),%eax
  802e19:	8b 50 08             	mov    0x8(%eax),%edx
  802e1c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e1f:	89 50 08             	mov    %edx,0x8(%eax)
						iterator->size = iterator->size + blockToInsert->size;
  802e22:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e25:	8b 50 0c             	mov    0xc(%eax),%edx
  802e28:	8b 45 08             	mov    0x8(%ebp),%eax
  802e2b:	8b 40 0c             	mov    0xc(%eax),%eax
  802e2e:	01 c2                	add    %eax,%edx
  802e30:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e33:	89 50 0c             	mov    %edx,0xc(%eax)
						addToAvailMemBlocksList(blockToInsert);
  802e36:	83 ec 0c             	sub    $0xc,%esp
  802e39:	ff 75 08             	pushl  0x8(%ebp)
  802e3c:	e8 c4 fd ff ff       	call   802c05 <addToAvailMemBlocksList>
  802e41:	83 c4 10             	add    $0x10,%esp

					else {
						LIST_INSERT_BEFORE(&FreeMemBlocksList, iterator,
								blockToInsert);
					}
					break;
  802e44:	e9 80 02 00 00       	jmp    8030c9 <insert_sorted_with_merge_freeList+0x444>
						addToAvailMemBlocksList(blockToInsert);

					}

					else {
						LIST_INSERT_BEFORE(&FreeMemBlocksList, iterator,
  802e49:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802e4d:	74 06                	je     802e55 <insert_sorted_with_merge_freeList+0x1d0>
  802e4f:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802e53:	75 17                	jne    802e6c <insert_sorted_with_merge_freeList+0x1e7>
  802e55:	83 ec 04             	sub    $0x4,%esp
  802e58:	68 a8 3b 80 00       	push   $0x803ba8
  802e5d:	68 3a 01 00 00       	push   $0x13a
  802e62:	68 17 3b 80 00       	push   $0x803b17
  802e67:	e8 86 d6 ff ff       	call   8004f2 <_panic>
  802e6c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e6f:	8b 50 04             	mov    0x4(%eax),%edx
  802e72:	8b 45 08             	mov    0x8(%ebp),%eax
  802e75:	89 50 04             	mov    %edx,0x4(%eax)
  802e78:	8b 45 08             	mov    0x8(%ebp),%eax
  802e7b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802e7e:	89 10                	mov    %edx,(%eax)
  802e80:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e83:	8b 40 04             	mov    0x4(%eax),%eax
  802e86:	85 c0                	test   %eax,%eax
  802e88:	74 0d                	je     802e97 <insert_sorted_with_merge_freeList+0x212>
  802e8a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e8d:	8b 40 04             	mov    0x4(%eax),%eax
  802e90:	8b 55 08             	mov    0x8(%ebp),%edx
  802e93:	89 10                	mov    %edx,(%eax)
  802e95:	eb 08                	jmp    802e9f <insert_sorted_with_merge_freeList+0x21a>
  802e97:	8b 45 08             	mov    0x8(%ebp),%eax
  802e9a:	a3 38 41 80 00       	mov    %eax,0x804138
  802e9f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ea2:	8b 55 08             	mov    0x8(%ebp),%edx
  802ea5:	89 50 04             	mov    %edx,0x4(%eax)
  802ea8:	a1 44 41 80 00       	mov    0x804144,%eax
  802ead:	40                   	inc    %eax
  802eae:	a3 44 41 80 00       	mov    %eax,0x804144
								blockToInsert);
					}
					break;
  802eb3:	e9 11 02 00 00       	jmp    8030c9 <insert_sorted_with_merge_freeList+0x444>
				} else {
					//prev and next merge
					if (prev->sva + prev->size + blockToInsert->size
  802eb8:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802ebb:	8b 50 08             	mov    0x8(%eax),%edx
  802ebe:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802ec1:	8b 40 0c             	mov    0xc(%eax),%eax
  802ec4:	01 c2                	add    %eax,%edx
  802ec6:	8b 45 08             	mov    0x8(%ebp),%eax
  802ec9:	8b 40 0c             	mov    0xc(%eax),%eax
  802ecc:	01 c2                	add    %eax,%edx
							== iterator->sva) {
  802ece:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ed1:	8b 40 08             	mov    0x8(%eax),%eax
								blockToInsert);
					}
					break;
				} else {
					//prev and next merge
					if (prev->sva + prev->size + blockToInsert->size
  802ed4:	39 c2                	cmp    %eax,%edx
  802ed6:	0f 85 bf 00 00 00    	jne    802f9b <insert_sorted_with_merge_freeList+0x316>
							== iterator->sva) {
						prev->size = prev->size + blockToInsert->size
  802edc:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802edf:	8b 50 0c             	mov    0xc(%eax),%edx
  802ee2:	8b 45 08             	mov    0x8(%ebp),%eax
  802ee5:	8b 40 0c             	mov    0xc(%eax),%eax
  802ee8:	01 c2                	add    %eax,%edx
								+ iterator->size;
  802eea:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802eed:	8b 40 0c             	mov    0xc(%eax),%eax
  802ef0:	01 c2                	add    %eax,%edx
					break;
				} else {
					//prev and next merge
					if (prev->sva + prev->size + blockToInsert->size
							== iterator->sva) {
						prev->size = prev->size + blockToInsert->size
  802ef2:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802ef5:	89 50 0c             	mov    %edx,0xc(%eax)
								+ iterator->size;
						LIST_REMOVE(&FreeMemBlocksList, iterator);
  802ef8:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802efc:	75 17                	jne    802f15 <insert_sorted_with_merge_freeList+0x290>
  802efe:	83 ec 04             	sub    $0x4,%esp
  802f01:	68 88 3b 80 00       	push   $0x803b88
  802f06:	68 43 01 00 00       	push   $0x143
  802f0b:	68 17 3b 80 00       	push   $0x803b17
  802f10:	e8 dd d5 ff ff       	call   8004f2 <_panic>
  802f15:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f18:	8b 00                	mov    (%eax),%eax
  802f1a:	85 c0                	test   %eax,%eax
  802f1c:	74 10                	je     802f2e <insert_sorted_with_merge_freeList+0x2a9>
  802f1e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f21:	8b 00                	mov    (%eax),%eax
  802f23:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802f26:	8b 52 04             	mov    0x4(%edx),%edx
  802f29:	89 50 04             	mov    %edx,0x4(%eax)
  802f2c:	eb 0b                	jmp    802f39 <insert_sorted_with_merge_freeList+0x2b4>
  802f2e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f31:	8b 40 04             	mov    0x4(%eax),%eax
  802f34:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802f39:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f3c:	8b 40 04             	mov    0x4(%eax),%eax
  802f3f:	85 c0                	test   %eax,%eax
  802f41:	74 0f                	je     802f52 <insert_sorted_with_merge_freeList+0x2cd>
  802f43:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f46:	8b 40 04             	mov    0x4(%eax),%eax
  802f49:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802f4c:	8b 12                	mov    (%edx),%edx
  802f4e:	89 10                	mov    %edx,(%eax)
  802f50:	eb 0a                	jmp    802f5c <insert_sorted_with_merge_freeList+0x2d7>
  802f52:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f55:	8b 00                	mov    (%eax),%eax
  802f57:	a3 38 41 80 00       	mov    %eax,0x804138
  802f5c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f5f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802f65:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f68:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802f6f:	a1 44 41 80 00       	mov    0x804144,%eax
  802f74:	48                   	dec    %eax
  802f75:	a3 44 41 80 00       	mov    %eax,0x804144
						addToAvailMemBlocksList(blockToInsert);
  802f7a:	83 ec 0c             	sub    $0xc,%esp
  802f7d:	ff 75 08             	pushl  0x8(%ebp)
  802f80:	e8 80 fc ff ff       	call   802c05 <addToAvailMemBlocksList>
  802f85:	83 c4 10             	add    $0x10,%esp
						addToAvailMemBlocksList(iterator);
  802f88:	83 ec 0c             	sub    $0xc,%esp
  802f8b:	ff 75 f4             	pushl  -0xc(%ebp)
  802f8e:	e8 72 fc ff ff       	call   802c05 <addToAvailMemBlocksList>
  802f93:	83 c4 10             	add    $0x10,%esp
					//Insert
					else {
						LIST_INSERT_BEFORE(&FreeMemBlocksList, iterator,
								blockToInsert);
					}
					break;
  802f96:	e9 2e 01 00 00       	jmp    8030c9 <insert_sorted_with_merge_freeList+0x444>
						LIST_REMOVE(&FreeMemBlocksList, iterator);
						addToAvailMemBlocksList(blockToInsert);
						addToAvailMemBlocksList(iterator);
					}
					//previous merge
					else if (prev->sva + prev->size == blockToInsert->sva) {
  802f9b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802f9e:	8b 50 08             	mov    0x8(%eax),%edx
  802fa1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802fa4:	8b 40 0c             	mov    0xc(%eax),%eax
  802fa7:	01 c2                	add    %eax,%edx
  802fa9:	8b 45 08             	mov    0x8(%ebp),%eax
  802fac:	8b 40 08             	mov    0x8(%eax),%eax
  802faf:	39 c2                	cmp    %eax,%edx
  802fb1:	75 27                	jne    802fda <insert_sorted_with_merge_freeList+0x355>
						prev->size = prev->size + blockToInsert->size;
  802fb3:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802fb6:	8b 50 0c             	mov    0xc(%eax),%edx
  802fb9:	8b 45 08             	mov    0x8(%ebp),%eax
  802fbc:	8b 40 0c             	mov    0xc(%eax),%eax
  802fbf:	01 c2                	add    %eax,%edx
  802fc1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802fc4:	89 50 0c             	mov    %edx,0xc(%eax)
						addToAvailMemBlocksList(blockToInsert);
  802fc7:	83 ec 0c             	sub    $0xc,%esp
  802fca:	ff 75 08             	pushl  0x8(%ebp)
  802fcd:	e8 33 fc ff ff       	call   802c05 <addToAvailMemBlocksList>
  802fd2:	83 c4 10             	add    $0x10,%esp
					//Insert
					else {
						LIST_INSERT_BEFORE(&FreeMemBlocksList, iterator,
								blockToInsert);
					}
					break;
  802fd5:	e9 ef 00 00 00       	jmp    8030c9 <insert_sorted_with_merge_freeList+0x444>
					else if (prev->sva + prev->size == blockToInsert->sva) {
						prev->size = prev->size + blockToInsert->size;
						addToAvailMemBlocksList(blockToInsert);
					}
					//next merge
					else if (blockToInsert->size + blockToInsert->sva
  802fda:	8b 45 08             	mov    0x8(%ebp),%eax
  802fdd:	8b 50 0c             	mov    0xc(%eax),%edx
  802fe0:	8b 45 08             	mov    0x8(%ebp),%eax
  802fe3:	8b 40 08             	mov    0x8(%eax),%eax
  802fe6:	01 c2                	add    %eax,%edx
							== iterator->sva) {
  802fe8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802feb:	8b 40 08             	mov    0x8(%eax),%eax
					else if (prev->sva + prev->size == blockToInsert->sva) {
						prev->size = prev->size + blockToInsert->size;
						addToAvailMemBlocksList(blockToInsert);
					}
					//next merge
					else if (blockToInsert->size + blockToInsert->sva
  802fee:	39 c2                	cmp    %eax,%edx
  802ff0:	75 33                	jne    803025 <insert_sorted_with_merge_freeList+0x3a0>
							== iterator->sva) {
						iterator->sva = blockToInsert->sva;
  802ff2:	8b 45 08             	mov    0x8(%ebp),%eax
  802ff5:	8b 50 08             	mov    0x8(%eax),%edx
  802ff8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ffb:	89 50 08             	mov    %edx,0x8(%eax)
						iterator->size = iterator->size + blockToInsert->size;
  802ffe:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803001:	8b 50 0c             	mov    0xc(%eax),%edx
  803004:	8b 45 08             	mov    0x8(%ebp),%eax
  803007:	8b 40 0c             	mov    0xc(%eax),%eax
  80300a:	01 c2                	add    %eax,%edx
  80300c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80300f:	89 50 0c             	mov    %edx,0xc(%eax)
						addToAvailMemBlocksList(blockToInsert);
  803012:	83 ec 0c             	sub    $0xc,%esp
  803015:	ff 75 08             	pushl  0x8(%ebp)
  803018:	e8 e8 fb ff ff       	call   802c05 <addToAvailMemBlocksList>
  80301d:	83 c4 10             	add    $0x10,%esp
					//Insert
					else {
						LIST_INSERT_BEFORE(&FreeMemBlocksList, iterator,
								blockToInsert);
					}
					break;
  803020:	e9 a4 00 00 00       	jmp    8030c9 <insert_sorted_with_merge_freeList+0x444>
						iterator->size = iterator->size + blockToInsert->size;
						addToAvailMemBlocksList(blockToInsert);
					}
					//Insert
					else {
						LIST_INSERT_BEFORE(&FreeMemBlocksList, iterator,
  803025:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803029:	74 06                	je     803031 <insert_sorted_with_merge_freeList+0x3ac>
  80302b:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80302f:	75 17                	jne    803048 <insert_sorted_with_merge_freeList+0x3c3>
  803031:	83 ec 04             	sub    $0x4,%esp
  803034:	68 a8 3b 80 00       	push   $0x803ba8
  803039:	68 56 01 00 00       	push   $0x156
  80303e:	68 17 3b 80 00       	push   $0x803b17
  803043:	e8 aa d4 ff ff       	call   8004f2 <_panic>
  803048:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80304b:	8b 50 04             	mov    0x4(%eax),%edx
  80304e:	8b 45 08             	mov    0x8(%ebp),%eax
  803051:	89 50 04             	mov    %edx,0x4(%eax)
  803054:	8b 45 08             	mov    0x8(%ebp),%eax
  803057:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80305a:	89 10                	mov    %edx,(%eax)
  80305c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80305f:	8b 40 04             	mov    0x4(%eax),%eax
  803062:	85 c0                	test   %eax,%eax
  803064:	74 0d                	je     803073 <insert_sorted_with_merge_freeList+0x3ee>
  803066:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803069:	8b 40 04             	mov    0x4(%eax),%eax
  80306c:	8b 55 08             	mov    0x8(%ebp),%edx
  80306f:	89 10                	mov    %edx,(%eax)
  803071:	eb 08                	jmp    80307b <insert_sorted_with_merge_freeList+0x3f6>
  803073:	8b 45 08             	mov    0x8(%ebp),%eax
  803076:	a3 38 41 80 00       	mov    %eax,0x804138
  80307b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80307e:	8b 55 08             	mov    0x8(%ebp),%edx
  803081:	89 50 04             	mov    %edx,0x4(%eax)
  803084:	a1 44 41 80 00       	mov    0x804144,%eax
  803089:	40                   	inc    %eax
  80308a:	a3 44 41 80 00       	mov    %eax,0x804144
								blockToInsert);
					}
					break;
  80308f:	eb 38                	jmp    8030c9 <insert_sorted_with_merge_freeList+0x444>
		} else {
			LIST_INSERT_AFTER(&FreeMemBlocksList, last, blockToInsert);
		}
	} else {
		struct MemBlock *iterator;
		LIST_FOREACH(iterator, &(FreeMemBlocksList))
  803091:	a1 40 41 80 00       	mov    0x804140,%eax
  803096:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803099:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80309d:	74 07                	je     8030a6 <insert_sorted_with_merge_freeList+0x421>
  80309f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030a2:	8b 00                	mov    (%eax),%eax
  8030a4:	eb 05                	jmp    8030ab <insert_sorted_with_merge_freeList+0x426>
  8030a6:	b8 00 00 00 00       	mov    $0x0,%eax
  8030ab:	a3 40 41 80 00       	mov    %eax,0x804140
  8030b0:	a1 40 41 80 00       	mov    0x804140,%eax
  8030b5:	85 c0                	test   %eax,%eax
  8030b7:	0f 85 1a fd ff ff    	jne    802dd7 <insert_sorted_with_merge_freeList+0x152>
  8030bd:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8030c1:	0f 85 10 fd ff ff    	jne    802dd7 <insert_sorted_with_merge_freeList+0x152>
		}
	}

	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  8030c7:	eb 00                	jmp    8030c9 <insert_sorted_with_merge_freeList+0x444>
  8030c9:	90                   	nop
  8030ca:	c9                   	leave  
  8030cb:	c3                   	ret    

008030cc <__udivdi3>:
  8030cc:	55                   	push   %ebp
  8030cd:	57                   	push   %edi
  8030ce:	56                   	push   %esi
  8030cf:	53                   	push   %ebx
  8030d0:	83 ec 1c             	sub    $0x1c,%esp
  8030d3:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  8030d7:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  8030db:	8b 7c 24 38          	mov    0x38(%esp),%edi
  8030df:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8030e3:	89 ca                	mov    %ecx,%edx
  8030e5:	89 f8                	mov    %edi,%eax
  8030e7:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  8030eb:	85 f6                	test   %esi,%esi
  8030ed:	75 2d                	jne    80311c <__udivdi3+0x50>
  8030ef:	39 cf                	cmp    %ecx,%edi
  8030f1:	77 65                	ja     803158 <__udivdi3+0x8c>
  8030f3:	89 fd                	mov    %edi,%ebp
  8030f5:	85 ff                	test   %edi,%edi
  8030f7:	75 0b                	jne    803104 <__udivdi3+0x38>
  8030f9:	b8 01 00 00 00       	mov    $0x1,%eax
  8030fe:	31 d2                	xor    %edx,%edx
  803100:	f7 f7                	div    %edi
  803102:	89 c5                	mov    %eax,%ebp
  803104:	31 d2                	xor    %edx,%edx
  803106:	89 c8                	mov    %ecx,%eax
  803108:	f7 f5                	div    %ebp
  80310a:	89 c1                	mov    %eax,%ecx
  80310c:	89 d8                	mov    %ebx,%eax
  80310e:	f7 f5                	div    %ebp
  803110:	89 cf                	mov    %ecx,%edi
  803112:	89 fa                	mov    %edi,%edx
  803114:	83 c4 1c             	add    $0x1c,%esp
  803117:	5b                   	pop    %ebx
  803118:	5e                   	pop    %esi
  803119:	5f                   	pop    %edi
  80311a:	5d                   	pop    %ebp
  80311b:	c3                   	ret    
  80311c:	39 ce                	cmp    %ecx,%esi
  80311e:	77 28                	ja     803148 <__udivdi3+0x7c>
  803120:	0f bd fe             	bsr    %esi,%edi
  803123:	83 f7 1f             	xor    $0x1f,%edi
  803126:	75 40                	jne    803168 <__udivdi3+0x9c>
  803128:	39 ce                	cmp    %ecx,%esi
  80312a:	72 0a                	jb     803136 <__udivdi3+0x6a>
  80312c:	3b 44 24 08          	cmp    0x8(%esp),%eax
  803130:	0f 87 9e 00 00 00    	ja     8031d4 <__udivdi3+0x108>
  803136:	b8 01 00 00 00       	mov    $0x1,%eax
  80313b:	89 fa                	mov    %edi,%edx
  80313d:	83 c4 1c             	add    $0x1c,%esp
  803140:	5b                   	pop    %ebx
  803141:	5e                   	pop    %esi
  803142:	5f                   	pop    %edi
  803143:	5d                   	pop    %ebp
  803144:	c3                   	ret    
  803145:	8d 76 00             	lea    0x0(%esi),%esi
  803148:	31 ff                	xor    %edi,%edi
  80314a:	31 c0                	xor    %eax,%eax
  80314c:	89 fa                	mov    %edi,%edx
  80314e:	83 c4 1c             	add    $0x1c,%esp
  803151:	5b                   	pop    %ebx
  803152:	5e                   	pop    %esi
  803153:	5f                   	pop    %edi
  803154:	5d                   	pop    %ebp
  803155:	c3                   	ret    
  803156:	66 90                	xchg   %ax,%ax
  803158:	89 d8                	mov    %ebx,%eax
  80315a:	f7 f7                	div    %edi
  80315c:	31 ff                	xor    %edi,%edi
  80315e:	89 fa                	mov    %edi,%edx
  803160:	83 c4 1c             	add    $0x1c,%esp
  803163:	5b                   	pop    %ebx
  803164:	5e                   	pop    %esi
  803165:	5f                   	pop    %edi
  803166:	5d                   	pop    %ebp
  803167:	c3                   	ret    
  803168:	bd 20 00 00 00       	mov    $0x20,%ebp
  80316d:	89 eb                	mov    %ebp,%ebx
  80316f:	29 fb                	sub    %edi,%ebx
  803171:	89 f9                	mov    %edi,%ecx
  803173:	d3 e6                	shl    %cl,%esi
  803175:	89 c5                	mov    %eax,%ebp
  803177:	88 d9                	mov    %bl,%cl
  803179:	d3 ed                	shr    %cl,%ebp
  80317b:	89 e9                	mov    %ebp,%ecx
  80317d:	09 f1                	or     %esi,%ecx
  80317f:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  803183:	89 f9                	mov    %edi,%ecx
  803185:	d3 e0                	shl    %cl,%eax
  803187:	89 c5                	mov    %eax,%ebp
  803189:	89 d6                	mov    %edx,%esi
  80318b:	88 d9                	mov    %bl,%cl
  80318d:	d3 ee                	shr    %cl,%esi
  80318f:	89 f9                	mov    %edi,%ecx
  803191:	d3 e2                	shl    %cl,%edx
  803193:	8b 44 24 08          	mov    0x8(%esp),%eax
  803197:	88 d9                	mov    %bl,%cl
  803199:	d3 e8                	shr    %cl,%eax
  80319b:	09 c2                	or     %eax,%edx
  80319d:	89 d0                	mov    %edx,%eax
  80319f:	89 f2                	mov    %esi,%edx
  8031a1:	f7 74 24 0c          	divl   0xc(%esp)
  8031a5:	89 d6                	mov    %edx,%esi
  8031a7:	89 c3                	mov    %eax,%ebx
  8031a9:	f7 e5                	mul    %ebp
  8031ab:	39 d6                	cmp    %edx,%esi
  8031ad:	72 19                	jb     8031c8 <__udivdi3+0xfc>
  8031af:	74 0b                	je     8031bc <__udivdi3+0xf0>
  8031b1:	89 d8                	mov    %ebx,%eax
  8031b3:	31 ff                	xor    %edi,%edi
  8031b5:	e9 58 ff ff ff       	jmp    803112 <__udivdi3+0x46>
  8031ba:	66 90                	xchg   %ax,%ax
  8031bc:	8b 54 24 08          	mov    0x8(%esp),%edx
  8031c0:	89 f9                	mov    %edi,%ecx
  8031c2:	d3 e2                	shl    %cl,%edx
  8031c4:	39 c2                	cmp    %eax,%edx
  8031c6:	73 e9                	jae    8031b1 <__udivdi3+0xe5>
  8031c8:	8d 43 ff             	lea    -0x1(%ebx),%eax
  8031cb:	31 ff                	xor    %edi,%edi
  8031cd:	e9 40 ff ff ff       	jmp    803112 <__udivdi3+0x46>
  8031d2:	66 90                	xchg   %ax,%ax
  8031d4:	31 c0                	xor    %eax,%eax
  8031d6:	e9 37 ff ff ff       	jmp    803112 <__udivdi3+0x46>
  8031db:	90                   	nop

008031dc <__umoddi3>:
  8031dc:	55                   	push   %ebp
  8031dd:	57                   	push   %edi
  8031de:	56                   	push   %esi
  8031df:	53                   	push   %ebx
  8031e0:	83 ec 1c             	sub    $0x1c,%esp
  8031e3:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  8031e7:	8b 74 24 34          	mov    0x34(%esp),%esi
  8031eb:	8b 7c 24 38          	mov    0x38(%esp),%edi
  8031ef:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  8031f3:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8031f7:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8031fb:	89 f3                	mov    %esi,%ebx
  8031fd:	89 fa                	mov    %edi,%edx
  8031ff:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  803203:	89 34 24             	mov    %esi,(%esp)
  803206:	85 c0                	test   %eax,%eax
  803208:	75 1a                	jne    803224 <__umoddi3+0x48>
  80320a:	39 f7                	cmp    %esi,%edi
  80320c:	0f 86 a2 00 00 00    	jbe    8032b4 <__umoddi3+0xd8>
  803212:	89 c8                	mov    %ecx,%eax
  803214:	89 f2                	mov    %esi,%edx
  803216:	f7 f7                	div    %edi
  803218:	89 d0                	mov    %edx,%eax
  80321a:	31 d2                	xor    %edx,%edx
  80321c:	83 c4 1c             	add    $0x1c,%esp
  80321f:	5b                   	pop    %ebx
  803220:	5e                   	pop    %esi
  803221:	5f                   	pop    %edi
  803222:	5d                   	pop    %ebp
  803223:	c3                   	ret    
  803224:	39 f0                	cmp    %esi,%eax
  803226:	0f 87 ac 00 00 00    	ja     8032d8 <__umoddi3+0xfc>
  80322c:	0f bd e8             	bsr    %eax,%ebp
  80322f:	83 f5 1f             	xor    $0x1f,%ebp
  803232:	0f 84 ac 00 00 00    	je     8032e4 <__umoddi3+0x108>
  803238:	bf 20 00 00 00       	mov    $0x20,%edi
  80323d:	29 ef                	sub    %ebp,%edi
  80323f:	89 fe                	mov    %edi,%esi
  803241:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  803245:	89 e9                	mov    %ebp,%ecx
  803247:	d3 e0                	shl    %cl,%eax
  803249:	89 d7                	mov    %edx,%edi
  80324b:	89 f1                	mov    %esi,%ecx
  80324d:	d3 ef                	shr    %cl,%edi
  80324f:	09 c7                	or     %eax,%edi
  803251:	89 e9                	mov    %ebp,%ecx
  803253:	d3 e2                	shl    %cl,%edx
  803255:	89 14 24             	mov    %edx,(%esp)
  803258:	89 d8                	mov    %ebx,%eax
  80325a:	d3 e0                	shl    %cl,%eax
  80325c:	89 c2                	mov    %eax,%edx
  80325e:	8b 44 24 08          	mov    0x8(%esp),%eax
  803262:	d3 e0                	shl    %cl,%eax
  803264:	89 44 24 04          	mov    %eax,0x4(%esp)
  803268:	8b 44 24 08          	mov    0x8(%esp),%eax
  80326c:	89 f1                	mov    %esi,%ecx
  80326e:	d3 e8                	shr    %cl,%eax
  803270:	09 d0                	or     %edx,%eax
  803272:	d3 eb                	shr    %cl,%ebx
  803274:	89 da                	mov    %ebx,%edx
  803276:	f7 f7                	div    %edi
  803278:	89 d3                	mov    %edx,%ebx
  80327a:	f7 24 24             	mull   (%esp)
  80327d:	89 c6                	mov    %eax,%esi
  80327f:	89 d1                	mov    %edx,%ecx
  803281:	39 d3                	cmp    %edx,%ebx
  803283:	0f 82 87 00 00 00    	jb     803310 <__umoddi3+0x134>
  803289:	0f 84 91 00 00 00    	je     803320 <__umoddi3+0x144>
  80328f:	8b 54 24 04          	mov    0x4(%esp),%edx
  803293:	29 f2                	sub    %esi,%edx
  803295:	19 cb                	sbb    %ecx,%ebx
  803297:	89 d8                	mov    %ebx,%eax
  803299:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  80329d:	d3 e0                	shl    %cl,%eax
  80329f:	89 e9                	mov    %ebp,%ecx
  8032a1:	d3 ea                	shr    %cl,%edx
  8032a3:	09 d0                	or     %edx,%eax
  8032a5:	89 e9                	mov    %ebp,%ecx
  8032a7:	d3 eb                	shr    %cl,%ebx
  8032a9:	89 da                	mov    %ebx,%edx
  8032ab:	83 c4 1c             	add    $0x1c,%esp
  8032ae:	5b                   	pop    %ebx
  8032af:	5e                   	pop    %esi
  8032b0:	5f                   	pop    %edi
  8032b1:	5d                   	pop    %ebp
  8032b2:	c3                   	ret    
  8032b3:	90                   	nop
  8032b4:	89 fd                	mov    %edi,%ebp
  8032b6:	85 ff                	test   %edi,%edi
  8032b8:	75 0b                	jne    8032c5 <__umoddi3+0xe9>
  8032ba:	b8 01 00 00 00       	mov    $0x1,%eax
  8032bf:	31 d2                	xor    %edx,%edx
  8032c1:	f7 f7                	div    %edi
  8032c3:	89 c5                	mov    %eax,%ebp
  8032c5:	89 f0                	mov    %esi,%eax
  8032c7:	31 d2                	xor    %edx,%edx
  8032c9:	f7 f5                	div    %ebp
  8032cb:	89 c8                	mov    %ecx,%eax
  8032cd:	f7 f5                	div    %ebp
  8032cf:	89 d0                	mov    %edx,%eax
  8032d1:	e9 44 ff ff ff       	jmp    80321a <__umoddi3+0x3e>
  8032d6:	66 90                	xchg   %ax,%ax
  8032d8:	89 c8                	mov    %ecx,%eax
  8032da:	89 f2                	mov    %esi,%edx
  8032dc:	83 c4 1c             	add    $0x1c,%esp
  8032df:	5b                   	pop    %ebx
  8032e0:	5e                   	pop    %esi
  8032e1:	5f                   	pop    %edi
  8032e2:	5d                   	pop    %ebp
  8032e3:	c3                   	ret    
  8032e4:	3b 04 24             	cmp    (%esp),%eax
  8032e7:	72 06                	jb     8032ef <__umoddi3+0x113>
  8032e9:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  8032ed:	77 0f                	ja     8032fe <__umoddi3+0x122>
  8032ef:	89 f2                	mov    %esi,%edx
  8032f1:	29 f9                	sub    %edi,%ecx
  8032f3:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  8032f7:	89 14 24             	mov    %edx,(%esp)
  8032fa:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8032fe:	8b 44 24 04          	mov    0x4(%esp),%eax
  803302:	8b 14 24             	mov    (%esp),%edx
  803305:	83 c4 1c             	add    $0x1c,%esp
  803308:	5b                   	pop    %ebx
  803309:	5e                   	pop    %esi
  80330a:	5f                   	pop    %edi
  80330b:	5d                   	pop    %ebp
  80330c:	c3                   	ret    
  80330d:	8d 76 00             	lea    0x0(%esi),%esi
  803310:	2b 04 24             	sub    (%esp),%eax
  803313:	19 fa                	sbb    %edi,%edx
  803315:	89 d1                	mov    %edx,%ecx
  803317:	89 c6                	mov    %eax,%esi
  803319:	e9 71 ff ff ff       	jmp    80328f <__umoddi3+0xb3>
  80331e:	66 90                	xchg   %ax,%ax
  803320:	39 44 24 04          	cmp    %eax,0x4(%esp)
  803324:	72 ea                	jb     803310 <__umoddi3+0x134>
  803326:	89 d9                	mov    %ebx,%ecx
  803328:	e9 62 ff ff ff       	jmp    80328f <__umoddi3+0xb3>
