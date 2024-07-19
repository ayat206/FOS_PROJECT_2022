
obj/user/arrayOperations_stats:     file format elf32-i386


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
  800031:	e8 f7 04 00 00       	call   80052d <libmain>
1:      jmp 1b
  800036:	eb fe                	jmp    800036 <args_exist+0x5>

00800038 <_main>:
void ArrayStats(int *Elements, int NumOfElements, int *mean, int *var, int *min, int *max, int *med);
int KthElement(int *Elements, int NumOfElements, int k);
int QSort(int *Elements,int NumOfElements, int startIndex, int finalIndex, int kIndex);

void _main(void)
{
  800038:	55                   	push   %ebp
  800039:	89 e5                	mov    %esp,%ebp
  80003b:	83 ec 58             	sub    $0x58,%esp
	int32 envID = sys_getenvid();
  80003e:	e8 5f 1d 00 00       	call   801da2 <sys_getenvid>
  800043:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int32 parentenvID = sys_getparentenvid();
  800046:	e8 89 1d 00 00       	call   801dd4 <sys_getparentenvid>
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
  80005f:	68 c0 34 80 00       	push   $0x8034c0
  800064:	ff 75 ec             	pushl  -0x14(%ebp)
  800067:	e8 5b 18 00 00       	call   8018c7 <sget>
  80006c:	83 c4 10             	add    $0x10,%esp
  80006f:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	numOfElements = sget(parentenvID,"arrSize") ;
  800072:	83 ec 08             	sub    $0x8,%esp
  800075:	68 c4 34 80 00       	push   $0x8034c4
  80007a:	ff 75 ec             	pushl  -0x14(%ebp)
  80007d:	e8 45 18 00 00       	call   8018c7 <sget>
  800082:	83 c4 10             	add    $0x10,%esp
  800085:	89 45 e8             	mov    %eax,-0x18(%ebp)

	//Get the check-finishing counter
	int *finishedCount = NULL;
  800088:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
	finishedCount = sget(parentenvID,"finishedCount") ;
  80008f:	83 ec 08             	sub    $0x8,%esp
  800092:	68 cc 34 80 00       	push   $0x8034cc
  800097:	ff 75 ec             	pushl  -0x14(%ebp)
  80009a:	e8 28 18 00 00       	call   8018c7 <sget>
  80009f:	83 c4 10             	add    $0x10,%esp
  8000a2:	89 45 e0             	mov    %eax,-0x20(%ebp)
	int max ;
	int med ;

	//take a copy from the original array
	int *tmpArray;
	tmpArray = smalloc("tmpArr", sizeof(int) * *numOfElements, 0) ;
  8000a5:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8000a8:	8b 00                	mov    (%eax),%eax
  8000aa:	c1 e0 02             	shl    $0x2,%eax
  8000ad:	83 ec 04             	sub    $0x4,%esp
  8000b0:	6a 00                	push   $0x0
  8000b2:	50                   	push   %eax
  8000b3:	68 da 34 80 00       	push   $0x8034da
  8000b8:	e8 5a 17 00 00       	call   801817 <smalloc>
  8000bd:	83 c4 10             	add    $0x10,%esp
  8000c0:	89 45 dc             	mov    %eax,-0x24(%ebp)
	int i ;
	for (i = 0 ; i < *numOfElements ; i++)
  8000c3:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  8000ca:	eb 25                	jmp    8000f1 <_main+0xb9>
	{
		tmpArray[i] = sharedArray[i];
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

	//take a copy from the original array
	int *tmpArray;
	tmpArray = smalloc("tmpArr", sizeof(int) * *numOfElements, 0) ;
	int i ;
	for (i = 0 ; i < *numOfElements ; i++)
  8000ee:	ff 45 f4             	incl   -0xc(%ebp)
  8000f1:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8000f4:	8b 00                	mov    (%eax),%eax
  8000f6:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  8000f9:	7f d1                	jg     8000cc <_main+0x94>
	{
		tmpArray[i] = sharedArray[i];
	}

	ArrayStats(tmpArray ,*numOfElements, &mean, &var, &min, &max, &med);
  8000fb:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8000fe:	8b 00                	mov    (%eax),%eax
  800100:	83 ec 04             	sub    $0x4,%esp
  800103:	8d 55 b4             	lea    -0x4c(%ebp),%edx
  800106:	52                   	push   %edx
  800107:	8d 55 b8             	lea    -0x48(%ebp),%edx
  80010a:	52                   	push   %edx
  80010b:	8d 55 bc             	lea    -0x44(%ebp),%edx
  80010e:	52                   	push   %edx
  80010f:	8d 55 c0             	lea    -0x40(%ebp),%edx
  800112:	52                   	push   %edx
  800113:	8d 55 c4             	lea    -0x3c(%ebp),%edx
  800116:	52                   	push   %edx
  800117:	50                   	push   %eax
  800118:	ff 75 dc             	pushl  -0x24(%ebp)
  80011b:	e8 55 02 00 00       	call   800375 <ArrayStats>
  800120:	83 c4 20             	add    $0x20,%esp
	cprintf("Stats Calculations are Finished!!!!\n") ;
  800123:	83 ec 0c             	sub    $0xc,%esp
  800126:	68 e4 34 80 00       	push   $0x8034e4
  80012b:	e8 0d 06 00 00       	call   80073d <cprintf>
  800130:	83 c4 10             	add    $0x10,%esp

	/*[3] SHARE THE RESULTS & DECLARE FINISHING*/
	int *shMean, *shVar, *shMin, *shMax, *shMed;
	shMean = smalloc("mean", sizeof(int), 0) ; *shMean = mean;
  800133:	83 ec 04             	sub    $0x4,%esp
  800136:	6a 00                	push   $0x0
  800138:	6a 04                	push   $0x4
  80013a:	68 09 35 80 00       	push   $0x803509
  80013f:	e8 d3 16 00 00       	call   801817 <smalloc>
  800144:	83 c4 10             	add    $0x10,%esp
  800147:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80014a:	8b 55 c4             	mov    -0x3c(%ebp),%edx
  80014d:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800150:	89 10                	mov    %edx,(%eax)
	shVar = smalloc("var", sizeof(int), 0) ; *shVar = var;
  800152:	83 ec 04             	sub    $0x4,%esp
  800155:	6a 00                	push   $0x0
  800157:	6a 04                	push   $0x4
  800159:	68 0e 35 80 00       	push   $0x80350e
  80015e:	e8 b4 16 00 00       	call   801817 <smalloc>
  800163:	83 c4 10             	add    $0x10,%esp
  800166:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  800169:	8b 55 c0             	mov    -0x40(%ebp),%edx
  80016c:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80016f:	89 10                	mov    %edx,(%eax)
	shMin = smalloc("min", sizeof(int), 0) ; *shMin = min;
  800171:	83 ec 04             	sub    $0x4,%esp
  800174:	6a 00                	push   $0x0
  800176:	6a 04                	push   $0x4
  800178:	68 12 35 80 00       	push   $0x803512
  80017d:	e8 95 16 00 00       	call   801817 <smalloc>
  800182:	83 c4 10             	add    $0x10,%esp
  800185:	89 45 d0             	mov    %eax,-0x30(%ebp)
  800188:	8b 55 bc             	mov    -0x44(%ebp),%edx
  80018b:	8b 45 d0             	mov    -0x30(%ebp),%eax
  80018e:	89 10                	mov    %edx,(%eax)
	shMax = smalloc("max", sizeof(int), 0) ; *shMax = max;
  800190:	83 ec 04             	sub    $0x4,%esp
  800193:	6a 00                	push   $0x0
  800195:	6a 04                	push   $0x4
  800197:	68 16 35 80 00       	push   $0x803516
  80019c:	e8 76 16 00 00       	call   801817 <smalloc>
  8001a1:	83 c4 10             	add    $0x10,%esp
  8001a4:	89 45 cc             	mov    %eax,-0x34(%ebp)
  8001a7:	8b 55 b8             	mov    -0x48(%ebp),%edx
  8001aa:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8001ad:	89 10                	mov    %edx,(%eax)
	shMed = smalloc("med", sizeof(int), 0) ; *shMed = med;
  8001af:	83 ec 04             	sub    $0x4,%esp
  8001b2:	6a 00                	push   $0x0
  8001b4:	6a 04                	push   $0x4
  8001b6:	68 1a 35 80 00       	push   $0x80351a
  8001bb:	e8 57 16 00 00       	call   801817 <smalloc>
  8001c0:	83 c4 10             	add    $0x10,%esp
  8001c3:	89 45 c8             	mov    %eax,-0x38(%ebp)
  8001c6:	8b 55 b4             	mov    -0x4c(%ebp),%edx
  8001c9:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8001cc:	89 10                	mov    %edx,(%eax)

	(*finishedCount)++ ;
  8001ce:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8001d1:	8b 00                	mov    (%eax),%eax
  8001d3:	8d 50 01             	lea    0x1(%eax),%edx
  8001d6:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8001d9:	89 10                	mov    %edx,(%eax)

}
  8001db:	90                   	nop
  8001dc:	c9                   	leave  
  8001dd:	c3                   	ret    

008001de <KthElement>:



///Kth Element
int KthElement(int *Elements, int NumOfElements, int k)
{
  8001de:	55                   	push   %ebp
  8001df:	89 e5                	mov    %esp,%ebp
  8001e1:	83 ec 08             	sub    $0x8,%esp
	return QSort(Elements, NumOfElements, 0, NumOfElements-1, k-1) ;
  8001e4:	8b 45 10             	mov    0x10(%ebp),%eax
  8001e7:	8d 50 ff             	lea    -0x1(%eax),%edx
  8001ea:	8b 45 0c             	mov    0xc(%ebp),%eax
  8001ed:	48                   	dec    %eax
  8001ee:	83 ec 0c             	sub    $0xc,%esp
  8001f1:	52                   	push   %edx
  8001f2:	50                   	push   %eax
  8001f3:	6a 00                	push   $0x0
  8001f5:	ff 75 0c             	pushl  0xc(%ebp)
  8001f8:	ff 75 08             	pushl  0x8(%ebp)
  8001fb:	e8 05 00 00 00       	call   800205 <QSort>
  800200:	83 c4 20             	add    $0x20,%esp
}
  800203:	c9                   	leave  
  800204:	c3                   	ret    

00800205 <QSort>:


int QSort(int *Elements,int NumOfElements, int startIndex, int finalIndex, int kIndex)
{
  800205:	55                   	push   %ebp
  800206:	89 e5                	mov    %esp,%ebp
  800208:	83 ec 28             	sub    $0x28,%esp
	if (startIndex >= finalIndex) return Elements[finalIndex];
  80020b:	8b 45 10             	mov    0x10(%ebp),%eax
  80020e:	3b 45 14             	cmp    0x14(%ebp),%eax
  800211:	7c 16                	jl     800229 <QSort+0x24>
  800213:	8b 45 14             	mov    0x14(%ebp),%eax
  800216:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80021d:	8b 45 08             	mov    0x8(%ebp),%eax
  800220:	01 d0                	add    %edx,%eax
  800222:	8b 00                	mov    (%eax),%eax
  800224:	e9 4a 01 00 00       	jmp    800373 <QSort+0x16e>

	int pvtIndex = RAND(startIndex, finalIndex) ;
  800229:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  80022c:	83 ec 0c             	sub    $0xc,%esp
  80022f:	50                   	push   %eax
  800230:	e8 d2 1b 00 00       	call   801e07 <sys_get_virtual_time>
  800235:	83 c4 0c             	add    $0xc,%esp
  800238:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80023b:	8b 55 14             	mov    0x14(%ebp),%edx
  80023e:	2b 55 10             	sub    0x10(%ebp),%edx
  800241:	89 d1                	mov    %edx,%ecx
  800243:	ba 00 00 00 00       	mov    $0x0,%edx
  800248:	f7 f1                	div    %ecx
  80024a:	8b 45 10             	mov    0x10(%ebp),%eax
  80024d:	01 d0                	add    %edx,%eax
  80024f:	89 45 ec             	mov    %eax,-0x14(%ebp)
	Swap(Elements, startIndex, pvtIndex);
  800252:	83 ec 04             	sub    $0x4,%esp
  800255:	ff 75 ec             	pushl  -0x14(%ebp)
  800258:	ff 75 10             	pushl  0x10(%ebp)
  80025b:	ff 75 08             	pushl  0x8(%ebp)
  80025e:	e8 77 02 00 00       	call   8004da <Swap>
  800263:	83 c4 10             	add    $0x10,%esp

	int i = startIndex+1, j = finalIndex;
  800266:	8b 45 10             	mov    0x10(%ebp),%eax
  800269:	40                   	inc    %eax
  80026a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80026d:	8b 45 14             	mov    0x14(%ebp),%eax
  800270:	89 45 f0             	mov    %eax,-0x10(%ebp)

	while (i <= j)
  800273:	e9 80 00 00 00       	jmp    8002f8 <QSort+0xf3>
	{
		while (i <= finalIndex && Elements[startIndex] >= Elements[i]) i++;
  800278:	ff 45 f4             	incl   -0xc(%ebp)
  80027b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80027e:	3b 45 14             	cmp    0x14(%ebp),%eax
  800281:	7f 2b                	jg     8002ae <QSort+0xa9>
  800283:	8b 45 10             	mov    0x10(%ebp),%eax
  800286:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80028d:	8b 45 08             	mov    0x8(%ebp),%eax
  800290:	01 d0                	add    %edx,%eax
  800292:	8b 10                	mov    (%eax),%edx
  800294:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800297:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  80029e:	8b 45 08             	mov    0x8(%ebp),%eax
  8002a1:	01 c8                	add    %ecx,%eax
  8002a3:	8b 00                	mov    (%eax),%eax
  8002a5:	39 c2                	cmp    %eax,%edx
  8002a7:	7d cf                	jge    800278 <QSort+0x73>
		while (j > startIndex && Elements[startIndex] <= Elements[j]) j--;
  8002a9:	eb 03                	jmp    8002ae <QSort+0xa9>
  8002ab:	ff 4d f0             	decl   -0x10(%ebp)
  8002ae:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8002b1:	3b 45 10             	cmp    0x10(%ebp),%eax
  8002b4:	7e 26                	jle    8002dc <QSort+0xd7>
  8002b6:	8b 45 10             	mov    0x10(%ebp),%eax
  8002b9:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8002c0:	8b 45 08             	mov    0x8(%ebp),%eax
  8002c3:	01 d0                	add    %edx,%eax
  8002c5:	8b 10                	mov    (%eax),%edx
  8002c7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8002ca:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  8002d1:	8b 45 08             	mov    0x8(%ebp),%eax
  8002d4:	01 c8                	add    %ecx,%eax
  8002d6:	8b 00                	mov    (%eax),%eax
  8002d8:	39 c2                	cmp    %eax,%edx
  8002da:	7e cf                	jle    8002ab <QSort+0xa6>

		if (i <= j)
  8002dc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8002df:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8002e2:	7f 14                	jg     8002f8 <QSort+0xf3>
		{
			Swap(Elements, i, j);
  8002e4:	83 ec 04             	sub    $0x4,%esp
  8002e7:	ff 75 f0             	pushl  -0x10(%ebp)
  8002ea:	ff 75 f4             	pushl  -0xc(%ebp)
  8002ed:	ff 75 08             	pushl  0x8(%ebp)
  8002f0:	e8 e5 01 00 00       	call   8004da <Swap>
  8002f5:	83 c4 10             	add    $0x10,%esp
	int pvtIndex = RAND(startIndex, finalIndex) ;
	Swap(Elements, startIndex, pvtIndex);

	int i = startIndex+1, j = finalIndex;

	while (i <= j)
  8002f8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8002fb:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8002fe:	0f 8e 77 ff ff ff    	jle    80027b <QSort+0x76>
		{
			Swap(Elements, i, j);
		}
	}

	Swap( Elements, startIndex, j);
  800304:	83 ec 04             	sub    $0x4,%esp
  800307:	ff 75 f0             	pushl  -0x10(%ebp)
  80030a:	ff 75 10             	pushl  0x10(%ebp)
  80030d:	ff 75 08             	pushl  0x8(%ebp)
  800310:	e8 c5 01 00 00       	call   8004da <Swap>
  800315:	83 c4 10             	add    $0x10,%esp

	if (kIndex == j)
  800318:	8b 45 18             	mov    0x18(%ebp),%eax
  80031b:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80031e:	75 13                	jne    800333 <QSort+0x12e>
		return Elements[kIndex] ;
  800320:	8b 45 18             	mov    0x18(%ebp),%eax
  800323:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80032a:	8b 45 08             	mov    0x8(%ebp),%eax
  80032d:	01 d0                	add    %edx,%eax
  80032f:	8b 00                	mov    (%eax),%eax
  800331:	eb 40                	jmp    800373 <QSort+0x16e>
	else if (kIndex < j)
  800333:	8b 45 18             	mov    0x18(%ebp),%eax
  800336:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800339:	7d 1e                	jge    800359 <QSort+0x154>
		return QSort(Elements, NumOfElements, startIndex, j - 1, kIndex);
  80033b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80033e:	48                   	dec    %eax
  80033f:	83 ec 0c             	sub    $0xc,%esp
  800342:	ff 75 18             	pushl  0x18(%ebp)
  800345:	50                   	push   %eax
  800346:	ff 75 10             	pushl  0x10(%ebp)
  800349:	ff 75 0c             	pushl  0xc(%ebp)
  80034c:	ff 75 08             	pushl  0x8(%ebp)
  80034f:	e8 b1 fe ff ff       	call   800205 <QSort>
  800354:	83 c4 20             	add    $0x20,%esp
  800357:	eb 1a                	jmp    800373 <QSort+0x16e>
	else
		return QSort(Elements, NumOfElements, i, finalIndex, kIndex);
  800359:	83 ec 0c             	sub    $0xc,%esp
  80035c:	ff 75 18             	pushl  0x18(%ebp)
  80035f:	ff 75 14             	pushl  0x14(%ebp)
  800362:	ff 75 f4             	pushl  -0xc(%ebp)
  800365:	ff 75 0c             	pushl  0xc(%ebp)
  800368:	ff 75 08             	pushl  0x8(%ebp)
  80036b:	e8 95 fe ff ff       	call   800205 <QSort>
  800370:	83 c4 20             	add    $0x20,%esp
}
  800373:	c9                   	leave  
  800374:	c3                   	ret    

00800375 <ArrayStats>:

void ArrayStats(int *Elements, int NumOfElements, int *mean, int *var, int *min, int *max, int *med)
{
  800375:	55                   	push   %ebp
  800376:	89 e5                	mov    %esp,%ebp
  800378:	53                   	push   %ebx
  800379:	83 ec 14             	sub    $0x14,%esp
	int i ;
	*mean =0 ;
  80037c:	8b 45 10             	mov    0x10(%ebp),%eax
  80037f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	*min = 0x7FFFFFFF ;
  800385:	8b 45 18             	mov    0x18(%ebp),%eax
  800388:	c7 00 ff ff ff 7f    	movl   $0x7fffffff,(%eax)
	*max = 0x80000000 ;
  80038e:	8b 45 1c             	mov    0x1c(%ebp),%eax
  800391:	c7 00 00 00 00 80    	movl   $0x80000000,(%eax)
	for (i = 0 ; i < NumOfElements ; i++)
  800397:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  80039e:	e9 80 00 00 00       	jmp    800423 <ArrayStats+0xae>
	{
		(*mean) += Elements[i];
  8003a3:	8b 45 10             	mov    0x10(%ebp),%eax
  8003a6:	8b 10                	mov    (%eax),%edx
  8003a8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8003ab:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  8003b2:	8b 45 08             	mov    0x8(%ebp),%eax
  8003b5:	01 c8                	add    %ecx,%eax
  8003b7:	8b 00                	mov    (%eax),%eax
  8003b9:	01 c2                	add    %eax,%edx
  8003bb:	8b 45 10             	mov    0x10(%ebp),%eax
  8003be:	89 10                	mov    %edx,(%eax)
		if (Elements[i] < (*min))
  8003c0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8003c3:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8003ca:	8b 45 08             	mov    0x8(%ebp),%eax
  8003cd:	01 d0                	add    %edx,%eax
  8003cf:	8b 10                	mov    (%eax),%edx
  8003d1:	8b 45 18             	mov    0x18(%ebp),%eax
  8003d4:	8b 00                	mov    (%eax),%eax
  8003d6:	39 c2                	cmp    %eax,%edx
  8003d8:	7d 16                	jge    8003f0 <ArrayStats+0x7b>
		{
			(*min) = Elements[i];
  8003da:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8003dd:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8003e4:	8b 45 08             	mov    0x8(%ebp),%eax
  8003e7:	01 d0                	add    %edx,%eax
  8003e9:	8b 10                	mov    (%eax),%edx
  8003eb:	8b 45 18             	mov    0x18(%ebp),%eax
  8003ee:	89 10                	mov    %edx,(%eax)
		}
		if (Elements[i] > (*max))
  8003f0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8003f3:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8003fa:	8b 45 08             	mov    0x8(%ebp),%eax
  8003fd:	01 d0                	add    %edx,%eax
  8003ff:	8b 10                	mov    (%eax),%edx
  800401:	8b 45 1c             	mov    0x1c(%ebp),%eax
  800404:	8b 00                	mov    (%eax),%eax
  800406:	39 c2                	cmp    %eax,%edx
  800408:	7e 16                	jle    800420 <ArrayStats+0xab>
		{
			(*max) = Elements[i];
  80040a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80040d:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800414:	8b 45 08             	mov    0x8(%ebp),%eax
  800417:	01 d0                	add    %edx,%eax
  800419:	8b 10                	mov    (%eax),%edx
  80041b:	8b 45 1c             	mov    0x1c(%ebp),%eax
  80041e:	89 10                	mov    %edx,(%eax)
{
	int i ;
	*mean =0 ;
	*min = 0x7FFFFFFF ;
	*max = 0x80000000 ;
	for (i = 0 ; i < NumOfElements ; i++)
  800420:	ff 45 f4             	incl   -0xc(%ebp)
  800423:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800426:	3b 45 0c             	cmp    0xc(%ebp),%eax
  800429:	0f 8c 74 ff ff ff    	jl     8003a3 <ArrayStats+0x2e>
		{
			(*max) = Elements[i];
		}
	}

	(*med) = KthElement(Elements, NumOfElements, NumOfElements/2);
  80042f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800432:	89 c2                	mov    %eax,%edx
  800434:	c1 ea 1f             	shr    $0x1f,%edx
  800437:	01 d0                	add    %edx,%eax
  800439:	d1 f8                	sar    %eax
  80043b:	83 ec 04             	sub    $0x4,%esp
  80043e:	50                   	push   %eax
  80043f:	ff 75 0c             	pushl  0xc(%ebp)
  800442:	ff 75 08             	pushl  0x8(%ebp)
  800445:	e8 94 fd ff ff       	call   8001de <KthElement>
  80044a:	83 c4 10             	add    $0x10,%esp
  80044d:	89 c2                	mov    %eax,%edx
  80044f:	8b 45 20             	mov    0x20(%ebp),%eax
  800452:	89 10                	mov    %edx,(%eax)

	(*mean) /= NumOfElements;
  800454:	8b 45 10             	mov    0x10(%ebp),%eax
  800457:	8b 00                	mov    (%eax),%eax
  800459:	99                   	cltd   
  80045a:	f7 7d 0c             	idivl  0xc(%ebp)
  80045d:	89 c2                	mov    %eax,%edx
  80045f:	8b 45 10             	mov    0x10(%ebp),%eax
  800462:	89 10                	mov    %edx,(%eax)
	(*var) = 0;
  800464:	8b 45 14             	mov    0x14(%ebp),%eax
  800467:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	for (i = 0 ; i < NumOfElements ; i++)
  80046d:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  800474:	eb 46                	jmp    8004bc <ArrayStats+0x147>
	{
		(*var) += (Elements[i] - (*mean))*(Elements[i] - (*mean));
  800476:	8b 45 14             	mov    0x14(%ebp),%eax
  800479:	8b 10                	mov    (%eax),%edx
  80047b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80047e:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  800485:	8b 45 08             	mov    0x8(%ebp),%eax
  800488:	01 c8                	add    %ecx,%eax
  80048a:	8b 08                	mov    (%eax),%ecx
  80048c:	8b 45 10             	mov    0x10(%ebp),%eax
  80048f:	8b 00                	mov    (%eax),%eax
  800491:	89 cb                	mov    %ecx,%ebx
  800493:	29 c3                	sub    %eax,%ebx
  800495:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800498:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  80049f:	8b 45 08             	mov    0x8(%ebp),%eax
  8004a2:	01 c8                	add    %ecx,%eax
  8004a4:	8b 08                	mov    (%eax),%ecx
  8004a6:	8b 45 10             	mov    0x10(%ebp),%eax
  8004a9:	8b 00                	mov    (%eax),%eax
  8004ab:	29 c1                	sub    %eax,%ecx
  8004ad:	89 c8                	mov    %ecx,%eax
  8004af:	0f af c3             	imul   %ebx,%eax
  8004b2:	01 c2                	add    %eax,%edx
  8004b4:	8b 45 14             	mov    0x14(%ebp),%eax
  8004b7:	89 10                	mov    %edx,(%eax)

	(*med) = KthElement(Elements, NumOfElements, NumOfElements/2);

	(*mean) /= NumOfElements;
	(*var) = 0;
	for (i = 0 ; i < NumOfElements ; i++)
  8004b9:	ff 45 f4             	incl   -0xc(%ebp)
  8004bc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8004bf:	3b 45 0c             	cmp    0xc(%ebp),%eax
  8004c2:	7c b2                	jl     800476 <ArrayStats+0x101>
	{
		(*var) += (Elements[i] - (*mean))*(Elements[i] - (*mean));
	}
	(*var) /= NumOfElements;
  8004c4:	8b 45 14             	mov    0x14(%ebp),%eax
  8004c7:	8b 00                	mov    (%eax),%eax
  8004c9:	99                   	cltd   
  8004ca:	f7 7d 0c             	idivl  0xc(%ebp)
  8004cd:	89 c2                	mov    %eax,%edx
  8004cf:	8b 45 14             	mov    0x14(%ebp),%eax
  8004d2:	89 10                	mov    %edx,(%eax)
}
  8004d4:	90                   	nop
  8004d5:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8004d8:	c9                   	leave  
  8004d9:	c3                   	ret    

008004da <Swap>:

///Private Functions
void Swap(int *Elements, int First, int Second)
{
  8004da:	55                   	push   %ebp
  8004db:	89 e5                	mov    %esp,%ebp
  8004dd:	83 ec 10             	sub    $0x10,%esp
	int Tmp = Elements[First] ;
  8004e0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8004e3:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8004ea:	8b 45 08             	mov    0x8(%ebp),%eax
  8004ed:	01 d0                	add    %edx,%eax
  8004ef:	8b 00                	mov    (%eax),%eax
  8004f1:	89 45 fc             	mov    %eax,-0x4(%ebp)
	Elements[First] = Elements[Second] ;
  8004f4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8004f7:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8004fe:	8b 45 08             	mov    0x8(%ebp),%eax
  800501:	01 c2                	add    %eax,%edx
  800503:	8b 45 10             	mov    0x10(%ebp),%eax
  800506:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  80050d:	8b 45 08             	mov    0x8(%ebp),%eax
  800510:	01 c8                	add    %ecx,%eax
  800512:	8b 00                	mov    (%eax),%eax
  800514:	89 02                	mov    %eax,(%edx)
	Elements[Second] = Tmp ;
  800516:	8b 45 10             	mov    0x10(%ebp),%eax
  800519:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800520:	8b 45 08             	mov    0x8(%ebp),%eax
  800523:	01 c2                	add    %eax,%edx
  800525:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800528:	89 02                	mov    %eax,(%edx)
}
  80052a:	90                   	nop
  80052b:	c9                   	leave  
  80052c:	c3                   	ret    

0080052d <libmain>:
volatile struct Env *myEnv = NULL;
volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";

void
libmain(int argc, char **argv)
{
  80052d:	55                   	push   %ebp
  80052e:	89 e5                	mov    %esp,%ebp
  800530:	83 ec 18             	sub    $0x18,%esp
	int envIndex = sys_getenvindex();
  800533:	e8 83 18 00 00       	call   801dbb <sys_getenvindex>
  800538:	89 45 f4             	mov    %eax,-0xc(%ebp)
	myEnv = &(envs[envIndex]);
  80053b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80053e:	89 d0                	mov    %edx,%eax
  800540:	c1 e0 03             	shl    $0x3,%eax
  800543:	01 d0                	add    %edx,%eax
  800545:	01 c0                	add    %eax,%eax
  800547:	01 d0                	add    %edx,%eax
  800549:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800550:	01 d0                	add    %edx,%eax
  800552:	c1 e0 04             	shl    $0x4,%eax
  800555:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  80055a:	a3 20 40 80 00       	mov    %eax,0x804020

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  80055f:	a1 20 40 80 00       	mov    0x804020,%eax
  800564:	8a 80 5c 05 00 00    	mov    0x55c(%eax),%al
  80056a:	84 c0                	test   %al,%al
  80056c:	74 0f                	je     80057d <libmain+0x50>
		binaryname = myEnv->prog_name;
  80056e:	a1 20 40 80 00       	mov    0x804020,%eax
  800573:	05 5c 05 00 00       	add    $0x55c,%eax
  800578:	a3 00 40 80 00       	mov    %eax,0x804000

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  80057d:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800581:	7e 0a                	jle    80058d <libmain+0x60>
		binaryname = argv[0];
  800583:	8b 45 0c             	mov    0xc(%ebp),%eax
  800586:	8b 00                	mov    (%eax),%eax
  800588:	a3 00 40 80 00       	mov    %eax,0x804000

	// call user main routine
	_main(argc, argv);
  80058d:	83 ec 08             	sub    $0x8,%esp
  800590:	ff 75 0c             	pushl  0xc(%ebp)
  800593:	ff 75 08             	pushl  0x8(%ebp)
  800596:	e8 9d fa ff ff       	call   800038 <_main>
  80059b:	83 c4 10             	add    $0x10,%esp



	sys_disable_interrupt();
  80059e:	e8 25 16 00 00       	call   801bc8 <sys_disable_interrupt>
	cprintf("**************************************\n");
  8005a3:	83 ec 0c             	sub    $0xc,%esp
  8005a6:	68 38 35 80 00       	push   $0x803538
  8005ab:	e8 8d 01 00 00       	call   80073d <cprintf>
  8005b0:	83 c4 10             	add    $0x10,%esp
	cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  8005b3:	a1 20 40 80 00       	mov    0x804020,%eax
  8005b8:	8b 90 44 05 00 00    	mov    0x544(%eax),%edx
  8005be:	a1 20 40 80 00       	mov    0x804020,%eax
  8005c3:	8b 80 34 05 00 00    	mov    0x534(%eax),%eax
  8005c9:	83 ec 04             	sub    $0x4,%esp
  8005cc:	52                   	push   %edx
  8005cd:	50                   	push   %eax
  8005ce:	68 60 35 80 00       	push   $0x803560
  8005d3:	e8 65 01 00 00       	call   80073d <cprintf>
  8005d8:	83 c4 10             	add    $0x10,%esp
	cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  8005db:	a1 20 40 80 00       	mov    0x804020,%eax
  8005e0:	8b 88 54 05 00 00    	mov    0x554(%eax),%ecx
  8005e6:	a1 20 40 80 00       	mov    0x804020,%eax
  8005eb:	8b 90 50 05 00 00    	mov    0x550(%eax),%edx
  8005f1:	a1 20 40 80 00       	mov    0x804020,%eax
  8005f6:	8b 80 4c 05 00 00    	mov    0x54c(%eax),%eax
  8005fc:	51                   	push   %ecx
  8005fd:	52                   	push   %edx
  8005fe:	50                   	push   %eax
  8005ff:	68 88 35 80 00       	push   $0x803588
  800604:	e8 34 01 00 00       	call   80073d <cprintf>
  800609:	83 c4 10             	add    $0x10,%esp
	//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
	cprintf("Num of clocks = %d\n", myEnv->nClocks);
  80060c:	a1 20 40 80 00       	mov    0x804020,%eax
  800611:	8b 80 a4 05 00 00    	mov    0x5a4(%eax),%eax
  800617:	83 ec 08             	sub    $0x8,%esp
  80061a:	50                   	push   %eax
  80061b:	68 e0 35 80 00       	push   $0x8035e0
  800620:	e8 18 01 00 00       	call   80073d <cprintf>
  800625:	83 c4 10             	add    $0x10,%esp
	cprintf("**************************************\n");
  800628:	83 ec 0c             	sub    $0xc,%esp
  80062b:	68 38 35 80 00       	push   $0x803538
  800630:	e8 08 01 00 00       	call   80073d <cprintf>
  800635:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  800638:	e8 a5 15 00 00       	call   801be2 <sys_enable_interrupt>

	// exit gracefully
	exit();
  80063d:	e8 19 00 00 00       	call   80065b <exit>
}
  800642:	90                   	nop
  800643:	c9                   	leave  
  800644:	c3                   	ret    

00800645 <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  800645:	55                   	push   %ebp
  800646:	89 e5                	mov    %esp,%ebp
  800648:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  80064b:	83 ec 0c             	sub    $0xc,%esp
  80064e:	6a 00                	push   $0x0
  800650:	e8 32 17 00 00       	call   801d87 <sys_destroy_env>
  800655:	83 c4 10             	add    $0x10,%esp
}
  800658:	90                   	nop
  800659:	c9                   	leave  
  80065a:	c3                   	ret    

0080065b <exit>:

void
exit(void)
{
  80065b:	55                   	push   %ebp
  80065c:	89 e5                	mov    %esp,%ebp
  80065e:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  800661:	e8 87 17 00 00       	call   801ded <sys_exit_env>
}
  800666:	90                   	nop
  800667:	c9                   	leave  
  800668:	c3                   	ret    

00800669 <putch>:
};

//2017:
uint8 printProgName = 0;

static void putch(int ch, struct printbuf *b) {
  800669:	55                   	push   %ebp
  80066a:	89 e5                	mov    %esp,%ebp
  80066c:	83 ec 08             	sub    $0x8,%esp
	b->buf[b->idx++] = ch;
  80066f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800672:	8b 00                	mov    (%eax),%eax
  800674:	8d 48 01             	lea    0x1(%eax),%ecx
  800677:	8b 55 0c             	mov    0xc(%ebp),%edx
  80067a:	89 0a                	mov    %ecx,(%edx)
  80067c:	8b 55 08             	mov    0x8(%ebp),%edx
  80067f:	88 d1                	mov    %dl,%cl
  800681:	8b 55 0c             	mov    0xc(%ebp),%edx
  800684:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  800688:	8b 45 0c             	mov    0xc(%ebp),%eax
  80068b:	8b 00                	mov    (%eax),%eax
  80068d:	3d ff 00 00 00       	cmp    $0xff,%eax
  800692:	75 2c                	jne    8006c0 <putch+0x57>
		sys_cputs(b->buf, b->idx, printProgName);
  800694:	a0 24 40 80 00       	mov    0x804024,%al
  800699:	0f b6 c0             	movzbl %al,%eax
  80069c:	8b 55 0c             	mov    0xc(%ebp),%edx
  80069f:	8b 12                	mov    (%edx),%edx
  8006a1:	89 d1                	mov    %edx,%ecx
  8006a3:	8b 55 0c             	mov    0xc(%ebp),%edx
  8006a6:	83 c2 08             	add    $0x8,%edx
  8006a9:	83 ec 04             	sub    $0x4,%esp
  8006ac:	50                   	push   %eax
  8006ad:	51                   	push   %ecx
  8006ae:	52                   	push   %edx
  8006af:	e8 66 13 00 00       	call   801a1a <sys_cputs>
  8006b4:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  8006b7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8006ba:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  8006c0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8006c3:	8b 40 04             	mov    0x4(%eax),%eax
  8006c6:	8d 50 01             	lea    0x1(%eax),%edx
  8006c9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8006cc:	89 50 04             	mov    %edx,0x4(%eax)
}
  8006cf:	90                   	nop
  8006d0:	c9                   	leave  
  8006d1:	c3                   	ret    

008006d2 <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  8006d2:	55                   	push   %ebp
  8006d3:	89 e5                	mov    %esp,%ebp
  8006d5:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  8006db:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  8006e2:	00 00 00 
	b.cnt = 0;
  8006e5:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  8006ec:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  8006ef:	ff 75 0c             	pushl  0xc(%ebp)
  8006f2:	ff 75 08             	pushl  0x8(%ebp)
  8006f5:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8006fb:	50                   	push   %eax
  8006fc:	68 69 06 80 00       	push   $0x800669
  800701:	e8 11 02 00 00       	call   800917 <vprintfmt>
  800706:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName);
  800709:	a0 24 40 80 00       	mov    0x804024,%al
  80070e:	0f b6 c0             	movzbl %al,%eax
  800711:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  800717:	83 ec 04             	sub    $0x4,%esp
  80071a:	50                   	push   %eax
  80071b:	52                   	push   %edx
  80071c:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800722:	83 c0 08             	add    $0x8,%eax
  800725:	50                   	push   %eax
  800726:	e8 ef 12 00 00       	call   801a1a <sys_cputs>
  80072b:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  80072e:	c6 05 24 40 80 00 00 	movb   $0x0,0x804024
	return b.cnt;
  800735:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  80073b:	c9                   	leave  
  80073c:	c3                   	ret    

0080073d <cprintf>:

int cprintf(const char *fmt, ...) {
  80073d:	55                   	push   %ebp
  80073e:	89 e5                	mov    %esp,%ebp
  800740:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  800743:	c6 05 24 40 80 00 01 	movb   $0x1,0x804024
	va_start(ap, fmt);
  80074a:	8d 45 0c             	lea    0xc(%ebp),%eax
  80074d:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800750:	8b 45 08             	mov    0x8(%ebp),%eax
  800753:	83 ec 08             	sub    $0x8,%esp
  800756:	ff 75 f4             	pushl  -0xc(%ebp)
  800759:	50                   	push   %eax
  80075a:	e8 73 ff ff ff       	call   8006d2 <vcprintf>
  80075f:	83 c4 10             	add    $0x10,%esp
  800762:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  800765:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800768:	c9                   	leave  
  800769:	c3                   	ret    

0080076a <atomic_cprintf>:

int atomic_cprintf(const char *fmt, ...) {
  80076a:	55                   	push   %ebp
  80076b:	89 e5                	mov    %esp,%ebp
  80076d:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  800770:	e8 53 14 00 00       	call   801bc8 <sys_disable_interrupt>
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  800775:	8d 45 0c             	lea    0xc(%ebp),%eax
  800778:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  80077b:	8b 45 08             	mov    0x8(%ebp),%eax
  80077e:	83 ec 08             	sub    $0x8,%esp
  800781:	ff 75 f4             	pushl  -0xc(%ebp)
  800784:	50                   	push   %eax
  800785:	e8 48 ff ff ff       	call   8006d2 <vcprintf>
  80078a:	83 c4 10             	add    $0x10,%esp
  80078d:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	sys_enable_interrupt();
  800790:	e8 4d 14 00 00       	call   801be2 <sys_enable_interrupt>
	return cnt;
  800795:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800798:	c9                   	leave  
  800799:	c3                   	ret    

0080079a <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  80079a:	55                   	push   %ebp
  80079b:	89 e5                	mov    %esp,%ebp
  80079d:	53                   	push   %ebx
  80079e:	83 ec 14             	sub    $0x14,%esp
  8007a1:	8b 45 10             	mov    0x10(%ebp),%eax
  8007a4:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8007a7:	8b 45 14             	mov    0x14(%ebp),%eax
  8007aa:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  8007ad:	8b 45 18             	mov    0x18(%ebp),%eax
  8007b0:	ba 00 00 00 00       	mov    $0x0,%edx
  8007b5:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  8007b8:	77 55                	ja     80080f <printnum+0x75>
  8007ba:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  8007bd:	72 05                	jb     8007c4 <printnum+0x2a>
  8007bf:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8007c2:	77 4b                	ja     80080f <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  8007c4:	8b 45 1c             	mov    0x1c(%ebp),%eax
  8007c7:	8d 58 ff             	lea    -0x1(%eax),%ebx
  8007ca:	8b 45 18             	mov    0x18(%ebp),%eax
  8007cd:	ba 00 00 00 00       	mov    $0x0,%edx
  8007d2:	52                   	push   %edx
  8007d3:	50                   	push   %eax
  8007d4:	ff 75 f4             	pushl  -0xc(%ebp)
  8007d7:	ff 75 f0             	pushl  -0x10(%ebp)
  8007da:	e8 65 2a 00 00       	call   803244 <__udivdi3>
  8007df:	83 c4 10             	add    $0x10,%esp
  8007e2:	83 ec 04             	sub    $0x4,%esp
  8007e5:	ff 75 20             	pushl  0x20(%ebp)
  8007e8:	53                   	push   %ebx
  8007e9:	ff 75 18             	pushl  0x18(%ebp)
  8007ec:	52                   	push   %edx
  8007ed:	50                   	push   %eax
  8007ee:	ff 75 0c             	pushl  0xc(%ebp)
  8007f1:	ff 75 08             	pushl  0x8(%ebp)
  8007f4:	e8 a1 ff ff ff       	call   80079a <printnum>
  8007f9:	83 c4 20             	add    $0x20,%esp
  8007fc:	eb 1a                	jmp    800818 <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  8007fe:	83 ec 08             	sub    $0x8,%esp
  800801:	ff 75 0c             	pushl  0xc(%ebp)
  800804:	ff 75 20             	pushl  0x20(%ebp)
  800807:	8b 45 08             	mov    0x8(%ebp),%eax
  80080a:	ff d0                	call   *%eax
  80080c:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  80080f:	ff 4d 1c             	decl   0x1c(%ebp)
  800812:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  800816:	7f e6                	jg     8007fe <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800818:	8b 4d 18             	mov    0x18(%ebp),%ecx
  80081b:	bb 00 00 00 00       	mov    $0x0,%ebx
  800820:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800823:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800826:	53                   	push   %ebx
  800827:	51                   	push   %ecx
  800828:	52                   	push   %edx
  800829:	50                   	push   %eax
  80082a:	e8 25 2b 00 00       	call   803354 <__umoddi3>
  80082f:	83 c4 10             	add    $0x10,%esp
  800832:	05 14 38 80 00       	add    $0x803814,%eax
  800837:	8a 00                	mov    (%eax),%al
  800839:	0f be c0             	movsbl %al,%eax
  80083c:	83 ec 08             	sub    $0x8,%esp
  80083f:	ff 75 0c             	pushl  0xc(%ebp)
  800842:	50                   	push   %eax
  800843:	8b 45 08             	mov    0x8(%ebp),%eax
  800846:	ff d0                	call   *%eax
  800848:	83 c4 10             	add    $0x10,%esp
}
  80084b:	90                   	nop
  80084c:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80084f:	c9                   	leave  
  800850:	c3                   	ret    

00800851 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  800851:	55                   	push   %ebp
  800852:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800854:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800858:	7e 1c                	jle    800876 <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  80085a:	8b 45 08             	mov    0x8(%ebp),%eax
  80085d:	8b 00                	mov    (%eax),%eax
  80085f:	8d 50 08             	lea    0x8(%eax),%edx
  800862:	8b 45 08             	mov    0x8(%ebp),%eax
  800865:	89 10                	mov    %edx,(%eax)
  800867:	8b 45 08             	mov    0x8(%ebp),%eax
  80086a:	8b 00                	mov    (%eax),%eax
  80086c:	83 e8 08             	sub    $0x8,%eax
  80086f:	8b 50 04             	mov    0x4(%eax),%edx
  800872:	8b 00                	mov    (%eax),%eax
  800874:	eb 40                	jmp    8008b6 <getuint+0x65>
	else if (lflag)
  800876:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80087a:	74 1e                	je     80089a <getuint+0x49>
		return va_arg(*ap, unsigned long);
  80087c:	8b 45 08             	mov    0x8(%ebp),%eax
  80087f:	8b 00                	mov    (%eax),%eax
  800881:	8d 50 04             	lea    0x4(%eax),%edx
  800884:	8b 45 08             	mov    0x8(%ebp),%eax
  800887:	89 10                	mov    %edx,(%eax)
  800889:	8b 45 08             	mov    0x8(%ebp),%eax
  80088c:	8b 00                	mov    (%eax),%eax
  80088e:	83 e8 04             	sub    $0x4,%eax
  800891:	8b 00                	mov    (%eax),%eax
  800893:	ba 00 00 00 00       	mov    $0x0,%edx
  800898:	eb 1c                	jmp    8008b6 <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  80089a:	8b 45 08             	mov    0x8(%ebp),%eax
  80089d:	8b 00                	mov    (%eax),%eax
  80089f:	8d 50 04             	lea    0x4(%eax),%edx
  8008a2:	8b 45 08             	mov    0x8(%ebp),%eax
  8008a5:	89 10                	mov    %edx,(%eax)
  8008a7:	8b 45 08             	mov    0x8(%ebp),%eax
  8008aa:	8b 00                	mov    (%eax),%eax
  8008ac:	83 e8 04             	sub    $0x4,%eax
  8008af:	8b 00                	mov    (%eax),%eax
  8008b1:	ba 00 00 00 00       	mov    $0x0,%edx
}
  8008b6:	5d                   	pop    %ebp
  8008b7:	c3                   	ret    

008008b8 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  8008b8:	55                   	push   %ebp
  8008b9:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  8008bb:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  8008bf:	7e 1c                	jle    8008dd <getint+0x25>
		return va_arg(*ap, long long);
  8008c1:	8b 45 08             	mov    0x8(%ebp),%eax
  8008c4:	8b 00                	mov    (%eax),%eax
  8008c6:	8d 50 08             	lea    0x8(%eax),%edx
  8008c9:	8b 45 08             	mov    0x8(%ebp),%eax
  8008cc:	89 10                	mov    %edx,(%eax)
  8008ce:	8b 45 08             	mov    0x8(%ebp),%eax
  8008d1:	8b 00                	mov    (%eax),%eax
  8008d3:	83 e8 08             	sub    $0x8,%eax
  8008d6:	8b 50 04             	mov    0x4(%eax),%edx
  8008d9:	8b 00                	mov    (%eax),%eax
  8008db:	eb 38                	jmp    800915 <getint+0x5d>
	else if (lflag)
  8008dd:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8008e1:	74 1a                	je     8008fd <getint+0x45>
		return va_arg(*ap, long);
  8008e3:	8b 45 08             	mov    0x8(%ebp),%eax
  8008e6:	8b 00                	mov    (%eax),%eax
  8008e8:	8d 50 04             	lea    0x4(%eax),%edx
  8008eb:	8b 45 08             	mov    0x8(%ebp),%eax
  8008ee:	89 10                	mov    %edx,(%eax)
  8008f0:	8b 45 08             	mov    0x8(%ebp),%eax
  8008f3:	8b 00                	mov    (%eax),%eax
  8008f5:	83 e8 04             	sub    $0x4,%eax
  8008f8:	8b 00                	mov    (%eax),%eax
  8008fa:	99                   	cltd   
  8008fb:	eb 18                	jmp    800915 <getint+0x5d>
	else
		return va_arg(*ap, int);
  8008fd:	8b 45 08             	mov    0x8(%ebp),%eax
  800900:	8b 00                	mov    (%eax),%eax
  800902:	8d 50 04             	lea    0x4(%eax),%edx
  800905:	8b 45 08             	mov    0x8(%ebp),%eax
  800908:	89 10                	mov    %edx,(%eax)
  80090a:	8b 45 08             	mov    0x8(%ebp),%eax
  80090d:	8b 00                	mov    (%eax),%eax
  80090f:	83 e8 04             	sub    $0x4,%eax
  800912:	8b 00                	mov    (%eax),%eax
  800914:	99                   	cltd   
}
  800915:	5d                   	pop    %ebp
  800916:	c3                   	ret    

00800917 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  800917:	55                   	push   %ebp
  800918:	89 e5                	mov    %esp,%ebp
  80091a:	56                   	push   %esi
  80091b:	53                   	push   %ebx
  80091c:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  80091f:	eb 17                	jmp    800938 <vprintfmt+0x21>
			if (ch == '\0')
  800921:	85 db                	test   %ebx,%ebx
  800923:	0f 84 af 03 00 00    	je     800cd8 <vprintfmt+0x3c1>
				return;
			putch(ch, putdat);
  800929:	83 ec 08             	sub    $0x8,%esp
  80092c:	ff 75 0c             	pushl  0xc(%ebp)
  80092f:	53                   	push   %ebx
  800930:	8b 45 08             	mov    0x8(%ebp),%eax
  800933:	ff d0                	call   *%eax
  800935:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800938:	8b 45 10             	mov    0x10(%ebp),%eax
  80093b:	8d 50 01             	lea    0x1(%eax),%edx
  80093e:	89 55 10             	mov    %edx,0x10(%ebp)
  800941:	8a 00                	mov    (%eax),%al
  800943:	0f b6 d8             	movzbl %al,%ebx
  800946:	83 fb 25             	cmp    $0x25,%ebx
  800949:	75 d6                	jne    800921 <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  80094b:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  80094f:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  800956:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  80095d:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  800964:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  80096b:	8b 45 10             	mov    0x10(%ebp),%eax
  80096e:	8d 50 01             	lea    0x1(%eax),%edx
  800971:	89 55 10             	mov    %edx,0x10(%ebp)
  800974:	8a 00                	mov    (%eax),%al
  800976:	0f b6 d8             	movzbl %al,%ebx
  800979:	8d 43 dd             	lea    -0x23(%ebx),%eax
  80097c:	83 f8 55             	cmp    $0x55,%eax
  80097f:	0f 87 2b 03 00 00    	ja     800cb0 <vprintfmt+0x399>
  800985:	8b 04 85 38 38 80 00 	mov    0x803838(,%eax,4),%eax
  80098c:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  80098e:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  800992:	eb d7                	jmp    80096b <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800994:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  800998:	eb d1                	jmp    80096b <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  80099a:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  8009a1:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8009a4:	89 d0                	mov    %edx,%eax
  8009a6:	c1 e0 02             	shl    $0x2,%eax
  8009a9:	01 d0                	add    %edx,%eax
  8009ab:	01 c0                	add    %eax,%eax
  8009ad:	01 d8                	add    %ebx,%eax
  8009af:	83 e8 30             	sub    $0x30,%eax
  8009b2:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  8009b5:	8b 45 10             	mov    0x10(%ebp),%eax
  8009b8:	8a 00                	mov    (%eax),%al
  8009ba:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  8009bd:	83 fb 2f             	cmp    $0x2f,%ebx
  8009c0:	7e 3e                	jle    800a00 <vprintfmt+0xe9>
  8009c2:	83 fb 39             	cmp    $0x39,%ebx
  8009c5:	7f 39                	jg     800a00 <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8009c7:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  8009ca:	eb d5                	jmp    8009a1 <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  8009cc:	8b 45 14             	mov    0x14(%ebp),%eax
  8009cf:	83 c0 04             	add    $0x4,%eax
  8009d2:	89 45 14             	mov    %eax,0x14(%ebp)
  8009d5:	8b 45 14             	mov    0x14(%ebp),%eax
  8009d8:	83 e8 04             	sub    $0x4,%eax
  8009db:	8b 00                	mov    (%eax),%eax
  8009dd:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  8009e0:	eb 1f                	jmp    800a01 <vprintfmt+0xea>

		case '.':
			if (width < 0)
  8009e2:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8009e6:	79 83                	jns    80096b <vprintfmt+0x54>
				width = 0;
  8009e8:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  8009ef:	e9 77 ff ff ff       	jmp    80096b <vprintfmt+0x54>

		case '#':
			altflag = 1;
  8009f4:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  8009fb:	e9 6b ff ff ff       	jmp    80096b <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  800a00:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  800a01:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800a05:	0f 89 60 ff ff ff    	jns    80096b <vprintfmt+0x54>
				width = precision, precision = -1;
  800a0b:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800a0e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800a11:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  800a18:	e9 4e ff ff ff       	jmp    80096b <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  800a1d:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  800a20:	e9 46 ff ff ff       	jmp    80096b <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  800a25:	8b 45 14             	mov    0x14(%ebp),%eax
  800a28:	83 c0 04             	add    $0x4,%eax
  800a2b:	89 45 14             	mov    %eax,0x14(%ebp)
  800a2e:	8b 45 14             	mov    0x14(%ebp),%eax
  800a31:	83 e8 04             	sub    $0x4,%eax
  800a34:	8b 00                	mov    (%eax),%eax
  800a36:	83 ec 08             	sub    $0x8,%esp
  800a39:	ff 75 0c             	pushl  0xc(%ebp)
  800a3c:	50                   	push   %eax
  800a3d:	8b 45 08             	mov    0x8(%ebp),%eax
  800a40:	ff d0                	call   *%eax
  800a42:	83 c4 10             	add    $0x10,%esp
			break;
  800a45:	e9 89 02 00 00       	jmp    800cd3 <vprintfmt+0x3bc>

		// error message
		case 'e':
			err = va_arg(ap, int);
  800a4a:	8b 45 14             	mov    0x14(%ebp),%eax
  800a4d:	83 c0 04             	add    $0x4,%eax
  800a50:	89 45 14             	mov    %eax,0x14(%ebp)
  800a53:	8b 45 14             	mov    0x14(%ebp),%eax
  800a56:	83 e8 04             	sub    $0x4,%eax
  800a59:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  800a5b:	85 db                	test   %ebx,%ebx
  800a5d:	79 02                	jns    800a61 <vprintfmt+0x14a>
				err = -err;
  800a5f:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  800a61:	83 fb 64             	cmp    $0x64,%ebx
  800a64:	7f 0b                	jg     800a71 <vprintfmt+0x15a>
  800a66:	8b 34 9d 80 36 80 00 	mov    0x803680(,%ebx,4),%esi
  800a6d:	85 f6                	test   %esi,%esi
  800a6f:	75 19                	jne    800a8a <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  800a71:	53                   	push   %ebx
  800a72:	68 25 38 80 00       	push   $0x803825
  800a77:	ff 75 0c             	pushl  0xc(%ebp)
  800a7a:	ff 75 08             	pushl  0x8(%ebp)
  800a7d:	e8 5e 02 00 00       	call   800ce0 <printfmt>
  800a82:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800a85:	e9 49 02 00 00       	jmp    800cd3 <vprintfmt+0x3bc>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800a8a:	56                   	push   %esi
  800a8b:	68 2e 38 80 00       	push   $0x80382e
  800a90:	ff 75 0c             	pushl  0xc(%ebp)
  800a93:	ff 75 08             	pushl  0x8(%ebp)
  800a96:	e8 45 02 00 00       	call   800ce0 <printfmt>
  800a9b:	83 c4 10             	add    $0x10,%esp
			break;
  800a9e:	e9 30 02 00 00       	jmp    800cd3 <vprintfmt+0x3bc>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  800aa3:	8b 45 14             	mov    0x14(%ebp),%eax
  800aa6:	83 c0 04             	add    $0x4,%eax
  800aa9:	89 45 14             	mov    %eax,0x14(%ebp)
  800aac:	8b 45 14             	mov    0x14(%ebp),%eax
  800aaf:	83 e8 04             	sub    $0x4,%eax
  800ab2:	8b 30                	mov    (%eax),%esi
  800ab4:	85 f6                	test   %esi,%esi
  800ab6:	75 05                	jne    800abd <vprintfmt+0x1a6>
				p = "(null)";
  800ab8:	be 31 38 80 00       	mov    $0x803831,%esi
			if (width > 0 && padc != '-')
  800abd:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800ac1:	7e 6d                	jle    800b30 <vprintfmt+0x219>
  800ac3:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  800ac7:	74 67                	je     800b30 <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  800ac9:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800acc:	83 ec 08             	sub    $0x8,%esp
  800acf:	50                   	push   %eax
  800ad0:	56                   	push   %esi
  800ad1:	e8 0c 03 00 00       	call   800de2 <strnlen>
  800ad6:	83 c4 10             	add    $0x10,%esp
  800ad9:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  800adc:	eb 16                	jmp    800af4 <vprintfmt+0x1dd>
					putch(padc, putdat);
  800ade:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  800ae2:	83 ec 08             	sub    $0x8,%esp
  800ae5:	ff 75 0c             	pushl  0xc(%ebp)
  800ae8:	50                   	push   %eax
  800ae9:	8b 45 08             	mov    0x8(%ebp),%eax
  800aec:	ff d0                	call   *%eax
  800aee:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800af1:	ff 4d e4             	decl   -0x1c(%ebp)
  800af4:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800af8:	7f e4                	jg     800ade <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800afa:	eb 34                	jmp    800b30 <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  800afc:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800b00:	74 1c                	je     800b1e <vprintfmt+0x207>
  800b02:	83 fb 1f             	cmp    $0x1f,%ebx
  800b05:	7e 05                	jle    800b0c <vprintfmt+0x1f5>
  800b07:	83 fb 7e             	cmp    $0x7e,%ebx
  800b0a:	7e 12                	jle    800b1e <vprintfmt+0x207>
					putch('?', putdat);
  800b0c:	83 ec 08             	sub    $0x8,%esp
  800b0f:	ff 75 0c             	pushl  0xc(%ebp)
  800b12:	6a 3f                	push   $0x3f
  800b14:	8b 45 08             	mov    0x8(%ebp),%eax
  800b17:	ff d0                	call   *%eax
  800b19:	83 c4 10             	add    $0x10,%esp
  800b1c:	eb 0f                	jmp    800b2d <vprintfmt+0x216>
				else
					putch(ch, putdat);
  800b1e:	83 ec 08             	sub    $0x8,%esp
  800b21:	ff 75 0c             	pushl  0xc(%ebp)
  800b24:	53                   	push   %ebx
  800b25:	8b 45 08             	mov    0x8(%ebp),%eax
  800b28:	ff d0                	call   *%eax
  800b2a:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800b2d:	ff 4d e4             	decl   -0x1c(%ebp)
  800b30:	89 f0                	mov    %esi,%eax
  800b32:	8d 70 01             	lea    0x1(%eax),%esi
  800b35:	8a 00                	mov    (%eax),%al
  800b37:	0f be d8             	movsbl %al,%ebx
  800b3a:	85 db                	test   %ebx,%ebx
  800b3c:	74 24                	je     800b62 <vprintfmt+0x24b>
  800b3e:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800b42:	78 b8                	js     800afc <vprintfmt+0x1e5>
  800b44:	ff 4d e0             	decl   -0x20(%ebp)
  800b47:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800b4b:	79 af                	jns    800afc <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800b4d:	eb 13                	jmp    800b62 <vprintfmt+0x24b>
				putch(' ', putdat);
  800b4f:	83 ec 08             	sub    $0x8,%esp
  800b52:	ff 75 0c             	pushl  0xc(%ebp)
  800b55:	6a 20                	push   $0x20
  800b57:	8b 45 08             	mov    0x8(%ebp),%eax
  800b5a:	ff d0                	call   *%eax
  800b5c:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800b5f:	ff 4d e4             	decl   -0x1c(%ebp)
  800b62:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800b66:	7f e7                	jg     800b4f <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  800b68:	e9 66 01 00 00       	jmp    800cd3 <vprintfmt+0x3bc>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  800b6d:	83 ec 08             	sub    $0x8,%esp
  800b70:	ff 75 e8             	pushl  -0x18(%ebp)
  800b73:	8d 45 14             	lea    0x14(%ebp),%eax
  800b76:	50                   	push   %eax
  800b77:	e8 3c fd ff ff       	call   8008b8 <getint>
  800b7c:	83 c4 10             	add    $0x10,%esp
  800b7f:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800b82:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  800b85:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800b88:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800b8b:	85 d2                	test   %edx,%edx
  800b8d:	79 23                	jns    800bb2 <vprintfmt+0x29b>
				putch('-', putdat);
  800b8f:	83 ec 08             	sub    $0x8,%esp
  800b92:	ff 75 0c             	pushl  0xc(%ebp)
  800b95:	6a 2d                	push   $0x2d
  800b97:	8b 45 08             	mov    0x8(%ebp),%eax
  800b9a:	ff d0                	call   *%eax
  800b9c:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  800b9f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800ba2:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800ba5:	f7 d8                	neg    %eax
  800ba7:	83 d2 00             	adc    $0x0,%edx
  800baa:	f7 da                	neg    %edx
  800bac:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800baf:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  800bb2:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800bb9:	e9 bc 00 00 00       	jmp    800c7a <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  800bbe:	83 ec 08             	sub    $0x8,%esp
  800bc1:	ff 75 e8             	pushl  -0x18(%ebp)
  800bc4:	8d 45 14             	lea    0x14(%ebp),%eax
  800bc7:	50                   	push   %eax
  800bc8:	e8 84 fc ff ff       	call   800851 <getuint>
  800bcd:	83 c4 10             	add    $0x10,%esp
  800bd0:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800bd3:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  800bd6:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800bdd:	e9 98 00 00 00       	jmp    800c7a <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  800be2:	83 ec 08             	sub    $0x8,%esp
  800be5:	ff 75 0c             	pushl  0xc(%ebp)
  800be8:	6a 58                	push   $0x58
  800bea:	8b 45 08             	mov    0x8(%ebp),%eax
  800bed:	ff d0                	call   *%eax
  800bef:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800bf2:	83 ec 08             	sub    $0x8,%esp
  800bf5:	ff 75 0c             	pushl  0xc(%ebp)
  800bf8:	6a 58                	push   $0x58
  800bfa:	8b 45 08             	mov    0x8(%ebp),%eax
  800bfd:	ff d0                	call   *%eax
  800bff:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800c02:	83 ec 08             	sub    $0x8,%esp
  800c05:	ff 75 0c             	pushl  0xc(%ebp)
  800c08:	6a 58                	push   $0x58
  800c0a:	8b 45 08             	mov    0x8(%ebp),%eax
  800c0d:	ff d0                	call   *%eax
  800c0f:	83 c4 10             	add    $0x10,%esp
			break;
  800c12:	e9 bc 00 00 00       	jmp    800cd3 <vprintfmt+0x3bc>

		// pointer
		case 'p':
			putch('0', putdat);
  800c17:	83 ec 08             	sub    $0x8,%esp
  800c1a:	ff 75 0c             	pushl  0xc(%ebp)
  800c1d:	6a 30                	push   $0x30
  800c1f:	8b 45 08             	mov    0x8(%ebp),%eax
  800c22:	ff d0                	call   *%eax
  800c24:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  800c27:	83 ec 08             	sub    $0x8,%esp
  800c2a:	ff 75 0c             	pushl  0xc(%ebp)
  800c2d:	6a 78                	push   $0x78
  800c2f:	8b 45 08             	mov    0x8(%ebp),%eax
  800c32:	ff d0                	call   *%eax
  800c34:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  800c37:	8b 45 14             	mov    0x14(%ebp),%eax
  800c3a:	83 c0 04             	add    $0x4,%eax
  800c3d:	89 45 14             	mov    %eax,0x14(%ebp)
  800c40:	8b 45 14             	mov    0x14(%ebp),%eax
  800c43:	83 e8 04             	sub    $0x4,%eax
  800c46:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800c48:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800c4b:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  800c52:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  800c59:	eb 1f                	jmp    800c7a <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800c5b:	83 ec 08             	sub    $0x8,%esp
  800c5e:	ff 75 e8             	pushl  -0x18(%ebp)
  800c61:	8d 45 14             	lea    0x14(%ebp),%eax
  800c64:	50                   	push   %eax
  800c65:	e8 e7 fb ff ff       	call   800851 <getuint>
  800c6a:	83 c4 10             	add    $0x10,%esp
  800c6d:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800c70:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  800c73:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800c7a:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  800c7e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800c81:	83 ec 04             	sub    $0x4,%esp
  800c84:	52                   	push   %edx
  800c85:	ff 75 e4             	pushl  -0x1c(%ebp)
  800c88:	50                   	push   %eax
  800c89:	ff 75 f4             	pushl  -0xc(%ebp)
  800c8c:	ff 75 f0             	pushl  -0x10(%ebp)
  800c8f:	ff 75 0c             	pushl  0xc(%ebp)
  800c92:	ff 75 08             	pushl  0x8(%ebp)
  800c95:	e8 00 fb ff ff       	call   80079a <printnum>
  800c9a:	83 c4 20             	add    $0x20,%esp
			break;
  800c9d:	eb 34                	jmp    800cd3 <vprintfmt+0x3bc>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  800c9f:	83 ec 08             	sub    $0x8,%esp
  800ca2:	ff 75 0c             	pushl  0xc(%ebp)
  800ca5:	53                   	push   %ebx
  800ca6:	8b 45 08             	mov    0x8(%ebp),%eax
  800ca9:	ff d0                	call   *%eax
  800cab:	83 c4 10             	add    $0x10,%esp
			break;
  800cae:	eb 23                	jmp    800cd3 <vprintfmt+0x3bc>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800cb0:	83 ec 08             	sub    $0x8,%esp
  800cb3:	ff 75 0c             	pushl  0xc(%ebp)
  800cb6:	6a 25                	push   $0x25
  800cb8:	8b 45 08             	mov    0x8(%ebp),%eax
  800cbb:	ff d0                	call   *%eax
  800cbd:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  800cc0:	ff 4d 10             	decl   0x10(%ebp)
  800cc3:	eb 03                	jmp    800cc8 <vprintfmt+0x3b1>
  800cc5:	ff 4d 10             	decl   0x10(%ebp)
  800cc8:	8b 45 10             	mov    0x10(%ebp),%eax
  800ccb:	48                   	dec    %eax
  800ccc:	8a 00                	mov    (%eax),%al
  800cce:	3c 25                	cmp    $0x25,%al
  800cd0:	75 f3                	jne    800cc5 <vprintfmt+0x3ae>
				/* do nothing */;
			break;
  800cd2:	90                   	nop
		}
	}
  800cd3:	e9 47 fc ff ff       	jmp    80091f <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  800cd8:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  800cd9:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800cdc:	5b                   	pop    %ebx
  800cdd:	5e                   	pop    %esi
  800cde:	5d                   	pop    %ebp
  800cdf:	c3                   	ret    

