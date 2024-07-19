
obj/user/arrayOperations_mergesort:     file format elf32-i386


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
  800031:	e8 3d 04 00 00       	call   800473 <libmain>
1:      jmp 1b
  800036:	eb fe                	jmp    800036 <args_exist+0x5>

00800038 <_main>:

//int *Left;
//int *Right;

void _main(void)
{
  800038:	55                   	push   %ebp
  800039:	89 e5                	mov    %esp,%ebp
  80003b:	83 ec 28             	sub    $0x28,%esp
	int32 parentenvID = sys_getparentenvid();
  80003e:	e8 d7 1c 00 00       	call   801d1a <sys_getparentenvid>
  800043:	89 45 f0             	mov    %eax,-0x10(%ebp)

	int ret;
	/*[1] GET SHARED VARs*/
	//Get the shared array & its size
	int *numOfElements = NULL;
  800046:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
	int *sharedArray = NULL;
  80004d:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
	sharedArray = sget(parentenvID, "arr") ;
  800054:	83 ec 08             	sub    $0x8,%esp
  800057:	68 00 34 80 00       	push   $0x803400
  80005c:	ff 75 f0             	pushl  -0x10(%ebp)
  80005f:	e8 a9 17 00 00       	call   80180d <sget>
  800064:	83 c4 10             	add    $0x10,%esp
  800067:	89 45 e8             	mov    %eax,-0x18(%ebp)
	numOfElements = sget(parentenvID, "arrSize") ;
  80006a:	83 ec 08             	sub    $0x8,%esp
  80006d:	68 04 34 80 00       	push   $0x803404
  800072:	ff 75 f0             	pushl  -0x10(%ebp)
  800075:	e8 93 17 00 00       	call   80180d <sget>
  80007a:	83 c4 10             	add    $0x10,%esp
  80007d:	89 45 ec             	mov    %eax,-0x14(%ebp)
	//PrintElements(sharedArray, *numOfElements);

	//Get the check-finishing counter
	int *finishedCount = NULL;
  800080:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	finishedCount = sget(parentenvID, "finishedCount") ;
  800087:	83 ec 08             	sub    $0x8,%esp
  80008a:	68 0c 34 80 00       	push   $0x80340c
  80008f:	ff 75 f0             	pushl  -0x10(%ebp)
  800092:	e8 76 17 00 00       	call   80180d <sget>
  800097:	83 c4 10             	add    $0x10,%esp
  80009a:	89 45 e4             	mov    %eax,-0x1c(%ebp)

	/*[2] DO THE JOB*/
	//take a copy from the original array
	int *sortedArray;

	sortedArray = smalloc("mergesortedArr", sizeof(int) * *numOfElements, 0) ;
  80009d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8000a0:	8b 00                	mov    (%eax),%eax
  8000a2:	c1 e0 02             	shl    $0x2,%eax
  8000a5:	83 ec 04             	sub    $0x4,%esp
  8000a8:	6a 00                	push   $0x0
  8000aa:	50                   	push   %eax
  8000ab:	68 1a 34 80 00       	push   $0x80341a
  8000b0:	e8 a8 16 00 00       	call   80175d <smalloc>
  8000b5:	83 c4 10             	add    $0x10,%esp
  8000b8:	89 45 e0             	mov    %eax,-0x20(%ebp)
	int i ;
	for (i = 0 ; i < *numOfElements ; i++)
  8000bb:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  8000c2:	eb 25                	jmp    8000e9 <_main+0xb1>
	{
		sortedArray[i] = sharedArray[i];
  8000c4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8000c7:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8000ce:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8000d1:	01 c2                	add    %eax,%edx
  8000d3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8000d6:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  8000dd:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8000e0:	01 c8                	add    %ecx,%eax
  8000e2:	8b 00                	mov    (%eax),%eax
  8000e4:	89 02                	mov    %eax,(%edx)
	//take a copy from the original array
	int *sortedArray;

	sortedArray = smalloc("mergesortedArr", sizeof(int) * *numOfElements, 0) ;
	int i ;
	for (i = 0 ; i < *numOfElements ; i++)
  8000e6:	ff 45 f4             	incl   -0xc(%ebp)
  8000e9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8000ec:	8b 00                	mov    (%eax),%eax
  8000ee:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  8000f1:	7f d1                	jg     8000c4 <_main+0x8c>
	}
//	//Create two temps array for "left" & "right"
//	Left = smalloc("mergesortLeftArr", sizeof(int) * (*numOfElements), 1) ;
//	Right = smalloc("mergesortRightArr", sizeof(int) * (*numOfElements), 1) ;

	MSort(sortedArray, 1, *numOfElements);
  8000f3:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8000f6:	8b 00                	mov    (%eax),%eax
  8000f8:	83 ec 04             	sub    $0x4,%esp
  8000fb:	50                   	push   %eax
  8000fc:	6a 01                	push   $0x1
  8000fe:	ff 75 e0             	pushl  -0x20(%ebp)
  800101:	e8 fc 00 00 00       	call   800202 <MSort>
  800106:	83 c4 10             	add    $0x10,%esp
	cprintf("Merge sort is Finished!!!!\n") ;
  800109:	83 ec 0c             	sub    $0xc,%esp
  80010c:	68 29 34 80 00       	push   $0x803429
  800111:	e8 6d 05 00 00       	call   800683 <cprintf>
  800116:	83 c4 10             	add    $0x10,%esp

	/*[3] SHARE THE RESULTS & DECLARE FINISHING*/
	(*finishedCount)++ ;
  800119:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80011c:	8b 00                	mov    (%eax),%eax
  80011e:	8d 50 01             	lea    0x1(%eax),%edx
  800121:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800124:	89 10                	mov    %edx,(%eax)

}
  800126:	90                   	nop
  800127:	c9                   	leave  
  800128:	c3                   	ret    

00800129 <Swap>:

void Swap(int *Elements, int First, int Second)
{
  800129:	55                   	push   %ebp
  80012a:	89 e5                	mov    %esp,%ebp
  80012c:	83 ec 10             	sub    $0x10,%esp
	int Tmp = Elements[First] ;
  80012f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800132:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800139:	8b 45 08             	mov    0x8(%ebp),%eax
  80013c:	01 d0                	add    %edx,%eax
  80013e:	8b 00                	mov    (%eax),%eax
  800140:	89 45 fc             	mov    %eax,-0x4(%ebp)
	Elements[First] = Elements[Second] ;
  800143:	8b 45 0c             	mov    0xc(%ebp),%eax
  800146:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80014d:	8b 45 08             	mov    0x8(%ebp),%eax
  800150:	01 c2                	add    %eax,%edx
  800152:	8b 45 10             	mov    0x10(%ebp),%eax
  800155:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  80015c:	8b 45 08             	mov    0x8(%ebp),%eax
  80015f:	01 c8                	add    %ecx,%eax
  800161:	8b 00                	mov    (%eax),%eax
  800163:	89 02                	mov    %eax,(%edx)
	Elements[Second] = Tmp ;
  800165:	8b 45 10             	mov    0x10(%ebp),%eax
  800168:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80016f:	8b 45 08             	mov    0x8(%ebp),%eax
  800172:	01 c2                	add    %eax,%edx
  800174:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800177:	89 02                	mov    %eax,(%edx)
}
  800179:	90                   	nop
  80017a:	c9                   	leave  
  80017b:	c3                   	ret    

0080017c <PrintElements>:


