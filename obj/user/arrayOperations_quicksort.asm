
obj/user/arrayOperations_quicksort:     file format elf32-i386


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
  800031:	e8 20 03 00 00       	call   800356 <libmain>
1:      jmp 1b
  800036:	eb fe                	jmp    800036 <args_exist+0x5>

00800038 <_main>:

void QuickSort(int *Elements, int NumOfElements);
void QSort(int *Elements,int NumOfElements, int startIndex, int finalIndex);

void _main(void)
{
  800038:	55                   	push   %ebp
  800039:	89 e5                	mov    %esp,%ebp
  80003b:	83 ec 28             	sub    $0x28,%esp
	int32 envID = sys_getenvid();
  80003e:	e8 88 1b 00 00       	call   801bcb <sys_getenvid>
  800043:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int32 parentenvID = sys_getparentenvid();
  800046:	e8 b2 1b 00 00       	call   801bfd <sys_getparentenvid>
  80004b:	89 45 ec             	mov    %eax,-0x14(%ebp)

	int ret;
	/*[1] GET SHARED VARs*/
	//Get the shared array & its size
	int *numOfElements = NULL;
  80004e:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
	int *sharedArray = NULL;
  800055:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	sharedArray = sget(parentenvID,"arr") ;
  80005c:	83 ec 08             	sub    $0x8,%esp
  80005f:	68 e0 32 80 00       	push   $0x8032e0
  800064:	ff 75 ec             	pushl  -0x14(%ebp)
  800067:	e8 84 16 00 00       	call   8016f0 <sget>
  80006c:	83 c4 10             	add    $0x10,%esp
  80006f:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	numOfElements = sget(parentenvID,"arrSize") ;
  800072:	83 ec 08             	sub    $0x8,%esp
  800075:	68 e4 32 80 00       	push   $0x8032e4
  80007a:	ff 75 ec             	pushl  -0x14(%ebp)
  80007d:	e8 6e 16 00 00       	call   8016f0 <sget>
  800082:	83 c4 10             	add    $0x10,%esp
  800085:	89 45 e8             	mov    %eax,-0x18(%ebp)

	//Get the check-finishing counter
	int *finishedCount = NULL;
  800088:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
	finishedCount = sget(parentenvID,"finishedCount") ;
  80008f:	83 ec 08             	sub    $0x8,%esp
  800092:	68 ec 32 80 00       	push   $0x8032ec
  800097:	ff 75 ec             	pushl  -0x14(%ebp)
  80009a:	e8 51 16 00 00       	call   8016f0 <sget>
  80009f:	83 c4 10             	add    $0x10,%esp
  8000a2:	89 45 e0             	mov    %eax,-0x20(%ebp)

	/*[2] DO THE JOB*/
	//take a copy from the original array
	int *sortedArray;
	sortedArray = smalloc("quicksortedArr", sizeof(int) * *numOfElements, 0) ;
  8000a5:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8000a8:	8b 00                	mov    (%eax),%eax
  8000aa:	c1 e0 02             	shl    $0x2,%eax
  8000ad:	83 ec 04             	sub    $0x4,%esp
  8000b0:	6a 00                	push   $0x0
  8000b2:	50                   	push   %eax
  8000b3:	68 fa 32 80 00       	push   $0x8032fa
  8000b8:	e8 83 15 00 00       	call   801640 <smalloc>
  8000bd:	83 c4 10             	add    $0x10,%esp
  8000c0:	89 45 dc             	mov    %eax,-0x24(%ebp)
	int i ;
	for (i = 0 ; i < *numOfElements ; i++)
  8000c3:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  8000ca:	eb 25                	jmp    8000f1 <_main+0xb9>
	{
		sortedArray[i] = sharedArray[i];
  8000cc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8000cf:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8000d6:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8000d9:	01 c2                	add    %eax,%edx
  8000db:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8000de:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  8000e5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8000e8:	01 c8                	add    %ecx,%eax
  8000ea:	8b 00                	mov    (%eax),%eax
  8000ec:	89 02                	mov    %eax,(%edx)
	/*[2] DO THE JOB*/
	//take a copy from the original array
	int *sortedArray;
	sortedArray = smalloc("quicksortedArr", sizeof(int) * *numOfElements, 0) ;
	int i ;
	for (i = 0 ; i < *numOfElements ; i++)
  8000ee:	ff 45 f4             	incl   -0xc(%ebp)
  8000f1:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8000f4:	8b 00                	mov    (%eax),%eax
  8000f6:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  8000f9:	7f d1                	jg     8000cc <_main+0x94>
	{
		sortedArray[i] = sharedArray[i];
	}
	QuickSort(sortedArray, *numOfElements);
  8000fb:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8000fe:	8b 00                	mov    (%eax),%eax
  800100:	83 ec 08             	sub    $0x8,%esp
  800103:	50                   	push   %eax
  800104:	ff 75 dc             	pushl  -0x24(%ebp)
  800107:	e8 23 00 00 00       	call   80012f <QuickSort>
  80010c:	83 c4 10             	add    $0x10,%esp
	cprintf("Quick sort is Finished!!!!\n") ;
  80010f:	83 ec 0c             	sub    $0xc,%esp
  800112:	68 09 33 80 00       	push   $0x803309
  800117:	e8 4a 04 00 00       	call   800566 <cprintf>
  80011c:	83 c4 10             	add    $0x10,%esp

	/*[3] SHARE THE RESULTS & DECLARE FINISHING*/
	(*finishedCount)++ ;
  80011f:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800122:	8b 00                	mov    (%eax),%eax
  800124:	8d 50 01             	lea    0x1(%eax),%edx
  800127:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80012a:	89 10                	mov    %edx,(%eax)

}
  80012c:	90                   	nop
  80012d:	c9                   	leave  
  80012e:	c3                   	ret    

0080012f <QuickSort>:

///Quick sort
void QuickSort(int *Elements, int NumOfElements)
{
  80012f:	55                   	push   %ebp
  800130:	89 e5                	mov    %esp,%ebp
  800132:	83 ec 08             	sub    $0x8,%esp
	QSort(Elements, NumOfElements, 0, NumOfElements-1) ;
  800135:	8b 45 0c             	mov    0xc(%ebp),%eax
  800138:	48                   	dec    %eax
  800139:	50                   	push   %eax
  80013a:	6a 00                	push   $0x0
  80013c:	ff 75 0c             	pushl  0xc(%ebp)
  80013f:	ff 75 08             	pushl  0x8(%ebp)
  800142:	e8 06 00 00 00       	call   80014d <QSort>
  800147:	83 c4 10             	add    $0x10,%esp
}
  80014a:	90                   	nop
  80014b:	c9                   	leave  
  80014c:	c3                   	ret    

0080014d <QSort>:


void QSort(int *Elements,int NumOfElements, int startIndex, int finalIndex)
{
  80014d:	55                   	push   %ebp
  80014e:	89 e5                	mov    %esp,%ebp
  800150:	83 ec 28             	sub    $0x28,%esp
	if (startIndex >= finalIndex) return;
  800153:	8b 45 10             	mov    0x10(%ebp),%eax
  800156:	3b 45 14             	cmp    0x14(%ebp),%eax
  800159:	0f 8d 1b 01 00 00    	jge    80027a <QSort+0x12d>
	int pvtIndex = RAND(startIndex, finalIndex) ;
  80015f:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  800162:	83 ec 0c             	sub    $0xc,%esp
  800165:	50                   	push   %eax
  800166:	e8 c5 1a 00 00       	call   801c30 <sys_get_virtual_time>
  80016b:	83 c4 0c             	add    $0xc,%esp
  80016e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800171:	8b 55 14             	mov    0x14(%ebp),%edx
  800174:	2b 55 10             	sub    0x10(%ebp),%edx
  800177:	89 d1                	mov    %edx,%ecx
  800179:	ba 00 00 00 00       	mov    $0x0,%edx
  80017e:	f7 f1                	div    %ecx
  800180:	8b 45 10             	mov    0x10(%ebp),%eax
  800183:	01 d0                	add    %edx,%eax
  800185:	89 45 ec             	mov    %eax,-0x14(%ebp)
	Swap(Elements, startIndex, pvtIndex);
  800188:	83 ec 04             	sub    $0x4,%esp
  80018b:	ff 75 ec             	pushl  -0x14(%ebp)
  80018e:	ff 75 10             	pushl  0x10(%ebp)
  800191:	ff 75 08             	pushl  0x8(%ebp)
  800194:	e8 e4 00 00 00       	call   80027d <Swap>
  800199:	83 c4 10             	add    $0x10,%esp

	int i = startIndex+1, j = finalIndex;
  80019c:	8b 45 10             	mov    0x10(%ebp),%eax
  80019f:	40                   	inc    %eax
  8001a0:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8001a3:	8b 45 14             	mov    0x14(%ebp),%eax
  8001a6:	89 45 f0             	mov    %eax,-0x10(%ebp)

	while (i <= j)
  8001a9:	e9 80 00 00 00       	jmp    80022e <QSort+0xe1>
	{
		while (i <= finalIndex && Elements[startIndex] >= Elements[i]) i++;
  8001ae:	ff 45 f4             	incl   -0xc(%ebp)
  8001b1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8001b4:	3b 45 14             	cmp    0x14(%ebp),%eax
  8001b7:	7f 2b                	jg     8001e4 <QSort+0x97>
  8001b9:	8b 45 10             	mov    0x10(%ebp),%eax
  8001bc:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8001c3:	8b 45 08             	mov    0x8(%ebp),%eax
  8001c6:	01 d0                	add    %edx,%eax
  8001c8:	8b 10                	mov    (%eax),%edx
  8001ca:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8001cd:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  8001d4:	8b 45 08             	mov    0x8(%ebp),%eax
  8001d7:	01 c8                	add    %ecx,%eax
  8001d9:	8b 00                	mov    (%eax),%eax
  8001db:	39 c2                	cmp    %eax,%edx
  8001dd:	7d cf                	jge    8001ae <QSort+0x61>
		while (j > startIndex && Elements[startIndex] <= Elements[j]) j--;
  8001df:	eb 03                	jmp    8001e4 <QSort+0x97>
  8001e1:	ff 4d f0             	decl   -0x10(%ebp)
  8001e4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8001e7:	3b 45 10             	cmp    0x10(%ebp),%eax
  8001ea:	7e 26                	jle    800212 <QSort+0xc5>
  8001ec:	8b 45 10             	mov    0x10(%ebp),%eax
  8001ef:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8001f6:	8b 45 08             	mov    0x8(%ebp),%eax
  8001f9:	01 d0                	add    %edx,%eax
  8001fb:	8b 10                	mov    (%eax),%edx
  8001fd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800200:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  800207:	8b 45 08             	mov    0x8(%ebp),%eax
  80020a:	01 c8                	add    %ecx,%eax
  80020c:	8b 00                	mov    (%eax),%eax
  80020e:	39 c2                	cmp    %eax,%edx
  800210:	7e cf                	jle    8001e1 <QSort+0x94>

		if (i <= j)
  800212:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800215:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800218:	7f 14                	jg     80022e <QSort+0xe1>
		{
			Swap(Elements, i, j);
  80021a:	83 ec 04             	sub    $0x4,%esp
  80021d:	ff 75 f0             	pushl  -0x10(%ebp)
  800220:	ff 75 f4             	pushl  -0xc(%ebp)
  800223:	ff 75 08             	pushl  0x8(%ebp)
  800226:	e8 52 00 00 00       	call   80027d <Swap>
  80022b:	83 c4 10             	add    $0x10,%esp
	int pvtIndex = RAND(startIndex, finalIndex) ;
	Swap(Elements, startIndex, pvtIndex);

	int i = startIndex+1, j = finalIndex;

	while (i <= j)
  80022e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800231:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800234:	0f 8e 77 ff ff ff    	jle    8001b1 <QSort+0x64>
		{
			Swap(Elements, i, j);
		}
	}

	Swap( Elements, startIndex, j);
  80023a:	83 ec 04             	sub    $0x4,%esp
  80023d:	ff 75 f0             	pushl  -0x10(%ebp)
  800240:	ff 75 10             	pushl  0x10(%ebp)
  800243:	ff 75 08             	pushl  0x8(%ebp)
  800246:	e8 32 00 00 00       	call   80027d <Swap>
  80024b:	83 c4 10             	add    $0x10,%esp

	QSort(Elements, NumOfElements, startIndex, j - 1);
  80024e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800251:	48                   	dec    %eax
  800252:	50                   	push   %eax
  800253:	ff 75 10             	pushl  0x10(%ebp)
  800256:	ff 75 0c             	pushl  0xc(%ebp)
  800259:	ff 75 08             	pushl  0x8(%ebp)
  80025c:	e8 ec fe ff ff       	call   80014d <QSort>
  800261:	83 c4 10             	add    $0x10,%esp
	QSort(Elements, NumOfElements, i, finalIndex);
  800264:	ff 75 14             	pushl  0x14(%ebp)
  800267:	ff 75 f4             	pushl  -0xc(%ebp)
  80026a:	ff 75 0c             	pushl  0xc(%ebp)
  80026d:	ff 75 08             	pushl  0x8(%ebp)
  800270:	e8 d8 fe ff ff       	call   80014d <QSort>
  800275:	83 c4 10             	add    $0x10,%esp
  800278:	eb 01                	jmp    80027b <QSort+0x12e>
}


void QSort(int *Elements,int NumOfElements, int startIndex, int finalIndex)
{
	if (startIndex >= finalIndex) return;
  80027a:	90                   	nop
	QSort(Elements, NumOfElements, startIndex, j - 1);
	QSort(Elements, NumOfElements, i, finalIndex);

	//cprintf("qs,after sorting: start = %d, end = %d\n", startIndex, finalIndex);

}
  80027b:	c9                   	leave  
  80027c:	c3                   	ret    

0080027d <Swap>:

///Private Functions


void Swap(int *Elements, int First, int Second)
{
  80027d:	55                   	push   %ebp
  80027e:	89 e5                	mov    %esp,%ebp
  800280:	83 ec 10             	sub    $0x10,%esp
	int Tmp = Elements[First] ;
  800283:	8b 45 0c             	mov    0xc(%ebp),%eax
  800286:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80028d:	8b 45 08             	mov    0x8(%ebp),%eax
  800290:	01 d0                	add    %edx,%eax
  800292:	8b 00                	mov    (%eax),%eax
  800294:	89 45 fc             	mov    %eax,-0x4(%ebp)
	Elements[First] = Elements[Second] ;
  800297:	8b 45 0c             	mov    0xc(%ebp),%eax
  80029a:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8002a1:	8b 45 08             	mov    0x8(%ebp),%eax
  8002a4:	01 c2                	add    %eax,%edx
  8002a6:	8b 45 10             	mov    0x10(%ebp),%eax
  8002a9:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  8002b0:	8b 45 08             	mov    0x8(%ebp),%eax
  8002b3:	01 c8                	add    %ecx,%eax
  8002b5:	8b 00                	mov    (%eax),%eax
  8002b7:	89 02                	mov    %eax,(%edx)
	Elements[Second] = Tmp ;
  8002b9:	8b 45 10             	mov    0x10(%ebp),%eax
  8002bc:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8002c3:	8b 45 08             	mov    0x8(%ebp),%eax
  8002c6:	01 c2                	add    %eax,%edx
  8002c8:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8002cb:	89 02                	mov    %eax,(%edx)
}
  8002cd:	90                   	nop
  8002ce:	c9                   	leave  
  8002cf:	c3                   	ret    

008002d0 <PrintElements>:


void PrintElements(int *Elements, int NumOfElements)
{
  8002d0:	55                   	push   %ebp
  8002d1:	89 e5                	mov    %esp,%ebp
  8002d3:	83 ec 18             	sub    $0x18,%esp
	int i ;
	int NumsPerLine = 20 ;
  8002d6:	c7 45 f0 14 00 00 00 	movl   $0x14,-0x10(%ebp)
	for (i = 0 ; i < NumOfElements-1 ; i++)
  8002dd:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  8002e4:	eb 42                	jmp    800328 <PrintElements+0x58>
	{
		if (i%NumsPerLine == 0)
  8002e6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8002e9:	99                   	cltd   
  8002ea:	f7 7d f0             	idivl  -0x10(%ebp)
  8002ed:	89 d0                	mov    %edx,%eax
  8002ef:	85 c0                	test   %eax,%eax
  8002f1:	75 10                	jne    800303 <PrintElements+0x33>
			cprintf("\n");
  8002f3:	83 ec 0c             	sub    $0xc,%esp
  8002f6:	68 25 33 80 00       	push   $0x803325
  8002fb:	e8 66 02 00 00       	call   800566 <cprintf>
  800300:	83 c4 10             	add    $0x10,%esp
		cprintf("%d, ",Elements[i]);
  800303:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800306:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80030d:	8b 45 08             	mov    0x8(%ebp),%eax
  800310:	01 d0                	add    %edx,%eax
  800312:	8b 00                	mov    (%eax),%eax
  800314:	83 ec 08             	sub    $0x8,%esp
  800317:	50                   	push   %eax
  800318:	68 27 33 80 00       	push   $0x803327
  80031d:	e8 44 02 00 00       	call   800566 <cprintf>
  800322:	83 c4 10             	add    $0x10,%esp

void PrintElements(int *Elements, int NumOfElements)
{
	int i ;
	int NumsPerLine = 20 ;
	for (i = 0 ; i < NumOfElements-1 ; i++)
  800325:	ff 45 f4             	incl   -0xc(%ebp)
  800328:	8b 45 0c             	mov    0xc(%ebp),%eax
  80032b:	48                   	dec    %eax
  80032c:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  80032f:	7f b5                	jg     8002e6 <PrintElements+0x16>
	{
		if (i%NumsPerLine == 0)
			cprintf("\n");
		cprintf("%d, ",Elements[i]);
	}
	cprintf("%d\n",Elements[i]);
  800331:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800334:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80033b:	8b 45 08             	mov    0x8(%ebp),%eax
  80033e:	01 d0                	add    %edx,%eax
  800340:	8b 00                	mov    (%eax),%eax
  800342:	83 ec 08             	sub    $0x8,%esp
  800345:	50                   	push   %eax
  800346:	68 2c 33 80 00       	push   $0x80332c
  80034b:	e8 16 02 00 00       	call   800566 <cprintf>
  800350:	83 c4 10             	add    $0x10,%esp

}
  800353:	90                   	nop
  800354:	c9                   	leave  
  800355:	c3                   	ret    

00800356 <libmain>:
volatile struct Env *myEnv = NULL;
volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";

void
libmain(int argc, char **argv)
{
  800356:	55                   	push   %ebp
  800357:	89 e5                	mov    %esp,%ebp
  800359:	83 ec 18             	sub    $0x18,%esp
	int envIndex = sys_getenvindex();
  80035c:	e8 83 18 00 00       	call   801be4 <sys_getenvindex>
  800361:	89 45 f4             	mov    %eax,-0xc(%ebp)
	myEnv = &(envs[envIndex]);
  800364:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800367:	89 d0                	mov    %edx,%eax
  800369:	c1 e0 03             	shl    $0x3,%eax
  80036c:	01 d0                	add    %edx,%eax
  80036e:	01 c0                	add    %eax,%eax
  800370:	01 d0                	add    %edx,%eax
  800372:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800379:	01 d0                	add    %edx,%eax
  80037b:	c1 e0 04             	shl    $0x4,%eax
  80037e:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  800383:	a3 20 40 80 00       	mov    %eax,0x804020

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  800388:	a1 20 40 80 00       	mov    0x804020,%eax
  80038d:	8a 80 5c 05 00 00    	mov    0x55c(%eax),%al
  800393:	84 c0                	test   %al,%al
  800395:	74 0f                	je     8003a6 <libmain+0x50>
		binaryname = myEnv->prog_name;
  800397:	a1 20 40 80 00       	mov    0x804020,%eax
  80039c:	05 5c 05 00 00       	add    $0x55c,%eax
  8003a1:	a3 00 40 80 00       	mov    %eax,0x804000

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8003a6:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8003aa:	7e 0a                	jle    8003b6 <libmain+0x60>
		binaryname = argv[0];
  8003ac:	8b 45 0c             	mov    0xc(%ebp),%eax
  8003af:	8b 00                	mov    (%eax),%eax
  8003b1:	a3 00 40 80 00       	mov    %eax,0x804000

	// call user main routine
	_main(argc, argv);
  8003b6:	83 ec 08             	sub    $0x8,%esp
  8003b9:	ff 75 0c             	pushl  0xc(%ebp)
  8003bc:	ff 75 08             	pushl  0x8(%ebp)
  8003bf:	e8 74 fc ff ff       	call   800038 <_main>
  8003c4:	83 c4 10             	add    $0x10,%esp



	sys_disable_interrupt();
  8003c7:	e8 25 16 00 00       	call   8019f1 <sys_disable_interrupt>
	cprintf("**************************************\n");
  8003cc:	83 ec 0c             	sub    $0xc,%esp
  8003cf:	68 48 33 80 00       	push   $0x803348
  8003d4:	e8 8d 01 00 00       	call   800566 <cprintf>
  8003d9:	83 c4 10             	add    $0x10,%esp
	cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  8003dc:	a1 20 40 80 00       	mov    0x804020,%eax
  8003e1:	8b 90 44 05 00 00    	mov    0x544(%eax),%edx
  8003e7:	a1 20 40 80 00       	mov    0x804020,%eax
  8003ec:	8b 80 34 05 00 00    	mov    0x534(%eax),%eax
  8003f2:	83 ec 04             	sub    $0x4,%esp
  8003f5:	52                   	push   %edx
  8003f6:	50                   	push   %eax
  8003f7:	68 70 33 80 00       	push   $0x803370
  8003fc:	e8 65 01 00 00       	call   800566 <cprintf>
  800401:	83 c4 10             	add    $0x10,%esp
	cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  800404:	a1 20 40 80 00       	mov    0x804020,%eax
  800409:	8b 88 54 05 00 00    	mov    0x554(%eax),%ecx
  80040f:	a1 20 40 80 00       	mov    0x804020,%eax
  800414:	8b 90 50 05 00 00    	mov    0x550(%eax),%edx
  80041a:	a1 20 40 80 00       	mov    0x804020,%eax
  80041f:	8b 80 4c 05 00 00    	mov    0x54c(%eax),%eax
  800425:	51                   	push   %ecx
  800426:	52                   	push   %edx
  800427:	50                   	push   %eax
  800428:	68 98 33 80 00       	push   $0x803398
  80042d:	e8 34 01 00 00       	call   800566 <cprintf>
  800432:	83 c4 10             	add    $0x10,%esp
	//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
	cprintf("Num of clocks = %d\n", myEnv->nClocks);
  800435:	a1 20 40 80 00       	mov    0x804020,%eax
  80043a:	8b 80 a4 05 00 00    	mov    0x5a4(%eax),%eax
  800440:	83 ec 08             	sub    $0x8,%esp
  800443:	50                   	push   %eax
  800444:	68 f0 33 80 00       	push   $0x8033f0
  800449:	e8 18 01 00 00       	call   800566 <cprintf>
  80044e:	83 c4 10             	add    $0x10,%esp
	cprintf("**************************************\n");
  800451:	83 ec 0c             	sub    $0xc,%esp
  800454:	68 48 33 80 00       	push   $0x803348
  800459:	e8 08 01 00 00       	call   800566 <cprintf>
  80045e:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  800461:	e8 a5 15 00 00       	call   801a0b <sys_enable_interrupt>

	// exit gracefully
	exit();
  800466:	e8 19 00 00 00       	call   800484 <exit>
}
  80046b:	90                   	nop
  80046c:	c9                   	leave  
  80046d:	c3                   	ret    

0080046e <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  80046e:	55                   	push   %ebp
  80046f:	89 e5                	mov    %esp,%ebp
  800471:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  800474:	83 ec 0c             	sub    $0xc,%esp
  800477:	6a 00                	push   $0x0
  800479:	e8 32 17 00 00       	call   801bb0 <sys_destroy_env>
  80047e:	83 c4 10             	add    $0x10,%esp
}
  800481:	90                   	nop
  800482:	c9                   	leave  
  800483:	c3                   	ret    

00800484 <exit>:

void
exit(void)
{
  800484:	55                   	push   %ebp
  800485:	89 e5                	mov    %esp,%ebp
  800487:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  80048a:	e8 87 17 00 00       	call   801c16 <sys_exit_env>
}
  80048f:	90                   	nop
  800490:	c9                   	leave  
  800491:	c3                   	ret    

00800492 <putch>:
};

//2017:
uint8 printProgName = 0;

static void putch(int ch, struct printbuf *b) {
  800492:	55                   	push   %ebp
  800493:	89 e5                	mov    %esp,%ebp
  800495:	83 ec 08             	sub    $0x8,%esp
	b->buf[b->idx++] = ch;
  800498:	8b 45 0c             	mov    0xc(%ebp),%eax
  80049b:	8b 00                	mov    (%eax),%eax
  80049d:	8d 48 01             	lea    0x1(%eax),%ecx
  8004a0:	8b 55 0c             	mov    0xc(%ebp),%edx
  8004a3:	89 0a                	mov    %ecx,(%edx)
  8004a5:	8b 55 08             	mov    0x8(%ebp),%edx
  8004a8:	88 d1                	mov    %dl,%cl
  8004aa:	8b 55 0c             	mov    0xc(%ebp),%edx
  8004ad:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  8004b1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8004b4:	8b 00                	mov    (%eax),%eax
  8004b6:	3d ff 00 00 00       	cmp    $0xff,%eax
  8004bb:	75 2c                	jne    8004e9 <putch+0x57>
		sys_cputs(b->buf, b->idx, printProgName);
  8004bd:	a0 24 40 80 00       	mov    0x804024,%al
  8004c2:	0f b6 c0             	movzbl %al,%eax
  8004c5:	8b 55 0c             	mov    0xc(%ebp),%edx
  8004c8:	8b 12                	mov    (%edx),%edx
  8004ca:	89 d1                	mov    %edx,%ecx
  8004cc:	8b 55 0c             	mov    0xc(%ebp),%edx
  8004cf:	83 c2 08             	add    $0x8,%edx
  8004d2:	83 ec 04             	sub    $0x4,%esp
  8004d5:	50                   	push   %eax
  8004d6:	51                   	push   %ecx
  8004d7:	52                   	push   %edx
  8004d8:	e8 66 13 00 00       	call   801843 <sys_cputs>
  8004dd:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  8004e0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8004e3:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  8004e9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8004ec:	8b 40 04             	mov    0x4(%eax),%eax
  8004ef:	8d 50 01             	lea    0x1(%eax),%edx
  8004f2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8004f5:	89 50 04             	mov    %edx,0x4(%eax)
}
  8004f8:	90                   	nop
  8004f9:	c9                   	leave  
  8004fa:	c3                   	ret    

008004fb <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  8004fb:	55                   	push   %ebp
  8004fc:	89 e5                	mov    %esp,%ebp
  8004fe:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  800504:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  80050b:	00 00 00 
	b.cnt = 0;
  80050e:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800515:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  800518:	ff 75 0c             	pushl  0xc(%ebp)
  80051b:	ff 75 08             	pushl  0x8(%ebp)
  80051e:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800524:	50                   	push   %eax
  800525:	68 92 04 80 00       	push   $0x800492
  80052a:	e8 11 02 00 00       	call   800740 <vprintfmt>
  80052f:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName);
  800532:	a0 24 40 80 00       	mov    0x804024,%al
  800537:	0f b6 c0             	movzbl %al,%eax
  80053a:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  800540:	83 ec 04             	sub    $0x4,%esp
  800543:	50                   	push   %eax
  800544:	52                   	push   %edx
  800545:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  80054b:	83 c0 08             	add    $0x8,%eax
  80054e:	50                   	push   %eax
  80054f:	e8 ef 12 00 00       	call   801843 <sys_cputs>
  800554:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  800557:	c6 05 24 40 80 00 00 	movb   $0x0,0x804024
	return b.cnt;
  80055e:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  800564:	c9                   	leave  
  800565:	c3                   	ret    

00800566 <cprintf>:

int cprintf(const char *fmt, ...) {
  800566:	55                   	push   %ebp
  800567:	89 e5                	mov    %esp,%ebp
  800569:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  80056c:	c6 05 24 40 80 00 01 	movb   $0x1,0x804024
	va_start(ap, fmt);
  800573:	8d 45 0c             	lea    0xc(%ebp),%eax
  800576:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800579:	8b 45 08             	mov    0x8(%ebp),%eax
  80057c:	83 ec 08             	sub    $0x8,%esp
  80057f:	ff 75 f4             	pushl  -0xc(%ebp)
  800582:	50                   	push   %eax
  800583:	e8 73 ff ff ff       	call   8004fb <vcprintf>
  800588:	83 c4 10             	add    $0x10,%esp
  80058b:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  80058e:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800591:	c9                   	leave  
  800592:	c3                   	ret    

00800593 <atomic_cprintf>:

int atomic_cprintf(const char *fmt, ...) {
  800593:	55                   	push   %ebp
  800594:	89 e5                	mov    %esp,%ebp
  800596:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  800599:	e8 53 14 00 00       	call   8019f1 <sys_disable_interrupt>
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  80059e:	8d 45 0c             	lea    0xc(%ebp),%eax
  8005a1:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  8005a4:	8b 45 08             	mov    0x8(%ebp),%eax
  8005a7:	83 ec 08             	sub    $0x8,%esp
  8005aa:	ff 75 f4             	pushl  -0xc(%ebp)
  8005ad:	50                   	push   %eax
  8005ae:	e8 48 ff ff ff       	call   8004fb <vcprintf>
  8005b3:	83 c4 10             	add    $0x10,%esp
  8005b6:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	sys_enable_interrupt();
  8005b9:	e8 4d 14 00 00       	call   801a0b <sys_enable_interrupt>
	return cnt;
  8005be:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8005c1:	c9                   	leave  
  8005c2:	c3                   	ret    

008005c3 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8005c3:	55                   	push   %ebp
  8005c4:	89 e5                	mov    %esp,%ebp
  8005c6:	53                   	push   %ebx
  8005c7:	83 ec 14             	sub    $0x14,%esp
  8005ca:	8b 45 10             	mov    0x10(%ebp),%eax
  8005cd:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8005d0:	8b 45 14             	mov    0x14(%ebp),%eax
  8005d3:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  8005d6:	8b 45 18             	mov    0x18(%ebp),%eax
  8005d9:	ba 00 00 00 00       	mov    $0x0,%edx
  8005de:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  8005e1:	77 55                	ja     800638 <printnum+0x75>
  8005e3:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  8005e6:	72 05                	jb     8005ed <printnum+0x2a>
  8005e8:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8005eb:	77 4b                	ja     800638 <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  8005ed:	8b 45 1c             	mov    0x1c(%ebp),%eax
  8005f0:	8d 58 ff             	lea    -0x1(%eax),%ebx
  8005f3:	8b 45 18             	mov    0x18(%ebp),%eax
  8005f6:	ba 00 00 00 00       	mov    $0x0,%edx
  8005fb:	52                   	push   %edx
  8005fc:	50                   	push   %eax
  8005fd:	ff 75 f4             	pushl  -0xc(%ebp)
  800600:	ff 75 f0             	pushl  -0x10(%ebp)
  800603:	e8 64 2a 00 00       	call   80306c <__udivdi3>
  800608:	83 c4 10             	add    $0x10,%esp
  80060b:	83 ec 04             	sub    $0x4,%esp
  80060e:	ff 75 20             	pushl  0x20(%ebp)
  800611:	53                   	push   %ebx
  800612:	ff 75 18             	pushl  0x18(%ebp)
  800615:	52                   	push   %edx
  800616:	50                   	push   %eax
  800617:	ff 75 0c             	pushl  0xc(%ebp)
  80061a:	ff 75 08             	pushl  0x8(%ebp)
  80061d:	e8 a1 ff ff ff       	call   8005c3 <printnum>
  800622:	83 c4 20             	add    $0x20,%esp
  800625:	eb 1a                	jmp    800641 <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800627:	83 ec 08             	sub    $0x8,%esp
  80062a:	ff 75 0c             	pushl  0xc(%ebp)
  80062d:	ff 75 20             	pushl  0x20(%ebp)
  800630:	8b 45 08             	mov    0x8(%ebp),%eax
  800633:	ff d0                	call   *%eax
  800635:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800638:	ff 4d 1c             	decl   0x1c(%ebp)
  80063b:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  80063f:	7f e6                	jg     800627 <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800641:	8b 4d 18             	mov    0x18(%ebp),%ecx
  800644:	bb 00 00 00 00       	mov    $0x0,%ebx
  800649:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80064c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80064f:	53                   	push   %ebx
  800650:	51                   	push   %ecx
  800651:	52                   	push   %edx
  800652:	50                   	push   %eax
  800653:	e8 24 2b 00 00       	call   80317c <__umoddi3>
  800658:	83 c4 10             	add    $0x10,%esp
  80065b:	05 34 36 80 00       	add    $0x803634,%eax
  800660:	8a 00                	mov    (%eax),%al
  800662:	0f be c0             	movsbl %al,%eax
  800665:	83 ec 08             	sub    $0x8,%esp
  800668:	ff 75 0c             	pushl  0xc(%ebp)
  80066b:	50                   	push   %eax
  80066c:	8b 45 08             	mov    0x8(%ebp),%eax
  80066f:	ff d0                	call   *%eax
  800671:	83 c4 10             	add    $0x10,%esp
}
  800674:	90                   	nop
  800675:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800678:	c9                   	leave  
  800679:	c3                   	ret    

0080067a <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  80067a:	55                   	push   %ebp
  80067b:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  80067d:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800681:	7e 1c                	jle    80069f <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  800683:	8b 45 08             	mov    0x8(%ebp),%eax
  800686:	8b 00                	mov    (%eax),%eax
  800688:	8d 50 08             	lea    0x8(%eax),%edx
  80068b:	8b 45 08             	mov    0x8(%ebp),%eax
  80068e:	89 10                	mov    %edx,(%eax)
  800690:	8b 45 08             	mov    0x8(%ebp),%eax
  800693:	8b 00                	mov    (%eax),%eax
  800695:	83 e8 08             	sub    $0x8,%eax
  800698:	8b 50 04             	mov    0x4(%eax),%edx
  80069b:	8b 00                	mov    (%eax),%eax
  80069d:	eb 40                	jmp    8006df <getuint+0x65>
	else if (lflag)
  80069f:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8006a3:	74 1e                	je     8006c3 <getuint+0x49>
		return va_arg(*ap, unsigned long);
  8006a5:	8b 45 08             	mov    0x8(%ebp),%eax
  8006a8:	8b 00                	mov    (%eax),%eax
  8006aa:	8d 50 04             	lea    0x4(%eax),%edx
  8006ad:	8b 45 08             	mov    0x8(%ebp),%eax
  8006b0:	89 10                	mov    %edx,(%eax)
  8006b2:	8b 45 08             	mov    0x8(%ebp),%eax
  8006b5:	8b 00                	mov    (%eax),%eax
  8006b7:	83 e8 04             	sub    $0x4,%eax
  8006ba:	8b 00                	mov    (%eax),%eax
  8006bc:	ba 00 00 00 00       	mov    $0x0,%edx
  8006c1:	eb 1c                	jmp    8006df <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  8006c3:	8b 45 08             	mov    0x8(%ebp),%eax
  8006c6:	8b 00                	mov    (%eax),%eax
  8006c8:	8d 50 04             	lea    0x4(%eax),%edx
  8006cb:	8b 45 08             	mov    0x8(%ebp),%eax
  8006ce:	89 10                	mov    %edx,(%eax)
  8006d0:	8b 45 08             	mov    0x8(%ebp),%eax
  8006d3:	8b 00                	mov    (%eax),%eax
  8006d5:	83 e8 04             	sub    $0x4,%eax
  8006d8:	8b 00                	mov    (%eax),%eax
  8006da:	ba 00 00 00 00       	mov    $0x0,%edx
}
  8006df:	5d                   	pop    %ebp
  8006e0:	c3                   	ret    

008006e1 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  8006e1:	55                   	push   %ebp
  8006e2:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  8006e4:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  8006e8:	7e 1c                	jle    800706 <getint+0x25>
		return va_arg(*ap, long long);
  8006ea:	8b 45 08             	mov    0x8(%ebp),%eax
  8006ed:	8b 00                	mov    (%eax),%eax
  8006ef:	8d 50 08             	lea    0x8(%eax),%edx
  8006f2:	8b 45 08             	mov    0x8(%ebp),%eax
  8006f5:	89 10                	mov    %edx,(%eax)
  8006f7:	8b 45 08             	mov    0x8(%ebp),%eax
  8006fa:	8b 00                	mov    (%eax),%eax
  8006fc:	83 e8 08             	sub    $0x8,%eax
  8006ff:	8b 50 04             	mov    0x4(%eax),%edx
  800702:	8b 00                	mov    (%eax),%eax
  800704:	eb 38                	jmp    80073e <getint+0x5d>
	else if (lflag)
  800706:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80070a:	74 1a                	je     800726 <getint+0x45>
		return va_arg(*ap, long);
  80070c:	8b 45 08             	mov    0x8(%ebp),%eax
  80070f:	8b 00                	mov    (%eax),%eax
  800711:	8d 50 04             	lea    0x4(%eax),%edx
  800714:	8b 45 08             	mov    0x8(%ebp),%eax
  800717:	89 10                	mov    %edx,(%eax)
  800719:	8b 45 08             	mov    0x8(%ebp),%eax
  80071c:	8b 00                	mov    (%eax),%eax
  80071e:	83 e8 04             	sub    $0x4,%eax
  800721:	8b 00                	mov    (%eax),%eax
  800723:	99                   	cltd   
  800724:	eb 18                	jmp    80073e <getint+0x5d>
	else
		return va_arg(*ap, int);
  800726:	8b 45 08             	mov    0x8(%ebp),%eax
  800729:	8b 00                	mov    (%eax),%eax
  80072b:	8d 50 04             	lea    0x4(%eax),%edx
  80072e:	8b 45 08             	mov    0x8(%ebp),%eax
  800731:	89 10                	mov    %edx,(%eax)
  800733:	8b 45 08             	mov    0x8(%ebp),%eax
  800736:	8b 00                	mov    (%eax),%eax
  800738:	83 e8 04             	sub    $0x4,%eax
  80073b:	8b 00                	mov    (%eax),%eax
  80073d:	99                   	cltd   
}
  80073e:	5d                   	pop    %ebp
  80073f:	c3                   	ret    