00800ce0 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800ce0:	55                   	push   %ebp
  800ce1:	89 e5                	mov    %esp,%ebp
  800ce3:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  800ce6:	8d 45 10             	lea    0x10(%ebp),%eax
  800ce9:	83 c0 04             	add    $0x4,%eax
  800cec:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  800cef:	8b 45 10             	mov    0x10(%ebp),%eax
  800cf2:	ff 75 f4             	pushl  -0xc(%ebp)
  800cf5:	50                   	push   %eax
  800cf6:	ff 75 0c             	pushl  0xc(%ebp)
  800cf9:	ff 75 08             	pushl  0x8(%ebp)
  800cfc:	e8 16 fc ff ff       	call   800917 <vprintfmt>
  800d01:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  800d04:	90                   	nop
  800d05:	c9                   	leave  
  800d06:	c3                   	ret    

00800d07 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800d07:	55                   	push   %ebp
  800d08:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  800d0a:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d0d:	8b 40 08             	mov    0x8(%eax),%eax
  800d10:	8d 50 01             	lea    0x1(%eax),%edx
  800d13:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d16:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  800d19:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d1c:	8b 10                	mov    (%eax),%edx
  800d1e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d21:	8b 40 04             	mov    0x4(%eax),%eax
  800d24:	39 c2                	cmp    %eax,%edx
  800d26:	73 12                	jae    800d3a <sprintputch+0x33>
		*b->buf++ = ch;
  800d28:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d2b:	8b 00                	mov    (%eax),%eax
  800d2d:	8d 48 01             	lea    0x1(%eax),%ecx
  800d30:	8b 55 0c             	mov    0xc(%ebp),%edx
  800d33:	89 0a                	mov    %ecx,(%edx)
  800d35:	8b 55 08             	mov    0x8(%ebp),%edx
  800d38:	88 10                	mov    %dl,(%eax)
}
  800d3a:	90                   	nop
  800d3b:	5d                   	pop    %ebp
  800d3c:	c3                   	ret    

00800d3d <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800d3d:	55                   	push   %ebp
  800d3e:	89 e5                	mov    %esp,%ebp
  800d40:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  800d43:	8b 45 08             	mov    0x8(%ebp),%eax
  800d46:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800d49:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d4c:	8d 50 ff             	lea    -0x1(%eax),%edx
  800d4f:	8b 45 08             	mov    0x8(%ebp),%eax
  800d52:	01 d0                	add    %edx,%eax
  800d54:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800d57:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800d5e:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800d62:	74 06                	je     800d6a <vsnprintf+0x2d>
  800d64:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800d68:	7f 07                	jg     800d71 <vsnprintf+0x34>
		return -E_INVAL;
  800d6a:	b8 03 00 00 00       	mov    $0x3,%eax
  800d6f:	eb 20                	jmp    800d91 <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800d71:	ff 75 14             	pushl  0x14(%ebp)
  800d74:	ff 75 10             	pushl  0x10(%ebp)
  800d77:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800d7a:	50                   	push   %eax
  800d7b:	68 07 0d 80 00       	push   $0x800d07
  800d80:	e8 92 fb ff ff       	call   800917 <vprintfmt>
  800d85:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  800d88:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800d8b:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800d8e:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  800d91:	c9                   	leave  
  800d92:	c3                   	ret    

00800d93 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800d93:	55                   	push   %ebp
  800d94:	89 e5                	mov    %esp,%ebp
  800d96:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800d99:	8d 45 10             	lea    0x10(%ebp),%eax
  800d9c:	83 c0 04             	add    $0x4,%eax
  800d9f:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  800da2:	8b 45 10             	mov    0x10(%ebp),%eax
  800da5:	ff 75 f4             	pushl  -0xc(%ebp)
  800da8:	50                   	push   %eax
  800da9:	ff 75 0c             	pushl  0xc(%ebp)
  800dac:	ff 75 08             	pushl  0x8(%ebp)
  800daf:	e8 89 ff ff ff       	call   800d3d <vsnprintf>
  800db4:	83 c4 10             	add    $0x10,%esp
  800db7:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  800dba:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800dbd:	c9                   	leave  
  800dbe:	c3                   	ret    