void PrintElements(int *Elements, int NumOfElements)
{
  80017c:	55                   	push   %ebp
  80017d:	89 e5                	mov    %esp,%ebp
  80017f:	83 ec 18             	sub    $0x18,%esp
	int i ;
	int NumsPerLine = 20 ;
  800182:	c7 45 f0 14 00 00 00 	movl   $0x14,-0x10(%ebp)
	for (i = 0 ; i < NumOfElements-1 ; i++)
  800189:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  800190:	eb 42                	jmp    8001d4 <PrintElements+0x58>
	{
		if (i%NumsPerLine == 0)
  800192:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800195:	99                   	cltd   
  800196:	f7 7d f0             	idivl  -0x10(%ebp)
  800199:	89 d0                	mov    %edx,%eax
  80019b:	85 c0                	test   %eax,%eax
  80019d:	75 10                	jne    8001af <PrintElements+0x33>
			cprintf("\n");
  80019f:	83 ec 0c             	sub    $0xc,%esp
  8001a2:	68 45 34 80 00       	push   $0x803445
  8001a7:	e8 d7 04 00 00       	call   800683 <cprintf>
  8001ac:	83 c4 10             	add    $0x10,%esp
		cprintf("%d, ",Elements[i]);
  8001af:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8001b2:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8001b9:	8b 45 08             	mov    0x8(%ebp),%eax
  8001bc:	01 d0                	add    %edx,%eax
  8001be:	8b 00                	mov    (%eax),%eax
  8001c0:	83 ec 08             	sub    $0x8,%esp
  8001c3:	50                   	push   %eax
  8001c4:	68 47 34 80 00       	push   $0x803447
  8001c9:	e8 b5 04 00 00       	call   800683 <cprintf>
  8001ce:	83 c4 10             	add    $0x10,%esp

void PrintElements(int *Elements, int NumOfElements)
{
	int i ;
	int NumsPerLine = 20 ;
	for (i = 0 ; i < NumOfElements-1 ; i++)
  8001d1:	ff 45 f4             	incl   -0xc(%ebp)
  8001d4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8001d7:	48                   	dec    %eax
  8001d8:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  8001db:	7f b5                	jg     800192 <PrintElements+0x16>
	{
		if (i%NumsPerLine == 0)
			cprintf("\n");
		cprintf("%d, ",Elements[i]);
	}
	cprintf("%d\n",Elements[i]);
  8001dd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8001e0:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8001e7:	8b 45 08             	mov    0x8(%ebp),%eax
  8001ea:	01 d0                	add    %edx,%eax
  8001ec:	8b 00                	mov    (%eax),%eax
  8001ee:	83 ec 08             	sub    $0x8,%esp
  8001f1:	50                   	push   %eax
  8001f2:	68 4c 34 80 00       	push   $0x80344c
  8001f7:	e8 87 04 00 00       	call   800683 <cprintf>
  8001fc:	83 c4 10             	add    $0x10,%esp

}
  8001ff:	90                   	nop
  800200:	c9                   	leave  
  800201:	c3                   	ret    

00800202 <MSort>:


void MSort(int* A, int p, int r)
{
  800202:	55                   	push   %ebp
  800203:	89 e5                	mov    %esp,%ebp
  800205:	83 ec 18             	sub    $0x18,%esp
	if (p >= r)
  800208:	8b 45 0c             	mov    0xc(%ebp),%eax
  80020b:	3b 45 10             	cmp    0x10(%ebp),%eax
  80020e:	7d 54                	jge    800264 <MSort+0x62>
	{
		return;
	}

	int q = (p + r) / 2;
  800210:	8b 55 0c             	mov    0xc(%ebp),%edx
  800213:	8b 45 10             	mov    0x10(%ebp),%eax
  800216:	01 d0                	add    %edx,%eax
  800218:	89 c2                	mov    %eax,%edx
  80021a:	c1 ea 1f             	shr    $0x1f,%edx
  80021d:	01 d0                	add    %edx,%eax
  80021f:	d1 f8                	sar    %eax
  800221:	89 45 f4             	mov    %eax,-0xc(%ebp)

	MSort(A, p, q);
  800224:	83 ec 04             	sub    $0x4,%esp
  800227:	ff 75 f4             	pushl  -0xc(%ebp)
  80022a:	ff 75 0c             	pushl  0xc(%ebp)
  80022d:	ff 75 08             	pushl  0x8(%ebp)
  800230:	e8 cd ff ff ff       	call   800202 <MSort>
  800235:	83 c4 10             	add    $0x10,%esp
//	cprintf("LEFT is sorted: from %d to %d\n", p, q);

	MSort(A, q + 1, r);
  800238:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80023b:	40                   	inc    %eax
  80023c:	83 ec 04             	sub    $0x4,%esp
  80023f:	ff 75 10             	pushl  0x10(%ebp)
  800242:	50                   	push   %eax
  800243:	ff 75 08             	pushl  0x8(%ebp)
  800246:	e8 b7 ff ff ff       	call   800202 <MSort>
  80024b:	83 c4 10             	add    $0x10,%esp
//	cprintf("RIGHT is sorted: from %d to %d\n", q+1, r);

	Merge(A, p, q, r);
  80024e:	ff 75 10             	pushl  0x10(%ebp)
  800251:	ff 75 f4             	pushl  -0xc(%ebp)
  800254:	ff 75 0c             	pushl  0xc(%ebp)
  800257:	ff 75 08             	pushl  0x8(%ebp)
  80025a:	e8 08 00 00 00       	call   800267 <Merge>
  80025f:	83 c4 10             	add    $0x10,%esp
  800262:	eb 01                	jmp    800265 <MSort+0x63>

void MSort(int* A, int p, int r)
{
	if (p >= r)
	{
		return;
  800264:	90                   	nop
//	cprintf("RIGHT is sorted: from %d to %d\n", q+1, r);

	Merge(A, p, q, r);
	//cprintf("[%d %d] + [%d %d] = [%d %d]\n", p, q, q+1, r, p, r);

}
  800265:	c9                   	leave  
  800266:	c3                   	ret    

00800267 <Merge>:

void Merge(int* A, int p, int q, int r)
{
  800267:	55                   	push   %ebp
  800268:	89 e5                	mov    %esp,%ebp
  80026a:	83 ec 38             	sub    $0x38,%esp
	int leftCapacity = q - p + 1;
  80026d:	8b 45 10             	mov    0x10(%ebp),%eax
  800270:	2b 45 0c             	sub    0xc(%ebp),%eax
  800273:	40                   	inc    %eax
  800274:	89 45 e0             	mov    %eax,-0x20(%ebp)

	int rightCapacity = r - q;
  800277:	8b 45 14             	mov    0x14(%ebp),%eax
  80027a:	2b 45 10             	sub    0x10(%ebp),%eax
  80027d:	89 45 dc             	mov    %eax,-0x24(%ebp)

	int leftIndex = 0;
  800280:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	int rightIndex = 0;
  800287:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)

	int* Left = malloc(sizeof(int) * leftCapacity);
  80028e:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800291:	c1 e0 02             	shl    $0x2,%eax
  800294:	83 ec 0c             	sub    $0xc,%esp
  800297:	50                   	push   %eax
  800298:	e8 78 13 00 00       	call   801615 <malloc>
  80029d:	83 c4 10             	add    $0x10,%esp
  8002a0:	89 45 d8             	mov    %eax,-0x28(%ebp)

	int* Right = malloc(sizeof(int) * rightCapacity);
  8002a3:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8002a6:	c1 e0 02             	shl    $0x2,%eax
  8002a9:	83 ec 0c             	sub    $0xc,%esp
  8002ac:	50                   	push   %eax
  8002ad:	e8 63 13 00 00       	call   801615 <malloc>
  8002b2:	83 c4 10             	add    $0x10,%esp
  8002b5:	89 45 d4             	mov    %eax,-0x2c(%ebp)

	int i, j, k;
	for (i = 0; i < leftCapacity; i++)
  8002b8:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  8002bf:	eb 2f                	jmp    8002f0 <Merge+0x89>
	{
		Left[i] = A[p + i - 1];
  8002c1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8002c4:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8002cb:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8002ce:	01 c2                	add    %eax,%edx
  8002d0:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8002d3:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8002d6:	01 c8                	add    %ecx,%eax
  8002d8:	05 ff ff ff 3f       	add    $0x3fffffff,%eax
  8002dd:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  8002e4:	8b 45 08             	mov    0x8(%ebp),%eax
  8002e7:	01 c8                	add    %ecx,%eax
  8002e9:	8b 00                	mov    (%eax),%eax
  8002eb:	89 02                	mov    %eax,(%edx)
	int* Left = malloc(sizeof(int) * leftCapacity);

	int* Right = malloc(sizeof(int) * rightCapacity);

	int i, j, k;
	for (i = 0; i < leftCapacity; i++)
  8002ed:	ff 45 ec             	incl   -0x14(%ebp)
  8002f0:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8002f3:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  8002f6:	7c c9                	jl     8002c1 <Merge+0x5a>
	{
		Left[i] = A[p + i - 1];
	}
	for (j = 0; j < rightCapacity; j++)
  8002f8:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  8002ff:	eb 2a                	jmp    80032b <Merge+0xc4>
	{
		Right[j] = A[q + j];
  800301:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800304:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80030b:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80030e:	01 c2                	add    %eax,%edx
  800310:	8b 4d 10             	mov    0x10(%ebp),%ecx
  800313:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800316:	01 c8                	add    %ecx,%eax
  800318:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  80031f:	8b 45 08             	mov    0x8(%ebp),%eax
  800322:	01 c8                	add    %ecx,%eax
  800324:	8b 00                	mov    (%eax),%eax
  800326:	89 02                	mov    %eax,(%edx)
	int i, j, k;
	for (i = 0; i < leftCapacity; i++)
	{
		Left[i] = A[p + i - 1];
	}
	for (j = 0; j < rightCapacity; j++)
  800328:	ff 45 e8             	incl   -0x18(%ebp)
  80032b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80032e:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  800331:	7c ce                	jl     800301 <Merge+0x9a>
	{
		Right[j] = A[q + j];
	}

	for ( k = p; k <= r; k++)
  800333:	8b 45 0c             	mov    0xc(%ebp),%eax
  800336:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800339:	e9 0a 01 00 00       	jmp    800448 <Merge+0x1e1>
	{
		if (leftIndex < leftCapacity && rightIndex < rightCapacity)
  80033e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800341:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  800344:	0f 8d 95 00 00 00    	jge    8003df <Merge+0x178>
  80034a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80034d:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  800350:	0f 8d 89 00 00 00    	jge    8003df <Merge+0x178>
		{
			if (Left[leftIndex] < Right[rightIndex] )
  800356:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800359:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800360:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800363:	01 d0                	add    %edx,%eax
  800365:	8b 10                	mov    (%eax),%edx
  800367:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80036a:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  800371:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  800374:	01 c8                	add    %ecx,%eax
  800376:	8b 00                	mov    (%eax),%eax
  800378:	39 c2                	cmp    %eax,%edx
  80037a:	7d 33                	jge    8003af <Merge+0x148>
			{
				A[k - 1] = Left[leftIndex++];
  80037c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80037f:	05 ff ff ff 3f       	add    $0x3fffffff,%eax
  800384:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80038b:	8b 45 08             	mov    0x8(%ebp),%eax
  80038e:	8d 0c 02             	lea    (%edx,%eax,1),%ecx
  800391:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800394:	8d 50 01             	lea    0x1(%eax),%edx
  800397:	89 55 f4             	mov    %edx,-0xc(%ebp)
  80039a:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8003a1:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8003a4:	01 d0                	add    %edx,%eax
  8003a6:	8b 00                	mov    (%eax),%eax
  8003a8:	89 01                	mov    %eax,(%ecx)

	for ( k = p; k <= r; k++)
	{
		if (leftIndex < leftCapacity && rightIndex < rightCapacity)
		{
			if (Left[leftIndex] < Right[rightIndex] )
  8003aa:	e9 96 00 00 00       	jmp    800445 <Merge+0x1de>
			{
				A[k - 1] = Left[leftIndex++];
			}
			else
			{
				A[k - 1] = Right[rightIndex++];
  8003af:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8003b2:	05 ff ff ff 3f       	add    $0x3fffffff,%eax
  8003b7:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8003be:	8b 45 08             	mov    0x8(%ebp),%eax
  8003c1:	8d 0c 02             	lea    (%edx,%eax,1),%ecx
  8003c4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8003c7:	8d 50 01             	lea    0x1(%eax),%edx
  8003ca:	89 55 f0             	mov    %edx,-0x10(%ebp)
  8003cd:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8003d4:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8003d7:	01 d0                	add    %edx,%eax
  8003d9:	8b 00                	mov    (%eax),%eax
  8003db:	89 01                	mov    %eax,(%ecx)

	for ( k = p; k <= r; k++)
	{
		if (leftIndex < leftCapacity && rightIndex < rightCapacity)
		{
			if (Left[leftIndex] < Right[rightIndex] )
  8003dd:	eb 66                	jmp    800445 <Merge+0x1de>
			else
			{
				A[k - 1] = Right[rightIndex++];
			}
		}
		else if (leftIndex < leftCapacity)
  8003df:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8003e2:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  8003e5:	7d 30                	jge    800417 <Merge+0x1b0>
		{
			A[k - 1] = Left[leftIndex++];
  8003e7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8003ea:	05 ff ff ff 3f       	add    $0x3fffffff,%eax
  8003ef:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8003f6:	8b 45 08             	mov    0x8(%ebp),%eax
  8003f9:	8d 0c 02             	lea    (%edx,%eax,1),%ecx
  8003fc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8003ff:	8d 50 01             	lea    0x1(%eax),%edx
  800402:	89 55 f4             	mov    %edx,-0xc(%ebp)
  800405:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80040c:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80040f:	01 d0                	add    %edx,%eax
  800411:	8b 00                	mov    (%eax),%eax
  800413:	89 01                	mov    %eax,(%ecx)
  800415:	eb 2e                	jmp    800445 <Merge+0x1de>
		}
		else
		{
			A[k - 1] = Right[rightIndex++];
  800417:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80041a:	05 ff ff ff 3f       	add    $0x3fffffff,%eax
  80041f:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800426:	8b 45 08             	mov    0x8(%ebp),%eax
  800429:	8d 0c 02             	lea    (%edx,%eax,1),%ecx
  80042c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80042f:	8d 50 01             	lea    0x1(%eax),%edx
  800432:	89 55 f0             	mov    %edx,-0x10(%ebp)
  800435:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80043c:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80043f:	01 d0                	add    %edx,%eax
  800441:	8b 00                	mov    (%eax),%eax
  800443:	89 01                	mov    %eax,(%ecx)
	for (j = 0; j < rightCapacity; j++)
	{
		Right[j] = A[q + j];
	}

	for ( k = p; k <= r; k++)
  800445:	ff 45 e4             	incl   -0x1c(%ebp)
  800448:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80044b:	3b 45 14             	cmp    0x14(%ebp),%eax
  80044e:	0f 8e ea fe ff ff    	jle    80033e <Merge+0xd7>
		{
			A[k - 1] = Right[rightIndex++];
		}
	}

	free(Left);
  800454:	83 ec 0c             	sub    $0xc,%esp
  800457:	ff 75 d8             	pushl  -0x28(%ebp)
  80045a:	e8 37 12 00 00       	call   801696 <free>
  80045f:	83 c4 10             	add    $0x10,%esp
	free(Right);
  800462:	83 ec 0c             	sub    $0xc,%esp
  800465:	ff 75 d4             	pushl  -0x2c(%ebp)
  800468:	e8 29 12 00 00       	call   801696 <free>
  80046d:	83 c4 10             	add    $0x10,%esp

}
  800470:	90                   	nop
  800471:	c9                   	leave  
  800472:	c3                   	ret    

00800473 <libmain>:
volatile struct Env *myEnv = NULL;
volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";

void
libmain(int argc, char **argv)
{
  800473:	55                   	push   %ebp
  800474:	89 e5                	mov    %esp,%ebp
  800476:	83 ec 18             	sub    $0x18,%esp
	int envIndex = sys_getenvindex();
  800479:	e8 83 18 00 00       	call   801d01 <sys_getenvindex>
  80047e:	89 45 f4             	mov    %eax,-0xc(%ebp)
	myEnv = &(envs[envIndex]);
  800481:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800484:	89 d0                	mov    %edx,%eax
  800486:	c1 e0 03             	shl    $0x3,%eax
  800489:	01 d0                	add    %edx,%eax
  80048b:	01 c0                	add    %eax,%eax
  80048d:	01 d0                	add    %edx,%eax
  80048f:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800496:	01 d0                	add    %edx,%eax
  800498:	c1 e0 04             	shl    $0x4,%eax
  80049b:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8004a0:	a3 20 40 80 00       	mov    %eax,0x804020

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  8004a5:	a1 20 40 80 00       	mov    0x804020,%eax
  8004aa:	8a 80 5c 05 00 00    	mov    0x55c(%eax),%al
  8004b0:	84 c0                	test   %al,%al
  8004b2:	74 0f                	je     8004c3 <libmain+0x50>
		binaryname = myEnv->prog_name;
  8004b4:	a1 20 40 80 00       	mov    0x804020,%eax
  8004b9:	05 5c 05 00 00       	add    $0x55c,%eax
  8004be:	a3 00 40 80 00       	mov    %eax,0x804000

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8004c3:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8004c7:	7e 0a                	jle    8004d3 <libmain+0x60>
		binaryname = argv[0];
  8004c9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8004cc:	8b 00                	mov    (%eax),%eax
  8004ce:	a3 00 40 80 00       	mov    %eax,0x804000

	// call user main routine
	_main(argc, argv);
  8004d3:	83 ec 08             	sub    $0x8,%esp
  8004d6:	ff 75 0c             	pushl  0xc(%ebp)
  8004d9:	ff 75 08             	pushl  0x8(%ebp)
  8004dc:	e8 57 fb ff ff       	call   800038 <_main>
  8004e1:	83 c4 10             	add    $0x10,%esp



	sys_disable_interrupt();
  8004e4:	e8 25 16 00 00       	call   801b0e <sys_disable_interrupt>
	cprintf("**************************************\n");
  8004e9:	83 ec 0c             	sub    $0xc,%esp
  8004ec:	68 68 34 80 00       	push   $0x803468
  8004f1:	e8 8d 01 00 00       	call   800683 <cprintf>
  8004f6:	83 c4 10             	add    $0x10,%esp
	cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  8004f9:	a1 20 40 80 00       	mov    0x804020,%eax
  8004fe:	8b 90 44 05 00 00    	mov    0x544(%eax),%edx
  800504:	a1 20 40 80 00       	mov    0x804020,%eax
  800509:	8b 80 34 05 00 00    	mov    0x534(%eax),%eax
  80050f:	83 ec 04             	sub    $0x4,%esp
  800512:	52                   	push   %edx
  800513:	50                   	push   %eax
  800514:	68 90 34 80 00       	push   $0x803490
  800519:	e8 65 01 00 00       	call   800683 <cprintf>
  80051e:	83 c4 10             	add    $0x10,%esp
	cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  800521:	a1 20 40 80 00       	mov    0x804020,%eax
  800526:	8b 88 54 05 00 00    	mov    0x554(%eax),%ecx
  80052c:	a1 20 40 80 00       	mov    0x804020,%eax
  800531:	8b 90 50 05 00 00    	mov    0x550(%eax),%edx
  800537:	a1 20 40 80 00       	mov    0x804020,%eax
  80053c:	8b 80 4c 05 00 00    	mov    0x54c(%eax),%eax
  800542:	51                   	push   %ecx
  800543:	52                   	push   %edx
  800544:	50                   	push   %eax
  800545:	68 b8 34 80 00       	push   $0x8034b8
  80054a:	e8 34 01 00 00       	call   800683 <cprintf>
  80054f:	83 c4 10             	add    $0x10,%esp
	//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
	cprintf("Num of clocks = %d\n", myEnv->nClocks);
  800552:	a1 20 40 80 00       	mov    0x804020,%eax
  800557:	8b 80 a4 05 00 00    	mov    0x5a4(%eax),%eax
  80055d:	83 ec 08             	sub    $0x8,%esp
  800560:	50                   	push   %eax
  800561:	68 10 35 80 00       	push   $0x803510
  800566:	e8 18 01 00 00       	call   800683 <cprintf>
  80056b:	83 c4 10             	add    $0x10,%esp
	cprintf("**************************************\n");
  80056e:	83 ec 0c             	sub    $0xc,%esp
  800571:	68 68 34 80 00       	push   $0x803468
  800576:	e8 08 01 00 00       	call   800683 <cprintf>
  80057b:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  80057e:	e8 a5 15 00 00       	call   801b28 <sys_enable_interrupt>

	// exit gracefully
	exit();
  800583:	e8 19 00 00 00       	call   8005a1 <exit>
}
  800588:	90                   	nop
  800589:	c9                   	leave  
  80058a:	c3                   	ret    

0080058b <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  80058b:	55                   	push   %ebp
  80058c:	89 e5                	mov    %esp,%ebp
  80058e:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  800591:	83 ec 0c             	sub    $0xc,%esp
  800594:	6a 00                	push   $0x0
  800596:	e8 32 17 00 00       	call   801ccd <sys_destroy_env>
  80059b:	83 c4 10             	add    $0x10,%esp
}
  80059e:	90                   	nop
  80059f:	c9                   	leave  
  8005a0:	c3                   	ret    

008005a1 <exit>:

void
exit(void)
{
  8005a1:	55                   	push   %ebp
  8005a2:	89 e5                	mov    %esp,%ebp
  8005a4:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  8005a7:	e8 87 17 00 00       	call   801d33 <sys_exit_env>
}
  8005ac:	90                   	nop
  8005ad:	c9                   	leave  
  8005ae:	c3                   	ret    

008005af <putch>:
};

//2017:
uint8 printProgName = 0;

static void putch(int ch, struct printbuf *b) {
  8005af:	55                   	push   %ebp
  8005b0:	89 e5                	mov    %esp,%ebp
  8005b2:	83 ec 08             	sub    $0x8,%esp
	b->buf[b->idx++] = ch;
  8005b5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8005b8:	8b 00                	mov    (%eax),%eax
  8005ba:	8d 48 01             	lea    0x1(%eax),%ecx
  8005bd:	8b 55 0c             	mov    0xc(%ebp),%edx
  8005c0:	89 0a                	mov    %ecx,(%edx)
  8005c2:	8b 55 08             	mov    0x8(%ebp),%edx
  8005c5:	88 d1                	mov    %dl,%cl
  8005c7:	8b 55 0c             	mov    0xc(%ebp),%edx
  8005ca:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  8005ce:	8b 45 0c             	mov    0xc(%ebp),%eax
  8005d1:	8b 00                	mov    (%eax),%eax
  8005d3:	3d ff 00 00 00       	cmp    $0xff,%eax
  8005d8:	75 2c                	jne    800606 <putch+0x57>
		sys_cputs(b->buf, b->idx, printProgName);
  8005da:	a0 24 40 80 00       	mov    0x804024,%al
  8005df:	0f b6 c0             	movzbl %al,%eax
  8005e2:	8b 55 0c             	mov    0xc(%ebp),%edx
  8005e5:	8b 12                	mov    (%edx),%edx
  8005e7:	89 d1                	mov    %edx,%ecx
  8005e9:	8b 55 0c             	mov    0xc(%ebp),%edx
  8005ec:	83 c2 08             	add    $0x8,%edx
  8005ef:	83 ec 04             	sub    $0x4,%esp
  8005f2:	50                   	push   %eax
  8005f3:	51                   	push   %ecx
  8005f4:	52                   	push   %edx
  8005f5:	e8 66 13 00 00       	call   801960 <sys_cputs>
  8005fa:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  8005fd:	8b 45 0c             	mov    0xc(%ebp),%eax
  800600:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  800606:	8b 45 0c             	mov    0xc(%ebp),%eax
  800609:	8b 40 04             	mov    0x4(%eax),%eax
  80060c:	8d 50 01             	lea    0x1(%eax),%edx
  80060f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800612:	89 50 04             	mov    %edx,0x4(%eax)
}
  800615:	90                   	nop
  800616:	c9                   	leave  
  800617:	c3                   	ret    

00800618 <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  800618:	55                   	push   %ebp
  800619:	89 e5                	mov    %esp,%ebp
  80061b:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  800621:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800628:	00 00 00 
	b.cnt = 0;
  80062b:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800632:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  800635:	ff 75 0c             	pushl  0xc(%ebp)
  800638:	ff 75 08             	pushl  0x8(%ebp)
  80063b:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800641:	50                   	push   %eax
  800642:	68 af 05 80 00       	push   $0x8005af
  800647:	e8 11 02 00 00       	call   80085d <vprintfmt>
  80064c:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName);
  80064f:	a0 24 40 80 00       	mov    0x804024,%al
  800654:	0f b6 c0             	movzbl %al,%eax
  800657:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  80065d:	83 ec 04             	sub    $0x4,%esp
  800660:	50                   	push   %eax
  800661:	52                   	push   %edx
  800662:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800668:	83 c0 08             	add    $0x8,%eax
  80066b:	50                   	push   %eax
  80066c:	e8 ef 12 00 00       	call   801960 <sys_cputs>
  800671:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  800674:	c6 05 24 40 80 00 00 	movb   $0x0,0x804024
	return b.cnt;
  80067b:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  800681:	c9                   	leave  
  800682:	c3                   	ret    

00800683 <cprintf>:

int cprintf(const char *fmt, ...) {
  800683:	55                   	push   %ebp
  800684:	89 e5                	mov    %esp,%ebp
  800686:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  800689:	c6 05 24 40 80 00 01 	movb   $0x1,0x804024
	va_start(ap, fmt);
  800690:	8d 45 0c             	lea    0xc(%ebp),%eax
  800693:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800696:	8b 45 08             	mov    0x8(%ebp),%eax
  800699:	83 ec 08             	sub    $0x8,%esp
  80069c:	ff 75 f4             	pushl  -0xc(%ebp)
  80069f:	50                   	push   %eax
  8006a0:	e8 73 ff ff ff       	call   800618 <vcprintf>
  8006a5:	83 c4 10             	add    $0x10,%esp
  8006a8:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  8006ab:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8006ae:	c9                   	leave  
  8006af:	c3                   	ret    

008006b0 <atomic_cprintf>:

int atomic_cprintf(const char *fmt, ...) {
  8006b0:	55                   	push   %ebp
  8006b1:	89 e5                	mov    %esp,%ebp
  8006b3:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  8006b6:	e8 53 14 00 00       	call   801b0e <sys_disable_interrupt>
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  8006bb:	8d 45 0c             	lea    0xc(%ebp),%eax
  8006be:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  8006c1:	8b 45 08             	mov    0x8(%ebp),%eax
  8006c4:	83 ec 08             	sub    $0x8,%esp
  8006c7:	ff 75 f4             	pushl  -0xc(%ebp)
  8006ca:	50                   	push   %eax
  8006cb:	e8 48 ff ff ff       	call   800618 <vcprintf>
  8006d0:	83 c4 10             	add    $0x10,%esp
  8006d3:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	sys_enable_interrupt();
  8006d6:	e8 4d 14 00 00       	call   801b28 <sys_enable_interrupt>
	return cnt;
  8006db:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8006de:	c9                   	leave  
  8006df:	c3                   	ret    

008006e0 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8006e0:	55                   	push   %ebp
  8006e1:	89 e5                	mov    %esp,%ebp
  8006e3:	53                   	push   %ebx
  8006e4:	83 ec 14             	sub    $0x14,%esp
  8006e7:	8b 45 10             	mov    0x10(%ebp),%eax
  8006ea:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8006ed:	8b 45 14             	mov    0x14(%ebp),%eax
  8006f0:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  8006f3:	8b 45 18             	mov    0x18(%ebp),%eax
  8006f6:	ba 00 00 00 00       	mov    $0x0,%edx
  8006fb:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  8006fe:	77 55                	ja     800755 <printnum+0x75>
  800700:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800703:	72 05                	jb     80070a <printnum+0x2a>
  800705:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800708:	77 4b                	ja     800755 <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  80070a:	8b 45 1c             	mov    0x1c(%ebp),%eax
  80070d:	8d 58 ff             	lea    -0x1(%eax),%ebx
  800710:	8b 45 18             	mov    0x18(%ebp),%eax
  800713:	ba 00 00 00 00       	mov    $0x0,%edx
  800718:	52                   	push   %edx
  800719:	50                   	push   %eax
  80071a:	ff 75 f4             	pushl  -0xc(%ebp)
  80071d:	ff 75 f0             	pushl  -0x10(%ebp)
  800720:	e8 67 2a 00 00       	call   80318c <__udivdi3>
  800725:	83 c4 10             	add    $0x10,%esp
  800728:	83 ec 04             	sub    $0x4,%esp
  80072b:	ff 75 20             	pushl  0x20(%ebp)
  80072e:	53                   	push   %ebx
  80072f:	ff 75 18             	pushl  0x18(%ebp)
  800732:	52                   	push   %edx
  800733:	50                   	push   %eax
  800734:	ff 75 0c             	pushl  0xc(%ebp)
  800737:	ff 75 08             	pushl  0x8(%ebp)
  80073a:	e8 a1 ff ff ff       	call   8006e0 <printnum>
  80073f:	83 c4 20             	add    $0x20,%esp
  800742:	eb 1a                	jmp    80075e <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800744:	83 ec 08             	sub    $0x8,%esp
  800747:	ff 75 0c             	pushl  0xc(%ebp)
  80074a:	ff 75 20             	pushl  0x20(%ebp)
  80074d:	8b 45 08             	mov    0x8(%ebp),%eax
  800750:	ff d0                	call   *%eax
  800752:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800755:	ff 4d 1c             	decl   0x1c(%ebp)
  800758:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  80075c:	7f e6                	jg     800744 <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  80075e:	8b 4d 18             	mov    0x18(%ebp),%ecx
  800761:	bb 00 00 00 00       	mov    $0x0,%ebx
  800766:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800769:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80076c:	53                   	push   %ebx
  80076d:	51                   	push   %ecx
  80076e:	52                   	push   %edx
  80076f:	50                   	push   %eax
  800770:	e8 27 2b 00 00       	call   80329c <__umoddi3>
  800775:	83 c4 10             	add    $0x10,%esp
  800778:	05 54 37 80 00       	add    $0x803754,%eax
  80077d:	8a 00                	mov    (%eax),%al
  80077f:	0f be c0             	movsbl %al,%eax
  800782:	83 ec 08             	sub    $0x8,%esp
  800785:	ff 75 0c             	pushl  0xc(%ebp)
  800788:	50                   	push   %eax
  800789:	8b 45 08             	mov    0x8(%ebp),%eax
  80078c:	ff d0                	call   *%eax
  80078e:	83 c4 10             	add    $0x10,%esp
}
  800791:	90                   	nop
  800792:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800795:	c9                   	leave  
  800796:	c3                   	ret    

00800797 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  800797:	55                   	push   %ebp
  800798:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  80079a:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  80079e:	7e 1c                	jle    8007bc <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  8007a0:	8b 45 08             	mov    0x8(%ebp),%eax
  8007a3:	8b 00                	mov    (%eax),%eax
  8007a5:	8d 50 08             	lea    0x8(%eax),%edx
  8007a8:	8b 45 08             	mov    0x8(%ebp),%eax
  8007ab:	89 10                	mov    %edx,(%eax)
  8007ad:	8b 45 08             	mov    0x8(%ebp),%eax
  8007b0:	8b 00                	mov    (%eax),%eax
  8007b2:	83 e8 08             	sub    $0x8,%eax
  8007b5:	8b 50 04             	mov    0x4(%eax),%edx
  8007b8:	8b 00                	mov    (%eax),%eax
  8007ba:	eb 40                	jmp    8007fc <getuint+0x65>
	else if (lflag)
  8007bc:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8007c0:	74 1e                	je     8007e0 <getuint+0x49>
		return va_arg(*ap, unsigned long);
  8007c2:	8b 45 08             	mov    0x8(%ebp),%eax
  8007c5:	8b 00                	mov    (%eax),%eax
  8007c7:	8d 50 04             	lea    0x4(%eax),%edx
  8007ca:	8b 45 08             	mov    0x8(%ebp),%eax
  8007cd:	89 10                	mov    %edx,(%eax)
  8007cf:	8b 45 08             	mov    0x8(%ebp),%eax
  8007d2:	8b 00                	mov    (%eax),%eax
  8007d4:	83 e8 04             	sub    $0x4,%eax
  8007d7:	8b 00                	mov    (%eax),%eax
  8007d9:	ba 00 00 00 00       	mov    $0x0,%edx
  8007de:	eb 1c                	jmp    8007fc <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  8007e0:	8b 45 08             	mov    0x8(%ebp),%eax
  8007e3:	8b 00                	mov    (%eax),%eax
  8007e5:	8d 50 04             	lea    0x4(%eax),%edx
  8007e8:	8b 45 08             	mov    0x8(%ebp),%eax
  8007eb:	89 10                	mov    %edx,(%eax)
  8007ed:	8b 45 08             	mov    0x8(%ebp),%eax
  8007f0:	8b 00                	mov    (%eax),%eax
  8007f2:	83 e8 04             	sub    $0x4,%eax
  8007f5:	8b 00                	mov    (%eax),%eax
  8007f7:	ba 00 00 00 00       	mov    $0x0,%edx
}
  8007fc:	5d                   	pop    %ebp
  8007fd:	c3                   	ret    

008007fe <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  8007fe:	55                   	push   %ebp
  8007ff:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800801:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800805:	7e 1c                	jle    800823 <getint+0x25>
		return va_arg(*ap, long long);
  800807:	8b 45 08             	mov    0x8(%ebp),%eax
  80080a:	8b 00                	mov    (%eax),%eax
  80080c:	8d 50 08             	lea    0x8(%eax),%edx
  80080f:	8b 45 08             	mov    0x8(%ebp),%eax
  800812:	89 10                	mov    %edx,(%eax)
  800814:	8b 45 08             	mov    0x8(%ebp),%eax
  800817:	8b 00                	mov    (%eax),%eax
  800819:	83 e8 08             	sub    $0x8,%eax
  80081c:	8b 50 04             	mov    0x4(%eax),%edx
  80081f:	8b 00                	mov    (%eax),%eax
  800821:	eb 38                	jmp    80085b <getint+0x5d>
	else if (lflag)
  800823:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800827:	74 1a                	je     800843 <getint+0x45>
		return va_arg(*ap, long);
  800829:	8b 45 08             	mov    0x8(%ebp),%eax
  80082c:	8b 00                	mov    (%eax),%eax
  80082e:	8d 50 04             	lea    0x4(%eax),%edx
  800831:	8b 45 08             	mov    0x8(%ebp),%eax
  800834:	89 10                	mov    %edx,(%eax)
  800836:	8b 45 08             	mov    0x8(%ebp),%eax
  800839:	8b 00                	mov    (%eax),%eax
  80083b:	83 e8 04             	sub    $0x4,%eax
  80083e:	8b 00                	mov    (%eax),%eax
  800840:	99                   	cltd   
  800841:	eb 18                	jmp    80085b <getint+0x5d>
	else
		return va_arg(*ap, int);
  800843:	8b 45 08             	mov    0x8(%ebp),%eax
  800846:	8b 00                	mov    (%eax),%eax
  800848:	8d 50 04             	lea    0x4(%eax),%edx
  80084b:	8b 45 08             	mov    0x8(%ebp),%eax
  80084e:	89 10                	mov    %edx,(%eax)
  800850:	8b 45 08             	mov    0x8(%ebp),%eax
  800853:	8b 00                	mov    (%eax),%eax
  800855:	83 e8 04             	sub    $0x4,%eax
  800858:	8b 00                	mov    (%eax),%eax
  80085a:	99                   	cltd   
}
  80085b:	5d                   	pop    %ebp
  80085c:	c3                   	ret    

0080085d <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  80085d:	55                   	push   %ebp
  80085e:	89 e5                	mov    %esp,%ebp
  800860:	56                   	push   %esi
  800861:	53                   	push   %ebx
  800862:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800865:	eb 17                	jmp    80087e <vprintfmt+0x21>
			if (ch == '\0')
  800867:	85 db                	test   %ebx,%ebx
  800869:	0f 84 af 03 00 00    	je     800c1e <vprintfmt+0x3c1>
				return;
			putch(ch, putdat);
  80086f:	83 ec 08             	sub    $0x8,%esp
  800872:	ff 75 0c             	pushl  0xc(%ebp)
  800875:	53                   	push   %ebx
  800876:	8b 45 08             	mov    0x8(%ebp),%eax
  800879:	ff d0                	call   *%eax
  80087b:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  80087e:	8b 45 10             	mov    0x10(%ebp),%eax
  800881:	8d 50 01             	lea    0x1(%eax),%edx
  800884:	89 55 10             	mov    %edx,0x10(%ebp)
  800887:	8a 00                	mov    (%eax),%al
  800889:	0f b6 d8             	movzbl %al,%ebx
  80088c:	83 fb 25             	cmp    $0x25,%ebx
  80088f:	75 d6                	jne    800867 <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  800891:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  800895:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  80089c:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  8008a3:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  8008aa:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8008b1:	8b 45 10             	mov    0x10(%ebp),%eax
  8008b4:	8d 50 01             	lea    0x1(%eax),%edx
  8008b7:	89 55 10             	mov    %edx,0x10(%ebp)
  8008ba:	8a 00                	mov    (%eax),%al
  8008bc:	0f b6 d8             	movzbl %al,%ebx
  8008bf:	8d 43 dd             	lea    -0x23(%ebx),%eax
  8008c2:	83 f8 55             	cmp    $0x55,%eax
  8008c5:	0f 87 2b 03 00 00    	ja     800bf6 <vprintfmt+0x399>
  8008cb:	8b 04 85 78 37 80 00 	mov    0x803778(,%eax,4),%eax
  8008d2:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  8008d4:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  8008d8:	eb d7                	jmp    8008b1 <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  8008da:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  8008de:	eb d1                	jmp    8008b1 <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8008e0:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  8008e7:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8008ea:	89 d0                	mov    %edx,%eax
  8008ec:	c1 e0 02             	shl    $0x2,%eax
  8008ef:	01 d0                	add    %edx,%eax
  8008f1:	01 c0                	add    %eax,%eax
  8008f3:	01 d8                	add    %ebx,%eax
  8008f5:	83 e8 30             	sub    $0x30,%eax
  8008f8:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  8008fb:	8b 45 10             	mov    0x10(%ebp),%eax
  8008fe:	8a 00                	mov    (%eax),%al
  800900:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  800903:	83 fb 2f             	cmp    $0x2f,%ebx
  800906:	7e 3e                	jle    800946 <vprintfmt+0xe9>
  800908:	83 fb 39             	cmp    $0x39,%ebx
  80090b:	7f 39                	jg     800946 <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  80090d:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800910:	eb d5                	jmp    8008e7 <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  800912:	8b 45 14             	mov    0x14(%ebp),%eax
  800915:	83 c0 04             	add    $0x4,%eax
  800918:	89 45 14             	mov    %eax,0x14(%ebp)
  80091b:	8b 45 14             	mov    0x14(%ebp),%eax
  80091e:	83 e8 04             	sub    $0x4,%eax
  800921:	8b 00                	mov    (%eax),%eax
  800923:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  800926:	eb 1f                	jmp    800947 <vprintfmt+0xea>

		case '.':
			if (width < 0)
  800928:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80092c:	79 83                	jns    8008b1 <vprintfmt+0x54>
				width = 0;
  80092e:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  800935:	e9 77 ff ff ff       	jmp    8008b1 <vprintfmt+0x54>

		case '#':
			altflag = 1;
  80093a:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  800941:	e9 6b ff ff ff       	jmp    8008b1 <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  800946:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  800947:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80094b:	0f 89 60 ff ff ff    	jns    8008b1 <vprintfmt+0x54>
				width = precision, precision = -1;
  800951:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800954:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800957:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  80095e:	e9 4e ff ff ff       	jmp    8008b1 <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  800963:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  800966:	e9 46 ff ff ff       	jmp    8008b1 <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  80096b:	8b 45 14             	mov    0x14(%ebp),%eax
  80096e:	83 c0 04             	add    $0x4,%eax
  800971:	89 45 14             	mov    %eax,0x14(%ebp)
  800974:	8b 45 14             	mov    0x14(%ebp),%eax
  800977:	83 e8 04             	sub    $0x4,%eax
  80097a:	8b 00                	mov    (%eax),%eax
  80097c:	83 ec 08             	sub    $0x8,%esp
  80097f:	ff 75 0c             	pushl  0xc(%ebp)
  800982:	50                   	push   %eax
  800983:	8b 45 08             	mov    0x8(%ebp),%eax
  800986:	ff d0                	call   *%eax
  800988:	83 c4 10             	add    $0x10,%esp
			break;
  80098b:	e9 89 02 00 00       	jmp    800c19 <vprintfmt+0x3bc>

		// error message
		case 'e':
			err = va_arg(ap, int);
  800990:	8b 45 14             	mov    0x14(%ebp),%eax
  800993:	83 c0 04             	add    $0x4,%eax
  800996:	89 45 14             	mov    %eax,0x14(%ebp)
  800999:	8b 45 14             	mov    0x14(%ebp),%eax
  80099c:	83 e8 04             	sub    $0x4,%eax
  80099f:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  8009a1:	85 db                	test   %ebx,%ebx
  8009a3:	79 02                	jns    8009a7 <vprintfmt+0x14a>
				err = -err;
  8009a5:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  8009a7:	83 fb 64             	cmp    $0x64,%ebx
  8009aa:	7f 0b                	jg     8009b7 <vprintfmt+0x15a>
  8009ac:	8b 34 9d c0 35 80 00 	mov    0x8035c0(,%ebx,4),%esi
  8009b3:	85 f6                	test   %esi,%esi
  8009b5:	75 19                	jne    8009d0 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  8009b7:	53                   	push   %ebx
  8009b8:	68 65 37 80 00       	push   $0x803765
  8009bd:	ff 75 0c             	pushl  0xc(%ebp)
  8009c0:	ff 75 08             	pushl  0x8(%ebp)
  8009c3:	e8 5e 02 00 00       	call   800c26 <printfmt>
  8009c8:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  8009cb:	e9 49 02 00 00       	jmp    800c19 <vprintfmt+0x3bc>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  8009d0:	56                   	push   %esi
  8009d1:	68 6e 37 80 00       	push   $0x80376e
  8009d6:	ff 75 0c             	pushl  0xc(%ebp)
  8009d9:	ff 75 08             	pushl  0x8(%ebp)
  8009dc:	e8 45 02 00 00       	call   800c26 <printfmt>
  8009e1:	83 c4 10             	add    $0x10,%esp
			break;
  8009e4:	e9 30 02 00 00       	jmp    800c19 <vprintfmt+0x3bc>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  8009e9:	8b 45 14             	mov    0x14(%ebp),%eax
  8009ec:	83 c0 04             	add    $0x4,%eax
  8009ef:	89 45 14             	mov    %eax,0x14(%ebp)
  8009f2:	8b 45 14             	mov    0x14(%ebp),%eax
  8009f5:	83 e8 04             	sub    $0x4,%eax
  8009f8:	8b 30                	mov    (%eax),%esi
  8009fa:	85 f6                	test   %esi,%esi
  8009fc:	75 05                	jne    800a03 <vprintfmt+0x1a6>
				p = "(null)";
  8009fe:	be 71 37 80 00       	mov    $0x803771,%esi
			if (width > 0 && padc != '-')
  800a03:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800a07:	7e 6d                	jle    800a76 <vprintfmt+0x219>
  800a09:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  800a0d:	74 67                	je     800a76 <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  800a0f:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800a12:	83 ec 08             	sub    $0x8,%esp
  800a15:	50                   	push   %eax
  800a16:	56                   	push   %esi
  800a17:	e8 0c 03 00 00       	call   800d28 <strnlen>
  800a1c:	83 c4 10             	add    $0x10,%esp
  800a1f:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  800a22:	eb 16                	jmp    800a3a <vprintfmt+0x1dd>
					putch(padc, putdat);
  800a24:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  800a28:	83 ec 08             	sub    $0x8,%esp
  800a2b:	ff 75 0c             	pushl  0xc(%ebp)
  800a2e:	50                   	push   %eax
  800a2f:	8b 45 08             	mov    0x8(%ebp),%eax
  800a32:	ff d0                	call   *%eax
  800a34:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800a37:	ff 4d e4             	decl   -0x1c(%ebp)
  800a3a:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800a3e:	7f e4                	jg     800a24 <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800a40:	eb 34                	jmp    800a76 <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  800a42:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800a46:	74 1c                	je     800a64 <vprintfmt+0x207>
  800a48:	83 fb 1f             	cmp    $0x1f,%ebx
  800a4b:	7e 05                	jle    800a52 <vprintfmt+0x1f5>
  800a4d:	83 fb 7e             	cmp    $0x7e,%ebx
  800a50:	7e 12                	jle    800a64 <vprintfmt+0x207>
					putch('?', putdat);
  800a52:	83 ec 08             	sub    $0x8,%esp
  800a55:	ff 75 0c             	pushl  0xc(%ebp)
  800a58:	6a 3f                	push   $0x3f
  800a5a:	8b 45 08             	mov    0x8(%ebp),%eax
  800a5d:	ff d0                	call   *%eax
  800a5f:	83 c4 10             	add    $0x10,%esp
  800a62:	eb 0f                	jmp    800a73 <vprintfmt+0x216>
				else
					putch(ch, putdat);
  800a64:	83 ec 08             	sub    $0x8,%esp
  800a67:	ff 75 0c             	pushl  0xc(%ebp)
  800a6a:	53                   	push   %ebx
  800a6b:	8b 45 08             	mov    0x8(%ebp),%eax
  800a6e:	ff d0                	call   *%eax
  800a70:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800a73:	ff 4d e4             	decl   -0x1c(%ebp)
  800a76:	89 f0                	mov    %esi,%eax
  800a78:	8d 70 01             	lea    0x1(%eax),%esi
  800a7b:	8a 00                	mov    (%eax),%al
  800a7d:	0f be d8             	movsbl %al,%ebx
  800a80:	85 db                	test   %ebx,%ebx
  800a82:	74 24                	je     800aa8 <vprintfmt+0x24b>
  800a84:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800a88:	78 b8                	js     800a42 <vprintfmt+0x1e5>
  800a8a:	ff 4d e0             	decl   -0x20(%ebp)
  800a8d:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800a91:	79 af                	jns    800a42 <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800a93:	eb 13                	jmp    800aa8 <vprintfmt+0x24b>
				putch(' ', putdat);
  800a95:	83 ec 08             	sub    $0x8,%esp
  800a98:	ff 75 0c             	pushl  0xc(%ebp)
  800a9b:	6a 20                	push   $0x20
  800a9d:	8b 45 08             	mov    0x8(%ebp),%eax
  800aa0:	ff d0                	call   *%eax
  800aa2:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800aa5:	ff 4d e4             	decl   -0x1c(%ebp)
  800aa8:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800aac:	7f e7                	jg     800a95 <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  800aae:	e9 66 01 00 00       	jmp    800c19 <vprintfmt+0x3bc>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  800ab3:	83 ec 08             	sub    $0x8,%esp
  800ab6:	ff 75 e8             	pushl  -0x18(%ebp)
  800ab9:	8d 45 14             	lea    0x14(%ebp),%eax
  800abc:	50                   	push   %eax
  800abd:	e8 3c fd ff ff       	call   8007fe <getint>
  800ac2:	83 c4 10             	add    $0x10,%esp
  800ac5:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800ac8:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  800acb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800ace:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800ad1:	85 d2                	test   %edx,%edx
  800ad3:	79 23                	jns    800af8 <vprintfmt+0x29b>
				putch('-', putdat);
  800ad5:	83 ec 08             	sub    $0x8,%esp
  800ad8:	ff 75 0c             	pushl  0xc(%ebp)
  800adb:	6a 2d                	push   $0x2d
  800add:	8b 45 08             	mov    0x8(%ebp),%eax
  800ae0:	ff d0                	call   *%eax
  800ae2:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  800ae5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800ae8:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800aeb:	f7 d8                	neg    %eax
  800aed:	83 d2 00             	adc    $0x0,%edx
  800af0:	f7 da                	neg    %edx
  800af2:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800af5:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  800af8:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800aff:	e9 bc 00 00 00       	jmp    800bc0 <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  800b04:	83 ec 08             	sub    $0x8,%esp
  800b07:	ff 75 e8             	pushl  -0x18(%ebp)
  800b0a:	8d 45 14             	lea    0x14(%ebp),%eax
  800b0d:	50                   	push   %eax
  800b0e:	e8 84 fc ff ff       	call   800797 <getuint>
  800b13:	83 c4 10             	add    $0x10,%esp
  800b16:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800b19:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  800b1c:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800b23:	e9 98 00 00 00       	jmp    800bc0 <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  800b28:	83 ec 08             	sub    $0x8,%esp
  800b2b:	ff 75 0c             	pushl  0xc(%ebp)
  800b2e:	6a 58                	push   $0x58
  800b30:	8b 45 08             	mov    0x8(%ebp),%eax
  800b33:	ff d0                	call   *%eax
  800b35:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800b38:	83 ec 08             	sub    $0x8,%esp
  800b3b:	ff 75 0c             	pushl  0xc(%ebp)
  800b3e:	6a 58                	push   $0x58
  800b40:	8b 45 08             	mov    0x8(%ebp),%eax
  800b43:	ff d0                	call   *%eax
  800b45:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800b48:	83 ec 08             	sub    $0x8,%esp
  800b4b:	ff 75 0c             	pushl  0xc(%ebp)
  800b4e:	6a 58                	push   $0x58
  800b50:	8b 45 08             	mov    0x8(%ebp),%eax
  800b53:	ff d0                	call   *%eax
  800b55:	83 c4 10             	add    $0x10,%esp
			break;
  800b58:	e9 bc 00 00 00       	jmp    800c19 <vprintfmt+0x3bc>

		// pointer
		case 'p':
			putch('0', putdat);
  800b5d:	83 ec 08             	sub    $0x8,%esp
  800b60:	ff 75 0c             	pushl  0xc(%ebp)
  800b63:	6a 30                	push   $0x30
  800b65:	8b 45 08             	mov    0x8(%ebp),%eax
  800b68:	ff d0                	call   *%eax
  800b6a:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  800b6d:	83 ec 08             	sub    $0x8,%esp
  800b70:	ff 75 0c             	pushl  0xc(%ebp)
  800b73:	6a 78                	push   $0x78
  800b75:	8b 45 08             	mov    0x8(%ebp),%eax
  800b78:	ff d0                	call   *%eax
  800b7a:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  800b7d:	8b 45 14             	mov    0x14(%ebp),%eax
  800b80:	83 c0 04             	add    $0x4,%eax
  800b83:	89 45 14             	mov    %eax,0x14(%ebp)
  800b86:	8b 45 14             	mov    0x14(%ebp),%eax
  800b89:	83 e8 04             	sub    $0x4,%eax
  800b8c:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800b8e:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800b91:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  800b98:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  800b9f:	eb 1f                	jmp    800bc0 <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800ba1:	83 ec 08             	sub    $0x8,%esp
  800ba4:	ff 75 e8             	pushl  -0x18(%ebp)
  800ba7:	8d 45 14             	lea    0x14(%ebp),%eax
  800baa:	50                   	push   %eax
  800bab:	e8 e7 fb ff ff       	call   800797 <getuint>
  800bb0:	83 c4 10             	add    $0x10,%esp
  800bb3:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800bb6:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  800bb9:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800bc0:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  800bc4:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800bc7:	83 ec 04             	sub    $0x4,%esp
  800bca:	52                   	push   %edx
  800bcb:	ff 75 e4             	pushl  -0x1c(%ebp)
  800bce:	50                   	push   %eax
  800bcf:	ff 75 f4             	pushl  -0xc(%ebp)
  800bd2:	ff 75 f0             	pushl  -0x10(%ebp)
  800bd5:	ff 75 0c             	pushl  0xc(%ebp)
  800bd8:	ff 75 08             	pushl  0x8(%ebp)
  800bdb:	e8 00 fb ff ff       	call   8006e0 <printnum>
  800be0:	83 c4 20             	add    $0x20,%esp
			break;
  800be3:	eb 34                	jmp    800c19 <vprintfmt+0x3bc>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  800be5:	83 ec 08             	sub    $0x8,%esp
  800be8:	ff 75 0c             	pushl  0xc(%ebp)
  800beb:	53                   	push   %ebx
  800bec:	8b 45 08             	mov    0x8(%ebp),%eax
  800bef:	ff d0                	call   *%eax
  800bf1:	83 c4 10             	add    $0x10,%esp
			break;
  800bf4:	eb 23                	jmp    800c19 <vprintfmt+0x3bc>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800bf6:	83 ec 08             	sub    $0x8,%esp
  800bf9:	ff 75 0c             	pushl  0xc(%ebp)
  800bfc:	6a 25                	push   $0x25
  800bfe:	8b 45 08             	mov    0x8(%ebp),%eax
  800c01:	ff d0                	call   *%eax
  800c03:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  800c06:	ff 4d 10             	decl   0x10(%ebp)
  800c09:	eb 03                	jmp    800c0e <vprintfmt+0x3b1>
  800c0b:	ff 4d 10             	decl   0x10(%ebp)
  800c0e:	8b 45 10             	mov    0x10(%ebp),%eax
  800c11:	48                   	dec    %eax
  800c12:	8a 00                	mov    (%eax),%al
  800c14:	3c 25                	cmp    $0x25,%al
  800c16:	75 f3                	jne    800c0b <vprintfmt+0x3ae>
				/* do nothing */;
			break;
  800c18:	90                   	nop
		}
	}
  800c19:	e9 47 fc ff ff       	jmp    800865 <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  800c1e:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  800c1f:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800c22:	5b                   	pop    %ebx
  800c23:	5e                   	pop    %esi
  800c24:	5d                   	pop    %ebp
  800c25:	c3                   	ret    

00800c26 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800c26:	55                   	push   %ebp
  800c27:	89 e5                	mov    %esp,%ebp
  800c29:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  800c2c:	8d 45 10             	lea    0x10(%ebp),%eax
  800c2f:	83 c0 04             	add    $0x4,%eax
  800c32:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  800c35:	8b 45 10             	mov    0x10(%ebp),%eax
  800c38:	ff 75 f4             	pushl  -0xc(%ebp)
  800c3b:	50                   	push   %eax
  800c3c:	ff 75 0c             	pushl  0xc(%ebp)
  800c3f:	ff 75 08             	pushl  0x8(%ebp)
  800c42:	e8 16 fc ff ff       	call   80085d <vprintfmt>
  800c47:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  800c4a:	90                   	nop
  800c4b:	c9                   	leave  
  800c4c:	c3                   	ret    

00800c4d <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800c4d:	55                   	push   %ebp
  800c4e:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  800c50:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c53:	8b 40 08             	mov    0x8(%eax),%eax
  800c56:	8d 50 01             	lea    0x1(%eax),%edx
  800c59:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c5c:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  800c5f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c62:	8b 10                	mov    (%eax),%edx
  800c64:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c67:	8b 40 04             	mov    0x4(%eax),%eax
  800c6a:	39 c2                	cmp    %eax,%edx
  800c6c:	73 12                	jae    800c80 <sprintputch+0x33>
		*b->buf++ = ch;
  800c6e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c71:	8b 00                	mov    (%eax),%eax
  800c73:	8d 48 01             	lea    0x1(%eax),%ecx
  800c76:	8b 55 0c             	mov    0xc(%ebp),%edx
  800c79:	89 0a                	mov    %ecx,(%edx)
  800c7b:	8b 55 08             	mov    0x8(%ebp),%edx
  800c7e:	88 10                	mov    %dl,(%eax)
}
  800c80:	90                   	nop
  800c81:	5d                   	pop    %ebp
  800c82:	c3                   	ret    

00800c83 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800c83:	55                   	push   %ebp
  800c84:	89 e5                	mov    %esp,%ebp
  800c86:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  800c89:	8b 45 08             	mov    0x8(%ebp),%eax
  800c8c:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800c8f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c92:	8d 50 ff             	lea    -0x1(%eax),%edx
  800c95:	8b 45 08             	mov    0x8(%ebp),%eax
  800c98:	01 d0                	add    %edx,%eax
  800c9a:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800c9d:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800ca4:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800ca8:	74 06                	je     800cb0 <vsnprintf+0x2d>
  800caa:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800cae:	7f 07                	jg     800cb7 <vsnprintf+0x34>
		return -E_INVAL;
  800cb0:	b8 03 00 00 00       	mov    $0x3,%eax
  800cb5:	eb 20                	jmp    800cd7 <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800cb7:	ff 75 14             	pushl  0x14(%ebp)
  800cba:	ff 75 10             	pushl  0x10(%ebp)
  800cbd:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800cc0:	50                   	push   %eax
  800cc1:	68 4d 0c 80 00       	push   $0x800c4d
  800cc6:	e8 92 fb ff ff       	call   80085d <vprintfmt>
  800ccb:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  800cce:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800cd1:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800cd4:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  800cd7:	c9                   	leave  
  800cd8:	c3                   	ret    

00800cd9 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800cd9:	55                   	push   %ebp
  800cda:	89 e5                	mov    %esp,%ebp
  800cdc:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800cdf:	8d 45 10             	lea    0x10(%ebp),%eax
  800ce2:	83 c0 04             	add    $0x4,%eax
  800ce5:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  800ce8:	8b 45 10             	mov    0x10(%ebp),%eax
  800ceb:	ff 75 f4             	pushl  -0xc(%ebp)
  800cee:	50                   	push   %eax
  800cef:	ff 75 0c             	pushl  0xc(%ebp)
  800cf2:	ff 75 08             	pushl  0x8(%ebp)
  800cf5:	e8 89 ff ff ff       	call   800c83 <vsnprintf>
  800cfa:	83 c4 10             	add    $0x10,%esp
  800cfd:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  800d00:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800d03:	c9                   	leave  
  800d04:	c3                   	ret    

00800d05 <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  800d05:	55                   	push   %ebp
  800d06:	89 e5                	mov    %esp,%ebp
  800d08:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  800d0b:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800d12:	eb 06                	jmp    800d1a <strlen+0x15>
		n++;
  800d14:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800d17:	ff 45 08             	incl   0x8(%ebp)
  800d1a:	8b 45 08             	mov    0x8(%ebp),%eax
  800d1d:	8a 00                	mov    (%eax),%al
  800d1f:	84 c0                	test   %al,%al
  800d21:	75 f1                	jne    800d14 <strlen+0xf>
		n++;
	return n;
  800d23:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800d26:	c9                   	leave  
  800d27:	c3                   	ret    

00800d28 <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  800d28:	55                   	push   %ebp
  800d29:	89 e5                	mov    %esp,%ebp
  800d2b:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800d2e:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800d35:	eb 09                	jmp    800d40 <strnlen+0x18>
		n++;
  800d37:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800d3a:	ff 45 08             	incl   0x8(%ebp)
  800d3d:	ff 4d 0c             	decl   0xc(%ebp)
  800d40:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800d44:	74 09                	je     800d4f <strnlen+0x27>
  800d46:	8b 45 08             	mov    0x8(%ebp),%eax
  800d49:	8a 00                	mov    (%eax),%al
  800d4b:	84 c0                	test   %al,%al
  800d4d:	75 e8                	jne    800d37 <strnlen+0xf>
		n++;
	return n;
  800d4f:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800d52:	c9                   	leave  
  800d53:	c3                   	ret    

00800d54 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800d54:	55                   	push   %ebp
  800d55:	89 e5                	mov    %esp,%ebp
  800d57:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  800d5a:	8b 45 08             	mov    0x8(%ebp),%eax
  800d5d:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  800d60:	90                   	nop
  800d61:	8b 45 08             	mov    0x8(%ebp),%eax
  800d64:	8d 50 01             	lea    0x1(%eax),%edx
  800d67:	89 55 08             	mov    %edx,0x8(%ebp)
  800d6a:	8b 55 0c             	mov    0xc(%ebp),%edx
  800d6d:	8d 4a 01             	lea    0x1(%edx),%ecx
  800d70:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800d73:	8a 12                	mov    (%edx),%dl
  800d75:	88 10                	mov    %dl,(%eax)
  800d77:	8a 00                	mov    (%eax),%al
  800d79:	84 c0                	test   %al,%al
  800d7b:	75 e4                	jne    800d61 <strcpy+0xd>
		/* do nothing */;
	return ret;
  800d7d:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800d80:	c9                   	leave  
  800d81:	c3                   	ret    

00800d82 <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  800d82:	55                   	push   %ebp
  800d83:	89 e5                	mov    %esp,%ebp
  800d85:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  800d88:	8b 45 08             	mov    0x8(%ebp),%eax
  800d8b:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  800d8e:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800d95:	eb 1f                	jmp    800db6 <strncpy+0x34>
		*dst++ = *src;
  800d97:	8b 45 08             	mov    0x8(%ebp),%eax
  800d9a:	8d 50 01             	lea    0x1(%eax),%edx
  800d9d:	89 55 08             	mov    %edx,0x8(%ebp)
  800da0:	8b 55 0c             	mov    0xc(%ebp),%edx
  800da3:	8a 12                	mov    (%edx),%dl
  800da5:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  800da7:	8b 45 0c             	mov    0xc(%ebp),%eax
  800daa:	8a 00                	mov    (%eax),%al
  800dac:	84 c0                	test   %al,%al
  800dae:	74 03                	je     800db3 <strncpy+0x31>
			src++;
  800db0:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800db3:	ff 45 fc             	incl   -0x4(%ebp)
  800db6:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800db9:	3b 45 10             	cmp    0x10(%ebp),%eax
  800dbc:	72 d9                	jb     800d97 <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  800dbe:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  800dc1:	c9                   	leave  
  800dc2:	c3                   	ret    

00800dc3 <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  800dc3:	55                   	push   %ebp
  800dc4:	89 e5                	mov    %esp,%ebp
  800dc6:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  800dc9:	8b 45 08             	mov    0x8(%ebp),%eax
  800dcc:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  800dcf:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800dd3:	74 30                	je     800e05 <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  800dd5:	eb 16                	jmp    800ded <strlcpy+0x2a>
			*dst++ = *src++;
  800dd7:	8b 45 08             	mov    0x8(%ebp),%eax
  800dda:	8d 50 01             	lea    0x1(%eax),%edx
  800ddd:	89 55 08             	mov    %edx,0x8(%ebp)
  800de0:	8b 55 0c             	mov    0xc(%ebp),%edx
  800de3:	8d 4a 01             	lea    0x1(%edx),%ecx
  800de6:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800de9:	8a 12                	mov    (%edx),%dl
  800deb:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800ded:	ff 4d 10             	decl   0x10(%ebp)
  800df0:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800df4:	74 09                	je     800dff <strlcpy+0x3c>
  800df6:	8b 45 0c             	mov    0xc(%ebp),%eax
  800df9:	8a 00                	mov    (%eax),%al
  800dfb:	84 c0                	test   %al,%al
  800dfd:	75 d8                	jne    800dd7 <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  800dff:	8b 45 08             	mov    0x8(%ebp),%eax
  800e02:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800e05:	8b 55 08             	mov    0x8(%ebp),%edx
  800e08:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800e0b:	29 c2                	sub    %eax,%edx
  800e0d:	89 d0                	mov    %edx,%eax
}
  800e0f:	c9                   	leave  
  800e10:	c3                   	ret    

00800e11 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800e11:	55                   	push   %ebp
  800e12:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  800e14:	eb 06                	jmp    800e1c <strcmp+0xb>
		p++, q++;
  800e16:	ff 45 08             	incl   0x8(%ebp)
  800e19:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  800e1c:	8b 45 08             	mov    0x8(%ebp),%eax
  800e1f:	8a 00                	mov    (%eax),%al
  800e21:	84 c0                	test   %al,%al
  800e23:	74 0e                	je     800e33 <strcmp+0x22>
  800e25:	8b 45 08             	mov    0x8(%ebp),%eax
  800e28:	8a 10                	mov    (%eax),%dl
  800e2a:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e2d:	8a 00                	mov    (%eax),%al
  800e2f:	38 c2                	cmp    %al,%dl
  800e31:	74 e3                	je     800e16 <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800e33:	8b 45 08             	mov    0x8(%ebp),%eax
  800e36:	8a 00                	mov    (%eax),%al
  800e38:	0f b6 d0             	movzbl %al,%edx
  800e3b:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e3e:	8a 00                	mov    (%eax),%al
  800e40:	0f b6 c0             	movzbl %al,%eax
  800e43:	29 c2                	sub    %eax,%edx
  800e45:	89 d0                	mov    %edx,%eax
}
  800e47:	5d                   	pop    %ebp
  800e48:	c3                   	ret    

00800e49 <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  800e49:	55                   	push   %ebp
  800e4a:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  800e4c:	eb 09                	jmp    800e57 <strncmp+0xe>
		n--, p++, q++;
  800e4e:	ff 4d 10             	decl   0x10(%ebp)
  800e51:	ff 45 08             	incl   0x8(%ebp)
  800e54:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  800e57:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800e5b:	74 17                	je     800e74 <strncmp+0x2b>
  800e5d:	8b 45 08             	mov    0x8(%ebp),%eax
  800e60:	8a 00                	mov    (%eax),%al
  800e62:	84 c0                	test   %al,%al
  800e64:	74 0e                	je     800e74 <strncmp+0x2b>
  800e66:	8b 45 08             	mov    0x8(%ebp),%eax
  800e69:	8a 10                	mov    (%eax),%dl
  800e6b:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e6e:	8a 00                	mov    (%eax),%al
  800e70:	38 c2                	cmp    %al,%dl
  800e72:	74 da                	je     800e4e <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  800e74:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800e78:	75 07                	jne    800e81 <strncmp+0x38>
		return 0;
  800e7a:	b8 00 00 00 00       	mov    $0x0,%eax
  800e7f:	eb 14                	jmp    800e95 <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800e81:	8b 45 08             	mov    0x8(%ebp),%eax
  800e84:	8a 00                	mov    (%eax),%al
  800e86:	0f b6 d0             	movzbl %al,%edx
  800e89:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e8c:	8a 00                	mov    (%eax),%al
  800e8e:	0f b6 c0             	movzbl %al,%eax
  800e91:	29 c2                	sub    %eax,%edx
  800e93:	89 d0                	mov    %edx,%eax
}
  800e95:	5d                   	pop    %ebp
  800e96:	c3                   	ret    

00800e97 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800e97:	55                   	push   %ebp
  800e98:	89 e5                	mov    %esp,%ebp
  800e9a:	83 ec 04             	sub    $0x4,%esp
  800e9d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ea0:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800ea3:	eb 12                	jmp    800eb7 <strchr+0x20>
		if (*s == c)
  800ea5:	8b 45 08             	mov    0x8(%ebp),%eax
  800ea8:	8a 00                	mov    (%eax),%al
  800eaa:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800ead:	75 05                	jne    800eb4 <strchr+0x1d>
			return (char *) s;
  800eaf:	8b 45 08             	mov    0x8(%ebp),%eax
  800eb2:	eb 11                	jmp    800ec5 <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  800eb4:	ff 45 08             	incl   0x8(%ebp)
  800eb7:	8b 45 08             	mov    0x8(%ebp),%eax
  800eba:	8a 00                	mov    (%eax),%al
  800ebc:	84 c0                	test   %al,%al
  800ebe:	75 e5                	jne    800ea5 <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  800ec0:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800ec5:	c9                   	leave  
  800ec6:	c3                   	ret    

00800ec7 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800ec7:	55                   	push   %ebp
  800ec8:	89 e5                	mov    %esp,%ebp
  800eca:	83 ec 04             	sub    $0x4,%esp
  800ecd:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ed0:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800ed3:	eb 0d                	jmp    800ee2 <strfind+0x1b>
		if (*s == c)
  800ed5:	8b 45 08             	mov    0x8(%ebp),%eax
  800ed8:	8a 00                	mov    (%eax),%al
  800eda:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800edd:	74 0e                	je     800eed <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  800edf:	ff 45 08             	incl   0x8(%ebp)
  800ee2:	8b 45 08             	mov    0x8(%ebp),%eax
  800ee5:	8a 00                	mov    (%eax),%al
  800ee7:	84 c0                	test   %al,%al
  800ee9:	75 ea                	jne    800ed5 <strfind+0xe>
  800eeb:	eb 01                	jmp    800eee <strfind+0x27>
		if (*s == c)
			break;
  800eed:	90                   	nop
	return (char *) s;
  800eee:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800ef1:	c9                   	leave  
  800ef2:	c3                   	ret    

00800ef3 <memset>:


void *
memset(void *v, int c, uint32 n)
{
  800ef3:	55                   	push   %ebp
  800ef4:	89 e5                	mov    %esp,%ebp
  800ef6:	83 ec 10             	sub    $0x10,%esp
	char *p;
	int m;

	p = v;
  800ef9:	8b 45 08             	mov    0x8(%ebp),%eax
  800efc:	89 45 fc             	mov    %eax,-0x4(%ebp)
	m = n;
  800eff:	8b 45 10             	mov    0x10(%ebp),%eax
  800f02:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (--m >= 0)
  800f05:	eb 0e                	jmp    800f15 <memset+0x22>
		*p++ = c;
  800f07:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800f0a:	8d 50 01             	lea    0x1(%eax),%edx
  800f0d:	89 55 fc             	mov    %edx,-0x4(%ebp)
  800f10:	8b 55 0c             	mov    0xc(%ebp),%edx
  800f13:	88 10                	mov    %dl,(%eax)
	char *p;
	int m;

	p = v;
	m = n;
	while (--m >= 0)
  800f15:	ff 4d f8             	decl   -0x8(%ebp)
  800f18:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  800f1c:	79 e9                	jns    800f07 <memset+0x14>
		*p++ = c;

	return v;
  800f1e:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800f21:	c9                   	leave  
  800f22:	c3                   	ret    

00800f23 <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  800f23:	55                   	push   %ebp
  800f24:	89 e5                	mov    %esp,%ebp
  800f26:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800f29:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f2c:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800f2f:	8b 45 08             	mov    0x8(%ebp),%eax
  800f32:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (n-- > 0)
  800f35:	eb 16                	jmp    800f4d <memcpy+0x2a>
		*d++ = *s++;
  800f37:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800f3a:	8d 50 01             	lea    0x1(%eax),%edx
  800f3d:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800f40:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800f43:	8d 4a 01             	lea    0x1(%edx),%ecx
  800f46:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800f49:	8a 12                	mov    (%edx),%dl
  800f4b:	88 10                	mov    %dl,(%eax)
	const char *s;
	char *d;

	s = src;
	d = dst;
	while (n-- > 0)
  800f4d:	8b 45 10             	mov    0x10(%ebp),%eax
  800f50:	8d 50 ff             	lea    -0x1(%eax),%edx
  800f53:	89 55 10             	mov    %edx,0x10(%ebp)
  800f56:	85 c0                	test   %eax,%eax
  800f58:	75 dd                	jne    800f37 <memcpy+0x14>
		*d++ = *s++;

	return dst;
  800f5a:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800f5d:	c9                   	leave  
  800f5e:	c3                   	ret    

00800f5f <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  800f5f:	55                   	push   %ebp
  800f60:	89 e5                	mov    %esp,%ebp
  800f62:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800f65:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f68:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800f6b:	8b 45 08             	mov    0x8(%ebp),%eax
  800f6e:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  800f71:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800f74:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800f77:	73 50                	jae    800fc9 <memmove+0x6a>
  800f79:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800f7c:	8b 45 10             	mov    0x10(%ebp),%eax
  800f7f:	01 d0                	add    %edx,%eax
  800f81:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800f84:	76 43                	jbe    800fc9 <memmove+0x6a>
		s += n;
  800f86:	8b 45 10             	mov    0x10(%ebp),%eax
  800f89:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  800f8c:	8b 45 10             	mov    0x10(%ebp),%eax
  800f8f:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  800f92:	eb 10                	jmp    800fa4 <memmove+0x45>
			*--d = *--s;
  800f94:	ff 4d f8             	decl   -0x8(%ebp)
  800f97:	ff 4d fc             	decl   -0x4(%ebp)
  800f9a:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800f9d:	8a 10                	mov    (%eax),%dl
  800f9f:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800fa2:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  800fa4:	8b 45 10             	mov    0x10(%ebp),%eax
  800fa7:	8d 50 ff             	lea    -0x1(%eax),%edx
  800faa:	89 55 10             	mov    %edx,0x10(%ebp)
  800fad:	85 c0                	test   %eax,%eax
  800faf:	75 e3                	jne    800f94 <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800fb1:	eb 23                	jmp    800fd6 <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  800fb3:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800fb6:	8d 50 01             	lea    0x1(%eax),%edx
  800fb9:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800fbc:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800fbf:	8d 4a 01             	lea    0x1(%edx),%ecx
  800fc2:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800fc5:	8a 12                	mov    (%edx),%dl
  800fc7:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  800fc9:	8b 45 10             	mov    0x10(%ebp),%eax
  800fcc:	8d 50 ff             	lea    -0x1(%eax),%edx
  800fcf:	89 55 10             	mov    %edx,0x10(%ebp)
  800fd2:	85 c0                	test   %eax,%eax
  800fd4:	75 dd                	jne    800fb3 <memmove+0x54>
			*d++ = *s++;

	return dst;
  800fd6:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800fd9:	c9                   	leave  
  800fda:	c3                   	ret    

00800fdb <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  800fdb:	55                   	push   %ebp
  800fdc:	89 e5                	mov    %esp,%ebp
  800fde:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  800fe1:	8b 45 08             	mov    0x8(%ebp),%eax
  800fe4:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  800fe7:	8b 45 0c             	mov    0xc(%ebp),%eax
  800fea:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  800fed:	eb 2a                	jmp    801019 <memcmp+0x3e>
		if (*s1 != *s2)
  800fef:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800ff2:	8a 10                	mov    (%eax),%dl
  800ff4:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800ff7:	8a 00                	mov    (%eax),%al
  800ff9:	38 c2                	cmp    %al,%dl
  800ffb:	74 16                	je     801013 <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  800ffd:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801000:	8a 00                	mov    (%eax),%al
  801002:	0f b6 d0             	movzbl %al,%edx
  801005:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801008:	8a 00                	mov    (%eax),%al
  80100a:	0f b6 c0             	movzbl %al,%eax
  80100d:	29 c2                	sub    %eax,%edx
  80100f:	89 d0                	mov    %edx,%eax
  801011:	eb 18                	jmp    80102b <memcmp+0x50>
		s1++, s2++;
  801013:	ff 45 fc             	incl   -0x4(%ebp)
  801016:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  801019:	8b 45 10             	mov    0x10(%ebp),%eax
  80101c:	8d 50 ff             	lea    -0x1(%eax),%edx
  80101f:	89 55 10             	mov    %edx,0x10(%ebp)
  801022:	85 c0                	test   %eax,%eax
  801024:	75 c9                	jne    800fef <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  801026:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80102b:	c9                   	leave  
  80102c:	c3                   	ret    

0080102d <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  80102d:	55                   	push   %ebp
  80102e:	89 e5                	mov    %esp,%ebp
  801030:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  801033:	8b 55 08             	mov    0x8(%ebp),%edx
  801036:	8b 45 10             	mov    0x10(%ebp),%eax
  801039:	01 d0                	add    %edx,%eax
  80103b:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  80103e:	eb 15                	jmp    801055 <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  801040:	8b 45 08             	mov    0x8(%ebp),%eax
  801043:	8a 00                	mov    (%eax),%al
  801045:	0f b6 d0             	movzbl %al,%edx
  801048:	8b 45 0c             	mov    0xc(%ebp),%eax
  80104b:	0f b6 c0             	movzbl %al,%eax
  80104e:	39 c2                	cmp    %eax,%edx
  801050:	74 0d                	je     80105f <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  801052:	ff 45 08             	incl   0x8(%ebp)
  801055:	8b 45 08             	mov    0x8(%ebp),%eax
  801058:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  80105b:	72 e3                	jb     801040 <memfind+0x13>
  80105d:	eb 01                	jmp    801060 <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  80105f:	90                   	nop
	return (void *) s;
  801060:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801063:	c9                   	leave  
  801064:	c3                   	ret    

00801065 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  801065:	55                   	push   %ebp
  801066:	89 e5                	mov    %esp,%ebp
  801068:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  80106b:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  801072:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801079:	eb 03                	jmp    80107e <strtol+0x19>
		s++;
  80107b:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  80107e:	8b 45 08             	mov    0x8(%ebp),%eax
  801081:	8a 00                	mov    (%eax),%al
  801083:	3c 20                	cmp    $0x20,%al
  801085:	74 f4                	je     80107b <strtol+0x16>
  801087:	8b 45 08             	mov    0x8(%ebp),%eax
  80108a:	8a 00                	mov    (%eax),%al
  80108c:	3c 09                	cmp    $0x9,%al
  80108e:	74 eb                	je     80107b <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  801090:	8b 45 08             	mov    0x8(%ebp),%eax
  801093:	8a 00                	mov    (%eax),%al
  801095:	3c 2b                	cmp    $0x2b,%al
  801097:	75 05                	jne    80109e <strtol+0x39>
		s++;
  801099:	ff 45 08             	incl   0x8(%ebp)
  80109c:	eb 13                	jmp    8010b1 <strtol+0x4c>
	else if (*s == '-')
  80109e:	8b 45 08             	mov    0x8(%ebp),%eax
  8010a1:	8a 00                	mov    (%eax),%al
  8010a3:	3c 2d                	cmp    $0x2d,%al
  8010a5:	75 0a                	jne    8010b1 <strtol+0x4c>
		s++, neg = 1;
  8010a7:	ff 45 08             	incl   0x8(%ebp)
  8010aa:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  8010b1:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8010b5:	74 06                	je     8010bd <strtol+0x58>
  8010b7:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  8010bb:	75 20                	jne    8010dd <strtol+0x78>
  8010bd:	8b 45 08             	mov    0x8(%ebp),%eax
  8010c0:	8a 00                	mov    (%eax),%al
  8010c2:	3c 30                	cmp    $0x30,%al
  8010c4:	75 17                	jne    8010dd <strtol+0x78>
  8010c6:	8b 45 08             	mov    0x8(%ebp),%eax
  8010c9:	40                   	inc    %eax
  8010ca:	8a 00                	mov    (%eax),%al
  8010cc:	3c 78                	cmp    $0x78,%al
  8010ce:	75 0d                	jne    8010dd <strtol+0x78>
		s += 2, base = 16;
  8010d0:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  8010d4:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  8010db:	eb 28                	jmp    801105 <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  8010dd:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8010e1:	75 15                	jne    8010f8 <strtol+0x93>
  8010e3:	8b 45 08             	mov    0x8(%ebp),%eax
  8010e6:	8a 00                	mov    (%eax),%al
  8010e8:	3c 30                	cmp    $0x30,%al
  8010ea:	75 0c                	jne    8010f8 <strtol+0x93>
		s++, base = 8;
  8010ec:	ff 45 08             	incl   0x8(%ebp)
  8010ef:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  8010f6:	eb 0d                	jmp    801105 <strtol+0xa0>
	else if (base == 0)
  8010f8:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8010fc:	75 07                	jne    801105 <strtol+0xa0>
		base = 10;
  8010fe:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  801105:	8b 45 08             	mov    0x8(%ebp),%eax
  801108:	8a 00                	mov    (%eax),%al
  80110a:	3c 2f                	cmp    $0x2f,%al
  80110c:	7e 19                	jle    801127 <strtol+0xc2>
  80110e:	8b 45 08             	mov    0x8(%ebp),%eax
  801111:	8a 00                	mov    (%eax),%al
  801113:	3c 39                	cmp    $0x39,%al
  801115:	7f 10                	jg     801127 <strtol+0xc2>
			dig = *s - '0';
  801117:	8b 45 08             	mov    0x8(%ebp),%eax
  80111a:	8a 00                	mov    (%eax),%al
  80111c:	0f be c0             	movsbl %al,%eax
  80111f:	83 e8 30             	sub    $0x30,%eax
  801122:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801125:	eb 42                	jmp    801169 <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  801127:	8b 45 08             	mov    0x8(%ebp),%eax
  80112a:	8a 00                	mov    (%eax),%al
  80112c:	3c 60                	cmp    $0x60,%al
  80112e:	7e 19                	jle    801149 <strtol+0xe4>
  801130:	8b 45 08             	mov    0x8(%ebp),%eax
  801133:	8a 00                	mov    (%eax),%al
  801135:	3c 7a                	cmp    $0x7a,%al
  801137:	7f 10                	jg     801149 <strtol+0xe4>
			dig = *s - 'a' + 10;
  801139:	8b 45 08             	mov    0x8(%ebp),%eax
  80113c:	8a 00                	mov    (%eax),%al
  80113e:	0f be c0             	movsbl %al,%eax
  801141:	83 e8 57             	sub    $0x57,%eax
  801144:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801147:	eb 20                	jmp    801169 <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  801149:	8b 45 08             	mov    0x8(%ebp),%eax
  80114c:	8a 00                	mov    (%eax),%al
  80114e:	3c 40                	cmp    $0x40,%al
  801150:	7e 39                	jle    80118b <strtol+0x126>
  801152:	8b 45 08             	mov    0x8(%ebp),%eax
  801155:	8a 00                	mov    (%eax),%al
  801157:	3c 5a                	cmp    $0x5a,%al
  801159:	7f 30                	jg     80118b <strtol+0x126>
			dig = *s - 'A' + 10;
  80115b:	8b 45 08             	mov    0x8(%ebp),%eax
  80115e:	8a 00                	mov    (%eax),%al
  801160:	0f be c0             	movsbl %al,%eax
  801163:	83 e8 37             	sub    $0x37,%eax
  801166:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  801169:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80116c:	3b 45 10             	cmp    0x10(%ebp),%eax
  80116f:	7d 19                	jge    80118a <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  801171:	ff 45 08             	incl   0x8(%ebp)
  801174:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801177:	0f af 45 10          	imul   0x10(%ebp),%eax
  80117b:	89 c2                	mov    %eax,%edx
  80117d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801180:	01 d0                	add    %edx,%eax
  801182:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  801185:	e9 7b ff ff ff       	jmp    801105 <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  80118a:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  80118b:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80118f:	74 08                	je     801199 <strtol+0x134>
		*endptr = (char *) s;
  801191:	8b 45 0c             	mov    0xc(%ebp),%eax
  801194:	8b 55 08             	mov    0x8(%ebp),%edx
  801197:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  801199:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  80119d:	74 07                	je     8011a6 <strtol+0x141>
  80119f:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8011a2:	f7 d8                	neg    %eax
  8011a4:	eb 03                	jmp    8011a9 <strtol+0x144>
  8011a6:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  8011a9:	c9                   	leave  
  8011aa:	c3                   	ret    

008011ab <ltostr>:

void
ltostr(long value, char *str)
{
  8011ab:	55                   	push   %ebp
  8011ac:	89 e5                	mov    %esp,%ebp
  8011ae:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  8011b1:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  8011b8:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  8011bf:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8011c3:	79 13                	jns    8011d8 <ltostr+0x2d>
	{
		neg = 1;
  8011c5:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  8011cc:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011cf:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  8011d2:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  8011d5:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  8011d8:	8b 45 08             	mov    0x8(%ebp),%eax
  8011db:	b9 0a 00 00 00       	mov    $0xa,%ecx
  8011e0:	99                   	cltd   
  8011e1:	f7 f9                	idiv   %ecx
  8011e3:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  8011e6:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8011e9:	8d 50 01             	lea    0x1(%eax),%edx
  8011ec:	89 55 f8             	mov    %edx,-0x8(%ebp)
  8011ef:	89 c2                	mov    %eax,%edx
  8011f1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011f4:	01 d0                	add    %edx,%eax
  8011f6:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8011f9:	83 c2 30             	add    $0x30,%edx
  8011fc:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  8011fe:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801201:	b8 67 66 66 66       	mov    $0x66666667,%eax
  801206:	f7 e9                	imul   %ecx
  801208:	c1 fa 02             	sar    $0x2,%edx
  80120b:	89 c8                	mov    %ecx,%eax
  80120d:	c1 f8 1f             	sar    $0x1f,%eax
  801210:	29 c2                	sub    %eax,%edx
  801212:	89 d0                	mov    %edx,%eax
  801214:	89 45 08             	mov    %eax,0x8(%ebp)
	} while (value % 10 != 0);
  801217:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80121a:	b8 67 66 66 66       	mov    $0x66666667,%eax
  80121f:	f7 e9                	imul   %ecx
  801221:	c1 fa 02             	sar    $0x2,%edx
  801224:	89 c8                	mov    %ecx,%eax
  801226:	c1 f8 1f             	sar    $0x1f,%eax
  801229:	29 c2                	sub    %eax,%edx
  80122b:	89 d0                	mov    %edx,%eax
  80122d:	c1 e0 02             	shl    $0x2,%eax
  801230:	01 d0                	add    %edx,%eax
  801232:	01 c0                	add    %eax,%eax
  801234:	29 c1                	sub    %eax,%ecx
  801236:	89 ca                	mov    %ecx,%edx
  801238:	85 d2                	test   %edx,%edx
  80123a:	75 9c                	jne    8011d8 <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  80123c:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  801243:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801246:	48                   	dec    %eax
  801247:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  80124a:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  80124e:	74 3d                	je     80128d <ltostr+0xe2>
		start = 1 ;
  801250:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  801257:	eb 34                	jmp    80128d <ltostr+0xe2>
	{
		char tmp = str[start] ;
  801259:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80125c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80125f:	01 d0                	add    %edx,%eax
  801261:	8a 00                	mov    (%eax),%al
  801263:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  801266:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801269:	8b 45 0c             	mov    0xc(%ebp),%eax
  80126c:	01 c2                	add    %eax,%edx
  80126e:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  801271:	8b 45 0c             	mov    0xc(%ebp),%eax
  801274:	01 c8                	add    %ecx,%eax
  801276:	8a 00                	mov    (%eax),%al
  801278:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  80127a:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80127d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801280:	01 c2                	add    %eax,%edx
  801282:	8a 45 eb             	mov    -0x15(%ebp),%al
  801285:	88 02                	mov    %al,(%edx)
		start++ ;
  801287:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  80128a:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  80128d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801290:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801293:	7c c4                	jl     801259 <ltostr+0xae>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  801295:	8b 55 f8             	mov    -0x8(%ebp),%edx
  801298:	8b 45 0c             	mov    0xc(%ebp),%eax
  80129b:	01 d0                	add    %edx,%eax
  80129d:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  8012a0:	90                   	nop
  8012a1:	c9                   	leave  
  8012a2:	c3                   	ret    

008012a3 <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  8012a3:	55                   	push   %ebp
  8012a4:	89 e5                	mov    %esp,%ebp
  8012a6:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  8012a9:	ff 75 08             	pushl  0x8(%ebp)
  8012ac:	e8 54 fa ff ff       	call   800d05 <strlen>
  8012b1:	83 c4 04             	add    $0x4,%esp
  8012b4:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  8012b7:	ff 75 0c             	pushl  0xc(%ebp)
  8012ba:	e8 46 fa ff ff       	call   800d05 <strlen>
  8012bf:	83 c4 04             	add    $0x4,%esp
  8012c2:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  8012c5:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  8012cc:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8012d3:	eb 17                	jmp    8012ec <strcconcat+0x49>
		final[s] = str1[s] ;
  8012d5:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8012d8:	8b 45 10             	mov    0x10(%ebp),%eax
  8012db:	01 c2                	add    %eax,%edx
  8012dd:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  8012e0:	8b 45 08             	mov    0x8(%ebp),%eax
  8012e3:	01 c8                	add    %ecx,%eax
  8012e5:	8a 00                	mov    (%eax),%al
  8012e7:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  8012e9:	ff 45 fc             	incl   -0x4(%ebp)
  8012ec:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8012ef:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  8012f2:	7c e1                	jl     8012d5 <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  8012f4:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  8012fb:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  801302:	eb 1f                	jmp    801323 <strcconcat+0x80>
		final[s++] = str2[i] ;
  801304:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801307:	8d 50 01             	lea    0x1(%eax),%edx
  80130a:	89 55 fc             	mov    %edx,-0x4(%ebp)
  80130d:	89 c2                	mov    %eax,%edx
  80130f:	8b 45 10             	mov    0x10(%ebp),%eax
  801312:	01 c2                	add    %eax,%edx
  801314:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  801317:	8b 45 0c             	mov    0xc(%ebp),%eax
  80131a:	01 c8                	add    %ecx,%eax
  80131c:	8a 00                	mov    (%eax),%al
  80131e:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  801320:	ff 45 f8             	incl   -0x8(%ebp)
  801323:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801326:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801329:	7c d9                	jl     801304 <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  80132b:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80132e:	8b 45 10             	mov    0x10(%ebp),%eax
  801331:	01 d0                	add    %edx,%eax
  801333:	c6 00 00             	movb   $0x0,(%eax)
}
  801336:	90                   	nop
  801337:	c9                   	leave  
  801338:	c3                   	ret    

00801339 <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  801339:	55                   	push   %ebp
  80133a:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  80133c:	8b 45 14             	mov    0x14(%ebp),%eax
  80133f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  801345:	8b 45 14             	mov    0x14(%ebp),%eax
  801348:	8b 00                	mov    (%eax),%eax
  80134a:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801351:	8b 45 10             	mov    0x10(%ebp),%eax
  801354:	01 d0                	add    %edx,%eax
  801356:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  80135c:	eb 0c                	jmp    80136a <strsplit+0x31>
			*string++ = 0;
  80135e:	8b 45 08             	mov    0x8(%ebp),%eax
  801361:	8d 50 01             	lea    0x1(%eax),%edx
  801364:	89 55 08             	mov    %edx,0x8(%ebp)
  801367:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  80136a:	8b 45 08             	mov    0x8(%ebp),%eax
  80136d:	8a 00                	mov    (%eax),%al
  80136f:	84 c0                	test   %al,%al
  801371:	74 18                	je     80138b <strsplit+0x52>
  801373:	8b 45 08             	mov    0x8(%ebp),%eax
  801376:	8a 00                	mov    (%eax),%al
  801378:	0f be c0             	movsbl %al,%eax
  80137b:	50                   	push   %eax
  80137c:	ff 75 0c             	pushl  0xc(%ebp)
  80137f:	e8 13 fb ff ff       	call   800e97 <strchr>
  801384:	83 c4 08             	add    $0x8,%esp
  801387:	85 c0                	test   %eax,%eax
  801389:	75 d3                	jne    80135e <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  80138b:	8b 45 08             	mov    0x8(%ebp),%eax
  80138e:	8a 00                	mov    (%eax),%al
  801390:	84 c0                	test   %al,%al
  801392:	74 5a                	je     8013ee <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  801394:	8b 45 14             	mov    0x14(%ebp),%eax
  801397:	8b 00                	mov    (%eax),%eax
  801399:	83 f8 0f             	cmp    $0xf,%eax
  80139c:	75 07                	jne    8013a5 <strsplit+0x6c>
		{
			return 0;
  80139e:	b8 00 00 00 00       	mov    $0x0,%eax
  8013a3:	eb 66                	jmp    80140b <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  8013a5:	8b 45 14             	mov    0x14(%ebp),%eax
  8013a8:	8b 00                	mov    (%eax),%eax
  8013aa:	8d 48 01             	lea    0x1(%eax),%ecx
  8013ad:	8b 55 14             	mov    0x14(%ebp),%edx
  8013b0:	89 0a                	mov    %ecx,(%edx)
  8013b2:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8013b9:	8b 45 10             	mov    0x10(%ebp),%eax
  8013bc:	01 c2                	add    %eax,%edx
  8013be:	8b 45 08             	mov    0x8(%ebp),%eax
  8013c1:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  8013c3:	eb 03                	jmp    8013c8 <strsplit+0x8f>
			string++;
  8013c5:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  8013c8:	8b 45 08             	mov    0x8(%ebp),%eax
  8013cb:	8a 00                	mov    (%eax),%al
  8013cd:	84 c0                	test   %al,%al
  8013cf:	74 8b                	je     80135c <strsplit+0x23>
  8013d1:	8b 45 08             	mov    0x8(%ebp),%eax
  8013d4:	8a 00                	mov    (%eax),%al
  8013d6:	0f be c0             	movsbl %al,%eax
  8013d9:	50                   	push   %eax
  8013da:	ff 75 0c             	pushl  0xc(%ebp)
  8013dd:	e8 b5 fa ff ff       	call   800e97 <strchr>
  8013e2:	83 c4 08             	add    $0x8,%esp
  8013e5:	85 c0                	test   %eax,%eax
  8013e7:	74 dc                	je     8013c5 <strsplit+0x8c>
			string++;
	}
  8013e9:	e9 6e ff ff ff       	jmp    80135c <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  8013ee:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  8013ef:	8b 45 14             	mov    0x14(%ebp),%eax
  8013f2:	8b 00                	mov    (%eax),%eax
  8013f4:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8013fb:	8b 45 10             	mov    0x10(%ebp),%eax
  8013fe:	01 d0                	add    %edx,%eax
  801400:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  801406:	b8 01 00 00 00       	mov    $0x1,%eax
}
  80140b:	c9                   	leave  
  80140c:	c3                   	ret    

0080140d <InitializeUHeap>:
//============================== GIVEN FUNCTIONS ===================================//
//==================================================================================//

int FirstTimeFlag = 1;
void InitializeUHeap()
{
  80140d:	55                   	push   %ebp
  80140e:	89 e5                	mov    %esp,%ebp
  801410:	83 ec 08             	sub    $0x8,%esp
	if(FirstTimeFlag)
  801413:	a1 04 40 80 00       	mov    0x804004,%eax
  801418:	85 c0                	test   %eax,%eax
  80141a:	74 1f                	je     80143b <InitializeUHeap+0x2e>
	{
		initialize_dyn_block_system();
  80141c:	e8 1d 00 00 00       	call   80143e <initialize_dyn_block_system>
		cprintf("DYNAMIC BLOCK SYSTEM IS INITIALIZED\n");
  801421:	83 ec 0c             	sub    $0xc,%esp
  801424:	68 d0 38 80 00       	push   $0x8038d0
  801429:	e8 55 f2 ff ff       	call   800683 <cprintf>
  80142e:	83 c4 10             	add    $0x10,%esp
#if UHP_USE_BUDDY
		initialize_buddy();
		cprintf("BUDDY SYSTEM IS INITIALIZED\n");
#endif
		FirstTimeFlag = 0;
  801431:	c7 05 04 40 80 00 00 	movl   $0x0,0x804004
  801438:	00 00 00 
	}
}
  80143b:	90                   	nop
  80143c:	c9                   	leave  
  80143d:	c3                   	ret    

0080143e <initialize_dyn_block_system>:

//=================================
// [1] INITIALIZE DYNAMIC ALLOCATOR:
//=================================
void initialize_dyn_block_system()
{
  80143e:	55                   	push   %ebp
  80143f:	89 e5                	mov    %esp,%ebp
  801441:	83 ec 28             	sub    $0x28,%esp
	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] initialize_dyn_block_system
	// your code is here, remove the panic and write your code
	//panic("initialize_dyn_block_system() is not implemented yet...!!");

	LIST_INIT(&AllocMemBlocksList);
  801444:	c7 05 40 40 80 00 00 	movl   $0x0,0x804040
  80144b:	00 00 00 
  80144e:	c7 05 44 40 80 00 00 	movl   $0x0,0x804044
  801455:	00 00 00 
  801458:	c7 05 4c 40 80 00 00 	movl   $0x0,0x80404c
  80145f:	00 00 00 
	LIST_INIT(&FreeMemBlocksList);
  801462:	c7 05 38 41 80 00 00 	movl   $0x0,0x804138
  801469:	00 00 00 
  80146c:	c7 05 3c 41 80 00 00 	movl   $0x0,0x80413c
  801473:	00 00 00 
  801476:	c7 05 44 41 80 00 00 	movl   $0x0,0x804144
  80147d:	00 00 00 
	MAX_MEM_BLOCK_CNT = NUM_OF_UHEAP_PAGES;
  801480:	c7 05 20 41 80 00 00 	movl   $0x20000,0x804120
  801487:	00 02 00 
	MemBlockNodes = (void*)USER_DYN_BLKS_ARRAY;
  80148a:	c7 45 f4 00 00 e0 7f 	movl   $0x7fe00000,-0xc(%ebp)
  801491:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801494:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801499:	2d 00 10 00 00       	sub    $0x1000,%eax
  80149e:	a3 50 40 80 00       	mov    %eax,0x804050
	int size_of_block = sizeof(struct MemBlock);
  8014a3:	c7 45 f0 10 00 00 00 	movl   $0x10,-0x10(%ebp)
	int size_all_struct = size_of_block*MAX_MEM_BLOCK_CNT;
  8014aa:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8014ad:	a1 20 41 80 00       	mov    0x804120,%eax
  8014b2:	0f af c2             	imul   %edx,%eax
  8014b5:	89 45 ec             	mov    %eax,-0x14(%ebp)
	size_all_struct = ROUNDUP(size_all_struct, PAGE_SIZE);
  8014b8:	c7 45 e8 00 10 00 00 	movl   $0x1000,-0x18(%ebp)
  8014bf:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8014c2:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8014c5:	01 d0                	add    %edx,%eax
  8014c7:	48                   	dec    %eax
  8014c8:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8014cb:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8014ce:	ba 00 00 00 00       	mov    $0x0,%edx
  8014d3:	f7 75 e8             	divl   -0x18(%ebp)
  8014d6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8014d9:	29 d0                	sub    %edx,%eax
  8014db:	89 45 ec             	mov    %eax,-0x14(%ebp)
	sys_allocate_chunk(USER_DYN_BLKS_ARRAY, size_all_struct,PERM_USER| PERM_WRITEABLE);
  8014de:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8014e1:	c7 45 e0 00 00 e0 7f 	movl   $0x7fe00000,-0x20(%ebp)
  8014e8:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8014eb:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
  8014f1:	81 ea 00 10 00 00    	sub    $0x1000,%edx
  8014f7:	83 ec 04             	sub    $0x4,%esp
  8014fa:	6a 06                	push   $0x6
  8014fc:	50                   	push   %eax
  8014fd:	52                   	push   %edx
  8014fe:	e8 a1 05 00 00       	call   801aa4 <sys_allocate_chunk>
  801503:	83 c4 10             	add    $0x10,%esp
	initialize_MemBlocksList(MAX_MEM_BLOCK_CNT);
  801506:	a1 20 41 80 00       	mov    0x804120,%eax
  80150b:	83 ec 0c             	sub    $0xc,%esp
  80150e:	50                   	push   %eax
  80150f:	e8 16 0c 00 00       	call   80212a <initialize_MemBlocksList>
  801514:	83 c4 10             	add    $0x10,%esp
	struct MemBlock* ourBlock =LIST_LAST(&AvailableMemBlocksList);
  801517:	a1 4c 41 80 00       	mov    0x80414c,%eax
  80151c:	89 45 dc             	mov    %eax,-0x24(%ebp)
	LIST_REMOVE(&AvailableMemBlocksList,ourBlock);
  80151f:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  801523:	75 14                	jne    801539 <initialize_dyn_block_system+0xfb>
  801525:	83 ec 04             	sub    $0x4,%esp
  801528:	68 f5 38 80 00       	push   $0x8038f5
  80152d:	6a 2d                	push   $0x2d
  80152f:	68 13 39 80 00       	push   $0x803913
  801534:	e8 70 1a 00 00       	call   802fa9 <_panic>
  801539:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80153c:	8b 00                	mov    (%eax),%eax
  80153e:	85 c0                	test   %eax,%eax
  801540:	74 10                	je     801552 <initialize_dyn_block_system+0x114>
  801542:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801545:	8b 00                	mov    (%eax),%eax
  801547:	8b 55 dc             	mov    -0x24(%ebp),%edx
  80154a:	8b 52 04             	mov    0x4(%edx),%edx
  80154d:	89 50 04             	mov    %edx,0x4(%eax)
  801550:	eb 0b                	jmp    80155d <initialize_dyn_block_system+0x11f>
  801552:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801555:	8b 40 04             	mov    0x4(%eax),%eax
  801558:	a3 4c 41 80 00       	mov    %eax,0x80414c
  80155d:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801560:	8b 40 04             	mov    0x4(%eax),%eax
  801563:	85 c0                	test   %eax,%eax
  801565:	74 0f                	je     801576 <initialize_dyn_block_system+0x138>
  801567:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80156a:	8b 40 04             	mov    0x4(%eax),%eax
  80156d:	8b 55 dc             	mov    -0x24(%ebp),%edx
  801570:	8b 12                	mov    (%edx),%edx
  801572:	89 10                	mov    %edx,(%eax)
  801574:	eb 0a                	jmp    801580 <initialize_dyn_block_system+0x142>
  801576:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801579:	8b 00                	mov    (%eax),%eax
  80157b:	a3 48 41 80 00       	mov    %eax,0x804148
  801580:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801583:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  801589:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80158c:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  801593:	a1 54 41 80 00       	mov    0x804154,%eax
  801598:	48                   	dec    %eax
  801599:	a3 54 41 80 00       	mov    %eax,0x804154
	ourBlock->size = USER_HEAP_MAX-USER_HEAP_START;
  80159e:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8015a1:	c7 40 0c 00 00 00 20 	movl   $0x20000000,0xc(%eax)
	ourBlock->sva=USER_HEAP_START;
  8015a8:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8015ab:	c7 40 08 00 00 00 80 	movl   $0x80000000,0x8(%eax)
	LIST_INSERT_TAIL(&FreeMemBlocksList, ourBlock);
  8015b2:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  8015b6:	75 14                	jne    8015cc <initialize_dyn_block_system+0x18e>
  8015b8:	83 ec 04             	sub    $0x4,%esp
  8015bb:	68 20 39 80 00       	push   $0x803920
  8015c0:	6a 30                	push   $0x30
  8015c2:	68 13 39 80 00       	push   $0x803913
  8015c7:	e8 dd 19 00 00       	call   802fa9 <_panic>
  8015cc:	8b 15 3c 41 80 00    	mov    0x80413c,%edx
  8015d2:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8015d5:	89 50 04             	mov    %edx,0x4(%eax)
  8015d8:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8015db:	8b 40 04             	mov    0x4(%eax),%eax
  8015de:	85 c0                	test   %eax,%eax
  8015e0:	74 0c                	je     8015ee <initialize_dyn_block_system+0x1b0>
  8015e2:	a1 3c 41 80 00       	mov    0x80413c,%eax
  8015e7:	8b 55 dc             	mov    -0x24(%ebp),%edx
  8015ea:	89 10                	mov    %edx,(%eax)
  8015ec:	eb 08                	jmp    8015f6 <initialize_dyn_block_system+0x1b8>
  8015ee:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8015f1:	a3 38 41 80 00       	mov    %eax,0x804138
  8015f6:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8015f9:	a3 3c 41 80 00       	mov    %eax,0x80413c
  8015fe:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801601:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  801607:	a1 44 41 80 00       	mov    0x804144,%eax
  80160c:	40                   	inc    %eax
  80160d:	a3 44 41 80 00       	mov    %eax,0x804144
	//[1] Initialize two lists (AllocMemBlocksList & FreeMemBlocksList) [Hint: use LIST_INIT()]
	//[2] Dynamically allocate the array of MemBlockNodes at VA USER_DYN_BLKS_ARRAY
	//	  (remember to set MAX_MEM_BLOCK_CNT with the chosen size of the array)
	//[3] Initialize AvailableMemBlocksList by filling it with the MemBlockNodes
	//[4] Insert a new MemBlock with the heap size into the FreeMemBlocksList
}
  801612:	90                   	nop
  801613:	c9                   	leave  
  801614:	c3                   	ret    

00801615 <malloc>:
//=================================
// [2] ALLOCATE SPACE IN USER HEAP:
//=================================

void* malloc(uint32 size)
{
  801615:	55                   	push   %ebp
  801616:	89 e5                	mov    %esp,%ebp
  801618:	83 ec 18             	sub    $0x18,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  80161b:	e8 ed fd ff ff       	call   80140d <InitializeUHeap>
	if (size == 0) return NULL ;
  801620:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801624:	75 07                	jne    80162d <malloc+0x18>
  801626:	b8 00 00 00 00       	mov    $0x0,%eax
  80162b:	eb 67                	jmp    801694 <malloc+0x7f>

	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] malloc
	// your code is here, remove the panic and write your code
	//panic("malloc() is not implemented yet...!!");

	size = ROUNDUP(size, PAGE_SIZE);
  80162d:	c7 45 f4 00 10 00 00 	movl   $0x1000,-0xc(%ebp)
  801634:	8b 55 08             	mov    0x8(%ebp),%edx
  801637:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80163a:	01 d0                	add    %edx,%eax
  80163c:	48                   	dec    %eax
  80163d:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801640:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801643:	ba 00 00 00 00       	mov    $0x0,%edx
  801648:	f7 75 f4             	divl   -0xc(%ebp)
  80164b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80164e:	29 d0                	sub    %edx,%eax
  801650:	89 45 08             	mov    %eax,0x8(%ebp)
	if(sys_isUHeapPlacementStrategyFIRSTFIT())
  801653:	e8 1a 08 00 00       	call   801e72 <sys_isUHeapPlacementStrategyFIRSTFIT>
  801658:	85 c0                	test   %eax,%eax
  80165a:	74 33                	je     80168f <malloc+0x7a>
	{
		struct MemBlock * myBlock = alloc_block_FF(size);
  80165c:	83 ec 0c             	sub    $0xc,%esp
  80165f:	ff 75 08             	pushl  0x8(%ebp)
  801662:	e8 0c 0e 00 00       	call   802473 <alloc_block_FF>
  801667:	83 c4 10             	add    $0x10,%esp
  80166a:	89 45 ec             	mov    %eax,-0x14(%ebp)
		if(myBlock != NULL)
  80166d:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  801671:	74 1c                	je     80168f <malloc+0x7a>
		{
			insert_sorted_allocList(myBlock);
  801673:	83 ec 0c             	sub    $0xc,%esp
  801676:	ff 75 ec             	pushl  -0x14(%ebp)
  801679:	e8 07 0c 00 00       	call   802285 <insert_sorted_allocList>
  80167e:	83 c4 10             	add    $0x10,%esp
			uint32 ptr = myBlock->sva;
  801681:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801684:	8b 40 08             	mov    0x8(%eax),%eax
  801687:	89 45 e8             	mov    %eax,-0x18(%ebp)
			return (void *)ptr;
  80168a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80168d:	eb 05                	jmp    801694 <malloc+0x7f>
		}
	}
	return NULL;
  80168f:	b8 00 00 00 00       	mov    $0x0,%eax
	//		to the required allocation size (space should be on 4 KB BOUNDARY)
	//	2) if no suitable space found, return NULL
	// 	3) Return pointer containing the virtual address of allocated space,
	//
	//Use sys_isUHeapPlacementStrategyFIRSTFIT()... to check the current strategy
}
  801694:	c9                   	leave  
  801695:	c3                   	ret    

00801696 <free>:
//	We can use sys_free_user_mem(uint32 virtual_address, uint32 size); which
//		switches to the kernel mode, calls free_user_mem() in
//		"kern/mem/chunk_operations.c", then switch back to the user mode here
//	the free_user_mem function is empty, make sure to implement it.
void free(void* virtual_address)
{
  801696:	55                   	push   %ebp
  801697:	89 e5                	mov    %esp,%ebp
  801699:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] free
	// your code is here, remove the panic and write your code
	//panic("free() is not implemented yet...!!");

	uint32 virtualAddress = (uint32 )(virtual_address);
  80169c:	8b 45 08             	mov    0x8(%ebp),%eax
  80169f:	89 45 f4             	mov    %eax,-0xc(%ebp)
//	virtualAddress = ROUNDDOWN(virtualAddress, PAGE_SIZE);
	struct MemBlock * myBlock = find_block(&AllocMemBlocksList, virtualAddress);
  8016a2:	83 ec 08             	sub    $0x8,%esp
  8016a5:	ff 75 f4             	pushl  -0xc(%ebp)
  8016a8:	68 40 40 80 00       	push   $0x804040
  8016ad:	e8 5b 0b 00 00       	call   80220d <find_block>
  8016b2:	83 c4 10             	add    $0x10,%esp
  8016b5:	89 45 f0             	mov    %eax,-0x10(%ebp)
//	cprintf ("ptr sva at free user side = %x \n", myBlock->sva);
	sys_free_user_mem(virtualAddress, myBlock->size);
  8016b8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8016bb:	8b 40 0c             	mov    0xc(%eax),%eax
  8016be:	83 ec 08             	sub    $0x8,%esp
  8016c1:	50                   	push   %eax
  8016c2:	ff 75 f4             	pushl  -0xc(%ebp)
  8016c5:	e8 a2 03 00 00       	call   801a6c <sys_free_user_mem>
  8016ca:	83 c4 10             	add    $0x10,%esp
	LIST_REMOVE(&AllocMemBlocksList, myBlock);
  8016cd:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8016d1:	75 14                	jne    8016e7 <free+0x51>
  8016d3:	83 ec 04             	sub    $0x4,%esp
  8016d6:	68 f5 38 80 00       	push   $0x8038f5
  8016db:	6a 76                	push   $0x76
  8016dd:	68 13 39 80 00       	push   $0x803913
  8016e2:	e8 c2 18 00 00       	call   802fa9 <_panic>
  8016e7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8016ea:	8b 00                	mov    (%eax),%eax
  8016ec:	85 c0                	test   %eax,%eax
  8016ee:	74 10                	je     801700 <free+0x6a>
  8016f0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8016f3:	8b 00                	mov    (%eax),%eax
  8016f5:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8016f8:	8b 52 04             	mov    0x4(%edx),%edx
  8016fb:	89 50 04             	mov    %edx,0x4(%eax)
  8016fe:	eb 0b                	jmp    80170b <free+0x75>
  801700:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801703:	8b 40 04             	mov    0x4(%eax),%eax
  801706:	a3 44 40 80 00       	mov    %eax,0x804044
  80170b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80170e:	8b 40 04             	mov    0x4(%eax),%eax
  801711:	85 c0                	test   %eax,%eax
  801713:	74 0f                	je     801724 <free+0x8e>
  801715:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801718:	8b 40 04             	mov    0x4(%eax),%eax
  80171b:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80171e:	8b 12                	mov    (%edx),%edx
  801720:	89 10                	mov    %edx,(%eax)
  801722:	eb 0a                	jmp    80172e <free+0x98>
  801724:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801727:	8b 00                	mov    (%eax),%eax
  801729:	a3 40 40 80 00       	mov    %eax,0x804040
  80172e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801731:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  801737:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80173a:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  801741:	a1 4c 40 80 00       	mov    0x80404c,%eax
  801746:	48                   	dec    %eax
  801747:	a3 4c 40 80 00       	mov    %eax,0x80404c
	insert_sorted_with_merge_freeList(myBlock);
  80174c:	83 ec 0c             	sub    $0xc,%esp
  80174f:	ff 75 f0             	pushl  -0x10(%ebp)
  801752:	e8 0b 14 00 00       	call   802b62 <insert_sorted_with_merge_freeList>
  801757:	83 c4 10             	add    $0x10,%esp

	//you should get the size of the given allocation using its address
	//you need to call sys_free_user_mem()
	//refer to the project presentation and documentation for details
}
  80175a:	90                   	nop
  80175b:	c9                   	leave  
  80175c:	c3                   	ret    