00800740 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  800740:	55                   	push   %ebp
  800741:	89 e5                	mov    %esp,%ebp
  800743:	56                   	push   %esi
  800744:	53                   	push   %ebx
  800745:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800748:	eb 17                	jmp    800761 <vprintfmt+0x21>
			if (ch == '\0')
  80074a:	85 db                	test   %ebx,%ebx
  80074c:	0f 84 af 03 00 00    	je     800b01 <vprintfmt+0x3c1>
				return;
			putch(ch, putdat);
  800752:	83 ec 08             	sub    $0x8,%esp
  800755:	ff 75 0c             	pushl  0xc(%ebp)
  800758:	53                   	push   %ebx
  800759:	8b 45 08             	mov    0x8(%ebp),%eax
  80075c:	ff d0                	call   *%eax
  80075e:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800761:	8b 45 10             	mov    0x10(%ebp),%eax
  800764:	8d 50 01             	lea    0x1(%eax),%edx
  800767:	89 55 10             	mov    %edx,0x10(%ebp)
  80076a:	8a 00                	mov    (%eax),%al
  80076c:	0f b6 d8             	movzbl %al,%ebx
  80076f:	83 fb 25             	cmp    $0x25,%ebx
  800772:	75 d6                	jne    80074a <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  800774:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  800778:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  80077f:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  800786:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  80078d:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800794:	8b 45 10             	mov    0x10(%ebp),%eax
  800797:	8d 50 01             	lea    0x1(%eax),%edx
  80079a:	89 55 10             	mov    %edx,0x10(%ebp)
  80079d:	8a 00                	mov    (%eax),%al
  80079f:	0f b6 d8             	movzbl %al,%ebx
  8007a2:	8d 43 dd             	lea    -0x23(%ebx),%eax
  8007a5:	83 f8 55             	cmp    $0x55,%eax
  8007a8:	0f 87 2b 03 00 00    	ja     800ad9 <vprintfmt+0x399>
  8007ae:	8b 04 85 58 36 80 00 	mov    0x803658(,%eax,4),%eax
  8007b5:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  8007b7:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  8007bb:	eb d7                	jmp    800794 <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  8007bd:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  8007c1:	eb d1                	jmp    800794 <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8007c3:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  8007ca:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8007cd:	89 d0                	mov    %edx,%eax
  8007cf:	c1 e0 02             	shl    $0x2,%eax
  8007d2:	01 d0                	add    %edx,%eax
  8007d4:	01 c0                	add    %eax,%eax
  8007d6:	01 d8                	add    %ebx,%eax
  8007d8:	83 e8 30             	sub    $0x30,%eax
  8007db:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  8007de:	8b 45 10             	mov    0x10(%ebp),%eax
  8007e1:	8a 00                	mov    (%eax),%al
  8007e3:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  8007e6:	83 fb 2f             	cmp    $0x2f,%ebx
  8007e9:	7e 3e                	jle    800829 <vprintfmt+0xe9>
  8007eb:	83 fb 39             	cmp    $0x39,%ebx
  8007ee:	7f 39                	jg     800829 <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8007f0:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  8007f3:	eb d5                	jmp    8007ca <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  8007f5:	8b 45 14             	mov    0x14(%ebp),%eax
  8007f8:	83 c0 04             	add    $0x4,%eax
  8007fb:	89 45 14             	mov    %eax,0x14(%ebp)
  8007fe:	8b 45 14             	mov    0x14(%ebp),%eax
  800801:	83 e8 04             	sub    $0x4,%eax
  800804:	8b 00                	mov    (%eax),%eax
  800806:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  800809:	eb 1f                	jmp    80082a <vprintfmt+0xea>

		case '.':
			if (width < 0)
  80080b:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80080f:	79 83                	jns    800794 <vprintfmt+0x54>
				width = 0;
  800811:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  800818:	e9 77 ff ff ff       	jmp    800794 <vprintfmt+0x54>

		case '#':
			altflag = 1;
  80081d:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  800824:	e9 6b ff ff ff       	jmp    800794 <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  800829:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  80082a:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80082e:	0f 89 60 ff ff ff    	jns    800794 <vprintfmt+0x54>
				width = precision, precision = -1;
  800834:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800837:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  80083a:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  800841:	e9 4e ff ff ff       	jmp    800794 <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  800846:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  800849:	e9 46 ff ff ff       	jmp    800794 <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  80084e:	8b 45 14             	mov    0x14(%ebp),%eax
  800851:	83 c0 04             	add    $0x4,%eax
  800854:	89 45 14             	mov    %eax,0x14(%ebp)
  800857:	8b 45 14             	mov    0x14(%ebp),%eax
  80085a:	83 e8 04             	sub    $0x4,%eax
  80085d:	8b 00                	mov    (%eax),%eax
  80085f:	83 ec 08             	sub    $0x8,%esp
  800862:	ff 75 0c             	pushl  0xc(%ebp)
  800865:	50                   	push   %eax
  800866:	8b 45 08             	mov    0x8(%ebp),%eax
  800869:	ff d0                	call   *%eax
  80086b:	83 c4 10             	add    $0x10,%esp
			break;
  80086e:	e9 89 02 00 00       	jmp    800afc <vprintfmt+0x3bc>

		// error message
		case 'e':
			err = va_arg(ap, int);
  800873:	8b 45 14             	mov    0x14(%ebp),%eax
  800876:	83 c0 04             	add    $0x4,%eax
  800879:	89 45 14             	mov    %eax,0x14(%ebp)
  80087c:	8b 45 14             	mov    0x14(%ebp),%eax
  80087f:	83 e8 04             	sub    $0x4,%eax
  800882:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  800884:	85 db                	test   %ebx,%ebx
  800886:	79 02                	jns    80088a <vprintfmt+0x14a>
				err = -err;
  800888:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  80088a:	83 fb 64             	cmp    $0x64,%ebx
  80088d:	7f 0b                	jg     80089a <vprintfmt+0x15a>
  80088f:	8b 34 9d a0 34 80 00 	mov    0x8034a0(,%ebx,4),%esi
  800896:	85 f6                	test   %esi,%esi
  800898:	75 19                	jne    8008b3 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  80089a:	53                   	push   %ebx
  80089b:	68 45 36 80 00       	push   $0x803645
  8008a0:	ff 75 0c             	pushl  0xc(%ebp)
  8008a3:	ff 75 08             	pushl  0x8(%ebp)
  8008a6:	e8 5e 02 00 00       	call   800b09 <printfmt>
  8008ab:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  8008ae:	e9 49 02 00 00       	jmp    800afc <vprintfmt+0x3bc>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  8008b3:	56                   	push   %esi
  8008b4:	68 4e 36 80 00       	push   $0x80364e
  8008b9:	ff 75 0c             	pushl  0xc(%ebp)
  8008bc:	ff 75 08             	pushl  0x8(%ebp)
  8008bf:	e8 45 02 00 00       	call   800b09 <printfmt>
  8008c4:	83 c4 10             	add    $0x10,%esp
			break;
  8008c7:	e9 30 02 00 00       	jmp    800afc <vprintfmt+0x3bc>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  8008cc:	8b 45 14             	mov    0x14(%ebp),%eax
  8008cf:	83 c0 04             	add    $0x4,%eax
  8008d2:	89 45 14             	mov    %eax,0x14(%ebp)
  8008d5:	8b 45 14             	mov    0x14(%ebp),%eax
  8008d8:	83 e8 04             	sub    $0x4,%eax
  8008db:	8b 30                	mov    (%eax),%esi
  8008dd:	85 f6                	test   %esi,%esi
  8008df:	75 05                	jne    8008e6 <vprintfmt+0x1a6>
				p = "(null)";
  8008e1:	be 51 36 80 00       	mov    $0x803651,%esi
			if (width > 0 && padc != '-')
  8008e6:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8008ea:	7e 6d                	jle    800959 <vprintfmt+0x219>
  8008ec:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  8008f0:	74 67                	je     800959 <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  8008f2:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8008f5:	83 ec 08             	sub    $0x8,%esp
  8008f8:	50                   	push   %eax
  8008f9:	56                   	push   %esi
  8008fa:	e8 0c 03 00 00       	call   800c0b <strnlen>
  8008ff:	83 c4 10             	add    $0x10,%esp
  800902:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  800905:	eb 16                	jmp    80091d <vprintfmt+0x1dd>
					putch(padc, putdat);
  800907:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  80090b:	83 ec 08             	sub    $0x8,%esp
  80090e:	ff 75 0c             	pushl  0xc(%ebp)
  800911:	50                   	push   %eax
  800912:	8b 45 08             	mov    0x8(%ebp),%eax
  800915:	ff d0                	call   *%eax
  800917:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  80091a:	ff 4d e4             	decl   -0x1c(%ebp)
  80091d:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800921:	7f e4                	jg     800907 <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800923:	eb 34                	jmp    800959 <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  800925:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800929:	74 1c                	je     800947 <vprintfmt+0x207>
  80092b:	83 fb 1f             	cmp    $0x1f,%ebx
  80092e:	7e 05                	jle    800935 <vprintfmt+0x1f5>
  800930:	83 fb 7e             	cmp    $0x7e,%ebx
  800933:	7e 12                	jle    800947 <vprintfmt+0x207>
					putch('?', putdat);
  800935:	83 ec 08             	sub    $0x8,%esp
  800938:	ff 75 0c             	pushl  0xc(%ebp)
  80093b:	6a 3f                	push   $0x3f
  80093d:	8b 45 08             	mov    0x8(%ebp),%eax
  800940:	ff d0                	call   *%eax
  800942:	83 c4 10             	add    $0x10,%esp
  800945:	eb 0f                	jmp    800956 <vprintfmt+0x216>
				else
					putch(ch, putdat);
  800947:	83 ec 08             	sub    $0x8,%esp
  80094a:	ff 75 0c             	pushl  0xc(%ebp)
  80094d:	53                   	push   %ebx
  80094e:	8b 45 08             	mov    0x8(%ebp),%eax
  800951:	ff d0                	call   *%eax
  800953:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800956:	ff 4d e4             	decl   -0x1c(%ebp)
  800959:	89 f0                	mov    %esi,%eax
  80095b:	8d 70 01             	lea    0x1(%eax),%esi
  80095e:	8a 00                	mov    (%eax),%al
  800960:	0f be d8             	movsbl %al,%ebx
  800963:	85 db                	test   %ebx,%ebx
  800965:	74 24                	je     80098b <vprintfmt+0x24b>
  800967:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80096b:	78 b8                	js     800925 <vprintfmt+0x1e5>
  80096d:	ff 4d e0             	decl   -0x20(%ebp)
  800970:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800974:	79 af                	jns    800925 <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800976:	eb 13                	jmp    80098b <vprintfmt+0x24b>
				putch(' ', putdat);
  800978:	83 ec 08             	sub    $0x8,%esp
  80097b:	ff 75 0c             	pushl  0xc(%ebp)
  80097e:	6a 20                	push   $0x20
  800980:	8b 45 08             	mov    0x8(%ebp),%eax
  800983:	ff d0                	call   *%eax
  800985:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800988:	ff 4d e4             	decl   -0x1c(%ebp)
  80098b:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80098f:	7f e7                	jg     800978 <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  800991:	e9 66 01 00 00       	jmp    800afc <vprintfmt+0x3bc>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  800996:	83 ec 08             	sub    $0x8,%esp
  800999:	ff 75 e8             	pushl  -0x18(%ebp)
  80099c:	8d 45 14             	lea    0x14(%ebp),%eax
  80099f:	50                   	push   %eax
  8009a0:	e8 3c fd ff ff       	call   8006e1 <getint>
  8009a5:	83 c4 10             	add    $0x10,%esp
  8009a8:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8009ab:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  8009ae:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8009b1:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8009b4:	85 d2                	test   %edx,%edx
  8009b6:	79 23                	jns    8009db <vprintfmt+0x29b>
				putch('-', putdat);
  8009b8:	83 ec 08             	sub    $0x8,%esp
  8009bb:	ff 75 0c             	pushl  0xc(%ebp)
  8009be:	6a 2d                	push   $0x2d
  8009c0:	8b 45 08             	mov    0x8(%ebp),%eax
  8009c3:	ff d0                	call   *%eax
  8009c5:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  8009c8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8009cb:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8009ce:	f7 d8                	neg    %eax
  8009d0:	83 d2 00             	adc    $0x0,%edx
  8009d3:	f7 da                	neg    %edx
  8009d5:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8009d8:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  8009db:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  8009e2:	e9 bc 00 00 00       	jmp    800aa3 <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  8009e7:	83 ec 08             	sub    $0x8,%esp
  8009ea:	ff 75 e8             	pushl  -0x18(%ebp)
  8009ed:	8d 45 14             	lea    0x14(%ebp),%eax
  8009f0:	50                   	push   %eax
  8009f1:	e8 84 fc ff ff       	call   80067a <getuint>
  8009f6:	83 c4 10             	add    $0x10,%esp
  8009f9:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8009fc:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  8009ff:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800a06:	e9 98 00 00 00       	jmp    800aa3 <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  800a0b:	83 ec 08             	sub    $0x8,%esp
  800a0e:	ff 75 0c             	pushl  0xc(%ebp)
  800a11:	6a 58                	push   $0x58
  800a13:	8b 45 08             	mov    0x8(%ebp),%eax
  800a16:	ff d0                	call   *%eax
  800a18:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800a1b:	83 ec 08             	sub    $0x8,%esp
  800a1e:	ff 75 0c             	pushl  0xc(%ebp)
  800a21:	6a 58                	push   $0x58
  800a23:	8b 45 08             	mov    0x8(%ebp),%eax
  800a26:	ff d0                	call   *%eax
  800a28:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800a2b:	83 ec 08             	sub    $0x8,%esp
  800a2e:	ff 75 0c             	pushl  0xc(%ebp)
  800a31:	6a 58                	push   $0x58
  800a33:	8b 45 08             	mov    0x8(%ebp),%eax
  800a36:	ff d0                	call   *%eax
  800a38:	83 c4 10             	add    $0x10,%esp
			break;
  800a3b:	e9 bc 00 00 00       	jmp    800afc <vprintfmt+0x3bc>

		// pointer
		case 'p':
			putch('0', putdat);
  800a40:	83 ec 08             	sub    $0x8,%esp
  800a43:	ff 75 0c             	pushl  0xc(%ebp)
  800a46:	6a 30                	push   $0x30
  800a48:	8b 45 08             	mov    0x8(%ebp),%eax
  800a4b:	ff d0                	call   *%eax
  800a4d:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  800a50:	83 ec 08             	sub    $0x8,%esp
  800a53:	ff 75 0c             	pushl  0xc(%ebp)
  800a56:	6a 78                	push   $0x78
  800a58:	8b 45 08             	mov    0x8(%ebp),%eax
  800a5b:	ff d0                	call   *%eax
  800a5d:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  800a60:	8b 45 14             	mov    0x14(%ebp),%eax
  800a63:	83 c0 04             	add    $0x4,%eax
  800a66:	89 45 14             	mov    %eax,0x14(%ebp)
  800a69:	8b 45 14             	mov    0x14(%ebp),%eax
  800a6c:	83 e8 04             	sub    $0x4,%eax
  800a6f:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800a71:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800a74:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  800a7b:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  800a82:	eb 1f                	jmp    800aa3 <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800a84:	83 ec 08             	sub    $0x8,%esp
  800a87:	ff 75 e8             	pushl  -0x18(%ebp)
  800a8a:	8d 45 14             	lea    0x14(%ebp),%eax
  800a8d:	50                   	push   %eax
  800a8e:	e8 e7 fb ff ff       	call   80067a <getuint>
  800a93:	83 c4 10             	add    $0x10,%esp
  800a96:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800a99:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  800a9c:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800aa3:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  800aa7:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800aaa:	83 ec 04             	sub    $0x4,%esp
  800aad:	52                   	push   %edx
  800aae:	ff 75 e4             	pushl  -0x1c(%ebp)
  800ab1:	50                   	push   %eax
  800ab2:	ff 75 f4             	pushl  -0xc(%ebp)
  800ab5:	ff 75 f0             	pushl  -0x10(%ebp)
  800ab8:	ff 75 0c             	pushl  0xc(%ebp)
  800abb:	ff 75 08             	pushl  0x8(%ebp)
  800abe:	e8 00 fb ff ff       	call   8005c3 <printnum>
  800ac3:	83 c4 20             	add    $0x20,%esp
			break;
  800ac6:	eb 34                	jmp    800afc <vprintfmt+0x3bc>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  800ac8:	83 ec 08             	sub    $0x8,%esp
  800acb:	ff 75 0c             	pushl  0xc(%ebp)
  800ace:	53                   	push   %ebx
  800acf:	8b 45 08             	mov    0x8(%ebp),%eax
  800ad2:	ff d0                	call   *%eax
  800ad4:	83 c4 10             	add    $0x10,%esp
			break;
  800ad7:	eb 23                	jmp    800afc <vprintfmt+0x3bc>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800ad9:	83 ec 08             	sub    $0x8,%esp
  800adc:	ff 75 0c             	pushl  0xc(%ebp)
  800adf:	6a 25                	push   $0x25
  800ae1:	8b 45 08             	mov    0x8(%ebp),%eax
  800ae4:	ff d0                	call   *%eax
  800ae6:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  800ae9:	ff 4d 10             	decl   0x10(%ebp)
  800aec:	eb 03                	jmp    800af1 <vprintfmt+0x3b1>
  800aee:	ff 4d 10             	decl   0x10(%ebp)
  800af1:	8b 45 10             	mov    0x10(%ebp),%eax
  800af4:	48                   	dec    %eax
  800af5:	8a 00                	mov    (%eax),%al
  800af7:	3c 25                	cmp    $0x25,%al
  800af9:	75 f3                	jne    800aee <vprintfmt+0x3ae>
				/* do nothing */;
			break;
  800afb:	90                   	nop
		}
	}
  800afc:	e9 47 fc ff ff       	jmp    800748 <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  800b01:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  800b02:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800b05:	5b                   	pop    %ebx
  800b06:	5e                   	pop    %esi
  800b07:	5d                   	pop    %ebp
  800b08:	c3                   	ret    

00800b09 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800b09:	55                   	push   %ebp
  800b0a:	89 e5                	mov    %esp,%ebp
  800b0c:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  800b0f:	8d 45 10             	lea    0x10(%ebp),%eax
  800b12:	83 c0 04             	add    $0x4,%eax
  800b15:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  800b18:	8b 45 10             	mov    0x10(%ebp),%eax
  800b1b:	ff 75 f4             	pushl  -0xc(%ebp)
  800b1e:	50                   	push   %eax
  800b1f:	ff 75 0c             	pushl  0xc(%ebp)
  800b22:	ff 75 08             	pushl  0x8(%ebp)
  800b25:	e8 16 fc ff ff       	call   800740 <vprintfmt>
  800b2a:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  800b2d:	90                   	nop
  800b2e:	c9                   	leave  
  800b2f:	c3                   	ret    

00800b30 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800b30:	55                   	push   %ebp
  800b31:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  800b33:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b36:	8b 40 08             	mov    0x8(%eax),%eax
  800b39:	8d 50 01             	lea    0x1(%eax),%edx
  800b3c:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b3f:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  800b42:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b45:	8b 10                	mov    (%eax),%edx
  800b47:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b4a:	8b 40 04             	mov    0x4(%eax),%eax
  800b4d:	39 c2                	cmp    %eax,%edx
  800b4f:	73 12                	jae    800b63 <sprintputch+0x33>
		*b->buf++ = ch;
  800b51:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b54:	8b 00                	mov    (%eax),%eax
  800b56:	8d 48 01             	lea    0x1(%eax),%ecx
  800b59:	8b 55 0c             	mov    0xc(%ebp),%edx
  800b5c:	89 0a                	mov    %ecx,(%edx)
  800b5e:	8b 55 08             	mov    0x8(%ebp),%edx
  800b61:	88 10                	mov    %dl,(%eax)
}
  800b63:	90                   	nop
  800b64:	5d                   	pop    %ebp
  800b65:	c3                   	ret    

00800b66 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800b66:	55                   	push   %ebp
  800b67:	89 e5                	mov    %esp,%ebp
  800b69:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  800b6c:	8b 45 08             	mov    0x8(%ebp),%eax
  800b6f:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800b72:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b75:	8d 50 ff             	lea    -0x1(%eax),%edx
  800b78:	8b 45 08             	mov    0x8(%ebp),%eax
  800b7b:	01 d0                	add    %edx,%eax
  800b7d:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800b80:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800b87:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800b8b:	74 06                	je     800b93 <vsnprintf+0x2d>
  800b8d:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800b91:	7f 07                	jg     800b9a <vsnprintf+0x34>
		return -E_INVAL;
  800b93:	b8 03 00 00 00       	mov    $0x3,%eax
  800b98:	eb 20                	jmp    800bba <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800b9a:	ff 75 14             	pushl  0x14(%ebp)
  800b9d:	ff 75 10             	pushl  0x10(%ebp)
  800ba0:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800ba3:	50                   	push   %eax
  800ba4:	68 30 0b 80 00       	push   $0x800b30
  800ba9:	e8 92 fb ff ff       	call   800740 <vprintfmt>
  800bae:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  800bb1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800bb4:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800bb7:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  800bba:	c9                   	leave  
  800bbb:	c3                   	ret    

00800bbc <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800bbc:	55                   	push   %ebp
  800bbd:	89 e5                	mov    %esp,%ebp
  800bbf:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800bc2:	8d 45 10             	lea    0x10(%ebp),%eax
  800bc5:	83 c0 04             	add    $0x4,%eax
  800bc8:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  800bcb:	8b 45 10             	mov    0x10(%ebp),%eax
  800bce:	ff 75 f4             	pushl  -0xc(%ebp)
  800bd1:	50                   	push   %eax
  800bd2:	ff 75 0c             	pushl  0xc(%ebp)
  800bd5:	ff 75 08             	pushl  0x8(%ebp)
  800bd8:	e8 89 ff ff ff       	call   800b66 <vsnprintf>
  800bdd:	83 c4 10             	add    $0x10,%esp
  800be0:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  800be3:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800be6:	c9                   	leave  
  800be7:	c3                   	ret    

00800be8 <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  800be8:	55                   	push   %ebp
  800be9:	89 e5                	mov    %esp,%ebp
  800beb:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  800bee:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800bf5:	eb 06                	jmp    800bfd <strlen+0x15>
		n++;
  800bf7:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800bfa:	ff 45 08             	incl   0x8(%ebp)
  800bfd:	8b 45 08             	mov    0x8(%ebp),%eax
  800c00:	8a 00                	mov    (%eax),%al
  800c02:	84 c0                	test   %al,%al
  800c04:	75 f1                	jne    800bf7 <strlen+0xf>
		n++;
	return n;
  800c06:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800c09:	c9                   	leave  
  800c0a:	c3                   	ret    

00800c0b <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  800c0b:	55                   	push   %ebp
  800c0c:	89 e5                	mov    %esp,%ebp
  800c0e:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800c11:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800c18:	eb 09                	jmp    800c23 <strnlen+0x18>
		n++;
  800c1a:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800c1d:	ff 45 08             	incl   0x8(%ebp)
  800c20:	ff 4d 0c             	decl   0xc(%ebp)
  800c23:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800c27:	74 09                	je     800c32 <strnlen+0x27>
  800c29:	8b 45 08             	mov    0x8(%ebp),%eax
  800c2c:	8a 00                	mov    (%eax),%al
  800c2e:	84 c0                	test   %al,%al
  800c30:	75 e8                	jne    800c1a <strnlen+0xf>
		n++;
	return n;
  800c32:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800c35:	c9                   	leave  
  800c36:	c3                   	ret    

00800c37 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800c37:	55                   	push   %ebp
  800c38:	89 e5                	mov    %esp,%ebp
  800c3a:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  800c3d:	8b 45 08             	mov    0x8(%ebp),%eax
  800c40:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  800c43:	90                   	nop
  800c44:	8b 45 08             	mov    0x8(%ebp),%eax
  800c47:	8d 50 01             	lea    0x1(%eax),%edx
  800c4a:	89 55 08             	mov    %edx,0x8(%ebp)
  800c4d:	8b 55 0c             	mov    0xc(%ebp),%edx
  800c50:	8d 4a 01             	lea    0x1(%edx),%ecx
  800c53:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800c56:	8a 12                	mov    (%edx),%dl
  800c58:	88 10                	mov    %dl,(%eax)
  800c5a:	8a 00                	mov    (%eax),%al
  800c5c:	84 c0                	test   %al,%al
  800c5e:	75 e4                	jne    800c44 <strcpy+0xd>
		/* do nothing */;
	return ret;
  800c60:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800c63:	c9                   	leave  
  800c64:	c3                   	ret    

00800c65 <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  800c65:	55                   	push   %ebp
  800c66:	89 e5                	mov    %esp,%ebp
  800c68:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  800c6b:	8b 45 08             	mov    0x8(%ebp),%eax
  800c6e:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  800c71:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800c78:	eb 1f                	jmp    800c99 <strncpy+0x34>
		*dst++ = *src;
  800c7a:	8b 45 08             	mov    0x8(%ebp),%eax
  800c7d:	8d 50 01             	lea    0x1(%eax),%edx
  800c80:	89 55 08             	mov    %edx,0x8(%ebp)
  800c83:	8b 55 0c             	mov    0xc(%ebp),%edx
  800c86:	8a 12                	mov    (%edx),%dl
  800c88:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  800c8a:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c8d:	8a 00                	mov    (%eax),%al
  800c8f:	84 c0                	test   %al,%al
  800c91:	74 03                	je     800c96 <strncpy+0x31>
			src++;
  800c93:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800c96:	ff 45 fc             	incl   -0x4(%ebp)
  800c99:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800c9c:	3b 45 10             	cmp    0x10(%ebp),%eax
  800c9f:	72 d9                	jb     800c7a <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  800ca1:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  800ca4:	c9                   	leave  
  800ca5:	c3                   	ret    

00800ca6 <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  800ca6:	55                   	push   %ebp
  800ca7:	89 e5                	mov    %esp,%ebp
  800ca9:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  800cac:	8b 45 08             	mov    0x8(%ebp),%eax
  800caf:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  800cb2:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800cb6:	74 30                	je     800ce8 <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  800cb8:	eb 16                	jmp    800cd0 <strlcpy+0x2a>
			*dst++ = *src++;
  800cba:	8b 45 08             	mov    0x8(%ebp),%eax
  800cbd:	8d 50 01             	lea    0x1(%eax),%edx
  800cc0:	89 55 08             	mov    %edx,0x8(%ebp)
  800cc3:	8b 55 0c             	mov    0xc(%ebp),%edx
  800cc6:	8d 4a 01             	lea    0x1(%edx),%ecx
  800cc9:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800ccc:	8a 12                	mov    (%edx),%dl
  800cce:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800cd0:	ff 4d 10             	decl   0x10(%ebp)
  800cd3:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800cd7:	74 09                	je     800ce2 <strlcpy+0x3c>
  800cd9:	8b 45 0c             	mov    0xc(%ebp),%eax
  800cdc:	8a 00                	mov    (%eax),%al
  800cde:	84 c0                	test   %al,%al
  800ce0:	75 d8                	jne    800cba <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  800ce2:	8b 45 08             	mov    0x8(%ebp),%eax
  800ce5:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800ce8:	8b 55 08             	mov    0x8(%ebp),%edx
  800ceb:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800cee:	29 c2                	sub    %eax,%edx
  800cf0:	89 d0                	mov    %edx,%eax
}
  800cf2:	c9                   	leave  
  800cf3:	c3                   	ret    

00800cf4 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800cf4:	55                   	push   %ebp
  800cf5:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  800cf7:	eb 06                	jmp    800cff <strcmp+0xb>
		p++, q++;
  800cf9:	ff 45 08             	incl   0x8(%ebp)
  800cfc:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  800cff:	8b 45 08             	mov    0x8(%ebp),%eax
  800d02:	8a 00                	mov    (%eax),%al
  800d04:	84 c0                	test   %al,%al
  800d06:	74 0e                	je     800d16 <strcmp+0x22>
  800d08:	8b 45 08             	mov    0x8(%ebp),%eax
  800d0b:	8a 10                	mov    (%eax),%dl
  800d0d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d10:	8a 00                	mov    (%eax),%al
  800d12:	38 c2                	cmp    %al,%dl
  800d14:	74 e3                	je     800cf9 <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800d16:	8b 45 08             	mov    0x8(%ebp),%eax
  800d19:	8a 00                	mov    (%eax),%al
  800d1b:	0f b6 d0             	movzbl %al,%edx
  800d1e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d21:	8a 00                	mov    (%eax),%al
  800d23:	0f b6 c0             	movzbl %al,%eax
  800d26:	29 c2                	sub    %eax,%edx
  800d28:	89 d0                	mov    %edx,%eax
}
  800d2a:	5d                   	pop    %ebp
  800d2b:	c3                   	ret    

