
obj/user/tst_free_2:     file format elf32-i386


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
  800031:	e8 43 09 00 00       	call   800979 <libmain>
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
  80003c:	81 ec d4 00 00 00    	sub    $0xd4,%esp

	//Initial test to ensure it works on "PLACEMENT" not "REPLACEMENT"
	{
		uint8 fullWS = 1;
  800042:	c6 45 f7 01          	movb   $0x1,-0x9(%ebp)
		for (int i = 0; i < myEnv->page_WS_max_size; ++i)
  800046:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  80004d:	eb 29                	jmp    800078 <_main+0x40>
		{
			if (myEnv->__uptr_pws[i].empty)
  80004f:	a1 20 50 80 00       	mov    0x805020,%eax
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
{

	//Initial test to ensure it works on "PLACEMENT" not "REPLACEMENT"
	{
		uint8 fullWS = 1;
		for (int i = 0; i < myEnv->page_WS_max_size; ++i)
  800075:	ff 45 f0             	incl   -0x10(%ebp)
  800078:	a1 20 50 80 00       	mov    0x805020,%eax
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
  800090:	68 00 39 80 00       	push   $0x803900
  800095:	6a 14                	push   $0x14
  800097:	68 1c 39 80 00       	push   $0x80391c
  80009c:	e8 14 0a 00 00       	call   800ab5 <_panic>
	}
	/*Dummy malloc to enforce the UHEAP initializations*/
	malloc(0);
  8000a1:	83 ec 0c             	sub    $0xc,%esp
  8000a4:	6a 00                	push   $0x0
  8000a6:	e8 50 1c 00 00       	call   801cfb <malloc>
  8000ab:	83 c4 10             	add    $0x10,%esp
	/*=================================================*/
	//Bypass the PAGE FAULT on <MOVB immediate, reg> instruction by setting its length
	//and continue executing the remaining code
	sys_bypassPageFault(3);
  8000ae:	83 ec 0c             	sub    $0xc,%esp
  8000b1:	6a 03                	push   $0x3
  8000b3:	e8 e7 23 00 00       	call   80249f <sys_bypassPageFault>
  8000b8:	83 c4 10             	add    $0x10,%esp





	int Mega = 1024*1024;
  8000bb:	c7 45 ec 00 00 10 00 	movl   $0x100000,-0x14(%ebp)
	int kilo = 1024;
  8000c2:	c7 45 e8 00 04 00 00 	movl   $0x400,-0x18(%ebp)

	int start_freeFrames = sys_calculate_free_frames() ;
  8000c9:	e8 39 20 00 00       	call   802107 <sys_calculate_free_frames>
  8000ce:	89 45 e4             	mov    %eax,-0x1c(%ebp)

	//ALLOCATE ALL
	void* ptr_allocations[20] = {0};
  8000d1:	8d 55 80             	lea    -0x80(%ebp),%edx
  8000d4:	b9 14 00 00 00       	mov    $0x14,%ecx
  8000d9:	b8 00 00 00 00       	mov    $0x0,%eax
  8000de:	89 d7                	mov    %edx,%edi
  8000e0:	f3 ab                	rep stos %eax,%es:(%edi)
	int lastIndices[20] = {0};
  8000e2:	8d 95 30 ff ff ff    	lea    -0xd0(%ebp),%edx
  8000e8:	b9 14 00 00 00       	mov    $0x14,%ecx
  8000ed:	b8 00 00 00 00       	mov    $0x0,%eax
  8000f2:	89 d7                	mov    %edx,%edi
  8000f4:	f3 ab                	rep stos %eax,%es:(%edi)
	{
		int freeFrames = sys_calculate_free_frames() ;
  8000f6:	e8 0c 20 00 00       	call   802107 <sys_calculate_free_frames>
  8000fb:	89 45 e0             	mov    %eax,-0x20(%ebp)
		int usedDiskPages = sys_pf_calculate_allocated_pages() ;
  8000fe:	e8 a4 20 00 00       	call   8021a7 <sys_pf_calculate_allocated_pages>
  800103:	89 45 dc             	mov    %eax,-0x24(%ebp)
		ptr_allocations[0] = malloc(2*Mega-kilo);
  800106:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800109:	01 c0                	add    %eax,%eax
  80010b:	2b 45 e8             	sub    -0x18(%ebp),%eax
  80010e:	83 ec 0c             	sub    $0xc,%esp
  800111:	50                   	push   %eax
  800112:	e8 e4 1b 00 00       	call   801cfb <malloc>
  800117:	83 c4 10             	add    $0x10,%esp
  80011a:	89 45 80             	mov    %eax,-0x80(%ebp)
		if ((uint32) ptr_allocations[0] <  (USER_HEAP_START)) panic("Wrong start address for the allocated space... check return address of malloc & updating of heap ptr");
  80011d:	8b 45 80             	mov    -0x80(%ebp),%eax
  800120:	85 c0                	test   %eax,%eax
  800122:	78 14                	js     800138 <_main+0x100>
  800124:	83 ec 04             	sub    $0x4,%esp
  800127:	68 30 39 80 00       	push   $0x803930
  80012c:	6a 2d                	push   $0x2d
  80012e:	68 1c 39 80 00       	push   $0x80391c
  800133:	e8 7d 09 00 00       	call   800ab5 <_panic>
		if ((sys_pf_calculate_allocated_pages() - usedDiskPages) != 0) panic("Extra or less pages are allocated in PageFile");
  800138:	e8 6a 20 00 00       	call   8021a7 <sys_pf_calculate_allocated_pages>
  80013d:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  800140:	74 14                	je     800156 <_main+0x11e>
  800142:	83 ec 04             	sub    $0x4,%esp
  800145:	68 98 39 80 00       	push   $0x803998
  80014a:	6a 2e                	push   $0x2e
  80014c:	68 1c 39 80 00       	push   $0x80391c
  800151:	e8 5f 09 00 00       	call   800ab5 <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 512+1 ) panic("Wrong allocation: ");
		lastIndices[0] = (2*Mega-kilo)/sizeof(char) - 1;
  800156:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800159:	01 c0                	add    %eax,%eax
  80015b:	2b 45 e8             	sub    -0x18(%ebp),%eax
  80015e:	48                   	dec    %eax
  80015f:	89 85 30 ff ff ff    	mov    %eax,-0xd0(%ebp)

		freeFrames = sys_calculate_free_frames() ;
  800165:	e8 9d 1f 00 00       	call   802107 <sys_calculate_free_frames>
  80016a:	89 45 e0             	mov    %eax,-0x20(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  80016d:	e8 35 20 00 00       	call   8021a7 <sys_pf_calculate_allocated_pages>
  800172:	89 45 dc             	mov    %eax,-0x24(%ebp)
		ptr_allocations[1] = malloc(2*Mega-kilo);
  800175:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800178:	01 c0                	add    %eax,%eax
  80017a:	2b 45 e8             	sub    -0x18(%ebp),%eax
  80017d:	83 ec 0c             	sub    $0xc,%esp
  800180:	50                   	push   %eax
  800181:	e8 75 1b 00 00       	call   801cfb <malloc>
  800186:	83 c4 10             	add    $0x10,%esp
  800189:	89 45 84             	mov    %eax,-0x7c(%ebp)
		if ((uint32) ptr_allocations[1] < (USER_HEAP_START + 2*Mega)) panic("Wrong start address for the allocated space... check return address of malloc & updating of heap ptr");
  80018c:	8b 45 84             	mov    -0x7c(%ebp),%eax
  80018f:	89 c2                	mov    %eax,%edx
  800191:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800194:	01 c0                	add    %eax,%eax
  800196:	05 00 00 00 80       	add    $0x80000000,%eax
  80019b:	39 c2                	cmp    %eax,%edx
  80019d:	73 14                	jae    8001b3 <_main+0x17b>
  80019f:	83 ec 04             	sub    $0x4,%esp
  8001a2:	68 30 39 80 00       	push   $0x803930
  8001a7:	6a 35                	push   $0x35
  8001a9:	68 1c 39 80 00       	push   $0x80391c
  8001ae:	e8 02 09 00 00       	call   800ab5 <_panic>
		if ((sys_pf_calculate_allocated_pages() - usedDiskPages) != 0) panic("Extra or less pages are allocated in PageFile");
  8001b3:	e8 ef 1f 00 00       	call   8021a7 <sys_pf_calculate_allocated_pages>
  8001b8:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  8001bb:	74 14                	je     8001d1 <_main+0x199>
  8001bd:	83 ec 04             	sub    $0x4,%esp
  8001c0:	68 98 39 80 00       	push   $0x803998
  8001c5:	6a 36                	push   $0x36
  8001c7:	68 1c 39 80 00       	push   $0x80391c
  8001cc:	e8 e4 08 00 00       	call   800ab5 <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 512 ) panic("Wrong allocation: ");
		lastIndices[1] = (2*Mega-kilo)/sizeof(char) - 1;
  8001d1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8001d4:	01 c0                	add    %eax,%eax
  8001d6:	2b 45 e8             	sub    -0x18(%ebp),%eax
  8001d9:	48                   	dec    %eax
  8001da:	89 85 34 ff ff ff    	mov    %eax,-0xcc(%ebp)

		freeFrames = sys_calculate_free_frames() ;
  8001e0:	e8 22 1f 00 00       	call   802107 <sys_calculate_free_frames>
  8001e5:	89 45 e0             	mov    %eax,-0x20(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  8001e8:	e8 ba 1f 00 00       	call   8021a7 <sys_pf_calculate_allocated_pages>
  8001ed:	89 45 dc             	mov    %eax,-0x24(%ebp)
		ptr_allocations[2] = malloc(2*kilo);
  8001f0:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8001f3:	01 c0                	add    %eax,%eax
  8001f5:	83 ec 0c             	sub    $0xc,%esp
  8001f8:	50                   	push   %eax
  8001f9:	e8 fd 1a 00 00       	call   801cfb <malloc>
  8001fe:	83 c4 10             	add    $0x10,%esp
  800201:	89 45 88             	mov    %eax,-0x78(%ebp)
		if ((uint32) ptr_allocations[2] < (USER_HEAP_START + 4*Mega)) panic("Wrong start address for the allocated space... check return address of malloc & updating of heap ptr");
  800204:	8b 45 88             	mov    -0x78(%ebp),%eax
  800207:	89 c2                	mov    %eax,%edx
  800209:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80020c:	c1 e0 02             	shl    $0x2,%eax
  80020f:	05 00 00 00 80       	add    $0x80000000,%eax
  800214:	39 c2                	cmp    %eax,%edx
  800216:	73 14                	jae    80022c <_main+0x1f4>
  800218:	83 ec 04             	sub    $0x4,%esp
  80021b:	68 30 39 80 00       	push   $0x803930
  800220:	6a 3d                	push   $0x3d
  800222:	68 1c 39 80 00       	push   $0x80391c
  800227:	e8 89 08 00 00       	call   800ab5 <_panic>
		if ((sys_pf_calculate_allocated_pages() - usedDiskPages) != 0) panic("Extra or less pages are allocated in PageFile");
  80022c:	e8 76 1f 00 00       	call   8021a7 <sys_pf_calculate_allocated_pages>
  800231:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  800234:	74 14                	je     80024a <_main+0x212>
  800236:	83 ec 04             	sub    $0x4,%esp
  800239:	68 98 39 80 00       	push   $0x803998
  80023e:	6a 3e                	push   $0x3e
  800240:	68 1c 39 80 00       	push   $0x80391c
  800245:	e8 6b 08 00 00       	call   800ab5 <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 1+1 ) panic("Wrong allocation: ");
		lastIndices[2] = (2*kilo)/sizeof(char) - 1;
  80024a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80024d:	01 c0                	add    %eax,%eax
  80024f:	48                   	dec    %eax
  800250:	89 85 38 ff ff ff    	mov    %eax,-0xc8(%ebp)

		freeFrames = sys_calculate_free_frames() ;
  800256:	e8 ac 1e 00 00       	call   802107 <sys_calculate_free_frames>
  80025b:	89 45 e0             	mov    %eax,-0x20(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  80025e:	e8 44 1f 00 00       	call   8021a7 <sys_pf_calculate_allocated_pages>
  800263:	89 45 dc             	mov    %eax,-0x24(%ebp)
		ptr_allocations[3] = malloc(2*kilo);
  800266:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800269:	01 c0                	add    %eax,%eax
  80026b:	83 ec 0c             	sub    $0xc,%esp
  80026e:	50                   	push   %eax
  80026f:	e8 87 1a 00 00       	call   801cfb <malloc>
  800274:	83 c4 10             	add    $0x10,%esp
  800277:	89 45 8c             	mov    %eax,-0x74(%ebp)
		if ((uint32) ptr_allocations[3] < (USER_HEAP_START + 4*Mega + 4*kilo)) panic("Wrong start address for the allocated space... check return address of malloc & updating of heap ptr");
  80027a:	8b 45 8c             	mov    -0x74(%ebp),%eax
  80027d:	89 c2                	mov    %eax,%edx
  80027f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800282:	c1 e0 02             	shl    $0x2,%eax
  800285:	89 c1                	mov    %eax,%ecx
  800287:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80028a:	c1 e0 02             	shl    $0x2,%eax
  80028d:	01 c8                	add    %ecx,%eax
  80028f:	05 00 00 00 80       	add    $0x80000000,%eax
  800294:	39 c2                	cmp    %eax,%edx
  800296:	73 14                	jae    8002ac <_main+0x274>
  800298:	83 ec 04             	sub    $0x4,%esp
  80029b:	68 30 39 80 00       	push   $0x803930
  8002a0:	6a 45                	push   $0x45
  8002a2:	68 1c 39 80 00       	push   $0x80391c
  8002a7:	e8 09 08 00 00       	call   800ab5 <_panic>
		if ((sys_pf_calculate_allocated_pages() - usedDiskPages) != 0) panic("Extra or less pages are allocated in PageFile");
  8002ac:	e8 f6 1e 00 00       	call   8021a7 <sys_pf_calculate_allocated_pages>
  8002b1:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  8002b4:	74 14                	je     8002ca <_main+0x292>
  8002b6:	83 ec 04             	sub    $0x4,%esp
  8002b9:	68 98 39 80 00       	push   $0x803998
  8002be:	6a 46                	push   $0x46
  8002c0:	68 1c 39 80 00       	push   $0x80391c
  8002c5:	e8 eb 07 00 00       	call   800ab5 <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 1 ) panic("Wrong allocation: ");
		lastIndices[3] = (2*kilo)/sizeof(char) - 1;
  8002ca:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8002cd:	01 c0                	add    %eax,%eax
  8002cf:	48                   	dec    %eax
  8002d0:	89 85 3c ff ff ff    	mov    %eax,-0xc4(%ebp)

		freeFrames = sys_calculate_free_frames() ;
  8002d6:	e8 2c 1e 00 00       	call   802107 <sys_calculate_free_frames>
  8002db:	89 45 e0             	mov    %eax,-0x20(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  8002de:	e8 c4 1e 00 00       	call   8021a7 <sys_pf_calculate_allocated_pages>
  8002e3:	89 45 dc             	mov    %eax,-0x24(%ebp)
		ptr_allocations[4] = malloc(7*kilo);
  8002e6:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8002e9:	89 d0                	mov    %edx,%eax
  8002eb:	01 c0                	add    %eax,%eax
  8002ed:	01 d0                	add    %edx,%eax
  8002ef:	01 c0                	add    %eax,%eax
  8002f1:	01 d0                	add    %edx,%eax
  8002f3:	83 ec 0c             	sub    $0xc,%esp
  8002f6:	50                   	push   %eax
  8002f7:	e8 ff 19 00 00       	call   801cfb <malloc>
  8002fc:	83 c4 10             	add    $0x10,%esp
  8002ff:	89 45 90             	mov    %eax,-0x70(%ebp)
		if ((uint32) ptr_allocations[4] < (USER_HEAP_START + 4*Mega + 8*kilo)) panic("Wrong start address for the allocated space... check return address of malloc & updating of heap ptr");
  800302:	8b 45 90             	mov    -0x70(%ebp),%eax
  800305:	89 c2                	mov    %eax,%edx
  800307:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80030a:	c1 e0 02             	shl    $0x2,%eax
  80030d:	89 c1                	mov    %eax,%ecx
  80030f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800312:	c1 e0 03             	shl    $0x3,%eax
  800315:	01 c8                	add    %ecx,%eax
  800317:	05 00 00 00 80       	add    $0x80000000,%eax
  80031c:	39 c2                	cmp    %eax,%edx
  80031e:	73 14                	jae    800334 <_main+0x2fc>
  800320:	83 ec 04             	sub    $0x4,%esp
  800323:	68 30 39 80 00       	push   $0x803930
  800328:	6a 4d                	push   $0x4d
  80032a:	68 1c 39 80 00       	push   $0x80391c
  80032f:	e8 81 07 00 00       	call   800ab5 <_panic>
		if ((sys_pf_calculate_allocated_pages() - usedDiskPages) != 0) panic("Extra or less pages are allocated in PageFile");
  800334:	e8 6e 1e 00 00       	call   8021a7 <sys_pf_calculate_allocated_pages>
  800339:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  80033c:	74 14                	je     800352 <_main+0x31a>
  80033e:	83 ec 04             	sub    $0x4,%esp
  800341:	68 98 39 80 00       	push   $0x803998
  800346:	6a 4e                	push   $0x4e
  800348:	68 1c 39 80 00       	push   $0x80391c
  80034d:	e8 63 07 00 00       	call   800ab5 <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 2)panic("Wrong allocation: ");
		lastIndices[4] = (7*kilo)/sizeof(char) - 1;
  800352:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800355:	89 d0                	mov    %edx,%eax
  800357:	01 c0                	add    %eax,%eax
  800359:	01 d0                	add    %edx,%eax
  80035b:	01 c0                	add    %eax,%eax
  80035d:	01 d0                	add    %edx,%eax
  80035f:	48                   	dec    %eax
  800360:	89 85 40 ff ff ff    	mov    %eax,-0xc0(%ebp)

		freeFrames = sys_calculate_free_frames() ;
  800366:	e8 9c 1d 00 00       	call   802107 <sys_calculate_free_frames>
  80036b:	89 45 e0             	mov    %eax,-0x20(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  80036e:	e8 34 1e 00 00       	call   8021a7 <sys_pf_calculate_allocated_pages>
  800373:	89 45 dc             	mov    %eax,-0x24(%ebp)
		ptr_allocations[5] = malloc(3*Mega-kilo);
  800376:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800379:	89 c2                	mov    %eax,%edx
  80037b:	01 d2                	add    %edx,%edx
  80037d:	01 d0                	add    %edx,%eax
  80037f:	2b 45 e8             	sub    -0x18(%ebp),%eax
  800382:	83 ec 0c             	sub    $0xc,%esp
  800385:	50                   	push   %eax
  800386:	e8 70 19 00 00       	call   801cfb <malloc>
  80038b:	83 c4 10             	add    $0x10,%esp
  80038e:	89 45 94             	mov    %eax,-0x6c(%ebp)
		if ((uint32) ptr_allocations[5] < (USER_HEAP_START + 4*Mega + 16*kilo)) panic("Wrong start address for the allocated space... check return address of malloc & updating of heap ptr");
  800391:	8b 45 94             	mov    -0x6c(%ebp),%eax
  800394:	89 c2                	mov    %eax,%edx
  800396:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800399:	c1 e0 02             	shl    $0x2,%eax
  80039c:	89 c1                	mov    %eax,%ecx
  80039e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8003a1:	c1 e0 04             	shl    $0x4,%eax
  8003a4:	01 c8                	add    %ecx,%eax
  8003a6:	05 00 00 00 80       	add    $0x80000000,%eax
  8003ab:	39 c2                	cmp    %eax,%edx
  8003ad:	73 14                	jae    8003c3 <_main+0x38b>
  8003af:	83 ec 04             	sub    $0x4,%esp
  8003b2:	68 30 39 80 00       	push   $0x803930
  8003b7:	6a 55                	push   $0x55
  8003b9:	68 1c 39 80 00       	push   $0x80391c
  8003be:	e8 f2 06 00 00       	call   800ab5 <_panic>
		if ((sys_pf_calculate_allocated_pages() - usedDiskPages) != 0) panic("Extra or less pages are allocated in PageFile");
  8003c3:	e8 df 1d 00 00       	call   8021a7 <sys_pf_calculate_allocated_pages>
  8003c8:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  8003cb:	74 14                	je     8003e1 <_main+0x3a9>
  8003cd:	83 ec 04             	sub    $0x4,%esp
  8003d0:	68 98 39 80 00       	push   $0x803998
  8003d5:	6a 56                	push   $0x56
  8003d7:	68 1c 39 80 00       	push   $0x80391c
  8003dc:	e8 d4 06 00 00       	call   800ab5 <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 3*Mega/4096 ) panic("Wrong allocation: ");
		lastIndices[5] = (3*Mega - kilo)/sizeof(char) - 1;
  8003e1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8003e4:	89 c2                	mov    %eax,%edx
  8003e6:	01 d2                	add    %edx,%edx
  8003e8:	01 d0                	add    %edx,%eax
  8003ea:	2b 45 e8             	sub    -0x18(%ebp),%eax
  8003ed:	48                   	dec    %eax
  8003ee:	89 85 44 ff ff ff    	mov    %eax,-0xbc(%ebp)

		freeFrames = sys_calculate_free_frames() ;
  8003f4:	e8 0e 1d 00 00       	call   802107 <sys_calculate_free_frames>
  8003f9:	89 45 e0             	mov    %eax,-0x20(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  8003fc:	e8 a6 1d 00 00       	call   8021a7 <sys_pf_calculate_allocated_pages>
  800401:	89 45 dc             	mov    %eax,-0x24(%ebp)
		ptr_allocations[6] = malloc(2*Mega-kilo);
  800404:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800407:	01 c0                	add    %eax,%eax
  800409:	2b 45 e8             	sub    -0x18(%ebp),%eax
  80040c:	83 ec 0c             	sub    $0xc,%esp
  80040f:	50                   	push   %eax
  800410:	e8 e6 18 00 00       	call   801cfb <malloc>
  800415:	83 c4 10             	add    $0x10,%esp
  800418:	89 45 98             	mov    %eax,-0x68(%ebp)
		if ((uint32) ptr_allocations[6] < (USER_HEAP_START + 7*Mega + 16*kilo)) panic("Wrong start address for the allocated space... check return address of malloc & updating of heap ptr");
  80041b:	8b 45 98             	mov    -0x68(%ebp),%eax
  80041e:	89 c1                	mov    %eax,%ecx
  800420:	8b 55 ec             	mov    -0x14(%ebp),%edx
  800423:	89 d0                	mov    %edx,%eax
  800425:	01 c0                	add    %eax,%eax
  800427:	01 d0                	add    %edx,%eax
  800429:	01 c0                	add    %eax,%eax
  80042b:	01 d0                	add    %edx,%eax
  80042d:	89 c2                	mov    %eax,%edx
  80042f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800432:	c1 e0 04             	shl    $0x4,%eax
  800435:	01 d0                	add    %edx,%eax
  800437:	05 00 00 00 80       	add    $0x80000000,%eax
  80043c:	39 c1                	cmp    %eax,%ecx
  80043e:	73 14                	jae    800454 <_main+0x41c>
  800440:	83 ec 04             	sub    $0x4,%esp
  800443:	68 30 39 80 00       	push   $0x803930
  800448:	6a 5d                	push   $0x5d
  80044a:	68 1c 39 80 00       	push   $0x80391c
  80044f:	e8 61 06 00 00       	call   800ab5 <_panic>
		if ((sys_pf_calculate_allocated_pages() - usedDiskPages) != 0) panic("Extra or less pages are allocated in PageFile");
  800454:	e8 4e 1d 00 00       	call   8021a7 <sys_pf_calculate_allocated_pages>
  800459:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  80045c:	74 14                	je     800472 <_main+0x43a>
  80045e:	83 ec 04             	sub    $0x4,%esp
  800461:	68 98 39 80 00       	push   $0x803998
  800466:	6a 5e                	push   $0x5e
  800468:	68 1c 39 80 00       	push   $0x80391c
  80046d:	e8 43 06 00 00       	call   800ab5 <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 512+1 ) panic("Wrong allocation: ");
		lastIndices[6] = (2*Mega - kilo)/sizeof(char) - 1;
  800472:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800475:	01 c0                	add    %eax,%eax
  800477:	2b 45 e8             	sub    -0x18(%ebp),%eax
  80047a:	48                   	dec    %eax
  80047b:	89 85 48 ff ff ff    	mov    %eax,-0xb8(%ebp)
	char x ;
	int y;
	char *byteArr ;
	//FREE ALL
	{
		int freeFrames = sys_calculate_free_frames() ;
  800481:	e8 81 1c 00 00       	call   802107 <sys_calculate_free_frames>
  800486:	89 45 d8             	mov    %eax,-0x28(%ebp)
		int usedDiskPages = sys_pf_calculate_allocated_pages() ;
  800489:	e8 19 1d 00 00       	call   8021a7 <sys_pf_calculate_allocated_pages>
  80048e:	89 45 d4             	mov    %eax,-0x2c(%ebp)
		free(ptr_allocations[0]);
  800491:	8b 45 80             	mov    -0x80(%ebp),%eax
  800494:	83 ec 0c             	sub    $0xc,%esp
  800497:	50                   	push   %eax
  800498:	e8 df 18 00 00       	call   801d7c <free>
  80049d:	83 c4 10             	add    $0x10,%esp
		if ((usedDiskPages - sys_pf_calculate_allocated_pages()) != 0) panic("Wrong free: Extra or less pages are removed from PageFile");
  8004a0:	e8 02 1d 00 00       	call   8021a7 <sys_pf_calculate_allocated_pages>
  8004a5:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  8004a8:	74 14                	je     8004be <_main+0x486>
  8004aa:	83 ec 04             	sub    $0x4,%esp
  8004ad:	68 c8 39 80 00       	push   $0x8039c8
  8004b2:	6a 6b                	push   $0x6b
  8004b4:	68 1c 39 80 00       	push   $0x80391c
  8004b9:	e8 f7 05 00 00       	call   800ab5 <_panic>
		//if ((sys_calculate_free_frames() - freeFrames) != 512 ) panic("Wrong free: ");
		byteArr = (char *) ptr_allocations[0];
  8004be:	8b 45 80             	mov    -0x80(%ebp),%eax
  8004c1:	89 45 d0             	mov    %eax,-0x30(%ebp)
		byteArr[0] = 10;
  8004c4:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8004c7:	c6 00 0a             	movb   $0xa,(%eax)
		if (sys_rcr2() != (uint32)&(byteArr[0])) panic("Free: successful access to freed space!! it should not be succeeded");
  8004ca:	e8 b7 1f 00 00       	call   802486 <sys_rcr2>
  8004cf:	89 c2                	mov    %eax,%edx
  8004d1:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8004d4:	39 c2                	cmp    %eax,%edx
  8004d6:	74 14                	je     8004ec <_main+0x4b4>
  8004d8:	83 ec 04             	sub    $0x4,%esp
  8004db:	68 04 3a 80 00       	push   $0x803a04
  8004e0:	6a 6f                	push   $0x6f
  8004e2:	68 1c 39 80 00       	push   $0x80391c
  8004e7:	e8 c9 05 00 00       	call   800ab5 <_panic>
		byteArr[lastIndices[0]] = 10;
  8004ec:	8b 85 30 ff ff ff    	mov    -0xd0(%ebp),%eax
  8004f2:	89 c2                	mov    %eax,%edx
  8004f4:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8004f7:	01 d0                	add    %edx,%eax
  8004f9:	c6 00 0a             	movb   $0xa,(%eax)
		if (sys_rcr2() != (uint32)&(byteArr[lastIndices[0]])) panic("Free: successful access to freed space!! it should not be succeeded");
  8004fc:	e8 85 1f 00 00       	call   802486 <sys_rcr2>
  800501:	8b 95 30 ff ff ff    	mov    -0xd0(%ebp),%edx
  800507:	89 d1                	mov    %edx,%ecx
  800509:	8b 55 d0             	mov    -0x30(%ebp),%edx
  80050c:	01 ca                	add    %ecx,%edx
  80050e:	39 d0                	cmp    %edx,%eax
  800510:	74 14                	je     800526 <_main+0x4ee>
  800512:	83 ec 04             	sub    $0x4,%esp
  800515:	68 04 3a 80 00       	push   $0x803a04
  80051a:	6a 71                	push   $0x71
  80051c:	68 1c 39 80 00       	push   $0x80391c
  800521:	e8 8f 05 00 00       	call   800ab5 <_panic>

		freeFrames = sys_calculate_free_frames() ;
  800526:	e8 dc 1b 00 00       	call   802107 <sys_calculate_free_frames>
  80052b:	89 45 d8             	mov    %eax,-0x28(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  80052e:	e8 74 1c 00 00       	call   8021a7 <sys_pf_calculate_allocated_pages>
  800533:	89 45 d4             	mov    %eax,-0x2c(%ebp)
		free(ptr_allocations[1]);
  800536:	8b 45 84             	mov    -0x7c(%ebp),%eax
  800539:	83 ec 0c             	sub    $0xc,%esp
  80053c:	50                   	push   %eax
  80053d:	e8 3a 18 00 00       	call   801d7c <free>
  800542:	83 c4 10             	add    $0x10,%esp
		if ((usedDiskPages - sys_pf_calculate_allocated_pages()) != 0) panic("Wrong free: Extra or less pages are removed from PageFile");
  800545:	e8 5d 1c 00 00       	call   8021a7 <sys_pf_calculate_allocated_pages>
  80054a:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  80054d:	74 14                	je     800563 <_main+0x52b>
  80054f:	83 ec 04             	sub    $0x4,%esp
  800552:	68 c8 39 80 00       	push   $0x8039c8
  800557:	6a 76                	push   $0x76
  800559:	68 1c 39 80 00       	push   $0x80391c
  80055e:	e8 52 05 00 00       	call   800ab5 <_panic>
		//if ((sys_calculate_free_frames() - freeFrames) != 512 + 1 ) panic("Wrong free: ");
		byteArr = (char *) ptr_allocations[1];
  800563:	8b 45 84             	mov    -0x7c(%ebp),%eax
  800566:	89 45 d0             	mov    %eax,-0x30(%ebp)
		byteArr[0] = 10;
  800569:	8b 45 d0             	mov    -0x30(%ebp),%eax
  80056c:	c6 00 0a             	movb   $0xa,(%eax)
		if (sys_rcr2() != (uint32)&(byteArr[0])) panic("Free: successful access to freed space!! it should not be succeeded");
  80056f:	e8 12 1f 00 00       	call   802486 <sys_rcr2>
  800574:	89 c2                	mov    %eax,%edx
  800576:	8b 45 d0             	mov    -0x30(%ebp),%eax
  800579:	39 c2                	cmp    %eax,%edx
  80057b:	74 14                	je     800591 <_main+0x559>
  80057d:	83 ec 04             	sub    $0x4,%esp
  800580:	68 04 3a 80 00       	push   $0x803a04
  800585:	6a 7a                	push   $0x7a
  800587:	68 1c 39 80 00       	push   $0x80391c
  80058c:	e8 24 05 00 00       	call   800ab5 <_panic>
		byteArr[lastIndices[1]] = 10;
  800591:	8b 85 34 ff ff ff    	mov    -0xcc(%ebp),%eax
  800597:	89 c2                	mov    %eax,%edx
  800599:	8b 45 d0             	mov    -0x30(%ebp),%eax
  80059c:	01 d0                	add    %edx,%eax
  80059e:	c6 00 0a             	movb   $0xa,(%eax)
		if (sys_rcr2() != (uint32)&(byteArr[lastIndices[1]])) panic("Free: successful access to freed space!! it should not be succeeded");
  8005a1:	e8 e0 1e 00 00       	call   802486 <sys_rcr2>
  8005a6:	8b 95 34 ff ff ff    	mov    -0xcc(%ebp),%edx
  8005ac:	89 d1                	mov    %edx,%ecx
  8005ae:	8b 55 d0             	mov    -0x30(%ebp),%edx
  8005b1:	01 ca                	add    %ecx,%edx
  8005b3:	39 d0                	cmp    %edx,%eax
  8005b5:	74 14                	je     8005cb <_main+0x593>
  8005b7:	83 ec 04             	sub    $0x4,%esp
  8005ba:	68 04 3a 80 00       	push   $0x803a04
  8005bf:	6a 7c                	push   $0x7c
  8005c1:	68 1c 39 80 00       	push   $0x80391c
  8005c6:	e8 ea 04 00 00       	call   800ab5 <_panic>

		freeFrames = sys_calculate_free_frames() ;
  8005cb:	e8 37 1b 00 00       	call   802107 <sys_calculate_free_frames>
  8005d0:	89 45 d8             	mov    %eax,-0x28(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  8005d3:	e8 cf 1b 00 00       	call   8021a7 <sys_pf_calculate_allocated_pages>
  8005d8:	89 45 d4             	mov    %eax,-0x2c(%ebp)
		free(ptr_allocations[2]);
  8005db:	8b 45 88             	mov    -0x78(%ebp),%eax
  8005de:	83 ec 0c             	sub    $0xc,%esp
  8005e1:	50                   	push   %eax
  8005e2:	e8 95 17 00 00       	call   801d7c <free>
  8005e7:	83 c4 10             	add    $0x10,%esp
		if ((usedDiskPages - sys_pf_calculate_allocated_pages()) != 0) panic("Wrong free: Extra or less pages are removed from PageFile");
  8005ea:	e8 b8 1b 00 00       	call   8021a7 <sys_pf_calculate_allocated_pages>
  8005ef:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  8005f2:	74 17                	je     80060b <_main+0x5d3>
  8005f4:	83 ec 04             	sub    $0x4,%esp
  8005f7:	68 c8 39 80 00       	push   $0x8039c8
  8005fc:	68 81 00 00 00       	push   $0x81
  800601:	68 1c 39 80 00       	push   $0x80391c
  800606:	e8 aa 04 00 00       	call   800ab5 <_panic>
		//if ((sys_calculate_free_frames() - freeFrames) != 1 ) panic("Wrong free: ");
		byteArr = (char *) ptr_allocations[2];
  80060b:	8b 45 88             	mov    -0x78(%ebp),%eax
  80060e:	89 45 d0             	mov    %eax,-0x30(%ebp)
		byteArr[0] = 10;
  800611:	8b 45 d0             	mov    -0x30(%ebp),%eax
  800614:	c6 00 0a             	movb   $0xa,(%eax)
		if (sys_rcr2() != (uint32)&(byteArr[0])) panic("Free: successful access to freed space!! it should not be succeeded");
  800617:	e8 6a 1e 00 00       	call   802486 <sys_rcr2>
  80061c:	89 c2                	mov    %eax,%edx
  80061e:	8b 45 d0             	mov    -0x30(%ebp),%eax
  800621:	39 c2                	cmp    %eax,%edx
  800623:	74 17                	je     80063c <_main+0x604>
  800625:	83 ec 04             	sub    $0x4,%esp
  800628:	68 04 3a 80 00       	push   $0x803a04
  80062d:	68 85 00 00 00       	push   $0x85
  800632:	68 1c 39 80 00       	push   $0x80391c
  800637:	e8 79 04 00 00       	call   800ab5 <_panic>
		byteArr[lastIndices[2]] = 10;
  80063c:	8b 85 38 ff ff ff    	mov    -0xc8(%ebp),%eax
  800642:	89 c2                	mov    %eax,%edx
  800644:	8b 45 d0             	mov    -0x30(%ebp),%eax
  800647:	01 d0                	add    %edx,%eax
  800649:	c6 00 0a             	movb   $0xa,(%eax)
		if (sys_rcr2() != (uint32)&(byteArr[lastIndices[2]])) panic("Free: successful access to freed space!! it should not be succeeded");
  80064c:	e8 35 1e 00 00       	call   802486 <sys_rcr2>
  800651:	8b 95 38 ff ff ff    	mov    -0xc8(%ebp),%edx
  800657:	89 d1                	mov    %edx,%ecx
  800659:	8b 55 d0             	mov    -0x30(%ebp),%edx
  80065c:	01 ca                	add    %ecx,%edx
  80065e:	39 d0                	cmp    %edx,%eax
  800660:	74 17                	je     800679 <_main+0x641>
  800662:	83 ec 04             	sub    $0x4,%esp
  800665:	68 04 3a 80 00       	push   $0x803a04
  80066a:	68 87 00 00 00       	push   $0x87
  80066f:	68 1c 39 80 00       	push   $0x80391c
  800674:	e8 3c 04 00 00       	call   800ab5 <_panic>

		freeFrames = sys_calculate_free_frames() ;
  800679:	e8 89 1a 00 00       	call   802107 <sys_calculate_free_frames>
  80067e:	89 45 d8             	mov    %eax,-0x28(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  800681:	e8 21 1b 00 00       	call   8021a7 <sys_pf_calculate_allocated_pages>
  800686:	89 45 d4             	mov    %eax,-0x2c(%ebp)
		free(ptr_allocations[3]);
  800689:	8b 45 8c             	mov    -0x74(%ebp),%eax
  80068c:	83 ec 0c             	sub    $0xc,%esp
  80068f:	50                   	push   %eax
  800690:	e8 e7 16 00 00       	call   801d7c <free>
  800695:	83 c4 10             	add    $0x10,%esp
		if ((usedDiskPages - sys_pf_calculate_allocated_pages()) != 0) panic("Wrong free: Extra or less pages are removed from PageFile");
  800698:	e8 0a 1b 00 00       	call   8021a7 <sys_pf_calculate_allocated_pages>
  80069d:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  8006a0:	74 17                	je     8006b9 <_main+0x681>
  8006a2:	83 ec 04             	sub    $0x4,%esp
  8006a5:	68 c8 39 80 00       	push   $0x8039c8
  8006aa:	68 8c 00 00 00       	push   $0x8c
  8006af:	68 1c 39 80 00       	push   $0x80391c
  8006b4:	e8 fc 03 00 00       	call   800ab5 <_panic>
		//if ((sys_calculate_free_frames() - freeFrames) != 1 ) panic("Wrong free: ");
		byteArr = (char *) ptr_allocations[3];
  8006b9:	8b 45 8c             	mov    -0x74(%ebp),%eax
  8006bc:	89 45 d0             	mov    %eax,-0x30(%ebp)
		byteArr[0] = 10;
  8006bf:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8006c2:	c6 00 0a             	movb   $0xa,(%eax)
		if (sys_rcr2() != (uint32)&(byteArr[0])) panic("Free: successful access to freed space!! it should not be succeeded");
  8006c5:	e8 bc 1d 00 00       	call   802486 <sys_rcr2>
  8006ca:	89 c2                	mov    %eax,%edx
  8006cc:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8006cf:	39 c2                	cmp    %eax,%edx
  8006d1:	74 17                	je     8006ea <_main+0x6b2>
  8006d3:	83 ec 04             	sub    $0x4,%esp
  8006d6:	68 04 3a 80 00       	push   $0x803a04
  8006db:	68 90 00 00 00       	push   $0x90
  8006e0:	68 1c 39 80 00       	push   $0x80391c
  8006e5:	e8 cb 03 00 00       	call   800ab5 <_panic>
		byteArr[lastIndices[3]] = 10;
  8006ea:	8b 85 3c ff ff ff    	mov    -0xc4(%ebp),%eax
  8006f0:	89 c2                	mov    %eax,%edx
  8006f2:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8006f5:	01 d0                	add    %edx,%eax
  8006f7:	c6 00 0a             	movb   $0xa,(%eax)
		if (sys_rcr2() != (uint32)&(byteArr[lastIndices[3]])) panic("Free: successful access to freed space!! it should not be succeeded");
  8006fa:	e8 87 1d 00 00       	call   802486 <sys_rcr2>
  8006ff:	8b 95 3c ff ff ff    	mov    -0xc4(%ebp),%edx
  800705:	89 d1                	mov    %edx,%ecx
  800707:	8b 55 d0             	mov    -0x30(%ebp),%edx
  80070a:	01 ca                	add    %ecx,%edx
  80070c:	39 d0                	cmp    %edx,%eax
  80070e:	74 17                	je     800727 <_main+0x6ef>
  800710:	83 ec 04             	sub    $0x4,%esp
  800713:	68 04 3a 80 00       	push   $0x803a04
  800718:	68 92 00 00 00       	push   $0x92
  80071d:	68 1c 39 80 00       	push   $0x80391c
  800722:	e8 8e 03 00 00       	call   800ab5 <_panic>

		freeFrames = sys_calculate_free_frames() ;
  800727:	e8 db 19 00 00       	call   802107 <sys_calculate_free_frames>
  80072c:	89 45 d8             	mov    %eax,-0x28(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  80072f:	e8 73 1a 00 00       	call   8021a7 <sys_pf_calculate_allocated_pages>
  800734:	89 45 d4             	mov    %eax,-0x2c(%ebp)
		free(ptr_allocations[4]);
  800737:	8b 45 90             	mov    -0x70(%ebp),%eax
  80073a:	83 ec 0c             	sub    $0xc,%esp
  80073d:	50                   	push   %eax
  80073e:	e8 39 16 00 00       	call   801d7c <free>
  800743:	83 c4 10             	add    $0x10,%esp
		if ((usedDiskPages - sys_pf_calculate_allocated_pages()) != 0) panic("Wrong free: Extra or less pages are removed from PageFile");
  800746:	e8 5c 1a 00 00       	call   8021a7 <sys_pf_calculate_allocated_pages>
  80074b:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  80074e:	74 17                	je     800767 <_main+0x72f>
  800750:	83 ec 04             	sub    $0x4,%esp
  800753:	68 c8 39 80 00       	push   $0x8039c8
  800758:	68 97 00 00 00       	push   $0x97
  80075d:	68 1c 39 80 00       	push   $0x80391c
  800762:	e8 4e 03 00 00       	call   800ab5 <_panic>
		//if ((sys_calculate_free_frames() - freeFrames) != 2 ) panic("Wrong free: ");
		byteArr = (char *) ptr_allocations[4];
  800767:	8b 45 90             	mov    -0x70(%ebp),%eax
  80076a:	89 45 d0             	mov    %eax,-0x30(%ebp)
		byteArr[0] = 10;
  80076d:	8b 45 d0             	mov    -0x30(%ebp),%eax
  800770:	c6 00 0a             	movb   $0xa,(%eax)
		if (sys_rcr2() != (uint32)&(byteArr[0])) panic("Free: successful access to freed space!! it should not be succeeded");
  800773:	e8 0e 1d 00 00       	call   802486 <sys_rcr2>
  800778:	89 c2                	mov    %eax,%edx
  80077a:	8b 45 d0             	mov    -0x30(%ebp),%eax
  80077d:	39 c2                	cmp    %eax,%edx
  80077f:	74 17                	je     800798 <_main+0x760>
  800781:	83 ec 04             	sub    $0x4,%esp
  800784:	68 04 3a 80 00       	push   $0x803a04
  800789:	68 9b 00 00 00       	push   $0x9b
  80078e:	68 1c 39 80 00       	push   $0x80391c
  800793:	e8 1d 03 00 00       	call   800ab5 <_panic>
		byteArr[lastIndices[4]] = 10;
  800798:	8b 85 40 ff ff ff    	mov    -0xc0(%ebp),%eax
  80079e:	89 c2                	mov    %eax,%edx
  8007a0:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8007a3:	01 d0                	add    %edx,%eax
  8007a5:	c6 00 0a             	movb   $0xa,(%eax)
		if (sys_rcr2() != (uint32)&(byteArr[lastIndices[4]])) panic("Free: successful access to freed space!! it should not be succeeded");
  8007a8:	e8 d9 1c 00 00       	call   802486 <sys_rcr2>
  8007ad:	8b 95 40 ff ff ff    	mov    -0xc0(%ebp),%edx
  8007b3:	89 d1                	mov    %edx,%ecx
  8007b5:	8b 55 d0             	mov    -0x30(%ebp),%edx
  8007b8:	01 ca                	add    %ecx,%edx
  8007ba:	39 d0                	cmp    %edx,%eax
  8007bc:	74 17                	je     8007d5 <_main+0x79d>
  8007be:	83 ec 04             	sub    $0x4,%esp
  8007c1:	68 04 3a 80 00       	push   $0x803a04
  8007c6:	68 9d 00 00 00       	push   $0x9d
  8007cb:	68 1c 39 80 00       	push   $0x80391c
  8007d0:	e8 e0 02 00 00       	call   800ab5 <_panic>

		freeFrames = sys_calculate_free_frames() ;
  8007d5:	e8 2d 19 00 00       	call   802107 <sys_calculate_free_frames>
  8007da:	89 45 d8             	mov    %eax,-0x28(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  8007dd:	e8 c5 19 00 00       	call   8021a7 <sys_pf_calculate_allocated_pages>
  8007e2:	89 45 d4             	mov    %eax,-0x2c(%ebp)
		free(ptr_allocations[5]);
  8007e5:	8b 45 94             	mov    -0x6c(%ebp),%eax
  8007e8:	83 ec 0c             	sub    $0xc,%esp
  8007eb:	50                   	push   %eax
  8007ec:	e8 8b 15 00 00       	call   801d7c <free>
  8007f1:	83 c4 10             	add    $0x10,%esp
		if ((usedDiskPages - sys_pf_calculate_allocated_pages()) != 0 ) panic("Wrong free: Extra or less pages are removed from PageFile");
  8007f4:	e8 ae 19 00 00       	call   8021a7 <sys_pf_calculate_allocated_pages>
  8007f9:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  8007fc:	74 17                	je     800815 <_main+0x7dd>
  8007fe:	83 ec 04             	sub    $0x4,%esp
  800801:	68 c8 39 80 00       	push   $0x8039c8
  800806:	68 a2 00 00 00       	push   $0xa2
  80080b:	68 1c 39 80 00       	push   $0x80391c
  800810:	e8 a0 02 00 00       	call   800ab5 <_panic>
		//if ((sys_calculate_free_frames() - freeFrames) != 3*Mega/4096 ) panic("Wrong free: ");
		byteArr = (char *) ptr_allocations[5];
  800815:	8b 45 94             	mov    -0x6c(%ebp),%eax
  800818:	89 45 d0             	mov    %eax,-0x30(%ebp)
		byteArr[0] = 10;
  80081b:	8b 45 d0             	mov    -0x30(%ebp),%eax
  80081e:	c6 00 0a             	movb   $0xa,(%eax)
		if (sys_rcr2() != (uint32)&(byteArr[0])) panic("Free: successful access to freed space!! it should not be succeeded");
  800821:	e8 60 1c 00 00       	call   802486 <sys_rcr2>
  800826:	89 c2                	mov    %eax,%edx
  800828:	8b 45 d0             	mov    -0x30(%ebp),%eax
  80082b:	39 c2                	cmp    %eax,%edx
  80082d:	74 17                	je     800846 <_main+0x80e>
  80082f:	83 ec 04             	sub    $0x4,%esp
  800832:	68 04 3a 80 00       	push   $0x803a04
  800837:	68 a6 00 00 00       	push   $0xa6
  80083c:	68 1c 39 80 00       	push   $0x80391c
  800841:	e8 6f 02 00 00       	call   800ab5 <_panic>
		byteArr[lastIndices[5]] = 10;
  800846:	8b 85 44 ff ff ff    	mov    -0xbc(%ebp),%eax
  80084c:	89 c2                	mov    %eax,%edx
  80084e:	8b 45 d0             	mov    -0x30(%ebp),%eax
  800851:	01 d0                	add    %edx,%eax
  800853:	c6 00 0a             	movb   $0xa,(%eax)
		if (sys_rcr2() != (uint32)&(byteArr[lastIndices[5]])) panic("Free: successful access to freed space!! it should not be succeeded");
  800856:	e8 2b 1c 00 00       	call   802486 <sys_rcr2>
  80085b:	8b 95 44 ff ff ff    	mov    -0xbc(%ebp),%edx
  800861:	89 d1                	mov    %edx,%ecx
  800863:	8b 55 d0             	mov    -0x30(%ebp),%edx
  800866:	01 ca                	add    %ecx,%edx
  800868:	39 d0                	cmp    %edx,%eax
  80086a:	74 17                	je     800883 <_main+0x84b>
  80086c:	83 ec 04             	sub    $0x4,%esp
  80086f:	68 04 3a 80 00       	push   $0x803a04
  800874:	68 a8 00 00 00       	push   $0xa8
  800879:	68 1c 39 80 00       	push   $0x80391c
  80087e:	e8 32 02 00 00       	call   800ab5 <_panic>

		freeFrames = sys_calculate_free_frames() ;
  800883:	e8 7f 18 00 00       	call   802107 <sys_calculate_free_frames>
  800888:	89 45 d8             	mov    %eax,-0x28(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  80088b:	e8 17 19 00 00       	call   8021a7 <sys_pf_calculate_allocated_pages>
  800890:	89 45 d4             	mov    %eax,-0x2c(%ebp)
		free(ptr_allocations[6]);
  800893:	8b 45 98             	mov    -0x68(%ebp),%eax
  800896:	83 ec 0c             	sub    $0xc,%esp
  800899:	50                   	push   %eax
  80089a:	e8 dd 14 00 00       	call   801d7c <free>
  80089f:	83 c4 10             	add    $0x10,%esp
		if ((usedDiskPages - sys_pf_calculate_allocated_pages()) != 0) panic("Wrong free: Extra or less pages are removed from PageFile");
  8008a2:	e8 00 19 00 00       	call   8021a7 <sys_pf_calculate_allocated_pages>
  8008a7:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  8008aa:	74 17                	je     8008c3 <_main+0x88b>
  8008ac:	83 ec 04             	sub    $0x4,%esp
  8008af:	68 c8 39 80 00       	push   $0x8039c8
  8008b4:	68 ad 00 00 00       	push   $0xad
  8008b9:	68 1c 39 80 00       	push   $0x80391c
  8008be:	e8 f2 01 00 00       	call   800ab5 <_panic>
		//if ((sys_calculate_free_frames() - freeFrames) != 512 + 2) panic("Wrong free: ");
		byteArr = (char *) ptr_allocations[6];
  8008c3:	8b 45 98             	mov    -0x68(%ebp),%eax
  8008c6:	89 45 d0             	mov    %eax,-0x30(%ebp)
		byteArr[0] = 10;
  8008c9:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8008cc:	c6 00 0a             	movb   $0xa,(%eax)
		if (sys_rcr2() != (uint32)&(byteArr[0])) panic("Free: successful access to freed space!! it should not be succeeded");
  8008cf:	e8 b2 1b 00 00       	call   802486 <sys_rcr2>
  8008d4:	89 c2                	mov    %eax,%edx
  8008d6:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8008d9:	39 c2                	cmp    %eax,%edx
  8008db:	74 17                	je     8008f4 <_main+0x8bc>
  8008dd:	83 ec 04             	sub    $0x4,%esp
  8008e0:	68 04 3a 80 00       	push   $0x803a04
  8008e5:	68 b1 00 00 00       	push   $0xb1
  8008ea:	68 1c 39 80 00       	push   $0x80391c
  8008ef:	e8 c1 01 00 00       	call   800ab5 <_panic>
		byteArr[lastIndices[6]] = 10;
  8008f4:	8b 85 48 ff ff ff    	mov    -0xb8(%ebp),%eax
  8008fa:	89 c2                	mov    %eax,%edx
  8008fc:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8008ff:	01 d0                	add    %edx,%eax
  800901:	c6 00 0a             	movb   $0xa,(%eax)
		if (sys_rcr2() != (uint32)&(byteArr[lastIndices[6]])) panic("Free: successful access to freed space!! it should not be succeeded");
  800904:	e8 7d 1b 00 00       	call   802486 <sys_rcr2>
  800909:	8b 95 48 ff ff ff    	mov    -0xb8(%ebp),%edx
  80090f:	89 d1                	mov    %edx,%ecx
  800911:	8b 55 d0             	mov    -0x30(%ebp),%edx
  800914:	01 ca                	add    %ecx,%edx
  800916:	39 d0                	cmp    %edx,%eax
  800918:	74 17                	je     800931 <_main+0x8f9>
  80091a:	83 ec 04             	sub    $0x4,%esp
  80091d:	68 04 3a 80 00       	push   $0x803a04
  800922:	68 b3 00 00 00       	push   $0xb3
  800927:	68 1c 39 80 00       	push   $0x80391c
  80092c:	e8 84 01 00 00       	call   800ab5 <_panic>

		if(start_freeFrames != (sys_calculate_free_frames()) ) {panic("Wrong free: not all pages removed correctly at end");}
  800931:	e8 d1 17 00 00       	call   802107 <sys_calculate_free_frames>
  800936:	89 c2                	mov    %eax,%edx
  800938:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80093b:	39 c2                	cmp    %eax,%edx
  80093d:	74 17                	je     800956 <_main+0x91e>
  80093f:	83 ec 04             	sub    $0x4,%esp
  800942:	68 48 3a 80 00       	push   $0x803a48
  800947:	68 b5 00 00 00       	push   $0xb5
  80094c:	68 1c 39 80 00       	push   $0x80391c
  800951:	e8 5f 01 00 00       	call   800ab5 <_panic>
	}

	//set it to 0 again to cancel the bypassing option
	sys_bypassPageFault(0);
  800956:	83 ec 0c             	sub    $0xc,%esp
  800959:	6a 00                	push   $0x0
  80095b:	e8 3f 1b 00 00       	call   80249f <sys_bypassPageFault>
  800960:	83 c4 10             	add    $0x10,%esp

	cprintf("Congratulations!! test free [2] completed successfully.\n");
  800963:	83 ec 0c             	sub    $0xc,%esp
  800966:	68 7c 3a 80 00       	push   $0x803a7c
  80096b:	e8 f9 03 00 00       	call   800d69 <cprintf>
  800970:	83 c4 10             	add    $0x10,%esp

	return;
  800973:	90                   	nop
}
  800974:	8b 7d fc             	mov    -0x4(%ebp),%edi
  800977:	c9                   	leave  
  800978:	c3                   	ret    

00800979 <libmain>:
volatile struct Env *myEnv = NULL;
volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";

void
libmain(int argc, char **argv)
{
  800979:	55                   	push   %ebp
  80097a:	89 e5                	mov    %esp,%ebp
  80097c:	83 ec 18             	sub    $0x18,%esp
	int envIndex = sys_getenvindex();
  80097f:	e8 63 1a 00 00       	call   8023e7 <sys_getenvindex>
  800984:	89 45 f4             	mov    %eax,-0xc(%ebp)
	myEnv = &(envs[envIndex]);
  800987:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80098a:	89 d0                	mov    %edx,%eax
  80098c:	c1 e0 03             	shl    $0x3,%eax
  80098f:	01 d0                	add    %edx,%eax
  800991:	01 c0                	add    %eax,%eax
  800993:	01 d0                	add    %edx,%eax
  800995:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80099c:	01 d0                	add    %edx,%eax
  80099e:	c1 e0 04             	shl    $0x4,%eax
  8009a1:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8009a6:	a3 20 50 80 00       	mov    %eax,0x805020

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  8009ab:	a1 20 50 80 00       	mov    0x805020,%eax
  8009b0:	8a 80 5c 05 00 00    	mov    0x55c(%eax),%al
  8009b6:	84 c0                	test   %al,%al
  8009b8:	74 0f                	je     8009c9 <libmain+0x50>
		binaryname = myEnv->prog_name;
  8009ba:	a1 20 50 80 00       	mov    0x805020,%eax
  8009bf:	05 5c 05 00 00       	add    $0x55c,%eax
  8009c4:	a3 00 50 80 00       	mov    %eax,0x805000

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8009c9:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8009cd:	7e 0a                	jle    8009d9 <libmain+0x60>
		binaryname = argv[0];
  8009cf:	8b 45 0c             	mov    0xc(%ebp),%eax
  8009d2:	8b 00                	mov    (%eax),%eax
  8009d4:	a3 00 50 80 00       	mov    %eax,0x805000

	// call user main routine
	_main(argc, argv);
  8009d9:	83 ec 08             	sub    $0x8,%esp
  8009dc:	ff 75 0c             	pushl  0xc(%ebp)
  8009df:	ff 75 08             	pushl  0x8(%ebp)
  8009e2:	e8 51 f6 ff ff       	call   800038 <_main>
  8009e7:	83 c4 10             	add    $0x10,%esp



	sys_disable_interrupt();
  8009ea:	e8 05 18 00 00       	call   8021f4 <sys_disable_interrupt>
	cprintf("**************************************\n");
  8009ef:	83 ec 0c             	sub    $0xc,%esp
  8009f2:	68 d0 3a 80 00       	push   $0x803ad0
  8009f7:	e8 6d 03 00 00       	call   800d69 <cprintf>
  8009fc:	83 c4 10             	add    $0x10,%esp
	cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  8009ff:	a1 20 50 80 00       	mov    0x805020,%eax
  800a04:	8b 90 44 05 00 00    	mov    0x544(%eax),%edx
  800a0a:	a1 20 50 80 00       	mov    0x805020,%eax
  800a0f:	8b 80 34 05 00 00    	mov    0x534(%eax),%eax
  800a15:	83 ec 04             	sub    $0x4,%esp
  800a18:	52                   	push   %edx
  800a19:	50                   	push   %eax
  800a1a:	68 f8 3a 80 00       	push   $0x803af8
  800a1f:	e8 45 03 00 00       	call   800d69 <cprintf>
  800a24:	83 c4 10             	add    $0x10,%esp
	cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  800a27:	a1 20 50 80 00       	mov    0x805020,%eax
  800a2c:	8b 88 54 05 00 00    	mov    0x554(%eax),%ecx
  800a32:	a1 20 50 80 00       	mov    0x805020,%eax
  800a37:	8b 90 50 05 00 00    	mov    0x550(%eax),%edx
  800a3d:	a1 20 50 80 00       	mov    0x805020,%eax
  800a42:	8b 80 4c 05 00 00    	mov    0x54c(%eax),%eax
  800a48:	51                   	push   %ecx
  800a49:	52                   	push   %edx
  800a4a:	50                   	push   %eax
  800a4b:	68 20 3b 80 00       	push   $0x803b20
  800a50:	e8 14 03 00 00       	call   800d69 <cprintf>
  800a55:	83 c4 10             	add    $0x10,%esp
	//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
	cprintf("Num of clocks = %d\n", myEnv->nClocks);
  800a58:	a1 20 50 80 00       	mov    0x805020,%eax
  800a5d:	8b 80 a4 05 00 00    	mov    0x5a4(%eax),%eax
  800a63:	83 ec 08             	sub    $0x8,%esp
  800a66:	50                   	push   %eax
  800a67:	68 78 3b 80 00       	push   $0x803b78
  800a6c:	e8 f8 02 00 00       	call   800d69 <cprintf>
  800a71:	83 c4 10             	add    $0x10,%esp
	cprintf("**************************************\n");
  800a74:	83 ec 0c             	sub    $0xc,%esp
  800a77:	68 d0 3a 80 00       	push   $0x803ad0
  800a7c:	e8 e8 02 00 00       	call   800d69 <cprintf>
  800a81:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  800a84:	e8 85 17 00 00       	call   80220e <sys_enable_interrupt>

	// exit gracefully
	exit();
  800a89:	e8 19 00 00 00       	call   800aa7 <exit>
}
  800a8e:	90                   	nop
  800a8f:	c9                   	leave  
  800a90:	c3                   	ret    

00800a91 <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  800a91:	55                   	push   %ebp
  800a92:	89 e5                	mov    %esp,%ebp
  800a94:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  800a97:	83 ec 0c             	sub    $0xc,%esp
  800a9a:	6a 00                	push   $0x0
  800a9c:	e8 12 19 00 00       	call   8023b3 <sys_destroy_env>
  800aa1:	83 c4 10             	add    $0x10,%esp
}
  800aa4:	90                   	nop
  800aa5:	c9                   	leave  
  800aa6:	c3                   	ret    

00800aa7 <exit>:

void
exit(void)
{
  800aa7:	55                   	push   %ebp
  800aa8:	89 e5                	mov    %esp,%ebp
  800aaa:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  800aad:	e8 67 19 00 00       	call   802419 <sys_exit_env>
}
  800ab2:	90                   	nop
  800ab3:	c9                   	leave  
  800ab4:	c3                   	ret    

00800ab5 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  800ab5:	55                   	push   %ebp
  800ab6:	89 e5                	mov    %esp,%ebp
  800ab8:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  800abb:	8d 45 10             	lea    0x10(%ebp),%eax
  800abe:	83 c0 04             	add    $0x4,%eax
  800ac1:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  800ac4:	a1 5c 51 80 00       	mov    0x80515c,%eax
  800ac9:	85 c0                	test   %eax,%eax
  800acb:	74 16                	je     800ae3 <_panic+0x2e>
		cprintf("%s: ", argv0);
  800acd:	a1 5c 51 80 00       	mov    0x80515c,%eax
  800ad2:	83 ec 08             	sub    $0x8,%esp
  800ad5:	50                   	push   %eax
  800ad6:	68 8c 3b 80 00       	push   $0x803b8c
  800adb:	e8 89 02 00 00       	call   800d69 <cprintf>
  800ae0:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  800ae3:	a1 00 50 80 00       	mov    0x805000,%eax
  800ae8:	ff 75 0c             	pushl  0xc(%ebp)
  800aeb:	ff 75 08             	pushl  0x8(%ebp)
  800aee:	50                   	push   %eax
  800aef:	68 91 3b 80 00       	push   $0x803b91
  800af4:	e8 70 02 00 00       	call   800d69 <cprintf>
  800af9:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  800afc:	8b 45 10             	mov    0x10(%ebp),%eax
  800aff:	83 ec 08             	sub    $0x8,%esp
  800b02:	ff 75 f4             	pushl  -0xc(%ebp)
  800b05:	50                   	push   %eax
  800b06:	e8 f3 01 00 00       	call   800cfe <vcprintf>
  800b0b:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  800b0e:	83 ec 08             	sub    $0x8,%esp
  800b11:	6a 00                	push   $0x0
  800b13:	68 ad 3b 80 00       	push   $0x803bad
  800b18:	e8 e1 01 00 00       	call   800cfe <vcprintf>
  800b1d:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  800b20:	e8 82 ff ff ff       	call   800aa7 <exit>

	// should not return here
	while (1) ;
  800b25:	eb fe                	jmp    800b25 <_panic+0x70>

00800b27 <CheckWSWithoutLastIndex>:
}

void CheckWSWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  800b27:	55                   	push   %ebp
  800b28:	89 e5                	mov    %esp,%ebp
  800b2a:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  800b2d:	a1 20 50 80 00       	mov    0x805020,%eax
  800b32:	8b 50 74             	mov    0x74(%eax),%edx
  800b35:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b38:	39 c2                	cmp    %eax,%edx
  800b3a:	74 14                	je     800b50 <CheckWSWithoutLastIndex+0x29>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  800b3c:	83 ec 04             	sub    $0x4,%esp
  800b3f:	68 b0 3b 80 00       	push   $0x803bb0
  800b44:	6a 26                	push   $0x26
  800b46:	68 fc 3b 80 00       	push   $0x803bfc
  800b4b:	e8 65 ff ff ff       	call   800ab5 <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  800b50:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  800b57:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800b5e:	e9 c2 00 00 00       	jmp    800c25 <CheckWSWithoutLastIndex+0xfe>
		if (expectedPages[e] == 0) {
  800b63:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800b66:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800b6d:	8b 45 08             	mov    0x8(%ebp),%eax
  800b70:	01 d0                	add    %edx,%eax
  800b72:	8b 00                	mov    (%eax),%eax
  800b74:	85 c0                	test   %eax,%eax
  800b76:	75 08                	jne    800b80 <CheckWSWithoutLastIndex+0x59>
			expectedNumOfEmptyLocs++;
  800b78:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  800b7b:	e9 a2 00 00 00       	jmp    800c22 <CheckWSWithoutLastIndex+0xfb>
		}
		int found = 0;
  800b80:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800b87:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  800b8e:	eb 69                	jmp    800bf9 <CheckWSWithoutLastIndex+0xd2>
			if (myEnv->__uptr_pws[w].empty == 0) {
  800b90:	a1 20 50 80 00       	mov    0x805020,%eax
  800b95:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  800b9b:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800b9e:	89 d0                	mov    %edx,%eax
  800ba0:	01 c0                	add    %eax,%eax
  800ba2:	01 d0                	add    %edx,%eax
  800ba4:	c1 e0 03             	shl    $0x3,%eax
  800ba7:	01 c8                	add    %ecx,%eax
  800ba9:	8a 40 04             	mov    0x4(%eax),%al
  800bac:	84 c0                	test   %al,%al
  800bae:	75 46                	jne    800bf6 <CheckWSWithoutLastIndex+0xcf>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  800bb0:	a1 20 50 80 00       	mov    0x805020,%eax
  800bb5:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  800bbb:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800bbe:	89 d0                	mov    %edx,%eax
  800bc0:	01 c0                	add    %eax,%eax
  800bc2:	01 d0                	add    %edx,%eax
  800bc4:	c1 e0 03             	shl    $0x3,%eax
  800bc7:	01 c8                	add    %ecx,%eax
  800bc9:	8b 00                	mov    (%eax),%eax
  800bcb:	89 45 dc             	mov    %eax,-0x24(%ebp)
  800bce:	8b 45 dc             	mov    -0x24(%ebp),%eax
  800bd1:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800bd6:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  800bd8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800bdb:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  800be2:	8b 45 08             	mov    0x8(%ebp),%eax
  800be5:	01 c8                	add    %ecx,%eax
  800be7:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  800be9:	39 c2                	cmp    %eax,%edx
  800beb:	75 09                	jne    800bf6 <CheckWSWithoutLastIndex+0xcf>
						== expectedPages[e]) {
					found = 1;
  800bed:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  800bf4:	eb 12                	jmp    800c08 <CheckWSWithoutLastIndex+0xe1>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800bf6:	ff 45 e8             	incl   -0x18(%ebp)
  800bf9:	a1 20 50 80 00       	mov    0x805020,%eax
  800bfe:	8b 50 74             	mov    0x74(%eax),%edx
  800c01:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800c04:	39 c2                	cmp    %eax,%edx
  800c06:	77 88                	ja     800b90 <CheckWSWithoutLastIndex+0x69>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  800c08:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  800c0c:	75 14                	jne    800c22 <CheckWSWithoutLastIndex+0xfb>
			panic(
  800c0e:	83 ec 04             	sub    $0x4,%esp
  800c11:	68 08 3c 80 00       	push   $0x803c08
  800c16:	6a 3a                	push   $0x3a
  800c18:	68 fc 3b 80 00       	push   $0x803bfc
  800c1d:	e8 93 fe ff ff       	call   800ab5 <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  800c22:	ff 45 f0             	incl   -0x10(%ebp)
  800c25:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800c28:	3b 45 0c             	cmp    0xc(%ebp),%eax
  800c2b:	0f 8c 32 ff ff ff    	jl     800b63 <CheckWSWithoutLastIndex+0x3c>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  800c31:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800c38:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  800c3f:	eb 26                	jmp    800c67 <CheckWSWithoutLastIndex+0x140>
		if (myEnv->__uptr_pws[w].empty == 1) {
  800c41:	a1 20 50 80 00       	mov    0x805020,%eax
  800c46:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  800c4c:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800c4f:	89 d0                	mov    %edx,%eax
  800c51:	01 c0                	add    %eax,%eax
  800c53:	01 d0                	add    %edx,%eax
  800c55:	c1 e0 03             	shl    $0x3,%eax
  800c58:	01 c8                	add    %ecx,%eax
  800c5a:	8a 40 04             	mov    0x4(%eax),%al
  800c5d:	3c 01                	cmp    $0x1,%al
  800c5f:	75 03                	jne    800c64 <CheckWSWithoutLastIndex+0x13d>
			actualNumOfEmptyLocs++;
  800c61:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800c64:	ff 45 e0             	incl   -0x20(%ebp)
  800c67:	a1 20 50 80 00       	mov    0x805020,%eax
  800c6c:	8b 50 74             	mov    0x74(%eax),%edx
  800c6f:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800c72:	39 c2                	cmp    %eax,%edx
  800c74:	77 cb                	ja     800c41 <CheckWSWithoutLastIndex+0x11a>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  800c76:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800c79:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  800c7c:	74 14                	je     800c92 <CheckWSWithoutLastIndex+0x16b>
		panic(
  800c7e:	83 ec 04             	sub    $0x4,%esp
  800c81:	68 5c 3c 80 00       	push   $0x803c5c
  800c86:	6a 44                	push   $0x44
  800c88:	68 fc 3b 80 00       	push   $0x803bfc
  800c8d:	e8 23 fe ff ff       	call   800ab5 <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  800c92:	90                   	nop
  800c93:	c9                   	leave  
  800c94:	c3                   	ret    

00800c95 <putch>:
};

//2017:
uint8 printProgName = 0;

static void putch(int ch, struct printbuf *b) {
  800c95:	55                   	push   %ebp
  800c96:	89 e5                	mov    %esp,%ebp
  800c98:	83 ec 08             	sub    $0x8,%esp
	b->buf[b->idx++] = ch;
  800c9b:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c9e:	8b 00                	mov    (%eax),%eax
  800ca0:	8d 48 01             	lea    0x1(%eax),%ecx
  800ca3:	8b 55 0c             	mov    0xc(%ebp),%edx
  800ca6:	89 0a                	mov    %ecx,(%edx)
  800ca8:	8b 55 08             	mov    0x8(%ebp),%edx
  800cab:	88 d1                	mov    %dl,%cl
  800cad:	8b 55 0c             	mov    0xc(%ebp),%edx
  800cb0:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  800cb4:	8b 45 0c             	mov    0xc(%ebp),%eax
  800cb7:	8b 00                	mov    (%eax),%eax
  800cb9:	3d ff 00 00 00       	cmp    $0xff,%eax
  800cbe:	75 2c                	jne    800cec <putch+0x57>
		sys_cputs(b->buf, b->idx, printProgName);
  800cc0:	a0 24 50 80 00       	mov    0x805024,%al
  800cc5:	0f b6 c0             	movzbl %al,%eax
  800cc8:	8b 55 0c             	mov    0xc(%ebp),%edx
  800ccb:	8b 12                	mov    (%edx),%edx
  800ccd:	89 d1                	mov    %edx,%ecx
  800ccf:	8b 55 0c             	mov    0xc(%ebp),%edx
  800cd2:	83 c2 08             	add    $0x8,%edx
  800cd5:	83 ec 04             	sub    $0x4,%esp
  800cd8:	50                   	push   %eax
  800cd9:	51                   	push   %ecx
  800cda:	52                   	push   %edx
  800cdb:	e8 66 13 00 00       	call   802046 <sys_cputs>
  800ce0:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  800ce3:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ce6:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  800cec:	8b 45 0c             	mov    0xc(%ebp),%eax
  800cef:	8b 40 04             	mov    0x4(%eax),%eax
  800cf2:	8d 50 01             	lea    0x1(%eax),%edx
  800cf5:	8b 45 0c             	mov    0xc(%ebp),%eax
  800cf8:	89 50 04             	mov    %edx,0x4(%eax)
}
  800cfb:	90                   	nop
  800cfc:	c9                   	leave  
  800cfd:	c3                   	ret    

00800cfe <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  800cfe:	55                   	push   %ebp
  800cff:	89 e5                	mov    %esp,%ebp
  800d01:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  800d07:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800d0e:	00 00 00 
	b.cnt = 0;
  800d11:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800d18:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  800d1b:	ff 75 0c             	pushl  0xc(%ebp)
  800d1e:	ff 75 08             	pushl  0x8(%ebp)
  800d21:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800d27:	50                   	push   %eax
  800d28:	68 95 0c 80 00       	push   $0x800c95
  800d2d:	e8 11 02 00 00       	call   800f43 <vprintfmt>
  800d32:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName);
  800d35:	a0 24 50 80 00       	mov    0x805024,%al
  800d3a:	0f b6 c0             	movzbl %al,%eax
  800d3d:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  800d43:	83 ec 04             	sub    $0x4,%esp
  800d46:	50                   	push   %eax
  800d47:	52                   	push   %edx
  800d48:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800d4e:	83 c0 08             	add    $0x8,%eax
  800d51:	50                   	push   %eax
  800d52:	e8 ef 12 00 00       	call   802046 <sys_cputs>
  800d57:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  800d5a:	c6 05 24 50 80 00 00 	movb   $0x0,0x805024
	return b.cnt;
  800d61:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  800d67:	c9                   	leave  
  800d68:	c3                   	ret    

00800d69 <cprintf>:

int cprintf(const char *fmt, ...) {
  800d69:	55                   	push   %ebp
  800d6a:	89 e5                	mov    %esp,%ebp
  800d6c:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  800d6f:	c6 05 24 50 80 00 01 	movb   $0x1,0x805024
	va_start(ap, fmt);
  800d76:	8d 45 0c             	lea    0xc(%ebp),%eax
  800d79:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800d7c:	8b 45 08             	mov    0x8(%ebp),%eax
  800d7f:	83 ec 08             	sub    $0x8,%esp
  800d82:	ff 75 f4             	pushl  -0xc(%ebp)
  800d85:	50                   	push   %eax
  800d86:	e8 73 ff ff ff       	call   800cfe <vcprintf>
  800d8b:	83 c4 10             	add    $0x10,%esp
  800d8e:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  800d91:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800d94:	c9                   	leave  
  800d95:	c3                   	ret    

00800d96 <atomic_cprintf>:

int atomic_cprintf(const char *fmt, ...) {
  800d96:	55                   	push   %ebp
  800d97:	89 e5                	mov    %esp,%ebp
  800d99:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  800d9c:	e8 53 14 00 00       	call   8021f4 <sys_disable_interrupt>
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  800da1:	8d 45 0c             	lea    0xc(%ebp),%eax
  800da4:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800da7:	8b 45 08             	mov    0x8(%ebp),%eax
  800daa:	83 ec 08             	sub    $0x8,%esp
  800dad:	ff 75 f4             	pushl  -0xc(%ebp)
  800db0:	50                   	push   %eax
  800db1:	e8 48 ff ff ff       	call   800cfe <vcprintf>
  800db6:	83 c4 10             	add    $0x10,%esp
  800db9:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	sys_enable_interrupt();
  800dbc:	e8 4d 14 00 00       	call   80220e <sys_enable_interrupt>
	return cnt;
  800dc1:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800dc4:	c9                   	leave  
  800dc5:	c3                   	ret    

00800dc6 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800dc6:	55                   	push   %ebp
  800dc7:	89 e5                	mov    %esp,%ebp
  800dc9:	53                   	push   %ebx
  800dca:	83 ec 14             	sub    $0x14,%esp
  800dcd:	8b 45 10             	mov    0x10(%ebp),%eax
  800dd0:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800dd3:	8b 45 14             	mov    0x14(%ebp),%eax
  800dd6:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800dd9:	8b 45 18             	mov    0x18(%ebp),%eax
  800ddc:	ba 00 00 00 00       	mov    $0x0,%edx
  800de1:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800de4:	77 55                	ja     800e3b <printnum+0x75>
  800de6:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800de9:	72 05                	jb     800df0 <printnum+0x2a>
  800deb:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800dee:	77 4b                	ja     800e3b <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800df0:	8b 45 1c             	mov    0x1c(%ebp),%eax
  800df3:	8d 58 ff             	lea    -0x1(%eax),%ebx
  800df6:	8b 45 18             	mov    0x18(%ebp),%eax
  800df9:	ba 00 00 00 00       	mov    $0x0,%edx
  800dfe:	52                   	push   %edx
  800dff:	50                   	push   %eax
  800e00:	ff 75 f4             	pushl  -0xc(%ebp)
  800e03:	ff 75 f0             	pushl  -0x10(%ebp)
  800e06:	e8 85 28 00 00       	call   803690 <__udivdi3>
  800e0b:	83 c4 10             	add    $0x10,%esp
  800e0e:	83 ec 04             	sub    $0x4,%esp
  800e11:	ff 75 20             	pushl  0x20(%ebp)
  800e14:	53                   	push   %ebx
  800e15:	ff 75 18             	pushl  0x18(%ebp)
  800e18:	52                   	push   %edx
  800e19:	50                   	push   %eax
  800e1a:	ff 75 0c             	pushl  0xc(%ebp)
  800e1d:	ff 75 08             	pushl  0x8(%ebp)
  800e20:	e8 a1 ff ff ff       	call   800dc6 <printnum>
  800e25:	83 c4 20             	add    $0x20,%esp
  800e28:	eb 1a                	jmp    800e44 <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800e2a:	83 ec 08             	sub    $0x8,%esp
  800e2d:	ff 75 0c             	pushl  0xc(%ebp)
  800e30:	ff 75 20             	pushl  0x20(%ebp)
  800e33:	8b 45 08             	mov    0x8(%ebp),%eax
  800e36:	ff d0                	call   *%eax
  800e38:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800e3b:	ff 4d 1c             	decl   0x1c(%ebp)
  800e3e:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  800e42:	7f e6                	jg     800e2a <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800e44:	8b 4d 18             	mov    0x18(%ebp),%ecx
  800e47:	bb 00 00 00 00       	mov    $0x0,%ebx
  800e4c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800e4f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800e52:	53                   	push   %ebx
  800e53:	51                   	push   %ecx
  800e54:	52                   	push   %edx
  800e55:	50                   	push   %eax
  800e56:	e8 45 29 00 00       	call   8037a0 <__umoddi3>
  800e5b:	83 c4 10             	add    $0x10,%esp
  800e5e:	05 d4 3e 80 00       	add    $0x803ed4,%eax
  800e63:	8a 00                	mov    (%eax),%al
  800e65:	0f be c0             	movsbl %al,%eax
  800e68:	83 ec 08             	sub    $0x8,%esp
  800e6b:	ff 75 0c             	pushl  0xc(%ebp)
  800e6e:	50                   	push   %eax
  800e6f:	8b 45 08             	mov    0x8(%ebp),%eax
  800e72:	ff d0                	call   *%eax
  800e74:	83 c4 10             	add    $0x10,%esp
}
  800e77:	90                   	nop
  800e78:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800e7b:	c9                   	leave  
  800e7c:	c3                   	ret    

00800e7d <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  800e7d:	55                   	push   %ebp
  800e7e:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800e80:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800e84:	7e 1c                	jle    800ea2 <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  800e86:	8b 45 08             	mov    0x8(%ebp),%eax
  800e89:	8b 00                	mov    (%eax),%eax
  800e8b:	8d 50 08             	lea    0x8(%eax),%edx
  800e8e:	8b 45 08             	mov    0x8(%ebp),%eax
  800e91:	89 10                	mov    %edx,(%eax)
  800e93:	8b 45 08             	mov    0x8(%ebp),%eax
  800e96:	8b 00                	mov    (%eax),%eax
  800e98:	83 e8 08             	sub    $0x8,%eax
  800e9b:	8b 50 04             	mov    0x4(%eax),%edx
  800e9e:	8b 00                	mov    (%eax),%eax
  800ea0:	eb 40                	jmp    800ee2 <getuint+0x65>
	else if (lflag)
  800ea2:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800ea6:	74 1e                	je     800ec6 <getuint+0x49>
		return va_arg(*ap, unsigned long);
  800ea8:	8b 45 08             	mov    0x8(%ebp),%eax
  800eab:	8b 00                	mov    (%eax),%eax
  800ead:	8d 50 04             	lea    0x4(%eax),%edx
  800eb0:	8b 45 08             	mov    0x8(%ebp),%eax
  800eb3:	89 10                	mov    %edx,(%eax)
  800eb5:	8b 45 08             	mov    0x8(%ebp),%eax
  800eb8:	8b 00                	mov    (%eax),%eax
  800eba:	83 e8 04             	sub    $0x4,%eax
  800ebd:	8b 00                	mov    (%eax),%eax
  800ebf:	ba 00 00 00 00       	mov    $0x0,%edx
  800ec4:	eb 1c                	jmp    800ee2 <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  800ec6:	8b 45 08             	mov    0x8(%ebp),%eax
  800ec9:	8b 00                	mov    (%eax),%eax
  800ecb:	8d 50 04             	lea    0x4(%eax),%edx
  800ece:	8b 45 08             	mov    0x8(%ebp),%eax
  800ed1:	89 10                	mov    %edx,(%eax)
  800ed3:	8b 45 08             	mov    0x8(%ebp),%eax
  800ed6:	8b 00                	mov    (%eax),%eax
  800ed8:	83 e8 04             	sub    $0x4,%eax
  800edb:	8b 00                	mov    (%eax),%eax
  800edd:	ba 00 00 00 00       	mov    $0x0,%edx
}
  800ee2:	5d                   	pop    %ebp
  800ee3:	c3                   	ret    

00800ee4 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  800ee4:	55                   	push   %ebp
  800ee5:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800ee7:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800eeb:	7e 1c                	jle    800f09 <getint+0x25>
		return va_arg(*ap, long long);
  800eed:	8b 45 08             	mov    0x8(%ebp),%eax
  800ef0:	8b 00                	mov    (%eax),%eax
  800ef2:	8d 50 08             	lea    0x8(%eax),%edx
  800ef5:	8b 45 08             	mov    0x8(%ebp),%eax
  800ef8:	89 10                	mov    %edx,(%eax)
  800efa:	8b 45 08             	mov    0x8(%ebp),%eax
  800efd:	8b 00                	mov    (%eax),%eax
  800eff:	83 e8 08             	sub    $0x8,%eax
  800f02:	8b 50 04             	mov    0x4(%eax),%edx
  800f05:	8b 00                	mov    (%eax),%eax
  800f07:	eb 38                	jmp    800f41 <getint+0x5d>
	else if (lflag)
  800f09:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800f0d:	74 1a                	je     800f29 <getint+0x45>
		return va_arg(*ap, long);
  800f0f:	8b 45 08             	mov    0x8(%ebp),%eax
  800f12:	8b 00                	mov    (%eax),%eax
  800f14:	8d 50 04             	lea    0x4(%eax),%edx
  800f17:	8b 45 08             	mov    0x8(%ebp),%eax
  800f1a:	89 10                	mov    %edx,(%eax)
  800f1c:	8b 45 08             	mov    0x8(%ebp),%eax
  800f1f:	8b 00                	mov    (%eax),%eax
  800f21:	83 e8 04             	sub    $0x4,%eax
  800f24:	8b 00                	mov    (%eax),%eax
  800f26:	99                   	cltd   
  800f27:	eb 18                	jmp    800f41 <getint+0x5d>
	else
		return va_arg(*ap, int);
  800f29:	8b 45 08             	mov    0x8(%ebp),%eax
  800f2c:	8b 00                	mov    (%eax),%eax
  800f2e:	8d 50 04             	lea    0x4(%eax),%edx
  800f31:	8b 45 08             	mov    0x8(%ebp),%eax
  800f34:	89 10                	mov    %edx,(%eax)
  800f36:	8b 45 08             	mov    0x8(%ebp),%eax
  800f39:	8b 00                	mov    (%eax),%eax
  800f3b:	83 e8 04             	sub    $0x4,%eax
  800f3e:	8b 00                	mov    (%eax),%eax
  800f40:	99                   	cltd   
}
  800f41:	5d                   	pop    %ebp
  800f42:	c3                   	ret    

00800f43 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  800f43:	55                   	push   %ebp
  800f44:	89 e5                	mov    %esp,%ebp
  800f46:	56                   	push   %esi
  800f47:	53                   	push   %ebx
  800f48:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800f4b:	eb 17                	jmp    800f64 <vprintfmt+0x21>
			if (ch == '\0')
  800f4d:	85 db                	test   %ebx,%ebx
  800f4f:	0f 84 af 03 00 00    	je     801304 <vprintfmt+0x3c1>
				return;
			putch(ch, putdat);
  800f55:	83 ec 08             	sub    $0x8,%esp
  800f58:	ff 75 0c             	pushl  0xc(%ebp)
  800f5b:	53                   	push   %ebx
  800f5c:	8b 45 08             	mov    0x8(%ebp),%eax
  800f5f:	ff d0                	call   *%eax
  800f61:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800f64:	8b 45 10             	mov    0x10(%ebp),%eax
  800f67:	8d 50 01             	lea    0x1(%eax),%edx
  800f6a:	89 55 10             	mov    %edx,0x10(%ebp)
  800f6d:	8a 00                	mov    (%eax),%al
  800f6f:	0f b6 d8             	movzbl %al,%ebx
  800f72:	83 fb 25             	cmp    $0x25,%ebx
  800f75:	75 d6                	jne    800f4d <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  800f77:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  800f7b:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  800f82:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  800f89:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  800f90:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800f97:	8b 45 10             	mov    0x10(%ebp),%eax
  800f9a:	8d 50 01             	lea    0x1(%eax),%edx
  800f9d:	89 55 10             	mov    %edx,0x10(%ebp)
  800fa0:	8a 00                	mov    (%eax),%al
  800fa2:	0f b6 d8             	movzbl %al,%ebx
  800fa5:	8d 43 dd             	lea    -0x23(%ebx),%eax
  800fa8:	83 f8 55             	cmp    $0x55,%eax
  800fab:	0f 87 2b 03 00 00    	ja     8012dc <vprintfmt+0x399>
  800fb1:	8b 04 85 f8 3e 80 00 	mov    0x803ef8(,%eax,4),%eax
  800fb8:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  800fba:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  800fbe:	eb d7                	jmp    800f97 <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800fc0:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  800fc4:	eb d1                	jmp    800f97 <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800fc6:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  800fcd:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800fd0:	89 d0                	mov    %edx,%eax
  800fd2:	c1 e0 02             	shl    $0x2,%eax
  800fd5:	01 d0                	add    %edx,%eax
  800fd7:	01 c0                	add    %eax,%eax
  800fd9:	01 d8                	add    %ebx,%eax
  800fdb:	83 e8 30             	sub    $0x30,%eax
  800fde:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  800fe1:	8b 45 10             	mov    0x10(%ebp),%eax
  800fe4:	8a 00                	mov    (%eax),%al
  800fe6:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  800fe9:	83 fb 2f             	cmp    $0x2f,%ebx
  800fec:	7e 3e                	jle    80102c <vprintfmt+0xe9>
  800fee:	83 fb 39             	cmp    $0x39,%ebx
  800ff1:	7f 39                	jg     80102c <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800ff3:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800ff6:	eb d5                	jmp    800fcd <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  800ff8:	8b 45 14             	mov    0x14(%ebp),%eax
  800ffb:	83 c0 04             	add    $0x4,%eax
  800ffe:	89 45 14             	mov    %eax,0x14(%ebp)
  801001:	8b 45 14             	mov    0x14(%ebp),%eax
  801004:	83 e8 04             	sub    $0x4,%eax
  801007:	8b 00                	mov    (%eax),%eax
  801009:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  80100c:	eb 1f                	jmp    80102d <vprintfmt+0xea>

		case '.':
			if (width < 0)
  80100e:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  801012:	79 83                	jns    800f97 <vprintfmt+0x54>
				width = 0;
  801014:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  80101b:	e9 77 ff ff ff       	jmp    800f97 <vprintfmt+0x54>

		case '#':
			altflag = 1;
  801020:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  801027:	e9 6b ff ff ff       	jmp    800f97 <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  80102c:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  80102d:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  801031:	0f 89 60 ff ff ff    	jns    800f97 <vprintfmt+0x54>
				width = precision, precision = -1;
  801037:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80103a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  80103d:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  801044:	e9 4e ff ff ff       	jmp    800f97 <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  801049:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  80104c:	e9 46 ff ff ff       	jmp    800f97 <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  801051:	8b 45 14             	mov    0x14(%ebp),%eax
  801054:	83 c0 04             	add    $0x4,%eax
  801057:	89 45 14             	mov    %eax,0x14(%ebp)
  80105a:	8b 45 14             	mov    0x14(%ebp),%eax
  80105d:	83 e8 04             	sub    $0x4,%eax
  801060:	8b 00                	mov    (%eax),%eax
  801062:	83 ec 08             	sub    $0x8,%esp
  801065:	ff 75 0c             	pushl  0xc(%ebp)
  801068:	50                   	push   %eax
  801069:	8b 45 08             	mov    0x8(%ebp),%eax
  80106c:	ff d0                	call   *%eax
  80106e:	83 c4 10             	add    $0x10,%esp
			break;
  801071:	e9 89 02 00 00       	jmp    8012ff <vprintfmt+0x3bc>

		// error message
		case 'e':
			err = va_arg(ap, int);
  801076:	8b 45 14             	mov    0x14(%ebp),%eax
  801079:	83 c0 04             	add    $0x4,%eax
  80107c:	89 45 14             	mov    %eax,0x14(%ebp)
  80107f:	8b 45 14             	mov    0x14(%ebp),%eax
  801082:	83 e8 04             	sub    $0x4,%eax
  801085:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  801087:	85 db                	test   %ebx,%ebx
  801089:	79 02                	jns    80108d <vprintfmt+0x14a>
				err = -err;
  80108b:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  80108d:	83 fb 64             	cmp    $0x64,%ebx
  801090:	7f 0b                	jg     80109d <vprintfmt+0x15a>
  801092:	8b 34 9d 40 3d 80 00 	mov    0x803d40(,%ebx,4),%esi
  801099:	85 f6                	test   %esi,%esi
  80109b:	75 19                	jne    8010b6 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  80109d:	53                   	push   %ebx
  80109e:	68 e5 3e 80 00       	push   $0x803ee5
  8010a3:	ff 75 0c             	pushl  0xc(%ebp)
  8010a6:	ff 75 08             	pushl  0x8(%ebp)
  8010a9:	e8 5e 02 00 00       	call   80130c <printfmt>
  8010ae:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  8010b1:	e9 49 02 00 00       	jmp    8012ff <vprintfmt+0x3bc>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  8010b6:	56                   	push   %esi
  8010b7:	68 ee 3e 80 00       	push   $0x803eee
  8010bc:	ff 75 0c             	pushl  0xc(%ebp)
  8010bf:	ff 75 08             	pushl  0x8(%ebp)
  8010c2:	e8 45 02 00 00       	call   80130c <printfmt>
  8010c7:	83 c4 10             	add    $0x10,%esp
			break;
  8010ca:	e9 30 02 00 00       	jmp    8012ff <vprintfmt+0x3bc>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  8010cf:	8b 45 14             	mov    0x14(%ebp),%eax
  8010d2:	83 c0 04             	add    $0x4,%eax
  8010d5:	89 45 14             	mov    %eax,0x14(%ebp)
  8010d8:	8b 45 14             	mov    0x14(%ebp),%eax
  8010db:	83 e8 04             	sub    $0x4,%eax
  8010de:	8b 30                	mov    (%eax),%esi
  8010e0:	85 f6                	test   %esi,%esi
  8010e2:	75 05                	jne    8010e9 <vprintfmt+0x1a6>
				p = "(null)";
  8010e4:	be f1 3e 80 00       	mov    $0x803ef1,%esi
			if (width > 0 && padc != '-')
  8010e9:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8010ed:	7e 6d                	jle    80115c <vprintfmt+0x219>
  8010ef:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  8010f3:	74 67                	je     80115c <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  8010f5:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8010f8:	83 ec 08             	sub    $0x8,%esp
  8010fb:	50                   	push   %eax
  8010fc:	56                   	push   %esi
  8010fd:	e8 0c 03 00 00       	call   80140e <strnlen>
  801102:	83 c4 10             	add    $0x10,%esp
  801105:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  801108:	eb 16                	jmp    801120 <vprintfmt+0x1dd>
					putch(padc, putdat);
  80110a:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  80110e:	83 ec 08             	sub    $0x8,%esp
  801111:	ff 75 0c             	pushl  0xc(%ebp)
  801114:	50                   	push   %eax
  801115:	8b 45 08             	mov    0x8(%ebp),%eax
  801118:	ff d0                	call   *%eax
  80111a:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  80111d:	ff 4d e4             	decl   -0x1c(%ebp)
  801120:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  801124:	7f e4                	jg     80110a <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  801126:	eb 34                	jmp    80115c <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  801128:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  80112c:	74 1c                	je     80114a <vprintfmt+0x207>
  80112e:	83 fb 1f             	cmp    $0x1f,%ebx
  801131:	7e 05                	jle    801138 <vprintfmt+0x1f5>
  801133:	83 fb 7e             	cmp    $0x7e,%ebx
  801136:	7e 12                	jle    80114a <vprintfmt+0x207>
					putch('?', putdat);
  801138:	83 ec 08             	sub    $0x8,%esp
  80113b:	ff 75 0c             	pushl  0xc(%ebp)
  80113e:	6a 3f                	push   $0x3f
  801140:	8b 45 08             	mov    0x8(%ebp),%eax
  801143:	ff d0                	call   *%eax
  801145:	83 c4 10             	add    $0x10,%esp
  801148:	eb 0f                	jmp    801159 <vprintfmt+0x216>
				else
					putch(ch, putdat);
  80114a:	83 ec 08             	sub    $0x8,%esp
  80114d:	ff 75 0c             	pushl  0xc(%ebp)
  801150:	53                   	push   %ebx
  801151:	8b 45 08             	mov    0x8(%ebp),%eax
  801154:	ff d0                	call   *%eax
  801156:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  801159:	ff 4d e4             	decl   -0x1c(%ebp)
  80115c:	89 f0                	mov    %esi,%eax
  80115e:	8d 70 01             	lea    0x1(%eax),%esi
  801161:	8a 00                	mov    (%eax),%al
  801163:	0f be d8             	movsbl %al,%ebx
  801166:	85 db                	test   %ebx,%ebx
  801168:	74 24                	je     80118e <vprintfmt+0x24b>
  80116a:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80116e:	78 b8                	js     801128 <vprintfmt+0x1e5>
  801170:	ff 4d e0             	decl   -0x20(%ebp)
  801173:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  801177:	79 af                	jns    801128 <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  801179:	eb 13                	jmp    80118e <vprintfmt+0x24b>
				putch(' ', putdat);
  80117b:	83 ec 08             	sub    $0x8,%esp
  80117e:	ff 75 0c             	pushl  0xc(%ebp)
  801181:	6a 20                	push   $0x20
  801183:	8b 45 08             	mov    0x8(%ebp),%eax
  801186:	ff d0                	call   *%eax
  801188:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  80118b:	ff 4d e4             	decl   -0x1c(%ebp)
  80118e:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  801192:	7f e7                	jg     80117b <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  801194:	e9 66 01 00 00       	jmp    8012ff <vprintfmt+0x3bc>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  801199:	83 ec 08             	sub    $0x8,%esp
  80119c:	ff 75 e8             	pushl  -0x18(%ebp)
  80119f:	8d 45 14             	lea    0x14(%ebp),%eax
  8011a2:	50                   	push   %eax
  8011a3:	e8 3c fd ff ff       	call   800ee4 <getint>
  8011a8:	83 c4 10             	add    $0x10,%esp
  8011ab:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8011ae:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  8011b1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8011b4:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8011b7:	85 d2                	test   %edx,%edx
  8011b9:	79 23                	jns    8011de <vprintfmt+0x29b>
				putch('-', putdat);
  8011bb:	83 ec 08             	sub    $0x8,%esp
  8011be:	ff 75 0c             	pushl  0xc(%ebp)
  8011c1:	6a 2d                	push   $0x2d
  8011c3:	8b 45 08             	mov    0x8(%ebp),%eax
  8011c6:	ff d0                	call   *%eax
  8011c8:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  8011cb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8011ce:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8011d1:	f7 d8                	neg    %eax
  8011d3:	83 d2 00             	adc    $0x0,%edx
  8011d6:	f7 da                	neg    %edx
  8011d8:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8011db:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  8011de:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  8011e5:	e9 bc 00 00 00       	jmp    8012a6 <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  8011ea:	83 ec 08             	sub    $0x8,%esp
  8011ed:	ff 75 e8             	pushl  -0x18(%ebp)
  8011f0:	8d 45 14             	lea    0x14(%ebp),%eax
  8011f3:	50                   	push   %eax
  8011f4:	e8 84 fc ff ff       	call   800e7d <getuint>
  8011f9:	83 c4 10             	add    $0x10,%esp
  8011fc:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8011ff:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  801202:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  801209:	e9 98 00 00 00       	jmp    8012a6 <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  80120e:	83 ec 08             	sub    $0x8,%esp
  801211:	ff 75 0c             	pushl  0xc(%ebp)
  801214:	6a 58                	push   $0x58
  801216:	8b 45 08             	mov    0x8(%ebp),%eax
  801219:	ff d0                	call   *%eax
  80121b:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  80121e:	83 ec 08             	sub    $0x8,%esp
  801221:	ff 75 0c             	pushl  0xc(%ebp)
  801224:	6a 58                	push   $0x58
  801226:	8b 45 08             	mov    0x8(%ebp),%eax
  801229:	ff d0                	call   *%eax
  80122b:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  80122e:	83 ec 08             	sub    $0x8,%esp
  801231:	ff 75 0c             	pushl  0xc(%ebp)
  801234:	6a 58                	push   $0x58
  801236:	8b 45 08             	mov    0x8(%ebp),%eax
  801239:	ff d0                	call   *%eax
  80123b:	83 c4 10             	add    $0x10,%esp
			break;
  80123e:	e9 bc 00 00 00       	jmp    8012ff <vprintfmt+0x3bc>

		// pointer
		case 'p':
			putch('0', putdat);
  801243:	83 ec 08             	sub    $0x8,%esp
  801246:	ff 75 0c             	pushl  0xc(%ebp)
  801249:	6a 30                	push   $0x30
  80124b:	8b 45 08             	mov    0x8(%ebp),%eax
  80124e:	ff d0                	call   *%eax
  801250:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  801253:	83 ec 08             	sub    $0x8,%esp
  801256:	ff 75 0c             	pushl  0xc(%ebp)
  801259:	6a 78                	push   $0x78
  80125b:	8b 45 08             	mov    0x8(%ebp),%eax
  80125e:	ff d0                	call   *%eax
  801260:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  801263:	8b 45 14             	mov    0x14(%ebp),%eax
  801266:	83 c0 04             	add    $0x4,%eax
  801269:	89 45 14             	mov    %eax,0x14(%ebp)
  80126c:	8b 45 14             	mov    0x14(%ebp),%eax
  80126f:	83 e8 04             	sub    $0x4,%eax
  801272:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  801274:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801277:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  80127e:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  801285:	eb 1f                	jmp    8012a6 <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  801287:	83 ec 08             	sub    $0x8,%esp
  80128a:	ff 75 e8             	pushl  -0x18(%ebp)
  80128d:	8d 45 14             	lea    0x14(%ebp),%eax
  801290:	50                   	push   %eax
  801291:	e8 e7 fb ff ff       	call   800e7d <getuint>
  801296:	83 c4 10             	add    $0x10,%esp
  801299:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80129c:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  80129f:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  8012a6:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  8012aa:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8012ad:	83 ec 04             	sub    $0x4,%esp
  8012b0:	52                   	push   %edx
  8012b1:	ff 75 e4             	pushl  -0x1c(%ebp)
  8012b4:	50                   	push   %eax
  8012b5:	ff 75 f4             	pushl  -0xc(%ebp)
  8012b8:	ff 75 f0             	pushl  -0x10(%ebp)
  8012bb:	ff 75 0c             	pushl  0xc(%ebp)
  8012be:	ff 75 08             	pushl  0x8(%ebp)
  8012c1:	e8 00 fb ff ff       	call   800dc6 <printnum>
  8012c6:	83 c4 20             	add    $0x20,%esp
			break;
  8012c9:	eb 34                	jmp    8012ff <vprintfmt+0x3bc>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  8012cb:	83 ec 08             	sub    $0x8,%esp
  8012ce:	ff 75 0c             	pushl  0xc(%ebp)
  8012d1:	53                   	push   %ebx
  8012d2:	8b 45 08             	mov    0x8(%ebp),%eax
  8012d5:	ff d0                	call   *%eax
  8012d7:	83 c4 10             	add    $0x10,%esp
			break;
  8012da:	eb 23                	jmp    8012ff <vprintfmt+0x3bc>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  8012dc:	83 ec 08             	sub    $0x8,%esp
  8012df:	ff 75 0c             	pushl  0xc(%ebp)
  8012e2:	6a 25                	push   $0x25
  8012e4:	8b 45 08             	mov    0x8(%ebp),%eax
  8012e7:	ff d0                	call   *%eax
  8012e9:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  8012ec:	ff 4d 10             	decl   0x10(%ebp)
  8012ef:	eb 03                	jmp    8012f4 <vprintfmt+0x3b1>
  8012f1:	ff 4d 10             	decl   0x10(%ebp)
  8012f4:	8b 45 10             	mov    0x10(%ebp),%eax
  8012f7:	48                   	dec    %eax
  8012f8:	8a 00                	mov    (%eax),%al
  8012fa:	3c 25                	cmp    $0x25,%al
  8012fc:	75 f3                	jne    8012f1 <vprintfmt+0x3ae>
				/* do nothing */;
			break;
  8012fe:	90                   	nop
		}
	}
  8012ff:	e9 47 fc ff ff       	jmp    800f4b <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  801304:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  801305:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801308:	5b                   	pop    %ebx
  801309:	5e                   	pop    %esi
  80130a:	5d                   	pop    %ebp
  80130b:	c3                   	ret    

0080130c <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  80130c:	55                   	push   %ebp
  80130d:	89 e5                	mov    %esp,%ebp
  80130f:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  801312:	8d 45 10             	lea    0x10(%ebp),%eax
  801315:	83 c0 04             	add    $0x4,%eax
  801318:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  80131b:	8b 45 10             	mov    0x10(%ebp),%eax
  80131e:	ff 75 f4             	pushl  -0xc(%ebp)
  801321:	50                   	push   %eax
  801322:	ff 75 0c             	pushl  0xc(%ebp)
  801325:	ff 75 08             	pushl  0x8(%ebp)
  801328:	e8 16 fc ff ff       	call   800f43 <vprintfmt>
  80132d:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  801330:	90                   	nop
  801331:	c9                   	leave  
  801332:	c3                   	ret    

00801333 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  801333:	55                   	push   %ebp
  801334:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  801336:	8b 45 0c             	mov    0xc(%ebp),%eax
  801339:	8b 40 08             	mov    0x8(%eax),%eax
  80133c:	8d 50 01             	lea    0x1(%eax),%edx
  80133f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801342:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  801345:	8b 45 0c             	mov    0xc(%ebp),%eax
  801348:	8b 10                	mov    (%eax),%edx
  80134a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80134d:	8b 40 04             	mov    0x4(%eax),%eax
  801350:	39 c2                	cmp    %eax,%edx
  801352:	73 12                	jae    801366 <sprintputch+0x33>
		*b->buf++ = ch;
  801354:	8b 45 0c             	mov    0xc(%ebp),%eax
  801357:	8b 00                	mov    (%eax),%eax
  801359:	8d 48 01             	lea    0x1(%eax),%ecx
  80135c:	8b 55 0c             	mov    0xc(%ebp),%edx
  80135f:	89 0a                	mov    %ecx,(%edx)
  801361:	8b 55 08             	mov    0x8(%ebp),%edx
  801364:	88 10                	mov    %dl,(%eax)
}
  801366:	90                   	nop
  801367:	5d                   	pop    %ebp
  801368:	c3                   	ret    

00801369 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  801369:	55                   	push   %ebp
  80136a:	89 e5                	mov    %esp,%ebp
  80136c:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  80136f:	8b 45 08             	mov    0x8(%ebp),%eax
  801372:	89 45 ec             	mov    %eax,-0x14(%ebp)
  801375:	8b 45 0c             	mov    0xc(%ebp),%eax
  801378:	8d 50 ff             	lea    -0x1(%eax),%edx
  80137b:	8b 45 08             	mov    0x8(%ebp),%eax
  80137e:	01 d0                	add    %edx,%eax
  801380:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801383:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  80138a:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80138e:	74 06                	je     801396 <vsnprintf+0x2d>
  801390:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801394:	7f 07                	jg     80139d <vsnprintf+0x34>
		return -E_INVAL;
  801396:	b8 03 00 00 00       	mov    $0x3,%eax
  80139b:	eb 20                	jmp    8013bd <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  80139d:	ff 75 14             	pushl  0x14(%ebp)
  8013a0:	ff 75 10             	pushl  0x10(%ebp)
  8013a3:	8d 45 ec             	lea    -0x14(%ebp),%eax
  8013a6:	50                   	push   %eax
  8013a7:	68 33 13 80 00       	push   $0x801333
  8013ac:	e8 92 fb ff ff       	call   800f43 <vprintfmt>
  8013b1:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  8013b4:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8013b7:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  8013ba:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  8013bd:	c9                   	leave  
  8013be:	c3                   	ret    

008013bf <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  8013bf:	55                   	push   %ebp
  8013c0:	89 e5                	mov    %esp,%ebp
  8013c2:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  8013c5:	8d 45 10             	lea    0x10(%ebp),%eax
  8013c8:	83 c0 04             	add    $0x4,%eax
  8013cb:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  8013ce:	8b 45 10             	mov    0x10(%ebp),%eax
  8013d1:	ff 75 f4             	pushl  -0xc(%ebp)
  8013d4:	50                   	push   %eax
  8013d5:	ff 75 0c             	pushl  0xc(%ebp)
  8013d8:	ff 75 08             	pushl  0x8(%ebp)
  8013db:	e8 89 ff ff ff       	call   801369 <vsnprintf>
  8013e0:	83 c4 10             	add    $0x10,%esp
  8013e3:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  8013e6:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8013e9:	c9                   	leave  
  8013ea:	c3                   	ret    

008013eb <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  8013eb:	55                   	push   %ebp
  8013ec:	89 e5                	mov    %esp,%ebp
  8013ee:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  8013f1:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8013f8:	eb 06                	jmp    801400 <strlen+0x15>
		n++;
  8013fa:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  8013fd:	ff 45 08             	incl   0x8(%ebp)
  801400:	8b 45 08             	mov    0x8(%ebp),%eax
  801403:	8a 00                	mov    (%eax),%al
  801405:	84 c0                	test   %al,%al
  801407:	75 f1                	jne    8013fa <strlen+0xf>
		n++;
	return n;
  801409:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  80140c:	c9                   	leave  
  80140d:	c3                   	ret    

0080140e <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  80140e:	55                   	push   %ebp
  80140f:	89 e5                	mov    %esp,%ebp
  801411:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  801414:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  80141b:	eb 09                	jmp    801426 <strnlen+0x18>
		n++;
  80141d:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  801420:	ff 45 08             	incl   0x8(%ebp)
  801423:	ff 4d 0c             	decl   0xc(%ebp)
  801426:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80142a:	74 09                	je     801435 <strnlen+0x27>
  80142c:	8b 45 08             	mov    0x8(%ebp),%eax
  80142f:	8a 00                	mov    (%eax),%al
  801431:	84 c0                	test   %al,%al
  801433:	75 e8                	jne    80141d <strnlen+0xf>
		n++;
	return n;
  801435:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  801438:	c9                   	leave  
  801439:	c3                   	ret    

0080143a <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  80143a:	55                   	push   %ebp
  80143b:	89 e5                	mov    %esp,%ebp
  80143d:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  801440:	8b 45 08             	mov    0x8(%ebp),%eax
  801443:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  801446:	90                   	nop
  801447:	8b 45 08             	mov    0x8(%ebp),%eax
  80144a:	8d 50 01             	lea    0x1(%eax),%edx
  80144d:	89 55 08             	mov    %edx,0x8(%ebp)
  801450:	8b 55 0c             	mov    0xc(%ebp),%edx
  801453:	8d 4a 01             	lea    0x1(%edx),%ecx
  801456:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  801459:	8a 12                	mov    (%edx),%dl
  80145b:	88 10                	mov    %dl,(%eax)
  80145d:	8a 00                	mov    (%eax),%al
  80145f:	84 c0                	test   %al,%al
  801461:	75 e4                	jne    801447 <strcpy+0xd>
		/* do nothing */;
	return ret;
  801463:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  801466:	c9                   	leave  
  801467:	c3                   	ret    

00801468 <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  801468:	55                   	push   %ebp
  801469:	89 e5                	mov    %esp,%ebp
  80146b:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  80146e:	8b 45 08             	mov    0x8(%ebp),%eax
  801471:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  801474:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  80147b:	eb 1f                	jmp    80149c <strncpy+0x34>
		*dst++ = *src;
  80147d:	8b 45 08             	mov    0x8(%ebp),%eax
  801480:	8d 50 01             	lea    0x1(%eax),%edx
  801483:	89 55 08             	mov    %edx,0x8(%ebp)
  801486:	8b 55 0c             	mov    0xc(%ebp),%edx
  801489:	8a 12                	mov    (%edx),%dl
  80148b:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  80148d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801490:	8a 00                	mov    (%eax),%al
  801492:	84 c0                	test   %al,%al
  801494:	74 03                	je     801499 <strncpy+0x31>
			src++;
  801496:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  801499:	ff 45 fc             	incl   -0x4(%ebp)
  80149c:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80149f:	3b 45 10             	cmp    0x10(%ebp),%eax
  8014a2:	72 d9                	jb     80147d <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  8014a4:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  8014a7:	c9                   	leave  
  8014a8:	c3                   	ret    

008014a9 <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  8014a9:	55                   	push   %ebp
  8014aa:	89 e5                	mov    %esp,%ebp
  8014ac:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  8014af:	8b 45 08             	mov    0x8(%ebp),%eax
  8014b2:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  8014b5:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8014b9:	74 30                	je     8014eb <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  8014bb:	eb 16                	jmp    8014d3 <strlcpy+0x2a>
			*dst++ = *src++;
  8014bd:	8b 45 08             	mov    0x8(%ebp),%eax
  8014c0:	8d 50 01             	lea    0x1(%eax),%edx
  8014c3:	89 55 08             	mov    %edx,0x8(%ebp)
  8014c6:	8b 55 0c             	mov    0xc(%ebp),%edx
  8014c9:	8d 4a 01             	lea    0x1(%edx),%ecx
  8014cc:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  8014cf:	8a 12                	mov    (%edx),%dl
  8014d1:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  8014d3:	ff 4d 10             	decl   0x10(%ebp)
  8014d6:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8014da:	74 09                	je     8014e5 <strlcpy+0x3c>
  8014dc:	8b 45 0c             	mov    0xc(%ebp),%eax
  8014df:	8a 00                	mov    (%eax),%al
  8014e1:	84 c0                	test   %al,%al
  8014e3:	75 d8                	jne    8014bd <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  8014e5:	8b 45 08             	mov    0x8(%ebp),%eax
  8014e8:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  8014eb:	8b 55 08             	mov    0x8(%ebp),%edx
  8014ee:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8014f1:	29 c2                	sub    %eax,%edx
  8014f3:	89 d0                	mov    %edx,%eax
}
  8014f5:	c9                   	leave  
  8014f6:	c3                   	ret    

008014f7 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  8014f7:	55                   	push   %ebp
  8014f8:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  8014fa:	eb 06                	jmp    801502 <strcmp+0xb>
		p++, q++;
  8014fc:	ff 45 08             	incl   0x8(%ebp)
  8014ff:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  801502:	8b 45 08             	mov    0x8(%ebp),%eax
  801505:	8a 00                	mov    (%eax),%al
  801507:	84 c0                	test   %al,%al
  801509:	74 0e                	je     801519 <strcmp+0x22>
  80150b:	8b 45 08             	mov    0x8(%ebp),%eax
  80150e:	8a 10                	mov    (%eax),%dl
  801510:	8b 45 0c             	mov    0xc(%ebp),%eax
  801513:	8a 00                	mov    (%eax),%al
  801515:	38 c2                	cmp    %al,%dl
  801517:	74 e3                	je     8014fc <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  801519:	8b 45 08             	mov    0x8(%ebp),%eax
  80151c:	8a 00                	mov    (%eax),%al
  80151e:	0f b6 d0             	movzbl %al,%edx
  801521:	8b 45 0c             	mov    0xc(%ebp),%eax
  801524:	8a 00                	mov    (%eax),%al
  801526:	0f b6 c0             	movzbl %al,%eax
  801529:	29 c2                	sub    %eax,%edx
  80152b:	89 d0                	mov    %edx,%eax
}
  80152d:	5d                   	pop    %ebp
  80152e:	c3                   	ret    

0080152f <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  80152f:	55                   	push   %ebp
  801530:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  801532:	eb 09                	jmp    80153d <strncmp+0xe>
		n--, p++, q++;
  801534:	ff 4d 10             	decl   0x10(%ebp)
  801537:	ff 45 08             	incl   0x8(%ebp)
  80153a:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  80153d:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801541:	74 17                	je     80155a <strncmp+0x2b>
  801543:	8b 45 08             	mov    0x8(%ebp),%eax
  801546:	8a 00                	mov    (%eax),%al
  801548:	84 c0                	test   %al,%al
  80154a:	74 0e                	je     80155a <strncmp+0x2b>
  80154c:	8b 45 08             	mov    0x8(%ebp),%eax
  80154f:	8a 10                	mov    (%eax),%dl
  801551:	8b 45 0c             	mov    0xc(%ebp),%eax
  801554:	8a 00                	mov    (%eax),%al
  801556:	38 c2                	cmp    %al,%dl
  801558:	74 da                	je     801534 <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  80155a:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80155e:	75 07                	jne    801567 <strncmp+0x38>
		return 0;
  801560:	b8 00 00 00 00       	mov    $0x0,%eax
  801565:	eb 14                	jmp    80157b <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  801567:	8b 45 08             	mov    0x8(%ebp),%eax
  80156a:	8a 00                	mov    (%eax),%al
  80156c:	0f b6 d0             	movzbl %al,%edx
  80156f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801572:	8a 00                	mov    (%eax),%al
  801574:	0f b6 c0             	movzbl %al,%eax
  801577:	29 c2                	sub    %eax,%edx
  801579:	89 d0                	mov    %edx,%eax
}
  80157b:	5d                   	pop    %ebp
  80157c:	c3                   	ret    

0080157d <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  80157d:	55                   	push   %ebp
  80157e:	89 e5                	mov    %esp,%ebp
  801580:	83 ec 04             	sub    $0x4,%esp
  801583:	8b 45 0c             	mov    0xc(%ebp),%eax
  801586:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  801589:	eb 12                	jmp    80159d <strchr+0x20>
		if (*s == c)
  80158b:	8b 45 08             	mov    0x8(%ebp),%eax
  80158e:	8a 00                	mov    (%eax),%al
  801590:	3a 45 fc             	cmp    -0x4(%ebp),%al
  801593:	75 05                	jne    80159a <strchr+0x1d>
			return (char *) s;
  801595:	8b 45 08             	mov    0x8(%ebp),%eax
  801598:	eb 11                	jmp    8015ab <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  80159a:	ff 45 08             	incl   0x8(%ebp)
  80159d:	8b 45 08             	mov    0x8(%ebp),%eax
  8015a0:	8a 00                	mov    (%eax),%al
  8015a2:	84 c0                	test   %al,%al
  8015a4:	75 e5                	jne    80158b <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  8015a6:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8015ab:	c9                   	leave  
  8015ac:	c3                   	ret    

008015ad <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  8015ad:	55                   	push   %ebp
  8015ae:	89 e5                	mov    %esp,%ebp
  8015b0:	83 ec 04             	sub    $0x4,%esp
  8015b3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8015b6:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  8015b9:	eb 0d                	jmp    8015c8 <strfind+0x1b>
		if (*s == c)
  8015bb:	8b 45 08             	mov    0x8(%ebp),%eax
  8015be:	8a 00                	mov    (%eax),%al
  8015c0:	3a 45 fc             	cmp    -0x4(%ebp),%al
  8015c3:	74 0e                	je     8015d3 <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  8015c5:	ff 45 08             	incl   0x8(%ebp)
  8015c8:	8b 45 08             	mov    0x8(%ebp),%eax
  8015cb:	8a 00                	mov    (%eax),%al
  8015cd:	84 c0                	test   %al,%al
  8015cf:	75 ea                	jne    8015bb <strfind+0xe>
  8015d1:	eb 01                	jmp    8015d4 <strfind+0x27>
		if (*s == c)
			break;
  8015d3:	90                   	nop
	return (char *) s;
  8015d4:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8015d7:	c9                   	leave  
  8015d8:	c3                   	ret    

008015d9 <memset>:


void *
memset(void *v, int c, uint32 n)
{
  8015d9:	55                   	push   %ebp
  8015da:	89 e5                	mov    %esp,%ebp
  8015dc:	83 ec 10             	sub    $0x10,%esp
	char *p;
	int m;

	p = v;
  8015df:	8b 45 08             	mov    0x8(%ebp),%eax
  8015e2:	89 45 fc             	mov    %eax,-0x4(%ebp)
	m = n;
  8015e5:	8b 45 10             	mov    0x10(%ebp),%eax
  8015e8:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (--m >= 0)
  8015eb:	eb 0e                	jmp    8015fb <memset+0x22>
		*p++ = c;
  8015ed:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8015f0:	8d 50 01             	lea    0x1(%eax),%edx
  8015f3:	89 55 fc             	mov    %edx,-0x4(%ebp)
  8015f6:	8b 55 0c             	mov    0xc(%ebp),%edx
  8015f9:	88 10                	mov    %dl,(%eax)
	char *p;
	int m;

	p = v;
	m = n;
	while (--m >= 0)
  8015fb:	ff 4d f8             	decl   -0x8(%ebp)
  8015fe:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  801602:	79 e9                	jns    8015ed <memset+0x14>
		*p++ = c;

	return v;
  801604:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801607:	c9                   	leave  
  801608:	c3                   	ret    

00801609 <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  801609:	55                   	push   %ebp
  80160a:	89 e5                	mov    %esp,%ebp
  80160c:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  80160f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801612:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  801615:	8b 45 08             	mov    0x8(%ebp),%eax
  801618:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (n-- > 0)
  80161b:	eb 16                	jmp    801633 <memcpy+0x2a>
		*d++ = *s++;
  80161d:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801620:	8d 50 01             	lea    0x1(%eax),%edx
  801623:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801626:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801629:	8d 4a 01             	lea    0x1(%edx),%ecx
  80162c:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  80162f:	8a 12                	mov    (%edx),%dl
  801631:	88 10                	mov    %dl,(%eax)
	const char *s;
	char *d;

	s = src;
	d = dst;
	while (n-- > 0)
  801633:	8b 45 10             	mov    0x10(%ebp),%eax
  801636:	8d 50 ff             	lea    -0x1(%eax),%edx
  801639:	89 55 10             	mov    %edx,0x10(%ebp)
  80163c:	85 c0                	test   %eax,%eax
  80163e:	75 dd                	jne    80161d <memcpy+0x14>
		*d++ = *s++;

	return dst;
  801640:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801643:	c9                   	leave  
  801644:	c3                   	ret    

00801645 <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  801645:	55                   	push   %ebp
  801646:	89 e5                	mov    %esp,%ebp
  801648:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  80164b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80164e:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  801651:	8b 45 08             	mov    0x8(%ebp),%eax
  801654:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  801657:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80165a:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  80165d:	73 50                	jae    8016af <memmove+0x6a>
  80165f:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801662:	8b 45 10             	mov    0x10(%ebp),%eax
  801665:	01 d0                	add    %edx,%eax
  801667:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  80166a:	76 43                	jbe    8016af <memmove+0x6a>
		s += n;
  80166c:	8b 45 10             	mov    0x10(%ebp),%eax
  80166f:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  801672:	8b 45 10             	mov    0x10(%ebp),%eax
  801675:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  801678:	eb 10                	jmp    80168a <memmove+0x45>
			*--d = *--s;
  80167a:	ff 4d f8             	decl   -0x8(%ebp)
  80167d:	ff 4d fc             	decl   -0x4(%ebp)
  801680:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801683:	8a 10                	mov    (%eax),%dl
  801685:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801688:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  80168a:	8b 45 10             	mov    0x10(%ebp),%eax
  80168d:	8d 50 ff             	lea    -0x1(%eax),%edx
  801690:	89 55 10             	mov    %edx,0x10(%ebp)
  801693:	85 c0                	test   %eax,%eax
  801695:	75 e3                	jne    80167a <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  801697:	eb 23                	jmp    8016bc <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  801699:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80169c:	8d 50 01             	lea    0x1(%eax),%edx
  80169f:	89 55 f8             	mov    %edx,-0x8(%ebp)
  8016a2:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8016a5:	8d 4a 01             	lea    0x1(%edx),%ecx
  8016a8:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  8016ab:	8a 12                	mov    (%edx),%dl
  8016ad:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  8016af:	8b 45 10             	mov    0x10(%ebp),%eax
  8016b2:	8d 50 ff             	lea    -0x1(%eax),%edx
  8016b5:	89 55 10             	mov    %edx,0x10(%ebp)
  8016b8:	85 c0                	test   %eax,%eax
  8016ba:	75 dd                	jne    801699 <memmove+0x54>
			*d++ = *s++;

	return dst;
  8016bc:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8016bf:	c9                   	leave  
  8016c0:	c3                   	ret    

008016c1 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  8016c1:	55                   	push   %ebp
  8016c2:	89 e5                	mov    %esp,%ebp
  8016c4:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  8016c7:	8b 45 08             	mov    0x8(%ebp),%eax
  8016ca:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  8016cd:	8b 45 0c             	mov    0xc(%ebp),%eax
  8016d0:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  8016d3:	eb 2a                	jmp    8016ff <memcmp+0x3e>
		if (*s1 != *s2)
  8016d5:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8016d8:	8a 10                	mov    (%eax),%dl
  8016da:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8016dd:	8a 00                	mov    (%eax),%al
  8016df:	38 c2                	cmp    %al,%dl
  8016e1:	74 16                	je     8016f9 <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  8016e3:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8016e6:	8a 00                	mov    (%eax),%al
  8016e8:	0f b6 d0             	movzbl %al,%edx
  8016eb:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8016ee:	8a 00                	mov    (%eax),%al
  8016f0:	0f b6 c0             	movzbl %al,%eax
  8016f3:	29 c2                	sub    %eax,%edx
  8016f5:	89 d0                	mov    %edx,%eax
  8016f7:	eb 18                	jmp    801711 <memcmp+0x50>
		s1++, s2++;
  8016f9:	ff 45 fc             	incl   -0x4(%ebp)
  8016fc:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  8016ff:	8b 45 10             	mov    0x10(%ebp),%eax
  801702:	8d 50 ff             	lea    -0x1(%eax),%edx
  801705:	89 55 10             	mov    %edx,0x10(%ebp)
  801708:	85 c0                	test   %eax,%eax
  80170a:	75 c9                	jne    8016d5 <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  80170c:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801711:	c9                   	leave  
  801712:	c3                   	ret    

00801713 <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  801713:	55                   	push   %ebp
  801714:	89 e5                	mov    %esp,%ebp
  801716:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  801719:	8b 55 08             	mov    0x8(%ebp),%edx
  80171c:	8b 45 10             	mov    0x10(%ebp),%eax
  80171f:	01 d0                	add    %edx,%eax
  801721:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  801724:	eb 15                	jmp    80173b <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  801726:	8b 45 08             	mov    0x8(%ebp),%eax
  801729:	8a 00                	mov    (%eax),%al
  80172b:	0f b6 d0             	movzbl %al,%edx
  80172e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801731:	0f b6 c0             	movzbl %al,%eax
  801734:	39 c2                	cmp    %eax,%edx
  801736:	74 0d                	je     801745 <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  801738:	ff 45 08             	incl   0x8(%ebp)
  80173b:	8b 45 08             	mov    0x8(%ebp),%eax
  80173e:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  801741:	72 e3                	jb     801726 <memfind+0x13>
  801743:	eb 01                	jmp    801746 <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  801745:	90                   	nop
	return (void *) s;
  801746:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801749:	c9                   	leave  
  80174a:	c3                   	ret    

0080174b <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  80174b:	55                   	push   %ebp
  80174c:	89 e5                	mov    %esp,%ebp
  80174e:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  801751:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  801758:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  80175f:	eb 03                	jmp    801764 <strtol+0x19>
		s++;
  801761:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801764:	8b 45 08             	mov    0x8(%ebp),%eax
  801767:	8a 00                	mov    (%eax),%al
  801769:	3c 20                	cmp    $0x20,%al
  80176b:	74 f4                	je     801761 <strtol+0x16>
  80176d:	8b 45 08             	mov    0x8(%ebp),%eax
  801770:	8a 00                	mov    (%eax),%al
  801772:	3c 09                	cmp    $0x9,%al
  801774:	74 eb                	je     801761 <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  801776:	8b 45 08             	mov    0x8(%ebp),%eax
  801779:	8a 00                	mov    (%eax),%al
  80177b:	3c 2b                	cmp    $0x2b,%al
  80177d:	75 05                	jne    801784 <strtol+0x39>
		s++;
  80177f:	ff 45 08             	incl   0x8(%ebp)
  801782:	eb 13                	jmp    801797 <strtol+0x4c>
	else if (*s == '-')
  801784:	8b 45 08             	mov    0x8(%ebp),%eax
  801787:	8a 00                	mov    (%eax),%al
  801789:	3c 2d                	cmp    $0x2d,%al
  80178b:	75 0a                	jne    801797 <strtol+0x4c>
		s++, neg = 1;
  80178d:	ff 45 08             	incl   0x8(%ebp)
  801790:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  801797:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80179b:	74 06                	je     8017a3 <strtol+0x58>
  80179d:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  8017a1:	75 20                	jne    8017c3 <strtol+0x78>
  8017a3:	8b 45 08             	mov    0x8(%ebp),%eax
  8017a6:	8a 00                	mov    (%eax),%al
  8017a8:	3c 30                	cmp    $0x30,%al
  8017aa:	75 17                	jne    8017c3 <strtol+0x78>
  8017ac:	8b 45 08             	mov    0x8(%ebp),%eax
  8017af:	40                   	inc    %eax
  8017b0:	8a 00                	mov    (%eax),%al
  8017b2:	3c 78                	cmp    $0x78,%al
  8017b4:	75 0d                	jne    8017c3 <strtol+0x78>
		s += 2, base = 16;
  8017b6:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  8017ba:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  8017c1:	eb 28                	jmp    8017eb <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  8017c3:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8017c7:	75 15                	jne    8017de <strtol+0x93>
  8017c9:	8b 45 08             	mov    0x8(%ebp),%eax
  8017cc:	8a 00                	mov    (%eax),%al
  8017ce:	3c 30                	cmp    $0x30,%al
  8017d0:	75 0c                	jne    8017de <strtol+0x93>
		s++, base = 8;
  8017d2:	ff 45 08             	incl   0x8(%ebp)
  8017d5:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  8017dc:	eb 0d                	jmp    8017eb <strtol+0xa0>
	else if (base == 0)
  8017de:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8017e2:	75 07                	jne    8017eb <strtol+0xa0>
		base = 10;
  8017e4:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  8017eb:	8b 45 08             	mov    0x8(%ebp),%eax
  8017ee:	8a 00                	mov    (%eax),%al
  8017f0:	3c 2f                	cmp    $0x2f,%al
  8017f2:	7e 19                	jle    80180d <strtol+0xc2>
  8017f4:	8b 45 08             	mov    0x8(%ebp),%eax
  8017f7:	8a 00                	mov    (%eax),%al
  8017f9:	3c 39                	cmp    $0x39,%al
  8017fb:	7f 10                	jg     80180d <strtol+0xc2>
			dig = *s - '0';
  8017fd:	8b 45 08             	mov    0x8(%ebp),%eax
  801800:	8a 00                	mov    (%eax),%al
  801802:	0f be c0             	movsbl %al,%eax
  801805:	83 e8 30             	sub    $0x30,%eax
  801808:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80180b:	eb 42                	jmp    80184f <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  80180d:	8b 45 08             	mov    0x8(%ebp),%eax
  801810:	8a 00                	mov    (%eax),%al
  801812:	3c 60                	cmp    $0x60,%al
  801814:	7e 19                	jle    80182f <strtol+0xe4>
  801816:	8b 45 08             	mov    0x8(%ebp),%eax
  801819:	8a 00                	mov    (%eax),%al
  80181b:	3c 7a                	cmp    $0x7a,%al
  80181d:	7f 10                	jg     80182f <strtol+0xe4>
			dig = *s - 'a' + 10;
  80181f:	8b 45 08             	mov    0x8(%ebp),%eax
  801822:	8a 00                	mov    (%eax),%al
  801824:	0f be c0             	movsbl %al,%eax
  801827:	83 e8 57             	sub    $0x57,%eax
  80182a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80182d:	eb 20                	jmp    80184f <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  80182f:	8b 45 08             	mov    0x8(%ebp),%eax
  801832:	8a 00                	mov    (%eax),%al
  801834:	3c 40                	cmp    $0x40,%al
  801836:	7e 39                	jle    801871 <strtol+0x126>
  801838:	8b 45 08             	mov    0x8(%ebp),%eax
  80183b:	8a 00                	mov    (%eax),%al
  80183d:	3c 5a                	cmp    $0x5a,%al
  80183f:	7f 30                	jg     801871 <strtol+0x126>
			dig = *s - 'A' + 10;
  801841:	8b 45 08             	mov    0x8(%ebp),%eax
  801844:	8a 00                	mov    (%eax),%al
  801846:	0f be c0             	movsbl %al,%eax
  801849:	83 e8 37             	sub    $0x37,%eax
  80184c:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  80184f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801852:	3b 45 10             	cmp    0x10(%ebp),%eax
  801855:	7d 19                	jge    801870 <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  801857:	ff 45 08             	incl   0x8(%ebp)
  80185a:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80185d:	0f af 45 10          	imul   0x10(%ebp),%eax
  801861:	89 c2                	mov    %eax,%edx
  801863:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801866:	01 d0                	add    %edx,%eax
  801868:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  80186b:	e9 7b ff ff ff       	jmp    8017eb <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  801870:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  801871:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801875:	74 08                	je     80187f <strtol+0x134>
		*endptr = (char *) s;
  801877:	8b 45 0c             	mov    0xc(%ebp),%eax
  80187a:	8b 55 08             	mov    0x8(%ebp),%edx
  80187d:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  80187f:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801883:	74 07                	je     80188c <strtol+0x141>
  801885:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801888:	f7 d8                	neg    %eax
  80188a:	eb 03                	jmp    80188f <strtol+0x144>
  80188c:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  80188f:	c9                   	leave  
  801890:	c3                   	ret    

00801891 <ltostr>:

void
ltostr(long value, char *str)
{
  801891:	55                   	push   %ebp
  801892:	89 e5                	mov    %esp,%ebp
  801894:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  801897:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  80189e:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  8018a5:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8018a9:	79 13                	jns    8018be <ltostr+0x2d>
	{
		neg = 1;
  8018ab:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  8018b2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8018b5:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  8018b8:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  8018bb:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  8018be:	8b 45 08             	mov    0x8(%ebp),%eax
  8018c1:	b9 0a 00 00 00       	mov    $0xa,%ecx
  8018c6:	99                   	cltd   
  8018c7:	f7 f9                	idiv   %ecx
  8018c9:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  8018cc:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8018cf:	8d 50 01             	lea    0x1(%eax),%edx
  8018d2:	89 55 f8             	mov    %edx,-0x8(%ebp)
  8018d5:	89 c2                	mov    %eax,%edx
  8018d7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8018da:	01 d0                	add    %edx,%eax
  8018dc:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8018df:	83 c2 30             	add    $0x30,%edx
  8018e2:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  8018e4:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8018e7:	b8 67 66 66 66       	mov    $0x66666667,%eax
  8018ec:	f7 e9                	imul   %ecx
  8018ee:	c1 fa 02             	sar    $0x2,%edx
  8018f1:	89 c8                	mov    %ecx,%eax
  8018f3:	c1 f8 1f             	sar    $0x1f,%eax
  8018f6:	29 c2                	sub    %eax,%edx
  8018f8:	89 d0                	mov    %edx,%eax
  8018fa:	89 45 08             	mov    %eax,0x8(%ebp)
	} while (value % 10 != 0);
  8018fd:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801900:	b8 67 66 66 66       	mov    $0x66666667,%eax
  801905:	f7 e9                	imul   %ecx
  801907:	c1 fa 02             	sar    $0x2,%edx
  80190a:	89 c8                	mov    %ecx,%eax
  80190c:	c1 f8 1f             	sar    $0x1f,%eax
  80190f:	29 c2                	sub    %eax,%edx
  801911:	89 d0                	mov    %edx,%eax
  801913:	c1 e0 02             	shl    $0x2,%eax
  801916:	01 d0                	add    %edx,%eax
  801918:	01 c0                	add    %eax,%eax
  80191a:	29 c1                	sub    %eax,%ecx
  80191c:	89 ca                	mov    %ecx,%edx
  80191e:	85 d2                	test   %edx,%edx
  801920:	75 9c                	jne    8018be <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  801922:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  801929:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80192c:	48                   	dec    %eax
  80192d:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  801930:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801934:	74 3d                	je     801973 <ltostr+0xe2>
		start = 1 ;
  801936:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  80193d:	eb 34                	jmp    801973 <ltostr+0xe2>
	{
		char tmp = str[start] ;
  80193f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801942:	8b 45 0c             	mov    0xc(%ebp),%eax
  801945:	01 d0                	add    %edx,%eax
  801947:	8a 00                	mov    (%eax),%al
  801949:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  80194c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80194f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801952:	01 c2                	add    %eax,%edx
  801954:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  801957:	8b 45 0c             	mov    0xc(%ebp),%eax
  80195a:	01 c8                	add    %ecx,%eax
  80195c:	8a 00                	mov    (%eax),%al
  80195e:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  801960:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801963:	8b 45 0c             	mov    0xc(%ebp),%eax
  801966:	01 c2                	add    %eax,%edx
  801968:	8a 45 eb             	mov    -0x15(%ebp),%al
  80196b:	88 02                	mov    %al,(%edx)
		start++ ;
  80196d:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  801970:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  801973:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801976:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801979:	7c c4                	jl     80193f <ltostr+0xae>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  80197b:	8b 55 f8             	mov    -0x8(%ebp),%edx
  80197e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801981:	01 d0                	add    %edx,%eax
  801983:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  801986:	90                   	nop
  801987:	c9                   	leave  
  801988:	c3                   	ret    

00801989 <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  801989:	55                   	push   %ebp
  80198a:	89 e5                	mov    %esp,%ebp
  80198c:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  80198f:	ff 75 08             	pushl  0x8(%ebp)
  801992:	e8 54 fa ff ff       	call   8013eb <strlen>
  801997:	83 c4 04             	add    $0x4,%esp
  80199a:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  80199d:	ff 75 0c             	pushl  0xc(%ebp)
  8019a0:	e8 46 fa ff ff       	call   8013eb <strlen>
  8019a5:	83 c4 04             	add    $0x4,%esp
  8019a8:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  8019ab:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  8019b2:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8019b9:	eb 17                	jmp    8019d2 <strcconcat+0x49>
		final[s] = str1[s] ;
  8019bb:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8019be:	8b 45 10             	mov    0x10(%ebp),%eax
  8019c1:	01 c2                	add    %eax,%edx
  8019c3:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  8019c6:	8b 45 08             	mov    0x8(%ebp),%eax
  8019c9:	01 c8                	add    %ecx,%eax
  8019cb:	8a 00                	mov    (%eax),%al
  8019cd:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  8019cf:	ff 45 fc             	incl   -0x4(%ebp)
  8019d2:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8019d5:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  8019d8:	7c e1                	jl     8019bb <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  8019da:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  8019e1:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  8019e8:	eb 1f                	jmp    801a09 <strcconcat+0x80>
		final[s++] = str2[i] ;
  8019ea:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8019ed:	8d 50 01             	lea    0x1(%eax),%edx
  8019f0:	89 55 fc             	mov    %edx,-0x4(%ebp)
  8019f3:	89 c2                	mov    %eax,%edx
  8019f5:	8b 45 10             	mov    0x10(%ebp),%eax
  8019f8:	01 c2                	add    %eax,%edx
  8019fa:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  8019fd:	8b 45 0c             	mov    0xc(%ebp),%eax
  801a00:	01 c8                	add    %ecx,%eax
  801a02:	8a 00                	mov    (%eax),%al
  801a04:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  801a06:	ff 45 f8             	incl   -0x8(%ebp)
  801a09:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801a0c:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801a0f:	7c d9                	jl     8019ea <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  801a11:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801a14:	8b 45 10             	mov    0x10(%ebp),%eax
  801a17:	01 d0                	add    %edx,%eax
  801a19:	c6 00 00             	movb   $0x0,(%eax)
}
  801a1c:	90                   	nop
  801a1d:	c9                   	leave  
  801a1e:	c3                   	ret    

00801a1f <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  801a1f:	55                   	push   %ebp
  801a20:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  801a22:	8b 45 14             	mov    0x14(%ebp),%eax
  801a25:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  801a2b:	8b 45 14             	mov    0x14(%ebp),%eax
  801a2e:	8b 00                	mov    (%eax),%eax
  801a30:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801a37:	8b 45 10             	mov    0x10(%ebp),%eax
  801a3a:	01 d0                	add    %edx,%eax
  801a3c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801a42:	eb 0c                	jmp    801a50 <strsplit+0x31>
			*string++ = 0;
  801a44:	8b 45 08             	mov    0x8(%ebp),%eax
  801a47:	8d 50 01             	lea    0x1(%eax),%edx
  801a4a:	89 55 08             	mov    %edx,0x8(%ebp)
  801a4d:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801a50:	8b 45 08             	mov    0x8(%ebp),%eax
  801a53:	8a 00                	mov    (%eax),%al
  801a55:	84 c0                	test   %al,%al
  801a57:	74 18                	je     801a71 <strsplit+0x52>
  801a59:	8b 45 08             	mov    0x8(%ebp),%eax
  801a5c:	8a 00                	mov    (%eax),%al
  801a5e:	0f be c0             	movsbl %al,%eax
  801a61:	50                   	push   %eax
  801a62:	ff 75 0c             	pushl  0xc(%ebp)
  801a65:	e8 13 fb ff ff       	call   80157d <strchr>
  801a6a:	83 c4 08             	add    $0x8,%esp
  801a6d:	85 c0                	test   %eax,%eax
  801a6f:	75 d3                	jne    801a44 <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  801a71:	8b 45 08             	mov    0x8(%ebp),%eax
  801a74:	8a 00                	mov    (%eax),%al
  801a76:	84 c0                	test   %al,%al
  801a78:	74 5a                	je     801ad4 <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  801a7a:	8b 45 14             	mov    0x14(%ebp),%eax
  801a7d:	8b 00                	mov    (%eax),%eax
  801a7f:	83 f8 0f             	cmp    $0xf,%eax
  801a82:	75 07                	jne    801a8b <strsplit+0x6c>
		{
			return 0;
  801a84:	b8 00 00 00 00       	mov    $0x0,%eax
  801a89:	eb 66                	jmp    801af1 <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  801a8b:	8b 45 14             	mov    0x14(%ebp),%eax
  801a8e:	8b 00                	mov    (%eax),%eax
  801a90:	8d 48 01             	lea    0x1(%eax),%ecx
  801a93:	8b 55 14             	mov    0x14(%ebp),%edx
  801a96:	89 0a                	mov    %ecx,(%edx)
  801a98:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801a9f:	8b 45 10             	mov    0x10(%ebp),%eax
  801aa2:	01 c2                	add    %eax,%edx
  801aa4:	8b 45 08             	mov    0x8(%ebp),%eax
  801aa7:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  801aa9:	eb 03                	jmp    801aae <strsplit+0x8f>
			string++;
  801aab:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  801aae:	8b 45 08             	mov    0x8(%ebp),%eax
  801ab1:	8a 00                	mov    (%eax),%al
  801ab3:	84 c0                	test   %al,%al
  801ab5:	74 8b                	je     801a42 <strsplit+0x23>
  801ab7:	8b 45 08             	mov    0x8(%ebp),%eax
  801aba:	8a 00                	mov    (%eax),%al
  801abc:	0f be c0             	movsbl %al,%eax
  801abf:	50                   	push   %eax
  801ac0:	ff 75 0c             	pushl  0xc(%ebp)
  801ac3:	e8 b5 fa ff ff       	call   80157d <strchr>
  801ac8:	83 c4 08             	add    $0x8,%esp
  801acb:	85 c0                	test   %eax,%eax
  801acd:	74 dc                	je     801aab <strsplit+0x8c>
			string++;
	}
  801acf:	e9 6e ff ff ff       	jmp    801a42 <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  801ad4:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  801ad5:	8b 45 14             	mov    0x14(%ebp),%eax
  801ad8:	8b 00                	mov    (%eax),%eax
  801ada:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801ae1:	8b 45 10             	mov    0x10(%ebp),%eax
  801ae4:	01 d0                	add    %edx,%eax
  801ae6:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  801aec:	b8 01 00 00 00       	mov    $0x1,%eax
}
  801af1:	c9                   	leave  
  801af2:	c3                   	ret    

00801af3 <InitializeUHeap>:
//============================== GIVEN FUNCTIONS ===================================//
//==================================================================================//

int FirstTimeFlag = 1;
void InitializeUHeap()
{
  801af3:	55                   	push   %ebp
  801af4:	89 e5                	mov    %esp,%ebp
  801af6:	83 ec 08             	sub    $0x8,%esp
	if(FirstTimeFlag)
  801af9:	a1 04 50 80 00       	mov    0x805004,%eax
  801afe:	85 c0                	test   %eax,%eax
  801b00:	74 1f                	je     801b21 <InitializeUHeap+0x2e>
	{
		initialize_dyn_block_system();
  801b02:	e8 1d 00 00 00       	call   801b24 <initialize_dyn_block_system>
		cprintf("DYNAMIC BLOCK SYSTEM IS INITIALIZED\n");
  801b07:	83 ec 0c             	sub    $0xc,%esp
  801b0a:	68 50 40 80 00       	push   $0x804050
  801b0f:	e8 55 f2 ff ff       	call   800d69 <cprintf>
  801b14:	83 c4 10             	add    $0x10,%esp
#if UHP_USE_BUDDY
		initialize_buddy();
		cprintf("BUDDY SYSTEM IS INITIALIZED\n");
#endif
		FirstTimeFlag = 0;
  801b17:	c7 05 04 50 80 00 00 	movl   $0x0,0x805004
  801b1e:	00 00 00 
	}
}
  801b21:	90                   	nop
  801b22:	c9                   	leave  
  801b23:	c3                   	ret    

00801b24 <initialize_dyn_block_system>:

//=================================
// [1] INITIALIZE DYNAMIC ALLOCATOR:
//=================================
void initialize_dyn_block_system()
{
  801b24:	55                   	push   %ebp
  801b25:	89 e5                	mov    %esp,%ebp
  801b27:	83 ec 28             	sub    $0x28,%esp
	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] initialize_dyn_block_system
	// your code is here, remove the panic and write your code
	//panic("initialize_dyn_block_system() is not implemented yet...!!");

	LIST_INIT(&AllocMemBlocksList);
  801b2a:	c7 05 40 50 80 00 00 	movl   $0x0,0x805040
  801b31:	00 00 00 
  801b34:	c7 05 44 50 80 00 00 	movl   $0x0,0x805044
  801b3b:	00 00 00 
  801b3e:	c7 05 4c 50 80 00 00 	movl   $0x0,0x80504c
  801b45:	00 00 00 
	LIST_INIT(&FreeMemBlocksList);
  801b48:	c7 05 38 51 80 00 00 	movl   $0x0,0x805138
  801b4f:	00 00 00 
  801b52:	c7 05 3c 51 80 00 00 	movl   $0x0,0x80513c
  801b59:	00 00 00 
  801b5c:	c7 05 44 51 80 00 00 	movl   $0x0,0x805144
  801b63:	00 00 00 
	MAX_MEM_BLOCK_CNT = NUM_OF_UHEAP_PAGES;
  801b66:	c7 05 20 51 80 00 00 	movl   $0x20000,0x805120
  801b6d:	00 02 00 
	MemBlockNodes = (void*)USER_DYN_BLKS_ARRAY;
  801b70:	c7 45 f4 00 00 e0 7f 	movl   $0x7fe00000,-0xc(%ebp)
  801b77:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801b7a:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801b7f:	2d 00 10 00 00       	sub    $0x1000,%eax
  801b84:	a3 50 50 80 00       	mov    %eax,0x805050
	int size_of_block = sizeof(struct MemBlock);
  801b89:	c7 45 f0 10 00 00 00 	movl   $0x10,-0x10(%ebp)
	int size_all_struct = size_of_block*MAX_MEM_BLOCK_CNT;
  801b90:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801b93:	a1 20 51 80 00       	mov    0x805120,%eax
  801b98:	0f af c2             	imul   %edx,%eax
  801b9b:	89 45 ec             	mov    %eax,-0x14(%ebp)
	size_all_struct = ROUNDUP(size_all_struct, PAGE_SIZE);
  801b9e:	c7 45 e8 00 10 00 00 	movl   $0x1000,-0x18(%ebp)
  801ba5:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801ba8:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801bab:	01 d0                	add    %edx,%eax
  801bad:	48                   	dec    %eax
  801bae:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  801bb1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801bb4:	ba 00 00 00 00       	mov    $0x0,%edx
  801bb9:	f7 75 e8             	divl   -0x18(%ebp)
  801bbc:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801bbf:	29 d0                	sub    %edx,%eax
  801bc1:	89 45 ec             	mov    %eax,-0x14(%ebp)
	sys_allocate_chunk(USER_DYN_BLKS_ARRAY, size_all_struct,PERM_USER| PERM_WRITEABLE);
  801bc4:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801bc7:	c7 45 e0 00 00 e0 7f 	movl   $0x7fe00000,-0x20(%ebp)
  801bce:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801bd1:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
  801bd7:	81 ea 00 10 00 00    	sub    $0x1000,%edx
  801bdd:	83 ec 04             	sub    $0x4,%esp
  801be0:	6a 06                	push   $0x6
  801be2:	50                   	push   %eax
  801be3:	52                   	push   %edx
  801be4:	e8 a1 05 00 00       	call   80218a <sys_allocate_chunk>
  801be9:	83 c4 10             	add    $0x10,%esp
	initialize_MemBlocksList(MAX_MEM_BLOCK_CNT);
  801bec:	a1 20 51 80 00       	mov    0x805120,%eax
  801bf1:	83 ec 0c             	sub    $0xc,%esp
  801bf4:	50                   	push   %eax
  801bf5:	e8 16 0c 00 00       	call   802810 <initialize_MemBlocksList>
  801bfa:	83 c4 10             	add    $0x10,%esp
	struct MemBlock* ourBlock =LIST_LAST(&AvailableMemBlocksList);
  801bfd:	a1 4c 51 80 00       	mov    0x80514c,%eax
  801c02:	89 45 dc             	mov    %eax,-0x24(%ebp)
	LIST_REMOVE(&AvailableMemBlocksList,ourBlock);
  801c05:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  801c09:	75 14                	jne    801c1f <initialize_dyn_block_system+0xfb>
  801c0b:	83 ec 04             	sub    $0x4,%esp
  801c0e:	68 75 40 80 00       	push   $0x804075
  801c13:	6a 2d                	push   $0x2d
  801c15:	68 93 40 80 00       	push   $0x804093
  801c1a:	e8 96 ee ff ff       	call   800ab5 <_panic>
  801c1f:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801c22:	8b 00                	mov    (%eax),%eax
  801c24:	85 c0                	test   %eax,%eax
  801c26:	74 10                	je     801c38 <initialize_dyn_block_system+0x114>
  801c28:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801c2b:	8b 00                	mov    (%eax),%eax
  801c2d:	8b 55 dc             	mov    -0x24(%ebp),%edx
  801c30:	8b 52 04             	mov    0x4(%edx),%edx
  801c33:	89 50 04             	mov    %edx,0x4(%eax)
  801c36:	eb 0b                	jmp    801c43 <initialize_dyn_block_system+0x11f>
  801c38:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801c3b:	8b 40 04             	mov    0x4(%eax),%eax
  801c3e:	a3 4c 51 80 00       	mov    %eax,0x80514c
  801c43:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801c46:	8b 40 04             	mov    0x4(%eax),%eax
  801c49:	85 c0                	test   %eax,%eax
  801c4b:	74 0f                	je     801c5c <initialize_dyn_block_system+0x138>
  801c4d:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801c50:	8b 40 04             	mov    0x4(%eax),%eax
  801c53:	8b 55 dc             	mov    -0x24(%ebp),%edx
  801c56:	8b 12                	mov    (%edx),%edx
  801c58:	89 10                	mov    %edx,(%eax)
  801c5a:	eb 0a                	jmp    801c66 <initialize_dyn_block_system+0x142>
  801c5c:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801c5f:	8b 00                	mov    (%eax),%eax
  801c61:	a3 48 51 80 00       	mov    %eax,0x805148
  801c66:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801c69:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  801c6f:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801c72:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  801c79:	a1 54 51 80 00       	mov    0x805154,%eax
  801c7e:	48                   	dec    %eax
  801c7f:	a3 54 51 80 00       	mov    %eax,0x805154
	ourBlock->size = USER_HEAP_MAX-USER_HEAP_START;
  801c84:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801c87:	c7 40 0c 00 00 00 20 	movl   $0x20000000,0xc(%eax)
	ourBlock->sva=USER_HEAP_START;
  801c8e:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801c91:	c7 40 08 00 00 00 80 	movl   $0x80000000,0x8(%eax)
	LIST_INSERT_TAIL(&FreeMemBlocksList, ourBlock);
  801c98:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  801c9c:	75 14                	jne    801cb2 <initialize_dyn_block_system+0x18e>
  801c9e:	83 ec 04             	sub    $0x4,%esp
  801ca1:	68 a0 40 80 00       	push   $0x8040a0
  801ca6:	6a 30                	push   $0x30
  801ca8:	68 93 40 80 00       	push   $0x804093
  801cad:	e8 03 ee ff ff       	call   800ab5 <_panic>
  801cb2:	8b 15 3c 51 80 00    	mov    0x80513c,%edx
  801cb8:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801cbb:	89 50 04             	mov    %edx,0x4(%eax)
  801cbe:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801cc1:	8b 40 04             	mov    0x4(%eax),%eax
  801cc4:	85 c0                	test   %eax,%eax
  801cc6:	74 0c                	je     801cd4 <initialize_dyn_block_system+0x1b0>
  801cc8:	a1 3c 51 80 00       	mov    0x80513c,%eax
  801ccd:	8b 55 dc             	mov    -0x24(%ebp),%edx
  801cd0:	89 10                	mov    %edx,(%eax)
  801cd2:	eb 08                	jmp    801cdc <initialize_dyn_block_system+0x1b8>
  801cd4:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801cd7:	a3 38 51 80 00       	mov    %eax,0x805138
  801cdc:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801cdf:	a3 3c 51 80 00       	mov    %eax,0x80513c
  801ce4:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801ce7:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  801ced:	a1 44 51 80 00       	mov    0x805144,%eax
  801cf2:	40                   	inc    %eax
  801cf3:	a3 44 51 80 00       	mov    %eax,0x805144
	//[1] Initialize two lists (AllocMemBlocksList & FreeMemBlocksList) [Hint: use LIST_INIT()]
	//[2] Dynamically allocate the array of MemBlockNodes at VA USER_DYN_BLKS_ARRAY
	//	  (remember to set MAX_MEM_BLOCK_CNT with the chosen size of the array)
	//[3] Initialize AvailableMemBlocksList by filling it with the MemBlockNodes
	//[4] Insert a new MemBlock with the heap size into the FreeMemBlocksList
}
  801cf8:	90                   	nop
  801cf9:	c9                   	leave  
  801cfa:	c3                   	ret    

00801cfb <malloc>:
//=================================
// [2] ALLOCATE SPACE IN USER HEAP:
//=================================

void* malloc(uint32 size)
{
  801cfb:	55                   	push   %ebp
  801cfc:	89 e5                	mov    %esp,%ebp
  801cfe:	83 ec 18             	sub    $0x18,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801d01:	e8 ed fd ff ff       	call   801af3 <InitializeUHeap>
	if (size == 0) return NULL ;
  801d06:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801d0a:	75 07                	jne    801d13 <malloc+0x18>
  801d0c:	b8 00 00 00 00       	mov    $0x0,%eax
  801d11:	eb 67                	jmp    801d7a <malloc+0x7f>

	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] malloc
	// your code is here, remove the panic and write your code
	//panic("malloc() is not implemented yet...!!");

	size = ROUNDUP(size, PAGE_SIZE);
  801d13:	c7 45 f4 00 10 00 00 	movl   $0x1000,-0xc(%ebp)
  801d1a:	8b 55 08             	mov    0x8(%ebp),%edx
  801d1d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801d20:	01 d0                	add    %edx,%eax
  801d22:	48                   	dec    %eax
  801d23:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801d26:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801d29:	ba 00 00 00 00       	mov    $0x0,%edx
  801d2e:	f7 75 f4             	divl   -0xc(%ebp)
  801d31:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801d34:	29 d0                	sub    %edx,%eax
  801d36:	89 45 08             	mov    %eax,0x8(%ebp)
	if(sys_isUHeapPlacementStrategyFIRSTFIT())
  801d39:	e8 1a 08 00 00       	call   802558 <sys_isUHeapPlacementStrategyFIRSTFIT>
  801d3e:	85 c0                	test   %eax,%eax
  801d40:	74 33                	je     801d75 <malloc+0x7a>
	{
		struct MemBlock * myBlock = alloc_block_FF(size);
  801d42:	83 ec 0c             	sub    $0xc,%esp
  801d45:	ff 75 08             	pushl  0x8(%ebp)
  801d48:	e8 0c 0e 00 00       	call   802b59 <alloc_block_FF>
  801d4d:	83 c4 10             	add    $0x10,%esp
  801d50:	89 45 ec             	mov    %eax,-0x14(%ebp)
		if(myBlock != NULL)
  801d53:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  801d57:	74 1c                	je     801d75 <malloc+0x7a>
		{
			insert_sorted_allocList(myBlock);
  801d59:	83 ec 0c             	sub    $0xc,%esp
  801d5c:	ff 75 ec             	pushl  -0x14(%ebp)
  801d5f:	e8 07 0c 00 00       	call   80296b <insert_sorted_allocList>
  801d64:	83 c4 10             	add    $0x10,%esp
			uint32 ptr = myBlock->sva;
  801d67:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801d6a:	8b 40 08             	mov    0x8(%eax),%eax
  801d6d:	89 45 e8             	mov    %eax,-0x18(%ebp)
			return (void *)ptr;
  801d70:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801d73:	eb 05                	jmp    801d7a <malloc+0x7f>
		}
	}
	return NULL;
  801d75:	b8 00 00 00 00       	mov    $0x0,%eax
	//		to the required allocation size (space should be on 4 KB BOUNDARY)
	//	2) if no suitable space found, return NULL
	// 	3) Return pointer containing the virtual address of allocated space,
	//
	//Use sys_isUHeapPlacementStrategyFIRSTFIT()... to check the current strategy
}
  801d7a:	c9                   	leave  
  801d7b:	c3                   	ret    

