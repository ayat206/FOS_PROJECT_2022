
obj/user/tst_first_fit_2:     file format elf32-i386


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
  800031:	e8 4a 06 00 00       	call   800680 <libmain>
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
	sys_set_uheap_strategy(UHP_PLACE_FIRSTFIT);
  800040:	83 ec 0c             	sub    $0xc,%esp
  800043:	6a 01                	push   $0x1
  800045:	e8 d9 22 00 00       	call   802323 <sys_set_uheap_strategy>
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
  80005a:	a1 20 40 80 00       	mov    0x804020,%eax
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
	sys_set_uheap_strategy(UHP_PLACE_FIRSTFIT);

	//Initial test to ensure it works on "PLACEMENT" not "REPLACEMENT"
	{
		uint8 fullWS = 1;
		for (int i = 0; i < myEnv->page_WS_max_size; ++i)
  800080:	ff 45 f0             	incl   -0x10(%ebp)
  800083:	a1 20 40 80 00       	mov    0x804020,%eax
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
  80009b:	68 00 36 80 00       	push   $0x803600
  8000a0:	6a 1b                	push   $0x1b
  8000a2:	68 1c 36 80 00       	push   $0x80361c
  8000a7:	e8 10 07 00 00       	call   8007bc <_panic>
	}
	/*Dummy malloc to enforce the UHEAP initializations*/
	malloc(0);
  8000ac:	83 ec 0c             	sub    $0xc,%esp
  8000af:	6a 00                	push   $0x0
  8000b1:	e8 4c 19 00 00       	call   801a02 <malloc>
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
  8000e0:	e8 1d 19 00 00       	call   801a02 <malloc>
  8000e5:	83 c4 10             	add    $0x10,%esp
  8000e8:	89 45 90             	mov    %eax,-0x70(%ebp)
		if (ptr_allocations[0] != NULL) panic("Malloc: Attempt to allocate more than heap size, should return NULL");
  8000eb:	8b 45 90             	mov    -0x70(%ebp),%eax
  8000ee:	85 c0                	test   %eax,%eax
  8000f0:	74 14                	je     800106 <_main+0xce>
  8000f2:	83 ec 04             	sub    $0x4,%esp
  8000f5:	68 34 36 80 00       	push   $0x803634
  8000fa:	6a 28                	push   $0x28
  8000fc:	68 1c 36 80 00       	push   $0x80361c
  800101:	e8 b6 06 00 00       	call   8007bc <_panic>
	}
	//[2] Attempt to allocate space more than any available fragment
	//	a) Create Fragments
	{
		//2 MB
		int freeFrames = sys_calculate_free_frames() ;
  800106:	e8 03 1d 00 00       	call   801e0e <sys_calculate_free_frames>
  80010b:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		int usedDiskPages = sys_pf_calculate_allocated_pages();
  80010e:	e8 9b 1d 00 00       	call   801eae <sys_pf_calculate_allocated_pages>
  800113:	89 45 e0             	mov    %eax,-0x20(%ebp)
		ptr_allocations[0] = malloc(2*Mega-kilo);
  800116:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800119:	01 c0                	add    %eax,%eax
  80011b:	2b 45 e8             	sub    -0x18(%ebp),%eax
  80011e:	83 ec 0c             	sub    $0xc,%esp
  800121:	50                   	push   %eax
  800122:	e8 db 18 00 00       	call   801a02 <malloc>
  800127:	83 c4 10             	add    $0x10,%esp
  80012a:	89 45 90             	mov    %eax,-0x70(%ebp)
		if ((uint32) ptr_allocations[0] != (USER_HEAP_START)) panic("Wrong start address for the allocated space... ");
  80012d:	8b 45 90             	mov    -0x70(%ebp),%eax
  800130:	3d 00 00 00 80       	cmp    $0x80000000,%eax
  800135:	74 14                	je     80014b <_main+0x113>
  800137:	83 ec 04             	sub    $0x4,%esp
  80013a:	68 78 36 80 00       	push   $0x803678
  80013f:	6a 31                	push   $0x31
  800141:	68 1c 36 80 00       	push   $0x80361c
  800146:	e8 71 06 00 00       	call   8007bc <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 512+1 ) panic("Wrong allocation: ");
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  0) panic("Wrong page file allocation: ");
  80014b:	e8 5e 1d 00 00       	call   801eae <sys_pf_calculate_allocated_pages>
  800150:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  800153:	74 14                	je     800169 <_main+0x131>
  800155:	83 ec 04             	sub    $0x4,%esp
  800158:	68 a8 36 80 00       	push   $0x8036a8
  80015d:	6a 33                	push   $0x33
  80015f:	68 1c 36 80 00       	push   $0x80361c
  800164:	e8 53 06 00 00       	call   8007bc <_panic>

		//2 MB
		freeFrames = sys_calculate_free_frames() ;
  800169:	e8 a0 1c 00 00       	call   801e0e <sys_calculate_free_frames>
  80016e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  800171:	e8 38 1d 00 00       	call   801eae <sys_pf_calculate_allocated_pages>
  800176:	89 45 e0             	mov    %eax,-0x20(%ebp)
		ptr_allocations[1] = malloc(2*Mega-kilo);
  800179:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80017c:	01 c0                	add    %eax,%eax
  80017e:	2b 45 e8             	sub    -0x18(%ebp),%eax
  800181:	83 ec 0c             	sub    $0xc,%esp
  800184:	50                   	push   %eax
  800185:	e8 78 18 00 00       	call   801a02 <malloc>
  80018a:	83 c4 10             	add    $0x10,%esp
  80018d:	89 45 94             	mov    %eax,-0x6c(%ebp)
		if ((uint32) ptr_allocations[1] != (USER_HEAP_START + 2*Mega)) panic("Wrong start address for the allocated space... ");
  800190:	8b 45 94             	mov    -0x6c(%ebp),%eax
  800193:	89 c2                	mov    %eax,%edx
  800195:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800198:	01 c0                	add    %eax,%eax
  80019a:	05 00 00 00 80       	add    $0x80000000,%eax
  80019f:	39 c2                	cmp    %eax,%edx
  8001a1:	74 14                	je     8001b7 <_main+0x17f>
  8001a3:	83 ec 04             	sub    $0x4,%esp
  8001a6:	68 78 36 80 00       	push   $0x803678
  8001ab:	6a 39                	push   $0x39
  8001ad:	68 1c 36 80 00       	push   $0x80361c
  8001b2:	e8 05 06 00 00       	call   8007bc <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 512 ) panic("Wrong allocation: ");
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  0) panic("Wrong page file allocation: ");
  8001b7:	e8 f2 1c 00 00       	call   801eae <sys_pf_calculate_allocated_pages>
  8001bc:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  8001bf:	74 14                	je     8001d5 <_main+0x19d>
  8001c1:	83 ec 04             	sub    $0x4,%esp
  8001c4:	68 a8 36 80 00       	push   $0x8036a8
  8001c9:	6a 3b                	push   $0x3b
  8001cb:	68 1c 36 80 00       	push   $0x80361c
  8001d0:	e8 e7 05 00 00       	call   8007bc <_panic>

		//3 KB
		freeFrames = sys_calculate_free_frames() ;
  8001d5:	e8 34 1c 00 00       	call   801e0e <sys_calculate_free_frames>
  8001da:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  8001dd:	e8 cc 1c 00 00       	call   801eae <sys_pf_calculate_allocated_pages>
  8001e2:	89 45 e0             	mov    %eax,-0x20(%ebp)
		ptr_allocations[2] = malloc(3*kilo);
  8001e5:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8001e8:	89 c2                	mov    %eax,%edx
  8001ea:	01 d2                	add    %edx,%edx
  8001ec:	01 d0                	add    %edx,%eax
  8001ee:	83 ec 0c             	sub    $0xc,%esp
  8001f1:	50                   	push   %eax
  8001f2:	e8 0b 18 00 00       	call   801a02 <malloc>
  8001f7:	83 c4 10             	add    $0x10,%esp
  8001fa:	89 45 98             	mov    %eax,-0x68(%ebp)
		if ((uint32) ptr_allocations[2] != (USER_HEAP_START + 4*Mega)) panic("Wrong start address for the allocated space... ");
  8001fd:	8b 45 98             	mov    -0x68(%ebp),%eax
  800200:	89 c2                	mov    %eax,%edx
  800202:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800205:	c1 e0 02             	shl    $0x2,%eax
  800208:	05 00 00 00 80       	add    $0x80000000,%eax
  80020d:	39 c2                	cmp    %eax,%edx
  80020f:	74 14                	je     800225 <_main+0x1ed>
  800211:	83 ec 04             	sub    $0x4,%esp
  800214:	68 78 36 80 00       	push   $0x803678
  800219:	6a 41                	push   $0x41
  80021b:	68 1c 36 80 00       	push   $0x80361c
  800220:	e8 97 05 00 00       	call   8007bc <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 1+1 ) panic("Wrong allocation: ");
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  0) panic("Wrong page file allocation: ");
  800225:	e8 84 1c 00 00       	call   801eae <sys_pf_calculate_allocated_pages>
  80022a:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  80022d:	74 14                	je     800243 <_main+0x20b>
  80022f:	83 ec 04             	sub    $0x4,%esp
  800232:	68 a8 36 80 00       	push   $0x8036a8
  800237:	6a 43                	push   $0x43
  800239:	68 1c 36 80 00       	push   $0x80361c
  80023e:	e8 79 05 00 00       	call   8007bc <_panic>

		//3 KB
		freeFrames = sys_calculate_free_frames() ;
  800243:	e8 c6 1b 00 00       	call   801e0e <sys_calculate_free_frames>
  800248:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  80024b:	e8 5e 1c 00 00       	call   801eae <sys_pf_calculate_allocated_pages>
  800250:	89 45 e0             	mov    %eax,-0x20(%ebp)
		ptr_allocations[3] = malloc(3*kilo);
  800253:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800256:	89 c2                	mov    %eax,%edx
  800258:	01 d2                	add    %edx,%edx
  80025a:	01 d0                	add    %edx,%eax
  80025c:	83 ec 0c             	sub    $0xc,%esp
  80025f:	50                   	push   %eax
  800260:	e8 9d 17 00 00       	call   801a02 <malloc>
  800265:	83 c4 10             	add    $0x10,%esp
  800268:	89 45 9c             	mov    %eax,-0x64(%ebp)
		if ((uint32) ptr_allocations[3] != (USER_HEAP_START + 4*Mega + 4*kilo)) panic("Wrong start address for the allocated space... ");
  80026b:	8b 45 9c             	mov    -0x64(%ebp),%eax
  80026e:	89 c2                	mov    %eax,%edx
  800270:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800273:	c1 e0 02             	shl    $0x2,%eax
  800276:	89 c1                	mov    %eax,%ecx
  800278:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80027b:	c1 e0 02             	shl    $0x2,%eax
  80027e:	01 c8                	add    %ecx,%eax
  800280:	05 00 00 00 80       	add    $0x80000000,%eax
  800285:	39 c2                	cmp    %eax,%edx
  800287:	74 14                	je     80029d <_main+0x265>
  800289:	83 ec 04             	sub    $0x4,%esp
  80028c:	68 78 36 80 00       	push   $0x803678
  800291:	6a 49                	push   $0x49
  800293:	68 1c 36 80 00       	push   $0x80361c
  800298:	e8 1f 05 00 00       	call   8007bc <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 1 ) panic("Wrong allocation: ");
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  0) panic("Wrong page file allocation: ");
  80029d:	e8 0c 1c 00 00       	call   801eae <sys_pf_calculate_allocated_pages>
  8002a2:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  8002a5:	74 14                	je     8002bb <_main+0x283>
  8002a7:	83 ec 04             	sub    $0x4,%esp
  8002aa:	68 a8 36 80 00       	push   $0x8036a8
  8002af:	6a 4b                	push   $0x4b
  8002b1:	68 1c 36 80 00       	push   $0x80361c
  8002b6:	e8 01 05 00 00       	call   8007bc <_panic>

		//4 KB Hole
		freeFrames = sys_calculate_free_frames() ;
  8002bb:	e8 4e 1b 00 00       	call   801e0e <sys_calculate_free_frames>
  8002c0:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  8002c3:	e8 e6 1b 00 00       	call   801eae <sys_pf_calculate_allocated_pages>
  8002c8:	89 45 e0             	mov    %eax,-0x20(%ebp)
		free(ptr_allocations[2]);
  8002cb:	8b 45 98             	mov    -0x68(%ebp),%eax
  8002ce:	83 ec 0c             	sub    $0xc,%esp
  8002d1:	50                   	push   %eax
  8002d2:	e8 ac 17 00 00       	call   801a83 <free>
  8002d7:	83 c4 10             	add    $0x10,%esp
		//if ((sys_calculate_free_frames() - freeFrames) != 1) panic("Wrong free: ");
		if( (usedDiskPages-sys_pf_calculate_allocated_pages()) !=  0) panic("Wrong page file free: ");
  8002da:	e8 cf 1b 00 00       	call   801eae <sys_pf_calculate_allocated_pages>
  8002df:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  8002e2:	74 14                	je     8002f8 <_main+0x2c0>
  8002e4:	83 ec 04             	sub    $0x4,%esp
  8002e7:	68 c5 36 80 00       	push   $0x8036c5
  8002ec:	6a 52                	push   $0x52
  8002ee:	68 1c 36 80 00       	push   $0x80361c
  8002f3:	e8 c4 04 00 00       	call   8007bc <_panic>

		//7 KB
		freeFrames = sys_calculate_free_frames() ;
  8002f8:	e8 11 1b 00 00       	call   801e0e <sys_calculate_free_frames>
  8002fd:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  800300:	e8 a9 1b 00 00       	call   801eae <sys_pf_calculate_allocated_pages>
  800305:	89 45 e0             	mov    %eax,-0x20(%ebp)
		ptr_allocations[4] = malloc(7*kilo);
  800308:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80030b:	89 d0                	mov    %edx,%eax
  80030d:	01 c0                	add    %eax,%eax
  80030f:	01 d0                	add    %edx,%eax
  800311:	01 c0                	add    %eax,%eax
  800313:	01 d0                	add    %edx,%eax
  800315:	83 ec 0c             	sub    $0xc,%esp
  800318:	50                   	push   %eax
  800319:	e8 e4 16 00 00       	call   801a02 <malloc>
  80031e:	83 c4 10             	add    $0x10,%esp
  800321:	89 45 a0             	mov    %eax,-0x60(%ebp)
		if ((uint32) ptr_allocations[4] != (USER_HEAP_START + 4*Mega + 8*kilo)) panic("Wrong start address for the allocated space... ");
  800324:	8b 45 a0             	mov    -0x60(%ebp),%eax
  800327:	89 c2                	mov    %eax,%edx
  800329:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80032c:	c1 e0 02             	shl    $0x2,%eax
  80032f:	89 c1                	mov    %eax,%ecx
  800331:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800334:	c1 e0 03             	shl    $0x3,%eax
  800337:	01 c8                	add    %ecx,%eax
  800339:	05 00 00 00 80       	add    $0x80000000,%eax
  80033e:	39 c2                	cmp    %eax,%edx
  800340:	74 14                	je     800356 <_main+0x31e>
  800342:	83 ec 04             	sub    $0x4,%esp
  800345:	68 78 36 80 00       	push   $0x803678
  80034a:	6a 58                	push   $0x58
  80034c:	68 1c 36 80 00       	push   $0x80361c
  800351:	e8 66 04 00 00       	call   8007bc <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 2)panic("Wrong allocation: ");
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  0) panic("Wrong page file allocation: ");
  800356:	e8 53 1b 00 00       	call   801eae <sys_pf_calculate_allocated_pages>
  80035b:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  80035e:	74 14                	je     800374 <_main+0x33c>
  800360:	83 ec 04             	sub    $0x4,%esp
  800363:	68 a8 36 80 00       	push   $0x8036a8
  800368:	6a 5a                	push   $0x5a
  80036a:	68 1c 36 80 00       	push   $0x80361c
  80036f:	e8 48 04 00 00       	call   8007bc <_panic>

		//2 MB Hole
		freeFrames = sys_calculate_free_frames() ;
  800374:	e8 95 1a 00 00       	call   801e0e <sys_calculate_free_frames>
  800379:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  80037c:	e8 2d 1b 00 00       	call   801eae <sys_pf_calculate_allocated_pages>
  800381:	89 45 e0             	mov    %eax,-0x20(%ebp)
		free(ptr_allocations[0]);
  800384:	8b 45 90             	mov    -0x70(%ebp),%eax
  800387:	83 ec 0c             	sub    $0xc,%esp
  80038a:	50                   	push   %eax
  80038b:	e8 f3 16 00 00       	call   801a83 <free>
  800390:	83 c4 10             	add    $0x10,%esp
		//if ((sys_calculate_free_frames() - freeFrames) != 512) panic("Wrong free: ");
		if( (usedDiskPages - sys_pf_calculate_allocated_pages() ) !=  0) panic("Wrong page file free: ");
  800393:	e8 16 1b 00 00       	call   801eae <sys_pf_calculate_allocated_pages>
  800398:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  80039b:	74 14                	je     8003b1 <_main+0x379>
  80039d:	83 ec 04             	sub    $0x4,%esp
  8003a0:	68 c5 36 80 00       	push   $0x8036c5
  8003a5:	6a 61                	push   $0x61
  8003a7:	68 1c 36 80 00       	push   $0x80361c
  8003ac:	e8 0b 04 00 00       	call   8007bc <_panic>

		//3 MB
		freeFrames = sys_calculate_free_frames() ;
  8003b1:	e8 58 1a 00 00       	call   801e0e <sys_calculate_free_frames>
  8003b6:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  8003b9:	e8 f0 1a 00 00       	call   801eae <sys_pf_calculate_allocated_pages>
  8003be:	89 45 e0             	mov    %eax,-0x20(%ebp)
		ptr_allocations[5] = malloc(3*Mega-kilo);
  8003c1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8003c4:	89 c2                	mov    %eax,%edx
  8003c6:	01 d2                	add    %edx,%edx
  8003c8:	01 d0                	add    %edx,%eax
  8003ca:	2b 45 e8             	sub    -0x18(%ebp),%eax
  8003cd:	83 ec 0c             	sub    $0xc,%esp
  8003d0:	50                   	push   %eax
  8003d1:	e8 2c 16 00 00       	call   801a02 <malloc>
  8003d6:	83 c4 10             	add    $0x10,%esp
  8003d9:	89 45 a4             	mov    %eax,-0x5c(%ebp)
		if ((uint32) ptr_allocations[5] !=  (USER_HEAP_START + 4*Mega + 16*kilo)) panic("Wrong start address for the allocated space... ");
  8003dc:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  8003df:	89 c2                	mov    %eax,%edx
  8003e1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8003e4:	c1 e0 02             	shl    $0x2,%eax
  8003e7:	89 c1                	mov    %eax,%ecx
  8003e9:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8003ec:	c1 e0 04             	shl    $0x4,%eax
  8003ef:	01 c8                	add    %ecx,%eax
  8003f1:	05 00 00 00 80       	add    $0x80000000,%eax
  8003f6:	39 c2                	cmp    %eax,%edx
  8003f8:	74 14                	je     80040e <_main+0x3d6>
  8003fa:	83 ec 04             	sub    $0x4,%esp
  8003fd:	68 78 36 80 00       	push   $0x803678
  800402:	6a 67                	push   $0x67
  800404:	68 1c 36 80 00       	push   $0x80361c
  800409:	e8 ae 03 00 00       	call   8007bc <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 3*Mega/4096 ) panic("Wrong allocation: ");
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  0) panic("Wrong page file allocation: ");
  80040e:	e8 9b 1a 00 00       	call   801eae <sys_pf_calculate_allocated_pages>
  800413:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  800416:	74 14                	je     80042c <_main+0x3f4>
  800418:	83 ec 04             	sub    $0x4,%esp
  80041b:	68 a8 36 80 00       	push   $0x8036a8
  800420:	6a 69                	push   $0x69
  800422:	68 1c 36 80 00       	push   $0x80361c
  800427:	e8 90 03 00 00       	call   8007bc <_panic>

		//2 MB + 6 KB
		freeFrames = sys_calculate_free_frames() ;
  80042c:	e8 dd 19 00 00       	call   801e0e <sys_calculate_free_frames>
  800431:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  800434:	e8 75 1a 00 00       	call   801eae <sys_pf_calculate_allocated_pages>
  800439:	89 45 e0             	mov    %eax,-0x20(%ebp)
		ptr_allocations[6] = malloc(2*Mega + 6*kilo);
  80043c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80043f:	89 c2                	mov    %eax,%edx
  800441:	01 d2                	add    %edx,%edx
  800443:	01 c2                	add    %eax,%edx
  800445:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800448:	01 d0                	add    %edx,%eax
  80044a:	01 c0                	add    %eax,%eax
  80044c:	83 ec 0c             	sub    $0xc,%esp
  80044f:	50                   	push   %eax
  800450:	e8 ad 15 00 00       	call   801a02 <malloc>
  800455:	83 c4 10             	add    $0x10,%esp
  800458:	89 45 a8             	mov    %eax,-0x58(%ebp)
		if ((uint32) ptr_allocations[6] !=  (USER_HEAP_START + 7*Mega + 16*kilo)) panic("Wrong start address for the allocated space... ");
  80045b:	8b 45 a8             	mov    -0x58(%ebp),%eax
  80045e:	89 c1                	mov    %eax,%ecx
  800460:	8b 55 ec             	mov    -0x14(%ebp),%edx
  800463:	89 d0                	mov    %edx,%eax
  800465:	01 c0                	add    %eax,%eax
  800467:	01 d0                	add    %edx,%eax
  800469:	01 c0                	add    %eax,%eax
  80046b:	01 d0                	add    %edx,%eax
  80046d:	89 c2                	mov    %eax,%edx
  80046f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800472:	c1 e0 04             	shl    $0x4,%eax
  800475:	01 d0                	add    %edx,%eax
  800477:	05 00 00 00 80       	add    $0x80000000,%eax
  80047c:	39 c1                	cmp    %eax,%ecx
  80047e:	74 14                	je     800494 <_main+0x45c>
  800480:	83 ec 04             	sub    $0x4,%esp
  800483:	68 78 36 80 00       	push   $0x803678
  800488:	6a 6f                	push   $0x6f
  80048a:	68 1c 36 80 00       	push   $0x80361c
  80048f:	e8 28 03 00 00       	call   8007bc <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 514+1 ) panic("Wrong allocation: ");
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  0) panic("Wrong page file allocation: ");
  800494:	e8 15 1a 00 00       	call   801eae <sys_pf_calculate_allocated_pages>
  800499:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  80049c:	74 14                	je     8004b2 <_main+0x47a>
  80049e:	83 ec 04             	sub    $0x4,%esp
  8004a1:	68 a8 36 80 00       	push   $0x8036a8
  8004a6:	6a 71                	push   $0x71
  8004a8:	68 1c 36 80 00       	push   $0x80361c
  8004ad:	e8 0a 03 00 00       	call   8007bc <_panic>

		//3 MB Hole
		freeFrames = sys_calculate_free_frames() ;
  8004b2:	e8 57 19 00 00       	call   801e0e <sys_calculate_free_frames>
  8004b7:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  8004ba:	e8 ef 19 00 00       	call   801eae <sys_pf_calculate_allocated_pages>
  8004bf:	89 45 e0             	mov    %eax,-0x20(%ebp)
		free(ptr_allocations[5]);
  8004c2:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  8004c5:	83 ec 0c             	sub    $0xc,%esp
  8004c8:	50                   	push   %eax
  8004c9:	e8 b5 15 00 00       	call   801a83 <free>
  8004ce:	83 c4 10             	add    $0x10,%esp
		//if ((sys_calculate_free_frames() - freeFrames) != 768) panic("Wrong free: ");
		if( (usedDiskPages - sys_pf_calculate_allocated_pages()) !=  0) panic("Wrong page file free: ");
  8004d1:	e8 d8 19 00 00       	call   801eae <sys_pf_calculate_allocated_pages>
  8004d6:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  8004d9:	74 14                	je     8004ef <_main+0x4b7>
  8004db:	83 ec 04             	sub    $0x4,%esp
  8004de:	68 c5 36 80 00       	push   $0x8036c5
  8004e3:	6a 78                	push   $0x78
  8004e5:	68 1c 36 80 00       	push   $0x80361c
  8004ea:	e8 cd 02 00 00       	call   8007bc <_panic>

		//2 MB Hole [Resulting Hole = 2 MB + 2 MB + 4 KB = 4 MB + 4 KB]
		freeFrames = sys_calculate_free_frames() ;
  8004ef:	e8 1a 19 00 00       	call   801e0e <sys_calculate_free_frames>
  8004f4:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  8004f7:	e8 b2 19 00 00       	call   801eae <sys_pf_calculate_allocated_pages>
  8004fc:	89 45 e0             	mov    %eax,-0x20(%ebp)
		free(ptr_allocations[1]);
  8004ff:	8b 45 94             	mov    -0x6c(%ebp),%eax
  800502:	83 ec 0c             	sub    $0xc,%esp
  800505:	50                   	push   %eax
  800506:	e8 78 15 00 00       	call   801a83 <free>
  80050b:	83 c4 10             	add    $0x10,%esp
		//if ((sys_calculate_free_frames() - freeFrames) != 512) panic("Wrong free: ");
		if( (usedDiskPages - sys_pf_calculate_allocated_pages() ) !=  0) panic("Wrong page file free: ");
  80050e:	e8 9b 19 00 00       	call   801eae <sys_pf_calculate_allocated_pages>
  800513:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  800516:	74 14                	je     80052c <_main+0x4f4>
  800518:	83 ec 04             	sub    $0x4,%esp
  80051b:	68 c5 36 80 00       	push   $0x8036c5
  800520:	6a 7f                	push   $0x7f
  800522:	68 1c 36 80 00       	push   $0x80361c
  800527:	e8 90 02 00 00       	call   8007bc <_panic>

		//5 MB
		freeFrames = sys_calculate_free_frames() ;
  80052c:	e8 dd 18 00 00       	call   801e0e <sys_calculate_free_frames>
  800531:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  800534:	e8 75 19 00 00       	call   801eae <sys_pf_calculate_allocated_pages>
  800539:	89 45 e0             	mov    %eax,-0x20(%ebp)
		ptr_allocations[7] = malloc(5*Mega-kilo);
  80053c:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80053f:	89 d0                	mov    %edx,%eax
  800541:	c1 e0 02             	shl    $0x2,%eax
  800544:	01 d0                	add    %edx,%eax
  800546:	2b 45 e8             	sub    -0x18(%ebp),%eax
  800549:	83 ec 0c             	sub    $0xc,%esp
  80054c:	50                   	push   %eax
  80054d:	e8 b0 14 00 00       	call   801a02 <malloc>
  800552:	83 c4 10             	add    $0x10,%esp
  800555:	89 45 ac             	mov    %eax,-0x54(%ebp)
		if ((uint32) ptr_allocations[7] != (USER_HEAP_START + 9*Mega + 24*kilo)) panic("Wrong start address for the allocated space... ");
  800558:	8b 45 ac             	mov    -0x54(%ebp),%eax
  80055b:	89 c1                	mov    %eax,%ecx
  80055d:	8b 55 ec             	mov    -0x14(%ebp),%edx
  800560:	89 d0                	mov    %edx,%eax
  800562:	c1 e0 03             	shl    $0x3,%eax
  800565:	01 d0                	add    %edx,%eax
  800567:	89 c3                	mov    %eax,%ebx
  800569:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80056c:	89 d0                	mov    %edx,%eax
  80056e:	01 c0                	add    %eax,%eax
  800570:	01 d0                	add    %edx,%eax
  800572:	c1 e0 03             	shl    $0x3,%eax
  800575:	01 d8                	add    %ebx,%eax
  800577:	05 00 00 00 80       	add    $0x80000000,%eax
  80057c:	39 c1                	cmp    %eax,%ecx
  80057e:	74 17                	je     800597 <_main+0x55f>
  800580:	83 ec 04             	sub    $0x4,%esp
  800583:	68 78 36 80 00       	push   $0x803678
  800588:	68 85 00 00 00       	push   $0x85
  80058d:	68 1c 36 80 00       	push   $0x80361c
  800592:	e8 25 02 00 00       	call   8007bc <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 5*Mega/4096 + 1) panic("Wrong allocation: ");
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  0) panic("Wrong page file allocation: ");
  800597:	e8 12 19 00 00       	call   801eae <sys_pf_calculate_allocated_pages>
  80059c:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  80059f:	74 17                	je     8005b8 <_main+0x580>
  8005a1:	83 ec 04             	sub    $0x4,%esp
  8005a4:	68 a8 36 80 00       	push   $0x8036a8
  8005a9:	68 87 00 00 00       	push   $0x87
  8005ae:	68 1c 36 80 00       	push   $0x80361c
  8005b3:	e8 04 02 00 00       	call   8007bc <_panic>
		//		//if ((sys_calculate_free_frames() - freeFrames) != 514) panic("Wrong free: ");
		//		if( (usedDiskPages - sys_pf_calculate_allocated_pages()) !=  514) panic("Wrong page file free: ");

		//[FIRST FIT Case]
		//3 MB
		freeFrames = sys_calculate_free_frames() ;
  8005b8:	e8 51 18 00 00       	call   801e0e <sys_calculate_free_frames>
  8005bd:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  8005c0:	e8 e9 18 00 00       	call   801eae <sys_pf_calculate_allocated_pages>
  8005c5:	89 45 e0             	mov    %eax,-0x20(%ebp)
		ptr_allocations[8] = malloc(3*Mega-kilo);
  8005c8:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8005cb:	89 c2                	mov    %eax,%edx
  8005cd:	01 d2                	add    %edx,%edx
  8005cf:	01 d0                	add    %edx,%eax
  8005d1:	2b 45 e8             	sub    -0x18(%ebp),%eax
  8005d4:	83 ec 0c             	sub    $0xc,%esp
  8005d7:	50                   	push   %eax
  8005d8:	e8 25 14 00 00       	call   801a02 <malloc>
  8005dd:	83 c4 10             	add    $0x10,%esp
  8005e0:	89 45 b0             	mov    %eax,-0x50(%ebp)
		if ((uint32) ptr_allocations[8] != (USER_HEAP_START)) panic("Wrong start address for the allocated space... ");
  8005e3:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8005e6:	3d 00 00 00 80       	cmp    $0x80000000,%eax
  8005eb:	74 17                	je     800604 <_main+0x5cc>
  8005ed:	83 ec 04             	sub    $0x4,%esp
  8005f0:	68 78 36 80 00       	push   $0x803678
  8005f5:	68 95 00 00 00       	push   $0x95
  8005fa:	68 1c 36 80 00       	push   $0x80361c
  8005ff:	e8 b8 01 00 00       	call   8007bc <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 3*Mega/4096) panic("Wrong allocation: ");
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  0) panic("Wrong page file allocation: ");
  800604:	e8 a5 18 00 00       	call   801eae <sys_pf_calculate_allocated_pages>
  800609:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  80060c:	74 17                	je     800625 <_main+0x5ed>
  80060e:	83 ec 04             	sub    $0x4,%esp
  800611:	68 a8 36 80 00       	push   $0x8036a8
  800616:	68 97 00 00 00       	push   $0x97
  80061b:	68 1c 36 80 00       	push   $0x80361c
  800620:	e8 97 01 00 00       	call   8007bc <_panic>
	//	b) Attempt to allocate large segment with no suitable fragment to fit on
	{
		//Large Allocation
		//int freeFrames = sys_calculate_free_frames() ;
		//usedDiskPages = sys_pf_calculate_allocated_pages();
		ptr_allocations[9] = malloc((USER_HEAP_MAX - USER_HEAP_START - 14*Mega));
  800625:	8b 55 ec             	mov    -0x14(%ebp),%edx
  800628:	89 d0                	mov    %edx,%eax
  80062a:	01 c0                	add    %eax,%eax
  80062c:	01 d0                	add    %edx,%eax
  80062e:	01 c0                	add    %eax,%eax
  800630:	01 d0                	add    %edx,%eax
  800632:	01 c0                	add    %eax,%eax
  800634:	f7 d8                	neg    %eax
  800636:	05 00 00 00 20       	add    $0x20000000,%eax
  80063b:	83 ec 0c             	sub    $0xc,%esp
  80063e:	50                   	push   %eax
  80063f:	e8 be 13 00 00       	call   801a02 <malloc>
  800644:	83 c4 10             	add    $0x10,%esp
  800647:	89 45 b4             	mov    %eax,-0x4c(%ebp)
		if (ptr_allocations[9] != NULL) panic("Malloc: Attempt to allocate large segment with no suitable fragment to fit on, should return NULL");
  80064a:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  80064d:	85 c0                	test   %eax,%eax
  80064f:	74 17                	je     800668 <_main+0x630>
  800651:	83 ec 04             	sub    $0x4,%esp
  800654:	68 dc 36 80 00       	push   $0x8036dc
  800659:	68 a0 00 00 00       	push   $0xa0
  80065e:	68 1c 36 80 00       	push   $0x80361c
  800663:	e8 54 01 00 00       	call   8007bc <_panic>

		cprintf("Congratulations!! test FIRST FIT allocation (2) completed successfully.\n");
  800668:	83 ec 0c             	sub    $0xc,%esp
  80066b:	68 40 37 80 00       	push   $0x803740
  800670:	e8 fb 03 00 00       	call   800a70 <cprintf>
  800675:	83 c4 10             	add    $0x10,%esp

		return;
  800678:	90                   	nop
	}
}
  800679:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80067c:	5b                   	pop    %ebx
  80067d:	5f                   	pop    %edi
  80067e:	5d                   	pop    %ebp
  80067f:	c3                   	ret    

00800680 <libmain>:
volatile struct Env *myEnv = NULL;
volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";

