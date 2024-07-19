
obj/user/tst_first_fit_1:     file format elf32-i386


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
  800031:	e8 38 0b 00 00       	call   800b6e <libmain>
1:      jmp 1b
  800036:	eb fe                	jmp    800036 <args_exist+0x5>

00800038 <_main>:
/* MAKE SURE PAGE_WS_MAX_SIZE = 1000 */
/* *********************************************************** */
#include <inc/lib.h>

void _main(void)
{
  800038:	55                   	push   %ebp
  800039:	89 e5                	mov    %esp,%ebp
  80003b:	57                   	push   %edi
  80003c:	83 ec 74             	sub    $0x74,%esp
	sys_set_uheap_strategy(UHP_PLACE_FIRSTFIT);
  80003f:	83 ec 0c             	sub    $0xc,%esp
  800042:	6a 01                	push   $0x1
  800044:	e8 c8 27 00 00       	call   802811 <sys_set_uheap_strategy>
  800049:	83 c4 10             	add    $0x10,%esp

	//Initial test to ensure it works on "PLACEMENT" not "REPLACEMENT"
	{
		uint8 fullWS = 1;
  80004c:	c6 45 f7 01          	movb   $0x1,-0x9(%ebp)
		for (int i = 0; i < myEnv->page_WS_max_size; ++i)
  800050:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800057:	eb 29                	jmp    800082 <_main+0x4a>
		{
			if (myEnv->__uptr_pws[i].empty)
  800059:	a1 20 50 80 00       	mov    0x805020,%eax
  80005e:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  800064:	8b 55 f0             	mov    -0x10(%ebp),%edx
  800067:	89 d0                	mov    %edx,%eax
  800069:	01 c0                	add    %eax,%eax
  80006b:	01 d0                	add    %edx,%eax
  80006d:	c1 e0 03             	shl    $0x3,%eax
  800070:	01 c8                	add    %ecx,%eax
  800072:	8a 40 04             	mov    0x4(%eax),%al
  800075:	84 c0                	test   %al,%al
  800077:	74 06                	je     80007f <_main+0x47>
			{
				fullWS = 0;
  800079:	c6 45 f7 00          	movb   $0x0,-0x9(%ebp)
				break;
  80007d:	eb 12                	jmp    800091 <_main+0x59>
	sys_set_uheap_strategy(UHP_PLACE_FIRSTFIT);

	//Initial test to ensure it works on "PLACEMENT" not "REPLACEMENT"
	{
		uint8 fullWS = 1;
		for (int i = 0; i < myEnv->page_WS_max_size; ++i)
  80007f:	ff 45 f0             	incl   -0x10(%ebp)
  800082:	a1 20 50 80 00       	mov    0x805020,%eax
  800087:	8b 50 74             	mov    0x74(%eax),%edx
  80008a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80008d:	39 c2                	cmp    %eax,%edx
  80008f:	77 c8                	ja     800059 <_main+0x21>
			{
				fullWS = 0;
				break;
			}
		}
		if (fullWS) panic("Please increase the WS size");
  800091:	80 7d f7 00          	cmpb   $0x0,-0x9(%ebp)
  800095:	74 14                	je     8000ab <_main+0x73>
  800097:	83 ec 04             	sub    $0x4,%esp
  80009a:	68 00 3b 80 00       	push   $0x803b00
  80009f:	6a 15                	push   $0x15
  8000a1:	68 1c 3b 80 00       	push   $0x803b1c
  8000a6:	e8 ff 0b 00 00       	call   800caa <_panic>
	}

	int Mega = 1024*1024;
  8000ab:	c7 45 ec 00 00 10 00 	movl   $0x100000,-0x14(%ebp)
	int kilo = 1024;
  8000b2:	c7 45 e8 00 04 00 00 	movl   $0x400,-0x18(%ebp)
	/*Dummy malloc to enforce the UHEAP initializations*/
	malloc(0);
  8000b9:	83 ec 0c             	sub    $0xc,%esp
  8000bc:	6a 00                	push   $0x0
  8000be:	e8 2d 1e 00 00       	call   801ef0 <malloc>
  8000c3:	83 c4 10             	add    $0x10,%esp
	/*=================================================*/
	void* ptr_allocations[20] = {0};
  8000c6:	8d 55 90             	lea    -0x70(%ebp),%edx
  8000c9:	b9 14 00 00 00       	mov    $0x14,%ecx
  8000ce:	b8 00 00 00 00       	mov    $0x0,%eax
  8000d3:	89 d7                	mov    %edx,%edi
  8000d5:	f3 ab                	rep stos %eax,%es:(%edi)
	int freeFrames ;
	int usedDiskPages;
	//[1] Allocate all
	{
		//Allocate 1 MB
		freeFrames = sys_calculate_free_frames() ;
  8000d7:	e8 20 22 00 00       	call   8022fc <sys_calculate_free_frames>
  8000dc:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  8000df:	e8 b8 22 00 00       	call   80239c <sys_pf_calculate_allocated_pages>
  8000e4:	89 45 e0             	mov    %eax,-0x20(%ebp)
		ptr_allocations[0] = malloc(1*Mega-kilo);
  8000e7:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8000ea:	2b 45 e8             	sub    -0x18(%ebp),%eax
  8000ed:	83 ec 0c             	sub    $0xc,%esp
  8000f0:	50                   	push   %eax
  8000f1:	e8 fa 1d 00 00       	call   801ef0 <malloc>
  8000f6:	83 c4 10             	add    $0x10,%esp
  8000f9:	89 45 90             	mov    %eax,-0x70(%ebp)
		if ((uint32) ptr_allocations[0] != (USER_HEAP_START)) panic("Wrong start address for the allocated space... ");
  8000fc:	8b 45 90             	mov    -0x70(%ebp),%eax
  8000ff:	3d 00 00 00 80       	cmp    $0x80000000,%eax
  800104:	74 14                	je     80011a <_main+0xe2>
  800106:	83 ec 04             	sub    $0x4,%esp
  800109:	68 34 3b 80 00       	push   $0x803b34
  80010e:	6a 26                	push   $0x26
  800110:	68 1c 3b 80 00       	push   $0x803b1c
  800115:	e8 90 0b 00 00       	call   800caa <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 256+1 ) panic("Wrong allocation: ");
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  0) panic("Wrong page file allocation: ");
  80011a:	e8 7d 22 00 00       	call   80239c <sys_pf_calculate_allocated_pages>
  80011f:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  800122:	74 14                	je     800138 <_main+0x100>
  800124:	83 ec 04             	sub    $0x4,%esp
  800127:	68 64 3b 80 00       	push   $0x803b64
  80012c:	6a 28                	push   $0x28
  80012e:	68 1c 3b 80 00       	push   $0x803b1c
  800133:	e8 72 0b 00 00       	call   800caa <_panic>
		if ((freeFrames - sys_calculate_free_frames()) != 0 ) panic("Wrong allocation: ");
  800138:	e8 bf 21 00 00       	call   8022fc <sys_calculate_free_frames>
  80013d:	89 c2                	mov    %eax,%edx
  80013f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800142:	39 c2                	cmp    %eax,%edx
  800144:	74 14                	je     80015a <_main+0x122>
  800146:	83 ec 04             	sub    $0x4,%esp
  800149:	68 81 3b 80 00       	push   $0x803b81
  80014e:	6a 29                	push   $0x29
  800150:	68 1c 3b 80 00       	push   $0x803b1c
  800155:	e8 50 0b 00 00       	call   800caa <_panic>

		//Allocate 1 MB
		freeFrames = sys_calculate_free_frames() ;
  80015a:	e8 9d 21 00 00       	call   8022fc <sys_calculate_free_frames>
  80015f:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  800162:	e8 35 22 00 00       	call   80239c <sys_pf_calculate_allocated_pages>
  800167:	89 45 e0             	mov    %eax,-0x20(%ebp)
		ptr_allocations[1] = malloc(1*Mega-kilo);
  80016a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80016d:	2b 45 e8             	sub    -0x18(%ebp),%eax
  800170:	83 ec 0c             	sub    $0xc,%esp
  800173:	50                   	push   %eax
  800174:	e8 77 1d 00 00       	call   801ef0 <malloc>
  800179:	83 c4 10             	add    $0x10,%esp
  80017c:	89 45 94             	mov    %eax,-0x6c(%ebp)
		if ((uint32) ptr_allocations[1] != (USER_HEAP_START + 1*Mega)) panic("Wrong start address for the allocated space... ");
  80017f:	8b 45 94             	mov    -0x6c(%ebp),%eax
  800182:	89 c2                	mov    %eax,%edx
  800184:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800187:	05 00 00 00 80       	add    $0x80000000,%eax
  80018c:	39 c2                	cmp    %eax,%edx
  80018e:	74 14                	je     8001a4 <_main+0x16c>
  800190:	83 ec 04             	sub    $0x4,%esp
  800193:	68 34 3b 80 00       	push   $0x803b34
  800198:	6a 2f                	push   $0x2f
  80019a:	68 1c 3b 80 00       	push   $0x803b1c
  80019f:	e8 06 0b 00 00       	call   800caa <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 256 ) panic("Wrong allocation: ");
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  0) panic("Wrong page file allocation: ");
  8001a4:	e8 f3 21 00 00       	call   80239c <sys_pf_calculate_allocated_pages>
  8001a9:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  8001ac:	74 14                	je     8001c2 <_main+0x18a>
  8001ae:	83 ec 04             	sub    $0x4,%esp
  8001b1:	68 64 3b 80 00       	push   $0x803b64
  8001b6:	6a 31                	push   $0x31
  8001b8:	68 1c 3b 80 00       	push   $0x803b1c
  8001bd:	e8 e8 0a 00 00       	call   800caa <_panic>
		if ((freeFrames - sys_calculate_free_frames()) != 0 ) panic("Wrong allocation: ");
  8001c2:	e8 35 21 00 00       	call   8022fc <sys_calculate_free_frames>
  8001c7:	89 c2                	mov    %eax,%edx
  8001c9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8001cc:	39 c2                	cmp    %eax,%edx
  8001ce:	74 14                	je     8001e4 <_main+0x1ac>
  8001d0:	83 ec 04             	sub    $0x4,%esp
  8001d3:	68 81 3b 80 00       	push   $0x803b81
  8001d8:	6a 32                	push   $0x32
  8001da:	68 1c 3b 80 00       	push   $0x803b1c
  8001df:	e8 c6 0a 00 00       	call   800caa <_panic>

		//Allocate 1 MB
		freeFrames = sys_calculate_free_frames() ;
  8001e4:	e8 13 21 00 00       	call   8022fc <sys_calculate_free_frames>
  8001e9:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  8001ec:	e8 ab 21 00 00       	call   80239c <sys_pf_calculate_allocated_pages>
  8001f1:	89 45 e0             	mov    %eax,-0x20(%ebp)
		ptr_allocations[2] = malloc(1*Mega-kilo);
  8001f4:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8001f7:	2b 45 e8             	sub    -0x18(%ebp),%eax
  8001fa:	83 ec 0c             	sub    $0xc,%esp
  8001fd:	50                   	push   %eax
  8001fe:	e8 ed 1c 00 00       	call   801ef0 <malloc>
  800203:	83 c4 10             	add    $0x10,%esp
  800206:	89 45 98             	mov    %eax,-0x68(%ebp)
		if ((uint32) ptr_allocations[2] != (USER_HEAP_START + 2*Mega)) panic("Wrong start address for the allocated space... ");
  800209:	8b 45 98             	mov    -0x68(%ebp),%eax
  80020c:	89 c2                	mov    %eax,%edx
  80020e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800211:	01 c0                	add    %eax,%eax
  800213:	05 00 00 00 80       	add    $0x80000000,%eax
  800218:	39 c2                	cmp    %eax,%edx
  80021a:	74 14                	je     800230 <_main+0x1f8>
  80021c:	83 ec 04             	sub    $0x4,%esp
  80021f:	68 34 3b 80 00       	push   $0x803b34
  800224:	6a 38                	push   $0x38
  800226:	68 1c 3b 80 00       	push   $0x803b1c
  80022b:	e8 7a 0a 00 00       	call   800caa <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 256 ) panic("Wrong allocation: ");
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  0) panic("Wrong page file allocation: ");
  800230:	e8 67 21 00 00       	call   80239c <sys_pf_calculate_allocated_pages>
  800235:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  800238:	74 14                	je     80024e <_main+0x216>
  80023a:	83 ec 04             	sub    $0x4,%esp
  80023d:	68 64 3b 80 00       	push   $0x803b64
  800242:	6a 3a                	push   $0x3a
  800244:	68 1c 3b 80 00       	push   $0x803b1c
  800249:	e8 5c 0a 00 00       	call   800caa <_panic>
		if ((freeFrames - sys_calculate_free_frames()) != 0 ) panic("Wrong allocation: ");
  80024e:	e8 a9 20 00 00       	call   8022fc <sys_calculate_free_frames>
  800253:	89 c2                	mov    %eax,%edx
  800255:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800258:	39 c2                	cmp    %eax,%edx
  80025a:	74 14                	je     800270 <_main+0x238>
  80025c:	83 ec 04             	sub    $0x4,%esp
  80025f:	68 81 3b 80 00       	push   $0x803b81
  800264:	6a 3b                	push   $0x3b
  800266:	68 1c 3b 80 00       	push   $0x803b1c
  80026b:	e8 3a 0a 00 00       	call   800caa <_panic>

		//Allocate 1 MB
		freeFrames = sys_calculate_free_frames() ;
  800270:	e8 87 20 00 00       	call   8022fc <sys_calculate_free_frames>
  800275:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  800278:	e8 1f 21 00 00       	call   80239c <sys_pf_calculate_allocated_pages>
  80027d:	89 45 e0             	mov    %eax,-0x20(%ebp)
		ptr_allocations[3] = malloc(1*Mega-kilo);
  800280:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800283:	2b 45 e8             	sub    -0x18(%ebp),%eax
  800286:	83 ec 0c             	sub    $0xc,%esp
  800289:	50                   	push   %eax
  80028a:	e8 61 1c 00 00       	call   801ef0 <malloc>
  80028f:	83 c4 10             	add    $0x10,%esp
  800292:	89 45 9c             	mov    %eax,-0x64(%ebp)
		if ((uint32) ptr_allocations[3] != (USER_HEAP_START + 3*Mega) ) panic("Wrong start address for the allocated space... ");
  800295:	8b 45 9c             	mov    -0x64(%ebp),%eax
  800298:	89 c1                	mov    %eax,%ecx
  80029a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80029d:	89 c2                	mov    %eax,%edx
  80029f:	01 d2                	add    %edx,%edx
  8002a1:	01 d0                	add    %edx,%eax
  8002a3:	05 00 00 00 80       	add    $0x80000000,%eax
  8002a8:	39 c1                	cmp    %eax,%ecx
  8002aa:	74 14                	je     8002c0 <_main+0x288>
  8002ac:	83 ec 04             	sub    $0x4,%esp
  8002af:	68 34 3b 80 00       	push   $0x803b34
  8002b4:	6a 41                	push   $0x41
  8002b6:	68 1c 3b 80 00       	push   $0x803b1c
  8002bb:	e8 ea 09 00 00       	call   800caa <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 256 ) panic("Wrong allocation: ");
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  0) panic("Wrong page file allocation: ");
  8002c0:	e8 d7 20 00 00       	call   80239c <sys_pf_calculate_allocated_pages>
  8002c5:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  8002c8:	74 14                	je     8002de <_main+0x2a6>
  8002ca:	83 ec 04             	sub    $0x4,%esp
  8002cd:	68 64 3b 80 00       	push   $0x803b64
  8002d2:	6a 43                	push   $0x43
  8002d4:	68 1c 3b 80 00       	push   $0x803b1c
  8002d9:	e8 cc 09 00 00       	call   800caa <_panic>
		if ((freeFrames - sys_calculate_free_frames()) != 0 ) panic("Wrong allocation: ");
  8002de:	e8 19 20 00 00       	call   8022fc <sys_calculate_free_frames>
  8002e3:	89 c2                	mov    %eax,%edx
  8002e5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8002e8:	39 c2                	cmp    %eax,%edx
  8002ea:	74 14                	je     800300 <_main+0x2c8>
  8002ec:	83 ec 04             	sub    $0x4,%esp
  8002ef:	68 81 3b 80 00       	push   $0x803b81
  8002f4:	6a 44                	push   $0x44
  8002f6:	68 1c 3b 80 00       	push   $0x803b1c
  8002fb:	e8 aa 09 00 00       	call   800caa <_panic>

		//Allocate 2 MB
		freeFrames = sys_calculate_free_frames() ;
  800300:	e8 f7 1f 00 00       	call   8022fc <sys_calculate_free_frames>
  800305:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  800308:	e8 8f 20 00 00       	call   80239c <sys_pf_calculate_allocated_pages>
  80030d:	89 45 e0             	mov    %eax,-0x20(%ebp)
		ptr_allocations[4] = malloc(2*Mega-kilo);
  800310:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800313:	01 c0                	add    %eax,%eax
  800315:	2b 45 e8             	sub    -0x18(%ebp),%eax
  800318:	83 ec 0c             	sub    $0xc,%esp
  80031b:	50                   	push   %eax
  80031c:	e8 cf 1b 00 00       	call   801ef0 <malloc>
  800321:	83 c4 10             	add    $0x10,%esp
  800324:	89 45 a0             	mov    %eax,-0x60(%ebp)
		if ((uint32) ptr_allocations[4] != (USER_HEAP_START + 4*Mega)) panic("Wrong start address for the allocated space... ");
  800327:	8b 45 a0             	mov    -0x60(%ebp),%eax
  80032a:	89 c2                	mov    %eax,%edx
  80032c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80032f:	c1 e0 02             	shl    $0x2,%eax
  800332:	05 00 00 00 80       	add    $0x80000000,%eax
  800337:	39 c2                	cmp    %eax,%edx
  800339:	74 14                	je     80034f <_main+0x317>
  80033b:	83 ec 04             	sub    $0x4,%esp
  80033e:	68 34 3b 80 00       	push   $0x803b34
  800343:	6a 4a                	push   $0x4a
  800345:	68 1c 3b 80 00       	push   $0x803b1c
  80034a:	e8 5b 09 00 00       	call   800caa <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 512 + 1) panic("Wrong allocation: ");
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  0) panic("Wrong page file allocation: ");
  80034f:	e8 48 20 00 00       	call   80239c <sys_pf_calculate_allocated_pages>
  800354:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  800357:	74 14                	je     80036d <_main+0x335>
  800359:	83 ec 04             	sub    $0x4,%esp
  80035c:	68 64 3b 80 00       	push   $0x803b64
  800361:	6a 4c                	push   $0x4c
  800363:	68 1c 3b 80 00       	push   $0x803b1c
  800368:	e8 3d 09 00 00       	call   800caa <_panic>
		if ((freeFrames - sys_calculate_free_frames()) != 0) panic("Wrong allocation: ");
  80036d:	e8 8a 1f 00 00       	call   8022fc <sys_calculate_free_frames>
  800372:	89 c2                	mov    %eax,%edx
  800374:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800377:	39 c2                	cmp    %eax,%edx
  800379:	74 14                	je     80038f <_main+0x357>
  80037b:	83 ec 04             	sub    $0x4,%esp
  80037e:	68 81 3b 80 00       	push   $0x803b81
  800383:	6a 4d                	push   $0x4d
  800385:	68 1c 3b 80 00       	push   $0x803b1c
  80038a:	e8 1b 09 00 00       	call   800caa <_panic>

		//Allocate 2 MB
		freeFrames = sys_calculate_free_frames() ;
  80038f:	e8 68 1f 00 00       	call   8022fc <sys_calculate_free_frames>
  800394:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  800397:	e8 00 20 00 00       	call   80239c <sys_pf_calculate_allocated_pages>
  80039c:	89 45 e0             	mov    %eax,-0x20(%ebp)
		ptr_allocations[5] = malloc(2*Mega-kilo);
  80039f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8003a2:	01 c0                	add    %eax,%eax
  8003a4:	2b 45 e8             	sub    -0x18(%ebp),%eax
  8003a7:	83 ec 0c             	sub    $0xc,%esp
  8003aa:	50                   	push   %eax
  8003ab:	e8 40 1b 00 00       	call   801ef0 <malloc>
  8003b0:	83 c4 10             	add    $0x10,%esp
  8003b3:	89 45 a4             	mov    %eax,-0x5c(%ebp)
		if ((uint32) ptr_allocations[5] != (USER_HEAP_START + 6*Mega)) panic("Wrong start address for the allocated space... ");
  8003b6:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  8003b9:	89 c1                	mov    %eax,%ecx
  8003bb:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8003be:	89 d0                	mov    %edx,%eax
  8003c0:	01 c0                	add    %eax,%eax
  8003c2:	01 d0                	add    %edx,%eax
  8003c4:	01 c0                	add    %eax,%eax
  8003c6:	05 00 00 00 80       	add    $0x80000000,%eax
  8003cb:	39 c1                	cmp    %eax,%ecx
  8003cd:	74 14                	je     8003e3 <_main+0x3ab>
  8003cf:	83 ec 04             	sub    $0x4,%esp
  8003d2:	68 34 3b 80 00       	push   $0x803b34
  8003d7:	6a 53                	push   $0x53
  8003d9:	68 1c 3b 80 00       	push   $0x803b1c
  8003de:	e8 c7 08 00 00       	call   800caa <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 512) panic("Wrong allocation: ");
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  0) panic("Wrong page file allocation: ");
  8003e3:	e8 b4 1f 00 00       	call   80239c <sys_pf_calculate_allocated_pages>
  8003e8:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  8003eb:	74 14                	je     800401 <_main+0x3c9>
  8003ed:	83 ec 04             	sub    $0x4,%esp
  8003f0:	68 64 3b 80 00       	push   $0x803b64
  8003f5:	6a 55                	push   $0x55
  8003f7:	68 1c 3b 80 00       	push   $0x803b1c
  8003fc:	e8 a9 08 00 00       	call   800caa <_panic>
		if ((freeFrames - sys_calculate_free_frames()) != 0) panic("Wrong allocation: ");
  800401:	e8 f6 1e 00 00       	call   8022fc <sys_calculate_free_frames>
  800406:	89 c2                	mov    %eax,%edx
  800408:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80040b:	39 c2                	cmp    %eax,%edx
  80040d:	74 14                	je     800423 <_main+0x3eb>
  80040f:	83 ec 04             	sub    $0x4,%esp
  800412:	68 81 3b 80 00       	push   $0x803b81
  800417:	6a 56                	push   $0x56
  800419:	68 1c 3b 80 00       	push   $0x803b1c
  80041e:	e8 87 08 00 00       	call   800caa <_panic>

		//Allocate 3 MB
		freeFrames = sys_calculate_free_frames() ;
  800423:	e8 d4 1e 00 00       	call   8022fc <sys_calculate_free_frames>
  800428:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  80042b:	e8 6c 1f 00 00       	call   80239c <sys_pf_calculate_allocated_pages>
  800430:	89 45 e0             	mov    %eax,-0x20(%ebp)
		ptr_allocations[6] = malloc(3*Mega-kilo);
  800433:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800436:	89 c2                	mov    %eax,%edx
  800438:	01 d2                	add    %edx,%edx
  80043a:	01 d0                	add    %edx,%eax
  80043c:	2b 45 e8             	sub    -0x18(%ebp),%eax
  80043f:	83 ec 0c             	sub    $0xc,%esp
  800442:	50                   	push   %eax
  800443:	e8 a8 1a 00 00       	call   801ef0 <malloc>
  800448:	83 c4 10             	add    $0x10,%esp
  80044b:	89 45 a8             	mov    %eax,-0x58(%ebp)
		if ((uint32) ptr_allocations[6] != (USER_HEAP_START + 8*Mega)) panic("Wrong start address for the allocated space... ");
  80044e:	8b 45 a8             	mov    -0x58(%ebp),%eax
  800451:	89 c2                	mov    %eax,%edx
  800453:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800456:	c1 e0 03             	shl    $0x3,%eax
  800459:	05 00 00 00 80       	add    $0x80000000,%eax
  80045e:	39 c2                	cmp    %eax,%edx
  800460:	74 14                	je     800476 <_main+0x43e>
  800462:	83 ec 04             	sub    $0x4,%esp
  800465:	68 34 3b 80 00       	push   $0x803b34
  80046a:	6a 5c                	push   $0x5c
  80046c:	68 1c 3b 80 00       	push   $0x803b1c
  800471:	e8 34 08 00 00       	call   800caa <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 768 + 1) panic("Wrong allocation: ");
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  0) panic("Wrong page file allocation: ");
  800476:	e8 21 1f 00 00       	call   80239c <sys_pf_calculate_allocated_pages>
  80047b:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  80047e:	74 14                	je     800494 <_main+0x45c>
  800480:	83 ec 04             	sub    $0x4,%esp
  800483:	68 64 3b 80 00       	push   $0x803b64
  800488:	6a 5e                	push   $0x5e
  80048a:	68 1c 3b 80 00       	push   $0x803b1c
  80048f:	e8 16 08 00 00       	call   800caa <_panic>
		if ((freeFrames - sys_calculate_free_frames()) != 0) panic("Wrong allocation: ");
  800494:	e8 63 1e 00 00       	call   8022fc <sys_calculate_free_frames>
  800499:	89 c2                	mov    %eax,%edx
  80049b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80049e:	39 c2                	cmp    %eax,%edx
  8004a0:	74 14                	je     8004b6 <_main+0x47e>
  8004a2:	83 ec 04             	sub    $0x4,%esp
  8004a5:	68 81 3b 80 00       	push   $0x803b81
  8004aa:	6a 5f                	push   $0x5f
  8004ac:	68 1c 3b 80 00       	push   $0x803b1c
  8004b1:	e8 f4 07 00 00       	call   800caa <_panic>

		//Allocate 3 MB
		freeFrames = sys_calculate_free_frames() ;
  8004b6:	e8 41 1e 00 00       	call   8022fc <sys_calculate_free_frames>
  8004bb:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  8004be:	e8 d9 1e 00 00       	call   80239c <sys_pf_calculate_allocated_pages>
  8004c3:	89 45 e0             	mov    %eax,-0x20(%ebp)
		ptr_allocations[7] = malloc(3*Mega-kilo);
  8004c6:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8004c9:	89 c2                	mov    %eax,%edx
  8004cb:	01 d2                	add    %edx,%edx
  8004cd:	01 d0                	add    %edx,%eax
  8004cf:	2b 45 e8             	sub    -0x18(%ebp),%eax
  8004d2:	83 ec 0c             	sub    $0xc,%esp
  8004d5:	50                   	push   %eax
  8004d6:	e8 15 1a 00 00       	call   801ef0 <malloc>
  8004db:	83 c4 10             	add    $0x10,%esp
  8004de:	89 45 ac             	mov    %eax,-0x54(%ebp)
		if ((uint32) ptr_allocations[7] != (USER_HEAP_START + 11*Mega)) panic("Wrong start address for the allocated space... ");
  8004e1:	8b 45 ac             	mov    -0x54(%ebp),%eax
  8004e4:	89 c1                	mov    %eax,%ecx
  8004e6:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8004e9:	89 d0                	mov    %edx,%eax
  8004eb:	c1 e0 02             	shl    $0x2,%eax
  8004ee:	01 d0                	add    %edx,%eax
  8004f0:	01 c0                	add    %eax,%eax
  8004f2:	01 d0                	add    %edx,%eax
  8004f4:	05 00 00 00 80       	add    $0x80000000,%eax
  8004f9:	39 c1                	cmp    %eax,%ecx
  8004fb:	74 14                	je     800511 <_main+0x4d9>
  8004fd:	83 ec 04             	sub    $0x4,%esp
  800500:	68 34 3b 80 00       	push   $0x803b34
  800505:	6a 65                	push   $0x65
  800507:	68 1c 3b 80 00       	push   $0x803b1c
  80050c:	e8 99 07 00 00       	call   800caa <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 768 + 1) panic("Wrong allocation: ");
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  0) panic("Wrong page file allocation: ");
  800511:	e8 86 1e 00 00       	call   80239c <sys_pf_calculate_allocated_pages>
  800516:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  800519:	74 14                	je     80052f <_main+0x4f7>
  80051b:	83 ec 04             	sub    $0x4,%esp
  80051e:	68 64 3b 80 00       	push   $0x803b64
  800523:	6a 67                	push   $0x67
  800525:	68 1c 3b 80 00       	push   $0x803b1c
  80052a:	e8 7b 07 00 00       	call   800caa <_panic>
		if ((freeFrames - sys_calculate_free_frames()) != 0) panic("Wrong allocation: ");
  80052f:	e8 c8 1d 00 00       	call   8022fc <sys_calculate_free_frames>
  800534:	89 c2                	mov    %eax,%edx
  800536:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800539:	39 c2                	cmp    %eax,%edx
  80053b:	74 14                	je     800551 <_main+0x519>
  80053d:	83 ec 04             	sub    $0x4,%esp
  800540:	68 81 3b 80 00       	push   $0x803b81
  800545:	6a 68                	push   $0x68
  800547:	68 1c 3b 80 00       	push   $0x803b1c
  80054c:	e8 59 07 00 00       	call   800caa <_panic>
	}

	//[2] Free some to create holes
	{
		//1 MB Hole
		freeFrames = sys_calculate_free_frames() ;
  800551:	e8 a6 1d 00 00       	call   8022fc <sys_calculate_free_frames>
  800556:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  800559:	e8 3e 1e 00 00       	call   80239c <sys_pf_calculate_allocated_pages>
  80055e:	89 45 e0             	mov    %eax,-0x20(%ebp)
		free(ptr_allocations[1]);
  800561:	8b 45 94             	mov    -0x6c(%ebp),%eax
  800564:	83 ec 0c             	sub    $0xc,%esp
  800567:	50                   	push   %eax
  800568:	e8 04 1a 00 00       	call   801f71 <free>
  80056d:	83 c4 10             	add    $0x10,%esp
		//if ((sys_calculate_free_frames() - freeFrames) != 256) panic("Wrong free: ");
		if( (usedDiskPages - sys_pf_calculate_allocated_pages()) !=  0) panic("Wrong page file free: ");
  800570:	e8 27 1e 00 00       	call   80239c <sys_pf_calculate_allocated_pages>
  800575:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  800578:	74 14                	je     80058e <_main+0x556>
  80057a:	83 ec 04             	sub    $0x4,%esp
  80057d:	68 94 3b 80 00       	push   $0x803b94
  800582:	6a 72                	push   $0x72
  800584:	68 1c 3b 80 00       	push   $0x803b1c
  800589:	e8 1c 07 00 00       	call   800caa <_panic>
		if ((sys_calculate_free_frames() - freeFrames) != 0) panic("Wrong free: ");
  80058e:	e8 69 1d 00 00       	call   8022fc <sys_calculate_free_frames>
  800593:	89 c2                	mov    %eax,%edx
  800595:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800598:	39 c2                	cmp    %eax,%edx
  80059a:	74 14                	je     8005b0 <_main+0x578>
  80059c:	83 ec 04             	sub    $0x4,%esp
  80059f:	68 ab 3b 80 00       	push   $0x803bab
  8005a4:	6a 73                	push   $0x73
  8005a6:	68 1c 3b 80 00       	push   $0x803b1c
  8005ab:	e8 fa 06 00 00       	call   800caa <_panic>

		//2 MB Hole
		freeFrames = sys_calculate_free_frames() ;
  8005b0:	e8 47 1d 00 00       	call   8022fc <sys_calculate_free_frames>
  8005b5:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  8005b8:	e8 df 1d 00 00       	call   80239c <sys_pf_calculate_allocated_pages>
  8005bd:	89 45 e0             	mov    %eax,-0x20(%ebp)
		free(ptr_allocations[4]);
  8005c0:	8b 45 a0             	mov    -0x60(%ebp),%eax
  8005c3:	83 ec 0c             	sub    $0xc,%esp
  8005c6:	50                   	push   %eax
  8005c7:	e8 a5 19 00 00       	call   801f71 <free>
  8005cc:	83 c4 10             	add    $0x10,%esp
		//if ((sys_calculate_free_frames() - freeFrames) != 512) panic("Wrong free: ");
		if( (usedDiskPages - sys_pf_calculate_allocated_pages()) !=  0) panic("Wrong page file free: ");
  8005cf:	e8 c8 1d 00 00       	call   80239c <sys_pf_calculate_allocated_pages>
  8005d4:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  8005d7:	74 14                	je     8005ed <_main+0x5b5>
  8005d9:	83 ec 04             	sub    $0x4,%esp
  8005dc:	68 94 3b 80 00       	push   $0x803b94
  8005e1:	6a 7a                	push   $0x7a
  8005e3:	68 1c 3b 80 00       	push   $0x803b1c
  8005e8:	e8 bd 06 00 00       	call   800caa <_panic>
		if ((sys_calculate_free_frames() - freeFrames) != 0) panic("Wrong free: ");
  8005ed:	e8 0a 1d 00 00       	call   8022fc <sys_calculate_free_frames>
  8005f2:	89 c2                	mov    %eax,%edx
  8005f4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8005f7:	39 c2                	cmp    %eax,%edx
  8005f9:	74 14                	je     80060f <_main+0x5d7>
  8005fb:	83 ec 04             	sub    $0x4,%esp
  8005fe:	68 ab 3b 80 00       	push   $0x803bab
  800603:	6a 7b                	push   $0x7b
  800605:	68 1c 3b 80 00       	push   $0x803b1c
  80060a:	e8 9b 06 00 00       	call   800caa <_panic>

		//3 MB Hole
		freeFrames = sys_calculate_free_frames() ;
  80060f:	e8 e8 1c 00 00       	call   8022fc <sys_calculate_free_frames>
  800614:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  800617:	e8 80 1d 00 00       	call   80239c <sys_pf_calculate_allocated_pages>
  80061c:	89 45 e0             	mov    %eax,-0x20(%ebp)
		free(ptr_allocations[6]);
  80061f:	8b 45 a8             	mov    -0x58(%ebp),%eax
  800622:	83 ec 0c             	sub    $0xc,%esp
  800625:	50                   	push   %eax
  800626:	e8 46 19 00 00       	call   801f71 <free>
  80062b:	83 c4 10             	add    $0x10,%esp
		//if ((sys_calculate_free_frames() - freeFrames) != 768) panic("Wrong free: ");
		if( (usedDiskPages - sys_pf_calculate_allocated_pages()) !=  0) panic("Wrong page file free: ");
  80062e:	e8 69 1d 00 00       	call   80239c <sys_pf_calculate_allocated_pages>
  800633:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  800636:	74 17                	je     80064f <_main+0x617>
  800638:	83 ec 04             	sub    $0x4,%esp
  80063b:	68 94 3b 80 00       	push   $0x803b94
  800640:	68 82 00 00 00       	push   $0x82
  800645:	68 1c 3b 80 00       	push   $0x803b1c
  80064a:	e8 5b 06 00 00       	call   800caa <_panic>
		if ((sys_calculate_free_frames() - freeFrames) != 0) panic("Wrong free: ");
  80064f:	e8 a8 1c 00 00       	call   8022fc <sys_calculate_free_frames>
  800654:	89 c2                	mov    %eax,%edx
  800656:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800659:	39 c2                	cmp    %eax,%edx
  80065b:	74 17                	je     800674 <_main+0x63c>
  80065d:	83 ec 04             	sub    $0x4,%esp
  800660:	68 ab 3b 80 00       	push   $0x803bab
  800665:	68 83 00 00 00       	push   $0x83
  80066a:	68 1c 3b 80 00       	push   $0x803b1c
  80066f:	e8 36 06 00 00       	call   800caa <_panic>
	}

	//[3] Allocate again [test first fit]
	{
		//Allocate 512 KB - should be placed in 1st hole
		freeFrames = sys_calculate_free_frames() ;
  800674:	e8 83 1c 00 00       	call   8022fc <sys_calculate_free_frames>
  800679:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  80067c:	e8 1b 1d 00 00       	call   80239c <sys_pf_calculate_allocated_pages>
  800681:	89 45 e0             	mov    %eax,-0x20(%ebp)
		ptr_allocations[8] = malloc(512*kilo - kilo);
  800684:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800687:	89 d0                	mov    %edx,%eax
  800689:	c1 e0 09             	shl    $0x9,%eax
  80068c:	29 d0                	sub    %edx,%eax
  80068e:	83 ec 0c             	sub    $0xc,%esp
  800691:	50                   	push   %eax
  800692:	e8 59 18 00 00       	call   801ef0 <malloc>
  800697:	83 c4 10             	add    $0x10,%esp
  80069a:	89 45 b0             	mov    %eax,-0x50(%ebp)
		if ((uint32) ptr_allocations[8] != (USER_HEAP_START + 1*Mega)) panic("Wrong start address for the allocated space... ");
  80069d:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8006a0:	89 c2                	mov    %eax,%edx
  8006a2:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8006a5:	05 00 00 00 80       	add    $0x80000000,%eax
  8006aa:	39 c2                	cmp    %eax,%edx
  8006ac:	74 17                	je     8006c5 <_main+0x68d>
  8006ae:	83 ec 04             	sub    $0x4,%esp
  8006b1:	68 34 3b 80 00       	push   $0x803b34
  8006b6:	68 8c 00 00 00       	push   $0x8c
  8006bb:	68 1c 3b 80 00       	push   $0x803b1c
  8006c0:	e8 e5 05 00 00       	call   800caa <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 128) panic("Wrong allocation: ");
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  0) panic("Wrong page file allocation: ");
  8006c5:	e8 d2 1c 00 00       	call   80239c <sys_pf_calculate_allocated_pages>
  8006ca:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  8006cd:	74 17                	je     8006e6 <_main+0x6ae>
  8006cf:	83 ec 04             	sub    $0x4,%esp
  8006d2:	68 64 3b 80 00       	push   $0x803b64
  8006d7:	68 8e 00 00 00       	push   $0x8e
  8006dc:	68 1c 3b 80 00       	push   $0x803b1c
  8006e1:	e8 c4 05 00 00       	call   800caa <_panic>
		if ((freeFrames - sys_calculate_free_frames()) != 0) panic("Wrong allocation: ");
  8006e6:	e8 11 1c 00 00       	call   8022fc <sys_calculate_free_frames>
  8006eb:	89 c2                	mov    %eax,%edx
  8006ed:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8006f0:	39 c2                	cmp    %eax,%edx
  8006f2:	74 17                	je     80070b <_main+0x6d3>
  8006f4:	83 ec 04             	sub    $0x4,%esp
  8006f7:	68 81 3b 80 00       	push   $0x803b81
  8006fc:	68 8f 00 00 00       	push   $0x8f
  800701:	68 1c 3b 80 00       	push   $0x803b1c
  800706:	e8 9f 05 00 00       	call   800caa <_panic>

		//Allocate 1 MB - should be placed in 2nd hole
		freeFrames = sys_calculate_free_frames() ;
  80070b:	e8 ec 1b 00 00       	call   8022fc <sys_calculate_free_frames>
  800710:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  800713:	e8 84 1c 00 00       	call   80239c <sys_pf_calculate_allocated_pages>
  800718:	89 45 e0             	mov    %eax,-0x20(%ebp)
		ptr_allocations[9] = malloc(1*Mega - kilo);
  80071b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80071e:	2b 45 e8             	sub    -0x18(%ebp),%eax
  800721:	83 ec 0c             	sub    $0xc,%esp
  800724:	50                   	push   %eax
  800725:	e8 c6 17 00 00       	call   801ef0 <malloc>
  80072a:	83 c4 10             	add    $0x10,%esp
  80072d:	89 45 b4             	mov    %eax,-0x4c(%ebp)
		if ((uint32) ptr_allocations[9] != (USER_HEAP_START + 4*Mega)) panic("Wrong start address for the allocated space... ");
  800730:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  800733:	89 c2                	mov    %eax,%edx
  800735:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800738:	c1 e0 02             	shl    $0x2,%eax
  80073b:	05 00 00 00 80       	add    $0x80000000,%eax
  800740:	39 c2                	cmp    %eax,%edx
  800742:	74 17                	je     80075b <_main+0x723>
  800744:	83 ec 04             	sub    $0x4,%esp
  800747:	68 34 3b 80 00       	push   $0x803b34
  80074c:	68 95 00 00 00       	push   $0x95
  800751:	68 1c 3b 80 00       	push   $0x803b1c
  800756:	e8 4f 05 00 00       	call   800caa <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 256) panic("Wrong allocation: ");
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  0) panic("Wrong page file allocation: ");
  80075b:	e8 3c 1c 00 00       	call   80239c <sys_pf_calculate_allocated_pages>
  800760:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  800763:	74 17                	je     80077c <_main+0x744>
  800765:	83 ec 04             	sub    $0x4,%esp
  800768:	68 64 3b 80 00       	push   $0x803b64
  80076d:	68 97 00 00 00       	push   $0x97
  800772:	68 1c 3b 80 00       	push   $0x803b1c
  800777:	e8 2e 05 00 00       	call   800caa <_panic>
		if ((freeFrames - sys_calculate_free_frames()) != 0) panic("Wrong allocation: ");
  80077c:	e8 7b 1b 00 00       	call   8022fc <sys_calculate_free_frames>
  800781:	89 c2                	mov    %eax,%edx
  800783:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800786:	39 c2                	cmp    %eax,%edx
  800788:	74 17                	je     8007a1 <_main+0x769>
  80078a:	83 ec 04             	sub    $0x4,%esp
  80078d:	68 81 3b 80 00       	push   $0x803b81
  800792:	68 98 00 00 00       	push   $0x98
  800797:	68 1c 3b 80 00       	push   $0x803b1c
  80079c:	e8 09 05 00 00       	call   800caa <_panic>

		//Allocate 256 KB - should be placed in remaining of 1st hole
		freeFrames = sys_calculate_free_frames() ;
  8007a1:	e8 56 1b 00 00       	call   8022fc <sys_calculate_free_frames>
  8007a6:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  8007a9:	e8 ee 1b 00 00       	call   80239c <sys_pf_calculate_allocated_pages>
  8007ae:	89 45 e0             	mov    %eax,-0x20(%ebp)
		ptr_allocations[10] = malloc(256*kilo - kilo);
  8007b1:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8007b4:	89 d0                	mov    %edx,%eax
  8007b6:	c1 e0 08             	shl    $0x8,%eax
  8007b9:	29 d0                	sub    %edx,%eax
  8007bb:	83 ec 0c             	sub    $0xc,%esp
  8007be:	50                   	push   %eax
  8007bf:	e8 2c 17 00 00       	call   801ef0 <malloc>
  8007c4:	83 c4 10             	add    $0x10,%esp
  8007c7:	89 45 b8             	mov    %eax,-0x48(%ebp)
		if ((uint32) ptr_allocations[10] != (USER_HEAP_START + 1*Mega + 512*kilo)) panic("Wrong start address for the allocated space... ");
  8007ca:	8b 45 b8             	mov    -0x48(%ebp),%eax
  8007cd:	89 c2                	mov    %eax,%edx
  8007cf:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8007d2:	c1 e0 09             	shl    $0x9,%eax
  8007d5:	89 c1                	mov    %eax,%ecx
  8007d7:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8007da:	01 c8                	add    %ecx,%eax
  8007dc:	05 00 00 00 80       	add    $0x80000000,%eax
  8007e1:	39 c2                	cmp    %eax,%edx
  8007e3:	74 17                	je     8007fc <_main+0x7c4>
  8007e5:	83 ec 04             	sub    $0x4,%esp
  8007e8:	68 34 3b 80 00       	push   $0x803b34
  8007ed:	68 9e 00 00 00       	push   $0x9e
  8007f2:	68 1c 3b 80 00       	push   $0x803b1c
  8007f7:	e8 ae 04 00 00       	call   800caa <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 64) panic("Wrong allocation: ");
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  0) panic("Wrong page file allocation: ");
  8007fc:	e8 9b 1b 00 00       	call   80239c <sys_pf_calculate_allocated_pages>
  800801:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  800804:	74 17                	je     80081d <_main+0x7e5>
  800806:	83 ec 04             	sub    $0x4,%esp
  800809:	68 64 3b 80 00       	push   $0x803b64
  80080e:	68 a0 00 00 00       	push   $0xa0
  800813:	68 1c 3b 80 00       	push   $0x803b1c
  800818:	e8 8d 04 00 00       	call   800caa <_panic>
		if ((freeFrames - sys_calculate_free_frames()) != 0) panic("Wrong allocation: ");
  80081d:	e8 da 1a 00 00       	call   8022fc <sys_calculate_free_frames>
  800822:	89 c2                	mov    %eax,%edx
  800824:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800827:	39 c2                	cmp    %eax,%edx
  800829:	74 17                	je     800842 <_main+0x80a>
  80082b:	83 ec 04             	sub    $0x4,%esp
  80082e:	68 81 3b 80 00       	push   $0x803b81
  800833:	68 a1 00 00 00       	push   $0xa1
  800838:	68 1c 3b 80 00       	push   $0x803b1c
  80083d:	e8 68 04 00 00       	call   800caa <_panic>

		//Allocate 2 MB - should be placed in 3rd hole
		freeFrames = sys_calculate_free_frames() ;
  800842:	e8 b5 1a 00 00       	call   8022fc <sys_calculate_free_frames>
  800847:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  80084a:	e8 4d 1b 00 00       	call   80239c <sys_pf_calculate_allocated_pages>
  80084f:	89 45 e0             	mov    %eax,-0x20(%ebp)
		ptr_allocations[11] = malloc(2*Mega);
  800852:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800855:	01 c0                	add    %eax,%eax
  800857:	83 ec 0c             	sub    $0xc,%esp
  80085a:	50                   	push   %eax
  80085b:	e8 90 16 00 00       	call   801ef0 <malloc>
  800860:	83 c4 10             	add    $0x10,%esp
  800863:	89 45 bc             	mov    %eax,-0x44(%ebp)
		if ((uint32) ptr_allocations[11] != (USER_HEAP_START + 8*Mega)) panic("Wrong start address for the allocated space... ");
  800866:	8b 45 bc             	mov    -0x44(%ebp),%eax
  800869:	89 c2                	mov    %eax,%edx
  80086b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80086e:	c1 e0 03             	shl    $0x3,%eax
  800871:	05 00 00 00 80       	add    $0x80000000,%eax
  800876:	39 c2                	cmp    %eax,%edx
  800878:	74 17                	je     800891 <_main+0x859>
  80087a:	83 ec 04             	sub    $0x4,%esp
  80087d:	68 34 3b 80 00       	push   $0x803b34
  800882:	68 a7 00 00 00       	push   $0xa7
  800887:	68 1c 3b 80 00       	push   $0x803b1c
  80088c:	e8 19 04 00 00       	call   800caa <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 256) panic("Wrong allocation: ");
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  0) panic("Wrong page file allocation: ");
  800891:	e8 06 1b 00 00       	call   80239c <sys_pf_calculate_allocated_pages>
  800896:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  800899:	74 17                	je     8008b2 <_main+0x87a>
  80089b:	83 ec 04             	sub    $0x4,%esp
  80089e:	68 64 3b 80 00       	push   $0x803b64
  8008a3:	68 a9 00 00 00       	push   $0xa9
  8008a8:	68 1c 3b 80 00       	push   $0x803b1c
  8008ad:	e8 f8 03 00 00       	call   800caa <_panic>
		if ((freeFrames - sys_calculate_free_frames()) != 0) panic("Wrong allocation: ");
  8008b2:	e8 45 1a 00 00       	call   8022fc <sys_calculate_free_frames>
  8008b7:	89 c2                	mov    %eax,%edx
  8008b9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8008bc:	39 c2                	cmp    %eax,%edx
  8008be:	74 17                	je     8008d7 <_main+0x89f>
  8008c0:	83 ec 04             	sub    $0x4,%esp
  8008c3:	68 81 3b 80 00       	push   $0x803b81
  8008c8:	68 aa 00 00 00       	push   $0xaa
  8008cd:	68 1c 3b 80 00       	push   $0x803b1c
  8008d2:	e8 d3 03 00 00       	call   800caa <_panic>

		//Allocate 4 MB - should be placed in end of all allocations
		freeFrames = sys_calculate_free_frames() ;
  8008d7:	e8 20 1a 00 00       	call   8022fc <sys_calculate_free_frames>
  8008dc:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  8008df:	e8 b8 1a 00 00       	call   80239c <sys_pf_calculate_allocated_pages>
  8008e4:	89 45 e0             	mov    %eax,-0x20(%ebp)
		ptr_allocations[12] = malloc(4*Mega - kilo);
  8008e7:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8008ea:	c1 e0 02             	shl    $0x2,%eax
  8008ed:	2b 45 e8             	sub    -0x18(%ebp),%eax
  8008f0:	83 ec 0c             	sub    $0xc,%esp
  8008f3:	50                   	push   %eax
  8008f4:	e8 f7 15 00 00       	call   801ef0 <malloc>
  8008f9:	83 c4 10             	add    $0x10,%esp
  8008fc:	89 45 c0             	mov    %eax,-0x40(%ebp)
		if ((uint32) ptr_allocations[12] != (USER_HEAP_START + 14*Mega) ) panic("Wrong start address for the allocated space... ");
  8008ff:	8b 45 c0             	mov    -0x40(%ebp),%eax
  800902:	89 c1                	mov    %eax,%ecx
  800904:	8b 55 ec             	mov    -0x14(%ebp),%edx
  800907:	89 d0                	mov    %edx,%eax
  800909:	01 c0                	add    %eax,%eax
  80090b:	01 d0                	add    %edx,%eax
  80090d:	01 c0                	add    %eax,%eax
  80090f:	01 d0                	add    %edx,%eax
  800911:	01 c0                	add    %eax,%eax
  800913:	05 00 00 00 80       	add    $0x80000000,%eax
  800918:	39 c1                	cmp    %eax,%ecx
  80091a:	74 17                	je     800933 <_main+0x8fb>
  80091c:	83 ec 04             	sub    $0x4,%esp
  80091f:	68 34 3b 80 00       	push   $0x803b34
  800924:	68 b0 00 00 00       	push   $0xb0
  800929:	68 1c 3b 80 00       	push   $0x803b1c
  80092e:	e8 77 03 00 00       	call   800caa <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 1024 + 1) panic("Wrong allocation: ");
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  0) panic("Wrong page file allocation: ");
  800933:	e8 64 1a 00 00       	call   80239c <sys_pf_calculate_allocated_pages>
  800938:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  80093b:	74 17                	je     800954 <_main+0x91c>
  80093d:	83 ec 04             	sub    $0x4,%esp
  800940:	68 64 3b 80 00       	push   $0x803b64
  800945:	68 b2 00 00 00       	push   $0xb2
  80094a:	68 1c 3b 80 00       	push   $0x803b1c
  80094f:	e8 56 03 00 00       	call   800caa <_panic>
		if ((freeFrames - sys_calculate_free_frames()) != 0) panic("Wrong allocation: ");
  800954:	e8 a3 19 00 00       	call   8022fc <sys_calculate_free_frames>
  800959:	89 c2                	mov    %eax,%edx
  80095b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80095e:	39 c2                	cmp    %eax,%edx
  800960:	74 17                	je     800979 <_main+0x941>
  800962:	83 ec 04             	sub    $0x4,%esp
  800965:	68 81 3b 80 00       	push   $0x803b81
  80096a:	68 b3 00 00 00       	push   $0xb3
  80096f:	68 1c 3b 80 00       	push   $0x803b1c
  800974:	e8 31 03 00 00       	call   800caa <_panic>
	}

	//[4] Free contiguous allocations
	{
		//1 MB Hole appended to previous 256 KB hole
		freeFrames = sys_calculate_free_frames() ;
  800979:	e8 7e 19 00 00       	call   8022fc <sys_calculate_free_frames>
  80097e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  800981:	e8 16 1a 00 00       	call   80239c <sys_pf_calculate_allocated_pages>
  800986:	89 45 e0             	mov    %eax,-0x20(%ebp)
		free(ptr_allocations[2]);
  800989:	8b 45 98             	mov    -0x68(%ebp),%eax
  80098c:	83 ec 0c             	sub    $0xc,%esp
  80098f:	50                   	push   %eax
  800990:	e8 dc 15 00 00       	call   801f71 <free>
  800995:	83 c4 10             	add    $0x10,%esp
		//if ((sys_calculate_free_frames() - freeFrames) != 256) panic("Wrong free: ");
		if( (usedDiskPages - sys_pf_calculate_allocated_pages()) !=  0) panic("Wrong page file free: ");
  800998:	e8 ff 19 00 00       	call   80239c <sys_pf_calculate_allocated_pages>
  80099d:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  8009a0:	74 17                	je     8009b9 <_main+0x981>
  8009a2:	83 ec 04             	sub    $0x4,%esp
  8009a5:	68 94 3b 80 00       	push   $0x803b94
  8009aa:	68 bd 00 00 00       	push   $0xbd
  8009af:	68 1c 3b 80 00       	push   $0x803b1c
  8009b4:	e8 f1 02 00 00       	call   800caa <_panic>
		if ((sys_calculate_free_frames() - freeFrames) != 0) panic("Wrong free: ");
  8009b9:	e8 3e 19 00 00       	call   8022fc <sys_calculate_free_frames>
  8009be:	89 c2                	mov    %eax,%edx
  8009c0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8009c3:	39 c2                	cmp    %eax,%edx
  8009c5:	74 17                	je     8009de <_main+0x9a6>
  8009c7:	83 ec 04             	sub    $0x4,%esp
  8009ca:	68 ab 3b 80 00       	push   $0x803bab
  8009cf:	68 be 00 00 00       	push   $0xbe
  8009d4:	68 1c 3b 80 00       	push   $0x803b1c
  8009d9:	e8 cc 02 00 00       	call   800caa <_panic>

		//1 MB Hole appended to next 1 MB hole
		freeFrames = sys_calculate_free_frames() ;
  8009de:	e8 19 19 00 00       	call   8022fc <sys_calculate_free_frames>
  8009e3:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  8009e6:	e8 b1 19 00 00       	call   80239c <sys_pf_calculate_allocated_pages>
  8009eb:	89 45 e0             	mov    %eax,-0x20(%ebp)
		free(ptr_allocations[9]);
  8009ee:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  8009f1:	83 ec 0c             	sub    $0xc,%esp
  8009f4:	50                   	push   %eax
  8009f5:	e8 77 15 00 00       	call   801f71 <free>
  8009fa:	83 c4 10             	add    $0x10,%esp
		//if ((sys_calculate_free_frames() - freeFrames) != 256) panic("Wrong free: ");
		if( (usedDiskPages - sys_pf_calculate_allocated_pages()) !=  0) panic("Wrong page file free: ");
  8009fd:	e8 9a 19 00 00       	call   80239c <sys_pf_calculate_allocated_pages>
  800a02:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  800a05:	74 17                	je     800a1e <_main+0x9e6>
  800a07:	83 ec 04             	sub    $0x4,%esp
  800a0a:	68 94 3b 80 00       	push   $0x803b94
  800a0f:	68 c5 00 00 00       	push   $0xc5
  800a14:	68 1c 3b 80 00       	push   $0x803b1c
  800a19:	e8 8c 02 00 00       	call   800caa <_panic>
		if ((sys_calculate_free_frames() - freeFrames) != 0) panic("Wrong free: ");
  800a1e:	e8 d9 18 00 00       	call   8022fc <sys_calculate_free_frames>
  800a23:	89 c2                	mov    %eax,%edx
  800a25:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800a28:	39 c2                	cmp    %eax,%edx
  800a2a:	74 17                	je     800a43 <_main+0xa0b>
  800a2c:	83 ec 04             	sub    $0x4,%esp
  800a2f:	68 ab 3b 80 00       	push   $0x803bab
  800a34:	68 c6 00 00 00       	push   $0xc6
  800a39:	68 1c 3b 80 00       	push   $0x803b1c
  800a3e:	e8 67 02 00 00       	call   800caa <_panic>

		//1 MB Hole appended to previous 1 MB + 256 KB hole and next 2 MB hole
		freeFrames = sys_calculate_free_frames() ;
  800a43:	e8 b4 18 00 00       	call   8022fc <sys_calculate_free_frames>
  800a48:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  800a4b:	e8 4c 19 00 00       	call   80239c <sys_pf_calculate_allocated_pages>
  800a50:	89 45 e0             	mov    %eax,-0x20(%ebp)
		free(ptr_allocations[3]);
  800a53:	8b 45 9c             	mov    -0x64(%ebp),%eax
  800a56:	83 ec 0c             	sub    $0xc,%esp
  800a59:	50                   	push   %eax
  800a5a:	e8 12 15 00 00       	call   801f71 <free>
  800a5f:	83 c4 10             	add    $0x10,%esp
		//if ((sys_calculate_free_frames() - freeFrames) != 256) panic("Wrong free: ");
		if( (usedDiskPages - sys_pf_calculate_allocated_pages()) !=  0) panic("Wrong page file free: ");
  800a62:	e8 35 19 00 00       	call   80239c <sys_pf_calculate_allocated_pages>
  800a67:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  800a6a:	74 17                	je     800a83 <_main+0xa4b>
  800a6c:	83 ec 04             	sub    $0x4,%esp
  800a6f:	68 94 3b 80 00       	push   $0x803b94
  800a74:	68 cd 00 00 00       	push   $0xcd
  800a79:	68 1c 3b 80 00       	push   $0x803b1c
  800a7e:	e8 27 02 00 00       	call   800caa <_panic>
		if ((sys_calculate_free_frames() - freeFrames) != 0) panic("Wrong free: ");
  800a83:	e8 74 18 00 00       	call   8022fc <sys_calculate_free_frames>
  800a88:	89 c2                	mov    %eax,%edx
  800a8a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800a8d:	39 c2                	cmp    %eax,%edx
  800a8f:	74 17                	je     800aa8 <_main+0xa70>
  800a91:	83 ec 04             	sub    $0x4,%esp
  800a94:	68 ab 3b 80 00       	push   $0x803bab
  800a99:	68 ce 00 00 00       	push   $0xce
  800a9e:	68 1c 3b 80 00       	push   $0x803b1c
  800aa3:	e8 02 02 00 00       	call   800caa <_panic>

	//[5] Allocate again [test first fit]
	{
		//[FIRST FIT Case]
		//Allocate 4 MB + 256 KB - should be placed in the contiguous hole (256 KB + 4 MB)
		freeFrames = sys_calculate_free_frames() ;
  800aa8:	e8 4f 18 00 00       	call   8022fc <sys_calculate_free_frames>
  800aad:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  800ab0:	e8 e7 18 00 00       	call   80239c <sys_pf_calculate_allocated_pages>
  800ab5:	89 45 e0             	mov    %eax,-0x20(%ebp)
		ptr_allocations[13] = malloc(4*Mega + 256*kilo - kilo);
  800ab8:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800abb:	c1 e0 06             	shl    $0x6,%eax
  800abe:	89 c2                	mov    %eax,%edx
  800ac0:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800ac3:	01 d0                	add    %edx,%eax
  800ac5:	c1 e0 02             	shl    $0x2,%eax
  800ac8:	2b 45 e8             	sub    -0x18(%ebp),%eax
  800acb:	83 ec 0c             	sub    $0xc,%esp
  800ace:	50                   	push   %eax
  800acf:	e8 1c 14 00 00       	call   801ef0 <malloc>
  800ad4:	83 c4 10             	add    $0x10,%esp
  800ad7:	89 45 c4             	mov    %eax,-0x3c(%ebp)
		if ((uint32) ptr_allocations[13] != (USER_HEAP_START + 1*Mega + 768*kilo)) panic("Wrong start address for the allocated space... ");
  800ada:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  800add:	89 c1                	mov    %eax,%ecx
  800adf:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800ae2:	89 d0                	mov    %edx,%eax
  800ae4:	01 c0                	add    %eax,%eax
  800ae6:	01 d0                	add    %edx,%eax
  800ae8:	c1 e0 08             	shl    $0x8,%eax
  800aeb:	89 c2                	mov    %eax,%edx
  800aed:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800af0:	01 d0                	add    %edx,%eax
  800af2:	05 00 00 00 80       	add    $0x80000000,%eax
  800af7:	39 c1                	cmp    %eax,%ecx
  800af9:	74 17                	je     800b12 <_main+0xada>
  800afb:	83 ec 04             	sub    $0x4,%esp
  800afe:	68 34 3b 80 00       	push   $0x803b34
  800b03:	68 d8 00 00 00       	push   $0xd8
  800b08:	68 1c 3b 80 00       	push   $0x803b1c
  800b0d:	e8 98 01 00 00       	call   800caa <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 512+32) panic("Wrong allocation: ");
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  0) panic("Wrong page file allocation: ");
  800b12:	e8 85 18 00 00       	call   80239c <sys_pf_calculate_allocated_pages>
  800b17:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  800b1a:	74 17                	je     800b33 <_main+0xafb>
  800b1c:	83 ec 04             	sub    $0x4,%esp
  800b1f:	68 64 3b 80 00       	push   $0x803b64
  800b24:	68 da 00 00 00       	push   $0xda
  800b29:	68 1c 3b 80 00       	push   $0x803b1c
  800b2e:	e8 77 01 00 00       	call   800caa <_panic>
		if ((freeFrames - sys_calculate_free_frames()) != 0) panic("Wrong allocation: ");
  800b33:	e8 c4 17 00 00       	call   8022fc <sys_calculate_free_frames>
  800b38:	89 c2                	mov    %eax,%edx
  800b3a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800b3d:	39 c2                	cmp    %eax,%edx
  800b3f:	74 17                	je     800b58 <_main+0xb20>
  800b41:	83 ec 04             	sub    $0x4,%esp
  800b44:	68 81 3b 80 00       	push   $0x803b81
  800b49:	68 db 00 00 00       	push   $0xdb
  800b4e:	68 1c 3b 80 00       	push   $0x803b1c
  800b53:	e8 52 01 00 00       	call   800caa <_panic>
	}
	cprintf("Congratulations!! test FIRST FIT allocation (1) completed successfully.\n");
  800b58:	83 ec 0c             	sub    $0xc,%esp
  800b5b:	68 b8 3b 80 00       	push   $0x803bb8
  800b60:	e8 f9 03 00 00       	call   800f5e <cprintf>
  800b65:	83 c4 10             	add    $0x10,%esp

	return;
  800b68:	90                   	nop
}
  800b69:	8b 7d fc             	mov    -0x4(%ebp),%edi
  800b6c:	c9                   	leave  
  800b6d:	c3                   	ret    