00801d7c <free>:
//	We can use sys_free_user_mem(uint32 virtual_address, uint32 size); which
//		switches to the kernel mode, calls free_user_mem() in
//		"kern/mem/chunk_operations.c", then switch back to the user mode here
//	the free_user_mem function is empty, make sure to implement it.
void free(void* virtual_address)
{
  801d7c:	55                   	push   %ebp
  801d7d:	89 e5                	mov    %esp,%ebp
  801d7f:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] free
	// your code is here, remove the panic and write your code
	//panic("free() is not implemented yet...!!");

	uint32 virtualAddress = (uint32 )(virtual_address);
  801d82:	8b 45 08             	mov    0x8(%ebp),%eax
  801d85:	89 45 f4             	mov    %eax,-0xc(%ebp)
//	virtualAddress = ROUNDDOWN(virtualAddress, PAGE_SIZE);
	struct MemBlock * myBlock = find_block(&AllocMemBlocksList, virtualAddress);
  801d88:	83 ec 08             	sub    $0x8,%esp
  801d8b:	ff 75 f4             	pushl  -0xc(%ebp)
  801d8e:	68 40 50 80 00       	push   $0x805040
  801d93:	e8 5b 0b 00 00       	call   8028f3 <find_block>
  801d98:	83 c4 10             	add    $0x10,%esp
  801d9b:	89 45 f0             	mov    %eax,-0x10(%ebp)