0080175d <smalloc>:

//=================================
// [4] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
  80175d:	55                   	push   %ebp
  80175e:	89 e5                	mov    %esp,%ebp
  801760:	83 ec 28             	sub    $0x28,%esp
  801763:	8b 45 10             	mov    0x10(%ebp),%eax
  801766:	88 45 e4             	mov    %al,-0x1c(%ebp)
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801769:	e8 9f fc ff ff       	call   80140d <InitializeUHeap>
	if (size == 0) return NULL ;
  80176e:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801772:	75 0a                	jne    80177e <smalloc+0x21>
  801774:	b8 00 00 00 00       	mov    $0x0,%eax
  801779:	e9 8d 00 00 00       	jmp    80180b <smalloc+0xae>

	//This function should find the space of the required range
	// * ON 4KB BOUNDARY **** //
	//Use sys_isUHeapPlacementStrategyFIRSTFIT() to check the current strategy

	size = ROUNDUP(size, PAGE_SIZE);
  80177e:	c7 45 f4 00 10 00 00 	movl   $0x1000,-0xc(%ebp)
  801785:	8b 55 0c             	mov    0xc(%ebp),%edx
  801788:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80178b:	01 d0                	add    %edx,%eax
  80178d:	48                   	dec    %eax
  80178e:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801791:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801794:	ba 00 00 00 00       	mov    $0x0,%edx
  801799:	f7 75 f4             	divl   -0xc(%ebp)
  80179c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80179f:	29 d0                	sub    %edx,%eax
  8017a1:	89 45 0c             	mov    %eax,0xc(%ebp)
		if(sys_isUHeapPlacementStrategyFIRSTFIT())
  8017a4:	e8 c9 06 00 00       	call   801e72 <sys_isUHeapPlacementStrategyFIRSTFIT>
  8017a9:	85 c0                	test   %eax,%eax
  8017ab:	74 59                	je     801806 <smalloc+0xa9>
		{
			struct MemBlock * v1=NULL;
  8017ad:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
			v1= alloc_block_FF(size);
  8017b4:	83 ec 0c             	sub    $0xc,%esp
  8017b7:	ff 75 0c             	pushl  0xc(%ebp)
  8017ba:	e8 b4 0c 00 00       	call   802473 <alloc_block_FF>
  8017bf:	83 c4 10             	add    $0x10,%esp
  8017c2:	89 45 ec             	mov    %eax,-0x14(%ebp)
			if(v1==NULL)
  8017c5:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8017c9:	75 07                	jne    8017d2 <smalloc+0x75>
			{
				return NULL;
  8017cb:	b8 00 00 00 00       	mov    $0x0,%eax
  8017d0:	eb 39                	jmp    80180b <smalloc+0xae>
			}
			else
			{
				int ret=sys_createSharedObject(sharedVarName,  size,  isWritable,(void*)v1->sva);
  8017d2:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8017d5:	8b 40 08             	mov    0x8(%eax),%eax
  8017d8:	89 c2                	mov    %eax,%edx
  8017da:	0f b6 45 e4          	movzbl -0x1c(%ebp),%eax
  8017de:	52                   	push   %edx
  8017df:	50                   	push   %eax
  8017e0:	ff 75 0c             	pushl  0xc(%ebp)
  8017e3:	ff 75 08             	pushl  0x8(%ebp)
  8017e6:	e8 0c 04 00 00       	call   801bf7 <sys_createSharedObject>
  8017eb:	83 c4 10             	add    $0x10,%esp
  8017ee:	89 45 e8             	mov    %eax,-0x18(%ebp)
				if(ret>=0)
  8017f1:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8017f5:	78 08                	js     8017ff <smalloc+0xa2>
				{
					return (void*)v1->sva;
  8017f7:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8017fa:	8b 40 08             	mov    0x8(%eax),%eax
  8017fd:	eb 0c                	jmp    80180b <smalloc+0xae>
				}
				else
				{
					return NULL;
  8017ff:	b8 00 00 00 00       	mov    $0x0,%eax
  801804:	eb 05                	jmp    80180b <smalloc+0xae>
				}
			}

		}
		return NULL;
  801806:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80180b:	c9                   	leave  
  80180c:	c3                   	ret    