00800b6e <libmain>:
volatile struct Env *myEnv = NULL;
volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";

void
libmain(int argc, char **argv)
{
  800b6e:	55                   	push   %ebp
  800b6f:	89 e5                	mov    %esp,%ebp
  800b71:	83 ec 18             	sub    $0x18,%esp
	int envIndex = sys_getenvindex();
  800b74:	e8 63 1a 00 00       	call   8025dc <sys_getenvindex>
  800b79:	89 45 f4             	mov    %eax,-0xc(%ebp)
	myEnv = &(envs[envIndex]);
  800b7c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800b7f:	89 d0                	mov    %edx,%eax
  800b81:	c1 e0 03             	shl    $0x3,%eax
  800b84:	01 d0                	add    %edx,%eax
  800b86:	01 c0                	add    %eax,%eax
  800b88:	01 d0                	add    %edx,%eax
  800b8a:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800b91:	01 d0                	add    %edx,%eax
  800b93:	c1 e0 04             	shl    $0x4,%eax
  800b96:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  800b9b:	a3 20 50 80 00       	mov    %eax,0x805020

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  800ba0:	a1 20 50 80 00       	mov    0x805020,%eax
  800ba5:	8a 80 5c 05 00 00    	mov    0x55c(%eax),%al
  800bab:	84 c0                	test   %al,%al
  800bad:	74 0f                	je     800bbe <libmain+0x50>
		binaryname = myEnv->prog_name;
  800baf:	a1 20 50 80 00       	mov    0x805020,%eax
  800bb4:	05 5c 05 00 00       	add    $0x55c,%eax
  800bb9:	a3 00 50 80 00       	mov    %eax,0x805000

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800bbe:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800bc2:	7e 0a                	jle    800bce <libmain+0x60>
		binaryname = argv[0];
  800bc4:	8b 45 0c             	mov    0xc(%ebp),%eax
  800bc7:	8b 00                	mov    (%eax),%eax
  800bc9:	a3 00 50 80 00       	mov    %eax,0x805000

	// call user main routine
	_main(argc, argv);
  800bce:	83 ec 08             	sub    $0x8,%esp
  800bd1:	ff 75 0c             	pushl  0xc(%ebp)
  800bd4:	ff 75 08             	pushl  0x8(%ebp)
  800bd7:	e8 5c f4 ff ff       	call   800038 <_main>
  800bdc:	83 c4 10             	add    $0x10,%esp



	sys_disable_interrupt();
  800bdf:	e8 05 18 00 00       	call   8023e9 <sys_disable_interrupt>
	cprintf("**************************************\n");
  800be4:	83 ec 0c             	sub    $0xc,%esp
  800be7:	68 1c 3c 80 00       	push   $0x803c1c
  800bec:	e8 6d 03 00 00       	call   800f5e <cprintf>
  800bf1:	83 c4 10             	add    $0x10,%esp
	cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  800bf4:	a1 20 50 80 00       	mov    0x805020,%eax
  800bf9:	8b 90 44 05 00 00    	mov    0x544(%eax),%edx
  800bff:	a1 20 50 80 00       	mov    0x805020,%eax
  800c04:	8b 80 34 05 00 00    	mov    0x534(%eax),%eax
  800c0a:	83 ec 04             	sub    $0x4,%esp
  800c0d:	52                   	push   %edx
  800c0e:	50                   	push   %eax
  800c0f:	68 44 3c 80 00       	push   $0x803c44
  800c14:	e8 45 03 00 00       	call   800f5e <cprintf>
  800c19:	83 c4 10             	add    $0x10,%esp
	cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  800c1c:	a1 20 50 80 00       	mov    0x805020,%eax
  800c21:	8b 88 54 05 00 00    	mov    0x554(%eax),%ecx
  800c27:	a1 20 50 80 00       	mov    0x805020,%eax
  800c2c:	8b 90 50 05 00 00    	mov    0x550(%eax),%edx
  800c32:	a1 20 50 80 00       	mov    0x805020,%eax
  800c37:	8b 80 4c 05 00 00    	mov    0x54c(%eax),%eax
  800c3d:	51                   	push   %ecx
  800c3e:	52                   	push   %edx
  800c3f:	50                   	push   %eax
  800c40:	68 6c 3c 80 00       	push   $0x803c6c
  800c45:	e8 14 03 00 00       	call   800f5e <cprintf>
  800c4a:	83 c4 10             	add    $0x10,%esp
	//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
	cprintf("Num of clocks = %d\n", myEnv->nClocks);
  800c4d:	a1 20 50 80 00       	mov    0x805020,%eax
  800c52:	8b 80 a4 05 00 00    	mov    0x5a4(%eax),%eax
  800c58:	83 ec 08             	sub    $0x8,%esp
  800c5b:	50                   	push   %eax
  800c5c:	68 c4 3c 80 00       	push   $0x803cc4
  800c61:	e8 f8 02 00 00       	call   800f5e <cprintf>
  800c66:	83 c4 10             	add    $0x10,%esp
	cprintf("**************************************\n");
  800c69:	83 ec 0c             	sub    $0xc,%esp
  800c6c:	68 1c 3c 80 00       	push   $0x803c1c
  800c71:	e8 e8 02 00 00       	call   800f5e <cprintf>
  800c76:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  800c79:	e8 85 17 00 00       	call   802403 <sys_enable_interrupt>

	// exit gracefully
	exit();
  800c7e:	e8 19 00 00 00       	call   800c9c <exit>
}
  800c83:	90                   	nop
  800c84:	c9                   	leave  
  800c85:	c3                   	ret    

00800c86 <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  800c86:	55                   	push   %ebp
  800c87:	89 e5                	mov    %esp,%ebp
  800c89:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  800c8c:	83 ec 0c             	sub    $0xc,%esp
  800c8f:	6a 00                	push   $0x0
  800c91:	e8 12 19 00 00       	call   8025a8 <sys_destroy_env>
  800c96:	83 c4 10             	add    $0x10,%esp
}
  800c99:	90                   	nop
  800c9a:	c9                   	leave  
  800c9b:	c3                   	ret    

00800c9c <exit>:

void
exit(void)
{
  800c9c:	55                   	push   %ebp
  800c9d:	89 e5                	mov    %esp,%ebp
  800c9f:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  800ca2:	e8 67 19 00 00       	call   80260e <sys_exit_env>
}
  800ca7:	90                   	nop
  800ca8:	c9                   	leave  
  800ca9:	c3                   	ret    

00800caa <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  800caa:	55                   	push   %ebp
  800cab:	89 e5                	mov    %esp,%ebp
  800cad:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  800cb0:	8d 45 10             	lea    0x10(%ebp),%eax
  800cb3:	83 c0 04             	add    $0x4,%eax
  800cb6:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  800cb9:	a1 5c 51 80 00       	mov    0x80515c,%eax
  800cbe:	85 c0                	test   %eax,%eax
  800cc0:	74 16                	je     800cd8 <_panic+0x2e>
		cprintf("%s: ", argv0);
  800cc2:	a1 5c 51 80 00       	mov    0x80515c,%eax
  800cc7:	83 ec 08             	sub    $0x8,%esp
  800cca:	50                   	push   %eax
  800ccb:	68 d8 3c 80 00       	push   $0x803cd8
  800cd0:	e8 89 02 00 00       	call   800f5e <cprintf>
  800cd5:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  800cd8:	a1 00 50 80 00       	mov    0x805000,%eax
  800cdd:	ff 75 0c             	pushl  0xc(%ebp)
  800ce0:	ff 75 08             	pushl  0x8(%ebp)
  800ce3:	50                   	push   %eax
  800ce4:	68 dd 3c 80 00       	push   $0x803cdd
  800ce9:	e8 70 02 00 00       	call   800f5e <cprintf>
  800cee:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  800cf1:	8b 45 10             	mov    0x10(%ebp),%eax
  800cf4:	83 ec 08             	sub    $0x8,%esp
  800cf7:	ff 75 f4             	pushl  -0xc(%ebp)
  800cfa:	50                   	push   %eax
  800cfb:	e8 f3 01 00 00       	call   800ef3 <vcprintf>
  800d00:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  800d03:	83 ec 08             	sub    $0x8,%esp
  800d06:	6a 00                	push   $0x0
  800d08:	68 f9 3c 80 00       	push   $0x803cf9
  800d0d:	e8 e1 01 00 00       	call   800ef3 <vcprintf>
  800d12:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  800d15:	e8 82 ff ff ff       	call   800c9c <exit>

	// should not return here
	while (1) ;
  800d1a:	eb fe                	jmp    800d1a <_panic+0x70>

00800d1c <CheckWSWithoutLastIndex>:
}

void CheckWSWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  800d1c:	55                   	push   %ebp
  800d1d:	89 e5                	mov    %esp,%ebp
  800d1f:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  800d22:	a1 20 50 80 00       	mov    0x805020,%eax
  800d27:	8b 50 74             	mov    0x74(%eax),%edx
  800d2a:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d2d:	39 c2                	cmp    %eax,%edx
  800d2f:	74 14                	je     800d45 <CheckWSWithoutLastIndex+0x29>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  800d31:	83 ec 04             	sub    $0x4,%esp
  800d34:	68 fc 3c 80 00       	push   $0x803cfc
  800d39:	6a 26                	push   $0x26
  800d3b:	68 48 3d 80 00       	push   $0x803d48
  800d40:	e8 65 ff ff ff       	call   800caa <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  800d45:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  800d4c:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800d53:	e9 c2 00 00 00       	jmp    800e1a <CheckWSWithoutLastIndex+0xfe>
		if (expectedPages[e] == 0) {
  800d58:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800d5b:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800d62:	8b 45 08             	mov    0x8(%ebp),%eax
  800d65:	01 d0                	add    %edx,%eax
  800d67:	8b 00                	mov    (%eax),%eax
  800d69:	85 c0                	test   %eax,%eax
  800d6b:	75 08                	jne    800d75 <CheckWSWithoutLastIndex+0x59>
			expectedNumOfEmptyLocs++;
  800d6d:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  800d70:	e9 a2 00 00 00       	jmp    800e17 <CheckWSWithoutLastIndex+0xfb>
		}
		int found = 0;
  800d75:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800d7c:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  800d83:	eb 69                	jmp    800dee <CheckWSWithoutLastIndex+0xd2>
			if (myEnv->__uptr_pws[w].empty == 0) {
  800d85:	a1 20 50 80 00       	mov    0x805020,%eax
  800d8a:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  800d90:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800d93:	89 d0                	mov    %edx,%eax
  800d95:	01 c0                	add    %eax,%eax
  800d97:	01 d0                	add    %edx,%eax
  800d99:	c1 e0 03             	shl    $0x3,%eax
  800d9c:	01 c8                	add    %ecx,%eax
  800d9e:	8a 40 04             	mov    0x4(%eax),%al
  800da1:	84 c0                	test   %al,%al
  800da3:	75 46                	jne    800deb <CheckWSWithoutLastIndex+0xcf>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  800da5:	a1 20 50 80 00       	mov    0x805020,%eax
  800daa:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  800db0:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800db3:	89 d0                	mov    %edx,%eax
  800db5:	01 c0                	add    %eax,%eax
  800db7:	01 d0                	add    %edx,%eax
  800db9:	c1 e0 03             	shl    $0x3,%eax
  800dbc:	01 c8                	add    %ecx,%eax
  800dbe:	8b 00                	mov    (%eax),%eax
  800dc0:	89 45 dc             	mov    %eax,-0x24(%ebp)
  800dc3:	8b 45 dc             	mov    -0x24(%ebp),%eax
  800dc6:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800dcb:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  800dcd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800dd0:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  800dd7:	8b 45 08             	mov    0x8(%ebp),%eax
  800dda:	01 c8                	add    %ecx,%eax
  800ddc:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  800dde:	39 c2                	cmp    %eax,%edx
  800de0:	75 09                	jne    800deb <CheckWSWithoutLastIndex+0xcf>
						== expectedPages[e]) {
					found = 1;
  800de2:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  800de9:	eb 12                	jmp    800dfd <CheckWSWithoutLastIndex+0xe1>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800deb:	ff 45 e8             	incl   -0x18(%ebp)
  800dee:	a1 20 50 80 00       	mov    0x805020,%eax
  800df3:	8b 50 74             	mov    0x74(%eax),%edx
  800df6:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800df9:	39 c2                	cmp    %eax,%edx
  800dfb:	77 88                	ja     800d85 <CheckWSWithoutLastIndex+0x69>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  800dfd:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  800e01:	75 14                	jne    800e17 <CheckWSWithoutLastIndex+0xfb>
			panic(
  800e03:	83 ec 04             	sub    $0x4,%esp
  800e06:	68 54 3d 80 00       	push   $0x803d54
  800e0b:	6a 3a                	push   $0x3a
  800e0d:	68 48 3d 80 00       	push   $0x803d48
  800e12:	e8 93 fe ff ff       	call   800caa <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  800e17:	ff 45 f0             	incl   -0x10(%ebp)
  800e1a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800e1d:	3b 45 0c             	cmp    0xc(%ebp),%eax
  800e20:	0f 8c 32 ff ff ff    	jl     800d58 <CheckWSWithoutLastIndex+0x3c>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  800e26:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800e2d:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  800e34:	eb 26                	jmp    800e5c <CheckWSWithoutLastIndex+0x140>
		if (myEnv->__uptr_pws[w].empty == 1) {
  800e36:	a1 20 50 80 00       	mov    0x805020,%eax
  800e3b:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  800e41:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800e44:	89 d0                	mov    %edx,%eax
  800e46:	01 c0                	add    %eax,%eax
  800e48:	01 d0                	add    %edx,%eax
  800e4a:	c1 e0 03             	shl    $0x3,%eax
  800e4d:	01 c8                	add    %ecx,%eax
  800e4f:	8a 40 04             	mov    0x4(%eax),%al
  800e52:	3c 01                	cmp    $0x1,%al
  800e54:	75 03                	jne    800e59 <CheckWSWithoutLastIndex+0x13d>
			actualNumOfEmptyLocs++;
  800e56:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800e59:	ff 45 e0             	incl   -0x20(%ebp)
  800e5c:	a1 20 50 80 00       	mov    0x805020,%eax
  800e61:	8b 50 74             	mov    0x74(%eax),%edx
  800e64:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800e67:	39 c2                	cmp    %eax,%edx
  800e69:	77 cb                	ja     800e36 <CheckWSWithoutLastIndex+0x11a>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  800e6b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800e6e:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  800e71:	74 14                	je     800e87 <CheckWSWithoutLastIndex+0x16b>
		panic(
  800e73:	83 ec 04             	sub    $0x4,%esp
  800e76:	68 a8 3d 80 00       	push   $0x803da8
  800e7b:	6a 44                	push   $0x44
  800e7d:	68 48 3d 80 00       	push   $0x803d48
  800e82:	e8 23 fe ff ff       	call   800caa <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  800e87:	90                   	nop
  800e88:	c9                   	leave  
  800e89:	c3                   	ret    

00800e8a <putch>:
};

//2017:
uint8 printProgName = 0;

static void putch(int ch, struct printbuf *b) {
  800e8a:	55                   	push   %ebp
  800e8b:	89 e5                	mov    %esp,%ebp
  800e8d:	83 ec 08             	sub    $0x8,%esp
	b->buf[b->idx++] = ch;
  800e90:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e93:	8b 00                	mov    (%eax),%eax
  800e95:	8d 48 01             	lea    0x1(%eax),%ecx
  800e98:	8b 55 0c             	mov    0xc(%ebp),%edx
  800e9b:	89 0a                	mov    %ecx,(%edx)
  800e9d:	8b 55 08             	mov    0x8(%ebp),%edx
  800ea0:	88 d1                	mov    %dl,%cl
  800ea2:	8b 55 0c             	mov    0xc(%ebp),%edx
  800ea5:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  800ea9:	8b 45 0c             	mov    0xc(%ebp),%eax
  800eac:	8b 00                	mov    (%eax),%eax
  800eae:	3d ff 00 00 00       	cmp    $0xff,%eax
  800eb3:	75 2c                	jne    800ee1 <putch+0x57>
		sys_cputs(b->buf, b->idx, printProgName);
  800eb5:	a0 24 50 80 00       	mov    0x805024,%al
  800eba:	0f b6 c0             	movzbl %al,%eax
  800ebd:	8b 55 0c             	mov    0xc(%ebp),%edx
  800ec0:	8b 12                	mov    (%edx),%edx
  800ec2:	89 d1                	mov    %edx,%ecx
  800ec4:	8b 55 0c             	mov    0xc(%ebp),%edx
  800ec7:	83 c2 08             	add    $0x8,%edx
  800eca:	83 ec 04             	sub    $0x4,%esp
  800ecd:	50                   	push   %eax
  800ece:	51                   	push   %ecx
  800ecf:	52                   	push   %edx
  800ed0:	e8 66 13 00 00       	call   80223b <sys_cputs>
  800ed5:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  800ed8:	8b 45 0c             	mov    0xc(%ebp),%eax
  800edb:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  800ee1:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ee4:	8b 40 04             	mov    0x4(%eax),%eax
  800ee7:	8d 50 01             	lea    0x1(%eax),%edx
  800eea:	8b 45 0c             	mov    0xc(%ebp),%eax
  800eed:	89 50 04             	mov    %edx,0x4(%eax)
}
  800ef0:	90                   	nop
  800ef1:	c9                   	leave  
  800ef2:	c3                   	ret    

00800ef3 <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  800ef3:	55                   	push   %ebp
  800ef4:	89 e5                	mov    %esp,%ebp
  800ef6:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  800efc:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800f03:	00 00 00 
	b.cnt = 0;
  800f06:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800f0d:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  800f10:	ff 75 0c             	pushl  0xc(%ebp)
  800f13:	ff 75 08             	pushl  0x8(%ebp)
  800f16:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800f1c:	50                   	push   %eax
  800f1d:	68 8a 0e 80 00       	push   $0x800e8a
  800f22:	e8 11 02 00 00       	call   801138 <vprintfmt>
  800f27:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName);
  800f2a:	a0 24 50 80 00       	mov    0x805024,%al
  800f2f:	0f b6 c0             	movzbl %al,%eax
  800f32:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  800f38:	83 ec 04             	sub    $0x4,%esp
  800f3b:	50                   	push   %eax
  800f3c:	52                   	push   %edx
  800f3d:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800f43:	83 c0 08             	add    $0x8,%eax
  800f46:	50                   	push   %eax
  800f47:	e8 ef 12 00 00       	call   80223b <sys_cputs>
  800f4c:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  800f4f:	c6 05 24 50 80 00 00 	movb   $0x0,0x805024
	return b.cnt;
  800f56:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  800f5c:	c9                   	leave  
  800f5d:	c3                   	ret    

00800f5e <cprintf>:

int cprintf(const char *fmt, ...) {
  800f5e:	55                   	push   %ebp
  800f5f:	89 e5                	mov    %esp,%ebp
  800f61:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  800f64:	c6 05 24 50 80 00 01 	movb   $0x1,0x805024
	va_start(ap, fmt);
  800f6b:	8d 45 0c             	lea    0xc(%ebp),%eax
  800f6e:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800f71:	8b 45 08             	mov    0x8(%ebp),%eax
  800f74:	83 ec 08             	sub    $0x8,%esp
  800f77:	ff 75 f4             	pushl  -0xc(%ebp)
  800f7a:	50                   	push   %eax
  800f7b:	e8 73 ff ff ff       	call   800ef3 <vcprintf>
  800f80:	83 c4 10             	add    $0x10,%esp
  800f83:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  800f86:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800f89:	c9                   	leave  
  800f8a:	c3                   	ret    

00800f8b <atomic_cprintf>:

int atomic_cprintf(const char *fmt, ...) {
  800f8b:	55                   	push   %ebp
  800f8c:	89 e5                	mov    %esp,%ebp
  800f8e:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  800f91:	e8 53 14 00 00       	call   8023e9 <sys_disable_interrupt>
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  800f96:	8d 45 0c             	lea    0xc(%ebp),%eax
  800f99:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800f9c:	8b 45 08             	mov    0x8(%ebp),%eax
  800f9f:	83 ec 08             	sub    $0x8,%esp
  800fa2:	ff 75 f4             	pushl  -0xc(%ebp)
  800fa5:	50                   	push   %eax
  800fa6:	e8 48 ff ff ff       	call   800ef3 <vcprintf>
  800fab:	83 c4 10             	add    $0x10,%esp
  800fae:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	sys_enable_interrupt();
  800fb1:	e8 4d 14 00 00       	call   802403 <sys_enable_interrupt>
	return cnt;
  800fb6:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800fb9:	c9                   	leave  
  800fba:	c3                   	ret    

00800fbb <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800fbb:	55                   	push   %ebp
  800fbc:	89 e5                	mov    %esp,%ebp
  800fbe:	53                   	push   %ebx
  800fbf:	83 ec 14             	sub    $0x14,%esp
  800fc2:	8b 45 10             	mov    0x10(%ebp),%eax
  800fc5:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800fc8:	8b 45 14             	mov    0x14(%ebp),%eax
  800fcb:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800fce:	8b 45 18             	mov    0x18(%ebp),%eax
  800fd1:	ba 00 00 00 00       	mov    $0x0,%edx
  800fd6:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800fd9:	77 55                	ja     801030 <printnum+0x75>
  800fdb:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800fde:	72 05                	jb     800fe5 <printnum+0x2a>
  800fe0:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800fe3:	77 4b                	ja     801030 <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800fe5:	8b 45 1c             	mov    0x1c(%ebp),%eax
  800fe8:	8d 58 ff             	lea    -0x1(%eax),%ebx
  800feb:	8b 45 18             	mov    0x18(%ebp),%eax
  800fee:	ba 00 00 00 00       	mov    $0x0,%edx
  800ff3:	52                   	push   %edx
  800ff4:	50                   	push   %eax
  800ff5:	ff 75 f4             	pushl  -0xc(%ebp)
  800ff8:	ff 75 f0             	pushl  -0x10(%ebp)
  800ffb:	e8 84 28 00 00       	call   803884 <__udivdi3>
  801000:	83 c4 10             	add    $0x10,%esp
  801003:	83 ec 04             	sub    $0x4,%esp
  801006:	ff 75 20             	pushl  0x20(%ebp)
  801009:	53                   	push   %ebx
  80100a:	ff 75 18             	pushl  0x18(%ebp)
  80100d:	52                   	push   %edx
  80100e:	50                   	push   %eax
  80100f:	ff 75 0c             	pushl  0xc(%ebp)
  801012:	ff 75 08             	pushl  0x8(%ebp)
  801015:	e8 a1 ff ff ff       	call   800fbb <printnum>
  80101a:	83 c4 20             	add    $0x20,%esp
  80101d:	eb 1a                	jmp    801039 <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  80101f:	83 ec 08             	sub    $0x8,%esp
  801022:	ff 75 0c             	pushl  0xc(%ebp)
  801025:	ff 75 20             	pushl  0x20(%ebp)
  801028:	8b 45 08             	mov    0x8(%ebp),%eax
  80102b:	ff d0                	call   *%eax
  80102d:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  801030:	ff 4d 1c             	decl   0x1c(%ebp)
  801033:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  801037:	7f e6                	jg     80101f <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  801039:	8b 4d 18             	mov    0x18(%ebp),%ecx
  80103c:	bb 00 00 00 00       	mov    $0x0,%ebx
  801041:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801044:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801047:	53                   	push   %ebx
  801048:	51                   	push   %ecx
  801049:	52                   	push   %edx
  80104a:	50                   	push   %eax
  80104b:	e8 44 29 00 00       	call   803994 <__umoddi3>
  801050:	83 c4 10             	add    $0x10,%esp
  801053:	05 14 40 80 00       	add    $0x804014,%eax
  801058:	8a 00                	mov    (%eax),%al
  80105a:	0f be c0             	movsbl %al,%eax
  80105d:	83 ec 08             	sub    $0x8,%esp
  801060:	ff 75 0c             	pushl  0xc(%ebp)
  801063:	50                   	push   %eax
  801064:	8b 45 08             	mov    0x8(%ebp),%eax
  801067:	ff d0                	call   *%eax
  801069:	83 c4 10             	add    $0x10,%esp
}
  80106c:	90                   	nop
  80106d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801070:	c9                   	leave  
  801071:	c3                   	ret    

00801072 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  801072:	55                   	push   %ebp
  801073:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  801075:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  801079:	7e 1c                	jle    801097 <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  80107b:	8b 45 08             	mov    0x8(%ebp),%eax
  80107e:	8b 00                	mov    (%eax),%eax
  801080:	8d 50 08             	lea    0x8(%eax),%edx
  801083:	8b 45 08             	mov    0x8(%ebp),%eax
  801086:	89 10                	mov    %edx,(%eax)
  801088:	8b 45 08             	mov    0x8(%ebp),%eax
  80108b:	8b 00                	mov    (%eax),%eax
  80108d:	83 e8 08             	sub    $0x8,%eax
  801090:	8b 50 04             	mov    0x4(%eax),%edx
  801093:	8b 00                	mov    (%eax),%eax
  801095:	eb 40                	jmp    8010d7 <getuint+0x65>
	else if (lflag)
  801097:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80109b:	74 1e                	je     8010bb <getuint+0x49>
		return va_arg(*ap, unsigned long);
  80109d:	8b 45 08             	mov    0x8(%ebp),%eax
  8010a0:	8b 00                	mov    (%eax),%eax
  8010a2:	8d 50 04             	lea    0x4(%eax),%edx
  8010a5:	8b 45 08             	mov    0x8(%ebp),%eax
  8010a8:	89 10                	mov    %edx,(%eax)
  8010aa:	8b 45 08             	mov    0x8(%ebp),%eax
  8010ad:	8b 00                	mov    (%eax),%eax
  8010af:	83 e8 04             	sub    $0x4,%eax
  8010b2:	8b 00                	mov    (%eax),%eax
  8010b4:	ba 00 00 00 00       	mov    $0x0,%edx
  8010b9:	eb 1c                	jmp    8010d7 <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  8010bb:	8b 45 08             	mov    0x8(%ebp),%eax
  8010be:	8b 00                	mov    (%eax),%eax
  8010c0:	8d 50 04             	lea    0x4(%eax),%edx
  8010c3:	8b 45 08             	mov    0x8(%ebp),%eax
  8010c6:	89 10                	mov    %edx,(%eax)
  8010c8:	8b 45 08             	mov    0x8(%ebp),%eax
  8010cb:	8b 00                	mov    (%eax),%eax
  8010cd:	83 e8 04             	sub    $0x4,%eax
  8010d0:	8b 00                	mov    (%eax),%eax
  8010d2:	ba 00 00 00 00       	mov    $0x0,%edx
}
  8010d7:	5d                   	pop    %ebp
  8010d8:	c3                   	ret    

008010d9 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  8010d9:	55                   	push   %ebp
  8010da:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  8010dc:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  8010e0:	7e 1c                	jle    8010fe <getint+0x25>
		return va_arg(*ap, long long);
  8010e2:	8b 45 08             	mov    0x8(%ebp),%eax
  8010e5:	8b 00                	mov    (%eax),%eax
  8010e7:	8d 50 08             	lea    0x8(%eax),%edx
  8010ea:	8b 45 08             	mov    0x8(%ebp),%eax
  8010ed:	89 10                	mov    %edx,(%eax)
  8010ef:	8b 45 08             	mov    0x8(%ebp),%eax
  8010f2:	8b 00                	mov    (%eax),%eax
  8010f4:	83 e8 08             	sub    $0x8,%eax
  8010f7:	8b 50 04             	mov    0x4(%eax),%edx
  8010fa:	8b 00                	mov    (%eax),%eax
  8010fc:	eb 38                	jmp    801136 <getint+0x5d>
	else if (lflag)
  8010fe:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801102:	74 1a                	je     80111e <getint+0x45>
		return va_arg(*ap, long);
  801104:	8b 45 08             	mov    0x8(%ebp),%eax
  801107:	8b 00                	mov    (%eax),%eax
  801109:	8d 50 04             	lea    0x4(%eax),%edx
  80110c:	8b 45 08             	mov    0x8(%ebp),%eax
  80110f:	89 10                	mov    %edx,(%eax)
  801111:	8b 45 08             	mov    0x8(%ebp),%eax
  801114:	8b 00                	mov    (%eax),%eax
  801116:	83 e8 04             	sub    $0x4,%eax
  801119:	8b 00                	mov    (%eax),%eax
  80111b:	99                   	cltd   
  80111c:	eb 18                	jmp    801136 <getint+0x5d>
	else
		return va_arg(*ap, int);
  80111e:	8b 45 08             	mov    0x8(%ebp),%eax
  801121:	8b 00                	mov    (%eax),%eax
  801123:	8d 50 04             	lea    0x4(%eax),%edx
  801126:	8b 45 08             	mov    0x8(%ebp),%eax
  801129:	89 10                	mov    %edx,(%eax)
  80112b:	8b 45 08             	mov    0x8(%ebp),%eax
  80112e:	8b 00                	mov    (%eax),%eax
  801130:	83 e8 04             	sub    $0x4,%eax
  801133:	8b 00                	mov    (%eax),%eax
  801135:	99                   	cltd   
}
  801136:	5d                   	pop    %ebp
  801137:	c3                   	ret    

00801138 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  801138:	55                   	push   %ebp
  801139:	89 e5                	mov    %esp,%ebp
  80113b:	56                   	push   %esi
  80113c:	53                   	push   %ebx
  80113d:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  801140:	eb 17                	jmp    801159 <vprintfmt+0x21>
			if (ch == '\0')
  801142:	85 db                	test   %ebx,%ebx
  801144:	0f 84 af 03 00 00    	je     8014f9 <vprintfmt+0x3c1>
				return;
			putch(ch, putdat);
  80114a:	83 ec 08             	sub    $0x8,%esp
  80114d:	ff 75 0c             	pushl  0xc(%ebp)
  801150:	53                   	push   %ebx
  801151:	8b 45 08             	mov    0x8(%ebp),%eax
  801154:	ff d0                	call   *%eax
  801156:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  801159:	8b 45 10             	mov    0x10(%ebp),%eax
  80115c:	8d 50 01             	lea    0x1(%eax),%edx
  80115f:	89 55 10             	mov    %edx,0x10(%ebp)
  801162:	8a 00                	mov    (%eax),%al
  801164:	0f b6 d8             	movzbl %al,%ebx
  801167:	83 fb 25             	cmp    $0x25,%ebx
  80116a:	75 d6                	jne    801142 <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  80116c:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  801170:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  801177:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  80117e:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  801185:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  80118c:	8b 45 10             	mov    0x10(%ebp),%eax
  80118f:	8d 50 01             	lea    0x1(%eax),%edx
  801192:	89 55 10             	mov    %edx,0x10(%ebp)
  801195:	8a 00                	mov    (%eax),%al
  801197:	0f b6 d8             	movzbl %al,%ebx
  80119a:	8d 43 dd             	lea    -0x23(%ebx),%eax
  80119d:	83 f8 55             	cmp    $0x55,%eax
  8011a0:	0f 87 2b 03 00 00    	ja     8014d1 <vprintfmt+0x399>
  8011a6:	8b 04 85 38 40 80 00 	mov    0x804038(,%eax,4),%eax
  8011ad:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  8011af:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  8011b3:	eb d7                	jmp    80118c <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  8011b5:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  8011b9:	eb d1                	jmp    80118c <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8011bb:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  8011c2:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8011c5:	89 d0                	mov    %edx,%eax
  8011c7:	c1 e0 02             	shl    $0x2,%eax
  8011ca:	01 d0                	add    %edx,%eax
  8011cc:	01 c0                	add    %eax,%eax
  8011ce:	01 d8                	add    %ebx,%eax
  8011d0:	83 e8 30             	sub    $0x30,%eax
  8011d3:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  8011d6:	8b 45 10             	mov    0x10(%ebp),%eax
  8011d9:	8a 00                	mov    (%eax),%al
  8011db:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  8011de:	83 fb 2f             	cmp    $0x2f,%ebx
  8011e1:	7e 3e                	jle    801221 <vprintfmt+0xe9>
  8011e3:	83 fb 39             	cmp    $0x39,%ebx
  8011e6:	7f 39                	jg     801221 <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8011e8:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  8011eb:	eb d5                	jmp    8011c2 <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  8011ed:	8b 45 14             	mov    0x14(%ebp),%eax
  8011f0:	83 c0 04             	add    $0x4,%eax
  8011f3:	89 45 14             	mov    %eax,0x14(%ebp)
  8011f6:	8b 45 14             	mov    0x14(%ebp),%eax
  8011f9:	83 e8 04             	sub    $0x4,%eax
  8011fc:	8b 00                	mov    (%eax),%eax
  8011fe:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  801201:	eb 1f                	jmp    801222 <vprintfmt+0xea>

		case '.':
			if (width < 0)
  801203:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  801207:	79 83                	jns    80118c <vprintfmt+0x54>
				width = 0;
  801209:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  801210:	e9 77 ff ff ff       	jmp    80118c <vprintfmt+0x54>

		case '#':
			altflag = 1;
  801215:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  80121c:	e9 6b ff ff ff       	jmp    80118c <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  801221:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  801222:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  801226:	0f 89 60 ff ff ff    	jns    80118c <vprintfmt+0x54>
				width = precision, precision = -1;
  80122c:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80122f:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  801232:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  801239:	e9 4e ff ff ff       	jmp    80118c <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  80123e:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  801241:	e9 46 ff ff ff       	jmp    80118c <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  801246:	8b 45 14             	mov    0x14(%ebp),%eax
  801249:	83 c0 04             	add    $0x4,%eax
  80124c:	89 45 14             	mov    %eax,0x14(%ebp)
  80124f:	8b 45 14             	mov    0x14(%ebp),%eax
  801252:	83 e8 04             	sub    $0x4,%eax
  801255:	8b 00                	mov    (%eax),%eax
  801257:	83 ec 08             	sub    $0x8,%esp
  80125a:	ff 75 0c             	pushl  0xc(%ebp)
  80125d:	50                   	push   %eax
  80125e:	8b 45 08             	mov    0x8(%ebp),%eax
  801261:	ff d0                	call   *%eax
  801263:	83 c4 10             	add    $0x10,%esp
			break;
  801266:	e9 89 02 00 00       	jmp    8014f4 <vprintfmt+0x3bc>

		// error message
		case 'e':
			err = va_arg(ap, int);
  80126b:	8b 45 14             	mov    0x14(%ebp),%eax
  80126e:	83 c0 04             	add    $0x4,%eax
  801271:	89 45 14             	mov    %eax,0x14(%ebp)
  801274:	8b 45 14             	mov    0x14(%ebp),%eax
  801277:	83 e8 04             	sub    $0x4,%eax
  80127a:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  80127c:	85 db                	test   %ebx,%ebx
  80127e:	79 02                	jns    801282 <vprintfmt+0x14a>
				err = -err;
  801280:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  801282:	83 fb 64             	cmp    $0x64,%ebx
  801285:	7f 0b                	jg     801292 <vprintfmt+0x15a>
  801287:	8b 34 9d 80 3e 80 00 	mov    0x803e80(,%ebx,4),%esi
  80128e:	85 f6                	test   %esi,%esi
  801290:	75 19                	jne    8012ab <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  801292:	53                   	push   %ebx
  801293:	68 25 40 80 00       	push   $0x804025
  801298:	ff 75 0c             	pushl  0xc(%ebp)
  80129b:	ff 75 08             	pushl  0x8(%ebp)
  80129e:	e8 5e 02 00 00       	call   801501 <printfmt>
  8012a3:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  8012a6:	e9 49 02 00 00       	jmp    8014f4 <vprintfmt+0x3bc>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  8012ab:	56                   	push   %esi
  8012ac:	68 2e 40 80 00       	push   $0x80402e
  8012b1:	ff 75 0c             	pushl  0xc(%ebp)
  8012b4:	ff 75 08             	pushl  0x8(%ebp)
  8012b7:	e8 45 02 00 00       	call   801501 <printfmt>
  8012bc:	83 c4 10             	add    $0x10,%esp
			break;
  8012bf:	e9 30 02 00 00       	jmp    8014f4 <vprintfmt+0x3bc>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  8012c4:	8b 45 14             	mov    0x14(%ebp),%eax
  8012c7:	83 c0 04             	add    $0x4,%eax
  8012ca:	89 45 14             	mov    %eax,0x14(%ebp)
  8012cd:	8b 45 14             	mov    0x14(%ebp),%eax
  8012d0:	83 e8 04             	sub    $0x4,%eax
  8012d3:	8b 30                	mov    (%eax),%esi
  8012d5:	85 f6                	test   %esi,%esi
  8012d7:	75 05                	jne    8012de <vprintfmt+0x1a6>
				p = "(null)";
  8012d9:	be 31 40 80 00       	mov    $0x804031,%esi
			if (width > 0 && padc != '-')
  8012de:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8012e2:	7e 6d                	jle    801351 <vprintfmt+0x219>
  8012e4:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  8012e8:	74 67                	je     801351 <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  8012ea:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8012ed:	83 ec 08             	sub    $0x8,%esp
  8012f0:	50                   	push   %eax
  8012f1:	56                   	push   %esi
  8012f2:	e8 0c 03 00 00       	call   801603 <strnlen>
  8012f7:	83 c4 10             	add    $0x10,%esp
  8012fa:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  8012fd:	eb 16                	jmp    801315 <vprintfmt+0x1dd>
					putch(padc, putdat);
  8012ff:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  801303:	83 ec 08             	sub    $0x8,%esp
  801306:	ff 75 0c             	pushl  0xc(%ebp)
  801309:	50                   	push   %eax
  80130a:	8b 45 08             	mov    0x8(%ebp),%eax
  80130d:	ff d0                	call   *%eax
  80130f:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  801312:	ff 4d e4             	decl   -0x1c(%ebp)
  801315:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  801319:	7f e4                	jg     8012ff <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  80131b:	eb 34                	jmp    801351 <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  80131d:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  801321:	74 1c                	je     80133f <vprintfmt+0x207>
  801323:	83 fb 1f             	cmp    $0x1f,%ebx
  801326:	7e 05                	jle    80132d <vprintfmt+0x1f5>
  801328:	83 fb 7e             	cmp    $0x7e,%ebx
  80132b:	7e 12                	jle    80133f <vprintfmt+0x207>
					putch('?', putdat);
  80132d:	83 ec 08             	sub    $0x8,%esp
  801330:	ff 75 0c             	pushl  0xc(%ebp)
  801333:	6a 3f                	push   $0x3f
  801335:	8b 45 08             	mov    0x8(%ebp),%eax
  801338:	ff d0                	call   *%eax
  80133a:	83 c4 10             	add    $0x10,%esp
  80133d:	eb 0f                	jmp    80134e <vprintfmt+0x216>
				else
					putch(ch, putdat);
  80133f:	83 ec 08             	sub    $0x8,%esp
  801342:	ff 75 0c             	pushl  0xc(%ebp)
  801345:	53                   	push   %ebx
  801346:	8b 45 08             	mov    0x8(%ebp),%eax
  801349:	ff d0                	call   *%eax
  80134b:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  80134e:	ff 4d e4             	decl   -0x1c(%ebp)
  801351:	89 f0                	mov    %esi,%eax
  801353:	8d 70 01             	lea    0x1(%eax),%esi
  801356:	8a 00                	mov    (%eax),%al
  801358:	0f be d8             	movsbl %al,%ebx
  80135b:	85 db                	test   %ebx,%ebx
  80135d:	74 24                	je     801383 <vprintfmt+0x24b>
  80135f:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  801363:	78 b8                	js     80131d <vprintfmt+0x1e5>
  801365:	ff 4d e0             	decl   -0x20(%ebp)
  801368:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80136c:	79 af                	jns    80131d <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  80136e:	eb 13                	jmp    801383 <vprintfmt+0x24b>
				putch(' ', putdat);
  801370:	83 ec 08             	sub    $0x8,%esp
  801373:	ff 75 0c             	pushl  0xc(%ebp)
  801376:	6a 20                	push   $0x20
  801378:	8b 45 08             	mov    0x8(%ebp),%eax
  80137b:	ff d0                	call   *%eax
  80137d:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  801380:	ff 4d e4             	decl   -0x1c(%ebp)
  801383:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  801387:	7f e7                	jg     801370 <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  801389:	e9 66 01 00 00       	jmp    8014f4 <vprintfmt+0x3bc>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  80138e:	83 ec 08             	sub    $0x8,%esp
  801391:	ff 75 e8             	pushl  -0x18(%ebp)
  801394:	8d 45 14             	lea    0x14(%ebp),%eax
  801397:	50                   	push   %eax
  801398:	e8 3c fd ff ff       	call   8010d9 <getint>
  80139d:	83 c4 10             	add    $0x10,%esp
  8013a0:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8013a3:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  8013a6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8013a9:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8013ac:	85 d2                	test   %edx,%edx
  8013ae:	79 23                	jns    8013d3 <vprintfmt+0x29b>
				putch('-', putdat);
  8013b0:	83 ec 08             	sub    $0x8,%esp
  8013b3:	ff 75 0c             	pushl  0xc(%ebp)
  8013b6:	6a 2d                	push   $0x2d
  8013b8:	8b 45 08             	mov    0x8(%ebp),%eax
  8013bb:	ff d0                	call   *%eax
  8013bd:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  8013c0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8013c3:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8013c6:	f7 d8                	neg    %eax
  8013c8:	83 d2 00             	adc    $0x0,%edx
  8013cb:	f7 da                	neg    %edx
  8013cd:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8013d0:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  8013d3:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  8013da:	e9 bc 00 00 00       	jmp    80149b <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  8013df:	83 ec 08             	sub    $0x8,%esp
  8013e2:	ff 75 e8             	pushl  -0x18(%ebp)
  8013e5:	8d 45 14             	lea    0x14(%ebp),%eax
  8013e8:	50                   	push   %eax
  8013e9:	e8 84 fc ff ff       	call   801072 <getuint>
  8013ee:	83 c4 10             	add    $0x10,%esp
  8013f1:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8013f4:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  8013f7:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  8013fe:	e9 98 00 00 00       	jmp    80149b <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  801403:	83 ec 08             	sub    $0x8,%esp
  801406:	ff 75 0c             	pushl  0xc(%ebp)
  801409:	6a 58                	push   $0x58
  80140b:	8b 45 08             	mov    0x8(%ebp),%eax
  80140e:	ff d0                	call   *%eax
  801410:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  801413:	83 ec 08             	sub    $0x8,%esp
  801416:	ff 75 0c             	pushl  0xc(%ebp)
  801419:	6a 58                	push   $0x58
  80141b:	8b 45 08             	mov    0x8(%ebp),%eax
  80141e:	ff d0                	call   *%eax
  801420:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  801423:	83 ec 08             	sub    $0x8,%esp
  801426:	ff 75 0c             	pushl  0xc(%ebp)
  801429:	6a 58                	push   $0x58
  80142b:	8b 45 08             	mov    0x8(%ebp),%eax
  80142e:	ff d0                	call   *%eax
  801430:	83 c4 10             	add    $0x10,%esp
			break;
  801433:	e9 bc 00 00 00       	jmp    8014f4 <vprintfmt+0x3bc>

		// pointer
		case 'p':
			putch('0', putdat);
  801438:	83 ec 08             	sub    $0x8,%esp
  80143b:	ff 75 0c             	pushl  0xc(%ebp)
  80143e:	6a 30                	push   $0x30
  801440:	8b 45 08             	mov    0x8(%ebp),%eax
  801443:	ff d0                	call   *%eax
  801445:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  801448:	83 ec 08             	sub    $0x8,%esp
  80144b:	ff 75 0c             	pushl  0xc(%ebp)
  80144e:	6a 78                	push   $0x78
  801450:	8b 45 08             	mov    0x8(%ebp),%eax
  801453:	ff d0                	call   *%eax
  801455:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  801458:	8b 45 14             	mov    0x14(%ebp),%eax
  80145b:	83 c0 04             	add    $0x4,%eax
  80145e:	89 45 14             	mov    %eax,0x14(%ebp)
  801461:	8b 45 14             	mov    0x14(%ebp),%eax
  801464:	83 e8 04             	sub    $0x4,%eax
  801467:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  801469:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80146c:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  801473:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  80147a:	eb 1f                	jmp    80149b <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  80147c:	83 ec 08             	sub    $0x8,%esp
  80147f:	ff 75 e8             	pushl  -0x18(%ebp)
  801482:	8d 45 14             	lea    0x14(%ebp),%eax
  801485:	50                   	push   %eax
  801486:	e8 e7 fb ff ff       	call   801072 <getuint>
  80148b:	83 c4 10             	add    $0x10,%esp
  80148e:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801491:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  801494:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  80149b:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  80149f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8014a2:	83 ec 04             	sub    $0x4,%esp
  8014a5:	52                   	push   %edx
  8014a6:	ff 75 e4             	pushl  -0x1c(%ebp)
  8014a9:	50                   	push   %eax
  8014aa:	ff 75 f4             	pushl  -0xc(%ebp)
  8014ad:	ff 75 f0             	pushl  -0x10(%ebp)
  8014b0:	ff 75 0c             	pushl  0xc(%ebp)
  8014b3:	ff 75 08             	pushl  0x8(%ebp)
  8014b6:	e8 00 fb ff ff       	call   800fbb <printnum>
  8014bb:	83 c4 20             	add    $0x20,%esp
			break;
  8014be:	eb 34                	jmp    8014f4 <vprintfmt+0x3bc>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  8014c0:	83 ec 08             	sub    $0x8,%esp
  8014c3:	ff 75 0c             	pushl  0xc(%ebp)
  8014c6:	53                   	push   %ebx
  8014c7:	8b 45 08             	mov    0x8(%ebp),%eax
  8014ca:	ff d0                	call   *%eax
  8014cc:	83 c4 10             	add    $0x10,%esp
			break;
  8014cf:	eb 23                	jmp    8014f4 <vprintfmt+0x3bc>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  8014d1:	83 ec 08             	sub    $0x8,%esp
  8014d4:	ff 75 0c             	pushl  0xc(%ebp)
  8014d7:	6a 25                	push   $0x25
  8014d9:	8b 45 08             	mov    0x8(%ebp),%eax
  8014dc:	ff d0                	call   *%eax
  8014de:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  8014e1:	ff 4d 10             	decl   0x10(%ebp)
  8014e4:	eb 03                	jmp    8014e9 <vprintfmt+0x3b1>
  8014e6:	ff 4d 10             	decl   0x10(%ebp)
  8014e9:	8b 45 10             	mov    0x10(%ebp),%eax
  8014ec:	48                   	dec    %eax
  8014ed:	8a 00                	mov    (%eax),%al
  8014ef:	3c 25                	cmp    $0x25,%al
  8014f1:	75 f3                	jne    8014e6 <vprintfmt+0x3ae>
				/* do nothing */;
			break;
  8014f3:	90                   	nop
		}
	}
  8014f4:	e9 47 fc ff ff       	jmp    801140 <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  8014f9:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  8014fa:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8014fd:	5b                   	pop    %ebx
  8014fe:	5e                   	pop    %esi
  8014ff:	5d                   	pop    %ebp
  801500:	c3                   	ret    

00801501 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  801501:	55                   	push   %ebp
  801502:	89 e5                	mov    %esp,%ebp
  801504:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  801507:	8d 45 10             	lea    0x10(%ebp),%eax
  80150a:	83 c0 04             	add    $0x4,%eax
  80150d:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  801510:	8b 45 10             	mov    0x10(%ebp),%eax
  801513:	ff 75 f4             	pushl  -0xc(%ebp)
  801516:	50                   	push   %eax
  801517:	ff 75 0c             	pushl  0xc(%ebp)
  80151a:	ff 75 08             	pushl  0x8(%ebp)
  80151d:	e8 16 fc ff ff       	call   801138 <vprintfmt>
  801522:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  801525:	90                   	nop
  801526:	c9                   	leave  
  801527:	c3                   	ret    

00801528 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  801528:	55                   	push   %ebp
  801529:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  80152b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80152e:	8b 40 08             	mov    0x8(%eax),%eax
  801531:	8d 50 01             	lea    0x1(%eax),%edx
  801534:	8b 45 0c             	mov    0xc(%ebp),%eax
  801537:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  80153a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80153d:	8b 10                	mov    (%eax),%edx
  80153f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801542:	8b 40 04             	mov    0x4(%eax),%eax
  801545:	39 c2                	cmp    %eax,%edx
  801547:	73 12                	jae    80155b <sprintputch+0x33>
		*b->buf++ = ch;
  801549:	8b 45 0c             	mov    0xc(%ebp),%eax
  80154c:	8b 00                	mov    (%eax),%eax
  80154e:	8d 48 01             	lea    0x1(%eax),%ecx
  801551:	8b 55 0c             	mov    0xc(%ebp),%edx
  801554:	89 0a                	mov    %ecx,(%edx)
  801556:	8b 55 08             	mov    0x8(%ebp),%edx
  801559:	88 10                	mov    %dl,(%eax)
}
  80155b:	90                   	nop
  80155c:	5d                   	pop    %ebp
  80155d:	c3                   	ret    

0080155e <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  80155e:	55                   	push   %ebp
  80155f:	89 e5                	mov    %esp,%ebp
  801561:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  801564:	8b 45 08             	mov    0x8(%ebp),%eax
  801567:	89 45 ec             	mov    %eax,-0x14(%ebp)
  80156a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80156d:	8d 50 ff             	lea    -0x1(%eax),%edx
  801570:	8b 45 08             	mov    0x8(%ebp),%eax
  801573:	01 d0                	add    %edx,%eax
  801575:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801578:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  80157f:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801583:	74 06                	je     80158b <vsnprintf+0x2d>
  801585:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801589:	7f 07                	jg     801592 <vsnprintf+0x34>
		return -E_INVAL;
  80158b:	b8 03 00 00 00       	mov    $0x3,%eax
  801590:	eb 20                	jmp    8015b2 <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  801592:	ff 75 14             	pushl  0x14(%ebp)
  801595:	ff 75 10             	pushl  0x10(%ebp)
  801598:	8d 45 ec             	lea    -0x14(%ebp),%eax
  80159b:	50                   	push   %eax
  80159c:	68 28 15 80 00       	push   $0x801528
  8015a1:	e8 92 fb ff ff       	call   801138 <vprintfmt>
  8015a6:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  8015a9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8015ac:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  8015af:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  8015b2:	c9                   	leave  
  8015b3:	c3                   	ret    

008015b4 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  8015b4:	55                   	push   %ebp
  8015b5:	89 e5                	mov    %esp,%ebp
  8015b7:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  8015ba:	8d 45 10             	lea    0x10(%ebp),%eax
  8015bd:	83 c0 04             	add    $0x4,%eax
  8015c0:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  8015c3:	8b 45 10             	mov    0x10(%ebp),%eax
  8015c6:	ff 75 f4             	pushl  -0xc(%ebp)
  8015c9:	50                   	push   %eax
  8015ca:	ff 75 0c             	pushl  0xc(%ebp)
  8015cd:	ff 75 08             	pushl  0x8(%ebp)
  8015d0:	e8 89 ff ff ff       	call   80155e <vsnprintf>
  8015d5:	83 c4 10             	add    $0x10,%esp
  8015d8:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  8015db:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8015de:	c9                   	leave  
  8015df:	c3                   	ret    

008015e0 <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  8015e0:	55                   	push   %ebp
  8015e1:	89 e5                	mov    %esp,%ebp
  8015e3:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  8015e6:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8015ed:	eb 06                	jmp    8015f5 <strlen+0x15>
		n++;
  8015ef:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  8015f2:	ff 45 08             	incl   0x8(%ebp)
  8015f5:	8b 45 08             	mov    0x8(%ebp),%eax
  8015f8:	8a 00                	mov    (%eax),%al
  8015fa:	84 c0                	test   %al,%al
  8015fc:	75 f1                	jne    8015ef <strlen+0xf>
		n++;
	return n;
  8015fe:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  801601:	c9                   	leave  
  801602:	c3                   	ret    

00801603 <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  801603:	55                   	push   %ebp
  801604:	89 e5                	mov    %esp,%ebp
  801606:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  801609:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801610:	eb 09                	jmp    80161b <strnlen+0x18>
		n++;
  801612:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  801615:	ff 45 08             	incl   0x8(%ebp)
  801618:	ff 4d 0c             	decl   0xc(%ebp)
  80161b:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80161f:	74 09                	je     80162a <strnlen+0x27>
  801621:	8b 45 08             	mov    0x8(%ebp),%eax
  801624:	8a 00                	mov    (%eax),%al
  801626:	84 c0                	test   %al,%al
  801628:	75 e8                	jne    801612 <strnlen+0xf>
		n++;
	return n;
  80162a:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  80162d:	c9                   	leave  
  80162e:	c3                   	ret    

0080162f <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  80162f:	55                   	push   %ebp
  801630:	89 e5                	mov    %esp,%ebp
  801632:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  801635:	8b 45 08             	mov    0x8(%ebp),%eax
  801638:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  80163b:	90                   	nop
  80163c:	8b 45 08             	mov    0x8(%ebp),%eax
  80163f:	8d 50 01             	lea    0x1(%eax),%edx
  801642:	89 55 08             	mov    %edx,0x8(%ebp)
  801645:	8b 55 0c             	mov    0xc(%ebp),%edx
  801648:	8d 4a 01             	lea    0x1(%edx),%ecx
  80164b:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  80164e:	8a 12                	mov    (%edx),%dl
  801650:	88 10                	mov    %dl,(%eax)
  801652:	8a 00                	mov    (%eax),%al
  801654:	84 c0                	test   %al,%al
  801656:	75 e4                	jne    80163c <strcpy+0xd>
		/* do nothing */;
	return ret;
  801658:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  80165b:	c9                   	leave  
  80165c:	c3                   	ret    

0080165d <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  80165d:	55                   	push   %ebp
  80165e:	89 e5                	mov    %esp,%ebp
  801660:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  801663:	8b 45 08             	mov    0x8(%ebp),%eax
  801666:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  801669:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801670:	eb 1f                	jmp    801691 <strncpy+0x34>
		*dst++ = *src;
  801672:	8b 45 08             	mov    0x8(%ebp),%eax
  801675:	8d 50 01             	lea    0x1(%eax),%edx
  801678:	89 55 08             	mov    %edx,0x8(%ebp)
  80167b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80167e:	8a 12                	mov    (%edx),%dl
  801680:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  801682:	8b 45 0c             	mov    0xc(%ebp),%eax
  801685:	8a 00                	mov    (%eax),%al
  801687:	84 c0                	test   %al,%al
  801689:	74 03                	je     80168e <strncpy+0x31>
			src++;
  80168b:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  80168e:	ff 45 fc             	incl   -0x4(%ebp)
  801691:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801694:	3b 45 10             	cmp    0x10(%ebp),%eax
  801697:	72 d9                	jb     801672 <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  801699:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  80169c:	c9                   	leave  
  80169d:	c3                   	ret    

0080169e <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  80169e:	55                   	push   %ebp
  80169f:	89 e5                	mov    %esp,%ebp
  8016a1:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  8016a4:	8b 45 08             	mov    0x8(%ebp),%eax
  8016a7:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  8016aa:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8016ae:	74 30                	je     8016e0 <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  8016b0:	eb 16                	jmp    8016c8 <strlcpy+0x2a>
			*dst++ = *src++;
  8016b2:	8b 45 08             	mov    0x8(%ebp),%eax
  8016b5:	8d 50 01             	lea    0x1(%eax),%edx
  8016b8:	89 55 08             	mov    %edx,0x8(%ebp)
  8016bb:	8b 55 0c             	mov    0xc(%ebp),%edx
  8016be:	8d 4a 01             	lea    0x1(%edx),%ecx
  8016c1:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  8016c4:	8a 12                	mov    (%edx),%dl
  8016c6:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  8016c8:	ff 4d 10             	decl   0x10(%ebp)
  8016cb:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8016cf:	74 09                	je     8016da <strlcpy+0x3c>
  8016d1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8016d4:	8a 00                	mov    (%eax),%al
  8016d6:	84 c0                	test   %al,%al
  8016d8:	75 d8                	jne    8016b2 <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  8016da:	8b 45 08             	mov    0x8(%ebp),%eax
  8016dd:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  8016e0:	8b 55 08             	mov    0x8(%ebp),%edx
  8016e3:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8016e6:	29 c2                	sub    %eax,%edx
  8016e8:	89 d0                	mov    %edx,%eax
}
  8016ea:	c9                   	leave  
  8016eb:	c3                   	ret    