//	cprintf ("ptr sva at free user side = %x \n", myBlock->sva);
	sys_free_user_mem(virtualAddress, myBlock->size);
  801d9e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801da1:	8b 40 0c             	mov    0xc(%eax),%eax
  801da4:	83 ec 08             	sub    $0x8,%esp
  801da7:	50                   	push   %eax
  801da8:	ff 75 f4             	pushl  -0xc(%ebp)
  801dab:	e8 a2 03 00 00       	call   802152 <sys_free_user_mem>
  801db0:	83 c4 10             	add    $0x10,%esp
	LIST_REMOVE(&AllocMemBlocksList, myBlock);
  801db3:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801db7:	75 14                	jne    801dcd <free+0x51>
  801db9:	83 ec 04             	sub    $0x4,%esp
  801dbc:	68 75 40 80 00       	push   $0x804075
  801dc1:	6a 76                	push   $0x76
  801dc3:	68 93 40 80 00       	push   $0x804093
  801dc8:	e8 e8 ec ff ff       	call   800ab5 <_panic>
  801dcd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801dd0:	8b 00                	mov    (%eax),%eax
  801dd2:	85 c0                	test   %eax,%eax
  801dd4:	74 10                	je     801de6 <free+0x6a>
  801dd6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801dd9:	8b 00                	mov    (%eax),%eax
  801ddb:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801dde:	8b 52 04             	mov    0x4(%edx),%edx
  801de1:	89 50 04             	mov    %edx,0x4(%eax)
  801de4:	eb 0b                	jmp    801df1 <free+0x75>
  801de6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801de9:	8b 40 04             	mov    0x4(%eax),%eax
  801dec:	a3 44 50 80 00       	mov    %eax,0x805044
  801df1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801df4:	8b 40 04             	mov    0x4(%eax),%eax
  801df7:	85 c0                	test   %eax,%eax
  801df9:	74 0f                	je     801e0a <free+0x8e>
  801dfb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801dfe:	8b 40 04             	mov    0x4(%eax),%eax
  801e01:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801e04:	8b 12                	mov    (%edx),%edx
  801e06:	89 10                	mov    %edx,(%eax)
  801e08:	eb 0a                	jmp    801e14 <free+0x98>
  801e0a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801e0d:	8b 00                	mov    (%eax),%eax
  801e0f:	a3 40 50 80 00       	mov    %eax,0x805040
  801e14:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801e17:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  801e1d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801e20:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  801e27:	a1 4c 50 80 00       	mov    0x80504c,%eax
  801e2c:	48                   	dec    %eax
  801e2d:	a3 4c 50 80 00       	mov    %eax,0x80504c
	insert_sorted_with_merge_freeList(myBlock);
  801e32:	83 ec 0c             	sub    $0xc,%esp
  801e35:	ff 75 f0             	pushl  -0x10(%ebp)
  801e38:	e8 0b 14 00 00       	call   803248 <insert_sorted_with_merge_freeList>
  801e3d:	83 c4 10             	add    $0x10,%esp

	//you should get the size of the given allocation using its address
	//you need to call sys_free_user_mem()
	//refer to the project presentation and documentation for details
}
  801e40:	90                   	nop
  801e41:	c9                   	leave  
  801e42:	c3                   	ret    