void
libmain(int argc, char **argv)
{
  800680:	55                   	push   %ebp
  800681:	89 e5                	mov    %esp,%ebp
  800683:	83 ec 18             	sub    $0x18,%esp
	int envIndex = sys_getenvindex();
  800686:	e8 63 1a 00 00       	call   8020ee <sys_getenvindex>
  80068b:	89 45 f4             	mov    %eax,-0xc(%ebp)
	myEnv = &(envs[envIndex]);
  80068e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800691:	89 d0                	mov    %edx,%eax
  800693:	c1 e0 03             	shl    $0x3,%eax
  800696:	01 d0                	add    %edx,%eax
  800698:	01 c0                	add    %eax,%eax
  80069a:	01 d0                	add    %edx,%eax
  80069c:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8006a3:	01 d0                	add    %edx,%eax
  8006a5:	c1 e0 04             	shl    $0x4,%eax
  8006a8:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8006ad:	a3 20 40 80 00       	mov    %eax,0x804020

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  8006b2:	a1 20 40 80 00       	mov    0x804020,%eax
  8006b7:	8a 80 5c 05 00 00    	mov    0x55c(%eax),%al
  8006bd:	84 c0                	test   %al,%al
  8006bf:	74 0f                	je     8006d0 <libmain+0x50>
		binaryname = myEnv->prog_name;
  8006c1:	a1 20 40 80 00       	mov    0x804020,%eax
  8006c6:	05 5c 05 00 00       	add    $0x55c,%eax
  8006cb:	a3 00 40 80 00       	mov    %eax,0x804000

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8006d0:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8006d4:	7e 0a                	jle    8006e0 <libmain+0x60>
		binaryname = argv[0];
  8006d6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8006d9:	8b 00                	mov    (%eax),%eax
  8006db:	a3 00 40 80 00       	mov    %eax,0x804000

	// call user main routine
	_main(argc, argv);
  8006e0:	83 ec 08             	sub    $0x8,%esp
  8006e3:	ff 75 0c             	pushl  0xc(%ebp)
  8006e6:	ff 75 08             	pushl  0x8(%ebp)
  8006e9:	e8 4a f9 ff ff       	call   800038 <_main>
  8006ee:	83 c4 10             	add    $0x10,%esp



	sys_disable_interrupt();
  8006f1:	e8 05 18 00 00       	call   801efb <sys_disable_interrupt>
	cprintf("**************************************\n");
  8006f6:	83 ec 0c             	sub    $0xc,%esp
  8006f9:	68 a4 37 80 00       	push   $0x8037a4
  8006fe:	e8 6d 03 00 00       	call   800a70 <cprintf>
  800703:	83 c4 10             	add    $0x10,%esp
	cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  800706:	a1 20 40 80 00       	mov    0x804020,%eax
  80070b:	8b 90 44 05 00 00    	mov    0x544(%eax),%edx
  800711:	a1 20 40 80 00       	mov    0x804020,%eax
  800716:	8b 80 34 05 00 00    	mov    0x534(%eax),%eax
  80071c:	83 ec 04             	sub    $0x4,%esp
  80071f:	52                   	push   %edx
  800720:	50                   	push   %eax
  800721:	68 cc 37 80 00       	push   $0x8037cc
  800726:	e8 45 03 00 00       	call   800a70 <cprintf>
  80072b:	83 c4 10             	add    $0x10,%esp
	cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  80072e:	a1 20 40 80 00       	mov    0x804020,%eax
  800733:	8b 88 54 05 00 00    	mov    0x554(%eax),%ecx
  800739:	a1 20 40 80 00       	mov    0x804020,%eax
  80073e:	8b 90 50 05 00 00    	mov    0x550(%eax),%edx
  800744:	a1 20 40 80 00       	mov    0x804020,%eax
  800749:	8b 80 4c 05 00 00    	mov    0x54c(%eax),%eax
  80074f:	51                   	push   %ecx
  800750:	52                   	push   %edx
  800751:	50                   	push   %eax
  800752:	68 f4 37 80 00       	push   $0x8037f4
  800757:	e8 14 03 00 00       	call   800a70 <cprintf>
  80075c:	83 c4 10             	add    $0x10,%esp
	//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
	cprintf("Num of clocks = %d\n", myEnv->nClocks);
  80075f:	a1 20 40 80 00       	mov    0x804020,%eax
  800764:	8b 80 a4 05 00 00    	mov    0x5a4(%eax),%eax
  80076a:	83 ec 08             	sub    $0x8,%esp
  80076d:	50                   	push   %eax
  80076e:	68 4c 38 80 00       	push   $0x80384c
  800773:	e8 f8 02 00 00       	call   800a70 <cprintf>
  800778:	83 c4 10             	add    $0x10,%esp
	cprintf("**************************************\n");
  80077b:	83 ec 0c             	sub    $0xc,%esp
  80077e:	68 a4 37 80 00       	push   $0x8037a4
  800783:	e8 e8 02 00 00       	call   800a70 <cprintf>
  800788:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  80078b:	e8 85 17 00 00       	call   801f15 <sys_enable_interrupt>

	// exit gracefully
	exit();
  800790:	e8 19 00 00 00       	call   8007ae <exit>
}
  800795:	90                   	nop
  800796:	c9                   	leave  
  800797:	c3                   	ret    

00800798 <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  800798:	55                   	push   %ebp
  800799:	89 e5                	mov    %esp,%ebp
  80079b:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  80079e:	83 ec 0c             	sub    $0xc,%esp
  8007a1:	6a 00                	push   $0x0
  8007a3:	e8 12 19 00 00       	call   8020ba <sys_destroy_env>
  8007a8:	83 c4 10             	add    $0x10,%esp
}
  8007ab:	90                   	nop
  8007ac:	c9                   	leave  
  8007ad:	c3                   	ret    

008007ae <exit>:

void
exit(void)
{
  8007ae:	55                   	push   %ebp
  8007af:	89 e5                	mov    %esp,%ebp
  8007b1:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  8007b4:	e8 67 19 00 00       	call   802120 <sys_exit_env>
}
  8007b9:	90                   	nop
  8007ba:	c9                   	leave  
  8007bb:	c3                   	ret    

008007bc <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  8007bc:	55                   	push   %ebp
  8007bd:	89 e5                	mov    %esp,%ebp
  8007bf:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  8007c2:	8d 45 10             	lea    0x10(%ebp),%eax
  8007c5:	83 c0 04             	add    $0x4,%eax
  8007c8:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  8007cb:	a1 5c 41 80 00       	mov    0x80415c,%eax
  8007d0:	85 c0                	test   %eax,%eax
  8007d2:	74 16                	je     8007ea <_panic+0x2e>
		cprintf("%s: ", argv0);
  8007d4:	a1 5c 41 80 00       	mov    0x80415c,%eax
  8007d9:	83 ec 08             	sub    $0x8,%esp
  8007dc:	50                   	push   %eax
  8007dd:	68 60 38 80 00       	push   $0x803860
  8007e2:	e8 89 02 00 00       	call   800a70 <cprintf>
  8007e7:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  8007ea:	a1 00 40 80 00       	mov    0x804000,%eax
  8007ef:	ff 75 0c             	pushl  0xc(%ebp)
  8007f2:	ff 75 08             	pushl  0x8(%ebp)
  8007f5:	50                   	push   %eax
  8007f6:	68 65 38 80 00       	push   $0x803865
  8007fb:	e8 70 02 00 00       	call   800a70 <cprintf>
  800800:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  800803:	8b 45 10             	mov    0x10(%ebp),%eax
  800806:	83 ec 08             	sub    $0x8,%esp
  800809:	ff 75 f4             	pushl  -0xc(%ebp)
  80080c:	50                   	push   %eax
  80080d:	e8 f3 01 00 00       	call   800a05 <vcprintf>
  800812:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  800815:	83 ec 08             	sub    $0x8,%esp
  800818:	6a 00                	push   $0x0
  80081a:	68 81 38 80 00       	push   $0x803881
  80081f:	e8 e1 01 00 00       	call   800a05 <vcprintf>
  800824:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  800827:	e8 82 ff ff ff       	call   8007ae <exit>

	// should not return here
	while (1) ;
  80082c:	eb fe                	jmp    80082c <_panic+0x70>

0080082e <CheckWSWithoutLastIndex>:
}

void CheckWSWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  80082e:	55                   	push   %ebp
  80082f:	89 e5                	mov    %esp,%ebp
  800831:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  800834:	a1 20 40 80 00       	mov    0x804020,%eax
  800839:	8b 50 74             	mov    0x74(%eax),%edx
  80083c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80083f:	39 c2                	cmp    %eax,%edx
  800841:	74 14                	je     800857 <CheckWSWithoutLastIndex+0x29>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  800843:	83 ec 04             	sub    $0x4,%esp
  800846:	68 84 38 80 00       	push   $0x803884
  80084b:	6a 26                	push   $0x26
  80084d:	68 d0 38 80 00       	push   $0x8038d0
  800852:	e8 65 ff ff ff       	call   8007bc <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  800857:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  80085e:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800865:	e9 c2 00 00 00       	jmp    80092c <CheckWSWithoutLastIndex+0xfe>
		if (expectedPages[e] == 0) {
  80086a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80086d:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800874:	8b 45 08             	mov    0x8(%ebp),%eax
  800877:	01 d0                	add    %edx,%eax
  800879:	8b 00                	mov    (%eax),%eax
  80087b:	85 c0                	test   %eax,%eax
  80087d:	75 08                	jne    800887 <CheckWSWithoutLastIndex+0x59>
			expectedNumOfEmptyLocs++;
  80087f:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  800882:	e9 a2 00 00 00       	jmp    800929 <CheckWSWithoutLastIndex+0xfb>
		}
		int found = 0;
  800887:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  80088e:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  800895:	eb 69                	jmp    800900 <CheckWSWithoutLastIndex+0xd2>
			if (myEnv->__uptr_pws[w].empty == 0) {
  800897:	a1 20 40 80 00       	mov    0x804020,%eax
  80089c:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  8008a2:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8008a5:	89 d0                	mov    %edx,%eax
  8008a7:	01 c0                	add    %eax,%eax
  8008a9:	01 d0                	add    %edx,%eax
  8008ab:	c1 e0 03             	shl    $0x3,%eax
  8008ae:	01 c8                	add    %ecx,%eax
  8008b0:	8a 40 04             	mov    0x4(%eax),%al
  8008b3:	84 c0                	test   %al,%al
  8008b5:	75 46                	jne    8008fd <CheckWSWithoutLastIndex+0xcf>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  8008b7:	a1 20 40 80 00       	mov    0x804020,%eax
  8008bc:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  8008c2:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8008c5:	89 d0                	mov    %edx,%eax
  8008c7:	01 c0                	add    %eax,%eax
  8008c9:	01 d0                	add    %edx,%eax
  8008cb:	c1 e0 03             	shl    $0x3,%eax
  8008ce:	01 c8                	add    %ecx,%eax
  8008d0:	8b 00                	mov    (%eax),%eax
  8008d2:	89 45 dc             	mov    %eax,-0x24(%ebp)
  8008d5:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8008d8:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8008dd:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  8008df:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8008e2:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  8008e9:	8b 45 08             	mov    0x8(%ebp),%eax
  8008ec:	01 c8                	add    %ecx,%eax
  8008ee:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  8008f0:	39 c2                	cmp    %eax,%edx
  8008f2:	75 09                	jne    8008fd <CheckWSWithoutLastIndex+0xcf>
						== expectedPages[e]) {
					found = 1;
  8008f4:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  8008fb:	eb 12                	jmp    80090f <CheckWSWithoutLastIndex+0xe1>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8008fd:	ff 45 e8             	incl   -0x18(%ebp)
  800900:	a1 20 40 80 00       	mov    0x804020,%eax
  800905:	8b 50 74             	mov    0x74(%eax),%edx
  800908:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80090b:	39 c2                	cmp    %eax,%edx
  80090d:	77 88                	ja     800897 <CheckWSWithoutLastIndex+0x69>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  80090f:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  800913:	75 14                	jne    800929 <CheckWSWithoutLastIndex+0xfb>
			panic(
  800915:	83 ec 04             	sub    $0x4,%esp
  800918:	68 dc 38 80 00       	push   $0x8038dc
  80091d:	6a 3a                	push   $0x3a
  80091f:	68 d0 38 80 00       	push   $0x8038d0
  800924:	e8 93 fe ff ff       	call   8007bc <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  800929:	ff 45 f0             	incl   -0x10(%ebp)
  80092c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80092f:	3b 45 0c             	cmp    0xc(%ebp),%eax
  800932:	0f 8c 32 ff ff ff    	jl     80086a <CheckWSWithoutLastIndex+0x3c>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  800938:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  80093f:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  800946:	eb 26                	jmp    80096e <CheckWSWithoutLastIndex+0x140>
		if (myEnv->__uptr_pws[w].empty == 1) {
  800948:	a1 20 40 80 00       	mov    0x804020,%eax
  80094d:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  800953:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800956:	89 d0                	mov    %edx,%eax
  800958:	01 c0                	add    %eax,%eax
  80095a:	01 d0                	add    %edx,%eax
  80095c:	c1 e0 03             	shl    $0x3,%eax
  80095f:	01 c8                	add    %ecx,%eax
  800961:	8a 40 04             	mov    0x4(%eax),%al
  800964:	3c 01                	cmp    $0x1,%al
  800966:	75 03                	jne    80096b <CheckWSWithoutLastIndex+0x13d>
			actualNumOfEmptyLocs++;
  800968:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  80096b:	ff 45 e0             	incl   -0x20(%ebp)
  80096e:	a1 20 40 80 00       	mov    0x804020,%eax
  800973:	8b 50 74             	mov    0x74(%eax),%edx
  800976:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800979:	39 c2                	cmp    %eax,%edx
  80097b:	77 cb                	ja     800948 <CheckWSWithoutLastIndex+0x11a>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  80097d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800980:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  800983:	74 14                	je     800999 <CheckWSWithoutLastIndex+0x16b>
		panic(
  800985:	83 ec 04             	sub    $0x4,%esp
  800988:	68 30 39 80 00       	push   $0x803930
  80098d:	6a 44                	push   $0x44
  80098f:	68 d0 38 80 00       	push   $0x8038d0
  800994:	e8 23 fe ff ff       	call   8007bc <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  800999:	90                   	nop
  80099a:	c9                   	leave  
  80099b:	c3                   	ret    

0080099c <putch>:
};

//2017:
uint8 printProgName = 0;

static void putch(int ch, struct printbuf *b) {
  80099c:	55                   	push   %ebp
  80099d:	89 e5                	mov    %esp,%ebp
  80099f:	83 ec 08             	sub    $0x8,%esp
	b->buf[b->idx++] = ch;
  8009a2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8009a5:	8b 00                	mov    (%eax),%eax
  8009a7:	8d 48 01             	lea    0x1(%eax),%ecx
  8009aa:	8b 55 0c             	mov    0xc(%ebp),%edx
  8009ad:	89 0a                	mov    %ecx,(%edx)
  8009af:	8b 55 08             	mov    0x8(%ebp),%edx
  8009b2:	88 d1                	mov    %dl,%cl
  8009b4:	8b 55 0c             	mov    0xc(%ebp),%edx
  8009b7:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  8009bb:	8b 45 0c             	mov    0xc(%ebp),%eax
  8009be:	8b 00                	mov    (%eax),%eax
  8009c0:	3d ff 00 00 00       	cmp    $0xff,%eax
  8009c5:	75 2c                	jne    8009f3 <putch+0x57>
		sys_cputs(b->buf, b->idx, printProgName);
  8009c7:	a0 24 40 80 00       	mov    0x804024,%al
  8009cc:	0f b6 c0             	movzbl %al,%eax
  8009cf:	8b 55 0c             	mov    0xc(%ebp),%edx
  8009d2:	8b 12                	mov    (%edx),%edx
  8009d4:	89 d1                	mov    %edx,%ecx
  8009d6:	8b 55 0c             	mov    0xc(%ebp),%edx
  8009d9:	83 c2 08             	add    $0x8,%edx
  8009dc:	83 ec 04             	sub    $0x4,%esp
  8009df:	50                   	push   %eax
  8009e0:	51                   	push   %ecx
  8009e1:	52                   	push   %edx
  8009e2:	e8 66 13 00 00       	call   801d4d <sys_cputs>
  8009e7:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  8009ea:	8b 45 0c             	mov    0xc(%ebp),%eax
  8009ed:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  8009f3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8009f6:	8b 40 04             	mov    0x4(%eax),%eax
  8009f9:	8d 50 01             	lea    0x1(%eax),%edx
  8009fc:	8b 45 0c             	mov    0xc(%ebp),%eax
  8009ff:	89 50 04             	mov    %edx,0x4(%eax)
}
  800a02:	90                   	nop
  800a03:	c9                   	leave  
  800a04:	c3                   	ret    

00800a05 <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  800a05:	55                   	push   %ebp
  800a06:	89 e5                	mov    %esp,%ebp
  800a08:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  800a0e:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800a15:	00 00 00 
	b.cnt = 0;
  800a18:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800a1f:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  800a22:	ff 75 0c             	pushl  0xc(%ebp)
  800a25:	ff 75 08             	pushl  0x8(%ebp)
  800a28:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800a2e:	50                   	push   %eax
  800a2f:	68 9c 09 80 00       	push   $0x80099c
  800a34:	e8 11 02 00 00       	call   800c4a <vprintfmt>
  800a39:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName);
  800a3c:	a0 24 40 80 00       	mov    0x804024,%al
  800a41:	0f b6 c0             	movzbl %al,%eax
  800a44:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  800a4a:	83 ec 04             	sub    $0x4,%esp
  800a4d:	50                   	push   %eax
  800a4e:	52                   	push   %edx
  800a4f:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800a55:	83 c0 08             	add    $0x8,%eax
  800a58:	50                   	push   %eax
  800a59:	e8 ef 12 00 00       	call   801d4d <sys_cputs>
  800a5e:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  800a61:	c6 05 24 40 80 00 00 	movb   $0x0,0x804024
	return b.cnt;
  800a68:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  800a6e:	c9                   	leave  
  800a6f:	c3                   	ret    

00800a70 <cprintf>:

int cprintf(const char *fmt, ...) {
  800a70:	55                   	push   %ebp
  800a71:	89 e5                	mov    %esp,%ebp
  800a73:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  800a76:	c6 05 24 40 80 00 01 	movb   $0x1,0x804024
	va_start(ap, fmt);
  800a7d:	8d 45 0c             	lea    0xc(%ebp),%eax
  800a80:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800a83:	8b 45 08             	mov    0x8(%ebp),%eax
  800a86:	83 ec 08             	sub    $0x8,%esp
  800a89:	ff 75 f4             	pushl  -0xc(%ebp)
  800a8c:	50                   	push   %eax
  800a8d:	e8 73 ff ff ff       	call   800a05 <vcprintf>
  800a92:	83 c4 10             	add    $0x10,%esp
  800a95:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  800a98:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800a9b:	c9                   	leave  
  800a9c:	c3                   	ret    

00800a9d <atomic_cprintf>:

int atomic_cprintf(const char *fmt, ...) {
  800a9d:	55                   	push   %ebp
  800a9e:	89 e5                	mov    %esp,%ebp
  800aa0:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  800aa3:	e8 53 14 00 00       	call   801efb <sys_disable_interrupt>
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  800aa8:	8d 45 0c             	lea    0xc(%ebp),%eax
  800aab:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800aae:	8b 45 08             	mov    0x8(%ebp),%eax
  800ab1:	83 ec 08             	sub    $0x8,%esp
  800ab4:	ff 75 f4             	pushl  -0xc(%ebp)
  800ab7:	50                   	push   %eax
  800ab8:	e8 48 ff ff ff       	call   800a05 <vcprintf>
  800abd:	83 c4 10             	add    $0x10,%esp
  800ac0:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	sys_enable_interrupt();
  800ac3:	e8 4d 14 00 00       	call   801f15 <sys_enable_interrupt>
	return cnt;
  800ac8:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800acb:	c9                   	leave  
  800acc:	c3                   	ret    

00800acd <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800acd:	55                   	push   %ebp
  800ace:	89 e5                	mov    %esp,%ebp
  800ad0:	53                   	push   %ebx
  800ad1:	83 ec 14             	sub    $0x14,%esp
  800ad4:	8b 45 10             	mov    0x10(%ebp),%eax
  800ad7:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800ada:	8b 45 14             	mov    0x14(%ebp),%eax
  800add:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800ae0:	8b 45 18             	mov    0x18(%ebp),%eax
  800ae3:	ba 00 00 00 00       	mov    $0x0,%edx
  800ae8:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800aeb:	77 55                	ja     800b42 <printnum+0x75>
  800aed:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800af0:	72 05                	jb     800af7 <printnum+0x2a>
  800af2:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800af5:	77 4b                	ja     800b42 <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800af7:	8b 45 1c             	mov    0x1c(%ebp),%eax
  800afa:	8d 58 ff             	lea    -0x1(%eax),%ebx
  800afd:	8b 45 18             	mov    0x18(%ebp),%eax
  800b00:	ba 00 00 00 00       	mov    $0x0,%edx
  800b05:	52                   	push   %edx
  800b06:	50                   	push   %eax
  800b07:	ff 75 f4             	pushl  -0xc(%ebp)
  800b0a:	ff 75 f0             	pushl  -0x10(%ebp)
  800b0d:	e8 86 28 00 00       	call   803398 <__udivdi3>
  800b12:	83 c4 10             	add    $0x10,%esp
  800b15:	83 ec 04             	sub    $0x4,%esp
  800b18:	ff 75 20             	pushl  0x20(%ebp)
  800b1b:	53                   	push   %ebx
  800b1c:	ff 75 18             	pushl  0x18(%ebp)
  800b1f:	52                   	push   %edx
  800b20:	50                   	push   %eax
  800b21:	ff 75 0c             	pushl  0xc(%ebp)
  800b24:	ff 75 08             	pushl  0x8(%ebp)
  800b27:	e8 a1 ff ff ff       	call   800acd <printnum>
  800b2c:	83 c4 20             	add    $0x20,%esp
  800b2f:	eb 1a                	jmp    800b4b <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800b31:	83 ec 08             	sub    $0x8,%esp
  800b34:	ff 75 0c             	pushl  0xc(%ebp)
  800b37:	ff 75 20             	pushl  0x20(%ebp)
  800b3a:	8b 45 08             	mov    0x8(%ebp),%eax
  800b3d:	ff d0                	call   *%eax
  800b3f:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800b42:	ff 4d 1c             	decl   0x1c(%ebp)
  800b45:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  800b49:	7f e6                	jg     800b31 <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800b4b:	8b 4d 18             	mov    0x18(%ebp),%ecx
  800b4e:	bb 00 00 00 00       	mov    $0x0,%ebx
  800b53:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800b56:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800b59:	53                   	push   %ebx
  800b5a:	51                   	push   %ecx
  800b5b:	52                   	push   %edx
  800b5c:	50                   	push   %eax
  800b5d:	e8 46 29 00 00       	call   8034a8 <__umoddi3>
  800b62:	83 c4 10             	add    $0x10,%esp
  800b65:	05 94 3b 80 00       	add    $0x803b94,%eax
  800b6a:	8a 00                	mov    (%eax),%al
  800b6c:	0f be c0             	movsbl %al,%eax
  800b6f:	83 ec 08             	sub    $0x8,%esp
  800b72:	ff 75 0c             	pushl  0xc(%ebp)
  800b75:	50                   	push   %eax
  800b76:	8b 45 08             	mov    0x8(%ebp),%eax
  800b79:	ff d0                	call   *%eax
  800b7b:	83 c4 10             	add    $0x10,%esp
}
  800b7e:	90                   	nop
  800b7f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800b82:	c9                   	leave  
  800b83:	c3                   	ret    

00800b84 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  800b84:	55                   	push   %ebp
  800b85:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800b87:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800b8b:	7e 1c                	jle    800ba9 <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  800b8d:	8b 45 08             	mov    0x8(%ebp),%eax
  800b90:	8b 00                	mov    (%eax),%eax
  800b92:	8d 50 08             	lea    0x8(%eax),%edx
  800b95:	8b 45 08             	mov    0x8(%ebp),%eax
  800b98:	89 10                	mov    %edx,(%eax)
  800b9a:	8b 45 08             	mov    0x8(%ebp),%eax
  800b9d:	8b 00                	mov    (%eax),%eax
  800b9f:	83 e8 08             	sub    $0x8,%eax
  800ba2:	8b 50 04             	mov    0x4(%eax),%edx
  800ba5:	8b 00                	mov    (%eax),%eax
  800ba7:	eb 40                	jmp    800be9 <getuint+0x65>
	else if (lflag)
  800ba9:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800bad:	74 1e                	je     800bcd <getuint+0x49>
		return va_arg(*ap, unsigned long);
  800baf:	8b 45 08             	mov    0x8(%ebp),%eax
  800bb2:	8b 00                	mov    (%eax),%eax
  800bb4:	8d 50 04             	lea    0x4(%eax),%edx
  800bb7:	8b 45 08             	mov    0x8(%ebp),%eax
  800bba:	89 10                	mov    %edx,(%eax)
  800bbc:	8b 45 08             	mov    0x8(%ebp),%eax
  800bbf:	8b 00                	mov    (%eax),%eax
  800bc1:	83 e8 04             	sub    $0x4,%eax
  800bc4:	8b 00                	mov    (%eax),%eax
  800bc6:	ba 00 00 00 00       	mov    $0x0,%edx
  800bcb:	eb 1c                	jmp    800be9 <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  800bcd:	8b 45 08             	mov    0x8(%ebp),%eax
  800bd0:	8b 00                	mov    (%eax),%eax
  800bd2:	8d 50 04             	lea    0x4(%eax),%edx
  800bd5:	8b 45 08             	mov    0x8(%ebp),%eax
  800bd8:	89 10                	mov    %edx,(%eax)
  800bda:	8b 45 08             	mov    0x8(%ebp),%eax
  800bdd:	8b 00                	mov    (%eax),%eax
  800bdf:	83 e8 04             	sub    $0x4,%eax
  800be2:	8b 00                	mov    (%eax),%eax
  800be4:	ba 00 00 00 00       	mov    $0x0,%edx
}
  800be9:	5d                   	pop    %ebp
  800bea:	c3                   	ret    

00800beb <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  800beb:	55                   	push   %ebp
  800bec:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800bee:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800bf2:	7e 1c                	jle    800c10 <getint+0x25>
		return va_arg(*ap, long long);
  800bf4:	8b 45 08             	mov    0x8(%ebp),%eax
  800bf7:	8b 00                	mov    (%eax),%eax
  800bf9:	8d 50 08             	lea    0x8(%eax),%edx
  800bfc:	8b 45 08             	mov    0x8(%ebp),%eax
  800bff:	89 10                	mov    %edx,(%eax)
  800c01:	8b 45 08             	mov    0x8(%ebp),%eax
  800c04:	8b 00                	mov    (%eax),%eax
  800c06:	83 e8 08             	sub    $0x8,%eax
  800c09:	8b 50 04             	mov    0x4(%eax),%edx
  800c0c:	8b 00                	mov    (%eax),%eax
  800c0e:	eb 38                	jmp    800c48 <getint+0x5d>
	else if (lflag)
  800c10:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800c14:	74 1a                	je     800c30 <getint+0x45>
		return va_arg(*ap, long);
  800c16:	8b 45 08             	mov    0x8(%ebp),%eax
  800c19:	8b 00                	mov    (%eax),%eax
  800c1b:	8d 50 04             	lea    0x4(%eax),%edx
  800c1e:	8b 45 08             	mov    0x8(%ebp),%eax
  800c21:	89 10                	mov    %edx,(%eax)
  800c23:	8b 45 08             	mov    0x8(%ebp),%eax
  800c26:	8b 00                	mov    (%eax),%eax
  800c28:	83 e8 04             	sub    $0x4,%eax
  800c2b:	8b 00                	mov    (%eax),%eax
  800c2d:	99                   	cltd   
  800c2e:	eb 18                	jmp    800c48 <getint+0x5d>
	else
		return va_arg(*ap, int);
  800c30:	8b 45 08             	mov    0x8(%ebp),%eax
  800c33:	8b 00                	mov    (%eax),%eax
  800c35:	8d 50 04             	lea    0x4(%eax),%edx
  800c38:	8b 45 08             	mov    0x8(%ebp),%eax
  800c3b:	89 10                	mov    %edx,(%eax)
  800c3d:	8b 45 08             	mov    0x8(%ebp),%eax
  800c40:	8b 00                	mov    (%eax),%eax
  800c42:	83 e8 04             	sub    $0x4,%eax
  800c45:	8b 00                	mov    (%eax),%eax
  800c47:	99                   	cltd   
}
  800c48:	5d                   	pop    %ebp
  800c49:	c3                   	ret    

00800c4a <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  800c4a:	55                   	push   %ebp
  800c4b:	89 e5                	mov    %esp,%ebp
  800c4d:	56                   	push   %esi
  800c4e:	53                   	push   %ebx
  800c4f:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800c52:	eb 17                	jmp    800c6b <vprintfmt+0x21>
			if (ch == '\0')
  800c54:	85 db                	test   %ebx,%ebx
  800c56:	0f 84 af 03 00 00    	je     80100b <vprintfmt+0x3c1>
				return;
			putch(ch, putdat);
  800c5c:	83 ec 08             	sub    $0x8,%esp
  800c5f:	ff 75 0c             	pushl  0xc(%ebp)
  800c62:	53                   	push   %ebx
  800c63:	8b 45 08             	mov    0x8(%ebp),%eax
  800c66:	ff d0                	call   *%eax
  800c68:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800c6b:	8b 45 10             	mov    0x10(%ebp),%eax
  800c6e:	8d 50 01             	lea    0x1(%eax),%edx
  800c71:	89 55 10             	mov    %edx,0x10(%ebp)
  800c74:	8a 00                	mov    (%eax),%al
  800c76:	0f b6 d8             	movzbl %al,%ebx
  800c79:	83 fb 25             	cmp    $0x25,%ebx
  800c7c:	75 d6                	jne    800c54 <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  800c7e:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  800c82:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  800c89:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  800c90:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  800c97:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800c9e:	8b 45 10             	mov    0x10(%ebp),%eax
  800ca1:	8d 50 01             	lea    0x1(%eax),%edx
  800ca4:	89 55 10             	mov    %edx,0x10(%ebp)
  800ca7:	8a 00                	mov    (%eax),%al
  800ca9:	0f b6 d8             	movzbl %al,%ebx
  800cac:	8d 43 dd             	lea    -0x23(%ebx),%eax
  800caf:	83 f8 55             	cmp    $0x55,%eax
  800cb2:	0f 87 2b 03 00 00    	ja     800fe3 <vprintfmt+0x399>
  800cb8:	8b 04 85 b8 3b 80 00 	mov    0x803bb8(,%eax,4),%eax
  800cbf:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  800cc1:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  800cc5:	eb d7                	jmp    800c9e <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800cc7:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  800ccb:	eb d1                	jmp    800c9e <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800ccd:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  800cd4:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800cd7:	89 d0                	mov    %edx,%eax
  800cd9:	c1 e0 02             	shl    $0x2,%eax
  800cdc:	01 d0                	add    %edx,%eax
  800cde:	01 c0                	add    %eax,%eax
  800ce0:	01 d8                	add    %ebx,%eax
  800ce2:	83 e8 30             	sub    $0x30,%eax
  800ce5:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  800ce8:	8b 45 10             	mov    0x10(%ebp),%eax
  800ceb:	8a 00                	mov    (%eax),%al
  800ced:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  800cf0:	83 fb 2f             	cmp    $0x2f,%ebx
  800cf3:	7e 3e                	jle    800d33 <vprintfmt+0xe9>
  800cf5:	83 fb 39             	cmp    $0x39,%ebx
  800cf8:	7f 39                	jg     800d33 <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800cfa:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800cfd:	eb d5                	jmp    800cd4 <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  800cff:	8b 45 14             	mov    0x14(%ebp),%eax
  800d02:	83 c0 04             	add    $0x4,%eax
  800d05:	89 45 14             	mov    %eax,0x14(%ebp)
  800d08:	8b 45 14             	mov    0x14(%ebp),%eax
  800d0b:	83 e8 04             	sub    $0x4,%eax
  800d0e:	8b 00                	mov    (%eax),%eax
  800d10:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  800d13:	eb 1f                	jmp    800d34 <vprintfmt+0xea>

		case '.':
			if (width < 0)
  800d15:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800d19:	79 83                	jns    800c9e <vprintfmt+0x54>
				width = 0;
  800d1b:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  800d22:	e9 77 ff ff ff       	jmp    800c9e <vprintfmt+0x54>

		case '#':
			altflag = 1;
  800d27:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  800d2e:	e9 6b ff ff ff       	jmp    800c9e <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  800d33:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  800d34:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800d38:	0f 89 60 ff ff ff    	jns    800c9e <vprintfmt+0x54>
				width = precision, precision = -1;
  800d3e:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800d41:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800d44:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  800d4b:	e9 4e ff ff ff       	jmp    800c9e <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  800d50:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  800d53:	e9 46 ff ff ff       	jmp    800c9e <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  800d58:	8b 45 14             	mov    0x14(%ebp),%eax
  800d5b:	83 c0 04             	add    $0x4,%eax
  800d5e:	89 45 14             	mov    %eax,0x14(%ebp)
  800d61:	8b 45 14             	mov    0x14(%ebp),%eax
  800d64:	83 e8 04             	sub    $0x4,%eax
  800d67:	8b 00                	mov    (%eax),%eax
  800d69:	83 ec 08             	sub    $0x8,%esp
  800d6c:	ff 75 0c             	pushl  0xc(%ebp)
  800d6f:	50                   	push   %eax
  800d70:	8b 45 08             	mov    0x8(%ebp),%eax
  800d73:	ff d0                	call   *%eax
  800d75:	83 c4 10             	add    $0x10,%esp
			break;
  800d78:	e9 89 02 00 00       	jmp    801006 <vprintfmt+0x3bc>

		// error message
		case 'e':
			err = va_arg(ap, int);
  800d7d:	8b 45 14             	mov    0x14(%ebp),%eax
  800d80:	83 c0 04             	add    $0x4,%eax
  800d83:	89 45 14             	mov    %eax,0x14(%ebp)
  800d86:	8b 45 14             	mov    0x14(%ebp),%eax
  800d89:	83 e8 04             	sub    $0x4,%eax
  800d8c:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  800d8e:	85 db                	test   %ebx,%ebx
  800d90:	79 02                	jns    800d94 <vprintfmt+0x14a>
				err = -err;
  800d92:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  800d94:	83 fb 64             	cmp    $0x64,%ebx
  800d97:	7f 0b                	jg     800da4 <vprintfmt+0x15a>
  800d99:	8b 34 9d 00 3a 80 00 	mov    0x803a00(,%ebx,4),%esi
  800da0:	85 f6                	test   %esi,%esi
  800da2:	75 19                	jne    800dbd <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  800da4:	53                   	push   %ebx
  800da5:	68 a5 3b 80 00       	push   $0x803ba5
  800daa:	ff 75 0c             	pushl  0xc(%ebp)
  800dad:	ff 75 08             	pushl  0x8(%ebp)
  800db0:	e8 5e 02 00 00       	call   801013 <printfmt>
  800db5:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800db8:	e9 49 02 00 00       	jmp    801006 <vprintfmt+0x3bc>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800dbd:	56                   	push   %esi
  800dbe:	68 ae 3b 80 00       	push   $0x803bae
  800dc3:	ff 75 0c             	pushl  0xc(%ebp)
  800dc6:	ff 75 08             	pushl  0x8(%ebp)
  800dc9:	e8 45 02 00 00       	call   801013 <printfmt>
  800dce:	83 c4 10             	add    $0x10,%esp
			break;
  800dd1:	e9 30 02 00 00       	jmp    801006 <vprintfmt+0x3bc>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  800dd6:	8b 45 14             	mov    0x14(%ebp),%eax
  800dd9:	83 c0 04             	add    $0x4,%eax
  800ddc:	89 45 14             	mov    %eax,0x14(%ebp)
  800ddf:	8b 45 14             	mov    0x14(%ebp),%eax
  800de2:	83 e8 04             	sub    $0x4,%eax
  800de5:	8b 30                	mov    (%eax),%esi
  800de7:	85 f6                	test   %esi,%esi
  800de9:	75 05                	jne    800df0 <vprintfmt+0x1a6>
				p = "(null)";
  800deb:	be b1 3b 80 00       	mov    $0x803bb1,%esi
			if (width > 0 && padc != '-')
  800df0:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800df4:	7e 6d                	jle    800e63 <vprintfmt+0x219>
  800df6:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  800dfa:	74 67                	je     800e63 <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  800dfc:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800dff:	83 ec 08             	sub    $0x8,%esp
  800e02:	50                   	push   %eax
  800e03:	56                   	push   %esi
  800e04:	e8 0c 03 00 00       	call   801115 <strnlen>
  800e09:	83 c4 10             	add    $0x10,%esp
  800e0c:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  800e0f:	eb 16                	jmp    800e27 <vprintfmt+0x1dd>
					putch(padc, putdat);
  800e11:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  800e15:	83 ec 08             	sub    $0x8,%esp
  800e18:	ff 75 0c             	pushl  0xc(%ebp)
  800e1b:	50                   	push   %eax
  800e1c:	8b 45 08             	mov    0x8(%ebp),%eax
  800e1f:	ff d0                	call   *%eax
  800e21:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800e24:	ff 4d e4             	decl   -0x1c(%ebp)
  800e27:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800e2b:	7f e4                	jg     800e11 <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800e2d:	eb 34                	jmp    800e63 <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  800e2f:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800e33:	74 1c                	je     800e51 <vprintfmt+0x207>
  800e35:	83 fb 1f             	cmp    $0x1f,%ebx
  800e38:	7e 05                	jle    800e3f <vprintfmt+0x1f5>
  800e3a:	83 fb 7e             	cmp    $0x7e,%ebx
  800e3d:	7e 12                	jle    800e51 <vprintfmt+0x207>
					putch('?', putdat);
  800e3f:	83 ec 08             	sub    $0x8,%esp
  800e42:	ff 75 0c             	pushl  0xc(%ebp)
  800e45:	6a 3f                	push   $0x3f
  800e47:	8b 45 08             	mov    0x8(%ebp),%eax
  800e4a:	ff d0                	call   *%eax
  800e4c:	83 c4 10             	add    $0x10,%esp
  800e4f:	eb 0f                	jmp    800e60 <vprintfmt+0x216>
				else
					putch(ch, putdat);
  800e51:	83 ec 08             	sub    $0x8,%esp
  800e54:	ff 75 0c             	pushl  0xc(%ebp)
  800e57:	53                   	push   %ebx
  800e58:	8b 45 08             	mov    0x8(%ebp),%eax
  800e5b:	ff d0                	call   *%eax
  800e5d:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800e60:	ff 4d e4             	decl   -0x1c(%ebp)
  800e63:	89 f0                	mov    %esi,%eax
  800e65:	8d 70 01             	lea    0x1(%eax),%esi
  800e68:	8a 00                	mov    (%eax),%al
  800e6a:	0f be d8             	movsbl %al,%ebx
  800e6d:	85 db                	test   %ebx,%ebx
  800e6f:	74 24                	je     800e95 <vprintfmt+0x24b>
  800e71:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800e75:	78 b8                	js     800e2f <vprintfmt+0x1e5>
  800e77:	ff 4d e0             	decl   -0x20(%ebp)
  800e7a:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800e7e:	79 af                	jns    800e2f <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800e80:	eb 13                	jmp    800e95 <vprintfmt+0x24b>
				putch(' ', putdat);
  800e82:	83 ec 08             	sub    $0x8,%esp
  800e85:	ff 75 0c             	pushl  0xc(%ebp)
  800e88:	6a 20                	push   $0x20
  800e8a:	8b 45 08             	mov    0x8(%ebp),%eax
  800e8d:	ff d0                	call   *%eax
  800e8f:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800e92:	ff 4d e4             	decl   -0x1c(%ebp)
  800e95:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800e99:	7f e7                	jg     800e82 <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  800e9b:	e9 66 01 00 00       	jmp    801006 <vprintfmt+0x3bc>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  800ea0:	83 ec 08             	sub    $0x8,%esp
  800ea3:	ff 75 e8             	pushl  -0x18(%ebp)
  800ea6:	8d 45 14             	lea    0x14(%ebp),%eax
  800ea9:	50                   	push   %eax
  800eaa:	e8 3c fd ff ff       	call   800beb <getint>
  800eaf:	83 c4 10             	add    $0x10,%esp
  800eb2:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800eb5:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  800eb8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800ebb:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800ebe:	85 d2                	test   %edx,%edx
  800ec0:	79 23                	jns    800ee5 <vprintfmt+0x29b>
				putch('-', putdat);
  800ec2:	83 ec 08             	sub    $0x8,%esp
  800ec5:	ff 75 0c             	pushl  0xc(%ebp)
  800ec8:	6a 2d                	push   $0x2d
  800eca:	8b 45 08             	mov    0x8(%ebp),%eax
  800ecd:	ff d0                	call   *%eax
  800ecf:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  800ed2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800ed5:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800ed8:	f7 d8                	neg    %eax
  800eda:	83 d2 00             	adc    $0x0,%edx
  800edd:	f7 da                	neg    %edx
  800edf:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800ee2:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  800ee5:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800eec:	e9 bc 00 00 00       	jmp    800fad <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  800ef1:	83 ec 08             	sub    $0x8,%esp
  800ef4:	ff 75 e8             	pushl  -0x18(%ebp)
  800ef7:	8d 45 14             	lea    0x14(%ebp),%eax
  800efa:	50                   	push   %eax
  800efb:	e8 84 fc ff ff       	call   800b84 <getuint>
  800f00:	83 c4 10             	add    $0x10,%esp
  800f03:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800f06:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  800f09:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800f10:	e9 98 00 00 00       	jmp    800fad <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  800f15:	83 ec 08             	sub    $0x8,%esp
  800f18:	ff 75 0c             	pushl  0xc(%ebp)
  800f1b:	6a 58                	push   $0x58
  800f1d:	8b 45 08             	mov    0x8(%ebp),%eax
  800f20:	ff d0                	call   *%eax
  800f22:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800f25:	83 ec 08             	sub    $0x8,%esp
  800f28:	ff 75 0c             	pushl  0xc(%ebp)
  800f2b:	6a 58                	push   $0x58
  800f2d:	8b 45 08             	mov    0x8(%ebp),%eax
  800f30:	ff d0                	call   *%eax
  800f32:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800f35:	83 ec 08             	sub    $0x8,%esp
  800f38:	ff 75 0c             	pushl  0xc(%ebp)
  800f3b:	6a 58                	push   $0x58
  800f3d:	8b 45 08             	mov    0x8(%ebp),%eax
  800f40:	ff d0                	call   *%eax
  800f42:	83 c4 10             	add    $0x10,%esp
			break;
  800f45:	e9 bc 00 00 00       	jmp    801006 <vprintfmt+0x3bc>

		// pointer
		case 'p':
			putch('0', putdat);
  800f4a:	83 ec 08             	sub    $0x8,%esp
  800f4d:	ff 75 0c             	pushl  0xc(%ebp)
  800f50:	6a 30                	push   $0x30
  800f52:	8b 45 08             	mov    0x8(%ebp),%eax
  800f55:	ff d0                	call   *%eax
  800f57:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  800f5a:	83 ec 08             	sub    $0x8,%esp
  800f5d:	ff 75 0c             	pushl  0xc(%ebp)
  800f60:	6a 78                	push   $0x78
  800f62:	8b 45 08             	mov    0x8(%ebp),%eax
  800f65:	ff d0                	call   *%eax
  800f67:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  800f6a:	8b 45 14             	mov    0x14(%ebp),%eax
  800f6d:	83 c0 04             	add    $0x4,%eax
  800f70:	89 45 14             	mov    %eax,0x14(%ebp)
  800f73:	8b 45 14             	mov    0x14(%ebp),%eax
  800f76:	83 e8 04             	sub    $0x4,%eax
  800f79:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800f7b:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800f7e:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  800f85:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  800f8c:	eb 1f                	jmp    800fad <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800f8e:	83 ec 08             	sub    $0x8,%esp
  800f91:	ff 75 e8             	pushl  -0x18(%ebp)
  800f94:	8d 45 14             	lea    0x14(%ebp),%eax
  800f97:	50                   	push   %eax
  800f98:	e8 e7 fb ff ff       	call   800b84 <getuint>
  800f9d:	83 c4 10             	add    $0x10,%esp
  800fa0:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800fa3:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  800fa6:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800fad:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  800fb1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800fb4:	83 ec 04             	sub    $0x4,%esp
  800fb7:	52                   	push   %edx
  800fb8:	ff 75 e4             	pushl  -0x1c(%ebp)
  800fbb:	50                   	push   %eax
  800fbc:	ff 75 f4             	pushl  -0xc(%ebp)
  800fbf:	ff 75 f0             	pushl  -0x10(%ebp)
  800fc2:	ff 75 0c             	pushl  0xc(%ebp)
  800fc5:	ff 75 08             	pushl  0x8(%ebp)
  800fc8:	e8 00 fb ff ff       	call   800acd <printnum>
  800fcd:	83 c4 20             	add    $0x20,%esp
			break;
  800fd0:	eb 34                	jmp    801006 <vprintfmt+0x3bc>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  800fd2:	83 ec 08             	sub    $0x8,%esp
  800fd5:	ff 75 0c             	pushl  0xc(%ebp)
  800fd8:	53                   	push   %ebx
  800fd9:	8b 45 08             	mov    0x8(%ebp),%eax
  800fdc:	ff d0                	call   *%eax
  800fde:	83 c4 10             	add    $0x10,%esp
			break;
  800fe1:	eb 23                	jmp    801006 <vprintfmt+0x3bc>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800fe3:	83 ec 08             	sub    $0x8,%esp
  800fe6:	ff 75 0c             	pushl  0xc(%ebp)
  800fe9:	6a 25                	push   $0x25
  800feb:	8b 45 08             	mov    0x8(%ebp),%eax
  800fee:	ff d0                	call   *%eax
  800ff0:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  800ff3:	ff 4d 10             	decl   0x10(%ebp)
  800ff6:	eb 03                	jmp    800ffb <vprintfmt+0x3b1>
  800ff8:	ff 4d 10             	decl   0x10(%ebp)
  800ffb:	8b 45 10             	mov    0x10(%ebp),%eax
  800ffe:	48                   	dec    %eax
  800fff:	8a 00                	mov    (%eax),%al
  801001:	3c 25                	cmp    $0x25,%al
  801003:	75 f3                	jne    800ff8 <vprintfmt+0x3ae>
				/* do nothing */;
			break;
  801005:	90                   	nop
		}
	}
  801006:	e9 47 fc ff ff       	jmp    800c52 <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  80100b:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  80100c:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80100f:	5b                   	pop    %ebx
  801010:	5e                   	pop    %esi
  801011:	5d                   	pop    %ebp
  801012:	c3                   	ret    