00800dbf <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  800dbf:	55                   	push   %ebp
  800dc0:	89 e5                	mov    %esp,%ebp
  800dc2:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  800dc5:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800dcc:	eb 06                	jmp    800dd4 <strlen+0x15>
		n++;
  800dce:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800dd1:	ff 45 08             	incl   0x8(%ebp)
  800dd4:	8b 45 08             	mov    0x8(%ebp),%eax
  800dd7:	8a 00                	mov    (%eax),%al
  800dd9:	84 c0                	test   %al,%al
  800ddb:	75 f1                	jne    800dce <strlen+0xf>
		n++;
	return n;
  800ddd:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800de0:	c9                   	leave  
  800de1:	c3                   	ret    

00800de2 <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  800de2:	55                   	push   %ebp
  800de3:	89 e5                	mov    %esp,%ebp
  800de5:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800de8:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800def:	eb 09                	jmp    800dfa <strnlen+0x18>
		n++;
  800df1:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800df4:	ff 45 08             	incl   0x8(%ebp)
  800df7:	ff 4d 0c             	decl   0xc(%ebp)
  800dfa:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800dfe:	74 09                	je     800e09 <strnlen+0x27>
  800e00:	8b 45 08             	mov    0x8(%ebp),%eax
  800e03:	8a 00                	mov    (%eax),%al
  800e05:	84 c0                	test   %al,%al
  800e07:	75 e8                	jne    800df1 <strnlen+0xf>
		n++;
	return n;
  800e09:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800e0c:	c9                   	leave  
  800e0d:	c3                   	ret    

00800e0e <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800e0e:	55                   	push   %ebp
  800e0f:	89 e5                	mov    %esp,%ebp
  800e11:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  800e14:	8b 45 08             	mov    0x8(%ebp),%eax
  800e17:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  800e1a:	90                   	nop
  800e1b:	8b 45 08             	mov    0x8(%ebp),%eax
  800e1e:	8d 50 01             	lea    0x1(%eax),%edx
  800e21:	89 55 08             	mov    %edx,0x8(%ebp)
  800e24:	8b 55 0c             	mov    0xc(%ebp),%edx
  800e27:	8d 4a 01             	lea    0x1(%edx),%ecx
  800e2a:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800e2d:	8a 12                	mov    (%edx),%dl
  800e2f:	88 10                	mov    %dl,(%eax)
  800e31:	8a 00                	mov    (%eax),%al
  800e33:	84 c0                	test   %al,%al
  800e35:	75 e4                	jne    800e1b <strcpy+0xd>
		/* do nothing */;
	return ret;
  800e37:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800e3a:	c9                   	leave  
  800e3b:	c3                   	ret    

00800e3c <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  800e3c:	55                   	push   %ebp
  800e3d:	89 e5                	mov    %esp,%ebp
  800e3f:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  800e42:	8b 45 08             	mov    0x8(%ebp),%eax
  800e45:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  800e48:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800e4f:	eb 1f                	jmp    800e70 <strncpy+0x34>
		*dst++ = *src;
  800e51:	8b 45 08             	mov    0x8(%ebp),%eax
  800e54:	8d 50 01             	lea    0x1(%eax),%edx
  800e57:	89 55 08             	mov    %edx,0x8(%ebp)
  800e5a:	8b 55 0c             	mov    0xc(%ebp),%edx
  800e5d:	8a 12                	mov    (%edx),%dl
  800e5f:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  800e61:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e64:	8a 00                	mov    (%eax),%al
  800e66:	84 c0                	test   %al,%al
  800e68:	74 03                	je     800e6d <strncpy+0x31>
			src++;
  800e6a:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800e6d:	ff 45 fc             	incl   -0x4(%ebp)
  800e70:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800e73:	3b 45 10             	cmp    0x10(%ebp),%eax
  800e76:	72 d9                	jb     800e51 <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  800e78:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  800e7b:	c9                   	leave  
  800e7c:	c3                   	ret    

00800e7d <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  800e7d:	55                   	push   %ebp
  800e7e:	89 e5                	mov    %esp,%ebp
  800e80:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  800e83:	8b 45 08             	mov    0x8(%ebp),%eax
  800e86:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  800e89:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800e8d:	74 30                	je     800ebf <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  800e8f:	eb 16                	jmp    800ea7 <strlcpy+0x2a>
			*dst++ = *src++;
  800e91:	8b 45 08             	mov    0x8(%ebp),%eax
  800e94:	8d 50 01             	lea    0x1(%eax),%edx
  800e97:	89 55 08             	mov    %edx,0x8(%ebp)
  800e9a:	8b 55 0c             	mov    0xc(%ebp),%edx
  800e9d:	8d 4a 01             	lea    0x1(%edx),%ecx
  800ea0:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800ea3:	8a 12                	mov    (%edx),%dl
  800ea5:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800ea7:	ff 4d 10             	decl   0x10(%ebp)
  800eaa:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800eae:	74 09                	je     800eb9 <strlcpy+0x3c>
  800eb0:	8b 45 0c             	mov    0xc(%ebp),%eax
  800eb3:	8a 00                	mov    (%eax),%al
  800eb5:	84 c0                	test   %al,%al
  800eb7:	75 d8                	jne    800e91 <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  800eb9:	8b 45 08             	mov    0x8(%ebp),%eax
  800ebc:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800ebf:	8b 55 08             	mov    0x8(%ebp),%edx
  800ec2:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800ec5:	29 c2                	sub    %eax,%edx
  800ec7:	89 d0                	mov    %edx,%eax
}
  800ec9:	c9                   	leave  
  800eca:	c3                   	ret    

00800ecb <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800ecb:	55                   	push   %ebp
  800ecc:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  800ece:	eb 06                	jmp    800ed6 <strcmp+0xb>
		p++, q++;
  800ed0:	ff 45 08             	incl   0x8(%ebp)
  800ed3:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  800ed6:	8b 45 08             	mov    0x8(%ebp),%eax
  800ed9:	8a 00                	mov    (%eax),%al
  800edb:	84 c0                	test   %al,%al
  800edd:	74 0e                	je     800eed <strcmp+0x22>
  800edf:	8b 45 08             	mov    0x8(%ebp),%eax
  800ee2:	8a 10                	mov    (%eax),%dl
  800ee4:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ee7:	8a 00                	mov    (%eax),%al
  800ee9:	38 c2                	cmp    %al,%dl
  800eeb:	74 e3                	je     800ed0 <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800eed:	8b 45 08             	mov    0x8(%ebp),%eax
  800ef0:	8a 00                	mov    (%eax),%al
  800ef2:	0f b6 d0             	movzbl %al,%edx
  800ef5:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ef8:	8a 00                	mov    (%eax),%al
  800efa:	0f b6 c0             	movzbl %al,%eax
  800efd:	29 c2                	sub    %eax,%edx
  800eff:	89 d0                	mov    %edx,%eax
}
  800f01:	5d                   	pop    %ebp
  800f02:	c3                   	ret    

00800f03 <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  800f03:	55                   	push   %ebp
  800f04:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  800f06:	eb 09                	jmp    800f11 <strncmp+0xe>
		n--, p++, q++;
  800f08:	ff 4d 10             	decl   0x10(%ebp)
  800f0b:	ff 45 08             	incl   0x8(%ebp)
  800f0e:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  800f11:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800f15:	74 17                	je     800f2e <strncmp+0x2b>
  800f17:	8b 45 08             	mov    0x8(%ebp),%eax
  800f1a:	8a 00                	mov    (%eax),%al
  800f1c:	84 c0                	test   %al,%al
  800f1e:	74 0e                	je     800f2e <strncmp+0x2b>
  800f20:	8b 45 08             	mov    0x8(%ebp),%eax
  800f23:	8a 10                	mov    (%eax),%dl
  800f25:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f28:	8a 00                	mov    (%eax),%al
  800f2a:	38 c2                	cmp    %al,%dl
  800f2c:	74 da                	je     800f08 <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  800f2e:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800f32:	75 07                	jne    800f3b <strncmp+0x38>
		return 0;
  800f34:	b8 00 00 00 00       	mov    $0x0,%eax
  800f39:	eb 14                	jmp    800f4f <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800f3b:	8b 45 08             	mov    0x8(%ebp),%eax
  800f3e:	8a 00                	mov    (%eax),%al
  800f40:	0f b6 d0             	movzbl %al,%edx
  800f43:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f46:	8a 00                	mov    (%eax),%al
  800f48:	0f b6 c0             	movzbl %al,%eax
  800f4b:	29 c2                	sub    %eax,%edx
  800f4d:	89 d0                	mov    %edx,%eax
}
  800f4f:	5d                   	pop    %ebp
  800f50:	c3                   	ret    

00800f51 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800f51:	55                   	push   %ebp
  800f52:	89 e5                	mov    %esp,%ebp
  800f54:	83 ec 04             	sub    $0x4,%esp
  800f57:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f5a:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800f5d:	eb 12                	jmp    800f71 <strchr+0x20>
		if (*s == c)
  800f5f:	8b 45 08             	mov    0x8(%ebp),%eax
  800f62:	8a 00                	mov    (%eax),%al
  800f64:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800f67:	75 05                	jne    800f6e <strchr+0x1d>
			return (char *) s;
  800f69:	8b 45 08             	mov    0x8(%ebp),%eax
  800f6c:	eb 11                	jmp    800f7f <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  800f6e:	ff 45 08             	incl   0x8(%ebp)
  800f71:	8b 45 08             	mov    0x8(%ebp),%eax
  800f74:	8a 00                	mov    (%eax),%al
  800f76:	84 c0                	test   %al,%al
  800f78:	75 e5                	jne    800f5f <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  800f7a:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800f7f:	c9                   	leave  
  800f80:	c3                   	ret    

00800f81 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800f81:	55                   	push   %ebp
  800f82:	89 e5                	mov    %esp,%ebp
  800f84:	83 ec 04             	sub    $0x4,%esp
  800f87:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f8a:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800f8d:	eb 0d                	jmp    800f9c <strfind+0x1b>
		if (*s == c)
  800f8f:	8b 45 08             	mov    0x8(%ebp),%eax
  800f92:	8a 00                	mov    (%eax),%al
  800f94:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800f97:	74 0e                	je     800fa7 <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  800f99:	ff 45 08             	incl   0x8(%ebp)
  800f9c:	8b 45 08             	mov    0x8(%ebp),%eax
  800f9f:	8a 00                	mov    (%eax),%al
  800fa1:	84 c0                	test   %al,%al
  800fa3:	75 ea                	jne    800f8f <strfind+0xe>
  800fa5:	eb 01                	jmp    800fa8 <strfind+0x27>
		if (*s == c)
			break;
  800fa7:	90                   	nop
	return (char *) s;
  800fa8:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800fab:	c9                   	leave  
  800fac:	c3                   	ret    

00800fad <memset>:


void *
memset(void *v, int c, uint32 n)
{
  800fad:	55                   	push   %ebp
  800fae:	89 e5                	mov    %esp,%ebp
  800fb0:	83 ec 10             	sub    $0x10,%esp
	char *p;
	int m;

	p = v;
  800fb3:	8b 45 08             	mov    0x8(%ebp),%eax
  800fb6:	89 45 fc             	mov    %eax,-0x4(%ebp)
	m = n;
  800fb9:	8b 45 10             	mov    0x10(%ebp),%eax
  800fbc:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (--m >= 0)
  800fbf:	eb 0e                	jmp    800fcf <memset+0x22>
		*p++ = c;
  800fc1:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800fc4:	8d 50 01             	lea    0x1(%eax),%edx
  800fc7:	89 55 fc             	mov    %edx,-0x4(%ebp)
  800fca:	8b 55 0c             	mov    0xc(%ebp),%edx
  800fcd:	88 10                	mov    %dl,(%eax)
	char *p;
	int m;

	p = v;
	m = n;
	while (--m >= 0)
  800fcf:	ff 4d f8             	decl   -0x8(%ebp)
  800fd2:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  800fd6:	79 e9                	jns    800fc1 <memset+0x14>
		*p++ = c;

	return v;
  800fd8:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800fdb:	c9                   	leave  
  800fdc:	c3                   	ret    

00800fdd <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  800fdd:	55                   	push   %ebp
  800fde:	89 e5                	mov    %esp,%ebp
  800fe0:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800fe3:	8b 45 0c             	mov    0xc(%ebp),%eax
  800fe6:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800fe9:	8b 45 08             	mov    0x8(%ebp),%eax
  800fec:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (n-- > 0)
  800fef:	eb 16                	jmp    801007 <memcpy+0x2a>
		*d++ = *s++;
  800ff1:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800ff4:	8d 50 01             	lea    0x1(%eax),%edx
  800ff7:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800ffa:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800ffd:	8d 4a 01             	lea    0x1(%edx),%ecx
  801000:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  801003:	8a 12                	mov    (%edx),%dl
  801005:	88 10                	mov    %dl,(%eax)
	const char *s;
	char *d;

	s = src;
	d = dst;
	while (n-- > 0)
  801007:	8b 45 10             	mov    0x10(%ebp),%eax
  80100a:	8d 50 ff             	lea    -0x1(%eax),%edx
  80100d:	89 55 10             	mov    %edx,0x10(%ebp)
  801010:	85 c0                	test   %eax,%eax
  801012:	75 dd                	jne    800ff1 <memcpy+0x14>
		*d++ = *s++;

	return dst;
  801014:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801017:	c9                   	leave  
  801018:	c3                   	ret    

00801019 <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  801019:	55                   	push   %ebp
  80101a:	89 e5                	mov    %esp,%ebp
  80101c:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  80101f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801022:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  801025:	8b 45 08             	mov    0x8(%ebp),%eax
  801028:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  80102b:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80102e:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  801031:	73 50                	jae    801083 <memmove+0x6a>
  801033:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801036:	8b 45 10             	mov    0x10(%ebp),%eax
  801039:	01 d0                	add    %edx,%eax
  80103b:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  80103e:	76 43                	jbe    801083 <memmove+0x6a>
		s += n;
  801040:	8b 45 10             	mov    0x10(%ebp),%eax
  801043:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  801046:	8b 45 10             	mov    0x10(%ebp),%eax
  801049:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  80104c:	eb 10                	jmp    80105e <memmove+0x45>
			*--d = *--s;
  80104e:	ff 4d f8             	decl   -0x8(%ebp)
  801051:	ff 4d fc             	decl   -0x4(%ebp)
  801054:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801057:	8a 10                	mov    (%eax),%dl
  801059:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80105c:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  80105e:	8b 45 10             	mov    0x10(%ebp),%eax
  801061:	8d 50 ff             	lea    -0x1(%eax),%edx
  801064:	89 55 10             	mov    %edx,0x10(%ebp)
  801067:	85 c0                	test   %eax,%eax
  801069:	75 e3                	jne    80104e <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  80106b:	eb 23                	jmp    801090 <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  80106d:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801070:	8d 50 01             	lea    0x1(%eax),%edx
  801073:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801076:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801079:	8d 4a 01             	lea    0x1(%edx),%ecx
  80107c:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  80107f:	8a 12                	mov    (%edx),%dl
  801081:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  801083:	8b 45 10             	mov    0x10(%ebp),%eax
  801086:	8d 50 ff             	lea    -0x1(%eax),%edx
  801089:	89 55 10             	mov    %edx,0x10(%ebp)
  80108c:	85 c0                	test   %eax,%eax
  80108e:	75 dd                	jne    80106d <memmove+0x54>
			*d++ = *s++;

	return dst;
  801090:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801093:	c9                   	leave  
  801094:	c3                   	ret    

00801095 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  801095:	55                   	push   %ebp
  801096:	89 e5                	mov    %esp,%ebp
  801098:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  80109b:	8b 45 08             	mov    0x8(%ebp),%eax
  80109e:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  8010a1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010a4:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  8010a7:	eb 2a                	jmp    8010d3 <memcmp+0x3e>
		if (*s1 != *s2)
  8010a9:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8010ac:	8a 10                	mov    (%eax),%dl
  8010ae:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8010b1:	8a 00                	mov    (%eax),%al
  8010b3:	38 c2                	cmp    %al,%dl
  8010b5:	74 16                	je     8010cd <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  8010b7:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8010ba:	8a 00                	mov    (%eax),%al
  8010bc:	0f b6 d0             	movzbl %al,%edx
  8010bf:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8010c2:	8a 00                	mov    (%eax),%al
  8010c4:	0f b6 c0             	movzbl %al,%eax
  8010c7:	29 c2                	sub    %eax,%edx
  8010c9:	89 d0                	mov    %edx,%eax
  8010cb:	eb 18                	jmp    8010e5 <memcmp+0x50>
		s1++, s2++;
  8010cd:	ff 45 fc             	incl   -0x4(%ebp)
  8010d0:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  8010d3:	8b 45 10             	mov    0x10(%ebp),%eax
  8010d6:	8d 50 ff             	lea    -0x1(%eax),%edx
  8010d9:	89 55 10             	mov    %edx,0x10(%ebp)
  8010dc:	85 c0                	test   %eax,%eax
  8010de:	75 c9                	jne    8010a9 <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  8010e0:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8010e5:	c9                   	leave  
  8010e6:	c3                   	ret    

008010e7 <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  8010e7:	55                   	push   %ebp
  8010e8:	89 e5                	mov    %esp,%ebp
  8010ea:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  8010ed:	8b 55 08             	mov    0x8(%ebp),%edx
  8010f0:	8b 45 10             	mov    0x10(%ebp),%eax
  8010f3:	01 d0                	add    %edx,%eax
  8010f5:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  8010f8:	eb 15                	jmp    80110f <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  8010fa:	8b 45 08             	mov    0x8(%ebp),%eax
  8010fd:	8a 00                	mov    (%eax),%al
  8010ff:	0f b6 d0             	movzbl %al,%edx
  801102:	8b 45 0c             	mov    0xc(%ebp),%eax
  801105:	0f b6 c0             	movzbl %al,%eax
  801108:	39 c2                	cmp    %eax,%edx
  80110a:	74 0d                	je     801119 <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  80110c:	ff 45 08             	incl   0x8(%ebp)
  80110f:	8b 45 08             	mov    0x8(%ebp),%eax
  801112:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  801115:	72 e3                	jb     8010fa <memfind+0x13>
  801117:	eb 01                	jmp    80111a <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  801119:	90                   	nop
	return (void *) s;
  80111a:	8b 45 08             	mov    0x8(%ebp),%eax
}
  80111d:	c9                   	leave  
  80111e:	c3                   	ret    

0080111f <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  80111f:	55                   	push   %ebp
  801120:	89 e5                	mov    %esp,%ebp
  801122:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  801125:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  80112c:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801133:	eb 03                	jmp    801138 <strtol+0x19>
		s++;
  801135:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801138:	8b 45 08             	mov    0x8(%ebp),%eax
  80113b:	8a 00                	mov    (%eax),%al
  80113d:	3c 20                	cmp    $0x20,%al
  80113f:	74 f4                	je     801135 <strtol+0x16>
  801141:	8b 45 08             	mov    0x8(%ebp),%eax
  801144:	8a 00                	mov    (%eax),%al
  801146:	3c 09                	cmp    $0x9,%al
  801148:	74 eb                	je     801135 <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  80114a:	8b 45 08             	mov    0x8(%ebp),%eax
  80114d:	8a 00                	mov    (%eax),%al
  80114f:	3c 2b                	cmp    $0x2b,%al
  801151:	75 05                	jne    801158 <strtol+0x39>
		s++;
  801153:	ff 45 08             	incl   0x8(%ebp)
  801156:	eb 13                	jmp    80116b <strtol+0x4c>
	else if (*s == '-')
  801158:	8b 45 08             	mov    0x8(%ebp),%eax
  80115b:	8a 00                	mov    (%eax),%al
  80115d:	3c 2d                	cmp    $0x2d,%al
  80115f:	75 0a                	jne    80116b <strtol+0x4c>
		s++, neg = 1;
  801161:	ff 45 08             	incl   0x8(%ebp)
  801164:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  80116b:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80116f:	74 06                	je     801177 <strtol+0x58>
  801171:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  801175:	75 20                	jne    801197 <strtol+0x78>
  801177:	8b 45 08             	mov    0x8(%ebp),%eax
  80117a:	8a 00                	mov    (%eax),%al
  80117c:	3c 30                	cmp    $0x30,%al
  80117e:	75 17                	jne    801197 <strtol+0x78>
  801180:	8b 45 08             	mov    0x8(%ebp),%eax
  801183:	40                   	inc    %eax
  801184:	8a 00                	mov    (%eax),%al
  801186:	3c 78                	cmp    $0x78,%al
  801188:	75 0d                	jne    801197 <strtol+0x78>
		s += 2, base = 16;
  80118a:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  80118e:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  801195:	eb 28                	jmp    8011bf <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  801197:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80119b:	75 15                	jne    8011b2 <strtol+0x93>
  80119d:	8b 45 08             	mov    0x8(%ebp),%eax
  8011a0:	8a 00                	mov    (%eax),%al
  8011a2:	3c 30                	cmp    $0x30,%al
  8011a4:	75 0c                	jne    8011b2 <strtol+0x93>
		s++, base = 8;
  8011a6:	ff 45 08             	incl   0x8(%ebp)
  8011a9:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  8011b0:	eb 0d                	jmp    8011bf <strtol+0xa0>
	else if (base == 0)
  8011b2:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8011b6:	75 07                	jne    8011bf <strtol+0xa0>
		base = 10;
  8011b8:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  8011bf:	8b 45 08             	mov    0x8(%ebp),%eax
  8011c2:	8a 00                	mov    (%eax),%al
  8011c4:	3c 2f                	cmp    $0x2f,%al
  8011c6:	7e 19                	jle    8011e1 <strtol+0xc2>
  8011c8:	8b 45 08             	mov    0x8(%ebp),%eax
  8011cb:	8a 00                	mov    (%eax),%al
  8011cd:	3c 39                	cmp    $0x39,%al
  8011cf:	7f 10                	jg     8011e1 <strtol+0xc2>
			dig = *s - '0';
  8011d1:	8b 45 08             	mov    0x8(%ebp),%eax
  8011d4:	8a 00                	mov    (%eax),%al
  8011d6:	0f be c0             	movsbl %al,%eax
  8011d9:	83 e8 30             	sub    $0x30,%eax
  8011dc:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8011df:	eb 42                	jmp    801223 <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  8011e1:	8b 45 08             	mov    0x8(%ebp),%eax
  8011e4:	8a 00                	mov    (%eax),%al
  8011e6:	3c 60                	cmp    $0x60,%al
  8011e8:	7e 19                	jle    801203 <strtol+0xe4>
  8011ea:	8b 45 08             	mov    0x8(%ebp),%eax
  8011ed:	8a 00                	mov    (%eax),%al
  8011ef:	3c 7a                	cmp    $0x7a,%al
  8011f1:	7f 10                	jg     801203 <strtol+0xe4>
			dig = *s - 'a' + 10;
  8011f3:	8b 45 08             	mov    0x8(%ebp),%eax
  8011f6:	8a 00                	mov    (%eax),%al
  8011f8:	0f be c0             	movsbl %al,%eax
  8011fb:	83 e8 57             	sub    $0x57,%eax
  8011fe:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801201:	eb 20                	jmp    801223 <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  801203:	8b 45 08             	mov    0x8(%ebp),%eax
  801206:	8a 00                	mov    (%eax),%al
  801208:	3c 40                	cmp    $0x40,%al
  80120a:	7e 39                	jle    801245 <strtol+0x126>
  80120c:	8b 45 08             	mov    0x8(%ebp),%eax
  80120f:	8a 00                	mov    (%eax),%al
  801211:	3c 5a                	cmp    $0x5a,%al
  801213:	7f 30                	jg     801245 <strtol+0x126>
			dig = *s - 'A' + 10;
  801215:	8b 45 08             	mov    0x8(%ebp),%eax
  801218:	8a 00                	mov    (%eax),%al
  80121a:	0f be c0             	movsbl %al,%eax
  80121d:	83 e8 37             	sub    $0x37,%eax
  801220:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  801223:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801226:	3b 45 10             	cmp    0x10(%ebp),%eax
  801229:	7d 19                	jge    801244 <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  80122b:	ff 45 08             	incl   0x8(%ebp)
  80122e:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801231:	0f af 45 10          	imul   0x10(%ebp),%eax
  801235:	89 c2                	mov    %eax,%edx
  801237:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80123a:	01 d0                	add    %edx,%eax
  80123c:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  80123f:	e9 7b ff ff ff       	jmp    8011bf <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  801244:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  801245:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801249:	74 08                	je     801253 <strtol+0x134>
		*endptr = (char *) s;
  80124b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80124e:	8b 55 08             	mov    0x8(%ebp),%edx
  801251:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  801253:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801257:	74 07                	je     801260 <strtol+0x141>
  801259:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80125c:	f7 d8                	neg    %eax
  80125e:	eb 03                	jmp    801263 <strtol+0x144>
  801260:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  801263:	c9                   	leave  
  801264:	c3                   	ret    

00801265 <ltostr>:

void
ltostr(long value, char *str)
{
  801265:	55                   	push   %ebp
  801266:	89 e5                	mov    %esp,%ebp
  801268:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  80126b:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  801272:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  801279:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80127d:	79 13                	jns    801292 <ltostr+0x2d>
	{
		neg = 1;
  80127f:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  801286:	8b 45 0c             	mov    0xc(%ebp),%eax
  801289:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  80128c:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  80128f:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  801292:	8b 45 08             	mov    0x8(%ebp),%eax
  801295:	b9 0a 00 00 00       	mov    $0xa,%ecx
  80129a:	99                   	cltd   
  80129b:	f7 f9                	idiv   %ecx
  80129d:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  8012a0:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8012a3:	8d 50 01             	lea    0x1(%eax),%edx
  8012a6:	89 55 f8             	mov    %edx,-0x8(%ebp)
  8012a9:	89 c2                	mov    %eax,%edx
  8012ab:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012ae:	01 d0                	add    %edx,%eax
  8012b0:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8012b3:	83 c2 30             	add    $0x30,%edx
  8012b6:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  8012b8:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8012bb:	b8 67 66 66 66       	mov    $0x66666667,%eax
  8012c0:	f7 e9                	imul   %ecx
  8012c2:	c1 fa 02             	sar    $0x2,%edx
  8012c5:	89 c8                	mov    %ecx,%eax
  8012c7:	c1 f8 1f             	sar    $0x1f,%eax
  8012ca:	29 c2                	sub    %eax,%edx
  8012cc:	89 d0                	mov    %edx,%eax
  8012ce:	89 45 08             	mov    %eax,0x8(%ebp)
	} while (value % 10 != 0);
  8012d1:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8012d4:	b8 67 66 66 66       	mov    $0x66666667,%eax
  8012d9:	f7 e9                	imul   %ecx
  8012db:	c1 fa 02             	sar    $0x2,%edx
  8012de:	89 c8                	mov    %ecx,%eax
  8012e0:	c1 f8 1f             	sar    $0x1f,%eax
  8012e3:	29 c2                	sub    %eax,%edx
  8012e5:	89 d0                	mov    %edx,%eax
  8012e7:	c1 e0 02             	shl    $0x2,%eax
  8012ea:	01 d0                	add    %edx,%eax
  8012ec:	01 c0                	add    %eax,%eax
  8012ee:	29 c1                	sub    %eax,%ecx
  8012f0:	89 ca                	mov    %ecx,%edx
  8012f2:	85 d2                	test   %edx,%edx
  8012f4:	75 9c                	jne    801292 <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  8012f6:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  8012fd:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801300:	48                   	dec    %eax
  801301:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  801304:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801308:	74 3d                	je     801347 <ltostr+0xe2>
		start = 1 ;
  80130a:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  801311:	eb 34                	jmp    801347 <ltostr+0xe2>
	{
		char tmp = str[start] ;
  801313:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801316:	8b 45 0c             	mov    0xc(%ebp),%eax
  801319:	01 d0                	add    %edx,%eax
  80131b:	8a 00                	mov    (%eax),%al
  80131d:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  801320:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801323:	8b 45 0c             	mov    0xc(%ebp),%eax
  801326:	01 c2                	add    %eax,%edx
  801328:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  80132b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80132e:	01 c8                	add    %ecx,%eax
  801330:	8a 00                	mov    (%eax),%al
  801332:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  801334:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801337:	8b 45 0c             	mov    0xc(%ebp),%eax
  80133a:	01 c2                	add    %eax,%edx
  80133c:	8a 45 eb             	mov    -0x15(%ebp),%al
  80133f:	88 02                	mov    %al,(%edx)
		start++ ;
  801341:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  801344:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  801347:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80134a:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80134d:	7c c4                	jl     801313 <ltostr+0xae>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  80134f:	8b 55 f8             	mov    -0x8(%ebp),%edx
  801352:	8b 45 0c             	mov    0xc(%ebp),%eax
  801355:	01 d0                	add    %edx,%eax
  801357:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  80135a:	90                   	nop
  80135b:	c9                   	leave  
  80135c:	c3                   	ret    

0080135d <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  80135d:	55                   	push   %ebp
  80135e:	89 e5                	mov    %esp,%ebp
  801360:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  801363:	ff 75 08             	pushl  0x8(%ebp)
  801366:	e8 54 fa ff ff       	call   800dbf <strlen>
  80136b:	83 c4 04             	add    $0x4,%esp
  80136e:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  801371:	ff 75 0c             	pushl  0xc(%ebp)
  801374:	e8 46 fa ff ff       	call   800dbf <strlen>
  801379:	83 c4 04             	add    $0x4,%esp
  80137c:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  80137f:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  801386:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  80138d:	eb 17                	jmp    8013a6 <strcconcat+0x49>
		final[s] = str1[s] ;
  80138f:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801392:	8b 45 10             	mov    0x10(%ebp),%eax
  801395:	01 c2                	add    %eax,%edx
  801397:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  80139a:	8b 45 08             	mov    0x8(%ebp),%eax
  80139d:	01 c8                	add    %ecx,%eax
  80139f:	8a 00                	mov    (%eax),%al
  8013a1:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  8013a3:	ff 45 fc             	incl   -0x4(%ebp)
  8013a6:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8013a9:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  8013ac:	7c e1                	jl     80138f <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  8013ae:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  8013b5:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  8013bc:	eb 1f                	jmp    8013dd <strcconcat+0x80>
		final[s++] = str2[i] ;
  8013be:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8013c1:	8d 50 01             	lea    0x1(%eax),%edx
  8013c4:	89 55 fc             	mov    %edx,-0x4(%ebp)
  8013c7:	89 c2                	mov    %eax,%edx
  8013c9:	8b 45 10             	mov    0x10(%ebp),%eax
  8013cc:	01 c2                	add    %eax,%edx
  8013ce:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  8013d1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8013d4:	01 c8                	add    %ecx,%eax
  8013d6:	8a 00                	mov    (%eax),%al
  8013d8:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  8013da:	ff 45 f8             	incl   -0x8(%ebp)
  8013dd:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8013e0:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8013e3:	7c d9                	jl     8013be <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  8013e5:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8013e8:	8b 45 10             	mov    0x10(%ebp),%eax
  8013eb:	01 d0                	add    %edx,%eax
  8013ed:	c6 00 00             	movb   $0x0,(%eax)
}
  8013f0:	90                   	nop
  8013f1:	c9                   	leave  
  8013f2:	c3                   	ret    

008013f3 <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  8013f3:	55                   	push   %ebp
  8013f4:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  8013f6:	8b 45 14             	mov    0x14(%ebp),%eax
  8013f9:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  8013ff:	8b 45 14             	mov    0x14(%ebp),%eax
  801402:	8b 00                	mov    (%eax),%eax
  801404:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80140b:	8b 45 10             	mov    0x10(%ebp),%eax
  80140e:	01 d0                	add    %edx,%eax
  801410:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801416:	eb 0c                	jmp    801424 <strsplit+0x31>
			*string++ = 0;
  801418:	8b 45 08             	mov    0x8(%ebp),%eax
  80141b:	8d 50 01             	lea    0x1(%eax),%edx
  80141e:	89 55 08             	mov    %edx,0x8(%ebp)
  801421:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801424:	8b 45 08             	mov    0x8(%ebp),%eax
  801427:	8a 00                	mov    (%eax),%al
  801429:	84 c0                	test   %al,%al
  80142b:	74 18                	je     801445 <strsplit+0x52>
  80142d:	8b 45 08             	mov    0x8(%ebp),%eax
  801430:	8a 00                	mov    (%eax),%al
  801432:	0f be c0             	movsbl %al,%eax
  801435:	50                   	push   %eax
  801436:	ff 75 0c             	pushl  0xc(%ebp)
  801439:	e8 13 fb ff ff       	call   800f51 <strchr>
  80143e:	83 c4 08             	add    $0x8,%esp
  801441:	85 c0                	test   %eax,%eax
  801443:	75 d3                	jne    801418 <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  801445:	8b 45 08             	mov    0x8(%ebp),%eax
  801448:	8a 00                	mov    (%eax),%al
  80144a:	84 c0                	test   %al,%al
  80144c:	74 5a                	je     8014a8 <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  80144e:	8b 45 14             	mov    0x14(%ebp),%eax
  801451:	8b 00                	mov    (%eax),%eax
  801453:	83 f8 0f             	cmp    $0xf,%eax
  801456:	75 07                	jne    80145f <strsplit+0x6c>
		{
			return 0;
  801458:	b8 00 00 00 00       	mov    $0x0,%eax
  80145d:	eb 66                	jmp    8014c5 <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  80145f:	8b 45 14             	mov    0x14(%ebp),%eax
  801462:	8b 00                	mov    (%eax),%eax
  801464:	8d 48 01             	lea    0x1(%eax),%ecx
  801467:	8b 55 14             	mov    0x14(%ebp),%edx
  80146a:	89 0a                	mov    %ecx,(%edx)
  80146c:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801473:	8b 45 10             	mov    0x10(%ebp),%eax
  801476:	01 c2                	add    %eax,%edx
  801478:	8b 45 08             	mov    0x8(%ebp),%eax
  80147b:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  80147d:	eb 03                	jmp    801482 <strsplit+0x8f>
			string++;
  80147f:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  801482:	8b 45 08             	mov    0x8(%ebp),%eax
  801485:	8a 00                	mov    (%eax),%al
  801487:	84 c0                	test   %al,%al
  801489:	74 8b                	je     801416 <strsplit+0x23>
  80148b:	8b 45 08             	mov    0x8(%ebp),%eax
  80148e:	8a 00                	mov    (%eax),%al
  801490:	0f be c0             	movsbl %al,%eax
  801493:	50                   	push   %eax
  801494:	ff 75 0c             	pushl  0xc(%ebp)
  801497:	e8 b5 fa ff ff       	call   800f51 <strchr>
  80149c:	83 c4 08             	add    $0x8,%esp
  80149f:	85 c0                	test   %eax,%eax
  8014a1:	74 dc                	je     80147f <strsplit+0x8c>
			string++;
	}
  8014a3:	e9 6e ff ff ff       	jmp    801416 <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  8014a8:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  8014a9:	8b 45 14             	mov    0x14(%ebp),%eax
  8014ac:	8b 00                	mov    (%eax),%eax
  8014ae:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8014b5:	8b 45 10             	mov    0x10(%ebp),%eax
  8014b8:	01 d0                	add    %edx,%eax
  8014ba:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  8014c0:	b8 01 00 00 00       	mov    $0x1,%eax
}
  8014c5:	c9                   	leave  
  8014c6:	c3                   	ret    