008016ec <strcmp>:

int
strcmp(const char *p, const char *q)
{
  8016ec:	55                   	push   %ebp
  8016ed:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  8016ef:	eb 06                	jmp    8016f7 <strcmp+0xb>
		p++, q++;
  8016f1:	ff 45 08             	incl   0x8(%ebp)
  8016f4:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  8016f7:	8b 45 08             	mov    0x8(%ebp),%eax
  8016fa:	8a 00                	mov    (%eax),%al
  8016fc:	84 c0                	test   %al,%al
  8016fe:	74 0e                	je     80170e <strcmp+0x22>
  801700:	8b 45 08             	mov    0x8(%ebp),%eax
  801703:	8a 10                	mov    (%eax),%dl
  801705:	8b 45 0c             	mov    0xc(%ebp),%eax
  801708:	8a 00                	mov    (%eax),%al
  80170a:	38 c2                	cmp    %al,%dl
  80170c:	74 e3                	je     8016f1 <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  80170e:	8b 45 08             	mov    0x8(%ebp),%eax
  801711:	8a 00                	mov    (%eax),%al
  801713:	0f b6 d0             	movzbl %al,%edx
  801716:	8b 45 0c             	mov    0xc(%ebp),%eax
  801719:	8a 00                	mov    (%eax),%al
  80171b:	0f b6 c0             	movzbl %al,%eax
  80171e:	29 c2                	sub    %eax,%edx
  801720:	89 d0                	mov    %edx,%eax
}
  801722:	5d                   	pop    %ebp
  801723:	c3                   	ret    

00801724 <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  801724:	55                   	push   %ebp
  801725:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  801727:	eb 09                	jmp    801732 <strncmp+0xe>
		n--, p++, q++;
  801729:	ff 4d 10             	decl   0x10(%ebp)
  80172c:	ff 45 08             	incl   0x8(%ebp)
  80172f:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  801732:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801736:	74 17                	je     80174f <strncmp+0x2b>
  801738:	8b 45 08             	mov    0x8(%ebp),%eax
  80173b:	8a 00                	mov    (%eax),%al
  80173d:	84 c0                	test   %al,%al
  80173f:	74 0e                	je     80174f <strncmp+0x2b>
  801741:	8b 45 08             	mov    0x8(%ebp),%eax
  801744:	8a 10                	mov    (%eax),%dl
  801746:	8b 45 0c             	mov    0xc(%ebp),%eax
  801749:	8a 00                	mov    (%eax),%al
  80174b:	38 c2                	cmp    %al,%dl
  80174d:	74 da                	je     801729 <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  80174f:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801753:	75 07                	jne    80175c <strncmp+0x38>
		return 0;
  801755:	b8 00 00 00 00       	mov    $0x0,%eax
  80175a:	eb 14                	jmp    801770 <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  80175c:	8b 45 08             	mov    0x8(%ebp),%eax
  80175f:	8a 00                	mov    (%eax),%al
  801761:	0f b6 d0             	movzbl %al,%edx
  801764:	8b 45 0c             	mov    0xc(%ebp),%eax
  801767:	8a 00                	mov    (%eax),%al
  801769:	0f b6 c0             	movzbl %al,%eax
  80176c:	29 c2                	sub    %eax,%edx
  80176e:	89 d0                	mov    %edx,%eax
}
  801770:	5d                   	pop    %ebp
  801771:	c3                   	ret    

00801772 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  801772:	55                   	push   %ebp
  801773:	89 e5                	mov    %esp,%ebp
  801775:	83 ec 04             	sub    $0x4,%esp
  801778:	8b 45 0c             	mov    0xc(%ebp),%eax
  80177b:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  80177e:	eb 12                	jmp    801792 <strchr+0x20>
		if (*s == c)
  801780:	8b 45 08             	mov    0x8(%ebp),%eax
  801783:	8a 00                	mov    (%eax),%al
  801785:	3a 45 fc             	cmp    -0x4(%ebp),%al
  801788:	75 05                	jne    80178f <strchr+0x1d>
			return (char *) s;
  80178a:	8b 45 08             	mov    0x8(%ebp),%eax
  80178d:	eb 11                	jmp    8017a0 <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  80178f:	ff 45 08             	incl   0x8(%ebp)
  801792:	8b 45 08             	mov    0x8(%ebp),%eax
  801795:	8a 00                	mov    (%eax),%al
  801797:	84 c0                	test   %al,%al
  801799:	75 e5                	jne    801780 <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  80179b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8017a0:	c9                   	leave  
  8017a1:	c3                   	ret    

008017a2 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  8017a2:	55                   	push   %ebp
  8017a3:	89 e5                	mov    %esp,%ebp
  8017a5:	83 ec 04             	sub    $0x4,%esp
  8017a8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8017ab:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  8017ae:	eb 0d                	jmp    8017bd <strfind+0x1b>
		if (*s == c)
  8017b0:	8b 45 08             	mov    0x8(%ebp),%eax
  8017b3:	8a 00                	mov    (%eax),%al
  8017b5:	3a 45 fc             	cmp    -0x4(%ebp),%al
  8017b8:	74 0e                	je     8017c8 <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  8017ba:	ff 45 08             	incl   0x8(%ebp)
  8017bd:	8b 45 08             	mov    0x8(%ebp),%eax
  8017c0:	8a 00                	mov    (%eax),%al
  8017c2:	84 c0                	test   %al,%al
  8017c4:	75 ea                	jne    8017b0 <strfind+0xe>
  8017c6:	eb 01                	jmp    8017c9 <strfind+0x27>
		if (*s == c)
			break;
  8017c8:	90                   	nop
	return (char *) s;
  8017c9:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8017cc:	c9                   	leave  
  8017cd:	c3                   	ret    

008017ce <memset>:


void *
memset(void *v, int c, uint32 n)
{
  8017ce:	55                   	push   %ebp
  8017cf:	89 e5                	mov    %esp,%ebp
  8017d1:	83 ec 10             	sub    $0x10,%esp
	char *p;
	int m;

	p = v;
  8017d4:	8b 45 08             	mov    0x8(%ebp),%eax
  8017d7:	89 45 fc             	mov    %eax,-0x4(%ebp)
	m = n;
  8017da:	8b 45 10             	mov    0x10(%ebp),%eax
  8017dd:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (--m >= 0)
  8017e0:	eb 0e                	jmp    8017f0 <memset+0x22>
		*p++ = c;
  8017e2:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8017e5:	8d 50 01             	lea    0x1(%eax),%edx
  8017e8:	89 55 fc             	mov    %edx,-0x4(%ebp)
  8017eb:	8b 55 0c             	mov    0xc(%ebp),%edx
  8017ee:	88 10                	mov    %dl,(%eax)
	char *p;
	int m;

	p = v;
	m = n;
	while (--m >= 0)
  8017f0:	ff 4d f8             	decl   -0x8(%ebp)
  8017f3:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  8017f7:	79 e9                	jns    8017e2 <memset+0x14>
		*p++ = c;

	return v;
  8017f9:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8017fc:	c9                   	leave  
  8017fd:	c3                   	ret    

008017fe <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  8017fe:	55                   	push   %ebp
  8017ff:	89 e5                	mov    %esp,%ebp
  801801:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  801804:	8b 45 0c             	mov    0xc(%ebp),%eax
  801807:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  80180a:	8b 45 08             	mov    0x8(%ebp),%eax
  80180d:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (n-- > 0)
  801810:	eb 16                	jmp    801828 <memcpy+0x2a>
		*d++ = *s++;
  801812:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801815:	8d 50 01             	lea    0x1(%eax),%edx
  801818:	89 55 f8             	mov    %edx,-0x8(%ebp)
  80181b:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80181e:	8d 4a 01             	lea    0x1(%edx),%ecx
  801821:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  801824:	8a 12                	mov    (%edx),%dl
  801826:	88 10                	mov    %dl,(%eax)
	const char *s;
	char *d;

	s = src;
	d = dst;
	while (n-- > 0)
  801828:	8b 45 10             	mov    0x10(%ebp),%eax
  80182b:	8d 50 ff             	lea    -0x1(%eax),%edx
  80182e:	89 55 10             	mov    %edx,0x10(%ebp)
  801831:	85 c0                	test   %eax,%eax
  801833:	75 dd                	jne    801812 <memcpy+0x14>
		*d++ = *s++;

	return dst;
  801835:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801838:	c9                   	leave  
  801839:	c3                   	ret    

0080183a <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  80183a:	55                   	push   %ebp
  80183b:	89 e5                	mov    %esp,%ebp
  80183d:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  801840:	8b 45 0c             	mov    0xc(%ebp),%eax
  801843:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  801846:	8b 45 08             	mov    0x8(%ebp),%eax
  801849:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  80184c:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80184f:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  801852:	73 50                	jae    8018a4 <memmove+0x6a>
  801854:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801857:	8b 45 10             	mov    0x10(%ebp),%eax
  80185a:	01 d0                	add    %edx,%eax
  80185c:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  80185f:	76 43                	jbe    8018a4 <memmove+0x6a>
		s += n;
  801861:	8b 45 10             	mov    0x10(%ebp),%eax
  801864:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  801867:	8b 45 10             	mov    0x10(%ebp),%eax
  80186a:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  80186d:	eb 10                	jmp    80187f <memmove+0x45>
			*--d = *--s;
  80186f:	ff 4d f8             	decl   -0x8(%ebp)
  801872:	ff 4d fc             	decl   -0x4(%ebp)
  801875:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801878:	8a 10                	mov    (%eax),%dl
  80187a:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80187d:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  80187f:	8b 45 10             	mov    0x10(%ebp),%eax
  801882:	8d 50 ff             	lea    -0x1(%eax),%edx
  801885:	89 55 10             	mov    %edx,0x10(%ebp)
  801888:	85 c0                	test   %eax,%eax
  80188a:	75 e3                	jne    80186f <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  80188c:	eb 23                	jmp    8018b1 <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  80188e:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801891:	8d 50 01             	lea    0x1(%eax),%edx
  801894:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801897:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80189a:	8d 4a 01             	lea    0x1(%edx),%ecx
  80189d:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  8018a0:	8a 12                	mov    (%edx),%dl
  8018a2:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  8018a4:	8b 45 10             	mov    0x10(%ebp),%eax
  8018a7:	8d 50 ff             	lea    -0x1(%eax),%edx
  8018aa:	89 55 10             	mov    %edx,0x10(%ebp)
  8018ad:	85 c0                	test   %eax,%eax
  8018af:	75 dd                	jne    80188e <memmove+0x54>
			*d++ = *s++;

	return dst;
  8018b1:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8018b4:	c9                   	leave  
  8018b5:	c3                   	ret    

008018b6 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  8018b6:	55                   	push   %ebp
  8018b7:	89 e5                	mov    %esp,%ebp
  8018b9:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  8018bc:	8b 45 08             	mov    0x8(%ebp),%eax
  8018bf:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  8018c2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8018c5:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  8018c8:	eb 2a                	jmp    8018f4 <memcmp+0x3e>
		if (*s1 != *s2)
  8018ca:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8018cd:	8a 10                	mov    (%eax),%dl
  8018cf:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8018d2:	8a 00                	mov    (%eax),%al
  8018d4:	38 c2                	cmp    %al,%dl
  8018d6:	74 16                	je     8018ee <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  8018d8:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8018db:	8a 00                	mov    (%eax),%al
  8018dd:	0f b6 d0             	movzbl %al,%edx
  8018e0:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8018e3:	8a 00                	mov    (%eax),%al
  8018e5:	0f b6 c0             	movzbl %al,%eax
  8018e8:	29 c2                	sub    %eax,%edx
  8018ea:	89 d0                	mov    %edx,%eax
  8018ec:	eb 18                	jmp    801906 <memcmp+0x50>
		s1++, s2++;
  8018ee:	ff 45 fc             	incl   -0x4(%ebp)
  8018f1:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  8018f4:	8b 45 10             	mov    0x10(%ebp),%eax
  8018f7:	8d 50 ff             	lea    -0x1(%eax),%edx
  8018fa:	89 55 10             	mov    %edx,0x10(%ebp)
  8018fd:	85 c0                	test   %eax,%eax
  8018ff:	75 c9                	jne    8018ca <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  801901:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801906:	c9                   	leave  
  801907:	c3                   	ret    

00801908 <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  801908:	55                   	push   %ebp
  801909:	89 e5                	mov    %esp,%ebp
  80190b:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  80190e:	8b 55 08             	mov    0x8(%ebp),%edx
  801911:	8b 45 10             	mov    0x10(%ebp),%eax
  801914:	01 d0                	add    %edx,%eax
  801916:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  801919:	eb 15                	jmp    801930 <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  80191b:	8b 45 08             	mov    0x8(%ebp),%eax
  80191e:	8a 00                	mov    (%eax),%al
  801920:	0f b6 d0             	movzbl %al,%edx
  801923:	8b 45 0c             	mov    0xc(%ebp),%eax
  801926:	0f b6 c0             	movzbl %al,%eax
  801929:	39 c2                	cmp    %eax,%edx
  80192b:	74 0d                	je     80193a <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  80192d:	ff 45 08             	incl   0x8(%ebp)
  801930:	8b 45 08             	mov    0x8(%ebp),%eax
  801933:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  801936:	72 e3                	jb     80191b <memfind+0x13>
  801938:	eb 01                	jmp    80193b <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  80193a:	90                   	nop
	return (void *) s;
  80193b:	8b 45 08             	mov    0x8(%ebp),%eax
}
  80193e:	c9                   	leave  
  80193f:	c3                   	ret    

00801940 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  801940:	55                   	push   %ebp
  801941:	89 e5                	mov    %esp,%ebp
  801943:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  801946:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  80194d:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801954:	eb 03                	jmp    801959 <strtol+0x19>
		s++;
  801956:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801959:	8b 45 08             	mov    0x8(%ebp),%eax
  80195c:	8a 00                	mov    (%eax),%al
  80195e:	3c 20                	cmp    $0x20,%al
  801960:	74 f4                	je     801956 <strtol+0x16>
  801962:	8b 45 08             	mov    0x8(%ebp),%eax
  801965:	8a 00                	mov    (%eax),%al
  801967:	3c 09                	cmp    $0x9,%al
  801969:	74 eb                	je     801956 <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  80196b:	8b 45 08             	mov    0x8(%ebp),%eax
  80196e:	8a 00                	mov    (%eax),%al
  801970:	3c 2b                	cmp    $0x2b,%al
  801972:	75 05                	jne    801979 <strtol+0x39>
		s++;
  801974:	ff 45 08             	incl   0x8(%ebp)
  801977:	eb 13                	jmp    80198c <strtol+0x4c>
	else if (*s == '-')
  801979:	8b 45 08             	mov    0x8(%ebp),%eax
  80197c:	8a 00                	mov    (%eax),%al
  80197e:	3c 2d                	cmp    $0x2d,%al
  801980:	75 0a                	jne    80198c <strtol+0x4c>
		s++, neg = 1;
  801982:	ff 45 08             	incl   0x8(%ebp)
  801985:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  80198c:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801990:	74 06                	je     801998 <strtol+0x58>
  801992:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  801996:	75 20                	jne    8019b8 <strtol+0x78>
  801998:	8b 45 08             	mov    0x8(%ebp),%eax
  80199b:	8a 00                	mov    (%eax),%al
  80199d:	3c 30                	cmp    $0x30,%al
  80199f:	75 17                	jne    8019b8 <strtol+0x78>
  8019a1:	8b 45 08             	mov    0x8(%ebp),%eax
  8019a4:	40                   	inc    %eax
  8019a5:	8a 00                	mov    (%eax),%al
  8019a7:	3c 78                	cmp    $0x78,%al
  8019a9:	75 0d                	jne    8019b8 <strtol+0x78>
		s += 2, base = 16;
  8019ab:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  8019af:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  8019b6:	eb 28                	jmp    8019e0 <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  8019b8:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8019bc:	75 15                	jne    8019d3 <strtol+0x93>
  8019be:	8b 45 08             	mov    0x8(%ebp),%eax
  8019c1:	8a 00                	mov    (%eax),%al
  8019c3:	3c 30                	cmp    $0x30,%al
  8019c5:	75 0c                	jne    8019d3 <strtol+0x93>
		s++, base = 8;
  8019c7:	ff 45 08             	incl   0x8(%ebp)
  8019ca:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  8019d1:	eb 0d                	jmp    8019e0 <strtol+0xa0>
	else if (base == 0)
  8019d3:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8019d7:	75 07                	jne    8019e0 <strtol+0xa0>
		base = 10;
  8019d9:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  8019e0:	8b 45 08             	mov    0x8(%ebp),%eax
  8019e3:	8a 00                	mov    (%eax),%al
  8019e5:	3c 2f                	cmp    $0x2f,%al
  8019e7:	7e 19                	jle    801a02 <strtol+0xc2>
  8019e9:	8b 45 08             	mov    0x8(%ebp),%eax
  8019ec:	8a 00                	mov    (%eax),%al
  8019ee:	3c 39                	cmp    $0x39,%al
  8019f0:	7f 10                	jg     801a02 <strtol+0xc2>
			dig = *s - '0';
  8019f2:	8b 45 08             	mov    0x8(%ebp),%eax
  8019f5:	8a 00                	mov    (%eax),%al
  8019f7:	0f be c0             	movsbl %al,%eax
  8019fa:	83 e8 30             	sub    $0x30,%eax
  8019fd:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801a00:	eb 42                	jmp    801a44 <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  801a02:	8b 45 08             	mov    0x8(%ebp),%eax
  801a05:	8a 00                	mov    (%eax),%al
  801a07:	3c 60                	cmp    $0x60,%al
  801a09:	7e 19                	jle    801a24 <strtol+0xe4>
  801a0b:	8b 45 08             	mov    0x8(%ebp),%eax
  801a0e:	8a 00                	mov    (%eax),%al
  801a10:	3c 7a                	cmp    $0x7a,%al
  801a12:	7f 10                	jg     801a24 <strtol+0xe4>
			dig = *s - 'a' + 10;
  801a14:	8b 45 08             	mov    0x8(%ebp),%eax
  801a17:	8a 00                	mov    (%eax),%al
  801a19:	0f be c0             	movsbl %al,%eax
  801a1c:	83 e8 57             	sub    $0x57,%eax
  801a1f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801a22:	eb 20                	jmp    801a44 <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  801a24:	8b 45 08             	mov    0x8(%ebp),%eax
  801a27:	8a 00                	mov    (%eax),%al
  801a29:	3c 40                	cmp    $0x40,%al
  801a2b:	7e 39                	jle    801a66 <strtol+0x126>
  801a2d:	8b 45 08             	mov    0x8(%ebp),%eax
  801a30:	8a 00                	mov    (%eax),%al
  801a32:	3c 5a                	cmp    $0x5a,%al
  801a34:	7f 30                	jg     801a66 <strtol+0x126>
			dig = *s - 'A' + 10;
  801a36:	8b 45 08             	mov    0x8(%ebp),%eax
  801a39:	8a 00                	mov    (%eax),%al
  801a3b:	0f be c0             	movsbl %al,%eax
  801a3e:	83 e8 37             	sub    $0x37,%eax
  801a41:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  801a44:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801a47:	3b 45 10             	cmp    0x10(%ebp),%eax
  801a4a:	7d 19                	jge    801a65 <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  801a4c:	ff 45 08             	incl   0x8(%ebp)
  801a4f:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801a52:	0f af 45 10          	imul   0x10(%ebp),%eax
  801a56:	89 c2                	mov    %eax,%edx
  801a58:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801a5b:	01 d0                	add    %edx,%eax
  801a5d:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  801a60:	e9 7b ff ff ff       	jmp    8019e0 <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  801a65:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  801a66:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801a6a:	74 08                	je     801a74 <strtol+0x134>
		*endptr = (char *) s;
  801a6c:	8b 45 0c             	mov    0xc(%ebp),%eax
  801a6f:	8b 55 08             	mov    0x8(%ebp),%edx
  801a72:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  801a74:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801a78:	74 07                	je     801a81 <strtol+0x141>
  801a7a:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801a7d:	f7 d8                	neg    %eax
  801a7f:	eb 03                	jmp    801a84 <strtol+0x144>
  801a81:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  801a84:	c9                   	leave  
  801a85:	c3                   	ret    

00801a86 <ltostr>:

void
ltostr(long value, char *str)
{
  801a86:	55                   	push   %ebp
  801a87:	89 e5                	mov    %esp,%ebp
  801a89:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  801a8c:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  801a93:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  801a9a:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801a9e:	79 13                	jns    801ab3 <ltostr+0x2d>
	{
		neg = 1;
  801aa0:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  801aa7:	8b 45 0c             	mov    0xc(%ebp),%eax
  801aaa:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  801aad:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  801ab0:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  801ab3:	8b 45 08             	mov    0x8(%ebp),%eax
  801ab6:	b9 0a 00 00 00       	mov    $0xa,%ecx
  801abb:	99                   	cltd   
  801abc:	f7 f9                	idiv   %ecx
  801abe:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  801ac1:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801ac4:	8d 50 01             	lea    0x1(%eax),%edx
  801ac7:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801aca:	89 c2                	mov    %eax,%edx
  801acc:	8b 45 0c             	mov    0xc(%ebp),%eax
  801acf:	01 d0                	add    %edx,%eax
  801ad1:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801ad4:	83 c2 30             	add    $0x30,%edx
  801ad7:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  801ad9:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801adc:	b8 67 66 66 66       	mov    $0x66666667,%eax
  801ae1:	f7 e9                	imul   %ecx
  801ae3:	c1 fa 02             	sar    $0x2,%edx
  801ae6:	89 c8                	mov    %ecx,%eax
  801ae8:	c1 f8 1f             	sar    $0x1f,%eax
  801aeb:	29 c2                	sub    %eax,%edx
  801aed:	89 d0                	mov    %edx,%eax
  801aef:	89 45 08             	mov    %eax,0x8(%ebp)
	} while (value % 10 != 0);
  801af2:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801af5:	b8 67 66 66 66       	mov    $0x66666667,%eax
  801afa:	f7 e9                	imul   %ecx
  801afc:	c1 fa 02             	sar    $0x2,%edx
  801aff:	89 c8                	mov    %ecx,%eax
  801b01:	c1 f8 1f             	sar    $0x1f,%eax
  801b04:	29 c2                	sub    %eax,%edx
  801b06:	89 d0                	mov    %edx,%eax
  801b08:	c1 e0 02             	shl    $0x2,%eax
  801b0b:	01 d0                	add    %edx,%eax
  801b0d:	01 c0                	add    %eax,%eax
  801b0f:	29 c1                	sub    %eax,%ecx
  801b11:	89 ca                	mov    %ecx,%edx
  801b13:	85 d2                	test   %edx,%edx
  801b15:	75 9c                	jne    801ab3 <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  801b17:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  801b1e:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801b21:	48                   	dec    %eax
  801b22:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  801b25:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801b29:	74 3d                	je     801b68 <ltostr+0xe2>
		start = 1 ;
  801b2b:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  801b32:	eb 34                	jmp    801b68 <ltostr+0xe2>
	{
		char tmp = str[start] ;
  801b34:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801b37:	8b 45 0c             	mov    0xc(%ebp),%eax
  801b3a:	01 d0                	add    %edx,%eax
  801b3c:	8a 00                	mov    (%eax),%al
  801b3e:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  801b41:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801b44:	8b 45 0c             	mov    0xc(%ebp),%eax
  801b47:	01 c2                	add    %eax,%edx
  801b49:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  801b4c:	8b 45 0c             	mov    0xc(%ebp),%eax
  801b4f:	01 c8                	add    %ecx,%eax
  801b51:	8a 00                	mov    (%eax),%al
  801b53:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  801b55:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801b58:	8b 45 0c             	mov    0xc(%ebp),%eax
  801b5b:	01 c2                	add    %eax,%edx
  801b5d:	8a 45 eb             	mov    -0x15(%ebp),%al
  801b60:	88 02                	mov    %al,(%edx)
		start++ ;
  801b62:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  801b65:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  801b68:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801b6b:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801b6e:	7c c4                	jl     801b34 <ltostr+0xae>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  801b70:	8b 55 f8             	mov    -0x8(%ebp),%edx
  801b73:	8b 45 0c             	mov    0xc(%ebp),%eax
  801b76:	01 d0                	add    %edx,%eax
  801b78:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  801b7b:	90                   	nop
  801b7c:	c9                   	leave  
  801b7d:	c3                   	ret    

00801b7e <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  801b7e:	55                   	push   %ebp
  801b7f:	89 e5                	mov    %esp,%ebp
  801b81:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  801b84:	ff 75 08             	pushl  0x8(%ebp)
  801b87:	e8 54 fa ff ff       	call   8015e0 <strlen>
  801b8c:	83 c4 04             	add    $0x4,%esp
  801b8f:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  801b92:	ff 75 0c             	pushl  0xc(%ebp)
  801b95:	e8 46 fa ff ff       	call   8015e0 <strlen>
  801b9a:	83 c4 04             	add    $0x4,%esp
  801b9d:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  801ba0:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  801ba7:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801bae:	eb 17                	jmp    801bc7 <strcconcat+0x49>
		final[s] = str1[s] ;
  801bb0:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801bb3:	8b 45 10             	mov    0x10(%ebp),%eax
  801bb6:	01 c2                	add    %eax,%edx
  801bb8:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  801bbb:	8b 45 08             	mov    0x8(%ebp),%eax
  801bbe:	01 c8                	add    %ecx,%eax
  801bc0:	8a 00                	mov    (%eax),%al
  801bc2:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  801bc4:	ff 45 fc             	incl   -0x4(%ebp)
  801bc7:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801bca:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  801bcd:	7c e1                	jl     801bb0 <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  801bcf:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  801bd6:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  801bdd:	eb 1f                	jmp    801bfe <strcconcat+0x80>
		final[s++] = str2[i] ;
  801bdf:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801be2:	8d 50 01             	lea    0x1(%eax),%edx
  801be5:	89 55 fc             	mov    %edx,-0x4(%ebp)
  801be8:	89 c2                	mov    %eax,%edx
  801bea:	8b 45 10             	mov    0x10(%ebp),%eax
  801bed:	01 c2                	add    %eax,%edx
  801bef:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  801bf2:	8b 45 0c             	mov    0xc(%ebp),%eax
  801bf5:	01 c8                	add    %ecx,%eax
  801bf7:	8a 00                	mov    (%eax),%al
  801bf9:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  801bfb:	ff 45 f8             	incl   -0x8(%ebp)
  801bfe:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801c01:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801c04:	7c d9                	jl     801bdf <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  801c06:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801c09:	8b 45 10             	mov    0x10(%ebp),%eax
  801c0c:	01 d0                	add    %edx,%eax
  801c0e:	c6 00 00             	movb   $0x0,(%eax)
}
  801c11:	90                   	nop
  801c12:	c9                   	leave  
  801c13:	c3                   	ret    

00801c14 <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  801c14:	55                   	push   %ebp
  801c15:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  801c17:	8b 45 14             	mov    0x14(%ebp),%eax
  801c1a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  801c20:	8b 45 14             	mov    0x14(%ebp),%eax
  801c23:	8b 00                	mov    (%eax),%eax
  801c25:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801c2c:	8b 45 10             	mov    0x10(%ebp),%eax
  801c2f:	01 d0                	add    %edx,%eax
  801c31:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801c37:	eb 0c                	jmp    801c45 <strsplit+0x31>
			*string++ = 0;
  801c39:	8b 45 08             	mov    0x8(%ebp),%eax
  801c3c:	8d 50 01             	lea    0x1(%eax),%edx
  801c3f:	89 55 08             	mov    %edx,0x8(%ebp)
  801c42:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801c45:	8b 45 08             	mov    0x8(%ebp),%eax
  801c48:	8a 00                	mov    (%eax),%al
  801c4a:	84 c0                	test   %al,%al
  801c4c:	74 18                	je     801c66 <strsplit+0x52>
  801c4e:	8b 45 08             	mov    0x8(%ebp),%eax
  801c51:	8a 00                	mov    (%eax),%al
  801c53:	0f be c0             	movsbl %al,%eax
  801c56:	50                   	push   %eax
  801c57:	ff 75 0c             	pushl  0xc(%ebp)
  801c5a:	e8 13 fb ff ff       	call   801772 <strchr>
  801c5f:	83 c4 08             	add    $0x8,%esp
  801c62:	85 c0                	test   %eax,%eax
  801c64:	75 d3                	jne    801c39 <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  801c66:	8b 45 08             	mov    0x8(%ebp),%eax
  801c69:	8a 00                	mov    (%eax),%al
  801c6b:	84 c0                	test   %al,%al
  801c6d:	74 5a                	je     801cc9 <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  801c6f:	8b 45 14             	mov    0x14(%ebp),%eax
  801c72:	8b 00                	mov    (%eax),%eax
  801c74:	83 f8 0f             	cmp    $0xf,%eax
  801c77:	75 07                	jne    801c80 <strsplit+0x6c>
		{
			return 0;
  801c79:	b8 00 00 00 00       	mov    $0x0,%eax
  801c7e:	eb 66                	jmp    801ce6 <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  801c80:	8b 45 14             	mov    0x14(%ebp),%eax
  801c83:	8b 00                	mov    (%eax),%eax
  801c85:	8d 48 01             	lea    0x1(%eax),%ecx
  801c88:	8b 55 14             	mov    0x14(%ebp),%edx
  801c8b:	89 0a                	mov    %ecx,(%edx)
  801c8d:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801c94:	8b 45 10             	mov    0x10(%ebp),%eax
  801c97:	01 c2                	add    %eax,%edx
  801c99:	8b 45 08             	mov    0x8(%ebp),%eax
  801c9c:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  801c9e:	eb 03                	jmp    801ca3 <strsplit+0x8f>
			string++;
  801ca0:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  801ca3:	8b 45 08             	mov    0x8(%ebp),%eax
  801ca6:	8a 00                	mov    (%eax),%al
  801ca8:	84 c0                	test   %al,%al
  801caa:	74 8b                	je     801c37 <strsplit+0x23>
  801cac:	8b 45 08             	mov    0x8(%ebp),%eax
  801caf:	8a 00                	mov    (%eax),%al
  801cb1:	0f be c0             	movsbl %al,%eax
  801cb4:	50                   	push   %eax
  801cb5:	ff 75 0c             	pushl  0xc(%ebp)
  801cb8:	e8 b5 fa ff ff       	call   801772 <strchr>
  801cbd:	83 c4 08             	add    $0x8,%esp
  801cc0:	85 c0                	test   %eax,%eax
  801cc2:	74 dc                	je     801ca0 <strsplit+0x8c>
			string++;
	}
  801cc4:	e9 6e ff ff ff       	jmp    801c37 <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  801cc9:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  801cca:	8b 45 14             	mov    0x14(%ebp),%eax
  801ccd:	8b 00                	mov    (%eax),%eax
  801ccf:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801cd6:	8b 45 10             	mov    0x10(%ebp),%eax
  801cd9:	01 d0                	add    %edx,%eax
  801cdb:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  801ce1:	b8 01 00 00 00       	mov    $0x1,%eax
}
  801ce6:	c9                   	leave  
  801ce7:	c3                   	ret    

00801ce8 <InitializeUHeap>:
//============================== GIVEN FUNCTIONS ===================================//
//==================================================================================//

int FirstTimeFlag = 1;
void InitializeUHeap()
{
  801ce8:	55                   	push   %ebp
  801ce9:	89 e5                	mov    %esp,%ebp
  801ceb:	83 ec 08             	sub    $0x8,%esp
	if(FirstTimeFlag)
  801cee:	a1 04 50 80 00       	mov    0x805004,%eax
  801cf3:	85 c0                	test   %eax,%eax
  801cf5:	74 1f                	je     801d16 <InitializeUHeap+0x2e>
	{
		initialize_dyn_block_system();
  801cf7:	e8 1d 00 00 00       	call   801d19 <initialize_dyn_block_system>
		cprintf("DYNAMIC BLOCK SYSTEM IS INITIALIZED\n");
  801cfc:	83 ec 0c             	sub    $0xc,%esp
  801cff:	68 90 41 80 00       	push   $0x804190
  801d04:	e8 55 f2 ff ff       	call   800f5e <cprintf>
  801d09:	83 c4 10             	add    $0x10,%esp
#if UHP_USE_BUDDY
		initialize_buddy();
		cprintf("BUDDY SYSTEM IS INITIALIZED\n");
#endif
		FirstTimeFlag = 0;
  801d0c:	c7 05 04 50 80 00 00 	movl   $0x0,0x805004
  801d13:	00 00 00 
	}
}
  801d16:	90                   	nop
  801d17:	c9                   	leave  
  801d18:	c3                   	ret    

00801d19 <initialize_dyn_block_system>:

//=================================
// [1] INITIALIZE DYNAMIC ALLOCATOR:
//=================================
void initialize_dyn_block_system()
{
  801d19:	55                   	push   %ebp
  801d1a:	89 e5                	mov    %esp,%ebp
  801d1c:	83 ec 28             	sub    $0x28,%esp
	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] initialize_dyn_block_system
	// your code is here, remove the panic and write your code
	//panic("initialize_dyn_block_system() is not implemented yet...!!");

	LIST_INIT(&AllocMemBlocksList);
  801d1f:	c7 05 40 50 80 00 00 	movl   $0x0,0x805040
  801d26:	00 00 00 
  801d29:	c7 05 44 50 80 00 00 	movl   $0x0,0x805044
  801d30:	00 00 00 
  801d33:	c7 05 4c 50 80 00 00 	movl   $0x0,0x80504c
  801d3a:	00 00 00 
	LIST_INIT(&FreeMemBlocksList);
  801d3d:	c7 05 38 51 80 00 00 	movl   $0x0,0x805138
  801d44:	00 00 00 
  801d47:	c7 05 3c 51 80 00 00 	movl   $0x0,0x80513c
  801d4e:	00 00 00 
  801d51:	c7 05 44 51 80 00 00 	movl   $0x0,0x805144
  801d58:	00 00 00 
	MAX_MEM_BLOCK_CNT = NUM_OF_UHEAP_PAGES;
  801d5b:	c7 05 20 51 80 00 00 	movl   $0x20000,0x805120
  801d62:	00 02 00 
	MemBlockNodes = (void*)USER_DYN_BLKS_ARRAY;
  801d65:	c7 45 f4 00 00 e0 7f 	movl   $0x7fe00000,-0xc(%ebp)
  801d6c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801d6f:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801d74:	2d 00 10 00 00       	sub    $0x1000,%eax
  801d79:	a3 50 50 80 00       	mov    %eax,0x805050
	int size_of_block = sizeof(struct MemBlock);
  801d7e:	c7 45 f0 10 00 00 00 	movl   $0x10,-0x10(%ebp)
	int size_all_struct = size_of_block*MAX_MEM_BLOCK_CNT;
  801d85:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801d88:	a1 20 51 80 00       	mov    0x805120,%eax
  801d8d:	0f af c2             	imul   %edx,%eax
  801d90:	89 45 ec             	mov    %eax,-0x14(%ebp)
	size_all_struct = ROUNDUP(size_all_struct, PAGE_SIZE);
  801d93:	c7 45 e8 00 10 00 00 	movl   $0x1000,-0x18(%ebp)
  801d9a:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801d9d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801da0:	01 d0                	add    %edx,%eax
  801da2:	48                   	dec    %eax
  801da3:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  801da6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801da9:	ba 00 00 00 00       	mov    $0x0,%edx
  801dae:	f7 75 e8             	divl   -0x18(%ebp)
  801db1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801db4:	29 d0                	sub    %edx,%eax
  801db6:	89 45 ec             	mov    %eax,-0x14(%ebp)
	sys_allocate_chunk(USER_DYN_BLKS_ARRAY, size_all_struct,PERM_USER| PERM_WRITEABLE);
  801db9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801dbc:	c7 45 e0 00 00 e0 7f 	movl   $0x7fe00000,-0x20(%ebp)
  801dc3:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801dc6:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
  801dcc:	81 ea 00 10 00 00    	sub    $0x1000,%edx
  801dd2:	83 ec 04             	sub    $0x4,%esp
  801dd5:	6a 06                	push   $0x6
  801dd7:	50                   	push   %eax
  801dd8:	52                   	push   %edx
  801dd9:	e8 a1 05 00 00       	call   80237f <sys_allocate_chunk>
  801dde:	83 c4 10             	add    $0x10,%esp
	initialize_MemBlocksList(MAX_MEM_BLOCK_CNT);
  801de1:	a1 20 51 80 00       	mov    0x805120,%eax
  801de6:	83 ec 0c             	sub    $0xc,%esp
  801de9:	50                   	push   %eax
  801dea:	e8 16 0c 00 00       	call   802a05 <initialize_MemBlocksList>
  801def:	83 c4 10             	add    $0x10,%esp
	struct MemBlock* ourBlock =LIST_LAST(&AvailableMemBlocksList);
  801df2:	a1 4c 51 80 00       	mov    0x80514c,%eax
  801df7:	89 45 dc             	mov    %eax,-0x24(%ebp)
	LIST_REMOVE(&AvailableMemBlocksList,ourBlock);
  801dfa:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  801dfe:	75 14                	jne    801e14 <initialize_dyn_block_system+0xfb>
  801e00:	83 ec 04             	sub    $0x4,%esp
  801e03:	68 b5 41 80 00       	push   $0x8041b5
  801e08:	6a 2d                	push   $0x2d
  801e0a:	68 d3 41 80 00       	push   $0x8041d3
  801e0f:	e8 96 ee ff ff       	call   800caa <_panic>
  801e14:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801e17:	8b 00                	mov    (%eax),%eax
  801e19:	85 c0                	test   %eax,%eax
  801e1b:	74 10                	je     801e2d <initialize_dyn_block_system+0x114>
  801e1d:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801e20:	8b 00                	mov    (%eax),%eax
  801e22:	8b 55 dc             	mov    -0x24(%ebp),%edx
  801e25:	8b 52 04             	mov    0x4(%edx),%edx
  801e28:	89 50 04             	mov    %edx,0x4(%eax)
  801e2b:	eb 0b                	jmp    801e38 <initialize_dyn_block_system+0x11f>
  801e2d:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801e30:	8b 40 04             	mov    0x4(%eax),%eax
  801e33:	a3 4c 51 80 00       	mov    %eax,0x80514c
  801e38:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801e3b:	8b 40 04             	mov    0x4(%eax),%eax
  801e3e:	85 c0                	test   %eax,%eax
  801e40:	74 0f                	je     801e51 <initialize_dyn_block_system+0x138>
  801e42:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801e45:	8b 40 04             	mov    0x4(%eax),%eax
  801e48:	8b 55 dc             	mov    -0x24(%ebp),%edx
  801e4b:	8b 12                	mov    (%edx),%edx
  801e4d:	89 10                	mov    %edx,(%eax)
  801e4f:	eb 0a                	jmp    801e5b <initialize_dyn_block_system+0x142>
  801e51:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801e54:	8b 00                	mov    (%eax),%eax
  801e56:	a3 48 51 80 00       	mov    %eax,0x805148
  801e5b:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801e5e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  801e64:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801e67:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  801e6e:	a1 54 51 80 00       	mov    0x805154,%eax
  801e73:	48                   	dec    %eax
  801e74:	a3 54 51 80 00       	mov    %eax,0x805154
	ourBlock->size = USER_HEAP_MAX-USER_HEAP_START;
  801e79:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801e7c:	c7 40 0c 00 00 00 20 	movl   $0x20000000,0xc(%eax)
	ourBlock->sva=USER_HEAP_START;
  801e83:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801e86:	c7 40 08 00 00 00 80 	movl   $0x80000000,0x8(%eax)
	LIST_INSERT_TAIL(&FreeMemBlocksList, ourBlock);
  801e8d:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  801e91:	75 14                	jne    801ea7 <initialize_dyn_block_system+0x18e>
  801e93:	83 ec 04             	sub    $0x4,%esp
  801e96:	68 e0 41 80 00       	push   $0x8041e0
  801e9b:	6a 30                	push   $0x30
  801e9d:	68 d3 41 80 00       	push   $0x8041d3
  801ea2:	e8 03 ee ff ff       	call   800caa <_panic>
  801ea7:	8b 15 3c 51 80 00    	mov    0x80513c,%edx
  801ead:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801eb0:	89 50 04             	mov    %edx,0x4(%eax)
  801eb3:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801eb6:	8b 40 04             	mov    0x4(%eax),%eax
  801eb9:	85 c0                	test   %eax,%eax
  801ebb:	74 0c                	je     801ec9 <initialize_dyn_block_system+0x1b0>
  801ebd:	a1 3c 51 80 00       	mov    0x80513c,%eax
  801ec2:	8b 55 dc             	mov    -0x24(%ebp),%edx
  801ec5:	89 10                	mov    %edx,(%eax)
  801ec7:	eb 08                	jmp    801ed1 <initialize_dyn_block_system+0x1b8>
  801ec9:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801ecc:	a3 38 51 80 00       	mov    %eax,0x805138
  801ed1:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801ed4:	a3 3c 51 80 00       	mov    %eax,0x80513c
  801ed9:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801edc:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  801ee2:	a1 44 51 80 00       	mov    0x805144,%eax
  801ee7:	40                   	inc    %eax
  801ee8:	a3 44 51 80 00       	mov    %eax,0x805144
	//[1] Initialize two lists (AllocMemBlocksList & FreeMemBlocksList) [Hint: use LIST_INIT()]
	//[2] Dynamically allocate the array of MemBlockNodes at VA USER_DYN_BLKS_ARRAY
	//	  (remember to set MAX_MEM_BLOCK_CNT with the chosen size of the array)
	//[3] Initialize AvailableMemBlocksList by filling it with the MemBlockNodes
	//[4] Insert a new MemBlock with the heap size into the FreeMemBlocksList
}
  801eed:	90                   	nop
  801eee:	c9                   	leave  
  801eef:	c3                   	ret    