00801013 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  801013:	55                   	push   %ebp
  801014:	89 e5                	mov    %esp,%ebp
  801016:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  801019:	8d 45 10             	lea    0x10(%ebp),%eax
  80101c:	83 c0 04             	add    $0x4,%eax
  80101f:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  801022:	8b 45 10             	mov    0x10(%ebp),%eax
  801025:	ff 75 f4             	pushl  -0xc(%ebp)
  801028:	50                   	push   %eax
  801029:	ff 75 0c             	pushl  0xc(%ebp)
  80102c:	ff 75 08             	pushl  0x8(%ebp)
  80102f:	e8 16 fc ff ff       	call   800c4a <vprintfmt>
  801034:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  801037:	90                   	nop
  801038:	c9                   	leave  
  801039:	c3                   	ret    

0080103a <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  80103a:	55                   	push   %ebp
  80103b:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  80103d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801040:	8b 40 08             	mov    0x8(%eax),%eax
  801043:	8d 50 01             	lea    0x1(%eax),%edx
  801046:	8b 45 0c             	mov    0xc(%ebp),%eax
  801049:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  80104c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80104f:	8b 10                	mov    (%eax),%edx
  801051:	8b 45 0c             	mov    0xc(%ebp),%eax
  801054:	8b 40 04             	mov    0x4(%eax),%eax
  801057:	39 c2                	cmp    %eax,%edx
  801059:	73 12                	jae    80106d <sprintputch+0x33>
		*b->buf++ = ch;
  80105b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80105e:	8b 00                	mov    (%eax),%eax
  801060:	8d 48 01             	lea    0x1(%eax),%ecx
  801063:	8b 55 0c             	mov    0xc(%ebp),%edx
  801066:	89 0a                	mov    %ecx,(%edx)
  801068:	8b 55 08             	mov    0x8(%ebp),%edx
  80106b:	88 10                	mov    %dl,(%eax)
}
  80106d:	90                   	nop
  80106e:	5d                   	pop    %ebp
  80106f:	c3                   	ret    

00801070 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  801070:	55                   	push   %ebp
  801071:	89 e5                	mov    %esp,%ebp
  801073:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  801076:	8b 45 08             	mov    0x8(%ebp),%eax
  801079:	89 45 ec             	mov    %eax,-0x14(%ebp)
  80107c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80107f:	8d 50 ff             	lea    -0x1(%eax),%edx
  801082:	8b 45 08             	mov    0x8(%ebp),%eax
  801085:	01 d0                	add    %edx,%eax
  801087:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80108a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  801091:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801095:	74 06                	je     80109d <vsnprintf+0x2d>
  801097:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80109b:	7f 07                	jg     8010a4 <vsnprintf+0x34>
		return -E_INVAL;
  80109d:	b8 03 00 00 00       	mov    $0x3,%eax
  8010a2:	eb 20                	jmp    8010c4 <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  8010a4:	ff 75 14             	pushl  0x14(%ebp)
  8010a7:	ff 75 10             	pushl  0x10(%ebp)
  8010aa:	8d 45 ec             	lea    -0x14(%ebp),%eax
  8010ad:	50                   	push   %eax
  8010ae:	68 3a 10 80 00       	push   $0x80103a
  8010b3:	e8 92 fb ff ff       	call   800c4a <vprintfmt>
  8010b8:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  8010bb:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8010be:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  8010c1:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  8010c4:	c9                   	leave  
  8010c5:	c3                   	ret    

008010c6 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  8010c6:	55                   	push   %ebp
  8010c7:	89 e5                	mov    %esp,%ebp
  8010c9:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  8010cc:	8d 45 10             	lea    0x10(%ebp),%eax
  8010cf:	83 c0 04             	add    $0x4,%eax
  8010d2:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  8010d5:	8b 45 10             	mov    0x10(%ebp),%eax
  8010d8:	ff 75 f4             	pushl  -0xc(%ebp)
  8010db:	50                   	push   %eax
  8010dc:	ff 75 0c             	pushl  0xc(%ebp)
  8010df:	ff 75 08             	pushl  0x8(%ebp)
  8010e2:	e8 89 ff ff ff       	call   801070 <vsnprintf>
  8010e7:	83 c4 10             	add    $0x10,%esp
  8010ea:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  8010ed:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8010f0:	c9                   	leave  
  8010f1:	c3                   	ret    

008010f2 <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  8010f2:	55                   	push   %ebp
  8010f3:	89 e5                	mov    %esp,%ebp
  8010f5:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  8010f8:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8010ff:	eb 06                	jmp    801107 <strlen+0x15>
		n++;
  801101:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  801104:	ff 45 08             	incl   0x8(%ebp)
  801107:	8b 45 08             	mov    0x8(%ebp),%eax
  80110a:	8a 00                	mov    (%eax),%al
  80110c:	84 c0                	test   %al,%al
  80110e:	75 f1                	jne    801101 <strlen+0xf>
		n++;
	return n;
  801110:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  801113:	c9                   	leave  
  801114:	c3                   	ret    

00801115 <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  801115:	55                   	push   %ebp
  801116:	89 e5                	mov    %esp,%ebp
  801118:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  80111b:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801122:	eb 09                	jmp    80112d <strnlen+0x18>
		n++;
  801124:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  801127:	ff 45 08             	incl   0x8(%ebp)
  80112a:	ff 4d 0c             	decl   0xc(%ebp)
  80112d:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801131:	74 09                	je     80113c <strnlen+0x27>
  801133:	8b 45 08             	mov    0x8(%ebp),%eax
  801136:	8a 00                	mov    (%eax),%al
  801138:	84 c0                	test   %al,%al
  80113a:	75 e8                	jne    801124 <strnlen+0xf>
		n++;
	return n;
  80113c:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  80113f:	c9                   	leave  
  801140:	c3                   	ret    

00801141 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  801141:	55                   	push   %ebp
  801142:	89 e5                	mov    %esp,%ebp
  801144:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  801147:	8b 45 08             	mov    0x8(%ebp),%eax
  80114a:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  80114d:	90                   	nop
  80114e:	8b 45 08             	mov    0x8(%ebp),%eax
  801151:	8d 50 01             	lea    0x1(%eax),%edx
  801154:	89 55 08             	mov    %edx,0x8(%ebp)
  801157:	8b 55 0c             	mov    0xc(%ebp),%edx
  80115a:	8d 4a 01             	lea    0x1(%edx),%ecx
  80115d:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  801160:	8a 12                	mov    (%edx),%dl
  801162:	88 10                	mov    %dl,(%eax)
  801164:	8a 00                	mov    (%eax),%al
  801166:	84 c0                	test   %al,%al
  801168:	75 e4                	jne    80114e <strcpy+0xd>
		/* do nothing */;
	return ret;
  80116a:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  80116d:	c9                   	leave  
  80116e:	c3                   	ret    

0080116f <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  80116f:	55                   	push   %ebp
  801170:	89 e5                	mov    %esp,%ebp
  801172:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  801175:	8b 45 08             	mov    0x8(%ebp),%eax
  801178:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  80117b:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801182:	eb 1f                	jmp    8011a3 <strncpy+0x34>
		*dst++ = *src;
  801184:	8b 45 08             	mov    0x8(%ebp),%eax
  801187:	8d 50 01             	lea    0x1(%eax),%edx
  80118a:	89 55 08             	mov    %edx,0x8(%ebp)
  80118d:	8b 55 0c             	mov    0xc(%ebp),%edx
  801190:	8a 12                	mov    (%edx),%dl
  801192:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  801194:	8b 45 0c             	mov    0xc(%ebp),%eax
  801197:	8a 00                	mov    (%eax),%al
  801199:	84 c0                	test   %al,%al
  80119b:	74 03                	je     8011a0 <strncpy+0x31>
			src++;
  80119d:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  8011a0:	ff 45 fc             	incl   -0x4(%ebp)
  8011a3:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8011a6:	3b 45 10             	cmp    0x10(%ebp),%eax
  8011a9:	72 d9                	jb     801184 <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  8011ab:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  8011ae:	c9                   	leave  
  8011af:	c3                   	ret    

008011b0 <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  8011b0:	55                   	push   %ebp
  8011b1:	89 e5                	mov    %esp,%ebp
  8011b3:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  8011b6:	8b 45 08             	mov    0x8(%ebp),%eax
  8011b9:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  8011bc:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8011c0:	74 30                	je     8011f2 <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  8011c2:	eb 16                	jmp    8011da <strlcpy+0x2a>
			*dst++ = *src++;
  8011c4:	8b 45 08             	mov    0x8(%ebp),%eax
  8011c7:	8d 50 01             	lea    0x1(%eax),%edx
  8011ca:	89 55 08             	mov    %edx,0x8(%ebp)
  8011cd:	8b 55 0c             	mov    0xc(%ebp),%edx
  8011d0:	8d 4a 01             	lea    0x1(%edx),%ecx
  8011d3:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  8011d6:	8a 12                	mov    (%edx),%dl
  8011d8:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  8011da:	ff 4d 10             	decl   0x10(%ebp)
  8011dd:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8011e1:	74 09                	je     8011ec <strlcpy+0x3c>
  8011e3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011e6:	8a 00                	mov    (%eax),%al
  8011e8:	84 c0                	test   %al,%al
  8011ea:	75 d8                	jne    8011c4 <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  8011ec:	8b 45 08             	mov    0x8(%ebp),%eax
  8011ef:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  8011f2:	8b 55 08             	mov    0x8(%ebp),%edx
  8011f5:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8011f8:	29 c2                	sub    %eax,%edx
  8011fa:	89 d0                	mov    %edx,%eax
}
  8011fc:	c9                   	leave  
  8011fd:	c3                   	ret    

008011fe <strcmp>:

int
strcmp(const char *p, const char *q)
{
  8011fe:	55                   	push   %ebp
  8011ff:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  801201:	eb 06                	jmp    801209 <strcmp+0xb>
		p++, q++;
  801203:	ff 45 08             	incl   0x8(%ebp)
  801206:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  801209:	8b 45 08             	mov    0x8(%ebp),%eax
  80120c:	8a 00                	mov    (%eax),%al
  80120e:	84 c0                	test   %al,%al
  801210:	74 0e                	je     801220 <strcmp+0x22>
  801212:	8b 45 08             	mov    0x8(%ebp),%eax
  801215:	8a 10                	mov    (%eax),%dl
  801217:	8b 45 0c             	mov    0xc(%ebp),%eax
  80121a:	8a 00                	mov    (%eax),%al
  80121c:	38 c2                	cmp    %al,%dl
  80121e:	74 e3                	je     801203 <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  801220:	8b 45 08             	mov    0x8(%ebp),%eax
  801223:	8a 00                	mov    (%eax),%al
  801225:	0f b6 d0             	movzbl %al,%edx
  801228:	8b 45 0c             	mov    0xc(%ebp),%eax
  80122b:	8a 00                	mov    (%eax),%al
  80122d:	0f b6 c0             	movzbl %al,%eax
  801230:	29 c2                	sub    %eax,%edx
  801232:	89 d0                	mov    %edx,%eax
}
  801234:	5d                   	pop    %ebp
  801235:	c3                   	ret    

00801236 <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  801236:	55                   	push   %ebp
  801237:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  801239:	eb 09                	jmp    801244 <strncmp+0xe>
		n--, p++, q++;
  80123b:	ff 4d 10             	decl   0x10(%ebp)
  80123e:	ff 45 08             	incl   0x8(%ebp)
  801241:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  801244:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801248:	74 17                	je     801261 <strncmp+0x2b>
  80124a:	8b 45 08             	mov    0x8(%ebp),%eax
  80124d:	8a 00                	mov    (%eax),%al
  80124f:	84 c0                	test   %al,%al
  801251:	74 0e                	je     801261 <strncmp+0x2b>
  801253:	8b 45 08             	mov    0x8(%ebp),%eax
  801256:	8a 10                	mov    (%eax),%dl
  801258:	8b 45 0c             	mov    0xc(%ebp),%eax
  80125b:	8a 00                	mov    (%eax),%al
  80125d:	38 c2                	cmp    %al,%dl
  80125f:	74 da                	je     80123b <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  801261:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801265:	75 07                	jne    80126e <strncmp+0x38>
		return 0;
  801267:	b8 00 00 00 00       	mov    $0x0,%eax
  80126c:	eb 14                	jmp    801282 <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  80126e:	8b 45 08             	mov    0x8(%ebp),%eax
  801271:	8a 00                	mov    (%eax),%al
  801273:	0f b6 d0             	movzbl %al,%edx
  801276:	8b 45 0c             	mov    0xc(%ebp),%eax
  801279:	8a 00                	mov    (%eax),%al
  80127b:	0f b6 c0             	movzbl %al,%eax
  80127e:	29 c2                	sub    %eax,%edx
  801280:	89 d0                	mov    %edx,%eax
}
  801282:	5d                   	pop    %ebp
  801283:	c3                   	ret    

00801284 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  801284:	55                   	push   %ebp
  801285:	89 e5                	mov    %esp,%ebp
  801287:	83 ec 04             	sub    $0x4,%esp
  80128a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80128d:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  801290:	eb 12                	jmp    8012a4 <strchr+0x20>
		if (*s == c)
  801292:	8b 45 08             	mov    0x8(%ebp),%eax
  801295:	8a 00                	mov    (%eax),%al
  801297:	3a 45 fc             	cmp    -0x4(%ebp),%al
  80129a:	75 05                	jne    8012a1 <strchr+0x1d>
			return (char *) s;
  80129c:	8b 45 08             	mov    0x8(%ebp),%eax
  80129f:	eb 11                	jmp    8012b2 <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  8012a1:	ff 45 08             	incl   0x8(%ebp)
  8012a4:	8b 45 08             	mov    0x8(%ebp),%eax
  8012a7:	8a 00                	mov    (%eax),%al
  8012a9:	84 c0                	test   %al,%al
  8012ab:	75 e5                	jne    801292 <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  8012ad:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8012b2:	c9                   	leave  
  8012b3:	c3                   	ret    

008012b4 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  8012b4:	55                   	push   %ebp
  8012b5:	89 e5                	mov    %esp,%ebp
  8012b7:	83 ec 04             	sub    $0x4,%esp
  8012ba:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012bd:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  8012c0:	eb 0d                	jmp    8012cf <strfind+0x1b>
		if (*s == c)
  8012c2:	8b 45 08             	mov    0x8(%ebp),%eax
  8012c5:	8a 00                	mov    (%eax),%al
  8012c7:	3a 45 fc             	cmp    -0x4(%ebp),%al
  8012ca:	74 0e                	je     8012da <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  8012cc:	ff 45 08             	incl   0x8(%ebp)
  8012cf:	8b 45 08             	mov    0x8(%ebp),%eax
  8012d2:	8a 00                	mov    (%eax),%al
  8012d4:	84 c0                	test   %al,%al
  8012d6:	75 ea                	jne    8012c2 <strfind+0xe>
  8012d8:	eb 01                	jmp    8012db <strfind+0x27>
		if (*s == c)
			break;
  8012da:	90                   	nop
	return (char *) s;
  8012db:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8012de:	c9                   	leave  
  8012df:	c3                   	ret    

008012e0 <memset>:


void *
memset(void *v, int c, uint32 n)
{
  8012e0:	55                   	push   %ebp
  8012e1:	89 e5                	mov    %esp,%ebp
  8012e3:	83 ec 10             	sub    $0x10,%esp
	char *p;
	int m;

	p = v;
  8012e6:	8b 45 08             	mov    0x8(%ebp),%eax
  8012e9:	89 45 fc             	mov    %eax,-0x4(%ebp)
	m = n;
  8012ec:	8b 45 10             	mov    0x10(%ebp),%eax
  8012ef:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (--m >= 0)
  8012f2:	eb 0e                	jmp    801302 <memset+0x22>
		*p++ = c;
  8012f4:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8012f7:	8d 50 01             	lea    0x1(%eax),%edx
  8012fa:	89 55 fc             	mov    %edx,-0x4(%ebp)
  8012fd:	8b 55 0c             	mov    0xc(%ebp),%edx
  801300:	88 10                	mov    %dl,(%eax)
	char *p;
	int m;

	p = v;
	m = n;
	while (--m >= 0)
  801302:	ff 4d f8             	decl   -0x8(%ebp)
  801305:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  801309:	79 e9                	jns    8012f4 <memset+0x14>
		*p++ = c;

	return v;
  80130b:	8b 45 08             	mov    0x8(%ebp),%eax
}
  80130e:	c9                   	leave  
  80130f:	c3                   	ret    

00801310 <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  801310:	55                   	push   %ebp
  801311:	89 e5                	mov    %esp,%ebp
  801313:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  801316:	8b 45 0c             	mov    0xc(%ebp),%eax
  801319:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  80131c:	8b 45 08             	mov    0x8(%ebp),%eax
  80131f:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (n-- > 0)
  801322:	eb 16                	jmp    80133a <memcpy+0x2a>
		*d++ = *s++;
  801324:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801327:	8d 50 01             	lea    0x1(%eax),%edx
  80132a:	89 55 f8             	mov    %edx,-0x8(%ebp)
  80132d:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801330:	8d 4a 01             	lea    0x1(%edx),%ecx
  801333:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  801336:	8a 12                	mov    (%edx),%dl
  801338:	88 10                	mov    %dl,(%eax)
	const char *s;
	char *d;

	s = src;
	d = dst;
	while (n-- > 0)
  80133a:	8b 45 10             	mov    0x10(%ebp),%eax
  80133d:	8d 50 ff             	lea    -0x1(%eax),%edx
  801340:	89 55 10             	mov    %edx,0x10(%ebp)
  801343:	85 c0                	test   %eax,%eax
  801345:	75 dd                	jne    801324 <memcpy+0x14>
		*d++ = *s++;

	return dst;
  801347:	8b 45 08             	mov    0x8(%ebp),%eax
}
  80134a:	c9                   	leave  
  80134b:	c3                   	ret    

0080134c <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  80134c:	55                   	push   %ebp
  80134d:	89 e5                	mov    %esp,%ebp
  80134f:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  801352:	8b 45 0c             	mov    0xc(%ebp),%eax
  801355:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  801358:	8b 45 08             	mov    0x8(%ebp),%eax
  80135b:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  80135e:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801361:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  801364:	73 50                	jae    8013b6 <memmove+0x6a>
  801366:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801369:	8b 45 10             	mov    0x10(%ebp),%eax
  80136c:	01 d0                	add    %edx,%eax
  80136e:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  801371:	76 43                	jbe    8013b6 <memmove+0x6a>
		s += n;
  801373:	8b 45 10             	mov    0x10(%ebp),%eax
  801376:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  801379:	8b 45 10             	mov    0x10(%ebp),%eax
  80137c:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  80137f:	eb 10                	jmp    801391 <memmove+0x45>
			*--d = *--s;
  801381:	ff 4d f8             	decl   -0x8(%ebp)
  801384:	ff 4d fc             	decl   -0x4(%ebp)
  801387:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80138a:	8a 10                	mov    (%eax),%dl
  80138c:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80138f:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  801391:	8b 45 10             	mov    0x10(%ebp),%eax
  801394:	8d 50 ff             	lea    -0x1(%eax),%edx
  801397:	89 55 10             	mov    %edx,0x10(%ebp)
  80139a:	85 c0                	test   %eax,%eax
  80139c:	75 e3                	jne    801381 <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  80139e:	eb 23                	jmp    8013c3 <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  8013a0:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8013a3:	8d 50 01             	lea    0x1(%eax),%edx
  8013a6:	89 55 f8             	mov    %edx,-0x8(%ebp)
  8013a9:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8013ac:	8d 4a 01             	lea    0x1(%edx),%ecx
  8013af:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  8013b2:	8a 12                	mov    (%edx),%dl
  8013b4:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  8013b6:	8b 45 10             	mov    0x10(%ebp),%eax
  8013b9:	8d 50 ff             	lea    -0x1(%eax),%edx
  8013bc:	89 55 10             	mov    %edx,0x10(%ebp)
  8013bf:	85 c0                	test   %eax,%eax
  8013c1:	75 dd                	jne    8013a0 <memmove+0x54>
			*d++ = *s++;

	return dst;
  8013c3:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8013c6:	c9                   	leave  
  8013c7:	c3                   	ret    

008013c8 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  8013c8:	55                   	push   %ebp
  8013c9:	89 e5                	mov    %esp,%ebp
  8013cb:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  8013ce:	8b 45 08             	mov    0x8(%ebp),%eax
  8013d1:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  8013d4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8013d7:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  8013da:	eb 2a                	jmp    801406 <memcmp+0x3e>
		if (*s1 != *s2)
  8013dc:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8013df:	8a 10                	mov    (%eax),%dl
  8013e1:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8013e4:	8a 00                	mov    (%eax),%al
  8013e6:	38 c2                	cmp    %al,%dl
  8013e8:	74 16                	je     801400 <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  8013ea:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8013ed:	8a 00                	mov    (%eax),%al
  8013ef:	0f b6 d0             	movzbl %al,%edx
  8013f2:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8013f5:	8a 00                	mov    (%eax),%al
  8013f7:	0f b6 c0             	movzbl %al,%eax
  8013fa:	29 c2                	sub    %eax,%edx
  8013fc:	89 d0                	mov    %edx,%eax
  8013fe:	eb 18                	jmp    801418 <memcmp+0x50>
		s1++, s2++;
  801400:	ff 45 fc             	incl   -0x4(%ebp)
  801403:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  801406:	8b 45 10             	mov    0x10(%ebp),%eax
  801409:	8d 50 ff             	lea    -0x1(%eax),%edx
  80140c:	89 55 10             	mov    %edx,0x10(%ebp)
  80140f:	85 c0                	test   %eax,%eax
  801411:	75 c9                	jne    8013dc <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  801413:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801418:	c9                   	leave  
  801419:	c3                   	ret    

0080141a <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  80141a:	55                   	push   %ebp
  80141b:	89 e5                	mov    %esp,%ebp
  80141d:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  801420:	8b 55 08             	mov    0x8(%ebp),%edx
  801423:	8b 45 10             	mov    0x10(%ebp),%eax
  801426:	01 d0                	add    %edx,%eax
  801428:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  80142b:	eb 15                	jmp    801442 <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  80142d:	8b 45 08             	mov    0x8(%ebp),%eax
  801430:	8a 00                	mov    (%eax),%al
  801432:	0f b6 d0             	movzbl %al,%edx
  801435:	8b 45 0c             	mov    0xc(%ebp),%eax
  801438:	0f b6 c0             	movzbl %al,%eax
  80143b:	39 c2                	cmp    %eax,%edx
  80143d:	74 0d                	je     80144c <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  80143f:	ff 45 08             	incl   0x8(%ebp)
  801442:	8b 45 08             	mov    0x8(%ebp),%eax
  801445:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  801448:	72 e3                	jb     80142d <memfind+0x13>
  80144a:	eb 01                	jmp    80144d <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  80144c:	90                   	nop
	return (void *) s;
  80144d:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801450:	c9                   	leave  
  801451:	c3                   	ret    

00801452 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  801452:	55                   	push   %ebp
  801453:	89 e5                	mov    %esp,%ebp
  801455:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  801458:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  80145f:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801466:	eb 03                	jmp    80146b <strtol+0x19>
		s++;
  801468:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  80146b:	8b 45 08             	mov    0x8(%ebp),%eax
  80146e:	8a 00                	mov    (%eax),%al
  801470:	3c 20                	cmp    $0x20,%al
  801472:	74 f4                	je     801468 <strtol+0x16>
  801474:	8b 45 08             	mov    0x8(%ebp),%eax
  801477:	8a 00                	mov    (%eax),%al
  801479:	3c 09                	cmp    $0x9,%al
  80147b:	74 eb                	je     801468 <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  80147d:	8b 45 08             	mov    0x8(%ebp),%eax
  801480:	8a 00                	mov    (%eax),%al
  801482:	3c 2b                	cmp    $0x2b,%al
  801484:	75 05                	jne    80148b <strtol+0x39>
		s++;
  801486:	ff 45 08             	incl   0x8(%ebp)
  801489:	eb 13                	jmp    80149e <strtol+0x4c>
	else if (*s == '-')
  80148b:	8b 45 08             	mov    0x8(%ebp),%eax
  80148e:	8a 00                	mov    (%eax),%al
  801490:	3c 2d                	cmp    $0x2d,%al
  801492:	75 0a                	jne    80149e <strtol+0x4c>
		s++, neg = 1;
  801494:	ff 45 08             	incl   0x8(%ebp)
  801497:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  80149e:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8014a2:	74 06                	je     8014aa <strtol+0x58>
  8014a4:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  8014a8:	75 20                	jne    8014ca <strtol+0x78>
  8014aa:	8b 45 08             	mov    0x8(%ebp),%eax
  8014ad:	8a 00                	mov    (%eax),%al
  8014af:	3c 30                	cmp    $0x30,%al
  8014b1:	75 17                	jne    8014ca <strtol+0x78>
  8014b3:	8b 45 08             	mov    0x8(%ebp),%eax
  8014b6:	40                   	inc    %eax
  8014b7:	8a 00                	mov    (%eax),%al
  8014b9:	3c 78                	cmp    $0x78,%al
  8014bb:	75 0d                	jne    8014ca <strtol+0x78>
		s += 2, base = 16;
  8014bd:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  8014c1:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  8014c8:	eb 28                	jmp    8014f2 <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  8014ca:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8014ce:	75 15                	jne    8014e5 <strtol+0x93>
  8014d0:	8b 45 08             	mov    0x8(%ebp),%eax
  8014d3:	8a 00                	mov    (%eax),%al
  8014d5:	3c 30                	cmp    $0x30,%al
  8014d7:	75 0c                	jne    8014e5 <strtol+0x93>
		s++, base = 8;
  8014d9:	ff 45 08             	incl   0x8(%ebp)
  8014dc:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  8014e3:	eb 0d                	jmp    8014f2 <strtol+0xa0>
	else if (base == 0)
  8014e5:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8014e9:	75 07                	jne    8014f2 <strtol+0xa0>
		base = 10;
  8014eb:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  8014f2:	8b 45 08             	mov    0x8(%ebp),%eax
  8014f5:	8a 00                	mov    (%eax),%al
  8014f7:	3c 2f                	cmp    $0x2f,%al
  8014f9:	7e 19                	jle    801514 <strtol+0xc2>
  8014fb:	8b 45 08             	mov    0x8(%ebp),%eax
  8014fe:	8a 00                	mov    (%eax),%al
  801500:	3c 39                	cmp    $0x39,%al
  801502:	7f 10                	jg     801514 <strtol+0xc2>
			dig = *s - '0';
  801504:	8b 45 08             	mov    0x8(%ebp),%eax
  801507:	8a 00                	mov    (%eax),%al
  801509:	0f be c0             	movsbl %al,%eax
  80150c:	83 e8 30             	sub    $0x30,%eax
  80150f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801512:	eb 42                	jmp    801556 <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  801514:	8b 45 08             	mov    0x8(%ebp),%eax
  801517:	8a 00                	mov    (%eax),%al
  801519:	3c 60                	cmp    $0x60,%al
  80151b:	7e 19                	jle    801536 <strtol+0xe4>
  80151d:	8b 45 08             	mov    0x8(%ebp),%eax
  801520:	8a 00                	mov    (%eax),%al
  801522:	3c 7a                	cmp    $0x7a,%al
  801524:	7f 10                	jg     801536 <strtol+0xe4>
			dig = *s - 'a' + 10;
  801526:	8b 45 08             	mov    0x8(%ebp),%eax
  801529:	8a 00                	mov    (%eax),%al
  80152b:	0f be c0             	movsbl %al,%eax
  80152e:	83 e8 57             	sub    $0x57,%eax
  801531:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801534:	eb 20                	jmp    801556 <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  801536:	8b 45 08             	mov    0x8(%ebp),%eax
  801539:	8a 00                	mov    (%eax),%al
  80153b:	3c 40                	cmp    $0x40,%al
  80153d:	7e 39                	jle    801578 <strtol+0x126>
  80153f:	8b 45 08             	mov    0x8(%ebp),%eax
  801542:	8a 00                	mov    (%eax),%al
  801544:	3c 5a                	cmp    $0x5a,%al
  801546:	7f 30                	jg     801578 <strtol+0x126>
			dig = *s - 'A' + 10;
  801548:	8b 45 08             	mov    0x8(%ebp),%eax
  80154b:	8a 00                	mov    (%eax),%al
  80154d:	0f be c0             	movsbl %al,%eax
  801550:	83 e8 37             	sub    $0x37,%eax
  801553:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  801556:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801559:	3b 45 10             	cmp    0x10(%ebp),%eax
  80155c:	7d 19                	jge    801577 <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  80155e:	ff 45 08             	incl   0x8(%ebp)
  801561:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801564:	0f af 45 10          	imul   0x10(%ebp),%eax
  801568:	89 c2                	mov    %eax,%edx
  80156a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80156d:	01 d0                	add    %edx,%eax
  80156f:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  801572:	e9 7b ff ff ff       	jmp    8014f2 <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  801577:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  801578:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80157c:	74 08                	je     801586 <strtol+0x134>
		*endptr = (char *) s;
  80157e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801581:	8b 55 08             	mov    0x8(%ebp),%edx
  801584:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  801586:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  80158a:	74 07                	je     801593 <strtol+0x141>
  80158c:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80158f:	f7 d8                	neg    %eax
  801591:	eb 03                	jmp    801596 <strtol+0x144>
  801593:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  801596:	c9                   	leave  
  801597:	c3                   	ret    