0080180d <sget>:

//========================================
// [5] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  80180d:	55                   	push   %ebp
  80180e:	89 e5                	mov    %esp,%ebp
  801810:	83 ec 18             	sub    $0x18,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801813:	e8 f5 fb ff ff       	call   80140d <InitializeUHeap>

	//This function should find the space for sharing the variable
	// *** ON 4KB BOUNDARY ******** //

	//Use sys_isUHeapPlacementStrategyFIRSTFIT() to check the current strategy
	int ret=sys_getSizeOfSharedObject(ownerEnvID,sharedVarName);
  801818:	83 ec 08             	sub    $0x8,%esp
  80181b:	ff 75 0c             	pushl  0xc(%ebp)
  80181e:	ff 75 08             	pushl  0x8(%ebp)
  801821:	e8 fb 03 00 00       	call   801c21 <sys_getSizeOfSharedObject>
  801826:	83 c4 10             	add    $0x10,%esp
  801829:	89 45 f4             	mov    %eax,-0xc(%ebp)
	if(ret==0)
  80182c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801830:	75 07                	jne    801839 <sget+0x2c>
	{
		return NULL;
  801832:	b8 00 00 00 00       	mov    $0x0,%eax
  801837:	eb 64                	jmp    80189d <sget+0x90>
	}
	if(sys_isUHeapPlacementStrategyFIRSTFIT())
  801839:	e8 34 06 00 00       	call   801e72 <sys_isUHeapPlacementStrategyFIRSTFIT>
  80183e:	85 c0                	test   %eax,%eax
  801840:	74 56                	je     801898 <sget+0x8b>
	{
		struct MemBlock * v1=NULL;
  801842:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
		v1= alloc_block_FF(ret);
  801849:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80184c:	83 ec 0c             	sub    $0xc,%esp
  80184f:	50                   	push   %eax
  801850:	e8 1e 0c 00 00       	call   802473 <alloc_block_FF>
  801855:	83 c4 10             	add    $0x10,%esp
  801858:	89 45 f0             	mov    %eax,-0x10(%ebp)
		if(v1==NULL)
  80185b:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80185f:	75 07                	jne    801868 <sget+0x5b>
		{
		return NULL;
  801861:	b8 00 00 00 00       	mov    $0x0,%eax
  801866:	eb 35                	jmp    80189d <sget+0x90>
	    }
		else
		{
			int ret1=sys_getSharedObject(ownerEnvID,sharedVarName,(void*)v1->sva);
  801868:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80186b:	8b 40 08             	mov    0x8(%eax),%eax
  80186e:	83 ec 04             	sub    $0x4,%esp
  801871:	50                   	push   %eax
  801872:	ff 75 0c             	pushl  0xc(%ebp)
  801875:	ff 75 08             	pushl  0x8(%ebp)
  801878:	e8 c1 03 00 00       	call   801c3e <sys_getSharedObject>
  80187d:	83 c4 10             	add    $0x10,%esp
  801880:	89 45 ec             	mov    %eax,-0x14(%ebp)
			if(ret1>=0)
  801883:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  801887:	78 08                	js     801891 <sget+0x84>
			{
				return (void*)v1->sva;
  801889:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80188c:	8b 40 08             	mov    0x8(%eax),%eax
  80188f:	eb 0c                	jmp    80189d <sget+0x90>
			}
			else
			{
				return NULL;
  801891:	b8 00 00 00 00       	mov    $0x0,%eax
  801896:	eb 05                	jmp    80189d <sget+0x90>
			}
		}
	}
  return NULL;
  801898:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80189d:	c9                   	leave  
  80189e:	c3                   	ret    

0080189f <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  80189f:	55                   	push   %ebp
  8018a0:	89 e5                	mov    %esp,%ebp
  8018a2:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  8018a5:	e8 63 fb ff ff       	call   80140d <InitializeUHeap>
	//==============================================================
	// [USER HEAP - USER SIDE] realloc
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  8018aa:	83 ec 04             	sub    $0x4,%esp
  8018ad:	68 44 39 80 00       	push   $0x803944
  8018b2:	68 0e 01 00 00       	push   $0x10e
  8018b7:	68 13 39 80 00       	push   $0x803913
  8018bc:	e8 e8 16 00 00       	call   802fa9 <_panic>

008018c1 <sfree>:
//	use sys_freeSharedObject(...); which switches to the kernel mode,
//	calls freeSharedObject(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the freeSharedObject() function is empty, make sure to implement it.

void sfree(void* virtual_address)
{
  8018c1:	55                   	push   %ebp
  8018c2:	89 e5                	mov    %esp,%ebp
  8018c4:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS3 - BONUS] [SHARING - USER SIDE] sfree()

	// Write your code here, remove the panic and write your code
	panic("sfree() is not implemented yet...!!");
  8018c7:	83 ec 04             	sub    $0x4,%esp
  8018ca:	68 6c 39 80 00       	push   $0x80396c
  8018cf:	68 22 01 00 00       	push   $0x122
  8018d4:	68 13 39 80 00       	push   $0x803913
  8018d9:	e8 cb 16 00 00       	call   802fa9 <_panic>

008018de <expand>:

//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//
void expand(uint32 newSize)
{
  8018de:	55                   	push   %ebp
  8018df:	89 e5                	mov    %esp,%ebp
  8018e1:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  8018e4:	83 ec 04             	sub    $0x4,%esp
  8018e7:	68 90 39 80 00       	push   $0x803990
  8018ec:	68 2d 01 00 00       	push   $0x12d
  8018f1:	68 13 39 80 00       	push   $0x803913
  8018f6:	e8 ae 16 00 00       	call   802fa9 <_panic>

008018fb <shrink>:

}
void shrink(uint32 newSize)
{
  8018fb:	55                   	push   %ebp
  8018fc:	89 e5                	mov    %esp,%ebp
  8018fe:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801901:	83 ec 04             	sub    $0x4,%esp
  801904:	68 90 39 80 00       	push   $0x803990
  801909:	68 32 01 00 00       	push   $0x132
  80190e:	68 13 39 80 00       	push   $0x803913
  801913:	e8 91 16 00 00       	call   802fa9 <_panic>

00801918 <freeHeap>:

}
void freeHeap(void* virtual_address)
{
  801918:	55                   	push   %ebp
  801919:	89 e5                	mov    %esp,%ebp
  80191b:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  80191e:	83 ec 04             	sub    $0x4,%esp
  801921:	68 90 39 80 00       	push   $0x803990
  801926:	68 37 01 00 00       	push   $0x137
  80192b:	68 13 39 80 00       	push   $0x803913
  801930:	e8 74 16 00 00       	call   802fa9 <_panic>

00801935 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  801935:	55                   	push   %ebp
  801936:	89 e5                	mov    %esp,%ebp
  801938:	57                   	push   %edi
  801939:	56                   	push   %esi
  80193a:	53                   	push   %ebx
  80193b:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  80193e:	8b 45 08             	mov    0x8(%ebp),%eax
  801941:	8b 55 0c             	mov    0xc(%ebp),%edx
  801944:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801947:	8b 5d 14             	mov    0x14(%ebp),%ebx
  80194a:	8b 7d 18             	mov    0x18(%ebp),%edi
  80194d:	8b 75 1c             	mov    0x1c(%ebp),%esi
  801950:	cd 30                	int    $0x30
  801952:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  801955:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801958:	83 c4 10             	add    $0x10,%esp
  80195b:	5b                   	pop    %ebx
  80195c:	5e                   	pop    %esi
  80195d:	5f                   	pop    %edi
  80195e:	5d                   	pop    %ebp
  80195f:	c3                   	ret    

00801960 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  801960:	55                   	push   %ebp
  801961:	89 e5                	mov    %esp,%ebp
  801963:	83 ec 04             	sub    $0x4,%esp
  801966:	8b 45 10             	mov    0x10(%ebp),%eax
  801969:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  80196c:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801970:	8b 45 08             	mov    0x8(%ebp),%eax
  801973:	6a 00                	push   $0x0
  801975:	6a 00                	push   $0x0
  801977:	52                   	push   %edx
  801978:	ff 75 0c             	pushl  0xc(%ebp)
  80197b:	50                   	push   %eax
  80197c:	6a 00                	push   $0x0
  80197e:	e8 b2 ff ff ff       	call   801935 <syscall>
  801983:	83 c4 18             	add    $0x18,%esp
}
  801986:	90                   	nop
  801987:	c9                   	leave  
  801988:	c3                   	ret    

00801989 <sys_cgetc>:

int
sys_cgetc(void)
{
  801989:	55                   	push   %ebp
  80198a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  80198c:	6a 00                	push   $0x0
  80198e:	6a 00                	push   $0x0
  801990:	6a 00                	push   $0x0
  801992:	6a 00                	push   $0x0
  801994:	6a 00                	push   $0x0
  801996:	6a 01                	push   $0x1
  801998:	e8 98 ff ff ff       	call   801935 <syscall>
  80199d:	83 c4 18             	add    $0x18,%esp
}
  8019a0:	c9                   	leave  
  8019a1:	c3                   	ret    

008019a2 <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  8019a2:	55                   	push   %ebp
  8019a3:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  8019a5:	8b 55 0c             	mov    0xc(%ebp),%edx
  8019a8:	8b 45 08             	mov    0x8(%ebp),%eax
  8019ab:	6a 00                	push   $0x0
  8019ad:	6a 00                	push   $0x0
  8019af:	6a 00                	push   $0x0
  8019b1:	52                   	push   %edx
  8019b2:	50                   	push   %eax
  8019b3:	6a 05                	push   $0x5
  8019b5:	e8 7b ff ff ff       	call   801935 <syscall>
  8019ba:	83 c4 18             	add    $0x18,%esp
}
  8019bd:	c9                   	leave  
  8019be:	c3                   	ret    

008019bf <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  8019bf:	55                   	push   %ebp
  8019c0:	89 e5                	mov    %esp,%ebp
  8019c2:	56                   	push   %esi
  8019c3:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  8019c4:	8b 75 18             	mov    0x18(%ebp),%esi
  8019c7:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8019ca:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8019cd:	8b 55 0c             	mov    0xc(%ebp),%edx
  8019d0:	8b 45 08             	mov    0x8(%ebp),%eax
  8019d3:	56                   	push   %esi
  8019d4:	53                   	push   %ebx
  8019d5:	51                   	push   %ecx
  8019d6:	52                   	push   %edx
  8019d7:	50                   	push   %eax
  8019d8:	6a 06                	push   $0x6
  8019da:	e8 56 ff ff ff       	call   801935 <syscall>
  8019df:	83 c4 18             	add    $0x18,%esp
}
  8019e2:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8019e5:	5b                   	pop    %ebx
  8019e6:	5e                   	pop    %esi
  8019e7:	5d                   	pop    %ebp
  8019e8:	c3                   	ret    

008019e9 <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  8019e9:	55                   	push   %ebp
  8019ea:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  8019ec:	8b 55 0c             	mov    0xc(%ebp),%edx
  8019ef:	8b 45 08             	mov    0x8(%ebp),%eax
  8019f2:	6a 00                	push   $0x0
  8019f4:	6a 00                	push   $0x0
  8019f6:	6a 00                	push   $0x0
  8019f8:	52                   	push   %edx
  8019f9:	50                   	push   %eax
  8019fa:	6a 07                	push   $0x7
  8019fc:	e8 34 ff ff ff       	call   801935 <syscall>
  801a01:	83 c4 18             	add    $0x18,%esp
}
  801a04:	c9                   	leave  
  801a05:	c3                   	ret    

00801a06 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  801a06:	55                   	push   %ebp
  801a07:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  801a09:	6a 00                	push   $0x0
  801a0b:	6a 00                	push   $0x0
  801a0d:	6a 00                	push   $0x0
  801a0f:	ff 75 0c             	pushl  0xc(%ebp)
  801a12:	ff 75 08             	pushl  0x8(%ebp)
  801a15:	6a 08                	push   $0x8
  801a17:	e8 19 ff ff ff       	call   801935 <syscall>
  801a1c:	83 c4 18             	add    $0x18,%esp
}
  801a1f:	c9                   	leave  
  801a20:	c3                   	ret    

00801a21 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  801a21:	55                   	push   %ebp
  801a22:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  801a24:	6a 00                	push   $0x0
  801a26:	6a 00                	push   $0x0
  801a28:	6a 00                	push   $0x0
  801a2a:	6a 00                	push   $0x0
  801a2c:	6a 00                	push   $0x0
  801a2e:	6a 09                	push   $0x9
  801a30:	e8 00 ff ff ff       	call   801935 <syscall>
  801a35:	83 c4 18             	add    $0x18,%esp
}
  801a38:	c9                   	leave  
  801a39:	c3                   	ret    

00801a3a <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  801a3a:	55                   	push   %ebp
  801a3b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  801a3d:	6a 00                	push   $0x0
  801a3f:	6a 00                	push   $0x0
  801a41:	6a 00                	push   $0x0
  801a43:	6a 00                	push   $0x0
  801a45:	6a 00                	push   $0x0
  801a47:	6a 0a                	push   $0xa
  801a49:	e8 e7 fe ff ff       	call   801935 <syscall>
  801a4e:	83 c4 18             	add    $0x18,%esp
}
  801a51:	c9                   	leave  
  801a52:	c3                   	ret    

00801a53 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  801a53:	55                   	push   %ebp
  801a54:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  801a56:	6a 00                	push   $0x0
  801a58:	6a 00                	push   $0x0
  801a5a:	6a 00                	push   $0x0
  801a5c:	6a 00                	push   $0x0
  801a5e:	6a 00                	push   $0x0
  801a60:	6a 0b                	push   $0xb
  801a62:	e8 ce fe ff ff       	call   801935 <syscall>
  801a67:	83 c4 18             	add    $0x18,%esp
}
  801a6a:	c9                   	leave  
  801a6b:	c3                   	ret    

00801a6c <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  801a6c:	55                   	push   %ebp
  801a6d:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  801a6f:	6a 00                	push   $0x0
  801a71:	6a 00                	push   $0x0
  801a73:	6a 00                	push   $0x0
  801a75:	ff 75 0c             	pushl  0xc(%ebp)
  801a78:	ff 75 08             	pushl  0x8(%ebp)
  801a7b:	6a 0f                	push   $0xf
  801a7d:	e8 b3 fe ff ff       	call   801935 <syscall>
  801a82:	83 c4 18             	add    $0x18,%esp
	return;
  801a85:	90                   	nop
}
  801a86:	c9                   	leave  
  801a87:	c3                   	ret    

00801a88 <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  801a88:	55                   	push   %ebp
  801a89:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  801a8b:	6a 00                	push   $0x0
  801a8d:	6a 00                	push   $0x0
  801a8f:	6a 00                	push   $0x0
  801a91:	ff 75 0c             	pushl  0xc(%ebp)
  801a94:	ff 75 08             	pushl  0x8(%ebp)
  801a97:	6a 10                	push   $0x10
  801a99:	e8 97 fe ff ff       	call   801935 <syscall>
  801a9e:	83 c4 18             	add    $0x18,%esp
	return ;
  801aa1:	90                   	nop
}
  801aa2:	c9                   	leave  
  801aa3:	c3                   	ret    