00800d2c <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  800d2c:	55                   	push   %ebp
  800d2d:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  800d2f:	eb 09                	jmp    800d3a <strncmp+0xe>
		n--, p++, q++;
  800d31:	ff 4d 10             	decl   0x10(%ebp)
  800d34:	ff 45 08             	incl   0x8(%ebp)
  800d37:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  800d3a:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800d3e:	74 17                	je     800d57 <strncmp+0x2b>
  800d40:	8b 45 08             	mov    0x8(%ebp),%eax
  800d43:	8a 00                	mov    (%eax),%al
  800d45:	84 c0                	test   %al,%al
  800d47:	74 0e                	je     800d57 <strncmp+0x2b>
  800d49:	8b 45 08             	mov    0x8(%ebp),%eax
  800d4c:	8a 10                	mov    (%eax),%dl
  800d4e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d51:	8a 00                	mov    (%eax),%al
  800d53:	38 c2                	cmp    %al,%dl
  800d55:	74 da                	je     800d31 <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  800d57:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800d5b:	75 07                	jne    800d64 <strncmp+0x38>
		return 0;
  800d5d:	b8 00 00 00 00       	mov    $0x0,%eax
  800d62:	eb 14                	jmp    800d78 <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800d64:	8b 45 08             	mov    0x8(%ebp),%eax
  800d67:	8a 00                	mov    (%eax),%al
  800d69:	0f b6 d0             	movzbl %al,%edx
  800d6c:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d6f:	8a 00                	mov    (%eax),%al
  800d71:	0f b6 c0             	movzbl %al,%eax
  800d74:	29 c2                	sub    %eax,%edx
  800d76:	89 d0                	mov    %edx,%eax
}
  800d78:	5d                   	pop    %ebp
  800d79:	c3                   	ret    

00800d7a <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800d7a:	55                   	push   %ebp
  800d7b:	89 e5                	mov    %esp,%ebp
  800d7d:	83 ec 04             	sub    $0x4,%esp
  800d80:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d83:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800d86:	eb 12                	jmp    800d9a <strchr+0x20>
		if (*s == c)
  800d88:	8b 45 08             	mov    0x8(%ebp),%eax
  800d8b:	8a 00                	mov    (%eax),%al
  800d8d:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800d90:	75 05                	jne    800d97 <strchr+0x1d>
			return (char *) s;
  800d92:	8b 45 08             	mov    0x8(%ebp),%eax
  800d95:	eb 11                	jmp    800da8 <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  800d97:	ff 45 08             	incl   0x8(%ebp)
  800d9a:	8b 45 08             	mov    0x8(%ebp),%eax
  800d9d:	8a 00                	mov    (%eax),%al
  800d9f:	84 c0                	test   %al,%al
  800da1:	75 e5                	jne    800d88 <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  800da3:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800da8:	c9                   	leave  
  800da9:	c3                   	ret    

00800daa <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800daa:	55                   	push   %ebp
  800dab:	89 e5                	mov    %esp,%ebp
  800dad:	83 ec 04             	sub    $0x4,%esp
  800db0:	8b 45 0c             	mov    0xc(%ebp),%eax
  800db3:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800db6:	eb 0d                	jmp    800dc5 <strfind+0x1b>
		if (*s == c)
  800db8:	8b 45 08             	mov    0x8(%ebp),%eax
  800dbb:	8a 00                	mov    (%eax),%al
  800dbd:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800dc0:	74 0e                	je     800dd0 <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  800dc2:	ff 45 08             	incl   0x8(%ebp)
  800dc5:	8b 45 08             	mov    0x8(%ebp),%eax
  800dc8:	8a 00                	mov    (%eax),%al
  800dca:	84 c0                	test   %al,%al
  800dcc:	75 ea                	jne    800db8 <strfind+0xe>
  800dce:	eb 01                	jmp    800dd1 <strfind+0x27>
		if (*s == c)
			break;
  800dd0:	90                   	nop
	return (char *) s;
  800dd1:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800dd4:	c9                   	leave  
  800dd5:	c3                   	ret    

00800dd6 <memset>:


void *
memset(void *v, int c, uint32 n)
{
  800dd6:	55                   	push   %ebp
  800dd7:	89 e5                	mov    %esp,%ebp
  800dd9:	83 ec 10             	sub    $0x10,%esp
	char *p;
	int m;

	p = v;
  800ddc:	8b 45 08             	mov    0x8(%ebp),%eax
  800ddf:	89 45 fc             	mov    %eax,-0x4(%ebp)
	m = n;
  800de2:	8b 45 10             	mov    0x10(%ebp),%eax
  800de5:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (--m >= 0)
  800de8:	eb 0e                	jmp    800df8 <memset+0x22>
		*p++ = c;
  800dea:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800ded:	8d 50 01             	lea    0x1(%eax),%edx
  800df0:	89 55 fc             	mov    %edx,-0x4(%ebp)
  800df3:	8b 55 0c             	mov    0xc(%ebp),%edx
  800df6:	88 10                	mov    %dl,(%eax)
	char *p;
	int m;

	p = v;
	m = n;
	while (--m >= 0)
  800df8:	ff 4d f8             	decl   -0x8(%ebp)
  800dfb:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  800dff:	79 e9                	jns    800dea <memset+0x14>
		*p++ = c;

	return v;
  800e01:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800e04:	c9                   	leave  
  800e05:	c3                   	ret    

00800e06 <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  800e06:	55                   	push   %ebp
  800e07:	89 e5                	mov    %esp,%ebp
  800e09:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800e0c:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e0f:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800e12:	8b 45 08             	mov    0x8(%ebp),%eax
  800e15:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (n-- > 0)
  800e18:	eb 16                	jmp    800e30 <memcpy+0x2a>
		*d++ = *s++;
  800e1a:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800e1d:	8d 50 01             	lea    0x1(%eax),%edx
  800e20:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800e23:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800e26:	8d 4a 01             	lea    0x1(%edx),%ecx
  800e29:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800e2c:	8a 12                	mov    (%edx),%dl
  800e2e:	88 10                	mov    %dl,(%eax)
	const char *s;
	char *d;

	s = src;
	d = dst;
	while (n-- > 0)
  800e30:	8b 45 10             	mov    0x10(%ebp),%eax
  800e33:	8d 50 ff             	lea    -0x1(%eax),%edx
  800e36:	89 55 10             	mov    %edx,0x10(%ebp)
  800e39:	85 c0                	test   %eax,%eax
  800e3b:	75 dd                	jne    800e1a <memcpy+0x14>
		*d++ = *s++;

	return dst;
  800e3d:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800e40:	c9                   	leave  
  800e41:	c3                   	ret    

00800e42 <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  800e42:	55                   	push   %ebp
  800e43:	89 e5                	mov    %esp,%ebp
  800e45:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800e48:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e4b:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800e4e:	8b 45 08             	mov    0x8(%ebp),%eax
  800e51:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  800e54:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800e57:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800e5a:	73 50                	jae    800eac <memmove+0x6a>
  800e5c:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800e5f:	8b 45 10             	mov    0x10(%ebp),%eax
  800e62:	01 d0                	add    %edx,%eax
  800e64:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800e67:	76 43                	jbe    800eac <memmove+0x6a>
		s += n;
  800e69:	8b 45 10             	mov    0x10(%ebp),%eax
  800e6c:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  800e6f:	8b 45 10             	mov    0x10(%ebp),%eax
  800e72:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  800e75:	eb 10                	jmp    800e87 <memmove+0x45>
			*--d = *--s;
  800e77:	ff 4d f8             	decl   -0x8(%ebp)
  800e7a:	ff 4d fc             	decl   -0x4(%ebp)
  800e7d:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800e80:	8a 10                	mov    (%eax),%dl
  800e82:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800e85:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  800e87:	8b 45 10             	mov    0x10(%ebp),%eax
  800e8a:	8d 50 ff             	lea    -0x1(%eax),%edx
  800e8d:	89 55 10             	mov    %edx,0x10(%ebp)
  800e90:	85 c0                	test   %eax,%eax
  800e92:	75 e3                	jne    800e77 <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800e94:	eb 23                	jmp    800eb9 <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  800e96:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800e99:	8d 50 01             	lea    0x1(%eax),%edx
  800e9c:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800e9f:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800ea2:	8d 4a 01             	lea    0x1(%edx),%ecx
  800ea5:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800ea8:	8a 12                	mov    (%edx),%dl
  800eaa:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  800eac:	8b 45 10             	mov    0x10(%ebp),%eax
  800eaf:	8d 50 ff             	lea    -0x1(%eax),%edx
  800eb2:	89 55 10             	mov    %edx,0x10(%ebp)
  800eb5:	85 c0                	test   %eax,%eax
  800eb7:	75 dd                	jne    800e96 <memmove+0x54>
			*d++ = *s++;

	return dst;
  800eb9:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800ebc:	c9                   	leave  
  800ebd:	c3                   	ret    

00800ebe <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  800ebe:	55                   	push   %ebp
  800ebf:	89 e5                	mov    %esp,%ebp
  800ec1:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  800ec4:	8b 45 08             	mov    0x8(%ebp),%eax
  800ec7:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  800eca:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ecd:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  800ed0:	eb 2a                	jmp    800efc <memcmp+0x3e>
		if (*s1 != *s2)
  800ed2:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800ed5:	8a 10                	mov    (%eax),%dl
  800ed7:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800eda:	8a 00                	mov    (%eax),%al
  800edc:	38 c2                	cmp    %al,%dl
  800ede:	74 16                	je     800ef6 <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  800ee0:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800ee3:	8a 00                	mov    (%eax),%al
  800ee5:	0f b6 d0             	movzbl %al,%edx
  800ee8:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800eeb:	8a 00                	mov    (%eax),%al
  800eed:	0f b6 c0             	movzbl %al,%eax
  800ef0:	29 c2                	sub    %eax,%edx
  800ef2:	89 d0                	mov    %edx,%eax
  800ef4:	eb 18                	jmp    800f0e <memcmp+0x50>
		s1++, s2++;
  800ef6:	ff 45 fc             	incl   -0x4(%ebp)
  800ef9:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  800efc:	8b 45 10             	mov    0x10(%ebp),%eax
  800eff:	8d 50 ff             	lea    -0x1(%eax),%edx
  800f02:	89 55 10             	mov    %edx,0x10(%ebp)
  800f05:	85 c0                	test   %eax,%eax
  800f07:	75 c9                	jne    800ed2 <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  800f09:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800f0e:	c9                   	leave  
  800f0f:	c3                   	ret    

00800f10 <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  800f10:	55                   	push   %ebp
  800f11:	89 e5                	mov    %esp,%ebp
  800f13:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  800f16:	8b 55 08             	mov    0x8(%ebp),%edx
  800f19:	8b 45 10             	mov    0x10(%ebp),%eax
  800f1c:	01 d0                	add    %edx,%eax
  800f1e:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  800f21:	eb 15                	jmp    800f38 <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  800f23:	8b 45 08             	mov    0x8(%ebp),%eax
  800f26:	8a 00                	mov    (%eax),%al
  800f28:	0f b6 d0             	movzbl %al,%edx
  800f2b:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f2e:	0f b6 c0             	movzbl %al,%eax
  800f31:	39 c2                	cmp    %eax,%edx
  800f33:	74 0d                	je     800f42 <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  800f35:	ff 45 08             	incl   0x8(%ebp)
  800f38:	8b 45 08             	mov    0x8(%ebp),%eax
  800f3b:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  800f3e:	72 e3                	jb     800f23 <memfind+0x13>
  800f40:	eb 01                	jmp    800f43 <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  800f42:	90                   	nop
	return (void *) s;
  800f43:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800f46:	c9                   	leave  
  800f47:	c3                   	ret    

00800f48 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800f48:	55                   	push   %ebp
  800f49:	89 e5                	mov    %esp,%ebp
  800f4b:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  800f4e:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  800f55:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800f5c:	eb 03                	jmp    800f61 <strtol+0x19>
		s++;
  800f5e:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800f61:	8b 45 08             	mov    0x8(%ebp),%eax
  800f64:	8a 00                	mov    (%eax),%al
  800f66:	3c 20                	cmp    $0x20,%al
  800f68:	74 f4                	je     800f5e <strtol+0x16>
  800f6a:	8b 45 08             	mov    0x8(%ebp),%eax
  800f6d:	8a 00                	mov    (%eax),%al
  800f6f:	3c 09                	cmp    $0x9,%al
  800f71:	74 eb                	je     800f5e <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  800f73:	8b 45 08             	mov    0x8(%ebp),%eax
  800f76:	8a 00                	mov    (%eax),%al
  800f78:	3c 2b                	cmp    $0x2b,%al
  800f7a:	75 05                	jne    800f81 <strtol+0x39>
		s++;
  800f7c:	ff 45 08             	incl   0x8(%ebp)
  800f7f:	eb 13                	jmp    800f94 <strtol+0x4c>
	else if (*s == '-')
  800f81:	8b 45 08             	mov    0x8(%ebp),%eax
  800f84:	8a 00                	mov    (%eax),%al
  800f86:	3c 2d                	cmp    $0x2d,%al
  800f88:	75 0a                	jne    800f94 <strtol+0x4c>
		s++, neg = 1;
  800f8a:	ff 45 08             	incl   0x8(%ebp)
  800f8d:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800f94:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800f98:	74 06                	je     800fa0 <strtol+0x58>
  800f9a:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  800f9e:	75 20                	jne    800fc0 <strtol+0x78>
  800fa0:	8b 45 08             	mov    0x8(%ebp),%eax
  800fa3:	8a 00                	mov    (%eax),%al
  800fa5:	3c 30                	cmp    $0x30,%al
  800fa7:	75 17                	jne    800fc0 <strtol+0x78>
  800fa9:	8b 45 08             	mov    0x8(%ebp),%eax
  800fac:	40                   	inc    %eax
  800fad:	8a 00                	mov    (%eax),%al
  800faf:	3c 78                	cmp    $0x78,%al
  800fb1:	75 0d                	jne    800fc0 <strtol+0x78>
		s += 2, base = 16;
  800fb3:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  800fb7:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  800fbe:	eb 28                	jmp    800fe8 <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  800fc0:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800fc4:	75 15                	jne    800fdb <strtol+0x93>
  800fc6:	8b 45 08             	mov    0x8(%ebp),%eax
  800fc9:	8a 00                	mov    (%eax),%al
  800fcb:	3c 30                	cmp    $0x30,%al
  800fcd:	75 0c                	jne    800fdb <strtol+0x93>
		s++, base = 8;
  800fcf:	ff 45 08             	incl   0x8(%ebp)
  800fd2:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  800fd9:	eb 0d                	jmp    800fe8 <strtol+0xa0>
	else if (base == 0)
  800fdb:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800fdf:	75 07                	jne    800fe8 <strtol+0xa0>
		base = 10;
  800fe1:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  800fe8:	8b 45 08             	mov    0x8(%ebp),%eax
  800feb:	8a 00                	mov    (%eax),%al
  800fed:	3c 2f                	cmp    $0x2f,%al
  800fef:	7e 19                	jle    80100a <strtol+0xc2>
  800ff1:	8b 45 08             	mov    0x8(%ebp),%eax
  800ff4:	8a 00                	mov    (%eax),%al
  800ff6:	3c 39                	cmp    $0x39,%al
  800ff8:	7f 10                	jg     80100a <strtol+0xc2>
			dig = *s - '0';
  800ffa:	8b 45 08             	mov    0x8(%ebp),%eax
  800ffd:	8a 00                	mov    (%eax),%al
  800fff:	0f be c0             	movsbl %al,%eax
  801002:	83 e8 30             	sub    $0x30,%eax
  801005:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801008:	eb 42                	jmp    80104c <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  80100a:	8b 45 08             	mov    0x8(%ebp),%eax
  80100d:	8a 00                	mov    (%eax),%al
  80100f:	3c 60                	cmp    $0x60,%al
  801011:	7e 19                	jle    80102c <strtol+0xe4>
  801013:	8b 45 08             	mov    0x8(%ebp),%eax
  801016:	8a 00                	mov    (%eax),%al
  801018:	3c 7a                	cmp    $0x7a,%al
  80101a:	7f 10                	jg     80102c <strtol+0xe4>
			dig = *s - 'a' + 10;
  80101c:	8b 45 08             	mov    0x8(%ebp),%eax
  80101f:	8a 00                	mov    (%eax),%al
  801021:	0f be c0             	movsbl %al,%eax
  801024:	83 e8 57             	sub    $0x57,%eax
  801027:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80102a:	eb 20                	jmp    80104c <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  80102c:	8b 45 08             	mov    0x8(%ebp),%eax
  80102f:	8a 00                	mov    (%eax),%al
  801031:	3c 40                	cmp    $0x40,%al
  801033:	7e 39                	jle    80106e <strtol+0x126>
  801035:	8b 45 08             	mov    0x8(%ebp),%eax
  801038:	8a 00                	mov    (%eax),%al
  80103a:	3c 5a                	cmp    $0x5a,%al
  80103c:	7f 30                	jg     80106e <strtol+0x126>
			dig = *s - 'A' + 10;
  80103e:	8b 45 08             	mov    0x8(%ebp),%eax
  801041:	8a 00                	mov    (%eax),%al
  801043:	0f be c0             	movsbl %al,%eax
  801046:	83 e8 37             	sub    $0x37,%eax
  801049:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  80104c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80104f:	3b 45 10             	cmp    0x10(%ebp),%eax
  801052:	7d 19                	jge    80106d <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  801054:	ff 45 08             	incl   0x8(%ebp)
  801057:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80105a:	0f af 45 10          	imul   0x10(%ebp),%eax
  80105e:	89 c2                	mov    %eax,%edx
  801060:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801063:	01 d0                	add    %edx,%eax
  801065:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  801068:	e9 7b ff ff ff       	jmp    800fe8 <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  80106d:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  80106e:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801072:	74 08                	je     80107c <strtol+0x134>
		*endptr = (char *) s;
  801074:	8b 45 0c             	mov    0xc(%ebp),%eax
  801077:	8b 55 08             	mov    0x8(%ebp),%edx
  80107a:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  80107c:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801080:	74 07                	je     801089 <strtol+0x141>
  801082:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801085:	f7 d8                	neg    %eax
  801087:	eb 03                	jmp    80108c <strtol+0x144>
  801089:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  80108c:	c9                   	leave  
  80108d:	c3                   	ret    

0080108e <ltostr>:

void
ltostr(long value, char *str)
{
  80108e:	55                   	push   %ebp
  80108f:	89 e5                	mov    %esp,%ebp
  801091:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  801094:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  80109b:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  8010a2:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8010a6:	79 13                	jns    8010bb <ltostr+0x2d>
	{
		neg = 1;
  8010a8:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  8010af:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010b2:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  8010b5:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  8010b8:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  8010bb:	8b 45 08             	mov    0x8(%ebp),%eax
  8010be:	b9 0a 00 00 00       	mov    $0xa,%ecx
  8010c3:	99                   	cltd   
  8010c4:	f7 f9                	idiv   %ecx
  8010c6:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  8010c9:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8010cc:	8d 50 01             	lea    0x1(%eax),%edx
  8010cf:	89 55 f8             	mov    %edx,-0x8(%ebp)
  8010d2:	89 c2                	mov    %eax,%edx
  8010d4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010d7:	01 d0                	add    %edx,%eax
  8010d9:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8010dc:	83 c2 30             	add    $0x30,%edx
  8010df:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  8010e1:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8010e4:	b8 67 66 66 66       	mov    $0x66666667,%eax
  8010e9:	f7 e9                	imul   %ecx
  8010eb:	c1 fa 02             	sar    $0x2,%edx
  8010ee:	89 c8                	mov    %ecx,%eax
  8010f0:	c1 f8 1f             	sar    $0x1f,%eax
  8010f3:	29 c2                	sub    %eax,%edx
  8010f5:	89 d0                	mov    %edx,%eax
  8010f7:	89 45 08             	mov    %eax,0x8(%ebp)
	} while (value % 10 != 0);
  8010fa:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8010fd:	b8 67 66 66 66       	mov    $0x66666667,%eax
  801102:	f7 e9                	imul   %ecx
  801104:	c1 fa 02             	sar    $0x2,%edx
  801107:	89 c8                	mov    %ecx,%eax
  801109:	c1 f8 1f             	sar    $0x1f,%eax
  80110c:	29 c2                	sub    %eax,%edx
  80110e:	89 d0                	mov    %edx,%eax
  801110:	c1 e0 02             	shl    $0x2,%eax
  801113:	01 d0                	add    %edx,%eax
  801115:	01 c0                	add    %eax,%eax
  801117:	29 c1                	sub    %eax,%ecx
  801119:	89 ca                	mov    %ecx,%edx
  80111b:	85 d2                	test   %edx,%edx
  80111d:	75 9c                	jne    8010bb <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  80111f:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  801126:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801129:	48                   	dec    %eax
  80112a:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  80112d:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801131:	74 3d                	je     801170 <ltostr+0xe2>
		start = 1 ;
  801133:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  80113a:	eb 34                	jmp    801170 <ltostr+0xe2>
	{
		char tmp = str[start] ;
  80113c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80113f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801142:	01 d0                	add    %edx,%eax
  801144:	8a 00                	mov    (%eax),%al
  801146:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  801149:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80114c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80114f:	01 c2                	add    %eax,%edx
  801151:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  801154:	8b 45 0c             	mov    0xc(%ebp),%eax
  801157:	01 c8                	add    %ecx,%eax
  801159:	8a 00                	mov    (%eax),%al
  80115b:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  80115d:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801160:	8b 45 0c             	mov    0xc(%ebp),%eax
  801163:	01 c2                	add    %eax,%edx
  801165:	8a 45 eb             	mov    -0x15(%ebp),%al
  801168:	88 02                	mov    %al,(%edx)
		start++ ;
  80116a:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  80116d:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  801170:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801173:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801176:	7c c4                	jl     80113c <ltostr+0xae>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  801178:	8b 55 f8             	mov    -0x8(%ebp),%edx
  80117b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80117e:	01 d0                	add    %edx,%eax
  801180:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  801183:	90                   	nop
  801184:	c9                   	leave  
  801185:	c3                   	ret    

00801186 <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  801186:	55                   	push   %ebp
  801187:	89 e5                	mov    %esp,%ebp
  801189:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  80118c:	ff 75 08             	pushl  0x8(%ebp)
  80118f:	e8 54 fa ff ff       	call   800be8 <strlen>
  801194:	83 c4 04             	add    $0x4,%esp
  801197:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  80119a:	ff 75 0c             	pushl  0xc(%ebp)
  80119d:	e8 46 fa ff ff       	call   800be8 <strlen>
  8011a2:	83 c4 04             	add    $0x4,%esp
  8011a5:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  8011a8:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  8011af:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8011b6:	eb 17                	jmp    8011cf <strcconcat+0x49>
		final[s] = str1[s] ;
  8011b8:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8011bb:	8b 45 10             	mov    0x10(%ebp),%eax
  8011be:	01 c2                	add    %eax,%edx
  8011c0:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  8011c3:	8b 45 08             	mov    0x8(%ebp),%eax
  8011c6:	01 c8                	add    %ecx,%eax
  8011c8:	8a 00                	mov    (%eax),%al
  8011ca:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  8011cc:	ff 45 fc             	incl   -0x4(%ebp)
  8011cf:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8011d2:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  8011d5:	7c e1                	jl     8011b8 <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  8011d7:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  8011de:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  8011e5:	eb 1f                	jmp    801206 <strcconcat+0x80>
		final[s++] = str2[i] ;
  8011e7:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8011ea:	8d 50 01             	lea    0x1(%eax),%edx
  8011ed:	89 55 fc             	mov    %edx,-0x4(%ebp)
  8011f0:	89 c2                	mov    %eax,%edx
  8011f2:	8b 45 10             	mov    0x10(%ebp),%eax
  8011f5:	01 c2                	add    %eax,%edx
  8011f7:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  8011fa:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011fd:	01 c8                	add    %ecx,%eax
  8011ff:	8a 00                	mov    (%eax),%al
  801201:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  801203:	ff 45 f8             	incl   -0x8(%ebp)
  801206:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801209:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80120c:	7c d9                	jl     8011e7 <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  80120e:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801211:	8b 45 10             	mov    0x10(%ebp),%eax
  801214:	01 d0                	add    %edx,%eax
  801216:	c6 00 00             	movb   $0x0,(%eax)
}
  801219:	90                   	nop
  80121a:	c9                   	leave  
  80121b:	c3                   	ret    

0080121c <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  80121c:	55                   	push   %ebp
  80121d:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  80121f:	8b 45 14             	mov    0x14(%ebp),%eax
  801222:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  801228:	8b 45 14             	mov    0x14(%ebp),%eax
  80122b:	8b 00                	mov    (%eax),%eax
  80122d:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801234:	8b 45 10             	mov    0x10(%ebp),%eax
  801237:	01 d0                	add    %edx,%eax
  801239:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  80123f:	eb 0c                	jmp    80124d <strsplit+0x31>
			*string++ = 0;
  801241:	8b 45 08             	mov    0x8(%ebp),%eax
  801244:	8d 50 01             	lea    0x1(%eax),%edx
  801247:	89 55 08             	mov    %edx,0x8(%ebp)
  80124a:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  80124d:	8b 45 08             	mov    0x8(%ebp),%eax
  801250:	8a 00                	mov    (%eax),%al
  801252:	84 c0                	test   %al,%al
  801254:	74 18                	je     80126e <strsplit+0x52>
  801256:	8b 45 08             	mov    0x8(%ebp),%eax
  801259:	8a 00                	mov    (%eax),%al
  80125b:	0f be c0             	movsbl %al,%eax
  80125e:	50                   	push   %eax
  80125f:	ff 75 0c             	pushl  0xc(%ebp)
  801262:	e8 13 fb ff ff       	call   800d7a <strchr>
  801267:	83 c4 08             	add    $0x8,%esp
  80126a:	85 c0                	test   %eax,%eax
  80126c:	75 d3                	jne    801241 <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  80126e:	8b 45 08             	mov    0x8(%ebp),%eax
  801271:	8a 00                	mov    (%eax),%al
  801273:	84 c0                	test   %al,%al
  801275:	74 5a                	je     8012d1 <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  801277:	8b 45 14             	mov    0x14(%ebp),%eax
  80127a:	8b 00                	mov    (%eax),%eax
  80127c:	83 f8 0f             	cmp    $0xf,%eax
  80127f:	75 07                	jne    801288 <strsplit+0x6c>
		{
			return 0;
  801281:	b8 00 00 00 00       	mov    $0x0,%eax
  801286:	eb 66                	jmp    8012ee <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  801288:	8b 45 14             	mov    0x14(%ebp),%eax
  80128b:	8b 00                	mov    (%eax),%eax
  80128d:	8d 48 01             	lea    0x1(%eax),%ecx
  801290:	8b 55 14             	mov    0x14(%ebp),%edx
  801293:	89 0a                	mov    %ecx,(%edx)
  801295:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80129c:	8b 45 10             	mov    0x10(%ebp),%eax
  80129f:	01 c2                	add    %eax,%edx
  8012a1:	8b 45 08             	mov    0x8(%ebp),%eax
  8012a4:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  8012a6:	eb 03                	jmp    8012ab <strsplit+0x8f>
			string++;
  8012a8:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  8012ab:	8b 45 08             	mov    0x8(%ebp),%eax
  8012ae:	8a 00                	mov    (%eax),%al
  8012b0:	84 c0                	test   %al,%al
  8012b2:	74 8b                	je     80123f <strsplit+0x23>
  8012b4:	8b 45 08             	mov    0x8(%ebp),%eax
  8012b7:	8a 00                	mov    (%eax),%al
  8012b9:	0f be c0             	movsbl %al,%eax
  8012bc:	50                   	push   %eax
  8012bd:	ff 75 0c             	pushl  0xc(%ebp)
  8012c0:	e8 b5 fa ff ff       	call   800d7a <strchr>
  8012c5:	83 c4 08             	add    $0x8,%esp
  8012c8:	85 c0                	test   %eax,%eax
  8012ca:	74 dc                	je     8012a8 <strsplit+0x8c>
			string++;
	}
  8012cc:	e9 6e ff ff ff       	jmp    80123f <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  8012d1:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  8012d2:	8b 45 14             	mov    0x14(%ebp),%eax
  8012d5:	8b 00                	mov    (%eax),%eax
  8012d7:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8012de:	8b 45 10             	mov    0x10(%ebp),%eax
  8012e1:	01 d0                	add    %edx,%eax
  8012e3:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  8012e9:	b8 01 00 00 00       	mov    $0x1,%eax
}
  8012ee:	c9                   	leave  
  8012ef:	c3                   	ret    

008012f0 <InitializeUHeap>:
//============================== GIVEN FUNCTIONS ===================================//
//==================================================================================//

int FirstTimeFlag = 1;
void InitializeUHeap()
{
  8012f0:	55                   	push   %ebp
  8012f1:	89 e5                	mov    %esp,%ebp
  8012f3:	83 ec 08             	sub    $0x8,%esp
	if(FirstTimeFlag)
  8012f6:	a1 04 40 80 00       	mov    0x804004,%eax
  8012fb:	85 c0                	test   %eax,%eax
  8012fd:	74 1f                	je     80131e <InitializeUHeap+0x2e>
	{
		initialize_dyn_block_system();
  8012ff:	e8 1d 00 00 00       	call   801321 <initialize_dyn_block_system>
		cprintf("DYNAMIC BLOCK SYSTEM IS INITIALIZED\n");
  801304:	83 ec 0c             	sub    $0xc,%esp
  801307:	68 b0 37 80 00       	push   $0x8037b0
  80130c:	e8 55 f2 ff ff       	call   800566 <cprintf>
  801311:	83 c4 10             	add    $0x10,%esp
#if UHP_USE_BUDDY
		initialize_buddy();
		cprintf("BUDDY SYSTEM IS INITIALIZED\n");
#endif
		FirstTimeFlag = 0;
  801314:	c7 05 04 40 80 00 00 	movl   $0x0,0x804004
  80131b:	00 00 00 
	}
}
  80131e:	90                   	nop
  80131f:	c9                   	leave  
  801320:	c3                   	ret    

00801321 <initialize_dyn_block_system>:

//=================================
// [1] INITIALIZE DYNAMIC ALLOCATOR:
//=================================
void initialize_dyn_block_system()
{
  801321:	55                   	push   %ebp
  801322:	89 e5                	mov    %esp,%ebp
  801324:	83 ec 28             	sub    $0x28,%esp
	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] initialize_dyn_block_system
	// your code is here, remove the panic and write your code
	//panic("initialize_dyn_block_system() is not implemented yet...!!");

	LIST_INIT(&AllocMemBlocksList);
  801327:	c7 05 40 40 80 00 00 	movl   $0x0,0x804040
  80132e:	00 00 00 
  801331:	c7 05 44 40 80 00 00 	movl   $0x0,0x804044
  801338:	00 00 00 
  80133b:	c7 05 4c 40 80 00 00 	movl   $0x0,0x80404c
  801342:	00 00 00 
	LIST_INIT(&FreeMemBlocksList);
  801345:	c7 05 38 41 80 00 00 	movl   $0x0,0x804138
  80134c:	00 00 00 
  80134f:	c7 05 3c 41 80 00 00 	movl   $0x0,0x80413c
  801356:	00 00 00 
  801359:	c7 05 44 41 80 00 00 	movl   $0x0,0x804144
  801360:	00 00 00 
	MAX_MEM_BLOCK_CNT = NUM_OF_UHEAP_PAGES;
  801363:	c7 05 20 41 80 00 00 	movl   $0x20000,0x804120
  80136a:	00 02 00 
	MemBlockNodes = (void*)USER_DYN_BLKS_ARRAY;
  80136d:	c7 45 f4 00 00 e0 7f 	movl   $0x7fe00000,-0xc(%ebp)
  801374:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801377:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80137c:	2d 00 10 00 00       	sub    $0x1000,%eax
  801381:	a3 50 40 80 00       	mov    %eax,0x804050
	int size_of_block = sizeof(struct MemBlock);
  801386:	c7 45 f0 10 00 00 00 	movl   $0x10,-0x10(%ebp)
	int size_all_struct = size_of_block*MAX_MEM_BLOCK_CNT;
  80138d:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801390:	a1 20 41 80 00       	mov    0x804120,%eax
  801395:	0f af c2             	imul   %edx,%eax
  801398:	89 45 ec             	mov    %eax,-0x14(%ebp)
	size_all_struct = ROUNDUP(size_all_struct, PAGE_SIZE);
  80139b:	c7 45 e8 00 10 00 00 	movl   $0x1000,-0x18(%ebp)
  8013a2:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8013a5:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8013a8:	01 d0                	add    %edx,%eax
  8013aa:	48                   	dec    %eax
  8013ab:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8013ae:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8013b1:	ba 00 00 00 00       	mov    $0x0,%edx
  8013b6:	f7 75 e8             	divl   -0x18(%ebp)
  8013b9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8013bc:	29 d0                	sub    %edx,%eax
  8013be:	89 45 ec             	mov    %eax,-0x14(%ebp)
	sys_allocate_chunk(USER_DYN_BLKS_ARRAY, size_all_struct,PERM_USER| PERM_WRITEABLE);
  8013c1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8013c4:	c7 45 e0 00 00 e0 7f 	movl   $0x7fe00000,-0x20(%ebp)
  8013cb:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8013ce:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
  8013d4:	81 ea 00 10 00 00    	sub    $0x1000,%edx
  8013da:	83 ec 04             	sub    $0x4,%esp
  8013dd:	6a 06                	push   $0x6
  8013df:	50                   	push   %eax
  8013e0:	52                   	push   %edx
  8013e1:	e8 a1 05 00 00       	call   801987 <sys_allocate_chunk>
  8013e6:	83 c4 10             	add    $0x10,%esp
	initialize_MemBlocksList(MAX_MEM_BLOCK_CNT);
  8013e9:	a1 20 41 80 00       	mov    0x804120,%eax
  8013ee:	83 ec 0c             	sub    $0xc,%esp
  8013f1:	50                   	push   %eax
  8013f2:	e8 16 0c 00 00       	call   80200d <initialize_MemBlocksList>
  8013f7:	83 c4 10             	add    $0x10,%esp
	struct MemBlock* ourBlock =LIST_LAST(&AvailableMemBlocksList);
  8013fa:	a1 4c 41 80 00       	mov    0x80414c,%eax
  8013ff:	89 45 dc             	mov    %eax,-0x24(%ebp)
	LIST_REMOVE(&AvailableMemBlocksList,ourBlock);
  801402:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  801406:	75 14                	jne    80141c <initialize_dyn_block_system+0xfb>
  801408:	83 ec 04             	sub    $0x4,%esp
  80140b:	68 d5 37 80 00       	push   $0x8037d5
  801410:	6a 2d                	push   $0x2d
  801412:	68 f3 37 80 00       	push   $0x8037f3
  801417:	e8 70 1a 00 00       	call   802e8c <_panic>
  80141c:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80141f:	8b 00                	mov    (%eax),%eax
  801421:	85 c0                	test   %eax,%eax
  801423:	74 10                	je     801435 <initialize_dyn_block_system+0x114>
  801425:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801428:	8b 00                	mov    (%eax),%eax
  80142a:	8b 55 dc             	mov    -0x24(%ebp),%edx
  80142d:	8b 52 04             	mov    0x4(%edx),%edx
  801430:	89 50 04             	mov    %edx,0x4(%eax)
  801433:	eb 0b                	jmp    801440 <initialize_dyn_block_system+0x11f>
  801435:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801438:	8b 40 04             	mov    0x4(%eax),%eax
  80143b:	a3 4c 41 80 00       	mov    %eax,0x80414c
  801440:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801443:	8b 40 04             	mov    0x4(%eax),%eax
  801446:	85 c0                	test   %eax,%eax
  801448:	74 0f                	je     801459 <initialize_dyn_block_system+0x138>
  80144a:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80144d:	8b 40 04             	mov    0x4(%eax),%eax
  801450:	8b 55 dc             	mov    -0x24(%ebp),%edx
  801453:	8b 12                	mov    (%edx),%edx
  801455:	89 10                	mov    %edx,(%eax)
  801457:	eb 0a                	jmp    801463 <initialize_dyn_block_system+0x142>
  801459:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80145c:	8b 00                	mov    (%eax),%eax
  80145e:	a3 48 41 80 00       	mov    %eax,0x804148
  801463:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801466:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80146c:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80146f:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  801476:	a1 54 41 80 00       	mov    0x804154,%eax
  80147b:	48                   	dec    %eax
  80147c:	a3 54 41 80 00       	mov    %eax,0x804154
	ourBlock->size = USER_HEAP_MAX-USER_HEAP_START;
  801481:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801484:	c7 40 0c 00 00 00 20 	movl   $0x20000000,0xc(%eax)
	ourBlock->sva=USER_HEAP_START;
  80148b:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80148e:	c7 40 08 00 00 00 80 	movl   $0x80000000,0x8(%eax)
	LIST_INSERT_TAIL(&FreeMemBlocksList, ourBlock);
  801495:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  801499:	75 14                	jne    8014af <initialize_dyn_block_system+0x18e>
  80149b:	83 ec 04             	sub    $0x4,%esp
  80149e:	68 00 38 80 00       	push   $0x803800
  8014a3:	6a 30                	push   $0x30
  8014a5:	68 f3 37 80 00       	push   $0x8037f3
  8014aa:	e8 dd 19 00 00       	call   802e8c <_panic>
  8014af:	8b 15 3c 41 80 00    	mov    0x80413c,%edx
  8014b5:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8014b8:	89 50 04             	mov    %edx,0x4(%eax)
  8014bb:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8014be:	8b 40 04             	mov    0x4(%eax),%eax
  8014c1:	85 c0                	test   %eax,%eax
  8014c3:	74 0c                	je     8014d1 <initialize_dyn_block_system+0x1b0>
  8014c5:	a1 3c 41 80 00       	mov    0x80413c,%eax
  8014ca:	8b 55 dc             	mov    -0x24(%ebp),%edx
  8014cd:	89 10                	mov    %edx,(%eax)
  8014cf:	eb 08                	jmp    8014d9 <initialize_dyn_block_system+0x1b8>
  8014d1:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8014d4:	a3 38 41 80 00       	mov    %eax,0x804138
  8014d9:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8014dc:	a3 3c 41 80 00       	mov    %eax,0x80413c
  8014e1:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8014e4:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8014ea:	a1 44 41 80 00       	mov    0x804144,%eax
  8014ef:	40                   	inc    %eax
  8014f0:	a3 44 41 80 00       	mov    %eax,0x804144
	//[1] Initialize two lists (AllocMemBlocksList & FreeMemBlocksList) [Hint: use LIST_INIT()]
	//[2] Dynamically allocate the array of MemBlockNodes at VA USER_DYN_BLKS_ARRAY
	//	  (remember to set MAX_MEM_BLOCK_CNT with the chosen size of the array)
	//[3] Initialize AvailableMemBlocksList by filling it with the MemBlockNodes
	//[4] Insert a new MemBlock with the heap size into the FreeMemBlocksList
}
  8014f5:	90                   	nop
  8014f6:	c9                   	leave  
  8014f7:	c3                   	ret    