00801e43 <smalloc>:

//=================================
// [4] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
  801e43:	55                   	push   %ebp
  801e44:	89 e5                	mov    %esp,%ebp
  801e46:	83 ec 28             	sub    $0x28,%esp
  801e49:	8b 45 10             	mov    0x10(%ebp),%eax
  801e4c:	88 45 e4             	mov    %al,-0x1c(%ebp)
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801e4f:	e8 9f fc ff ff       	call   801af3 <InitializeUHeap>
	if (size == 0) return NULL ;
  801e54:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801e58:	75 0a                	jne    801e64 <smalloc+0x21>
  801e5a:	b8 00 00 00 00       	mov    $0x0,%eax
  801e5f:	e9 8d 00 00 00       	jmp    801ef1 <smalloc+0xae>

	//This function should find the space of the required range
	// * ON 4KB BOUNDARY **** //
	//Use sys_isUHeapPlacementStrategyFIRSTFIT() to check the current strategy

	size = ROUNDUP(size, PAGE_SIZE);
  801e64:	c7 45 f4 00 10 00 00 	movl   $0x1000,-0xc(%ebp)
  801e6b:	8b 55 0c             	mov    0xc(%ebp),%edx
  801e6e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e71:	01 d0                	add    %edx,%eax
  801e73:	48                   	dec    %eax
  801e74:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801e77:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801e7a:	ba 00 00 00 00       	mov    $0x0,%edx
  801e7f:	f7 75 f4             	divl   -0xc(%ebp)
  801e82:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801e85:	29 d0                	sub    %edx,%eax
  801e87:	89 45 0c             	mov    %eax,0xc(%ebp)
		if(sys_isUHeapPlacementStrategyFIRSTFIT())
  801e8a:	e8 c9 06 00 00       	call   802558 <sys_isUHeapPlacementStrategyFIRSTFIT>
  801e8f:	85 c0                	test   %eax,%eax
  801e91:	74 59                	je     801eec <smalloc+0xa9>
		{
			struct MemBlock * v1=NULL;
  801e93:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
			v1= alloc_block_FF(size);
  801e9a:	83 ec 0c             	sub    $0xc,%esp
  801e9d:	ff 75 0c             	pushl  0xc(%ebp)
  801ea0:	e8 b4 0c 00 00       	call   802b59 <alloc_block_FF>
  801ea5:	83 c4 10             	add    $0x10,%esp
  801ea8:	89 45 ec             	mov    %eax,-0x14(%ebp)
			if(v1==NULL)
  801eab:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  801eaf:	75 07                	jne    801eb8 <smalloc+0x75>
			{
				return NULL;
  801eb1:	b8 00 00 00 00       	mov    $0x0,%eax
  801eb6:	eb 39                	jmp    801ef1 <smalloc+0xae>
			}
			else
			{
				int ret=sys_createSharedObject(sharedVarName,  size,  isWritable,(void*)v1->sva);
  801eb8:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801ebb:	8b 40 08             	mov    0x8(%eax),%eax
  801ebe:	89 c2                	mov    %eax,%edx
  801ec0:	0f b6 45 e4          	movzbl -0x1c(%ebp),%eax
  801ec4:	52                   	push   %edx
  801ec5:	50                   	push   %eax
  801ec6:	ff 75 0c             	pushl  0xc(%ebp)
  801ec9:	ff 75 08             	pushl  0x8(%ebp)
  801ecc:	e8 0c 04 00 00       	call   8022dd <sys_createSharedObject>
  801ed1:	83 c4 10             	add    $0x10,%esp
  801ed4:	89 45 e8             	mov    %eax,-0x18(%ebp)
				if(ret>=0)
  801ed7:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  801edb:	78 08                	js     801ee5 <smalloc+0xa2>
				{
					return (void*)v1->sva;
  801edd:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801ee0:	8b 40 08             	mov    0x8(%eax),%eax
  801ee3:	eb 0c                	jmp    801ef1 <smalloc+0xae>
				}
				else
				{
					return NULL;
  801ee5:	b8 00 00 00 00       	mov    $0x0,%eax
  801eea:	eb 05                	jmp    801ef1 <smalloc+0xae>
				}
			}

		}
		return NULL;
  801eec:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801ef1:	c9                   	leave  
  801ef2:	c3                   	ret    

