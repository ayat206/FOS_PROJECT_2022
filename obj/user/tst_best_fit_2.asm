
obj/user/tst_best_fit_2:     file format elf32-i386


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
  800031:	e8 b5 08 00 00       	call   8008eb <libmain>
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
  80003c:	53                   	push   %ebx
  80003d:	83 ec 70             	sub    $0x70,%esp
	sys_set_uheap_strategy(UHP_PLACE_BESTFIT);
  800040:	83 ec 0c             	sub    $0xc,%esp
  800043:	6a 02                	push   $0x2
  800045:	e8 44 25 00 00       	call   80258e <sys_set_uheap_strategy>
  80004a:	83 c4 10             	add    $0x10,%esp

	//Initial test to ensure it works on "PLACEMENT" not "REPLACEMENT"
	{
		uint8 fullWS = 1;
  80004d:	c6 45 f7 01          	movb   $0x1,-0x9(%ebp)
		for (int i = 0; i < myEnv->page_WS_max_size; ++i)
  800051:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800058:	eb 29                	jmp    800083 <_main+0x4b>
		{
			if (myEnv->__uptr_pws[i].empty)
  80005a:	a1 20 50 80 00       	mov    0x805020,%eax
  80005f:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  800065:	8b 55 f0             	mov    -0x10(%ebp),%edx
  800068:	89 d0                	mov    %edx,%eax
  80006a:	01 c0                	add    %eax,%eax
  80006c:	01 d0                	add    %edx,%eax
  80006e:	c1 e0 03             	shl    $0x3,%eax
  800071:	01 c8                	add    %ecx,%eax
  800073:	8a 40 04             	mov    0x4(%eax),%al
  800076:	84 c0                	test   %al,%al
  800078:	74 06                	je     800080 <_main+0x48>
			{
				fullWS = 0;
  80007a:	c6 45 f7 00          	movb   $0x0,-0x9(%ebp)
				break;
  80007e:	eb 12                	jmp    800092 <_main+0x5a>
	sys_set_uheap_strategy(UHP_PLACE_BESTFIT);

	//Initial test to ensure it works on "PLACEMENT" not "REPLACEMENT"
	{
		uint8 fullWS = 1;
		for (int i = 0; i < myEnv->page_WS_max_size; ++i)
  800080:	ff 45 f0             	incl   -0x10(%ebp)
  800083:	a1 20 50 80 00       	mov    0x805020,%eax
  800088:	8b 50 74             	mov    0x74(%eax),%edx
  80008b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80008e:	39 c2                	cmp    %eax,%edx
  800090:	77 c8                	ja     80005a <_main+0x22>
			{
				fullWS = 0;
				break;
			}
		}
		if (fullWS) panic("Please increase the WS size");
  800092:	80 7d f7 00          	cmpb   $0x0,-0x9(%ebp)
  800096:	74 14                	je     8000ac <_main+0x74>
  800098:	83 ec 04             	sub    $0x4,%esp
  80009b:	68 80 38 80 00       	push   $0x803880
  8000a0:	6a 1b                	push   $0x1b
  8000a2:	68 9c 38 80 00       	push   $0x80389c
  8000a7:	e8 7b 09 00 00       	call   800a27 <_panic>
	}
	/*Dummy malloc to enforce the UHEAP initializations*/
	malloc(0);
  8000ac:	83 ec 0c             	sub    $0xc,%esp
  8000af:	6a 00                	push   $0x0
  8000b1:	e8 b7 1b 00 00       	call   801c6d <malloc>
  8000b6:	83 c4 10             	add    $0x10,%esp
	/*=================================================*/

	int Mega = 1024*1024;
  8000b9:	c7 45 ec 00 00 10 00 	movl   $0x100000,-0x14(%ebp)
	int kilo = 1024;
  8000c0:	c7 45 e8 00 04 00 00 	movl   $0x400,-0x18(%ebp)
	void* ptr_allocations[20] = {0};
  8000c7:	8d 55 90             	lea    -0x70(%ebp),%edx
  8000ca:	b9 14 00 00 00       	mov    $0x14,%ecx
  8000cf:	b8 00 00 00 00       	mov    $0x0,%eax
  8000d4:	89 d7                	mov    %edx,%edi
  8000d6:	f3 ab                	rep stos %eax,%es:(%edi)

	//[1] Attempt to allocate more than heap size
	{
		ptr_allocations[0] = malloc(USER_HEAP_MAX - USER_HEAP_START + 1);
  8000d8:	83 ec 0c             	sub    $0xc,%esp
  8000db:	68 01 00 00 20       	push   $0x20000001
  8000e0:	e8 88 1b 00 00       	call   801c6d <malloc>
  8000e5:	83 c4 10             	add    $0x10,%esp
  8000e8:	89 45 90             	mov    %eax,-0x70(%ebp)
		if (ptr_allocations[0] != NULL) panic("Malloc: Attempt to allocate more than heap size, should return NULL");
  8000eb:	8b 45 90             	mov    -0x70(%ebp),%eax
  8000ee:	85 c0                	test   %eax,%eax
  8000f0:	74 14                	je     800106 <_main+0xce>
  8000f2:	83 ec 04             	sub    $0x4,%esp
  8000f5:	68 b4 38 80 00       	push   $0x8038b4
  8000fa:	6a 28                	push   $0x28
  8000fc:	68 9c 38 80 00       	push   $0x80389c
  800101:	e8 21 09 00 00       	call   800a27 <_panic>
	}
	//[2] Attempt to allocate space more than any available fragment
	//	a) Create Fragments
	{
		//2 MB
		int freeFrames = sys_calculate_free_frames() ;
  800106:	e8 6e 1f 00 00       	call   802079 <sys_calculate_free_frames>
  80010b:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		int usedDiskPages = sys_pf_calculate_allocated_pages();
  80010e:	e8 06 20 00 00       	call   802119 <sys_pf_calculate_allocated_pages>
  800113:	89 45 e0             	mov    %eax,-0x20(%ebp)
		ptr_allocations[0] = malloc(2*Mega-kilo);
  800116:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800119:	01 c0                	add    %eax,%eax
  80011b:	2b 45 e8             	sub    -0x18(%ebp),%eax
  80011e:	83 ec 0c             	sub    $0xc,%esp
  800121:	50                   	push   %eax
  800122:	e8 46 1b 00 00       	call   801c6d <malloc>
  800127:	83 c4 10             	add    $0x10,%esp
  80012a:	89 45 90             	mov    %eax,-0x70(%ebp)
		if ((uint32) ptr_allocations[0] != (USER_HEAP_START) ) panic("Wrong start address for the allocated space... ");
  80012d:	8b 45 90             	mov    -0x70(%ebp),%eax
  800130:	3d 00 00 00 80       	cmp    $0x80000000,%eax
  800135:	74 14                	je     80014b <_main+0x113>
  800137:	83 ec 04             	sub    $0x4,%esp
  80013a:	68 f8 38 80 00       	push   $0x8038f8
  80013f:	6a 31                	push   $0x31
  800141:	68 9c 38 80 00       	push   $0x80389c
  800146:	e8 dc 08 00 00       	call   800a27 <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 512+1 ) panic("Wrong allocation: ");
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  512) panic("Wrong page file allocation: ");
  80014b:	e8 c9 1f 00 00       	call   802119 <sys_pf_calculate_allocated_pages>
  800150:	2b 45 e0             	sub    -0x20(%ebp),%eax
  800153:	3d 00 02 00 00       	cmp    $0x200,%eax
  800158:	74 14                	je     80016e <_main+0x136>
  80015a:	83 ec 04             	sub    $0x4,%esp
  80015d:	68 28 39 80 00       	push   $0x803928
  800162:	6a 33                	push   $0x33
  800164:	68 9c 38 80 00       	push   $0x80389c
  800169:	e8 b9 08 00 00       	call   800a27 <_panic>

		//2 MB
		freeFrames = sys_calculate_free_frames() ;
  80016e:	e8 06 1f 00 00       	call   802079 <sys_calculate_free_frames>
  800173:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  800176:	e8 9e 1f 00 00       	call   802119 <sys_pf_calculate_allocated_pages>
  80017b:	89 45 e0             	mov    %eax,-0x20(%ebp)
		ptr_allocations[1] = malloc(2*Mega-kilo);
  80017e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800181:	01 c0                	add    %eax,%eax
  800183:	2b 45 e8             	sub    -0x18(%ebp),%eax
  800186:	83 ec 0c             	sub    $0xc,%esp
  800189:	50                   	push   %eax
  80018a:	e8 de 1a 00 00       	call   801c6d <malloc>
  80018f:	83 c4 10             	add    $0x10,%esp
  800192:	89 45 94             	mov    %eax,-0x6c(%ebp)
		if ((uint32) ptr_allocations[1] != (USER_HEAP_START + 2*Mega)) panic("Wrong start address for the allocated space... ");
  800195:	8b 45 94             	mov    -0x6c(%ebp),%eax
  800198:	89 c2                	mov    %eax,%edx
  80019a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80019d:	01 c0                	add    %eax,%eax
  80019f:	05 00 00 00 80       	add    $0x80000000,%eax
  8001a4:	39 c2                	cmp    %eax,%edx
  8001a6:	74 14                	je     8001bc <_main+0x184>
  8001a8:	83 ec 04             	sub    $0x4,%esp
  8001ab:	68 f8 38 80 00       	push   $0x8038f8
  8001b0:	6a 39                	push   $0x39
  8001b2:	68 9c 38 80 00       	push   $0x80389c
  8001b7:	e8 6b 08 00 00       	call   800a27 <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 512 ) panic("Wrong allocation: ");
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  512) panic("Wrong page file allocation: ");
  8001bc:	e8 58 1f 00 00       	call   802119 <sys_pf_calculate_allocated_pages>
  8001c1:	2b 45 e0             	sub    -0x20(%ebp),%eax
  8001c4:	3d 00 02 00 00       	cmp    $0x200,%eax
  8001c9:	74 14                	je     8001df <_main+0x1a7>
  8001cb:	83 ec 04             	sub    $0x4,%esp
  8001ce:	68 28 39 80 00       	push   $0x803928
  8001d3:	6a 3b                	push   $0x3b
  8001d5:	68 9c 38 80 00       	push   $0x80389c
  8001da:	e8 48 08 00 00       	call   800a27 <_panic>

		//2 KB
		freeFrames = sys_calculate_free_frames() ;
  8001df:	e8 95 1e 00 00       	call   802079 <sys_calculate_free_frames>
  8001e4:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  8001e7:	e8 2d 1f 00 00       	call   802119 <sys_pf_calculate_allocated_pages>
  8001ec:	89 45 e0             	mov    %eax,-0x20(%ebp)
		ptr_allocations[2] = malloc(2*kilo);
  8001ef:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8001f2:	01 c0                	add    %eax,%eax
  8001f4:	83 ec 0c             	sub    $0xc,%esp
  8001f7:	50                   	push   %eax
  8001f8:	e8 70 1a 00 00       	call   801c6d <malloc>
  8001fd:	83 c4 10             	add    $0x10,%esp
  800200:	89 45 98             	mov    %eax,-0x68(%ebp)
		if ((uint32) ptr_allocations[2] != (USER_HEAP_START + 4*Mega)) panic("Wrong start address for the allocated space... ");
  800203:	8b 45 98             	mov    -0x68(%ebp),%eax
  800206:	89 c2                	mov    %eax,%edx
  800208:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80020b:	c1 e0 02             	shl    $0x2,%eax
  80020e:	05 00 00 00 80       	add    $0x80000000,%eax
  800213:	39 c2                	cmp    %eax,%edx
  800215:	74 14                	je     80022b <_main+0x1f3>
  800217:	83 ec 04             	sub    $0x4,%esp
  80021a:	68 f8 38 80 00       	push   $0x8038f8
  80021f:	6a 41                	push   $0x41
  800221:	68 9c 38 80 00       	push   $0x80389c
  800226:	e8 fc 07 00 00       	call   800a27 <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 1+1 ) panic("Wrong allocation: ");
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  1) panic("Wrong page file allocation: ");
  80022b:	e8 e9 1e 00 00       	call   802119 <sys_pf_calculate_allocated_pages>
  800230:	2b 45 e0             	sub    -0x20(%ebp),%eax
  800233:	83 f8 01             	cmp    $0x1,%eax
  800236:	74 14                	je     80024c <_main+0x214>
  800238:	83 ec 04             	sub    $0x4,%esp
  80023b:	68 28 39 80 00       	push   $0x803928
  800240:	6a 43                	push   $0x43
  800242:	68 9c 38 80 00       	push   $0x80389c
  800247:	e8 db 07 00 00       	call   800a27 <_panic>

		//2 KB
		freeFrames = sys_calculate_free_frames() ;
  80024c:	e8 28 1e 00 00       	call   802079 <sys_calculate_free_frames>
  800251:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  800254:	e8 c0 1e 00 00       	call   802119 <sys_pf_calculate_allocated_pages>
  800259:	89 45 e0             	mov    %eax,-0x20(%ebp)
		ptr_allocations[3] = malloc(2*kilo);
  80025c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80025f:	01 c0                	add    %eax,%eax
  800261:	83 ec 0c             	sub    $0xc,%esp
  800264:	50                   	push   %eax
  800265:	e8 03 1a 00 00       	call   801c6d <malloc>
  80026a:	83 c4 10             	add    $0x10,%esp
  80026d:	89 45 9c             	mov    %eax,-0x64(%ebp)
		if ((uint32) ptr_allocations[3] != (USER_HEAP_START + 4*Mega + 4*kilo)) panic("Wrong start address for the allocated space... ");
  800270:	8b 45 9c             	mov    -0x64(%ebp),%eax
  800273:	89 c2                	mov    %eax,%edx
  800275:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800278:	c1 e0 02             	shl    $0x2,%eax
  80027b:	89 c1                	mov    %eax,%ecx
  80027d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800280:	c1 e0 02             	shl    $0x2,%eax
  800283:	01 c8                	add    %ecx,%eax
  800285:	05 00 00 00 80       	add    $0x80000000,%eax
  80028a:	39 c2                	cmp    %eax,%edx
  80028c:	74 14                	je     8002a2 <_main+0x26a>
  80028e:	83 ec 04             	sub    $0x4,%esp
  800291:	68 f8 38 80 00       	push   $0x8038f8
  800296:	6a 49                	push   $0x49
  800298:	68 9c 38 80 00       	push   $0x80389c
  80029d:	e8 85 07 00 00       	call   800a27 <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 1 ) panic("Wrong allocation: ");
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  1) panic("Wrong page file allocation: ");
  8002a2:	e8 72 1e 00 00       	call   802119 <sys_pf_calculate_allocated_pages>
  8002a7:	2b 45 e0             	sub    -0x20(%ebp),%eax
  8002aa:	83 f8 01             	cmp    $0x1,%eax
  8002ad:	74 14                	je     8002c3 <_main+0x28b>
  8002af:	83 ec 04             	sub    $0x4,%esp
  8002b2:	68 28 39 80 00       	push   $0x803928
  8002b7:	6a 4b                	push   $0x4b
  8002b9:	68 9c 38 80 00       	push   $0x80389c
  8002be:	e8 64 07 00 00       	call   800a27 <_panic>

		//4 KB Hole
		freeFrames = sys_calculate_free_frames() ;
  8002c3:	e8 b1 1d 00 00       	call   802079 <sys_calculate_free_frames>
  8002c8:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  8002cb:	e8 49 1e 00 00       	call   802119 <sys_pf_calculate_allocated_pages>
  8002d0:	89 45 e0             	mov    %eax,-0x20(%ebp)
		free(ptr_allocations[2]);
  8002d3:	8b 45 98             	mov    -0x68(%ebp),%eax
  8002d6:	83 ec 0c             	sub    $0xc,%esp
  8002d9:	50                   	push   %eax
  8002da:	e8 0f 1a 00 00       	call   801cee <free>
  8002df:	83 c4 10             	add    $0x10,%esp
		//if ((sys_calculate_free_frames() - freeFrames) != 1) panic("Wrong free: ");
		if( (usedDiskPages-sys_pf_calculate_allocated_pages()) !=  1) panic("Wrong page file free: ");
  8002e2:	e8 32 1e 00 00       	call   802119 <sys_pf_calculate_allocated_pages>
  8002e7:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8002ea:	29 c2                	sub    %eax,%edx
  8002ec:	89 d0                	mov    %edx,%eax
  8002ee:	83 f8 01             	cmp    $0x1,%eax
  8002f1:	74 14                	je     800307 <_main+0x2cf>
  8002f3:	83 ec 04             	sub    $0x4,%esp
  8002f6:	68 45 39 80 00       	push   $0x803945
  8002fb:	6a 52                	push   $0x52
  8002fd:	68 9c 38 80 00       	push   $0x80389c
  800302:	e8 20 07 00 00       	call   800a27 <_panic>

		//7 KB
		freeFrames = sys_calculate_free_frames() ;
  800307:	e8 6d 1d 00 00       	call   802079 <sys_calculate_free_frames>
  80030c:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  80030f:	e8 05 1e 00 00       	call   802119 <sys_pf_calculate_allocated_pages>
  800314:	89 45 e0             	mov    %eax,-0x20(%ebp)
		ptr_allocations[4] = malloc(7*kilo);
  800317:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80031a:	89 d0                	mov    %edx,%eax
  80031c:	01 c0                	add    %eax,%eax
  80031e:	01 d0                	add    %edx,%eax
  800320:	01 c0                	add    %eax,%eax
  800322:	01 d0                	add    %edx,%eax
  800324:	83 ec 0c             	sub    $0xc,%esp
  800327:	50                   	push   %eax
  800328:	e8 40 19 00 00       	call   801c6d <malloc>
  80032d:	83 c4 10             	add    $0x10,%esp
  800330:	89 45 a0             	mov    %eax,-0x60(%ebp)
		if ((uint32) ptr_allocations[4] != (USER_HEAP_START + 4*Mega + 8*kilo)) panic("Wrong start address for the allocated space... ");
  800333:	8b 45 a0             	mov    -0x60(%ebp),%eax
  800336:	89 c2                	mov    %eax,%edx
  800338:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80033b:	c1 e0 02             	shl    $0x2,%eax
  80033e:	89 c1                	mov    %eax,%ecx
  800340:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800343:	c1 e0 03             	shl    $0x3,%eax
  800346:	01 c8                	add    %ecx,%eax
  800348:	05 00 00 00 80       	add    $0x80000000,%eax
  80034d:	39 c2                	cmp    %eax,%edx
  80034f:	74 14                	je     800365 <_main+0x32d>
  800351:	83 ec 04             	sub    $0x4,%esp
  800354:	68 f8 38 80 00       	push   $0x8038f8
  800359:	6a 58                	push   $0x58
  80035b:	68 9c 38 80 00       	push   $0x80389c
  800360:	e8 c2 06 00 00       	call   800a27 <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 2)panic("Wrong allocation: ");
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  2) panic("Wrong page file allocation: ");
  800365:	e8 af 1d 00 00       	call   802119 <sys_pf_calculate_allocated_pages>
  80036a:	2b 45 e0             	sub    -0x20(%ebp),%eax
  80036d:	83 f8 02             	cmp    $0x2,%eax
  800370:	74 14                	je     800386 <_main+0x34e>
  800372:	83 ec 04             	sub    $0x4,%esp
  800375:	68 28 39 80 00       	push   $0x803928
  80037a:	6a 5a                	push   $0x5a
  80037c:	68 9c 38 80 00       	push   $0x80389c
  800381:	e8 a1 06 00 00       	call   800a27 <_panic>

		//2 MB Hole
		freeFrames = sys_calculate_free_frames() ;
  800386:	e8 ee 1c 00 00       	call   802079 <sys_calculate_free_frames>
  80038b:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  80038e:	e8 86 1d 00 00       	call   802119 <sys_pf_calculate_allocated_pages>
  800393:	89 45 e0             	mov    %eax,-0x20(%ebp)
		free(ptr_allocations[0]);
  800396:	8b 45 90             	mov    -0x70(%ebp),%eax
  800399:	83 ec 0c             	sub    $0xc,%esp
  80039c:	50                   	push   %eax
  80039d:	e8 4c 19 00 00       	call   801cee <free>
  8003a2:	83 c4 10             	add    $0x10,%esp
		//if ((sys_calculate_free_frames() - freeFrames) != 512) panic("Wrong free: ");
		if( (usedDiskPages - sys_pf_calculate_allocated_pages() ) !=  512) panic("Wrong page file free: ");
  8003a5:	e8 6f 1d 00 00       	call   802119 <sys_pf_calculate_allocated_pages>
  8003aa:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8003ad:	29 c2                	sub    %eax,%edx
  8003af:	89 d0                	mov    %edx,%eax
  8003b1:	3d 00 02 00 00       	cmp    $0x200,%eax
  8003b6:	74 14                	je     8003cc <_main+0x394>
  8003b8:	83 ec 04             	sub    $0x4,%esp
  8003bb:	68 45 39 80 00       	push   $0x803945
  8003c0:	6a 61                	push   $0x61
  8003c2:	68 9c 38 80 00       	push   $0x80389c
  8003c7:	e8 5b 06 00 00       	call   800a27 <_panic>

		//3 MB
		freeFrames = sys_calculate_free_frames() ;
  8003cc:	e8 a8 1c 00 00       	call   802079 <sys_calculate_free_frames>
  8003d1:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  8003d4:	e8 40 1d 00 00       	call   802119 <sys_pf_calculate_allocated_pages>
  8003d9:	89 45 e0             	mov    %eax,-0x20(%ebp)
		ptr_allocations[5] = malloc(3*Mega-kilo);
  8003dc:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8003df:	89 c2                	mov    %eax,%edx
  8003e1:	01 d2                	add    %edx,%edx
  8003e3:	01 d0                	add    %edx,%eax
  8003e5:	2b 45 e8             	sub    -0x18(%ebp),%eax
  8003e8:	83 ec 0c             	sub    $0xc,%esp
  8003eb:	50                   	push   %eax
  8003ec:	e8 7c 18 00 00       	call   801c6d <malloc>
  8003f1:	83 c4 10             	add    $0x10,%esp
  8003f4:	89 45 a4             	mov    %eax,-0x5c(%ebp)
		if ((uint32) ptr_allocations[5] != (USER_HEAP_START + 4*Mega + 16*kilo)) panic("Wrong start address for the allocated space... ");
  8003f7:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  8003fa:	89 c2                	mov    %eax,%edx
  8003fc:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8003ff:	c1 e0 02             	shl    $0x2,%eax
  800402:	89 c1                	mov    %eax,%ecx
  800404:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800407:	c1 e0 04             	shl    $0x4,%eax
  80040a:	01 c8                	add    %ecx,%eax
  80040c:	05 00 00 00 80       	add    $0x80000000,%eax
  800411:	39 c2                	cmp    %eax,%edx
  800413:	74 14                	je     800429 <_main+0x3f1>
  800415:	83 ec 04             	sub    $0x4,%esp
  800418:	68 f8 38 80 00       	push   $0x8038f8
  80041d:	6a 67                	push   $0x67
  80041f:	68 9c 38 80 00       	push   $0x80389c
  800424:	e8 fe 05 00 00       	call   800a27 <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 3*Mega/4096 ) panic("Wrong allocation: ");
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  3*Mega/4096) panic("Wrong page file allocation: ");
  800429:	e8 eb 1c 00 00       	call   802119 <sys_pf_calculate_allocated_pages>
  80042e:	2b 45 e0             	sub    -0x20(%ebp),%eax
  800431:	89 c2                	mov    %eax,%edx
  800433:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800436:	89 c1                	mov    %eax,%ecx
  800438:	01 c9                	add    %ecx,%ecx
  80043a:	01 c8                	add    %ecx,%eax
  80043c:	85 c0                	test   %eax,%eax
  80043e:	79 05                	jns    800445 <_main+0x40d>
  800440:	05 ff 0f 00 00       	add    $0xfff,%eax
  800445:	c1 f8 0c             	sar    $0xc,%eax
  800448:	39 c2                	cmp    %eax,%edx
  80044a:	74 14                	je     800460 <_main+0x428>
  80044c:	83 ec 04             	sub    $0x4,%esp
  80044f:	68 28 39 80 00       	push   $0x803928
  800454:	6a 69                	push   $0x69
  800456:	68 9c 38 80 00       	push   $0x80389c
  80045b:	e8 c7 05 00 00       	call   800a27 <_panic>

		//2 MB + 6 KB
		freeFrames = sys_calculate_free_frames() ;
  800460:	e8 14 1c 00 00       	call   802079 <sys_calculate_free_frames>
  800465:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  800468:	e8 ac 1c 00 00       	call   802119 <sys_pf_calculate_allocated_pages>
  80046d:	89 45 e0             	mov    %eax,-0x20(%ebp)
		ptr_allocations[6] = malloc(2*Mega + 6*kilo);
  800470:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800473:	89 c2                	mov    %eax,%edx
  800475:	01 d2                	add    %edx,%edx
  800477:	01 c2                	add    %eax,%edx
  800479:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80047c:	01 d0                	add    %edx,%eax
  80047e:	01 c0                	add    %eax,%eax
  800480:	83 ec 0c             	sub    $0xc,%esp
  800483:	50                   	push   %eax
  800484:	e8 e4 17 00 00       	call   801c6d <malloc>
  800489:	83 c4 10             	add    $0x10,%esp
  80048c:	89 45 a8             	mov    %eax,-0x58(%ebp)
		if ((uint32) ptr_allocations[6] != (USER_HEAP_START + 7*Mega + 16*kilo)) panic("Wrong start address for the allocated space... ");
  80048f:	8b 45 a8             	mov    -0x58(%ebp),%eax
  800492:	89 c1                	mov    %eax,%ecx
  800494:	8b 55 ec             	mov    -0x14(%ebp),%edx
  800497:	89 d0                	mov    %edx,%eax
  800499:	01 c0                	add    %eax,%eax
  80049b:	01 d0                	add    %edx,%eax
  80049d:	01 c0                	add    %eax,%eax
  80049f:	01 d0                	add    %edx,%eax
  8004a1:	89 c2                	mov    %eax,%edx
  8004a3:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8004a6:	c1 e0 04             	shl    $0x4,%eax
  8004a9:	01 d0                	add    %edx,%eax
  8004ab:	05 00 00 00 80       	add    $0x80000000,%eax
  8004b0:	39 c1                	cmp    %eax,%ecx
  8004b2:	74 14                	je     8004c8 <_main+0x490>
  8004b4:	83 ec 04             	sub    $0x4,%esp
  8004b7:	68 f8 38 80 00       	push   $0x8038f8
  8004bc:	6a 6f                	push   $0x6f
  8004be:	68 9c 38 80 00       	push   $0x80389c
  8004c3:	e8 5f 05 00 00       	call   800a27 <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 514+1 ) panic("Wrong allocation: ");
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  514) panic("Wrong page file allocation: ");
  8004c8:	e8 4c 1c 00 00       	call   802119 <sys_pf_calculate_allocated_pages>
  8004cd:	2b 45 e0             	sub    -0x20(%ebp),%eax
  8004d0:	3d 02 02 00 00       	cmp    $0x202,%eax
  8004d5:	74 14                	je     8004eb <_main+0x4b3>
  8004d7:	83 ec 04             	sub    $0x4,%esp
  8004da:	68 28 39 80 00       	push   $0x803928
  8004df:	6a 71                	push   $0x71
  8004e1:	68 9c 38 80 00       	push   $0x80389c
  8004e6:	e8 3c 05 00 00       	call   800a27 <_panic>

		//5 MB
		freeFrames = sys_calculate_free_frames() ;
  8004eb:	e8 89 1b 00 00       	call   802079 <sys_calculate_free_frames>
  8004f0:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  8004f3:	e8 21 1c 00 00       	call   802119 <sys_pf_calculate_allocated_pages>
  8004f8:	89 45 e0             	mov    %eax,-0x20(%ebp)
		ptr_allocations[7] = malloc(5*Mega-kilo);
  8004fb:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8004fe:	89 d0                	mov    %edx,%eax
  800500:	c1 e0 02             	shl    $0x2,%eax
  800503:	01 d0                	add    %edx,%eax
  800505:	2b 45 e8             	sub    -0x18(%ebp),%eax
  800508:	83 ec 0c             	sub    $0xc,%esp
  80050b:	50                   	push   %eax
  80050c:	e8 5c 17 00 00       	call   801c6d <malloc>
  800511:	83 c4 10             	add    $0x10,%esp
  800514:	89 45 ac             	mov    %eax,-0x54(%ebp)
		if ((uint32) ptr_allocations[7] != (USER_HEAP_START + 9*Mega + 24*kilo)) panic("Wrong start address for the allocated space... ");
  800517:	8b 45 ac             	mov    -0x54(%ebp),%eax
  80051a:	89 c1                	mov    %eax,%ecx
  80051c:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80051f:	89 d0                	mov    %edx,%eax
  800521:	c1 e0 03             	shl    $0x3,%eax
  800524:	01 d0                	add    %edx,%eax
  800526:	89 c3                	mov    %eax,%ebx
  800528:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80052b:	89 d0                	mov    %edx,%eax
  80052d:	01 c0                	add    %eax,%eax
  80052f:	01 d0                	add    %edx,%eax
  800531:	c1 e0 03             	shl    $0x3,%eax
  800534:	01 d8                	add    %ebx,%eax
  800536:	05 00 00 00 80       	add    $0x80000000,%eax
  80053b:	39 c1                	cmp    %eax,%ecx
  80053d:	74 14                	je     800553 <_main+0x51b>
  80053f:	83 ec 04             	sub    $0x4,%esp
  800542:	68 f8 38 80 00       	push   $0x8038f8
  800547:	6a 77                	push   $0x77
  800549:	68 9c 38 80 00       	push   $0x80389c
  80054e:	e8 d4 04 00 00       	call   800a27 <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 5*Mega/4096 + 1) panic("Wrong allocation: ");
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  5*Mega/4096) panic("Wrong page file allocation: ");
  800553:	e8 c1 1b 00 00       	call   802119 <sys_pf_calculate_allocated_pages>
  800558:	2b 45 e0             	sub    -0x20(%ebp),%eax
  80055b:	89 c1                	mov    %eax,%ecx
  80055d:	8b 55 ec             	mov    -0x14(%ebp),%edx
  800560:	89 d0                	mov    %edx,%eax
  800562:	c1 e0 02             	shl    $0x2,%eax
  800565:	01 d0                	add    %edx,%eax
  800567:	85 c0                	test   %eax,%eax
  800569:	79 05                	jns    800570 <_main+0x538>
  80056b:	05 ff 0f 00 00       	add    $0xfff,%eax
  800570:	c1 f8 0c             	sar    $0xc,%eax
  800573:	39 c1                	cmp    %eax,%ecx
  800575:	74 14                	je     80058b <_main+0x553>
  800577:	83 ec 04             	sub    $0x4,%esp
  80057a:	68 28 39 80 00       	push   $0x803928
  80057f:	6a 79                	push   $0x79
  800581:	68 9c 38 80 00       	push   $0x80389c
  800586:	e8 9c 04 00 00       	call   800a27 <_panic>

		//2 MB + 8 KB Hole
		freeFrames = sys_calculate_free_frames() ;
  80058b:	e8 e9 1a 00 00       	call   802079 <sys_calculate_free_frames>
  800590:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  800593:	e8 81 1b 00 00       	call   802119 <sys_pf_calculate_allocated_pages>
  800598:	89 45 e0             	mov    %eax,-0x20(%ebp)
		free(ptr_allocations[6]);
  80059b:	8b 45 a8             	mov    -0x58(%ebp),%eax
  80059e:	83 ec 0c             	sub    $0xc,%esp
  8005a1:	50                   	push   %eax
  8005a2:	e8 47 17 00 00       	call   801cee <free>
  8005a7:	83 c4 10             	add    $0x10,%esp
		//if ((sys_calculate_free_frames() - freeFrames) != 514) panic("Wrong free: ");
		if( (usedDiskPages - sys_pf_calculate_allocated_pages()) !=  514) panic("Wrong page file free: ");
  8005aa:	e8 6a 1b 00 00       	call   802119 <sys_pf_calculate_allocated_pages>
  8005af:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8005b2:	29 c2                	sub    %eax,%edx
  8005b4:	89 d0                	mov    %edx,%eax
  8005b6:	3d 02 02 00 00       	cmp    $0x202,%eax
  8005bb:	74 17                	je     8005d4 <_main+0x59c>
  8005bd:	83 ec 04             	sub    $0x4,%esp
  8005c0:	68 45 39 80 00       	push   $0x803945
  8005c5:	68 80 00 00 00       	push   $0x80
  8005ca:	68 9c 38 80 00       	push   $0x80389c
  8005cf:	e8 53 04 00 00       	call   800a27 <_panic>

		//2 MB Hole
		freeFrames = sys_calculate_free_frames() ;
  8005d4:	e8 a0 1a 00 00       	call   802079 <sys_calculate_free_frames>
  8005d9:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  8005dc:	e8 38 1b 00 00       	call   802119 <sys_pf_calculate_allocated_pages>
  8005e1:	89 45 e0             	mov    %eax,-0x20(%ebp)
		free(ptr_allocations[1]);
  8005e4:	8b 45 94             	mov    -0x6c(%ebp),%eax
  8005e7:	83 ec 0c             	sub    $0xc,%esp
  8005ea:	50                   	push   %eax
  8005eb:	e8 fe 16 00 00       	call   801cee <free>
  8005f0:	83 c4 10             	add    $0x10,%esp
		//if ((sys_calculate_free_frames() - freeFrames) != 512) panic("Wrong free: ");
		if( (usedDiskPages - sys_pf_calculate_allocated_pages() ) !=  512) panic("Wrong page file free: ");
  8005f3:	e8 21 1b 00 00       	call   802119 <sys_pf_calculate_allocated_pages>
  8005f8:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8005fb:	29 c2                	sub    %eax,%edx
  8005fd:	89 d0                	mov    %edx,%eax
  8005ff:	3d 00 02 00 00       	cmp    $0x200,%eax
  800604:	74 17                	je     80061d <_main+0x5e5>
  800606:	83 ec 04             	sub    $0x4,%esp
  800609:	68 45 39 80 00       	push   $0x803945
  80060e:	68 87 00 00 00       	push   $0x87
  800613:	68 9c 38 80 00       	push   $0x80389c
  800618:	e8 0a 04 00 00       	call   800a27 <_panic>

		//2 MB [BEST FIT Case]
		freeFrames = sys_calculate_free_frames() ;
  80061d:	e8 57 1a 00 00       	call   802079 <sys_calculate_free_frames>
  800622:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  800625:	e8 ef 1a 00 00       	call   802119 <sys_pf_calculate_allocated_pages>
  80062a:	89 45 e0             	mov    %eax,-0x20(%ebp)
		ptr_allocations[8] = malloc(2*Mega-kilo);
  80062d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800630:	01 c0                	add    %eax,%eax
  800632:	2b 45 e8             	sub    -0x18(%ebp),%eax
  800635:	83 ec 0c             	sub    $0xc,%esp
  800638:	50                   	push   %eax
  800639:	e8 2f 16 00 00       	call   801c6d <malloc>
  80063e:	83 c4 10             	add    $0x10,%esp
  800641:	89 45 b0             	mov    %eax,-0x50(%ebp)
		if ((uint32) ptr_allocations[8] !=  (USER_HEAP_START + 7*Mega + 16*kilo)) panic("Wrong start address for the allocated space... ");
  800644:	8b 45 b0             	mov    -0x50(%ebp),%eax
  800647:	89 c1                	mov    %eax,%ecx
  800649:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80064c:	89 d0                	mov    %edx,%eax
  80064e:	01 c0                	add    %eax,%eax
  800650:	01 d0                	add    %edx,%eax
  800652:	01 c0                	add    %eax,%eax
  800654:	01 d0                	add    %edx,%eax
  800656:	89 c2                	mov    %eax,%edx
  800658:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80065b:	c1 e0 04             	shl    $0x4,%eax
  80065e:	01 d0                	add    %edx,%eax
  800660:	05 00 00 00 80       	add    $0x80000000,%eax
  800665:	39 c1                	cmp    %eax,%ecx
  800667:	74 17                	je     800680 <_main+0x648>
  800669:	83 ec 04             	sub    $0x4,%esp
  80066c:	68 f8 38 80 00       	push   $0x8038f8
  800671:	68 8d 00 00 00       	push   $0x8d
  800676:	68 9c 38 80 00       	push   $0x80389c
  80067b:	e8 a7 03 00 00       	call   800a27 <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 512 ) panic("Wrong allocation: ");
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  512) panic("Wrong page file allocation: ");
  800680:	e8 94 1a 00 00       	call   802119 <sys_pf_calculate_allocated_pages>
  800685:	2b 45 e0             	sub    -0x20(%ebp),%eax
  800688:	3d 00 02 00 00       	cmp    $0x200,%eax
  80068d:	74 17                	je     8006a6 <_main+0x66e>
  80068f:	83 ec 04             	sub    $0x4,%esp
  800692:	68 28 39 80 00       	push   $0x803928
  800697:	68 8f 00 00 00       	push   $0x8f
  80069c:	68 9c 38 80 00       	push   $0x80389c
  8006a1:	e8 81 03 00 00       	call   800a27 <_panic>

		//6 KB [BEST FIT Case]
		freeFrames = sys_calculate_free_frames() ;
  8006a6:	e8 ce 19 00 00       	call   802079 <sys_calculate_free_frames>
  8006ab:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  8006ae:	e8 66 1a 00 00       	call   802119 <sys_pf_calculate_allocated_pages>
  8006b3:	89 45 e0             	mov    %eax,-0x20(%ebp)
		ptr_allocations[9] = malloc(6*kilo);
  8006b6:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8006b9:	89 d0                	mov    %edx,%eax
  8006bb:	01 c0                	add    %eax,%eax
  8006bd:	01 d0                	add    %edx,%eax
  8006bf:	01 c0                	add    %eax,%eax
  8006c1:	83 ec 0c             	sub    $0xc,%esp
  8006c4:	50                   	push   %eax
  8006c5:	e8 a3 15 00 00       	call   801c6d <malloc>
  8006ca:	83 c4 10             	add    $0x10,%esp
  8006cd:	89 45 b4             	mov    %eax,-0x4c(%ebp)
		if ((uint32) ptr_allocations[9] != (USER_HEAP_START + 9*Mega + 16*kilo)) panic("Wrong start address for the allocated space... ");
  8006d0:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  8006d3:	89 c1                	mov    %eax,%ecx
  8006d5:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8006d8:	89 d0                	mov    %edx,%eax
  8006da:	c1 e0 03             	shl    $0x3,%eax
  8006dd:	01 d0                	add    %edx,%eax
  8006df:	89 c2                	mov    %eax,%edx
  8006e1:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8006e4:	c1 e0 04             	shl    $0x4,%eax
  8006e7:	01 d0                	add    %edx,%eax
  8006e9:	05 00 00 00 80       	add    $0x80000000,%eax
  8006ee:	39 c1                	cmp    %eax,%ecx
  8006f0:	74 17                	je     800709 <_main+0x6d1>
  8006f2:	83 ec 04             	sub    $0x4,%esp
  8006f5:	68 f8 38 80 00       	push   $0x8038f8
  8006fa:	68 95 00 00 00       	push   $0x95
  8006ff:	68 9c 38 80 00       	push   $0x80389c
  800704:	e8 1e 03 00 00       	call   800a27 <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 2)panic("Wrong allocation: ");
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  2) panic("Wrong page file allocation: ");
  800709:	e8 0b 1a 00 00       	call   802119 <sys_pf_calculate_allocated_pages>
  80070e:	2b 45 e0             	sub    -0x20(%ebp),%eax
  800711:	83 f8 02             	cmp    $0x2,%eax
  800714:	74 17                	je     80072d <_main+0x6f5>
  800716:	83 ec 04             	sub    $0x4,%esp
  800719:	68 28 39 80 00       	push   $0x803928
  80071e:	68 97 00 00 00       	push   $0x97
  800723:	68 9c 38 80 00       	push   $0x80389c
  800728:	e8 fa 02 00 00       	call   800a27 <_panic>

		//3 MB Hole
		freeFrames = sys_calculate_free_frames() ;
  80072d:	e8 47 19 00 00       	call   802079 <sys_calculate_free_frames>
  800732:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  800735:	e8 df 19 00 00       	call   802119 <sys_pf_calculate_allocated_pages>
  80073a:	89 45 e0             	mov    %eax,-0x20(%ebp)
		free(ptr_allocations[5]);
  80073d:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  800740:	83 ec 0c             	sub    $0xc,%esp
  800743:	50                   	push   %eax
  800744:	e8 a5 15 00 00       	call   801cee <free>
  800749:	83 c4 10             	add    $0x10,%esp
		//if ((sys_calculate_free_frames() - freeFrames) != 768) panic("Wrong free: ");
		if( (usedDiskPages - sys_pf_calculate_allocated_pages()) !=  768) panic("Wrong page file free: ");
  80074c:	e8 c8 19 00 00       	call   802119 <sys_pf_calculate_allocated_pages>
  800751:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800754:	29 c2                	sub    %eax,%edx
  800756:	89 d0                	mov    %edx,%eax
  800758:	3d 00 03 00 00       	cmp    $0x300,%eax
  80075d:	74 17                	je     800776 <_main+0x73e>
  80075f:	83 ec 04             	sub    $0x4,%esp
  800762:	68 45 39 80 00       	push   $0x803945
  800767:	68 9e 00 00 00       	push   $0x9e
  80076c:	68 9c 38 80 00       	push   $0x80389c
  800771:	e8 b1 02 00 00       	call   800a27 <_panic>

		//3 MB [BEST FIT Case]
		freeFrames = sys_calculate_free_frames() ;
  800776:	e8 fe 18 00 00       	call   802079 <sys_calculate_free_frames>
  80077b:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  80077e:	e8 96 19 00 00       	call   802119 <sys_pf_calculate_allocated_pages>
  800783:	89 45 e0             	mov    %eax,-0x20(%ebp)
		ptr_allocations[10] = malloc(3*Mega-kilo);
  800786:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800789:	89 c2                	mov    %eax,%edx
  80078b:	01 d2                	add    %edx,%edx
  80078d:	01 d0                	add    %edx,%eax
  80078f:	2b 45 e8             	sub    -0x18(%ebp),%eax
  800792:	83 ec 0c             	sub    $0xc,%esp
  800795:	50                   	push   %eax
  800796:	e8 d2 14 00 00       	call   801c6d <malloc>
  80079b:	83 c4 10             	add    $0x10,%esp
  80079e:	89 45 b8             	mov    %eax,-0x48(%ebp)
		if ((uint32) ptr_allocations[10] != (USER_HEAP_START + 4*Mega + 16*kilo)) panic("Wrong start address for the allocated space... ");
  8007a1:	8b 45 b8             	mov    -0x48(%ebp),%eax
  8007a4:	89 c2                	mov    %eax,%edx
  8007a6:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8007a9:	c1 e0 02             	shl    $0x2,%eax
  8007ac:	89 c1                	mov    %eax,%ecx
  8007ae:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8007b1:	c1 e0 04             	shl    $0x4,%eax
  8007b4:	01 c8                	add    %ecx,%eax
  8007b6:	05 00 00 00 80       	add    $0x80000000,%eax
  8007bb:	39 c2                	cmp    %eax,%edx
  8007bd:	74 17                	je     8007d6 <_main+0x79e>
  8007bf:	83 ec 04             	sub    $0x4,%esp
  8007c2:	68 f8 38 80 00       	push   $0x8038f8
  8007c7:	68 a4 00 00 00       	push   $0xa4
  8007cc:	68 9c 38 80 00       	push   $0x80389c
  8007d1:	e8 51 02 00 00       	call   800a27 <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 3*Mega/4096 ) panic("Wrong allocation: ");
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  3*Mega/4096) panic("Wrong page file allocation: ");
  8007d6:	e8 3e 19 00 00       	call   802119 <sys_pf_calculate_allocated_pages>
  8007db:	2b 45 e0             	sub    -0x20(%ebp),%eax
  8007de:	89 c2                	mov    %eax,%edx
  8007e0:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8007e3:	89 c1                	mov    %eax,%ecx
  8007e5:	01 c9                	add    %ecx,%ecx
  8007e7:	01 c8                	add    %ecx,%eax
  8007e9:	85 c0                	test   %eax,%eax
  8007eb:	79 05                	jns    8007f2 <_main+0x7ba>
  8007ed:	05 ff 0f 00 00       	add    $0xfff,%eax
  8007f2:	c1 f8 0c             	sar    $0xc,%eax
  8007f5:	39 c2                	cmp    %eax,%edx
  8007f7:	74 17                	je     800810 <_main+0x7d8>
  8007f9:	83 ec 04             	sub    $0x4,%esp
  8007fc:	68 28 39 80 00       	push   $0x803928
  800801:	68 a6 00 00 00       	push   $0xa6
  800806:	68 9c 38 80 00       	push   $0x80389c
  80080b:	e8 17 02 00 00       	call   800a27 <_panic>

		//4 MB
		freeFrames = sys_calculate_free_frames() ;
  800810:	e8 64 18 00 00       	call   802079 <sys_calculate_free_frames>
  800815:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  800818:	e8 fc 18 00 00       	call   802119 <sys_pf_calculate_allocated_pages>
  80081d:	89 45 e0             	mov    %eax,-0x20(%ebp)
		ptr_allocations[11] = malloc(4*Mega-kilo);
  800820:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800823:	c1 e0 02             	shl    $0x2,%eax
  800826:	2b 45 e8             	sub    -0x18(%ebp),%eax
  800829:	83 ec 0c             	sub    $0xc,%esp
  80082c:	50                   	push   %eax
  80082d:	e8 3b 14 00 00       	call   801c6d <malloc>
  800832:	83 c4 10             	add    $0x10,%esp
  800835:	89 45 bc             	mov    %eax,-0x44(%ebp)
		if ((uint32) ptr_allocations[11] != (USER_HEAP_START)) panic("Wrong start address for the allocated space... ");
  800838:	8b 45 bc             	mov    -0x44(%ebp),%eax
  80083b:	3d 00 00 00 80       	cmp    $0x80000000,%eax
  800840:	74 17                	je     800859 <_main+0x821>
  800842:	83 ec 04             	sub    $0x4,%esp
  800845:	68 f8 38 80 00       	push   $0x8038f8
  80084a:	68 ac 00 00 00       	push   $0xac
  80084f:	68 9c 38 80 00       	push   $0x80389c
  800854:	e8 ce 01 00 00       	call   800a27 <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 4*Mega/4096) panic("Wrong allocation: ");
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  4*Mega/4096) panic("Wrong page file allocation: ");
  800859:	e8 bb 18 00 00       	call   802119 <sys_pf_calculate_allocated_pages>
  80085e:	2b 45 e0             	sub    -0x20(%ebp),%eax
  800861:	89 c2                	mov    %eax,%edx
  800863:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800866:	c1 e0 02             	shl    $0x2,%eax
  800869:	85 c0                	test   %eax,%eax
  80086b:	79 05                	jns    800872 <_main+0x83a>
  80086d:	05 ff 0f 00 00       	add    $0xfff,%eax
  800872:	c1 f8 0c             	sar    $0xc,%eax
  800875:	39 c2                	cmp    %eax,%edx
  800877:	74 17                	je     800890 <_main+0x858>
  800879:	83 ec 04             	sub    $0x4,%esp
  80087c:	68 28 39 80 00       	push   $0x803928
  800881:	68 ae 00 00 00       	push   $0xae
  800886:	68 9c 38 80 00       	push   $0x80389c
  80088b:	e8 97 01 00 00       	call   800a27 <_panic>
	//	b) Attempt to allocate large segment with no suitable fragment to fit on
	{
		//Large Allocation
		//int freeFrames = sys_calculate_free_frames() ;
		//usedDiskPages = sys_pf_calculate_allocated_pages();
		ptr_allocations[12] = malloc((USER_HEAP_MAX - USER_HEAP_START - 14*Mega));
  800890:	8b 55 ec             	mov    -0x14(%ebp),%edx
  800893:	89 d0                	mov    %edx,%eax
  800895:	01 c0                	add    %eax,%eax
  800897:	01 d0                	add    %edx,%eax
  800899:	01 c0                	add    %eax,%eax
  80089b:	01 d0                	add    %edx,%eax
  80089d:	01 c0                	add    %eax,%eax
  80089f:	f7 d8                	neg    %eax
  8008a1:	05 00 00 00 20       	add    $0x20000000,%eax
  8008a6:	83 ec 0c             	sub    $0xc,%esp
  8008a9:	50                   	push   %eax
  8008aa:	e8 be 13 00 00       	call   801c6d <malloc>
  8008af:	83 c4 10             	add    $0x10,%esp
  8008b2:	89 45 c0             	mov    %eax,-0x40(%ebp)
		if (ptr_allocations[12] != NULL) panic("Malloc: Attempt to allocate large segment with no suitable fragment to fit on, should return NULL");
  8008b5:	8b 45 c0             	mov    -0x40(%ebp),%eax
  8008b8:	85 c0                	test   %eax,%eax
  8008ba:	74 17                	je     8008d3 <_main+0x89b>
  8008bc:	83 ec 04             	sub    $0x4,%esp
  8008bf:	68 5c 39 80 00       	push   $0x80395c
  8008c4:	68 b7 00 00 00       	push   $0xb7
  8008c9:	68 9c 38 80 00       	push   $0x80389c
  8008ce:	e8 54 01 00 00       	call   800a27 <_panic>

		cprintf("Congratulations!! test BEST FIT allocation (2) completed successfully.\n");
  8008d3:	83 ec 0c             	sub    $0xc,%esp
  8008d6:	68 c0 39 80 00       	push   $0x8039c0
  8008db:	e8 fb 03 00 00       	call   800cdb <cprintf>
  8008e0:	83 c4 10             	add    $0x10,%esp

		return;
  8008e3:	90                   	nop
	}
}
  8008e4:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8008e7:	5b                   	pop    %ebx
  8008e8:	5f                   	pop    %edi
  8008e9:	5d                   	pop    %ebp
  8008ea:	c3                   	ret    