00801aa4 <sys_allocate_chunk>:

void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  801aa4:	55                   	push   %ebp
  801aa5:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  801aa7:	6a 00                	push   $0x0
  801aa9:	6a 00                	push   $0x0
  801aab:	ff 75 10             	pushl  0x10(%ebp)
  801aae:	ff 75 0c             	pushl  0xc(%ebp)
  801ab1:	ff 75 08             	pushl  0x8(%ebp)
  801ab4:	6a 11                	push   $0x11
  801ab6:	e8 7a fe ff ff       	call   801935 <syscall>
  801abb:	83 c4 18             	add    $0x18,%esp
	return ;
  801abe:	90                   	nop
}
  801abf:	c9                   	leave  
  801ac0:	c3                   	ret    

00801ac1 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  801ac1:	55                   	push   %ebp
  801ac2:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  801ac4:	6a 00                	push   $0x0
  801ac6:	6a 00                	push   $0x0
  801ac8:	6a 00                	push   $0x0
  801aca:	6a 00                	push   $0x0
  801acc:	6a 00                	push   $0x0
  801ace:	6a 0c                	push   $0xc
  801ad0:	e8 60 fe ff ff       	call   801935 <syscall>
  801ad5:	83 c4 18             	add    $0x18,%esp
}
  801ad8:	c9                   	leave  
  801ad9:	c3                   	ret    

00801ada <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  801ada:	55                   	push   %ebp
  801adb:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  801add:	6a 00                	push   $0x0
  801adf:	6a 00                	push   $0x0
  801ae1:	6a 00                	push   $0x0
  801ae3:	6a 00                	push   $0x0
  801ae5:	ff 75 08             	pushl  0x8(%ebp)
  801ae8:	6a 0d                	push   $0xd
  801aea:	e8 46 fe ff ff       	call   801935 <syscall>
  801aef:	83 c4 18             	add    $0x18,%esp
}
  801af2:	c9                   	leave  
  801af3:	c3                   	ret    

00801af4 <sys_scarce_memory>:

void sys_scarce_memory()
{
  801af4:	55                   	push   %ebp
  801af5:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  801af7:	6a 00                	push   $0x0
  801af9:	6a 00                	push   $0x0
  801afb:	6a 00                	push   $0x0
  801afd:	6a 00                	push   $0x0
  801aff:	6a 00                	push   $0x0
  801b01:	6a 0e                	push   $0xe
  801b03:	e8 2d fe ff ff       	call   801935 <syscall>
  801b08:	83 c4 18             	add    $0x18,%esp
}
  801b0b:	90                   	nop
  801b0c:	c9                   	leave  
  801b0d:	c3                   	ret    

00801b0e <sys_disable_interrupt>:

//NEW !! 2012...
void
sys_disable_interrupt()
{
  801b0e:	55                   	push   %ebp
  801b0f:	89 e5                	mov    %esp,%ebp
	syscall(SYS_disableINTR,0, 0, 0, 0, 0);
  801b11:	6a 00                	push   $0x0
  801b13:	6a 00                	push   $0x0
  801b15:	6a 00                	push   $0x0
  801b17:	6a 00                	push   $0x0
  801b19:	6a 00                	push   $0x0
  801b1b:	6a 13                	push   $0x13
  801b1d:	e8 13 fe ff ff       	call   801935 <syscall>
  801b22:	83 c4 18             	add    $0x18,%esp
}
  801b25:	90                   	nop
  801b26:	c9                   	leave  
  801b27:	c3                   	ret    

00801b28 <sys_enable_interrupt>:


void
sys_enable_interrupt()
{
  801b28:	55                   	push   %ebp
  801b29:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enableINTR,0, 0, 0, 0, 0);
  801b2b:	6a 00                	push   $0x0
  801b2d:	6a 00                	push   $0x0
  801b2f:	6a 00                	push   $0x0
  801b31:	6a 00                	push   $0x0
  801b33:	6a 00                	push   $0x0
  801b35:	6a 14                	push   $0x14
  801b37:	e8 f9 fd ff ff       	call   801935 <syscall>
  801b3c:	83 c4 18             	add    $0x18,%esp
}
  801b3f:	90                   	nop
  801b40:	c9                   	leave  
  801b41:	c3                   	ret    

00801b42 <sys_cputc>:


void
sys_cputc(const char c)
{
  801b42:	55                   	push   %ebp
  801b43:	89 e5                	mov    %esp,%ebp
  801b45:	83 ec 04             	sub    $0x4,%esp
  801b48:	8b 45 08             	mov    0x8(%ebp),%eax
  801b4b:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  801b4e:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801b52:	6a 00                	push   $0x0
  801b54:	6a 00                	push   $0x0
  801b56:	6a 00                	push   $0x0
  801b58:	6a 00                	push   $0x0
  801b5a:	50                   	push   %eax
  801b5b:	6a 15                	push   $0x15
  801b5d:	e8 d3 fd ff ff       	call   801935 <syscall>
  801b62:	83 c4 18             	add    $0x18,%esp
}
  801b65:	90                   	nop
  801b66:	c9                   	leave  
  801b67:	c3                   	ret    

00801b68 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  801b68:	55                   	push   %ebp
  801b69:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  801b6b:	6a 00                	push   $0x0
  801b6d:	6a 00                	push   $0x0
  801b6f:	6a 00                	push   $0x0
  801b71:	6a 00                	push   $0x0
  801b73:	6a 00                	push   $0x0
  801b75:	6a 16                	push   $0x16
  801b77:	e8 b9 fd ff ff       	call   801935 <syscall>
  801b7c:	83 c4 18             	add    $0x18,%esp
}
  801b7f:	90                   	nop
  801b80:	c9                   	leave  
  801b81:	c3                   	ret    

00801b82 <sys_createSemaphore>:

int
sys_createSemaphore(char* semaphoreName, uint32 initialValue)
{
  801b82:	55                   	push   %ebp
  801b83:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_semaphore,(uint32)semaphoreName, (uint32)initialValue, 0, 0, 0);
  801b85:	8b 45 08             	mov    0x8(%ebp),%eax
  801b88:	6a 00                	push   $0x0
  801b8a:	6a 00                	push   $0x0
  801b8c:	6a 00                	push   $0x0
  801b8e:	ff 75 0c             	pushl  0xc(%ebp)
  801b91:	50                   	push   %eax
  801b92:	6a 17                	push   $0x17
  801b94:	e8 9c fd ff ff       	call   801935 <syscall>
  801b99:	83 c4 18             	add    $0x18,%esp
}
  801b9c:	c9                   	leave  
  801b9d:	c3                   	ret    

00801b9e <sys_getSemaphoreValue>:

int
sys_getSemaphoreValue(int32 ownerEnvID, char* semaphoreName)
{
  801b9e:	55                   	push   %ebp
  801b9f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_semaphore_value,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801ba1:	8b 55 0c             	mov    0xc(%ebp),%edx
  801ba4:	8b 45 08             	mov    0x8(%ebp),%eax
  801ba7:	6a 00                	push   $0x0
  801ba9:	6a 00                	push   $0x0
  801bab:	6a 00                	push   $0x0
  801bad:	52                   	push   %edx
  801bae:	50                   	push   %eax
  801baf:	6a 1a                	push   $0x1a
  801bb1:	e8 7f fd ff ff       	call   801935 <syscall>
  801bb6:	83 c4 18             	add    $0x18,%esp
}
  801bb9:	c9                   	leave  
  801bba:	c3                   	ret    

00801bbb <sys_waitSemaphore>:

void
sys_waitSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801bbb:	55                   	push   %ebp
  801bbc:	89 e5                	mov    %esp,%ebp
	syscall(SYS_wait_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801bbe:	8b 55 0c             	mov    0xc(%ebp),%edx
  801bc1:	8b 45 08             	mov    0x8(%ebp),%eax
  801bc4:	6a 00                	push   $0x0
  801bc6:	6a 00                	push   $0x0
  801bc8:	6a 00                	push   $0x0
  801bca:	52                   	push   %edx
  801bcb:	50                   	push   %eax
  801bcc:	6a 18                	push   $0x18
  801bce:	e8 62 fd ff ff       	call   801935 <syscall>
  801bd3:	83 c4 18             	add    $0x18,%esp
}
  801bd6:	90                   	nop
  801bd7:	c9                   	leave  
  801bd8:	c3                   	ret    

00801bd9 <sys_signalSemaphore>:

void
sys_signalSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801bd9:	55                   	push   %ebp
  801bda:	89 e5                	mov    %esp,%ebp
	syscall(SYS_signal_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801bdc:	8b 55 0c             	mov    0xc(%ebp),%edx
  801bdf:	8b 45 08             	mov    0x8(%ebp),%eax
  801be2:	6a 00                	push   $0x0
  801be4:	6a 00                	push   $0x0
  801be6:	6a 00                	push   $0x0
  801be8:	52                   	push   %edx
  801be9:	50                   	push   %eax
  801bea:	6a 19                	push   $0x19
  801bec:	e8 44 fd ff ff       	call   801935 <syscall>
  801bf1:	83 c4 18             	add    $0x18,%esp
}
  801bf4:	90                   	nop
  801bf5:	c9                   	leave  
  801bf6:	c3                   	ret    

00801bf7 <sys_createSharedObject>:

int
sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  801bf7:	55                   	push   %ebp
  801bf8:	89 e5                	mov    %esp,%ebp
  801bfa:	83 ec 04             	sub    $0x4,%esp
  801bfd:	8b 45 10             	mov    0x10(%ebp),%eax
  801c00:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  801c03:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801c06:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801c0a:	8b 45 08             	mov    0x8(%ebp),%eax
  801c0d:	6a 00                	push   $0x0
  801c0f:	51                   	push   %ecx
  801c10:	52                   	push   %edx
  801c11:	ff 75 0c             	pushl  0xc(%ebp)
  801c14:	50                   	push   %eax
  801c15:	6a 1b                	push   $0x1b
  801c17:	e8 19 fd ff ff       	call   801935 <syscall>
  801c1c:	83 c4 18             	add    $0x18,%esp
}
  801c1f:	c9                   	leave  
  801c20:	c3                   	ret    

00801c21 <sys_getSizeOfSharedObject>:

//2017:
int
sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  801c21:	55                   	push   %ebp
  801c22:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  801c24:	8b 55 0c             	mov    0xc(%ebp),%edx
  801c27:	8b 45 08             	mov    0x8(%ebp),%eax
  801c2a:	6a 00                	push   $0x0
  801c2c:	6a 00                	push   $0x0
  801c2e:	6a 00                	push   $0x0
  801c30:	52                   	push   %edx
  801c31:	50                   	push   %eax
  801c32:	6a 1c                	push   $0x1c
  801c34:	e8 fc fc ff ff       	call   801935 <syscall>
  801c39:	83 c4 18             	add    $0x18,%esp
}
  801c3c:	c9                   	leave  
  801c3d:	c3                   	ret    

00801c3e <sys_getSharedObject>:
//==========

int
sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  801c3e:	55                   	push   %ebp
  801c3f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  801c41:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801c44:	8b 55 0c             	mov    0xc(%ebp),%edx
  801c47:	8b 45 08             	mov    0x8(%ebp),%eax
  801c4a:	6a 00                	push   $0x0
  801c4c:	6a 00                	push   $0x0
  801c4e:	51                   	push   %ecx
  801c4f:	52                   	push   %edx
  801c50:	50                   	push   %eax
  801c51:	6a 1d                	push   $0x1d
  801c53:	e8 dd fc ff ff       	call   801935 <syscall>
  801c58:	83 c4 18             	add    $0x18,%esp
}
  801c5b:	c9                   	leave  
  801c5c:	c3                   	ret    

00801c5d <sys_freeSharedObject>:

int
sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  801c5d:	55                   	push   %ebp
  801c5e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  801c60:	8b 55 0c             	mov    0xc(%ebp),%edx
  801c63:	8b 45 08             	mov    0x8(%ebp),%eax
  801c66:	6a 00                	push   $0x0
  801c68:	6a 00                	push   $0x0
  801c6a:	6a 00                	push   $0x0
  801c6c:	52                   	push   %edx
  801c6d:	50                   	push   %eax
  801c6e:	6a 1e                	push   $0x1e
  801c70:	e8 c0 fc ff ff       	call   801935 <syscall>
  801c75:	83 c4 18             	add    $0x18,%esp
}
  801c78:	c9                   	leave  
  801c79:	c3                   	ret    

00801c7a <sys_getMaxShares>:

uint32 	sys_getMaxShares()
{
  801c7a:	55                   	push   %ebp
  801c7b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_max_shares,0, 0, 0, 0, 0);
  801c7d:	6a 00                	push   $0x0
  801c7f:	6a 00                	push   $0x0
  801c81:	6a 00                	push   $0x0
  801c83:	6a 00                	push   $0x0
  801c85:	6a 00                	push   $0x0
  801c87:	6a 1f                	push   $0x1f
  801c89:	e8 a7 fc ff ff       	call   801935 <syscall>
  801c8e:	83 c4 18             	add    $0x18,%esp
}
  801c91:	c9                   	leave  
  801c92:	c3                   	ret    

00801c93 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  801c93:	55                   	push   %ebp
  801c94:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  801c96:	8b 45 08             	mov    0x8(%ebp),%eax
  801c99:	6a 00                	push   $0x0
  801c9b:	ff 75 14             	pushl  0x14(%ebp)
  801c9e:	ff 75 10             	pushl  0x10(%ebp)
  801ca1:	ff 75 0c             	pushl  0xc(%ebp)
  801ca4:	50                   	push   %eax
  801ca5:	6a 20                	push   $0x20
  801ca7:	e8 89 fc ff ff       	call   801935 <syscall>
  801cac:	83 c4 18             	add    $0x18,%esp
}
  801caf:	c9                   	leave  
  801cb0:	c3                   	ret    

00801cb1 <sys_run_env>:

void
sys_run_env(int32 envId)
{
  801cb1:	55                   	push   %ebp
  801cb2:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  801cb4:	8b 45 08             	mov    0x8(%ebp),%eax
  801cb7:	6a 00                	push   $0x0
  801cb9:	6a 00                	push   $0x0
  801cbb:	6a 00                	push   $0x0
  801cbd:	6a 00                	push   $0x0
  801cbf:	50                   	push   %eax
  801cc0:	6a 21                	push   $0x21
  801cc2:	e8 6e fc ff ff       	call   801935 <syscall>
  801cc7:	83 c4 18             	add    $0x18,%esp
}
  801cca:	90                   	nop
  801ccb:	c9                   	leave  
  801ccc:	c3                   	ret    

00801ccd <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  801ccd:	55                   	push   %ebp
  801cce:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  801cd0:	8b 45 08             	mov    0x8(%ebp),%eax
  801cd3:	6a 00                	push   $0x0
  801cd5:	6a 00                	push   $0x0
  801cd7:	6a 00                	push   $0x0
  801cd9:	6a 00                	push   $0x0
  801cdb:	50                   	push   %eax
  801cdc:	6a 22                	push   $0x22
  801cde:	e8 52 fc ff ff       	call   801935 <syscall>
  801ce3:	83 c4 18             	add    $0x18,%esp
}
  801ce6:	c9                   	leave  
  801ce7:	c3                   	ret    

00801ce8 <sys_getenvid>:

int32 sys_getenvid(void)
{
  801ce8:	55                   	push   %ebp
  801ce9:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  801ceb:	6a 00                	push   $0x0
  801ced:	6a 00                	push   $0x0
  801cef:	6a 00                	push   $0x0
  801cf1:	6a 00                	push   $0x0
  801cf3:	6a 00                	push   $0x0
  801cf5:	6a 02                	push   $0x2
  801cf7:	e8 39 fc ff ff       	call   801935 <syscall>
  801cfc:	83 c4 18             	add    $0x18,%esp
}
  801cff:	c9                   	leave  
  801d00:	c3                   	ret    

00801d01 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  801d01:	55                   	push   %ebp
  801d02:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  801d04:	6a 00                	push   $0x0
  801d06:	6a 00                	push   $0x0
  801d08:	6a 00                	push   $0x0
  801d0a:	6a 00                	push   $0x0
  801d0c:	6a 00                	push   $0x0
  801d0e:	6a 03                	push   $0x3
  801d10:	e8 20 fc ff ff       	call   801935 <syscall>
  801d15:	83 c4 18             	add    $0x18,%esp
}
  801d18:	c9                   	leave  
  801d19:	c3                   	ret    

00801d1a <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  801d1a:	55                   	push   %ebp
  801d1b:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  801d1d:	6a 00                	push   $0x0
  801d1f:	6a 00                	push   $0x0
  801d21:	6a 00                	push   $0x0
  801d23:	6a 00                	push   $0x0
  801d25:	6a 00                	push   $0x0
  801d27:	6a 04                	push   $0x4
  801d29:	e8 07 fc ff ff       	call   801935 <syscall>
  801d2e:	83 c4 18             	add    $0x18,%esp
}
  801d31:	c9                   	leave  
  801d32:	c3                   	ret    

00801d33 <sys_exit_env>:


void sys_exit_env(void)
{
  801d33:	55                   	push   %ebp
  801d34:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  801d36:	6a 00                	push   $0x0
  801d38:	6a 00                	push   $0x0
  801d3a:	6a 00                	push   $0x0
  801d3c:	6a 00                	push   $0x0
  801d3e:	6a 00                	push   $0x0
  801d40:	6a 23                	push   $0x23
  801d42:	e8 ee fb ff ff       	call   801935 <syscall>
  801d47:	83 c4 18             	add    $0x18,%esp
}
  801d4a:	90                   	nop
  801d4b:	c9                   	leave  
  801d4c:	c3                   	ret    

00801d4d <sys_get_virtual_time>:


struct uint64
sys_get_virtual_time()
{
  801d4d:	55                   	push   %ebp
  801d4e:	89 e5                	mov    %esp,%ebp
  801d50:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  801d53:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801d56:	8d 50 04             	lea    0x4(%eax),%edx
  801d59:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801d5c:	6a 00                	push   $0x0
  801d5e:	6a 00                	push   $0x0
  801d60:	6a 00                	push   $0x0
  801d62:	52                   	push   %edx
  801d63:	50                   	push   %eax
  801d64:	6a 24                	push   $0x24
  801d66:	e8 ca fb ff ff       	call   801935 <syscall>
  801d6b:	83 c4 18             	add    $0x18,%esp
	return result;
  801d6e:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801d71:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801d74:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801d77:	89 01                	mov    %eax,(%ecx)
  801d79:	89 51 04             	mov    %edx,0x4(%ecx)
}
  801d7c:	8b 45 08             	mov    0x8(%ebp),%eax
  801d7f:	c9                   	leave  
  801d80:	c2 04 00             	ret    $0x4

00801d83 <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  801d83:	55                   	push   %ebp
  801d84:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  801d86:	6a 00                	push   $0x0
  801d88:	6a 00                	push   $0x0
  801d8a:	ff 75 10             	pushl  0x10(%ebp)
  801d8d:	ff 75 0c             	pushl  0xc(%ebp)
  801d90:	ff 75 08             	pushl  0x8(%ebp)
  801d93:	6a 12                	push   $0x12
  801d95:	e8 9b fb ff ff       	call   801935 <syscall>
  801d9a:	83 c4 18             	add    $0x18,%esp
	return ;
  801d9d:	90                   	nop
}
  801d9e:	c9                   	leave  
  801d9f:	c3                   	ret    

00801da0 <sys_rcr2>:
uint32 sys_rcr2()
{
  801da0:	55                   	push   %ebp
  801da1:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  801da3:	6a 00                	push   $0x0
  801da5:	6a 00                	push   $0x0
  801da7:	6a 00                	push   $0x0
  801da9:	6a 00                	push   $0x0
  801dab:	6a 00                	push   $0x0
  801dad:	6a 25                	push   $0x25
  801daf:	e8 81 fb ff ff       	call   801935 <syscall>
  801db4:	83 c4 18             	add    $0x18,%esp
}
  801db7:	c9                   	leave  
  801db8:	c3                   	ret    

00801db9 <sys_bypassPageFault>:
void sys_bypassPageFault(uint8 instrLength)
{
  801db9:	55                   	push   %ebp
  801dba:	89 e5                	mov    %esp,%ebp
  801dbc:	83 ec 04             	sub    $0x4,%esp
  801dbf:	8b 45 08             	mov    0x8(%ebp),%eax
  801dc2:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  801dc5:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  801dc9:	6a 00                	push   $0x0
  801dcb:	6a 00                	push   $0x0
  801dcd:	6a 00                	push   $0x0
  801dcf:	6a 00                	push   $0x0
  801dd1:	50                   	push   %eax
  801dd2:	6a 26                	push   $0x26
  801dd4:	e8 5c fb ff ff       	call   801935 <syscall>
  801dd9:	83 c4 18             	add    $0x18,%esp
	return ;
  801ddc:	90                   	nop
}
  801ddd:	c9                   	leave  
  801dde:	c3                   	ret    

00801ddf <rsttst>:
void rsttst()
{
  801ddf:	55                   	push   %ebp
  801de0:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  801de2:	6a 00                	push   $0x0
  801de4:	6a 00                	push   $0x0
  801de6:	6a 00                	push   $0x0
  801de8:	6a 00                	push   $0x0
  801dea:	6a 00                	push   $0x0
  801dec:	6a 28                	push   $0x28
  801dee:	e8 42 fb ff ff       	call   801935 <syscall>
  801df3:	83 c4 18             	add    $0x18,%esp
	return ;
  801df6:	90                   	nop
}
  801df7:	c9                   	leave  
  801df8:	c3                   	ret    

00801df9 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  801df9:	55                   	push   %ebp
  801dfa:	89 e5                	mov    %esp,%ebp
  801dfc:	83 ec 04             	sub    $0x4,%esp
  801dff:	8b 45 14             	mov    0x14(%ebp),%eax
  801e02:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  801e05:	8b 55 18             	mov    0x18(%ebp),%edx
  801e08:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801e0c:	52                   	push   %edx
  801e0d:	50                   	push   %eax
  801e0e:	ff 75 10             	pushl  0x10(%ebp)
  801e11:	ff 75 0c             	pushl  0xc(%ebp)
  801e14:	ff 75 08             	pushl  0x8(%ebp)
  801e17:	6a 27                	push   $0x27
  801e19:	e8 17 fb ff ff       	call   801935 <syscall>
  801e1e:	83 c4 18             	add    $0x18,%esp
	return ;
  801e21:	90                   	nop
}
  801e22:	c9                   	leave  
  801e23:	c3                   	ret    

00801e24 <chktst>:
void chktst(uint32 n)
{
  801e24:	55                   	push   %ebp
  801e25:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  801e27:	6a 00                	push   $0x0
  801e29:	6a 00                	push   $0x0
  801e2b:	6a 00                	push   $0x0
  801e2d:	6a 00                	push   $0x0
  801e2f:	ff 75 08             	pushl  0x8(%ebp)
  801e32:	6a 29                	push   $0x29
  801e34:	e8 fc fa ff ff       	call   801935 <syscall>
  801e39:	83 c4 18             	add    $0x18,%esp
	return ;
  801e3c:	90                   	nop
}
  801e3d:	c9                   	leave  
  801e3e:	c3                   	ret    

00801e3f <inctst>:

void inctst()
{
  801e3f:	55                   	push   %ebp
  801e40:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  801e42:	6a 00                	push   $0x0
  801e44:	6a 00                	push   $0x0
  801e46:	6a 00                	push   $0x0
  801e48:	6a 00                	push   $0x0
  801e4a:	6a 00                	push   $0x0
  801e4c:	6a 2a                	push   $0x2a
  801e4e:	e8 e2 fa ff ff       	call   801935 <syscall>
  801e53:	83 c4 18             	add    $0x18,%esp
	return ;
  801e56:	90                   	nop
}
  801e57:	c9                   	leave  
  801e58:	c3                   	ret    

00801e59 <gettst>:
uint32 gettst()
{
  801e59:	55                   	push   %ebp
  801e5a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  801e5c:	6a 00                	push   $0x0
  801e5e:	6a 00                	push   $0x0
  801e60:	6a 00                	push   $0x0
  801e62:	6a 00                	push   $0x0
  801e64:	6a 00                	push   $0x0
  801e66:	6a 2b                	push   $0x2b
  801e68:	e8 c8 fa ff ff       	call   801935 <syscall>
  801e6d:	83 c4 18             	add    $0x18,%esp
}
  801e70:	c9                   	leave  
  801e71:	c3                   	ret    

00801e72 <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  801e72:	55                   	push   %ebp
  801e73:	89 e5                	mov    %esp,%ebp
  801e75:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801e78:	6a 00                	push   $0x0
  801e7a:	6a 00                	push   $0x0
  801e7c:	6a 00                	push   $0x0
  801e7e:	6a 00                	push   $0x0
  801e80:	6a 00                	push   $0x0
  801e82:	6a 2c                	push   $0x2c
  801e84:	e8 ac fa ff ff       	call   801935 <syscall>
  801e89:	83 c4 18             	add    $0x18,%esp
  801e8c:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  801e8f:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  801e93:	75 07                	jne    801e9c <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  801e95:	b8 01 00 00 00       	mov    $0x1,%eax
  801e9a:	eb 05                	jmp    801ea1 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  801e9c:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801ea1:	c9                   	leave  
  801ea2:	c3                   	ret    

00801ea3 <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  801ea3:	55                   	push   %ebp
  801ea4:	89 e5                	mov    %esp,%ebp
  801ea6:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801ea9:	6a 00                	push   $0x0
  801eab:	6a 00                	push   $0x0
  801ead:	6a 00                	push   $0x0
  801eaf:	6a 00                	push   $0x0
  801eb1:	6a 00                	push   $0x0
  801eb3:	6a 2c                	push   $0x2c
  801eb5:	e8 7b fa ff ff       	call   801935 <syscall>
  801eba:	83 c4 18             	add    $0x18,%esp
  801ebd:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  801ec0:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  801ec4:	75 07                	jne    801ecd <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  801ec6:	b8 01 00 00 00       	mov    $0x1,%eax
  801ecb:	eb 05                	jmp    801ed2 <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  801ecd:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801ed2:	c9                   	leave  
  801ed3:	c3                   	ret    

00801ed4 <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  801ed4:	55                   	push   %ebp
  801ed5:	89 e5                	mov    %esp,%ebp
  801ed7:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801eda:	6a 00                	push   $0x0
  801edc:	6a 00                	push   $0x0
  801ede:	6a 00                	push   $0x0
  801ee0:	6a 00                	push   $0x0
  801ee2:	6a 00                	push   $0x0
  801ee4:	6a 2c                	push   $0x2c
  801ee6:	e8 4a fa ff ff       	call   801935 <syscall>
  801eeb:	83 c4 18             	add    $0x18,%esp
  801eee:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  801ef1:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  801ef5:	75 07                	jne    801efe <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  801ef7:	b8 01 00 00 00       	mov    $0x1,%eax
  801efc:	eb 05                	jmp    801f03 <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  801efe:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801f03:	c9                   	leave  
  801f04:	c3                   	ret    

00801f05 <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  801f05:	55                   	push   %ebp
  801f06:	89 e5                	mov    %esp,%ebp
  801f08:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801f0b:	6a 00                	push   $0x0
  801f0d:	6a 00                	push   $0x0
  801f0f:	6a 00                	push   $0x0
  801f11:	6a 00                	push   $0x0
  801f13:	6a 00                	push   $0x0
  801f15:	6a 2c                	push   $0x2c
  801f17:	e8 19 fa ff ff       	call   801935 <syscall>
  801f1c:	83 c4 18             	add    $0x18,%esp
  801f1f:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  801f22:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  801f26:	75 07                	jne    801f2f <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  801f28:	b8 01 00 00 00       	mov    $0x1,%eax
  801f2d:	eb 05                	jmp    801f34 <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  801f2f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801f34:	c9                   	leave  
  801f35:	c3                   	ret    

00801f36 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  801f36:	55                   	push   %ebp
  801f37:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  801f39:	6a 00                	push   $0x0
  801f3b:	6a 00                	push   $0x0
  801f3d:	6a 00                	push   $0x0
  801f3f:	6a 00                	push   $0x0
  801f41:	ff 75 08             	pushl  0x8(%ebp)
  801f44:	6a 2d                	push   $0x2d
  801f46:	e8 ea f9 ff ff       	call   801935 <syscall>
  801f4b:	83 c4 18             	add    $0x18,%esp
	return ;
  801f4e:	90                   	nop
}
  801f4f:	c9                   	leave  
  801f50:	c3                   	ret    

00801f51 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  801f51:	55                   	push   %ebp
  801f52:	89 e5                	mov    %esp,%ebp
  801f54:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  801f55:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801f58:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801f5b:	8b 55 0c             	mov    0xc(%ebp),%edx
  801f5e:	8b 45 08             	mov    0x8(%ebp),%eax
  801f61:	6a 00                	push   $0x0
  801f63:	53                   	push   %ebx
  801f64:	51                   	push   %ecx
  801f65:	52                   	push   %edx
  801f66:	50                   	push   %eax
  801f67:	6a 2e                	push   $0x2e
  801f69:	e8 c7 f9 ff ff       	call   801935 <syscall>
  801f6e:	83 c4 18             	add    $0x18,%esp
}
  801f71:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801f74:	c9                   	leave  
  801f75:	c3                   	ret    

00801f76 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  801f76:	55                   	push   %ebp
  801f77:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  801f79:	8b 55 0c             	mov    0xc(%ebp),%edx
  801f7c:	8b 45 08             	mov    0x8(%ebp),%eax
  801f7f:	6a 00                	push   $0x0
  801f81:	6a 00                	push   $0x0
  801f83:	6a 00                	push   $0x0
  801f85:	52                   	push   %edx
  801f86:	50                   	push   %eax
  801f87:	6a 2f                	push   $0x2f
  801f89:	e8 a7 f9 ff ff       	call   801935 <syscall>
  801f8e:	83 c4 18             	add    $0x18,%esp
}
  801f91:	c9                   	leave  
  801f92:	c3                   	ret    

00801f93 <print_mem_block_lists>:
//===========================
// PRINT MEM BLOCK LISTS:
//===========================

void print_mem_block_lists()
{
  801f93:	55                   	push   %ebp
  801f94:	89 e5                	mov    %esp,%ebp
  801f96:	83 ec 18             	sub    $0x18,%esp
	cprintf("\n=========================================\n");
  801f99:	83 ec 0c             	sub    $0xc,%esp
  801f9c:	68 a0 39 80 00       	push   $0x8039a0
  801fa1:	e8 dd e6 ff ff       	call   800683 <cprintf>
  801fa6:	83 c4 10             	add    $0x10,%esp
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
  801fa9:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nFreeMemBlocksList:\n");
  801fb0:	83 ec 0c             	sub    $0xc,%esp
  801fb3:	68 cc 39 80 00       	push   $0x8039cc
  801fb8:	e8 c6 e6 ff ff       	call   800683 <cprintf>
  801fbd:	83 c4 10             	add    $0x10,%esp
	uint8 sorted = 1 ;
  801fc0:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &FreeMemBlocksList)
  801fc4:	a1 38 41 80 00       	mov    0x804138,%eax
  801fc9:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801fcc:	eb 56                	jmp    802024 <print_mem_block_lists+0x91>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  801fce:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801fd2:	74 1c                	je     801ff0 <print_mem_block_lists+0x5d>
  801fd4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801fd7:	8b 50 08             	mov    0x8(%eax),%edx
  801fda:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801fdd:	8b 48 08             	mov    0x8(%eax),%ecx
  801fe0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801fe3:	8b 40 0c             	mov    0xc(%eax),%eax
  801fe6:	01 c8                	add    %ecx,%eax
  801fe8:	39 c2                	cmp    %eax,%edx
  801fea:	73 04                	jae    801ff0 <print_mem_block_lists+0x5d>
			sorted = 0 ;
  801fec:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  801ff0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ff3:	8b 50 08             	mov    0x8(%eax),%edx
  801ff6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ff9:	8b 40 0c             	mov    0xc(%eax),%eax
  801ffc:	01 c2                	add    %eax,%edx
  801ffe:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802001:	8b 40 08             	mov    0x8(%eax),%eax
  802004:	83 ec 04             	sub    $0x4,%esp
  802007:	52                   	push   %edx
  802008:	50                   	push   %eax
  802009:	68 e1 39 80 00       	push   $0x8039e1
  80200e:	e8 70 e6 ff ff       	call   800683 <cprintf>
  802013:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  802016:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802019:	89 45 f0             	mov    %eax,-0x10(%ebp)
	cprintf("\n=========================================\n");
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
	cprintf("\nFreeMemBlocksList:\n");
	uint8 sorted = 1 ;
	LIST_FOREACH(blk, &FreeMemBlocksList)
  80201c:	a1 40 41 80 00       	mov    0x804140,%eax
  802021:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802024:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802028:	74 07                	je     802031 <print_mem_block_lists+0x9e>
  80202a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80202d:	8b 00                	mov    (%eax),%eax
  80202f:	eb 05                	jmp    802036 <print_mem_block_lists+0xa3>
  802031:	b8 00 00 00 00       	mov    $0x0,%eax
  802036:	a3 40 41 80 00       	mov    %eax,0x804140
  80203b:	a1 40 41 80 00       	mov    0x804140,%eax
  802040:	85 c0                	test   %eax,%eax
  802042:	75 8a                	jne    801fce <print_mem_block_lists+0x3b>
  802044:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802048:	75 84                	jne    801fce <print_mem_block_lists+0x3b>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;
  80204a:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  80204e:	75 10                	jne    802060 <print_mem_block_lists+0xcd>
  802050:	83 ec 0c             	sub    $0xc,%esp
  802053:	68 f0 39 80 00       	push   $0x8039f0
  802058:	e8 26 e6 ff ff       	call   800683 <cprintf>
  80205d:	83 c4 10             	add    $0x10,%esp

	lastBlk = NULL ;
  802060:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nAllocMemBlocksList:\n");
  802067:	83 ec 0c             	sub    $0xc,%esp
  80206a:	68 14 3a 80 00       	push   $0x803a14
  80206f:	e8 0f e6 ff ff       	call   800683 <cprintf>
  802074:	83 c4 10             	add    $0x10,%esp
	sorted = 1 ;
  802077:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &AllocMemBlocksList)
  80207b:	a1 40 40 80 00       	mov    0x804040,%eax
  802080:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802083:	eb 56                	jmp    8020db <print_mem_block_lists+0x148>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  802085:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802089:	74 1c                	je     8020a7 <print_mem_block_lists+0x114>
  80208b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80208e:	8b 50 08             	mov    0x8(%eax),%edx
  802091:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802094:	8b 48 08             	mov    0x8(%eax),%ecx
  802097:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80209a:	8b 40 0c             	mov    0xc(%eax),%eax
  80209d:	01 c8                	add    %ecx,%eax
  80209f:	39 c2                	cmp    %eax,%edx
  8020a1:	73 04                	jae    8020a7 <print_mem_block_lists+0x114>
			sorted = 0 ;
  8020a3:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  8020a7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020aa:	8b 50 08             	mov    0x8(%eax),%edx
  8020ad:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020b0:	8b 40 0c             	mov    0xc(%eax),%eax
  8020b3:	01 c2                	add    %eax,%edx
  8020b5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020b8:	8b 40 08             	mov    0x8(%eax),%eax
  8020bb:	83 ec 04             	sub    $0x4,%esp
  8020be:	52                   	push   %edx
  8020bf:	50                   	push   %eax
  8020c0:	68 e1 39 80 00       	push   $0x8039e1
  8020c5:	e8 b9 e5 ff ff       	call   800683 <cprintf>
  8020ca:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  8020cd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020d0:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;

	lastBlk = NULL ;
	cprintf("\nAllocMemBlocksList:\n");
	sorted = 1 ;
	LIST_FOREACH(blk, &AllocMemBlocksList)
  8020d3:	a1 48 40 80 00       	mov    0x804048,%eax
  8020d8:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8020db:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8020df:	74 07                	je     8020e8 <print_mem_block_lists+0x155>
  8020e1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020e4:	8b 00                	mov    (%eax),%eax
  8020e6:	eb 05                	jmp    8020ed <print_mem_block_lists+0x15a>
  8020e8:	b8 00 00 00 00       	mov    $0x0,%eax
  8020ed:	a3 48 40 80 00       	mov    %eax,0x804048
  8020f2:	a1 48 40 80 00       	mov    0x804048,%eax
  8020f7:	85 c0                	test   %eax,%eax
  8020f9:	75 8a                	jne    802085 <print_mem_block_lists+0xf2>
  8020fb:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8020ff:	75 84                	jne    802085 <print_mem_block_lists+0xf2>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nAllocMemBlocksList is NOT SORTED!!\n") ;
  802101:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  802105:	75 10                	jne    802117 <print_mem_block_lists+0x184>
  802107:	83 ec 0c             	sub    $0xc,%esp
  80210a:	68 2c 3a 80 00       	push   $0x803a2c
  80210f:	e8 6f e5 ff ff       	call   800683 <cprintf>
  802114:	83 c4 10             	add    $0x10,%esp
	cprintf("\n=========================================\n");
  802117:	83 ec 0c             	sub    $0xc,%esp
  80211a:	68 a0 39 80 00       	push   $0x8039a0
  80211f:	e8 5f e5 ff ff       	call   800683 <cprintf>
  802124:	83 c4 10             	add    $0x10,%esp

}
  802127:	90                   	nop
  802128:	c9                   	leave  
  802129:	c3                   	ret    