008014c7 <InitializeUHeap>:
//============================== GIVEN FUNCTIONS ===================================//
//==================================================================================//

int FirstTimeFlag = 1;
void InitializeUHeap()
{
  8014c7:	55                   	push   %ebp
  8014c8:	89 e5                	mov    %esp,%ebp
  8014ca:	83 ec 08             	sub    $0x8,%esp
	if(FirstTimeFlag)
  8014cd:	a1 04 40 80 00       	mov    0x804004,%eax
  8014d2:	85 c0                	test   %eax,%eax
  8014d4:	74 1f                	je     8014f5 <InitializeUHeap+0x2e>
	{
		initialize_dyn_block_system();
  8014d6:	e8 1d 00 00 00       	call   8014f8 <initialize_dyn_block_system>
		cprintf("DYNAMIC BLOCK SYSTEM IS INITIALIZED\n");
  8014db:	83 ec 0c             	sub    $0xc,%esp
  8014de:	68 90 39 80 00       	push   $0x803990
  8014e3:	e8 55 f2 ff ff       	call   80073d <cprintf>
  8014e8:	83 c4 10             	add    $0x10,%esp
#if UHP_USE_BUDDY
		initialize_buddy();
		cprintf("BUDDY SYSTEM IS INITIALIZED\n");
#endif
		FirstTimeFlag = 0;
  8014eb:	c7 05 04 40 80 00 00 	movl   $0x0,0x804004
  8014f2:	00 00 00 
	}
}
  8014f5:	90                   	nop
  8014f6:	c9                   	leave  
  8014f7:	c3                   	ret    

008014f8 <initialize_dyn_block_system>:

//=================================
// [1] INITIALIZE DYNAMIC ALLOCATOR:
//=================================
void initialize_dyn_block_system()
{
  8014f8:	55                   	push   %ebp
  8014f9:	89 e5                	mov    %esp,%ebp
  8014fb:	83 ec 28             	sub    $0x28,%esp
	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] initialize_dyn_block_system
	// your code is here, remove the panic and write your code
	//panic("initialize_dyn_block_system() is not implemented yet...!!");

	LIST_INIT(&AllocMemBlocksList);
  8014fe:	c7 05 40 40 80 00 00 	movl   $0x0,0x804040
  801505:	00 00 00 
  801508:	c7 05 44 40 80 00 00 	movl   $0x0,0x804044
  80150f:	00 00 00 
  801512:	c7 05 4c 40 80 00 00 	movl   $0x0,0x80404c
  801519:	00 00 00 
	LIST_INIT(&FreeMemBlocksList);
  80151c:	c7 05 38 41 80 00 00 	movl   $0x0,0x804138
  801523:	00 00 00 
  801526:	c7 05 3c 41 80 00 00 	movl   $0x0,0x80413c
  80152d:	00 00 00 
  801530:	c7 05 44 41 80 00 00 	movl   $0x0,0x804144
  801537:	00 00 00 
	MAX_MEM_BLOCK_CNT = NUM_OF_UHEAP_PAGES;
  80153a:	c7 05 20 41 80 00 00 	movl   $0x20000,0x804120
  801541:	00 02 00 
	MemBlockNodes = (void*)USER_DYN_BLKS_ARRAY;
  801544:	c7 45 f4 00 00 e0 7f 	movl   $0x7fe00000,-0xc(%ebp)
  80154b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80154e:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801553:	2d 00 10 00 00       	sub    $0x1000,%eax
  801558:	a3 50 40 80 00       	mov    %eax,0x804050
	int size_of_block = sizeof(struct MemBlock);
  80155d:	c7 45 f0 10 00 00 00 	movl   $0x10,-0x10(%ebp)
	int size_all_struct = size_of_block*MAX_MEM_BLOCK_CNT;
  801564:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801567:	a1 20 41 80 00       	mov    0x804120,%eax
  80156c:	0f af c2             	imul   %edx,%eax
  80156f:	89 45 ec             	mov    %eax,-0x14(%ebp)
	size_all_struct = ROUNDUP(size_all_struct, PAGE_SIZE);
  801572:	c7 45 e8 00 10 00 00 	movl   $0x1000,-0x18(%ebp)
  801579:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80157c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80157f:	01 d0                	add    %edx,%eax
  801581:	48                   	dec    %eax
  801582:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  801585:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801588:	ba 00 00 00 00       	mov    $0x0,%edx
  80158d:	f7 75 e8             	divl   -0x18(%ebp)
  801590:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801593:	29 d0                	sub    %edx,%eax
  801595:	89 45 ec             	mov    %eax,-0x14(%ebp)
	sys_allocate_chunk(USER_DYN_BLKS_ARRAY, size_all_struct,PERM_USER| PERM_WRITEABLE);
  801598:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80159b:	c7 45 e0 00 00 e0 7f 	movl   $0x7fe00000,-0x20(%ebp)
  8015a2:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8015a5:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
  8015ab:	81 ea 00 10 00 00    	sub    $0x1000,%edx
  8015b1:	83 ec 04             	sub    $0x4,%esp
  8015b4:	6a 06                	push   $0x6
  8015b6:	50                   	push   %eax
  8015b7:	52                   	push   %edx
  8015b8:	e8 a1 05 00 00       	call   801b5e <sys_allocate_chunk>
  8015bd:	83 c4 10             	add    $0x10,%esp
	initialize_MemBlocksList(MAX_MEM_BLOCK_CNT);
  8015c0:	a1 20 41 80 00       	mov    0x804120,%eax
  8015c5:	83 ec 0c             	sub    $0xc,%esp
  8015c8:	50                   	push   %eax
  8015c9:	e8 16 0c 00 00       	call   8021e4 <initialize_MemBlocksList>
  8015ce:	83 c4 10             	add    $0x10,%esp
	struct MemBlock* ourBlock =LIST_LAST(&AvailableMemBlocksList);
  8015d1:	a1 4c 41 80 00       	mov    0x80414c,%eax
  8015d6:	89 45 dc             	mov    %eax,-0x24(%ebp)
	LIST_REMOVE(&AvailableMemBlocksList,ourBlock);
  8015d9:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  8015dd:	75 14                	jne    8015f3 <initialize_dyn_block_system+0xfb>
  8015df:	83 ec 04             	sub    $0x4,%esp
  8015e2:	68 b5 39 80 00       	push   $0x8039b5
  8015e7:	6a 2d                	push   $0x2d
  8015e9:	68 d3 39 80 00       	push   $0x8039d3
  8015ee:	e8 70 1a 00 00       	call   803063 <_panic>
  8015f3:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8015f6:	8b 00                	mov    (%eax),%eax
  8015f8:	85 c0                	test   %eax,%eax
  8015fa:	74 10                	je     80160c <initialize_dyn_block_system+0x114>
  8015fc:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8015ff:	8b 00                	mov    (%eax),%eax
  801601:	8b 55 dc             	mov    -0x24(%ebp),%edx
  801604:	8b 52 04             	mov    0x4(%edx),%edx
  801607:	89 50 04             	mov    %edx,0x4(%eax)
  80160a:	eb 0b                	jmp    801617 <initialize_dyn_block_system+0x11f>
  80160c:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80160f:	8b 40 04             	mov    0x4(%eax),%eax
  801612:	a3 4c 41 80 00       	mov    %eax,0x80414c
  801617:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80161a:	8b 40 04             	mov    0x4(%eax),%eax
  80161d:	85 c0                	test   %eax,%eax
  80161f:	74 0f                	je     801630 <initialize_dyn_block_system+0x138>
  801621:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801624:	8b 40 04             	mov    0x4(%eax),%eax
  801627:	8b 55 dc             	mov    -0x24(%ebp),%edx
  80162a:	8b 12                	mov    (%edx),%edx
  80162c:	89 10                	mov    %edx,(%eax)
  80162e:	eb 0a                	jmp    80163a <initialize_dyn_block_system+0x142>
  801630:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801633:	8b 00                	mov    (%eax),%eax
  801635:	a3 48 41 80 00       	mov    %eax,0x804148
  80163a:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80163d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  801643:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801646:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80164d:	a1 54 41 80 00       	mov    0x804154,%eax
  801652:	48                   	dec    %eax
  801653:	a3 54 41 80 00       	mov    %eax,0x804154
	ourBlock->size = USER_HEAP_MAX-USER_HEAP_START;
  801658:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80165b:	c7 40 0c 00 00 00 20 	movl   $0x20000000,0xc(%eax)
	ourBlock->sva=USER_HEAP_START;
  801662:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801665:	c7 40 08 00 00 00 80 	movl   $0x80000000,0x8(%eax)
	LIST_INSERT_TAIL(&FreeMemBlocksList, ourBlock);
  80166c:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  801670:	75 14                	jne    801686 <initialize_dyn_block_system+0x18e>
  801672:	83 ec 04             	sub    $0x4,%esp
  801675:	68 e0 39 80 00       	push   $0x8039e0
  80167a:	6a 30                	push   $0x30
  80167c:	68 d3 39 80 00       	push   $0x8039d3
  801681:	e8 dd 19 00 00       	call   803063 <_panic>
  801686:	8b 15 3c 41 80 00    	mov    0x80413c,%edx
  80168c:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80168f:	89 50 04             	mov    %edx,0x4(%eax)
  801692:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801695:	8b 40 04             	mov    0x4(%eax),%eax
  801698:	85 c0                	test   %eax,%eax
  80169a:	74 0c                	je     8016a8 <initialize_dyn_block_system+0x1b0>
  80169c:	a1 3c 41 80 00       	mov    0x80413c,%eax
  8016a1:	8b 55 dc             	mov    -0x24(%ebp),%edx
  8016a4:	89 10                	mov    %edx,(%eax)
  8016a6:	eb 08                	jmp    8016b0 <initialize_dyn_block_system+0x1b8>
  8016a8:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8016ab:	a3 38 41 80 00       	mov    %eax,0x804138
  8016b0:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8016b3:	a3 3c 41 80 00       	mov    %eax,0x80413c
  8016b8:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8016bb:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8016c1:	a1 44 41 80 00       	mov    0x804144,%eax
  8016c6:	40                   	inc    %eax
  8016c7:	a3 44 41 80 00       	mov    %eax,0x804144
	//[1] Initialize two lists (AllocMemBlocksList & FreeMemBlocksList) [Hint: use LIST_INIT()]
	//[2] Dynamically allocate the array of MemBlockNodes at VA USER_DYN_BLKS_ARRAY
	//	  (remember to set MAX_MEM_BLOCK_CNT with the chosen size of the array)
	//[3] Initialize AvailableMemBlocksList by filling it with the MemBlockNodes
	//[4] Insert a new MemBlock with the heap size into the FreeMemBlocksList
}
  8016cc:	90                   	nop
  8016cd:	c9                   	leave  
  8016ce:	c3                   	ret    

008016cf <malloc>:
//=================================
// [2] ALLOCATE SPACE IN USER HEAP:
//=================================

void* malloc(uint32 size)
{
  8016cf:	55                   	push   %ebp
  8016d0:	89 e5                	mov    %esp,%ebp
  8016d2:	83 ec 18             	sub    $0x18,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  8016d5:	e8 ed fd ff ff       	call   8014c7 <InitializeUHeap>
	if (size == 0) return NULL ;
  8016da:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8016de:	75 07                	jne    8016e7 <malloc+0x18>
  8016e0:	b8 00 00 00 00       	mov    $0x0,%eax
  8016e5:	eb 67                	jmp    80174e <malloc+0x7f>

	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] malloc
	// your code is here, remove the panic and write your code
	//panic("malloc() is not implemented yet...!!");

	size = ROUNDUP(size, PAGE_SIZE);
  8016e7:	c7 45 f4 00 10 00 00 	movl   $0x1000,-0xc(%ebp)
  8016ee:	8b 55 08             	mov    0x8(%ebp),%edx
  8016f1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8016f4:	01 d0                	add    %edx,%eax
  8016f6:	48                   	dec    %eax
  8016f7:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8016fa:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8016fd:	ba 00 00 00 00       	mov    $0x0,%edx
  801702:	f7 75 f4             	divl   -0xc(%ebp)
  801705:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801708:	29 d0                	sub    %edx,%eax
  80170a:	89 45 08             	mov    %eax,0x8(%ebp)
	if(sys_isUHeapPlacementStrategyFIRSTFIT())
  80170d:	e8 1a 08 00 00       	call   801f2c <sys_isUHeapPlacementStrategyFIRSTFIT>
  801712:	85 c0                	test   %eax,%eax
  801714:	74 33                	je     801749 <malloc+0x7a>
	{
		struct MemBlock * myBlock = alloc_block_FF(size);
  801716:	83 ec 0c             	sub    $0xc,%esp
  801719:	ff 75 08             	pushl  0x8(%ebp)
  80171c:	e8 0c 0e 00 00       	call   80252d <alloc_block_FF>
  801721:	83 c4 10             	add    $0x10,%esp
  801724:	89 45 ec             	mov    %eax,-0x14(%ebp)
		if(myBlock != NULL)
  801727:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  80172b:	74 1c                	je     801749 <malloc+0x7a>
		{
			insert_sorted_allocList(myBlock);
  80172d:	83 ec 0c             	sub    $0xc,%esp
  801730:	ff 75 ec             	pushl  -0x14(%ebp)
  801733:	e8 07 0c 00 00       	call   80233f <insert_sorted_allocList>
  801738:	83 c4 10             	add    $0x10,%esp
			uint32 ptr = myBlock->sva;
  80173b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80173e:	8b 40 08             	mov    0x8(%eax),%eax
  801741:	89 45 e8             	mov    %eax,-0x18(%ebp)
			return (void *)ptr;
  801744:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801747:	eb 05                	jmp    80174e <malloc+0x7f>
		}
	}
	return NULL;
  801749:	b8 00 00 00 00       	mov    $0x0,%eax
	//		to the required allocation size (space should be on 4 KB BOUNDARY)
	//	2) if no suitable space found, return NULL
	// 	3) Return pointer containing the virtual address of allocated space,
	//
	//Use sys_isUHeapPlacementStrategyFIRSTFIT()... to check the current strategy
}
  80174e:	c9                   	leave  
  80174f:	c3                   	ret    

00801750 <free>:
//	We can use sys_free_user_mem(uint32 virtual_address, uint32 size); which
//		switches to the kernel mode, calls free_user_mem() in
//		"kern/mem/chunk_operations.c", then switch back to the user mode here
//	the free_user_mem function is empty, make sure to implement it.
void free(void* virtual_address)
{
  801750:	55                   	push   %ebp
  801751:	89 e5                	mov    %esp,%ebp
  801753:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] free
	// your code is here, remove the panic and write your code
	//panic("free() is not implemented yet...!!");

	uint32 virtualAddress = (uint32 )(virtual_address);
  801756:	8b 45 08             	mov    0x8(%ebp),%eax
  801759:	89 45 f4             	mov    %eax,-0xc(%ebp)
//	virtualAddress = ROUNDDOWN(virtualAddress, PAGE_SIZE);
	struct MemBlock * myBlock = find_block(&AllocMemBlocksList, virtualAddress);
  80175c:	83 ec 08             	sub    $0x8,%esp
  80175f:	ff 75 f4             	pushl  -0xc(%ebp)
  801762:	68 40 40 80 00       	push   $0x804040
  801767:	e8 5b 0b 00 00       	call   8022c7 <find_block>
  80176c:	83 c4 10             	add    $0x10,%esp
  80176f:	89 45 f0             	mov    %eax,-0x10(%ebp)
//	cprintf ("ptr sva at free user side = %x \n", myBlock->sva);
	sys_free_user_mem(virtualAddress, myBlock->size);
  801772:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801775:	8b 40 0c             	mov    0xc(%eax),%eax
  801778:	83 ec 08             	sub    $0x8,%esp
  80177b:	50                   	push   %eax
  80177c:	ff 75 f4             	pushl  -0xc(%ebp)
  80177f:	e8 a2 03 00 00       	call   801b26 <sys_free_user_mem>
  801784:	83 c4 10             	add    $0x10,%esp
	LIST_REMOVE(&AllocMemBlocksList, myBlock);
  801787:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80178b:	75 14                	jne    8017a1 <free+0x51>
  80178d:	83 ec 04             	sub    $0x4,%esp
  801790:	68 b5 39 80 00       	push   $0x8039b5
  801795:	6a 76                	push   $0x76
  801797:	68 d3 39 80 00       	push   $0x8039d3
  80179c:	e8 c2 18 00 00       	call   803063 <_panic>
  8017a1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8017a4:	8b 00                	mov    (%eax),%eax
  8017a6:	85 c0                	test   %eax,%eax
  8017a8:	74 10                	je     8017ba <free+0x6a>
  8017aa:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8017ad:	8b 00                	mov    (%eax),%eax
  8017af:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8017b2:	8b 52 04             	mov    0x4(%edx),%edx
  8017b5:	89 50 04             	mov    %edx,0x4(%eax)
  8017b8:	eb 0b                	jmp    8017c5 <free+0x75>
  8017ba:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8017bd:	8b 40 04             	mov    0x4(%eax),%eax
  8017c0:	a3 44 40 80 00       	mov    %eax,0x804044
  8017c5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8017c8:	8b 40 04             	mov    0x4(%eax),%eax
  8017cb:	85 c0                	test   %eax,%eax
  8017cd:	74 0f                	je     8017de <free+0x8e>
  8017cf:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8017d2:	8b 40 04             	mov    0x4(%eax),%eax
  8017d5:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8017d8:	8b 12                	mov    (%edx),%edx
  8017da:	89 10                	mov    %edx,(%eax)
  8017dc:	eb 0a                	jmp    8017e8 <free+0x98>
  8017de:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8017e1:	8b 00                	mov    (%eax),%eax
  8017e3:	a3 40 40 80 00       	mov    %eax,0x804040
  8017e8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8017eb:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8017f1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8017f4:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8017fb:	a1 4c 40 80 00       	mov    0x80404c,%eax
  801800:	48                   	dec    %eax
  801801:	a3 4c 40 80 00       	mov    %eax,0x80404c
	insert_sorted_with_merge_freeList(myBlock);
  801806:	83 ec 0c             	sub    $0xc,%esp
  801809:	ff 75 f0             	pushl  -0x10(%ebp)
  80180c:	e8 0b 14 00 00       	call   802c1c <insert_sorted_with_merge_freeList>
  801811:	83 c4 10             	add    $0x10,%esp

	//you should get the size of the given allocation using its address
	//you need to call sys_free_user_mem()
	//refer to the project presentation and documentation for details
}
  801814:	90                   	nop
  801815:	c9                   	leave  
  801816:	c3                   	ret    

00801817 <smalloc>:

//=================================
// [4] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
  801817:	55                   	push   %ebp
  801818:	89 e5                	mov    %esp,%ebp
  80181a:	83 ec 28             	sub    $0x28,%esp
  80181d:	8b 45 10             	mov    0x10(%ebp),%eax
  801820:	88 45 e4             	mov    %al,-0x1c(%ebp)
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801823:	e8 9f fc ff ff       	call   8014c7 <InitializeUHeap>
	if (size == 0) return NULL ;
  801828:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80182c:	75 0a                	jne    801838 <smalloc+0x21>
  80182e:	b8 00 00 00 00       	mov    $0x0,%eax
  801833:	e9 8d 00 00 00       	jmp    8018c5 <smalloc+0xae>

	//This function should find the space of the required range
	// * ON 4KB BOUNDARY **** //
	//Use sys_isUHeapPlacementStrategyFIRSTFIT() to check the current strategy

	size = ROUNDUP(size, PAGE_SIZE);
  801838:	c7 45 f4 00 10 00 00 	movl   $0x1000,-0xc(%ebp)
  80183f:	8b 55 0c             	mov    0xc(%ebp),%edx
  801842:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801845:	01 d0                	add    %edx,%eax
  801847:	48                   	dec    %eax
  801848:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80184b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80184e:	ba 00 00 00 00       	mov    $0x0,%edx
  801853:	f7 75 f4             	divl   -0xc(%ebp)
  801856:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801859:	29 d0                	sub    %edx,%eax
  80185b:	89 45 0c             	mov    %eax,0xc(%ebp)
		if(sys_isUHeapPlacementStrategyFIRSTFIT())
  80185e:	e8 c9 06 00 00       	call   801f2c <sys_isUHeapPlacementStrategyFIRSTFIT>
  801863:	85 c0                	test   %eax,%eax
  801865:	74 59                	je     8018c0 <smalloc+0xa9>
		{
			struct MemBlock * v1=NULL;
  801867:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
			v1= alloc_block_FF(size);
  80186e:	83 ec 0c             	sub    $0xc,%esp
  801871:	ff 75 0c             	pushl  0xc(%ebp)
  801874:	e8 b4 0c 00 00       	call   80252d <alloc_block_FF>
  801879:	83 c4 10             	add    $0x10,%esp
  80187c:	89 45 ec             	mov    %eax,-0x14(%ebp)
			if(v1==NULL)
  80187f:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  801883:	75 07                	jne    80188c <smalloc+0x75>
			{
				return NULL;
  801885:	b8 00 00 00 00       	mov    $0x0,%eax
  80188a:	eb 39                	jmp    8018c5 <smalloc+0xae>
			}
			else
			{
				int ret=sys_createSharedObject(sharedVarName,  size,  isWritable,(void*)v1->sva);
  80188c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80188f:	8b 40 08             	mov    0x8(%eax),%eax
  801892:	89 c2                	mov    %eax,%edx
  801894:	0f b6 45 e4          	movzbl -0x1c(%ebp),%eax
  801898:	52                   	push   %edx
  801899:	50                   	push   %eax
  80189a:	ff 75 0c             	pushl  0xc(%ebp)
  80189d:	ff 75 08             	pushl  0x8(%ebp)
  8018a0:	e8 0c 04 00 00       	call   801cb1 <sys_createSharedObject>
  8018a5:	83 c4 10             	add    $0x10,%esp
  8018a8:	89 45 e8             	mov    %eax,-0x18(%ebp)
				if(ret>=0)
  8018ab:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8018af:	78 08                	js     8018b9 <smalloc+0xa2>
				{
					return (void*)v1->sva;
  8018b1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8018b4:	8b 40 08             	mov    0x8(%eax),%eax
  8018b7:	eb 0c                	jmp    8018c5 <smalloc+0xae>
				}
				else
				{
					return NULL;
  8018b9:	b8 00 00 00 00       	mov    $0x0,%eax
  8018be:	eb 05                	jmp    8018c5 <smalloc+0xae>
				}
			}

		}
		return NULL;
  8018c0:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8018c5:	c9                   	leave  
  8018c6:	c3                   	ret    

008018c7 <sget>:

//========================================
// [5] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  8018c7:	55                   	push   %ebp
  8018c8:	89 e5                	mov    %esp,%ebp
  8018ca:	83 ec 18             	sub    $0x18,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  8018cd:	e8 f5 fb ff ff       	call   8014c7 <InitializeUHeap>

	//This function should find the space for sharing the variable
	// *** ON 4KB BOUNDARY ******** //

	//Use sys_isUHeapPlacementStrategyFIRSTFIT() to check the current strategy
	int ret=sys_getSizeOfSharedObject(ownerEnvID,sharedVarName);
  8018d2:	83 ec 08             	sub    $0x8,%esp
  8018d5:	ff 75 0c             	pushl  0xc(%ebp)
  8018d8:	ff 75 08             	pushl  0x8(%ebp)
  8018db:	e8 fb 03 00 00       	call   801cdb <sys_getSizeOfSharedObject>
  8018e0:	83 c4 10             	add    $0x10,%esp
  8018e3:	89 45 f4             	mov    %eax,-0xc(%ebp)
	if(ret==0)
  8018e6:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8018ea:	75 07                	jne    8018f3 <sget+0x2c>
	{
		return NULL;
  8018ec:	b8 00 00 00 00       	mov    $0x0,%eax
  8018f1:	eb 64                	jmp    801957 <sget+0x90>
	}
	if(sys_isUHeapPlacementStrategyFIRSTFIT())
  8018f3:	e8 34 06 00 00       	call   801f2c <sys_isUHeapPlacementStrategyFIRSTFIT>
  8018f8:	85 c0                	test   %eax,%eax
  8018fa:	74 56                	je     801952 <sget+0x8b>
	{
		struct MemBlock * v1=NULL;
  8018fc:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
		v1= alloc_block_FF(ret);
  801903:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801906:	83 ec 0c             	sub    $0xc,%esp
  801909:	50                   	push   %eax
  80190a:	e8 1e 0c 00 00       	call   80252d <alloc_block_FF>
  80190f:	83 c4 10             	add    $0x10,%esp
  801912:	89 45 f0             	mov    %eax,-0x10(%ebp)
		if(v1==NULL)
  801915:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801919:	75 07                	jne    801922 <sget+0x5b>
		{
		return NULL;
  80191b:	b8 00 00 00 00       	mov    $0x0,%eax
  801920:	eb 35                	jmp    801957 <sget+0x90>
	    }
		else
		{
			int ret1=sys_getSharedObject(ownerEnvID,sharedVarName,(void*)v1->sva);
  801922:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801925:	8b 40 08             	mov    0x8(%eax),%eax
  801928:	83 ec 04             	sub    $0x4,%esp
  80192b:	50                   	push   %eax
  80192c:	ff 75 0c             	pushl  0xc(%ebp)
  80192f:	ff 75 08             	pushl  0x8(%ebp)
  801932:	e8 c1 03 00 00       	call   801cf8 <sys_getSharedObject>
  801937:	83 c4 10             	add    $0x10,%esp
  80193a:	89 45 ec             	mov    %eax,-0x14(%ebp)
			if(ret1>=0)
  80193d:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  801941:	78 08                	js     80194b <sget+0x84>
			{
				return (void*)v1->sva;
  801943:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801946:	8b 40 08             	mov    0x8(%eax),%eax
  801949:	eb 0c                	jmp    801957 <sget+0x90>
			}
			else
			{
				return NULL;
  80194b:	b8 00 00 00 00       	mov    $0x0,%eax
  801950:	eb 05                	jmp    801957 <sget+0x90>
			}
		}
	}
  return NULL;
  801952:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801957:	c9                   	leave  
  801958:	c3                   	ret    

00801959 <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  801959:	55                   	push   %ebp
  80195a:	89 e5                	mov    %esp,%ebp
  80195c:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  80195f:	e8 63 fb ff ff       	call   8014c7 <InitializeUHeap>
	//==============================================================
	// [USER HEAP - USER SIDE] realloc
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  801964:	83 ec 04             	sub    $0x4,%esp
  801967:	68 04 3a 80 00       	push   $0x803a04
  80196c:	68 0e 01 00 00       	push   $0x10e
  801971:	68 d3 39 80 00       	push   $0x8039d3
  801976:	e8 e8 16 00 00       	call   803063 <_panic>

0080197b <sfree>:
//	use sys_freeSharedObject(...); which switches to the kernel mode,
//	calls freeSharedObject(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the freeSharedObject() function is empty, make sure to implement it.

void sfree(void* virtual_address)
{
  80197b:	55                   	push   %ebp
  80197c:	89 e5                	mov    %esp,%ebp
  80197e:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS3 - BONUS] [SHARING - USER SIDE] sfree()

	// Write your code here, remove the panic and write your code
	panic("sfree() is not implemented yet...!!");
  801981:	83 ec 04             	sub    $0x4,%esp
  801984:	68 2c 3a 80 00       	push   $0x803a2c
  801989:	68 22 01 00 00       	push   $0x122
  80198e:	68 d3 39 80 00       	push   $0x8039d3
  801993:	e8 cb 16 00 00       	call   803063 <_panic>

00801998 <expand>:

//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//
void expand(uint32 newSize)
{
  801998:	55                   	push   %ebp
  801999:	89 e5                	mov    %esp,%ebp
  80199b:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  80199e:	83 ec 04             	sub    $0x4,%esp
  8019a1:	68 50 3a 80 00       	push   $0x803a50
  8019a6:	68 2d 01 00 00       	push   $0x12d
  8019ab:	68 d3 39 80 00       	push   $0x8039d3
  8019b0:	e8 ae 16 00 00       	call   803063 <_panic>

008019b5 <shrink>:

}
void shrink(uint32 newSize)
{
  8019b5:	55                   	push   %ebp
  8019b6:	89 e5                	mov    %esp,%ebp
  8019b8:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  8019bb:	83 ec 04             	sub    $0x4,%esp
  8019be:	68 50 3a 80 00       	push   $0x803a50
  8019c3:	68 32 01 00 00       	push   $0x132
  8019c8:	68 d3 39 80 00       	push   $0x8039d3
  8019cd:	e8 91 16 00 00       	call   803063 <_panic>

008019d2 <freeHeap>:

}
void freeHeap(void* virtual_address)
{
  8019d2:	55                   	push   %ebp
  8019d3:	89 e5                	mov    %esp,%ebp
  8019d5:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  8019d8:	83 ec 04             	sub    $0x4,%esp
  8019db:	68 50 3a 80 00       	push   $0x803a50
  8019e0:	68 37 01 00 00       	push   $0x137
  8019e5:	68 d3 39 80 00       	push   $0x8039d3
  8019ea:	e8 74 16 00 00       	call   803063 <_panic>

008019ef <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  8019ef:	55                   	push   %ebp
  8019f0:	89 e5                	mov    %esp,%ebp
  8019f2:	57                   	push   %edi
  8019f3:	56                   	push   %esi
  8019f4:	53                   	push   %ebx
  8019f5:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8019f8:	8b 45 08             	mov    0x8(%ebp),%eax
  8019fb:	8b 55 0c             	mov    0xc(%ebp),%edx
  8019fe:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801a01:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801a04:	8b 7d 18             	mov    0x18(%ebp),%edi
  801a07:	8b 75 1c             	mov    0x1c(%ebp),%esi
  801a0a:	cd 30                	int    $0x30
  801a0c:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  801a0f:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801a12:	83 c4 10             	add    $0x10,%esp
  801a15:	5b                   	pop    %ebx
  801a16:	5e                   	pop    %esi
  801a17:	5f                   	pop    %edi
  801a18:	5d                   	pop    %ebp
  801a19:	c3                   	ret    

00801a1a <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  801a1a:	55                   	push   %ebp
  801a1b:	89 e5                	mov    %esp,%ebp
  801a1d:	83 ec 04             	sub    $0x4,%esp
  801a20:	8b 45 10             	mov    0x10(%ebp),%eax
  801a23:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  801a26:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801a2a:	8b 45 08             	mov    0x8(%ebp),%eax
  801a2d:	6a 00                	push   $0x0
  801a2f:	6a 00                	push   $0x0
  801a31:	52                   	push   %edx
  801a32:	ff 75 0c             	pushl  0xc(%ebp)
  801a35:	50                   	push   %eax
  801a36:	6a 00                	push   $0x0
  801a38:	e8 b2 ff ff ff       	call   8019ef <syscall>
  801a3d:	83 c4 18             	add    $0x18,%esp
}
  801a40:	90                   	nop
  801a41:	c9                   	leave  
  801a42:	c3                   	ret    

00801a43 <sys_cgetc>:

int
sys_cgetc(void)
{
  801a43:	55                   	push   %ebp
  801a44:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  801a46:	6a 00                	push   $0x0
  801a48:	6a 00                	push   $0x0
  801a4a:	6a 00                	push   $0x0
  801a4c:	6a 00                	push   $0x0
  801a4e:	6a 00                	push   $0x0
  801a50:	6a 01                	push   $0x1
  801a52:	e8 98 ff ff ff       	call   8019ef <syscall>
  801a57:	83 c4 18             	add    $0x18,%esp
}
  801a5a:	c9                   	leave  
  801a5b:	c3                   	ret    

00801a5c <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  801a5c:	55                   	push   %ebp
  801a5d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  801a5f:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a62:	8b 45 08             	mov    0x8(%ebp),%eax
  801a65:	6a 00                	push   $0x0
  801a67:	6a 00                	push   $0x0
  801a69:	6a 00                	push   $0x0
  801a6b:	52                   	push   %edx
  801a6c:	50                   	push   %eax
  801a6d:	6a 05                	push   $0x5
  801a6f:	e8 7b ff ff ff       	call   8019ef <syscall>
  801a74:	83 c4 18             	add    $0x18,%esp
}
  801a77:	c9                   	leave  
  801a78:	c3                   	ret    

00801a79 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  801a79:	55                   	push   %ebp
  801a7a:	89 e5                	mov    %esp,%ebp
  801a7c:	56                   	push   %esi
  801a7d:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  801a7e:	8b 75 18             	mov    0x18(%ebp),%esi
  801a81:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801a84:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801a87:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a8a:	8b 45 08             	mov    0x8(%ebp),%eax
  801a8d:	56                   	push   %esi
  801a8e:	53                   	push   %ebx
  801a8f:	51                   	push   %ecx
  801a90:	52                   	push   %edx
  801a91:	50                   	push   %eax
  801a92:	6a 06                	push   $0x6
  801a94:	e8 56 ff ff ff       	call   8019ef <syscall>
  801a99:	83 c4 18             	add    $0x18,%esp
}
  801a9c:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801a9f:	5b                   	pop    %ebx
  801aa0:	5e                   	pop    %esi
  801aa1:	5d                   	pop    %ebp
  801aa2:	c3                   	ret    

00801aa3 <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  801aa3:	55                   	push   %ebp
  801aa4:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  801aa6:	8b 55 0c             	mov    0xc(%ebp),%edx
  801aa9:	8b 45 08             	mov    0x8(%ebp),%eax
  801aac:	6a 00                	push   $0x0
  801aae:	6a 00                	push   $0x0
  801ab0:	6a 00                	push   $0x0
  801ab2:	52                   	push   %edx
  801ab3:	50                   	push   %eax
  801ab4:	6a 07                	push   $0x7
  801ab6:	e8 34 ff ff ff       	call   8019ef <syscall>
  801abb:	83 c4 18             	add    $0x18,%esp
}
  801abe:	c9                   	leave  
  801abf:	c3                   	ret    

00801ac0 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  801ac0:	55                   	push   %ebp
  801ac1:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  801ac3:	6a 00                	push   $0x0
  801ac5:	6a 00                	push   $0x0
  801ac7:	6a 00                	push   $0x0
  801ac9:	ff 75 0c             	pushl  0xc(%ebp)
  801acc:	ff 75 08             	pushl  0x8(%ebp)
  801acf:	6a 08                	push   $0x8
  801ad1:	e8 19 ff ff ff       	call   8019ef <syscall>
  801ad6:	83 c4 18             	add    $0x18,%esp
}
  801ad9:	c9                   	leave  
  801ada:	c3                   	ret    

