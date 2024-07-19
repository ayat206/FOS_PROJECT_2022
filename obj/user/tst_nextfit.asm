
obj/user/tst_nextfit:     file format elf32-i386


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
  800031:	e8 b6 0b 00 00       	call   800bec <libmain>
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
	int Mega = 1024*1024;
  800043:	c7 45 d8 00 00 10 00 	movl   $0x100000,-0x28(%ebp)
	int kilo = 1024;
  80004a:	c7 45 d4 00 04 00 00 	movl   $0x400,-0x2c(%ebp)
	sys_set_uheap_strategy(UHP_PLACE_NEXTFIT);
  800051:	83 ec 0c             	sub    $0xc,%esp
  800054:	6a 03                	push   $0x3
  800056:	e8 34 28 00 00       	call   80288f <sys_set_uheap_strategy>
  80005b:	83 c4 10             	add    $0x10,%esp

	//Initial test to ensure it works on "PLACEMENT" not "REPLACEMENT"
	{
		uint8 fullWS = 1;
  80005e:	c6 45 f7 01          	movb   $0x1,-0x9(%ebp)
		for (int i = 0; i < myEnv->page_WS_max_size; ++i)
  800062:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800069:	eb 29                	jmp    800094 <_main+0x5c>
		{
			if (myEnv->__uptr_pws[i].empty)
  80006b:	a1 20 50 80 00       	mov    0x805020,%eax
  800070:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  800076:	8b 55 f0             	mov    -0x10(%ebp),%edx
  800079:	89 d0                	mov    %edx,%eax
  80007b:	01 c0                	add    %eax,%eax
  80007d:	01 d0                	add    %edx,%eax
  80007f:	c1 e0 03             	shl    $0x3,%eax
  800082:	01 c8                	add    %ecx,%eax
  800084:	8a 40 04             	mov    0x4(%eax),%al
  800087:	84 c0                	test   %al,%al
  800089:	74 06                	je     800091 <_main+0x59>
			{
				fullWS = 0;
  80008b:	c6 45 f7 00          	movb   $0x0,-0x9(%ebp)
				break;
  80008f:	eb 12                	jmp    8000a3 <_main+0x6b>
	sys_set_uheap_strategy(UHP_PLACE_NEXTFIT);

	//Initial test to ensure it works on "PLACEMENT" not "REPLACEMENT"
	{
		uint8 fullWS = 1;
		for (int i = 0; i < myEnv->page_WS_max_size; ++i)
  800091:	ff 45 f0             	incl   -0x10(%ebp)
  800094:	a1 20 50 80 00       	mov    0x805020,%eax
  800099:	8b 50 74             	mov    0x74(%eax),%edx
  80009c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80009f:	39 c2                	cmp    %eax,%edx
  8000a1:	77 c8                	ja     80006b <_main+0x33>
			{
				fullWS = 0;
				break;
			}
		}
		if (fullWS) panic("Please increase the WS size");
  8000a3:	80 7d f7 00          	cmpb   $0x0,-0x9(%ebp)
  8000a7:	74 14                	je     8000bd <_main+0x85>
  8000a9:	83 ec 04             	sub    $0x4,%esp
  8000ac:	68 80 3b 80 00       	push   $0x803b80
  8000b1:	6a 18                	push   $0x18
  8000b3:	68 9c 3b 80 00       	push   $0x803b9c
  8000b8:	e8 6b 0c 00 00       	call   800d28 <_panic>
	}
	/*Dummy malloc to enforce the UHEAP initializations*/
	malloc(0);
  8000bd:	83 ec 0c             	sub    $0xc,%esp
  8000c0:	6a 00                	push   $0x0
  8000c2:	e8 a7 1e 00 00       	call   801f6e <malloc>
  8000c7:	83 c4 10             	add    $0x10,%esp
	/*=================================================*/

	//Make sure that the heap size is 512 MB
	int numOf2MBsInHeap = (USER_HEAP_MAX - USER_HEAP_START) / (2*Mega);
  8000ca:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8000cd:	01 c0                	add    %eax,%eax
  8000cf:	89 c7                	mov    %eax,%edi
  8000d1:	b8 00 00 00 20       	mov    $0x20000000,%eax
  8000d6:	ba 00 00 00 00       	mov    $0x0,%edx
  8000db:	f7 f7                	div    %edi
  8000dd:	89 45 d0             	mov    %eax,-0x30(%ebp)
	assert(numOf2MBsInHeap == 256);
  8000e0:	81 7d d0 00 01 00 00 	cmpl   $0x100,-0x30(%ebp)
  8000e7:	74 16                	je     8000ff <_main+0xc7>
  8000e9:	68 af 3b 80 00       	push   $0x803baf
  8000ee:	68 c6 3b 80 00       	push   $0x803bc6
  8000f3:	6a 20                	push   $0x20
  8000f5:	68 9c 3b 80 00       	push   $0x803b9c
  8000fa:	e8 29 0c 00 00       	call   800d28 <_panic>




	sys_set_uheap_strategy(UHP_PLACE_NEXTFIT);
  8000ff:	83 ec 0c             	sub    $0xc,%esp
  800102:	6a 03                	push   $0x3
  800104:	e8 86 27 00 00       	call   80288f <sys_set_uheap_strategy>
  800109:	83 c4 10             	add    $0x10,%esp

	//Initial test to ensure it works on "PLACEMENT" not "REPLACEMENT"
	{
		uint8 fullWS = 1;
  80010c:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
		for (int i = 0; i < myEnv->page_WS_max_size; ++i)
  800110:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  800117:	eb 29                	jmp    800142 <_main+0x10a>
		{
			if (myEnv->__uptr_pws[i].empty)
  800119:	a1 20 50 80 00       	mov    0x805020,%eax
  80011e:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  800124:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800127:	89 d0                	mov    %edx,%eax
  800129:	01 c0                	add    %eax,%eax
  80012b:	01 d0                	add    %edx,%eax
  80012d:	c1 e0 03             	shl    $0x3,%eax
  800130:	01 c8                	add    %ecx,%eax
  800132:	8a 40 04             	mov    0x4(%eax),%al
  800135:	84 c0                	test   %al,%al
  800137:	74 06                	je     80013f <_main+0x107>
			{
				fullWS = 0;
  800139:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
				break;
  80013d:	eb 12                	jmp    800151 <_main+0x119>
	sys_set_uheap_strategy(UHP_PLACE_NEXTFIT);

	//Initial test to ensure it works on "PLACEMENT" not "REPLACEMENT"
	{
		uint8 fullWS = 1;
		for (int i = 0; i < myEnv->page_WS_max_size; ++i)
  80013f:	ff 45 e8             	incl   -0x18(%ebp)
  800142:	a1 20 50 80 00       	mov    0x805020,%eax
  800147:	8b 50 74             	mov    0x74(%eax),%edx
  80014a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80014d:	39 c2                	cmp    %eax,%edx
  80014f:	77 c8                	ja     800119 <_main+0xe1>
			{
				fullWS = 0;
				break;
			}
		}
		if (fullWS) panic("Please increase the WS size");
  800151:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  800155:	74 14                	je     80016b <_main+0x133>
  800157:	83 ec 04             	sub    $0x4,%esp
  80015a:	68 80 3b 80 00       	push   $0x803b80
  80015f:	6a 32                	push   $0x32
  800161:	68 9c 3b 80 00       	push   $0x803b9c
  800166:	e8 bd 0b 00 00       	call   800d28 <_panic>

	int freeFrames ;
	int usedDiskPages;

	//[0] Make sure there're available places in the WS
	int w = 0 ;
  80016b:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	int requiredNumOfEmptyWSLocs = 2;
  800172:	c7 45 cc 02 00 00 00 	movl   $0x2,-0x34(%ebp)
	int numOfEmptyWSLocs = 0;
  800179:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
	for (w = 0 ; w < myEnv->page_WS_max_size ; w++)
  800180:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  800187:	eb 26                	jmp    8001af <_main+0x177>
	{
		if( myEnv->__uptr_pws[w].empty == 1)
  800189:	a1 20 50 80 00       	mov    0x805020,%eax
  80018e:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  800194:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  800197:	89 d0                	mov    %edx,%eax
  800199:	01 c0                	add    %eax,%eax
  80019b:	01 d0                	add    %edx,%eax
  80019d:	c1 e0 03             	shl    $0x3,%eax
  8001a0:	01 c8                	add    %ecx,%eax
  8001a2:	8a 40 04             	mov    0x4(%eax),%al
  8001a5:	3c 01                	cmp    $0x1,%al
  8001a7:	75 03                	jne    8001ac <_main+0x174>
			numOfEmptyWSLocs++;
  8001a9:	ff 45 e0             	incl   -0x20(%ebp)

	//[0] Make sure there're available places in the WS
	int w = 0 ;
	int requiredNumOfEmptyWSLocs = 2;
	int numOfEmptyWSLocs = 0;
	for (w = 0 ; w < myEnv->page_WS_max_size ; w++)
  8001ac:	ff 45 e4             	incl   -0x1c(%ebp)
  8001af:	a1 20 50 80 00       	mov    0x805020,%eax
  8001b4:	8b 50 74             	mov    0x74(%eax),%edx
  8001b7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8001ba:	39 c2                	cmp    %eax,%edx
  8001bc:	77 cb                	ja     800189 <_main+0x151>
	{
		if( myEnv->__uptr_pws[w].empty == 1)
			numOfEmptyWSLocs++;
	}
	if (numOfEmptyWSLocs < requiredNumOfEmptyWSLocs)
  8001be:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8001c1:	3b 45 cc             	cmp    -0x34(%ebp),%eax
  8001c4:	7d 14                	jge    8001da <_main+0x1a2>
		panic("Insufficient number of WS empty locations! please increase the PAGE_WS_MAX_SIZE");
  8001c6:	83 ec 04             	sub    $0x4,%esp
  8001c9:	68 dc 3b 80 00       	push   $0x803bdc
  8001ce:	6a 43                	push   $0x43
  8001d0:	68 9c 3b 80 00       	push   $0x803b9c
  8001d5:	e8 4e 0b 00 00       	call   800d28 <_panic>


	void* ptr_allocations[512] = {0};
  8001da:	8d 95 c0 f7 ff ff    	lea    -0x840(%ebp),%edx
  8001e0:	b9 00 02 00 00       	mov    $0x200,%ecx
  8001e5:	b8 00 00 00 00       	mov    $0x0,%eax
  8001ea:	89 d7                	mov    %edx,%edi
  8001ec:	f3 ab                	rep stos %eax,%es:(%edi)
	int i;

	cprintf("This test has THREE cases. A pass message will be displayed after each one.\n");
  8001ee:	83 ec 0c             	sub    $0xc,%esp
  8001f1:	68 2c 3c 80 00       	push   $0x803c2c
  8001f6:	e8 e1 0d 00 00       	call   800fdc <cprintf>
  8001fb:	83 c4 10             	add    $0x10,%esp

	// allocate pages
	freeFrames = sys_calculate_free_frames() ;
  8001fe:	e8 77 21 00 00       	call   80237a <sys_calculate_free_frames>
  800203:	89 45 c8             	mov    %eax,-0x38(%ebp)
	usedDiskPages = sys_pf_calculate_allocated_pages();
  800206:	e8 0f 22 00 00       	call   80241a <sys_pf_calculate_allocated_pages>
  80020b:	89 45 c4             	mov    %eax,-0x3c(%ebp)
	for(i = 0; i< 256;i++)
  80020e:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
  800215:	eb 20                	jmp    800237 <_main+0x1ff>
	{
		ptr_allocations[i] = malloc(2*Mega);
  800217:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80021a:	01 c0                	add    %eax,%eax
  80021c:	83 ec 0c             	sub    $0xc,%esp
  80021f:	50                   	push   %eax
  800220:	e8 49 1d 00 00       	call   801f6e <malloc>
  800225:	83 c4 10             	add    $0x10,%esp
  800228:	89 c2                	mov    %eax,%edx
  80022a:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80022d:	89 94 85 c0 f7 ff ff 	mov    %edx,-0x840(%ebp,%eax,4)
	cprintf("This test has THREE cases. A pass message will be displayed after each one.\n");

	// allocate pages
	freeFrames = sys_calculate_free_frames() ;
	usedDiskPages = sys_pf_calculate_allocated_pages();
	for(i = 0; i< 256;i++)
  800234:	ff 45 dc             	incl   -0x24(%ebp)
  800237:	81 7d dc ff 00 00 00 	cmpl   $0xff,-0x24(%ebp)
  80023e:	7e d7                	jle    800217 <_main+0x1df>
	{
		ptr_allocations[i] = malloc(2*Mega);
	}

	// randomly check the addresses of the allocation
	if( 	(uint32)ptr_allocations[0] != 0x80000000 ||
  800240:	8b 85 c0 f7 ff ff    	mov    -0x840(%ebp),%eax
  800246:	3d 00 00 00 80       	cmp    $0x80000000,%eax
  80024b:	75 5b                	jne    8002a8 <_main+0x270>
			(uint32)ptr_allocations[2] != 0x80400000 ||
  80024d:	8b 85 c8 f7 ff ff    	mov    -0x838(%ebp),%eax
	{
		ptr_allocations[i] = malloc(2*Mega);
	}

	// randomly check the addresses of the allocation
	if( 	(uint32)ptr_allocations[0] != 0x80000000 ||
  800253:	3d 00 00 40 80       	cmp    $0x80400000,%eax
  800258:	75 4e                	jne    8002a8 <_main+0x270>
			(uint32)ptr_allocations[2] != 0x80400000 ||
			(uint32)ptr_allocations[8] != 0x81000000 ||
  80025a:	8b 85 e0 f7 ff ff    	mov    -0x820(%ebp),%eax
		ptr_allocations[i] = malloc(2*Mega);
	}

	// randomly check the addresses of the allocation
	if( 	(uint32)ptr_allocations[0] != 0x80000000 ||
			(uint32)ptr_allocations[2] != 0x80400000 ||
  800260:	3d 00 00 00 81       	cmp    $0x81000000,%eax
  800265:	75 41                	jne    8002a8 <_main+0x270>
			(uint32)ptr_allocations[8] != 0x81000000 ||
			(uint32)ptr_allocations[10] != 0x81400000 ||
  800267:	8b 85 e8 f7 ff ff    	mov    -0x818(%ebp),%eax
	}

	// randomly check the addresses of the allocation
	if( 	(uint32)ptr_allocations[0] != 0x80000000 ||
			(uint32)ptr_allocations[2] != 0x80400000 ||
			(uint32)ptr_allocations[8] != 0x81000000 ||
  80026d:	3d 00 00 40 81       	cmp    $0x81400000,%eax
  800272:	75 34                	jne    8002a8 <_main+0x270>
			(uint32)ptr_allocations[10] != 0x81400000 ||
			(uint32)ptr_allocations[15] != 0x81e00000 ||
  800274:	8b 85 fc f7 ff ff    	mov    -0x804(%ebp),%eax

	// randomly check the addresses of the allocation
	if( 	(uint32)ptr_allocations[0] != 0x80000000 ||
			(uint32)ptr_allocations[2] != 0x80400000 ||
			(uint32)ptr_allocations[8] != 0x81000000 ||
			(uint32)ptr_allocations[10] != 0x81400000 ||
  80027a:	3d 00 00 e0 81       	cmp    $0x81e00000,%eax
  80027f:	75 27                	jne    8002a8 <_main+0x270>
			(uint32)ptr_allocations[15] != 0x81e00000 ||
			(uint32)ptr_allocations[20] != 0x82800000 ||
  800281:	8b 85 10 f8 ff ff    	mov    -0x7f0(%ebp),%eax
	// randomly check the addresses of the allocation
	if( 	(uint32)ptr_allocations[0] != 0x80000000 ||
			(uint32)ptr_allocations[2] != 0x80400000 ||
			(uint32)ptr_allocations[8] != 0x81000000 ||
			(uint32)ptr_allocations[10] != 0x81400000 ||
			(uint32)ptr_allocations[15] != 0x81e00000 ||
  800287:	3d 00 00 80 82       	cmp    $0x82800000,%eax
  80028c:	75 1a                	jne    8002a8 <_main+0x270>
			(uint32)ptr_allocations[20] != 0x82800000 ||
			(uint32)ptr_allocations[25] != 0x83200000 ||
  80028e:	8b 85 24 f8 ff ff    	mov    -0x7dc(%ebp),%eax
	if( 	(uint32)ptr_allocations[0] != 0x80000000 ||
			(uint32)ptr_allocations[2] != 0x80400000 ||
			(uint32)ptr_allocations[8] != 0x81000000 ||
			(uint32)ptr_allocations[10] != 0x81400000 ||
			(uint32)ptr_allocations[15] != 0x81e00000 ||
			(uint32)ptr_allocations[20] != 0x82800000 ||
  800294:	3d 00 00 20 83       	cmp    $0x83200000,%eax
  800299:	75 0d                	jne    8002a8 <_main+0x270>
			(uint32)ptr_allocations[25] != 0x83200000 ||
			(uint32)ptr_allocations[255] != 0x9FE00000)
  80029b:	8b 85 bc fb ff ff    	mov    -0x444(%ebp),%eax
			(uint32)ptr_allocations[2] != 0x80400000 ||
			(uint32)ptr_allocations[8] != 0x81000000 ||
			(uint32)ptr_allocations[10] != 0x81400000 ||
			(uint32)ptr_allocations[15] != 0x81e00000 ||
			(uint32)ptr_allocations[20] != 0x82800000 ||
			(uint32)ptr_allocations[25] != 0x83200000 ||
  8002a1:	3d 00 00 e0 9f       	cmp    $0x9fe00000,%eax
  8002a6:	74 14                	je     8002bc <_main+0x284>
			(uint32)ptr_allocations[255] != 0x9FE00000)
		panic("Wrong allocation, Check fitting strategy is working correctly");
  8002a8:	83 ec 04             	sub    $0x4,%esp
  8002ab:	68 7c 3c 80 00       	push   $0x803c7c
  8002b0:	6a 5c                	push   $0x5c
  8002b2:	68 9c 3b 80 00       	push   $0x803b9c
  8002b7:	e8 6c 0a 00 00       	call   800d28 <_panic>

	if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  512*Mega/PAGE_SIZE) panic("Wrong page file allocation: ");
  8002bc:	e8 59 21 00 00       	call   80241a <sys_pf_calculate_allocated_pages>
  8002c1:	2b 45 c4             	sub    -0x3c(%ebp),%eax
  8002c4:	89 c2                	mov    %eax,%edx
  8002c6:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8002c9:	c1 e0 09             	shl    $0x9,%eax
  8002cc:	85 c0                	test   %eax,%eax
  8002ce:	79 05                	jns    8002d5 <_main+0x29d>
  8002d0:	05 ff 0f 00 00       	add    $0xfff,%eax
  8002d5:	c1 f8 0c             	sar    $0xc,%eax
  8002d8:	39 c2                	cmp    %eax,%edx
  8002da:	74 14                	je     8002f0 <_main+0x2b8>
  8002dc:	83 ec 04             	sub    $0x4,%esp
  8002df:	68 ba 3c 80 00       	push   $0x803cba
  8002e4:	6a 5e                	push   $0x5e
  8002e6:	68 9c 3b 80 00       	push   $0x803b9c
  8002eb:	e8 38 0a 00 00       	call   800d28 <_panic>
	if ((freeFrames - sys_calculate_free_frames()) != (512*Mega)/(1024*PAGE_SIZE) ) panic("Wrong allocation");
  8002f0:	8b 5d c8             	mov    -0x38(%ebp),%ebx
  8002f3:	e8 82 20 00 00       	call   80237a <sys_calculate_free_frames>
  8002f8:	29 c3                	sub    %eax,%ebx
  8002fa:	89 da                	mov    %ebx,%edx
  8002fc:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8002ff:	c1 e0 09             	shl    $0x9,%eax
  800302:	85 c0                	test   %eax,%eax
  800304:	79 05                	jns    80030b <_main+0x2d3>
  800306:	05 ff ff 3f 00       	add    $0x3fffff,%eax
  80030b:	c1 f8 16             	sar    $0x16,%eax
  80030e:	39 c2                	cmp    %eax,%edx
  800310:	74 14                	je     800326 <_main+0x2ee>
  800312:	83 ec 04             	sub    $0x4,%esp
  800315:	68 d7 3c 80 00       	push   $0x803cd7
  80031a:	6a 5f                	push   $0x5f
  80031c:	68 9c 3b 80 00       	push   $0x803b9c
  800321:	e8 02 0a 00 00       	call   800d28 <_panic>

	// Make memory holes.
	freeFrames = sys_calculate_free_frames() ;
  800326:	e8 4f 20 00 00       	call   80237a <sys_calculate_free_frames>
  80032b:	89 45 c8             	mov    %eax,-0x38(%ebp)
	usedDiskPages = sys_pf_calculate_allocated_pages();
  80032e:	e8 e7 20 00 00       	call   80241a <sys_pf_calculate_allocated_pages>
  800333:	89 45 c4             	mov    %eax,-0x3c(%ebp)

	free(ptr_allocations[0]);		// Hole 1 = 2 M
  800336:	8b 85 c0 f7 ff ff    	mov    -0x840(%ebp),%eax
  80033c:	83 ec 0c             	sub    $0xc,%esp
  80033f:	50                   	push   %eax
  800340:	e8 aa 1c 00 00       	call   801fef <free>
  800345:	83 c4 10             	add    $0x10,%esp
	free(ptr_allocations[2]);		// Hole 2 = 4 M
  800348:	8b 85 c8 f7 ff ff    	mov    -0x838(%ebp),%eax
  80034e:	83 ec 0c             	sub    $0xc,%esp
  800351:	50                   	push   %eax
  800352:	e8 98 1c 00 00       	call   801fef <free>
  800357:	83 c4 10             	add    $0x10,%esp
	free(ptr_allocations[3]);
  80035a:	8b 85 cc f7 ff ff    	mov    -0x834(%ebp),%eax
  800360:	83 ec 0c             	sub    $0xc,%esp
  800363:	50                   	push   %eax
  800364:	e8 86 1c 00 00       	call   801fef <free>
  800369:	83 c4 10             	add    $0x10,%esp
	free(ptr_allocations[5]);		// Hole 3 = 2 M
  80036c:	8b 85 d4 f7 ff ff    	mov    -0x82c(%ebp),%eax
  800372:	83 ec 0c             	sub    $0xc,%esp
  800375:	50                   	push   %eax
  800376:	e8 74 1c 00 00       	call   801fef <free>
  80037b:	83 c4 10             	add    $0x10,%esp
	free(ptr_allocations[10]);		// Hole 4 = 6 M
  80037e:	8b 85 e8 f7 ff ff    	mov    -0x818(%ebp),%eax
  800384:	83 ec 0c             	sub    $0xc,%esp
  800387:	50                   	push   %eax
  800388:	e8 62 1c 00 00       	call   801fef <free>
  80038d:	83 c4 10             	add    $0x10,%esp
	free(ptr_allocations[12]);
  800390:	8b 85 f0 f7 ff ff    	mov    -0x810(%ebp),%eax
  800396:	83 ec 0c             	sub    $0xc,%esp
  800399:	50                   	push   %eax
  80039a:	e8 50 1c 00 00       	call   801fef <free>
  80039f:	83 c4 10             	add    $0x10,%esp
	free(ptr_allocations[11]);
  8003a2:	8b 85 ec f7 ff ff    	mov    -0x814(%ebp),%eax
  8003a8:	83 ec 0c             	sub    $0xc,%esp
  8003ab:	50                   	push   %eax
  8003ac:	e8 3e 1c 00 00       	call   801fef <free>
  8003b1:	83 c4 10             	add    $0x10,%esp
	free(ptr_allocations[20]);		// Hole 5 = 2 M
  8003b4:	8b 85 10 f8 ff ff    	mov    -0x7f0(%ebp),%eax
  8003ba:	83 ec 0c             	sub    $0xc,%esp
  8003bd:	50                   	push   %eax
  8003be:	e8 2c 1c 00 00       	call   801fef <free>
  8003c3:	83 c4 10             	add    $0x10,%esp
	free(ptr_allocations[25]);		// Hole 6 = 2 M
  8003c6:	8b 85 24 f8 ff ff    	mov    -0x7dc(%ebp),%eax
  8003cc:	83 ec 0c             	sub    $0xc,%esp
  8003cf:	50                   	push   %eax
  8003d0:	e8 1a 1c 00 00       	call   801fef <free>
  8003d5:	83 c4 10             	add    $0x10,%esp
	free(ptr_allocations[255]);		// Hole 7 = 2 M
  8003d8:	8b 85 bc fb ff ff    	mov    -0x444(%ebp),%eax
  8003de:	83 ec 0c             	sub    $0xc,%esp
  8003e1:	50                   	push   %eax
  8003e2:	e8 08 1c 00 00       	call   801fef <free>
  8003e7:	83 c4 10             	add    $0x10,%esp

	if ((usedDiskPages - sys_pf_calculate_allocated_pages()) != 10*(2*Mega)/PAGE_SIZE) panic("Wrong free: Extra or less pages are removed from PageFile");
  8003ea:	e8 2b 20 00 00       	call   80241a <sys_pf_calculate_allocated_pages>
  8003ef:	8b 55 c4             	mov    -0x3c(%ebp),%edx
  8003f2:	89 d1                	mov    %edx,%ecx
  8003f4:	29 c1                	sub    %eax,%ecx
  8003f6:	8b 55 d8             	mov    -0x28(%ebp),%edx
  8003f9:	89 d0                	mov    %edx,%eax
  8003fb:	c1 e0 02             	shl    $0x2,%eax
  8003fe:	01 d0                	add    %edx,%eax
  800400:	c1 e0 02             	shl    $0x2,%eax
  800403:	85 c0                	test   %eax,%eax
  800405:	79 05                	jns    80040c <_main+0x3d4>
  800407:	05 ff 0f 00 00       	add    $0xfff,%eax
  80040c:	c1 f8 0c             	sar    $0xc,%eax
  80040f:	39 c1                	cmp    %eax,%ecx
  800411:	74 14                	je     800427 <_main+0x3ef>
  800413:	83 ec 04             	sub    $0x4,%esp
  800416:	68 e8 3c 80 00       	push   $0x803ce8
  80041b:	6a 70                	push   $0x70
  80041d:	68 9c 3b 80 00       	push   $0x803b9c
  800422:	e8 01 09 00 00       	call   800d28 <_panic>
	if ((sys_calculate_free_frames() - freeFrames) != 0) panic("Wrong free: Extra or less pages are removed from main memory");
  800427:	e8 4e 1f 00 00       	call   80237a <sys_calculate_free_frames>
  80042c:	89 c2                	mov    %eax,%edx
  80042e:	8b 45 c8             	mov    -0x38(%ebp),%eax
  800431:	39 c2                	cmp    %eax,%edx
  800433:	74 14                	je     800449 <_main+0x411>
  800435:	83 ec 04             	sub    $0x4,%esp
  800438:	68 24 3d 80 00       	push   $0x803d24
  80043d:	6a 71                	push   $0x71
  80043f:	68 9c 3b 80 00       	push   $0x803b9c
  800444:	e8 df 08 00 00       	call   800d28 <_panic>

	// Test next fit

	freeFrames = sys_calculate_free_frames() ;
  800449:	e8 2c 1f 00 00       	call   80237a <sys_calculate_free_frames>
  80044e:	89 45 c8             	mov    %eax,-0x38(%ebp)
	usedDiskPages = sys_pf_calculate_allocated_pages();
  800451:	e8 c4 1f 00 00       	call   80241a <sys_pf_calculate_allocated_pages>
  800456:	89 45 c4             	mov    %eax,-0x3c(%ebp)
	void* tempAddress = malloc(Mega-kilo);		// Use Hole 1 -> Hole 1 = 1 M
  800459:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80045c:	2b 45 d4             	sub    -0x2c(%ebp),%eax
  80045f:	83 ec 0c             	sub    $0xc,%esp
  800462:	50                   	push   %eax
  800463:	e8 06 1b 00 00       	call   801f6e <malloc>
  800468:	83 c4 10             	add    $0x10,%esp
  80046b:	89 45 c0             	mov    %eax,-0x40(%ebp)
	if((uint32)tempAddress != 0x80000000)
  80046e:	8b 45 c0             	mov    -0x40(%ebp),%eax
  800471:	3d 00 00 00 80       	cmp    $0x80000000,%eax
  800476:	74 14                	je     80048c <_main+0x454>
		panic("Next Fit not working correctly");
  800478:	83 ec 04             	sub    $0x4,%esp
  80047b:	68 64 3d 80 00       	push   $0x803d64
  800480:	6a 79                	push   $0x79
  800482:	68 9c 3b 80 00       	push   $0x803b9c
  800487:	e8 9c 08 00 00       	call   800d28 <_panic>
	if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  1*Mega/PAGE_SIZE) panic("Wrong page file allocation: ");
  80048c:	e8 89 1f 00 00       	call   80241a <sys_pf_calculate_allocated_pages>
  800491:	2b 45 c4             	sub    -0x3c(%ebp),%eax
  800494:	89 c2                	mov    %eax,%edx
  800496:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800499:	85 c0                	test   %eax,%eax
  80049b:	79 05                	jns    8004a2 <_main+0x46a>
  80049d:	05 ff 0f 00 00       	add    $0xfff,%eax
  8004a2:	c1 f8 0c             	sar    $0xc,%eax
  8004a5:	39 c2                	cmp    %eax,%edx
  8004a7:	74 14                	je     8004bd <_main+0x485>
  8004a9:	83 ec 04             	sub    $0x4,%esp
  8004ac:	68 ba 3c 80 00       	push   $0x803cba
  8004b1:	6a 7a                	push   $0x7a
  8004b3:	68 9c 3b 80 00       	push   $0x803b9c
  8004b8:	e8 6b 08 00 00       	call   800d28 <_panic>
	if ((freeFrames - sys_calculate_free_frames()) != 0) panic("Wrong allocation");
  8004bd:	e8 b8 1e 00 00       	call   80237a <sys_calculate_free_frames>
  8004c2:	89 c2                	mov    %eax,%edx
  8004c4:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8004c7:	39 c2                	cmp    %eax,%edx
  8004c9:	74 14                	je     8004df <_main+0x4a7>
  8004cb:	83 ec 04             	sub    $0x4,%esp
  8004ce:	68 d7 3c 80 00       	push   $0x803cd7
  8004d3:	6a 7b                	push   $0x7b
  8004d5:	68 9c 3b 80 00       	push   $0x803b9c
  8004da:	e8 49 08 00 00       	call   800d28 <_panic>

	freeFrames = sys_calculate_free_frames() ;
  8004df:	e8 96 1e 00 00       	call   80237a <sys_calculate_free_frames>
  8004e4:	89 45 c8             	mov    %eax,-0x38(%ebp)
	usedDiskPages = sys_pf_calculate_allocated_pages();
  8004e7:	e8 2e 1f 00 00       	call   80241a <sys_pf_calculate_allocated_pages>
  8004ec:	89 45 c4             	mov    %eax,-0x3c(%ebp)
	tempAddress = malloc(kilo);					// Use Hole 1 -> Hole 1 = 1 M - Kilo
  8004ef:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8004f2:	83 ec 0c             	sub    $0xc,%esp
  8004f5:	50                   	push   %eax
  8004f6:	e8 73 1a 00 00       	call   801f6e <malloc>
  8004fb:	83 c4 10             	add    $0x10,%esp
  8004fe:	89 45 c0             	mov    %eax,-0x40(%ebp)
	if((uint32)tempAddress != 0x80100000)
  800501:	8b 45 c0             	mov    -0x40(%ebp),%eax
  800504:	3d 00 00 10 80       	cmp    $0x80100000,%eax
  800509:	74 17                	je     800522 <_main+0x4ea>
		panic("Next Fit not working correctly");
  80050b:	83 ec 04             	sub    $0x4,%esp
  80050e:	68 64 3d 80 00       	push   $0x803d64
  800513:	68 81 00 00 00       	push   $0x81
  800518:	68 9c 3b 80 00       	push   $0x803b9c
  80051d:	e8 06 08 00 00       	call   800d28 <_panic>
	if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  4*kilo/PAGE_SIZE) panic("Wrong page file allocation: ");
  800522:	e8 f3 1e 00 00       	call   80241a <sys_pf_calculate_allocated_pages>
  800527:	2b 45 c4             	sub    -0x3c(%ebp),%eax
  80052a:	89 c2                	mov    %eax,%edx
  80052c:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80052f:	c1 e0 02             	shl    $0x2,%eax
  800532:	85 c0                	test   %eax,%eax
  800534:	79 05                	jns    80053b <_main+0x503>
  800536:	05 ff 0f 00 00       	add    $0xfff,%eax
  80053b:	c1 f8 0c             	sar    $0xc,%eax
  80053e:	39 c2                	cmp    %eax,%edx
  800540:	74 17                	je     800559 <_main+0x521>
  800542:	83 ec 04             	sub    $0x4,%esp
  800545:	68 ba 3c 80 00       	push   $0x803cba
  80054a:	68 82 00 00 00       	push   $0x82
  80054f:	68 9c 3b 80 00       	push   $0x803b9c
  800554:	e8 cf 07 00 00       	call   800d28 <_panic>
	if ((freeFrames - sys_calculate_free_frames()) != 0) panic("Wrong allocation");
  800559:	e8 1c 1e 00 00       	call   80237a <sys_calculate_free_frames>
  80055e:	89 c2                	mov    %eax,%edx
  800560:	8b 45 c8             	mov    -0x38(%ebp),%eax
  800563:	39 c2                	cmp    %eax,%edx
  800565:	74 17                	je     80057e <_main+0x546>
  800567:	83 ec 04             	sub    $0x4,%esp
  80056a:	68 d7 3c 80 00       	push   $0x803cd7
  80056f:	68 83 00 00 00       	push   $0x83
  800574:	68 9c 3b 80 00       	push   $0x803b9c
  800579:	e8 aa 07 00 00       	call   800d28 <_panic>

	freeFrames = sys_calculate_free_frames() ;
  80057e:	e8 f7 1d 00 00       	call   80237a <sys_calculate_free_frames>
  800583:	89 45 c8             	mov    %eax,-0x38(%ebp)
	usedDiskPages = sys_pf_calculate_allocated_pages();
  800586:	e8 8f 1e 00 00       	call   80241a <sys_pf_calculate_allocated_pages>
  80058b:	89 45 c4             	mov    %eax,-0x3c(%ebp)
	tempAddress = malloc(5*Mega); 			   // Use Hole 4 -> Hole 4 = 1 M
  80058e:	8b 55 d8             	mov    -0x28(%ebp),%edx
  800591:	89 d0                	mov    %edx,%eax
  800593:	c1 e0 02             	shl    $0x2,%eax
  800596:	01 d0                	add    %edx,%eax
  800598:	83 ec 0c             	sub    $0xc,%esp
  80059b:	50                   	push   %eax
  80059c:	e8 cd 19 00 00       	call   801f6e <malloc>
  8005a1:	83 c4 10             	add    $0x10,%esp
  8005a4:	89 45 c0             	mov    %eax,-0x40(%ebp)
	if((uint32)tempAddress != 0x81400000)
  8005a7:	8b 45 c0             	mov    -0x40(%ebp),%eax
  8005aa:	3d 00 00 40 81       	cmp    $0x81400000,%eax
  8005af:	74 17                	je     8005c8 <_main+0x590>
		panic("Next Fit not working correctly");
  8005b1:	83 ec 04             	sub    $0x4,%esp
  8005b4:	68 64 3d 80 00       	push   $0x803d64
  8005b9:	68 89 00 00 00       	push   $0x89
  8005be:	68 9c 3b 80 00       	push   $0x803b9c
  8005c3:	e8 60 07 00 00       	call   800d28 <_panic>
	if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  5*Mega/PAGE_SIZE) panic("Wrong page file allocation: ");
  8005c8:	e8 4d 1e 00 00       	call   80241a <sys_pf_calculate_allocated_pages>
  8005cd:	2b 45 c4             	sub    -0x3c(%ebp),%eax
  8005d0:	89 c1                	mov    %eax,%ecx
  8005d2:	8b 55 d8             	mov    -0x28(%ebp),%edx
  8005d5:	89 d0                	mov    %edx,%eax
  8005d7:	c1 e0 02             	shl    $0x2,%eax
  8005da:	01 d0                	add    %edx,%eax
  8005dc:	85 c0                	test   %eax,%eax
  8005de:	79 05                	jns    8005e5 <_main+0x5ad>
  8005e0:	05 ff 0f 00 00       	add    $0xfff,%eax
  8005e5:	c1 f8 0c             	sar    $0xc,%eax
  8005e8:	39 c1                	cmp    %eax,%ecx
  8005ea:	74 17                	je     800603 <_main+0x5cb>
  8005ec:	83 ec 04             	sub    $0x4,%esp
  8005ef:	68 ba 3c 80 00       	push   $0x803cba
  8005f4:	68 8a 00 00 00       	push   $0x8a
  8005f9:	68 9c 3b 80 00       	push   $0x803b9c
  8005fe:	e8 25 07 00 00       	call   800d28 <_panic>
	if ((freeFrames - sys_calculate_free_frames()) != 0) panic("Wrong allocation");
  800603:	e8 72 1d 00 00       	call   80237a <sys_calculate_free_frames>
  800608:	89 c2                	mov    %eax,%edx
  80060a:	8b 45 c8             	mov    -0x38(%ebp),%eax
  80060d:	39 c2                	cmp    %eax,%edx
  80060f:	74 17                	je     800628 <_main+0x5f0>
  800611:	83 ec 04             	sub    $0x4,%esp
  800614:	68 d7 3c 80 00       	push   $0x803cd7
  800619:	68 8b 00 00 00       	push   $0x8b
  80061e:	68 9c 3b 80 00       	push   $0x803b9c
  800623:	e8 00 07 00 00       	call   800d28 <_panic>

	freeFrames = sys_calculate_free_frames() ;
  800628:	e8 4d 1d 00 00       	call   80237a <sys_calculate_free_frames>
  80062d:	89 45 c8             	mov    %eax,-0x38(%ebp)
	usedDiskPages = sys_pf_calculate_allocated_pages();
  800630:	e8 e5 1d 00 00       	call   80241a <sys_pf_calculate_allocated_pages>
  800635:	89 45 c4             	mov    %eax,-0x3c(%ebp)
	tempAddress = malloc(1*Mega); 			   // Use Hole 4 -> Hole 4 = 0 M
  800638:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80063b:	83 ec 0c             	sub    $0xc,%esp
  80063e:	50                   	push   %eax
  80063f:	e8 2a 19 00 00       	call   801f6e <malloc>
  800644:	83 c4 10             	add    $0x10,%esp
  800647:	89 45 c0             	mov    %eax,-0x40(%ebp)
	if((uint32)tempAddress != 0x81900000)
  80064a:	8b 45 c0             	mov    -0x40(%ebp),%eax
  80064d:	3d 00 00 90 81       	cmp    $0x81900000,%eax
  800652:	74 17                	je     80066b <_main+0x633>
		panic("Next Fit not working correctly");
  800654:	83 ec 04             	sub    $0x4,%esp
  800657:	68 64 3d 80 00       	push   $0x803d64
  80065c:	68 91 00 00 00       	push   $0x91
  800661:	68 9c 3b 80 00       	push   $0x803b9c
  800666:	e8 bd 06 00 00       	call   800d28 <_panic>
	if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  1*Mega/PAGE_SIZE) panic("Wrong page file allocation: ");
  80066b:	e8 aa 1d 00 00       	call   80241a <sys_pf_calculate_allocated_pages>
  800670:	2b 45 c4             	sub    -0x3c(%ebp),%eax
  800673:	89 c2                	mov    %eax,%edx
  800675:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800678:	85 c0                	test   %eax,%eax
  80067a:	79 05                	jns    800681 <_main+0x649>
  80067c:	05 ff 0f 00 00       	add    $0xfff,%eax
  800681:	c1 f8 0c             	sar    $0xc,%eax
  800684:	39 c2                	cmp    %eax,%edx
  800686:	74 17                	je     80069f <_main+0x667>
  800688:	83 ec 04             	sub    $0x4,%esp
  80068b:	68 ba 3c 80 00       	push   $0x803cba
  800690:	68 92 00 00 00       	push   $0x92
  800695:	68 9c 3b 80 00       	push   $0x803b9c
  80069a:	e8 89 06 00 00       	call   800d28 <_panic>
	if ((freeFrames - sys_calculate_free_frames()) != 0) panic("Wrong allocation");
  80069f:	e8 d6 1c 00 00       	call   80237a <sys_calculate_free_frames>
  8006a4:	89 c2                	mov    %eax,%edx
  8006a6:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8006a9:	39 c2                	cmp    %eax,%edx
  8006ab:	74 17                	je     8006c4 <_main+0x68c>
  8006ad:	83 ec 04             	sub    $0x4,%esp
  8006b0:	68 d7 3c 80 00       	push   $0x803cd7
  8006b5:	68 93 00 00 00       	push   $0x93
  8006ba:	68 9c 3b 80 00       	push   $0x803b9c
  8006bf:	e8 64 06 00 00       	call   800d28 <_panic>


	freeFrames = sys_calculate_free_frames() ;
  8006c4:	e8 b1 1c 00 00       	call   80237a <sys_calculate_free_frames>
  8006c9:	89 45 c8             	mov    %eax,-0x38(%ebp)
	usedDiskPages = sys_pf_calculate_allocated_pages();
  8006cc:	e8 49 1d 00 00       	call   80241a <sys_pf_calculate_allocated_pages>
  8006d1:	89 45 c4             	mov    %eax,-0x3c(%ebp)
	free(ptr_allocations[15]);					// Make a new hole => 2 M
  8006d4:	8b 85 fc f7 ff ff    	mov    -0x804(%ebp),%eax
  8006da:	83 ec 0c             	sub    $0xc,%esp
  8006dd:	50                   	push   %eax
  8006de:	e8 0c 19 00 00       	call   801fef <free>
  8006e3:	83 c4 10             	add    $0x10,%esp
	if ((usedDiskPages - sys_pf_calculate_allocated_pages()) != 2*Mega/PAGE_SIZE) panic("Wrong free: Extra or less pages are removed from PageFile");
  8006e6:	e8 2f 1d 00 00       	call   80241a <sys_pf_calculate_allocated_pages>
  8006eb:	8b 55 c4             	mov    -0x3c(%ebp),%edx
  8006ee:	29 c2                	sub    %eax,%edx
  8006f0:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8006f3:	01 c0                	add    %eax,%eax
  8006f5:	85 c0                	test   %eax,%eax
  8006f7:	79 05                	jns    8006fe <_main+0x6c6>
  8006f9:	05 ff 0f 00 00       	add    $0xfff,%eax
  8006fe:	c1 f8 0c             	sar    $0xc,%eax
  800701:	39 c2                	cmp    %eax,%edx
  800703:	74 17                	je     80071c <_main+0x6e4>
  800705:	83 ec 04             	sub    $0x4,%esp
  800708:	68 e8 3c 80 00       	push   $0x803ce8
  80070d:	68 99 00 00 00       	push   $0x99
  800712:	68 9c 3b 80 00       	push   $0x803b9c
  800717:	e8 0c 06 00 00       	call   800d28 <_panic>
	if ((sys_calculate_free_frames() - freeFrames) != 0) panic("Wrong free: Extra or less pages are removed from main memory");
  80071c:	e8 59 1c 00 00       	call   80237a <sys_calculate_free_frames>
  800721:	89 c2                	mov    %eax,%edx
  800723:	8b 45 c8             	mov    -0x38(%ebp),%eax
  800726:	39 c2                	cmp    %eax,%edx
  800728:	74 17                	je     800741 <_main+0x709>
  80072a:	83 ec 04             	sub    $0x4,%esp
  80072d:	68 24 3d 80 00       	push   $0x803d24
  800732:	68 9a 00 00 00       	push   $0x9a
  800737:	68 9c 3b 80 00       	push   $0x803b9c
  80073c:	e8 e7 05 00 00       	call   800d28 <_panic>

	//[NEXT FIT Case]
	freeFrames = sys_calculate_free_frames() ;
  800741:	e8 34 1c 00 00       	call   80237a <sys_calculate_free_frames>
  800746:	89 45 c8             	mov    %eax,-0x38(%ebp)
	usedDiskPages = sys_pf_calculate_allocated_pages();
  800749:	e8 cc 1c 00 00       	call   80241a <sys_pf_calculate_allocated_pages>
  80074e:	89 45 c4             	mov    %eax,-0x3c(%ebp)
	tempAddress = malloc(kilo); 			   // Use new Hole = 2 M - 4 kilo
  800751:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  800754:	83 ec 0c             	sub    $0xc,%esp
  800757:	50                   	push   %eax
  800758:	e8 11 18 00 00       	call   801f6e <malloc>
  80075d:	83 c4 10             	add    $0x10,%esp
  800760:	89 45 c0             	mov    %eax,-0x40(%ebp)
	if((uint32)tempAddress != 0x81E00000)
  800763:	8b 45 c0             	mov    -0x40(%ebp),%eax
  800766:	3d 00 00 e0 81       	cmp    $0x81e00000,%eax
  80076b:	74 17                	je     800784 <_main+0x74c>
		panic("Next Fit not working correctly");
  80076d:	83 ec 04             	sub    $0x4,%esp
  800770:	68 64 3d 80 00       	push   $0x803d64
  800775:	68 a1 00 00 00       	push   $0xa1
  80077a:	68 9c 3b 80 00       	push   $0x803b9c
  80077f:	e8 a4 05 00 00       	call   800d28 <_panic>
	if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  4*kilo/PAGE_SIZE) panic("Wrong page file allocation: ");
  800784:	e8 91 1c 00 00       	call   80241a <sys_pf_calculate_allocated_pages>
  800789:	2b 45 c4             	sub    -0x3c(%ebp),%eax
  80078c:	89 c2                	mov    %eax,%edx
  80078e:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  800791:	c1 e0 02             	shl    $0x2,%eax
  800794:	85 c0                	test   %eax,%eax
  800796:	79 05                	jns    80079d <_main+0x765>
  800798:	05 ff 0f 00 00       	add    $0xfff,%eax
  80079d:	c1 f8 0c             	sar    $0xc,%eax
  8007a0:	39 c2                	cmp    %eax,%edx
  8007a2:	74 17                	je     8007bb <_main+0x783>
  8007a4:	83 ec 04             	sub    $0x4,%esp
  8007a7:	68 ba 3c 80 00       	push   $0x803cba
  8007ac:	68 a2 00 00 00       	push   $0xa2
  8007b1:	68 9c 3b 80 00       	push   $0x803b9c
  8007b6:	e8 6d 05 00 00       	call   800d28 <_panic>
	if ((freeFrames - sys_calculate_free_frames()) != 0) panic("Wrong allocation");
  8007bb:	e8 ba 1b 00 00       	call   80237a <sys_calculate_free_frames>
  8007c0:	89 c2                	mov    %eax,%edx
  8007c2:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8007c5:	39 c2                	cmp    %eax,%edx
  8007c7:	74 17                	je     8007e0 <_main+0x7a8>
  8007c9:	83 ec 04             	sub    $0x4,%esp
  8007cc:	68 d7 3c 80 00       	push   $0x803cd7
  8007d1:	68 a3 00 00 00       	push   $0xa3
  8007d6:	68 9c 3b 80 00       	push   $0x803b9c
  8007db:	e8 48 05 00 00       	call   800d28 <_panic>

	freeFrames = sys_calculate_free_frames() ;
  8007e0:	e8 95 1b 00 00       	call   80237a <sys_calculate_free_frames>
  8007e5:	89 45 c8             	mov    %eax,-0x38(%ebp)
	usedDiskPages = sys_pf_calculate_allocated_pages();
  8007e8:	e8 2d 1c 00 00       	call   80241a <sys_pf_calculate_allocated_pages>
  8007ed:	89 45 c4             	mov    %eax,-0x3c(%ebp)
	tempAddress = malloc(Mega + 1016*kilo); 	// Use new Hole = 4 kilo
  8007f0:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8007f3:	c1 e0 03             	shl    $0x3,%eax
  8007f6:	89 c2                	mov    %eax,%edx
  8007f8:	c1 e2 07             	shl    $0x7,%edx
  8007fb:	29 c2                	sub    %eax,%edx
  8007fd:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800800:	01 d0                	add    %edx,%eax
  800802:	83 ec 0c             	sub    $0xc,%esp
  800805:	50                   	push   %eax
  800806:	e8 63 17 00 00       	call   801f6e <malloc>
  80080b:	83 c4 10             	add    $0x10,%esp
  80080e:	89 45 c0             	mov    %eax,-0x40(%ebp)
	if((uint32)tempAddress != 0x81E01000)
  800811:	8b 45 c0             	mov    -0x40(%ebp),%eax
  800814:	3d 00 10 e0 81       	cmp    $0x81e01000,%eax
  800819:	74 17                	je     800832 <_main+0x7fa>
		panic("Next Fit not working correctly");
  80081b:	83 ec 04             	sub    $0x4,%esp
  80081e:	68 64 3d 80 00       	push   $0x803d64
  800823:	68 a9 00 00 00       	push   $0xa9
  800828:	68 9c 3b 80 00       	push   $0x803b9c
  80082d:	e8 f6 04 00 00       	call   800d28 <_panic>
	if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  (1*Mega+1016*kilo)/PAGE_SIZE) panic("Wrong page file allocation: ");
  800832:	e8 e3 1b 00 00       	call   80241a <sys_pf_calculate_allocated_pages>
  800837:	2b 45 c4             	sub    -0x3c(%ebp),%eax
  80083a:	89 c2                	mov    %eax,%edx
  80083c:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80083f:	c1 e0 03             	shl    $0x3,%eax
  800842:	89 c1                	mov    %eax,%ecx
  800844:	c1 e1 07             	shl    $0x7,%ecx
  800847:	29 c1                	sub    %eax,%ecx
  800849:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80084c:	01 c8                	add    %ecx,%eax
  80084e:	85 c0                	test   %eax,%eax
  800850:	79 05                	jns    800857 <_main+0x81f>
  800852:	05 ff 0f 00 00       	add    $0xfff,%eax
  800857:	c1 f8 0c             	sar    $0xc,%eax
  80085a:	39 c2                	cmp    %eax,%edx
  80085c:	74 17                	je     800875 <_main+0x83d>
  80085e:	83 ec 04             	sub    $0x4,%esp
  800861:	68 ba 3c 80 00       	push   $0x803cba
  800866:	68 aa 00 00 00       	push   $0xaa
  80086b:	68 9c 3b 80 00       	push   $0x803b9c
  800870:	e8 b3 04 00 00       	call   800d28 <_panic>
	if ((freeFrames - sys_calculate_free_frames()) != 0) panic("Wrong allocation");
  800875:	e8 00 1b 00 00       	call   80237a <sys_calculate_free_frames>
  80087a:	89 c2                	mov    %eax,%edx
  80087c:	8b 45 c8             	mov    -0x38(%ebp),%eax
  80087f:	39 c2                	cmp    %eax,%edx
  800881:	74 17                	je     80089a <_main+0x862>
  800883:	83 ec 04             	sub    $0x4,%esp
  800886:	68 d7 3c 80 00       	push   $0x803cd7
  80088b:	68 ab 00 00 00       	push   $0xab
  800890:	68 9c 3b 80 00       	push   $0x803b9c
  800895:	e8 8e 04 00 00       	call   800d28 <_panic>

	freeFrames = sys_calculate_free_frames() ;
  80089a:	e8 db 1a 00 00       	call   80237a <sys_calculate_free_frames>
  80089f:	89 45 c8             	mov    %eax,-0x38(%ebp)
	usedDiskPages = sys_pf_calculate_allocated_pages();
  8008a2:	e8 73 1b 00 00       	call   80241a <sys_pf_calculate_allocated_pages>
  8008a7:	89 45 c4             	mov    %eax,-0x3c(%ebp)
	tempAddress = malloc(512*kilo); 			   // Use Hole 5 -> Hole 5 = 1.5 M
  8008aa:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8008ad:	c1 e0 09             	shl    $0x9,%eax
  8008b0:	83 ec 0c             	sub    $0xc,%esp
  8008b3:	50                   	push   %eax
  8008b4:	e8 b5 16 00 00       	call   801f6e <malloc>
  8008b9:	83 c4 10             	add    $0x10,%esp
  8008bc:	89 45 c0             	mov    %eax,-0x40(%ebp)
	if((uint32)tempAddress != 0x82800000)
  8008bf:	8b 45 c0             	mov    -0x40(%ebp),%eax
  8008c2:	3d 00 00 80 82       	cmp    $0x82800000,%eax
  8008c7:	74 17                	je     8008e0 <_main+0x8a8>
		panic("Next Fit not working correctly");
  8008c9:	83 ec 04             	sub    $0x4,%esp
  8008cc:	68 64 3d 80 00       	push   $0x803d64
  8008d1:	68 b1 00 00 00       	push   $0xb1
  8008d6:	68 9c 3b 80 00       	push   $0x803b9c
  8008db:	e8 48 04 00 00       	call   800d28 <_panic>
	if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  512*kilo/PAGE_SIZE) panic("Wrong page file allocation: ");
  8008e0:	e8 35 1b 00 00       	call   80241a <sys_pf_calculate_allocated_pages>
  8008e5:	2b 45 c4             	sub    -0x3c(%ebp),%eax
  8008e8:	89 c2                	mov    %eax,%edx
  8008ea:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8008ed:	c1 e0 09             	shl    $0x9,%eax
  8008f0:	85 c0                	test   %eax,%eax
  8008f2:	79 05                	jns    8008f9 <_main+0x8c1>
  8008f4:	05 ff 0f 00 00       	add    $0xfff,%eax
  8008f9:	c1 f8 0c             	sar    $0xc,%eax
  8008fc:	39 c2                	cmp    %eax,%edx
  8008fe:	74 17                	je     800917 <_main+0x8df>
  800900:	83 ec 04             	sub    $0x4,%esp
  800903:	68 ba 3c 80 00       	push   $0x803cba
  800908:	68 b2 00 00 00       	push   $0xb2
  80090d:	68 9c 3b 80 00       	push   $0x803b9c
  800912:	e8 11 04 00 00       	call   800d28 <_panic>
	if ((freeFrames - sys_calculate_free_frames()) != 0) panic("Wrong allocation");
  800917:	e8 5e 1a 00 00       	call   80237a <sys_calculate_free_frames>
  80091c:	89 c2                	mov    %eax,%edx
  80091e:	8b 45 c8             	mov    -0x38(%ebp),%eax
  800921:	39 c2                	cmp    %eax,%edx
  800923:	74 17                	je     80093c <_main+0x904>
  800925:	83 ec 04             	sub    $0x4,%esp
  800928:	68 d7 3c 80 00       	push   $0x803cd7
  80092d:	68 b3 00 00 00       	push   $0xb3
  800932:	68 9c 3b 80 00       	push   $0x803b9c
  800937:	e8 ec 03 00 00       	call   800d28 <_panic>

	cprintf("\nCASE1: (next fit without looping back) is succeeded...\n") ;
  80093c:	83 ec 0c             	sub    $0xc,%esp
  80093f:	68 84 3d 80 00       	push   $0x803d84
  800944:	e8 93 06 00 00       	call   800fdc <cprintf>
  800949:	83 c4 10             	add    $0x10,%esp

	// Check that next fit is looping back to check for free space
	freeFrames = sys_calculate_free_frames() ;
  80094c:	e8 29 1a 00 00       	call   80237a <sys_calculate_free_frames>
  800951:	89 45 c8             	mov    %eax,-0x38(%ebp)
	usedDiskPages = sys_pf_calculate_allocated_pages();
  800954:	e8 c1 1a 00 00       	call   80241a <sys_pf_calculate_allocated_pages>
  800959:	89 45 c4             	mov    %eax,-0x3c(%ebp)
	tempAddress = malloc(3*Mega + 512*kilo); 			   // Use Hole 2 -> Hole 2 = 0.5 M
  80095c:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80095f:	89 c2                	mov    %eax,%edx
  800961:	01 d2                	add    %edx,%edx
  800963:	01 c2                	add    %eax,%edx
  800965:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  800968:	c1 e0 09             	shl    $0x9,%eax
  80096b:	01 d0                	add    %edx,%eax
  80096d:	83 ec 0c             	sub    $0xc,%esp
  800970:	50                   	push   %eax
  800971:	e8 f8 15 00 00       	call   801f6e <malloc>
  800976:	83 c4 10             	add    $0x10,%esp
  800979:	89 45 c0             	mov    %eax,-0x40(%ebp)
	if((uint32)tempAddress != 0x80400000)
  80097c:	8b 45 c0             	mov    -0x40(%ebp),%eax
  80097f:	3d 00 00 40 80       	cmp    $0x80400000,%eax
  800984:	74 17                	je     80099d <_main+0x965>
		panic("Next Fit not working correctly");
  800986:	83 ec 04             	sub    $0x4,%esp
  800989:	68 64 3d 80 00       	push   $0x803d64
  80098e:	68 bc 00 00 00       	push   $0xbc
  800993:	68 9c 3b 80 00       	push   $0x803b9c
  800998:	e8 8b 03 00 00       	call   800d28 <_panic>
	if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  (3*Mega+512*kilo)/PAGE_SIZE) panic("Wrong page file allocation: ");
  80099d:	e8 78 1a 00 00       	call   80241a <sys_pf_calculate_allocated_pages>
  8009a2:	2b 45 c4             	sub    -0x3c(%ebp),%eax
  8009a5:	89 c2                	mov    %eax,%edx
  8009a7:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8009aa:	89 c1                	mov    %eax,%ecx
  8009ac:	01 c9                	add    %ecx,%ecx
  8009ae:	01 c1                	add    %eax,%ecx
  8009b0:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8009b3:	c1 e0 09             	shl    $0x9,%eax
  8009b6:	01 c8                	add    %ecx,%eax
  8009b8:	85 c0                	test   %eax,%eax
  8009ba:	79 05                	jns    8009c1 <_main+0x989>
  8009bc:	05 ff 0f 00 00       	add    $0xfff,%eax
  8009c1:	c1 f8 0c             	sar    $0xc,%eax
  8009c4:	39 c2                	cmp    %eax,%edx
  8009c6:	74 17                	je     8009df <_main+0x9a7>
  8009c8:	83 ec 04             	sub    $0x4,%esp
  8009cb:	68 ba 3c 80 00       	push   $0x803cba
  8009d0:	68 bd 00 00 00       	push   $0xbd
  8009d5:	68 9c 3b 80 00       	push   $0x803b9c
  8009da:	e8 49 03 00 00       	call   800d28 <_panic>
	if ((freeFrames - sys_calculate_free_frames()) != 0) panic("Wrong allocation");
  8009df:	e8 96 19 00 00       	call   80237a <sys_calculate_free_frames>
  8009e4:	89 c2                	mov    %eax,%edx
  8009e6:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8009e9:	39 c2                	cmp    %eax,%edx
  8009eb:	74 17                	je     800a04 <_main+0x9cc>
  8009ed:	83 ec 04             	sub    $0x4,%esp
  8009f0:	68 d7 3c 80 00       	push   $0x803cd7
  8009f5:	68 be 00 00 00       	push   $0xbe
  8009fa:	68 9c 3b 80 00       	push   $0x803b9c
  8009ff:	e8 24 03 00 00       	call   800d28 <_panic>


	freeFrames = sys_calculate_free_frames() ;
  800a04:	e8 71 19 00 00       	call   80237a <sys_calculate_free_frames>
  800a09:	89 45 c8             	mov    %eax,-0x38(%ebp)
	usedDiskPages = sys_pf_calculate_allocated_pages();
  800a0c:	e8 09 1a 00 00       	call   80241a <sys_pf_calculate_allocated_pages>
  800a11:	89 45 c4             	mov    %eax,-0x3c(%ebp)
	free(ptr_allocations[24]);		// Increase size of Hole 6 to 4 M
  800a14:	8b 85 20 f8 ff ff    	mov    -0x7e0(%ebp),%eax
  800a1a:	83 ec 0c             	sub    $0xc,%esp
  800a1d:	50                   	push   %eax
  800a1e:	e8 cc 15 00 00       	call   801fef <free>
  800a23:	83 c4 10             	add    $0x10,%esp
	if ((usedDiskPages - sys_pf_calculate_allocated_pages()) != 2*Mega/PAGE_SIZE) panic("Wrong free: Extra or less pages are removed from PageFile");
  800a26:	e8 ef 19 00 00       	call   80241a <sys_pf_calculate_allocated_pages>
  800a2b:	8b 55 c4             	mov    -0x3c(%ebp),%edx
  800a2e:	29 c2                	sub    %eax,%edx
  800a30:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800a33:	01 c0                	add    %eax,%eax
  800a35:	85 c0                	test   %eax,%eax
  800a37:	79 05                	jns    800a3e <_main+0xa06>
  800a39:	05 ff 0f 00 00       	add    $0xfff,%eax
  800a3e:	c1 f8 0c             	sar    $0xc,%eax
  800a41:	39 c2                	cmp    %eax,%edx
  800a43:	74 17                	je     800a5c <_main+0xa24>
  800a45:	83 ec 04             	sub    $0x4,%esp
  800a48:	68 e8 3c 80 00       	push   $0x803ce8
  800a4d:	68 c4 00 00 00       	push   $0xc4
  800a52:	68 9c 3b 80 00       	push   $0x803b9c
  800a57:	e8 cc 02 00 00       	call   800d28 <_panic>
	if ((sys_calculate_free_frames() - freeFrames) != 0) panic("Wrong free: Extra or less pages are removed from main memory");
  800a5c:	e8 19 19 00 00       	call   80237a <sys_calculate_free_frames>
  800a61:	89 c2                	mov    %eax,%edx
  800a63:	8b 45 c8             	mov    -0x38(%ebp),%eax
  800a66:	39 c2                	cmp    %eax,%edx
  800a68:	74 17                	je     800a81 <_main+0xa49>
  800a6a:	83 ec 04             	sub    $0x4,%esp
  800a6d:	68 24 3d 80 00       	push   $0x803d24
  800a72:	68 c5 00 00 00       	push   $0xc5
  800a77:	68 9c 3b 80 00       	push   $0x803b9c
  800a7c:	e8 a7 02 00 00       	call   800d28 <_panic>


	freeFrames = sys_calculate_free_frames() ;
  800a81:	e8 f4 18 00 00       	call   80237a <sys_calculate_free_frames>
  800a86:	89 45 c8             	mov    %eax,-0x38(%ebp)
	usedDiskPages = sys_pf_calculate_allocated_pages();
  800a89:	e8 8c 19 00 00       	call   80241a <sys_pf_calculate_allocated_pages>
  800a8e:	89 45 c4             	mov    %eax,-0x3c(%ebp)
	tempAddress = malloc(4*Mega-kilo);		// Use Hole 6 -> Hole 6 = 0 M
  800a91:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800a94:	c1 e0 02             	shl    $0x2,%eax
  800a97:	2b 45 d4             	sub    -0x2c(%ebp),%eax
  800a9a:	83 ec 0c             	sub    $0xc,%esp
  800a9d:	50                   	push   %eax
  800a9e:	e8 cb 14 00 00       	call   801f6e <malloc>
  800aa3:	83 c4 10             	add    $0x10,%esp
  800aa6:	89 45 c0             	mov    %eax,-0x40(%ebp)
	if((uint32)tempAddress != 0x83000000)
  800aa9:	8b 45 c0             	mov    -0x40(%ebp),%eax
  800aac:	3d 00 00 00 83       	cmp    $0x83000000,%eax
  800ab1:	74 17                	je     800aca <_main+0xa92>
		panic("Next Fit not working correctly");
  800ab3:	83 ec 04             	sub    $0x4,%esp
  800ab6:	68 64 3d 80 00       	push   $0x803d64
  800abb:	68 cc 00 00 00       	push   $0xcc
  800ac0:	68 9c 3b 80 00       	push   $0x803b9c
  800ac5:	e8 5e 02 00 00       	call   800d28 <_panic>
	if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  4*Mega/PAGE_SIZE) panic("Wrong page file allocation: ");
  800aca:	e8 4b 19 00 00       	call   80241a <sys_pf_calculate_allocated_pages>
  800acf:	2b 45 c4             	sub    -0x3c(%ebp),%eax
  800ad2:	89 c2                	mov    %eax,%edx
  800ad4:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800ad7:	c1 e0 02             	shl    $0x2,%eax
  800ada:	85 c0                	test   %eax,%eax
  800adc:	79 05                	jns    800ae3 <_main+0xaab>
  800ade:	05 ff 0f 00 00       	add    $0xfff,%eax
  800ae3:	c1 f8 0c             	sar    $0xc,%eax
  800ae6:	39 c2                	cmp    %eax,%edx
  800ae8:	74 17                	je     800b01 <_main+0xac9>
  800aea:	83 ec 04             	sub    $0x4,%esp
  800aed:	68 ba 3c 80 00       	push   $0x803cba
  800af2:	68 cd 00 00 00       	push   $0xcd
  800af7:	68 9c 3b 80 00       	push   $0x803b9c
  800afc:	e8 27 02 00 00       	call   800d28 <_panic>
	if ((freeFrames - sys_calculate_free_frames()) != 0) panic("Wrong allocation");
  800b01:	e8 74 18 00 00       	call   80237a <sys_calculate_free_frames>
  800b06:	89 c2                	mov    %eax,%edx
  800b08:	8b 45 c8             	mov    -0x38(%ebp),%eax
  800b0b:	39 c2                	cmp    %eax,%edx
  800b0d:	74 17                	je     800b26 <_main+0xaee>
  800b0f:	83 ec 04             	sub    $0x4,%esp
  800b12:	68 d7 3c 80 00       	push   $0x803cd7
  800b17:	68 ce 00 00 00       	push   $0xce
  800b1c:	68 9c 3b 80 00       	push   $0x803b9c
  800b21:	e8 02 02 00 00       	call   800d28 <_panic>

	cprintf("\nCASE2: (next fit WITH looping back) is succeeded...\n") ;
  800b26:	83 ec 0c             	sub    $0xc,%esp
  800b29:	68 c0 3d 80 00       	push   $0x803dc0
  800b2e:	e8 a9 04 00 00       	call   800fdc <cprintf>
  800b33:	83 c4 10             	add    $0x10,%esp

	// Check that next fit returns null in case all holes are not free
	freeFrames = sys_calculate_free_frames() ;
  800b36:	e8 3f 18 00 00       	call   80237a <sys_calculate_free_frames>
  800b3b:	89 45 c8             	mov    %eax,-0x38(%ebp)
	usedDiskPages = sys_pf_calculate_allocated_pages();
  800b3e:	e8 d7 18 00 00       	call   80241a <sys_pf_calculate_allocated_pages>
  800b43:	89 45 c4             	mov    %eax,-0x3c(%ebp)
	tempAddress = malloc(6*Mega); 			   // No Suitable Hole is available
  800b46:	8b 55 d8             	mov    -0x28(%ebp),%edx
  800b49:	89 d0                	mov    %edx,%eax
  800b4b:	01 c0                	add    %eax,%eax
  800b4d:	01 d0                	add    %edx,%eax
  800b4f:	01 c0                	add    %eax,%eax
  800b51:	83 ec 0c             	sub    $0xc,%esp
  800b54:	50                   	push   %eax
  800b55:	e8 14 14 00 00       	call   801f6e <malloc>
  800b5a:	83 c4 10             	add    $0x10,%esp
  800b5d:	89 45 c0             	mov    %eax,-0x40(%ebp)
	if((uint32)tempAddress != 0x0)
  800b60:	8b 45 c0             	mov    -0x40(%ebp),%eax
  800b63:	85 c0                	test   %eax,%eax
  800b65:	74 17                	je     800b7e <_main+0xb46>
		panic("Next Fit not working correctly");
  800b67:	83 ec 04             	sub    $0x4,%esp
  800b6a:	68 64 3d 80 00       	push   $0x803d64
  800b6f:	68 d7 00 00 00       	push   $0xd7
  800b74:	68 9c 3b 80 00       	push   $0x803b9c
  800b79:	e8 aa 01 00 00       	call   800d28 <_panic>
	if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  0) panic("Wrong page file allocation: ");
  800b7e:	e8 97 18 00 00       	call   80241a <sys_pf_calculate_allocated_pages>
  800b83:	3b 45 c4             	cmp    -0x3c(%ebp),%eax
  800b86:	74 17                	je     800b9f <_main+0xb67>
  800b88:	83 ec 04             	sub    $0x4,%esp
  800b8b:	68 ba 3c 80 00       	push   $0x803cba
  800b90:	68 d8 00 00 00       	push   $0xd8
  800b95:	68 9c 3b 80 00       	push   $0x803b9c
  800b9a:	e8 89 01 00 00       	call   800d28 <_panic>
	if ((freeFrames - sys_calculate_free_frames()) != 0) panic("Wrong allocation");
  800b9f:	e8 d6 17 00 00       	call   80237a <sys_calculate_free_frames>
  800ba4:	89 c2                	mov    %eax,%edx
  800ba6:	8b 45 c8             	mov    -0x38(%ebp),%eax
  800ba9:	39 c2                	cmp    %eax,%edx
  800bab:	74 17                	je     800bc4 <_main+0xb8c>
  800bad:	83 ec 04             	sub    $0x4,%esp
  800bb0:	68 d7 3c 80 00       	push   $0x803cd7
  800bb5:	68 d9 00 00 00       	push   $0xd9
  800bba:	68 9c 3b 80 00       	push   $0x803b9c
  800bbf:	e8 64 01 00 00       	call   800d28 <_panic>

	cprintf("\nCASE3: (next fit with insufficient space) is succeeded...\n") ;
  800bc4:	83 ec 0c             	sub    $0xc,%esp
  800bc7:	68 f8 3d 80 00       	push   $0x803df8
  800bcc:	e8 0b 04 00 00       	call   800fdc <cprintf>
  800bd1:	83 c4 10             	add    $0x10,%esp

	cprintf("Congratulations!! test Next Fit completed successfully.\n");
  800bd4:	83 ec 0c             	sub    $0xc,%esp
  800bd7:	68 34 3e 80 00       	push   $0x803e34
  800bdc:	e8 fb 03 00 00       	call   800fdc <cprintf>
  800be1:	83 c4 10             	add    $0x10,%esp

	return;
  800be4:	90                   	nop
}
  800be5:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800be8:	5b                   	pop    %ebx
  800be9:	5f                   	pop    %edi
  800bea:	5d                   	pop    %ebp
  800beb:	c3                   	ret    

00800bec <libmain>:
volatile struct Env *myEnv = NULL;
volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";

void
libmain(int argc, char **argv)
{
  800bec:	55                   	push   %ebp
  800bed:	89 e5                	mov    %esp,%ebp
  800bef:	83 ec 18             	sub    $0x18,%esp
	int envIndex = sys_getenvindex();
  800bf2:	e8 63 1a 00 00       	call   80265a <sys_getenvindex>
  800bf7:	89 45 f4             	mov    %eax,-0xc(%ebp)
	myEnv = &(envs[envIndex]);
  800bfa:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800bfd:	89 d0                	mov    %edx,%eax
  800bff:	c1 e0 03             	shl    $0x3,%eax
  800c02:	01 d0                	add    %edx,%eax
  800c04:	01 c0                	add    %eax,%eax
  800c06:	01 d0                	add    %edx,%eax
  800c08:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800c0f:	01 d0                	add    %edx,%eax
  800c11:	c1 e0 04             	shl    $0x4,%eax
  800c14:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  800c19:	a3 20 50 80 00       	mov    %eax,0x805020

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  800c1e:	a1 20 50 80 00       	mov    0x805020,%eax
  800c23:	8a 80 5c 05 00 00    	mov    0x55c(%eax),%al
  800c29:	84 c0                	test   %al,%al
  800c2b:	74 0f                	je     800c3c <libmain+0x50>
		binaryname = myEnv->prog_name;
  800c2d:	a1 20 50 80 00       	mov    0x805020,%eax
  800c32:	05 5c 05 00 00       	add    $0x55c,%eax
  800c37:	a3 00 50 80 00       	mov    %eax,0x805000

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800c3c:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800c40:	7e 0a                	jle    800c4c <libmain+0x60>
		binaryname = argv[0];
  800c42:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c45:	8b 00                	mov    (%eax),%eax
  800c47:	a3 00 50 80 00       	mov    %eax,0x805000

	// call user main routine
	_main(argc, argv);
  800c4c:	83 ec 08             	sub    $0x8,%esp
  800c4f:	ff 75 0c             	pushl  0xc(%ebp)
  800c52:	ff 75 08             	pushl  0x8(%ebp)
  800c55:	e8 de f3 ff ff       	call   800038 <_main>
  800c5a:	83 c4 10             	add    $0x10,%esp



	sys_disable_interrupt();
  800c5d:	e8 05 18 00 00       	call   802467 <sys_disable_interrupt>
	cprintf("**************************************\n");
  800c62:	83 ec 0c             	sub    $0xc,%esp
  800c65:	68 88 3e 80 00       	push   $0x803e88
  800c6a:	e8 6d 03 00 00       	call   800fdc <cprintf>
  800c6f:	83 c4 10             	add    $0x10,%esp
	cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  800c72:	a1 20 50 80 00       	mov    0x805020,%eax
  800c77:	8b 90 44 05 00 00    	mov    0x544(%eax),%edx
  800c7d:	a1 20 50 80 00       	mov    0x805020,%eax
  800c82:	8b 80 34 05 00 00    	mov    0x534(%eax),%eax
  800c88:	83 ec 04             	sub    $0x4,%esp
  800c8b:	52                   	push   %edx
  800c8c:	50                   	push   %eax
  800c8d:	68 b0 3e 80 00       	push   $0x803eb0
  800c92:	e8 45 03 00 00       	call   800fdc <cprintf>
  800c97:	83 c4 10             	add    $0x10,%esp
	cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  800c9a:	a1 20 50 80 00       	mov    0x805020,%eax
  800c9f:	8b 88 54 05 00 00    	mov    0x554(%eax),%ecx
  800ca5:	a1 20 50 80 00       	mov    0x805020,%eax
  800caa:	8b 90 50 05 00 00    	mov    0x550(%eax),%edx
  800cb0:	a1 20 50 80 00       	mov    0x805020,%eax
  800cb5:	8b 80 4c 05 00 00    	mov    0x54c(%eax),%eax
  800cbb:	51                   	push   %ecx
  800cbc:	52                   	push   %edx
  800cbd:	50                   	push   %eax
  800cbe:	68 d8 3e 80 00       	push   $0x803ed8
  800cc3:	e8 14 03 00 00       	call   800fdc <cprintf>
  800cc8:	83 c4 10             	add    $0x10,%esp
	//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
	cprintf("Num of clocks = %d\n", myEnv->nClocks);
  800ccb:	a1 20 50 80 00       	mov    0x805020,%eax
  800cd0:	8b 80 a4 05 00 00    	mov    0x5a4(%eax),%eax
  800cd6:	83 ec 08             	sub    $0x8,%esp
  800cd9:	50                   	push   %eax
  800cda:	68 30 3f 80 00       	push   $0x803f30
  800cdf:	e8 f8 02 00 00       	call   800fdc <cprintf>
  800ce4:	83 c4 10             	add    $0x10,%esp
	cprintf("**************************************\n");
  800ce7:	83 ec 0c             	sub    $0xc,%esp
  800cea:	68 88 3e 80 00       	push   $0x803e88
  800cef:	e8 e8 02 00 00       	call   800fdc <cprintf>
  800cf4:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  800cf7:	e8 85 17 00 00       	call   802481 <sys_enable_interrupt>

	// exit gracefully
	exit();
  800cfc:	e8 19 00 00 00       	call   800d1a <exit>
}
  800d01:	90                   	nop
  800d02:	c9                   	leave  
  800d03:	c3                   	ret    

00800d04 <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  800d04:	55                   	push   %ebp
  800d05:	89 e5                	mov    %esp,%ebp
  800d07:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  800d0a:	83 ec 0c             	sub    $0xc,%esp
  800d0d:	6a 00                	push   $0x0
  800d0f:	e8 12 19 00 00       	call   802626 <sys_destroy_env>
  800d14:	83 c4 10             	add    $0x10,%esp
}
  800d17:	90                   	nop
  800d18:	c9                   	leave  
  800d19:	c3                   	ret    

00800d1a <exit>:

void
exit(void)
{
  800d1a:	55                   	push   %ebp
  800d1b:	89 e5                	mov    %esp,%ebp
  800d1d:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  800d20:	e8 67 19 00 00       	call   80268c <sys_exit_env>
}
  800d25:	90                   	nop
  800d26:	c9                   	leave  
  800d27:	c3                   	ret    

00800d28 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  800d28:	55                   	push   %ebp
  800d29:	89 e5                	mov    %esp,%ebp
  800d2b:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  800d2e:	8d 45 10             	lea    0x10(%ebp),%eax
  800d31:	83 c0 04             	add    $0x4,%eax
  800d34:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  800d37:	a1 5c 51 80 00       	mov    0x80515c,%eax
  800d3c:	85 c0                	test   %eax,%eax
  800d3e:	74 16                	je     800d56 <_panic+0x2e>
		cprintf("%s: ", argv0);
  800d40:	a1 5c 51 80 00       	mov    0x80515c,%eax
  800d45:	83 ec 08             	sub    $0x8,%esp
  800d48:	50                   	push   %eax
  800d49:	68 44 3f 80 00       	push   $0x803f44
  800d4e:	e8 89 02 00 00       	call   800fdc <cprintf>
  800d53:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  800d56:	a1 00 50 80 00       	mov    0x805000,%eax
  800d5b:	ff 75 0c             	pushl  0xc(%ebp)
  800d5e:	ff 75 08             	pushl  0x8(%ebp)
  800d61:	50                   	push   %eax
  800d62:	68 49 3f 80 00       	push   $0x803f49
  800d67:	e8 70 02 00 00       	call   800fdc <cprintf>
  800d6c:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  800d6f:	8b 45 10             	mov    0x10(%ebp),%eax
  800d72:	83 ec 08             	sub    $0x8,%esp
  800d75:	ff 75 f4             	pushl  -0xc(%ebp)
  800d78:	50                   	push   %eax
  800d79:	e8 f3 01 00 00       	call   800f71 <vcprintf>
  800d7e:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  800d81:	83 ec 08             	sub    $0x8,%esp
  800d84:	6a 00                	push   $0x0
  800d86:	68 65 3f 80 00       	push   $0x803f65
  800d8b:	e8 e1 01 00 00       	call   800f71 <vcprintf>
  800d90:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  800d93:	e8 82 ff ff ff       	call   800d1a <exit>

	// should not return here
	while (1) ;
  800d98:	eb fe                	jmp    800d98 <_panic+0x70>

00800d9a <CheckWSWithoutLastIndex>:
}

void CheckWSWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  800d9a:	55                   	push   %ebp
  800d9b:	89 e5                	mov    %esp,%ebp
  800d9d:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  800da0:	a1 20 50 80 00       	mov    0x805020,%eax
  800da5:	8b 50 74             	mov    0x74(%eax),%edx
  800da8:	8b 45 0c             	mov    0xc(%ebp),%eax
  800dab:	39 c2                	cmp    %eax,%edx
  800dad:	74 14                	je     800dc3 <CheckWSWithoutLastIndex+0x29>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  800daf:	83 ec 04             	sub    $0x4,%esp
  800db2:	68 68 3f 80 00       	push   $0x803f68
  800db7:	6a 26                	push   $0x26
  800db9:	68 b4 3f 80 00       	push   $0x803fb4
  800dbe:	e8 65 ff ff ff       	call   800d28 <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  800dc3:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  800dca:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800dd1:	e9 c2 00 00 00       	jmp    800e98 <CheckWSWithoutLastIndex+0xfe>
		if (expectedPages[e] == 0) {
  800dd6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800dd9:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800de0:	8b 45 08             	mov    0x8(%ebp),%eax
  800de3:	01 d0                	add    %edx,%eax
  800de5:	8b 00                	mov    (%eax),%eax
  800de7:	85 c0                	test   %eax,%eax
  800de9:	75 08                	jne    800df3 <CheckWSWithoutLastIndex+0x59>
			expectedNumOfEmptyLocs++;
  800deb:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  800dee:	e9 a2 00 00 00       	jmp    800e95 <CheckWSWithoutLastIndex+0xfb>
		}
		int found = 0;
  800df3:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800dfa:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  800e01:	eb 69                	jmp    800e6c <CheckWSWithoutLastIndex+0xd2>
			if (myEnv->__uptr_pws[w].empty == 0) {
  800e03:	a1 20 50 80 00       	mov    0x805020,%eax
  800e08:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  800e0e:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800e11:	89 d0                	mov    %edx,%eax
  800e13:	01 c0                	add    %eax,%eax
  800e15:	01 d0                	add    %edx,%eax
  800e17:	c1 e0 03             	shl    $0x3,%eax
  800e1a:	01 c8                	add    %ecx,%eax
  800e1c:	8a 40 04             	mov    0x4(%eax),%al
  800e1f:	84 c0                	test   %al,%al
  800e21:	75 46                	jne    800e69 <CheckWSWithoutLastIndex+0xcf>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  800e23:	a1 20 50 80 00       	mov    0x805020,%eax
  800e28:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  800e2e:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800e31:	89 d0                	mov    %edx,%eax
  800e33:	01 c0                	add    %eax,%eax
  800e35:	01 d0                	add    %edx,%eax
  800e37:	c1 e0 03             	shl    $0x3,%eax
  800e3a:	01 c8                	add    %ecx,%eax
  800e3c:	8b 00                	mov    (%eax),%eax
  800e3e:	89 45 dc             	mov    %eax,-0x24(%ebp)
  800e41:	8b 45 dc             	mov    -0x24(%ebp),%eax
  800e44:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800e49:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  800e4b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800e4e:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  800e55:	8b 45 08             	mov    0x8(%ebp),%eax
  800e58:	01 c8                	add    %ecx,%eax
  800e5a:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  800e5c:	39 c2                	cmp    %eax,%edx
  800e5e:	75 09                	jne    800e69 <CheckWSWithoutLastIndex+0xcf>
						== expectedPages[e]) {
					found = 1;
  800e60:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  800e67:	eb 12                	jmp    800e7b <CheckWSWithoutLastIndex+0xe1>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800e69:	ff 45 e8             	incl   -0x18(%ebp)
  800e6c:	a1 20 50 80 00       	mov    0x805020,%eax
  800e71:	8b 50 74             	mov    0x74(%eax),%edx
  800e74:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800e77:	39 c2                	cmp    %eax,%edx
  800e79:	77 88                	ja     800e03 <CheckWSWithoutLastIndex+0x69>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  800e7b:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  800e7f:	75 14                	jne    800e95 <CheckWSWithoutLastIndex+0xfb>
			panic(
  800e81:	83 ec 04             	sub    $0x4,%esp
  800e84:	68 c0 3f 80 00       	push   $0x803fc0
  800e89:	6a 3a                	push   $0x3a
  800e8b:	68 b4 3f 80 00       	push   $0x803fb4
  800e90:	e8 93 fe ff ff       	call   800d28 <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  800e95:	ff 45 f0             	incl   -0x10(%ebp)
  800e98:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800e9b:	3b 45 0c             	cmp    0xc(%ebp),%eax
  800e9e:	0f 8c 32 ff ff ff    	jl     800dd6 <CheckWSWithoutLastIndex+0x3c>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  800ea4:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800eab:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  800eb2:	eb 26                	jmp    800eda <CheckWSWithoutLastIndex+0x140>
		if (myEnv->__uptr_pws[w].empty == 1) {
  800eb4:	a1 20 50 80 00       	mov    0x805020,%eax
  800eb9:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  800ebf:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800ec2:	89 d0                	mov    %edx,%eax
  800ec4:	01 c0                	add    %eax,%eax
  800ec6:	01 d0                	add    %edx,%eax
  800ec8:	c1 e0 03             	shl    $0x3,%eax
  800ecb:	01 c8                	add    %ecx,%eax
  800ecd:	8a 40 04             	mov    0x4(%eax),%al
  800ed0:	3c 01                	cmp    $0x1,%al
  800ed2:	75 03                	jne    800ed7 <CheckWSWithoutLastIndex+0x13d>
			actualNumOfEmptyLocs++;
  800ed4:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800ed7:	ff 45 e0             	incl   -0x20(%ebp)
  800eda:	a1 20 50 80 00       	mov    0x805020,%eax
  800edf:	8b 50 74             	mov    0x74(%eax),%edx
  800ee2:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800ee5:	39 c2                	cmp    %eax,%edx
  800ee7:	77 cb                	ja     800eb4 <CheckWSWithoutLastIndex+0x11a>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  800ee9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800eec:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  800eef:	74 14                	je     800f05 <CheckWSWithoutLastIndex+0x16b>
		panic(
  800ef1:	83 ec 04             	sub    $0x4,%esp
  800ef4:	68 14 40 80 00       	push   $0x804014
  800ef9:	6a 44                	push   $0x44
  800efb:	68 b4 3f 80 00       	push   $0x803fb4
  800f00:	e8 23 fe ff ff       	call   800d28 <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  800f05:	90                   	nop
  800f06:	c9                   	leave  
  800f07:	c3                   	ret    

00800f08 <putch>:
};

//2017:
uint8 printProgName = 0;

static void putch(int ch, struct printbuf *b) {
  800f08:	55                   	push   %ebp
  800f09:	89 e5                	mov    %esp,%ebp
  800f0b:	83 ec 08             	sub    $0x8,%esp
	b->buf[b->idx++] = ch;
  800f0e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f11:	8b 00                	mov    (%eax),%eax
  800f13:	8d 48 01             	lea    0x1(%eax),%ecx
  800f16:	8b 55 0c             	mov    0xc(%ebp),%edx
  800f19:	89 0a                	mov    %ecx,(%edx)
  800f1b:	8b 55 08             	mov    0x8(%ebp),%edx
  800f1e:	88 d1                	mov    %dl,%cl
  800f20:	8b 55 0c             	mov    0xc(%ebp),%edx
  800f23:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  800f27:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f2a:	8b 00                	mov    (%eax),%eax
  800f2c:	3d ff 00 00 00       	cmp    $0xff,%eax
  800f31:	75 2c                	jne    800f5f <putch+0x57>
		sys_cputs(b->buf, b->idx, printProgName);
  800f33:	a0 24 50 80 00       	mov    0x805024,%al
  800f38:	0f b6 c0             	movzbl %al,%eax
  800f3b:	8b 55 0c             	mov    0xc(%ebp),%edx
  800f3e:	8b 12                	mov    (%edx),%edx
  800f40:	89 d1                	mov    %edx,%ecx
  800f42:	8b 55 0c             	mov    0xc(%ebp),%edx
  800f45:	83 c2 08             	add    $0x8,%edx
  800f48:	83 ec 04             	sub    $0x4,%esp
  800f4b:	50                   	push   %eax
  800f4c:	51                   	push   %ecx
  800f4d:	52                   	push   %edx
  800f4e:	e8 66 13 00 00       	call   8022b9 <sys_cputs>
  800f53:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  800f56:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f59:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  800f5f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f62:	8b 40 04             	mov    0x4(%eax),%eax
  800f65:	8d 50 01             	lea    0x1(%eax),%edx
  800f68:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f6b:	89 50 04             	mov    %edx,0x4(%eax)
}
  800f6e:	90                   	nop
  800f6f:	c9                   	leave  
  800f70:	c3                   	ret    

00800f71 <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  800f71:	55                   	push   %ebp
  800f72:	89 e5                	mov    %esp,%ebp
  800f74:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  800f7a:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800f81:	00 00 00 
	b.cnt = 0;
  800f84:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800f8b:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  800f8e:	ff 75 0c             	pushl  0xc(%ebp)
  800f91:	ff 75 08             	pushl  0x8(%ebp)
  800f94:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800f9a:	50                   	push   %eax
  800f9b:	68 08 0f 80 00       	push   $0x800f08
  800fa0:	e8 11 02 00 00       	call   8011b6 <vprintfmt>
  800fa5:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName);
  800fa8:	a0 24 50 80 00       	mov    0x805024,%al
  800fad:	0f b6 c0             	movzbl %al,%eax
  800fb0:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  800fb6:	83 ec 04             	sub    $0x4,%esp
  800fb9:	50                   	push   %eax
  800fba:	52                   	push   %edx
  800fbb:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800fc1:	83 c0 08             	add    $0x8,%eax
  800fc4:	50                   	push   %eax
  800fc5:	e8 ef 12 00 00       	call   8022b9 <sys_cputs>
  800fca:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  800fcd:	c6 05 24 50 80 00 00 	movb   $0x0,0x805024
	return b.cnt;
  800fd4:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  800fda:	c9                   	leave  
  800fdb:	c3                   	ret    

00800fdc <cprintf>:

int cprintf(const char *fmt, ...) {
  800fdc:	55                   	push   %ebp
  800fdd:	89 e5                	mov    %esp,%ebp
  800fdf:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  800fe2:	c6 05 24 50 80 00 01 	movb   $0x1,0x805024
	va_start(ap, fmt);
  800fe9:	8d 45 0c             	lea    0xc(%ebp),%eax
  800fec:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800fef:	8b 45 08             	mov    0x8(%ebp),%eax
  800ff2:	83 ec 08             	sub    $0x8,%esp
  800ff5:	ff 75 f4             	pushl  -0xc(%ebp)
  800ff8:	50                   	push   %eax
  800ff9:	e8 73 ff ff ff       	call   800f71 <vcprintf>
  800ffe:	83 c4 10             	add    $0x10,%esp
  801001:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  801004:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801007:	c9                   	leave  
  801008:	c3                   	ret    

00801009 <atomic_cprintf>:

int atomic_cprintf(const char *fmt, ...) {
  801009:	55                   	push   %ebp
  80100a:	89 e5                	mov    %esp,%ebp
  80100c:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  80100f:	e8 53 14 00 00       	call   802467 <sys_disable_interrupt>
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  801014:	8d 45 0c             	lea    0xc(%ebp),%eax
  801017:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  80101a:	8b 45 08             	mov    0x8(%ebp),%eax
  80101d:	83 ec 08             	sub    $0x8,%esp
  801020:	ff 75 f4             	pushl  -0xc(%ebp)
  801023:	50                   	push   %eax
  801024:	e8 48 ff ff ff       	call   800f71 <vcprintf>
  801029:	83 c4 10             	add    $0x10,%esp
  80102c:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	sys_enable_interrupt();
  80102f:	e8 4d 14 00 00       	call   802481 <sys_enable_interrupt>
	return cnt;
  801034:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801037:	c9                   	leave  
  801038:	c3                   	ret    

00801039 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  801039:	55                   	push   %ebp
  80103a:	89 e5                	mov    %esp,%ebp
  80103c:	53                   	push   %ebx
  80103d:	83 ec 14             	sub    $0x14,%esp
  801040:	8b 45 10             	mov    0x10(%ebp),%eax
  801043:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801046:	8b 45 14             	mov    0x14(%ebp),%eax
  801049:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  80104c:	8b 45 18             	mov    0x18(%ebp),%eax
  80104f:	ba 00 00 00 00       	mov    $0x0,%edx
  801054:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  801057:	77 55                	ja     8010ae <printnum+0x75>
  801059:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  80105c:	72 05                	jb     801063 <printnum+0x2a>
  80105e:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801061:	77 4b                	ja     8010ae <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  801063:	8b 45 1c             	mov    0x1c(%ebp),%eax
  801066:	8d 58 ff             	lea    -0x1(%eax),%ebx
  801069:	8b 45 18             	mov    0x18(%ebp),%eax
  80106c:	ba 00 00 00 00       	mov    $0x0,%edx
  801071:	52                   	push   %edx
  801072:	50                   	push   %eax
  801073:	ff 75 f4             	pushl  -0xc(%ebp)
  801076:	ff 75 f0             	pushl  -0x10(%ebp)
  801079:	e8 86 28 00 00       	call   803904 <__udivdi3>
  80107e:	83 c4 10             	add    $0x10,%esp
  801081:	83 ec 04             	sub    $0x4,%esp
  801084:	ff 75 20             	pushl  0x20(%ebp)
  801087:	53                   	push   %ebx
  801088:	ff 75 18             	pushl  0x18(%ebp)
  80108b:	52                   	push   %edx
  80108c:	50                   	push   %eax
  80108d:	ff 75 0c             	pushl  0xc(%ebp)
  801090:	ff 75 08             	pushl  0x8(%ebp)
  801093:	e8 a1 ff ff ff       	call   801039 <printnum>
  801098:	83 c4 20             	add    $0x20,%esp
  80109b:	eb 1a                	jmp    8010b7 <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  80109d:	83 ec 08             	sub    $0x8,%esp
  8010a0:	ff 75 0c             	pushl  0xc(%ebp)
  8010a3:	ff 75 20             	pushl  0x20(%ebp)
  8010a6:	8b 45 08             	mov    0x8(%ebp),%eax
  8010a9:	ff d0                	call   *%eax
  8010ab:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  8010ae:	ff 4d 1c             	decl   0x1c(%ebp)
  8010b1:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  8010b5:	7f e6                	jg     80109d <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  8010b7:	8b 4d 18             	mov    0x18(%ebp),%ecx
  8010ba:	bb 00 00 00 00       	mov    $0x0,%ebx
  8010bf:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8010c2:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8010c5:	53                   	push   %ebx
  8010c6:	51                   	push   %ecx
  8010c7:	52                   	push   %edx
  8010c8:	50                   	push   %eax
  8010c9:	e8 46 29 00 00       	call   803a14 <__umoddi3>
  8010ce:	83 c4 10             	add    $0x10,%esp
  8010d1:	05 74 42 80 00       	add    $0x804274,%eax
  8010d6:	8a 00                	mov    (%eax),%al
  8010d8:	0f be c0             	movsbl %al,%eax
  8010db:	83 ec 08             	sub    $0x8,%esp
  8010de:	ff 75 0c             	pushl  0xc(%ebp)
  8010e1:	50                   	push   %eax
  8010e2:	8b 45 08             	mov    0x8(%ebp),%eax
  8010e5:	ff d0                	call   *%eax
  8010e7:	83 c4 10             	add    $0x10,%esp
}
  8010ea:	90                   	nop
  8010eb:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8010ee:	c9                   	leave  
  8010ef:	c3                   	ret    

008010f0 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  8010f0:	55                   	push   %ebp
  8010f1:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  8010f3:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  8010f7:	7e 1c                	jle    801115 <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  8010f9:	8b 45 08             	mov    0x8(%ebp),%eax
  8010fc:	8b 00                	mov    (%eax),%eax
  8010fe:	8d 50 08             	lea    0x8(%eax),%edx
  801101:	8b 45 08             	mov    0x8(%ebp),%eax
  801104:	89 10                	mov    %edx,(%eax)
  801106:	8b 45 08             	mov    0x8(%ebp),%eax
  801109:	8b 00                	mov    (%eax),%eax
  80110b:	83 e8 08             	sub    $0x8,%eax
  80110e:	8b 50 04             	mov    0x4(%eax),%edx
  801111:	8b 00                	mov    (%eax),%eax
  801113:	eb 40                	jmp    801155 <getuint+0x65>
	else if (lflag)
  801115:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801119:	74 1e                	je     801139 <getuint+0x49>
		return va_arg(*ap, unsigned long);
  80111b:	8b 45 08             	mov    0x8(%ebp),%eax
  80111e:	8b 00                	mov    (%eax),%eax
  801120:	8d 50 04             	lea    0x4(%eax),%edx
  801123:	8b 45 08             	mov    0x8(%ebp),%eax
  801126:	89 10                	mov    %edx,(%eax)
  801128:	8b 45 08             	mov    0x8(%ebp),%eax
  80112b:	8b 00                	mov    (%eax),%eax
  80112d:	83 e8 04             	sub    $0x4,%eax
  801130:	8b 00                	mov    (%eax),%eax
  801132:	ba 00 00 00 00       	mov    $0x0,%edx
  801137:	eb 1c                	jmp    801155 <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  801139:	8b 45 08             	mov    0x8(%ebp),%eax
  80113c:	8b 00                	mov    (%eax),%eax
  80113e:	8d 50 04             	lea    0x4(%eax),%edx
  801141:	8b 45 08             	mov    0x8(%ebp),%eax
  801144:	89 10                	mov    %edx,(%eax)
  801146:	8b 45 08             	mov    0x8(%ebp),%eax
  801149:	8b 00                	mov    (%eax),%eax
  80114b:	83 e8 04             	sub    $0x4,%eax
  80114e:	8b 00                	mov    (%eax),%eax
  801150:	ba 00 00 00 00       	mov    $0x0,%edx
}
  801155:	5d                   	pop    %ebp
  801156:	c3                   	ret    

00801157 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  801157:	55                   	push   %ebp
  801158:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  80115a:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  80115e:	7e 1c                	jle    80117c <getint+0x25>
		return va_arg(*ap, long long);
  801160:	8b 45 08             	mov    0x8(%ebp),%eax
  801163:	8b 00                	mov    (%eax),%eax
  801165:	8d 50 08             	lea    0x8(%eax),%edx
  801168:	8b 45 08             	mov    0x8(%ebp),%eax
  80116b:	89 10                	mov    %edx,(%eax)
  80116d:	8b 45 08             	mov    0x8(%ebp),%eax
  801170:	8b 00                	mov    (%eax),%eax
  801172:	83 e8 08             	sub    $0x8,%eax
  801175:	8b 50 04             	mov    0x4(%eax),%edx
  801178:	8b 00                	mov    (%eax),%eax
  80117a:	eb 38                	jmp    8011b4 <getint+0x5d>
	else if (lflag)
  80117c:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801180:	74 1a                	je     80119c <getint+0x45>
		return va_arg(*ap, long);
  801182:	8b 45 08             	mov    0x8(%ebp),%eax
  801185:	8b 00                	mov    (%eax),%eax
  801187:	8d 50 04             	lea    0x4(%eax),%edx
  80118a:	8b 45 08             	mov    0x8(%ebp),%eax
  80118d:	89 10                	mov    %edx,(%eax)
  80118f:	8b 45 08             	mov    0x8(%ebp),%eax
  801192:	8b 00                	mov    (%eax),%eax
  801194:	83 e8 04             	sub    $0x4,%eax
  801197:	8b 00                	mov    (%eax),%eax
  801199:	99                   	cltd   
  80119a:	eb 18                	jmp    8011b4 <getint+0x5d>
	else
		return va_arg(*ap, int);
  80119c:	8b 45 08             	mov    0x8(%ebp),%eax
  80119f:	8b 00                	mov    (%eax),%eax
  8011a1:	8d 50 04             	lea    0x4(%eax),%edx
  8011a4:	8b 45 08             	mov    0x8(%ebp),%eax
  8011a7:	89 10                	mov    %edx,(%eax)
  8011a9:	8b 45 08             	mov    0x8(%ebp),%eax
  8011ac:	8b 00                	mov    (%eax),%eax
  8011ae:	83 e8 04             	sub    $0x4,%eax
  8011b1:	8b 00                	mov    (%eax),%eax
  8011b3:	99                   	cltd   
}
  8011b4:	5d                   	pop    %ebp
  8011b5:	c3                   	ret    

008011b6 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  8011b6:	55                   	push   %ebp
  8011b7:	89 e5                	mov    %esp,%ebp
  8011b9:	56                   	push   %esi
  8011ba:	53                   	push   %ebx
  8011bb:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8011be:	eb 17                	jmp    8011d7 <vprintfmt+0x21>
			if (ch == '\0')
  8011c0:	85 db                	test   %ebx,%ebx
  8011c2:	0f 84 af 03 00 00    	je     801577 <vprintfmt+0x3c1>
				return;
			putch(ch, putdat);
  8011c8:	83 ec 08             	sub    $0x8,%esp
  8011cb:	ff 75 0c             	pushl  0xc(%ebp)
  8011ce:	53                   	push   %ebx
  8011cf:	8b 45 08             	mov    0x8(%ebp),%eax
  8011d2:	ff d0                	call   *%eax
  8011d4:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8011d7:	8b 45 10             	mov    0x10(%ebp),%eax
  8011da:	8d 50 01             	lea    0x1(%eax),%edx
  8011dd:	89 55 10             	mov    %edx,0x10(%ebp)
  8011e0:	8a 00                	mov    (%eax),%al
  8011e2:	0f b6 d8             	movzbl %al,%ebx
  8011e5:	83 fb 25             	cmp    $0x25,%ebx
  8011e8:	75 d6                	jne    8011c0 <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  8011ea:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  8011ee:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  8011f5:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  8011fc:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  801203:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  80120a:	8b 45 10             	mov    0x10(%ebp),%eax
  80120d:	8d 50 01             	lea    0x1(%eax),%edx
  801210:	89 55 10             	mov    %edx,0x10(%ebp)
  801213:	8a 00                	mov    (%eax),%al
  801215:	0f b6 d8             	movzbl %al,%ebx
  801218:	8d 43 dd             	lea    -0x23(%ebx),%eax
  80121b:	83 f8 55             	cmp    $0x55,%eax
  80121e:	0f 87 2b 03 00 00    	ja     80154f <vprintfmt+0x399>
  801224:	8b 04 85 98 42 80 00 	mov    0x804298(,%eax,4),%eax
  80122b:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  80122d:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  801231:	eb d7                	jmp    80120a <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  801233:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  801237:	eb d1                	jmp    80120a <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  801239:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  801240:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801243:	89 d0                	mov    %edx,%eax
  801245:	c1 e0 02             	shl    $0x2,%eax
  801248:	01 d0                	add    %edx,%eax
  80124a:	01 c0                	add    %eax,%eax
  80124c:	01 d8                	add    %ebx,%eax
  80124e:	83 e8 30             	sub    $0x30,%eax
  801251:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  801254:	8b 45 10             	mov    0x10(%ebp),%eax
  801257:	8a 00                	mov    (%eax),%al
  801259:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  80125c:	83 fb 2f             	cmp    $0x2f,%ebx
  80125f:	7e 3e                	jle    80129f <vprintfmt+0xe9>
  801261:	83 fb 39             	cmp    $0x39,%ebx
  801264:	7f 39                	jg     80129f <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  801266:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  801269:	eb d5                	jmp    801240 <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  80126b:	8b 45 14             	mov    0x14(%ebp),%eax
  80126e:	83 c0 04             	add    $0x4,%eax
  801271:	89 45 14             	mov    %eax,0x14(%ebp)
  801274:	8b 45 14             	mov    0x14(%ebp),%eax
  801277:	83 e8 04             	sub    $0x4,%eax
  80127a:	8b 00                	mov    (%eax),%eax
  80127c:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  80127f:	eb 1f                	jmp    8012a0 <vprintfmt+0xea>

		case '.':
			if (width < 0)
  801281:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  801285:	79 83                	jns    80120a <vprintfmt+0x54>
				width = 0;
  801287:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  80128e:	e9 77 ff ff ff       	jmp    80120a <vprintfmt+0x54>

		case '#':
			altflag = 1;
  801293:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  80129a:	e9 6b ff ff ff       	jmp    80120a <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  80129f:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  8012a0:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8012a4:	0f 89 60 ff ff ff    	jns    80120a <vprintfmt+0x54>
				width = precision, precision = -1;
  8012aa:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8012ad:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8012b0:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  8012b7:	e9 4e ff ff ff       	jmp    80120a <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  8012bc:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  8012bf:	e9 46 ff ff ff       	jmp    80120a <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  8012c4:	8b 45 14             	mov    0x14(%ebp),%eax
  8012c7:	83 c0 04             	add    $0x4,%eax
  8012ca:	89 45 14             	mov    %eax,0x14(%ebp)
  8012cd:	8b 45 14             	mov    0x14(%ebp),%eax
  8012d0:	83 e8 04             	sub    $0x4,%eax
  8012d3:	8b 00                	mov    (%eax),%eax
  8012d5:	83 ec 08             	sub    $0x8,%esp
  8012d8:	ff 75 0c             	pushl  0xc(%ebp)
  8012db:	50                   	push   %eax
  8012dc:	8b 45 08             	mov    0x8(%ebp),%eax
  8012df:	ff d0                	call   *%eax
  8012e1:	83 c4 10             	add    $0x10,%esp
			break;
  8012e4:	e9 89 02 00 00       	jmp    801572 <vprintfmt+0x3bc>

		// error message
		case 'e':
			err = va_arg(ap, int);
  8012e9:	8b 45 14             	mov    0x14(%ebp),%eax
  8012ec:	83 c0 04             	add    $0x4,%eax
  8012ef:	89 45 14             	mov    %eax,0x14(%ebp)
  8012f2:	8b 45 14             	mov    0x14(%ebp),%eax
  8012f5:	83 e8 04             	sub    $0x4,%eax
  8012f8:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  8012fa:	85 db                	test   %ebx,%ebx
  8012fc:	79 02                	jns    801300 <vprintfmt+0x14a>
				err = -err;
  8012fe:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  801300:	83 fb 64             	cmp    $0x64,%ebx
  801303:	7f 0b                	jg     801310 <vprintfmt+0x15a>
  801305:	8b 34 9d e0 40 80 00 	mov    0x8040e0(,%ebx,4),%esi
  80130c:	85 f6                	test   %esi,%esi
  80130e:	75 19                	jne    801329 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  801310:	53                   	push   %ebx
  801311:	68 85 42 80 00       	push   $0x804285
  801316:	ff 75 0c             	pushl  0xc(%ebp)
  801319:	ff 75 08             	pushl  0x8(%ebp)
  80131c:	e8 5e 02 00 00       	call   80157f <printfmt>
  801321:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  801324:	e9 49 02 00 00       	jmp    801572 <vprintfmt+0x3bc>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  801329:	56                   	push   %esi
  80132a:	68 8e 42 80 00       	push   $0x80428e
  80132f:	ff 75 0c             	pushl  0xc(%ebp)
  801332:	ff 75 08             	pushl  0x8(%ebp)
  801335:	e8 45 02 00 00       	call   80157f <printfmt>
  80133a:	83 c4 10             	add    $0x10,%esp
			break;
  80133d:	e9 30 02 00 00       	jmp    801572 <vprintfmt+0x3bc>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  801342:	8b 45 14             	mov    0x14(%ebp),%eax
  801345:	83 c0 04             	add    $0x4,%eax
  801348:	89 45 14             	mov    %eax,0x14(%ebp)
  80134b:	8b 45 14             	mov    0x14(%ebp),%eax
  80134e:	83 e8 04             	sub    $0x4,%eax
  801351:	8b 30                	mov    (%eax),%esi
  801353:	85 f6                	test   %esi,%esi
  801355:	75 05                	jne    80135c <vprintfmt+0x1a6>
				p = "(null)";
  801357:	be 91 42 80 00       	mov    $0x804291,%esi
			if (width > 0 && padc != '-')
  80135c:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  801360:	7e 6d                	jle    8013cf <vprintfmt+0x219>
  801362:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  801366:	74 67                	je     8013cf <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  801368:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80136b:	83 ec 08             	sub    $0x8,%esp
  80136e:	50                   	push   %eax
  80136f:	56                   	push   %esi
  801370:	e8 0c 03 00 00       	call   801681 <strnlen>
  801375:	83 c4 10             	add    $0x10,%esp
  801378:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  80137b:	eb 16                	jmp    801393 <vprintfmt+0x1dd>
					putch(padc, putdat);
  80137d:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  801381:	83 ec 08             	sub    $0x8,%esp
  801384:	ff 75 0c             	pushl  0xc(%ebp)
  801387:	50                   	push   %eax
  801388:	8b 45 08             	mov    0x8(%ebp),%eax
  80138b:	ff d0                	call   *%eax
  80138d:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  801390:	ff 4d e4             	decl   -0x1c(%ebp)
  801393:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  801397:	7f e4                	jg     80137d <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  801399:	eb 34                	jmp    8013cf <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  80139b:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  80139f:	74 1c                	je     8013bd <vprintfmt+0x207>
  8013a1:	83 fb 1f             	cmp    $0x1f,%ebx
  8013a4:	7e 05                	jle    8013ab <vprintfmt+0x1f5>
  8013a6:	83 fb 7e             	cmp    $0x7e,%ebx
  8013a9:	7e 12                	jle    8013bd <vprintfmt+0x207>
					putch('?', putdat);
  8013ab:	83 ec 08             	sub    $0x8,%esp
  8013ae:	ff 75 0c             	pushl  0xc(%ebp)
  8013b1:	6a 3f                	push   $0x3f
  8013b3:	8b 45 08             	mov    0x8(%ebp),%eax
  8013b6:	ff d0                	call   *%eax
  8013b8:	83 c4 10             	add    $0x10,%esp
  8013bb:	eb 0f                	jmp    8013cc <vprintfmt+0x216>
				else
					putch(ch, putdat);
  8013bd:	83 ec 08             	sub    $0x8,%esp
  8013c0:	ff 75 0c             	pushl  0xc(%ebp)
  8013c3:	53                   	push   %ebx
  8013c4:	8b 45 08             	mov    0x8(%ebp),%eax
  8013c7:	ff d0                	call   *%eax
  8013c9:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8013cc:	ff 4d e4             	decl   -0x1c(%ebp)
  8013cf:	89 f0                	mov    %esi,%eax
  8013d1:	8d 70 01             	lea    0x1(%eax),%esi
  8013d4:	8a 00                	mov    (%eax),%al
  8013d6:	0f be d8             	movsbl %al,%ebx
  8013d9:	85 db                	test   %ebx,%ebx
  8013db:	74 24                	je     801401 <vprintfmt+0x24b>
  8013dd:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8013e1:	78 b8                	js     80139b <vprintfmt+0x1e5>
  8013e3:	ff 4d e0             	decl   -0x20(%ebp)
  8013e6:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8013ea:	79 af                	jns    80139b <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  8013ec:	eb 13                	jmp    801401 <vprintfmt+0x24b>
				putch(' ', putdat);
  8013ee:	83 ec 08             	sub    $0x8,%esp
  8013f1:	ff 75 0c             	pushl  0xc(%ebp)
  8013f4:	6a 20                	push   $0x20
  8013f6:	8b 45 08             	mov    0x8(%ebp),%eax
  8013f9:	ff d0                	call   *%eax
  8013fb:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  8013fe:	ff 4d e4             	decl   -0x1c(%ebp)
  801401:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  801405:	7f e7                	jg     8013ee <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  801407:	e9 66 01 00 00       	jmp    801572 <vprintfmt+0x3bc>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  80140c:	83 ec 08             	sub    $0x8,%esp
  80140f:	ff 75 e8             	pushl  -0x18(%ebp)
  801412:	8d 45 14             	lea    0x14(%ebp),%eax
  801415:	50                   	push   %eax
  801416:	e8 3c fd ff ff       	call   801157 <getint>
  80141b:	83 c4 10             	add    $0x10,%esp
  80141e:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801421:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  801424:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801427:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80142a:	85 d2                	test   %edx,%edx
  80142c:	79 23                	jns    801451 <vprintfmt+0x29b>
				putch('-', putdat);
  80142e:	83 ec 08             	sub    $0x8,%esp
  801431:	ff 75 0c             	pushl  0xc(%ebp)
  801434:	6a 2d                	push   $0x2d
  801436:	8b 45 08             	mov    0x8(%ebp),%eax
  801439:	ff d0                	call   *%eax
  80143b:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  80143e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801441:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801444:	f7 d8                	neg    %eax
  801446:	83 d2 00             	adc    $0x0,%edx
  801449:	f7 da                	neg    %edx
  80144b:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80144e:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  801451:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  801458:	e9 bc 00 00 00       	jmp    801519 <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  80145d:	83 ec 08             	sub    $0x8,%esp
  801460:	ff 75 e8             	pushl  -0x18(%ebp)
  801463:	8d 45 14             	lea    0x14(%ebp),%eax
  801466:	50                   	push   %eax
  801467:	e8 84 fc ff ff       	call   8010f0 <getuint>
  80146c:	83 c4 10             	add    $0x10,%esp
  80146f:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801472:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  801475:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  80147c:	e9 98 00 00 00       	jmp    801519 <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  801481:	83 ec 08             	sub    $0x8,%esp
  801484:	ff 75 0c             	pushl  0xc(%ebp)
  801487:	6a 58                	push   $0x58
  801489:	8b 45 08             	mov    0x8(%ebp),%eax
  80148c:	ff d0                	call   *%eax
  80148e:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  801491:	83 ec 08             	sub    $0x8,%esp
  801494:	ff 75 0c             	pushl  0xc(%ebp)
  801497:	6a 58                	push   $0x58
  801499:	8b 45 08             	mov    0x8(%ebp),%eax
  80149c:	ff d0                	call   *%eax
  80149e:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  8014a1:	83 ec 08             	sub    $0x8,%esp
  8014a4:	ff 75 0c             	pushl  0xc(%ebp)
  8014a7:	6a 58                	push   $0x58
  8014a9:	8b 45 08             	mov    0x8(%ebp),%eax
  8014ac:	ff d0                	call   *%eax
  8014ae:	83 c4 10             	add    $0x10,%esp
			break;
  8014b1:	e9 bc 00 00 00       	jmp    801572 <vprintfmt+0x3bc>

		// pointer
		case 'p':
			putch('0', putdat);
  8014b6:	83 ec 08             	sub    $0x8,%esp
  8014b9:	ff 75 0c             	pushl  0xc(%ebp)
  8014bc:	6a 30                	push   $0x30
  8014be:	8b 45 08             	mov    0x8(%ebp),%eax
  8014c1:	ff d0                	call   *%eax
  8014c3:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  8014c6:	83 ec 08             	sub    $0x8,%esp
  8014c9:	ff 75 0c             	pushl  0xc(%ebp)
  8014cc:	6a 78                	push   $0x78
  8014ce:	8b 45 08             	mov    0x8(%ebp),%eax
  8014d1:	ff d0                	call   *%eax
  8014d3:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  8014d6:	8b 45 14             	mov    0x14(%ebp),%eax
  8014d9:	83 c0 04             	add    $0x4,%eax
  8014dc:	89 45 14             	mov    %eax,0x14(%ebp)
  8014df:	8b 45 14             	mov    0x14(%ebp),%eax
  8014e2:	83 e8 04             	sub    $0x4,%eax
  8014e5:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  8014e7:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8014ea:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  8014f1:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  8014f8:	eb 1f                	jmp    801519 <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  8014fa:	83 ec 08             	sub    $0x8,%esp
  8014fd:	ff 75 e8             	pushl  -0x18(%ebp)
  801500:	8d 45 14             	lea    0x14(%ebp),%eax
  801503:	50                   	push   %eax
  801504:	e8 e7 fb ff ff       	call   8010f0 <getuint>
  801509:	83 c4 10             	add    $0x10,%esp
  80150c:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80150f:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  801512:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  801519:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  80151d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801520:	83 ec 04             	sub    $0x4,%esp
  801523:	52                   	push   %edx
  801524:	ff 75 e4             	pushl  -0x1c(%ebp)
  801527:	50                   	push   %eax
  801528:	ff 75 f4             	pushl  -0xc(%ebp)
  80152b:	ff 75 f0             	pushl  -0x10(%ebp)
  80152e:	ff 75 0c             	pushl  0xc(%ebp)
  801531:	ff 75 08             	pushl  0x8(%ebp)
  801534:	e8 00 fb ff ff       	call   801039 <printnum>
  801539:	83 c4 20             	add    $0x20,%esp
			break;
  80153c:	eb 34                	jmp    801572 <vprintfmt+0x3bc>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  80153e:	83 ec 08             	sub    $0x8,%esp
  801541:	ff 75 0c             	pushl  0xc(%ebp)
  801544:	53                   	push   %ebx
  801545:	8b 45 08             	mov    0x8(%ebp),%eax
  801548:	ff d0                	call   *%eax
  80154a:	83 c4 10             	add    $0x10,%esp
			break;
  80154d:	eb 23                	jmp    801572 <vprintfmt+0x3bc>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  80154f:	83 ec 08             	sub    $0x8,%esp
  801552:	ff 75 0c             	pushl  0xc(%ebp)
  801555:	6a 25                	push   $0x25
  801557:	8b 45 08             	mov    0x8(%ebp),%eax
  80155a:	ff d0                	call   *%eax
  80155c:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  80155f:	ff 4d 10             	decl   0x10(%ebp)
  801562:	eb 03                	jmp    801567 <vprintfmt+0x3b1>
  801564:	ff 4d 10             	decl   0x10(%ebp)
  801567:	8b 45 10             	mov    0x10(%ebp),%eax
  80156a:	48                   	dec    %eax
  80156b:	8a 00                	mov    (%eax),%al
  80156d:	3c 25                	cmp    $0x25,%al
  80156f:	75 f3                	jne    801564 <vprintfmt+0x3ae>
				/* do nothing */;
			break;
  801571:	90                   	nop
		}
	}
  801572:	e9 47 fc ff ff       	jmp    8011be <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  801577:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  801578:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80157b:	5b                   	pop    %ebx
  80157c:	5e                   	pop    %esi
  80157d:	5d                   	pop    %ebp
  80157e:	c3                   	ret    

0080157f <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  80157f:	55                   	push   %ebp
  801580:	89 e5                	mov    %esp,%ebp
  801582:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  801585:	8d 45 10             	lea    0x10(%ebp),%eax
  801588:	83 c0 04             	add    $0x4,%eax
  80158b:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  80158e:	8b 45 10             	mov    0x10(%ebp),%eax
  801591:	ff 75 f4             	pushl  -0xc(%ebp)
  801594:	50                   	push   %eax
  801595:	ff 75 0c             	pushl  0xc(%ebp)
  801598:	ff 75 08             	pushl  0x8(%ebp)
  80159b:	e8 16 fc ff ff       	call   8011b6 <vprintfmt>
  8015a0:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  8015a3:	90                   	nop
  8015a4:	c9                   	leave  
  8015a5:	c3                   	ret    

008015a6 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  8015a6:	55                   	push   %ebp
  8015a7:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  8015a9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8015ac:	8b 40 08             	mov    0x8(%eax),%eax
  8015af:	8d 50 01             	lea    0x1(%eax),%edx
  8015b2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8015b5:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  8015b8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8015bb:	8b 10                	mov    (%eax),%edx
  8015bd:	8b 45 0c             	mov    0xc(%ebp),%eax
  8015c0:	8b 40 04             	mov    0x4(%eax),%eax
  8015c3:	39 c2                	cmp    %eax,%edx
  8015c5:	73 12                	jae    8015d9 <sprintputch+0x33>
		*b->buf++ = ch;
  8015c7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8015ca:	8b 00                	mov    (%eax),%eax
  8015cc:	8d 48 01             	lea    0x1(%eax),%ecx
  8015cf:	8b 55 0c             	mov    0xc(%ebp),%edx
  8015d2:	89 0a                	mov    %ecx,(%edx)
  8015d4:	8b 55 08             	mov    0x8(%ebp),%edx
  8015d7:	88 10                	mov    %dl,(%eax)
}
  8015d9:	90                   	nop
  8015da:	5d                   	pop    %ebp
  8015db:	c3                   	ret    

008015dc <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  8015dc:	55                   	push   %ebp
  8015dd:	89 e5                	mov    %esp,%ebp
  8015df:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  8015e2:	8b 45 08             	mov    0x8(%ebp),%eax
  8015e5:	89 45 ec             	mov    %eax,-0x14(%ebp)
  8015e8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8015eb:	8d 50 ff             	lea    -0x1(%eax),%edx
  8015ee:	8b 45 08             	mov    0x8(%ebp),%eax
  8015f1:	01 d0                	add    %edx,%eax
  8015f3:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8015f6:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  8015fd:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801601:	74 06                	je     801609 <vsnprintf+0x2d>
  801603:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801607:	7f 07                	jg     801610 <vsnprintf+0x34>
		return -E_INVAL;
  801609:	b8 03 00 00 00       	mov    $0x3,%eax
  80160e:	eb 20                	jmp    801630 <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  801610:	ff 75 14             	pushl  0x14(%ebp)
  801613:	ff 75 10             	pushl  0x10(%ebp)
  801616:	8d 45 ec             	lea    -0x14(%ebp),%eax
  801619:	50                   	push   %eax
  80161a:	68 a6 15 80 00       	push   $0x8015a6
  80161f:	e8 92 fb ff ff       	call   8011b6 <vprintfmt>
  801624:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  801627:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80162a:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  80162d:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  801630:	c9                   	leave  
  801631:	c3                   	ret    

00801632 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  801632:	55                   	push   %ebp
  801633:	89 e5                	mov    %esp,%ebp
  801635:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  801638:	8d 45 10             	lea    0x10(%ebp),%eax
  80163b:	83 c0 04             	add    $0x4,%eax
  80163e:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  801641:	8b 45 10             	mov    0x10(%ebp),%eax
  801644:	ff 75 f4             	pushl  -0xc(%ebp)
  801647:	50                   	push   %eax
  801648:	ff 75 0c             	pushl  0xc(%ebp)
  80164b:	ff 75 08             	pushl  0x8(%ebp)
  80164e:	e8 89 ff ff ff       	call   8015dc <vsnprintf>
  801653:	83 c4 10             	add    $0x10,%esp
  801656:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  801659:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  80165c:	c9                   	leave  
  80165d:	c3                   	ret    

0080165e <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  80165e:	55                   	push   %ebp
  80165f:	89 e5                	mov    %esp,%ebp
  801661:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  801664:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  80166b:	eb 06                	jmp    801673 <strlen+0x15>
		n++;
  80166d:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  801670:	ff 45 08             	incl   0x8(%ebp)
  801673:	8b 45 08             	mov    0x8(%ebp),%eax
  801676:	8a 00                	mov    (%eax),%al
  801678:	84 c0                	test   %al,%al
  80167a:	75 f1                	jne    80166d <strlen+0xf>
		n++;
	return n;
  80167c:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  80167f:	c9                   	leave  
  801680:	c3                   	ret    

00801681 <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  801681:	55                   	push   %ebp
  801682:	89 e5                	mov    %esp,%ebp
  801684:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  801687:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  80168e:	eb 09                	jmp    801699 <strnlen+0x18>
		n++;
  801690:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  801693:	ff 45 08             	incl   0x8(%ebp)
  801696:	ff 4d 0c             	decl   0xc(%ebp)
  801699:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80169d:	74 09                	je     8016a8 <strnlen+0x27>
  80169f:	8b 45 08             	mov    0x8(%ebp),%eax
  8016a2:	8a 00                	mov    (%eax),%al
  8016a4:	84 c0                	test   %al,%al
  8016a6:	75 e8                	jne    801690 <strnlen+0xf>
		n++;
	return n;
  8016a8:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  8016ab:	c9                   	leave  
  8016ac:	c3                   	ret    

008016ad <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  8016ad:	55                   	push   %ebp
  8016ae:	89 e5                	mov    %esp,%ebp
  8016b0:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  8016b3:	8b 45 08             	mov    0x8(%ebp),%eax
  8016b6:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  8016b9:	90                   	nop
  8016ba:	8b 45 08             	mov    0x8(%ebp),%eax
  8016bd:	8d 50 01             	lea    0x1(%eax),%edx
  8016c0:	89 55 08             	mov    %edx,0x8(%ebp)
  8016c3:	8b 55 0c             	mov    0xc(%ebp),%edx
  8016c6:	8d 4a 01             	lea    0x1(%edx),%ecx
  8016c9:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  8016cc:	8a 12                	mov    (%edx),%dl
  8016ce:	88 10                	mov    %dl,(%eax)
  8016d0:	8a 00                	mov    (%eax),%al
  8016d2:	84 c0                	test   %al,%al
  8016d4:	75 e4                	jne    8016ba <strcpy+0xd>
		/* do nothing */;
	return ret;
  8016d6:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  8016d9:	c9                   	leave  
  8016da:	c3                   	ret    

008016db <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  8016db:	55                   	push   %ebp
  8016dc:	89 e5                	mov    %esp,%ebp
  8016de:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  8016e1:	8b 45 08             	mov    0x8(%ebp),%eax
  8016e4:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  8016e7:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8016ee:	eb 1f                	jmp    80170f <strncpy+0x34>
		*dst++ = *src;
  8016f0:	8b 45 08             	mov    0x8(%ebp),%eax
  8016f3:	8d 50 01             	lea    0x1(%eax),%edx
  8016f6:	89 55 08             	mov    %edx,0x8(%ebp)
  8016f9:	8b 55 0c             	mov    0xc(%ebp),%edx
  8016fc:	8a 12                	mov    (%edx),%dl
  8016fe:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  801700:	8b 45 0c             	mov    0xc(%ebp),%eax
  801703:	8a 00                	mov    (%eax),%al
  801705:	84 c0                	test   %al,%al
  801707:	74 03                	je     80170c <strncpy+0x31>
			src++;
  801709:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  80170c:	ff 45 fc             	incl   -0x4(%ebp)
  80170f:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801712:	3b 45 10             	cmp    0x10(%ebp),%eax
  801715:	72 d9                	jb     8016f0 <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  801717:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  80171a:	c9                   	leave  
  80171b:	c3                   	ret    

0080171c <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  80171c:	55                   	push   %ebp
  80171d:	89 e5                	mov    %esp,%ebp
  80171f:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  801722:	8b 45 08             	mov    0x8(%ebp),%eax
  801725:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  801728:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80172c:	74 30                	je     80175e <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  80172e:	eb 16                	jmp    801746 <strlcpy+0x2a>
			*dst++ = *src++;
  801730:	8b 45 08             	mov    0x8(%ebp),%eax
  801733:	8d 50 01             	lea    0x1(%eax),%edx
  801736:	89 55 08             	mov    %edx,0x8(%ebp)
  801739:	8b 55 0c             	mov    0xc(%ebp),%edx
  80173c:	8d 4a 01             	lea    0x1(%edx),%ecx
  80173f:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  801742:	8a 12                	mov    (%edx),%dl
  801744:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  801746:	ff 4d 10             	decl   0x10(%ebp)
  801749:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80174d:	74 09                	je     801758 <strlcpy+0x3c>
  80174f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801752:	8a 00                	mov    (%eax),%al
  801754:	84 c0                	test   %al,%al
  801756:	75 d8                	jne    801730 <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  801758:	8b 45 08             	mov    0x8(%ebp),%eax
  80175b:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  80175e:	8b 55 08             	mov    0x8(%ebp),%edx
  801761:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801764:	29 c2                	sub    %eax,%edx
  801766:	89 d0                	mov    %edx,%eax
}
  801768:	c9                   	leave  
  801769:	c3                   	ret    

0080176a <strcmp>:

int
strcmp(const char *p, const char *q)
{
  80176a:	55                   	push   %ebp
  80176b:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  80176d:	eb 06                	jmp    801775 <strcmp+0xb>
		p++, q++;
  80176f:	ff 45 08             	incl   0x8(%ebp)
  801772:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  801775:	8b 45 08             	mov    0x8(%ebp),%eax
  801778:	8a 00                	mov    (%eax),%al
  80177a:	84 c0                	test   %al,%al
  80177c:	74 0e                	je     80178c <strcmp+0x22>
  80177e:	8b 45 08             	mov    0x8(%ebp),%eax
  801781:	8a 10                	mov    (%eax),%dl
  801783:	8b 45 0c             	mov    0xc(%ebp),%eax
  801786:	8a 00                	mov    (%eax),%al
  801788:	38 c2                	cmp    %al,%dl
  80178a:	74 e3                	je     80176f <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  80178c:	8b 45 08             	mov    0x8(%ebp),%eax
  80178f:	8a 00                	mov    (%eax),%al
  801791:	0f b6 d0             	movzbl %al,%edx
  801794:	8b 45 0c             	mov    0xc(%ebp),%eax
  801797:	8a 00                	mov    (%eax),%al
  801799:	0f b6 c0             	movzbl %al,%eax
  80179c:	29 c2                	sub    %eax,%edx
  80179e:	89 d0                	mov    %edx,%eax
}
  8017a0:	5d                   	pop    %ebp
  8017a1:	c3                   	ret    

008017a2 <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  8017a2:	55                   	push   %ebp
  8017a3:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  8017a5:	eb 09                	jmp    8017b0 <strncmp+0xe>
		n--, p++, q++;
  8017a7:	ff 4d 10             	decl   0x10(%ebp)
  8017aa:	ff 45 08             	incl   0x8(%ebp)
  8017ad:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  8017b0:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8017b4:	74 17                	je     8017cd <strncmp+0x2b>
  8017b6:	8b 45 08             	mov    0x8(%ebp),%eax
  8017b9:	8a 00                	mov    (%eax),%al
  8017bb:	84 c0                	test   %al,%al
  8017bd:	74 0e                	je     8017cd <strncmp+0x2b>
  8017bf:	8b 45 08             	mov    0x8(%ebp),%eax
  8017c2:	8a 10                	mov    (%eax),%dl
  8017c4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8017c7:	8a 00                	mov    (%eax),%al
  8017c9:	38 c2                	cmp    %al,%dl
  8017cb:	74 da                	je     8017a7 <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  8017cd:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8017d1:	75 07                	jne    8017da <strncmp+0x38>
		return 0;
  8017d3:	b8 00 00 00 00       	mov    $0x0,%eax
  8017d8:	eb 14                	jmp    8017ee <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  8017da:	8b 45 08             	mov    0x8(%ebp),%eax
  8017dd:	8a 00                	mov    (%eax),%al
  8017df:	0f b6 d0             	movzbl %al,%edx
  8017e2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8017e5:	8a 00                	mov    (%eax),%al
  8017e7:	0f b6 c0             	movzbl %al,%eax
  8017ea:	29 c2                	sub    %eax,%edx
  8017ec:	89 d0                	mov    %edx,%eax
}
  8017ee:	5d                   	pop    %ebp
  8017ef:	c3                   	ret    

008017f0 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  8017f0:	55                   	push   %ebp
  8017f1:	89 e5                	mov    %esp,%ebp
  8017f3:	83 ec 04             	sub    $0x4,%esp
  8017f6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8017f9:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  8017fc:	eb 12                	jmp    801810 <strchr+0x20>
		if (*s == c)
  8017fe:	8b 45 08             	mov    0x8(%ebp),%eax
  801801:	8a 00                	mov    (%eax),%al
  801803:	3a 45 fc             	cmp    -0x4(%ebp),%al
  801806:	75 05                	jne    80180d <strchr+0x1d>
			return (char *) s;
  801808:	8b 45 08             	mov    0x8(%ebp),%eax
  80180b:	eb 11                	jmp    80181e <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  80180d:	ff 45 08             	incl   0x8(%ebp)
  801810:	8b 45 08             	mov    0x8(%ebp),%eax
  801813:	8a 00                	mov    (%eax),%al
  801815:	84 c0                	test   %al,%al
  801817:	75 e5                	jne    8017fe <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  801819:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80181e:	c9                   	leave  
  80181f:	c3                   	ret    

00801820 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  801820:	55                   	push   %ebp
  801821:	89 e5                	mov    %esp,%ebp
  801823:	83 ec 04             	sub    $0x4,%esp
  801826:	8b 45 0c             	mov    0xc(%ebp),%eax
  801829:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  80182c:	eb 0d                	jmp    80183b <strfind+0x1b>
		if (*s == c)
  80182e:	8b 45 08             	mov    0x8(%ebp),%eax
  801831:	8a 00                	mov    (%eax),%al
  801833:	3a 45 fc             	cmp    -0x4(%ebp),%al
  801836:	74 0e                	je     801846 <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  801838:	ff 45 08             	incl   0x8(%ebp)
  80183b:	8b 45 08             	mov    0x8(%ebp),%eax
  80183e:	8a 00                	mov    (%eax),%al
  801840:	84 c0                	test   %al,%al
  801842:	75 ea                	jne    80182e <strfind+0xe>
  801844:	eb 01                	jmp    801847 <strfind+0x27>
		if (*s == c)
			break;
  801846:	90                   	nop
	return (char *) s;
  801847:	8b 45 08             	mov    0x8(%ebp),%eax
}
  80184a:	c9                   	leave  
  80184b:	c3                   	ret    

0080184c <memset>:


void *
memset(void *v, int c, uint32 n)
{
  80184c:	55                   	push   %ebp
  80184d:	89 e5                	mov    %esp,%ebp
  80184f:	83 ec 10             	sub    $0x10,%esp
	char *p;
	int m;

	p = v;
  801852:	8b 45 08             	mov    0x8(%ebp),%eax
  801855:	89 45 fc             	mov    %eax,-0x4(%ebp)
	m = n;
  801858:	8b 45 10             	mov    0x10(%ebp),%eax
  80185b:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (--m >= 0)
  80185e:	eb 0e                	jmp    80186e <memset+0x22>
		*p++ = c;
  801860:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801863:	8d 50 01             	lea    0x1(%eax),%edx
  801866:	89 55 fc             	mov    %edx,-0x4(%ebp)
  801869:	8b 55 0c             	mov    0xc(%ebp),%edx
  80186c:	88 10                	mov    %dl,(%eax)
	char *p;
	int m;

	p = v;
	m = n;
	while (--m >= 0)
  80186e:	ff 4d f8             	decl   -0x8(%ebp)
  801871:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  801875:	79 e9                	jns    801860 <memset+0x14>
		*p++ = c;

	return v;
  801877:	8b 45 08             	mov    0x8(%ebp),%eax
}
  80187a:	c9                   	leave  
  80187b:	c3                   	ret    

0080187c <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  80187c:	55                   	push   %ebp
  80187d:	89 e5                	mov    %esp,%ebp
  80187f:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  801882:	8b 45 0c             	mov    0xc(%ebp),%eax
  801885:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  801888:	8b 45 08             	mov    0x8(%ebp),%eax
  80188b:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (n-- > 0)
  80188e:	eb 16                	jmp    8018a6 <memcpy+0x2a>
		*d++ = *s++;
  801890:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801893:	8d 50 01             	lea    0x1(%eax),%edx
  801896:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801899:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80189c:	8d 4a 01             	lea    0x1(%edx),%ecx
  80189f:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  8018a2:	8a 12                	mov    (%edx),%dl
  8018a4:	88 10                	mov    %dl,(%eax)
	const char *s;
	char *d;

	s = src;
	d = dst;
	while (n-- > 0)
  8018a6:	8b 45 10             	mov    0x10(%ebp),%eax
  8018a9:	8d 50 ff             	lea    -0x1(%eax),%edx
  8018ac:	89 55 10             	mov    %edx,0x10(%ebp)
  8018af:	85 c0                	test   %eax,%eax
  8018b1:	75 dd                	jne    801890 <memcpy+0x14>
		*d++ = *s++;

	return dst;
  8018b3:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8018b6:	c9                   	leave  
  8018b7:	c3                   	ret    

008018b8 <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  8018b8:	55                   	push   %ebp
  8018b9:	89 e5                	mov    %esp,%ebp
  8018bb:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  8018be:	8b 45 0c             	mov    0xc(%ebp),%eax
  8018c1:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  8018c4:	8b 45 08             	mov    0x8(%ebp),%eax
  8018c7:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  8018ca:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8018cd:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  8018d0:	73 50                	jae    801922 <memmove+0x6a>
  8018d2:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8018d5:	8b 45 10             	mov    0x10(%ebp),%eax
  8018d8:	01 d0                	add    %edx,%eax
  8018da:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  8018dd:	76 43                	jbe    801922 <memmove+0x6a>
		s += n;
  8018df:	8b 45 10             	mov    0x10(%ebp),%eax
  8018e2:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  8018e5:	8b 45 10             	mov    0x10(%ebp),%eax
  8018e8:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  8018eb:	eb 10                	jmp    8018fd <memmove+0x45>
			*--d = *--s;
  8018ed:	ff 4d f8             	decl   -0x8(%ebp)
  8018f0:	ff 4d fc             	decl   -0x4(%ebp)
  8018f3:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8018f6:	8a 10                	mov    (%eax),%dl
  8018f8:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8018fb:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  8018fd:	8b 45 10             	mov    0x10(%ebp),%eax
  801900:	8d 50 ff             	lea    -0x1(%eax),%edx
  801903:	89 55 10             	mov    %edx,0x10(%ebp)
  801906:	85 c0                	test   %eax,%eax
  801908:	75 e3                	jne    8018ed <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  80190a:	eb 23                	jmp    80192f <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  80190c:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80190f:	8d 50 01             	lea    0x1(%eax),%edx
  801912:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801915:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801918:	8d 4a 01             	lea    0x1(%edx),%ecx
  80191b:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  80191e:	8a 12                	mov    (%edx),%dl
  801920:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  801922:	8b 45 10             	mov    0x10(%ebp),%eax
  801925:	8d 50 ff             	lea    -0x1(%eax),%edx
  801928:	89 55 10             	mov    %edx,0x10(%ebp)
  80192b:	85 c0                	test   %eax,%eax
  80192d:	75 dd                	jne    80190c <memmove+0x54>
			*d++ = *s++;

	return dst;
  80192f:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801932:	c9                   	leave  
  801933:	c3                   	ret    

00801934 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  801934:	55                   	push   %ebp
  801935:	89 e5                	mov    %esp,%ebp
  801937:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  80193a:	8b 45 08             	mov    0x8(%ebp),%eax
  80193d:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  801940:	8b 45 0c             	mov    0xc(%ebp),%eax
  801943:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  801946:	eb 2a                	jmp    801972 <memcmp+0x3e>
		if (*s1 != *s2)
  801948:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80194b:	8a 10                	mov    (%eax),%dl
  80194d:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801950:	8a 00                	mov    (%eax),%al
  801952:	38 c2                	cmp    %al,%dl
  801954:	74 16                	je     80196c <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  801956:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801959:	8a 00                	mov    (%eax),%al
  80195b:	0f b6 d0             	movzbl %al,%edx
  80195e:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801961:	8a 00                	mov    (%eax),%al
  801963:	0f b6 c0             	movzbl %al,%eax
  801966:	29 c2                	sub    %eax,%edx
  801968:	89 d0                	mov    %edx,%eax
  80196a:	eb 18                	jmp    801984 <memcmp+0x50>
		s1++, s2++;
  80196c:	ff 45 fc             	incl   -0x4(%ebp)
  80196f:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  801972:	8b 45 10             	mov    0x10(%ebp),%eax
  801975:	8d 50 ff             	lea    -0x1(%eax),%edx
  801978:	89 55 10             	mov    %edx,0x10(%ebp)
  80197b:	85 c0                	test   %eax,%eax
  80197d:	75 c9                	jne    801948 <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  80197f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801984:	c9                   	leave  
  801985:	c3                   	ret    

00801986 <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  801986:	55                   	push   %ebp
  801987:	89 e5                	mov    %esp,%ebp
  801989:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  80198c:	8b 55 08             	mov    0x8(%ebp),%edx
  80198f:	8b 45 10             	mov    0x10(%ebp),%eax
  801992:	01 d0                	add    %edx,%eax
  801994:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  801997:	eb 15                	jmp    8019ae <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  801999:	8b 45 08             	mov    0x8(%ebp),%eax
  80199c:	8a 00                	mov    (%eax),%al
  80199e:	0f b6 d0             	movzbl %al,%edx
  8019a1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8019a4:	0f b6 c0             	movzbl %al,%eax
  8019a7:	39 c2                	cmp    %eax,%edx
  8019a9:	74 0d                	je     8019b8 <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  8019ab:	ff 45 08             	incl   0x8(%ebp)
  8019ae:	8b 45 08             	mov    0x8(%ebp),%eax
  8019b1:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  8019b4:	72 e3                	jb     801999 <memfind+0x13>
  8019b6:	eb 01                	jmp    8019b9 <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  8019b8:	90                   	nop
	return (void *) s;
  8019b9:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8019bc:	c9                   	leave  
  8019bd:	c3                   	ret    

008019be <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  8019be:	55                   	push   %ebp
  8019bf:	89 e5                	mov    %esp,%ebp
  8019c1:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  8019c4:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  8019cb:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  8019d2:	eb 03                	jmp    8019d7 <strtol+0x19>
		s++;
  8019d4:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  8019d7:	8b 45 08             	mov    0x8(%ebp),%eax
  8019da:	8a 00                	mov    (%eax),%al
  8019dc:	3c 20                	cmp    $0x20,%al
  8019de:	74 f4                	je     8019d4 <strtol+0x16>
  8019e0:	8b 45 08             	mov    0x8(%ebp),%eax
  8019e3:	8a 00                	mov    (%eax),%al
  8019e5:	3c 09                	cmp    $0x9,%al
  8019e7:	74 eb                	je     8019d4 <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  8019e9:	8b 45 08             	mov    0x8(%ebp),%eax
  8019ec:	8a 00                	mov    (%eax),%al
  8019ee:	3c 2b                	cmp    $0x2b,%al
  8019f0:	75 05                	jne    8019f7 <strtol+0x39>
		s++;
  8019f2:	ff 45 08             	incl   0x8(%ebp)
  8019f5:	eb 13                	jmp    801a0a <strtol+0x4c>
	else if (*s == '-')
  8019f7:	8b 45 08             	mov    0x8(%ebp),%eax
  8019fa:	8a 00                	mov    (%eax),%al
  8019fc:	3c 2d                	cmp    $0x2d,%al
  8019fe:	75 0a                	jne    801a0a <strtol+0x4c>
		s++, neg = 1;
  801a00:	ff 45 08             	incl   0x8(%ebp)
  801a03:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  801a0a:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801a0e:	74 06                	je     801a16 <strtol+0x58>
  801a10:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  801a14:	75 20                	jne    801a36 <strtol+0x78>
  801a16:	8b 45 08             	mov    0x8(%ebp),%eax
  801a19:	8a 00                	mov    (%eax),%al
  801a1b:	3c 30                	cmp    $0x30,%al
  801a1d:	75 17                	jne    801a36 <strtol+0x78>
  801a1f:	8b 45 08             	mov    0x8(%ebp),%eax
  801a22:	40                   	inc    %eax
  801a23:	8a 00                	mov    (%eax),%al
  801a25:	3c 78                	cmp    $0x78,%al
  801a27:	75 0d                	jne    801a36 <strtol+0x78>
		s += 2, base = 16;
  801a29:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  801a2d:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  801a34:	eb 28                	jmp    801a5e <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  801a36:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801a3a:	75 15                	jne    801a51 <strtol+0x93>
  801a3c:	8b 45 08             	mov    0x8(%ebp),%eax
  801a3f:	8a 00                	mov    (%eax),%al
  801a41:	3c 30                	cmp    $0x30,%al
  801a43:	75 0c                	jne    801a51 <strtol+0x93>
		s++, base = 8;
  801a45:	ff 45 08             	incl   0x8(%ebp)
  801a48:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  801a4f:	eb 0d                	jmp    801a5e <strtol+0xa0>
	else if (base == 0)
  801a51:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801a55:	75 07                	jne    801a5e <strtol+0xa0>
		base = 10;
  801a57:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  801a5e:	8b 45 08             	mov    0x8(%ebp),%eax
  801a61:	8a 00                	mov    (%eax),%al
  801a63:	3c 2f                	cmp    $0x2f,%al
  801a65:	7e 19                	jle    801a80 <strtol+0xc2>
  801a67:	8b 45 08             	mov    0x8(%ebp),%eax
  801a6a:	8a 00                	mov    (%eax),%al
  801a6c:	3c 39                	cmp    $0x39,%al
  801a6e:	7f 10                	jg     801a80 <strtol+0xc2>
			dig = *s - '0';
  801a70:	8b 45 08             	mov    0x8(%ebp),%eax
  801a73:	8a 00                	mov    (%eax),%al
  801a75:	0f be c0             	movsbl %al,%eax
  801a78:	83 e8 30             	sub    $0x30,%eax
  801a7b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801a7e:	eb 42                	jmp    801ac2 <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  801a80:	8b 45 08             	mov    0x8(%ebp),%eax
  801a83:	8a 00                	mov    (%eax),%al
  801a85:	3c 60                	cmp    $0x60,%al
  801a87:	7e 19                	jle    801aa2 <strtol+0xe4>
  801a89:	8b 45 08             	mov    0x8(%ebp),%eax
  801a8c:	8a 00                	mov    (%eax),%al
  801a8e:	3c 7a                	cmp    $0x7a,%al
  801a90:	7f 10                	jg     801aa2 <strtol+0xe4>
			dig = *s - 'a' + 10;
  801a92:	8b 45 08             	mov    0x8(%ebp),%eax
  801a95:	8a 00                	mov    (%eax),%al
  801a97:	0f be c0             	movsbl %al,%eax
  801a9a:	83 e8 57             	sub    $0x57,%eax
  801a9d:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801aa0:	eb 20                	jmp    801ac2 <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  801aa2:	8b 45 08             	mov    0x8(%ebp),%eax
  801aa5:	8a 00                	mov    (%eax),%al
  801aa7:	3c 40                	cmp    $0x40,%al
  801aa9:	7e 39                	jle    801ae4 <strtol+0x126>
  801aab:	8b 45 08             	mov    0x8(%ebp),%eax
  801aae:	8a 00                	mov    (%eax),%al
  801ab0:	3c 5a                	cmp    $0x5a,%al
  801ab2:	7f 30                	jg     801ae4 <strtol+0x126>
			dig = *s - 'A' + 10;
  801ab4:	8b 45 08             	mov    0x8(%ebp),%eax
  801ab7:	8a 00                	mov    (%eax),%al
  801ab9:	0f be c0             	movsbl %al,%eax
  801abc:	83 e8 37             	sub    $0x37,%eax
  801abf:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  801ac2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ac5:	3b 45 10             	cmp    0x10(%ebp),%eax
  801ac8:	7d 19                	jge    801ae3 <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  801aca:	ff 45 08             	incl   0x8(%ebp)
  801acd:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801ad0:	0f af 45 10          	imul   0x10(%ebp),%eax
  801ad4:	89 c2                	mov    %eax,%edx
  801ad6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ad9:	01 d0                	add    %edx,%eax
  801adb:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  801ade:	e9 7b ff ff ff       	jmp    801a5e <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  801ae3:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  801ae4:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801ae8:	74 08                	je     801af2 <strtol+0x134>
		*endptr = (char *) s;
  801aea:	8b 45 0c             	mov    0xc(%ebp),%eax
  801aed:	8b 55 08             	mov    0x8(%ebp),%edx
  801af0:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  801af2:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801af6:	74 07                	je     801aff <strtol+0x141>
  801af8:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801afb:	f7 d8                	neg    %eax
  801afd:	eb 03                	jmp    801b02 <strtol+0x144>
  801aff:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  801b02:	c9                   	leave  
  801b03:	c3                   	ret    

00801b04 <ltostr>:

void
ltostr(long value, char *str)
{
  801b04:	55                   	push   %ebp
  801b05:	89 e5                	mov    %esp,%ebp
  801b07:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  801b0a:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  801b11:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  801b18:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801b1c:	79 13                	jns    801b31 <ltostr+0x2d>
	{
		neg = 1;
  801b1e:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  801b25:	8b 45 0c             	mov    0xc(%ebp),%eax
  801b28:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  801b2b:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  801b2e:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  801b31:	8b 45 08             	mov    0x8(%ebp),%eax
  801b34:	b9 0a 00 00 00       	mov    $0xa,%ecx
  801b39:	99                   	cltd   
  801b3a:	f7 f9                	idiv   %ecx
  801b3c:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  801b3f:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801b42:	8d 50 01             	lea    0x1(%eax),%edx
  801b45:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801b48:	89 c2                	mov    %eax,%edx
  801b4a:	8b 45 0c             	mov    0xc(%ebp),%eax
  801b4d:	01 d0                	add    %edx,%eax
  801b4f:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801b52:	83 c2 30             	add    $0x30,%edx
  801b55:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  801b57:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801b5a:	b8 67 66 66 66       	mov    $0x66666667,%eax
  801b5f:	f7 e9                	imul   %ecx
  801b61:	c1 fa 02             	sar    $0x2,%edx
  801b64:	89 c8                	mov    %ecx,%eax
  801b66:	c1 f8 1f             	sar    $0x1f,%eax
  801b69:	29 c2                	sub    %eax,%edx
  801b6b:	89 d0                	mov    %edx,%eax
  801b6d:	89 45 08             	mov    %eax,0x8(%ebp)
	} while (value % 10 != 0);
  801b70:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801b73:	b8 67 66 66 66       	mov    $0x66666667,%eax
  801b78:	f7 e9                	imul   %ecx
  801b7a:	c1 fa 02             	sar    $0x2,%edx
  801b7d:	89 c8                	mov    %ecx,%eax
  801b7f:	c1 f8 1f             	sar    $0x1f,%eax
  801b82:	29 c2                	sub    %eax,%edx
  801b84:	89 d0                	mov    %edx,%eax
  801b86:	c1 e0 02             	shl    $0x2,%eax
  801b89:	01 d0                	add    %edx,%eax
  801b8b:	01 c0                	add    %eax,%eax
  801b8d:	29 c1                	sub    %eax,%ecx
  801b8f:	89 ca                	mov    %ecx,%edx
  801b91:	85 d2                	test   %edx,%edx
  801b93:	75 9c                	jne    801b31 <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  801b95:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  801b9c:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801b9f:	48                   	dec    %eax
  801ba0:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  801ba3:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801ba7:	74 3d                	je     801be6 <ltostr+0xe2>
		start = 1 ;
  801ba9:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  801bb0:	eb 34                	jmp    801be6 <ltostr+0xe2>
	{
		char tmp = str[start] ;
  801bb2:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801bb5:	8b 45 0c             	mov    0xc(%ebp),%eax
  801bb8:	01 d0                	add    %edx,%eax
  801bba:	8a 00                	mov    (%eax),%al
  801bbc:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  801bbf:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801bc2:	8b 45 0c             	mov    0xc(%ebp),%eax
  801bc5:	01 c2                	add    %eax,%edx
  801bc7:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  801bca:	8b 45 0c             	mov    0xc(%ebp),%eax
  801bcd:	01 c8                	add    %ecx,%eax
  801bcf:	8a 00                	mov    (%eax),%al
  801bd1:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  801bd3:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801bd6:	8b 45 0c             	mov    0xc(%ebp),%eax
  801bd9:	01 c2                	add    %eax,%edx
  801bdb:	8a 45 eb             	mov    -0x15(%ebp),%al
  801bde:	88 02                	mov    %al,(%edx)
		start++ ;
  801be0:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  801be3:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  801be6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801be9:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801bec:	7c c4                	jl     801bb2 <ltostr+0xae>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  801bee:	8b 55 f8             	mov    -0x8(%ebp),%edx
  801bf1:	8b 45 0c             	mov    0xc(%ebp),%eax
  801bf4:	01 d0                	add    %edx,%eax
  801bf6:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  801bf9:	90                   	nop
  801bfa:	c9                   	leave  
  801bfb:	c3                   	ret    

00801bfc <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  801bfc:	55                   	push   %ebp
  801bfd:	89 e5                	mov    %esp,%ebp
  801bff:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  801c02:	ff 75 08             	pushl  0x8(%ebp)
  801c05:	e8 54 fa ff ff       	call   80165e <strlen>
  801c0a:	83 c4 04             	add    $0x4,%esp
  801c0d:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  801c10:	ff 75 0c             	pushl  0xc(%ebp)
  801c13:	e8 46 fa ff ff       	call   80165e <strlen>
  801c18:	83 c4 04             	add    $0x4,%esp
  801c1b:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  801c1e:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  801c25:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801c2c:	eb 17                	jmp    801c45 <strcconcat+0x49>
		final[s] = str1[s] ;
  801c2e:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801c31:	8b 45 10             	mov    0x10(%ebp),%eax
  801c34:	01 c2                	add    %eax,%edx
  801c36:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  801c39:	8b 45 08             	mov    0x8(%ebp),%eax
  801c3c:	01 c8                	add    %ecx,%eax
  801c3e:	8a 00                	mov    (%eax),%al
  801c40:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  801c42:	ff 45 fc             	incl   -0x4(%ebp)
  801c45:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801c48:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  801c4b:	7c e1                	jl     801c2e <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  801c4d:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  801c54:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  801c5b:	eb 1f                	jmp    801c7c <strcconcat+0x80>
		final[s++] = str2[i] ;
  801c5d:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801c60:	8d 50 01             	lea    0x1(%eax),%edx
  801c63:	89 55 fc             	mov    %edx,-0x4(%ebp)
  801c66:	89 c2                	mov    %eax,%edx
  801c68:	8b 45 10             	mov    0x10(%ebp),%eax
  801c6b:	01 c2                	add    %eax,%edx
  801c6d:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  801c70:	8b 45 0c             	mov    0xc(%ebp),%eax
  801c73:	01 c8                	add    %ecx,%eax
  801c75:	8a 00                	mov    (%eax),%al
  801c77:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  801c79:	ff 45 f8             	incl   -0x8(%ebp)
  801c7c:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801c7f:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801c82:	7c d9                	jl     801c5d <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  801c84:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801c87:	8b 45 10             	mov    0x10(%ebp),%eax
  801c8a:	01 d0                	add    %edx,%eax
  801c8c:	c6 00 00             	movb   $0x0,(%eax)
}
  801c8f:	90                   	nop
  801c90:	c9                   	leave  
  801c91:	c3                   	ret    

00801c92 <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  801c92:	55                   	push   %ebp
  801c93:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  801c95:	8b 45 14             	mov    0x14(%ebp),%eax
  801c98:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  801c9e:	8b 45 14             	mov    0x14(%ebp),%eax
  801ca1:	8b 00                	mov    (%eax),%eax
  801ca3:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801caa:	8b 45 10             	mov    0x10(%ebp),%eax
  801cad:	01 d0                	add    %edx,%eax
  801caf:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801cb5:	eb 0c                	jmp    801cc3 <strsplit+0x31>
			*string++ = 0;
  801cb7:	8b 45 08             	mov    0x8(%ebp),%eax
  801cba:	8d 50 01             	lea    0x1(%eax),%edx
  801cbd:	89 55 08             	mov    %edx,0x8(%ebp)
  801cc0:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801cc3:	8b 45 08             	mov    0x8(%ebp),%eax
  801cc6:	8a 00                	mov    (%eax),%al
  801cc8:	84 c0                	test   %al,%al
  801cca:	74 18                	je     801ce4 <strsplit+0x52>
  801ccc:	8b 45 08             	mov    0x8(%ebp),%eax
  801ccf:	8a 00                	mov    (%eax),%al
  801cd1:	0f be c0             	movsbl %al,%eax
  801cd4:	50                   	push   %eax
  801cd5:	ff 75 0c             	pushl  0xc(%ebp)
  801cd8:	e8 13 fb ff ff       	call   8017f0 <strchr>
  801cdd:	83 c4 08             	add    $0x8,%esp
  801ce0:	85 c0                	test   %eax,%eax
  801ce2:	75 d3                	jne    801cb7 <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  801ce4:	8b 45 08             	mov    0x8(%ebp),%eax
  801ce7:	8a 00                	mov    (%eax),%al
  801ce9:	84 c0                	test   %al,%al
  801ceb:	74 5a                	je     801d47 <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  801ced:	8b 45 14             	mov    0x14(%ebp),%eax
  801cf0:	8b 00                	mov    (%eax),%eax
  801cf2:	83 f8 0f             	cmp    $0xf,%eax
  801cf5:	75 07                	jne    801cfe <strsplit+0x6c>
		{
			return 0;
  801cf7:	b8 00 00 00 00       	mov    $0x0,%eax
  801cfc:	eb 66                	jmp    801d64 <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  801cfe:	8b 45 14             	mov    0x14(%ebp),%eax
  801d01:	8b 00                	mov    (%eax),%eax
  801d03:	8d 48 01             	lea    0x1(%eax),%ecx
  801d06:	8b 55 14             	mov    0x14(%ebp),%edx
  801d09:	89 0a                	mov    %ecx,(%edx)
  801d0b:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801d12:	8b 45 10             	mov    0x10(%ebp),%eax
  801d15:	01 c2                	add    %eax,%edx
  801d17:	8b 45 08             	mov    0x8(%ebp),%eax
  801d1a:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  801d1c:	eb 03                	jmp    801d21 <strsplit+0x8f>
			string++;
  801d1e:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  801d21:	8b 45 08             	mov    0x8(%ebp),%eax
  801d24:	8a 00                	mov    (%eax),%al
  801d26:	84 c0                	test   %al,%al
  801d28:	74 8b                	je     801cb5 <strsplit+0x23>
  801d2a:	8b 45 08             	mov    0x8(%ebp),%eax
  801d2d:	8a 00                	mov    (%eax),%al
  801d2f:	0f be c0             	movsbl %al,%eax
  801d32:	50                   	push   %eax
  801d33:	ff 75 0c             	pushl  0xc(%ebp)
  801d36:	e8 b5 fa ff ff       	call   8017f0 <strchr>
  801d3b:	83 c4 08             	add    $0x8,%esp
  801d3e:	85 c0                	test   %eax,%eax
  801d40:	74 dc                	je     801d1e <strsplit+0x8c>
			string++;
	}
  801d42:	e9 6e ff ff ff       	jmp    801cb5 <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  801d47:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  801d48:	8b 45 14             	mov    0x14(%ebp),%eax
  801d4b:	8b 00                	mov    (%eax),%eax
  801d4d:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801d54:	8b 45 10             	mov    0x10(%ebp),%eax
  801d57:	01 d0                	add    %edx,%eax
  801d59:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  801d5f:	b8 01 00 00 00       	mov    $0x1,%eax
}
  801d64:	c9                   	leave  
  801d65:	c3                   	ret    

00801d66 <InitializeUHeap>:
//============================== GIVEN FUNCTIONS ===================================//
//==================================================================================//

int FirstTimeFlag = 1;
void InitializeUHeap()
{
  801d66:	55                   	push   %ebp
  801d67:	89 e5                	mov    %esp,%ebp
  801d69:	83 ec 08             	sub    $0x8,%esp
	if(FirstTimeFlag)
  801d6c:	a1 04 50 80 00       	mov    0x805004,%eax
  801d71:	85 c0                	test   %eax,%eax
  801d73:	74 1f                	je     801d94 <InitializeUHeap+0x2e>
	{
		initialize_dyn_block_system();
  801d75:	e8 1d 00 00 00       	call   801d97 <initialize_dyn_block_system>
		cprintf("DYNAMIC BLOCK SYSTEM IS INITIALIZED\n");
  801d7a:	83 ec 0c             	sub    $0xc,%esp
  801d7d:	68 f0 43 80 00       	push   $0x8043f0
  801d82:	e8 55 f2 ff ff       	call   800fdc <cprintf>
  801d87:	83 c4 10             	add    $0x10,%esp
#if UHP_USE_BUDDY
		initialize_buddy();
		cprintf("BUDDY SYSTEM IS INITIALIZED\n");
#endif
		FirstTimeFlag = 0;
  801d8a:	c7 05 04 50 80 00 00 	movl   $0x0,0x805004
  801d91:	00 00 00 
	}
}
  801d94:	90                   	nop
  801d95:	c9                   	leave  
  801d96:	c3                   	ret    

00801d97 <initialize_dyn_block_system>:

//=================================
// [1] INITIALIZE DYNAMIC ALLOCATOR:
//=================================
void initialize_dyn_block_system()
{
  801d97:	55                   	push   %ebp
  801d98:	89 e5                	mov    %esp,%ebp
  801d9a:	83 ec 28             	sub    $0x28,%esp
	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] initialize_dyn_block_system
	// your code is here, remove the panic and write your code
	//panic("initialize_dyn_block_system() is not implemented yet...!!");

	LIST_INIT(&AllocMemBlocksList);
  801d9d:	c7 05 40 50 80 00 00 	movl   $0x0,0x805040
  801da4:	00 00 00 
  801da7:	c7 05 44 50 80 00 00 	movl   $0x0,0x805044
  801dae:	00 00 00 
  801db1:	c7 05 4c 50 80 00 00 	movl   $0x0,0x80504c
  801db8:	00 00 00 
	LIST_INIT(&FreeMemBlocksList);
  801dbb:	c7 05 38 51 80 00 00 	movl   $0x0,0x805138
  801dc2:	00 00 00 
  801dc5:	c7 05 3c 51 80 00 00 	movl   $0x0,0x80513c
  801dcc:	00 00 00 
  801dcf:	c7 05 44 51 80 00 00 	movl   $0x0,0x805144
  801dd6:	00 00 00 
	MAX_MEM_BLOCK_CNT = NUM_OF_UHEAP_PAGES;
  801dd9:	c7 05 20 51 80 00 00 	movl   $0x20000,0x805120
  801de0:	00 02 00 
	MemBlockNodes = (void*)USER_DYN_BLKS_ARRAY;
  801de3:	c7 45 f4 00 00 e0 7f 	movl   $0x7fe00000,-0xc(%ebp)
  801dea:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ded:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801df2:	2d 00 10 00 00       	sub    $0x1000,%eax
  801df7:	a3 50 50 80 00       	mov    %eax,0x805050
	int size_of_block = sizeof(struct MemBlock);
  801dfc:	c7 45 f0 10 00 00 00 	movl   $0x10,-0x10(%ebp)
	int size_all_struct = size_of_block*MAX_MEM_BLOCK_CNT;
  801e03:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801e06:	a1 20 51 80 00       	mov    0x805120,%eax
  801e0b:	0f af c2             	imul   %edx,%eax
  801e0e:	89 45 ec             	mov    %eax,-0x14(%ebp)
	size_all_struct = ROUNDUP(size_all_struct, PAGE_SIZE);
  801e11:	c7 45 e8 00 10 00 00 	movl   $0x1000,-0x18(%ebp)
  801e18:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801e1b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801e1e:	01 d0                	add    %edx,%eax
  801e20:	48                   	dec    %eax
  801e21:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  801e24:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801e27:	ba 00 00 00 00       	mov    $0x0,%edx
  801e2c:	f7 75 e8             	divl   -0x18(%ebp)
  801e2f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801e32:	29 d0                	sub    %edx,%eax
  801e34:	89 45 ec             	mov    %eax,-0x14(%ebp)
	sys_allocate_chunk(USER_DYN_BLKS_ARRAY, size_all_struct,PERM_USER| PERM_WRITEABLE);
  801e37:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801e3a:	c7 45 e0 00 00 e0 7f 	movl   $0x7fe00000,-0x20(%ebp)
  801e41:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801e44:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
  801e4a:	81 ea 00 10 00 00    	sub    $0x1000,%edx
  801e50:	83 ec 04             	sub    $0x4,%esp
  801e53:	6a 06                	push   $0x6
  801e55:	50                   	push   %eax
  801e56:	52                   	push   %edx
  801e57:	e8 a1 05 00 00       	call   8023fd <sys_allocate_chunk>
  801e5c:	83 c4 10             	add    $0x10,%esp
	initialize_MemBlocksList(MAX_MEM_BLOCK_CNT);
  801e5f:	a1 20 51 80 00       	mov    0x805120,%eax
  801e64:	83 ec 0c             	sub    $0xc,%esp
  801e67:	50                   	push   %eax
  801e68:	e8 16 0c 00 00       	call   802a83 <initialize_MemBlocksList>
  801e6d:	83 c4 10             	add    $0x10,%esp
	struct MemBlock* ourBlock =LIST_LAST(&AvailableMemBlocksList);
  801e70:	a1 4c 51 80 00       	mov    0x80514c,%eax
  801e75:	89 45 dc             	mov    %eax,-0x24(%ebp)
	LIST_REMOVE(&AvailableMemBlocksList,ourBlock);
  801e78:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  801e7c:	75 14                	jne    801e92 <initialize_dyn_block_system+0xfb>
  801e7e:	83 ec 04             	sub    $0x4,%esp
  801e81:	68 15 44 80 00       	push   $0x804415
  801e86:	6a 2d                	push   $0x2d
  801e88:	68 33 44 80 00       	push   $0x804433
  801e8d:	e8 96 ee ff ff       	call   800d28 <_panic>
  801e92:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801e95:	8b 00                	mov    (%eax),%eax
  801e97:	85 c0                	test   %eax,%eax
  801e99:	74 10                	je     801eab <initialize_dyn_block_system+0x114>
  801e9b:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801e9e:	8b 00                	mov    (%eax),%eax
  801ea0:	8b 55 dc             	mov    -0x24(%ebp),%edx
  801ea3:	8b 52 04             	mov    0x4(%edx),%edx
  801ea6:	89 50 04             	mov    %edx,0x4(%eax)
  801ea9:	eb 0b                	jmp    801eb6 <initialize_dyn_block_system+0x11f>
  801eab:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801eae:	8b 40 04             	mov    0x4(%eax),%eax
  801eb1:	a3 4c 51 80 00       	mov    %eax,0x80514c
  801eb6:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801eb9:	8b 40 04             	mov    0x4(%eax),%eax
  801ebc:	85 c0                	test   %eax,%eax
  801ebe:	74 0f                	je     801ecf <initialize_dyn_block_system+0x138>
  801ec0:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801ec3:	8b 40 04             	mov    0x4(%eax),%eax
  801ec6:	8b 55 dc             	mov    -0x24(%ebp),%edx
  801ec9:	8b 12                	mov    (%edx),%edx
  801ecb:	89 10                	mov    %edx,(%eax)
  801ecd:	eb 0a                	jmp    801ed9 <initialize_dyn_block_system+0x142>
  801ecf:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801ed2:	8b 00                	mov    (%eax),%eax
  801ed4:	a3 48 51 80 00       	mov    %eax,0x805148
  801ed9:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801edc:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  801ee2:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801ee5:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  801eec:	a1 54 51 80 00       	mov    0x805154,%eax
  801ef1:	48                   	dec    %eax
  801ef2:	a3 54 51 80 00       	mov    %eax,0x805154
	ourBlock->size = USER_HEAP_MAX-USER_HEAP_START;
  801ef7:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801efa:	c7 40 0c 00 00 00 20 	movl   $0x20000000,0xc(%eax)
	ourBlock->sva=USER_HEAP_START;
  801f01:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801f04:	c7 40 08 00 00 00 80 	movl   $0x80000000,0x8(%eax)
	LIST_INSERT_TAIL(&FreeMemBlocksList, ourBlock);
  801f0b:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  801f0f:	75 14                	jne    801f25 <initialize_dyn_block_system+0x18e>
  801f11:	83 ec 04             	sub    $0x4,%esp
  801f14:	68 40 44 80 00       	push   $0x804440
  801f19:	6a 30                	push   $0x30
  801f1b:	68 33 44 80 00       	push   $0x804433
  801f20:	e8 03 ee ff ff       	call   800d28 <_panic>
  801f25:	8b 15 3c 51 80 00    	mov    0x80513c,%edx
  801f2b:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801f2e:	89 50 04             	mov    %edx,0x4(%eax)
  801f31:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801f34:	8b 40 04             	mov    0x4(%eax),%eax
  801f37:	85 c0                	test   %eax,%eax
  801f39:	74 0c                	je     801f47 <initialize_dyn_block_system+0x1b0>
  801f3b:	a1 3c 51 80 00       	mov    0x80513c,%eax
  801f40:	8b 55 dc             	mov    -0x24(%ebp),%edx
  801f43:	89 10                	mov    %edx,(%eax)
  801f45:	eb 08                	jmp    801f4f <initialize_dyn_block_system+0x1b8>
  801f47:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801f4a:	a3 38 51 80 00       	mov    %eax,0x805138
  801f4f:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801f52:	a3 3c 51 80 00       	mov    %eax,0x80513c
  801f57:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801f5a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  801f60:	a1 44 51 80 00       	mov    0x805144,%eax
  801f65:	40                   	inc    %eax
  801f66:	a3 44 51 80 00       	mov    %eax,0x805144
	//[1] Initialize two lists (AllocMemBlocksList & FreeMemBlocksList) [Hint: use LIST_INIT()]
	//[2] Dynamically allocate the array of MemBlockNodes at VA USER_DYN_BLKS_ARRAY
	//	  (remember to set MAX_MEM_BLOCK_CNT with the chosen size of the array)
	//[3] Initialize AvailableMemBlocksList by filling it with the MemBlockNodes
	//[4] Insert a new MemBlock with the heap size into the FreeMemBlocksList
}
  801f6b:	90                   	nop
  801f6c:	c9                   	leave  
  801f6d:	c3                   	ret    

00801f6e <malloc>:
//=================================
// [2] ALLOCATE SPACE IN USER HEAP:
//=================================

void* malloc(uint32 size)
{
  801f6e:	55                   	push   %ebp
  801f6f:	89 e5                	mov    %esp,%ebp
  801f71:	83 ec 18             	sub    $0x18,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801f74:	e8 ed fd ff ff       	call   801d66 <InitializeUHeap>
	if (size == 0) return NULL ;
  801f79:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801f7d:	75 07                	jne    801f86 <malloc+0x18>
  801f7f:	b8 00 00 00 00       	mov    $0x0,%eax
  801f84:	eb 67                	jmp    801fed <malloc+0x7f>

	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] malloc
	// your code is here, remove the panic and write your code
	//panic("malloc() is not implemented yet...!!");

	size = ROUNDUP(size, PAGE_SIZE);
  801f86:	c7 45 f4 00 10 00 00 	movl   $0x1000,-0xc(%ebp)
  801f8d:	8b 55 08             	mov    0x8(%ebp),%edx
  801f90:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f93:	01 d0                	add    %edx,%eax
  801f95:	48                   	dec    %eax
  801f96:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801f99:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801f9c:	ba 00 00 00 00       	mov    $0x0,%edx
  801fa1:	f7 75 f4             	divl   -0xc(%ebp)
  801fa4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801fa7:	29 d0                	sub    %edx,%eax
  801fa9:	89 45 08             	mov    %eax,0x8(%ebp)
	if(sys_isUHeapPlacementStrategyFIRSTFIT())
  801fac:	e8 1a 08 00 00       	call   8027cb <sys_isUHeapPlacementStrategyFIRSTFIT>
  801fb1:	85 c0                	test   %eax,%eax
  801fb3:	74 33                	je     801fe8 <malloc+0x7a>
	{
		struct MemBlock * myBlock = alloc_block_FF(size);
  801fb5:	83 ec 0c             	sub    $0xc,%esp
  801fb8:	ff 75 08             	pushl  0x8(%ebp)
  801fbb:	e8 0c 0e 00 00       	call   802dcc <alloc_block_FF>
  801fc0:	83 c4 10             	add    $0x10,%esp
  801fc3:	89 45 ec             	mov    %eax,-0x14(%ebp)
		if(myBlock != NULL)
  801fc6:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  801fca:	74 1c                	je     801fe8 <malloc+0x7a>
		{
			insert_sorted_allocList(myBlock);
  801fcc:	83 ec 0c             	sub    $0xc,%esp
  801fcf:	ff 75 ec             	pushl  -0x14(%ebp)
  801fd2:	e8 07 0c 00 00       	call   802bde <insert_sorted_allocList>
  801fd7:	83 c4 10             	add    $0x10,%esp
			uint32 ptr = myBlock->sva;
  801fda:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801fdd:	8b 40 08             	mov    0x8(%eax),%eax
  801fe0:	89 45 e8             	mov    %eax,-0x18(%ebp)
			return (void *)ptr;
  801fe3:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801fe6:	eb 05                	jmp    801fed <malloc+0x7f>
		}
	}
	return NULL;
  801fe8:	b8 00 00 00 00       	mov    $0x0,%eax
	//		to the required allocation size (space should be on 4 KB BOUNDARY)
	//	2) if no suitable space found, return NULL
	// 	3) Return pointer containing the virtual address of allocated space,
	//
	//Use sys_isUHeapPlacementStrategyFIRSTFIT()... to check the current strategy
}
  801fed:	c9                   	leave  
  801fee:	c3                   	ret    

00801fef <free>:
//	We can use sys_free_user_mem(uint32 virtual_address, uint32 size); which
//		switches to the kernel mode, calls free_user_mem() in
//		"kern/mem/chunk_operations.c", then switch back to the user mode here
//	the free_user_mem function is empty, make sure to implement it.
void free(void* virtual_address)
{
  801fef:	55                   	push   %ebp
  801ff0:	89 e5                	mov    %esp,%ebp
  801ff2:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] free
	// your code is here, remove the panic and write your code
	//panic("free() is not implemented yet...!!");

	uint32 virtualAddress = (uint32 )(virtual_address);
  801ff5:	8b 45 08             	mov    0x8(%ebp),%eax
  801ff8:	89 45 f4             	mov    %eax,-0xc(%ebp)
//	virtualAddress = ROUNDDOWN(virtualAddress, PAGE_SIZE);
	struct MemBlock * myBlock = find_block(&AllocMemBlocksList, virtualAddress);
  801ffb:	83 ec 08             	sub    $0x8,%esp
  801ffe:	ff 75 f4             	pushl  -0xc(%ebp)
  802001:	68 40 50 80 00       	push   $0x805040
  802006:	e8 5b 0b 00 00       	call   802b66 <find_block>
  80200b:	83 c4 10             	add    $0x10,%esp
  80200e:	89 45 f0             	mov    %eax,-0x10(%ebp)
//	cprintf ("ptr sva at free user side = %x \n", myBlock->sva);
	sys_free_user_mem(virtualAddress, myBlock->size);
  802011:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802014:	8b 40 0c             	mov    0xc(%eax),%eax
  802017:	83 ec 08             	sub    $0x8,%esp
  80201a:	50                   	push   %eax
  80201b:	ff 75 f4             	pushl  -0xc(%ebp)
  80201e:	e8 a2 03 00 00       	call   8023c5 <sys_free_user_mem>
  802023:	83 c4 10             	add    $0x10,%esp
	LIST_REMOVE(&AllocMemBlocksList, myBlock);
  802026:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80202a:	75 14                	jne    802040 <free+0x51>
  80202c:	83 ec 04             	sub    $0x4,%esp
  80202f:	68 15 44 80 00       	push   $0x804415
  802034:	6a 76                	push   $0x76
  802036:	68 33 44 80 00       	push   $0x804433
  80203b:	e8 e8 ec ff ff       	call   800d28 <_panic>
  802040:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802043:	8b 00                	mov    (%eax),%eax
  802045:	85 c0                	test   %eax,%eax
  802047:	74 10                	je     802059 <free+0x6a>
  802049:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80204c:	8b 00                	mov    (%eax),%eax
  80204e:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802051:	8b 52 04             	mov    0x4(%edx),%edx
  802054:	89 50 04             	mov    %edx,0x4(%eax)
  802057:	eb 0b                	jmp    802064 <free+0x75>
  802059:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80205c:	8b 40 04             	mov    0x4(%eax),%eax
  80205f:	a3 44 50 80 00       	mov    %eax,0x805044
  802064:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802067:	8b 40 04             	mov    0x4(%eax),%eax
  80206a:	85 c0                	test   %eax,%eax
  80206c:	74 0f                	je     80207d <free+0x8e>
  80206e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802071:	8b 40 04             	mov    0x4(%eax),%eax
  802074:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802077:	8b 12                	mov    (%edx),%edx
  802079:	89 10                	mov    %edx,(%eax)
  80207b:	eb 0a                	jmp    802087 <free+0x98>
  80207d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802080:	8b 00                	mov    (%eax),%eax
  802082:	a3 40 50 80 00       	mov    %eax,0x805040
  802087:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80208a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802090:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802093:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80209a:	a1 4c 50 80 00       	mov    0x80504c,%eax
  80209f:	48                   	dec    %eax
  8020a0:	a3 4c 50 80 00       	mov    %eax,0x80504c
	insert_sorted_with_merge_freeList(myBlock);
  8020a5:	83 ec 0c             	sub    $0xc,%esp
  8020a8:	ff 75 f0             	pushl  -0x10(%ebp)
  8020ab:	e8 0b 14 00 00       	call   8034bb <insert_sorted_with_merge_freeList>
  8020b0:	83 c4 10             	add    $0x10,%esp

	//you should get the size of the given allocation using its address
	//you need to call sys_free_user_mem()
	//refer to the project presentation and documentation for details
}
  8020b3:	90                   	nop
  8020b4:	c9                   	leave  
  8020b5:	c3                   	ret    

008020b6 <smalloc>:

//=================================
// [4] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
  8020b6:	55                   	push   %ebp
  8020b7:	89 e5                	mov    %esp,%ebp
  8020b9:	83 ec 28             	sub    $0x28,%esp
  8020bc:	8b 45 10             	mov    0x10(%ebp),%eax
  8020bf:	88 45 e4             	mov    %al,-0x1c(%ebp)
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  8020c2:	e8 9f fc ff ff       	call   801d66 <InitializeUHeap>
	if (size == 0) return NULL ;
  8020c7:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8020cb:	75 0a                	jne    8020d7 <smalloc+0x21>
  8020cd:	b8 00 00 00 00       	mov    $0x0,%eax
  8020d2:	e9 8d 00 00 00       	jmp    802164 <smalloc+0xae>

	//This function should find the space of the required range
	// * ON 4KB BOUNDARY **** //
	//Use sys_isUHeapPlacementStrategyFIRSTFIT() to check the current strategy

	size = ROUNDUP(size, PAGE_SIZE);
  8020d7:	c7 45 f4 00 10 00 00 	movl   $0x1000,-0xc(%ebp)
  8020de:	8b 55 0c             	mov    0xc(%ebp),%edx
  8020e1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020e4:	01 d0                	add    %edx,%eax
  8020e6:	48                   	dec    %eax
  8020e7:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8020ea:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8020ed:	ba 00 00 00 00       	mov    $0x0,%edx
  8020f2:	f7 75 f4             	divl   -0xc(%ebp)
  8020f5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8020f8:	29 d0                	sub    %edx,%eax
  8020fa:	89 45 0c             	mov    %eax,0xc(%ebp)
		if(sys_isUHeapPlacementStrategyFIRSTFIT())
  8020fd:	e8 c9 06 00 00       	call   8027cb <sys_isUHeapPlacementStrategyFIRSTFIT>
  802102:	85 c0                	test   %eax,%eax
  802104:	74 59                	je     80215f <smalloc+0xa9>
		{
			struct MemBlock * v1=NULL;
  802106:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
			v1= alloc_block_FF(size);
  80210d:	83 ec 0c             	sub    $0xc,%esp
  802110:	ff 75 0c             	pushl  0xc(%ebp)
  802113:	e8 b4 0c 00 00       	call   802dcc <alloc_block_FF>
  802118:	83 c4 10             	add    $0x10,%esp
  80211b:	89 45 ec             	mov    %eax,-0x14(%ebp)
			if(v1==NULL)
  80211e:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802122:	75 07                	jne    80212b <smalloc+0x75>
			{
				return NULL;
  802124:	b8 00 00 00 00       	mov    $0x0,%eax
  802129:	eb 39                	jmp    802164 <smalloc+0xae>
			}
			else
			{
				int ret=sys_createSharedObject(sharedVarName,  size,  isWritable,(void*)v1->sva);
  80212b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80212e:	8b 40 08             	mov    0x8(%eax),%eax
  802131:	89 c2                	mov    %eax,%edx
  802133:	0f b6 45 e4          	movzbl -0x1c(%ebp),%eax
  802137:	52                   	push   %edx
  802138:	50                   	push   %eax
  802139:	ff 75 0c             	pushl  0xc(%ebp)
  80213c:	ff 75 08             	pushl  0x8(%ebp)
  80213f:	e8 0c 04 00 00       	call   802550 <sys_createSharedObject>
  802144:	83 c4 10             	add    $0x10,%esp
  802147:	89 45 e8             	mov    %eax,-0x18(%ebp)
				if(ret>=0)
  80214a:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  80214e:	78 08                	js     802158 <smalloc+0xa2>
				{
					return (void*)v1->sva;
  802150:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802153:	8b 40 08             	mov    0x8(%eax),%eax
  802156:	eb 0c                	jmp    802164 <smalloc+0xae>
				}
				else
				{
					return NULL;
  802158:	b8 00 00 00 00       	mov    $0x0,%eax
  80215d:	eb 05                	jmp    802164 <smalloc+0xae>
				}
			}

		}
		return NULL;
  80215f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802164:	c9                   	leave  
  802165:	c3                   	ret    

00802166 <sget>:

//========================================
// [5] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  802166:	55                   	push   %ebp
  802167:	89 e5                	mov    %esp,%ebp
  802169:	83 ec 18             	sub    $0x18,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  80216c:	e8 f5 fb ff ff       	call   801d66 <InitializeUHeap>

	//This function should find the space for sharing the variable
	// *** ON 4KB BOUNDARY ******** //

	//Use sys_isUHeapPlacementStrategyFIRSTFIT() to check the current strategy
	int ret=sys_getSizeOfSharedObject(ownerEnvID,sharedVarName);
  802171:	83 ec 08             	sub    $0x8,%esp
  802174:	ff 75 0c             	pushl  0xc(%ebp)
  802177:	ff 75 08             	pushl  0x8(%ebp)
  80217a:	e8 fb 03 00 00       	call   80257a <sys_getSizeOfSharedObject>
  80217f:	83 c4 10             	add    $0x10,%esp
  802182:	89 45 f4             	mov    %eax,-0xc(%ebp)
	if(ret==0)
  802185:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802189:	75 07                	jne    802192 <sget+0x2c>
	{
		return NULL;
  80218b:	b8 00 00 00 00       	mov    $0x0,%eax
  802190:	eb 64                	jmp    8021f6 <sget+0x90>
	}
	if(sys_isUHeapPlacementStrategyFIRSTFIT())
  802192:	e8 34 06 00 00       	call   8027cb <sys_isUHeapPlacementStrategyFIRSTFIT>
  802197:	85 c0                	test   %eax,%eax
  802199:	74 56                	je     8021f1 <sget+0x8b>
	{
		struct MemBlock * v1=NULL;
  80219b:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
		v1= alloc_block_FF(ret);
  8021a2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021a5:	83 ec 0c             	sub    $0xc,%esp
  8021a8:	50                   	push   %eax
  8021a9:	e8 1e 0c 00 00       	call   802dcc <alloc_block_FF>
  8021ae:	83 c4 10             	add    $0x10,%esp
  8021b1:	89 45 f0             	mov    %eax,-0x10(%ebp)
		if(v1==NULL)
  8021b4:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8021b8:	75 07                	jne    8021c1 <sget+0x5b>
		{
		return NULL;
  8021ba:	b8 00 00 00 00       	mov    $0x0,%eax
  8021bf:	eb 35                	jmp    8021f6 <sget+0x90>
	    }
		else
		{
			int ret1=sys_getSharedObject(ownerEnvID,sharedVarName,(void*)v1->sva);
  8021c1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8021c4:	8b 40 08             	mov    0x8(%eax),%eax
  8021c7:	83 ec 04             	sub    $0x4,%esp
  8021ca:	50                   	push   %eax
  8021cb:	ff 75 0c             	pushl  0xc(%ebp)
  8021ce:	ff 75 08             	pushl  0x8(%ebp)
  8021d1:	e8 c1 03 00 00       	call   802597 <sys_getSharedObject>
  8021d6:	83 c4 10             	add    $0x10,%esp
  8021d9:	89 45 ec             	mov    %eax,-0x14(%ebp)
			if(ret1>=0)
  8021dc:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8021e0:	78 08                	js     8021ea <sget+0x84>
			{
				return (void*)v1->sva;
  8021e2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8021e5:	8b 40 08             	mov    0x8(%eax),%eax
  8021e8:	eb 0c                	jmp    8021f6 <sget+0x90>
			}
			else
			{
				return NULL;
  8021ea:	b8 00 00 00 00       	mov    $0x0,%eax
  8021ef:	eb 05                	jmp    8021f6 <sget+0x90>
			}
		}
	}
  return NULL;
  8021f1:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8021f6:	c9                   	leave  
  8021f7:	c3                   	ret    

008021f8 <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  8021f8:	55                   	push   %ebp
  8021f9:	89 e5                	mov    %esp,%ebp
  8021fb:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  8021fe:	e8 63 fb ff ff       	call   801d66 <InitializeUHeap>
	//==============================================================
	// [USER HEAP - USER SIDE] realloc
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  802203:	83 ec 04             	sub    $0x4,%esp
  802206:	68 64 44 80 00       	push   $0x804464
  80220b:	68 0e 01 00 00       	push   $0x10e
  802210:	68 33 44 80 00       	push   $0x804433
  802215:	e8 0e eb ff ff       	call   800d28 <_panic>

0080221a <sfree>:
//	use sys_freeSharedObject(...); which switches to the kernel mode,
//	calls freeSharedObject(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the freeSharedObject() function is empty, make sure to implement it.

void sfree(void* virtual_address)
{
  80221a:	55                   	push   %ebp
  80221b:	89 e5                	mov    %esp,%ebp
  80221d:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS3 - BONUS] [SHARING - USER SIDE] sfree()

	// Write your code here, remove the panic and write your code
	panic("sfree() is not implemented yet...!!");
  802220:	83 ec 04             	sub    $0x4,%esp
  802223:	68 8c 44 80 00       	push   $0x80448c
  802228:	68 22 01 00 00       	push   $0x122
  80222d:	68 33 44 80 00       	push   $0x804433
  802232:	e8 f1 ea ff ff       	call   800d28 <_panic>

00802237 <expand>:

//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//
void expand(uint32 newSize)
{
  802237:	55                   	push   %ebp
  802238:	89 e5                	mov    %esp,%ebp
  80223a:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  80223d:	83 ec 04             	sub    $0x4,%esp
  802240:	68 b0 44 80 00       	push   $0x8044b0
  802245:	68 2d 01 00 00       	push   $0x12d
  80224a:	68 33 44 80 00       	push   $0x804433
  80224f:	e8 d4 ea ff ff       	call   800d28 <_panic>

00802254 <shrink>:

}
void shrink(uint32 newSize)
{
  802254:	55                   	push   %ebp
  802255:	89 e5                	mov    %esp,%ebp
  802257:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  80225a:	83 ec 04             	sub    $0x4,%esp
  80225d:	68 b0 44 80 00       	push   $0x8044b0
  802262:	68 32 01 00 00       	push   $0x132
  802267:	68 33 44 80 00       	push   $0x804433
  80226c:	e8 b7 ea ff ff       	call   800d28 <_panic>

00802271 <freeHeap>:

}
void freeHeap(void* virtual_address)
{
  802271:	55                   	push   %ebp
  802272:	89 e5                	mov    %esp,%ebp
  802274:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  802277:	83 ec 04             	sub    $0x4,%esp
  80227a:	68 b0 44 80 00       	push   $0x8044b0
  80227f:	68 37 01 00 00       	push   $0x137
  802284:	68 33 44 80 00       	push   $0x804433
  802289:	e8 9a ea ff ff       	call   800d28 <_panic>

0080228e <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  80228e:	55                   	push   %ebp
  80228f:	89 e5                	mov    %esp,%ebp
  802291:	57                   	push   %edi
  802292:	56                   	push   %esi
  802293:	53                   	push   %ebx
  802294:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  802297:	8b 45 08             	mov    0x8(%ebp),%eax
  80229a:	8b 55 0c             	mov    0xc(%ebp),%edx
  80229d:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8022a0:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8022a3:	8b 7d 18             	mov    0x18(%ebp),%edi
  8022a6:	8b 75 1c             	mov    0x1c(%ebp),%esi
  8022a9:	cd 30                	int    $0x30
  8022ab:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  8022ae:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8022b1:	83 c4 10             	add    $0x10,%esp
  8022b4:	5b                   	pop    %ebx
  8022b5:	5e                   	pop    %esi
  8022b6:	5f                   	pop    %edi
  8022b7:	5d                   	pop    %ebp
  8022b8:	c3                   	ret    

008022b9 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  8022b9:	55                   	push   %ebp
  8022ba:	89 e5                	mov    %esp,%ebp
  8022bc:	83 ec 04             	sub    $0x4,%esp
  8022bf:	8b 45 10             	mov    0x10(%ebp),%eax
  8022c2:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  8022c5:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  8022c9:	8b 45 08             	mov    0x8(%ebp),%eax
  8022cc:	6a 00                	push   $0x0
  8022ce:	6a 00                	push   $0x0
  8022d0:	52                   	push   %edx
  8022d1:	ff 75 0c             	pushl  0xc(%ebp)
  8022d4:	50                   	push   %eax
  8022d5:	6a 00                	push   $0x0
  8022d7:	e8 b2 ff ff ff       	call   80228e <syscall>
  8022dc:	83 c4 18             	add    $0x18,%esp
}
  8022df:	90                   	nop
  8022e0:	c9                   	leave  
  8022e1:	c3                   	ret    

008022e2 <sys_cgetc>:

int
sys_cgetc(void)
{
  8022e2:	55                   	push   %ebp
  8022e3:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  8022e5:	6a 00                	push   $0x0
  8022e7:	6a 00                	push   $0x0
  8022e9:	6a 00                	push   $0x0
  8022eb:	6a 00                	push   $0x0
  8022ed:	6a 00                	push   $0x0
  8022ef:	6a 01                	push   $0x1
  8022f1:	e8 98 ff ff ff       	call   80228e <syscall>
  8022f6:	83 c4 18             	add    $0x18,%esp
}
  8022f9:	c9                   	leave  
  8022fa:	c3                   	ret    

008022fb <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  8022fb:	55                   	push   %ebp
  8022fc:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  8022fe:	8b 55 0c             	mov    0xc(%ebp),%edx
  802301:	8b 45 08             	mov    0x8(%ebp),%eax
  802304:	6a 00                	push   $0x0
  802306:	6a 00                	push   $0x0
  802308:	6a 00                	push   $0x0
  80230a:	52                   	push   %edx
  80230b:	50                   	push   %eax
  80230c:	6a 05                	push   $0x5
  80230e:	e8 7b ff ff ff       	call   80228e <syscall>
  802313:	83 c4 18             	add    $0x18,%esp
}
  802316:	c9                   	leave  
  802317:	c3                   	ret    

00802318 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  802318:	55                   	push   %ebp
  802319:	89 e5                	mov    %esp,%ebp
  80231b:	56                   	push   %esi
  80231c:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  80231d:	8b 75 18             	mov    0x18(%ebp),%esi
  802320:	8b 5d 14             	mov    0x14(%ebp),%ebx
  802323:	8b 4d 10             	mov    0x10(%ebp),%ecx
  802326:	8b 55 0c             	mov    0xc(%ebp),%edx
  802329:	8b 45 08             	mov    0x8(%ebp),%eax
  80232c:	56                   	push   %esi
  80232d:	53                   	push   %ebx
  80232e:	51                   	push   %ecx
  80232f:	52                   	push   %edx
  802330:	50                   	push   %eax
  802331:	6a 06                	push   $0x6
  802333:	e8 56 ff ff ff       	call   80228e <syscall>
  802338:	83 c4 18             	add    $0x18,%esp
}
  80233b:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80233e:	5b                   	pop    %ebx
  80233f:	5e                   	pop    %esi
  802340:	5d                   	pop    %ebp
  802341:	c3                   	ret    

00802342 <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  802342:	55                   	push   %ebp
  802343:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  802345:	8b 55 0c             	mov    0xc(%ebp),%edx
  802348:	8b 45 08             	mov    0x8(%ebp),%eax
  80234b:	6a 00                	push   $0x0
  80234d:	6a 00                	push   $0x0
  80234f:	6a 00                	push   $0x0
  802351:	52                   	push   %edx
  802352:	50                   	push   %eax
  802353:	6a 07                	push   $0x7
  802355:	e8 34 ff ff ff       	call   80228e <syscall>
  80235a:	83 c4 18             	add    $0x18,%esp
}
  80235d:	c9                   	leave  
  80235e:	c3                   	ret    

0080235f <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  80235f:	55                   	push   %ebp
  802360:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  802362:	6a 00                	push   $0x0
  802364:	6a 00                	push   $0x0
  802366:	6a 00                	push   $0x0
  802368:	ff 75 0c             	pushl  0xc(%ebp)
  80236b:	ff 75 08             	pushl  0x8(%ebp)
  80236e:	6a 08                	push   $0x8
  802370:	e8 19 ff ff ff       	call   80228e <syscall>
  802375:	83 c4 18             	add    $0x18,%esp
}
  802378:	c9                   	leave  
  802379:	c3                   	ret    

0080237a <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  80237a:	55                   	push   %ebp
  80237b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  80237d:	6a 00                	push   $0x0
  80237f:	6a 00                	push   $0x0
  802381:	6a 00                	push   $0x0
  802383:	6a 00                	push   $0x0
  802385:	6a 00                	push   $0x0
  802387:	6a 09                	push   $0x9
  802389:	e8 00 ff ff ff       	call   80228e <syscall>
  80238e:	83 c4 18             	add    $0x18,%esp
}
  802391:	c9                   	leave  
  802392:	c3                   	ret    

00802393 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  802393:	55                   	push   %ebp
  802394:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  802396:	6a 00                	push   $0x0
  802398:	6a 00                	push   $0x0
  80239a:	6a 00                	push   $0x0
  80239c:	6a 00                	push   $0x0
  80239e:	6a 00                	push   $0x0
  8023a0:	6a 0a                	push   $0xa
  8023a2:	e8 e7 fe ff ff       	call   80228e <syscall>
  8023a7:	83 c4 18             	add    $0x18,%esp
}
  8023aa:	c9                   	leave  
  8023ab:	c3                   	ret    

008023ac <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  8023ac:	55                   	push   %ebp
  8023ad:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  8023af:	6a 00                	push   $0x0
  8023b1:	6a 00                	push   $0x0
  8023b3:	6a 00                	push   $0x0
  8023b5:	6a 00                	push   $0x0
  8023b7:	6a 00                	push   $0x0
  8023b9:	6a 0b                	push   $0xb
  8023bb:	e8 ce fe ff ff       	call   80228e <syscall>
  8023c0:	83 c4 18             	add    $0x18,%esp
}
  8023c3:	c9                   	leave  
  8023c4:	c3                   	ret    

008023c5 <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  8023c5:	55                   	push   %ebp
  8023c6:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  8023c8:	6a 00                	push   $0x0
  8023ca:	6a 00                	push   $0x0
  8023cc:	6a 00                	push   $0x0
  8023ce:	ff 75 0c             	pushl  0xc(%ebp)
  8023d1:	ff 75 08             	pushl  0x8(%ebp)
  8023d4:	6a 0f                	push   $0xf
  8023d6:	e8 b3 fe ff ff       	call   80228e <syscall>
  8023db:	83 c4 18             	add    $0x18,%esp
	return;
  8023de:	90                   	nop
}
  8023df:	c9                   	leave  
  8023e0:	c3                   	ret    

008023e1 <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  8023e1:	55                   	push   %ebp
  8023e2:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  8023e4:	6a 00                	push   $0x0
  8023e6:	6a 00                	push   $0x0
  8023e8:	6a 00                	push   $0x0
  8023ea:	ff 75 0c             	pushl  0xc(%ebp)
  8023ed:	ff 75 08             	pushl  0x8(%ebp)
  8023f0:	6a 10                	push   $0x10
  8023f2:	e8 97 fe ff ff       	call   80228e <syscall>
  8023f7:	83 c4 18             	add    $0x18,%esp
	return ;
  8023fa:	90                   	nop
}
  8023fb:	c9                   	leave  
  8023fc:	c3                   	ret    

008023fd <sys_allocate_chunk>:

void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  8023fd:	55                   	push   %ebp
  8023fe:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  802400:	6a 00                	push   $0x0
  802402:	6a 00                	push   $0x0
  802404:	ff 75 10             	pushl  0x10(%ebp)
  802407:	ff 75 0c             	pushl  0xc(%ebp)
  80240a:	ff 75 08             	pushl  0x8(%ebp)
  80240d:	6a 11                	push   $0x11
  80240f:	e8 7a fe ff ff       	call   80228e <syscall>
  802414:	83 c4 18             	add    $0x18,%esp
	return ;
  802417:	90                   	nop
}
  802418:	c9                   	leave  
  802419:	c3                   	ret    

0080241a <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  80241a:	55                   	push   %ebp
  80241b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  80241d:	6a 00                	push   $0x0
  80241f:	6a 00                	push   $0x0
  802421:	6a 00                	push   $0x0
  802423:	6a 00                	push   $0x0
  802425:	6a 00                	push   $0x0
  802427:	6a 0c                	push   $0xc
  802429:	e8 60 fe ff ff       	call   80228e <syscall>
  80242e:	83 c4 18             	add    $0x18,%esp
}
  802431:	c9                   	leave  
  802432:	c3                   	ret    

00802433 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  802433:	55                   	push   %ebp
  802434:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  802436:	6a 00                	push   $0x0
  802438:	6a 00                	push   $0x0
  80243a:	6a 00                	push   $0x0
  80243c:	6a 00                	push   $0x0
  80243e:	ff 75 08             	pushl  0x8(%ebp)
  802441:	6a 0d                	push   $0xd
  802443:	e8 46 fe ff ff       	call   80228e <syscall>
  802448:	83 c4 18             	add    $0x18,%esp
}
  80244b:	c9                   	leave  
  80244c:	c3                   	ret    

0080244d <sys_scarce_memory>:

void sys_scarce_memory()
{
  80244d:	55                   	push   %ebp
  80244e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  802450:	6a 00                	push   $0x0
  802452:	6a 00                	push   $0x0
  802454:	6a 00                	push   $0x0
  802456:	6a 00                	push   $0x0
  802458:	6a 00                	push   $0x0
  80245a:	6a 0e                	push   $0xe
  80245c:	e8 2d fe ff ff       	call   80228e <syscall>
  802461:	83 c4 18             	add    $0x18,%esp
}
  802464:	90                   	nop
  802465:	c9                   	leave  
  802466:	c3                   	ret    

00802467 <sys_disable_interrupt>:

//NEW !! 2012...
void
sys_disable_interrupt()
{
  802467:	55                   	push   %ebp
  802468:	89 e5                	mov    %esp,%ebp
	syscall(SYS_disableINTR,0, 0, 0, 0, 0);
  80246a:	6a 00                	push   $0x0
  80246c:	6a 00                	push   $0x0
  80246e:	6a 00                	push   $0x0
  802470:	6a 00                	push   $0x0
  802472:	6a 00                	push   $0x0
  802474:	6a 13                	push   $0x13
  802476:	e8 13 fe ff ff       	call   80228e <syscall>
  80247b:	83 c4 18             	add    $0x18,%esp
}
  80247e:	90                   	nop
  80247f:	c9                   	leave  
  802480:	c3                   	ret    

00802481 <sys_enable_interrupt>:


void
sys_enable_interrupt()
{
  802481:	55                   	push   %ebp
  802482:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enableINTR,0, 0, 0, 0, 0);
  802484:	6a 00                	push   $0x0
  802486:	6a 00                	push   $0x0
  802488:	6a 00                	push   $0x0
  80248a:	6a 00                	push   $0x0
  80248c:	6a 00                	push   $0x0
  80248e:	6a 14                	push   $0x14
  802490:	e8 f9 fd ff ff       	call   80228e <syscall>
  802495:	83 c4 18             	add    $0x18,%esp
}
  802498:	90                   	nop
  802499:	c9                   	leave  
  80249a:	c3                   	ret    

0080249b <sys_cputc>:


void
sys_cputc(const char c)
{
  80249b:	55                   	push   %ebp
  80249c:	89 e5                	mov    %esp,%ebp
  80249e:	83 ec 04             	sub    $0x4,%esp
  8024a1:	8b 45 08             	mov    0x8(%ebp),%eax
  8024a4:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  8024a7:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  8024ab:	6a 00                	push   $0x0
  8024ad:	6a 00                	push   $0x0
  8024af:	6a 00                	push   $0x0
  8024b1:	6a 00                	push   $0x0
  8024b3:	50                   	push   %eax
  8024b4:	6a 15                	push   $0x15
  8024b6:	e8 d3 fd ff ff       	call   80228e <syscall>
  8024bb:	83 c4 18             	add    $0x18,%esp
}
  8024be:	90                   	nop
  8024bf:	c9                   	leave  
  8024c0:	c3                   	ret    

008024c1 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  8024c1:	55                   	push   %ebp
  8024c2:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  8024c4:	6a 00                	push   $0x0
  8024c6:	6a 00                	push   $0x0
  8024c8:	6a 00                	push   $0x0
  8024ca:	6a 00                	push   $0x0
  8024cc:	6a 00                	push   $0x0
  8024ce:	6a 16                	push   $0x16
  8024d0:	e8 b9 fd ff ff       	call   80228e <syscall>
  8024d5:	83 c4 18             	add    $0x18,%esp
}
  8024d8:	90                   	nop
  8024d9:	c9                   	leave  
  8024da:	c3                   	ret    

008024db <sys_createSemaphore>:

int
sys_createSemaphore(char* semaphoreName, uint32 initialValue)
{
  8024db:	55                   	push   %ebp
  8024dc:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_semaphore,(uint32)semaphoreName, (uint32)initialValue, 0, 0, 0);
  8024de:	8b 45 08             	mov    0x8(%ebp),%eax
  8024e1:	6a 00                	push   $0x0
  8024e3:	6a 00                	push   $0x0
  8024e5:	6a 00                	push   $0x0
  8024e7:	ff 75 0c             	pushl  0xc(%ebp)
  8024ea:	50                   	push   %eax
  8024eb:	6a 17                	push   $0x17
  8024ed:	e8 9c fd ff ff       	call   80228e <syscall>
  8024f2:	83 c4 18             	add    $0x18,%esp
}
  8024f5:	c9                   	leave  
  8024f6:	c3                   	ret    

008024f7 <sys_getSemaphoreValue>:

int
sys_getSemaphoreValue(int32 ownerEnvID, char* semaphoreName)
{
  8024f7:	55                   	push   %ebp
  8024f8:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_semaphore_value,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  8024fa:	8b 55 0c             	mov    0xc(%ebp),%edx
  8024fd:	8b 45 08             	mov    0x8(%ebp),%eax
  802500:	6a 00                	push   $0x0
  802502:	6a 00                	push   $0x0
  802504:	6a 00                	push   $0x0
  802506:	52                   	push   %edx
  802507:	50                   	push   %eax
  802508:	6a 1a                	push   $0x1a
  80250a:	e8 7f fd ff ff       	call   80228e <syscall>
  80250f:	83 c4 18             	add    $0x18,%esp
}
  802512:	c9                   	leave  
  802513:	c3                   	ret    

00802514 <sys_waitSemaphore>:

void
sys_waitSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  802514:	55                   	push   %ebp
  802515:	89 e5                	mov    %esp,%ebp
	syscall(SYS_wait_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  802517:	8b 55 0c             	mov    0xc(%ebp),%edx
  80251a:	8b 45 08             	mov    0x8(%ebp),%eax
  80251d:	6a 00                	push   $0x0
  80251f:	6a 00                	push   $0x0
  802521:	6a 00                	push   $0x0
  802523:	52                   	push   %edx
  802524:	50                   	push   %eax
  802525:	6a 18                	push   $0x18
  802527:	e8 62 fd ff ff       	call   80228e <syscall>
  80252c:	83 c4 18             	add    $0x18,%esp
}
  80252f:	90                   	nop
  802530:	c9                   	leave  
  802531:	c3                   	ret    

00802532 <sys_signalSemaphore>:

void
sys_signalSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  802532:	55                   	push   %ebp
  802533:	89 e5                	mov    %esp,%ebp
	syscall(SYS_signal_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  802535:	8b 55 0c             	mov    0xc(%ebp),%edx
  802538:	8b 45 08             	mov    0x8(%ebp),%eax
  80253b:	6a 00                	push   $0x0
  80253d:	6a 00                	push   $0x0
  80253f:	6a 00                	push   $0x0
  802541:	52                   	push   %edx
  802542:	50                   	push   %eax
  802543:	6a 19                	push   $0x19
  802545:	e8 44 fd ff ff       	call   80228e <syscall>
  80254a:	83 c4 18             	add    $0x18,%esp
}
  80254d:	90                   	nop
  80254e:	c9                   	leave  
  80254f:	c3                   	ret    

00802550 <sys_createSharedObject>:

int
sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  802550:	55                   	push   %ebp
  802551:	89 e5                	mov    %esp,%ebp
  802553:	83 ec 04             	sub    $0x4,%esp
  802556:	8b 45 10             	mov    0x10(%ebp),%eax
  802559:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  80255c:	8b 4d 14             	mov    0x14(%ebp),%ecx
  80255f:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  802563:	8b 45 08             	mov    0x8(%ebp),%eax
  802566:	6a 00                	push   $0x0
  802568:	51                   	push   %ecx
  802569:	52                   	push   %edx
  80256a:	ff 75 0c             	pushl  0xc(%ebp)
  80256d:	50                   	push   %eax
  80256e:	6a 1b                	push   $0x1b
  802570:	e8 19 fd ff ff       	call   80228e <syscall>
  802575:	83 c4 18             	add    $0x18,%esp
}
  802578:	c9                   	leave  
  802579:	c3                   	ret    

0080257a <sys_getSizeOfSharedObject>:

//2017:
int
sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  80257a:	55                   	push   %ebp
  80257b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  80257d:	8b 55 0c             	mov    0xc(%ebp),%edx
  802580:	8b 45 08             	mov    0x8(%ebp),%eax
  802583:	6a 00                	push   $0x0
  802585:	6a 00                	push   $0x0
  802587:	6a 00                	push   $0x0
  802589:	52                   	push   %edx
  80258a:	50                   	push   %eax
  80258b:	6a 1c                	push   $0x1c
  80258d:	e8 fc fc ff ff       	call   80228e <syscall>
  802592:	83 c4 18             	add    $0x18,%esp
}
  802595:	c9                   	leave  
  802596:	c3                   	ret    

00802597 <sys_getSharedObject>:
//==========

int
sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  802597:	55                   	push   %ebp
  802598:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  80259a:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80259d:	8b 55 0c             	mov    0xc(%ebp),%edx
  8025a0:	8b 45 08             	mov    0x8(%ebp),%eax
  8025a3:	6a 00                	push   $0x0
  8025a5:	6a 00                	push   $0x0
  8025a7:	51                   	push   %ecx
  8025a8:	52                   	push   %edx
  8025a9:	50                   	push   %eax
  8025aa:	6a 1d                	push   $0x1d
  8025ac:	e8 dd fc ff ff       	call   80228e <syscall>
  8025b1:	83 c4 18             	add    $0x18,%esp
}
  8025b4:	c9                   	leave  
  8025b5:	c3                   	ret    

008025b6 <sys_freeSharedObject>:

int
sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  8025b6:	55                   	push   %ebp
  8025b7:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  8025b9:	8b 55 0c             	mov    0xc(%ebp),%edx
  8025bc:	8b 45 08             	mov    0x8(%ebp),%eax
  8025bf:	6a 00                	push   $0x0
  8025c1:	6a 00                	push   $0x0
  8025c3:	6a 00                	push   $0x0
  8025c5:	52                   	push   %edx
  8025c6:	50                   	push   %eax
  8025c7:	6a 1e                	push   $0x1e
  8025c9:	e8 c0 fc ff ff       	call   80228e <syscall>
  8025ce:	83 c4 18             	add    $0x18,%esp
}
  8025d1:	c9                   	leave  
  8025d2:	c3                   	ret    

008025d3 <sys_getMaxShares>:

uint32 	sys_getMaxShares()
{
  8025d3:	55                   	push   %ebp
  8025d4:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_max_shares,0, 0, 0, 0, 0);
  8025d6:	6a 00                	push   $0x0
  8025d8:	6a 00                	push   $0x0
  8025da:	6a 00                	push   $0x0
  8025dc:	6a 00                	push   $0x0
  8025de:	6a 00                	push   $0x0
  8025e0:	6a 1f                	push   $0x1f
  8025e2:	e8 a7 fc ff ff       	call   80228e <syscall>
  8025e7:	83 c4 18             	add    $0x18,%esp
}
  8025ea:	c9                   	leave  
  8025eb:	c3                   	ret    

008025ec <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  8025ec:	55                   	push   %ebp
  8025ed:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  8025ef:	8b 45 08             	mov    0x8(%ebp),%eax
  8025f2:	6a 00                	push   $0x0
  8025f4:	ff 75 14             	pushl  0x14(%ebp)
  8025f7:	ff 75 10             	pushl  0x10(%ebp)
  8025fa:	ff 75 0c             	pushl  0xc(%ebp)
  8025fd:	50                   	push   %eax
  8025fe:	6a 20                	push   $0x20
  802600:	e8 89 fc ff ff       	call   80228e <syscall>
  802605:	83 c4 18             	add    $0x18,%esp
}
  802608:	c9                   	leave  
  802609:	c3                   	ret    

0080260a <sys_run_env>:

void
sys_run_env(int32 envId)
{
  80260a:	55                   	push   %ebp
  80260b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  80260d:	8b 45 08             	mov    0x8(%ebp),%eax
  802610:	6a 00                	push   $0x0
  802612:	6a 00                	push   $0x0
  802614:	6a 00                	push   $0x0
  802616:	6a 00                	push   $0x0
  802618:	50                   	push   %eax
  802619:	6a 21                	push   $0x21
  80261b:	e8 6e fc ff ff       	call   80228e <syscall>
  802620:	83 c4 18             	add    $0x18,%esp
}
  802623:	90                   	nop
  802624:	c9                   	leave  
  802625:	c3                   	ret    

00802626 <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  802626:	55                   	push   %ebp
  802627:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  802629:	8b 45 08             	mov    0x8(%ebp),%eax
  80262c:	6a 00                	push   $0x0
  80262e:	6a 00                	push   $0x0
  802630:	6a 00                	push   $0x0
  802632:	6a 00                	push   $0x0
  802634:	50                   	push   %eax
  802635:	6a 22                	push   $0x22
  802637:	e8 52 fc ff ff       	call   80228e <syscall>
  80263c:	83 c4 18             	add    $0x18,%esp
}
  80263f:	c9                   	leave  
  802640:	c3                   	ret    

00802641 <sys_getenvid>:

int32 sys_getenvid(void)
{
  802641:	55                   	push   %ebp
  802642:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  802644:	6a 00                	push   $0x0
  802646:	6a 00                	push   $0x0
  802648:	6a 00                	push   $0x0
  80264a:	6a 00                	push   $0x0
  80264c:	6a 00                	push   $0x0
  80264e:	6a 02                	push   $0x2
  802650:	e8 39 fc ff ff       	call   80228e <syscall>
  802655:	83 c4 18             	add    $0x18,%esp
}
  802658:	c9                   	leave  
  802659:	c3                   	ret    

0080265a <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  80265a:	55                   	push   %ebp
  80265b:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  80265d:	6a 00                	push   $0x0
  80265f:	6a 00                	push   $0x0
  802661:	6a 00                	push   $0x0
  802663:	6a 00                	push   $0x0
  802665:	6a 00                	push   $0x0
  802667:	6a 03                	push   $0x3
  802669:	e8 20 fc ff ff       	call   80228e <syscall>
  80266e:	83 c4 18             	add    $0x18,%esp
}
  802671:	c9                   	leave  
  802672:	c3                   	ret    

00802673 <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  802673:	55                   	push   %ebp
  802674:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  802676:	6a 00                	push   $0x0
  802678:	6a 00                	push   $0x0
  80267a:	6a 00                	push   $0x0
  80267c:	6a 00                	push   $0x0
  80267e:	6a 00                	push   $0x0
  802680:	6a 04                	push   $0x4
  802682:	e8 07 fc ff ff       	call   80228e <syscall>
  802687:	83 c4 18             	add    $0x18,%esp
}
  80268a:	c9                   	leave  
  80268b:	c3                   	ret    

0080268c <sys_exit_env>:


void sys_exit_env(void)
{
  80268c:	55                   	push   %ebp
  80268d:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  80268f:	6a 00                	push   $0x0
  802691:	6a 00                	push   $0x0
  802693:	6a 00                	push   $0x0
  802695:	6a 00                	push   $0x0
  802697:	6a 00                	push   $0x0
  802699:	6a 23                	push   $0x23
  80269b:	e8 ee fb ff ff       	call   80228e <syscall>
  8026a0:	83 c4 18             	add    $0x18,%esp
}
  8026a3:	90                   	nop
  8026a4:	c9                   	leave  
  8026a5:	c3                   	ret    

008026a6 <sys_get_virtual_time>:


struct uint64
sys_get_virtual_time()
{
  8026a6:	55                   	push   %ebp
  8026a7:	89 e5                	mov    %esp,%ebp
  8026a9:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  8026ac:	8d 45 f8             	lea    -0x8(%ebp),%eax
  8026af:	8d 50 04             	lea    0x4(%eax),%edx
  8026b2:	8d 45 f8             	lea    -0x8(%ebp),%eax
  8026b5:	6a 00                	push   $0x0
  8026b7:	6a 00                	push   $0x0
  8026b9:	6a 00                	push   $0x0
  8026bb:	52                   	push   %edx
  8026bc:	50                   	push   %eax
  8026bd:	6a 24                	push   $0x24
  8026bf:	e8 ca fb ff ff       	call   80228e <syscall>
  8026c4:	83 c4 18             	add    $0x18,%esp
	return result;
  8026c7:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8026ca:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8026cd:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8026d0:	89 01                	mov    %eax,(%ecx)
  8026d2:	89 51 04             	mov    %edx,0x4(%ecx)
}
  8026d5:	8b 45 08             	mov    0x8(%ebp),%eax
  8026d8:	c9                   	leave  
  8026d9:	c2 04 00             	ret    $0x4

008026dc <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  8026dc:	55                   	push   %ebp
  8026dd:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  8026df:	6a 00                	push   $0x0
  8026e1:	6a 00                	push   $0x0
  8026e3:	ff 75 10             	pushl  0x10(%ebp)
  8026e6:	ff 75 0c             	pushl  0xc(%ebp)
  8026e9:	ff 75 08             	pushl  0x8(%ebp)
  8026ec:	6a 12                	push   $0x12
  8026ee:	e8 9b fb ff ff       	call   80228e <syscall>
  8026f3:	83 c4 18             	add    $0x18,%esp
	return ;
  8026f6:	90                   	nop
}
  8026f7:	c9                   	leave  
  8026f8:	c3                   	ret    

008026f9 <sys_rcr2>:
uint32 sys_rcr2()
{
  8026f9:	55                   	push   %ebp
  8026fa:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  8026fc:	6a 00                	push   $0x0
  8026fe:	6a 00                	push   $0x0
  802700:	6a 00                	push   $0x0
  802702:	6a 00                	push   $0x0
  802704:	6a 00                	push   $0x0
  802706:	6a 25                	push   $0x25
  802708:	e8 81 fb ff ff       	call   80228e <syscall>
  80270d:	83 c4 18             	add    $0x18,%esp
}
  802710:	c9                   	leave  
  802711:	c3                   	ret    

00802712 <sys_bypassPageFault>:
void sys_bypassPageFault(uint8 instrLength)
{
  802712:	55                   	push   %ebp
  802713:	89 e5                	mov    %esp,%ebp
  802715:	83 ec 04             	sub    $0x4,%esp
  802718:	8b 45 08             	mov    0x8(%ebp),%eax
  80271b:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  80271e:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  802722:	6a 00                	push   $0x0
  802724:	6a 00                	push   $0x0
  802726:	6a 00                	push   $0x0
  802728:	6a 00                	push   $0x0
  80272a:	50                   	push   %eax
  80272b:	6a 26                	push   $0x26
  80272d:	e8 5c fb ff ff       	call   80228e <syscall>
  802732:	83 c4 18             	add    $0x18,%esp
	return ;
  802735:	90                   	nop
}
  802736:	c9                   	leave  
  802737:	c3                   	ret    

00802738 <rsttst>:
void rsttst()
{
  802738:	55                   	push   %ebp
  802739:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  80273b:	6a 00                	push   $0x0
  80273d:	6a 00                	push   $0x0
  80273f:	6a 00                	push   $0x0
  802741:	6a 00                	push   $0x0
  802743:	6a 00                	push   $0x0
  802745:	6a 28                	push   $0x28
  802747:	e8 42 fb ff ff       	call   80228e <syscall>
  80274c:	83 c4 18             	add    $0x18,%esp
	return ;
  80274f:	90                   	nop
}
  802750:	c9                   	leave  
  802751:	c3                   	ret    

00802752 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  802752:	55                   	push   %ebp
  802753:	89 e5                	mov    %esp,%ebp
  802755:	83 ec 04             	sub    $0x4,%esp
  802758:	8b 45 14             	mov    0x14(%ebp),%eax
  80275b:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  80275e:	8b 55 18             	mov    0x18(%ebp),%edx
  802761:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  802765:	52                   	push   %edx
  802766:	50                   	push   %eax
  802767:	ff 75 10             	pushl  0x10(%ebp)
  80276a:	ff 75 0c             	pushl  0xc(%ebp)
  80276d:	ff 75 08             	pushl  0x8(%ebp)
  802770:	6a 27                	push   $0x27
  802772:	e8 17 fb ff ff       	call   80228e <syscall>
  802777:	83 c4 18             	add    $0x18,%esp
	return ;
  80277a:	90                   	nop
}
  80277b:	c9                   	leave  
  80277c:	c3                   	ret    

0080277d <chktst>:
void chktst(uint32 n)
{
  80277d:	55                   	push   %ebp
  80277e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  802780:	6a 00                	push   $0x0
  802782:	6a 00                	push   $0x0
  802784:	6a 00                	push   $0x0
  802786:	6a 00                	push   $0x0
  802788:	ff 75 08             	pushl  0x8(%ebp)
  80278b:	6a 29                	push   $0x29
  80278d:	e8 fc fa ff ff       	call   80228e <syscall>
  802792:	83 c4 18             	add    $0x18,%esp
	return ;
  802795:	90                   	nop
}
  802796:	c9                   	leave  
  802797:	c3                   	ret    

00802798 <inctst>:

void inctst()
{
  802798:	55                   	push   %ebp
  802799:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  80279b:	6a 00                	push   $0x0
  80279d:	6a 00                	push   $0x0
  80279f:	6a 00                	push   $0x0
  8027a1:	6a 00                	push   $0x0
  8027a3:	6a 00                	push   $0x0
  8027a5:	6a 2a                	push   $0x2a
  8027a7:	e8 e2 fa ff ff       	call   80228e <syscall>
  8027ac:	83 c4 18             	add    $0x18,%esp
	return ;
  8027af:	90                   	nop
}
  8027b0:	c9                   	leave  
  8027b1:	c3                   	ret    

008027b2 <gettst>:
uint32 gettst()
{
  8027b2:	55                   	push   %ebp
  8027b3:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  8027b5:	6a 00                	push   $0x0
  8027b7:	6a 00                	push   $0x0
  8027b9:	6a 00                	push   $0x0
  8027bb:	6a 00                	push   $0x0
  8027bd:	6a 00                	push   $0x0
  8027bf:	6a 2b                	push   $0x2b
  8027c1:	e8 c8 fa ff ff       	call   80228e <syscall>
  8027c6:	83 c4 18             	add    $0x18,%esp
}
  8027c9:	c9                   	leave  
  8027ca:	c3                   	ret    

008027cb <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  8027cb:	55                   	push   %ebp
  8027cc:	89 e5                	mov    %esp,%ebp
  8027ce:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8027d1:	6a 00                	push   $0x0
  8027d3:	6a 00                	push   $0x0
  8027d5:	6a 00                	push   $0x0
  8027d7:	6a 00                	push   $0x0
  8027d9:	6a 00                	push   $0x0
  8027db:	6a 2c                	push   $0x2c
  8027dd:	e8 ac fa ff ff       	call   80228e <syscall>
  8027e2:	83 c4 18             	add    $0x18,%esp
  8027e5:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  8027e8:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  8027ec:	75 07                	jne    8027f5 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  8027ee:	b8 01 00 00 00       	mov    $0x1,%eax
  8027f3:	eb 05                	jmp    8027fa <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  8027f5:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8027fa:	c9                   	leave  
  8027fb:	c3                   	ret    

008027fc <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  8027fc:	55                   	push   %ebp
  8027fd:	89 e5                	mov    %esp,%ebp
  8027ff:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  802802:	6a 00                	push   $0x0
  802804:	6a 00                	push   $0x0
  802806:	6a 00                	push   $0x0
  802808:	6a 00                	push   $0x0
  80280a:	6a 00                	push   $0x0
  80280c:	6a 2c                	push   $0x2c
  80280e:	e8 7b fa ff ff       	call   80228e <syscall>
  802813:	83 c4 18             	add    $0x18,%esp
  802816:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  802819:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  80281d:	75 07                	jne    802826 <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  80281f:	b8 01 00 00 00       	mov    $0x1,%eax
  802824:	eb 05                	jmp    80282b <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  802826:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80282b:	c9                   	leave  
  80282c:	c3                   	ret    

0080282d <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  80282d:	55                   	push   %ebp
  80282e:	89 e5                	mov    %esp,%ebp
  802830:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  802833:	6a 00                	push   $0x0
  802835:	6a 00                	push   $0x0
  802837:	6a 00                	push   $0x0
  802839:	6a 00                	push   $0x0
  80283b:	6a 00                	push   $0x0
  80283d:	6a 2c                	push   $0x2c
  80283f:	e8 4a fa ff ff       	call   80228e <syscall>
  802844:	83 c4 18             	add    $0x18,%esp
  802847:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  80284a:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  80284e:	75 07                	jne    802857 <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  802850:	b8 01 00 00 00       	mov    $0x1,%eax
  802855:	eb 05                	jmp    80285c <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  802857:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80285c:	c9                   	leave  
  80285d:	c3                   	ret    

0080285e <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  80285e:	55                   	push   %ebp
  80285f:	89 e5                	mov    %esp,%ebp
  802861:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  802864:	6a 00                	push   $0x0
  802866:	6a 00                	push   $0x0
  802868:	6a 00                	push   $0x0
  80286a:	6a 00                	push   $0x0
  80286c:	6a 00                	push   $0x0
  80286e:	6a 2c                	push   $0x2c
  802870:	e8 19 fa ff ff       	call   80228e <syscall>
  802875:	83 c4 18             	add    $0x18,%esp
  802878:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  80287b:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  80287f:	75 07                	jne    802888 <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  802881:	b8 01 00 00 00       	mov    $0x1,%eax
  802886:	eb 05                	jmp    80288d <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  802888:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80288d:	c9                   	leave  
  80288e:	c3                   	ret    

0080288f <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  80288f:	55                   	push   %ebp
  802890:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  802892:	6a 00                	push   $0x0
  802894:	6a 00                	push   $0x0
  802896:	6a 00                	push   $0x0
  802898:	6a 00                	push   $0x0
  80289a:	ff 75 08             	pushl  0x8(%ebp)
  80289d:	6a 2d                	push   $0x2d
  80289f:	e8 ea f9 ff ff       	call   80228e <syscall>
  8028a4:	83 c4 18             	add    $0x18,%esp
	return ;
  8028a7:	90                   	nop
}
  8028a8:	c9                   	leave  
  8028a9:	c3                   	ret    

008028aa <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  8028aa:	55                   	push   %ebp
  8028ab:	89 e5                	mov    %esp,%ebp
  8028ad:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  8028ae:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8028b1:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8028b4:	8b 55 0c             	mov    0xc(%ebp),%edx
  8028b7:	8b 45 08             	mov    0x8(%ebp),%eax
  8028ba:	6a 00                	push   $0x0
  8028bc:	53                   	push   %ebx
  8028bd:	51                   	push   %ecx
  8028be:	52                   	push   %edx
  8028bf:	50                   	push   %eax
  8028c0:	6a 2e                	push   $0x2e
  8028c2:	e8 c7 f9 ff ff       	call   80228e <syscall>
  8028c7:	83 c4 18             	add    $0x18,%esp
}
  8028ca:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8028cd:	c9                   	leave  
  8028ce:	c3                   	ret    

008028cf <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  8028cf:	55                   	push   %ebp
  8028d0:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  8028d2:	8b 55 0c             	mov    0xc(%ebp),%edx
  8028d5:	8b 45 08             	mov    0x8(%ebp),%eax
  8028d8:	6a 00                	push   $0x0
  8028da:	6a 00                	push   $0x0
  8028dc:	6a 00                	push   $0x0
  8028de:	52                   	push   %edx
  8028df:	50                   	push   %eax
  8028e0:	6a 2f                	push   $0x2f
  8028e2:	e8 a7 f9 ff ff       	call   80228e <syscall>
  8028e7:	83 c4 18             	add    $0x18,%esp
}
  8028ea:	c9                   	leave  
  8028eb:	c3                   	ret    

008028ec <print_mem_block_lists>:
//===========================
// PRINT MEM BLOCK LISTS:
//===========================

void print_mem_block_lists()
{
  8028ec:	55                   	push   %ebp
  8028ed:	89 e5                	mov    %esp,%ebp
  8028ef:	83 ec 18             	sub    $0x18,%esp
	cprintf("\n=========================================\n");
  8028f2:	83 ec 0c             	sub    $0xc,%esp
  8028f5:	68 c0 44 80 00       	push   $0x8044c0
  8028fa:	e8 dd e6 ff ff       	call   800fdc <cprintf>
  8028ff:	83 c4 10             	add    $0x10,%esp
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
  802902:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nFreeMemBlocksList:\n");
  802909:	83 ec 0c             	sub    $0xc,%esp
  80290c:	68 ec 44 80 00       	push   $0x8044ec
  802911:	e8 c6 e6 ff ff       	call   800fdc <cprintf>
  802916:	83 c4 10             	add    $0x10,%esp
	uint8 sorted = 1 ;
  802919:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &FreeMemBlocksList)
  80291d:	a1 38 51 80 00       	mov    0x805138,%eax
  802922:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802925:	eb 56                	jmp    80297d <print_mem_block_lists+0x91>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  802927:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80292b:	74 1c                	je     802949 <print_mem_block_lists+0x5d>
  80292d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802930:	8b 50 08             	mov    0x8(%eax),%edx
  802933:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802936:	8b 48 08             	mov    0x8(%eax),%ecx
  802939:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80293c:	8b 40 0c             	mov    0xc(%eax),%eax
  80293f:	01 c8                	add    %ecx,%eax
  802941:	39 c2                	cmp    %eax,%edx
  802943:	73 04                	jae    802949 <print_mem_block_lists+0x5d>
			sorted = 0 ;
  802945:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  802949:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80294c:	8b 50 08             	mov    0x8(%eax),%edx
  80294f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802952:	8b 40 0c             	mov    0xc(%eax),%eax
  802955:	01 c2                	add    %eax,%edx
  802957:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80295a:	8b 40 08             	mov    0x8(%eax),%eax
  80295d:	83 ec 04             	sub    $0x4,%esp
  802960:	52                   	push   %edx
  802961:	50                   	push   %eax
  802962:	68 01 45 80 00       	push   $0x804501
  802967:	e8 70 e6 ff ff       	call   800fdc <cprintf>
  80296c:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  80296f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802972:	89 45 f0             	mov    %eax,-0x10(%ebp)
	cprintf("\n=========================================\n");
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
	cprintf("\nFreeMemBlocksList:\n");
	uint8 sorted = 1 ;
	LIST_FOREACH(blk, &FreeMemBlocksList)
  802975:	a1 40 51 80 00       	mov    0x805140,%eax
  80297a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80297d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802981:	74 07                	je     80298a <print_mem_block_lists+0x9e>
  802983:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802986:	8b 00                	mov    (%eax),%eax
  802988:	eb 05                	jmp    80298f <print_mem_block_lists+0xa3>
  80298a:	b8 00 00 00 00       	mov    $0x0,%eax
  80298f:	a3 40 51 80 00       	mov    %eax,0x805140
  802994:	a1 40 51 80 00       	mov    0x805140,%eax
  802999:	85 c0                	test   %eax,%eax
  80299b:	75 8a                	jne    802927 <print_mem_block_lists+0x3b>
  80299d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8029a1:	75 84                	jne    802927 <print_mem_block_lists+0x3b>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;
  8029a3:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  8029a7:	75 10                	jne    8029b9 <print_mem_block_lists+0xcd>
  8029a9:	83 ec 0c             	sub    $0xc,%esp
  8029ac:	68 10 45 80 00       	push   $0x804510
  8029b1:	e8 26 e6 ff ff       	call   800fdc <cprintf>
  8029b6:	83 c4 10             	add    $0x10,%esp

	lastBlk = NULL ;
  8029b9:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nAllocMemBlocksList:\n");
  8029c0:	83 ec 0c             	sub    $0xc,%esp
  8029c3:	68 34 45 80 00       	push   $0x804534
  8029c8:	e8 0f e6 ff ff       	call   800fdc <cprintf>
  8029cd:	83 c4 10             	add    $0x10,%esp
	sorted = 1 ;
  8029d0:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &AllocMemBlocksList)
  8029d4:	a1 40 50 80 00       	mov    0x805040,%eax
  8029d9:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8029dc:	eb 56                	jmp    802a34 <print_mem_block_lists+0x148>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  8029de:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8029e2:	74 1c                	je     802a00 <print_mem_block_lists+0x114>
  8029e4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029e7:	8b 50 08             	mov    0x8(%eax),%edx
  8029ea:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8029ed:	8b 48 08             	mov    0x8(%eax),%ecx
  8029f0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8029f3:	8b 40 0c             	mov    0xc(%eax),%eax
  8029f6:	01 c8                	add    %ecx,%eax
  8029f8:	39 c2                	cmp    %eax,%edx
  8029fa:	73 04                	jae    802a00 <print_mem_block_lists+0x114>
			sorted = 0 ;
  8029fc:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  802a00:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a03:	8b 50 08             	mov    0x8(%eax),%edx
  802a06:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a09:	8b 40 0c             	mov    0xc(%eax),%eax
  802a0c:	01 c2                	add    %eax,%edx
  802a0e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a11:	8b 40 08             	mov    0x8(%eax),%eax
  802a14:	83 ec 04             	sub    $0x4,%esp
  802a17:	52                   	push   %edx
  802a18:	50                   	push   %eax
  802a19:	68 01 45 80 00       	push   $0x804501
  802a1e:	e8 b9 e5 ff ff       	call   800fdc <cprintf>
  802a23:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  802a26:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a29:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;

	lastBlk = NULL ;
	cprintf("\nAllocMemBlocksList:\n");
	sorted = 1 ;
	LIST_FOREACH(blk, &AllocMemBlocksList)
  802a2c:	a1 48 50 80 00       	mov    0x805048,%eax
  802a31:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802a34:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802a38:	74 07                	je     802a41 <print_mem_block_lists+0x155>
  802a3a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a3d:	8b 00                	mov    (%eax),%eax
  802a3f:	eb 05                	jmp    802a46 <print_mem_block_lists+0x15a>
  802a41:	b8 00 00 00 00       	mov    $0x0,%eax
  802a46:	a3 48 50 80 00       	mov    %eax,0x805048
  802a4b:	a1 48 50 80 00       	mov    0x805048,%eax
  802a50:	85 c0                	test   %eax,%eax
  802a52:	75 8a                	jne    8029de <print_mem_block_lists+0xf2>
  802a54:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802a58:	75 84                	jne    8029de <print_mem_block_lists+0xf2>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nAllocMemBlocksList is NOT SORTED!!\n") ;
  802a5a:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  802a5e:	75 10                	jne    802a70 <print_mem_block_lists+0x184>
  802a60:	83 ec 0c             	sub    $0xc,%esp
  802a63:	68 4c 45 80 00       	push   $0x80454c
  802a68:	e8 6f e5 ff ff       	call   800fdc <cprintf>
  802a6d:	83 c4 10             	add    $0x10,%esp
	cprintf("\n=========================================\n");
  802a70:	83 ec 0c             	sub    $0xc,%esp
  802a73:	68 c0 44 80 00       	push   $0x8044c0
  802a78:	e8 5f e5 ff ff       	call   800fdc <cprintf>
  802a7d:	83 c4 10             	add    $0x10,%esp

}
  802a80:	90                   	nop
  802a81:	c9                   	leave  
  802a82:	c3                   	ret    

00802a83 <initialize_MemBlocksList>:

//===============================
// [1] INITIALIZE AVAILABLE LIST:
//===============================
void initialize_MemBlocksList(uint32 numOfBlocks)
{
  802a83:	55                   	push   %ebp
  802a84:	89 e5                	mov    %esp,%ebp
  802a86:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] initialize_MemBlocksList
	// Write your code here, remove the panic and write your code
	//panic("initialize_MemBlocksList() is not implemented yet...!!");
	uint32 n = numOfBlocks;
  802a89:	8b 45 08             	mov    0x8(%ebp),%eax
  802a8c:	89 45 f0             	mov    %eax,-0x10(%ebp)

	LIST_INIT(&AvailableMemBlocksList);
  802a8f:	c7 05 48 51 80 00 00 	movl   $0x0,0x805148
  802a96:	00 00 00 
  802a99:	c7 05 4c 51 80 00 00 	movl   $0x0,0x80514c
  802aa0:	00 00 00 
  802aa3:	c7 05 54 51 80 00 00 	movl   $0x0,0x805154
  802aaa:	00 00 00 
	for(int i = 0; i<n;i++)
  802aad:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  802ab4:	e9 9e 00 00 00       	jmp    802b57 <initialize_MemBlocksList+0xd4>
	{
		LIST_INSERT_HEAD(&AvailableMemBlocksList, &(MemBlockNodes[i]));
  802ab9:	a1 50 50 80 00       	mov    0x805050,%eax
  802abe:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802ac1:	c1 e2 04             	shl    $0x4,%edx
  802ac4:	01 d0                	add    %edx,%eax
  802ac6:	85 c0                	test   %eax,%eax
  802ac8:	75 14                	jne    802ade <initialize_MemBlocksList+0x5b>
  802aca:	83 ec 04             	sub    $0x4,%esp
  802acd:	68 74 45 80 00       	push   $0x804574
  802ad2:	6a 47                	push   $0x47
  802ad4:	68 97 45 80 00       	push   $0x804597
  802ad9:	e8 4a e2 ff ff       	call   800d28 <_panic>
  802ade:	a1 50 50 80 00       	mov    0x805050,%eax
  802ae3:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802ae6:	c1 e2 04             	shl    $0x4,%edx
  802ae9:	01 d0                	add    %edx,%eax
  802aeb:	8b 15 48 51 80 00    	mov    0x805148,%edx
  802af1:	89 10                	mov    %edx,(%eax)
  802af3:	8b 00                	mov    (%eax),%eax
  802af5:	85 c0                	test   %eax,%eax
  802af7:	74 18                	je     802b11 <initialize_MemBlocksList+0x8e>
  802af9:	a1 48 51 80 00       	mov    0x805148,%eax
  802afe:	8b 15 50 50 80 00    	mov    0x805050,%edx
  802b04:	8b 4d f4             	mov    -0xc(%ebp),%ecx
  802b07:	c1 e1 04             	shl    $0x4,%ecx
  802b0a:	01 ca                	add    %ecx,%edx
  802b0c:	89 50 04             	mov    %edx,0x4(%eax)
  802b0f:	eb 12                	jmp    802b23 <initialize_MemBlocksList+0xa0>
  802b11:	a1 50 50 80 00       	mov    0x805050,%eax
  802b16:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802b19:	c1 e2 04             	shl    $0x4,%edx
  802b1c:	01 d0                	add    %edx,%eax
  802b1e:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802b23:	a1 50 50 80 00       	mov    0x805050,%eax
  802b28:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802b2b:	c1 e2 04             	shl    $0x4,%edx
  802b2e:	01 d0                	add    %edx,%eax
  802b30:	a3 48 51 80 00       	mov    %eax,0x805148
  802b35:	a1 50 50 80 00       	mov    0x805050,%eax
  802b3a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802b3d:	c1 e2 04             	shl    $0x4,%edx
  802b40:	01 d0                	add    %edx,%eax
  802b42:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802b49:	a1 54 51 80 00       	mov    0x805154,%eax
  802b4e:	40                   	inc    %eax
  802b4f:	a3 54 51 80 00       	mov    %eax,0x805154
	// Write your code here, remove the panic and write your code
	//panic("initialize_MemBlocksList() is not implemented yet...!!");
	uint32 n = numOfBlocks;

	LIST_INIT(&AvailableMemBlocksList);
	for(int i = 0; i<n;i++)
  802b54:	ff 45 f4             	incl   -0xc(%ebp)
  802b57:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b5a:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  802b5d:	0f 82 56 ff ff ff    	jb     802ab9 <initialize_MemBlocksList+0x36>
	{
		LIST_INSERT_HEAD(&AvailableMemBlocksList, &(MemBlockNodes[i]));
	}
}
  802b63:	90                   	nop
  802b64:	c9                   	leave  
  802b65:	c3                   	ret    

00802b66 <find_block>:

//===============================
// [2] FIND BLOCK:
//===============================
struct MemBlock *find_block(struct MemBlock_List *blockList, uint32 va)
{
  802b66:	55                   	push   %ebp
  802b67:	89 e5                	mov    %esp,%ebp
  802b69:	83 ec 10             	sub    $0x10,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] find_block
	// Write your code here, remove the panic and write your code
	//panic("find_block() is not implemented yet...!!");
	uint32 virAddress = va;
  802b6c:	8b 45 0c             	mov    0xc(%ebp),%eax
  802b6f:	89 45 f4             	mov    %eax,-0xc(%ebp)
	struct MemBlock* blk;
	int found = 0;
  802b72:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	LIST_FOREACH(blk, &(AllocMemBlocksList))
  802b79:	a1 40 50 80 00       	mov    0x805040,%eax
  802b7e:	89 45 fc             	mov    %eax,-0x4(%ebp)
  802b81:	eb 23                	jmp    802ba6 <find_block+0x40>
	{
		if(blk->sva == virAddress)
  802b83:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802b86:	8b 40 08             	mov    0x8(%eax),%eax
  802b89:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  802b8c:	75 09                	jne    802b97 <find_block+0x31>
		{
			found = 1;
  802b8e:	c7 45 f8 01 00 00 00 	movl   $0x1,-0x8(%ebp)
			break;
  802b95:	eb 35                	jmp    802bcc <find_block+0x66>
		}
		else
		{
			found = 0;
  802b97:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	//panic("find_block() is not implemented yet...!!");
	uint32 virAddress = va;
	struct MemBlock* blk;
	int found = 0;

	LIST_FOREACH(blk, &(AllocMemBlocksList))
  802b9e:	a1 48 50 80 00       	mov    0x805048,%eax
  802ba3:	89 45 fc             	mov    %eax,-0x4(%ebp)
  802ba6:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  802baa:	74 07                	je     802bb3 <find_block+0x4d>
  802bac:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802baf:	8b 00                	mov    (%eax),%eax
  802bb1:	eb 05                	jmp    802bb8 <find_block+0x52>
  802bb3:	b8 00 00 00 00       	mov    $0x0,%eax
  802bb8:	a3 48 50 80 00       	mov    %eax,0x805048
  802bbd:	a1 48 50 80 00       	mov    0x805048,%eax
  802bc2:	85 c0                	test   %eax,%eax
  802bc4:	75 bd                	jne    802b83 <find_block+0x1d>
  802bc6:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  802bca:	75 b7                	jne    802b83 <find_block+0x1d>
		{
			found = 0;
			continue;
		}
	}
	if(found == 1)
  802bcc:	83 7d f8 01          	cmpl   $0x1,-0x8(%ebp)
  802bd0:	75 05                	jne    802bd7 <find_block+0x71>
	{
		return blk;
  802bd2:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802bd5:	eb 05                	jmp    802bdc <find_block+0x76>
	}
	else
	{
		return NULL;
  802bd7:	b8 00 00 00 00       	mov    $0x0,%eax
	}
}
  802bdc:	c9                   	leave  
  802bdd:	c3                   	ret    

00802bde <insert_sorted_allocList>:

//=========================================
// [3] INSERT BLOCK IN ALLOC LIST [SORTED]:
//=========================================
void insert_sorted_allocList(struct MemBlock *blockToInsert)
{
  802bde:	55                   	push   %ebp
  802bdf:	89 e5                	mov    %esp,%ebp
  802be1:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] insert_sorted_allocList
	// Write your code here, remove the panic and write your code
	//panic("insert_sorted_allocList() is not implemented yet...!!");
	struct MemBlock* blk;
	struct MemBlock* newblk = blockToInsert;
  802be4:	8b 45 08             	mov    0x8(%ebp),%eax
  802be7:	89 45 f0             	mov    %eax,-0x10(%ebp)

	if((LIST_EMPTY(&AllocMemBlocksList)) || (newblk->sva < LIST_FIRST(&AllocMemBlocksList)->sva))
  802bea:	a1 40 50 80 00       	mov    0x805040,%eax
  802bef:	85 c0                	test   %eax,%eax
  802bf1:	74 12                	je     802c05 <insert_sorted_allocList+0x27>
  802bf3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802bf6:	8b 50 08             	mov    0x8(%eax),%edx
  802bf9:	a1 40 50 80 00       	mov    0x805040,%eax
  802bfe:	8b 40 08             	mov    0x8(%eax),%eax
  802c01:	39 c2                	cmp    %eax,%edx
  802c03:	73 65                	jae    802c6a <insert_sorted_allocList+0x8c>
	{
		LIST_INSERT_HEAD(&(AllocMemBlocksList), newblk);
  802c05:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802c09:	75 14                	jne    802c1f <insert_sorted_allocList+0x41>
  802c0b:	83 ec 04             	sub    $0x4,%esp
  802c0e:	68 74 45 80 00       	push   $0x804574
  802c13:	6a 7b                	push   $0x7b
  802c15:	68 97 45 80 00       	push   $0x804597
  802c1a:	e8 09 e1 ff ff       	call   800d28 <_panic>
  802c1f:	8b 15 40 50 80 00    	mov    0x805040,%edx
  802c25:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c28:	89 10                	mov    %edx,(%eax)
  802c2a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c2d:	8b 00                	mov    (%eax),%eax
  802c2f:	85 c0                	test   %eax,%eax
  802c31:	74 0d                	je     802c40 <insert_sorted_allocList+0x62>
  802c33:	a1 40 50 80 00       	mov    0x805040,%eax
  802c38:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802c3b:	89 50 04             	mov    %edx,0x4(%eax)
  802c3e:	eb 08                	jmp    802c48 <insert_sorted_allocList+0x6a>
  802c40:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c43:	a3 44 50 80 00       	mov    %eax,0x805044
  802c48:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c4b:	a3 40 50 80 00       	mov    %eax,0x805040
  802c50:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c53:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802c5a:	a1 4c 50 80 00       	mov    0x80504c,%eax
  802c5f:	40                   	inc    %eax
  802c60:	a3 4c 50 80 00       	mov    %eax,0x80504c
  802c65:	e9 5f 01 00 00       	jmp    802dc9 <insert_sorted_allocList+0x1eb>
	}
	else if(newblk->sva > LIST_LAST(&AllocMemBlocksList)->sva)
  802c6a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c6d:	8b 50 08             	mov    0x8(%eax),%edx
  802c70:	a1 44 50 80 00       	mov    0x805044,%eax
  802c75:	8b 40 08             	mov    0x8(%eax),%eax
  802c78:	39 c2                	cmp    %eax,%edx
  802c7a:	76 65                	jbe    802ce1 <insert_sorted_allocList+0x103>
	{
		LIST_INSERT_TAIL(&AllocMemBlocksList, newblk);
  802c7c:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802c80:	75 14                	jne    802c96 <insert_sorted_allocList+0xb8>
  802c82:	83 ec 04             	sub    $0x4,%esp
  802c85:	68 b0 45 80 00       	push   $0x8045b0
  802c8a:	6a 7f                	push   $0x7f
  802c8c:	68 97 45 80 00       	push   $0x804597
  802c91:	e8 92 e0 ff ff       	call   800d28 <_panic>
  802c96:	8b 15 44 50 80 00    	mov    0x805044,%edx
  802c9c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c9f:	89 50 04             	mov    %edx,0x4(%eax)
  802ca2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ca5:	8b 40 04             	mov    0x4(%eax),%eax
  802ca8:	85 c0                	test   %eax,%eax
  802caa:	74 0c                	je     802cb8 <insert_sorted_allocList+0xda>
  802cac:	a1 44 50 80 00       	mov    0x805044,%eax
  802cb1:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802cb4:	89 10                	mov    %edx,(%eax)
  802cb6:	eb 08                	jmp    802cc0 <insert_sorted_allocList+0xe2>
  802cb8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802cbb:	a3 40 50 80 00       	mov    %eax,0x805040
  802cc0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802cc3:	a3 44 50 80 00       	mov    %eax,0x805044
  802cc8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ccb:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802cd1:	a1 4c 50 80 00       	mov    0x80504c,%eax
  802cd6:	40                   	inc    %eax
  802cd7:	a3 4c 50 80 00       	mov    %eax,0x80504c
				LIST_INSERT_AFTER(&AllocMemBlocksList, blk, newblk);
				break;
			}
		}
	}
}
  802cdc:	e9 e8 00 00 00       	jmp    802dc9 <insert_sorted_allocList+0x1eb>
	{
		LIST_INSERT_TAIL(&AllocMemBlocksList, newblk);
	}
	else
	{
		LIST_FOREACH(blk, &AllocMemBlocksList)
  802ce1:	a1 40 50 80 00       	mov    0x805040,%eax
  802ce6:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802ce9:	e9 ab 00 00 00       	jmp    802d99 <insert_sorted_allocList+0x1bb>
		{
			if(blk->prev_next_info.le_next != NULL && newblk->sva > blk->sva  && newblk->sva < blk->prev_next_info.le_next->sva)
  802cee:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cf1:	8b 00                	mov    (%eax),%eax
  802cf3:	85 c0                	test   %eax,%eax
  802cf5:	0f 84 96 00 00 00    	je     802d91 <insert_sorted_allocList+0x1b3>
  802cfb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802cfe:	8b 50 08             	mov    0x8(%eax),%edx
  802d01:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d04:	8b 40 08             	mov    0x8(%eax),%eax
  802d07:	39 c2                	cmp    %eax,%edx
  802d09:	0f 86 82 00 00 00    	jbe    802d91 <insert_sorted_allocList+0x1b3>
  802d0f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d12:	8b 50 08             	mov    0x8(%eax),%edx
  802d15:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d18:	8b 00                	mov    (%eax),%eax
  802d1a:	8b 40 08             	mov    0x8(%eax),%eax
  802d1d:	39 c2                	cmp    %eax,%edx
  802d1f:	73 70                	jae    802d91 <insert_sorted_allocList+0x1b3>
			{
				LIST_INSERT_AFTER(&AllocMemBlocksList, blk, newblk);
  802d21:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802d25:	74 06                	je     802d2d <insert_sorted_allocList+0x14f>
  802d27:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802d2b:	75 17                	jne    802d44 <insert_sorted_allocList+0x166>
  802d2d:	83 ec 04             	sub    $0x4,%esp
  802d30:	68 d4 45 80 00       	push   $0x8045d4
  802d35:	68 87 00 00 00       	push   $0x87
  802d3a:	68 97 45 80 00       	push   $0x804597
  802d3f:	e8 e4 df ff ff       	call   800d28 <_panic>
  802d44:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d47:	8b 10                	mov    (%eax),%edx
  802d49:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d4c:	89 10                	mov    %edx,(%eax)
  802d4e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d51:	8b 00                	mov    (%eax),%eax
  802d53:	85 c0                	test   %eax,%eax
  802d55:	74 0b                	je     802d62 <insert_sorted_allocList+0x184>
  802d57:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d5a:	8b 00                	mov    (%eax),%eax
  802d5c:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802d5f:	89 50 04             	mov    %edx,0x4(%eax)
  802d62:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d65:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802d68:	89 10                	mov    %edx,(%eax)
  802d6a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d6d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802d70:	89 50 04             	mov    %edx,0x4(%eax)
  802d73:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d76:	8b 00                	mov    (%eax),%eax
  802d78:	85 c0                	test   %eax,%eax
  802d7a:	75 08                	jne    802d84 <insert_sorted_allocList+0x1a6>
  802d7c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d7f:	a3 44 50 80 00       	mov    %eax,0x805044
  802d84:	a1 4c 50 80 00       	mov    0x80504c,%eax
  802d89:	40                   	inc    %eax
  802d8a:	a3 4c 50 80 00       	mov    %eax,0x80504c
				break;
  802d8f:	eb 38                	jmp    802dc9 <insert_sorted_allocList+0x1eb>
	{
		LIST_INSERT_TAIL(&AllocMemBlocksList, newblk);
	}
	else
	{
		LIST_FOREACH(blk, &AllocMemBlocksList)
  802d91:	a1 48 50 80 00       	mov    0x805048,%eax
  802d96:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802d99:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802d9d:	74 07                	je     802da6 <insert_sorted_allocList+0x1c8>
  802d9f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802da2:	8b 00                	mov    (%eax),%eax
  802da4:	eb 05                	jmp    802dab <insert_sorted_allocList+0x1cd>
  802da6:	b8 00 00 00 00       	mov    $0x0,%eax
  802dab:	a3 48 50 80 00       	mov    %eax,0x805048
  802db0:	a1 48 50 80 00       	mov    0x805048,%eax
  802db5:	85 c0                	test   %eax,%eax
  802db7:	0f 85 31 ff ff ff    	jne    802cee <insert_sorted_allocList+0x110>
  802dbd:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802dc1:	0f 85 27 ff ff ff    	jne    802cee <insert_sorted_allocList+0x110>
				LIST_INSERT_AFTER(&AllocMemBlocksList, blk, newblk);
				break;
			}
		}
	}
}
  802dc7:	eb 00                	jmp    802dc9 <insert_sorted_allocList+0x1eb>
  802dc9:	90                   	nop
  802dca:	c9                   	leave  
  802dcb:	c3                   	ret    

00802dcc <alloc_block_FF>:

//=========================================
// [4] ALLOCATE BLOCK BY FIRST FIT:
//=========================================
struct MemBlock *alloc_block_FF(uint32 size)
{
  802dcc:	55                   	push   %ebp
  802dcd:	89 e5                	mov    %esp,%ebp
  802dcf:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_FF
	// Write your code here, remove the panic and write your code
	//panic("alloc_block_FF() is not implemented yet...!!");
	uint32 versize = size;
  802dd2:	8b 45 08             	mov    0x8(%ebp),%eax
  802dd5:	89 45 f0             	mov    %eax,-0x10(%ebp)
	struct MemBlock* blk;
	struct MemBlock* newblk = LIST_FIRST(&AvailableMemBlocksList);
  802dd8:	a1 48 51 80 00       	mov    0x805148,%eax
  802ddd:	89 45 ec             	mov    %eax,-0x14(%ebp)

	LIST_FOREACH(blk,&FreeMemBlocksList)
  802de0:	a1 38 51 80 00       	mov    0x805138,%eax
  802de5:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802de8:	e9 77 01 00 00       	jmp    802f64 <alloc_block_FF+0x198>
	{
		if(blk->size == versize)
  802ded:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802df0:	8b 40 0c             	mov    0xc(%eax),%eax
  802df3:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  802df6:	0f 85 8a 00 00 00    	jne    802e86 <alloc_block_FF+0xba>
		{
			LIST_REMOVE(&FreeMemBlocksList,blk);
  802dfc:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802e00:	75 17                	jne    802e19 <alloc_block_FF+0x4d>
  802e02:	83 ec 04             	sub    $0x4,%esp
  802e05:	68 08 46 80 00       	push   $0x804608
  802e0a:	68 9e 00 00 00       	push   $0x9e
  802e0f:	68 97 45 80 00       	push   $0x804597
  802e14:	e8 0f df ff ff       	call   800d28 <_panic>
  802e19:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e1c:	8b 00                	mov    (%eax),%eax
  802e1e:	85 c0                	test   %eax,%eax
  802e20:	74 10                	je     802e32 <alloc_block_FF+0x66>
  802e22:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e25:	8b 00                	mov    (%eax),%eax
  802e27:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802e2a:	8b 52 04             	mov    0x4(%edx),%edx
  802e2d:	89 50 04             	mov    %edx,0x4(%eax)
  802e30:	eb 0b                	jmp    802e3d <alloc_block_FF+0x71>
  802e32:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e35:	8b 40 04             	mov    0x4(%eax),%eax
  802e38:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802e3d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e40:	8b 40 04             	mov    0x4(%eax),%eax
  802e43:	85 c0                	test   %eax,%eax
  802e45:	74 0f                	je     802e56 <alloc_block_FF+0x8a>
  802e47:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e4a:	8b 40 04             	mov    0x4(%eax),%eax
  802e4d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802e50:	8b 12                	mov    (%edx),%edx
  802e52:	89 10                	mov    %edx,(%eax)
  802e54:	eb 0a                	jmp    802e60 <alloc_block_FF+0x94>
  802e56:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e59:	8b 00                	mov    (%eax),%eax
  802e5b:	a3 38 51 80 00       	mov    %eax,0x805138
  802e60:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e63:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802e69:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e6c:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802e73:	a1 44 51 80 00       	mov    0x805144,%eax
  802e78:	48                   	dec    %eax
  802e79:	a3 44 51 80 00       	mov    %eax,0x805144
			return blk;
  802e7e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e81:	e9 11 01 00 00       	jmp    802f97 <alloc_block_FF+0x1cb>
		}
		else if(blk->size > versize)
  802e86:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e89:	8b 40 0c             	mov    0xc(%eax),%eax
  802e8c:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  802e8f:	0f 86 c7 00 00 00    	jbe    802f5c <alloc_block_FF+0x190>
		{
			LIST_REMOVE(&AvailableMemBlocksList,newblk);
  802e95:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802e99:	75 17                	jne    802eb2 <alloc_block_FF+0xe6>
  802e9b:	83 ec 04             	sub    $0x4,%esp
  802e9e:	68 08 46 80 00       	push   $0x804608
  802ea3:	68 a3 00 00 00       	push   $0xa3
  802ea8:	68 97 45 80 00       	push   $0x804597
  802ead:	e8 76 de ff ff       	call   800d28 <_panic>
  802eb2:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802eb5:	8b 00                	mov    (%eax),%eax
  802eb7:	85 c0                	test   %eax,%eax
  802eb9:	74 10                	je     802ecb <alloc_block_FF+0xff>
  802ebb:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802ebe:	8b 00                	mov    (%eax),%eax
  802ec0:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802ec3:	8b 52 04             	mov    0x4(%edx),%edx
  802ec6:	89 50 04             	mov    %edx,0x4(%eax)
  802ec9:	eb 0b                	jmp    802ed6 <alloc_block_FF+0x10a>
  802ecb:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802ece:	8b 40 04             	mov    0x4(%eax),%eax
  802ed1:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802ed6:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802ed9:	8b 40 04             	mov    0x4(%eax),%eax
  802edc:	85 c0                	test   %eax,%eax
  802ede:	74 0f                	je     802eef <alloc_block_FF+0x123>
  802ee0:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802ee3:	8b 40 04             	mov    0x4(%eax),%eax
  802ee6:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802ee9:	8b 12                	mov    (%edx),%edx
  802eeb:	89 10                	mov    %edx,(%eax)
  802eed:	eb 0a                	jmp    802ef9 <alloc_block_FF+0x12d>
  802eef:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802ef2:	8b 00                	mov    (%eax),%eax
  802ef4:	a3 48 51 80 00       	mov    %eax,0x805148
  802ef9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802efc:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802f02:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802f05:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802f0c:	a1 54 51 80 00       	mov    0x805154,%eax
  802f11:	48                   	dec    %eax
  802f12:	a3 54 51 80 00       	mov    %eax,0x805154
			newblk->size = versize;
  802f17:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802f1a:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802f1d:	89 50 0c             	mov    %edx,0xc(%eax)
			blk->size = blk->size-versize;
  802f20:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f23:	8b 40 0c             	mov    0xc(%eax),%eax
  802f26:	2b 45 f0             	sub    -0x10(%ebp),%eax
  802f29:	89 c2                	mov    %eax,%edx
  802f2b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f2e:	89 50 0c             	mov    %edx,0xc(%eax)
			uint32 newveradd = blk->sva;
  802f31:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f34:	8b 40 08             	mov    0x8(%eax),%eax
  802f37:	89 45 e8             	mov    %eax,-0x18(%ebp)
			blk->sva+=newblk->size;
  802f3a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f3d:	8b 50 08             	mov    0x8(%eax),%edx
  802f40:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802f43:	8b 40 0c             	mov    0xc(%eax),%eax
  802f46:	01 c2                	add    %eax,%edx
  802f48:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f4b:	89 50 08             	mov    %edx,0x8(%eax)
			newblk->sva = newveradd;
  802f4e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802f51:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802f54:	89 50 08             	mov    %edx,0x8(%eax)
			return newblk;
  802f57:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802f5a:	eb 3b                	jmp    802f97 <alloc_block_FF+0x1cb>
	//panic("alloc_block_FF() is not implemented yet...!!");
	uint32 versize = size;
	struct MemBlock* blk;
	struct MemBlock* newblk = LIST_FIRST(&AvailableMemBlocksList);

	LIST_FOREACH(blk,&FreeMemBlocksList)
  802f5c:	a1 40 51 80 00       	mov    0x805140,%eax
  802f61:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802f64:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802f68:	74 07                	je     802f71 <alloc_block_FF+0x1a5>
  802f6a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f6d:	8b 00                	mov    (%eax),%eax
  802f6f:	eb 05                	jmp    802f76 <alloc_block_FF+0x1aa>
  802f71:	b8 00 00 00 00       	mov    $0x0,%eax
  802f76:	a3 40 51 80 00       	mov    %eax,0x805140
  802f7b:	a1 40 51 80 00       	mov    0x805140,%eax
  802f80:	85 c0                	test   %eax,%eax
  802f82:	0f 85 65 fe ff ff    	jne    802ded <alloc_block_FF+0x21>
  802f88:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802f8c:	0f 85 5b fe ff ff    	jne    802ded <alloc_block_FF+0x21>
			blk->sva+=newblk->size;
			newblk->sva = newveradd;
			return newblk;
		}
	}
	return NULL;
  802f92:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802f97:	c9                   	leave  
  802f98:	c3                   	ret    

00802f99 <alloc_block_BF>:

//=========================================
// [5] ALLOCATE BLOCK BY BEST FIT:
//=========================================
struct MemBlock *alloc_block_BF(uint32 size)
{
  802f99:	55                   	push   %ebp
  802f9a:	89 e5                	mov    %esp,%ebp
  802f9c:	83 ec 28             	sub    $0x28,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_BF
	// Write your code here, remove the panic and write your code
	//panic("alloc_block_BF() is not implemented yet...!!");
	uint32 versize=size;
  802f9f:	8b 45 08             	mov    0x8(%ebp),%eax
  802fa2:	89 45 e8             	mov    %eax,-0x18(%ebp)
	struct MemBlock* blk;
	struct MemBlock* newblk=LIST_FIRST(&AvailableMemBlocksList);
  802fa5:	a1 48 51 80 00       	mov    0x805148,%eax
  802faa:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	uint32 newveradd;
	uint32 newsize;
	int size_free = LIST_SIZE(&FreeMemBlocksList);
  802fad:	a1 44 51 80 00       	mov    0x805144,%eax
  802fb2:	89 45 e0             	mov    %eax,-0x20(%ebp)

	LIST_FOREACH(blk, &FreeMemBlocksList)
  802fb5:	a1 38 51 80 00       	mov    0x805138,%eax
  802fba:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802fbd:	e9 a1 00 00 00       	jmp    803063 <alloc_block_BF+0xca>
	{
		if(blk->size == versize)
  802fc2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802fc5:	8b 40 0c             	mov    0xc(%eax),%eax
  802fc8:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  802fcb:	0f 85 8a 00 00 00    	jne    80305b <alloc_block_BF+0xc2>
		{
			LIST_REMOVE(&FreeMemBlocksList, blk);
  802fd1:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802fd5:	75 17                	jne    802fee <alloc_block_BF+0x55>
  802fd7:	83 ec 04             	sub    $0x4,%esp
  802fda:	68 08 46 80 00       	push   $0x804608
  802fdf:	68 c2 00 00 00       	push   $0xc2
  802fe4:	68 97 45 80 00       	push   $0x804597
  802fe9:	e8 3a dd ff ff       	call   800d28 <_panic>
  802fee:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ff1:	8b 00                	mov    (%eax),%eax
  802ff3:	85 c0                	test   %eax,%eax
  802ff5:	74 10                	je     803007 <alloc_block_BF+0x6e>
  802ff7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ffa:	8b 00                	mov    (%eax),%eax
  802ffc:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802fff:	8b 52 04             	mov    0x4(%edx),%edx
  803002:	89 50 04             	mov    %edx,0x4(%eax)
  803005:	eb 0b                	jmp    803012 <alloc_block_BF+0x79>
  803007:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80300a:	8b 40 04             	mov    0x4(%eax),%eax
  80300d:	a3 3c 51 80 00       	mov    %eax,0x80513c
  803012:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803015:	8b 40 04             	mov    0x4(%eax),%eax
  803018:	85 c0                	test   %eax,%eax
  80301a:	74 0f                	je     80302b <alloc_block_BF+0x92>
  80301c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80301f:	8b 40 04             	mov    0x4(%eax),%eax
  803022:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803025:	8b 12                	mov    (%edx),%edx
  803027:	89 10                	mov    %edx,(%eax)
  803029:	eb 0a                	jmp    803035 <alloc_block_BF+0x9c>
  80302b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80302e:	8b 00                	mov    (%eax),%eax
  803030:	a3 38 51 80 00       	mov    %eax,0x805138
  803035:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803038:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80303e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803041:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803048:	a1 44 51 80 00       	mov    0x805144,%eax
  80304d:	48                   	dec    %eax
  80304e:	a3 44 51 80 00       	mov    %eax,0x805144
			return blk;
  803053:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803056:	e9 11 02 00 00       	jmp    80326c <alloc_block_BF+0x2d3>
	struct MemBlock* newblk=LIST_FIRST(&AvailableMemBlocksList);
	uint32 newveradd;
	uint32 newsize;
	int size_free = LIST_SIZE(&FreeMemBlocksList);

	LIST_FOREACH(blk, &FreeMemBlocksList)
  80305b:	a1 40 51 80 00       	mov    0x805140,%eax
  803060:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803063:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803067:	74 07                	je     803070 <alloc_block_BF+0xd7>
  803069:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80306c:	8b 00                	mov    (%eax),%eax
  80306e:	eb 05                	jmp    803075 <alloc_block_BF+0xdc>
  803070:	b8 00 00 00 00       	mov    $0x0,%eax
  803075:	a3 40 51 80 00       	mov    %eax,0x805140
  80307a:	a1 40 51 80 00       	mov    0x805140,%eax
  80307f:	85 c0                	test   %eax,%eax
  803081:	0f 85 3b ff ff ff    	jne    802fc2 <alloc_block_BF+0x29>
  803087:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80308b:	0f 85 31 ff ff ff    	jne    802fc2 <alloc_block_BF+0x29>
		{
			LIST_REMOVE(&FreeMemBlocksList, blk);
			return blk;
		}
	}
	LIST_FOREACH(blk, &FreeMemBlocksList)
  803091:	a1 38 51 80 00       	mov    0x805138,%eax
  803096:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803099:	eb 27                	jmp    8030c2 <alloc_block_BF+0x129>
	{
		if(blk->size > versize)
  80309b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80309e:	8b 40 0c             	mov    0xc(%eax),%eax
  8030a1:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  8030a4:	76 14                	jbe    8030ba <alloc_block_BF+0x121>
		{
			newsize = blk->size;
  8030a6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030a9:	8b 40 0c             	mov    0xc(%eax),%eax
  8030ac:	89 45 ec             	mov    %eax,-0x14(%ebp)
			newveradd = blk->sva;
  8030af:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030b2:	8b 40 08             	mov    0x8(%eax),%eax
  8030b5:	89 45 f0             	mov    %eax,-0x10(%ebp)
			break;
  8030b8:	eb 2e                	jmp    8030e8 <alloc_block_BF+0x14f>
		{
			LIST_REMOVE(&FreeMemBlocksList, blk);
			return blk;
		}
	}
	LIST_FOREACH(blk, &FreeMemBlocksList)
  8030ba:	a1 40 51 80 00       	mov    0x805140,%eax
  8030bf:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8030c2:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8030c6:	74 07                	je     8030cf <alloc_block_BF+0x136>
  8030c8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030cb:	8b 00                	mov    (%eax),%eax
  8030cd:	eb 05                	jmp    8030d4 <alloc_block_BF+0x13b>
  8030cf:	b8 00 00 00 00       	mov    $0x0,%eax
  8030d4:	a3 40 51 80 00       	mov    %eax,0x805140
  8030d9:	a1 40 51 80 00       	mov    0x805140,%eax
  8030de:	85 c0                	test   %eax,%eax
  8030e0:	75 b9                	jne    80309b <alloc_block_BF+0x102>
  8030e2:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8030e6:	75 b3                	jne    80309b <alloc_block_BF+0x102>
			newsize = blk->size;
			newveradd = blk->sva;
			break;
		}
	}
	LIST_FOREACH(blk, &FreeMemBlocksList)
  8030e8:	a1 38 51 80 00       	mov    0x805138,%eax
  8030ed:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8030f0:	eb 30                	jmp    803122 <alloc_block_BF+0x189>
	{
		if(newsize > blk->size && blk->size > versize)
  8030f2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030f5:	8b 40 0c             	mov    0xc(%eax),%eax
  8030f8:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  8030fb:	73 1d                	jae    80311a <alloc_block_BF+0x181>
  8030fd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803100:	8b 40 0c             	mov    0xc(%eax),%eax
  803103:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  803106:	76 12                	jbe    80311a <alloc_block_BF+0x181>
		{
	       newsize = blk->size;
  803108:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80310b:	8b 40 0c             	mov    0xc(%eax),%eax
  80310e:	89 45 ec             	mov    %eax,-0x14(%ebp)
		   newveradd = blk->sva;
  803111:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803114:	8b 40 08             	mov    0x8(%eax),%eax
  803117:	89 45 f0             	mov    %eax,-0x10(%ebp)
			newsize = blk->size;
			newveradd = blk->sva;
			break;
		}
	}
	LIST_FOREACH(blk, &FreeMemBlocksList)
  80311a:	a1 40 51 80 00       	mov    0x805140,%eax
  80311f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803122:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803126:	74 07                	je     80312f <alloc_block_BF+0x196>
  803128:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80312b:	8b 00                	mov    (%eax),%eax
  80312d:	eb 05                	jmp    803134 <alloc_block_BF+0x19b>
  80312f:	b8 00 00 00 00       	mov    $0x0,%eax
  803134:	a3 40 51 80 00       	mov    %eax,0x805140
  803139:	a1 40 51 80 00       	mov    0x805140,%eax
  80313e:	85 c0                	test   %eax,%eax
  803140:	75 b0                	jne    8030f2 <alloc_block_BF+0x159>
  803142:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803146:	75 aa                	jne    8030f2 <alloc_block_BF+0x159>
		{
	       newsize = blk->size;
		   newveradd = blk->sva;
		}
	}
	LIST_FOREACH(blk, &FreeMemBlocksList)
  803148:	a1 38 51 80 00       	mov    0x805138,%eax
  80314d:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803150:	e9 e4 00 00 00       	jmp    803239 <alloc_block_BF+0x2a0>
	{
		if(blk->size == newsize && blk->sva == newveradd)
  803155:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803158:	8b 40 0c             	mov    0xc(%eax),%eax
  80315b:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  80315e:	0f 85 cd 00 00 00    	jne    803231 <alloc_block_BF+0x298>
  803164:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803167:	8b 40 08             	mov    0x8(%eax),%eax
  80316a:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80316d:	0f 85 be 00 00 00    	jne    803231 <alloc_block_BF+0x298>
		{
			LIST_REMOVE(&AvailableMemBlocksList, newblk);
  803173:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  803177:	75 17                	jne    803190 <alloc_block_BF+0x1f7>
  803179:	83 ec 04             	sub    $0x4,%esp
  80317c:	68 08 46 80 00       	push   $0x804608
  803181:	68 db 00 00 00       	push   $0xdb
  803186:	68 97 45 80 00       	push   $0x804597
  80318b:	e8 98 db ff ff       	call   800d28 <_panic>
  803190:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803193:	8b 00                	mov    (%eax),%eax
  803195:	85 c0                	test   %eax,%eax
  803197:	74 10                	je     8031a9 <alloc_block_BF+0x210>
  803199:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80319c:	8b 00                	mov    (%eax),%eax
  80319e:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8031a1:	8b 52 04             	mov    0x4(%edx),%edx
  8031a4:	89 50 04             	mov    %edx,0x4(%eax)
  8031a7:	eb 0b                	jmp    8031b4 <alloc_block_BF+0x21b>
  8031a9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8031ac:	8b 40 04             	mov    0x4(%eax),%eax
  8031af:	a3 4c 51 80 00       	mov    %eax,0x80514c
  8031b4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8031b7:	8b 40 04             	mov    0x4(%eax),%eax
  8031ba:	85 c0                	test   %eax,%eax
  8031bc:	74 0f                	je     8031cd <alloc_block_BF+0x234>
  8031be:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8031c1:	8b 40 04             	mov    0x4(%eax),%eax
  8031c4:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8031c7:	8b 12                	mov    (%edx),%edx
  8031c9:	89 10                	mov    %edx,(%eax)
  8031cb:	eb 0a                	jmp    8031d7 <alloc_block_BF+0x23e>
  8031cd:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8031d0:	8b 00                	mov    (%eax),%eax
  8031d2:	a3 48 51 80 00       	mov    %eax,0x805148
  8031d7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8031da:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8031e0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8031e3:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8031ea:	a1 54 51 80 00       	mov    0x805154,%eax
  8031ef:	48                   	dec    %eax
  8031f0:	a3 54 51 80 00       	mov    %eax,0x805154
			newblk->size = versize;
  8031f5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8031f8:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8031fb:	89 50 0c             	mov    %edx,0xc(%eax)
			newblk->sva = newveradd;
  8031fe:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803201:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803204:	89 50 08             	mov    %edx,0x8(%eax)
			blk->size = blk->size - versize;
  803207:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80320a:	8b 40 0c             	mov    0xc(%eax),%eax
  80320d:	2b 45 e8             	sub    -0x18(%ebp),%eax
  803210:	89 c2                	mov    %eax,%edx
  803212:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803215:	89 50 0c             	mov    %edx,0xc(%eax)
			blk->sva+= newblk->size;
  803218:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80321b:	8b 50 08             	mov    0x8(%eax),%edx
  80321e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803221:	8b 40 0c             	mov    0xc(%eax),%eax
  803224:	01 c2                	add    %eax,%edx
  803226:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803229:	89 50 08             	mov    %edx,0x8(%eax)
			return newblk;
  80322c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80322f:	eb 3b                	jmp    80326c <alloc_block_BF+0x2d3>
		{
	       newsize = blk->size;
		   newveradd = blk->sva;
		}
	}
	LIST_FOREACH(blk, &FreeMemBlocksList)
  803231:	a1 40 51 80 00       	mov    0x805140,%eax
  803236:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803239:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80323d:	74 07                	je     803246 <alloc_block_BF+0x2ad>
  80323f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803242:	8b 00                	mov    (%eax),%eax
  803244:	eb 05                	jmp    80324b <alloc_block_BF+0x2b2>
  803246:	b8 00 00 00 00       	mov    $0x0,%eax
  80324b:	a3 40 51 80 00       	mov    %eax,0x805140
  803250:	a1 40 51 80 00       	mov    0x805140,%eax
  803255:	85 c0                	test   %eax,%eax
  803257:	0f 85 f8 fe ff ff    	jne    803155 <alloc_block_BF+0x1bc>
  80325d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803261:	0f 85 ee fe ff ff    	jne    803155 <alloc_block_BF+0x1bc>
			blk->size = blk->size - versize;
			blk->sva+= newblk->size;
			return newblk;
		}
	}
	return NULL;
  803267:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80326c:	c9                   	leave  
  80326d:	c3                   	ret    

0080326e <alloc_block_NF>:
//=========================================
// [7] ALLOCATE BLOCK BY NEXT FIT:
//=========================================
struct MemBlock *last_allocate;
struct MemBlock *alloc_block_NF(uint32 size)
{
  80326e:	55                   	push   %ebp
  80326f:	89 e5                	mov    %esp,%ebp
  803271:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1 - BONUS] [DYNAMIC ALLOCATOR] alloc_block_NF
	// Write your code here, remove the panic and write your code
	//panic("alloc_block_NF() is not implemented yet...!!");
	uint32 versize = size;
  803274:	8b 45 08             	mov    0x8(%ebp),%eax
  803277:	89 45 f0             	mov    %eax,-0x10(%ebp)
	struct MemBlock* blk;
	struct MemBlock* newblk = LIST_FIRST(&AvailableMemBlocksList);
  80327a:	a1 48 51 80 00       	mov    0x805148,%eax
  80327f:	89 45 ec             	mov    %eax,-0x14(%ebp)

	LIST_FOREACH(blk,&FreeMemBlocksList)
  803282:	a1 38 51 80 00       	mov    0x805138,%eax
  803287:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80328a:	e9 77 01 00 00       	jmp    803406 <alloc_block_NF+0x198>
	{
		if(blk->size == versize)
  80328f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803292:	8b 40 0c             	mov    0xc(%eax),%eax
  803295:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  803298:	0f 85 8a 00 00 00    	jne    803328 <alloc_block_NF+0xba>
		{
			LIST_REMOVE(&FreeMemBlocksList,blk);
  80329e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8032a2:	75 17                	jne    8032bb <alloc_block_NF+0x4d>
  8032a4:	83 ec 04             	sub    $0x4,%esp
  8032a7:	68 08 46 80 00       	push   $0x804608
  8032ac:	68 f7 00 00 00       	push   $0xf7
  8032b1:	68 97 45 80 00       	push   $0x804597
  8032b6:	e8 6d da ff ff       	call   800d28 <_panic>
  8032bb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8032be:	8b 00                	mov    (%eax),%eax
  8032c0:	85 c0                	test   %eax,%eax
  8032c2:	74 10                	je     8032d4 <alloc_block_NF+0x66>
  8032c4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8032c7:	8b 00                	mov    (%eax),%eax
  8032c9:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8032cc:	8b 52 04             	mov    0x4(%edx),%edx
  8032cf:	89 50 04             	mov    %edx,0x4(%eax)
  8032d2:	eb 0b                	jmp    8032df <alloc_block_NF+0x71>
  8032d4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8032d7:	8b 40 04             	mov    0x4(%eax),%eax
  8032da:	a3 3c 51 80 00       	mov    %eax,0x80513c
  8032df:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8032e2:	8b 40 04             	mov    0x4(%eax),%eax
  8032e5:	85 c0                	test   %eax,%eax
  8032e7:	74 0f                	je     8032f8 <alloc_block_NF+0x8a>
  8032e9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8032ec:	8b 40 04             	mov    0x4(%eax),%eax
  8032ef:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8032f2:	8b 12                	mov    (%edx),%edx
  8032f4:	89 10                	mov    %edx,(%eax)
  8032f6:	eb 0a                	jmp    803302 <alloc_block_NF+0x94>
  8032f8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8032fb:	8b 00                	mov    (%eax),%eax
  8032fd:	a3 38 51 80 00       	mov    %eax,0x805138
  803302:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803305:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80330b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80330e:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803315:	a1 44 51 80 00       	mov    0x805144,%eax
  80331a:	48                   	dec    %eax
  80331b:	a3 44 51 80 00       	mov    %eax,0x805144
			return blk;
  803320:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803323:	e9 11 01 00 00       	jmp    803439 <alloc_block_NF+0x1cb>
		}
		else if(blk->size > versize)
  803328:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80332b:	8b 40 0c             	mov    0xc(%eax),%eax
  80332e:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  803331:	0f 86 c7 00 00 00    	jbe    8033fe <alloc_block_NF+0x190>
		{
			LIST_REMOVE(&AvailableMemBlocksList,newblk);
  803337:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  80333b:	75 17                	jne    803354 <alloc_block_NF+0xe6>
  80333d:	83 ec 04             	sub    $0x4,%esp
  803340:	68 08 46 80 00       	push   $0x804608
  803345:	68 fc 00 00 00       	push   $0xfc
  80334a:	68 97 45 80 00       	push   $0x804597
  80334f:	e8 d4 d9 ff ff       	call   800d28 <_panic>
  803354:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803357:	8b 00                	mov    (%eax),%eax
  803359:	85 c0                	test   %eax,%eax
  80335b:	74 10                	je     80336d <alloc_block_NF+0xff>
  80335d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803360:	8b 00                	mov    (%eax),%eax
  803362:	8b 55 ec             	mov    -0x14(%ebp),%edx
  803365:	8b 52 04             	mov    0x4(%edx),%edx
  803368:	89 50 04             	mov    %edx,0x4(%eax)
  80336b:	eb 0b                	jmp    803378 <alloc_block_NF+0x10a>
  80336d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803370:	8b 40 04             	mov    0x4(%eax),%eax
  803373:	a3 4c 51 80 00       	mov    %eax,0x80514c
  803378:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80337b:	8b 40 04             	mov    0x4(%eax),%eax
  80337e:	85 c0                	test   %eax,%eax
  803380:	74 0f                	je     803391 <alloc_block_NF+0x123>
  803382:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803385:	8b 40 04             	mov    0x4(%eax),%eax
  803388:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80338b:	8b 12                	mov    (%edx),%edx
  80338d:	89 10                	mov    %edx,(%eax)
  80338f:	eb 0a                	jmp    80339b <alloc_block_NF+0x12d>
  803391:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803394:	8b 00                	mov    (%eax),%eax
  803396:	a3 48 51 80 00       	mov    %eax,0x805148
  80339b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80339e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8033a4:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8033a7:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8033ae:	a1 54 51 80 00       	mov    0x805154,%eax
  8033b3:	48                   	dec    %eax
  8033b4:	a3 54 51 80 00       	mov    %eax,0x805154
			newblk->size = versize;
  8033b9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8033bc:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8033bf:	89 50 0c             	mov    %edx,0xc(%eax)
			blk->size = blk->size-versize;
  8033c2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8033c5:	8b 40 0c             	mov    0xc(%eax),%eax
  8033c8:	2b 45 f0             	sub    -0x10(%ebp),%eax
  8033cb:	89 c2                	mov    %eax,%edx
  8033cd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8033d0:	89 50 0c             	mov    %edx,0xc(%eax)
			uint32 newveradd = blk->sva;
  8033d3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8033d6:	8b 40 08             	mov    0x8(%eax),%eax
  8033d9:	89 45 e8             	mov    %eax,-0x18(%ebp)
			blk->sva+=newblk->size;
  8033dc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8033df:	8b 50 08             	mov    0x8(%eax),%edx
  8033e2:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8033e5:	8b 40 0c             	mov    0xc(%eax),%eax
  8033e8:	01 c2                	add    %eax,%edx
  8033ea:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8033ed:	89 50 08             	mov    %edx,0x8(%eax)
			newblk->sva = newveradd;
  8033f0:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8033f3:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8033f6:	89 50 08             	mov    %edx,0x8(%eax)
			return newblk;
  8033f9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8033fc:	eb 3b                	jmp    803439 <alloc_block_NF+0x1cb>
	//panic("alloc_block_NF() is not implemented yet...!!");
	uint32 versize = size;
	struct MemBlock* blk;
	struct MemBlock* newblk = LIST_FIRST(&AvailableMemBlocksList);

	LIST_FOREACH(blk,&FreeMemBlocksList)
  8033fe:	a1 40 51 80 00       	mov    0x805140,%eax
  803403:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803406:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80340a:	74 07                	je     803413 <alloc_block_NF+0x1a5>
  80340c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80340f:	8b 00                	mov    (%eax),%eax
  803411:	eb 05                	jmp    803418 <alloc_block_NF+0x1aa>
  803413:	b8 00 00 00 00       	mov    $0x0,%eax
  803418:	a3 40 51 80 00       	mov    %eax,0x805140
  80341d:	a1 40 51 80 00       	mov    0x805140,%eax
  803422:	85 c0                	test   %eax,%eax
  803424:	0f 85 65 fe ff ff    	jne    80328f <alloc_block_NF+0x21>
  80342a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80342e:	0f 85 5b fe ff ff    	jne    80328f <alloc_block_NF+0x21>
			blk->sva+=newblk->size;
			newblk->sva = newveradd;
			return newblk;
		}
	}
	return NULL;
  803434:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803439:	c9                   	leave  
  80343a:	c3                   	ret    

0080343b <addToAvailMemBlocksList>:

//===================================================
// [8] INSERT BLOCK (SORTED WITH MERGE) IN FREE LIST:
//===================================================
void addToAvailMemBlocksList(struct MemBlock *blockToInsert)
{
  80343b:	55                   	push   %ebp
  80343c:	89 e5                	mov    %esp,%ebp
  80343e:	83 ec 08             	sub    $0x8,%esp
	blockToInsert->sva = 0;
  803441:	8b 45 08             	mov    0x8(%ebp),%eax
  803444:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
	blockToInsert->size = 0;
  80344b:	8b 45 08             	mov    0x8(%ebp),%eax
  80344e:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
	//add to avail
	LIST_INSERT_TAIL(&AvailableMemBlocksList, blockToInsert);
  803455:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803459:	75 17                	jne    803472 <addToAvailMemBlocksList+0x37>
  80345b:	83 ec 04             	sub    $0x4,%esp
  80345e:	68 b0 45 80 00       	push   $0x8045b0
  803463:	68 10 01 00 00       	push   $0x110
  803468:	68 97 45 80 00       	push   $0x804597
  80346d:	e8 b6 d8 ff ff       	call   800d28 <_panic>
  803472:	8b 15 4c 51 80 00    	mov    0x80514c,%edx
  803478:	8b 45 08             	mov    0x8(%ebp),%eax
  80347b:	89 50 04             	mov    %edx,0x4(%eax)
  80347e:	8b 45 08             	mov    0x8(%ebp),%eax
  803481:	8b 40 04             	mov    0x4(%eax),%eax
  803484:	85 c0                	test   %eax,%eax
  803486:	74 0c                	je     803494 <addToAvailMemBlocksList+0x59>
  803488:	a1 4c 51 80 00       	mov    0x80514c,%eax
  80348d:	8b 55 08             	mov    0x8(%ebp),%edx
  803490:	89 10                	mov    %edx,(%eax)
  803492:	eb 08                	jmp    80349c <addToAvailMemBlocksList+0x61>
  803494:	8b 45 08             	mov    0x8(%ebp),%eax
  803497:	a3 48 51 80 00       	mov    %eax,0x805148
  80349c:	8b 45 08             	mov    0x8(%ebp),%eax
  80349f:	a3 4c 51 80 00       	mov    %eax,0x80514c
  8034a4:	8b 45 08             	mov    0x8(%ebp),%eax
  8034a7:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8034ad:	a1 54 51 80 00       	mov    0x805154,%eax
  8034b2:	40                   	inc    %eax
  8034b3:	a3 54 51 80 00       	mov    %eax,0x805154
}
  8034b8:	90                   	nop
  8034b9:	c9                   	leave  
  8034ba:	c3                   	ret    

008034bb <insert_sorted_with_merge_freeList>:
void insert_sorted_with_merge_freeList(struct MemBlock *blockToInsert)
{
  8034bb:	55                   	push   %ebp
  8034bc:	89 e5                	mov    %esp,%ebp
  8034be:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] insert_sorted_with_merge_freeList
	// Write your code here, remove the panic and write your code

	struct MemBlock* last = LIST_LAST(&FreeMemBlocksList);
  8034c1:	a1 3c 51 80 00       	mov    0x80513c,%eax
  8034c6:	89 45 f0             	mov    %eax,-0x10(%ebp)
	//check if list empty
	if (LIST_SIZE(&(FreeMemBlocksList)) == 0)
  8034c9:	a1 44 51 80 00       	mov    0x805144,%eax
  8034ce:	85 c0                	test   %eax,%eax
  8034d0:	75 68                	jne    80353a <insert_sorted_with_merge_freeList+0x7f>
		LIST_INSERT_HEAD(&FreeMemBlocksList, blockToInsert);
  8034d2:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8034d6:	75 17                	jne    8034ef <insert_sorted_with_merge_freeList+0x34>
  8034d8:	83 ec 04             	sub    $0x4,%esp
  8034db:	68 74 45 80 00       	push   $0x804574
  8034e0:	68 1a 01 00 00       	push   $0x11a
  8034e5:	68 97 45 80 00       	push   $0x804597
  8034ea:	e8 39 d8 ff ff       	call   800d28 <_panic>
  8034ef:	8b 15 38 51 80 00    	mov    0x805138,%edx
  8034f5:	8b 45 08             	mov    0x8(%ebp),%eax
  8034f8:	89 10                	mov    %edx,(%eax)
  8034fa:	8b 45 08             	mov    0x8(%ebp),%eax
  8034fd:	8b 00                	mov    (%eax),%eax
  8034ff:	85 c0                	test   %eax,%eax
  803501:	74 0d                	je     803510 <insert_sorted_with_merge_freeList+0x55>
  803503:	a1 38 51 80 00       	mov    0x805138,%eax
  803508:	8b 55 08             	mov    0x8(%ebp),%edx
  80350b:	89 50 04             	mov    %edx,0x4(%eax)
  80350e:	eb 08                	jmp    803518 <insert_sorted_with_merge_freeList+0x5d>
  803510:	8b 45 08             	mov    0x8(%ebp),%eax
  803513:	a3 3c 51 80 00       	mov    %eax,0x80513c
  803518:	8b 45 08             	mov    0x8(%ebp),%eax
  80351b:	a3 38 51 80 00       	mov    %eax,0x805138
  803520:	8b 45 08             	mov    0x8(%ebp),%eax
  803523:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80352a:	a1 44 51 80 00       	mov    0x805144,%eax
  80352f:	40                   	inc    %eax
  803530:	a3 44 51 80 00       	mov    %eax,0x805144
		}
	}

	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  803535:	e9 c5 03 00 00       	jmp    8038ff <insert_sorted_with_merge_freeList+0x444>
	struct MemBlock* last = LIST_LAST(&FreeMemBlocksList);
	//check if list empty
	if (LIST_SIZE(&(FreeMemBlocksList)) == 0)
		LIST_INSERT_HEAD(&FreeMemBlocksList, blockToInsert);
	//check if it's position is at last
	else if (last->sva < blockToInsert->sva) {
  80353a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80353d:	8b 50 08             	mov    0x8(%eax),%edx
  803540:	8b 45 08             	mov    0x8(%ebp),%eax
  803543:	8b 40 08             	mov    0x8(%eax),%eax
  803546:	39 c2                	cmp    %eax,%edx
  803548:	0f 83 b2 00 00 00    	jae    803600 <insert_sorted_with_merge_freeList+0x145>

		//if i have to merge
		if (last->sva + last->size == blockToInsert->sva) {
  80354e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803551:	8b 50 08             	mov    0x8(%eax),%edx
  803554:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803557:	8b 40 0c             	mov    0xc(%eax),%eax
  80355a:	01 c2                	add    %eax,%edx
  80355c:	8b 45 08             	mov    0x8(%ebp),%eax
  80355f:	8b 40 08             	mov    0x8(%eax),%eax
  803562:	39 c2                	cmp    %eax,%edx
  803564:	75 27                	jne    80358d <insert_sorted_with_merge_freeList+0xd2>
			last->size = last->size + blockToInsert->size;
  803566:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803569:	8b 50 0c             	mov    0xc(%eax),%edx
  80356c:	8b 45 08             	mov    0x8(%ebp),%eax
  80356f:	8b 40 0c             	mov    0xc(%eax),%eax
  803572:	01 c2                	add    %eax,%edx
  803574:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803577:	89 50 0c             	mov    %edx,0xc(%eax)
			addToAvailMemBlocksList(blockToInsert);
  80357a:	83 ec 0c             	sub    $0xc,%esp
  80357d:	ff 75 08             	pushl  0x8(%ebp)
  803580:	e8 b6 fe ff ff       	call   80343b <addToAvailMemBlocksList>
  803585:	83 c4 10             	add    $0x10,%esp
		}
	}

	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  803588:	e9 72 03 00 00       	jmp    8038ff <insert_sorted_with_merge_freeList+0x444>
		if (last->sva + last->size == blockToInsert->sva) {
			last->size = last->size + blockToInsert->size;
			addToAvailMemBlocksList(blockToInsert);

		} else {
			LIST_INSERT_AFTER(&FreeMemBlocksList, last, blockToInsert);
  80358d:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  803591:	74 06                	je     803599 <insert_sorted_with_merge_freeList+0xde>
  803593:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803597:	75 17                	jne    8035b0 <insert_sorted_with_merge_freeList+0xf5>
  803599:	83 ec 04             	sub    $0x4,%esp
  80359c:	68 d4 45 80 00       	push   $0x8045d4
  8035a1:	68 24 01 00 00       	push   $0x124
  8035a6:	68 97 45 80 00       	push   $0x804597
  8035ab:	e8 78 d7 ff ff       	call   800d28 <_panic>
  8035b0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8035b3:	8b 10                	mov    (%eax),%edx
  8035b5:	8b 45 08             	mov    0x8(%ebp),%eax
  8035b8:	89 10                	mov    %edx,(%eax)
  8035ba:	8b 45 08             	mov    0x8(%ebp),%eax
  8035bd:	8b 00                	mov    (%eax),%eax
  8035bf:	85 c0                	test   %eax,%eax
  8035c1:	74 0b                	je     8035ce <insert_sorted_with_merge_freeList+0x113>
  8035c3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8035c6:	8b 00                	mov    (%eax),%eax
  8035c8:	8b 55 08             	mov    0x8(%ebp),%edx
  8035cb:	89 50 04             	mov    %edx,0x4(%eax)
  8035ce:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8035d1:	8b 55 08             	mov    0x8(%ebp),%edx
  8035d4:	89 10                	mov    %edx,(%eax)
  8035d6:	8b 45 08             	mov    0x8(%ebp),%eax
  8035d9:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8035dc:	89 50 04             	mov    %edx,0x4(%eax)
  8035df:	8b 45 08             	mov    0x8(%ebp),%eax
  8035e2:	8b 00                	mov    (%eax),%eax
  8035e4:	85 c0                	test   %eax,%eax
  8035e6:	75 08                	jne    8035f0 <insert_sorted_with_merge_freeList+0x135>
  8035e8:	8b 45 08             	mov    0x8(%ebp),%eax
  8035eb:	a3 3c 51 80 00       	mov    %eax,0x80513c
  8035f0:	a1 44 51 80 00       	mov    0x805144,%eax
  8035f5:	40                   	inc    %eax
  8035f6:	a3 44 51 80 00       	mov    %eax,0x805144
		}
	}

	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  8035fb:	e9 ff 02 00 00       	jmp    8038ff <insert_sorted_with_merge_freeList+0x444>
		} else {
			LIST_INSERT_AFTER(&FreeMemBlocksList, last, blockToInsert);
		}
	} else {
		struct MemBlock *iterator;
		LIST_FOREACH(iterator, &(FreeMemBlocksList))
  803600:	a1 38 51 80 00       	mov    0x805138,%eax
  803605:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803608:	e9 c2 02 00 00       	jmp    8038cf <insert_sorted_with_merge_freeList+0x414>
		{

			if (iterator->sva > blockToInsert->sva) {
  80360d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803610:	8b 50 08             	mov    0x8(%eax),%edx
  803613:	8b 45 08             	mov    0x8(%ebp),%eax
  803616:	8b 40 08             	mov    0x8(%eax),%eax
  803619:	39 c2                	cmp    %eax,%edx
  80361b:	0f 86 a6 02 00 00    	jbe    8038c7 <insert_sorted_with_merge_freeList+0x40c>

				struct MemBlock* prev = LIST_PREV(iterator);
  803621:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803624:	8b 40 04             	mov    0x4(%eax),%eax
  803627:	89 45 ec             	mov    %eax,-0x14(%ebp)
				if (prev == NULL) {
  80362a:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  80362e:	0f 85 ba 00 00 00    	jne    8036ee <insert_sorted_with_merge_freeList+0x233>
					//check merge
					if (blockToInsert->size + blockToInsert->sva
  803634:	8b 45 08             	mov    0x8(%ebp),%eax
  803637:	8b 50 0c             	mov    0xc(%eax),%edx
  80363a:	8b 45 08             	mov    0x8(%ebp),%eax
  80363d:	8b 40 08             	mov    0x8(%eax),%eax
  803640:	01 c2                	add    %eax,%edx
							== iterator->sva) {
  803642:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803645:	8b 40 08             	mov    0x8(%eax),%eax
			if (iterator->sva > blockToInsert->sva) {

				struct MemBlock* prev = LIST_PREV(iterator);
				if (prev == NULL) {
					//check merge
					if (blockToInsert->size + blockToInsert->sva
  803648:	39 c2                	cmp    %eax,%edx
  80364a:	75 33                	jne    80367f <insert_sorted_with_merge_freeList+0x1c4>
							== iterator->sva) {
						iterator->sva = blockToInsert->sva;
  80364c:	8b 45 08             	mov    0x8(%ebp),%eax
  80364f:	8b 50 08             	mov    0x8(%eax),%edx
  803652:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803655:	89 50 08             	mov    %edx,0x8(%eax)
						iterator->size = iterator->size + blockToInsert->size;
  803658:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80365b:	8b 50 0c             	mov    0xc(%eax),%edx
  80365e:	8b 45 08             	mov    0x8(%ebp),%eax
  803661:	8b 40 0c             	mov    0xc(%eax),%eax
  803664:	01 c2                	add    %eax,%edx
  803666:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803669:	89 50 0c             	mov    %edx,0xc(%eax)
						addToAvailMemBlocksList(blockToInsert);
  80366c:	83 ec 0c             	sub    $0xc,%esp
  80366f:	ff 75 08             	pushl  0x8(%ebp)
  803672:	e8 c4 fd ff ff       	call   80343b <addToAvailMemBlocksList>
  803677:	83 c4 10             	add    $0x10,%esp

					else {
						LIST_INSERT_BEFORE(&FreeMemBlocksList, iterator,
								blockToInsert);
					}
					break;
  80367a:	e9 80 02 00 00       	jmp    8038ff <insert_sorted_with_merge_freeList+0x444>
						addToAvailMemBlocksList(blockToInsert);

					}

					else {
						LIST_INSERT_BEFORE(&FreeMemBlocksList, iterator,
  80367f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803683:	74 06                	je     80368b <insert_sorted_with_merge_freeList+0x1d0>
  803685:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803689:	75 17                	jne    8036a2 <insert_sorted_with_merge_freeList+0x1e7>
  80368b:	83 ec 04             	sub    $0x4,%esp
  80368e:	68 28 46 80 00       	push   $0x804628
  803693:	68 3a 01 00 00       	push   $0x13a
  803698:	68 97 45 80 00       	push   $0x804597
  80369d:	e8 86 d6 ff ff       	call   800d28 <_panic>
  8036a2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8036a5:	8b 50 04             	mov    0x4(%eax),%edx
  8036a8:	8b 45 08             	mov    0x8(%ebp),%eax
  8036ab:	89 50 04             	mov    %edx,0x4(%eax)
  8036ae:	8b 45 08             	mov    0x8(%ebp),%eax
  8036b1:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8036b4:	89 10                	mov    %edx,(%eax)
  8036b6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8036b9:	8b 40 04             	mov    0x4(%eax),%eax
  8036bc:	85 c0                	test   %eax,%eax
  8036be:	74 0d                	je     8036cd <insert_sorted_with_merge_freeList+0x212>
  8036c0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8036c3:	8b 40 04             	mov    0x4(%eax),%eax
  8036c6:	8b 55 08             	mov    0x8(%ebp),%edx
  8036c9:	89 10                	mov    %edx,(%eax)
  8036cb:	eb 08                	jmp    8036d5 <insert_sorted_with_merge_freeList+0x21a>
  8036cd:	8b 45 08             	mov    0x8(%ebp),%eax
  8036d0:	a3 38 51 80 00       	mov    %eax,0x805138
  8036d5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8036d8:	8b 55 08             	mov    0x8(%ebp),%edx
  8036db:	89 50 04             	mov    %edx,0x4(%eax)
  8036de:	a1 44 51 80 00       	mov    0x805144,%eax
  8036e3:	40                   	inc    %eax
  8036e4:	a3 44 51 80 00       	mov    %eax,0x805144
								blockToInsert);
					}
					break;
  8036e9:	e9 11 02 00 00       	jmp    8038ff <insert_sorted_with_merge_freeList+0x444>
				} else {
					//prev and next merge
					if (prev->sva + prev->size + blockToInsert->size
  8036ee:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8036f1:	8b 50 08             	mov    0x8(%eax),%edx
  8036f4:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8036f7:	8b 40 0c             	mov    0xc(%eax),%eax
  8036fa:	01 c2                	add    %eax,%edx
  8036fc:	8b 45 08             	mov    0x8(%ebp),%eax
  8036ff:	8b 40 0c             	mov    0xc(%eax),%eax
  803702:	01 c2                	add    %eax,%edx
							== iterator->sva) {
  803704:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803707:	8b 40 08             	mov    0x8(%eax),%eax
								blockToInsert);
					}
					break;
				} else {
					//prev and next merge
					if (prev->sva + prev->size + blockToInsert->size
  80370a:	39 c2                	cmp    %eax,%edx
  80370c:	0f 85 bf 00 00 00    	jne    8037d1 <insert_sorted_with_merge_freeList+0x316>
							== iterator->sva) {
						prev->size = prev->size + blockToInsert->size
  803712:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803715:	8b 50 0c             	mov    0xc(%eax),%edx
  803718:	8b 45 08             	mov    0x8(%ebp),%eax
  80371b:	8b 40 0c             	mov    0xc(%eax),%eax
  80371e:	01 c2                	add    %eax,%edx
								+ iterator->size;
  803720:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803723:	8b 40 0c             	mov    0xc(%eax),%eax
  803726:	01 c2                	add    %eax,%edx
					break;
				} else {
					//prev and next merge
					if (prev->sva + prev->size + blockToInsert->size
							== iterator->sva) {
						prev->size = prev->size + blockToInsert->size
  803728:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80372b:	89 50 0c             	mov    %edx,0xc(%eax)
								+ iterator->size;
						LIST_REMOVE(&FreeMemBlocksList, iterator);
  80372e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803732:	75 17                	jne    80374b <insert_sorted_with_merge_freeList+0x290>
  803734:	83 ec 04             	sub    $0x4,%esp
  803737:	68 08 46 80 00       	push   $0x804608
  80373c:	68 43 01 00 00       	push   $0x143
  803741:	68 97 45 80 00       	push   $0x804597
  803746:	e8 dd d5 ff ff       	call   800d28 <_panic>
  80374b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80374e:	8b 00                	mov    (%eax),%eax
  803750:	85 c0                	test   %eax,%eax
  803752:	74 10                	je     803764 <insert_sorted_with_merge_freeList+0x2a9>
  803754:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803757:	8b 00                	mov    (%eax),%eax
  803759:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80375c:	8b 52 04             	mov    0x4(%edx),%edx
  80375f:	89 50 04             	mov    %edx,0x4(%eax)
  803762:	eb 0b                	jmp    80376f <insert_sorted_with_merge_freeList+0x2b4>
  803764:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803767:	8b 40 04             	mov    0x4(%eax),%eax
  80376a:	a3 3c 51 80 00       	mov    %eax,0x80513c
  80376f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803772:	8b 40 04             	mov    0x4(%eax),%eax
  803775:	85 c0                	test   %eax,%eax
  803777:	74 0f                	je     803788 <insert_sorted_with_merge_freeList+0x2cd>
  803779:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80377c:	8b 40 04             	mov    0x4(%eax),%eax
  80377f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803782:	8b 12                	mov    (%edx),%edx
  803784:	89 10                	mov    %edx,(%eax)
  803786:	eb 0a                	jmp    803792 <insert_sorted_with_merge_freeList+0x2d7>
  803788:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80378b:	8b 00                	mov    (%eax),%eax
  80378d:	a3 38 51 80 00       	mov    %eax,0x805138
  803792:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803795:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80379b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80379e:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8037a5:	a1 44 51 80 00       	mov    0x805144,%eax
  8037aa:	48                   	dec    %eax
  8037ab:	a3 44 51 80 00       	mov    %eax,0x805144
						addToAvailMemBlocksList(blockToInsert);
  8037b0:	83 ec 0c             	sub    $0xc,%esp
  8037b3:	ff 75 08             	pushl  0x8(%ebp)
  8037b6:	e8 80 fc ff ff       	call   80343b <addToAvailMemBlocksList>
  8037bb:	83 c4 10             	add    $0x10,%esp
						addToAvailMemBlocksList(iterator);
  8037be:	83 ec 0c             	sub    $0xc,%esp
  8037c1:	ff 75 f4             	pushl  -0xc(%ebp)
  8037c4:	e8 72 fc ff ff       	call   80343b <addToAvailMemBlocksList>
  8037c9:	83 c4 10             	add    $0x10,%esp
					//Insert
					else {
						LIST_INSERT_BEFORE(&FreeMemBlocksList, iterator,
								blockToInsert);
					}
					break;
  8037cc:	e9 2e 01 00 00       	jmp    8038ff <insert_sorted_with_merge_freeList+0x444>
						LIST_REMOVE(&FreeMemBlocksList, iterator);
						addToAvailMemBlocksList(blockToInsert);
						addToAvailMemBlocksList(iterator);
					}
					//previous merge
					else if (prev->sva + prev->size == blockToInsert->sva) {
  8037d1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8037d4:	8b 50 08             	mov    0x8(%eax),%edx
  8037d7:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8037da:	8b 40 0c             	mov    0xc(%eax),%eax
  8037dd:	01 c2                	add    %eax,%edx
  8037df:	8b 45 08             	mov    0x8(%ebp),%eax
  8037e2:	8b 40 08             	mov    0x8(%eax),%eax
  8037e5:	39 c2                	cmp    %eax,%edx
  8037e7:	75 27                	jne    803810 <insert_sorted_with_merge_freeList+0x355>
						prev->size = prev->size + blockToInsert->size;
  8037e9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8037ec:	8b 50 0c             	mov    0xc(%eax),%edx
  8037ef:	8b 45 08             	mov    0x8(%ebp),%eax
  8037f2:	8b 40 0c             	mov    0xc(%eax),%eax
  8037f5:	01 c2                	add    %eax,%edx
  8037f7:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8037fa:	89 50 0c             	mov    %edx,0xc(%eax)
						addToAvailMemBlocksList(blockToInsert);
  8037fd:	83 ec 0c             	sub    $0xc,%esp
  803800:	ff 75 08             	pushl  0x8(%ebp)
  803803:	e8 33 fc ff ff       	call   80343b <addToAvailMemBlocksList>
  803808:	83 c4 10             	add    $0x10,%esp
					//Insert
					else {
						LIST_INSERT_BEFORE(&FreeMemBlocksList, iterator,
								blockToInsert);
					}
					break;
  80380b:	e9 ef 00 00 00       	jmp    8038ff <insert_sorted_with_merge_freeList+0x444>
					else if (prev->sva + prev->size == blockToInsert->sva) {
						prev->size = prev->size + blockToInsert->size;
						addToAvailMemBlocksList(blockToInsert);
					}
					//next merge
					else if (blockToInsert->size + blockToInsert->sva
  803810:	8b 45 08             	mov    0x8(%ebp),%eax
  803813:	8b 50 0c             	mov    0xc(%eax),%edx
  803816:	8b 45 08             	mov    0x8(%ebp),%eax
  803819:	8b 40 08             	mov    0x8(%eax),%eax
  80381c:	01 c2                	add    %eax,%edx
							== iterator->sva) {
  80381e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803821:	8b 40 08             	mov    0x8(%eax),%eax
					else if (prev->sva + prev->size == blockToInsert->sva) {
						prev->size = prev->size + blockToInsert->size;
						addToAvailMemBlocksList(blockToInsert);
					}
					//next merge
					else if (blockToInsert->size + blockToInsert->sva
  803824:	39 c2                	cmp    %eax,%edx
  803826:	75 33                	jne    80385b <insert_sorted_with_merge_freeList+0x3a0>
							== iterator->sva) {
						iterator->sva = blockToInsert->sva;
  803828:	8b 45 08             	mov    0x8(%ebp),%eax
  80382b:	8b 50 08             	mov    0x8(%eax),%edx
  80382e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803831:	89 50 08             	mov    %edx,0x8(%eax)
						iterator->size = iterator->size + blockToInsert->size;
  803834:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803837:	8b 50 0c             	mov    0xc(%eax),%edx
  80383a:	8b 45 08             	mov    0x8(%ebp),%eax
  80383d:	8b 40 0c             	mov    0xc(%eax),%eax
  803840:	01 c2                	add    %eax,%edx
  803842:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803845:	89 50 0c             	mov    %edx,0xc(%eax)
						addToAvailMemBlocksList(blockToInsert);
  803848:	83 ec 0c             	sub    $0xc,%esp
  80384b:	ff 75 08             	pushl  0x8(%ebp)
  80384e:	e8 e8 fb ff ff       	call   80343b <addToAvailMemBlocksList>
  803853:	83 c4 10             	add    $0x10,%esp
					//Insert
					else {
						LIST_INSERT_BEFORE(&FreeMemBlocksList, iterator,
								blockToInsert);
					}
					break;
  803856:	e9 a4 00 00 00       	jmp    8038ff <insert_sorted_with_merge_freeList+0x444>
						iterator->size = iterator->size + blockToInsert->size;
						addToAvailMemBlocksList(blockToInsert);
					}
					//Insert
					else {
						LIST_INSERT_BEFORE(&FreeMemBlocksList, iterator,
  80385b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80385f:	74 06                	je     803867 <insert_sorted_with_merge_freeList+0x3ac>
  803861:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803865:	75 17                	jne    80387e <insert_sorted_with_merge_freeList+0x3c3>
  803867:	83 ec 04             	sub    $0x4,%esp
  80386a:	68 28 46 80 00       	push   $0x804628
  80386f:	68 56 01 00 00       	push   $0x156
  803874:	68 97 45 80 00       	push   $0x804597
  803879:	e8 aa d4 ff ff       	call   800d28 <_panic>
  80387e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803881:	8b 50 04             	mov    0x4(%eax),%edx
  803884:	8b 45 08             	mov    0x8(%ebp),%eax
  803887:	89 50 04             	mov    %edx,0x4(%eax)
  80388a:	8b 45 08             	mov    0x8(%ebp),%eax
  80388d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803890:	89 10                	mov    %edx,(%eax)
  803892:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803895:	8b 40 04             	mov    0x4(%eax),%eax
  803898:	85 c0                	test   %eax,%eax
  80389a:	74 0d                	je     8038a9 <insert_sorted_with_merge_freeList+0x3ee>
  80389c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80389f:	8b 40 04             	mov    0x4(%eax),%eax
  8038a2:	8b 55 08             	mov    0x8(%ebp),%edx
  8038a5:	89 10                	mov    %edx,(%eax)
  8038a7:	eb 08                	jmp    8038b1 <insert_sorted_with_merge_freeList+0x3f6>
  8038a9:	8b 45 08             	mov    0x8(%ebp),%eax
  8038ac:	a3 38 51 80 00       	mov    %eax,0x805138
  8038b1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8038b4:	8b 55 08             	mov    0x8(%ebp),%edx
  8038b7:	89 50 04             	mov    %edx,0x4(%eax)
  8038ba:	a1 44 51 80 00       	mov    0x805144,%eax
  8038bf:	40                   	inc    %eax
  8038c0:	a3 44 51 80 00       	mov    %eax,0x805144
								blockToInsert);
					}
					break;
  8038c5:	eb 38                	jmp    8038ff <insert_sorted_with_merge_freeList+0x444>
		} else {
			LIST_INSERT_AFTER(&FreeMemBlocksList, last, blockToInsert);
		}
	} else {
		struct MemBlock *iterator;
		LIST_FOREACH(iterator, &(FreeMemBlocksList))
  8038c7:	a1 40 51 80 00       	mov    0x805140,%eax
  8038cc:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8038cf:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8038d3:	74 07                	je     8038dc <insert_sorted_with_merge_freeList+0x421>
  8038d5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8038d8:	8b 00                	mov    (%eax),%eax
  8038da:	eb 05                	jmp    8038e1 <insert_sorted_with_merge_freeList+0x426>
  8038dc:	b8 00 00 00 00       	mov    $0x0,%eax
  8038e1:	a3 40 51 80 00       	mov    %eax,0x805140
  8038e6:	a1 40 51 80 00       	mov    0x805140,%eax
  8038eb:	85 c0                	test   %eax,%eax
  8038ed:	0f 85 1a fd ff ff    	jne    80360d <insert_sorted_with_merge_freeList+0x152>
  8038f3:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8038f7:	0f 85 10 fd ff ff    	jne    80360d <insert_sorted_with_merge_freeList+0x152>
		}
	}

	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  8038fd:	eb 00                	jmp    8038ff <insert_sorted_with_merge_freeList+0x444>
  8038ff:	90                   	nop
  803900:	c9                   	leave  
  803901:	c3                   	ret    
  803902:	66 90                	xchg   %ax,%ax

00803904 <__udivdi3>:
  803904:	55                   	push   %ebp
  803905:	57                   	push   %edi
  803906:	56                   	push   %esi
  803907:	53                   	push   %ebx
  803908:	83 ec 1c             	sub    $0x1c,%esp
  80390b:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  80390f:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  803913:	8b 7c 24 38          	mov    0x38(%esp),%edi
  803917:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  80391b:	89 ca                	mov    %ecx,%edx
  80391d:	89 f8                	mov    %edi,%eax
  80391f:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  803923:	85 f6                	test   %esi,%esi
  803925:	75 2d                	jne    803954 <__udivdi3+0x50>
  803927:	39 cf                	cmp    %ecx,%edi
  803929:	77 65                	ja     803990 <__udivdi3+0x8c>
  80392b:	89 fd                	mov    %edi,%ebp
  80392d:	85 ff                	test   %edi,%edi
  80392f:	75 0b                	jne    80393c <__udivdi3+0x38>
  803931:	b8 01 00 00 00       	mov    $0x1,%eax
  803936:	31 d2                	xor    %edx,%edx
  803938:	f7 f7                	div    %edi
  80393a:	89 c5                	mov    %eax,%ebp
  80393c:	31 d2                	xor    %edx,%edx
  80393e:	89 c8                	mov    %ecx,%eax
  803940:	f7 f5                	div    %ebp
  803942:	89 c1                	mov    %eax,%ecx
  803944:	89 d8                	mov    %ebx,%eax
  803946:	f7 f5                	div    %ebp
  803948:	89 cf                	mov    %ecx,%edi
  80394a:	89 fa                	mov    %edi,%edx
  80394c:	83 c4 1c             	add    $0x1c,%esp
  80394f:	5b                   	pop    %ebx
  803950:	5e                   	pop    %esi
  803951:	5f                   	pop    %edi
  803952:	5d                   	pop    %ebp
  803953:	c3                   	ret    
  803954:	39 ce                	cmp    %ecx,%esi
  803956:	77 28                	ja     803980 <__udivdi3+0x7c>
  803958:	0f bd fe             	bsr    %esi,%edi
  80395b:	83 f7 1f             	xor    $0x1f,%edi
  80395e:	75 40                	jne    8039a0 <__udivdi3+0x9c>
  803960:	39 ce                	cmp    %ecx,%esi
  803962:	72 0a                	jb     80396e <__udivdi3+0x6a>
  803964:	3b 44 24 08          	cmp    0x8(%esp),%eax
  803968:	0f 87 9e 00 00 00    	ja     803a0c <__udivdi3+0x108>
  80396e:	b8 01 00 00 00       	mov    $0x1,%eax
  803973:	89 fa                	mov    %edi,%edx
  803975:	83 c4 1c             	add    $0x1c,%esp
  803978:	5b                   	pop    %ebx
  803979:	5e                   	pop    %esi
  80397a:	5f                   	pop    %edi
  80397b:	5d                   	pop    %ebp
  80397c:	c3                   	ret    
  80397d:	8d 76 00             	lea    0x0(%esi),%esi
  803980:	31 ff                	xor    %edi,%edi
  803982:	31 c0                	xor    %eax,%eax
  803984:	89 fa                	mov    %edi,%edx
  803986:	83 c4 1c             	add    $0x1c,%esp
  803989:	5b                   	pop    %ebx
  80398a:	5e                   	pop    %esi
  80398b:	5f                   	pop    %edi
  80398c:	5d                   	pop    %ebp
  80398d:	c3                   	ret    
  80398e:	66 90                	xchg   %ax,%ax
  803990:	89 d8                	mov    %ebx,%eax
  803992:	f7 f7                	div    %edi
  803994:	31 ff                	xor    %edi,%edi
  803996:	89 fa                	mov    %edi,%edx
  803998:	83 c4 1c             	add    $0x1c,%esp
  80399b:	5b                   	pop    %ebx
  80399c:	5e                   	pop    %esi
  80399d:	5f                   	pop    %edi
  80399e:	5d                   	pop    %ebp
  80399f:	c3                   	ret    
  8039a0:	bd 20 00 00 00       	mov    $0x20,%ebp
  8039a5:	89 eb                	mov    %ebp,%ebx
  8039a7:	29 fb                	sub    %edi,%ebx
  8039a9:	89 f9                	mov    %edi,%ecx
  8039ab:	d3 e6                	shl    %cl,%esi
  8039ad:	89 c5                	mov    %eax,%ebp
  8039af:	88 d9                	mov    %bl,%cl
  8039b1:	d3 ed                	shr    %cl,%ebp
  8039b3:	89 e9                	mov    %ebp,%ecx
  8039b5:	09 f1                	or     %esi,%ecx
  8039b7:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  8039bb:	89 f9                	mov    %edi,%ecx
  8039bd:	d3 e0                	shl    %cl,%eax
  8039bf:	89 c5                	mov    %eax,%ebp
  8039c1:	89 d6                	mov    %edx,%esi
  8039c3:	88 d9                	mov    %bl,%cl
  8039c5:	d3 ee                	shr    %cl,%esi
  8039c7:	89 f9                	mov    %edi,%ecx
  8039c9:	d3 e2                	shl    %cl,%edx
  8039cb:	8b 44 24 08          	mov    0x8(%esp),%eax
  8039cf:	88 d9                	mov    %bl,%cl
  8039d1:	d3 e8                	shr    %cl,%eax
  8039d3:	09 c2                	or     %eax,%edx
  8039d5:	89 d0                	mov    %edx,%eax
  8039d7:	89 f2                	mov    %esi,%edx
  8039d9:	f7 74 24 0c          	divl   0xc(%esp)
  8039dd:	89 d6                	mov    %edx,%esi
  8039df:	89 c3                	mov    %eax,%ebx
  8039e1:	f7 e5                	mul    %ebp
  8039e3:	39 d6                	cmp    %edx,%esi
  8039e5:	72 19                	jb     803a00 <__udivdi3+0xfc>
  8039e7:	74 0b                	je     8039f4 <__udivdi3+0xf0>
  8039e9:	89 d8                	mov    %ebx,%eax
  8039eb:	31 ff                	xor    %edi,%edi
  8039ed:	e9 58 ff ff ff       	jmp    80394a <__udivdi3+0x46>
  8039f2:	66 90                	xchg   %ax,%ax
  8039f4:	8b 54 24 08          	mov    0x8(%esp),%edx
  8039f8:	89 f9                	mov    %edi,%ecx
  8039fa:	d3 e2                	shl    %cl,%edx
  8039fc:	39 c2                	cmp    %eax,%edx
  8039fe:	73 e9                	jae    8039e9 <__udivdi3+0xe5>
  803a00:	8d 43 ff             	lea    -0x1(%ebx),%eax
  803a03:	31 ff                	xor    %edi,%edi
  803a05:	e9 40 ff ff ff       	jmp    80394a <__udivdi3+0x46>
  803a0a:	66 90                	xchg   %ax,%ax
  803a0c:	31 c0                	xor    %eax,%eax
  803a0e:	e9 37 ff ff ff       	jmp    80394a <__udivdi3+0x46>
  803a13:	90                   	nop

00803a14 <__umoddi3>:
  803a14:	55                   	push   %ebp
  803a15:	57                   	push   %edi
  803a16:	56                   	push   %esi
  803a17:	53                   	push   %ebx
  803a18:	83 ec 1c             	sub    $0x1c,%esp
  803a1b:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  803a1f:	8b 74 24 34          	mov    0x34(%esp),%esi
  803a23:	8b 7c 24 38          	mov    0x38(%esp),%edi
  803a27:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  803a2b:	89 44 24 0c          	mov    %eax,0xc(%esp)
  803a2f:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  803a33:	89 f3                	mov    %esi,%ebx
  803a35:	89 fa                	mov    %edi,%edx
  803a37:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  803a3b:	89 34 24             	mov    %esi,(%esp)
  803a3e:	85 c0                	test   %eax,%eax
  803a40:	75 1a                	jne    803a5c <__umoddi3+0x48>
  803a42:	39 f7                	cmp    %esi,%edi
  803a44:	0f 86 a2 00 00 00    	jbe    803aec <__umoddi3+0xd8>
  803a4a:	89 c8                	mov    %ecx,%eax
  803a4c:	89 f2                	mov    %esi,%edx
  803a4e:	f7 f7                	div    %edi
  803a50:	89 d0                	mov    %edx,%eax
  803a52:	31 d2                	xor    %edx,%edx
  803a54:	83 c4 1c             	add    $0x1c,%esp
  803a57:	5b                   	pop    %ebx
  803a58:	5e                   	pop    %esi
  803a59:	5f                   	pop    %edi
  803a5a:	5d                   	pop    %ebp
  803a5b:	c3                   	ret    
  803a5c:	39 f0                	cmp    %esi,%eax
  803a5e:	0f 87 ac 00 00 00    	ja     803b10 <__umoddi3+0xfc>
  803a64:	0f bd e8             	bsr    %eax,%ebp
  803a67:	83 f5 1f             	xor    $0x1f,%ebp
  803a6a:	0f 84 ac 00 00 00    	je     803b1c <__umoddi3+0x108>
  803a70:	bf 20 00 00 00       	mov    $0x20,%edi
  803a75:	29 ef                	sub    %ebp,%edi
  803a77:	89 fe                	mov    %edi,%esi
  803a79:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  803a7d:	89 e9                	mov    %ebp,%ecx
  803a7f:	d3 e0                	shl    %cl,%eax
  803a81:	89 d7                	mov    %edx,%edi
  803a83:	89 f1                	mov    %esi,%ecx
  803a85:	d3 ef                	shr    %cl,%edi
  803a87:	09 c7                	or     %eax,%edi
  803a89:	89 e9                	mov    %ebp,%ecx
  803a8b:	d3 e2                	shl    %cl,%edx
  803a8d:	89 14 24             	mov    %edx,(%esp)
  803a90:	89 d8                	mov    %ebx,%eax
  803a92:	d3 e0                	shl    %cl,%eax
  803a94:	89 c2                	mov    %eax,%edx
  803a96:	8b 44 24 08          	mov    0x8(%esp),%eax
  803a9a:	d3 e0                	shl    %cl,%eax
  803a9c:	89 44 24 04          	mov    %eax,0x4(%esp)
  803aa0:	8b 44 24 08          	mov    0x8(%esp),%eax
  803aa4:	89 f1                	mov    %esi,%ecx
  803aa6:	d3 e8                	shr    %cl,%eax
  803aa8:	09 d0                	or     %edx,%eax
  803aaa:	d3 eb                	shr    %cl,%ebx
  803aac:	89 da                	mov    %ebx,%edx
  803aae:	f7 f7                	div    %edi
  803ab0:	89 d3                	mov    %edx,%ebx
  803ab2:	f7 24 24             	mull   (%esp)
  803ab5:	89 c6                	mov    %eax,%esi
  803ab7:	89 d1                	mov    %edx,%ecx
  803ab9:	39 d3                	cmp    %edx,%ebx
  803abb:	0f 82 87 00 00 00    	jb     803b48 <__umoddi3+0x134>
  803ac1:	0f 84 91 00 00 00    	je     803b58 <__umoddi3+0x144>
  803ac7:	8b 54 24 04          	mov    0x4(%esp),%edx
  803acb:	29 f2                	sub    %esi,%edx
  803acd:	19 cb                	sbb    %ecx,%ebx
  803acf:	89 d8                	mov    %ebx,%eax
  803ad1:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  803ad5:	d3 e0                	shl    %cl,%eax
  803ad7:	89 e9                	mov    %ebp,%ecx
  803ad9:	d3 ea                	shr    %cl,%edx
  803adb:	09 d0                	or     %edx,%eax
  803add:	89 e9                	mov    %ebp,%ecx
  803adf:	d3 eb                	shr    %cl,%ebx
  803ae1:	89 da                	mov    %ebx,%edx
  803ae3:	83 c4 1c             	add    $0x1c,%esp
  803ae6:	5b                   	pop    %ebx
  803ae7:	5e                   	pop    %esi
  803ae8:	5f                   	pop    %edi
  803ae9:	5d                   	pop    %ebp
  803aea:	c3                   	ret    
  803aeb:	90                   	nop
  803aec:	89 fd                	mov    %edi,%ebp
  803aee:	85 ff                	test   %edi,%edi
  803af0:	75 0b                	jne    803afd <__umoddi3+0xe9>
  803af2:	b8 01 00 00 00       	mov    $0x1,%eax
  803af7:	31 d2                	xor    %edx,%edx
  803af9:	f7 f7                	div    %edi
  803afb:	89 c5                	mov    %eax,%ebp
  803afd:	89 f0                	mov    %esi,%eax
  803aff:	31 d2                	xor    %edx,%edx
  803b01:	f7 f5                	div    %ebp
  803b03:	89 c8                	mov    %ecx,%eax
  803b05:	f7 f5                	div    %ebp
  803b07:	89 d0                	mov    %edx,%eax
  803b09:	e9 44 ff ff ff       	jmp    803a52 <__umoddi3+0x3e>
  803b0e:	66 90                	xchg   %ax,%ax
  803b10:	89 c8                	mov    %ecx,%eax
  803b12:	89 f2                	mov    %esi,%edx
  803b14:	83 c4 1c             	add    $0x1c,%esp
  803b17:	5b                   	pop    %ebx
  803b18:	5e                   	pop    %esi
  803b19:	5f                   	pop    %edi
  803b1a:	5d                   	pop    %ebp
  803b1b:	c3                   	ret    
  803b1c:	3b 04 24             	cmp    (%esp),%eax
  803b1f:	72 06                	jb     803b27 <__umoddi3+0x113>
  803b21:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  803b25:	77 0f                	ja     803b36 <__umoddi3+0x122>
  803b27:	89 f2                	mov    %esi,%edx
  803b29:	29 f9                	sub    %edi,%ecx
  803b2b:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  803b2f:	89 14 24             	mov    %edx,(%esp)
  803b32:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  803b36:	8b 44 24 04          	mov    0x4(%esp),%eax
  803b3a:	8b 14 24             	mov    (%esp),%edx
  803b3d:	83 c4 1c             	add    $0x1c,%esp
  803b40:	5b                   	pop    %ebx
  803b41:	5e                   	pop    %esi
  803b42:	5f                   	pop    %edi
  803b43:	5d                   	pop    %ebp
  803b44:	c3                   	ret    
  803b45:	8d 76 00             	lea    0x0(%esi),%esi
  803b48:	2b 04 24             	sub    (%esp),%eax
  803b4b:	19 fa                	sbb    %edi,%edx
  803b4d:	89 d1                	mov    %edx,%ecx
  803b4f:	89 c6                	mov    %eax,%esi
  803b51:	e9 71 ff ff ff       	jmp    803ac7 <__umoddi3+0xb3>
  803b56:	66 90                	xchg   %ax,%ax
  803b58:	39 44 24 04          	cmp    %eax,0x4(%esp)
  803b5c:	72 ea                	jb     803b48 <__umoddi3+0x134>
  803b5e:	89 d9                	mov    %ebx,%ecx
  803b60:	e9 62 ff ff ff       	jmp    803ac7 <__umoddi3+0xb3>