008014f8 <malloc>:
//=================================
// [2] ALLOCATE SPACE IN USER HEAP:
//=================================

void* malloc(uint32 size)
{
  8014f8:	55                   	push   %ebp
  8014f9:	89 e5                	mov    %esp,%ebp
  8014fb:	83 ec 18             	sub    $0x18,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  8014fe:	e8 ed fd ff ff       	call   8012f0 <InitializeUHeap>
	if (size == 0) return NULL ;
  801503:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801507:	75 07                	jne    801510 <malloc+0x18>
  801509:	b8 00 00 00 00       	mov    $0x0,%eax
  80150e:	eb 67                	jmp    801577 <malloc+0x7f>

	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] malloc
	// your code is here, remove the panic and write your code
	//panic("malloc() is not implemented yet...!!");

	size = ROUNDUP(size, PAGE_SIZE);
  801510:	c7 45 f4 00 10 00 00 	movl   $0x1000,-0xc(%ebp)
  801517:	8b 55 08             	mov    0x8(%ebp),%edx
  80151a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80151d:	01 d0                	add    %edx,%eax
  80151f:	48                   	dec    %eax
  801520:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801523:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801526:	ba 00 00 00 00       	mov    $0x0,%edx
  80152b:	f7 75 f4             	divl   -0xc(%ebp)
  80152e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801531:	29 d0                	sub    %edx,%eax
  801533:	89 45 08             	mov    %eax,0x8(%ebp)
	if(sys_isUHeapPlacementStrategyFIRSTFIT())
  801536:	e8 1a 08 00 00       	call   801d55 <sys_isUHeapPlacementStrategyFIRSTFIT>
  80153b:	85 c0                	test   %eax,%eax
  80153d:	74 33                	je     801572 <malloc+0x7a>
	{
		struct MemBlock * myBlock = alloc_block_FF(size);
  80153f:	83 ec 0c             	sub    $0xc,%esp
  801542:	ff 75 08             	pushl  0x8(%ebp)
  801545:	e8 0c 0e 00 00       	call   802356 <alloc_block_FF>
  80154a:	83 c4 10             	add    $0x10,%esp
  80154d:	89 45 ec             	mov    %eax,-0x14(%ebp)
		if(myBlock != NULL)
  801550:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  801554:	74 1c                	je     801572 <malloc+0x7a>
		{
			insert_sorted_allocList(myBlock);
  801556:	83 ec 0c             	sub    $0xc,%esp
  801559:	ff 75 ec             	pushl  -0x14(%ebp)
  80155c:	e8 07 0c 00 00       	call   802168 <insert_sorted_allocList>
  801561:	83 c4 10             	add    $0x10,%esp
			uint32 ptr = myBlock->sva;
  801564:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801567:	8b 40 08             	mov    0x8(%eax),%eax
  80156a:	89 45 e8             	mov    %eax,-0x18(%ebp)
			return (void *)ptr;
  80156d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801570:	eb 05                	jmp    801577 <malloc+0x7f>
		}
	}
	return NULL;
  801572:	b8 00 00 00 00       	mov    $0x0,%eax
	//		to the required allocation size (space should be on 4 KB BOUNDARY)
	//	2) if no suitable space found, return NULL
	// 	3) Return pointer containing the virtual address of allocated space,
	//
	//Use sys_isUHeapPlacementStrategyFIRSTFIT()... to check the current strategy
}
  801577:	c9                   	leave  
  801578:	c3                   	ret    

00801579 <free>:
//	We can use sys_free_user_mem(uint32 virtual_address, uint32 size); which
//		switches to the kernel mode, calls free_user_mem() in
//		"kern/mem/chunk_operations.c", then switch back to the user mode here
//	the free_user_mem function is empty, make sure to implement it.
void free(void* virtual_address)
{
  801579:	55                   	push   %ebp
  80157a:	89 e5                	mov    %esp,%ebp
  80157c:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] free
	// your code is here, remove the panic and write your code
	//panic("free() is not implemented yet...!!");

	uint32 virtualAddress = (uint32 )(virtual_address);
  80157f:	8b 45 08             	mov    0x8(%ebp),%eax
  801582:	89 45 f4             	mov    %eax,-0xc(%ebp)
//	virtualAddress = ROUNDDOWN(virtualAddress, PAGE_SIZE);
	struct MemBlock * myBlock = find_block(&AllocMemBlocksList, virtualAddress);
  801585:	83 ec 08             	sub    $0x8,%esp
  801588:	ff 75 f4             	pushl  -0xc(%ebp)
  80158b:	68 40 40 80 00       	push   $0x804040
  801590:	e8 5b 0b 00 00       	call   8020f0 <find_block>
  801595:	83 c4 10             	add    $0x10,%esp
  801598:	89 45 f0             	mov    %eax,-0x10(%ebp)
//	cprintf ("ptr sva at free user side = %x \n", myBlock->sva);
	sys_free_user_mem(virtualAddress, myBlock->size);
  80159b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80159e:	8b 40 0c             	mov    0xc(%eax),%eax
  8015a1:	83 ec 08             	sub    $0x8,%esp
  8015a4:	50                   	push   %eax
  8015a5:	ff 75 f4             	pushl  -0xc(%ebp)
  8015a8:	e8 a2 03 00 00       	call   80194f <sys_free_user_mem>
  8015ad:	83 c4 10             	add    $0x10,%esp
	LIST_REMOVE(&AllocMemBlocksList, myBlock);
  8015b0:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8015b4:	75 14                	jne    8015ca <free+0x51>
  8015b6:	83 ec 04             	sub    $0x4,%esp
  8015b9:	68 d5 37 80 00       	push   $0x8037d5
  8015be:	6a 76                	push   $0x76
  8015c0:	68 f3 37 80 00       	push   $0x8037f3
  8015c5:	e8 c2 18 00 00       	call   802e8c <_panic>
  8015ca:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8015cd:	8b 00                	mov    (%eax),%eax
  8015cf:	85 c0                	test   %eax,%eax
  8015d1:	74 10                	je     8015e3 <free+0x6a>
  8015d3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8015d6:	8b 00                	mov    (%eax),%eax
  8015d8:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8015db:	8b 52 04             	mov    0x4(%edx),%edx
  8015de:	89 50 04             	mov    %edx,0x4(%eax)
  8015e1:	eb 0b                	jmp    8015ee <free+0x75>
  8015e3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8015e6:	8b 40 04             	mov    0x4(%eax),%eax
  8015e9:	a3 44 40 80 00       	mov    %eax,0x804044
  8015ee:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8015f1:	8b 40 04             	mov    0x4(%eax),%eax
  8015f4:	85 c0                	test   %eax,%eax
  8015f6:	74 0f                	je     801607 <free+0x8e>
  8015f8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8015fb:	8b 40 04             	mov    0x4(%eax),%eax
  8015fe:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801601:	8b 12                	mov    (%edx),%edx
  801603:	89 10                	mov    %edx,(%eax)
  801605:	eb 0a                	jmp    801611 <free+0x98>
  801607:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80160a:	8b 00                	mov    (%eax),%eax
  80160c:	a3 40 40 80 00       	mov    %eax,0x804040
  801611:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801614:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80161a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80161d:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  801624:	a1 4c 40 80 00       	mov    0x80404c,%eax
  801629:	48                   	dec    %eax
  80162a:	a3 4c 40 80 00       	mov    %eax,0x80404c
	insert_sorted_with_merge_freeList(myBlock);
  80162f:	83 ec 0c             	sub    $0xc,%esp
  801632:	ff 75 f0             	pushl  -0x10(%ebp)
  801635:	e8 0b 14 00 00       	call   802a45 <insert_sorted_with_merge_freeList>
  80163a:	83 c4 10             	add    $0x10,%esp

	//you should get the size of the given allocation using its address
	//you need to call sys_free_user_mem()
	//refer to the project presentation and documentation for details
}
  80163d:	90                   	nop
  80163e:	c9                   	leave  
  80163f:	c3                   	ret    

00801640 <smalloc>:

//=================================
// [4] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
  801640:	55                   	push   %ebp
  801641:	89 e5                	mov    %esp,%ebp
  801643:	83 ec 28             	sub    $0x28,%esp
  801646:	8b 45 10             	mov    0x10(%ebp),%eax
  801649:	88 45 e4             	mov    %al,-0x1c(%ebp)
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  80164c:	e8 9f fc ff ff       	call   8012f0 <InitializeUHeap>
	if (size == 0) return NULL ;
  801651:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801655:	75 0a                	jne    801661 <smalloc+0x21>
  801657:	b8 00 00 00 00       	mov    $0x0,%eax
  80165c:	e9 8d 00 00 00       	jmp    8016ee <smalloc+0xae>

	//This function should find the space of the required range
	// * ON 4KB BOUNDARY **** //
	//Use sys_isUHeapPlacementStrategyFIRSTFIT() to check the current strategy

	size = ROUNDUP(size, PAGE_SIZE);
  801661:	c7 45 f4 00 10 00 00 	movl   $0x1000,-0xc(%ebp)
  801668:	8b 55 0c             	mov    0xc(%ebp),%edx
  80166b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80166e:	01 d0                	add    %edx,%eax
  801670:	48                   	dec    %eax
  801671:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801674:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801677:	ba 00 00 00 00       	mov    $0x0,%edx
  80167c:	f7 75 f4             	divl   -0xc(%ebp)
  80167f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801682:	29 d0                	sub    %edx,%eax
  801684:	89 45 0c             	mov    %eax,0xc(%ebp)
		if(sys_isUHeapPlacementStrategyFIRSTFIT())
  801687:	e8 c9 06 00 00       	call   801d55 <sys_isUHeapPlacementStrategyFIRSTFIT>
  80168c:	85 c0                	test   %eax,%eax
  80168e:	74 59                	je     8016e9 <smalloc+0xa9>
		{
			struct MemBlock * v1=NULL;
  801690:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
			v1= alloc_block_FF(size);
  801697:	83 ec 0c             	sub    $0xc,%esp
  80169a:	ff 75 0c             	pushl  0xc(%ebp)
  80169d:	e8 b4 0c 00 00       	call   802356 <alloc_block_FF>
  8016a2:	83 c4 10             	add    $0x10,%esp
  8016a5:	89 45 ec             	mov    %eax,-0x14(%ebp)
			if(v1==NULL)
  8016a8:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8016ac:	75 07                	jne    8016b5 <smalloc+0x75>
			{
				return NULL;
  8016ae:	b8 00 00 00 00       	mov    $0x0,%eax
  8016b3:	eb 39                	jmp    8016ee <smalloc+0xae>
			}
			else
			{
				int ret=sys_createSharedObject(sharedVarName,  size,  isWritable,(void*)v1->sva);
  8016b5:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8016b8:	8b 40 08             	mov    0x8(%eax),%eax
  8016bb:	89 c2                	mov    %eax,%edx
  8016bd:	0f b6 45 e4          	movzbl -0x1c(%ebp),%eax
  8016c1:	52                   	push   %edx
  8016c2:	50                   	push   %eax
  8016c3:	ff 75 0c             	pushl  0xc(%ebp)
  8016c6:	ff 75 08             	pushl  0x8(%ebp)
  8016c9:	e8 0c 04 00 00       	call   801ada <sys_createSharedObject>
  8016ce:	83 c4 10             	add    $0x10,%esp
  8016d1:	89 45 e8             	mov    %eax,-0x18(%ebp)
				if(ret>=0)
  8016d4:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8016d8:	78 08                	js     8016e2 <smalloc+0xa2>
				{
					return (void*)v1->sva;
  8016da:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8016dd:	8b 40 08             	mov    0x8(%eax),%eax
  8016e0:	eb 0c                	jmp    8016ee <smalloc+0xae>
				}
				else
				{
					return NULL;
  8016e2:	b8 00 00 00 00       	mov    $0x0,%eax
  8016e7:	eb 05                	jmp    8016ee <smalloc+0xae>
				}
			}

		}
		return NULL;
  8016e9:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8016ee:	c9                   	leave  
  8016ef:	c3                   	ret    

008016f0 <sget>:

//========================================
// [5] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  8016f0:	55                   	push   %ebp
  8016f1:	89 e5                	mov    %esp,%ebp
  8016f3:	83 ec 18             	sub    $0x18,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  8016f6:	e8 f5 fb ff ff       	call   8012f0 <InitializeUHeap>

	//This function should find the space for sharing the variable
	// *** ON 4KB BOUNDARY ******** //

	//Use sys_isUHeapPlacementStrategyFIRSTFIT() to check the current strategy
	int ret=sys_getSizeOfSharedObject(ownerEnvID,sharedVarName);
  8016fb:	83 ec 08             	sub    $0x8,%esp
  8016fe:	ff 75 0c             	pushl  0xc(%ebp)
  801701:	ff 75 08             	pushl  0x8(%ebp)
  801704:	e8 fb 03 00 00       	call   801b04 <sys_getSizeOfSharedObject>
  801709:	83 c4 10             	add    $0x10,%esp
  80170c:	89 45 f4             	mov    %eax,-0xc(%ebp)
	if(ret==0)
  80170f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801713:	75 07                	jne    80171c <sget+0x2c>
	{
		return NULL;
  801715:	b8 00 00 00 00       	mov    $0x0,%eax
  80171a:	eb 64                	jmp    801780 <sget+0x90>
	}
	if(sys_isUHeapPlacementStrategyFIRSTFIT())
  80171c:	e8 34 06 00 00       	call   801d55 <sys_isUHeapPlacementStrategyFIRSTFIT>
  801721:	85 c0                	test   %eax,%eax
  801723:	74 56                	je     80177b <sget+0x8b>
	{
		struct MemBlock * v1=NULL;
  801725:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
		v1= alloc_block_FF(ret);
  80172c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80172f:	83 ec 0c             	sub    $0xc,%esp
  801732:	50                   	push   %eax
  801733:	e8 1e 0c 00 00       	call   802356 <alloc_block_FF>
  801738:	83 c4 10             	add    $0x10,%esp
  80173b:	89 45 f0             	mov    %eax,-0x10(%ebp)
		if(v1==NULL)
  80173e:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801742:	75 07                	jne    80174b <sget+0x5b>
		{
		return NULL;
  801744:	b8 00 00 00 00       	mov    $0x0,%eax
  801749:	eb 35                	jmp    801780 <sget+0x90>
	    }
		else
		{
			int ret1=sys_getSharedObject(ownerEnvID,sharedVarName,(void*)v1->sva);
  80174b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80174e:	8b 40 08             	mov    0x8(%eax),%eax
  801751:	83 ec 04             	sub    $0x4,%esp
  801754:	50                   	push   %eax
  801755:	ff 75 0c             	pushl  0xc(%ebp)
  801758:	ff 75 08             	pushl  0x8(%ebp)
  80175b:	e8 c1 03 00 00       	call   801b21 <sys_getSharedObject>
  801760:	83 c4 10             	add    $0x10,%esp
  801763:	89 45 ec             	mov    %eax,-0x14(%ebp)
			if(ret1>=0)
  801766:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  80176a:	78 08                	js     801774 <sget+0x84>
			{
				return (void*)v1->sva;
  80176c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80176f:	8b 40 08             	mov    0x8(%eax),%eax
  801772:	eb 0c                	jmp    801780 <sget+0x90>
			}
			else
			{
				return NULL;
  801774:	b8 00 00 00 00       	mov    $0x0,%eax
  801779:	eb 05                	jmp    801780 <sget+0x90>
			}
		}
	}
  return NULL;
  80177b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801780:	c9                   	leave  
  801781:	c3                   	ret    

00801782 <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  801782:	55                   	push   %ebp
  801783:	89 e5                	mov    %esp,%ebp
  801785:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801788:	e8 63 fb ff ff       	call   8012f0 <InitializeUHeap>
	//==============================================================
	// [USER HEAP - USER SIDE] realloc
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  80178d:	83 ec 04             	sub    $0x4,%esp
  801790:	68 24 38 80 00       	push   $0x803824
  801795:	68 0e 01 00 00       	push   $0x10e
  80179a:	68 f3 37 80 00       	push   $0x8037f3
  80179f:	e8 e8 16 00 00       	call   802e8c <_panic>

008017a4 <sfree>:
//	use sys_freeSharedObject(...); which switches to the kernel mode,
//	calls freeSharedObject(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the freeSharedObject() function is empty, make sure to implement it.

void sfree(void* virtual_address)
{
  8017a4:	55                   	push   %ebp
  8017a5:	89 e5                	mov    %esp,%ebp
  8017a7:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS3 - BONUS] [SHARING - USER SIDE] sfree()

	// Write your code here, remove the panic and write your code
	panic("sfree() is not implemented yet...!!");
  8017aa:	83 ec 04             	sub    $0x4,%esp
  8017ad:	68 4c 38 80 00       	push   $0x80384c
  8017b2:	68 22 01 00 00       	push   $0x122
  8017b7:	68 f3 37 80 00       	push   $0x8037f3
  8017bc:	e8 cb 16 00 00       	call   802e8c <_panic>

008017c1 <expand>:

//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//
void expand(uint32 newSize)
{
  8017c1:	55                   	push   %ebp
  8017c2:	89 e5                	mov    %esp,%ebp
  8017c4:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  8017c7:	83 ec 04             	sub    $0x4,%esp
  8017ca:	68 70 38 80 00       	push   $0x803870
  8017cf:	68 2d 01 00 00       	push   $0x12d
  8017d4:	68 f3 37 80 00       	push   $0x8037f3
  8017d9:	e8 ae 16 00 00       	call   802e8c <_panic>

008017de <shrink>:

}
void shrink(uint32 newSize)
{
  8017de:	55                   	push   %ebp
  8017df:	89 e5                	mov    %esp,%ebp
  8017e1:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  8017e4:	83 ec 04             	sub    $0x4,%esp
  8017e7:	68 70 38 80 00       	push   $0x803870
  8017ec:	68 32 01 00 00       	push   $0x132
  8017f1:	68 f3 37 80 00       	push   $0x8037f3
  8017f6:	e8 91 16 00 00       	call   802e8c <_panic>

008017fb <freeHeap>:

}
void freeHeap(void* virtual_address)
{
  8017fb:	55                   	push   %ebp
  8017fc:	89 e5                	mov    %esp,%ebp
  8017fe:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801801:	83 ec 04             	sub    $0x4,%esp
  801804:	68 70 38 80 00       	push   $0x803870
  801809:	68 37 01 00 00       	push   $0x137
  80180e:	68 f3 37 80 00       	push   $0x8037f3
  801813:	e8 74 16 00 00       	call   802e8c <_panic>

00801818 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  801818:	55                   	push   %ebp
  801819:	89 e5                	mov    %esp,%ebp
  80181b:	57                   	push   %edi
  80181c:	56                   	push   %esi
  80181d:	53                   	push   %ebx
  80181e:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801821:	8b 45 08             	mov    0x8(%ebp),%eax
  801824:	8b 55 0c             	mov    0xc(%ebp),%edx
  801827:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80182a:	8b 5d 14             	mov    0x14(%ebp),%ebx
  80182d:	8b 7d 18             	mov    0x18(%ebp),%edi
  801830:	8b 75 1c             	mov    0x1c(%ebp),%esi
  801833:	cd 30                	int    $0x30
  801835:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  801838:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  80183b:	83 c4 10             	add    $0x10,%esp
  80183e:	5b                   	pop    %ebx
  80183f:	5e                   	pop    %esi
  801840:	5f                   	pop    %edi
  801841:	5d                   	pop    %ebp
  801842:	c3                   	ret    

00801843 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  801843:	55                   	push   %ebp
  801844:	89 e5                	mov    %esp,%ebp
  801846:	83 ec 04             	sub    $0x4,%esp
  801849:	8b 45 10             	mov    0x10(%ebp),%eax
  80184c:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  80184f:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801853:	8b 45 08             	mov    0x8(%ebp),%eax
  801856:	6a 00                	push   $0x0
  801858:	6a 00                	push   $0x0
  80185a:	52                   	push   %edx
  80185b:	ff 75 0c             	pushl  0xc(%ebp)
  80185e:	50                   	push   %eax
  80185f:	6a 00                	push   $0x0
  801861:	e8 b2 ff ff ff       	call   801818 <syscall>
  801866:	83 c4 18             	add    $0x18,%esp
}
  801869:	90                   	nop
  80186a:	c9                   	leave  
  80186b:	c3                   	ret    

0080186c <sys_cgetc>:

int
sys_cgetc(void)
{
  80186c:	55                   	push   %ebp
  80186d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  80186f:	6a 00                	push   $0x0
  801871:	6a 00                	push   $0x0
  801873:	6a 00                	push   $0x0
  801875:	6a 00                	push   $0x0
  801877:	6a 00                	push   $0x0
  801879:	6a 01                	push   $0x1
  80187b:	e8 98 ff ff ff       	call   801818 <syscall>
  801880:	83 c4 18             	add    $0x18,%esp
}
  801883:	c9                   	leave  
  801884:	c3                   	ret    

00801885 <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  801885:	55                   	push   %ebp
  801886:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  801888:	8b 55 0c             	mov    0xc(%ebp),%edx
  80188b:	8b 45 08             	mov    0x8(%ebp),%eax
  80188e:	6a 00                	push   $0x0
  801890:	6a 00                	push   $0x0
  801892:	6a 00                	push   $0x0
  801894:	52                   	push   %edx
  801895:	50                   	push   %eax
  801896:	6a 05                	push   $0x5
  801898:	e8 7b ff ff ff       	call   801818 <syscall>
  80189d:	83 c4 18             	add    $0x18,%esp
}
  8018a0:	c9                   	leave  
  8018a1:	c3                   	ret    

008018a2 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  8018a2:	55                   	push   %ebp
  8018a3:	89 e5                	mov    %esp,%ebp
  8018a5:	56                   	push   %esi
  8018a6:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  8018a7:	8b 75 18             	mov    0x18(%ebp),%esi
  8018aa:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8018ad:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8018b0:	8b 55 0c             	mov    0xc(%ebp),%edx
  8018b3:	8b 45 08             	mov    0x8(%ebp),%eax
  8018b6:	56                   	push   %esi
  8018b7:	53                   	push   %ebx
  8018b8:	51                   	push   %ecx
  8018b9:	52                   	push   %edx
  8018ba:	50                   	push   %eax
  8018bb:	6a 06                	push   $0x6
  8018bd:	e8 56 ff ff ff       	call   801818 <syscall>
  8018c2:	83 c4 18             	add    $0x18,%esp
}
  8018c5:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8018c8:	5b                   	pop    %ebx
  8018c9:	5e                   	pop    %esi
  8018ca:	5d                   	pop    %ebp
  8018cb:	c3                   	ret    

008018cc <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  8018cc:	55                   	push   %ebp
  8018cd:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  8018cf:	8b 55 0c             	mov    0xc(%ebp),%edx
  8018d2:	8b 45 08             	mov    0x8(%ebp),%eax
  8018d5:	6a 00                	push   $0x0
  8018d7:	6a 00                	push   $0x0
  8018d9:	6a 00                	push   $0x0
  8018db:	52                   	push   %edx
  8018dc:	50                   	push   %eax
  8018dd:	6a 07                	push   $0x7
  8018df:	e8 34 ff ff ff       	call   801818 <syscall>
  8018e4:	83 c4 18             	add    $0x18,%esp
}
  8018e7:	c9                   	leave  
  8018e8:	c3                   	ret    

008018e9 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  8018e9:	55                   	push   %ebp
  8018ea:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  8018ec:	6a 00                	push   $0x0
  8018ee:	6a 00                	push   $0x0
  8018f0:	6a 00                	push   $0x0
  8018f2:	ff 75 0c             	pushl  0xc(%ebp)
  8018f5:	ff 75 08             	pushl  0x8(%ebp)
  8018f8:	6a 08                	push   $0x8
  8018fa:	e8 19 ff ff ff       	call   801818 <syscall>
  8018ff:	83 c4 18             	add    $0x18,%esp
}
  801902:	c9                   	leave  
  801903:	c3                   	ret    

00801904 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  801904:	55                   	push   %ebp
  801905:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  801907:	6a 00                	push   $0x0
  801909:	6a 00                	push   $0x0
  80190b:	6a 00                	push   $0x0
  80190d:	6a 00                	push   $0x0
  80190f:	6a 00                	push   $0x0
  801911:	6a 09                	push   $0x9
  801913:	e8 00 ff ff ff       	call   801818 <syscall>
  801918:	83 c4 18             	add    $0x18,%esp
}
  80191b:	c9                   	leave  
  80191c:	c3                   	ret    

0080191d <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  80191d:	55                   	push   %ebp
  80191e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  801920:	6a 00                	push   $0x0
  801922:	6a 00                	push   $0x0
  801924:	6a 00                	push   $0x0
  801926:	6a 00                	push   $0x0
  801928:	6a 00                	push   $0x0
  80192a:	6a 0a                	push   $0xa
  80192c:	e8 e7 fe ff ff       	call   801818 <syscall>
  801931:	83 c4 18             	add    $0x18,%esp
}
  801934:	c9                   	leave  
  801935:	c3                   	ret    

00801936 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  801936:	55                   	push   %ebp
  801937:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  801939:	6a 00                	push   $0x0
  80193b:	6a 00                	push   $0x0
  80193d:	6a 00                	push   $0x0
  80193f:	6a 00                	push   $0x0
  801941:	6a 00                	push   $0x0
  801943:	6a 0b                	push   $0xb
  801945:	e8 ce fe ff ff       	call   801818 <syscall>
  80194a:	83 c4 18             	add    $0x18,%esp
}
  80194d:	c9                   	leave  
  80194e:	c3                   	ret    

0080194f <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  80194f:	55                   	push   %ebp
  801950:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  801952:	6a 00                	push   $0x0
  801954:	6a 00                	push   $0x0
  801956:	6a 00                	push   $0x0
  801958:	ff 75 0c             	pushl  0xc(%ebp)
  80195b:	ff 75 08             	pushl  0x8(%ebp)
  80195e:	6a 0f                	push   $0xf
  801960:	e8 b3 fe ff ff       	call   801818 <syscall>
  801965:	83 c4 18             	add    $0x18,%esp
	return;
  801968:	90                   	nop
}
  801969:	c9                   	leave  
  80196a:	c3                   	ret    

0080196b <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  80196b:	55                   	push   %ebp
  80196c:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  80196e:	6a 00                	push   $0x0
  801970:	6a 00                	push   $0x0
  801972:	6a 00                	push   $0x0
  801974:	ff 75 0c             	pushl  0xc(%ebp)
  801977:	ff 75 08             	pushl  0x8(%ebp)
  80197a:	6a 10                	push   $0x10
  80197c:	e8 97 fe ff ff       	call   801818 <syscall>
  801981:	83 c4 18             	add    $0x18,%esp
	return ;
  801984:	90                   	nop
}
  801985:	c9                   	leave  
  801986:	c3                   	ret    

00801987 <sys_allocate_chunk>:

void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  801987:	55                   	push   %ebp
  801988:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  80198a:	6a 00                	push   $0x0
  80198c:	6a 00                	push   $0x0
  80198e:	ff 75 10             	pushl  0x10(%ebp)
  801991:	ff 75 0c             	pushl  0xc(%ebp)
  801994:	ff 75 08             	pushl  0x8(%ebp)
  801997:	6a 11                	push   $0x11
  801999:	e8 7a fe ff ff       	call   801818 <syscall>
  80199e:	83 c4 18             	add    $0x18,%esp
	return ;
  8019a1:	90                   	nop
}
  8019a2:	c9                   	leave  
  8019a3:	c3                   	ret    

008019a4 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  8019a4:	55                   	push   %ebp
  8019a5:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  8019a7:	6a 00                	push   $0x0
  8019a9:	6a 00                	push   $0x0
  8019ab:	6a 00                	push   $0x0
  8019ad:	6a 00                	push   $0x0
  8019af:	6a 00                	push   $0x0
  8019b1:	6a 0c                	push   $0xc
  8019b3:	e8 60 fe ff ff       	call   801818 <syscall>
  8019b8:	83 c4 18             	add    $0x18,%esp
}
  8019bb:	c9                   	leave  
  8019bc:	c3                   	ret    

008019bd <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  8019bd:	55                   	push   %ebp
  8019be:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  8019c0:	6a 00                	push   $0x0
  8019c2:	6a 00                	push   $0x0
  8019c4:	6a 00                	push   $0x0
  8019c6:	6a 00                	push   $0x0
  8019c8:	ff 75 08             	pushl  0x8(%ebp)
  8019cb:	6a 0d                	push   $0xd
  8019cd:	e8 46 fe ff ff       	call   801818 <syscall>
  8019d2:	83 c4 18             	add    $0x18,%esp
}
  8019d5:	c9                   	leave  
  8019d6:	c3                   	ret    

008019d7 <sys_scarce_memory>:

void sys_scarce_memory()
{
  8019d7:	55                   	push   %ebp
  8019d8:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  8019da:	6a 00                	push   $0x0
  8019dc:	6a 00                	push   $0x0
  8019de:	6a 00                	push   $0x0
  8019e0:	6a 00                	push   $0x0
  8019e2:	6a 00                	push   $0x0
  8019e4:	6a 0e                	push   $0xe
  8019e6:	e8 2d fe ff ff       	call   801818 <syscall>
  8019eb:	83 c4 18             	add    $0x18,%esp
}
  8019ee:	90                   	nop
  8019ef:	c9                   	leave  
  8019f0:	c3                   	ret    

008019f1 <sys_disable_interrupt>:

//NEW !! 2012...
void
sys_disable_interrupt()
{
  8019f1:	55                   	push   %ebp
  8019f2:	89 e5                	mov    %esp,%ebp
	syscall(SYS_disableINTR,0, 0, 0, 0, 0);
  8019f4:	6a 00                	push   $0x0
  8019f6:	6a 00                	push   $0x0
  8019f8:	6a 00                	push   $0x0
  8019fa:	6a 00                	push   $0x0
  8019fc:	6a 00                	push   $0x0
  8019fe:	6a 13                	push   $0x13
  801a00:	e8 13 fe ff ff       	call   801818 <syscall>
  801a05:	83 c4 18             	add    $0x18,%esp
}
  801a08:	90                   	nop
  801a09:	c9                   	leave  
  801a0a:	c3                   	ret    

00801a0b <sys_enable_interrupt>:


void
sys_enable_interrupt()
{
  801a0b:	55                   	push   %ebp
  801a0c:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enableINTR,0, 0, 0, 0, 0);
  801a0e:	6a 00                	push   $0x0
  801a10:	6a 00                	push   $0x0
  801a12:	6a 00                	push   $0x0
  801a14:	6a 00                	push   $0x0
  801a16:	6a 00                	push   $0x0
  801a18:	6a 14                	push   $0x14
  801a1a:	e8 f9 fd ff ff       	call   801818 <syscall>
  801a1f:	83 c4 18             	add    $0x18,%esp
}
  801a22:	90                   	nop
  801a23:	c9                   	leave  
  801a24:	c3                   	ret    

00801a25 <sys_cputc>:


void
sys_cputc(const char c)
{
  801a25:	55                   	push   %ebp
  801a26:	89 e5                	mov    %esp,%ebp
  801a28:	83 ec 04             	sub    $0x4,%esp
  801a2b:	8b 45 08             	mov    0x8(%ebp),%eax
  801a2e:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  801a31:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801a35:	6a 00                	push   $0x0
  801a37:	6a 00                	push   $0x0
  801a39:	6a 00                	push   $0x0
  801a3b:	6a 00                	push   $0x0
  801a3d:	50                   	push   %eax
  801a3e:	6a 15                	push   $0x15
  801a40:	e8 d3 fd ff ff       	call   801818 <syscall>
  801a45:	83 c4 18             	add    $0x18,%esp
}
  801a48:	90                   	nop
  801a49:	c9                   	leave  
  801a4a:	c3                   	ret    

00801a4b <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  801a4b:	55                   	push   %ebp
  801a4c:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  801a4e:	6a 00                	push   $0x0
  801a50:	6a 00                	push   $0x0
  801a52:	6a 00                	push   $0x0
  801a54:	6a 00                	push   $0x0
  801a56:	6a 00                	push   $0x0
  801a58:	6a 16                	push   $0x16
  801a5a:	e8 b9 fd ff ff       	call   801818 <syscall>
  801a5f:	83 c4 18             	add    $0x18,%esp
}
  801a62:	90                   	nop
  801a63:	c9                   	leave  
  801a64:	c3                   	ret    

00801a65 <sys_createSemaphore>:

int
sys_createSemaphore(char* semaphoreName, uint32 initialValue)
{
  801a65:	55                   	push   %ebp
  801a66:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_semaphore,(uint32)semaphoreName, (uint32)initialValue, 0, 0, 0);
  801a68:	8b 45 08             	mov    0x8(%ebp),%eax
  801a6b:	6a 00                	push   $0x0
  801a6d:	6a 00                	push   $0x0
  801a6f:	6a 00                	push   $0x0
  801a71:	ff 75 0c             	pushl  0xc(%ebp)
  801a74:	50                   	push   %eax
  801a75:	6a 17                	push   $0x17
  801a77:	e8 9c fd ff ff       	call   801818 <syscall>
  801a7c:	83 c4 18             	add    $0x18,%esp
}
  801a7f:	c9                   	leave  
  801a80:	c3                   	ret    

00801a81 <sys_getSemaphoreValue>:

int
sys_getSemaphoreValue(int32 ownerEnvID, char* semaphoreName)
{
  801a81:	55                   	push   %ebp
  801a82:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_semaphore_value,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801a84:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a87:	8b 45 08             	mov    0x8(%ebp),%eax
  801a8a:	6a 00                	push   $0x0
  801a8c:	6a 00                	push   $0x0
  801a8e:	6a 00                	push   $0x0
  801a90:	52                   	push   %edx
  801a91:	50                   	push   %eax
  801a92:	6a 1a                	push   $0x1a
  801a94:	e8 7f fd ff ff       	call   801818 <syscall>
  801a99:	83 c4 18             	add    $0x18,%esp
}
  801a9c:	c9                   	leave  
  801a9d:	c3                   	ret    

00801a9e <sys_waitSemaphore>:

void
sys_waitSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801a9e:	55                   	push   %ebp
  801a9f:	89 e5                	mov    %esp,%ebp
	syscall(SYS_wait_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801aa1:	8b 55 0c             	mov    0xc(%ebp),%edx
  801aa4:	8b 45 08             	mov    0x8(%ebp),%eax
  801aa7:	6a 00                	push   $0x0
  801aa9:	6a 00                	push   $0x0
  801aab:	6a 00                	push   $0x0
  801aad:	52                   	push   %edx
  801aae:	50                   	push   %eax
  801aaf:	6a 18                	push   $0x18
  801ab1:	e8 62 fd ff ff       	call   801818 <syscall>
  801ab6:	83 c4 18             	add    $0x18,%esp
}
  801ab9:	90                   	nop
  801aba:	c9                   	leave  
  801abb:	c3                   	ret    

00801abc <sys_signalSemaphore>:

void
sys_signalSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801abc:	55                   	push   %ebp
  801abd:	89 e5                	mov    %esp,%ebp
	syscall(SYS_signal_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801abf:	8b 55 0c             	mov    0xc(%ebp),%edx
  801ac2:	8b 45 08             	mov    0x8(%ebp),%eax
  801ac5:	6a 00                	push   $0x0
  801ac7:	6a 00                	push   $0x0
  801ac9:	6a 00                	push   $0x0
  801acb:	52                   	push   %edx
  801acc:	50                   	push   %eax
  801acd:	6a 19                	push   $0x19
  801acf:	e8 44 fd ff ff       	call   801818 <syscall>
  801ad4:	83 c4 18             	add    $0x18,%esp
}
  801ad7:	90                   	nop
  801ad8:	c9                   	leave  
  801ad9:	c3                   	ret    

00801ada <sys_createSharedObject>:

int
sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  801ada:	55                   	push   %ebp
  801adb:	89 e5                	mov    %esp,%ebp
  801add:	83 ec 04             	sub    $0x4,%esp
  801ae0:	8b 45 10             	mov    0x10(%ebp),%eax
  801ae3:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  801ae6:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801ae9:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801aed:	8b 45 08             	mov    0x8(%ebp),%eax
  801af0:	6a 00                	push   $0x0
  801af2:	51                   	push   %ecx
  801af3:	52                   	push   %edx
  801af4:	ff 75 0c             	pushl  0xc(%ebp)
  801af7:	50                   	push   %eax
  801af8:	6a 1b                	push   $0x1b
  801afa:	e8 19 fd ff ff       	call   801818 <syscall>
  801aff:	83 c4 18             	add    $0x18,%esp
}
  801b02:	c9                   	leave  
  801b03:	c3                   	ret    

00801b04 <sys_getSizeOfSharedObject>:

//2017:
int
sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  801b04:	55                   	push   %ebp
  801b05:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  801b07:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b0a:	8b 45 08             	mov    0x8(%ebp),%eax
  801b0d:	6a 00                	push   $0x0
  801b0f:	6a 00                	push   $0x0
  801b11:	6a 00                	push   $0x0
  801b13:	52                   	push   %edx
  801b14:	50                   	push   %eax
  801b15:	6a 1c                	push   $0x1c
  801b17:	e8 fc fc ff ff       	call   801818 <syscall>
  801b1c:	83 c4 18             	add    $0x18,%esp
}
  801b1f:	c9                   	leave  
  801b20:	c3                   	ret    

00801b21 <sys_getSharedObject>:
//==========

int
sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  801b21:	55                   	push   %ebp
  801b22:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  801b24:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801b27:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b2a:	8b 45 08             	mov    0x8(%ebp),%eax
  801b2d:	6a 00                	push   $0x0
  801b2f:	6a 00                	push   $0x0
  801b31:	51                   	push   %ecx
  801b32:	52                   	push   %edx
  801b33:	50                   	push   %eax
  801b34:	6a 1d                	push   $0x1d
  801b36:	e8 dd fc ff ff       	call   801818 <syscall>
  801b3b:	83 c4 18             	add    $0x18,%esp
}
  801b3e:	c9                   	leave  
  801b3f:	c3                   	ret    

00801b40 <sys_freeSharedObject>:

int
sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  801b40:	55                   	push   %ebp
  801b41:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  801b43:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b46:	8b 45 08             	mov    0x8(%ebp),%eax
  801b49:	6a 00                	push   $0x0
  801b4b:	6a 00                	push   $0x0
  801b4d:	6a 00                	push   $0x0
  801b4f:	52                   	push   %edx
  801b50:	50                   	push   %eax
  801b51:	6a 1e                	push   $0x1e
  801b53:	e8 c0 fc ff ff       	call   801818 <syscall>
  801b58:	83 c4 18             	add    $0x18,%esp
}
  801b5b:	c9                   	leave  
  801b5c:	c3                   	ret    

00801b5d <sys_getMaxShares>:

uint32 	sys_getMaxShares()
{
  801b5d:	55                   	push   %ebp
  801b5e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_max_shares,0, 0, 0, 0, 0);
  801b60:	6a 00                	push   $0x0
  801b62:	6a 00                	push   $0x0
  801b64:	6a 00                	push   $0x0
  801b66:	6a 00                	push   $0x0
  801b68:	6a 00                	push   $0x0
  801b6a:	6a 1f                	push   $0x1f
  801b6c:	e8 a7 fc ff ff       	call   801818 <syscall>
  801b71:	83 c4 18             	add    $0x18,%esp
}
  801b74:	c9                   	leave  
  801b75:	c3                   	ret    

00801b76 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  801b76:	55                   	push   %ebp
  801b77:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  801b79:	8b 45 08             	mov    0x8(%ebp),%eax
  801b7c:	6a 00                	push   $0x0
  801b7e:	ff 75 14             	pushl  0x14(%ebp)
  801b81:	ff 75 10             	pushl  0x10(%ebp)
  801b84:	ff 75 0c             	pushl  0xc(%ebp)
  801b87:	50                   	push   %eax
  801b88:	6a 20                	push   $0x20
  801b8a:	e8 89 fc ff ff       	call   801818 <syscall>
  801b8f:	83 c4 18             	add    $0x18,%esp
}
  801b92:	c9                   	leave  
  801b93:	c3                   	ret    

00801b94 <sys_run_env>:

void
sys_run_env(int32 envId)
{
  801b94:	55                   	push   %ebp
  801b95:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  801b97:	8b 45 08             	mov    0x8(%ebp),%eax
  801b9a:	6a 00                	push   $0x0
  801b9c:	6a 00                	push   $0x0
  801b9e:	6a 00                	push   $0x0
  801ba0:	6a 00                	push   $0x0
  801ba2:	50                   	push   %eax
  801ba3:	6a 21                	push   $0x21
  801ba5:	e8 6e fc ff ff       	call   801818 <syscall>
  801baa:	83 c4 18             	add    $0x18,%esp
}
  801bad:	90                   	nop
  801bae:	c9                   	leave  
  801baf:	c3                   	ret    

00801bb0 <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  801bb0:	55                   	push   %ebp
  801bb1:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  801bb3:	8b 45 08             	mov    0x8(%ebp),%eax
  801bb6:	6a 00                	push   $0x0
  801bb8:	6a 00                	push   $0x0
  801bba:	6a 00                	push   $0x0
  801bbc:	6a 00                	push   $0x0
  801bbe:	50                   	push   %eax
  801bbf:	6a 22                	push   $0x22
  801bc1:	e8 52 fc ff ff       	call   801818 <syscall>
  801bc6:	83 c4 18             	add    $0x18,%esp
}
  801bc9:	c9                   	leave  
  801bca:	c3                   	ret    

00801bcb <sys_getenvid>:

int32 sys_getenvid(void)
{
  801bcb:	55                   	push   %ebp
  801bcc:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  801bce:	6a 00                	push   $0x0
  801bd0:	6a 00                	push   $0x0
  801bd2:	6a 00                	push   $0x0
  801bd4:	6a 00                	push   $0x0
  801bd6:	6a 00                	push   $0x0
  801bd8:	6a 02                	push   $0x2
  801bda:	e8 39 fc ff ff       	call   801818 <syscall>
  801bdf:	83 c4 18             	add    $0x18,%esp
}
  801be2:	c9                   	leave  
  801be3:	c3                   	ret    

00801be4 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  801be4:	55                   	push   %ebp
  801be5:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  801be7:	6a 00                	push   $0x0
  801be9:	6a 00                	push   $0x0
  801beb:	6a 00                	push   $0x0
  801bed:	6a 00                	push   $0x0
  801bef:	6a 00                	push   $0x0
  801bf1:	6a 03                	push   $0x3
  801bf3:	e8 20 fc ff ff       	call   801818 <syscall>
  801bf8:	83 c4 18             	add    $0x18,%esp
}
  801bfb:	c9                   	leave  
  801bfc:	c3                   	ret    

00801bfd <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  801bfd:	55                   	push   %ebp
  801bfe:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  801c00:	6a 00                	push   $0x0
  801c02:	6a 00                	push   $0x0
  801c04:	6a 00                	push   $0x0
  801c06:	6a 00                	push   $0x0
  801c08:	6a 00                	push   $0x0
  801c0a:	6a 04                	push   $0x4
  801c0c:	e8 07 fc ff ff       	call   801818 <syscall>
  801c11:	83 c4 18             	add    $0x18,%esp
}
  801c14:	c9                   	leave  
  801c15:	c3                   	ret    

00801c16 <sys_exit_env>:


void sys_exit_env(void)
{
  801c16:	55                   	push   %ebp
  801c17:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  801c19:	6a 00                	push   $0x0
  801c1b:	6a 00                	push   $0x0
  801c1d:	6a 00                	push   $0x0
  801c1f:	6a 00                	push   $0x0
  801c21:	6a 00                	push   $0x0
  801c23:	6a 23                	push   $0x23
  801c25:	e8 ee fb ff ff       	call   801818 <syscall>
  801c2a:	83 c4 18             	add    $0x18,%esp
}
  801c2d:	90                   	nop
  801c2e:	c9                   	leave  
  801c2f:	c3                   	ret    

00801c30 <sys_get_virtual_time>:


struct uint64
sys_get_virtual_time()
{
  801c30:	55                   	push   %ebp
  801c31:	89 e5                	mov    %esp,%ebp
  801c33:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  801c36:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801c39:	8d 50 04             	lea    0x4(%eax),%edx
  801c3c:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801c3f:	6a 00                	push   $0x0
  801c41:	6a 00                	push   $0x0
  801c43:	6a 00                	push   $0x0
  801c45:	52                   	push   %edx
  801c46:	50                   	push   %eax
  801c47:	6a 24                	push   $0x24
  801c49:	e8 ca fb ff ff       	call   801818 <syscall>
  801c4e:	83 c4 18             	add    $0x18,%esp
	return result;
  801c51:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801c54:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801c57:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801c5a:	89 01                	mov    %eax,(%ecx)
  801c5c:	89 51 04             	mov    %edx,0x4(%ecx)
}
  801c5f:	8b 45 08             	mov    0x8(%ebp),%eax
  801c62:	c9                   	leave  
  801c63:	c2 04 00             	ret    $0x4

00801c66 <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  801c66:	55                   	push   %ebp
  801c67:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  801c69:	6a 00                	push   $0x0
  801c6b:	6a 00                	push   $0x0
  801c6d:	ff 75 10             	pushl  0x10(%ebp)
  801c70:	ff 75 0c             	pushl  0xc(%ebp)
  801c73:	ff 75 08             	pushl  0x8(%ebp)
  801c76:	6a 12                	push   $0x12
  801c78:	e8 9b fb ff ff       	call   801818 <syscall>
  801c7d:	83 c4 18             	add    $0x18,%esp
	return ;
  801c80:	90                   	nop
}
  801c81:	c9                   	leave  
  801c82:	c3                   	ret    

00801c83 <sys_rcr2>:
uint32 sys_rcr2()
{
  801c83:	55                   	push   %ebp
  801c84:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  801c86:	6a 00                	push   $0x0
  801c88:	6a 00                	push   $0x0
  801c8a:	6a 00                	push   $0x0
  801c8c:	6a 00                	push   $0x0
  801c8e:	6a 00                	push   $0x0
  801c90:	6a 25                	push   $0x25
  801c92:	e8 81 fb ff ff       	call   801818 <syscall>
  801c97:	83 c4 18             	add    $0x18,%esp
}
  801c9a:	c9                   	leave  
  801c9b:	c3                   	ret    

00801c9c <sys_bypassPageFault>:
void sys_bypassPageFault(uint8 instrLength)
{
  801c9c:	55                   	push   %ebp
  801c9d:	89 e5                	mov    %esp,%ebp
  801c9f:	83 ec 04             	sub    $0x4,%esp
  801ca2:	8b 45 08             	mov    0x8(%ebp),%eax
  801ca5:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  801ca8:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  801cac:	6a 00                	push   $0x0
  801cae:	6a 00                	push   $0x0
  801cb0:	6a 00                	push   $0x0
  801cb2:	6a 00                	push   $0x0
  801cb4:	50                   	push   %eax
  801cb5:	6a 26                	push   $0x26
  801cb7:	e8 5c fb ff ff       	call   801818 <syscall>
  801cbc:	83 c4 18             	add    $0x18,%esp
	return ;
  801cbf:	90                   	nop
}
  801cc0:	c9                   	leave  
  801cc1:	c3                   	ret    

00801cc2 <rsttst>:
void rsttst()
{
  801cc2:	55                   	push   %ebp
  801cc3:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  801cc5:	6a 00                	push   $0x0
  801cc7:	6a 00                	push   $0x0
  801cc9:	6a 00                	push   $0x0
  801ccb:	6a 00                	push   $0x0
  801ccd:	6a 00                	push   $0x0
  801ccf:	6a 28                	push   $0x28
  801cd1:	e8 42 fb ff ff       	call   801818 <syscall>
  801cd6:	83 c4 18             	add    $0x18,%esp
	return ;
  801cd9:	90                   	nop
}
  801cda:	c9                   	leave  
  801cdb:	c3                   	ret    

00801cdc <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  801cdc:	55                   	push   %ebp
  801cdd:	89 e5                	mov    %esp,%ebp
  801cdf:	83 ec 04             	sub    $0x4,%esp
  801ce2:	8b 45 14             	mov    0x14(%ebp),%eax
  801ce5:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  801ce8:	8b 55 18             	mov    0x18(%ebp),%edx
  801ceb:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801cef:	52                   	push   %edx
  801cf0:	50                   	push   %eax
  801cf1:	ff 75 10             	pushl  0x10(%ebp)
  801cf4:	ff 75 0c             	pushl  0xc(%ebp)
  801cf7:	ff 75 08             	pushl  0x8(%ebp)
  801cfa:	6a 27                	push   $0x27
  801cfc:	e8 17 fb ff ff       	call   801818 <syscall>
  801d01:	83 c4 18             	add    $0x18,%esp
	return ;
  801d04:	90                   	nop
}
  801d05:	c9                   	leave  
  801d06:	c3                   	ret    

00801d07 <chktst>:
void chktst(uint32 n)
{
  801d07:	55                   	push   %ebp
  801d08:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  801d0a:	6a 00                	push   $0x0
  801d0c:	6a 00                	push   $0x0
  801d0e:	6a 00                	push   $0x0
  801d10:	6a 00                	push   $0x0
  801d12:	ff 75 08             	pushl  0x8(%ebp)
  801d15:	6a 29                	push   $0x29
  801d17:	e8 fc fa ff ff       	call   801818 <syscall>
  801d1c:	83 c4 18             	add    $0x18,%esp
	return ;
  801d1f:	90                   	nop
}
  801d20:	c9                   	leave  
  801d21:	c3                   	ret    

00801d22 <inctst>:

void inctst()
{
  801d22:	55                   	push   %ebp
  801d23:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  801d25:	6a 00                	push   $0x0
  801d27:	6a 00                	push   $0x0
  801d29:	6a 00                	push   $0x0
  801d2b:	6a 00                	push   $0x0
  801d2d:	6a 00                	push   $0x0
  801d2f:	6a 2a                	push   $0x2a
  801d31:	e8 e2 fa ff ff       	call   801818 <syscall>
  801d36:	83 c4 18             	add    $0x18,%esp
	return ;
  801d39:	90                   	nop
}
  801d3a:	c9                   	leave  
  801d3b:	c3                   	ret    

00801d3c <gettst>:
uint32 gettst()
{
  801d3c:	55                   	push   %ebp
  801d3d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  801d3f:	6a 00                	push   $0x0
  801d41:	6a 00                	push   $0x0
  801d43:	6a 00                	push   $0x0
  801d45:	6a 00                	push   $0x0
  801d47:	6a 00                	push   $0x0
  801d49:	6a 2b                	push   $0x2b
  801d4b:	e8 c8 fa ff ff       	call   801818 <syscall>
  801d50:	83 c4 18             	add    $0x18,%esp
}
  801d53:	c9                   	leave  
  801d54:	c3                   	ret    

00801d55 <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  801d55:	55                   	push   %ebp
  801d56:	89 e5                	mov    %esp,%ebp
  801d58:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801d5b:	6a 00                	push   $0x0
  801d5d:	6a 00                	push   $0x0
  801d5f:	6a 00                	push   $0x0
  801d61:	6a 00                	push   $0x0
  801d63:	6a 00                	push   $0x0
  801d65:	6a 2c                	push   $0x2c
  801d67:	e8 ac fa ff ff       	call   801818 <syscall>
  801d6c:	83 c4 18             	add    $0x18,%esp
  801d6f:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  801d72:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  801d76:	75 07                	jne    801d7f <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  801d78:	b8 01 00 00 00       	mov    $0x1,%eax
  801d7d:	eb 05                	jmp    801d84 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  801d7f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801d84:	c9                   	leave  
  801d85:	c3                   	ret    

00801d86 <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  801d86:	55                   	push   %ebp
  801d87:	89 e5                	mov    %esp,%ebp
  801d89:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801d8c:	6a 00                	push   $0x0
  801d8e:	6a 00                	push   $0x0
  801d90:	6a 00                	push   $0x0
  801d92:	6a 00                	push   $0x0
  801d94:	6a 00                	push   $0x0
  801d96:	6a 2c                	push   $0x2c
  801d98:	e8 7b fa ff ff       	call   801818 <syscall>
  801d9d:	83 c4 18             	add    $0x18,%esp
  801da0:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  801da3:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  801da7:	75 07                	jne    801db0 <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  801da9:	b8 01 00 00 00       	mov    $0x1,%eax
  801dae:	eb 05                	jmp    801db5 <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  801db0:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801db5:	c9                   	leave  
  801db6:	c3                   	ret    

00801db7 <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  801db7:	55                   	push   %ebp
  801db8:	89 e5                	mov    %esp,%ebp
  801dba:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801dbd:	6a 00                	push   $0x0
  801dbf:	6a 00                	push   $0x0
  801dc1:	6a 00                	push   $0x0
  801dc3:	6a 00                	push   $0x0
  801dc5:	6a 00                	push   $0x0
  801dc7:	6a 2c                	push   $0x2c
  801dc9:	e8 4a fa ff ff       	call   801818 <syscall>
  801dce:	83 c4 18             	add    $0x18,%esp
  801dd1:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  801dd4:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  801dd8:	75 07                	jne    801de1 <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  801dda:	b8 01 00 00 00       	mov    $0x1,%eax
  801ddf:	eb 05                	jmp    801de6 <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  801de1:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801de6:	c9                   	leave  
  801de7:	c3                   	ret    

00801de8 <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  801de8:	55                   	push   %ebp
  801de9:	89 e5                	mov    %esp,%ebp
  801deb:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801dee:	6a 00                	push   $0x0
  801df0:	6a 00                	push   $0x0
  801df2:	6a 00                	push   $0x0
  801df4:	6a 00                	push   $0x0
  801df6:	6a 00                	push   $0x0
  801df8:	6a 2c                	push   $0x2c
  801dfa:	e8 19 fa ff ff       	call   801818 <syscall>
  801dff:	83 c4 18             	add    $0x18,%esp
  801e02:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  801e05:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  801e09:	75 07                	jne    801e12 <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  801e0b:	b8 01 00 00 00       	mov    $0x1,%eax
  801e10:	eb 05                	jmp    801e17 <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  801e12:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801e17:	c9                   	leave  
  801e18:	c3                   	ret    

00801e19 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  801e19:	55                   	push   %ebp
  801e1a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  801e1c:	6a 00                	push   $0x0
  801e1e:	6a 00                	push   $0x0
  801e20:	6a 00                	push   $0x0
  801e22:	6a 00                	push   $0x0
  801e24:	ff 75 08             	pushl  0x8(%ebp)
  801e27:	6a 2d                	push   $0x2d
  801e29:	e8 ea f9 ff ff       	call   801818 <syscall>
  801e2e:	83 c4 18             	add    $0x18,%esp
	return ;
  801e31:	90                   	nop
}
  801e32:	c9                   	leave  
  801e33:	c3                   	ret    

00801e34 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  801e34:	55                   	push   %ebp
  801e35:	89 e5                	mov    %esp,%ebp
  801e37:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  801e38:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801e3b:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801e3e:	8b 55 0c             	mov    0xc(%ebp),%edx
  801e41:	8b 45 08             	mov    0x8(%ebp),%eax
  801e44:	6a 00                	push   $0x0
  801e46:	53                   	push   %ebx
  801e47:	51                   	push   %ecx
  801e48:	52                   	push   %edx
  801e49:	50                   	push   %eax
  801e4a:	6a 2e                	push   $0x2e
  801e4c:	e8 c7 f9 ff ff       	call   801818 <syscall>
  801e51:	83 c4 18             	add    $0x18,%esp
}
  801e54:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801e57:	c9                   	leave  
  801e58:	c3                   	ret    

00801e59 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  801e59:	55                   	push   %ebp
  801e5a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  801e5c:	8b 55 0c             	mov    0xc(%ebp),%edx
  801e5f:	8b 45 08             	mov    0x8(%ebp),%eax
  801e62:	6a 00                	push   $0x0
  801e64:	6a 00                	push   $0x0
  801e66:	6a 00                	push   $0x0
  801e68:	52                   	push   %edx
  801e69:	50                   	push   %eax
  801e6a:	6a 2f                	push   $0x2f
  801e6c:	e8 a7 f9 ff ff       	call   801818 <syscall>
  801e71:	83 c4 18             	add    $0x18,%esp
}
  801e74:	c9                   	leave  
  801e75:	c3                   	ret    

00801e76 <print_mem_block_lists>:
//===========================
// PRINT MEM BLOCK LISTS:
//===========================

void print_mem_block_lists()
{
  801e76:	55                   	push   %ebp
  801e77:	89 e5                	mov    %esp,%ebp
  801e79:	83 ec 18             	sub    $0x18,%esp
	cprintf("\n=========================================\n");
  801e7c:	83 ec 0c             	sub    $0xc,%esp
  801e7f:	68 80 38 80 00       	push   $0x803880
  801e84:	e8 dd e6 ff ff       	call   800566 <cprintf>
  801e89:	83 c4 10             	add    $0x10,%esp
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
  801e8c:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nFreeMemBlocksList:\n");
  801e93:	83 ec 0c             	sub    $0xc,%esp
  801e96:	68 ac 38 80 00       	push   $0x8038ac
  801e9b:	e8 c6 e6 ff ff       	call   800566 <cprintf>
  801ea0:	83 c4 10             	add    $0x10,%esp
	uint8 sorted = 1 ;
  801ea3:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &FreeMemBlocksList)
  801ea7:	a1 38 41 80 00       	mov    0x804138,%eax
  801eac:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801eaf:	eb 56                	jmp    801f07 <print_mem_block_lists+0x91>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  801eb1:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801eb5:	74 1c                	je     801ed3 <print_mem_block_lists+0x5d>
  801eb7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801eba:	8b 50 08             	mov    0x8(%eax),%edx
  801ebd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801ec0:	8b 48 08             	mov    0x8(%eax),%ecx
  801ec3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801ec6:	8b 40 0c             	mov    0xc(%eax),%eax
  801ec9:	01 c8                	add    %ecx,%eax
  801ecb:	39 c2                	cmp    %eax,%edx
  801ecd:	73 04                	jae    801ed3 <print_mem_block_lists+0x5d>
			sorted = 0 ;
  801ecf:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  801ed3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ed6:	8b 50 08             	mov    0x8(%eax),%edx
  801ed9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801edc:	8b 40 0c             	mov    0xc(%eax),%eax
  801edf:	01 c2                	add    %eax,%edx
  801ee1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ee4:	8b 40 08             	mov    0x8(%eax),%eax
  801ee7:	83 ec 04             	sub    $0x4,%esp
  801eea:	52                   	push   %edx
  801eeb:	50                   	push   %eax
  801eec:	68 c1 38 80 00       	push   $0x8038c1
  801ef1:	e8 70 e6 ff ff       	call   800566 <cprintf>
  801ef6:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  801ef9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801efc:	89 45 f0             	mov    %eax,-0x10(%ebp)
	cprintf("\n=========================================\n");
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
	cprintf("\nFreeMemBlocksList:\n");
	uint8 sorted = 1 ;
	LIST_FOREACH(blk, &FreeMemBlocksList)
  801eff:	a1 40 41 80 00       	mov    0x804140,%eax
  801f04:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801f07:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801f0b:	74 07                	je     801f14 <print_mem_block_lists+0x9e>
  801f0d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f10:	8b 00                	mov    (%eax),%eax
  801f12:	eb 05                	jmp    801f19 <print_mem_block_lists+0xa3>
  801f14:	b8 00 00 00 00       	mov    $0x0,%eax
  801f19:	a3 40 41 80 00       	mov    %eax,0x804140
  801f1e:	a1 40 41 80 00       	mov    0x804140,%eax
  801f23:	85 c0                	test   %eax,%eax
  801f25:	75 8a                	jne    801eb1 <print_mem_block_lists+0x3b>
  801f27:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801f2b:	75 84                	jne    801eb1 <print_mem_block_lists+0x3b>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;
  801f2d:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  801f31:	75 10                	jne    801f43 <print_mem_block_lists+0xcd>
  801f33:	83 ec 0c             	sub    $0xc,%esp
  801f36:	68 d0 38 80 00       	push   $0x8038d0
  801f3b:	e8 26 e6 ff ff       	call   800566 <cprintf>
  801f40:	83 c4 10             	add    $0x10,%esp

	lastBlk = NULL ;
  801f43:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nAllocMemBlocksList:\n");
  801f4a:	83 ec 0c             	sub    $0xc,%esp
  801f4d:	68 f4 38 80 00       	push   $0x8038f4
  801f52:	e8 0f e6 ff ff       	call   800566 <cprintf>
  801f57:	83 c4 10             	add    $0x10,%esp
	sorted = 1 ;
  801f5a:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &AllocMemBlocksList)
  801f5e:	a1 40 40 80 00       	mov    0x804040,%eax
  801f63:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801f66:	eb 56                	jmp    801fbe <print_mem_block_lists+0x148>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  801f68:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801f6c:	74 1c                	je     801f8a <print_mem_block_lists+0x114>
  801f6e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f71:	8b 50 08             	mov    0x8(%eax),%edx
  801f74:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801f77:	8b 48 08             	mov    0x8(%eax),%ecx
  801f7a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801f7d:	8b 40 0c             	mov    0xc(%eax),%eax
  801f80:	01 c8                	add    %ecx,%eax
  801f82:	39 c2                	cmp    %eax,%edx
  801f84:	73 04                	jae    801f8a <print_mem_block_lists+0x114>
			sorted = 0 ;
  801f86:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  801f8a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f8d:	8b 50 08             	mov    0x8(%eax),%edx
  801f90:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f93:	8b 40 0c             	mov    0xc(%eax),%eax
  801f96:	01 c2                	add    %eax,%edx
  801f98:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f9b:	8b 40 08             	mov    0x8(%eax),%eax
  801f9e:	83 ec 04             	sub    $0x4,%esp
  801fa1:	52                   	push   %edx
  801fa2:	50                   	push   %eax
  801fa3:	68 c1 38 80 00       	push   $0x8038c1
  801fa8:	e8 b9 e5 ff ff       	call   800566 <cprintf>
  801fad:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  801fb0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801fb3:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;

	lastBlk = NULL ;
	cprintf("\nAllocMemBlocksList:\n");
	sorted = 1 ;
	LIST_FOREACH(blk, &AllocMemBlocksList)
  801fb6:	a1 48 40 80 00       	mov    0x804048,%eax
  801fbb:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801fbe:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801fc2:	74 07                	je     801fcb <print_mem_block_lists+0x155>
  801fc4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801fc7:	8b 00                	mov    (%eax),%eax
  801fc9:	eb 05                	jmp    801fd0 <print_mem_block_lists+0x15a>
  801fcb:	b8 00 00 00 00       	mov    $0x0,%eax
  801fd0:	a3 48 40 80 00       	mov    %eax,0x804048
  801fd5:	a1 48 40 80 00       	mov    0x804048,%eax
  801fda:	85 c0                	test   %eax,%eax
  801fdc:	75 8a                	jne    801f68 <print_mem_block_lists+0xf2>
  801fde:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801fe2:	75 84                	jne    801f68 <print_mem_block_lists+0xf2>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nAllocMemBlocksList is NOT SORTED!!\n") ;
  801fe4:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  801fe8:	75 10                	jne    801ffa <print_mem_block_lists+0x184>
  801fea:	83 ec 0c             	sub    $0xc,%esp
  801fed:	68 0c 39 80 00       	push   $0x80390c
  801ff2:	e8 6f e5 ff ff       	call   800566 <cprintf>
  801ff7:	83 c4 10             	add    $0x10,%esp
	cprintf("\n=========================================\n");
  801ffa:	83 ec 0c             	sub    $0xc,%esp
  801ffd:	68 80 38 80 00       	push   $0x803880
  802002:	e8 5f e5 ff ff       	call   800566 <cprintf>
  802007:	83 c4 10             	add    $0x10,%esp

}
  80200a:	90                   	nop
  80200b:	c9                   	leave  
  80200c:	c3                   	ret    