00801adb <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  801adb:	55                   	push   %ebp
  801adc:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  801ade:	6a 00                	push   $0x0
  801ae0:	6a 00                	push   $0x0
  801ae2:	6a 00                	push   $0x0
  801ae4:	6a 00                	push   $0x0
  801ae6:	6a 00                	push   $0x0
  801ae8:	6a 09                	push   $0x9
  801aea:	e8 00 ff ff ff       	call   8019ef <syscall>
  801aef:	83 c4 18             	add    $0x18,%esp
}
  801af2:	c9                   	leave  
  801af3:	c3                   	ret    

00801af4 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  801af4:	55                   	push   %ebp
  801af5:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  801af7:	6a 00                	push   $0x0
  801af9:	6a 00                	push   $0x0
  801afb:	6a 00                	push   $0x0
  801afd:	6a 00                	push   $0x0
  801aff:	6a 00                	push   $0x0
  801b01:	6a 0a                	push   $0xa
  801b03:	e8 e7 fe ff ff       	call   8019ef <syscall>
  801b08:	83 c4 18             	add    $0x18,%esp
}
  801b0b:	c9                   	leave  
  801b0c:	c3                   	ret    

00801b0d <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  801b0d:	55                   	push   %ebp
  801b0e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  801b10:	6a 00                	push   $0x0
  801b12:	6a 00                	push   $0x0
  801b14:	6a 00                	push   $0x0
  801b16:	6a 00                	push   $0x0
  801b18:	6a 00                	push   $0x0
  801b1a:	6a 0b                	push   $0xb
  801b1c:	e8 ce fe ff ff       	call   8019ef <syscall>
  801b21:	83 c4 18             	add    $0x18,%esp
}
  801b24:	c9                   	leave  
  801b25:	c3                   	ret    

00801b26 <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  801b26:	55                   	push   %ebp
  801b27:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  801b29:	6a 00                	push   $0x0
  801b2b:	6a 00                	push   $0x0
  801b2d:	6a 00                	push   $0x0
  801b2f:	ff 75 0c             	pushl  0xc(%ebp)
  801b32:	ff 75 08             	pushl  0x8(%ebp)
  801b35:	6a 0f                	push   $0xf
  801b37:	e8 b3 fe ff ff       	call   8019ef <syscall>
  801b3c:	83 c4 18             	add    $0x18,%esp
	return;
  801b3f:	90                   	nop
}
  801b40:	c9                   	leave  
  801b41:	c3                   	ret    

00801b42 <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  801b42:	55                   	push   %ebp
  801b43:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  801b45:	6a 00                	push   $0x0
  801b47:	6a 00                	push   $0x0
  801b49:	6a 00                	push   $0x0
  801b4b:	ff 75 0c             	pushl  0xc(%ebp)
  801b4e:	ff 75 08             	pushl  0x8(%ebp)
  801b51:	6a 10                	push   $0x10
  801b53:	e8 97 fe ff ff       	call   8019ef <syscall>
  801b58:	83 c4 18             	add    $0x18,%esp
	return ;
  801b5b:	90                   	nop
}
  801b5c:	c9                   	leave  
  801b5d:	c3                   	ret    

00801b5e <sys_allocate_chunk>:

void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  801b5e:	55                   	push   %ebp
  801b5f:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  801b61:	6a 00                	push   $0x0
  801b63:	6a 00                	push   $0x0
  801b65:	ff 75 10             	pushl  0x10(%ebp)
  801b68:	ff 75 0c             	pushl  0xc(%ebp)
  801b6b:	ff 75 08             	pushl  0x8(%ebp)
  801b6e:	6a 11                	push   $0x11
  801b70:	e8 7a fe ff ff       	call   8019ef <syscall>
  801b75:	83 c4 18             	add    $0x18,%esp
	return ;
  801b78:	90                   	nop
}
  801b79:	c9                   	leave  
  801b7a:	c3                   	ret    

00801b7b <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  801b7b:	55                   	push   %ebp
  801b7c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  801b7e:	6a 00                	push   $0x0
  801b80:	6a 00                	push   $0x0
  801b82:	6a 00                	push   $0x0
  801b84:	6a 00                	push   $0x0
  801b86:	6a 00                	push   $0x0
  801b88:	6a 0c                	push   $0xc
  801b8a:	e8 60 fe ff ff       	call   8019ef <syscall>
  801b8f:	83 c4 18             	add    $0x18,%esp
}
  801b92:	c9                   	leave  
  801b93:	c3                   	ret    

00801b94 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  801b94:	55                   	push   %ebp
  801b95:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  801b97:	6a 00                	push   $0x0
  801b99:	6a 00                	push   $0x0
  801b9b:	6a 00                	push   $0x0
  801b9d:	6a 00                	push   $0x0
  801b9f:	ff 75 08             	pushl  0x8(%ebp)
  801ba2:	6a 0d                	push   $0xd
  801ba4:	e8 46 fe ff ff       	call   8019ef <syscall>
  801ba9:	83 c4 18             	add    $0x18,%esp
}
  801bac:	c9                   	leave  
  801bad:	c3                   	ret    

00801bae <sys_scarce_memory>:

void sys_scarce_memory()
{
  801bae:	55                   	push   %ebp
  801baf:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  801bb1:	6a 00                	push   $0x0
  801bb3:	6a 00                	push   $0x0
  801bb5:	6a 00                	push   $0x0
  801bb7:	6a 00                	push   $0x0
  801bb9:	6a 00                	push   $0x0
  801bbb:	6a 0e                	push   $0xe
  801bbd:	e8 2d fe ff ff       	call   8019ef <syscall>
  801bc2:	83 c4 18             	add    $0x18,%esp
}
  801bc5:	90                   	nop
  801bc6:	c9                   	leave  
  801bc7:	c3                   	ret    

00801bc8 <sys_disable_interrupt>:

//NEW !! 2012...
void
sys_disable_interrupt()
{
  801bc8:	55                   	push   %ebp
  801bc9:	89 e5                	mov    %esp,%ebp
	syscall(SYS_disableINTR,0, 0, 0, 0, 0);
  801bcb:	6a 00                	push   $0x0
  801bcd:	6a 00                	push   $0x0
  801bcf:	6a 00                	push   $0x0
  801bd1:	6a 00                	push   $0x0
  801bd3:	6a 00                	push   $0x0
  801bd5:	6a 13                	push   $0x13
  801bd7:	e8 13 fe ff ff       	call   8019ef <syscall>
  801bdc:	83 c4 18             	add    $0x18,%esp
}
  801bdf:	90                   	nop
  801be0:	c9                   	leave  
  801be1:	c3                   	ret    

00801be2 <sys_enable_interrupt>:


void
sys_enable_interrupt()
{
  801be2:	55                   	push   %ebp
  801be3:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enableINTR,0, 0, 0, 0, 0);
  801be5:	6a 00                	push   $0x0
  801be7:	6a 00                	push   $0x0
  801be9:	6a 00                	push   $0x0
  801beb:	6a 00                	push   $0x0
  801bed:	6a 00                	push   $0x0
  801bef:	6a 14                	push   $0x14
  801bf1:	e8 f9 fd ff ff       	call   8019ef <syscall>
  801bf6:	83 c4 18             	add    $0x18,%esp
}
  801bf9:	90                   	nop
  801bfa:	c9                   	leave  
  801bfb:	c3                   	ret    

00801bfc <sys_cputc>:


void
sys_cputc(const char c)
{
  801bfc:	55                   	push   %ebp
  801bfd:	89 e5                	mov    %esp,%ebp
  801bff:	83 ec 04             	sub    $0x4,%esp
  801c02:	8b 45 08             	mov    0x8(%ebp),%eax
  801c05:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  801c08:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801c0c:	6a 00                	push   $0x0
  801c0e:	6a 00                	push   $0x0
  801c10:	6a 00                	push   $0x0
  801c12:	6a 00                	push   $0x0
  801c14:	50                   	push   %eax
  801c15:	6a 15                	push   $0x15
  801c17:	e8 d3 fd ff ff       	call   8019ef <syscall>
  801c1c:	83 c4 18             	add    $0x18,%esp
}
  801c1f:	90                   	nop
  801c20:	c9                   	leave  
  801c21:	c3                   	ret    

00801c22 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  801c22:	55                   	push   %ebp
  801c23:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  801c25:	6a 00                	push   $0x0
  801c27:	6a 00                	push   $0x0
  801c29:	6a 00                	push   $0x0
  801c2b:	6a 00                	push   $0x0
  801c2d:	6a 00                	push   $0x0
  801c2f:	6a 16                	push   $0x16
  801c31:	e8 b9 fd ff ff       	call   8019ef <syscall>
  801c36:	83 c4 18             	add    $0x18,%esp
}
  801c39:	90                   	nop
  801c3a:	c9                   	leave  
  801c3b:	c3                   	ret    

00801c3c <sys_createSemaphore>:

int
sys_createSemaphore(char* semaphoreName, uint32 initialValue)
{
  801c3c:	55                   	push   %ebp
  801c3d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_semaphore,(uint32)semaphoreName, (uint32)initialValue, 0, 0, 0);
  801c3f:	8b 45 08             	mov    0x8(%ebp),%eax
  801c42:	6a 00                	push   $0x0
  801c44:	6a 00                	push   $0x0
  801c46:	6a 00                	push   $0x0
  801c48:	ff 75 0c             	pushl  0xc(%ebp)
  801c4b:	50                   	push   %eax
  801c4c:	6a 17                	push   $0x17
  801c4e:	e8 9c fd ff ff       	call   8019ef <syscall>
  801c53:	83 c4 18             	add    $0x18,%esp
}
  801c56:	c9                   	leave  
  801c57:	c3                   	ret    

00801c58 <sys_getSemaphoreValue>:

int
sys_getSemaphoreValue(int32 ownerEnvID, char* semaphoreName)
{
  801c58:	55                   	push   %ebp
  801c59:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_semaphore_value,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801c5b:	8b 55 0c             	mov    0xc(%ebp),%edx
  801c5e:	8b 45 08             	mov    0x8(%ebp),%eax
  801c61:	6a 00                	push   $0x0
  801c63:	6a 00                	push   $0x0
  801c65:	6a 00                	push   $0x0
  801c67:	52                   	push   %edx
  801c68:	50                   	push   %eax
  801c69:	6a 1a                	push   $0x1a
  801c6b:	e8 7f fd ff ff       	call   8019ef <syscall>
  801c70:	83 c4 18             	add    $0x18,%esp
}
  801c73:	c9                   	leave  
  801c74:	c3                   	ret    

00801c75 <sys_waitSemaphore>:

void
sys_waitSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801c75:	55                   	push   %ebp
  801c76:	89 e5                	mov    %esp,%ebp
	syscall(SYS_wait_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801c78:	8b 55 0c             	mov    0xc(%ebp),%edx
  801c7b:	8b 45 08             	mov    0x8(%ebp),%eax
  801c7e:	6a 00                	push   $0x0
  801c80:	6a 00                	push   $0x0
  801c82:	6a 00                	push   $0x0
  801c84:	52                   	push   %edx
  801c85:	50                   	push   %eax
  801c86:	6a 18                	push   $0x18
  801c88:	e8 62 fd ff ff       	call   8019ef <syscall>
  801c8d:	83 c4 18             	add    $0x18,%esp
}
  801c90:	90                   	nop
  801c91:	c9                   	leave  
  801c92:	c3                   	ret    

00801c93 <sys_signalSemaphore>:

void
sys_signalSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801c93:	55                   	push   %ebp
  801c94:	89 e5                	mov    %esp,%ebp
	syscall(SYS_signal_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801c96:	8b 55 0c             	mov    0xc(%ebp),%edx
  801c99:	8b 45 08             	mov    0x8(%ebp),%eax
  801c9c:	6a 00                	push   $0x0
  801c9e:	6a 00                	push   $0x0
  801ca0:	6a 00                	push   $0x0
  801ca2:	52                   	push   %edx
  801ca3:	50                   	push   %eax
  801ca4:	6a 19                	push   $0x19
  801ca6:	e8 44 fd ff ff       	call   8019ef <syscall>
  801cab:	83 c4 18             	add    $0x18,%esp
}
  801cae:	90                   	nop
  801caf:	c9                   	leave  
  801cb0:	c3                   	ret    

00801cb1 <sys_createSharedObject>:

int
sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  801cb1:	55                   	push   %ebp
  801cb2:	89 e5                	mov    %esp,%ebp
  801cb4:	83 ec 04             	sub    $0x4,%esp
  801cb7:	8b 45 10             	mov    0x10(%ebp),%eax
  801cba:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  801cbd:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801cc0:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801cc4:	8b 45 08             	mov    0x8(%ebp),%eax
  801cc7:	6a 00                	push   $0x0
  801cc9:	51                   	push   %ecx
  801cca:	52                   	push   %edx
  801ccb:	ff 75 0c             	pushl  0xc(%ebp)
  801cce:	50                   	push   %eax
  801ccf:	6a 1b                	push   $0x1b
  801cd1:	e8 19 fd ff ff       	call   8019ef <syscall>
  801cd6:	83 c4 18             	add    $0x18,%esp
}
  801cd9:	c9                   	leave  
  801cda:	c3                   	ret    

00801cdb <sys_getSizeOfSharedObject>:

//2017:
int
sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  801cdb:	55                   	push   %ebp
  801cdc:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  801cde:	8b 55 0c             	mov    0xc(%ebp),%edx
  801ce1:	8b 45 08             	mov    0x8(%ebp),%eax
  801ce4:	6a 00                	push   $0x0
  801ce6:	6a 00                	push   $0x0
  801ce8:	6a 00                	push   $0x0
  801cea:	52                   	push   %edx
  801ceb:	50                   	push   %eax
  801cec:	6a 1c                	push   $0x1c
  801cee:	e8 fc fc ff ff       	call   8019ef <syscall>
  801cf3:	83 c4 18             	add    $0x18,%esp
}
  801cf6:	c9                   	leave  
  801cf7:	c3                   	ret    

00801cf8 <sys_getSharedObject>:
//==========

int
sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  801cf8:	55                   	push   %ebp
  801cf9:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  801cfb:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801cfe:	8b 55 0c             	mov    0xc(%ebp),%edx
  801d01:	8b 45 08             	mov    0x8(%ebp),%eax
  801d04:	6a 00                	push   $0x0
  801d06:	6a 00                	push   $0x0
  801d08:	51                   	push   %ecx
  801d09:	52                   	push   %edx
  801d0a:	50                   	push   %eax
  801d0b:	6a 1d                	push   $0x1d
  801d0d:	e8 dd fc ff ff       	call   8019ef <syscall>
  801d12:	83 c4 18             	add    $0x18,%esp
}
  801d15:	c9                   	leave  
  801d16:	c3                   	ret    

00801d17 <sys_freeSharedObject>:

int
sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  801d17:	55                   	push   %ebp
  801d18:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  801d1a:	8b 55 0c             	mov    0xc(%ebp),%edx
  801d1d:	8b 45 08             	mov    0x8(%ebp),%eax
  801d20:	6a 00                	push   $0x0
  801d22:	6a 00                	push   $0x0
  801d24:	6a 00                	push   $0x0
  801d26:	52                   	push   %edx
  801d27:	50                   	push   %eax
  801d28:	6a 1e                	push   $0x1e
  801d2a:	e8 c0 fc ff ff       	call   8019ef <syscall>
  801d2f:	83 c4 18             	add    $0x18,%esp
}
  801d32:	c9                   	leave  
  801d33:	c3                   	ret    

00801d34 <sys_getMaxShares>:

uint32 	sys_getMaxShares()
{
  801d34:	55                   	push   %ebp
  801d35:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_max_shares,0, 0, 0, 0, 0);
  801d37:	6a 00                	push   $0x0
  801d39:	6a 00                	push   $0x0
  801d3b:	6a 00                	push   $0x0
  801d3d:	6a 00                	push   $0x0
  801d3f:	6a 00                	push   $0x0
  801d41:	6a 1f                	push   $0x1f
  801d43:	e8 a7 fc ff ff       	call   8019ef <syscall>
  801d48:	83 c4 18             	add    $0x18,%esp
}
  801d4b:	c9                   	leave  
  801d4c:	c3                   	ret    

00801d4d <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  801d4d:	55                   	push   %ebp
  801d4e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  801d50:	8b 45 08             	mov    0x8(%ebp),%eax
  801d53:	6a 00                	push   $0x0
  801d55:	ff 75 14             	pushl  0x14(%ebp)
  801d58:	ff 75 10             	pushl  0x10(%ebp)
  801d5b:	ff 75 0c             	pushl  0xc(%ebp)
  801d5e:	50                   	push   %eax
  801d5f:	6a 20                	push   $0x20
  801d61:	e8 89 fc ff ff       	call   8019ef <syscall>
  801d66:	83 c4 18             	add    $0x18,%esp
}
  801d69:	c9                   	leave  
  801d6a:	c3                   	ret    

00801d6b <sys_run_env>:

void
sys_run_env(int32 envId)
{
  801d6b:	55                   	push   %ebp
  801d6c:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  801d6e:	8b 45 08             	mov    0x8(%ebp),%eax
  801d71:	6a 00                	push   $0x0
  801d73:	6a 00                	push   $0x0
  801d75:	6a 00                	push   $0x0
  801d77:	6a 00                	push   $0x0
  801d79:	50                   	push   %eax
  801d7a:	6a 21                	push   $0x21
  801d7c:	e8 6e fc ff ff       	call   8019ef <syscall>
  801d81:	83 c4 18             	add    $0x18,%esp
}
  801d84:	90                   	nop
  801d85:	c9                   	leave  
  801d86:	c3                   	ret    

00801d87 <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  801d87:	55                   	push   %ebp
  801d88:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  801d8a:	8b 45 08             	mov    0x8(%ebp),%eax
  801d8d:	6a 00                	push   $0x0
  801d8f:	6a 00                	push   $0x0
  801d91:	6a 00                	push   $0x0
  801d93:	6a 00                	push   $0x0
  801d95:	50                   	push   %eax
  801d96:	6a 22                	push   $0x22
  801d98:	e8 52 fc ff ff       	call   8019ef <syscall>
  801d9d:	83 c4 18             	add    $0x18,%esp
}
  801da0:	c9                   	leave  
  801da1:	c3                   	ret    

00801da2 <sys_getenvid>:

int32 sys_getenvid(void)
{
  801da2:	55                   	push   %ebp
  801da3:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  801da5:	6a 00                	push   $0x0
  801da7:	6a 00                	push   $0x0
  801da9:	6a 00                	push   $0x0
  801dab:	6a 00                	push   $0x0
  801dad:	6a 00                	push   $0x0
  801daf:	6a 02                	push   $0x2
  801db1:	e8 39 fc ff ff       	call   8019ef <syscall>
  801db6:	83 c4 18             	add    $0x18,%esp
}
  801db9:	c9                   	leave  
  801dba:	c3                   	ret    

00801dbb <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  801dbb:	55                   	push   %ebp
  801dbc:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  801dbe:	6a 00                	push   $0x0
  801dc0:	6a 00                	push   $0x0
  801dc2:	6a 00                	push   $0x0
  801dc4:	6a 00                	push   $0x0
  801dc6:	6a 00                	push   $0x0
  801dc8:	6a 03                	push   $0x3
  801dca:	e8 20 fc ff ff       	call   8019ef <syscall>
  801dcf:	83 c4 18             	add    $0x18,%esp
}
  801dd2:	c9                   	leave  
  801dd3:	c3                   	ret    

00801dd4 <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  801dd4:	55                   	push   %ebp
  801dd5:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  801dd7:	6a 00                	push   $0x0
  801dd9:	6a 00                	push   $0x0
  801ddb:	6a 00                	push   $0x0
  801ddd:	6a 00                	push   $0x0
  801ddf:	6a 00                	push   $0x0
  801de1:	6a 04                	push   $0x4
  801de3:	e8 07 fc ff ff       	call   8019ef <syscall>
  801de8:	83 c4 18             	add    $0x18,%esp
}
  801deb:	c9                   	leave  
  801dec:	c3                   	ret    

00801ded <sys_exit_env>:


void sys_exit_env(void)
{
  801ded:	55                   	push   %ebp
  801dee:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  801df0:	6a 00                	push   $0x0
  801df2:	6a 00                	push   $0x0
  801df4:	6a 00                	push   $0x0
  801df6:	6a 00                	push   $0x0
  801df8:	6a 00                	push   $0x0
  801dfa:	6a 23                	push   $0x23
  801dfc:	e8 ee fb ff ff       	call   8019ef <syscall>
  801e01:	83 c4 18             	add    $0x18,%esp
}
  801e04:	90                   	nop
  801e05:	c9                   	leave  
  801e06:	c3                   	ret    

00801e07 <sys_get_virtual_time>:


struct uint64
sys_get_virtual_time()
{
  801e07:	55                   	push   %ebp
  801e08:	89 e5                	mov    %esp,%ebp
  801e0a:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  801e0d:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801e10:	8d 50 04             	lea    0x4(%eax),%edx
  801e13:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801e16:	6a 00                	push   $0x0
  801e18:	6a 00                	push   $0x0
  801e1a:	6a 00                	push   $0x0
  801e1c:	52                   	push   %edx
  801e1d:	50                   	push   %eax
  801e1e:	6a 24                	push   $0x24
  801e20:	e8 ca fb ff ff       	call   8019ef <syscall>
  801e25:	83 c4 18             	add    $0x18,%esp
	return result;
  801e28:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801e2b:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801e2e:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801e31:	89 01                	mov    %eax,(%ecx)
  801e33:	89 51 04             	mov    %edx,0x4(%ecx)
}
  801e36:	8b 45 08             	mov    0x8(%ebp),%eax
  801e39:	c9                   	leave  
  801e3a:	c2 04 00             	ret    $0x4

00801e3d <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  801e3d:	55                   	push   %ebp
  801e3e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  801e40:	6a 00                	push   $0x0
  801e42:	6a 00                	push   $0x0
  801e44:	ff 75 10             	pushl  0x10(%ebp)
  801e47:	ff 75 0c             	pushl  0xc(%ebp)
  801e4a:	ff 75 08             	pushl  0x8(%ebp)
  801e4d:	6a 12                	push   $0x12
  801e4f:	e8 9b fb ff ff       	call   8019ef <syscall>
  801e54:	83 c4 18             	add    $0x18,%esp
	return ;
  801e57:	90                   	nop
}
  801e58:	c9                   	leave  
  801e59:	c3                   	ret    

00801e5a <sys_rcr2>:
uint32 sys_rcr2()
{
  801e5a:	55                   	push   %ebp
  801e5b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  801e5d:	6a 00                	push   $0x0
  801e5f:	6a 00                	push   $0x0
  801e61:	6a 00                	push   $0x0
  801e63:	6a 00                	push   $0x0
  801e65:	6a 00                	push   $0x0
  801e67:	6a 25                	push   $0x25
  801e69:	e8 81 fb ff ff       	call   8019ef <syscall>
  801e6e:	83 c4 18             	add    $0x18,%esp
}
  801e71:	c9                   	leave  
  801e72:	c3                   	ret    

00801e73 <sys_bypassPageFault>:
void sys_bypassPageFault(uint8 instrLength)
{
  801e73:	55                   	push   %ebp
  801e74:	89 e5                	mov    %esp,%ebp
  801e76:	83 ec 04             	sub    $0x4,%esp
  801e79:	8b 45 08             	mov    0x8(%ebp),%eax
  801e7c:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  801e7f:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  801e83:	6a 00                	push   $0x0
  801e85:	6a 00                	push   $0x0
  801e87:	6a 00                	push   $0x0
  801e89:	6a 00                	push   $0x0
  801e8b:	50                   	push   %eax
  801e8c:	6a 26                	push   $0x26
  801e8e:	e8 5c fb ff ff       	call   8019ef <syscall>
  801e93:	83 c4 18             	add    $0x18,%esp
	return ;
  801e96:	90                   	nop
}
  801e97:	c9                   	leave  
  801e98:	c3                   	ret    

00801e99 <rsttst>:
void rsttst()
{
  801e99:	55                   	push   %ebp
  801e9a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  801e9c:	6a 00                	push   $0x0
  801e9e:	6a 00                	push   $0x0
  801ea0:	6a 00                	push   $0x0
  801ea2:	6a 00                	push   $0x0
  801ea4:	6a 00                	push   $0x0
  801ea6:	6a 28                	push   $0x28
  801ea8:	e8 42 fb ff ff       	call   8019ef <syscall>
  801ead:	83 c4 18             	add    $0x18,%esp
	return ;
  801eb0:	90                   	nop
}
  801eb1:	c9                   	leave  
  801eb2:	c3                   	ret    

00801eb3 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  801eb3:	55                   	push   %ebp
  801eb4:	89 e5                	mov    %esp,%ebp
  801eb6:	83 ec 04             	sub    $0x4,%esp
  801eb9:	8b 45 14             	mov    0x14(%ebp),%eax
  801ebc:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  801ebf:	8b 55 18             	mov    0x18(%ebp),%edx
  801ec2:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801ec6:	52                   	push   %edx
  801ec7:	50                   	push   %eax
  801ec8:	ff 75 10             	pushl  0x10(%ebp)
  801ecb:	ff 75 0c             	pushl  0xc(%ebp)
  801ece:	ff 75 08             	pushl  0x8(%ebp)
  801ed1:	6a 27                	push   $0x27
  801ed3:	e8 17 fb ff ff       	call   8019ef <syscall>
  801ed8:	83 c4 18             	add    $0x18,%esp
	return ;
  801edb:	90                   	nop
}
  801edc:	c9                   	leave  
  801edd:	c3                   	ret    

00801ede <chktst>:
void chktst(uint32 n)
{
  801ede:	55                   	push   %ebp
  801edf:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  801ee1:	6a 00                	push   $0x0
  801ee3:	6a 00                	push   $0x0
  801ee5:	6a 00                	push   $0x0
  801ee7:	6a 00                	push   $0x0
  801ee9:	ff 75 08             	pushl  0x8(%ebp)
  801eec:	6a 29                	push   $0x29
  801eee:	e8 fc fa ff ff       	call   8019ef <syscall>
  801ef3:	83 c4 18             	add    $0x18,%esp
	return ;
  801ef6:	90                   	nop
}
  801ef7:	c9                   	leave  
  801ef8:	c3                   	ret    

00801ef9 <inctst>:

void inctst()
{
  801ef9:	55                   	push   %ebp
  801efa:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  801efc:	6a 00                	push   $0x0
  801efe:	6a 00                	push   $0x0
  801f00:	6a 00                	push   $0x0
  801f02:	6a 00                	push   $0x0
  801f04:	6a 00                	push   $0x0
  801f06:	6a 2a                	push   $0x2a
  801f08:	e8 e2 fa ff ff       	call   8019ef <syscall>
  801f0d:	83 c4 18             	add    $0x18,%esp
	return ;
  801f10:	90                   	nop
}
  801f11:	c9                   	leave  
  801f12:	c3                   	ret    

00801f13 <gettst>:
uint32 gettst()
{
  801f13:	55                   	push   %ebp
  801f14:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  801f16:	6a 00                	push   $0x0
  801f18:	6a 00                	push   $0x0
  801f1a:	6a 00                	push   $0x0
  801f1c:	6a 00                	push   $0x0
  801f1e:	6a 00                	push   $0x0
  801f20:	6a 2b                	push   $0x2b
  801f22:	e8 c8 fa ff ff       	call   8019ef <syscall>
  801f27:	83 c4 18             	add    $0x18,%esp
}
  801f2a:	c9                   	leave  
  801f2b:	c3                   	ret    

00801f2c <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  801f2c:	55                   	push   %ebp
  801f2d:	89 e5                	mov    %esp,%ebp
  801f2f:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801f32:	6a 00                	push   $0x0
  801f34:	6a 00                	push   $0x0
  801f36:	6a 00                	push   $0x0
  801f38:	6a 00                	push   $0x0
  801f3a:	6a 00                	push   $0x0
  801f3c:	6a 2c                	push   $0x2c
  801f3e:	e8 ac fa ff ff       	call   8019ef <syscall>
  801f43:	83 c4 18             	add    $0x18,%esp
  801f46:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  801f49:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  801f4d:	75 07                	jne    801f56 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  801f4f:	b8 01 00 00 00       	mov    $0x1,%eax
  801f54:	eb 05                	jmp    801f5b <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  801f56:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801f5b:	c9                   	leave  
  801f5c:	c3                   	ret    

00801f5d <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  801f5d:	55                   	push   %ebp
  801f5e:	89 e5                	mov    %esp,%ebp
  801f60:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801f63:	6a 00                	push   $0x0
  801f65:	6a 00                	push   $0x0
  801f67:	6a 00                	push   $0x0
  801f69:	6a 00                	push   $0x0
  801f6b:	6a 00                	push   $0x0
  801f6d:	6a 2c                	push   $0x2c
  801f6f:	e8 7b fa ff ff       	call   8019ef <syscall>
  801f74:	83 c4 18             	add    $0x18,%esp
  801f77:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  801f7a:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  801f7e:	75 07                	jne    801f87 <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  801f80:	b8 01 00 00 00       	mov    $0x1,%eax
  801f85:	eb 05                	jmp    801f8c <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  801f87:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801f8c:	c9                   	leave  
  801f8d:	c3                   	ret    

00801f8e <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  801f8e:	55                   	push   %ebp
  801f8f:	89 e5                	mov    %esp,%ebp
  801f91:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801f94:	6a 00                	push   $0x0
  801f96:	6a 00                	push   $0x0
  801f98:	6a 00                	push   $0x0
  801f9a:	6a 00                	push   $0x0
  801f9c:	6a 00                	push   $0x0
  801f9e:	6a 2c                	push   $0x2c
  801fa0:	e8 4a fa ff ff       	call   8019ef <syscall>
  801fa5:	83 c4 18             	add    $0x18,%esp
  801fa8:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  801fab:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  801faf:	75 07                	jne    801fb8 <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  801fb1:	b8 01 00 00 00       	mov    $0x1,%eax
  801fb6:	eb 05                	jmp    801fbd <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  801fb8:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801fbd:	c9                   	leave  
  801fbe:	c3                   	ret    

00801fbf <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  801fbf:	55                   	push   %ebp
  801fc0:	89 e5                	mov    %esp,%ebp
  801fc2:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801fc5:	6a 00                	push   $0x0
  801fc7:	6a 00                	push   $0x0
  801fc9:	6a 00                	push   $0x0
  801fcb:	6a 00                	push   $0x0
  801fcd:	6a 00                	push   $0x0
  801fcf:	6a 2c                	push   $0x2c
  801fd1:	e8 19 fa ff ff       	call   8019ef <syscall>
  801fd6:	83 c4 18             	add    $0x18,%esp
  801fd9:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  801fdc:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  801fe0:	75 07                	jne    801fe9 <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  801fe2:	b8 01 00 00 00       	mov    $0x1,%eax
  801fe7:	eb 05                	jmp    801fee <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  801fe9:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801fee:	c9                   	leave  
  801fef:	c3                   	ret    

00801ff0 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  801ff0:	55                   	push   %ebp
  801ff1:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  801ff3:	6a 00                	push   $0x0
  801ff5:	6a 00                	push   $0x0
  801ff7:	6a 00                	push   $0x0
  801ff9:	6a 00                	push   $0x0
  801ffb:	ff 75 08             	pushl  0x8(%ebp)
  801ffe:	6a 2d                	push   $0x2d
  802000:	e8 ea f9 ff ff       	call   8019ef <syscall>
  802005:	83 c4 18             	add    $0x18,%esp
	return ;
  802008:	90                   	nop
}
  802009:	c9                   	leave  
  80200a:	c3                   	ret    

0080200b <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  80200b:	55                   	push   %ebp
  80200c:	89 e5                	mov    %esp,%ebp
  80200e:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  80200f:	8b 5d 14             	mov    0x14(%ebp),%ebx
  802012:	8b 4d 10             	mov    0x10(%ebp),%ecx
  802015:	8b 55 0c             	mov    0xc(%ebp),%edx
  802018:	8b 45 08             	mov    0x8(%ebp),%eax
  80201b:	6a 00                	push   $0x0
  80201d:	53                   	push   %ebx
  80201e:	51                   	push   %ecx
  80201f:	52                   	push   %edx
  802020:	50                   	push   %eax
  802021:	6a 2e                	push   $0x2e
  802023:	e8 c7 f9 ff ff       	call   8019ef <syscall>
  802028:	83 c4 18             	add    $0x18,%esp
}
  80202b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80202e:	c9                   	leave  
  80202f:	c3                   	ret    

00802030 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  802030:	55                   	push   %ebp
  802031:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  802033:	8b 55 0c             	mov    0xc(%ebp),%edx
  802036:	8b 45 08             	mov    0x8(%ebp),%eax
  802039:	6a 00                	push   $0x0
  80203b:	6a 00                	push   $0x0
  80203d:	6a 00                	push   $0x0
  80203f:	52                   	push   %edx
  802040:	50                   	push   %eax
  802041:	6a 2f                	push   $0x2f
  802043:	e8 a7 f9 ff ff       	call   8019ef <syscall>
  802048:	83 c4 18             	add    $0x18,%esp
}
  80204b:	c9                   	leave  
  80204c:	c3                   	ret    

0080204d <print_mem_block_lists>:
//===========================
// PRINT MEM BLOCK LISTS:
//===========================