00801598 <ltostr>:

void
ltostr(long value, char *str)
{
  801598:	55                   	push   %ebp
  801599:	89 e5                	mov    %esp,%ebp
  80159b:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  80159e:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  8015a5:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  8015ac:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8015b0:	79 13                	jns    8015c5 <ltostr+0x2d>
	{
		neg = 1;
  8015b2:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  8015b9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8015bc:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  8015bf:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  8015c2:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  8015c5:	8b 45 08             	mov    0x8(%ebp),%eax
  8015c8:	b9 0a 00 00 00       	mov    $0xa,%ecx
  8015cd:	99                   	cltd   
  8015ce:	f7 f9                	idiv   %ecx
  8015d0:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  8015d3:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8015d6:	8d 50 01             	lea    0x1(%eax),%edx
  8015d9:	89 55 f8             	mov    %edx,-0x8(%ebp)
  8015dc:	89 c2                	mov    %eax,%edx
  8015de:	8b 45 0c             	mov    0xc(%ebp),%eax
  8015e1:	01 d0                	add    %edx,%eax
  8015e3:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8015e6:	83 c2 30             	add    $0x30,%edx
  8015e9:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  8015eb:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8015ee:	b8 67 66 66 66       	mov    $0x66666667,%eax
  8015f3:	f7 e9                	imul   %ecx
  8015f5:	c1 fa 02             	sar    $0x2,%edx
  8015f8:	89 c8                	mov    %ecx,%eax
  8015fa:	c1 f8 1f             	sar    $0x1f,%eax
  8015fd:	29 c2                	sub    %eax,%edx
  8015ff:	89 d0                	mov    %edx,%eax
  801601:	89 45 08             	mov    %eax,0x8(%ebp)
	} while (value % 10 != 0);
  801604:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801607:	b8 67 66 66 66       	mov    $0x66666667,%eax
  80160c:	f7 e9                	imul   %ecx
  80160e:	c1 fa 02             	sar    $0x2,%edx
  801611:	89 c8                	mov    %ecx,%eax
  801613:	c1 f8 1f             	sar    $0x1f,%eax
  801616:	29 c2                	sub    %eax,%edx
  801618:	89 d0                	mov    %edx,%eax
  80161a:	c1 e0 02             	shl    $0x2,%eax
  80161d:	01 d0                	add    %edx,%eax
  80161f:	01 c0                	add    %eax,%eax
  801621:	29 c1                	sub    %eax,%ecx
  801623:	89 ca                	mov    %ecx,%edx
  801625:	85 d2                	test   %edx,%edx
  801627:	75 9c                	jne    8015c5 <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  801629:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  801630:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801633:	48                   	dec    %eax
  801634:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  801637:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  80163b:	74 3d                	je     80167a <ltostr+0xe2>
		start = 1 ;
  80163d:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  801644:	eb 34                	jmp    80167a <ltostr+0xe2>
	{
		char tmp = str[start] ;
  801646:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801649:	8b 45 0c             	mov    0xc(%ebp),%eax
  80164c:	01 d0                	add    %edx,%eax
  80164e:	8a 00                	mov    (%eax),%al
  801650:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  801653:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801656:	8b 45 0c             	mov    0xc(%ebp),%eax
  801659:	01 c2                	add    %eax,%edx
  80165b:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  80165e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801661:	01 c8                	add    %ecx,%eax
  801663:	8a 00                	mov    (%eax),%al
  801665:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  801667:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80166a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80166d:	01 c2                	add    %eax,%edx
  80166f:	8a 45 eb             	mov    -0x15(%ebp),%al
  801672:	88 02                	mov    %al,(%edx)
		start++ ;
  801674:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  801677:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  80167a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80167d:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801680:	7c c4                	jl     801646 <ltostr+0xae>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  801682:	8b 55 f8             	mov    -0x8(%ebp),%edx
  801685:	8b 45 0c             	mov    0xc(%ebp),%eax
  801688:	01 d0                	add    %edx,%eax
  80168a:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  80168d:	90                   	nop
  80168e:	c9                   	leave  
  80168f:	c3                   	ret    

00801690 <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  801690:	55                   	push   %ebp
  801691:	89 e5                	mov    %esp,%ebp
  801693:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  801696:	ff 75 08             	pushl  0x8(%ebp)
  801699:	e8 54 fa ff ff       	call   8010f2 <strlen>
  80169e:	83 c4 04             	add    $0x4,%esp
  8016a1:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  8016a4:	ff 75 0c             	pushl  0xc(%ebp)
  8016a7:	e8 46 fa ff ff       	call   8010f2 <strlen>
  8016ac:	83 c4 04             	add    $0x4,%esp
  8016af:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  8016b2:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  8016b9:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8016c0:	eb 17                	jmp    8016d9 <strcconcat+0x49>
		final[s] = str1[s] ;
  8016c2:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8016c5:	8b 45 10             	mov    0x10(%ebp),%eax
  8016c8:	01 c2                	add    %eax,%edx
  8016ca:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  8016cd:	8b 45 08             	mov    0x8(%ebp),%eax
  8016d0:	01 c8                	add    %ecx,%eax
  8016d2:	8a 00                	mov    (%eax),%al
  8016d4:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  8016d6:	ff 45 fc             	incl   -0x4(%ebp)
  8016d9:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8016dc:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  8016df:	7c e1                	jl     8016c2 <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  8016e1:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  8016e8:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  8016ef:	eb 1f                	jmp    801710 <strcconcat+0x80>
		final[s++] = str2[i] ;
  8016f1:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8016f4:	8d 50 01             	lea    0x1(%eax),%edx
  8016f7:	89 55 fc             	mov    %edx,-0x4(%ebp)
  8016fa:	89 c2                	mov    %eax,%edx
  8016fc:	8b 45 10             	mov    0x10(%ebp),%eax
  8016ff:	01 c2                	add    %eax,%edx
  801701:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  801704:	8b 45 0c             	mov    0xc(%ebp),%eax
  801707:	01 c8                	add    %ecx,%eax
  801709:	8a 00                	mov    (%eax),%al
  80170b:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  80170d:	ff 45 f8             	incl   -0x8(%ebp)
  801710:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801713:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801716:	7c d9                	jl     8016f1 <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  801718:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80171b:	8b 45 10             	mov    0x10(%ebp),%eax
  80171e:	01 d0                	add    %edx,%eax
  801720:	c6 00 00             	movb   $0x0,(%eax)
}
  801723:	90                   	nop
  801724:	c9                   	leave  
  801725:	c3                   	ret    

00801726 <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  801726:	55                   	push   %ebp
  801727:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  801729:	8b 45 14             	mov    0x14(%ebp),%eax
  80172c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  801732:	8b 45 14             	mov    0x14(%ebp),%eax
  801735:	8b 00                	mov    (%eax),%eax
  801737:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80173e:	8b 45 10             	mov    0x10(%ebp),%eax
  801741:	01 d0                	add    %edx,%eax
  801743:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801749:	eb 0c                	jmp    801757 <strsplit+0x31>
			*string++ = 0;
  80174b:	8b 45 08             	mov    0x8(%ebp),%eax
  80174e:	8d 50 01             	lea    0x1(%eax),%edx
  801751:	89 55 08             	mov    %edx,0x8(%ebp)
  801754:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801757:	8b 45 08             	mov    0x8(%ebp),%eax
  80175a:	8a 00                	mov    (%eax),%al
  80175c:	84 c0                	test   %al,%al
  80175e:	74 18                	je     801778 <strsplit+0x52>
  801760:	8b 45 08             	mov    0x8(%ebp),%eax
  801763:	8a 00                	mov    (%eax),%al
  801765:	0f be c0             	movsbl %al,%eax
  801768:	50                   	push   %eax
  801769:	ff 75 0c             	pushl  0xc(%ebp)
  80176c:	e8 13 fb ff ff       	call   801284 <strchr>
  801771:	83 c4 08             	add    $0x8,%esp
  801774:	85 c0                	test   %eax,%eax
  801776:	75 d3                	jne    80174b <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  801778:	8b 45 08             	mov    0x8(%ebp),%eax
  80177b:	8a 00                	mov    (%eax),%al
  80177d:	84 c0                	test   %al,%al
  80177f:	74 5a                	je     8017db <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  801781:	8b 45 14             	mov    0x14(%ebp),%eax
  801784:	8b 00                	mov    (%eax),%eax
  801786:	83 f8 0f             	cmp    $0xf,%eax
  801789:	75 07                	jne    801792 <strsplit+0x6c>
		{
			return 0;
  80178b:	b8 00 00 00 00       	mov    $0x0,%eax
  801790:	eb 66                	jmp    8017f8 <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  801792:	8b 45 14             	mov    0x14(%ebp),%eax
  801795:	8b 00                	mov    (%eax),%eax
  801797:	8d 48 01             	lea    0x1(%eax),%ecx
  80179a:	8b 55 14             	mov    0x14(%ebp),%edx
  80179d:	89 0a                	mov    %ecx,(%edx)
  80179f:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8017a6:	8b 45 10             	mov    0x10(%ebp),%eax
  8017a9:	01 c2                	add    %eax,%edx
  8017ab:	8b 45 08             	mov    0x8(%ebp),%eax
  8017ae:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  8017b0:	eb 03                	jmp    8017b5 <strsplit+0x8f>
			string++;
  8017b2:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  8017b5:	8b 45 08             	mov    0x8(%ebp),%eax
  8017b8:	8a 00                	mov    (%eax),%al
  8017ba:	84 c0                	test   %al,%al
  8017bc:	74 8b                	je     801749 <strsplit+0x23>
  8017be:	8b 45 08             	mov    0x8(%ebp),%eax
  8017c1:	8a 00                	mov    (%eax),%al
  8017c3:	0f be c0             	movsbl %al,%eax
  8017c6:	50                   	push   %eax
  8017c7:	ff 75 0c             	pushl  0xc(%ebp)
  8017ca:	e8 b5 fa ff ff       	call   801284 <strchr>
  8017cf:	83 c4 08             	add    $0x8,%esp
  8017d2:	85 c0                	test   %eax,%eax
  8017d4:	74 dc                	je     8017b2 <strsplit+0x8c>
			string++;
	}
  8017d6:	e9 6e ff ff ff       	jmp    801749 <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  8017db:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  8017dc:	8b 45 14             	mov    0x14(%ebp),%eax
  8017df:	8b 00                	mov    (%eax),%eax
  8017e1:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8017e8:	8b 45 10             	mov    0x10(%ebp),%eax
  8017eb:	01 d0                	add    %edx,%eax
  8017ed:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  8017f3:	b8 01 00 00 00       	mov    $0x1,%eax
}
  8017f8:	c9                   	leave  
  8017f9:	c3                   	ret    

008017fa <InitializeUHeap>:
//============================== GIVEN FUNCTIONS ===================================//
//==================================================================================//

int FirstTimeFlag = 1;
void InitializeUHeap()
{
  8017fa:	55                   	push   %ebp
  8017fb:	89 e5                	mov    %esp,%ebp
  8017fd:	83 ec 08             	sub    $0x8,%esp
	if(FirstTimeFlag)
  801800:	a1 04 40 80 00       	mov    0x804004,%eax
  801805:	85 c0                	test   %eax,%eax
  801807:	74 1f                	je     801828 <InitializeUHeap+0x2e>
	{
		initialize_dyn_block_system();
  801809:	e8 1d 00 00 00       	call   80182b <initialize_dyn_block_system>
		cprintf("DYNAMIC BLOCK SYSTEM IS INITIALIZED\n");
  80180e:	83 ec 0c             	sub    $0xc,%esp
  801811:	68 10 3d 80 00       	push   $0x803d10
  801816:	e8 55 f2 ff ff       	call   800a70 <cprintf>
  80181b:	83 c4 10             	add    $0x10,%esp
#if UHP_USE_BUDDY
		initialize_buddy();
		cprintf("BUDDY SYSTEM IS INITIALIZED\n");
#endif
		FirstTimeFlag = 0;
  80181e:	c7 05 04 40 80 00 00 	movl   $0x0,0x804004
  801825:	00 00 00 
	}
}
  801828:	90                   	nop
  801829:	c9                   	leave  
  80182a:	c3                   	ret    

0080182b <initialize_dyn_block_system>:

//=================================
// [1] INITIALIZE DYNAMIC ALLOCATOR:
//=================================
void initialize_dyn_block_system()
{
  80182b:	55                   	push   %ebp
  80182c:	89 e5                	mov    %esp,%ebp
  80182e:	83 ec 28             	sub    $0x28,%esp
	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] initialize_dyn_block_system
	// your code is here, remove the panic and write your code
	//panic("initialize_dyn_block_system() is not implemented yet...!!");

	LIST_INIT(&AllocMemBlocksList);
  801831:	c7 05 40 40 80 00 00 	movl   $0x0,0x804040
  801838:	00 00 00 
  80183b:	c7 05 44 40 80 00 00 	movl   $0x0,0x804044
  801842:	00 00 00 
  801845:	c7 05 4c 40 80 00 00 	movl   $0x0,0x80404c
  80184c:	00 00 00 
	LIST_INIT(&FreeMemBlocksList);
  80184f:	c7 05 38 41 80 00 00 	movl   $0x0,0x804138
  801856:	00 00 00 
  801859:	c7 05 3c 41 80 00 00 	movl   $0x0,0x80413c
  801860:	00 00 00 
  801863:	c7 05 44 41 80 00 00 	movl   $0x0,0x804144
  80186a:	00 00 00 
	MAX_MEM_BLOCK_CNT = NUM_OF_UHEAP_PAGES;
  80186d:	c7 05 20 41 80 00 00 	movl   $0x20000,0x804120
  801874:	00 02 00 
	MemBlockNodes = (void*)USER_DYN_BLKS_ARRAY;
  801877:	c7 45 f4 00 00 e0 7f 	movl   $0x7fe00000,-0xc(%ebp)
  80187e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801881:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801886:	2d 00 10 00 00       	sub    $0x1000,%eax
  80188b:	a3 50 40 80 00       	mov    %eax,0x804050
	int size_of_block = sizeof(struct MemBlock);
  801890:	c7 45 f0 10 00 00 00 	movl   $0x10,-0x10(%ebp)
	int size_all_struct = size_of_block*MAX_MEM_BLOCK_CNT;
  801897:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80189a:	a1 20 41 80 00       	mov    0x804120,%eax
  80189f:	0f af c2             	imul   %edx,%eax
  8018a2:	89 45 ec             	mov    %eax,-0x14(%ebp)
	size_all_struct = ROUNDUP(size_all_struct, PAGE_SIZE);
  8018a5:	c7 45 e8 00 10 00 00 	movl   $0x1000,-0x18(%ebp)
  8018ac:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8018af:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8018b2:	01 d0                	add    %edx,%eax
  8018b4:	48                   	dec    %eax
  8018b5:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8018b8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8018bb:	ba 00 00 00 00       	mov    $0x0,%edx
  8018c0:	f7 75 e8             	divl   -0x18(%ebp)
  8018c3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8018c6:	29 d0                	sub    %edx,%eax
  8018c8:	89 45 ec             	mov    %eax,-0x14(%ebp)
	sys_allocate_chunk(USER_DYN_BLKS_ARRAY, size_all_struct,PERM_USER| PERM_WRITEABLE);
  8018cb:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8018ce:	c7 45 e0 00 00 e0 7f 	movl   $0x7fe00000,-0x20(%ebp)
  8018d5:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8018d8:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
  8018de:	81 ea 00 10 00 00    	sub    $0x1000,%edx
  8018e4:	83 ec 04             	sub    $0x4,%esp
  8018e7:	6a 06                	push   $0x6
  8018e9:	50                   	push   %eax
  8018ea:	52                   	push   %edx
  8018eb:	e8 a1 05 00 00       	call   801e91 <sys_allocate_chunk>
  8018f0:	83 c4 10             	add    $0x10,%esp
	initialize_MemBlocksList(MAX_MEM_BLOCK_CNT);
  8018f3:	a1 20 41 80 00       	mov    0x804120,%eax
  8018f8:	83 ec 0c             	sub    $0xc,%esp
  8018fb:	50                   	push   %eax
  8018fc:	e8 16 0c 00 00       	call   802517 <initialize_MemBlocksList>
  801901:	83 c4 10             	add    $0x10,%esp
	struct MemBlock* ourBlock =LIST_LAST(&AvailableMemBlocksList);
  801904:	a1 4c 41 80 00       	mov    0x80414c,%eax
  801909:	89 45 dc             	mov    %eax,-0x24(%ebp)
	LIST_REMOVE(&AvailableMemBlocksList,ourBlock);
  80190c:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  801910:	75 14                	jne    801926 <initialize_dyn_block_system+0xfb>
  801912:	83 ec 04             	sub    $0x4,%esp
  801915:	68 35 3d 80 00       	push   $0x803d35
  80191a:	6a 2d                	push   $0x2d
  80191c:	68 53 3d 80 00       	push   $0x803d53
  801921:	e8 96 ee ff ff       	call   8007bc <_panic>
  801926:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801929:	8b 00                	mov    (%eax),%eax
  80192b:	85 c0                	test   %eax,%eax
  80192d:	74 10                	je     80193f <initialize_dyn_block_system+0x114>
  80192f:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801932:	8b 00                	mov    (%eax),%eax
  801934:	8b 55 dc             	mov    -0x24(%ebp),%edx
  801937:	8b 52 04             	mov    0x4(%edx),%edx
  80193a:	89 50 04             	mov    %edx,0x4(%eax)
  80193d:	eb 0b                	jmp    80194a <initialize_dyn_block_system+0x11f>
  80193f:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801942:	8b 40 04             	mov    0x4(%eax),%eax
  801945:	a3 4c 41 80 00       	mov    %eax,0x80414c
  80194a:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80194d:	8b 40 04             	mov    0x4(%eax),%eax
  801950:	85 c0                	test   %eax,%eax
  801952:	74 0f                	je     801963 <initialize_dyn_block_system+0x138>
  801954:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801957:	8b 40 04             	mov    0x4(%eax),%eax
  80195a:	8b 55 dc             	mov    -0x24(%ebp),%edx
  80195d:	8b 12                	mov    (%edx),%edx
  80195f:	89 10                	mov    %edx,(%eax)
  801961:	eb 0a                	jmp    80196d <initialize_dyn_block_system+0x142>
  801963:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801966:	8b 00                	mov    (%eax),%eax
  801968:	a3 48 41 80 00       	mov    %eax,0x804148
  80196d:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801970:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  801976:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801979:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  801980:	a1 54 41 80 00       	mov    0x804154,%eax
  801985:	48                   	dec    %eax
  801986:	a3 54 41 80 00       	mov    %eax,0x804154
	ourBlock->size = USER_HEAP_MAX-USER_HEAP_START;
  80198b:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80198e:	c7 40 0c 00 00 00 20 	movl   $0x20000000,0xc(%eax)
	ourBlock->sva=USER_HEAP_START;
  801995:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801998:	c7 40 08 00 00 00 80 	movl   $0x80000000,0x8(%eax)
	LIST_INSERT_TAIL(&FreeMemBlocksList, ourBlock);
  80199f:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  8019a3:	75 14                	jne    8019b9 <initialize_dyn_block_system+0x18e>
  8019a5:	83 ec 04             	sub    $0x4,%esp
  8019a8:	68 60 3d 80 00       	push   $0x803d60
  8019ad:	6a 30                	push   $0x30
  8019af:	68 53 3d 80 00       	push   $0x803d53
  8019b4:	e8 03 ee ff ff       	call   8007bc <_panic>
  8019b9:	8b 15 3c 41 80 00    	mov    0x80413c,%edx
  8019bf:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8019c2:	89 50 04             	mov    %edx,0x4(%eax)
  8019c5:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8019c8:	8b 40 04             	mov    0x4(%eax),%eax
  8019cb:	85 c0                	test   %eax,%eax
  8019cd:	74 0c                	je     8019db <initialize_dyn_block_system+0x1b0>
  8019cf:	a1 3c 41 80 00       	mov    0x80413c,%eax
  8019d4:	8b 55 dc             	mov    -0x24(%ebp),%edx
  8019d7:	89 10                	mov    %edx,(%eax)
  8019d9:	eb 08                	jmp    8019e3 <initialize_dyn_block_system+0x1b8>
  8019db:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8019de:	a3 38 41 80 00       	mov    %eax,0x804138
  8019e3:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8019e6:	a3 3c 41 80 00       	mov    %eax,0x80413c
  8019eb:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8019ee:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8019f4:	a1 44 41 80 00       	mov    0x804144,%eax
  8019f9:	40                   	inc    %eax
  8019fa:	a3 44 41 80 00       	mov    %eax,0x804144
	//[1] Initialize two lists (AllocMemBlocksList & FreeMemBlocksList) [Hint: use LIST_INIT()]
	//[2] Dynamically allocate the array of MemBlockNodes at VA USER_DYN_BLKS_ARRAY
	//	  (remember to set MAX_MEM_BLOCK_CNT with the chosen size of the array)
	//[3] Initialize AvailableMemBlocksList by filling it with the MemBlockNodes
	//[4] Insert a new MemBlock with the heap size into the FreeMemBlocksList
}
  8019ff:	90                   	nop
  801a00:	c9                   	leave  
  801a01:	c3                   	ret    

00801a02 <malloc>:
//=================================
// [2] ALLOCATE SPACE IN USER HEAP:
//=================================

void* malloc(uint32 size)
{
  801a02:	55                   	push   %ebp
  801a03:	89 e5                	mov    %esp,%ebp
  801a05:	83 ec 18             	sub    $0x18,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801a08:	e8 ed fd ff ff       	call   8017fa <InitializeUHeap>
	if (size == 0) return NULL ;
  801a0d:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801a11:	75 07                	jne    801a1a <malloc+0x18>
  801a13:	b8 00 00 00 00       	mov    $0x0,%eax
  801a18:	eb 67                	jmp    801a81 <malloc+0x7f>

	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] malloc
	// your code is here, remove the panic and write your code
	//panic("malloc() is not implemented yet...!!");

	size = ROUNDUP(size, PAGE_SIZE);
  801a1a:	c7 45 f4 00 10 00 00 	movl   $0x1000,-0xc(%ebp)
  801a21:	8b 55 08             	mov    0x8(%ebp),%edx
  801a24:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801a27:	01 d0                	add    %edx,%eax
  801a29:	48                   	dec    %eax
  801a2a:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801a2d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801a30:	ba 00 00 00 00       	mov    $0x0,%edx
  801a35:	f7 75 f4             	divl   -0xc(%ebp)
  801a38:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801a3b:	29 d0                	sub    %edx,%eax
  801a3d:	89 45 08             	mov    %eax,0x8(%ebp)
	if(sys_isUHeapPlacementStrategyFIRSTFIT())
  801a40:	e8 1a 08 00 00       	call   80225f <sys_isUHeapPlacementStrategyFIRSTFIT>
  801a45:	85 c0                	test   %eax,%eax
  801a47:	74 33                	je     801a7c <malloc+0x7a>
	{
		struct MemBlock * myBlock = alloc_block_FF(size);
  801a49:	83 ec 0c             	sub    $0xc,%esp
  801a4c:	ff 75 08             	pushl  0x8(%ebp)
  801a4f:	e8 0c 0e 00 00       	call   802860 <alloc_block_FF>
  801a54:	83 c4 10             	add    $0x10,%esp
  801a57:	89 45 ec             	mov    %eax,-0x14(%ebp)
		if(myBlock != NULL)
  801a5a:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  801a5e:	74 1c                	je     801a7c <malloc+0x7a>
		{
			insert_sorted_allocList(myBlock);
  801a60:	83 ec 0c             	sub    $0xc,%esp
  801a63:	ff 75 ec             	pushl  -0x14(%ebp)
  801a66:	e8 07 0c 00 00       	call   802672 <insert_sorted_allocList>
  801a6b:	83 c4 10             	add    $0x10,%esp
			uint32 ptr = myBlock->sva;
  801a6e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801a71:	8b 40 08             	mov    0x8(%eax),%eax
  801a74:	89 45 e8             	mov    %eax,-0x18(%ebp)
			return (void *)ptr;
  801a77:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801a7a:	eb 05                	jmp    801a81 <malloc+0x7f>
		}
	}
	return NULL;
  801a7c:	b8 00 00 00 00       	mov    $0x0,%eax
	//		to the required allocation size (space should be on 4 KB BOUNDARY)
	//	2) if no suitable space found, return NULL
	// 	3) Return pointer containing the virtual address of allocated space,
	//
	//Use sys_isUHeapPlacementStrategyFIRSTFIT()... to check the current strategy
}
  801a81:	c9                   	leave  
  801a82:	c3                   	ret    

00801a83 <free>:
//	We can use sys_free_user_mem(uint32 virtual_address, uint32 size); which
//		switches to the kernel mode, calls free_user_mem() in
//		"kern/mem/chunk_operations.c", then switch back to the user mode here
//	the free_user_mem function is empty, make sure to implement it.
void free(void* virtual_address)
{
  801a83:	55                   	push   %ebp
  801a84:	89 e5                	mov    %esp,%ebp
  801a86:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] free
	// your code is here, remove the panic and write your code
	//panic("free() is not implemented yet...!!");

	uint32 virtualAddress = (uint32 )(virtual_address);
  801a89:	8b 45 08             	mov    0x8(%ebp),%eax
  801a8c:	89 45 f4             	mov    %eax,-0xc(%ebp)
//	virtualAddress = ROUNDDOWN(virtualAddress, PAGE_SIZE);
	struct MemBlock * myBlock = find_block(&AllocMemBlocksList, virtualAddress);
  801a8f:	83 ec 08             	sub    $0x8,%esp
  801a92:	ff 75 f4             	pushl  -0xc(%ebp)
  801a95:	68 40 40 80 00       	push   $0x804040
  801a9a:	e8 5b 0b 00 00       	call   8025fa <find_block>
  801a9f:	83 c4 10             	add    $0x10,%esp
  801aa2:	89 45 f0             	mov    %eax,-0x10(%ebp)
//	cprintf ("ptr sva at free user side = %x \n", myBlock->sva);
	sys_free_user_mem(virtualAddress, myBlock->size);
  801aa5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801aa8:	8b 40 0c             	mov    0xc(%eax),%eax
  801aab:	83 ec 08             	sub    $0x8,%esp
  801aae:	50                   	push   %eax
  801aaf:	ff 75 f4             	pushl  -0xc(%ebp)
  801ab2:	e8 a2 03 00 00       	call   801e59 <sys_free_user_mem>
  801ab7:	83 c4 10             	add    $0x10,%esp
	LIST_REMOVE(&AllocMemBlocksList, myBlock);
  801aba:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801abe:	75 14                	jne    801ad4 <free+0x51>
  801ac0:	83 ec 04             	sub    $0x4,%esp
  801ac3:	68 35 3d 80 00       	push   $0x803d35
  801ac8:	6a 76                	push   $0x76
  801aca:	68 53 3d 80 00       	push   $0x803d53
  801acf:	e8 e8 ec ff ff       	call   8007bc <_panic>
  801ad4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801ad7:	8b 00                	mov    (%eax),%eax
  801ad9:	85 c0                	test   %eax,%eax
  801adb:	74 10                	je     801aed <free+0x6a>
  801add:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801ae0:	8b 00                	mov    (%eax),%eax
  801ae2:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801ae5:	8b 52 04             	mov    0x4(%edx),%edx
  801ae8:	89 50 04             	mov    %edx,0x4(%eax)
  801aeb:	eb 0b                	jmp    801af8 <free+0x75>
  801aed:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801af0:	8b 40 04             	mov    0x4(%eax),%eax
  801af3:	a3 44 40 80 00       	mov    %eax,0x804044
  801af8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801afb:	8b 40 04             	mov    0x4(%eax),%eax
  801afe:	85 c0                	test   %eax,%eax
  801b00:	74 0f                	je     801b11 <free+0x8e>
  801b02:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801b05:	8b 40 04             	mov    0x4(%eax),%eax
  801b08:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801b0b:	8b 12                	mov    (%edx),%edx
  801b0d:	89 10                	mov    %edx,(%eax)
  801b0f:	eb 0a                	jmp    801b1b <free+0x98>
  801b11:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801b14:	8b 00                	mov    (%eax),%eax
  801b16:	a3 40 40 80 00       	mov    %eax,0x804040
  801b1b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801b1e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  801b24:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801b27:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  801b2e:	a1 4c 40 80 00       	mov    0x80404c,%eax
  801b33:	48                   	dec    %eax
  801b34:	a3 4c 40 80 00       	mov    %eax,0x80404c
	insert_sorted_with_merge_freeList(myBlock);
  801b39:	83 ec 0c             	sub    $0xc,%esp
  801b3c:	ff 75 f0             	pushl  -0x10(%ebp)
  801b3f:	e8 0b 14 00 00       	call   802f4f <insert_sorted_with_merge_freeList>
  801b44:	83 c4 10             	add    $0x10,%esp

	//you should get the size of the given allocation using its address
	//you need to call sys_free_user_mem()
	//refer to the project presentation and documentation for details
}
  801b47:	90                   	nop
  801b48:	c9                   	leave  
  801b49:	c3                   	ret    

00801b4a <smalloc>:

//=================================
// [4] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
  801b4a:	55                   	push   %ebp
  801b4b:	89 e5                	mov    %esp,%ebp
  801b4d:	83 ec 28             	sub    $0x28,%esp
  801b50:	8b 45 10             	mov    0x10(%ebp),%eax
  801b53:	88 45 e4             	mov    %al,-0x1c(%ebp)
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801b56:	e8 9f fc ff ff       	call   8017fa <InitializeUHeap>
	if (size == 0) return NULL ;
  801b5b:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801b5f:	75 0a                	jne    801b6b <smalloc+0x21>
  801b61:	b8 00 00 00 00       	mov    $0x0,%eax
  801b66:	e9 8d 00 00 00       	jmp    801bf8 <smalloc+0xae>

	//This function should find the space of the required range
	// * ON 4KB BOUNDARY **** //
	//Use sys_isUHeapPlacementStrategyFIRSTFIT() to check the current strategy

	size = ROUNDUP(size, PAGE_SIZE);
  801b6b:	c7 45 f4 00 10 00 00 	movl   $0x1000,-0xc(%ebp)
  801b72:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b75:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801b78:	01 d0                	add    %edx,%eax
  801b7a:	48                   	dec    %eax
  801b7b:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801b7e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801b81:	ba 00 00 00 00       	mov    $0x0,%edx
  801b86:	f7 75 f4             	divl   -0xc(%ebp)
  801b89:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801b8c:	29 d0                	sub    %edx,%eax
  801b8e:	89 45 0c             	mov    %eax,0xc(%ebp)
		if(sys_isUHeapPlacementStrategyFIRSTFIT())
  801b91:	e8 c9 06 00 00       	call   80225f <sys_isUHeapPlacementStrategyFIRSTFIT>
  801b96:	85 c0                	test   %eax,%eax
  801b98:	74 59                	je     801bf3 <smalloc+0xa9>
		{
			struct MemBlock * v1=NULL;
  801b9a:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
			v1= alloc_block_FF(size);
  801ba1:	83 ec 0c             	sub    $0xc,%esp
  801ba4:	ff 75 0c             	pushl  0xc(%ebp)
  801ba7:	e8 b4 0c 00 00       	call   802860 <alloc_block_FF>
  801bac:	83 c4 10             	add    $0x10,%esp
  801baf:	89 45 ec             	mov    %eax,-0x14(%ebp)
			if(v1==NULL)
  801bb2:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  801bb6:	75 07                	jne    801bbf <smalloc+0x75>
			{
				return NULL;
  801bb8:	b8 00 00 00 00       	mov    $0x0,%eax
  801bbd:	eb 39                	jmp    801bf8 <smalloc+0xae>
			}
			else
			{
				int ret=sys_createSharedObject(sharedVarName,  size,  isWritable,(void*)v1->sva);
  801bbf:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801bc2:	8b 40 08             	mov    0x8(%eax),%eax
  801bc5:	89 c2                	mov    %eax,%edx
  801bc7:	0f b6 45 e4          	movzbl -0x1c(%ebp),%eax
  801bcb:	52                   	push   %edx
  801bcc:	50                   	push   %eax
  801bcd:	ff 75 0c             	pushl  0xc(%ebp)
  801bd0:	ff 75 08             	pushl  0x8(%ebp)
  801bd3:	e8 0c 04 00 00       	call   801fe4 <sys_createSharedObject>
  801bd8:	83 c4 10             	add    $0x10,%esp
  801bdb:	89 45 e8             	mov    %eax,-0x18(%ebp)
				if(ret>=0)
  801bde:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  801be2:	78 08                	js     801bec <smalloc+0xa2>
				{
					return (void*)v1->sva;
  801be4:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801be7:	8b 40 08             	mov    0x8(%eax),%eax
  801bea:	eb 0c                	jmp    801bf8 <smalloc+0xae>
				}
				else
				{
					return NULL;
  801bec:	b8 00 00 00 00       	mov    $0x0,%eax
  801bf1:	eb 05                	jmp    801bf8 <smalloc+0xae>
				}
			}

		}
		return NULL;
  801bf3:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801bf8:	c9                   	leave  
  801bf9:	c3                   	ret    

00801bfa <sget>:

//========================================
// [5] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  801bfa:	55                   	push   %ebp
  801bfb:	89 e5                	mov    %esp,%ebp
  801bfd:	83 ec 18             	sub    $0x18,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801c00:	e8 f5 fb ff ff       	call   8017fa <InitializeUHeap>

	//This function should find the space for sharing the variable
	// *** ON 4KB BOUNDARY ******** //

	//Use sys_isUHeapPlacementStrategyFIRSTFIT() to check the current strategy
	int ret=sys_getSizeOfSharedObject(ownerEnvID,sharedVarName);
  801c05:	83 ec 08             	sub    $0x8,%esp
  801c08:	ff 75 0c             	pushl  0xc(%ebp)
  801c0b:	ff 75 08             	pushl  0x8(%ebp)
  801c0e:	e8 fb 03 00 00       	call   80200e <sys_getSizeOfSharedObject>
  801c13:	83 c4 10             	add    $0x10,%esp
  801c16:	89 45 f4             	mov    %eax,-0xc(%ebp)
	if(ret==0)
  801c19:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801c1d:	75 07                	jne    801c26 <sget+0x2c>
	{
		return NULL;
  801c1f:	b8 00 00 00 00       	mov    $0x0,%eax
  801c24:	eb 64                	jmp    801c8a <sget+0x90>
	}
	if(sys_isUHeapPlacementStrategyFIRSTFIT())
  801c26:	e8 34 06 00 00       	call   80225f <sys_isUHeapPlacementStrategyFIRSTFIT>
  801c2b:	85 c0                	test   %eax,%eax
  801c2d:	74 56                	je     801c85 <sget+0x8b>
	{
		struct MemBlock * v1=NULL;
  801c2f:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
		v1= alloc_block_FF(ret);
  801c36:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801c39:	83 ec 0c             	sub    $0xc,%esp
  801c3c:	50                   	push   %eax
  801c3d:	e8 1e 0c 00 00       	call   802860 <alloc_block_FF>
  801c42:	83 c4 10             	add    $0x10,%esp
  801c45:	89 45 f0             	mov    %eax,-0x10(%ebp)
		if(v1==NULL)
  801c48:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801c4c:	75 07                	jne    801c55 <sget+0x5b>
		{
		return NULL;
  801c4e:	b8 00 00 00 00       	mov    $0x0,%eax
  801c53:	eb 35                	jmp    801c8a <sget+0x90>
	    }
		else
		{
			int ret1=sys_getSharedObject(ownerEnvID,sharedVarName,(void*)v1->sva);
  801c55:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801c58:	8b 40 08             	mov    0x8(%eax),%eax
  801c5b:	83 ec 04             	sub    $0x4,%esp
  801c5e:	50                   	push   %eax
  801c5f:	ff 75 0c             	pushl  0xc(%ebp)
  801c62:	ff 75 08             	pushl  0x8(%ebp)
  801c65:	e8 c1 03 00 00       	call   80202b <sys_getSharedObject>
  801c6a:	83 c4 10             	add    $0x10,%esp
  801c6d:	89 45 ec             	mov    %eax,-0x14(%ebp)
			if(ret1>=0)
  801c70:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  801c74:	78 08                	js     801c7e <sget+0x84>
			{
				return (void*)v1->sva;
  801c76:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801c79:	8b 40 08             	mov    0x8(%eax),%eax
  801c7c:	eb 0c                	jmp    801c8a <sget+0x90>
			}
			else
			{
				return NULL;
  801c7e:	b8 00 00 00 00       	mov    $0x0,%eax
  801c83:	eb 05                	jmp    801c8a <sget+0x90>
			}
		}
	}
  return NULL;
  801c85:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801c8a:	c9                   	leave  
  801c8b:	c3                   	ret    

00801c8c <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  801c8c:	55                   	push   %ebp
  801c8d:	89 e5                	mov    %esp,%ebp
  801c8f:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801c92:	e8 63 fb ff ff       	call   8017fa <InitializeUHeap>
	//==============================================================
	// [USER HEAP - USER SIDE] realloc
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  801c97:	83 ec 04             	sub    $0x4,%esp
  801c9a:	68 84 3d 80 00       	push   $0x803d84
  801c9f:	68 0e 01 00 00       	push   $0x10e
  801ca4:	68 53 3d 80 00       	push   $0x803d53
  801ca9:	e8 0e eb ff ff       	call   8007bc <_panic>

00801cae <sfree>:
//	use sys_freeSharedObject(...); which switches to the kernel mode,
//	calls freeSharedObject(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the freeSharedObject() function is empty, make sure to implement it.

void sfree(void* virtual_address)
{
  801cae:	55                   	push   %ebp
  801caf:	89 e5                	mov    %esp,%ebp
  801cb1:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS3 - BONUS] [SHARING - USER SIDE] sfree()

	// Write your code here, remove the panic and write your code
	panic("sfree() is not implemented yet...!!");
  801cb4:	83 ec 04             	sub    $0x4,%esp
  801cb7:	68 ac 3d 80 00       	push   $0x803dac
  801cbc:	68 22 01 00 00       	push   $0x122
  801cc1:	68 53 3d 80 00       	push   $0x803d53
  801cc6:	e8 f1 ea ff ff       	call   8007bc <_panic>

00801ccb <expand>:

//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//
void expand(uint32 newSize)
{
  801ccb:	55                   	push   %ebp
  801ccc:	89 e5                	mov    %esp,%ebp
  801cce:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801cd1:	83 ec 04             	sub    $0x4,%esp
  801cd4:	68 d0 3d 80 00       	push   $0x803dd0
  801cd9:	68 2d 01 00 00       	push   $0x12d
  801cde:	68 53 3d 80 00       	push   $0x803d53
  801ce3:	e8 d4 ea ff ff       	call   8007bc <_panic>

00801ce8 <shrink>:

}
void shrink(uint32 newSize)
{
  801ce8:	55                   	push   %ebp
  801ce9:	89 e5                	mov    %esp,%ebp
  801ceb:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801cee:	83 ec 04             	sub    $0x4,%esp
  801cf1:	68 d0 3d 80 00       	push   $0x803dd0
  801cf6:	68 32 01 00 00       	push   $0x132
  801cfb:	68 53 3d 80 00       	push   $0x803d53
  801d00:	e8 b7 ea ff ff       	call   8007bc <_panic>

00801d05 <freeHeap>:

}
void freeHeap(void* virtual_address)
{
  801d05:	55                   	push   %ebp
  801d06:	89 e5                	mov    %esp,%ebp
  801d08:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801d0b:	83 ec 04             	sub    $0x4,%esp
  801d0e:	68 d0 3d 80 00       	push   $0x803dd0
  801d13:	68 37 01 00 00       	push   $0x137
  801d18:	68 53 3d 80 00       	push   $0x803d53
  801d1d:	e8 9a ea ff ff       	call   8007bc <_panic>

00801d22 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  801d22:	55                   	push   %ebp
  801d23:	89 e5                	mov    %esp,%ebp
  801d25:	57                   	push   %edi
  801d26:	56                   	push   %esi
  801d27:	53                   	push   %ebx
  801d28:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801d2b:	8b 45 08             	mov    0x8(%ebp),%eax
  801d2e:	8b 55 0c             	mov    0xc(%ebp),%edx
  801d31:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801d34:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801d37:	8b 7d 18             	mov    0x18(%ebp),%edi
  801d3a:	8b 75 1c             	mov    0x1c(%ebp),%esi
  801d3d:	cd 30                	int    $0x30
  801d3f:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  801d42:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801d45:	83 c4 10             	add    $0x10,%esp
  801d48:	5b                   	pop    %ebx
  801d49:	5e                   	pop    %esi
  801d4a:	5f                   	pop    %edi
  801d4b:	5d                   	pop    %ebp
  801d4c:	c3                   	ret    

00801d4d <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  801d4d:	55                   	push   %ebp
  801d4e:	89 e5                	mov    %esp,%ebp
  801d50:	83 ec 04             	sub    $0x4,%esp
  801d53:	8b 45 10             	mov    0x10(%ebp),%eax
  801d56:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  801d59:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801d5d:	8b 45 08             	mov    0x8(%ebp),%eax
  801d60:	6a 00                	push   $0x0
  801d62:	6a 00                	push   $0x0
  801d64:	52                   	push   %edx
  801d65:	ff 75 0c             	pushl  0xc(%ebp)
  801d68:	50                   	push   %eax
  801d69:	6a 00                	push   $0x0
  801d6b:	e8 b2 ff ff ff       	call   801d22 <syscall>
  801d70:	83 c4 18             	add    $0x18,%esp
}
  801d73:	90                   	nop
  801d74:	c9                   	leave  
  801d75:	c3                   	ret    

00801d76 <sys_cgetc>:

int
sys_cgetc(void)
{
  801d76:	55                   	push   %ebp
  801d77:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  801d79:	6a 00                	push   $0x0
  801d7b:	6a 00                	push   $0x0
  801d7d:	6a 00                	push   $0x0
  801d7f:	6a 00                	push   $0x0
  801d81:	6a 00                	push   $0x0
  801d83:	6a 01                	push   $0x1
  801d85:	e8 98 ff ff ff       	call   801d22 <syscall>
  801d8a:	83 c4 18             	add    $0x18,%esp
}
  801d8d:	c9                   	leave  
  801d8e:	c3                   	ret    

00801d8f <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  801d8f:	55                   	push   %ebp
  801d90:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  801d92:	8b 55 0c             	mov    0xc(%ebp),%edx
  801d95:	8b 45 08             	mov    0x8(%ebp),%eax
  801d98:	6a 00                	push   $0x0
  801d9a:	6a 00                	push   $0x0
  801d9c:	6a 00                	push   $0x0
  801d9e:	52                   	push   %edx
  801d9f:	50                   	push   %eax
  801da0:	6a 05                	push   $0x5
  801da2:	e8 7b ff ff ff       	call   801d22 <syscall>
  801da7:	83 c4 18             	add    $0x18,%esp
}
  801daa:	c9                   	leave  
  801dab:	c3                   	ret    

00801dac <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  801dac:	55                   	push   %ebp
  801dad:	89 e5                	mov    %esp,%ebp
  801daf:	56                   	push   %esi
  801db0:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  801db1:	8b 75 18             	mov    0x18(%ebp),%esi
  801db4:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801db7:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801dba:	8b 55 0c             	mov    0xc(%ebp),%edx
  801dbd:	8b 45 08             	mov    0x8(%ebp),%eax
  801dc0:	56                   	push   %esi
  801dc1:	53                   	push   %ebx
  801dc2:	51                   	push   %ecx
  801dc3:	52                   	push   %edx
  801dc4:	50                   	push   %eax
  801dc5:	6a 06                	push   $0x6
  801dc7:	e8 56 ff ff ff       	call   801d22 <syscall>
  801dcc:	83 c4 18             	add    $0x18,%esp
}
  801dcf:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801dd2:	5b                   	pop    %ebx
  801dd3:	5e                   	pop    %esi
  801dd4:	5d                   	pop    %ebp
  801dd5:	c3                   	ret    

00801dd6 <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  801dd6:	55                   	push   %ebp
  801dd7:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  801dd9:	8b 55 0c             	mov    0xc(%ebp),%edx
  801ddc:	8b 45 08             	mov    0x8(%ebp),%eax
  801ddf:	6a 00                	push   $0x0
  801de1:	6a 00                	push   $0x0
  801de3:	6a 00                	push   $0x0
  801de5:	52                   	push   %edx
  801de6:	50                   	push   %eax
  801de7:	6a 07                	push   $0x7
  801de9:	e8 34 ff ff ff       	call   801d22 <syscall>
  801dee:	83 c4 18             	add    $0x18,%esp
}
  801df1:	c9                   	leave  
  801df2:	c3                   	ret    

00801df3 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  801df3:	55                   	push   %ebp
  801df4:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  801df6:	6a 00                	push   $0x0
  801df8:	6a 00                	push   $0x0
  801dfa:	6a 00                	push   $0x0
  801dfc:	ff 75 0c             	pushl  0xc(%ebp)
  801dff:	ff 75 08             	pushl  0x8(%ebp)
  801e02:	6a 08                	push   $0x8
  801e04:	e8 19 ff ff ff       	call   801d22 <syscall>
  801e09:	83 c4 18             	add    $0x18,%esp
}
  801e0c:	c9                   	leave  
  801e0d:	c3                   	ret    

00801e0e <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  801e0e:	55                   	push   %ebp
  801e0f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  801e11:	6a 00                	push   $0x0
  801e13:	6a 00                	push   $0x0
  801e15:	6a 00                	push   $0x0
  801e17:	6a 00                	push   $0x0
  801e19:	6a 00                	push   $0x0
  801e1b:	6a 09                	push   $0x9
  801e1d:	e8 00 ff ff ff       	call   801d22 <syscall>
  801e22:	83 c4 18             	add    $0x18,%esp
}
  801e25:	c9                   	leave  
  801e26:	c3                   	ret    

00801e27 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  801e27:	55                   	push   %ebp
  801e28:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  801e2a:	6a 00                	push   $0x0
  801e2c:	6a 00                	push   $0x0
  801e2e:	6a 00                	push   $0x0
  801e30:	6a 00                	push   $0x0
  801e32:	6a 00                	push   $0x0
  801e34:	6a 0a                	push   $0xa
  801e36:	e8 e7 fe ff ff       	call   801d22 <syscall>
  801e3b:	83 c4 18             	add    $0x18,%esp
}
  801e3e:	c9                   	leave  
  801e3f:	c3                   	ret    

00801e40 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  801e40:	55                   	push   %ebp
  801e41:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  801e43:	6a 00                	push   $0x0
  801e45:	6a 00                	push   $0x0
  801e47:	6a 00                	push   $0x0
  801e49:	6a 00                	push   $0x0
  801e4b:	6a 00                	push   $0x0
  801e4d:	6a 0b                	push   $0xb
  801e4f:	e8 ce fe ff ff       	call   801d22 <syscall>
  801e54:	83 c4 18             	add    $0x18,%esp
}
  801e57:	c9                   	leave  
  801e58:	c3                   	ret    

00801e59 <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  801e59:	55                   	push   %ebp
  801e5a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  801e5c:	6a 00                	push   $0x0
  801e5e:	6a 00                	push   $0x0
  801e60:	6a 00                	push   $0x0
  801e62:	ff 75 0c             	pushl  0xc(%ebp)
  801e65:	ff 75 08             	pushl  0x8(%ebp)
  801e68:	6a 0f                	push   $0xf
  801e6a:	e8 b3 fe ff ff       	call   801d22 <syscall>
  801e6f:	83 c4 18             	add    $0x18,%esp
	return;
  801e72:	90                   	nop
}
  801e73:	c9                   	leave  
  801e74:	c3                   	ret    

00801e75 <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  801e75:	55                   	push   %ebp
  801e76:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  801e78:	6a 00                	push   $0x0
  801e7a:	6a 00                	push   $0x0
  801e7c:	6a 00                	push   $0x0
  801e7e:	ff 75 0c             	pushl  0xc(%ebp)
  801e81:	ff 75 08             	pushl  0x8(%ebp)
  801e84:	6a 10                	push   $0x10
  801e86:	e8 97 fe ff ff       	call   801d22 <syscall>
  801e8b:	83 c4 18             	add    $0x18,%esp
	return ;
  801e8e:	90                   	nop
}
  801e8f:	c9                   	leave  
  801e90:	c3                   	ret    

00801e91 <sys_allocate_chunk>:

void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  801e91:	55                   	push   %ebp
  801e92:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  801e94:	6a 00                	push   $0x0
  801e96:	6a 00                	push   $0x0
  801e98:	ff 75 10             	pushl  0x10(%ebp)
  801e9b:	ff 75 0c             	pushl  0xc(%ebp)
  801e9e:	ff 75 08             	pushl  0x8(%ebp)
  801ea1:	6a 11                	push   $0x11
  801ea3:	e8 7a fe ff ff       	call   801d22 <syscall>
  801ea8:	83 c4 18             	add    $0x18,%esp
	return ;
  801eab:	90                   	nop
}
  801eac:	c9                   	leave  
  801ead:	c3                   	ret    

00801eae <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  801eae:	55                   	push   %ebp
  801eaf:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  801eb1:	6a 00                	push   $0x0
  801eb3:	6a 00                	push   $0x0
  801eb5:	6a 00                	push   $0x0
  801eb7:	6a 00                	push   $0x0
  801eb9:	6a 00                	push   $0x0
  801ebb:	6a 0c                	push   $0xc
  801ebd:	e8 60 fe ff ff       	call   801d22 <syscall>
  801ec2:	83 c4 18             	add    $0x18,%esp
}
  801ec5:	c9                   	leave  
  801ec6:	c3                   	ret    

00801ec7 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  801ec7:	55                   	push   %ebp
  801ec8:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  801eca:	6a 00                	push   $0x0
  801ecc:	6a 00                	push   $0x0
  801ece:	6a 00                	push   $0x0
  801ed0:	6a 00                	push   $0x0
  801ed2:	ff 75 08             	pushl  0x8(%ebp)
  801ed5:	6a 0d                	push   $0xd
  801ed7:	e8 46 fe ff ff       	call   801d22 <syscall>
  801edc:	83 c4 18             	add    $0x18,%esp
}
  801edf:	c9                   	leave  
  801ee0:	c3                   	ret    

00801ee1 <sys_scarce_memory>:

void sys_scarce_memory()
{
  801ee1:	55                   	push   %ebp
  801ee2:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  801ee4:	6a 00                	push   $0x0
  801ee6:	6a 00                	push   $0x0
  801ee8:	6a 00                	push   $0x0
  801eea:	6a 00                	push   $0x0
  801eec:	6a 00                	push   $0x0
  801eee:	6a 0e                	push   $0xe
  801ef0:	e8 2d fe ff ff       	call   801d22 <syscall>
  801ef5:	83 c4 18             	add    $0x18,%esp
}
  801ef8:	90                   	nop
  801ef9:	c9                   	leave  
  801efa:	c3                   	ret    

00801efb <sys_disable_interrupt>:

//NEW !! 2012...
void
sys_disable_interrupt()
{
  801efb:	55                   	push   %ebp
  801efc:	89 e5                	mov    %esp,%ebp
	syscall(SYS_disableINTR,0, 0, 0, 0, 0);
  801efe:	6a 00                	push   $0x0
  801f00:	6a 00                	push   $0x0
  801f02:	6a 00                	push   $0x0
  801f04:	6a 00                	push   $0x0
  801f06:	6a 00                	push   $0x0
  801f08:	6a 13                	push   $0x13
  801f0a:	e8 13 fe ff ff       	call   801d22 <syscall>
  801f0f:	83 c4 18             	add    $0x18,%esp
}
  801f12:	90                   	nop
  801f13:	c9                   	leave  
  801f14:	c3                   	ret    

00801f15 <sys_enable_interrupt>:


void
sys_enable_interrupt()
{
  801f15:	55                   	push   %ebp
  801f16:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enableINTR,0, 0, 0, 0, 0);
  801f18:	6a 00                	push   $0x0
  801f1a:	6a 00                	push   $0x0
  801f1c:	6a 00                	push   $0x0
  801f1e:	6a 00                	push   $0x0
  801f20:	6a 00                	push   $0x0
  801f22:	6a 14                	push   $0x14
  801f24:	e8 f9 fd ff ff       	call   801d22 <syscall>
  801f29:	83 c4 18             	add    $0x18,%esp
}
  801f2c:	90                   	nop
  801f2d:	c9                   	leave  
  801f2e:	c3                   	ret    

00801f2f <sys_cputc>:


void
sys_cputc(const char c)
{
  801f2f:	55                   	push   %ebp
  801f30:	89 e5                	mov    %esp,%ebp
  801f32:	83 ec 04             	sub    $0x4,%esp
  801f35:	8b 45 08             	mov    0x8(%ebp),%eax
  801f38:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  801f3b:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801f3f:	6a 00                	push   $0x0
  801f41:	6a 00                	push   $0x0
  801f43:	6a 00                	push   $0x0
  801f45:	6a 00                	push   $0x0
  801f47:	50                   	push   %eax
  801f48:	6a 15                	push   $0x15
  801f4a:	e8 d3 fd ff ff       	call   801d22 <syscall>
  801f4f:	83 c4 18             	add    $0x18,%esp
}
  801f52:	90                   	nop
  801f53:	c9                   	leave  
  801f54:	c3                   	ret    

00801f55 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  801f55:	55                   	push   %ebp
  801f56:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  801f58:	6a 00                	push   $0x0
  801f5a:	6a 00                	push   $0x0
  801f5c:	6a 00                	push   $0x0
  801f5e:	6a 00                	push   $0x0
  801f60:	6a 00                	push   $0x0
  801f62:	6a 16                	push   $0x16
  801f64:	e8 b9 fd ff ff       	call   801d22 <syscall>
  801f69:	83 c4 18             	add    $0x18,%esp
}
  801f6c:	90                   	nop
  801f6d:	c9                   	leave  
  801f6e:	c3                   	ret    

00801f6f <sys_createSemaphore>:

int
sys_createSemaphore(char* semaphoreName, uint32 initialValue)
{
  801f6f:	55                   	push   %ebp
  801f70:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_semaphore,(uint32)semaphoreName, (uint32)initialValue, 0, 0, 0);
  801f72:	8b 45 08             	mov    0x8(%ebp),%eax
  801f75:	6a 00                	push   $0x0
  801f77:	6a 00                	push   $0x0
  801f79:	6a 00                	push   $0x0
  801f7b:	ff 75 0c             	pushl  0xc(%ebp)
  801f7e:	50                   	push   %eax
  801f7f:	6a 17                	push   $0x17
  801f81:	e8 9c fd ff ff       	call   801d22 <syscall>
  801f86:	83 c4 18             	add    $0x18,%esp
}
  801f89:	c9                   	leave  
  801f8a:	c3                   	ret    

00801f8b <sys_getSemaphoreValue>:

int
sys_getSemaphoreValue(int32 ownerEnvID, char* semaphoreName)
{
  801f8b:	55                   	push   %ebp
  801f8c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_semaphore_value,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801f8e:	8b 55 0c             	mov    0xc(%ebp),%edx
  801f91:	8b 45 08             	mov    0x8(%ebp),%eax
  801f94:	6a 00                	push   $0x0
  801f96:	6a 00                	push   $0x0
  801f98:	6a 00                	push   $0x0
  801f9a:	52                   	push   %edx
  801f9b:	50                   	push   %eax
  801f9c:	6a 1a                	push   $0x1a
  801f9e:	e8 7f fd ff ff       	call   801d22 <syscall>
  801fa3:	83 c4 18             	add    $0x18,%esp
}
  801fa6:	c9                   	leave  
  801fa7:	c3                   	ret    

00801fa8 <sys_waitSemaphore>:

void
sys_waitSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801fa8:	55                   	push   %ebp
  801fa9:	89 e5                	mov    %esp,%ebp
	syscall(SYS_wait_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801fab:	8b 55 0c             	mov    0xc(%ebp),%edx
  801fae:	8b 45 08             	mov    0x8(%ebp),%eax
  801fb1:	6a 00                	push   $0x0
  801fb3:	6a 00                	push   $0x0
  801fb5:	6a 00                	push   $0x0
  801fb7:	52                   	push   %edx
  801fb8:	50                   	push   %eax
  801fb9:	6a 18                	push   $0x18
  801fbb:	e8 62 fd ff ff       	call   801d22 <syscall>
  801fc0:	83 c4 18             	add    $0x18,%esp
}
  801fc3:	90                   	nop
  801fc4:	c9                   	leave  
  801fc5:	c3                   	ret    

00801fc6 <sys_signalSemaphore>:

void
sys_signalSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801fc6:	55                   	push   %ebp
  801fc7:	89 e5                	mov    %esp,%ebp
	syscall(SYS_signal_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801fc9:	8b 55 0c             	mov    0xc(%ebp),%edx
  801fcc:	8b 45 08             	mov    0x8(%ebp),%eax
  801fcf:	6a 00                	push   $0x0
  801fd1:	6a 00                	push   $0x0
  801fd3:	6a 00                	push   $0x0
  801fd5:	52                   	push   %edx
  801fd6:	50                   	push   %eax
  801fd7:	6a 19                	push   $0x19
  801fd9:	e8 44 fd ff ff       	call   801d22 <syscall>
  801fde:	83 c4 18             	add    $0x18,%esp
}
  801fe1:	90                   	nop
  801fe2:	c9                   	leave  
  801fe3:	c3                   	ret    

00801fe4 <sys_createSharedObject>:

int
sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  801fe4:	55                   	push   %ebp
  801fe5:	89 e5                	mov    %esp,%ebp
  801fe7:	83 ec 04             	sub    $0x4,%esp
  801fea:	8b 45 10             	mov    0x10(%ebp),%eax
  801fed:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  801ff0:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801ff3:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801ff7:	8b 45 08             	mov    0x8(%ebp),%eax
  801ffa:	6a 00                	push   $0x0
  801ffc:	51                   	push   %ecx
  801ffd:	52                   	push   %edx
  801ffe:	ff 75 0c             	pushl  0xc(%ebp)
  802001:	50                   	push   %eax
  802002:	6a 1b                	push   $0x1b
  802004:	e8 19 fd ff ff       	call   801d22 <syscall>
  802009:	83 c4 18             	add    $0x18,%esp
}
  80200c:	c9                   	leave  
  80200d:	c3                   	ret    

0080200e <sys_getSizeOfSharedObject>:

//2017:
int
sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  80200e:	55                   	push   %ebp
  80200f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  802011:	8b 55 0c             	mov    0xc(%ebp),%edx
  802014:	8b 45 08             	mov    0x8(%ebp),%eax
  802017:	6a 00                	push   $0x0
  802019:	6a 00                	push   $0x0
  80201b:	6a 00                	push   $0x0
  80201d:	52                   	push   %edx
  80201e:	50                   	push   %eax
  80201f:	6a 1c                	push   $0x1c
  802021:	e8 fc fc ff ff       	call   801d22 <syscall>
  802026:	83 c4 18             	add    $0x18,%esp
}
  802029:	c9                   	leave  
  80202a:	c3                   	ret    

0080202b <sys_getSharedObject>:
//==========

int
sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  80202b:	55                   	push   %ebp
  80202c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  80202e:	8b 4d 10             	mov    0x10(%ebp),%ecx
  802031:	8b 55 0c             	mov    0xc(%ebp),%edx
  802034:	8b 45 08             	mov    0x8(%ebp),%eax
  802037:	6a 00                	push   $0x0
  802039:	6a 00                	push   $0x0
  80203b:	51                   	push   %ecx
  80203c:	52                   	push   %edx
  80203d:	50                   	push   %eax
  80203e:	6a 1d                	push   $0x1d
  802040:	e8 dd fc ff ff       	call   801d22 <syscall>
  802045:	83 c4 18             	add    $0x18,%esp
}
  802048:	c9                   	leave  
  802049:	c3                   	ret    

0080204a <sys_freeSharedObject>:

int
sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  80204a:	55                   	push   %ebp
  80204b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  80204d:	8b 55 0c             	mov    0xc(%ebp),%edx
  802050:	8b 45 08             	mov    0x8(%ebp),%eax
  802053:	6a 00                	push   $0x0
  802055:	6a 00                	push   $0x0
  802057:	6a 00                	push   $0x0
  802059:	52                   	push   %edx
  80205a:	50                   	push   %eax
  80205b:	6a 1e                	push   $0x1e
  80205d:	e8 c0 fc ff ff       	call   801d22 <syscall>
  802062:	83 c4 18             	add    $0x18,%esp
}
  802065:	c9                   	leave  
  802066:	c3                   	ret    

00802067 <sys_getMaxShares>:

uint32 	sys_getMaxShares()
{
  802067:	55                   	push   %ebp
  802068:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_max_shares,0, 0, 0, 0, 0);
  80206a:	6a 00                	push   $0x0
  80206c:	6a 00                	push   $0x0
  80206e:	6a 00                	push   $0x0
  802070:	6a 00                	push   $0x0
  802072:	6a 00                	push   $0x0
  802074:	6a 1f                	push   $0x1f
  802076:	e8 a7 fc ff ff       	call   801d22 <syscall>
  80207b:	83 c4 18             	add    $0x18,%esp
}
  80207e:	c9                   	leave  
  80207f:	c3                   	ret    

00802080 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  802080:	55                   	push   %ebp
  802081:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  802083:	8b 45 08             	mov    0x8(%ebp),%eax
  802086:	6a 00                	push   $0x0
  802088:	ff 75 14             	pushl  0x14(%ebp)
  80208b:	ff 75 10             	pushl  0x10(%ebp)
  80208e:	ff 75 0c             	pushl  0xc(%ebp)
  802091:	50                   	push   %eax
  802092:	6a 20                	push   $0x20
  802094:	e8 89 fc ff ff       	call   801d22 <syscall>
  802099:	83 c4 18             	add    $0x18,%esp
}
  80209c:	c9                   	leave  
  80209d:	c3                   	ret    

0080209e <sys_run_env>:

void
sys_run_env(int32 envId)
{
  80209e:	55                   	push   %ebp
  80209f:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  8020a1:	8b 45 08             	mov    0x8(%ebp),%eax
  8020a4:	6a 00                	push   $0x0
  8020a6:	6a 00                	push   $0x0
  8020a8:	6a 00                	push   $0x0
  8020aa:	6a 00                	push   $0x0
  8020ac:	50                   	push   %eax
  8020ad:	6a 21                	push   $0x21
  8020af:	e8 6e fc ff ff       	call   801d22 <syscall>
  8020b4:	83 c4 18             	add    $0x18,%esp
}
  8020b7:	90                   	nop
  8020b8:	c9                   	leave  
  8020b9:	c3                   	ret    

008020ba <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  8020ba:	55                   	push   %ebp
  8020bb:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  8020bd:	8b 45 08             	mov    0x8(%ebp),%eax
  8020c0:	6a 00                	push   $0x0
  8020c2:	6a 00                	push   $0x0
  8020c4:	6a 00                	push   $0x0
  8020c6:	6a 00                	push   $0x0
  8020c8:	50                   	push   %eax
  8020c9:	6a 22                	push   $0x22
  8020cb:	e8 52 fc ff ff       	call   801d22 <syscall>
  8020d0:	83 c4 18             	add    $0x18,%esp
}
  8020d3:	c9                   	leave  
  8020d4:	c3                   	ret    

008020d5 <sys_getenvid>:

int32 sys_getenvid(void)
{
  8020d5:	55                   	push   %ebp
  8020d6:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  8020d8:	6a 00                	push   $0x0
  8020da:	6a 00                	push   $0x0
  8020dc:	6a 00                	push   $0x0
  8020de:	6a 00                	push   $0x0
  8020e0:	6a 00                	push   $0x0
  8020e2:	6a 02                	push   $0x2
  8020e4:	e8 39 fc ff ff       	call   801d22 <syscall>
  8020e9:	83 c4 18             	add    $0x18,%esp
}
  8020ec:	c9                   	leave  
  8020ed:	c3                   	ret    

008020ee <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  8020ee:	55                   	push   %ebp
  8020ef:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  8020f1:	6a 00                	push   $0x0
  8020f3:	6a 00                	push   $0x0
  8020f5:	6a 00                	push   $0x0
  8020f7:	6a 00                	push   $0x0
  8020f9:	6a 00                	push   $0x0
  8020fb:	6a 03                	push   $0x3
  8020fd:	e8 20 fc ff ff       	call   801d22 <syscall>
  802102:	83 c4 18             	add    $0x18,%esp
}
  802105:	c9                   	leave  
  802106:	c3                   	ret    

00802107 <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  802107:	55                   	push   %ebp
  802108:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  80210a:	6a 00                	push   $0x0
  80210c:	6a 00                	push   $0x0
  80210e:	6a 00                	push   $0x0
  802110:	6a 00                	push   $0x0
  802112:	6a 00                	push   $0x0
  802114:	6a 04                	push   $0x4
  802116:	e8 07 fc ff ff       	call   801d22 <syscall>
  80211b:	83 c4 18             	add    $0x18,%esp
}
  80211e:	c9                   	leave  
  80211f:	c3                   	ret    

00802120 <sys_exit_env>:


void sys_exit_env(void)
{
  802120:	55                   	push   %ebp
  802121:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  802123:	6a 00                	push   $0x0
  802125:	6a 00                	push   $0x0
  802127:	6a 00                	push   $0x0
  802129:	6a 00                	push   $0x0
  80212b:	6a 00                	push   $0x0
  80212d:	6a 23                	push   $0x23
  80212f:	e8 ee fb ff ff       	call   801d22 <syscall>
  802134:	83 c4 18             	add    $0x18,%esp
}
  802137:	90                   	nop
  802138:	c9                   	leave  
  802139:	c3                   	ret    

0080213a <sys_get_virtual_time>:


struct uint64
sys_get_virtual_time()
{
  80213a:	55                   	push   %ebp
  80213b:	89 e5                	mov    %esp,%ebp
  80213d:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  802140:	8d 45 f8             	lea    -0x8(%ebp),%eax
  802143:	8d 50 04             	lea    0x4(%eax),%edx
  802146:	8d 45 f8             	lea    -0x8(%ebp),%eax
  802149:	6a 00                	push   $0x0
  80214b:	6a 00                	push   $0x0
  80214d:	6a 00                	push   $0x0
  80214f:	52                   	push   %edx
  802150:	50                   	push   %eax
  802151:	6a 24                	push   $0x24
  802153:	e8 ca fb ff ff       	call   801d22 <syscall>
  802158:	83 c4 18             	add    $0x18,%esp
	return result;
  80215b:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80215e:	8b 45 f8             	mov    -0x8(%ebp),%eax
  802161:	8b 55 fc             	mov    -0x4(%ebp),%edx
  802164:	89 01                	mov    %eax,(%ecx)
  802166:	89 51 04             	mov    %edx,0x4(%ecx)
}
  802169:	8b 45 08             	mov    0x8(%ebp),%eax
  80216c:	c9                   	leave  
  80216d:	c2 04 00             	ret    $0x4

00802170 <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  802170:	55                   	push   %ebp
  802171:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  802173:	6a 00                	push   $0x0
  802175:	6a 00                	push   $0x0
  802177:	ff 75 10             	pushl  0x10(%ebp)
  80217a:	ff 75 0c             	pushl  0xc(%ebp)
  80217d:	ff 75 08             	pushl  0x8(%ebp)
  802180:	6a 12                	push   $0x12
  802182:	e8 9b fb ff ff       	call   801d22 <syscall>
  802187:	83 c4 18             	add    $0x18,%esp
	return ;
  80218a:	90                   	nop
}
  80218b:	c9                   	leave  
  80218c:	c3                   	ret    

0080218d <sys_rcr2>:
uint32 sys_rcr2()
{
  80218d:	55                   	push   %ebp
  80218e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  802190:	6a 00                	push   $0x0
  802192:	6a 00                	push   $0x0
  802194:	6a 00                	push   $0x0
  802196:	6a 00                	push   $0x0
  802198:	6a 00                	push   $0x0
  80219a:	6a 25                	push   $0x25
  80219c:	e8 81 fb ff ff       	call   801d22 <syscall>
  8021a1:	83 c4 18             	add    $0x18,%esp
}
  8021a4:	c9                   	leave  
  8021a5:	c3                   	ret    

008021a6 <sys_bypassPageFault>:
void sys_bypassPageFault(uint8 instrLength)
{
  8021a6:	55                   	push   %ebp
  8021a7:	89 e5                	mov    %esp,%ebp
  8021a9:	83 ec 04             	sub    $0x4,%esp
  8021ac:	8b 45 08             	mov    0x8(%ebp),%eax
  8021af:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  8021b2:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  8021b6:	6a 00                	push   $0x0
  8021b8:	6a 00                	push   $0x0
  8021ba:	6a 00                	push   $0x0
  8021bc:	6a 00                	push   $0x0
  8021be:	50                   	push   %eax
  8021bf:	6a 26                	push   $0x26
  8021c1:	e8 5c fb ff ff       	call   801d22 <syscall>
  8021c6:	83 c4 18             	add    $0x18,%esp
	return ;
  8021c9:	90                   	nop
}
  8021ca:	c9                   	leave  
  8021cb:	c3                   	ret    

008021cc <rsttst>:
void rsttst()
{
  8021cc:	55                   	push   %ebp
  8021cd:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  8021cf:	6a 00                	push   $0x0
  8021d1:	6a 00                	push   $0x0
  8021d3:	6a 00                	push   $0x0
  8021d5:	6a 00                	push   $0x0
  8021d7:	6a 00                	push   $0x0
  8021d9:	6a 28                	push   $0x28
  8021db:	e8 42 fb ff ff       	call   801d22 <syscall>
  8021e0:	83 c4 18             	add    $0x18,%esp
	return ;
  8021e3:	90                   	nop
}
  8021e4:	c9                   	leave  
  8021e5:	c3                   	ret    