0080200d <initialize_MemBlocksList>:

//===============================
// [1] INITIALIZE AVAILABLE LIST:
//===============================
void initialize_MemBlocksList(uint32 numOfBlocks)
{
  80200d:	55                   	push   %ebp
  80200e:	89 e5                	mov    %esp,%ebp
  802010:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] initialize_MemBlocksList
	// Write your code here, remove the panic and write your code
	//panic("initialize_MemBlocksList() is not implemented yet...!!");
	uint32 n = numOfBlocks;
  802013:	8b 45 08             	mov    0x8(%ebp),%eax
  802016:	89 45 f0             	mov    %eax,-0x10(%ebp)

	LIST_INIT(&AvailableMemBlocksList);
  802019:	c7 05 48 41 80 00 00 	movl   $0x0,0x804148
  802020:	00 00 00 
  802023:	c7 05 4c 41 80 00 00 	movl   $0x0,0x80414c
  80202a:	00 00 00 
  80202d:	c7 05 54 41 80 00 00 	movl   $0x0,0x804154
  802034:	00 00 00 
	for(int i = 0; i<n;i++)
  802037:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  80203e:	e9 9e 00 00 00       	jmp    8020e1 <initialize_MemBlocksList+0xd4>
	{
		LIST_INSERT_HEAD(&AvailableMemBlocksList, &(MemBlockNodes[i]));
  802043:	a1 50 40 80 00       	mov    0x804050,%eax
  802048:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80204b:	c1 e2 04             	shl    $0x4,%edx
  80204e:	01 d0                	add    %edx,%eax
  802050:	85 c0                	test   %eax,%eax
  802052:	75 14                	jne    802068 <initialize_MemBlocksList+0x5b>
  802054:	83 ec 04             	sub    $0x4,%esp
  802057:	68 34 39 80 00       	push   $0x803934
  80205c:	6a 47                	push   $0x47
  80205e:	68 57 39 80 00       	push   $0x803957
  802063:	e8 24 0e 00 00       	call   802e8c <_panic>
  802068:	a1 50 40 80 00       	mov    0x804050,%eax
  80206d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802070:	c1 e2 04             	shl    $0x4,%edx
  802073:	01 d0                	add    %edx,%eax
  802075:	8b 15 48 41 80 00    	mov    0x804148,%edx
  80207b:	89 10                	mov    %edx,(%eax)
  80207d:	8b 00                	mov    (%eax),%eax
  80207f:	85 c0                	test   %eax,%eax
  802081:	74 18                	je     80209b <initialize_MemBlocksList+0x8e>
  802083:	a1 48 41 80 00       	mov    0x804148,%eax
  802088:	8b 15 50 40 80 00    	mov    0x804050,%edx
  80208e:	8b 4d f4             	mov    -0xc(%ebp),%ecx
  802091:	c1 e1 04             	shl    $0x4,%ecx
  802094:	01 ca                	add    %ecx,%edx
  802096:	89 50 04             	mov    %edx,0x4(%eax)
  802099:	eb 12                	jmp    8020ad <initialize_MemBlocksList+0xa0>
  80209b:	a1 50 40 80 00       	mov    0x804050,%eax
  8020a0:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8020a3:	c1 e2 04             	shl    $0x4,%edx
  8020a6:	01 d0                	add    %edx,%eax
  8020a8:	a3 4c 41 80 00       	mov    %eax,0x80414c
  8020ad:	a1 50 40 80 00       	mov    0x804050,%eax
  8020b2:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8020b5:	c1 e2 04             	shl    $0x4,%edx
  8020b8:	01 d0                	add    %edx,%eax
  8020ba:	a3 48 41 80 00       	mov    %eax,0x804148
  8020bf:	a1 50 40 80 00       	mov    0x804050,%eax
  8020c4:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8020c7:	c1 e2 04             	shl    $0x4,%edx
  8020ca:	01 d0                	add    %edx,%eax
  8020cc:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8020d3:	a1 54 41 80 00       	mov    0x804154,%eax
  8020d8:	40                   	inc    %eax
  8020d9:	a3 54 41 80 00       	mov    %eax,0x804154
	// Write your code here, remove the panic and write your code
	//panic("initialize_MemBlocksList() is not implemented yet...!!");
	uint32 n = numOfBlocks;

	LIST_INIT(&AvailableMemBlocksList);
	for(int i = 0; i<n;i++)
  8020de:	ff 45 f4             	incl   -0xc(%ebp)
  8020e1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020e4:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8020e7:	0f 82 56 ff ff ff    	jb     802043 <initialize_MemBlocksList+0x36>
	{
		LIST_INSERT_HEAD(&AvailableMemBlocksList, &(MemBlockNodes[i]));
	}
}
  8020ed:	90                   	nop
  8020ee:	c9                   	leave  
  8020ef:	c3                   	ret    

008020f0 <find_block>:

//===============================
// [2] FIND BLOCK:
//===============================
struct MemBlock *find_block(struct MemBlock_List *blockList, uint32 va)
{
  8020f0:	55                   	push   %ebp
  8020f1:	89 e5                	mov    %esp,%ebp
  8020f3:	83 ec 10             	sub    $0x10,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] find_block
	// Write your code here, remove the panic and write your code
	//panic("find_block() is not implemented yet...!!");
	uint32 virAddress = va;
  8020f6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8020f9:	89 45 f4             	mov    %eax,-0xc(%ebp)
	struct MemBlock* blk;
	int found = 0;
  8020fc:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	LIST_FOREACH(blk, &(AllocMemBlocksList))
  802103:	a1 40 40 80 00       	mov    0x804040,%eax
  802108:	89 45 fc             	mov    %eax,-0x4(%ebp)
  80210b:	eb 23                	jmp    802130 <find_block+0x40>
	{
		if(blk->sva == virAddress)
  80210d:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802110:	8b 40 08             	mov    0x8(%eax),%eax
  802113:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  802116:	75 09                	jne    802121 <find_block+0x31>
		{
			found = 1;
  802118:	c7 45 f8 01 00 00 00 	movl   $0x1,-0x8(%ebp)
			break;
  80211f:	eb 35                	jmp    802156 <find_block+0x66>
		}
		else
		{
			found = 0;
  802121:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	//panic("find_block() is not implemented yet...!!");
	uint32 virAddress = va;
	struct MemBlock* blk;
	int found = 0;

	LIST_FOREACH(blk, &(AllocMemBlocksList))
  802128:	a1 48 40 80 00       	mov    0x804048,%eax
  80212d:	89 45 fc             	mov    %eax,-0x4(%ebp)
  802130:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  802134:	74 07                	je     80213d <find_block+0x4d>
  802136:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802139:	8b 00                	mov    (%eax),%eax
  80213b:	eb 05                	jmp    802142 <find_block+0x52>
  80213d:	b8 00 00 00 00       	mov    $0x0,%eax
  802142:	a3 48 40 80 00       	mov    %eax,0x804048
  802147:	a1 48 40 80 00       	mov    0x804048,%eax
  80214c:	85 c0                	test   %eax,%eax
  80214e:	75 bd                	jne    80210d <find_block+0x1d>
  802150:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  802154:	75 b7                	jne    80210d <find_block+0x1d>
		{
			found = 0;
			continue;
		}
	}
	if(found == 1)
  802156:	83 7d f8 01          	cmpl   $0x1,-0x8(%ebp)
  80215a:	75 05                	jne    802161 <find_block+0x71>
	{
		return blk;
  80215c:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80215f:	eb 05                	jmp    802166 <find_block+0x76>
	}
	else
	{
		return NULL;
  802161:	b8 00 00 00 00       	mov    $0x0,%eax
	}
}
  802166:	c9                   	leave  
  802167:	c3                   	ret    

00802168 <insert_sorted_allocList>:

//=========================================
// [3] INSERT BLOCK IN ALLOC LIST [SORTED]:
//=========================================
void insert_sorted_allocList(struct MemBlock *blockToInsert)
{
  802168:	55                   	push   %ebp
  802169:	89 e5                	mov    %esp,%ebp
  80216b:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] insert_sorted_allocList
	// Write your code here, remove the panic and write your code
	//panic("insert_sorted_allocList() is not implemented yet...!!");
	struct MemBlock* blk;
	struct MemBlock* newblk = blockToInsert;
  80216e:	8b 45 08             	mov    0x8(%ebp),%eax
  802171:	89 45 f0             	mov    %eax,-0x10(%ebp)

	if((LIST_EMPTY(&AllocMemBlocksList)) || (newblk->sva < LIST_FIRST(&AllocMemBlocksList)->sva))
  802174:	a1 40 40 80 00       	mov    0x804040,%eax
  802179:	85 c0                	test   %eax,%eax
  80217b:	74 12                	je     80218f <insert_sorted_allocList+0x27>
  80217d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802180:	8b 50 08             	mov    0x8(%eax),%edx
  802183:	a1 40 40 80 00       	mov    0x804040,%eax
  802188:	8b 40 08             	mov    0x8(%eax),%eax
  80218b:	39 c2                	cmp    %eax,%edx
  80218d:	73 65                	jae    8021f4 <insert_sorted_allocList+0x8c>
	{
		LIST_INSERT_HEAD(&(AllocMemBlocksList), newblk);
  80218f:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802193:	75 14                	jne    8021a9 <insert_sorted_allocList+0x41>
  802195:	83 ec 04             	sub    $0x4,%esp
  802198:	68 34 39 80 00       	push   $0x803934
  80219d:	6a 7b                	push   $0x7b
  80219f:	68 57 39 80 00       	push   $0x803957
  8021a4:	e8 e3 0c 00 00       	call   802e8c <_panic>
  8021a9:	8b 15 40 40 80 00    	mov    0x804040,%edx
  8021af:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8021b2:	89 10                	mov    %edx,(%eax)
  8021b4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8021b7:	8b 00                	mov    (%eax),%eax
  8021b9:	85 c0                	test   %eax,%eax
  8021bb:	74 0d                	je     8021ca <insert_sorted_allocList+0x62>
  8021bd:	a1 40 40 80 00       	mov    0x804040,%eax
  8021c2:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8021c5:	89 50 04             	mov    %edx,0x4(%eax)
  8021c8:	eb 08                	jmp    8021d2 <insert_sorted_allocList+0x6a>
  8021ca:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8021cd:	a3 44 40 80 00       	mov    %eax,0x804044
  8021d2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8021d5:	a3 40 40 80 00       	mov    %eax,0x804040
  8021da:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8021dd:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8021e4:	a1 4c 40 80 00       	mov    0x80404c,%eax
  8021e9:	40                   	inc    %eax
  8021ea:	a3 4c 40 80 00       	mov    %eax,0x80404c
  8021ef:	e9 5f 01 00 00       	jmp    802353 <insert_sorted_allocList+0x1eb>
	}
	else if(newblk->sva > LIST_LAST(&AllocMemBlocksList)->sva)
  8021f4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8021f7:	8b 50 08             	mov    0x8(%eax),%edx
  8021fa:	a1 44 40 80 00       	mov    0x804044,%eax
  8021ff:	8b 40 08             	mov    0x8(%eax),%eax
  802202:	39 c2                	cmp    %eax,%edx
  802204:	76 65                	jbe    80226b <insert_sorted_allocList+0x103>
	{
		LIST_INSERT_TAIL(&AllocMemBlocksList, newblk);
  802206:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80220a:	75 14                	jne    802220 <insert_sorted_allocList+0xb8>
  80220c:	83 ec 04             	sub    $0x4,%esp
  80220f:	68 70 39 80 00       	push   $0x803970
  802214:	6a 7f                	push   $0x7f
  802216:	68 57 39 80 00       	push   $0x803957
  80221b:	e8 6c 0c 00 00       	call   802e8c <_panic>
  802220:	8b 15 44 40 80 00    	mov    0x804044,%edx
  802226:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802229:	89 50 04             	mov    %edx,0x4(%eax)
  80222c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80222f:	8b 40 04             	mov    0x4(%eax),%eax
  802232:	85 c0                	test   %eax,%eax
  802234:	74 0c                	je     802242 <insert_sorted_allocList+0xda>
  802236:	a1 44 40 80 00       	mov    0x804044,%eax
  80223b:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80223e:	89 10                	mov    %edx,(%eax)
  802240:	eb 08                	jmp    80224a <insert_sorted_allocList+0xe2>
  802242:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802245:	a3 40 40 80 00       	mov    %eax,0x804040
  80224a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80224d:	a3 44 40 80 00       	mov    %eax,0x804044
  802252:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802255:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80225b:	a1 4c 40 80 00       	mov    0x80404c,%eax
  802260:	40                   	inc    %eax
  802261:	a3 4c 40 80 00       	mov    %eax,0x80404c
				LIST_INSERT_AFTER(&AllocMemBlocksList, blk, newblk);
				break;
			}
		}
	}
}
  802266:	e9 e8 00 00 00       	jmp    802353 <insert_sorted_allocList+0x1eb>
	{
		LIST_INSERT_TAIL(&AllocMemBlocksList, newblk);
	}
	else
	{
		LIST_FOREACH(blk, &AllocMemBlocksList)
  80226b:	a1 40 40 80 00       	mov    0x804040,%eax
  802270:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802273:	e9 ab 00 00 00       	jmp    802323 <insert_sorted_allocList+0x1bb>
		{
			if(blk->prev_next_info.le_next != NULL && newblk->sva > blk->sva  && newblk->sva < blk->prev_next_info.le_next->sva)
  802278:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80227b:	8b 00                	mov    (%eax),%eax
  80227d:	85 c0                	test   %eax,%eax
  80227f:	0f 84 96 00 00 00    	je     80231b <insert_sorted_allocList+0x1b3>
  802285:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802288:	8b 50 08             	mov    0x8(%eax),%edx
  80228b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80228e:	8b 40 08             	mov    0x8(%eax),%eax
  802291:	39 c2                	cmp    %eax,%edx
  802293:	0f 86 82 00 00 00    	jbe    80231b <insert_sorted_allocList+0x1b3>
  802299:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80229c:	8b 50 08             	mov    0x8(%eax),%edx
  80229f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022a2:	8b 00                	mov    (%eax),%eax
  8022a4:	8b 40 08             	mov    0x8(%eax),%eax
  8022a7:	39 c2                	cmp    %eax,%edx
  8022a9:	73 70                	jae    80231b <insert_sorted_allocList+0x1b3>
			{
				LIST_INSERT_AFTER(&AllocMemBlocksList, blk, newblk);
  8022ab:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8022af:	74 06                	je     8022b7 <insert_sorted_allocList+0x14f>
  8022b1:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8022b5:	75 17                	jne    8022ce <insert_sorted_allocList+0x166>
  8022b7:	83 ec 04             	sub    $0x4,%esp
  8022ba:	68 94 39 80 00       	push   $0x803994
  8022bf:	68 87 00 00 00       	push   $0x87
  8022c4:	68 57 39 80 00       	push   $0x803957
  8022c9:	e8 be 0b 00 00       	call   802e8c <_panic>
  8022ce:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022d1:	8b 10                	mov    (%eax),%edx
  8022d3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8022d6:	89 10                	mov    %edx,(%eax)
  8022d8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8022db:	8b 00                	mov    (%eax),%eax
  8022dd:	85 c0                	test   %eax,%eax
  8022df:	74 0b                	je     8022ec <insert_sorted_allocList+0x184>
  8022e1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022e4:	8b 00                	mov    (%eax),%eax
  8022e6:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8022e9:	89 50 04             	mov    %edx,0x4(%eax)
  8022ec:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022ef:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8022f2:	89 10                	mov    %edx,(%eax)
  8022f4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8022f7:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8022fa:	89 50 04             	mov    %edx,0x4(%eax)
  8022fd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802300:	8b 00                	mov    (%eax),%eax
  802302:	85 c0                	test   %eax,%eax
  802304:	75 08                	jne    80230e <insert_sorted_allocList+0x1a6>
  802306:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802309:	a3 44 40 80 00       	mov    %eax,0x804044
  80230e:	a1 4c 40 80 00       	mov    0x80404c,%eax
  802313:	40                   	inc    %eax
  802314:	a3 4c 40 80 00       	mov    %eax,0x80404c
				break;
  802319:	eb 38                	jmp    802353 <insert_sorted_allocList+0x1eb>
	{
		LIST_INSERT_TAIL(&AllocMemBlocksList, newblk);
	}
	else
	{
		LIST_FOREACH(blk, &AllocMemBlocksList)
  80231b:	a1 48 40 80 00       	mov    0x804048,%eax
  802320:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802323:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802327:	74 07                	je     802330 <insert_sorted_allocList+0x1c8>
  802329:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80232c:	8b 00                	mov    (%eax),%eax
  80232e:	eb 05                	jmp    802335 <insert_sorted_allocList+0x1cd>
  802330:	b8 00 00 00 00       	mov    $0x0,%eax
  802335:	a3 48 40 80 00       	mov    %eax,0x804048
  80233a:	a1 48 40 80 00       	mov    0x804048,%eax
  80233f:	85 c0                	test   %eax,%eax
  802341:	0f 85 31 ff ff ff    	jne    802278 <insert_sorted_allocList+0x110>
  802347:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80234b:	0f 85 27 ff ff ff    	jne    802278 <insert_sorted_allocList+0x110>
				LIST_INSERT_AFTER(&AllocMemBlocksList, blk, newblk);
				break;
			}
		}
	}
}
  802351:	eb 00                	jmp    802353 <insert_sorted_allocList+0x1eb>
  802353:	90                   	nop
  802354:	c9                   	leave  
  802355:	c3                   	ret    

00802356 <alloc_block_FF>:

//=========================================
// [4] ALLOCATE BLOCK BY FIRST FIT:
//=========================================
struct MemBlock *alloc_block_FF(uint32 size)
{
  802356:	55                   	push   %ebp
  802357:	89 e5                	mov    %esp,%ebp
  802359:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_FF
	// Write your code here, remove the panic and write your code
	//panic("alloc_block_FF() is not implemented yet...!!");
	uint32 versize = size;
  80235c:	8b 45 08             	mov    0x8(%ebp),%eax
  80235f:	89 45 f0             	mov    %eax,-0x10(%ebp)
	struct MemBlock* blk;
	struct MemBlock* newblk = LIST_FIRST(&AvailableMemBlocksList);
  802362:	a1 48 41 80 00       	mov    0x804148,%eax
  802367:	89 45 ec             	mov    %eax,-0x14(%ebp)

	LIST_FOREACH(blk,&FreeMemBlocksList)
  80236a:	a1 38 41 80 00       	mov    0x804138,%eax
  80236f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802372:	e9 77 01 00 00       	jmp    8024ee <alloc_block_FF+0x198>
	{
		if(blk->size == versize)
  802377:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80237a:	8b 40 0c             	mov    0xc(%eax),%eax
  80237d:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  802380:	0f 85 8a 00 00 00    	jne    802410 <alloc_block_FF+0xba>
		{
			LIST_REMOVE(&FreeMemBlocksList,blk);
  802386:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80238a:	75 17                	jne    8023a3 <alloc_block_FF+0x4d>
  80238c:	83 ec 04             	sub    $0x4,%esp
  80238f:	68 c8 39 80 00       	push   $0x8039c8
  802394:	68 9e 00 00 00       	push   $0x9e
  802399:	68 57 39 80 00       	push   $0x803957
  80239e:	e8 e9 0a 00 00       	call   802e8c <_panic>
  8023a3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023a6:	8b 00                	mov    (%eax),%eax
  8023a8:	85 c0                	test   %eax,%eax
  8023aa:	74 10                	je     8023bc <alloc_block_FF+0x66>
  8023ac:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023af:	8b 00                	mov    (%eax),%eax
  8023b1:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8023b4:	8b 52 04             	mov    0x4(%edx),%edx
  8023b7:	89 50 04             	mov    %edx,0x4(%eax)
  8023ba:	eb 0b                	jmp    8023c7 <alloc_block_FF+0x71>
  8023bc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023bf:	8b 40 04             	mov    0x4(%eax),%eax
  8023c2:	a3 3c 41 80 00       	mov    %eax,0x80413c
  8023c7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023ca:	8b 40 04             	mov    0x4(%eax),%eax
  8023cd:	85 c0                	test   %eax,%eax
  8023cf:	74 0f                	je     8023e0 <alloc_block_FF+0x8a>
  8023d1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023d4:	8b 40 04             	mov    0x4(%eax),%eax
  8023d7:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8023da:	8b 12                	mov    (%edx),%edx
  8023dc:	89 10                	mov    %edx,(%eax)
  8023de:	eb 0a                	jmp    8023ea <alloc_block_FF+0x94>
  8023e0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023e3:	8b 00                	mov    (%eax),%eax
  8023e5:	a3 38 41 80 00       	mov    %eax,0x804138
  8023ea:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023ed:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8023f3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023f6:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8023fd:	a1 44 41 80 00       	mov    0x804144,%eax
  802402:	48                   	dec    %eax
  802403:	a3 44 41 80 00       	mov    %eax,0x804144
			return blk;
  802408:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80240b:	e9 11 01 00 00       	jmp    802521 <alloc_block_FF+0x1cb>
		}
		else if(blk->size > versize)
  802410:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802413:	8b 40 0c             	mov    0xc(%eax),%eax
  802416:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  802419:	0f 86 c7 00 00 00    	jbe    8024e6 <alloc_block_FF+0x190>
		{
			LIST_REMOVE(&AvailableMemBlocksList,newblk);
  80241f:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802423:	75 17                	jne    80243c <alloc_block_FF+0xe6>
  802425:	83 ec 04             	sub    $0x4,%esp
  802428:	68 c8 39 80 00       	push   $0x8039c8
  80242d:	68 a3 00 00 00       	push   $0xa3
  802432:	68 57 39 80 00       	push   $0x803957
  802437:	e8 50 0a 00 00       	call   802e8c <_panic>
  80243c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80243f:	8b 00                	mov    (%eax),%eax
  802441:	85 c0                	test   %eax,%eax
  802443:	74 10                	je     802455 <alloc_block_FF+0xff>
  802445:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802448:	8b 00                	mov    (%eax),%eax
  80244a:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80244d:	8b 52 04             	mov    0x4(%edx),%edx
  802450:	89 50 04             	mov    %edx,0x4(%eax)
  802453:	eb 0b                	jmp    802460 <alloc_block_FF+0x10a>
  802455:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802458:	8b 40 04             	mov    0x4(%eax),%eax
  80245b:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802460:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802463:	8b 40 04             	mov    0x4(%eax),%eax
  802466:	85 c0                	test   %eax,%eax
  802468:	74 0f                	je     802479 <alloc_block_FF+0x123>
  80246a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80246d:	8b 40 04             	mov    0x4(%eax),%eax
  802470:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802473:	8b 12                	mov    (%edx),%edx
  802475:	89 10                	mov    %edx,(%eax)
  802477:	eb 0a                	jmp    802483 <alloc_block_FF+0x12d>
  802479:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80247c:	8b 00                	mov    (%eax),%eax
  80247e:	a3 48 41 80 00       	mov    %eax,0x804148
  802483:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802486:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80248c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80248f:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802496:	a1 54 41 80 00       	mov    0x804154,%eax
  80249b:	48                   	dec    %eax
  80249c:	a3 54 41 80 00       	mov    %eax,0x804154
			newblk->size = versize;
  8024a1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8024a4:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8024a7:	89 50 0c             	mov    %edx,0xc(%eax)
			blk->size = blk->size-versize;
  8024aa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024ad:	8b 40 0c             	mov    0xc(%eax),%eax
  8024b0:	2b 45 f0             	sub    -0x10(%ebp),%eax
  8024b3:	89 c2                	mov    %eax,%edx
  8024b5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024b8:	89 50 0c             	mov    %edx,0xc(%eax)
			uint32 newveradd = blk->sva;
  8024bb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024be:	8b 40 08             	mov    0x8(%eax),%eax
  8024c1:	89 45 e8             	mov    %eax,-0x18(%ebp)
			blk->sva+=newblk->size;
  8024c4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024c7:	8b 50 08             	mov    0x8(%eax),%edx
  8024ca:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8024cd:	8b 40 0c             	mov    0xc(%eax),%eax
  8024d0:	01 c2                	add    %eax,%edx
  8024d2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024d5:	89 50 08             	mov    %edx,0x8(%eax)
			newblk->sva = newveradd;
  8024d8:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8024db:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8024de:	89 50 08             	mov    %edx,0x8(%eax)
			return newblk;
  8024e1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8024e4:	eb 3b                	jmp    802521 <alloc_block_FF+0x1cb>
	//panic("alloc_block_FF() is not implemented yet...!!");
	uint32 versize = size;
	struct MemBlock* blk;
	struct MemBlock* newblk = LIST_FIRST(&AvailableMemBlocksList);

	LIST_FOREACH(blk,&FreeMemBlocksList)
  8024e6:	a1 40 41 80 00       	mov    0x804140,%eax
  8024eb:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8024ee:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8024f2:	74 07                	je     8024fb <alloc_block_FF+0x1a5>
  8024f4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024f7:	8b 00                	mov    (%eax),%eax
  8024f9:	eb 05                	jmp    802500 <alloc_block_FF+0x1aa>
  8024fb:	b8 00 00 00 00       	mov    $0x0,%eax
  802500:	a3 40 41 80 00       	mov    %eax,0x804140
  802505:	a1 40 41 80 00       	mov    0x804140,%eax
  80250a:	85 c0                	test   %eax,%eax
  80250c:	0f 85 65 fe ff ff    	jne    802377 <alloc_block_FF+0x21>
  802512:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802516:	0f 85 5b fe ff ff    	jne    802377 <alloc_block_FF+0x21>
			blk->sva+=newblk->size;
			newblk->sva = newveradd;
			return newblk;
		}
	}
	return NULL;
  80251c:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802521:	c9                   	leave  
  802522:	c3                   	ret    

00802523 <alloc_block_BF>:

//=========================================
// [5] ALLOCATE BLOCK BY BEST FIT:
//=========================================
struct MemBlock *alloc_block_BF(uint32 size)
{
  802523:	55                   	push   %ebp
  802524:	89 e5                	mov    %esp,%ebp
  802526:	83 ec 28             	sub    $0x28,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_BF
	// Write your code here, remove the panic and write your code
	//panic("alloc_block_BF() is not implemented yet...!!");
	uint32 versize=size;
  802529:	8b 45 08             	mov    0x8(%ebp),%eax
  80252c:	89 45 e8             	mov    %eax,-0x18(%ebp)
	struct MemBlock* blk;
	struct MemBlock* newblk=LIST_FIRST(&AvailableMemBlocksList);
  80252f:	a1 48 41 80 00       	mov    0x804148,%eax
  802534:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	uint32 newveradd;
	uint32 newsize;
	int size_free = LIST_SIZE(&FreeMemBlocksList);
  802537:	a1 44 41 80 00       	mov    0x804144,%eax
  80253c:	89 45 e0             	mov    %eax,-0x20(%ebp)