00801ef3 <sget>:

//========================================
// [5] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  801ef3:	55                   	push   %ebp
  801ef4:	89 e5                	mov    %esp,%ebp
  801ef6:	83 ec 18             	sub    $0x18,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801ef9:	e8 f5 fb ff ff       	call   801af3 <InitializeUHeap>

	//This function should find the space for sharing the variable
	// *** ON 4KB BOUNDARY ******** //

	//Use sys_isUHeapPlacementStrategyFIRSTFIT() to check the current strategy
	int ret=sys_getSizeOfSharedObject(ownerEnvID,sharedVarName);
  801efe:	83 ec 08             	sub    $0x8,%esp
  801f01:	ff 75 0c             	pushl  0xc(%ebp)
  801f04:	ff 75 08             	pushl  0x8(%ebp)
  801f07:	e8 fb 03 00 00       	call   802307 <sys_getSizeOfSharedObject>
  801f0c:	83 c4 10             	add    $0x10,%esp
  801f0f:	89 45 f4             	mov    %eax,-0xc(%ebp)
	if(ret==0)
  801f12:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801f16:	75 07                	jne    801f1f <sget+0x2c>
	{
		return NULL;
  801f18:	b8 00 00 00 00       	mov    $0x0,%eax
  801f1d:	eb 64                	jmp    801f83 <sget+0x90>
	}
	if(sys_isUHeapPlacementStrategyFIRSTFIT())
  801f1f:	e8 34 06 00 00       	call   802558 <sys_isUHeapPlacementStrategyFIRSTFIT>
  801f24:	85 c0                	test   %eax,%eax
  801f26:	74 56                	je     801f7e <sget+0x8b>
	{
		struct MemBlock * v1=NULL;
  801f28:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
		v1= alloc_block_FF(ret);
  801f2f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f32:	83 ec 0c             	sub    $0xc,%esp
  801f35:	50                   	push   %eax
  801f36:	e8 1e 0c 00 00       	call   802b59 <alloc_block_FF>
  801f3b:	83 c4 10             	add    $0x10,%esp
  801f3e:	89 45 f0             	mov    %eax,-0x10(%ebp)
		if(v1==NULL)
  801f41:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801f45:	75 07                	jne    801f4e <sget+0x5b>
		{
		return NULL;
  801f47:	b8 00 00 00 00       	mov    $0x0,%eax
  801f4c:	eb 35                	jmp    801f83 <sget+0x90>
	    }
		else
		{
			int ret1=sys_getSharedObject(ownerEnvID,sharedVarName,(void*)v1->sva);
  801f4e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801f51:	8b 40 08             	mov    0x8(%eax),%eax
  801f54:	83 ec 04             	sub    $0x4,%esp
  801f57:	50                   	push   %eax
  801f58:	ff 75 0c             	pushl  0xc(%ebp)
  801f5b:	ff 75 08             	pushl  0x8(%ebp)
  801f5e:	e8 c1 03 00 00       	call   802324 <sys_getSharedObject>
  801f63:	83 c4 10             	add    $0x10,%esp
  801f66:	89 45 ec             	mov    %eax,-0x14(%ebp)
			if(ret1>=0)
  801f69:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  801f6d:	78 08                	js     801f77 <sget+0x84>
			{
				return (void*)v1->sva;
  801f6f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801f72:	8b 40 08             	mov    0x8(%eax),%eax
  801f75:	eb 0c                	jmp    801f83 <sget+0x90>
			}
			else
			{
				return NULL;
  801f77:	b8 00 00 00 00       	mov    $0x0,%eax
  801f7c:	eb 05                	jmp    801f83 <sget+0x90>
			}
		}
	}
  return NULL;
  801f7e:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801f83:	c9                   	leave  
  801f84:	c3                   	ret    

00801f85 <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  801f85:	55                   	push   %ebp
  801f86:	89 e5                	mov    %esp,%ebp
  801f88:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801f8b:	e8 63 fb ff ff       	call   801af3 <InitializeUHeap>
	//==============================================================
	// [USER HEAP - USER SIDE] realloc
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  801f90:	83 ec 04             	sub    $0x4,%esp
  801f93:	68 c4 40 80 00       	push   $0x8040c4
  801f98:	68 0e 01 00 00       	push   $0x10e
  801f9d:	68 93 40 80 00       	push   $0x804093
  801fa2:	e8 0e eb ff ff       	call   800ab5 <_panic>

00801fa7 <sfree>:
//	use sys_freeSharedObject(...); which switches to the kernel mode,
//	calls freeSharedObject(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the freeSharedObject() function is empty, make sure to implement it.

void sfree(void* virtual_address)
{
  801fa7:	55                   	push   %ebp
  801fa8:	89 e5                	mov    %esp,%ebp
  801faa:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS3 - BONUS] [SHARING - USER SIDE] sfree()

	// Write your code here, remove the panic and write your code
	panic("sfree() is not implemented yet...!!");
  801fad:	83 ec 04             	sub    $0x4,%esp
  801fb0:	68 ec 40 80 00       	push   $0x8040ec
  801fb5:	68 22 01 00 00       	push   $0x122
  801fba:	68 93 40 80 00       	push   $0x804093
  801fbf:	e8 f1 ea ff ff       	call   800ab5 <_panic>

00801fc4 <expand>:

//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//
void expand(uint32 newSize)
{
  801fc4:	55                   	push   %ebp
  801fc5:	89 e5                	mov    %esp,%ebp
  801fc7:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801fca:	83 ec 04             	sub    $0x4,%esp
  801fcd:	68 10 41 80 00       	push   $0x804110
  801fd2:	68 2d 01 00 00       	push   $0x12d
  801fd7:	68 93 40 80 00       	push   $0x804093
  801fdc:	e8 d4 ea ff ff       	call   800ab5 <_panic>

00801fe1 <shrink>:

}
void shrink(uint32 newSize)
{
  801fe1:	55                   	push   %ebp
  801fe2:	89 e5                	mov    %esp,%ebp
  801fe4:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801fe7:	83 ec 04             	sub    $0x4,%esp
  801fea:	68 10 41 80 00       	push   $0x804110
  801fef:	68 32 01 00 00       	push   $0x132
  801ff4:	68 93 40 80 00       	push   $0x804093
  801ff9:	e8 b7 ea ff ff       	call   800ab5 <_panic>

00801ffe <freeHeap>:

}
void freeHeap(void* virtual_address)
{
  801ffe:	55                   	push   %ebp
  801fff:	89 e5                	mov    %esp,%ebp
  802001:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  802004:	83 ec 04             	sub    $0x4,%esp
  802007:	68 10 41 80 00       	push   $0x804110
  80200c:	68 37 01 00 00       	push   $0x137
  802011:	68 93 40 80 00       	push   $0x804093
  802016:	e8 9a ea ff ff       	call   800ab5 <_panic>

0080201b <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  80201b:	55                   	push   %ebp
  80201c:	89 e5                	mov    %esp,%ebp
  80201e:	57                   	push   %edi
  80201f:	56                   	push   %esi
  802020:	53                   	push   %ebx
  802021:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  802024:	8b 45 08             	mov    0x8(%ebp),%eax
  802027:	8b 55 0c             	mov    0xc(%ebp),%edx
  80202a:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80202d:	8b 5d 14             	mov    0x14(%ebp),%ebx
  802030:	8b 7d 18             	mov    0x18(%ebp),%edi
  802033:	8b 75 1c             	mov    0x1c(%ebp),%esi
  802036:	cd 30                	int    $0x30
  802038:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  80203b:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  80203e:	83 c4 10             	add    $0x10,%esp
  802041:	5b                   	pop    %ebx
  802042:	5e                   	pop    %esi
  802043:	5f                   	pop    %edi
  802044:	5d                   	pop    %ebp
  802045:	c3                   	ret    

00802046 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  802046:	55                   	push   %ebp
  802047:	89 e5                	mov    %esp,%ebp
  802049:	83 ec 04             	sub    $0x4,%esp
  80204c:	8b 45 10             	mov    0x10(%ebp),%eax
  80204f:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  802052:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  802056:	8b 45 08             	mov    0x8(%ebp),%eax
  802059:	6a 00                	push   $0x0
  80205b:	6a 00                	push   $0x0
  80205d:	52                   	push   %edx
  80205e:	ff 75 0c             	pushl  0xc(%ebp)
  802061:	50                   	push   %eax
  802062:	6a 00                	push   $0x0
  802064:	e8 b2 ff ff ff       	call   80201b <syscall>
  802069:	83 c4 18             	add    $0x18,%esp
}
  80206c:	90                   	nop
  80206d:	c9                   	leave  
  80206e:	c3                   	ret    

0080206f <sys_cgetc>:

int
sys_cgetc(void)
{
  80206f:	55                   	push   %ebp
  802070:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  802072:	6a 00                	push   $0x0
  802074:	6a 00                	push   $0x0
  802076:	6a 00                	push   $0x0
  802078:	6a 00                	push   $0x0
  80207a:	6a 00                	push   $0x0
  80207c:	6a 01                	push   $0x1
  80207e:	e8 98 ff ff ff       	call   80201b <syscall>
  802083:	83 c4 18             	add    $0x18,%esp
}
  802086:	c9                   	leave  
  802087:	c3                   	ret    

00802088 <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  802088:	55                   	push   %ebp
  802089:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  80208b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80208e:	8b 45 08             	mov    0x8(%ebp),%eax
  802091:	6a 00                	push   $0x0
  802093:	6a 00                	push   $0x0
  802095:	6a 00                	push   $0x0
  802097:	52                   	push   %edx
  802098:	50                   	push   %eax
  802099:	6a 05                	push   $0x5
  80209b:	e8 7b ff ff ff       	call   80201b <syscall>
  8020a0:	83 c4 18             	add    $0x18,%esp
}
  8020a3:	c9                   	leave  
  8020a4:	c3                   	ret    

008020a5 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  8020a5:	55                   	push   %ebp
  8020a6:	89 e5                	mov    %esp,%ebp
  8020a8:	56                   	push   %esi
  8020a9:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  8020aa:	8b 75 18             	mov    0x18(%ebp),%esi
  8020ad:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8020b0:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8020b3:	8b 55 0c             	mov    0xc(%ebp),%edx
  8020b6:	8b 45 08             	mov    0x8(%ebp),%eax
  8020b9:	56                   	push   %esi
  8020ba:	53                   	push   %ebx
  8020bb:	51                   	push   %ecx
  8020bc:	52                   	push   %edx
  8020bd:	50                   	push   %eax
  8020be:	6a 06                	push   $0x6
  8020c0:	e8 56 ff ff ff       	call   80201b <syscall>
  8020c5:	83 c4 18             	add    $0x18,%esp
}
  8020c8:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8020cb:	5b                   	pop    %ebx
  8020cc:	5e                   	pop    %esi
  8020cd:	5d                   	pop    %ebp
  8020ce:	c3                   	ret    

008020cf <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  8020cf:	55                   	push   %ebp
  8020d0:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  8020d2:	8b 55 0c             	mov    0xc(%ebp),%edx
  8020d5:	8b 45 08             	mov    0x8(%ebp),%eax
  8020d8:	6a 00                	push   $0x0
  8020da:	6a 00                	push   $0x0
  8020dc:	6a 00                	push   $0x0
  8020de:	52                   	push   %edx
  8020df:	50                   	push   %eax
  8020e0:	6a 07                	push   $0x7
  8020e2:	e8 34 ff ff ff       	call   80201b <syscall>
  8020e7:	83 c4 18             	add    $0x18,%esp
}
  8020ea:	c9                   	leave  
  8020eb:	c3                   	ret    

008020ec <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  8020ec:	55                   	push   %ebp
  8020ed:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  8020ef:	6a 00                	push   $0x0
  8020f1:	6a 00                	push   $0x0
  8020f3:	6a 00                	push   $0x0
  8020f5:	ff 75 0c             	pushl  0xc(%ebp)
  8020f8:	ff 75 08             	pushl  0x8(%ebp)
  8020fb:	6a 08                	push   $0x8
  8020fd:	e8 19 ff ff ff       	call   80201b <syscall>
  802102:	83 c4 18             	add    $0x18,%esp
}
  802105:	c9                   	leave  
  802106:	c3                   	ret    

00802107 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  802107:	55                   	push   %ebp
  802108:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  80210a:	6a 00                	push   $0x0
  80210c:	6a 00                	push   $0x0
  80210e:	6a 00                	push   $0x0
  802110:	6a 00                	push   $0x0
  802112:	6a 00                	push   $0x0
  802114:	6a 09                	push   $0x9
  802116:	e8 00 ff ff ff       	call   80201b <syscall>
  80211b:	83 c4 18             	add    $0x18,%esp
}
  80211e:	c9                   	leave  
  80211f:	c3                   	ret    

00802120 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  802120:	55                   	push   %ebp
  802121:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  802123:	6a 00                	push   $0x0
  802125:	6a 00                	push   $0x0
  802127:	6a 00                	push   $0x0
  802129:	6a 00                	push   $0x0
  80212b:	6a 00                	push   $0x0
  80212d:	6a 0a                	push   $0xa
  80212f:	e8 e7 fe ff ff       	call   80201b <syscall>
  802134:	83 c4 18             	add    $0x18,%esp
}
  802137:	c9                   	leave  
  802138:	c3                   	ret    

00802139 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  802139:	55                   	push   %ebp
  80213a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  80213c:	6a 00                	push   $0x0
  80213e:	6a 00                	push   $0x0
  802140:	6a 00                	push   $0x0
  802142:	6a 00                	push   $0x0
  802144:	6a 00                	push   $0x0
  802146:	6a 0b                	push   $0xb
  802148:	e8 ce fe ff ff       	call   80201b <syscall>
  80214d:	83 c4 18             	add    $0x18,%esp
}
  802150:	c9                   	leave  
  802151:	c3                   	ret    

00802152 <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  802152:	55                   	push   %ebp
  802153:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  802155:	6a 00                	push   $0x0
  802157:	6a 00                	push   $0x0
  802159:	6a 00                	push   $0x0
  80215b:	ff 75 0c             	pushl  0xc(%ebp)
  80215e:	ff 75 08             	pushl  0x8(%ebp)
  802161:	6a 0f                	push   $0xf
  802163:	e8 b3 fe ff ff       	call   80201b <syscall>
  802168:	83 c4 18             	add    $0x18,%esp
	return;
  80216b:	90                   	nop
}
  80216c:	c9                   	leave  
  80216d:	c3                   	ret    

0080216e <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  80216e:	55                   	push   %ebp
  80216f:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  802171:	6a 00                	push   $0x0
  802173:	6a 00                	push   $0x0
  802175:	6a 00                	push   $0x0
  802177:	ff 75 0c             	pushl  0xc(%ebp)
  80217a:	ff 75 08             	pushl  0x8(%ebp)
  80217d:	6a 10                	push   $0x10
  80217f:	e8 97 fe ff ff       	call   80201b <syscall>
  802184:	83 c4 18             	add    $0x18,%esp
	return ;
  802187:	90                   	nop
}
  802188:	c9                   	leave  
  802189:	c3                   	ret    

0080218a <sys_allocate_chunk>:

void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  80218a:	55                   	push   %ebp
  80218b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  80218d:	6a 00                	push   $0x0
  80218f:	6a 00                	push   $0x0
  802191:	ff 75 10             	pushl  0x10(%ebp)
  802194:	ff 75 0c             	pushl  0xc(%ebp)
  802197:	ff 75 08             	pushl  0x8(%ebp)
  80219a:	6a 11                	push   $0x11
  80219c:	e8 7a fe ff ff       	call   80201b <syscall>
  8021a1:	83 c4 18             	add    $0x18,%esp
	return ;
  8021a4:	90                   	nop
}
  8021a5:	c9                   	leave  
  8021a6:	c3                   	ret    

008021a7 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  8021a7:	55                   	push   %ebp
  8021a8:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  8021aa:	6a 00                	push   $0x0
  8021ac:	6a 00                	push   $0x0
  8021ae:	6a 00                	push   $0x0
  8021b0:	6a 00                	push   $0x0
  8021b2:	6a 00                	push   $0x0
  8021b4:	6a 0c                	push   $0xc
  8021b6:	e8 60 fe ff ff       	call   80201b <syscall>
  8021bb:	83 c4 18             	add    $0x18,%esp
}
  8021be:	c9                   	leave  
  8021bf:	c3                   	ret    

008021c0 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  8021c0:	55                   	push   %ebp
  8021c1:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  8021c3:	6a 00                	push   $0x0
  8021c5:	6a 00                	push   $0x0
  8021c7:	6a 00                	push   $0x0
  8021c9:	6a 00                	push   $0x0
  8021cb:	ff 75 08             	pushl  0x8(%ebp)
  8021ce:	6a 0d                	push   $0xd
  8021d0:	e8 46 fe ff ff       	call   80201b <syscall>
  8021d5:	83 c4 18             	add    $0x18,%esp
}
  8021d8:	c9                   	leave  
  8021d9:	c3                   	ret    

008021da <sys_scarce_memory>:

void sys_scarce_memory()
{
  8021da:	55                   	push   %ebp
  8021db:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  8021dd:	6a 00                	push   $0x0
  8021df:	6a 00                	push   $0x0
  8021e1:	6a 00                	push   $0x0
  8021e3:	6a 00                	push   $0x0
  8021e5:	6a 00                	push   $0x0
  8021e7:	6a 0e                	push   $0xe
  8021e9:	e8 2d fe ff ff       	call   80201b <syscall>
  8021ee:	83 c4 18             	add    $0x18,%esp
}
  8021f1:	90                   	nop
  8021f2:	c9                   	leave  
  8021f3:	c3                   	ret    

008021f4 <sys_disable_interrupt>:

//NEW !! 2012...
void
sys_disable_interrupt()
{
  8021f4:	55                   	push   %ebp
  8021f5:	89 e5                	mov    %esp,%ebp
	syscall(SYS_disableINTR,0, 0, 0, 0, 0);
  8021f7:	6a 00                	push   $0x0
  8021f9:	6a 00                	push   $0x0
  8021fb:	6a 00                	push   $0x0
  8021fd:	6a 00                	push   $0x0
  8021ff:	6a 00                	push   $0x0
  802201:	6a 13                	push   $0x13
  802203:	e8 13 fe ff ff       	call   80201b <syscall>
  802208:	83 c4 18             	add    $0x18,%esp
}
  80220b:	90                   	nop
  80220c:	c9                   	leave  
  80220d:	c3                   	ret    

0080220e <sys_enable_interrupt>:


void
sys_enable_interrupt()
{
  80220e:	55                   	push   %ebp
  80220f:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enableINTR,0, 0, 0, 0, 0);
  802211:	6a 00                	push   $0x0
  802213:	6a 00                	push   $0x0
  802215:	6a 00                	push   $0x0
  802217:	6a 00                	push   $0x0
  802219:	6a 00                	push   $0x0
  80221b:	6a 14                	push   $0x14
  80221d:	e8 f9 fd ff ff       	call   80201b <syscall>
  802222:	83 c4 18             	add    $0x18,%esp
}
  802225:	90                   	nop
  802226:	c9                   	leave  
  802227:	c3                   	ret    

00802228 <sys_cputc>:


void
sys_cputc(const char c)
{
  802228:	55                   	push   %ebp
  802229:	89 e5                	mov    %esp,%ebp
  80222b:	83 ec 04             	sub    $0x4,%esp
  80222e:	8b 45 08             	mov    0x8(%ebp),%eax
  802231:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  802234:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  802238:	6a 00                	push   $0x0
  80223a:	6a 00                	push   $0x0
  80223c:	6a 00                	push   $0x0
  80223e:	6a 00                	push   $0x0
  802240:	50                   	push   %eax
  802241:	6a 15                	push   $0x15
  802243:	e8 d3 fd ff ff       	call   80201b <syscall>
  802248:	83 c4 18             	add    $0x18,%esp
}
  80224b:	90                   	nop
  80224c:	c9                   	leave  
  80224d:	c3                   	ret    

0080224e <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  80224e:	55                   	push   %ebp
  80224f:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  802251:	6a 00                	push   $0x0
  802253:	6a 00                	push   $0x0
  802255:	6a 00                	push   $0x0
  802257:	6a 00                	push   $0x0
  802259:	6a 00                	push   $0x0
  80225b:	6a 16                	push   $0x16
  80225d:	e8 b9 fd ff ff       	call   80201b <syscall>
  802262:	83 c4 18             	add    $0x18,%esp
}
  802265:	90                   	nop
  802266:	c9                   	leave  
  802267:	c3                   	ret    

00802268 <sys_createSemaphore>:

int
sys_createSemaphore(char* semaphoreName, uint32 initialValue)
{
  802268:	55                   	push   %ebp
  802269:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_semaphore,(uint32)semaphoreName, (uint32)initialValue, 0, 0, 0);
  80226b:	8b 45 08             	mov    0x8(%ebp),%eax
  80226e:	6a 00                	push   $0x0
  802270:	6a 00                	push   $0x0
  802272:	6a 00                	push   $0x0
  802274:	ff 75 0c             	pushl  0xc(%ebp)
  802277:	50                   	push   %eax
  802278:	6a 17                	push   $0x17
  80227a:	e8 9c fd ff ff       	call   80201b <syscall>
  80227f:	83 c4 18             	add    $0x18,%esp
}
  802282:	c9                   	leave  
  802283:	c3                   	ret    

00802284 <sys_getSemaphoreValue>:

int
sys_getSemaphoreValue(int32 ownerEnvID, char* semaphoreName)
{
  802284:	55                   	push   %ebp
  802285:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_semaphore_value,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  802287:	8b 55 0c             	mov    0xc(%ebp),%edx
  80228a:	8b 45 08             	mov    0x8(%ebp),%eax
  80228d:	6a 00                	push   $0x0
  80228f:	6a 00                	push   $0x0
  802291:	6a 00                	push   $0x0
  802293:	52                   	push   %edx
  802294:	50                   	push   %eax
  802295:	6a 1a                	push   $0x1a
  802297:	e8 7f fd ff ff       	call   80201b <syscall>
  80229c:	83 c4 18             	add    $0x18,%esp
}
  80229f:	c9                   	leave  
  8022a0:	c3                   	ret    

008022a1 <sys_waitSemaphore>:

void
sys_waitSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  8022a1:	55                   	push   %ebp
  8022a2:	89 e5                	mov    %esp,%ebp
	syscall(SYS_wait_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  8022a4:	8b 55 0c             	mov    0xc(%ebp),%edx
  8022a7:	8b 45 08             	mov    0x8(%ebp),%eax
  8022aa:	6a 00                	push   $0x0
  8022ac:	6a 00                	push   $0x0
  8022ae:	6a 00                	push   $0x0
  8022b0:	52                   	push   %edx
  8022b1:	50                   	push   %eax
  8022b2:	6a 18                	push   $0x18
  8022b4:	e8 62 fd ff ff       	call   80201b <syscall>
  8022b9:	83 c4 18             	add    $0x18,%esp
}
  8022bc:	90                   	nop
  8022bd:	c9                   	leave  
  8022be:	c3                   	ret    

008022bf <sys_signalSemaphore>:

void
sys_signalSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  8022bf:	55                   	push   %ebp
  8022c0:	89 e5                	mov    %esp,%ebp
	syscall(SYS_signal_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  8022c2:	8b 55 0c             	mov    0xc(%ebp),%edx
  8022c5:	8b 45 08             	mov    0x8(%ebp),%eax
  8022c8:	6a 00                	push   $0x0
  8022ca:	6a 00                	push   $0x0
  8022cc:	6a 00                	push   $0x0
  8022ce:	52                   	push   %edx
  8022cf:	50                   	push   %eax
  8022d0:	6a 19                	push   $0x19
  8022d2:	e8 44 fd ff ff       	call   80201b <syscall>
  8022d7:	83 c4 18             	add    $0x18,%esp
}
  8022da:	90                   	nop
  8022db:	c9                   	leave  
  8022dc:	c3                   	ret    

008022dd <sys_createSharedObject>:

int
sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  8022dd:	55                   	push   %ebp
  8022de:	89 e5                	mov    %esp,%ebp
  8022e0:	83 ec 04             	sub    $0x4,%esp
  8022e3:	8b 45 10             	mov    0x10(%ebp),%eax
  8022e6:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  8022e9:	8b 4d 14             	mov    0x14(%ebp),%ecx
  8022ec:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  8022f0:	8b 45 08             	mov    0x8(%ebp),%eax
  8022f3:	6a 00                	push   $0x0
  8022f5:	51                   	push   %ecx
  8022f6:	52                   	push   %edx
  8022f7:	ff 75 0c             	pushl  0xc(%ebp)
  8022fa:	50                   	push   %eax
  8022fb:	6a 1b                	push   $0x1b
  8022fd:	e8 19 fd ff ff       	call   80201b <syscall>
  802302:	83 c4 18             	add    $0x18,%esp
}
  802305:	c9                   	leave  
  802306:	c3                   	ret    

00802307 <sys_getSizeOfSharedObject>:

//2017:
int
sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  802307:	55                   	push   %ebp
  802308:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  80230a:	8b 55 0c             	mov    0xc(%ebp),%edx
  80230d:	8b 45 08             	mov    0x8(%ebp),%eax
  802310:	6a 00                	push   $0x0
  802312:	6a 00                	push   $0x0
  802314:	6a 00                	push   $0x0
  802316:	52                   	push   %edx
  802317:	50                   	push   %eax
  802318:	6a 1c                	push   $0x1c
  80231a:	e8 fc fc ff ff       	call   80201b <syscall>
  80231f:	83 c4 18             	add    $0x18,%esp
}
  802322:	c9                   	leave  
  802323:	c3                   	ret    

00802324 <sys_getSharedObject>:
//==========

int
sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  802324:	55                   	push   %ebp
  802325:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  802327:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80232a:	8b 55 0c             	mov    0xc(%ebp),%edx
  80232d:	8b 45 08             	mov    0x8(%ebp),%eax
  802330:	6a 00                	push   $0x0
  802332:	6a 00                	push   $0x0
  802334:	51                   	push   %ecx
  802335:	52                   	push   %edx
  802336:	50                   	push   %eax
  802337:	6a 1d                	push   $0x1d
  802339:	e8 dd fc ff ff       	call   80201b <syscall>
  80233e:	83 c4 18             	add    $0x18,%esp
}
  802341:	c9                   	leave  
  802342:	c3                   	ret    

00802343 <sys_freeSharedObject>:

int
sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  802343:	55                   	push   %ebp
  802344:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  802346:	8b 55 0c             	mov    0xc(%ebp),%edx
  802349:	8b 45 08             	mov    0x8(%ebp),%eax
  80234c:	6a 00                	push   $0x0
  80234e:	6a 00                	push   $0x0
  802350:	6a 00                	push   $0x0
  802352:	52                   	push   %edx
  802353:	50                   	push   %eax
  802354:	6a 1e                	push   $0x1e
  802356:	e8 c0 fc ff ff       	call   80201b <syscall>
  80235b:	83 c4 18             	add    $0x18,%esp
}
  80235e:	c9                   	leave  
  80235f:	c3                   	ret    

00802360 <sys_getMaxShares>:

uint32 	sys_getMaxShares()
{
  802360:	55                   	push   %ebp
  802361:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_max_shares,0, 0, 0, 0, 0);
  802363:	6a 00                	push   $0x0
  802365:	6a 00                	push   $0x0
  802367:	6a 00                	push   $0x0
  802369:	6a 00                	push   $0x0
  80236b:	6a 00                	push   $0x0
  80236d:	6a 1f                	push   $0x1f
  80236f:	e8 a7 fc ff ff       	call   80201b <syscall>
  802374:	83 c4 18             	add    $0x18,%esp
}
  802377:	c9                   	leave  
  802378:	c3                   	ret    

00802379 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  802379:	55                   	push   %ebp
  80237a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  80237c:	8b 45 08             	mov    0x8(%ebp),%eax
  80237f:	6a 00                	push   $0x0
  802381:	ff 75 14             	pushl  0x14(%ebp)
  802384:	ff 75 10             	pushl  0x10(%ebp)
  802387:	ff 75 0c             	pushl  0xc(%ebp)
  80238a:	50                   	push   %eax
  80238b:	6a 20                	push   $0x20
  80238d:	e8 89 fc ff ff       	call   80201b <syscall>
  802392:	83 c4 18             	add    $0x18,%esp
}
  802395:	c9                   	leave  
  802396:	c3                   	ret    

00802397 <sys_run_env>:

void
sys_run_env(int32 envId)
{
  802397:	55                   	push   %ebp
  802398:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  80239a:	8b 45 08             	mov    0x8(%ebp),%eax
  80239d:	6a 00                	push   $0x0
  80239f:	6a 00                	push   $0x0
  8023a1:	6a 00                	push   $0x0
  8023a3:	6a 00                	push   $0x0
  8023a5:	50                   	push   %eax
  8023a6:	6a 21                	push   $0x21
  8023a8:	e8 6e fc ff ff       	call   80201b <syscall>
  8023ad:	83 c4 18             	add    $0x18,%esp
}
  8023b0:	90                   	nop
  8023b1:	c9                   	leave  
  8023b2:	c3                   	ret    

008023b3 <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  8023b3:	55                   	push   %ebp
  8023b4:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  8023b6:	8b 45 08             	mov    0x8(%ebp),%eax
  8023b9:	6a 00                	push   $0x0
  8023bb:	6a 00                	push   $0x0
  8023bd:	6a 00                	push   $0x0
  8023bf:	6a 00                	push   $0x0
  8023c1:	50                   	push   %eax
  8023c2:	6a 22                	push   $0x22
  8023c4:	e8 52 fc ff ff       	call   80201b <syscall>
  8023c9:	83 c4 18             	add    $0x18,%esp
}
  8023cc:	c9                   	leave  
  8023cd:	c3                   	ret    

008023ce <sys_getenvid>:

int32 sys_getenvid(void)
{
  8023ce:	55                   	push   %ebp
  8023cf:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  8023d1:	6a 00                	push   $0x0
  8023d3:	6a 00                	push   $0x0
  8023d5:	6a 00                	push   $0x0
  8023d7:	6a 00                	push   $0x0
  8023d9:	6a 00                	push   $0x0
  8023db:	6a 02                	push   $0x2
  8023dd:	e8 39 fc ff ff       	call   80201b <syscall>
  8023e2:	83 c4 18             	add    $0x18,%esp
}
  8023e5:	c9                   	leave  
  8023e6:	c3                   	ret    

008023e7 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  8023e7:	55                   	push   %ebp
  8023e8:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  8023ea:	6a 00                	push   $0x0
  8023ec:	6a 00                	push   $0x0
  8023ee:	6a 00                	push   $0x0
  8023f0:	6a 00                	push   $0x0
  8023f2:	6a 00                	push   $0x0
  8023f4:	6a 03                	push   $0x3
  8023f6:	e8 20 fc ff ff       	call   80201b <syscall>
  8023fb:	83 c4 18             	add    $0x18,%esp
}
  8023fe:	c9                   	leave  
  8023ff:	c3                   	ret    

00802400 <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  802400:	55                   	push   %ebp
  802401:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  802403:	6a 00                	push   $0x0
  802405:	6a 00                	push   $0x0
  802407:	6a 00                	push   $0x0
  802409:	6a 00                	push   $0x0
  80240b:	6a 00                	push   $0x0
  80240d:	6a 04                	push   $0x4
  80240f:	e8 07 fc ff ff       	call   80201b <syscall>
  802414:	83 c4 18             	add    $0x18,%esp
}
  802417:	c9                   	leave  
  802418:	c3                   	ret    

00802419 <sys_exit_env>:


void sys_exit_env(void)
{
  802419:	55                   	push   %ebp
  80241a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  80241c:	6a 00                	push   $0x0
  80241e:	6a 00                	push   $0x0
  802420:	6a 00                	push   $0x0
  802422:	6a 00                	push   $0x0
  802424:	6a 00                	push   $0x0
  802426:	6a 23                	push   $0x23
  802428:	e8 ee fb ff ff       	call   80201b <syscall>
  80242d:	83 c4 18             	add    $0x18,%esp
}
  802430:	90                   	nop
  802431:	c9                   	leave  
  802432:	c3                   	ret    

00802433 <sys_get_virtual_time>:


struct uint64
sys_get_virtual_time()
{
  802433:	55                   	push   %ebp
  802434:	89 e5                	mov    %esp,%ebp
  802436:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  802439:	8d 45 f8             	lea    -0x8(%ebp),%eax
  80243c:	8d 50 04             	lea    0x4(%eax),%edx
  80243f:	8d 45 f8             	lea    -0x8(%ebp),%eax
  802442:	6a 00                	push   $0x0
  802444:	6a 00                	push   $0x0
  802446:	6a 00                	push   $0x0
  802448:	52                   	push   %edx
  802449:	50                   	push   %eax
  80244a:	6a 24                	push   $0x24
  80244c:	e8 ca fb ff ff       	call   80201b <syscall>
  802451:	83 c4 18             	add    $0x18,%esp
	return result;
  802454:	8b 4d 08             	mov    0x8(%ebp),%ecx
  802457:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80245a:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80245d:	89 01                	mov    %eax,(%ecx)
  80245f:	89 51 04             	mov    %edx,0x4(%ecx)
}
  802462:	8b 45 08             	mov    0x8(%ebp),%eax
  802465:	c9                   	leave  
  802466:	c2 04 00             	ret    $0x4

00802469 <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  802469:	55                   	push   %ebp
  80246a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  80246c:	6a 00                	push   $0x0
  80246e:	6a 00                	push   $0x0
  802470:	ff 75 10             	pushl  0x10(%ebp)
  802473:	ff 75 0c             	pushl  0xc(%ebp)
  802476:	ff 75 08             	pushl  0x8(%ebp)
  802479:	6a 12                	push   $0x12
  80247b:	e8 9b fb ff ff       	call   80201b <syscall>
  802480:	83 c4 18             	add    $0x18,%esp
	return ;
  802483:	90                   	nop
}
  802484:	c9                   	leave  
  802485:	c3                   	ret    

00802486 <sys_rcr2>:
uint32 sys_rcr2()
{
  802486:	55                   	push   %ebp
  802487:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  802489:	6a 00                	push   $0x0
  80248b:	6a 00                	push   $0x0
  80248d:	6a 00                	push   $0x0
  80248f:	6a 00                	push   $0x0
  802491:	6a 00                	push   $0x0
  802493:	6a 25                	push   $0x25
  802495:	e8 81 fb ff ff       	call   80201b <syscall>
  80249a:	83 c4 18             	add    $0x18,%esp
}
  80249d:	c9                   	leave  
  80249e:	c3                   	ret    

0080249f <sys_bypassPageFault>:
void sys_bypassPageFault(uint8 instrLength)
{
  80249f:	55                   	push   %ebp
  8024a0:	89 e5                	mov    %esp,%ebp
  8024a2:	83 ec 04             	sub    $0x4,%esp
  8024a5:	8b 45 08             	mov    0x8(%ebp),%eax
  8024a8:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  8024ab:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  8024af:	6a 00                	push   $0x0
  8024b1:	6a 00                	push   $0x0
  8024b3:	6a 00                	push   $0x0
  8024b5:	6a 00                	push   $0x0
  8024b7:	50                   	push   %eax
  8024b8:	6a 26                	push   $0x26
  8024ba:	e8 5c fb ff ff       	call   80201b <syscall>
  8024bf:	83 c4 18             	add    $0x18,%esp
	return ;
  8024c2:	90                   	nop
}
  8024c3:	c9                   	leave  
  8024c4:	c3                   	ret    

008024c5 <rsttst>:
void rsttst()
{
  8024c5:	55                   	push   %ebp
  8024c6:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  8024c8:	6a 00                	push   $0x0
  8024ca:	6a 00                	push   $0x0
  8024cc:	6a 00                	push   $0x0
  8024ce:	6a 00                	push   $0x0
  8024d0:	6a 00                	push   $0x0
  8024d2:	6a 28                	push   $0x28
  8024d4:	e8 42 fb ff ff       	call   80201b <syscall>
  8024d9:	83 c4 18             	add    $0x18,%esp
	return ;
  8024dc:	90                   	nop
}
  8024dd:	c9                   	leave  
  8024de:	c3                   	ret    

008024df <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  8024df:	55                   	push   %ebp
  8024e0:	89 e5                	mov    %esp,%ebp
  8024e2:	83 ec 04             	sub    $0x4,%esp
  8024e5:	8b 45 14             	mov    0x14(%ebp),%eax
  8024e8:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  8024eb:	8b 55 18             	mov    0x18(%ebp),%edx
  8024ee:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  8024f2:	52                   	push   %edx
  8024f3:	50                   	push   %eax
  8024f4:	ff 75 10             	pushl  0x10(%ebp)
  8024f7:	ff 75 0c             	pushl  0xc(%ebp)
  8024fa:	ff 75 08             	pushl  0x8(%ebp)
  8024fd:	6a 27                	push   $0x27
  8024ff:	e8 17 fb ff ff       	call   80201b <syscall>
  802504:	83 c4 18             	add    $0x18,%esp
	return ;
  802507:	90                   	nop
}
  802508:	c9                   	leave  
  802509:	c3                   	ret    

0080250a <chktst>:
void chktst(uint32 n)
{
  80250a:	55                   	push   %ebp
  80250b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  80250d:	6a 00                	push   $0x0
  80250f:	6a 00                	push   $0x0
  802511:	6a 00                	push   $0x0
  802513:	6a 00                	push   $0x0
  802515:	ff 75 08             	pushl  0x8(%ebp)
  802518:	6a 29                	push   $0x29
  80251a:	e8 fc fa ff ff       	call   80201b <syscall>
  80251f:	83 c4 18             	add    $0x18,%esp
	return ;
  802522:	90                   	nop
}
  802523:	c9                   	leave  
  802524:	c3                   	ret    

00802525 <inctst>:

void inctst()
{
  802525:	55                   	push   %ebp
  802526:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  802528:	6a 00                	push   $0x0
  80252a:	6a 00                	push   $0x0
  80252c:	6a 00                	push   $0x0
  80252e:	6a 00                	push   $0x0
  802530:	6a 00                	push   $0x0
  802532:	6a 2a                	push   $0x2a
  802534:	e8 e2 fa ff ff       	call   80201b <syscall>
  802539:	83 c4 18             	add    $0x18,%esp
	return ;
  80253c:	90                   	nop
}
  80253d:	c9                   	leave  
  80253e:	c3                   	ret    

0080253f <gettst>:
uint32 gettst()
{
  80253f:	55                   	push   %ebp
  802540:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  802542:	6a 00                	push   $0x0
  802544:	6a 00                	push   $0x0
  802546:	6a 00                	push   $0x0
  802548:	6a 00                	push   $0x0
  80254a:	6a 00                	push   $0x0
  80254c:	6a 2b                	push   $0x2b
  80254e:	e8 c8 fa ff ff       	call   80201b <syscall>
  802553:	83 c4 18             	add    $0x18,%esp
}
  802556:	c9                   	leave  
  802557:	c3                   	ret    

00802558 <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  802558:	55                   	push   %ebp
  802559:	89 e5                	mov    %esp,%ebp
  80255b:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  80255e:	6a 00                	push   $0x0
  802560:	6a 00                	push   $0x0
  802562:	6a 00                	push   $0x0
  802564:	6a 00                	push   $0x0
  802566:	6a 00                	push   $0x0
  802568:	6a 2c                	push   $0x2c
  80256a:	e8 ac fa ff ff       	call   80201b <syscall>
  80256f:	83 c4 18             	add    $0x18,%esp
  802572:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  802575:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  802579:	75 07                	jne    802582 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  80257b:	b8 01 00 00 00       	mov    $0x1,%eax
  802580:	eb 05                	jmp    802587 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  802582:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802587:	c9                   	leave  
  802588:	c3                   	ret    

00802589 <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  802589:	55                   	push   %ebp
  80258a:	89 e5                	mov    %esp,%ebp
  80258c:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  80258f:	6a 00                	push   $0x0
  802591:	6a 00                	push   $0x0
  802593:	6a 00                	push   $0x0
  802595:	6a 00                	push   $0x0
  802597:	6a 00                	push   $0x0
  802599:	6a 2c                	push   $0x2c
  80259b:	e8 7b fa ff ff       	call   80201b <syscall>
  8025a0:	83 c4 18             	add    $0x18,%esp
  8025a3:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  8025a6:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  8025aa:	75 07                	jne    8025b3 <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  8025ac:	b8 01 00 00 00       	mov    $0x1,%eax
  8025b1:	eb 05                	jmp    8025b8 <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  8025b3:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8025b8:	c9                   	leave  
  8025b9:	c3                   	ret    

008025ba <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  8025ba:	55                   	push   %ebp
  8025bb:	89 e5                	mov    %esp,%ebp
  8025bd:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8025c0:	6a 00                	push   $0x0
  8025c2:	6a 00                	push   $0x0
  8025c4:	6a 00                	push   $0x0
  8025c6:	6a 00                	push   $0x0
  8025c8:	6a 00                	push   $0x0
  8025ca:	6a 2c                	push   $0x2c
  8025cc:	e8 4a fa ff ff       	call   80201b <syscall>
  8025d1:	83 c4 18             	add    $0x18,%esp
  8025d4:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  8025d7:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  8025db:	75 07                	jne    8025e4 <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  8025dd:	b8 01 00 00 00       	mov    $0x1,%eax
  8025e2:	eb 05                	jmp    8025e9 <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  8025e4:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8025e9:	c9                   	leave  
  8025ea:	c3                   	ret    

008025eb <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  8025eb:	55                   	push   %ebp
  8025ec:	89 e5                	mov    %esp,%ebp
  8025ee:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8025f1:	6a 00                	push   $0x0
  8025f3:	6a 00                	push   $0x0
  8025f5:	6a 00                	push   $0x0
  8025f7:	6a 00                	push   $0x0
  8025f9:	6a 00                	push   $0x0
  8025fb:	6a 2c                	push   $0x2c
  8025fd:	e8 19 fa ff ff       	call   80201b <syscall>
  802602:	83 c4 18             	add    $0x18,%esp
  802605:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  802608:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  80260c:	75 07                	jne    802615 <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  80260e:	b8 01 00 00 00       	mov    $0x1,%eax
  802613:	eb 05                	jmp    80261a <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  802615:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80261a:	c9                   	leave  
  80261b:	c3                   	ret    

0080261c <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  80261c:	55                   	push   %ebp
  80261d:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  80261f:	6a 00                	push   $0x0
  802621:	6a 00                	push   $0x0
  802623:	6a 00                	push   $0x0
  802625:	6a 00                	push   $0x0
  802627:	ff 75 08             	pushl  0x8(%ebp)
  80262a:	6a 2d                	push   $0x2d
  80262c:	e8 ea f9 ff ff       	call   80201b <syscall>
  802631:	83 c4 18             	add    $0x18,%esp
	return ;
  802634:	90                   	nop
}
  802635:	c9                   	leave  
  802636:	c3                   	ret    

00802637 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  802637:	55                   	push   %ebp
  802638:	89 e5                	mov    %esp,%ebp
  80263a:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  80263b:	8b 5d 14             	mov    0x14(%ebp),%ebx
  80263e:	8b 4d 10             	mov    0x10(%ebp),%ecx
  802641:	8b 55 0c             	mov    0xc(%ebp),%edx
  802644:	8b 45 08             	mov    0x8(%ebp),%eax
  802647:	6a 00                	push   $0x0
  802649:	53                   	push   %ebx
  80264a:	51                   	push   %ecx
  80264b:	52                   	push   %edx
  80264c:	50                   	push   %eax
  80264d:	6a 2e                	push   $0x2e
  80264f:	e8 c7 f9 ff ff       	call   80201b <syscall>
  802654:	83 c4 18             	add    $0x18,%esp
}
  802657:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80265a:	c9                   	leave  
  80265b:	c3                   	ret    

0080265c <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  80265c:	55                   	push   %ebp
  80265d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  80265f:	8b 55 0c             	mov    0xc(%ebp),%edx
  802662:	8b 45 08             	mov    0x8(%ebp),%eax
  802665:	6a 00                	push   $0x0
  802667:	6a 00                	push   $0x0
  802669:	6a 00                	push   $0x0
  80266b:	52                   	push   %edx
  80266c:	50                   	push   %eax
  80266d:	6a 2f                	push   $0x2f
  80266f:	e8 a7 f9 ff ff       	call   80201b <syscall>
  802674:	83 c4 18             	add    $0x18,%esp
}
  802677:	c9                   	leave  
  802678:	c3                   	ret    

00802679 <print_mem_block_lists>:
//===========================
// PRINT MEM BLOCK LISTS:
//===========================

void print_mem_block_lists()
{
  802679:	55                   	push   %ebp
  80267a:	89 e5                	mov    %esp,%ebp
  80267c:	83 ec 18             	sub    $0x18,%esp
	cprintf("\n=========================================\n");
  80267f:	83 ec 0c             	sub    $0xc,%esp
  802682:	68 20 41 80 00       	push   $0x804120
  802687:	e8 dd e6 ff ff       	call   800d69 <cprintf>
  80268c:	83 c4 10             	add    $0x10,%esp
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
  80268f:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nFreeMemBlocksList:\n");
  802696:	83 ec 0c             	sub    $0xc,%esp
  802699:	68 4c 41 80 00       	push   $0x80414c
  80269e:	e8 c6 e6 ff ff       	call   800d69 <cprintf>
  8026a3:	83 c4 10             	add    $0x10,%esp
	uint8 sorted = 1 ;
  8026a6:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &FreeMemBlocksList)
  8026aa:	a1 38 51 80 00       	mov    0x805138,%eax
  8026af:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8026b2:	eb 56                	jmp    80270a <print_mem_block_lists+0x91>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  8026b4:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8026b8:	74 1c                	je     8026d6 <print_mem_block_lists+0x5d>
  8026ba:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026bd:	8b 50 08             	mov    0x8(%eax),%edx
  8026c0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8026c3:	8b 48 08             	mov    0x8(%eax),%ecx
  8026c6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8026c9:	8b 40 0c             	mov    0xc(%eax),%eax
  8026cc:	01 c8                	add    %ecx,%eax
  8026ce:	39 c2                	cmp    %eax,%edx
  8026d0:	73 04                	jae    8026d6 <print_mem_block_lists+0x5d>
			sorted = 0 ;
  8026d2:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  8026d6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026d9:	8b 50 08             	mov    0x8(%eax),%edx
  8026dc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026df:	8b 40 0c             	mov    0xc(%eax),%eax
  8026e2:	01 c2                	add    %eax,%edx
  8026e4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026e7:	8b 40 08             	mov    0x8(%eax),%eax
  8026ea:	83 ec 04             	sub    $0x4,%esp
  8026ed:	52                   	push   %edx
  8026ee:	50                   	push   %eax
  8026ef:	68 61 41 80 00       	push   $0x804161
  8026f4:	e8 70 e6 ff ff       	call   800d69 <cprintf>
  8026f9:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  8026fc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026ff:	89 45 f0             	mov    %eax,-0x10(%ebp)
	cprintf("\n=========================================\n");
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
	cprintf("\nFreeMemBlocksList:\n");
	uint8 sorted = 1 ;
	LIST_FOREACH(blk, &FreeMemBlocksList)
  802702:	a1 40 51 80 00       	mov    0x805140,%eax
  802707:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80270a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80270e:	74 07                	je     802717 <print_mem_block_lists+0x9e>
  802710:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802713:	8b 00                	mov    (%eax),%eax
  802715:	eb 05                	jmp    80271c <print_mem_block_lists+0xa3>
  802717:	b8 00 00 00 00       	mov    $0x0,%eax
  80271c:	a3 40 51 80 00       	mov    %eax,0x805140
  802721:	a1 40 51 80 00       	mov    0x805140,%eax
  802726:	85 c0                	test   %eax,%eax
  802728:	75 8a                	jne    8026b4 <print_mem_block_lists+0x3b>
  80272a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80272e:	75 84                	jne    8026b4 <print_mem_block_lists+0x3b>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;
  802730:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  802734:	75 10                	jne    802746 <print_mem_block_lists+0xcd>
  802736:	83 ec 0c             	sub    $0xc,%esp
  802739:	68 70 41 80 00       	push   $0x804170
  80273e:	e8 26 e6 ff ff       	call   800d69 <cprintf>
  802743:	83 c4 10             	add    $0x10,%esp

	lastBlk = NULL ;
  802746:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nAllocMemBlocksList:\n");
  80274d:	83 ec 0c             	sub    $0xc,%esp
  802750:	68 94 41 80 00       	push   $0x804194
  802755:	e8 0f e6 ff ff       	call   800d69 <cprintf>
  80275a:	83 c4 10             	add    $0x10,%esp
	sorted = 1 ;
  80275d:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &AllocMemBlocksList)
  802761:	a1 40 50 80 00       	mov    0x805040,%eax
  802766:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802769:	eb 56                	jmp    8027c1 <print_mem_block_lists+0x148>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  80276b:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80276f:	74 1c                	je     80278d <print_mem_block_lists+0x114>
  802771:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802774:	8b 50 08             	mov    0x8(%eax),%edx
  802777:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80277a:	8b 48 08             	mov    0x8(%eax),%ecx
  80277d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802780:	8b 40 0c             	mov    0xc(%eax),%eax
  802783:	01 c8                	add    %ecx,%eax
  802785:	39 c2                	cmp    %eax,%edx
  802787:	73 04                	jae    80278d <print_mem_block_lists+0x114>
			sorted = 0 ;
  802789:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  80278d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802790:	8b 50 08             	mov    0x8(%eax),%edx
  802793:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802796:	8b 40 0c             	mov    0xc(%eax),%eax
  802799:	01 c2                	add    %eax,%edx
  80279b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80279e:	8b 40 08             	mov    0x8(%eax),%eax
  8027a1:	83 ec 04             	sub    $0x4,%esp
  8027a4:	52                   	push   %edx
  8027a5:	50                   	push   %eax
  8027a6:	68 61 41 80 00       	push   $0x804161
  8027ab:	e8 b9 e5 ff ff       	call   800d69 <cprintf>
  8027b0:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  8027b3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027b6:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;

	lastBlk = NULL ;
	cprintf("\nAllocMemBlocksList:\n");
	sorted = 1 ;
	LIST_FOREACH(blk, &AllocMemBlocksList)
  8027b9:	a1 48 50 80 00       	mov    0x805048,%eax
  8027be:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8027c1:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8027c5:	74 07                	je     8027ce <print_mem_block_lists+0x155>
  8027c7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027ca:	8b 00                	mov    (%eax),%eax
  8027cc:	eb 05                	jmp    8027d3 <print_mem_block_lists+0x15a>
  8027ce:	b8 00 00 00 00       	mov    $0x0,%eax
  8027d3:	a3 48 50 80 00       	mov    %eax,0x805048
  8027d8:	a1 48 50 80 00       	mov    0x805048,%eax
  8027dd:	85 c0                	test   %eax,%eax
  8027df:	75 8a                	jne    80276b <print_mem_block_lists+0xf2>
  8027e1:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8027e5:	75 84                	jne    80276b <print_mem_block_lists+0xf2>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nAllocMemBlocksList is NOT SORTED!!\n") ;
  8027e7:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  8027eb:	75 10                	jne    8027fd <print_mem_block_lists+0x184>
  8027ed:	83 ec 0c             	sub    $0xc,%esp
  8027f0:	68 ac 41 80 00       	push   $0x8041ac
  8027f5:	e8 6f e5 ff ff       	call   800d69 <cprintf>
  8027fa:	83 c4 10             	add    $0x10,%esp
	cprintf("\n=========================================\n");
  8027fd:	83 ec 0c             	sub    $0xc,%esp
  802800:	68 20 41 80 00       	push   $0x804120
  802805:	e8 5f e5 ff ff       	call   800d69 <cprintf>
  80280a:	83 c4 10             	add    $0x10,%esp

}
  80280d:	90                   	nop
  80280e:	c9                   	leave  
  80280f:	c3                   	ret    

00802810 <initialize_MemBlocksList>:

//===============================
// [1] INITIALIZE AVAILABLE LIST:
//===============================
void initialize_MemBlocksList(uint32 numOfBlocks)
{
  802810:	55                   	push   %ebp
  802811:	89 e5                	mov    %esp,%ebp
  802813:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] initialize_MemBlocksList
	// Write your code here, remove the panic and write your code
	//panic("initialize_MemBlocksList() is not implemented yet...!!");
	uint32 n = numOfBlocks;
  802816:	8b 45 08             	mov    0x8(%ebp),%eax
  802819:	89 45 f0             	mov    %eax,-0x10(%ebp)

	LIST_INIT(&AvailableMemBlocksList);
  80281c:	c7 05 48 51 80 00 00 	movl   $0x0,0x805148
  802823:	00 00 00 
  802826:	c7 05 4c 51 80 00 00 	movl   $0x0,0x80514c
  80282d:	00 00 00 
  802830:	c7 05 54 51 80 00 00 	movl   $0x0,0x805154
  802837:	00 00 00 
	for(int i = 0; i<n;i++)
  80283a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  802841:	e9 9e 00 00 00       	jmp    8028e4 <initialize_MemBlocksList+0xd4>
	{
		LIST_INSERT_HEAD(&AvailableMemBlocksList, &(MemBlockNodes[i]));
  802846:	a1 50 50 80 00       	mov    0x805050,%eax
  80284b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80284e:	c1 e2 04             	shl    $0x4,%edx
  802851:	01 d0                	add    %edx,%eax
  802853:	85 c0                	test   %eax,%eax
  802855:	75 14                	jne    80286b <initialize_MemBlocksList+0x5b>
  802857:	83 ec 04             	sub    $0x4,%esp
  80285a:	68 d4 41 80 00       	push   $0x8041d4
  80285f:	6a 47                	push   $0x47
  802861:	68 f7 41 80 00       	push   $0x8041f7
  802866:	e8 4a e2 ff ff       	call   800ab5 <_panic>
  80286b:	a1 50 50 80 00       	mov    0x805050,%eax
  802870:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802873:	c1 e2 04             	shl    $0x4,%edx
  802876:	01 d0                	add    %edx,%eax
  802878:	8b 15 48 51 80 00    	mov    0x805148,%edx
  80287e:	89 10                	mov    %edx,(%eax)
  802880:	8b 00                	mov    (%eax),%eax
  802882:	85 c0                	test   %eax,%eax
  802884:	74 18                	je     80289e <initialize_MemBlocksList+0x8e>
  802886:	a1 48 51 80 00       	mov    0x805148,%eax
  80288b:	8b 15 50 50 80 00    	mov    0x805050,%edx
  802891:	8b 4d f4             	mov    -0xc(%ebp),%ecx
  802894:	c1 e1 04             	shl    $0x4,%ecx
  802897:	01 ca                	add    %ecx,%edx
  802899:	89 50 04             	mov    %edx,0x4(%eax)
  80289c:	eb 12                	jmp    8028b0 <initialize_MemBlocksList+0xa0>
  80289e:	a1 50 50 80 00       	mov    0x805050,%eax
  8028a3:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8028a6:	c1 e2 04             	shl    $0x4,%edx
  8028a9:	01 d0                	add    %edx,%eax
  8028ab:	a3 4c 51 80 00       	mov    %eax,0x80514c
  8028b0:	a1 50 50 80 00       	mov    0x805050,%eax
  8028b5:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8028b8:	c1 e2 04             	shl    $0x4,%edx
  8028bb:	01 d0                	add    %edx,%eax
  8028bd:	a3 48 51 80 00       	mov    %eax,0x805148
  8028c2:	a1 50 50 80 00       	mov    0x805050,%eax
  8028c7:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8028ca:	c1 e2 04             	shl    $0x4,%edx
  8028cd:	01 d0                	add    %edx,%eax
  8028cf:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8028d6:	a1 54 51 80 00       	mov    0x805154,%eax
  8028db:	40                   	inc    %eax
  8028dc:	a3 54 51 80 00       	mov    %eax,0x805154
	// Write your code here, remove the panic and write your code
	//panic("initialize_MemBlocksList() is not implemented yet...!!");
	uint32 n = numOfBlocks;

	LIST_INIT(&AvailableMemBlocksList);
	for(int i = 0; i<n;i++)
  8028e1:	ff 45 f4             	incl   -0xc(%ebp)
  8028e4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028e7:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8028ea:	0f 82 56 ff ff ff    	jb     802846 <initialize_MemBlocksList+0x36>
	{
		LIST_INSERT_HEAD(&AvailableMemBlocksList, &(MemBlockNodes[i]));
	}
}
  8028f0:	90                   	nop
  8028f1:	c9                   	leave  
  8028f2:	c3                   	ret    

008028f3 <find_block>:

//===============================
// [2] FIND BLOCK:
//===============================
struct MemBlock *find_block(struct MemBlock_List *blockList, uint32 va)
{
  8028f3:	55                   	push   %ebp
  8028f4:	89 e5                	mov    %esp,%ebp
  8028f6:	83 ec 10             	sub    $0x10,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] find_block
	// Write your code here, remove the panic and write your code
	//panic("find_block() is not implemented yet...!!");
	uint32 virAddress = va;
  8028f9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8028fc:	89 45 f4             	mov    %eax,-0xc(%ebp)
	struct MemBlock* blk;
	int found = 0;
  8028ff:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	LIST_FOREACH(blk, &(AllocMemBlocksList))
  802906:	a1 40 50 80 00       	mov    0x805040,%eax
  80290b:	89 45 fc             	mov    %eax,-0x4(%ebp)
  80290e:	eb 23                	jmp    802933 <find_block+0x40>
	{
		if(blk->sva == virAddress)
  802910:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802913:	8b 40 08             	mov    0x8(%eax),%eax
  802916:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  802919:	75 09                	jne    802924 <find_block+0x31>
		{
			found = 1;
  80291b:	c7 45 f8 01 00 00 00 	movl   $0x1,-0x8(%ebp)
			break;
  802922:	eb 35                	jmp    802959 <find_block+0x66>
		}
		else
		{
			found = 0;
  802924:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	//panic("find_block() is not implemented yet...!!");
	uint32 virAddress = va;
	struct MemBlock* blk;
	int found = 0;

	LIST_FOREACH(blk, &(AllocMemBlocksList))
  80292b:	a1 48 50 80 00       	mov    0x805048,%eax
  802930:	89 45 fc             	mov    %eax,-0x4(%ebp)
  802933:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  802937:	74 07                	je     802940 <find_block+0x4d>
  802939:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80293c:	8b 00                	mov    (%eax),%eax
  80293e:	eb 05                	jmp    802945 <find_block+0x52>
  802940:	b8 00 00 00 00       	mov    $0x0,%eax
  802945:	a3 48 50 80 00       	mov    %eax,0x805048
  80294a:	a1 48 50 80 00       	mov    0x805048,%eax
  80294f:	85 c0                	test   %eax,%eax
  802951:	75 bd                	jne    802910 <find_block+0x1d>
  802953:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  802957:	75 b7                	jne    802910 <find_block+0x1d>
		{
			found = 0;
			continue;
		}
	}
	if(found == 1)
  802959:	83 7d f8 01          	cmpl   $0x1,-0x8(%ebp)
  80295d:	75 05                	jne    802964 <find_block+0x71>
	{
		return blk;
  80295f:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802962:	eb 05                	jmp    802969 <find_block+0x76>
	}
	else
	{
		return NULL;
  802964:	b8 00 00 00 00       	mov    $0x0,%eax
	}
}
  802969:	c9                   	leave  
  80296a:	c3                   	ret    

0080296b <insert_sorted_allocList>:

//=========================================
// [3] INSERT BLOCK IN ALLOC LIST [SORTED]:
//=========================================
void insert_sorted_allocList(struct MemBlock *blockToInsert)
{
  80296b:	55                   	push   %ebp
  80296c:	89 e5                	mov    %esp,%ebp
  80296e:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] insert_sorted_allocList
	// Write your code here, remove the panic and write your code
	//panic("insert_sorted_allocList() is not implemented yet...!!");
	struct MemBlock* blk;
	struct MemBlock* newblk = blockToInsert;
  802971:	8b 45 08             	mov    0x8(%ebp),%eax
  802974:	89 45 f0             	mov    %eax,-0x10(%ebp)

	if((LIST_EMPTY(&AllocMemBlocksList)) || (newblk->sva < LIST_FIRST(&AllocMemBlocksList)->sva))
  802977:	a1 40 50 80 00       	mov    0x805040,%eax
  80297c:	85 c0                	test   %eax,%eax
  80297e:	74 12                	je     802992 <insert_sorted_allocList+0x27>
  802980:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802983:	8b 50 08             	mov    0x8(%eax),%edx
  802986:	a1 40 50 80 00       	mov    0x805040,%eax
  80298b:	8b 40 08             	mov    0x8(%eax),%eax
  80298e:	39 c2                	cmp    %eax,%edx
  802990:	73 65                	jae    8029f7 <insert_sorted_allocList+0x8c>
	{
		LIST_INSERT_HEAD(&(AllocMemBlocksList), newblk);
  802992:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802996:	75 14                	jne    8029ac <insert_sorted_allocList+0x41>
  802998:	83 ec 04             	sub    $0x4,%esp
  80299b:	68 d4 41 80 00       	push   $0x8041d4
  8029a0:	6a 7b                	push   $0x7b
  8029a2:	68 f7 41 80 00       	push   $0x8041f7
  8029a7:	e8 09 e1 ff ff       	call   800ab5 <_panic>
  8029ac:	8b 15 40 50 80 00    	mov    0x805040,%edx
  8029b2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8029b5:	89 10                	mov    %edx,(%eax)
  8029b7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8029ba:	8b 00                	mov    (%eax),%eax
  8029bc:	85 c0                	test   %eax,%eax
  8029be:	74 0d                	je     8029cd <insert_sorted_allocList+0x62>
  8029c0:	a1 40 50 80 00       	mov    0x805040,%eax
  8029c5:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8029c8:	89 50 04             	mov    %edx,0x4(%eax)
  8029cb:	eb 08                	jmp    8029d5 <insert_sorted_allocList+0x6a>
  8029cd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8029d0:	a3 44 50 80 00       	mov    %eax,0x805044
  8029d5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8029d8:	a3 40 50 80 00       	mov    %eax,0x805040
  8029dd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8029e0:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8029e7:	a1 4c 50 80 00       	mov    0x80504c,%eax
  8029ec:	40                   	inc    %eax
  8029ed:	a3 4c 50 80 00       	mov    %eax,0x80504c
  8029f2:	e9 5f 01 00 00       	jmp    802b56 <insert_sorted_allocList+0x1eb>
	}
	else if(newblk->sva > LIST_LAST(&AllocMemBlocksList)->sva)
  8029f7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8029fa:	8b 50 08             	mov    0x8(%eax),%edx
  8029fd:	a1 44 50 80 00       	mov    0x805044,%eax
  802a02:	8b 40 08             	mov    0x8(%eax),%eax
  802a05:	39 c2                	cmp    %eax,%edx
  802a07:	76 65                	jbe    802a6e <insert_sorted_allocList+0x103>
	{
		LIST_INSERT_TAIL(&AllocMemBlocksList, newblk);
  802a09:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802a0d:	75 14                	jne    802a23 <insert_sorted_allocList+0xb8>
  802a0f:	83 ec 04             	sub    $0x4,%esp
  802a12:	68 10 42 80 00       	push   $0x804210
  802a17:	6a 7f                	push   $0x7f
  802a19:	68 f7 41 80 00       	push   $0x8041f7
  802a1e:	e8 92 e0 ff ff       	call   800ab5 <_panic>
  802a23:	8b 15 44 50 80 00    	mov    0x805044,%edx
  802a29:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a2c:	89 50 04             	mov    %edx,0x4(%eax)
  802a2f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a32:	8b 40 04             	mov    0x4(%eax),%eax
  802a35:	85 c0                	test   %eax,%eax
  802a37:	74 0c                	je     802a45 <insert_sorted_allocList+0xda>
  802a39:	a1 44 50 80 00       	mov    0x805044,%eax
  802a3e:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802a41:	89 10                	mov    %edx,(%eax)
  802a43:	eb 08                	jmp    802a4d <insert_sorted_allocList+0xe2>
  802a45:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a48:	a3 40 50 80 00       	mov    %eax,0x805040
  802a4d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a50:	a3 44 50 80 00       	mov    %eax,0x805044
  802a55:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a58:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802a5e:	a1 4c 50 80 00       	mov    0x80504c,%eax
  802a63:	40                   	inc    %eax
  802a64:	a3 4c 50 80 00       	mov    %eax,0x80504c
				LIST_INSERT_AFTER(&AllocMemBlocksList, blk, newblk);
				break;
			}
		}
	}
}
  802a69:	e9 e8 00 00 00       	jmp    802b56 <insert_sorted_allocList+0x1eb>
	{
		LIST_INSERT_TAIL(&AllocMemBlocksList, newblk);
	}
	else
	{
		LIST_FOREACH(blk, &AllocMemBlocksList)
  802a6e:	a1 40 50 80 00       	mov    0x805040,%eax
  802a73:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802a76:	e9 ab 00 00 00       	jmp    802b26 <insert_sorted_allocList+0x1bb>
		{
			if(blk->prev_next_info.le_next != NULL && newblk->sva > blk->sva  && newblk->sva < blk->prev_next_info.le_next->sva)
  802a7b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a7e:	8b 00                	mov    (%eax),%eax
  802a80:	85 c0                	test   %eax,%eax
  802a82:	0f 84 96 00 00 00    	je     802b1e <insert_sorted_allocList+0x1b3>
  802a88:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a8b:	8b 50 08             	mov    0x8(%eax),%edx
  802a8e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a91:	8b 40 08             	mov    0x8(%eax),%eax
  802a94:	39 c2                	cmp    %eax,%edx
  802a96:	0f 86 82 00 00 00    	jbe    802b1e <insert_sorted_allocList+0x1b3>
  802a9c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a9f:	8b 50 08             	mov    0x8(%eax),%edx
  802aa2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802aa5:	8b 00                	mov    (%eax),%eax
  802aa7:	8b 40 08             	mov    0x8(%eax),%eax
  802aaa:	39 c2                	cmp    %eax,%edx
  802aac:	73 70                	jae    802b1e <insert_sorted_allocList+0x1b3>
			{
				LIST_INSERT_AFTER(&AllocMemBlocksList, blk, newblk);
  802aae:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802ab2:	74 06                	je     802aba <insert_sorted_allocList+0x14f>
  802ab4:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802ab8:	75 17                	jne    802ad1 <insert_sorted_allocList+0x166>
  802aba:	83 ec 04             	sub    $0x4,%esp
  802abd:	68 34 42 80 00       	push   $0x804234
  802ac2:	68 87 00 00 00       	push   $0x87
  802ac7:	68 f7 41 80 00       	push   $0x8041f7
  802acc:	e8 e4 df ff ff       	call   800ab5 <_panic>
  802ad1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ad4:	8b 10                	mov    (%eax),%edx
  802ad6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ad9:	89 10                	mov    %edx,(%eax)
  802adb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ade:	8b 00                	mov    (%eax),%eax
  802ae0:	85 c0                	test   %eax,%eax
  802ae2:	74 0b                	je     802aef <insert_sorted_allocList+0x184>
  802ae4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ae7:	8b 00                	mov    (%eax),%eax
  802ae9:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802aec:	89 50 04             	mov    %edx,0x4(%eax)
  802aef:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802af2:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802af5:	89 10                	mov    %edx,(%eax)
  802af7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802afa:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802afd:	89 50 04             	mov    %edx,0x4(%eax)
  802b00:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b03:	8b 00                	mov    (%eax),%eax
  802b05:	85 c0                	test   %eax,%eax
  802b07:	75 08                	jne    802b11 <insert_sorted_allocList+0x1a6>
  802b09:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b0c:	a3 44 50 80 00       	mov    %eax,0x805044
  802b11:	a1 4c 50 80 00       	mov    0x80504c,%eax
  802b16:	40                   	inc    %eax
  802b17:	a3 4c 50 80 00       	mov    %eax,0x80504c
				break;
  802b1c:	eb 38                	jmp    802b56 <insert_sorted_allocList+0x1eb>
	{
		LIST_INSERT_TAIL(&AllocMemBlocksList, newblk);
	}
	else
	{
		LIST_FOREACH(blk, &AllocMemBlocksList)
  802b1e:	a1 48 50 80 00       	mov    0x805048,%eax
  802b23:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802b26:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802b2a:	74 07                	je     802b33 <insert_sorted_allocList+0x1c8>
  802b2c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b2f:	8b 00                	mov    (%eax),%eax
  802b31:	eb 05                	jmp    802b38 <insert_sorted_allocList+0x1cd>
  802b33:	b8 00 00 00 00       	mov    $0x0,%eax
  802b38:	a3 48 50 80 00       	mov    %eax,0x805048
  802b3d:	a1 48 50 80 00       	mov    0x805048,%eax
  802b42:	85 c0                	test   %eax,%eax
  802b44:	0f 85 31 ff ff ff    	jne    802a7b <insert_sorted_allocList+0x110>
  802b4a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802b4e:	0f 85 27 ff ff ff    	jne    802a7b <insert_sorted_allocList+0x110>
				LIST_INSERT_AFTER(&AllocMemBlocksList, blk, newblk);
				break;
			}
		}
	}
}
  802b54:	eb 00                	jmp    802b56 <insert_sorted_allocList+0x1eb>
  802b56:	90                   	nop
  802b57:	c9                   	leave  
  802b58:	c3                   	ret    