0080212a <initialize_MemBlocksList>:

//===============================
// [1] INITIALIZE AVAILABLE LIST:
//===============================
void initialize_MemBlocksList(uint32 numOfBlocks)
{
  80212a:	55                   	push   %ebp
  80212b:	89 e5                	mov    %esp,%ebp
  80212d:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] initialize_MemBlocksList
	// Write your code here, remove the panic and write your code
	//panic("initialize_MemBlocksList() is not implemented yet...!!");
	uint32 n = numOfBlocks;
  802130:	8b 45 08             	mov    0x8(%ebp),%eax
  802133:	89 45 f0             	mov    %eax,-0x10(%ebp)

	LIST_INIT(&AvailableMemBlocksList);
  802136:	c7 05 48 41 80 00 00 	movl   $0x0,0x804148
  80213d:	00 00 00 
  802140:	c7 05 4c 41 80 00 00 	movl   $0x0,0x80414c
  802147:	00 00 00 
  80214a:	c7 05 54 41 80 00 00 	movl   $0x0,0x804154
  802151:	00 00 00 
	for(int i = 0; i<n;i++)
  802154:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  80215b:	e9 9e 00 00 00       	jmp    8021fe <initialize_MemBlocksList+0xd4>
	{
		LIST_INSERT_HEAD(&AvailableMemBlocksList, &(MemBlockNodes[i]));
  802160:	a1 50 40 80 00       	mov    0x804050,%eax
  802165:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802168:	c1 e2 04             	shl    $0x4,%edx
  80216b:	01 d0                	add    %edx,%eax
  80216d:	85 c0                	test   %eax,%eax
  80216f:	75 14                	jne    802185 <initialize_MemBlocksList+0x5b>
  802171:	83 ec 04             	sub    $0x4,%esp
  802174:	68 54 3a 80 00       	push   $0x803a54
  802179:	6a 47                	push   $0x47
  80217b:	68 77 3a 80 00       	push   $0x803a77
  802180:	e8 24 0e 00 00       	call   802fa9 <_panic>
  802185:	a1 50 40 80 00       	mov    0x804050,%eax
  80218a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80218d:	c1 e2 04             	shl    $0x4,%edx
  802190:	01 d0                	add    %edx,%eax
  802192:	8b 15 48 41 80 00    	mov    0x804148,%edx
  802198:	89 10                	mov    %edx,(%eax)
  80219a:	8b 00                	mov    (%eax),%eax
  80219c:	85 c0                	test   %eax,%eax
  80219e:	74 18                	je     8021b8 <initialize_MemBlocksList+0x8e>
  8021a0:	a1 48 41 80 00       	mov    0x804148,%eax
  8021a5:	8b 15 50 40 80 00    	mov    0x804050,%edx
  8021ab:	8b 4d f4             	mov    -0xc(%ebp),%ecx
  8021ae:	c1 e1 04             	shl    $0x4,%ecx
  8021b1:	01 ca                	add    %ecx,%edx
  8021b3:	89 50 04             	mov    %edx,0x4(%eax)
  8021b6:	eb 12                	jmp    8021ca <initialize_MemBlocksList+0xa0>
  8021b8:	a1 50 40 80 00       	mov    0x804050,%eax
  8021bd:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8021c0:	c1 e2 04             	shl    $0x4,%edx
  8021c3:	01 d0                	add    %edx,%eax
  8021c5:	a3 4c 41 80 00       	mov    %eax,0x80414c
  8021ca:	a1 50 40 80 00       	mov    0x804050,%eax
  8021cf:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8021d2:	c1 e2 04             	shl    $0x4,%edx
  8021d5:	01 d0                	add    %edx,%eax
  8021d7:	a3 48 41 80 00       	mov    %eax,0x804148
  8021dc:	a1 50 40 80 00       	mov    0x804050,%eax
  8021e1:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8021e4:	c1 e2 04             	shl    $0x4,%edx
  8021e7:	01 d0                	add    %edx,%eax
  8021e9:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8021f0:	a1 54 41 80 00       	mov    0x804154,%eax
  8021f5:	40                   	inc    %eax
  8021f6:	a3 54 41 80 00       	mov    %eax,0x804154
	// Write your code here, remove the panic and write your code
	//panic("initialize_MemBlocksList() is not implemented yet...!!");
	uint32 n = numOfBlocks;

	LIST_INIT(&AvailableMemBlocksList);
	for(int i = 0; i<n;i++)
  8021fb:	ff 45 f4             	incl   -0xc(%ebp)
  8021fe:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802201:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  802204:	0f 82 56 ff ff ff    	jb     802160 <initialize_MemBlocksList+0x36>
	{
		LIST_INSERT_HEAD(&AvailableMemBlocksList, &(MemBlockNodes[i]));
	}
}
  80220a:	90                   	nop
  80220b:	c9                   	leave  
  80220c:	c3                   	ret    

0080220d <find_block>:

//===============================
// [2] FIND BLOCK:
//===============================
struct MemBlock *find_block(struct MemBlock_List *blockList, uint32 va)
{
  80220d:	55                   	push   %ebp
  80220e:	89 e5                	mov    %esp,%ebp
  802210:	83 ec 10             	sub    $0x10,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] find_block
	// Write your code here, remove the panic and write your code
	//panic("find_block() is not implemented yet...!!");
	uint32 virAddress = va;
  802213:	8b 45 0c             	mov    0xc(%ebp),%eax
  802216:	89 45 f4             	mov    %eax,-0xc(%ebp)
	struct MemBlock* blk;
	int found = 0;
  802219:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	LIST_FOREACH(blk, &(AllocMemBlocksList))
  802220:	a1 40 40 80 00       	mov    0x804040,%eax
  802225:	89 45 fc             	mov    %eax,-0x4(%ebp)
  802228:	eb 23                	jmp    80224d <find_block+0x40>
	{
		if(blk->sva == virAddress)
  80222a:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80222d:	8b 40 08             	mov    0x8(%eax),%eax
  802230:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  802233:	75 09                	jne    80223e <find_block+0x31>
		{
			found = 1;
  802235:	c7 45 f8 01 00 00 00 	movl   $0x1,-0x8(%ebp)
			break;
  80223c:	eb 35                	jmp    802273 <find_block+0x66>
		}
		else
		{
			found = 0;
  80223e:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	//panic("find_block() is not implemented yet...!!");
	uint32 virAddress = va;
	struct MemBlock* blk;
	int found = 0;

	LIST_FOREACH(blk, &(AllocMemBlocksList))
  802245:	a1 48 40 80 00       	mov    0x804048,%eax
  80224a:	89 45 fc             	mov    %eax,-0x4(%ebp)
  80224d:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  802251:	74 07                	je     80225a <find_block+0x4d>
  802253:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802256:	8b 00                	mov    (%eax),%eax
  802258:	eb 05                	jmp    80225f <find_block+0x52>
  80225a:	b8 00 00 00 00       	mov    $0x0,%eax
  80225f:	a3 48 40 80 00       	mov    %eax,0x804048
  802264:	a1 48 40 80 00       	mov    0x804048,%eax
  802269:	85 c0                	test   %eax,%eax
  80226b:	75 bd                	jne    80222a <find_block+0x1d>
  80226d:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  802271:	75 b7                	jne    80222a <find_block+0x1d>
		{
			found = 0;
			continue;
		}
	}
	if(found == 1)
  802273:	83 7d f8 01          	cmpl   $0x1,-0x8(%ebp)
  802277:	75 05                	jne    80227e <find_block+0x71>
	{
		return blk;
  802279:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80227c:	eb 05                	jmp    802283 <find_block+0x76>
	}
	else
	{
		return NULL;
  80227e:	b8 00 00 00 00       	mov    $0x0,%eax
	}
}
  802283:	c9                   	leave  
  802284:	c3                   	ret    

00802285 <insert_sorted_allocList>:

//=========================================
// [3] INSERT BLOCK IN ALLOC LIST [SORTED]:
//=========================================
void insert_sorted_allocList(struct MemBlock *blockToInsert)
{
  802285:	55                   	push   %ebp
  802286:	89 e5                	mov    %esp,%ebp
  802288:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] insert_sorted_allocList
	// Write your code here, remove the panic and write your code
	//panic("insert_sorted_allocList() is not implemented yet...!!");
	struct MemBlock* blk;
	struct MemBlock* newblk = blockToInsert;
  80228b:	8b 45 08             	mov    0x8(%ebp),%eax
  80228e:	89 45 f0             	mov    %eax,-0x10(%ebp)

	if((LIST_EMPTY(&AllocMemBlocksList)) || (newblk->sva < LIST_FIRST(&AllocMemBlocksList)->sva))
  802291:	a1 40 40 80 00       	mov    0x804040,%eax
  802296:	85 c0                	test   %eax,%eax
  802298:	74 12                	je     8022ac <insert_sorted_allocList+0x27>
  80229a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80229d:	8b 50 08             	mov    0x8(%eax),%edx
  8022a0:	a1 40 40 80 00       	mov    0x804040,%eax
  8022a5:	8b 40 08             	mov    0x8(%eax),%eax
  8022a8:	39 c2                	cmp    %eax,%edx
  8022aa:	73 65                	jae    802311 <insert_sorted_allocList+0x8c>
	{
		LIST_INSERT_HEAD(&(AllocMemBlocksList), newblk);
  8022ac:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8022b0:	75 14                	jne    8022c6 <insert_sorted_allocList+0x41>
  8022b2:	83 ec 04             	sub    $0x4,%esp
  8022b5:	68 54 3a 80 00       	push   $0x803a54
  8022ba:	6a 7b                	push   $0x7b
  8022bc:	68 77 3a 80 00       	push   $0x803a77
  8022c1:	e8 e3 0c 00 00       	call   802fa9 <_panic>
  8022c6:	8b 15 40 40 80 00    	mov    0x804040,%edx
  8022cc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8022cf:	89 10                	mov    %edx,(%eax)
  8022d1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8022d4:	8b 00                	mov    (%eax),%eax
  8022d6:	85 c0                	test   %eax,%eax
  8022d8:	74 0d                	je     8022e7 <insert_sorted_allocList+0x62>
  8022da:	a1 40 40 80 00       	mov    0x804040,%eax
  8022df:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8022e2:	89 50 04             	mov    %edx,0x4(%eax)
  8022e5:	eb 08                	jmp    8022ef <insert_sorted_allocList+0x6a>
  8022e7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8022ea:	a3 44 40 80 00       	mov    %eax,0x804044
  8022ef:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8022f2:	a3 40 40 80 00       	mov    %eax,0x804040
  8022f7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8022fa:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802301:	a1 4c 40 80 00       	mov    0x80404c,%eax
  802306:	40                   	inc    %eax
  802307:	a3 4c 40 80 00       	mov    %eax,0x80404c
  80230c:	e9 5f 01 00 00       	jmp    802470 <insert_sorted_allocList+0x1eb>
	}
	else if(newblk->sva > LIST_LAST(&AllocMemBlocksList)->sva)
  802311:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802314:	8b 50 08             	mov    0x8(%eax),%edx
  802317:	a1 44 40 80 00       	mov    0x804044,%eax
  80231c:	8b 40 08             	mov    0x8(%eax),%eax
  80231f:	39 c2                	cmp    %eax,%edx
  802321:	76 65                	jbe    802388 <insert_sorted_allocList+0x103>
	{
		LIST_INSERT_TAIL(&AllocMemBlocksList, newblk);
  802323:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802327:	75 14                	jne    80233d <insert_sorted_allocList+0xb8>
  802329:	83 ec 04             	sub    $0x4,%esp
  80232c:	68 90 3a 80 00       	push   $0x803a90
  802331:	6a 7f                	push   $0x7f
  802333:	68 77 3a 80 00       	push   $0x803a77
  802338:	e8 6c 0c 00 00       	call   802fa9 <_panic>
  80233d:	8b 15 44 40 80 00    	mov    0x804044,%edx
  802343:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802346:	89 50 04             	mov    %edx,0x4(%eax)
  802349:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80234c:	8b 40 04             	mov    0x4(%eax),%eax
  80234f:	85 c0                	test   %eax,%eax
  802351:	74 0c                	je     80235f <insert_sorted_allocList+0xda>
  802353:	a1 44 40 80 00       	mov    0x804044,%eax
  802358:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80235b:	89 10                	mov    %edx,(%eax)
  80235d:	eb 08                	jmp    802367 <insert_sorted_allocList+0xe2>
  80235f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802362:	a3 40 40 80 00       	mov    %eax,0x804040
  802367:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80236a:	a3 44 40 80 00       	mov    %eax,0x804044
  80236f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802372:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802378:	a1 4c 40 80 00       	mov    0x80404c,%eax
  80237d:	40                   	inc    %eax
  80237e:	a3 4c 40 80 00       	mov    %eax,0x80404c
				LIST_INSERT_AFTER(&AllocMemBlocksList, blk, newblk);
				break;
			}
		}
	}
}
  802383:	e9 e8 00 00 00       	jmp    802470 <insert_sorted_allocList+0x1eb>
	{
		LIST_INSERT_TAIL(&AllocMemBlocksList, newblk);
	}
	else
	{
		LIST_FOREACH(blk, &AllocMemBlocksList)
  802388:	a1 40 40 80 00       	mov    0x804040,%eax
  80238d:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802390:	e9 ab 00 00 00       	jmp    802440 <insert_sorted_allocList+0x1bb>
		{
			if(blk->prev_next_info.le_next != NULL && newblk->sva > blk->sva  && newblk->sva < blk->prev_next_info.le_next->sva)
  802395:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802398:	8b 00                	mov    (%eax),%eax
  80239a:	85 c0                	test   %eax,%eax
  80239c:	0f 84 96 00 00 00    	je     802438 <insert_sorted_allocList+0x1b3>
  8023a2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8023a5:	8b 50 08             	mov    0x8(%eax),%edx
  8023a8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023ab:	8b 40 08             	mov    0x8(%eax),%eax
  8023ae:	39 c2                	cmp    %eax,%edx
  8023b0:	0f 86 82 00 00 00    	jbe    802438 <insert_sorted_allocList+0x1b3>
  8023b6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8023b9:	8b 50 08             	mov    0x8(%eax),%edx
  8023bc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023bf:	8b 00                	mov    (%eax),%eax
  8023c1:	8b 40 08             	mov    0x8(%eax),%eax
  8023c4:	39 c2                	cmp    %eax,%edx
  8023c6:	73 70                	jae    802438 <insert_sorted_allocList+0x1b3>
			{
				LIST_INSERT_AFTER(&AllocMemBlocksList, blk, newblk);
  8023c8:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8023cc:	74 06                	je     8023d4 <insert_sorted_allocList+0x14f>
  8023ce:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8023d2:	75 17                	jne    8023eb <insert_sorted_allocList+0x166>
  8023d4:	83 ec 04             	sub    $0x4,%esp
  8023d7:	68 b4 3a 80 00       	push   $0x803ab4
  8023dc:	68 87 00 00 00       	push   $0x87
  8023e1:	68 77 3a 80 00       	push   $0x803a77
  8023e6:	e8 be 0b 00 00       	call   802fa9 <_panic>
  8023eb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023ee:	8b 10                	mov    (%eax),%edx
  8023f0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8023f3:	89 10                	mov    %edx,(%eax)
  8023f5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8023f8:	8b 00                	mov    (%eax),%eax
  8023fa:	85 c0                	test   %eax,%eax
  8023fc:	74 0b                	je     802409 <insert_sorted_allocList+0x184>
  8023fe:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802401:	8b 00                	mov    (%eax),%eax
  802403:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802406:	89 50 04             	mov    %edx,0x4(%eax)
  802409:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80240c:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80240f:	89 10                	mov    %edx,(%eax)
  802411:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802414:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802417:	89 50 04             	mov    %edx,0x4(%eax)
  80241a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80241d:	8b 00                	mov    (%eax),%eax
  80241f:	85 c0                	test   %eax,%eax
  802421:	75 08                	jne    80242b <insert_sorted_allocList+0x1a6>
  802423:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802426:	a3 44 40 80 00       	mov    %eax,0x804044
  80242b:	a1 4c 40 80 00       	mov    0x80404c,%eax
  802430:	40                   	inc    %eax
  802431:	a3 4c 40 80 00       	mov    %eax,0x80404c
				break;
  802436:	eb 38                	jmp    802470 <insert_sorted_allocList+0x1eb>
	{
		LIST_INSERT_TAIL(&AllocMemBlocksList, newblk);
	}
	else
	{
		LIST_FOREACH(blk, &AllocMemBlocksList)
  802438:	a1 48 40 80 00       	mov    0x804048,%eax
  80243d:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802440:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802444:	74 07                	je     80244d <insert_sorted_allocList+0x1c8>
  802446:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802449:	8b 00                	mov    (%eax),%eax
  80244b:	eb 05                	jmp    802452 <insert_sorted_allocList+0x1cd>
  80244d:	b8 00 00 00 00       	mov    $0x0,%eax
  802452:	a3 48 40 80 00       	mov    %eax,0x804048
  802457:	a1 48 40 80 00       	mov    0x804048,%eax
  80245c:	85 c0                	test   %eax,%eax
  80245e:	0f 85 31 ff ff ff    	jne    802395 <insert_sorted_allocList+0x110>
  802464:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802468:	0f 85 27 ff ff ff    	jne    802395 <insert_sorted_allocList+0x110>
				LIST_INSERT_AFTER(&AllocMemBlocksList, blk, newblk);
				break;
			}
		}
	}
}
  80246e:	eb 00                	jmp    802470 <insert_sorted_allocList+0x1eb>
  802470:	90                   	nop
  802471:	c9                   	leave  
  802472:	c3                   	ret    

00802473 <alloc_block_FF>:

//=========================================
// [4] ALLOCATE BLOCK BY FIRST FIT:
//=========================================
struct MemBlock *alloc_block_FF(uint32 size)
{
  802473:	55                   	push   %ebp
  802474:	89 e5                	mov    %esp,%ebp
  802476:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_FF
	// Write your code here, remove the panic and write your code
	//panic("alloc_block_FF() is not implemented yet...!!");
	uint32 versize = size;
  802479:	8b 45 08             	mov    0x8(%ebp),%eax
  80247c:	89 45 f0             	mov    %eax,-0x10(%ebp)
	struct MemBlock* blk;
	struct MemBlock* newblk = LIST_FIRST(&AvailableMemBlocksList);
  80247f:	a1 48 41 80 00       	mov    0x804148,%eax
  802484:	89 45 ec             	mov    %eax,-0x14(%ebp)

	LIST_FOREACH(blk,&FreeMemBlocksList)
  802487:	a1 38 41 80 00       	mov    0x804138,%eax
  80248c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80248f:	e9 77 01 00 00       	jmp    80260b <alloc_block_FF+0x198>
	{
		if(blk->size == versize)
  802494:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802497:	8b 40 0c             	mov    0xc(%eax),%eax
  80249a:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80249d:	0f 85 8a 00 00 00    	jne    80252d <alloc_block_FF+0xba>
		{
			LIST_REMOVE(&FreeMemBlocksList,blk);
  8024a3:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8024a7:	75 17                	jne    8024c0 <alloc_block_FF+0x4d>
  8024a9:	83 ec 04             	sub    $0x4,%esp
  8024ac:	68 e8 3a 80 00       	push   $0x803ae8
  8024b1:	68 9e 00 00 00       	push   $0x9e
  8024b6:	68 77 3a 80 00       	push   $0x803a77
  8024bb:	e8 e9 0a 00 00       	call   802fa9 <_panic>
  8024c0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024c3:	8b 00                	mov    (%eax),%eax
  8024c5:	85 c0                	test   %eax,%eax
  8024c7:	74 10                	je     8024d9 <alloc_block_FF+0x66>
  8024c9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024cc:	8b 00                	mov    (%eax),%eax
  8024ce:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8024d1:	8b 52 04             	mov    0x4(%edx),%edx
  8024d4:	89 50 04             	mov    %edx,0x4(%eax)
  8024d7:	eb 0b                	jmp    8024e4 <alloc_block_FF+0x71>
  8024d9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024dc:	8b 40 04             	mov    0x4(%eax),%eax
  8024df:	a3 3c 41 80 00       	mov    %eax,0x80413c
  8024e4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024e7:	8b 40 04             	mov    0x4(%eax),%eax
  8024ea:	85 c0                	test   %eax,%eax
  8024ec:	74 0f                	je     8024fd <alloc_block_FF+0x8a>
  8024ee:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024f1:	8b 40 04             	mov    0x4(%eax),%eax
  8024f4:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8024f7:	8b 12                	mov    (%edx),%edx
  8024f9:	89 10                	mov    %edx,(%eax)
  8024fb:	eb 0a                	jmp    802507 <alloc_block_FF+0x94>
  8024fd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802500:	8b 00                	mov    (%eax),%eax
  802502:	a3 38 41 80 00       	mov    %eax,0x804138
  802507:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80250a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802510:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802513:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80251a:	a1 44 41 80 00       	mov    0x804144,%eax
  80251f:	48                   	dec    %eax
  802520:	a3 44 41 80 00       	mov    %eax,0x804144
			return blk;
  802525:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802528:	e9 11 01 00 00       	jmp    80263e <alloc_block_FF+0x1cb>
		}
		else if(blk->size > versize)
  80252d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802530:	8b 40 0c             	mov    0xc(%eax),%eax
  802533:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  802536:	0f 86 c7 00 00 00    	jbe    802603 <alloc_block_FF+0x190>
		{
			LIST_REMOVE(&AvailableMemBlocksList,newblk);
  80253c:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802540:	75 17                	jne    802559 <alloc_block_FF+0xe6>
  802542:	83 ec 04             	sub    $0x4,%esp
  802545:	68 e8 3a 80 00       	push   $0x803ae8
  80254a:	68 a3 00 00 00       	push   $0xa3
  80254f:	68 77 3a 80 00       	push   $0x803a77
  802554:	e8 50 0a 00 00       	call   802fa9 <_panic>
  802559:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80255c:	8b 00                	mov    (%eax),%eax
  80255e:	85 c0                	test   %eax,%eax
  802560:	74 10                	je     802572 <alloc_block_FF+0xff>
  802562:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802565:	8b 00                	mov    (%eax),%eax
  802567:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80256a:	8b 52 04             	mov    0x4(%edx),%edx
  80256d:	89 50 04             	mov    %edx,0x4(%eax)
  802570:	eb 0b                	jmp    80257d <alloc_block_FF+0x10a>
  802572:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802575:	8b 40 04             	mov    0x4(%eax),%eax
  802578:	a3 4c 41 80 00       	mov    %eax,0x80414c
  80257d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802580:	8b 40 04             	mov    0x4(%eax),%eax
  802583:	85 c0                	test   %eax,%eax
  802585:	74 0f                	je     802596 <alloc_block_FF+0x123>
  802587:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80258a:	8b 40 04             	mov    0x4(%eax),%eax
  80258d:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802590:	8b 12                	mov    (%edx),%edx
  802592:	89 10                	mov    %edx,(%eax)
  802594:	eb 0a                	jmp    8025a0 <alloc_block_FF+0x12d>
  802596:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802599:	8b 00                	mov    (%eax),%eax
  80259b:	a3 48 41 80 00       	mov    %eax,0x804148
  8025a0:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8025a3:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8025a9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8025ac:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8025b3:	a1 54 41 80 00       	mov    0x804154,%eax
  8025b8:	48                   	dec    %eax
  8025b9:	a3 54 41 80 00       	mov    %eax,0x804154
			newblk->size = versize;
  8025be:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8025c1:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8025c4:	89 50 0c             	mov    %edx,0xc(%eax)
			blk->size = blk->size-versize;
  8025c7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025ca:	8b 40 0c             	mov    0xc(%eax),%eax
  8025cd:	2b 45 f0             	sub    -0x10(%ebp),%eax
  8025d0:	89 c2                	mov    %eax,%edx
  8025d2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025d5:	89 50 0c             	mov    %edx,0xc(%eax)
			uint32 newveradd = blk->sva;
  8025d8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025db:	8b 40 08             	mov    0x8(%eax),%eax
  8025de:	89 45 e8             	mov    %eax,-0x18(%ebp)
			blk->sva+=newblk->size;
  8025e1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025e4:	8b 50 08             	mov    0x8(%eax),%edx
  8025e7:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8025ea:	8b 40 0c             	mov    0xc(%eax),%eax
  8025ed:	01 c2                	add    %eax,%edx
  8025ef:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025f2:	89 50 08             	mov    %edx,0x8(%eax)
			newblk->sva = newveradd;
  8025f5:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8025f8:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8025fb:	89 50 08             	mov    %edx,0x8(%eax)
			return newblk;
  8025fe:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802601:	eb 3b                	jmp    80263e <alloc_block_FF+0x1cb>
	//panic("alloc_block_FF() is not implemented yet...!!");
	uint32 versize = size;
	struct MemBlock* blk;
	struct MemBlock* newblk = LIST_FIRST(&AvailableMemBlocksList);

	LIST_FOREACH(blk,&FreeMemBlocksList)
  802603:	a1 40 41 80 00       	mov    0x804140,%eax
  802608:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80260b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80260f:	74 07                	je     802618 <alloc_block_FF+0x1a5>
  802611:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802614:	8b 00                	mov    (%eax),%eax
  802616:	eb 05                	jmp    80261d <alloc_block_FF+0x1aa>
  802618:	b8 00 00 00 00       	mov    $0x0,%eax
  80261d:	a3 40 41 80 00       	mov    %eax,0x804140
  802622:	a1 40 41 80 00       	mov    0x804140,%eax
  802627:	85 c0                	test   %eax,%eax
  802629:	0f 85 65 fe ff ff    	jne    802494 <alloc_block_FF+0x21>
  80262f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802633:	0f 85 5b fe ff ff    	jne    802494 <alloc_block_FF+0x21>
			blk->sva+=newblk->size;
			newblk->sva = newveradd;
			return newblk;
		}
	}
	return NULL;
  802639:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80263e:	c9                   	leave  
  80263f:	c3                   	ret    

00802640 <alloc_block_BF>:

//=========================================
// [5] ALLOCATE BLOCK BY BEST FIT:
//=========================================
struct MemBlock *alloc_block_BF(uint32 size)
{
  802640:	55                   	push   %ebp
  802641:	89 e5                	mov    %esp,%ebp
  802643:	83 ec 28             	sub    $0x28,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_BF
	// Write your code here, remove the panic and write your code
	//panic("alloc_block_BF() is not implemented yet...!!");
	uint32 versize=size;
  802646:	8b 45 08             	mov    0x8(%ebp),%eax
  802649:	89 45 e8             	mov    %eax,-0x18(%ebp)
	struct MemBlock* blk;
	struct MemBlock* newblk=LIST_FIRST(&AvailableMemBlocksList);
  80264c:	a1 48 41 80 00       	mov    0x804148,%eax
  802651:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	uint32 newveradd;
	uint32 newsize;
	int size_free = LIST_SIZE(&FreeMemBlocksList);
  802654:	a1 44 41 80 00       	mov    0x804144,%eax
  802659:	89 45 e0             	mov    %eax,-0x20(%ebp)