008008eb <libmain>:
volatile struct Env *myEnv = NULL;
volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";

void
libmain(int argc, char **argv)
{
  8008eb:	55                   	push   %ebp
  8008ec:	89 e5                	mov    %esp,%ebp
  8008ee:	83 ec 18             	sub    $0x18,%esp
	int envIndex = sys_getenvindex();
  8008f1:	e8 63 1a 00 00       	call   802359 <sys_getenvindex>
  8008f6:	89 45 f4             	mov    %eax,-0xc(%ebp)
	myEnv = &(envs[envIndex]);
  8008f9:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8008fc:	89 d0                	mov    %edx,%eax
  8008fe:	c1 e0 03             	shl    $0x3,%eax
  800901:	01 d0                	add    %edx,%eax
  800903:	01 c0                	add    %eax,%eax
  800905:	01 d0                	add    %edx,%eax
  800907:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80090e:	01 d0                	add    %edx,%eax
  800910:	c1 e0 04             	shl    $0x4,%eax
  800913:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  800918:	a3 20 50 80 00       	mov    %eax,0x805020

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  80091d:	a1 20 50 80 00       	mov    0x805020,%eax
  800922:	8a 80 5c 05 00 00    	mov    0x55c(%eax),%al
  800928:	84 c0                	test   %al,%al
  80092a:	74 0f                	je     80093b <libmain+0x50>
		binaryname = myEnv->prog_name;
  80092c:	a1 20 50 80 00       	mov    0x805020,%eax
  800931:	05 5c 05 00 00       	add    $0x55c,%eax
  800936:	a3 00 50 80 00       	mov    %eax,0x805000

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  80093b:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80093f:	7e 0a                	jle    80094b <libmain+0x60>
		binaryname = argv[0];
  800941:	8b 45 0c             	mov    0xc(%ebp),%eax
  800944:	8b 00                	mov    (%eax),%eax
  800946:	a3 00 50 80 00       	mov    %eax,0x805000

	// call user main routine
	_main(argc, argv);
  80094b:	83 ec 08             	sub    $0x8,%esp
  80094e:	ff 75 0c             	pushl  0xc(%ebp)
  800951:	ff 75 08             	pushl  0x8(%ebp)
  800954:	e8 df f6 ff ff       	call   800038 <_main>
  800959:	83 c4 10             	add    $0x10,%esp



	sys_disable_interrupt();
  80095c:	e8 05 18 00 00       	call   802166 <sys_disable_interrupt>
	cprintf("**************************************\n");
  800961:	83 ec 0c             	sub    $0xc,%esp
  800964:	68 20 3a 80 00       	push   $0x803a20
  800969:	e8 6d 03 00 00       	call   800cdb <cprintf>
  80096e:	83 c4 10             	add    $0x10,%esp
	cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  800971:	a1 20 50 80 00       	mov    0x805020,%eax
  800976:	8b 90 44 05 00 00    	mov    0x544(%eax),%edx
  80097c:	a1 20 50 80 00       	mov    0x805020,%eax
  800981:	8b 80 34 05 00 00    	mov    0x534(%eax),%eax
  800987:	83 ec 04             	sub    $0x4,%esp
  80098a:	52                   	push   %edx
  80098b:	50                   	push   %eax
  80098c:	68 48 3a 80 00       	push   $0x803a48
  800991:	e8 45 03 00 00       	call   800cdb <cprintf>
  800996:	83 c4 10             	add    $0x10,%esp
	cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  800999:	a1 20 50 80 00       	mov    0x805020,%eax
  80099e:	8b 88 54 05 00 00    	mov    0x554(%eax),%ecx
  8009a4:	a1 20 50 80 00       	mov    0x805020,%eax
  8009a9:	8b 90 50 05 00 00    	mov    0x550(%eax),%edx
  8009af:	a1 20 50 80 00       	mov    0x805020,%eax
  8009b4:	8b 80 4c 05 00 00    	mov    0x54c(%eax),%eax
  8009ba:	51                   	push   %ecx
  8009bb:	52                   	push   %edx
  8009bc:	50                   	push   %eax
  8009bd:	68 70 3a 80 00       	push   $0x803a70
  8009c2:	e8 14 03 00 00       	call   800cdb <cprintf>
  8009c7:	83 c4 10             	add    $0x10,%esp
	//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
	cprintf("Num of clocks = %d\n", myEnv->nClocks);
  8009ca:	a1 20 50 80 00       	mov    0x805020,%eax
  8009cf:	8b 80 a4 05 00 00    	mov    0x5a4(%eax),%eax
  8009d5:	83 ec 08             	sub    $0x8,%esp
  8009d8:	50                   	push   %eax
  8009d9:	68 c8 3a 80 00       	push   $0x803ac8
  8009de:	e8 f8 02 00 00       	call   800cdb <cprintf>
  8009e3:	83 c4 10             	add    $0x10,%esp
	cprintf("**************************************\n");
  8009e6:	83 ec 0c             	sub    $0xc,%esp
  8009e9:	68 20 3a 80 00       	push   $0x803a20
  8009ee:	e8 e8 02 00 00       	call   800cdb <cprintf>
  8009f3:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  8009f6:	e8 85 17 00 00       	call   802180 <sys_enable_interrupt>

	// exit gracefully
	exit();
  8009fb:	e8 19 00 00 00       	call   800a19 <exit>
}
  800a00:	90                   	nop
  800a01:	c9                   	leave  
  800a02:	c3                   	ret    

00800a03 <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  800a03:	55                   	push   %ebp
  800a04:	89 e5                	mov    %esp,%ebp
  800a06:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  800a09:	83 ec 0c             	sub    $0xc,%esp
  800a0c:	6a 00                	push   $0x0
  800a0e:	e8 12 19 00 00       	call   802325 <sys_destroy_env>
  800a13:	83 c4 10             	add    $0x10,%esp
}
  800a16:	90                   	nop
  800a17:	c9                   	leave  
  800a18:	c3                   	ret    

00800a19 <exit>:

void
exit(void)
{
  800a19:	55                   	push   %ebp
  800a1a:	89 e5                	mov    %esp,%ebp
  800a1c:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  800a1f:	e8 67 19 00 00       	call   80238b <sys_exit_env>
}
  800a24:	90                   	nop
  800a25:	c9                   	leave  
  800a26:	c3                   	ret    

00800a27 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  800a27:	55                   	push   %ebp
  800a28:	89 e5                	mov    %esp,%ebp
  800a2a:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  800a2d:	8d 45 10             	lea    0x10(%ebp),%eax
  800a30:	83 c0 04             	add    $0x4,%eax
  800a33:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  800a36:	a1 5c 51 80 00       	mov    0x80515c,%eax
  800a3b:	85 c0                	test   %eax,%eax
  800a3d:	74 16                	je     800a55 <_panic+0x2e>
		cprintf("%s: ", argv0);
  800a3f:	a1 5c 51 80 00       	mov    0x80515c,%eax
  800a44:	83 ec 08             	sub    $0x8,%esp
  800a47:	50                   	push   %eax
  800a48:	68 dc 3a 80 00       	push   $0x803adc
  800a4d:	e8 89 02 00 00       	call   800cdb <cprintf>
  800a52:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  800a55:	a1 00 50 80 00       	mov    0x805000,%eax
  800a5a:	ff 75 0c             	pushl  0xc(%ebp)
  800a5d:	ff 75 08             	pushl  0x8(%ebp)
  800a60:	50                   	push   %eax
  800a61:	68 e1 3a 80 00       	push   $0x803ae1
  800a66:	e8 70 02 00 00       	call   800cdb <cprintf>
  800a6b:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  800a6e:	8b 45 10             	mov    0x10(%ebp),%eax
  800a71:	83 ec 08             	sub    $0x8,%esp
  800a74:	ff 75 f4             	pushl  -0xc(%ebp)
  800a77:	50                   	push   %eax
  800a78:	e8 f3 01 00 00       	call   800c70 <vcprintf>
  800a7d:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  800a80:	83 ec 08             	sub    $0x8,%esp
  800a83:	6a 00                	push   $0x0
  800a85:	68 fd 3a 80 00       	push   $0x803afd
  800a8a:	e8 e1 01 00 00       	call   800c70 <vcprintf>
  800a8f:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  800a92:	e8 82 ff ff ff       	call   800a19 <exit>

	// should not return here
	while (1) ;
  800a97:	eb fe                	jmp    800a97 <_panic+0x70>

00800a99 <CheckWSWithoutLastIndex>:
}

void CheckWSWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  800a99:	55                   	push   %ebp
  800a9a:	89 e5                	mov    %esp,%ebp
  800a9c:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  800a9f:	a1 20 50 80 00       	mov    0x805020,%eax
  800aa4:	8b 50 74             	mov    0x74(%eax),%edx
  800aa7:	8b 45 0c             	mov    0xc(%ebp),%eax
  800aaa:	39 c2                	cmp    %eax,%edx
  800aac:	74 14                	je     800ac2 <CheckWSWithoutLastIndex+0x29>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  800aae:	83 ec 04             	sub    $0x4,%esp
  800ab1:	68 00 3b 80 00       	push   $0x803b00
  800ab6:	6a 26                	push   $0x26
  800ab8:	68 4c 3b 80 00       	push   $0x803b4c
  800abd:	e8 65 ff ff ff       	call   800a27 <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  800ac2:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  800ac9:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800ad0:	e9 c2 00 00 00       	jmp    800b97 <CheckWSWithoutLastIndex+0xfe>
		if (expectedPages[e] == 0) {
  800ad5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800ad8:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800adf:	8b 45 08             	mov    0x8(%ebp),%eax
  800ae2:	01 d0                	add    %edx,%eax
  800ae4:	8b 00                	mov    (%eax),%eax
  800ae6:	85 c0                	test   %eax,%eax
  800ae8:	75 08                	jne    800af2 <CheckWSWithoutLastIndex+0x59>
			expectedNumOfEmptyLocs++;
  800aea:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  800aed:	e9 a2 00 00 00       	jmp    800b94 <CheckWSWithoutLastIndex+0xfb>
		}
		int found = 0;
  800af2:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800af9:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  800b00:	eb 69                	jmp    800b6b <CheckWSWithoutLastIndex+0xd2>
			if (myEnv->__uptr_pws[w].empty == 0) {
  800b02:	a1 20 50 80 00       	mov    0x805020,%eax
  800b07:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  800b0d:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800b10:	89 d0                	mov    %edx,%eax
  800b12:	01 c0                	add    %eax,%eax
  800b14:	01 d0                	add    %edx,%eax
  800b16:	c1 e0 03             	shl    $0x3,%eax
  800b19:	01 c8                	add    %ecx,%eax
  800b1b:	8a 40 04             	mov    0x4(%eax),%al
  800b1e:	84 c0                	test   %al,%al
  800b20:	75 46                	jne    800b68 <CheckWSWithoutLastIndex+0xcf>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  800b22:	a1 20 50 80 00       	mov    0x805020,%eax
  800b27:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  800b2d:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800b30:	89 d0                	mov    %edx,%eax
  800b32:	01 c0                	add    %eax,%eax
  800b34:	01 d0                	add    %edx,%eax
  800b36:	c1 e0 03             	shl    $0x3,%eax
  800b39:	01 c8                	add    %ecx,%eax
  800b3b:	8b 00                	mov    (%eax),%eax
  800b3d:	89 45 dc             	mov    %eax,-0x24(%ebp)
  800b40:	8b 45 dc             	mov    -0x24(%ebp),%eax
  800b43:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800b48:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  800b4a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800b4d:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  800b54:	8b 45 08             	mov    0x8(%ebp),%eax
  800b57:	01 c8                	add    %ecx,%eax
  800b59:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  800b5b:	39 c2                	cmp    %eax,%edx
  800b5d:	75 09                	jne    800b68 <CheckWSWithoutLastIndex+0xcf>
						== expectedPages[e]) {
					found = 1;
  800b5f:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  800b66:	eb 12                	jmp    800b7a <CheckWSWithoutLastIndex+0xe1>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800b68:	ff 45 e8             	incl   -0x18(%ebp)
  800b6b:	a1 20 50 80 00       	mov    0x805020,%eax
  800b70:	8b 50 74             	mov    0x74(%eax),%edx
  800b73:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800b76:	39 c2                	cmp    %eax,%edx
  800b78:	77 88                	ja     800b02 <CheckWSWithoutLastIndex+0x69>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  800b7a:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  800b7e:	75 14                	jne    800b94 <CheckWSWithoutLastIndex+0xfb>
			panic(
  800b80:	83 ec 04             	sub    $0x4,%esp
  800b83:	68 58 3b 80 00       	push   $0x803b58
  800b88:	6a 3a                	push   $0x3a
  800b8a:	68 4c 3b 80 00       	push   $0x803b4c
  800b8f:	e8 93 fe ff ff       	call   800a27 <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  800b94:	ff 45 f0             	incl   -0x10(%ebp)
  800b97:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800b9a:	3b 45 0c             	cmp    0xc(%ebp),%eax
  800b9d:	0f 8c 32 ff ff ff    	jl     800ad5 <CheckWSWithoutLastIndex+0x3c>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  800ba3:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800baa:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  800bb1:	eb 26                	jmp    800bd9 <CheckWSWithoutLastIndex+0x140>
		if (myEnv->__uptr_pws[w].empty == 1) {
  800bb3:	a1 20 50 80 00       	mov    0x805020,%eax
  800bb8:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  800bbe:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800bc1:	89 d0                	mov    %edx,%eax
  800bc3:	01 c0                	add    %eax,%eax
  800bc5:	01 d0                	add    %edx,%eax
  800bc7:	c1 e0 03             	shl    $0x3,%eax
  800bca:	01 c8                	add    %ecx,%eax
  800bcc:	8a 40 04             	mov    0x4(%eax),%al
  800bcf:	3c 01                	cmp    $0x1,%al
  800bd1:	75 03                	jne    800bd6 <CheckWSWithoutLastIndex+0x13d>
			actualNumOfEmptyLocs++;
  800bd3:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800bd6:	ff 45 e0             	incl   -0x20(%ebp)
  800bd9:	a1 20 50 80 00       	mov    0x805020,%eax
  800bde:	8b 50 74             	mov    0x74(%eax),%edx
  800be1:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800be4:	39 c2                	cmp    %eax,%edx
  800be6:	77 cb                	ja     800bb3 <CheckWSWithoutLastIndex+0x11a>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  800be8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800beb:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  800bee:	74 14                	je     800c04 <CheckWSWithoutLastIndex+0x16b>
		panic(
  800bf0:	83 ec 04             	sub    $0x4,%esp
  800bf3:	68 ac 3b 80 00       	push   $0x803bac
  800bf8:	6a 44                	push   $0x44
  800bfa:	68 4c 3b 80 00       	push   $0x803b4c
  800bff:	e8 23 fe ff ff       	call   800a27 <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  800c04:	90                   	nop
  800c05:	c9                   	leave  
  800c06:	c3                   	ret    

00800c07 <putch>:
};

//2017:
uint8 printProgName = 0;

static void putch(int ch, struct printbuf *b) {
  800c07:	55                   	push   %ebp
  800c08:	89 e5                	mov    %esp,%ebp
  800c0a:	83 ec 08             	sub    $0x8,%esp
	b->buf[b->idx++] = ch;
  800c0d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c10:	8b 00                	mov    (%eax),%eax
  800c12:	8d 48 01             	lea    0x1(%eax),%ecx
  800c15:	8b 55 0c             	mov    0xc(%ebp),%edx
  800c18:	89 0a                	mov    %ecx,(%edx)
  800c1a:	8b 55 08             	mov    0x8(%ebp),%edx
  800c1d:	88 d1                	mov    %dl,%cl
  800c1f:	8b 55 0c             	mov    0xc(%ebp),%edx
  800c22:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  800c26:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c29:	8b 00                	mov    (%eax),%eax
  800c2b:	3d ff 00 00 00       	cmp    $0xff,%eax
  800c30:	75 2c                	jne    800c5e <putch+0x57>
		sys_cputs(b->buf, b->idx, printProgName);
  800c32:	a0 24 50 80 00       	mov    0x805024,%al
  800c37:	0f b6 c0             	movzbl %al,%eax
  800c3a:	8b 55 0c             	mov    0xc(%ebp),%edx
  800c3d:	8b 12                	mov    (%edx),%edx
  800c3f:	89 d1                	mov    %edx,%ecx
  800c41:	8b 55 0c             	mov    0xc(%ebp),%edx
  800c44:	83 c2 08             	add    $0x8,%edx
  800c47:	83 ec 04             	sub    $0x4,%esp
  800c4a:	50                   	push   %eax
  800c4b:	51                   	push   %ecx
  800c4c:	52                   	push   %edx
  800c4d:	e8 66 13 00 00       	call   801fb8 <sys_cputs>
  800c52:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  800c55:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c58:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  800c5e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c61:	8b 40 04             	mov    0x4(%eax),%eax
  800c64:	8d 50 01             	lea    0x1(%eax),%edx
  800c67:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c6a:	89 50 04             	mov    %edx,0x4(%eax)
}
  800c6d:	90                   	nop
  800c6e:	c9                   	leave  
  800c6f:	c3                   	ret    

00800c70 <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  800c70:	55                   	push   %ebp
  800c71:	89 e5                	mov    %esp,%ebp
  800c73:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  800c79:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800c80:	00 00 00 
	b.cnt = 0;
  800c83:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800c8a:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  800c8d:	ff 75 0c             	pushl  0xc(%ebp)
  800c90:	ff 75 08             	pushl  0x8(%ebp)
  800c93:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800c99:	50                   	push   %eax
  800c9a:	68 07 0c 80 00       	push   $0x800c07
  800c9f:	e8 11 02 00 00       	call   800eb5 <vprintfmt>
  800ca4:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName);
  800ca7:	a0 24 50 80 00       	mov    0x805024,%al
  800cac:	0f b6 c0             	movzbl %al,%eax
  800caf:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  800cb5:	83 ec 04             	sub    $0x4,%esp
  800cb8:	50                   	push   %eax
  800cb9:	52                   	push   %edx
  800cba:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800cc0:	83 c0 08             	add    $0x8,%eax
  800cc3:	50                   	push   %eax
  800cc4:	e8 ef 12 00 00       	call   801fb8 <sys_cputs>
  800cc9:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  800ccc:	c6 05 24 50 80 00 00 	movb   $0x0,0x805024
	return b.cnt;
  800cd3:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  800cd9:	c9                   	leave  
  800cda:	c3                   	ret    

00800cdb <cprintf>:

int cprintf(const char *fmt, ...) {
  800cdb:	55                   	push   %ebp
  800cdc:	89 e5                	mov    %esp,%ebp
  800cde:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  800ce1:	c6 05 24 50 80 00 01 	movb   $0x1,0x805024
	va_start(ap, fmt);
  800ce8:	8d 45 0c             	lea    0xc(%ebp),%eax
  800ceb:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800cee:	8b 45 08             	mov    0x8(%ebp),%eax
  800cf1:	83 ec 08             	sub    $0x8,%esp
  800cf4:	ff 75 f4             	pushl  -0xc(%ebp)
  800cf7:	50                   	push   %eax
  800cf8:	e8 73 ff ff ff       	call   800c70 <vcprintf>
  800cfd:	83 c4 10             	add    $0x10,%esp
  800d00:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  800d03:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800d06:	c9                   	leave  
  800d07:	c3                   	ret    

00800d08 <atomic_cprintf>:

int atomic_cprintf(const char *fmt, ...) {
  800d08:	55                   	push   %ebp
  800d09:	89 e5                	mov    %esp,%ebp
  800d0b:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  800d0e:	e8 53 14 00 00       	call   802166 <sys_disable_interrupt>
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  800d13:	8d 45 0c             	lea    0xc(%ebp),%eax
  800d16:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800d19:	8b 45 08             	mov    0x8(%ebp),%eax
  800d1c:	83 ec 08             	sub    $0x8,%esp
  800d1f:	ff 75 f4             	pushl  -0xc(%ebp)
  800d22:	50                   	push   %eax
  800d23:	e8 48 ff ff ff       	call   800c70 <vcprintf>
  800d28:	83 c4 10             	add    $0x10,%esp
  800d2b:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	sys_enable_interrupt();
  800d2e:	e8 4d 14 00 00       	call   802180 <sys_enable_interrupt>
	return cnt;
  800d33:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800d36:	c9                   	leave  
  800d37:	c3                   	ret    

00800d38 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800d38:	55                   	push   %ebp
  800d39:	89 e5                	mov    %esp,%ebp
  800d3b:	53                   	push   %ebx
  800d3c:	83 ec 14             	sub    $0x14,%esp
  800d3f:	8b 45 10             	mov    0x10(%ebp),%eax
  800d42:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800d45:	8b 45 14             	mov    0x14(%ebp),%eax
  800d48:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800d4b:	8b 45 18             	mov    0x18(%ebp),%eax
  800d4e:	ba 00 00 00 00       	mov    $0x0,%edx
  800d53:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800d56:	77 55                	ja     800dad <printnum+0x75>
  800d58:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800d5b:	72 05                	jb     800d62 <printnum+0x2a>
  800d5d:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800d60:	77 4b                	ja     800dad <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800d62:	8b 45 1c             	mov    0x1c(%ebp),%eax
  800d65:	8d 58 ff             	lea    -0x1(%eax),%ebx
  800d68:	8b 45 18             	mov    0x18(%ebp),%eax
  800d6b:	ba 00 00 00 00       	mov    $0x0,%edx
  800d70:	52                   	push   %edx
  800d71:	50                   	push   %eax
  800d72:	ff 75 f4             	pushl  -0xc(%ebp)
  800d75:	ff 75 f0             	pushl  -0x10(%ebp)
  800d78:	e8 87 28 00 00       	call   803604 <__udivdi3>
  800d7d:	83 c4 10             	add    $0x10,%esp
  800d80:	83 ec 04             	sub    $0x4,%esp
  800d83:	ff 75 20             	pushl  0x20(%ebp)
  800d86:	53                   	push   %ebx
  800d87:	ff 75 18             	pushl  0x18(%ebp)
  800d8a:	52                   	push   %edx
  800d8b:	50                   	push   %eax
  800d8c:	ff 75 0c             	pushl  0xc(%ebp)
  800d8f:	ff 75 08             	pushl  0x8(%ebp)
  800d92:	e8 a1 ff ff ff       	call   800d38 <printnum>
  800d97:	83 c4 20             	add    $0x20,%esp
  800d9a:	eb 1a                	jmp    800db6 <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800d9c:	83 ec 08             	sub    $0x8,%esp
  800d9f:	ff 75 0c             	pushl  0xc(%ebp)
  800da2:	ff 75 20             	pushl  0x20(%ebp)
  800da5:	8b 45 08             	mov    0x8(%ebp),%eax
  800da8:	ff d0                	call   *%eax
  800daa:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800dad:	ff 4d 1c             	decl   0x1c(%ebp)
  800db0:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  800db4:	7f e6                	jg     800d9c <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800db6:	8b 4d 18             	mov    0x18(%ebp),%ecx
  800db9:	bb 00 00 00 00       	mov    $0x0,%ebx
  800dbe:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800dc1:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800dc4:	53                   	push   %ebx
  800dc5:	51                   	push   %ecx
  800dc6:	52                   	push   %edx
  800dc7:	50                   	push   %eax
  800dc8:	e8 47 29 00 00       	call   803714 <__umoddi3>
  800dcd:	83 c4 10             	add    $0x10,%esp
  800dd0:	05 14 3e 80 00       	add    $0x803e14,%eax
  800dd5:	8a 00                	mov    (%eax),%al
  800dd7:	0f be c0             	movsbl %al,%eax
  800dda:	83 ec 08             	sub    $0x8,%esp
  800ddd:	ff 75 0c             	pushl  0xc(%ebp)
  800de0:	50                   	push   %eax
  800de1:	8b 45 08             	mov    0x8(%ebp),%eax
  800de4:	ff d0                	call   *%eax
  800de6:	83 c4 10             	add    $0x10,%esp
}
  800de9:	90                   	nop
  800dea:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800ded:	c9                   	leave  
  800dee:	c3                   	ret    

00800def <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  800def:	55                   	push   %ebp
  800df0:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800df2:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800df6:	7e 1c                	jle    800e14 <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  800df8:	8b 45 08             	mov    0x8(%ebp),%eax
  800dfb:	8b 00                	mov    (%eax),%eax
  800dfd:	8d 50 08             	lea    0x8(%eax),%edx
  800e00:	8b 45 08             	mov    0x8(%ebp),%eax
  800e03:	89 10                	mov    %edx,(%eax)
  800e05:	8b 45 08             	mov    0x8(%ebp),%eax
  800e08:	8b 00                	mov    (%eax),%eax
  800e0a:	83 e8 08             	sub    $0x8,%eax
  800e0d:	8b 50 04             	mov    0x4(%eax),%edx
  800e10:	8b 00                	mov    (%eax),%eax
  800e12:	eb 40                	jmp    800e54 <getuint+0x65>
	else if (lflag)
  800e14:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800e18:	74 1e                	je     800e38 <getuint+0x49>
		return va_arg(*ap, unsigned long);
  800e1a:	8b 45 08             	mov    0x8(%ebp),%eax
  800e1d:	8b 00                	mov    (%eax),%eax
  800e1f:	8d 50 04             	lea    0x4(%eax),%edx
  800e22:	8b 45 08             	mov    0x8(%ebp),%eax
  800e25:	89 10                	mov    %edx,(%eax)
  800e27:	8b 45 08             	mov    0x8(%ebp),%eax
  800e2a:	8b 00                	mov    (%eax),%eax
  800e2c:	83 e8 04             	sub    $0x4,%eax
  800e2f:	8b 00                	mov    (%eax),%eax
  800e31:	ba 00 00 00 00       	mov    $0x0,%edx
  800e36:	eb 1c                	jmp    800e54 <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  800e38:	8b 45 08             	mov    0x8(%ebp),%eax
  800e3b:	8b 00                	mov    (%eax),%eax
  800e3d:	8d 50 04             	lea    0x4(%eax),%edx
  800e40:	8b 45 08             	mov    0x8(%ebp),%eax
  800e43:	89 10                	mov    %edx,(%eax)
  800e45:	8b 45 08             	mov    0x8(%ebp),%eax
  800e48:	8b 00                	mov    (%eax),%eax
  800e4a:	83 e8 04             	sub    $0x4,%eax
  800e4d:	8b 00                	mov    (%eax),%eax
  800e4f:	ba 00 00 00 00       	mov    $0x0,%edx
}
  800e54:	5d                   	pop    %ebp
  800e55:	c3                   	ret    

00800e56 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  800e56:	55                   	push   %ebp
  800e57:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800e59:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800e5d:	7e 1c                	jle    800e7b <getint+0x25>
		return va_arg(*ap, long long);
  800e5f:	8b 45 08             	mov    0x8(%ebp),%eax
  800e62:	8b 00                	mov    (%eax),%eax
  800e64:	8d 50 08             	lea    0x8(%eax),%edx
  800e67:	8b 45 08             	mov    0x8(%ebp),%eax
  800e6a:	89 10                	mov    %edx,(%eax)
  800e6c:	8b 45 08             	mov    0x8(%ebp),%eax
  800e6f:	8b 00                	mov    (%eax),%eax
  800e71:	83 e8 08             	sub    $0x8,%eax
  800e74:	8b 50 04             	mov    0x4(%eax),%edx
  800e77:	8b 00                	mov    (%eax),%eax
  800e79:	eb 38                	jmp    800eb3 <getint+0x5d>
	else if (lflag)
  800e7b:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800e7f:	74 1a                	je     800e9b <getint+0x45>
		return va_arg(*ap, long);
  800e81:	8b 45 08             	mov    0x8(%ebp),%eax
  800e84:	8b 00                	mov    (%eax),%eax
  800e86:	8d 50 04             	lea    0x4(%eax),%edx
  800e89:	8b 45 08             	mov    0x8(%ebp),%eax
  800e8c:	89 10                	mov    %edx,(%eax)
  800e8e:	8b 45 08             	mov    0x8(%ebp),%eax
  800e91:	8b 00                	mov    (%eax),%eax
  800e93:	83 e8 04             	sub    $0x4,%eax
  800e96:	8b 00                	mov    (%eax),%eax
  800e98:	99                   	cltd   
  800e99:	eb 18                	jmp    800eb3 <getint+0x5d>
	else
		return va_arg(*ap, int);
  800e9b:	8b 45 08             	mov    0x8(%ebp),%eax
  800e9e:	8b 00                	mov    (%eax),%eax
  800ea0:	8d 50 04             	lea    0x4(%eax),%edx
  800ea3:	8b 45 08             	mov    0x8(%ebp),%eax
  800ea6:	89 10                	mov    %edx,(%eax)
  800ea8:	8b 45 08             	mov    0x8(%ebp),%eax
  800eab:	8b 00                	mov    (%eax),%eax
  800ead:	83 e8 04             	sub    $0x4,%eax
  800eb0:	8b 00                	mov    (%eax),%eax
  800eb2:	99                   	cltd   
}
  800eb3:	5d                   	pop    %ebp
  800eb4:	c3                   	ret    

00800eb5 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  800eb5:	55                   	push   %ebp
  800eb6:	89 e5                	mov    %esp,%ebp
  800eb8:	56                   	push   %esi
  800eb9:	53                   	push   %ebx
  800eba:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800ebd:	eb 17                	jmp    800ed6 <vprintfmt+0x21>
			if (ch == '\0')
  800ebf:	85 db                	test   %ebx,%ebx
  800ec1:	0f 84 af 03 00 00    	je     801276 <vprintfmt+0x3c1>
				return;
			putch(ch, putdat);
  800ec7:	83 ec 08             	sub    $0x8,%esp
  800eca:	ff 75 0c             	pushl  0xc(%ebp)
  800ecd:	53                   	push   %ebx
  800ece:	8b 45 08             	mov    0x8(%ebp),%eax
  800ed1:	ff d0                	call   *%eax
  800ed3:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800ed6:	8b 45 10             	mov    0x10(%ebp),%eax
  800ed9:	8d 50 01             	lea    0x1(%eax),%edx
  800edc:	89 55 10             	mov    %edx,0x10(%ebp)
  800edf:	8a 00                	mov    (%eax),%al
  800ee1:	0f b6 d8             	movzbl %al,%ebx
  800ee4:	83 fb 25             	cmp    $0x25,%ebx
  800ee7:	75 d6                	jne    800ebf <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  800ee9:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  800eed:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  800ef4:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  800efb:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  800f02:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800f09:	8b 45 10             	mov    0x10(%ebp),%eax
  800f0c:	8d 50 01             	lea    0x1(%eax),%edx
  800f0f:	89 55 10             	mov    %edx,0x10(%ebp)
  800f12:	8a 00                	mov    (%eax),%al
  800f14:	0f b6 d8             	movzbl %al,%ebx
  800f17:	8d 43 dd             	lea    -0x23(%ebx),%eax
  800f1a:	83 f8 55             	cmp    $0x55,%eax
  800f1d:	0f 87 2b 03 00 00    	ja     80124e <vprintfmt+0x399>
  800f23:	8b 04 85 38 3e 80 00 	mov    0x803e38(,%eax,4),%eax
  800f2a:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  800f2c:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  800f30:	eb d7                	jmp    800f09 <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800f32:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  800f36:	eb d1                	jmp    800f09 <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800f38:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  800f3f:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800f42:	89 d0                	mov    %edx,%eax
  800f44:	c1 e0 02             	shl    $0x2,%eax
  800f47:	01 d0                	add    %edx,%eax
  800f49:	01 c0                	add    %eax,%eax
  800f4b:	01 d8                	add    %ebx,%eax
  800f4d:	83 e8 30             	sub    $0x30,%eax
  800f50:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  800f53:	8b 45 10             	mov    0x10(%ebp),%eax
  800f56:	8a 00                	mov    (%eax),%al
  800f58:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  800f5b:	83 fb 2f             	cmp    $0x2f,%ebx
  800f5e:	7e 3e                	jle    800f9e <vprintfmt+0xe9>
  800f60:	83 fb 39             	cmp    $0x39,%ebx
  800f63:	7f 39                	jg     800f9e <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800f65:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800f68:	eb d5                	jmp    800f3f <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  800f6a:	8b 45 14             	mov    0x14(%ebp),%eax
  800f6d:	83 c0 04             	add    $0x4,%eax
  800f70:	89 45 14             	mov    %eax,0x14(%ebp)
  800f73:	8b 45 14             	mov    0x14(%ebp),%eax
  800f76:	83 e8 04             	sub    $0x4,%eax
  800f79:	8b 00                	mov    (%eax),%eax
  800f7b:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  800f7e:	eb 1f                	jmp    800f9f <vprintfmt+0xea>

		case '.':
			if (width < 0)
  800f80:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800f84:	79 83                	jns    800f09 <vprintfmt+0x54>
				width = 0;
  800f86:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  800f8d:	e9 77 ff ff ff       	jmp    800f09 <vprintfmt+0x54>

		case '#':
			altflag = 1;
  800f92:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  800f99:	e9 6b ff ff ff       	jmp    800f09 <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  800f9e:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  800f9f:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800fa3:	0f 89 60 ff ff ff    	jns    800f09 <vprintfmt+0x54>
				width = precision, precision = -1;
  800fa9:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800fac:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800faf:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  800fb6:	e9 4e ff ff ff       	jmp    800f09 <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  800fbb:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  800fbe:	e9 46 ff ff ff       	jmp    800f09 <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  800fc3:	8b 45 14             	mov    0x14(%ebp),%eax
  800fc6:	83 c0 04             	add    $0x4,%eax
  800fc9:	89 45 14             	mov    %eax,0x14(%ebp)
  800fcc:	8b 45 14             	mov    0x14(%ebp),%eax
  800fcf:	83 e8 04             	sub    $0x4,%eax
  800fd2:	8b 00                	mov    (%eax),%eax
  800fd4:	83 ec 08             	sub    $0x8,%esp
  800fd7:	ff 75 0c             	pushl  0xc(%ebp)
  800fda:	50                   	push   %eax
  800fdb:	8b 45 08             	mov    0x8(%ebp),%eax
  800fde:	ff d0                	call   *%eax
  800fe0:	83 c4 10             	add    $0x10,%esp
			break;
  800fe3:	e9 89 02 00 00       	jmp    801271 <vprintfmt+0x3bc>

		// error message
		case 'e':
			err = va_arg(ap, int);
  800fe8:	8b 45 14             	mov    0x14(%ebp),%eax
  800feb:	83 c0 04             	add    $0x4,%eax
  800fee:	89 45 14             	mov    %eax,0x14(%ebp)
  800ff1:	8b 45 14             	mov    0x14(%ebp),%eax
  800ff4:	83 e8 04             	sub    $0x4,%eax
  800ff7:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  800ff9:	85 db                	test   %ebx,%ebx
  800ffb:	79 02                	jns    800fff <vprintfmt+0x14a>
				err = -err;
  800ffd:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  800fff:	83 fb 64             	cmp    $0x64,%ebx
  801002:	7f 0b                	jg     80100f <vprintfmt+0x15a>
  801004:	8b 34 9d 80 3c 80 00 	mov    0x803c80(,%ebx,4),%esi
  80100b:	85 f6                	test   %esi,%esi
  80100d:	75 19                	jne    801028 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  80100f:	53                   	push   %ebx
  801010:	68 25 3e 80 00       	push   $0x803e25
  801015:	ff 75 0c             	pushl  0xc(%ebp)
  801018:	ff 75 08             	pushl  0x8(%ebp)
  80101b:	e8 5e 02 00 00       	call   80127e <printfmt>
  801020:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  801023:	e9 49 02 00 00       	jmp    801271 <vprintfmt+0x3bc>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  801028:	56                   	push   %esi
  801029:	68 2e 3e 80 00       	push   $0x803e2e
  80102e:	ff 75 0c             	pushl  0xc(%ebp)
  801031:	ff 75 08             	pushl  0x8(%ebp)
  801034:	e8 45 02 00 00       	call   80127e <printfmt>
  801039:	83 c4 10             	add    $0x10,%esp
			break;
  80103c:	e9 30 02 00 00       	jmp    801271 <vprintfmt+0x3bc>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  801041:	8b 45 14             	mov    0x14(%ebp),%eax
  801044:	83 c0 04             	add    $0x4,%eax
  801047:	89 45 14             	mov    %eax,0x14(%ebp)
  80104a:	8b 45 14             	mov    0x14(%ebp),%eax
  80104d:	83 e8 04             	sub    $0x4,%eax
  801050:	8b 30                	mov    (%eax),%esi
  801052:	85 f6                	test   %esi,%esi
  801054:	75 05                	jne    80105b <vprintfmt+0x1a6>
				p = "(null)";
  801056:	be 31 3e 80 00       	mov    $0x803e31,%esi
			if (width > 0 && padc != '-')
  80105b:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80105f:	7e 6d                	jle    8010ce <vprintfmt+0x219>
  801061:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  801065:	74 67                	je     8010ce <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  801067:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80106a:	83 ec 08             	sub    $0x8,%esp
  80106d:	50                   	push   %eax
  80106e:	56                   	push   %esi
  80106f:	e8 0c 03 00 00       	call   801380 <strnlen>
  801074:	83 c4 10             	add    $0x10,%esp
  801077:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  80107a:	eb 16                	jmp    801092 <vprintfmt+0x1dd>
					putch(padc, putdat);
  80107c:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  801080:	83 ec 08             	sub    $0x8,%esp
  801083:	ff 75 0c             	pushl  0xc(%ebp)
  801086:	50                   	push   %eax
  801087:	8b 45 08             	mov    0x8(%ebp),%eax
  80108a:	ff d0                	call   *%eax
  80108c:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  80108f:	ff 4d e4             	decl   -0x1c(%ebp)
  801092:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  801096:	7f e4                	jg     80107c <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  801098:	eb 34                	jmp    8010ce <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  80109a:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  80109e:	74 1c                	je     8010bc <vprintfmt+0x207>
  8010a0:	83 fb 1f             	cmp    $0x1f,%ebx
  8010a3:	7e 05                	jle    8010aa <vprintfmt+0x1f5>
  8010a5:	83 fb 7e             	cmp    $0x7e,%ebx
  8010a8:	7e 12                	jle    8010bc <vprintfmt+0x207>
					putch('?', putdat);
  8010aa:	83 ec 08             	sub    $0x8,%esp
  8010ad:	ff 75 0c             	pushl  0xc(%ebp)
  8010b0:	6a 3f                	push   $0x3f
  8010b2:	8b 45 08             	mov    0x8(%ebp),%eax
  8010b5:	ff d0                	call   *%eax
  8010b7:	83 c4 10             	add    $0x10,%esp
  8010ba:	eb 0f                	jmp    8010cb <vprintfmt+0x216>
				else
					putch(ch, putdat);
  8010bc:	83 ec 08             	sub    $0x8,%esp
  8010bf:	ff 75 0c             	pushl  0xc(%ebp)
  8010c2:	53                   	push   %ebx
  8010c3:	8b 45 08             	mov    0x8(%ebp),%eax
  8010c6:	ff d0                	call   *%eax
  8010c8:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8010cb:	ff 4d e4             	decl   -0x1c(%ebp)
  8010ce:	89 f0                	mov    %esi,%eax
  8010d0:	8d 70 01             	lea    0x1(%eax),%esi
  8010d3:	8a 00                	mov    (%eax),%al
  8010d5:	0f be d8             	movsbl %al,%ebx
  8010d8:	85 db                	test   %ebx,%ebx
  8010da:	74 24                	je     801100 <vprintfmt+0x24b>
  8010dc:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8010e0:	78 b8                	js     80109a <vprintfmt+0x1e5>
  8010e2:	ff 4d e0             	decl   -0x20(%ebp)
  8010e5:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8010e9:	79 af                	jns    80109a <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  8010eb:	eb 13                	jmp    801100 <vprintfmt+0x24b>
				putch(' ', putdat);
  8010ed:	83 ec 08             	sub    $0x8,%esp
  8010f0:	ff 75 0c             	pushl  0xc(%ebp)
  8010f3:	6a 20                	push   $0x20
  8010f5:	8b 45 08             	mov    0x8(%ebp),%eax
  8010f8:	ff d0                	call   *%eax
  8010fa:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  8010fd:	ff 4d e4             	decl   -0x1c(%ebp)
  801100:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  801104:	7f e7                	jg     8010ed <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  801106:	e9 66 01 00 00       	jmp    801271 <vprintfmt+0x3bc>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  80110b:	83 ec 08             	sub    $0x8,%esp
  80110e:	ff 75 e8             	pushl  -0x18(%ebp)
  801111:	8d 45 14             	lea    0x14(%ebp),%eax
  801114:	50                   	push   %eax
  801115:	e8 3c fd ff ff       	call   800e56 <getint>
  80111a:	83 c4 10             	add    $0x10,%esp
  80111d:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801120:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  801123:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801126:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801129:	85 d2                	test   %edx,%edx
  80112b:	79 23                	jns    801150 <vprintfmt+0x29b>
				putch('-', putdat);
  80112d:	83 ec 08             	sub    $0x8,%esp
  801130:	ff 75 0c             	pushl  0xc(%ebp)
  801133:	6a 2d                	push   $0x2d
  801135:	8b 45 08             	mov    0x8(%ebp),%eax
  801138:	ff d0                	call   *%eax
  80113a:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  80113d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801140:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801143:	f7 d8                	neg    %eax
  801145:	83 d2 00             	adc    $0x0,%edx
  801148:	f7 da                	neg    %edx
  80114a:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80114d:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  801150:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  801157:	e9 bc 00 00 00       	jmp    801218 <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  80115c:	83 ec 08             	sub    $0x8,%esp
  80115f:	ff 75 e8             	pushl  -0x18(%ebp)
  801162:	8d 45 14             	lea    0x14(%ebp),%eax
  801165:	50                   	push   %eax
  801166:	e8 84 fc ff ff       	call   800def <getuint>
  80116b:	83 c4 10             	add    $0x10,%esp
  80116e:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801171:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  801174:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  80117b:	e9 98 00 00 00       	jmp    801218 <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  801180:	83 ec 08             	sub    $0x8,%esp
  801183:	ff 75 0c             	pushl  0xc(%ebp)
  801186:	6a 58                	push   $0x58
  801188:	8b 45 08             	mov    0x8(%ebp),%eax
  80118b:	ff d0                	call   *%eax
  80118d:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  801190:	83 ec 08             	sub    $0x8,%esp
  801193:	ff 75 0c             	pushl  0xc(%ebp)
  801196:	6a 58                	push   $0x58
  801198:	8b 45 08             	mov    0x8(%ebp),%eax
  80119b:	ff d0                	call   *%eax
  80119d:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  8011a0:	83 ec 08             	sub    $0x8,%esp
  8011a3:	ff 75 0c             	pushl  0xc(%ebp)
  8011a6:	6a 58                	push   $0x58
  8011a8:	8b 45 08             	mov    0x8(%ebp),%eax
  8011ab:	ff d0                	call   *%eax
  8011ad:	83 c4 10             	add    $0x10,%esp
			break;
  8011b0:	e9 bc 00 00 00       	jmp    801271 <vprintfmt+0x3bc>

		// pointer
		case 'p':
			putch('0', putdat);
  8011b5:	83 ec 08             	sub    $0x8,%esp
  8011b8:	ff 75 0c             	pushl  0xc(%ebp)
  8011bb:	6a 30                	push   $0x30
  8011bd:	8b 45 08             	mov    0x8(%ebp),%eax
  8011c0:	ff d0                	call   *%eax
  8011c2:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  8011c5:	83 ec 08             	sub    $0x8,%esp
  8011c8:	ff 75 0c             	pushl  0xc(%ebp)
  8011cb:	6a 78                	push   $0x78
  8011cd:	8b 45 08             	mov    0x8(%ebp),%eax
  8011d0:	ff d0                	call   *%eax
  8011d2:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  8011d5:	8b 45 14             	mov    0x14(%ebp),%eax
  8011d8:	83 c0 04             	add    $0x4,%eax
  8011db:	89 45 14             	mov    %eax,0x14(%ebp)
  8011de:	8b 45 14             	mov    0x14(%ebp),%eax
  8011e1:	83 e8 04             	sub    $0x4,%eax
  8011e4:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  8011e6:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8011e9:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  8011f0:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  8011f7:	eb 1f                	jmp    801218 <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  8011f9:	83 ec 08             	sub    $0x8,%esp
  8011fc:	ff 75 e8             	pushl  -0x18(%ebp)
  8011ff:	8d 45 14             	lea    0x14(%ebp),%eax
  801202:	50                   	push   %eax
  801203:	e8 e7 fb ff ff       	call   800def <getuint>
  801208:	83 c4 10             	add    $0x10,%esp
  80120b:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80120e:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  801211:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  801218:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  80121c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80121f:	83 ec 04             	sub    $0x4,%esp
  801222:	52                   	push   %edx
  801223:	ff 75 e4             	pushl  -0x1c(%ebp)
  801226:	50                   	push   %eax
  801227:	ff 75 f4             	pushl  -0xc(%ebp)
  80122a:	ff 75 f0             	pushl  -0x10(%ebp)
  80122d:	ff 75 0c             	pushl  0xc(%ebp)
  801230:	ff 75 08             	pushl  0x8(%ebp)
  801233:	e8 00 fb ff ff       	call   800d38 <printnum>
  801238:	83 c4 20             	add    $0x20,%esp
			break;
  80123b:	eb 34                	jmp    801271 <vprintfmt+0x3bc>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  80123d:	83 ec 08             	sub    $0x8,%esp
  801240:	ff 75 0c             	pushl  0xc(%ebp)
  801243:	53                   	push   %ebx
  801244:	8b 45 08             	mov    0x8(%ebp),%eax
  801247:	ff d0                	call   *%eax
  801249:	83 c4 10             	add    $0x10,%esp
			break;
  80124c:	eb 23                	jmp    801271 <vprintfmt+0x3bc>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  80124e:	83 ec 08             	sub    $0x8,%esp
  801251:	ff 75 0c             	pushl  0xc(%ebp)
  801254:	6a 25                	push   $0x25
  801256:	8b 45 08             	mov    0x8(%ebp),%eax
  801259:	ff d0                	call   *%eax
  80125b:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  80125e:	ff 4d 10             	decl   0x10(%ebp)
  801261:	eb 03                	jmp    801266 <vprintfmt+0x3b1>
  801263:	ff 4d 10             	decl   0x10(%ebp)
  801266:	8b 45 10             	mov    0x10(%ebp),%eax
  801269:	48                   	dec    %eax
  80126a:	8a 00                	mov    (%eax),%al
  80126c:	3c 25                	cmp    $0x25,%al
  80126e:	75 f3                	jne    801263 <vprintfmt+0x3ae>
				/* do nothing */;
			break;
  801270:	90                   	nop
		}
	}
  801271:	e9 47 fc ff ff       	jmp    800ebd <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  801276:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  801277:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80127a:	5b                   	pop    %ebx
  80127b:	5e                   	pop    %esi
  80127c:	5d                   	pop    %ebp
  80127d:	c3                   	ret    

0080127e <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  80127e:	55                   	push   %ebp
  80127f:	89 e5                	mov    %esp,%ebp
  801281:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  801284:	8d 45 10             	lea    0x10(%ebp),%eax
  801287:	83 c0 04             	add    $0x4,%eax
  80128a:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  80128d:	8b 45 10             	mov    0x10(%ebp),%eax
  801290:	ff 75 f4             	pushl  -0xc(%ebp)
  801293:	50                   	push   %eax
  801294:	ff 75 0c             	pushl  0xc(%ebp)
  801297:	ff 75 08             	pushl  0x8(%ebp)
  80129a:	e8 16 fc ff ff       	call   800eb5 <vprintfmt>
  80129f:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  8012a2:	90                   	nop
  8012a3:	c9                   	leave  
  8012a4:	c3                   	ret    

008012a5 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  8012a5:	55                   	push   %ebp
  8012a6:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  8012a8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012ab:	8b 40 08             	mov    0x8(%eax),%eax
  8012ae:	8d 50 01             	lea    0x1(%eax),%edx
  8012b1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012b4:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  8012b7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012ba:	8b 10                	mov    (%eax),%edx
  8012bc:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012bf:	8b 40 04             	mov    0x4(%eax),%eax
  8012c2:	39 c2                	cmp    %eax,%edx
  8012c4:	73 12                	jae    8012d8 <sprintputch+0x33>
		*b->buf++ = ch;
  8012c6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012c9:	8b 00                	mov    (%eax),%eax
  8012cb:	8d 48 01             	lea    0x1(%eax),%ecx
  8012ce:	8b 55 0c             	mov    0xc(%ebp),%edx
  8012d1:	89 0a                	mov    %ecx,(%edx)
  8012d3:	8b 55 08             	mov    0x8(%ebp),%edx
  8012d6:	88 10                	mov    %dl,(%eax)
}
  8012d8:	90                   	nop
  8012d9:	5d                   	pop    %ebp
  8012da:	c3                   	ret    

008012db <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  8012db:	55                   	push   %ebp
  8012dc:	89 e5                	mov    %esp,%ebp
  8012de:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  8012e1:	8b 45 08             	mov    0x8(%ebp),%eax
  8012e4:	89 45 ec             	mov    %eax,-0x14(%ebp)
  8012e7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012ea:	8d 50 ff             	lea    -0x1(%eax),%edx
  8012ed:	8b 45 08             	mov    0x8(%ebp),%eax
  8012f0:	01 d0                	add    %edx,%eax
  8012f2:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8012f5:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  8012fc:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801300:	74 06                	je     801308 <vsnprintf+0x2d>
  801302:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801306:	7f 07                	jg     80130f <vsnprintf+0x34>
		return -E_INVAL;
  801308:	b8 03 00 00 00       	mov    $0x3,%eax
  80130d:	eb 20                	jmp    80132f <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  80130f:	ff 75 14             	pushl  0x14(%ebp)
  801312:	ff 75 10             	pushl  0x10(%ebp)
  801315:	8d 45 ec             	lea    -0x14(%ebp),%eax
  801318:	50                   	push   %eax
  801319:	68 a5 12 80 00       	push   $0x8012a5
  80131e:	e8 92 fb ff ff       	call   800eb5 <vprintfmt>
  801323:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  801326:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801329:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  80132c:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  80132f:	c9                   	leave  
  801330:	c3                   	ret    

00801331 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  801331:	55                   	push   %ebp
  801332:	89 e5                	mov    %esp,%ebp
  801334:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  801337:	8d 45 10             	lea    0x10(%ebp),%eax
  80133a:	83 c0 04             	add    $0x4,%eax
  80133d:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  801340:	8b 45 10             	mov    0x10(%ebp),%eax
  801343:	ff 75 f4             	pushl  -0xc(%ebp)
  801346:	50                   	push   %eax
  801347:	ff 75 0c             	pushl  0xc(%ebp)
  80134a:	ff 75 08             	pushl  0x8(%ebp)
  80134d:	e8 89 ff ff ff       	call   8012db <vsnprintf>
  801352:	83 c4 10             	add    $0x10,%esp
  801355:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  801358:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  80135b:	c9                   	leave  
  80135c:	c3                   	ret    

0080135d <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  80135d:	55                   	push   %ebp
  80135e:	89 e5                	mov    %esp,%ebp
  801360:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  801363:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  80136a:	eb 06                	jmp    801372 <strlen+0x15>
		n++;
  80136c:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  80136f:	ff 45 08             	incl   0x8(%ebp)
  801372:	8b 45 08             	mov    0x8(%ebp),%eax
  801375:	8a 00                	mov    (%eax),%al
  801377:	84 c0                	test   %al,%al
  801379:	75 f1                	jne    80136c <strlen+0xf>
		n++;
	return n;
  80137b:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  80137e:	c9                   	leave  
  80137f:	c3                   	ret    

00801380 <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  801380:	55                   	push   %ebp
  801381:	89 e5                	mov    %esp,%ebp
  801383:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  801386:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  80138d:	eb 09                	jmp    801398 <strnlen+0x18>
		n++;
  80138f:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  801392:	ff 45 08             	incl   0x8(%ebp)
  801395:	ff 4d 0c             	decl   0xc(%ebp)
  801398:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80139c:	74 09                	je     8013a7 <strnlen+0x27>
  80139e:	8b 45 08             	mov    0x8(%ebp),%eax
  8013a1:	8a 00                	mov    (%eax),%al
  8013a3:	84 c0                	test   %al,%al
  8013a5:	75 e8                	jne    80138f <strnlen+0xf>
		n++;
	return n;
  8013a7:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  8013aa:	c9                   	leave  
  8013ab:	c3                   	ret    

008013ac <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  8013ac:	55                   	push   %ebp
  8013ad:	89 e5                	mov    %esp,%ebp
  8013af:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  8013b2:	8b 45 08             	mov    0x8(%ebp),%eax
  8013b5:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  8013b8:	90                   	nop
  8013b9:	8b 45 08             	mov    0x8(%ebp),%eax
  8013bc:	8d 50 01             	lea    0x1(%eax),%edx
  8013bf:	89 55 08             	mov    %edx,0x8(%ebp)
  8013c2:	8b 55 0c             	mov    0xc(%ebp),%edx
  8013c5:	8d 4a 01             	lea    0x1(%edx),%ecx
  8013c8:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  8013cb:	8a 12                	mov    (%edx),%dl
  8013cd:	88 10                	mov    %dl,(%eax)
  8013cf:	8a 00                	mov    (%eax),%al
  8013d1:	84 c0                	test   %al,%al
  8013d3:	75 e4                	jne    8013b9 <strcpy+0xd>
		/* do nothing */;
	return ret;
  8013d5:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  8013d8:	c9                   	leave  
  8013d9:	c3                   	ret    

008013da <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  8013da:	55                   	push   %ebp
  8013db:	89 e5                	mov    %esp,%ebp
  8013dd:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  8013e0:	8b 45 08             	mov    0x8(%ebp),%eax
  8013e3:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  8013e6:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8013ed:	eb 1f                	jmp    80140e <strncpy+0x34>
		*dst++ = *src;
  8013ef:	8b 45 08             	mov    0x8(%ebp),%eax
  8013f2:	8d 50 01             	lea    0x1(%eax),%edx
  8013f5:	89 55 08             	mov    %edx,0x8(%ebp)
  8013f8:	8b 55 0c             	mov    0xc(%ebp),%edx
  8013fb:	8a 12                	mov    (%edx),%dl
  8013fd:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  8013ff:	8b 45 0c             	mov    0xc(%ebp),%eax
  801402:	8a 00                	mov    (%eax),%al
  801404:	84 c0                	test   %al,%al
  801406:	74 03                	je     80140b <strncpy+0x31>
			src++;
  801408:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  80140b:	ff 45 fc             	incl   -0x4(%ebp)
  80140e:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801411:	3b 45 10             	cmp    0x10(%ebp),%eax
  801414:	72 d9                	jb     8013ef <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  801416:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  801419:	c9                   	leave  
  80141a:	c3                   	ret    

0080141b <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  80141b:	55                   	push   %ebp
  80141c:	89 e5                	mov    %esp,%ebp
  80141e:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  801421:	8b 45 08             	mov    0x8(%ebp),%eax
  801424:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  801427:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80142b:	74 30                	je     80145d <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  80142d:	eb 16                	jmp    801445 <strlcpy+0x2a>
			*dst++ = *src++;
  80142f:	8b 45 08             	mov    0x8(%ebp),%eax
  801432:	8d 50 01             	lea    0x1(%eax),%edx
  801435:	89 55 08             	mov    %edx,0x8(%ebp)
  801438:	8b 55 0c             	mov    0xc(%ebp),%edx
  80143b:	8d 4a 01             	lea    0x1(%edx),%ecx
  80143e:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  801441:	8a 12                	mov    (%edx),%dl
  801443:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  801445:	ff 4d 10             	decl   0x10(%ebp)
  801448:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80144c:	74 09                	je     801457 <strlcpy+0x3c>
  80144e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801451:	8a 00                	mov    (%eax),%al
  801453:	84 c0                	test   %al,%al
  801455:	75 d8                	jne    80142f <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  801457:	8b 45 08             	mov    0x8(%ebp),%eax
  80145a:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  80145d:	8b 55 08             	mov    0x8(%ebp),%edx
  801460:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801463:	29 c2                	sub    %eax,%edx
  801465:	89 d0                	mov    %edx,%eax
}
  801467:	c9                   	leave  
  801468:	c3                   	ret    

00801469 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  801469:	55                   	push   %ebp
  80146a:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  80146c:	eb 06                	jmp    801474 <strcmp+0xb>
		p++, q++;
  80146e:	ff 45 08             	incl   0x8(%ebp)
  801471:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  801474:	8b 45 08             	mov    0x8(%ebp),%eax
  801477:	8a 00                	mov    (%eax),%al
  801479:	84 c0                	test   %al,%al
  80147b:	74 0e                	je     80148b <strcmp+0x22>
  80147d:	8b 45 08             	mov    0x8(%ebp),%eax
  801480:	8a 10                	mov    (%eax),%dl
  801482:	8b 45 0c             	mov    0xc(%ebp),%eax
  801485:	8a 00                	mov    (%eax),%al
  801487:	38 c2                	cmp    %al,%dl
  801489:	74 e3                	je     80146e <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  80148b:	8b 45 08             	mov    0x8(%ebp),%eax
  80148e:	8a 00                	mov    (%eax),%al
  801490:	0f b6 d0             	movzbl %al,%edx
  801493:	8b 45 0c             	mov    0xc(%ebp),%eax
  801496:	8a 00                	mov    (%eax),%al
  801498:	0f b6 c0             	movzbl %al,%eax
  80149b:	29 c2                	sub    %eax,%edx
  80149d:	89 d0                	mov    %edx,%eax
}
  80149f:	5d                   	pop    %ebp
  8014a0:	c3                   	ret    

008014a1 <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  8014a1:	55                   	push   %ebp
  8014a2:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  8014a4:	eb 09                	jmp    8014af <strncmp+0xe>
		n--, p++, q++;
  8014a6:	ff 4d 10             	decl   0x10(%ebp)
  8014a9:	ff 45 08             	incl   0x8(%ebp)
  8014ac:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  8014af:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8014b3:	74 17                	je     8014cc <strncmp+0x2b>
  8014b5:	8b 45 08             	mov    0x8(%ebp),%eax
  8014b8:	8a 00                	mov    (%eax),%al
  8014ba:	84 c0                	test   %al,%al
  8014bc:	74 0e                	je     8014cc <strncmp+0x2b>
  8014be:	8b 45 08             	mov    0x8(%ebp),%eax
  8014c1:	8a 10                	mov    (%eax),%dl
  8014c3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8014c6:	8a 00                	mov    (%eax),%al
  8014c8:	38 c2                	cmp    %al,%dl
  8014ca:	74 da                	je     8014a6 <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  8014cc:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8014d0:	75 07                	jne    8014d9 <strncmp+0x38>
		return 0;
  8014d2:	b8 00 00 00 00       	mov    $0x0,%eax
  8014d7:	eb 14                	jmp    8014ed <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  8014d9:	8b 45 08             	mov    0x8(%ebp),%eax
  8014dc:	8a 00                	mov    (%eax),%al
  8014de:	0f b6 d0             	movzbl %al,%edx
  8014e1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8014e4:	8a 00                	mov    (%eax),%al
  8014e6:	0f b6 c0             	movzbl %al,%eax
  8014e9:	29 c2                	sub    %eax,%edx
  8014eb:	89 d0                	mov    %edx,%eax
}
  8014ed:	5d                   	pop    %ebp
  8014ee:	c3                   	ret    

008014ef <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  8014ef:	55                   	push   %ebp
  8014f0:	89 e5                	mov    %esp,%ebp
  8014f2:	83 ec 04             	sub    $0x4,%esp
  8014f5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8014f8:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  8014fb:	eb 12                	jmp    80150f <strchr+0x20>
		if (*s == c)
  8014fd:	8b 45 08             	mov    0x8(%ebp),%eax
  801500:	8a 00                	mov    (%eax),%al
  801502:	3a 45 fc             	cmp    -0x4(%ebp),%al
  801505:	75 05                	jne    80150c <strchr+0x1d>
			return (char *) s;
  801507:	8b 45 08             	mov    0x8(%ebp),%eax
  80150a:	eb 11                	jmp    80151d <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  80150c:	ff 45 08             	incl   0x8(%ebp)
  80150f:	8b 45 08             	mov    0x8(%ebp),%eax
  801512:	8a 00                	mov    (%eax),%al
  801514:	84 c0                	test   %al,%al
  801516:	75 e5                	jne    8014fd <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  801518:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80151d:	c9                   	leave  
  80151e:	c3                   	ret    

0080151f <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  80151f:	55                   	push   %ebp
  801520:	89 e5                	mov    %esp,%ebp
  801522:	83 ec 04             	sub    $0x4,%esp
  801525:	8b 45 0c             	mov    0xc(%ebp),%eax
  801528:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  80152b:	eb 0d                	jmp    80153a <strfind+0x1b>
		if (*s == c)
  80152d:	8b 45 08             	mov    0x8(%ebp),%eax
  801530:	8a 00                	mov    (%eax),%al
  801532:	3a 45 fc             	cmp    -0x4(%ebp),%al
  801535:	74 0e                	je     801545 <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  801537:	ff 45 08             	incl   0x8(%ebp)
  80153a:	8b 45 08             	mov    0x8(%ebp),%eax
  80153d:	8a 00                	mov    (%eax),%al
  80153f:	84 c0                	test   %al,%al
  801541:	75 ea                	jne    80152d <strfind+0xe>
  801543:	eb 01                	jmp    801546 <strfind+0x27>
		if (*s == c)
			break;
  801545:	90                   	nop
	return (char *) s;
  801546:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801549:	c9                   	leave  
  80154a:	c3                   	ret    

0080154b <memset>:


void *
memset(void *v, int c, uint32 n)
{
  80154b:	55                   	push   %ebp
  80154c:	89 e5                	mov    %esp,%ebp
  80154e:	83 ec 10             	sub    $0x10,%esp
	char *p;
	int m;

	p = v;
  801551:	8b 45 08             	mov    0x8(%ebp),%eax
  801554:	89 45 fc             	mov    %eax,-0x4(%ebp)
	m = n;
  801557:	8b 45 10             	mov    0x10(%ebp),%eax
  80155a:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (--m >= 0)
  80155d:	eb 0e                	jmp    80156d <memset+0x22>
		*p++ = c;
  80155f:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801562:	8d 50 01             	lea    0x1(%eax),%edx
  801565:	89 55 fc             	mov    %edx,-0x4(%ebp)
  801568:	8b 55 0c             	mov    0xc(%ebp),%edx
  80156b:	88 10                	mov    %dl,(%eax)
	char *p;
	int m;

	p = v;
	m = n;
	while (--m >= 0)
  80156d:	ff 4d f8             	decl   -0x8(%ebp)
  801570:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  801574:	79 e9                	jns    80155f <memset+0x14>
		*p++ = c;

	return v;
  801576:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801579:	c9                   	leave  
  80157a:	c3                   	ret    

0080157b <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  80157b:	55                   	push   %ebp
  80157c:	89 e5                	mov    %esp,%ebp
  80157e:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  801581:	8b 45 0c             	mov    0xc(%ebp),%eax
  801584:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  801587:	8b 45 08             	mov    0x8(%ebp),%eax
  80158a:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (n-- > 0)
  80158d:	eb 16                	jmp    8015a5 <memcpy+0x2a>
		*d++ = *s++;
  80158f:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801592:	8d 50 01             	lea    0x1(%eax),%edx
  801595:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801598:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80159b:	8d 4a 01             	lea    0x1(%edx),%ecx
  80159e:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  8015a1:	8a 12                	mov    (%edx),%dl
  8015a3:	88 10                	mov    %dl,(%eax)
	const char *s;
	char *d;

	s = src;
	d = dst;
	while (n-- > 0)
  8015a5:	8b 45 10             	mov    0x10(%ebp),%eax
  8015a8:	8d 50 ff             	lea    -0x1(%eax),%edx
  8015ab:	89 55 10             	mov    %edx,0x10(%ebp)
  8015ae:	85 c0                	test   %eax,%eax
  8015b0:	75 dd                	jne    80158f <memcpy+0x14>
		*d++ = *s++;

	return dst;
  8015b2:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8015b5:	c9                   	leave  
  8015b6:	c3                   	ret    

008015b7 <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  8015b7:	55                   	push   %ebp
  8015b8:	89 e5                	mov    %esp,%ebp
  8015ba:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  8015bd:	8b 45 0c             	mov    0xc(%ebp),%eax
  8015c0:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  8015c3:	8b 45 08             	mov    0x8(%ebp),%eax
  8015c6:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  8015c9:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8015cc:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  8015cf:	73 50                	jae    801621 <memmove+0x6a>
  8015d1:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8015d4:	8b 45 10             	mov    0x10(%ebp),%eax
  8015d7:	01 d0                	add    %edx,%eax
  8015d9:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  8015dc:	76 43                	jbe    801621 <memmove+0x6a>
		s += n;
  8015de:	8b 45 10             	mov    0x10(%ebp),%eax
  8015e1:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  8015e4:	8b 45 10             	mov    0x10(%ebp),%eax
  8015e7:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  8015ea:	eb 10                	jmp    8015fc <memmove+0x45>
			*--d = *--s;
  8015ec:	ff 4d f8             	decl   -0x8(%ebp)
  8015ef:	ff 4d fc             	decl   -0x4(%ebp)
  8015f2:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8015f5:	8a 10                	mov    (%eax),%dl
  8015f7:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8015fa:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  8015fc:	8b 45 10             	mov    0x10(%ebp),%eax
  8015ff:	8d 50 ff             	lea    -0x1(%eax),%edx
  801602:	89 55 10             	mov    %edx,0x10(%ebp)
  801605:	85 c0                	test   %eax,%eax
  801607:	75 e3                	jne    8015ec <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  801609:	eb 23                	jmp    80162e <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  80160b:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80160e:	8d 50 01             	lea    0x1(%eax),%edx
  801611:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801614:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801617:	8d 4a 01             	lea    0x1(%edx),%ecx
  80161a:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  80161d:	8a 12                	mov    (%edx),%dl
  80161f:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  801621:	8b 45 10             	mov    0x10(%ebp),%eax
  801624:	8d 50 ff             	lea    -0x1(%eax),%edx
  801627:	89 55 10             	mov    %edx,0x10(%ebp)
  80162a:	85 c0                	test   %eax,%eax
  80162c:	75 dd                	jne    80160b <memmove+0x54>
			*d++ = *s++;

	return dst;
  80162e:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801631:	c9                   	leave  
  801632:	c3                   	ret    

00801633 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  801633:	55                   	push   %ebp
  801634:	89 e5                	mov    %esp,%ebp
  801636:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  801639:	8b 45 08             	mov    0x8(%ebp),%eax
  80163c:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  80163f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801642:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  801645:	eb 2a                	jmp    801671 <memcmp+0x3e>
		if (*s1 != *s2)
  801647:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80164a:	8a 10                	mov    (%eax),%dl
  80164c:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80164f:	8a 00                	mov    (%eax),%al
  801651:	38 c2                	cmp    %al,%dl
  801653:	74 16                	je     80166b <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  801655:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801658:	8a 00                	mov    (%eax),%al
  80165a:	0f b6 d0             	movzbl %al,%edx
  80165d:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801660:	8a 00                	mov    (%eax),%al
  801662:	0f b6 c0             	movzbl %al,%eax
  801665:	29 c2                	sub    %eax,%edx
  801667:	89 d0                	mov    %edx,%eax
  801669:	eb 18                	jmp    801683 <memcmp+0x50>
		s1++, s2++;
  80166b:	ff 45 fc             	incl   -0x4(%ebp)
  80166e:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  801671:	8b 45 10             	mov    0x10(%ebp),%eax
  801674:	8d 50 ff             	lea    -0x1(%eax),%edx
  801677:	89 55 10             	mov    %edx,0x10(%ebp)
  80167a:	85 c0                	test   %eax,%eax
  80167c:	75 c9                	jne    801647 <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  80167e:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801683:	c9                   	leave  
  801684:	c3                   	ret    

00801685 <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  801685:	55                   	push   %ebp
  801686:	89 e5                	mov    %esp,%ebp
  801688:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  80168b:	8b 55 08             	mov    0x8(%ebp),%edx
  80168e:	8b 45 10             	mov    0x10(%ebp),%eax
  801691:	01 d0                	add    %edx,%eax
  801693:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  801696:	eb 15                	jmp    8016ad <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  801698:	8b 45 08             	mov    0x8(%ebp),%eax
  80169b:	8a 00                	mov    (%eax),%al
  80169d:	0f b6 d0             	movzbl %al,%edx
  8016a0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8016a3:	0f b6 c0             	movzbl %al,%eax
  8016a6:	39 c2                	cmp    %eax,%edx
  8016a8:	74 0d                	je     8016b7 <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  8016aa:	ff 45 08             	incl   0x8(%ebp)
  8016ad:	8b 45 08             	mov    0x8(%ebp),%eax
  8016b0:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  8016b3:	72 e3                	jb     801698 <memfind+0x13>
  8016b5:	eb 01                	jmp    8016b8 <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  8016b7:	90                   	nop
	return (void *) s;
  8016b8:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8016bb:	c9                   	leave  
  8016bc:	c3                   	ret    

008016bd <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  8016bd:	55                   	push   %ebp
  8016be:	89 e5                	mov    %esp,%ebp
  8016c0:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  8016c3:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  8016ca:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  8016d1:	eb 03                	jmp    8016d6 <strtol+0x19>
		s++;
  8016d3:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  8016d6:	8b 45 08             	mov    0x8(%ebp),%eax
  8016d9:	8a 00                	mov    (%eax),%al
  8016db:	3c 20                	cmp    $0x20,%al
  8016dd:	74 f4                	je     8016d3 <strtol+0x16>
  8016df:	8b 45 08             	mov    0x8(%ebp),%eax
  8016e2:	8a 00                	mov    (%eax),%al
  8016e4:	3c 09                	cmp    $0x9,%al
  8016e6:	74 eb                	je     8016d3 <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  8016e8:	8b 45 08             	mov    0x8(%ebp),%eax
  8016eb:	8a 00                	mov    (%eax),%al
  8016ed:	3c 2b                	cmp    $0x2b,%al
  8016ef:	75 05                	jne    8016f6 <strtol+0x39>
		s++;
  8016f1:	ff 45 08             	incl   0x8(%ebp)
  8016f4:	eb 13                	jmp    801709 <strtol+0x4c>
	else if (*s == '-')
  8016f6:	8b 45 08             	mov    0x8(%ebp),%eax
  8016f9:	8a 00                	mov    (%eax),%al
  8016fb:	3c 2d                	cmp    $0x2d,%al
  8016fd:	75 0a                	jne    801709 <strtol+0x4c>
		s++, neg = 1;
  8016ff:	ff 45 08             	incl   0x8(%ebp)
  801702:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  801709:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80170d:	74 06                	je     801715 <strtol+0x58>
  80170f:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  801713:	75 20                	jne    801735 <strtol+0x78>
  801715:	8b 45 08             	mov    0x8(%ebp),%eax
  801718:	8a 00                	mov    (%eax),%al
  80171a:	3c 30                	cmp    $0x30,%al
  80171c:	75 17                	jne    801735 <strtol+0x78>
  80171e:	8b 45 08             	mov    0x8(%ebp),%eax
  801721:	40                   	inc    %eax
  801722:	8a 00                	mov    (%eax),%al
  801724:	3c 78                	cmp    $0x78,%al
  801726:	75 0d                	jne    801735 <strtol+0x78>
		s += 2, base = 16;
  801728:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  80172c:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  801733:	eb 28                	jmp    80175d <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  801735:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801739:	75 15                	jne    801750 <strtol+0x93>
  80173b:	8b 45 08             	mov    0x8(%ebp),%eax
  80173e:	8a 00                	mov    (%eax),%al
  801740:	3c 30                	cmp    $0x30,%al
  801742:	75 0c                	jne    801750 <strtol+0x93>
		s++, base = 8;
  801744:	ff 45 08             	incl   0x8(%ebp)
  801747:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  80174e:	eb 0d                	jmp    80175d <strtol+0xa0>
	else if (base == 0)
  801750:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801754:	75 07                	jne    80175d <strtol+0xa0>
		base = 10;
  801756:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  80175d:	8b 45 08             	mov    0x8(%ebp),%eax
  801760:	8a 00                	mov    (%eax),%al
  801762:	3c 2f                	cmp    $0x2f,%al
  801764:	7e 19                	jle    80177f <strtol+0xc2>
  801766:	8b 45 08             	mov    0x8(%ebp),%eax
  801769:	8a 00                	mov    (%eax),%al
  80176b:	3c 39                	cmp    $0x39,%al
  80176d:	7f 10                	jg     80177f <strtol+0xc2>
			dig = *s - '0';
  80176f:	8b 45 08             	mov    0x8(%ebp),%eax
  801772:	8a 00                	mov    (%eax),%al
  801774:	0f be c0             	movsbl %al,%eax
  801777:	83 e8 30             	sub    $0x30,%eax
  80177a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80177d:	eb 42                	jmp    8017c1 <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  80177f:	8b 45 08             	mov    0x8(%ebp),%eax
  801782:	8a 00                	mov    (%eax),%al
  801784:	3c 60                	cmp    $0x60,%al
  801786:	7e 19                	jle    8017a1 <strtol+0xe4>
  801788:	8b 45 08             	mov    0x8(%ebp),%eax
  80178b:	8a 00                	mov    (%eax),%al
  80178d:	3c 7a                	cmp    $0x7a,%al
  80178f:	7f 10                	jg     8017a1 <strtol+0xe4>
			dig = *s - 'a' + 10;
  801791:	8b 45 08             	mov    0x8(%ebp),%eax
  801794:	8a 00                	mov    (%eax),%al
  801796:	0f be c0             	movsbl %al,%eax
  801799:	83 e8 57             	sub    $0x57,%eax
  80179c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80179f:	eb 20                	jmp    8017c1 <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  8017a1:	8b 45 08             	mov    0x8(%ebp),%eax
  8017a4:	8a 00                	mov    (%eax),%al
  8017a6:	3c 40                	cmp    $0x40,%al
  8017a8:	7e 39                	jle    8017e3 <strtol+0x126>
  8017aa:	8b 45 08             	mov    0x8(%ebp),%eax
  8017ad:	8a 00                	mov    (%eax),%al
  8017af:	3c 5a                	cmp    $0x5a,%al
  8017b1:	7f 30                	jg     8017e3 <strtol+0x126>
			dig = *s - 'A' + 10;
  8017b3:	8b 45 08             	mov    0x8(%ebp),%eax
  8017b6:	8a 00                	mov    (%eax),%al
  8017b8:	0f be c0             	movsbl %al,%eax
  8017bb:	83 e8 37             	sub    $0x37,%eax
  8017be:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  8017c1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8017c4:	3b 45 10             	cmp    0x10(%ebp),%eax
  8017c7:	7d 19                	jge    8017e2 <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  8017c9:	ff 45 08             	incl   0x8(%ebp)
  8017cc:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8017cf:	0f af 45 10          	imul   0x10(%ebp),%eax
  8017d3:	89 c2                	mov    %eax,%edx
  8017d5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8017d8:	01 d0                	add    %edx,%eax
  8017da:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  8017dd:	e9 7b ff ff ff       	jmp    80175d <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  8017e2:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  8017e3:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8017e7:	74 08                	je     8017f1 <strtol+0x134>
		*endptr = (char *) s;
  8017e9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8017ec:	8b 55 08             	mov    0x8(%ebp),%edx
  8017ef:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  8017f1:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8017f5:	74 07                	je     8017fe <strtol+0x141>
  8017f7:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8017fa:	f7 d8                	neg    %eax
  8017fc:	eb 03                	jmp    801801 <strtol+0x144>
  8017fe:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  801801:	c9                   	leave  
  801802:	c3                   	ret    

00801803 <ltostr>:

void
ltostr(long value, char *str)
{
  801803:	55                   	push   %ebp
  801804:	89 e5                	mov    %esp,%ebp
  801806:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  801809:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  801810:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  801817:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80181b:	79 13                	jns    801830 <ltostr+0x2d>
	{
		neg = 1;
  80181d:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  801824:	8b 45 0c             	mov    0xc(%ebp),%eax
  801827:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  80182a:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  80182d:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  801830:	8b 45 08             	mov    0x8(%ebp),%eax
  801833:	b9 0a 00 00 00       	mov    $0xa,%ecx
  801838:	99                   	cltd   
  801839:	f7 f9                	idiv   %ecx
  80183b:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  80183e:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801841:	8d 50 01             	lea    0x1(%eax),%edx
  801844:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801847:	89 c2                	mov    %eax,%edx
  801849:	8b 45 0c             	mov    0xc(%ebp),%eax
  80184c:	01 d0                	add    %edx,%eax
  80184e:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801851:	83 c2 30             	add    $0x30,%edx
  801854:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  801856:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801859:	b8 67 66 66 66       	mov    $0x66666667,%eax
  80185e:	f7 e9                	imul   %ecx
  801860:	c1 fa 02             	sar    $0x2,%edx
  801863:	89 c8                	mov    %ecx,%eax
  801865:	c1 f8 1f             	sar    $0x1f,%eax
  801868:	29 c2                	sub    %eax,%edx
  80186a:	89 d0                	mov    %edx,%eax
  80186c:	89 45 08             	mov    %eax,0x8(%ebp)
	} while (value % 10 != 0);
  80186f:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801872:	b8 67 66 66 66       	mov    $0x66666667,%eax
  801877:	f7 e9                	imul   %ecx
  801879:	c1 fa 02             	sar    $0x2,%edx
  80187c:	89 c8                	mov    %ecx,%eax
  80187e:	c1 f8 1f             	sar    $0x1f,%eax
  801881:	29 c2                	sub    %eax,%edx
  801883:	89 d0                	mov    %edx,%eax
  801885:	c1 e0 02             	shl    $0x2,%eax
  801888:	01 d0                	add    %edx,%eax
  80188a:	01 c0                	add    %eax,%eax
  80188c:	29 c1                	sub    %eax,%ecx
  80188e:	89 ca                	mov    %ecx,%edx
  801890:	85 d2                	test   %edx,%edx
  801892:	75 9c                	jne    801830 <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  801894:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  80189b:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80189e:	48                   	dec    %eax
  80189f:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  8018a2:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8018a6:	74 3d                	je     8018e5 <ltostr+0xe2>
		start = 1 ;
  8018a8:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  8018af:	eb 34                	jmp    8018e5 <ltostr+0xe2>
	{
		char tmp = str[start] ;
  8018b1:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8018b4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8018b7:	01 d0                	add    %edx,%eax
  8018b9:	8a 00                	mov    (%eax),%al
  8018bb:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  8018be:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8018c1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8018c4:	01 c2                	add    %eax,%edx
  8018c6:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  8018c9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8018cc:	01 c8                	add    %ecx,%eax
  8018ce:	8a 00                	mov    (%eax),%al
  8018d0:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  8018d2:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8018d5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8018d8:	01 c2                	add    %eax,%edx
  8018da:	8a 45 eb             	mov    -0x15(%ebp),%al
  8018dd:	88 02                	mov    %al,(%edx)
		start++ ;
  8018df:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  8018e2:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  8018e5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8018e8:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8018eb:	7c c4                	jl     8018b1 <ltostr+0xae>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  8018ed:	8b 55 f8             	mov    -0x8(%ebp),%edx
  8018f0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8018f3:	01 d0                	add    %edx,%eax
  8018f5:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  8018f8:	90                   	nop
  8018f9:	c9                   	leave  
  8018fa:	c3                   	ret    

008018fb <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  8018fb:	55                   	push   %ebp
  8018fc:	89 e5                	mov    %esp,%ebp
  8018fe:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  801901:	ff 75 08             	pushl  0x8(%ebp)
  801904:	e8 54 fa ff ff       	call   80135d <strlen>
  801909:	83 c4 04             	add    $0x4,%esp
  80190c:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  80190f:	ff 75 0c             	pushl  0xc(%ebp)
  801912:	e8 46 fa ff ff       	call   80135d <strlen>
  801917:	83 c4 04             	add    $0x4,%esp
  80191a:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  80191d:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  801924:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  80192b:	eb 17                	jmp    801944 <strcconcat+0x49>
		final[s] = str1[s] ;
  80192d:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801930:	8b 45 10             	mov    0x10(%ebp),%eax
  801933:	01 c2                	add    %eax,%edx
  801935:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  801938:	8b 45 08             	mov    0x8(%ebp),%eax
  80193b:	01 c8                	add    %ecx,%eax
  80193d:	8a 00                	mov    (%eax),%al
  80193f:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  801941:	ff 45 fc             	incl   -0x4(%ebp)
  801944:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801947:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  80194a:	7c e1                	jl     80192d <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  80194c:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  801953:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  80195a:	eb 1f                	jmp    80197b <strcconcat+0x80>
		final[s++] = str2[i] ;
  80195c:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80195f:	8d 50 01             	lea    0x1(%eax),%edx
  801962:	89 55 fc             	mov    %edx,-0x4(%ebp)
  801965:	89 c2                	mov    %eax,%edx
  801967:	8b 45 10             	mov    0x10(%ebp),%eax
  80196a:	01 c2                	add    %eax,%edx
  80196c:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  80196f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801972:	01 c8                	add    %ecx,%eax
  801974:	8a 00                	mov    (%eax),%al
  801976:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  801978:	ff 45 f8             	incl   -0x8(%ebp)
  80197b:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80197e:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801981:	7c d9                	jl     80195c <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  801983:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801986:	8b 45 10             	mov    0x10(%ebp),%eax
  801989:	01 d0                	add    %edx,%eax
  80198b:	c6 00 00             	movb   $0x0,(%eax)
}
  80198e:	90                   	nop
  80198f:	c9                   	leave  
  801990:	c3                   	ret    

00801991 <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  801991:	55                   	push   %ebp
  801992:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  801994:	8b 45 14             	mov    0x14(%ebp),%eax
  801997:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  80199d:	8b 45 14             	mov    0x14(%ebp),%eax
  8019a0:	8b 00                	mov    (%eax),%eax
  8019a2:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8019a9:	8b 45 10             	mov    0x10(%ebp),%eax
  8019ac:	01 d0                	add    %edx,%eax
  8019ae:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  8019b4:	eb 0c                	jmp    8019c2 <strsplit+0x31>
			*string++ = 0;
  8019b6:	8b 45 08             	mov    0x8(%ebp),%eax
  8019b9:	8d 50 01             	lea    0x1(%eax),%edx
  8019bc:	89 55 08             	mov    %edx,0x8(%ebp)
  8019bf:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  8019c2:	8b 45 08             	mov    0x8(%ebp),%eax
  8019c5:	8a 00                	mov    (%eax),%al
  8019c7:	84 c0                	test   %al,%al
  8019c9:	74 18                	je     8019e3 <strsplit+0x52>
  8019cb:	8b 45 08             	mov    0x8(%ebp),%eax
  8019ce:	8a 00                	mov    (%eax),%al
  8019d0:	0f be c0             	movsbl %al,%eax
  8019d3:	50                   	push   %eax
  8019d4:	ff 75 0c             	pushl  0xc(%ebp)
  8019d7:	e8 13 fb ff ff       	call   8014ef <strchr>
  8019dc:	83 c4 08             	add    $0x8,%esp
  8019df:	85 c0                	test   %eax,%eax
  8019e1:	75 d3                	jne    8019b6 <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  8019e3:	8b 45 08             	mov    0x8(%ebp),%eax
  8019e6:	8a 00                	mov    (%eax),%al
  8019e8:	84 c0                	test   %al,%al
  8019ea:	74 5a                	je     801a46 <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  8019ec:	8b 45 14             	mov    0x14(%ebp),%eax
  8019ef:	8b 00                	mov    (%eax),%eax
  8019f1:	83 f8 0f             	cmp    $0xf,%eax
  8019f4:	75 07                	jne    8019fd <strsplit+0x6c>
		{
			return 0;
  8019f6:	b8 00 00 00 00       	mov    $0x0,%eax
  8019fb:	eb 66                	jmp    801a63 <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  8019fd:	8b 45 14             	mov    0x14(%ebp),%eax
  801a00:	8b 00                	mov    (%eax),%eax
  801a02:	8d 48 01             	lea    0x1(%eax),%ecx
  801a05:	8b 55 14             	mov    0x14(%ebp),%edx
  801a08:	89 0a                	mov    %ecx,(%edx)
  801a0a:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801a11:	8b 45 10             	mov    0x10(%ebp),%eax
  801a14:	01 c2                	add    %eax,%edx
  801a16:	8b 45 08             	mov    0x8(%ebp),%eax
  801a19:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  801a1b:	eb 03                	jmp    801a20 <strsplit+0x8f>
			string++;
  801a1d:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  801a20:	8b 45 08             	mov    0x8(%ebp),%eax
  801a23:	8a 00                	mov    (%eax),%al
  801a25:	84 c0                	test   %al,%al
  801a27:	74 8b                	je     8019b4 <strsplit+0x23>
  801a29:	8b 45 08             	mov    0x8(%ebp),%eax
  801a2c:	8a 00                	mov    (%eax),%al
  801a2e:	0f be c0             	movsbl %al,%eax
  801a31:	50                   	push   %eax
  801a32:	ff 75 0c             	pushl  0xc(%ebp)
  801a35:	e8 b5 fa ff ff       	call   8014ef <strchr>
  801a3a:	83 c4 08             	add    $0x8,%esp
  801a3d:	85 c0                	test   %eax,%eax
  801a3f:	74 dc                	je     801a1d <strsplit+0x8c>
			string++;
	}
  801a41:	e9 6e ff ff ff       	jmp    8019b4 <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  801a46:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  801a47:	8b 45 14             	mov    0x14(%ebp),%eax
  801a4a:	8b 00                	mov    (%eax),%eax
  801a4c:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801a53:	8b 45 10             	mov    0x10(%ebp),%eax
  801a56:	01 d0                	add    %edx,%eax
  801a58:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  801a5e:	b8 01 00 00 00       	mov    $0x1,%eax
}
  801a63:	c9                   	leave  
  801a64:	c3                   	ret    

00801a65 <InitializeUHeap>:
//============================== GIVEN FUNCTIONS ===================================//
//==================================================================================//

int FirstTimeFlag = 1;
void InitializeUHeap()
{
  801a65:	55                   	push   %ebp
  801a66:	89 e5                	mov    %esp,%ebp
  801a68:	83 ec 08             	sub    $0x8,%esp
	if(FirstTimeFlag)
  801a6b:	a1 04 50 80 00       	mov    0x805004,%eax
  801a70:	85 c0                	test   %eax,%eax
  801a72:	74 1f                	je     801a93 <InitializeUHeap+0x2e>
	{
		initialize_dyn_block_system();
  801a74:	e8 1d 00 00 00       	call   801a96 <initialize_dyn_block_system>
		cprintf("DYNAMIC BLOCK SYSTEM IS INITIALIZED\n");
  801a79:	83 ec 0c             	sub    $0xc,%esp
  801a7c:	68 90 3f 80 00       	push   $0x803f90
  801a81:	e8 55 f2 ff ff       	call   800cdb <cprintf>
  801a86:	83 c4 10             	add    $0x10,%esp
#if UHP_USE_BUDDY
		initialize_buddy();
		cprintf("BUDDY SYSTEM IS INITIALIZED\n");
#endif
		FirstTimeFlag = 0;
  801a89:	c7 05 04 50 80 00 00 	movl   $0x0,0x805004
  801a90:	00 00 00 
	}
}
  801a93:	90                   	nop
  801a94:	c9                   	leave  
  801a95:	c3                   	ret    

00801a96 <initialize_dyn_block_system>:

//=================================
// [1] INITIALIZE DYNAMIC ALLOCATOR:
//=================================
void initialize_dyn_block_system()
{
  801a96:	55                   	push   %ebp
  801a97:	89 e5                	mov    %esp,%ebp
  801a99:	83 ec 28             	sub    $0x28,%esp
	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] initialize_dyn_block_system
	// your code is here, remove the panic and write your code
	//panic("initialize_dyn_block_system() is not implemented yet...!!");

	LIST_INIT(&AllocMemBlocksList);
  801a9c:	c7 05 40 50 80 00 00 	movl   $0x0,0x805040
  801aa3:	00 00 00 
  801aa6:	c7 05 44 50 80 00 00 	movl   $0x0,0x805044
  801aad:	00 00 00 
  801ab0:	c7 05 4c 50 80 00 00 	movl   $0x0,0x80504c
  801ab7:	00 00 00 
	LIST_INIT(&FreeMemBlocksList);
  801aba:	c7 05 38 51 80 00 00 	movl   $0x0,0x805138
  801ac1:	00 00 00 
  801ac4:	c7 05 3c 51 80 00 00 	movl   $0x0,0x80513c
  801acb:	00 00 00 
  801ace:	c7 05 44 51 80 00 00 	movl   $0x0,0x805144
  801ad5:	00 00 00 
	MAX_MEM_BLOCK_CNT = NUM_OF_UHEAP_PAGES;
  801ad8:	c7 05 20 51 80 00 00 	movl   $0x20000,0x805120
  801adf:	00 02 00 
	MemBlockNodes = (void*)USER_DYN_BLKS_ARRAY;
  801ae2:	c7 45 f4 00 00 e0 7f 	movl   $0x7fe00000,-0xc(%ebp)
  801ae9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801aec:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801af1:	2d 00 10 00 00       	sub    $0x1000,%eax
  801af6:	a3 50 50 80 00       	mov    %eax,0x805050
	int size_of_block = sizeof(struct MemBlock);
  801afb:	c7 45 f0 10 00 00 00 	movl   $0x10,-0x10(%ebp)
	int size_all_struct = size_of_block*MAX_MEM_BLOCK_CNT;
  801b02:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801b05:	a1 20 51 80 00       	mov    0x805120,%eax
  801b0a:	0f af c2             	imul   %edx,%eax
  801b0d:	89 45 ec             	mov    %eax,-0x14(%ebp)
	size_all_struct = ROUNDUP(size_all_struct, PAGE_SIZE);
  801b10:	c7 45 e8 00 10 00 00 	movl   $0x1000,-0x18(%ebp)
  801b17:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801b1a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801b1d:	01 d0                	add    %edx,%eax
  801b1f:	48                   	dec    %eax
  801b20:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  801b23:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801b26:	ba 00 00 00 00       	mov    $0x0,%edx
  801b2b:	f7 75 e8             	divl   -0x18(%ebp)
  801b2e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801b31:	29 d0                	sub    %edx,%eax
  801b33:	89 45 ec             	mov    %eax,-0x14(%ebp)
	sys_allocate_chunk(USER_DYN_BLKS_ARRAY, size_all_struct,PERM_USER| PERM_WRITEABLE);
  801b36:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801b39:	c7 45 e0 00 00 e0 7f 	movl   $0x7fe00000,-0x20(%ebp)
  801b40:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801b43:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
  801b49:	81 ea 00 10 00 00    	sub    $0x1000,%edx
  801b4f:	83 ec 04             	sub    $0x4,%esp
  801b52:	6a 06                	push   $0x6
  801b54:	50                   	push   %eax
  801b55:	52                   	push   %edx
  801b56:	e8 a1 05 00 00       	call   8020fc <sys_allocate_chunk>
  801b5b:	83 c4 10             	add    $0x10,%esp
	initialize_MemBlocksList(MAX_MEM_BLOCK_CNT);
  801b5e:	a1 20 51 80 00       	mov    0x805120,%eax
  801b63:	83 ec 0c             	sub    $0xc,%esp
  801b66:	50                   	push   %eax
  801b67:	e8 16 0c 00 00       	call   802782 <initialize_MemBlocksList>
  801b6c:	83 c4 10             	add    $0x10,%esp
	struct MemBlock* ourBlock =LIST_LAST(&AvailableMemBlocksList);
  801b6f:	a1 4c 51 80 00       	mov    0x80514c,%eax
  801b74:	89 45 dc             	mov    %eax,-0x24(%ebp)
	LIST_REMOVE(&AvailableMemBlocksList,ourBlock);
  801b77:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  801b7b:	75 14                	jne    801b91 <initialize_dyn_block_system+0xfb>
  801b7d:	83 ec 04             	sub    $0x4,%esp
  801b80:	68 b5 3f 80 00       	push   $0x803fb5
  801b85:	6a 2d                	push   $0x2d
  801b87:	68 d3 3f 80 00       	push   $0x803fd3
  801b8c:	e8 96 ee ff ff       	call   800a27 <_panic>
  801b91:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801b94:	8b 00                	mov    (%eax),%eax
  801b96:	85 c0                	test   %eax,%eax
  801b98:	74 10                	je     801baa <initialize_dyn_block_system+0x114>
  801b9a:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801b9d:	8b 00                	mov    (%eax),%eax
  801b9f:	8b 55 dc             	mov    -0x24(%ebp),%edx
  801ba2:	8b 52 04             	mov    0x4(%edx),%edx
  801ba5:	89 50 04             	mov    %edx,0x4(%eax)
  801ba8:	eb 0b                	jmp    801bb5 <initialize_dyn_block_system+0x11f>
  801baa:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801bad:	8b 40 04             	mov    0x4(%eax),%eax
  801bb0:	a3 4c 51 80 00       	mov    %eax,0x80514c
  801bb5:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801bb8:	8b 40 04             	mov    0x4(%eax),%eax
  801bbb:	85 c0                	test   %eax,%eax
  801bbd:	74 0f                	je     801bce <initialize_dyn_block_system+0x138>
  801bbf:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801bc2:	8b 40 04             	mov    0x4(%eax),%eax
  801bc5:	8b 55 dc             	mov    -0x24(%ebp),%edx
  801bc8:	8b 12                	mov    (%edx),%edx
  801bca:	89 10                	mov    %edx,(%eax)
  801bcc:	eb 0a                	jmp    801bd8 <initialize_dyn_block_system+0x142>
  801bce:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801bd1:	8b 00                	mov    (%eax),%eax
  801bd3:	a3 48 51 80 00       	mov    %eax,0x805148
  801bd8:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801bdb:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  801be1:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801be4:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  801beb:	a1 54 51 80 00       	mov    0x805154,%eax
  801bf0:	48                   	dec    %eax
  801bf1:	a3 54 51 80 00       	mov    %eax,0x805154
	ourBlock->size = USER_HEAP_MAX-USER_HEAP_START;
  801bf6:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801bf9:	c7 40 0c 00 00 00 20 	movl   $0x20000000,0xc(%eax)
	ourBlock->sva=USER_HEAP_START;
  801c00:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801c03:	c7 40 08 00 00 00 80 	movl   $0x80000000,0x8(%eax)
	LIST_INSERT_TAIL(&FreeMemBlocksList, ourBlock);
  801c0a:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  801c0e:	75 14                	jne    801c24 <initialize_dyn_block_system+0x18e>
  801c10:	83 ec 04             	sub    $0x4,%esp
  801c13:	68 e0 3f 80 00       	push   $0x803fe0
  801c18:	6a 30                	push   $0x30
  801c1a:	68 d3 3f 80 00       	push   $0x803fd3
  801c1f:	e8 03 ee ff ff       	call   800a27 <_panic>
  801c24:	8b 15 3c 51 80 00    	mov    0x80513c,%edx
  801c2a:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801c2d:	89 50 04             	mov    %edx,0x4(%eax)
  801c30:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801c33:	8b 40 04             	mov    0x4(%eax),%eax
  801c36:	85 c0                	test   %eax,%eax
  801c38:	74 0c                	je     801c46 <initialize_dyn_block_system+0x1b0>
  801c3a:	a1 3c 51 80 00       	mov    0x80513c,%eax
  801c3f:	8b 55 dc             	mov    -0x24(%ebp),%edx
  801c42:	89 10                	mov    %edx,(%eax)
  801c44:	eb 08                	jmp    801c4e <initialize_dyn_block_system+0x1b8>
  801c46:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801c49:	a3 38 51 80 00       	mov    %eax,0x805138
  801c4e:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801c51:	a3 3c 51 80 00       	mov    %eax,0x80513c
  801c56:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801c59:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  801c5f:	a1 44 51 80 00       	mov    0x805144,%eax
  801c64:	40                   	inc    %eax
  801c65:	a3 44 51 80 00       	mov    %eax,0x805144
	//[1] Initialize two lists (AllocMemBlocksList & FreeMemBlocksList) [Hint: use LIST_INIT()]
	//[2] Dynamically allocate the array of MemBlockNodes at VA USER_DYN_BLKS_ARRAY
	//	  (remember to set MAX_MEM_BLOCK_CNT with the chosen size of the array)
	//[3] Initialize AvailableMemBlocksList by filling it with the MemBlockNodes
	//[4] Insert a new MemBlock with the heap size into the FreeMemBlocksList
}
  801c6a:	90                   	nop
  801c6b:	c9                   	leave  
  801c6c:	c3                   	ret    

00801c6d <malloc>:
//=================================
// [2] ALLOCATE SPACE IN USER HEAP:
//=================================

void* malloc(uint32 size)
{
  801c6d:	55                   	push   %ebp
  801c6e:	89 e5                	mov    %esp,%ebp
  801c70:	83 ec 18             	sub    $0x18,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801c73:	e8 ed fd ff ff       	call   801a65 <InitializeUHeap>
	if (size == 0) return NULL ;
  801c78:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801c7c:	75 07                	jne    801c85 <malloc+0x18>
  801c7e:	b8 00 00 00 00       	mov    $0x0,%eax
  801c83:	eb 67                	jmp    801cec <malloc+0x7f>

	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] malloc
	// your code is here, remove the panic and write your code
	//panic("malloc() is not implemented yet...!!");

	size = ROUNDUP(size, PAGE_SIZE);
  801c85:	c7 45 f4 00 10 00 00 	movl   $0x1000,-0xc(%ebp)
  801c8c:	8b 55 08             	mov    0x8(%ebp),%edx
  801c8f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801c92:	01 d0                	add    %edx,%eax
  801c94:	48                   	dec    %eax
  801c95:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801c98:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801c9b:	ba 00 00 00 00       	mov    $0x0,%edx
  801ca0:	f7 75 f4             	divl   -0xc(%ebp)
  801ca3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801ca6:	29 d0                	sub    %edx,%eax
  801ca8:	89 45 08             	mov    %eax,0x8(%ebp)
	if(sys_isUHeapPlacementStrategyFIRSTFIT())
  801cab:	e8 1a 08 00 00       	call   8024ca <sys_isUHeapPlacementStrategyFIRSTFIT>
  801cb0:	85 c0                	test   %eax,%eax
  801cb2:	74 33                	je     801ce7 <malloc+0x7a>
	{
		struct MemBlock * myBlock = alloc_block_FF(size);
  801cb4:	83 ec 0c             	sub    $0xc,%esp
  801cb7:	ff 75 08             	pushl  0x8(%ebp)
  801cba:	e8 0c 0e 00 00       	call   802acb <alloc_block_FF>
  801cbf:	83 c4 10             	add    $0x10,%esp
  801cc2:	89 45 ec             	mov    %eax,-0x14(%ebp)
		if(myBlock != NULL)
  801cc5:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  801cc9:	74 1c                	je     801ce7 <malloc+0x7a>
		{
			insert_sorted_allocList(myBlock);
  801ccb:	83 ec 0c             	sub    $0xc,%esp
  801cce:	ff 75 ec             	pushl  -0x14(%ebp)
  801cd1:	e8 07 0c 00 00       	call   8028dd <insert_sorted_allocList>
  801cd6:	83 c4 10             	add    $0x10,%esp
			uint32 ptr = myBlock->sva;
  801cd9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801cdc:	8b 40 08             	mov    0x8(%eax),%eax
  801cdf:	89 45 e8             	mov    %eax,-0x18(%ebp)
			return (void *)ptr;
  801ce2:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801ce5:	eb 05                	jmp    801cec <malloc+0x7f>
		}
	}
	return NULL;
  801ce7:	b8 00 00 00 00       	mov    $0x0,%eax
	//		to the required allocation size (space should be on 4 KB BOUNDARY)
	//	2) if no suitable space found, return NULL
	// 	3) Return pointer containing the virtual address of allocated space,
	//
	//Use sys_isUHeapPlacementStrategyFIRSTFIT()... to check the current strategy
}
  801cec:	c9                   	leave  
  801ced:	c3                   	ret    

00801cee <free>:
//	We can use sys_free_user_mem(uint32 virtual_address, uint32 size); which
//		switches to the kernel mode, calls free_user_mem() in
//		"kern/mem/chunk_operations.c", then switch back to the user mode here
//	the free_user_mem function is empty, make sure to implement it.
void free(void* virtual_address)
{
  801cee:	55                   	push   %ebp
  801cef:	89 e5                	mov    %esp,%ebp
  801cf1:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] free
	// your code is here, remove the panic and write your code
	//panic("free() is not implemented yet...!!");

	uint32 virtualAddress = (uint32 )(virtual_address);
  801cf4:	8b 45 08             	mov    0x8(%ebp),%eax
  801cf7:	89 45 f4             	mov    %eax,-0xc(%ebp)
//	virtualAddress = ROUNDDOWN(virtualAddress, PAGE_SIZE);
	struct MemBlock * myBlock = find_block(&AllocMemBlocksList, virtualAddress);
  801cfa:	83 ec 08             	sub    $0x8,%esp
  801cfd:	ff 75 f4             	pushl  -0xc(%ebp)
  801d00:	68 40 50 80 00       	push   $0x805040
  801d05:	e8 5b 0b 00 00       	call   802865 <find_block>
  801d0a:	83 c4 10             	add    $0x10,%esp
  801d0d:	89 45 f0             	mov    %eax,-0x10(%ebp)