void print_mem_block_lists()
{
  80204d:	55                   	push   %ebp
  80204e:	89 e5                	mov    %esp,%ebp
  802050:	83 ec 18             	sub    $0x18,%esp
	cprintf("\n=========================================\n");
  802053:	83 ec 0c             	sub    $0xc,%esp
  802056:	68 60 3a 80 00       	push   $0x803a60
  80205b:	e8 dd e6 ff ff       	call   80073d <cprintf>
  802060:	83 c4 10             	add    $0x10,%esp
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
  802063:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nFreeMemBlocksList:\n");
  80206a:	83 ec 0c             	sub    $0xc,%esp
  80206d:	68 8c 3a 80 00       	push   $0x803a8c
  802072:	e8 c6 e6 ff ff       	call   80073d <cprintf>
  802077:	83 c4 10             	add    $0x10,%esp
	uint8 sorted = 1 ;
  80207a:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &FreeMemBlocksList)
  80207e:	a1 38 41 80 00       	mov    0x804138,%eax
  802083:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802086:	eb 56                	jmp    8020de <print_mem_block_lists+0x91>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  802088:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80208c:	74 1c                	je     8020aa <print_mem_block_lists+0x5d>
  80208e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802091:	8b 50 08             	mov    0x8(%eax),%edx
  802094:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802097:	8b 48 08             	mov    0x8(%eax),%ecx
  80209a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80209d:	8b 40 0c             	mov    0xc(%eax),%eax
  8020a0:	01 c8                	add    %ecx,%eax
  8020a2:	39 c2                	cmp    %eax,%edx
  8020a4:	73 04                	jae    8020aa <print_mem_block_lists+0x5d>
			sorted = 0 ;
  8020a6:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  8020aa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020ad:	8b 50 08             	mov    0x8(%eax),%edx
  8020b0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020b3:	8b 40 0c             	mov    0xc(%eax),%eax
  8020b6:	01 c2                	add    %eax,%edx
  8020b8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020bb:	8b 40 08             	mov    0x8(%eax),%eax
  8020be:	83 ec 04             	sub    $0x4,%esp
  8020c1:	52                   	push   %edx
  8020c2:	50                   	push   %eax
  8020c3:	68 a1 3a 80 00       	push   $0x803aa1
  8020c8:	e8 70 e6 ff ff       	call   80073d <cprintf>
  8020cd:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  8020d0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020d3:	89 45 f0             	mov    %eax,-0x10(%ebp)
	cprintf("\n=========================================\n");
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
	cprintf("\nFreeMemBlocksList:\n");
	uint8 sorted = 1 ;
	LIST_FOREACH(blk, &FreeMemBlocksList)
  8020d6:	a1 40 41 80 00       	mov    0x804140,%eax
  8020db:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8020de:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8020e2:	74 07                	je     8020eb <print_mem_block_lists+0x9e>
  8020e4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020e7:	8b 00                	mov    (%eax),%eax
  8020e9:	eb 05                	jmp    8020f0 <print_mem_block_lists+0xa3>
  8020eb:	b8 00 00 00 00       	mov    $0x0,%eax
  8020f0:	a3 40 41 80 00       	mov    %eax,0x804140
  8020f5:	a1 40 41 80 00       	mov    0x804140,%eax
  8020fa:	85 c0                	test   %eax,%eax
  8020fc:	75 8a                	jne    802088 <print_mem_block_lists+0x3b>
  8020fe:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802102:	75 84                	jne    802088 <print_mem_block_lists+0x3b>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;
  802104:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  802108:	75 10                	jne    80211a <print_mem_block_lists+0xcd>
  80210a:	83 ec 0c             	sub    $0xc,%esp
  80210d:	68 b0 3a 80 00       	push   $0x803ab0
  802112:	e8 26 e6 ff ff       	call   80073d <cprintf>
  802117:	83 c4 10             	add    $0x10,%esp

	lastBlk = NULL ;
  80211a:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nAllocMemBlocksList:\n");
  802121:	83 ec 0c             	sub    $0xc,%esp
  802124:	68 d4 3a 80 00       	push   $0x803ad4
  802129:	e8 0f e6 ff ff       	call   80073d <cprintf>
  80212e:	83 c4 10             	add    $0x10,%esp
	sorted = 1 ;
  802131:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &AllocMemBlocksList)
  802135:	a1 40 40 80 00       	mov    0x804040,%eax
  80213a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80213d:	eb 56                	jmp    802195 <print_mem_block_lists+0x148>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  80213f:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802143:	74 1c                	je     802161 <print_mem_block_lists+0x114>
  802145:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802148:	8b 50 08             	mov    0x8(%eax),%edx
  80214b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80214e:	8b 48 08             	mov    0x8(%eax),%ecx
  802151:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802154:	8b 40 0c             	mov    0xc(%eax),%eax
  802157:	01 c8                	add    %ecx,%eax
  802159:	39 c2                	cmp    %eax,%edx
  80215b:	73 04                	jae    802161 <print_mem_block_lists+0x114>
			sorted = 0 ;
  80215d:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  802161:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802164:	8b 50 08             	mov    0x8(%eax),%edx
  802167:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80216a:	8b 40 0c             	mov    0xc(%eax),%eax
  80216d:	01 c2                	add    %eax,%edx
  80216f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802172:	8b 40 08             	mov    0x8(%eax),%eax
  802175:	83 ec 04             	sub    $0x4,%esp
  802178:	52                   	push   %edx
  802179:	50                   	push   %eax
  80217a:	68 a1 3a 80 00       	push   $0x803aa1
  80217f:	e8 b9 e5 ff ff       	call   80073d <cprintf>
  802184:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  802187:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80218a:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;

	lastBlk = NULL ;
	cprintf("\nAllocMemBlocksList:\n");
	sorted = 1 ;
	LIST_FOREACH(blk, &AllocMemBlocksList)
  80218d:	a1 48 40 80 00       	mov    0x804048,%eax
  802192:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802195:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802199:	74 07                	je     8021a2 <print_mem_block_lists+0x155>
  80219b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80219e:	8b 00                	mov    (%eax),%eax
  8021a0:	eb 05                	jmp    8021a7 <print_mem_block_lists+0x15a>
  8021a2:	b8 00 00 00 00       	mov    $0x0,%eax
  8021a7:	a3 48 40 80 00       	mov    %eax,0x804048
  8021ac:	a1 48 40 80 00       	mov    0x804048,%eax
  8021b1:	85 c0                	test   %eax,%eax
  8021b3:	75 8a                	jne    80213f <print_mem_block_lists+0xf2>
  8021b5:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8021b9:	75 84                	jne    80213f <print_mem_block_lists+0xf2>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nAllocMemBlocksList is NOT SORTED!!\n") ;
  8021bb:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  8021bf:	75 10                	jne    8021d1 <print_mem_block_lists+0x184>
  8021c1:	83 ec 0c             	sub    $0xc,%esp
  8021c4:	68 ec 3a 80 00       	push   $0x803aec
  8021c9:	e8 6f e5 ff ff       	call   80073d <cprintf>
  8021ce:	83 c4 10             	add    $0x10,%esp
	cprintf("\n=========================================\n");
  8021d1:	83 ec 0c             	sub    $0xc,%esp
  8021d4:	68 60 3a 80 00       	push   $0x803a60
  8021d9:	e8 5f e5 ff ff       	call   80073d <cprintf>
  8021de:	83 c4 10             	add    $0x10,%esp

}
  8021e1:	90                   	nop
  8021e2:	c9                   	leave  
  8021e3:	c3                   	ret    

008021e4 <initialize_MemBlocksList>:

//===============================
// [1] INITIALIZE AVAILABLE LIST:
//===============================
void initialize_MemBlocksList(uint32 numOfBlocks)
{
  8021e4:	55                   	push   %ebp
  8021e5:	89 e5                	mov    %esp,%ebp
  8021e7:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] initialize_MemBlocksList
	// Write your code here, remove the panic and write your code
	//panic("initialize_MemBlocksList() is not implemented yet...!!");
	uint32 n = numOfBlocks;
  8021ea:	8b 45 08             	mov    0x8(%ebp),%eax
  8021ed:	89 45 f0             	mov    %eax,-0x10(%ebp)

	LIST_INIT(&AvailableMemBlocksList);
  8021f0:	c7 05 48 41 80 00 00 	movl   $0x0,0x804148
  8021f7:	00 00 00 
  8021fa:	c7 05 4c 41 80 00 00 	movl   $0x0,0x80414c
  802201:	00 00 00 
  802204:	c7 05 54 41 80 00 00 	movl   $0x0,0x804154
  80220b:	00 00 00 
	for(int i = 0; i<n;i++)
  80220e:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  802215:	e9 9e 00 00 00       	jmp    8022b8 <initialize_MemBlocksList+0xd4>
	{
		LIST_INSERT_HEAD(&AvailableMemBlocksList, &(MemBlockNodes[i]));
  80221a:	a1 50 40 80 00       	mov    0x804050,%eax
  80221f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802222:	c1 e2 04             	shl    $0x4,%edx
  802225:	01 d0                	add    %edx,%eax
  802227:	85 c0                	test   %eax,%eax
  802229:	75 14                	jne    80223f <initialize_MemBlocksList+0x5b>
  80222b:	83 ec 04             	sub    $0x4,%esp
  80222e:	68 14 3b 80 00       	push   $0x803b14
  802233:	6a 47                	push   $0x47
  802235:	68 37 3b 80 00       	push   $0x803b37
  80223a:	e8 24 0e 00 00       	call   803063 <_panic>
  80223f:	a1 50 40 80 00       	mov    0x804050,%eax
  802244:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802247:	c1 e2 04             	shl    $0x4,%edx
  80224a:	01 d0                	add    %edx,%eax
  80224c:	8b 15 48 41 80 00    	mov    0x804148,%edx
  802252:	89 10                	mov    %edx,(%eax)
  802254:	8b 00                	mov    (%eax),%eax
  802256:	85 c0                	test   %eax,%eax
  802258:	74 18                	je     802272 <initialize_MemBlocksList+0x8e>
  80225a:	a1 48 41 80 00       	mov    0x804148,%eax
  80225f:	8b 15 50 40 80 00    	mov    0x804050,%edx
  802265:	8b 4d f4             	mov    -0xc(%ebp),%ecx
  802268:	c1 e1 04             	shl    $0x4,%ecx
  80226b:	01 ca                	add    %ecx,%edx
  80226d:	89 50 04             	mov    %edx,0x4(%eax)
  802270:	eb 12                	jmp    802284 <initialize_MemBlocksList+0xa0>
  802272:	a1 50 40 80 00       	mov    0x804050,%eax
  802277:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80227a:	c1 e2 04             	shl    $0x4,%edx
  80227d:	01 d0                	add    %edx,%eax
  80227f:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802284:	a1 50 40 80 00       	mov    0x804050,%eax
  802289:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80228c:	c1 e2 04             	shl    $0x4,%edx
  80228f:	01 d0                	add    %edx,%eax
  802291:	a3 48 41 80 00       	mov    %eax,0x804148
  802296:	a1 50 40 80 00       	mov    0x804050,%eax
  80229b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80229e:	c1 e2 04             	shl    $0x4,%edx
  8022a1:	01 d0                	add    %edx,%eax
  8022a3:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8022aa:	a1 54 41 80 00       	mov    0x804154,%eax
  8022af:	40                   	inc    %eax
  8022b0:	a3 54 41 80 00       	mov    %eax,0x804154
	// Write your code here, remove the panic and write your code
	//panic("initialize_MemBlocksList() is not implemented yet...!!");
	uint32 n = numOfBlocks;

	LIST_INIT(&AvailableMemBlocksList);
	for(int i = 0; i<n;i++)
  8022b5:	ff 45 f4             	incl   -0xc(%ebp)
  8022b8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022bb:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8022be:	0f 82 56 ff ff ff    	jb     80221a <initialize_MemBlocksList+0x36>
	{
		LIST_INSERT_HEAD(&AvailableMemBlocksList, &(MemBlockNodes[i]));
	}
}
  8022c4:	90                   	nop
  8022c5:	c9                   	leave  
  8022c6:	c3                   	ret    

008022c7 <find_block>:

//===============================
// [2] FIND BLOCK:
//===============================
struct MemBlock *find_block(struct MemBlock_List *blockList, uint32 va)
{
  8022c7:	55                   	push   %ebp
  8022c8:	89 e5                	mov    %esp,%ebp
  8022ca:	83 ec 10             	sub    $0x10,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] find_block
	// Write your code here, remove the panic and write your code
	//panic("find_block() is not implemented yet...!!");
	uint32 virAddress = va;
  8022cd:	8b 45 0c             	mov    0xc(%ebp),%eax
  8022d0:	89 45 f4             	mov    %eax,-0xc(%ebp)
	struct MemBlock* blk;
	int found = 0;
  8022d3:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	LIST_FOREACH(blk, &(AllocMemBlocksList))
  8022da:	a1 40 40 80 00       	mov    0x804040,%eax
  8022df:	89 45 fc             	mov    %eax,-0x4(%ebp)
  8022e2:	eb 23                	jmp    802307 <find_block+0x40>
	{
		if(blk->sva == virAddress)
  8022e4:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8022e7:	8b 40 08             	mov    0x8(%eax),%eax
  8022ea:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  8022ed:	75 09                	jne    8022f8 <find_block+0x31>
		{
			found = 1;
  8022ef:	c7 45 f8 01 00 00 00 	movl   $0x1,-0x8(%ebp)
			break;
  8022f6:	eb 35                	jmp    80232d <find_block+0x66>
		}
		else
		{
			found = 0;
  8022f8:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	//panic("find_block() is not implemented yet...!!");
	uint32 virAddress = va;
	struct MemBlock* blk;
	int found = 0;

	LIST_FOREACH(blk, &(AllocMemBlocksList))
  8022ff:	a1 48 40 80 00       	mov    0x804048,%eax
  802304:	89 45 fc             	mov    %eax,-0x4(%ebp)
  802307:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  80230b:	74 07                	je     802314 <find_block+0x4d>
  80230d:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802310:	8b 00                	mov    (%eax),%eax
  802312:	eb 05                	jmp    802319 <find_block+0x52>
  802314:	b8 00 00 00 00       	mov    $0x0,%eax
  802319:	a3 48 40 80 00       	mov    %eax,0x804048
  80231e:	a1 48 40 80 00       	mov    0x804048,%eax
  802323:	85 c0                	test   %eax,%eax
  802325:	75 bd                	jne    8022e4 <find_block+0x1d>
  802327:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  80232b:	75 b7                	jne    8022e4 <find_block+0x1d>
		{
			found = 0;
			continue;
		}
	}
	if(found == 1)
  80232d:	83 7d f8 01          	cmpl   $0x1,-0x8(%ebp)
  802331:	75 05                	jne    802338 <find_block+0x71>
	{
		return blk;
  802333:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802336:	eb 05                	jmp    80233d <find_block+0x76>
	}
	else
	{
		return NULL;
  802338:	b8 00 00 00 00       	mov    $0x0,%eax
	}
}
  80233d:	c9                   	leave  
  80233e:	c3                   	ret    

0080233f <insert_sorted_allocList>:

//=========================================
// [3] INSERT BLOCK IN ALLOC LIST [SORTED]:
//=========================================
void insert_sorted_allocList(struct MemBlock *blockToInsert)
{
  80233f:	55                   	push   %ebp
  802340:	89 e5                	mov    %esp,%ebp
  802342:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] insert_sorted_allocList
	// Write your code here, remove the panic and write your code
	//panic("insert_sorted_allocList() is not implemented yet...!!");
	struct MemBlock* blk;
	struct MemBlock* newblk = blockToInsert;
  802345:	8b 45 08             	mov    0x8(%ebp),%eax
  802348:	89 45 f0             	mov    %eax,-0x10(%ebp)

	if((LIST_EMPTY(&AllocMemBlocksList)) || (newblk->sva < LIST_FIRST(&AllocMemBlocksList)->sva))
  80234b:	a1 40 40 80 00       	mov    0x804040,%eax
  802350:	85 c0                	test   %eax,%eax
  802352:	74 12                	je     802366 <insert_sorted_allocList+0x27>
  802354:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802357:	8b 50 08             	mov    0x8(%eax),%edx
  80235a:	a1 40 40 80 00       	mov    0x804040,%eax
  80235f:	8b 40 08             	mov    0x8(%eax),%eax
  802362:	39 c2                	cmp    %eax,%edx
  802364:	73 65                	jae    8023cb <insert_sorted_allocList+0x8c>
	{
		LIST_INSERT_HEAD(&(AllocMemBlocksList), newblk);
  802366:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80236a:	75 14                	jne    802380 <insert_sorted_allocList+0x41>
  80236c:	83 ec 04             	sub    $0x4,%esp
  80236f:	68 14 3b 80 00       	push   $0x803b14
  802374:	6a 7b                	push   $0x7b
  802376:	68 37 3b 80 00       	push   $0x803b37
  80237b:	e8 e3 0c 00 00       	call   803063 <_panic>
  802380:	8b 15 40 40 80 00    	mov    0x804040,%edx
  802386:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802389:	89 10                	mov    %edx,(%eax)
  80238b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80238e:	8b 00                	mov    (%eax),%eax
  802390:	85 c0                	test   %eax,%eax
  802392:	74 0d                	je     8023a1 <insert_sorted_allocList+0x62>
  802394:	a1 40 40 80 00       	mov    0x804040,%eax
  802399:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80239c:	89 50 04             	mov    %edx,0x4(%eax)
  80239f:	eb 08                	jmp    8023a9 <insert_sorted_allocList+0x6a>
  8023a1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8023a4:	a3 44 40 80 00       	mov    %eax,0x804044
  8023a9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8023ac:	a3 40 40 80 00       	mov    %eax,0x804040
  8023b1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8023b4:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8023bb:	a1 4c 40 80 00       	mov    0x80404c,%eax
  8023c0:	40                   	inc    %eax
  8023c1:	a3 4c 40 80 00       	mov    %eax,0x80404c
  8023c6:	e9 5f 01 00 00       	jmp    80252a <insert_sorted_allocList+0x1eb>
	}
	else if(newblk->sva > LIST_LAST(&AllocMemBlocksList)->sva)
  8023cb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8023ce:	8b 50 08             	mov    0x8(%eax),%edx
  8023d1:	a1 44 40 80 00       	mov    0x804044,%eax
  8023d6:	8b 40 08             	mov    0x8(%eax),%eax
  8023d9:	39 c2                	cmp    %eax,%edx
  8023db:	76 65                	jbe    802442 <insert_sorted_allocList+0x103>
	{
		LIST_INSERT_TAIL(&AllocMemBlocksList, newblk);
  8023dd:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8023e1:	75 14                	jne    8023f7 <insert_sorted_allocList+0xb8>
  8023e3:	83 ec 04             	sub    $0x4,%esp
  8023e6:	68 50 3b 80 00       	push   $0x803b50
  8023eb:	6a 7f                	push   $0x7f
  8023ed:	68 37 3b 80 00       	push   $0x803b37
  8023f2:	e8 6c 0c 00 00       	call   803063 <_panic>
  8023f7:	8b 15 44 40 80 00    	mov    0x804044,%edx
  8023fd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802400:	89 50 04             	mov    %edx,0x4(%eax)
  802403:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802406:	8b 40 04             	mov    0x4(%eax),%eax
  802409:	85 c0                	test   %eax,%eax
  80240b:	74 0c                	je     802419 <insert_sorted_allocList+0xda>
  80240d:	a1 44 40 80 00       	mov    0x804044,%eax
  802412:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802415:	89 10                	mov    %edx,(%eax)
  802417:	eb 08                	jmp    802421 <insert_sorted_allocList+0xe2>
  802419:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80241c:	a3 40 40 80 00       	mov    %eax,0x804040
  802421:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802424:	a3 44 40 80 00       	mov    %eax,0x804044
  802429:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80242c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802432:	a1 4c 40 80 00       	mov    0x80404c,%eax
  802437:	40                   	inc    %eax
  802438:	a3 4c 40 80 00       	mov    %eax,0x80404c
				LIST_INSERT_AFTER(&AllocMemBlocksList, blk, newblk);
				break;
			}
		}
	}
}
  80243d:	e9 e8 00 00 00       	jmp    80252a <insert_sorted_allocList+0x1eb>
	{
		LIST_INSERT_TAIL(&AllocMemBlocksList, newblk);
	}
	else
	{
		LIST_FOREACH(blk, &AllocMemBlocksList)
  802442:	a1 40 40 80 00       	mov    0x804040,%eax
  802447:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80244a:	e9 ab 00 00 00       	jmp    8024fa <insert_sorted_allocList+0x1bb>
		{
			if(blk->prev_next_info.le_next != NULL && newblk->sva > blk->sva  && newblk->sva < blk->prev_next_info.le_next->sva)
  80244f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802452:	8b 00                	mov    (%eax),%eax
  802454:	85 c0                	test   %eax,%eax
  802456:	0f 84 96 00 00 00    	je     8024f2 <insert_sorted_allocList+0x1b3>
  80245c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80245f:	8b 50 08             	mov    0x8(%eax),%edx
  802462:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802465:	8b 40 08             	mov    0x8(%eax),%eax
  802468:	39 c2                	cmp    %eax,%edx
  80246a:	0f 86 82 00 00 00    	jbe    8024f2 <insert_sorted_allocList+0x1b3>
  802470:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802473:	8b 50 08             	mov    0x8(%eax),%edx
  802476:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802479:	8b 00                	mov    (%eax),%eax
  80247b:	8b 40 08             	mov    0x8(%eax),%eax
  80247e:	39 c2                	cmp    %eax,%edx
  802480:	73 70                	jae    8024f2 <insert_sorted_allocList+0x1b3>
			{
				LIST_INSERT_AFTER(&AllocMemBlocksList, blk, newblk);
  802482:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802486:	74 06                	je     80248e <insert_sorted_allocList+0x14f>
  802488:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80248c:	75 17                	jne    8024a5 <insert_sorted_allocList+0x166>
  80248e:	83 ec 04             	sub    $0x4,%esp
  802491:	68 74 3b 80 00       	push   $0x803b74
  802496:	68 87 00 00 00       	push   $0x87
  80249b:	68 37 3b 80 00       	push   $0x803b37
  8024a0:	e8 be 0b 00 00       	call   803063 <_panic>
  8024a5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024a8:	8b 10                	mov    (%eax),%edx
  8024aa:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8024ad:	89 10                	mov    %edx,(%eax)
  8024af:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8024b2:	8b 00                	mov    (%eax),%eax
  8024b4:	85 c0                	test   %eax,%eax
  8024b6:	74 0b                	je     8024c3 <insert_sorted_allocList+0x184>
  8024b8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024bb:	8b 00                	mov    (%eax),%eax
  8024bd:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8024c0:	89 50 04             	mov    %edx,0x4(%eax)
  8024c3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024c6:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8024c9:	89 10                	mov    %edx,(%eax)
  8024cb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8024ce:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8024d1:	89 50 04             	mov    %edx,0x4(%eax)
  8024d4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8024d7:	8b 00                	mov    (%eax),%eax
  8024d9:	85 c0                	test   %eax,%eax
  8024db:	75 08                	jne    8024e5 <insert_sorted_allocList+0x1a6>
  8024dd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8024e0:	a3 44 40 80 00       	mov    %eax,0x804044
  8024e5:	a1 4c 40 80 00       	mov    0x80404c,%eax
  8024ea:	40                   	inc    %eax
  8024eb:	a3 4c 40 80 00       	mov    %eax,0x80404c
				break;
  8024f0:	eb 38                	jmp    80252a <insert_sorted_allocList+0x1eb>
	{
		LIST_INSERT_TAIL(&AllocMemBlocksList, newblk);
	}
	else
	{
		LIST_FOREACH(blk, &AllocMemBlocksList)
  8024f2:	a1 48 40 80 00       	mov    0x804048,%eax
  8024f7:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8024fa:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8024fe:	74 07                	je     802507 <insert_sorted_allocList+0x1c8>
  802500:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802503:	8b 00                	mov    (%eax),%eax
  802505:	eb 05                	jmp    80250c <insert_sorted_allocList+0x1cd>
  802507:	b8 00 00 00 00       	mov    $0x0,%eax
  80250c:	a3 48 40 80 00       	mov    %eax,0x804048
  802511:	a1 48 40 80 00       	mov    0x804048,%eax
  802516:	85 c0                	test   %eax,%eax
  802518:	0f 85 31 ff ff ff    	jne    80244f <insert_sorted_allocList+0x110>
  80251e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802522:	0f 85 27 ff ff ff    	jne    80244f <insert_sorted_allocList+0x110>
				LIST_INSERT_AFTER(&AllocMemBlocksList, blk, newblk);
				break;
			}
		}
	}
}
  802528:	eb 00                	jmp    80252a <insert_sorted_allocList+0x1eb>
  80252a:	90                   	nop
  80252b:	c9                   	leave  
  80252c:	c3                   	ret    

0080252d <alloc_block_FF>:

//=========================================
// [4] ALLOCATE BLOCK BY FIRST FIT:
//=========================================
struct MemBlock *alloc_block_FF(uint32 size)
{
  80252d:	55                   	push   %ebp
  80252e:	89 e5                	mov    %esp,%ebp
  802530:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_FF
	// Write your code here, remove the panic and write your code
	//panic("alloc_block_FF() is not implemented yet...!!");
	uint32 versize = size;
  802533:	8b 45 08             	mov    0x8(%ebp),%eax
  802536:	89 45 f0             	mov    %eax,-0x10(%ebp)
	struct MemBlock* blk;
	struct MemBlock* newblk = LIST_FIRST(&AvailableMemBlocksList);
  802539:	a1 48 41 80 00       	mov    0x804148,%eax
  80253e:	89 45 ec             	mov    %eax,-0x14(%ebp)

	LIST_FOREACH(blk,&FreeMemBlocksList)
  802541:	a1 38 41 80 00       	mov    0x804138,%eax
  802546:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802549:	e9 77 01 00 00       	jmp    8026c5 <alloc_block_FF+0x198>
	{
		if(blk->size == versize)
  80254e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802551:	8b 40 0c             	mov    0xc(%eax),%eax
  802554:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  802557:	0f 85 8a 00 00 00    	jne    8025e7 <alloc_block_FF+0xba>
		{
			LIST_REMOVE(&FreeMemBlocksList,blk);
  80255d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802561:	75 17                	jne    80257a <alloc_block_FF+0x4d>
  802563:	83 ec 04             	sub    $0x4,%esp
  802566:	68 a8 3b 80 00       	push   $0x803ba8
  80256b:	68 9e 00 00 00       	push   $0x9e
  802570:	68 37 3b 80 00       	push   $0x803b37
  802575:	e8 e9 0a 00 00       	call   803063 <_panic>
  80257a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80257d:	8b 00                	mov    (%eax),%eax
  80257f:	85 c0                	test   %eax,%eax
  802581:	74 10                	je     802593 <alloc_block_FF+0x66>
  802583:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802586:	8b 00                	mov    (%eax),%eax
  802588:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80258b:	8b 52 04             	mov    0x4(%edx),%edx
  80258e:	89 50 04             	mov    %edx,0x4(%eax)
  802591:	eb 0b                	jmp    80259e <alloc_block_FF+0x71>
  802593:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802596:	8b 40 04             	mov    0x4(%eax),%eax
  802599:	a3 3c 41 80 00       	mov    %eax,0x80413c
  80259e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025a1:	8b 40 04             	mov    0x4(%eax),%eax
  8025a4:	85 c0                	test   %eax,%eax
  8025a6:	74 0f                	je     8025b7 <alloc_block_FF+0x8a>
  8025a8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025ab:	8b 40 04             	mov    0x4(%eax),%eax
  8025ae:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8025b1:	8b 12                	mov    (%edx),%edx
  8025b3:	89 10                	mov    %edx,(%eax)
  8025b5:	eb 0a                	jmp    8025c1 <alloc_block_FF+0x94>
  8025b7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025ba:	8b 00                	mov    (%eax),%eax
  8025bc:	a3 38 41 80 00       	mov    %eax,0x804138
  8025c1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025c4:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8025ca:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025cd:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8025d4:	a1 44 41 80 00       	mov    0x804144,%eax
  8025d9:	48                   	dec    %eax
  8025da:	a3 44 41 80 00       	mov    %eax,0x804144
			return blk;
  8025df:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025e2:	e9 11 01 00 00       	jmp    8026f8 <alloc_block_FF+0x1cb>
		}
		else if(blk->size > versize)
  8025e7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025ea:	8b 40 0c             	mov    0xc(%eax),%eax
  8025ed:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8025f0:	0f 86 c7 00 00 00    	jbe    8026bd <alloc_block_FF+0x190>
		{
			LIST_REMOVE(&AvailableMemBlocksList,newblk);
  8025f6:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8025fa:	75 17                	jne    802613 <alloc_block_FF+0xe6>
  8025fc:	83 ec 04             	sub    $0x4,%esp
  8025ff:	68 a8 3b 80 00       	push   $0x803ba8
  802604:	68 a3 00 00 00       	push   $0xa3
  802609:	68 37 3b 80 00       	push   $0x803b37
  80260e:	e8 50 0a 00 00       	call   803063 <_panic>
  802613:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802616:	8b 00                	mov    (%eax),%eax
  802618:	85 c0                	test   %eax,%eax
  80261a:	74 10                	je     80262c <alloc_block_FF+0xff>
  80261c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80261f:	8b 00                	mov    (%eax),%eax
  802621:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802624:	8b 52 04             	mov    0x4(%edx),%edx
  802627:	89 50 04             	mov    %edx,0x4(%eax)
  80262a:	eb 0b                	jmp    802637 <alloc_block_FF+0x10a>
  80262c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80262f:	8b 40 04             	mov    0x4(%eax),%eax
  802632:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802637:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80263a:	8b 40 04             	mov    0x4(%eax),%eax
  80263d:	85 c0                	test   %eax,%eax
  80263f:	74 0f                	je     802650 <alloc_block_FF+0x123>
  802641:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802644:	8b 40 04             	mov    0x4(%eax),%eax
  802647:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80264a:	8b 12                	mov    (%edx),%edx
  80264c:	89 10                	mov    %edx,(%eax)
  80264e:	eb 0a                	jmp    80265a <alloc_block_FF+0x12d>
  802650:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802653:	8b 00                	mov    (%eax),%eax
  802655:	a3 48 41 80 00       	mov    %eax,0x804148
  80265a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80265d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802663:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802666:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80266d:	a1 54 41 80 00       	mov    0x804154,%eax
  802672:	48                   	dec    %eax
  802673:	a3 54 41 80 00       	mov    %eax,0x804154
			newblk->size = versize;
  802678:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80267b:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80267e:	89 50 0c             	mov    %edx,0xc(%eax)
			blk->size = blk->size-versize;
  802681:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802684:	8b 40 0c             	mov    0xc(%eax),%eax
  802687:	2b 45 f0             	sub    -0x10(%ebp),%eax
  80268a:	89 c2                	mov    %eax,%edx
  80268c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80268f:	89 50 0c             	mov    %edx,0xc(%eax)
			uint32 newveradd = blk->sva;
  802692:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802695:	8b 40 08             	mov    0x8(%eax),%eax
  802698:	89 45 e8             	mov    %eax,-0x18(%ebp)
			blk->sva+=newblk->size;
  80269b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80269e:	8b 50 08             	mov    0x8(%eax),%edx
  8026a1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8026a4:	8b 40 0c             	mov    0xc(%eax),%eax
  8026a7:	01 c2                	add    %eax,%edx
  8026a9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026ac:	89 50 08             	mov    %edx,0x8(%eax)
			newblk->sva = newveradd;
  8026af:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8026b2:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8026b5:	89 50 08             	mov    %edx,0x8(%eax)
			return newblk;
  8026b8:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8026bb:	eb 3b                	jmp    8026f8 <alloc_block_FF+0x1cb>
	//panic("alloc_block_FF() is not implemented yet...!!");
	uint32 versize = size;
	struct MemBlock* blk;
	struct MemBlock* newblk = LIST_FIRST(&AvailableMemBlocksList);

	LIST_FOREACH(blk,&FreeMemBlocksList)
  8026bd:	a1 40 41 80 00       	mov    0x804140,%eax
  8026c2:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8026c5:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8026c9:	74 07                	je     8026d2 <alloc_block_FF+0x1a5>
  8026cb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026ce:	8b 00                	mov    (%eax),%eax
  8026d0:	eb 05                	jmp    8026d7 <alloc_block_FF+0x1aa>
  8026d2:	b8 00 00 00 00       	mov    $0x0,%eax
  8026d7:	a3 40 41 80 00       	mov    %eax,0x804140
  8026dc:	a1 40 41 80 00       	mov    0x804140,%eax
  8026e1:	85 c0                	test   %eax,%eax
  8026e3:	0f 85 65 fe ff ff    	jne    80254e <alloc_block_FF+0x21>
  8026e9:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8026ed:	0f 85 5b fe ff ff    	jne    80254e <alloc_block_FF+0x21>
			blk->sva+=newblk->size;
			newblk->sva = newveradd;
			return newblk;
		}
	}
	return NULL;
  8026f3:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8026f8:	c9                   	leave  
  8026f9:	c3                   	ret    

008026fa <alloc_block_BF>:

//=========================================
// [5] ALLOCATE BLOCK BY BEST FIT:
//=========================================
struct MemBlock *alloc_block_BF(uint32 size)
{
  8026fa:	55                   	push   %ebp
  8026fb:	89 e5                	mov    %esp,%ebp
  8026fd:	83 ec 28             	sub    $0x28,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_BF
	// Write your code here, remove the panic and write your code
	//panic("alloc_block_BF() is not implemented yet...!!");
	uint32 versize=size;
  802700:	8b 45 08             	mov    0x8(%ebp),%eax
  802703:	89 45 e8             	mov    %eax,-0x18(%ebp)
	struct MemBlock* blk;
	struct MemBlock* newblk=LIST_FIRST(&AvailableMemBlocksList);
  802706:	a1 48 41 80 00       	mov    0x804148,%eax
  80270b:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	uint32 newveradd;
	uint32 newsize;
	int size_free = LIST_SIZE(&FreeMemBlocksList);
  80270e:	a1 44 41 80 00       	mov    0x804144,%eax
  802713:	89 45 e0             	mov    %eax,-0x20(%ebp)