	LIST_FOREACH(blk, &FreeMemBlocksList)
  80265c:	a1 38 41 80 00       	mov    0x804138,%eax
  802661:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802664:	e9 a1 00 00 00       	jmp    80270a <alloc_block_BF+0xca>
	{
		if(blk->size == versize)
  802669:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80266c:	8b 40 0c             	mov    0xc(%eax),%eax
  80266f:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  802672:	0f 85 8a 00 00 00    	jne    802702 <alloc_block_BF+0xc2>
		{
			LIST_REMOVE(&FreeMemBlocksList, blk);
  802678:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80267c:	75 17                	jne    802695 <alloc_block_BF+0x55>
  80267e:	83 ec 04             	sub    $0x4,%esp
  802681:	68 e8 3a 80 00       	push   $0x803ae8
  802686:	68 c2 00 00 00       	push   $0xc2
  80268b:	68 77 3a 80 00       	push   $0x803a77
  802690:	e8 14 09 00 00       	call   802fa9 <_panic>
  802695:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802698:	8b 00                	mov    (%eax),%eax
  80269a:	85 c0                	test   %eax,%eax
  80269c:	74 10                	je     8026ae <alloc_block_BF+0x6e>
  80269e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026a1:	8b 00                	mov    (%eax),%eax
  8026a3:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8026a6:	8b 52 04             	mov    0x4(%edx),%edx
  8026a9:	89 50 04             	mov    %edx,0x4(%eax)
  8026ac:	eb 0b                	jmp    8026b9 <alloc_block_BF+0x79>
  8026ae:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026b1:	8b 40 04             	mov    0x4(%eax),%eax
  8026b4:	a3 3c 41 80 00       	mov    %eax,0x80413c
  8026b9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026bc:	8b 40 04             	mov    0x4(%eax),%eax
  8026bf:	85 c0                	test   %eax,%eax
  8026c1:	74 0f                	je     8026d2 <alloc_block_BF+0x92>
  8026c3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026c6:	8b 40 04             	mov    0x4(%eax),%eax
  8026c9:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8026cc:	8b 12                	mov    (%edx),%edx
  8026ce:	89 10                	mov    %edx,(%eax)
  8026d0:	eb 0a                	jmp    8026dc <alloc_block_BF+0x9c>
  8026d2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026d5:	8b 00                	mov    (%eax),%eax
  8026d7:	a3 38 41 80 00       	mov    %eax,0x804138
  8026dc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026df:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8026e5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026e8:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8026ef:	a1 44 41 80 00       	mov    0x804144,%eax
  8026f4:	48                   	dec    %eax
  8026f5:	a3 44 41 80 00       	mov    %eax,0x804144
			return blk;
  8026fa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026fd:	e9 11 02 00 00       	jmp    802913 <alloc_block_BF+0x2d3>
	struct MemBlock* newblk=LIST_FIRST(&AvailableMemBlocksList);
	uint32 newveradd;
	uint32 newsize;
	int size_free = LIST_SIZE(&FreeMemBlocksList);

	LIST_FOREACH(blk, &FreeMemBlocksList)
  802702:	a1 40 41 80 00       	mov    0x804140,%eax
  802707:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80270a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80270e:	74 07                	je     802717 <alloc_block_BF+0xd7>
  802710:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802713:	8b 00                	mov    (%eax),%eax
  802715:	eb 05                	jmp    80271c <alloc_block_BF+0xdc>
  802717:	b8 00 00 00 00       	mov    $0x0,%eax
  80271c:	a3 40 41 80 00       	mov    %eax,0x804140
  802721:	a1 40 41 80 00       	mov    0x804140,%eax
  802726:	85 c0                	test   %eax,%eax
  802728:	0f 85 3b ff ff ff    	jne    802669 <alloc_block_BF+0x29>
  80272e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802732:	0f 85 31 ff ff ff    	jne    802669 <alloc_block_BF+0x29>
		{
			LIST_REMOVE(&FreeMemBlocksList, blk);
			return blk;
		}
	}
	LIST_FOREACH(blk, &FreeMemBlocksList)
  802738:	a1 38 41 80 00       	mov    0x804138,%eax
  80273d:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802740:	eb 27                	jmp    802769 <alloc_block_BF+0x129>
	{
		if(blk->size > versize)
  802742:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802745:	8b 40 0c             	mov    0xc(%eax),%eax
  802748:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  80274b:	76 14                	jbe    802761 <alloc_block_BF+0x121>
		{
			newsize = blk->size;
  80274d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802750:	8b 40 0c             	mov    0xc(%eax),%eax
  802753:	89 45 ec             	mov    %eax,-0x14(%ebp)
			newveradd = blk->sva;
  802756:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802759:	8b 40 08             	mov    0x8(%eax),%eax
  80275c:	89 45 f0             	mov    %eax,-0x10(%ebp)
			break;
  80275f:	eb 2e                	jmp    80278f <alloc_block_BF+0x14f>
		{
			LIST_REMOVE(&FreeMemBlocksList, blk);
			return blk;
		}
	}
	LIST_FOREACH(blk, &FreeMemBlocksList)
  802761:	a1 40 41 80 00       	mov    0x804140,%eax
  802766:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802769:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80276d:	74 07                	je     802776 <alloc_block_BF+0x136>
  80276f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802772:	8b 00                	mov    (%eax),%eax
  802774:	eb 05                	jmp    80277b <alloc_block_BF+0x13b>
  802776:	b8 00 00 00 00       	mov    $0x0,%eax
  80277b:	a3 40 41 80 00       	mov    %eax,0x804140
  802780:	a1 40 41 80 00       	mov    0x804140,%eax
  802785:	85 c0                	test   %eax,%eax
  802787:	75 b9                	jne    802742 <alloc_block_BF+0x102>
  802789:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80278d:	75 b3                	jne    802742 <alloc_block_BF+0x102>
			newsize = blk->size;
			newveradd = blk->sva;
			break;
		}
	}
	LIST_FOREACH(blk, &FreeMemBlocksList)
  80278f:	a1 38 41 80 00       	mov    0x804138,%eax
  802794:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802797:	eb 30                	jmp    8027c9 <alloc_block_BF+0x189>
	{
		if(newsize > blk->size && blk->size > versize)
  802799:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80279c:	8b 40 0c             	mov    0xc(%eax),%eax
  80279f:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  8027a2:	73 1d                	jae    8027c1 <alloc_block_BF+0x181>
  8027a4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027a7:	8b 40 0c             	mov    0xc(%eax),%eax
  8027aa:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  8027ad:	76 12                	jbe    8027c1 <alloc_block_BF+0x181>
		{
	       newsize = blk->size;
  8027af:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027b2:	8b 40 0c             	mov    0xc(%eax),%eax
  8027b5:	89 45 ec             	mov    %eax,-0x14(%ebp)
		   newveradd = blk->sva;
  8027b8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027bb:	8b 40 08             	mov    0x8(%eax),%eax
  8027be:	89 45 f0             	mov    %eax,-0x10(%ebp)
			newsize = blk->size;
			newveradd = blk->sva;
			break;
		}
	}
	LIST_FOREACH(blk, &FreeMemBlocksList)
  8027c1:	a1 40 41 80 00       	mov    0x804140,%eax
  8027c6:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8027c9:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8027cd:	74 07                	je     8027d6 <alloc_block_BF+0x196>
  8027cf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027d2:	8b 00                	mov    (%eax),%eax
  8027d4:	eb 05                	jmp    8027db <alloc_block_BF+0x19b>
  8027d6:	b8 00 00 00 00       	mov    $0x0,%eax
  8027db:	a3 40 41 80 00       	mov    %eax,0x804140
  8027e0:	a1 40 41 80 00       	mov    0x804140,%eax
  8027e5:	85 c0                	test   %eax,%eax
  8027e7:	75 b0                	jne    802799 <alloc_block_BF+0x159>
  8027e9:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8027ed:	75 aa                	jne    802799 <alloc_block_BF+0x159>
		{
	       newsize = blk->size;
		   newveradd = blk->sva;
		}
	}
	LIST_FOREACH(blk, &FreeMemBlocksList)
  8027ef:	a1 38 41 80 00       	mov    0x804138,%eax
  8027f4:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8027f7:	e9 e4 00 00 00       	jmp    8028e0 <alloc_block_BF+0x2a0>
	{
		if(blk->size == newsize && blk->sva == newveradd)
  8027fc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027ff:	8b 40 0c             	mov    0xc(%eax),%eax
  802802:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  802805:	0f 85 cd 00 00 00    	jne    8028d8 <alloc_block_BF+0x298>
  80280b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80280e:	8b 40 08             	mov    0x8(%eax),%eax
  802811:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  802814:	0f 85 be 00 00 00    	jne    8028d8 <alloc_block_BF+0x298>
		{
			LIST_REMOVE(&AvailableMemBlocksList, newblk);
  80281a:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80281e:	75 17                	jne    802837 <alloc_block_BF+0x1f7>
  802820:	83 ec 04             	sub    $0x4,%esp
  802823:	68 e8 3a 80 00       	push   $0x803ae8
  802828:	68 db 00 00 00       	push   $0xdb
  80282d:	68 77 3a 80 00       	push   $0x803a77
  802832:	e8 72 07 00 00       	call   802fa9 <_panic>
  802837:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80283a:	8b 00                	mov    (%eax),%eax
  80283c:	85 c0                	test   %eax,%eax
  80283e:	74 10                	je     802850 <alloc_block_BF+0x210>
  802840:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802843:	8b 00                	mov    (%eax),%eax
  802845:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802848:	8b 52 04             	mov    0x4(%edx),%edx
  80284b:	89 50 04             	mov    %edx,0x4(%eax)
  80284e:	eb 0b                	jmp    80285b <alloc_block_BF+0x21b>
  802850:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802853:	8b 40 04             	mov    0x4(%eax),%eax
  802856:	a3 4c 41 80 00       	mov    %eax,0x80414c
  80285b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80285e:	8b 40 04             	mov    0x4(%eax),%eax
  802861:	85 c0                	test   %eax,%eax
  802863:	74 0f                	je     802874 <alloc_block_BF+0x234>
  802865:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802868:	8b 40 04             	mov    0x4(%eax),%eax
  80286b:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80286e:	8b 12                	mov    (%edx),%edx
  802870:	89 10                	mov    %edx,(%eax)
  802872:	eb 0a                	jmp    80287e <alloc_block_BF+0x23e>
  802874:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802877:	8b 00                	mov    (%eax),%eax
  802879:	a3 48 41 80 00       	mov    %eax,0x804148
  80287e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802881:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802887:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80288a:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802891:	a1 54 41 80 00       	mov    0x804154,%eax
  802896:	48                   	dec    %eax
  802897:	a3 54 41 80 00       	mov    %eax,0x804154
			newblk->size = versize;
  80289c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80289f:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8028a2:	89 50 0c             	mov    %edx,0xc(%eax)
			newblk->sva = newveradd;
  8028a5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8028a8:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8028ab:	89 50 08             	mov    %edx,0x8(%eax)
			blk->size = blk->size - versize;
  8028ae:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028b1:	8b 40 0c             	mov    0xc(%eax),%eax
  8028b4:	2b 45 e8             	sub    -0x18(%ebp),%eax
  8028b7:	89 c2                	mov    %eax,%edx
  8028b9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028bc:	89 50 0c             	mov    %edx,0xc(%eax)
			blk->sva+= newblk->size;
  8028bf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028c2:	8b 50 08             	mov    0x8(%eax),%edx
  8028c5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8028c8:	8b 40 0c             	mov    0xc(%eax),%eax
  8028cb:	01 c2                	add    %eax,%edx
  8028cd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028d0:	89 50 08             	mov    %edx,0x8(%eax)
			return newblk;
  8028d3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8028d6:	eb 3b                	jmp    802913 <alloc_block_BF+0x2d3>
		{
	       newsize = blk->size;
		   newveradd = blk->sva;
		}
	}
	LIST_FOREACH(blk, &FreeMemBlocksList)
  8028d8:	a1 40 41 80 00       	mov    0x804140,%eax
  8028dd:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8028e0:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8028e4:	74 07                	je     8028ed <alloc_block_BF+0x2ad>
  8028e6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028e9:	8b 00                	mov    (%eax),%eax
  8028eb:	eb 05                	jmp    8028f2 <alloc_block_BF+0x2b2>
  8028ed:	b8 00 00 00 00       	mov    $0x0,%eax
  8028f2:	a3 40 41 80 00       	mov    %eax,0x804140
  8028f7:	a1 40 41 80 00       	mov    0x804140,%eax
  8028fc:	85 c0                	test   %eax,%eax
  8028fe:	0f 85 f8 fe ff ff    	jne    8027fc <alloc_block_BF+0x1bc>
  802904:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802908:	0f 85 ee fe ff ff    	jne    8027fc <alloc_block_BF+0x1bc>
			blk->size = blk->size - versize;
			blk->sva+= newblk->size;
			return newblk;
		}
	}
	return NULL;
  80290e:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802913:	c9                   	leave  
  802914:	c3                   	ret    

00802915 <alloc_block_NF>:
//=========================================
// [7] ALLOCATE BLOCK BY NEXT FIT:
//=========================================
struct MemBlock *last_allocate;
struct MemBlock *alloc_block_NF(uint32 size)
{
  802915:	55                   	push   %ebp
  802916:	89 e5                	mov    %esp,%ebp
  802918:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1 - BONUS] [DYNAMIC ALLOCATOR] alloc_block_NF
	// Write your code here, remove the panic and write your code
	//panic("alloc_block_NF() is not implemented yet...!!");
	uint32 versize = size;
  80291b:	8b 45 08             	mov    0x8(%ebp),%eax
  80291e:	89 45 f0             	mov    %eax,-0x10(%ebp)
	struct MemBlock* blk;
	struct MemBlock* newblk = LIST_FIRST(&AvailableMemBlocksList);
  802921:	a1 48 41 80 00       	mov    0x804148,%eax
  802926:	89 45 ec             	mov    %eax,-0x14(%ebp)

	LIST_FOREACH(blk,&FreeMemBlocksList)
  802929:	a1 38 41 80 00       	mov    0x804138,%eax
  80292e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802931:	e9 77 01 00 00       	jmp    802aad <alloc_block_NF+0x198>
	{
		if(blk->size == versize)
  802936:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802939:	8b 40 0c             	mov    0xc(%eax),%eax
  80293c:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80293f:	0f 85 8a 00 00 00    	jne    8029cf <alloc_block_NF+0xba>
		{
			LIST_REMOVE(&FreeMemBlocksList,blk);
  802945:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802949:	75 17                	jne    802962 <alloc_block_NF+0x4d>
  80294b:	83 ec 04             	sub    $0x4,%esp
  80294e:	68 e8 3a 80 00       	push   $0x803ae8
  802953:	68 f7 00 00 00       	push   $0xf7
  802958:	68 77 3a 80 00       	push   $0x803a77
  80295d:	e8 47 06 00 00       	call   802fa9 <_panic>
  802962:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802965:	8b 00                	mov    (%eax),%eax
  802967:	85 c0                	test   %eax,%eax
  802969:	74 10                	je     80297b <alloc_block_NF+0x66>
  80296b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80296e:	8b 00                	mov    (%eax),%eax
  802970:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802973:	8b 52 04             	mov    0x4(%edx),%edx
  802976:	89 50 04             	mov    %edx,0x4(%eax)
  802979:	eb 0b                	jmp    802986 <alloc_block_NF+0x71>
  80297b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80297e:	8b 40 04             	mov    0x4(%eax),%eax
  802981:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802986:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802989:	8b 40 04             	mov    0x4(%eax),%eax
  80298c:	85 c0                	test   %eax,%eax
  80298e:	74 0f                	je     80299f <alloc_block_NF+0x8a>
  802990:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802993:	8b 40 04             	mov    0x4(%eax),%eax
  802996:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802999:	8b 12                	mov    (%edx),%edx
  80299b:	89 10                	mov    %edx,(%eax)
  80299d:	eb 0a                	jmp    8029a9 <alloc_block_NF+0x94>
  80299f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029a2:	8b 00                	mov    (%eax),%eax
  8029a4:	a3 38 41 80 00       	mov    %eax,0x804138
  8029a9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029ac:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8029b2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029b5:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8029bc:	a1 44 41 80 00       	mov    0x804144,%eax
  8029c1:	48                   	dec    %eax
  8029c2:	a3 44 41 80 00       	mov    %eax,0x804144
			return blk;
  8029c7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029ca:	e9 11 01 00 00       	jmp    802ae0 <alloc_block_NF+0x1cb>
		}
		else if(blk->size > versize)
  8029cf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029d2:	8b 40 0c             	mov    0xc(%eax),%eax
  8029d5:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8029d8:	0f 86 c7 00 00 00    	jbe    802aa5 <alloc_block_NF+0x190>
		{
			LIST_REMOVE(&AvailableMemBlocksList,newblk);
  8029de:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8029e2:	75 17                	jne    8029fb <alloc_block_NF+0xe6>
  8029e4:	83 ec 04             	sub    $0x4,%esp
  8029e7:	68 e8 3a 80 00       	push   $0x803ae8
  8029ec:	68 fc 00 00 00       	push   $0xfc
  8029f1:	68 77 3a 80 00       	push   $0x803a77
  8029f6:	e8 ae 05 00 00       	call   802fa9 <_panic>
  8029fb:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8029fe:	8b 00                	mov    (%eax),%eax
  802a00:	85 c0                	test   %eax,%eax
  802a02:	74 10                	je     802a14 <alloc_block_NF+0xff>
  802a04:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802a07:	8b 00                	mov    (%eax),%eax
  802a09:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802a0c:	8b 52 04             	mov    0x4(%edx),%edx
  802a0f:	89 50 04             	mov    %edx,0x4(%eax)
  802a12:	eb 0b                	jmp    802a1f <alloc_block_NF+0x10a>
  802a14:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802a17:	8b 40 04             	mov    0x4(%eax),%eax
  802a1a:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802a1f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802a22:	8b 40 04             	mov    0x4(%eax),%eax
  802a25:	85 c0                	test   %eax,%eax
  802a27:	74 0f                	je     802a38 <alloc_block_NF+0x123>
  802a29:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802a2c:	8b 40 04             	mov    0x4(%eax),%eax
  802a2f:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802a32:	8b 12                	mov    (%edx),%edx
  802a34:	89 10                	mov    %edx,(%eax)
  802a36:	eb 0a                	jmp    802a42 <alloc_block_NF+0x12d>
  802a38:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802a3b:	8b 00                	mov    (%eax),%eax
  802a3d:	a3 48 41 80 00       	mov    %eax,0x804148
  802a42:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802a45:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802a4b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802a4e:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802a55:	a1 54 41 80 00       	mov    0x804154,%eax
  802a5a:	48                   	dec    %eax
  802a5b:	a3 54 41 80 00       	mov    %eax,0x804154
			newblk->size = versize;
  802a60:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802a63:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802a66:	89 50 0c             	mov    %edx,0xc(%eax)
			blk->size = blk->size-versize;
  802a69:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a6c:	8b 40 0c             	mov    0xc(%eax),%eax
  802a6f:	2b 45 f0             	sub    -0x10(%ebp),%eax
  802a72:	89 c2                	mov    %eax,%edx
  802a74:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a77:	89 50 0c             	mov    %edx,0xc(%eax)
			uint32 newveradd = blk->sva;
  802a7a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a7d:	8b 40 08             	mov    0x8(%eax),%eax
  802a80:	89 45 e8             	mov    %eax,-0x18(%ebp)
			blk->sva+=newblk->size;
  802a83:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a86:	8b 50 08             	mov    0x8(%eax),%edx
  802a89:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802a8c:	8b 40 0c             	mov    0xc(%eax),%eax
  802a8f:	01 c2                	add    %eax,%edx
  802a91:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a94:	89 50 08             	mov    %edx,0x8(%eax)
			newblk->sva = newveradd;
  802a97:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802a9a:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802a9d:	89 50 08             	mov    %edx,0x8(%eax)
			return newblk;
  802aa0:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802aa3:	eb 3b                	jmp    802ae0 <alloc_block_NF+0x1cb>
	//panic("alloc_block_NF() is not implemented yet...!!");
	uint32 versize = size;
	struct MemBlock* blk;
	struct MemBlock* newblk = LIST_FIRST(&AvailableMemBlocksList);

	LIST_FOREACH(blk,&FreeMemBlocksList)
  802aa5:	a1 40 41 80 00       	mov    0x804140,%eax
  802aaa:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802aad:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802ab1:	74 07                	je     802aba <alloc_block_NF+0x1a5>
  802ab3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ab6:	8b 00                	mov    (%eax),%eax
  802ab8:	eb 05                	jmp    802abf <alloc_block_NF+0x1aa>
  802aba:	b8 00 00 00 00       	mov    $0x0,%eax
  802abf:	a3 40 41 80 00       	mov    %eax,0x804140
  802ac4:	a1 40 41 80 00       	mov    0x804140,%eax
  802ac9:	85 c0                	test   %eax,%eax
  802acb:	0f 85 65 fe ff ff    	jne    802936 <alloc_block_NF+0x21>
  802ad1:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802ad5:	0f 85 5b fe ff ff    	jne    802936 <alloc_block_NF+0x21>
			blk->sva+=newblk->size;
			newblk->sva = newveradd;
			return newblk;
		}
	}
	return NULL;
  802adb:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802ae0:	c9                   	leave  
  802ae1:	c3                   	ret    

00802ae2 <addToAvailMemBlocksList>:

//===================================================
// [8] INSERT BLOCK (SORTED WITH MERGE) IN FREE LIST:
//===================================================
void addToAvailMemBlocksList(struct MemBlock *blockToInsert)
{
  802ae2:	55                   	push   %ebp
  802ae3:	89 e5                	mov    %esp,%ebp
  802ae5:	83 ec 08             	sub    $0x8,%esp
	blockToInsert->sva = 0;
  802ae8:	8b 45 08             	mov    0x8(%ebp),%eax
  802aeb:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
	blockToInsert->size = 0;
  802af2:	8b 45 08             	mov    0x8(%ebp),%eax
  802af5:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
	//add to avail
	LIST_INSERT_TAIL(&AvailableMemBlocksList, blockToInsert);
  802afc:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802b00:	75 17                	jne    802b19 <addToAvailMemBlocksList+0x37>
  802b02:	83 ec 04             	sub    $0x4,%esp
  802b05:	68 90 3a 80 00       	push   $0x803a90
  802b0a:	68 10 01 00 00       	push   $0x110
  802b0f:	68 77 3a 80 00       	push   $0x803a77
  802b14:	e8 90 04 00 00       	call   802fa9 <_panic>
  802b19:	8b 15 4c 41 80 00    	mov    0x80414c,%edx
  802b1f:	8b 45 08             	mov    0x8(%ebp),%eax
  802b22:	89 50 04             	mov    %edx,0x4(%eax)
  802b25:	8b 45 08             	mov    0x8(%ebp),%eax
  802b28:	8b 40 04             	mov    0x4(%eax),%eax
  802b2b:	85 c0                	test   %eax,%eax
  802b2d:	74 0c                	je     802b3b <addToAvailMemBlocksList+0x59>
  802b2f:	a1 4c 41 80 00       	mov    0x80414c,%eax
  802b34:	8b 55 08             	mov    0x8(%ebp),%edx
  802b37:	89 10                	mov    %edx,(%eax)
  802b39:	eb 08                	jmp    802b43 <addToAvailMemBlocksList+0x61>
  802b3b:	8b 45 08             	mov    0x8(%ebp),%eax
  802b3e:	a3 48 41 80 00       	mov    %eax,0x804148
  802b43:	8b 45 08             	mov    0x8(%ebp),%eax
  802b46:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802b4b:	8b 45 08             	mov    0x8(%ebp),%eax
  802b4e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802b54:	a1 54 41 80 00       	mov    0x804154,%eax
  802b59:	40                   	inc    %eax
  802b5a:	a3 54 41 80 00       	mov    %eax,0x804154
}
  802b5f:	90                   	nop
  802b60:	c9                   	leave  
  802b61:	c3                   	ret    