//	cprintf ("ptr sva at free user side = %x \n", myBlock->sva);
	sys_free_user_mem(virtualAddress, myBlock->size);
  801d10:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801d13:	8b 40 0c             	mov    0xc(%eax),%eax
  801d16:	83 ec 08             	sub    $0x8,%esp
  801d19:	50                   	push   %eax
  801d1a:	ff 75 f4             	pushl  -0xc(%ebp)
  801d1d:	e8 a2 03 00 00       	call   8020c4 <sys_free_user_mem>
  801d22:	83 c4 10             	add    $0x10,%esp
	LIST_REMOVE(&AllocMemBlocksList, myBlock);
  801d25:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801d29:	75 14                	jne    801d3f <free+0x51>
  801d2b:	83 ec 04             	sub    $0x4,%esp
  801d2e:	68 b5 3f 80 00       	push   $0x803fb5
  801d33:	6a 76                	push   $0x76
  801d35:	68 d3 3f 80 00       	push   $0x803fd3
  801d3a:	e8 e8 ec ff ff       	call   800a27 <_panic>
  801d3f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801d42:	8b 00                	mov    (%eax),%eax
  801d44:	85 c0                	test   %eax,%eax
  801d46:	74 10                	je     801d58 <free+0x6a>
  801d48:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801d4b:	8b 00                	mov    (%eax),%eax
  801d4d:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801d50:	8b 52 04             	mov    0x4(%edx),%edx
  801d53:	89 50 04             	mov    %edx,0x4(%eax)
  801d56:	eb 0b                	jmp    801d63 <free+0x75>
  801d58:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801d5b:	8b 40 04             	mov    0x4(%eax),%eax
  801d5e:	a3 44 50 80 00       	mov    %eax,0x805044
  801d63:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801d66:	8b 40 04             	mov    0x4(%eax),%eax
  801d69:	85 c0                	test   %eax,%eax
  801d6b:	74 0f                	je     801d7c <free+0x8e>
  801d6d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801d70:	8b 40 04             	mov    0x4(%eax),%eax
  801d73:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801d76:	8b 12                	mov    (%edx),%edx
  801d78:	89 10                	mov    %edx,(%eax)
  801d7a:	eb 0a                	jmp    801d86 <free+0x98>
  801d7c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801d7f:	8b 00                	mov    (%eax),%eax
  801d81:	a3 40 50 80 00       	mov    %eax,0x805040
  801d86:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801d89:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  801d8f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801d92:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  801d99:	a1 4c 50 80 00       	mov    0x80504c,%eax
  801d9e:	48                   	dec    %eax
  801d9f:	a3 4c 50 80 00       	mov    %eax,0x80504c
	insert_sorted_with_merge_freeList(myBlock);
  801da4:	83 ec 0c             	sub    $0xc,%esp
  801da7:	ff 75 f0             	pushl  -0x10(%ebp)
  801daa:	e8 0b 14 00 00       	call   8031ba <insert_sorted_with_merge_freeList>
  801daf:	83 c4 10             	add    $0x10,%esp

	//you should get the size of the given allocation using its address
	//you need to call sys_free_user_mem()
	//refer to the project presentation and documentation for details
}
  801db2:	90                   	nop
  801db3:	c9                   	leave  
  801db4:	c3                   	ret    

00801db5 <smalloc>:

//=================================
// [4] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
  801db5:	55                   	push   %ebp
  801db6:	89 e5                	mov    %esp,%ebp
  801db8:	83 ec 28             	sub    $0x28,%esp
  801dbb:	8b 45 10             	mov    0x10(%ebp),%eax
  801dbe:	88 45 e4             	mov    %al,-0x1c(%ebp)
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801dc1:	e8 9f fc ff ff       	call   801a65 <InitializeUHeap>
	if (size == 0) return NULL ;
  801dc6:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801dca:	75 0a                	jne    801dd6 <smalloc+0x21>
  801dcc:	b8 00 00 00 00       	mov    $0x0,%eax
  801dd1:	e9 8d 00 00 00       	jmp    801e63 <smalloc+0xae>

	//This function should find the space of the required range
	// * ON 4KB BOUNDARY **** //
	//Use sys_isUHeapPlacementStrategyFIRSTFIT() to check the current strategy

	size = ROUNDUP(size, PAGE_SIZE);
  801dd6:	c7 45 f4 00 10 00 00 	movl   $0x1000,-0xc(%ebp)
  801ddd:	8b 55 0c             	mov    0xc(%ebp),%edx
  801de0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801de3:	01 d0                	add    %edx,%eax
  801de5:	48                   	dec    %eax
  801de6:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801de9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801dec:	ba 00 00 00 00       	mov    $0x0,%edx
  801df1:	f7 75 f4             	divl   -0xc(%ebp)
  801df4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801df7:	29 d0                	sub    %edx,%eax
  801df9:	89 45 0c             	mov    %eax,0xc(%ebp)
		if(sys_isUHeapPlacementStrategyFIRSTFIT())
  801dfc:	e8 c9 06 00 00       	call   8024ca <sys_isUHeapPlacementStrategyFIRSTFIT>
  801e01:	85 c0                	test   %eax,%eax
  801e03:	74 59                	je     801e5e <smalloc+0xa9>
		{
			struct MemBlock * v1=NULL;
  801e05:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
			v1= alloc_block_FF(size);
  801e0c:	83 ec 0c             	sub    $0xc,%esp
  801e0f:	ff 75 0c             	pushl  0xc(%ebp)
  801e12:	e8 b4 0c 00 00       	call   802acb <alloc_block_FF>
  801e17:	83 c4 10             	add    $0x10,%esp
  801e1a:	89 45 ec             	mov    %eax,-0x14(%ebp)
			if(v1==NULL)
  801e1d:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  801e21:	75 07                	jne    801e2a <smalloc+0x75>
			{
				return NULL;
  801e23:	b8 00 00 00 00       	mov    $0x0,%eax
  801e28:	eb 39                	jmp    801e63 <smalloc+0xae>
			}
			else
			{
				int ret=sys_createSharedObject(sharedVarName,  size,  isWritable,(void*)v1->sva);
  801e2a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801e2d:	8b 40 08             	mov    0x8(%eax),%eax
  801e30:	89 c2                	mov    %eax,%edx
  801e32:	0f b6 45 e4          	movzbl -0x1c(%ebp),%eax
  801e36:	52                   	push   %edx
  801e37:	50                   	push   %eax
  801e38:	ff 75 0c             	pushl  0xc(%ebp)
  801e3b:	ff 75 08             	pushl  0x8(%ebp)
  801e3e:	e8 0c 04 00 00       	call   80224f <sys_createSharedObject>
  801e43:	83 c4 10             	add    $0x10,%esp
  801e46:	89 45 e8             	mov    %eax,-0x18(%ebp)
				if(ret>=0)
  801e49:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  801e4d:	78 08                	js     801e57 <smalloc+0xa2>
				{
					return (void*)v1->sva;
  801e4f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801e52:	8b 40 08             	mov    0x8(%eax),%eax
  801e55:	eb 0c                	jmp    801e63 <smalloc+0xae>
				}
				else
				{
					return NULL;
  801e57:	b8 00 00 00 00       	mov    $0x0,%eax
  801e5c:	eb 05                	jmp    801e63 <smalloc+0xae>
				}
			}

		}
		return NULL;
  801e5e:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801e63:	c9                   	leave  
  801e64:	c3                   	ret    

00801e65 <sget>:

//========================================
// [5] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  801e65:	55                   	push   %ebp
  801e66:	89 e5                	mov    %esp,%ebp
  801e68:	83 ec 18             	sub    $0x18,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801e6b:	e8 f5 fb ff ff       	call   801a65 <InitializeUHeap>

	//This function should find the space for sharing the variable
	// *** ON 4KB BOUNDARY ******** //

	//Use sys_isUHeapPlacementStrategyFIRSTFIT() to check the current strategy
	int ret=sys_getSizeOfSharedObject(ownerEnvID,sharedVarName);
  801e70:	83 ec 08             	sub    $0x8,%esp
  801e73:	ff 75 0c             	pushl  0xc(%ebp)
  801e76:	ff 75 08             	pushl  0x8(%ebp)
  801e79:	e8 fb 03 00 00       	call   802279 <sys_getSizeOfSharedObject>
  801e7e:	83 c4 10             	add    $0x10,%esp
  801e81:	89 45 f4             	mov    %eax,-0xc(%ebp)
	if(ret==0)
  801e84:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801e88:	75 07                	jne    801e91 <sget+0x2c>
	{
		return NULL;
  801e8a:	b8 00 00 00 00       	mov    $0x0,%eax
  801e8f:	eb 64                	jmp    801ef5 <sget+0x90>
	}
	if(sys_isUHeapPlacementStrategyFIRSTFIT())
  801e91:	e8 34 06 00 00       	call   8024ca <sys_isUHeapPlacementStrategyFIRSTFIT>
  801e96:	85 c0                	test   %eax,%eax
  801e98:	74 56                	je     801ef0 <sget+0x8b>
	{
		struct MemBlock * v1=NULL;
  801e9a:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
		v1= alloc_block_FF(ret);
  801ea1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ea4:	83 ec 0c             	sub    $0xc,%esp
  801ea7:	50                   	push   %eax
  801ea8:	e8 1e 0c 00 00       	call   802acb <alloc_block_FF>
  801ead:	83 c4 10             	add    $0x10,%esp
  801eb0:	89 45 f0             	mov    %eax,-0x10(%ebp)
		if(v1==NULL)
  801eb3:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801eb7:	75 07                	jne    801ec0 <sget+0x5b>
		{
		return NULL;
  801eb9:	b8 00 00 00 00       	mov    $0x0,%eax
  801ebe:	eb 35                	jmp    801ef5 <sget+0x90>
	    }
		else
		{
			int ret1=sys_getSharedObject(ownerEnvID,sharedVarName,(void*)v1->sva);
  801ec0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801ec3:	8b 40 08             	mov    0x8(%eax),%eax
  801ec6:	83 ec 04             	sub    $0x4,%esp
  801ec9:	50                   	push   %eax
  801eca:	ff 75 0c             	pushl  0xc(%ebp)
  801ecd:	ff 75 08             	pushl  0x8(%ebp)
  801ed0:	e8 c1 03 00 00       	call   802296 <sys_getSharedObject>
  801ed5:	83 c4 10             	add    $0x10,%esp
  801ed8:	89 45 ec             	mov    %eax,-0x14(%ebp)
			if(ret1>=0)
  801edb:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  801edf:	78 08                	js     801ee9 <sget+0x84>
			{
				return (void*)v1->sva;
  801ee1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801ee4:	8b 40 08             	mov    0x8(%eax),%eax
  801ee7:	eb 0c                	jmp    801ef5 <sget+0x90>
			}
			else
			{
				return NULL;
  801ee9:	b8 00 00 00 00       	mov    $0x0,%eax
  801eee:	eb 05                	jmp    801ef5 <sget+0x90>
			}
		}
	}
  return NULL;
  801ef0:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801ef5:	c9                   	leave  
  801ef6:	c3                   	ret    

00801ef7 <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  801ef7:	55                   	push   %ebp
  801ef8:	89 e5                	mov    %esp,%ebp
  801efa:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801efd:	e8 63 fb ff ff       	call   801a65 <InitializeUHeap>
	//==============================================================
	// [USER HEAP - USER SIDE] realloc
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  801f02:	83 ec 04             	sub    $0x4,%esp
  801f05:	68 04 40 80 00       	push   $0x804004
  801f0a:	68 0e 01 00 00       	push   $0x10e
  801f0f:	68 d3 3f 80 00       	push   $0x803fd3
  801f14:	e8 0e eb ff ff       	call   800a27 <_panic>

00801f19 <sfree>:
//	use sys_freeSharedObject(...); which switches to the kernel mode,
//	calls freeSharedObject(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the freeSharedObject() function is empty, make sure to implement it.

void sfree(void* virtual_address)
{
  801f19:	55                   	push   %ebp
  801f1a:	89 e5                	mov    %esp,%ebp
  801f1c:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS3 - BONUS] [SHARING - USER SIDE] sfree()

	// Write your code here, remove the panic and write your code
	panic("sfree() is not implemented yet...!!");
  801f1f:	83 ec 04             	sub    $0x4,%esp
  801f22:	68 2c 40 80 00       	push   $0x80402c
  801f27:	68 22 01 00 00       	push   $0x122
  801f2c:	68 d3 3f 80 00       	push   $0x803fd3
  801f31:	e8 f1 ea ff ff       	call   800a27 <_panic>

00801f36 <expand>:

//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//
void expand(uint32 newSize)
{
  801f36:	55                   	push   %ebp
  801f37:	89 e5                	mov    %esp,%ebp
  801f39:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801f3c:	83 ec 04             	sub    $0x4,%esp
  801f3f:	68 50 40 80 00       	push   $0x804050
  801f44:	68 2d 01 00 00       	push   $0x12d
  801f49:	68 d3 3f 80 00       	push   $0x803fd3
  801f4e:	e8 d4 ea ff ff       	call   800a27 <_panic>

00801f53 <shrink>:

}
void shrink(uint32 newSize)
{
  801f53:	55                   	push   %ebp
  801f54:	89 e5                	mov    %esp,%ebp
  801f56:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801f59:	83 ec 04             	sub    $0x4,%esp
  801f5c:	68 50 40 80 00       	push   $0x804050
  801f61:	68 32 01 00 00       	push   $0x132
  801f66:	68 d3 3f 80 00       	push   $0x803fd3
  801f6b:	e8 b7 ea ff ff       	call   800a27 <_panic>

00801f70 <freeHeap>:

}
void freeHeap(void* virtual_address)
{
  801f70:	55                   	push   %ebp
  801f71:	89 e5                	mov    %esp,%ebp
  801f73:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801f76:	83 ec 04             	sub    $0x4,%esp
  801f79:	68 50 40 80 00       	push   $0x804050
  801f7e:	68 37 01 00 00       	push   $0x137
  801f83:	68 d3 3f 80 00       	push   $0x803fd3
  801f88:	e8 9a ea ff ff       	call   800a27 <_panic>

00801f8d <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  801f8d:	55                   	push   %ebp
  801f8e:	89 e5                	mov    %esp,%ebp
  801f90:	57                   	push   %edi
  801f91:	56                   	push   %esi
  801f92:	53                   	push   %ebx
  801f93:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801f96:	8b 45 08             	mov    0x8(%ebp),%eax
  801f99:	8b 55 0c             	mov    0xc(%ebp),%edx
  801f9c:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801f9f:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801fa2:	8b 7d 18             	mov    0x18(%ebp),%edi
  801fa5:	8b 75 1c             	mov    0x1c(%ebp),%esi
  801fa8:	cd 30                	int    $0x30
  801faa:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  801fad:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801fb0:	83 c4 10             	add    $0x10,%esp
  801fb3:	5b                   	pop    %ebx
  801fb4:	5e                   	pop    %esi
  801fb5:	5f                   	pop    %edi
  801fb6:	5d                   	pop    %ebp
  801fb7:	c3                   	ret    

00801fb8 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  801fb8:	55                   	push   %ebp
  801fb9:	89 e5                	mov    %esp,%ebp
  801fbb:	83 ec 04             	sub    $0x4,%esp
  801fbe:	8b 45 10             	mov    0x10(%ebp),%eax
  801fc1:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  801fc4:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801fc8:	8b 45 08             	mov    0x8(%ebp),%eax
  801fcb:	6a 00                	push   $0x0
  801fcd:	6a 00                	push   $0x0
  801fcf:	52                   	push   %edx
  801fd0:	ff 75 0c             	pushl  0xc(%ebp)
  801fd3:	50                   	push   %eax
  801fd4:	6a 00                	push   $0x0
  801fd6:	e8 b2 ff ff ff       	call   801f8d <syscall>
  801fdb:	83 c4 18             	add    $0x18,%esp
}
  801fde:	90                   	nop
  801fdf:	c9                   	leave  
  801fe0:	c3                   	ret    

00801fe1 <sys_cgetc>:

int
sys_cgetc(void)
{
  801fe1:	55                   	push   %ebp
  801fe2:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  801fe4:	6a 00                	push   $0x0
  801fe6:	6a 00                	push   $0x0
  801fe8:	6a 00                	push   $0x0
  801fea:	6a 00                	push   $0x0
  801fec:	6a 00                	push   $0x0
  801fee:	6a 01                	push   $0x1
  801ff0:	e8 98 ff ff ff       	call   801f8d <syscall>
  801ff5:	83 c4 18             	add    $0x18,%esp
}
  801ff8:	c9                   	leave  
  801ff9:	c3                   	ret    

00801ffa <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  801ffa:	55                   	push   %ebp
  801ffb:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  801ffd:	8b 55 0c             	mov    0xc(%ebp),%edx
  802000:	8b 45 08             	mov    0x8(%ebp),%eax
  802003:	6a 00                	push   $0x0
  802005:	6a 00                	push   $0x0
  802007:	6a 00                	push   $0x0
  802009:	52                   	push   %edx
  80200a:	50                   	push   %eax
  80200b:	6a 05                	push   $0x5
  80200d:	e8 7b ff ff ff       	call   801f8d <syscall>
  802012:	83 c4 18             	add    $0x18,%esp
}
  802015:	c9                   	leave  
  802016:	c3                   	ret    

00802017 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  802017:	55                   	push   %ebp
  802018:	89 e5                	mov    %esp,%ebp
  80201a:	56                   	push   %esi
  80201b:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  80201c:	8b 75 18             	mov    0x18(%ebp),%esi
  80201f:	8b 5d 14             	mov    0x14(%ebp),%ebx
  802022:	8b 4d 10             	mov    0x10(%ebp),%ecx
  802025:	8b 55 0c             	mov    0xc(%ebp),%edx
  802028:	8b 45 08             	mov    0x8(%ebp),%eax
  80202b:	56                   	push   %esi
  80202c:	53                   	push   %ebx
  80202d:	51                   	push   %ecx
  80202e:	52                   	push   %edx
  80202f:	50                   	push   %eax
  802030:	6a 06                	push   $0x6
  802032:	e8 56 ff ff ff       	call   801f8d <syscall>
  802037:	83 c4 18             	add    $0x18,%esp
}
  80203a:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80203d:	5b                   	pop    %ebx
  80203e:	5e                   	pop    %esi
  80203f:	5d                   	pop    %ebp
  802040:	c3                   	ret    

00802041 <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  802041:	55                   	push   %ebp
  802042:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  802044:	8b 55 0c             	mov    0xc(%ebp),%edx
  802047:	8b 45 08             	mov    0x8(%ebp),%eax
  80204a:	6a 00                	push   $0x0
  80204c:	6a 00                	push   $0x0
  80204e:	6a 00                	push   $0x0
  802050:	52                   	push   %edx
  802051:	50                   	push   %eax
  802052:	6a 07                	push   $0x7
  802054:	e8 34 ff ff ff       	call   801f8d <syscall>
  802059:	83 c4 18             	add    $0x18,%esp
}
  80205c:	c9                   	leave  
  80205d:	c3                   	ret    

0080205e <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  80205e:	55                   	push   %ebp
  80205f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  802061:	6a 00                	push   $0x0
  802063:	6a 00                	push   $0x0
  802065:	6a 00                	push   $0x0
  802067:	ff 75 0c             	pushl  0xc(%ebp)
  80206a:	ff 75 08             	pushl  0x8(%ebp)
  80206d:	6a 08                	push   $0x8
  80206f:	e8 19 ff ff ff       	call   801f8d <syscall>
  802074:	83 c4 18             	add    $0x18,%esp
}
  802077:	c9                   	leave  
  802078:	c3                   	ret    

00802079 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  802079:	55                   	push   %ebp
  80207a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  80207c:	6a 00                	push   $0x0
  80207e:	6a 00                	push   $0x0
  802080:	6a 00                	push   $0x0
  802082:	6a 00                	push   $0x0
  802084:	6a 00                	push   $0x0
  802086:	6a 09                	push   $0x9
  802088:	e8 00 ff ff ff       	call   801f8d <syscall>
  80208d:	83 c4 18             	add    $0x18,%esp
}
  802090:	c9                   	leave  
  802091:	c3                   	ret    

00802092 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  802092:	55                   	push   %ebp
  802093:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  802095:	6a 00                	push   $0x0
  802097:	6a 00                	push   $0x0
  802099:	6a 00                	push   $0x0
  80209b:	6a 00                	push   $0x0
  80209d:	6a 00                	push   $0x0
  80209f:	6a 0a                	push   $0xa
  8020a1:	e8 e7 fe ff ff       	call   801f8d <syscall>
  8020a6:	83 c4 18             	add    $0x18,%esp
}
  8020a9:	c9                   	leave  
  8020aa:	c3                   	ret    

008020ab <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  8020ab:	55                   	push   %ebp
  8020ac:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  8020ae:	6a 00                	push   $0x0
  8020b0:	6a 00                	push   $0x0
  8020b2:	6a 00                	push   $0x0
  8020b4:	6a 00                	push   $0x0
  8020b6:	6a 00                	push   $0x0
  8020b8:	6a 0b                	push   $0xb
  8020ba:	e8 ce fe ff ff       	call   801f8d <syscall>
  8020bf:	83 c4 18             	add    $0x18,%esp
}
  8020c2:	c9                   	leave  
  8020c3:	c3                   	ret    

008020c4 <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  8020c4:	55                   	push   %ebp
  8020c5:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  8020c7:	6a 00                	push   $0x0
  8020c9:	6a 00                	push   $0x0
  8020cb:	6a 00                	push   $0x0
  8020cd:	ff 75 0c             	pushl  0xc(%ebp)
  8020d0:	ff 75 08             	pushl  0x8(%ebp)
  8020d3:	6a 0f                	push   $0xf
  8020d5:	e8 b3 fe ff ff       	call   801f8d <syscall>
  8020da:	83 c4 18             	add    $0x18,%esp
	return;
  8020dd:	90                   	nop
}
  8020de:	c9                   	leave  
  8020df:	c3                   	ret    

008020e0 <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  8020e0:	55                   	push   %ebp
  8020e1:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  8020e3:	6a 00                	push   $0x0
  8020e5:	6a 00                	push   $0x0
  8020e7:	6a 00                	push   $0x0
  8020e9:	ff 75 0c             	pushl  0xc(%ebp)
  8020ec:	ff 75 08             	pushl  0x8(%ebp)
  8020ef:	6a 10                	push   $0x10
  8020f1:	e8 97 fe ff ff       	call   801f8d <syscall>
  8020f6:	83 c4 18             	add    $0x18,%esp
	return ;
  8020f9:	90                   	nop
}
  8020fa:	c9                   	leave  
  8020fb:	c3                   	ret    

008020fc <sys_allocate_chunk>:

void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  8020fc:	55                   	push   %ebp
  8020fd:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  8020ff:	6a 00                	push   $0x0
  802101:	6a 00                	push   $0x0
  802103:	ff 75 10             	pushl  0x10(%ebp)
  802106:	ff 75 0c             	pushl  0xc(%ebp)
  802109:	ff 75 08             	pushl  0x8(%ebp)
  80210c:	6a 11                	push   $0x11
  80210e:	e8 7a fe ff ff       	call   801f8d <syscall>
  802113:	83 c4 18             	add    $0x18,%esp
	return ;
  802116:	90                   	nop
}
  802117:	c9                   	leave  
  802118:	c3                   	ret    

00802119 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  802119:	55                   	push   %ebp
  80211a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  80211c:	6a 00                	push   $0x0
  80211e:	6a 00                	push   $0x0
  802120:	6a 00                	push   $0x0
  802122:	6a 00                	push   $0x0
  802124:	6a 00                	push   $0x0
  802126:	6a 0c                	push   $0xc
  802128:	e8 60 fe ff ff       	call   801f8d <syscall>
  80212d:	83 c4 18             	add    $0x18,%esp
}
  802130:	c9                   	leave  
  802131:	c3                   	ret    

00802132 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  802132:	55                   	push   %ebp
  802133:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  802135:	6a 00                	push   $0x0
  802137:	6a 00                	push   $0x0
  802139:	6a 00                	push   $0x0
  80213b:	6a 00                	push   $0x0
  80213d:	ff 75 08             	pushl  0x8(%ebp)
  802140:	6a 0d                	push   $0xd
  802142:	e8 46 fe ff ff       	call   801f8d <syscall>
  802147:	83 c4 18             	add    $0x18,%esp
}
  80214a:	c9                   	leave  
  80214b:	c3                   	ret    

0080214c <sys_scarce_memory>:

void sys_scarce_memory()
{
  80214c:	55                   	push   %ebp
  80214d:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  80214f:	6a 00                	push   $0x0
  802151:	6a 00                	push   $0x0
  802153:	6a 00                	push   $0x0
  802155:	6a 00                	push   $0x0
  802157:	6a 00                	push   $0x0
  802159:	6a 0e                	push   $0xe
  80215b:	e8 2d fe ff ff       	call   801f8d <syscall>
  802160:	83 c4 18             	add    $0x18,%esp
}
  802163:	90                   	nop
  802164:	c9                   	leave  
  802165:	c3                   	ret    

00802166 <sys_disable_interrupt>:

//NEW !! 2012...
void
sys_disable_interrupt()
{
  802166:	55                   	push   %ebp
  802167:	89 e5                	mov    %esp,%ebp
	syscall(SYS_disableINTR,0, 0, 0, 0, 0);
  802169:	6a 00                	push   $0x0
  80216b:	6a 00                	push   $0x0
  80216d:	6a 00                	push   $0x0
  80216f:	6a 00                	push   $0x0
  802171:	6a 00                	push   $0x0
  802173:	6a 13                	push   $0x13
  802175:	e8 13 fe ff ff       	call   801f8d <syscall>
  80217a:	83 c4 18             	add    $0x18,%esp
}
  80217d:	90                   	nop
  80217e:	c9                   	leave  
  80217f:	c3                   	ret    

00802180 <sys_enable_interrupt>:


void
sys_enable_interrupt()
{
  802180:	55                   	push   %ebp
  802181:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enableINTR,0, 0, 0, 0, 0);
  802183:	6a 00                	push   $0x0
  802185:	6a 00                	push   $0x0
  802187:	6a 00                	push   $0x0
  802189:	6a 00                	push   $0x0
  80218b:	6a 00                	push   $0x0
  80218d:	6a 14                	push   $0x14
  80218f:	e8 f9 fd ff ff       	call   801f8d <syscall>
  802194:	83 c4 18             	add    $0x18,%esp
}
  802197:	90                   	nop
  802198:	c9                   	leave  
  802199:	c3                   	ret    

0080219a <sys_cputc>:


void
sys_cputc(const char c)
{
  80219a:	55                   	push   %ebp
  80219b:	89 e5                	mov    %esp,%ebp
  80219d:	83 ec 04             	sub    $0x4,%esp
  8021a0:	8b 45 08             	mov    0x8(%ebp),%eax
  8021a3:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  8021a6:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  8021aa:	6a 00                	push   $0x0
  8021ac:	6a 00                	push   $0x0
  8021ae:	6a 00                	push   $0x0
  8021b0:	6a 00                	push   $0x0
  8021b2:	50                   	push   %eax
  8021b3:	6a 15                	push   $0x15
  8021b5:	e8 d3 fd ff ff       	call   801f8d <syscall>
  8021ba:	83 c4 18             	add    $0x18,%esp
}
  8021bd:	90                   	nop
  8021be:	c9                   	leave  
  8021bf:	c3                   	ret    

008021c0 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  8021c0:	55                   	push   %ebp
  8021c1:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  8021c3:	6a 00                	push   $0x0
  8021c5:	6a 00                	push   $0x0
  8021c7:	6a 00                	push   $0x0
  8021c9:	6a 00                	push   $0x0
  8021cb:	6a 00                	push   $0x0
  8021cd:	6a 16                	push   $0x16
  8021cf:	e8 b9 fd ff ff       	call   801f8d <syscall>
  8021d4:	83 c4 18             	add    $0x18,%esp
}
  8021d7:	90                   	nop
  8021d8:	c9                   	leave  
  8021d9:	c3                   	ret    

008021da <sys_createSemaphore>:

int
sys_createSemaphore(char* semaphoreName, uint32 initialValue)
{
  8021da:	55                   	push   %ebp
  8021db:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_semaphore,(uint32)semaphoreName, (uint32)initialValue, 0, 0, 0);
  8021dd:	8b 45 08             	mov    0x8(%ebp),%eax
  8021e0:	6a 00                	push   $0x0
  8021e2:	6a 00                	push   $0x0
  8021e4:	6a 00                	push   $0x0
  8021e6:	ff 75 0c             	pushl  0xc(%ebp)
  8021e9:	50                   	push   %eax
  8021ea:	6a 17                	push   $0x17
  8021ec:	e8 9c fd ff ff       	call   801f8d <syscall>
  8021f1:	83 c4 18             	add    $0x18,%esp
}
  8021f4:	c9                   	leave  
  8021f5:	c3                   	ret    

008021f6 <sys_getSemaphoreValue>:

int
sys_getSemaphoreValue(int32 ownerEnvID, char* semaphoreName)
{
  8021f6:	55                   	push   %ebp
  8021f7:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_semaphore_value,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  8021f9:	8b 55 0c             	mov    0xc(%ebp),%edx
  8021fc:	8b 45 08             	mov    0x8(%ebp),%eax
  8021ff:	6a 00                	push   $0x0
  802201:	6a 00                	push   $0x0
  802203:	6a 00                	push   $0x0
  802205:	52                   	push   %edx
  802206:	50                   	push   %eax
  802207:	6a 1a                	push   $0x1a
  802209:	e8 7f fd ff ff       	call   801f8d <syscall>
  80220e:	83 c4 18             	add    $0x18,%esp
}
  802211:	c9                   	leave  
  802212:	c3                   	ret    

00802213 <sys_waitSemaphore>:

void
sys_waitSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  802213:	55                   	push   %ebp
  802214:	89 e5                	mov    %esp,%ebp
	syscall(SYS_wait_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  802216:	8b 55 0c             	mov    0xc(%ebp),%edx
  802219:	8b 45 08             	mov    0x8(%ebp),%eax
  80221c:	6a 00                	push   $0x0
  80221e:	6a 00                	push   $0x0
  802220:	6a 00                	push   $0x0
  802222:	52                   	push   %edx
  802223:	50                   	push   %eax
  802224:	6a 18                	push   $0x18
  802226:	e8 62 fd ff ff       	call   801f8d <syscall>
  80222b:	83 c4 18             	add    $0x18,%esp
}
  80222e:	90                   	nop
  80222f:	c9                   	leave  
  802230:	c3                   	ret    

00802231 <sys_signalSemaphore>:

void
sys_signalSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  802231:	55                   	push   %ebp
  802232:	89 e5                	mov    %esp,%ebp
	syscall(SYS_signal_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  802234:	8b 55 0c             	mov    0xc(%ebp),%edx
  802237:	8b 45 08             	mov    0x8(%ebp),%eax
  80223a:	6a 00                	push   $0x0
  80223c:	6a 00                	push   $0x0
  80223e:	6a 00                	push   $0x0
  802240:	52                   	push   %edx
  802241:	50                   	push   %eax
  802242:	6a 19                	push   $0x19
  802244:	e8 44 fd ff ff       	call   801f8d <syscall>
  802249:	83 c4 18             	add    $0x18,%esp
}
  80224c:	90                   	nop
  80224d:	c9                   	leave  
  80224e:	c3                   	ret    

0080224f <sys_createSharedObject>:

int
sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  80224f:	55                   	push   %ebp
  802250:	89 e5                	mov    %esp,%ebp
  802252:	83 ec 04             	sub    $0x4,%esp
  802255:	8b 45 10             	mov    0x10(%ebp),%eax
  802258:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  80225b:	8b 4d 14             	mov    0x14(%ebp),%ecx
  80225e:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  802262:	8b 45 08             	mov    0x8(%ebp),%eax
  802265:	6a 00                	push   $0x0
  802267:	51                   	push   %ecx
  802268:	52                   	push   %edx
  802269:	ff 75 0c             	pushl  0xc(%ebp)
  80226c:	50                   	push   %eax
  80226d:	6a 1b                	push   $0x1b
  80226f:	e8 19 fd ff ff       	call   801f8d <syscall>
  802274:	83 c4 18             	add    $0x18,%esp
}
  802277:	c9                   	leave  
  802278:	c3                   	ret    

00802279 <sys_getSizeOfSharedObject>:

//2017:
int
sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  802279:	55                   	push   %ebp
  80227a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  80227c:	8b 55 0c             	mov    0xc(%ebp),%edx
  80227f:	8b 45 08             	mov    0x8(%ebp),%eax
  802282:	6a 00                	push   $0x0
  802284:	6a 00                	push   $0x0
  802286:	6a 00                	push   $0x0
  802288:	52                   	push   %edx
  802289:	50                   	push   %eax
  80228a:	6a 1c                	push   $0x1c
  80228c:	e8 fc fc ff ff       	call   801f8d <syscall>
  802291:	83 c4 18             	add    $0x18,%esp
}
  802294:	c9                   	leave  
  802295:	c3                   	ret    

00802296 <sys_getSharedObject>:
//==========

int
sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  802296:	55                   	push   %ebp
  802297:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  802299:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80229c:	8b 55 0c             	mov    0xc(%ebp),%edx
  80229f:	8b 45 08             	mov    0x8(%ebp),%eax
  8022a2:	6a 00                	push   $0x0
  8022a4:	6a 00                	push   $0x0
  8022a6:	51                   	push   %ecx
  8022a7:	52                   	push   %edx
  8022a8:	50                   	push   %eax
  8022a9:	6a 1d                	push   $0x1d
  8022ab:	e8 dd fc ff ff       	call   801f8d <syscall>
  8022b0:	83 c4 18             	add    $0x18,%esp
}
  8022b3:	c9                   	leave  
  8022b4:	c3                   	ret    

008022b5 <sys_freeSharedObject>:

int
sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  8022b5:	55                   	push   %ebp
  8022b6:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  8022b8:	8b 55 0c             	mov    0xc(%ebp),%edx
  8022bb:	8b 45 08             	mov    0x8(%ebp),%eax
  8022be:	6a 00                	push   $0x0
  8022c0:	6a 00                	push   $0x0
  8022c2:	6a 00                	push   $0x0
  8022c4:	52                   	push   %edx
  8022c5:	50                   	push   %eax
  8022c6:	6a 1e                	push   $0x1e
  8022c8:	e8 c0 fc ff ff       	call   801f8d <syscall>
  8022cd:	83 c4 18             	add    $0x18,%esp
}
  8022d0:	c9                   	leave  
  8022d1:	c3                   	ret    

008022d2 <sys_getMaxShares>:

uint32 	sys_getMaxShares()
{
  8022d2:	55                   	push   %ebp
  8022d3:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_max_shares,0, 0, 0, 0, 0);
  8022d5:	6a 00                	push   $0x0
  8022d7:	6a 00                	push   $0x0
  8022d9:	6a 00                	push   $0x0
  8022db:	6a 00                	push   $0x0
  8022dd:	6a 00                	push   $0x0
  8022df:	6a 1f                	push   $0x1f
  8022e1:	e8 a7 fc ff ff       	call   801f8d <syscall>
  8022e6:	83 c4 18             	add    $0x18,%esp
}
  8022e9:	c9                   	leave  
  8022ea:	c3                   	ret    

008022eb <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  8022eb:	55                   	push   %ebp
  8022ec:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  8022ee:	8b 45 08             	mov    0x8(%ebp),%eax
  8022f1:	6a 00                	push   $0x0
  8022f3:	ff 75 14             	pushl  0x14(%ebp)
  8022f6:	ff 75 10             	pushl  0x10(%ebp)
  8022f9:	ff 75 0c             	pushl  0xc(%ebp)
  8022fc:	50                   	push   %eax
  8022fd:	6a 20                	push   $0x20
  8022ff:	e8 89 fc ff ff       	call   801f8d <syscall>
  802304:	83 c4 18             	add    $0x18,%esp
}
  802307:	c9                   	leave  
  802308:	c3                   	ret    

00802309 <sys_run_env>:

void
sys_run_env(int32 envId)
{
  802309:	55                   	push   %ebp
  80230a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  80230c:	8b 45 08             	mov    0x8(%ebp),%eax
  80230f:	6a 00                	push   $0x0
  802311:	6a 00                	push   $0x0
  802313:	6a 00                	push   $0x0
  802315:	6a 00                	push   $0x0
  802317:	50                   	push   %eax
  802318:	6a 21                	push   $0x21
  80231a:	e8 6e fc ff ff       	call   801f8d <syscall>
  80231f:	83 c4 18             	add    $0x18,%esp
}
  802322:	90                   	nop
  802323:	c9                   	leave  
  802324:	c3                   	ret    

00802325 <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  802325:	55                   	push   %ebp
  802326:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  802328:	8b 45 08             	mov    0x8(%ebp),%eax
  80232b:	6a 00                	push   $0x0
  80232d:	6a 00                	push   $0x0
  80232f:	6a 00                	push   $0x0
  802331:	6a 00                	push   $0x0
  802333:	50                   	push   %eax
  802334:	6a 22                	push   $0x22
  802336:	e8 52 fc ff ff       	call   801f8d <syscall>
  80233b:	83 c4 18             	add    $0x18,%esp
}
  80233e:	c9                   	leave  
  80233f:	c3                   	ret    

00802340 <sys_getenvid>:

int32 sys_getenvid(void)
{
  802340:	55                   	push   %ebp
  802341:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  802343:	6a 00                	push   $0x0
  802345:	6a 00                	push   $0x0
  802347:	6a 00                	push   $0x0
  802349:	6a 00                	push   $0x0
  80234b:	6a 00                	push   $0x0
  80234d:	6a 02                	push   $0x2
  80234f:	e8 39 fc ff ff       	call   801f8d <syscall>
  802354:	83 c4 18             	add    $0x18,%esp
}
  802357:	c9                   	leave  
  802358:	c3                   	ret    