00801ef0 <malloc>:
//=================================
// [2] ALLOCATE SPACE IN USER HEAP:
//=================================

void* malloc(uint32 size)
{
  801ef0:	55                   	push   %ebp
  801ef1:	89 e5                	mov    %esp,%ebp
  801ef3:	83 ec 18             	sub    $0x18,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801ef6:	e8 ed fd ff ff       	call   801ce8 <InitializeUHeap>
	if (size == 0) return NULL ;
  801efb:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801eff:	75 07                	jne    801f08 <malloc+0x18>
  801f01:	b8 00 00 00 00       	mov    $0x0,%eax
  801f06:	eb 67                	jmp    801f6f <malloc+0x7f>

	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] malloc
	// your code is here, remove the panic and write your code
	//panic("malloc() is not implemented yet...!!");

	size = ROUNDUP(size, PAGE_SIZE);
  801f08:	c7 45 f4 00 10 00 00 	movl   $0x1000,-0xc(%ebp)
  801f0f:	8b 55 08             	mov    0x8(%ebp),%edx
  801f12:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f15:	01 d0                	add    %edx,%eax
  801f17:	48                   	dec    %eax
  801f18:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801f1b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801f1e:	ba 00 00 00 00       	mov    $0x0,%edx
  801f23:	f7 75 f4             	divl   -0xc(%ebp)
  801f26:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801f29:	29 d0                	sub    %edx,%eax
  801f2b:	89 45 08             	mov    %eax,0x8(%ebp)
	if(sys_isUHeapPlacementStrategyFIRSTFIT())
  801f2e:	e8 1a 08 00 00       	call   80274d <sys_isUHeapPlacementStrategyFIRSTFIT>
  801f33:	85 c0                	test   %eax,%eax
  801f35:	74 33                	je     801f6a <malloc+0x7a>
	{
		struct MemBlock * myBlock = alloc_block_FF(size);
  801f37:	83 ec 0c             	sub    $0xc,%esp
  801f3a:	ff 75 08             	pushl  0x8(%ebp)
  801f3d:	e8 0c 0e 00 00       	call   802d4e <alloc_block_FF>
  801f42:	83 c4 10             	add    $0x10,%esp
  801f45:	89 45 ec             	mov    %eax,-0x14(%ebp)
		if(myBlock != NULL)
  801f48:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  801f4c:	74 1c                	je     801f6a <malloc+0x7a>
		{
			insert_sorted_allocList(myBlock);
  801f4e:	83 ec 0c             	sub    $0xc,%esp
  801f51:	ff 75 ec             	pushl  -0x14(%ebp)
  801f54:	e8 07 0c 00 00       	call   802b60 <insert_sorted_allocList>
  801f59:	83 c4 10             	add    $0x10,%esp
			uint32 ptr = myBlock->sva;
  801f5c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801f5f:	8b 40 08             	mov    0x8(%eax),%eax
  801f62:	89 45 e8             	mov    %eax,-0x18(%ebp)
			return (void *)ptr;
  801f65:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801f68:	eb 05                	jmp    801f6f <malloc+0x7f>
		}
	}
	return NULL;
  801f6a:	b8 00 00 00 00       	mov    $0x0,%eax
	//		to the required allocation size (space should be on 4 KB BOUNDARY)
	//	2) if no suitable space found, return NULL
	// 	3) Return pointer containing the virtual address of allocated space,
	//
	//Use sys_isUHeapPlacementStrategyFIRSTFIT()... to check the current strategy
}
  801f6f:	c9                   	leave  
  801f70:	c3                   	ret    

00801f71 <free>:
//	We can use sys_free_user_mem(uint32 virtual_address, uint32 size); which
//		switches to the kernel mode, calls free_user_mem() in
//		"kern/mem/chunk_operations.c", then switch back to the user mode here
//	the free_user_mem function is empty, make sure to implement it.
void free(void* virtual_address)
{
  801f71:	55                   	push   %ebp
  801f72:	89 e5                	mov    %esp,%ebp
  801f74:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] free
	// your code is here, remove the panic and write your code
	//panic("free() is not implemented yet...!!");

	uint32 virtualAddress = (uint32 )(virtual_address);
  801f77:	8b 45 08             	mov    0x8(%ebp),%eax
  801f7a:	89 45 f4             	mov    %eax,-0xc(%ebp)
//	virtualAddress = ROUNDDOWN(virtualAddress, PAGE_SIZE);
	struct MemBlock * myBlock = find_block(&AllocMemBlocksList, virtualAddress);
  801f7d:	83 ec 08             	sub    $0x8,%esp
  801f80:	ff 75 f4             	pushl  -0xc(%ebp)
  801f83:	68 40 50 80 00       	push   $0x805040
  801f88:	e8 5b 0b 00 00       	call   802ae8 <find_block>
  801f8d:	83 c4 10             	add    $0x10,%esp
  801f90:	89 45 f0             	mov    %eax,-0x10(%ebp)
//	cprintf ("ptr sva at free user side = %x \n", myBlock->sva);
	sys_free_user_mem(virtualAddress, myBlock->size);
  801f93:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801f96:	8b 40 0c             	mov    0xc(%eax),%eax
  801f99:	83 ec 08             	sub    $0x8,%esp
  801f9c:	50                   	push   %eax
  801f9d:	ff 75 f4             	pushl  -0xc(%ebp)
  801fa0:	e8 a2 03 00 00       	call   802347 <sys_free_user_mem>
  801fa5:	83 c4 10             	add    $0x10,%esp
	LIST_REMOVE(&AllocMemBlocksList, myBlock);
  801fa8:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801fac:	75 14                	jne    801fc2 <free+0x51>
  801fae:	83 ec 04             	sub    $0x4,%esp
  801fb1:	68 b5 41 80 00       	push   $0x8041b5
  801fb6:	6a 76                	push   $0x76
  801fb8:	68 d3 41 80 00       	push   $0x8041d3
  801fbd:	e8 e8 ec ff ff       	call   800caa <_panic>
  801fc2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801fc5:	8b 00                	mov    (%eax),%eax
  801fc7:	85 c0                	test   %eax,%eax
  801fc9:	74 10                	je     801fdb <free+0x6a>
  801fcb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801fce:	8b 00                	mov    (%eax),%eax
  801fd0:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801fd3:	8b 52 04             	mov    0x4(%edx),%edx
  801fd6:	89 50 04             	mov    %edx,0x4(%eax)
  801fd9:	eb 0b                	jmp    801fe6 <free+0x75>
  801fdb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801fde:	8b 40 04             	mov    0x4(%eax),%eax
  801fe1:	a3 44 50 80 00       	mov    %eax,0x805044
  801fe6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801fe9:	8b 40 04             	mov    0x4(%eax),%eax
  801fec:	85 c0                	test   %eax,%eax
  801fee:	74 0f                	je     801fff <free+0x8e>
  801ff0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801ff3:	8b 40 04             	mov    0x4(%eax),%eax
  801ff6:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801ff9:	8b 12                	mov    (%edx),%edx
  801ffb:	89 10                	mov    %edx,(%eax)
  801ffd:	eb 0a                	jmp    802009 <free+0x98>
  801fff:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802002:	8b 00                	mov    (%eax),%eax
  802004:	a3 40 50 80 00       	mov    %eax,0x805040
  802009:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80200c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802012:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802015:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80201c:	a1 4c 50 80 00       	mov    0x80504c,%eax
  802021:	48                   	dec    %eax
  802022:	a3 4c 50 80 00       	mov    %eax,0x80504c
	insert_sorted_with_merge_freeList(myBlock);
  802027:	83 ec 0c             	sub    $0xc,%esp
  80202a:	ff 75 f0             	pushl  -0x10(%ebp)
  80202d:	e8 0b 14 00 00       	call   80343d <insert_sorted_with_merge_freeList>
  802032:	83 c4 10             	add    $0x10,%esp

	//you should get the size of the given allocation using its address
	//you need to call sys_free_user_mem()
	//refer to the project presentation and documentation for details
}
  802035:	90                   	nop
  802036:	c9                   	leave  
  802037:	c3                   	ret    

00802038 <smalloc>:

//=================================
// [4] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
  802038:	55                   	push   %ebp
  802039:	89 e5                	mov    %esp,%ebp
  80203b:	83 ec 28             	sub    $0x28,%esp
  80203e:	8b 45 10             	mov    0x10(%ebp),%eax
  802041:	88 45 e4             	mov    %al,-0x1c(%ebp)
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  802044:	e8 9f fc ff ff       	call   801ce8 <InitializeUHeap>
	if (size == 0) return NULL ;
  802049:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80204d:	75 0a                	jne    802059 <smalloc+0x21>
  80204f:	b8 00 00 00 00       	mov    $0x0,%eax
  802054:	e9 8d 00 00 00       	jmp    8020e6 <smalloc+0xae>

	//This function should find the space of the required range
	// * ON 4KB BOUNDARY **** //
	//Use sys_isUHeapPlacementStrategyFIRSTFIT() to check the current strategy

	size = ROUNDUP(size, PAGE_SIZE);
  802059:	c7 45 f4 00 10 00 00 	movl   $0x1000,-0xc(%ebp)
  802060:	8b 55 0c             	mov    0xc(%ebp),%edx
  802063:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802066:	01 d0                	add    %edx,%eax
  802068:	48                   	dec    %eax
  802069:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80206c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80206f:	ba 00 00 00 00       	mov    $0x0,%edx
  802074:	f7 75 f4             	divl   -0xc(%ebp)
  802077:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80207a:	29 d0                	sub    %edx,%eax
  80207c:	89 45 0c             	mov    %eax,0xc(%ebp)
		if(sys_isUHeapPlacementStrategyFIRSTFIT())
  80207f:	e8 c9 06 00 00       	call   80274d <sys_isUHeapPlacementStrategyFIRSTFIT>
  802084:	85 c0                	test   %eax,%eax
  802086:	74 59                	je     8020e1 <smalloc+0xa9>
		{
			struct MemBlock * v1=NULL;
  802088:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
			v1= alloc_block_FF(size);
  80208f:	83 ec 0c             	sub    $0xc,%esp
  802092:	ff 75 0c             	pushl  0xc(%ebp)
  802095:	e8 b4 0c 00 00       	call   802d4e <alloc_block_FF>
  80209a:	83 c4 10             	add    $0x10,%esp
  80209d:	89 45 ec             	mov    %eax,-0x14(%ebp)
			if(v1==NULL)
  8020a0:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8020a4:	75 07                	jne    8020ad <smalloc+0x75>
			{
				return NULL;
  8020a6:	b8 00 00 00 00       	mov    $0x0,%eax
  8020ab:	eb 39                	jmp    8020e6 <smalloc+0xae>
			}
			else
			{
				int ret=sys_createSharedObject(sharedVarName,  size,  isWritable,(void*)v1->sva);
  8020ad:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8020b0:	8b 40 08             	mov    0x8(%eax),%eax
  8020b3:	89 c2                	mov    %eax,%edx
  8020b5:	0f b6 45 e4          	movzbl -0x1c(%ebp),%eax
  8020b9:	52                   	push   %edx
  8020ba:	50                   	push   %eax
  8020bb:	ff 75 0c             	pushl  0xc(%ebp)
  8020be:	ff 75 08             	pushl  0x8(%ebp)
  8020c1:	e8 0c 04 00 00       	call   8024d2 <sys_createSharedObject>
  8020c6:	83 c4 10             	add    $0x10,%esp
  8020c9:	89 45 e8             	mov    %eax,-0x18(%ebp)
				if(ret>=0)
  8020cc:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8020d0:	78 08                	js     8020da <smalloc+0xa2>
				{
					return (void*)v1->sva;
  8020d2:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8020d5:	8b 40 08             	mov    0x8(%eax),%eax
  8020d8:	eb 0c                	jmp    8020e6 <smalloc+0xae>
				}
				else
				{
					return NULL;
  8020da:	b8 00 00 00 00       	mov    $0x0,%eax
  8020df:	eb 05                	jmp    8020e6 <smalloc+0xae>
				}
			}

		}
		return NULL;
  8020e1:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8020e6:	c9                   	leave  
  8020e7:	c3                   	ret    

008020e8 <sget>:

//========================================
// [5] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  8020e8:	55                   	push   %ebp
  8020e9:	89 e5                	mov    %esp,%ebp
  8020eb:	83 ec 18             	sub    $0x18,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  8020ee:	e8 f5 fb ff ff       	call   801ce8 <InitializeUHeap>

	//This function should find the space for sharing the variable
	// *** ON 4KB BOUNDARY ******** //

	//Use sys_isUHeapPlacementStrategyFIRSTFIT() to check the current strategy
	int ret=sys_getSizeOfSharedObject(ownerEnvID,sharedVarName);
  8020f3:	83 ec 08             	sub    $0x8,%esp
  8020f6:	ff 75 0c             	pushl  0xc(%ebp)
  8020f9:	ff 75 08             	pushl  0x8(%ebp)
  8020fc:	e8 fb 03 00 00       	call   8024fc <sys_getSizeOfSharedObject>
  802101:	83 c4 10             	add    $0x10,%esp
  802104:	89 45 f4             	mov    %eax,-0xc(%ebp)
	if(ret==0)
  802107:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80210b:	75 07                	jne    802114 <sget+0x2c>
	{
		return NULL;
  80210d:	b8 00 00 00 00       	mov    $0x0,%eax
  802112:	eb 64                	jmp    802178 <sget+0x90>
	}
	if(sys_isUHeapPlacementStrategyFIRSTFIT())
  802114:	e8 34 06 00 00       	call   80274d <sys_isUHeapPlacementStrategyFIRSTFIT>
  802119:	85 c0                	test   %eax,%eax
  80211b:	74 56                	je     802173 <sget+0x8b>
	{
		struct MemBlock * v1=NULL;
  80211d:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
		v1= alloc_block_FF(ret);
  802124:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802127:	83 ec 0c             	sub    $0xc,%esp
  80212a:	50                   	push   %eax
  80212b:	e8 1e 0c 00 00       	call   802d4e <alloc_block_FF>
  802130:	83 c4 10             	add    $0x10,%esp
  802133:	89 45 f0             	mov    %eax,-0x10(%ebp)
		if(v1==NULL)
  802136:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80213a:	75 07                	jne    802143 <sget+0x5b>
		{
		return NULL;
  80213c:	b8 00 00 00 00       	mov    $0x0,%eax
  802141:	eb 35                	jmp    802178 <sget+0x90>
	    }
		else
		{
			int ret1=sys_getSharedObject(ownerEnvID,sharedVarName,(void*)v1->sva);
  802143:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802146:	8b 40 08             	mov    0x8(%eax),%eax
  802149:	83 ec 04             	sub    $0x4,%esp
  80214c:	50                   	push   %eax
  80214d:	ff 75 0c             	pushl  0xc(%ebp)
  802150:	ff 75 08             	pushl  0x8(%ebp)
  802153:	e8 c1 03 00 00       	call   802519 <sys_getSharedObject>
  802158:	83 c4 10             	add    $0x10,%esp
  80215b:	89 45 ec             	mov    %eax,-0x14(%ebp)
			if(ret1>=0)
  80215e:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802162:	78 08                	js     80216c <sget+0x84>
			{
				return (void*)v1->sva;
  802164:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802167:	8b 40 08             	mov    0x8(%eax),%eax
  80216a:	eb 0c                	jmp    802178 <sget+0x90>
			}
			else
			{
				return NULL;
  80216c:	b8 00 00 00 00       	mov    $0x0,%eax
  802171:	eb 05                	jmp    802178 <sget+0x90>
			}
		}
	}
  return NULL;
  802173:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802178:	c9                   	leave  
  802179:	c3                   	ret    

0080217a <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  80217a:	55                   	push   %ebp
  80217b:	89 e5                	mov    %esp,%ebp
  80217d:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  802180:	e8 63 fb ff ff       	call   801ce8 <InitializeUHeap>
	//==============================================================
	// [USER HEAP - USER SIDE] realloc
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  802185:	83 ec 04             	sub    $0x4,%esp
  802188:	68 04 42 80 00       	push   $0x804204
  80218d:	68 0e 01 00 00       	push   $0x10e
  802192:	68 d3 41 80 00       	push   $0x8041d3
  802197:	e8 0e eb ff ff       	call   800caa <_panic>

0080219c <sfree>:
//	use sys_freeSharedObject(...); which switches to the kernel mode,
//	calls freeSharedObject(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the freeSharedObject() function is empty, make sure to implement it.

void sfree(void* virtual_address)
{
  80219c:	55                   	push   %ebp
  80219d:	89 e5                	mov    %esp,%ebp
  80219f:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS3 - BONUS] [SHARING - USER SIDE] sfree()

	// Write your code here, remove the panic and write your code
	panic("sfree() is not implemented yet...!!");
  8021a2:	83 ec 04             	sub    $0x4,%esp
  8021a5:	68 2c 42 80 00       	push   $0x80422c
  8021aa:	68 22 01 00 00       	push   $0x122
  8021af:	68 d3 41 80 00       	push   $0x8041d3
  8021b4:	e8 f1 ea ff ff       	call   800caa <_panic>

008021b9 <expand>:

//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//
void expand(uint32 newSize)
{
  8021b9:	55                   	push   %ebp
  8021ba:	89 e5                	mov    %esp,%ebp
  8021bc:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  8021bf:	83 ec 04             	sub    $0x4,%esp
  8021c2:	68 50 42 80 00       	push   $0x804250
  8021c7:	68 2d 01 00 00       	push   $0x12d
  8021cc:	68 d3 41 80 00       	push   $0x8041d3
  8021d1:	e8 d4 ea ff ff       	call   800caa <_panic>

008021d6 <shrink>:

}
void shrink(uint32 newSize)
{
  8021d6:	55                   	push   %ebp
  8021d7:	89 e5                	mov    %esp,%ebp
  8021d9:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  8021dc:	83 ec 04             	sub    $0x4,%esp
  8021df:	68 50 42 80 00       	push   $0x804250
  8021e4:	68 32 01 00 00       	push   $0x132
  8021e9:	68 d3 41 80 00       	push   $0x8041d3
  8021ee:	e8 b7 ea ff ff       	call   800caa <_panic>

008021f3 <freeHeap>:

}
void freeHeap(void* virtual_address)
{
  8021f3:	55                   	push   %ebp
  8021f4:	89 e5                	mov    %esp,%ebp
  8021f6:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  8021f9:	83 ec 04             	sub    $0x4,%esp
  8021fc:	68 50 42 80 00       	push   $0x804250
  802201:	68 37 01 00 00       	push   $0x137
  802206:	68 d3 41 80 00       	push   $0x8041d3
  80220b:	e8 9a ea ff ff       	call   800caa <_panic>

00802210 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  802210:	55                   	push   %ebp
  802211:	89 e5                	mov    %esp,%ebp
  802213:	57                   	push   %edi
  802214:	56                   	push   %esi
  802215:	53                   	push   %ebx
  802216:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  802219:	8b 45 08             	mov    0x8(%ebp),%eax
  80221c:	8b 55 0c             	mov    0xc(%ebp),%edx
  80221f:	8b 4d 10             	mov    0x10(%ebp),%ecx
  802222:	8b 5d 14             	mov    0x14(%ebp),%ebx
  802225:	8b 7d 18             	mov    0x18(%ebp),%edi
  802228:	8b 75 1c             	mov    0x1c(%ebp),%esi
  80222b:	cd 30                	int    $0x30
  80222d:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  802230:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  802233:	83 c4 10             	add    $0x10,%esp
  802236:	5b                   	pop    %ebx
  802237:	5e                   	pop    %esi
  802238:	5f                   	pop    %edi
  802239:	5d                   	pop    %ebp
  80223a:	c3                   	ret    

0080223b <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  80223b:	55                   	push   %ebp
  80223c:	89 e5                	mov    %esp,%ebp
  80223e:	83 ec 04             	sub    $0x4,%esp
  802241:	8b 45 10             	mov    0x10(%ebp),%eax
  802244:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  802247:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  80224b:	8b 45 08             	mov    0x8(%ebp),%eax
  80224e:	6a 00                	push   $0x0
  802250:	6a 00                	push   $0x0
  802252:	52                   	push   %edx
  802253:	ff 75 0c             	pushl  0xc(%ebp)
  802256:	50                   	push   %eax
  802257:	6a 00                	push   $0x0
  802259:	e8 b2 ff ff ff       	call   802210 <syscall>
  80225e:	83 c4 18             	add    $0x18,%esp
}
  802261:	90                   	nop
  802262:	c9                   	leave  
  802263:	c3                   	ret    

00802264 <sys_cgetc>:

int
sys_cgetc(void)
{
  802264:	55                   	push   %ebp
  802265:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  802267:	6a 00                	push   $0x0
  802269:	6a 00                	push   $0x0
  80226b:	6a 00                	push   $0x0
  80226d:	6a 00                	push   $0x0
  80226f:	6a 00                	push   $0x0
  802271:	6a 01                	push   $0x1
  802273:	e8 98 ff ff ff       	call   802210 <syscall>
  802278:	83 c4 18             	add    $0x18,%esp
}
  80227b:	c9                   	leave  
  80227c:	c3                   	ret    

0080227d <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  80227d:	55                   	push   %ebp
  80227e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  802280:	8b 55 0c             	mov    0xc(%ebp),%edx
  802283:	8b 45 08             	mov    0x8(%ebp),%eax
  802286:	6a 00                	push   $0x0
  802288:	6a 00                	push   $0x0
  80228a:	6a 00                	push   $0x0
  80228c:	52                   	push   %edx
  80228d:	50                   	push   %eax
  80228e:	6a 05                	push   $0x5
  802290:	e8 7b ff ff ff       	call   802210 <syscall>
  802295:	83 c4 18             	add    $0x18,%esp
}
  802298:	c9                   	leave  
  802299:	c3                   	ret    

0080229a <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  80229a:	55                   	push   %ebp
  80229b:	89 e5                	mov    %esp,%ebp
  80229d:	56                   	push   %esi
  80229e:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  80229f:	8b 75 18             	mov    0x18(%ebp),%esi
  8022a2:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8022a5:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8022a8:	8b 55 0c             	mov    0xc(%ebp),%edx
  8022ab:	8b 45 08             	mov    0x8(%ebp),%eax
  8022ae:	56                   	push   %esi
  8022af:	53                   	push   %ebx
  8022b0:	51                   	push   %ecx
  8022b1:	52                   	push   %edx
  8022b2:	50                   	push   %eax
  8022b3:	6a 06                	push   $0x6
  8022b5:	e8 56 ff ff ff       	call   802210 <syscall>
  8022ba:	83 c4 18             	add    $0x18,%esp
}
  8022bd:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8022c0:	5b                   	pop    %ebx
  8022c1:	5e                   	pop    %esi
  8022c2:	5d                   	pop    %ebp
  8022c3:	c3                   	ret    

008022c4 <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  8022c4:	55                   	push   %ebp
  8022c5:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  8022c7:	8b 55 0c             	mov    0xc(%ebp),%edx
  8022ca:	8b 45 08             	mov    0x8(%ebp),%eax
  8022cd:	6a 00                	push   $0x0
  8022cf:	6a 00                	push   $0x0
  8022d1:	6a 00                	push   $0x0
  8022d3:	52                   	push   %edx
  8022d4:	50                   	push   %eax
  8022d5:	6a 07                	push   $0x7
  8022d7:	e8 34 ff ff ff       	call   802210 <syscall>
  8022dc:	83 c4 18             	add    $0x18,%esp
}
  8022df:	c9                   	leave  
  8022e0:	c3                   	ret    

008022e1 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  8022e1:	55                   	push   %ebp
  8022e2:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  8022e4:	6a 00                	push   $0x0
  8022e6:	6a 00                	push   $0x0
  8022e8:	6a 00                	push   $0x0
  8022ea:	ff 75 0c             	pushl  0xc(%ebp)
  8022ed:	ff 75 08             	pushl  0x8(%ebp)
  8022f0:	6a 08                	push   $0x8
  8022f2:	e8 19 ff ff ff       	call   802210 <syscall>
  8022f7:	83 c4 18             	add    $0x18,%esp
}
  8022fa:	c9                   	leave  
  8022fb:	c3                   	ret    

008022fc <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  8022fc:	55                   	push   %ebp
  8022fd:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  8022ff:	6a 00                	push   $0x0
  802301:	6a 00                	push   $0x0
  802303:	6a 00                	push   $0x0
  802305:	6a 00                	push   $0x0
  802307:	6a 00                	push   $0x0
  802309:	6a 09                	push   $0x9
  80230b:	e8 00 ff ff ff       	call   802210 <syscall>
  802310:	83 c4 18             	add    $0x18,%esp
}
  802313:	c9                   	leave  
  802314:	c3                   	ret    

00802315 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  802315:	55                   	push   %ebp
  802316:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  802318:	6a 00                	push   $0x0
  80231a:	6a 00                	push   $0x0
  80231c:	6a 00                	push   $0x0
  80231e:	6a 00                	push   $0x0
  802320:	6a 00                	push   $0x0
  802322:	6a 0a                	push   $0xa
  802324:	e8 e7 fe ff ff       	call   802210 <syscall>
  802329:	83 c4 18             	add    $0x18,%esp
}
  80232c:	c9                   	leave  
  80232d:	c3                   	ret    

0080232e <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  80232e:	55                   	push   %ebp
  80232f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  802331:	6a 00                	push   $0x0
  802333:	6a 00                	push   $0x0
  802335:	6a 00                	push   $0x0
  802337:	6a 00                	push   $0x0
  802339:	6a 00                	push   $0x0
  80233b:	6a 0b                	push   $0xb
  80233d:	e8 ce fe ff ff       	call   802210 <syscall>
  802342:	83 c4 18             	add    $0x18,%esp
}
  802345:	c9                   	leave  
  802346:	c3                   	ret    

00802347 <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  802347:	55                   	push   %ebp
  802348:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  80234a:	6a 00                	push   $0x0
  80234c:	6a 00                	push   $0x0
  80234e:	6a 00                	push   $0x0
  802350:	ff 75 0c             	pushl  0xc(%ebp)
  802353:	ff 75 08             	pushl  0x8(%ebp)
  802356:	6a 0f                	push   $0xf
  802358:	e8 b3 fe ff ff       	call   802210 <syscall>
  80235d:	83 c4 18             	add    $0x18,%esp
	return;
  802360:	90                   	nop
}
  802361:	c9                   	leave  
  802362:	c3                   	ret    

00802363 <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  802363:	55                   	push   %ebp
  802364:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  802366:	6a 00                	push   $0x0
  802368:	6a 00                	push   $0x0
  80236a:	6a 00                	push   $0x0
  80236c:	ff 75 0c             	pushl  0xc(%ebp)
  80236f:	ff 75 08             	pushl  0x8(%ebp)
  802372:	6a 10                	push   $0x10
  802374:	e8 97 fe ff ff       	call   802210 <syscall>
  802379:	83 c4 18             	add    $0x18,%esp
	return ;
  80237c:	90                   	nop
}
  80237d:	c9                   	leave  
  80237e:	c3                   	ret    

0080237f <sys_allocate_chunk>:

void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  80237f:	55                   	push   %ebp
  802380:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  802382:	6a 00                	push   $0x0
  802384:	6a 00                	push   $0x0
  802386:	ff 75 10             	pushl  0x10(%ebp)
  802389:	ff 75 0c             	pushl  0xc(%ebp)
  80238c:	ff 75 08             	pushl  0x8(%ebp)
  80238f:	6a 11                	push   $0x11
  802391:	e8 7a fe ff ff       	call   802210 <syscall>
  802396:	83 c4 18             	add    $0x18,%esp
	return ;
  802399:	90                   	nop
}
  80239a:	c9                   	leave  
  80239b:	c3                   	ret    

0080239c <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  80239c:	55                   	push   %ebp
  80239d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  80239f:	6a 00                	push   $0x0
  8023a1:	6a 00                	push   $0x0
  8023a3:	6a 00                	push   $0x0
  8023a5:	6a 00                	push   $0x0
  8023a7:	6a 00                	push   $0x0
  8023a9:	6a 0c                	push   $0xc
  8023ab:	e8 60 fe ff ff       	call   802210 <syscall>
  8023b0:	83 c4 18             	add    $0x18,%esp
}
  8023b3:	c9                   	leave  
  8023b4:	c3                   	ret    

008023b5 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  8023b5:	55                   	push   %ebp
  8023b6:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  8023b8:	6a 00                	push   $0x0
  8023ba:	6a 00                	push   $0x0
  8023bc:	6a 00                	push   $0x0
  8023be:	6a 00                	push   $0x0
  8023c0:	ff 75 08             	pushl  0x8(%ebp)
  8023c3:	6a 0d                	push   $0xd
  8023c5:	e8 46 fe ff ff       	call   802210 <syscall>
  8023ca:	83 c4 18             	add    $0x18,%esp
}
  8023cd:	c9                   	leave  
  8023ce:	c3                   	ret    

008023cf <sys_scarce_memory>:

void sys_scarce_memory()
{
  8023cf:	55                   	push   %ebp
  8023d0:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  8023d2:	6a 00                	push   $0x0
  8023d4:	6a 00                	push   $0x0
  8023d6:	6a 00                	push   $0x0
  8023d8:	6a 00                	push   $0x0
  8023da:	6a 00                	push   $0x0
  8023dc:	6a 0e                	push   $0xe
  8023de:	e8 2d fe ff ff       	call   802210 <syscall>
  8023e3:	83 c4 18             	add    $0x18,%esp
}
  8023e6:	90                   	nop
  8023e7:	c9                   	leave  
  8023e8:	c3                   	ret    

008023e9 <sys_disable_interrupt>:

//NEW !! 2012...
void
sys_disable_interrupt()
{
  8023e9:	55                   	push   %ebp
  8023ea:	89 e5                	mov    %esp,%ebp
	syscall(SYS_disableINTR,0, 0, 0, 0, 0);
  8023ec:	6a 00                	push   $0x0
  8023ee:	6a 00                	push   $0x0
  8023f0:	6a 00                	push   $0x0
  8023f2:	6a 00                	push   $0x0
  8023f4:	6a 00                	push   $0x0
  8023f6:	6a 13                	push   $0x13
  8023f8:	e8 13 fe ff ff       	call   802210 <syscall>
  8023fd:	83 c4 18             	add    $0x18,%esp
}
  802400:	90                   	nop
  802401:	c9                   	leave  
  802402:	c3                   	ret    

00802403 <sys_enable_interrupt>:


void
sys_enable_interrupt()
{
  802403:	55                   	push   %ebp
  802404:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enableINTR,0, 0, 0, 0, 0);
  802406:	6a 00                	push   $0x0
  802408:	6a 00                	push   $0x0
  80240a:	6a 00                	push   $0x0
  80240c:	6a 00                	push   $0x0
  80240e:	6a 00                	push   $0x0
  802410:	6a 14                	push   $0x14
  802412:	e8 f9 fd ff ff       	call   802210 <syscall>
  802417:	83 c4 18             	add    $0x18,%esp
}
  80241a:	90                   	nop
  80241b:	c9                   	leave  
  80241c:	c3                   	ret    

0080241d <sys_cputc>:


void
sys_cputc(const char c)
{
  80241d:	55                   	push   %ebp
  80241e:	89 e5                	mov    %esp,%ebp
  802420:	83 ec 04             	sub    $0x4,%esp
  802423:	8b 45 08             	mov    0x8(%ebp),%eax
  802426:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  802429:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  80242d:	6a 00                	push   $0x0
  80242f:	6a 00                	push   $0x0
  802431:	6a 00                	push   $0x0
  802433:	6a 00                	push   $0x0
  802435:	50                   	push   %eax
  802436:	6a 15                	push   $0x15
  802438:	e8 d3 fd ff ff       	call   802210 <syscall>
  80243d:	83 c4 18             	add    $0x18,%esp
}
  802440:	90                   	nop
  802441:	c9                   	leave  
  802442:	c3                   	ret    

00802443 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  802443:	55                   	push   %ebp
  802444:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  802446:	6a 00                	push   $0x0
  802448:	6a 00                	push   $0x0
  80244a:	6a 00                	push   $0x0
  80244c:	6a 00                	push   $0x0
  80244e:	6a 00                	push   $0x0
  802450:	6a 16                	push   $0x16
  802452:	e8 b9 fd ff ff       	call   802210 <syscall>
  802457:	83 c4 18             	add    $0x18,%esp
}
  80245a:	90                   	nop
  80245b:	c9                   	leave  
  80245c:	c3                   	ret    

0080245d <sys_createSemaphore>:

int
sys_createSemaphore(char* semaphoreName, uint32 initialValue)
{
  80245d:	55                   	push   %ebp
  80245e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_semaphore,(uint32)semaphoreName, (uint32)initialValue, 0, 0, 0);
  802460:	8b 45 08             	mov    0x8(%ebp),%eax
  802463:	6a 00                	push   $0x0
  802465:	6a 00                	push   $0x0
  802467:	6a 00                	push   $0x0
  802469:	ff 75 0c             	pushl  0xc(%ebp)
  80246c:	50                   	push   %eax
  80246d:	6a 17                	push   $0x17
  80246f:	e8 9c fd ff ff       	call   802210 <syscall>
  802474:	83 c4 18             	add    $0x18,%esp
}
  802477:	c9                   	leave  
  802478:	c3                   	ret    

00802479 <sys_getSemaphoreValue>:

int
sys_getSemaphoreValue(int32 ownerEnvID, char* semaphoreName)
{
  802479:	55                   	push   %ebp
  80247a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_semaphore_value,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  80247c:	8b 55 0c             	mov    0xc(%ebp),%edx
  80247f:	8b 45 08             	mov    0x8(%ebp),%eax
  802482:	6a 00                	push   $0x0
  802484:	6a 00                	push   $0x0
  802486:	6a 00                	push   $0x0
  802488:	52                   	push   %edx
  802489:	50                   	push   %eax
  80248a:	6a 1a                	push   $0x1a
  80248c:	e8 7f fd ff ff       	call   802210 <syscall>
  802491:	83 c4 18             	add    $0x18,%esp
}
  802494:	c9                   	leave  
  802495:	c3                   	ret    

00802496 <sys_waitSemaphore>:

void
sys_waitSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  802496:	55                   	push   %ebp
  802497:	89 e5                	mov    %esp,%ebp
	syscall(SYS_wait_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  802499:	8b 55 0c             	mov    0xc(%ebp),%edx
  80249c:	8b 45 08             	mov    0x8(%ebp),%eax
  80249f:	6a 00                	push   $0x0
  8024a1:	6a 00                	push   $0x0
  8024a3:	6a 00                	push   $0x0
  8024a5:	52                   	push   %edx
  8024a6:	50                   	push   %eax
  8024a7:	6a 18                	push   $0x18
  8024a9:	e8 62 fd ff ff       	call   802210 <syscall>
  8024ae:	83 c4 18             	add    $0x18,%esp
}
  8024b1:	90                   	nop
  8024b2:	c9                   	leave  
  8024b3:	c3                   	ret    

008024b4 <sys_signalSemaphore>:

void
sys_signalSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  8024b4:	55                   	push   %ebp
  8024b5:	89 e5                	mov    %esp,%ebp
	syscall(SYS_signal_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  8024b7:	8b 55 0c             	mov    0xc(%ebp),%edx
  8024ba:	8b 45 08             	mov    0x8(%ebp),%eax
  8024bd:	6a 00                	push   $0x0
  8024bf:	6a 00                	push   $0x0
  8024c1:	6a 00                	push   $0x0
  8024c3:	52                   	push   %edx
  8024c4:	50                   	push   %eax
  8024c5:	6a 19                	push   $0x19
  8024c7:	e8 44 fd ff ff       	call   802210 <syscall>
  8024cc:	83 c4 18             	add    $0x18,%esp
}
  8024cf:	90                   	nop
  8024d0:	c9                   	leave  
  8024d1:	c3                   	ret    

008024d2 <sys_createSharedObject>:

int
sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  8024d2:	55                   	push   %ebp
  8024d3:	89 e5                	mov    %esp,%ebp
  8024d5:	83 ec 04             	sub    $0x4,%esp
  8024d8:	8b 45 10             	mov    0x10(%ebp),%eax
  8024db:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  8024de:	8b 4d 14             	mov    0x14(%ebp),%ecx
  8024e1:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  8024e5:	8b 45 08             	mov    0x8(%ebp),%eax
  8024e8:	6a 00                	push   $0x0
  8024ea:	51                   	push   %ecx
  8024eb:	52                   	push   %edx
  8024ec:	ff 75 0c             	pushl  0xc(%ebp)
  8024ef:	50                   	push   %eax
  8024f0:	6a 1b                	push   $0x1b
  8024f2:	e8 19 fd ff ff       	call   802210 <syscall>
  8024f7:	83 c4 18             	add    $0x18,%esp
}
  8024fa:	c9                   	leave  
  8024fb:	c3                   	ret    

008024fc <sys_getSizeOfSharedObject>:

//2017:
int
sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  8024fc:	55                   	push   %ebp
  8024fd:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  8024ff:	8b 55 0c             	mov    0xc(%ebp),%edx
  802502:	8b 45 08             	mov    0x8(%ebp),%eax
  802505:	6a 00                	push   $0x0
  802507:	6a 00                	push   $0x0
  802509:	6a 00                	push   $0x0
  80250b:	52                   	push   %edx
  80250c:	50                   	push   %eax
  80250d:	6a 1c                	push   $0x1c
  80250f:	e8 fc fc ff ff       	call   802210 <syscall>
  802514:	83 c4 18             	add    $0x18,%esp
}
  802517:	c9                   	leave  
  802518:	c3                   	ret    