00802b59 <alloc_block_FF>:

//=========================================
// [4] ALLOCATE BLOCK BY FIRST FIT:
//=========================================
struct MemBlock *alloc_block_FF(uint32 size)
{
  802b59:	55                   	push   %ebp
  802b5a:	89 e5                	mov    %esp,%ebp
  802b5c:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_FF
	// Write your code here, remove the panic and write your code
	//panic("alloc_block_FF() is not implemented yet...!!");
	uint32 versize = size;
  802b5f:	8b 45 08             	mov    0x8(%ebp),%eax
  802b62:	89 45 f0             	mov    %eax,-0x10(%ebp)
	struct MemBlock* blk;
	struct MemBlock* newblk = LIST_FIRST(&AvailableMemBlocksList);
  802b65:	a1 48 51 80 00       	mov    0x805148,%eax
  802b6a:	89 45 ec             	mov    %eax,-0x14(%ebp)

	LIST_FOREACH(blk,&FreeMemBlocksList)
  802b6d:	a1 38 51 80 00       	mov    0x805138,%eax
  802b72:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802b75:	e9 77 01 00 00       	jmp    802cf1 <alloc_block_FF+0x198>
	{
		if(blk->size == versize)
  802b7a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b7d:	8b 40 0c             	mov    0xc(%eax),%eax
  802b80:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  802b83:	0f 85 8a 00 00 00    	jne    802c13 <alloc_block_FF+0xba>
		{
			LIST_REMOVE(&FreeMemBlocksList,blk);
  802b89:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802b8d:	75 17                	jne    802ba6 <alloc_block_FF+0x4d>
  802b8f:	83 ec 04             	sub    $0x4,%esp
  802b92:	68 68 42 80 00       	push   $0x804268
  802b97:	68 9e 00 00 00       	push   $0x9e
  802b9c:	68 f7 41 80 00       	push   $0x8041f7
  802ba1:	e8 0f df ff ff       	call   800ab5 <_panic>
  802ba6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ba9:	8b 00                	mov    (%eax),%eax
  802bab:	85 c0                	test   %eax,%eax
  802bad:	74 10                	je     802bbf <alloc_block_FF+0x66>
  802baf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bb2:	8b 00                	mov    (%eax),%eax
  802bb4:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802bb7:	8b 52 04             	mov    0x4(%edx),%edx
  802bba:	89 50 04             	mov    %edx,0x4(%eax)
  802bbd:	eb 0b                	jmp    802bca <alloc_block_FF+0x71>
  802bbf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bc2:	8b 40 04             	mov    0x4(%eax),%eax
  802bc5:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802bca:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bcd:	8b 40 04             	mov    0x4(%eax),%eax
  802bd0:	85 c0                	test   %eax,%eax
  802bd2:	74 0f                	je     802be3 <alloc_block_FF+0x8a>
  802bd4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bd7:	8b 40 04             	mov    0x4(%eax),%eax
  802bda:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802bdd:	8b 12                	mov    (%edx),%edx
  802bdf:	89 10                	mov    %edx,(%eax)
  802be1:	eb 0a                	jmp    802bed <alloc_block_FF+0x94>
  802be3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802be6:	8b 00                	mov    (%eax),%eax
  802be8:	a3 38 51 80 00       	mov    %eax,0x805138
  802bed:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bf0:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802bf6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bf9:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802c00:	a1 44 51 80 00       	mov    0x805144,%eax
  802c05:	48                   	dec    %eax
  802c06:	a3 44 51 80 00       	mov    %eax,0x805144
			return blk;
  802c0b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c0e:	e9 11 01 00 00       	jmp    802d24 <alloc_block_FF+0x1cb>
		}
		else if(blk->size > versize)
  802c13:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c16:	8b 40 0c             	mov    0xc(%eax),%eax
  802c19:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  802c1c:	0f 86 c7 00 00 00    	jbe    802ce9 <alloc_block_FF+0x190>
		{
			LIST_REMOVE(&AvailableMemBlocksList,newblk);
  802c22:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802c26:	75 17                	jne    802c3f <alloc_block_FF+0xe6>
  802c28:	83 ec 04             	sub    $0x4,%esp
  802c2b:	68 68 42 80 00       	push   $0x804268
  802c30:	68 a3 00 00 00       	push   $0xa3
  802c35:	68 f7 41 80 00       	push   $0x8041f7
  802c3a:	e8 76 de ff ff       	call   800ab5 <_panic>
  802c3f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802c42:	8b 00                	mov    (%eax),%eax
  802c44:	85 c0                	test   %eax,%eax
  802c46:	74 10                	je     802c58 <alloc_block_FF+0xff>
  802c48:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802c4b:	8b 00                	mov    (%eax),%eax
  802c4d:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802c50:	8b 52 04             	mov    0x4(%edx),%edx
  802c53:	89 50 04             	mov    %edx,0x4(%eax)
  802c56:	eb 0b                	jmp    802c63 <alloc_block_FF+0x10a>
  802c58:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802c5b:	8b 40 04             	mov    0x4(%eax),%eax
  802c5e:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802c63:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802c66:	8b 40 04             	mov    0x4(%eax),%eax
  802c69:	85 c0                	test   %eax,%eax
  802c6b:	74 0f                	je     802c7c <alloc_block_FF+0x123>
  802c6d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802c70:	8b 40 04             	mov    0x4(%eax),%eax
  802c73:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802c76:	8b 12                	mov    (%edx),%edx
  802c78:	89 10                	mov    %edx,(%eax)
  802c7a:	eb 0a                	jmp    802c86 <alloc_block_FF+0x12d>
  802c7c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802c7f:	8b 00                	mov    (%eax),%eax
  802c81:	a3 48 51 80 00       	mov    %eax,0x805148
  802c86:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802c89:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802c8f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802c92:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802c99:	a1 54 51 80 00       	mov    0x805154,%eax
  802c9e:	48                   	dec    %eax
  802c9f:	a3 54 51 80 00       	mov    %eax,0x805154
			newblk->size = versize;
  802ca4:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802ca7:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802caa:	89 50 0c             	mov    %edx,0xc(%eax)
			blk->size = blk->size-versize;
  802cad:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cb0:	8b 40 0c             	mov    0xc(%eax),%eax
  802cb3:	2b 45 f0             	sub    -0x10(%ebp),%eax
  802cb6:	89 c2                	mov    %eax,%edx
  802cb8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cbb:	89 50 0c             	mov    %edx,0xc(%eax)
			uint32 newveradd = blk->sva;
  802cbe:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cc1:	8b 40 08             	mov    0x8(%eax),%eax
  802cc4:	89 45 e8             	mov    %eax,-0x18(%ebp)
			blk->sva+=newblk->size;
  802cc7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cca:	8b 50 08             	mov    0x8(%eax),%edx
  802ccd:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802cd0:	8b 40 0c             	mov    0xc(%eax),%eax
  802cd3:	01 c2                	add    %eax,%edx
  802cd5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cd8:	89 50 08             	mov    %edx,0x8(%eax)
			newblk->sva = newveradd;
  802cdb:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802cde:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802ce1:	89 50 08             	mov    %edx,0x8(%eax)
			return newblk;
  802ce4:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802ce7:	eb 3b                	jmp    802d24 <alloc_block_FF+0x1cb>
	//panic("alloc_block_FF() is not implemented yet...!!");
	uint32 versize = size;
	struct MemBlock* blk;
	struct MemBlock* newblk = LIST_FIRST(&AvailableMemBlocksList);

	LIST_FOREACH(blk,&FreeMemBlocksList)
  802ce9:	a1 40 51 80 00       	mov    0x805140,%eax
  802cee:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802cf1:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802cf5:	74 07                	je     802cfe <alloc_block_FF+0x1a5>
  802cf7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cfa:	8b 00                	mov    (%eax),%eax
  802cfc:	eb 05                	jmp    802d03 <alloc_block_FF+0x1aa>
  802cfe:	b8 00 00 00 00       	mov    $0x0,%eax
  802d03:	a3 40 51 80 00       	mov    %eax,0x805140
  802d08:	a1 40 51 80 00       	mov    0x805140,%eax
  802d0d:	85 c0                	test   %eax,%eax
  802d0f:	0f 85 65 fe ff ff    	jne    802b7a <alloc_block_FF+0x21>
  802d15:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802d19:	0f 85 5b fe ff ff    	jne    802b7a <alloc_block_FF+0x21>
			blk->sva+=newblk->size;
			newblk->sva = newveradd;
			return newblk;
		}
	}
	return NULL;
  802d1f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802d24:	c9                   	leave  
  802d25:	c3                   	ret    

00802d26 <alloc_block_BF>:

//=========================================
// [5] ALLOCATE BLOCK BY BEST FIT:
//=========================================
struct MemBlock *alloc_block_BF(uint32 size)
{
  802d26:	55                   	push   %ebp
  802d27:	89 e5                	mov    %esp,%ebp
  802d29:	83 ec 28             	sub    $0x28,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_BF
	// Write your code here, remove the panic and write your code
	//panic("alloc_block_BF() is not implemented yet...!!");
	uint32 versize=size;
  802d2c:	8b 45 08             	mov    0x8(%ebp),%eax
  802d2f:	89 45 e8             	mov    %eax,-0x18(%ebp)
	struct MemBlock* blk;
	struct MemBlock* newblk=LIST_FIRST(&AvailableMemBlocksList);
  802d32:	a1 48 51 80 00       	mov    0x805148,%eax
  802d37:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	uint32 newveradd;
	uint32 newsize;
	int size_free = LIST_SIZE(&FreeMemBlocksList);
  802d3a:	a1 44 51 80 00       	mov    0x805144,%eax
  802d3f:	89 45 e0             	mov    %eax,-0x20(%ebp)

	LIST_FOREACH(blk, &FreeMemBlocksList)
  802d42:	a1 38 51 80 00       	mov    0x805138,%eax
  802d47:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802d4a:	e9 a1 00 00 00       	jmp    802df0 <alloc_block_BF+0xca>
	{
		if(blk->size == versize)
  802d4f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d52:	8b 40 0c             	mov    0xc(%eax),%eax
  802d55:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  802d58:	0f 85 8a 00 00 00    	jne    802de8 <alloc_block_BF+0xc2>
		{
			LIST_REMOVE(&FreeMemBlocksList, blk);
  802d5e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802d62:	75 17                	jne    802d7b <alloc_block_BF+0x55>
  802d64:	83 ec 04             	sub    $0x4,%esp
  802d67:	68 68 42 80 00       	push   $0x804268
  802d6c:	68 c2 00 00 00       	push   $0xc2
  802d71:	68 f7 41 80 00       	push   $0x8041f7
  802d76:	e8 3a dd ff ff       	call   800ab5 <_panic>
  802d7b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d7e:	8b 00                	mov    (%eax),%eax
  802d80:	85 c0                	test   %eax,%eax
  802d82:	74 10                	je     802d94 <alloc_block_BF+0x6e>
  802d84:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d87:	8b 00                	mov    (%eax),%eax
  802d89:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802d8c:	8b 52 04             	mov    0x4(%edx),%edx
  802d8f:	89 50 04             	mov    %edx,0x4(%eax)
  802d92:	eb 0b                	jmp    802d9f <alloc_block_BF+0x79>
  802d94:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d97:	8b 40 04             	mov    0x4(%eax),%eax
  802d9a:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802d9f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802da2:	8b 40 04             	mov    0x4(%eax),%eax
  802da5:	85 c0                	test   %eax,%eax
  802da7:	74 0f                	je     802db8 <alloc_block_BF+0x92>
  802da9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802dac:	8b 40 04             	mov    0x4(%eax),%eax
  802daf:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802db2:	8b 12                	mov    (%edx),%edx
  802db4:	89 10                	mov    %edx,(%eax)
  802db6:	eb 0a                	jmp    802dc2 <alloc_block_BF+0x9c>
  802db8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802dbb:	8b 00                	mov    (%eax),%eax
  802dbd:	a3 38 51 80 00       	mov    %eax,0x805138
  802dc2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802dc5:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802dcb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802dce:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802dd5:	a1 44 51 80 00       	mov    0x805144,%eax
  802dda:	48                   	dec    %eax
  802ddb:	a3 44 51 80 00       	mov    %eax,0x805144
			return blk;
  802de0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802de3:	e9 11 02 00 00       	jmp    802ff9 <alloc_block_BF+0x2d3>
	struct MemBlock* newblk=LIST_FIRST(&AvailableMemBlocksList);
	uint32 newveradd;
	uint32 newsize;
	int size_free = LIST_SIZE(&FreeMemBlocksList);

	LIST_FOREACH(blk, &FreeMemBlocksList)
  802de8:	a1 40 51 80 00       	mov    0x805140,%eax
  802ded:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802df0:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802df4:	74 07                	je     802dfd <alloc_block_BF+0xd7>
  802df6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802df9:	8b 00                	mov    (%eax),%eax
  802dfb:	eb 05                	jmp    802e02 <alloc_block_BF+0xdc>
  802dfd:	b8 00 00 00 00       	mov    $0x0,%eax
  802e02:	a3 40 51 80 00       	mov    %eax,0x805140
  802e07:	a1 40 51 80 00       	mov    0x805140,%eax
  802e0c:	85 c0                	test   %eax,%eax
  802e0e:	0f 85 3b ff ff ff    	jne    802d4f <alloc_block_BF+0x29>
  802e14:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802e18:	0f 85 31 ff ff ff    	jne    802d4f <alloc_block_BF+0x29>
		{
			LIST_REMOVE(&FreeMemBlocksList, blk);
			return blk;
		}
	}
	LIST_FOREACH(blk, &FreeMemBlocksList)
  802e1e:	a1 38 51 80 00       	mov    0x805138,%eax
  802e23:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802e26:	eb 27                	jmp    802e4f <alloc_block_BF+0x129>
	{
		if(blk->size > versize)
  802e28:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e2b:	8b 40 0c             	mov    0xc(%eax),%eax
  802e2e:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  802e31:	76 14                	jbe    802e47 <alloc_block_BF+0x121>
		{
			newsize = blk->size;
  802e33:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e36:	8b 40 0c             	mov    0xc(%eax),%eax
  802e39:	89 45 ec             	mov    %eax,-0x14(%ebp)
			newveradd = blk->sva;
  802e3c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e3f:	8b 40 08             	mov    0x8(%eax),%eax
  802e42:	89 45 f0             	mov    %eax,-0x10(%ebp)
			break;
  802e45:	eb 2e                	jmp    802e75 <alloc_block_BF+0x14f>
		{
			LIST_REMOVE(&FreeMemBlocksList, blk);
			return blk;
		}
	}
	LIST_FOREACH(blk, &FreeMemBlocksList)
  802e47:	a1 40 51 80 00       	mov    0x805140,%eax
  802e4c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802e4f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802e53:	74 07                	je     802e5c <alloc_block_BF+0x136>
  802e55:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e58:	8b 00                	mov    (%eax),%eax
  802e5a:	eb 05                	jmp    802e61 <alloc_block_BF+0x13b>
  802e5c:	b8 00 00 00 00       	mov    $0x0,%eax
  802e61:	a3 40 51 80 00       	mov    %eax,0x805140
  802e66:	a1 40 51 80 00       	mov    0x805140,%eax
  802e6b:	85 c0                	test   %eax,%eax
  802e6d:	75 b9                	jne    802e28 <alloc_block_BF+0x102>
  802e6f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802e73:	75 b3                	jne    802e28 <alloc_block_BF+0x102>
			newsize = blk->size;
			newveradd = blk->sva;
			break;
		}
	}
	LIST_FOREACH(blk, &FreeMemBlocksList)
  802e75:	a1 38 51 80 00       	mov    0x805138,%eax
  802e7a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802e7d:	eb 30                	jmp    802eaf <alloc_block_BF+0x189>
	{
		if(newsize > blk->size && blk->size > versize)
  802e7f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e82:	8b 40 0c             	mov    0xc(%eax),%eax
  802e85:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  802e88:	73 1d                	jae    802ea7 <alloc_block_BF+0x181>
  802e8a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e8d:	8b 40 0c             	mov    0xc(%eax),%eax
  802e90:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  802e93:	76 12                	jbe    802ea7 <alloc_block_BF+0x181>
		{
	       newsize = blk->size;
  802e95:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e98:	8b 40 0c             	mov    0xc(%eax),%eax
  802e9b:	89 45 ec             	mov    %eax,-0x14(%ebp)
		   newveradd = blk->sva;
  802e9e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ea1:	8b 40 08             	mov    0x8(%eax),%eax
  802ea4:	89 45 f0             	mov    %eax,-0x10(%ebp)
			newsize = blk->size;
			newveradd = blk->sva;
			break;
		}
	}
	LIST_FOREACH(blk, &FreeMemBlocksList)
  802ea7:	a1 40 51 80 00       	mov    0x805140,%eax
  802eac:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802eaf:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802eb3:	74 07                	je     802ebc <alloc_block_BF+0x196>
  802eb5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802eb8:	8b 00                	mov    (%eax),%eax
  802eba:	eb 05                	jmp    802ec1 <alloc_block_BF+0x19b>
  802ebc:	b8 00 00 00 00       	mov    $0x0,%eax
  802ec1:	a3 40 51 80 00       	mov    %eax,0x805140
  802ec6:	a1 40 51 80 00       	mov    0x805140,%eax
  802ecb:	85 c0                	test   %eax,%eax
  802ecd:	75 b0                	jne    802e7f <alloc_block_BF+0x159>
  802ecf:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802ed3:	75 aa                	jne    802e7f <alloc_block_BF+0x159>
		{
	       newsize = blk->size;
		   newveradd = blk->sva;
		}
	}
	LIST_FOREACH(blk, &FreeMemBlocksList)
  802ed5:	a1 38 51 80 00       	mov    0x805138,%eax
  802eda:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802edd:	e9 e4 00 00 00       	jmp    802fc6 <alloc_block_BF+0x2a0>
	{
		if(blk->size == newsize && blk->sva == newveradd)
  802ee2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ee5:	8b 40 0c             	mov    0xc(%eax),%eax
  802ee8:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  802eeb:	0f 85 cd 00 00 00    	jne    802fbe <alloc_block_BF+0x298>
  802ef1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ef4:	8b 40 08             	mov    0x8(%eax),%eax
  802ef7:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  802efa:	0f 85 be 00 00 00    	jne    802fbe <alloc_block_BF+0x298>
		{
			LIST_REMOVE(&AvailableMemBlocksList, newblk);
  802f00:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  802f04:	75 17                	jne    802f1d <alloc_block_BF+0x1f7>
  802f06:	83 ec 04             	sub    $0x4,%esp
  802f09:	68 68 42 80 00       	push   $0x804268
  802f0e:	68 db 00 00 00       	push   $0xdb
  802f13:	68 f7 41 80 00       	push   $0x8041f7
  802f18:	e8 98 db ff ff       	call   800ab5 <_panic>
  802f1d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802f20:	8b 00                	mov    (%eax),%eax
  802f22:	85 c0                	test   %eax,%eax
  802f24:	74 10                	je     802f36 <alloc_block_BF+0x210>
  802f26:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802f29:	8b 00                	mov    (%eax),%eax
  802f2b:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802f2e:	8b 52 04             	mov    0x4(%edx),%edx
  802f31:	89 50 04             	mov    %edx,0x4(%eax)
  802f34:	eb 0b                	jmp    802f41 <alloc_block_BF+0x21b>
  802f36:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802f39:	8b 40 04             	mov    0x4(%eax),%eax
  802f3c:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802f41:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802f44:	8b 40 04             	mov    0x4(%eax),%eax
  802f47:	85 c0                	test   %eax,%eax
  802f49:	74 0f                	je     802f5a <alloc_block_BF+0x234>
  802f4b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802f4e:	8b 40 04             	mov    0x4(%eax),%eax
  802f51:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802f54:	8b 12                	mov    (%edx),%edx
  802f56:	89 10                	mov    %edx,(%eax)
  802f58:	eb 0a                	jmp    802f64 <alloc_block_BF+0x23e>
  802f5a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802f5d:	8b 00                	mov    (%eax),%eax
  802f5f:	a3 48 51 80 00       	mov    %eax,0x805148
  802f64:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802f67:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802f6d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802f70:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802f77:	a1 54 51 80 00       	mov    0x805154,%eax
  802f7c:	48                   	dec    %eax
  802f7d:	a3 54 51 80 00       	mov    %eax,0x805154
			newblk->size = versize;
  802f82:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802f85:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802f88:	89 50 0c             	mov    %edx,0xc(%eax)
			newblk->sva = newveradd;
  802f8b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802f8e:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802f91:	89 50 08             	mov    %edx,0x8(%eax)
			blk->size = blk->size - versize;
  802f94:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f97:	8b 40 0c             	mov    0xc(%eax),%eax
  802f9a:	2b 45 e8             	sub    -0x18(%ebp),%eax
  802f9d:	89 c2                	mov    %eax,%edx
  802f9f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802fa2:	89 50 0c             	mov    %edx,0xc(%eax)
			blk->sva+= newblk->size;
  802fa5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802fa8:	8b 50 08             	mov    0x8(%eax),%edx
  802fab:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802fae:	8b 40 0c             	mov    0xc(%eax),%eax
  802fb1:	01 c2                	add    %eax,%edx
  802fb3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802fb6:	89 50 08             	mov    %edx,0x8(%eax)
			return newblk;
  802fb9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802fbc:	eb 3b                	jmp    802ff9 <alloc_block_BF+0x2d3>
		{
	       newsize = blk->size;
		   newveradd = blk->sva;
		}
	}
	LIST_FOREACH(blk, &FreeMemBlocksList)
  802fbe:	a1 40 51 80 00       	mov    0x805140,%eax
  802fc3:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802fc6:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802fca:	74 07                	je     802fd3 <alloc_block_BF+0x2ad>
  802fcc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802fcf:	8b 00                	mov    (%eax),%eax
  802fd1:	eb 05                	jmp    802fd8 <alloc_block_BF+0x2b2>
  802fd3:	b8 00 00 00 00       	mov    $0x0,%eax
  802fd8:	a3 40 51 80 00       	mov    %eax,0x805140
  802fdd:	a1 40 51 80 00       	mov    0x805140,%eax
  802fe2:	85 c0                	test   %eax,%eax
  802fe4:	0f 85 f8 fe ff ff    	jne    802ee2 <alloc_block_BF+0x1bc>
  802fea:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802fee:	0f 85 ee fe ff ff    	jne    802ee2 <alloc_block_BF+0x1bc>
			blk->size = blk->size - versize;
			blk->sva+= newblk->size;
			return newblk;
		}
	}
	return NULL;
  802ff4:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802ff9:	c9                   	leave  
  802ffa:	c3                   	ret    

00802ffb <alloc_block_NF>:
//=========================================
// [7] ALLOCATE BLOCK BY NEXT FIT:
//=========================================
struct MemBlock *last_allocate;
struct MemBlock *alloc_block_NF(uint32 size)
{
  802ffb:	55                   	push   %ebp
  802ffc:	89 e5                	mov    %esp,%ebp
  802ffe:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1 - BONUS] [DYNAMIC ALLOCATOR] alloc_block_NF
	// Write your code here, remove the panic and write your code
	//panic("alloc_block_NF() is not implemented yet...!!");
	uint32 versize = size;
  803001:	8b 45 08             	mov    0x8(%ebp),%eax
  803004:	89 45 f0             	mov    %eax,-0x10(%ebp)
	struct MemBlock* blk;
	struct MemBlock* newblk = LIST_FIRST(&AvailableMemBlocksList);
  803007:	a1 48 51 80 00       	mov    0x805148,%eax
  80300c:	89 45 ec             	mov    %eax,-0x14(%ebp)

	LIST_FOREACH(blk,&FreeMemBlocksList)
  80300f:	a1 38 51 80 00       	mov    0x805138,%eax
  803014:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803017:	e9 77 01 00 00       	jmp    803193 <alloc_block_NF+0x198>
	{
		if(blk->size == versize)
  80301c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80301f:	8b 40 0c             	mov    0xc(%eax),%eax
  803022:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  803025:	0f 85 8a 00 00 00    	jne    8030b5 <alloc_block_NF+0xba>
		{
			LIST_REMOVE(&FreeMemBlocksList,blk);
  80302b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80302f:	75 17                	jne    803048 <alloc_block_NF+0x4d>
  803031:	83 ec 04             	sub    $0x4,%esp
  803034:	68 68 42 80 00       	push   $0x804268
  803039:	68 f7 00 00 00       	push   $0xf7
  80303e:	68 f7 41 80 00       	push   $0x8041f7
  803043:	e8 6d da ff ff       	call   800ab5 <_panic>
  803048:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80304b:	8b 00                	mov    (%eax),%eax
  80304d:	85 c0                	test   %eax,%eax
  80304f:	74 10                	je     803061 <alloc_block_NF+0x66>
  803051:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803054:	8b 00                	mov    (%eax),%eax
  803056:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803059:	8b 52 04             	mov    0x4(%edx),%edx
  80305c:	89 50 04             	mov    %edx,0x4(%eax)
  80305f:	eb 0b                	jmp    80306c <alloc_block_NF+0x71>
  803061:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803064:	8b 40 04             	mov    0x4(%eax),%eax
  803067:	a3 3c 51 80 00       	mov    %eax,0x80513c
  80306c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80306f:	8b 40 04             	mov    0x4(%eax),%eax
  803072:	85 c0                	test   %eax,%eax
  803074:	74 0f                	je     803085 <alloc_block_NF+0x8a>
  803076:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803079:	8b 40 04             	mov    0x4(%eax),%eax
  80307c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80307f:	8b 12                	mov    (%edx),%edx
  803081:	89 10                	mov    %edx,(%eax)
  803083:	eb 0a                	jmp    80308f <alloc_block_NF+0x94>
  803085:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803088:	8b 00                	mov    (%eax),%eax
  80308a:	a3 38 51 80 00       	mov    %eax,0x805138
  80308f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803092:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803098:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80309b:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8030a2:	a1 44 51 80 00       	mov    0x805144,%eax
  8030a7:	48                   	dec    %eax
  8030a8:	a3 44 51 80 00       	mov    %eax,0x805144
			return blk;
  8030ad:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030b0:	e9 11 01 00 00       	jmp    8031c6 <alloc_block_NF+0x1cb>
		}
		else if(blk->size > versize)
  8030b5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030b8:	8b 40 0c             	mov    0xc(%eax),%eax
  8030bb:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8030be:	0f 86 c7 00 00 00    	jbe    80318b <alloc_block_NF+0x190>
		{
			LIST_REMOVE(&AvailableMemBlocksList,newblk);
  8030c4:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8030c8:	75 17                	jne    8030e1 <alloc_block_NF+0xe6>
  8030ca:	83 ec 04             	sub    $0x4,%esp
  8030cd:	68 68 42 80 00       	push   $0x804268
  8030d2:	68 fc 00 00 00       	push   $0xfc
  8030d7:	68 f7 41 80 00       	push   $0x8041f7
  8030dc:	e8 d4 d9 ff ff       	call   800ab5 <_panic>
  8030e1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8030e4:	8b 00                	mov    (%eax),%eax
  8030e6:	85 c0                	test   %eax,%eax
  8030e8:	74 10                	je     8030fa <alloc_block_NF+0xff>
  8030ea:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8030ed:	8b 00                	mov    (%eax),%eax
  8030ef:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8030f2:	8b 52 04             	mov    0x4(%edx),%edx
  8030f5:	89 50 04             	mov    %edx,0x4(%eax)
  8030f8:	eb 0b                	jmp    803105 <alloc_block_NF+0x10a>
  8030fa:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8030fd:	8b 40 04             	mov    0x4(%eax),%eax
  803100:	a3 4c 51 80 00       	mov    %eax,0x80514c
  803105:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803108:	8b 40 04             	mov    0x4(%eax),%eax
  80310b:	85 c0                	test   %eax,%eax
  80310d:	74 0f                	je     80311e <alloc_block_NF+0x123>
  80310f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803112:	8b 40 04             	mov    0x4(%eax),%eax
  803115:	8b 55 ec             	mov    -0x14(%ebp),%edx
  803118:	8b 12                	mov    (%edx),%edx
  80311a:	89 10                	mov    %edx,(%eax)
  80311c:	eb 0a                	jmp    803128 <alloc_block_NF+0x12d>
  80311e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803121:	8b 00                	mov    (%eax),%eax
  803123:	a3 48 51 80 00       	mov    %eax,0x805148
  803128:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80312b:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803131:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803134:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80313b:	a1 54 51 80 00       	mov    0x805154,%eax
  803140:	48                   	dec    %eax
  803141:	a3 54 51 80 00       	mov    %eax,0x805154
			newblk->size = versize;
  803146:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803149:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80314c:	89 50 0c             	mov    %edx,0xc(%eax)
			blk->size = blk->size-versize;
  80314f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803152:	8b 40 0c             	mov    0xc(%eax),%eax
  803155:	2b 45 f0             	sub    -0x10(%ebp),%eax
  803158:	89 c2                	mov    %eax,%edx
  80315a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80315d:	89 50 0c             	mov    %edx,0xc(%eax)
			uint32 newveradd = blk->sva;
  803160:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803163:	8b 40 08             	mov    0x8(%eax),%eax
  803166:	89 45 e8             	mov    %eax,-0x18(%ebp)
			blk->sva+=newblk->size;
  803169:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80316c:	8b 50 08             	mov    0x8(%eax),%edx
  80316f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803172:	8b 40 0c             	mov    0xc(%eax),%eax
  803175:	01 c2                	add    %eax,%edx
  803177:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80317a:	89 50 08             	mov    %edx,0x8(%eax)
			newblk->sva = newveradd;
  80317d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803180:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803183:	89 50 08             	mov    %edx,0x8(%eax)
			return newblk;
  803186:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803189:	eb 3b                	jmp    8031c6 <alloc_block_NF+0x1cb>
	//panic("alloc_block_NF() is not implemented yet...!!");
	uint32 versize = size;
	struct MemBlock* blk;
	struct MemBlock* newblk = LIST_FIRST(&AvailableMemBlocksList);

	LIST_FOREACH(blk,&FreeMemBlocksList)
  80318b:	a1 40 51 80 00       	mov    0x805140,%eax
  803190:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803193:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803197:	74 07                	je     8031a0 <alloc_block_NF+0x1a5>
  803199:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80319c:	8b 00                	mov    (%eax),%eax
  80319e:	eb 05                	jmp    8031a5 <alloc_block_NF+0x1aa>
  8031a0:	b8 00 00 00 00       	mov    $0x0,%eax
  8031a5:	a3 40 51 80 00       	mov    %eax,0x805140
  8031aa:	a1 40 51 80 00       	mov    0x805140,%eax
  8031af:	85 c0                	test   %eax,%eax
  8031b1:	0f 85 65 fe ff ff    	jne    80301c <alloc_block_NF+0x21>
  8031b7:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8031bb:	0f 85 5b fe ff ff    	jne    80301c <alloc_block_NF+0x21>
			blk->sva+=newblk->size;
			newblk->sva = newveradd;
			return newblk;
		}
	}
	return NULL;
  8031c1:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8031c6:	c9                   	leave  
  8031c7:	c3                   	ret    

008031c8 <addToAvailMemBlocksList>:

//===================================================
// [8] INSERT BLOCK (SORTED WITH MERGE) IN FREE LIST:
//===================================================
void addToAvailMemBlocksList(struct MemBlock *blockToInsert)
{
  8031c8:	55                   	push   %ebp
  8031c9:	89 e5                	mov    %esp,%ebp
  8031cb:	83 ec 08             	sub    $0x8,%esp
	blockToInsert->sva = 0;
  8031ce:	8b 45 08             	mov    0x8(%ebp),%eax
  8031d1:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
	blockToInsert->size = 0;
  8031d8:	8b 45 08             	mov    0x8(%ebp),%eax
  8031db:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
	//add to avail
	LIST_INSERT_TAIL(&AvailableMemBlocksList, blockToInsert);
  8031e2:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8031e6:	75 17                	jne    8031ff <addToAvailMemBlocksList+0x37>
  8031e8:	83 ec 04             	sub    $0x4,%esp
  8031eb:	68 10 42 80 00       	push   $0x804210
  8031f0:	68 10 01 00 00       	push   $0x110
  8031f5:	68 f7 41 80 00       	push   $0x8041f7
  8031fa:	e8 b6 d8 ff ff       	call   800ab5 <_panic>
  8031ff:	8b 15 4c 51 80 00    	mov    0x80514c,%edx
  803205:	8b 45 08             	mov    0x8(%ebp),%eax
  803208:	89 50 04             	mov    %edx,0x4(%eax)
  80320b:	8b 45 08             	mov    0x8(%ebp),%eax
  80320e:	8b 40 04             	mov    0x4(%eax),%eax
  803211:	85 c0                	test   %eax,%eax
  803213:	74 0c                	je     803221 <addToAvailMemBlocksList+0x59>
  803215:	a1 4c 51 80 00       	mov    0x80514c,%eax
  80321a:	8b 55 08             	mov    0x8(%ebp),%edx
  80321d:	89 10                	mov    %edx,(%eax)
  80321f:	eb 08                	jmp    803229 <addToAvailMemBlocksList+0x61>
  803221:	8b 45 08             	mov    0x8(%ebp),%eax
  803224:	a3 48 51 80 00       	mov    %eax,0x805148
  803229:	8b 45 08             	mov    0x8(%ebp),%eax
  80322c:	a3 4c 51 80 00       	mov    %eax,0x80514c
  803231:	8b 45 08             	mov    0x8(%ebp),%eax
  803234:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80323a:	a1 54 51 80 00       	mov    0x805154,%eax
  80323f:	40                   	inc    %eax
  803240:	a3 54 51 80 00       	mov    %eax,0x805154
}
  803245:	90                   	nop
  803246:	c9                   	leave  
  803247:	c3                   	ret    