008021e6 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  8021e6:	55                   	push   %ebp
  8021e7:	89 e5                	mov    %esp,%ebp
  8021e9:	83 ec 04             	sub    $0x4,%esp
  8021ec:	8b 45 14             	mov    0x14(%ebp),%eax
  8021ef:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  8021f2:	8b 55 18             	mov    0x18(%ebp),%edx
  8021f5:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  8021f9:	52                   	push   %edx
  8021fa:	50                   	push   %eax
  8021fb:	ff 75 10             	pushl  0x10(%ebp)
  8021fe:	ff 75 0c             	pushl  0xc(%ebp)
  802201:	ff 75 08             	pushl  0x8(%ebp)
  802204:	6a 27                	push   $0x27
  802206:	e8 17 fb ff ff       	call   801d22 <syscall>
  80220b:	83 c4 18             	add    $0x18,%esp
	return ;
  80220e:	90                   	nop
}
  80220f:	c9                   	leave  
  802210:	c3                   	ret    

00802211 <chktst>:
void chktst(uint32 n)
{
  802211:	55                   	push   %ebp
  802212:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  802214:	6a 00                	push   $0x0
  802216:	6a 00                	push   $0x0
  802218:	6a 00                	push   $0x0
  80221a:	6a 00                	push   $0x0
  80221c:	ff 75 08             	pushl  0x8(%ebp)
  80221f:	6a 29                	push   $0x29
  802221:	e8 fc fa ff ff       	call   801d22 <syscall>
  802226:	83 c4 18             	add    $0x18,%esp
	return ;
  802229:	90                   	nop
}
  80222a:	c9                   	leave  
  80222b:	c3                   	ret    

0080222c <inctst>:

void inctst()
{
  80222c:	55                   	push   %ebp
  80222d:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  80222f:	6a 00                	push   $0x0
  802231:	6a 00                	push   $0x0
  802233:	6a 00                	push   $0x0
  802235:	6a 00                	push   $0x0
  802237:	6a 00                	push   $0x0
  802239:	6a 2a                	push   $0x2a
  80223b:	e8 e2 fa ff ff       	call   801d22 <syscall>
  802240:	83 c4 18             	add    $0x18,%esp
	return ;
  802243:	90                   	nop
}
  802244:	c9                   	leave  
  802245:	c3                   	ret    

00802246 <gettst>:
uint32 gettst()
{
  802246:	55                   	push   %ebp
  802247:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  802249:	6a 00                	push   $0x0
  80224b:	6a 00                	push   $0x0
  80224d:	6a 00                	push   $0x0
  80224f:	6a 00                	push   $0x0
  802251:	6a 00                	push   $0x0
  802253:	6a 2b                	push   $0x2b
  802255:	e8 c8 fa ff ff       	call   801d22 <syscall>
  80225a:	83 c4 18             	add    $0x18,%esp
}
  80225d:	c9                   	leave  
  80225e:	c3                   	ret    

0080225f <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  80225f:	55                   	push   %ebp
  802260:	89 e5                	mov    %esp,%ebp
  802262:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  802265:	6a 00                	push   $0x0
  802267:	6a 00                	push   $0x0
  802269:	6a 00                	push   $0x0
  80226b:	6a 00                	push   $0x0
  80226d:	6a 00                	push   $0x0
  80226f:	6a 2c                	push   $0x2c
  802271:	e8 ac fa ff ff       	call   801d22 <syscall>
  802276:	83 c4 18             	add    $0x18,%esp
  802279:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  80227c:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  802280:	75 07                	jne    802289 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  802282:	b8 01 00 00 00       	mov    $0x1,%eax
  802287:	eb 05                	jmp    80228e <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  802289:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80228e:	c9                   	leave  
  80228f:	c3                   	ret    

00802290 <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  802290:	55                   	push   %ebp
  802291:	89 e5                	mov    %esp,%ebp
  802293:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  802296:	6a 00                	push   $0x0
  802298:	6a 00                	push   $0x0
  80229a:	6a 00                	push   $0x0
  80229c:	6a 00                	push   $0x0
  80229e:	6a 00                	push   $0x0
  8022a0:	6a 2c                	push   $0x2c
  8022a2:	e8 7b fa ff ff       	call   801d22 <syscall>
  8022a7:	83 c4 18             	add    $0x18,%esp
  8022aa:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  8022ad:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  8022b1:	75 07                	jne    8022ba <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  8022b3:	b8 01 00 00 00       	mov    $0x1,%eax
  8022b8:	eb 05                	jmp    8022bf <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  8022ba:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8022bf:	c9                   	leave  
  8022c0:	c3                   	ret    

008022c1 <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  8022c1:	55                   	push   %ebp
  8022c2:	89 e5                	mov    %esp,%ebp
  8022c4:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8022c7:	6a 00                	push   $0x0
  8022c9:	6a 00                	push   $0x0
  8022cb:	6a 00                	push   $0x0
  8022cd:	6a 00                	push   $0x0
  8022cf:	6a 00                	push   $0x0
  8022d1:	6a 2c                	push   $0x2c
  8022d3:	e8 4a fa ff ff       	call   801d22 <syscall>
  8022d8:	83 c4 18             	add    $0x18,%esp
  8022db:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  8022de:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  8022e2:	75 07                	jne    8022eb <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  8022e4:	b8 01 00 00 00       	mov    $0x1,%eax
  8022e9:	eb 05                	jmp    8022f0 <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  8022eb:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8022f0:	c9                   	leave  
  8022f1:	c3                   	ret    

008022f2 <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  8022f2:	55                   	push   %ebp
  8022f3:	89 e5                	mov    %esp,%ebp
  8022f5:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8022f8:	6a 00                	push   $0x0
  8022fa:	6a 00                	push   $0x0
  8022fc:	6a 00                	push   $0x0
  8022fe:	6a 00                	push   $0x0
  802300:	6a 00                	push   $0x0
  802302:	6a 2c                	push   $0x2c
  802304:	e8 19 fa ff ff       	call   801d22 <syscall>
  802309:	83 c4 18             	add    $0x18,%esp
  80230c:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  80230f:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  802313:	75 07                	jne    80231c <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  802315:	b8 01 00 00 00       	mov    $0x1,%eax
  80231a:	eb 05                	jmp    802321 <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  80231c:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802321:	c9                   	leave  
  802322:	c3                   	ret    

00802323 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  802323:	55                   	push   %ebp
  802324:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  802326:	6a 00                	push   $0x0
  802328:	6a 00                	push   $0x0
  80232a:	6a 00                	push   $0x0
  80232c:	6a 00                	push   $0x0
  80232e:	ff 75 08             	pushl  0x8(%ebp)
  802331:	6a 2d                	push   $0x2d
  802333:	e8 ea f9 ff ff       	call   801d22 <syscall>
  802338:	83 c4 18             	add    $0x18,%esp
	return ;
  80233b:	90                   	nop
}
  80233c:	c9                   	leave  
  80233d:	c3                   	ret    

0080233e <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  80233e:	55                   	push   %ebp
  80233f:	89 e5                	mov    %esp,%ebp
  802341:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  802342:	8b 5d 14             	mov    0x14(%ebp),%ebx
  802345:	8b 4d 10             	mov    0x10(%ebp),%ecx
  802348:	8b 55 0c             	mov    0xc(%ebp),%edx
  80234b:	8b 45 08             	mov    0x8(%ebp),%eax
  80234e:	6a 00                	push   $0x0
  802350:	53                   	push   %ebx
  802351:	51                   	push   %ecx
  802352:	52                   	push   %edx
  802353:	50                   	push   %eax
  802354:	6a 2e                	push   $0x2e
  802356:	e8 c7 f9 ff ff       	call   801d22 <syscall>
  80235b:	83 c4 18             	add    $0x18,%esp
}
  80235e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802361:	c9                   	leave  
  802362:	c3                   	ret    

00802363 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  802363:	55                   	push   %ebp
  802364:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  802366:	8b 55 0c             	mov    0xc(%ebp),%edx
  802369:	8b 45 08             	mov    0x8(%ebp),%eax
  80236c:	6a 00                	push   $0x0
  80236e:	6a 00                	push   $0x0
  802370:	6a 00                	push   $0x0
  802372:	52                   	push   %edx
  802373:	50                   	push   %eax
  802374:	6a 2f                	push   $0x2f
  802376:	e8 a7 f9 ff ff       	call   801d22 <syscall>
  80237b:	83 c4 18             	add    $0x18,%esp
}
  80237e:	c9                   	leave  
  80237f:	c3                   	ret    

00802380 <print_mem_block_lists>:
//===========================
// PRINT MEM BLOCK LISTS:
//===========================

void print_mem_block_lists()
{
  802380:	55                   	push   %ebp
  802381:	89 e5                	mov    %esp,%ebp
  802383:	83 ec 18             	sub    $0x18,%esp
	cprintf("\n=========================================\n");
  802386:	83 ec 0c             	sub    $0xc,%esp
  802389:	68 e0 3d 80 00       	push   $0x803de0
  80238e:	e8 dd e6 ff ff       	call   800a70 <cprintf>
  802393:	83 c4 10             	add    $0x10,%esp
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
  802396:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nFreeMemBlocksList:\n");
  80239d:	83 ec 0c             	sub    $0xc,%esp
  8023a0:	68 0c 3e 80 00       	push   $0x803e0c
  8023a5:	e8 c6 e6 ff ff       	call   800a70 <cprintf>
  8023aa:	83 c4 10             	add    $0x10,%esp
	uint8 sorted = 1 ;
  8023ad:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &FreeMemBlocksList)
  8023b1:	a1 38 41 80 00       	mov    0x804138,%eax
  8023b6:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8023b9:	eb 56                	jmp    802411 <print_mem_block_lists+0x91>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  8023bb:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8023bf:	74 1c                	je     8023dd <print_mem_block_lists+0x5d>
  8023c1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023c4:	8b 50 08             	mov    0x8(%eax),%edx
  8023c7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8023ca:	8b 48 08             	mov    0x8(%eax),%ecx
  8023cd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8023d0:	8b 40 0c             	mov    0xc(%eax),%eax
  8023d3:	01 c8                	add    %ecx,%eax
  8023d5:	39 c2                	cmp    %eax,%edx
  8023d7:	73 04                	jae    8023dd <print_mem_block_lists+0x5d>
			sorted = 0 ;
  8023d9:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  8023dd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023e0:	8b 50 08             	mov    0x8(%eax),%edx
  8023e3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023e6:	8b 40 0c             	mov    0xc(%eax),%eax
  8023e9:	01 c2                	add    %eax,%edx
  8023eb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023ee:	8b 40 08             	mov    0x8(%eax),%eax
  8023f1:	83 ec 04             	sub    $0x4,%esp
  8023f4:	52                   	push   %edx
  8023f5:	50                   	push   %eax
  8023f6:	68 21 3e 80 00       	push   $0x803e21
  8023fb:	e8 70 e6 ff ff       	call   800a70 <cprintf>
  802400:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  802403:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802406:	89 45 f0             	mov    %eax,-0x10(%ebp)
	cprintf("\n=========================================\n");
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
	cprintf("\nFreeMemBlocksList:\n");
	uint8 sorted = 1 ;
	LIST_FOREACH(blk, &FreeMemBlocksList)
  802409:	a1 40 41 80 00       	mov    0x804140,%eax
  80240e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802411:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802415:	74 07                	je     80241e <print_mem_block_lists+0x9e>
  802417:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80241a:	8b 00                	mov    (%eax),%eax
  80241c:	eb 05                	jmp    802423 <print_mem_block_lists+0xa3>
  80241e:	b8 00 00 00 00       	mov    $0x0,%eax
  802423:	a3 40 41 80 00       	mov    %eax,0x804140
  802428:	a1 40 41 80 00       	mov    0x804140,%eax
  80242d:	85 c0                	test   %eax,%eax
  80242f:	75 8a                	jne    8023bb <print_mem_block_lists+0x3b>
  802431:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802435:	75 84                	jne    8023bb <print_mem_block_lists+0x3b>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;
  802437:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  80243b:	75 10                	jne    80244d <print_mem_block_lists+0xcd>
  80243d:	83 ec 0c             	sub    $0xc,%esp
  802440:	68 30 3e 80 00       	push   $0x803e30
  802445:	e8 26 e6 ff ff       	call   800a70 <cprintf>
  80244a:	83 c4 10             	add    $0x10,%esp

	lastBlk = NULL ;
  80244d:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nAllocMemBlocksList:\n");
  802454:	83 ec 0c             	sub    $0xc,%esp
  802457:	68 54 3e 80 00       	push   $0x803e54
  80245c:	e8 0f e6 ff ff       	call   800a70 <cprintf>
  802461:	83 c4 10             	add    $0x10,%esp
	sorted = 1 ;
  802464:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &AllocMemBlocksList)
  802468:	a1 40 40 80 00       	mov    0x804040,%eax
  80246d:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802470:	eb 56                	jmp    8024c8 <print_mem_block_lists+0x148>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  802472:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802476:	74 1c                	je     802494 <print_mem_block_lists+0x114>
  802478:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80247b:	8b 50 08             	mov    0x8(%eax),%edx
  80247e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802481:	8b 48 08             	mov    0x8(%eax),%ecx
  802484:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802487:	8b 40 0c             	mov    0xc(%eax),%eax
  80248a:	01 c8                	add    %ecx,%eax
  80248c:	39 c2                	cmp    %eax,%edx
  80248e:	73 04                	jae    802494 <print_mem_block_lists+0x114>
			sorted = 0 ;
  802490:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  802494:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802497:	8b 50 08             	mov    0x8(%eax),%edx
  80249a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80249d:	8b 40 0c             	mov    0xc(%eax),%eax
  8024a0:	01 c2                	add    %eax,%edx
  8024a2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024a5:	8b 40 08             	mov    0x8(%eax),%eax
  8024a8:	83 ec 04             	sub    $0x4,%esp
  8024ab:	52                   	push   %edx
  8024ac:	50                   	push   %eax
  8024ad:	68 21 3e 80 00       	push   $0x803e21
  8024b2:	e8 b9 e5 ff ff       	call   800a70 <cprintf>
  8024b7:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  8024ba:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024bd:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;

	lastBlk = NULL ;
	cprintf("\nAllocMemBlocksList:\n");
	sorted = 1 ;
	LIST_FOREACH(blk, &AllocMemBlocksList)
  8024c0:	a1 48 40 80 00       	mov    0x804048,%eax
  8024c5:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8024c8:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8024cc:	74 07                	je     8024d5 <print_mem_block_lists+0x155>
  8024ce:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024d1:	8b 00                	mov    (%eax),%eax
  8024d3:	eb 05                	jmp    8024da <print_mem_block_lists+0x15a>
  8024d5:	b8 00 00 00 00       	mov    $0x0,%eax
  8024da:	a3 48 40 80 00       	mov    %eax,0x804048
  8024df:	a1 48 40 80 00       	mov    0x804048,%eax
  8024e4:	85 c0                	test   %eax,%eax
  8024e6:	75 8a                	jne    802472 <print_mem_block_lists+0xf2>
  8024e8:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8024ec:	75 84                	jne    802472 <print_mem_block_lists+0xf2>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nAllocMemBlocksList is NOT SORTED!!\n") ;
  8024ee:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  8024f2:	75 10                	jne    802504 <print_mem_block_lists+0x184>
  8024f4:	83 ec 0c             	sub    $0xc,%esp
  8024f7:	68 6c 3e 80 00       	push   $0x803e6c
  8024fc:	e8 6f e5 ff ff       	call   800a70 <cprintf>
  802501:	83 c4 10             	add    $0x10,%esp
	cprintf("\n=========================================\n");
  802504:	83 ec 0c             	sub    $0xc,%esp
  802507:	68 e0 3d 80 00       	push   $0x803de0
  80250c:	e8 5f e5 ff ff       	call   800a70 <cprintf>
  802511:	83 c4 10             	add    $0x10,%esp

}
  802514:	90                   	nop
  802515:	c9                   	leave  
  802516:	c3                   	ret    

00802517 <initialize_MemBlocksList>:

//===============================
// [1] INITIALIZE AVAILABLE LIST:
//===============================
void initialize_MemBlocksList(uint32 numOfBlocks)
{
  802517:	55                   	push   %ebp
  802518:	89 e5                	mov    %esp,%ebp
  80251a:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] initialize_MemBlocksList
	// Write your code here, remove the panic and write your code
	//panic("initialize_MemBlocksList() is not implemented yet...!!");
	uint32 n = numOfBlocks;
  80251d:	8b 45 08             	mov    0x8(%ebp),%eax
  802520:	89 45 f0             	mov    %eax,-0x10(%ebp)

	LIST_INIT(&AvailableMemBlocksList);
  802523:	c7 05 48 41 80 00 00 	movl   $0x0,0x804148
  80252a:	00 00 00 
  80252d:	c7 05 4c 41 80 00 00 	movl   $0x0,0x80414c
  802534:	00 00 00 
  802537:	c7 05 54 41 80 00 00 	movl   $0x0,0x804154
  80253e:	00 00 00 
	for(int i = 0; i<n;i++)
  802541:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  802548:	e9 9e 00 00 00       	jmp    8025eb <initialize_MemBlocksList+0xd4>
	{
		LIST_INSERT_HEAD(&AvailableMemBlocksList, &(MemBlockNodes[i]));
  80254d:	a1 50 40 80 00       	mov    0x804050,%eax
  802552:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802555:	c1 e2 04             	shl    $0x4,%edx
  802558:	01 d0                	add    %edx,%eax
  80255a:	85 c0                	test   %eax,%eax
  80255c:	75 14                	jne    802572 <initialize_MemBlocksList+0x5b>
  80255e:	83 ec 04             	sub    $0x4,%esp
  802561:	68 94 3e 80 00       	push   $0x803e94
  802566:	6a 47                	push   $0x47
  802568:	68 b7 3e 80 00       	push   $0x803eb7
  80256d:	e8 4a e2 ff ff       	call   8007bc <_panic>
  802572:	a1 50 40 80 00       	mov    0x804050,%eax
  802577:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80257a:	c1 e2 04             	shl    $0x4,%edx
  80257d:	01 d0                	add    %edx,%eax
  80257f:	8b 15 48 41 80 00    	mov    0x804148,%edx
  802585:	89 10                	mov    %edx,(%eax)
  802587:	8b 00                	mov    (%eax),%eax
  802589:	85 c0                	test   %eax,%eax
  80258b:	74 18                	je     8025a5 <initialize_MemBlocksList+0x8e>
  80258d:	a1 48 41 80 00       	mov    0x804148,%eax
  802592:	8b 15 50 40 80 00    	mov    0x804050,%edx
  802598:	8b 4d f4             	mov    -0xc(%ebp),%ecx
  80259b:	c1 e1 04             	shl    $0x4,%ecx
  80259e:	01 ca                	add    %ecx,%edx
  8025a0:	89 50 04             	mov    %edx,0x4(%eax)
  8025a3:	eb 12                	jmp    8025b7 <initialize_MemBlocksList+0xa0>
  8025a5:	a1 50 40 80 00       	mov    0x804050,%eax
  8025aa:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8025ad:	c1 e2 04             	shl    $0x4,%edx
  8025b0:	01 d0                	add    %edx,%eax
  8025b2:	a3 4c 41 80 00       	mov    %eax,0x80414c
  8025b7:	a1 50 40 80 00       	mov    0x804050,%eax
  8025bc:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8025bf:	c1 e2 04             	shl    $0x4,%edx
  8025c2:	01 d0                	add    %edx,%eax
  8025c4:	a3 48 41 80 00       	mov    %eax,0x804148
  8025c9:	a1 50 40 80 00       	mov    0x804050,%eax
  8025ce:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8025d1:	c1 e2 04             	shl    $0x4,%edx
  8025d4:	01 d0                	add    %edx,%eax
  8025d6:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8025dd:	a1 54 41 80 00       	mov    0x804154,%eax
  8025e2:	40                   	inc    %eax
  8025e3:	a3 54 41 80 00       	mov    %eax,0x804154
	// Write your code here, remove the panic and write your code
	//panic("initialize_MemBlocksList() is not implemented yet...!!");
	uint32 n = numOfBlocks;

	LIST_INIT(&AvailableMemBlocksList);
	for(int i = 0; i<n;i++)
  8025e8:	ff 45 f4             	incl   -0xc(%ebp)
  8025eb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025ee:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8025f1:	0f 82 56 ff ff ff    	jb     80254d <initialize_MemBlocksList+0x36>
	{
		LIST_INSERT_HEAD(&AvailableMemBlocksList, &(MemBlockNodes[i]));
	}
}
  8025f7:	90                   	nop
  8025f8:	c9                   	leave  
  8025f9:	c3                   	ret    

008025fa <find_block>:

//===============================
// [2] FIND BLOCK:
//===============================
struct MemBlock *find_block(struct MemBlock_List *blockList, uint32 va)
{
  8025fa:	55                   	push   %ebp
  8025fb:	89 e5                	mov    %esp,%ebp
  8025fd:	83 ec 10             	sub    $0x10,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] find_block
	// Write your code here, remove the panic and write your code
	//panic("find_block() is not implemented yet...!!");
	uint32 virAddress = va;
  802600:	8b 45 0c             	mov    0xc(%ebp),%eax
  802603:	89 45 f4             	mov    %eax,-0xc(%ebp)
	struct MemBlock* blk;
	int found = 0;
  802606:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	LIST_FOREACH(blk, &(AllocMemBlocksList))
  80260d:	a1 40 40 80 00       	mov    0x804040,%eax
  802612:	89 45 fc             	mov    %eax,-0x4(%ebp)
  802615:	eb 23                	jmp    80263a <find_block+0x40>
	{
		if(blk->sva == virAddress)
  802617:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80261a:	8b 40 08             	mov    0x8(%eax),%eax
  80261d:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  802620:	75 09                	jne    80262b <find_block+0x31>
		{
			found = 1;
  802622:	c7 45 f8 01 00 00 00 	movl   $0x1,-0x8(%ebp)
			break;
  802629:	eb 35                	jmp    802660 <find_block+0x66>
		}
		else
		{
			found = 0;
  80262b:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	//panic("find_block() is not implemented yet...!!");
	uint32 virAddress = va;
	struct MemBlock* blk;
	int found = 0;

	LIST_FOREACH(blk, &(AllocMemBlocksList))
  802632:	a1 48 40 80 00       	mov    0x804048,%eax
  802637:	89 45 fc             	mov    %eax,-0x4(%ebp)
  80263a:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  80263e:	74 07                	je     802647 <find_block+0x4d>
  802640:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802643:	8b 00                	mov    (%eax),%eax
  802645:	eb 05                	jmp    80264c <find_block+0x52>
  802647:	b8 00 00 00 00       	mov    $0x0,%eax
  80264c:	a3 48 40 80 00       	mov    %eax,0x804048
  802651:	a1 48 40 80 00       	mov    0x804048,%eax
  802656:	85 c0                	test   %eax,%eax
  802658:	75 bd                	jne    802617 <find_block+0x1d>
  80265a:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  80265e:	75 b7                	jne    802617 <find_block+0x1d>
		{
			found = 0;
			continue;
		}
	}
	if(found == 1)
  802660:	83 7d f8 01          	cmpl   $0x1,-0x8(%ebp)
  802664:	75 05                	jne    80266b <find_block+0x71>
	{
		return blk;
  802666:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802669:	eb 05                	jmp    802670 <find_block+0x76>
	}
	else
	{
		return NULL;
  80266b:	b8 00 00 00 00       	mov    $0x0,%eax
	}
}
  802670:	c9                   	leave  
  802671:	c3                   	ret    

00802672 <insert_sorted_allocList>:

//=========================================
// [3] INSERT BLOCK IN ALLOC LIST [SORTED]:
//=========================================
void insert_sorted_allocList(struct MemBlock *blockToInsert)
{
  802672:	55                   	push   %ebp
  802673:	89 e5                	mov    %esp,%ebp
  802675:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] insert_sorted_allocList
	// Write your code here, remove the panic and write your code
	//panic("insert_sorted_allocList() is not implemented yet...!!");
	struct MemBlock* blk;
	struct MemBlock* newblk = blockToInsert;
  802678:	8b 45 08             	mov    0x8(%ebp),%eax
  80267b:	89 45 f0             	mov    %eax,-0x10(%ebp)

	if((LIST_EMPTY(&AllocMemBlocksList)) || (newblk->sva < LIST_FIRST(&AllocMemBlocksList)->sva))
  80267e:	a1 40 40 80 00       	mov    0x804040,%eax
  802683:	85 c0                	test   %eax,%eax
  802685:	74 12                	je     802699 <insert_sorted_allocList+0x27>
  802687:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80268a:	8b 50 08             	mov    0x8(%eax),%edx
  80268d:	a1 40 40 80 00       	mov    0x804040,%eax
  802692:	8b 40 08             	mov    0x8(%eax),%eax
  802695:	39 c2                	cmp    %eax,%edx
  802697:	73 65                	jae    8026fe <insert_sorted_allocList+0x8c>
	{
		LIST_INSERT_HEAD(&(AllocMemBlocksList), newblk);
  802699:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80269d:	75 14                	jne    8026b3 <insert_sorted_allocList+0x41>
  80269f:	83 ec 04             	sub    $0x4,%esp
  8026a2:	68 94 3e 80 00       	push   $0x803e94
  8026a7:	6a 7b                	push   $0x7b
  8026a9:	68 b7 3e 80 00       	push   $0x803eb7
  8026ae:	e8 09 e1 ff ff       	call   8007bc <_panic>
  8026b3:	8b 15 40 40 80 00    	mov    0x804040,%edx
  8026b9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8026bc:	89 10                	mov    %edx,(%eax)
  8026be:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8026c1:	8b 00                	mov    (%eax),%eax
  8026c3:	85 c0                	test   %eax,%eax
  8026c5:	74 0d                	je     8026d4 <insert_sorted_allocList+0x62>
  8026c7:	a1 40 40 80 00       	mov    0x804040,%eax
  8026cc:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8026cf:	89 50 04             	mov    %edx,0x4(%eax)
  8026d2:	eb 08                	jmp    8026dc <insert_sorted_allocList+0x6a>
  8026d4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8026d7:	a3 44 40 80 00       	mov    %eax,0x804044
  8026dc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8026df:	a3 40 40 80 00       	mov    %eax,0x804040
  8026e4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8026e7:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8026ee:	a1 4c 40 80 00       	mov    0x80404c,%eax
  8026f3:	40                   	inc    %eax
  8026f4:	a3 4c 40 80 00       	mov    %eax,0x80404c
  8026f9:	e9 5f 01 00 00       	jmp    80285d <insert_sorted_allocList+0x1eb>
	}
	else if(newblk->sva > LIST_LAST(&AllocMemBlocksList)->sva)
  8026fe:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802701:	8b 50 08             	mov    0x8(%eax),%edx
  802704:	a1 44 40 80 00       	mov    0x804044,%eax
  802709:	8b 40 08             	mov    0x8(%eax),%eax
  80270c:	39 c2                	cmp    %eax,%edx
  80270e:	76 65                	jbe    802775 <insert_sorted_allocList+0x103>
	{
		LIST_INSERT_TAIL(&AllocMemBlocksList, newblk);
  802710:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802714:	75 14                	jne    80272a <insert_sorted_allocList+0xb8>
  802716:	83 ec 04             	sub    $0x4,%esp
  802719:	68 d0 3e 80 00       	push   $0x803ed0
  80271e:	6a 7f                	push   $0x7f
  802720:	68 b7 3e 80 00       	push   $0x803eb7
  802725:	e8 92 e0 ff ff       	call   8007bc <_panic>
  80272a:	8b 15 44 40 80 00    	mov    0x804044,%edx
  802730:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802733:	89 50 04             	mov    %edx,0x4(%eax)
  802736:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802739:	8b 40 04             	mov    0x4(%eax),%eax
  80273c:	85 c0                	test   %eax,%eax
  80273e:	74 0c                	je     80274c <insert_sorted_allocList+0xda>
  802740:	a1 44 40 80 00       	mov    0x804044,%eax
  802745:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802748:	89 10                	mov    %edx,(%eax)
  80274a:	eb 08                	jmp    802754 <insert_sorted_allocList+0xe2>
  80274c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80274f:	a3 40 40 80 00       	mov    %eax,0x804040
  802754:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802757:	a3 44 40 80 00       	mov    %eax,0x804044
  80275c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80275f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802765:	a1 4c 40 80 00       	mov    0x80404c,%eax
  80276a:	40                   	inc    %eax
  80276b:	a3 4c 40 80 00       	mov    %eax,0x80404c
				LIST_INSERT_AFTER(&AllocMemBlocksList, blk, newblk);
				break;
			}
		}
	}
}
  802770:	e9 e8 00 00 00       	jmp    80285d <insert_sorted_allocList+0x1eb>
	{
		LIST_INSERT_TAIL(&AllocMemBlocksList, newblk);
	}
	else
	{
		LIST_FOREACH(blk, &AllocMemBlocksList)
  802775:	a1 40 40 80 00       	mov    0x804040,%eax
  80277a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80277d:	e9 ab 00 00 00       	jmp    80282d <insert_sorted_allocList+0x1bb>
		{
			if(blk->prev_next_info.le_next != NULL && newblk->sva > blk->sva  && newblk->sva < blk->prev_next_info.le_next->sva)
  802782:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802785:	8b 00                	mov    (%eax),%eax
  802787:	85 c0                	test   %eax,%eax
  802789:	0f 84 96 00 00 00    	je     802825 <insert_sorted_allocList+0x1b3>
  80278f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802792:	8b 50 08             	mov    0x8(%eax),%edx
  802795:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802798:	8b 40 08             	mov    0x8(%eax),%eax
  80279b:	39 c2                	cmp    %eax,%edx
  80279d:	0f 86 82 00 00 00    	jbe    802825 <insert_sorted_allocList+0x1b3>
  8027a3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8027a6:	8b 50 08             	mov    0x8(%eax),%edx
  8027a9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027ac:	8b 00                	mov    (%eax),%eax
  8027ae:	8b 40 08             	mov    0x8(%eax),%eax
  8027b1:	39 c2                	cmp    %eax,%edx
  8027b3:	73 70                	jae    802825 <insert_sorted_allocList+0x1b3>
			{
				LIST_INSERT_AFTER(&AllocMemBlocksList, blk, newblk);
  8027b5:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8027b9:	74 06                	je     8027c1 <insert_sorted_allocList+0x14f>
  8027bb:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8027bf:	75 17                	jne    8027d8 <insert_sorted_allocList+0x166>
  8027c1:	83 ec 04             	sub    $0x4,%esp
  8027c4:	68 f4 3e 80 00       	push   $0x803ef4
  8027c9:	68 87 00 00 00       	push   $0x87
  8027ce:	68 b7 3e 80 00       	push   $0x803eb7
  8027d3:	e8 e4 df ff ff       	call   8007bc <_panic>
  8027d8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027db:	8b 10                	mov    (%eax),%edx
  8027dd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8027e0:	89 10                	mov    %edx,(%eax)
  8027e2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8027e5:	8b 00                	mov    (%eax),%eax
  8027e7:	85 c0                	test   %eax,%eax
  8027e9:	74 0b                	je     8027f6 <insert_sorted_allocList+0x184>
  8027eb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027ee:	8b 00                	mov    (%eax),%eax
  8027f0:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8027f3:	89 50 04             	mov    %edx,0x4(%eax)
  8027f6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027f9:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8027fc:	89 10                	mov    %edx,(%eax)
  8027fe:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802801:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802804:	89 50 04             	mov    %edx,0x4(%eax)
  802807:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80280a:	8b 00                	mov    (%eax),%eax
  80280c:	85 c0                	test   %eax,%eax
  80280e:	75 08                	jne    802818 <insert_sorted_allocList+0x1a6>
  802810:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802813:	a3 44 40 80 00       	mov    %eax,0x804044
  802818:	a1 4c 40 80 00       	mov    0x80404c,%eax
  80281d:	40                   	inc    %eax
  80281e:	a3 4c 40 80 00       	mov    %eax,0x80404c
				break;
  802823:	eb 38                	jmp    80285d <insert_sorted_allocList+0x1eb>
	{
		LIST_INSERT_TAIL(&AllocMemBlocksList, newblk);
	}
	else
	{
		LIST_FOREACH(blk, &AllocMemBlocksList)
  802825:	a1 48 40 80 00       	mov    0x804048,%eax
  80282a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80282d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802831:	74 07                	je     80283a <insert_sorted_allocList+0x1c8>
  802833:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802836:	8b 00                	mov    (%eax),%eax
  802838:	eb 05                	jmp    80283f <insert_sorted_allocList+0x1cd>
  80283a:	b8 00 00 00 00       	mov    $0x0,%eax
  80283f:	a3 48 40 80 00       	mov    %eax,0x804048
  802844:	a1 48 40 80 00       	mov    0x804048,%eax
  802849:	85 c0                	test   %eax,%eax
  80284b:	0f 85 31 ff ff ff    	jne    802782 <insert_sorted_allocList+0x110>
  802851:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802855:	0f 85 27 ff ff ff    	jne    802782 <insert_sorted_allocList+0x110>
				LIST_INSERT_AFTER(&AllocMemBlocksList, blk, newblk);
				break;
			}
		}
	}
}
  80285b:	eb 00                	jmp    80285d <insert_sorted_allocList+0x1eb>
  80285d:	90                   	nop
  80285e:	c9                   	leave  
  80285f:	c3                   	ret    

00802860 <alloc_block_FF>:

//=========================================
// [4] ALLOCATE BLOCK BY FIRST FIT:
//=========================================
struct MemBlock *alloc_block_FF(uint32 size)
{
  802860:	55                   	push   %ebp
  802861:	89 e5                	mov    %esp,%ebp
  802863:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_FF
	// Write your code here, remove the panic and write your code
	//panic("alloc_block_FF() is not implemented yet...!!");
	uint32 versize = size;
  802866:	8b 45 08             	mov    0x8(%ebp),%eax
  802869:	89 45 f0             	mov    %eax,-0x10(%ebp)
	struct MemBlock* blk;
	struct MemBlock* newblk = LIST_FIRST(&AvailableMemBlocksList);
  80286c:	a1 48 41 80 00       	mov    0x804148,%eax
  802871:	89 45 ec             	mov    %eax,-0x14(%ebp)