00802519 <sys_getSharedObject>:
//==========

int
sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  802519:	55                   	push   %ebp
  80251a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  80251c:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80251f:	8b 55 0c             	mov    0xc(%ebp),%edx
  802522:	8b 45 08             	mov    0x8(%ebp),%eax
  802525:	6a 00                	push   $0x0
  802527:	6a 00                	push   $0x0
  802529:	51                   	push   %ecx
  80252a:	52                   	push   %edx
  80252b:	50                   	push   %eax
  80252c:	6a 1d                	push   $0x1d
  80252e:	e8 dd fc ff ff       	call   802210 <syscall>
  802533:	83 c4 18             	add    $0x18,%esp
}
  802536:	c9                   	leave  
  802537:	c3                   	ret    

00802538 <sys_freeSharedObject>:

int
sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  802538:	55                   	push   %ebp
  802539:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  80253b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80253e:	8b 45 08             	mov    0x8(%ebp),%eax
  802541:	6a 00                	push   $0x0
  802543:	6a 00                	push   $0x0
  802545:	6a 00                	push   $0x0
  802547:	52                   	push   %edx
  802548:	50                   	push   %eax
  802549:	6a 1e                	push   $0x1e
  80254b:	e8 c0 fc ff ff       	call   802210 <syscall>
  802550:	83 c4 18             	add    $0x18,%esp
}
  802553:	c9                   	leave  
  802554:	c3                   	ret    

00802555 <sys_getMaxShares>:

uint32 	sys_getMaxShares()
{
  802555:	55                   	push   %ebp
  802556:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_max_shares,0, 0, 0, 0, 0);
  802558:	6a 00                	push   $0x0
  80255a:	6a 00                	push   $0x0
  80255c:	6a 00                	push   $0x0
  80255e:	6a 00                	push   $0x0
  802560:	6a 00                	push   $0x0
  802562:	6a 1f                	push   $0x1f
  802564:	e8 a7 fc ff ff       	call   802210 <syscall>
  802569:	83 c4 18             	add    $0x18,%esp
}
  80256c:	c9                   	leave  
  80256d:	c3                   	ret    

0080256e <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  80256e:	55                   	push   %ebp
  80256f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  802571:	8b 45 08             	mov    0x8(%ebp),%eax
  802574:	6a 00                	push   $0x0
  802576:	ff 75 14             	pushl  0x14(%ebp)
  802579:	ff 75 10             	pushl  0x10(%ebp)
  80257c:	ff 75 0c             	pushl  0xc(%ebp)
  80257f:	50                   	push   %eax
  802580:	6a 20                	push   $0x20
  802582:	e8 89 fc ff ff       	call   802210 <syscall>
  802587:	83 c4 18             	add    $0x18,%esp
}
  80258a:	c9                   	leave  
  80258b:	c3                   	ret    

0080258c <sys_run_env>:

void
sys_run_env(int32 envId)
{
  80258c:	55                   	push   %ebp
  80258d:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  80258f:	8b 45 08             	mov    0x8(%ebp),%eax
  802592:	6a 00                	push   $0x0
  802594:	6a 00                	push   $0x0
  802596:	6a 00                	push   $0x0
  802598:	6a 00                	push   $0x0
  80259a:	50                   	push   %eax
  80259b:	6a 21                	push   $0x21
  80259d:	e8 6e fc ff ff       	call   802210 <syscall>
  8025a2:	83 c4 18             	add    $0x18,%esp
}
  8025a5:	90                   	nop
  8025a6:	c9                   	leave  
  8025a7:	c3                   	ret    

008025a8 <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  8025a8:	55                   	push   %ebp
  8025a9:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  8025ab:	8b 45 08             	mov    0x8(%ebp),%eax
  8025ae:	6a 00                	push   $0x0
  8025b0:	6a 00                	push   $0x0
  8025b2:	6a 00                	push   $0x0
  8025b4:	6a 00                	push   $0x0
  8025b6:	50                   	push   %eax
  8025b7:	6a 22                	push   $0x22
  8025b9:	e8 52 fc ff ff       	call   802210 <syscall>
  8025be:	83 c4 18             	add    $0x18,%esp
}
  8025c1:	c9                   	leave  
  8025c2:	c3                   	ret    

008025c3 <sys_getenvid>:

int32 sys_getenvid(void)
{
  8025c3:	55                   	push   %ebp
  8025c4:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  8025c6:	6a 00                	push   $0x0
  8025c8:	6a 00                	push   $0x0
  8025ca:	6a 00                	push   $0x0
  8025cc:	6a 00                	push   $0x0
  8025ce:	6a 00                	push   $0x0
  8025d0:	6a 02                	push   $0x2
  8025d2:	e8 39 fc ff ff       	call   802210 <syscall>
  8025d7:	83 c4 18             	add    $0x18,%esp
}
  8025da:	c9                   	leave  
  8025db:	c3                   	ret    

008025dc <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  8025dc:	55                   	push   %ebp
  8025dd:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  8025df:	6a 00                	push   $0x0
  8025e1:	6a 00                	push   $0x0
  8025e3:	6a 00                	push   $0x0
  8025e5:	6a 00                	push   $0x0
  8025e7:	6a 00                	push   $0x0
  8025e9:	6a 03                	push   $0x3
  8025eb:	e8 20 fc ff ff       	call   802210 <syscall>
  8025f0:	83 c4 18             	add    $0x18,%esp
}
  8025f3:	c9                   	leave  
  8025f4:	c3                   	ret    

008025f5 <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  8025f5:	55                   	push   %ebp
  8025f6:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  8025f8:	6a 00                	push   $0x0
  8025fa:	6a 00                	push   $0x0
  8025fc:	6a 00                	push   $0x0
  8025fe:	6a 00                	push   $0x0
  802600:	6a 00                	push   $0x0
  802602:	6a 04                	push   $0x4
  802604:	e8 07 fc ff ff       	call   802210 <syscall>
  802609:	83 c4 18             	add    $0x18,%esp
}
  80260c:	c9                   	leave  
  80260d:	c3                   	ret    

0080260e <sys_exit_env>:


void sys_exit_env(void)
{
  80260e:	55                   	push   %ebp
  80260f:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  802611:	6a 00                	push   $0x0
  802613:	6a 00                	push   $0x0
  802615:	6a 00                	push   $0x0
  802617:	6a 00                	push   $0x0
  802619:	6a 00                	push   $0x0
  80261b:	6a 23                	push   $0x23
  80261d:	e8 ee fb ff ff       	call   802210 <syscall>
  802622:	83 c4 18             	add    $0x18,%esp
}
  802625:	90                   	nop
  802626:	c9                   	leave  
  802627:	c3                   	ret    

00802628 <sys_get_virtual_time>:


struct uint64
sys_get_virtual_time()
{
  802628:	55                   	push   %ebp
  802629:	89 e5                	mov    %esp,%ebp
  80262b:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  80262e:	8d 45 f8             	lea    -0x8(%ebp),%eax
  802631:	8d 50 04             	lea    0x4(%eax),%edx
  802634:	8d 45 f8             	lea    -0x8(%ebp),%eax
  802637:	6a 00                	push   $0x0
  802639:	6a 00                	push   $0x0
  80263b:	6a 00                	push   $0x0
  80263d:	52                   	push   %edx
  80263e:	50                   	push   %eax
  80263f:	6a 24                	push   $0x24
  802641:	e8 ca fb ff ff       	call   802210 <syscall>
  802646:	83 c4 18             	add    $0x18,%esp
	return result;
  802649:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80264c:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80264f:	8b 55 fc             	mov    -0x4(%ebp),%edx
  802652:	89 01                	mov    %eax,(%ecx)
  802654:	89 51 04             	mov    %edx,0x4(%ecx)
}
  802657:	8b 45 08             	mov    0x8(%ebp),%eax
  80265a:	c9                   	leave  
  80265b:	c2 04 00             	ret    $0x4

0080265e <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  80265e:	55                   	push   %ebp
  80265f:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  802661:	6a 00                	push   $0x0
  802663:	6a 00                	push   $0x0
  802665:	ff 75 10             	pushl  0x10(%ebp)
  802668:	ff 75 0c             	pushl  0xc(%ebp)
  80266b:	ff 75 08             	pushl  0x8(%ebp)
  80266e:	6a 12                	push   $0x12
  802670:	e8 9b fb ff ff       	call   802210 <syscall>
  802675:	83 c4 18             	add    $0x18,%esp
	return ;
  802678:	90                   	nop
}
  802679:	c9                   	leave  
  80267a:	c3                   	ret    

0080267b <sys_rcr2>:
uint32 sys_rcr2()
{
  80267b:	55                   	push   %ebp
  80267c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  80267e:	6a 00                	push   $0x0
  802680:	6a 00                	push   $0x0
  802682:	6a 00                	push   $0x0
  802684:	6a 00                	push   $0x0
  802686:	6a 00                	push   $0x0
  802688:	6a 25                	push   $0x25
  80268a:	e8 81 fb ff ff       	call   802210 <syscall>
  80268f:	83 c4 18             	add    $0x18,%esp
}
  802692:	c9                   	leave  
  802693:	c3                   	ret    

00802694 <sys_bypassPageFault>:
void sys_bypassPageFault(uint8 instrLength)
{
  802694:	55                   	push   %ebp
  802695:	89 e5                	mov    %esp,%ebp
  802697:	83 ec 04             	sub    $0x4,%esp
  80269a:	8b 45 08             	mov    0x8(%ebp),%eax
  80269d:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  8026a0:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  8026a4:	6a 00                	push   $0x0
  8026a6:	6a 00                	push   $0x0
  8026a8:	6a 00                	push   $0x0
  8026aa:	6a 00                	push   $0x0
  8026ac:	50                   	push   %eax
  8026ad:	6a 26                	push   $0x26
  8026af:	e8 5c fb ff ff       	call   802210 <syscall>
  8026b4:	83 c4 18             	add    $0x18,%esp
	return ;
  8026b7:	90                   	nop
}
  8026b8:	c9                   	leave  
  8026b9:	c3                   	ret    

008026ba <rsttst>:
void rsttst()
{
  8026ba:	55                   	push   %ebp
  8026bb:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  8026bd:	6a 00                	push   $0x0
  8026bf:	6a 00                	push   $0x0
  8026c1:	6a 00                	push   $0x0
  8026c3:	6a 00                	push   $0x0
  8026c5:	6a 00                	push   $0x0
  8026c7:	6a 28                	push   $0x28
  8026c9:	e8 42 fb ff ff       	call   802210 <syscall>
  8026ce:	83 c4 18             	add    $0x18,%esp
	return ;
  8026d1:	90                   	nop
}
  8026d2:	c9                   	leave  
  8026d3:	c3                   	ret    

008026d4 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  8026d4:	55                   	push   %ebp
  8026d5:	89 e5                	mov    %esp,%ebp
  8026d7:	83 ec 04             	sub    $0x4,%esp
  8026da:	8b 45 14             	mov    0x14(%ebp),%eax
  8026dd:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  8026e0:	8b 55 18             	mov    0x18(%ebp),%edx
  8026e3:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  8026e7:	52                   	push   %edx
  8026e8:	50                   	push   %eax
  8026e9:	ff 75 10             	pushl  0x10(%ebp)
  8026ec:	ff 75 0c             	pushl  0xc(%ebp)
  8026ef:	ff 75 08             	pushl  0x8(%ebp)
  8026f2:	6a 27                	push   $0x27
  8026f4:	e8 17 fb ff ff       	call   802210 <syscall>
  8026f9:	83 c4 18             	add    $0x18,%esp
	return ;
  8026fc:	90                   	nop
}
  8026fd:	c9                   	leave  
  8026fe:	c3                   	ret    

008026ff <chktst>:
void chktst(uint32 n)
{
  8026ff:	55                   	push   %ebp
  802700:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  802702:	6a 00                	push   $0x0
  802704:	6a 00                	push   $0x0
  802706:	6a 00                	push   $0x0
  802708:	6a 00                	push   $0x0
  80270a:	ff 75 08             	pushl  0x8(%ebp)
  80270d:	6a 29                	push   $0x29
  80270f:	e8 fc fa ff ff       	call   802210 <syscall>
  802714:	83 c4 18             	add    $0x18,%esp
	return ;
  802717:	90                   	nop
}
  802718:	c9                   	leave  
  802719:	c3                   	ret    

0080271a <inctst>:

void inctst()
{
  80271a:	55                   	push   %ebp
  80271b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  80271d:	6a 00                	push   $0x0
  80271f:	6a 00                	push   $0x0
  802721:	6a 00                	push   $0x0
  802723:	6a 00                	push   $0x0
  802725:	6a 00                	push   $0x0
  802727:	6a 2a                	push   $0x2a
  802729:	e8 e2 fa ff ff       	call   802210 <syscall>
  80272e:	83 c4 18             	add    $0x18,%esp
	return ;
  802731:	90                   	nop
}
  802732:	c9                   	leave  
  802733:	c3                   	ret    

00802734 <gettst>:
uint32 gettst()
{
  802734:	55                   	push   %ebp
  802735:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  802737:	6a 00                	push   $0x0
  802739:	6a 00                	push   $0x0
  80273b:	6a 00                	push   $0x0
  80273d:	6a 00                	push   $0x0
  80273f:	6a 00                	push   $0x0
  802741:	6a 2b                	push   $0x2b
  802743:	e8 c8 fa ff ff       	call   802210 <syscall>
  802748:	83 c4 18             	add    $0x18,%esp
}
  80274b:	c9                   	leave  
  80274c:	c3                   	ret    

0080274d <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  80274d:	55                   	push   %ebp
  80274e:	89 e5                	mov    %esp,%ebp
  802750:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  802753:	6a 00                	push   $0x0
  802755:	6a 00                	push   $0x0
  802757:	6a 00                	push   $0x0
  802759:	6a 00                	push   $0x0
  80275b:	6a 00                	push   $0x0
  80275d:	6a 2c                	push   $0x2c
  80275f:	e8 ac fa ff ff       	call   802210 <syscall>
  802764:	83 c4 18             	add    $0x18,%esp
  802767:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  80276a:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  80276e:	75 07                	jne    802777 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  802770:	b8 01 00 00 00       	mov    $0x1,%eax
  802775:	eb 05                	jmp    80277c <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  802777:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80277c:	c9                   	leave  
  80277d:	c3                   	ret    

0080277e <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  80277e:	55                   	push   %ebp
  80277f:	89 e5                	mov    %esp,%ebp
  802781:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  802784:	6a 00                	push   $0x0
  802786:	6a 00                	push   $0x0
  802788:	6a 00                	push   $0x0
  80278a:	6a 00                	push   $0x0
  80278c:	6a 00                	push   $0x0
  80278e:	6a 2c                	push   $0x2c
  802790:	e8 7b fa ff ff       	call   802210 <syscall>
  802795:	83 c4 18             	add    $0x18,%esp
  802798:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  80279b:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  80279f:	75 07                	jne    8027a8 <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  8027a1:	b8 01 00 00 00       	mov    $0x1,%eax
  8027a6:	eb 05                	jmp    8027ad <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  8027a8:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8027ad:	c9                   	leave  
  8027ae:	c3                   	ret    

008027af <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  8027af:	55                   	push   %ebp
  8027b0:	89 e5                	mov    %esp,%ebp
  8027b2:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8027b5:	6a 00                	push   $0x0
  8027b7:	6a 00                	push   $0x0
  8027b9:	6a 00                	push   $0x0
  8027bb:	6a 00                	push   $0x0
  8027bd:	6a 00                	push   $0x0
  8027bf:	6a 2c                	push   $0x2c
  8027c1:	e8 4a fa ff ff       	call   802210 <syscall>
  8027c6:	83 c4 18             	add    $0x18,%esp
  8027c9:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  8027cc:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  8027d0:	75 07                	jne    8027d9 <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  8027d2:	b8 01 00 00 00       	mov    $0x1,%eax
  8027d7:	eb 05                	jmp    8027de <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  8027d9:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8027de:	c9                   	leave  
  8027df:	c3                   	ret    

008027e0 <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  8027e0:	55                   	push   %ebp
  8027e1:	89 e5                	mov    %esp,%ebp
  8027e3:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8027e6:	6a 00                	push   $0x0
  8027e8:	6a 00                	push   $0x0
  8027ea:	6a 00                	push   $0x0
  8027ec:	6a 00                	push   $0x0
  8027ee:	6a 00                	push   $0x0
  8027f0:	6a 2c                	push   $0x2c
  8027f2:	e8 19 fa ff ff       	call   802210 <syscall>
  8027f7:	83 c4 18             	add    $0x18,%esp
  8027fa:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  8027fd:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  802801:	75 07                	jne    80280a <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  802803:	b8 01 00 00 00       	mov    $0x1,%eax
  802808:	eb 05                	jmp    80280f <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  80280a:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80280f:	c9                   	leave  
  802810:	c3                   	ret    

00802811 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  802811:	55                   	push   %ebp
  802812:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  802814:	6a 00                	push   $0x0
  802816:	6a 00                	push   $0x0
  802818:	6a 00                	push   $0x0
  80281a:	6a 00                	push   $0x0
  80281c:	ff 75 08             	pushl  0x8(%ebp)
  80281f:	6a 2d                	push   $0x2d
  802821:	e8 ea f9 ff ff       	call   802210 <syscall>
  802826:	83 c4 18             	add    $0x18,%esp
	return ;
  802829:	90                   	nop
}
  80282a:	c9                   	leave  
  80282b:	c3                   	ret    

0080282c <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  80282c:	55                   	push   %ebp
  80282d:	89 e5                	mov    %esp,%ebp
  80282f:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  802830:	8b 5d 14             	mov    0x14(%ebp),%ebx
  802833:	8b 4d 10             	mov    0x10(%ebp),%ecx
  802836:	8b 55 0c             	mov    0xc(%ebp),%edx
  802839:	8b 45 08             	mov    0x8(%ebp),%eax
  80283c:	6a 00                	push   $0x0
  80283e:	53                   	push   %ebx
  80283f:	51                   	push   %ecx
  802840:	52                   	push   %edx
  802841:	50                   	push   %eax
  802842:	6a 2e                	push   $0x2e
  802844:	e8 c7 f9 ff ff       	call   802210 <syscall>
  802849:	83 c4 18             	add    $0x18,%esp
}
  80284c:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80284f:	c9                   	leave  
  802850:	c3                   	ret    

00802851 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  802851:	55                   	push   %ebp
  802852:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  802854:	8b 55 0c             	mov    0xc(%ebp),%edx
  802857:	8b 45 08             	mov    0x8(%ebp),%eax
  80285a:	6a 00                	push   $0x0
  80285c:	6a 00                	push   $0x0
  80285e:	6a 00                	push   $0x0
  802860:	52                   	push   %edx
  802861:	50                   	push   %eax
  802862:	6a 2f                	push   $0x2f
  802864:	e8 a7 f9 ff ff       	call   802210 <syscall>
  802869:	83 c4 18             	add    $0x18,%esp
}
  80286c:	c9                   	leave  
  80286d:	c3                   	ret    

0080286e <print_mem_block_lists>:
//===========================
// PRINT MEM BLOCK LISTS:
//===========================

void print_mem_block_lists()
{
  80286e:	55                   	push   %ebp
  80286f:	89 e5                	mov    %esp,%ebp
  802871:	83 ec 18             	sub    $0x18,%esp
	cprintf("\n=========================================\n");
  802874:	83 ec 0c             	sub    $0xc,%esp
  802877:	68 60 42 80 00       	push   $0x804260
  80287c:	e8 dd e6 ff ff       	call   800f5e <cprintf>
  802881:	83 c4 10             	add    $0x10,%esp
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
  802884:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nFreeMemBlocksList:\n");
  80288b:	83 ec 0c             	sub    $0xc,%esp
  80288e:	68 8c 42 80 00       	push   $0x80428c
  802893:	e8 c6 e6 ff ff       	call   800f5e <cprintf>
  802898:	83 c4 10             	add    $0x10,%esp
	uint8 sorted = 1 ;
  80289b:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &FreeMemBlocksList)
  80289f:	a1 38 51 80 00       	mov    0x805138,%eax
  8028a4:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8028a7:	eb 56                	jmp    8028ff <print_mem_block_lists+0x91>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  8028a9:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8028ad:	74 1c                	je     8028cb <print_mem_block_lists+0x5d>
  8028af:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028b2:	8b 50 08             	mov    0x8(%eax),%edx
  8028b5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8028b8:	8b 48 08             	mov    0x8(%eax),%ecx
  8028bb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8028be:	8b 40 0c             	mov    0xc(%eax),%eax
  8028c1:	01 c8                	add    %ecx,%eax
  8028c3:	39 c2                	cmp    %eax,%edx
  8028c5:	73 04                	jae    8028cb <print_mem_block_lists+0x5d>
			sorted = 0 ;
  8028c7:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  8028cb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028ce:	8b 50 08             	mov    0x8(%eax),%edx
  8028d1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028d4:	8b 40 0c             	mov    0xc(%eax),%eax
  8028d7:	01 c2                	add    %eax,%edx
  8028d9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028dc:	8b 40 08             	mov    0x8(%eax),%eax
  8028df:	83 ec 04             	sub    $0x4,%esp
  8028e2:	52                   	push   %edx
  8028e3:	50                   	push   %eax
  8028e4:	68 a1 42 80 00       	push   $0x8042a1
  8028e9:	e8 70 e6 ff ff       	call   800f5e <cprintf>
  8028ee:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  8028f1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028f4:	89 45 f0             	mov    %eax,-0x10(%ebp)
	cprintf("\n=========================================\n");
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
	cprintf("\nFreeMemBlocksList:\n");
	uint8 sorted = 1 ;
	LIST_FOREACH(blk, &FreeMemBlocksList)
  8028f7:	a1 40 51 80 00       	mov    0x805140,%eax
  8028fc:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8028ff:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802903:	74 07                	je     80290c <print_mem_block_lists+0x9e>
  802905:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802908:	8b 00                	mov    (%eax),%eax
  80290a:	eb 05                	jmp    802911 <print_mem_block_lists+0xa3>
  80290c:	b8 00 00 00 00       	mov    $0x0,%eax
  802911:	a3 40 51 80 00       	mov    %eax,0x805140
  802916:	a1 40 51 80 00       	mov    0x805140,%eax
  80291b:	85 c0                	test   %eax,%eax
  80291d:	75 8a                	jne    8028a9 <print_mem_block_lists+0x3b>
  80291f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802923:	75 84                	jne    8028a9 <print_mem_block_lists+0x3b>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;
  802925:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  802929:	75 10                	jne    80293b <print_mem_block_lists+0xcd>
  80292b:	83 ec 0c             	sub    $0xc,%esp
  80292e:	68 b0 42 80 00       	push   $0x8042b0
  802933:	e8 26 e6 ff ff       	call   800f5e <cprintf>
  802938:	83 c4 10             	add    $0x10,%esp

	lastBlk = NULL ;
  80293b:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nAllocMemBlocksList:\n");
  802942:	83 ec 0c             	sub    $0xc,%esp
  802945:	68 d4 42 80 00       	push   $0x8042d4
  80294a:	e8 0f e6 ff ff       	call   800f5e <cprintf>
  80294f:	83 c4 10             	add    $0x10,%esp
	sorted = 1 ;
  802952:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &AllocMemBlocksList)
  802956:	a1 40 50 80 00       	mov    0x805040,%eax
  80295b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80295e:	eb 56                	jmp    8029b6 <print_mem_block_lists+0x148>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  802960:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802964:	74 1c                	je     802982 <print_mem_block_lists+0x114>
  802966:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802969:	8b 50 08             	mov    0x8(%eax),%edx
  80296c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80296f:	8b 48 08             	mov    0x8(%eax),%ecx
  802972:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802975:	8b 40 0c             	mov    0xc(%eax),%eax
  802978:	01 c8                	add    %ecx,%eax
  80297a:	39 c2                	cmp    %eax,%edx
  80297c:	73 04                	jae    802982 <print_mem_block_lists+0x114>
			sorted = 0 ;
  80297e:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  802982:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802985:	8b 50 08             	mov    0x8(%eax),%edx
  802988:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80298b:	8b 40 0c             	mov    0xc(%eax),%eax
  80298e:	01 c2                	add    %eax,%edx
  802990:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802993:	8b 40 08             	mov    0x8(%eax),%eax
  802996:	83 ec 04             	sub    $0x4,%esp
  802999:	52                   	push   %edx
  80299a:	50                   	push   %eax
  80299b:	68 a1 42 80 00       	push   $0x8042a1
  8029a0:	e8 b9 e5 ff ff       	call   800f5e <cprintf>
  8029a5:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  8029a8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029ab:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;

	lastBlk = NULL ;
	cprintf("\nAllocMemBlocksList:\n");
	sorted = 1 ;
	LIST_FOREACH(blk, &AllocMemBlocksList)
  8029ae:	a1 48 50 80 00       	mov    0x805048,%eax
  8029b3:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8029b6:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8029ba:	74 07                	je     8029c3 <print_mem_block_lists+0x155>
  8029bc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029bf:	8b 00                	mov    (%eax),%eax
  8029c1:	eb 05                	jmp    8029c8 <print_mem_block_lists+0x15a>
  8029c3:	b8 00 00 00 00       	mov    $0x0,%eax
  8029c8:	a3 48 50 80 00       	mov    %eax,0x805048
  8029cd:	a1 48 50 80 00       	mov    0x805048,%eax
  8029d2:	85 c0                	test   %eax,%eax
  8029d4:	75 8a                	jne    802960 <print_mem_block_lists+0xf2>
  8029d6:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8029da:	75 84                	jne    802960 <print_mem_block_lists+0xf2>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nAllocMemBlocksList is NOT SORTED!!\n") ;
  8029dc:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  8029e0:	75 10                	jne    8029f2 <print_mem_block_lists+0x184>
  8029e2:	83 ec 0c             	sub    $0xc,%esp
  8029e5:	68 ec 42 80 00       	push   $0x8042ec
  8029ea:	e8 6f e5 ff ff       	call   800f5e <cprintf>
  8029ef:	83 c4 10             	add    $0x10,%esp
	cprintf("\n=========================================\n");
  8029f2:	83 ec 0c             	sub    $0xc,%esp
  8029f5:	68 60 42 80 00       	push   $0x804260
  8029fa:	e8 5f e5 ff ff       	call   800f5e <cprintf>
  8029ff:	83 c4 10             	add    $0x10,%esp

}
  802a02:	90                   	nop
  802a03:	c9                   	leave  
  802a04:	c3                   	ret    

00802a05 <initialize_MemBlocksList>:

//===============================
// [1] INITIALIZE AVAILABLE LIST:
//===============================
void initialize_MemBlocksList(uint32 numOfBlocks)
{
  802a05:	55                   	push   %ebp
  802a06:	89 e5                	mov    %esp,%ebp
  802a08:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] initialize_MemBlocksList
	// Write your code here, remove the panic and write your code
	//panic("initialize_MemBlocksList() is not implemented yet...!!");
	uint32 n = numOfBlocks;
  802a0b:	8b 45 08             	mov    0x8(%ebp),%eax
  802a0e:	89 45 f0             	mov    %eax,-0x10(%ebp)

	LIST_INIT(&AvailableMemBlocksList);
  802a11:	c7 05 48 51 80 00 00 	movl   $0x0,0x805148
  802a18:	00 00 00 
  802a1b:	c7 05 4c 51 80 00 00 	movl   $0x0,0x80514c
  802a22:	00 00 00 
  802a25:	c7 05 54 51 80 00 00 	movl   $0x0,0x805154
  802a2c:	00 00 00 
	for(int i = 0; i<n;i++)
  802a2f:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  802a36:	e9 9e 00 00 00       	jmp    802ad9 <initialize_MemBlocksList+0xd4>
	{
		LIST_INSERT_HEAD(&AvailableMemBlocksList, &(MemBlockNodes[i]));
  802a3b:	a1 50 50 80 00       	mov    0x805050,%eax
  802a40:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802a43:	c1 e2 04             	shl    $0x4,%edx
  802a46:	01 d0                	add    %edx,%eax
  802a48:	85 c0                	test   %eax,%eax
  802a4a:	75 14                	jne    802a60 <initialize_MemBlocksList+0x5b>
  802a4c:	83 ec 04             	sub    $0x4,%esp
  802a4f:	68 14 43 80 00       	push   $0x804314
  802a54:	6a 47                	push   $0x47
  802a56:	68 37 43 80 00       	push   $0x804337
  802a5b:	e8 4a e2 ff ff       	call   800caa <_panic>
  802a60:	a1 50 50 80 00       	mov    0x805050,%eax
  802a65:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802a68:	c1 e2 04             	shl    $0x4,%edx
  802a6b:	01 d0                	add    %edx,%eax
  802a6d:	8b 15 48 51 80 00    	mov    0x805148,%edx
  802a73:	89 10                	mov    %edx,(%eax)
  802a75:	8b 00                	mov    (%eax),%eax
  802a77:	85 c0                	test   %eax,%eax
  802a79:	74 18                	je     802a93 <initialize_MemBlocksList+0x8e>
  802a7b:	a1 48 51 80 00       	mov    0x805148,%eax
  802a80:	8b 15 50 50 80 00    	mov    0x805050,%edx
  802a86:	8b 4d f4             	mov    -0xc(%ebp),%ecx
  802a89:	c1 e1 04             	shl    $0x4,%ecx
  802a8c:	01 ca                	add    %ecx,%edx
  802a8e:	89 50 04             	mov    %edx,0x4(%eax)
  802a91:	eb 12                	jmp    802aa5 <initialize_MemBlocksList+0xa0>
  802a93:	a1 50 50 80 00       	mov    0x805050,%eax
  802a98:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802a9b:	c1 e2 04             	shl    $0x4,%edx
  802a9e:	01 d0                	add    %edx,%eax
  802aa0:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802aa5:	a1 50 50 80 00       	mov    0x805050,%eax
  802aaa:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802aad:	c1 e2 04             	shl    $0x4,%edx
  802ab0:	01 d0                	add    %edx,%eax
  802ab2:	a3 48 51 80 00       	mov    %eax,0x805148
  802ab7:	a1 50 50 80 00       	mov    0x805050,%eax
  802abc:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802abf:	c1 e2 04             	shl    $0x4,%edx
  802ac2:	01 d0                	add    %edx,%eax
  802ac4:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802acb:	a1 54 51 80 00       	mov    0x805154,%eax
  802ad0:	40                   	inc    %eax
  802ad1:	a3 54 51 80 00       	mov    %eax,0x805154
	// Write your code here, remove the panic and write your code
	//panic("initialize_MemBlocksList() is not implemented yet...!!");
	uint32 n = numOfBlocks;

	LIST_INIT(&AvailableMemBlocksList);
	for(int i = 0; i<n;i++)
  802ad6:	ff 45 f4             	incl   -0xc(%ebp)
  802ad9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802adc:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  802adf:	0f 82 56 ff ff ff    	jb     802a3b <initialize_MemBlocksList+0x36>
	{
		LIST_INSERT_HEAD(&AvailableMemBlocksList, &(MemBlockNodes[i]));
	}
}
  802ae5:	90                   	nop
  802ae6:	c9                   	leave  
  802ae7:	c3                   	ret    

00802ae8 <find_block>:

//===============================
// [2] FIND BLOCK:
//===============================
struct MemBlock *find_block(struct MemBlock_List *blockList, uint32 va)
{
  802ae8:	55                   	push   %ebp
  802ae9:	89 e5                	mov    %esp,%ebp
  802aeb:	83 ec 10             	sub    $0x10,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] find_block
	// Write your code here, remove the panic and write your code
	//panic("find_block() is not implemented yet...!!");
	uint32 virAddress = va;
  802aee:	8b 45 0c             	mov    0xc(%ebp),%eax
  802af1:	89 45 f4             	mov    %eax,-0xc(%ebp)
	struct MemBlock* blk;
	int found = 0;
  802af4:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	LIST_FOREACH(blk, &(AllocMemBlocksList))
  802afb:	a1 40 50 80 00       	mov    0x805040,%eax
  802b00:	89 45 fc             	mov    %eax,-0x4(%ebp)
  802b03:	eb 23                	jmp    802b28 <find_block+0x40>
	{
		if(blk->sva == virAddress)
  802b05:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802b08:	8b 40 08             	mov    0x8(%eax),%eax
  802b0b:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  802b0e:	75 09                	jne    802b19 <find_block+0x31>
		{
			found = 1;
  802b10:	c7 45 f8 01 00 00 00 	movl   $0x1,-0x8(%ebp)
			break;
  802b17:	eb 35                	jmp    802b4e <find_block+0x66>
		}
		else
		{
			found = 0;
  802b19:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	//panic("find_block() is not implemented yet...!!");
	uint32 virAddress = va;
	struct MemBlock* blk;
	int found = 0;

	LIST_FOREACH(blk, &(AllocMemBlocksList))
  802b20:	a1 48 50 80 00       	mov    0x805048,%eax
  802b25:	89 45 fc             	mov    %eax,-0x4(%ebp)
  802b28:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  802b2c:	74 07                	je     802b35 <find_block+0x4d>
  802b2e:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802b31:	8b 00                	mov    (%eax),%eax
  802b33:	eb 05                	jmp    802b3a <find_block+0x52>
  802b35:	b8 00 00 00 00       	mov    $0x0,%eax
  802b3a:	a3 48 50 80 00       	mov    %eax,0x805048
  802b3f:	a1 48 50 80 00       	mov    0x805048,%eax
  802b44:	85 c0                	test   %eax,%eax
  802b46:	75 bd                	jne    802b05 <find_block+0x1d>
  802b48:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  802b4c:	75 b7                	jne    802b05 <find_block+0x1d>
		{
			found = 0;
			continue;
		}
	}
	if(found == 1)
  802b4e:	83 7d f8 01          	cmpl   $0x1,-0x8(%ebp)
  802b52:	75 05                	jne    802b59 <find_block+0x71>
	{
		return blk;
  802b54:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802b57:	eb 05                	jmp    802b5e <find_block+0x76>
	}
	else
	{
		return NULL;
  802b59:	b8 00 00 00 00       	mov    $0x0,%eax
	}
}
  802b5e:	c9                   	leave  
  802b5f:	c3                   	ret    

00802b60 <insert_sorted_allocList>:

//=========================================
// [3] INSERT BLOCK IN ALLOC LIST [SORTED]:
//=========================================
void insert_sorted_allocList(struct MemBlock *blockToInsert)
{
  802b60:	55                   	push   %ebp
  802b61:	89 e5                	mov    %esp,%ebp
  802b63:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] insert_sorted_allocList
	// Write your code here, remove the panic and write your code
	//panic("insert_sorted_allocList() is not implemented yet...!!");
	struct MemBlock* blk;
	struct MemBlock* newblk = blockToInsert;
  802b66:	8b 45 08             	mov    0x8(%ebp),%eax
  802b69:	89 45 f0             	mov    %eax,-0x10(%ebp)

	if((LIST_EMPTY(&AllocMemBlocksList)) || (newblk->sva < LIST_FIRST(&AllocMemBlocksList)->sva))
  802b6c:	a1 40 50 80 00       	mov    0x805040,%eax
  802b71:	85 c0                	test   %eax,%eax
  802b73:	74 12                	je     802b87 <insert_sorted_allocList+0x27>
  802b75:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b78:	8b 50 08             	mov    0x8(%eax),%edx
  802b7b:	a1 40 50 80 00       	mov    0x805040,%eax
  802b80:	8b 40 08             	mov    0x8(%eax),%eax
  802b83:	39 c2                	cmp    %eax,%edx
  802b85:	73 65                	jae    802bec <insert_sorted_allocList+0x8c>
	{
		LIST_INSERT_HEAD(&(AllocMemBlocksList), newblk);
  802b87:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802b8b:	75 14                	jne    802ba1 <insert_sorted_allocList+0x41>
  802b8d:	83 ec 04             	sub    $0x4,%esp
  802b90:	68 14 43 80 00       	push   $0x804314
  802b95:	6a 7b                	push   $0x7b
  802b97:	68 37 43 80 00       	push   $0x804337
  802b9c:	e8 09 e1 ff ff       	call   800caa <_panic>
  802ba1:	8b 15 40 50 80 00    	mov    0x805040,%edx
  802ba7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802baa:	89 10                	mov    %edx,(%eax)
  802bac:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802baf:	8b 00                	mov    (%eax),%eax
  802bb1:	85 c0                	test   %eax,%eax
  802bb3:	74 0d                	je     802bc2 <insert_sorted_allocList+0x62>
  802bb5:	a1 40 50 80 00       	mov    0x805040,%eax
  802bba:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802bbd:	89 50 04             	mov    %edx,0x4(%eax)
  802bc0:	eb 08                	jmp    802bca <insert_sorted_allocList+0x6a>
  802bc2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802bc5:	a3 44 50 80 00       	mov    %eax,0x805044
  802bca:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802bcd:	a3 40 50 80 00       	mov    %eax,0x805040
  802bd2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802bd5:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802bdc:	a1 4c 50 80 00       	mov    0x80504c,%eax
  802be1:	40                   	inc    %eax
  802be2:	a3 4c 50 80 00       	mov    %eax,0x80504c
  802be7:	e9 5f 01 00 00       	jmp    802d4b <insert_sorted_allocList+0x1eb>
	}
	else if(newblk->sva > LIST_LAST(&AllocMemBlocksList)->sva)
  802bec:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802bef:	8b 50 08             	mov    0x8(%eax),%edx
  802bf2:	a1 44 50 80 00       	mov    0x805044,%eax
  802bf7:	8b 40 08             	mov    0x8(%eax),%eax
  802bfa:	39 c2                	cmp    %eax,%edx
  802bfc:	76 65                	jbe    802c63 <insert_sorted_allocList+0x103>
	{
		LIST_INSERT_TAIL(&AllocMemBlocksList, newblk);
  802bfe:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802c02:	75 14                	jne    802c18 <insert_sorted_allocList+0xb8>
  802c04:	83 ec 04             	sub    $0x4,%esp
  802c07:	68 50 43 80 00       	push   $0x804350
  802c0c:	6a 7f                	push   $0x7f
  802c0e:	68 37 43 80 00       	push   $0x804337
  802c13:	e8 92 e0 ff ff       	call   800caa <_panic>
  802c18:	8b 15 44 50 80 00    	mov    0x805044,%edx
  802c1e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c21:	89 50 04             	mov    %edx,0x4(%eax)
  802c24:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c27:	8b 40 04             	mov    0x4(%eax),%eax
  802c2a:	85 c0                	test   %eax,%eax
  802c2c:	74 0c                	je     802c3a <insert_sorted_allocList+0xda>
  802c2e:	a1 44 50 80 00       	mov    0x805044,%eax
  802c33:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802c36:	89 10                	mov    %edx,(%eax)
  802c38:	eb 08                	jmp    802c42 <insert_sorted_allocList+0xe2>
  802c3a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c3d:	a3 40 50 80 00       	mov    %eax,0x805040
  802c42:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c45:	a3 44 50 80 00       	mov    %eax,0x805044
  802c4a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c4d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802c53:	a1 4c 50 80 00       	mov    0x80504c,%eax
  802c58:	40                   	inc    %eax
  802c59:	a3 4c 50 80 00       	mov    %eax,0x80504c
				LIST_INSERT_AFTER(&AllocMemBlocksList, blk, newblk);
				break;
			}
		}
	}
}
  802c5e:	e9 e8 00 00 00       	jmp    802d4b <insert_sorted_allocList+0x1eb>
	{
		LIST_INSERT_TAIL(&AllocMemBlocksList, newblk);
	}
	else
	{
		LIST_FOREACH(blk, &AllocMemBlocksList)
  802c63:	a1 40 50 80 00       	mov    0x805040,%eax
  802c68:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802c6b:	e9 ab 00 00 00       	jmp    802d1b <insert_sorted_allocList+0x1bb>
		{
			if(blk->prev_next_info.le_next != NULL && newblk->sva > blk->sva  && newblk->sva < blk->prev_next_info.le_next->sva)
  802c70:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c73:	8b 00                	mov    (%eax),%eax
  802c75:	85 c0                	test   %eax,%eax
  802c77:	0f 84 96 00 00 00    	je     802d13 <insert_sorted_allocList+0x1b3>
  802c7d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c80:	8b 50 08             	mov    0x8(%eax),%edx
  802c83:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c86:	8b 40 08             	mov    0x8(%eax),%eax
  802c89:	39 c2                	cmp    %eax,%edx
  802c8b:	0f 86 82 00 00 00    	jbe    802d13 <insert_sorted_allocList+0x1b3>
  802c91:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c94:	8b 50 08             	mov    0x8(%eax),%edx
  802c97:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c9a:	8b 00                	mov    (%eax),%eax
  802c9c:	8b 40 08             	mov    0x8(%eax),%eax
  802c9f:	39 c2                	cmp    %eax,%edx
  802ca1:	73 70                	jae    802d13 <insert_sorted_allocList+0x1b3>
			{
				LIST_INSERT_AFTER(&AllocMemBlocksList, blk, newblk);
  802ca3:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802ca7:	74 06                	je     802caf <insert_sorted_allocList+0x14f>
  802ca9:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802cad:	75 17                	jne    802cc6 <insert_sorted_allocList+0x166>
  802caf:	83 ec 04             	sub    $0x4,%esp
  802cb2:	68 74 43 80 00       	push   $0x804374
  802cb7:	68 87 00 00 00       	push   $0x87
  802cbc:	68 37 43 80 00       	push   $0x804337
  802cc1:	e8 e4 df ff ff       	call   800caa <_panic>
  802cc6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cc9:	8b 10                	mov    (%eax),%edx
  802ccb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802cce:	89 10                	mov    %edx,(%eax)
  802cd0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802cd3:	8b 00                	mov    (%eax),%eax
  802cd5:	85 c0                	test   %eax,%eax
  802cd7:	74 0b                	je     802ce4 <insert_sorted_allocList+0x184>
  802cd9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cdc:	8b 00                	mov    (%eax),%eax
  802cde:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802ce1:	89 50 04             	mov    %edx,0x4(%eax)
  802ce4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ce7:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802cea:	89 10                	mov    %edx,(%eax)
  802cec:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802cef:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802cf2:	89 50 04             	mov    %edx,0x4(%eax)
  802cf5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802cf8:	8b 00                	mov    (%eax),%eax
  802cfa:	85 c0                	test   %eax,%eax
  802cfc:	75 08                	jne    802d06 <insert_sorted_allocList+0x1a6>
  802cfe:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d01:	a3 44 50 80 00       	mov    %eax,0x805044
  802d06:	a1 4c 50 80 00       	mov    0x80504c,%eax
  802d0b:	40                   	inc    %eax
  802d0c:	a3 4c 50 80 00       	mov    %eax,0x80504c
				break;
  802d11:	eb 38                	jmp    802d4b <insert_sorted_allocList+0x1eb>
	{
		LIST_INSERT_TAIL(&AllocMemBlocksList, newblk);
	}
	else
	{
		LIST_FOREACH(blk, &AllocMemBlocksList)
  802d13:	a1 48 50 80 00       	mov    0x805048,%eax
  802d18:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802d1b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802d1f:	74 07                	je     802d28 <insert_sorted_allocList+0x1c8>
  802d21:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d24:	8b 00                	mov    (%eax),%eax
  802d26:	eb 05                	jmp    802d2d <insert_sorted_allocList+0x1cd>
  802d28:	b8 00 00 00 00       	mov    $0x0,%eax
  802d2d:	a3 48 50 80 00       	mov    %eax,0x805048
  802d32:	a1 48 50 80 00       	mov    0x805048,%eax
  802d37:	85 c0                	test   %eax,%eax
  802d39:	0f 85 31 ff ff ff    	jne    802c70 <insert_sorted_allocList+0x110>
  802d3f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802d43:	0f 85 27 ff ff ff    	jne    802c70 <insert_sorted_allocList+0x110>
				LIST_INSERT_AFTER(&AllocMemBlocksList, blk, newblk);
				break;
			}
		}
	}
}
  802d49:	eb 00                	jmp    802d4b <insert_sorted_allocList+0x1eb>
  802d4b:	90                   	nop
  802d4c:	c9                   	leave  
  802d4d:	c3                   	ret    