	LIST_FOREACH(blk, &FreeMemBlocksList)
  802716:	a1 38 41 80 00       	mov    0x804138,%eax
  80271b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80271e:	e9 a1 00 00 00       	jmp    8027c4 <alloc_block_BF+0xca>
	{
		if(blk->size == versize)
  802723:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802726:	8b 40 0c             	mov    0xc(%eax),%eax
  802729:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  80272c:	0f 85 8a 00 00 00    	jne    8027bc <alloc_block_BF+0xc2>
		{
			LIST_REMOVE(&FreeMemBlocksList, blk);
  802732:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802736:	75 17                	jne    80274f <alloc_block_BF+0x55>
  802738:	83 ec 04             	sub    $0x4,%esp
  80273b:	68 a8 3b 80 00       	push   $0x803ba8
  802740:	68 c2 00 00 00       	push   $0xc2
  802745:	68 37 3b 80 00       	push   $0x803b37
  80274a:	e8 14 09 00 00       	call   803063 <_panic>
  80274f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802752:	8b 00                	mov    (%eax),%eax
  802754:	85 c0                	test   %eax,%eax
  802756:	74 10                	je     802768 <alloc_block_BF+0x6e>
  802758:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80275b:	8b 00                	mov    (%eax),%eax
  80275d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802760:	8b 52 04             	mov    0x4(%edx),%edx
  802763:	89 50 04             	mov    %edx,0x4(%eax)
  802766:	eb 0b                	jmp    802773 <alloc_block_BF+0x79>
  802768:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80276b:	8b 40 04             	mov    0x4(%eax),%eax
  80276e:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802773:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802776:	8b 40 04             	mov    0x4(%eax),%eax
  802779:	85 c0                	test   %eax,%eax
  80277b:	74 0f                	je     80278c <alloc_block_BF+0x92>
  80277d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802780:	8b 40 04             	mov    0x4(%eax),%eax
  802783:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802786:	8b 12                	mov    (%edx),%edx
  802788:	89 10                	mov    %edx,(%eax)
  80278a:	eb 0a                	jmp    802796 <alloc_block_BF+0x9c>
  80278c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80278f:	8b 00                	mov    (%eax),%eax
  802791:	a3 38 41 80 00       	mov    %eax,0x804138
  802796:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802799:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80279f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027a2:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8027a9:	a1 44 41 80 00       	mov    0x804144,%eax
  8027ae:	48                   	dec    %eax
  8027af:	a3 44 41 80 00       	mov    %eax,0x804144
			return blk;
  8027b4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027b7:	e9 11 02 00 00       	jmp    8029cd <alloc_block_BF+0x2d3>
	struct MemBlock* newblk=LIST_FIRST(&AvailableMemBlocksList);
	uint32 newveradd;
	uint32 newsize;
	int size_free = LIST_SIZE(&FreeMemBlocksList);

	LIST_FOREACH(blk, &FreeMemBlocksList)
  8027bc:	a1 40 41 80 00       	mov    0x804140,%eax
  8027c1:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8027c4:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8027c8:	74 07                	je     8027d1 <alloc_block_BF+0xd7>
  8027ca:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027cd:	8b 00                	mov    (%eax),%eax
  8027cf:	eb 05                	jmp    8027d6 <alloc_block_BF+0xdc>
  8027d1:	b8 00 00 00 00       	mov    $0x0,%eax
  8027d6:	a3 40 41 80 00       	mov    %eax,0x804140
  8027db:	a1 40 41 80 00       	mov    0x804140,%eax
  8027e0:	85 c0                	test   %eax,%eax
  8027e2:	0f 85 3b ff ff ff    	jne    802723 <alloc_block_BF+0x29>
  8027e8:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8027ec:	0f 85 31 ff ff ff    	jne    802723 <alloc_block_BF+0x29>
		{
			LIST_REMOVE(&FreeMemBlocksList, blk);
			return blk;
		}
	}
	LIST_FOREACH(blk, &FreeMemBlocksList)
  8027f2:	a1 38 41 80 00       	mov    0x804138,%eax
  8027f7:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8027fa:	eb 27                	jmp    802823 <alloc_block_BF+0x129>
	{
		if(blk->size > versize)
  8027fc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027ff:	8b 40 0c             	mov    0xc(%eax),%eax
  802802:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  802805:	76 14                	jbe    80281b <alloc_block_BF+0x121>
		{
			newsize = blk->size;
  802807:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80280a:	8b 40 0c             	mov    0xc(%eax),%eax
  80280d:	89 45 ec             	mov    %eax,-0x14(%ebp)
			newveradd = blk->sva;
  802810:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802813:	8b 40 08             	mov    0x8(%eax),%eax
  802816:	89 45 f0             	mov    %eax,-0x10(%ebp)
			break;
  802819:	eb 2e                	jmp    802849 <alloc_block_BF+0x14f>
		{
			LIST_REMOVE(&FreeMemBlocksList, blk);
			return blk;
		}
	}
	LIST_FOREACH(blk, &FreeMemBlocksList)
  80281b:	a1 40 41 80 00       	mov    0x804140,%eax
  802820:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802823:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802827:	74 07                	je     802830 <alloc_block_BF+0x136>
  802829:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80282c:	8b 00                	mov    (%eax),%eax
  80282e:	eb 05                	jmp    802835 <alloc_block_BF+0x13b>
  802830:	b8 00 00 00 00       	mov    $0x0,%eax
  802835:	a3 40 41 80 00       	mov    %eax,0x804140
  80283a:	a1 40 41 80 00       	mov    0x804140,%eax
  80283f:	85 c0                	test   %eax,%eax
  802841:	75 b9                	jne    8027fc <alloc_block_BF+0x102>
  802843:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802847:	75 b3                	jne    8027fc <alloc_block_BF+0x102>
			newsize = blk->size;
			newveradd = blk->sva;
			break;
		}
	}
	LIST_FOREACH(blk, &FreeMemBlocksList)
  802849:	a1 38 41 80 00       	mov    0x804138,%eax
  80284e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802851:	eb 30                	jmp    802883 <alloc_block_BF+0x189>
	{
		if(newsize > blk->size && blk->size > versize)
  802853:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802856:	8b 40 0c             	mov    0xc(%eax),%eax
  802859:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  80285c:	73 1d                	jae    80287b <alloc_block_BF+0x181>
  80285e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802861:	8b 40 0c             	mov    0xc(%eax),%eax
  802864:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  802867:	76 12                	jbe    80287b <alloc_block_BF+0x181>
		{
	       newsize = blk->size;
  802869:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80286c:	8b 40 0c             	mov    0xc(%eax),%eax
  80286f:	89 45 ec             	mov    %eax,-0x14(%ebp)
		   newveradd = blk->sva;
  802872:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802875:	8b 40 08             	mov    0x8(%eax),%eax
  802878:	89 45 f0             	mov    %eax,-0x10(%ebp)
			newsize = blk->size;
			newveradd = blk->sva;
			break;
		}
	}
	LIST_FOREACH(blk, &FreeMemBlocksList)
  80287b:	a1 40 41 80 00       	mov    0x804140,%eax
  802880:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802883:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802887:	74 07                	je     802890 <alloc_block_BF+0x196>
  802889:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80288c:	8b 00                	mov    (%eax),%eax
  80288e:	eb 05                	jmp    802895 <alloc_block_BF+0x19b>
  802890:	b8 00 00 00 00       	mov    $0x0,%eax
  802895:	a3 40 41 80 00       	mov    %eax,0x804140
  80289a:	a1 40 41 80 00       	mov    0x804140,%eax
  80289f:	85 c0                	test   %eax,%eax
  8028a1:	75 b0                	jne    802853 <alloc_block_BF+0x159>
  8028a3:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8028a7:	75 aa                	jne    802853 <alloc_block_BF+0x159>
		{
	       newsize = blk->size;
		   newveradd = blk->sva;
		}
	}
	LIST_FOREACH(blk, &FreeMemBlocksList)
  8028a9:	a1 38 41 80 00       	mov    0x804138,%eax
  8028ae:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8028b1:	e9 e4 00 00 00       	jmp    80299a <alloc_block_BF+0x2a0>
	{
		if(blk->size == newsize && blk->sva == newveradd)
  8028b6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028b9:	8b 40 0c             	mov    0xc(%eax),%eax
  8028bc:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  8028bf:	0f 85 cd 00 00 00    	jne    802992 <alloc_block_BF+0x298>
  8028c5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028c8:	8b 40 08             	mov    0x8(%eax),%eax
  8028cb:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8028ce:	0f 85 be 00 00 00    	jne    802992 <alloc_block_BF+0x298>
		{
			LIST_REMOVE(&AvailableMemBlocksList, newblk);
  8028d4:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8028d8:	75 17                	jne    8028f1 <alloc_block_BF+0x1f7>
  8028da:	83 ec 04             	sub    $0x4,%esp
  8028dd:	68 a8 3b 80 00       	push   $0x803ba8
  8028e2:	68 db 00 00 00       	push   $0xdb
  8028e7:	68 37 3b 80 00       	push   $0x803b37
  8028ec:	e8 72 07 00 00       	call   803063 <_panic>
  8028f1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8028f4:	8b 00                	mov    (%eax),%eax
  8028f6:	85 c0                	test   %eax,%eax
  8028f8:	74 10                	je     80290a <alloc_block_BF+0x210>
  8028fa:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8028fd:	8b 00                	mov    (%eax),%eax
  8028ff:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802902:	8b 52 04             	mov    0x4(%edx),%edx
  802905:	89 50 04             	mov    %edx,0x4(%eax)
  802908:	eb 0b                	jmp    802915 <alloc_block_BF+0x21b>
  80290a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80290d:	8b 40 04             	mov    0x4(%eax),%eax
  802910:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802915:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802918:	8b 40 04             	mov    0x4(%eax),%eax
  80291b:	85 c0                	test   %eax,%eax
  80291d:	74 0f                	je     80292e <alloc_block_BF+0x234>
  80291f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802922:	8b 40 04             	mov    0x4(%eax),%eax
  802925:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802928:	8b 12                	mov    (%edx),%edx
  80292a:	89 10                	mov    %edx,(%eax)
  80292c:	eb 0a                	jmp    802938 <alloc_block_BF+0x23e>
  80292e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802931:	8b 00                	mov    (%eax),%eax
  802933:	a3 48 41 80 00       	mov    %eax,0x804148
  802938:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80293b:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802941:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802944:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80294b:	a1 54 41 80 00       	mov    0x804154,%eax
  802950:	48                   	dec    %eax
  802951:	a3 54 41 80 00       	mov    %eax,0x804154
			newblk->size = versize;
  802956:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802959:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80295c:	89 50 0c             	mov    %edx,0xc(%eax)
			newblk->sva = newveradd;
  80295f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802962:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802965:	89 50 08             	mov    %edx,0x8(%eax)
			blk->size = blk->size - versize;
  802968:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80296b:	8b 40 0c             	mov    0xc(%eax),%eax
  80296e:	2b 45 e8             	sub    -0x18(%ebp),%eax
  802971:	89 c2                	mov    %eax,%edx
  802973:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802976:	89 50 0c             	mov    %edx,0xc(%eax)
			blk->sva+= newblk->size;
  802979:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80297c:	8b 50 08             	mov    0x8(%eax),%edx
  80297f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802982:	8b 40 0c             	mov    0xc(%eax),%eax
  802985:	01 c2                	add    %eax,%edx
  802987:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80298a:	89 50 08             	mov    %edx,0x8(%eax)
			return newblk;
  80298d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802990:	eb 3b                	jmp    8029cd <alloc_block_BF+0x2d3>
		{
	       newsize = blk->size;
		   newveradd = blk->sva;
		}
	}
	LIST_FOREACH(blk, &FreeMemBlocksList)
  802992:	a1 40 41 80 00       	mov    0x804140,%eax
  802997:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80299a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80299e:	74 07                	je     8029a7 <alloc_block_BF+0x2ad>
  8029a0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029a3:	8b 00                	mov    (%eax),%eax
  8029a5:	eb 05                	jmp    8029ac <alloc_block_BF+0x2b2>
  8029a7:	b8 00 00 00 00       	mov    $0x0,%eax
  8029ac:	a3 40 41 80 00       	mov    %eax,0x804140
  8029b1:	a1 40 41 80 00       	mov    0x804140,%eax
  8029b6:	85 c0                	test   %eax,%eax
  8029b8:	0f 85 f8 fe ff ff    	jne    8028b6 <alloc_block_BF+0x1bc>
  8029be:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8029c2:	0f 85 ee fe ff ff    	jne    8028b6 <alloc_block_BF+0x1bc>
			blk->size = blk->size - versize;
			blk->sva+= newblk->size;
			return newblk;
		}
	}
	return NULL;
  8029c8:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8029cd:	c9                   	leave  
  8029ce:	c3                   	ret    

008029cf <alloc_block_NF>:
//=========================================
// [7] ALLOCATE BLOCK BY NEXT FIT:
//=========================================
struct MemBlock *last_allocate;
struct MemBlock *alloc_block_NF(uint32 size)
{
  8029cf:	55                   	push   %ebp
  8029d0:	89 e5                	mov    %esp,%ebp
  8029d2:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1 - BONUS] [DYNAMIC ALLOCATOR] alloc_block_NF
	// Write your code here, remove the panic and write your code
	//panic("alloc_block_NF() is not implemented yet...!!");
	uint32 versize = size;
  8029d5:	8b 45 08             	mov    0x8(%ebp),%eax
  8029d8:	89 45 f0             	mov    %eax,-0x10(%ebp)
	struct MemBlock* blk;
	struct MemBlock* newblk = LIST_FIRST(&AvailableMemBlocksList);
  8029db:	a1 48 41 80 00       	mov    0x804148,%eax
  8029e0:	89 45 ec             	mov    %eax,-0x14(%ebp)

	LIST_FOREACH(blk,&FreeMemBlocksList)
  8029e3:	a1 38 41 80 00       	mov    0x804138,%eax
  8029e8:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8029eb:	e9 77 01 00 00       	jmp    802b67 <alloc_block_NF+0x198>
	{
		if(blk->size == versize)
  8029f0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029f3:	8b 40 0c             	mov    0xc(%eax),%eax
  8029f6:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8029f9:	0f 85 8a 00 00 00    	jne    802a89 <alloc_block_NF+0xba>
		{
			LIST_REMOVE(&FreeMemBlocksList,blk);
  8029ff:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802a03:	75 17                	jne    802a1c <alloc_block_NF+0x4d>
  802a05:	83 ec 04             	sub    $0x4,%esp
  802a08:	68 a8 3b 80 00       	push   $0x803ba8
  802a0d:	68 f7 00 00 00       	push   $0xf7
  802a12:	68 37 3b 80 00       	push   $0x803b37
  802a17:	e8 47 06 00 00       	call   803063 <_panic>
  802a1c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a1f:	8b 00                	mov    (%eax),%eax
  802a21:	85 c0                	test   %eax,%eax
  802a23:	74 10                	je     802a35 <alloc_block_NF+0x66>
  802a25:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a28:	8b 00                	mov    (%eax),%eax
  802a2a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802a2d:	8b 52 04             	mov    0x4(%edx),%edx
  802a30:	89 50 04             	mov    %edx,0x4(%eax)
  802a33:	eb 0b                	jmp    802a40 <alloc_block_NF+0x71>
  802a35:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a38:	8b 40 04             	mov    0x4(%eax),%eax
  802a3b:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802a40:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a43:	8b 40 04             	mov    0x4(%eax),%eax
  802a46:	85 c0                	test   %eax,%eax
  802a48:	74 0f                	je     802a59 <alloc_block_NF+0x8a>
  802a4a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a4d:	8b 40 04             	mov    0x4(%eax),%eax
  802a50:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802a53:	8b 12                	mov    (%edx),%edx
  802a55:	89 10                	mov    %edx,(%eax)
  802a57:	eb 0a                	jmp    802a63 <alloc_block_NF+0x94>
  802a59:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a5c:	8b 00                	mov    (%eax),%eax
  802a5e:	a3 38 41 80 00       	mov    %eax,0x804138
  802a63:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a66:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802a6c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a6f:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802a76:	a1 44 41 80 00       	mov    0x804144,%eax
  802a7b:	48                   	dec    %eax
  802a7c:	a3 44 41 80 00       	mov    %eax,0x804144
			return blk;
  802a81:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a84:	e9 11 01 00 00       	jmp    802b9a <alloc_block_NF+0x1cb>
		}
		else if(blk->size > versize)
  802a89:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a8c:	8b 40 0c             	mov    0xc(%eax),%eax
  802a8f:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  802a92:	0f 86 c7 00 00 00    	jbe    802b5f <alloc_block_NF+0x190>
		{
			LIST_REMOVE(&AvailableMemBlocksList,newblk);
  802a98:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802a9c:	75 17                	jne    802ab5 <alloc_block_NF+0xe6>
  802a9e:	83 ec 04             	sub    $0x4,%esp
  802aa1:	68 a8 3b 80 00       	push   $0x803ba8
  802aa6:	68 fc 00 00 00       	push   $0xfc
  802aab:	68 37 3b 80 00       	push   $0x803b37
  802ab0:	e8 ae 05 00 00       	call   803063 <_panic>
  802ab5:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802ab8:	8b 00                	mov    (%eax),%eax
  802aba:	85 c0                	test   %eax,%eax
  802abc:	74 10                	je     802ace <alloc_block_NF+0xff>
  802abe:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802ac1:	8b 00                	mov    (%eax),%eax
  802ac3:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802ac6:	8b 52 04             	mov    0x4(%edx),%edx
  802ac9:	89 50 04             	mov    %edx,0x4(%eax)
  802acc:	eb 0b                	jmp    802ad9 <alloc_block_NF+0x10a>
  802ace:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802ad1:	8b 40 04             	mov    0x4(%eax),%eax
  802ad4:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802ad9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802adc:	8b 40 04             	mov    0x4(%eax),%eax
  802adf:	85 c0                	test   %eax,%eax
  802ae1:	74 0f                	je     802af2 <alloc_block_NF+0x123>
  802ae3:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802ae6:	8b 40 04             	mov    0x4(%eax),%eax
  802ae9:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802aec:	8b 12                	mov    (%edx),%edx
  802aee:	89 10                	mov    %edx,(%eax)
  802af0:	eb 0a                	jmp    802afc <alloc_block_NF+0x12d>
  802af2:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802af5:	8b 00                	mov    (%eax),%eax
  802af7:	a3 48 41 80 00       	mov    %eax,0x804148
  802afc:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802aff:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802b05:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802b08:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802b0f:	a1 54 41 80 00       	mov    0x804154,%eax
  802b14:	48                   	dec    %eax
  802b15:	a3 54 41 80 00       	mov    %eax,0x804154
			newblk->size = versize;
  802b1a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802b1d:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802b20:	89 50 0c             	mov    %edx,0xc(%eax)
			blk->size = blk->size-versize;
  802b23:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b26:	8b 40 0c             	mov    0xc(%eax),%eax
  802b29:	2b 45 f0             	sub    -0x10(%ebp),%eax
  802b2c:	89 c2                	mov    %eax,%edx
  802b2e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b31:	89 50 0c             	mov    %edx,0xc(%eax)
			uint32 newveradd = blk->sva;
  802b34:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b37:	8b 40 08             	mov    0x8(%eax),%eax
  802b3a:	89 45 e8             	mov    %eax,-0x18(%ebp)
			blk->sva+=newblk->size;
  802b3d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b40:	8b 50 08             	mov    0x8(%eax),%edx
  802b43:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802b46:	8b 40 0c             	mov    0xc(%eax),%eax
  802b49:	01 c2                	add    %eax,%edx
  802b4b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b4e:	89 50 08             	mov    %edx,0x8(%eax)
			newblk->sva = newveradd;
  802b51:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802b54:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802b57:	89 50 08             	mov    %edx,0x8(%eax)
			return newblk;
  802b5a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802b5d:	eb 3b                	jmp    802b9a <alloc_block_NF+0x1cb>
	//panic("alloc_block_NF() is not implemented yet...!!");
	uint32 versize = size;
	struct MemBlock* blk;
	struct MemBlock* newblk = LIST_FIRST(&AvailableMemBlocksList);

	LIST_FOREACH(blk,&FreeMemBlocksList)
  802b5f:	a1 40 41 80 00       	mov    0x804140,%eax
  802b64:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802b67:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802b6b:	74 07                	je     802b74 <alloc_block_NF+0x1a5>
  802b6d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b70:	8b 00                	mov    (%eax),%eax
  802b72:	eb 05                	jmp    802b79 <alloc_block_NF+0x1aa>
  802b74:	b8 00 00 00 00       	mov    $0x0,%eax
  802b79:	a3 40 41 80 00       	mov    %eax,0x804140
  802b7e:	a1 40 41 80 00       	mov    0x804140,%eax
  802b83:	85 c0                	test   %eax,%eax
  802b85:	0f 85 65 fe ff ff    	jne    8029f0 <alloc_block_NF+0x21>
  802b8b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802b8f:	0f 85 5b fe ff ff    	jne    8029f0 <alloc_block_NF+0x21>
			blk->sva+=newblk->size;
			newblk->sva = newveradd;
			return newblk;
		}
	}
	return NULL;
  802b95:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802b9a:	c9                   	leave  
  802b9b:	c3                   	ret    

00802b9c <addToAvailMemBlocksList>:

//===================================================
// [8] INSERT BLOCK (SORTED WITH MERGE) IN FREE LIST:
//===================================================
void addToAvailMemBlocksList(struct MemBlock *blockToInsert)
{
  802b9c:	55                   	push   %ebp
  802b9d:	89 e5                	mov    %esp,%ebp
  802b9f:	83 ec 08             	sub    $0x8,%esp
	blockToInsert->sva = 0;
  802ba2:	8b 45 08             	mov    0x8(%ebp),%eax
  802ba5:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
	blockToInsert->size = 0;
  802bac:	8b 45 08             	mov    0x8(%ebp),%eax
  802baf:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
	//add to avail
	LIST_INSERT_TAIL(&AvailableMemBlocksList, blockToInsert);
  802bb6:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802bba:	75 17                	jne    802bd3 <addToAvailMemBlocksList+0x37>
  802bbc:	83 ec 04             	sub    $0x4,%esp
  802bbf:	68 50 3b 80 00       	push   $0x803b50
  802bc4:	68 10 01 00 00       	push   $0x110
  802bc9:	68 37 3b 80 00       	push   $0x803b37
  802bce:	e8 90 04 00 00       	call   803063 <_panic>
  802bd3:	8b 15 4c 41 80 00    	mov    0x80414c,%edx
  802bd9:	8b 45 08             	mov    0x8(%ebp),%eax
  802bdc:	89 50 04             	mov    %edx,0x4(%eax)
  802bdf:	8b 45 08             	mov    0x8(%ebp),%eax
  802be2:	8b 40 04             	mov    0x4(%eax),%eax
  802be5:	85 c0                	test   %eax,%eax
  802be7:	74 0c                	je     802bf5 <addToAvailMemBlocksList+0x59>
  802be9:	a1 4c 41 80 00       	mov    0x80414c,%eax
  802bee:	8b 55 08             	mov    0x8(%ebp),%edx
  802bf1:	89 10                	mov    %edx,(%eax)
  802bf3:	eb 08                	jmp    802bfd <addToAvailMemBlocksList+0x61>
  802bf5:	8b 45 08             	mov    0x8(%ebp),%eax
  802bf8:	a3 48 41 80 00       	mov    %eax,0x804148
  802bfd:	8b 45 08             	mov    0x8(%ebp),%eax
  802c00:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802c05:	8b 45 08             	mov    0x8(%ebp),%eax
  802c08:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802c0e:	a1 54 41 80 00       	mov    0x804154,%eax
  802c13:	40                   	inc    %eax
  802c14:	a3 54 41 80 00       	mov    %eax,0x804154
}
  802c19:	90                   	nop
  802c1a:	c9                   	leave  
  802c1b:	c3                   	ret    