00802b62 <insert_sorted_with_merge_freeList>:
void insert_sorted_with_merge_freeList(struct MemBlock *blockToInsert)
{
  802b62:	55                   	push   %ebp
  802b63:	89 e5                	mov    %esp,%ebp
  802b65:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] insert_sorted_with_merge_freeList
	// Write your code here, remove the panic and write your code

	struct MemBlock* last = LIST_LAST(&FreeMemBlocksList);
  802b68:	a1 3c 41 80 00       	mov    0x80413c,%eax
  802b6d:	89 45 f0             	mov    %eax,-0x10(%ebp)
	//check if list empty
	if (LIST_SIZE(&(FreeMemBlocksList)) == 0)
  802b70:	a1 44 41 80 00       	mov    0x804144,%eax
  802b75:	85 c0                	test   %eax,%eax
  802b77:	75 68                	jne    802be1 <insert_sorted_with_merge_freeList+0x7f>
		LIST_INSERT_HEAD(&FreeMemBlocksList, blockToInsert);
  802b79:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802b7d:	75 17                	jne    802b96 <insert_sorted_with_merge_freeList+0x34>
  802b7f:	83 ec 04             	sub    $0x4,%esp
  802b82:	68 54 3a 80 00       	push   $0x803a54
  802b87:	68 1a 01 00 00       	push   $0x11a
  802b8c:	68 77 3a 80 00       	push   $0x803a77
  802b91:	e8 13 04 00 00       	call   802fa9 <_panic>
  802b96:	8b 15 38 41 80 00    	mov    0x804138,%edx
  802b9c:	8b 45 08             	mov    0x8(%ebp),%eax
  802b9f:	89 10                	mov    %edx,(%eax)
  802ba1:	8b 45 08             	mov    0x8(%ebp),%eax
  802ba4:	8b 00                	mov    (%eax),%eax
  802ba6:	85 c0                	test   %eax,%eax
  802ba8:	74 0d                	je     802bb7 <insert_sorted_with_merge_freeList+0x55>
  802baa:	a1 38 41 80 00       	mov    0x804138,%eax
  802baf:	8b 55 08             	mov    0x8(%ebp),%edx
  802bb2:	89 50 04             	mov    %edx,0x4(%eax)
  802bb5:	eb 08                	jmp    802bbf <insert_sorted_with_merge_freeList+0x5d>
  802bb7:	8b 45 08             	mov    0x8(%ebp),%eax
  802bba:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802bbf:	8b 45 08             	mov    0x8(%ebp),%eax
  802bc2:	a3 38 41 80 00       	mov    %eax,0x804138
  802bc7:	8b 45 08             	mov    0x8(%ebp),%eax
  802bca:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802bd1:	a1 44 41 80 00       	mov    0x804144,%eax
  802bd6:	40                   	inc    %eax
  802bd7:	a3 44 41 80 00       	mov    %eax,0x804144
		}
	}

	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  802bdc:	e9 c5 03 00 00       	jmp    802fa6 <insert_sorted_with_merge_freeList+0x444>
	struct MemBlock* last = LIST_LAST(&FreeMemBlocksList);
	//check if list empty
	if (LIST_SIZE(&(FreeMemBlocksList)) == 0)
		LIST_INSERT_HEAD(&FreeMemBlocksList, blockToInsert);
	//check if it's position is at last
	else if (last->sva < blockToInsert->sva) {
  802be1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802be4:	8b 50 08             	mov    0x8(%eax),%edx
  802be7:	8b 45 08             	mov    0x8(%ebp),%eax
  802bea:	8b 40 08             	mov    0x8(%eax),%eax
  802bed:	39 c2                	cmp    %eax,%edx
  802bef:	0f 83 b2 00 00 00    	jae    802ca7 <insert_sorted_with_merge_freeList+0x145>

		//if i have to merge
		if (last->sva + last->size == blockToInsert->sva) {
  802bf5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802bf8:	8b 50 08             	mov    0x8(%eax),%edx
  802bfb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802bfe:	8b 40 0c             	mov    0xc(%eax),%eax
  802c01:	01 c2                	add    %eax,%edx
  802c03:	8b 45 08             	mov    0x8(%ebp),%eax
  802c06:	8b 40 08             	mov    0x8(%eax),%eax
  802c09:	39 c2                	cmp    %eax,%edx
  802c0b:	75 27                	jne    802c34 <insert_sorted_with_merge_freeList+0xd2>
			last->size = last->size + blockToInsert->size;
  802c0d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c10:	8b 50 0c             	mov    0xc(%eax),%edx
  802c13:	8b 45 08             	mov    0x8(%ebp),%eax
  802c16:	8b 40 0c             	mov    0xc(%eax),%eax
  802c19:	01 c2                	add    %eax,%edx
  802c1b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c1e:	89 50 0c             	mov    %edx,0xc(%eax)
			addToAvailMemBlocksList(blockToInsert);
  802c21:	83 ec 0c             	sub    $0xc,%esp
  802c24:	ff 75 08             	pushl  0x8(%ebp)
  802c27:	e8 b6 fe ff ff       	call   802ae2 <addToAvailMemBlocksList>
  802c2c:	83 c4 10             	add    $0x10,%esp
		}
	}

	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  802c2f:	e9 72 03 00 00       	jmp    802fa6 <insert_sorted_with_merge_freeList+0x444>
		if (last->sva + last->size == blockToInsert->sva) {
			last->size = last->size + blockToInsert->size;
			addToAvailMemBlocksList(blockToInsert);

		} else {
			LIST_INSERT_AFTER(&FreeMemBlocksList, last, blockToInsert);
  802c34:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802c38:	74 06                	je     802c40 <insert_sorted_with_merge_freeList+0xde>
  802c3a:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802c3e:	75 17                	jne    802c57 <insert_sorted_with_merge_freeList+0xf5>
  802c40:	83 ec 04             	sub    $0x4,%esp
  802c43:	68 b4 3a 80 00       	push   $0x803ab4
  802c48:	68 24 01 00 00       	push   $0x124
  802c4d:	68 77 3a 80 00       	push   $0x803a77
  802c52:	e8 52 03 00 00       	call   802fa9 <_panic>
  802c57:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c5a:	8b 10                	mov    (%eax),%edx
  802c5c:	8b 45 08             	mov    0x8(%ebp),%eax
  802c5f:	89 10                	mov    %edx,(%eax)
  802c61:	8b 45 08             	mov    0x8(%ebp),%eax
  802c64:	8b 00                	mov    (%eax),%eax
  802c66:	85 c0                	test   %eax,%eax
  802c68:	74 0b                	je     802c75 <insert_sorted_with_merge_freeList+0x113>
  802c6a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c6d:	8b 00                	mov    (%eax),%eax
  802c6f:	8b 55 08             	mov    0x8(%ebp),%edx
  802c72:	89 50 04             	mov    %edx,0x4(%eax)
  802c75:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c78:	8b 55 08             	mov    0x8(%ebp),%edx
  802c7b:	89 10                	mov    %edx,(%eax)
  802c7d:	8b 45 08             	mov    0x8(%ebp),%eax
  802c80:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802c83:	89 50 04             	mov    %edx,0x4(%eax)
  802c86:	8b 45 08             	mov    0x8(%ebp),%eax
  802c89:	8b 00                	mov    (%eax),%eax
  802c8b:	85 c0                	test   %eax,%eax
  802c8d:	75 08                	jne    802c97 <insert_sorted_with_merge_freeList+0x135>
  802c8f:	8b 45 08             	mov    0x8(%ebp),%eax
  802c92:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802c97:	a1 44 41 80 00       	mov    0x804144,%eax
  802c9c:	40                   	inc    %eax
  802c9d:	a3 44 41 80 00       	mov    %eax,0x804144
		}
	}

	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  802ca2:	e9 ff 02 00 00       	jmp    802fa6 <insert_sorted_with_merge_freeList+0x444>
		} else {
			LIST_INSERT_AFTER(&FreeMemBlocksList, last, blockToInsert);
		}
	} else {
		struct MemBlock *iterator;
		LIST_FOREACH(iterator, &(FreeMemBlocksList))
  802ca7:	a1 38 41 80 00       	mov    0x804138,%eax
  802cac:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802caf:	e9 c2 02 00 00       	jmp    802f76 <insert_sorted_with_merge_freeList+0x414>
		{

			if (iterator->sva > blockToInsert->sva) {
  802cb4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cb7:	8b 50 08             	mov    0x8(%eax),%edx
  802cba:	8b 45 08             	mov    0x8(%ebp),%eax
  802cbd:	8b 40 08             	mov    0x8(%eax),%eax
  802cc0:	39 c2                	cmp    %eax,%edx
  802cc2:	0f 86 a6 02 00 00    	jbe    802f6e <insert_sorted_with_merge_freeList+0x40c>

				struct MemBlock* prev = LIST_PREV(iterator);
  802cc8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ccb:	8b 40 04             	mov    0x4(%eax),%eax
  802cce:	89 45 ec             	mov    %eax,-0x14(%ebp)
				if (prev == NULL) {
  802cd1:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802cd5:	0f 85 ba 00 00 00    	jne    802d95 <insert_sorted_with_merge_freeList+0x233>
					//check merge
					if (blockToInsert->size + blockToInsert->sva
  802cdb:	8b 45 08             	mov    0x8(%ebp),%eax
  802cde:	8b 50 0c             	mov    0xc(%eax),%edx
  802ce1:	8b 45 08             	mov    0x8(%ebp),%eax
  802ce4:	8b 40 08             	mov    0x8(%eax),%eax
  802ce7:	01 c2                	add    %eax,%edx
							== iterator->sva) {
  802ce9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cec:	8b 40 08             	mov    0x8(%eax),%eax
			if (iterator->sva > blockToInsert->sva) {

				struct MemBlock* prev = LIST_PREV(iterator);
				if (prev == NULL) {
					//check merge
					if (blockToInsert->size + blockToInsert->sva
  802cef:	39 c2                	cmp    %eax,%edx
  802cf1:	75 33                	jne    802d26 <insert_sorted_with_merge_freeList+0x1c4>
							== iterator->sva) {
						iterator->sva = blockToInsert->sva;
  802cf3:	8b 45 08             	mov    0x8(%ebp),%eax
  802cf6:	8b 50 08             	mov    0x8(%eax),%edx
  802cf9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cfc:	89 50 08             	mov    %edx,0x8(%eax)
						iterator->size = iterator->size + blockToInsert->size;
  802cff:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d02:	8b 50 0c             	mov    0xc(%eax),%edx
  802d05:	8b 45 08             	mov    0x8(%ebp),%eax
  802d08:	8b 40 0c             	mov    0xc(%eax),%eax
  802d0b:	01 c2                	add    %eax,%edx
  802d0d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d10:	89 50 0c             	mov    %edx,0xc(%eax)
						addToAvailMemBlocksList(blockToInsert);
  802d13:	83 ec 0c             	sub    $0xc,%esp
  802d16:	ff 75 08             	pushl  0x8(%ebp)
  802d19:	e8 c4 fd ff ff       	call   802ae2 <addToAvailMemBlocksList>
  802d1e:	83 c4 10             	add    $0x10,%esp

					else {
						LIST_INSERT_BEFORE(&FreeMemBlocksList, iterator,
								blockToInsert);
					}
					break;
  802d21:	e9 80 02 00 00       	jmp    802fa6 <insert_sorted_with_merge_freeList+0x444>
						addToAvailMemBlocksList(blockToInsert);

					}

					else {
						LIST_INSERT_BEFORE(&FreeMemBlocksList, iterator,
  802d26:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802d2a:	74 06                	je     802d32 <insert_sorted_with_merge_freeList+0x1d0>
  802d2c:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802d30:	75 17                	jne    802d49 <insert_sorted_with_merge_freeList+0x1e7>
  802d32:	83 ec 04             	sub    $0x4,%esp
  802d35:	68 08 3b 80 00       	push   $0x803b08
  802d3a:	68 3a 01 00 00       	push   $0x13a
  802d3f:	68 77 3a 80 00       	push   $0x803a77
  802d44:	e8 60 02 00 00       	call   802fa9 <_panic>
  802d49:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d4c:	8b 50 04             	mov    0x4(%eax),%edx
  802d4f:	8b 45 08             	mov    0x8(%ebp),%eax
  802d52:	89 50 04             	mov    %edx,0x4(%eax)
  802d55:	8b 45 08             	mov    0x8(%ebp),%eax
  802d58:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802d5b:	89 10                	mov    %edx,(%eax)
  802d5d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d60:	8b 40 04             	mov    0x4(%eax),%eax
  802d63:	85 c0                	test   %eax,%eax
  802d65:	74 0d                	je     802d74 <insert_sorted_with_merge_freeList+0x212>
  802d67:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d6a:	8b 40 04             	mov    0x4(%eax),%eax
  802d6d:	8b 55 08             	mov    0x8(%ebp),%edx
  802d70:	89 10                	mov    %edx,(%eax)
  802d72:	eb 08                	jmp    802d7c <insert_sorted_with_merge_freeList+0x21a>
  802d74:	8b 45 08             	mov    0x8(%ebp),%eax
  802d77:	a3 38 41 80 00       	mov    %eax,0x804138
  802d7c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d7f:	8b 55 08             	mov    0x8(%ebp),%edx
  802d82:	89 50 04             	mov    %edx,0x4(%eax)
  802d85:	a1 44 41 80 00       	mov    0x804144,%eax
  802d8a:	40                   	inc    %eax
  802d8b:	a3 44 41 80 00       	mov    %eax,0x804144
								blockToInsert);
					}
					break;
  802d90:	e9 11 02 00 00       	jmp    802fa6 <insert_sorted_with_merge_freeList+0x444>
				} else {
					//prev and next merge
					if (prev->sva + prev->size + blockToInsert->size
  802d95:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802d98:	8b 50 08             	mov    0x8(%eax),%edx
  802d9b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802d9e:	8b 40 0c             	mov    0xc(%eax),%eax
  802da1:	01 c2                	add    %eax,%edx
  802da3:	8b 45 08             	mov    0x8(%ebp),%eax
  802da6:	8b 40 0c             	mov    0xc(%eax),%eax
  802da9:	01 c2                	add    %eax,%edx
							== iterator->sva) {
  802dab:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802dae:	8b 40 08             	mov    0x8(%eax),%eax
								blockToInsert);
					}
					break;
				} else {
					//prev and next merge
					if (prev->sva + prev->size + blockToInsert->size
  802db1:	39 c2                	cmp    %eax,%edx
  802db3:	0f 85 bf 00 00 00    	jne    802e78 <insert_sorted_with_merge_freeList+0x316>
							== iterator->sva) {
						prev->size = prev->size + blockToInsert->size
  802db9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802dbc:	8b 50 0c             	mov    0xc(%eax),%edx
  802dbf:	8b 45 08             	mov    0x8(%ebp),%eax
  802dc2:	8b 40 0c             	mov    0xc(%eax),%eax
  802dc5:	01 c2                	add    %eax,%edx
								+ iterator->size;
  802dc7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802dca:	8b 40 0c             	mov    0xc(%eax),%eax
  802dcd:	01 c2                	add    %eax,%edx
					break;
				} else {
					//prev and next merge
					if (prev->sva + prev->size + blockToInsert->size
							== iterator->sva) {
						prev->size = prev->size + blockToInsert->size
  802dcf:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802dd2:	89 50 0c             	mov    %edx,0xc(%eax)
								+ iterator->size;
						LIST_REMOVE(&FreeMemBlocksList, iterator);
  802dd5:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802dd9:	75 17                	jne    802df2 <insert_sorted_with_merge_freeList+0x290>
  802ddb:	83 ec 04             	sub    $0x4,%esp
  802dde:	68 e8 3a 80 00       	push   $0x803ae8
  802de3:	68 43 01 00 00       	push   $0x143
  802de8:	68 77 3a 80 00       	push   $0x803a77
  802ded:	e8 b7 01 00 00       	call   802fa9 <_panic>
  802df2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802df5:	8b 00                	mov    (%eax),%eax
  802df7:	85 c0                	test   %eax,%eax
  802df9:	74 10                	je     802e0b <insert_sorted_with_merge_freeList+0x2a9>
  802dfb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802dfe:	8b 00                	mov    (%eax),%eax
  802e00:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802e03:	8b 52 04             	mov    0x4(%edx),%edx
  802e06:	89 50 04             	mov    %edx,0x4(%eax)
  802e09:	eb 0b                	jmp    802e16 <insert_sorted_with_merge_freeList+0x2b4>
  802e0b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e0e:	8b 40 04             	mov    0x4(%eax),%eax
  802e11:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802e16:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e19:	8b 40 04             	mov    0x4(%eax),%eax
  802e1c:	85 c0                	test   %eax,%eax
  802e1e:	74 0f                	je     802e2f <insert_sorted_with_merge_freeList+0x2cd>
  802e20:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e23:	8b 40 04             	mov    0x4(%eax),%eax
  802e26:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802e29:	8b 12                	mov    (%edx),%edx
  802e2b:	89 10                	mov    %edx,(%eax)
  802e2d:	eb 0a                	jmp    802e39 <insert_sorted_with_merge_freeList+0x2d7>
  802e2f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e32:	8b 00                	mov    (%eax),%eax
  802e34:	a3 38 41 80 00       	mov    %eax,0x804138
  802e39:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e3c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802e42:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e45:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802e4c:	a1 44 41 80 00       	mov    0x804144,%eax
  802e51:	48                   	dec    %eax
  802e52:	a3 44 41 80 00       	mov    %eax,0x804144
						addToAvailMemBlocksList(blockToInsert);
  802e57:	83 ec 0c             	sub    $0xc,%esp
  802e5a:	ff 75 08             	pushl  0x8(%ebp)
  802e5d:	e8 80 fc ff ff       	call   802ae2 <addToAvailMemBlocksList>
  802e62:	83 c4 10             	add    $0x10,%esp
						addToAvailMemBlocksList(iterator);
  802e65:	83 ec 0c             	sub    $0xc,%esp
  802e68:	ff 75 f4             	pushl  -0xc(%ebp)
  802e6b:	e8 72 fc ff ff       	call   802ae2 <addToAvailMemBlocksList>
  802e70:	83 c4 10             	add    $0x10,%esp
					//Insert
					else {
						LIST_INSERT_BEFORE(&FreeMemBlocksList, iterator,
								blockToInsert);
					}
					break;
  802e73:	e9 2e 01 00 00       	jmp    802fa6 <insert_sorted_with_merge_freeList+0x444>
						LIST_REMOVE(&FreeMemBlocksList, iterator);
						addToAvailMemBlocksList(blockToInsert);
						addToAvailMemBlocksList(iterator);
					}
					//previous merge
					else if (prev->sva + prev->size == blockToInsert->sva) {
  802e78:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802e7b:	8b 50 08             	mov    0x8(%eax),%edx
  802e7e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802e81:	8b 40 0c             	mov    0xc(%eax),%eax
  802e84:	01 c2                	add    %eax,%edx
  802e86:	8b 45 08             	mov    0x8(%ebp),%eax
  802e89:	8b 40 08             	mov    0x8(%eax),%eax
  802e8c:	39 c2                	cmp    %eax,%edx
  802e8e:	75 27                	jne    802eb7 <insert_sorted_with_merge_freeList+0x355>
						prev->size = prev->size + blockToInsert->size;
  802e90:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802e93:	8b 50 0c             	mov    0xc(%eax),%edx
  802e96:	8b 45 08             	mov    0x8(%ebp),%eax
  802e99:	8b 40 0c             	mov    0xc(%eax),%eax
  802e9c:	01 c2                	add    %eax,%edx
  802e9e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802ea1:	89 50 0c             	mov    %edx,0xc(%eax)
						addToAvailMemBlocksList(blockToInsert);
  802ea4:	83 ec 0c             	sub    $0xc,%esp
  802ea7:	ff 75 08             	pushl  0x8(%ebp)
  802eaa:	e8 33 fc ff ff       	call   802ae2 <addToAvailMemBlocksList>
  802eaf:	83 c4 10             	add    $0x10,%esp
					//Insert
					else {
						LIST_INSERT_BEFORE(&FreeMemBlocksList, iterator,
								blockToInsert);
					}
					break;
  802eb2:	e9 ef 00 00 00       	jmp    802fa6 <insert_sorted_with_merge_freeList+0x444>
					else if (prev->sva + prev->size == blockToInsert->sva) {
						prev->size = prev->size + blockToInsert->size;
						addToAvailMemBlocksList(blockToInsert);
					}
					//next merge
					else if (blockToInsert->size + blockToInsert->sva
  802eb7:	8b 45 08             	mov    0x8(%ebp),%eax
  802eba:	8b 50 0c             	mov    0xc(%eax),%edx
  802ebd:	8b 45 08             	mov    0x8(%ebp),%eax
  802ec0:	8b 40 08             	mov    0x8(%eax),%eax
  802ec3:	01 c2                	add    %eax,%edx
							== iterator->sva) {
  802ec5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ec8:	8b 40 08             	mov    0x8(%eax),%eax
					else if (prev->sva + prev->size == blockToInsert->sva) {
						prev->size = prev->size + blockToInsert->size;
						addToAvailMemBlocksList(blockToInsert);
					}
					//next merge
					else if (blockToInsert->size + blockToInsert->sva
  802ecb:	39 c2                	cmp    %eax,%edx
  802ecd:	75 33                	jne    802f02 <insert_sorted_with_merge_freeList+0x3a0>
							== iterator->sva) {
						iterator->sva = blockToInsert->sva;
  802ecf:	8b 45 08             	mov    0x8(%ebp),%eax
  802ed2:	8b 50 08             	mov    0x8(%eax),%edx
  802ed5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ed8:	89 50 08             	mov    %edx,0x8(%eax)
						iterator->size = iterator->size + blockToInsert->size;
  802edb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ede:	8b 50 0c             	mov    0xc(%eax),%edx
  802ee1:	8b 45 08             	mov    0x8(%ebp),%eax
  802ee4:	8b 40 0c             	mov    0xc(%eax),%eax
  802ee7:	01 c2                	add    %eax,%edx
  802ee9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802eec:	89 50 0c             	mov    %edx,0xc(%eax)
						addToAvailMemBlocksList(blockToInsert);
  802eef:	83 ec 0c             	sub    $0xc,%esp
  802ef2:	ff 75 08             	pushl  0x8(%ebp)
  802ef5:	e8 e8 fb ff ff       	call   802ae2 <addToAvailMemBlocksList>
  802efa:	83 c4 10             	add    $0x10,%esp
					//Insert
					else {
						LIST_INSERT_BEFORE(&FreeMemBlocksList, iterator,
								blockToInsert);
					}
					break;
  802efd:	e9 a4 00 00 00       	jmp    802fa6 <insert_sorted_with_merge_freeList+0x444>
						iterator->size = iterator->size + blockToInsert->size;
						addToAvailMemBlocksList(blockToInsert);
					}
					//Insert
					else {
						LIST_INSERT_BEFORE(&FreeMemBlocksList, iterator,
  802f02:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802f06:	74 06                	je     802f0e <insert_sorted_with_merge_freeList+0x3ac>
  802f08:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802f0c:	75 17                	jne    802f25 <insert_sorted_with_merge_freeList+0x3c3>
  802f0e:	83 ec 04             	sub    $0x4,%esp
  802f11:	68 08 3b 80 00       	push   $0x803b08
  802f16:	68 56 01 00 00       	push   $0x156
  802f1b:	68 77 3a 80 00       	push   $0x803a77
  802f20:	e8 84 00 00 00       	call   802fa9 <_panic>
  802f25:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f28:	8b 50 04             	mov    0x4(%eax),%edx
  802f2b:	8b 45 08             	mov    0x8(%ebp),%eax
  802f2e:	89 50 04             	mov    %edx,0x4(%eax)
  802f31:	8b 45 08             	mov    0x8(%ebp),%eax
  802f34:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802f37:	89 10                	mov    %edx,(%eax)
  802f39:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f3c:	8b 40 04             	mov    0x4(%eax),%eax
  802f3f:	85 c0                	test   %eax,%eax
  802f41:	74 0d                	je     802f50 <insert_sorted_with_merge_freeList+0x3ee>
  802f43:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f46:	8b 40 04             	mov    0x4(%eax),%eax
  802f49:	8b 55 08             	mov    0x8(%ebp),%edx
  802f4c:	89 10                	mov    %edx,(%eax)
  802f4e:	eb 08                	jmp    802f58 <insert_sorted_with_merge_freeList+0x3f6>
  802f50:	8b 45 08             	mov    0x8(%ebp),%eax
  802f53:	a3 38 41 80 00       	mov    %eax,0x804138
  802f58:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f5b:	8b 55 08             	mov    0x8(%ebp),%edx
  802f5e:	89 50 04             	mov    %edx,0x4(%eax)
  802f61:	a1 44 41 80 00       	mov    0x804144,%eax
  802f66:	40                   	inc    %eax
  802f67:	a3 44 41 80 00       	mov    %eax,0x804144
								blockToInsert);
					}
					break;
  802f6c:	eb 38                	jmp    802fa6 <insert_sorted_with_merge_freeList+0x444>
		} else {
			LIST_INSERT_AFTER(&FreeMemBlocksList, last, blockToInsert);
		}
	} else {
		struct MemBlock *iterator;
		LIST_FOREACH(iterator, &(FreeMemBlocksList))
  802f6e:	a1 40 41 80 00       	mov    0x804140,%eax
  802f73:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802f76:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802f7a:	74 07                	je     802f83 <insert_sorted_with_merge_freeList+0x421>
  802f7c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f7f:	8b 00                	mov    (%eax),%eax
  802f81:	eb 05                	jmp    802f88 <insert_sorted_with_merge_freeList+0x426>
  802f83:	b8 00 00 00 00       	mov    $0x0,%eax
  802f88:	a3 40 41 80 00       	mov    %eax,0x804140
  802f8d:	a1 40 41 80 00       	mov    0x804140,%eax
  802f92:	85 c0                	test   %eax,%eax
  802f94:	0f 85 1a fd ff ff    	jne    802cb4 <insert_sorted_with_merge_freeList+0x152>
  802f9a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802f9e:	0f 85 10 fd ff ff    	jne    802cb4 <insert_sorted_with_merge_freeList+0x152>
		}
	}

	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  802fa4:	eb 00                	jmp    802fa6 <insert_sorted_with_merge_freeList+0x444>
  802fa6:	90                   	nop
  802fa7:	c9                   	leave  
  802fa8:	c3                   	ret    

00802fa9 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  802fa9:	55                   	push   %ebp
  802faa:	89 e5                	mov    %esp,%ebp
  802fac:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  802faf:	8d 45 10             	lea    0x10(%ebp),%eax
  802fb2:	83 c0 04             	add    $0x4,%eax
  802fb5:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  802fb8:	a1 60 41 80 00       	mov    0x804160,%eax
  802fbd:	85 c0                	test   %eax,%eax
  802fbf:	74 16                	je     802fd7 <_panic+0x2e>
		cprintf("%s: ", argv0);
  802fc1:	a1 60 41 80 00       	mov    0x804160,%eax
  802fc6:	83 ec 08             	sub    $0x8,%esp
  802fc9:	50                   	push   %eax
  802fca:	68 40 3b 80 00       	push   $0x803b40
  802fcf:	e8 af d6 ff ff       	call   800683 <cprintf>
  802fd4:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  802fd7:	a1 00 40 80 00       	mov    0x804000,%eax
  802fdc:	ff 75 0c             	pushl  0xc(%ebp)
  802fdf:	ff 75 08             	pushl  0x8(%ebp)
  802fe2:	50                   	push   %eax
  802fe3:	68 45 3b 80 00       	push   $0x803b45
  802fe8:	e8 96 d6 ff ff       	call   800683 <cprintf>
  802fed:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  802ff0:	8b 45 10             	mov    0x10(%ebp),%eax
  802ff3:	83 ec 08             	sub    $0x8,%esp
  802ff6:	ff 75 f4             	pushl  -0xc(%ebp)
  802ff9:	50                   	push   %eax
  802ffa:	e8 19 d6 ff ff       	call   800618 <vcprintf>
  802fff:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  803002:	83 ec 08             	sub    $0x8,%esp
  803005:	6a 00                	push   $0x0
  803007:	68 61 3b 80 00       	push   $0x803b61
  80300c:	e8 07 d6 ff ff       	call   800618 <vcprintf>
  803011:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  803014:	e8 88 d5 ff ff       	call   8005a1 <exit>

	// should not return here
	while (1) ;
  803019:	eb fe                	jmp    803019 <_panic+0x70>

0080301b <CheckWSWithoutLastIndex>:
}

void CheckWSWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  80301b:	55                   	push   %ebp
  80301c:	89 e5                	mov    %esp,%ebp
  80301e:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  803021:	a1 20 40 80 00       	mov    0x804020,%eax
  803026:	8b 50 74             	mov    0x74(%eax),%edx
  803029:	8b 45 0c             	mov    0xc(%ebp),%eax
  80302c:	39 c2                	cmp    %eax,%edx
  80302e:	74 14                	je     803044 <CheckWSWithoutLastIndex+0x29>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  803030:	83 ec 04             	sub    $0x4,%esp
  803033:	68 64 3b 80 00       	push   $0x803b64
  803038:	6a 26                	push   $0x26
  80303a:	68 b0 3b 80 00       	push   $0x803bb0
  80303f:	e8 65 ff ff ff       	call   802fa9 <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  803044:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  80304b:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  803052:	e9 c2 00 00 00       	jmp    803119 <CheckWSWithoutLastIndex+0xfe>
		if (expectedPages[e] == 0) {
  803057:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80305a:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  803061:	8b 45 08             	mov    0x8(%ebp),%eax
  803064:	01 d0                	add    %edx,%eax
  803066:	8b 00                	mov    (%eax),%eax
  803068:	85 c0                	test   %eax,%eax
  80306a:	75 08                	jne    803074 <CheckWSWithoutLastIndex+0x59>
			expectedNumOfEmptyLocs++;
  80306c:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  80306f:	e9 a2 00 00 00       	jmp    803116 <CheckWSWithoutLastIndex+0xfb>
		}
		int found = 0;
  803074:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  80307b:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  803082:	eb 69                	jmp    8030ed <CheckWSWithoutLastIndex+0xd2>
			if (myEnv->__uptr_pws[w].empty == 0) {
  803084:	a1 20 40 80 00       	mov    0x804020,%eax
  803089:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  80308f:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803092:	89 d0                	mov    %edx,%eax
  803094:	01 c0                	add    %eax,%eax
  803096:	01 d0                	add    %edx,%eax
  803098:	c1 e0 03             	shl    $0x3,%eax
  80309b:	01 c8                	add    %ecx,%eax
  80309d:	8a 40 04             	mov    0x4(%eax),%al
  8030a0:	84 c0                	test   %al,%al
  8030a2:	75 46                	jne    8030ea <CheckWSWithoutLastIndex+0xcf>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  8030a4:	a1 20 40 80 00       	mov    0x804020,%eax
  8030a9:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  8030af:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8030b2:	89 d0                	mov    %edx,%eax
  8030b4:	01 c0                	add    %eax,%eax
  8030b6:	01 d0                	add    %edx,%eax
  8030b8:	c1 e0 03             	shl    $0x3,%eax
  8030bb:	01 c8                	add    %ecx,%eax
  8030bd:	8b 00                	mov    (%eax),%eax
  8030bf:	89 45 dc             	mov    %eax,-0x24(%ebp)
  8030c2:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8030c5:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8030ca:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  8030cc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8030cf:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  8030d6:	8b 45 08             	mov    0x8(%ebp),%eax
  8030d9:	01 c8                	add    %ecx,%eax
  8030db:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  8030dd:	39 c2                	cmp    %eax,%edx
  8030df:	75 09                	jne    8030ea <CheckWSWithoutLastIndex+0xcf>
						== expectedPages[e]) {
					found = 1;
  8030e1:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  8030e8:	eb 12                	jmp    8030fc <CheckWSWithoutLastIndex+0xe1>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8030ea:	ff 45 e8             	incl   -0x18(%ebp)
  8030ed:	a1 20 40 80 00       	mov    0x804020,%eax
  8030f2:	8b 50 74             	mov    0x74(%eax),%edx
  8030f5:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8030f8:	39 c2                	cmp    %eax,%edx
  8030fa:	77 88                	ja     803084 <CheckWSWithoutLastIndex+0x69>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  8030fc:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  803100:	75 14                	jne    803116 <CheckWSWithoutLastIndex+0xfb>
			panic(
  803102:	83 ec 04             	sub    $0x4,%esp
  803105:	68 bc 3b 80 00       	push   $0x803bbc
  80310a:	6a 3a                	push   $0x3a
  80310c:	68 b0 3b 80 00       	push   $0x803bb0
  803111:	e8 93 fe ff ff       	call   802fa9 <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  803116:	ff 45 f0             	incl   -0x10(%ebp)
  803119:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80311c:	3b 45 0c             	cmp    0xc(%ebp),%eax
  80311f:	0f 8c 32 ff ff ff    	jl     803057 <CheckWSWithoutLastIndex+0x3c>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  803125:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  80312c:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  803133:	eb 26                	jmp    80315b <CheckWSWithoutLastIndex+0x140>
		if (myEnv->__uptr_pws[w].empty == 1) {
  803135:	a1 20 40 80 00       	mov    0x804020,%eax
  80313a:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  803140:	8b 55 e0             	mov    -0x20(%ebp),%edx
  803143:	89 d0                	mov    %edx,%eax
  803145:	01 c0                	add    %eax,%eax
  803147:	01 d0                	add    %edx,%eax
  803149:	c1 e0 03             	shl    $0x3,%eax
  80314c:	01 c8                	add    %ecx,%eax
  80314e:	8a 40 04             	mov    0x4(%eax),%al
  803151:	3c 01                	cmp    $0x1,%al
  803153:	75 03                	jne    803158 <CheckWSWithoutLastIndex+0x13d>
			actualNumOfEmptyLocs++;
  803155:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  803158:	ff 45 e0             	incl   -0x20(%ebp)
  80315b:	a1 20 40 80 00       	mov    0x804020,%eax
  803160:	8b 50 74             	mov    0x74(%eax),%edx
  803163:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803166:	39 c2                	cmp    %eax,%edx
  803168:	77 cb                	ja     803135 <CheckWSWithoutLastIndex+0x11a>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  80316a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80316d:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  803170:	74 14                	je     803186 <CheckWSWithoutLastIndex+0x16b>
		panic(
  803172:	83 ec 04             	sub    $0x4,%esp
  803175:	68 10 3c 80 00       	push   $0x803c10
  80317a:	6a 44                	push   $0x44
  80317c:	68 b0 3b 80 00       	push   $0x803bb0
  803181:	e8 23 fe ff ff       	call   802fa9 <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  803186:	90                   	nop
  803187:	c9                   	leave  
  803188:	c3                   	ret    
  803189:	66 90                	xchg   %ax,%ax
  80318b:	90                   	nop

0080318c <__udivdi3>:
  80318c:	55                   	push   %ebp
  80318d:	57                   	push   %edi
  80318e:	56                   	push   %esi
  80318f:	53                   	push   %ebx
  803190:	83 ec 1c             	sub    $0x1c,%esp
  803193:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  803197:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  80319b:	8b 7c 24 38          	mov    0x38(%esp),%edi
  80319f:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8031a3:	89 ca                	mov    %ecx,%edx
  8031a5:	89 f8                	mov    %edi,%eax
  8031a7:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  8031ab:	85 f6                	test   %esi,%esi
  8031ad:	75 2d                	jne    8031dc <__udivdi3+0x50>
  8031af:	39 cf                	cmp    %ecx,%edi
  8031b1:	77 65                	ja     803218 <__udivdi3+0x8c>
  8031b3:	89 fd                	mov    %edi,%ebp
  8031b5:	85 ff                	test   %edi,%edi
  8031b7:	75 0b                	jne    8031c4 <__udivdi3+0x38>
  8031b9:	b8 01 00 00 00       	mov    $0x1,%eax
  8031be:	31 d2                	xor    %edx,%edx
  8031c0:	f7 f7                	div    %edi
  8031c2:	89 c5                	mov    %eax,%ebp
  8031c4:	31 d2                	xor    %edx,%edx
  8031c6:	89 c8                	mov    %ecx,%eax
  8031c8:	f7 f5                	div    %ebp
  8031ca:	89 c1                	mov    %eax,%ecx
  8031cc:	89 d8                	mov    %ebx,%eax
  8031ce:	f7 f5                	div    %ebp
  8031d0:	89 cf                	mov    %ecx,%edi
  8031d2:	89 fa                	mov    %edi,%edx
  8031d4:	83 c4 1c             	add    $0x1c,%esp
  8031d7:	5b                   	pop    %ebx
  8031d8:	5e                   	pop    %esi
  8031d9:	5f                   	pop    %edi
  8031da:	5d                   	pop    %ebp
  8031db:	c3                   	ret    
  8031dc:	39 ce                	cmp    %ecx,%esi
  8031de:	77 28                	ja     803208 <__udivdi3+0x7c>
  8031e0:	0f bd fe             	bsr    %esi,%edi
  8031e3:	83 f7 1f             	xor    $0x1f,%edi
  8031e6:	75 40                	jne    803228 <__udivdi3+0x9c>
  8031e8:	39 ce                	cmp    %ecx,%esi
  8031ea:	72 0a                	jb     8031f6 <__udivdi3+0x6a>
  8031ec:	3b 44 24 08          	cmp    0x8(%esp),%eax
  8031f0:	0f 87 9e 00 00 00    	ja     803294 <__udivdi3+0x108>
  8031f6:	b8 01 00 00 00       	mov    $0x1,%eax
  8031fb:	89 fa                	mov    %edi,%edx
  8031fd:	83 c4 1c             	add    $0x1c,%esp
  803200:	5b                   	pop    %ebx
  803201:	5e                   	pop    %esi
  803202:	5f                   	pop    %edi
  803203:	5d                   	pop    %ebp
  803204:	c3                   	ret    
  803205:	8d 76 00             	lea    0x0(%esi),%esi
  803208:	31 ff                	xor    %edi,%edi
  80320a:	31 c0                	xor    %eax,%eax
  80320c:	89 fa                	mov    %edi,%edx
  80320e:	83 c4 1c             	add    $0x1c,%esp
  803211:	5b                   	pop    %ebx
  803212:	5e                   	pop    %esi
  803213:	5f                   	pop    %edi
  803214:	5d                   	pop    %ebp
  803215:	c3                   	ret    
  803216:	66 90                	xchg   %ax,%ax
  803218:	89 d8                	mov    %ebx,%eax
  80321a:	f7 f7                	div    %edi
  80321c:	31 ff                	xor    %edi,%edi
  80321e:	89 fa                	mov    %edi,%edx
  803220:	83 c4 1c             	add    $0x1c,%esp
  803223:	5b                   	pop    %ebx
  803224:	5e                   	pop    %esi
  803225:	5f                   	pop    %edi
  803226:	5d                   	pop    %ebp
  803227:	c3                   	ret    
  803228:	bd 20 00 00 00       	mov    $0x20,%ebp
  80322d:	89 eb                	mov    %ebp,%ebx
  80322f:	29 fb                	sub    %edi,%ebx
  803231:	89 f9                	mov    %edi,%ecx
  803233:	d3 e6                	shl    %cl,%esi
  803235:	89 c5                	mov    %eax,%ebp
  803237:	88 d9                	mov    %bl,%cl
  803239:	d3 ed                	shr    %cl,%ebp
  80323b:	89 e9                	mov    %ebp,%ecx
  80323d:	09 f1                	or     %esi,%ecx
  80323f:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  803243:	89 f9                	mov    %edi,%ecx
  803245:	d3 e0                	shl    %cl,%eax
  803247:	89 c5                	mov    %eax,%ebp
  803249:	89 d6                	mov    %edx,%esi
  80324b:	88 d9                	mov    %bl,%cl
  80324d:	d3 ee                	shr    %cl,%esi
  80324f:	89 f9                	mov    %edi,%ecx
  803251:	d3 e2                	shl    %cl,%edx
  803253:	8b 44 24 08          	mov    0x8(%esp),%eax
  803257:	88 d9                	mov    %bl,%cl
  803259:	d3 e8                	shr    %cl,%eax
  80325b:	09 c2                	or     %eax,%edx
  80325d:	89 d0                	mov    %edx,%eax
  80325f:	89 f2                	mov    %esi,%edx
  803261:	f7 74 24 0c          	divl   0xc(%esp)
  803265:	89 d6                	mov    %edx,%esi
  803267:	89 c3                	mov    %eax,%ebx
  803269:	f7 e5                	mul    %ebp
  80326b:	39 d6                	cmp    %edx,%esi
  80326d:	72 19                	jb     803288 <__udivdi3+0xfc>
  80326f:	74 0b                	je     80327c <__udivdi3+0xf0>
  803271:	89 d8                	mov    %ebx,%eax
  803273:	31 ff                	xor    %edi,%edi
  803275:	e9 58 ff ff ff       	jmp    8031d2 <__udivdi3+0x46>
  80327a:	66 90                	xchg   %ax,%ax
  80327c:	8b 54 24 08          	mov    0x8(%esp),%edx
  803280:	89 f9                	mov    %edi,%ecx
  803282:	d3 e2                	shl    %cl,%edx
  803284:	39 c2                	cmp    %eax,%edx
  803286:	73 e9                	jae    803271 <__udivdi3+0xe5>
  803288:	8d 43 ff             	lea    -0x1(%ebx),%eax
  80328b:	31 ff                	xor    %edi,%edi
  80328d:	e9 40 ff ff ff       	jmp    8031d2 <__udivdi3+0x46>
  803292:	66 90                	xchg   %ax,%ax
  803294:	31 c0                	xor    %eax,%eax
  803296:	e9 37 ff ff ff       	jmp    8031d2 <__udivdi3+0x46>
  80329b:	90                   	nop

0080329c <__umoddi3>:
  80329c:	55                   	push   %ebp
  80329d:	57                   	push   %edi
  80329e:	56                   	push   %esi
  80329f:	53                   	push   %ebx
  8032a0:	83 ec 1c             	sub    $0x1c,%esp
  8032a3:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  8032a7:	8b 74 24 34          	mov    0x34(%esp),%esi
  8032ab:	8b 7c 24 38          	mov    0x38(%esp),%edi
  8032af:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  8032b3:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8032b7:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8032bb:	89 f3                	mov    %esi,%ebx
  8032bd:	89 fa                	mov    %edi,%edx
  8032bf:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8032c3:	89 34 24             	mov    %esi,(%esp)
  8032c6:	85 c0                	test   %eax,%eax
  8032c8:	75 1a                	jne    8032e4 <__umoddi3+0x48>
  8032ca:	39 f7                	cmp    %esi,%edi
  8032cc:	0f 86 a2 00 00 00    	jbe    803374 <__umoddi3+0xd8>
  8032d2:	89 c8                	mov    %ecx,%eax
  8032d4:	89 f2                	mov    %esi,%edx
  8032d6:	f7 f7                	div    %edi
  8032d8:	89 d0                	mov    %edx,%eax
  8032da:	31 d2                	xor    %edx,%edx
  8032dc:	83 c4 1c             	add    $0x1c,%esp
  8032df:	5b                   	pop    %ebx
  8032e0:	5e                   	pop    %esi
  8032e1:	5f                   	pop    %edi
  8032e2:	5d                   	pop    %ebp
  8032e3:	c3                   	ret    
  8032e4:	39 f0                	cmp    %esi,%eax
  8032e6:	0f 87 ac 00 00 00    	ja     803398 <__umoddi3+0xfc>
  8032ec:	0f bd e8             	bsr    %eax,%ebp
  8032ef:	83 f5 1f             	xor    $0x1f,%ebp
  8032f2:	0f 84 ac 00 00 00    	je     8033a4 <__umoddi3+0x108>
  8032f8:	bf 20 00 00 00       	mov    $0x20,%edi
  8032fd:	29 ef                	sub    %ebp,%edi
  8032ff:	89 fe                	mov    %edi,%esi
  803301:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  803305:	89 e9                	mov    %ebp,%ecx
  803307:	d3 e0                	shl    %cl,%eax
  803309:	89 d7                	mov    %edx,%edi
  80330b:	89 f1                	mov    %esi,%ecx
  80330d:	d3 ef                	shr    %cl,%edi
  80330f:	09 c7                	or     %eax,%edi
  803311:	89 e9                	mov    %ebp,%ecx
  803313:	d3 e2                	shl    %cl,%edx
  803315:	89 14 24             	mov    %edx,(%esp)
  803318:	89 d8                	mov    %ebx,%eax
  80331a:	d3 e0                	shl    %cl,%eax
  80331c:	89 c2                	mov    %eax,%edx
  80331e:	8b 44 24 08          	mov    0x8(%esp),%eax
  803322:	d3 e0                	shl    %cl,%eax
  803324:	89 44 24 04          	mov    %eax,0x4(%esp)
  803328:	8b 44 24 08          	mov    0x8(%esp),%eax
  80332c:	89 f1                	mov    %esi,%ecx
  80332e:	d3 e8                	shr    %cl,%eax
  803330:	09 d0                	or     %edx,%eax
  803332:	d3 eb                	shr    %cl,%ebx
  803334:	89 da                	mov    %ebx,%edx
  803336:	f7 f7                	div    %edi
  803338:	89 d3                	mov    %edx,%ebx
  80333a:	f7 24 24             	mull   (%esp)
  80333d:	89 c6                	mov    %eax,%esi
  80333f:	89 d1                	mov    %edx,%ecx
  803341:	39 d3                	cmp    %edx,%ebx
  803343:	0f 82 87 00 00 00    	jb     8033d0 <__umoddi3+0x134>
  803349:	0f 84 91 00 00 00    	je     8033e0 <__umoddi3+0x144>
  80334f:	8b 54 24 04          	mov    0x4(%esp),%edx
  803353:	29 f2                	sub    %esi,%edx
  803355:	19 cb                	sbb    %ecx,%ebx
  803357:	89 d8                	mov    %ebx,%eax
  803359:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  80335d:	d3 e0                	shl    %cl,%eax
  80335f:	89 e9                	mov    %ebp,%ecx
  803361:	d3 ea                	shr    %cl,%edx
  803363:	09 d0                	or     %edx,%eax
  803365:	89 e9                	mov    %ebp,%ecx
  803367:	d3 eb                	shr    %cl,%ebx
  803369:	89 da                	mov    %ebx,%edx
  80336b:	83 c4 1c             	add    $0x1c,%esp
  80336e:	5b                   	pop    %ebx
  80336f:	5e                   	pop    %esi
  803370:	5f                   	pop    %edi
  803371:	5d                   	pop    %ebp
  803372:	c3                   	ret    
  803373:	90                   	nop
  803374:	89 fd                	mov    %edi,%ebp
  803376:	85 ff                	test   %edi,%edi
  803378:	75 0b                	jne    803385 <__umoddi3+0xe9>
  80337a:	b8 01 00 00 00       	mov    $0x1,%eax
  80337f:	31 d2                	xor    %edx,%edx
  803381:	f7 f7                	div    %edi
  803383:	89 c5                	mov    %eax,%ebp
  803385:	89 f0                	mov    %esi,%eax
  803387:	31 d2                	xor    %edx,%edx
  803389:	f7 f5                	div    %ebp
  80338b:	89 c8                	mov    %ecx,%eax
  80338d:	f7 f5                	div    %ebp
  80338f:	89 d0                	mov    %edx,%eax
  803391:	e9 44 ff ff ff       	jmp    8032da <__umoddi3+0x3e>
  803396:	66 90                	xchg   %ax,%ax
  803398:	89 c8                	mov    %ecx,%eax
  80339a:	89 f2                	mov    %esi,%edx
  80339c:	83 c4 1c             	add    $0x1c,%esp
  80339f:	5b                   	pop    %ebx
  8033a0:	5e                   	pop    %esi
  8033a1:	5f                   	pop    %edi
  8033a2:	5d                   	pop    %ebp
  8033a3:	c3                   	ret    
  8033a4:	3b 04 24             	cmp    (%esp),%eax
  8033a7:	72 06                	jb     8033af <__umoddi3+0x113>
  8033a9:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  8033ad:	77 0f                	ja     8033be <__umoddi3+0x122>
  8033af:	89 f2                	mov    %esi,%edx
  8033b1:	29 f9                	sub    %edi,%ecx
  8033b3:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  8033b7:	89 14 24             	mov    %edx,(%esp)
  8033ba:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8033be:	8b 44 24 04          	mov    0x4(%esp),%eax
  8033c2:	8b 14 24             	mov    (%esp),%edx
  8033c5:	83 c4 1c             	add    $0x1c,%esp
  8033c8:	5b                   	pop    %ebx
  8033c9:	5e                   	pop    %esi
  8033ca:	5f                   	pop    %edi
  8033cb:	5d                   	pop    %ebp
  8033cc:	c3                   	ret    
  8033cd:	8d 76 00             	lea    0x0(%esi),%esi
  8033d0:	2b 04 24             	sub    (%esp),%eax
  8033d3:	19 fa                	sbb    %edi,%edx
  8033d5:	89 d1                	mov    %edx,%ecx
  8033d7:	89 c6                	mov    %eax,%esi
  8033d9:	e9 71 ff ff ff       	jmp    80334f <__umoddi3+0xb3>
  8033de:	66 90                	xchg   %ax,%ax
  8033e0:	39 44 24 04          	cmp    %eax,0x4(%esp)
  8033e4:	72 ea                	jb     8033d0 <__umoddi3+0x134>
  8033e6:	89 d9                	mov    %ebx,%ecx
  8033e8:	e9 62 ff ff ff       	jmp    80334f <__umoddi3+0xb3>