00802d4e <alloc_block_FF>:

//=========================================
// [4] ALLOCATE BLOCK BY FIRST FIT:
//=========================================
struct MemBlock *alloc_block_FF(uint32 size)
{
  802d4e:	55                   	push   %ebp
  802d4f:	89 e5                	mov    %esp,%ebp
  802d51:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_FF
	// Write your code here, remove the panic and write your code
	//panic("alloc_block_FF() is not implemented yet...!!");
	uint32 versize = size;
  802d54:	8b 45 08             	mov    0x8(%ebp),%eax
  802d57:	89 45 f0             	mov    %eax,-0x10(%ebp)
	struct MemBlock* blk;
	struct MemBlock* newblk = LIST_FIRST(&AvailableMemBlocksList);
  802d5a:	a1 48 51 80 00       	mov    0x805148,%eax
  802d5f:	89 45 ec             	mov    %eax,-0x14(%ebp)

	LIST_FOREACH(blk,&FreeMemBlocksList)
  802d62:	a1 38 51 80 00       	mov    0x805138,%eax
  802d67:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802d6a:	e9 77 01 00 00       	jmp    802ee6 <alloc_block_FF+0x198>
	{
		if(blk->size == versize)
  802d6f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d72:	8b 40 0c             	mov    0xc(%eax),%eax
  802d75:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  802d78:	0f 85 8a 00 00 00    	jne    802e08 <alloc_block_FF+0xba>
		{
			LIST_REMOVE(&FreeMemBlocksList,blk);
  802d7e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802d82:	75 17                	jne    802d9b <alloc_block_FF+0x4d>
  802d84:	83 ec 04             	sub    $0x4,%esp
  802d87:	68 a8 43 80 00       	push   $0x8043a8
  802d8c:	68 9e 00 00 00       	push   $0x9e
  802d91:	68 37 43 80 00       	push   $0x804337
  802d96:	e8 0f df ff ff       	call   800caa <_panic>
  802d9b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d9e:	8b 00                	mov    (%eax),%eax
  802da0:	85 c0                	test   %eax,%eax
  802da2:	74 10                	je     802db4 <alloc_block_FF+0x66>
  802da4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802da7:	8b 00                	mov    (%eax),%eax
  802da9:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802dac:	8b 52 04             	mov    0x4(%edx),%edx
  802daf:	89 50 04             	mov    %edx,0x4(%eax)
  802db2:	eb 0b                	jmp    802dbf <alloc_block_FF+0x71>
  802db4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802db7:	8b 40 04             	mov    0x4(%eax),%eax
  802dba:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802dbf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802dc2:	8b 40 04             	mov    0x4(%eax),%eax
  802dc5:	85 c0                	test   %eax,%eax
  802dc7:	74 0f                	je     802dd8 <alloc_block_FF+0x8a>
  802dc9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802dcc:	8b 40 04             	mov    0x4(%eax),%eax
  802dcf:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802dd2:	8b 12                	mov    (%edx),%edx
  802dd4:	89 10                	mov    %edx,(%eax)
  802dd6:	eb 0a                	jmp    802de2 <alloc_block_FF+0x94>
  802dd8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ddb:	8b 00                	mov    (%eax),%eax
  802ddd:	a3 38 51 80 00       	mov    %eax,0x805138
  802de2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802de5:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802deb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802dee:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802df5:	a1 44 51 80 00       	mov    0x805144,%eax
  802dfa:	48                   	dec    %eax
  802dfb:	a3 44 51 80 00       	mov    %eax,0x805144
			return blk;
  802e00:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e03:	e9 11 01 00 00       	jmp    802f19 <alloc_block_FF+0x1cb>
		}
		else if(blk->size > versize)
  802e08:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e0b:	8b 40 0c             	mov    0xc(%eax),%eax
  802e0e:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  802e11:	0f 86 c7 00 00 00    	jbe    802ede <alloc_block_FF+0x190>
		{
			LIST_REMOVE(&AvailableMemBlocksList,newblk);
  802e17:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802e1b:	75 17                	jne    802e34 <alloc_block_FF+0xe6>
  802e1d:	83 ec 04             	sub    $0x4,%esp
  802e20:	68 a8 43 80 00       	push   $0x8043a8
  802e25:	68 a3 00 00 00       	push   $0xa3
  802e2a:	68 37 43 80 00       	push   $0x804337
  802e2f:	e8 76 de ff ff       	call   800caa <_panic>
  802e34:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802e37:	8b 00                	mov    (%eax),%eax
  802e39:	85 c0                	test   %eax,%eax
  802e3b:	74 10                	je     802e4d <alloc_block_FF+0xff>
  802e3d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802e40:	8b 00                	mov    (%eax),%eax
  802e42:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802e45:	8b 52 04             	mov    0x4(%edx),%edx
  802e48:	89 50 04             	mov    %edx,0x4(%eax)
  802e4b:	eb 0b                	jmp    802e58 <alloc_block_FF+0x10a>
  802e4d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802e50:	8b 40 04             	mov    0x4(%eax),%eax
  802e53:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802e58:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802e5b:	8b 40 04             	mov    0x4(%eax),%eax
  802e5e:	85 c0                	test   %eax,%eax
  802e60:	74 0f                	je     802e71 <alloc_block_FF+0x123>
  802e62:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802e65:	8b 40 04             	mov    0x4(%eax),%eax
  802e68:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802e6b:	8b 12                	mov    (%edx),%edx
  802e6d:	89 10                	mov    %edx,(%eax)
  802e6f:	eb 0a                	jmp    802e7b <alloc_block_FF+0x12d>
  802e71:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802e74:	8b 00                	mov    (%eax),%eax
  802e76:	a3 48 51 80 00       	mov    %eax,0x805148
  802e7b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802e7e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802e84:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802e87:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802e8e:	a1 54 51 80 00       	mov    0x805154,%eax
  802e93:	48                   	dec    %eax
  802e94:	a3 54 51 80 00       	mov    %eax,0x805154
			newblk->size = versize;
  802e99:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802e9c:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802e9f:	89 50 0c             	mov    %edx,0xc(%eax)
			blk->size = blk->size-versize;
  802ea2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ea5:	8b 40 0c             	mov    0xc(%eax),%eax
  802ea8:	2b 45 f0             	sub    -0x10(%ebp),%eax
  802eab:	89 c2                	mov    %eax,%edx
  802ead:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802eb0:	89 50 0c             	mov    %edx,0xc(%eax)
			uint32 newveradd = blk->sva;
  802eb3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802eb6:	8b 40 08             	mov    0x8(%eax),%eax
  802eb9:	89 45 e8             	mov    %eax,-0x18(%ebp)
			blk->sva+=newblk->size;
  802ebc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ebf:	8b 50 08             	mov    0x8(%eax),%edx
  802ec2:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802ec5:	8b 40 0c             	mov    0xc(%eax),%eax
  802ec8:	01 c2                	add    %eax,%edx
  802eca:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ecd:	89 50 08             	mov    %edx,0x8(%eax)
			newblk->sva = newveradd;
  802ed0:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802ed3:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802ed6:	89 50 08             	mov    %edx,0x8(%eax)
			return newblk;
  802ed9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802edc:	eb 3b                	jmp    802f19 <alloc_block_FF+0x1cb>
	//panic("alloc_block_FF() is not implemented yet...!!");
	uint32 versize = size;
	struct MemBlock* blk;
	struct MemBlock* newblk = LIST_FIRST(&AvailableMemBlocksList);

	LIST_FOREACH(blk,&FreeMemBlocksList)
  802ede:	a1 40 51 80 00       	mov    0x805140,%eax
  802ee3:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802ee6:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802eea:	74 07                	je     802ef3 <alloc_block_FF+0x1a5>
  802eec:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802eef:	8b 00                	mov    (%eax),%eax
  802ef1:	eb 05                	jmp    802ef8 <alloc_block_FF+0x1aa>
  802ef3:	b8 00 00 00 00       	mov    $0x0,%eax
  802ef8:	a3 40 51 80 00       	mov    %eax,0x805140
  802efd:	a1 40 51 80 00       	mov    0x805140,%eax
  802f02:	85 c0                	test   %eax,%eax
  802f04:	0f 85 65 fe ff ff    	jne    802d6f <alloc_block_FF+0x21>
  802f0a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802f0e:	0f 85 5b fe ff ff    	jne    802d6f <alloc_block_FF+0x21>
			blk->sva+=newblk->size;
			newblk->sva = newveradd;
			return newblk;
		}
	}
	return NULL;
  802f14:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802f19:	c9                   	leave  
  802f1a:	c3                   	ret    

00802f1b <alloc_block_BF>:

//=========================================
// [5] ALLOCATE BLOCK BY BEST FIT:
//=========================================
struct MemBlock *alloc_block_BF(uint32 size)
{
  802f1b:	55                   	push   %ebp
  802f1c:	89 e5                	mov    %esp,%ebp
  802f1e:	83 ec 28             	sub    $0x28,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_BF
	// Write your code here, remove the panic and write your code
	//panic("alloc_block_BF() is not implemented yet...!!");
	uint32 versize=size;
  802f21:	8b 45 08             	mov    0x8(%ebp),%eax
  802f24:	89 45 e8             	mov    %eax,-0x18(%ebp)
	struct MemBlock* blk;
	struct MemBlock* newblk=LIST_FIRST(&AvailableMemBlocksList);
  802f27:	a1 48 51 80 00       	mov    0x805148,%eax
  802f2c:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	uint32 newveradd;
	uint32 newsize;
	int size_free = LIST_SIZE(&FreeMemBlocksList);
  802f2f:	a1 44 51 80 00       	mov    0x805144,%eax
  802f34:	89 45 e0             	mov    %eax,-0x20(%ebp)

	LIST_FOREACH(blk, &FreeMemBlocksList)
  802f37:	a1 38 51 80 00       	mov    0x805138,%eax
  802f3c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802f3f:	e9 a1 00 00 00       	jmp    802fe5 <alloc_block_BF+0xca>
	{
		if(blk->size == versize)
  802f44:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f47:	8b 40 0c             	mov    0xc(%eax),%eax
  802f4a:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  802f4d:	0f 85 8a 00 00 00    	jne    802fdd <alloc_block_BF+0xc2>
		{
			LIST_REMOVE(&FreeMemBlocksList, blk);
  802f53:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802f57:	75 17                	jne    802f70 <alloc_block_BF+0x55>
  802f59:	83 ec 04             	sub    $0x4,%esp
  802f5c:	68 a8 43 80 00       	push   $0x8043a8
  802f61:	68 c2 00 00 00       	push   $0xc2
  802f66:	68 37 43 80 00       	push   $0x804337
  802f6b:	e8 3a dd ff ff       	call   800caa <_panic>
  802f70:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f73:	8b 00                	mov    (%eax),%eax
  802f75:	85 c0                	test   %eax,%eax
  802f77:	74 10                	je     802f89 <alloc_block_BF+0x6e>
  802f79:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f7c:	8b 00                	mov    (%eax),%eax
  802f7e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802f81:	8b 52 04             	mov    0x4(%edx),%edx
  802f84:	89 50 04             	mov    %edx,0x4(%eax)
  802f87:	eb 0b                	jmp    802f94 <alloc_block_BF+0x79>
  802f89:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f8c:	8b 40 04             	mov    0x4(%eax),%eax
  802f8f:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802f94:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f97:	8b 40 04             	mov    0x4(%eax),%eax
  802f9a:	85 c0                	test   %eax,%eax
  802f9c:	74 0f                	je     802fad <alloc_block_BF+0x92>
  802f9e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802fa1:	8b 40 04             	mov    0x4(%eax),%eax
  802fa4:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802fa7:	8b 12                	mov    (%edx),%edx
  802fa9:	89 10                	mov    %edx,(%eax)
  802fab:	eb 0a                	jmp    802fb7 <alloc_block_BF+0x9c>
  802fad:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802fb0:	8b 00                	mov    (%eax),%eax
  802fb2:	a3 38 51 80 00       	mov    %eax,0x805138
  802fb7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802fba:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802fc0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802fc3:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802fca:	a1 44 51 80 00       	mov    0x805144,%eax
  802fcf:	48                   	dec    %eax
  802fd0:	a3 44 51 80 00       	mov    %eax,0x805144
			return blk;
  802fd5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802fd8:	e9 11 02 00 00       	jmp    8031ee <alloc_block_BF+0x2d3>
	struct MemBlock* newblk=LIST_FIRST(&AvailableMemBlocksList);
	uint32 newveradd;
	uint32 newsize;
	int size_free = LIST_SIZE(&FreeMemBlocksList);

	LIST_FOREACH(blk, &FreeMemBlocksList)
  802fdd:	a1 40 51 80 00       	mov    0x805140,%eax
  802fe2:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802fe5:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802fe9:	74 07                	je     802ff2 <alloc_block_BF+0xd7>
  802feb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802fee:	8b 00                	mov    (%eax),%eax
  802ff0:	eb 05                	jmp    802ff7 <alloc_block_BF+0xdc>
  802ff2:	b8 00 00 00 00       	mov    $0x0,%eax
  802ff7:	a3 40 51 80 00       	mov    %eax,0x805140
  802ffc:	a1 40 51 80 00       	mov    0x805140,%eax
  803001:	85 c0                	test   %eax,%eax
  803003:	0f 85 3b ff ff ff    	jne    802f44 <alloc_block_BF+0x29>
  803009:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80300d:	0f 85 31 ff ff ff    	jne    802f44 <alloc_block_BF+0x29>
		{
			LIST_REMOVE(&FreeMemBlocksList, blk);
			return blk;
		}
	}
	LIST_FOREACH(blk, &FreeMemBlocksList)
  803013:	a1 38 51 80 00       	mov    0x805138,%eax
  803018:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80301b:	eb 27                	jmp    803044 <alloc_block_BF+0x129>
	{
		if(blk->size > versize)
  80301d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803020:	8b 40 0c             	mov    0xc(%eax),%eax
  803023:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  803026:	76 14                	jbe    80303c <alloc_block_BF+0x121>
		{
			newsize = blk->size;
  803028:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80302b:	8b 40 0c             	mov    0xc(%eax),%eax
  80302e:	89 45 ec             	mov    %eax,-0x14(%ebp)
			newveradd = blk->sva;
  803031:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803034:	8b 40 08             	mov    0x8(%eax),%eax
  803037:	89 45 f0             	mov    %eax,-0x10(%ebp)
			break;
  80303a:	eb 2e                	jmp    80306a <alloc_block_BF+0x14f>
		{
			LIST_REMOVE(&FreeMemBlocksList, blk);
			return blk;
		}
	}
	LIST_FOREACH(blk, &FreeMemBlocksList)
  80303c:	a1 40 51 80 00       	mov    0x805140,%eax
  803041:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803044:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803048:	74 07                	je     803051 <alloc_block_BF+0x136>
  80304a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80304d:	8b 00                	mov    (%eax),%eax
  80304f:	eb 05                	jmp    803056 <alloc_block_BF+0x13b>
  803051:	b8 00 00 00 00       	mov    $0x0,%eax
  803056:	a3 40 51 80 00       	mov    %eax,0x805140
  80305b:	a1 40 51 80 00       	mov    0x805140,%eax
  803060:	85 c0                	test   %eax,%eax
  803062:	75 b9                	jne    80301d <alloc_block_BF+0x102>
  803064:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803068:	75 b3                	jne    80301d <alloc_block_BF+0x102>
			newsize = blk->size;
			newveradd = blk->sva;
			break;
		}
	}
	LIST_FOREACH(blk, &FreeMemBlocksList)
  80306a:	a1 38 51 80 00       	mov    0x805138,%eax
  80306f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803072:	eb 30                	jmp    8030a4 <alloc_block_BF+0x189>
	{
		if(newsize > blk->size && blk->size > versize)
  803074:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803077:	8b 40 0c             	mov    0xc(%eax),%eax
  80307a:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  80307d:	73 1d                	jae    80309c <alloc_block_BF+0x181>
  80307f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803082:	8b 40 0c             	mov    0xc(%eax),%eax
  803085:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  803088:	76 12                	jbe    80309c <alloc_block_BF+0x181>
		{
	       newsize = blk->size;
  80308a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80308d:	8b 40 0c             	mov    0xc(%eax),%eax
  803090:	89 45 ec             	mov    %eax,-0x14(%ebp)
		   newveradd = blk->sva;
  803093:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803096:	8b 40 08             	mov    0x8(%eax),%eax
  803099:	89 45 f0             	mov    %eax,-0x10(%ebp)
			newsize = blk->size;
			newveradd = blk->sva;
			break;
		}
	}
	LIST_FOREACH(blk, &FreeMemBlocksList)
  80309c:	a1 40 51 80 00       	mov    0x805140,%eax
  8030a1:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8030a4:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8030a8:	74 07                	je     8030b1 <alloc_block_BF+0x196>
  8030aa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030ad:	8b 00                	mov    (%eax),%eax
  8030af:	eb 05                	jmp    8030b6 <alloc_block_BF+0x19b>
  8030b1:	b8 00 00 00 00       	mov    $0x0,%eax
  8030b6:	a3 40 51 80 00       	mov    %eax,0x805140
  8030bb:	a1 40 51 80 00       	mov    0x805140,%eax
  8030c0:	85 c0                	test   %eax,%eax
  8030c2:	75 b0                	jne    803074 <alloc_block_BF+0x159>
  8030c4:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8030c8:	75 aa                	jne    803074 <alloc_block_BF+0x159>
		{
	       newsize = blk->size;
		   newveradd = blk->sva;
		}
	}
	LIST_FOREACH(blk, &FreeMemBlocksList)
  8030ca:	a1 38 51 80 00       	mov    0x805138,%eax
  8030cf:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8030d2:	e9 e4 00 00 00       	jmp    8031bb <alloc_block_BF+0x2a0>
	{
		if(blk->size == newsize && blk->sva == newveradd)
  8030d7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030da:	8b 40 0c             	mov    0xc(%eax),%eax
  8030dd:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  8030e0:	0f 85 cd 00 00 00    	jne    8031b3 <alloc_block_BF+0x298>
  8030e6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030e9:	8b 40 08             	mov    0x8(%eax),%eax
  8030ec:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8030ef:	0f 85 be 00 00 00    	jne    8031b3 <alloc_block_BF+0x298>
		{
			LIST_REMOVE(&AvailableMemBlocksList, newblk);
  8030f5:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8030f9:	75 17                	jne    803112 <alloc_block_BF+0x1f7>
  8030fb:	83 ec 04             	sub    $0x4,%esp
  8030fe:	68 a8 43 80 00       	push   $0x8043a8
  803103:	68 db 00 00 00       	push   $0xdb
  803108:	68 37 43 80 00       	push   $0x804337
  80310d:	e8 98 db ff ff       	call   800caa <_panic>
  803112:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803115:	8b 00                	mov    (%eax),%eax
  803117:	85 c0                	test   %eax,%eax
  803119:	74 10                	je     80312b <alloc_block_BF+0x210>
  80311b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80311e:	8b 00                	mov    (%eax),%eax
  803120:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803123:	8b 52 04             	mov    0x4(%edx),%edx
  803126:	89 50 04             	mov    %edx,0x4(%eax)
  803129:	eb 0b                	jmp    803136 <alloc_block_BF+0x21b>
  80312b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80312e:	8b 40 04             	mov    0x4(%eax),%eax
  803131:	a3 4c 51 80 00       	mov    %eax,0x80514c
  803136:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803139:	8b 40 04             	mov    0x4(%eax),%eax
  80313c:	85 c0                	test   %eax,%eax
  80313e:	74 0f                	je     80314f <alloc_block_BF+0x234>
  803140:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803143:	8b 40 04             	mov    0x4(%eax),%eax
  803146:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803149:	8b 12                	mov    (%edx),%edx
  80314b:	89 10                	mov    %edx,(%eax)
  80314d:	eb 0a                	jmp    803159 <alloc_block_BF+0x23e>
  80314f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803152:	8b 00                	mov    (%eax),%eax
  803154:	a3 48 51 80 00       	mov    %eax,0x805148
  803159:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80315c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803162:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803165:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80316c:	a1 54 51 80 00       	mov    0x805154,%eax
  803171:	48                   	dec    %eax
  803172:	a3 54 51 80 00       	mov    %eax,0x805154
			newblk->size = versize;
  803177:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80317a:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80317d:	89 50 0c             	mov    %edx,0xc(%eax)
			newblk->sva = newveradd;
  803180:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803183:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803186:	89 50 08             	mov    %edx,0x8(%eax)
			blk->size = blk->size - versize;
  803189:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80318c:	8b 40 0c             	mov    0xc(%eax),%eax
  80318f:	2b 45 e8             	sub    -0x18(%ebp),%eax
  803192:	89 c2                	mov    %eax,%edx
  803194:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803197:	89 50 0c             	mov    %edx,0xc(%eax)
			blk->sva+= newblk->size;
  80319a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80319d:	8b 50 08             	mov    0x8(%eax),%edx
  8031a0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8031a3:	8b 40 0c             	mov    0xc(%eax),%eax
  8031a6:	01 c2                	add    %eax,%edx
  8031a8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8031ab:	89 50 08             	mov    %edx,0x8(%eax)
			return newblk;
  8031ae:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8031b1:	eb 3b                	jmp    8031ee <alloc_block_BF+0x2d3>
		{
	       newsize = blk->size;
		   newveradd = blk->sva;
		}
	}
	LIST_FOREACH(blk, &FreeMemBlocksList)
  8031b3:	a1 40 51 80 00       	mov    0x805140,%eax
  8031b8:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8031bb:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8031bf:	74 07                	je     8031c8 <alloc_block_BF+0x2ad>
  8031c1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8031c4:	8b 00                	mov    (%eax),%eax
  8031c6:	eb 05                	jmp    8031cd <alloc_block_BF+0x2b2>
  8031c8:	b8 00 00 00 00       	mov    $0x0,%eax
  8031cd:	a3 40 51 80 00       	mov    %eax,0x805140
  8031d2:	a1 40 51 80 00       	mov    0x805140,%eax
  8031d7:	85 c0                	test   %eax,%eax
  8031d9:	0f 85 f8 fe ff ff    	jne    8030d7 <alloc_block_BF+0x1bc>
  8031df:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8031e3:	0f 85 ee fe ff ff    	jne    8030d7 <alloc_block_BF+0x1bc>
			blk->size = blk->size - versize;
			blk->sva+= newblk->size;
			return newblk;
		}
	}
	return NULL;
  8031e9:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8031ee:	c9                   	leave  
  8031ef:	c3                   	ret    

008031f0 <alloc_block_NF>:
//=========================================
// [7] ALLOCATE BLOCK BY NEXT FIT:
//=========================================
struct MemBlock *last_allocate;
struct MemBlock *alloc_block_NF(uint32 size)
{
  8031f0:	55                   	push   %ebp
  8031f1:	89 e5                	mov    %esp,%ebp
  8031f3:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1 - BONUS] [DYNAMIC ALLOCATOR] alloc_block_NF
	// Write your code here, remove the panic and write your code
	//panic("alloc_block_NF() is not implemented yet...!!");
	uint32 versize = size;
  8031f6:	8b 45 08             	mov    0x8(%ebp),%eax
  8031f9:	89 45 f0             	mov    %eax,-0x10(%ebp)
	struct MemBlock* blk;
	struct MemBlock* newblk = LIST_FIRST(&AvailableMemBlocksList);
  8031fc:	a1 48 51 80 00       	mov    0x805148,%eax
  803201:	89 45 ec             	mov    %eax,-0x14(%ebp)

	LIST_FOREACH(blk,&FreeMemBlocksList)
  803204:	a1 38 51 80 00       	mov    0x805138,%eax
  803209:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80320c:	e9 77 01 00 00       	jmp    803388 <alloc_block_NF+0x198>
	{
		if(blk->size == versize)
  803211:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803214:	8b 40 0c             	mov    0xc(%eax),%eax
  803217:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80321a:	0f 85 8a 00 00 00    	jne    8032aa <alloc_block_NF+0xba>
		{
			LIST_REMOVE(&FreeMemBlocksList,blk);
  803220:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803224:	75 17                	jne    80323d <alloc_block_NF+0x4d>
  803226:	83 ec 04             	sub    $0x4,%esp
  803229:	68 a8 43 80 00       	push   $0x8043a8
  80322e:	68 f7 00 00 00       	push   $0xf7
  803233:	68 37 43 80 00       	push   $0x804337
  803238:	e8 6d da ff ff       	call   800caa <_panic>
  80323d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803240:	8b 00                	mov    (%eax),%eax
  803242:	85 c0                	test   %eax,%eax
  803244:	74 10                	je     803256 <alloc_block_NF+0x66>
  803246:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803249:	8b 00                	mov    (%eax),%eax
  80324b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80324e:	8b 52 04             	mov    0x4(%edx),%edx
  803251:	89 50 04             	mov    %edx,0x4(%eax)
  803254:	eb 0b                	jmp    803261 <alloc_block_NF+0x71>
  803256:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803259:	8b 40 04             	mov    0x4(%eax),%eax
  80325c:	a3 3c 51 80 00       	mov    %eax,0x80513c
  803261:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803264:	8b 40 04             	mov    0x4(%eax),%eax
  803267:	85 c0                	test   %eax,%eax
  803269:	74 0f                	je     80327a <alloc_block_NF+0x8a>
  80326b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80326e:	8b 40 04             	mov    0x4(%eax),%eax
  803271:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803274:	8b 12                	mov    (%edx),%edx
  803276:	89 10                	mov    %edx,(%eax)
  803278:	eb 0a                	jmp    803284 <alloc_block_NF+0x94>
  80327a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80327d:	8b 00                	mov    (%eax),%eax
  80327f:	a3 38 51 80 00       	mov    %eax,0x805138
  803284:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803287:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80328d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803290:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803297:	a1 44 51 80 00       	mov    0x805144,%eax
  80329c:	48                   	dec    %eax
  80329d:	a3 44 51 80 00       	mov    %eax,0x805144
			return blk;
  8032a2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8032a5:	e9 11 01 00 00       	jmp    8033bb <alloc_block_NF+0x1cb>
		}
		else if(blk->size > versize)
  8032aa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8032ad:	8b 40 0c             	mov    0xc(%eax),%eax
  8032b0:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8032b3:	0f 86 c7 00 00 00    	jbe    803380 <alloc_block_NF+0x190>
		{
			LIST_REMOVE(&AvailableMemBlocksList,newblk);
  8032b9:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8032bd:	75 17                	jne    8032d6 <alloc_block_NF+0xe6>
  8032bf:	83 ec 04             	sub    $0x4,%esp
  8032c2:	68 a8 43 80 00       	push   $0x8043a8
  8032c7:	68 fc 00 00 00       	push   $0xfc
  8032cc:	68 37 43 80 00       	push   $0x804337
  8032d1:	e8 d4 d9 ff ff       	call   800caa <_panic>
  8032d6:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8032d9:	8b 00                	mov    (%eax),%eax
  8032db:	85 c0                	test   %eax,%eax
  8032dd:	74 10                	je     8032ef <alloc_block_NF+0xff>
  8032df:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8032e2:	8b 00                	mov    (%eax),%eax
  8032e4:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8032e7:	8b 52 04             	mov    0x4(%edx),%edx
  8032ea:	89 50 04             	mov    %edx,0x4(%eax)
  8032ed:	eb 0b                	jmp    8032fa <alloc_block_NF+0x10a>
  8032ef:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8032f2:	8b 40 04             	mov    0x4(%eax),%eax
  8032f5:	a3 4c 51 80 00       	mov    %eax,0x80514c
  8032fa:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8032fd:	8b 40 04             	mov    0x4(%eax),%eax
  803300:	85 c0                	test   %eax,%eax
  803302:	74 0f                	je     803313 <alloc_block_NF+0x123>
  803304:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803307:	8b 40 04             	mov    0x4(%eax),%eax
  80330a:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80330d:	8b 12                	mov    (%edx),%edx
  80330f:	89 10                	mov    %edx,(%eax)
  803311:	eb 0a                	jmp    80331d <alloc_block_NF+0x12d>
  803313:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803316:	8b 00                	mov    (%eax),%eax
  803318:	a3 48 51 80 00       	mov    %eax,0x805148
  80331d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803320:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803326:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803329:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803330:	a1 54 51 80 00       	mov    0x805154,%eax
  803335:	48                   	dec    %eax
  803336:	a3 54 51 80 00       	mov    %eax,0x805154
			newblk->size = versize;
  80333b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80333e:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803341:	89 50 0c             	mov    %edx,0xc(%eax)
			blk->size = blk->size-versize;
  803344:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803347:	8b 40 0c             	mov    0xc(%eax),%eax
  80334a:	2b 45 f0             	sub    -0x10(%ebp),%eax
  80334d:	89 c2                	mov    %eax,%edx
  80334f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803352:	89 50 0c             	mov    %edx,0xc(%eax)
			uint32 newveradd = blk->sva;
  803355:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803358:	8b 40 08             	mov    0x8(%eax),%eax
  80335b:	89 45 e8             	mov    %eax,-0x18(%ebp)
			blk->sva+=newblk->size;
  80335e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803361:	8b 50 08             	mov    0x8(%eax),%edx
  803364:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803367:	8b 40 0c             	mov    0xc(%eax),%eax
  80336a:	01 c2                	add    %eax,%edx
  80336c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80336f:	89 50 08             	mov    %edx,0x8(%eax)
			newblk->sva = newveradd;
  803372:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803375:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803378:	89 50 08             	mov    %edx,0x8(%eax)
			return newblk;
  80337b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80337e:	eb 3b                	jmp    8033bb <alloc_block_NF+0x1cb>
	//panic("alloc_block_NF() is not implemented yet...!!");
	uint32 versize = size;
	struct MemBlock* blk;
	struct MemBlock* newblk = LIST_FIRST(&AvailableMemBlocksList);

	LIST_FOREACH(blk,&FreeMemBlocksList)
  803380:	a1 40 51 80 00       	mov    0x805140,%eax
  803385:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803388:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80338c:	74 07                	je     803395 <alloc_block_NF+0x1a5>
  80338e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803391:	8b 00                	mov    (%eax),%eax
  803393:	eb 05                	jmp    80339a <alloc_block_NF+0x1aa>
  803395:	b8 00 00 00 00       	mov    $0x0,%eax
  80339a:	a3 40 51 80 00       	mov    %eax,0x805140
  80339f:	a1 40 51 80 00       	mov    0x805140,%eax
  8033a4:	85 c0                	test   %eax,%eax
  8033a6:	0f 85 65 fe ff ff    	jne    803211 <alloc_block_NF+0x21>
  8033ac:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8033b0:	0f 85 5b fe ff ff    	jne    803211 <alloc_block_NF+0x21>
			blk->sva+=newblk->size;
			newblk->sva = newveradd;
			return newblk;
		}
	}
	return NULL;
  8033b6:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8033bb:	c9                   	leave  
  8033bc:	c3                   	ret    

008033bd <addToAvailMemBlocksList>:

//===================================================
// [8] INSERT BLOCK (SORTED WITH MERGE) IN FREE LIST:
//===================================================
void addToAvailMemBlocksList(struct MemBlock *blockToInsert)
{
  8033bd:	55                   	push   %ebp
  8033be:	89 e5                	mov    %esp,%ebp
  8033c0:	83 ec 08             	sub    $0x8,%esp
	blockToInsert->sva = 0;
  8033c3:	8b 45 08             	mov    0x8(%ebp),%eax
  8033c6:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
	blockToInsert->size = 0;
  8033cd:	8b 45 08             	mov    0x8(%ebp),%eax
  8033d0:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
	//add to avail
	LIST_INSERT_TAIL(&AvailableMemBlocksList, blockToInsert);
  8033d7:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8033db:	75 17                	jne    8033f4 <addToAvailMemBlocksList+0x37>
  8033dd:	83 ec 04             	sub    $0x4,%esp
  8033e0:	68 50 43 80 00       	push   $0x804350
  8033e5:	68 10 01 00 00       	push   $0x110
  8033ea:	68 37 43 80 00       	push   $0x804337
  8033ef:	e8 b6 d8 ff ff       	call   800caa <_panic>
  8033f4:	8b 15 4c 51 80 00    	mov    0x80514c,%edx
  8033fa:	8b 45 08             	mov    0x8(%ebp),%eax
  8033fd:	89 50 04             	mov    %edx,0x4(%eax)
  803400:	8b 45 08             	mov    0x8(%ebp),%eax
  803403:	8b 40 04             	mov    0x4(%eax),%eax
  803406:	85 c0                	test   %eax,%eax
  803408:	74 0c                	je     803416 <addToAvailMemBlocksList+0x59>
  80340a:	a1 4c 51 80 00       	mov    0x80514c,%eax
  80340f:	8b 55 08             	mov    0x8(%ebp),%edx
  803412:	89 10                	mov    %edx,(%eax)
  803414:	eb 08                	jmp    80341e <addToAvailMemBlocksList+0x61>
  803416:	8b 45 08             	mov    0x8(%ebp),%eax
  803419:	a3 48 51 80 00       	mov    %eax,0x805148
  80341e:	8b 45 08             	mov    0x8(%ebp),%eax
  803421:	a3 4c 51 80 00       	mov    %eax,0x80514c
  803426:	8b 45 08             	mov    0x8(%ebp),%eax
  803429:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80342f:	a1 54 51 80 00       	mov    0x805154,%eax
  803434:	40                   	inc    %eax
  803435:	a3 54 51 80 00       	mov    %eax,0x805154
}
  80343a:	90                   	nop
  80343b:	c9                   	leave  
  80343c:	c3                   	ret    