	LIST_FOREACH(blk, &FreeMemBlocksList)
  80253f:	a1 38 41 80 00       	mov    0x804138,%eax
  802544:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802547:	e9 a1 00 00 00       	jmp    8025ed <alloc_block_BF+0xca>
	{
		if(blk->size == versize)
  80254c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80254f:	8b 40 0c             	mov    0xc(%eax),%eax
  802552:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  802555:	0f 85 8a 00 00 00    	jne    8025e5 <alloc_block_BF+0xc2>
		{
			LIST_REMOVE(&FreeMemBlocksList, blk);
  80255b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80255f:	75 17                	jne    802578 <alloc_block_BF+0x55>
  802561:	83 ec 04             	sub    $0x4,%esp
  802564:	68 c8 39 80 00       	push   $0x8039c8
  802569:	68 c2 00 00 00       	push   $0xc2
  80256e:	68 57 39 80 00       	push   $0x803957
  802573:	e8 14 09 00 00       	call   802e8c <_panic>
  802578:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80257b:	8b 00                	mov    (%eax),%eax
  80257d:	85 c0                	test   %eax,%eax
  80257f:	74 10                	je     802591 <alloc_block_BF+0x6e>
  802581:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802584:	8b 00                	mov    (%eax),%eax
  802586:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802589:	8b 52 04             	mov    0x4(%edx),%edx
  80258c:	89 50 04             	mov    %edx,0x4(%eax)
  80258f:	eb 0b                	jmp    80259c <alloc_block_BF+0x79>
  802591:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802594:	8b 40 04             	mov    0x4(%eax),%eax
  802597:	a3 3c 41 80 00       	mov    %eax,0x80413c
  80259c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80259f:	8b 40 04             	mov    0x4(%eax),%eax
  8025a2:	85 c0                	test   %eax,%eax
  8025a4:	74 0f                	je     8025b5 <alloc_block_BF+0x92>
  8025a6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025a9:	8b 40 04             	mov    0x4(%eax),%eax
  8025ac:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8025af:	8b 12                	mov    (%edx),%edx
  8025b1:	89 10                	mov    %edx,(%eax)
  8025b3:	eb 0a                	jmp    8025bf <alloc_block_BF+0x9c>
  8025b5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025b8:	8b 00                	mov    (%eax),%eax
  8025ba:	a3 38 41 80 00       	mov    %eax,0x804138
  8025bf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025c2:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8025c8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025cb:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8025d2:	a1 44 41 80 00       	mov    0x804144,%eax
  8025d7:	48                   	dec    %eax
  8025d8:	a3 44 41 80 00       	mov    %eax,0x804144
			return blk;
  8025dd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025e0:	e9 11 02 00 00       	jmp    8027f6 <alloc_block_BF+0x2d3>
	struct MemBlock* newblk=LIST_FIRST(&AvailableMemBlocksList);
	uint32 newveradd;
	uint32 newsize;
	int size_free = LIST_SIZE(&FreeMemBlocksList);

	LIST_FOREACH(blk, &FreeMemBlocksList)
  8025e5:	a1 40 41 80 00       	mov    0x804140,%eax
  8025ea:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8025ed:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8025f1:	74 07                	je     8025fa <alloc_block_BF+0xd7>
  8025f3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025f6:	8b 00                	mov    (%eax),%eax
  8025f8:	eb 05                	jmp    8025ff <alloc_block_BF+0xdc>
  8025fa:	b8 00 00 00 00       	mov    $0x0,%eax
  8025ff:	a3 40 41 80 00       	mov    %eax,0x804140
  802604:	a1 40 41 80 00       	mov    0x804140,%eax
  802609:	85 c0                	test   %eax,%eax
  80260b:	0f 85 3b ff ff ff    	jne    80254c <alloc_block_BF+0x29>
  802611:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802615:	0f 85 31 ff ff ff    	jne    80254c <alloc_block_BF+0x29>
		{
			LIST_REMOVE(&FreeMemBlocksList, blk);
			return blk;
		}
	}
	LIST_FOREACH(blk, &FreeMemBlocksList)
  80261b:	a1 38 41 80 00       	mov    0x804138,%eax
  802620:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802623:	eb 27                	jmp    80264c <alloc_block_BF+0x129>
	{
		if(blk->size > versize)
  802625:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802628:	8b 40 0c             	mov    0xc(%eax),%eax
  80262b:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  80262e:	76 14                	jbe    802644 <alloc_block_BF+0x121>
		{
			newsize = blk->size;
  802630:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802633:	8b 40 0c             	mov    0xc(%eax),%eax
  802636:	89 45 ec             	mov    %eax,-0x14(%ebp)
			newveradd = blk->sva;
  802639:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80263c:	8b 40 08             	mov    0x8(%eax),%eax
  80263f:	89 45 f0             	mov    %eax,-0x10(%ebp)
			break;
  802642:	eb 2e                	jmp    802672 <alloc_block_BF+0x14f>
		{
			LIST_REMOVE(&FreeMemBlocksList, blk);
			return blk;
		}
	}
	LIST_FOREACH(blk, &FreeMemBlocksList)
  802644:	a1 40 41 80 00       	mov    0x804140,%eax
  802649:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80264c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802650:	74 07                	je     802659 <alloc_block_BF+0x136>
  802652:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802655:	8b 00                	mov    (%eax),%eax
  802657:	eb 05                	jmp    80265e <alloc_block_BF+0x13b>
  802659:	b8 00 00 00 00       	mov    $0x0,%eax
  80265e:	a3 40 41 80 00       	mov    %eax,0x804140
  802663:	a1 40 41 80 00       	mov    0x804140,%eax
  802668:	85 c0                	test   %eax,%eax
  80266a:	75 b9                	jne    802625 <alloc_block_BF+0x102>
  80266c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802670:	75 b3                	jne    802625 <alloc_block_BF+0x102>
			newsize = blk->size;
			newveradd = blk->sva;
			break;
		}
	}
	LIST_FOREACH(blk, &FreeMemBlocksList)
  802672:	a1 38 41 80 00       	mov    0x804138,%eax
  802677:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80267a:	eb 30                	jmp    8026ac <alloc_block_BF+0x189>
	{
		if(newsize > blk->size && blk->size > versize)
  80267c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80267f:	8b 40 0c             	mov    0xc(%eax),%eax
  802682:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  802685:	73 1d                	jae    8026a4 <alloc_block_BF+0x181>
  802687:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80268a:	8b 40 0c             	mov    0xc(%eax),%eax
  80268d:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  802690:	76 12                	jbe    8026a4 <alloc_block_BF+0x181>
		{
	       newsize = blk->size;
  802692:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802695:	8b 40 0c             	mov    0xc(%eax),%eax
  802698:	89 45 ec             	mov    %eax,-0x14(%ebp)
		   newveradd = blk->sva;
  80269b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80269e:	8b 40 08             	mov    0x8(%eax),%eax
  8026a1:	89 45 f0             	mov    %eax,-0x10(%ebp)
			newsize = blk->size;
			newveradd = blk->sva;
			break;
		}
	}
	LIST_FOREACH(blk, &FreeMemBlocksList)
  8026a4:	a1 40 41 80 00       	mov    0x804140,%eax
  8026a9:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8026ac:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8026b0:	74 07                	je     8026b9 <alloc_block_BF+0x196>
  8026b2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026b5:	8b 00                	mov    (%eax),%eax
  8026b7:	eb 05                	jmp    8026be <alloc_block_BF+0x19b>
  8026b9:	b8 00 00 00 00       	mov    $0x0,%eax
  8026be:	a3 40 41 80 00       	mov    %eax,0x804140
  8026c3:	a1 40 41 80 00       	mov    0x804140,%eax
  8026c8:	85 c0                	test   %eax,%eax
  8026ca:	75 b0                	jne    80267c <alloc_block_BF+0x159>
  8026cc:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8026d0:	75 aa                	jne    80267c <alloc_block_BF+0x159>
		{
	       newsize = blk->size;
		   newveradd = blk->sva;
		}
	}
	LIST_FOREACH(blk, &FreeMemBlocksList)
  8026d2:	a1 38 41 80 00       	mov    0x804138,%eax
  8026d7:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8026da:	e9 e4 00 00 00       	jmp    8027c3 <alloc_block_BF+0x2a0>
	{
		if(blk->size == newsize && blk->sva == newveradd)
  8026df:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026e2:	8b 40 0c             	mov    0xc(%eax),%eax
  8026e5:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  8026e8:	0f 85 cd 00 00 00    	jne    8027bb <alloc_block_BF+0x298>
  8026ee:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026f1:	8b 40 08             	mov    0x8(%eax),%eax
  8026f4:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8026f7:	0f 85 be 00 00 00    	jne    8027bb <alloc_block_BF+0x298>
		{
			LIST_REMOVE(&AvailableMemBlocksList, newblk);
  8026fd:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  802701:	75 17                	jne    80271a <alloc_block_BF+0x1f7>
  802703:	83 ec 04             	sub    $0x4,%esp
  802706:	68 c8 39 80 00       	push   $0x8039c8
  80270b:	68 db 00 00 00       	push   $0xdb
  802710:	68 57 39 80 00       	push   $0x803957
  802715:	e8 72 07 00 00       	call   802e8c <_panic>
  80271a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80271d:	8b 00                	mov    (%eax),%eax
  80271f:	85 c0                	test   %eax,%eax
  802721:	74 10                	je     802733 <alloc_block_BF+0x210>
  802723:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802726:	8b 00                	mov    (%eax),%eax
  802728:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80272b:	8b 52 04             	mov    0x4(%edx),%edx
  80272e:	89 50 04             	mov    %edx,0x4(%eax)
  802731:	eb 0b                	jmp    80273e <alloc_block_BF+0x21b>
  802733:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802736:	8b 40 04             	mov    0x4(%eax),%eax
  802739:	a3 4c 41 80 00       	mov    %eax,0x80414c
  80273e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802741:	8b 40 04             	mov    0x4(%eax),%eax
  802744:	85 c0                	test   %eax,%eax
  802746:	74 0f                	je     802757 <alloc_block_BF+0x234>
  802748:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80274b:	8b 40 04             	mov    0x4(%eax),%eax
  80274e:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802751:	8b 12                	mov    (%edx),%edx
  802753:	89 10                	mov    %edx,(%eax)
  802755:	eb 0a                	jmp    802761 <alloc_block_BF+0x23e>
  802757:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80275a:	8b 00                	mov    (%eax),%eax
  80275c:	a3 48 41 80 00       	mov    %eax,0x804148
  802761:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802764:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80276a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80276d:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802774:	a1 54 41 80 00       	mov    0x804154,%eax
  802779:	48                   	dec    %eax
  80277a:	a3 54 41 80 00       	mov    %eax,0x804154
			newblk->size = versize;
  80277f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802782:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802785:	89 50 0c             	mov    %edx,0xc(%eax)
			newblk->sva = newveradd;
  802788:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80278b:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80278e:	89 50 08             	mov    %edx,0x8(%eax)
			blk->size = blk->size - versize;
  802791:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802794:	8b 40 0c             	mov    0xc(%eax),%eax
  802797:	2b 45 e8             	sub    -0x18(%ebp),%eax
  80279a:	89 c2                	mov    %eax,%edx
  80279c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80279f:	89 50 0c             	mov    %edx,0xc(%eax)
			blk->sva+= newblk->size;
  8027a2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027a5:	8b 50 08             	mov    0x8(%eax),%edx
  8027a8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8027ab:	8b 40 0c             	mov    0xc(%eax),%eax
  8027ae:	01 c2                	add    %eax,%edx
  8027b0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027b3:	89 50 08             	mov    %edx,0x8(%eax)
			return newblk;
  8027b6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8027b9:	eb 3b                	jmp    8027f6 <alloc_block_BF+0x2d3>
		{
	       newsize = blk->size;
		   newveradd = blk->sva;
		}
	}
	LIST_FOREACH(blk, &FreeMemBlocksList)
  8027bb:	a1 40 41 80 00       	mov    0x804140,%eax
  8027c0:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8027c3:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8027c7:	74 07                	je     8027d0 <alloc_block_BF+0x2ad>
  8027c9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027cc:	8b 00                	mov    (%eax),%eax
  8027ce:	eb 05                	jmp    8027d5 <alloc_block_BF+0x2b2>
  8027d0:	b8 00 00 00 00       	mov    $0x0,%eax
  8027d5:	a3 40 41 80 00       	mov    %eax,0x804140
  8027da:	a1 40 41 80 00       	mov    0x804140,%eax
  8027df:	85 c0                	test   %eax,%eax
  8027e1:	0f 85 f8 fe ff ff    	jne    8026df <alloc_block_BF+0x1bc>
  8027e7:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8027eb:	0f 85 ee fe ff ff    	jne    8026df <alloc_block_BF+0x1bc>
			blk->size = blk->size - versize;
			blk->sva+= newblk->size;
			return newblk;
		}
	}
	return NULL;
  8027f1:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8027f6:	c9                   	leave  
  8027f7:	c3                   	ret    

008027f8 <alloc_block_NF>:
//=========================================
// [7] ALLOCATE BLOCK BY NEXT FIT:
//=========================================
struct MemBlock *last_allocate;
struct MemBlock *alloc_block_NF(uint32 size)
{
  8027f8:	55                   	push   %ebp
  8027f9:	89 e5                	mov    %esp,%ebp
  8027fb:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1 - BONUS] [DYNAMIC ALLOCATOR] alloc_block_NF
	// Write your code here, remove the panic and write your code
	//panic("alloc_block_NF() is not implemented yet...!!");
	uint32 versize = size;
  8027fe:	8b 45 08             	mov    0x8(%ebp),%eax
  802801:	89 45 f0             	mov    %eax,-0x10(%ebp)
	struct MemBlock* blk;
	struct MemBlock* newblk = LIST_FIRST(&AvailableMemBlocksList);
  802804:	a1 48 41 80 00       	mov    0x804148,%eax
  802809:	89 45 ec             	mov    %eax,-0x14(%ebp)

	LIST_FOREACH(blk,&FreeMemBlocksList)
  80280c:	a1 38 41 80 00       	mov    0x804138,%eax
  802811:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802814:	e9 77 01 00 00       	jmp    802990 <alloc_block_NF+0x198>
	{
		if(blk->size == versize)
  802819:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80281c:	8b 40 0c             	mov    0xc(%eax),%eax
  80281f:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  802822:	0f 85 8a 00 00 00    	jne    8028b2 <alloc_block_NF+0xba>
		{
			LIST_REMOVE(&FreeMemBlocksList,blk);
  802828:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80282c:	75 17                	jne    802845 <alloc_block_NF+0x4d>
  80282e:	83 ec 04             	sub    $0x4,%esp
  802831:	68 c8 39 80 00       	push   $0x8039c8
  802836:	68 f7 00 00 00       	push   $0xf7
  80283b:	68 57 39 80 00       	push   $0x803957
  802840:	e8 47 06 00 00       	call   802e8c <_panic>
  802845:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802848:	8b 00                	mov    (%eax),%eax
  80284a:	85 c0                	test   %eax,%eax
  80284c:	74 10                	je     80285e <alloc_block_NF+0x66>
  80284e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802851:	8b 00                	mov    (%eax),%eax
  802853:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802856:	8b 52 04             	mov    0x4(%edx),%edx
  802859:	89 50 04             	mov    %edx,0x4(%eax)
  80285c:	eb 0b                	jmp    802869 <alloc_block_NF+0x71>
  80285e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802861:	8b 40 04             	mov    0x4(%eax),%eax
  802864:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802869:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80286c:	8b 40 04             	mov    0x4(%eax),%eax
  80286f:	85 c0                	test   %eax,%eax
  802871:	74 0f                	je     802882 <alloc_block_NF+0x8a>
  802873:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802876:	8b 40 04             	mov    0x4(%eax),%eax
  802879:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80287c:	8b 12                	mov    (%edx),%edx
  80287e:	89 10                	mov    %edx,(%eax)
  802880:	eb 0a                	jmp    80288c <alloc_block_NF+0x94>
  802882:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802885:	8b 00                	mov    (%eax),%eax
  802887:	a3 38 41 80 00       	mov    %eax,0x804138
  80288c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80288f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802895:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802898:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80289f:	a1 44 41 80 00       	mov    0x804144,%eax
  8028a4:	48                   	dec    %eax
  8028a5:	a3 44 41 80 00       	mov    %eax,0x804144
			return blk;
  8028aa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028ad:	e9 11 01 00 00       	jmp    8029c3 <alloc_block_NF+0x1cb>
		}
		else if(blk->size > versize)
  8028b2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028b5:	8b 40 0c             	mov    0xc(%eax),%eax
  8028b8:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8028bb:	0f 86 c7 00 00 00    	jbe    802988 <alloc_block_NF+0x190>
		{
			LIST_REMOVE(&AvailableMemBlocksList,newblk);
  8028c1:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8028c5:	75 17                	jne    8028de <alloc_block_NF+0xe6>
  8028c7:	83 ec 04             	sub    $0x4,%esp
  8028ca:	68 c8 39 80 00       	push   $0x8039c8
  8028cf:	68 fc 00 00 00       	push   $0xfc
  8028d4:	68 57 39 80 00       	push   $0x803957
  8028d9:	e8 ae 05 00 00       	call   802e8c <_panic>
  8028de:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8028e1:	8b 00                	mov    (%eax),%eax
  8028e3:	85 c0                	test   %eax,%eax
  8028e5:	74 10                	je     8028f7 <alloc_block_NF+0xff>
  8028e7:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8028ea:	8b 00                	mov    (%eax),%eax
  8028ec:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8028ef:	8b 52 04             	mov    0x4(%edx),%edx
  8028f2:	89 50 04             	mov    %edx,0x4(%eax)
  8028f5:	eb 0b                	jmp    802902 <alloc_block_NF+0x10a>
  8028f7:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8028fa:	8b 40 04             	mov    0x4(%eax),%eax
  8028fd:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802902:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802905:	8b 40 04             	mov    0x4(%eax),%eax
  802908:	85 c0                	test   %eax,%eax
  80290a:	74 0f                	je     80291b <alloc_block_NF+0x123>
  80290c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80290f:	8b 40 04             	mov    0x4(%eax),%eax
  802912:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802915:	8b 12                	mov    (%edx),%edx
  802917:	89 10                	mov    %edx,(%eax)
  802919:	eb 0a                	jmp    802925 <alloc_block_NF+0x12d>
  80291b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80291e:	8b 00                	mov    (%eax),%eax
  802920:	a3 48 41 80 00       	mov    %eax,0x804148
  802925:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802928:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80292e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802931:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802938:	a1 54 41 80 00       	mov    0x804154,%eax
  80293d:	48                   	dec    %eax
  80293e:	a3 54 41 80 00       	mov    %eax,0x804154
			newblk->size = versize;
  802943:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802946:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802949:	89 50 0c             	mov    %edx,0xc(%eax)
			blk->size = blk->size-versize;
  80294c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80294f:	8b 40 0c             	mov    0xc(%eax),%eax
  802952:	2b 45 f0             	sub    -0x10(%ebp),%eax
  802955:	89 c2                	mov    %eax,%edx
  802957:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80295a:	89 50 0c             	mov    %edx,0xc(%eax)
			uint32 newveradd = blk->sva;
  80295d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802960:	8b 40 08             	mov    0x8(%eax),%eax
  802963:	89 45 e8             	mov    %eax,-0x18(%ebp)
			blk->sva+=newblk->size;
  802966:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802969:	8b 50 08             	mov    0x8(%eax),%edx
  80296c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80296f:	8b 40 0c             	mov    0xc(%eax),%eax
  802972:	01 c2                	add    %eax,%edx
  802974:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802977:	89 50 08             	mov    %edx,0x8(%eax)
			newblk->sva = newveradd;
  80297a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80297d:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802980:	89 50 08             	mov    %edx,0x8(%eax)
			return newblk;
  802983:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802986:	eb 3b                	jmp    8029c3 <alloc_block_NF+0x1cb>
	//panic("alloc_block_NF() is not implemented yet...!!");
	uint32 versize = size;
	struct MemBlock* blk;
	struct MemBlock* newblk = LIST_FIRST(&AvailableMemBlocksList);

	LIST_FOREACH(blk,&FreeMemBlocksList)
  802988:	a1 40 41 80 00       	mov    0x804140,%eax
  80298d:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802990:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802994:	74 07                	je     80299d <alloc_block_NF+0x1a5>
  802996:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802999:	8b 00                	mov    (%eax),%eax
  80299b:	eb 05                	jmp    8029a2 <alloc_block_NF+0x1aa>
  80299d:	b8 00 00 00 00       	mov    $0x0,%eax
  8029a2:	a3 40 41 80 00       	mov    %eax,0x804140
  8029a7:	a1 40 41 80 00       	mov    0x804140,%eax
  8029ac:	85 c0                	test   %eax,%eax
  8029ae:	0f 85 65 fe ff ff    	jne    802819 <alloc_block_NF+0x21>
  8029b4:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8029b8:	0f 85 5b fe ff ff    	jne    802819 <alloc_block_NF+0x21>
			blk->sva+=newblk->size;
			newblk->sva = newveradd;
			return newblk;
		}
	}
	return NULL;
  8029be:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8029c3:	c9                   	leave  
  8029c4:	c3                   	ret    

008029c5 <addToAvailMemBlocksList>:

//===================================================
// [8] INSERT BLOCK (SORTED WITH MERGE) IN FREE LIST:
//===================================================
void addToAvailMemBlocksList(struct MemBlock *blockToInsert)
{
  8029c5:	55                   	push   %ebp
  8029c6:	89 e5                	mov    %esp,%ebp
  8029c8:	83 ec 08             	sub    $0x8,%esp
	blockToInsert->sva = 0;
  8029cb:	8b 45 08             	mov    0x8(%ebp),%eax
  8029ce:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
	blockToInsert->size = 0;
  8029d5:	8b 45 08             	mov    0x8(%ebp),%eax
  8029d8:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
	//add to avail
	LIST_INSERT_TAIL(&AvailableMemBlocksList, blockToInsert);
  8029df:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8029e3:	75 17                	jne    8029fc <addToAvailMemBlocksList+0x37>
  8029e5:	83 ec 04             	sub    $0x4,%esp
  8029e8:	68 70 39 80 00       	push   $0x803970
  8029ed:	68 10 01 00 00       	push   $0x110
  8029f2:	68 57 39 80 00       	push   $0x803957
  8029f7:	e8 90 04 00 00       	call   802e8c <_panic>
  8029fc:	8b 15 4c 41 80 00    	mov    0x80414c,%edx
  802a02:	8b 45 08             	mov    0x8(%ebp),%eax
  802a05:	89 50 04             	mov    %edx,0x4(%eax)
  802a08:	8b 45 08             	mov    0x8(%ebp),%eax
  802a0b:	8b 40 04             	mov    0x4(%eax),%eax
  802a0e:	85 c0                	test   %eax,%eax
  802a10:	74 0c                	je     802a1e <addToAvailMemBlocksList+0x59>
  802a12:	a1 4c 41 80 00       	mov    0x80414c,%eax
  802a17:	8b 55 08             	mov    0x8(%ebp),%edx
  802a1a:	89 10                	mov    %edx,(%eax)
  802a1c:	eb 08                	jmp    802a26 <addToAvailMemBlocksList+0x61>
  802a1e:	8b 45 08             	mov    0x8(%ebp),%eax
  802a21:	a3 48 41 80 00       	mov    %eax,0x804148
  802a26:	8b 45 08             	mov    0x8(%ebp),%eax
  802a29:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802a2e:	8b 45 08             	mov    0x8(%ebp),%eax
  802a31:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802a37:	a1 54 41 80 00       	mov    0x804154,%eax
  802a3c:	40                   	inc    %eax
  802a3d:	a3 54 41 80 00       	mov    %eax,0x804154
}
  802a42:	90                   	nop
  802a43:	c9                   	leave  
  802a44:	c3                   	ret    