00802359 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  802359:	55                   	push   %ebp
  80235a:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  80235c:	6a 00                	push   $0x0
  80235e:	6a 00                	push   $0x0
  802360:	6a 00                	push   $0x0
  802362:	6a 00                	push   $0x0
  802364:	6a 00                	push   $0x0
  802366:	6a 03                	push   $0x3
  802368:	e8 20 fc ff ff       	call   801f8d <syscall>
  80236d:	83 c4 18             	add    $0x18,%esp
}
  802370:	c9                   	leave  
  802371:	c3                   	ret    

00802372 <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  802372:	55                   	push   %ebp
  802373:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  802375:	6a 00                	push   $0x0
  802377:	6a 00                	push   $0x0
  802379:	6a 00                	push   $0x0
  80237b:	6a 00                	push   $0x0
  80237d:	6a 00                	push   $0x0
  80237f:	6a 04                	push   $0x4
  802381:	e8 07 fc ff ff       	call   801f8d <syscall>
  802386:	83 c4 18             	add    $0x18,%esp
}
  802389:	c9                   	leave  
  80238a:	c3                   	ret    

0080238b <sys_exit_env>:


void sys_exit_env(void)
{
  80238b:	55                   	push   %ebp
  80238c:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  80238e:	6a 00                	push   $0x0
  802390:	6a 00                	push   $0x0
  802392:	6a 00                	push   $0x0
  802394:	6a 00                	push   $0x0
  802396:	6a 00                	push   $0x0
  802398:	6a 23                	push   $0x23
  80239a:	e8 ee fb ff ff       	call   801f8d <syscall>
  80239f:	83 c4 18             	add    $0x18,%esp
}
  8023a2:	90                   	nop
  8023a3:	c9                   	leave  
  8023a4:	c3                   	ret    

008023a5 <sys_get_virtual_time>:


struct uint64
sys_get_virtual_time()
{
  8023a5:	55                   	push   %ebp
  8023a6:	89 e5                	mov    %esp,%ebp
  8023a8:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  8023ab:	8d 45 f8             	lea    -0x8(%ebp),%eax
  8023ae:	8d 50 04             	lea    0x4(%eax),%edx
  8023b1:	8d 45 f8             	lea    -0x8(%ebp),%eax
  8023b4:	6a 00                	push   $0x0
  8023b6:	6a 00                	push   $0x0
  8023b8:	6a 00                	push   $0x0
  8023ba:	52                   	push   %edx
  8023bb:	50                   	push   %eax
  8023bc:	6a 24                	push   $0x24
  8023be:	e8 ca fb ff ff       	call   801f8d <syscall>
  8023c3:	83 c4 18             	add    $0x18,%esp
	return result;
  8023c6:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8023c9:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8023cc:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8023cf:	89 01                	mov    %eax,(%ecx)
  8023d1:	89 51 04             	mov    %edx,0x4(%ecx)
}
  8023d4:	8b 45 08             	mov    0x8(%ebp),%eax
  8023d7:	c9                   	leave  
  8023d8:	c2 04 00             	ret    $0x4

008023db <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  8023db:	55                   	push   %ebp
  8023dc:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  8023de:	6a 00                	push   $0x0
  8023e0:	6a 00                	push   $0x0
  8023e2:	ff 75 10             	pushl  0x10(%ebp)
  8023e5:	ff 75 0c             	pushl  0xc(%ebp)
  8023e8:	ff 75 08             	pushl  0x8(%ebp)
  8023eb:	6a 12                	push   $0x12
  8023ed:	e8 9b fb ff ff       	call   801f8d <syscall>
  8023f2:	83 c4 18             	add    $0x18,%esp
	return ;
  8023f5:	90                   	nop
}
  8023f6:	c9                   	leave  
  8023f7:	c3                   	ret    

008023f8 <sys_rcr2>:
uint32 sys_rcr2()
{
  8023f8:	55                   	push   %ebp
  8023f9:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  8023fb:	6a 00                	push   $0x0
  8023fd:	6a 00                	push   $0x0
  8023ff:	6a 00                	push   $0x0
  802401:	6a 00                	push   $0x0
  802403:	6a 00                	push   $0x0
  802405:	6a 25                	push   $0x25
  802407:	e8 81 fb ff ff       	call   801f8d <syscall>
  80240c:	83 c4 18             	add    $0x18,%esp
}
  80240f:	c9                   	leave  
  802410:	c3                   	ret    

00802411 <sys_bypassPageFault>:
void sys_bypassPageFault(uint8 instrLength)
{
  802411:	55                   	push   %ebp
  802412:	89 e5                	mov    %esp,%ebp
  802414:	83 ec 04             	sub    $0x4,%esp
  802417:	8b 45 08             	mov    0x8(%ebp),%eax
  80241a:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  80241d:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  802421:	6a 00                	push   $0x0
  802423:	6a 00                	push   $0x0
  802425:	6a 00                	push   $0x0
  802427:	6a 00                	push   $0x0
  802429:	50                   	push   %eax
  80242a:	6a 26                	push   $0x26
  80242c:	e8 5c fb ff ff       	call   801f8d <syscall>
  802431:	83 c4 18             	add    $0x18,%esp
	return ;
  802434:	90                   	nop
}
  802435:	c9                   	leave  
  802436:	c3                   	ret    

00802437 <rsttst>:
void rsttst()
{
  802437:	55                   	push   %ebp
  802438:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  80243a:	6a 00                	push   $0x0
  80243c:	6a 00                	push   $0x0
  80243e:	6a 00                	push   $0x0
  802440:	6a 00                	push   $0x0
  802442:	6a 00                	push   $0x0
  802444:	6a 28                	push   $0x28
  802446:	e8 42 fb ff ff       	call   801f8d <syscall>
  80244b:	83 c4 18             	add    $0x18,%esp
	return ;
  80244e:	90                   	nop
}
  80244f:	c9                   	leave  
  802450:	c3                   	ret    

00802451 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  802451:	55                   	push   %ebp
  802452:	89 e5                	mov    %esp,%ebp
  802454:	83 ec 04             	sub    $0x4,%esp
  802457:	8b 45 14             	mov    0x14(%ebp),%eax
  80245a:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  80245d:	8b 55 18             	mov    0x18(%ebp),%edx
  802460:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  802464:	52                   	push   %edx
  802465:	50                   	push   %eax
  802466:	ff 75 10             	pushl  0x10(%ebp)
  802469:	ff 75 0c             	pushl  0xc(%ebp)
  80246c:	ff 75 08             	pushl  0x8(%ebp)
  80246f:	6a 27                	push   $0x27
  802471:	e8 17 fb ff ff       	call   801f8d <syscall>
  802476:	83 c4 18             	add    $0x18,%esp
	return ;
  802479:	90                   	nop
}
  80247a:	c9                   	leave  
  80247b:	c3                   	ret    

0080247c <chktst>:
void chktst(uint32 n)
{
  80247c:	55                   	push   %ebp
  80247d:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  80247f:	6a 00                	push   $0x0
  802481:	6a 00                	push   $0x0
  802483:	6a 00                	push   $0x0
  802485:	6a 00                	push   $0x0
  802487:	ff 75 08             	pushl  0x8(%ebp)
  80248a:	6a 29                	push   $0x29
  80248c:	e8 fc fa ff ff       	call   801f8d <syscall>
  802491:	83 c4 18             	add    $0x18,%esp
	return ;
  802494:	90                   	nop
}
  802495:	c9                   	leave  
  802496:	c3                   	ret    

00802497 <inctst>:

void inctst()
{
  802497:	55                   	push   %ebp
  802498:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  80249a:	6a 00                	push   $0x0
  80249c:	6a 00                	push   $0x0
  80249e:	6a 00                	push   $0x0
  8024a0:	6a 00                	push   $0x0
  8024a2:	6a 00                	push   $0x0
  8024a4:	6a 2a                	push   $0x2a
  8024a6:	e8 e2 fa ff ff       	call   801f8d <syscall>
  8024ab:	83 c4 18             	add    $0x18,%esp
	return ;
  8024ae:	90                   	nop
}
  8024af:	c9                   	leave  
  8024b0:	c3                   	ret    

008024b1 <gettst>:
uint32 gettst()
{
  8024b1:	55                   	push   %ebp
  8024b2:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  8024b4:	6a 00                	push   $0x0
  8024b6:	6a 00                	push   $0x0
  8024b8:	6a 00                	push   $0x0
  8024ba:	6a 00                	push   $0x0
  8024bc:	6a 00                	push   $0x0
  8024be:	6a 2b                	push   $0x2b
  8024c0:	e8 c8 fa ff ff       	call   801f8d <syscall>
  8024c5:	83 c4 18             	add    $0x18,%esp
}
  8024c8:	c9                   	leave  
  8024c9:	c3                   	ret    

008024ca <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  8024ca:	55                   	push   %ebp
  8024cb:	89 e5                	mov    %esp,%ebp
  8024cd:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8024d0:	6a 00                	push   $0x0
  8024d2:	6a 00                	push   $0x0
  8024d4:	6a 00                	push   $0x0
  8024d6:	6a 00                	push   $0x0
  8024d8:	6a 00                	push   $0x0
  8024da:	6a 2c                	push   $0x2c
  8024dc:	e8 ac fa ff ff       	call   801f8d <syscall>
  8024e1:	83 c4 18             	add    $0x18,%esp
  8024e4:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  8024e7:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  8024eb:	75 07                	jne    8024f4 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  8024ed:	b8 01 00 00 00       	mov    $0x1,%eax
  8024f2:	eb 05                	jmp    8024f9 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  8024f4:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8024f9:	c9                   	leave  
  8024fa:	c3                   	ret    

008024fb <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  8024fb:	55                   	push   %ebp
  8024fc:	89 e5                	mov    %esp,%ebp
  8024fe:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  802501:	6a 00                	push   $0x0
  802503:	6a 00                	push   $0x0
  802505:	6a 00                	push   $0x0
  802507:	6a 00                	push   $0x0
  802509:	6a 00                	push   $0x0
  80250b:	6a 2c                	push   $0x2c
  80250d:	e8 7b fa ff ff       	call   801f8d <syscall>
  802512:	83 c4 18             	add    $0x18,%esp
  802515:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  802518:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  80251c:	75 07                	jne    802525 <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  80251e:	b8 01 00 00 00       	mov    $0x1,%eax
  802523:	eb 05                	jmp    80252a <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  802525:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80252a:	c9                   	leave  
  80252b:	c3                   	ret    

0080252c <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  80252c:	55                   	push   %ebp
  80252d:	89 e5                	mov    %esp,%ebp
  80252f:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  802532:	6a 00                	push   $0x0
  802534:	6a 00                	push   $0x0
  802536:	6a 00                	push   $0x0
  802538:	6a 00                	push   $0x0
  80253a:	6a 00                	push   $0x0
  80253c:	6a 2c                	push   $0x2c
  80253e:	e8 4a fa ff ff       	call   801f8d <syscall>
  802543:	83 c4 18             	add    $0x18,%esp
  802546:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  802549:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  80254d:	75 07                	jne    802556 <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  80254f:	b8 01 00 00 00       	mov    $0x1,%eax
  802554:	eb 05                	jmp    80255b <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  802556:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80255b:	c9                   	leave  
  80255c:	c3                   	ret    

0080255d <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  80255d:	55                   	push   %ebp
  80255e:	89 e5                	mov    %esp,%ebp
  802560:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  802563:	6a 00                	push   $0x0
  802565:	6a 00                	push   $0x0
  802567:	6a 00                	push   $0x0
  802569:	6a 00                	push   $0x0
  80256b:	6a 00                	push   $0x0
  80256d:	6a 2c                	push   $0x2c
  80256f:	e8 19 fa ff ff       	call   801f8d <syscall>
  802574:	83 c4 18             	add    $0x18,%esp
  802577:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  80257a:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  80257e:	75 07                	jne    802587 <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  802580:	b8 01 00 00 00       	mov    $0x1,%eax
  802585:	eb 05                	jmp    80258c <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  802587:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80258c:	c9                   	leave  
  80258d:	c3                   	ret    

0080258e <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  80258e:	55                   	push   %ebp
  80258f:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  802591:	6a 00                	push   $0x0
  802593:	6a 00                	push   $0x0
  802595:	6a 00                	push   $0x0
  802597:	6a 00                	push   $0x0
  802599:	ff 75 08             	pushl  0x8(%ebp)
  80259c:	6a 2d                	push   $0x2d
  80259e:	e8 ea f9 ff ff       	call   801f8d <syscall>
  8025a3:	83 c4 18             	add    $0x18,%esp
	return ;
  8025a6:	90                   	nop
}
  8025a7:	c9                   	leave  
  8025a8:	c3                   	ret    

008025a9 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  8025a9:	55                   	push   %ebp
  8025aa:	89 e5                	mov    %esp,%ebp
  8025ac:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  8025ad:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8025b0:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8025b3:	8b 55 0c             	mov    0xc(%ebp),%edx
  8025b6:	8b 45 08             	mov    0x8(%ebp),%eax
  8025b9:	6a 00                	push   $0x0
  8025bb:	53                   	push   %ebx
  8025bc:	51                   	push   %ecx
  8025bd:	52                   	push   %edx
  8025be:	50                   	push   %eax
  8025bf:	6a 2e                	push   $0x2e
  8025c1:	e8 c7 f9 ff ff       	call   801f8d <syscall>
  8025c6:	83 c4 18             	add    $0x18,%esp
}
  8025c9:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8025cc:	c9                   	leave  
  8025cd:	c3                   	ret    

008025ce <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  8025ce:	55                   	push   %ebp
  8025cf:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  8025d1:	8b 55 0c             	mov    0xc(%ebp),%edx
  8025d4:	8b 45 08             	mov    0x8(%ebp),%eax
  8025d7:	6a 00                	push   $0x0
  8025d9:	6a 00                	push   $0x0
  8025db:	6a 00                	push   $0x0
  8025dd:	52                   	push   %edx
  8025de:	50                   	push   %eax
  8025df:	6a 2f                	push   $0x2f
  8025e1:	e8 a7 f9 ff ff       	call   801f8d <syscall>
  8025e6:	83 c4 18             	add    $0x18,%esp
}
  8025e9:	c9                   	leave  
  8025ea:	c3                   	ret    

008025eb <print_mem_block_lists>:
//===========================
// PRINT MEM BLOCK LISTS:
//===========================

void print_mem_block_lists()
{
  8025eb:	55                   	push   %ebp
  8025ec:	89 e5                	mov    %esp,%ebp
  8025ee:	83 ec 18             	sub    $0x18,%esp
	cprintf("\n=========================================\n");
  8025f1:	83 ec 0c             	sub    $0xc,%esp
  8025f4:	68 60 40 80 00       	push   $0x804060
  8025f9:	e8 dd e6 ff ff       	call   800cdb <cprintf>
  8025fe:	83 c4 10             	add    $0x10,%esp
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
  802601:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nFreeMemBlocksList:\n");
  802608:	83 ec 0c             	sub    $0xc,%esp
  80260b:	68 8c 40 80 00       	push   $0x80408c
  802610:	e8 c6 e6 ff ff       	call   800cdb <cprintf>
  802615:	83 c4 10             	add    $0x10,%esp
	uint8 sorted = 1 ;
  802618:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &FreeMemBlocksList)
  80261c:	a1 38 51 80 00       	mov    0x805138,%eax
  802621:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802624:	eb 56                	jmp    80267c <print_mem_block_lists+0x91>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  802626:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80262a:	74 1c                	je     802648 <print_mem_block_lists+0x5d>
  80262c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80262f:	8b 50 08             	mov    0x8(%eax),%edx
  802632:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802635:	8b 48 08             	mov    0x8(%eax),%ecx
  802638:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80263b:	8b 40 0c             	mov    0xc(%eax),%eax
  80263e:	01 c8                	add    %ecx,%eax
  802640:	39 c2                	cmp    %eax,%edx
  802642:	73 04                	jae    802648 <print_mem_block_lists+0x5d>
			sorted = 0 ;
  802644:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  802648:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80264b:	8b 50 08             	mov    0x8(%eax),%edx
  80264e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802651:	8b 40 0c             	mov    0xc(%eax),%eax
  802654:	01 c2                	add    %eax,%edx
  802656:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802659:	8b 40 08             	mov    0x8(%eax),%eax
  80265c:	83 ec 04             	sub    $0x4,%esp
  80265f:	52                   	push   %edx
  802660:	50                   	push   %eax
  802661:	68 a1 40 80 00       	push   $0x8040a1
  802666:	e8 70 e6 ff ff       	call   800cdb <cprintf>
  80266b:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  80266e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802671:	89 45 f0             	mov    %eax,-0x10(%ebp)
	cprintf("\n=========================================\n");
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
	cprintf("\nFreeMemBlocksList:\n");
	uint8 sorted = 1 ;
	LIST_FOREACH(blk, &FreeMemBlocksList)
  802674:	a1 40 51 80 00       	mov    0x805140,%eax
  802679:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80267c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802680:	74 07                	je     802689 <print_mem_block_lists+0x9e>
  802682:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802685:	8b 00                	mov    (%eax),%eax
  802687:	eb 05                	jmp    80268e <print_mem_block_lists+0xa3>
  802689:	b8 00 00 00 00       	mov    $0x0,%eax
  80268e:	a3 40 51 80 00       	mov    %eax,0x805140
  802693:	a1 40 51 80 00       	mov    0x805140,%eax
  802698:	85 c0                	test   %eax,%eax
  80269a:	75 8a                	jne    802626 <print_mem_block_lists+0x3b>
  80269c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8026a0:	75 84                	jne    802626 <print_mem_block_lists+0x3b>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;
  8026a2:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  8026a6:	75 10                	jne    8026b8 <print_mem_block_lists+0xcd>
  8026a8:	83 ec 0c             	sub    $0xc,%esp
  8026ab:	68 b0 40 80 00       	push   $0x8040b0
  8026b0:	e8 26 e6 ff ff       	call   800cdb <cprintf>
  8026b5:	83 c4 10             	add    $0x10,%esp

	lastBlk = NULL ;
  8026b8:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nAllocMemBlocksList:\n");
  8026bf:	83 ec 0c             	sub    $0xc,%esp
  8026c2:	68 d4 40 80 00       	push   $0x8040d4
  8026c7:	e8 0f e6 ff ff       	call   800cdb <cprintf>
  8026cc:	83 c4 10             	add    $0x10,%esp
	sorted = 1 ;
  8026cf:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &AllocMemBlocksList)
  8026d3:	a1 40 50 80 00       	mov    0x805040,%eax
  8026d8:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8026db:	eb 56                	jmp    802733 <print_mem_block_lists+0x148>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  8026dd:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8026e1:	74 1c                	je     8026ff <print_mem_block_lists+0x114>
  8026e3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026e6:	8b 50 08             	mov    0x8(%eax),%edx
  8026e9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8026ec:	8b 48 08             	mov    0x8(%eax),%ecx
  8026ef:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8026f2:	8b 40 0c             	mov    0xc(%eax),%eax
  8026f5:	01 c8                	add    %ecx,%eax
  8026f7:	39 c2                	cmp    %eax,%edx
  8026f9:	73 04                	jae    8026ff <print_mem_block_lists+0x114>
			sorted = 0 ;
  8026fb:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  8026ff:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802702:	8b 50 08             	mov    0x8(%eax),%edx
  802705:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802708:	8b 40 0c             	mov    0xc(%eax),%eax
  80270b:	01 c2                	add    %eax,%edx
  80270d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802710:	8b 40 08             	mov    0x8(%eax),%eax
  802713:	83 ec 04             	sub    $0x4,%esp
  802716:	52                   	push   %edx
  802717:	50                   	push   %eax
  802718:	68 a1 40 80 00       	push   $0x8040a1
  80271d:	e8 b9 e5 ff ff       	call   800cdb <cprintf>
  802722:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  802725:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802728:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;

	lastBlk = NULL ;
	cprintf("\nAllocMemBlocksList:\n");
	sorted = 1 ;
	LIST_FOREACH(blk, &AllocMemBlocksList)
  80272b:	a1 48 50 80 00       	mov    0x805048,%eax
  802730:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802733:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802737:	74 07                	je     802740 <print_mem_block_lists+0x155>
  802739:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80273c:	8b 00                	mov    (%eax),%eax
  80273e:	eb 05                	jmp    802745 <print_mem_block_lists+0x15a>
  802740:	b8 00 00 00 00       	mov    $0x0,%eax
  802745:	a3 48 50 80 00       	mov    %eax,0x805048
  80274a:	a1 48 50 80 00       	mov    0x805048,%eax
  80274f:	85 c0                	test   %eax,%eax
  802751:	75 8a                	jne    8026dd <print_mem_block_lists+0xf2>
  802753:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802757:	75 84                	jne    8026dd <print_mem_block_lists+0xf2>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nAllocMemBlocksList is NOT SORTED!!\n") ;
  802759:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  80275d:	75 10                	jne    80276f <print_mem_block_lists+0x184>
  80275f:	83 ec 0c             	sub    $0xc,%esp
  802762:	68 ec 40 80 00       	push   $0x8040ec
  802767:	e8 6f e5 ff ff       	call   800cdb <cprintf>
  80276c:	83 c4 10             	add    $0x10,%esp
	cprintf("\n=========================================\n");
  80276f:	83 ec 0c             	sub    $0xc,%esp
  802772:	68 60 40 80 00       	push   $0x804060
  802777:	e8 5f e5 ff ff       	call   800cdb <cprintf>
  80277c:	83 c4 10             	add    $0x10,%esp

}
  80277f:	90                   	nop
  802780:	c9                   	leave  
  802781:	c3                   	ret    

00802782 <initialize_MemBlocksList>:

//===============================
// [1] INITIALIZE AVAILABLE LIST:
//===============================
void initialize_MemBlocksList(uint32 numOfBlocks)
{
  802782:	55                   	push   %ebp
  802783:	89 e5                	mov    %esp,%ebp
  802785:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] initialize_MemBlocksList
	// Write your code here, remove the panic and write your code
	//panic("initialize_MemBlocksList() is not implemented yet...!!");
	uint32 n = numOfBlocks;
  802788:	8b 45 08             	mov    0x8(%ebp),%eax
  80278b:	89 45 f0             	mov    %eax,-0x10(%ebp)

	LIST_INIT(&AvailableMemBlocksList);
  80278e:	c7 05 48 51 80 00 00 	movl   $0x0,0x805148
  802795:	00 00 00 
  802798:	c7 05 4c 51 80 00 00 	movl   $0x0,0x80514c
  80279f:	00 00 00 
  8027a2:	c7 05 54 51 80 00 00 	movl   $0x0,0x805154
  8027a9:	00 00 00 
	for(int i = 0; i<n;i++)
  8027ac:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  8027b3:	e9 9e 00 00 00       	jmp    802856 <initialize_MemBlocksList+0xd4>
	{
		LIST_INSERT_HEAD(&AvailableMemBlocksList, &(MemBlockNodes[i]));
  8027b8:	a1 50 50 80 00       	mov    0x805050,%eax
  8027bd:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8027c0:	c1 e2 04             	shl    $0x4,%edx
  8027c3:	01 d0                	add    %edx,%eax
  8027c5:	85 c0                	test   %eax,%eax
  8027c7:	75 14                	jne    8027dd <initialize_MemBlocksList+0x5b>
  8027c9:	83 ec 04             	sub    $0x4,%esp
  8027cc:	68 14 41 80 00       	push   $0x804114
  8027d1:	6a 47                	push   $0x47
  8027d3:	68 37 41 80 00       	push   $0x804137
  8027d8:	e8 4a e2 ff ff       	call   800a27 <_panic>
  8027dd:	a1 50 50 80 00       	mov    0x805050,%eax
  8027e2:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8027e5:	c1 e2 04             	shl    $0x4,%edx
  8027e8:	01 d0                	add    %edx,%eax
  8027ea:	8b 15 48 51 80 00    	mov    0x805148,%edx
  8027f0:	89 10                	mov    %edx,(%eax)
  8027f2:	8b 00                	mov    (%eax),%eax
  8027f4:	85 c0                	test   %eax,%eax
  8027f6:	74 18                	je     802810 <initialize_MemBlocksList+0x8e>
  8027f8:	a1 48 51 80 00       	mov    0x805148,%eax
  8027fd:	8b 15 50 50 80 00    	mov    0x805050,%edx
  802803:	8b 4d f4             	mov    -0xc(%ebp),%ecx
  802806:	c1 e1 04             	shl    $0x4,%ecx
  802809:	01 ca                	add    %ecx,%edx
  80280b:	89 50 04             	mov    %edx,0x4(%eax)
  80280e:	eb 12                	jmp    802822 <initialize_MemBlocksList+0xa0>
  802810:	a1 50 50 80 00       	mov    0x805050,%eax
  802815:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802818:	c1 e2 04             	shl    $0x4,%edx
  80281b:	01 d0                	add    %edx,%eax
  80281d:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802822:	a1 50 50 80 00       	mov    0x805050,%eax
  802827:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80282a:	c1 e2 04             	shl    $0x4,%edx
  80282d:	01 d0                	add    %edx,%eax
  80282f:	a3 48 51 80 00       	mov    %eax,0x805148
  802834:	a1 50 50 80 00       	mov    0x805050,%eax
  802839:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80283c:	c1 e2 04             	shl    $0x4,%edx
  80283f:	01 d0                	add    %edx,%eax
  802841:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802848:	a1 54 51 80 00       	mov    0x805154,%eax
  80284d:	40                   	inc    %eax
  80284e:	a3 54 51 80 00       	mov    %eax,0x805154
	// Write your code here, remove the panic and write your code
	//panic("initialize_MemBlocksList() is not implemented yet...!!");
	uint32 n = numOfBlocks;

	LIST_INIT(&AvailableMemBlocksList);
	for(int i = 0; i<n;i++)
  802853:	ff 45 f4             	incl   -0xc(%ebp)
  802856:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802859:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80285c:	0f 82 56 ff ff ff    	jb     8027b8 <initialize_MemBlocksList+0x36>
	{
		LIST_INSERT_HEAD(&AvailableMemBlocksList, &(MemBlockNodes[i]));
	}
}
  802862:	90                   	nop
  802863:	c9                   	leave  
  802864:	c3                   	ret    

00802865 <find_block>:

//===============================
// [2] FIND BLOCK:
//===============================
struct MemBlock *find_block(struct MemBlock_List *blockList, uint32 va)
{
  802865:	55                   	push   %ebp
  802866:	89 e5                	mov    %esp,%ebp
  802868:	83 ec 10             	sub    $0x10,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] find_block
	// Write your code here, remove the panic and write your code
	//panic("find_block() is not implemented yet...!!");
	uint32 virAddress = va;
  80286b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80286e:	89 45 f4             	mov    %eax,-0xc(%ebp)
	struct MemBlock* blk;
	int found = 0;
  802871:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	LIST_FOREACH(blk, &(AllocMemBlocksList))
  802878:	a1 40 50 80 00       	mov    0x805040,%eax
  80287d:	89 45 fc             	mov    %eax,-0x4(%ebp)
  802880:	eb 23                	jmp    8028a5 <find_block+0x40>
	{
		if(blk->sva == virAddress)
  802882:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802885:	8b 40 08             	mov    0x8(%eax),%eax
  802888:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  80288b:	75 09                	jne    802896 <find_block+0x31>
		{
			found = 1;
  80288d:	c7 45 f8 01 00 00 00 	movl   $0x1,-0x8(%ebp)
			break;
  802894:	eb 35                	jmp    8028cb <find_block+0x66>
		}
		else
		{
			found = 0;
  802896:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	//panic("find_block() is not implemented yet...!!");
	uint32 virAddress = va;
	struct MemBlock* blk;
	int found = 0;

	LIST_FOREACH(blk, &(AllocMemBlocksList))
  80289d:	a1 48 50 80 00       	mov    0x805048,%eax
  8028a2:	89 45 fc             	mov    %eax,-0x4(%ebp)
  8028a5:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8028a9:	74 07                	je     8028b2 <find_block+0x4d>
  8028ab:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8028ae:	8b 00                	mov    (%eax),%eax
  8028b0:	eb 05                	jmp    8028b7 <find_block+0x52>
  8028b2:	b8 00 00 00 00       	mov    $0x0,%eax
  8028b7:	a3 48 50 80 00       	mov    %eax,0x805048
  8028bc:	a1 48 50 80 00       	mov    0x805048,%eax
  8028c1:	85 c0                	test   %eax,%eax
  8028c3:	75 bd                	jne    802882 <find_block+0x1d>
  8028c5:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8028c9:	75 b7                	jne    802882 <find_block+0x1d>
		{
			found = 0;
			continue;
		}
	}
	if(found == 1)
  8028cb:	83 7d f8 01          	cmpl   $0x1,-0x8(%ebp)
  8028cf:	75 05                	jne    8028d6 <find_block+0x71>
	{
		return blk;
  8028d1:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8028d4:	eb 05                	jmp    8028db <find_block+0x76>
	}
	else
	{
		return NULL;
  8028d6:	b8 00 00 00 00       	mov    $0x0,%eax
	}
}
  8028db:	c9                   	leave  
  8028dc:	c3                   	ret    

008028dd <insert_sorted_allocList>:

//=========================================
// [3] INSERT BLOCK IN ALLOC LIST [SORTED]:
//=========================================
void insert_sorted_allocList(struct MemBlock *blockToInsert)
{
  8028dd:	55                   	push   %ebp
  8028de:	89 e5                	mov    %esp,%ebp
  8028e0:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] insert_sorted_allocList
	// Write your code here, remove the panic and write your code
	//panic("insert_sorted_allocList() is not implemented yet...!!");
	struct MemBlock* blk;
	struct MemBlock* newblk = blockToInsert;
  8028e3:	8b 45 08             	mov    0x8(%ebp),%eax
  8028e6:	89 45 f0             	mov    %eax,-0x10(%ebp)

	if((LIST_EMPTY(&AllocMemBlocksList)) || (newblk->sva < LIST_FIRST(&AllocMemBlocksList)->sva))
  8028e9:	a1 40 50 80 00       	mov    0x805040,%eax
  8028ee:	85 c0                	test   %eax,%eax
  8028f0:	74 12                	je     802904 <insert_sorted_allocList+0x27>
  8028f2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8028f5:	8b 50 08             	mov    0x8(%eax),%edx
  8028f8:	a1 40 50 80 00       	mov    0x805040,%eax
  8028fd:	8b 40 08             	mov    0x8(%eax),%eax
  802900:	39 c2                	cmp    %eax,%edx
  802902:	73 65                	jae    802969 <insert_sorted_allocList+0x8c>
	{
		LIST_INSERT_HEAD(&(AllocMemBlocksList), newblk);
  802904:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802908:	75 14                	jne    80291e <insert_sorted_allocList+0x41>
  80290a:	83 ec 04             	sub    $0x4,%esp
  80290d:	68 14 41 80 00       	push   $0x804114
  802912:	6a 7b                	push   $0x7b
  802914:	68 37 41 80 00       	push   $0x804137
  802919:	e8 09 e1 ff ff       	call   800a27 <_panic>
  80291e:	8b 15 40 50 80 00    	mov    0x805040,%edx
  802924:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802927:	89 10                	mov    %edx,(%eax)
  802929:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80292c:	8b 00                	mov    (%eax),%eax
  80292e:	85 c0                	test   %eax,%eax
  802930:	74 0d                	je     80293f <insert_sorted_allocList+0x62>
  802932:	a1 40 50 80 00       	mov    0x805040,%eax
  802937:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80293a:	89 50 04             	mov    %edx,0x4(%eax)
  80293d:	eb 08                	jmp    802947 <insert_sorted_allocList+0x6a>
  80293f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802942:	a3 44 50 80 00       	mov    %eax,0x805044
  802947:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80294a:	a3 40 50 80 00       	mov    %eax,0x805040
  80294f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802952:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802959:	a1 4c 50 80 00       	mov    0x80504c,%eax
  80295e:	40                   	inc    %eax
  80295f:	a3 4c 50 80 00       	mov    %eax,0x80504c
  802964:	e9 5f 01 00 00       	jmp    802ac8 <insert_sorted_allocList+0x1eb>
	}
	else if(newblk->sva > LIST_LAST(&AllocMemBlocksList)->sva)
  802969:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80296c:	8b 50 08             	mov    0x8(%eax),%edx
  80296f:	a1 44 50 80 00       	mov    0x805044,%eax
  802974:	8b 40 08             	mov    0x8(%eax),%eax
  802977:	39 c2                	cmp    %eax,%edx
  802979:	76 65                	jbe    8029e0 <insert_sorted_allocList+0x103>
	{
		LIST_INSERT_TAIL(&AllocMemBlocksList, newblk);
  80297b:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80297f:	75 14                	jne    802995 <insert_sorted_allocList+0xb8>
  802981:	83 ec 04             	sub    $0x4,%esp
  802984:	68 50 41 80 00       	push   $0x804150
  802989:	6a 7f                	push   $0x7f
  80298b:	68 37 41 80 00       	push   $0x804137
  802990:	e8 92 e0 ff ff       	call   800a27 <_panic>
  802995:	8b 15 44 50 80 00    	mov    0x805044,%edx
  80299b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80299e:	89 50 04             	mov    %edx,0x4(%eax)
  8029a1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8029a4:	8b 40 04             	mov    0x4(%eax),%eax
  8029a7:	85 c0                	test   %eax,%eax
  8029a9:	74 0c                	je     8029b7 <insert_sorted_allocList+0xda>
  8029ab:	a1 44 50 80 00       	mov    0x805044,%eax
  8029b0:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8029b3:	89 10                	mov    %edx,(%eax)
  8029b5:	eb 08                	jmp    8029bf <insert_sorted_allocList+0xe2>
  8029b7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8029ba:	a3 40 50 80 00       	mov    %eax,0x805040
  8029bf:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8029c2:	a3 44 50 80 00       	mov    %eax,0x805044
  8029c7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8029ca:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8029d0:	a1 4c 50 80 00       	mov    0x80504c,%eax
  8029d5:	40                   	inc    %eax
  8029d6:	a3 4c 50 80 00       	mov    %eax,0x80504c
				LIST_INSERT_AFTER(&AllocMemBlocksList, blk, newblk);
				break;
			}
		}
	}
}
  8029db:	e9 e8 00 00 00       	jmp    802ac8 <insert_sorted_allocList+0x1eb>
	{
		LIST_INSERT_TAIL(&AllocMemBlocksList, newblk);
	}
	else
	{
		LIST_FOREACH(blk, &AllocMemBlocksList)
  8029e0:	a1 40 50 80 00       	mov    0x805040,%eax
  8029e5:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8029e8:	e9 ab 00 00 00       	jmp    802a98 <insert_sorted_allocList+0x1bb>
		{
			if(blk->prev_next_info.le_next != NULL && newblk->sva > blk->sva  && newblk->sva < blk->prev_next_info.le_next->sva)
  8029ed:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029f0:	8b 00                	mov    (%eax),%eax
  8029f2:	85 c0                	test   %eax,%eax
  8029f4:	0f 84 96 00 00 00    	je     802a90 <insert_sorted_allocList+0x1b3>
  8029fa:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8029fd:	8b 50 08             	mov    0x8(%eax),%edx
  802a00:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a03:	8b 40 08             	mov    0x8(%eax),%eax
  802a06:	39 c2                	cmp    %eax,%edx
  802a08:	0f 86 82 00 00 00    	jbe    802a90 <insert_sorted_allocList+0x1b3>
  802a0e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a11:	8b 50 08             	mov    0x8(%eax),%edx
  802a14:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a17:	8b 00                	mov    (%eax),%eax
  802a19:	8b 40 08             	mov    0x8(%eax),%eax
  802a1c:	39 c2                	cmp    %eax,%edx
  802a1e:	73 70                	jae    802a90 <insert_sorted_allocList+0x1b3>
			{
				LIST_INSERT_AFTER(&AllocMemBlocksList, blk, newblk);
  802a20:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802a24:	74 06                	je     802a2c <insert_sorted_allocList+0x14f>
  802a26:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802a2a:	75 17                	jne    802a43 <insert_sorted_allocList+0x166>
  802a2c:	83 ec 04             	sub    $0x4,%esp
  802a2f:	68 74 41 80 00       	push   $0x804174
  802a34:	68 87 00 00 00       	push   $0x87
  802a39:	68 37 41 80 00       	push   $0x804137
  802a3e:	e8 e4 df ff ff       	call   800a27 <_panic>
  802a43:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a46:	8b 10                	mov    (%eax),%edx
  802a48:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a4b:	89 10                	mov    %edx,(%eax)
  802a4d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a50:	8b 00                	mov    (%eax),%eax
  802a52:	85 c0                	test   %eax,%eax
  802a54:	74 0b                	je     802a61 <insert_sorted_allocList+0x184>
  802a56:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a59:	8b 00                	mov    (%eax),%eax
  802a5b:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802a5e:	89 50 04             	mov    %edx,0x4(%eax)
  802a61:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a64:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802a67:	89 10                	mov    %edx,(%eax)
  802a69:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a6c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802a6f:	89 50 04             	mov    %edx,0x4(%eax)
  802a72:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a75:	8b 00                	mov    (%eax),%eax
  802a77:	85 c0                	test   %eax,%eax
  802a79:	75 08                	jne    802a83 <insert_sorted_allocList+0x1a6>
  802a7b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a7e:	a3 44 50 80 00       	mov    %eax,0x805044
  802a83:	a1 4c 50 80 00       	mov    0x80504c,%eax
  802a88:	40                   	inc    %eax
  802a89:	a3 4c 50 80 00       	mov    %eax,0x80504c
				break;
  802a8e:	eb 38                	jmp    802ac8 <insert_sorted_allocList+0x1eb>
	{
		LIST_INSERT_TAIL(&AllocMemBlocksList, newblk);
	}
	else
	{
		LIST_FOREACH(blk, &AllocMemBlocksList)
  802a90:	a1 48 50 80 00       	mov    0x805048,%eax
  802a95:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802a98:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802a9c:	74 07                	je     802aa5 <insert_sorted_allocList+0x1c8>
  802a9e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802aa1:	8b 00                	mov    (%eax),%eax
  802aa3:	eb 05                	jmp    802aaa <insert_sorted_allocList+0x1cd>
  802aa5:	b8 00 00 00 00       	mov    $0x0,%eax
  802aaa:	a3 48 50 80 00       	mov    %eax,0x805048
  802aaf:	a1 48 50 80 00       	mov    0x805048,%eax
  802ab4:	85 c0                	test   %eax,%eax
  802ab6:	0f 85 31 ff ff ff    	jne    8029ed <insert_sorted_allocList+0x110>
  802abc:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802ac0:	0f 85 27 ff ff ff    	jne    8029ed <insert_sorted_allocList+0x110>
				LIST_INSERT_AFTER(&AllocMemBlocksList, blk, newblk);
				break;
			}
		}
	}
}
  802ac6:	eb 00                	jmp    802ac8 <insert_sorted_allocList+0x1eb>
  802ac8:	90                   	nop
  802ac9:	c9                   	leave  
  802aca:	c3                   	ret    

