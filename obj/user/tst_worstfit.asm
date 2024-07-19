
obj/user/tst_worstfit:     file format elf32-i386


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
  800031:	e8 81 0c 00 00       	call   800cb7 <libmain>
1:      jmp 1b
  800036:	eb fe                	jmp    800036 <args_exist+0x5>

00800038 <_main>:
/* *********************************************************** */

#include <inc/lib.h>

void _main(void)
{
  800038:	55                   	push   %ebp
  800039:	89 e5                	mov    %esp,%ebp
  80003b:	57                   	push   %edi
  80003c:	53                   	push   %ebx
  80003d:	81 ec 40 08 00 00    	sub    $0x840,%esp
	sys_set_uheap_strategy(UHP_PLACE_WORSTFIT);
  800043:	83 ec 0c             	sub    $0xc,%esp
  800046:	6a 04                	push   $0x4
  800048:	e8 0d 29 00 00       	call   80295a <sys_set_uheap_strategy>
  80004d:	83 c4 10             	add    $0x10,%esp

	//Initial test to ensure it works on "PLACEMENT" not "REPLACEMENT"
	{
		uint8 fullWS = 1;
  800050:	c6 45 f7 01          	movb   $0x1,-0x9(%ebp)
		for (int i = 0; i < myEnv->page_WS_max_size; ++i)
  800054:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  80005b:	eb 29                	jmp    800086 <_main+0x4e>
		{
			if (myEnv->__uptr_pws[i].empty)
  80005d:	a1 20 50 80 00       	mov    0x805020,%eax
  800062:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  800068:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80006b:	89 d0                	mov    %edx,%eax
  80006d:	01 c0                	add    %eax,%eax
  80006f:	01 d0                	add    %edx,%eax
  800071:	c1 e0 03             	shl    $0x3,%eax
  800074:	01 c8                	add    %ecx,%eax
  800076:	8a 40 04             	mov    0x4(%eax),%al
  800079:	84 c0                	test   %al,%al
  80007b:	74 06                	je     800083 <_main+0x4b>
			{
				fullWS = 0;
  80007d:	c6 45 f7 00          	movb   $0x0,-0x9(%ebp)
				break;
  800081:	eb 12                	jmp    800095 <_main+0x5d>
	sys_set_uheap_strategy(UHP_PLACE_WORSTFIT);

	//Initial test to ensure it works on "PLACEMENT" not "REPLACEMENT"
	{
		uint8 fullWS = 1;
		for (int i = 0; i < myEnv->page_WS_max_size; ++i)
  800083:	ff 45 f0             	incl   -0x10(%ebp)
  800086:	a1 20 50 80 00       	mov    0x805020,%eax
  80008b:	8b 50 74             	mov    0x74(%eax),%edx
  80008e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800091:	39 c2                	cmp    %eax,%edx
  800093:	77 c8                	ja     80005d <_main+0x25>
			{
				fullWS = 0;
				break;
			}
		}
		if (fullWS) panic("Please increase the WS size");
  800095:	80 7d f7 00          	cmpb   $0x0,-0x9(%ebp)
  800099:	74 14                	je     8000af <_main+0x77>
  80009b:	83 ec 04             	sub    $0x4,%esp
  80009e:	68 40 3c 80 00       	push   $0x803c40
  8000a3:	6a 16                	push   $0x16
  8000a5:	68 5c 3c 80 00       	push   $0x803c5c
  8000aa:	e8 44 0d 00 00       	call   800df3 <_panic>
	}
	/*Dummy malloc to enforce the UHEAP initializations*/
	malloc(0);
  8000af:	83 ec 0c             	sub    $0xc,%esp
  8000b2:	6a 00                	push   $0x0
  8000b4:	e8 80 1f 00 00       	call   802039 <malloc>
  8000b9:	83 c4 10             	add    $0x10,%esp
	/*=================================================*/

	int Mega = 1024*1024;
  8000bc:	c7 45 d8 00 00 10 00 	movl   $0x100000,-0x28(%ebp)
	int kilo = 1024;
  8000c3:	c7 45 d4 00 04 00 00 	movl   $0x400,-0x2c(%ebp)

	int count = 0;
  8000ca:	c7 45 d0 00 00 00 00 	movl   $0x0,-0x30(%ebp)
	int totalNumberOfTests = 11;
  8000d1:	c7 45 cc 0b 00 00 00 	movl   $0xb,-0x34(%ebp)

	//Make sure that the heap size is 512 MB
	int numOf2MBsInHeap = (USER_HEAP_MAX - USER_HEAP_START) / (2*Mega);
  8000d8:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8000db:	01 c0                	add    %eax,%eax
  8000dd:	89 c7                	mov    %eax,%edi
  8000df:	b8 00 00 00 20       	mov    $0x20000000,%eax
  8000e4:	ba 00 00 00 00       	mov    $0x0,%edx
  8000e9:	f7 f7                	div    %edi
  8000eb:	89 45 c8             	mov    %eax,-0x38(%ebp)
	assert(numOf2MBsInHeap == 256);
  8000ee:	81 7d c8 00 01 00 00 	cmpl   $0x100,-0x38(%ebp)
  8000f5:	74 16                	je     80010d <_main+0xd5>
  8000f7:	68 70 3c 80 00       	push   $0x803c70
  8000fc:	68 87 3c 80 00       	push   $0x803c87
  800101:	6a 24                	push   $0x24
  800103:	68 5c 3c 80 00       	push   $0x803c5c
  800108:	e8 e6 0c 00 00       	call   800df3 <_panic>




	sys_set_uheap_strategy(UHP_PLACE_WORSTFIT);
  80010d:	83 ec 0c             	sub    $0xc,%esp
  800110:	6a 04                	push   $0x4
  800112:	e8 43 28 00 00       	call   80295a <sys_set_uheap_strategy>
  800117:	83 c4 10             	add    $0x10,%esp

	//Initial test to ensure it works on "PLACEMENT" not "REPLACEMENT"
	{
		uint8 fullWS = 1;
  80011a:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
		for (int i = 0; i < myEnv->page_WS_max_size; ++i)
  80011e:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  800125:	eb 29                	jmp    800150 <_main+0x118>
		{
			if (myEnv->__uptr_pws[i].empty)
  800127:	a1 20 50 80 00       	mov    0x805020,%eax
  80012c:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  800132:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800135:	89 d0                	mov    %edx,%eax
  800137:	01 c0                	add    %eax,%eax
  800139:	01 d0                	add    %edx,%eax
  80013b:	c1 e0 03             	shl    $0x3,%eax
  80013e:	01 c8                	add    %ecx,%eax
  800140:	8a 40 04             	mov    0x4(%eax),%al
  800143:	84 c0                	test   %al,%al
  800145:	74 06                	je     80014d <_main+0x115>
			{
				fullWS = 0;
  800147:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
				break;
  80014b:	eb 12                	jmp    80015f <_main+0x127>
	sys_set_uheap_strategy(UHP_PLACE_WORSTFIT);

	//Initial test to ensure it works on "PLACEMENT" not "REPLACEMENT"
	{
		uint8 fullWS = 1;
		for (int i = 0; i < myEnv->page_WS_max_size; ++i)
  80014d:	ff 45 e8             	incl   -0x18(%ebp)
  800150:	a1 20 50 80 00       	mov    0x805020,%eax
  800155:	8b 50 74             	mov    0x74(%eax),%edx
  800158:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80015b:	39 c2                	cmp    %eax,%edx
  80015d:	77 c8                	ja     800127 <_main+0xef>
			{
				fullWS = 0;
				break;
			}
		}
		if (fullWS) panic("Please increase the WS size");
  80015f:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  800163:	74 14                	je     800179 <_main+0x141>
  800165:	83 ec 04             	sub    $0x4,%esp
  800168:	68 40 3c 80 00       	push   $0x803c40
  80016d:	6a 36                	push   $0x36
  80016f:	68 5c 3c 80 00       	push   $0x803c5c
  800174:	e8 7a 0c 00 00       	call   800df3 <_panic>
	}

	int freeFrames ;
	int usedDiskPages;

	cprintf("This test has %d tests. A pass message will be displayed after each one.\n", totalNumberOfTests);
  800179:	83 ec 08             	sub    $0x8,%esp
  80017c:	ff 75 cc             	pushl  -0x34(%ebp)
  80017f:	68 9c 3c 80 00       	push   $0x803c9c
  800184:	e8 1e 0f 00 00       	call   8010a7 <cprintf>
  800189:	83 c4 10             	add    $0x10,%esp

	//[0] Make sure there're available places in the WS
	int w = 0 ;
  80018c:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	int requiredNumOfEmptyWSLocs = 2;
  800193:	c7 45 c4 02 00 00 00 	movl   $0x2,-0x3c(%ebp)
	int numOfEmptyWSLocs = 0;
  80019a:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
	for (w = 0 ; w < myEnv->page_WS_max_size; w++)
  8001a1:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  8001a8:	eb 26                	jmp    8001d0 <_main+0x198>
	{
		if( myEnv->__uptr_pws[w].empty == 1)
  8001aa:	a1 20 50 80 00       	mov    0x805020,%eax
  8001af:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  8001b5:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8001b8:	89 d0                	mov    %edx,%eax
  8001ba:	01 c0                	add    %eax,%eax
  8001bc:	01 d0                	add    %edx,%eax
  8001be:	c1 e0 03             	shl    $0x3,%eax
  8001c1:	01 c8                	add    %ecx,%eax
  8001c3:	8a 40 04             	mov    0x4(%eax),%al
  8001c6:	3c 01                	cmp    $0x1,%al
  8001c8:	75 03                	jne    8001cd <_main+0x195>
			numOfEmptyWSLocs++;
  8001ca:	ff 45 e0             	incl   -0x20(%ebp)

	//[0] Make sure there're available places in the WS
	int w = 0 ;
	int requiredNumOfEmptyWSLocs = 2;
	int numOfEmptyWSLocs = 0;
	for (w = 0 ; w < myEnv->page_WS_max_size; w++)
  8001cd:	ff 45 e4             	incl   -0x1c(%ebp)
  8001d0:	a1 20 50 80 00       	mov    0x805020,%eax
  8001d5:	8b 50 74             	mov    0x74(%eax),%edx
  8001d8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8001db:	39 c2                	cmp    %eax,%edx
  8001dd:	77 cb                	ja     8001aa <_main+0x172>
	{
		if( myEnv->__uptr_pws[w].empty == 1)
			numOfEmptyWSLocs++;
	}
	if (numOfEmptyWSLocs < requiredNumOfEmptyWSLocs)
  8001df:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8001e2:	3b 45 c4             	cmp    -0x3c(%ebp),%eax
  8001e5:	7d 14                	jge    8001fb <_main+0x1c3>
		panic("Insufficient number of WS empty locations! please increase the PAGE_WS_MAX_SIZE");
  8001e7:	83 ec 04             	sub    $0x4,%esp
  8001ea:	68 e8 3c 80 00       	push   $0x803ce8
  8001ef:	6a 48                	push   $0x48
  8001f1:	68 5c 3c 80 00       	push   $0x803c5c
  8001f6:	e8 f8 0b 00 00       	call   800df3 <_panic>

	void* ptr_allocations[512] = {0};
  8001fb:	8d 95 b8 f7 ff ff    	lea    -0x848(%ebp),%edx
  800201:	b9 00 02 00 00       	mov    $0x200,%ecx
  800206:	b8 00 00 00 00       	mov    $0x0,%eax
  80020b:	89 d7                	mov    %edx,%edi
  80020d:	f3 ab                	rep stos %eax,%es:(%edi)
	int i;

	// allocate pages
	freeFrames = sys_calculate_free_frames() ;
  80020f:	e8 31 22 00 00       	call   802445 <sys_calculate_free_frames>
  800214:	89 45 c0             	mov    %eax,-0x40(%ebp)
	usedDiskPages = sys_pf_calculate_allocated_pages();
  800217:	e8 c9 22 00 00       	call   8024e5 <sys_pf_calculate_allocated_pages>
  80021c:	89 45 bc             	mov    %eax,-0x44(%ebp)
	for(i = 0; i< 256;i++)
  80021f:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
  800226:	eb 20                	jmp    800248 <_main+0x210>
	{
		ptr_allocations[i] = malloc(2*Mega);
  800228:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80022b:	01 c0                	add    %eax,%eax
  80022d:	83 ec 0c             	sub    $0xc,%esp
  800230:	50                   	push   %eax
  800231:	e8 03 1e 00 00       	call   802039 <malloc>
  800236:	83 c4 10             	add    $0x10,%esp
  800239:	89 c2                	mov    %eax,%edx
  80023b:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80023e:	89 94 85 b8 f7 ff ff 	mov    %edx,-0x848(%ebp,%eax,4)
	int i;

	// allocate pages
	freeFrames = sys_calculate_free_frames() ;
	usedDiskPages = sys_pf_calculate_allocated_pages();
	for(i = 0; i< 256;i++)
  800245:	ff 45 dc             	incl   -0x24(%ebp)
  800248:	81 7d dc ff 00 00 00 	cmpl   $0xff,-0x24(%ebp)
  80024f:	7e d7                	jle    800228 <_main+0x1f0>
	{
		ptr_allocations[i] = malloc(2*Mega);
	}

	// randomly check the addresses of the allocation
	if( (uint32)ptr_allocations[0] != 0x80000000 ||
  800251:	8b 85 b8 f7 ff ff    	mov    -0x848(%ebp),%eax
  800257:	3d 00 00 00 80       	cmp    $0x80000000,%eax
  80025c:	75 4e                	jne    8002ac <_main+0x274>
			(uint32)ptr_allocations[2] != 0x80400000 ||
  80025e:	8b 85 c0 f7 ff ff    	mov    -0x840(%ebp),%eax
	{
		ptr_allocations[i] = malloc(2*Mega);
	}

	// randomly check the addresses of the allocation
	if( (uint32)ptr_allocations[0] != 0x80000000 ||
  800264:	3d 00 00 40 80       	cmp    $0x80400000,%eax
  800269:	75 41                	jne    8002ac <_main+0x274>
			(uint32)ptr_allocations[2] != 0x80400000 ||
			(uint32)ptr_allocations[8] != 0x81000000 ||
  80026b:	8b 85 d8 f7 ff ff    	mov    -0x828(%ebp),%eax
		ptr_allocations[i] = malloc(2*Mega);
	}

	// randomly check the addresses of the allocation
	if( (uint32)ptr_allocations[0] != 0x80000000 ||
			(uint32)ptr_allocations[2] != 0x80400000 ||
  800271:	3d 00 00 00 81       	cmp    $0x81000000,%eax
  800276:	75 34                	jne    8002ac <_main+0x274>
			(uint32)ptr_allocations[8] != 0x81000000 ||
			(uint32)ptr_allocations[100] != 0x8C800000 ||
  800278:	8b 85 48 f9 ff ff    	mov    -0x6b8(%ebp),%eax
	}

	// randomly check the addresses of the allocation
	if( (uint32)ptr_allocations[0] != 0x80000000 ||
			(uint32)ptr_allocations[2] != 0x80400000 ||
			(uint32)ptr_allocations[8] != 0x81000000 ||
  80027e:	3d 00 00 80 8c       	cmp    $0x8c800000,%eax
  800283:	75 27                	jne    8002ac <_main+0x274>
			(uint32)ptr_allocations[100] != 0x8C800000 ||
			(uint32)ptr_allocations[150] != 0x92C00000 ||
  800285:	8b 85 10 fa ff ff    	mov    -0x5f0(%ebp),%eax

	// randomly check the addresses of the allocation
	if( (uint32)ptr_allocations[0] != 0x80000000 ||
			(uint32)ptr_allocations[2] != 0x80400000 ||
			(uint32)ptr_allocations[8] != 0x81000000 ||
			(uint32)ptr_allocations[100] != 0x8C800000 ||
  80028b:	3d 00 00 c0 92       	cmp    $0x92c00000,%eax
  800290:	75 1a                	jne    8002ac <_main+0x274>
			(uint32)ptr_allocations[150] != 0x92C00000 ||
			(uint32)ptr_allocations[200] != 0x99000000 ||
  800292:	8b 85 d8 fa ff ff    	mov    -0x528(%ebp),%eax
	// randomly check the addresses of the allocation
	if( (uint32)ptr_allocations[0] != 0x80000000 ||
			(uint32)ptr_allocations[2] != 0x80400000 ||
			(uint32)ptr_allocations[8] != 0x81000000 ||
			(uint32)ptr_allocations[100] != 0x8C800000 ||
			(uint32)ptr_allocations[150] != 0x92C00000 ||
  800298:	3d 00 00 00 99       	cmp    $0x99000000,%eax
  80029d:	75 0d                	jne    8002ac <_main+0x274>
			(uint32)ptr_allocations[200] != 0x99000000 ||
			(uint32)ptr_allocations[255] != 0x9FE00000)
  80029f:	8b 85 b4 fb ff ff    	mov    -0x44c(%ebp),%eax
	if( (uint32)ptr_allocations[0] != 0x80000000 ||
			(uint32)ptr_allocations[2] != 0x80400000 ||
			(uint32)ptr_allocations[8] != 0x81000000 ||
			(uint32)ptr_allocations[100] != 0x8C800000 ||
			(uint32)ptr_allocations[150] != 0x92C00000 ||
			(uint32)ptr_allocations[200] != 0x99000000 ||
  8002a5:	3d 00 00 e0 9f       	cmp    $0x9fe00000,%eax
  8002aa:	74 14                	je     8002c0 <_main+0x288>
			(uint32)ptr_allocations[255] != 0x9FE00000)
		panic("Wrong allocation, Check fitting strategy is working correctly");
  8002ac:	83 ec 04             	sub    $0x4,%esp
  8002af:	68 38 3d 80 00       	push   $0x803d38
  8002b4:	6a 5d                	push   $0x5d
  8002b6:	68 5c 3c 80 00       	push   $0x803c5c
  8002bb:	e8 33 0b 00 00       	call   800df3 <_panic>

	if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  512*Mega/PAGE_SIZE) panic("Wrong page file allocation: ");
  8002c0:	e8 20 22 00 00       	call   8024e5 <sys_pf_calculate_allocated_pages>
  8002c5:	2b 45 bc             	sub    -0x44(%ebp),%eax
  8002c8:	89 c2                	mov    %eax,%edx
  8002ca:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8002cd:	c1 e0 09             	shl    $0x9,%eax
  8002d0:	85 c0                	test   %eax,%eax
  8002d2:	79 05                	jns    8002d9 <_main+0x2a1>
  8002d4:	05 ff 0f 00 00       	add    $0xfff,%eax
  8002d9:	c1 f8 0c             	sar    $0xc,%eax
  8002dc:	39 c2                	cmp    %eax,%edx
  8002de:	74 14                	je     8002f4 <_main+0x2bc>
  8002e0:	83 ec 04             	sub    $0x4,%esp
  8002e3:	68 76 3d 80 00       	push   $0x803d76
  8002e8:	6a 5f                	push   $0x5f
  8002ea:	68 5c 3c 80 00       	push   $0x803c5c
  8002ef:	e8 ff 0a 00 00       	call   800df3 <_panic>
	if ((freeFrames - sys_calculate_free_frames()) != (512*Mega)/(1024*PAGE_SIZE) ) panic("Wrong allocation");
  8002f4:	8b 5d c0             	mov    -0x40(%ebp),%ebx
  8002f7:	e8 49 21 00 00       	call   802445 <sys_calculate_free_frames>
  8002fc:	29 c3                	sub    %eax,%ebx
  8002fe:	89 da                	mov    %ebx,%edx
  800300:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800303:	c1 e0 09             	shl    $0x9,%eax
  800306:	85 c0                	test   %eax,%eax
  800308:	79 05                	jns    80030f <_main+0x2d7>
  80030a:	05 ff ff 3f 00       	add    $0x3fffff,%eax
  80030f:	c1 f8 16             	sar    $0x16,%eax
  800312:	39 c2                	cmp    %eax,%edx
  800314:	74 14                	je     80032a <_main+0x2f2>
  800316:	83 ec 04             	sub    $0x4,%esp
  800319:	68 93 3d 80 00       	push   $0x803d93
  80031e:	6a 60                	push   $0x60
  800320:	68 5c 3c 80 00       	push   $0x803c5c
  800325:	e8 c9 0a 00 00       	call   800df3 <_panic>

	// Make memory holes.
	freeFrames = sys_calculate_free_frames() ;
  80032a:	e8 16 21 00 00       	call   802445 <sys_calculate_free_frames>
  80032f:	89 45 c0             	mov    %eax,-0x40(%ebp)
	usedDiskPages = sys_pf_calculate_allocated_pages();
  800332:	e8 ae 21 00 00       	call   8024e5 <sys_pf_calculate_allocated_pages>
  800337:	89 45 bc             	mov    %eax,-0x44(%ebp)

	free(ptr_allocations[0]);		// Hole 1 = 2 M
  80033a:	8b 85 b8 f7 ff ff    	mov    -0x848(%ebp),%eax
  800340:	83 ec 0c             	sub    $0xc,%esp
  800343:	50                   	push   %eax
  800344:	e8 71 1d 00 00       	call   8020ba <free>
  800349:	83 c4 10             	add    $0x10,%esp
	free(ptr_allocations[2]);		// Hole 2 = 4 M
  80034c:	8b 85 c0 f7 ff ff    	mov    -0x840(%ebp),%eax
  800352:	83 ec 0c             	sub    $0xc,%esp
  800355:	50                   	push   %eax
  800356:	e8 5f 1d 00 00       	call   8020ba <free>
  80035b:	83 c4 10             	add    $0x10,%esp
	free(ptr_allocations[3]);
  80035e:	8b 85 c4 f7 ff ff    	mov    -0x83c(%ebp),%eax
  800364:	83 ec 0c             	sub    $0xc,%esp
  800367:	50                   	push   %eax
  800368:	e8 4d 1d 00 00       	call   8020ba <free>
  80036d:	83 c4 10             	add    $0x10,%esp
	free(ptr_allocations[10]);		// Hole 3 = 6 M
  800370:	8b 85 e0 f7 ff ff    	mov    -0x820(%ebp),%eax
  800376:	83 ec 0c             	sub    $0xc,%esp
  800379:	50                   	push   %eax
  80037a:	e8 3b 1d 00 00       	call   8020ba <free>
  80037f:	83 c4 10             	add    $0x10,%esp
	free(ptr_allocations[12]);
  800382:	8b 85 e8 f7 ff ff    	mov    -0x818(%ebp),%eax
  800388:	83 ec 0c             	sub    $0xc,%esp
  80038b:	50                   	push   %eax
  80038c:	e8 29 1d 00 00       	call   8020ba <free>
  800391:	83 c4 10             	add    $0x10,%esp
	free(ptr_allocations[11]);
  800394:	8b 85 e4 f7 ff ff    	mov    -0x81c(%ebp),%eax
  80039a:	83 ec 0c             	sub    $0xc,%esp
  80039d:	50                   	push   %eax
  80039e:	e8 17 1d 00 00       	call   8020ba <free>
  8003a3:	83 c4 10             	add    $0x10,%esp
	free(ptr_allocations[100]);		// Hole 4 = 10 M
  8003a6:	8b 85 48 f9 ff ff    	mov    -0x6b8(%ebp),%eax
  8003ac:	83 ec 0c             	sub    $0xc,%esp
  8003af:	50                   	push   %eax
  8003b0:	e8 05 1d 00 00       	call   8020ba <free>
  8003b5:	83 c4 10             	add    $0x10,%esp
	free(ptr_allocations[104]);
  8003b8:	8b 85 58 f9 ff ff    	mov    -0x6a8(%ebp),%eax
  8003be:	83 ec 0c             	sub    $0xc,%esp
  8003c1:	50                   	push   %eax
  8003c2:	e8 f3 1c 00 00       	call   8020ba <free>
  8003c7:	83 c4 10             	add    $0x10,%esp
	free(ptr_allocations[103]);
  8003ca:	8b 85 54 f9 ff ff    	mov    -0x6ac(%ebp),%eax
  8003d0:	83 ec 0c             	sub    $0xc,%esp
  8003d3:	50                   	push   %eax
  8003d4:	e8 e1 1c 00 00       	call   8020ba <free>
  8003d9:	83 c4 10             	add    $0x10,%esp
	free(ptr_allocations[102]);
  8003dc:	8b 85 50 f9 ff ff    	mov    -0x6b0(%ebp),%eax
  8003e2:	83 ec 0c             	sub    $0xc,%esp
  8003e5:	50                   	push   %eax
  8003e6:	e8 cf 1c 00 00       	call   8020ba <free>
  8003eb:	83 c4 10             	add    $0x10,%esp
	free(ptr_allocations[101]);
  8003ee:	8b 85 4c f9 ff ff    	mov    -0x6b4(%ebp),%eax
  8003f4:	83 ec 0c             	sub    $0xc,%esp
  8003f7:	50                   	push   %eax
  8003f8:	e8 bd 1c 00 00       	call   8020ba <free>
  8003fd:	83 c4 10             	add    $0x10,%esp
	free(ptr_allocations[200]);		// Hole 5 = 8 M
  800400:	8b 85 d8 fa ff ff    	mov    -0x528(%ebp),%eax
  800406:	83 ec 0c             	sub    $0xc,%esp
  800409:	50                   	push   %eax
  80040a:	e8 ab 1c 00 00       	call   8020ba <free>
  80040f:	83 c4 10             	add    $0x10,%esp
	free(ptr_allocations[201]);
  800412:	8b 85 dc fa ff ff    	mov    -0x524(%ebp),%eax
  800418:	83 ec 0c             	sub    $0xc,%esp
  80041b:	50                   	push   %eax
  80041c:	e8 99 1c 00 00       	call   8020ba <free>
  800421:	83 c4 10             	add    $0x10,%esp
	free(ptr_allocations[202]);
  800424:	8b 85 e0 fa ff ff    	mov    -0x520(%ebp),%eax
  80042a:	83 ec 0c             	sub    $0xc,%esp
  80042d:	50                   	push   %eax
  80042e:	e8 87 1c 00 00       	call   8020ba <free>
  800433:	83 c4 10             	add    $0x10,%esp
	free(ptr_allocations[203]);
  800436:	8b 85 e4 fa ff ff    	mov    -0x51c(%ebp),%eax
  80043c:	83 ec 0c             	sub    $0xc,%esp
  80043f:	50                   	push   %eax
  800440:	e8 75 1c 00 00       	call   8020ba <free>
  800445:	83 c4 10             	add    $0x10,%esp

	if ((usedDiskPages - sys_pf_calculate_allocated_pages()) != 15*(2*Mega)/PAGE_SIZE) panic("Wrong free: Extra or less pages are removed from PageFile");
  800448:	e8 98 20 00 00       	call   8024e5 <sys_pf_calculate_allocated_pages>
  80044d:	8b 55 bc             	mov    -0x44(%ebp),%edx
  800450:	89 d1                	mov    %edx,%ecx
  800452:	29 c1                	sub    %eax,%ecx
  800454:	8b 55 d8             	mov    -0x28(%ebp),%edx
  800457:	89 d0                	mov    %edx,%eax
  800459:	01 c0                	add    %eax,%eax
  80045b:	01 d0                	add    %edx,%eax
  80045d:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800464:	01 d0                	add    %edx,%eax
  800466:	01 c0                	add    %eax,%eax
  800468:	85 c0                	test   %eax,%eax
  80046a:	79 05                	jns    800471 <_main+0x439>
  80046c:	05 ff 0f 00 00       	add    $0xfff,%eax
  800471:	c1 f8 0c             	sar    $0xc,%eax
  800474:	39 c1                	cmp    %eax,%ecx
  800476:	74 14                	je     80048c <_main+0x454>
  800478:	83 ec 04             	sub    $0x4,%esp
  80047b:	68 a4 3d 80 00       	push   $0x803da4
  800480:	6a 76                	push   $0x76
  800482:	68 5c 3c 80 00       	push   $0x803c5c
  800487:	e8 67 09 00 00       	call   800df3 <_panic>
	if ((sys_calculate_free_frames() - freeFrames) != 0) panic("Wrong free: Extra or less pages are removed from main memory");
  80048c:	e8 b4 1f 00 00       	call   802445 <sys_calculate_free_frames>
  800491:	89 c2                	mov    %eax,%edx
  800493:	8b 45 c0             	mov    -0x40(%ebp),%eax
  800496:	39 c2                	cmp    %eax,%edx
  800498:	74 14                	je     8004ae <_main+0x476>
  80049a:	83 ec 04             	sub    $0x4,%esp
  80049d:	68 e0 3d 80 00       	push   $0x803de0
  8004a2:	6a 77                	push   $0x77
  8004a4:	68 5c 3c 80 00       	push   $0x803c5c
  8004a9:	e8 45 09 00 00       	call   800df3 <_panic>

	// Test worst fit
	//[WORST FIT Case]
	freeFrames = sys_calculate_free_frames() ;
  8004ae:	e8 92 1f 00 00       	call   802445 <sys_calculate_free_frames>
  8004b3:	89 45 c0             	mov    %eax,-0x40(%ebp)
	usedDiskPages = sys_pf_calculate_allocated_pages();
  8004b6:	e8 2a 20 00 00       	call   8024e5 <sys_pf_calculate_allocated_pages>
  8004bb:	89 45 bc             	mov    %eax,-0x44(%ebp)
	void* tempAddress = malloc(Mega);		// Use Hole 4 -> Hole 4 = 9 M
  8004be:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8004c1:	83 ec 0c             	sub    $0xc,%esp
  8004c4:	50                   	push   %eax
  8004c5:	e8 6f 1b 00 00       	call   802039 <malloc>
  8004ca:	83 c4 10             	add    $0x10,%esp
  8004cd:	89 45 b8             	mov    %eax,-0x48(%ebp)
	if((uint32)tempAddress != 0x8C800000)
  8004d0:	8b 45 b8             	mov    -0x48(%ebp),%eax
  8004d3:	3d 00 00 80 8c       	cmp    $0x8c800000,%eax
  8004d8:	74 14                	je     8004ee <_main+0x4b6>
		panic("Worst Fit not working correctly");
  8004da:	83 ec 04             	sub    $0x4,%esp
  8004dd:	68 20 3e 80 00       	push   $0x803e20
  8004e2:	6a 7f                	push   $0x7f
  8004e4:	68 5c 3c 80 00       	push   $0x803c5c
  8004e9:	e8 05 09 00 00       	call   800df3 <_panic>
	if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  1*Mega/PAGE_SIZE) panic("Wrong page file allocation: ");
  8004ee:	e8 f2 1f 00 00       	call   8024e5 <sys_pf_calculate_allocated_pages>
  8004f3:	2b 45 bc             	sub    -0x44(%ebp),%eax
  8004f6:	89 c2                	mov    %eax,%edx
  8004f8:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8004fb:	85 c0                	test   %eax,%eax
  8004fd:	79 05                	jns    800504 <_main+0x4cc>
  8004ff:	05 ff 0f 00 00       	add    $0xfff,%eax
  800504:	c1 f8 0c             	sar    $0xc,%eax
  800507:	39 c2                	cmp    %eax,%edx
  800509:	74 17                	je     800522 <_main+0x4ea>
  80050b:	83 ec 04             	sub    $0x4,%esp
  80050e:	68 76 3d 80 00       	push   $0x803d76
  800513:	68 80 00 00 00       	push   $0x80
  800518:	68 5c 3c 80 00       	push   $0x803c5c
  80051d:	e8 d1 08 00 00       	call   800df3 <_panic>
	if ((freeFrames - sys_calculate_free_frames()) != 0) panic("Wrong allocation");
  800522:	e8 1e 1f 00 00       	call   802445 <sys_calculate_free_frames>
  800527:	89 c2                	mov    %eax,%edx
  800529:	8b 45 c0             	mov    -0x40(%ebp),%eax
  80052c:	39 c2                	cmp    %eax,%edx
  80052e:	74 17                	je     800547 <_main+0x50f>
  800530:	83 ec 04             	sub    $0x4,%esp
  800533:	68 93 3d 80 00       	push   $0x803d93
  800538:	68 81 00 00 00       	push   $0x81
  80053d:	68 5c 3c 80 00       	push   $0x803c5c
  800542:	e8 ac 08 00 00       	call   800df3 <_panic>
	cprintf("Test %d Passed \n", ++count);
  800547:	ff 45 d0             	incl   -0x30(%ebp)
  80054a:	83 ec 08             	sub    $0x8,%esp
  80054d:	ff 75 d0             	pushl  -0x30(%ebp)
  800550:	68 40 3e 80 00       	push   $0x803e40
  800555:	e8 4d 0b 00 00       	call   8010a7 <cprintf>
  80055a:	83 c4 10             	add    $0x10,%esp

	freeFrames = sys_calculate_free_frames() ;
  80055d:	e8 e3 1e 00 00       	call   802445 <sys_calculate_free_frames>
  800562:	89 45 c0             	mov    %eax,-0x40(%ebp)
	usedDiskPages = sys_pf_calculate_allocated_pages();
  800565:	e8 7b 1f 00 00       	call   8024e5 <sys_pf_calculate_allocated_pages>
  80056a:	89 45 bc             	mov    %eax,-0x44(%ebp)
	tempAddress = malloc(4 * Mega);			// Use Hole 4 -> Hole 4 = 5 M
  80056d:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800570:	c1 e0 02             	shl    $0x2,%eax
  800573:	83 ec 0c             	sub    $0xc,%esp
  800576:	50                   	push   %eax
  800577:	e8 bd 1a 00 00       	call   802039 <malloc>
  80057c:	83 c4 10             	add    $0x10,%esp
  80057f:	89 45 b8             	mov    %eax,-0x48(%ebp)
	if((uint32)tempAddress != 0x8C900000)
  800582:	8b 45 b8             	mov    -0x48(%ebp),%eax
  800585:	3d 00 00 90 8c       	cmp    $0x8c900000,%eax
  80058a:	74 17                	je     8005a3 <_main+0x56b>
		panic("Worst Fit not working correctly");
  80058c:	83 ec 04             	sub    $0x4,%esp
  80058f:	68 20 3e 80 00       	push   $0x803e20
  800594:	68 88 00 00 00       	push   $0x88
  800599:	68 5c 3c 80 00       	push   $0x803c5c
  80059e:	e8 50 08 00 00       	call   800df3 <_panic>
	if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  4*Mega/PAGE_SIZE) panic("Wrong page file allocation: ");
  8005a3:	e8 3d 1f 00 00       	call   8024e5 <sys_pf_calculate_allocated_pages>
  8005a8:	2b 45 bc             	sub    -0x44(%ebp),%eax
  8005ab:	89 c2                	mov    %eax,%edx
  8005ad:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8005b0:	c1 e0 02             	shl    $0x2,%eax
  8005b3:	85 c0                	test   %eax,%eax
  8005b5:	79 05                	jns    8005bc <_main+0x584>
  8005b7:	05 ff 0f 00 00       	add    $0xfff,%eax
  8005bc:	c1 f8 0c             	sar    $0xc,%eax
  8005bf:	39 c2                	cmp    %eax,%edx
  8005c1:	74 17                	je     8005da <_main+0x5a2>
  8005c3:	83 ec 04             	sub    $0x4,%esp
  8005c6:	68 76 3d 80 00       	push   $0x803d76
  8005cb:	68 89 00 00 00       	push   $0x89
  8005d0:	68 5c 3c 80 00       	push   $0x803c5c
  8005d5:	e8 19 08 00 00       	call   800df3 <_panic>
	if ((freeFrames - sys_calculate_free_frames()) != 0) panic("Wrong allocation");
  8005da:	e8 66 1e 00 00       	call   802445 <sys_calculate_free_frames>
  8005df:	89 c2                	mov    %eax,%edx
  8005e1:	8b 45 c0             	mov    -0x40(%ebp),%eax
  8005e4:	39 c2                	cmp    %eax,%edx
  8005e6:	74 17                	je     8005ff <_main+0x5c7>
  8005e8:	83 ec 04             	sub    $0x4,%esp
  8005eb:	68 93 3d 80 00       	push   $0x803d93
  8005f0:	68 8a 00 00 00       	push   $0x8a
  8005f5:	68 5c 3c 80 00       	push   $0x803c5c
  8005fa:	e8 f4 07 00 00       	call   800df3 <_panic>
	cprintf("Test %d Passed \n", ++count);
  8005ff:	ff 45 d0             	incl   -0x30(%ebp)
  800602:	83 ec 08             	sub    $0x8,%esp
  800605:	ff 75 d0             	pushl  -0x30(%ebp)
  800608:	68 40 3e 80 00       	push   $0x803e40
  80060d:	e8 95 0a 00 00       	call   8010a7 <cprintf>
  800612:	83 c4 10             	add    $0x10,%esp

	freeFrames = sys_calculate_free_frames() ;
  800615:	e8 2b 1e 00 00       	call   802445 <sys_calculate_free_frames>
  80061a:	89 45 c0             	mov    %eax,-0x40(%ebp)
	usedDiskPages = sys_pf_calculate_allocated_pages();
  80061d:	e8 c3 1e 00 00       	call   8024e5 <sys_pf_calculate_allocated_pages>
  800622:	89 45 bc             	mov    %eax,-0x44(%ebp)
	tempAddress = malloc(6*Mega); 			   // Use Hole 5 -> Hole 5 = 2 M
  800625:	8b 55 d8             	mov    -0x28(%ebp),%edx
  800628:	89 d0                	mov    %edx,%eax
  80062a:	01 c0                	add    %eax,%eax
  80062c:	01 d0                	add    %edx,%eax
  80062e:	01 c0                	add    %eax,%eax
  800630:	83 ec 0c             	sub    $0xc,%esp
  800633:	50                   	push   %eax
  800634:	e8 00 1a 00 00       	call   802039 <malloc>
  800639:	83 c4 10             	add    $0x10,%esp
  80063c:	89 45 b8             	mov    %eax,-0x48(%ebp)
	if((uint32)tempAddress != 0x99000000)
  80063f:	8b 45 b8             	mov    -0x48(%ebp),%eax
  800642:	3d 00 00 00 99       	cmp    $0x99000000,%eax
  800647:	74 17                	je     800660 <_main+0x628>
		panic("Worst Fit not working correctly");
  800649:	83 ec 04             	sub    $0x4,%esp
  80064c:	68 20 3e 80 00       	push   $0x803e20
  800651:	68 91 00 00 00       	push   $0x91
  800656:	68 5c 3c 80 00       	push   $0x803c5c
  80065b:	e8 93 07 00 00       	call   800df3 <_panic>
	if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  6*Mega/PAGE_SIZE) panic("Wrong page file allocation: ");
  800660:	e8 80 1e 00 00       	call   8024e5 <sys_pf_calculate_allocated_pages>
  800665:	2b 45 bc             	sub    -0x44(%ebp),%eax
  800668:	89 c1                	mov    %eax,%ecx
  80066a:	8b 55 d8             	mov    -0x28(%ebp),%edx
  80066d:	89 d0                	mov    %edx,%eax
  80066f:	01 c0                	add    %eax,%eax
  800671:	01 d0                	add    %edx,%eax
  800673:	01 c0                	add    %eax,%eax
  800675:	85 c0                	test   %eax,%eax
  800677:	79 05                	jns    80067e <_main+0x646>
  800679:	05 ff 0f 00 00       	add    $0xfff,%eax
  80067e:	c1 f8 0c             	sar    $0xc,%eax
  800681:	39 c1                	cmp    %eax,%ecx
  800683:	74 17                	je     80069c <_main+0x664>
  800685:	83 ec 04             	sub    $0x4,%esp
  800688:	68 76 3d 80 00       	push   $0x803d76
  80068d:	68 92 00 00 00       	push   $0x92
  800692:	68 5c 3c 80 00       	push   $0x803c5c
  800697:	e8 57 07 00 00       	call   800df3 <_panic>
	if ((freeFrames - sys_calculate_free_frames()) != 0) panic("Wrong allocation");
  80069c:	e8 a4 1d 00 00       	call   802445 <sys_calculate_free_frames>
  8006a1:	89 c2                	mov    %eax,%edx
  8006a3:	8b 45 c0             	mov    -0x40(%ebp),%eax
  8006a6:	39 c2                	cmp    %eax,%edx
  8006a8:	74 17                	je     8006c1 <_main+0x689>
  8006aa:	83 ec 04             	sub    $0x4,%esp
  8006ad:	68 93 3d 80 00       	push   $0x803d93
  8006b2:	68 93 00 00 00       	push   $0x93
  8006b7:	68 5c 3c 80 00       	push   $0x803c5c
  8006bc:	e8 32 07 00 00       	call   800df3 <_panic>
	cprintf("Test %d Passed \n", ++count);
  8006c1:	ff 45 d0             	incl   -0x30(%ebp)
  8006c4:	83 ec 08             	sub    $0x8,%esp
  8006c7:	ff 75 d0             	pushl  -0x30(%ebp)
  8006ca:	68 40 3e 80 00       	push   $0x803e40
  8006cf:	e8 d3 09 00 00       	call   8010a7 <cprintf>
  8006d4:	83 c4 10             	add    $0x10,%esp

	freeFrames = sys_calculate_free_frames() ;
  8006d7:	e8 69 1d 00 00       	call   802445 <sys_calculate_free_frames>
  8006dc:	89 45 c0             	mov    %eax,-0x40(%ebp)
	usedDiskPages = sys_pf_calculate_allocated_pages();
  8006df:	e8 01 1e 00 00       	call   8024e5 <sys_pf_calculate_allocated_pages>
  8006e4:	89 45 bc             	mov    %eax,-0x44(%ebp)
	tempAddress = malloc(5*Mega); 			   // Use Hole 3 -> Hole 3 = 1 M
  8006e7:	8b 55 d8             	mov    -0x28(%ebp),%edx
  8006ea:	89 d0                	mov    %edx,%eax
  8006ec:	c1 e0 02             	shl    $0x2,%eax
  8006ef:	01 d0                	add    %edx,%eax
  8006f1:	83 ec 0c             	sub    $0xc,%esp
  8006f4:	50                   	push   %eax
  8006f5:	e8 3f 19 00 00       	call   802039 <malloc>
  8006fa:	83 c4 10             	add    $0x10,%esp
  8006fd:	89 45 b8             	mov    %eax,-0x48(%ebp)
	if((uint32)tempAddress != 0x81400000)
  800700:	8b 45 b8             	mov    -0x48(%ebp),%eax
  800703:	3d 00 00 40 81       	cmp    $0x81400000,%eax
  800708:	74 17                	je     800721 <_main+0x6e9>
		panic("Worst Fit not working correctly");
  80070a:	83 ec 04             	sub    $0x4,%esp
  80070d:	68 20 3e 80 00       	push   $0x803e20
  800712:	68 9a 00 00 00       	push   $0x9a
  800717:	68 5c 3c 80 00       	push   $0x803c5c
  80071c:	e8 d2 06 00 00       	call   800df3 <_panic>
	if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  5*Mega/PAGE_SIZE) panic("Wrong page file allocation: ");
  800721:	e8 bf 1d 00 00       	call   8024e5 <sys_pf_calculate_allocated_pages>
  800726:	2b 45 bc             	sub    -0x44(%ebp),%eax
  800729:	89 c1                	mov    %eax,%ecx
  80072b:	8b 55 d8             	mov    -0x28(%ebp),%edx
  80072e:	89 d0                	mov    %edx,%eax
  800730:	c1 e0 02             	shl    $0x2,%eax
  800733:	01 d0                	add    %edx,%eax
  800735:	85 c0                	test   %eax,%eax
  800737:	79 05                	jns    80073e <_main+0x706>
  800739:	05 ff 0f 00 00       	add    $0xfff,%eax
  80073e:	c1 f8 0c             	sar    $0xc,%eax
  800741:	39 c1                	cmp    %eax,%ecx
  800743:	74 17                	je     80075c <_main+0x724>
  800745:	83 ec 04             	sub    $0x4,%esp
  800748:	68 76 3d 80 00       	push   $0x803d76
  80074d:	68 9b 00 00 00       	push   $0x9b
  800752:	68 5c 3c 80 00       	push   $0x803c5c
  800757:	e8 97 06 00 00       	call   800df3 <_panic>
	if ((freeFrames - sys_calculate_free_frames()) != 0) panic("Wrong allocation");
  80075c:	e8 e4 1c 00 00       	call   802445 <sys_calculate_free_frames>
  800761:	89 c2                	mov    %eax,%edx
  800763:	8b 45 c0             	mov    -0x40(%ebp),%eax
  800766:	39 c2                	cmp    %eax,%edx
  800768:	74 17                	je     800781 <_main+0x749>
  80076a:	83 ec 04             	sub    $0x4,%esp
  80076d:	68 93 3d 80 00       	push   $0x803d93
  800772:	68 9c 00 00 00       	push   $0x9c
  800777:	68 5c 3c 80 00       	push   $0x803c5c
  80077c:	e8 72 06 00 00       	call   800df3 <_panic>
	cprintf("Test %d Passed \n", ++count);
  800781:	ff 45 d0             	incl   -0x30(%ebp)
  800784:	83 ec 08             	sub    $0x8,%esp
  800787:	ff 75 d0             	pushl  -0x30(%ebp)
  80078a:	68 40 3e 80 00       	push   $0x803e40
  80078f:	e8 13 09 00 00       	call   8010a7 <cprintf>
  800794:	83 c4 10             	add    $0x10,%esp

	freeFrames = sys_calculate_free_frames() ;
  800797:	e8 a9 1c 00 00       	call   802445 <sys_calculate_free_frames>
  80079c:	89 45 c0             	mov    %eax,-0x40(%ebp)
	usedDiskPages = sys_pf_calculate_allocated_pages();
  80079f:	e8 41 1d 00 00       	call   8024e5 <sys_pf_calculate_allocated_pages>
  8007a4:	89 45 bc             	mov    %eax,-0x44(%ebp)
	tempAddress = malloc(4*Mega); 			   // Use Hole 4 -> Hole 4 = 1 M
  8007a7:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8007aa:	c1 e0 02             	shl    $0x2,%eax
  8007ad:	83 ec 0c             	sub    $0xc,%esp
  8007b0:	50                   	push   %eax
  8007b1:	e8 83 18 00 00       	call   802039 <malloc>
  8007b6:	83 c4 10             	add    $0x10,%esp
  8007b9:	89 45 b8             	mov    %eax,-0x48(%ebp)
	if((uint32)tempAddress != 0x8CD00000)
  8007bc:	8b 45 b8             	mov    -0x48(%ebp),%eax
  8007bf:	3d 00 00 d0 8c       	cmp    $0x8cd00000,%eax
  8007c4:	74 17                	je     8007dd <_main+0x7a5>
		panic("Worst Fit not working correctly");
  8007c6:	83 ec 04             	sub    $0x4,%esp
  8007c9:	68 20 3e 80 00       	push   $0x803e20
  8007ce:	68 a3 00 00 00       	push   $0xa3
  8007d3:	68 5c 3c 80 00       	push   $0x803c5c
  8007d8:	e8 16 06 00 00       	call   800df3 <_panic>
	if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  4*Mega/PAGE_SIZE) panic("Wrong page file allocation: ");
  8007dd:	e8 03 1d 00 00       	call   8024e5 <sys_pf_calculate_allocated_pages>
  8007e2:	2b 45 bc             	sub    -0x44(%ebp),%eax
  8007e5:	89 c2                	mov    %eax,%edx
  8007e7:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8007ea:	c1 e0 02             	shl    $0x2,%eax
  8007ed:	85 c0                	test   %eax,%eax
  8007ef:	79 05                	jns    8007f6 <_main+0x7be>
  8007f1:	05 ff 0f 00 00       	add    $0xfff,%eax
  8007f6:	c1 f8 0c             	sar    $0xc,%eax
  8007f9:	39 c2                	cmp    %eax,%edx
  8007fb:	74 17                	je     800814 <_main+0x7dc>
  8007fd:	83 ec 04             	sub    $0x4,%esp
  800800:	68 76 3d 80 00       	push   $0x803d76
  800805:	68 a4 00 00 00       	push   $0xa4
  80080a:	68 5c 3c 80 00       	push   $0x803c5c
  80080f:	e8 df 05 00 00       	call   800df3 <_panic>
	if ((freeFrames - sys_calculate_free_frames()) != 0) panic("Wrong allocation");
  800814:	e8 2c 1c 00 00       	call   802445 <sys_calculate_free_frames>
  800819:	89 c2                	mov    %eax,%edx
  80081b:	8b 45 c0             	mov    -0x40(%ebp),%eax
  80081e:	39 c2                	cmp    %eax,%edx
  800820:	74 17                	je     800839 <_main+0x801>
  800822:	83 ec 04             	sub    $0x4,%esp
  800825:	68 93 3d 80 00       	push   $0x803d93
  80082a:	68 a5 00 00 00       	push   $0xa5
  80082f:	68 5c 3c 80 00       	push   $0x803c5c
  800834:	e8 ba 05 00 00       	call   800df3 <_panic>
	cprintf("Test %d Passed \n", ++count);
  800839:	ff 45 d0             	incl   -0x30(%ebp)
  80083c:	83 ec 08             	sub    $0x8,%esp
  80083f:	ff 75 d0             	pushl  -0x30(%ebp)
  800842:	68 40 3e 80 00       	push   $0x803e40
  800847:	e8 5b 08 00 00       	call   8010a7 <cprintf>
  80084c:	83 c4 10             	add    $0x10,%esp

	freeFrames = sys_calculate_free_frames() ;
  80084f:	e8 f1 1b 00 00       	call   802445 <sys_calculate_free_frames>
  800854:	89 45 c0             	mov    %eax,-0x40(%ebp)
	usedDiskPages = sys_pf_calculate_allocated_pages();
  800857:	e8 89 1c 00 00       	call   8024e5 <sys_pf_calculate_allocated_pages>
  80085c:	89 45 bc             	mov    %eax,-0x44(%ebp)
	tempAddress = malloc(2 * Mega); 			// Use Hole 2 -> Hole 2 = 2 M
  80085f:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800862:	01 c0                	add    %eax,%eax
  800864:	83 ec 0c             	sub    $0xc,%esp
  800867:	50                   	push   %eax
  800868:	e8 cc 17 00 00       	call   802039 <malloc>
  80086d:	83 c4 10             	add    $0x10,%esp
  800870:	89 45 b8             	mov    %eax,-0x48(%ebp)
	if((uint32)tempAddress != 0x80400000)
  800873:	8b 45 b8             	mov    -0x48(%ebp),%eax
  800876:	3d 00 00 40 80       	cmp    $0x80400000,%eax
  80087b:	74 17                	je     800894 <_main+0x85c>
		panic("Worst Fit not working correctly");
  80087d:	83 ec 04             	sub    $0x4,%esp
  800880:	68 20 3e 80 00       	push   $0x803e20
  800885:	68 ac 00 00 00       	push   $0xac
  80088a:	68 5c 3c 80 00       	push   $0x803c5c
  80088f:	e8 5f 05 00 00       	call   800df3 <_panic>
	if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  2*Mega/PAGE_SIZE) panic("Wrong page file allocation: ");
  800894:	e8 4c 1c 00 00       	call   8024e5 <sys_pf_calculate_allocated_pages>
  800899:	2b 45 bc             	sub    -0x44(%ebp),%eax
  80089c:	89 c2                	mov    %eax,%edx
  80089e:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8008a1:	01 c0                	add    %eax,%eax
  8008a3:	85 c0                	test   %eax,%eax
  8008a5:	79 05                	jns    8008ac <_main+0x874>
  8008a7:	05 ff 0f 00 00       	add    $0xfff,%eax
  8008ac:	c1 f8 0c             	sar    $0xc,%eax
  8008af:	39 c2                	cmp    %eax,%edx
  8008b1:	74 17                	je     8008ca <_main+0x892>
  8008b3:	83 ec 04             	sub    $0x4,%esp
  8008b6:	68 76 3d 80 00       	push   $0x803d76
  8008bb:	68 ad 00 00 00       	push   $0xad
  8008c0:	68 5c 3c 80 00       	push   $0x803c5c
  8008c5:	e8 29 05 00 00       	call   800df3 <_panic>
	if ((freeFrames - sys_calculate_free_frames()) != 0) panic("Wrong allocation");
  8008ca:	e8 76 1b 00 00       	call   802445 <sys_calculate_free_frames>
  8008cf:	89 c2                	mov    %eax,%edx
  8008d1:	8b 45 c0             	mov    -0x40(%ebp),%eax
  8008d4:	39 c2                	cmp    %eax,%edx
  8008d6:	74 17                	je     8008ef <_main+0x8b7>
  8008d8:	83 ec 04             	sub    $0x4,%esp
  8008db:	68 93 3d 80 00       	push   $0x803d93
  8008e0:	68 ae 00 00 00       	push   $0xae
  8008e5:	68 5c 3c 80 00       	push   $0x803c5c
  8008ea:	e8 04 05 00 00       	call   800df3 <_panic>
	cprintf("Test %d Passed \n", ++count);
  8008ef:	ff 45 d0             	incl   -0x30(%ebp)
  8008f2:	83 ec 08             	sub    $0x8,%esp
  8008f5:	ff 75 d0             	pushl  -0x30(%ebp)
  8008f8:	68 40 3e 80 00       	push   $0x803e40
  8008fd:	e8 a5 07 00 00       	call   8010a7 <cprintf>
  800902:	83 c4 10             	add    $0x10,%esp

	freeFrames = sys_calculate_free_frames() ;
  800905:	e8 3b 1b 00 00       	call   802445 <sys_calculate_free_frames>
  80090a:	89 45 c0             	mov    %eax,-0x40(%ebp)
	usedDiskPages = sys_pf_calculate_allocated_pages();
  80090d:	e8 d3 1b 00 00       	call   8024e5 <sys_pf_calculate_allocated_pages>
  800912:	89 45 bc             	mov    %eax,-0x44(%ebp)
	tempAddress = malloc(1*Mega + 512*kilo);    // Use Hole 1 -> Hole 1 = 0.5 M
  800915:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  800918:	c1 e0 09             	shl    $0x9,%eax
  80091b:	89 c2                	mov    %eax,%edx
  80091d:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800920:	01 d0                	add    %edx,%eax
  800922:	83 ec 0c             	sub    $0xc,%esp
  800925:	50                   	push   %eax
  800926:	e8 0e 17 00 00       	call   802039 <malloc>
  80092b:	83 c4 10             	add    $0x10,%esp
  80092e:	89 45 b8             	mov    %eax,-0x48(%ebp)
	if((uint32)tempAddress != 0x80000000)
  800931:	8b 45 b8             	mov    -0x48(%ebp),%eax
  800934:	3d 00 00 00 80       	cmp    $0x80000000,%eax
  800939:	74 17                	je     800952 <_main+0x91a>
		panic("Worst Fit not working correctly");
  80093b:	83 ec 04             	sub    $0x4,%esp
  80093e:	68 20 3e 80 00       	push   $0x803e20
  800943:	68 b5 00 00 00       	push   $0xb5
  800948:	68 5c 3c 80 00       	push   $0x803c5c
  80094d:	e8 a1 04 00 00       	call   800df3 <_panic>
	if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  (1*Mega + 512*kilo)/PAGE_SIZE) panic("Wrong page file allocation: ");
  800952:	e8 8e 1b 00 00       	call   8024e5 <sys_pf_calculate_allocated_pages>
  800957:	2b 45 bc             	sub    -0x44(%ebp),%eax
  80095a:	89 c2                	mov    %eax,%edx
  80095c:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80095f:	c1 e0 09             	shl    $0x9,%eax
  800962:	89 c1                	mov    %eax,%ecx
  800964:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800967:	01 c8                	add    %ecx,%eax
  800969:	85 c0                	test   %eax,%eax
  80096b:	79 05                	jns    800972 <_main+0x93a>
  80096d:	05 ff 0f 00 00       	add    $0xfff,%eax
  800972:	c1 f8 0c             	sar    $0xc,%eax
  800975:	39 c2                	cmp    %eax,%edx
  800977:	74 17                	je     800990 <_main+0x958>
  800979:	83 ec 04             	sub    $0x4,%esp
  80097c:	68 76 3d 80 00       	push   $0x803d76
  800981:	68 b6 00 00 00       	push   $0xb6
  800986:	68 5c 3c 80 00       	push   $0x803c5c
  80098b:	e8 63 04 00 00       	call   800df3 <_panic>
	if ((freeFrames - sys_calculate_free_frames()) != 0) panic("Wrong allocation");
  800990:	e8 b0 1a 00 00       	call   802445 <sys_calculate_free_frames>
  800995:	89 c2                	mov    %eax,%edx
  800997:	8b 45 c0             	mov    -0x40(%ebp),%eax
  80099a:	39 c2                	cmp    %eax,%edx
  80099c:	74 17                	je     8009b5 <_main+0x97d>
  80099e:	83 ec 04             	sub    $0x4,%esp
  8009a1:	68 93 3d 80 00       	push   $0x803d93
  8009a6:	68 b7 00 00 00       	push   $0xb7
  8009ab:	68 5c 3c 80 00       	push   $0x803c5c
  8009b0:	e8 3e 04 00 00       	call   800df3 <_panic>
	cprintf("Test %d Passed \n", ++count);
  8009b5:	ff 45 d0             	incl   -0x30(%ebp)
  8009b8:	83 ec 08             	sub    $0x8,%esp
  8009bb:	ff 75 d0             	pushl  -0x30(%ebp)
  8009be:	68 40 3e 80 00       	push   $0x803e40
  8009c3:	e8 df 06 00 00       	call   8010a7 <cprintf>
  8009c8:	83 c4 10             	add    $0x10,%esp

	freeFrames = sys_calculate_free_frames() ;
  8009cb:	e8 75 1a 00 00       	call   802445 <sys_calculate_free_frames>
  8009d0:	89 45 c0             	mov    %eax,-0x40(%ebp)
	usedDiskPages = sys_pf_calculate_allocated_pages();
  8009d3:	e8 0d 1b 00 00       	call   8024e5 <sys_pf_calculate_allocated_pages>
  8009d8:	89 45 bc             	mov    %eax,-0x44(%ebp)
	tempAddress = malloc(512*kilo); 			   // Use Hole 2 -> Hole 2 = 1.5 M
  8009db:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8009de:	c1 e0 09             	shl    $0x9,%eax
  8009e1:	83 ec 0c             	sub    $0xc,%esp
  8009e4:	50                   	push   %eax
  8009e5:	e8 4f 16 00 00       	call   802039 <malloc>
  8009ea:	83 c4 10             	add    $0x10,%esp
  8009ed:	89 45 b8             	mov    %eax,-0x48(%ebp)
	if((uint32)tempAddress != 0x80600000)
  8009f0:	8b 45 b8             	mov    -0x48(%ebp),%eax
  8009f3:	3d 00 00 60 80       	cmp    $0x80600000,%eax
  8009f8:	74 17                	je     800a11 <_main+0x9d9>
		panic("Worst Fit not working correctly");
  8009fa:	83 ec 04             	sub    $0x4,%esp
  8009fd:	68 20 3e 80 00       	push   $0x803e20
  800a02:	68 be 00 00 00       	push   $0xbe
  800a07:	68 5c 3c 80 00       	push   $0x803c5c
  800a0c:	e8 e2 03 00 00       	call   800df3 <_panic>
	if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  512*kilo/PAGE_SIZE) panic("Wrong page file allocation: ");
  800a11:	e8 cf 1a 00 00       	call   8024e5 <sys_pf_calculate_allocated_pages>
  800a16:	2b 45 bc             	sub    -0x44(%ebp),%eax
  800a19:	89 c2                	mov    %eax,%edx
  800a1b:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  800a1e:	c1 e0 09             	shl    $0x9,%eax
  800a21:	85 c0                	test   %eax,%eax
  800a23:	79 05                	jns    800a2a <_main+0x9f2>
  800a25:	05 ff 0f 00 00       	add    $0xfff,%eax
  800a2a:	c1 f8 0c             	sar    $0xc,%eax
  800a2d:	39 c2                	cmp    %eax,%edx
  800a2f:	74 17                	je     800a48 <_main+0xa10>
  800a31:	83 ec 04             	sub    $0x4,%esp
  800a34:	68 76 3d 80 00       	push   $0x803d76
  800a39:	68 bf 00 00 00       	push   $0xbf
  800a3e:	68 5c 3c 80 00       	push   $0x803c5c
  800a43:	e8 ab 03 00 00       	call   800df3 <_panic>
	if ((freeFrames - sys_calculate_free_frames()) != 0) panic("Wrong allocation");
  800a48:	e8 f8 19 00 00       	call   802445 <sys_calculate_free_frames>
  800a4d:	89 c2                	mov    %eax,%edx
  800a4f:	8b 45 c0             	mov    -0x40(%ebp),%eax
  800a52:	39 c2                	cmp    %eax,%edx
  800a54:	74 17                	je     800a6d <_main+0xa35>
  800a56:	83 ec 04             	sub    $0x4,%esp
  800a59:	68 93 3d 80 00       	push   $0x803d93
  800a5e:	68 c0 00 00 00       	push   $0xc0
  800a63:	68 5c 3c 80 00       	push   $0x803c5c
  800a68:	e8 86 03 00 00       	call   800df3 <_panic>
	cprintf("Test %d Passed \n", ++count);
  800a6d:	ff 45 d0             	incl   -0x30(%ebp)
  800a70:	83 ec 08             	sub    $0x8,%esp
  800a73:	ff 75 d0             	pushl  -0x30(%ebp)
  800a76:	68 40 3e 80 00       	push   $0x803e40
  800a7b:	e8 27 06 00 00       	call   8010a7 <cprintf>
  800a80:	83 c4 10             	add    $0x10,%esp

	freeFrames = sys_calculate_free_frames() ;
  800a83:	e8 bd 19 00 00       	call   802445 <sys_calculate_free_frames>
  800a88:	89 45 c0             	mov    %eax,-0x40(%ebp)
	usedDiskPages = sys_pf_calculate_allocated_pages();
  800a8b:	e8 55 1a 00 00       	call   8024e5 <sys_pf_calculate_allocated_pages>
  800a90:	89 45 bc             	mov    %eax,-0x44(%ebp)
	tempAddress = malloc(kilo); 			   // Use Hole 5 -> Hole 5 = 2 M - K
  800a93:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  800a96:	83 ec 0c             	sub    $0xc,%esp
  800a99:	50                   	push   %eax
  800a9a:	e8 9a 15 00 00       	call   802039 <malloc>
  800a9f:	83 c4 10             	add    $0x10,%esp
  800aa2:	89 45 b8             	mov    %eax,-0x48(%ebp)
	if((uint32)tempAddress != 0x99600000)
  800aa5:	8b 45 b8             	mov    -0x48(%ebp),%eax
  800aa8:	3d 00 00 60 99       	cmp    $0x99600000,%eax
  800aad:	74 17                	je     800ac6 <_main+0xa8e>
		panic("Worst Fit not working correctly");
  800aaf:	83 ec 04             	sub    $0x4,%esp
  800ab2:	68 20 3e 80 00       	push   $0x803e20
  800ab7:	68 c7 00 00 00       	push   $0xc7
  800abc:	68 5c 3c 80 00       	push   $0x803c5c
  800ac1:	e8 2d 03 00 00       	call   800df3 <_panic>
	if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  4*kilo/PAGE_SIZE) panic("Wrong page file allocation: ");
  800ac6:	e8 1a 1a 00 00       	call   8024e5 <sys_pf_calculate_allocated_pages>
  800acb:	2b 45 bc             	sub    -0x44(%ebp),%eax
  800ace:	89 c2                	mov    %eax,%edx
  800ad0:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  800ad3:	c1 e0 02             	shl    $0x2,%eax
  800ad6:	85 c0                	test   %eax,%eax
  800ad8:	79 05                	jns    800adf <_main+0xaa7>
  800ada:	05 ff 0f 00 00       	add    $0xfff,%eax
  800adf:	c1 f8 0c             	sar    $0xc,%eax
  800ae2:	39 c2                	cmp    %eax,%edx
  800ae4:	74 17                	je     800afd <_main+0xac5>
  800ae6:	83 ec 04             	sub    $0x4,%esp
  800ae9:	68 76 3d 80 00       	push   $0x803d76
  800aee:	68 c8 00 00 00       	push   $0xc8
  800af3:	68 5c 3c 80 00       	push   $0x803c5c
  800af8:	e8 f6 02 00 00       	call   800df3 <_panic>
	if ((freeFrames - sys_calculate_free_frames()) != 0) panic("Wrong allocation");
  800afd:	e8 43 19 00 00       	call   802445 <sys_calculate_free_frames>
  800b02:	89 c2                	mov    %eax,%edx
  800b04:	8b 45 c0             	mov    -0x40(%ebp),%eax
  800b07:	39 c2                	cmp    %eax,%edx
  800b09:	74 17                	je     800b22 <_main+0xaea>
  800b0b:	83 ec 04             	sub    $0x4,%esp
  800b0e:	68 93 3d 80 00       	push   $0x803d93
  800b13:	68 c9 00 00 00       	push   $0xc9
  800b18:	68 5c 3c 80 00       	push   $0x803c5c
  800b1d:	e8 d1 02 00 00       	call   800df3 <_panic>
	cprintf("Test %d Passed \n", ++count);
  800b22:	ff 45 d0             	incl   -0x30(%ebp)
  800b25:	83 ec 08             	sub    $0x8,%esp
  800b28:	ff 75 d0             	pushl  -0x30(%ebp)
  800b2b:	68 40 3e 80 00       	push   $0x803e40
  800b30:	e8 72 05 00 00       	call   8010a7 <cprintf>
  800b35:	83 c4 10             	add    $0x10,%esp

	freeFrames = sys_calculate_free_frames() ;
  800b38:	e8 08 19 00 00       	call   802445 <sys_calculate_free_frames>
  800b3d:	89 45 c0             	mov    %eax,-0x40(%ebp)
	usedDiskPages = sys_pf_calculate_allocated_pages();
  800b40:	e8 a0 19 00 00       	call   8024e5 <sys_pf_calculate_allocated_pages>
  800b45:	89 45 bc             	mov    %eax,-0x44(%ebp)
	tempAddress = malloc(2*Mega - 4*kilo); 		// Use Hole 5 -> Hole 5 = 0
  800b48:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  800b4b:	01 c0                	add    %eax,%eax
  800b4d:	89 c2                	mov    %eax,%edx
  800b4f:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800b52:	29 d0                	sub    %edx,%eax
  800b54:	01 c0                	add    %eax,%eax
  800b56:	83 ec 0c             	sub    $0xc,%esp
  800b59:	50                   	push   %eax
  800b5a:	e8 da 14 00 00       	call   802039 <malloc>
  800b5f:	83 c4 10             	add    $0x10,%esp
  800b62:	89 45 b8             	mov    %eax,-0x48(%ebp)
	if((uint32)tempAddress != 0x99601000)
  800b65:	8b 45 b8             	mov    -0x48(%ebp),%eax
  800b68:	3d 00 10 60 99       	cmp    $0x99601000,%eax
  800b6d:	74 17                	je     800b86 <_main+0xb4e>
		panic("Worst Fit not working correctly");
  800b6f:	83 ec 04             	sub    $0x4,%esp
  800b72:	68 20 3e 80 00       	push   $0x803e20
  800b77:	68 d0 00 00 00       	push   $0xd0
  800b7c:	68 5c 3c 80 00       	push   $0x803c5c
  800b81:	e8 6d 02 00 00       	call   800df3 <_panic>
	if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  (2*Mega - 4*kilo)/PAGE_SIZE) panic("Wrong page file allocation: ");
  800b86:	e8 5a 19 00 00       	call   8024e5 <sys_pf_calculate_allocated_pages>
  800b8b:	2b 45 bc             	sub    -0x44(%ebp),%eax
  800b8e:	89 c2                	mov    %eax,%edx
  800b90:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  800b93:	01 c0                	add    %eax,%eax
  800b95:	89 c1                	mov    %eax,%ecx
  800b97:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800b9a:	29 c8                	sub    %ecx,%eax
  800b9c:	01 c0                	add    %eax,%eax
  800b9e:	85 c0                	test   %eax,%eax
  800ba0:	79 05                	jns    800ba7 <_main+0xb6f>
  800ba2:	05 ff 0f 00 00       	add    $0xfff,%eax
  800ba7:	c1 f8 0c             	sar    $0xc,%eax
  800baa:	39 c2                	cmp    %eax,%edx
  800bac:	74 17                	je     800bc5 <_main+0xb8d>
  800bae:	83 ec 04             	sub    $0x4,%esp
  800bb1:	68 76 3d 80 00       	push   $0x803d76
  800bb6:	68 d1 00 00 00       	push   $0xd1
  800bbb:	68 5c 3c 80 00       	push   $0x803c5c
  800bc0:	e8 2e 02 00 00       	call   800df3 <_panic>
	if ((freeFrames - sys_calculate_free_frames()) != 0) panic("Wrong allocation");
  800bc5:	e8 7b 18 00 00       	call   802445 <sys_calculate_free_frames>
  800bca:	89 c2                	mov    %eax,%edx
  800bcc:	8b 45 c0             	mov    -0x40(%ebp),%eax
  800bcf:	39 c2                	cmp    %eax,%edx
  800bd1:	74 17                	je     800bea <_main+0xbb2>
  800bd3:	83 ec 04             	sub    $0x4,%esp
  800bd6:	68 93 3d 80 00       	push   $0x803d93
  800bdb:	68 d2 00 00 00       	push   $0xd2
  800be0:	68 5c 3c 80 00       	push   $0x803c5c
  800be5:	e8 09 02 00 00       	call   800df3 <_panic>
	cprintf("Test %d Passed \n", ++count);
  800bea:	ff 45 d0             	incl   -0x30(%ebp)
  800bed:	83 ec 08             	sub    $0x8,%esp
  800bf0:	ff 75 d0             	pushl  -0x30(%ebp)
  800bf3:	68 40 3e 80 00       	push   $0x803e40
  800bf8:	e8 aa 04 00 00       	call   8010a7 <cprintf>
  800bfd:	83 c4 10             	add    $0x10,%esp

	// Check that worst fit returns null in case all holes are not free
	freeFrames = sys_calculate_free_frames() ;
  800c00:	e8 40 18 00 00       	call   802445 <sys_calculate_free_frames>
  800c05:	89 45 c0             	mov    %eax,-0x40(%ebp)
	usedDiskPages = sys_pf_calculate_allocated_pages();
  800c08:	e8 d8 18 00 00       	call   8024e5 <sys_pf_calculate_allocated_pages>
  800c0d:	89 45 bc             	mov    %eax,-0x44(%ebp)
	tempAddress = malloc(4*Mega); 		//No Suitable hole
  800c10:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800c13:	c1 e0 02             	shl    $0x2,%eax
  800c16:	83 ec 0c             	sub    $0xc,%esp
  800c19:	50                   	push   %eax
  800c1a:	e8 1a 14 00 00       	call   802039 <malloc>
  800c1f:	83 c4 10             	add    $0x10,%esp
  800c22:	89 45 b8             	mov    %eax,-0x48(%ebp)
	if((uint32)tempAddress != 0x0)
  800c25:	8b 45 b8             	mov    -0x48(%ebp),%eax
  800c28:	85 c0                	test   %eax,%eax
  800c2a:	74 17                	je     800c43 <_main+0xc0b>
		panic("Worst Fit not working correctly");
  800c2c:	83 ec 04             	sub    $0x4,%esp
  800c2f:	68 20 3e 80 00       	push   $0x803e20
  800c34:	68 da 00 00 00       	push   $0xda
  800c39:	68 5c 3c 80 00       	push   $0x803c5c
  800c3e:	e8 b0 01 00 00       	call   800df3 <_panic>
	if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  0) panic("Wrong page file allocation: ");
  800c43:	e8 9d 18 00 00       	call   8024e5 <sys_pf_calculate_allocated_pages>
  800c48:	3b 45 bc             	cmp    -0x44(%ebp),%eax
  800c4b:	74 17                	je     800c64 <_main+0xc2c>
  800c4d:	83 ec 04             	sub    $0x4,%esp
  800c50:	68 76 3d 80 00       	push   $0x803d76
  800c55:	68 db 00 00 00       	push   $0xdb
  800c5a:	68 5c 3c 80 00       	push   $0x803c5c
  800c5f:	e8 8f 01 00 00       	call   800df3 <_panic>
	if ((freeFrames - sys_calculate_free_frames()) != 0) panic("Wrong allocation");
  800c64:	e8 dc 17 00 00       	call   802445 <sys_calculate_free_frames>
  800c69:	89 c2                	mov    %eax,%edx
  800c6b:	8b 45 c0             	mov    -0x40(%ebp),%eax
  800c6e:	39 c2                	cmp    %eax,%edx
  800c70:	74 17                	je     800c89 <_main+0xc51>
  800c72:	83 ec 04             	sub    $0x4,%esp
  800c75:	68 93 3d 80 00       	push   $0x803d93
  800c7a:	68 dc 00 00 00       	push   $0xdc
  800c7f:	68 5c 3c 80 00       	push   $0x803c5c
  800c84:	e8 6a 01 00 00       	call   800df3 <_panic>
	cprintf("Test %d Passed \n", ++count);
  800c89:	ff 45 d0             	incl   -0x30(%ebp)
  800c8c:	83 ec 08             	sub    $0x8,%esp
  800c8f:	ff 75 d0             	pushl  -0x30(%ebp)
  800c92:	68 40 3e 80 00       	push   $0x803e40
  800c97:	e8 0b 04 00 00       	call   8010a7 <cprintf>
  800c9c:	83 c4 10             	add    $0x10,%esp

	cprintf("Congratulations!! test Worst Fit completed successfully.\n");
  800c9f:	83 ec 0c             	sub    $0xc,%esp
  800ca2:	68 54 3e 80 00       	push   $0x803e54
  800ca7:	e8 fb 03 00 00       	call   8010a7 <cprintf>
  800cac:	83 c4 10             	add    $0x10,%esp

	return;
  800caf:	90                   	nop
}
  800cb0:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800cb3:	5b                   	pop    %ebx
  800cb4:	5f                   	pop    %edi
  800cb5:	5d                   	pop    %ebp
  800cb6:	c3                   	ret    

00800cb7 <libmain>:
volatile struct Env *myEnv = NULL;
volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";

void
libmain(int argc, char **argv)
{
  800cb7:	55                   	push   %ebp
  800cb8:	89 e5                	mov    %esp,%ebp
  800cba:	83 ec 18             	sub    $0x18,%esp
	int envIndex = sys_getenvindex();
  800cbd:	e8 63 1a 00 00       	call   802725 <sys_getenvindex>
  800cc2:	89 45 f4             	mov    %eax,-0xc(%ebp)
	myEnv = &(envs[envIndex]);
  800cc5:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800cc8:	89 d0                	mov    %edx,%eax
  800cca:	c1 e0 03             	shl    $0x3,%eax
  800ccd:	01 d0                	add    %edx,%eax
  800ccf:	01 c0                	add    %eax,%eax
  800cd1:	01 d0                	add    %edx,%eax
  800cd3:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800cda:	01 d0                	add    %edx,%eax
  800cdc:	c1 e0 04             	shl    $0x4,%eax
  800cdf:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  800ce4:	a3 20 50 80 00       	mov    %eax,0x805020

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  800ce9:	a1 20 50 80 00       	mov    0x805020,%eax
  800cee:	8a 80 5c 05 00 00    	mov    0x55c(%eax),%al
  800cf4:	84 c0                	test   %al,%al
  800cf6:	74 0f                	je     800d07 <libmain+0x50>
		binaryname = myEnv->prog_name;
  800cf8:	a1 20 50 80 00       	mov    0x805020,%eax
  800cfd:	05 5c 05 00 00       	add    $0x55c,%eax
  800d02:	a3 00 50 80 00       	mov    %eax,0x805000

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800d07:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800d0b:	7e 0a                	jle    800d17 <libmain+0x60>
		binaryname = argv[0];
  800d0d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d10:	8b 00                	mov    (%eax),%eax
  800d12:	a3 00 50 80 00       	mov    %eax,0x805000

	// call user main routine
	_main(argc, argv);
  800d17:	83 ec 08             	sub    $0x8,%esp
  800d1a:	ff 75 0c             	pushl  0xc(%ebp)
  800d1d:	ff 75 08             	pushl  0x8(%ebp)
  800d20:	e8 13 f3 ff ff       	call   800038 <_main>
  800d25:	83 c4 10             	add    $0x10,%esp



	sys_disable_interrupt();
  800d28:	e8 05 18 00 00       	call   802532 <sys_disable_interrupt>
	cprintf("**************************************\n");
  800d2d:	83 ec 0c             	sub    $0xc,%esp
  800d30:	68 a8 3e 80 00       	push   $0x803ea8
  800d35:	e8 6d 03 00 00       	call   8010a7 <cprintf>
  800d3a:	83 c4 10             	add    $0x10,%esp
	cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  800d3d:	a1 20 50 80 00       	mov    0x805020,%eax
  800d42:	8b 90 44 05 00 00    	mov    0x544(%eax),%edx
  800d48:	a1 20 50 80 00       	mov    0x805020,%eax
  800d4d:	8b 80 34 05 00 00    	mov    0x534(%eax),%eax
  800d53:	83 ec 04             	sub    $0x4,%esp
  800d56:	52                   	push   %edx
  800d57:	50                   	push   %eax
  800d58:	68 d0 3e 80 00       	push   $0x803ed0
  800d5d:	e8 45 03 00 00       	call   8010a7 <cprintf>
  800d62:	83 c4 10             	add    $0x10,%esp
	cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  800d65:	a1 20 50 80 00       	mov    0x805020,%eax
  800d6a:	8b 88 54 05 00 00    	mov    0x554(%eax),%ecx
  800d70:	a1 20 50 80 00       	mov    0x805020,%eax
  800d75:	8b 90 50 05 00 00    	mov    0x550(%eax),%edx
  800d7b:	a1 20 50 80 00       	mov    0x805020,%eax
  800d80:	8b 80 4c 05 00 00    	mov    0x54c(%eax),%eax
  800d86:	51                   	push   %ecx
  800d87:	52                   	push   %edx
  800d88:	50                   	push   %eax
  800d89:	68 f8 3e 80 00       	push   $0x803ef8
  800d8e:	e8 14 03 00 00       	call   8010a7 <cprintf>
  800d93:	83 c4 10             	add    $0x10,%esp
	//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
	cprintf("Num of clocks = %d\n", myEnv->nClocks);
  800d96:	a1 20 50 80 00       	mov    0x805020,%eax
  800d9b:	8b 80 a4 05 00 00    	mov    0x5a4(%eax),%eax
  800da1:	83 ec 08             	sub    $0x8,%esp
  800da4:	50                   	push   %eax
  800da5:	68 50 3f 80 00       	push   $0x803f50
  800daa:	e8 f8 02 00 00       	call   8010a7 <cprintf>
  800daf:	83 c4 10             	add    $0x10,%esp
	cprintf("**************************************\n");
  800db2:	83 ec 0c             	sub    $0xc,%esp
  800db5:	68 a8 3e 80 00       	push   $0x803ea8
  800dba:	e8 e8 02 00 00       	call   8010a7 <cprintf>
  800dbf:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  800dc2:	e8 85 17 00 00       	call   80254c <sys_enable_interrupt>

	// exit gracefully
	exit();
  800dc7:	e8 19 00 00 00       	call   800de5 <exit>
}
  800dcc:	90                   	nop
  800dcd:	c9                   	leave  
  800dce:	c3                   	ret    

00800dcf <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  800dcf:	55                   	push   %ebp
  800dd0:	89 e5                	mov    %esp,%ebp
  800dd2:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  800dd5:	83 ec 0c             	sub    $0xc,%esp
  800dd8:	6a 00                	push   $0x0
  800dda:	e8 12 19 00 00       	call   8026f1 <sys_destroy_env>
  800ddf:	83 c4 10             	add    $0x10,%esp
}
  800de2:	90                   	nop
  800de3:	c9                   	leave  
  800de4:	c3                   	ret    

00800de5 <exit>:

void
exit(void)
{
  800de5:	55                   	push   %ebp
  800de6:	89 e5                	mov    %esp,%ebp
  800de8:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  800deb:	e8 67 19 00 00       	call   802757 <sys_exit_env>
}
  800df0:	90                   	nop
  800df1:	c9                   	leave  
  800df2:	c3                   	ret    

00800df3 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  800df3:	55                   	push   %ebp
  800df4:	89 e5                	mov    %esp,%ebp
  800df6:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  800df9:	8d 45 10             	lea    0x10(%ebp),%eax
  800dfc:	83 c0 04             	add    $0x4,%eax
  800dff:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  800e02:	a1 5c 51 80 00       	mov    0x80515c,%eax
  800e07:	85 c0                	test   %eax,%eax
  800e09:	74 16                	je     800e21 <_panic+0x2e>
		cprintf("%s: ", argv0);
  800e0b:	a1 5c 51 80 00       	mov    0x80515c,%eax
  800e10:	83 ec 08             	sub    $0x8,%esp
  800e13:	50                   	push   %eax
  800e14:	68 64 3f 80 00       	push   $0x803f64
  800e19:	e8 89 02 00 00       	call   8010a7 <cprintf>
  800e1e:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  800e21:	a1 00 50 80 00       	mov    0x805000,%eax
  800e26:	ff 75 0c             	pushl  0xc(%ebp)
  800e29:	ff 75 08             	pushl  0x8(%ebp)
  800e2c:	50                   	push   %eax
  800e2d:	68 69 3f 80 00       	push   $0x803f69
  800e32:	e8 70 02 00 00       	call   8010a7 <cprintf>
  800e37:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  800e3a:	8b 45 10             	mov    0x10(%ebp),%eax
  800e3d:	83 ec 08             	sub    $0x8,%esp
  800e40:	ff 75 f4             	pushl  -0xc(%ebp)
  800e43:	50                   	push   %eax
  800e44:	e8 f3 01 00 00       	call   80103c <vcprintf>
  800e49:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  800e4c:	83 ec 08             	sub    $0x8,%esp
  800e4f:	6a 00                	push   $0x0
  800e51:	68 85 3f 80 00       	push   $0x803f85
  800e56:	e8 e1 01 00 00       	call   80103c <vcprintf>
  800e5b:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  800e5e:	e8 82 ff ff ff       	call   800de5 <exit>

	// should not return here
	while (1) ;
  800e63:	eb fe                	jmp    800e63 <_panic+0x70>

00800e65 <CheckWSWithoutLastIndex>:
}

void CheckWSWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  800e65:	55                   	push   %ebp
  800e66:	89 e5                	mov    %esp,%ebp
  800e68:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  800e6b:	a1 20 50 80 00       	mov    0x805020,%eax
  800e70:	8b 50 74             	mov    0x74(%eax),%edx
  800e73:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e76:	39 c2                	cmp    %eax,%edx
  800e78:	74 14                	je     800e8e <CheckWSWithoutLastIndex+0x29>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  800e7a:	83 ec 04             	sub    $0x4,%esp
  800e7d:	68 88 3f 80 00       	push   $0x803f88
  800e82:	6a 26                	push   $0x26
  800e84:	68 d4 3f 80 00       	push   $0x803fd4
  800e89:	e8 65 ff ff ff       	call   800df3 <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  800e8e:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  800e95:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800e9c:	e9 c2 00 00 00       	jmp    800f63 <CheckWSWithoutLastIndex+0xfe>
		if (expectedPages[e] == 0) {
  800ea1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800ea4:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800eab:	8b 45 08             	mov    0x8(%ebp),%eax
  800eae:	01 d0                	add    %edx,%eax
  800eb0:	8b 00                	mov    (%eax),%eax
  800eb2:	85 c0                	test   %eax,%eax
  800eb4:	75 08                	jne    800ebe <CheckWSWithoutLastIndex+0x59>
			expectedNumOfEmptyLocs++;
  800eb6:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  800eb9:	e9 a2 00 00 00       	jmp    800f60 <CheckWSWithoutLastIndex+0xfb>
		}
		int found = 0;
  800ebe:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800ec5:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  800ecc:	eb 69                	jmp    800f37 <CheckWSWithoutLastIndex+0xd2>
			if (myEnv->__uptr_pws[w].empty == 0) {
  800ece:	a1 20 50 80 00       	mov    0x805020,%eax
  800ed3:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  800ed9:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800edc:	89 d0                	mov    %edx,%eax
  800ede:	01 c0                	add    %eax,%eax
  800ee0:	01 d0                	add    %edx,%eax
  800ee2:	c1 e0 03             	shl    $0x3,%eax
  800ee5:	01 c8                	add    %ecx,%eax
  800ee7:	8a 40 04             	mov    0x4(%eax),%al
  800eea:	84 c0                	test   %al,%al
  800eec:	75 46                	jne    800f34 <CheckWSWithoutLastIndex+0xcf>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  800eee:	a1 20 50 80 00       	mov    0x805020,%eax
  800ef3:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  800ef9:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800efc:	89 d0                	mov    %edx,%eax
  800efe:	01 c0                	add    %eax,%eax
  800f00:	01 d0                	add    %edx,%eax
  800f02:	c1 e0 03             	shl    $0x3,%eax
  800f05:	01 c8                	add    %ecx,%eax
  800f07:	8b 00                	mov    (%eax),%eax
  800f09:	89 45 dc             	mov    %eax,-0x24(%ebp)
  800f0c:	8b 45 dc             	mov    -0x24(%ebp),%eax
  800f0f:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800f14:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  800f16:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800f19:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  800f20:	8b 45 08             	mov    0x8(%ebp),%eax
  800f23:	01 c8                	add    %ecx,%eax
  800f25:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  800f27:	39 c2                	cmp    %eax,%edx
  800f29:	75 09                	jne    800f34 <CheckWSWithoutLastIndex+0xcf>
						== expectedPages[e]) {
					found = 1;
  800f2b:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  800f32:	eb 12                	jmp    800f46 <CheckWSWithoutLastIndex+0xe1>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800f34:	ff 45 e8             	incl   -0x18(%ebp)
  800f37:	a1 20 50 80 00       	mov    0x805020,%eax
  800f3c:	8b 50 74             	mov    0x74(%eax),%edx
  800f3f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800f42:	39 c2                	cmp    %eax,%edx
  800f44:	77 88                	ja     800ece <CheckWSWithoutLastIndex+0x69>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  800f46:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  800f4a:	75 14                	jne    800f60 <CheckWSWithoutLastIndex+0xfb>
			panic(
  800f4c:	83 ec 04             	sub    $0x4,%esp
  800f4f:	68 e0 3f 80 00       	push   $0x803fe0
  800f54:	6a 3a                	push   $0x3a
  800f56:	68 d4 3f 80 00       	push   $0x803fd4
  800f5b:	e8 93 fe ff ff       	call   800df3 <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  800f60:	ff 45 f0             	incl   -0x10(%ebp)
  800f63:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800f66:	3b 45 0c             	cmp    0xc(%ebp),%eax
  800f69:	0f 8c 32 ff ff ff    	jl     800ea1 <CheckWSWithoutLastIndex+0x3c>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  800f6f:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800f76:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  800f7d:	eb 26                	jmp    800fa5 <CheckWSWithoutLastIndex+0x140>
		if (myEnv->__uptr_pws[w].empty == 1) {
  800f7f:	a1 20 50 80 00       	mov    0x805020,%eax
  800f84:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  800f8a:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800f8d:	89 d0                	mov    %edx,%eax
  800f8f:	01 c0                	add    %eax,%eax
  800f91:	01 d0                	add    %edx,%eax
  800f93:	c1 e0 03             	shl    $0x3,%eax
  800f96:	01 c8                	add    %ecx,%eax
  800f98:	8a 40 04             	mov    0x4(%eax),%al
  800f9b:	3c 01                	cmp    $0x1,%al
  800f9d:	75 03                	jne    800fa2 <CheckWSWithoutLastIndex+0x13d>
			actualNumOfEmptyLocs++;
  800f9f:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800fa2:	ff 45 e0             	incl   -0x20(%ebp)
  800fa5:	a1 20 50 80 00       	mov    0x805020,%eax
  800faa:	8b 50 74             	mov    0x74(%eax),%edx
  800fad:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800fb0:	39 c2                	cmp    %eax,%edx
  800fb2:	77 cb                	ja     800f7f <CheckWSWithoutLastIndex+0x11a>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  800fb4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800fb7:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  800fba:	74 14                	je     800fd0 <CheckWSWithoutLastIndex+0x16b>
		panic(
  800fbc:	83 ec 04             	sub    $0x4,%esp
  800fbf:	68 34 40 80 00       	push   $0x804034
  800fc4:	6a 44                	push   $0x44
  800fc6:	68 d4 3f 80 00       	push   $0x803fd4
  800fcb:	e8 23 fe ff ff       	call   800df3 <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  800fd0:	90                   	nop
  800fd1:	c9                   	leave  
  800fd2:	c3                   	ret    

00800fd3 <putch>:
};

//2017:
uint8 printProgName = 0;

static void putch(int ch, struct printbuf *b) {
  800fd3:	55                   	push   %ebp
  800fd4:	89 e5                	mov    %esp,%ebp
  800fd6:	83 ec 08             	sub    $0x8,%esp
	b->buf[b->idx++] = ch;
  800fd9:	8b 45 0c             	mov    0xc(%ebp),%eax
  800fdc:	8b 00                	mov    (%eax),%eax
  800fde:	8d 48 01             	lea    0x1(%eax),%ecx
  800fe1:	8b 55 0c             	mov    0xc(%ebp),%edx
  800fe4:	89 0a                	mov    %ecx,(%edx)
  800fe6:	8b 55 08             	mov    0x8(%ebp),%edx
  800fe9:	88 d1                	mov    %dl,%cl
  800feb:	8b 55 0c             	mov    0xc(%ebp),%edx
  800fee:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  800ff2:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ff5:	8b 00                	mov    (%eax),%eax
  800ff7:	3d ff 00 00 00       	cmp    $0xff,%eax
  800ffc:	75 2c                	jne    80102a <putch+0x57>
		sys_cputs(b->buf, b->idx, printProgName);
  800ffe:	a0 24 50 80 00       	mov    0x805024,%al
  801003:	0f b6 c0             	movzbl %al,%eax
  801006:	8b 55 0c             	mov    0xc(%ebp),%edx
  801009:	8b 12                	mov    (%edx),%edx
  80100b:	89 d1                	mov    %edx,%ecx
  80100d:	8b 55 0c             	mov    0xc(%ebp),%edx
  801010:	83 c2 08             	add    $0x8,%edx
  801013:	83 ec 04             	sub    $0x4,%esp
  801016:	50                   	push   %eax
  801017:	51                   	push   %ecx
  801018:	52                   	push   %edx
  801019:	e8 66 13 00 00       	call   802384 <sys_cputs>
  80101e:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  801021:	8b 45 0c             	mov    0xc(%ebp),%eax
  801024:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  80102a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80102d:	8b 40 04             	mov    0x4(%eax),%eax
  801030:	8d 50 01             	lea    0x1(%eax),%edx
  801033:	8b 45 0c             	mov    0xc(%ebp),%eax
  801036:	89 50 04             	mov    %edx,0x4(%eax)
}
  801039:	90                   	nop
  80103a:	c9                   	leave  
  80103b:	c3                   	ret    

0080103c <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  80103c:	55                   	push   %ebp
  80103d:	89 e5                	mov    %esp,%ebp
  80103f:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  801045:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  80104c:	00 00 00 
	b.cnt = 0;
  80104f:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  801056:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  801059:	ff 75 0c             	pushl  0xc(%ebp)
  80105c:	ff 75 08             	pushl  0x8(%ebp)
  80105f:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  801065:	50                   	push   %eax
  801066:	68 d3 0f 80 00       	push   $0x800fd3
  80106b:	e8 11 02 00 00       	call   801281 <vprintfmt>
  801070:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName);
  801073:	a0 24 50 80 00       	mov    0x805024,%al
  801078:	0f b6 c0             	movzbl %al,%eax
  80107b:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  801081:	83 ec 04             	sub    $0x4,%esp
  801084:	50                   	push   %eax
  801085:	52                   	push   %edx
  801086:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  80108c:	83 c0 08             	add    $0x8,%eax
  80108f:	50                   	push   %eax
  801090:	e8 ef 12 00 00       	call   802384 <sys_cputs>
  801095:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  801098:	c6 05 24 50 80 00 00 	movb   $0x0,0x805024
	return b.cnt;
  80109f:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  8010a5:	c9                   	leave  
  8010a6:	c3                   	ret    

008010a7 <cprintf>:

int cprintf(const char *fmt, ...) {
  8010a7:	55                   	push   %ebp
  8010a8:	89 e5                	mov    %esp,%ebp
  8010aa:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  8010ad:	c6 05 24 50 80 00 01 	movb   $0x1,0x805024
	va_start(ap, fmt);
  8010b4:	8d 45 0c             	lea    0xc(%ebp),%eax
  8010b7:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  8010ba:	8b 45 08             	mov    0x8(%ebp),%eax
  8010bd:	83 ec 08             	sub    $0x8,%esp
  8010c0:	ff 75 f4             	pushl  -0xc(%ebp)
  8010c3:	50                   	push   %eax
  8010c4:	e8 73 ff ff ff       	call   80103c <vcprintf>
  8010c9:	83 c4 10             	add    $0x10,%esp
  8010cc:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  8010cf:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8010d2:	c9                   	leave  
  8010d3:	c3                   	ret    

008010d4 <atomic_cprintf>:

int atomic_cprintf(const char *fmt, ...) {
  8010d4:	55                   	push   %ebp
  8010d5:	89 e5                	mov    %esp,%ebp
  8010d7:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  8010da:	e8 53 14 00 00       	call   802532 <sys_disable_interrupt>
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  8010df:	8d 45 0c             	lea    0xc(%ebp),%eax
  8010e2:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  8010e5:	8b 45 08             	mov    0x8(%ebp),%eax
  8010e8:	83 ec 08             	sub    $0x8,%esp
  8010eb:	ff 75 f4             	pushl  -0xc(%ebp)
  8010ee:	50                   	push   %eax
  8010ef:	e8 48 ff ff ff       	call   80103c <vcprintf>
  8010f4:	83 c4 10             	add    $0x10,%esp
  8010f7:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	sys_enable_interrupt();
  8010fa:	e8 4d 14 00 00       	call   80254c <sys_enable_interrupt>
	return cnt;
  8010ff:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801102:	c9                   	leave  
  801103:	c3                   	ret    

00801104 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  801104:	55                   	push   %ebp
  801105:	89 e5                	mov    %esp,%ebp
  801107:	53                   	push   %ebx
  801108:	83 ec 14             	sub    $0x14,%esp
  80110b:	8b 45 10             	mov    0x10(%ebp),%eax
  80110e:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801111:	8b 45 14             	mov    0x14(%ebp),%eax
  801114:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  801117:	8b 45 18             	mov    0x18(%ebp),%eax
  80111a:	ba 00 00 00 00       	mov    $0x0,%edx
  80111f:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  801122:	77 55                	ja     801179 <printnum+0x75>
  801124:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  801127:	72 05                	jb     80112e <printnum+0x2a>
  801129:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80112c:	77 4b                	ja     801179 <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  80112e:	8b 45 1c             	mov    0x1c(%ebp),%eax
  801131:	8d 58 ff             	lea    -0x1(%eax),%ebx
  801134:	8b 45 18             	mov    0x18(%ebp),%eax
  801137:	ba 00 00 00 00       	mov    $0x0,%edx
  80113c:	52                   	push   %edx
  80113d:	50                   	push   %eax
  80113e:	ff 75 f4             	pushl  -0xc(%ebp)
  801141:	ff 75 f0             	pushl  -0x10(%ebp)
  801144:	e8 87 28 00 00       	call   8039d0 <__udivdi3>
  801149:	83 c4 10             	add    $0x10,%esp
  80114c:	83 ec 04             	sub    $0x4,%esp
  80114f:	ff 75 20             	pushl  0x20(%ebp)
  801152:	53                   	push   %ebx
  801153:	ff 75 18             	pushl  0x18(%ebp)
  801156:	52                   	push   %edx
  801157:	50                   	push   %eax
  801158:	ff 75 0c             	pushl  0xc(%ebp)
  80115b:	ff 75 08             	pushl  0x8(%ebp)
  80115e:	e8 a1 ff ff ff       	call   801104 <printnum>
  801163:	83 c4 20             	add    $0x20,%esp
  801166:	eb 1a                	jmp    801182 <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  801168:	83 ec 08             	sub    $0x8,%esp
  80116b:	ff 75 0c             	pushl  0xc(%ebp)
  80116e:	ff 75 20             	pushl  0x20(%ebp)
  801171:	8b 45 08             	mov    0x8(%ebp),%eax
  801174:	ff d0                	call   *%eax
  801176:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  801179:	ff 4d 1c             	decl   0x1c(%ebp)
  80117c:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  801180:	7f e6                	jg     801168 <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  801182:	8b 4d 18             	mov    0x18(%ebp),%ecx
  801185:	bb 00 00 00 00       	mov    $0x0,%ebx
  80118a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80118d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801190:	53                   	push   %ebx
  801191:	51                   	push   %ecx
  801192:	52                   	push   %edx
  801193:	50                   	push   %eax
  801194:	e8 47 29 00 00       	call   803ae0 <__umoddi3>
  801199:	83 c4 10             	add    $0x10,%esp
  80119c:	05 94 42 80 00       	add    $0x804294,%eax
  8011a1:	8a 00                	mov    (%eax),%al
  8011a3:	0f be c0             	movsbl %al,%eax
  8011a6:	83 ec 08             	sub    $0x8,%esp
  8011a9:	ff 75 0c             	pushl  0xc(%ebp)
  8011ac:	50                   	push   %eax
  8011ad:	8b 45 08             	mov    0x8(%ebp),%eax
  8011b0:	ff d0                	call   *%eax
  8011b2:	83 c4 10             	add    $0x10,%esp
}
  8011b5:	90                   	nop
  8011b6:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8011b9:	c9                   	leave  
  8011ba:	c3                   	ret    

008011bb <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  8011bb:	55                   	push   %ebp
  8011bc:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  8011be:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  8011c2:	7e 1c                	jle    8011e0 <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  8011c4:	8b 45 08             	mov    0x8(%ebp),%eax
  8011c7:	8b 00                	mov    (%eax),%eax
  8011c9:	8d 50 08             	lea    0x8(%eax),%edx
  8011cc:	8b 45 08             	mov    0x8(%ebp),%eax
  8011cf:	89 10                	mov    %edx,(%eax)
  8011d1:	8b 45 08             	mov    0x8(%ebp),%eax
  8011d4:	8b 00                	mov    (%eax),%eax
  8011d6:	83 e8 08             	sub    $0x8,%eax
  8011d9:	8b 50 04             	mov    0x4(%eax),%edx
  8011dc:	8b 00                	mov    (%eax),%eax
  8011de:	eb 40                	jmp    801220 <getuint+0x65>
	else if (lflag)
  8011e0:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8011e4:	74 1e                	je     801204 <getuint+0x49>
		return va_arg(*ap, unsigned long);
  8011e6:	8b 45 08             	mov    0x8(%ebp),%eax
  8011e9:	8b 00                	mov    (%eax),%eax
  8011eb:	8d 50 04             	lea    0x4(%eax),%edx
  8011ee:	8b 45 08             	mov    0x8(%ebp),%eax
  8011f1:	89 10                	mov    %edx,(%eax)
  8011f3:	8b 45 08             	mov    0x8(%ebp),%eax
  8011f6:	8b 00                	mov    (%eax),%eax
  8011f8:	83 e8 04             	sub    $0x4,%eax
  8011fb:	8b 00                	mov    (%eax),%eax
  8011fd:	ba 00 00 00 00       	mov    $0x0,%edx
  801202:	eb 1c                	jmp    801220 <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  801204:	8b 45 08             	mov    0x8(%ebp),%eax
  801207:	8b 00                	mov    (%eax),%eax
  801209:	8d 50 04             	lea    0x4(%eax),%edx
  80120c:	8b 45 08             	mov    0x8(%ebp),%eax
  80120f:	89 10                	mov    %edx,(%eax)
  801211:	8b 45 08             	mov    0x8(%ebp),%eax
  801214:	8b 00                	mov    (%eax),%eax
  801216:	83 e8 04             	sub    $0x4,%eax
  801219:	8b 00                	mov    (%eax),%eax
  80121b:	ba 00 00 00 00       	mov    $0x0,%edx
}
  801220:	5d                   	pop    %ebp
  801221:	c3                   	ret    

00801222 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  801222:	55                   	push   %ebp
  801223:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  801225:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  801229:	7e 1c                	jle    801247 <getint+0x25>
		return va_arg(*ap, long long);
  80122b:	8b 45 08             	mov    0x8(%ebp),%eax
  80122e:	8b 00                	mov    (%eax),%eax
  801230:	8d 50 08             	lea    0x8(%eax),%edx
  801233:	8b 45 08             	mov    0x8(%ebp),%eax
  801236:	89 10                	mov    %edx,(%eax)
  801238:	8b 45 08             	mov    0x8(%ebp),%eax
  80123b:	8b 00                	mov    (%eax),%eax
  80123d:	83 e8 08             	sub    $0x8,%eax
  801240:	8b 50 04             	mov    0x4(%eax),%edx
  801243:	8b 00                	mov    (%eax),%eax
  801245:	eb 38                	jmp    80127f <getint+0x5d>
	else if (lflag)
  801247:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80124b:	74 1a                	je     801267 <getint+0x45>
		return va_arg(*ap, long);
  80124d:	8b 45 08             	mov    0x8(%ebp),%eax
  801250:	8b 00                	mov    (%eax),%eax
  801252:	8d 50 04             	lea    0x4(%eax),%edx
  801255:	8b 45 08             	mov    0x8(%ebp),%eax
  801258:	89 10                	mov    %edx,(%eax)
  80125a:	8b 45 08             	mov    0x8(%ebp),%eax
  80125d:	8b 00                	mov    (%eax),%eax
  80125f:	83 e8 04             	sub    $0x4,%eax
  801262:	8b 00                	mov    (%eax),%eax
  801264:	99                   	cltd   
  801265:	eb 18                	jmp    80127f <getint+0x5d>
	else
		return va_arg(*ap, int);
  801267:	8b 45 08             	mov    0x8(%ebp),%eax
  80126a:	8b 00                	mov    (%eax),%eax
  80126c:	8d 50 04             	lea    0x4(%eax),%edx
  80126f:	8b 45 08             	mov    0x8(%ebp),%eax
  801272:	89 10                	mov    %edx,(%eax)
  801274:	8b 45 08             	mov    0x8(%ebp),%eax
  801277:	8b 00                	mov    (%eax),%eax
  801279:	83 e8 04             	sub    $0x4,%eax
  80127c:	8b 00                	mov    (%eax),%eax
  80127e:	99                   	cltd   
}
  80127f:	5d                   	pop    %ebp
  801280:	c3                   	ret    

00801281 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  801281:	55                   	push   %ebp
  801282:	89 e5                	mov    %esp,%ebp
  801284:	56                   	push   %esi
  801285:	53                   	push   %ebx
  801286:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  801289:	eb 17                	jmp    8012a2 <vprintfmt+0x21>
			if (ch == '\0')
  80128b:	85 db                	test   %ebx,%ebx
  80128d:	0f 84 af 03 00 00    	je     801642 <vprintfmt+0x3c1>
				return;
			putch(ch, putdat);
  801293:	83 ec 08             	sub    $0x8,%esp
  801296:	ff 75 0c             	pushl  0xc(%ebp)
  801299:	53                   	push   %ebx
  80129a:	8b 45 08             	mov    0x8(%ebp),%eax
  80129d:	ff d0                	call   *%eax
  80129f:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8012a2:	8b 45 10             	mov    0x10(%ebp),%eax
  8012a5:	8d 50 01             	lea    0x1(%eax),%edx
  8012a8:	89 55 10             	mov    %edx,0x10(%ebp)
  8012ab:	8a 00                	mov    (%eax),%al
  8012ad:	0f b6 d8             	movzbl %al,%ebx
  8012b0:	83 fb 25             	cmp    $0x25,%ebx
  8012b3:	75 d6                	jne    80128b <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  8012b5:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  8012b9:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  8012c0:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  8012c7:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  8012ce:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8012d5:	8b 45 10             	mov    0x10(%ebp),%eax
  8012d8:	8d 50 01             	lea    0x1(%eax),%edx
  8012db:	89 55 10             	mov    %edx,0x10(%ebp)
  8012de:	8a 00                	mov    (%eax),%al
  8012e0:	0f b6 d8             	movzbl %al,%ebx
  8012e3:	8d 43 dd             	lea    -0x23(%ebx),%eax
  8012e6:	83 f8 55             	cmp    $0x55,%eax
  8012e9:	0f 87 2b 03 00 00    	ja     80161a <vprintfmt+0x399>
  8012ef:	8b 04 85 b8 42 80 00 	mov    0x8042b8(,%eax,4),%eax
  8012f6:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  8012f8:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  8012fc:	eb d7                	jmp    8012d5 <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  8012fe:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  801302:	eb d1                	jmp    8012d5 <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  801304:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  80130b:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80130e:	89 d0                	mov    %edx,%eax
  801310:	c1 e0 02             	shl    $0x2,%eax
  801313:	01 d0                	add    %edx,%eax
  801315:	01 c0                	add    %eax,%eax
  801317:	01 d8                	add    %ebx,%eax
  801319:	83 e8 30             	sub    $0x30,%eax
  80131c:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  80131f:	8b 45 10             	mov    0x10(%ebp),%eax
  801322:	8a 00                	mov    (%eax),%al
  801324:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  801327:	83 fb 2f             	cmp    $0x2f,%ebx
  80132a:	7e 3e                	jle    80136a <vprintfmt+0xe9>
  80132c:	83 fb 39             	cmp    $0x39,%ebx
  80132f:	7f 39                	jg     80136a <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  801331:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  801334:	eb d5                	jmp    80130b <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  801336:	8b 45 14             	mov    0x14(%ebp),%eax
  801339:	83 c0 04             	add    $0x4,%eax
  80133c:	89 45 14             	mov    %eax,0x14(%ebp)
  80133f:	8b 45 14             	mov    0x14(%ebp),%eax
  801342:	83 e8 04             	sub    $0x4,%eax
  801345:	8b 00                	mov    (%eax),%eax
  801347:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  80134a:	eb 1f                	jmp    80136b <vprintfmt+0xea>

		case '.':
			if (width < 0)
  80134c:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  801350:	79 83                	jns    8012d5 <vprintfmt+0x54>
				width = 0;
  801352:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  801359:	e9 77 ff ff ff       	jmp    8012d5 <vprintfmt+0x54>

		case '#':
			altflag = 1;
  80135e:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  801365:	e9 6b ff ff ff       	jmp    8012d5 <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  80136a:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  80136b:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80136f:	0f 89 60 ff ff ff    	jns    8012d5 <vprintfmt+0x54>
				width = precision, precision = -1;
  801375:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801378:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  80137b:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  801382:	e9 4e ff ff ff       	jmp    8012d5 <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  801387:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  80138a:	e9 46 ff ff ff       	jmp    8012d5 <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  80138f:	8b 45 14             	mov    0x14(%ebp),%eax
  801392:	83 c0 04             	add    $0x4,%eax
  801395:	89 45 14             	mov    %eax,0x14(%ebp)
  801398:	8b 45 14             	mov    0x14(%ebp),%eax
  80139b:	83 e8 04             	sub    $0x4,%eax
  80139e:	8b 00                	mov    (%eax),%eax
  8013a0:	83 ec 08             	sub    $0x8,%esp
  8013a3:	ff 75 0c             	pushl  0xc(%ebp)
  8013a6:	50                   	push   %eax
  8013a7:	8b 45 08             	mov    0x8(%ebp),%eax
  8013aa:	ff d0                	call   *%eax
  8013ac:	83 c4 10             	add    $0x10,%esp
			break;
  8013af:	e9 89 02 00 00       	jmp    80163d <vprintfmt+0x3bc>

		// error message
		case 'e':
			err = va_arg(ap, int);
  8013b4:	8b 45 14             	mov    0x14(%ebp),%eax
  8013b7:	83 c0 04             	add    $0x4,%eax
  8013ba:	89 45 14             	mov    %eax,0x14(%ebp)
  8013bd:	8b 45 14             	mov    0x14(%ebp),%eax
  8013c0:	83 e8 04             	sub    $0x4,%eax
  8013c3:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  8013c5:	85 db                	test   %ebx,%ebx
  8013c7:	79 02                	jns    8013cb <vprintfmt+0x14a>
				err = -err;
  8013c9:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  8013cb:	83 fb 64             	cmp    $0x64,%ebx
  8013ce:	7f 0b                	jg     8013db <vprintfmt+0x15a>
  8013d0:	8b 34 9d 00 41 80 00 	mov    0x804100(,%ebx,4),%esi
  8013d7:	85 f6                	test   %esi,%esi
  8013d9:	75 19                	jne    8013f4 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  8013db:	53                   	push   %ebx
  8013dc:	68 a5 42 80 00       	push   $0x8042a5
  8013e1:	ff 75 0c             	pushl  0xc(%ebp)
  8013e4:	ff 75 08             	pushl  0x8(%ebp)
  8013e7:	e8 5e 02 00 00       	call   80164a <printfmt>
  8013ec:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  8013ef:	e9 49 02 00 00       	jmp    80163d <vprintfmt+0x3bc>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  8013f4:	56                   	push   %esi
  8013f5:	68 ae 42 80 00       	push   $0x8042ae
  8013fa:	ff 75 0c             	pushl  0xc(%ebp)
  8013fd:	ff 75 08             	pushl  0x8(%ebp)
  801400:	e8 45 02 00 00       	call   80164a <printfmt>
  801405:	83 c4 10             	add    $0x10,%esp
			break;
  801408:	e9 30 02 00 00       	jmp    80163d <vprintfmt+0x3bc>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  80140d:	8b 45 14             	mov    0x14(%ebp),%eax
  801410:	83 c0 04             	add    $0x4,%eax
  801413:	89 45 14             	mov    %eax,0x14(%ebp)
  801416:	8b 45 14             	mov    0x14(%ebp),%eax
  801419:	83 e8 04             	sub    $0x4,%eax
  80141c:	8b 30                	mov    (%eax),%esi
  80141e:	85 f6                	test   %esi,%esi
  801420:	75 05                	jne    801427 <vprintfmt+0x1a6>
				p = "(null)";
  801422:	be b1 42 80 00       	mov    $0x8042b1,%esi
			if (width > 0 && padc != '-')
  801427:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80142b:	7e 6d                	jle    80149a <vprintfmt+0x219>
  80142d:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  801431:	74 67                	je     80149a <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  801433:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801436:	83 ec 08             	sub    $0x8,%esp
  801439:	50                   	push   %eax
  80143a:	56                   	push   %esi
  80143b:	e8 0c 03 00 00       	call   80174c <strnlen>
  801440:	83 c4 10             	add    $0x10,%esp
  801443:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  801446:	eb 16                	jmp    80145e <vprintfmt+0x1dd>
					putch(padc, putdat);
  801448:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  80144c:	83 ec 08             	sub    $0x8,%esp
  80144f:	ff 75 0c             	pushl  0xc(%ebp)
  801452:	50                   	push   %eax
  801453:	8b 45 08             	mov    0x8(%ebp),%eax
  801456:	ff d0                	call   *%eax
  801458:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  80145b:	ff 4d e4             	decl   -0x1c(%ebp)
  80145e:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  801462:	7f e4                	jg     801448 <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  801464:	eb 34                	jmp    80149a <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  801466:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  80146a:	74 1c                	je     801488 <vprintfmt+0x207>
  80146c:	83 fb 1f             	cmp    $0x1f,%ebx
  80146f:	7e 05                	jle    801476 <vprintfmt+0x1f5>
  801471:	83 fb 7e             	cmp    $0x7e,%ebx
  801474:	7e 12                	jle    801488 <vprintfmt+0x207>
					putch('?', putdat);
  801476:	83 ec 08             	sub    $0x8,%esp
  801479:	ff 75 0c             	pushl  0xc(%ebp)
  80147c:	6a 3f                	push   $0x3f
  80147e:	8b 45 08             	mov    0x8(%ebp),%eax
  801481:	ff d0                	call   *%eax
  801483:	83 c4 10             	add    $0x10,%esp
  801486:	eb 0f                	jmp    801497 <vprintfmt+0x216>
				else
					putch(ch, putdat);
  801488:	83 ec 08             	sub    $0x8,%esp
  80148b:	ff 75 0c             	pushl  0xc(%ebp)
  80148e:	53                   	push   %ebx
  80148f:	8b 45 08             	mov    0x8(%ebp),%eax
  801492:	ff d0                	call   *%eax
  801494:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  801497:	ff 4d e4             	decl   -0x1c(%ebp)
  80149a:	89 f0                	mov    %esi,%eax
  80149c:	8d 70 01             	lea    0x1(%eax),%esi
  80149f:	8a 00                	mov    (%eax),%al
  8014a1:	0f be d8             	movsbl %al,%ebx
  8014a4:	85 db                	test   %ebx,%ebx
  8014a6:	74 24                	je     8014cc <vprintfmt+0x24b>
  8014a8:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8014ac:	78 b8                	js     801466 <vprintfmt+0x1e5>
  8014ae:	ff 4d e0             	decl   -0x20(%ebp)
  8014b1:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8014b5:	79 af                	jns    801466 <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  8014b7:	eb 13                	jmp    8014cc <vprintfmt+0x24b>
				putch(' ', putdat);
  8014b9:	83 ec 08             	sub    $0x8,%esp
  8014bc:	ff 75 0c             	pushl  0xc(%ebp)
  8014bf:	6a 20                	push   $0x20
  8014c1:	8b 45 08             	mov    0x8(%ebp),%eax
  8014c4:	ff d0                	call   *%eax
  8014c6:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  8014c9:	ff 4d e4             	decl   -0x1c(%ebp)
  8014cc:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8014d0:	7f e7                	jg     8014b9 <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  8014d2:	e9 66 01 00 00       	jmp    80163d <vprintfmt+0x3bc>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  8014d7:	83 ec 08             	sub    $0x8,%esp
  8014da:	ff 75 e8             	pushl  -0x18(%ebp)
  8014dd:	8d 45 14             	lea    0x14(%ebp),%eax
  8014e0:	50                   	push   %eax
  8014e1:	e8 3c fd ff ff       	call   801222 <getint>
  8014e6:	83 c4 10             	add    $0x10,%esp
  8014e9:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8014ec:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  8014ef:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8014f2:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8014f5:	85 d2                	test   %edx,%edx
  8014f7:	79 23                	jns    80151c <vprintfmt+0x29b>
				putch('-', putdat);
  8014f9:	83 ec 08             	sub    $0x8,%esp
  8014fc:	ff 75 0c             	pushl  0xc(%ebp)
  8014ff:	6a 2d                	push   $0x2d
  801501:	8b 45 08             	mov    0x8(%ebp),%eax
  801504:	ff d0                	call   *%eax
  801506:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  801509:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80150c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80150f:	f7 d8                	neg    %eax
  801511:	83 d2 00             	adc    $0x0,%edx
  801514:	f7 da                	neg    %edx
  801516:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801519:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  80151c:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  801523:	e9 bc 00 00 00       	jmp    8015e4 <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  801528:	83 ec 08             	sub    $0x8,%esp
  80152b:	ff 75 e8             	pushl  -0x18(%ebp)
  80152e:	8d 45 14             	lea    0x14(%ebp),%eax
  801531:	50                   	push   %eax
  801532:	e8 84 fc ff ff       	call   8011bb <getuint>
  801537:	83 c4 10             	add    $0x10,%esp
  80153a:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80153d:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  801540:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  801547:	e9 98 00 00 00       	jmp    8015e4 <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  80154c:	83 ec 08             	sub    $0x8,%esp
  80154f:	ff 75 0c             	pushl  0xc(%ebp)
  801552:	6a 58                	push   $0x58
  801554:	8b 45 08             	mov    0x8(%ebp),%eax
  801557:	ff d0                	call   *%eax
  801559:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  80155c:	83 ec 08             	sub    $0x8,%esp
  80155f:	ff 75 0c             	pushl  0xc(%ebp)
  801562:	6a 58                	push   $0x58
  801564:	8b 45 08             	mov    0x8(%ebp),%eax
  801567:	ff d0                	call   *%eax
  801569:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  80156c:	83 ec 08             	sub    $0x8,%esp
  80156f:	ff 75 0c             	pushl  0xc(%ebp)
  801572:	6a 58                	push   $0x58
  801574:	8b 45 08             	mov    0x8(%ebp),%eax
  801577:	ff d0                	call   *%eax
  801579:	83 c4 10             	add    $0x10,%esp
			break;
  80157c:	e9 bc 00 00 00       	jmp    80163d <vprintfmt+0x3bc>

		// pointer
		case 'p':
			putch('0', putdat);
  801581:	83 ec 08             	sub    $0x8,%esp
  801584:	ff 75 0c             	pushl  0xc(%ebp)
  801587:	6a 30                	push   $0x30
  801589:	8b 45 08             	mov    0x8(%ebp),%eax
  80158c:	ff d0                	call   *%eax
  80158e:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  801591:	83 ec 08             	sub    $0x8,%esp
  801594:	ff 75 0c             	pushl  0xc(%ebp)
  801597:	6a 78                	push   $0x78
  801599:	8b 45 08             	mov    0x8(%ebp),%eax
  80159c:	ff d0                	call   *%eax
  80159e:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  8015a1:	8b 45 14             	mov    0x14(%ebp),%eax
  8015a4:	83 c0 04             	add    $0x4,%eax
  8015a7:	89 45 14             	mov    %eax,0x14(%ebp)
  8015aa:	8b 45 14             	mov    0x14(%ebp),%eax
  8015ad:	83 e8 04             	sub    $0x4,%eax
  8015b0:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  8015b2:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8015b5:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  8015bc:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  8015c3:	eb 1f                	jmp    8015e4 <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  8015c5:	83 ec 08             	sub    $0x8,%esp
  8015c8:	ff 75 e8             	pushl  -0x18(%ebp)
  8015cb:	8d 45 14             	lea    0x14(%ebp),%eax
  8015ce:	50                   	push   %eax
  8015cf:	e8 e7 fb ff ff       	call   8011bb <getuint>
  8015d4:	83 c4 10             	add    $0x10,%esp
  8015d7:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8015da:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  8015dd:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  8015e4:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  8015e8:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8015eb:	83 ec 04             	sub    $0x4,%esp
  8015ee:	52                   	push   %edx
  8015ef:	ff 75 e4             	pushl  -0x1c(%ebp)
  8015f2:	50                   	push   %eax
  8015f3:	ff 75 f4             	pushl  -0xc(%ebp)
  8015f6:	ff 75 f0             	pushl  -0x10(%ebp)
  8015f9:	ff 75 0c             	pushl  0xc(%ebp)
  8015fc:	ff 75 08             	pushl  0x8(%ebp)
  8015ff:	e8 00 fb ff ff       	call   801104 <printnum>
  801604:	83 c4 20             	add    $0x20,%esp
			break;
  801607:	eb 34                	jmp    80163d <vprintfmt+0x3bc>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  801609:	83 ec 08             	sub    $0x8,%esp
  80160c:	ff 75 0c             	pushl  0xc(%ebp)
  80160f:	53                   	push   %ebx
  801610:	8b 45 08             	mov    0x8(%ebp),%eax
  801613:	ff d0                	call   *%eax
  801615:	83 c4 10             	add    $0x10,%esp
			break;
  801618:	eb 23                	jmp    80163d <vprintfmt+0x3bc>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  80161a:	83 ec 08             	sub    $0x8,%esp
  80161d:	ff 75 0c             	pushl  0xc(%ebp)
  801620:	6a 25                	push   $0x25
  801622:	8b 45 08             	mov    0x8(%ebp),%eax
  801625:	ff d0                	call   *%eax
  801627:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  80162a:	ff 4d 10             	decl   0x10(%ebp)
  80162d:	eb 03                	jmp    801632 <vprintfmt+0x3b1>
  80162f:	ff 4d 10             	decl   0x10(%ebp)
  801632:	8b 45 10             	mov    0x10(%ebp),%eax
  801635:	48                   	dec    %eax
  801636:	8a 00                	mov    (%eax),%al
  801638:	3c 25                	cmp    $0x25,%al
  80163a:	75 f3                	jne    80162f <vprintfmt+0x3ae>
				/* do nothing */;
			break;
  80163c:	90                   	nop
		}
	}
  80163d:	e9 47 fc ff ff       	jmp    801289 <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  801642:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  801643:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801646:	5b                   	pop    %ebx
  801647:	5e                   	pop    %esi
  801648:	5d                   	pop    %ebp
  801649:	c3                   	ret    

0080164a <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  80164a:	55                   	push   %ebp
  80164b:	89 e5                	mov    %esp,%ebp
  80164d:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  801650:	8d 45 10             	lea    0x10(%ebp),%eax
  801653:	83 c0 04             	add    $0x4,%eax
  801656:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  801659:	8b 45 10             	mov    0x10(%ebp),%eax
  80165c:	ff 75 f4             	pushl  -0xc(%ebp)
  80165f:	50                   	push   %eax
  801660:	ff 75 0c             	pushl  0xc(%ebp)
  801663:	ff 75 08             	pushl  0x8(%ebp)
  801666:	e8 16 fc ff ff       	call   801281 <vprintfmt>
  80166b:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  80166e:	90                   	nop
  80166f:	c9                   	leave  
  801670:	c3                   	ret    

00801671 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  801671:	55                   	push   %ebp
  801672:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  801674:	8b 45 0c             	mov    0xc(%ebp),%eax
  801677:	8b 40 08             	mov    0x8(%eax),%eax
  80167a:	8d 50 01             	lea    0x1(%eax),%edx
  80167d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801680:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  801683:	8b 45 0c             	mov    0xc(%ebp),%eax
  801686:	8b 10                	mov    (%eax),%edx
  801688:	8b 45 0c             	mov    0xc(%ebp),%eax
  80168b:	8b 40 04             	mov    0x4(%eax),%eax
  80168e:	39 c2                	cmp    %eax,%edx
  801690:	73 12                	jae    8016a4 <sprintputch+0x33>
		*b->buf++ = ch;
  801692:	8b 45 0c             	mov    0xc(%ebp),%eax
  801695:	8b 00                	mov    (%eax),%eax
  801697:	8d 48 01             	lea    0x1(%eax),%ecx
  80169a:	8b 55 0c             	mov    0xc(%ebp),%edx
  80169d:	89 0a                	mov    %ecx,(%edx)
  80169f:	8b 55 08             	mov    0x8(%ebp),%edx
  8016a2:	88 10                	mov    %dl,(%eax)
}
  8016a4:	90                   	nop
  8016a5:	5d                   	pop    %ebp
  8016a6:	c3                   	ret    

008016a7 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  8016a7:	55                   	push   %ebp
  8016a8:	89 e5                	mov    %esp,%ebp
  8016aa:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  8016ad:	8b 45 08             	mov    0x8(%ebp),%eax
  8016b0:	89 45 ec             	mov    %eax,-0x14(%ebp)
  8016b3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8016b6:	8d 50 ff             	lea    -0x1(%eax),%edx
  8016b9:	8b 45 08             	mov    0x8(%ebp),%eax
  8016bc:	01 d0                	add    %edx,%eax
  8016be:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8016c1:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  8016c8:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8016cc:	74 06                	je     8016d4 <vsnprintf+0x2d>
  8016ce:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8016d2:	7f 07                	jg     8016db <vsnprintf+0x34>
		return -E_INVAL;
  8016d4:	b8 03 00 00 00       	mov    $0x3,%eax
  8016d9:	eb 20                	jmp    8016fb <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  8016db:	ff 75 14             	pushl  0x14(%ebp)
  8016de:	ff 75 10             	pushl  0x10(%ebp)
  8016e1:	8d 45 ec             	lea    -0x14(%ebp),%eax
  8016e4:	50                   	push   %eax
  8016e5:	68 71 16 80 00       	push   $0x801671
  8016ea:	e8 92 fb ff ff       	call   801281 <vprintfmt>
  8016ef:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  8016f2:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8016f5:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  8016f8:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  8016fb:	c9                   	leave  
  8016fc:	c3                   	ret    

008016fd <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  8016fd:	55                   	push   %ebp
  8016fe:	89 e5                	mov    %esp,%ebp
  801700:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  801703:	8d 45 10             	lea    0x10(%ebp),%eax
  801706:	83 c0 04             	add    $0x4,%eax
  801709:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  80170c:	8b 45 10             	mov    0x10(%ebp),%eax
  80170f:	ff 75 f4             	pushl  -0xc(%ebp)
  801712:	50                   	push   %eax
  801713:	ff 75 0c             	pushl  0xc(%ebp)
  801716:	ff 75 08             	pushl  0x8(%ebp)
  801719:	e8 89 ff ff ff       	call   8016a7 <vsnprintf>
  80171e:	83 c4 10             	add    $0x10,%esp
  801721:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  801724:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801727:	c9                   	leave  
  801728:	c3                   	ret    

00801729 <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  801729:	55                   	push   %ebp
  80172a:	89 e5                	mov    %esp,%ebp
  80172c:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  80172f:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801736:	eb 06                	jmp    80173e <strlen+0x15>
		n++;
  801738:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  80173b:	ff 45 08             	incl   0x8(%ebp)
  80173e:	8b 45 08             	mov    0x8(%ebp),%eax
  801741:	8a 00                	mov    (%eax),%al
  801743:	84 c0                	test   %al,%al
  801745:	75 f1                	jne    801738 <strlen+0xf>
		n++;
	return n;
  801747:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  80174a:	c9                   	leave  
  80174b:	c3                   	ret    

0080174c <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  80174c:	55                   	push   %ebp
  80174d:	89 e5                	mov    %esp,%ebp
  80174f:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  801752:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801759:	eb 09                	jmp    801764 <strnlen+0x18>
		n++;
  80175b:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  80175e:	ff 45 08             	incl   0x8(%ebp)
  801761:	ff 4d 0c             	decl   0xc(%ebp)
  801764:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801768:	74 09                	je     801773 <strnlen+0x27>
  80176a:	8b 45 08             	mov    0x8(%ebp),%eax
  80176d:	8a 00                	mov    (%eax),%al
  80176f:	84 c0                	test   %al,%al
  801771:	75 e8                	jne    80175b <strnlen+0xf>
		n++;
	return n;
  801773:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  801776:	c9                   	leave  
  801777:	c3                   	ret    

00801778 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  801778:	55                   	push   %ebp
  801779:	89 e5                	mov    %esp,%ebp
  80177b:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  80177e:	8b 45 08             	mov    0x8(%ebp),%eax
  801781:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  801784:	90                   	nop
  801785:	8b 45 08             	mov    0x8(%ebp),%eax
  801788:	8d 50 01             	lea    0x1(%eax),%edx
  80178b:	89 55 08             	mov    %edx,0x8(%ebp)
  80178e:	8b 55 0c             	mov    0xc(%ebp),%edx
  801791:	8d 4a 01             	lea    0x1(%edx),%ecx
  801794:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  801797:	8a 12                	mov    (%edx),%dl
  801799:	88 10                	mov    %dl,(%eax)
  80179b:	8a 00                	mov    (%eax),%al
  80179d:	84 c0                	test   %al,%al
  80179f:	75 e4                	jne    801785 <strcpy+0xd>
		/* do nothing */;
	return ret;
  8017a1:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  8017a4:	c9                   	leave  
  8017a5:	c3                   	ret    

008017a6 <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  8017a6:	55                   	push   %ebp
  8017a7:	89 e5                	mov    %esp,%ebp
  8017a9:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  8017ac:	8b 45 08             	mov    0x8(%ebp),%eax
  8017af:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  8017b2:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8017b9:	eb 1f                	jmp    8017da <strncpy+0x34>
		*dst++ = *src;
  8017bb:	8b 45 08             	mov    0x8(%ebp),%eax
  8017be:	8d 50 01             	lea    0x1(%eax),%edx
  8017c1:	89 55 08             	mov    %edx,0x8(%ebp)
  8017c4:	8b 55 0c             	mov    0xc(%ebp),%edx
  8017c7:	8a 12                	mov    (%edx),%dl
  8017c9:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  8017cb:	8b 45 0c             	mov    0xc(%ebp),%eax
  8017ce:	8a 00                	mov    (%eax),%al
  8017d0:	84 c0                	test   %al,%al
  8017d2:	74 03                	je     8017d7 <strncpy+0x31>
			src++;
  8017d4:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  8017d7:	ff 45 fc             	incl   -0x4(%ebp)
  8017da:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8017dd:	3b 45 10             	cmp    0x10(%ebp),%eax
  8017e0:	72 d9                	jb     8017bb <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  8017e2:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  8017e5:	c9                   	leave  
  8017e6:	c3                   	ret    

008017e7 <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  8017e7:	55                   	push   %ebp
  8017e8:	89 e5                	mov    %esp,%ebp
  8017ea:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  8017ed:	8b 45 08             	mov    0x8(%ebp),%eax
  8017f0:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  8017f3:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8017f7:	74 30                	je     801829 <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  8017f9:	eb 16                	jmp    801811 <strlcpy+0x2a>
			*dst++ = *src++;
  8017fb:	8b 45 08             	mov    0x8(%ebp),%eax
  8017fe:	8d 50 01             	lea    0x1(%eax),%edx
  801801:	89 55 08             	mov    %edx,0x8(%ebp)
  801804:	8b 55 0c             	mov    0xc(%ebp),%edx
  801807:	8d 4a 01             	lea    0x1(%edx),%ecx
  80180a:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  80180d:	8a 12                	mov    (%edx),%dl
  80180f:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  801811:	ff 4d 10             	decl   0x10(%ebp)
  801814:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801818:	74 09                	je     801823 <strlcpy+0x3c>
  80181a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80181d:	8a 00                	mov    (%eax),%al
  80181f:	84 c0                	test   %al,%al
  801821:	75 d8                	jne    8017fb <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  801823:	8b 45 08             	mov    0x8(%ebp),%eax
  801826:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  801829:	8b 55 08             	mov    0x8(%ebp),%edx
  80182c:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80182f:	29 c2                	sub    %eax,%edx
  801831:	89 d0                	mov    %edx,%eax
}
  801833:	c9                   	leave  
  801834:	c3                   	ret    

00801835 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  801835:	55                   	push   %ebp
  801836:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  801838:	eb 06                	jmp    801840 <strcmp+0xb>
		p++, q++;
  80183a:	ff 45 08             	incl   0x8(%ebp)
  80183d:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  801840:	8b 45 08             	mov    0x8(%ebp),%eax
  801843:	8a 00                	mov    (%eax),%al
  801845:	84 c0                	test   %al,%al
  801847:	74 0e                	je     801857 <strcmp+0x22>
  801849:	8b 45 08             	mov    0x8(%ebp),%eax
  80184c:	8a 10                	mov    (%eax),%dl
  80184e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801851:	8a 00                	mov    (%eax),%al
  801853:	38 c2                	cmp    %al,%dl
  801855:	74 e3                	je     80183a <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  801857:	8b 45 08             	mov    0x8(%ebp),%eax
  80185a:	8a 00                	mov    (%eax),%al
  80185c:	0f b6 d0             	movzbl %al,%edx
  80185f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801862:	8a 00                	mov    (%eax),%al
  801864:	0f b6 c0             	movzbl %al,%eax
  801867:	29 c2                	sub    %eax,%edx
  801869:	89 d0                	mov    %edx,%eax
}
  80186b:	5d                   	pop    %ebp
  80186c:	c3                   	ret    

0080186d <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  80186d:	55                   	push   %ebp
  80186e:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  801870:	eb 09                	jmp    80187b <strncmp+0xe>
		n--, p++, q++;
  801872:	ff 4d 10             	decl   0x10(%ebp)
  801875:	ff 45 08             	incl   0x8(%ebp)
  801878:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  80187b:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80187f:	74 17                	je     801898 <strncmp+0x2b>
  801881:	8b 45 08             	mov    0x8(%ebp),%eax
  801884:	8a 00                	mov    (%eax),%al
  801886:	84 c0                	test   %al,%al
  801888:	74 0e                	je     801898 <strncmp+0x2b>
  80188a:	8b 45 08             	mov    0x8(%ebp),%eax
  80188d:	8a 10                	mov    (%eax),%dl
  80188f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801892:	8a 00                	mov    (%eax),%al
  801894:	38 c2                	cmp    %al,%dl
  801896:	74 da                	je     801872 <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  801898:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80189c:	75 07                	jne    8018a5 <strncmp+0x38>
		return 0;
  80189e:	b8 00 00 00 00       	mov    $0x0,%eax
  8018a3:	eb 14                	jmp    8018b9 <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  8018a5:	8b 45 08             	mov    0x8(%ebp),%eax
  8018a8:	8a 00                	mov    (%eax),%al
  8018aa:	0f b6 d0             	movzbl %al,%edx
  8018ad:	8b 45 0c             	mov    0xc(%ebp),%eax
  8018b0:	8a 00                	mov    (%eax),%al
  8018b2:	0f b6 c0             	movzbl %al,%eax
  8018b5:	29 c2                	sub    %eax,%edx
  8018b7:	89 d0                	mov    %edx,%eax
}
  8018b9:	5d                   	pop    %ebp
  8018ba:	c3                   	ret    

008018bb <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  8018bb:	55                   	push   %ebp
  8018bc:	89 e5                	mov    %esp,%ebp
  8018be:	83 ec 04             	sub    $0x4,%esp
  8018c1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8018c4:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  8018c7:	eb 12                	jmp    8018db <strchr+0x20>
		if (*s == c)
  8018c9:	8b 45 08             	mov    0x8(%ebp),%eax
  8018cc:	8a 00                	mov    (%eax),%al
  8018ce:	3a 45 fc             	cmp    -0x4(%ebp),%al
  8018d1:	75 05                	jne    8018d8 <strchr+0x1d>
			return (char *) s;
  8018d3:	8b 45 08             	mov    0x8(%ebp),%eax
  8018d6:	eb 11                	jmp    8018e9 <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  8018d8:	ff 45 08             	incl   0x8(%ebp)
  8018db:	8b 45 08             	mov    0x8(%ebp),%eax
  8018de:	8a 00                	mov    (%eax),%al
  8018e0:	84 c0                	test   %al,%al
  8018e2:	75 e5                	jne    8018c9 <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  8018e4:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8018e9:	c9                   	leave  
  8018ea:	c3                   	ret    

008018eb <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  8018eb:	55                   	push   %ebp
  8018ec:	89 e5                	mov    %esp,%ebp
  8018ee:	83 ec 04             	sub    $0x4,%esp
  8018f1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8018f4:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  8018f7:	eb 0d                	jmp    801906 <strfind+0x1b>
		if (*s == c)
  8018f9:	8b 45 08             	mov    0x8(%ebp),%eax
  8018fc:	8a 00                	mov    (%eax),%al
  8018fe:	3a 45 fc             	cmp    -0x4(%ebp),%al
  801901:	74 0e                	je     801911 <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  801903:	ff 45 08             	incl   0x8(%ebp)
  801906:	8b 45 08             	mov    0x8(%ebp),%eax
  801909:	8a 00                	mov    (%eax),%al
  80190b:	84 c0                	test   %al,%al
  80190d:	75 ea                	jne    8018f9 <strfind+0xe>
  80190f:	eb 01                	jmp    801912 <strfind+0x27>
		if (*s == c)
			break;
  801911:	90                   	nop
	return (char *) s;
  801912:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801915:	c9                   	leave  
  801916:	c3                   	ret    

00801917 <memset>:


void *
memset(void *v, int c, uint32 n)
{
  801917:	55                   	push   %ebp
  801918:	89 e5                	mov    %esp,%ebp
  80191a:	83 ec 10             	sub    $0x10,%esp
	char *p;
	int m;

	p = v;
  80191d:	8b 45 08             	mov    0x8(%ebp),%eax
  801920:	89 45 fc             	mov    %eax,-0x4(%ebp)
	m = n;
  801923:	8b 45 10             	mov    0x10(%ebp),%eax
  801926:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (--m >= 0)
  801929:	eb 0e                	jmp    801939 <memset+0x22>
		*p++ = c;
  80192b:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80192e:	8d 50 01             	lea    0x1(%eax),%edx
  801931:	89 55 fc             	mov    %edx,-0x4(%ebp)
  801934:	8b 55 0c             	mov    0xc(%ebp),%edx
  801937:	88 10                	mov    %dl,(%eax)
	char *p;
	int m;

	p = v;
	m = n;
	while (--m >= 0)
  801939:	ff 4d f8             	decl   -0x8(%ebp)
  80193c:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  801940:	79 e9                	jns    80192b <memset+0x14>
		*p++ = c;

	return v;
  801942:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801945:	c9                   	leave  
  801946:	c3                   	ret    

00801947 <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  801947:	55                   	push   %ebp
  801948:	89 e5                	mov    %esp,%ebp
  80194a:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  80194d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801950:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  801953:	8b 45 08             	mov    0x8(%ebp),%eax
  801956:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (n-- > 0)
  801959:	eb 16                	jmp    801971 <memcpy+0x2a>
		*d++ = *s++;
  80195b:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80195e:	8d 50 01             	lea    0x1(%eax),%edx
  801961:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801964:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801967:	8d 4a 01             	lea    0x1(%edx),%ecx
  80196a:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  80196d:	8a 12                	mov    (%edx),%dl
  80196f:	88 10                	mov    %dl,(%eax)
	const char *s;
	char *d;

	s = src;
	d = dst;
	while (n-- > 0)
  801971:	8b 45 10             	mov    0x10(%ebp),%eax
  801974:	8d 50 ff             	lea    -0x1(%eax),%edx
  801977:	89 55 10             	mov    %edx,0x10(%ebp)
  80197a:	85 c0                	test   %eax,%eax
  80197c:	75 dd                	jne    80195b <memcpy+0x14>
		*d++ = *s++;

	return dst;
  80197e:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801981:	c9                   	leave  
  801982:	c3                   	ret    

00801983 <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  801983:	55                   	push   %ebp
  801984:	89 e5                	mov    %esp,%ebp
  801986:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  801989:	8b 45 0c             	mov    0xc(%ebp),%eax
  80198c:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  80198f:	8b 45 08             	mov    0x8(%ebp),%eax
  801992:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  801995:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801998:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  80199b:	73 50                	jae    8019ed <memmove+0x6a>
  80199d:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8019a0:	8b 45 10             	mov    0x10(%ebp),%eax
  8019a3:	01 d0                	add    %edx,%eax
  8019a5:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  8019a8:	76 43                	jbe    8019ed <memmove+0x6a>
		s += n;
  8019aa:	8b 45 10             	mov    0x10(%ebp),%eax
  8019ad:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  8019b0:	8b 45 10             	mov    0x10(%ebp),%eax
  8019b3:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  8019b6:	eb 10                	jmp    8019c8 <memmove+0x45>
			*--d = *--s;
  8019b8:	ff 4d f8             	decl   -0x8(%ebp)
  8019bb:	ff 4d fc             	decl   -0x4(%ebp)
  8019be:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8019c1:	8a 10                	mov    (%eax),%dl
  8019c3:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8019c6:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  8019c8:	8b 45 10             	mov    0x10(%ebp),%eax
  8019cb:	8d 50 ff             	lea    -0x1(%eax),%edx
  8019ce:	89 55 10             	mov    %edx,0x10(%ebp)
  8019d1:	85 c0                	test   %eax,%eax
  8019d3:	75 e3                	jne    8019b8 <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  8019d5:	eb 23                	jmp    8019fa <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  8019d7:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8019da:	8d 50 01             	lea    0x1(%eax),%edx
  8019dd:	89 55 f8             	mov    %edx,-0x8(%ebp)
  8019e0:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8019e3:	8d 4a 01             	lea    0x1(%edx),%ecx
  8019e6:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  8019e9:	8a 12                	mov    (%edx),%dl
  8019eb:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  8019ed:	8b 45 10             	mov    0x10(%ebp),%eax
  8019f0:	8d 50 ff             	lea    -0x1(%eax),%edx
  8019f3:	89 55 10             	mov    %edx,0x10(%ebp)
  8019f6:	85 c0                	test   %eax,%eax
  8019f8:	75 dd                	jne    8019d7 <memmove+0x54>
			*d++ = *s++;

	return dst;
  8019fa:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8019fd:	c9                   	leave  
  8019fe:	c3                   	ret    

008019ff <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  8019ff:	55                   	push   %ebp
  801a00:	89 e5                	mov    %esp,%ebp
  801a02:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  801a05:	8b 45 08             	mov    0x8(%ebp),%eax
  801a08:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  801a0b:	8b 45 0c             	mov    0xc(%ebp),%eax
  801a0e:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  801a11:	eb 2a                	jmp    801a3d <memcmp+0x3e>
		if (*s1 != *s2)
  801a13:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801a16:	8a 10                	mov    (%eax),%dl
  801a18:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801a1b:	8a 00                	mov    (%eax),%al
  801a1d:	38 c2                	cmp    %al,%dl
  801a1f:	74 16                	je     801a37 <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  801a21:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801a24:	8a 00                	mov    (%eax),%al
  801a26:	0f b6 d0             	movzbl %al,%edx
  801a29:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801a2c:	8a 00                	mov    (%eax),%al
  801a2e:	0f b6 c0             	movzbl %al,%eax
  801a31:	29 c2                	sub    %eax,%edx
  801a33:	89 d0                	mov    %edx,%eax
  801a35:	eb 18                	jmp    801a4f <memcmp+0x50>
		s1++, s2++;
  801a37:	ff 45 fc             	incl   -0x4(%ebp)
  801a3a:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  801a3d:	8b 45 10             	mov    0x10(%ebp),%eax
  801a40:	8d 50 ff             	lea    -0x1(%eax),%edx
  801a43:	89 55 10             	mov    %edx,0x10(%ebp)
  801a46:	85 c0                	test   %eax,%eax
  801a48:	75 c9                	jne    801a13 <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  801a4a:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801a4f:	c9                   	leave  
  801a50:	c3                   	ret    

00801a51 <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  801a51:	55                   	push   %ebp
  801a52:	89 e5                	mov    %esp,%ebp
  801a54:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  801a57:	8b 55 08             	mov    0x8(%ebp),%edx
  801a5a:	8b 45 10             	mov    0x10(%ebp),%eax
  801a5d:	01 d0                	add    %edx,%eax
  801a5f:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  801a62:	eb 15                	jmp    801a79 <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  801a64:	8b 45 08             	mov    0x8(%ebp),%eax
  801a67:	8a 00                	mov    (%eax),%al
  801a69:	0f b6 d0             	movzbl %al,%edx
  801a6c:	8b 45 0c             	mov    0xc(%ebp),%eax
  801a6f:	0f b6 c0             	movzbl %al,%eax
  801a72:	39 c2                	cmp    %eax,%edx
  801a74:	74 0d                	je     801a83 <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  801a76:	ff 45 08             	incl   0x8(%ebp)
  801a79:	8b 45 08             	mov    0x8(%ebp),%eax
  801a7c:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  801a7f:	72 e3                	jb     801a64 <memfind+0x13>
  801a81:	eb 01                	jmp    801a84 <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  801a83:	90                   	nop
	return (void *) s;
  801a84:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801a87:	c9                   	leave  
  801a88:	c3                   	ret    

00801a89 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  801a89:	55                   	push   %ebp
  801a8a:	89 e5                	mov    %esp,%ebp
  801a8c:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  801a8f:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  801a96:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801a9d:	eb 03                	jmp    801aa2 <strtol+0x19>
		s++;
  801a9f:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801aa2:	8b 45 08             	mov    0x8(%ebp),%eax
  801aa5:	8a 00                	mov    (%eax),%al
  801aa7:	3c 20                	cmp    $0x20,%al
  801aa9:	74 f4                	je     801a9f <strtol+0x16>
  801aab:	8b 45 08             	mov    0x8(%ebp),%eax
  801aae:	8a 00                	mov    (%eax),%al
  801ab0:	3c 09                	cmp    $0x9,%al
  801ab2:	74 eb                	je     801a9f <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  801ab4:	8b 45 08             	mov    0x8(%ebp),%eax
  801ab7:	8a 00                	mov    (%eax),%al
  801ab9:	3c 2b                	cmp    $0x2b,%al
  801abb:	75 05                	jne    801ac2 <strtol+0x39>
		s++;
  801abd:	ff 45 08             	incl   0x8(%ebp)
  801ac0:	eb 13                	jmp    801ad5 <strtol+0x4c>
	else if (*s == '-')
  801ac2:	8b 45 08             	mov    0x8(%ebp),%eax
  801ac5:	8a 00                	mov    (%eax),%al
  801ac7:	3c 2d                	cmp    $0x2d,%al
  801ac9:	75 0a                	jne    801ad5 <strtol+0x4c>
		s++, neg = 1;
  801acb:	ff 45 08             	incl   0x8(%ebp)
  801ace:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  801ad5:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801ad9:	74 06                	je     801ae1 <strtol+0x58>
  801adb:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  801adf:	75 20                	jne    801b01 <strtol+0x78>
  801ae1:	8b 45 08             	mov    0x8(%ebp),%eax
  801ae4:	8a 00                	mov    (%eax),%al
  801ae6:	3c 30                	cmp    $0x30,%al
  801ae8:	75 17                	jne    801b01 <strtol+0x78>
  801aea:	8b 45 08             	mov    0x8(%ebp),%eax
  801aed:	40                   	inc    %eax
  801aee:	8a 00                	mov    (%eax),%al
  801af0:	3c 78                	cmp    $0x78,%al
  801af2:	75 0d                	jne    801b01 <strtol+0x78>
		s += 2, base = 16;
  801af4:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  801af8:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  801aff:	eb 28                	jmp    801b29 <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  801b01:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801b05:	75 15                	jne    801b1c <strtol+0x93>
  801b07:	8b 45 08             	mov    0x8(%ebp),%eax
  801b0a:	8a 00                	mov    (%eax),%al
  801b0c:	3c 30                	cmp    $0x30,%al
  801b0e:	75 0c                	jne    801b1c <strtol+0x93>
		s++, base = 8;
  801b10:	ff 45 08             	incl   0x8(%ebp)
  801b13:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  801b1a:	eb 0d                	jmp    801b29 <strtol+0xa0>
	else if (base == 0)
  801b1c:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801b20:	75 07                	jne    801b29 <strtol+0xa0>
		base = 10;
  801b22:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  801b29:	8b 45 08             	mov    0x8(%ebp),%eax
  801b2c:	8a 00                	mov    (%eax),%al
  801b2e:	3c 2f                	cmp    $0x2f,%al
  801b30:	7e 19                	jle    801b4b <strtol+0xc2>
  801b32:	8b 45 08             	mov    0x8(%ebp),%eax
  801b35:	8a 00                	mov    (%eax),%al
  801b37:	3c 39                	cmp    $0x39,%al
  801b39:	7f 10                	jg     801b4b <strtol+0xc2>
			dig = *s - '0';
  801b3b:	8b 45 08             	mov    0x8(%ebp),%eax
  801b3e:	8a 00                	mov    (%eax),%al
  801b40:	0f be c0             	movsbl %al,%eax
  801b43:	83 e8 30             	sub    $0x30,%eax
  801b46:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801b49:	eb 42                	jmp    801b8d <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  801b4b:	8b 45 08             	mov    0x8(%ebp),%eax
  801b4e:	8a 00                	mov    (%eax),%al
  801b50:	3c 60                	cmp    $0x60,%al
  801b52:	7e 19                	jle    801b6d <strtol+0xe4>
  801b54:	8b 45 08             	mov    0x8(%ebp),%eax
  801b57:	8a 00                	mov    (%eax),%al
  801b59:	3c 7a                	cmp    $0x7a,%al
  801b5b:	7f 10                	jg     801b6d <strtol+0xe4>
			dig = *s - 'a' + 10;
  801b5d:	8b 45 08             	mov    0x8(%ebp),%eax
  801b60:	8a 00                	mov    (%eax),%al
  801b62:	0f be c0             	movsbl %al,%eax
  801b65:	83 e8 57             	sub    $0x57,%eax
  801b68:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801b6b:	eb 20                	jmp    801b8d <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  801b6d:	8b 45 08             	mov    0x8(%ebp),%eax
  801b70:	8a 00                	mov    (%eax),%al
  801b72:	3c 40                	cmp    $0x40,%al
  801b74:	7e 39                	jle    801baf <strtol+0x126>
  801b76:	8b 45 08             	mov    0x8(%ebp),%eax
  801b79:	8a 00                	mov    (%eax),%al
  801b7b:	3c 5a                	cmp    $0x5a,%al
  801b7d:	7f 30                	jg     801baf <strtol+0x126>
			dig = *s - 'A' + 10;
  801b7f:	8b 45 08             	mov    0x8(%ebp),%eax
  801b82:	8a 00                	mov    (%eax),%al
  801b84:	0f be c0             	movsbl %al,%eax
  801b87:	83 e8 37             	sub    $0x37,%eax
  801b8a:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  801b8d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801b90:	3b 45 10             	cmp    0x10(%ebp),%eax
  801b93:	7d 19                	jge    801bae <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  801b95:	ff 45 08             	incl   0x8(%ebp)
  801b98:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801b9b:	0f af 45 10          	imul   0x10(%ebp),%eax
  801b9f:	89 c2                	mov    %eax,%edx
  801ba1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ba4:	01 d0                	add    %edx,%eax
  801ba6:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  801ba9:	e9 7b ff ff ff       	jmp    801b29 <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  801bae:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  801baf:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801bb3:	74 08                	je     801bbd <strtol+0x134>
		*endptr = (char *) s;
  801bb5:	8b 45 0c             	mov    0xc(%ebp),%eax
  801bb8:	8b 55 08             	mov    0x8(%ebp),%edx
  801bbb:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  801bbd:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801bc1:	74 07                	je     801bca <strtol+0x141>
  801bc3:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801bc6:	f7 d8                	neg    %eax
  801bc8:	eb 03                	jmp    801bcd <strtol+0x144>
  801bca:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  801bcd:	c9                   	leave  
  801bce:	c3                   	ret    

00801bcf <ltostr>:

void
ltostr(long value, char *str)
{
  801bcf:	55                   	push   %ebp
  801bd0:	89 e5                	mov    %esp,%ebp
  801bd2:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  801bd5:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  801bdc:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  801be3:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801be7:	79 13                	jns    801bfc <ltostr+0x2d>
	{
		neg = 1;
  801be9:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  801bf0:	8b 45 0c             	mov    0xc(%ebp),%eax
  801bf3:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  801bf6:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  801bf9:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  801bfc:	8b 45 08             	mov    0x8(%ebp),%eax
  801bff:	b9 0a 00 00 00       	mov    $0xa,%ecx
  801c04:	99                   	cltd   
  801c05:	f7 f9                	idiv   %ecx
  801c07:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  801c0a:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801c0d:	8d 50 01             	lea    0x1(%eax),%edx
  801c10:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801c13:	89 c2                	mov    %eax,%edx
  801c15:	8b 45 0c             	mov    0xc(%ebp),%eax
  801c18:	01 d0                	add    %edx,%eax
  801c1a:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801c1d:	83 c2 30             	add    $0x30,%edx
  801c20:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  801c22:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801c25:	b8 67 66 66 66       	mov    $0x66666667,%eax
  801c2a:	f7 e9                	imul   %ecx
  801c2c:	c1 fa 02             	sar    $0x2,%edx
  801c2f:	89 c8                	mov    %ecx,%eax
  801c31:	c1 f8 1f             	sar    $0x1f,%eax
  801c34:	29 c2                	sub    %eax,%edx
  801c36:	89 d0                	mov    %edx,%eax
  801c38:	89 45 08             	mov    %eax,0x8(%ebp)
	} while (value % 10 != 0);
  801c3b:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801c3e:	b8 67 66 66 66       	mov    $0x66666667,%eax
  801c43:	f7 e9                	imul   %ecx
  801c45:	c1 fa 02             	sar    $0x2,%edx
  801c48:	89 c8                	mov    %ecx,%eax
  801c4a:	c1 f8 1f             	sar    $0x1f,%eax
  801c4d:	29 c2                	sub    %eax,%edx
  801c4f:	89 d0                	mov    %edx,%eax
  801c51:	c1 e0 02             	shl    $0x2,%eax
  801c54:	01 d0                	add    %edx,%eax
  801c56:	01 c0                	add    %eax,%eax
  801c58:	29 c1                	sub    %eax,%ecx
  801c5a:	89 ca                	mov    %ecx,%edx
  801c5c:	85 d2                	test   %edx,%edx
  801c5e:	75 9c                	jne    801bfc <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  801c60:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  801c67:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801c6a:	48                   	dec    %eax
  801c6b:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  801c6e:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801c72:	74 3d                	je     801cb1 <ltostr+0xe2>
		start = 1 ;
  801c74:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  801c7b:	eb 34                	jmp    801cb1 <ltostr+0xe2>
	{
		char tmp = str[start] ;
  801c7d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801c80:	8b 45 0c             	mov    0xc(%ebp),%eax
  801c83:	01 d0                	add    %edx,%eax
  801c85:	8a 00                	mov    (%eax),%al
  801c87:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  801c8a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801c8d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801c90:	01 c2                	add    %eax,%edx
  801c92:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  801c95:	8b 45 0c             	mov    0xc(%ebp),%eax
  801c98:	01 c8                	add    %ecx,%eax
  801c9a:	8a 00                	mov    (%eax),%al
  801c9c:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  801c9e:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801ca1:	8b 45 0c             	mov    0xc(%ebp),%eax
  801ca4:	01 c2                	add    %eax,%edx
  801ca6:	8a 45 eb             	mov    -0x15(%ebp),%al
  801ca9:	88 02                	mov    %al,(%edx)
		start++ ;
  801cab:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  801cae:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  801cb1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801cb4:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801cb7:	7c c4                	jl     801c7d <ltostr+0xae>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  801cb9:	8b 55 f8             	mov    -0x8(%ebp),%edx
  801cbc:	8b 45 0c             	mov    0xc(%ebp),%eax
  801cbf:	01 d0                	add    %edx,%eax
  801cc1:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  801cc4:	90                   	nop
  801cc5:	c9                   	leave  
  801cc6:	c3                   	ret    

00801cc7 <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  801cc7:	55                   	push   %ebp
  801cc8:	89 e5                	mov    %esp,%ebp
  801cca:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  801ccd:	ff 75 08             	pushl  0x8(%ebp)
  801cd0:	e8 54 fa ff ff       	call   801729 <strlen>
  801cd5:	83 c4 04             	add    $0x4,%esp
  801cd8:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  801cdb:	ff 75 0c             	pushl  0xc(%ebp)
  801cde:	e8 46 fa ff ff       	call   801729 <strlen>
  801ce3:	83 c4 04             	add    $0x4,%esp
  801ce6:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  801ce9:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  801cf0:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801cf7:	eb 17                	jmp    801d10 <strcconcat+0x49>
		final[s] = str1[s] ;
  801cf9:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801cfc:	8b 45 10             	mov    0x10(%ebp),%eax
  801cff:	01 c2                	add    %eax,%edx
  801d01:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  801d04:	8b 45 08             	mov    0x8(%ebp),%eax
  801d07:	01 c8                	add    %ecx,%eax
  801d09:	8a 00                	mov    (%eax),%al
  801d0b:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  801d0d:	ff 45 fc             	incl   -0x4(%ebp)
  801d10:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801d13:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  801d16:	7c e1                	jl     801cf9 <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  801d18:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  801d1f:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  801d26:	eb 1f                	jmp    801d47 <strcconcat+0x80>
		final[s++] = str2[i] ;
  801d28:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801d2b:	8d 50 01             	lea    0x1(%eax),%edx
  801d2e:	89 55 fc             	mov    %edx,-0x4(%ebp)
  801d31:	89 c2                	mov    %eax,%edx
  801d33:	8b 45 10             	mov    0x10(%ebp),%eax
  801d36:	01 c2                	add    %eax,%edx
  801d38:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  801d3b:	8b 45 0c             	mov    0xc(%ebp),%eax
  801d3e:	01 c8                	add    %ecx,%eax
  801d40:	8a 00                	mov    (%eax),%al
  801d42:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  801d44:	ff 45 f8             	incl   -0x8(%ebp)
  801d47:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801d4a:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801d4d:	7c d9                	jl     801d28 <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  801d4f:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801d52:	8b 45 10             	mov    0x10(%ebp),%eax
  801d55:	01 d0                	add    %edx,%eax
  801d57:	c6 00 00             	movb   $0x0,(%eax)
}
  801d5a:	90                   	nop
  801d5b:	c9                   	leave  
  801d5c:	c3                   	ret    

00801d5d <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  801d5d:	55                   	push   %ebp
  801d5e:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  801d60:	8b 45 14             	mov    0x14(%ebp),%eax
  801d63:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  801d69:	8b 45 14             	mov    0x14(%ebp),%eax
  801d6c:	8b 00                	mov    (%eax),%eax
  801d6e:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801d75:	8b 45 10             	mov    0x10(%ebp),%eax
  801d78:	01 d0                	add    %edx,%eax
  801d7a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801d80:	eb 0c                	jmp    801d8e <strsplit+0x31>
			*string++ = 0;
  801d82:	8b 45 08             	mov    0x8(%ebp),%eax
  801d85:	8d 50 01             	lea    0x1(%eax),%edx
  801d88:	89 55 08             	mov    %edx,0x8(%ebp)
  801d8b:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801d8e:	8b 45 08             	mov    0x8(%ebp),%eax
  801d91:	8a 00                	mov    (%eax),%al
  801d93:	84 c0                	test   %al,%al
  801d95:	74 18                	je     801daf <strsplit+0x52>
  801d97:	8b 45 08             	mov    0x8(%ebp),%eax
  801d9a:	8a 00                	mov    (%eax),%al
  801d9c:	0f be c0             	movsbl %al,%eax
  801d9f:	50                   	push   %eax
  801da0:	ff 75 0c             	pushl  0xc(%ebp)
  801da3:	e8 13 fb ff ff       	call   8018bb <strchr>
  801da8:	83 c4 08             	add    $0x8,%esp
  801dab:	85 c0                	test   %eax,%eax
  801dad:	75 d3                	jne    801d82 <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  801daf:	8b 45 08             	mov    0x8(%ebp),%eax
  801db2:	8a 00                	mov    (%eax),%al
  801db4:	84 c0                	test   %al,%al
  801db6:	74 5a                	je     801e12 <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  801db8:	8b 45 14             	mov    0x14(%ebp),%eax
  801dbb:	8b 00                	mov    (%eax),%eax
  801dbd:	83 f8 0f             	cmp    $0xf,%eax
  801dc0:	75 07                	jne    801dc9 <strsplit+0x6c>
		{
			return 0;
  801dc2:	b8 00 00 00 00       	mov    $0x0,%eax
  801dc7:	eb 66                	jmp    801e2f <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  801dc9:	8b 45 14             	mov    0x14(%ebp),%eax
  801dcc:	8b 00                	mov    (%eax),%eax
  801dce:	8d 48 01             	lea    0x1(%eax),%ecx
  801dd1:	8b 55 14             	mov    0x14(%ebp),%edx
  801dd4:	89 0a                	mov    %ecx,(%edx)
  801dd6:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801ddd:	8b 45 10             	mov    0x10(%ebp),%eax
  801de0:	01 c2                	add    %eax,%edx
  801de2:	8b 45 08             	mov    0x8(%ebp),%eax
  801de5:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  801de7:	eb 03                	jmp    801dec <strsplit+0x8f>
			string++;
  801de9:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  801dec:	8b 45 08             	mov    0x8(%ebp),%eax
  801def:	8a 00                	mov    (%eax),%al
  801df1:	84 c0                	test   %al,%al
  801df3:	74 8b                	je     801d80 <strsplit+0x23>
  801df5:	8b 45 08             	mov    0x8(%ebp),%eax
  801df8:	8a 00                	mov    (%eax),%al
  801dfa:	0f be c0             	movsbl %al,%eax
  801dfd:	50                   	push   %eax
  801dfe:	ff 75 0c             	pushl  0xc(%ebp)
  801e01:	e8 b5 fa ff ff       	call   8018bb <strchr>
  801e06:	83 c4 08             	add    $0x8,%esp
  801e09:	85 c0                	test   %eax,%eax
  801e0b:	74 dc                	je     801de9 <strsplit+0x8c>
			string++;
	}
  801e0d:	e9 6e ff ff ff       	jmp    801d80 <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  801e12:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  801e13:	8b 45 14             	mov    0x14(%ebp),%eax
  801e16:	8b 00                	mov    (%eax),%eax
  801e18:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801e1f:	8b 45 10             	mov    0x10(%ebp),%eax
  801e22:	01 d0                	add    %edx,%eax
  801e24:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  801e2a:	b8 01 00 00 00       	mov    $0x1,%eax
}
  801e2f:	c9                   	leave  
  801e30:	c3                   	ret    

00801e31 <InitializeUHeap>:
//============================== GIVEN FUNCTIONS ===================================//
//==================================================================================//

int FirstTimeFlag = 1;
void InitializeUHeap()
{
  801e31:	55                   	push   %ebp
  801e32:	89 e5                	mov    %esp,%ebp
  801e34:	83 ec 08             	sub    $0x8,%esp
	if(FirstTimeFlag)
  801e37:	a1 04 50 80 00       	mov    0x805004,%eax
  801e3c:	85 c0                	test   %eax,%eax
  801e3e:	74 1f                	je     801e5f <InitializeUHeap+0x2e>
	{
		initialize_dyn_block_system();
  801e40:	e8 1d 00 00 00       	call   801e62 <initialize_dyn_block_system>
		cprintf("DYNAMIC BLOCK SYSTEM IS INITIALIZED\n");
  801e45:	83 ec 0c             	sub    $0xc,%esp
  801e48:	68 10 44 80 00       	push   $0x804410
  801e4d:	e8 55 f2 ff ff       	call   8010a7 <cprintf>
  801e52:	83 c4 10             	add    $0x10,%esp
#if UHP_USE_BUDDY
		initialize_buddy();
		cprintf("BUDDY SYSTEM IS INITIALIZED\n");
#endif
		FirstTimeFlag = 0;
  801e55:	c7 05 04 50 80 00 00 	movl   $0x0,0x805004
  801e5c:	00 00 00 
	}
}
  801e5f:	90                   	nop
  801e60:	c9                   	leave  
  801e61:	c3                   	ret    

00801e62 <initialize_dyn_block_system>:

//=================================
// [1] INITIALIZE DYNAMIC ALLOCATOR:
//=================================
void initialize_dyn_block_system()
{
  801e62:	55                   	push   %ebp
  801e63:	89 e5                	mov    %esp,%ebp
  801e65:	83 ec 28             	sub    $0x28,%esp
	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] initialize_dyn_block_system
	// your code is here, remove the panic and write your code
	//panic("initialize_dyn_block_system() is not implemented yet...!!");

	LIST_INIT(&AllocMemBlocksList);
  801e68:	c7 05 40 50 80 00 00 	movl   $0x0,0x805040
  801e6f:	00 00 00 
  801e72:	c7 05 44 50 80 00 00 	movl   $0x0,0x805044
  801e79:	00 00 00 
  801e7c:	c7 05 4c 50 80 00 00 	movl   $0x0,0x80504c
  801e83:	00 00 00 
	LIST_INIT(&FreeMemBlocksList);
  801e86:	c7 05 38 51 80 00 00 	movl   $0x0,0x805138
  801e8d:	00 00 00 
  801e90:	c7 05 3c 51 80 00 00 	movl   $0x0,0x80513c
  801e97:	00 00 00 
  801e9a:	c7 05 44 51 80 00 00 	movl   $0x0,0x805144
  801ea1:	00 00 00 
	MAX_MEM_BLOCK_CNT = NUM_OF_UHEAP_PAGES;
  801ea4:	c7 05 20 51 80 00 00 	movl   $0x20000,0x805120
  801eab:	00 02 00 
	MemBlockNodes = (void*)USER_DYN_BLKS_ARRAY;
  801eae:	c7 45 f4 00 00 e0 7f 	movl   $0x7fe00000,-0xc(%ebp)
  801eb5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801eb8:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801ebd:	2d 00 10 00 00       	sub    $0x1000,%eax
  801ec2:	a3 50 50 80 00       	mov    %eax,0x805050
	int size_of_block = sizeof(struct MemBlock);
  801ec7:	c7 45 f0 10 00 00 00 	movl   $0x10,-0x10(%ebp)
	int size_all_struct = size_of_block*MAX_MEM_BLOCK_CNT;
  801ece:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801ed1:	a1 20 51 80 00       	mov    0x805120,%eax
  801ed6:	0f af c2             	imul   %edx,%eax
  801ed9:	89 45 ec             	mov    %eax,-0x14(%ebp)
	size_all_struct = ROUNDUP(size_all_struct, PAGE_SIZE);
  801edc:	c7 45 e8 00 10 00 00 	movl   $0x1000,-0x18(%ebp)
  801ee3:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801ee6:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801ee9:	01 d0                	add    %edx,%eax
  801eeb:	48                   	dec    %eax
  801eec:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  801eef:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801ef2:	ba 00 00 00 00       	mov    $0x0,%edx
  801ef7:	f7 75 e8             	divl   -0x18(%ebp)
  801efa:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801efd:	29 d0                	sub    %edx,%eax
  801eff:	89 45 ec             	mov    %eax,-0x14(%ebp)
	sys_allocate_chunk(USER_DYN_BLKS_ARRAY, size_all_struct,PERM_USER| PERM_WRITEABLE);
  801f02:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801f05:	c7 45 e0 00 00 e0 7f 	movl   $0x7fe00000,-0x20(%ebp)
  801f0c:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801f0f:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
  801f15:	81 ea 00 10 00 00    	sub    $0x1000,%edx
  801f1b:	83 ec 04             	sub    $0x4,%esp
  801f1e:	6a 06                	push   $0x6
  801f20:	50                   	push   %eax
  801f21:	52                   	push   %edx
  801f22:	e8 a1 05 00 00       	call   8024c8 <sys_allocate_chunk>
  801f27:	83 c4 10             	add    $0x10,%esp
	initialize_MemBlocksList(MAX_MEM_BLOCK_CNT);
  801f2a:	a1 20 51 80 00       	mov    0x805120,%eax
  801f2f:	83 ec 0c             	sub    $0xc,%esp
  801f32:	50                   	push   %eax
  801f33:	e8 16 0c 00 00       	call   802b4e <initialize_MemBlocksList>
  801f38:	83 c4 10             	add    $0x10,%esp
	struct MemBlock* ourBlock =LIST_LAST(&AvailableMemBlocksList);
  801f3b:	a1 4c 51 80 00       	mov    0x80514c,%eax
  801f40:	89 45 dc             	mov    %eax,-0x24(%ebp)
	LIST_REMOVE(&AvailableMemBlocksList,ourBlock);
  801f43:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  801f47:	75 14                	jne    801f5d <initialize_dyn_block_system+0xfb>
  801f49:	83 ec 04             	sub    $0x4,%esp
  801f4c:	68 35 44 80 00       	push   $0x804435
  801f51:	6a 2d                	push   $0x2d
  801f53:	68 53 44 80 00       	push   $0x804453
  801f58:	e8 96 ee ff ff       	call   800df3 <_panic>
  801f5d:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801f60:	8b 00                	mov    (%eax),%eax
  801f62:	85 c0                	test   %eax,%eax
  801f64:	74 10                	je     801f76 <initialize_dyn_block_system+0x114>
  801f66:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801f69:	8b 00                	mov    (%eax),%eax
  801f6b:	8b 55 dc             	mov    -0x24(%ebp),%edx
  801f6e:	8b 52 04             	mov    0x4(%edx),%edx
  801f71:	89 50 04             	mov    %edx,0x4(%eax)
  801f74:	eb 0b                	jmp    801f81 <initialize_dyn_block_system+0x11f>
  801f76:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801f79:	8b 40 04             	mov    0x4(%eax),%eax
  801f7c:	a3 4c 51 80 00       	mov    %eax,0x80514c
  801f81:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801f84:	8b 40 04             	mov    0x4(%eax),%eax
  801f87:	85 c0                	test   %eax,%eax
  801f89:	74 0f                	je     801f9a <initialize_dyn_block_system+0x138>
  801f8b:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801f8e:	8b 40 04             	mov    0x4(%eax),%eax
  801f91:	8b 55 dc             	mov    -0x24(%ebp),%edx
  801f94:	8b 12                	mov    (%edx),%edx
  801f96:	89 10                	mov    %edx,(%eax)
  801f98:	eb 0a                	jmp    801fa4 <initialize_dyn_block_system+0x142>
  801f9a:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801f9d:	8b 00                	mov    (%eax),%eax
  801f9f:	a3 48 51 80 00       	mov    %eax,0x805148
  801fa4:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801fa7:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  801fad:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801fb0:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  801fb7:	a1 54 51 80 00       	mov    0x805154,%eax
  801fbc:	48                   	dec    %eax
  801fbd:	a3 54 51 80 00       	mov    %eax,0x805154
	ourBlock->size = USER_HEAP_MAX-USER_HEAP_START;
  801fc2:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801fc5:	c7 40 0c 00 00 00 20 	movl   $0x20000000,0xc(%eax)
	ourBlock->sva=USER_HEAP_START;
  801fcc:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801fcf:	c7 40 08 00 00 00 80 	movl   $0x80000000,0x8(%eax)
	LIST_INSERT_TAIL(&FreeMemBlocksList, ourBlock);
  801fd6:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  801fda:	75 14                	jne    801ff0 <initialize_dyn_block_system+0x18e>
  801fdc:	83 ec 04             	sub    $0x4,%esp
  801fdf:	68 60 44 80 00       	push   $0x804460
  801fe4:	6a 30                	push   $0x30
  801fe6:	68 53 44 80 00       	push   $0x804453
  801feb:	e8 03 ee ff ff       	call   800df3 <_panic>
  801ff0:	8b 15 3c 51 80 00    	mov    0x80513c,%edx
  801ff6:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801ff9:	89 50 04             	mov    %edx,0x4(%eax)
  801ffc:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801fff:	8b 40 04             	mov    0x4(%eax),%eax
  802002:	85 c0                	test   %eax,%eax
  802004:	74 0c                	je     802012 <initialize_dyn_block_system+0x1b0>
  802006:	a1 3c 51 80 00       	mov    0x80513c,%eax
  80200b:	8b 55 dc             	mov    -0x24(%ebp),%edx
  80200e:	89 10                	mov    %edx,(%eax)
  802010:	eb 08                	jmp    80201a <initialize_dyn_block_system+0x1b8>
  802012:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802015:	a3 38 51 80 00       	mov    %eax,0x805138
  80201a:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80201d:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802022:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802025:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80202b:	a1 44 51 80 00       	mov    0x805144,%eax
  802030:	40                   	inc    %eax
  802031:	a3 44 51 80 00       	mov    %eax,0x805144
	//[1] Initialize two lists (AllocMemBlocksList & FreeMemBlocksList) [Hint: use LIST_INIT()]
	//[2] Dynamically allocate the array of MemBlockNodes at VA USER_DYN_BLKS_ARRAY
	//	  (remember to set MAX_MEM_BLOCK_CNT with the chosen size of the array)
	//[3] Initialize AvailableMemBlocksList by filling it with the MemBlockNodes
	//[4] Insert a new MemBlock with the heap size into the FreeMemBlocksList
}
  802036:	90                   	nop
  802037:	c9                   	leave  
  802038:	c3                   	ret    

00802039 <malloc>:
//=================================
// [2] ALLOCATE SPACE IN USER HEAP:
//=================================

void* malloc(uint32 size)
{
  802039:	55                   	push   %ebp
  80203a:	89 e5                	mov    %esp,%ebp
  80203c:	83 ec 18             	sub    $0x18,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  80203f:	e8 ed fd ff ff       	call   801e31 <InitializeUHeap>
	if (size == 0) return NULL ;
  802044:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802048:	75 07                	jne    802051 <malloc+0x18>
  80204a:	b8 00 00 00 00       	mov    $0x0,%eax
  80204f:	eb 67                	jmp    8020b8 <malloc+0x7f>

	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] malloc
	// your code is here, remove the panic and write your code
	//panic("malloc() is not implemented yet...!!");

	size = ROUNDUP(size, PAGE_SIZE);
  802051:	c7 45 f4 00 10 00 00 	movl   $0x1000,-0xc(%ebp)
  802058:	8b 55 08             	mov    0x8(%ebp),%edx
  80205b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80205e:	01 d0                	add    %edx,%eax
  802060:	48                   	dec    %eax
  802061:	89 45 f0             	mov    %eax,-0x10(%ebp)
  802064:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802067:	ba 00 00 00 00       	mov    $0x0,%edx
  80206c:	f7 75 f4             	divl   -0xc(%ebp)
  80206f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802072:	29 d0                	sub    %edx,%eax
  802074:	89 45 08             	mov    %eax,0x8(%ebp)
	if(sys_isUHeapPlacementStrategyFIRSTFIT())
  802077:	e8 1a 08 00 00       	call   802896 <sys_isUHeapPlacementStrategyFIRSTFIT>
  80207c:	85 c0                	test   %eax,%eax
  80207e:	74 33                	je     8020b3 <malloc+0x7a>
	{
		struct MemBlock * myBlock = alloc_block_FF(size);
  802080:	83 ec 0c             	sub    $0xc,%esp
  802083:	ff 75 08             	pushl  0x8(%ebp)
  802086:	e8 0c 0e 00 00       	call   802e97 <alloc_block_FF>
  80208b:	83 c4 10             	add    $0x10,%esp
  80208e:	89 45 ec             	mov    %eax,-0x14(%ebp)
		if(myBlock != NULL)
  802091:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802095:	74 1c                	je     8020b3 <malloc+0x7a>
		{
			insert_sorted_allocList(myBlock);
  802097:	83 ec 0c             	sub    $0xc,%esp
  80209a:	ff 75 ec             	pushl  -0x14(%ebp)
  80209d:	e8 07 0c 00 00       	call   802ca9 <insert_sorted_allocList>
  8020a2:	83 c4 10             	add    $0x10,%esp
			uint32 ptr = myBlock->sva;
  8020a5:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8020a8:	8b 40 08             	mov    0x8(%eax),%eax
  8020ab:	89 45 e8             	mov    %eax,-0x18(%ebp)
			return (void *)ptr;
  8020ae:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8020b1:	eb 05                	jmp    8020b8 <malloc+0x7f>
		}
	}
	return NULL;
  8020b3:	b8 00 00 00 00       	mov    $0x0,%eax
	//		to the required allocation size (space should be on 4 KB BOUNDARY)
	//	2) if no suitable space found, return NULL
	// 	3) Return pointer containing the virtual address of allocated space,
	//
	//Use sys_isUHeapPlacementStrategyFIRSTFIT()... to check the current strategy
}
  8020b8:	c9                   	leave  
  8020b9:	c3                   	ret    

008020ba <free>:
//	We can use sys_free_user_mem(uint32 virtual_address, uint32 size); which
//		switches to the kernel mode, calls free_user_mem() in
//		"kern/mem/chunk_operations.c", then switch back to the user mode here
//	the free_user_mem function is empty, make sure to implement it.
void free(void* virtual_address)
{
  8020ba:	55                   	push   %ebp
  8020bb:	89 e5                	mov    %esp,%ebp
  8020bd:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] free
	// your code is here, remove the panic and write your code
	//panic("free() is not implemented yet...!!");

	uint32 virtualAddress = (uint32 )(virtual_address);
  8020c0:	8b 45 08             	mov    0x8(%ebp),%eax
  8020c3:	89 45 f4             	mov    %eax,-0xc(%ebp)
//	virtualAddress = ROUNDDOWN(virtualAddress, PAGE_SIZE);
	struct MemBlock * myBlock = find_block(&AllocMemBlocksList, virtualAddress);
  8020c6:	83 ec 08             	sub    $0x8,%esp
  8020c9:	ff 75 f4             	pushl  -0xc(%ebp)
  8020cc:	68 40 50 80 00       	push   $0x805040
  8020d1:	e8 5b 0b 00 00       	call   802c31 <find_block>
  8020d6:	83 c4 10             	add    $0x10,%esp
  8020d9:	89 45 f0             	mov    %eax,-0x10(%ebp)
//	cprintf ("ptr sva at free user side = %x \n", myBlock->sva);
	sys_free_user_mem(virtualAddress, myBlock->size);
  8020dc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8020df:	8b 40 0c             	mov    0xc(%eax),%eax
  8020e2:	83 ec 08             	sub    $0x8,%esp
  8020e5:	50                   	push   %eax
  8020e6:	ff 75 f4             	pushl  -0xc(%ebp)
  8020e9:	e8 a2 03 00 00       	call   802490 <sys_free_user_mem>
  8020ee:	83 c4 10             	add    $0x10,%esp
	LIST_REMOVE(&AllocMemBlocksList, myBlock);
  8020f1:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8020f5:	75 14                	jne    80210b <free+0x51>
  8020f7:	83 ec 04             	sub    $0x4,%esp
  8020fa:	68 35 44 80 00       	push   $0x804435
  8020ff:	6a 76                	push   $0x76
  802101:	68 53 44 80 00       	push   $0x804453
  802106:	e8 e8 ec ff ff       	call   800df3 <_panic>
  80210b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80210e:	8b 00                	mov    (%eax),%eax
  802110:	85 c0                	test   %eax,%eax
  802112:	74 10                	je     802124 <free+0x6a>
  802114:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802117:	8b 00                	mov    (%eax),%eax
  802119:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80211c:	8b 52 04             	mov    0x4(%edx),%edx
  80211f:	89 50 04             	mov    %edx,0x4(%eax)
  802122:	eb 0b                	jmp    80212f <free+0x75>
  802124:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802127:	8b 40 04             	mov    0x4(%eax),%eax
  80212a:	a3 44 50 80 00       	mov    %eax,0x805044
  80212f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802132:	8b 40 04             	mov    0x4(%eax),%eax
  802135:	85 c0                	test   %eax,%eax
  802137:	74 0f                	je     802148 <free+0x8e>
  802139:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80213c:	8b 40 04             	mov    0x4(%eax),%eax
  80213f:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802142:	8b 12                	mov    (%edx),%edx
  802144:	89 10                	mov    %edx,(%eax)
  802146:	eb 0a                	jmp    802152 <free+0x98>
  802148:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80214b:	8b 00                	mov    (%eax),%eax
  80214d:	a3 40 50 80 00       	mov    %eax,0x805040
  802152:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802155:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80215b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80215e:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802165:	a1 4c 50 80 00       	mov    0x80504c,%eax
  80216a:	48                   	dec    %eax
  80216b:	a3 4c 50 80 00       	mov    %eax,0x80504c
	insert_sorted_with_merge_freeList(myBlock);
  802170:	83 ec 0c             	sub    $0xc,%esp
  802173:	ff 75 f0             	pushl  -0x10(%ebp)
  802176:	e8 0b 14 00 00       	call   803586 <insert_sorted_with_merge_freeList>
  80217b:	83 c4 10             	add    $0x10,%esp

	//you should get the size of the given allocation using its address
	//you need to call sys_free_user_mem()
	//refer to the project presentation and documentation for details
}
  80217e:	90                   	nop
  80217f:	c9                   	leave  
  802180:	c3                   	ret    

00802181 <smalloc>:

//=================================
// [4] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
  802181:	55                   	push   %ebp
  802182:	89 e5                	mov    %esp,%ebp
  802184:	83 ec 28             	sub    $0x28,%esp
  802187:	8b 45 10             	mov    0x10(%ebp),%eax
  80218a:	88 45 e4             	mov    %al,-0x1c(%ebp)
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  80218d:	e8 9f fc ff ff       	call   801e31 <InitializeUHeap>
	if (size == 0) return NULL ;
  802192:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  802196:	75 0a                	jne    8021a2 <smalloc+0x21>
  802198:	b8 00 00 00 00       	mov    $0x0,%eax
  80219d:	e9 8d 00 00 00       	jmp    80222f <smalloc+0xae>

	//This function should find the space of the required range
	// * ON 4KB BOUNDARY **** //
	//Use sys_isUHeapPlacementStrategyFIRSTFIT() to check the current strategy

	size = ROUNDUP(size, PAGE_SIZE);
  8021a2:	c7 45 f4 00 10 00 00 	movl   $0x1000,-0xc(%ebp)
  8021a9:	8b 55 0c             	mov    0xc(%ebp),%edx
  8021ac:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021af:	01 d0                	add    %edx,%eax
  8021b1:	48                   	dec    %eax
  8021b2:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8021b5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8021b8:	ba 00 00 00 00       	mov    $0x0,%edx
  8021bd:	f7 75 f4             	divl   -0xc(%ebp)
  8021c0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8021c3:	29 d0                	sub    %edx,%eax
  8021c5:	89 45 0c             	mov    %eax,0xc(%ebp)
		if(sys_isUHeapPlacementStrategyFIRSTFIT())
  8021c8:	e8 c9 06 00 00       	call   802896 <sys_isUHeapPlacementStrategyFIRSTFIT>
  8021cd:	85 c0                	test   %eax,%eax
  8021cf:	74 59                	je     80222a <smalloc+0xa9>
		{
			struct MemBlock * v1=NULL;
  8021d1:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
			v1= alloc_block_FF(size);
  8021d8:	83 ec 0c             	sub    $0xc,%esp
  8021db:	ff 75 0c             	pushl  0xc(%ebp)
  8021de:	e8 b4 0c 00 00       	call   802e97 <alloc_block_FF>
  8021e3:	83 c4 10             	add    $0x10,%esp
  8021e6:	89 45 ec             	mov    %eax,-0x14(%ebp)
			if(v1==NULL)
  8021e9:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8021ed:	75 07                	jne    8021f6 <smalloc+0x75>
			{
				return NULL;
  8021ef:	b8 00 00 00 00       	mov    $0x0,%eax
  8021f4:	eb 39                	jmp    80222f <smalloc+0xae>
			}
			else
			{
				int ret=sys_createSharedObject(sharedVarName,  size,  isWritable,(void*)v1->sva);
  8021f6:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8021f9:	8b 40 08             	mov    0x8(%eax),%eax
  8021fc:	89 c2                	mov    %eax,%edx
  8021fe:	0f b6 45 e4          	movzbl -0x1c(%ebp),%eax
  802202:	52                   	push   %edx
  802203:	50                   	push   %eax
  802204:	ff 75 0c             	pushl  0xc(%ebp)
  802207:	ff 75 08             	pushl  0x8(%ebp)
  80220a:	e8 0c 04 00 00       	call   80261b <sys_createSharedObject>
  80220f:	83 c4 10             	add    $0x10,%esp
  802212:	89 45 e8             	mov    %eax,-0x18(%ebp)
				if(ret>=0)
  802215:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  802219:	78 08                	js     802223 <smalloc+0xa2>
				{
					return (void*)v1->sva;
  80221b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80221e:	8b 40 08             	mov    0x8(%eax),%eax
  802221:	eb 0c                	jmp    80222f <smalloc+0xae>
				}
				else
				{
					return NULL;
  802223:	b8 00 00 00 00       	mov    $0x0,%eax
  802228:	eb 05                	jmp    80222f <smalloc+0xae>
				}
			}

		}
		return NULL;
  80222a:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80222f:	c9                   	leave  
  802230:	c3                   	ret    

00802231 <sget>:

//========================================
// [5] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  802231:	55                   	push   %ebp
  802232:	89 e5                	mov    %esp,%ebp
  802234:	83 ec 18             	sub    $0x18,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  802237:	e8 f5 fb ff ff       	call   801e31 <InitializeUHeap>

	//This function should find the space for sharing the variable
	// *** ON 4KB BOUNDARY ******** //

	//Use sys_isUHeapPlacementStrategyFIRSTFIT() to check the current strategy
	int ret=sys_getSizeOfSharedObject(ownerEnvID,sharedVarName);
  80223c:	83 ec 08             	sub    $0x8,%esp
  80223f:	ff 75 0c             	pushl  0xc(%ebp)
  802242:	ff 75 08             	pushl  0x8(%ebp)
  802245:	e8 fb 03 00 00       	call   802645 <sys_getSizeOfSharedObject>
  80224a:	83 c4 10             	add    $0x10,%esp
  80224d:	89 45 f4             	mov    %eax,-0xc(%ebp)
	if(ret==0)
  802250:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802254:	75 07                	jne    80225d <sget+0x2c>
	{
		return NULL;
  802256:	b8 00 00 00 00       	mov    $0x0,%eax
  80225b:	eb 64                	jmp    8022c1 <sget+0x90>
	}
	if(sys_isUHeapPlacementStrategyFIRSTFIT())
  80225d:	e8 34 06 00 00       	call   802896 <sys_isUHeapPlacementStrategyFIRSTFIT>
  802262:	85 c0                	test   %eax,%eax
  802264:	74 56                	je     8022bc <sget+0x8b>
	{
		struct MemBlock * v1=NULL;
  802266:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
		v1= alloc_block_FF(ret);
  80226d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802270:	83 ec 0c             	sub    $0xc,%esp
  802273:	50                   	push   %eax
  802274:	e8 1e 0c 00 00       	call   802e97 <alloc_block_FF>
  802279:	83 c4 10             	add    $0x10,%esp
  80227c:	89 45 f0             	mov    %eax,-0x10(%ebp)
		if(v1==NULL)
  80227f:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802283:	75 07                	jne    80228c <sget+0x5b>
		{
		return NULL;
  802285:	b8 00 00 00 00       	mov    $0x0,%eax
  80228a:	eb 35                	jmp    8022c1 <sget+0x90>
	    }
		else
		{
			int ret1=sys_getSharedObject(ownerEnvID,sharedVarName,(void*)v1->sva);
  80228c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80228f:	8b 40 08             	mov    0x8(%eax),%eax
  802292:	83 ec 04             	sub    $0x4,%esp
  802295:	50                   	push   %eax
  802296:	ff 75 0c             	pushl  0xc(%ebp)
  802299:	ff 75 08             	pushl  0x8(%ebp)
  80229c:	e8 c1 03 00 00       	call   802662 <sys_getSharedObject>
  8022a1:	83 c4 10             	add    $0x10,%esp
  8022a4:	89 45 ec             	mov    %eax,-0x14(%ebp)
			if(ret1>=0)
  8022a7:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8022ab:	78 08                	js     8022b5 <sget+0x84>
			{
				return (void*)v1->sva;
  8022ad:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8022b0:	8b 40 08             	mov    0x8(%eax),%eax
  8022b3:	eb 0c                	jmp    8022c1 <sget+0x90>
			}
			else
			{
				return NULL;
  8022b5:	b8 00 00 00 00       	mov    $0x0,%eax
  8022ba:	eb 05                	jmp    8022c1 <sget+0x90>
			}
		}
	}
  return NULL;
  8022bc:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8022c1:	c9                   	leave  
  8022c2:	c3                   	ret    

008022c3 <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  8022c3:	55                   	push   %ebp
  8022c4:	89 e5                	mov    %esp,%ebp
  8022c6:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  8022c9:	e8 63 fb ff ff       	call   801e31 <InitializeUHeap>
	//==============================================================
	// [USER HEAP - USER SIDE] realloc
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  8022ce:	83 ec 04             	sub    $0x4,%esp
  8022d1:	68 84 44 80 00       	push   $0x804484
  8022d6:	68 0e 01 00 00       	push   $0x10e
  8022db:	68 53 44 80 00       	push   $0x804453
  8022e0:	e8 0e eb ff ff       	call   800df3 <_panic>

008022e5 <sfree>:
//	use sys_freeSharedObject(...); which switches to the kernel mode,
//	calls freeSharedObject(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the freeSharedObject() function is empty, make sure to implement it.

void sfree(void* virtual_address)
{
  8022e5:	55                   	push   %ebp
  8022e6:	89 e5                	mov    %esp,%ebp
  8022e8:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS3 - BONUS] [SHARING - USER SIDE] sfree()

	// Write your code here, remove the panic and write your code
	panic("sfree() is not implemented yet...!!");
  8022eb:	83 ec 04             	sub    $0x4,%esp
  8022ee:	68 ac 44 80 00       	push   $0x8044ac
  8022f3:	68 22 01 00 00       	push   $0x122
  8022f8:	68 53 44 80 00       	push   $0x804453
  8022fd:	e8 f1 ea ff ff       	call   800df3 <_panic>

00802302 <expand>:

//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//
void expand(uint32 newSize)
{
  802302:	55                   	push   %ebp
  802303:	89 e5                	mov    %esp,%ebp
  802305:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  802308:	83 ec 04             	sub    $0x4,%esp
  80230b:	68 d0 44 80 00       	push   $0x8044d0
  802310:	68 2d 01 00 00       	push   $0x12d
  802315:	68 53 44 80 00       	push   $0x804453
  80231a:	e8 d4 ea ff ff       	call   800df3 <_panic>

0080231f <shrink>:

}
void shrink(uint32 newSize)
{
  80231f:	55                   	push   %ebp
  802320:	89 e5                	mov    %esp,%ebp
  802322:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  802325:	83 ec 04             	sub    $0x4,%esp
  802328:	68 d0 44 80 00       	push   $0x8044d0
  80232d:	68 32 01 00 00       	push   $0x132
  802332:	68 53 44 80 00       	push   $0x804453
  802337:	e8 b7 ea ff ff       	call   800df3 <_panic>

0080233c <freeHeap>:

}
void freeHeap(void* virtual_address)
{
  80233c:	55                   	push   %ebp
  80233d:	89 e5                	mov    %esp,%ebp
  80233f:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  802342:	83 ec 04             	sub    $0x4,%esp
  802345:	68 d0 44 80 00       	push   $0x8044d0
  80234a:	68 37 01 00 00       	push   $0x137
  80234f:	68 53 44 80 00       	push   $0x804453
  802354:	e8 9a ea ff ff       	call   800df3 <_panic>

00802359 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  802359:	55                   	push   %ebp
  80235a:	89 e5                	mov    %esp,%ebp
  80235c:	57                   	push   %edi
  80235d:	56                   	push   %esi
  80235e:	53                   	push   %ebx
  80235f:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  802362:	8b 45 08             	mov    0x8(%ebp),%eax
  802365:	8b 55 0c             	mov    0xc(%ebp),%edx
  802368:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80236b:	8b 5d 14             	mov    0x14(%ebp),%ebx
  80236e:	8b 7d 18             	mov    0x18(%ebp),%edi
  802371:	8b 75 1c             	mov    0x1c(%ebp),%esi
  802374:	cd 30                	int    $0x30
  802376:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  802379:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  80237c:	83 c4 10             	add    $0x10,%esp
  80237f:	5b                   	pop    %ebx
  802380:	5e                   	pop    %esi
  802381:	5f                   	pop    %edi
  802382:	5d                   	pop    %ebp
  802383:	c3                   	ret    

00802384 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  802384:	55                   	push   %ebp
  802385:	89 e5                	mov    %esp,%ebp
  802387:	83 ec 04             	sub    $0x4,%esp
  80238a:	8b 45 10             	mov    0x10(%ebp),%eax
  80238d:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  802390:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  802394:	8b 45 08             	mov    0x8(%ebp),%eax
  802397:	6a 00                	push   $0x0
  802399:	6a 00                	push   $0x0
  80239b:	52                   	push   %edx
  80239c:	ff 75 0c             	pushl  0xc(%ebp)
  80239f:	50                   	push   %eax
  8023a0:	6a 00                	push   $0x0
  8023a2:	e8 b2 ff ff ff       	call   802359 <syscall>
  8023a7:	83 c4 18             	add    $0x18,%esp
}
  8023aa:	90                   	nop
  8023ab:	c9                   	leave  
  8023ac:	c3                   	ret    

008023ad <sys_cgetc>:

int
sys_cgetc(void)
{
  8023ad:	55                   	push   %ebp
  8023ae:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  8023b0:	6a 00                	push   $0x0
  8023b2:	6a 00                	push   $0x0
  8023b4:	6a 00                	push   $0x0
  8023b6:	6a 00                	push   $0x0
  8023b8:	6a 00                	push   $0x0
  8023ba:	6a 01                	push   $0x1
  8023bc:	e8 98 ff ff ff       	call   802359 <syscall>
  8023c1:	83 c4 18             	add    $0x18,%esp
}
  8023c4:	c9                   	leave  
  8023c5:	c3                   	ret    

008023c6 <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  8023c6:	55                   	push   %ebp
  8023c7:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  8023c9:	8b 55 0c             	mov    0xc(%ebp),%edx
  8023cc:	8b 45 08             	mov    0x8(%ebp),%eax
  8023cf:	6a 00                	push   $0x0
  8023d1:	6a 00                	push   $0x0
  8023d3:	6a 00                	push   $0x0
  8023d5:	52                   	push   %edx
  8023d6:	50                   	push   %eax
  8023d7:	6a 05                	push   $0x5
  8023d9:	e8 7b ff ff ff       	call   802359 <syscall>
  8023de:	83 c4 18             	add    $0x18,%esp
}
  8023e1:	c9                   	leave  
  8023e2:	c3                   	ret    

008023e3 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  8023e3:	55                   	push   %ebp
  8023e4:	89 e5                	mov    %esp,%ebp
  8023e6:	56                   	push   %esi
  8023e7:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  8023e8:	8b 75 18             	mov    0x18(%ebp),%esi
  8023eb:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8023ee:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8023f1:	8b 55 0c             	mov    0xc(%ebp),%edx
  8023f4:	8b 45 08             	mov    0x8(%ebp),%eax
  8023f7:	56                   	push   %esi
  8023f8:	53                   	push   %ebx
  8023f9:	51                   	push   %ecx
  8023fa:	52                   	push   %edx
  8023fb:	50                   	push   %eax
  8023fc:	6a 06                	push   $0x6
  8023fe:	e8 56 ff ff ff       	call   802359 <syscall>
  802403:	83 c4 18             	add    $0x18,%esp
}
  802406:	8d 65 f8             	lea    -0x8(%ebp),%esp
  802409:	5b                   	pop    %ebx
  80240a:	5e                   	pop    %esi
  80240b:	5d                   	pop    %ebp
  80240c:	c3                   	ret    

0080240d <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  80240d:	55                   	push   %ebp
  80240e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  802410:	8b 55 0c             	mov    0xc(%ebp),%edx
  802413:	8b 45 08             	mov    0x8(%ebp),%eax
  802416:	6a 00                	push   $0x0
  802418:	6a 00                	push   $0x0
  80241a:	6a 00                	push   $0x0
  80241c:	52                   	push   %edx
  80241d:	50                   	push   %eax
  80241e:	6a 07                	push   $0x7
  802420:	e8 34 ff ff ff       	call   802359 <syscall>
  802425:	83 c4 18             	add    $0x18,%esp
}
  802428:	c9                   	leave  
  802429:	c3                   	ret    

0080242a <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  80242a:	55                   	push   %ebp
  80242b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  80242d:	6a 00                	push   $0x0
  80242f:	6a 00                	push   $0x0
  802431:	6a 00                	push   $0x0
  802433:	ff 75 0c             	pushl  0xc(%ebp)
  802436:	ff 75 08             	pushl  0x8(%ebp)
  802439:	6a 08                	push   $0x8
  80243b:	e8 19 ff ff ff       	call   802359 <syscall>
  802440:	83 c4 18             	add    $0x18,%esp
}
  802443:	c9                   	leave  
  802444:	c3                   	ret    

00802445 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  802445:	55                   	push   %ebp
  802446:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  802448:	6a 00                	push   $0x0
  80244a:	6a 00                	push   $0x0
  80244c:	6a 00                	push   $0x0
  80244e:	6a 00                	push   $0x0
  802450:	6a 00                	push   $0x0
  802452:	6a 09                	push   $0x9
  802454:	e8 00 ff ff ff       	call   802359 <syscall>
  802459:	83 c4 18             	add    $0x18,%esp
}
  80245c:	c9                   	leave  
  80245d:	c3                   	ret    

0080245e <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  80245e:	55                   	push   %ebp
  80245f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  802461:	6a 00                	push   $0x0
  802463:	6a 00                	push   $0x0
  802465:	6a 00                	push   $0x0
  802467:	6a 00                	push   $0x0
  802469:	6a 00                	push   $0x0
  80246b:	6a 0a                	push   $0xa
  80246d:	e8 e7 fe ff ff       	call   802359 <syscall>
  802472:	83 c4 18             	add    $0x18,%esp
}
  802475:	c9                   	leave  
  802476:	c3                   	ret    

00802477 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  802477:	55                   	push   %ebp
  802478:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  80247a:	6a 00                	push   $0x0
  80247c:	6a 00                	push   $0x0
  80247e:	6a 00                	push   $0x0
  802480:	6a 00                	push   $0x0
  802482:	6a 00                	push   $0x0
  802484:	6a 0b                	push   $0xb
  802486:	e8 ce fe ff ff       	call   802359 <syscall>
  80248b:	83 c4 18             	add    $0x18,%esp
}
  80248e:	c9                   	leave  
  80248f:	c3                   	ret    

00802490 <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  802490:	55                   	push   %ebp
  802491:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  802493:	6a 00                	push   $0x0
  802495:	6a 00                	push   $0x0
  802497:	6a 00                	push   $0x0
  802499:	ff 75 0c             	pushl  0xc(%ebp)
  80249c:	ff 75 08             	pushl  0x8(%ebp)
  80249f:	6a 0f                	push   $0xf
  8024a1:	e8 b3 fe ff ff       	call   802359 <syscall>
  8024a6:	83 c4 18             	add    $0x18,%esp
	return;
  8024a9:	90                   	nop
}
  8024aa:	c9                   	leave  
  8024ab:	c3                   	ret    

008024ac <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  8024ac:	55                   	push   %ebp
  8024ad:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  8024af:	6a 00                	push   $0x0
  8024b1:	6a 00                	push   $0x0
  8024b3:	6a 00                	push   $0x0
  8024b5:	ff 75 0c             	pushl  0xc(%ebp)
  8024b8:	ff 75 08             	pushl  0x8(%ebp)
  8024bb:	6a 10                	push   $0x10
  8024bd:	e8 97 fe ff ff       	call   802359 <syscall>
  8024c2:	83 c4 18             	add    $0x18,%esp
	return ;
  8024c5:	90                   	nop
}
  8024c6:	c9                   	leave  
  8024c7:	c3                   	ret    

008024c8 <sys_allocate_chunk>:

void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  8024c8:	55                   	push   %ebp
  8024c9:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  8024cb:	6a 00                	push   $0x0
  8024cd:	6a 00                	push   $0x0
  8024cf:	ff 75 10             	pushl  0x10(%ebp)
  8024d2:	ff 75 0c             	pushl  0xc(%ebp)
  8024d5:	ff 75 08             	pushl  0x8(%ebp)
  8024d8:	6a 11                	push   $0x11
  8024da:	e8 7a fe ff ff       	call   802359 <syscall>
  8024df:	83 c4 18             	add    $0x18,%esp
	return ;
  8024e2:	90                   	nop
}
  8024e3:	c9                   	leave  
  8024e4:	c3                   	ret    

008024e5 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  8024e5:	55                   	push   %ebp
  8024e6:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  8024e8:	6a 00                	push   $0x0
  8024ea:	6a 00                	push   $0x0
  8024ec:	6a 00                	push   $0x0
  8024ee:	6a 00                	push   $0x0
  8024f0:	6a 00                	push   $0x0
  8024f2:	6a 0c                	push   $0xc
  8024f4:	e8 60 fe ff ff       	call   802359 <syscall>
  8024f9:	83 c4 18             	add    $0x18,%esp
}
  8024fc:	c9                   	leave  
  8024fd:	c3                   	ret    

008024fe <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  8024fe:	55                   	push   %ebp
  8024ff:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  802501:	6a 00                	push   $0x0
  802503:	6a 00                	push   $0x0
  802505:	6a 00                	push   $0x0
  802507:	6a 00                	push   $0x0
  802509:	ff 75 08             	pushl  0x8(%ebp)
  80250c:	6a 0d                	push   $0xd
  80250e:	e8 46 fe ff ff       	call   802359 <syscall>
  802513:	83 c4 18             	add    $0x18,%esp
}
  802516:	c9                   	leave  
  802517:	c3                   	ret    

00802518 <sys_scarce_memory>:

void sys_scarce_memory()
{
  802518:	55                   	push   %ebp
  802519:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  80251b:	6a 00                	push   $0x0
  80251d:	6a 00                	push   $0x0
  80251f:	6a 00                	push   $0x0
  802521:	6a 00                	push   $0x0
  802523:	6a 00                	push   $0x0
  802525:	6a 0e                	push   $0xe
  802527:	e8 2d fe ff ff       	call   802359 <syscall>
  80252c:	83 c4 18             	add    $0x18,%esp
}
  80252f:	90                   	nop
  802530:	c9                   	leave  
  802531:	c3                   	ret    

00802532 <sys_disable_interrupt>:

//NEW !! 2012...
void
sys_disable_interrupt()
{
  802532:	55                   	push   %ebp
  802533:	89 e5                	mov    %esp,%ebp
	syscall(SYS_disableINTR,0, 0, 0, 0, 0);
  802535:	6a 00                	push   $0x0
  802537:	6a 00                	push   $0x0
  802539:	6a 00                	push   $0x0
  80253b:	6a 00                	push   $0x0
  80253d:	6a 00                	push   $0x0
  80253f:	6a 13                	push   $0x13
  802541:	e8 13 fe ff ff       	call   802359 <syscall>
  802546:	83 c4 18             	add    $0x18,%esp
}
  802549:	90                   	nop
  80254a:	c9                   	leave  
  80254b:	c3                   	ret    

0080254c <sys_enable_interrupt>:


void
sys_enable_interrupt()
{
  80254c:	55                   	push   %ebp
  80254d:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enableINTR,0, 0, 0, 0, 0);
  80254f:	6a 00                	push   $0x0
  802551:	6a 00                	push   $0x0
  802553:	6a 00                	push   $0x0
  802555:	6a 00                	push   $0x0
  802557:	6a 00                	push   $0x0
  802559:	6a 14                	push   $0x14
  80255b:	e8 f9 fd ff ff       	call   802359 <syscall>
  802560:	83 c4 18             	add    $0x18,%esp
}
  802563:	90                   	nop
  802564:	c9                   	leave  
  802565:	c3                   	ret    

00802566 <sys_cputc>:


void
sys_cputc(const char c)
{
  802566:	55                   	push   %ebp
  802567:	89 e5                	mov    %esp,%ebp
  802569:	83 ec 04             	sub    $0x4,%esp
  80256c:	8b 45 08             	mov    0x8(%ebp),%eax
  80256f:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  802572:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  802576:	6a 00                	push   $0x0
  802578:	6a 00                	push   $0x0
  80257a:	6a 00                	push   $0x0
  80257c:	6a 00                	push   $0x0
  80257e:	50                   	push   %eax
  80257f:	6a 15                	push   $0x15
  802581:	e8 d3 fd ff ff       	call   802359 <syscall>
  802586:	83 c4 18             	add    $0x18,%esp
}
  802589:	90                   	nop
  80258a:	c9                   	leave  
  80258b:	c3                   	ret    

0080258c <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  80258c:	55                   	push   %ebp
  80258d:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  80258f:	6a 00                	push   $0x0
  802591:	6a 00                	push   $0x0
  802593:	6a 00                	push   $0x0
  802595:	6a 00                	push   $0x0
  802597:	6a 00                	push   $0x0
  802599:	6a 16                	push   $0x16
  80259b:	e8 b9 fd ff ff       	call   802359 <syscall>
  8025a0:	83 c4 18             	add    $0x18,%esp
}
  8025a3:	90                   	nop
  8025a4:	c9                   	leave  
  8025a5:	c3                   	ret    

008025a6 <sys_createSemaphore>:

int
sys_createSemaphore(char* semaphoreName, uint32 initialValue)
{
  8025a6:	55                   	push   %ebp
  8025a7:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_semaphore,(uint32)semaphoreName, (uint32)initialValue, 0, 0, 0);
  8025a9:	8b 45 08             	mov    0x8(%ebp),%eax
  8025ac:	6a 00                	push   $0x0
  8025ae:	6a 00                	push   $0x0
  8025b0:	6a 00                	push   $0x0
  8025b2:	ff 75 0c             	pushl  0xc(%ebp)
  8025b5:	50                   	push   %eax
  8025b6:	6a 17                	push   $0x17
  8025b8:	e8 9c fd ff ff       	call   802359 <syscall>
  8025bd:	83 c4 18             	add    $0x18,%esp
}
  8025c0:	c9                   	leave  
  8025c1:	c3                   	ret    

008025c2 <sys_getSemaphoreValue>:

int
sys_getSemaphoreValue(int32 ownerEnvID, char* semaphoreName)
{
  8025c2:	55                   	push   %ebp
  8025c3:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_semaphore_value,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  8025c5:	8b 55 0c             	mov    0xc(%ebp),%edx
  8025c8:	8b 45 08             	mov    0x8(%ebp),%eax
  8025cb:	6a 00                	push   $0x0
  8025cd:	6a 00                	push   $0x0
  8025cf:	6a 00                	push   $0x0
  8025d1:	52                   	push   %edx
  8025d2:	50                   	push   %eax
  8025d3:	6a 1a                	push   $0x1a
  8025d5:	e8 7f fd ff ff       	call   802359 <syscall>
  8025da:	83 c4 18             	add    $0x18,%esp
}
  8025dd:	c9                   	leave  
  8025de:	c3                   	ret    

008025df <sys_waitSemaphore>:

void
sys_waitSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  8025df:	55                   	push   %ebp
  8025e0:	89 e5                	mov    %esp,%ebp
	syscall(SYS_wait_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  8025e2:	8b 55 0c             	mov    0xc(%ebp),%edx
  8025e5:	8b 45 08             	mov    0x8(%ebp),%eax
  8025e8:	6a 00                	push   $0x0
  8025ea:	6a 00                	push   $0x0
  8025ec:	6a 00                	push   $0x0
  8025ee:	52                   	push   %edx
  8025ef:	50                   	push   %eax
  8025f0:	6a 18                	push   $0x18
  8025f2:	e8 62 fd ff ff       	call   802359 <syscall>
  8025f7:	83 c4 18             	add    $0x18,%esp
}
  8025fa:	90                   	nop
  8025fb:	c9                   	leave  
  8025fc:	c3                   	ret    

008025fd <sys_signalSemaphore>:

void
sys_signalSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  8025fd:	55                   	push   %ebp
  8025fe:	89 e5                	mov    %esp,%ebp
	syscall(SYS_signal_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  802600:	8b 55 0c             	mov    0xc(%ebp),%edx
  802603:	8b 45 08             	mov    0x8(%ebp),%eax
  802606:	6a 00                	push   $0x0
  802608:	6a 00                	push   $0x0
  80260a:	6a 00                	push   $0x0
  80260c:	52                   	push   %edx
  80260d:	50                   	push   %eax
  80260e:	6a 19                	push   $0x19
  802610:	e8 44 fd ff ff       	call   802359 <syscall>
  802615:	83 c4 18             	add    $0x18,%esp
}
  802618:	90                   	nop
  802619:	c9                   	leave  
  80261a:	c3                   	ret    

0080261b <sys_createSharedObject>:

int
sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  80261b:	55                   	push   %ebp
  80261c:	89 e5                	mov    %esp,%ebp
  80261e:	83 ec 04             	sub    $0x4,%esp
  802621:	8b 45 10             	mov    0x10(%ebp),%eax
  802624:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  802627:	8b 4d 14             	mov    0x14(%ebp),%ecx
  80262a:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  80262e:	8b 45 08             	mov    0x8(%ebp),%eax
  802631:	6a 00                	push   $0x0
  802633:	51                   	push   %ecx
  802634:	52                   	push   %edx
  802635:	ff 75 0c             	pushl  0xc(%ebp)
  802638:	50                   	push   %eax
  802639:	6a 1b                	push   $0x1b
  80263b:	e8 19 fd ff ff       	call   802359 <syscall>
  802640:	83 c4 18             	add    $0x18,%esp
}
  802643:	c9                   	leave  
  802644:	c3                   	ret    

00802645 <sys_getSizeOfSharedObject>:

//2017:
int
sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  802645:	55                   	push   %ebp
  802646:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  802648:	8b 55 0c             	mov    0xc(%ebp),%edx
  80264b:	8b 45 08             	mov    0x8(%ebp),%eax
  80264e:	6a 00                	push   $0x0
  802650:	6a 00                	push   $0x0
  802652:	6a 00                	push   $0x0
  802654:	52                   	push   %edx
  802655:	50                   	push   %eax
  802656:	6a 1c                	push   $0x1c
  802658:	e8 fc fc ff ff       	call   802359 <syscall>
  80265d:	83 c4 18             	add    $0x18,%esp
}
  802660:	c9                   	leave  
  802661:	c3                   	ret    

00802662 <sys_getSharedObject>:
//==========

int
sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  802662:	55                   	push   %ebp
  802663:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  802665:	8b 4d 10             	mov    0x10(%ebp),%ecx
  802668:	8b 55 0c             	mov    0xc(%ebp),%edx
  80266b:	8b 45 08             	mov    0x8(%ebp),%eax
  80266e:	6a 00                	push   $0x0
  802670:	6a 00                	push   $0x0
  802672:	51                   	push   %ecx
  802673:	52                   	push   %edx
  802674:	50                   	push   %eax
  802675:	6a 1d                	push   $0x1d
  802677:	e8 dd fc ff ff       	call   802359 <syscall>
  80267c:	83 c4 18             	add    $0x18,%esp
}
  80267f:	c9                   	leave  
  802680:	c3                   	ret    

00802681 <sys_freeSharedObject>:

int
sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  802681:	55                   	push   %ebp
  802682:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  802684:	8b 55 0c             	mov    0xc(%ebp),%edx
  802687:	8b 45 08             	mov    0x8(%ebp),%eax
  80268a:	6a 00                	push   $0x0
  80268c:	6a 00                	push   $0x0
  80268e:	6a 00                	push   $0x0
  802690:	52                   	push   %edx
  802691:	50                   	push   %eax
  802692:	6a 1e                	push   $0x1e
  802694:	e8 c0 fc ff ff       	call   802359 <syscall>
  802699:	83 c4 18             	add    $0x18,%esp
}
  80269c:	c9                   	leave  
  80269d:	c3                   	ret    

0080269e <sys_getMaxShares>:

uint32 	sys_getMaxShares()
{
  80269e:	55                   	push   %ebp
  80269f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_max_shares,0, 0, 0, 0, 0);
  8026a1:	6a 00                	push   $0x0
  8026a3:	6a 00                	push   $0x0
  8026a5:	6a 00                	push   $0x0
  8026a7:	6a 00                	push   $0x0
  8026a9:	6a 00                	push   $0x0
  8026ab:	6a 1f                	push   $0x1f
  8026ad:	e8 a7 fc ff ff       	call   802359 <syscall>
  8026b2:	83 c4 18             	add    $0x18,%esp
}
  8026b5:	c9                   	leave  
  8026b6:	c3                   	ret    

008026b7 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  8026b7:	55                   	push   %ebp
  8026b8:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  8026ba:	8b 45 08             	mov    0x8(%ebp),%eax
  8026bd:	6a 00                	push   $0x0
  8026bf:	ff 75 14             	pushl  0x14(%ebp)
  8026c2:	ff 75 10             	pushl  0x10(%ebp)
  8026c5:	ff 75 0c             	pushl  0xc(%ebp)
  8026c8:	50                   	push   %eax
  8026c9:	6a 20                	push   $0x20
  8026cb:	e8 89 fc ff ff       	call   802359 <syscall>
  8026d0:	83 c4 18             	add    $0x18,%esp
}
  8026d3:	c9                   	leave  
  8026d4:	c3                   	ret    

008026d5 <sys_run_env>:

void
sys_run_env(int32 envId)
{
  8026d5:	55                   	push   %ebp
  8026d6:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  8026d8:	8b 45 08             	mov    0x8(%ebp),%eax
  8026db:	6a 00                	push   $0x0
  8026dd:	6a 00                	push   $0x0
  8026df:	6a 00                	push   $0x0
  8026e1:	6a 00                	push   $0x0
  8026e3:	50                   	push   %eax
  8026e4:	6a 21                	push   $0x21
  8026e6:	e8 6e fc ff ff       	call   802359 <syscall>
  8026eb:	83 c4 18             	add    $0x18,%esp
}
  8026ee:	90                   	nop
  8026ef:	c9                   	leave  
  8026f0:	c3                   	ret    

008026f1 <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  8026f1:	55                   	push   %ebp
  8026f2:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  8026f4:	8b 45 08             	mov    0x8(%ebp),%eax
  8026f7:	6a 00                	push   $0x0
  8026f9:	6a 00                	push   $0x0
  8026fb:	6a 00                	push   $0x0
  8026fd:	6a 00                	push   $0x0
  8026ff:	50                   	push   %eax
  802700:	6a 22                	push   $0x22
  802702:	e8 52 fc ff ff       	call   802359 <syscall>
  802707:	83 c4 18             	add    $0x18,%esp
}
  80270a:	c9                   	leave  
  80270b:	c3                   	ret    

0080270c <sys_getenvid>:

int32 sys_getenvid(void)
{
  80270c:	55                   	push   %ebp
  80270d:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  80270f:	6a 00                	push   $0x0
  802711:	6a 00                	push   $0x0
  802713:	6a 00                	push   $0x0
  802715:	6a 00                	push   $0x0
  802717:	6a 00                	push   $0x0
  802719:	6a 02                	push   $0x2
  80271b:	e8 39 fc ff ff       	call   802359 <syscall>
  802720:	83 c4 18             	add    $0x18,%esp
}
  802723:	c9                   	leave  
  802724:	c3                   	ret    

00802725 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  802725:	55                   	push   %ebp
  802726:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  802728:	6a 00                	push   $0x0
  80272a:	6a 00                	push   $0x0
  80272c:	6a 00                	push   $0x0
  80272e:	6a 00                	push   $0x0
  802730:	6a 00                	push   $0x0
  802732:	6a 03                	push   $0x3
  802734:	e8 20 fc ff ff       	call   802359 <syscall>
  802739:	83 c4 18             	add    $0x18,%esp
}
  80273c:	c9                   	leave  
  80273d:	c3                   	ret    

0080273e <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  80273e:	55                   	push   %ebp
  80273f:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  802741:	6a 00                	push   $0x0
  802743:	6a 00                	push   $0x0
  802745:	6a 00                	push   $0x0
  802747:	6a 00                	push   $0x0
  802749:	6a 00                	push   $0x0
  80274b:	6a 04                	push   $0x4
  80274d:	e8 07 fc ff ff       	call   802359 <syscall>
  802752:	83 c4 18             	add    $0x18,%esp
}
  802755:	c9                   	leave  
  802756:	c3                   	ret    

00802757 <sys_exit_env>:


void sys_exit_env(void)
{
  802757:	55                   	push   %ebp
  802758:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  80275a:	6a 00                	push   $0x0
  80275c:	6a 00                	push   $0x0
  80275e:	6a 00                	push   $0x0
  802760:	6a 00                	push   $0x0
  802762:	6a 00                	push   $0x0
  802764:	6a 23                	push   $0x23
  802766:	e8 ee fb ff ff       	call   802359 <syscall>
  80276b:	83 c4 18             	add    $0x18,%esp
}
  80276e:	90                   	nop
  80276f:	c9                   	leave  
  802770:	c3                   	ret    

00802771 <sys_get_virtual_time>:


struct uint64
sys_get_virtual_time()
{
  802771:	55                   	push   %ebp
  802772:	89 e5                	mov    %esp,%ebp
  802774:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  802777:	8d 45 f8             	lea    -0x8(%ebp),%eax
  80277a:	8d 50 04             	lea    0x4(%eax),%edx
  80277d:	8d 45 f8             	lea    -0x8(%ebp),%eax
  802780:	6a 00                	push   $0x0
  802782:	6a 00                	push   $0x0
  802784:	6a 00                	push   $0x0
  802786:	52                   	push   %edx
  802787:	50                   	push   %eax
  802788:	6a 24                	push   $0x24
  80278a:	e8 ca fb ff ff       	call   802359 <syscall>
  80278f:	83 c4 18             	add    $0x18,%esp
	return result;
  802792:	8b 4d 08             	mov    0x8(%ebp),%ecx
  802795:	8b 45 f8             	mov    -0x8(%ebp),%eax
  802798:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80279b:	89 01                	mov    %eax,(%ecx)
  80279d:	89 51 04             	mov    %edx,0x4(%ecx)
}
  8027a0:	8b 45 08             	mov    0x8(%ebp),%eax
  8027a3:	c9                   	leave  
  8027a4:	c2 04 00             	ret    $0x4

008027a7 <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  8027a7:	55                   	push   %ebp
  8027a8:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  8027aa:	6a 00                	push   $0x0
  8027ac:	6a 00                	push   $0x0
  8027ae:	ff 75 10             	pushl  0x10(%ebp)
  8027b1:	ff 75 0c             	pushl  0xc(%ebp)
  8027b4:	ff 75 08             	pushl  0x8(%ebp)
  8027b7:	6a 12                	push   $0x12
  8027b9:	e8 9b fb ff ff       	call   802359 <syscall>
  8027be:	83 c4 18             	add    $0x18,%esp
	return ;
  8027c1:	90                   	nop
}
  8027c2:	c9                   	leave  
  8027c3:	c3                   	ret    

008027c4 <sys_rcr2>:
uint32 sys_rcr2()
{
  8027c4:	55                   	push   %ebp
  8027c5:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  8027c7:	6a 00                	push   $0x0
  8027c9:	6a 00                	push   $0x0
  8027cb:	6a 00                	push   $0x0
  8027cd:	6a 00                	push   $0x0
  8027cf:	6a 00                	push   $0x0
  8027d1:	6a 25                	push   $0x25
  8027d3:	e8 81 fb ff ff       	call   802359 <syscall>
  8027d8:	83 c4 18             	add    $0x18,%esp
}
  8027db:	c9                   	leave  
  8027dc:	c3                   	ret    

008027dd <sys_bypassPageFault>:
void sys_bypassPageFault(uint8 instrLength)
{
  8027dd:	55                   	push   %ebp
  8027de:	89 e5                	mov    %esp,%ebp
  8027e0:	83 ec 04             	sub    $0x4,%esp
  8027e3:	8b 45 08             	mov    0x8(%ebp),%eax
  8027e6:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  8027e9:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  8027ed:	6a 00                	push   $0x0
  8027ef:	6a 00                	push   $0x0
  8027f1:	6a 00                	push   $0x0
  8027f3:	6a 00                	push   $0x0
  8027f5:	50                   	push   %eax
  8027f6:	6a 26                	push   $0x26
  8027f8:	e8 5c fb ff ff       	call   802359 <syscall>
  8027fd:	83 c4 18             	add    $0x18,%esp
	return ;
  802800:	90                   	nop
}
  802801:	c9                   	leave  
  802802:	c3                   	ret    

00802803 <rsttst>:
void rsttst()
{
  802803:	55                   	push   %ebp
  802804:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  802806:	6a 00                	push   $0x0
  802808:	6a 00                	push   $0x0
  80280a:	6a 00                	push   $0x0
  80280c:	6a 00                	push   $0x0
  80280e:	6a 00                	push   $0x0
  802810:	6a 28                	push   $0x28
  802812:	e8 42 fb ff ff       	call   802359 <syscall>
  802817:	83 c4 18             	add    $0x18,%esp
	return ;
  80281a:	90                   	nop
}
  80281b:	c9                   	leave  
  80281c:	c3                   	ret    

0080281d <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  80281d:	55                   	push   %ebp
  80281e:	89 e5                	mov    %esp,%ebp
  802820:	83 ec 04             	sub    $0x4,%esp
  802823:	8b 45 14             	mov    0x14(%ebp),%eax
  802826:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  802829:	8b 55 18             	mov    0x18(%ebp),%edx
  80282c:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  802830:	52                   	push   %edx
  802831:	50                   	push   %eax
  802832:	ff 75 10             	pushl  0x10(%ebp)
  802835:	ff 75 0c             	pushl  0xc(%ebp)
  802838:	ff 75 08             	pushl  0x8(%ebp)
  80283b:	6a 27                	push   $0x27
  80283d:	e8 17 fb ff ff       	call   802359 <syscall>
  802842:	83 c4 18             	add    $0x18,%esp
	return ;
  802845:	90                   	nop
}
  802846:	c9                   	leave  
  802847:	c3                   	ret    

00802848 <chktst>:
void chktst(uint32 n)
{
  802848:	55                   	push   %ebp
  802849:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  80284b:	6a 00                	push   $0x0
  80284d:	6a 00                	push   $0x0
  80284f:	6a 00                	push   $0x0
  802851:	6a 00                	push   $0x0
  802853:	ff 75 08             	pushl  0x8(%ebp)
  802856:	6a 29                	push   $0x29
  802858:	e8 fc fa ff ff       	call   802359 <syscall>
  80285d:	83 c4 18             	add    $0x18,%esp
	return ;
  802860:	90                   	nop
}
  802861:	c9                   	leave  
  802862:	c3                   	ret    

00802863 <inctst>:

void inctst()
{
  802863:	55                   	push   %ebp
  802864:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  802866:	6a 00                	push   $0x0
  802868:	6a 00                	push   $0x0
  80286a:	6a 00                	push   $0x0
  80286c:	6a 00                	push   $0x0
  80286e:	6a 00                	push   $0x0
  802870:	6a 2a                	push   $0x2a
  802872:	e8 e2 fa ff ff       	call   802359 <syscall>
  802877:	83 c4 18             	add    $0x18,%esp
	return ;
  80287a:	90                   	nop
}
  80287b:	c9                   	leave  
  80287c:	c3                   	ret    

0080287d <gettst>:
uint32 gettst()
{
  80287d:	55                   	push   %ebp
  80287e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  802880:	6a 00                	push   $0x0
  802882:	6a 00                	push   $0x0
  802884:	6a 00                	push   $0x0
  802886:	6a 00                	push   $0x0
  802888:	6a 00                	push   $0x0
  80288a:	6a 2b                	push   $0x2b
  80288c:	e8 c8 fa ff ff       	call   802359 <syscall>
  802891:	83 c4 18             	add    $0x18,%esp
}
  802894:	c9                   	leave  
  802895:	c3                   	ret    

00802896 <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  802896:	55                   	push   %ebp
  802897:	89 e5                	mov    %esp,%ebp
  802899:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  80289c:	6a 00                	push   $0x0
  80289e:	6a 00                	push   $0x0
  8028a0:	6a 00                	push   $0x0
  8028a2:	6a 00                	push   $0x0
  8028a4:	6a 00                	push   $0x0
  8028a6:	6a 2c                	push   $0x2c
  8028a8:	e8 ac fa ff ff       	call   802359 <syscall>
  8028ad:	83 c4 18             	add    $0x18,%esp
  8028b0:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  8028b3:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  8028b7:	75 07                	jne    8028c0 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  8028b9:	b8 01 00 00 00       	mov    $0x1,%eax
  8028be:	eb 05                	jmp    8028c5 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  8028c0:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8028c5:	c9                   	leave  
  8028c6:	c3                   	ret    

008028c7 <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  8028c7:	55                   	push   %ebp
  8028c8:	89 e5                	mov    %esp,%ebp
  8028ca:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8028cd:	6a 00                	push   $0x0
  8028cf:	6a 00                	push   $0x0
  8028d1:	6a 00                	push   $0x0
  8028d3:	6a 00                	push   $0x0
  8028d5:	6a 00                	push   $0x0
  8028d7:	6a 2c                	push   $0x2c
  8028d9:	e8 7b fa ff ff       	call   802359 <syscall>
  8028de:	83 c4 18             	add    $0x18,%esp
  8028e1:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  8028e4:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  8028e8:	75 07                	jne    8028f1 <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  8028ea:	b8 01 00 00 00       	mov    $0x1,%eax
  8028ef:	eb 05                	jmp    8028f6 <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  8028f1:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8028f6:	c9                   	leave  
  8028f7:	c3                   	ret    

008028f8 <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  8028f8:	55                   	push   %ebp
  8028f9:	89 e5                	mov    %esp,%ebp
  8028fb:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8028fe:	6a 00                	push   $0x0
  802900:	6a 00                	push   $0x0
  802902:	6a 00                	push   $0x0
  802904:	6a 00                	push   $0x0
  802906:	6a 00                	push   $0x0
  802908:	6a 2c                	push   $0x2c
  80290a:	e8 4a fa ff ff       	call   802359 <syscall>
  80290f:	83 c4 18             	add    $0x18,%esp
  802912:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  802915:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  802919:	75 07                	jne    802922 <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  80291b:	b8 01 00 00 00       	mov    $0x1,%eax
  802920:	eb 05                	jmp    802927 <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  802922:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802927:	c9                   	leave  
  802928:	c3                   	ret    

00802929 <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  802929:	55                   	push   %ebp
  80292a:	89 e5                	mov    %esp,%ebp
  80292c:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  80292f:	6a 00                	push   $0x0
  802931:	6a 00                	push   $0x0
  802933:	6a 00                	push   $0x0
  802935:	6a 00                	push   $0x0
  802937:	6a 00                	push   $0x0
  802939:	6a 2c                	push   $0x2c
  80293b:	e8 19 fa ff ff       	call   802359 <syscall>
  802940:	83 c4 18             	add    $0x18,%esp
  802943:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  802946:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  80294a:	75 07                	jne    802953 <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  80294c:	b8 01 00 00 00       	mov    $0x1,%eax
  802951:	eb 05                	jmp    802958 <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  802953:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802958:	c9                   	leave  
  802959:	c3                   	ret    

0080295a <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  80295a:	55                   	push   %ebp
  80295b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  80295d:	6a 00                	push   $0x0
  80295f:	6a 00                	push   $0x0
  802961:	6a 00                	push   $0x0
  802963:	6a 00                	push   $0x0
  802965:	ff 75 08             	pushl  0x8(%ebp)
  802968:	6a 2d                	push   $0x2d
  80296a:	e8 ea f9 ff ff       	call   802359 <syscall>
  80296f:	83 c4 18             	add    $0x18,%esp
	return ;
  802972:	90                   	nop
}
  802973:	c9                   	leave  
  802974:	c3                   	ret    

00802975 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  802975:	55                   	push   %ebp
  802976:	89 e5                	mov    %esp,%ebp
  802978:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  802979:	8b 5d 14             	mov    0x14(%ebp),%ebx
  80297c:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80297f:	8b 55 0c             	mov    0xc(%ebp),%edx
  802982:	8b 45 08             	mov    0x8(%ebp),%eax
  802985:	6a 00                	push   $0x0
  802987:	53                   	push   %ebx
  802988:	51                   	push   %ecx
  802989:	52                   	push   %edx
  80298a:	50                   	push   %eax
  80298b:	6a 2e                	push   $0x2e
  80298d:	e8 c7 f9 ff ff       	call   802359 <syscall>
  802992:	83 c4 18             	add    $0x18,%esp
}
  802995:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802998:	c9                   	leave  
  802999:	c3                   	ret    

0080299a <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  80299a:	55                   	push   %ebp
  80299b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  80299d:	8b 55 0c             	mov    0xc(%ebp),%edx
  8029a0:	8b 45 08             	mov    0x8(%ebp),%eax
  8029a3:	6a 00                	push   $0x0
  8029a5:	6a 00                	push   $0x0
  8029a7:	6a 00                	push   $0x0
  8029a9:	52                   	push   %edx
  8029aa:	50                   	push   %eax
  8029ab:	6a 2f                	push   $0x2f
  8029ad:	e8 a7 f9 ff ff       	call   802359 <syscall>
  8029b2:	83 c4 18             	add    $0x18,%esp
}
  8029b5:	c9                   	leave  
  8029b6:	c3                   	ret    

008029b7 <print_mem_block_lists>:
//===========================
// PRINT MEM BLOCK LISTS:
//===========================

void print_mem_block_lists()
{
  8029b7:	55                   	push   %ebp
  8029b8:	89 e5                	mov    %esp,%ebp
  8029ba:	83 ec 18             	sub    $0x18,%esp
	cprintf("\n=========================================\n");
  8029bd:	83 ec 0c             	sub    $0xc,%esp
  8029c0:	68 e0 44 80 00       	push   $0x8044e0
  8029c5:	e8 dd e6 ff ff       	call   8010a7 <cprintf>
  8029ca:	83 c4 10             	add    $0x10,%esp
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
  8029cd:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nFreeMemBlocksList:\n");
  8029d4:	83 ec 0c             	sub    $0xc,%esp
  8029d7:	68 0c 45 80 00       	push   $0x80450c
  8029dc:	e8 c6 e6 ff ff       	call   8010a7 <cprintf>
  8029e1:	83 c4 10             	add    $0x10,%esp
	uint8 sorted = 1 ;
  8029e4:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &FreeMemBlocksList)
  8029e8:	a1 38 51 80 00       	mov    0x805138,%eax
  8029ed:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8029f0:	eb 56                	jmp    802a48 <print_mem_block_lists+0x91>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  8029f2:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8029f6:	74 1c                	je     802a14 <print_mem_block_lists+0x5d>
  8029f8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029fb:	8b 50 08             	mov    0x8(%eax),%edx
  8029fe:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a01:	8b 48 08             	mov    0x8(%eax),%ecx
  802a04:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a07:	8b 40 0c             	mov    0xc(%eax),%eax
  802a0a:	01 c8                	add    %ecx,%eax
  802a0c:	39 c2                	cmp    %eax,%edx
  802a0e:	73 04                	jae    802a14 <print_mem_block_lists+0x5d>
			sorted = 0 ;
  802a10:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  802a14:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a17:	8b 50 08             	mov    0x8(%eax),%edx
  802a1a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a1d:	8b 40 0c             	mov    0xc(%eax),%eax
  802a20:	01 c2                	add    %eax,%edx
  802a22:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a25:	8b 40 08             	mov    0x8(%eax),%eax
  802a28:	83 ec 04             	sub    $0x4,%esp
  802a2b:	52                   	push   %edx
  802a2c:	50                   	push   %eax
  802a2d:	68 21 45 80 00       	push   $0x804521
  802a32:	e8 70 e6 ff ff       	call   8010a7 <cprintf>
  802a37:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  802a3a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a3d:	89 45 f0             	mov    %eax,-0x10(%ebp)
	cprintf("\n=========================================\n");
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
	cprintf("\nFreeMemBlocksList:\n");
	uint8 sorted = 1 ;
	LIST_FOREACH(blk, &FreeMemBlocksList)
  802a40:	a1 40 51 80 00       	mov    0x805140,%eax
  802a45:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802a48:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802a4c:	74 07                	je     802a55 <print_mem_block_lists+0x9e>
  802a4e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a51:	8b 00                	mov    (%eax),%eax
  802a53:	eb 05                	jmp    802a5a <print_mem_block_lists+0xa3>
  802a55:	b8 00 00 00 00       	mov    $0x0,%eax
  802a5a:	a3 40 51 80 00       	mov    %eax,0x805140
  802a5f:	a1 40 51 80 00       	mov    0x805140,%eax
  802a64:	85 c0                	test   %eax,%eax
  802a66:	75 8a                	jne    8029f2 <print_mem_block_lists+0x3b>
  802a68:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802a6c:	75 84                	jne    8029f2 <print_mem_block_lists+0x3b>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;
  802a6e:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  802a72:	75 10                	jne    802a84 <print_mem_block_lists+0xcd>
  802a74:	83 ec 0c             	sub    $0xc,%esp
  802a77:	68 30 45 80 00       	push   $0x804530
  802a7c:	e8 26 e6 ff ff       	call   8010a7 <cprintf>
  802a81:	83 c4 10             	add    $0x10,%esp

	lastBlk = NULL ;
  802a84:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nAllocMemBlocksList:\n");
  802a8b:	83 ec 0c             	sub    $0xc,%esp
  802a8e:	68 54 45 80 00       	push   $0x804554
  802a93:	e8 0f e6 ff ff       	call   8010a7 <cprintf>
  802a98:	83 c4 10             	add    $0x10,%esp
	sorted = 1 ;
  802a9b:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &AllocMemBlocksList)
  802a9f:	a1 40 50 80 00       	mov    0x805040,%eax
  802aa4:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802aa7:	eb 56                	jmp    802aff <print_mem_block_lists+0x148>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  802aa9:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802aad:	74 1c                	je     802acb <print_mem_block_lists+0x114>
  802aaf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ab2:	8b 50 08             	mov    0x8(%eax),%edx
  802ab5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ab8:	8b 48 08             	mov    0x8(%eax),%ecx
  802abb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802abe:	8b 40 0c             	mov    0xc(%eax),%eax
  802ac1:	01 c8                	add    %ecx,%eax
  802ac3:	39 c2                	cmp    %eax,%edx
  802ac5:	73 04                	jae    802acb <print_mem_block_lists+0x114>
			sorted = 0 ;
  802ac7:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  802acb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ace:	8b 50 08             	mov    0x8(%eax),%edx
  802ad1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ad4:	8b 40 0c             	mov    0xc(%eax),%eax
  802ad7:	01 c2                	add    %eax,%edx
  802ad9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802adc:	8b 40 08             	mov    0x8(%eax),%eax
  802adf:	83 ec 04             	sub    $0x4,%esp
  802ae2:	52                   	push   %edx
  802ae3:	50                   	push   %eax
  802ae4:	68 21 45 80 00       	push   $0x804521
  802ae9:	e8 b9 e5 ff ff       	call   8010a7 <cprintf>
  802aee:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  802af1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802af4:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;

	lastBlk = NULL ;
	cprintf("\nAllocMemBlocksList:\n");
	sorted = 1 ;
	LIST_FOREACH(blk, &AllocMemBlocksList)
  802af7:	a1 48 50 80 00       	mov    0x805048,%eax
  802afc:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802aff:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802b03:	74 07                	je     802b0c <print_mem_block_lists+0x155>
  802b05:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b08:	8b 00                	mov    (%eax),%eax
  802b0a:	eb 05                	jmp    802b11 <print_mem_block_lists+0x15a>
  802b0c:	b8 00 00 00 00       	mov    $0x0,%eax
  802b11:	a3 48 50 80 00       	mov    %eax,0x805048
  802b16:	a1 48 50 80 00       	mov    0x805048,%eax
  802b1b:	85 c0                	test   %eax,%eax
  802b1d:	75 8a                	jne    802aa9 <print_mem_block_lists+0xf2>
  802b1f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802b23:	75 84                	jne    802aa9 <print_mem_block_lists+0xf2>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nAllocMemBlocksList is NOT SORTED!!\n") ;
  802b25:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  802b29:	75 10                	jne    802b3b <print_mem_block_lists+0x184>
  802b2b:	83 ec 0c             	sub    $0xc,%esp
  802b2e:	68 6c 45 80 00       	push   $0x80456c
  802b33:	e8 6f e5 ff ff       	call   8010a7 <cprintf>
  802b38:	83 c4 10             	add    $0x10,%esp
	cprintf("\n=========================================\n");
  802b3b:	83 ec 0c             	sub    $0xc,%esp
  802b3e:	68 e0 44 80 00       	push   $0x8044e0
  802b43:	e8 5f e5 ff ff       	call   8010a7 <cprintf>
  802b48:	83 c4 10             	add    $0x10,%esp

}
  802b4b:	90                   	nop
  802b4c:	c9                   	leave  
  802b4d:	c3                   	ret    

00802b4e <initialize_MemBlocksList>:

//===============================
// [1] INITIALIZE AVAILABLE LIST:
//===============================
void initialize_MemBlocksList(uint32 numOfBlocks)
{
  802b4e:	55                   	push   %ebp
  802b4f:	89 e5                	mov    %esp,%ebp
  802b51:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] initialize_MemBlocksList
	// Write your code here, remove the panic and write your code
	//panic("initialize_MemBlocksList() is not implemented yet...!!");
	uint32 n = numOfBlocks;
  802b54:	8b 45 08             	mov    0x8(%ebp),%eax
  802b57:	89 45 f0             	mov    %eax,-0x10(%ebp)

	LIST_INIT(&AvailableMemBlocksList);
  802b5a:	c7 05 48 51 80 00 00 	movl   $0x0,0x805148
  802b61:	00 00 00 
  802b64:	c7 05 4c 51 80 00 00 	movl   $0x0,0x80514c
  802b6b:	00 00 00 
  802b6e:	c7 05 54 51 80 00 00 	movl   $0x0,0x805154
  802b75:	00 00 00 
	for(int i = 0; i<n;i++)
  802b78:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  802b7f:	e9 9e 00 00 00       	jmp    802c22 <initialize_MemBlocksList+0xd4>
	{
		LIST_INSERT_HEAD(&AvailableMemBlocksList, &(MemBlockNodes[i]));
  802b84:	a1 50 50 80 00       	mov    0x805050,%eax
  802b89:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802b8c:	c1 e2 04             	shl    $0x4,%edx
  802b8f:	01 d0                	add    %edx,%eax
  802b91:	85 c0                	test   %eax,%eax
  802b93:	75 14                	jne    802ba9 <initialize_MemBlocksList+0x5b>
  802b95:	83 ec 04             	sub    $0x4,%esp
  802b98:	68 94 45 80 00       	push   $0x804594
  802b9d:	6a 47                	push   $0x47
  802b9f:	68 b7 45 80 00       	push   $0x8045b7
  802ba4:	e8 4a e2 ff ff       	call   800df3 <_panic>
  802ba9:	a1 50 50 80 00       	mov    0x805050,%eax
  802bae:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802bb1:	c1 e2 04             	shl    $0x4,%edx
  802bb4:	01 d0                	add    %edx,%eax
  802bb6:	8b 15 48 51 80 00    	mov    0x805148,%edx
  802bbc:	89 10                	mov    %edx,(%eax)
  802bbe:	8b 00                	mov    (%eax),%eax
  802bc0:	85 c0                	test   %eax,%eax
  802bc2:	74 18                	je     802bdc <initialize_MemBlocksList+0x8e>
  802bc4:	a1 48 51 80 00       	mov    0x805148,%eax
  802bc9:	8b 15 50 50 80 00    	mov    0x805050,%edx
  802bcf:	8b 4d f4             	mov    -0xc(%ebp),%ecx
  802bd2:	c1 e1 04             	shl    $0x4,%ecx
  802bd5:	01 ca                	add    %ecx,%edx
  802bd7:	89 50 04             	mov    %edx,0x4(%eax)
  802bda:	eb 12                	jmp    802bee <initialize_MemBlocksList+0xa0>
  802bdc:	a1 50 50 80 00       	mov    0x805050,%eax
  802be1:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802be4:	c1 e2 04             	shl    $0x4,%edx
  802be7:	01 d0                	add    %edx,%eax
  802be9:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802bee:	a1 50 50 80 00       	mov    0x805050,%eax
  802bf3:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802bf6:	c1 e2 04             	shl    $0x4,%edx
  802bf9:	01 d0                	add    %edx,%eax
  802bfb:	a3 48 51 80 00       	mov    %eax,0x805148
  802c00:	a1 50 50 80 00       	mov    0x805050,%eax
  802c05:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802c08:	c1 e2 04             	shl    $0x4,%edx
  802c0b:	01 d0                	add    %edx,%eax
  802c0d:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802c14:	a1 54 51 80 00       	mov    0x805154,%eax
  802c19:	40                   	inc    %eax
  802c1a:	a3 54 51 80 00       	mov    %eax,0x805154
	// Write your code here, remove the panic and write your code
	//panic("initialize_MemBlocksList() is not implemented yet...!!");
	uint32 n = numOfBlocks;

	LIST_INIT(&AvailableMemBlocksList);
	for(int i = 0; i<n;i++)
  802c1f:	ff 45 f4             	incl   -0xc(%ebp)
  802c22:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c25:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  802c28:	0f 82 56 ff ff ff    	jb     802b84 <initialize_MemBlocksList+0x36>
	{
		LIST_INSERT_HEAD(&AvailableMemBlocksList, &(MemBlockNodes[i]));
	}
}
  802c2e:	90                   	nop
  802c2f:	c9                   	leave  
  802c30:	c3                   	ret    

00802c31 <find_block>:

//===============================
// [2] FIND BLOCK:
//===============================
struct MemBlock *find_block(struct MemBlock_List *blockList, uint32 va)
{
  802c31:	55                   	push   %ebp
  802c32:	89 e5                	mov    %esp,%ebp
  802c34:	83 ec 10             	sub    $0x10,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] find_block
	// Write your code here, remove the panic and write your code
	//panic("find_block() is not implemented yet...!!");
	uint32 virAddress = va;
  802c37:	8b 45 0c             	mov    0xc(%ebp),%eax
  802c3a:	89 45 f4             	mov    %eax,-0xc(%ebp)
	struct MemBlock* blk;
	int found = 0;
  802c3d:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	LIST_FOREACH(blk, &(AllocMemBlocksList))
  802c44:	a1 40 50 80 00       	mov    0x805040,%eax
  802c49:	89 45 fc             	mov    %eax,-0x4(%ebp)
  802c4c:	eb 23                	jmp    802c71 <find_block+0x40>
	{
		if(blk->sva == virAddress)
  802c4e:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802c51:	8b 40 08             	mov    0x8(%eax),%eax
  802c54:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  802c57:	75 09                	jne    802c62 <find_block+0x31>
		{
			found = 1;
  802c59:	c7 45 f8 01 00 00 00 	movl   $0x1,-0x8(%ebp)
			break;
  802c60:	eb 35                	jmp    802c97 <find_block+0x66>
		}
		else
		{
			found = 0;
  802c62:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	//panic("find_block() is not implemented yet...!!");
	uint32 virAddress = va;
	struct MemBlock* blk;
	int found = 0;

	LIST_FOREACH(blk, &(AllocMemBlocksList))
  802c69:	a1 48 50 80 00       	mov    0x805048,%eax
  802c6e:	89 45 fc             	mov    %eax,-0x4(%ebp)
  802c71:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  802c75:	74 07                	je     802c7e <find_block+0x4d>
  802c77:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802c7a:	8b 00                	mov    (%eax),%eax
  802c7c:	eb 05                	jmp    802c83 <find_block+0x52>
  802c7e:	b8 00 00 00 00       	mov    $0x0,%eax
  802c83:	a3 48 50 80 00       	mov    %eax,0x805048
  802c88:	a1 48 50 80 00       	mov    0x805048,%eax
  802c8d:	85 c0                	test   %eax,%eax
  802c8f:	75 bd                	jne    802c4e <find_block+0x1d>
  802c91:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  802c95:	75 b7                	jne    802c4e <find_block+0x1d>
		{
			found = 0;
			continue;
		}
	}
	if(found == 1)
  802c97:	83 7d f8 01          	cmpl   $0x1,-0x8(%ebp)
  802c9b:	75 05                	jne    802ca2 <find_block+0x71>
	{
		return blk;
  802c9d:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802ca0:	eb 05                	jmp    802ca7 <find_block+0x76>
	}
	else
	{
		return NULL;
  802ca2:	b8 00 00 00 00       	mov    $0x0,%eax
	}
}
  802ca7:	c9                   	leave  
  802ca8:	c3                   	ret    

00802ca9 <insert_sorted_allocList>:

//=========================================
// [3] INSERT BLOCK IN ALLOC LIST [SORTED]:
//=========================================
void insert_sorted_allocList(struct MemBlock *blockToInsert)
{
  802ca9:	55                   	push   %ebp
  802caa:	89 e5                	mov    %esp,%ebp
  802cac:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] insert_sorted_allocList
	// Write your code here, remove the panic and write your code
	//panic("insert_sorted_allocList() is not implemented yet...!!");
	struct MemBlock* blk;
	struct MemBlock* newblk = blockToInsert;
  802caf:	8b 45 08             	mov    0x8(%ebp),%eax
  802cb2:	89 45 f0             	mov    %eax,-0x10(%ebp)

	if((LIST_EMPTY(&AllocMemBlocksList)) || (newblk->sva < LIST_FIRST(&AllocMemBlocksList)->sva))
  802cb5:	a1 40 50 80 00       	mov    0x805040,%eax
  802cba:	85 c0                	test   %eax,%eax
  802cbc:	74 12                	je     802cd0 <insert_sorted_allocList+0x27>
  802cbe:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802cc1:	8b 50 08             	mov    0x8(%eax),%edx
  802cc4:	a1 40 50 80 00       	mov    0x805040,%eax
  802cc9:	8b 40 08             	mov    0x8(%eax),%eax
  802ccc:	39 c2                	cmp    %eax,%edx
  802cce:	73 65                	jae    802d35 <insert_sorted_allocList+0x8c>
	{
		LIST_INSERT_HEAD(&(AllocMemBlocksList), newblk);
  802cd0:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802cd4:	75 14                	jne    802cea <insert_sorted_allocList+0x41>
  802cd6:	83 ec 04             	sub    $0x4,%esp
  802cd9:	68 94 45 80 00       	push   $0x804594
  802cde:	6a 7b                	push   $0x7b
  802ce0:	68 b7 45 80 00       	push   $0x8045b7
  802ce5:	e8 09 e1 ff ff       	call   800df3 <_panic>
  802cea:	8b 15 40 50 80 00    	mov    0x805040,%edx
  802cf0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802cf3:	89 10                	mov    %edx,(%eax)
  802cf5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802cf8:	8b 00                	mov    (%eax),%eax
  802cfa:	85 c0                	test   %eax,%eax
  802cfc:	74 0d                	je     802d0b <insert_sorted_allocList+0x62>
  802cfe:	a1 40 50 80 00       	mov    0x805040,%eax
  802d03:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802d06:	89 50 04             	mov    %edx,0x4(%eax)
  802d09:	eb 08                	jmp    802d13 <insert_sorted_allocList+0x6a>
  802d0b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d0e:	a3 44 50 80 00       	mov    %eax,0x805044
  802d13:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d16:	a3 40 50 80 00       	mov    %eax,0x805040
  802d1b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d1e:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802d25:	a1 4c 50 80 00       	mov    0x80504c,%eax
  802d2a:	40                   	inc    %eax
  802d2b:	a3 4c 50 80 00       	mov    %eax,0x80504c
  802d30:	e9 5f 01 00 00       	jmp    802e94 <insert_sorted_allocList+0x1eb>
	}
	else if(newblk->sva > LIST_LAST(&AllocMemBlocksList)->sva)
  802d35:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d38:	8b 50 08             	mov    0x8(%eax),%edx
  802d3b:	a1 44 50 80 00       	mov    0x805044,%eax
  802d40:	8b 40 08             	mov    0x8(%eax),%eax
  802d43:	39 c2                	cmp    %eax,%edx
  802d45:	76 65                	jbe    802dac <insert_sorted_allocList+0x103>
	{
		LIST_INSERT_TAIL(&AllocMemBlocksList, newblk);
  802d47:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802d4b:	75 14                	jne    802d61 <insert_sorted_allocList+0xb8>
  802d4d:	83 ec 04             	sub    $0x4,%esp
  802d50:	68 d0 45 80 00       	push   $0x8045d0
  802d55:	6a 7f                	push   $0x7f
  802d57:	68 b7 45 80 00       	push   $0x8045b7
  802d5c:	e8 92 e0 ff ff       	call   800df3 <_panic>
  802d61:	8b 15 44 50 80 00    	mov    0x805044,%edx
  802d67:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d6a:	89 50 04             	mov    %edx,0x4(%eax)
  802d6d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d70:	8b 40 04             	mov    0x4(%eax),%eax
  802d73:	85 c0                	test   %eax,%eax
  802d75:	74 0c                	je     802d83 <insert_sorted_allocList+0xda>
  802d77:	a1 44 50 80 00       	mov    0x805044,%eax
  802d7c:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802d7f:	89 10                	mov    %edx,(%eax)
  802d81:	eb 08                	jmp    802d8b <insert_sorted_allocList+0xe2>
  802d83:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d86:	a3 40 50 80 00       	mov    %eax,0x805040
  802d8b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d8e:	a3 44 50 80 00       	mov    %eax,0x805044
  802d93:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d96:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802d9c:	a1 4c 50 80 00       	mov    0x80504c,%eax
  802da1:	40                   	inc    %eax
  802da2:	a3 4c 50 80 00       	mov    %eax,0x80504c
				LIST_INSERT_AFTER(&AllocMemBlocksList, blk, newblk);
				break;
			}
		}
	}
}
  802da7:	e9 e8 00 00 00       	jmp    802e94 <insert_sorted_allocList+0x1eb>
	{
		LIST_INSERT_TAIL(&AllocMemBlocksList, newblk);
	}
	else
	{
		LIST_FOREACH(blk, &AllocMemBlocksList)
  802dac:	a1 40 50 80 00       	mov    0x805040,%eax
  802db1:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802db4:	e9 ab 00 00 00       	jmp    802e64 <insert_sorted_allocList+0x1bb>
		{
			if(blk->prev_next_info.le_next != NULL && newblk->sva > blk->sva  && newblk->sva < blk->prev_next_info.le_next->sva)
  802db9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802dbc:	8b 00                	mov    (%eax),%eax
  802dbe:	85 c0                	test   %eax,%eax
  802dc0:	0f 84 96 00 00 00    	je     802e5c <insert_sorted_allocList+0x1b3>
  802dc6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802dc9:	8b 50 08             	mov    0x8(%eax),%edx
  802dcc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802dcf:	8b 40 08             	mov    0x8(%eax),%eax
  802dd2:	39 c2                	cmp    %eax,%edx
  802dd4:	0f 86 82 00 00 00    	jbe    802e5c <insert_sorted_allocList+0x1b3>
  802dda:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ddd:	8b 50 08             	mov    0x8(%eax),%edx
  802de0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802de3:	8b 00                	mov    (%eax),%eax
  802de5:	8b 40 08             	mov    0x8(%eax),%eax
  802de8:	39 c2                	cmp    %eax,%edx
  802dea:	73 70                	jae    802e5c <insert_sorted_allocList+0x1b3>
			{
				LIST_INSERT_AFTER(&AllocMemBlocksList, blk, newblk);
  802dec:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802df0:	74 06                	je     802df8 <insert_sorted_allocList+0x14f>
  802df2:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802df6:	75 17                	jne    802e0f <insert_sorted_allocList+0x166>
  802df8:	83 ec 04             	sub    $0x4,%esp
  802dfb:	68 f4 45 80 00       	push   $0x8045f4
  802e00:	68 87 00 00 00       	push   $0x87
  802e05:	68 b7 45 80 00       	push   $0x8045b7
  802e0a:	e8 e4 df ff ff       	call   800df3 <_panic>
  802e0f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e12:	8b 10                	mov    (%eax),%edx
  802e14:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e17:	89 10                	mov    %edx,(%eax)
  802e19:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e1c:	8b 00                	mov    (%eax),%eax
  802e1e:	85 c0                	test   %eax,%eax
  802e20:	74 0b                	je     802e2d <insert_sorted_allocList+0x184>
  802e22:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e25:	8b 00                	mov    (%eax),%eax
  802e27:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802e2a:	89 50 04             	mov    %edx,0x4(%eax)
  802e2d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e30:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802e33:	89 10                	mov    %edx,(%eax)
  802e35:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e38:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802e3b:	89 50 04             	mov    %edx,0x4(%eax)
  802e3e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e41:	8b 00                	mov    (%eax),%eax
  802e43:	85 c0                	test   %eax,%eax
  802e45:	75 08                	jne    802e4f <insert_sorted_allocList+0x1a6>
  802e47:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e4a:	a3 44 50 80 00       	mov    %eax,0x805044
  802e4f:	a1 4c 50 80 00       	mov    0x80504c,%eax
  802e54:	40                   	inc    %eax
  802e55:	a3 4c 50 80 00       	mov    %eax,0x80504c
				break;
  802e5a:	eb 38                	jmp    802e94 <insert_sorted_allocList+0x1eb>
	{
		LIST_INSERT_TAIL(&AllocMemBlocksList, newblk);
	}
	else
	{
		LIST_FOREACH(blk, &AllocMemBlocksList)
  802e5c:	a1 48 50 80 00       	mov    0x805048,%eax
  802e61:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802e64:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802e68:	74 07                	je     802e71 <insert_sorted_allocList+0x1c8>
  802e6a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e6d:	8b 00                	mov    (%eax),%eax
  802e6f:	eb 05                	jmp    802e76 <insert_sorted_allocList+0x1cd>
  802e71:	b8 00 00 00 00       	mov    $0x0,%eax
  802e76:	a3 48 50 80 00       	mov    %eax,0x805048
  802e7b:	a1 48 50 80 00       	mov    0x805048,%eax
  802e80:	85 c0                	test   %eax,%eax
  802e82:	0f 85 31 ff ff ff    	jne    802db9 <insert_sorted_allocList+0x110>
  802e88:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802e8c:	0f 85 27 ff ff ff    	jne    802db9 <insert_sorted_allocList+0x110>
				LIST_INSERT_AFTER(&AllocMemBlocksList, blk, newblk);
				break;
			}
		}
	}
}
  802e92:	eb 00                	jmp    802e94 <insert_sorted_allocList+0x1eb>
  802e94:	90                   	nop
  802e95:	c9                   	leave  
  802e96:	c3                   	ret    

00802e97 <alloc_block_FF>:

//=========================================
// [4] ALLOCATE BLOCK BY FIRST FIT:
//=========================================
struct MemBlock *alloc_block_FF(uint32 size)
{
  802e97:	55                   	push   %ebp
  802e98:	89 e5                	mov    %esp,%ebp
  802e9a:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_FF
	// Write your code here, remove the panic and write your code
	//panic("alloc_block_FF() is not implemented yet...!!");
	uint32 versize = size;
  802e9d:	8b 45 08             	mov    0x8(%ebp),%eax
  802ea0:	89 45 f0             	mov    %eax,-0x10(%ebp)
	struct MemBlock* blk;
	struct MemBlock* newblk = LIST_FIRST(&AvailableMemBlocksList);
  802ea3:	a1 48 51 80 00       	mov    0x805148,%eax
  802ea8:	89 45 ec             	mov    %eax,-0x14(%ebp)

	LIST_FOREACH(blk,&FreeMemBlocksList)
  802eab:	a1 38 51 80 00       	mov    0x805138,%eax
  802eb0:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802eb3:	e9 77 01 00 00       	jmp    80302f <alloc_block_FF+0x198>
	{
		if(blk->size == versize)
  802eb8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ebb:	8b 40 0c             	mov    0xc(%eax),%eax
  802ebe:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  802ec1:	0f 85 8a 00 00 00    	jne    802f51 <alloc_block_FF+0xba>
		{
			LIST_REMOVE(&FreeMemBlocksList,blk);
  802ec7:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802ecb:	75 17                	jne    802ee4 <alloc_block_FF+0x4d>
  802ecd:	83 ec 04             	sub    $0x4,%esp
  802ed0:	68 28 46 80 00       	push   $0x804628
  802ed5:	68 9e 00 00 00       	push   $0x9e
  802eda:	68 b7 45 80 00       	push   $0x8045b7
  802edf:	e8 0f df ff ff       	call   800df3 <_panic>
  802ee4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ee7:	8b 00                	mov    (%eax),%eax
  802ee9:	85 c0                	test   %eax,%eax
  802eeb:	74 10                	je     802efd <alloc_block_FF+0x66>
  802eed:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ef0:	8b 00                	mov    (%eax),%eax
  802ef2:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802ef5:	8b 52 04             	mov    0x4(%edx),%edx
  802ef8:	89 50 04             	mov    %edx,0x4(%eax)
  802efb:	eb 0b                	jmp    802f08 <alloc_block_FF+0x71>
  802efd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f00:	8b 40 04             	mov    0x4(%eax),%eax
  802f03:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802f08:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f0b:	8b 40 04             	mov    0x4(%eax),%eax
  802f0e:	85 c0                	test   %eax,%eax
  802f10:	74 0f                	je     802f21 <alloc_block_FF+0x8a>
  802f12:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f15:	8b 40 04             	mov    0x4(%eax),%eax
  802f18:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802f1b:	8b 12                	mov    (%edx),%edx
  802f1d:	89 10                	mov    %edx,(%eax)
  802f1f:	eb 0a                	jmp    802f2b <alloc_block_FF+0x94>
  802f21:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f24:	8b 00                	mov    (%eax),%eax
  802f26:	a3 38 51 80 00       	mov    %eax,0x805138
  802f2b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f2e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802f34:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f37:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802f3e:	a1 44 51 80 00       	mov    0x805144,%eax
  802f43:	48                   	dec    %eax
  802f44:	a3 44 51 80 00       	mov    %eax,0x805144
			return blk;
  802f49:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f4c:	e9 11 01 00 00       	jmp    803062 <alloc_block_FF+0x1cb>
		}
		else if(blk->size > versize)
  802f51:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f54:	8b 40 0c             	mov    0xc(%eax),%eax
  802f57:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  802f5a:	0f 86 c7 00 00 00    	jbe    803027 <alloc_block_FF+0x190>
		{
			LIST_REMOVE(&AvailableMemBlocksList,newblk);
  802f60:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802f64:	75 17                	jne    802f7d <alloc_block_FF+0xe6>
  802f66:	83 ec 04             	sub    $0x4,%esp
  802f69:	68 28 46 80 00       	push   $0x804628
  802f6e:	68 a3 00 00 00       	push   $0xa3
  802f73:	68 b7 45 80 00       	push   $0x8045b7
  802f78:	e8 76 de ff ff       	call   800df3 <_panic>
  802f7d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802f80:	8b 00                	mov    (%eax),%eax
  802f82:	85 c0                	test   %eax,%eax
  802f84:	74 10                	je     802f96 <alloc_block_FF+0xff>
  802f86:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802f89:	8b 00                	mov    (%eax),%eax
  802f8b:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802f8e:	8b 52 04             	mov    0x4(%edx),%edx
  802f91:	89 50 04             	mov    %edx,0x4(%eax)
  802f94:	eb 0b                	jmp    802fa1 <alloc_block_FF+0x10a>
  802f96:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802f99:	8b 40 04             	mov    0x4(%eax),%eax
  802f9c:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802fa1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802fa4:	8b 40 04             	mov    0x4(%eax),%eax
  802fa7:	85 c0                	test   %eax,%eax
  802fa9:	74 0f                	je     802fba <alloc_block_FF+0x123>
  802fab:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802fae:	8b 40 04             	mov    0x4(%eax),%eax
  802fb1:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802fb4:	8b 12                	mov    (%edx),%edx
  802fb6:	89 10                	mov    %edx,(%eax)
  802fb8:	eb 0a                	jmp    802fc4 <alloc_block_FF+0x12d>
  802fba:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802fbd:	8b 00                	mov    (%eax),%eax
  802fbf:	a3 48 51 80 00       	mov    %eax,0x805148
  802fc4:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802fc7:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802fcd:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802fd0:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802fd7:	a1 54 51 80 00       	mov    0x805154,%eax
  802fdc:	48                   	dec    %eax
  802fdd:	a3 54 51 80 00       	mov    %eax,0x805154
			newblk->size = versize;
  802fe2:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802fe5:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802fe8:	89 50 0c             	mov    %edx,0xc(%eax)
			blk->size = blk->size-versize;
  802feb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802fee:	8b 40 0c             	mov    0xc(%eax),%eax
  802ff1:	2b 45 f0             	sub    -0x10(%ebp),%eax
  802ff4:	89 c2                	mov    %eax,%edx
  802ff6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ff9:	89 50 0c             	mov    %edx,0xc(%eax)
			uint32 newveradd = blk->sva;
  802ffc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802fff:	8b 40 08             	mov    0x8(%eax),%eax
  803002:	89 45 e8             	mov    %eax,-0x18(%ebp)
			blk->sva+=newblk->size;
  803005:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803008:	8b 50 08             	mov    0x8(%eax),%edx
  80300b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80300e:	8b 40 0c             	mov    0xc(%eax),%eax
  803011:	01 c2                	add    %eax,%edx
  803013:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803016:	89 50 08             	mov    %edx,0x8(%eax)
			newblk->sva = newveradd;
  803019:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80301c:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80301f:	89 50 08             	mov    %edx,0x8(%eax)
			return newblk;
  803022:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803025:	eb 3b                	jmp    803062 <alloc_block_FF+0x1cb>
	//panic("alloc_block_FF() is not implemented yet...!!");
	uint32 versize = size;
	struct MemBlock* blk;
	struct MemBlock* newblk = LIST_FIRST(&AvailableMemBlocksList);

	LIST_FOREACH(blk,&FreeMemBlocksList)
  803027:	a1 40 51 80 00       	mov    0x805140,%eax
  80302c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80302f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803033:	74 07                	je     80303c <alloc_block_FF+0x1a5>
  803035:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803038:	8b 00                	mov    (%eax),%eax
  80303a:	eb 05                	jmp    803041 <alloc_block_FF+0x1aa>
  80303c:	b8 00 00 00 00       	mov    $0x0,%eax
  803041:	a3 40 51 80 00       	mov    %eax,0x805140
  803046:	a1 40 51 80 00       	mov    0x805140,%eax
  80304b:	85 c0                	test   %eax,%eax
  80304d:	0f 85 65 fe ff ff    	jne    802eb8 <alloc_block_FF+0x21>
  803053:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803057:	0f 85 5b fe ff ff    	jne    802eb8 <alloc_block_FF+0x21>
			blk->sva+=newblk->size;
			newblk->sva = newveradd;
			return newblk;
		}
	}
	return NULL;
  80305d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803062:	c9                   	leave  
  803063:	c3                   	ret    

00803064 <alloc_block_BF>:

//=========================================
// [5] ALLOCATE BLOCK BY BEST FIT:
//=========================================
struct MemBlock *alloc_block_BF(uint32 size)
{
  803064:	55                   	push   %ebp
  803065:	89 e5                	mov    %esp,%ebp
  803067:	83 ec 28             	sub    $0x28,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_BF
	// Write your code here, remove the panic and write your code
	//panic("alloc_block_BF() is not implemented yet...!!");
	uint32 versize=size;
  80306a:	8b 45 08             	mov    0x8(%ebp),%eax
  80306d:	89 45 e8             	mov    %eax,-0x18(%ebp)
	struct MemBlock* blk;
	struct MemBlock* newblk=LIST_FIRST(&AvailableMemBlocksList);
  803070:	a1 48 51 80 00       	mov    0x805148,%eax
  803075:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	uint32 newveradd;
	uint32 newsize;
	int size_free = LIST_SIZE(&FreeMemBlocksList);
  803078:	a1 44 51 80 00       	mov    0x805144,%eax
  80307d:	89 45 e0             	mov    %eax,-0x20(%ebp)

	LIST_FOREACH(blk, &FreeMemBlocksList)
  803080:	a1 38 51 80 00       	mov    0x805138,%eax
  803085:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803088:	e9 a1 00 00 00       	jmp    80312e <alloc_block_BF+0xca>
	{
		if(blk->size == versize)
  80308d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803090:	8b 40 0c             	mov    0xc(%eax),%eax
  803093:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  803096:	0f 85 8a 00 00 00    	jne    803126 <alloc_block_BF+0xc2>
		{
			LIST_REMOVE(&FreeMemBlocksList, blk);
  80309c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8030a0:	75 17                	jne    8030b9 <alloc_block_BF+0x55>
  8030a2:	83 ec 04             	sub    $0x4,%esp
  8030a5:	68 28 46 80 00       	push   $0x804628
  8030aa:	68 c2 00 00 00       	push   $0xc2
  8030af:	68 b7 45 80 00       	push   $0x8045b7
  8030b4:	e8 3a dd ff ff       	call   800df3 <_panic>
  8030b9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030bc:	8b 00                	mov    (%eax),%eax
  8030be:	85 c0                	test   %eax,%eax
  8030c0:	74 10                	je     8030d2 <alloc_block_BF+0x6e>
  8030c2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030c5:	8b 00                	mov    (%eax),%eax
  8030c7:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8030ca:	8b 52 04             	mov    0x4(%edx),%edx
  8030cd:	89 50 04             	mov    %edx,0x4(%eax)
  8030d0:	eb 0b                	jmp    8030dd <alloc_block_BF+0x79>
  8030d2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030d5:	8b 40 04             	mov    0x4(%eax),%eax
  8030d8:	a3 3c 51 80 00       	mov    %eax,0x80513c
  8030dd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030e0:	8b 40 04             	mov    0x4(%eax),%eax
  8030e3:	85 c0                	test   %eax,%eax
  8030e5:	74 0f                	je     8030f6 <alloc_block_BF+0x92>
  8030e7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030ea:	8b 40 04             	mov    0x4(%eax),%eax
  8030ed:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8030f0:	8b 12                	mov    (%edx),%edx
  8030f2:	89 10                	mov    %edx,(%eax)
  8030f4:	eb 0a                	jmp    803100 <alloc_block_BF+0x9c>
  8030f6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030f9:	8b 00                	mov    (%eax),%eax
  8030fb:	a3 38 51 80 00       	mov    %eax,0x805138
  803100:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803103:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803109:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80310c:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803113:	a1 44 51 80 00       	mov    0x805144,%eax
  803118:	48                   	dec    %eax
  803119:	a3 44 51 80 00       	mov    %eax,0x805144
			return blk;
  80311e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803121:	e9 11 02 00 00       	jmp    803337 <alloc_block_BF+0x2d3>
	struct MemBlock* newblk=LIST_FIRST(&AvailableMemBlocksList);
	uint32 newveradd;
	uint32 newsize;
	int size_free = LIST_SIZE(&FreeMemBlocksList);

	LIST_FOREACH(blk, &FreeMemBlocksList)
  803126:	a1 40 51 80 00       	mov    0x805140,%eax
  80312b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80312e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803132:	74 07                	je     80313b <alloc_block_BF+0xd7>
  803134:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803137:	8b 00                	mov    (%eax),%eax
  803139:	eb 05                	jmp    803140 <alloc_block_BF+0xdc>
  80313b:	b8 00 00 00 00       	mov    $0x0,%eax
  803140:	a3 40 51 80 00       	mov    %eax,0x805140
  803145:	a1 40 51 80 00       	mov    0x805140,%eax
  80314a:	85 c0                	test   %eax,%eax
  80314c:	0f 85 3b ff ff ff    	jne    80308d <alloc_block_BF+0x29>
  803152:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803156:	0f 85 31 ff ff ff    	jne    80308d <alloc_block_BF+0x29>
		{
			LIST_REMOVE(&FreeMemBlocksList, blk);
			return blk;
		}
	}
	LIST_FOREACH(blk, &FreeMemBlocksList)
  80315c:	a1 38 51 80 00       	mov    0x805138,%eax
  803161:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803164:	eb 27                	jmp    80318d <alloc_block_BF+0x129>
	{
		if(blk->size > versize)
  803166:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803169:	8b 40 0c             	mov    0xc(%eax),%eax
  80316c:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  80316f:	76 14                	jbe    803185 <alloc_block_BF+0x121>
		{
			newsize = blk->size;
  803171:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803174:	8b 40 0c             	mov    0xc(%eax),%eax
  803177:	89 45 ec             	mov    %eax,-0x14(%ebp)
			newveradd = blk->sva;
  80317a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80317d:	8b 40 08             	mov    0x8(%eax),%eax
  803180:	89 45 f0             	mov    %eax,-0x10(%ebp)
			break;
  803183:	eb 2e                	jmp    8031b3 <alloc_block_BF+0x14f>
		{
			LIST_REMOVE(&FreeMemBlocksList, blk);
			return blk;
		}
	}
	LIST_FOREACH(blk, &FreeMemBlocksList)
  803185:	a1 40 51 80 00       	mov    0x805140,%eax
  80318a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80318d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803191:	74 07                	je     80319a <alloc_block_BF+0x136>
  803193:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803196:	8b 00                	mov    (%eax),%eax
  803198:	eb 05                	jmp    80319f <alloc_block_BF+0x13b>
  80319a:	b8 00 00 00 00       	mov    $0x0,%eax
  80319f:	a3 40 51 80 00       	mov    %eax,0x805140
  8031a4:	a1 40 51 80 00       	mov    0x805140,%eax
  8031a9:	85 c0                	test   %eax,%eax
  8031ab:	75 b9                	jne    803166 <alloc_block_BF+0x102>
  8031ad:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8031b1:	75 b3                	jne    803166 <alloc_block_BF+0x102>
			newsize = blk->size;
			newveradd = blk->sva;
			break;
		}
	}
	LIST_FOREACH(blk, &FreeMemBlocksList)
  8031b3:	a1 38 51 80 00       	mov    0x805138,%eax
  8031b8:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8031bb:	eb 30                	jmp    8031ed <alloc_block_BF+0x189>
	{
		if(newsize > blk->size && blk->size > versize)
  8031bd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8031c0:	8b 40 0c             	mov    0xc(%eax),%eax
  8031c3:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  8031c6:	73 1d                	jae    8031e5 <alloc_block_BF+0x181>
  8031c8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8031cb:	8b 40 0c             	mov    0xc(%eax),%eax
  8031ce:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  8031d1:	76 12                	jbe    8031e5 <alloc_block_BF+0x181>
		{
	       newsize = blk->size;
  8031d3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8031d6:	8b 40 0c             	mov    0xc(%eax),%eax
  8031d9:	89 45 ec             	mov    %eax,-0x14(%ebp)
		   newveradd = blk->sva;
  8031dc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8031df:	8b 40 08             	mov    0x8(%eax),%eax
  8031e2:	89 45 f0             	mov    %eax,-0x10(%ebp)
			newsize = blk->size;
			newveradd = blk->sva;
			break;
		}
	}
	LIST_FOREACH(blk, &FreeMemBlocksList)
  8031e5:	a1 40 51 80 00       	mov    0x805140,%eax
  8031ea:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8031ed:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8031f1:	74 07                	je     8031fa <alloc_block_BF+0x196>
  8031f3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8031f6:	8b 00                	mov    (%eax),%eax
  8031f8:	eb 05                	jmp    8031ff <alloc_block_BF+0x19b>
  8031fa:	b8 00 00 00 00       	mov    $0x0,%eax
  8031ff:	a3 40 51 80 00       	mov    %eax,0x805140
  803204:	a1 40 51 80 00       	mov    0x805140,%eax
  803209:	85 c0                	test   %eax,%eax
  80320b:	75 b0                	jne    8031bd <alloc_block_BF+0x159>
  80320d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803211:	75 aa                	jne    8031bd <alloc_block_BF+0x159>
		{
	       newsize = blk->size;
		   newveradd = blk->sva;
		}
	}
	LIST_FOREACH(blk, &FreeMemBlocksList)
  803213:	a1 38 51 80 00       	mov    0x805138,%eax
  803218:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80321b:	e9 e4 00 00 00       	jmp    803304 <alloc_block_BF+0x2a0>
	{
		if(blk->size == newsize && blk->sva == newveradd)
  803220:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803223:	8b 40 0c             	mov    0xc(%eax),%eax
  803226:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  803229:	0f 85 cd 00 00 00    	jne    8032fc <alloc_block_BF+0x298>
  80322f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803232:	8b 40 08             	mov    0x8(%eax),%eax
  803235:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  803238:	0f 85 be 00 00 00    	jne    8032fc <alloc_block_BF+0x298>
		{
			LIST_REMOVE(&AvailableMemBlocksList, newblk);
  80323e:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  803242:	75 17                	jne    80325b <alloc_block_BF+0x1f7>
  803244:	83 ec 04             	sub    $0x4,%esp
  803247:	68 28 46 80 00       	push   $0x804628
  80324c:	68 db 00 00 00       	push   $0xdb
  803251:	68 b7 45 80 00       	push   $0x8045b7
  803256:	e8 98 db ff ff       	call   800df3 <_panic>
  80325b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80325e:	8b 00                	mov    (%eax),%eax
  803260:	85 c0                	test   %eax,%eax
  803262:	74 10                	je     803274 <alloc_block_BF+0x210>
  803264:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803267:	8b 00                	mov    (%eax),%eax
  803269:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80326c:	8b 52 04             	mov    0x4(%edx),%edx
  80326f:	89 50 04             	mov    %edx,0x4(%eax)
  803272:	eb 0b                	jmp    80327f <alloc_block_BF+0x21b>
  803274:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803277:	8b 40 04             	mov    0x4(%eax),%eax
  80327a:	a3 4c 51 80 00       	mov    %eax,0x80514c
  80327f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803282:	8b 40 04             	mov    0x4(%eax),%eax
  803285:	85 c0                	test   %eax,%eax
  803287:	74 0f                	je     803298 <alloc_block_BF+0x234>
  803289:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80328c:	8b 40 04             	mov    0x4(%eax),%eax
  80328f:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803292:	8b 12                	mov    (%edx),%edx
  803294:	89 10                	mov    %edx,(%eax)
  803296:	eb 0a                	jmp    8032a2 <alloc_block_BF+0x23e>
  803298:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80329b:	8b 00                	mov    (%eax),%eax
  80329d:	a3 48 51 80 00       	mov    %eax,0x805148
  8032a2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8032a5:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8032ab:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8032ae:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8032b5:	a1 54 51 80 00       	mov    0x805154,%eax
  8032ba:	48                   	dec    %eax
  8032bb:	a3 54 51 80 00       	mov    %eax,0x805154
			newblk->size = versize;
  8032c0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8032c3:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8032c6:	89 50 0c             	mov    %edx,0xc(%eax)
			newblk->sva = newveradd;
  8032c9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8032cc:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8032cf:	89 50 08             	mov    %edx,0x8(%eax)
			blk->size = blk->size - versize;
  8032d2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8032d5:	8b 40 0c             	mov    0xc(%eax),%eax
  8032d8:	2b 45 e8             	sub    -0x18(%ebp),%eax
  8032db:	89 c2                	mov    %eax,%edx
  8032dd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8032e0:	89 50 0c             	mov    %edx,0xc(%eax)
			blk->sva+= newblk->size;
  8032e3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8032e6:	8b 50 08             	mov    0x8(%eax),%edx
  8032e9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8032ec:	8b 40 0c             	mov    0xc(%eax),%eax
  8032ef:	01 c2                	add    %eax,%edx
  8032f1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8032f4:	89 50 08             	mov    %edx,0x8(%eax)
			return newblk;
  8032f7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8032fa:	eb 3b                	jmp    803337 <alloc_block_BF+0x2d3>
		{
	       newsize = blk->size;
		   newveradd = blk->sva;
		}
	}
	LIST_FOREACH(blk, &FreeMemBlocksList)
  8032fc:	a1 40 51 80 00       	mov    0x805140,%eax
  803301:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803304:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803308:	74 07                	je     803311 <alloc_block_BF+0x2ad>
  80330a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80330d:	8b 00                	mov    (%eax),%eax
  80330f:	eb 05                	jmp    803316 <alloc_block_BF+0x2b2>
  803311:	b8 00 00 00 00       	mov    $0x0,%eax
  803316:	a3 40 51 80 00       	mov    %eax,0x805140
  80331b:	a1 40 51 80 00       	mov    0x805140,%eax
  803320:	85 c0                	test   %eax,%eax
  803322:	0f 85 f8 fe ff ff    	jne    803220 <alloc_block_BF+0x1bc>
  803328:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80332c:	0f 85 ee fe ff ff    	jne    803220 <alloc_block_BF+0x1bc>
			blk->size = blk->size - versize;
			blk->sva+= newblk->size;
			return newblk;
		}
	}
	return NULL;
  803332:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803337:	c9                   	leave  
  803338:	c3                   	ret    

00803339 <alloc_block_NF>:
//=========================================
// [7] ALLOCATE BLOCK BY NEXT FIT:
//=========================================
struct MemBlock *last_allocate;
struct MemBlock *alloc_block_NF(uint32 size)
{
  803339:	55                   	push   %ebp
  80333a:	89 e5                	mov    %esp,%ebp
  80333c:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1 - BONUS] [DYNAMIC ALLOCATOR] alloc_block_NF
	// Write your code here, remove the panic and write your code
	//panic("alloc_block_NF() is not implemented yet...!!");
	uint32 versize = size;
  80333f:	8b 45 08             	mov    0x8(%ebp),%eax
  803342:	89 45 f0             	mov    %eax,-0x10(%ebp)
	struct MemBlock* blk;
	struct MemBlock* newblk = LIST_FIRST(&AvailableMemBlocksList);
  803345:	a1 48 51 80 00       	mov    0x805148,%eax
  80334a:	89 45 ec             	mov    %eax,-0x14(%ebp)

	LIST_FOREACH(blk,&FreeMemBlocksList)
  80334d:	a1 38 51 80 00       	mov    0x805138,%eax
  803352:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803355:	e9 77 01 00 00       	jmp    8034d1 <alloc_block_NF+0x198>
	{
		if(blk->size == versize)
  80335a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80335d:	8b 40 0c             	mov    0xc(%eax),%eax
  803360:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  803363:	0f 85 8a 00 00 00    	jne    8033f3 <alloc_block_NF+0xba>
		{
			LIST_REMOVE(&FreeMemBlocksList,blk);
  803369:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80336d:	75 17                	jne    803386 <alloc_block_NF+0x4d>
  80336f:	83 ec 04             	sub    $0x4,%esp
  803372:	68 28 46 80 00       	push   $0x804628
  803377:	68 f7 00 00 00       	push   $0xf7
  80337c:	68 b7 45 80 00       	push   $0x8045b7
  803381:	e8 6d da ff ff       	call   800df3 <_panic>
  803386:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803389:	8b 00                	mov    (%eax),%eax
  80338b:	85 c0                	test   %eax,%eax
  80338d:	74 10                	je     80339f <alloc_block_NF+0x66>
  80338f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803392:	8b 00                	mov    (%eax),%eax
  803394:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803397:	8b 52 04             	mov    0x4(%edx),%edx
  80339a:	89 50 04             	mov    %edx,0x4(%eax)
  80339d:	eb 0b                	jmp    8033aa <alloc_block_NF+0x71>
  80339f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8033a2:	8b 40 04             	mov    0x4(%eax),%eax
  8033a5:	a3 3c 51 80 00       	mov    %eax,0x80513c
  8033aa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8033ad:	8b 40 04             	mov    0x4(%eax),%eax
  8033b0:	85 c0                	test   %eax,%eax
  8033b2:	74 0f                	je     8033c3 <alloc_block_NF+0x8a>
  8033b4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8033b7:	8b 40 04             	mov    0x4(%eax),%eax
  8033ba:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8033bd:	8b 12                	mov    (%edx),%edx
  8033bf:	89 10                	mov    %edx,(%eax)
  8033c1:	eb 0a                	jmp    8033cd <alloc_block_NF+0x94>
  8033c3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8033c6:	8b 00                	mov    (%eax),%eax
  8033c8:	a3 38 51 80 00       	mov    %eax,0x805138
  8033cd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8033d0:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8033d6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8033d9:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8033e0:	a1 44 51 80 00       	mov    0x805144,%eax
  8033e5:	48                   	dec    %eax
  8033e6:	a3 44 51 80 00       	mov    %eax,0x805144
			return blk;
  8033eb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8033ee:	e9 11 01 00 00       	jmp    803504 <alloc_block_NF+0x1cb>
		}
		else if(blk->size > versize)
  8033f3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8033f6:	8b 40 0c             	mov    0xc(%eax),%eax
  8033f9:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8033fc:	0f 86 c7 00 00 00    	jbe    8034c9 <alloc_block_NF+0x190>
		{
			LIST_REMOVE(&AvailableMemBlocksList,newblk);
  803402:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  803406:	75 17                	jne    80341f <alloc_block_NF+0xe6>
  803408:	83 ec 04             	sub    $0x4,%esp
  80340b:	68 28 46 80 00       	push   $0x804628
  803410:	68 fc 00 00 00       	push   $0xfc
  803415:	68 b7 45 80 00       	push   $0x8045b7
  80341a:	e8 d4 d9 ff ff       	call   800df3 <_panic>
  80341f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803422:	8b 00                	mov    (%eax),%eax
  803424:	85 c0                	test   %eax,%eax
  803426:	74 10                	je     803438 <alloc_block_NF+0xff>
  803428:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80342b:	8b 00                	mov    (%eax),%eax
  80342d:	8b 55 ec             	mov    -0x14(%ebp),%edx
  803430:	8b 52 04             	mov    0x4(%edx),%edx
  803433:	89 50 04             	mov    %edx,0x4(%eax)
  803436:	eb 0b                	jmp    803443 <alloc_block_NF+0x10a>
  803438:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80343b:	8b 40 04             	mov    0x4(%eax),%eax
  80343e:	a3 4c 51 80 00       	mov    %eax,0x80514c
  803443:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803446:	8b 40 04             	mov    0x4(%eax),%eax
  803449:	85 c0                	test   %eax,%eax
  80344b:	74 0f                	je     80345c <alloc_block_NF+0x123>
  80344d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803450:	8b 40 04             	mov    0x4(%eax),%eax
  803453:	8b 55 ec             	mov    -0x14(%ebp),%edx
  803456:	8b 12                	mov    (%edx),%edx
  803458:	89 10                	mov    %edx,(%eax)
  80345a:	eb 0a                	jmp    803466 <alloc_block_NF+0x12d>
  80345c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80345f:	8b 00                	mov    (%eax),%eax
  803461:	a3 48 51 80 00       	mov    %eax,0x805148
  803466:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803469:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80346f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803472:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803479:	a1 54 51 80 00       	mov    0x805154,%eax
  80347e:	48                   	dec    %eax
  80347f:	a3 54 51 80 00       	mov    %eax,0x805154
			newblk->size = versize;
  803484:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803487:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80348a:	89 50 0c             	mov    %edx,0xc(%eax)
			blk->size = blk->size-versize;
  80348d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803490:	8b 40 0c             	mov    0xc(%eax),%eax
  803493:	2b 45 f0             	sub    -0x10(%ebp),%eax
  803496:	89 c2                	mov    %eax,%edx
  803498:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80349b:	89 50 0c             	mov    %edx,0xc(%eax)
			uint32 newveradd = blk->sva;
  80349e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8034a1:	8b 40 08             	mov    0x8(%eax),%eax
  8034a4:	89 45 e8             	mov    %eax,-0x18(%ebp)
			blk->sva+=newblk->size;
  8034a7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8034aa:	8b 50 08             	mov    0x8(%eax),%edx
  8034ad:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8034b0:	8b 40 0c             	mov    0xc(%eax),%eax
  8034b3:	01 c2                	add    %eax,%edx
  8034b5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8034b8:	89 50 08             	mov    %edx,0x8(%eax)
			newblk->sva = newveradd;
  8034bb:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8034be:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8034c1:	89 50 08             	mov    %edx,0x8(%eax)
			return newblk;
  8034c4:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8034c7:	eb 3b                	jmp    803504 <alloc_block_NF+0x1cb>
	//panic("alloc_block_NF() is not implemented yet...!!");
	uint32 versize = size;
	struct MemBlock* blk;
	struct MemBlock* newblk = LIST_FIRST(&AvailableMemBlocksList);

	LIST_FOREACH(blk,&FreeMemBlocksList)
  8034c9:	a1 40 51 80 00       	mov    0x805140,%eax
  8034ce:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8034d1:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8034d5:	74 07                	je     8034de <alloc_block_NF+0x1a5>
  8034d7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8034da:	8b 00                	mov    (%eax),%eax
  8034dc:	eb 05                	jmp    8034e3 <alloc_block_NF+0x1aa>
  8034de:	b8 00 00 00 00       	mov    $0x0,%eax
  8034e3:	a3 40 51 80 00       	mov    %eax,0x805140
  8034e8:	a1 40 51 80 00       	mov    0x805140,%eax
  8034ed:	85 c0                	test   %eax,%eax
  8034ef:	0f 85 65 fe ff ff    	jne    80335a <alloc_block_NF+0x21>
  8034f5:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8034f9:	0f 85 5b fe ff ff    	jne    80335a <alloc_block_NF+0x21>
			blk->sva+=newblk->size;
			newblk->sva = newveradd;
			return newblk;
		}
	}
	return NULL;
  8034ff:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803504:	c9                   	leave  
  803505:	c3                   	ret    

00803506 <addToAvailMemBlocksList>:

//===================================================
// [8] INSERT BLOCK (SORTED WITH MERGE) IN FREE LIST:
//===================================================
void addToAvailMemBlocksList(struct MemBlock *blockToInsert)
{
  803506:	55                   	push   %ebp
  803507:	89 e5                	mov    %esp,%ebp
  803509:	83 ec 08             	sub    $0x8,%esp
	blockToInsert->sva = 0;
  80350c:	8b 45 08             	mov    0x8(%ebp),%eax
  80350f:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
	blockToInsert->size = 0;
  803516:	8b 45 08             	mov    0x8(%ebp),%eax
  803519:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
	//add to avail
	LIST_INSERT_TAIL(&AvailableMemBlocksList, blockToInsert);
  803520:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803524:	75 17                	jne    80353d <addToAvailMemBlocksList+0x37>
  803526:	83 ec 04             	sub    $0x4,%esp
  803529:	68 d0 45 80 00       	push   $0x8045d0
  80352e:	68 10 01 00 00       	push   $0x110
  803533:	68 b7 45 80 00       	push   $0x8045b7
  803538:	e8 b6 d8 ff ff       	call   800df3 <_panic>
  80353d:	8b 15 4c 51 80 00    	mov    0x80514c,%edx
  803543:	8b 45 08             	mov    0x8(%ebp),%eax
  803546:	89 50 04             	mov    %edx,0x4(%eax)
  803549:	8b 45 08             	mov    0x8(%ebp),%eax
  80354c:	8b 40 04             	mov    0x4(%eax),%eax
  80354f:	85 c0                	test   %eax,%eax
  803551:	74 0c                	je     80355f <addToAvailMemBlocksList+0x59>
  803553:	a1 4c 51 80 00       	mov    0x80514c,%eax
  803558:	8b 55 08             	mov    0x8(%ebp),%edx
  80355b:	89 10                	mov    %edx,(%eax)
  80355d:	eb 08                	jmp    803567 <addToAvailMemBlocksList+0x61>
  80355f:	8b 45 08             	mov    0x8(%ebp),%eax
  803562:	a3 48 51 80 00       	mov    %eax,0x805148
  803567:	8b 45 08             	mov    0x8(%ebp),%eax
  80356a:	a3 4c 51 80 00       	mov    %eax,0x80514c
  80356f:	8b 45 08             	mov    0x8(%ebp),%eax
  803572:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803578:	a1 54 51 80 00       	mov    0x805154,%eax
  80357d:	40                   	inc    %eax
  80357e:	a3 54 51 80 00       	mov    %eax,0x805154
}
  803583:	90                   	nop
  803584:	c9                   	leave  
  803585:	c3                   	ret    

00803586 <insert_sorted_with_merge_freeList>:
void insert_sorted_with_merge_freeList(struct MemBlock *blockToInsert)
{
  803586:	55                   	push   %ebp
  803587:	89 e5                	mov    %esp,%ebp
  803589:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] insert_sorted_with_merge_freeList
	// Write your code here, remove the panic and write your code

	struct MemBlock* last = LIST_LAST(&FreeMemBlocksList);
  80358c:	a1 3c 51 80 00       	mov    0x80513c,%eax
  803591:	89 45 f0             	mov    %eax,-0x10(%ebp)
	//check if list empty
	if (LIST_SIZE(&(FreeMemBlocksList)) == 0)
  803594:	a1 44 51 80 00       	mov    0x805144,%eax
  803599:	85 c0                	test   %eax,%eax
  80359b:	75 68                	jne    803605 <insert_sorted_with_merge_freeList+0x7f>
		LIST_INSERT_HEAD(&FreeMemBlocksList, blockToInsert);
  80359d:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8035a1:	75 17                	jne    8035ba <insert_sorted_with_merge_freeList+0x34>
  8035a3:	83 ec 04             	sub    $0x4,%esp
  8035a6:	68 94 45 80 00       	push   $0x804594
  8035ab:	68 1a 01 00 00       	push   $0x11a
  8035b0:	68 b7 45 80 00       	push   $0x8045b7
  8035b5:	e8 39 d8 ff ff       	call   800df3 <_panic>
  8035ba:	8b 15 38 51 80 00    	mov    0x805138,%edx
  8035c0:	8b 45 08             	mov    0x8(%ebp),%eax
  8035c3:	89 10                	mov    %edx,(%eax)
  8035c5:	8b 45 08             	mov    0x8(%ebp),%eax
  8035c8:	8b 00                	mov    (%eax),%eax
  8035ca:	85 c0                	test   %eax,%eax
  8035cc:	74 0d                	je     8035db <insert_sorted_with_merge_freeList+0x55>
  8035ce:	a1 38 51 80 00       	mov    0x805138,%eax
  8035d3:	8b 55 08             	mov    0x8(%ebp),%edx
  8035d6:	89 50 04             	mov    %edx,0x4(%eax)
  8035d9:	eb 08                	jmp    8035e3 <insert_sorted_with_merge_freeList+0x5d>
  8035db:	8b 45 08             	mov    0x8(%ebp),%eax
  8035de:	a3 3c 51 80 00       	mov    %eax,0x80513c
  8035e3:	8b 45 08             	mov    0x8(%ebp),%eax
  8035e6:	a3 38 51 80 00       	mov    %eax,0x805138
  8035eb:	8b 45 08             	mov    0x8(%ebp),%eax
  8035ee:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8035f5:	a1 44 51 80 00       	mov    0x805144,%eax
  8035fa:	40                   	inc    %eax
  8035fb:	a3 44 51 80 00       	mov    %eax,0x805144
		}
	}

	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  803600:	e9 c5 03 00 00       	jmp    8039ca <insert_sorted_with_merge_freeList+0x444>
	struct MemBlock* last = LIST_LAST(&FreeMemBlocksList);
	//check if list empty
	if (LIST_SIZE(&(FreeMemBlocksList)) == 0)
		LIST_INSERT_HEAD(&FreeMemBlocksList, blockToInsert);
	//check if it's position is at last
	else if (last->sva < blockToInsert->sva) {
  803605:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803608:	8b 50 08             	mov    0x8(%eax),%edx
  80360b:	8b 45 08             	mov    0x8(%ebp),%eax
  80360e:	8b 40 08             	mov    0x8(%eax),%eax
  803611:	39 c2                	cmp    %eax,%edx
  803613:	0f 83 b2 00 00 00    	jae    8036cb <insert_sorted_with_merge_freeList+0x145>

		//if i have to merge
		if (last->sva + last->size == blockToInsert->sva) {
  803619:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80361c:	8b 50 08             	mov    0x8(%eax),%edx
  80361f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803622:	8b 40 0c             	mov    0xc(%eax),%eax
  803625:	01 c2                	add    %eax,%edx
  803627:	8b 45 08             	mov    0x8(%ebp),%eax
  80362a:	8b 40 08             	mov    0x8(%eax),%eax
  80362d:	39 c2                	cmp    %eax,%edx
  80362f:	75 27                	jne    803658 <insert_sorted_with_merge_freeList+0xd2>
			last->size = last->size + blockToInsert->size;
  803631:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803634:	8b 50 0c             	mov    0xc(%eax),%edx
  803637:	8b 45 08             	mov    0x8(%ebp),%eax
  80363a:	8b 40 0c             	mov    0xc(%eax),%eax
  80363d:	01 c2                	add    %eax,%edx
  80363f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803642:	89 50 0c             	mov    %edx,0xc(%eax)
			addToAvailMemBlocksList(blockToInsert);
  803645:	83 ec 0c             	sub    $0xc,%esp
  803648:	ff 75 08             	pushl  0x8(%ebp)
  80364b:	e8 b6 fe ff ff       	call   803506 <addToAvailMemBlocksList>
  803650:	83 c4 10             	add    $0x10,%esp
		}
	}

	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  803653:	e9 72 03 00 00       	jmp    8039ca <insert_sorted_with_merge_freeList+0x444>
		if (last->sva + last->size == blockToInsert->sva) {
			last->size = last->size + blockToInsert->size;
			addToAvailMemBlocksList(blockToInsert);

		} else {
			LIST_INSERT_AFTER(&FreeMemBlocksList, last, blockToInsert);
  803658:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80365c:	74 06                	je     803664 <insert_sorted_with_merge_freeList+0xde>
  80365e:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803662:	75 17                	jne    80367b <insert_sorted_with_merge_freeList+0xf5>
  803664:	83 ec 04             	sub    $0x4,%esp
  803667:	68 f4 45 80 00       	push   $0x8045f4
  80366c:	68 24 01 00 00       	push   $0x124
  803671:	68 b7 45 80 00       	push   $0x8045b7
  803676:	e8 78 d7 ff ff       	call   800df3 <_panic>
  80367b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80367e:	8b 10                	mov    (%eax),%edx
  803680:	8b 45 08             	mov    0x8(%ebp),%eax
  803683:	89 10                	mov    %edx,(%eax)
  803685:	8b 45 08             	mov    0x8(%ebp),%eax
  803688:	8b 00                	mov    (%eax),%eax
  80368a:	85 c0                	test   %eax,%eax
  80368c:	74 0b                	je     803699 <insert_sorted_with_merge_freeList+0x113>
  80368e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803691:	8b 00                	mov    (%eax),%eax
  803693:	8b 55 08             	mov    0x8(%ebp),%edx
  803696:	89 50 04             	mov    %edx,0x4(%eax)
  803699:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80369c:	8b 55 08             	mov    0x8(%ebp),%edx
  80369f:	89 10                	mov    %edx,(%eax)
  8036a1:	8b 45 08             	mov    0x8(%ebp),%eax
  8036a4:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8036a7:	89 50 04             	mov    %edx,0x4(%eax)
  8036aa:	8b 45 08             	mov    0x8(%ebp),%eax
  8036ad:	8b 00                	mov    (%eax),%eax
  8036af:	85 c0                	test   %eax,%eax
  8036b1:	75 08                	jne    8036bb <insert_sorted_with_merge_freeList+0x135>
  8036b3:	8b 45 08             	mov    0x8(%ebp),%eax
  8036b6:	a3 3c 51 80 00       	mov    %eax,0x80513c
  8036bb:	a1 44 51 80 00       	mov    0x805144,%eax
  8036c0:	40                   	inc    %eax
  8036c1:	a3 44 51 80 00       	mov    %eax,0x805144
		}
	}

	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  8036c6:	e9 ff 02 00 00       	jmp    8039ca <insert_sorted_with_merge_freeList+0x444>
		} else {
			LIST_INSERT_AFTER(&FreeMemBlocksList, last, blockToInsert);
		}
	} else {
		struct MemBlock *iterator;
		LIST_FOREACH(iterator, &(FreeMemBlocksList))
  8036cb:	a1 38 51 80 00       	mov    0x805138,%eax
  8036d0:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8036d3:	e9 c2 02 00 00       	jmp    80399a <insert_sorted_with_merge_freeList+0x414>
		{

			if (iterator->sva > blockToInsert->sva) {
  8036d8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8036db:	8b 50 08             	mov    0x8(%eax),%edx
  8036de:	8b 45 08             	mov    0x8(%ebp),%eax
  8036e1:	8b 40 08             	mov    0x8(%eax),%eax
  8036e4:	39 c2                	cmp    %eax,%edx
  8036e6:	0f 86 a6 02 00 00    	jbe    803992 <insert_sorted_with_merge_freeList+0x40c>

				struct MemBlock* prev = LIST_PREV(iterator);
  8036ec:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8036ef:	8b 40 04             	mov    0x4(%eax),%eax
  8036f2:	89 45 ec             	mov    %eax,-0x14(%ebp)
				if (prev == NULL) {
  8036f5:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8036f9:	0f 85 ba 00 00 00    	jne    8037b9 <insert_sorted_with_merge_freeList+0x233>
					//check merge
					if (blockToInsert->size + blockToInsert->sva
  8036ff:	8b 45 08             	mov    0x8(%ebp),%eax
  803702:	8b 50 0c             	mov    0xc(%eax),%edx
  803705:	8b 45 08             	mov    0x8(%ebp),%eax
  803708:	8b 40 08             	mov    0x8(%eax),%eax
  80370b:	01 c2                	add    %eax,%edx
							== iterator->sva) {
  80370d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803710:	8b 40 08             	mov    0x8(%eax),%eax
			if (iterator->sva > blockToInsert->sva) {

				struct MemBlock* prev = LIST_PREV(iterator);
				if (prev == NULL) {
					//check merge
					if (blockToInsert->size + blockToInsert->sva
  803713:	39 c2                	cmp    %eax,%edx
  803715:	75 33                	jne    80374a <insert_sorted_with_merge_freeList+0x1c4>
							== iterator->sva) {
						iterator->sva = blockToInsert->sva;
  803717:	8b 45 08             	mov    0x8(%ebp),%eax
  80371a:	8b 50 08             	mov    0x8(%eax),%edx
  80371d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803720:	89 50 08             	mov    %edx,0x8(%eax)
						iterator->size = iterator->size + blockToInsert->size;
  803723:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803726:	8b 50 0c             	mov    0xc(%eax),%edx
  803729:	8b 45 08             	mov    0x8(%ebp),%eax
  80372c:	8b 40 0c             	mov    0xc(%eax),%eax
  80372f:	01 c2                	add    %eax,%edx
  803731:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803734:	89 50 0c             	mov    %edx,0xc(%eax)
						addToAvailMemBlocksList(blockToInsert);
  803737:	83 ec 0c             	sub    $0xc,%esp
  80373a:	ff 75 08             	pushl  0x8(%ebp)
  80373d:	e8 c4 fd ff ff       	call   803506 <addToAvailMemBlocksList>
  803742:	83 c4 10             	add    $0x10,%esp

					else {
						LIST_INSERT_BEFORE(&FreeMemBlocksList, iterator,
								blockToInsert);
					}
					break;
  803745:	e9 80 02 00 00       	jmp    8039ca <insert_sorted_with_merge_freeList+0x444>
						addToAvailMemBlocksList(blockToInsert);

					}

					else {
						LIST_INSERT_BEFORE(&FreeMemBlocksList, iterator,
  80374a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80374e:	74 06                	je     803756 <insert_sorted_with_merge_freeList+0x1d0>
  803750:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803754:	75 17                	jne    80376d <insert_sorted_with_merge_freeList+0x1e7>
  803756:	83 ec 04             	sub    $0x4,%esp
  803759:	68 48 46 80 00       	push   $0x804648
  80375e:	68 3a 01 00 00       	push   $0x13a
  803763:	68 b7 45 80 00       	push   $0x8045b7
  803768:	e8 86 d6 ff ff       	call   800df3 <_panic>
  80376d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803770:	8b 50 04             	mov    0x4(%eax),%edx
  803773:	8b 45 08             	mov    0x8(%ebp),%eax
  803776:	89 50 04             	mov    %edx,0x4(%eax)
  803779:	8b 45 08             	mov    0x8(%ebp),%eax
  80377c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80377f:	89 10                	mov    %edx,(%eax)
  803781:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803784:	8b 40 04             	mov    0x4(%eax),%eax
  803787:	85 c0                	test   %eax,%eax
  803789:	74 0d                	je     803798 <insert_sorted_with_merge_freeList+0x212>
  80378b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80378e:	8b 40 04             	mov    0x4(%eax),%eax
  803791:	8b 55 08             	mov    0x8(%ebp),%edx
  803794:	89 10                	mov    %edx,(%eax)
  803796:	eb 08                	jmp    8037a0 <insert_sorted_with_merge_freeList+0x21a>
  803798:	8b 45 08             	mov    0x8(%ebp),%eax
  80379b:	a3 38 51 80 00       	mov    %eax,0x805138
  8037a0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8037a3:	8b 55 08             	mov    0x8(%ebp),%edx
  8037a6:	89 50 04             	mov    %edx,0x4(%eax)
  8037a9:	a1 44 51 80 00       	mov    0x805144,%eax
  8037ae:	40                   	inc    %eax
  8037af:	a3 44 51 80 00       	mov    %eax,0x805144
								blockToInsert);
					}
					break;
  8037b4:	e9 11 02 00 00       	jmp    8039ca <insert_sorted_with_merge_freeList+0x444>
				} else {
					//prev and next merge
					if (prev->sva + prev->size + blockToInsert->size
  8037b9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8037bc:	8b 50 08             	mov    0x8(%eax),%edx
  8037bf:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8037c2:	8b 40 0c             	mov    0xc(%eax),%eax
  8037c5:	01 c2                	add    %eax,%edx
  8037c7:	8b 45 08             	mov    0x8(%ebp),%eax
  8037ca:	8b 40 0c             	mov    0xc(%eax),%eax
  8037cd:	01 c2                	add    %eax,%edx
							== iterator->sva) {
  8037cf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8037d2:	8b 40 08             	mov    0x8(%eax),%eax
								blockToInsert);
					}
					break;
				} else {
					//prev and next merge
					if (prev->sva + prev->size + blockToInsert->size
  8037d5:	39 c2                	cmp    %eax,%edx
  8037d7:	0f 85 bf 00 00 00    	jne    80389c <insert_sorted_with_merge_freeList+0x316>
							== iterator->sva) {
						prev->size = prev->size + blockToInsert->size
  8037dd:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8037e0:	8b 50 0c             	mov    0xc(%eax),%edx
  8037e3:	8b 45 08             	mov    0x8(%ebp),%eax
  8037e6:	8b 40 0c             	mov    0xc(%eax),%eax
  8037e9:	01 c2                	add    %eax,%edx
								+ iterator->size;
  8037eb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8037ee:	8b 40 0c             	mov    0xc(%eax),%eax
  8037f1:	01 c2                	add    %eax,%edx
					break;
				} else {
					//prev and next merge
					if (prev->sva + prev->size + blockToInsert->size
							== iterator->sva) {
						prev->size = prev->size + blockToInsert->size
  8037f3:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8037f6:	89 50 0c             	mov    %edx,0xc(%eax)
								+ iterator->size;
						LIST_REMOVE(&FreeMemBlocksList, iterator);
  8037f9:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8037fd:	75 17                	jne    803816 <insert_sorted_with_merge_freeList+0x290>
  8037ff:	83 ec 04             	sub    $0x4,%esp
  803802:	68 28 46 80 00       	push   $0x804628
  803807:	68 43 01 00 00       	push   $0x143
  80380c:	68 b7 45 80 00       	push   $0x8045b7
  803811:	e8 dd d5 ff ff       	call   800df3 <_panic>
  803816:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803819:	8b 00                	mov    (%eax),%eax
  80381b:	85 c0                	test   %eax,%eax
  80381d:	74 10                	je     80382f <insert_sorted_with_merge_freeList+0x2a9>
  80381f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803822:	8b 00                	mov    (%eax),%eax
  803824:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803827:	8b 52 04             	mov    0x4(%edx),%edx
  80382a:	89 50 04             	mov    %edx,0x4(%eax)
  80382d:	eb 0b                	jmp    80383a <insert_sorted_with_merge_freeList+0x2b4>
  80382f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803832:	8b 40 04             	mov    0x4(%eax),%eax
  803835:	a3 3c 51 80 00       	mov    %eax,0x80513c
  80383a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80383d:	8b 40 04             	mov    0x4(%eax),%eax
  803840:	85 c0                	test   %eax,%eax
  803842:	74 0f                	je     803853 <insert_sorted_with_merge_freeList+0x2cd>
  803844:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803847:	8b 40 04             	mov    0x4(%eax),%eax
  80384a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80384d:	8b 12                	mov    (%edx),%edx
  80384f:	89 10                	mov    %edx,(%eax)
  803851:	eb 0a                	jmp    80385d <insert_sorted_with_merge_freeList+0x2d7>
  803853:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803856:	8b 00                	mov    (%eax),%eax
  803858:	a3 38 51 80 00       	mov    %eax,0x805138
  80385d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803860:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803866:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803869:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803870:	a1 44 51 80 00       	mov    0x805144,%eax
  803875:	48                   	dec    %eax
  803876:	a3 44 51 80 00       	mov    %eax,0x805144
						addToAvailMemBlocksList(blockToInsert);
  80387b:	83 ec 0c             	sub    $0xc,%esp
  80387e:	ff 75 08             	pushl  0x8(%ebp)
  803881:	e8 80 fc ff ff       	call   803506 <addToAvailMemBlocksList>
  803886:	83 c4 10             	add    $0x10,%esp
						addToAvailMemBlocksList(iterator);
  803889:	83 ec 0c             	sub    $0xc,%esp
  80388c:	ff 75 f4             	pushl  -0xc(%ebp)
  80388f:	e8 72 fc ff ff       	call   803506 <addToAvailMemBlocksList>
  803894:	83 c4 10             	add    $0x10,%esp
					//Insert
					else {
						LIST_INSERT_BEFORE(&FreeMemBlocksList, iterator,
								blockToInsert);
					}
					break;
  803897:	e9 2e 01 00 00       	jmp    8039ca <insert_sorted_with_merge_freeList+0x444>
						LIST_REMOVE(&FreeMemBlocksList, iterator);
						addToAvailMemBlocksList(blockToInsert);
						addToAvailMemBlocksList(iterator);
					}
					//previous merge
					else if (prev->sva + prev->size == blockToInsert->sva) {
  80389c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80389f:	8b 50 08             	mov    0x8(%eax),%edx
  8038a2:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8038a5:	8b 40 0c             	mov    0xc(%eax),%eax
  8038a8:	01 c2                	add    %eax,%edx
  8038aa:	8b 45 08             	mov    0x8(%ebp),%eax
  8038ad:	8b 40 08             	mov    0x8(%eax),%eax
  8038b0:	39 c2                	cmp    %eax,%edx
  8038b2:	75 27                	jne    8038db <insert_sorted_with_merge_freeList+0x355>
						prev->size = prev->size + blockToInsert->size;
  8038b4:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8038b7:	8b 50 0c             	mov    0xc(%eax),%edx
  8038ba:	8b 45 08             	mov    0x8(%ebp),%eax
  8038bd:	8b 40 0c             	mov    0xc(%eax),%eax
  8038c0:	01 c2                	add    %eax,%edx
  8038c2:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8038c5:	89 50 0c             	mov    %edx,0xc(%eax)
						addToAvailMemBlocksList(blockToInsert);
  8038c8:	83 ec 0c             	sub    $0xc,%esp
  8038cb:	ff 75 08             	pushl  0x8(%ebp)
  8038ce:	e8 33 fc ff ff       	call   803506 <addToAvailMemBlocksList>
  8038d3:	83 c4 10             	add    $0x10,%esp
					//Insert
					else {
						LIST_INSERT_BEFORE(&FreeMemBlocksList, iterator,
								blockToInsert);
					}
					break;
  8038d6:	e9 ef 00 00 00       	jmp    8039ca <insert_sorted_with_merge_freeList+0x444>
					else if (prev->sva + prev->size == blockToInsert->sva) {
						prev->size = prev->size + blockToInsert->size;
						addToAvailMemBlocksList(blockToInsert);
					}
					//next merge
					else if (blockToInsert->size + blockToInsert->sva
  8038db:	8b 45 08             	mov    0x8(%ebp),%eax
  8038de:	8b 50 0c             	mov    0xc(%eax),%edx
  8038e1:	8b 45 08             	mov    0x8(%ebp),%eax
  8038e4:	8b 40 08             	mov    0x8(%eax),%eax
  8038e7:	01 c2                	add    %eax,%edx
							== iterator->sva) {
  8038e9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8038ec:	8b 40 08             	mov    0x8(%eax),%eax
					else if (prev->sva + prev->size == blockToInsert->sva) {
						prev->size = prev->size + blockToInsert->size;
						addToAvailMemBlocksList(blockToInsert);
					}
					//next merge
					else if (blockToInsert->size + blockToInsert->sva
  8038ef:	39 c2                	cmp    %eax,%edx
  8038f1:	75 33                	jne    803926 <insert_sorted_with_merge_freeList+0x3a0>
							== iterator->sva) {
						iterator->sva = blockToInsert->sva;
  8038f3:	8b 45 08             	mov    0x8(%ebp),%eax
  8038f6:	8b 50 08             	mov    0x8(%eax),%edx
  8038f9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8038fc:	89 50 08             	mov    %edx,0x8(%eax)
						iterator->size = iterator->size + blockToInsert->size;
  8038ff:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803902:	8b 50 0c             	mov    0xc(%eax),%edx
  803905:	8b 45 08             	mov    0x8(%ebp),%eax
  803908:	8b 40 0c             	mov    0xc(%eax),%eax
  80390b:	01 c2                	add    %eax,%edx
  80390d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803910:	89 50 0c             	mov    %edx,0xc(%eax)
						addToAvailMemBlocksList(blockToInsert);
  803913:	83 ec 0c             	sub    $0xc,%esp
  803916:	ff 75 08             	pushl  0x8(%ebp)
  803919:	e8 e8 fb ff ff       	call   803506 <addToAvailMemBlocksList>
  80391e:	83 c4 10             	add    $0x10,%esp
					//Insert
					else {
						LIST_INSERT_BEFORE(&FreeMemBlocksList, iterator,
								blockToInsert);
					}
					break;
  803921:	e9 a4 00 00 00       	jmp    8039ca <insert_sorted_with_merge_freeList+0x444>
						iterator->size = iterator->size + blockToInsert->size;
						addToAvailMemBlocksList(blockToInsert);
					}
					//Insert
					else {
						LIST_INSERT_BEFORE(&FreeMemBlocksList, iterator,
  803926:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80392a:	74 06                	je     803932 <insert_sorted_with_merge_freeList+0x3ac>
  80392c:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803930:	75 17                	jne    803949 <insert_sorted_with_merge_freeList+0x3c3>
  803932:	83 ec 04             	sub    $0x4,%esp
  803935:	68 48 46 80 00       	push   $0x804648
  80393a:	68 56 01 00 00       	push   $0x156
  80393f:	68 b7 45 80 00       	push   $0x8045b7
  803944:	e8 aa d4 ff ff       	call   800df3 <_panic>
  803949:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80394c:	8b 50 04             	mov    0x4(%eax),%edx
  80394f:	8b 45 08             	mov    0x8(%ebp),%eax
  803952:	89 50 04             	mov    %edx,0x4(%eax)
  803955:	8b 45 08             	mov    0x8(%ebp),%eax
  803958:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80395b:	89 10                	mov    %edx,(%eax)
  80395d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803960:	8b 40 04             	mov    0x4(%eax),%eax
  803963:	85 c0                	test   %eax,%eax
  803965:	74 0d                	je     803974 <insert_sorted_with_merge_freeList+0x3ee>
  803967:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80396a:	8b 40 04             	mov    0x4(%eax),%eax
  80396d:	8b 55 08             	mov    0x8(%ebp),%edx
  803970:	89 10                	mov    %edx,(%eax)
  803972:	eb 08                	jmp    80397c <insert_sorted_with_merge_freeList+0x3f6>
  803974:	8b 45 08             	mov    0x8(%ebp),%eax
  803977:	a3 38 51 80 00       	mov    %eax,0x805138
  80397c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80397f:	8b 55 08             	mov    0x8(%ebp),%edx
  803982:	89 50 04             	mov    %edx,0x4(%eax)
  803985:	a1 44 51 80 00       	mov    0x805144,%eax
  80398a:	40                   	inc    %eax
  80398b:	a3 44 51 80 00       	mov    %eax,0x805144
								blockToInsert);
					}
					break;
  803990:	eb 38                	jmp    8039ca <insert_sorted_with_merge_freeList+0x444>
		} else {
			LIST_INSERT_AFTER(&FreeMemBlocksList, last, blockToInsert);
		}
	} else {
		struct MemBlock *iterator;
		LIST_FOREACH(iterator, &(FreeMemBlocksList))
  803992:	a1 40 51 80 00       	mov    0x805140,%eax
  803997:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80399a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80399e:	74 07                	je     8039a7 <insert_sorted_with_merge_freeList+0x421>
  8039a0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8039a3:	8b 00                	mov    (%eax),%eax
  8039a5:	eb 05                	jmp    8039ac <insert_sorted_with_merge_freeList+0x426>
  8039a7:	b8 00 00 00 00       	mov    $0x0,%eax
  8039ac:	a3 40 51 80 00       	mov    %eax,0x805140
  8039b1:	a1 40 51 80 00       	mov    0x805140,%eax
  8039b6:	85 c0                	test   %eax,%eax
  8039b8:	0f 85 1a fd ff ff    	jne    8036d8 <insert_sorted_with_merge_freeList+0x152>
  8039be:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8039c2:	0f 85 10 fd ff ff    	jne    8036d8 <insert_sorted_with_merge_freeList+0x152>
		}
	}

	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  8039c8:	eb 00                	jmp    8039ca <insert_sorted_with_merge_freeList+0x444>
  8039ca:	90                   	nop
  8039cb:	c9                   	leave  
  8039cc:	c3                   	ret    
  8039cd:	66 90                	xchg   %ax,%ax
  8039cf:	90                   	nop

008039d0 <__udivdi3>:
  8039d0:	55                   	push   %ebp
  8039d1:	57                   	push   %edi
  8039d2:	56                   	push   %esi
  8039d3:	53                   	push   %ebx
  8039d4:	83 ec 1c             	sub    $0x1c,%esp
  8039d7:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  8039db:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  8039df:	8b 7c 24 38          	mov    0x38(%esp),%edi
  8039e3:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8039e7:	89 ca                	mov    %ecx,%edx
  8039e9:	89 f8                	mov    %edi,%eax
  8039eb:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  8039ef:	85 f6                	test   %esi,%esi
  8039f1:	75 2d                	jne    803a20 <__udivdi3+0x50>
  8039f3:	39 cf                	cmp    %ecx,%edi
  8039f5:	77 65                	ja     803a5c <__udivdi3+0x8c>
  8039f7:	89 fd                	mov    %edi,%ebp
  8039f9:	85 ff                	test   %edi,%edi
  8039fb:	75 0b                	jne    803a08 <__udivdi3+0x38>
  8039fd:	b8 01 00 00 00       	mov    $0x1,%eax
  803a02:	31 d2                	xor    %edx,%edx
  803a04:	f7 f7                	div    %edi
  803a06:	89 c5                	mov    %eax,%ebp
  803a08:	31 d2                	xor    %edx,%edx
  803a0a:	89 c8                	mov    %ecx,%eax
  803a0c:	f7 f5                	div    %ebp
  803a0e:	89 c1                	mov    %eax,%ecx
  803a10:	89 d8                	mov    %ebx,%eax
  803a12:	f7 f5                	div    %ebp
  803a14:	89 cf                	mov    %ecx,%edi
  803a16:	89 fa                	mov    %edi,%edx
  803a18:	83 c4 1c             	add    $0x1c,%esp
  803a1b:	5b                   	pop    %ebx
  803a1c:	5e                   	pop    %esi
  803a1d:	5f                   	pop    %edi
  803a1e:	5d                   	pop    %ebp
  803a1f:	c3                   	ret    
  803a20:	39 ce                	cmp    %ecx,%esi
  803a22:	77 28                	ja     803a4c <__udivdi3+0x7c>
  803a24:	0f bd fe             	bsr    %esi,%edi
  803a27:	83 f7 1f             	xor    $0x1f,%edi
  803a2a:	75 40                	jne    803a6c <__udivdi3+0x9c>
  803a2c:	39 ce                	cmp    %ecx,%esi
  803a2e:	72 0a                	jb     803a3a <__udivdi3+0x6a>
  803a30:	3b 44 24 08          	cmp    0x8(%esp),%eax
  803a34:	0f 87 9e 00 00 00    	ja     803ad8 <__udivdi3+0x108>
  803a3a:	b8 01 00 00 00       	mov    $0x1,%eax
  803a3f:	89 fa                	mov    %edi,%edx
  803a41:	83 c4 1c             	add    $0x1c,%esp
  803a44:	5b                   	pop    %ebx
  803a45:	5e                   	pop    %esi
  803a46:	5f                   	pop    %edi
  803a47:	5d                   	pop    %ebp
  803a48:	c3                   	ret    
  803a49:	8d 76 00             	lea    0x0(%esi),%esi
  803a4c:	31 ff                	xor    %edi,%edi
  803a4e:	31 c0                	xor    %eax,%eax
  803a50:	89 fa                	mov    %edi,%edx
  803a52:	83 c4 1c             	add    $0x1c,%esp
  803a55:	5b                   	pop    %ebx
  803a56:	5e                   	pop    %esi
  803a57:	5f                   	pop    %edi
  803a58:	5d                   	pop    %ebp
  803a59:	c3                   	ret    
  803a5a:	66 90                	xchg   %ax,%ax
  803a5c:	89 d8                	mov    %ebx,%eax
  803a5e:	f7 f7                	div    %edi
  803a60:	31 ff                	xor    %edi,%edi
  803a62:	89 fa                	mov    %edi,%edx
  803a64:	83 c4 1c             	add    $0x1c,%esp
  803a67:	5b                   	pop    %ebx
  803a68:	5e                   	pop    %esi
  803a69:	5f                   	pop    %edi
  803a6a:	5d                   	pop    %ebp
  803a6b:	c3                   	ret    
  803a6c:	bd 20 00 00 00       	mov    $0x20,%ebp
  803a71:	89 eb                	mov    %ebp,%ebx
  803a73:	29 fb                	sub    %edi,%ebx
  803a75:	89 f9                	mov    %edi,%ecx
  803a77:	d3 e6                	shl    %cl,%esi
  803a79:	89 c5                	mov    %eax,%ebp
  803a7b:	88 d9                	mov    %bl,%cl
  803a7d:	d3 ed                	shr    %cl,%ebp
  803a7f:	89 e9                	mov    %ebp,%ecx
  803a81:	09 f1                	or     %esi,%ecx
  803a83:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  803a87:	89 f9                	mov    %edi,%ecx
  803a89:	d3 e0                	shl    %cl,%eax
  803a8b:	89 c5                	mov    %eax,%ebp
  803a8d:	89 d6                	mov    %edx,%esi
  803a8f:	88 d9                	mov    %bl,%cl
  803a91:	d3 ee                	shr    %cl,%esi
  803a93:	89 f9                	mov    %edi,%ecx
  803a95:	d3 e2                	shl    %cl,%edx
  803a97:	8b 44 24 08          	mov    0x8(%esp),%eax
  803a9b:	88 d9                	mov    %bl,%cl
  803a9d:	d3 e8                	shr    %cl,%eax
  803a9f:	09 c2                	or     %eax,%edx
  803aa1:	89 d0                	mov    %edx,%eax
  803aa3:	89 f2                	mov    %esi,%edx
  803aa5:	f7 74 24 0c          	divl   0xc(%esp)
  803aa9:	89 d6                	mov    %edx,%esi
  803aab:	89 c3                	mov    %eax,%ebx
  803aad:	f7 e5                	mul    %ebp
  803aaf:	39 d6                	cmp    %edx,%esi
  803ab1:	72 19                	jb     803acc <__udivdi3+0xfc>
  803ab3:	74 0b                	je     803ac0 <__udivdi3+0xf0>
  803ab5:	89 d8                	mov    %ebx,%eax
  803ab7:	31 ff                	xor    %edi,%edi
  803ab9:	e9 58 ff ff ff       	jmp    803a16 <__udivdi3+0x46>
  803abe:	66 90                	xchg   %ax,%ax
  803ac0:	8b 54 24 08          	mov    0x8(%esp),%edx
  803ac4:	89 f9                	mov    %edi,%ecx
  803ac6:	d3 e2                	shl    %cl,%edx
  803ac8:	39 c2                	cmp    %eax,%edx
  803aca:	73 e9                	jae    803ab5 <__udivdi3+0xe5>
  803acc:	8d 43 ff             	lea    -0x1(%ebx),%eax
  803acf:	31 ff                	xor    %edi,%edi
  803ad1:	e9 40 ff ff ff       	jmp    803a16 <__udivdi3+0x46>
  803ad6:	66 90                	xchg   %ax,%ax
  803ad8:	31 c0                	xor    %eax,%eax
  803ada:	e9 37 ff ff ff       	jmp    803a16 <__udivdi3+0x46>
  803adf:	90                   	nop

00803ae0 <__umoddi3>:
  803ae0:	55                   	push   %ebp
  803ae1:	57                   	push   %edi
  803ae2:	56                   	push   %esi
  803ae3:	53                   	push   %ebx
  803ae4:	83 ec 1c             	sub    $0x1c,%esp
  803ae7:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  803aeb:	8b 74 24 34          	mov    0x34(%esp),%esi
  803aef:	8b 7c 24 38          	mov    0x38(%esp),%edi
  803af3:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  803af7:	89 44 24 0c          	mov    %eax,0xc(%esp)
  803afb:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  803aff:	89 f3                	mov    %esi,%ebx
  803b01:	89 fa                	mov    %edi,%edx
  803b03:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  803b07:	89 34 24             	mov    %esi,(%esp)
  803b0a:	85 c0                	test   %eax,%eax
  803b0c:	75 1a                	jne    803b28 <__umoddi3+0x48>
  803b0e:	39 f7                	cmp    %esi,%edi
  803b10:	0f 86 a2 00 00 00    	jbe    803bb8 <__umoddi3+0xd8>
  803b16:	89 c8                	mov    %ecx,%eax
  803b18:	89 f2                	mov    %esi,%edx
  803b1a:	f7 f7                	div    %edi
  803b1c:	89 d0                	mov    %edx,%eax
  803b1e:	31 d2                	xor    %edx,%edx
  803b20:	83 c4 1c             	add    $0x1c,%esp
  803b23:	5b                   	pop    %ebx
  803b24:	5e                   	pop    %esi
  803b25:	5f                   	pop    %edi
  803b26:	5d                   	pop    %ebp
  803b27:	c3                   	ret    
  803b28:	39 f0                	cmp    %esi,%eax
  803b2a:	0f 87 ac 00 00 00    	ja     803bdc <__umoddi3+0xfc>
  803b30:	0f bd e8             	bsr    %eax,%ebp
  803b33:	83 f5 1f             	xor    $0x1f,%ebp
  803b36:	0f 84 ac 00 00 00    	je     803be8 <__umoddi3+0x108>
  803b3c:	bf 20 00 00 00       	mov    $0x20,%edi
  803b41:	29 ef                	sub    %ebp,%edi
  803b43:	89 fe                	mov    %edi,%esi
  803b45:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  803b49:	89 e9                	mov    %ebp,%ecx
  803b4b:	d3 e0                	shl    %cl,%eax
  803b4d:	89 d7                	mov    %edx,%edi
  803b4f:	89 f1                	mov    %esi,%ecx
  803b51:	d3 ef                	shr    %cl,%edi
  803b53:	09 c7                	or     %eax,%edi
  803b55:	89 e9                	mov    %ebp,%ecx
  803b57:	d3 e2                	shl    %cl,%edx
  803b59:	89 14 24             	mov    %edx,(%esp)
  803b5c:	89 d8                	mov    %ebx,%eax
  803b5e:	d3 e0                	shl    %cl,%eax
  803b60:	89 c2                	mov    %eax,%edx
  803b62:	8b 44 24 08          	mov    0x8(%esp),%eax
  803b66:	d3 e0                	shl    %cl,%eax
  803b68:	89 44 24 04          	mov    %eax,0x4(%esp)
  803b6c:	8b 44 24 08          	mov    0x8(%esp),%eax
  803b70:	89 f1                	mov    %esi,%ecx
  803b72:	d3 e8                	shr    %cl,%eax
  803b74:	09 d0                	or     %edx,%eax
  803b76:	d3 eb                	shr    %cl,%ebx
  803b78:	89 da                	mov    %ebx,%edx
  803b7a:	f7 f7                	div    %edi
  803b7c:	89 d3                	mov    %edx,%ebx
  803b7e:	f7 24 24             	mull   (%esp)
  803b81:	89 c6                	mov    %eax,%esi
  803b83:	89 d1                	mov    %edx,%ecx
  803b85:	39 d3                	cmp    %edx,%ebx
  803b87:	0f 82 87 00 00 00    	jb     803c14 <__umoddi3+0x134>
  803b8d:	0f 84 91 00 00 00    	je     803c24 <__umoddi3+0x144>
  803b93:	8b 54 24 04          	mov    0x4(%esp),%edx
  803b97:	29 f2                	sub    %esi,%edx
  803b99:	19 cb                	sbb    %ecx,%ebx
  803b9b:	89 d8                	mov    %ebx,%eax
  803b9d:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  803ba1:	d3 e0                	shl    %cl,%eax
  803ba3:	89 e9                	mov    %ebp,%ecx
  803ba5:	d3 ea                	shr    %cl,%edx
  803ba7:	09 d0                	or     %edx,%eax
  803ba9:	89 e9                	mov    %ebp,%ecx
  803bab:	d3 eb                	shr    %cl,%ebx
  803bad:	89 da                	mov    %ebx,%edx
  803baf:	83 c4 1c             	add    $0x1c,%esp
  803bb2:	5b                   	pop    %ebx
  803bb3:	5e                   	pop    %esi
  803bb4:	5f                   	pop    %edi
  803bb5:	5d                   	pop    %ebp
  803bb6:	c3                   	ret    
  803bb7:	90                   	nop
  803bb8:	89 fd                	mov    %edi,%ebp
  803bba:	85 ff                	test   %edi,%edi
  803bbc:	75 0b                	jne    803bc9 <__umoddi3+0xe9>
  803bbe:	b8 01 00 00 00       	mov    $0x1,%eax
  803bc3:	31 d2                	xor    %edx,%edx
  803bc5:	f7 f7                	div    %edi
  803bc7:	89 c5                	mov    %eax,%ebp
  803bc9:	89 f0                	mov    %esi,%eax
  803bcb:	31 d2                	xor    %edx,%edx
  803bcd:	f7 f5                	div    %ebp
  803bcf:	89 c8                	mov    %ecx,%eax
  803bd1:	f7 f5                	div    %ebp
  803bd3:	89 d0                	mov    %edx,%eax
  803bd5:	e9 44 ff ff ff       	jmp    803b1e <__umoddi3+0x3e>
  803bda:	66 90                	xchg   %ax,%ax
  803bdc:	89 c8                	mov    %ecx,%eax
  803bde:	89 f2                	mov    %esi,%edx
  803be0:	83 c4 1c             	add    $0x1c,%esp
  803be3:	5b                   	pop    %ebx
  803be4:	5e                   	pop    %esi
  803be5:	5f                   	pop    %edi
  803be6:	5d                   	pop    %ebp
  803be7:	c3                   	ret    
  803be8:	3b 04 24             	cmp    (%esp),%eax
  803beb:	72 06                	jb     803bf3 <__umoddi3+0x113>
  803bed:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  803bf1:	77 0f                	ja     803c02 <__umoddi3+0x122>
  803bf3:	89 f2                	mov    %esi,%edx
  803bf5:	29 f9                	sub    %edi,%ecx
  803bf7:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  803bfb:	89 14 24             	mov    %edx,(%esp)
  803bfe:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  803c02:	8b 44 24 04          	mov    0x4(%esp),%eax
  803c06:	8b 14 24             	mov    (%esp),%edx
  803c09:	83 c4 1c             	add    $0x1c,%esp
  803c0c:	5b                   	pop    %ebx
  803c0d:	5e                   	pop    %esi
  803c0e:	5f                   	pop    %edi
  803c0f:	5d                   	pop    %ebp
  803c10:	c3                   	ret    
  803c11:	8d 76 00             	lea    0x0(%esi),%esi
  803c14:	2b 04 24             	sub    (%esp),%eax
  803c17:	19 fa                	sbb    %edi,%edx
  803c19:	89 d1                	mov    %edx,%ecx
  803c1b:	89 c6                	mov    %eax,%esi
  803c1d:	e9 71 ff ff ff       	jmp    803b93 <__umoddi3+0xb3>
  803c22:	66 90                	xchg   %ax,%ax
  803c24:	39 44 24 04          	cmp    %eax,0x4(%esp)
  803c28:	72 ea                	jb     803c14 <__umoddi3+0x134>
  803c2a:	89 d9                	mov    %ebx,%ecx
  803c2c:	e9 62 ff ff ff       	jmp    803b93 <__umoddi3+0xb3>