00803248 <insert_sorted_with_merge_freeList>:
void insert_sorted_with_merge_freeList(struct MemBlock *blockToInsert)
{
  803248:	55                   	push   %ebp
  803249:	89 e5                	mov    %esp,%ebp
  80324b:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] insert_sorted_with_merge_freeList
	// Write your code here, remove the panic and write your code

	struct MemBlock* last = LIST_LAST(&FreeMemBlocksList);
  80324e:	a1 3c 51 80 00       	mov    0x80513c,%eax
  803253:	89 45 f0             	mov    %eax,-0x10(%ebp)
	//check if list empty
	if (LIST_SIZE(&(FreeMemBlocksList)) == 0)
  803256:	a1 44 51 80 00       	mov    0x805144,%eax
  80325b:	85 c0                	test   %eax,%eax
  80325d:	75 68                	jne    8032c7 <insert_sorted_with_merge_freeList+0x7f>
		LIST_INSERT_HEAD(&FreeMemBlocksList, blockToInsert);
  80325f:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803263:	75 17                	jne    80327c <insert_sorted_with_merge_freeList+0x34>
  803265:	83 ec 04             	sub    $0x4,%esp
  803268:	68 d4 41 80 00       	push   $0x8041d4
  80326d:	68 1a 01 00 00       	push   $0x11a
  803272:	68 f7 41 80 00       	push   $0x8041f7
  803277:	e8 39 d8 ff ff       	call   800ab5 <_panic>
  80327c:	8b 15 38 51 80 00    	mov    0x805138,%edx
  803282:	8b 45 08             	mov    0x8(%ebp),%eax
  803285:	89 10                	mov    %edx,(%eax)
  803287:	8b 45 08             	mov    0x8(%ebp),%eax
  80328a:	8b 00                	mov    (%eax),%eax
  80328c:	85 c0                	test   %eax,%eax
  80328e:	74 0d                	je     80329d <insert_sorted_with_merge_freeList+0x55>
  803290:	a1 38 51 80 00       	mov    0x805138,%eax
  803295:	8b 55 08             	mov    0x8(%ebp),%edx
  803298:	89 50 04             	mov    %edx,0x4(%eax)
  80329b:	eb 08                	jmp    8032a5 <insert_sorted_with_merge_freeList+0x5d>
  80329d:	8b 45 08             	mov    0x8(%ebp),%eax
  8032a0:	a3 3c 51 80 00       	mov    %eax,0x80513c
  8032a5:	8b 45 08             	mov    0x8(%ebp),%eax
  8032a8:	a3 38 51 80 00       	mov    %eax,0x805138
  8032ad:	8b 45 08             	mov    0x8(%ebp),%eax
  8032b0:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8032b7:	a1 44 51 80 00       	mov    0x805144,%eax
  8032bc:	40                   	inc    %eax
  8032bd:	a3 44 51 80 00       	mov    %eax,0x805144
		}
	}

	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  8032c2:	e9 c5 03 00 00       	jmp    80368c <insert_sorted_with_merge_freeList+0x444>
	struct MemBlock* last = LIST_LAST(&FreeMemBlocksList);
	//check if list empty
	if (LIST_SIZE(&(FreeMemBlocksList)) == 0)
		LIST_INSERT_HEAD(&FreeMemBlocksList, blockToInsert);
	//check if it's position is at last
	else if (last->sva < blockToInsert->sva) {
  8032c7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8032ca:	8b 50 08             	mov    0x8(%eax),%edx
  8032cd:	8b 45 08             	mov    0x8(%ebp),%eax
  8032d0:	8b 40 08             	mov    0x8(%eax),%eax
  8032d3:	39 c2                	cmp    %eax,%edx
  8032d5:	0f 83 b2 00 00 00    	jae    80338d <insert_sorted_with_merge_freeList+0x145>

		//if i have to merge
		if (last->sva + last->size == blockToInsert->sva) {
  8032db:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8032de:	8b 50 08             	mov    0x8(%eax),%edx
  8032e1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8032e4:	8b 40 0c             	mov    0xc(%eax),%eax
  8032e7:	01 c2                	add    %eax,%edx
  8032e9:	8b 45 08             	mov    0x8(%ebp),%eax
  8032ec:	8b 40 08             	mov    0x8(%eax),%eax
  8032ef:	39 c2                	cmp    %eax,%edx
  8032f1:	75 27                	jne    80331a <insert_sorted_with_merge_freeList+0xd2>
			last->size = last->size + blockToInsert->size;
  8032f3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8032f6:	8b 50 0c             	mov    0xc(%eax),%edx
  8032f9:	8b 45 08             	mov    0x8(%ebp),%eax
  8032fc:	8b 40 0c             	mov    0xc(%eax),%eax
  8032ff:	01 c2                	add    %eax,%edx
  803301:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803304:	89 50 0c             	mov    %edx,0xc(%eax)
			addToAvailMemBlocksList(blockToInsert);
  803307:	83 ec 0c             	sub    $0xc,%esp
  80330a:	ff 75 08             	pushl  0x8(%ebp)
  80330d:	e8 b6 fe ff ff       	call   8031c8 <addToAvailMemBlocksList>
  803312:	83 c4 10             	add    $0x10,%esp
		}
	}

	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  803315:	e9 72 03 00 00       	jmp    80368c <insert_sorted_with_merge_freeList+0x444>
		if (last->sva + last->size == blockToInsert->sva) {
			last->size = last->size + blockToInsert->size;
			addToAvailMemBlocksList(blockToInsert);

		} else {
			LIST_INSERT_AFTER(&FreeMemBlocksList, last, blockToInsert);
  80331a:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80331e:	74 06                	je     803326 <insert_sorted_with_merge_freeList+0xde>
  803320:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803324:	75 17                	jne    80333d <insert_sorted_with_merge_freeList+0xf5>
  803326:	83 ec 04             	sub    $0x4,%esp
  803329:	68 34 42 80 00       	push   $0x804234
  80332e:	68 24 01 00 00       	push   $0x124
  803333:	68 f7 41 80 00       	push   $0x8041f7
  803338:	e8 78 d7 ff ff       	call   800ab5 <_panic>
  80333d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803340:	8b 10                	mov    (%eax),%edx
  803342:	8b 45 08             	mov    0x8(%ebp),%eax
  803345:	89 10                	mov    %edx,(%eax)
  803347:	8b 45 08             	mov    0x8(%ebp),%eax
  80334a:	8b 00                	mov    (%eax),%eax
  80334c:	85 c0                	test   %eax,%eax
  80334e:	74 0b                	je     80335b <insert_sorted_with_merge_freeList+0x113>
  803350:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803353:	8b 00                	mov    (%eax),%eax
  803355:	8b 55 08             	mov    0x8(%ebp),%edx
  803358:	89 50 04             	mov    %edx,0x4(%eax)
  80335b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80335e:	8b 55 08             	mov    0x8(%ebp),%edx
  803361:	89 10                	mov    %edx,(%eax)
  803363:	8b 45 08             	mov    0x8(%ebp),%eax
  803366:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803369:	89 50 04             	mov    %edx,0x4(%eax)
  80336c:	8b 45 08             	mov    0x8(%ebp),%eax
  80336f:	8b 00                	mov    (%eax),%eax
  803371:	85 c0                	test   %eax,%eax
  803373:	75 08                	jne    80337d <insert_sorted_with_merge_freeList+0x135>
  803375:	8b 45 08             	mov    0x8(%ebp),%eax
  803378:	a3 3c 51 80 00       	mov    %eax,0x80513c
  80337d:	a1 44 51 80 00       	mov    0x805144,%eax
  803382:	40                   	inc    %eax
  803383:	a3 44 51 80 00       	mov    %eax,0x805144
		}
	}

	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  803388:	e9 ff 02 00 00       	jmp    80368c <insert_sorted_with_merge_freeList+0x444>
		} else {
			LIST_INSERT_AFTER(&FreeMemBlocksList, last, blockToInsert);
		}
	} else {
		struct MemBlock *iterator;
		LIST_FOREACH(iterator, &(FreeMemBlocksList))
  80338d:	a1 38 51 80 00       	mov    0x805138,%eax
  803392:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803395:	e9 c2 02 00 00       	jmp    80365c <insert_sorted_with_merge_freeList+0x414>
		{

			if (iterator->sva > blockToInsert->sva) {
  80339a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80339d:	8b 50 08             	mov    0x8(%eax),%edx
  8033a0:	8b 45 08             	mov    0x8(%ebp),%eax
  8033a3:	8b 40 08             	mov    0x8(%eax),%eax
  8033a6:	39 c2                	cmp    %eax,%edx
  8033a8:	0f 86 a6 02 00 00    	jbe    803654 <insert_sorted_with_merge_freeList+0x40c>

				struct MemBlock* prev = LIST_PREV(iterator);
  8033ae:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8033b1:	8b 40 04             	mov    0x4(%eax),%eax
  8033b4:	89 45 ec             	mov    %eax,-0x14(%ebp)
				if (prev == NULL) {
  8033b7:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8033bb:	0f 85 ba 00 00 00    	jne    80347b <insert_sorted_with_merge_freeList+0x233>
					//check merge
					if (blockToInsert->size + blockToInsert->sva
  8033c1:	8b 45 08             	mov    0x8(%ebp),%eax
  8033c4:	8b 50 0c             	mov    0xc(%eax),%edx
  8033c7:	8b 45 08             	mov    0x8(%ebp),%eax
  8033ca:	8b 40 08             	mov    0x8(%eax),%eax
  8033cd:	01 c2                	add    %eax,%edx
							== iterator->sva) {
  8033cf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8033d2:	8b 40 08             	mov    0x8(%eax),%eax
			if (iterator->sva > blockToInsert->sva) {

				struct MemBlock* prev = LIST_PREV(iterator);
				if (prev == NULL) {
					//check merge
					if (blockToInsert->size + blockToInsert->sva
  8033d5:	39 c2                	cmp    %eax,%edx
  8033d7:	75 33                	jne    80340c <insert_sorted_with_merge_freeList+0x1c4>
							== iterator->sva) {
						iterator->sva = blockToInsert->sva;
  8033d9:	8b 45 08             	mov    0x8(%ebp),%eax
  8033dc:	8b 50 08             	mov    0x8(%eax),%edx
  8033df:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8033e2:	89 50 08             	mov    %edx,0x8(%eax)
						iterator->size = iterator->size + blockToInsert->size;
  8033e5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8033e8:	8b 50 0c             	mov    0xc(%eax),%edx
  8033eb:	8b 45 08             	mov    0x8(%ebp),%eax
  8033ee:	8b 40 0c             	mov    0xc(%eax),%eax
  8033f1:	01 c2                	add    %eax,%edx
  8033f3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8033f6:	89 50 0c             	mov    %edx,0xc(%eax)
						addToAvailMemBlocksList(blockToInsert);
  8033f9:	83 ec 0c             	sub    $0xc,%esp
  8033fc:	ff 75 08             	pushl  0x8(%ebp)
  8033ff:	e8 c4 fd ff ff       	call   8031c8 <addToAvailMemBlocksList>
  803404:	83 c4 10             	add    $0x10,%esp

					else {
						LIST_INSERT_BEFORE(&FreeMemBlocksList, iterator,
								blockToInsert);
					}
					break;
  803407:	e9 80 02 00 00       	jmp    80368c <insert_sorted_with_merge_freeList+0x444>
						addToAvailMemBlocksList(blockToInsert);

					}

					else {
						LIST_INSERT_BEFORE(&FreeMemBlocksList, iterator,
  80340c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803410:	74 06                	je     803418 <insert_sorted_with_merge_freeList+0x1d0>
  803412:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803416:	75 17                	jne    80342f <insert_sorted_with_merge_freeList+0x1e7>
  803418:	83 ec 04             	sub    $0x4,%esp
  80341b:	68 88 42 80 00       	push   $0x804288
  803420:	68 3a 01 00 00       	push   $0x13a
  803425:	68 f7 41 80 00       	push   $0x8041f7
  80342a:	e8 86 d6 ff ff       	call   800ab5 <_panic>
  80342f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803432:	8b 50 04             	mov    0x4(%eax),%edx
  803435:	8b 45 08             	mov    0x8(%ebp),%eax
  803438:	89 50 04             	mov    %edx,0x4(%eax)
  80343b:	8b 45 08             	mov    0x8(%ebp),%eax
  80343e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803441:	89 10                	mov    %edx,(%eax)
  803443:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803446:	8b 40 04             	mov    0x4(%eax),%eax
  803449:	85 c0                	test   %eax,%eax
  80344b:	74 0d                	je     80345a <insert_sorted_with_merge_freeList+0x212>
  80344d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803450:	8b 40 04             	mov    0x4(%eax),%eax
  803453:	8b 55 08             	mov    0x8(%ebp),%edx
  803456:	89 10                	mov    %edx,(%eax)
  803458:	eb 08                	jmp    803462 <insert_sorted_with_merge_freeList+0x21a>
  80345a:	8b 45 08             	mov    0x8(%ebp),%eax
  80345d:	a3 38 51 80 00       	mov    %eax,0x805138
  803462:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803465:	8b 55 08             	mov    0x8(%ebp),%edx
  803468:	89 50 04             	mov    %edx,0x4(%eax)
  80346b:	a1 44 51 80 00       	mov    0x805144,%eax
  803470:	40                   	inc    %eax
  803471:	a3 44 51 80 00       	mov    %eax,0x805144
								blockToInsert);
					}
					break;
  803476:	e9 11 02 00 00       	jmp    80368c <insert_sorted_with_merge_freeList+0x444>
				} else {
					//prev and next merge
					if (prev->sva + prev->size + blockToInsert->size
  80347b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80347e:	8b 50 08             	mov    0x8(%eax),%edx
  803481:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803484:	8b 40 0c             	mov    0xc(%eax),%eax
  803487:	01 c2                	add    %eax,%edx
  803489:	8b 45 08             	mov    0x8(%ebp),%eax
  80348c:	8b 40 0c             	mov    0xc(%eax),%eax
  80348f:	01 c2                	add    %eax,%edx
							== iterator->sva) {
  803491:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803494:	8b 40 08             	mov    0x8(%eax),%eax
								blockToInsert);
					}
					break;
				} else {
					//prev and next merge
					if (prev->sva + prev->size + blockToInsert->size
  803497:	39 c2                	cmp    %eax,%edx
  803499:	0f 85 bf 00 00 00    	jne    80355e <insert_sorted_with_merge_freeList+0x316>
							== iterator->sva) {
						prev->size = prev->size + blockToInsert->size
  80349f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8034a2:	8b 50 0c             	mov    0xc(%eax),%edx
  8034a5:	8b 45 08             	mov    0x8(%ebp),%eax
  8034a8:	8b 40 0c             	mov    0xc(%eax),%eax
  8034ab:	01 c2                	add    %eax,%edx
								+ iterator->size;
  8034ad:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8034b0:	8b 40 0c             	mov    0xc(%eax),%eax
  8034b3:	01 c2                	add    %eax,%edx
					break;
				} else {
					//prev and next merge
					if (prev->sva + prev->size + blockToInsert->size
							== iterator->sva) {
						prev->size = prev->size + blockToInsert->size
  8034b5:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8034b8:	89 50 0c             	mov    %edx,0xc(%eax)
								+ iterator->size;
						LIST_REMOVE(&FreeMemBlocksList, iterator);
  8034bb:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8034bf:	75 17                	jne    8034d8 <insert_sorted_with_merge_freeList+0x290>
  8034c1:	83 ec 04             	sub    $0x4,%esp
  8034c4:	68 68 42 80 00       	push   $0x804268
  8034c9:	68 43 01 00 00       	push   $0x143
  8034ce:	68 f7 41 80 00       	push   $0x8041f7
  8034d3:	e8 dd d5 ff ff       	call   800ab5 <_panic>
  8034d8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8034db:	8b 00                	mov    (%eax),%eax
  8034dd:	85 c0                	test   %eax,%eax
  8034df:	74 10                	je     8034f1 <insert_sorted_with_merge_freeList+0x2a9>
  8034e1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8034e4:	8b 00                	mov    (%eax),%eax
  8034e6:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8034e9:	8b 52 04             	mov    0x4(%edx),%edx
  8034ec:	89 50 04             	mov    %edx,0x4(%eax)
  8034ef:	eb 0b                	jmp    8034fc <insert_sorted_with_merge_freeList+0x2b4>
  8034f1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8034f4:	8b 40 04             	mov    0x4(%eax),%eax
  8034f7:	a3 3c 51 80 00       	mov    %eax,0x80513c
  8034fc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8034ff:	8b 40 04             	mov    0x4(%eax),%eax
  803502:	85 c0                	test   %eax,%eax
  803504:	74 0f                	je     803515 <insert_sorted_with_merge_freeList+0x2cd>
  803506:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803509:	8b 40 04             	mov    0x4(%eax),%eax
  80350c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80350f:	8b 12                	mov    (%edx),%edx
  803511:	89 10                	mov    %edx,(%eax)
  803513:	eb 0a                	jmp    80351f <insert_sorted_with_merge_freeList+0x2d7>
  803515:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803518:	8b 00                	mov    (%eax),%eax
  80351a:	a3 38 51 80 00       	mov    %eax,0x805138
  80351f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803522:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803528:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80352b:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803532:	a1 44 51 80 00       	mov    0x805144,%eax
  803537:	48                   	dec    %eax
  803538:	a3 44 51 80 00       	mov    %eax,0x805144
						addToAvailMemBlocksList(blockToInsert);
  80353d:	83 ec 0c             	sub    $0xc,%esp
  803540:	ff 75 08             	pushl  0x8(%ebp)
  803543:	e8 80 fc ff ff       	call   8031c8 <addToAvailMemBlocksList>
  803548:	83 c4 10             	add    $0x10,%esp
						addToAvailMemBlocksList(iterator);
  80354b:	83 ec 0c             	sub    $0xc,%esp
  80354e:	ff 75 f4             	pushl  -0xc(%ebp)
  803551:	e8 72 fc ff ff       	call   8031c8 <addToAvailMemBlocksList>
  803556:	83 c4 10             	add    $0x10,%esp
					//Insert
					else {
						LIST_INSERT_BEFORE(&FreeMemBlocksList, iterator,
								blockToInsert);
					}
					break;
  803559:	e9 2e 01 00 00       	jmp    80368c <insert_sorted_with_merge_freeList+0x444>
						LIST_REMOVE(&FreeMemBlocksList, iterator);
						addToAvailMemBlocksList(blockToInsert);
						addToAvailMemBlocksList(iterator);
					}
					//previous merge
					else if (prev->sva + prev->size == blockToInsert->sva) {
  80355e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803561:	8b 50 08             	mov    0x8(%eax),%edx
  803564:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803567:	8b 40 0c             	mov    0xc(%eax),%eax
  80356a:	01 c2                	add    %eax,%edx
  80356c:	8b 45 08             	mov    0x8(%ebp),%eax
  80356f:	8b 40 08             	mov    0x8(%eax),%eax
  803572:	39 c2                	cmp    %eax,%edx
  803574:	75 27                	jne    80359d <insert_sorted_with_merge_freeList+0x355>
						prev->size = prev->size + blockToInsert->size;
  803576:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803579:	8b 50 0c             	mov    0xc(%eax),%edx
  80357c:	8b 45 08             	mov    0x8(%ebp),%eax
  80357f:	8b 40 0c             	mov    0xc(%eax),%eax
  803582:	01 c2                	add    %eax,%edx
  803584:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803587:	89 50 0c             	mov    %edx,0xc(%eax)
						addToAvailMemBlocksList(blockToInsert);
  80358a:	83 ec 0c             	sub    $0xc,%esp
  80358d:	ff 75 08             	pushl  0x8(%ebp)
  803590:	e8 33 fc ff ff       	call   8031c8 <addToAvailMemBlocksList>
  803595:	83 c4 10             	add    $0x10,%esp
					//Insert
					else {
						LIST_INSERT_BEFORE(&FreeMemBlocksList, iterator,
								blockToInsert);
					}
					break;
  803598:	e9 ef 00 00 00       	jmp    80368c <insert_sorted_with_merge_freeList+0x444>
					else if (prev->sva + prev->size == blockToInsert->sva) {
						prev->size = prev->size + blockToInsert->size;
						addToAvailMemBlocksList(blockToInsert);
					}
					//next merge
					else if (blockToInsert->size + blockToInsert->sva
  80359d:	8b 45 08             	mov    0x8(%ebp),%eax
  8035a0:	8b 50 0c             	mov    0xc(%eax),%edx
  8035a3:	8b 45 08             	mov    0x8(%ebp),%eax
  8035a6:	8b 40 08             	mov    0x8(%eax),%eax
  8035a9:	01 c2                	add    %eax,%edx
							== iterator->sva) {
  8035ab:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8035ae:	8b 40 08             	mov    0x8(%eax),%eax
					else if (prev->sva + prev->size == blockToInsert->sva) {
						prev->size = prev->size + blockToInsert->size;
						addToAvailMemBlocksList(blockToInsert);
					}
					//next merge
					else if (blockToInsert->size + blockToInsert->sva
  8035b1:	39 c2                	cmp    %eax,%edx
  8035b3:	75 33                	jne    8035e8 <insert_sorted_with_merge_freeList+0x3a0>
							== iterator->sva) {
						iterator->sva = blockToInsert->sva;
  8035b5:	8b 45 08             	mov    0x8(%ebp),%eax
  8035b8:	8b 50 08             	mov    0x8(%eax),%edx
  8035bb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8035be:	89 50 08             	mov    %edx,0x8(%eax)
						iterator->size = iterator->size + blockToInsert->size;
  8035c1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8035c4:	8b 50 0c             	mov    0xc(%eax),%edx
  8035c7:	8b 45 08             	mov    0x8(%ebp),%eax
  8035ca:	8b 40 0c             	mov    0xc(%eax),%eax
  8035cd:	01 c2                	add    %eax,%edx
  8035cf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8035d2:	89 50 0c             	mov    %edx,0xc(%eax)
						addToAvailMemBlocksList(blockToInsert);
  8035d5:	83 ec 0c             	sub    $0xc,%esp
  8035d8:	ff 75 08             	pushl  0x8(%ebp)
  8035db:	e8 e8 fb ff ff       	call   8031c8 <addToAvailMemBlocksList>
  8035e0:	83 c4 10             	add    $0x10,%esp
					//Insert
					else {
						LIST_INSERT_BEFORE(&FreeMemBlocksList, iterator,
								blockToInsert);
					}
					break;
  8035e3:	e9 a4 00 00 00       	jmp    80368c <insert_sorted_with_merge_freeList+0x444>
						iterator->size = iterator->size + blockToInsert->size;
						addToAvailMemBlocksList(blockToInsert);
					}
					//Insert
					else {
						LIST_INSERT_BEFORE(&FreeMemBlocksList, iterator,
  8035e8:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8035ec:	74 06                	je     8035f4 <insert_sorted_with_merge_freeList+0x3ac>
  8035ee:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8035f2:	75 17                	jne    80360b <insert_sorted_with_merge_freeList+0x3c3>
  8035f4:	83 ec 04             	sub    $0x4,%esp
  8035f7:	68 88 42 80 00       	push   $0x804288
  8035fc:	68 56 01 00 00       	push   $0x156
  803601:	68 f7 41 80 00       	push   $0x8041f7
  803606:	e8 aa d4 ff ff       	call   800ab5 <_panic>
  80360b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80360e:	8b 50 04             	mov    0x4(%eax),%edx
  803611:	8b 45 08             	mov    0x8(%ebp),%eax
  803614:	89 50 04             	mov    %edx,0x4(%eax)
  803617:	8b 45 08             	mov    0x8(%ebp),%eax
  80361a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80361d:	89 10                	mov    %edx,(%eax)
  80361f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803622:	8b 40 04             	mov    0x4(%eax),%eax
  803625:	85 c0                	test   %eax,%eax
  803627:	74 0d                	je     803636 <insert_sorted_with_merge_freeList+0x3ee>
  803629:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80362c:	8b 40 04             	mov    0x4(%eax),%eax
  80362f:	8b 55 08             	mov    0x8(%ebp),%edx
  803632:	89 10                	mov    %edx,(%eax)
  803634:	eb 08                	jmp    80363e <insert_sorted_with_merge_freeList+0x3f6>
  803636:	8b 45 08             	mov    0x8(%ebp),%eax
  803639:	a3 38 51 80 00       	mov    %eax,0x805138
  80363e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803641:	8b 55 08             	mov    0x8(%ebp),%edx
  803644:	89 50 04             	mov    %edx,0x4(%eax)
  803647:	a1 44 51 80 00       	mov    0x805144,%eax
  80364c:	40                   	inc    %eax
  80364d:	a3 44 51 80 00       	mov    %eax,0x805144
								blockToInsert);
					}
					break;
  803652:	eb 38                	jmp    80368c <insert_sorted_with_merge_freeList+0x444>
		} else {
			LIST_INSERT_AFTER(&FreeMemBlocksList, last, blockToInsert);
		}
	} else {
		struct MemBlock *iterator;
		LIST_FOREACH(iterator, &(FreeMemBlocksList))
  803654:	a1 40 51 80 00       	mov    0x805140,%eax
  803659:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80365c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803660:	74 07                	je     803669 <insert_sorted_with_merge_freeList+0x421>
  803662:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803665:	8b 00                	mov    (%eax),%eax
  803667:	eb 05                	jmp    80366e <insert_sorted_with_merge_freeList+0x426>
  803669:	b8 00 00 00 00       	mov    $0x0,%eax
  80366e:	a3 40 51 80 00       	mov    %eax,0x805140
  803673:	a1 40 51 80 00       	mov    0x805140,%eax
  803678:	85 c0                	test   %eax,%eax
  80367a:	0f 85 1a fd ff ff    	jne    80339a <insert_sorted_with_merge_freeList+0x152>
  803680:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803684:	0f 85 10 fd ff ff    	jne    80339a <insert_sorted_with_merge_freeList+0x152>
		}
	}

	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  80368a:	eb 00                	jmp    80368c <insert_sorted_with_merge_freeList+0x444>
  80368c:	90                   	nop
  80368d:	c9                   	leave  
  80368e:	c3                   	ret    
  80368f:	90                   	nop

00803690 <__udivdi3>:
  803690:	55                   	push   %ebp
  803691:	57                   	push   %edi
  803692:	56                   	push   %esi
  803693:	53                   	push   %ebx
  803694:	83 ec 1c             	sub    $0x1c,%esp
  803697:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  80369b:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  80369f:	8b 7c 24 38          	mov    0x38(%esp),%edi
  8036a3:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8036a7:	89 ca                	mov    %ecx,%edx
  8036a9:	89 f8                	mov    %edi,%eax
  8036ab:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  8036af:	85 f6                	test   %esi,%esi
  8036b1:	75 2d                	jne    8036e0 <__udivdi3+0x50>
  8036b3:	39 cf                	cmp    %ecx,%edi
  8036b5:	77 65                	ja     80371c <__udivdi3+0x8c>
  8036b7:	89 fd                	mov    %edi,%ebp
  8036b9:	85 ff                	test   %edi,%edi
  8036bb:	75 0b                	jne    8036c8 <__udivdi3+0x38>
  8036bd:	b8 01 00 00 00       	mov    $0x1,%eax
  8036c2:	31 d2                	xor    %edx,%edx
  8036c4:	f7 f7                	div    %edi
  8036c6:	89 c5                	mov    %eax,%ebp
  8036c8:	31 d2                	xor    %edx,%edx
  8036ca:	89 c8                	mov    %ecx,%eax
  8036cc:	f7 f5                	div    %ebp
  8036ce:	89 c1                	mov    %eax,%ecx
  8036d0:	89 d8                	mov    %ebx,%eax
  8036d2:	f7 f5                	div    %ebp
  8036d4:	89 cf                	mov    %ecx,%edi
  8036d6:	89 fa                	mov    %edi,%edx
  8036d8:	83 c4 1c             	add    $0x1c,%esp
  8036db:	5b                   	pop    %ebx
  8036dc:	5e                   	pop    %esi
  8036dd:	5f                   	pop    %edi
  8036de:	5d                   	pop    %ebp
  8036df:	c3                   	ret    
  8036e0:	39 ce                	cmp    %ecx,%esi
  8036e2:	77 28                	ja     80370c <__udivdi3+0x7c>
  8036e4:	0f bd fe             	bsr    %esi,%edi
  8036e7:	83 f7 1f             	xor    $0x1f,%edi
  8036ea:	75 40                	jne    80372c <__udivdi3+0x9c>
  8036ec:	39 ce                	cmp    %ecx,%esi
  8036ee:	72 0a                	jb     8036fa <__udivdi3+0x6a>
  8036f0:	3b 44 24 08          	cmp    0x8(%esp),%eax
  8036f4:	0f 87 9e 00 00 00    	ja     803798 <__udivdi3+0x108>
  8036fa:	b8 01 00 00 00       	mov    $0x1,%eax
  8036ff:	89 fa                	mov    %edi,%edx
  803701:	83 c4 1c             	add    $0x1c,%esp
  803704:	5b                   	pop    %ebx
  803705:	5e                   	pop    %esi
  803706:	5f                   	pop    %edi
  803707:	5d                   	pop    %ebp
  803708:	c3                   	ret    
  803709:	8d 76 00             	lea    0x0(%esi),%esi
  80370c:	31 ff                	xor    %edi,%edi
  80370e:	31 c0                	xor    %eax,%eax
  803710:	89 fa                	mov    %edi,%edx
  803712:	83 c4 1c             	add    $0x1c,%esp
  803715:	5b                   	pop    %ebx
  803716:	5e                   	pop    %esi
  803717:	5f                   	pop    %edi
  803718:	5d                   	pop    %ebp
  803719:	c3                   	ret    
  80371a:	66 90                	xchg   %ax,%ax
  80371c:	89 d8                	mov    %ebx,%eax
  80371e:	f7 f7                	div    %edi
  803720:	31 ff                	xor    %edi,%edi
  803722:	89 fa                	mov    %edi,%edx
  803724:	83 c4 1c             	add    $0x1c,%esp
  803727:	5b                   	pop    %ebx
  803728:	5e                   	pop    %esi
  803729:	5f                   	pop    %edi
  80372a:	5d                   	pop    %ebp
  80372b:	c3                   	ret    
  80372c:	bd 20 00 00 00       	mov    $0x20,%ebp
  803731:	89 eb                	mov    %ebp,%ebx
  803733:	29 fb                	sub    %edi,%ebx
  803735:	89 f9                	mov    %edi,%ecx
  803737:	d3 e6                	shl    %cl,%esi
  803739:	89 c5                	mov    %eax,%ebp
  80373b:	88 d9                	mov    %bl,%cl
  80373d:	d3 ed                	shr    %cl,%ebp
  80373f:	89 e9                	mov    %ebp,%ecx
  803741:	09 f1                	or     %esi,%ecx
  803743:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  803747:	89 f9                	mov    %edi,%ecx
  803749:	d3 e0                	shl    %cl,%eax
  80374b:	89 c5                	mov    %eax,%ebp
  80374d:	89 d6                	mov    %edx,%esi
  80374f:	88 d9                	mov    %bl,%cl
  803751:	d3 ee                	shr    %cl,%esi
  803753:	89 f9                	mov    %edi,%ecx
  803755:	d3 e2                	shl    %cl,%edx
  803757:	8b 44 24 08          	mov    0x8(%esp),%eax
  80375b:	88 d9                	mov    %bl,%cl
  80375d:	d3 e8                	shr    %cl,%eax
  80375f:	09 c2                	or     %eax,%edx
  803761:	89 d0                	mov    %edx,%eax
  803763:	89 f2                	mov    %esi,%edx
  803765:	f7 74 24 0c          	divl   0xc(%esp)
  803769:	89 d6                	mov    %edx,%esi
  80376b:	89 c3                	mov    %eax,%ebx
  80376d:	f7 e5                	mul    %ebp
  80376f:	39 d6                	cmp    %edx,%esi
  803771:	72 19                	jb     80378c <__udivdi3+0xfc>
  803773:	74 0b                	je     803780 <__udivdi3+0xf0>
  803775:	89 d8                	mov    %ebx,%eax
  803777:	31 ff                	xor    %edi,%edi
  803779:	e9 58 ff ff ff       	jmp    8036d6 <__udivdi3+0x46>
  80377e:	66 90                	xchg   %ax,%ax
  803780:	8b 54 24 08          	mov    0x8(%esp),%edx
  803784:	89 f9                	mov    %edi,%ecx
  803786:	d3 e2                	shl    %cl,%edx
  803788:	39 c2                	cmp    %eax,%edx
  80378a:	73 e9                	jae    803775 <__udivdi3+0xe5>
  80378c:	8d 43 ff             	lea    -0x1(%ebx),%eax
  80378f:	31 ff                	xor    %edi,%edi
  803791:	e9 40 ff ff ff       	jmp    8036d6 <__udivdi3+0x46>
  803796:	66 90                	xchg   %ax,%ax
  803798:	31 c0                	xor    %eax,%eax
  80379a:	e9 37 ff ff ff       	jmp    8036d6 <__udivdi3+0x46>
  80379f:	90                   	nop

008037a0 <__umoddi3>:
  8037a0:	55                   	push   %ebp
  8037a1:	57                   	push   %edi
  8037a2:	56                   	push   %esi
  8037a3:	53                   	push   %ebx
  8037a4:	83 ec 1c             	sub    $0x1c,%esp
  8037a7:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  8037ab:	8b 74 24 34          	mov    0x34(%esp),%esi
  8037af:	8b 7c 24 38          	mov    0x38(%esp),%edi
  8037b3:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  8037b7:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8037bb:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8037bf:	89 f3                	mov    %esi,%ebx
  8037c1:	89 fa                	mov    %edi,%edx
  8037c3:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8037c7:	89 34 24             	mov    %esi,(%esp)
  8037ca:	85 c0                	test   %eax,%eax
  8037cc:	75 1a                	jne    8037e8 <__umoddi3+0x48>
  8037ce:	39 f7                	cmp    %esi,%edi
  8037d0:	0f 86 a2 00 00 00    	jbe    803878 <__umoddi3+0xd8>
  8037d6:	89 c8                	mov    %ecx,%eax
  8037d8:	89 f2                	mov    %esi,%edx
  8037da:	f7 f7                	div    %edi
  8037dc:	89 d0                	mov    %edx,%eax
  8037de:	31 d2                	xor    %edx,%edx
  8037e0:	83 c4 1c             	add    $0x1c,%esp
  8037e3:	5b                   	pop    %ebx
  8037e4:	5e                   	pop    %esi
  8037e5:	5f                   	pop    %edi
  8037e6:	5d                   	pop    %ebp
  8037e7:	c3                   	ret    
  8037e8:	39 f0                	cmp    %esi,%eax
  8037ea:	0f 87 ac 00 00 00    	ja     80389c <__umoddi3+0xfc>
  8037f0:	0f bd e8             	bsr    %eax,%ebp
  8037f3:	83 f5 1f             	xor    $0x1f,%ebp
  8037f6:	0f 84 ac 00 00 00    	je     8038a8 <__umoddi3+0x108>
  8037fc:	bf 20 00 00 00       	mov    $0x20,%edi
  803801:	29 ef                	sub    %ebp,%edi
  803803:	89 fe                	mov    %edi,%esi
  803805:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  803809:	89 e9                	mov    %ebp,%ecx
  80380b:	d3 e0                	shl    %cl,%eax
  80380d:	89 d7                	mov    %edx,%edi
  80380f:	89 f1                	mov    %esi,%ecx
  803811:	d3 ef                	shr    %cl,%edi
  803813:	09 c7                	or     %eax,%edi
  803815:	89 e9                	mov    %ebp,%ecx
  803817:	d3 e2                	shl    %cl,%edx
  803819:	89 14 24             	mov    %edx,(%esp)
  80381c:	89 d8                	mov    %ebx,%eax
  80381e:	d3 e0                	shl    %cl,%eax
  803820:	89 c2                	mov    %eax,%edx
  803822:	8b 44 24 08          	mov    0x8(%esp),%eax
  803826:	d3 e0                	shl    %cl,%eax
  803828:	89 44 24 04          	mov    %eax,0x4(%esp)
  80382c:	8b 44 24 08          	mov    0x8(%esp),%eax
  803830:	89 f1                	mov    %esi,%ecx
  803832:	d3 e8                	shr    %cl,%eax
  803834:	09 d0                	or     %edx,%eax
  803836:	d3 eb                	shr    %cl,%ebx
  803838:	89 da                	mov    %ebx,%edx
  80383a:	f7 f7                	div    %edi
  80383c:	89 d3                	mov    %edx,%ebx
  80383e:	f7 24 24             	mull   (%esp)
  803841:	89 c6                	mov    %eax,%esi
  803843:	89 d1                	mov    %edx,%ecx
  803845:	39 d3                	cmp    %edx,%ebx
  803847:	0f 82 87 00 00 00    	jb     8038d4 <__umoddi3+0x134>
  80384d:	0f 84 91 00 00 00    	je     8038e4 <__umoddi3+0x144>
  803853:	8b 54 24 04          	mov    0x4(%esp),%edx
  803857:	29 f2                	sub    %esi,%edx
  803859:	19 cb                	sbb    %ecx,%ebx
  80385b:	89 d8                	mov    %ebx,%eax
  80385d:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  803861:	d3 e0                	shl    %cl,%eax
  803863:	89 e9                	mov    %ebp,%ecx
  803865:	d3 ea                	shr    %cl,%edx
  803867:	09 d0                	or     %edx,%eax
  803869:	89 e9                	mov    %ebp,%ecx
  80386b:	d3 eb                	shr    %cl,%ebx
  80386d:	89 da                	mov    %ebx,%edx
  80386f:	83 c4 1c             	add    $0x1c,%esp
  803872:	5b                   	pop    %ebx
  803873:	5e                   	pop    %esi
  803874:	5f                   	pop    %edi
  803875:	5d                   	pop    %ebp
  803876:	c3                   	ret    
  803877:	90                   	nop
  803878:	89 fd                	mov    %edi,%ebp
  80387a:	85 ff                	test   %edi,%edi
  80387c:	75 0b                	jne    803889 <__umoddi3+0xe9>
  80387e:	b8 01 00 00 00       	mov    $0x1,%eax
  803883:	31 d2                	xor    %edx,%edx
  803885:	f7 f7                	div    %edi
  803887:	89 c5                	mov    %eax,%ebp
  803889:	89 f0                	mov    %esi,%eax
  80388b:	31 d2                	xor    %edx,%edx
  80388d:	f7 f5                	div    %ebp
  80388f:	89 c8                	mov    %ecx,%eax
  803891:	f7 f5                	div    %ebp
  803893:	89 d0                	mov    %edx,%eax
  803895:	e9 44 ff ff ff       	jmp    8037de <__umoddi3+0x3e>
  80389a:	66 90                	xchg   %ax,%ax
  80389c:	89 c8                	mov    %ecx,%eax
  80389e:	89 f2                	mov    %esi,%edx
  8038a0:	83 c4 1c             	add    $0x1c,%esp
  8038a3:	5b                   	pop    %ebx
  8038a4:	5e                   	pop    %esi
  8038a5:	5f                   	pop    %edi
  8038a6:	5d                   	pop    %ebp
  8038a7:	c3                   	ret    
  8038a8:	3b 04 24             	cmp    (%esp),%eax
  8038ab:	72 06                	jb     8038b3 <__umoddi3+0x113>
  8038ad:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  8038b1:	77 0f                	ja     8038c2 <__umoddi3+0x122>
  8038b3:	89 f2                	mov    %esi,%edx
  8038b5:	29 f9                	sub    %edi,%ecx
  8038b7:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  8038bb:	89 14 24             	mov    %edx,(%esp)
  8038be:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8038c2:	8b 44 24 04          	mov    0x4(%esp),%eax
  8038c6:	8b 14 24             	mov    (%esp),%edx
  8038c9:	83 c4 1c             	add    $0x1c,%esp
  8038cc:	5b                   	pop    %ebx
  8038cd:	5e                   	pop    %esi
  8038ce:	5f                   	pop    %edi
  8038cf:	5d                   	pop    %ebp
  8038d0:	c3                   	ret    
  8038d1:	8d 76 00             	lea    0x0(%esi),%esi
  8038d4:	2b 04 24             	sub    (%esp),%eax
  8038d7:	19 fa                	sbb    %edi,%edx
  8038d9:	89 d1                	mov    %edx,%ecx
  8038db:	89 c6                	mov    %eax,%esi
  8038dd:	e9 71 ff ff ff       	jmp    803853 <__umoddi3+0xb3>
  8038e2:	66 90                	xchg   %ax,%ax
  8038e4:	39 44 24 04          	cmp    %eax,0x4(%esp)
  8038e8:	72 ea                	jb     8038d4 <__umoddi3+0x134>
  8038ea:	89 d9                	mov    %ebx,%ecx
  8038ec:	e9 62 ff ff ff       	jmp    803853 <__umoddi3+0xb3>