00802acb <alloc_block_FF>:

//=========================================
// [4] ALLOCATE BLOCK BY FIRST FIT:
//=========================================
struct MemBlock *alloc_block_FF(uint32 size)
{
  802acb:	55                   	push   %ebp
  802acc:	89 e5                	mov    %esp,%ebp
  802ace:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_FF
	// Write your code here, remove the panic and write your code
	//panic("alloc_block_FF() is not implemented yet...!!");
	uint32 versize = size;
  802ad1:	8b 45 08             	mov    0x8(%ebp),%eax
  802ad4:	89 45 f0             	mov    %eax,-0x10(%ebp)
	struct MemBlock* blk;
	struct MemBlock* newblk = LIST_FIRST(&AvailableMemBlocksList);
  802ad7:	a1 48 51 80 00       	mov    0x805148,%eax
  802adc:	89 45 ec             	mov    %eax,-0x14(%ebp)

	LIST_FOREACH(blk,&FreeMemBlocksList)
  802adf:	a1 38 51 80 00       	mov    0x805138,%eax
  802ae4:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802ae7:	e9 77 01 00 00       	jmp    802c63 <alloc_block_FF+0x198>
	{
		if(blk->size == versize)
  802aec:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802aef:	8b 40 0c             	mov    0xc(%eax),%eax
  802af2:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  802af5:	0f 85 8a 00 00 00    	jne    802b85 <alloc_block_FF+0xba>
		{
			LIST_REMOVE(&FreeMemBlocksList,blk);
  802afb:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802aff:	75 17                	jne    802b18 <alloc_block_FF+0x4d>
  802b01:	83 ec 04             	sub    $0x4,%esp
  802b04:	68 a8 41 80 00       	push   $0x8041a8
  802b09:	68 9e 00 00 00       	push   $0x9e
  802b0e:	68 37 41 80 00       	push   $0x804137
  802b13:	e8 0f df ff ff       	call   800a27 <_panic>
  802b18:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b1b:	8b 00                	mov    (%eax),%eax
  802b1d:	85 c0                	test   %eax,%eax
  802b1f:	74 10                	je     802b31 <alloc_block_FF+0x66>
  802b21:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b24:	8b 00                	mov    (%eax),%eax
  802b26:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802b29:	8b 52 04             	mov    0x4(%edx),%edx
  802b2c:	89 50 04             	mov    %edx,0x4(%eax)
  802b2f:	eb 0b                	jmp    802b3c <alloc_block_FF+0x71>
  802b31:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b34:	8b 40 04             	mov    0x4(%eax),%eax
  802b37:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802b3c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b3f:	8b 40 04             	mov    0x4(%eax),%eax
  802b42:	85 c0                	test   %eax,%eax
  802b44:	74 0f                	je     802b55 <alloc_block_FF+0x8a>
  802b46:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b49:	8b 40 04             	mov    0x4(%eax),%eax
  802b4c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802b4f:	8b 12                	mov    (%edx),%edx
  802b51:	89 10                	mov    %edx,(%eax)
  802b53:	eb 0a                	jmp    802b5f <alloc_block_FF+0x94>
  802b55:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b58:	8b 00                	mov    (%eax),%eax
  802b5a:	a3 38 51 80 00       	mov    %eax,0x805138
  802b5f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b62:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802b68:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b6b:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802b72:	a1 44 51 80 00       	mov    0x805144,%eax
  802b77:	48                   	dec    %eax
  802b78:	a3 44 51 80 00       	mov    %eax,0x805144
			return blk;
  802b7d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b80:	e9 11 01 00 00       	jmp    802c96 <alloc_block_FF+0x1cb>
		}
		else if(blk->size > versize)
  802b85:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b88:	8b 40 0c             	mov    0xc(%eax),%eax
  802b8b:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  802b8e:	0f 86 c7 00 00 00    	jbe    802c5b <alloc_block_FF+0x190>
		{
			LIST_REMOVE(&AvailableMemBlocksList,newblk);
  802b94:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802b98:	75 17                	jne    802bb1 <alloc_block_FF+0xe6>
  802b9a:	83 ec 04             	sub    $0x4,%esp
  802b9d:	68 a8 41 80 00       	push   $0x8041a8
  802ba2:	68 a3 00 00 00       	push   $0xa3
  802ba7:	68 37 41 80 00       	push   $0x804137
  802bac:	e8 76 de ff ff       	call   800a27 <_panic>
  802bb1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802bb4:	8b 00                	mov    (%eax),%eax
  802bb6:	85 c0                	test   %eax,%eax
  802bb8:	74 10                	je     802bca <alloc_block_FF+0xff>
  802bba:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802bbd:	8b 00                	mov    (%eax),%eax
  802bbf:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802bc2:	8b 52 04             	mov    0x4(%edx),%edx
  802bc5:	89 50 04             	mov    %edx,0x4(%eax)
  802bc8:	eb 0b                	jmp    802bd5 <alloc_block_FF+0x10a>
  802bca:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802bcd:	8b 40 04             	mov    0x4(%eax),%eax
  802bd0:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802bd5:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802bd8:	8b 40 04             	mov    0x4(%eax),%eax
  802bdb:	85 c0                	test   %eax,%eax
  802bdd:	74 0f                	je     802bee <alloc_block_FF+0x123>
  802bdf:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802be2:	8b 40 04             	mov    0x4(%eax),%eax
  802be5:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802be8:	8b 12                	mov    (%edx),%edx
  802bea:	89 10                	mov    %edx,(%eax)
  802bec:	eb 0a                	jmp    802bf8 <alloc_block_FF+0x12d>
  802bee:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802bf1:	8b 00                	mov    (%eax),%eax
  802bf3:	a3 48 51 80 00       	mov    %eax,0x805148
  802bf8:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802bfb:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802c01:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802c04:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802c0b:	a1 54 51 80 00       	mov    0x805154,%eax
  802c10:	48                   	dec    %eax
  802c11:	a3 54 51 80 00       	mov    %eax,0x805154
			newblk->size = versize;
  802c16:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802c19:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802c1c:	89 50 0c             	mov    %edx,0xc(%eax)
			blk->size = blk->size-versize;
  802c1f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c22:	8b 40 0c             	mov    0xc(%eax),%eax
  802c25:	2b 45 f0             	sub    -0x10(%ebp),%eax
  802c28:	89 c2                	mov    %eax,%edx
  802c2a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c2d:	89 50 0c             	mov    %edx,0xc(%eax)
			uint32 newveradd = blk->sva;
  802c30:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c33:	8b 40 08             	mov    0x8(%eax),%eax
  802c36:	89 45 e8             	mov    %eax,-0x18(%ebp)
			blk->sva+=newblk->size;
  802c39:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c3c:	8b 50 08             	mov    0x8(%eax),%edx
  802c3f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802c42:	8b 40 0c             	mov    0xc(%eax),%eax
  802c45:	01 c2                	add    %eax,%edx
  802c47:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c4a:	89 50 08             	mov    %edx,0x8(%eax)
			newblk->sva = newveradd;
  802c4d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802c50:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802c53:	89 50 08             	mov    %edx,0x8(%eax)
			return newblk;
  802c56:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802c59:	eb 3b                	jmp    802c96 <alloc_block_FF+0x1cb>
	//panic("alloc_block_FF() is not implemented yet...!!");
	uint32 versize = size;
	struct MemBlock* blk;
	struct MemBlock* newblk = LIST_FIRST(&AvailableMemBlocksList);

	LIST_FOREACH(blk,&FreeMemBlocksList)
  802c5b:	a1 40 51 80 00       	mov    0x805140,%eax
  802c60:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802c63:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802c67:	74 07                	je     802c70 <alloc_block_FF+0x1a5>
  802c69:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c6c:	8b 00                	mov    (%eax),%eax
  802c6e:	eb 05                	jmp    802c75 <alloc_block_FF+0x1aa>
  802c70:	b8 00 00 00 00       	mov    $0x0,%eax
  802c75:	a3 40 51 80 00       	mov    %eax,0x805140
  802c7a:	a1 40 51 80 00       	mov    0x805140,%eax
  802c7f:	85 c0                	test   %eax,%eax
  802c81:	0f 85 65 fe ff ff    	jne    802aec <alloc_block_FF+0x21>
  802c87:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802c8b:	0f 85 5b fe ff ff    	jne    802aec <alloc_block_FF+0x21>
			blk->sva+=newblk->size;
			newblk->sva = newveradd;
			return newblk;
		}
	}
	return NULL;
  802c91:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802c96:	c9                   	leave  
  802c97:	c3                   	ret    

00802c98 <alloc_block_BF>:

//=========================================
// [5] ALLOCATE BLOCK BY BEST FIT:
//=========================================
struct MemBlock *alloc_block_BF(uint32 size)
{
  802c98:	55                   	push   %ebp
  802c99:	89 e5                	mov    %esp,%ebp
  802c9b:	83 ec 28             	sub    $0x28,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_BF
	// Write your code here, remove the panic and write your code
	//panic("alloc_block_BF() is not implemented yet...!!");
	uint32 versize=size;
  802c9e:	8b 45 08             	mov    0x8(%ebp),%eax
  802ca1:	89 45 e8             	mov    %eax,-0x18(%ebp)
	struct MemBlock* blk;
	struct MemBlock* newblk=LIST_FIRST(&AvailableMemBlocksList);
  802ca4:	a1 48 51 80 00       	mov    0x805148,%eax
  802ca9:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	uint32 newveradd;
	uint32 newsize;
	int size_free = LIST_SIZE(&FreeMemBlocksList);
  802cac:	a1 44 51 80 00       	mov    0x805144,%eax
  802cb1:	89 45 e0             	mov    %eax,-0x20(%ebp)

	LIST_FOREACH(blk, &FreeMemBlocksList)
  802cb4:	a1 38 51 80 00       	mov    0x805138,%eax
  802cb9:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802cbc:	e9 a1 00 00 00       	jmp    802d62 <alloc_block_BF+0xca>
	{
		if(blk->size == versize)
  802cc1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cc4:	8b 40 0c             	mov    0xc(%eax),%eax
  802cc7:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  802cca:	0f 85 8a 00 00 00    	jne    802d5a <alloc_block_BF+0xc2>
		{
			LIST_REMOVE(&FreeMemBlocksList, blk);
  802cd0:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802cd4:	75 17                	jne    802ced <alloc_block_BF+0x55>
  802cd6:	83 ec 04             	sub    $0x4,%esp
  802cd9:	68 a8 41 80 00       	push   $0x8041a8
  802cde:	68 c2 00 00 00       	push   $0xc2
  802ce3:	68 37 41 80 00       	push   $0x804137
  802ce8:	e8 3a dd ff ff       	call   800a27 <_panic>
  802ced:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cf0:	8b 00                	mov    (%eax),%eax
  802cf2:	85 c0                	test   %eax,%eax
  802cf4:	74 10                	je     802d06 <alloc_block_BF+0x6e>
  802cf6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cf9:	8b 00                	mov    (%eax),%eax
  802cfb:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802cfe:	8b 52 04             	mov    0x4(%edx),%edx
  802d01:	89 50 04             	mov    %edx,0x4(%eax)
  802d04:	eb 0b                	jmp    802d11 <alloc_block_BF+0x79>
  802d06:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d09:	8b 40 04             	mov    0x4(%eax),%eax
  802d0c:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802d11:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d14:	8b 40 04             	mov    0x4(%eax),%eax
  802d17:	85 c0                	test   %eax,%eax
  802d19:	74 0f                	je     802d2a <alloc_block_BF+0x92>
  802d1b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d1e:	8b 40 04             	mov    0x4(%eax),%eax
  802d21:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802d24:	8b 12                	mov    (%edx),%edx
  802d26:	89 10                	mov    %edx,(%eax)
  802d28:	eb 0a                	jmp    802d34 <alloc_block_BF+0x9c>
  802d2a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d2d:	8b 00                	mov    (%eax),%eax
  802d2f:	a3 38 51 80 00       	mov    %eax,0x805138
  802d34:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d37:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802d3d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d40:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802d47:	a1 44 51 80 00       	mov    0x805144,%eax
  802d4c:	48                   	dec    %eax
  802d4d:	a3 44 51 80 00       	mov    %eax,0x805144
			return blk;
  802d52:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d55:	e9 11 02 00 00       	jmp    802f6b <alloc_block_BF+0x2d3>
	struct MemBlock* newblk=LIST_FIRST(&AvailableMemBlocksList);
	uint32 newveradd;
	uint32 newsize;
	int size_free = LIST_SIZE(&FreeMemBlocksList);

	LIST_FOREACH(blk, &FreeMemBlocksList)
  802d5a:	a1 40 51 80 00       	mov    0x805140,%eax
  802d5f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802d62:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802d66:	74 07                	je     802d6f <alloc_block_BF+0xd7>
  802d68:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d6b:	8b 00                	mov    (%eax),%eax
  802d6d:	eb 05                	jmp    802d74 <alloc_block_BF+0xdc>
  802d6f:	b8 00 00 00 00       	mov    $0x0,%eax
  802d74:	a3 40 51 80 00       	mov    %eax,0x805140
  802d79:	a1 40 51 80 00       	mov    0x805140,%eax
  802d7e:	85 c0                	test   %eax,%eax
  802d80:	0f 85 3b ff ff ff    	jne    802cc1 <alloc_block_BF+0x29>
  802d86:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802d8a:	0f 85 31 ff ff ff    	jne    802cc1 <alloc_block_BF+0x29>
		{
			LIST_REMOVE(&FreeMemBlocksList, blk);
			return blk;
		}
	}
	LIST_FOREACH(blk, &FreeMemBlocksList)
  802d90:	a1 38 51 80 00       	mov    0x805138,%eax
  802d95:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802d98:	eb 27                	jmp    802dc1 <alloc_block_BF+0x129>
	{
		if(blk->size > versize)
  802d9a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d9d:	8b 40 0c             	mov    0xc(%eax),%eax
  802da0:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  802da3:	76 14                	jbe    802db9 <alloc_block_BF+0x121>
		{
			newsize = blk->size;
  802da5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802da8:	8b 40 0c             	mov    0xc(%eax),%eax
  802dab:	89 45 ec             	mov    %eax,-0x14(%ebp)
			newveradd = blk->sva;
  802dae:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802db1:	8b 40 08             	mov    0x8(%eax),%eax
  802db4:	89 45 f0             	mov    %eax,-0x10(%ebp)
			break;
  802db7:	eb 2e                	jmp    802de7 <alloc_block_BF+0x14f>
		{
			LIST_REMOVE(&FreeMemBlocksList, blk);
			return blk;
		}
	}
	LIST_FOREACH(blk, &FreeMemBlocksList)
  802db9:	a1 40 51 80 00       	mov    0x805140,%eax
  802dbe:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802dc1:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802dc5:	74 07                	je     802dce <alloc_block_BF+0x136>
  802dc7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802dca:	8b 00                	mov    (%eax),%eax
  802dcc:	eb 05                	jmp    802dd3 <alloc_block_BF+0x13b>
  802dce:	b8 00 00 00 00       	mov    $0x0,%eax
  802dd3:	a3 40 51 80 00       	mov    %eax,0x805140
  802dd8:	a1 40 51 80 00       	mov    0x805140,%eax
  802ddd:	85 c0                	test   %eax,%eax
  802ddf:	75 b9                	jne    802d9a <alloc_block_BF+0x102>
  802de1:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802de5:	75 b3                	jne    802d9a <alloc_block_BF+0x102>
			newsize = blk->size;
			newveradd = blk->sva;
			break;
		}
	}
	LIST_FOREACH(blk, &FreeMemBlocksList)
  802de7:	a1 38 51 80 00       	mov    0x805138,%eax
  802dec:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802def:	eb 30                	jmp    802e21 <alloc_block_BF+0x189>
	{
		if(newsize > blk->size && blk->size > versize)
  802df1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802df4:	8b 40 0c             	mov    0xc(%eax),%eax
  802df7:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  802dfa:	73 1d                	jae    802e19 <alloc_block_BF+0x181>
  802dfc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802dff:	8b 40 0c             	mov    0xc(%eax),%eax
  802e02:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  802e05:	76 12                	jbe    802e19 <alloc_block_BF+0x181>
		{
	       newsize = blk->size;
  802e07:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e0a:	8b 40 0c             	mov    0xc(%eax),%eax
  802e0d:	89 45 ec             	mov    %eax,-0x14(%ebp)
		   newveradd = blk->sva;
  802e10:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e13:	8b 40 08             	mov    0x8(%eax),%eax
  802e16:	89 45 f0             	mov    %eax,-0x10(%ebp)
			newsize = blk->size;
			newveradd = blk->sva;
			break;
		}
	}
	LIST_FOREACH(blk, &FreeMemBlocksList)
  802e19:	a1 40 51 80 00       	mov    0x805140,%eax
  802e1e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802e21:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802e25:	74 07                	je     802e2e <alloc_block_BF+0x196>
  802e27:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e2a:	8b 00                	mov    (%eax),%eax
  802e2c:	eb 05                	jmp    802e33 <alloc_block_BF+0x19b>
  802e2e:	b8 00 00 00 00       	mov    $0x0,%eax
  802e33:	a3 40 51 80 00       	mov    %eax,0x805140
  802e38:	a1 40 51 80 00       	mov    0x805140,%eax
  802e3d:	85 c0                	test   %eax,%eax
  802e3f:	75 b0                	jne    802df1 <alloc_block_BF+0x159>
  802e41:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802e45:	75 aa                	jne    802df1 <alloc_block_BF+0x159>
		{
	       newsize = blk->size;
		   newveradd = blk->sva;
		}
	}
	LIST_FOREACH(blk, &FreeMemBlocksList)
  802e47:	a1 38 51 80 00       	mov    0x805138,%eax
  802e4c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802e4f:	e9 e4 00 00 00       	jmp    802f38 <alloc_block_BF+0x2a0>
	{
		if(blk->size == newsize && blk->sva == newveradd)
  802e54:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e57:	8b 40 0c             	mov    0xc(%eax),%eax
  802e5a:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  802e5d:	0f 85 cd 00 00 00    	jne    802f30 <alloc_block_BF+0x298>
  802e63:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e66:	8b 40 08             	mov    0x8(%eax),%eax
  802e69:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  802e6c:	0f 85 be 00 00 00    	jne    802f30 <alloc_block_BF+0x298>
		{
			LIST_REMOVE(&AvailableMemBlocksList, newblk);
  802e72:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  802e76:	75 17                	jne    802e8f <alloc_block_BF+0x1f7>
  802e78:	83 ec 04             	sub    $0x4,%esp
  802e7b:	68 a8 41 80 00       	push   $0x8041a8
  802e80:	68 db 00 00 00       	push   $0xdb
  802e85:	68 37 41 80 00       	push   $0x804137
  802e8a:	e8 98 db ff ff       	call   800a27 <_panic>
  802e8f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802e92:	8b 00                	mov    (%eax),%eax
  802e94:	85 c0                	test   %eax,%eax
  802e96:	74 10                	je     802ea8 <alloc_block_BF+0x210>
  802e98:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802e9b:	8b 00                	mov    (%eax),%eax
  802e9d:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802ea0:	8b 52 04             	mov    0x4(%edx),%edx
  802ea3:	89 50 04             	mov    %edx,0x4(%eax)
  802ea6:	eb 0b                	jmp    802eb3 <alloc_block_BF+0x21b>
  802ea8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802eab:	8b 40 04             	mov    0x4(%eax),%eax
  802eae:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802eb3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802eb6:	8b 40 04             	mov    0x4(%eax),%eax
  802eb9:	85 c0                	test   %eax,%eax
  802ebb:	74 0f                	je     802ecc <alloc_block_BF+0x234>
  802ebd:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802ec0:	8b 40 04             	mov    0x4(%eax),%eax
  802ec3:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802ec6:	8b 12                	mov    (%edx),%edx
  802ec8:	89 10                	mov    %edx,(%eax)
  802eca:	eb 0a                	jmp    802ed6 <alloc_block_BF+0x23e>
  802ecc:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802ecf:	8b 00                	mov    (%eax),%eax
  802ed1:	a3 48 51 80 00       	mov    %eax,0x805148
  802ed6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802ed9:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802edf:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802ee2:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802ee9:	a1 54 51 80 00       	mov    0x805154,%eax
  802eee:	48                   	dec    %eax
  802eef:	a3 54 51 80 00       	mov    %eax,0x805154
			newblk->size = versize;
  802ef4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802ef7:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802efa:	89 50 0c             	mov    %edx,0xc(%eax)
			newblk->sva = newveradd;
  802efd:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802f00:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802f03:	89 50 08             	mov    %edx,0x8(%eax)
			blk->size = blk->size - versize;
  802f06:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f09:	8b 40 0c             	mov    0xc(%eax),%eax
  802f0c:	2b 45 e8             	sub    -0x18(%ebp),%eax
  802f0f:	89 c2                	mov    %eax,%edx
  802f11:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f14:	89 50 0c             	mov    %edx,0xc(%eax)
			blk->sva+= newblk->size;
  802f17:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f1a:	8b 50 08             	mov    0x8(%eax),%edx
  802f1d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802f20:	8b 40 0c             	mov    0xc(%eax),%eax
  802f23:	01 c2                	add    %eax,%edx
  802f25:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f28:	89 50 08             	mov    %edx,0x8(%eax)
			return newblk;
  802f2b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802f2e:	eb 3b                	jmp    802f6b <alloc_block_BF+0x2d3>
		{
	       newsize = blk->size;
		   newveradd = blk->sva;
		}
	}
	LIST_FOREACH(blk, &FreeMemBlocksList)
  802f30:	a1 40 51 80 00       	mov    0x805140,%eax
  802f35:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802f38:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802f3c:	74 07                	je     802f45 <alloc_block_BF+0x2ad>
  802f3e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f41:	8b 00                	mov    (%eax),%eax
  802f43:	eb 05                	jmp    802f4a <alloc_block_BF+0x2b2>
  802f45:	b8 00 00 00 00       	mov    $0x0,%eax
  802f4a:	a3 40 51 80 00       	mov    %eax,0x805140
  802f4f:	a1 40 51 80 00       	mov    0x805140,%eax
  802f54:	85 c0                	test   %eax,%eax
  802f56:	0f 85 f8 fe ff ff    	jne    802e54 <alloc_block_BF+0x1bc>
  802f5c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802f60:	0f 85 ee fe ff ff    	jne    802e54 <alloc_block_BF+0x1bc>
			blk->size = blk->size - versize;
			blk->sva+= newblk->size;
			return newblk;
		}
	}
	return NULL;
  802f66:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802f6b:	c9                   	leave  
  802f6c:	c3                   	ret    

00802f6d <alloc_block_NF>:
//=========================================
// [7] ALLOCATE BLOCK BY NEXT FIT:
//=========================================
struct MemBlock *last_allocate;
struct MemBlock *alloc_block_NF(uint32 size)
{
  802f6d:	55                   	push   %ebp
  802f6e:	89 e5                	mov    %esp,%ebp
  802f70:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1 - BONUS] [DYNAMIC ALLOCATOR] alloc_block_NF
	// Write your code here, remove the panic and write your code
	//panic("alloc_block_NF() is not implemented yet...!!");
	uint32 versize = size;
  802f73:	8b 45 08             	mov    0x8(%ebp),%eax
  802f76:	89 45 f0             	mov    %eax,-0x10(%ebp)
	struct MemBlock* blk;
	struct MemBlock* newblk = LIST_FIRST(&AvailableMemBlocksList);
  802f79:	a1 48 51 80 00       	mov    0x805148,%eax
  802f7e:	89 45 ec             	mov    %eax,-0x14(%ebp)

	LIST_FOREACH(blk,&FreeMemBlocksList)
  802f81:	a1 38 51 80 00       	mov    0x805138,%eax
  802f86:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802f89:	e9 77 01 00 00       	jmp    803105 <alloc_block_NF+0x198>
	{
		if(blk->size == versize)
  802f8e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f91:	8b 40 0c             	mov    0xc(%eax),%eax
  802f94:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  802f97:	0f 85 8a 00 00 00    	jne    803027 <alloc_block_NF+0xba>
		{
			LIST_REMOVE(&FreeMemBlocksList,blk);
  802f9d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802fa1:	75 17                	jne    802fba <alloc_block_NF+0x4d>
  802fa3:	83 ec 04             	sub    $0x4,%esp
  802fa6:	68 a8 41 80 00       	push   $0x8041a8
  802fab:	68 f7 00 00 00       	push   $0xf7
  802fb0:	68 37 41 80 00       	push   $0x804137
  802fb5:	e8 6d da ff ff       	call   800a27 <_panic>
  802fba:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802fbd:	8b 00                	mov    (%eax),%eax
  802fbf:	85 c0                	test   %eax,%eax
  802fc1:	74 10                	je     802fd3 <alloc_block_NF+0x66>
  802fc3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802fc6:	8b 00                	mov    (%eax),%eax
  802fc8:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802fcb:	8b 52 04             	mov    0x4(%edx),%edx
  802fce:	89 50 04             	mov    %edx,0x4(%eax)
  802fd1:	eb 0b                	jmp    802fde <alloc_block_NF+0x71>
  802fd3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802fd6:	8b 40 04             	mov    0x4(%eax),%eax
  802fd9:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802fde:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802fe1:	8b 40 04             	mov    0x4(%eax),%eax
  802fe4:	85 c0                	test   %eax,%eax
  802fe6:	74 0f                	je     802ff7 <alloc_block_NF+0x8a>
  802fe8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802feb:	8b 40 04             	mov    0x4(%eax),%eax
  802fee:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802ff1:	8b 12                	mov    (%edx),%edx
  802ff3:	89 10                	mov    %edx,(%eax)
  802ff5:	eb 0a                	jmp    803001 <alloc_block_NF+0x94>
  802ff7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ffa:	8b 00                	mov    (%eax),%eax
  802ffc:	a3 38 51 80 00       	mov    %eax,0x805138
  803001:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803004:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80300a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80300d:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803014:	a1 44 51 80 00       	mov    0x805144,%eax
  803019:	48                   	dec    %eax
  80301a:	a3 44 51 80 00       	mov    %eax,0x805144
			return blk;
  80301f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803022:	e9 11 01 00 00       	jmp    803138 <alloc_block_NF+0x1cb>
		}
		else if(blk->size > versize)
  803027:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80302a:	8b 40 0c             	mov    0xc(%eax),%eax
  80302d:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  803030:	0f 86 c7 00 00 00    	jbe    8030fd <alloc_block_NF+0x190>
		{
			LIST_REMOVE(&AvailableMemBlocksList,newblk);
  803036:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  80303a:	75 17                	jne    803053 <alloc_block_NF+0xe6>
  80303c:	83 ec 04             	sub    $0x4,%esp
  80303f:	68 a8 41 80 00       	push   $0x8041a8
  803044:	68 fc 00 00 00       	push   $0xfc
  803049:	68 37 41 80 00       	push   $0x804137
  80304e:	e8 d4 d9 ff ff       	call   800a27 <_panic>
  803053:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803056:	8b 00                	mov    (%eax),%eax
  803058:	85 c0                	test   %eax,%eax
  80305a:	74 10                	je     80306c <alloc_block_NF+0xff>
  80305c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80305f:	8b 00                	mov    (%eax),%eax
  803061:	8b 55 ec             	mov    -0x14(%ebp),%edx
  803064:	8b 52 04             	mov    0x4(%edx),%edx
  803067:	89 50 04             	mov    %edx,0x4(%eax)
  80306a:	eb 0b                	jmp    803077 <alloc_block_NF+0x10a>
  80306c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80306f:	8b 40 04             	mov    0x4(%eax),%eax
  803072:	a3 4c 51 80 00       	mov    %eax,0x80514c
  803077:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80307a:	8b 40 04             	mov    0x4(%eax),%eax
  80307d:	85 c0                	test   %eax,%eax
  80307f:	74 0f                	je     803090 <alloc_block_NF+0x123>
  803081:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803084:	8b 40 04             	mov    0x4(%eax),%eax
  803087:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80308a:	8b 12                	mov    (%edx),%edx
  80308c:	89 10                	mov    %edx,(%eax)
  80308e:	eb 0a                	jmp    80309a <alloc_block_NF+0x12d>
  803090:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803093:	8b 00                	mov    (%eax),%eax
  803095:	a3 48 51 80 00       	mov    %eax,0x805148
  80309a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80309d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8030a3:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8030a6:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8030ad:	a1 54 51 80 00       	mov    0x805154,%eax
  8030b2:	48                   	dec    %eax
  8030b3:	a3 54 51 80 00       	mov    %eax,0x805154
			newblk->size = versize;
  8030b8:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8030bb:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8030be:	89 50 0c             	mov    %edx,0xc(%eax)
			blk->size = blk->size-versize;
  8030c1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030c4:	8b 40 0c             	mov    0xc(%eax),%eax
  8030c7:	2b 45 f0             	sub    -0x10(%ebp),%eax
  8030ca:	89 c2                	mov    %eax,%edx
  8030cc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030cf:	89 50 0c             	mov    %edx,0xc(%eax)
			uint32 newveradd = blk->sva;
  8030d2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030d5:	8b 40 08             	mov    0x8(%eax),%eax
  8030d8:	89 45 e8             	mov    %eax,-0x18(%ebp)
			blk->sva+=newblk->size;
  8030db:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030de:	8b 50 08             	mov    0x8(%eax),%edx
  8030e1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8030e4:	8b 40 0c             	mov    0xc(%eax),%eax
  8030e7:	01 c2                	add    %eax,%edx
  8030e9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030ec:	89 50 08             	mov    %edx,0x8(%eax)
			newblk->sva = newveradd;
  8030ef:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8030f2:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8030f5:	89 50 08             	mov    %edx,0x8(%eax)
			return newblk;
  8030f8:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8030fb:	eb 3b                	jmp    803138 <alloc_block_NF+0x1cb>
	//panic("alloc_block_NF() is not implemented yet...!!");
	uint32 versize = size;
	struct MemBlock* blk;
	struct MemBlock* newblk = LIST_FIRST(&AvailableMemBlocksList);

	LIST_FOREACH(blk,&FreeMemBlocksList)
  8030fd:	a1 40 51 80 00       	mov    0x805140,%eax
  803102:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803105:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803109:	74 07                	je     803112 <alloc_block_NF+0x1a5>
  80310b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80310e:	8b 00                	mov    (%eax),%eax
  803110:	eb 05                	jmp    803117 <alloc_block_NF+0x1aa>
  803112:	b8 00 00 00 00       	mov    $0x0,%eax
  803117:	a3 40 51 80 00       	mov    %eax,0x805140
  80311c:	a1 40 51 80 00       	mov    0x805140,%eax
  803121:	85 c0                	test   %eax,%eax
  803123:	0f 85 65 fe ff ff    	jne    802f8e <alloc_block_NF+0x21>
  803129:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80312d:	0f 85 5b fe ff ff    	jne    802f8e <alloc_block_NF+0x21>
			blk->sva+=newblk->size;
			newblk->sva = newveradd;
			return newblk;
		}
	}
	return NULL;
  803133:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803138:	c9                   	leave  
  803139:	c3                   	ret    

0080313a <addToAvailMemBlocksList>:

//===================================================
// [8] INSERT BLOCK (SORTED WITH MERGE) IN FREE LIST:
//===================================================
void addToAvailMemBlocksList(struct MemBlock *blockToInsert)
{
  80313a:	55                   	push   %ebp
  80313b:	89 e5                	mov    %esp,%ebp
  80313d:	83 ec 08             	sub    $0x8,%esp
	blockToInsert->sva = 0;
  803140:	8b 45 08             	mov    0x8(%ebp),%eax
  803143:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
	blockToInsert->size = 0;
  80314a:	8b 45 08             	mov    0x8(%ebp),%eax
  80314d:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
	//add to avail
	LIST_INSERT_TAIL(&AvailableMemBlocksList, blockToInsert);
  803154:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803158:	75 17                	jne    803171 <addToAvailMemBlocksList+0x37>
  80315a:	83 ec 04             	sub    $0x4,%esp
  80315d:	68 50 41 80 00       	push   $0x804150
  803162:	68 10 01 00 00       	push   $0x110
  803167:	68 37 41 80 00       	push   $0x804137
  80316c:	e8 b6 d8 ff ff       	call   800a27 <_panic>
  803171:	8b 15 4c 51 80 00    	mov    0x80514c,%edx
  803177:	8b 45 08             	mov    0x8(%ebp),%eax
  80317a:	89 50 04             	mov    %edx,0x4(%eax)
  80317d:	8b 45 08             	mov    0x8(%ebp),%eax
  803180:	8b 40 04             	mov    0x4(%eax),%eax
  803183:	85 c0                	test   %eax,%eax
  803185:	74 0c                	je     803193 <addToAvailMemBlocksList+0x59>
  803187:	a1 4c 51 80 00       	mov    0x80514c,%eax
  80318c:	8b 55 08             	mov    0x8(%ebp),%edx
  80318f:	89 10                	mov    %edx,(%eax)
  803191:	eb 08                	jmp    80319b <addToAvailMemBlocksList+0x61>
  803193:	8b 45 08             	mov    0x8(%ebp),%eax
  803196:	a3 48 51 80 00       	mov    %eax,0x805148
  80319b:	8b 45 08             	mov    0x8(%ebp),%eax
  80319e:	a3 4c 51 80 00       	mov    %eax,0x80514c
  8031a3:	8b 45 08             	mov    0x8(%ebp),%eax
  8031a6:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8031ac:	a1 54 51 80 00       	mov    0x805154,%eax
  8031b1:	40                   	inc    %eax
  8031b2:	a3 54 51 80 00       	mov    %eax,0x805154
}
  8031b7:	90                   	nop
  8031b8:	c9                   	leave  
  8031b9:	c3                   	ret    