0080343d <insert_sorted_with_merge_freeList>:
void insert_sorted_with_merge_freeList(struct MemBlock *blockToInsert)
{
  80343d:	55                   	push   %ebp
  80343e:	89 e5                	mov    %esp,%ebp
  803440:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] insert_sorted_with_merge_freeList
	// Write your code here, remove the panic and write your code

	struct MemBlock* last = LIST_LAST(&FreeMemBlocksList);
  803443:	a1 3c 51 80 00       	mov    0x80513c,%eax
  803448:	89 45 f0             	mov    %eax,-0x10(%ebp)
	//check if list empty
	if (LIST_SIZE(&(FreeMemBlocksList)) == 0)
  80344b:	a1 44 51 80 00       	mov    0x805144,%eax
  803450:	85 c0                	test   %eax,%eax
  803452:	75 68                	jne    8034bc <insert_sorted_with_merge_freeList+0x7f>
		LIST_INSERT_HEAD(&FreeMemBlocksList, blockToInsert);
  803454:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803458:	75 17                	jne    803471 <insert_sorted_with_merge_freeList+0x34>
  80345a:	83 ec 04             	sub    $0x4,%esp
  80345d:	68 14 43 80 00       	push   $0x804314
  803462:	68 1a 01 00 00       	push   $0x11a
  803467:	68 37 43 80 00       	push   $0x804337
  80346c:	e8 39 d8 ff ff       	call   800caa <_panic>
  803471:	8b 15 38 51 80 00    	mov    0x805138,%edx
  803477:	8b 45 08             	mov    0x8(%ebp),%eax
  80347a:	89 10                	mov    %edx,(%eax)
  80347c:	8b 45 08             	mov    0x8(%ebp),%eax
  80347f:	8b 00                	mov    (%eax),%eax
  803481:	85 c0                	test   %eax,%eax
  803483:	74 0d                	je     803492 <insert_sorted_with_merge_freeList+0x55>
  803485:	a1 38 51 80 00       	mov    0x805138,%eax
  80348a:	8b 55 08             	mov    0x8(%ebp),%edx
  80348d:	89 50 04             	mov    %edx,0x4(%eax)
  803490:	eb 08                	jmp    80349a <insert_sorted_with_merge_freeList+0x5d>
  803492:	8b 45 08             	mov    0x8(%ebp),%eax
  803495:	a3 3c 51 80 00       	mov    %eax,0x80513c
  80349a:	8b 45 08             	mov    0x8(%ebp),%eax
  80349d:	a3 38 51 80 00       	mov    %eax,0x805138
  8034a2:	8b 45 08             	mov    0x8(%ebp),%eax
  8034a5:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8034ac:	a1 44 51 80 00       	mov    0x805144,%eax
  8034b1:	40                   	inc    %eax
  8034b2:	a3 44 51 80 00       	mov    %eax,0x805144
		}
	}

	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  8034b7:	e9 c5 03 00 00       	jmp    803881 <insert_sorted_with_merge_freeList+0x444>
	struct MemBlock* last = LIST_LAST(&FreeMemBlocksList);
	//check if list empty
	if (LIST_SIZE(&(FreeMemBlocksList)) == 0)
		LIST_INSERT_HEAD(&FreeMemBlocksList, blockToInsert);
	//check if it's position is at last
	else if (last->sva < blockToInsert->sva) {
  8034bc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8034bf:	8b 50 08             	mov    0x8(%eax),%edx
  8034c2:	8b 45 08             	mov    0x8(%ebp),%eax
  8034c5:	8b 40 08             	mov    0x8(%eax),%eax
  8034c8:	39 c2                	cmp    %eax,%edx
  8034ca:	0f 83 b2 00 00 00    	jae    803582 <insert_sorted_with_merge_freeList+0x145>

		//if i have to merge
		if (last->sva + last->size == blockToInsert->sva) {
  8034d0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8034d3:	8b 50 08             	mov    0x8(%eax),%edx
  8034d6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8034d9:	8b 40 0c             	mov    0xc(%eax),%eax
  8034dc:	01 c2                	add    %eax,%edx
  8034de:	8b 45 08             	mov    0x8(%ebp),%eax
  8034e1:	8b 40 08             	mov    0x8(%eax),%eax
  8034e4:	39 c2                	cmp    %eax,%edx
  8034e6:	75 27                	jne    80350f <insert_sorted_with_merge_freeList+0xd2>
			last->size = last->size + blockToInsert->size;
  8034e8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8034eb:	8b 50 0c             	mov    0xc(%eax),%edx
  8034ee:	8b 45 08             	mov    0x8(%ebp),%eax
  8034f1:	8b 40 0c             	mov    0xc(%eax),%eax
  8034f4:	01 c2                	add    %eax,%edx
  8034f6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8034f9:	89 50 0c             	mov    %edx,0xc(%eax)
			addToAvailMemBlocksList(blockToInsert);
  8034fc:	83 ec 0c             	sub    $0xc,%esp
  8034ff:	ff 75 08             	pushl  0x8(%ebp)
  803502:	e8 b6 fe ff ff       	call   8033bd <addToAvailMemBlocksList>
  803507:	83 c4 10             	add    $0x10,%esp
		}
	}

	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  80350a:	e9 72 03 00 00       	jmp    803881 <insert_sorted_with_merge_freeList+0x444>
		if (last->sva + last->size == blockToInsert->sva) {
			last->size = last->size + blockToInsert->size;
			addToAvailMemBlocksList(blockToInsert);

		} else {
			LIST_INSERT_AFTER(&FreeMemBlocksList, last, blockToInsert);
  80350f:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  803513:	74 06                	je     80351b <insert_sorted_with_merge_freeList+0xde>
  803515:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803519:	75 17                	jne    803532 <insert_sorted_with_merge_freeList+0xf5>
  80351b:	83 ec 04             	sub    $0x4,%esp
  80351e:	68 74 43 80 00       	push   $0x804374
  803523:	68 24 01 00 00       	push   $0x124
  803528:	68 37 43 80 00       	push   $0x804337
  80352d:	e8 78 d7 ff ff       	call   800caa <_panic>
  803532:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803535:	8b 10                	mov    (%eax),%edx
  803537:	8b 45 08             	mov    0x8(%ebp),%eax
  80353a:	89 10                	mov    %edx,(%eax)
  80353c:	8b 45 08             	mov    0x8(%ebp),%eax
  80353f:	8b 00                	mov    (%eax),%eax
  803541:	85 c0                	test   %eax,%eax
  803543:	74 0b                	je     803550 <insert_sorted_with_merge_freeList+0x113>
  803545:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803548:	8b 00                	mov    (%eax),%eax
  80354a:	8b 55 08             	mov    0x8(%ebp),%edx
  80354d:	89 50 04             	mov    %edx,0x4(%eax)
  803550:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803553:	8b 55 08             	mov    0x8(%ebp),%edx
  803556:	89 10                	mov    %edx,(%eax)
  803558:	8b 45 08             	mov    0x8(%ebp),%eax
  80355b:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80355e:	89 50 04             	mov    %edx,0x4(%eax)
  803561:	8b 45 08             	mov    0x8(%ebp),%eax
  803564:	8b 00                	mov    (%eax),%eax
  803566:	85 c0                	test   %eax,%eax
  803568:	75 08                	jne    803572 <insert_sorted_with_merge_freeList+0x135>
  80356a:	8b 45 08             	mov    0x8(%ebp),%eax
  80356d:	a3 3c 51 80 00       	mov    %eax,0x80513c
  803572:	a1 44 51 80 00       	mov    0x805144,%eax
  803577:	40                   	inc    %eax
  803578:	a3 44 51 80 00       	mov    %eax,0x805144
		}
	}

	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  80357d:	e9 ff 02 00 00       	jmp    803881 <insert_sorted_with_merge_freeList+0x444>
		} else {
			LIST_INSERT_AFTER(&FreeMemBlocksList, last, blockToInsert);
		}
	} else {
		struct MemBlock *iterator;
		LIST_FOREACH(iterator, &(FreeMemBlocksList))
  803582:	a1 38 51 80 00       	mov    0x805138,%eax
  803587:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80358a:	e9 c2 02 00 00       	jmp    803851 <insert_sorted_with_merge_freeList+0x414>
		{

			if (iterator->sva > blockToInsert->sva) {
  80358f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803592:	8b 50 08             	mov    0x8(%eax),%edx
  803595:	8b 45 08             	mov    0x8(%ebp),%eax
  803598:	8b 40 08             	mov    0x8(%eax),%eax
  80359b:	39 c2                	cmp    %eax,%edx
  80359d:	0f 86 a6 02 00 00    	jbe    803849 <insert_sorted_with_merge_freeList+0x40c>

				struct MemBlock* prev = LIST_PREV(iterator);
  8035a3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8035a6:	8b 40 04             	mov    0x4(%eax),%eax
  8035a9:	89 45 ec             	mov    %eax,-0x14(%ebp)
				if (prev == NULL) {
  8035ac:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8035b0:	0f 85 ba 00 00 00    	jne    803670 <insert_sorted_with_merge_freeList+0x233>
					//check merge
					if (blockToInsert->size + blockToInsert->sva
  8035b6:	8b 45 08             	mov    0x8(%ebp),%eax
  8035b9:	8b 50 0c             	mov    0xc(%eax),%edx
  8035bc:	8b 45 08             	mov    0x8(%ebp),%eax
  8035bf:	8b 40 08             	mov    0x8(%eax),%eax
  8035c2:	01 c2                	add    %eax,%edx
							== iterator->sva) {
  8035c4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8035c7:	8b 40 08             	mov    0x8(%eax),%eax
			if (iterator->sva > blockToInsert->sva) {

				struct MemBlock* prev = LIST_PREV(iterator);
				if (prev == NULL) {
					//check merge
					if (blockToInsert->size + blockToInsert->sva
  8035ca:	39 c2                	cmp    %eax,%edx
  8035cc:	75 33                	jne    803601 <insert_sorted_with_merge_freeList+0x1c4>
							== iterator->sva) {
						iterator->sva = blockToInsert->sva;
  8035ce:	8b 45 08             	mov    0x8(%ebp),%eax
  8035d1:	8b 50 08             	mov    0x8(%eax),%edx
  8035d4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8035d7:	89 50 08             	mov    %edx,0x8(%eax)
						iterator->size = iterator->size + blockToInsert->size;
  8035da:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8035dd:	8b 50 0c             	mov    0xc(%eax),%edx
  8035e0:	8b 45 08             	mov    0x8(%ebp),%eax
  8035e3:	8b 40 0c             	mov    0xc(%eax),%eax
  8035e6:	01 c2                	add    %eax,%edx
  8035e8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8035eb:	89 50 0c             	mov    %edx,0xc(%eax)
						addToAvailMemBlocksList(blockToInsert);
  8035ee:	83 ec 0c             	sub    $0xc,%esp
  8035f1:	ff 75 08             	pushl  0x8(%ebp)
  8035f4:	e8 c4 fd ff ff       	call   8033bd <addToAvailMemBlocksList>
  8035f9:	83 c4 10             	add    $0x10,%esp

					else {
						LIST_INSERT_BEFORE(&FreeMemBlocksList, iterator,
								blockToInsert);
					}
					break;
  8035fc:	e9 80 02 00 00       	jmp    803881 <insert_sorted_with_merge_freeList+0x444>
						addToAvailMemBlocksList(blockToInsert);

					}

					else {
						LIST_INSERT_BEFORE(&FreeMemBlocksList, iterator,
  803601:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803605:	74 06                	je     80360d <insert_sorted_with_merge_freeList+0x1d0>
  803607:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80360b:	75 17                	jne    803624 <insert_sorted_with_merge_freeList+0x1e7>
  80360d:	83 ec 04             	sub    $0x4,%esp
  803610:	68 c8 43 80 00       	push   $0x8043c8
  803615:	68 3a 01 00 00       	push   $0x13a
  80361a:	68 37 43 80 00       	push   $0x804337
  80361f:	e8 86 d6 ff ff       	call   800caa <_panic>
  803624:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803627:	8b 50 04             	mov    0x4(%eax),%edx
  80362a:	8b 45 08             	mov    0x8(%ebp),%eax
  80362d:	89 50 04             	mov    %edx,0x4(%eax)
  803630:	8b 45 08             	mov    0x8(%ebp),%eax
  803633:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803636:	89 10                	mov    %edx,(%eax)
  803638:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80363b:	8b 40 04             	mov    0x4(%eax),%eax
  80363e:	85 c0                	test   %eax,%eax
  803640:	74 0d                	je     80364f <insert_sorted_with_merge_freeList+0x212>
  803642:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803645:	8b 40 04             	mov    0x4(%eax),%eax
  803648:	8b 55 08             	mov    0x8(%ebp),%edx
  80364b:	89 10                	mov    %edx,(%eax)
  80364d:	eb 08                	jmp    803657 <insert_sorted_with_merge_freeList+0x21a>
  80364f:	8b 45 08             	mov    0x8(%ebp),%eax
  803652:	a3 38 51 80 00       	mov    %eax,0x805138
  803657:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80365a:	8b 55 08             	mov    0x8(%ebp),%edx
  80365d:	89 50 04             	mov    %edx,0x4(%eax)
  803660:	a1 44 51 80 00       	mov    0x805144,%eax
  803665:	40                   	inc    %eax
  803666:	a3 44 51 80 00       	mov    %eax,0x805144
								blockToInsert);
					}
					break;
  80366b:	e9 11 02 00 00       	jmp    803881 <insert_sorted_with_merge_freeList+0x444>
				} else {
					//prev and next merge
					if (prev->sva + prev->size + blockToInsert->size
  803670:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803673:	8b 50 08             	mov    0x8(%eax),%edx
  803676:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803679:	8b 40 0c             	mov    0xc(%eax),%eax
  80367c:	01 c2                	add    %eax,%edx
  80367e:	8b 45 08             	mov    0x8(%ebp),%eax
  803681:	8b 40 0c             	mov    0xc(%eax),%eax
  803684:	01 c2                	add    %eax,%edx
							== iterator->sva) {
  803686:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803689:	8b 40 08             	mov    0x8(%eax),%eax
								blockToInsert);
					}
					break;
				} else {
					//prev and next merge
					if (prev->sva + prev->size + blockToInsert->size
  80368c:	39 c2                	cmp    %eax,%edx
  80368e:	0f 85 bf 00 00 00    	jne    803753 <insert_sorted_with_merge_freeList+0x316>
							== iterator->sva) {
						prev->size = prev->size + blockToInsert->size
  803694:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803697:	8b 50 0c             	mov    0xc(%eax),%edx
  80369a:	8b 45 08             	mov    0x8(%ebp),%eax
  80369d:	8b 40 0c             	mov    0xc(%eax),%eax
  8036a0:	01 c2                	add    %eax,%edx
								+ iterator->size;
  8036a2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8036a5:	8b 40 0c             	mov    0xc(%eax),%eax
  8036a8:	01 c2                	add    %eax,%edx
					break;
				} else {
					//prev and next merge
					if (prev->sva + prev->size + blockToInsert->size
							== iterator->sva) {
						prev->size = prev->size + blockToInsert->size
  8036aa:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8036ad:	89 50 0c             	mov    %edx,0xc(%eax)
								+ iterator->size;
						LIST_REMOVE(&FreeMemBlocksList, iterator);
  8036b0:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8036b4:	75 17                	jne    8036cd <insert_sorted_with_merge_freeList+0x290>
  8036b6:	83 ec 04             	sub    $0x4,%esp
  8036b9:	68 a8 43 80 00       	push   $0x8043a8
  8036be:	68 43 01 00 00       	push   $0x143
  8036c3:	68 37 43 80 00       	push   $0x804337
  8036c8:	e8 dd d5 ff ff       	call   800caa <_panic>
  8036cd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8036d0:	8b 00                	mov    (%eax),%eax
  8036d2:	85 c0                	test   %eax,%eax
  8036d4:	74 10                	je     8036e6 <insert_sorted_with_merge_freeList+0x2a9>
  8036d6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8036d9:	8b 00                	mov    (%eax),%eax
  8036db:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8036de:	8b 52 04             	mov    0x4(%edx),%edx
  8036e1:	89 50 04             	mov    %edx,0x4(%eax)
  8036e4:	eb 0b                	jmp    8036f1 <insert_sorted_with_merge_freeList+0x2b4>
  8036e6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8036e9:	8b 40 04             	mov    0x4(%eax),%eax
  8036ec:	a3 3c 51 80 00       	mov    %eax,0x80513c
  8036f1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8036f4:	8b 40 04             	mov    0x4(%eax),%eax
  8036f7:	85 c0                	test   %eax,%eax
  8036f9:	74 0f                	je     80370a <insert_sorted_with_merge_freeList+0x2cd>
  8036fb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8036fe:	8b 40 04             	mov    0x4(%eax),%eax
  803701:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803704:	8b 12                	mov    (%edx),%edx
  803706:	89 10                	mov    %edx,(%eax)
  803708:	eb 0a                	jmp    803714 <insert_sorted_with_merge_freeList+0x2d7>
  80370a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80370d:	8b 00                	mov    (%eax),%eax
  80370f:	a3 38 51 80 00       	mov    %eax,0x805138
  803714:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803717:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80371d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803720:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803727:	a1 44 51 80 00       	mov    0x805144,%eax
  80372c:	48                   	dec    %eax
  80372d:	a3 44 51 80 00       	mov    %eax,0x805144
						addToAvailMemBlocksList(blockToInsert);
  803732:	83 ec 0c             	sub    $0xc,%esp
  803735:	ff 75 08             	pushl  0x8(%ebp)
  803738:	e8 80 fc ff ff       	call   8033bd <addToAvailMemBlocksList>
  80373d:	83 c4 10             	add    $0x10,%esp
						addToAvailMemBlocksList(iterator);
  803740:	83 ec 0c             	sub    $0xc,%esp
  803743:	ff 75 f4             	pushl  -0xc(%ebp)
  803746:	e8 72 fc ff ff       	call   8033bd <addToAvailMemBlocksList>
  80374b:	83 c4 10             	add    $0x10,%esp
					//Insert
					else {
						LIST_INSERT_BEFORE(&FreeMemBlocksList, iterator,
								blockToInsert);
					}
					break;
  80374e:	e9 2e 01 00 00       	jmp    803881 <insert_sorted_with_merge_freeList+0x444>
						LIST_REMOVE(&FreeMemBlocksList, iterator);
						addToAvailMemBlocksList(blockToInsert);
						addToAvailMemBlocksList(iterator);
					}
					//previous merge
					else if (prev->sva + prev->size == blockToInsert->sva) {
  803753:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803756:	8b 50 08             	mov    0x8(%eax),%edx
  803759:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80375c:	8b 40 0c             	mov    0xc(%eax),%eax
  80375f:	01 c2                	add    %eax,%edx
  803761:	8b 45 08             	mov    0x8(%ebp),%eax
  803764:	8b 40 08             	mov    0x8(%eax),%eax
  803767:	39 c2                	cmp    %eax,%edx
  803769:	75 27                	jne    803792 <insert_sorted_with_merge_freeList+0x355>
						prev->size = prev->size + blockToInsert->size;
  80376b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80376e:	8b 50 0c             	mov    0xc(%eax),%edx
  803771:	8b 45 08             	mov    0x8(%ebp),%eax
  803774:	8b 40 0c             	mov    0xc(%eax),%eax
  803777:	01 c2                	add    %eax,%edx
  803779:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80377c:	89 50 0c             	mov    %edx,0xc(%eax)
						addToAvailMemBlocksList(blockToInsert);
  80377f:	83 ec 0c             	sub    $0xc,%esp
  803782:	ff 75 08             	pushl  0x8(%ebp)
  803785:	e8 33 fc ff ff       	call   8033bd <addToAvailMemBlocksList>
  80378a:	83 c4 10             	add    $0x10,%esp
					//Insert
					else {
						LIST_INSERT_BEFORE(&FreeMemBlocksList, iterator,
								blockToInsert);
					}
					break;
  80378d:	e9 ef 00 00 00       	jmp    803881 <insert_sorted_with_merge_freeList+0x444>
					else if (prev->sva + prev->size == blockToInsert->sva) {
						prev->size = prev->size + blockToInsert->size;
						addToAvailMemBlocksList(blockToInsert);
					}
					//next merge
					else if (blockToInsert->size + blockToInsert->sva
  803792:	8b 45 08             	mov    0x8(%ebp),%eax
  803795:	8b 50 0c             	mov    0xc(%eax),%edx
  803798:	8b 45 08             	mov    0x8(%ebp),%eax
  80379b:	8b 40 08             	mov    0x8(%eax),%eax
  80379e:	01 c2                	add    %eax,%edx
							== iterator->sva) {
  8037a0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8037a3:	8b 40 08             	mov    0x8(%eax),%eax
					else if (prev->sva + prev->size == blockToInsert->sva) {
						prev->size = prev->size + blockToInsert->size;
						addToAvailMemBlocksList(blockToInsert);
					}
					//next merge
					else if (blockToInsert->size + blockToInsert->sva
  8037a6:	39 c2                	cmp    %eax,%edx
  8037a8:	75 33                	jne    8037dd <insert_sorted_with_merge_freeList+0x3a0>
							== iterator->sva) {
						iterator->sva = blockToInsert->sva;
  8037aa:	8b 45 08             	mov    0x8(%ebp),%eax
  8037ad:	8b 50 08             	mov    0x8(%eax),%edx
  8037b0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8037b3:	89 50 08             	mov    %edx,0x8(%eax)
						iterator->size = iterator->size + blockToInsert->size;
  8037b6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8037b9:	8b 50 0c             	mov    0xc(%eax),%edx
  8037bc:	8b 45 08             	mov    0x8(%ebp),%eax
  8037bf:	8b 40 0c             	mov    0xc(%eax),%eax
  8037c2:	01 c2                	add    %eax,%edx
  8037c4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8037c7:	89 50 0c             	mov    %edx,0xc(%eax)
						addToAvailMemBlocksList(blockToInsert);
  8037ca:	83 ec 0c             	sub    $0xc,%esp
  8037cd:	ff 75 08             	pushl  0x8(%ebp)
  8037d0:	e8 e8 fb ff ff       	call   8033bd <addToAvailMemBlocksList>
  8037d5:	83 c4 10             	add    $0x10,%esp
					//Insert
					else {
						LIST_INSERT_BEFORE(&FreeMemBlocksList, iterator,
								blockToInsert);
					}
					break;
  8037d8:	e9 a4 00 00 00       	jmp    803881 <insert_sorted_with_merge_freeList+0x444>
						iterator->size = iterator->size + blockToInsert->size;
						addToAvailMemBlocksList(blockToInsert);
					}
					//Insert
					else {
						LIST_INSERT_BEFORE(&FreeMemBlocksList, iterator,
  8037dd:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8037e1:	74 06                	je     8037e9 <insert_sorted_with_merge_freeList+0x3ac>
  8037e3:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8037e7:	75 17                	jne    803800 <insert_sorted_with_merge_freeList+0x3c3>
  8037e9:	83 ec 04             	sub    $0x4,%esp
  8037ec:	68 c8 43 80 00       	push   $0x8043c8
  8037f1:	68 56 01 00 00       	push   $0x156
  8037f6:	68 37 43 80 00       	push   $0x804337
  8037fb:	e8 aa d4 ff ff       	call   800caa <_panic>
  803800:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803803:	8b 50 04             	mov    0x4(%eax),%edx
  803806:	8b 45 08             	mov    0x8(%ebp),%eax
  803809:	89 50 04             	mov    %edx,0x4(%eax)
  80380c:	8b 45 08             	mov    0x8(%ebp),%eax
  80380f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803812:	89 10                	mov    %edx,(%eax)
  803814:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803817:	8b 40 04             	mov    0x4(%eax),%eax
  80381a:	85 c0                	test   %eax,%eax
  80381c:	74 0d                	je     80382b <insert_sorted_with_merge_freeList+0x3ee>
  80381e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803821:	8b 40 04             	mov    0x4(%eax),%eax
  803824:	8b 55 08             	mov    0x8(%ebp),%edx
  803827:	89 10                	mov    %edx,(%eax)
  803829:	eb 08                	jmp    803833 <insert_sorted_with_merge_freeList+0x3f6>
  80382b:	8b 45 08             	mov    0x8(%ebp),%eax
  80382e:	a3 38 51 80 00       	mov    %eax,0x805138
  803833:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803836:	8b 55 08             	mov    0x8(%ebp),%edx
  803839:	89 50 04             	mov    %edx,0x4(%eax)
  80383c:	a1 44 51 80 00       	mov    0x805144,%eax
  803841:	40                   	inc    %eax
  803842:	a3 44 51 80 00       	mov    %eax,0x805144
								blockToInsert);
					}
					break;
  803847:	eb 38                	jmp    803881 <insert_sorted_with_merge_freeList+0x444>
		} else {
			LIST_INSERT_AFTER(&FreeMemBlocksList, last, blockToInsert);
		}
	} else {
		struct MemBlock *iterator;
		LIST_FOREACH(iterator, &(FreeMemBlocksList))
  803849:	a1 40 51 80 00       	mov    0x805140,%eax
  80384e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803851:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803855:	74 07                	je     80385e <insert_sorted_with_merge_freeList+0x421>
  803857:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80385a:	8b 00                	mov    (%eax),%eax
  80385c:	eb 05                	jmp    803863 <insert_sorted_with_merge_freeList+0x426>
  80385e:	b8 00 00 00 00       	mov    $0x0,%eax
  803863:	a3 40 51 80 00       	mov    %eax,0x805140
  803868:	a1 40 51 80 00       	mov    0x805140,%eax
  80386d:	85 c0                	test   %eax,%eax
  80386f:	0f 85 1a fd ff ff    	jne    80358f <insert_sorted_with_merge_freeList+0x152>
  803875:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803879:	0f 85 10 fd ff ff    	jne    80358f <insert_sorted_with_merge_freeList+0x152>
		}
	}

	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  80387f:	eb 00                	jmp    803881 <insert_sorted_with_merge_freeList+0x444>
  803881:	90                   	nop
  803882:	c9                   	leave  
  803883:	c3                   	ret    

00803884 <__udivdi3>:
  803884:	55                   	push   %ebp
  803885:	57                   	push   %edi
  803886:	56                   	push   %esi
  803887:	53                   	push   %ebx
  803888:	83 ec 1c             	sub    $0x1c,%esp
  80388b:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  80388f:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  803893:	8b 7c 24 38          	mov    0x38(%esp),%edi
  803897:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  80389b:	89 ca                	mov    %ecx,%edx
  80389d:	89 f8                	mov    %edi,%eax
  80389f:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  8038a3:	85 f6                	test   %esi,%esi
  8038a5:	75 2d                	jne    8038d4 <__udivdi3+0x50>
  8038a7:	39 cf                	cmp    %ecx,%edi
  8038a9:	77 65                	ja     803910 <__udivdi3+0x8c>
  8038ab:	89 fd                	mov    %edi,%ebp
  8038ad:	85 ff                	test   %edi,%edi
  8038af:	75 0b                	jne    8038bc <__udivdi3+0x38>
  8038b1:	b8 01 00 00 00       	mov    $0x1,%eax
  8038b6:	31 d2                	xor    %edx,%edx
  8038b8:	f7 f7                	div    %edi
  8038ba:	89 c5                	mov    %eax,%ebp
  8038bc:	31 d2                	xor    %edx,%edx
  8038be:	89 c8                	mov    %ecx,%eax
  8038c0:	f7 f5                	div    %ebp
  8038c2:	89 c1                	mov    %eax,%ecx
  8038c4:	89 d8                	mov    %ebx,%eax
  8038c6:	f7 f5                	div    %ebp
  8038c8:	89 cf                	mov    %ecx,%edi
  8038ca:	89 fa                	mov    %edi,%edx
  8038cc:	83 c4 1c             	add    $0x1c,%esp
  8038cf:	5b                   	pop    %ebx
  8038d0:	5e                   	pop    %esi
  8038d1:	5f                   	pop    %edi
  8038d2:	5d                   	pop    %ebp
  8038d3:	c3                   	ret    
  8038d4:	39 ce                	cmp    %ecx,%esi
  8038d6:	77 28                	ja     803900 <__udivdi3+0x7c>
  8038d8:	0f bd fe             	bsr    %esi,%edi
  8038db:	83 f7 1f             	xor    $0x1f,%edi
  8038de:	75 40                	jne    803920 <__udivdi3+0x9c>
  8038e0:	39 ce                	cmp    %ecx,%esi
  8038e2:	72 0a                	jb     8038ee <__udivdi3+0x6a>
  8038e4:	3b 44 24 08          	cmp    0x8(%esp),%eax
  8038e8:	0f 87 9e 00 00 00    	ja     80398c <__udivdi3+0x108>
  8038ee:	b8 01 00 00 00       	mov    $0x1,%eax
  8038f3:	89 fa                	mov    %edi,%edx
  8038f5:	83 c4 1c             	add    $0x1c,%esp
  8038f8:	5b                   	pop    %ebx
  8038f9:	5e                   	pop    %esi
  8038fa:	5f                   	pop    %edi
  8038fb:	5d                   	pop    %ebp
  8038fc:	c3                   	ret    
  8038fd:	8d 76 00             	lea    0x0(%esi),%esi
  803900:	31 ff                	xor    %edi,%edi
  803902:	31 c0                	xor    %eax,%eax
  803904:	89 fa                	mov    %edi,%edx
  803906:	83 c4 1c             	add    $0x1c,%esp
  803909:	5b                   	pop    %ebx
  80390a:	5e                   	pop    %esi
  80390b:	5f                   	pop    %edi
  80390c:	5d                   	pop    %ebp
  80390d:	c3                   	ret    
  80390e:	66 90                	xchg   %ax,%ax
  803910:	89 d8                	mov    %ebx,%eax
  803912:	f7 f7                	div    %edi
  803914:	31 ff                	xor    %edi,%edi
  803916:	89 fa                	mov    %edi,%edx
  803918:	83 c4 1c             	add    $0x1c,%esp
  80391b:	5b                   	pop    %ebx
  80391c:	5e                   	pop    %esi
  80391d:	5f                   	pop    %edi
  80391e:	5d                   	pop    %ebp
  80391f:	c3                   	ret    
  803920:	bd 20 00 00 00       	mov    $0x20,%ebp
  803925:	89 eb                	mov    %ebp,%ebx
  803927:	29 fb                	sub    %edi,%ebx
  803929:	89 f9                	mov    %edi,%ecx
  80392b:	d3 e6                	shl    %cl,%esi
  80392d:	89 c5                	mov    %eax,%ebp
  80392f:	88 d9                	mov    %bl,%cl
  803931:	d3 ed                	shr    %cl,%ebp
  803933:	89 e9                	mov    %ebp,%ecx
  803935:	09 f1                	or     %esi,%ecx
  803937:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  80393b:	89 f9                	mov    %edi,%ecx
  80393d:	d3 e0                	shl    %cl,%eax
  80393f:	89 c5                	mov    %eax,%ebp
  803941:	89 d6                	mov    %edx,%esi
  803943:	88 d9                	mov    %bl,%cl
  803945:	d3 ee                	shr    %cl,%esi
  803947:	89 f9                	mov    %edi,%ecx
  803949:	d3 e2                	shl    %cl,%edx
  80394b:	8b 44 24 08          	mov    0x8(%esp),%eax
  80394f:	88 d9                	mov    %bl,%cl
  803951:	d3 e8                	shr    %cl,%eax
  803953:	09 c2                	or     %eax,%edx
  803955:	89 d0                	mov    %edx,%eax
  803957:	89 f2                	mov    %esi,%edx
  803959:	f7 74 24 0c          	divl   0xc(%esp)
  80395d:	89 d6                	mov    %edx,%esi
  80395f:	89 c3                	mov    %eax,%ebx
  803961:	f7 e5                	mul    %ebp
  803963:	39 d6                	cmp    %edx,%esi
  803965:	72 19                	jb     803980 <__udivdi3+0xfc>
  803967:	74 0b                	je     803974 <__udivdi3+0xf0>
  803969:	89 d8                	mov    %ebx,%eax
  80396b:	31 ff                	xor    %edi,%edi
  80396d:	e9 58 ff ff ff       	jmp    8038ca <__udivdi3+0x46>
  803972:	66 90                	xchg   %ax,%ax
  803974:	8b 54 24 08          	mov    0x8(%esp),%edx
  803978:	89 f9                	mov    %edi,%ecx
  80397a:	d3 e2                	shl    %cl,%edx
  80397c:	39 c2                	cmp    %eax,%edx
  80397e:	73 e9                	jae    803969 <__udivdi3+0xe5>
  803980:	8d 43 ff             	lea    -0x1(%ebx),%eax
  803983:	31 ff                	xor    %edi,%edi
  803985:	e9 40 ff ff ff       	jmp    8038ca <__udivdi3+0x46>
  80398a:	66 90                	xchg   %ax,%ax
  80398c:	31 c0                	xor    %eax,%eax
  80398e:	e9 37 ff ff ff       	jmp    8038ca <__udivdi3+0x46>
  803993:	90                   	nop

00803994 <__umoddi3>:
  803994:	55                   	push   %ebp
  803995:	57                   	push   %edi
  803996:	56                   	push   %esi
  803997:	53                   	push   %ebx
  803998:	83 ec 1c             	sub    $0x1c,%esp
  80399b:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  80399f:	8b 74 24 34          	mov    0x34(%esp),%esi
  8039a3:	8b 7c 24 38          	mov    0x38(%esp),%edi
  8039a7:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  8039ab:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8039af:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8039b3:	89 f3                	mov    %esi,%ebx
  8039b5:	89 fa                	mov    %edi,%edx
  8039b7:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8039bb:	89 34 24             	mov    %esi,(%esp)
  8039be:	85 c0                	test   %eax,%eax
  8039c0:	75 1a                	jne    8039dc <__umoddi3+0x48>
  8039c2:	39 f7                	cmp    %esi,%edi
  8039c4:	0f 86 a2 00 00 00    	jbe    803a6c <__umoddi3+0xd8>
  8039ca:	89 c8                	mov    %ecx,%eax
  8039cc:	89 f2                	mov    %esi,%edx
  8039ce:	f7 f7                	div    %edi
  8039d0:	89 d0                	mov    %edx,%eax
  8039d2:	31 d2                	xor    %edx,%edx
  8039d4:	83 c4 1c             	add    $0x1c,%esp
  8039d7:	5b                   	pop    %ebx
  8039d8:	5e                   	pop    %esi
  8039d9:	5f                   	pop    %edi
  8039da:	5d                   	pop    %ebp
  8039db:	c3                   	ret    
  8039dc:	39 f0                	cmp    %esi,%eax
  8039de:	0f 87 ac 00 00 00    	ja     803a90 <__umoddi3+0xfc>
  8039e4:	0f bd e8             	bsr    %eax,%ebp
  8039e7:	83 f5 1f             	xor    $0x1f,%ebp
  8039ea:	0f 84 ac 00 00 00    	je     803a9c <__umoddi3+0x108>
  8039f0:	bf 20 00 00 00       	mov    $0x20,%edi
  8039f5:	29 ef                	sub    %ebp,%edi
  8039f7:	89 fe                	mov    %edi,%esi
  8039f9:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  8039fd:	89 e9                	mov    %ebp,%ecx
  8039ff:	d3 e0                	shl    %cl,%eax
  803a01:	89 d7                	mov    %edx,%edi
  803a03:	89 f1                	mov    %esi,%ecx
  803a05:	d3 ef                	shr    %cl,%edi
  803a07:	09 c7                	or     %eax,%edi
  803a09:	89 e9                	mov    %ebp,%ecx
  803a0b:	d3 e2                	shl    %cl,%edx
  803a0d:	89 14 24             	mov    %edx,(%esp)
  803a10:	89 d8                	mov    %ebx,%eax
  803a12:	d3 e0                	shl    %cl,%eax
  803a14:	89 c2                	mov    %eax,%edx
  803a16:	8b 44 24 08          	mov    0x8(%esp),%eax
  803a1a:	d3 e0                	shl    %cl,%eax
  803a1c:	89 44 24 04          	mov    %eax,0x4(%esp)
  803a20:	8b 44 24 08          	mov    0x8(%esp),%eax
  803a24:	89 f1                	mov    %esi,%ecx
  803a26:	d3 e8                	shr    %cl,%eax
  803a28:	09 d0                	or     %edx,%eax
  803a2a:	d3 eb                	shr    %cl,%ebx
  803a2c:	89 da                	mov    %ebx,%edx
  803a2e:	f7 f7                	div    %edi
  803a30:	89 d3                	mov    %edx,%ebx
  803a32:	f7 24 24             	mull   (%esp)
  803a35:	89 c6                	mov    %eax,%esi
  803a37:	89 d1                	mov    %edx,%ecx
  803a39:	39 d3                	cmp    %edx,%ebx
  803a3b:	0f 82 87 00 00 00    	jb     803ac8 <__umoddi3+0x134>
  803a41:	0f 84 91 00 00 00    	je     803ad8 <__umoddi3+0x144>
  803a47:	8b 54 24 04          	mov    0x4(%esp),%edx
  803a4b:	29 f2                	sub    %esi,%edx
  803a4d:	19 cb                	sbb    %ecx,%ebx
  803a4f:	89 d8                	mov    %ebx,%eax
  803a51:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  803a55:	d3 e0                	shl    %cl,%eax
  803a57:	89 e9                	mov    %ebp,%ecx
  803a59:	d3 ea                	shr    %cl,%edx
  803a5b:	09 d0                	or     %edx,%eax
  803a5d:	89 e9                	mov    %ebp,%ecx
  803a5f:	d3 eb                	shr    %cl,%ebx
  803a61:	89 da                	mov    %ebx,%edx
  803a63:	83 c4 1c             	add    $0x1c,%esp
  803a66:	5b                   	pop    %ebx
  803a67:	5e                   	pop    %esi
  803a68:	5f                   	pop    %edi
  803a69:	5d                   	pop    %ebp
  803a6a:	c3                   	ret    
  803a6b:	90                   	nop
  803a6c:	89 fd                	mov    %edi,%ebp
  803a6e:	85 ff                	test   %edi,%edi
  803a70:	75 0b                	jne    803a7d <__umoddi3+0xe9>
  803a72:	b8 01 00 00 00       	mov    $0x1,%eax
  803a77:	31 d2                	xor    %edx,%edx
  803a79:	f7 f7                	div    %edi
  803a7b:	89 c5                	mov    %eax,%ebp
  803a7d:	89 f0                	mov    %esi,%eax
  803a7f:	31 d2                	xor    %edx,%edx
  803a81:	f7 f5                	div    %ebp
  803a83:	89 c8                	mov    %ecx,%eax
  803a85:	f7 f5                	div    %ebp
  803a87:	89 d0                	mov    %edx,%eax
  803a89:	e9 44 ff ff ff       	jmp    8039d2 <__umoddi3+0x3e>
  803a8e:	66 90                	xchg   %ax,%ax
  803a90:	89 c8                	mov    %ecx,%eax
  803a92:	89 f2                	mov    %esi,%edx
  803a94:	83 c4 1c             	add    $0x1c,%esp
  803a97:	5b                   	pop    %ebx
  803a98:	5e                   	pop    %esi
  803a99:	5f                   	pop    %edi
  803a9a:	5d                   	pop    %ebp
  803a9b:	c3                   	ret    
  803a9c:	3b 04 24             	cmp    (%esp),%eax
  803a9f:	72 06                	jb     803aa7 <__umoddi3+0x113>
  803aa1:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  803aa5:	77 0f                	ja     803ab6 <__umoddi3+0x122>
  803aa7:	89 f2                	mov    %esi,%edx
  803aa9:	29 f9                	sub    %edi,%ecx
  803aab:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  803aaf:	89 14 24             	mov    %edx,(%esp)
  803ab2:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  803ab6:	8b 44 24 04          	mov    0x4(%esp),%eax
  803aba:	8b 14 24             	mov    (%esp),%edx
  803abd:	83 c4 1c             	add    $0x1c,%esp
  803ac0:	5b                   	pop    %ebx
  803ac1:	5e                   	pop    %esi
  803ac2:	5f                   	pop    %edi
  803ac3:	5d                   	pop    %ebp
  803ac4:	c3                   	ret    
  803ac5:	8d 76 00             	lea    0x0(%esi),%esi
  803ac8:	2b 04 24             	sub    (%esp),%eax
  803acb:	19 fa                	sbb    %edi,%edx
  803acd:	89 d1                	mov    %edx,%ecx
  803acf:	89 c6                	mov    %eax,%esi
  803ad1:	e9 71 ff ff ff       	jmp    803a47 <__umoddi3+0xb3>
  803ad6:	66 90                	xchg   %ax,%ax
  803ad8:	39 44 24 04          	cmp    %eax,0x4(%esp)
  803adc:	72 ea                	jb     803ac8 <__umoddi3+0x134>
  803ade:	89 d9                	mov    %ebx,%ecx
  803ae0:	e9 62 ff ff ff       	jmp    803a47 <__umoddi3+0xb3>