00802c1c <insert_sorted_with_merge_freeList>:
void insert_sorted_with_merge_freeList(struct MemBlock *blockToInsert)
{
  802c1c:	55                   	push   %ebp
  802c1d:	89 e5                	mov    %esp,%ebp
  802c1f:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] insert_sorted_with_merge_freeList
	// Write your code here, remove the panic and write your code

	struct MemBlock* last = LIST_LAST(&FreeMemBlocksList);
  802c22:	a1 3c 41 80 00       	mov    0x80413c,%eax
  802c27:	89 45 f0             	mov    %eax,-0x10(%ebp)
	//check if list empty
	if (LIST_SIZE(&(FreeMemBlocksList)) == 0)
  802c2a:	a1 44 41 80 00       	mov    0x804144,%eax
  802c2f:	85 c0                	test   %eax,%eax
  802c31:	75 68                	jne    802c9b <insert_sorted_with_merge_freeList+0x7f>
		LIST_INSERT_HEAD(&FreeMemBlocksList, blockToInsert);
  802c33:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802c37:	75 17                	jne    802c50 <insert_sorted_with_merge_freeList+0x34>
  802c39:	83 ec 04             	sub    $0x4,%esp
  802c3c:	68 14 3b 80 00       	push   $0x803b14
  802c41:	68 1a 01 00 00       	push   $0x11a
  802c46:	68 37 3b 80 00       	push   $0x803b37
  802c4b:	e8 13 04 00 00       	call   803063 <_panic>
  802c50:	8b 15 38 41 80 00    	mov    0x804138,%edx
  802c56:	8b 45 08             	mov    0x8(%ebp),%eax
  802c59:	89 10                	mov    %edx,(%eax)
  802c5b:	8b 45 08             	mov    0x8(%ebp),%eax
  802c5e:	8b 00                	mov    (%eax),%eax
  802c60:	85 c0                	test   %eax,%eax
  802c62:	74 0d                	je     802c71 <insert_sorted_with_merge_freeList+0x55>
  802c64:	a1 38 41 80 00       	mov    0x804138,%eax
  802c69:	8b 55 08             	mov    0x8(%ebp),%edx
  802c6c:	89 50 04             	mov    %edx,0x4(%eax)
  802c6f:	eb 08                	jmp    802c79 <insert_sorted_with_merge_freeList+0x5d>
  802c71:	8b 45 08             	mov    0x8(%ebp),%eax
  802c74:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802c79:	8b 45 08             	mov    0x8(%ebp),%eax
  802c7c:	a3 38 41 80 00       	mov    %eax,0x804138
  802c81:	8b 45 08             	mov    0x8(%ebp),%eax
  802c84:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802c8b:	a1 44 41 80 00       	mov    0x804144,%eax
  802c90:	40                   	inc    %eax
  802c91:	a3 44 41 80 00       	mov    %eax,0x804144
		}
	}

	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  802c96:	e9 c5 03 00 00       	jmp    803060 <insert_sorted_with_merge_freeList+0x444>
	struct MemBlock* last = LIST_LAST(&FreeMemBlocksList);
	//check if list empty
	if (LIST_SIZE(&(FreeMemBlocksList)) == 0)
		LIST_INSERT_HEAD(&FreeMemBlocksList, blockToInsert);
	//check if it's position is at last
	else if (last->sva < blockToInsert->sva) {
  802c9b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c9e:	8b 50 08             	mov    0x8(%eax),%edx
  802ca1:	8b 45 08             	mov    0x8(%ebp),%eax
  802ca4:	8b 40 08             	mov    0x8(%eax),%eax
  802ca7:	39 c2                	cmp    %eax,%edx
  802ca9:	0f 83 b2 00 00 00    	jae    802d61 <insert_sorted_with_merge_freeList+0x145>

		//if i have to merge
		if (last->sva + last->size == blockToInsert->sva) {
  802caf:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802cb2:	8b 50 08             	mov    0x8(%eax),%edx
  802cb5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802cb8:	8b 40 0c             	mov    0xc(%eax),%eax
  802cbb:	01 c2                	add    %eax,%edx
  802cbd:	8b 45 08             	mov    0x8(%ebp),%eax
  802cc0:	8b 40 08             	mov    0x8(%eax),%eax
  802cc3:	39 c2                	cmp    %eax,%edx
  802cc5:	75 27                	jne    802cee <insert_sorted_with_merge_freeList+0xd2>
			last->size = last->size + blockToInsert->size;
  802cc7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802cca:	8b 50 0c             	mov    0xc(%eax),%edx
  802ccd:	8b 45 08             	mov    0x8(%ebp),%eax
  802cd0:	8b 40 0c             	mov    0xc(%eax),%eax
  802cd3:	01 c2                	add    %eax,%edx
  802cd5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802cd8:	89 50 0c             	mov    %edx,0xc(%eax)
			addToAvailMemBlocksList(blockToInsert);
  802cdb:	83 ec 0c             	sub    $0xc,%esp
  802cde:	ff 75 08             	pushl  0x8(%ebp)
  802ce1:	e8 b6 fe ff ff       	call   802b9c <addToAvailMemBlocksList>
  802ce6:	83 c4 10             	add    $0x10,%esp
		}
	}

	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  802ce9:	e9 72 03 00 00       	jmp    803060 <insert_sorted_with_merge_freeList+0x444>
		if (last->sva + last->size == blockToInsert->sva) {
			last->size = last->size + blockToInsert->size;
			addToAvailMemBlocksList(blockToInsert);

		} else {
			LIST_INSERT_AFTER(&FreeMemBlocksList, last, blockToInsert);
  802cee:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802cf2:	74 06                	je     802cfa <insert_sorted_with_merge_freeList+0xde>
  802cf4:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802cf8:	75 17                	jne    802d11 <insert_sorted_with_merge_freeList+0xf5>
  802cfa:	83 ec 04             	sub    $0x4,%esp
  802cfd:	68 74 3b 80 00       	push   $0x803b74
  802d02:	68 24 01 00 00       	push   $0x124
  802d07:	68 37 3b 80 00       	push   $0x803b37
  802d0c:	e8 52 03 00 00       	call   803063 <_panic>
  802d11:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d14:	8b 10                	mov    (%eax),%edx
  802d16:	8b 45 08             	mov    0x8(%ebp),%eax
  802d19:	89 10                	mov    %edx,(%eax)
  802d1b:	8b 45 08             	mov    0x8(%ebp),%eax
  802d1e:	8b 00                	mov    (%eax),%eax
  802d20:	85 c0                	test   %eax,%eax
  802d22:	74 0b                	je     802d2f <insert_sorted_with_merge_freeList+0x113>
  802d24:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d27:	8b 00                	mov    (%eax),%eax
  802d29:	8b 55 08             	mov    0x8(%ebp),%edx
  802d2c:	89 50 04             	mov    %edx,0x4(%eax)
  802d2f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d32:	8b 55 08             	mov    0x8(%ebp),%edx
  802d35:	89 10                	mov    %edx,(%eax)
  802d37:	8b 45 08             	mov    0x8(%ebp),%eax
  802d3a:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802d3d:	89 50 04             	mov    %edx,0x4(%eax)
  802d40:	8b 45 08             	mov    0x8(%ebp),%eax
  802d43:	8b 00                	mov    (%eax),%eax
  802d45:	85 c0                	test   %eax,%eax
  802d47:	75 08                	jne    802d51 <insert_sorted_with_merge_freeList+0x135>
  802d49:	8b 45 08             	mov    0x8(%ebp),%eax
  802d4c:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802d51:	a1 44 41 80 00       	mov    0x804144,%eax
  802d56:	40                   	inc    %eax
  802d57:	a3 44 41 80 00       	mov    %eax,0x804144
		}
	}

	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  802d5c:	e9 ff 02 00 00       	jmp    803060 <insert_sorted_with_merge_freeList+0x444>
		} else {
			LIST_INSERT_AFTER(&FreeMemBlocksList, last, blockToInsert);
		}
	} else {
		struct MemBlock *iterator;
		LIST_FOREACH(iterator, &(FreeMemBlocksList))
  802d61:	a1 38 41 80 00       	mov    0x804138,%eax
  802d66:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802d69:	e9 c2 02 00 00       	jmp    803030 <insert_sorted_with_merge_freeList+0x414>
		{

			if (iterator->sva > blockToInsert->sva) {
  802d6e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d71:	8b 50 08             	mov    0x8(%eax),%edx
  802d74:	8b 45 08             	mov    0x8(%ebp),%eax
  802d77:	8b 40 08             	mov    0x8(%eax),%eax
  802d7a:	39 c2                	cmp    %eax,%edx
  802d7c:	0f 86 a6 02 00 00    	jbe    803028 <insert_sorted_with_merge_freeList+0x40c>

				struct MemBlock* prev = LIST_PREV(iterator);
  802d82:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d85:	8b 40 04             	mov    0x4(%eax),%eax
  802d88:	89 45 ec             	mov    %eax,-0x14(%ebp)
				if (prev == NULL) {
  802d8b:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802d8f:	0f 85 ba 00 00 00    	jne    802e4f <insert_sorted_with_merge_freeList+0x233>
					//check merge
					if (blockToInsert->size + blockToInsert->sva
  802d95:	8b 45 08             	mov    0x8(%ebp),%eax
  802d98:	8b 50 0c             	mov    0xc(%eax),%edx
  802d9b:	8b 45 08             	mov    0x8(%ebp),%eax
  802d9e:	8b 40 08             	mov    0x8(%eax),%eax
  802da1:	01 c2                	add    %eax,%edx
							== iterator->sva) {
  802da3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802da6:	8b 40 08             	mov    0x8(%eax),%eax
			if (iterator->sva > blockToInsert->sva) {

				struct MemBlock* prev = LIST_PREV(iterator);
				if (prev == NULL) {
					//check merge
					if (blockToInsert->size + blockToInsert->sva
  802da9:	39 c2                	cmp    %eax,%edx
  802dab:	75 33                	jne    802de0 <insert_sorted_with_merge_freeList+0x1c4>
							== iterator->sva) {
						iterator->sva = blockToInsert->sva;
  802dad:	8b 45 08             	mov    0x8(%ebp),%eax
  802db0:	8b 50 08             	mov    0x8(%eax),%edx
  802db3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802db6:	89 50 08             	mov    %edx,0x8(%eax)
						iterator->size = iterator->size + blockToInsert->size;
  802db9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802dbc:	8b 50 0c             	mov    0xc(%eax),%edx
  802dbf:	8b 45 08             	mov    0x8(%ebp),%eax
  802dc2:	8b 40 0c             	mov    0xc(%eax),%eax
  802dc5:	01 c2                	add    %eax,%edx
  802dc7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802dca:	89 50 0c             	mov    %edx,0xc(%eax)
						addToAvailMemBlocksList(blockToInsert);
  802dcd:	83 ec 0c             	sub    $0xc,%esp
  802dd0:	ff 75 08             	pushl  0x8(%ebp)
  802dd3:	e8 c4 fd ff ff       	call   802b9c <addToAvailMemBlocksList>
  802dd8:	83 c4 10             	add    $0x10,%esp

					else {
						LIST_INSERT_BEFORE(&FreeMemBlocksList, iterator,
								blockToInsert);
					}
					break;
  802ddb:	e9 80 02 00 00       	jmp    803060 <insert_sorted_with_merge_freeList+0x444>
						addToAvailMemBlocksList(blockToInsert);

					}

					else {
						LIST_INSERT_BEFORE(&FreeMemBlocksList, iterator,
  802de0:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802de4:	74 06                	je     802dec <insert_sorted_with_merge_freeList+0x1d0>
  802de6:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802dea:	75 17                	jne    802e03 <insert_sorted_with_merge_freeList+0x1e7>
  802dec:	83 ec 04             	sub    $0x4,%esp
  802def:	68 c8 3b 80 00       	push   $0x803bc8
  802df4:	68 3a 01 00 00       	push   $0x13a
  802df9:	68 37 3b 80 00       	push   $0x803b37
  802dfe:	e8 60 02 00 00       	call   803063 <_panic>
  802e03:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e06:	8b 50 04             	mov    0x4(%eax),%edx
  802e09:	8b 45 08             	mov    0x8(%ebp),%eax
  802e0c:	89 50 04             	mov    %edx,0x4(%eax)
  802e0f:	8b 45 08             	mov    0x8(%ebp),%eax
  802e12:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802e15:	89 10                	mov    %edx,(%eax)
  802e17:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e1a:	8b 40 04             	mov    0x4(%eax),%eax
  802e1d:	85 c0                	test   %eax,%eax
  802e1f:	74 0d                	je     802e2e <insert_sorted_with_merge_freeList+0x212>
  802e21:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e24:	8b 40 04             	mov    0x4(%eax),%eax
  802e27:	8b 55 08             	mov    0x8(%ebp),%edx
  802e2a:	89 10                	mov    %edx,(%eax)
  802e2c:	eb 08                	jmp    802e36 <insert_sorted_with_merge_freeList+0x21a>
  802e2e:	8b 45 08             	mov    0x8(%ebp),%eax
  802e31:	a3 38 41 80 00       	mov    %eax,0x804138
  802e36:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e39:	8b 55 08             	mov    0x8(%ebp),%edx
  802e3c:	89 50 04             	mov    %edx,0x4(%eax)
  802e3f:	a1 44 41 80 00       	mov    0x804144,%eax
  802e44:	40                   	inc    %eax
  802e45:	a3 44 41 80 00       	mov    %eax,0x804144
								blockToInsert);
					}
					break;
  802e4a:	e9 11 02 00 00       	jmp    803060 <insert_sorted_with_merge_freeList+0x444>
				} else {
					//prev and next merge
					if (prev->sva + prev->size + blockToInsert->size
  802e4f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802e52:	8b 50 08             	mov    0x8(%eax),%edx
  802e55:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802e58:	8b 40 0c             	mov    0xc(%eax),%eax
  802e5b:	01 c2                	add    %eax,%edx
  802e5d:	8b 45 08             	mov    0x8(%ebp),%eax
  802e60:	8b 40 0c             	mov    0xc(%eax),%eax
  802e63:	01 c2                	add    %eax,%edx
							== iterator->sva) {
  802e65:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e68:	8b 40 08             	mov    0x8(%eax),%eax
								blockToInsert);
					}
					break;
				} else {
					//prev and next merge
					if (prev->sva + prev->size + blockToInsert->size
  802e6b:	39 c2                	cmp    %eax,%edx
  802e6d:	0f 85 bf 00 00 00    	jne    802f32 <insert_sorted_with_merge_freeList+0x316>
							== iterator->sva) {
						prev->size = prev->size + blockToInsert->size
  802e73:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802e76:	8b 50 0c             	mov    0xc(%eax),%edx
  802e79:	8b 45 08             	mov    0x8(%ebp),%eax
  802e7c:	8b 40 0c             	mov    0xc(%eax),%eax
  802e7f:	01 c2                	add    %eax,%edx
								+ iterator->size;
  802e81:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e84:	8b 40 0c             	mov    0xc(%eax),%eax
  802e87:	01 c2                	add    %eax,%edx
					break;
				} else {
					//prev and next merge
					if (prev->sva + prev->size + blockToInsert->size
							== iterator->sva) {
						prev->size = prev->size + blockToInsert->size
  802e89:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802e8c:	89 50 0c             	mov    %edx,0xc(%eax)
								+ iterator->size;
						LIST_REMOVE(&FreeMemBlocksList, iterator);
  802e8f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802e93:	75 17                	jne    802eac <insert_sorted_with_merge_freeList+0x290>
  802e95:	83 ec 04             	sub    $0x4,%esp
  802e98:	68 a8 3b 80 00       	push   $0x803ba8
  802e9d:	68 43 01 00 00       	push   $0x143
  802ea2:	68 37 3b 80 00       	push   $0x803b37
  802ea7:	e8 b7 01 00 00       	call   803063 <_panic>
  802eac:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802eaf:	8b 00                	mov    (%eax),%eax
  802eb1:	85 c0                	test   %eax,%eax
  802eb3:	74 10                	je     802ec5 <insert_sorted_with_merge_freeList+0x2a9>
  802eb5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802eb8:	8b 00                	mov    (%eax),%eax
  802eba:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802ebd:	8b 52 04             	mov    0x4(%edx),%edx
  802ec0:	89 50 04             	mov    %edx,0x4(%eax)
  802ec3:	eb 0b                	jmp    802ed0 <insert_sorted_with_merge_freeList+0x2b4>
  802ec5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ec8:	8b 40 04             	mov    0x4(%eax),%eax
  802ecb:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802ed0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ed3:	8b 40 04             	mov    0x4(%eax),%eax
  802ed6:	85 c0                	test   %eax,%eax
  802ed8:	74 0f                	je     802ee9 <insert_sorted_with_merge_freeList+0x2cd>
  802eda:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802edd:	8b 40 04             	mov    0x4(%eax),%eax
  802ee0:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802ee3:	8b 12                	mov    (%edx),%edx
  802ee5:	89 10                	mov    %edx,(%eax)
  802ee7:	eb 0a                	jmp    802ef3 <insert_sorted_with_merge_freeList+0x2d7>
  802ee9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802eec:	8b 00                	mov    (%eax),%eax
  802eee:	a3 38 41 80 00       	mov    %eax,0x804138
  802ef3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ef6:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802efc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802eff:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802f06:	a1 44 41 80 00       	mov    0x804144,%eax
  802f0b:	48                   	dec    %eax
  802f0c:	a3 44 41 80 00       	mov    %eax,0x804144
						addToAvailMemBlocksList(blockToInsert);
  802f11:	83 ec 0c             	sub    $0xc,%esp
  802f14:	ff 75 08             	pushl  0x8(%ebp)
  802f17:	e8 80 fc ff ff       	call   802b9c <addToAvailMemBlocksList>
  802f1c:	83 c4 10             	add    $0x10,%esp
						addToAvailMemBlocksList(iterator);
  802f1f:	83 ec 0c             	sub    $0xc,%esp
  802f22:	ff 75 f4             	pushl  -0xc(%ebp)
  802f25:	e8 72 fc ff ff       	call   802b9c <addToAvailMemBlocksList>
  802f2a:	83 c4 10             	add    $0x10,%esp
					//Insert
					else {
						LIST_INSERT_BEFORE(&FreeMemBlocksList, iterator,
								blockToInsert);
					}
					break;
  802f2d:	e9 2e 01 00 00       	jmp    803060 <insert_sorted_with_merge_freeList+0x444>
						LIST_REMOVE(&FreeMemBlocksList, iterator);
						addToAvailMemBlocksList(blockToInsert);
						addToAvailMemBlocksList(iterator);
					}
					//previous merge
					else if (prev->sva + prev->size == blockToInsert->sva) {
  802f32:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802f35:	8b 50 08             	mov    0x8(%eax),%edx
  802f38:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802f3b:	8b 40 0c             	mov    0xc(%eax),%eax
  802f3e:	01 c2                	add    %eax,%edx
  802f40:	8b 45 08             	mov    0x8(%ebp),%eax
  802f43:	8b 40 08             	mov    0x8(%eax),%eax
  802f46:	39 c2                	cmp    %eax,%edx
  802f48:	75 27                	jne    802f71 <insert_sorted_with_merge_freeList+0x355>
						prev->size = prev->size + blockToInsert->size;
  802f4a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802f4d:	8b 50 0c             	mov    0xc(%eax),%edx
  802f50:	8b 45 08             	mov    0x8(%ebp),%eax
  802f53:	8b 40 0c             	mov    0xc(%eax),%eax
  802f56:	01 c2                	add    %eax,%edx
  802f58:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802f5b:	89 50 0c             	mov    %edx,0xc(%eax)
						addToAvailMemBlocksList(blockToInsert);
  802f5e:	83 ec 0c             	sub    $0xc,%esp
  802f61:	ff 75 08             	pushl  0x8(%ebp)
  802f64:	e8 33 fc ff ff       	call   802b9c <addToAvailMemBlocksList>
  802f69:	83 c4 10             	add    $0x10,%esp
					//Insert
					else {
						LIST_INSERT_BEFORE(&FreeMemBlocksList, iterator,
								blockToInsert);
					}
					break;
  802f6c:	e9 ef 00 00 00       	jmp    803060 <insert_sorted_with_merge_freeList+0x444>
					else if (prev->sva + prev->size == blockToInsert->sva) {
						prev->size = prev->size + blockToInsert->size;
						addToAvailMemBlocksList(blockToInsert);
					}
					//next merge
					else if (blockToInsert->size + blockToInsert->sva
  802f71:	8b 45 08             	mov    0x8(%ebp),%eax
  802f74:	8b 50 0c             	mov    0xc(%eax),%edx
  802f77:	8b 45 08             	mov    0x8(%ebp),%eax
  802f7a:	8b 40 08             	mov    0x8(%eax),%eax
  802f7d:	01 c2                	add    %eax,%edx
							== iterator->sva) {
  802f7f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f82:	8b 40 08             	mov    0x8(%eax),%eax
					else if (prev->sva + prev->size == blockToInsert->sva) {
						prev->size = prev->size + blockToInsert->size;
						addToAvailMemBlocksList(blockToInsert);
					}
					//next merge
					else if (blockToInsert->size + blockToInsert->sva
  802f85:	39 c2                	cmp    %eax,%edx
  802f87:	75 33                	jne    802fbc <insert_sorted_with_merge_freeList+0x3a0>
							== iterator->sva) {
						iterator->sva = blockToInsert->sva;
  802f89:	8b 45 08             	mov    0x8(%ebp),%eax
  802f8c:	8b 50 08             	mov    0x8(%eax),%edx
  802f8f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f92:	89 50 08             	mov    %edx,0x8(%eax)
						iterator->size = iterator->size + blockToInsert->size;
  802f95:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f98:	8b 50 0c             	mov    0xc(%eax),%edx
  802f9b:	8b 45 08             	mov    0x8(%ebp),%eax
  802f9e:	8b 40 0c             	mov    0xc(%eax),%eax
  802fa1:	01 c2                	add    %eax,%edx
  802fa3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802fa6:	89 50 0c             	mov    %edx,0xc(%eax)
						addToAvailMemBlocksList(blockToInsert);
  802fa9:	83 ec 0c             	sub    $0xc,%esp
  802fac:	ff 75 08             	pushl  0x8(%ebp)
  802faf:	e8 e8 fb ff ff       	call   802b9c <addToAvailMemBlocksList>
  802fb4:	83 c4 10             	add    $0x10,%esp
					//Insert
					else {
						LIST_INSERT_BEFORE(&FreeMemBlocksList, iterator,
								blockToInsert);
					}
					break;
  802fb7:	e9 a4 00 00 00       	jmp    803060 <insert_sorted_with_merge_freeList+0x444>
						iterator->size = iterator->size + blockToInsert->size;
						addToAvailMemBlocksList(blockToInsert);
					}
					//Insert
					else {
						LIST_INSERT_BEFORE(&FreeMemBlocksList, iterator,
  802fbc:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802fc0:	74 06                	je     802fc8 <insert_sorted_with_merge_freeList+0x3ac>
  802fc2:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802fc6:	75 17                	jne    802fdf <insert_sorted_with_merge_freeList+0x3c3>
  802fc8:	83 ec 04             	sub    $0x4,%esp
  802fcb:	68 c8 3b 80 00       	push   $0x803bc8
  802fd0:	68 56 01 00 00       	push   $0x156
  802fd5:	68 37 3b 80 00       	push   $0x803b37
  802fda:	e8 84 00 00 00       	call   803063 <_panic>
  802fdf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802fe2:	8b 50 04             	mov    0x4(%eax),%edx
  802fe5:	8b 45 08             	mov    0x8(%ebp),%eax
  802fe8:	89 50 04             	mov    %edx,0x4(%eax)
  802feb:	8b 45 08             	mov    0x8(%ebp),%eax
  802fee:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802ff1:	89 10                	mov    %edx,(%eax)
  802ff3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ff6:	8b 40 04             	mov    0x4(%eax),%eax
  802ff9:	85 c0                	test   %eax,%eax
  802ffb:	74 0d                	je     80300a <insert_sorted_with_merge_freeList+0x3ee>
  802ffd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803000:	8b 40 04             	mov    0x4(%eax),%eax
  803003:	8b 55 08             	mov    0x8(%ebp),%edx
  803006:	89 10                	mov    %edx,(%eax)
  803008:	eb 08                	jmp    803012 <insert_sorted_with_merge_freeList+0x3f6>
  80300a:	8b 45 08             	mov    0x8(%ebp),%eax
  80300d:	a3 38 41 80 00       	mov    %eax,0x804138
  803012:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803015:	8b 55 08             	mov    0x8(%ebp),%edx
  803018:	89 50 04             	mov    %edx,0x4(%eax)
  80301b:	a1 44 41 80 00       	mov    0x804144,%eax
  803020:	40                   	inc    %eax
  803021:	a3 44 41 80 00       	mov    %eax,0x804144
								blockToInsert);
					}
					break;
  803026:	eb 38                	jmp    803060 <insert_sorted_with_merge_freeList+0x444>
		} else {
			LIST_INSERT_AFTER(&FreeMemBlocksList, last, blockToInsert);
		}
	} else {
		struct MemBlock *iterator;
		LIST_FOREACH(iterator, &(FreeMemBlocksList))
  803028:	a1 40 41 80 00       	mov    0x804140,%eax
  80302d:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803030:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803034:	74 07                	je     80303d <insert_sorted_with_merge_freeList+0x421>
  803036:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803039:	8b 00                	mov    (%eax),%eax
  80303b:	eb 05                	jmp    803042 <insert_sorted_with_merge_freeList+0x426>
  80303d:	b8 00 00 00 00       	mov    $0x0,%eax
  803042:	a3 40 41 80 00       	mov    %eax,0x804140
  803047:	a1 40 41 80 00       	mov    0x804140,%eax
  80304c:	85 c0                	test   %eax,%eax
  80304e:	0f 85 1a fd ff ff    	jne    802d6e <insert_sorted_with_merge_freeList+0x152>
  803054:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803058:	0f 85 10 fd ff ff    	jne    802d6e <insert_sorted_with_merge_freeList+0x152>
		}
	}

	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  80305e:	eb 00                	jmp    803060 <insert_sorted_with_merge_freeList+0x444>
  803060:	90                   	nop
  803061:	c9                   	leave  
  803062:	c3                   	ret    

00803063 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  803063:	55                   	push   %ebp
  803064:	89 e5                	mov    %esp,%ebp
  803066:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  803069:	8d 45 10             	lea    0x10(%ebp),%eax
  80306c:	83 c0 04             	add    $0x4,%eax
  80306f:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  803072:	a1 60 41 80 00       	mov    0x804160,%eax
  803077:	85 c0                	test   %eax,%eax
  803079:	74 16                	je     803091 <_panic+0x2e>
		cprintf("%s: ", argv0);
  80307b:	a1 60 41 80 00       	mov    0x804160,%eax
  803080:	83 ec 08             	sub    $0x8,%esp
  803083:	50                   	push   %eax
  803084:	68 00 3c 80 00       	push   $0x803c00
  803089:	e8 af d6 ff ff       	call   80073d <cprintf>
  80308e:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  803091:	a1 00 40 80 00       	mov    0x804000,%eax
  803096:	ff 75 0c             	pushl  0xc(%ebp)
  803099:	ff 75 08             	pushl  0x8(%ebp)
  80309c:	50                   	push   %eax
  80309d:	68 05 3c 80 00       	push   $0x803c05
  8030a2:	e8 96 d6 ff ff       	call   80073d <cprintf>
  8030a7:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  8030aa:	8b 45 10             	mov    0x10(%ebp),%eax
  8030ad:	83 ec 08             	sub    $0x8,%esp
  8030b0:	ff 75 f4             	pushl  -0xc(%ebp)
  8030b3:	50                   	push   %eax
  8030b4:	e8 19 d6 ff ff       	call   8006d2 <vcprintf>
  8030b9:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  8030bc:	83 ec 08             	sub    $0x8,%esp
  8030bf:	6a 00                	push   $0x0
  8030c1:	68 21 3c 80 00       	push   $0x803c21
  8030c6:	e8 07 d6 ff ff       	call   8006d2 <vcprintf>
  8030cb:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  8030ce:	e8 88 d5 ff ff       	call   80065b <exit>

	// should not return here
	while (1) ;
  8030d3:	eb fe                	jmp    8030d3 <_panic+0x70>

008030d5 <CheckWSWithoutLastIndex>:
}

void CheckWSWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  8030d5:	55                   	push   %ebp
  8030d6:	89 e5                	mov    %esp,%ebp
  8030d8:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  8030db:	a1 20 40 80 00       	mov    0x804020,%eax
  8030e0:	8b 50 74             	mov    0x74(%eax),%edx
  8030e3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8030e6:	39 c2                	cmp    %eax,%edx
  8030e8:	74 14                	je     8030fe <CheckWSWithoutLastIndex+0x29>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  8030ea:	83 ec 04             	sub    $0x4,%esp
  8030ed:	68 24 3c 80 00       	push   $0x803c24
  8030f2:	6a 26                	push   $0x26
  8030f4:	68 70 3c 80 00       	push   $0x803c70
  8030f9:	e8 65 ff ff ff       	call   803063 <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  8030fe:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  803105:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  80310c:	e9 c2 00 00 00       	jmp    8031d3 <CheckWSWithoutLastIndex+0xfe>
		if (expectedPages[e] == 0) {
  803111:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803114:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80311b:	8b 45 08             	mov    0x8(%ebp),%eax
  80311e:	01 d0                	add    %edx,%eax
  803120:	8b 00                	mov    (%eax),%eax
  803122:	85 c0                	test   %eax,%eax
  803124:	75 08                	jne    80312e <CheckWSWithoutLastIndex+0x59>
			expectedNumOfEmptyLocs++;
  803126:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  803129:	e9 a2 00 00 00       	jmp    8031d0 <CheckWSWithoutLastIndex+0xfb>
		}
		int found = 0;
  80312e:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  803135:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  80313c:	eb 69                	jmp    8031a7 <CheckWSWithoutLastIndex+0xd2>
			if (myEnv->__uptr_pws[w].empty == 0) {
  80313e:	a1 20 40 80 00       	mov    0x804020,%eax
  803143:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  803149:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80314c:	89 d0                	mov    %edx,%eax
  80314e:	01 c0                	add    %eax,%eax
  803150:	01 d0                	add    %edx,%eax
  803152:	c1 e0 03             	shl    $0x3,%eax
  803155:	01 c8                	add    %ecx,%eax
  803157:	8a 40 04             	mov    0x4(%eax),%al
  80315a:	84 c0                	test   %al,%al
  80315c:	75 46                	jne    8031a4 <CheckWSWithoutLastIndex+0xcf>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  80315e:	a1 20 40 80 00       	mov    0x804020,%eax
  803163:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  803169:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80316c:	89 d0                	mov    %edx,%eax
  80316e:	01 c0                	add    %eax,%eax
  803170:	01 d0                	add    %edx,%eax
  803172:	c1 e0 03             	shl    $0x3,%eax
  803175:	01 c8                	add    %ecx,%eax
  803177:	8b 00                	mov    (%eax),%eax
  803179:	89 45 dc             	mov    %eax,-0x24(%ebp)
  80317c:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80317f:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  803184:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  803186:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803189:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  803190:	8b 45 08             	mov    0x8(%ebp),%eax
  803193:	01 c8                	add    %ecx,%eax
  803195:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  803197:	39 c2                	cmp    %eax,%edx
  803199:	75 09                	jne    8031a4 <CheckWSWithoutLastIndex+0xcf>
						== expectedPages[e]) {
					found = 1;
  80319b:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  8031a2:	eb 12                	jmp    8031b6 <CheckWSWithoutLastIndex+0xe1>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8031a4:	ff 45 e8             	incl   -0x18(%ebp)
  8031a7:	a1 20 40 80 00       	mov    0x804020,%eax
  8031ac:	8b 50 74             	mov    0x74(%eax),%edx
  8031af:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8031b2:	39 c2                	cmp    %eax,%edx
  8031b4:	77 88                	ja     80313e <CheckWSWithoutLastIndex+0x69>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  8031b6:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8031ba:	75 14                	jne    8031d0 <CheckWSWithoutLastIndex+0xfb>
			panic(
  8031bc:	83 ec 04             	sub    $0x4,%esp
  8031bf:	68 7c 3c 80 00       	push   $0x803c7c
  8031c4:	6a 3a                	push   $0x3a
  8031c6:	68 70 3c 80 00       	push   $0x803c70
  8031cb:	e8 93 fe ff ff       	call   803063 <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  8031d0:	ff 45 f0             	incl   -0x10(%ebp)
  8031d3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8031d6:	3b 45 0c             	cmp    0xc(%ebp),%eax
  8031d9:	0f 8c 32 ff ff ff    	jl     803111 <CheckWSWithoutLastIndex+0x3c>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  8031df:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8031e6:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  8031ed:	eb 26                	jmp    803215 <CheckWSWithoutLastIndex+0x140>
		if (myEnv->__uptr_pws[w].empty == 1) {
  8031ef:	a1 20 40 80 00       	mov    0x804020,%eax
  8031f4:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  8031fa:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8031fd:	89 d0                	mov    %edx,%eax
  8031ff:	01 c0                	add    %eax,%eax
  803201:	01 d0                	add    %edx,%eax
  803203:	c1 e0 03             	shl    $0x3,%eax
  803206:	01 c8                	add    %ecx,%eax
  803208:	8a 40 04             	mov    0x4(%eax),%al
  80320b:	3c 01                	cmp    $0x1,%al
  80320d:	75 03                	jne    803212 <CheckWSWithoutLastIndex+0x13d>
			actualNumOfEmptyLocs++;
  80320f:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  803212:	ff 45 e0             	incl   -0x20(%ebp)
  803215:	a1 20 40 80 00       	mov    0x804020,%eax
  80321a:	8b 50 74             	mov    0x74(%eax),%edx
  80321d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803220:	39 c2                	cmp    %eax,%edx
  803222:	77 cb                	ja     8031ef <CheckWSWithoutLastIndex+0x11a>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  803224:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803227:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  80322a:	74 14                	je     803240 <CheckWSWithoutLastIndex+0x16b>
		panic(
  80322c:	83 ec 04             	sub    $0x4,%esp
  80322f:	68 d0 3c 80 00       	push   $0x803cd0
  803234:	6a 44                	push   $0x44
  803236:	68 70 3c 80 00       	push   $0x803c70
  80323b:	e8 23 fe ff ff       	call   803063 <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  803240:	90                   	nop
  803241:	c9                   	leave  
  803242:	c3                   	ret    
  803243:	90                   	nop

00803244 <__udivdi3>:
  803244:	55                   	push   %ebp
  803245:	57                   	push   %edi
  803246:	56                   	push   %esi
  803247:	53                   	push   %ebx
  803248:	83 ec 1c             	sub    $0x1c,%esp
  80324b:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  80324f:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  803253:	8b 7c 24 38          	mov    0x38(%esp),%edi
  803257:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  80325b:	89 ca                	mov    %ecx,%edx
  80325d:	89 f8                	mov    %edi,%eax
  80325f:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  803263:	85 f6                	test   %esi,%esi
  803265:	75 2d                	jne    803294 <__udivdi3+0x50>
  803267:	39 cf                	cmp    %ecx,%edi
  803269:	77 65                	ja     8032d0 <__udivdi3+0x8c>
  80326b:	89 fd                	mov    %edi,%ebp
  80326d:	85 ff                	test   %edi,%edi
  80326f:	75 0b                	jne    80327c <__udivdi3+0x38>
  803271:	b8 01 00 00 00       	mov    $0x1,%eax
  803276:	31 d2                	xor    %edx,%edx
  803278:	f7 f7                	div    %edi
  80327a:	89 c5                	mov    %eax,%ebp
  80327c:	31 d2                	xor    %edx,%edx
  80327e:	89 c8                	mov    %ecx,%eax
  803280:	f7 f5                	div    %ebp
  803282:	89 c1                	mov    %eax,%ecx
  803284:	89 d8                	mov    %ebx,%eax
  803286:	f7 f5                	div    %ebp
  803288:	89 cf                	mov    %ecx,%edi
  80328a:	89 fa                	mov    %edi,%edx
  80328c:	83 c4 1c             	add    $0x1c,%esp
  80328f:	5b                   	pop    %ebx
  803290:	5e                   	pop    %esi
  803291:	5f                   	pop    %edi
  803292:	5d                   	pop    %ebp
  803293:	c3                   	ret    
  803294:	39 ce                	cmp    %ecx,%esi
  803296:	77 28                	ja     8032c0 <__udivdi3+0x7c>
  803298:	0f bd fe             	bsr    %esi,%edi
  80329b:	83 f7 1f             	xor    $0x1f,%edi
  80329e:	75 40                	jne    8032e0 <__udivdi3+0x9c>
  8032a0:	39 ce                	cmp    %ecx,%esi
  8032a2:	72 0a                	jb     8032ae <__udivdi3+0x6a>
  8032a4:	3b 44 24 08          	cmp    0x8(%esp),%eax
  8032a8:	0f 87 9e 00 00 00    	ja     80334c <__udivdi3+0x108>
  8032ae:	b8 01 00 00 00       	mov    $0x1,%eax
  8032b3:	89 fa                	mov    %edi,%edx
  8032b5:	83 c4 1c             	add    $0x1c,%esp
  8032b8:	5b                   	pop    %ebx
  8032b9:	5e                   	pop    %esi
  8032ba:	5f                   	pop    %edi
  8032bb:	5d                   	pop    %ebp
  8032bc:	c3                   	ret    
  8032bd:	8d 76 00             	lea    0x0(%esi),%esi
  8032c0:	31 ff                	xor    %edi,%edi
  8032c2:	31 c0                	xor    %eax,%eax
  8032c4:	89 fa                	mov    %edi,%edx
  8032c6:	83 c4 1c             	add    $0x1c,%esp
  8032c9:	5b                   	pop    %ebx
  8032ca:	5e                   	pop    %esi
  8032cb:	5f                   	pop    %edi
  8032cc:	5d                   	pop    %ebp
  8032cd:	c3                   	ret    
  8032ce:	66 90                	xchg   %ax,%ax
  8032d0:	89 d8                	mov    %ebx,%eax
  8032d2:	f7 f7                	div    %edi
  8032d4:	31 ff                	xor    %edi,%edi
  8032d6:	89 fa                	mov    %edi,%edx
  8032d8:	83 c4 1c             	add    $0x1c,%esp
  8032db:	5b                   	pop    %ebx
  8032dc:	5e                   	pop    %esi
  8032dd:	5f                   	pop    %edi
  8032de:	5d                   	pop    %ebp
  8032df:	c3                   	ret    
  8032e0:	bd 20 00 00 00       	mov    $0x20,%ebp
  8032e5:	89 eb                	mov    %ebp,%ebx
  8032e7:	29 fb                	sub    %edi,%ebx
  8032e9:	89 f9                	mov    %edi,%ecx
  8032eb:	d3 e6                	shl    %cl,%esi
  8032ed:	89 c5                	mov    %eax,%ebp
  8032ef:	88 d9                	mov    %bl,%cl
  8032f1:	d3 ed                	shr    %cl,%ebp
  8032f3:	89 e9                	mov    %ebp,%ecx
  8032f5:	09 f1                	or     %esi,%ecx
  8032f7:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  8032fb:	89 f9                	mov    %edi,%ecx
  8032fd:	d3 e0                	shl    %cl,%eax
  8032ff:	89 c5                	mov    %eax,%ebp
  803301:	89 d6                	mov    %edx,%esi
  803303:	88 d9                	mov    %bl,%cl
  803305:	d3 ee                	shr    %cl,%esi
  803307:	89 f9                	mov    %edi,%ecx
  803309:	d3 e2                	shl    %cl,%edx
  80330b:	8b 44 24 08          	mov    0x8(%esp),%eax
  80330f:	88 d9                	mov    %bl,%cl
  803311:	d3 e8                	shr    %cl,%eax
  803313:	09 c2                	or     %eax,%edx
  803315:	89 d0                	mov    %edx,%eax
  803317:	89 f2                	mov    %esi,%edx
  803319:	f7 74 24 0c          	divl   0xc(%esp)
  80331d:	89 d6                	mov    %edx,%esi
  80331f:	89 c3                	mov    %eax,%ebx
  803321:	f7 e5                	mul    %ebp
  803323:	39 d6                	cmp    %edx,%esi
  803325:	72 19                	jb     803340 <__udivdi3+0xfc>
  803327:	74 0b                	je     803334 <__udivdi3+0xf0>
  803329:	89 d8                	mov    %ebx,%eax
  80332b:	31 ff                	xor    %edi,%edi
  80332d:	e9 58 ff ff ff       	jmp    80328a <__udivdi3+0x46>
  803332:	66 90                	xchg   %ax,%ax
  803334:	8b 54 24 08          	mov    0x8(%esp),%edx
  803338:	89 f9                	mov    %edi,%ecx
  80333a:	d3 e2                	shl    %cl,%edx
  80333c:	39 c2                	cmp    %eax,%edx
  80333e:	73 e9                	jae    803329 <__udivdi3+0xe5>
  803340:	8d 43 ff             	lea    -0x1(%ebx),%eax
  803343:	31 ff                	xor    %edi,%edi
  803345:	e9 40 ff ff ff       	jmp    80328a <__udivdi3+0x46>
  80334a:	66 90                	xchg   %ax,%ax
  80334c:	31 c0                	xor    %eax,%eax
  80334e:	e9 37 ff ff ff       	jmp    80328a <__udivdi3+0x46>
  803353:	90                   	nop

00803354 <__umoddi3>:
  803354:	55                   	push   %ebp
  803355:	57                   	push   %edi
  803356:	56                   	push   %esi
  803357:	53                   	push   %ebx
  803358:	83 ec 1c             	sub    $0x1c,%esp
  80335b:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  80335f:	8b 74 24 34          	mov    0x34(%esp),%esi
  803363:	8b 7c 24 38          	mov    0x38(%esp),%edi
  803367:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  80336b:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80336f:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  803373:	89 f3                	mov    %esi,%ebx
  803375:	89 fa                	mov    %edi,%edx
  803377:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  80337b:	89 34 24             	mov    %esi,(%esp)
  80337e:	85 c0                	test   %eax,%eax
  803380:	75 1a                	jne    80339c <__umoddi3+0x48>
  803382:	39 f7                	cmp    %esi,%edi
  803384:	0f 86 a2 00 00 00    	jbe    80342c <__umoddi3+0xd8>
  80338a:	89 c8                	mov    %ecx,%eax
  80338c:	89 f2                	mov    %esi,%edx
  80338e:	f7 f7                	div    %edi
  803390:	89 d0                	mov    %edx,%eax
  803392:	31 d2                	xor    %edx,%edx
  803394:	83 c4 1c             	add    $0x1c,%esp
  803397:	5b                   	pop    %ebx
  803398:	5e                   	pop    %esi
  803399:	5f                   	pop    %edi
  80339a:	5d                   	pop    %ebp
  80339b:	c3                   	ret    
  80339c:	39 f0                	cmp    %esi,%eax
  80339e:	0f 87 ac 00 00 00    	ja     803450 <__umoddi3+0xfc>
  8033a4:	0f bd e8             	bsr    %eax,%ebp
  8033a7:	83 f5 1f             	xor    $0x1f,%ebp
  8033aa:	0f 84 ac 00 00 00    	je     80345c <__umoddi3+0x108>
  8033b0:	bf 20 00 00 00       	mov    $0x20,%edi
  8033b5:	29 ef                	sub    %ebp,%edi
  8033b7:	89 fe                	mov    %edi,%esi
  8033b9:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  8033bd:	89 e9                	mov    %ebp,%ecx
  8033bf:	d3 e0                	shl    %cl,%eax
  8033c1:	89 d7                	mov    %edx,%edi
  8033c3:	89 f1                	mov    %esi,%ecx
  8033c5:	d3 ef                	shr    %cl,%edi
  8033c7:	09 c7                	or     %eax,%edi
  8033c9:	89 e9                	mov    %ebp,%ecx
  8033cb:	d3 e2                	shl    %cl,%edx
  8033cd:	89 14 24             	mov    %edx,(%esp)
  8033d0:	89 d8                	mov    %ebx,%eax
  8033d2:	d3 e0                	shl    %cl,%eax
  8033d4:	89 c2                	mov    %eax,%edx
  8033d6:	8b 44 24 08          	mov    0x8(%esp),%eax
  8033da:	d3 e0                	shl    %cl,%eax
  8033dc:	89 44 24 04          	mov    %eax,0x4(%esp)
  8033e0:	8b 44 24 08          	mov    0x8(%esp),%eax
  8033e4:	89 f1                	mov    %esi,%ecx
  8033e6:	d3 e8                	shr    %cl,%eax
  8033e8:	09 d0                	or     %edx,%eax
  8033ea:	d3 eb                	shr    %cl,%ebx
  8033ec:	89 da                	mov    %ebx,%edx
  8033ee:	f7 f7                	div    %edi
  8033f0:	89 d3                	mov    %edx,%ebx
  8033f2:	f7 24 24             	mull   (%esp)
  8033f5:	89 c6                	mov    %eax,%esi
  8033f7:	89 d1                	mov    %edx,%ecx
  8033f9:	39 d3                	cmp    %edx,%ebx
  8033fb:	0f 82 87 00 00 00    	jb     803488 <__umoddi3+0x134>
  803401:	0f 84 91 00 00 00    	je     803498 <__umoddi3+0x144>
  803407:	8b 54 24 04          	mov    0x4(%esp),%edx
  80340b:	29 f2                	sub    %esi,%edx
  80340d:	19 cb                	sbb    %ecx,%ebx
  80340f:	89 d8                	mov    %ebx,%eax
  803411:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  803415:	d3 e0                	shl    %cl,%eax
  803417:	89 e9                	mov    %ebp,%ecx
  803419:	d3 ea                	shr    %cl,%edx
  80341b:	09 d0                	or     %edx,%eax
  80341d:	89 e9                	mov    %ebp,%ecx
  80341f:	d3 eb                	shr    %cl,%ebx
  803421:	89 da                	mov    %ebx,%edx
  803423:	83 c4 1c             	add    $0x1c,%esp
  803426:	5b                   	pop    %ebx
  803427:	5e                   	pop    %esi
  803428:	5f                   	pop    %edi
  803429:	5d                   	pop    %ebp
  80342a:	c3                   	ret    
  80342b:	90                   	nop
  80342c:	89 fd                	mov    %edi,%ebp
  80342e:	85 ff                	test   %edi,%edi
  803430:	75 0b                	jne    80343d <__umoddi3+0xe9>
  803432:	b8 01 00 00 00       	mov    $0x1,%eax
  803437:	31 d2                	xor    %edx,%edx
  803439:	f7 f7                	div    %edi
  80343b:	89 c5                	mov    %eax,%ebp
  80343d:	89 f0                	mov    %esi,%eax
  80343f:	31 d2                	xor    %edx,%edx
  803441:	f7 f5                	div    %ebp
  803443:	89 c8                	mov    %ecx,%eax
  803445:	f7 f5                	div    %ebp
  803447:	89 d0                	mov    %edx,%eax
  803449:	e9 44 ff ff ff       	jmp    803392 <__umoddi3+0x3e>
  80344e:	66 90                	xchg   %ax,%ax
  803450:	89 c8                	mov    %ecx,%eax
  803452:	89 f2                	mov    %esi,%edx
  803454:	83 c4 1c             	add    $0x1c,%esp
  803457:	5b                   	pop    %ebx
  803458:	5e                   	pop    %esi
  803459:	5f                   	pop    %edi
  80345a:	5d                   	pop    %ebp
  80345b:	c3                   	ret    
  80345c:	3b 04 24             	cmp    (%esp),%eax
  80345f:	72 06                	jb     803467 <__umoddi3+0x113>
  803461:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  803465:	77 0f                	ja     803476 <__umoddi3+0x122>
  803467:	89 f2                	mov    %esi,%edx
  803469:	29 f9                	sub    %edi,%ecx
  80346b:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  80346f:	89 14 24             	mov    %edx,(%esp)
  803472:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  803476:	8b 44 24 04          	mov    0x4(%esp),%eax
  80347a:	8b 14 24             	mov    (%esp),%edx
  80347d:	83 c4 1c             	add    $0x1c,%esp
  803480:	5b                   	pop    %ebx
  803481:	5e                   	pop    %esi
  803482:	5f                   	pop    %edi
  803483:	5d                   	pop    %ebp
  803484:	c3                   	ret    
  803485:	8d 76 00             	lea    0x0(%esi),%esi
  803488:	2b 04 24             	sub    (%esp),%eax
  80348b:	19 fa                	sbb    %edi,%edx
  80348d:	89 d1                	mov    %edx,%ecx
  80348f:	89 c6                	mov    %eax,%esi
  803491:	e9 71 ff ff ff       	jmp    803407 <__umoddi3+0xb3>
  803496:	66 90                	xchg   %ax,%ax
  803498:	39 44 24 04          	cmp    %eax,0x4(%esp)
  80349c:	72 ea                	jb     803488 <__umoddi3+0x134>
  80349e:	89 d9                	mov    %ebx,%ecx
  8034a0:	e9 62 ff ff ff       	jmp    803407 <__umoddi3+0xb3>