008031ba <insert_sorted_with_merge_freeList>:
void insert_sorted_with_merge_freeList(struct MemBlock *blockToInsert)
{
  8031ba:	55                   	push   %ebp
  8031bb:	89 e5                	mov    %esp,%ebp
  8031bd:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] insert_sorted_with_merge_freeList
	// Write your code here, remove the panic and write your code

	struct MemBlock* last = LIST_LAST(&FreeMemBlocksList);
  8031c0:	a1 3c 51 80 00       	mov    0x80513c,%eax
  8031c5:	89 45 f0             	mov    %eax,-0x10(%ebp)
	//check if list empty
	if (LIST_SIZE(&(FreeMemBlocksList)) == 0)
  8031c8:	a1 44 51 80 00       	mov    0x805144,%eax
  8031cd:	85 c0                	test   %eax,%eax
  8031cf:	75 68                	jne    803239 <insert_sorted_with_merge_freeList+0x7f>
		LIST_INSERT_HEAD(&FreeMemBlocksList, blockToInsert);
  8031d1:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8031d5:	75 17                	jne    8031ee <insert_sorted_with_merge_freeList+0x34>
  8031d7:	83 ec 04             	sub    $0x4,%esp
  8031da:	68 14 41 80 00       	push   $0x804114
  8031df:	68 1a 01 00 00       	push   $0x11a
  8031e4:	68 37 41 80 00       	push   $0x804137
  8031e9:	e8 39 d8 ff ff       	call   800a27 <_panic>
  8031ee:	8b 15 38 51 80 00    	mov    0x805138,%edx
  8031f4:	8b 45 08             	mov    0x8(%ebp),%eax
  8031f7:	89 10                	mov    %edx,(%eax)
  8031f9:	8b 45 08             	mov    0x8(%ebp),%eax
  8031fc:	8b 00                	mov    (%eax),%eax
  8031fe:	85 c0                	test   %eax,%eax
  803200:	74 0d                	je     80320f <insert_sorted_with_merge_freeList+0x55>
  803202:	a1 38 51 80 00       	mov    0x805138,%eax
  803207:	8b 55 08             	mov    0x8(%ebp),%edx
  80320a:	89 50 04             	mov    %edx,0x4(%eax)
  80320d:	eb 08                	jmp    803217 <insert_sorted_with_merge_freeList+0x5d>
  80320f:	8b 45 08             	mov    0x8(%ebp),%eax
  803212:	a3 3c 51 80 00       	mov    %eax,0x80513c
  803217:	8b 45 08             	mov    0x8(%ebp),%eax
  80321a:	a3 38 51 80 00       	mov    %eax,0x805138
  80321f:	8b 45 08             	mov    0x8(%ebp),%eax
  803222:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803229:	a1 44 51 80 00       	mov    0x805144,%eax
  80322e:	40                   	inc    %eax
  80322f:	a3 44 51 80 00       	mov    %eax,0x805144
		}
	}

	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  803234:	e9 c5 03 00 00       	jmp    8035fe <insert_sorted_with_merge_freeList+0x444>
	struct MemBlock* last = LIST_LAST(&FreeMemBlocksList);
	//check if list empty
	if (LIST_SIZE(&(FreeMemBlocksList)) == 0)
		LIST_INSERT_HEAD(&FreeMemBlocksList, blockToInsert);
	//check if it's position is at last
	else if (last->sva < blockToInsert->sva) {
  803239:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80323c:	8b 50 08             	mov    0x8(%eax),%edx
  80323f:	8b 45 08             	mov    0x8(%ebp),%eax
  803242:	8b 40 08             	mov    0x8(%eax),%eax
  803245:	39 c2                	cmp    %eax,%edx
  803247:	0f 83 b2 00 00 00    	jae    8032ff <insert_sorted_with_merge_freeList+0x145>

		//if i have to merge
		if (last->sva + last->size == blockToInsert->sva) {
  80324d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803250:	8b 50 08             	mov    0x8(%eax),%edx
  803253:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803256:	8b 40 0c             	mov    0xc(%eax),%eax
  803259:	01 c2                	add    %eax,%edx
  80325b:	8b 45 08             	mov    0x8(%ebp),%eax
  80325e:	8b 40 08             	mov    0x8(%eax),%eax
  803261:	39 c2                	cmp    %eax,%edx
  803263:	75 27                	jne    80328c <insert_sorted_with_merge_freeList+0xd2>
			last->size = last->size + blockToInsert->size;
  803265:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803268:	8b 50 0c             	mov    0xc(%eax),%edx
  80326b:	8b 45 08             	mov    0x8(%ebp),%eax
  80326e:	8b 40 0c             	mov    0xc(%eax),%eax
  803271:	01 c2                	add    %eax,%edx
  803273:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803276:	89 50 0c             	mov    %edx,0xc(%eax)
			addToAvailMemBlocksList(blockToInsert);
  803279:	83 ec 0c             	sub    $0xc,%esp
  80327c:	ff 75 08             	pushl  0x8(%ebp)
  80327f:	e8 b6 fe ff ff       	call   80313a <addToAvailMemBlocksList>
  803284:	83 c4 10             	add    $0x10,%esp
		}
	}

	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  803287:	e9 72 03 00 00       	jmp    8035fe <insert_sorted_with_merge_freeList+0x444>
		if (last->sva + last->size == blockToInsert->sva) {
			last->size = last->size + blockToInsert->size;
			addToAvailMemBlocksList(blockToInsert);

		} else {
			LIST_INSERT_AFTER(&FreeMemBlocksList, last, blockToInsert);
  80328c:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  803290:	74 06                	je     803298 <insert_sorted_with_merge_freeList+0xde>
  803292:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803296:	75 17                	jne    8032af <insert_sorted_with_merge_freeList+0xf5>
  803298:	83 ec 04             	sub    $0x4,%esp
  80329b:	68 74 41 80 00       	push   $0x804174
  8032a0:	68 24 01 00 00       	push   $0x124
  8032a5:	68 37 41 80 00       	push   $0x804137
  8032aa:	e8 78 d7 ff ff       	call   800a27 <_panic>
  8032af:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8032b2:	8b 10                	mov    (%eax),%edx
  8032b4:	8b 45 08             	mov    0x8(%ebp),%eax
  8032b7:	89 10                	mov    %edx,(%eax)
  8032b9:	8b 45 08             	mov    0x8(%ebp),%eax
  8032bc:	8b 00                	mov    (%eax),%eax
  8032be:	85 c0                	test   %eax,%eax
  8032c0:	74 0b                	je     8032cd <insert_sorted_with_merge_freeList+0x113>
  8032c2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8032c5:	8b 00                	mov    (%eax),%eax
  8032c7:	8b 55 08             	mov    0x8(%ebp),%edx
  8032ca:	89 50 04             	mov    %edx,0x4(%eax)
  8032cd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8032d0:	8b 55 08             	mov    0x8(%ebp),%edx
  8032d3:	89 10                	mov    %edx,(%eax)
  8032d5:	8b 45 08             	mov    0x8(%ebp),%eax
  8032d8:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8032db:	89 50 04             	mov    %edx,0x4(%eax)
  8032de:	8b 45 08             	mov    0x8(%ebp),%eax
  8032e1:	8b 00                	mov    (%eax),%eax
  8032e3:	85 c0                	test   %eax,%eax
  8032e5:	75 08                	jne    8032ef <insert_sorted_with_merge_freeList+0x135>
  8032e7:	8b 45 08             	mov    0x8(%ebp),%eax
  8032ea:	a3 3c 51 80 00       	mov    %eax,0x80513c
  8032ef:	a1 44 51 80 00       	mov    0x805144,%eax
  8032f4:	40                   	inc    %eax
  8032f5:	a3 44 51 80 00       	mov    %eax,0x805144
		}
	}

	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  8032fa:	e9 ff 02 00 00       	jmp    8035fe <insert_sorted_with_merge_freeList+0x444>
		} else {
			LIST_INSERT_AFTER(&FreeMemBlocksList, last, blockToInsert);
		}
	} else {
		struct MemBlock *iterator;
		LIST_FOREACH(iterator, &(FreeMemBlocksList))
  8032ff:	a1 38 51 80 00       	mov    0x805138,%eax
  803304:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803307:	e9 c2 02 00 00       	jmp    8035ce <insert_sorted_with_merge_freeList+0x414>
		{

			if (iterator->sva > blockToInsert->sva) {
  80330c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80330f:	8b 50 08             	mov    0x8(%eax),%edx
  803312:	8b 45 08             	mov    0x8(%ebp),%eax
  803315:	8b 40 08             	mov    0x8(%eax),%eax
  803318:	39 c2                	cmp    %eax,%edx
  80331a:	0f 86 a6 02 00 00    	jbe    8035c6 <insert_sorted_with_merge_freeList+0x40c>

				struct MemBlock* prev = LIST_PREV(iterator);
  803320:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803323:	8b 40 04             	mov    0x4(%eax),%eax
  803326:	89 45 ec             	mov    %eax,-0x14(%ebp)
				if (prev == NULL) {
  803329:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  80332d:	0f 85 ba 00 00 00    	jne    8033ed <insert_sorted_with_merge_freeList+0x233>
					//check merge
					if (blockToInsert->size + blockToInsert->sva
  803333:	8b 45 08             	mov    0x8(%ebp),%eax
  803336:	8b 50 0c             	mov    0xc(%eax),%edx
  803339:	8b 45 08             	mov    0x8(%ebp),%eax
  80333c:	8b 40 08             	mov    0x8(%eax),%eax
  80333f:	01 c2                	add    %eax,%edx
							== iterator->sva) {
  803341:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803344:	8b 40 08             	mov    0x8(%eax),%eax
			if (iterator->sva > blockToInsert->sva) {

				struct MemBlock* prev = LIST_PREV(iterator);
				if (prev == NULL) {
					//check merge
					if (blockToInsert->size + blockToInsert->sva
  803347:	39 c2                	cmp    %eax,%edx
  803349:	75 33                	jne    80337e <insert_sorted_with_merge_freeList+0x1c4>
							== iterator->sva) {
						iterator->sva = blockToInsert->sva;
  80334b:	8b 45 08             	mov    0x8(%ebp),%eax
  80334e:	8b 50 08             	mov    0x8(%eax),%edx
  803351:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803354:	89 50 08             	mov    %edx,0x8(%eax)
						iterator->size = iterator->size + blockToInsert->size;
  803357:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80335a:	8b 50 0c             	mov    0xc(%eax),%edx
  80335d:	8b 45 08             	mov    0x8(%ebp),%eax
  803360:	8b 40 0c             	mov    0xc(%eax),%eax
  803363:	01 c2                	add    %eax,%edx
  803365:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803368:	89 50 0c             	mov    %edx,0xc(%eax)
						addToAvailMemBlocksList(blockToInsert);
  80336b:	83 ec 0c             	sub    $0xc,%esp
  80336e:	ff 75 08             	pushl  0x8(%ebp)
  803371:	e8 c4 fd ff ff       	call   80313a <addToAvailMemBlocksList>
  803376:	83 c4 10             	add    $0x10,%esp

					else {
						LIST_INSERT_BEFORE(&FreeMemBlocksList, iterator,
								blockToInsert);
					}
					break;
  803379:	e9 80 02 00 00       	jmp    8035fe <insert_sorted_with_merge_freeList+0x444>
						addToAvailMemBlocksList(blockToInsert);

					}

					else {
						LIST_INSERT_BEFORE(&FreeMemBlocksList, iterator,
  80337e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803382:	74 06                	je     80338a <insert_sorted_with_merge_freeList+0x1d0>
  803384:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803388:	75 17                	jne    8033a1 <insert_sorted_with_merge_freeList+0x1e7>
  80338a:	83 ec 04             	sub    $0x4,%esp
  80338d:	68 c8 41 80 00       	push   $0x8041c8
  803392:	68 3a 01 00 00       	push   $0x13a
  803397:	68 37 41 80 00       	push   $0x804137
  80339c:	e8 86 d6 ff ff       	call   800a27 <_panic>
  8033a1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8033a4:	8b 50 04             	mov    0x4(%eax),%edx
  8033a7:	8b 45 08             	mov    0x8(%ebp),%eax
  8033aa:	89 50 04             	mov    %edx,0x4(%eax)
  8033ad:	8b 45 08             	mov    0x8(%ebp),%eax
  8033b0:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8033b3:	89 10                	mov    %edx,(%eax)
  8033b5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8033b8:	8b 40 04             	mov    0x4(%eax),%eax
  8033bb:	85 c0                	test   %eax,%eax
  8033bd:	74 0d                	je     8033cc <insert_sorted_with_merge_freeList+0x212>
  8033bf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8033c2:	8b 40 04             	mov    0x4(%eax),%eax
  8033c5:	8b 55 08             	mov    0x8(%ebp),%edx
  8033c8:	89 10                	mov    %edx,(%eax)
  8033ca:	eb 08                	jmp    8033d4 <insert_sorted_with_merge_freeList+0x21a>
  8033cc:	8b 45 08             	mov    0x8(%ebp),%eax
  8033cf:	a3 38 51 80 00       	mov    %eax,0x805138
  8033d4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8033d7:	8b 55 08             	mov    0x8(%ebp),%edx
  8033da:	89 50 04             	mov    %edx,0x4(%eax)
  8033dd:	a1 44 51 80 00       	mov    0x805144,%eax
  8033e2:	40                   	inc    %eax
  8033e3:	a3 44 51 80 00       	mov    %eax,0x805144
								blockToInsert);
					}
					break;
  8033e8:	e9 11 02 00 00       	jmp    8035fe <insert_sorted_with_merge_freeList+0x444>
				} else {
					//prev and next merge
					if (prev->sva + prev->size + blockToInsert->size
  8033ed:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8033f0:	8b 50 08             	mov    0x8(%eax),%edx
  8033f3:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8033f6:	8b 40 0c             	mov    0xc(%eax),%eax
  8033f9:	01 c2                	add    %eax,%edx
  8033fb:	8b 45 08             	mov    0x8(%ebp),%eax
  8033fe:	8b 40 0c             	mov    0xc(%eax),%eax
  803401:	01 c2                	add    %eax,%edx
							== iterator->sva) {
  803403:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803406:	8b 40 08             	mov    0x8(%eax),%eax
								blockToInsert);
					}
					break;
				} else {
					//prev and next merge
					if (prev->sva + prev->size + blockToInsert->size
  803409:	39 c2                	cmp    %eax,%edx
  80340b:	0f 85 bf 00 00 00    	jne    8034d0 <insert_sorted_with_merge_freeList+0x316>
							== iterator->sva) {
						prev->size = prev->size + blockToInsert->size
  803411:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803414:	8b 50 0c             	mov    0xc(%eax),%edx
  803417:	8b 45 08             	mov    0x8(%ebp),%eax
  80341a:	8b 40 0c             	mov    0xc(%eax),%eax
  80341d:	01 c2                	add    %eax,%edx
								+ iterator->size;
  80341f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803422:	8b 40 0c             	mov    0xc(%eax),%eax
  803425:	01 c2                	add    %eax,%edx
					break;
				} else {
					//prev and next merge
					if (prev->sva + prev->size + blockToInsert->size
							== iterator->sva) {
						prev->size = prev->size + blockToInsert->size
  803427:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80342a:	89 50 0c             	mov    %edx,0xc(%eax)
								+ iterator->size;
						LIST_REMOVE(&FreeMemBlocksList, iterator);
  80342d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803431:	75 17                	jne    80344a <insert_sorted_with_merge_freeList+0x290>
  803433:	83 ec 04             	sub    $0x4,%esp
  803436:	68 a8 41 80 00       	push   $0x8041a8
  80343b:	68 43 01 00 00       	push   $0x143
  803440:	68 37 41 80 00       	push   $0x804137
  803445:	e8 dd d5 ff ff       	call   800a27 <_panic>
  80344a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80344d:	8b 00                	mov    (%eax),%eax
  80344f:	85 c0                	test   %eax,%eax
  803451:	74 10                	je     803463 <insert_sorted_with_merge_freeList+0x2a9>
  803453:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803456:	8b 00                	mov    (%eax),%eax
  803458:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80345b:	8b 52 04             	mov    0x4(%edx),%edx
  80345e:	89 50 04             	mov    %edx,0x4(%eax)
  803461:	eb 0b                	jmp    80346e <insert_sorted_with_merge_freeList+0x2b4>
  803463:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803466:	8b 40 04             	mov    0x4(%eax),%eax
  803469:	a3 3c 51 80 00       	mov    %eax,0x80513c
  80346e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803471:	8b 40 04             	mov    0x4(%eax),%eax
  803474:	85 c0                	test   %eax,%eax
  803476:	74 0f                	je     803487 <insert_sorted_with_merge_freeList+0x2cd>
  803478:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80347b:	8b 40 04             	mov    0x4(%eax),%eax
  80347e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803481:	8b 12                	mov    (%edx),%edx
  803483:	89 10                	mov    %edx,(%eax)
  803485:	eb 0a                	jmp    803491 <insert_sorted_with_merge_freeList+0x2d7>
  803487:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80348a:	8b 00                	mov    (%eax),%eax
  80348c:	a3 38 51 80 00       	mov    %eax,0x805138
  803491:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803494:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80349a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80349d:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8034a4:	a1 44 51 80 00       	mov    0x805144,%eax
  8034a9:	48                   	dec    %eax
  8034aa:	a3 44 51 80 00       	mov    %eax,0x805144
						addToAvailMemBlocksList(blockToInsert);
  8034af:	83 ec 0c             	sub    $0xc,%esp
  8034b2:	ff 75 08             	pushl  0x8(%ebp)
  8034b5:	e8 80 fc ff ff       	call   80313a <addToAvailMemBlocksList>
  8034ba:	83 c4 10             	add    $0x10,%esp
						addToAvailMemBlocksList(iterator);
  8034bd:	83 ec 0c             	sub    $0xc,%esp
  8034c0:	ff 75 f4             	pushl  -0xc(%ebp)
  8034c3:	e8 72 fc ff ff       	call   80313a <addToAvailMemBlocksList>
  8034c8:	83 c4 10             	add    $0x10,%esp
					//Insert
					else {
						LIST_INSERT_BEFORE(&FreeMemBlocksList, iterator,
								blockToInsert);
					}
					break;
  8034cb:	e9 2e 01 00 00       	jmp    8035fe <insert_sorted_with_merge_freeList+0x444>
						LIST_REMOVE(&FreeMemBlocksList, iterator);
						addToAvailMemBlocksList(blockToInsert);
						addToAvailMemBlocksList(iterator);
					}
					//previous merge
					else if (prev->sva + prev->size == blockToInsert->sva) {
  8034d0:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8034d3:	8b 50 08             	mov    0x8(%eax),%edx
  8034d6:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8034d9:	8b 40 0c             	mov    0xc(%eax),%eax
  8034dc:	01 c2                	add    %eax,%edx
  8034de:	8b 45 08             	mov    0x8(%ebp),%eax
  8034e1:	8b 40 08             	mov    0x8(%eax),%eax
  8034e4:	39 c2                	cmp    %eax,%edx
  8034e6:	75 27                	jne    80350f <insert_sorted_with_merge_freeList+0x355>
						prev->size = prev->size + blockToInsert->size;
  8034e8:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8034eb:	8b 50 0c             	mov    0xc(%eax),%edx
  8034ee:	8b 45 08             	mov    0x8(%ebp),%eax
  8034f1:	8b 40 0c             	mov    0xc(%eax),%eax
  8034f4:	01 c2                	add    %eax,%edx
  8034f6:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8034f9:	89 50 0c             	mov    %edx,0xc(%eax)
						addToAvailMemBlocksList(blockToInsert);
  8034fc:	83 ec 0c             	sub    $0xc,%esp
  8034ff:	ff 75 08             	pushl  0x8(%ebp)
  803502:	e8 33 fc ff ff       	call   80313a <addToAvailMemBlocksList>
  803507:	83 c4 10             	add    $0x10,%esp
					//Insert
					else {
						LIST_INSERT_BEFORE(&FreeMemBlocksList, iterator,
								blockToInsert);
					}
					break;
  80350a:	e9 ef 00 00 00       	jmp    8035fe <insert_sorted_with_merge_freeList+0x444>
					else if (prev->sva + prev->size == blockToInsert->sva) {
						prev->size = prev->size + blockToInsert->size;
						addToAvailMemBlocksList(blockToInsert);
					}
					//next merge
					else if (blockToInsert->size + blockToInsert->sva
  80350f:	8b 45 08             	mov    0x8(%ebp),%eax
  803512:	8b 50 0c             	mov    0xc(%eax),%edx
  803515:	8b 45 08             	mov    0x8(%ebp),%eax
  803518:	8b 40 08             	mov    0x8(%eax),%eax
  80351b:	01 c2                	add    %eax,%edx
							== iterator->sva) {
  80351d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803520:	8b 40 08             	mov    0x8(%eax),%eax
					else if (prev->sva + prev->size == blockToInsert->sva) {
						prev->size = prev->size + blockToInsert->size;
						addToAvailMemBlocksList(blockToInsert);
					}
					//next merge
					else if (blockToInsert->size + blockToInsert->sva
  803523:	39 c2                	cmp    %eax,%edx
  803525:	75 33                	jne    80355a <insert_sorted_with_merge_freeList+0x3a0>
							== iterator->sva) {
						iterator->sva = blockToInsert->sva;
  803527:	8b 45 08             	mov    0x8(%ebp),%eax
  80352a:	8b 50 08             	mov    0x8(%eax),%edx
  80352d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803530:	89 50 08             	mov    %edx,0x8(%eax)
						iterator->size = iterator->size + blockToInsert->size;
  803533:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803536:	8b 50 0c             	mov    0xc(%eax),%edx
  803539:	8b 45 08             	mov    0x8(%ebp),%eax
  80353c:	8b 40 0c             	mov    0xc(%eax),%eax
  80353f:	01 c2                	add    %eax,%edx
  803541:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803544:	89 50 0c             	mov    %edx,0xc(%eax)
						addToAvailMemBlocksList(blockToInsert);
  803547:	83 ec 0c             	sub    $0xc,%esp
  80354a:	ff 75 08             	pushl  0x8(%ebp)
  80354d:	e8 e8 fb ff ff       	call   80313a <addToAvailMemBlocksList>
  803552:	83 c4 10             	add    $0x10,%esp
					//Insert
					else {
						LIST_INSERT_BEFORE(&FreeMemBlocksList, iterator,
								blockToInsert);
					}
					break;
  803555:	e9 a4 00 00 00       	jmp    8035fe <insert_sorted_with_merge_freeList+0x444>
						iterator->size = iterator->size + blockToInsert->size;
						addToAvailMemBlocksList(blockToInsert);
					}
					//Insert
					else {
						LIST_INSERT_BEFORE(&FreeMemBlocksList, iterator,
  80355a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80355e:	74 06                	je     803566 <insert_sorted_with_merge_freeList+0x3ac>
  803560:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803564:	75 17                	jne    80357d <insert_sorted_with_merge_freeList+0x3c3>
  803566:	83 ec 04             	sub    $0x4,%esp
  803569:	68 c8 41 80 00       	push   $0x8041c8
  80356e:	68 56 01 00 00       	push   $0x156
  803573:	68 37 41 80 00       	push   $0x804137
  803578:	e8 aa d4 ff ff       	call   800a27 <_panic>
  80357d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803580:	8b 50 04             	mov    0x4(%eax),%edx
  803583:	8b 45 08             	mov    0x8(%ebp),%eax
  803586:	89 50 04             	mov    %edx,0x4(%eax)
  803589:	8b 45 08             	mov    0x8(%ebp),%eax
  80358c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80358f:	89 10                	mov    %edx,(%eax)
  803591:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803594:	8b 40 04             	mov    0x4(%eax),%eax
  803597:	85 c0                	test   %eax,%eax
  803599:	74 0d                	je     8035a8 <insert_sorted_with_merge_freeList+0x3ee>
  80359b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80359e:	8b 40 04             	mov    0x4(%eax),%eax
  8035a1:	8b 55 08             	mov    0x8(%ebp),%edx
  8035a4:	89 10                	mov    %edx,(%eax)
  8035a6:	eb 08                	jmp    8035b0 <insert_sorted_with_merge_freeList+0x3f6>
  8035a8:	8b 45 08             	mov    0x8(%ebp),%eax
  8035ab:	a3 38 51 80 00       	mov    %eax,0x805138
  8035b0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8035b3:	8b 55 08             	mov    0x8(%ebp),%edx
  8035b6:	89 50 04             	mov    %edx,0x4(%eax)
  8035b9:	a1 44 51 80 00       	mov    0x805144,%eax
  8035be:	40                   	inc    %eax
  8035bf:	a3 44 51 80 00       	mov    %eax,0x805144
								blockToInsert);
					}
					break;
  8035c4:	eb 38                	jmp    8035fe <insert_sorted_with_merge_freeList+0x444>
		} else {
			LIST_INSERT_AFTER(&FreeMemBlocksList, last, blockToInsert);
		}
	} else {
		struct MemBlock *iterator;
		LIST_FOREACH(iterator, &(FreeMemBlocksList))
  8035c6:	a1 40 51 80 00       	mov    0x805140,%eax
  8035cb:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8035ce:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8035d2:	74 07                	je     8035db <insert_sorted_with_merge_freeList+0x421>
  8035d4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8035d7:	8b 00                	mov    (%eax),%eax
  8035d9:	eb 05                	jmp    8035e0 <insert_sorted_with_merge_freeList+0x426>
  8035db:	b8 00 00 00 00       	mov    $0x0,%eax
  8035e0:	a3 40 51 80 00       	mov    %eax,0x805140
  8035e5:	a1 40 51 80 00       	mov    0x805140,%eax
  8035ea:	85 c0                	test   %eax,%eax
  8035ec:	0f 85 1a fd ff ff    	jne    80330c <insert_sorted_with_merge_freeList+0x152>
  8035f2:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8035f6:	0f 85 10 fd ff ff    	jne    80330c <insert_sorted_with_merge_freeList+0x152>
		}
	}

	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  8035fc:	eb 00                	jmp    8035fe <insert_sorted_with_merge_freeList+0x444>
  8035fe:	90                   	nop
  8035ff:	c9                   	leave  
  803600:	c3                   	ret    
  803601:	66 90                	xchg   %ax,%ax
  803603:	90                   	nop

00803604 <__udivdi3>:
  803604:	55                   	push   %ebp
  803605:	57                   	push   %edi
  803606:	56                   	push   %esi
  803607:	53                   	push   %ebx
  803608:	83 ec 1c             	sub    $0x1c,%esp
  80360b:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  80360f:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  803613:	8b 7c 24 38          	mov    0x38(%esp),%edi
  803617:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  80361b:	89 ca                	mov    %ecx,%edx
  80361d:	89 f8                	mov    %edi,%eax
  80361f:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  803623:	85 f6                	test   %esi,%esi
  803625:	75 2d                	jne    803654 <__udivdi3+0x50>
  803627:	39 cf                	cmp    %ecx,%edi
  803629:	77 65                	ja     803690 <__udivdi3+0x8c>
  80362b:	89 fd                	mov    %edi,%ebp
  80362d:	85 ff                	test   %edi,%edi
  80362f:	75 0b                	jne    80363c <__udivdi3+0x38>
  803631:	b8 01 00 00 00       	mov    $0x1,%eax
  803636:	31 d2                	xor    %edx,%edx
  803638:	f7 f7                	div    %edi
  80363a:	89 c5                	mov    %eax,%ebp
  80363c:	31 d2                	xor    %edx,%edx
  80363e:	89 c8                	mov    %ecx,%eax
  803640:	f7 f5                	div    %ebp
  803642:	89 c1                	mov    %eax,%ecx
  803644:	89 d8                	mov    %ebx,%eax
  803646:	f7 f5                	div    %ebp
  803648:	89 cf                	mov    %ecx,%edi
  80364a:	89 fa                	mov    %edi,%edx
  80364c:	83 c4 1c             	add    $0x1c,%esp
  80364f:	5b                   	pop    %ebx
  803650:	5e                   	pop    %esi
  803651:	5f                   	pop    %edi
  803652:	5d                   	pop    %ebp
  803653:	c3                   	ret    
  803654:	39 ce                	cmp    %ecx,%esi
  803656:	77 28                	ja     803680 <__udivdi3+0x7c>
  803658:	0f bd fe             	bsr    %esi,%edi
  80365b:	83 f7 1f             	xor    $0x1f,%edi
  80365e:	75 40                	jne    8036a0 <__udivdi3+0x9c>
  803660:	39 ce                	cmp    %ecx,%esi
  803662:	72 0a                	jb     80366e <__udivdi3+0x6a>
  803664:	3b 44 24 08          	cmp    0x8(%esp),%eax
  803668:	0f 87 9e 00 00 00    	ja     80370c <__udivdi3+0x108>
  80366e:	b8 01 00 00 00       	mov    $0x1,%eax
  803673:	89 fa                	mov    %edi,%edx
  803675:	83 c4 1c             	add    $0x1c,%esp
  803678:	5b                   	pop    %ebx
  803679:	5e                   	pop    %esi
  80367a:	5f                   	pop    %edi
  80367b:	5d                   	pop    %ebp
  80367c:	c3                   	ret    
  80367d:	8d 76 00             	lea    0x0(%esi),%esi
  803680:	31 ff                	xor    %edi,%edi
  803682:	31 c0                	xor    %eax,%eax
  803684:	89 fa                	mov    %edi,%edx
  803686:	83 c4 1c             	add    $0x1c,%esp
  803689:	5b                   	pop    %ebx
  80368a:	5e                   	pop    %esi
  80368b:	5f                   	pop    %edi
  80368c:	5d                   	pop    %ebp
  80368d:	c3                   	ret    
  80368e:	66 90                	xchg   %ax,%ax
  803690:	89 d8                	mov    %ebx,%eax
  803692:	f7 f7                	div    %edi
  803694:	31 ff                	xor    %edi,%edi
  803696:	89 fa                	mov    %edi,%edx
  803698:	83 c4 1c             	add    $0x1c,%esp
  80369b:	5b                   	pop    %ebx
  80369c:	5e                   	pop    %esi
  80369d:	5f                   	pop    %edi
  80369e:	5d                   	pop    %ebp
  80369f:	c3                   	ret    
  8036a0:	bd 20 00 00 00       	mov    $0x20,%ebp
  8036a5:	89 eb                	mov    %ebp,%ebx
  8036a7:	29 fb                	sub    %edi,%ebx
  8036a9:	89 f9                	mov    %edi,%ecx
  8036ab:	d3 e6                	shl    %cl,%esi
  8036ad:	89 c5                	mov    %eax,%ebp
  8036af:	88 d9                	mov    %bl,%cl
  8036b1:	d3 ed                	shr    %cl,%ebp
  8036b3:	89 e9                	mov    %ebp,%ecx
  8036b5:	09 f1                	or     %esi,%ecx
  8036b7:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  8036bb:	89 f9                	mov    %edi,%ecx
  8036bd:	d3 e0                	shl    %cl,%eax
  8036bf:	89 c5                	mov    %eax,%ebp
  8036c1:	89 d6                	mov    %edx,%esi
  8036c3:	88 d9                	mov    %bl,%cl
  8036c5:	d3 ee                	shr    %cl,%esi
  8036c7:	89 f9                	mov    %edi,%ecx
  8036c9:	d3 e2                	shl    %cl,%edx
  8036cb:	8b 44 24 08          	mov    0x8(%esp),%eax
  8036cf:	88 d9                	mov    %bl,%cl
  8036d1:	d3 e8                	shr    %cl,%eax
  8036d3:	09 c2                	or     %eax,%edx
  8036d5:	89 d0                	mov    %edx,%eax
  8036d7:	89 f2                	mov    %esi,%edx
  8036d9:	f7 74 24 0c          	divl   0xc(%esp)
  8036dd:	89 d6                	mov    %edx,%esi
  8036df:	89 c3                	mov    %eax,%ebx
  8036e1:	f7 e5                	mul    %ebp
  8036e3:	39 d6                	cmp    %edx,%esi
  8036e5:	72 19                	jb     803700 <__udivdi3+0xfc>
  8036e7:	74 0b                	je     8036f4 <__udivdi3+0xf0>
  8036e9:	89 d8                	mov    %ebx,%eax
  8036eb:	31 ff                	xor    %edi,%edi
  8036ed:	e9 58 ff ff ff       	jmp    80364a <__udivdi3+0x46>
  8036f2:	66 90                	xchg   %ax,%ax
  8036f4:	8b 54 24 08          	mov    0x8(%esp),%edx
  8036f8:	89 f9                	mov    %edi,%ecx
  8036fa:	d3 e2                	shl    %cl,%edx
  8036fc:	39 c2                	cmp    %eax,%edx
  8036fe:	73 e9                	jae    8036e9 <__udivdi3+0xe5>
  803700:	8d 43 ff             	lea    -0x1(%ebx),%eax
  803703:	31 ff                	xor    %edi,%edi
  803705:	e9 40 ff ff ff       	jmp    80364a <__udivdi3+0x46>
  80370a:	66 90                	xchg   %ax,%ax
  80370c:	31 c0                	xor    %eax,%eax
  80370e:	e9 37 ff ff ff       	jmp    80364a <__udivdi3+0x46>
  803713:	90                   	nop

00803714 <__umoddi3>:
  803714:	55                   	push   %ebp
  803715:	57                   	push   %edi
  803716:	56                   	push   %esi
  803717:	53                   	push   %ebx
  803718:	83 ec 1c             	sub    $0x1c,%esp
  80371b:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  80371f:	8b 74 24 34          	mov    0x34(%esp),%esi
  803723:	8b 7c 24 38          	mov    0x38(%esp),%edi
  803727:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  80372b:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80372f:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  803733:	89 f3                	mov    %esi,%ebx
  803735:	89 fa                	mov    %edi,%edx
  803737:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  80373b:	89 34 24             	mov    %esi,(%esp)
  80373e:	85 c0                	test   %eax,%eax
  803740:	75 1a                	jne    80375c <__umoddi3+0x48>
  803742:	39 f7                	cmp    %esi,%edi
  803744:	0f 86 a2 00 00 00    	jbe    8037ec <__umoddi3+0xd8>
  80374a:	89 c8                	mov    %ecx,%eax
  80374c:	89 f2                	mov    %esi,%edx
  80374e:	f7 f7                	div    %edi
  803750:	89 d0                	mov    %edx,%eax
  803752:	31 d2                	xor    %edx,%edx
  803754:	83 c4 1c             	add    $0x1c,%esp
  803757:	5b                   	pop    %ebx
  803758:	5e                   	pop    %esi
  803759:	5f                   	pop    %edi
  80375a:	5d                   	pop    %ebp
  80375b:	c3                   	ret    
  80375c:	39 f0                	cmp    %esi,%eax
  80375e:	0f 87 ac 00 00 00    	ja     803810 <__umoddi3+0xfc>
  803764:	0f bd e8             	bsr    %eax,%ebp
  803767:	83 f5 1f             	xor    $0x1f,%ebp
  80376a:	0f 84 ac 00 00 00    	je     80381c <__umoddi3+0x108>
  803770:	bf 20 00 00 00       	mov    $0x20,%edi
  803775:	29 ef                	sub    %ebp,%edi
  803777:	89 fe                	mov    %edi,%esi
  803779:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  80377d:	89 e9                	mov    %ebp,%ecx
  80377f:	d3 e0                	shl    %cl,%eax
  803781:	89 d7                	mov    %edx,%edi
  803783:	89 f1                	mov    %esi,%ecx
  803785:	d3 ef                	shr    %cl,%edi
  803787:	09 c7                	or     %eax,%edi
  803789:	89 e9                	mov    %ebp,%ecx
  80378b:	d3 e2                	shl    %cl,%edx
  80378d:	89 14 24             	mov    %edx,(%esp)
  803790:	89 d8                	mov    %ebx,%eax
  803792:	d3 e0                	shl    %cl,%eax
  803794:	89 c2                	mov    %eax,%edx
  803796:	8b 44 24 08          	mov    0x8(%esp),%eax
  80379a:	d3 e0                	shl    %cl,%eax
  80379c:	89 44 24 04          	mov    %eax,0x4(%esp)
  8037a0:	8b 44 24 08          	mov    0x8(%esp),%eax
  8037a4:	89 f1                	mov    %esi,%ecx
  8037a6:	d3 e8                	shr    %cl,%eax
  8037a8:	09 d0                	or     %edx,%eax
  8037aa:	d3 eb                	shr    %cl,%ebx
  8037ac:	89 da                	mov    %ebx,%edx
  8037ae:	f7 f7                	div    %edi
  8037b0:	89 d3                	mov    %edx,%ebx
  8037b2:	f7 24 24             	mull   (%esp)
  8037b5:	89 c6                	mov    %eax,%esi
  8037b7:	89 d1                	mov    %edx,%ecx
  8037b9:	39 d3                	cmp    %edx,%ebx
  8037bb:	0f 82 87 00 00 00    	jb     803848 <__umoddi3+0x134>
  8037c1:	0f 84 91 00 00 00    	je     803858 <__umoddi3+0x144>
  8037c7:	8b 54 24 04          	mov    0x4(%esp),%edx
  8037cb:	29 f2                	sub    %esi,%edx
  8037cd:	19 cb                	sbb    %ecx,%ebx
  8037cf:	89 d8                	mov    %ebx,%eax
  8037d1:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  8037d5:	d3 e0                	shl    %cl,%eax
  8037d7:	89 e9                	mov    %ebp,%ecx
  8037d9:	d3 ea                	shr    %cl,%edx
  8037db:	09 d0                	or     %edx,%eax
  8037dd:	89 e9                	mov    %ebp,%ecx
  8037df:	d3 eb                	shr    %cl,%ebx
  8037e1:	89 da                	mov    %ebx,%edx
  8037e3:	83 c4 1c             	add    $0x1c,%esp
  8037e6:	5b                   	pop    %ebx
  8037e7:	5e                   	pop    %esi
  8037e8:	5f                   	pop    %edi
  8037e9:	5d                   	pop    %ebp
  8037ea:	c3                   	ret    
  8037eb:	90                   	nop
  8037ec:	89 fd                	mov    %edi,%ebp
  8037ee:	85 ff                	test   %edi,%edi
  8037f0:	75 0b                	jne    8037fd <__umoddi3+0xe9>
  8037f2:	b8 01 00 00 00       	mov    $0x1,%eax
  8037f7:	31 d2                	xor    %edx,%edx
  8037f9:	f7 f7                	div    %edi
  8037fb:	89 c5                	mov    %eax,%ebp
  8037fd:	89 f0                	mov    %esi,%eax
  8037ff:	31 d2                	xor    %edx,%edx
  803801:	f7 f5                	div    %ebp
  803803:	89 c8                	mov    %ecx,%eax
  803805:	f7 f5                	div    %ebp
  803807:	89 d0                	mov    %edx,%eax
  803809:	e9 44 ff ff ff       	jmp    803752 <__umoddi3+0x3e>
  80380e:	66 90                	xchg   %ax,%ax
  803810:	89 c8                	mov    %ecx,%eax
  803812:	89 f2                	mov    %esi,%edx
  803814:	83 c4 1c             	add    $0x1c,%esp
  803817:	5b                   	pop    %ebx
  803818:	5e                   	pop    %esi
  803819:	5f                   	pop    %edi
  80381a:	5d                   	pop    %ebp
  80381b:	c3                   	ret    
  80381c:	3b 04 24             	cmp    (%esp),%eax
  80381f:	72 06                	jb     803827 <__umoddi3+0x113>
  803821:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  803825:	77 0f                	ja     803836 <__umoddi3+0x122>
  803827:	89 f2                	mov    %esi,%edx
  803829:	29 f9                	sub    %edi,%ecx
  80382b:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  80382f:	89 14 24             	mov    %edx,(%esp)
  803832:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  803836:	8b 44 24 04          	mov    0x4(%esp),%eax
  80383a:	8b 14 24             	mov    (%esp),%edx
  80383d:	83 c4 1c             	add    $0x1c,%esp
  803840:	5b                   	pop    %ebx
  803841:	5e                   	pop    %esi
  803842:	5f                   	pop    %edi
  803843:	5d                   	pop    %ebp
  803844:	c3                   	ret    
  803845:	8d 76 00             	lea    0x0(%esi),%esi
  803848:	2b 04 24             	sub    (%esp),%eax
  80384b:	19 fa                	sbb    %edi,%edx
  80384d:	89 d1                	mov    %edx,%ecx
  80384f:	89 c6                	mov    %eax,%esi
  803851:	e9 71 ff ff ff       	jmp    8037c7 <__umoddi3+0xb3>
  803856:	66 90                	xchg   %ax,%ax
  803858:	39 44 24 04          	cmp    %eax,0x4(%esp)
  80385c:	72 ea                	jb     803848 <__umoddi3+0x134>
  80385e:	89 d9                	mov    %ebx,%ecx
  803860:	e9 62 ff ff ff       	jmp    8037c7 <__umoddi3+0xb3>