00802a45 <insert_sorted_with_merge_freeList>:
void insert_sorted_with_merge_freeList(struct MemBlock *blockToInsert)
{
  802a45:	55                   	push   %ebp
  802a46:	89 e5                	mov    %esp,%ebp
  802a48:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] insert_sorted_with_merge_freeList
	// Write your code here, remove the panic and write your code

	struct MemBlock* last = LIST_LAST(&FreeMemBlocksList);
  802a4b:	a1 3c 41 80 00       	mov    0x80413c,%eax
  802a50:	89 45 f0             	mov    %eax,-0x10(%ebp)
	//check if list empty
	if (LIST_SIZE(&(FreeMemBlocksList)) == 0)
  802a53:	a1 44 41 80 00       	mov    0x804144,%eax
  802a58:	85 c0                	test   %eax,%eax
  802a5a:	75 68                	jne    802ac4 <insert_sorted_with_merge_freeList+0x7f>
		LIST_INSERT_HEAD(&FreeMemBlocksList, blockToInsert);
  802a5c:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802a60:	75 17                	jne    802a79 <insert_sorted_with_merge_freeList+0x34>
  802a62:	83 ec 04             	sub    $0x4,%esp
  802a65:	68 34 39 80 00       	push   $0x803934
  802a6a:	68 1a 01 00 00       	push   $0x11a
  802a6f:	68 57 39 80 00       	push   $0x803957
  802a74:	e8 13 04 00 00       	call   802e8c <_panic>
  802a79:	8b 15 38 41 80 00    	mov    0x804138,%edx
  802a7f:	8b 45 08             	mov    0x8(%ebp),%eax
  802a82:	89 10                	mov    %edx,(%eax)
  802a84:	8b 45 08             	mov    0x8(%ebp),%eax
  802a87:	8b 00                	mov    (%eax),%eax
  802a89:	85 c0                	test   %eax,%eax
  802a8b:	74 0d                	je     802a9a <insert_sorted_with_merge_freeList+0x55>
  802a8d:	a1 38 41 80 00       	mov    0x804138,%eax
  802a92:	8b 55 08             	mov    0x8(%ebp),%edx
  802a95:	89 50 04             	mov    %edx,0x4(%eax)
  802a98:	eb 08                	jmp    802aa2 <insert_sorted_with_merge_freeList+0x5d>
  802a9a:	8b 45 08             	mov    0x8(%ebp),%eax
  802a9d:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802aa2:	8b 45 08             	mov    0x8(%ebp),%eax
  802aa5:	a3 38 41 80 00       	mov    %eax,0x804138
  802aaa:	8b 45 08             	mov    0x8(%ebp),%eax
  802aad:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802ab4:	a1 44 41 80 00       	mov    0x804144,%eax
  802ab9:	40                   	inc    %eax
  802aba:	a3 44 41 80 00       	mov    %eax,0x804144
		}
	}

	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  802abf:	e9 c5 03 00 00       	jmp    802e89 <insert_sorted_with_merge_freeList+0x444>
	struct MemBlock* last = LIST_LAST(&FreeMemBlocksList);
	//check if list empty
	if (LIST_SIZE(&(FreeMemBlocksList)) == 0)
		LIST_INSERT_HEAD(&FreeMemBlocksList, blockToInsert);
	//check if it's position is at last
	else if (last->sva < blockToInsert->sva) {
  802ac4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ac7:	8b 50 08             	mov    0x8(%eax),%edx
  802aca:	8b 45 08             	mov    0x8(%ebp),%eax
  802acd:	8b 40 08             	mov    0x8(%eax),%eax
  802ad0:	39 c2                	cmp    %eax,%edx
  802ad2:	0f 83 b2 00 00 00    	jae    802b8a <insert_sorted_with_merge_freeList+0x145>

		//if i have to merge
		if (last->sva + last->size == blockToInsert->sva) {
  802ad8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802adb:	8b 50 08             	mov    0x8(%eax),%edx
  802ade:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ae1:	8b 40 0c             	mov    0xc(%eax),%eax
  802ae4:	01 c2                	add    %eax,%edx
  802ae6:	8b 45 08             	mov    0x8(%ebp),%eax
  802ae9:	8b 40 08             	mov    0x8(%eax),%eax
  802aec:	39 c2                	cmp    %eax,%edx
  802aee:	75 27                	jne    802b17 <insert_sorted_with_merge_freeList+0xd2>
			last->size = last->size + blockToInsert->size;
  802af0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802af3:	8b 50 0c             	mov    0xc(%eax),%edx
  802af6:	8b 45 08             	mov    0x8(%ebp),%eax
  802af9:	8b 40 0c             	mov    0xc(%eax),%eax
  802afc:	01 c2                	add    %eax,%edx
  802afe:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b01:	89 50 0c             	mov    %edx,0xc(%eax)
			addToAvailMemBlocksList(blockToInsert);
  802b04:	83 ec 0c             	sub    $0xc,%esp
  802b07:	ff 75 08             	pushl  0x8(%ebp)
  802b0a:	e8 b6 fe ff ff       	call   8029c5 <addToAvailMemBlocksList>
  802b0f:	83 c4 10             	add    $0x10,%esp
		}
	}

	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  802b12:	e9 72 03 00 00       	jmp    802e89 <insert_sorted_with_merge_freeList+0x444>
		if (last->sva + last->size == blockToInsert->sva) {
			last->size = last->size + blockToInsert->size;
			addToAvailMemBlocksList(blockToInsert);

		} else {
			LIST_INSERT_AFTER(&FreeMemBlocksList, last, blockToInsert);
  802b17:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802b1b:	74 06                	je     802b23 <insert_sorted_with_merge_freeList+0xde>
  802b1d:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802b21:	75 17                	jne    802b3a <insert_sorted_with_merge_freeList+0xf5>
  802b23:	83 ec 04             	sub    $0x4,%esp
  802b26:	68 94 39 80 00       	push   $0x803994
  802b2b:	68 24 01 00 00       	push   $0x124
  802b30:	68 57 39 80 00       	push   $0x803957
  802b35:	e8 52 03 00 00       	call   802e8c <_panic>
  802b3a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b3d:	8b 10                	mov    (%eax),%edx
  802b3f:	8b 45 08             	mov    0x8(%ebp),%eax
  802b42:	89 10                	mov    %edx,(%eax)
  802b44:	8b 45 08             	mov    0x8(%ebp),%eax
  802b47:	8b 00                	mov    (%eax),%eax
  802b49:	85 c0                	test   %eax,%eax
  802b4b:	74 0b                	je     802b58 <insert_sorted_with_merge_freeList+0x113>
  802b4d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b50:	8b 00                	mov    (%eax),%eax
  802b52:	8b 55 08             	mov    0x8(%ebp),%edx
  802b55:	89 50 04             	mov    %edx,0x4(%eax)
  802b58:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b5b:	8b 55 08             	mov    0x8(%ebp),%edx
  802b5e:	89 10                	mov    %edx,(%eax)
  802b60:	8b 45 08             	mov    0x8(%ebp),%eax
  802b63:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802b66:	89 50 04             	mov    %edx,0x4(%eax)
  802b69:	8b 45 08             	mov    0x8(%ebp),%eax
  802b6c:	8b 00                	mov    (%eax),%eax
  802b6e:	85 c0                	test   %eax,%eax
  802b70:	75 08                	jne    802b7a <insert_sorted_with_merge_freeList+0x135>
  802b72:	8b 45 08             	mov    0x8(%ebp),%eax
  802b75:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802b7a:	a1 44 41 80 00       	mov    0x804144,%eax
  802b7f:	40                   	inc    %eax
  802b80:	a3 44 41 80 00       	mov    %eax,0x804144
		}
	}

	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  802b85:	e9 ff 02 00 00       	jmp    802e89 <insert_sorted_with_merge_freeList+0x444>
		} else {
			LIST_INSERT_AFTER(&FreeMemBlocksList, last, blockToInsert);
		}
	} else {
		struct MemBlock *iterator;
		LIST_FOREACH(iterator, &(FreeMemBlocksList))
  802b8a:	a1 38 41 80 00       	mov    0x804138,%eax
  802b8f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802b92:	e9 c2 02 00 00       	jmp    802e59 <insert_sorted_with_merge_freeList+0x414>
		{

			if (iterator->sva > blockToInsert->sva) {
  802b97:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b9a:	8b 50 08             	mov    0x8(%eax),%edx
  802b9d:	8b 45 08             	mov    0x8(%ebp),%eax
  802ba0:	8b 40 08             	mov    0x8(%eax),%eax
  802ba3:	39 c2                	cmp    %eax,%edx
  802ba5:	0f 86 a6 02 00 00    	jbe    802e51 <insert_sorted_with_merge_freeList+0x40c>

				struct MemBlock* prev = LIST_PREV(iterator);
  802bab:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bae:	8b 40 04             	mov    0x4(%eax),%eax
  802bb1:	89 45 ec             	mov    %eax,-0x14(%ebp)
				if (prev == NULL) {
  802bb4:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802bb8:	0f 85 ba 00 00 00    	jne    802c78 <insert_sorted_with_merge_freeList+0x233>
					//check merge
					if (blockToInsert->size + blockToInsert->sva
  802bbe:	8b 45 08             	mov    0x8(%ebp),%eax
  802bc1:	8b 50 0c             	mov    0xc(%eax),%edx
  802bc4:	8b 45 08             	mov    0x8(%ebp),%eax
  802bc7:	8b 40 08             	mov    0x8(%eax),%eax
  802bca:	01 c2                	add    %eax,%edx
							== iterator->sva) {
  802bcc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bcf:	8b 40 08             	mov    0x8(%eax),%eax
			if (iterator->sva > blockToInsert->sva) {

				struct MemBlock* prev = LIST_PREV(iterator);
				if (prev == NULL) {
					//check merge
					if (blockToInsert->size + blockToInsert->sva
  802bd2:	39 c2                	cmp    %eax,%edx
  802bd4:	75 33                	jne    802c09 <insert_sorted_with_merge_freeList+0x1c4>
							== iterator->sva) {
						iterator->sva = blockToInsert->sva;
  802bd6:	8b 45 08             	mov    0x8(%ebp),%eax
  802bd9:	8b 50 08             	mov    0x8(%eax),%edx
  802bdc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bdf:	89 50 08             	mov    %edx,0x8(%eax)
						iterator->size = iterator->size + blockToInsert->size;
  802be2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802be5:	8b 50 0c             	mov    0xc(%eax),%edx
  802be8:	8b 45 08             	mov    0x8(%ebp),%eax
  802beb:	8b 40 0c             	mov    0xc(%eax),%eax
  802bee:	01 c2                	add    %eax,%edx
  802bf0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bf3:	89 50 0c             	mov    %edx,0xc(%eax)
						addToAvailMemBlocksList(blockToInsert);
  802bf6:	83 ec 0c             	sub    $0xc,%esp
  802bf9:	ff 75 08             	pushl  0x8(%ebp)
  802bfc:	e8 c4 fd ff ff       	call   8029c5 <addToAvailMemBlocksList>
  802c01:	83 c4 10             	add    $0x10,%esp

					else {
						LIST_INSERT_BEFORE(&FreeMemBlocksList, iterator,
								blockToInsert);
					}
					break;
  802c04:	e9 80 02 00 00       	jmp    802e89 <insert_sorted_with_merge_freeList+0x444>
						addToAvailMemBlocksList(blockToInsert);

					}

					else {
						LIST_INSERT_BEFORE(&FreeMemBlocksList, iterator,
  802c09:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802c0d:	74 06                	je     802c15 <insert_sorted_with_merge_freeList+0x1d0>
  802c0f:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802c13:	75 17                	jne    802c2c <insert_sorted_with_merge_freeList+0x1e7>
  802c15:	83 ec 04             	sub    $0x4,%esp
  802c18:	68 e8 39 80 00       	push   $0x8039e8
  802c1d:	68 3a 01 00 00       	push   $0x13a
  802c22:	68 57 39 80 00       	push   $0x803957
  802c27:	e8 60 02 00 00       	call   802e8c <_panic>
  802c2c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c2f:	8b 50 04             	mov    0x4(%eax),%edx
  802c32:	8b 45 08             	mov    0x8(%ebp),%eax
  802c35:	89 50 04             	mov    %edx,0x4(%eax)
  802c38:	8b 45 08             	mov    0x8(%ebp),%eax
  802c3b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802c3e:	89 10                	mov    %edx,(%eax)
  802c40:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c43:	8b 40 04             	mov    0x4(%eax),%eax
  802c46:	85 c0                	test   %eax,%eax
  802c48:	74 0d                	je     802c57 <insert_sorted_with_merge_freeList+0x212>
  802c4a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c4d:	8b 40 04             	mov    0x4(%eax),%eax
  802c50:	8b 55 08             	mov    0x8(%ebp),%edx
  802c53:	89 10                	mov    %edx,(%eax)
  802c55:	eb 08                	jmp    802c5f <insert_sorted_with_merge_freeList+0x21a>
  802c57:	8b 45 08             	mov    0x8(%ebp),%eax
  802c5a:	a3 38 41 80 00       	mov    %eax,0x804138
  802c5f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c62:	8b 55 08             	mov    0x8(%ebp),%edx
  802c65:	89 50 04             	mov    %edx,0x4(%eax)
  802c68:	a1 44 41 80 00       	mov    0x804144,%eax
  802c6d:	40                   	inc    %eax
  802c6e:	a3 44 41 80 00       	mov    %eax,0x804144
								blockToInsert);
					}
					break;
  802c73:	e9 11 02 00 00       	jmp    802e89 <insert_sorted_with_merge_freeList+0x444>
				} else {
					//prev and next merge
					if (prev->sva + prev->size + blockToInsert->size
  802c78:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802c7b:	8b 50 08             	mov    0x8(%eax),%edx
  802c7e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802c81:	8b 40 0c             	mov    0xc(%eax),%eax
  802c84:	01 c2                	add    %eax,%edx
  802c86:	8b 45 08             	mov    0x8(%ebp),%eax
  802c89:	8b 40 0c             	mov    0xc(%eax),%eax
  802c8c:	01 c2                	add    %eax,%edx
							== iterator->sva) {
  802c8e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c91:	8b 40 08             	mov    0x8(%eax),%eax
								blockToInsert);
					}
					break;
				} else {
					//prev and next merge
					if (prev->sva + prev->size + blockToInsert->size
  802c94:	39 c2                	cmp    %eax,%edx
  802c96:	0f 85 bf 00 00 00    	jne    802d5b <insert_sorted_with_merge_freeList+0x316>
							== iterator->sva) {
						prev->size = prev->size + blockToInsert->size
  802c9c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802c9f:	8b 50 0c             	mov    0xc(%eax),%edx
  802ca2:	8b 45 08             	mov    0x8(%ebp),%eax
  802ca5:	8b 40 0c             	mov    0xc(%eax),%eax
  802ca8:	01 c2                	add    %eax,%edx
								+ iterator->size;
  802caa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cad:	8b 40 0c             	mov    0xc(%eax),%eax
  802cb0:	01 c2                	add    %eax,%edx
					break;
				} else {
					//prev and next merge
					if (prev->sva + prev->size + blockToInsert->size
							== iterator->sva) {
						prev->size = prev->size + blockToInsert->size
  802cb2:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802cb5:	89 50 0c             	mov    %edx,0xc(%eax)
								+ iterator->size;
						LIST_REMOVE(&FreeMemBlocksList, iterator);
  802cb8:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802cbc:	75 17                	jne    802cd5 <insert_sorted_with_merge_freeList+0x290>
  802cbe:	83 ec 04             	sub    $0x4,%esp
  802cc1:	68 c8 39 80 00       	push   $0x8039c8
  802cc6:	68 43 01 00 00       	push   $0x143
  802ccb:	68 57 39 80 00       	push   $0x803957
  802cd0:	e8 b7 01 00 00       	call   802e8c <_panic>
  802cd5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cd8:	8b 00                	mov    (%eax),%eax
  802cda:	85 c0                	test   %eax,%eax
  802cdc:	74 10                	je     802cee <insert_sorted_with_merge_freeList+0x2a9>
  802cde:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ce1:	8b 00                	mov    (%eax),%eax
  802ce3:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802ce6:	8b 52 04             	mov    0x4(%edx),%edx
  802ce9:	89 50 04             	mov    %edx,0x4(%eax)
  802cec:	eb 0b                	jmp    802cf9 <insert_sorted_with_merge_freeList+0x2b4>
  802cee:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cf1:	8b 40 04             	mov    0x4(%eax),%eax
  802cf4:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802cf9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cfc:	8b 40 04             	mov    0x4(%eax),%eax
  802cff:	85 c0                	test   %eax,%eax
  802d01:	74 0f                	je     802d12 <insert_sorted_with_merge_freeList+0x2cd>
  802d03:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d06:	8b 40 04             	mov    0x4(%eax),%eax
  802d09:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802d0c:	8b 12                	mov    (%edx),%edx
  802d0e:	89 10                	mov    %edx,(%eax)
  802d10:	eb 0a                	jmp    802d1c <insert_sorted_with_merge_freeList+0x2d7>
  802d12:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d15:	8b 00                	mov    (%eax),%eax
  802d17:	a3 38 41 80 00       	mov    %eax,0x804138
  802d1c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d1f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802d25:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d28:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802d2f:	a1 44 41 80 00       	mov    0x804144,%eax
  802d34:	48                   	dec    %eax
  802d35:	a3 44 41 80 00       	mov    %eax,0x804144
						addToAvailMemBlocksList(blockToInsert);
  802d3a:	83 ec 0c             	sub    $0xc,%esp
  802d3d:	ff 75 08             	pushl  0x8(%ebp)
  802d40:	e8 80 fc ff ff       	call   8029c5 <addToAvailMemBlocksList>
  802d45:	83 c4 10             	add    $0x10,%esp
						addToAvailMemBlocksList(iterator);
  802d48:	83 ec 0c             	sub    $0xc,%esp
  802d4b:	ff 75 f4             	pushl  -0xc(%ebp)
  802d4e:	e8 72 fc ff ff       	call   8029c5 <addToAvailMemBlocksList>
  802d53:	83 c4 10             	add    $0x10,%esp
					//Insert
					else {
						LIST_INSERT_BEFORE(&FreeMemBlocksList, iterator,
								blockToInsert);
					}
					break;
  802d56:	e9 2e 01 00 00       	jmp    802e89 <insert_sorted_with_merge_freeList+0x444>
						LIST_REMOVE(&FreeMemBlocksList, iterator);
						addToAvailMemBlocksList(blockToInsert);
						addToAvailMemBlocksList(iterator);
					}
					//previous merge
					else if (prev->sva + prev->size == blockToInsert->sva) {
  802d5b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802d5e:	8b 50 08             	mov    0x8(%eax),%edx
  802d61:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802d64:	8b 40 0c             	mov    0xc(%eax),%eax
  802d67:	01 c2                	add    %eax,%edx
  802d69:	8b 45 08             	mov    0x8(%ebp),%eax
  802d6c:	8b 40 08             	mov    0x8(%eax),%eax
  802d6f:	39 c2                	cmp    %eax,%edx
  802d71:	75 27                	jne    802d9a <insert_sorted_with_merge_freeList+0x355>
						prev->size = prev->size + blockToInsert->size;
  802d73:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802d76:	8b 50 0c             	mov    0xc(%eax),%edx
  802d79:	8b 45 08             	mov    0x8(%ebp),%eax
  802d7c:	8b 40 0c             	mov    0xc(%eax),%eax
  802d7f:	01 c2                	add    %eax,%edx
  802d81:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802d84:	89 50 0c             	mov    %edx,0xc(%eax)
						addToAvailMemBlocksList(blockToInsert);
  802d87:	83 ec 0c             	sub    $0xc,%esp
  802d8a:	ff 75 08             	pushl  0x8(%ebp)
  802d8d:	e8 33 fc ff ff       	call   8029c5 <addToAvailMemBlocksList>
  802d92:	83 c4 10             	add    $0x10,%esp
					//Insert
					else {
						LIST_INSERT_BEFORE(&FreeMemBlocksList, iterator,
								blockToInsert);
					}
					break;
  802d95:	e9 ef 00 00 00       	jmp    802e89 <insert_sorted_with_merge_freeList+0x444>
					else if (prev->sva + prev->size == blockToInsert->sva) {
						prev->size = prev->size + blockToInsert->size;
						addToAvailMemBlocksList(blockToInsert);
					}
					//next merge
					else if (blockToInsert->size + blockToInsert->sva
  802d9a:	8b 45 08             	mov    0x8(%ebp),%eax
  802d9d:	8b 50 0c             	mov    0xc(%eax),%edx
  802da0:	8b 45 08             	mov    0x8(%ebp),%eax
  802da3:	8b 40 08             	mov    0x8(%eax),%eax
  802da6:	01 c2                	add    %eax,%edx
							== iterator->sva) {
  802da8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802dab:	8b 40 08             	mov    0x8(%eax),%eax
					else if (prev->sva + prev->size == blockToInsert->sva) {
						prev->size = prev->size + blockToInsert->size;
						addToAvailMemBlocksList(blockToInsert);
					}
					//next merge
					else if (blockToInsert->size + blockToInsert->sva
  802dae:	39 c2                	cmp    %eax,%edx
  802db0:	75 33                	jne    802de5 <insert_sorted_with_merge_freeList+0x3a0>
							== iterator->sva) {
						iterator->sva = blockToInsert->sva;
  802db2:	8b 45 08             	mov    0x8(%ebp),%eax
  802db5:	8b 50 08             	mov    0x8(%eax),%edx
  802db8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802dbb:	89 50 08             	mov    %edx,0x8(%eax)
						iterator->size = iterator->size + blockToInsert->size;
  802dbe:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802dc1:	8b 50 0c             	mov    0xc(%eax),%edx
  802dc4:	8b 45 08             	mov    0x8(%ebp),%eax
  802dc7:	8b 40 0c             	mov    0xc(%eax),%eax
  802dca:	01 c2                	add    %eax,%edx
  802dcc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802dcf:	89 50 0c             	mov    %edx,0xc(%eax)
						addToAvailMemBlocksList(blockToInsert);
  802dd2:	83 ec 0c             	sub    $0xc,%esp
  802dd5:	ff 75 08             	pushl  0x8(%ebp)
  802dd8:	e8 e8 fb ff ff       	call   8029c5 <addToAvailMemBlocksList>
  802ddd:	83 c4 10             	add    $0x10,%esp
					//Insert
					else {
						LIST_INSERT_BEFORE(&FreeMemBlocksList, iterator,
								blockToInsert);
					}
					break;
  802de0:	e9 a4 00 00 00       	jmp    802e89 <insert_sorted_with_merge_freeList+0x444>
						iterator->size = iterator->size + blockToInsert->size;
						addToAvailMemBlocksList(blockToInsert);
					}
					//Insert
					else {
						LIST_INSERT_BEFORE(&FreeMemBlocksList, iterator,
  802de5:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802de9:	74 06                	je     802df1 <insert_sorted_with_merge_freeList+0x3ac>
  802deb:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802def:	75 17                	jne    802e08 <insert_sorted_with_merge_freeList+0x3c3>
  802df1:	83 ec 04             	sub    $0x4,%esp
  802df4:	68 e8 39 80 00       	push   $0x8039e8
  802df9:	68 56 01 00 00       	push   $0x156
  802dfe:	68 57 39 80 00       	push   $0x803957
  802e03:	e8 84 00 00 00       	call   802e8c <_panic>
  802e08:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e0b:	8b 50 04             	mov    0x4(%eax),%edx
  802e0e:	8b 45 08             	mov    0x8(%ebp),%eax
  802e11:	89 50 04             	mov    %edx,0x4(%eax)
  802e14:	8b 45 08             	mov    0x8(%ebp),%eax
  802e17:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802e1a:	89 10                	mov    %edx,(%eax)
  802e1c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e1f:	8b 40 04             	mov    0x4(%eax),%eax
  802e22:	85 c0                	test   %eax,%eax
  802e24:	74 0d                	je     802e33 <insert_sorted_with_merge_freeList+0x3ee>
  802e26:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e29:	8b 40 04             	mov    0x4(%eax),%eax
  802e2c:	8b 55 08             	mov    0x8(%ebp),%edx
  802e2f:	89 10                	mov    %edx,(%eax)
  802e31:	eb 08                	jmp    802e3b <insert_sorted_with_merge_freeList+0x3f6>
  802e33:	8b 45 08             	mov    0x8(%ebp),%eax
  802e36:	a3 38 41 80 00       	mov    %eax,0x804138
  802e3b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e3e:	8b 55 08             	mov    0x8(%ebp),%edx
  802e41:	89 50 04             	mov    %edx,0x4(%eax)
  802e44:	a1 44 41 80 00       	mov    0x804144,%eax
  802e49:	40                   	inc    %eax
  802e4a:	a3 44 41 80 00       	mov    %eax,0x804144
								blockToInsert);
					}
					break;
  802e4f:	eb 38                	jmp    802e89 <insert_sorted_with_merge_freeList+0x444>
		} else {
			LIST_INSERT_AFTER(&FreeMemBlocksList, last, blockToInsert);
		}
	} else {
		struct MemBlock *iterator;
		LIST_FOREACH(iterator, &(FreeMemBlocksList))
  802e51:	a1 40 41 80 00       	mov    0x804140,%eax
  802e56:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802e59:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802e5d:	74 07                	je     802e66 <insert_sorted_with_merge_freeList+0x421>
  802e5f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e62:	8b 00                	mov    (%eax),%eax
  802e64:	eb 05                	jmp    802e6b <insert_sorted_with_merge_freeList+0x426>
  802e66:	b8 00 00 00 00       	mov    $0x0,%eax
  802e6b:	a3 40 41 80 00       	mov    %eax,0x804140
  802e70:	a1 40 41 80 00       	mov    0x804140,%eax
  802e75:	85 c0                	test   %eax,%eax
  802e77:	0f 85 1a fd ff ff    	jne    802b97 <insert_sorted_with_merge_freeList+0x152>
  802e7d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802e81:	0f 85 10 fd ff ff    	jne    802b97 <insert_sorted_with_merge_freeList+0x152>
		}
	}

	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  802e87:	eb 00                	jmp    802e89 <insert_sorted_with_merge_freeList+0x444>
  802e89:	90                   	nop
  802e8a:	c9                   	leave  
  802e8b:	c3                   	ret    

00802e8c <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  802e8c:	55                   	push   %ebp
  802e8d:	89 e5                	mov    %esp,%ebp
  802e8f:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  802e92:	8d 45 10             	lea    0x10(%ebp),%eax
  802e95:	83 c0 04             	add    $0x4,%eax
  802e98:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  802e9b:	a1 60 41 80 00       	mov    0x804160,%eax
  802ea0:	85 c0                	test   %eax,%eax
  802ea2:	74 16                	je     802eba <_panic+0x2e>
		cprintf("%s: ", argv0);
  802ea4:	a1 60 41 80 00       	mov    0x804160,%eax
  802ea9:	83 ec 08             	sub    $0x8,%esp
  802eac:	50                   	push   %eax
  802ead:	68 20 3a 80 00       	push   $0x803a20
  802eb2:	e8 af d6 ff ff       	call   800566 <cprintf>
  802eb7:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  802eba:	a1 00 40 80 00       	mov    0x804000,%eax
  802ebf:	ff 75 0c             	pushl  0xc(%ebp)
  802ec2:	ff 75 08             	pushl  0x8(%ebp)
  802ec5:	50                   	push   %eax
  802ec6:	68 25 3a 80 00       	push   $0x803a25
  802ecb:	e8 96 d6 ff ff       	call   800566 <cprintf>
  802ed0:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  802ed3:	8b 45 10             	mov    0x10(%ebp),%eax
  802ed6:	83 ec 08             	sub    $0x8,%esp
  802ed9:	ff 75 f4             	pushl  -0xc(%ebp)
  802edc:	50                   	push   %eax
  802edd:	e8 19 d6 ff ff       	call   8004fb <vcprintf>
  802ee2:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  802ee5:	83 ec 08             	sub    $0x8,%esp
  802ee8:	6a 00                	push   $0x0
  802eea:	68 41 3a 80 00       	push   $0x803a41
  802eef:	e8 07 d6 ff ff       	call   8004fb <vcprintf>
  802ef4:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  802ef7:	e8 88 d5 ff ff       	call   800484 <exit>

	// should not return here
	while (1) ;
  802efc:	eb fe                	jmp    802efc <_panic+0x70>

00802efe <CheckWSWithoutLastIndex>:
}

void CheckWSWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  802efe:	55                   	push   %ebp
  802eff:	89 e5                	mov    %esp,%ebp
  802f01:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  802f04:	a1 20 40 80 00       	mov    0x804020,%eax
  802f09:	8b 50 74             	mov    0x74(%eax),%edx
  802f0c:	8b 45 0c             	mov    0xc(%ebp),%eax
  802f0f:	39 c2                	cmp    %eax,%edx
  802f11:	74 14                	je     802f27 <CheckWSWithoutLastIndex+0x29>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  802f13:	83 ec 04             	sub    $0x4,%esp
  802f16:	68 44 3a 80 00       	push   $0x803a44
  802f1b:	6a 26                	push   $0x26
  802f1d:	68 90 3a 80 00       	push   $0x803a90
  802f22:	e8 65 ff ff ff       	call   802e8c <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  802f27:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  802f2e:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  802f35:	e9 c2 00 00 00       	jmp    802ffc <CheckWSWithoutLastIndex+0xfe>
		if (expectedPages[e] == 0) {
  802f3a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802f3d:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  802f44:	8b 45 08             	mov    0x8(%ebp),%eax
  802f47:	01 d0                	add    %edx,%eax
  802f49:	8b 00                	mov    (%eax),%eax
  802f4b:	85 c0                	test   %eax,%eax
  802f4d:	75 08                	jne    802f57 <CheckWSWithoutLastIndex+0x59>
			expectedNumOfEmptyLocs++;
  802f4f:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  802f52:	e9 a2 00 00 00       	jmp    802ff9 <CheckWSWithoutLastIndex+0xfb>
		}
		int found = 0;
  802f57:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  802f5e:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  802f65:	eb 69                	jmp    802fd0 <CheckWSWithoutLastIndex+0xd2>
			if (myEnv->__uptr_pws[w].empty == 0) {
  802f67:	a1 20 40 80 00       	mov    0x804020,%eax
  802f6c:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  802f72:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802f75:	89 d0                	mov    %edx,%eax
  802f77:	01 c0                	add    %eax,%eax
  802f79:	01 d0                	add    %edx,%eax
  802f7b:	c1 e0 03             	shl    $0x3,%eax
  802f7e:	01 c8                	add    %ecx,%eax
  802f80:	8a 40 04             	mov    0x4(%eax),%al
  802f83:	84 c0                	test   %al,%al
  802f85:	75 46                	jne    802fcd <CheckWSWithoutLastIndex+0xcf>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  802f87:	a1 20 40 80 00       	mov    0x804020,%eax
  802f8c:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  802f92:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802f95:	89 d0                	mov    %edx,%eax
  802f97:	01 c0                	add    %eax,%eax
  802f99:	01 d0                	add    %edx,%eax
  802f9b:	c1 e0 03             	shl    $0x3,%eax
  802f9e:	01 c8                	add    %ecx,%eax
  802fa0:	8b 00                	mov    (%eax),%eax
  802fa2:	89 45 dc             	mov    %eax,-0x24(%ebp)
  802fa5:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802fa8:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  802fad:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  802faf:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802fb2:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  802fb9:	8b 45 08             	mov    0x8(%ebp),%eax
  802fbc:	01 c8                	add    %ecx,%eax
  802fbe:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  802fc0:	39 c2                	cmp    %eax,%edx
  802fc2:	75 09                	jne    802fcd <CheckWSWithoutLastIndex+0xcf>
						== expectedPages[e]) {
					found = 1;
  802fc4:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  802fcb:	eb 12                	jmp    802fdf <CheckWSWithoutLastIndex+0xe1>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  802fcd:	ff 45 e8             	incl   -0x18(%ebp)
  802fd0:	a1 20 40 80 00       	mov    0x804020,%eax
  802fd5:	8b 50 74             	mov    0x74(%eax),%edx
  802fd8:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802fdb:	39 c2                	cmp    %eax,%edx
  802fdd:	77 88                	ja     802f67 <CheckWSWithoutLastIndex+0x69>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  802fdf:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802fe3:	75 14                	jne    802ff9 <CheckWSWithoutLastIndex+0xfb>
			panic(
  802fe5:	83 ec 04             	sub    $0x4,%esp
  802fe8:	68 9c 3a 80 00       	push   $0x803a9c
  802fed:	6a 3a                	push   $0x3a
  802fef:	68 90 3a 80 00       	push   $0x803a90
  802ff4:	e8 93 fe ff ff       	call   802e8c <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  802ff9:	ff 45 f0             	incl   -0x10(%ebp)
  802ffc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802fff:	3b 45 0c             	cmp    0xc(%ebp),%eax
  803002:	0f 8c 32 ff ff ff    	jl     802f3a <CheckWSWithoutLastIndex+0x3c>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  803008:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  80300f:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  803016:	eb 26                	jmp    80303e <CheckWSWithoutLastIndex+0x140>
		if (myEnv->__uptr_pws[w].empty == 1) {
  803018:	a1 20 40 80 00       	mov    0x804020,%eax
  80301d:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  803023:	8b 55 e0             	mov    -0x20(%ebp),%edx
  803026:	89 d0                	mov    %edx,%eax
  803028:	01 c0                	add    %eax,%eax
  80302a:	01 d0                	add    %edx,%eax
  80302c:	c1 e0 03             	shl    $0x3,%eax
  80302f:	01 c8                	add    %ecx,%eax
  803031:	8a 40 04             	mov    0x4(%eax),%al
  803034:	3c 01                	cmp    $0x1,%al
  803036:	75 03                	jne    80303b <CheckWSWithoutLastIndex+0x13d>
			actualNumOfEmptyLocs++;
  803038:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  80303b:	ff 45 e0             	incl   -0x20(%ebp)
  80303e:	a1 20 40 80 00       	mov    0x804020,%eax
  803043:	8b 50 74             	mov    0x74(%eax),%edx
  803046:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803049:	39 c2                	cmp    %eax,%edx
  80304b:	77 cb                	ja     803018 <CheckWSWithoutLastIndex+0x11a>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  80304d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803050:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  803053:	74 14                	je     803069 <CheckWSWithoutLastIndex+0x16b>
		panic(
  803055:	83 ec 04             	sub    $0x4,%esp
  803058:	68 f0 3a 80 00       	push   $0x803af0
  80305d:	6a 44                	push   $0x44
  80305f:	68 90 3a 80 00       	push   $0x803a90
  803064:	e8 23 fe ff ff       	call   802e8c <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  803069:	90                   	nop
  80306a:	c9                   	leave  
  80306b:	c3                   	ret    

0080306c <__udivdi3>:
  80306c:	55                   	push   %ebp
  80306d:	57                   	push   %edi
  80306e:	56                   	push   %esi
  80306f:	53                   	push   %ebx
  803070:	83 ec 1c             	sub    $0x1c,%esp
  803073:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  803077:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  80307b:	8b 7c 24 38          	mov    0x38(%esp),%edi
  80307f:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  803083:	89 ca                	mov    %ecx,%edx
  803085:	89 f8                	mov    %edi,%eax
  803087:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  80308b:	85 f6                	test   %esi,%esi
  80308d:	75 2d                	jne    8030bc <__udivdi3+0x50>
  80308f:	39 cf                	cmp    %ecx,%edi
  803091:	77 65                	ja     8030f8 <__udivdi3+0x8c>
  803093:	89 fd                	mov    %edi,%ebp
  803095:	85 ff                	test   %edi,%edi
  803097:	75 0b                	jne    8030a4 <__udivdi3+0x38>
  803099:	b8 01 00 00 00       	mov    $0x1,%eax
  80309e:	31 d2                	xor    %edx,%edx
  8030a0:	f7 f7                	div    %edi
  8030a2:	89 c5                	mov    %eax,%ebp
  8030a4:	31 d2                	xor    %edx,%edx
  8030a6:	89 c8                	mov    %ecx,%eax
  8030a8:	f7 f5                	div    %ebp
  8030aa:	89 c1                	mov    %eax,%ecx
  8030ac:	89 d8                	mov    %ebx,%eax
  8030ae:	f7 f5                	div    %ebp
  8030b0:	89 cf                	mov    %ecx,%edi
  8030b2:	89 fa                	mov    %edi,%edx
  8030b4:	83 c4 1c             	add    $0x1c,%esp
  8030b7:	5b                   	pop    %ebx
  8030b8:	5e                   	pop    %esi
  8030b9:	5f                   	pop    %edi
  8030ba:	5d                   	pop    %ebp
  8030bb:	c3                   	ret    
  8030bc:	39 ce                	cmp    %ecx,%esi
  8030be:	77 28                	ja     8030e8 <__udivdi3+0x7c>
  8030c0:	0f bd fe             	bsr    %esi,%edi
  8030c3:	83 f7 1f             	xor    $0x1f,%edi
  8030c6:	75 40                	jne    803108 <__udivdi3+0x9c>
  8030c8:	39 ce                	cmp    %ecx,%esi
  8030ca:	72 0a                	jb     8030d6 <__udivdi3+0x6a>
  8030cc:	3b 44 24 08          	cmp    0x8(%esp),%eax
  8030d0:	0f 87 9e 00 00 00    	ja     803174 <__udivdi3+0x108>
  8030d6:	b8 01 00 00 00       	mov    $0x1,%eax
  8030db:	89 fa                	mov    %edi,%edx
  8030dd:	83 c4 1c             	add    $0x1c,%esp
  8030e0:	5b                   	pop    %ebx
  8030e1:	5e                   	pop    %esi
  8030e2:	5f                   	pop    %edi
  8030e3:	5d                   	pop    %ebp
  8030e4:	c3                   	ret    
  8030e5:	8d 76 00             	lea    0x0(%esi),%esi
  8030e8:	31 ff                	xor    %edi,%edi
  8030ea:	31 c0                	xor    %eax,%eax
  8030ec:	89 fa                	mov    %edi,%edx
  8030ee:	83 c4 1c             	add    $0x1c,%esp
  8030f1:	5b                   	pop    %ebx
  8030f2:	5e                   	pop    %esi
  8030f3:	5f                   	pop    %edi
  8030f4:	5d                   	pop    %ebp
  8030f5:	c3                   	ret    
  8030f6:	66 90                	xchg   %ax,%ax
  8030f8:	89 d8                	mov    %ebx,%eax
  8030fa:	f7 f7                	div    %edi
  8030fc:	31 ff                	xor    %edi,%edi
  8030fe:	89 fa                	mov    %edi,%edx
  803100:	83 c4 1c             	add    $0x1c,%esp
  803103:	5b                   	pop    %ebx
  803104:	5e                   	pop    %esi
  803105:	5f                   	pop    %edi
  803106:	5d                   	pop    %ebp
  803107:	c3                   	ret    
  803108:	bd 20 00 00 00       	mov    $0x20,%ebp
  80310d:	89 eb                	mov    %ebp,%ebx
  80310f:	29 fb                	sub    %edi,%ebx
  803111:	89 f9                	mov    %edi,%ecx
  803113:	d3 e6                	shl    %cl,%esi
  803115:	89 c5                	mov    %eax,%ebp
  803117:	88 d9                	mov    %bl,%cl
  803119:	d3 ed                	shr    %cl,%ebp
  80311b:	89 e9                	mov    %ebp,%ecx
  80311d:	09 f1                	or     %esi,%ecx
  80311f:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  803123:	89 f9                	mov    %edi,%ecx
  803125:	d3 e0                	shl    %cl,%eax
  803127:	89 c5                	mov    %eax,%ebp
  803129:	89 d6                	mov    %edx,%esi
  80312b:	88 d9                	mov    %bl,%cl
  80312d:	d3 ee                	shr    %cl,%esi
  80312f:	89 f9                	mov    %edi,%ecx
  803131:	d3 e2                	shl    %cl,%edx
  803133:	8b 44 24 08          	mov    0x8(%esp),%eax
  803137:	88 d9                	mov    %bl,%cl
  803139:	d3 e8                	shr    %cl,%eax
  80313b:	09 c2                	or     %eax,%edx
  80313d:	89 d0                	mov    %edx,%eax
  80313f:	89 f2                	mov    %esi,%edx
  803141:	f7 74 24 0c          	divl   0xc(%esp)
  803145:	89 d6                	mov    %edx,%esi
  803147:	89 c3                	mov    %eax,%ebx
  803149:	f7 e5                	mul    %ebp
  80314b:	39 d6                	cmp    %edx,%esi
  80314d:	72 19                	jb     803168 <__udivdi3+0xfc>
  80314f:	74 0b                	je     80315c <__udivdi3+0xf0>
  803151:	89 d8                	mov    %ebx,%eax
  803153:	31 ff                	xor    %edi,%edi
  803155:	e9 58 ff ff ff       	jmp    8030b2 <__udivdi3+0x46>
  80315a:	66 90                	xchg   %ax,%ax
  80315c:	8b 54 24 08          	mov    0x8(%esp),%edx
  803160:	89 f9                	mov    %edi,%ecx
  803162:	d3 e2                	shl    %cl,%edx
  803164:	39 c2                	cmp    %eax,%edx
  803166:	73 e9                	jae    803151 <__udivdi3+0xe5>
  803168:	8d 43 ff             	lea    -0x1(%ebx),%eax
  80316b:	31 ff                	xor    %edi,%edi
  80316d:	e9 40 ff ff ff       	jmp    8030b2 <__udivdi3+0x46>
  803172:	66 90                	xchg   %ax,%ax
  803174:	31 c0                	xor    %eax,%eax
  803176:	e9 37 ff ff ff       	jmp    8030b2 <__udivdi3+0x46>
  80317b:	90                   	nop

0080317c <__umoddi3>:
  80317c:	55                   	push   %ebp
  80317d:	57                   	push   %edi
  80317e:	56                   	push   %esi
  80317f:	53                   	push   %ebx
  803180:	83 ec 1c             	sub    $0x1c,%esp
  803183:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  803187:	8b 74 24 34          	mov    0x34(%esp),%esi
  80318b:	8b 7c 24 38          	mov    0x38(%esp),%edi
  80318f:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  803193:	89 44 24 0c          	mov    %eax,0xc(%esp)
  803197:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  80319b:	89 f3                	mov    %esi,%ebx
  80319d:	89 fa                	mov    %edi,%edx
  80319f:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8031a3:	89 34 24             	mov    %esi,(%esp)
  8031a6:	85 c0                	test   %eax,%eax
  8031a8:	75 1a                	jne    8031c4 <__umoddi3+0x48>
  8031aa:	39 f7                	cmp    %esi,%edi
  8031ac:	0f 86 a2 00 00 00    	jbe    803254 <__umoddi3+0xd8>
  8031b2:	89 c8                	mov    %ecx,%eax
  8031b4:	89 f2                	mov    %esi,%edx
  8031b6:	f7 f7                	div    %edi
  8031b8:	89 d0                	mov    %edx,%eax
  8031ba:	31 d2                	xor    %edx,%edx
  8031bc:	83 c4 1c             	add    $0x1c,%esp
  8031bf:	5b                   	pop    %ebx
  8031c0:	5e                   	pop    %esi
  8031c1:	5f                   	pop    %edi
  8031c2:	5d                   	pop    %ebp
  8031c3:	c3                   	ret    
  8031c4:	39 f0                	cmp    %esi,%eax
  8031c6:	0f 87 ac 00 00 00    	ja     803278 <__umoddi3+0xfc>
  8031cc:	0f bd e8             	bsr    %eax,%ebp
  8031cf:	83 f5 1f             	xor    $0x1f,%ebp
  8031d2:	0f 84 ac 00 00 00    	je     803284 <__umoddi3+0x108>
  8031d8:	bf 20 00 00 00       	mov    $0x20,%edi
  8031dd:	29 ef                	sub    %ebp,%edi
  8031df:	89 fe                	mov    %edi,%esi
  8031e1:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  8031e5:	89 e9                	mov    %ebp,%ecx
  8031e7:	d3 e0                	shl    %cl,%eax
  8031e9:	89 d7                	mov    %edx,%edi
  8031eb:	89 f1                	mov    %esi,%ecx
  8031ed:	d3 ef                	shr    %cl,%edi
  8031ef:	09 c7                	or     %eax,%edi
  8031f1:	89 e9                	mov    %ebp,%ecx
  8031f3:	d3 e2                	shl    %cl,%edx
  8031f5:	89 14 24             	mov    %edx,(%esp)
  8031f8:	89 d8                	mov    %ebx,%eax
  8031fa:	d3 e0                	shl    %cl,%eax
  8031fc:	89 c2                	mov    %eax,%edx
  8031fe:	8b 44 24 08          	mov    0x8(%esp),%eax
  803202:	d3 e0                	shl    %cl,%eax
  803204:	89 44 24 04          	mov    %eax,0x4(%esp)
  803208:	8b 44 24 08          	mov    0x8(%esp),%eax
  80320c:	89 f1                	mov    %esi,%ecx
  80320e:	d3 e8                	shr    %cl,%eax
  803210:	09 d0                	or     %edx,%eax
  803212:	d3 eb                	shr    %cl,%ebx
  803214:	89 da                	mov    %ebx,%edx
  803216:	f7 f7                	div    %edi
  803218:	89 d3                	mov    %edx,%ebx
  80321a:	f7 24 24             	mull   (%esp)
  80321d:	89 c6                	mov    %eax,%esi
  80321f:	89 d1                	mov    %edx,%ecx
  803221:	39 d3                	cmp    %edx,%ebx
  803223:	0f 82 87 00 00 00    	jb     8032b0 <__umoddi3+0x134>
  803229:	0f 84 91 00 00 00    	je     8032c0 <__umoddi3+0x144>
  80322f:	8b 54 24 04          	mov    0x4(%esp),%edx
  803233:	29 f2                	sub    %esi,%edx
  803235:	19 cb                	sbb    %ecx,%ebx
  803237:	89 d8                	mov    %ebx,%eax
  803239:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  80323d:	d3 e0                	shl    %cl,%eax
  80323f:	89 e9                	mov    %ebp,%ecx
  803241:	d3 ea                	shr    %cl,%edx
  803243:	09 d0                	or     %edx,%eax
  803245:	89 e9                	mov    %ebp,%ecx
  803247:	d3 eb                	shr    %cl,%ebx
  803249:	89 da                	mov    %ebx,%edx
  80324b:	83 c4 1c             	add    $0x1c,%esp
  80324e:	5b                   	pop    %ebx
  80324f:	5e                   	pop    %esi
  803250:	5f                   	pop    %edi
  803251:	5d                   	pop    %ebp
  803252:	c3                   	ret    
  803253:	90                   	nop
  803254:	89 fd                	mov    %edi,%ebp
  803256:	85 ff                	test   %edi,%edi
  803258:	75 0b                	jne    803265 <__umoddi3+0xe9>
  80325a:	b8 01 00 00 00       	mov    $0x1,%eax
  80325f:	31 d2                	xor    %edx,%edx
  803261:	f7 f7                	div    %edi
  803263:	89 c5                	mov    %eax,%ebp
  803265:	89 f0                	mov    %esi,%eax
  803267:	31 d2                	xor    %edx,%edx
  803269:	f7 f5                	div    %ebp
  80326b:	89 c8                	mov    %ecx,%eax
  80326d:	f7 f5                	div    %ebp
  80326f:	89 d0                	mov    %edx,%eax
  803271:	e9 44 ff ff ff       	jmp    8031ba <__umoddi3+0x3e>
  803276:	66 90                	xchg   %ax,%ax
  803278:	89 c8                	mov    %ecx,%eax
  80327a:	89 f2                	mov    %esi,%edx
  80327c:	83 c4 1c             	add    $0x1c,%esp
  80327f:	5b                   	pop    %ebx
  803280:	5e                   	pop    %esi
  803281:	5f                   	pop    %edi
  803282:	5d                   	pop    %ebp
  803283:	c3                   	ret    
  803284:	3b 04 24             	cmp    (%esp),%eax
  803287:	72 06                	jb     80328f <__umoddi3+0x113>
  803289:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  80328d:	77 0f                	ja     80329e <__umoddi3+0x122>
  80328f:	89 f2                	mov    %esi,%edx
  803291:	29 f9                	sub    %edi,%ecx
  803293:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  803297:	89 14 24             	mov    %edx,(%esp)
  80329a:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  80329e:	8b 44 24 04          	mov    0x4(%esp),%eax
  8032a2:	8b 14 24             	mov    (%esp),%edx
  8032a5:	83 c4 1c             	add    $0x1c,%esp
  8032a8:	5b                   	pop    %ebx
  8032a9:	5e                   	pop    %esi
  8032aa:	5f                   	pop    %edi
  8032ab:	5d                   	pop    %ebp
  8032ac:	c3                   	ret    
  8032ad:	8d 76 00             	lea    0x0(%esi),%esi
  8032b0:	2b 04 24             	sub    (%esp),%eax
  8032b3:	19 fa                	sbb    %edi,%edx
  8032b5:	89 d1                	mov    %edx,%ecx
  8032b7:	89 c6                	mov    %eax,%esi
  8032b9:	e9 71 ff ff ff       	jmp    80322f <__umoddi3+0xb3>
  8032be:	66 90                	xchg   %ax,%ax
  8032c0:	39 44 24 04          	cmp    %eax,0x4(%esp)
  8032c4:	72 ea                	jb     8032b0 <__umoddi3+0x134>
  8032c6:	89 d9                	mov    %ebx,%ecx
  8032c8:	e9 62 ff ff ff       	jmp    80322f <__umoddi3+0xb3>