	LIST_FOREACH(blk,&FreeMemBlocksList)
  802874:	a1 38 41 80 00       	mov    0x804138,%eax
  802879:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80287c:	e9 77 01 00 00       	jmp    8029f8 <alloc_block_FF+0x198>
	{
		if(blk->size == versize)
  802881:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802884:	8b 40 0c             	mov    0xc(%eax),%eax
  802887:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80288a:	0f 85 8a 00 00 00    	jne    80291a <alloc_block_FF+0xba>
		{
			LIST_REMOVE(&FreeMemBlocksList,blk);
  802890:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802894:	75 17                	jne    8028ad <alloc_block_FF+0x4d>
  802896:	83 ec 04             	sub    $0x4,%esp
  802899:	68 28 3f 80 00       	push   $0x803f28
  80289e:	68 9e 00 00 00       	push   $0x9e
  8028a3:	68 b7 3e 80 00       	push   $0x803eb7
  8028a8:	e8 0f df ff ff       	call   8007bc <_panic>
  8028ad:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028b0:	8b 00                	mov    (%eax),%eax
  8028b2:	85 c0                	test   %eax,%eax
  8028b4:	74 10                	je     8028c6 <alloc_block_FF+0x66>
  8028b6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028b9:	8b 00                	mov    (%eax),%eax
  8028bb:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8028be:	8b 52 04             	mov    0x4(%edx),%edx
  8028c1:	89 50 04             	mov    %edx,0x4(%eax)
  8028c4:	eb 0b                	jmp    8028d1 <alloc_block_FF+0x71>
  8028c6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028c9:	8b 40 04             	mov    0x4(%eax),%eax
  8028cc:	a3 3c 41 80 00       	mov    %eax,0x80413c
  8028d1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028d4:	8b 40 04             	mov    0x4(%eax),%eax
  8028d7:	85 c0                	test   %eax,%eax
  8028d9:	74 0f                	je     8028ea <alloc_block_FF+0x8a>
  8028db:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028de:	8b 40 04             	mov    0x4(%eax),%eax
  8028e1:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8028e4:	8b 12                	mov    (%edx),%edx
  8028e6:	89 10                	mov    %edx,(%eax)
  8028e8:	eb 0a                	jmp    8028f4 <alloc_block_FF+0x94>
  8028ea:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028ed:	8b 00                	mov    (%eax),%eax
  8028ef:	a3 38 41 80 00       	mov    %eax,0x804138
  8028f4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028f7:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8028fd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802900:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802907:	a1 44 41 80 00       	mov    0x804144,%eax
  80290c:	48                   	dec    %eax
  80290d:	a3 44 41 80 00       	mov    %eax,0x804144
			return blk;
  802912:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802915:	e9 11 01 00 00       	jmp    802a2b <alloc_block_FF+0x1cb>
		}
		else if(blk->size > versize)
  80291a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80291d:	8b 40 0c             	mov    0xc(%eax),%eax
  802920:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  802923:	0f 86 c7 00 00 00    	jbe    8029f0 <alloc_block_FF+0x190>
		{
			LIST_REMOVE(&AvailableMemBlocksList,newblk);
  802929:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  80292d:	75 17                	jne    802946 <alloc_block_FF+0xe6>
  80292f:	83 ec 04             	sub    $0x4,%esp
  802932:	68 28 3f 80 00       	push   $0x803f28
  802937:	68 a3 00 00 00       	push   $0xa3
  80293c:	68 b7 3e 80 00       	push   $0x803eb7
  802941:	e8 76 de ff ff       	call   8007bc <_panic>
  802946:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802949:	8b 00                	mov    (%eax),%eax
  80294b:	85 c0                	test   %eax,%eax
  80294d:	74 10                	je     80295f <alloc_block_FF+0xff>
  80294f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802952:	8b 00                	mov    (%eax),%eax
  802954:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802957:	8b 52 04             	mov    0x4(%edx),%edx
  80295a:	89 50 04             	mov    %edx,0x4(%eax)
  80295d:	eb 0b                	jmp    80296a <alloc_block_FF+0x10a>
  80295f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802962:	8b 40 04             	mov    0x4(%eax),%eax
  802965:	a3 4c 41 80 00       	mov    %eax,0x80414c
  80296a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80296d:	8b 40 04             	mov    0x4(%eax),%eax
  802970:	85 c0                	test   %eax,%eax
  802972:	74 0f                	je     802983 <alloc_block_FF+0x123>
  802974:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802977:	8b 40 04             	mov    0x4(%eax),%eax
  80297a:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80297d:	8b 12                	mov    (%edx),%edx
  80297f:	89 10                	mov    %edx,(%eax)
  802981:	eb 0a                	jmp    80298d <alloc_block_FF+0x12d>
  802983:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802986:	8b 00                	mov    (%eax),%eax
  802988:	a3 48 41 80 00       	mov    %eax,0x804148
  80298d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802990:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802996:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802999:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8029a0:	a1 54 41 80 00       	mov    0x804154,%eax
  8029a5:	48                   	dec    %eax
  8029a6:	a3 54 41 80 00       	mov    %eax,0x804154
			newblk->size = versize;
  8029ab:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8029ae:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8029b1:	89 50 0c             	mov    %edx,0xc(%eax)
			blk->size = blk->size-versize;
  8029b4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029b7:	8b 40 0c             	mov    0xc(%eax),%eax
  8029ba:	2b 45 f0             	sub    -0x10(%ebp),%eax
  8029bd:	89 c2                	mov    %eax,%edx
  8029bf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029c2:	89 50 0c             	mov    %edx,0xc(%eax)
			uint32 newveradd = blk->sva;
  8029c5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029c8:	8b 40 08             	mov    0x8(%eax),%eax
  8029cb:	89 45 e8             	mov    %eax,-0x18(%ebp)
			blk->sva+=newblk->size;
  8029ce:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029d1:	8b 50 08             	mov    0x8(%eax),%edx
  8029d4:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8029d7:	8b 40 0c             	mov    0xc(%eax),%eax
  8029da:	01 c2                	add    %eax,%edx
  8029dc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029df:	89 50 08             	mov    %edx,0x8(%eax)
			newblk->sva = newveradd;
  8029e2:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8029e5:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8029e8:	89 50 08             	mov    %edx,0x8(%eax)
			return newblk;
  8029eb:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8029ee:	eb 3b                	jmp    802a2b <alloc_block_FF+0x1cb>
	//panic("alloc_block_FF() is not implemented yet...!!");
	uint32 versize = size;
	struct MemBlock* blk;
	struct MemBlock* newblk = LIST_FIRST(&AvailableMemBlocksList);

	LIST_FOREACH(blk,&FreeMemBlocksList)
  8029f0:	a1 40 41 80 00       	mov    0x804140,%eax
  8029f5:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8029f8:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8029fc:	74 07                	je     802a05 <alloc_block_FF+0x1a5>
  8029fe:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a01:	8b 00                	mov    (%eax),%eax
  802a03:	eb 05                	jmp    802a0a <alloc_block_FF+0x1aa>
  802a05:	b8 00 00 00 00       	mov    $0x0,%eax
  802a0a:	a3 40 41 80 00       	mov    %eax,0x804140
  802a0f:	a1 40 41 80 00       	mov    0x804140,%eax
  802a14:	85 c0                	test   %eax,%eax
  802a16:	0f 85 65 fe ff ff    	jne    802881 <alloc_block_FF+0x21>
  802a1c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802a20:	0f 85 5b fe ff ff    	jne    802881 <alloc_block_FF+0x21>
			blk->sva+=newblk->size;
			newblk->sva = newveradd;
			return newblk;
		}
	}
	return NULL;
  802a26:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802a2b:	c9                   	leave  
  802a2c:	c3                   	ret    

00802a2d <alloc_block_BF>:

//=========================================
// [5] ALLOCATE BLOCK BY BEST FIT:
//=========================================
struct MemBlock *alloc_block_BF(uint32 size)
{
  802a2d:	55                   	push   %ebp
  802a2e:	89 e5                	mov    %esp,%ebp
  802a30:	83 ec 28             	sub    $0x28,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_BF
	// Write your code here, remove the panic and write your code
	//panic("alloc_block_BF() is not implemented yet...!!");
	uint32 versize=size;
  802a33:	8b 45 08             	mov    0x8(%ebp),%eax
  802a36:	89 45 e8             	mov    %eax,-0x18(%ebp)
	struct MemBlock* blk;
	struct MemBlock* newblk=LIST_FIRST(&AvailableMemBlocksList);
  802a39:	a1 48 41 80 00       	mov    0x804148,%eax
  802a3e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	uint32 newveradd;
	uint32 newsize;
	int size_free = LIST_SIZE(&FreeMemBlocksList);
  802a41:	a1 44 41 80 00       	mov    0x804144,%eax
  802a46:	89 45 e0             	mov    %eax,-0x20(%ebp)

	LIST_FOREACH(blk, &FreeMemBlocksList)
  802a49:	a1 38 41 80 00       	mov    0x804138,%eax
  802a4e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802a51:	e9 a1 00 00 00       	jmp    802af7 <alloc_block_BF+0xca>
	{
		if(blk->size == versize)
  802a56:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a59:	8b 40 0c             	mov    0xc(%eax),%eax
  802a5c:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  802a5f:	0f 85 8a 00 00 00    	jne    802aef <alloc_block_BF+0xc2>
		{
			LIST_REMOVE(&FreeMemBlocksList, blk);
  802a65:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802a69:	75 17                	jne    802a82 <alloc_block_BF+0x55>
  802a6b:	83 ec 04             	sub    $0x4,%esp
  802a6e:	68 28 3f 80 00       	push   $0x803f28
  802a73:	68 c2 00 00 00       	push   $0xc2
  802a78:	68 b7 3e 80 00       	push   $0x803eb7
  802a7d:	e8 3a dd ff ff       	call   8007bc <_panic>
  802a82:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a85:	8b 00                	mov    (%eax),%eax
  802a87:	85 c0                	test   %eax,%eax
  802a89:	74 10                	je     802a9b <alloc_block_BF+0x6e>
  802a8b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a8e:	8b 00                	mov    (%eax),%eax
  802a90:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802a93:	8b 52 04             	mov    0x4(%edx),%edx
  802a96:	89 50 04             	mov    %edx,0x4(%eax)
  802a99:	eb 0b                	jmp    802aa6 <alloc_block_BF+0x79>
  802a9b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a9e:	8b 40 04             	mov    0x4(%eax),%eax
  802aa1:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802aa6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802aa9:	8b 40 04             	mov    0x4(%eax),%eax
  802aac:	85 c0                	test   %eax,%eax
  802aae:	74 0f                	je     802abf <alloc_block_BF+0x92>
  802ab0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ab3:	8b 40 04             	mov    0x4(%eax),%eax
  802ab6:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802ab9:	8b 12                	mov    (%edx),%edx
  802abb:	89 10                	mov    %edx,(%eax)
  802abd:	eb 0a                	jmp    802ac9 <alloc_block_BF+0x9c>
  802abf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ac2:	8b 00                	mov    (%eax),%eax
  802ac4:	a3 38 41 80 00       	mov    %eax,0x804138
  802ac9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802acc:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802ad2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ad5:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802adc:	a1 44 41 80 00       	mov    0x804144,%eax
  802ae1:	48                   	dec    %eax
  802ae2:	a3 44 41 80 00       	mov    %eax,0x804144
			return blk;
  802ae7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802aea:	e9 11 02 00 00       	jmp    802d00 <alloc_block_BF+0x2d3>
	struct MemBlock* newblk=LIST_FIRST(&AvailableMemBlocksList);
	uint32 newveradd;
	uint32 newsize;
	int size_free = LIST_SIZE(&FreeMemBlocksList);

	LIST_FOREACH(blk, &FreeMemBlocksList)
  802aef:	a1 40 41 80 00       	mov    0x804140,%eax
  802af4:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802af7:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802afb:	74 07                	je     802b04 <alloc_block_BF+0xd7>
  802afd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b00:	8b 00                	mov    (%eax),%eax
  802b02:	eb 05                	jmp    802b09 <alloc_block_BF+0xdc>
  802b04:	b8 00 00 00 00       	mov    $0x0,%eax
  802b09:	a3 40 41 80 00       	mov    %eax,0x804140
  802b0e:	a1 40 41 80 00       	mov    0x804140,%eax
  802b13:	85 c0                	test   %eax,%eax
  802b15:	0f 85 3b ff ff ff    	jne    802a56 <alloc_block_BF+0x29>
  802b1b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802b1f:	0f 85 31 ff ff ff    	jne    802a56 <alloc_block_BF+0x29>
		{
			LIST_REMOVE(&FreeMemBlocksList, blk);
			return blk;
		}
	}
	LIST_FOREACH(blk, &FreeMemBlocksList)
  802b25:	a1 38 41 80 00       	mov    0x804138,%eax
  802b2a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802b2d:	eb 27                	jmp    802b56 <alloc_block_BF+0x129>
	{
		if(blk->size > versize)
  802b2f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b32:	8b 40 0c             	mov    0xc(%eax),%eax
  802b35:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  802b38:	76 14                	jbe    802b4e <alloc_block_BF+0x121>
		{
			newsize = blk->size;
  802b3a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b3d:	8b 40 0c             	mov    0xc(%eax),%eax
  802b40:	89 45 ec             	mov    %eax,-0x14(%ebp)
			newveradd = blk->sva;
  802b43:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b46:	8b 40 08             	mov    0x8(%eax),%eax
  802b49:	89 45 f0             	mov    %eax,-0x10(%ebp)
			break;
  802b4c:	eb 2e                	jmp    802b7c <alloc_block_BF+0x14f>
		{
			LIST_REMOVE(&FreeMemBlocksList, blk);
			return blk;
		}
	}
	LIST_FOREACH(blk, &FreeMemBlocksList)
  802b4e:	a1 40 41 80 00       	mov    0x804140,%eax
  802b53:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802b56:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802b5a:	74 07                	je     802b63 <alloc_block_BF+0x136>
  802b5c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b5f:	8b 00                	mov    (%eax),%eax
  802b61:	eb 05                	jmp    802b68 <alloc_block_BF+0x13b>
  802b63:	b8 00 00 00 00       	mov    $0x0,%eax
  802b68:	a3 40 41 80 00       	mov    %eax,0x804140
  802b6d:	a1 40 41 80 00       	mov    0x804140,%eax
  802b72:	85 c0                	test   %eax,%eax
  802b74:	75 b9                	jne    802b2f <alloc_block_BF+0x102>
  802b76:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802b7a:	75 b3                	jne    802b2f <alloc_block_BF+0x102>
			newsize = blk->size;
			newveradd = blk->sva;
			break;
		}
	}
	LIST_FOREACH(blk, &FreeMemBlocksList)
  802b7c:	a1 38 41 80 00       	mov    0x804138,%eax
  802b81:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802b84:	eb 30                	jmp    802bb6 <alloc_block_BF+0x189>
	{
		if(newsize > blk->size && blk->size > versize)
  802b86:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b89:	8b 40 0c             	mov    0xc(%eax),%eax
  802b8c:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  802b8f:	73 1d                	jae    802bae <alloc_block_BF+0x181>
  802b91:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b94:	8b 40 0c             	mov    0xc(%eax),%eax
  802b97:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  802b9a:	76 12                	jbe    802bae <alloc_block_BF+0x181>
		{
	       newsize = blk->size;
  802b9c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b9f:	8b 40 0c             	mov    0xc(%eax),%eax
  802ba2:	89 45 ec             	mov    %eax,-0x14(%ebp)
		   newveradd = blk->sva;
  802ba5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ba8:	8b 40 08             	mov    0x8(%eax),%eax
  802bab:	89 45 f0             	mov    %eax,-0x10(%ebp)
			newsize = blk->size;
			newveradd = blk->sva;
			break;
		}
	}
	LIST_FOREACH(blk, &FreeMemBlocksList)
  802bae:	a1 40 41 80 00       	mov    0x804140,%eax
  802bb3:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802bb6:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802bba:	74 07                	je     802bc3 <alloc_block_BF+0x196>
  802bbc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bbf:	8b 00                	mov    (%eax),%eax
  802bc1:	eb 05                	jmp    802bc8 <alloc_block_BF+0x19b>
  802bc3:	b8 00 00 00 00       	mov    $0x0,%eax
  802bc8:	a3 40 41 80 00       	mov    %eax,0x804140
  802bcd:	a1 40 41 80 00       	mov    0x804140,%eax
  802bd2:	85 c0                	test   %eax,%eax
  802bd4:	75 b0                	jne    802b86 <alloc_block_BF+0x159>
  802bd6:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802bda:	75 aa                	jne    802b86 <alloc_block_BF+0x159>
		{
	       newsize = blk->size;
		   newveradd = blk->sva;
		}
	}
	LIST_FOREACH(blk, &FreeMemBlocksList)
  802bdc:	a1 38 41 80 00       	mov    0x804138,%eax
  802be1:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802be4:	e9 e4 00 00 00       	jmp    802ccd <alloc_block_BF+0x2a0>
	{
		if(blk->size == newsize && blk->sva == newveradd)
  802be9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bec:	8b 40 0c             	mov    0xc(%eax),%eax
  802bef:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  802bf2:	0f 85 cd 00 00 00    	jne    802cc5 <alloc_block_BF+0x298>
  802bf8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bfb:	8b 40 08             	mov    0x8(%eax),%eax
  802bfe:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  802c01:	0f 85 be 00 00 00    	jne    802cc5 <alloc_block_BF+0x298>
		{
			LIST_REMOVE(&AvailableMemBlocksList, newblk);
  802c07:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  802c0b:	75 17                	jne    802c24 <alloc_block_BF+0x1f7>
  802c0d:	83 ec 04             	sub    $0x4,%esp
  802c10:	68 28 3f 80 00       	push   $0x803f28
  802c15:	68 db 00 00 00       	push   $0xdb
  802c1a:	68 b7 3e 80 00       	push   $0x803eb7
  802c1f:	e8 98 db ff ff       	call   8007bc <_panic>
  802c24:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802c27:	8b 00                	mov    (%eax),%eax
  802c29:	85 c0                	test   %eax,%eax
  802c2b:	74 10                	je     802c3d <alloc_block_BF+0x210>
  802c2d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802c30:	8b 00                	mov    (%eax),%eax
  802c32:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802c35:	8b 52 04             	mov    0x4(%edx),%edx
  802c38:	89 50 04             	mov    %edx,0x4(%eax)
  802c3b:	eb 0b                	jmp    802c48 <alloc_block_BF+0x21b>
  802c3d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802c40:	8b 40 04             	mov    0x4(%eax),%eax
  802c43:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802c48:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802c4b:	8b 40 04             	mov    0x4(%eax),%eax
  802c4e:	85 c0                	test   %eax,%eax
  802c50:	74 0f                	je     802c61 <alloc_block_BF+0x234>
  802c52:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802c55:	8b 40 04             	mov    0x4(%eax),%eax
  802c58:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802c5b:	8b 12                	mov    (%edx),%edx
  802c5d:	89 10                	mov    %edx,(%eax)
  802c5f:	eb 0a                	jmp    802c6b <alloc_block_BF+0x23e>
  802c61:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802c64:	8b 00                	mov    (%eax),%eax
  802c66:	a3 48 41 80 00       	mov    %eax,0x804148
  802c6b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802c6e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802c74:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802c77:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802c7e:	a1 54 41 80 00       	mov    0x804154,%eax
  802c83:	48                   	dec    %eax
  802c84:	a3 54 41 80 00       	mov    %eax,0x804154
			newblk->size = versize;
  802c89:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802c8c:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802c8f:	89 50 0c             	mov    %edx,0xc(%eax)
			newblk->sva = newveradd;
  802c92:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802c95:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802c98:	89 50 08             	mov    %edx,0x8(%eax)
			blk->size = blk->size - versize;
  802c9b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c9e:	8b 40 0c             	mov    0xc(%eax),%eax
  802ca1:	2b 45 e8             	sub    -0x18(%ebp),%eax
  802ca4:	89 c2                	mov    %eax,%edx
  802ca6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ca9:	89 50 0c             	mov    %edx,0xc(%eax)
			blk->sva+= newblk->size;
  802cac:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802caf:	8b 50 08             	mov    0x8(%eax),%edx
  802cb2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802cb5:	8b 40 0c             	mov    0xc(%eax),%eax
  802cb8:	01 c2                	add    %eax,%edx
  802cba:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cbd:	89 50 08             	mov    %edx,0x8(%eax)
			return newblk;
  802cc0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802cc3:	eb 3b                	jmp    802d00 <alloc_block_BF+0x2d3>
		{
	       newsize = blk->size;
		   newveradd = blk->sva;
		}
	}
	LIST_FOREACH(blk, &FreeMemBlocksList)
  802cc5:	a1 40 41 80 00       	mov    0x804140,%eax
  802cca:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802ccd:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802cd1:	74 07                	je     802cda <alloc_block_BF+0x2ad>
  802cd3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cd6:	8b 00                	mov    (%eax),%eax
  802cd8:	eb 05                	jmp    802cdf <alloc_block_BF+0x2b2>
  802cda:	b8 00 00 00 00       	mov    $0x0,%eax
  802cdf:	a3 40 41 80 00       	mov    %eax,0x804140
  802ce4:	a1 40 41 80 00       	mov    0x804140,%eax
  802ce9:	85 c0                	test   %eax,%eax
  802ceb:	0f 85 f8 fe ff ff    	jne    802be9 <alloc_block_BF+0x1bc>
  802cf1:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802cf5:	0f 85 ee fe ff ff    	jne    802be9 <alloc_block_BF+0x1bc>
			blk->size = blk->size - versize;
			blk->sva+= newblk->size;
			return newblk;
		}
	}
	return NULL;
  802cfb:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802d00:	c9                   	leave  
  802d01:	c3                   	ret    

00802d02 <alloc_block_NF>:
//=========================================
// [7] ALLOCATE BLOCK BY NEXT FIT:
//=========================================
struct MemBlock *last_allocate;
struct MemBlock *alloc_block_NF(uint32 size)
{
  802d02:	55                   	push   %ebp
  802d03:	89 e5                	mov    %esp,%ebp
  802d05:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1 - BONUS] [DYNAMIC ALLOCATOR] alloc_block_NF
	// Write your code here, remove the panic and write your code
	//panic("alloc_block_NF() is not implemented yet...!!");
	uint32 versize = size;
  802d08:	8b 45 08             	mov    0x8(%ebp),%eax
  802d0b:	89 45 f0             	mov    %eax,-0x10(%ebp)
	struct MemBlock* blk;
	struct MemBlock* newblk = LIST_FIRST(&AvailableMemBlocksList);
  802d0e:	a1 48 41 80 00       	mov    0x804148,%eax
  802d13:	89 45 ec             	mov    %eax,-0x14(%ebp)

	LIST_FOREACH(blk,&FreeMemBlocksList)
  802d16:	a1 38 41 80 00       	mov    0x804138,%eax
  802d1b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802d1e:	e9 77 01 00 00       	jmp    802e9a <alloc_block_NF+0x198>
	{
		if(blk->size == versize)
  802d23:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d26:	8b 40 0c             	mov    0xc(%eax),%eax
  802d29:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  802d2c:	0f 85 8a 00 00 00    	jne    802dbc <alloc_block_NF+0xba>
		{
			LIST_REMOVE(&FreeMemBlocksList,blk);
  802d32:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802d36:	75 17                	jne    802d4f <alloc_block_NF+0x4d>
  802d38:	83 ec 04             	sub    $0x4,%esp
  802d3b:	68 28 3f 80 00       	push   $0x803f28
  802d40:	68 f7 00 00 00       	push   $0xf7
  802d45:	68 b7 3e 80 00       	push   $0x803eb7
  802d4a:	e8 6d da ff ff       	call   8007bc <_panic>
  802d4f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d52:	8b 00                	mov    (%eax),%eax
  802d54:	85 c0                	test   %eax,%eax
  802d56:	74 10                	je     802d68 <alloc_block_NF+0x66>
  802d58:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d5b:	8b 00                	mov    (%eax),%eax
  802d5d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802d60:	8b 52 04             	mov    0x4(%edx),%edx
  802d63:	89 50 04             	mov    %edx,0x4(%eax)
  802d66:	eb 0b                	jmp    802d73 <alloc_block_NF+0x71>
  802d68:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d6b:	8b 40 04             	mov    0x4(%eax),%eax
  802d6e:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802d73:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d76:	8b 40 04             	mov    0x4(%eax),%eax
  802d79:	85 c0                	test   %eax,%eax
  802d7b:	74 0f                	je     802d8c <alloc_block_NF+0x8a>
  802d7d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d80:	8b 40 04             	mov    0x4(%eax),%eax
  802d83:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802d86:	8b 12                	mov    (%edx),%edx
  802d88:	89 10                	mov    %edx,(%eax)
  802d8a:	eb 0a                	jmp    802d96 <alloc_block_NF+0x94>
  802d8c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d8f:	8b 00                	mov    (%eax),%eax
  802d91:	a3 38 41 80 00       	mov    %eax,0x804138
  802d96:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d99:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802d9f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802da2:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802da9:	a1 44 41 80 00       	mov    0x804144,%eax
  802dae:	48                   	dec    %eax
  802daf:	a3 44 41 80 00       	mov    %eax,0x804144
			return blk;
  802db4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802db7:	e9 11 01 00 00       	jmp    802ecd <alloc_block_NF+0x1cb>
		}
		else if(blk->size > versize)
  802dbc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802dbf:	8b 40 0c             	mov    0xc(%eax),%eax
  802dc2:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  802dc5:	0f 86 c7 00 00 00    	jbe    802e92 <alloc_block_NF+0x190>
		{
			LIST_REMOVE(&AvailableMemBlocksList,newblk);
  802dcb:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802dcf:	75 17                	jne    802de8 <alloc_block_NF+0xe6>
  802dd1:	83 ec 04             	sub    $0x4,%esp
  802dd4:	68 28 3f 80 00       	push   $0x803f28
  802dd9:	68 fc 00 00 00       	push   $0xfc
  802dde:	68 b7 3e 80 00       	push   $0x803eb7
  802de3:	e8 d4 d9 ff ff       	call   8007bc <_panic>
  802de8:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802deb:	8b 00                	mov    (%eax),%eax
  802ded:	85 c0                	test   %eax,%eax
  802def:	74 10                	je     802e01 <alloc_block_NF+0xff>
  802df1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802df4:	8b 00                	mov    (%eax),%eax
  802df6:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802df9:	8b 52 04             	mov    0x4(%edx),%edx
  802dfc:	89 50 04             	mov    %edx,0x4(%eax)
  802dff:	eb 0b                	jmp    802e0c <alloc_block_NF+0x10a>
  802e01:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802e04:	8b 40 04             	mov    0x4(%eax),%eax
  802e07:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802e0c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802e0f:	8b 40 04             	mov    0x4(%eax),%eax
  802e12:	85 c0                	test   %eax,%eax
  802e14:	74 0f                	je     802e25 <alloc_block_NF+0x123>
  802e16:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802e19:	8b 40 04             	mov    0x4(%eax),%eax
  802e1c:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802e1f:	8b 12                	mov    (%edx),%edx
  802e21:	89 10                	mov    %edx,(%eax)
  802e23:	eb 0a                	jmp    802e2f <alloc_block_NF+0x12d>
  802e25:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802e28:	8b 00                	mov    (%eax),%eax
  802e2a:	a3 48 41 80 00       	mov    %eax,0x804148
  802e2f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802e32:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802e38:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802e3b:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802e42:	a1 54 41 80 00       	mov    0x804154,%eax
  802e47:	48                   	dec    %eax
  802e48:	a3 54 41 80 00       	mov    %eax,0x804154
			newblk->size = versize;
  802e4d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802e50:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802e53:	89 50 0c             	mov    %edx,0xc(%eax)
			blk->size = blk->size-versize;
  802e56:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e59:	8b 40 0c             	mov    0xc(%eax),%eax
  802e5c:	2b 45 f0             	sub    -0x10(%ebp),%eax
  802e5f:	89 c2                	mov    %eax,%edx
  802e61:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e64:	89 50 0c             	mov    %edx,0xc(%eax)
			uint32 newveradd = blk->sva;
  802e67:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e6a:	8b 40 08             	mov    0x8(%eax),%eax
  802e6d:	89 45 e8             	mov    %eax,-0x18(%ebp)
			blk->sva+=newblk->size;
  802e70:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e73:	8b 50 08             	mov    0x8(%eax),%edx
  802e76:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802e79:	8b 40 0c             	mov    0xc(%eax),%eax
  802e7c:	01 c2                	add    %eax,%edx
  802e7e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e81:	89 50 08             	mov    %edx,0x8(%eax)
			newblk->sva = newveradd;
  802e84:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802e87:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802e8a:	89 50 08             	mov    %edx,0x8(%eax)
			return newblk;
  802e8d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802e90:	eb 3b                	jmp    802ecd <alloc_block_NF+0x1cb>
	//panic("alloc_block_NF() is not implemented yet...!!");
	uint32 versize = size;
	struct MemBlock* blk;
	struct MemBlock* newblk = LIST_FIRST(&AvailableMemBlocksList);

	LIST_FOREACH(blk,&FreeMemBlocksList)
  802e92:	a1 40 41 80 00       	mov    0x804140,%eax
  802e97:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802e9a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802e9e:	74 07                	je     802ea7 <alloc_block_NF+0x1a5>
  802ea0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ea3:	8b 00                	mov    (%eax),%eax
  802ea5:	eb 05                	jmp    802eac <alloc_block_NF+0x1aa>
  802ea7:	b8 00 00 00 00       	mov    $0x0,%eax
  802eac:	a3 40 41 80 00       	mov    %eax,0x804140
  802eb1:	a1 40 41 80 00       	mov    0x804140,%eax
  802eb6:	85 c0                	test   %eax,%eax
  802eb8:	0f 85 65 fe ff ff    	jne    802d23 <alloc_block_NF+0x21>
  802ebe:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802ec2:	0f 85 5b fe ff ff    	jne    802d23 <alloc_block_NF+0x21>
			blk->sva+=newblk->size;
			newblk->sva = newveradd;
			return newblk;
		}
	}
	return NULL;
  802ec8:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802ecd:	c9                   	leave  
  802ece:	c3                   	ret    

00802ecf <addToAvailMemBlocksList>:

//===================================================
// [8] INSERT BLOCK (SORTED WITH MERGE) IN FREE LIST:
//===================================================
void addToAvailMemBlocksList(struct MemBlock *blockToInsert)
{
  802ecf:	55                   	push   %ebp
  802ed0:	89 e5                	mov    %esp,%ebp
  802ed2:	83 ec 08             	sub    $0x8,%esp
	blockToInsert->sva = 0;
  802ed5:	8b 45 08             	mov    0x8(%ebp),%eax
  802ed8:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
	blockToInsert->size = 0;
  802edf:	8b 45 08             	mov    0x8(%ebp),%eax
  802ee2:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
	//add to avail
	LIST_INSERT_TAIL(&AvailableMemBlocksList, blockToInsert);
  802ee9:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802eed:	75 17                	jne    802f06 <addToAvailMemBlocksList+0x37>
  802eef:	83 ec 04             	sub    $0x4,%esp
  802ef2:	68 d0 3e 80 00       	push   $0x803ed0
  802ef7:	68 10 01 00 00       	push   $0x110
  802efc:	68 b7 3e 80 00       	push   $0x803eb7
  802f01:	e8 b6 d8 ff ff       	call   8007bc <_panic>
  802f06:	8b 15 4c 41 80 00    	mov    0x80414c,%edx
  802f0c:	8b 45 08             	mov    0x8(%ebp),%eax
  802f0f:	89 50 04             	mov    %edx,0x4(%eax)
  802f12:	8b 45 08             	mov    0x8(%ebp),%eax
  802f15:	8b 40 04             	mov    0x4(%eax),%eax
  802f18:	85 c0                	test   %eax,%eax
  802f1a:	74 0c                	je     802f28 <addToAvailMemBlocksList+0x59>
  802f1c:	a1 4c 41 80 00       	mov    0x80414c,%eax
  802f21:	8b 55 08             	mov    0x8(%ebp),%edx
  802f24:	89 10                	mov    %edx,(%eax)
  802f26:	eb 08                	jmp    802f30 <addToAvailMemBlocksList+0x61>
  802f28:	8b 45 08             	mov    0x8(%ebp),%eax
  802f2b:	a3 48 41 80 00       	mov    %eax,0x804148
  802f30:	8b 45 08             	mov    0x8(%ebp),%eax
  802f33:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802f38:	8b 45 08             	mov    0x8(%ebp),%eax
  802f3b:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802f41:	a1 54 41 80 00       	mov    0x804154,%eax
  802f46:	40                   	inc    %eax
  802f47:	a3 54 41 80 00       	mov    %eax,0x804154
}
  802f4c:	90                   	nop
  802f4d:	c9                   	leave  
  802f4e:	c3                   	ret    

00802f4f <insert_sorted_with_merge_freeList>:
void insert_sorted_with_merge_freeList(struct MemBlock *blockToInsert)
{
  802f4f:	55                   	push   %ebp
  802f50:	89 e5                	mov    %esp,%ebp
  802f52:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] insert_sorted_with_merge_freeList
	// Write your code here, remove the panic and write your code

	struct MemBlock* last = LIST_LAST(&FreeMemBlocksList);
  802f55:	a1 3c 41 80 00       	mov    0x80413c,%eax
  802f5a:	89 45 f0             	mov    %eax,-0x10(%ebp)
	//check if list empty
	if (LIST_SIZE(&(FreeMemBlocksList)) == 0)
  802f5d:	a1 44 41 80 00       	mov    0x804144,%eax
  802f62:	85 c0                	test   %eax,%eax
  802f64:	75 68                	jne    802fce <insert_sorted_with_merge_freeList+0x7f>
		LIST_INSERT_HEAD(&FreeMemBlocksList, blockToInsert);
  802f66:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802f6a:	75 17                	jne    802f83 <insert_sorted_with_merge_freeList+0x34>
  802f6c:	83 ec 04             	sub    $0x4,%esp
  802f6f:	68 94 3e 80 00       	push   $0x803e94
  802f74:	68 1a 01 00 00       	push   $0x11a
  802f79:	68 b7 3e 80 00       	push   $0x803eb7
  802f7e:	e8 39 d8 ff ff       	call   8007bc <_panic>
  802f83:	8b 15 38 41 80 00    	mov    0x804138,%edx
  802f89:	8b 45 08             	mov    0x8(%ebp),%eax
  802f8c:	89 10                	mov    %edx,(%eax)
  802f8e:	8b 45 08             	mov    0x8(%ebp),%eax
  802f91:	8b 00                	mov    (%eax),%eax
  802f93:	85 c0                	test   %eax,%eax
  802f95:	74 0d                	je     802fa4 <insert_sorted_with_merge_freeList+0x55>
  802f97:	a1 38 41 80 00       	mov    0x804138,%eax
  802f9c:	8b 55 08             	mov    0x8(%ebp),%edx
  802f9f:	89 50 04             	mov    %edx,0x4(%eax)
  802fa2:	eb 08                	jmp    802fac <insert_sorted_with_merge_freeList+0x5d>
  802fa4:	8b 45 08             	mov    0x8(%ebp),%eax
  802fa7:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802fac:	8b 45 08             	mov    0x8(%ebp),%eax
  802faf:	a3 38 41 80 00       	mov    %eax,0x804138
  802fb4:	8b 45 08             	mov    0x8(%ebp),%eax
  802fb7:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802fbe:	a1 44 41 80 00       	mov    0x804144,%eax
  802fc3:	40                   	inc    %eax
  802fc4:	a3 44 41 80 00       	mov    %eax,0x804144
		}
	}

	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  802fc9:	e9 c5 03 00 00       	jmp    803393 <insert_sorted_with_merge_freeList+0x444>
	struct MemBlock* last = LIST_LAST(&FreeMemBlocksList);
	//check if list empty
	if (LIST_SIZE(&(FreeMemBlocksList)) == 0)
		LIST_INSERT_HEAD(&FreeMemBlocksList, blockToInsert);
	//check if it's position is at last
	else if (last->sva < blockToInsert->sva) {
  802fce:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802fd1:	8b 50 08             	mov    0x8(%eax),%edx
  802fd4:	8b 45 08             	mov    0x8(%ebp),%eax
  802fd7:	8b 40 08             	mov    0x8(%eax),%eax
  802fda:	39 c2                	cmp    %eax,%edx
  802fdc:	0f 83 b2 00 00 00    	jae    803094 <insert_sorted_with_merge_freeList+0x145>

		//if i have to merge
		if (last->sva + last->size == blockToInsert->sva) {
  802fe2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802fe5:	8b 50 08             	mov    0x8(%eax),%edx
  802fe8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802feb:	8b 40 0c             	mov    0xc(%eax),%eax
  802fee:	01 c2                	add    %eax,%edx
  802ff0:	8b 45 08             	mov    0x8(%ebp),%eax
  802ff3:	8b 40 08             	mov    0x8(%eax),%eax
  802ff6:	39 c2                	cmp    %eax,%edx
  802ff8:	75 27                	jne    803021 <insert_sorted_with_merge_freeList+0xd2>
			last->size = last->size + blockToInsert->size;
  802ffa:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ffd:	8b 50 0c             	mov    0xc(%eax),%edx
  803000:	8b 45 08             	mov    0x8(%ebp),%eax
  803003:	8b 40 0c             	mov    0xc(%eax),%eax
  803006:	01 c2                	add    %eax,%edx
  803008:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80300b:	89 50 0c             	mov    %edx,0xc(%eax)
			addToAvailMemBlocksList(blockToInsert);
  80300e:	83 ec 0c             	sub    $0xc,%esp
  803011:	ff 75 08             	pushl  0x8(%ebp)
  803014:	e8 b6 fe ff ff       	call   802ecf <addToAvailMemBlocksList>
  803019:	83 c4 10             	add    $0x10,%esp
		}
	}

	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  80301c:	e9 72 03 00 00       	jmp    803393 <insert_sorted_with_merge_freeList+0x444>
		if (last->sva + last->size == blockToInsert->sva) {
			last->size = last->size + blockToInsert->size;
			addToAvailMemBlocksList(blockToInsert);

		} else {
			LIST_INSERT_AFTER(&FreeMemBlocksList, last, blockToInsert);
  803021:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  803025:	74 06                	je     80302d <insert_sorted_with_merge_freeList+0xde>
  803027:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80302b:	75 17                	jne    803044 <insert_sorted_with_merge_freeList+0xf5>
  80302d:	83 ec 04             	sub    $0x4,%esp
  803030:	68 f4 3e 80 00       	push   $0x803ef4
  803035:	68 24 01 00 00       	push   $0x124
  80303a:	68 b7 3e 80 00       	push   $0x803eb7
  80303f:	e8 78 d7 ff ff       	call   8007bc <_panic>
  803044:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803047:	8b 10                	mov    (%eax),%edx
  803049:	8b 45 08             	mov    0x8(%ebp),%eax
  80304c:	89 10                	mov    %edx,(%eax)
  80304e:	8b 45 08             	mov    0x8(%ebp),%eax
  803051:	8b 00                	mov    (%eax),%eax
  803053:	85 c0                	test   %eax,%eax
  803055:	74 0b                	je     803062 <insert_sorted_with_merge_freeList+0x113>
  803057:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80305a:	8b 00                	mov    (%eax),%eax
  80305c:	8b 55 08             	mov    0x8(%ebp),%edx
  80305f:	89 50 04             	mov    %edx,0x4(%eax)
  803062:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803065:	8b 55 08             	mov    0x8(%ebp),%edx
  803068:	89 10                	mov    %edx,(%eax)
  80306a:	8b 45 08             	mov    0x8(%ebp),%eax
  80306d:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803070:	89 50 04             	mov    %edx,0x4(%eax)
  803073:	8b 45 08             	mov    0x8(%ebp),%eax
  803076:	8b 00                	mov    (%eax),%eax
  803078:	85 c0                	test   %eax,%eax
  80307a:	75 08                	jne    803084 <insert_sorted_with_merge_freeList+0x135>
  80307c:	8b 45 08             	mov    0x8(%ebp),%eax
  80307f:	a3 3c 41 80 00       	mov    %eax,0x80413c
  803084:	a1 44 41 80 00       	mov    0x804144,%eax
  803089:	40                   	inc    %eax
  80308a:	a3 44 41 80 00       	mov    %eax,0x804144
		}
	}

	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  80308f:	e9 ff 02 00 00       	jmp    803393 <insert_sorted_with_merge_freeList+0x444>
		} else {
			LIST_INSERT_AFTER(&FreeMemBlocksList, last, blockToInsert);
		}
	} else {
		struct MemBlock *iterator;
		LIST_FOREACH(iterator, &(FreeMemBlocksList))
  803094:	a1 38 41 80 00       	mov    0x804138,%eax
  803099:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80309c:	e9 c2 02 00 00       	jmp    803363 <insert_sorted_with_merge_freeList+0x414>
		{

			if (iterator->sva > blockToInsert->sva) {
  8030a1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030a4:	8b 50 08             	mov    0x8(%eax),%edx
  8030a7:	8b 45 08             	mov    0x8(%ebp),%eax
  8030aa:	8b 40 08             	mov    0x8(%eax),%eax
  8030ad:	39 c2                	cmp    %eax,%edx
  8030af:	0f 86 a6 02 00 00    	jbe    80335b <insert_sorted_with_merge_freeList+0x40c>

				struct MemBlock* prev = LIST_PREV(iterator);
  8030b5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030b8:	8b 40 04             	mov    0x4(%eax),%eax
  8030bb:	89 45 ec             	mov    %eax,-0x14(%ebp)
				if (prev == NULL) {
  8030be:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8030c2:	0f 85 ba 00 00 00    	jne    803182 <insert_sorted_with_merge_freeList+0x233>
					//check merge
					if (blockToInsert->size + blockToInsert->sva
  8030c8:	8b 45 08             	mov    0x8(%ebp),%eax
  8030cb:	8b 50 0c             	mov    0xc(%eax),%edx
  8030ce:	8b 45 08             	mov    0x8(%ebp),%eax
  8030d1:	8b 40 08             	mov    0x8(%eax),%eax
  8030d4:	01 c2                	add    %eax,%edx
							== iterator->sva) {
  8030d6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030d9:	8b 40 08             	mov    0x8(%eax),%eax
			if (iterator->sva > blockToInsert->sva) {

				struct MemBlock* prev = LIST_PREV(iterator);
				if (prev == NULL) {
					//check merge
					if (blockToInsert->size + blockToInsert->sva
  8030dc:	39 c2                	cmp    %eax,%edx
  8030de:	75 33                	jne    803113 <insert_sorted_with_merge_freeList+0x1c4>
							== iterator->sva) {
						iterator->sva = blockToInsert->sva;
  8030e0:	8b 45 08             	mov    0x8(%ebp),%eax
  8030e3:	8b 50 08             	mov    0x8(%eax),%edx
  8030e6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030e9:	89 50 08             	mov    %edx,0x8(%eax)
						iterator->size = iterator->size + blockToInsert->size;
  8030ec:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030ef:	8b 50 0c             	mov    0xc(%eax),%edx
  8030f2:	8b 45 08             	mov    0x8(%ebp),%eax
  8030f5:	8b 40 0c             	mov    0xc(%eax),%eax
  8030f8:	01 c2                	add    %eax,%edx
  8030fa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030fd:	89 50 0c             	mov    %edx,0xc(%eax)
						addToAvailMemBlocksList(blockToInsert);
  803100:	83 ec 0c             	sub    $0xc,%esp
  803103:	ff 75 08             	pushl  0x8(%ebp)
  803106:	e8 c4 fd ff ff       	call   802ecf <addToAvailMemBlocksList>
  80310b:	83 c4 10             	add    $0x10,%esp

					else {
						LIST_INSERT_BEFORE(&FreeMemBlocksList, iterator,
								blockToInsert);
					}
					break;
  80310e:	e9 80 02 00 00       	jmp    803393 <insert_sorted_with_merge_freeList+0x444>
						addToAvailMemBlocksList(blockToInsert);

					}

					else {
						LIST_INSERT_BEFORE(&FreeMemBlocksList, iterator,
  803113:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803117:	74 06                	je     80311f <insert_sorted_with_merge_freeList+0x1d0>
  803119:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80311d:	75 17                	jne    803136 <insert_sorted_with_merge_freeList+0x1e7>
  80311f:	83 ec 04             	sub    $0x4,%esp
  803122:	68 48 3f 80 00       	push   $0x803f48
  803127:	68 3a 01 00 00       	push   $0x13a
  80312c:	68 b7 3e 80 00       	push   $0x803eb7
  803131:	e8 86 d6 ff ff       	call   8007bc <_panic>
  803136:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803139:	8b 50 04             	mov    0x4(%eax),%edx
  80313c:	8b 45 08             	mov    0x8(%ebp),%eax
  80313f:	89 50 04             	mov    %edx,0x4(%eax)
  803142:	8b 45 08             	mov    0x8(%ebp),%eax
  803145:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803148:	89 10                	mov    %edx,(%eax)
  80314a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80314d:	8b 40 04             	mov    0x4(%eax),%eax
  803150:	85 c0                	test   %eax,%eax
  803152:	74 0d                	je     803161 <insert_sorted_with_merge_freeList+0x212>
  803154:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803157:	8b 40 04             	mov    0x4(%eax),%eax
  80315a:	8b 55 08             	mov    0x8(%ebp),%edx
  80315d:	89 10                	mov    %edx,(%eax)
  80315f:	eb 08                	jmp    803169 <insert_sorted_with_merge_freeList+0x21a>
  803161:	8b 45 08             	mov    0x8(%ebp),%eax
  803164:	a3 38 41 80 00       	mov    %eax,0x804138
  803169:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80316c:	8b 55 08             	mov    0x8(%ebp),%edx
  80316f:	89 50 04             	mov    %edx,0x4(%eax)
  803172:	a1 44 41 80 00       	mov    0x804144,%eax
  803177:	40                   	inc    %eax
  803178:	a3 44 41 80 00       	mov    %eax,0x804144
								blockToInsert);
					}
					break;
  80317d:	e9 11 02 00 00       	jmp    803393 <insert_sorted_with_merge_freeList+0x444>
				} else {
					//prev and next merge
					if (prev->sva + prev->size + blockToInsert->size
  803182:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803185:	8b 50 08             	mov    0x8(%eax),%edx
  803188:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80318b:	8b 40 0c             	mov    0xc(%eax),%eax
  80318e:	01 c2                	add    %eax,%edx
  803190:	8b 45 08             	mov    0x8(%ebp),%eax
  803193:	8b 40 0c             	mov    0xc(%eax),%eax
  803196:	01 c2                	add    %eax,%edx
							== iterator->sva) {
  803198:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80319b:	8b 40 08             	mov    0x8(%eax),%eax
								blockToInsert);
					}
					break;
				} else {
					//prev and next merge
					if (prev->sva + prev->size + blockToInsert->size
  80319e:	39 c2                	cmp    %eax,%edx
  8031a0:	0f 85 bf 00 00 00    	jne    803265 <insert_sorted_with_merge_freeList+0x316>
							== iterator->sva) {
						prev->size = prev->size + blockToInsert->size
  8031a6:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8031a9:	8b 50 0c             	mov    0xc(%eax),%edx
  8031ac:	8b 45 08             	mov    0x8(%ebp),%eax
  8031af:	8b 40 0c             	mov    0xc(%eax),%eax
  8031b2:	01 c2                	add    %eax,%edx
								+ iterator->size;
  8031b4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8031b7:	8b 40 0c             	mov    0xc(%eax),%eax
  8031ba:	01 c2                	add    %eax,%edx
					break;
				} else {
					//prev and next merge
					if (prev->sva + prev->size + blockToInsert->size
							== iterator->sva) {
						prev->size = prev->size + blockToInsert->size
  8031bc:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8031bf:	89 50 0c             	mov    %edx,0xc(%eax)
								+ iterator->size;
						LIST_REMOVE(&FreeMemBlocksList, iterator);
  8031c2:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8031c6:	75 17                	jne    8031df <insert_sorted_with_merge_freeList+0x290>
  8031c8:	83 ec 04             	sub    $0x4,%esp
  8031cb:	68 28 3f 80 00       	push   $0x803f28
  8031d0:	68 43 01 00 00       	push   $0x143
  8031d5:	68 b7 3e 80 00       	push   $0x803eb7
  8031da:	e8 dd d5 ff ff       	call   8007bc <_panic>
  8031df:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8031e2:	8b 00                	mov    (%eax),%eax
  8031e4:	85 c0                	test   %eax,%eax
  8031e6:	74 10                	je     8031f8 <insert_sorted_with_merge_freeList+0x2a9>
  8031e8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8031eb:	8b 00                	mov    (%eax),%eax
  8031ed:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8031f0:	8b 52 04             	mov    0x4(%edx),%edx
  8031f3:	89 50 04             	mov    %edx,0x4(%eax)
  8031f6:	eb 0b                	jmp    803203 <insert_sorted_with_merge_freeList+0x2b4>
  8031f8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8031fb:	8b 40 04             	mov    0x4(%eax),%eax
  8031fe:	a3 3c 41 80 00       	mov    %eax,0x80413c
  803203:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803206:	8b 40 04             	mov    0x4(%eax),%eax
  803209:	85 c0                	test   %eax,%eax
  80320b:	74 0f                	je     80321c <insert_sorted_with_merge_freeList+0x2cd>
  80320d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803210:	8b 40 04             	mov    0x4(%eax),%eax
  803213:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803216:	8b 12                	mov    (%edx),%edx
  803218:	89 10                	mov    %edx,(%eax)
  80321a:	eb 0a                	jmp    803226 <insert_sorted_with_merge_freeList+0x2d7>
  80321c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80321f:	8b 00                	mov    (%eax),%eax
  803221:	a3 38 41 80 00       	mov    %eax,0x804138
  803226:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803229:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80322f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803232:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803239:	a1 44 41 80 00       	mov    0x804144,%eax
  80323e:	48                   	dec    %eax
  80323f:	a3 44 41 80 00       	mov    %eax,0x804144
						addToAvailMemBlocksList(blockToInsert);
  803244:	83 ec 0c             	sub    $0xc,%esp
  803247:	ff 75 08             	pushl  0x8(%ebp)
  80324a:	e8 80 fc ff ff       	call   802ecf <addToAvailMemBlocksList>
  80324f:	83 c4 10             	add    $0x10,%esp
						addToAvailMemBlocksList(iterator);
  803252:	83 ec 0c             	sub    $0xc,%esp
  803255:	ff 75 f4             	pushl  -0xc(%ebp)
  803258:	e8 72 fc ff ff       	call   802ecf <addToAvailMemBlocksList>
  80325d:	83 c4 10             	add    $0x10,%esp
					//Insert
					else {
						LIST_INSERT_BEFORE(&FreeMemBlocksList, iterator,
								blockToInsert);
					}
					break;
  803260:	e9 2e 01 00 00       	jmp    803393 <insert_sorted_with_merge_freeList+0x444>
						LIST_REMOVE(&FreeMemBlocksList, iterator);
						addToAvailMemBlocksList(blockToInsert);
						addToAvailMemBlocksList(iterator);
					}
					//previous merge
					else if (prev->sva + prev->size == blockToInsert->sva) {
  803265:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803268:	8b 50 08             	mov    0x8(%eax),%edx
  80326b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80326e:	8b 40 0c             	mov    0xc(%eax),%eax
  803271:	01 c2                	add    %eax,%edx
  803273:	8b 45 08             	mov    0x8(%ebp),%eax
  803276:	8b 40 08             	mov    0x8(%eax),%eax
  803279:	39 c2                	cmp    %eax,%edx
  80327b:	75 27                	jne    8032a4 <insert_sorted_with_merge_freeList+0x355>
						prev->size = prev->size + blockToInsert->size;
  80327d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803280:	8b 50 0c             	mov    0xc(%eax),%edx
  803283:	8b 45 08             	mov    0x8(%ebp),%eax
  803286:	8b 40 0c             	mov    0xc(%eax),%eax
  803289:	01 c2                	add    %eax,%edx
  80328b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80328e:	89 50 0c             	mov    %edx,0xc(%eax)
						addToAvailMemBlocksList(blockToInsert);
  803291:	83 ec 0c             	sub    $0xc,%esp
  803294:	ff 75 08             	pushl  0x8(%ebp)
  803297:	e8 33 fc ff ff       	call   802ecf <addToAvailMemBlocksList>
  80329c:	83 c4 10             	add    $0x10,%esp
					//Insert
					else {
						LIST_INSERT_BEFORE(&FreeMemBlocksList, iterator,
								blockToInsert);
					}
					break;
  80329f:	e9 ef 00 00 00       	jmp    803393 <insert_sorted_with_merge_freeList+0x444>
					else if (prev->sva + prev->size == blockToInsert->sva) {
						prev->size = prev->size + blockToInsert->size;
						addToAvailMemBlocksList(blockToInsert);
					}
					//next merge
					else if (blockToInsert->size + blockToInsert->sva
  8032a4:	8b 45 08             	mov    0x8(%ebp),%eax
  8032a7:	8b 50 0c             	mov    0xc(%eax),%edx
  8032aa:	8b 45 08             	mov    0x8(%ebp),%eax
  8032ad:	8b 40 08             	mov    0x8(%eax),%eax
  8032b0:	01 c2                	add    %eax,%edx
							== iterator->sva) {
  8032b2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8032b5:	8b 40 08             	mov    0x8(%eax),%eax
					else if (prev->sva + prev->size == blockToInsert->sva) {
						prev->size = prev->size + blockToInsert->size;
						addToAvailMemBlocksList(blockToInsert);
					}
					//next merge
					else if (blockToInsert->size + blockToInsert->sva
  8032b8:	39 c2                	cmp    %eax,%edx
  8032ba:	75 33                	jne    8032ef <insert_sorted_with_merge_freeList+0x3a0>
							== iterator->sva) {
						iterator->sva = blockToInsert->sva;
  8032bc:	8b 45 08             	mov    0x8(%ebp),%eax
  8032bf:	8b 50 08             	mov    0x8(%eax),%edx
  8032c2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8032c5:	89 50 08             	mov    %edx,0x8(%eax)
						iterator->size = iterator->size + blockToInsert->size;
  8032c8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8032cb:	8b 50 0c             	mov    0xc(%eax),%edx
  8032ce:	8b 45 08             	mov    0x8(%ebp),%eax
  8032d1:	8b 40 0c             	mov    0xc(%eax),%eax
  8032d4:	01 c2                	add    %eax,%edx
  8032d6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8032d9:	89 50 0c             	mov    %edx,0xc(%eax)
						addToAvailMemBlocksList(blockToInsert);
  8032dc:	83 ec 0c             	sub    $0xc,%esp
  8032df:	ff 75 08             	pushl  0x8(%ebp)
  8032e2:	e8 e8 fb ff ff       	call   802ecf <addToAvailMemBlocksList>
  8032e7:	83 c4 10             	add    $0x10,%esp
					//Insert
					else {
						LIST_INSERT_BEFORE(&FreeMemBlocksList, iterator,
								blockToInsert);
					}
					break;
  8032ea:	e9 a4 00 00 00       	jmp    803393 <insert_sorted_with_merge_freeList+0x444>
						iterator->size = iterator->size + blockToInsert->size;
						addToAvailMemBlocksList(blockToInsert);
					}
					//Insert
					else {
						LIST_INSERT_BEFORE(&FreeMemBlocksList, iterator,
  8032ef:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8032f3:	74 06                	je     8032fb <insert_sorted_with_merge_freeList+0x3ac>
  8032f5:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8032f9:	75 17                	jne    803312 <insert_sorted_with_merge_freeList+0x3c3>
  8032fb:	83 ec 04             	sub    $0x4,%esp
  8032fe:	68 48 3f 80 00       	push   $0x803f48
  803303:	68 56 01 00 00       	push   $0x156
  803308:	68 b7 3e 80 00       	push   $0x803eb7
  80330d:	e8 aa d4 ff ff       	call   8007bc <_panic>
  803312:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803315:	8b 50 04             	mov    0x4(%eax),%edx
  803318:	8b 45 08             	mov    0x8(%ebp),%eax
  80331b:	89 50 04             	mov    %edx,0x4(%eax)
  80331e:	8b 45 08             	mov    0x8(%ebp),%eax
  803321:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803324:	89 10                	mov    %edx,(%eax)
  803326:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803329:	8b 40 04             	mov    0x4(%eax),%eax
  80332c:	85 c0                	test   %eax,%eax
  80332e:	74 0d                	je     80333d <insert_sorted_with_merge_freeList+0x3ee>
  803330:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803333:	8b 40 04             	mov    0x4(%eax),%eax
  803336:	8b 55 08             	mov    0x8(%ebp),%edx
  803339:	89 10                	mov    %edx,(%eax)
  80333b:	eb 08                	jmp    803345 <insert_sorted_with_merge_freeList+0x3f6>
  80333d:	8b 45 08             	mov    0x8(%ebp),%eax
  803340:	a3 38 41 80 00       	mov    %eax,0x804138
  803345:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803348:	8b 55 08             	mov    0x8(%ebp),%edx
  80334b:	89 50 04             	mov    %edx,0x4(%eax)
  80334e:	a1 44 41 80 00       	mov    0x804144,%eax
  803353:	40                   	inc    %eax
  803354:	a3 44 41 80 00       	mov    %eax,0x804144
								blockToInsert);
					}
					break;
  803359:	eb 38                	jmp    803393 <insert_sorted_with_merge_freeList+0x444>
		} else {
			LIST_INSERT_AFTER(&FreeMemBlocksList, last, blockToInsert);
		}
	} else {
		struct MemBlock *iterator;
		LIST_FOREACH(iterator, &(FreeMemBlocksList))
  80335b:	a1 40 41 80 00       	mov    0x804140,%eax
  803360:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803363:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803367:	74 07                	je     803370 <insert_sorted_with_merge_freeList+0x421>
  803369:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80336c:	8b 00                	mov    (%eax),%eax
  80336e:	eb 05                	jmp    803375 <insert_sorted_with_merge_freeList+0x426>
  803370:	b8 00 00 00 00       	mov    $0x0,%eax
  803375:	a3 40 41 80 00       	mov    %eax,0x804140
  80337a:	a1 40 41 80 00       	mov    0x804140,%eax
  80337f:	85 c0                	test   %eax,%eax
  803381:	0f 85 1a fd ff ff    	jne    8030a1 <insert_sorted_with_merge_freeList+0x152>
  803387:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80338b:	0f 85 10 fd ff ff    	jne    8030a1 <insert_sorted_with_merge_freeList+0x152>
		}
	}

	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  803391:	eb 00                	jmp    803393 <insert_sorted_with_merge_freeList+0x444>
  803393:	90                   	nop
  803394:	c9                   	leave  
  803395:	c3                   	ret    
  803396:	66 90                	xchg   %ax,%ax

00803398 <__udivdi3>:
  803398:	55                   	push   %ebp
  803399:	57                   	push   %edi
  80339a:	56                   	push   %esi
  80339b:	53                   	push   %ebx
  80339c:	83 ec 1c             	sub    $0x1c,%esp
  80339f:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  8033a3:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  8033a7:	8b 7c 24 38          	mov    0x38(%esp),%edi
  8033ab:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8033af:	89 ca                	mov    %ecx,%edx
  8033b1:	89 f8                	mov    %edi,%eax
  8033b3:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  8033b7:	85 f6                	test   %esi,%esi
  8033b9:	75 2d                	jne    8033e8 <__udivdi3+0x50>
  8033bb:	39 cf                	cmp    %ecx,%edi
  8033bd:	77 65                	ja     803424 <__udivdi3+0x8c>
  8033bf:	89 fd                	mov    %edi,%ebp
  8033c1:	85 ff                	test   %edi,%edi
  8033c3:	75 0b                	jne    8033d0 <__udivdi3+0x38>
  8033c5:	b8 01 00 00 00       	mov    $0x1,%eax
  8033ca:	31 d2                	xor    %edx,%edx
  8033cc:	f7 f7                	div    %edi
  8033ce:	89 c5                	mov    %eax,%ebp
  8033d0:	31 d2                	xor    %edx,%edx
  8033d2:	89 c8                	mov    %ecx,%eax
  8033d4:	f7 f5                	div    %ebp
  8033d6:	89 c1                	mov    %eax,%ecx
  8033d8:	89 d8                	mov    %ebx,%eax
  8033da:	f7 f5                	div    %ebp
  8033dc:	89 cf                	mov    %ecx,%edi
  8033de:	89 fa                	mov    %edi,%edx
  8033e0:	83 c4 1c             	add    $0x1c,%esp
  8033e3:	5b                   	pop    %ebx
  8033e4:	5e                   	pop    %esi
  8033e5:	5f                   	pop    %edi
  8033e6:	5d                   	pop    %ebp
  8033e7:	c3                   	ret    
  8033e8:	39 ce                	cmp    %ecx,%esi
  8033ea:	77 28                	ja     803414 <__udivdi3+0x7c>
  8033ec:	0f bd fe             	bsr    %esi,%edi
  8033ef:	83 f7 1f             	xor    $0x1f,%edi
  8033f2:	75 40                	jne    803434 <__udivdi3+0x9c>
  8033f4:	39 ce                	cmp    %ecx,%esi
  8033f6:	72 0a                	jb     803402 <__udivdi3+0x6a>
  8033f8:	3b 44 24 08          	cmp    0x8(%esp),%eax
  8033fc:	0f 87 9e 00 00 00    	ja     8034a0 <__udivdi3+0x108>
  803402:	b8 01 00 00 00       	mov    $0x1,%eax
  803407:	89 fa                	mov    %edi,%edx
  803409:	83 c4 1c             	add    $0x1c,%esp
  80340c:	5b                   	pop    %ebx
  80340d:	5e                   	pop    %esi
  80340e:	5f                   	pop    %edi
  80340f:	5d                   	pop    %ebp
  803410:	c3                   	ret    
  803411:	8d 76 00             	lea    0x0(%esi),%esi
  803414:	31 ff                	xor    %edi,%edi
  803416:	31 c0                	xor    %eax,%eax
  803418:	89 fa                	mov    %edi,%edx
  80341a:	83 c4 1c             	add    $0x1c,%esp
  80341d:	5b                   	pop    %ebx
  80341e:	5e                   	pop    %esi
  80341f:	5f                   	pop    %edi
  803420:	5d                   	pop    %ebp
  803421:	c3                   	ret    
  803422:	66 90                	xchg   %ax,%ax
  803424:	89 d8                	mov    %ebx,%eax
  803426:	f7 f7                	div    %edi
  803428:	31 ff                	xor    %edi,%edi
  80342a:	89 fa                	mov    %edi,%edx
  80342c:	83 c4 1c             	add    $0x1c,%esp
  80342f:	5b                   	pop    %ebx
  803430:	5e                   	pop    %esi
  803431:	5f                   	pop    %edi
  803432:	5d                   	pop    %ebp
  803433:	c3                   	ret    
  803434:	bd 20 00 00 00       	mov    $0x20,%ebp
  803439:	89 eb                	mov    %ebp,%ebx
  80343b:	29 fb                	sub    %edi,%ebx
  80343d:	89 f9                	mov    %edi,%ecx
  80343f:	d3 e6                	shl    %cl,%esi
  803441:	89 c5                	mov    %eax,%ebp
  803443:	88 d9                	mov    %bl,%cl
  803445:	d3 ed                	shr    %cl,%ebp
  803447:	89 e9                	mov    %ebp,%ecx
  803449:	09 f1                	or     %esi,%ecx
  80344b:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  80344f:	89 f9                	mov    %edi,%ecx
  803451:	d3 e0                	shl    %cl,%eax
  803453:	89 c5                	mov    %eax,%ebp
  803455:	89 d6                	mov    %edx,%esi
  803457:	88 d9                	mov    %bl,%cl
  803459:	d3 ee                	shr    %cl,%esi
  80345b:	89 f9                	mov    %edi,%ecx
  80345d:	d3 e2                	shl    %cl,%edx
  80345f:	8b 44 24 08          	mov    0x8(%esp),%eax
  803463:	88 d9                	mov    %bl,%cl
  803465:	d3 e8                	shr    %cl,%eax
  803467:	09 c2                	or     %eax,%edx
  803469:	89 d0                	mov    %edx,%eax
  80346b:	89 f2                	mov    %esi,%edx
  80346d:	f7 74 24 0c          	divl   0xc(%esp)
  803471:	89 d6                	mov    %edx,%esi
  803473:	89 c3                	mov    %eax,%ebx
  803475:	f7 e5                	mul    %ebp
  803477:	39 d6                	cmp    %edx,%esi
  803479:	72 19                	jb     803494 <__udivdi3+0xfc>
  80347b:	74 0b                	je     803488 <__udivdi3+0xf0>
  80347d:	89 d8                	mov    %ebx,%eax
  80347f:	31 ff                	xor    %edi,%edi
  803481:	e9 58 ff ff ff       	jmp    8033de <__udivdi3+0x46>
  803486:	66 90                	xchg   %ax,%ax
  803488:	8b 54 24 08          	mov    0x8(%esp),%edx
  80348c:	89 f9                	mov    %edi,%ecx
  80348e:	d3 e2                	shl    %cl,%edx
  803490:	39 c2                	cmp    %eax,%edx
  803492:	73 e9                	jae    80347d <__udivdi3+0xe5>
  803494:	8d 43 ff             	lea    -0x1(%ebx),%eax
  803497:	31 ff                	xor    %edi,%edi
  803499:	e9 40 ff ff ff       	jmp    8033de <__udivdi3+0x46>
  80349e:	66 90                	xchg   %ax,%ax
  8034a0:	31 c0                	xor    %eax,%eax
  8034a2:	e9 37 ff ff ff       	jmp    8033de <__udivdi3+0x46>
  8034a7:	90                   	nop

008034a8 <__umoddi3>:
  8034a8:	55                   	push   %ebp
  8034a9:	57                   	push   %edi
  8034aa:	56                   	push   %esi
  8034ab:	53                   	push   %ebx
  8034ac:	83 ec 1c             	sub    $0x1c,%esp
  8034af:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  8034b3:	8b 74 24 34          	mov    0x34(%esp),%esi
  8034b7:	8b 7c 24 38          	mov    0x38(%esp),%edi
  8034bb:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  8034bf:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8034c3:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8034c7:	89 f3                	mov    %esi,%ebx
  8034c9:	89 fa                	mov    %edi,%edx
  8034cb:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8034cf:	89 34 24             	mov    %esi,(%esp)
  8034d2:	85 c0                	test   %eax,%eax
  8034d4:	75 1a                	jne    8034f0 <__umoddi3+0x48>
  8034d6:	39 f7                	cmp    %esi,%edi
  8034d8:	0f 86 a2 00 00 00    	jbe    803580 <__umoddi3+0xd8>
  8034de:	89 c8                	mov    %ecx,%eax
  8034e0:	89 f2                	mov    %esi,%edx
  8034e2:	f7 f7                	div    %edi
  8034e4:	89 d0                	mov    %edx,%eax
  8034e6:	31 d2                	xor    %edx,%edx
  8034e8:	83 c4 1c             	add    $0x1c,%esp
  8034eb:	5b                   	pop    %ebx
  8034ec:	5e                   	pop    %esi
  8034ed:	5f                   	pop    %edi
  8034ee:	5d                   	pop    %ebp
  8034ef:	c3                   	ret    
  8034f0:	39 f0                	cmp    %esi,%eax
  8034f2:	0f 87 ac 00 00 00    	ja     8035a4 <__umoddi3+0xfc>
  8034f8:	0f bd e8             	bsr    %eax,%ebp
  8034fb:	83 f5 1f             	xor    $0x1f,%ebp
  8034fe:	0f 84 ac 00 00 00    	je     8035b0 <__umoddi3+0x108>
  803504:	bf 20 00 00 00       	mov    $0x20,%edi
  803509:	29 ef                	sub    %ebp,%edi
  80350b:	89 fe                	mov    %edi,%esi
  80350d:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  803511:	89 e9                	mov    %ebp,%ecx
  803513:	d3 e0                	shl    %cl,%eax
  803515:	89 d7                	mov    %edx,%edi
  803517:	89 f1                	mov    %esi,%ecx
  803519:	d3 ef                	shr    %cl,%edi
  80351b:	09 c7                	or     %eax,%edi
  80351d:	89 e9                	mov    %ebp,%ecx
  80351f:	d3 e2                	shl    %cl,%edx
  803521:	89 14 24             	mov    %edx,(%esp)
  803524:	89 d8                	mov    %ebx,%eax
  803526:	d3 e0                	shl    %cl,%eax
  803528:	89 c2                	mov    %eax,%edx
  80352a:	8b 44 24 08          	mov    0x8(%esp),%eax
  80352e:	d3 e0                	shl    %cl,%eax
  803530:	89 44 24 04          	mov    %eax,0x4(%esp)
  803534:	8b 44 24 08          	mov    0x8(%esp),%eax
  803538:	89 f1                	mov    %esi,%ecx
  80353a:	d3 e8                	shr    %cl,%eax
  80353c:	09 d0                	or     %edx,%eax
  80353e:	d3 eb                	shr    %cl,%ebx
  803540:	89 da                	mov    %ebx,%edx
  803542:	f7 f7                	div    %edi
  803544:	89 d3                	mov    %edx,%ebx
  803546:	f7 24 24             	mull   (%esp)
  803549:	89 c6                	mov    %eax,%esi
  80354b:	89 d1                	mov    %edx,%ecx
  80354d:	39 d3                	cmp    %edx,%ebx
  80354f:	0f 82 87 00 00 00    	jb     8035dc <__umoddi3+0x134>
  803555:	0f 84 91 00 00 00    	je     8035ec <__umoddi3+0x144>
  80355b:	8b 54 24 04          	mov    0x4(%esp),%edx
  80355f:	29 f2                	sub    %esi,%edx
  803561:	19 cb                	sbb    %ecx,%ebx
  803563:	89 d8                	mov    %ebx,%eax
  803565:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  803569:	d3 e0                	shl    %cl,%eax
  80356b:	89 e9                	mov    %ebp,%ecx
  80356d:	d3 ea                	shr    %cl,%edx
  80356f:	09 d0                	or     %edx,%eax
  803571:	89 e9                	mov    %ebp,%ecx
  803573:	d3 eb                	shr    %cl,%ebx
  803575:	89 da                	mov    %ebx,%edx
  803577:	83 c4 1c             	add    $0x1c,%esp
  80357a:	5b                   	pop    %ebx
  80357b:	5e                   	pop    %esi
  80357c:	5f                   	pop    %edi
  80357d:	5d                   	pop    %ebp
  80357e:	c3                   	ret    
  80357f:	90                   	nop
  803580:	89 fd                	mov    %edi,%ebp
  803582:	85 ff                	test   %edi,%edi
  803584:	75 0b                	jne    803591 <__umoddi3+0xe9>
  803586:	b8 01 00 00 00       	mov    $0x1,%eax
  80358b:	31 d2                	xor    %edx,%edx
  80358d:	f7 f7                	div    %edi
  80358f:	89 c5                	mov    %eax,%ebp
  803591:	89 f0                	mov    %esi,%eax
  803593:	31 d2                	xor    %edx,%edx
  803595:	f7 f5                	div    %ebp
  803597:	89 c8                	mov    %ecx,%eax
  803599:	f7 f5                	div    %ebp
  80359b:	89 d0                	mov    %edx,%eax
  80359d:	e9 44 ff ff ff       	jmp    8034e6 <__umoddi3+0x3e>
  8035a2:	66 90                	xchg   %ax,%ax
  8035a4:	89 c8                	mov    %ecx,%eax
  8035a6:	89 f2                	mov    %esi,%edx
  8035a8:	83 c4 1c             	add    $0x1c,%esp
  8035ab:	5b                   	pop    %ebx
  8035ac:	5e                   	pop    %esi
  8035ad:	5f                   	pop    %edi
  8035ae:	5d                   	pop    %ebp
  8035af:	c3                   	ret    
  8035b0:	3b 04 24             	cmp    (%esp),%eax
  8035b3:	72 06                	jb     8035bb <__umoddi3+0x113>
  8035b5:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  8035b9:	77 0f                	ja     8035ca <__umoddi3+0x122>
  8035bb:	89 f2                	mov    %esi,%edx
  8035bd:	29 f9                	sub    %edi,%ecx
  8035bf:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  8035c3:	89 14 24             	mov    %edx,(%esp)
  8035c6:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8035ca:	8b 44 24 04          	mov    0x4(%esp),%eax
  8035ce:	8b 14 24             	mov    (%esp),%edx
  8035d1:	83 c4 1c             	add    $0x1c,%esp
  8035d4:	5b                   	pop    %ebx
  8035d5:	5e                   	pop    %esi
  8035d6:	5f                   	pop    %edi
  8035d7:	5d                   	pop    %ebp
  8035d8:	c3                   	ret    
  8035d9:	8d 76 00             	lea    0x0(%esi),%esi
  8035dc:	2b 04 24             	sub    (%esp),%eax
  8035df:	19 fa                	sbb    %edi,%edx
  8035e1:	89 d1                	mov    %edx,%ecx
  8035e3:	89 c6                	mov    %eax,%esi
  8035e5:	e9 71 ff ff ff       	jmp    80355b <__umoddi3+0xb3>
  8035ea:	66 90                	xchg   %ax,%ax
  8035ec:	39 44 24 04          	cmp    %eax,0x4(%esp)
  8035f0:	72 ea                	jb     8035dc <__umoddi3+0x134>
  8035f2:	89 d9                	mov    %ebx,%ecx
  8035f4:	e9 62 ff ff ff       	jmp    80355b <__umoddi3+0xb3>
