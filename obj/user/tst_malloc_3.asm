
obj/user/tst_malloc_3:     file format elf32-i386


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
  800031:	e8 f6 0d 00 00       	call   800e2c <libmain>
1:      jmp 1b
  800036:	eb fe                	jmp    800036 <args_exist+0x5>

00800038 <_main>:
	short b;
	int c;
};

void _main(void)
{
  800038:	55                   	push   %ebp
  800039:	89 e5                	mov    %esp,%ebp
  80003b:	57                   	push   %edi
  80003c:	53                   	push   %ebx
  80003d:	81 ec 20 01 00 00    	sub    $0x120,%esp
	//Initial test to ensure it works on "PLACEMENT" not "REPLACEMENT"
	{
		uint8 fullWS = 1;
  800043:	c6 45 f7 01          	movb   $0x1,-0x9(%ebp)
		for (int i = 0; i < myEnv->page_WS_max_size; ++i)
  800047:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  80004e:	eb 29                	jmp    800079 <_main+0x41>
		{
			if (myEnv->__uptr_pws[i].empty)
  800050:	a1 20 50 80 00       	mov    0x805020,%eax
  800055:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  80005b:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80005e:	89 d0                	mov    %edx,%eax
  800060:	01 c0                	add    %eax,%eax
  800062:	01 d0                	add    %edx,%eax
  800064:	c1 e0 03             	shl    $0x3,%eax
  800067:	01 c8                	add    %ecx,%eax
  800069:	8a 40 04             	mov    0x4(%eax),%al
  80006c:	84 c0                	test   %al,%al
  80006e:	74 06                	je     800076 <_main+0x3e>
			{
				fullWS = 0;
  800070:	c6 45 f7 00          	movb   $0x0,-0x9(%ebp)
				break;
  800074:	eb 12                	jmp    800088 <_main+0x50>
void _main(void)
{
	//Initial test to ensure it works on "PLACEMENT" not "REPLACEMENT"
	{
		uint8 fullWS = 1;
		for (int i = 0; i < myEnv->page_WS_max_size; ++i)
  800076:	ff 45 f0             	incl   -0x10(%ebp)
  800079:	a1 20 50 80 00       	mov    0x805020,%eax
  80007e:	8b 50 74             	mov    0x74(%eax),%edx
  800081:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800084:	39 c2                	cmp    %eax,%edx
  800086:	77 c8                	ja     800050 <_main+0x18>
			{
				fullWS = 0;
				break;
			}
		}
		if (fullWS) panic("Please increase the WS size");
  800088:	80 7d f7 00          	cmpb   $0x0,-0x9(%ebp)
  80008c:	74 14                	je     8000a2 <_main+0x6a>
  80008e:	83 ec 04             	sub    $0x4,%esp
  800091:	68 c0 3d 80 00       	push   $0x803dc0
  800096:	6a 1a                	push   $0x1a
  800098:	68 dc 3d 80 00       	push   $0x803ddc
  80009d:	e8 c6 0e 00 00       	call   800f68 <_panic>
	}
	/*Dummy malloc to enforce the UHEAP initializations*/
	malloc(0);
  8000a2:	83 ec 0c             	sub    $0xc,%esp
  8000a5:	6a 00                	push   $0x0
  8000a7:	e8 02 21 00 00       	call   8021ae <malloc>
  8000ac:	83 c4 10             	add    $0x10,%esp





	int Mega = 1024*1024;
  8000af:	c7 45 e4 00 00 10 00 	movl   $0x100000,-0x1c(%ebp)
	int kilo = 1024;
  8000b6:	c7 45 e0 00 04 00 00 	movl   $0x400,-0x20(%ebp)
	char minByte = 1<<7;
  8000bd:	c6 45 df 80          	movb   $0x80,-0x21(%ebp)
	char maxByte = 0x7F;
  8000c1:	c6 45 de 7f          	movb   $0x7f,-0x22(%ebp)
	short minShort = 1<<15 ;
  8000c5:	66 c7 45 dc 00 80    	movw   $0x8000,-0x24(%ebp)
	short maxShort = 0x7FFF;
  8000cb:	66 c7 45 da ff 7f    	movw   $0x7fff,-0x26(%ebp)
	int minInt = 1<<31 ;
  8000d1:	c7 45 d4 00 00 00 80 	movl   $0x80000000,-0x2c(%ebp)
	int maxInt = 0x7FFFFFFF;
  8000d8:	c7 45 d0 ff ff ff 7f 	movl   $0x7fffffff,-0x30(%ebp)
	char *byteArr, *byteArr2 ;
	short *shortArr, *shortArr2 ;
	int *intArr;
	struct MyStruct *structArr ;
	int lastIndexOfByte, lastIndexOfByte2, lastIndexOfShort, lastIndexOfShort2, lastIndexOfInt, lastIndexOfStruct;
	int start_freeFrames = sys_calculate_free_frames() ;
  8000df:	e8 d6 24 00 00       	call   8025ba <sys_calculate_free_frames>
  8000e4:	89 45 cc             	mov    %eax,-0x34(%ebp)

	void* ptr_allocations[20] = {0};
  8000e7:	8d 95 dc fe ff ff    	lea    -0x124(%ebp),%edx
  8000ed:	b9 14 00 00 00       	mov    $0x14,%ecx
  8000f2:	b8 00 00 00 00       	mov    $0x0,%eax
  8000f7:	89 d7                	mov    %edx,%edi
  8000f9:	f3 ab                	rep stos %eax,%es:(%edi)
	{
		//2 MB
		int usedDiskPages = sys_pf_calculate_allocated_pages() ;
  8000fb:	e8 5a 25 00 00       	call   80265a <sys_pf_calculate_allocated_pages>
  800100:	89 45 c8             	mov    %eax,-0x38(%ebp)
		ptr_allocations[0] = malloc(2*Mega-kilo);
  800103:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800106:	01 c0                	add    %eax,%eax
  800108:	2b 45 e0             	sub    -0x20(%ebp),%eax
  80010b:	83 ec 0c             	sub    $0xc,%esp
  80010e:	50                   	push   %eax
  80010f:	e8 9a 20 00 00       	call   8021ae <malloc>
  800114:	83 c4 10             	add    $0x10,%esp
  800117:	89 85 dc fe ff ff    	mov    %eax,-0x124(%ebp)
		if ((uint32) ptr_allocations[0] <  (USER_HEAP_START) || (uint32) ptr_allocations[0] > (USER_HEAP_START+PAGE_SIZE)) panic("Wrong start address for the allocated space... check return address of malloc & updating of heap ptr");
  80011d:	8b 85 dc fe ff ff    	mov    -0x124(%ebp),%eax
  800123:	85 c0                	test   %eax,%eax
  800125:	79 0d                	jns    800134 <_main+0xfc>
  800127:	8b 85 dc fe ff ff    	mov    -0x124(%ebp),%eax
  80012d:	3d 00 10 00 80       	cmp    $0x80001000,%eax
  800132:	76 14                	jbe    800148 <_main+0x110>
  800134:	83 ec 04             	sub    $0x4,%esp
  800137:	68 f0 3d 80 00       	push   $0x803df0
  80013c:	6a 39                	push   $0x39
  80013e:	68 dc 3d 80 00       	push   $0x803ddc
  800143:	e8 20 0e 00 00       	call   800f68 <_panic>
		if ((sys_pf_calculate_allocated_pages() - usedDiskPages) != 0) panic("Extra or less pages are allocated in PageFile");
  800148:	e8 0d 25 00 00       	call   80265a <sys_pf_calculate_allocated_pages>
  80014d:	3b 45 c8             	cmp    -0x38(%ebp),%eax
  800150:	74 14                	je     800166 <_main+0x12e>
  800152:	83 ec 04             	sub    $0x4,%esp
  800155:	68 58 3e 80 00       	push   $0x803e58
  80015a:	6a 3a                	push   $0x3a
  80015c:	68 dc 3d 80 00       	push   $0x803ddc
  800161:	e8 02 0e 00 00       	call   800f68 <_panic>

		int freeFrames = sys_calculate_free_frames() ;
  800166:	e8 4f 24 00 00       	call   8025ba <sys_calculate_free_frames>
  80016b:	89 45 c4             	mov    %eax,-0x3c(%ebp)
		lastIndexOfByte = (2*Mega-kilo)/sizeof(char) - 1;
  80016e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800171:	01 c0                	add    %eax,%eax
  800173:	2b 45 e0             	sub    -0x20(%ebp),%eax
  800176:	48                   	dec    %eax
  800177:	89 45 c0             	mov    %eax,-0x40(%ebp)
		byteArr = (char *) ptr_allocations[0];
  80017a:	8b 85 dc fe ff ff    	mov    -0x124(%ebp),%eax
  800180:	89 45 bc             	mov    %eax,-0x44(%ebp)
		byteArr[0] = minByte ;
  800183:	8b 45 bc             	mov    -0x44(%ebp),%eax
  800186:	8a 55 df             	mov    -0x21(%ebp),%dl
  800189:	88 10                	mov    %dl,(%eax)
		byteArr[lastIndexOfByte] = maxByte ;
  80018b:	8b 55 c0             	mov    -0x40(%ebp),%edx
  80018e:	8b 45 bc             	mov    -0x44(%ebp),%eax
  800191:	01 c2                	add    %eax,%edx
  800193:	8a 45 de             	mov    -0x22(%ebp),%al
  800196:	88 02                	mov    %al,(%edx)
		if ((freeFrames - sys_calculate_free_frames()) != 2 + 1) panic("Wrong allocation: pages are not loaded successfully into memory/WS");
  800198:	8b 5d c4             	mov    -0x3c(%ebp),%ebx
  80019b:	e8 1a 24 00 00       	call   8025ba <sys_calculate_free_frames>
  8001a0:	29 c3                	sub    %eax,%ebx
  8001a2:	89 d8                	mov    %ebx,%eax
  8001a4:	83 f8 03             	cmp    $0x3,%eax
  8001a7:	74 14                	je     8001bd <_main+0x185>
  8001a9:	83 ec 04             	sub    $0x4,%esp
  8001ac:	68 88 3e 80 00       	push   $0x803e88
  8001b1:	6a 41                	push   $0x41
  8001b3:	68 dc 3d 80 00       	push   $0x803ddc
  8001b8:	e8 ab 0d 00 00       	call   800f68 <_panic>
		int var;
		int found = 0;
  8001bd:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		for (var = 0; var < (myEnv->page_WS_max_size); ++var)
  8001c4:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  8001cb:	e9 82 00 00 00       	jmp    800252 <_main+0x21a>
		{
			if(ROUNDDOWN(myEnv->__uptr_pws[var].virtual_address,PAGE_SIZE) == ROUNDDOWN((uint32)(&(byteArr[0])), PAGE_SIZE))
  8001d0:	a1 20 50 80 00       	mov    0x805020,%eax
  8001d5:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  8001db:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8001de:	89 d0                	mov    %edx,%eax
  8001e0:	01 c0                	add    %eax,%eax
  8001e2:	01 d0                	add    %edx,%eax
  8001e4:	c1 e0 03             	shl    $0x3,%eax
  8001e7:	01 c8                	add    %ecx,%eax
  8001e9:	8b 00                	mov    (%eax),%eax
  8001eb:	89 45 b8             	mov    %eax,-0x48(%ebp)
  8001ee:	8b 45 b8             	mov    -0x48(%ebp),%eax
  8001f1:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8001f6:	89 c2                	mov    %eax,%edx
  8001f8:	8b 45 bc             	mov    -0x44(%ebp),%eax
  8001fb:	89 45 b4             	mov    %eax,-0x4c(%ebp)
  8001fe:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  800201:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800206:	39 c2                	cmp    %eax,%edx
  800208:	75 03                	jne    80020d <_main+0x1d5>
				found++;
  80020a:	ff 45 e8             	incl   -0x18(%ebp)
			if(ROUNDDOWN(myEnv->__uptr_pws[var].virtual_address,PAGE_SIZE) == ROUNDDOWN((uint32)(&(byteArr[lastIndexOfByte])), PAGE_SIZE))
  80020d:	a1 20 50 80 00       	mov    0x805020,%eax
  800212:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  800218:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80021b:	89 d0                	mov    %edx,%eax
  80021d:	01 c0                	add    %eax,%eax
  80021f:	01 d0                	add    %edx,%eax
  800221:	c1 e0 03             	shl    $0x3,%eax
  800224:	01 c8                	add    %ecx,%eax
  800226:	8b 00                	mov    (%eax),%eax
  800228:	89 45 b0             	mov    %eax,-0x50(%ebp)
  80022b:	8b 45 b0             	mov    -0x50(%ebp),%eax
  80022e:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800233:	89 c1                	mov    %eax,%ecx
  800235:	8b 55 c0             	mov    -0x40(%ebp),%edx
  800238:	8b 45 bc             	mov    -0x44(%ebp),%eax
  80023b:	01 d0                	add    %edx,%eax
  80023d:	89 45 ac             	mov    %eax,-0x54(%ebp)
  800240:	8b 45 ac             	mov    -0x54(%ebp),%eax
  800243:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800248:	39 c1                	cmp    %eax,%ecx
  80024a:	75 03                	jne    80024f <_main+0x217>
				found++;
  80024c:	ff 45 e8             	incl   -0x18(%ebp)
		byteArr[0] = minByte ;
		byteArr[lastIndexOfByte] = maxByte ;
		if ((freeFrames - sys_calculate_free_frames()) != 2 + 1) panic("Wrong allocation: pages are not loaded successfully into memory/WS");
		int var;
		int found = 0;
		for (var = 0; var < (myEnv->page_WS_max_size); ++var)
  80024f:	ff 45 ec             	incl   -0x14(%ebp)
  800252:	a1 20 50 80 00       	mov    0x805020,%eax
  800257:	8b 50 74             	mov    0x74(%eax),%edx
  80025a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80025d:	39 c2                	cmp    %eax,%edx
  80025f:	0f 87 6b ff ff ff    	ja     8001d0 <_main+0x198>
			if(ROUNDDOWN(myEnv->__uptr_pws[var].virtual_address,PAGE_SIZE) == ROUNDDOWN((uint32)(&(byteArr[0])), PAGE_SIZE))
				found++;
			if(ROUNDDOWN(myEnv->__uptr_pws[var].virtual_address,PAGE_SIZE) == ROUNDDOWN((uint32)(&(byteArr[lastIndexOfByte])), PAGE_SIZE))
				found++;
		}
		if (found != 2) panic("malloc: page is not added to WS");
  800265:	83 7d e8 02          	cmpl   $0x2,-0x18(%ebp)
  800269:	74 14                	je     80027f <_main+0x247>
  80026b:	83 ec 04             	sub    $0x4,%esp
  80026e:	68 cc 3e 80 00       	push   $0x803ecc
  800273:	6a 4b                	push   $0x4b
  800275:	68 dc 3d 80 00       	push   $0x803ddc
  80027a:	e8 e9 0c 00 00       	call   800f68 <_panic>

		//2 MB
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  80027f:	e8 d6 23 00 00       	call   80265a <sys_pf_calculate_allocated_pages>
  800284:	89 45 c8             	mov    %eax,-0x38(%ebp)
		ptr_allocations[1] = malloc(2*Mega-kilo);
  800287:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80028a:	01 c0                	add    %eax,%eax
  80028c:	2b 45 e0             	sub    -0x20(%ebp),%eax
  80028f:	83 ec 0c             	sub    $0xc,%esp
  800292:	50                   	push   %eax
  800293:	e8 16 1f 00 00       	call   8021ae <malloc>
  800298:	83 c4 10             	add    $0x10,%esp
  80029b:	89 85 e0 fe ff ff    	mov    %eax,-0x120(%ebp)
		if ((uint32) ptr_allocations[1] < (USER_HEAP_START + 2*Mega) || (uint32) ptr_allocations[1] > (USER_HEAP_START+ 2*Mega+PAGE_SIZE)) panic("Wrong start address for the allocated space... check return address of malloc & updating of heap ptr");
  8002a1:	8b 85 e0 fe ff ff    	mov    -0x120(%ebp),%eax
  8002a7:	89 c2                	mov    %eax,%edx
  8002a9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8002ac:	01 c0                	add    %eax,%eax
  8002ae:	05 00 00 00 80       	add    $0x80000000,%eax
  8002b3:	39 c2                	cmp    %eax,%edx
  8002b5:	72 16                	jb     8002cd <_main+0x295>
  8002b7:	8b 85 e0 fe ff ff    	mov    -0x120(%ebp),%eax
  8002bd:	89 c2                	mov    %eax,%edx
  8002bf:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8002c2:	01 c0                	add    %eax,%eax
  8002c4:	2d 00 f0 ff 7f       	sub    $0x7ffff000,%eax
  8002c9:	39 c2                	cmp    %eax,%edx
  8002cb:	76 14                	jbe    8002e1 <_main+0x2a9>
  8002cd:	83 ec 04             	sub    $0x4,%esp
  8002d0:	68 f0 3d 80 00       	push   $0x803df0
  8002d5:	6a 50                	push   $0x50
  8002d7:	68 dc 3d 80 00       	push   $0x803ddc
  8002dc:	e8 87 0c 00 00       	call   800f68 <_panic>
		if ((sys_pf_calculate_allocated_pages() - usedDiskPages) != 0) panic("Extra or less pages are allocated in PageFile");
  8002e1:	e8 74 23 00 00       	call   80265a <sys_pf_calculate_allocated_pages>
  8002e6:	3b 45 c8             	cmp    -0x38(%ebp),%eax
  8002e9:	74 14                	je     8002ff <_main+0x2c7>
  8002eb:	83 ec 04             	sub    $0x4,%esp
  8002ee:	68 58 3e 80 00       	push   $0x803e58
  8002f3:	6a 51                	push   $0x51
  8002f5:	68 dc 3d 80 00       	push   $0x803ddc
  8002fa:	e8 69 0c 00 00       	call   800f68 <_panic>

		freeFrames = sys_calculate_free_frames() ;
  8002ff:	e8 b6 22 00 00       	call   8025ba <sys_calculate_free_frames>
  800304:	89 45 c4             	mov    %eax,-0x3c(%ebp)
		shortArr = (short *) ptr_allocations[1];
  800307:	8b 85 e0 fe ff ff    	mov    -0x120(%ebp),%eax
  80030d:	89 45 a8             	mov    %eax,-0x58(%ebp)
		lastIndexOfShort = (2*Mega-kilo)/sizeof(short) - 1;
  800310:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800313:	01 c0                	add    %eax,%eax
  800315:	2b 45 e0             	sub    -0x20(%ebp),%eax
  800318:	d1 e8                	shr    %eax
  80031a:	48                   	dec    %eax
  80031b:	89 45 a4             	mov    %eax,-0x5c(%ebp)
		shortArr[0] = minShort;
  80031e:	8b 55 a8             	mov    -0x58(%ebp),%edx
  800321:	8b 45 dc             	mov    -0x24(%ebp),%eax
  800324:	66 89 02             	mov    %ax,(%edx)
		shortArr[lastIndexOfShort] = maxShort;
  800327:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  80032a:	01 c0                	add    %eax,%eax
  80032c:	89 c2                	mov    %eax,%edx
  80032e:	8b 45 a8             	mov    -0x58(%ebp),%eax
  800331:	01 c2                	add    %eax,%edx
  800333:	66 8b 45 da          	mov    -0x26(%ebp),%ax
  800337:	66 89 02             	mov    %ax,(%edx)
		if ((freeFrames - sys_calculate_free_frames()) != 2 ) panic("Wrong allocation: pages are not loaded successfully into memory/WS");
  80033a:	8b 5d c4             	mov    -0x3c(%ebp),%ebx
  80033d:	e8 78 22 00 00       	call   8025ba <sys_calculate_free_frames>
  800342:	29 c3                	sub    %eax,%ebx
  800344:	89 d8                	mov    %ebx,%eax
  800346:	83 f8 02             	cmp    $0x2,%eax
  800349:	74 14                	je     80035f <_main+0x327>
  80034b:	83 ec 04             	sub    $0x4,%esp
  80034e:	68 88 3e 80 00       	push   $0x803e88
  800353:	6a 58                	push   $0x58
  800355:	68 dc 3d 80 00       	push   $0x803ddc
  80035a:	e8 09 0c 00 00       	call   800f68 <_panic>
		found = 0;
  80035f:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		for (var = 0; var < (myEnv->page_WS_max_size); ++var)
  800366:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  80036d:	e9 86 00 00 00       	jmp    8003f8 <_main+0x3c0>
		{
			if(ROUNDDOWN(myEnv->__uptr_pws[var].virtual_address,PAGE_SIZE) == ROUNDDOWN((uint32)(&(shortArr[0])), PAGE_SIZE))
  800372:	a1 20 50 80 00       	mov    0x805020,%eax
  800377:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  80037d:	8b 55 ec             	mov    -0x14(%ebp),%edx
  800380:	89 d0                	mov    %edx,%eax
  800382:	01 c0                	add    %eax,%eax
  800384:	01 d0                	add    %edx,%eax
  800386:	c1 e0 03             	shl    $0x3,%eax
  800389:	01 c8                	add    %ecx,%eax
  80038b:	8b 00                	mov    (%eax),%eax
  80038d:	89 45 a0             	mov    %eax,-0x60(%ebp)
  800390:	8b 45 a0             	mov    -0x60(%ebp),%eax
  800393:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800398:	89 c2                	mov    %eax,%edx
  80039a:	8b 45 a8             	mov    -0x58(%ebp),%eax
  80039d:	89 45 9c             	mov    %eax,-0x64(%ebp)
  8003a0:	8b 45 9c             	mov    -0x64(%ebp),%eax
  8003a3:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8003a8:	39 c2                	cmp    %eax,%edx
  8003aa:	75 03                	jne    8003af <_main+0x377>
				found++;
  8003ac:	ff 45 e8             	incl   -0x18(%ebp)
			if(ROUNDDOWN(myEnv->__uptr_pws[var].virtual_address,PAGE_SIZE) == ROUNDDOWN((uint32)(&(shortArr[lastIndexOfShort])), PAGE_SIZE))
  8003af:	a1 20 50 80 00       	mov    0x805020,%eax
  8003b4:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  8003ba:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8003bd:	89 d0                	mov    %edx,%eax
  8003bf:	01 c0                	add    %eax,%eax
  8003c1:	01 d0                	add    %edx,%eax
  8003c3:	c1 e0 03             	shl    $0x3,%eax
  8003c6:	01 c8                	add    %ecx,%eax
  8003c8:	8b 00                	mov    (%eax),%eax
  8003ca:	89 45 98             	mov    %eax,-0x68(%ebp)
  8003cd:	8b 45 98             	mov    -0x68(%ebp),%eax
  8003d0:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8003d5:	89 c2                	mov    %eax,%edx
  8003d7:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  8003da:	01 c0                	add    %eax,%eax
  8003dc:	89 c1                	mov    %eax,%ecx
  8003de:	8b 45 a8             	mov    -0x58(%ebp),%eax
  8003e1:	01 c8                	add    %ecx,%eax
  8003e3:	89 45 94             	mov    %eax,-0x6c(%ebp)
  8003e6:	8b 45 94             	mov    -0x6c(%ebp),%eax
  8003e9:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8003ee:	39 c2                	cmp    %eax,%edx
  8003f0:	75 03                	jne    8003f5 <_main+0x3bd>
				found++;
  8003f2:	ff 45 e8             	incl   -0x18(%ebp)
		lastIndexOfShort = (2*Mega-kilo)/sizeof(short) - 1;
		shortArr[0] = minShort;
		shortArr[lastIndexOfShort] = maxShort;
		if ((freeFrames - sys_calculate_free_frames()) != 2 ) panic("Wrong allocation: pages are not loaded successfully into memory/WS");
		found = 0;
		for (var = 0; var < (myEnv->page_WS_max_size); ++var)
  8003f5:	ff 45 ec             	incl   -0x14(%ebp)
  8003f8:	a1 20 50 80 00       	mov    0x805020,%eax
  8003fd:	8b 50 74             	mov    0x74(%eax),%edx
  800400:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800403:	39 c2                	cmp    %eax,%edx
  800405:	0f 87 67 ff ff ff    	ja     800372 <_main+0x33a>
			if(ROUNDDOWN(myEnv->__uptr_pws[var].virtual_address,PAGE_SIZE) == ROUNDDOWN((uint32)(&(shortArr[0])), PAGE_SIZE))
				found++;
			if(ROUNDDOWN(myEnv->__uptr_pws[var].virtual_address,PAGE_SIZE) == ROUNDDOWN((uint32)(&(shortArr[lastIndexOfShort])), PAGE_SIZE))
				found++;
		}
		if (found != 2) panic("malloc: page is not added to WS");
  80040b:	83 7d e8 02          	cmpl   $0x2,-0x18(%ebp)
  80040f:	74 14                	je     800425 <_main+0x3ed>
  800411:	83 ec 04             	sub    $0x4,%esp
  800414:	68 cc 3e 80 00       	push   $0x803ecc
  800419:	6a 61                	push   $0x61
  80041b:	68 dc 3d 80 00       	push   $0x803ddc
  800420:	e8 43 0b 00 00       	call   800f68 <_panic>

		//3 KB
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  800425:	e8 30 22 00 00       	call   80265a <sys_pf_calculate_allocated_pages>
  80042a:	89 45 c8             	mov    %eax,-0x38(%ebp)
		ptr_allocations[2] = malloc(3*kilo);
  80042d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800430:	89 c2                	mov    %eax,%edx
  800432:	01 d2                	add    %edx,%edx
  800434:	01 d0                	add    %edx,%eax
  800436:	83 ec 0c             	sub    $0xc,%esp
  800439:	50                   	push   %eax
  80043a:	e8 6f 1d 00 00       	call   8021ae <malloc>
  80043f:	83 c4 10             	add    $0x10,%esp
  800442:	89 85 e4 fe ff ff    	mov    %eax,-0x11c(%ebp)
		if ((uint32) ptr_allocations[2] < (USER_HEAP_START + 4*Mega) || (uint32) ptr_allocations[2] > (USER_HEAP_START+ 4*Mega+PAGE_SIZE)) panic("Wrong start address for the allocated space... check return address of malloc & updating of heap ptr");
  800448:	8b 85 e4 fe ff ff    	mov    -0x11c(%ebp),%eax
  80044e:	89 c2                	mov    %eax,%edx
  800450:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800453:	c1 e0 02             	shl    $0x2,%eax
  800456:	05 00 00 00 80       	add    $0x80000000,%eax
  80045b:	39 c2                	cmp    %eax,%edx
  80045d:	72 17                	jb     800476 <_main+0x43e>
  80045f:	8b 85 e4 fe ff ff    	mov    -0x11c(%ebp),%eax
  800465:	89 c2                	mov    %eax,%edx
  800467:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80046a:	c1 e0 02             	shl    $0x2,%eax
  80046d:	2d 00 f0 ff 7f       	sub    $0x7ffff000,%eax
  800472:	39 c2                	cmp    %eax,%edx
  800474:	76 14                	jbe    80048a <_main+0x452>
  800476:	83 ec 04             	sub    $0x4,%esp
  800479:	68 f0 3d 80 00       	push   $0x803df0
  80047e:	6a 66                	push   $0x66
  800480:	68 dc 3d 80 00       	push   $0x803ddc
  800485:	e8 de 0a 00 00       	call   800f68 <_panic>
		if ((sys_pf_calculate_allocated_pages() - usedDiskPages) != 0) panic("Extra or less pages are allocated in PageFile");
  80048a:	e8 cb 21 00 00       	call   80265a <sys_pf_calculate_allocated_pages>
  80048f:	3b 45 c8             	cmp    -0x38(%ebp),%eax
  800492:	74 14                	je     8004a8 <_main+0x470>
  800494:	83 ec 04             	sub    $0x4,%esp
  800497:	68 58 3e 80 00       	push   $0x803e58
  80049c:	6a 67                	push   $0x67
  80049e:	68 dc 3d 80 00       	push   $0x803ddc
  8004a3:	e8 c0 0a 00 00       	call   800f68 <_panic>

		freeFrames = sys_calculate_free_frames() ;
  8004a8:	e8 0d 21 00 00       	call   8025ba <sys_calculate_free_frames>
  8004ad:	89 45 c4             	mov    %eax,-0x3c(%ebp)
		intArr = (int *) ptr_allocations[2];
  8004b0:	8b 85 e4 fe ff ff    	mov    -0x11c(%ebp),%eax
  8004b6:	89 45 90             	mov    %eax,-0x70(%ebp)
		lastIndexOfInt = (2*kilo)/sizeof(int) - 1;
  8004b9:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8004bc:	01 c0                	add    %eax,%eax
  8004be:	c1 e8 02             	shr    $0x2,%eax
  8004c1:	48                   	dec    %eax
  8004c2:	89 45 8c             	mov    %eax,-0x74(%ebp)
		intArr[0] = minInt;
  8004c5:	8b 45 90             	mov    -0x70(%ebp),%eax
  8004c8:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  8004cb:	89 10                	mov    %edx,(%eax)
		intArr[lastIndexOfInt] = maxInt;
  8004cd:	8b 45 8c             	mov    -0x74(%ebp),%eax
  8004d0:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8004d7:	8b 45 90             	mov    -0x70(%ebp),%eax
  8004da:	01 c2                	add    %eax,%edx
  8004dc:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8004df:	89 02                	mov    %eax,(%edx)
		if ((freeFrames - sys_calculate_free_frames()) != 1 + 1) panic("Wrong allocation: pages are not loaded successfully into memory/WS");
  8004e1:	8b 5d c4             	mov    -0x3c(%ebp),%ebx
  8004e4:	e8 d1 20 00 00       	call   8025ba <sys_calculate_free_frames>
  8004e9:	29 c3                	sub    %eax,%ebx
  8004eb:	89 d8                	mov    %ebx,%eax
  8004ed:	83 f8 02             	cmp    $0x2,%eax
  8004f0:	74 14                	je     800506 <_main+0x4ce>
  8004f2:	83 ec 04             	sub    $0x4,%esp
  8004f5:	68 88 3e 80 00       	push   $0x803e88
  8004fa:	6a 6e                	push   $0x6e
  8004fc:	68 dc 3d 80 00       	push   $0x803ddc
  800501:	e8 62 0a 00 00       	call   800f68 <_panic>
		found = 0;
  800506:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		for (var = 0; var < (myEnv->page_WS_max_size); ++var)
  80050d:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  800514:	e9 8f 00 00 00       	jmp    8005a8 <_main+0x570>
		{
			if(ROUNDDOWN(myEnv->__uptr_pws[var].virtual_address,PAGE_SIZE) == ROUNDDOWN((uint32)(&(intArr[0])), PAGE_SIZE))
  800519:	a1 20 50 80 00       	mov    0x805020,%eax
  80051e:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  800524:	8b 55 ec             	mov    -0x14(%ebp),%edx
  800527:	89 d0                	mov    %edx,%eax
  800529:	01 c0                	add    %eax,%eax
  80052b:	01 d0                	add    %edx,%eax
  80052d:	c1 e0 03             	shl    $0x3,%eax
  800530:	01 c8                	add    %ecx,%eax
  800532:	8b 00                	mov    (%eax),%eax
  800534:	89 45 88             	mov    %eax,-0x78(%ebp)
  800537:	8b 45 88             	mov    -0x78(%ebp),%eax
  80053a:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80053f:	89 c2                	mov    %eax,%edx
  800541:	8b 45 90             	mov    -0x70(%ebp),%eax
  800544:	89 45 84             	mov    %eax,-0x7c(%ebp)
  800547:	8b 45 84             	mov    -0x7c(%ebp),%eax
  80054a:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80054f:	39 c2                	cmp    %eax,%edx
  800551:	75 03                	jne    800556 <_main+0x51e>
				found++;
  800553:	ff 45 e8             	incl   -0x18(%ebp)
			if(ROUNDDOWN(myEnv->__uptr_pws[var].virtual_address,PAGE_SIZE) == ROUNDDOWN((uint32)(&(intArr[lastIndexOfInt])), PAGE_SIZE))
  800556:	a1 20 50 80 00       	mov    0x805020,%eax
  80055b:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  800561:	8b 55 ec             	mov    -0x14(%ebp),%edx
  800564:	89 d0                	mov    %edx,%eax
  800566:	01 c0                	add    %eax,%eax
  800568:	01 d0                	add    %edx,%eax
  80056a:	c1 e0 03             	shl    $0x3,%eax
  80056d:	01 c8                	add    %ecx,%eax
  80056f:	8b 00                	mov    (%eax),%eax
  800571:	89 45 80             	mov    %eax,-0x80(%ebp)
  800574:	8b 45 80             	mov    -0x80(%ebp),%eax
  800577:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80057c:	89 c2                	mov    %eax,%edx
  80057e:	8b 45 8c             	mov    -0x74(%ebp),%eax
  800581:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  800588:	8b 45 90             	mov    -0x70(%ebp),%eax
  80058b:	01 c8                	add    %ecx,%eax
  80058d:	89 85 7c ff ff ff    	mov    %eax,-0x84(%ebp)
  800593:	8b 85 7c ff ff ff    	mov    -0x84(%ebp),%eax
  800599:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80059e:	39 c2                	cmp    %eax,%edx
  8005a0:	75 03                	jne    8005a5 <_main+0x56d>
				found++;
  8005a2:	ff 45 e8             	incl   -0x18(%ebp)
		lastIndexOfInt = (2*kilo)/sizeof(int) - 1;
		intArr[0] = minInt;
		intArr[lastIndexOfInt] = maxInt;
		if ((freeFrames - sys_calculate_free_frames()) != 1 + 1) panic("Wrong allocation: pages are not loaded successfully into memory/WS");
		found = 0;
		for (var = 0; var < (myEnv->page_WS_max_size); ++var)
  8005a5:	ff 45 ec             	incl   -0x14(%ebp)
  8005a8:	a1 20 50 80 00       	mov    0x805020,%eax
  8005ad:	8b 50 74             	mov    0x74(%eax),%edx
  8005b0:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8005b3:	39 c2                	cmp    %eax,%edx
  8005b5:	0f 87 5e ff ff ff    	ja     800519 <_main+0x4e1>
			if(ROUNDDOWN(myEnv->__uptr_pws[var].virtual_address,PAGE_SIZE) == ROUNDDOWN((uint32)(&(intArr[0])), PAGE_SIZE))
				found++;
			if(ROUNDDOWN(myEnv->__uptr_pws[var].virtual_address,PAGE_SIZE) == ROUNDDOWN((uint32)(&(intArr[lastIndexOfInt])), PAGE_SIZE))
				found++;
		}
		if (found != 2) panic("malloc: page is not added to WS");
  8005bb:	83 7d e8 02          	cmpl   $0x2,-0x18(%ebp)
  8005bf:	74 14                	je     8005d5 <_main+0x59d>
  8005c1:	83 ec 04             	sub    $0x4,%esp
  8005c4:	68 cc 3e 80 00       	push   $0x803ecc
  8005c9:	6a 77                	push   $0x77
  8005cb:	68 dc 3d 80 00       	push   $0x803ddc
  8005d0:	e8 93 09 00 00       	call   800f68 <_panic>

		//3 KB
		freeFrames = sys_calculate_free_frames() ;
  8005d5:	e8 e0 1f 00 00       	call   8025ba <sys_calculate_free_frames>
  8005da:	89 45 c4             	mov    %eax,-0x3c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  8005dd:	e8 78 20 00 00       	call   80265a <sys_pf_calculate_allocated_pages>
  8005e2:	89 45 c8             	mov    %eax,-0x38(%ebp)
		ptr_allocations[3] = malloc(3*kilo);
  8005e5:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8005e8:	89 c2                	mov    %eax,%edx
  8005ea:	01 d2                	add    %edx,%edx
  8005ec:	01 d0                	add    %edx,%eax
  8005ee:	83 ec 0c             	sub    $0xc,%esp
  8005f1:	50                   	push   %eax
  8005f2:	e8 b7 1b 00 00       	call   8021ae <malloc>
  8005f7:	83 c4 10             	add    $0x10,%esp
  8005fa:	89 85 e8 fe ff ff    	mov    %eax,-0x118(%ebp)
		if ((uint32) ptr_allocations[3] < (USER_HEAP_START + 4*Mega + 4*kilo) || (uint32) ptr_allocations[3] > (USER_HEAP_START+ 4*Mega + 4*kilo +PAGE_SIZE)) panic("Wrong start address for the allocated space... check return address of malloc & updating of heap ptr");
  800600:	8b 85 e8 fe ff ff    	mov    -0x118(%ebp),%eax
  800606:	89 c2                	mov    %eax,%edx
  800608:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80060b:	c1 e0 02             	shl    $0x2,%eax
  80060e:	89 c1                	mov    %eax,%ecx
  800610:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800613:	c1 e0 02             	shl    $0x2,%eax
  800616:	01 c8                	add    %ecx,%eax
  800618:	05 00 00 00 80       	add    $0x80000000,%eax
  80061d:	39 c2                	cmp    %eax,%edx
  80061f:	72 21                	jb     800642 <_main+0x60a>
  800621:	8b 85 e8 fe ff ff    	mov    -0x118(%ebp),%eax
  800627:	89 c2                	mov    %eax,%edx
  800629:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80062c:	c1 e0 02             	shl    $0x2,%eax
  80062f:	89 c1                	mov    %eax,%ecx
  800631:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800634:	c1 e0 02             	shl    $0x2,%eax
  800637:	01 c8                	add    %ecx,%eax
  800639:	2d 00 f0 ff 7f       	sub    $0x7ffff000,%eax
  80063e:	39 c2                	cmp    %eax,%edx
  800640:	76 14                	jbe    800656 <_main+0x61e>
  800642:	83 ec 04             	sub    $0x4,%esp
  800645:	68 f0 3d 80 00       	push   $0x803df0
  80064a:	6a 7d                	push   $0x7d
  80064c:	68 dc 3d 80 00       	push   $0x803ddc
  800651:	e8 12 09 00 00       	call   800f68 <_panic>
		if ((sys_pf_calculate_allocated_pages() - usedDiskPages) != 0) panic("Extra or less pages are allocated in PageFile");
  800656:	e8 ff 1f 00 00       	call   80265a <sys_pf_calculate_allocated_pages>
  80065b:	3b 45 c8             	cmp    -0x38(%ebp),%eax
  80065e:	74 14                	je     800674 <_main+0x63c>
  800660:	83 ec 04             	sub    $0x4,%esp
  800663:	68 58 3e 80 00       	push   $0x803e58
  800668:	6a 7e                	push   $0x7e
  80066a:	68 dc 3d 80 00       	push   $0x803ddc
  80066f:	e8 f4 08 00 00       	call   800f68 <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 0) panic("Wrong allocation: ");

		//7 KB
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  800674:	e8 e1 1f 00 00       	call   80265a <sys_pf_calculate_allocated_pages>
  800679:	89 45 c8             	mov    %eax,-0x38(%ebp)
		ptr_allocations[4] = malloc(7*kilo);
  80067c:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80067f:	89 d0                	mov    %edx,%eax
  800681:	01 c0                	add    %eax,%eax
  800683:	01 d0                	add    %edx,%eax
  800685:	01 c0                	add    %eax,%eax
  800687:	01 d0                	add    %edx,%eax
  800689:	83 ec 0c             	sub    $0xc,%esp
  80068c:	50                   	push   %eax
  80068d:	e8 1c 1b 00 00       	call   8021ae <malloc>
  800692:	83 c4 10             	add    $0x10,%esp
  800695:	89 85 ec fe ff ff    	mov    %eax,-0x114(%ebp)
		if ((uint32) ptr_allocations[4] < (USER_HEAP_START + 4*Mega + 8*kilo)|| (uint32) ptr_allocations[4] > (USER_HEAP_START+ 4*Mega + 8*kilo +PAGE_SIZE)) panic("Wrong start address for the allocated space... check return address of malloc & updating of heap ptr");
  80069b:	8b 85 ec fe ff ff    	mov    -0x114(%ebp),%eax
  8006a1:	89 c2                	mov    %eax,%edx
  8006a3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8006a6:	c1 e0 02             	shl    $0x2,%eax
  8006a9:	89 c1                	mov    %eax,%ecx
  8006ab:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8006ae:	c1 e0 03             	shl    $0x3,%eax
  8006b1:	01 c8                	add    %ecx,%eax
  8006b3:	05 00 00 00 80       	add    $0x80000000,%eax
  8006b8:	39 c2                	cmp    %eax,%edx
  8006ba:	72 21                	jb     8006dd <_main+0x6a5>
  8006bc:	8b 85 ec fe ff ff    	mov    -0x114(%ebp),%eax
  8006c2:	89 c2                	mov    %eax,%edx
  8006c4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8006c7:	c1 e0 02             	shl    $0x2,%eax
  8006ca:	89 c1                	mov    %eax,%ecx
  8006cc:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8006cf:	c1 e0 03             	shl    $0x3,%eax
  8006d2:	01 c8                	add    %ecx,%eax
  8006d4:	2d 00 f0 ff 7f       	sub    $0x7ffff000,%eax
  8006d9:	39 c2                	cmp    %eax,%edx
  8006db:	76 17                	jbe    8006f4 <_main+0x6bc>
  8006dd:	83 ec 04             	sub    $0x4,%esp
  8006e0:	68 f0 3d 80 00       	push   $0x803df0
  8006e5:	68 84 00 00 00       	push   $0x84
  8006ea:	68 dc 3d 80 00       	push   $0x803ddc
  8006ef:	e8 74 08 00 00       	call   800f68 <_panic>
		if ((sys_pf_calculate_allocated_pages() - usedDiskPages) != 0) panic("Extra or less pages are allocated in PageFile");
  8006f4:	e8 61 1f 00 00       	call   80265a <sys_pf_calculate_allocated_pages>
  8006f9:	3b 45 c8             	cmp    -0x38(%ebp),%eax
  8006fc:	74 17                	je     800715 <_main+0x6dd>
  8006fe:	83 ec 04             	sub    $0x4,%esp
  800701:	68 58 3e 80 00       	push   $0x803e58
  800706:	68 85 00 00 00       	push   $0x85
  80070b:	68 dc 3d 80 00       	push   $0x803ddc
  800710:	e8 53 08 00 00       	call   800f68 <_panic>

		freeFrames = sys_calculate_free_frames() ;
  800715:	e8 a0 1e 00 00       	call   8025ba <sys_calculate_free_frames>
  80071a:	89 45 c4             	mov    %eax,-0x3c(%ebp)
		structArr = (struct MyStruct *) ptr_allocations[4];
  80071d:	8b 85 ec fe ff ff    	mov    -0x114(%ebp),%eax
  800723:	89 85 78 ff ff ff    	mov    %eax,-0x88(%ebp)
		lastIndexOfStruct = (7*kilo)/sizeof(struct MyStruct) - 1;
  800729:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80072c:	89 d0                	mov    %edx,%eax
  80072e:	01 c0                	add    %eax,%eax
  800730:	01 d0                	add    %edx,%eax
  800732:	01 c0                	add    %eax,%eax
  800734:	01 d0                	add    %edx,%eax
  800736:	c1 e8 03             	shr    $0x3,%eax
  800739:	48                   	dec    %eax
  80073a:	89 85 74 ff ff ff    	mov    %eax,-0x8c(%ebp)
		structArr[0].a = minByte; structArr[0].b = minShort; structArr[0].c = minInt;
  800740:	8b 85 78 ff ff ff    	mov    -0x88(%ebp),%eax
  800746:	8a 55 df             	mov    -0x21(%ebp),%dl
  800749:	88 10                	mov    %dl,(%eax)
  80074b:	8b 95 78 ff ff ff    	mov    -0x88(%ebp),%edx
  800751:	8b 45 dc             	mov    -0x24(%ebp),%eax
  800754:	66 89 42 02          	mov    %ax,0x2(%edx)
  800758:	8b 85 78 ff ff ff    	mov    -0x88(%ebp),%eax
  80075e:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  800761:	89 50 04             	mov    %edx,0x4(%eax)
		structArr[lastIndexOfStruct].a = maxByte; structArr[lastIndexOfStruct].b = maxShort; structArr[lastIndexOfStruct].c = maxInt;
  800764:	8b 85 74 ff ff ff    	mov    -0x8c(%ebp),%eax
  80076a:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
  800771:	8b 85 78 ff ff ff    	mov    -0x88(%ebp),%eax
  800777:	01 c2                	add    %eax,%edx
  800779:	8a 45 de             	mov    -0x22(%ebp),%al
  80077c:	88 02                	mov    %al,(%edx)
  80077e:	8b 85 74 ff ff ff    	mov    -0x8c(%ebp),%eax
  800784:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
  80078b:	8b 85 78 ff ff ff    	mov    -0x88(%ebp),%eax
  800791:	01 c2                	add    %eax,%edx
  800793:	66 8b 45 da          	mov    -0x26(%ebp),%ax
  800797:	66 89 42 02          	mov    %ax,0x2(%edx)
  80079b:	8b 85 74 ff ff ff    	mov    -0x8c(%ebp),%eax
  8007a1:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
  8007a8:	8b 85 78 ff ff ff    	mov    -0x88(%ebp),%eax
  8007ae:	01 c2                	add    %eax,%edx
  8007b0:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8007b3:	89 42 04             	mov    %eax,0x4(%edx)
		if ((freeFrames - sys_calculate_free_frames()) != 2) panic("Wrong allocation: pages are not loaded successfully into memory/WS");
  8007b6:	8b 5d c4             	mov    -0x3c(%ebp),%ebx
  8007b9:	e8 fc 1d 00 00       	call   8025ba <sys_calculate_free_frames>
  8007be:	29 c3                	sub    %eax,%ebx
  8007c0:	89 d8                	mov    %ebx,%eax
  8007c2:	83 f8 02             	cmp    $0x2,%eax
  8007c5:	74 17                	je     8007de <_main+0x7a6>
  8007c7:	83 ec 04             	sub    $0x4,%esp
  8007ca:	68 88 3e 80 00       	push   $0x803e88
  8007cf:	68 8c 00 00 00       	push   $0x8c
  8007d4:	68 dc 3d 80 00       	push   $0x803ddc
  8007d9:	e8 8a 07 00 00       	call   800f68 <_panic>
		found = 0;
  8007de:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		for (var = 0; var < (myEnv->page_WS_max_size); ++var)
  8007e5:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  8007ec:	e9 aa 00 00 00       	jmp    80089b <_main+0x863>
		{
			if(ROUNDDOWN(myEnv->__uptr_pws[var].virtual_address,PAGE_SIZE) == ROUNDDOWN((uint32)(&(structArr[0])), PAGE_SIZE))
  8007f1:	a1 20 50 80 00       	mov    0x805020,%eax
  8007f6:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  8007fc:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8007ff:	89 d0                	mov    %edx,%eax
  800801:	01 c0                	add    %eax,%eax
  800803:	01 d0                	add    %edx,%eax
  800805:	c1 e0 03             	shl    $0x3,%eax
  800808:	01 c8                	add    %ecx,%eax
  80080a:	8b 00                	mov    (%eax),%eax
  80080c:	89 85 70 ff ff ff    	mov    %eax,-0x90(%ebp)
  800812:	8b 85 70 ff ff ff    	mov    -0x90(%ebp),%eax
  800818:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80081d:	89 c2                	mov    %eax,%edx
  80081f:	8b 85 78 ff ff ff    	mov    -0x88(%ebp),%eax
  800825:	89 85 6c ff ff ff    	mov    %eax,-0x94(%ebp)
  80082b:	8b 85 6c ff ff ff    	mov    -0x94(%ebp),%eax
  800831:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800836:	39 c2                	cmp    %eax,%edx
  800838:	75 03                	jne    80083d <_main+0x805>
				found++;
  80083a:	ff 45 e8             	incl   -0x18(%ebp)
			if(ROUNDDOWN(myEnv->__uptr_pws[var].virtual_address,PAGE_SIZE) == ROUNDDOWN((uint32)(&(structArr[lastIndexOfStruct])), PAGE_SIZE))
  80083d:	a1 20 50 80 00       	mov    0x805020,%eax
  800842:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  800848:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80084b:	89 d0                	mov    %edx,%eax
  80084d:	01 c0                	add    %eax,%eax
  80084f:	01 d0                	add    %edx,%eax
  800851:	c1 e0 03             	shl    $0x3,%eax
  800854:	01 c8                	add    %ecx,%eax
  800856:	8b 00                	mov    (%eax),%eax
  800858:	89 85 68 ff ff ff    	mov    %eax,-0x98(%ebp)
  80085e:	8b 85 68 ff ff ff    	mov    -0x98(%ebp),%eax
  800864:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800869:	89 c2                	mov    %eax,%edx
  80086b:	8b 85 74 ff ff ff    	mov    -0x8c(%ebp),%eax
  800871:	8d 0c c5 00 00 00 00 	lea    0x0(,%eax,8),%ecx
  800878:	8b 85 78 ff ff ff    	mov    -0x88(%ebp),%eax
  80087e:	01 c8                	add    %ecx,%eax
  800880:	89 85 64 ff ff ff    	mov    %eax,-0x9c(%ebp)
  800886:	8b 85 64 ff ff ff    	mov    -0x9c(%ebp),%eax
  80088c:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800891:	39 c2                	cmp    %eax,%edx
  800893:	75 03                	jne    800898 <_main+0x860>
				found++;
  800895:	ff 45 e8             	incl   -0x18(%ebp)
		lastIndexOfStruct = (7*kilo)/sizeof(struct MyStruct) - 1;
		structArr[0].a = minByte; structArr[0].b = minShort; structArr[0].c = minInt;
		structArr[lastIndexOfStruct].a = maxByte; structArr[lastIndexOfStruct].b = maxShort; structArr[lastIndexOfStruct].c = maxInt;
		if ((freeFrames - sys_calculate_free_frames()) != 2) panic("Wrong allocation: pages are not loaded successfully into memory/WS");
		found = 0;
		for (var = 0; var < (myEnv->page_WS_max_size); ++var)
  800898:	ff 45 ec             	incl   -0x14(%ebp)
  80089b:	a1 20 50 80 00       	mov    0x805020,%eax
  8008a0:	8b 50 74             	mov    0x74(%eax),%edx
  8008a3:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8008a6:	39 c2                	cmp    %eax,%edx
  8008a8:	0f 87 43 ff ff ff    	ja     8007f1 <_main+0x7b9>
			if(ROUNDDOWN(myEnv->__uptr_pws[var].virtual_address,PAGE_SIZE) == ROUNDDOWN((uint32)(&(structArr[0])), PAGE_SIZE))
				found++;
			if(ROUNDDOWN(myEnv->__uptr_pws[var].virtual_address,PAGE_SIZE) == ROUNDDOWN((uint32)(&(structArr[lastIndexOfStruct])), PAGE_SIZE))
				found++;
		}
		if (found != 2) panic("malloc: page is not added to WS");
  8008ae:	83 7d e8 02          	cmpl   $0x2,-0x18(%ebp)
  8008b2:	74 17                	je     8008cb <_main+0x893>
  8008b4:	83 ec 04             	sub    $0x4,%esp
  8008b7:	68 cc 3e 80 00       	push   $0x803ecc
  8008bc:	68 95 00 00 00       	push   $0x95
  8008c1:	68 dc 3d 80 00       	push   $0x803ddc
  8008c6:	e8 9d 06 00 00       	call   800f68 <_panic>

		//3 MB
		freeFrames = sys_calculate_free_frames() ;
  8008cb:	e8 ea 1c 00 00       	call   8025ba <sys_calculate_free_frames>
  8008d0:	89 45 c4             	mov    %eax,-0x3c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  8008d3:	e8 82 1d 00 00       	call   80265a <sys_pf_calculate_allocated_pages>
  8008d8:	89 45 c8             	mov    %eax,-0x38(%ebp)
		ptr_allocations[5] = malloc(3*Mega-kilo);
  8008db:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8008de:	89 c2                	mov    %eax,%edx
  8008e0:	01 d2                	add    %edx,%edx
  8008e2:	01 d0                	add    %edx,%eax
  8008e4:	2b 45 e0             	sub    -0x20(%ebp),%eax
  8008e7:	83 ec 0c             	sub    $0xc,%esp
  8008ea:	50                   	push   %eax
  8008eb:	e8 be 18 00 00       	call   8021ae <malloc>
  8008f0:	83 c4 10             	add    $0x10,%esp
  8008f3:	89 85 f0 fe ff ff    	mov    %eax,-0x110(%ebp)
		if ((uint32) ptr_allocations[5] < (USER_HEAP_START + 4*Mega + 16*kilo) || (uint32) ptr_allocations[5] > (USER_HEAP_START+ 4*Mega + 16*kilo +PAGE_SIZE)) panic("Wrong start address for the allocated space... check return address of malloc & updating of heap ptr");
  8008f9:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
  8008ff:	89 c2                	mov    %eax,%edx
  800901:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800904:	c1 e0 02             	shl    $0x2,%eax
  800907:	89 c1                	mov    %eax,%ecx
  800909:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80090c:	c1 e0 04             	shl    $0x4,%eax
  80090f:	01 c8                	add    %ecx,%eax
  800911:	05 00 00 00 80       	add    $0x80000000,%eax
  800916:	39 c2                	cmp    %eax,%edx
  800918:	72 21                	jb     80093b <_main+0x903>
  80091a:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
  800920:	89 c2                	mov    %eax,%edx
  800922:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800925:	c1 e0 02             	shl    $0x2,%eax
  800928:	89 c1                	mov    %eax,%ecx
  80092a:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80092d:	c1 e0 04             	shl    $0x4,%eax
  800930:	01 c8                	add    %ecx,%eax
  800932:	2d 00 f0 ff 7f       	sub    $0x7ffff000,%eax
  800937:	39 c2                	cmp    %eax,%edx
  800939:	76 17                	jbe    800952 <_main+0x91a>
  80093b:	83 ec 04             	sub    $0x4,%esp
  80093e:	68 f0 3d 80 00       	push   $0x803df0
  800943:	68 9b 00 00 00       	push   $0x9b
  800948:	68 dc 3d 80 00       	push   $0x803ddc
  80094d:	e8 16 06 00 00       	call   800f68 <_panic>
		if ((sys_pf_calculate_allocated_pages() - usedDiskPages) != 0) panic("Extra or less pages are allocated in PageFile");
  800952:	e8 03 1d 00 00       	call   80265a <sys_pf_calculate_allocated_pages>
  800957:	3b 45 c8             	cmp    -0x38(%ebp),%eax
  80095a:	74 17                	je     800973 <_main+0x93b>
  80095c:	83 ec 04             	sub    $0x4,%esp
  80095f:	68 58 3e 80 00       	push   $0x803e58
  800964:	68 9c 00 00 00       	push   $0x9c
  800969:	68 dc 3d 80 00       	push   $0x803ddc
  80096e:	e8 f5 05 00 00       	call   800f68 <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 0) panic("Wrong allocation: ");

		//6 MB
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  800973:	e8 e2 1c 00 00       	call   80265a <sys_pf_calculate_allocated_pages>
  800978:	89 45 c8             	mov    %eax,-0x38(%ebp)
		ptr_allocations[6] = malloc(6*Mega-kilo);
  80097b:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80097e:	89 d0                	mov    %edx,%eax
  800980:	01 c0                	add    %eax,%eax
  800982:	01 d0                	add    %edx,%eax
  800984:	01 c0                	add    %eax,%eax
  800986:	2b 45 e0             	sub    -0x20(%ebp),%eax
  800989:	83 ec 0c             	sub    $0xc,%esp
  80098c:	50                   	push   %eax
  80098d:	e8 1c 18 00 00       	call   8021ae <malloc>
  800992:	83 c4 10             	add    $0x10,%esp
  800995:	89 85 f4 fe ff ff    	mov    %eax,-0x10c(%ebp)
		if ((uint32) ptr_allocations[6] < (USER_HEAP_START + 7*Mega + 16*kilo) || (uint32) ptr_allocations[6] > (USER_HEAP_START+ 7*Mega + 16*kilo +PAGE_SIZE)) panic("Wrong start address for the allocated space... check return address of malloc & updating of heap ptr");
  80099b:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  8009a1:	89 c1                	mov    %eax,%ecx
  8009a3:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8009a6:	89 d0                	mov    %edx,%eax
  8009a8:	01 c0                	add    %eax,%eax
  8009aa:	01 d0                	add    %edx,%eax
  8009ac:	01 c0                	add    %eax,%eax
  8009ae:	01 d0                	add    %edx,%eax
  8009b0:	89 c2                	mov    %eax,%edx
  8009b2:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8009b5:	c1 e0 04             	shl    $0x4,%eax
  8009b8:	01 d0                	add    %edx,%eax
  8009ba:	05 00 00 00 80       	add    $0x80000000,%eax
  8009bf:	39 c1                	cmp    %eax,%ecx
  8009c1:	72 28                	jb     8009eb <_main+0x9b3>
  8009c3:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  8009c9:	89 c1                	mov    %eax,%ecx
  8009cb:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8009ce:	89 d0                	mov    %edx,%eax
  8009d0:	01 c0                	add    %eax,%eax
  8009d2:	01 d0                	add    %edx,%eax
  8009d4:	01 c0                	add    %eax,%eax
  8009d6:	01 d0                	add    %edx,%eax
  8009d8:	89 c2                	mov    %eax,%edx
  8009da:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8009dd:	c1 e0 04             	shl    $0x4,%eax
  8009e0:	01 d0                	add    %edx,%eax
  8009e2:	2d 00 f0 ff 7f       	sub    $0x7ffff000,%eax
  8009e7:	39 c1                	cmp    %eax,%ecx
  8009e9:	76 17                	jbe    800a02 <_main+0x9ca>
  8009eb:	83 ec 04             	sub    $0x4,%esp
  8009ee:	68 f0 3d 80 00       	push   $0x803df0
  8009f3:	68 a2 00 00 00       	push   $0xa2
  8009f8:	68 dc 3d 80 00       	push   $0x803ddc
  8009fd:	e8 66 05 00 00       	call   800f68 <_panic>
		if ((sys_pf_calculate_allocated_pages() - usedDiskPages) != 0) panic("Extra or less pages are allocated in PageFile");
  800a02:	e8 53 1c 00 00       	call   80265a <sys_pf_calculate_allocated_pages>
  800a07:	3b 45 c8             	cmp    -0x38(%ebp),%eax
  800a0a:	74 17                	je     800a23 <_main+0x9eb>
  800a0c:	83 ec 04             	sub    $0x4,%esp
  800a0f:	68 58 3e 80 00       	push   $0x803e58
  800a14:	68 a3 00 00 00       	push   $0xa3
  800a19:	68 dc 3d 80 00       	push   $0x803ddc
  800a1e:	e8 45 05 00 00       	call   800f68 <_panic>

		freeFrames = sys_calculate_free_frames() ;
  800a23:	e8 92 1b 00 00       	call   8025ba <sys_calculate_free_frames>
  800a28:	89 45 c4             	mov    %eax,-0x3c(%ebp)
		lastIndexOfByte2 = (6*Mega-kilo)/sizeof(char) - 1;
  800a2b:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  800a2e:	89 d0                	mov    %edx,%eax
  800a30:	01 c0                	add    %eax,%eax
  800a32:	01 d0                	add    %edx,%eax
  800a34:	01 c0                	add    %eax,%eax
  800a36:	2b 45 e0             	sub    -0x20(%ebp),%eax
  800a39:	48                   	dec    %eax
  800a3a:	89 85 60 ff ff ff    	mov    %eax,-0xa0(%ebp)
		byteArr2 = (char *) ptr_allocations[6];
  800a40:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  800a46:	89 85 5c ff ff ff    	mov    %eax,-0xa4(%ebp)
		byteArr2[0] = minByte ;
  800a4c:	8b 85 5c ff ff ff    	mov    -0xa4(%ebp),%eax
  800a52:	8a 55 df             	mov    -0x21(%ebp),%dl
  800a55:	88 10                	mov    %dl,(%eax)
		byteArr2[lastIndexOfByte2 / 2] = maxByte / 2;
  800a57:	8b 85 60 ff ff ff    	mov    -0xa0(%ebp),%eax
  800a5d:	89 c2                	mov    %eax,%edx
  800a5f:	c1 ea 1f             	shr    $0x1f,%edx
  800a62:	01 d0                	add    %edx,%eax
  800a64:	d1 f8                	sar    %eax
  800a66:	89 c2                	mov    %eax,%edx
  800a68:	8b 85 5c ff ff ff    	mov    -0xa4(%ebp),%eax
  800a6e:	01 c2                	add    %eax,%edx
  800a70:	8a 45 de             	mov    -0x22(%ebp),%al
  800a73:	88 c1                	mov    %al,%cl
  800a75:	c0 e9 07             	shr    $0x7,%cl
  800a78:	01 c8                	add    %ecx,%eax
  800a7a:	d0 f8                	sar    %al
  800a7c:	88 02                	mov    %al,(%edx)
		byteArr2[lastIndexOfByte2] = maxByte ;
  800a7e:	8b 95 60 ff ff ff    	mov    -0xa0(%ebp),%edx
  800a84:	8b 85 5c ff ff ff    	mov    -0xa4(%ebp),%eax
  800a8a:	01 c2                	add    %eax,%edx
  800a8c:	8a 45 de             	mov    -0x22(%ebp),%al
  800a8f:	88 02                	mov    %al,(%edx)
		if ((freeFrames - sys_calculate_free_frames()) != 3 + 2) panic("Wrong allocation: pages are not loaded successfully into memory/WS");
  800a91:	8b 5d c4             	mov    -0x3c(%ebp),%ebx
  800a94:	e8 21 1b 00 00       	call   8025ba <sys_calculate_free_frames>
  800a99:	29 c3                	sub    %eax,%ebx
  800a9b:	89 d8                	mov    %ebx,%eax
  800a9d:	83 f8 05             	cmp    $0x5,%eax
  800aa0:	74 17                	je     800ab9 <_main+0xa81>
  800aa2:	83 ec 04             	sub    $0x4,%esp
  800aa5:	68 88 3e 80 00       	push   $0x803e88
  800aaa:	68 ab 00 00 00       	push   $0xab
  800aaf:	68 dc 3d 80 00       	push   $0x803ddc
  800ab4:	e8 af 04 00 00       	call   800f68 <_panic>
		found = 0;
  800ab9:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		for (var = 0; var < (myEnv->page_WS_max_size); ++var)
  800ac0:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  800ac7:	e9 02 01 00 00       	jmp    800bce <_main+0xb96>
		{
			if(ROUNDDOWN(myEnv->__uptr_pws[var].virtual_address,PAGE_SIZE) == ROUNDDOWN((uint32)(&(byteArr2[0])), PAGE_SIZE))
  800acc:	a1 20 50 80 00       	mov    0x805020,%eax
  800ad1:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  800ad7:	8b 55 ec             	mov    -0x14(%ebp),%edx
  800ada:	89 d0                	mov    %edx,%eax
  800adc:	01 c0                	add    %eax,%eax
  800ade:	01 d0                	add    %edx,%eax
  800ae0:	c1 e0 03             	shl    $0x3,%eax
  800ae3:	01 c8                	add    %ecx,%eax
  800ae5:	8b 00                	mov    (%eax),%eax
  800ae7:	89 85 58 ff ff ff    	mov    %eax,-0xa8(%ebp)
  800aed:	8b 85 58 ff ff ff    	mov    -0xa8(%ebp),%eax
  800af3:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800af8:	89 c2                	mov    %eax,%edx
  800afa:	8b 85 5c ff ff ff    	mov    -0xa4(%ebp),%eax
  800b00:	89 85 54 ff ff ff    	mov    %eax,-0xac(%ebp)
  800b06:	8b 85 54 ff ff ff    	mov    -0xac(%ebp),%eax
  800b0c:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800b11:	39 c2                	cmp    %eax,%edx
  800b13:	75 03                	jne    800b18 <_main+0xae0>
				found++;
  800b15:	ff 45 e8             	incl   -0x18(%ebp)
			if(ROUNDDOWN(myEnv->__uptr_pws[var].virtual_address,PAGE_SIZE) == ROUNDDOWN((uint32)(&(byteArr2[lastIndexOfByte2/2])), PAGE_SIZE))
  800b18:	a1 20 50 80 00       	mov    0x805020,%eax
  800b1d:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  800b23:	8b 55 ec             	mov    -0x14(%ebp),%edx
  800b26:	89 d0                	mov    %edx,%eax
  800b28:	01 c0                	add    %eax,%eax
  800b2a:	01 d0                	add    %edx,%eax
  800b2c:	c1 e0 03             	shl    $0x3,%eax
  800b2f:	01 c8                	add    %ecx,%eax
  800b31:	8b 00                	mov    (%eax),%eax
  800b33:	89 85 50 ff ff ff    	mov    %eax,-0xb0(%ebp)
  800b39:	8b 85 50 ff ff ff    	mov    -0xb0(%ebp),%eax
  800b3f:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800b44:	89 c2                	mov    %eax,%edx
  800b46:	8b 85 60 ff ff ff    	mov    -0xa0(%ebp),%eax
  800b4c:	89 c1                	mov    %eax,%ecx
  800b4e:	c1 e9 1f             	shr    $0x1f,%ecx
  800b51:	01 c8                	add    %ecx,%eax
  800b53:	d1 f8                	sar    %eax
  800b55:	89 c1                	mov    %eax,%ecx
  800b57:	8b 85 5c ff ff ff    	mov    -0xa4(%ebp),%eax
  800b5d:	01 c8                	add    %ecx,%eax
  800b5f:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%ebp)
  800b65:	8b 85 4c ff ff ff    	mov    -0xb4(%ebp),%eax
  800b6b:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800b70:	39 c2                	cmp    %eax,%edx
  800b72:	75 03                	jne    800b77 <_main+0xb3f>
				found++;
  800b74:	ff 45 e8             	incl   -0x18(%ebp)
			if(ROUNDDOWN(myEnv->__uptr_pws[var].virtual_address,PAGE_SIZE) == ROUNDDOWN((uint32)(&(byteArr2[lastIndexOfByte2])), PAGE_SIZE))
  800b77:	a1 20 50 80 00       	mov    0x805020,%eax
  800b7c:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  800b82:	8b 55 ec             	mov    -0x14(%ebp),%edx
  800b85:	89 d0                	mov    %edx,%eax
  800b87:	01 c0                	add    %eax,%eax
  800b89:	01 d0                	add    %edx,%eax
  800b8b:	c1 e0 03             	shl    $0x3,%eax
  800b8e:	01 c8                	add    %ecx,%eax
  800b90:	8b 00                	mov    (%eax),%eax
  800b92:	89 85 48 ff ff ff    	mov    %eax,-0xb8(%ebp)
  800b98:	8b 85 48 ff ff ff    	mov    -0xb8(%ebp),%eax
  800b9e:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800ba3:	89 c1                	mov    %eax,%ecx
  800ba5:	8b 95 60 ff ff ff    	mov    -0xa0(%ebp),%edx
  800bab:	8b 85 5c ff ff ff    	mov    -0xa4(%ebp),%eax
  800bb1:	01 d0                	add    %edx,%eax
  800bb3:	89 85 44 ff ff ff    	mov    %eax,-0xbc(%ebp)
  800bb9:	8b 85 44 ff ff ff    	mov    -0xbc(%ebp),%eax
  800bbf:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800bc4:	39 c1                	cmp    %eax,%ecx
  800bc6:	75 03                	jne    800bcb <_main+0xb93>
				found++;
  800bc8:	ff 45 e8             	incl   -0x18(%ebp)
		byteArr2[0] = minByte ;
		byteArr2[lastIndexOfByte2 / 2] = maxByte / 2;
		byteArr2[lastIndexOfByte2] = maxByte ;
		if ((freeFrames - sys_calculate_free_frames()) != 3 + 2) panic("Wrong allocation: pages are not loaded successfully into memory/WS");
		found = 0;
		for (var = 0; var < (myEnv->page_WS_max_size); ++var)
  800bcb:	ff 45 ec             	incl   -0x14(%ebp)
  800bce:	a1 20 50 80 00       	mov    0x805020,%eax
  800bd3:	8b 50 74             	mov    0x74(%eax),%edx
  800bd6:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800bd9:	39 c2                	cmp    %eax,%edx
  800bdb:	0f 87 eb fe ff ff    	ja     800acc <_main+0xa94>
			if(ROUNDDOWN(myEnv->__uptr_pws[var].virtual_address,PAGE_SIZE) == ROUNDDOWN((uint32)(&(byteArr2[lastIndexOfByte2/2])), PAGE_SIZE))
				found++;
			if(ROUNDDOWN(myEnv->__uptr_pws[var].virtual_address,PAGE_SIZE) == ROUNDDOWN((uint32)(&(byteArr2[lastIndexOfByte2])), PAGE_SIZE))
				found++;
		}
		if (found != 3) panic("malloc: page is not added to WS");
  800be1:	83 7d e8 03          	cmpl   $0x3,-0x18(%ebp)
  800be5:	74 17                	je     800bfe <_main+0xbc6>
  800be7:	83 ec 04             	sub    $0x4,%esp
  800bea:	68 cc 3e 80 00       	push   $0x803ecc
  800bef:	68 b6 00 00 00       	push   $0xb6
  800bf4:	68 dc 3d 80 00       	push   $0x803ddc
  800bf9:	e8 6a 03 00 00       	call   800f68 <_panic>

		//14 KB
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  800bfe:	e8 57 1a 00 00       	call   80265a <sys_pf_calculate_allocated_pages>
  800c03:	89 45 c8             	mov    %eax,-0x38(%ebp)
		ptr_allocations[7] = malloc(14*kilo);
  800c06:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800c09:	89 d0                	mov    %edx,%eax
  800c0b:	01 c0                	add    %eax,%eax
  800c0d:	01 d0                	add    %edx,%eax
  800c0f:	01 c0                	add    %eax,%eax
  800c11:	01 d0                	add    %edx,%eax
  800c13:	01 c0                	add    %eax,%eax
  800c15:	83 ec 0c             	sub    $0xc,%esp
  800c18:	50                   	push   %eax
  800c19:	e8 90 15 00 00       	call   8021ae <malloc>
  800c1e:	83 c4 10             	add    $0x10,%esp
  800c21:	89 85 f8 fe ff ff    	mov    %eax,-0x108(%ebp)
		if ((uint32) ptr_allocations[7] < (USER_HEAP_START + 13*Mega + 16*kilo)|| (uint32) ptr_allocations[7] > (USER_HEAP_START+ 13*Mega + 16*kilo +PAGE_SIZE)) panic("Wrong start address for the allocated space... check return address of malloc & updating of heap ptr");
  800c27:	8b 85 f8 fe ff ff    	mov    -0x108(%ebp),%eax
  800c2d:	89 c1                	mov    %eax,%ecx
  800c2f:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  800c32:	89 d0                	mov    %edx,%eax
  800c34:	01 c0                	add    %eax,%eax
  800c36:	01 d0                	add    %edx,%eax
  800c38:	c1 e0 02             	shl    $0x2,%eax
  800c3b:	01 d0                	add    %edx,%eax
  800c3d:	89 c2                	mov    %eax,%edx
  800c3f:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800c42:	c1 e0 04             	shl    $0x4,%eax
  800c45:	01 d0                	add    %edx,%eax
  800c47:	05 00 00 00 80       	add    $0x80000000,%eax
  800c4c:	39 c1                	cmp    %eax,%ecx
  800c4e:	72 29                	jb     800c79 <_main+0xc41>
  800c50:	8b 85 f8 fe ff ff    	mov    -0x108(%ebp),%eax
  800c56:	89 c1                	mov    %eax,%ecx
  800c58:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  800c5b:	89 d0                	mov    %edx,%eax
  800c5d:	01 c0                	add    %eax,%eax
  800c5f:	01 d0                	add    %edx,%eax
  800c61:	c1 e0 02             	shl    $0x2,%eax
  800c64:	01 d0                	add    %edx,%eax
  800c66:	89 c2                	mov    %eax,%edx
  800c68:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800c6b:	c1 e0 04             	shl    $0x4,%eax
  800c6e:	01 d0                	add    %edx,%eax
  800c70:	2d 00 f0 ff 7f       	sub    $0x7ffff000,%eax
  800c75:	39 c1                	cmp    %eax,%ecx
  800c77:	76 17                	jbe    800c90 <_main+0xc58>
  800c79:	83 ec 04             	sub    $0x4,%esp
  800c7c:	68 f0 3d 80 00       	push   $0x803df0
  800c81:	68 bb 00 00 00       	push   $0xbb
  800c86:	68 dc 3d 80 00       	push   $0x803ddc
  800c8b:	e8 d8 02 00 00       	call   800f68 <_panic>
		if ((sys_pf_calculate_allocated_pages() - usedDiskPages) != 0) panic("Extra or less pages are allocated in PageFile");
  800c90:	e8 c5 19 00 00       	call   80265a <sys_pf_calculate_allocated_pages>
  800c95:	3b 45 c8             	cmp    -0x38(%ebp),%eax
  800c98:	74 17                	je     800cb1 <_main+0xc79>
  800c9a:	83 ec 04             	sub    $0x4,%esp
  800c9d:	68 58 3e 80 00       	push   $0x803e58
  800ca2:	68 bc 00 00 00       	push   $0xbc
  800ca7:	68 dc 3d 80 00       	push   $0x803ddc
  800cac:	e8 b7 02 00 00       	call   800f68 <_panic>

		freeFrames = sys_calculate_free_frames() ;
  800cb1:	e8 04 19 00 00       	call   8025ba <sys_calculate_free_frames>
  800cb6:	89 45 c4             	mov    %eax,-0x3c(%ebp)
		shortArr2 = (short *) ptr_allocations[7];
  800cb9:	8b 85 f8 fe ff ff    	mov    -0x108(%ebp),%eax
  800cbf:	89 85 40 ff ff ff    	mov    %eax,-0xc0(%ebp)
		lastIndexOfShort2 = (14*kilo)/sizeof(short) - 1;
  800cc5:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800cc8:	89 d0                	mov    %edx,%eax
  800cca:	01 c0                	add    %eax,%eax
  800ccc:	01 d0                	add    %edx,%eax
  800cce:	01 c0                	add    %eax,%eax
  800cd0:	01 d0                	add    %edx,%eax
  800cd2:	01 c0                	add    %eax,%eax
  800cd4:	d1 e8                	shr    %eax
  800cd6:	48                   	dec    %eax
  800cd7:	89 85 3c ff ff ff    	mov    %eax,-0xc4(%ebp)
		shortArr2[0] = minShort;
  800cdd:	8b 95 40 ff ff ff    	mov    -0xc0(%ebp),%edx
  800ce3:	8b 45 dc             	mov    -0x24(%ebp),%eax
  800ce6:	66 89 02             	mov    %ax,(%edx)
		shortArr2[lastIndexOfShort2] = maxShort;
  800ce9:	8b 85 3c ff ff ff    	mov    -0xc4(%ebp),%eax
  800cef:	01 c0                	add    %eax,%eax
  800cf1:	89 c2                	mov    %eax,%edx
  800cf3:	8b 85 40 ff ff ff    	mov    -0xc0(%ebp),%eax
  800cf9:	01 c2                	add    %eax,%edx
  800cfb:	66 8b 45 da          	mov    -0x26(%ebp),%ax
  800cff:	66 89 02             	mov    %ax,(%edx)
		if ((freeFrames - sys_calculate_free_frames()) != 2) panic("Wrong allocation: pages are not loaded successfully into memory/WS");
  800d02:	8b 5d c4             	mov    -0x3c(%ebp),%ebx
  800d05:	e8 b0 18 00 00       	call   8025ba <sys_calculate_free_frames>
  800d0a:	29 c3                	sub    %eax,%ebx
  800d0c:	89 d8                	mov    %ebx,%eax
  800d0e:	83 f8 02             	cmp    $0x2,%eax
  800d11:	74 17                	je     800d2a <_main+0xcf2>
  800d13:	83 ec 04             	sub    $0x4,%esp
  800d16:	68 88 3e 80 00       	push   $0x803e88
  800d1b:	68 c3 00 00 00       	push   $0xc3
  800d20:	68 dc 3d 80 00       	push   $0x803ddc
  800d25:	e8 3e 02 00 00       	call   800f68 <_panic>
		found = 0;
  800d2a:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		for (var = 0; var < (myEnv->page_WS_max_size); ++var)
  800d31:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  800d38:	e9 a7 00 00 00       	jmp    800de4 <_main+0xdac>
		{
			if(ROUNDDOWN(myEnv->__uptr_pws[var].virtual_address,PAGE_SIZE) == ROUNDDOWN((uint32)(&(shortArr2[0])), PAGE_SIZE))
  800d3d:	a1 20 50 80 00       	mov    0x805020,%eax
  800d42:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  800d48:	8b 55 ec             	mov    -0x14(%ebp),%edx
  800d4b:	89 d0                	mov    %edx,%eax
  800d4d:	01 c0                	add    %eax,%eax
  800d4f:	01 d0                	add    %edx,%eax
  800d51:	c1 e0 03             	shl    $0x3,%eax
  800d54:	01 c8                	add    %ecx,%eax
  800d56:	8b 00                	mov    (%eax),%eax
  800d58:	89 85 38 ff ff ff    	mov    %eax,-0xc8(%ebp)
  800d5e:	8b 85 38 ff ff ff    	mov    -0xc8(%ebp),%eax
  800d64:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800d69:	89 c2                	mov    %eax,%edx
  800d6b:	8b 85 40 ff ff ff    	mov    -0xc0(%ebp),%eax
  800d71:	89 85 34 ff ff ff    	mov    %eax,-0xcc(%ebp)
  800d77:	8b 85 34 ff ff ff    	mov    -0xcc(%ebp),%eax
  800d7d:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800d82:	39 c2                	cmp    %eax,%edx
  800d84:	75 03                	jne    800d89 <_main+0xd51>
				found++;
  800d86:	ff 45 e8             	incl   -0x18(%ebp)
			if(ROUNDDOWN(myEnv->__uptr_pws[var].virtual_address,PAGE_SIZE) == ROUNDDOWN((uint32)(&(shortArr2[lastIndexOfShort2])), PAGE_SIZE))
  800d89:	a1 20 50 80 00       	mov    0x805020,%eax
  800d8e:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  800d94:	8b 55 ec             	mov    -0x14(%ebp),%edx
  800d97:	89 d0                	mov    %edx,%eax
  800d99:	01 c0                	add    %eax,%eax
  800d9b:	01 d0                	add    %edx,%eax
  800d9d:	c1 e0 03             	shl    $0x3,%eax
  800da0:	01 c8                	add    %ecx,%eax
  800da2:	8b 00                	mov    (%eax),%eax
  800da4:	89 85 30 ff ff ff    	mov    %eax,-0xd0(%ebp)
  800daa:	8b 85 30 ff ff ff    	mov    -0xd0(%ebp),%eax
  800db0:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800db5:	89 c2                	mov    %eax,%edx
  800db7:	8b 85 3c ff ff ff    	mov    -0xc4(%ebp),%eax
  800dbd:	01 c0                	add    %eax,%eax
  800dbf:	89 c1                	mov    %eax,%ecx
  800dc1:	8b 85 40 ff ff ff    	mov    -0xc0(%ebp),%eax
  800dc7:	01 c8                	add    %ecx,%eax
  800dc9:	89 85 2c ff ff ff    	mov    %eax,-0xd4(%ebp)
  800dcf:	8b 85 2c ff ff ff    	mov    -0xd4(%ebp),%eax
  800dd5:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800dda:	39 c2                	cmp    %eax,%edx
  800ddc:	75 03                	jne    800de1 <_main+0xda9>
				found++;
  800dde:	ff 45 e8             	incl   -0x18(%ebp)
		lastIndexOfShort2 = (14*kilo)/sizeof(short) - 1;
		shortArr2[0] = minShort;
		shortArr2[lastIndexOfShort2] = maxShort;
		if ((freeFrames - sys_calculate_free_frames()) != 2) panic("Wrong allocation: pages are not loaded successfully into memory/WS");
		found = 0;
		for (var = 0; var < (myEnv->page_WS_max_size); ++var)
  800de1:	ff 45 ec             	incl   -0x14(%ebp)
  800de4:	a1 20 50 80 00       	mov    0x805020,%eax
  800de9:	8b 50 74             	mov    0x74(%eax),%edx
  800dec:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800def:	39 c2                	cmp    %eax,%edx
  800df1:	0f 87 46 ff ff ff    	ja     800d3d <_main+0xd05>
			if(ROUNDDOWN(myEnv->__uptr_pws[var].virtual_address,PAGE_SIZE) == ROUNDDOWN((uint32)(&(shortArr2[0])), PAGE_SIZE))
				found++;
			if(ROUNDDOWN(myEnv->__uptr_pws[var].virtual_address,PAGE_SIZE) == ROUNDDOWN((uint32)(&(shortArr2[lastIndexOfShort2])), PAGE_SIZE))
				found++;
		}
		if (found != 2) panic("malloc: page is not added to WS");
  800df7:	83 7d e8 02          	cmpl   $0x2,-0x18(%ebp)
  800dfb:	74 17                	je     800e14 <_main+0xddc>
  800dfd:	83 ec 04             	sub    $0x4,%esp
  800e00:	68 cc 3e 80 00       	push   $0x803ecc
  800e05:	68 cc 00 00 00       	push   $0xcc
  800e0a:	68 dc 3d 80 00       	push   $0x803ddc
  800e0f:	e8 54 01 00 00       	call   800f68 <_panic>
	}

	cprintf("Congratulations!! test malloc [3] completed successfully.\n");
  800e14:	83 ec 0c             	sub    $0xc,%esp
  800e17:	68 ec 3e 80 00       	push   $0x803eec
  800e1c:	e8 fb 03 00 00       	call   80121c <cprintf>
  800e21:	83 c4 10             	add    $0x10,%esp

	return;
  800e24:	90                   	nop
}
  800e25:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800e28:	5b                   	pop    %ebx
  800e29:	5f                   	pop    %edi
  800e2a:	5d                   	pop    %ebp
  800e2b:	c3                   	ret    

00800e2c <libmain>:
volatile struct Env *myEnv = NULL;
volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";

void
libmain(int argc, char **argv)
{
  800e2c:	55                   	push   %ebp
  800e2d:	89 e5                	mov    %esp,%ebp
  800e2f:	83 ec 18             	sub    $0x18,%esp
	int envIndex = sys_getenvindex();
  800e32:	e8 63 1a 00 00       	call   80289a <sys_getenvindex>
  800e37:	89 45 f4             	mov    %eax,-0xc(%ebp)
	myEnv = &(envs[envIndex]);
  800e3a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800e3d:	89 d0                	mov    %edx,%eax
  800e3f:	c1 e0 03             	shl    $0x3,%eax
  800e42:	01 d0                	add    %edx,%eax
  800e44:	01 c0                	add    %eax,%eax
  800e46:	01 d0                	add    %edx,%eax
  800e48:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800e4f:	01 d0                	add    %edx,%eax
  800e51:	c1 e0 04             	shl    $0x4,%eax
  800e54:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  800e59:	a3 20 50 80 00       	mov    %eax,0x805020

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  800e5e:	a1 20 50 80 00       	mov    0x805020,%eax
  800e63:	8a 80 5c 05 00 00    	mov    0x55c(%eax),%al
  800e69:	84 c0                	test   %al,%al
  800e6b:	74 0f                	je     800e7c <libmain+0x50>
		binaryname = myEnv->prog_name;
  800e6d:	a1 20 50 80 00       	mov    0x805020,%eax
  800e72:	05 5c 05 00 00       	add    $0x55c,%eax
  800e77:	a3 00 50 80 00       	mov    %eax,0x805000

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800e7c:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800e80:	7e 0a                	jle    800e8c <libmain+0x60>
		binaryname = argv[0];
  800e82:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e85:	8b 00                	mov    (%eax),%eax
  800e87:	a3 00 50 80 00       	mov    %eax,0x805000

	// call user main routine
	_main(argc, argv);
  800e8c:	83 ec 08             	sub    $0x8,%esp
  800e8f:	ff 75 0c             	pushl  0xc(%ebp)
  800e92:	ff 75 08             	pushl  0x8(%ebp)
  800e95:	e8 9e f1 ff ff       	call   800038 <_main>
  800e9a:	83 c4 10             	add    $0x10,%esp



	sys_disable_interrupt();
  800e9d:	e8 05 18 00 00       	call   8026a7 <sys_disable_interrupt>
	cprintf("**************************************\n");
  800ea2:	83 ec 0c             	sub    $0xc,%esp
  800ea5:	68 40 3f 80 00       	push   $0x803f40
  800eaa:	e8 6d 03 00 00       	call   80121c <cprintf>
  800eaf:	83 c4 10             	add    $0x10,%esp
	cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  800eb2:	a1 20 50 80 00       	mov    0x805020,%eax
  800eb7:	8b 90 44 05 00 00    	mov    0x544(%eax),%edx
  800ebd:	a1 20 50 80 00       	mov    0x805020,%eax
  800ec2:	8b 80 34 05 00 00    	mov    0x534(%eax),%eax
  800ec8:	83 ec 04             	sub    $0x4,%esp
  800ecb:	52                   	push   %edx
  800ecc:	50                   	push   %eax
  800ecd:	68 68 3f 80 00       	push   $0x803f68
  800ed2:	e8 45 03 00 00       	call   80121c <cprintf>
  800ed7:	83 c4 10             	add    $0x10,%esp
	cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  800eda:	a1 20 50 80 00       	mov    0x805020,%eax
  800edf:	8b 88 54 05 00 00    	mov    0x554(%eax),%ecx
  800ee5:	a1 20 50 80 00       	mov    0x805020,%eax
  800eea:	8b 90 50 05 00 00    	mov    0x550(%eax),%edx
  800ef0:	a1 20 50 80 00       	mov    0x805020,%eax
  800ef5:	8b 80 4c 05 00 00    	mov    0x54c(%eax),%eax
  800efb:	51                   	push   %ecx
  800efc:	52                   	push   %edx
  800efd:	50                   	push   %eax
  800efe:	68 90 3f 80 00       	push   $0x803f90
  800f03:	e8 14 03 00 00       	call   80121c <cprintf>
  800f08:	83 c4 10             	add    $0x10,%esp
	//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
	cprintf("Num of clocks = %d\n", myEnv->nClocks);
  800f0b:	a1 20 50 80 00       	mov    0x805020,%eax
  800f10:	8b 80 a4 05 00 00    	mov    0x5a4(%eax),%eax
  800f16:	83 ec 08             	sub    $0x8,%esp
  800f19:	50                   	push   %eax
  800f1a:	68 e8 3f 80 00       	push   $0x803fe8
  800f1f:	e8 f8 02 00 00       	call   80121c <cprintf>
  800f24:	83 c4 10             	add    $0x10,%esp
	cprintf("**************************************\n");
  800f27:	83 ec 0c             	sub    $0xc,%esp
  800f2a:	68 40 3f 80 00       	push   $0x803f40
  800f2f:	e8 e8 02 00 00       	call   80121c <cprintf>
  800f34:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  800f37:	e8 85 17 00 00       	call   8026c1 <sys_enable_interrupt>

	// exit gracefully
	exit();
  800f3c:	e8 19 00 00 00       	call   800f5a <exit>
}
  800f41:	90                   	nop
  800f42:	c9                   	leave  
  800f43:	c3                   	ret    

00800f44 <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  800f44:	55                   	push   %ebp
  800f45:	89 e5                	mov    %esp,%ebp
  800f47:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  800f4a:	83 ec 0c             	sub    $0xc,%esp
  800f4d:	6a 00                	push   $0x0
  800f4f:	e8 12 19 00 00       	call   802866 <sys_destroy_env>
  800f54:	83 c4 10             	add    $0x10,%esp
}
  800f57:	90                   	nop
  800f58:	c9                   	leave  
  800f59:	c3                   	ret    

00800f5a <exit>:

void
exit(void)
{
  800f5a:	55                   	push   %ebp
  800f5b:	89 e5                	mov    %esp,%ebp
  800f5d:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  800f60:	e8 67 19 00 00       	call   8028cc <sys_exit_env>
}
  800f65:	90                   	nop
  800f66:	c9                   	leave  
  800f67:	c3                   	ret    

00800f68 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  800f68:	55                   	push   %ebp
  800f69:	89 e5                	mov    %esp,%ebp
  800f6b:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  800f6e:	8d 45 10             	lea    0x10(%ebp),%eax
  800f71:	83 c0 04             	add    $0x4,%eax
  800f74:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  800f77:	a1 5c 51 80 00       	mov    0x80515c,%eax
  800f7c:	85 c0                	test   %eax,%eax
  800f7e:	74 16                	je     800f96 <_panic+0x2e>
		cprintf("%s: ", argv0);
  800f80:	a1 5c 51 80 00       	mov    0x80515c,%eax
  800f85:	83 ec 08             	sub    $0x8,%esp
  800f88:	50                   	push   %eax
  800f89:	68 fc 3f 80 00       	push   $0x803ffc
  800f8e:	e8 89 02 00 00       	call   80121c <cprintf>
  800f93:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  800f96:	a1 00 50 80 00       	mov    0x805000,%eax
  800f9b:	ff 75 0c             	pushl  0xc(%ebp)
  800f9e:	ff 75 08             	pushl  0x8(%ebp)
  800fa1:	50                   	push   %eax
  800fa2:	68 01 40 80 00       	push   $0x804001
  800fa7:	e8 70 02 00 00       	call   80121c <cprintf>
  800fac:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  800faf:	8b 45 10             	mov    0x10(%ebp),%eax
  800fb2:	83 ec 08             	sub    $0x8,%esp
  800fb5:	ff 75 f4             	pushl  -0xc(%ebp)
  800fb8:	50                   	push   %eax
  800fb9:	e8 f3 01 00 00       	call   8011b1 <vcprintf>
  800fbe:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  800fc1:	83 ec 08             	sub    $0x8,%esp
  800fc4:	6a 00                	push   $0x0
  800fc6:	68 1d 40 80 00       	push   $0x80401d
  800fcb:	e8 e1 01 00 00       	call   8011b1 <vcprintf>
  800fd0:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  800fd3:	e8 82 ff ff ff       	call   800f5a <exit>

	// should not return here
	while (1) ;
  800fd8:	eb fe                	jmp    800fd8 <_panic+0x70>

00800fda <CheckWSWithoutLastIndex>:
}

void CheckWSWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  800fda:	55                   	push   %ebp
  800fdb:	89 e5                	mov    %esp,%ebp
  800fdd:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  800fe0:	a1 20 50 80 00       	mov    0x805020,%eax
  800fe5:	8b 50 74             	mov    0x74(%eax),%edx
  800fe8:	8b 45 0c             	mov    0xc(%ebp),%eax
  800feb:	39 c2                	cmp    %eax,%edx
  800fed:	74 14                	je     801003 <CheckWSWithoutLastIndex+0x29>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  800fef:	83 ec 04             	sub    $0x4,%esp
  800ff2:	68 20 40 80 00       	push   $0x804020
  800ff7:	6a 26                	push   $0x26
  800ff9:	68 6c 40 80 00       	push   $0x80406c
  800ffe:	e8 65 ff ff ff       	call   800f68 <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  801003:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  80100a:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  801011:	e9 c2 00 00 00       	jmp    8010d8 <CheckWSWithoutLastIndex+0xfe>
		if (expectedPages[e] == 0) {
  801016:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801019:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801020:	8b 45 08             	mov    0x8(%ebp),%eax
  801023:	01 d0                	add    %edx,%eax
  801025:	8b 00                	mov    (%eax),%eax
  801027:	85 c0                	test   %eax,%eax
  801029:	75 08                	jne    801033 <CheckWSWithoutLastIndex+0x59>
			expectedNumOfEmptyLocs++;
  80102b:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  80102e:	e9 a2 00 00 00       	jmp    8010d5 <CheckWSWithoutLastIndex+0xfb>
		}
		int found = 0;
  801033:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  80103a:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  801041:	eb 69                	jmp    8010ac <CheckWSWithoutLastIndex+0xd2>
			if (myEnv->__uptr_pws[w].empty == 0) {
  801043:	a1 20 50 80 00       	mov    0x805020,%eax
  801048:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  80104e:	8b 55 e8             	mov    -0x18(%ebp),%edx
  801051:	89 d0                	mov    %edx,%eax
  801053:	01 c0                	add    %eax,%eax
  801055:	01 d0                	add    %edx,%eax
  801057:	c1 e0 03             	shl    $0x3,%eax
  80105a:	01 c8                	add    %ecx,%eax
  80105c:	8a 40 04             	mov    0x4(%eax),%al
  80105f:	84 c0                	test   %al,%al
  801061:	75 46                	jne    8010a9 <CheckWSWithoutLastIndex+0xcf>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  801063:	a1 20 50 80 00       	mov    0x805020,%eax
  801068:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  80106e:	8b 55 e8             	mov    -0x18(%ebp),%edx
  801071:	89 d0                	mov    %edx,%eax
  801073:	01 c0                	add    %eax,%eax
  801075:	01 d0                	add    %edx,%eax
  801077:	c1 e0 03             	shl    $0x3,%eax
  80107a:	01 c8                	add    %ecx,%eax
  80107c:	8b 00                	mov    (%eax),%eax
  80107e:	89 45 dc             	mov    %eax,-0x24(%ebp)
  801081:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801084:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801089:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  80108b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80108e:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  801095:	8b 45 08             	mov    0x8(%ebp),%eax
  801098:	01 c8                	add    %ecx,%eax
  80109a:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  80109c:	39 c2                	cmp    %eax,%edx
  80109e:	75 09                	jne    8010a9 <CheckWSWithoutLastIndex+0xcf>
						== expectedPages[e]) {
					found = 1;
  8010a0:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  8010a7:	eb 12                	jmp    8010bb <CheckWSWithoutLastIndex+0xe1>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8010a9:	ff 45 e8             	incl   -0x18(%ebp)
  8010ac:	a1 20 50 80 00       	mov    0x805020,%eax
  8010b1:	8b 50 74             	mov    0x74(%eax),%edx
  8010b4:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8010b7:	39 c2                	cmp    %eax,%edx
  8010b9:	77 88                	ja     801043 <CheckWSWithoutLastIndex+0x69>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  8010bb:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8010bf:	75 14                	jne    8010d5 <CheckWSWithoutLastIndex+0xfb>
			panic(
  8010c1:	83 ec 04             	sub    $0x4,%esp
  8010c4:	68 78 40 80 00       	push   $0x804078
  8010c9:	6a 3a                	push   $0x3a
  8010cb:	68 6c 40 80 00       	push   $0x80406c
  8010d0:	e8 93 fe ff ff       	call   800f68 <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  8010d5:	ff 45 f0             	incl   -0x10(%ebp)
  8010d8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8010db:	3b 45 0c             	cmp    0xc(%ebp),%eax
  8010de:	0f 8c 32 ff ff ff    	jl     801016 <CheckWSWithoutLastIndex+0x3c>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  8010e4:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8010eb:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  8010f2:	eb 26                	jmp    80111a <CheckWSWithoutLastIndex+0x140>
		if (myEnv->__uptr_pws[w].empty == 1) {
  8010f4:	a1 20 50 80 00       	mov    0x805020,%eax
  8010f9:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  8010ff:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801102:	89 d0                	mov    %edx,%eax
  801104:	01 c0                	add    %eax,%eax
  801106:	01 d0                	add    %edx,%eax
  801108:	c1 e0 03             	shl    $0x3,%eax
  80110b:	01 c8                	add    %ecx,%eax
  80110d:	8a 40 04             	mov    0x4(%eax),%al
  801110:	3c 01                	cmp    $0x1,%al
  801112:	75 03                	jne    801117 <CheckWSWithoutLastIndex+0x13d>
			actualNumOfEmptyLocs++;
  801114:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  801117:	ff 45 e0             	incl   -0x20(%ebp)
  80111a:	a1 20 50 80 00       	mov    0x805020,%eax
  80111f:	8b 50 74             	mov    0x74(%eax),%edx
  801122:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801125:	39 c2                	cmp    %eax,%edx
  801127:	77 cb                	ja     8010f4 <CheckWSWithoutLastIndex+0x11a>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  801129:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80112c:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  80112f:	74 14                	je     801145 <CheckWSWithoutLastIndex+0x16b>
		panic(
  801131:	83 ec 04             	sub    $0x4,%esp
  801134:	68 cc 40 80 00       	push   $0x8040cc
  801139:	6a 44                	push   $0x44
  80113b:	68 6c 40 80 00       	push   $0x80406c
  801140:	e8 23 fe ff ff       	call   800f68 <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  801145:	90                   	nop
  801146:	c9                   	leave  
  801147:	c3                   	ret    

00801148 <putch>:
};

//2017:
uint8 printProgName = 0;

static void putch(int ch, struct printbuf *b) {
  801148:	55                   	push   %ebp
  801149:	89 e5                	mov    %esp,%ebp
  80114b:	83 ec 08             	sub    $0x8,%esp
	b->buf[b->idx++] = ch;
  80114e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801151:	8b 00                	mov    (%eax),%eax
  801153:	8d 48 01             	lea    0x1(%eax),%ecx
  801156:	8b 55 0c             	mov    0xc(%ebp),%edx
  801159:	89 0a                	mov    %ecx,(%edx)
  80115b:	8b 55 08             	mov    0x8(%ebp),%edx
  80115e:	88 d1                	mov    %dl,%cl
  801160:	8b 55 0c             	mov    0xc(%ebp),%edx
  801163:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  801167:	8b 45 0c             	mov    0xc(%ebp),%eax
  80116a:	8b 00                	mov    (%eax),%eax
  80116c:	3d ff 00 00 00       	cmp    $0xff,%eax
  801171:	75 2c                	jne    80119f <putch+0x57>
		sys_cputs(b->buf, b->idx, printProgName);
  801173:	a0 24 50 80 00       	mov    0x805024,%al
  801178:	0f b6 c0             	movzbl %al,%eax
  80117b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80117e:	8b 12                	mov    (%edx),%edx
  801180:	89 d1                	mov    %edx,%ecx
  801182:	8b 55 0c             	mov    0xc(%ebp),%edx
  801185:	83 c2 08             	add    $0x8,%edx
  801188:	83 ec 04             	sub    $0x4,%esp
  80118b:	50                   	push   %eax
  80118c:	51                   	push   %ecx
  80118d:	52                   	push   %edx
  80118e:	e8 66 13 00 00       	call   8024f9 <sys_cputs>
  801193:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  801196:	8b 45 0c             	mov    0xc(%ebp),%eax
  801199:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  80119f:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011a2:	8b 40 04             	mov    0x4(%eax),%eax
  8011a5:	8d 50 01             	lea    0x1(%eax),%edx
  8011a8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011ab:	89 50 04             	mov    %edx,0x4(%eax)
}
  8011ae:	90                   	nop
  8011af:	c9                   	leave  
  8011b0:	c3                   	ret    

008011b1 <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  8011b1:	55                   	push   %ebp
  8011b2:	89 e5                	mov    %esp,%ebp
  8011b4:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  8011ba:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  8011c1:	00 00 00 
	b.cnt = 0;
  8011c4:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  8011cb:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  8011ce:	ff 75 0c             	pushl  0xc(%ebp)
  8011d1:	ff 75 08             	pushl  0x8(%ebp)
  8011d4:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8011da:	50                   	push   %eax
  8011db:	68 48 11 80 00       	push   $0x801148
  8011e0:	e8 11 02 00 00       	call   8013f6 <vprintfmt>
  8011e5:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName);
  8011e8:	a0 24 50 80 00       	mov    0x805024,%al
  8011ed:	0f b6 c0             	movzbl %al,%eax
  8011f0:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  8011f6:	83 ec 04             	sub    $0x4,%esp
  8011f9:	50                   	push   %eax
  8011fa:	52                   	push   %edx
  8011fb:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  801201:	83 c0 08             	add    $0x8,%eax
  801204:	50                   	push   %eax
  801205:	e8 ef 12 00 00       	call   8024f9 <sys_cputs>
  80120a:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  80120d:	c6 05 24 50 80 00 00 	movb   $0x0,0x805024
	return b.cnt;
  801214:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  80121a:	c9                   	leave  
  80121b:	c3                   	ret    

0080121c <cprintf>:

int cprintf(const char *fmt, ...) {
  80121c:	55                   	push   %ebp
  80121d:	89 e5                	mov    %esp,%ebp
  80121f:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  801222:	c6 05 24 50 80 00 01 	movb   $0x1,0x805024
	va_start(ap, fmt);
  801229:	8d 45 0c             	lea    0xc(%ebp),%eax
  80122c:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  80122f:	8b 45 08             	mov    0x8(%ebp),%eax
  801232:	83 ec 08             	sub    $0x8,%esp
  801235:	ff 75 f4             	pushl  -0xc(%ebp)
  801238:	50                   	push   %eax
  801239:	e8 73 ff ff ff       	call   8011b1 <vcprintf>
  80123e:	83 c4 10             	add    $0x10,%esp
  801241:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  801244:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801247:	c9                   	leave  
  801248:	c3                   	ret    

00801249 <atomic_cprintf>:

int atomic_cprintf(const char *fmt, ...) {
  801249:	55                   	push   %ebp
  80124a:	89 e5                	mov    %esp,%ebp
  80124c:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  80124f:	e8 53 14 00 00       	call   8026a7 <sys_disable_interrupt>
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  801254:	8d 45 0c             	lea    0xc(%ebp),%eax
  801257:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  80125a:	8b 45 08             	mov    0x8(%ebp),%eax
  80125d:	83 ec 08             	sub    $0x8,%esp
  801260:	ff 75 f4             	pushl  -0xc(%ebp)
  801263:	50                   	push   %eax
  801264:	e8 48 ff ff ff       	call   8011b1 <vcprintf>
  801269:	83 c4 10             	add    $0x10,%esp
  80126c:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	sys_enable_interrupt();
  80126f:	e8 4d 14 00 00       	call   8026c1 <sys_enable_interrupt>
	return cnt;
  801274:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801277:	c9                   	leave  
  801278:	c3                   	ret    

00801279 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  801279:	55                   	push   %ebp
  80127a:	89 e5                	mov    %esp,%ebp
  80127c:	53                   	push   %ebx
  80127d:	83 ec 14             	sub    $0x14,%esp
  801280:	8b 45 10             	mov    0x10(%ebp),%eax
  801283:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801286:	8b 45 14             	mov    0x14(%ebp),%eax
  801289:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  80128c:	8b 45 18             	mov    0x18(%ebp),%eax
  80128f:	ba 00 00 00 00       	mov    $0x0,%edx
  801294:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  801297:	77 55                	ja     8012ee <printnum+0x75>
  801299:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  80129c:	72 05                	jb     8012a3 <printnum+0x2a>
  80129e:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8012a1:	77 4b                	ja     8012ee <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  8012a3:	8b 45 1c             	mov    0x1c(%ebp),%eax
  8012a6:	8d 58 ff             	lea    -0x1(%eax),%ebx
  8012a9:	8b 45 18             	mov    0x18(%ebp),%eax
  8012ac:	ba 00 00 00 00       	mov    $0x0,%edx
  8012b1:	52                   	push   %edx
  8012b2:	50                   	push   %eax
  8012b3:	ff 75 f4             	pushl  -0xc(%ebp)
  8012b6:	ff 75 f0             	pushl  -0x10(%ebp)
  8012b9:	e8 86 28 00 00       	call   803b44 <__udivdi3>
  8012be:	83 c4 10             	add    $0x10,%esp
  8012c1:	83 ec 04             	sub    $0x4,%esp
  8012c4:	ff 75 20             	pushl  0x20(%ebp)
  8012c7:	53                   	push   %ebx
  8012c8:	ff 75 18             	pushl  0x18(%ebp)
  8012cb:	52                   	push   %edx
  8012cc:	50                   	push   %eax
  8012cd:	ff 75 0c             	pushl  0xc(%ebp)
  8012d0:	ff 75 08             	pushl  0x8(%ebp)
  8012d3:	e8 a1 ff ff ff       	call   801279 <printnum>
  8012d8:	83 c4 20             	add    $0x20,%esp
  8012db:	eb 1a                	jmp    8012f7 <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  8012dd:	83 ec 08             	sub    $0x8,%esp
  8012e0:	ff 75 0c             	pushl  0xc(%ebp)
  8012e3:	ff 75 20             	pushl  0x20(%ebp)
  8012e6:	8b 45 08             	mov    0x8(%ebp),%eax
  8012e9:	ff d0                	call   *%eax
  8012eb:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  8012ee:	ff 4d 1c             	decl   0x1c(%ebp)
  8012f1:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  8012f5:	7f e6                	jg     8012dd <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  8012f7:	8b 4d 18             	mov    0x18(%ebp),%ecx
  8012fa:	bb 00 00 00 00       	mov    $0x0,%ebx
  8012ff:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801302:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801305:	53                   	push   %ebx
  801306:	51                   	push   %ecx
  801307:	52                   	push   %edx
  801308:	50                   	push   %eax
  801309:	e8 46 29 00 00       	call   803c54 <__umoddi3>
  80130e:	83 c4 10             	add    $0x10,%esp
  801311:	05 34 43 80 00       	add    $0x804334,%eax
  801316:	8a 00                	mov    (%eax),%al
  801318:	0f be c0             	movsbl %al,%eax
  80131b:	83 ec 08             	sub    $0x8,%esp
  80131e:	ff 75 0c             	pushl  0xc(%ebp)
  801321:	50                   	push   %eax
  801322:	8b 45 08             	mov    0x8(%ebp),%eax
  801325:	ff d0                	call   *%eax
  801327:	83 c4 10             	add    $0x10,%esp
}
  80132a:	90                   	nop
  80132b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80132e:	c9                   	leave  
  80132f:	c3                   	ret    

00801330 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  801330:	55                   	push   %ebp
  801331:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  801333:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  801337:	7e 1c                	jle    801355 <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  801339:	8b 45 08             	mov    0x8(%ebp),%eax
  80133c:	8b 00                	mov    (%eax),%eax
  80133e:	8d 50 08             	lea    0x8(%eax),%edx
  801341:	8b 45 08             	mov    0x8(%ebp),%eax
  801344:	89 10                	mov    %edx,(%eax)
  801346:	8b 45 08             	mov    0x8(%ebp),%eax
  801349:	8b 00                	mov    (%eax),%eax
  80134b:	83 e8 08             	sub    $0x8,%eax
  80134e:	8b 50 04             	mov    0x4(%eax),%edx
  801351:	8b 00                	mov    (%eax),%eax
  801353:	eb 40                	jmp    801395 <getuint+0x65>
	else if (lflag)
  801355:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801359:	74 1e                	je     801379 <getuint+0x49>
		return va_arg(*ap, unsigned long);
  80135b:	8b 45 08             	mov    0x8(%ebp),%eax
  80135e:	8b 00                	mov    (%eax),%eax
  801360:	8d 50 04             	lea    0x4(%eax),%edx
  801363:	8b 45 08             	mov    0x8(%ebp),%eax
  801366:	89 10                	mov    %edx,(%eax)
  801368:	8b 45 08             	mov    0x8(%ebp),%eax
  80136b:	8b 00                	mov    (%eax),%eax
  80136d:	83 e8 04             	sub    $0x4,%eax
  801370:	8b 00                	mov    (%eax),%eax
  801372:	ba 00 00 00 00       	mov    $0x0,%edx
  801377:	eb 1c                	jmp    801395 <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  801379:	8b 45 08             	mov    0x8(%ebp),%eax
  80137c:	8b 00                	mov    (%eax),%eax
  80137e:	8d 50 04             	lea    0x4(%eax),%edx
  801381:	8b 45 08             	mov    0x8(%ebp),%eax
  801384:	89 10                	mov    %edx,(%eax)
  801386:	8b 45 08             	mov    0x8(%ebp),%eax
  801389:	8b 00                	mov    (%eax),%eax
  80138b:	83 e8 04             	sub    $0x4,%eax
  80138e:	8b 00                	mov    (%eax),%eax
  801390:	ba 00 00 00 00       	mov    $0x0,%edx
}
  801395:	5d                   	pop    %ebp
  801396:	c3                   	ret    

00801397 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  801397:	55                   	push   %ebp
  801398:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  80139a:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  80139e:	7e 1c                	jle    8013bc <getint+0x25>
		return va_arg(*ap, long long);
  8013a0:	8b 45 08             	mov    0x8(%ebp),%eax
  8013a3:	8b 00                	mov    (%eax),%eax
  8013a5:	8d 50 08             	lea    0x8(%eax),%edx
  8013a8:	8b 45 08             	mov    0x8(%ebp),%eax
  8013ab:	89 10                	mov    %edx,(%eax)
  8013ad:	8b 45 08             	mov    0x8(%ebp),%eax
  8013b0:	8b 00                	mov    (%eax),%eax
  8013b2:	83 e8 08             	sub    $0x8,%eax
  8013b5:	8b 50 04             	mov    0x4(%eax),%edx
  8013b8:	8b 00                	mov    (%eax),%eax
  8013ba:	eb 38                	jmp    8013f4 <getint+0x5d>
	else if (lflag)
  8013bc:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8013c0:	74 1a                	je     8013dc <getint+0x45>
		return va_arg(*ap, long);
  8013c2:	8b 45 08             	mov    0x8(%ebp),%eax
  8013c5:	8b 00                	mov    (%eax),%eax
  8013c7:	8d 50 04             	lea    0x4(%eax),%edx
  8013ca:	8b 45 08             	mov    0x8(%ebp),%eax
  8013cd:	89 10                	mov    %edx,(%eax)
  8013cf:	8b 45 08             	mov    0x8(%ebp),%eax
  8013d2:	8b 00                	mov    (%eax),%eax
  8013d4:	83 e8 04             	sub    $0x4,%eax
  8013d7:	8b 00                	mov    (%eax),%eax
  8013d9:	99                   	cltd   
  8013da:	eb 18                	jmp    8013f4 <getint+0x5d>
	else
		return va_arg(*ap, int);
  8013dc:	8b 45 08             	mov    0x8(%ebp),%eax
  8013df:	8b 00                	mov    (%eax),%eax
  8013e1:	8d 50 04             	lea    0x4(%eax),%edx
  8013e4:	8b 45 08             	mov    0x8(%ebp),%eax
  8013e7:	89 10                	mov    %edx,(%eax)
  8013e9:	8b 45 08             	mov    0x8(%ebp),%eax
  8013ec:	8b 00                	mov    (%eax),%eax
  8013ee:	83 e8 04             	sub    $0x4,%eax
  8013f1:	8b 00                	mov    (%eax),%eax
  8013f3:	99                   	cltd   
}
  8013f4:	5d                   	pop    %ebp
  8013f5:	c3                   	ret    

008013f6 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  8013f6:	55                   	push   %ebp
  8013f7:	89 e5                	mov    %esp,%ebp
  8013f9:	56                   	push   %esi
  8013fa:	53                   	push   %ebx
  8013fb:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8013fe:	eb 17                	jmp    801417 <vprintfmt+0x21>
			if (ch == '\0')
  801400:	85 db                	test   %ebx,%ebx
  801402:	0f 84 af 03 00 00    	je     8017b7 <vprintfmt+0x3c1>
				return;
			putch(ch, putdat);
  801408:	83 ec 08             	sub    $0x8,%esp
  80140b:	ff 75 0c             	pushl  0xc(%ebp)
  80140e:	53                   	push   %ebx
  80140f:	8b 45 08             	mov    0x8(%ebp),%eax
  801412:	ff d0                	call   *%eax
  801414:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  801417:	8b 45 10             	mov    0x10(%ebp),%eax
  80141a:	8d 50 01             	lea    0x1(%eax),%edx
  80141d:	89 55 10             	mov    %edx,0x10(%ebp)
  801420:	8a 00                	mov    (%eax),%al
  801422:	0f b6 d8             	movzbl %al,%ebx
  801425:	83 fb 25             	cmp    $0x25,%ebx
  801428:	75 d6                	jne    801400 <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  80142a:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  80142e:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  801435:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  80143c:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  801443:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  80144a:	8b 45 10             	mov    0x10(%ebp),%eax
  80144d:	8d 50 01             	lea    0x1(%eax),%edx
  801450:	89 55 10             	mov    %edx,0x10(%ebp)
  801453:	8a 00                	mov    (%eax),%al
  801455:	0f b6 d8             	movzbl %al,%ebx
  801458:	8d 43 dd             	lea    -0x23(%ebx),%eax
  80145b:	83 f8 55             	cmp    $0x55,%eax
  80145e:	0f 87 2b 03 00 00    	ja     80178f <vprintfmt+0x399>
  801464:	8b 04 85 58 43 80 00 	mov    0x804358(,%eax,4),%eax
  80146b:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  80146d:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  801471:	eb d7                	jmp    80144a <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  801473:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  801477:	eb d1                	jmp    80144a <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  801479:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  801480:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801483:	89 d0                	mov    %edx,%eax
  801485:	c1 e0 02             	shl    $0x2,%eax
  801488:	01 d0                	add    %edx,%eax
  80148a:	01 c0                	add    %eax,%eax
  80148c:	01 d8                	add    %ebx,%eax
  80148e:	83 e8 30             	sub    $0x30,%eax
  801491:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  801494:	8b 45 10             	mov    0x10(%ebp),%eax
  801497:	8a 00                	mov    (%eax),%al
  801499:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  80149c:	83 fb 2f             	cmp    $0x2f,%ebx
  80149f:	7e 3e                	jle    8014df <vprintfmt+0xe9>
  8014a1:	83 fb 39             	cmp    $0x39,%ebx
  8014a4:	7f 39                	jg     8014df <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8014a6:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  8014a9:	eb d5                	jmp    801480 <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  8014ab:	8b 45 14             	mov    0x14(%ebp),%eax
  8014ae:	83 c0 04             	add    $0x4,%eax
  8014b1:	89 45 14             	mov    %eax,0x14(%ebp)
  8014b4:	8b 45 14             	mov    0x14(%ebp),%eax
  8014b7:	83 e8 04             	sub    $0x4,%eax
  8014ba:	8b 00                	mov    (%eax),%eax
  8014bc:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  8014bf:	eb 1f                	jmp    8014e0 <vprintfmt+0xea>

		case '.':
			if (width < 0)
  8014c1:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8014c5:	79 83                	jns    80144a <vprintfmt+0x54>
				width = 0;
  8014c7:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  8014ce:	e9 77 ff ff ff       	jmp    80144a <vprintfmt+0x54>

		case '#':
			altflag = 1;
  8014d3:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  8014da:	e9 6b ff ff ff       	jmp    80144a <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  8014df:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  8014e0:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8014e4:	0f 89 60 ff ff ff    	jns    80144a <vprintfmt+0x54>
				width = precision, precision = -1;
  8014ea:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8014ed:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8014f0:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  8014f7:	e9 4e ff ff ff       	jmp    80144a <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  8014fc:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  8014ff:	e9 46 ff ff ff       	jmp    80144a <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  801504:	8b 45 14             	mov    0x14(%ebp),%eax
  801507:	83 c0 04             	add    $0x4,%eax
  80150a:	89 45 14             	mov    %eax,0x14(%ebp)
  80150d:	8b 45 14             	mov    0x14(%ebp),%eax
  801510:	83 e8 04             	sub    $0x4,%eax
  801513:	8b 00                	mov    (%eax),%eax
  801515:	83 ec 08             	sub    $0x8,%esp
  801518:	ff 75 0c             	pushl  0xc(%ebp)
  80151b:	50                   	push   %eax
  80151c:	8b 45 08             	mov    0x8(%ebp),%eax
  80151f:	ff d0                	call   *%eax
  801521:	83 c4 10             	add    $0x10,%esp
			break;
  801524:	e9 89 02 00 00       	jmp    8017b2 <vprintfmt+0x3bc>

		// error message
		case 'e':
			err = va_arg(ap, int);
  801529:	8b 45 14             	mov    0x14(%ebp),%eax
  80152c:	83 c0 04             	add    $0x4,%eax
  80152f:	89 45 14             	mov    %eax,0x14(%ebp)
  801532:	8b 45 14             	mov    0x14(%ebp),%eax
  801535:	83 e8 04             	sub    $0x4,%eax
  801538:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  80153a:	85 db                	test   %ebx,%ebx
  80153c:	79 02                	jns    801540 <vprintfmt+0x14a>
				err = -err;
  80153e:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  801540:	83 fb 64             	cmp    $0x64,%ebx
  801543:	7f 0b                	jg     801550 <vprintfmt+0x15a>
  801545:	8b 34 9d a0 41 80 00 	mov    0x8041a0(,%ebx,4),%esi
  80154c:	85 f6                	test   %esi,%esi
  80154e:	75 19                	jne    801569 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  801550:	53                   	push   %ebx
  801551:	68 45 43 80 00       	push   $0x804345
  801556:	ff 75 0c             	pushl  0xc(%ebp)
  801559:	ff 75 08             	pushl  0x8(%ebp)
  80155c:	e8 5e 02 00 00       	call   8017bf <printfmt>
  801561:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  801564:	e9 49 02 00 00       	jmp    8017b2 <vprintfmt+0x3bc>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  801569:	56                   	push   %esi
  80156a:	68 4e 43 80 00       	push   $0x80434e
  80156f:	ff 75 0c             	pushl  0xc(%ebp)
  801572:	ff 75 08             	pushl  0x8(%ebp)
  801575:	e8 45 02 00 00       	call   8017bf <printfmt>
  80157a:	83 c4 10             	add    $0x10,%esp
			break;
  80157d:	e9 30 02 00 00       	jmp    8017b2 <vprintfmt+0x3bc>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  801582:	8b 45 14             	mov    0x14(%ebp),%eax
  801585:	83 c0 04             	add    $0x4,%eax
  801588:	89 45 14             	mov    %eax,0x14(%ebp)
  80158b:	8b 45 14             	mov    0x14(%ebp),%eax
  80158e:	83 e8 04             	sub    $0x4,%eax
  801591:	8b 30                	mov    (%eax),%esi
  801593:	85 f6                	test   %esi,%esi
  801595:	75 05                	jne    80159c <vprintfmt+0x1a6>
				p = "(null)";
  801597:	be 51 43 80 00       	mov    $0x804351,%esi
			if (width > 0 && padc != '-')
  80159c:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8015a0:	7e 6d                	jle    80160f <vprintfmt+0x219>
  8015a2:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  8015a6:	74 67                	je     80160f <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  8015a8:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8015ab:	83 ec 08             	sub    $0x8,%esp
  8015ae:	50                   	push   %eax
  8015af:	56                   	push   %esi
  8015b0:	e8 0c 03 00 00       	call   8018c1 <strnlen>
  8015b5:	83 c4 10             	add    $0x10,%esp
  8015b8:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  8015bb:	eb 16                	jmp    8015d3 <vprintfmt+0x1dd>
					putch(padc, putdat);
  8015bd:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  8015c1:	83 ec 08             	sub    $0x8,%esp
  8015c4:	ff 75 0c             	pushl  0xc(%ebp)
  8015c7:	50                   	push   %eax
  8015c8:	8b 45 08             	mov    0x8(%ebp),%eax
  8015cb:	ff d0                	call   *%eax
  8015cd:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  8015d0:	ff 4d e4             	decl   -0x1c(%ebp)
  8015d3:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8015d7:	7f e4                	jg     8015bd <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8015d9:	eb 34                	jmp    80160f <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  8015db:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  8015df:	74 1c                	je     8015fd <vprintfmt+0x207>
  8015e1:	83 fb 1f             	cmp    $0x1f,%ebx
  8015e4:	7e 05                	jle    8015eb <vprintfmt+0x1f5>
  8015e6:	83 fb 7e             	cmp    $0x7e,%ebx
  8015e9:	7e 12                	jle    8015fd <vprintfmt+0x207>
					putch('?', putdat);
  8015eb:	83 ec 08             	sub    $0x8,%esp
  8015ee:	ff 75 0c             	pushl  0xc(%ebp)
  8015f1:	6a 3f                	push   $0x3f
  8015f3:	8b 45 08             	mov    0x8(%ebp),%eax
  8015f6:	ff d0                	call   *%eax
  8015f8:	83 c4 10             	add    $0x10,%esp
  8015fb:	eb 0f                	jmp    80160c <vprintfmt+0x216>
				else
					putch(ch, putdat);
  8015fd:	83 ec 08             	sub    $0x8,%esp
  801600:	ff 75 0c             	pushl  0xc(%ebp)
  801603:	53                   	push   %ebx
  801604:	8b 45 08             	mov    0x8(%ebp),%eax
  801607:	ff d0                	call   *%eax
  801609:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  80160c:	ff 4d e4             	decl   -0x1c(%ebp)
  80160f:	89 f0                	mov    %esi,%eax
  801611:	8d 70 01             	lea    0x1(%eax),%esi
  801614:	8a 00                	mov    (%eax),%al
  801616:	0f be d8             	movsbl %al,%ebx
  801619:	85 db                	test   %ebx,%ebx
  80161b:	74 24                	je     801641 <vprintfmt+0x24b>
  80161d:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  801621:	78 b8                	js     8015db <vprintfmt+0x1e5>
  801623:	ff 4d e0             	decl   -0x20(%ebp)
  801626:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80162a:	79 af                	jns    8015db <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  80162c:	eb 13                	jmp    801641 <vprintfmt+0x24b>
				putch(' ', putdat);
  80162e:	83 ec 08             	sub    $0x8,%esp
  801631:	ff 75 0c             	pushl  0xc(%ebp)
  801634:	6a 20                	push   $0x20
  801636:	8b 45 08             	mov    0x8(%ebp),%eax
  801639:	ff d0                	call   *%eax
  80163b:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  80163e:	ff 4d e4             	decl   -0x1c(%ebp)
  801641:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  801645:	7f e7                	jg     80162e <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  801647:	e9 66 01 00 00       	jmp    8017b2 <vprintfmt+0x3bc>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  80164c:	83 ec 08             	sub    $0x8,%esp
  80164f:	ff 75 e8             	pushl  -0x18(%ebp)
  801652:	8d 45 14             	lea    0x14(%ebp),%eax
  801655:	50                   	push   %eax
  801656:	e8 3c fd ff ff       	call   801397 <getint>
  80165b:	83 c4 10             	add    $0x10,%esp
  80165e:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801661:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  801664:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801667:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80166a:	85 d2                	test   %edx,%edx
  80166c:	79 23                	jns    801691 <vprintfmt+0x29b>
				putch('-', putdat);
  80166e:	83 ec 08             	sub    $0x8,%esp
  801671:	ff 75 0c             	pushl  0xc(%ebp)
  801674:	6a 2d                	push   $0x2d
  801676:	8b 45 08             	mov    0x8(%ebp),%eax
  801679:	ff d0                	call   *%eax
  80167b:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  80167e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801681:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801684:	f7 d8                	neg    %eax
  801686:	83 d2 00             	adc    $0x0,%edx
  801689:	f7 da                	neg    %edx
  80168b:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80168e:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  801691:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  801698:	e9 bc 00 00 00       	jmp    801759 <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  80169d:	83 ec 08             	sub    $0x8,%esp
  8016a0:	ff 75 e8             	pushl  -0x18(%ebp)
  8016a3:	8d 45 14             	lea    0x14(%ebp),%eax
  8016a6:	50                   	push   %eax
  8016a7:	e8 84 fc ff ff       	call   801330 <getuint>
  8016ac:	83 c4 10             	add    $0x10,%esp
  8016af:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8016b2:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  8016b5:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  8016bc:	e9 98 00 00 00       	jmp    801759 <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  8016c1:	83 ec 08             	sub    $0x8,%esp
  8016c4:	ff 75 0c             	pushl  0xc(%ebp)
  8016c7:	6a 58                	push   $0x58
  8016c9:	8b 45 08             	mov    0x8(%ebp),%eax
  8016cc:	ff d0                	call   *%eax
  8016ce:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  8016d1:	83 ec 08             	sub    $0x8,%esp
  8016d4:	ff 75 0c             	pushl  0xc(%ebp)
  8016d7:	6a 58                	push   $0x58
  8016d9:	8b 45 08             	mov    0x8(%ebp),%eax
  8016dc:	ff d0                	call   *%eax
  8016de:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  8016e1:	83 ec 08             	sub    $0x8,%esp
  8016e4:	ff 75 0c             	pushl  0xc(%ebp)
  8016e7:	6a 58                	push   $0x58
  8016e9:	8b 45 08             	mov    0x8(%ebp),%eax
  8016ec:	ff d0                	call   *%eax
  8016ee:	83 c4 10             	add    $0x10,%esp
			break;
  8016f1:	e9 bc 00 00 00       	jmp    8017b2 <vprintfmt+0x3bc>

		// pointer
		case 'p':
			putch('0', putdat);
  8016f6:	83 ec 08             	sub    $0x8,%esp
  8016f9:	ff 75 0c             	pushl  0xc(%ebp)
  8016fc:	6a 30                	push   $0x30
  8016fe:	8b 45 08             	mov    0x8(%ebp),%eax
  801701:	ff d0                	call   *%eax
  801703:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  801706:	83 ec 08             	sub    $0x8,%esp
  801709:	ff 75 0c             	pushl  0xc(%ebp)
  80170c:	6a 78                	push   $0x78
  80170e:	8b 45 08             	mov    0x8(%ebp),%eax
  801711:	ff d0                	call   *%eax
  801713:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  801716:	8b 45 14             	mov    0x14(%ebp),%eax
  801719:	83 c0 04             	add    $0x4,%eax
  80171c:	89 45 14             	mov    %eax,0x14(%ebp)
  80171f:	8b 45 14             	mov    0x14(%ebp),%eax
  801722:	83 e8 04             	sub    $0x4,%eax
  801725:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  801727:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80172a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  801731:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  801738:	eb 1f                	jmp    801759 <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  80173a:	83 ec 08             	sub    $0x8,%esp
  80173d:	ff 75 e8             	pushl  -0x18(%ebp)
  801740:	8d 45 14             	lea    0x14(%ebp),%eax
  801743:	50                   	push   %eax
  801744:	e8 e7 fb ff ff       	call   801330 <getuint>
  801749:	83 c4 10             	add    $0x10,%esp
  80174c:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80174f:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  801752:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  801759:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  80175d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801760:	83 ec 04             	sub    $0x4,%esp
  801763:	52                   	push   %edx
  801764:	ff 75 e4             	pushl  -0x1c(%ebp)
  801767:	50                   	push   %eax
  801768:	ff 75 f4             	pushl  -0xc(%ebp)
  80176b:	ff 75 f0             	pushl  -0x10(%ebp)
  80176e:	ff 75 0c             	pushl  0xc(%ebp)
  801771:	ff 75 08             	pushl  0x8(%ebp)
  801774:	e8 00 fb ff ff       	call   801279 <printnum>
  801779:	83 c4 20             	add    $0x20,%esp
			break;
  80177c:	eb 34                	jmp    8017b2 <vprintfmt+0x3bc>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  80177e:	83 ec 08             	sub    $0x8,%esp
  801781:	ff 75 0c             	pushl  0xc(%ebp)
  801784:	53                   	push   %ebx
  801785:	8b 45 08             	mov    0x8(%ebp),%eax
  801788:	ff d0                	call   *%eax
  80178a:	83 c4 10             	add    $0x10,%esp
			break;
  80178d:	eb 23                	jmp    8017b2 <vprintfmt+0x3bc>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  80178f:	83 ec 08             	sub    $0x8,%esp
  801792:	ff 75 0c             	pushl  0xc(%ebp)
  801795:	6a 25                	push   $0x25
  801797:	8b 45 08             	mov    0x8(%ebp),%eax
  80179a:	ff d0                	call   *%eax
  80179c:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  80179f:	ff 4d 10             	decl   0x10(%ebp)
  8017a2:	eb 03                	jmp    8017a7 <vprintfmt+0x3b1>
  8017a4:	ff 4d 10             	decl   0x10(%ebp)
  8017a7:	8b 45 10             	mov    0x10(%ebp),%eax
  8017aa:	48                   	dec    %eax
  8017ab:	8a 00                	mov    (%eax),%al
  8017ad:	3c 25                	cmp    $0x25,%al
  8017af:	75 f3                	jne    8017a4 <vprintfmt+0x3ae>
				/* do nothing */;
			break;
  8017b1:	90                   	nop
		}
	}
  8017b2:	e9 47 fc ff ff       	jmp    8013fe <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  8017b7:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  8017b8:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8017bb:	5b                   	pop    %ebx
  8017bc:	5e                   	pop    %esi
  8017bd:	5d                   	pop    %ebp
  8017be:	c3                   	ret    

008017bf <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  8017bf:	55                   	push   %ebp
  8017c0:	89 e5                	mov    %esp,%ebp
  8017c2:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  8017c5:	8d 45 10             	lea    0x10(%ebp),%eax
  8017c8:	83 c0 04             	add    $0x4,%eax
  8017cb:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  8017ce:	8b 45 10             	mov    0x10(%ebp),%eax
  8017d1:	ff 75 f4             	pushl  -0xc(%ebp)
  8017d4:	50                   	push   %eax
  8017d5:	ff 75 0c             	pushl  0xc(%ebp)
  8017d8:	ff 75 08             	pushl  0x8(%ebp)
  8017db:	e8 16 fc ff ff       	call   8013f6 <vprintfmt>
  8017e0:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  8017e3:	90                   	nop
  8017e4:	c9                   	leave  
  8017e5:	c3                   	ret    

008017e6 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  8017e6:	55                   	push   %ebp
  8017e7:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  8017e9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8017ec:	8b 40 08             	mov    0x8(%eax),%eax
  8017ef:	8d 50 01             	lea    0x1(%eax),%edx
  8017f2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8017f5:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  8017f8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8017fb:	8b 10                	mov    (%eax),%edx
  8017fd:	8b 45 0c             	mov    0xc(%ebp),%eax
  801800:	8b 40 04             	mov    0x4(%eax),%eax
  801803:	39 c2                	cmp    %eax,%edx
  801805:	73 12                	jae    801819 <sprintputch+0x33>
		*b->buf++ = ch;
  801807:	8b 45 0c             	mov    0xc(%ebp),%eax
  80180a:	8b 00                	mov    (%eax),%eax
  80180c:	8d 48 01             	lea    0x1(%eax),%ecx
  80180f:	8b 55 0c             	mov    0xc(%ebp),%edx
  801812:	89 0a                	mov    %ecx,(%edx)
  801814:	8b 55 08             	mov    0x8(%ebp),%edx
  801817:	88 10                	mov    %dl,(%eax)
}
  801819:	90                   	nop
  80181a:	5d                   	pop    %ebp
  80181b:	c3                   	ret    

0080181c <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  80181c:	55                   	push   %ebp
  80181d:	89 e5                	mov    %esp,%ebp
  80181f:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  801822:	8b 45 08             	mov    0x8(%ebp),%eax
  801825:	89 45 ec             	mov    %eax,-0x14(%ebp)
  801828:	8b 45 0c             	mov    0xc(%ebp),%eax
  80182b:	8d 50 ff             	lea    -0x1(%eax),%edx
  80182e:	8b 45 08             	mov    0x8(%ebp),%eax
  801831:	01 d0                	add    %edx,%eax
  801833:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801836:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  80183d:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801841:	74 06                	je     801849 <vsnprintf+0x2d>
  801843:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801847:	7f 07                	jg     801850 <vsnprintf+0x34>
		return -E_INVAL;
  801849:	b8 03 00 00 00       	mov    $0x3,%eax
  80184e:	eb 20                	jmp    801870 <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  801850:	ff 75 14             	pushl  0x14(%ebp)
  801853:	ff 75 10             	pushl  0x10(%ebp)
  801856:	8d 45 ec             	lea    -0x14(%ebp),%eax
  801859:	50                   	push   %eax
  80185a:	68 e6 17 80 00       	push   $0x8017e6
  80185f:	e8 92 fb ff ff       	call   8013f6 <vprintfmt>
  801864:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  801867:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80186a:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  80186d:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  801870:	c9                   	leave  
  801871:	c3                   	ret    

00801872 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  801872:	55                   	push   %ebp
  801873:	89 e5                	mov    %esp,%ebp
  801875:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  801878:	8d 45 10             	lea    0x10(%ebp),%eax
  80187b:	83 c0 04             	add    $0x4,%eax
  80187e:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  801881:	8b 45 10             	mov    0x10(%ebp),%eax
  801884:	ff 75 f4             	pushl  -0xc(%ebp)
  801887:	50                   	push   %eax
  801888:	ff 75 0c             	pushl  0xc(%ebp)
  80188b:	ff 75 08             	pushl  0x8(%ebp)
  80188e:	e8 89 ff ff ff       	call   80181c <vsnprintf>
  801893:	83 c4 10             	add    $0x10,%esp
  801896:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  801899:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  80189c:	c9                   	leave  
  80189d:	c3                   	ret    

0080189e <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  80189e:	55                   	push   %ebp
  80189f:	89 e5                	mov    %esp,%ebp
  8018a1:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  8018a4:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8018ab:	eb 06                	jmp    8018b3 <strlen+0x15>
		n++;
  8018ad:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  8018b0:	ff 45 08             	incl   0x8(%ebp)
  8018b3:	8b 45 08             	mov    0x8(%ebp),%eax
  8018b6:	8a 00                	mov    (%eax),%al
  8018b8:	84 c0                	test   %al,%al
  8018ba:	75 f1                	jne    8018ad <strlen+0xf>
		n++;
	return n;
  8018bc:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  8018bf:	c9                   	leave  
  8018c0:	c3                   	ret    

008018c1 <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  8018c1:	55                   	push   %ebp
  8018c2:	89 e5                	mov    %esp,%ebp
  8018c4:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8018c7:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8018ce:	eb 09                	jmp    8018d9 <strnlen+0x18>
		n++;
  8018d0:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8018d3:	ff 45 08             	incl   0x8(%ebp)
  8018d6:	ff 4d 0c             	decl   0xc(%ebp)
  8018d9:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8018dd:	74 09                	je     8018e8 <strnlen+0x27>
  8018df:	8b 45 08             	mov    0x8(%ebp),%eax
  8018e2:	8a 00                	mov    (%eax),%al
  8018e4:	84 c0                	test   %al,%al
  8018e6:	75 e8                	jne    8018d0 <strnlen+0xf>
		n++;
	return n;
  8018e8:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  8018eb:	c9                   	leave  
  8018ec:	c3                   	ret    

008018ed <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  8018ed:	55                   	push   %ebp
  8018ee:	89 e5                	mov    %esp,%ebp
  8018f0:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  8018f3:	8b 45 08             	mov    0x8(%ebp),%eax
  8018f6:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  8018f9:	90                   	nop
  8018fa:	8b 45 08             	mov    0x8(%ebp),%eax
  8018fd:	8d 50 01             	lea    0x1(%eax),%edx
  801900:	89 55 08             	mov    %edx,0x8(%ebp)
  801903:	8b 55 0c             	mov    0xc(%ebp),%edx
  801906:	8d 4a 01             	lea    0x1(%edx),%ecx
  801909:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  80190c:	8a 12                	mov    (%edx),%dl
  80190e:	88 10                	mov    %dl,(%eax)
  801910:	8a 00                	mov    (%eax),%al
  801912:	84 c0                	test   %al,%al
  801914:	75 e4                	jne    8018fa <strcpy+0xd>
		/* do nothing */;
	return ret;
  801916:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  801919:	c9                   	leave  
  80191a:	c3                   	ret    

0080191b <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  80191b:	55                   	push   %ebp
  80191c:	89 e5                	mov    %esp,%ebp
  80191e:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  801921:	8b 45 08             	mov    0x8(%ebp),%eax
  801924:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  801927:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  80192e:	eb 1f                	jmp    80194f <strncpy+0x34>
		*dst++ = *src;
  801930:	8b 45 08             	mov    0x8(%ebp),%eax
  801933:	8d 50 01             	lea    0x1(%eax),%edx
  801936:	89 55 08             	mov    %edx,0x8(%ebp)
  801939:	8b 55 0c             	mov    0xc(%ebp),%edx
  80193c:	8a 12                	mov    (%edx),%dl
  80193e:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  801940:	8b 45 0c             	mov    0xc(%ebp),%eax
  801943:	8a 00                	mov    (%eax),%al
  801945:	84 c0                	test   %al,%al
  801947:	74 03                	je     80194c <strncpy+0x31>
			src++;
  801949:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  80194c:	ff 45 fc             	incl   -0x4(%ebp)
  80194f:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801952:	3b 45 10             	cmp    0x10(%ebp),%eax
  801955:	72 d9                	jb     801930 <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  801957:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  80195a:	c9                   	leave  
  80195b:	c3                   	ret    

0080195c <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  80195c:	55                   	push   %ebp
  80195d:	89 e5                	mov    %esp,%ebp
  80195f:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  801962:	8b 45 08             	mov    0x8(%ebp),%eax
  801965:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  801968:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80196c:	74 30                	je     80199e <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  80196e:	eb 16                	jmp    801986 <strlcpy+0x2a>
			*dst++ = *src++;
  801970:	8b 45 08             	mov    0x8(%ebp),%eax
  801973:	8d 50 01             	lea    0x1(%eax),%edx
  801976:	89 55 08             	mov    %edx,0x8(%ebp)
  801979:	8b 55 0c             	mov    0xc(%ebp),%edx
  80197c:	8d 4a 01             	lea    0x1(%edx),%ecx
  80197f:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  801982:	8a 12                	mov    (%edx),%dl
  801984:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  801986:	ff 4d 10             	decl   0x10(%ebp)
  801989:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80198d:	74 09                	je     801998 <strlcpy+0x3c>
  80198f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801992:	8a 00                	mov    (%eax),%al
  801994:	84 c0                	test   %al,%al
  801996:	75 d8                	jne    801970 <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  801998:	8b 45 08             	mov    0x8(%ebp),%eax
  80199b:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  80199e:	8b 55 08             	mov    0x8(%ebp),%edx
  8019a1:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8019a4:	29 c2                	sub    %eax,%edx
  8019a6:	89 d0                	mov    %edx,%eax
}
  8019a8:	c9                   	leave  
  8019a9:	c3                   	ret    

008019aa <strcmp>:

int
strcmp(const char *p, const char *q)
{
  8019aa:	55                   	push   %ebp
  8019ab:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  8019ad:	eb 06                	jmp    8019b5 <strcmp+0xb>
		p++, q++;
  8019af:	ff 45 08             	incl   0x8(%ebp)
  8019b2:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  8019b5:	8b 45 08             	mov    0x8(%ebp),%eax
  8019b8:	8a 00                	mov    (%eax),%al
  8019ba:	84 c0                	test   %al,%al
  8019bc:	74 0e                	je     8019cc <strcmp+0x22>
  8019be:	8b 45 08             	mov    0x8(%ebp),%eax
  8019c1:	8a 10                	mov    (%eax),%dl
  8019c3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8019c6:	8a 00                	mov    (%eax),%al
  8019c8:	38 c2                	cmp    %al,%dl
  8019ca:	74 e3                	je     8019af <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  8019cc:	8b 45 08             	mov    0x8(%ebp),%eax
  8019cf:	8a 00                	mov    (%eax),%al
  8019d1:	0f b6 d0             	movzbl %al,%edx
  8019d4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8019d7:	8a 00                	mov    (%eax),%al
  8019d9:	0f b6 c0             	movzbl %al,%eax
  8019dc:	29 c2                	sub    %eax,%edx
  8019de:	89 d0                	mov    %edx,%eax
}
  8019e0:	5d                   	pop    %ebp
  8019e1:	c3                   	ret    

008019e2 <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  8019e2:	55                   	push   %ebp
  8019e3:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  8019e5:	eb 09                	jmp    8019f0 <strncmp+0xe>
		n--, p++, q++;
  8019e7:	ff 4d 10             	decl   0x10(%ebp)
  8019ea:	ff 45 08             	incl   0x8(%ebp)
  8019ed:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  8019f0:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8019f4:	74 17                	je     801a0d <strncmp+0x2b>
  8019f6:	8b 45 08             	mov    0x8(%ebp),%eax
  8019f9:	8a 00                	mov    (%eax),%al
  8019fb:	84 c0                	test   %al,%al
  8019fd:	74 0e                	je     801a0d <strncmp+0x2b>
  8019ff:	8b 45 08             	mov    0x8(%ebp),%eax
  801a02:	8a 10                	mov    (%eax),%dl
  801a04:	8b 45 0c             	mov    0xc(%ebp),%eax
  801a07:	8a 00                	mov    (%eax),%al
  801a09:	38 c2                	cmp    %al,%dl
  801a0b:	74 da                	je     8019e7 <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  801a0d:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801a11:	75 07                	jne    801a1a <strncmp+0x38>
		return 0;
  801a13:	b8 00 00 00 00       	mov    $0x0,%eax
  801a18:	eb 14                	jmp    801a2e <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  801a1a:	8b 45 08             	mov    0x8(%ebp),%eax
  801a1d:	8a 00                	mov    (%eax),%al
  801a1f:	0f b6 d0             	movzbl %al,%edx
  801a22:	8b 45 0c             	mov    0xc(%ebp),%eax
  801a25:	8a 00                	mov    (%eax),%al
  801a27:	0f b6 c0             	movzbl %al,%eax
  801a2a:	29 c2                	sub    %eax,%edx
  801a2c:	89 d0                	mov    %edx,%eax
}
  801a2e:	5d                   	pop    %ebp
  801a2f:	c3                   	ret    

00801a30 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  801a30:	55                   	push   %ebp
  801a31:	89 e5                	mov    %esp,%ebp
  801a33:	83 ec 04             	sub    $0x4,%esp
  801a36:	8b 45 0c             	mov    0xc(%ebp),%eax
  801a39:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  801a3c:	eb 12                	jmp    801a50 <strchr+0x20>
		if (*s == c)
  801a3e:	8b 45 08             	mov    0x8(%ebp),%eax
  801a41:	8a 00                	mov    (%eax),%al
  801a43:	3a 45 fc             	cmp    -0x4(%ebp),%al
  801a46:	75 05                	jne    801a4d <strchr+0x1d>
			return (char *) s;
  801a48:	8b 45 08             	mov    0x8(%ebp),%eax
  801a4b:	eb 11                	jmp    801a5e <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  801a4d:	ff 45 08             	incl   0x8(%ebp)
  801a50:	8b 45 08             	mov    0x8(%ebp),%eax
  801a53:	8a 00                	mov    (%eax),%al
  801a55:	84 c0                	test   %al,%al
  801a57:	75 e5                	jne    801a3e <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  801a59:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801a5e:	c9                   	leave  
  801a5f:	c3                   	ret    

00801a60 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  801a60:	55                   	push   %ebp
  801a61:	89 e5                	mov    %esp,%ebp
  801a63:	83 ec 04             	sub    $0x4,%esp
  801a66:	8b 45 0c             	mov    0xc(%ebp),%eax
  801a69:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  801a6c:	eb 0d                	jmp    801a7b <strfind+0x1b>
		if (*s == c)
  801a6e:	8b 45 08             	mov    0x8(%ebp),%eax
  801a71:	8a 00                	mov    (%eax),%al
  801a73:	3a 45 fc             	cmp    -0x4(%ebp),%al
  801a76:	74 0e                	je     801a86 <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  801a78:	ff 45 08             	incl   0x8(%ebp)
  801a7b:	8b 45 08             	mov    0x8(%ebp),%eax
  801a7e:	8a 00                	mov    (%eax),%al
  801a80:	84 c0                	test   %al,%al
  801a82:	75 ea                	jne    801a6e <strfind+0xe>
  801a84:	eb 01                	jmp    801a87 <strfind+0x27>
		if (*s == c)
			break;
  801a86:	90                   	nop
	return (char *) s;
  801a87:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801a8a:	c9                   	leave  
  801a8b:	c3                   	ret    

00801a8c <memset>:


void *
memset(void *v, int c, uint32 n)
{
  801a8c:	55                   	push   %ebp
  801a8d:	89 e5                	mov    %esp,%ebp
  801a8f:	83 ec 10             	sub    $0x10,%esp
	char *p;
	int m;

	p = v;
  801a92:	8b 45 08             	mov    0x8(%ebp),%eax
  801a95:	89 45 fc             	mov    %eax,-0x4(%ebp)
	m = n;
  801a98:	8b 45 10             	mov    0x10(%ebp),%eax
  801a9b:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (--m >= 0)
  801a9e:	eb 0e                	jmp    801aae <memset+0x22>
		*p++ = c;
  801aa0:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801aa3:	8d 50 01             	lea    0x1(%eax),%edx
  801aa6:	89 55 fc             	mov    %edx,-0x4(%ebp)
  801aa9:	8b 55 0c             	mov    0xc(%ebp),%edx
  801aac:	88 10                	mov    %dl,(%eax)
	char *p;
	int m;

	p = v;
	m = n;
	while (--m >= 0)
  801aae:	ff 4d f8             	decl   -0x8(%ebp)
  801ab1:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  801ab5:	79 e9                	jns    801aa0 <memset+0x14>
		*p++ = c;

	return v;
  801ab7:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801aba:	c9                   	leave  
  801abb:	c3                   	ret    

00801abc <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  801abc:	55                   	push   %ebp
  801abd:	89 e5                	mov    %esp,%ebp
  801abf:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  801ac2:	8b 45 0c             	mov    0xc(%ebp),%eax
  801ac5:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  801ac8:	8b 45 08             	mov    0x8(%ebp),%eax
  801acb:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (n-- > 0)
  801ace:	eb 16                	jmp    801ae6 <memcpy+0x2a>
		*d++ = *s++;
  801ad0:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801ad3:	8d 50 01             	lea    0x1(%eax),%edx
  801ad6:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801ad9:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801adc:	8d 4a 01             	lea    0x1(%edx),%ecx
  801adf:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  801ae2:	8a 12                	mov    (%edx),%dl
  801ae4:	88 10                	mov    %dl,(%eax)
	const char *s;
	char *d;

	s = src;
	d = dst;
	while (n-- > 0)
  801ae6:	8b 45 10             	mov    0x10(%ebp),%eax
  801ae9:	8d 50 ff             	lea    -0x1(%eax),%edx
  801aec:	89 55 10             	mov    %edx,0x10(%ebp)
  801aef:	85 c0                	test   %eax,%eax
  801af1:	75 dd                	jne    801ad0 <memcpy+0x14>
		*d++ = *s++;

	return dst;
  801af3:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801af6:	c9                   	leave  
  801af7:	c3                   	ret    

00801af8 <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  801af8:	55                   	push   %ebp
  801af9:	89 e5                	mov    %esp,%ebp
  801afb:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  801afe:	8b 45 0c             	mov    0xc(%ebp),%eax
  801b01:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  801b04:	8b 45 08             	mov    0x8(%ebp),%eax
  801b07:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  801b0a:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801b0d:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  801b10:	73 50                	jae    801b62 <memmove+0x6a>
  801b12:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801b15:	8b 45 10             	mov    0x10(%ebp),%eax
  801b18:	01 d0                	add    %edx,%eax
  801b1a:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  801b1d:	76 43                	jbe    801b62 <memmove+0x6a>
		s += n;
  801b1f:	8b 45 10             	mov    0x10(%ebp),%eax
  801b22:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  801b25:	8b 45 10             	mov    0x10(%ebp),%eax
  801b28:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  801b2b:	eb 10                	jmp    801b3d <memmove+0x45>
			*--d = *--s;
  801b2d:	ff 4d f8             	decl   -0x8(%ebp)
  801b30:	ff 4d fc             	decl   -0x4(%ebp)
  801b33:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801b36:	8a 10                	mov    (%eax),%dl
  801b38:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801b3b:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  801b3d:	8b 45 10             	mov    0x10(%ebp),%eax
  801b40:	8d 50 ff             	lea    -0x1(%eax),%edx
  801b43:	89 55 10             	mov    %edx,0x10(%ebp)
  801b46:	85 c0                	test   %eax,%eax
  801b48:	75 e3                	jne    801b2d <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  801b4a:	eb 23                	jmp    801b6f <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  801b4c:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801b4f:	8d 50 01             	lea    0x1(%eax),%edx
  801b52:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801b55:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801b58:	8d 4a 01             	lea    0x1(%edx),%ecx
  801b5b:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  801b5e:	8a 12                	mov    (%edx),%dl
  801b60:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  801b62:	8b 45 10             	mov    0x10(%ebp),%eax
  801b65:	8d 50 ff             	lea    -0x1(%eax),%edx
  801b68:	89 55 10             	mov    %edx,0x10(%ebp)
  801b6b:	85 c0                	test   %eax,%eax
  801b6d:	75 dd                	jne    801b4c <memmove+0x54>
			*d++ = *s++;

	return dst;
  801b6f:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801b72:	c9                   	leave  
  801b73:	c3                   	ret    

00801b74 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  801b74:	55                   	push   %ebp
  801b75:	89 e5                	mov    %esp,%ebp
  801b77:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  801b7a:	8b 45 08             	mov    0x8(%ebp),%eax
  801b7d:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  801b80:	8b 45 0c             	mov    0xc(%ebp),%eax
  801b83:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  801b86:	eb 2a                	jmp    801bb2 <memcmp+0x3e>
		if (*s1 != *s2)
  801b88:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801b8b:	8a 10                	mov    (%eax),%dl
  801b8d:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801b90:	8a 00                	mov    (%eax),%al
  801b92:	38 c2                	cmp    %al,%dl
  801b94:	74 16                	je     801bac <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  801b96:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801b99:	8a 00                	mov    (%eax),%al
  801b9b:	0f b6 d0             	movzbl %al,%edx
  801b9e:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801ba1:	8a 00                	mov    (%eax),%al
  801ba3:	0f b6 c0             	movzbl %al,%eax
  801ba6:	29 c2                	sub    %eax,%edx
  801ba8:	89 d0                	mov    %edx,%eax
  801baa:	eb 18                	jmp    801bc4 <memcmp+0x50>
		s1++, s2++;
  801bac:	ff 45 fc             	incl   -0x4(%ebp)
  801baf:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  801bb2:	8b 45 10             	mov    0x10(%ebp),%eax
  801bb5:	8d 50 ff             	lea    -0x1(%eax),%edx
  801bb8:	89 55 10             	mov    %edx,0x10(%ebp)
  801bbb:	85 c0                	test   %eax,%eax
  801bbd:	75 c9                	jne    801b88 <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  801bbf:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801bc4:	c9                   	leave  
  801bc5:	c3                   	ret    

00801bc6 <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  801bc6:	55                   	push   %ebp
  801bc7:	89 e5                	mov    %esp,%ebp
  801bc9:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  801bcc:	8b 55 08             	mov    0x8(%ebp),%edx
  801bcf:	8b 45 10             	mov    0x10(%ebp),%eax
  801bd2:	01 d0                	add    %edx,%eax
  801bd4:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  801bd7:	eb 15                	jmp    801bee <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  801bd9:	8b 45 08             	mov    0x8(%ebp),%eax
  801bdc:	8a 00                	mov    (%eax),%al
  801bde:	0f b6 d0             	movzbl %al,%edx
  801be1:	8b 45 0c             	mov    0xc(%ebp),%eax
  801be4:	0f b6 c0             	movzbl %al,%eax
  801be7:	39 c2                	cmp    %eax,%edx
  801be9:	74 0d                	je     801bf8 <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  801beb:	ff 45 08             	incl   0x8(%ebp)
  801bee:	8b 45 08             	mov    0x8(%ebp),%eax
  801bf1:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  801bf4:	72 e3                	jb     801bd9 <memfind+0x13>
  801bf6:	eb 01                	jmp    801bf9 <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  801bf8:	90                   	nop
	return (void *) s;
  801bf9:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801bfc:	c9                   	leave  
  801bfd:	c3                   	ret    

00801bfe <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  801bfe:	55                   	push   %ebp
  801bff:	89 e5                	mov    %esp,%ebp
  801c01:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  801c04:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  801c0b:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801c12:	eb 03                	jmp    801c17 <strtol+0x19>
		s++;
  801c14:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801c17:	8b 45 08             	mov    0x8(%ebp),%eax
  801c1a:	8a 00                	mov    (%eax),%al
  801c1c:	3c 20                	cmp    $0x20,%al
  801c1e:	74 f4                	je     801c14 <strtol+0x16>
  801c20:	8b 45 08             	mov    0x8(%ebp),%eax
  801c23:	8a 00                	mov    (%eax),%al
  801c25:	3c 09                	cmp    $0x9,%al
  801c27:	74 eb                	je     801c14 <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  801c29:	8b 45 08             	mov    0x8(%ebp),%eax
  801c2c:	8a 00                	mov    (%eax),%al
  801c2e:	3c 2b                	cmp    $0x2b,%al
  801c30:	75 05                	jne    801c37 <strtol+0x39>
		s++;
  801c32:	ff 45 08             	incl   0x8(%ebp)
  801c35:	eb 13                	jmp    801c4a <strtol+0x4c>
	else if (*s == '-')
  801c37:	8b 45 08             	mov    0x8(%ebp),%eax
  801c3a:	8a 00                	mov    (%eax),%al
  801c3c:	3c 2d                	cmp    $0x2d,%al
  801c3e:	75 0a                	jne    801c4a <strtol+0x4c>
		s++, neg = 1;
  801c40:	ff 45 08             	incl   0x8(%ebp)
  801c43:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  801c4a:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801c4e:	74 06                	je     801c56 <strtol+0x58>
  801c50:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  801c54:	75 20                	jne    801c76 <strtol+0x78>
  801c56:	8b 45 08             	mov    0x8(%ebp),%eax
  801c59:	8a 00                	mov    (%eax),%al
  801c5b:	3c 30                	cmp    $0x30,%al
  801c5d:	75 17                	jne    801c76 <strtol+0x78>
  801c5f:	8b 45 08             	mov    0x8(%ebp),%eax
  801c62:	40                   	inc    %eax
  801c63:	8a 00                	mov    (%eax),%al
  801c65:	3c 78                	cmp    $0x78,%al
  801c67:	75 0d                	jne    801c76 <strtol+0x78>
		s += 2, base = 16;
  801c69:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  801c6d:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  801c74:	eb 28                	jmp    801c9e <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  801c76:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801c7a:	75 15                	jne    801c91 <strtol+0x93>
  801c7c:	8b 45 08             	mov    0x8(%ebp),%eax
  801c7f:	8a 00                	mov    (%eax),%al
  801c81:	3c 30                	cmp    $0x30,%al
  801c83:	75 0c                	jne    801c91 <strtol+0x93>
		s++, base = 8;
  801c85:	ff 45 08             	incl   0x8(%ebp)
  801c88:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  801c8f:	eb 0d                	jmp    801c9e <strtol+0xa0>
	else if (base == 0)
  801c91:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801c95:	75 07                	jne    801c9e <strtol+0xa0>
		base = 10;
  801c97:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  801c9e:	8b 45 08             	mov    0x8(%ebp),%eax
  801ca1:	8a 00                	mov    (%eax),%al
  801ca3:	3c 2f                	cmp    $0x2f,%al
  801ca5:	7e 19                	jle    801cc0 <strtol+0xc2>
  801ca7:	8b 45 08             	mov    0x8(%ebp),%eax
  801caa:	8a 00                	mov    (%eax),%al
  801cac:	3c 39                	cmp    $0x39,%al
  801cae:	7f 10                	jg     801cc0 <strtol+0xc2>
			dig = *s - '0';
  801cb0:	8b 45 08             	mov    0x8(%ebp),%eax
  801cb3:	8a 00                	mov    (%eax),%al
  801cb5:	0f be c0             	movsbl %al,%eax
  801cb8:	83 e8 30             	sub    $0x30,%eax
  801cbb:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801cbe:	eb 42                	jmp    801d02 <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  801cc0:	8b 45 08             	mov    0x8(%ebp),%eax
  801cc3:	8a 00                	mov    (%eax),%al
  801cc5:	3c 60                	cmp    $0x60,%al
  801cc7:	7e 19                	jle    801ce2 <strtol+0xe4>
  801cc9:	8b 45 08             	mov    0x8(%ebp),%eax
  801ccc:	8a 00                	mov    (%eax),%al
  801cce:	3c 7a                	cmp    $0x7a,%al
  801cd0:	7f 10                	jg     801ce2 <strtol+0xe4>
			dig = *s - 'a' + 10;
  801cd2:	8b 45 08             	mov    0x8(%ebp),%eax
  801cd5:	8a 00                	mov    (%eax),%al
  801cd7:	0f be c0             	movsbl %al,%eax
  801cda:	83 e8 57             	sub    $0x57,%eax
  801cdd:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801ce0:	eb 20                	jmp    801d02 <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  801ce2:	8b 45 08             	mov    0x8(%ebp),%eax
  801ce5:	8a 00                	mov    (%eax),%al
  801ce7:	3c 40                	cmp    $0x40,%al
  801ce9:	7e 39                	jle    801d24 <strtol+0x126>
  801ceb:	8b 45 08             	mov    0x8(%ebp),%eax
  801cee:	8a 00                	mov    (%eax),%al
  801cf0:	3c 5a                	cmp    $0x5a,%al
  801cf2:	7f 30                	jg     801d24 <strtol+0x126>
			dig = *s - 'A' + 10;
  801cf4:	8b 45 08             	mov    0x8(%ebp),%eax
  801cf7:	8a 00                	mov    (%eax),%al
  801cf9:	0f be c0             	movsbl %al,%eax
  801cfc:	83 e8 37             	sub    $0x37,%eax
  801cff:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  801d02:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801d05:	3b 45 10             	cmp    0x10(%ebp),%eax
  801d08:	7d 19                	jge    801d23 <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  801d0a:	ff 45 08             	incl   0x8(%ebp)
  801d0d:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801d10:	0f af 45 10          	imul   0x10(%ebp),%eax
  801d14:	89 c2                	mov    %eax,%edx
  801d16:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801d19:	01 d0                	add    %edx,%eax
  801d1b:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  801d1e:	e9 7b ff ff ff       	jmp    801c9e <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  801d23:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  801d24:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801d28:	74 08                	je     801d32 <strtol+0x134>
		*endptr = (char *) s;
  801d2a:	8b 45 0c             	mov    0xc(%ebp),%eax
  801d2d:	8b 55 08             	mov    0x8(%ebp),%edx
  801d30:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  801d32:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801d36:	74 07                	je     801d3f <strtol+0x141>
  801d38:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801d3b:	f7 d8                	neg    %eax
  801d3d:	eb 03                	jmp    801d42 <strtol+0x144>
  801d3f:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  801d42:	c9                   	leave  
  801d43:	c3                   	ret    

00801d44 <ltostr>:

void
ltostr(long value, char *str)
{
  801d44:	55                   	push   %ebp
  801d45:	89 e5                	mov    %esp,%ebp
  801d47:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  801d4a:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  801d51:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  801d58:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801d5c:	79 13                	jns    801d71 <ltostr+0x2d>
	{
		neg = 1;
  801d5e:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  801d65:	8b 45 0c             	mov    0xc(%ebp),%eax
  801d68:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  801d6b:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  801d6e:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  801d71:	8b 45 08             	mov    0x8(%ebp),%eax
  801d74:	b9 0a 00 00 00       	mov    $0xa,%ecx
  801d79:	99                   	cltd   
  801d7a:	f7 f9                	idiv   %ecx
  801d7c:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  801d7f:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801d82:	8d 50 01             	lea    0x1(%eax),%edx
  801d85:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801d88:	89 c2                	mov    %eax,%edx
  801d8a:	8b 45 0c             	mov    0xc(%ebp),%eax
  801d8d:	01 d0                	add    %edx,%eax
  801d8f:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801d92:	83 c2 30             	add    $0x30,%edx
  801d95:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  801d97:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801d9a:	b8 67 66 66 66       	mov    $0x66666667,%eax
  801d9f:	f7 e9                	imul   %ecx
  801da1:	c1 fa 02             	sar    $0x2,%edx
  801da4:	89 c8                	mov    %ecx,%eax
  801da6:	c1 f8 1f             	sar    $0x1f,%eax
  801da9:	29 c2                	sub    %eax,%edx
  801dab:	89 d0                	mov    %edx,%eax
  801dad:	89 45 08             	mov    %eax,0x8(%ebp)
	} while (value % 10 != 0);
  801db0:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801db3:	b8 67 66 66 66       	mov    $0x66666667,%eax
  801db8:	f7 e9                	imul   %ecx
  801dba:	c1 fa 02             	sar    $0x2,%edx
  801dbd:	89 c8                	mov    %ecx,%eax
  801dbf:	c1 f8 1f             	sar    $0x1f,%eax
  801dc2:	29 c2                	sub    %eax,%edx
  801dc4:	89 d0                	mov    %edx,%eax
  801dc6:	c1 e0 02             	shl    $0x2,%eax
  801dc9:	01 d0                	add    %edx,%eax
  801dcb:	01 c0                	add    %eax,%eax
  801dcd:	29 c1                	sub    %eax,%ecx
  801dcf:	89 ca                	mov    %ecx,%edx
  801dd1:	85 d2                	test   %edx,%edx
  801dd3:	75 9c                	jne    801d71 <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  801dd5:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  801ddc:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801ddf:	48                   	dec    %eax
  801de0:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  801de3:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801de7:	74 3d                	je     801e26 <ltostr+0xe2>
		start = 1 ;
  801de9:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  801df0:	eb 34                	jmp    801e26 <ltostr+0xe2>
	{
		char tmp = str[start] ;
  801df2:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801df5:	8b 45 0c             	mov    0xc(%ebp),%eax
  801df8:	01 d0                	add    %edx,%eax
  801dfa:	8a 00                	mov    (%eax),%al
  801dfc:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  801dff:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801e02:	8b 45 0c             	mov    0xc(%ebp),%eax
  801e05:	01 c2                	add    %eax,%edx
  801e07:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  801e0a:	8b 45 0c             	mov    0xc(%ebp),%eax
  801e0d:	01 c8                	add    %ecx,%eax
  801e0f:	8a 00                	mov    (%eax),%al
  801e11:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  801e13:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801e16:	8b 45 0c             	mov    0xc(%ebp),%eax
  801e19:	01 c2                	add    %eax,%edx
  801e1b:	8a 45 eb             	mov    -0x15(%ebp),%al
  801e1e:	88 02                	mov    %al,(%edx)
		start++ ;
  801e20:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  801e23:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  801e26:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e29:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801e2c:	7c c4                	jl     801df2 <ltostr+0xae>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  801e2e:	8b 55 f8             	mov    -0x8(%ebp),%edx
  801e31:	8b 45 0c             	mov    0xc(%ebp),%eax
  801e34:	01 d0                	add    %edx,%eax
  801e36:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  801e39:	90                   	nop
  801e3a:	c9                   	leave  
  801e3b:	c3                   	ret    

00801e3c <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  801e3c:	55                   	push   %ebp
  801e3d:	89 e5                	mov    %esp,%ebp
  801e3f:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  801e42:	ff 75 08             	pushl  0x8(%ebp)
  801e45:	e8 54 fa ff ff       	call   80189e <strlen>
  801e4a:	83 c4 04             	add    $0x4,%esp
  801e4d:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  801e50:	ff 75 0c             	pushl  0xc(%ebp)
  801e53:	e8 46 fa ff ff       	call   80189e <strlen>
  801e58:	83 c4 04             	add    $0x4,%esp
  801e5b:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  801e5e:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  801e65:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801e6c:	eb 17                	jmp    801e85 <strcconcat+0x49>
		final[s] = str1[s] ;
  801e6e:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801e71:	8b 45 10             	mov    0x10(%ebp),%eax
  801e74:	01 c2                	add    %eax,%edx
  801e76:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  801e79:	8b 45 08             	mov    0x8(%ebp),%eax
  801e7c:	01 c8                	add    %ecx,%eax
  801e7e:	8a 00                	mov    (%eax),%al
  801e80:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  801e82:	ff 45 fc             	incl   -0x4(%ebp)
  801e85:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801e88:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  801e8b:	7c e1                	jl     801e6e <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  801e8d:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  801e94:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  801e9b:	eb 1f                	jmp    801ebc <strcconcat+0x80>
		final[s++] = str2[i] ;
  801e9d:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801ea0:	8d 50 01             	lea    0x1(%eax),%edx
  801ea3:	89 55 fc             	mov    %edx,-0x4(%ebp)
  801ea6:	89 c2                	mov    %eax,%edx
  801ea8:	8b 45 10             	mov    0x10(%ebp),%eax
  801eab:	01 c2                	add    %eax,%edx
  801ead:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  801eb0:	8b 45 0c             	mov    0xc(%ebp),%eax
  801eb3:	01 c8                	add    %ecx,%eax
  801eb5:	8a 00                	mov    (%eax),%al
  801eb7:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  801eb9:	ff 45 f8             	incl   -0x8(%ebp)
  801ebc:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801ebf:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801ec2:	7c d9                	jl     801e9d <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  801ec4:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801ec7:	8b 45 10             	mov    0x10(%ebp),%eax
  801eca:	01 d0                	add    %edx,%eax
  801ecc:	c6 00 00             	movb   $0x0,(%eax)
}
  801ecf:	90                   	nop
  801ed0:	c9                   	leave  
  801ed1:	c3                   	ret    

00801ed2 <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  801ed2:	55                   	push   %ebp
  801ed3:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  801ed5:	8b 45 14             	mov    0x14(%ebp),%eax
  801ed8:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  801ede:	8b 45 14             	mov    0x14(%ebp),%eax
  801ee1:	8b 00                	mov    (%eax),%eax
  801ee3:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801eea:	8b 45 10             	mov    0x10(%ebp),%eax
  801eed:	01 d0                	add    %edx,%eax
  801eef:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801ef5:	eb 0c                	jmp    801f03 <strsplit+0x31>
			*string++ = 0;
  801ef7:	8b 45 08             	mov    0x8(%ebp),%eax
  801efa:	8d 50 01             	lea    0x1(%eax),%edx
  801efd:	89 55 08             	mov    %edx,0x8(%ebp)
  801f00:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801f03:	8b 45 08             	mov    0x8(%ebp),%eax
  801f06:	8a 00                	mov    (%eax),%al
  801f08:	84 c0                	test   %al,%al
  801f0a:	74 18                	je     801f24 <strsplit+0x52>
  801f0c:	8b 45 08             	mov    0x8(%ebp),%eax
  801f0f:	8a 00                	mov    (%eax),%al
  801f11:	0f be c0             	movsbl %al,%eax
  801f14:	50                   	push   %eax
  801f15:	ff 75 0c             	pushl  0xc(%ebp)
  801f18:	e8 13 fb ff ff       	call   801a30 <strchr>
  801f1d:	83 c4 08             	add    $0x8,%esp
  801f20:	85 c0                	test   %eax,%eax
  801f22:	75 d3                	jne    801ef7 <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  801f24:	8b 45 08             	mov    0x8(%ebp),%eax
  801f27:	8a 00                	mov    (%eax),%al
  801f29:	84 c0                	test   %al,%al
  801f2b:	74 5a                	je     801f87 <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  801f2d:	8b 45 14             	mov    0x14(%ebp),%eax
  801f30:	8b 00                	mov    (%eax),%eax
  801f32:	83 f8 0f             	cmp    $0xf,%eax
  801f35:	75 07                	jne    801f3e <strsplit+0x6c>
		{
			return 0;
  801f37:	b8 00 00 00 00       	mov    $0x0,%eax
  801f3c:	eb 66                	jmp    801fa4 <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  801f3e:	8b 45 14             	mov    0x14(%ebp),%eax
  801f41:	8b 00                	mov    (%eax),%eax
  801f43:	8d 48 01             	lea    0x1(%eax),%ecx
  801f46:	8b 55 14             	mov    0x14(%ebp),%edx
  801f49:	89 0a                	mov    %ecx,(%edx)
  801f4b:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801f52:	8b 45 10             	mov    0x10(%ebp),%eax
  801f55:	01 c2                	add    %eax,%edx
  801f57:	8b 45 08             	mov    0x8(%ebp),%eax
  801f5a:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  801f5c:	eb 03                	jmp    801f61 <strsplit+0x8f>
			string++;
  801f5e:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  801f61:	8b 45 08             	mov    0x8(%ebp),%eax
  801f64:	8a 00                	mov    (%eax),%al
  801f66:	84 c0                	test   %al,%al
  801f68:	74 8b                	je     801ef5 <strsplit+0x23>
  801f6a:	8b 45 08             	mov    0x8(%ebp),%eax
  801f6d:	8a 00                	mov    (%eax),%al
  801f6f:	0f be c0             	movsbl %al,%eax
  801f72:	50                   	push   %eax
  801f73:	ff 75 0c             	pushl  0xc(%ebp)
  801f76:	e8 b5 fa ff ff       	call   801a30 <strchr>
  801f7b:	83 c4 08             	add    $0x8,%esp
  801f7e:	85 c0                	test   %eax,%eax
  801f80:	74 dc                	je     801f5e <strsplit+0x8c>
			string++;
	}
  801f82:	e9 6e ff ff ff       	jmp    801ef5 <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  801f87:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  801f88:	8b 45 14             	mov    0x14(%ebp),%eax
  801f8b:	8b 00                	mov    (%eax),%eax
  801f8d:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801f94:	8b 45 10             	mov    0x10(%ebp),%eax
  801f97:	01 d0                	add    %edx,%eax
  801f99:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  801f9f:	b8 01 00 00 00       	mov    $0x1,%eax
}
  801fa4:	c9                   	leave  
  801fa5:	c3                   	ret    

00801fa6 <InitializeUHeap>:
//============================== GIVEN FUNCTIONS ===================================//
//==================================================================================//

int FirstTimeFlag = 1;
void InitializeUHeap()
{
  801fa6:	55                   	push   %ebp
  801fa7:	89 e5                	mov    %esp,%ebp
  801fa9:	83 ec 08             	sub    $0x8,%esp
	if(FirstTimeFlag)
  801fac:	a1 04 50 80 00       	mov    0x805004,%eax
  801fb1:	85 c0                	test   %eax,%eax
  801fb3:	74 1f                	je     801fd4 <InitializeUHeap+0x2e>
	{
		initialize_dyn_block_system();
  801fb5:	e8 1d 00 00 00       	call   801fd7 <initialize_dyn_block_system>
		cprintf("DYNAMIC BLOCK SYSTEM IS INITIALIZED\n");
  801fba:	83 ec 0c             	sub    $0xc,%esp
  801fbd:	68 b0 44 80 00       	push   $0x8044b0
  801fc2:	e8 55 f2 ff ff       	call   80121c <cprintf>
  801fc7:	83 c4 10             	add    $0x10,%esp
#if UHP_USE_BUDDY
		initialize_buddy();
		cprintf("BUDDY SYSTEM IS INITIALIZED\n");
#endif
		FirstTimeFlag = 0;
  801fca:	c7 05 04 50 80 00 00 	movl   $0x0,0x805004
  801fd1:	00 00 00 
	}
}
  801fd4:	90                   	nop
  801fd5:	c9                   	leave  
  801fd6:	c3                   	ret    

00801fd7 <initialize_dyn_block_system>:

//=================================
// [1] INITIALIZE DYNAMIC ALLOCATOR:
//=================================
void initialize_dyn_block_system()
{
  801fd7:	55                   	push   %ebp
  801fd8:	89 e5                	mov    %esp,%ebp
  801fda:	83 ec 28             	sub    $0x28,%esp
	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] initialize_dyn_block_system
	// your code is here, remove the panic and write your code
	//panic("initialize_dyn_block_system() is not implemented yet...!!");

	LIST_INIT(&AllocMemBlocksList);
  801fdd:	c7 05 40 50 80 00 00 	movl   $0x0,0x805040
  801fe4:	00 00 00 
  801fe7:	c7 05 44 50 80 00 00 	movl   $0x0,0x805044
  801fee:	00 00 00 
  801ff1:	c7 05 4c 50 80 00 00 	movl   $0x0,0x80504c
  801ff8:	00 00 00 
	LIST_INIT(&FreeMemBlocksList);
  801ffb:	c7 05 38 51 80 00 00 	movl   $0x0,0x805138
  802002:	00 00 00 
  802005:	c7 05 3c 51 80 00 00 	movl   $0x0,0x80513c
  80200c:	00 00 00 
  80200f:	c7 05 44 51 80 00 00 	movl   $0x0,0x805144
  802016:	00 00 00 
	MAX_MEM_BLOCK_CNT = NUM_OF_UHEAP_PAGES;
  802019:	c7 05 20 51 80 00 00 	movl   $0x20000,0x805120
  802020:	00 02 00 
	MemBlockNodes = (void*)USER_DYN_BLKS_ARRAY;
  802023:	c7 45 f4 00 00 e0 7f 	movl   $0x7fe00000,-0xc(%ebp)
  80202a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80202d:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  802032:	2d 00 10 00 00       	sub    $0x1000,%eax
  802037:	a3 50 50 80 00       	mov    %eax,0x805050
	int size_of_block = sizeof(struct MemBlock);
  80203c:	c7 45 f0 10 00 00 00 	movl   $0x10,-0x10(%ebp)
	int size_all_struct = size_of_block*MAX_MEM_BLOCK_CNT;
  802043:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802046:	a1 20 51 80 00       	mov    0x805120,%eax
  80204b:	0f af c2             	imul   %edx,%eax
  80204e:	89 45 ec             	mov    %eax,-0x14(%ebp)
	size_all_struct = ROUNDUP(size_all_struct, PAGE_SIZE);
  802051:	c7 45 e8 00 10 00 00 	movl   $0x1000,-0x18(%ebp)
  802058:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80205b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80205e:	01 d0                	add    %edx,%eax
  802060:	48                   	dec    %eax
  802061:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  802064:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802067:	ba 00 00 00 00       	mov    $0x0,%edx
  80206c:	f7 75 e8             	divl   -0x18(%ebp)
  80206f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802072:	29 d0                	sub    %edx,%eax
  802074:	89 45 ec             	mov    %eax,-0x14(%ebp)
	sys_allocate_chunk(USER_DYN_BLKS_ARRAY, size_all_struct,PERM_USER| PERM_WRITEABLE);
  802077:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80207a:	c7 45 e0 00 00 e0 7f 	movl   $0x7fe00000,-0x20(%ebp)
  802081:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802084:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
  80208a:	81 ea 00 10 00 00    	sub    $0x1000,%edx
  802090:	83 ec 04             	sub    $0x4,%esp
  802093:	6a 06                	push   $0x6
  802095:	50                   	push   %eax
  802096:	52                   	push   %edx
  802097:	e8 a1 05 00 00       	call   80263d <sys_allocate_chunk>
  80209c:	83 c4 10             	add    $0x10,%esp
	initialize_MemBlocksList(MAX_MEM_BLOCK_CNT);
  80209f:	a1 20 51 80 00       	mov    0x805120,%eax
  8020a4:	83 ec 0c             	sub    $0xc,%esp
  8020a7:	50                   	push   %eax
  8020a8:	e8 16 0c 00 00       	call   802cc3 <initialize_MemBlocksList>
  8020ad:	83 c4 10             	add    $0x10,%esp
	struct MemBlock* ourBlock =LIST_LAST(&AvailableMemBlocksList);
  8020b0:	a1 4c 51 80 00       	mov    0x80514c,%eax
  8020b5:	89 45 dc             	mov    %eax,-0x24(%ebp)
	LIST_REMOVE(&AvailableMemBlocksList,ourBlock);
  8020b8:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  8020bc:	75 14                	jne    8020d2 <initialize_dyn_block_system+0xfb>
  8020be:	83 ec 04             	sub    $0x4,%esp
  8020c1:	68 d5 44 80 00       	push   $0x8044d5
  8020c6:	6a 2d                	push   $0x2d
  8020c8:	68 f3 44 80 00       	push   $0x8044f3
  8020cd:	e8 96 ee ff ff       	call   800f68 <_panic>
  8020d2:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8020d5:	8b 00                	mov    (%eax),%eax
  8020d7:	85 c0                	test   %eax,%eax
  8020d9:	74 10                	je     8020eb <initialize_dyn_block_system+0x114>
  8020db:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8020de:	8b 00                	mov    (%eax),%eax
  8020e0:	8b 55 dc             	mov    -0x24(%ebp),%edx
  8020e3:	8b 52 04             	mov    0x4(%edx),%edx
  8020e6:	89 50 04             	mov    %edx,0x4(%eax)
  8020e9:	eb 0b                	jmp    8020f6 <initialize_dyn_block_system+0x11f>
  8020eb:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8020ee:	8b 40 04             	mov    0x4(%eax),%eax
  8020f1:	a3 4c 51 80 00       	mov    %eax,0x80514c
  8020f6:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8020f9:	8b 40 04             	mov    0x4(%eax),%eax
  8020fc:	85 c0                	test   %eax,%eax
  8020fe:	74 0f                	je     80210f <initialize_dyn_block_system+0x138>
  802100:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802103:	8b 40 04             	mov    0x4(%eax),%eax
  802106:	8b 55 dc             	mov    -0x24(%ebp),%edx
  802109:	8b 12                	mov    (%edx),%edx
  80210b:	89 10                	mov    %edx,(%eax)
  80210d:	eb 0a                	jmp    802119 <initialize_dyn_block_system+0x142>
  80210f:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802112:	8b 00                	mov    (%eax),%eax
  802114:	a3 48 51 80 00       	mov    %eax,0x805148
  802119:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80211c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802122:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802125:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80212c:	a1 54 51 80 00       	mov    0x805154,%eax
  802131:	48                   	dec    %eax
  802132:	a3 54 51 80 00       	mov    %eax,0x805154
	ourBlock->size = USER_HEAP_MAX-USER_HEAP_START;
  802137:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80213a:	c7 40 0c 00 00 00 20 	movl   $0x20000000,0xc(%eax)
	ourBlock->sva=USER_HEAP_START;
  802141:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802144:	c7 40 08 00 00 00 80 	movl   $0x80000000,0x8(%eax)
	LIST_INSERT_TAIL(&FreeMemBlocksList, ourBlock);
  80214b:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  80214f:	75 14                	jne    802165 <initialize_dyn_block_system+0x18e>
  802151:	83 ec 04             	sub    $0x4,%esp
  802154:	68 00 45 80 00       	push   $0x804500
  802159:	6a 30                	push   $0x30
  80215b:	68 f3 44 80 00       	push   $0x8044f3
  802160:	e8 03 ee ff ff       	call   800f68 <_panic>
  802165:	8b 15 3c 51 80 00    	mov    0x80513c,%edx
  80216b:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80216e:	89 50 04             	mov    %edx,0x4(%eax)
  802171:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802174:	8b 40 04             	mov    0x4(%eax),%eax
  802177:	85 c0                	test   %eax,%eax
  802179:	74 0c                	je     802187 <initialize_dyn_block_system+0x1b0>
  80217b:	a1 3c 51 80 00       	mov    0x80513c,%eax
  802180:	8b 55 dc             	mov    -0x24(%ebp),%edx
  802183:	89 10                	mov    %edx,(%eax)
  802185:	eb 08                	jmp    80218f <initialize_dyn_block_system+0x1b8>
  802187:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80218a:	a3 38 51 80 00       	mov    %eax,0x805138
  80218f:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802192:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802197:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80219a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8021a0:	a1 44 51 80 00       	mov    0x805144,%eax
  8021a5:	40                   	inc    %eax
  8021a6:	a3 44 51 80 00       	mov    %eax,0x805144
	//[1] Initialize two lists (AllocMemBlocksList & FreeMemBlocksList) [Hint: use LIST_INIT()]
	//[2] Dynamically allocate the array of MemBlockNodes at VA USER_DYN_BLKS_ARRAY
	//	  (remember to set MAX_MEM_BLOCK_CNT with the chosen size of the array)
	//[3] Initialize AvailableMemBlocksList by filling it with the MemBlockNodes
	//[4] Insert a new MemBlock with the heap size into the FreeMemBlocksList
}
  8021ab:	90                   	nop
  8021ac:	c9                   	leave  
  8021ad:	c3                   	ret    

008021ae <malloc>:
//=================================
// [2] ALLOCATE SPACE IN USER HEAP:
//=================================

void* malloc(uint32 size)
{
  8021ae:	55                   	push   %ebp
  8021af:	89 e5                	mov    %esp,%ebp
  8021b1:	83 ec 18             	sub    $0x18,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  8021b4:	e8 ed fd ff ff       	call   801fa6 <InitializeUHeap>
	if (size == 0) return NULL ;
  8021b9:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8021bd:	75 07                	jne    8021c6 <malloc+0x18>
  8021bf:	b8 00 00 00 00       	mov    $0x0,%eax
  8021c4:	eb 67                	jmp    80222d <malloc+0x7f>

	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] malloc
	// your code is here, remove the panic and write your code
	//panic("malloc() is not implemented yet...!!");

	size = ROUNDUP(size, PAGE_SIZE);
  8021c6:	c7 45 f4 00 10 00 00 	movl   $0x1000,-0xc(%ebp)
  8021cd:	8b 55 08             	mov    0x8(%ebp),%edx
  8021d0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021d3:	01 d0                	add    %edx,%eax
  8021d5:	48                   	dec    %eax
  8021d6:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8021d9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8021dc:	ba 00 00 00 00       	mov    $0x0,%edx
  8021e1:	f7 75 f4             	divl   -0xc(%ebp)
  8021e4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8021e7:	29 d0                	sub    %edx,%eax
  8021e9:	89 45 08             	mov    %eax,0x8(%ebp)
	if(sys_isUHeapPlacementStrategyFIRSTFIT())
  8021ec:	e8 1a 08 00 00       	call   802a0b <sys_isUHeapPlacementStrategyFIRSTFIT>
  8021f1:	85 c0                	test   %eax,%eax
  8021f3:	74 33                	je     802228 <malloc+0x7a>
	{
		struct MemBlock * myBlock = alloc_block_FF(size);
  8021f5:	83 ec 0c             	sub    $0xc,%esp
  8021f8:	ff 75 08             	pushl  0x8(%ebp)
  8021fb:	e8 0c 0e 00 00       	call   80300c <alloc_block_FF>
  802200:	83 c4 10             	add    $0x10,%esp
  802203:	89 45 ec             	mov    %eax,-0x14(%ebp)
		if(myBlock != NULL)
  802206:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  80220a:	74 1c                	je     802228 <malloc+0x7a>
		{
			insert_sorted_allocList(myBlock);
  80220c:	83 ec 0c             	sub    $0xc,%esp
  80220f:	ff 75 ec             	pushl  -0x14(%ebp)
  802212:	e8 07 0c 00 00       	call   802e1e <insert_sorted_allocList>
  802217:	83 c4 10             	add    $0x10,%esp
			uint32 ptr = myBlock->sva;
  80221a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80221d:	8b 40 08             	mov    0x8(%eax),%eax
  802220:	89 45 e8             	mov    %eax,-0x18(%ebp)
			return (void *)ptr;
  802223:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802226:	eb 05                	jmp    80222d <malloc+0x7f>
		}
	}
	return NULL;
  802228:	b8 00 00 00 00       	mov    $0x0,%eax
	//		to the required allocation size (space should be on 4 KB BOUNDARY)
	//	2) if no suitable space found, return NULL
	// 	3) Return pointer containing the virtual address of allocated space,
	//
	//Use sys_isUHeapPlacementStrategyFIRSTFIT()... to check the current strategy
}
  80222d:	c9                   	leave  
  80222e:	c3                   	ret    

0080222f <free>:
//	We can use sys_free_user_mem(uint32 virtual_address, uint32 size); which
//		switches to the kernel mode, calls free_user_mem() in
//		"kern/mem/chunk_operations.c", then switch back to the user mode here
//	the free_user_mem function is empty, make sure to implement it.
void free(void* virtual_address)
{
  80222f:	55                   	push   %ebp
  802230:	89 e5                	mov    %esp,%ebp
  802232:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] free
	// your code is here, remove the panic and write your code
	//panic("free() is not implemented yet...!!");

	uint32 virtualAddress = (uint32 )(virtual_address);
  802235:	8b 45 08             	mov    0x8(%ebp),%eax
  802238:	89 45 f4             	mov    %eax,-0xc(%ebp)
//	virtualAddress = ROUNDDOWN(virtualAddress, PAGE_SIZE);
	struct MemBlock * myBlock = find_block(&AllocMemBlocksList, virtualAddress);
  80223b:	83 ec 08             	sub    $0x8,%esp
  80223e:	ff 75 f4             	pushl  -0xc(%ebp)
  802241:	68 40 50 80 00       	push   $0x805040
  802246:	e8 5b 0b 00 00       	call   802da6 <find_block>
  80224b:	83 c4 10             	add    $0x10,%esp
  80224e:	89 45 f0             	mov    %eax,-0x10(%ebp)
//	cprintf ("ptr sva at free user side = %x \n", myBlock->sva);
	sys_free_user_mem(virtualAddress, myBlock->size);
  802251:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802254:	8b 40 0c             	mov    0xc(%eax),%eax
  802257:	83 ec 08             	sub    $0x8,%esp
  80225a:	50                   	push   %eax
  80225b:	ff 75 f4             	pushl  -0xc(%ebp)
  80225e:	e8 a2 03 00 00       	call   802605 <sys_free_user_mem>
  802263:	83 c4 10             	add    $0x10,%esp
	LIST_REMOVE(&AllocMemBlocksList, myBlock);
  802266:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80226a:	75 14                	jne    802280 <free+0x51>
  80226c:	83 ec 04             	sub    $0x4,%esp
  80226f:	68 d5 44 80 00       	push   $0x8044d5
  802274:	6a 76                	push   $0x76
  802276:	68 f3 44 80 00       	push   $0x8044f3
  80227b:	e8 e8 ec ff ff       	call   800f68 <_panic>
  802280:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802283:	8b 00                	mov    (%eax),%eax
  802285:	85 c0                	test   %eax,%eax
  802287:	74 10                	je     802299 <free+0x6a>
  802289:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80228c:	8b 00                	mov    (%eax),%eax
  80228e:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802291:	8b 52 04             	mov    0x4(%edx),%edx
  802294:	89 50 04             	mov    %edx,0x4(%eax)
  802297:	eb 0b                	jmp    8022a4 <free+0x75>
  802299:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80229c:	8b 40 04             	mov    0x4(%eax),%eax
  80229f:	a3 44 50 80 00       	mov    %eax,0x805044
  8022a4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8022a7:	8b 40 04             	mov    0x4(%eax),%eax
  8022aa:	85 c0                	test   %eax,%eax
  8022ac:	74 0f                	je     8022bd <free+0x8e>
  8022ae:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8022b1:	8b 40 04             	mov    0x4(%eax),%eax
  8022b4:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8022b7:	8b 12                	mov    (%edx),%edx
  8022b9:	89 10                	mov    %edx,(%eax)
  8022bb:	eb 0a                	jmp    8022c7 <free+0x98>
  8022bd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8022c0:	8b 00                	mov    (%eax),%eax
  8022c2:	a3 40 50 80 00       	mov    %eax,0x805040
  8022c7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8022ca:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8022d0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8022d3:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8022da:	a1 4c 50 80 00       	mov    0x80504c,%eax
  8022df:	48                   	dec    %eax
  8022e0:	a3 4c 50 80 00       	mov    %eax,0x80504c
	insert_sorted_with_merge_freeList(myBlock);
  8022e5:	83 ec 0c             	sub    $0xc,%esp
  8022e8:	ff 75 f0             	pushl  -0x10(%ebp)
  8022eb:	e8 0b 14 00 00       	call   8036fb <insert_sorted_with_merge_freeList>
  8022f0:	83 c4 10             	add    $0x10,%esp

	//you should get the size of the given allocation using its address
	//you need to call sys_free_user_mem()
	//refer to the project presentation and documentation for details
}
  8022f3:	90                   	nop
  8022f4:	c9                   	leave  
  8022f5:	c3                   	ret    

008022f6 <smalloc>:

//=================================
// [4] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
  8022f6:	55                   	push   %ebp
  8022f7:	89 e5                	mov    %esp,%ebp
  8022f9:	83 ec 28             	sub    $0x28,%esp
  8022fc:	8b 45 10             	mov    0x10(%ebp),%eax
  8022ff:	88 45 e4             	mov    %al,-0x1c(%ebp)
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  802302:	e8 9f fc ff ff       	call   801fa6 <InitializeUHeap>
	if (size == 0) return NULL ;
  802307:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80230b:	75 0a                	jne    802317 <smalloc+0x21>
  80230d:	b8 00 00 00 00       	mov    $0x0,%eax
  802312:	e9 8d 00 00 00       	jmp    8023a4 <smalloc+0xae>

	//This function should find the space of the required range
	// * ON 4KB BOUNDARY **** //
	//Use sys_isUHeapPlacementStrategyFIRSTFIT() to check the current strategy

	size = ROUNDUP(size, PAGE_SIZE);
  802317:	c7 45 f4 00 10 00 00 	movl   $0x1000,-0xc(%ebp)
  80231e:	8b 55 0c             	mov    0xc(%ebp),%edx
  802321:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802324:	01 d0                	add    %edx,%eax
  802326:	48                   	dec    %eax
  802327:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80232a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80232d:	ba 00 00 00 00       	mov    $0x0,%edx
  802332:	f7 75 f4             	divl   -0xc(%ebp)
  802335:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802338:	29 d0                	sub    %edx,%eax
  80233a:	89 45 0c             	mov    %eax,0xc(%ebp)
		if(sys_isUHeapPlacementStrategyFIRSTFIT())
  80233d:	e8 c9 06 00 00       	call   802a0b <sys_isUHeapPlacementStrategyFIRSTFIT>
  802342:	85 c0                	test   %eax,%eax
  802344:	74 59                	je     80239f <smalloc+0xa9>
		{
			struct MemBlock * v1=NULL;
  802346:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
			v1= alloc_block_FF(size);
  80234d:	83 ec 0c             	sub    $0xc,%esp
  802350:	ff 75 0c             	pushl  0xc(%ebp)
  802353:	e8 b4 0c 00 00       	call   80300c <alloc_block_FF>
  802358:	83 c4 10             	add    $0x10,%esp
  80235b:	89 45 ec             	mov    %eax,-0x14(%ebp)
			if(v1==NULL)
  80235e:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802362:	75 07                	jne    80236b <smalloc+0x75>
			{
				return NULL;
  802364:	b8 00 00 00 00       	mov    $0x0,%eax
  802369:	eb 39                	jmp    8023a4 <smalloc+0xae>
			}
			else
			{
				int ret=sys_createSharedObject(sharedVarName,  size,  isWritable,(void*)v1->sva);
  80236b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80236e:	8b 40 08             	mov    0x8(%eax),%eax
  802371:	89 c2                	mov    %eax,%edx
  802373:	0f b6 45 e4          	movzbl -0x1c(%ebp),%eax
  802377:	52                   	push   %edx
  802378:	50                   	push   %eax
  802379:	ff 75 0c             	pushl  0xc(%ebp)
  80237c:	ff 75 08             	pushl  0x8(%ebp)
  80237f:	e8 0c 04 00 00       	call   802790 <sys_createSharedObject>
  802384:	83 c4 10             	add    $0x10,%esp
  802387:	89 45 e8             	mov    %eax,-0x18(%ebp)
				if(ret>=0)
  80238a:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  80238e:	78 08                	js     802398 <smalloc+0xa2>
				{
					return (void*)v1->sva;
  802390:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802393:	8b 40 08             	mov    0x8(%eax),%eax
  802396:	eb 0c                	jmp    8023a4 <smalloc+0xae>
				}
				else
				{
					return NULL;
  802398:	b8 00 00 00 00       	mov    $0x0,%eax
  80239d:	eb 05                	jmp    8023a4 <smalloc+0xae>
				}
			}

		}
		return NULL;
  80239f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8023a4:	c9                   	leave  
  8023a5:	c3                   	ret    

008023a6 <sget>:

//========================================
// [5] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  8023a6:	55                   	push   %ebp
  8023a7:	89 e5                	mov    %esp,%ebp
  8023a9:	83 ec 18             	sub    $0x18,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  8023ac:	e8 f5 fb ff ff       	call   801fa6 <InitializeUHeap>

	//This function should find the space for sharing the variable
	// *** ON 4KB BOUNDARY ******** //

	//Use sys_isUHeapPlacementStrategyFIRSTFIT() to check the current strategy
	int ret=sys_getSizeOfSharedObject(ownerEnvID,sharedVarName);
  8023b1:	83 ec 08             	sub    $0x8,%esp
  8023b4:	ff 75 0c             	pushl  0xc(%ebp)
  8023b7:	ff 75 08             	pushl  0x8(%ebp)
  8023ba:	e8 fb 03 00 00       	call   8027ba <sys_getSizeOfSharedObject>
  8023bf:	83 c4 10             	add    $0x10,%esp
  8023c2:	89 45 f4             	mov    %eax,-0xc(%ebp)
	if(ret==0)
  8023c5:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8023c9:	75 07                	jne    8023d2 <sget+0x2c>
	{
		return NULL;
  8023cb:	b8 00 00 00 00       	mov    $0x0,%eax
  8023d0:	eb 64                	jmp    802436 <sget+0x90>
	}
	if(sys_isUHeapPlacementStrategyFIRSTFIT())
  8023d2:	e8 34 06 00 00       	call   802a0b <sys_isUHeapPlacementStrategyFIRSTFIT>
  8023d7:	85 c0                	test   %eax,%eax
  8023d9:	74 56                	je     802431 <sget+0x8b>
	{
		struct MemBlock * v1=NULL;
  8023db:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
		v1= alloc_block_FF(ret);
  8023e2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023e5:	83 ec 0c             	sub    $0xc,%esp
  8023e8:	50                   	push   %eax
  8023e9:	e8 1e 0c 00 00       	call   80300c <alloc_block_FF>
  8023ee:	83 c4 10             	add    $0x10,%esp
  8023f1:	89 45 f0             	mov    %eax,-0x10(%ebp)
		if(v1==NULL)
  8023f4:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8023f8:	75 07                	jne    802401 <sget+0x5b>
		{
		return NULL;
  8023fa:	b8 00 00 00 00       	mov    $0x0,%eax
  8023ff:	eb 35                	jmp    802436 <sget+0x90>
	    }
		else
		{
			int ret1=sys_getSharedObject(ownerEnvID,sharedVarName,(void*)v1->sva);
  802401:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802404:	8b 40 08             	mov    0x8(%eax),%eax
  802407:	83 ec 04             	sub    $0x4,%esp
  80240a:	50                   	push   %eax
  80240b:	ff 75 0c             	pushl  0xc(%ebp)
  80240e:	ff 75 08             	pushl  0x8(%ebp)
  802411:	e8 c1 03 00 00       	call   8027d7 <sys_getSharedObject>
  802416:	83 c4 10             	add    $0x10,%esp
  802419:	89 45 ec             	mov    %eax,-0x14(%ebp)
			if(ret1>=0)
  80241c:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802420:	78 08                	js     80242a <sget+0x84>
			{
				return (void*)v1->sva;
  802422:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802425:	8b 40 08             	mov    0x8(%eax),%eax
  802428:	eb 0c                	jmp    802436 <sget+0x90>
			}
			else
			{
				return NULL;
  80242a:	b8 00 00 00 00       	mov    $0x0,%eax
  80242f:	eb 05                	jmp    802436 <sget+0x90>
			}
		}
	}
  return NULL;
  802431:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802436:	c9                   	leave  
  802437:	c3                   	ret    

00802438 <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  802438:	55                   	push   %ebp
  802439:	89 e5                	mov    %esp,%ebp
  80243b:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  80243e:	e8 63 fb ff ff       	call   801fa6 <InitializeUHeap>
	//==============================================================
	// [USER HEAP - USER SIDE] realloc
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  802443:	83 ec 04             	sub    $0x4,%esp
  802446:	68 24 45 80 00       	push   $0x804524
  80244b:	68 0e 01 00 00       	push   $0x10e
  802450:	68 f3 44 80 00       	push   $0x8044f3
  802455:	e8 0e eb ff ff       	call   800f68 <_panic>

0080245a <sfree>:
//	use sys_freeSharedObject(...); which switches to the kernel mode,
//	calls freeSharedObject(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the freeSharedObject() function is empty, make sure to implement it.

void sfree(void* virtual_address)
{
  80245a:	55                   	push   %ebp
  80245b:	89 e5                	mov    %esp,%ebp
  80245d:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS3 - BONUS] [SHARING - USER SIDE] sfree()

	// Write your code here, remove the panic and write your code
	panic("sfree() is not implemented yet...!!");
  802460:	83 ec 04             	sub    $0x4,%esp
  802463:	68 4c 45 80 00       	push   $0x80454c
  802468:	68 22 01 00 00       	push   $0x122
  80246d:	68 f3 44 80 00       	push   $0x8044f3
  802472:	e8 f1 ea ff ff       	call   800f68 <_panic>

00802477 <expand>:

//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//
void expand(uint32 newSize)
{
  802477:	55                   	push   %ebp
  802478:	89 e5                	mov    %esp,%ebp
  80247a:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  80247d:	83 ec 04             	sub    $0x4,%esp
  802480:	68 70 45 80 00       	push   $0x804570
  802485:	68 2d 01 00 00       	push   $0x12d
  80248a:	68 f3 44 80 00       	push   $0x8044f3
  80248f:	e8 d4 ea ff ff       	call   800f68 <_panic>

00802494 <shrink>:

}
void shrink(uint32 newSize)
{
  802494:	55                   	push   %ebp
  802495:	89 e5                	mov    %esp,%ebp
  802497:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  80249a:	83 ec 04             	sub    $0x4,%esp
  80249d:	68 70 45 80 00       	push   $0x804570
  8024a2:	68 32 01 00 00       	push   $0x132
  8024a7:	68 f3 44 80 00       	push   $0x8044f3
  8024ac:	e8 b7 ea ff ff       	call   800f68 <_panic>

008024b1 <freeHeap>:

}
void freeHeap(void* virtual_address)
{
  8024b1:	55                   	push   %ebp
  8024b2:	89 e5                	mov    %esp,%ebp
  8024b4:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  8024b7:	83 ec 04             	sub    $0x4,%esp
  8024ba:	68 70 45 80 00       	push   $0x804570
  8024bf:	68 37 01 00 00       	push   $0x137
  8024c4:	68 f3 44 80 00       	push   $0x8044f3
  8024c9:	e8 9a ea ff ff       	call   800f68 <_panic>

008024ce <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  8024ce:	55                   	push   %ebp
  8024cf:	89 e5                	mov    %esp,%ebp
  8024d1:	57                   	push   %edi
  8024d2:	56                   	push   %esi
  8024d3:	53                   	push   %ebx
  8024d4:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8024d7:	8b 45 08             	mov    0x8(%ebp),%eax
  8024da:	8b 55 0c             	mov    0xc(%ebp),%edx
  8024dd:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8024e0:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8024e3:	8b 7d 18             	mov    0x18(%ebp),%edi
  8024e6:	8b 75 1c             	mov    0x1c(%ebp),%esi
  8024e9:	cd 30                	int    $0x30
  8024eb:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  8024ee:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8024f1:	83 c4 10             	add    $0x10,%esp
  8024f4:	5b                   	pop    %ebx
  8024f5:	5e                   	pop    %esi
  8024f6:	5f                   	pop    %edi
  8024f7:	5d                   	pop    %ebp
  8024f8:	c3                   	ret    

008024f9 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  8024f9:	55                   	push   %ebp
  8024fa:	89 e5                	mov    %esp,%ebp
  8024fc:	83 ec 04             	sub    $0x4,%esp
  8024ff:	8b 45 10             	mov    0x10(%ebp),%eax
  802502:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  802505:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  802509:	8b 45 08             	mov    0x8(%ebp),%eax
  80250c:	6a 00                	push   $0x0
  80250e:	6a 00                	push   $0x0
  802510:	52                   	push   %edx
  802511:	ff 75 0c             	pushl  0xc(%ebp)
  802514:	50                   	push   %eax
  802515:	6a 00                	push   $0x0
  802517:	e8 b2 ff ff ff       	call   8024ce <syscall>
  80251c:	83 c4 18             	add    $0x18,%esp
}
  80251f:	90                   	nop
  802520:	c9                   	leave  
  802521:	c3                   	ret    

00802522 <sys_cgetc>:

int
sys_cgetc(void)
{
  802522:	55                   	push   %ebp
  802523:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  802525:	6a 00                	push   $0x0
  802527:	6a 00                	push   $0x0
  802529:	6a 00                	push   $0x0
  80252b:	6a 00                	push   $0x0
  80252d:	6a 00                	push   $0x0
  80252f:	6a 01                	push   $0x1
  802531:	e8 98 ff ff ff       	call   8024ce <syscall>
  802536:	83 c4 18             	add    $0x18,%esp
}
  802539:	c9                   	leave  
  80253a:	c3                   	ret    

0080253b <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  80253b:	55                   	push   %ebp
  80253c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  80253e:	8b 55 0c             	mov    0xc(%ebp),%edx
  802541:	8b 45 08             	mov    0x8(%ebp),%eax
  802544:	6a 00                	push   $0x0
  802546:	6a 00                	push   $0x0
  802548:	6a 00                	push   $0x0
  80254a:	52                   	push   %edx
  80254b:	50                   	push   %eax
  80254c:	6a 05                	push   $0x5
  80254e:	e8 7b ff ff ff       	call   8024ce <syscall>
  802553:	83 c4 18             	add    $0x18,%esp
}
  802556:	c9                   	leave  
  802557:	c3                   	ret    

00802558 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  802558:	55                   	push   %ebp
  802559:	89 e5                	mov    %esp,%ebp
  80255b:	56                   	push   %esi
  80255c:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  80255d:	8b 75 18             	mov    0x18(%ebp),%esi
  802560:	8b 5d 14             	mov    0x14(%ebp),%ebx
  802563:	8b 4d 10             	mov    0x10(%ebp),%ecx
  802566:	8b 55 0c             	mov    0xc(%ebp),%edx
  802569:	8b 45 08             	mov    0x8(%ebp),%eax
  80256c:	56                   	push   %esi
  80256d:	53                   	push   %ebx
  80256e:	51                   	push   %ecx
  80256f:	52                   	push   %edx
  802570:	50                   	push   %eax
  802571:	6a 06                	push   $0x6
  802573:	e8 56 ff ff ff       	call   8024ce <syscall>
  802578:	83 c4 18             	add    $0x18,%esp
}
  80257b:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80257e:	5b                   	pop    %ebx
  80257f:	5e                   	pop    %esi
  802580:	5d                   	pop    %ebp
  802581:	c3                   	ret    

00802582 <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  802582:	55                   	push   %ebp
  802583:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  802585:	8b 55 0c             	mov    0xc(%ebp),%edx
  802588:	8b 45 08             	mov    0x8(%ebp),%eax
  80258b:	6a 00                	push   $0x0
  80258d:	6a 00                	push   $0x0
  80258f:	6a 00                	push   $0x0
  802591:	52                   	push   %edx
  802592:	50                   	push   %eax
  802593:	6a 07                	push   $0x7
  802595:	e8 34 ff ff ff       	call   8024ce <syscall>
  80259a:	83 c4 18             	add    $0x18,%esp
}
  80259d:	c9                   	leave  
  80259e:	c3                   	ret    

0080259f <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  80259f:	55                   	push   %ebp
  8025a0:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  8025a2:	6a 00                	push   $0x0
  8025a4:	6a 00                	push   $0x0
  8025a6:	6a 00                	push   $0x0
  8025a8:	ff 75 0c             	pushl  0xc(%ebp)
  8025ab:	ff 75 08             	pushl  0x8(%ebp)
  8025ae:	6a 08                	push   $0x8
  8025b0:	e8 19 ff ff ff       	call   8024ce <syscall>
  8025b5:	83 c4 18             	add    $0x18,%esp
}
  8025b8:	c9                   	leave  
  8025b9:	c3                   	ret    

008025ba <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  8025ba:	55                   	push   %ebp
  8025bb:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  8025bd:	6a 00                	push   $0x0
  8025bf:	6a 00                	push   $0x0
  8025c1:	6a 00                	push   $0x0
  8025c3:	6a 00                	push   $0x0
  8025c5:	6a 00                	push   $0x0
  8025c7:	6a 09                	push   $0x9
  8025c9:	e8 00 ff ff ff       	call   8024ce <syscall>
  8025ce:	83 c4 18             	add    $0x18,%esp
}
  8025d1:	c9                   	leave  
  8025d2:	c3                   	ret    

008025d3 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  8025d3:	55                   	push   %ebp
  8025d4:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  8025d6:	6a 00                	push   $0x0
  8025d8:	6a 00                	push   $0x0
  8025da:	6a 00                	push   $0x0
  8025dc:	6a 00                	push   $0x0
  8025de:	6a 00                	push   $0x0
  8025e0:	6a 0a                	push   $0xa
  8025e2:	e8 e7 fe ff ff       	call   8024ce <syscall>
  8025e7:	83 c4 18             	add    $0x18,%esp
}
  8025ea:	c9                   	leave  
  8025eb:	c3                   	ret    

008025ec <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  8025ec:	55                   	push   %ebp
  8025ed:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  8025ef:	6a 00                	push   $0x0
  8025f1:	6a 00                	push   $0x0
  8025f3:	6a 00                	push   $0x0
  8025f5:	6a 00                	push   $0x0
  8025f7:	6a 00                	push   $0x0
  8025f9:	6a 0b                	push   $0xb
  8025fb:	e8 ce fe ff ff       	call   8024ce <syscall>
  802600:	83 c4 18             	add    $0x18,%esp
}
  802603:	c9                   	leave  
  802604:	c3                   	ret    

00802605 <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  802605:	55                   	push   %ebp
  802606:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  802608:	6a 00                	push   $0x0
  80260a:	6a 00                	push   $0x0
  80260c:	6a 00                	push   $0x0
  80260e:	ff 75 0c             	pushl  0xc(%ebp)
  802611:	ff 75 08             	pushl  0x8(%ebp)
  802614:	6a 0f                	push   $0xf
  802616:	e8 b3 fe ff ff       	call   8024ce <syscall>
  80261b:	83 c4 18             	add    $0x18,%esp
	return;
  80261e:	90                   	nop
}
  80261f:	c9                   	leave  
  802620:	c3                   	ret    

00802621 <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  802621:	55                   	push   %ebp
  802622:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  802624:	6a 00                	push   $0x0
  802626:	6a 00                	push   $0x0
  802628:	6a 00                	push   $0x0
  80262a:	ff 75 0c             	pushl  0xc(%ebp)
  80262d:	ff 75 08             	pushl  0x8(%ebp)
  802630:	6a 10                	push   $0x10
  802632:	e8 97 fe ff ff       	call   8024ce <syscall>
  802637:	83 c4 18             	add    $0x18,%esp
	return ;
  80263a:	90                   	nop
}
  80263b:	c9                   	leave  
  80263c:	c3                   	ret    

0080263d <sys_allocate_chunk>:

void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  80263d:	55                   	push   %ebp
  80263e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  802640:	6a 00                	push   $0x0
  802642:	6a 00                	push   $0x0
  802644:	ff 75 10             	pushl  0x10(%ebp)
  802647:	ff 75 0c             	pushl  0xc(%ebp)
  80264a:	ff 75 08             	pushl  0x8(%ebp)
  80264d:	6a 11                	push   $0x11
  80264f:	e8 7a fe ff ff       	call   8024ce <syscall>
  802654:	83 c4 18             	add    $0x18,%esp
	return ;
  802657:	90                   	nop
}
  802658:	c9                   	leave  
  802659:	c3                   	ret    

0080265a <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  80265a:	55                   	push   %ebp
  80265b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  80265d:	6a 00                	push   $0x0
  80265f:	6a 00                	push   $0x0
  802661:	6a 00                	push   $0x0
  802663:	6a 00                	push   $0x0
  802665:	6a 00                	push   $0x0
  802667:	6a 0c                	push   $0xc
  802669:	e8 60 fe ff ff       	call   8024ce <syscall>
  80266e:	83 c4 18             	add    $0x18,%esp
}
  802671:	c9                   	leave  
  802672:	c3                   	ret    

00802673 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  802673:	55                   	push   %ebp
  802674:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  802676:	6a 00                	push   $0x0
  802678:	6a 00                	push   $0x0
  80267a:	6a 00                	push   $0x0
  80267c:	6a 00                	push   $0x0
  80267e:	ff 75 08             	pushl  0x8(%ebp)
  802681:	6a 0d                	push   $0xd
  802683:	e8 46 fe ff ff       	call   8024ce <syscall>
  802688:	83 c4 18             	add    $0x18,%esp
}
  80268b:	c9                   	leave  
  80268c:	c3                   	ret    

0080268d <sys_scarce_memory>:

void sys_scarce_memory()
{
  80268d:	55                   	push   %ebp
  80268e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  802690:	6a 00                	push   $0x0
  802692:	6a 00                	push   $0x0
  802694:	6a 00                	push   $0x0
  802696:	6a 00                	push   $0x0
  802698:	6a 00                	push   $0x0
  80269a:	6a 0e                	push   $0xe
  80269c:	e8 2d fe ff ff       	call   8024ce <syscall>
  8026a1:	83 c4 18             	add    $0x18,%esp
}
  8026a4:	90                   	nop
  8026a5:	c9                   	leave  
  8026a6:	c3                   	ret    

008026a7 <sys_disable_interrupt>:

//NEW !! 2012...
void
sys_disable_interrupt()
{
  8026a7:	55                   	push   %ebp
  8026a8:	89 e5                	mov    %esp,%ebp
	syscall(SYS_disableINTR,0, 0, 0, 0, 0);
  8026aa:	6a 00                	push   $0x0
  8026ac:	6a 00                	push   $0x0
  8026ae:	6a 00                	push   $0x0
  8026b0:	6a 00                	push   $0x0
  8026b2:	6a 00                	push   $0x0
  8026b4:	6a 13                	push   $0x13
  8026b6:	e8 13 fe ff ff       	call   8024ce <syscall>
  8026bb:	83 c4 18             	add    $0x18,%esp
}
  8026be:	90                   	nop
  8026bf:	c9                   	leave  
  8026c0:	c3                   	ret    

008026c1 <sys_enable_interrupt>:


void
sys_enable_interrupt()
{
  8026c1:	55                   	push   %ebp
  8026c2:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enableINTR,0, 0, 0, 0, 0);
  8026c4:	6a 00                	push   $0x0
  8026c6:	6a 00                	push   $0x0
  8026c8:	6a 00                	push   $0x0
  8026ca:	6a 00                	push   $0x0
  8026cc:	6a 00                	push   $0x0
  8026ce:	6a 14                	push   $0x14
  8026d0:	e8 f9 fd ff ff       	call   8024ce <syscall>
  8026d5:	83 c4 18             	add    $0x18,%esp
}
  8026d8:	90                   	nop
  8026d9:	c9                   	leave  
  8026da:	c3                   	ret    

008026db <sys_cputc>:


void
sys_cputc(const char c)
{
  8026db:	55                   	push   %ebp
  8026dc:	89 e5                	mov    %esp,%ebp
  8026de:	83 ec 04             	sub    $0x4,%esp
  8026e1:	8b 45 08             	mov    0x8(%ebp),%eax
  8026e4:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  8026e7:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  8026eb:	6a 00                	push   $0x0
  8026ed:	6a 00                	push   $0x0
  8026ef:	6a 00                	push   $0x0
  8026f1:	6a 00                	push   $0x0
  8026f3:	50                   	push   %eax
  8026f4:	6a 15                	push   $0x15
  8026f6:	e8 d3 fd ff ff       	call   8024ce <syscall>
  8026fb:	83 c4 18             	add    $0x18,%esp
}
  8026fe:	90                   	nop
  8026ff:	c9                   	leave  
  802700:	c3                   	ret    

00802701 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  802701:	55                   	push   %ebp
  802702:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  802704:	6a 00                	push   $0x0
  802706:	6a 00                	push   $0x0
  802708:	6a 00                	push   $0x0
  80270a:	6a 00                	push   $0x0
  80270c:	6a 00                	push   $0x0
  80270e:	6a 16                	push   $0x16
  802710:	e8 b9 fd ff ff       	call   8024ce <syscall>
  802715:	83 c4 18             	add    $0x18,%esp
}
  802718:	90                   	nop
  802719:	c9                   	leave  
  80271a:	c3                   	ret    

0080271b <sys_createSemaphore>:

int
sys_createSemaphore(char* semaphoreName, uint32 initialValue)
{
  80271b:	55                   	push   %ebp
  80271c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_semaphore,(uint32)semaphoreName, (uint32)initialValue, 0, 0, 0);
  80271e:	8b 45 08             	mov    0x8(%ebp),%eax
  802721:	6a 00                	push   $0x0
  802723:	6a 00                	push   $0x0
  802725:	6a 00                	push   $0x0
  802727:	ff 75 0c             	pushl  0xc(%ebp)
  80272a:	50                   	push   %eax
  80272b:	6a 17                	push   $0x17
  80272d:	e8 9c fd ff ff       	call   8024ce <syscall>
  802732:	83 c4 18             	add    $0x18,%esp
}
  802735:	c9                   	leave  
  802736:	c3                   	ret    

00802737 <sys_getSemaphoreValue>:

int
sys_getSemaphoreValue(int32 ownerEnvID, char* semaphoreName)
{
  802737:	55                   	push   %ebp
  802738:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_semaphore_value,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  80273a:	8b 55 0c             	mov    0xc(%ebp),%edx
  80273d:	8b 45 08             	mov    0x8(%ebp),%eax
  802740:	6a 00                	push   $0x0
  802742:	6a 00                	push   $0x0
  802744:	6a 00                	push   $0x0
  802746:	52                   	push   %edx
  802747:	50                   	push   %eax
  802748:	6a 1a                	push   $0x1a
  80274a:	e8 7f fd ff ff       	call   8024ce <syscall>
  80274f:	83 c4 18             	add    $0x18,%esp
}
  802752:	c9                   	leave  
  802753:	c3                   	ret    

00802754 <sys_waitSemaphore>:

void
sys_waitSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  802754:	55                   	push   %ebp
  802755:	89 e5                	mov    %esp,%ebp
	syscall(SYS_wait_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  802757:	8b 55 0c             	mov    0xc(%ebp),%edx
  80275a:	8b 45 08             	mov    0x8(%ebp),%eax
  80275d:	6a 00                	push   $0x0
  80275f:	6a 00                	push   $0x0
  802761:	6a 00                	push   $0x0
  802763:	52                   	push   %edx
  802764:	50                   	push   %eax
  802765:	6a 18                	push   $0x18
  802767:	e8 62 fd ff ff       	call   8024ce <syscall>
  80276c:	83 c4 18             	add    $0x18,%esp
}
  80276f:	90                   	nop
  802770:	c9                   	leave  
  802771:	c3                   	ret    

00802772 <sys_signalSemaphore>:

void
sys_signalSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  802772:	55                   	push   %ebp
  802773:	89 e5                	mov    %esp,%ebp
	syscall(SYS_signal_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  802775:	8b 55 0c             	mov    0xc(%ebp),%edx
  802778:	8b 45 08             	mov    0x8(%ebp),%eax
  80277b:	6a 00                	push   $0x0
  80277d:	6a 00                	push   $0x0
  80277f:	6a 00                	push   $0x0
  802781:	52                   	push   %edx
  802782:	50                   	push   %eax
  802783:	6a 19                	push   $0x19
  802785:	e8 44 fd ff ff       	call   8024ce <syscall>
  80278a:	83 c4 18             	add    $0x18,%esp
}
  80278d:	90                   	nop
  80278e:	c9                   	leave  
  80278f:	c3                   	ret    

00802790 <sys_createSharedObject>:

int
sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  802790:	55                   	push   %ebp
  802791:	89 e5                	mov    %esp,%ebp
  802793:	83 ec 04             	sub    $0x4,%esp
  802796:	8b 45 10             	mov    0x10(%ebp),%eax
  802799:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  80279c:	8b 4d 14             	mov    0x14(%ebp),%ecx
  80279f:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  8027a3:	8b 45 08             	mov    0x8(%ebp),%eax
  8027a6:	6a 00                	push   $0x0
  8027a8:	51                   	push   %ecx
  8027a9:	52                   	push   %edx
  8027aa:	ff 75 0c             	pushl  0xc(%ebp)
  8027ad:	50                   	push   %eax
  8027ae:	6a 1b                	push   $0x1b
  8027b0:	e8 19 fd ff ff       	call   8024ce <syscall>
  8027b5:	83 c4 18             	add    $0x18,%esp
}
  8027b8:	c9                   	leave  
  8027b9:	c3                   	ret    

008027ba <sys_getSizeOfSharedObject>:

//2017:
int
sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  8027ba:	55                   	push   %ebp
  8027bb:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  8027bd:	8b 55 0c             	mov    0xc(%ebp),%edx
  8027c0:	8b 45 08             	mov    0x8(%ebp),%eax
  8027c3:	6a 00                	push   $0x0
  8027c5:	6a 00                	push   $0x0
  8027c7:	6a 00                	push   $0x0
  8027c9:	52                   	push   %edx
  8027ca:	50                   	push   %eax
  8027cb:	6a 1c                	push   $0x1c
  8027cd:	e8 fc fc ff ff       	call   8024ce <syscall>
  8027d2:	83 c4 18             	add    $0x18,%esp
}
  8027d5:	c9                   	leave  
  8027d6:	c3                   	ret    

008027d7 <sys_getSharedObject>:
//==========

int
sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  8027d7:	55                   	push   %ebp
  8027d8:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  8027da:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8027dd:	8b 55 0c             	mov    0xc(%ebp),%edx
  8027e0:	8b 45 08             	mov    0x8(%ebp),%eax
  8027e3:	6a 00                	push   $0x0
  8027e5:	6a 00                	push   $0x0
  8027e7:	51                   	push   %ecx
  8027e8:	52                   	push   %edx
  8027e9:	50                   	push   %eax
  8027ea:	6a 1d                	push   $0x1d
  8027ec:	e8 dd fc ff ff       	call   8024ce <syscall>
  8027f1:	83 c4 18             	add    $0x18,%esp
}
  8027f4:	c9                   	leave  
  8027f5:	c3                   	ret    

008027f6 <sys_freeSharedObject>:

int
sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  8027f6:	55                   	push   %ebp
  8027f7:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  8027f9:	8b 55 0c             	mov    0xc(%ebp),%edx
  8027fc:	8b 45 08             	mov    0x8(%ebp),%eax
  8027ff:	6a 00                	push   $0x0
  802801:	6a 00                	push   $0x0
  802803:	6a 00                	push   $0x0
  802805:	52                   	push   %edx
  802806:	50                   	push   %eax
  802807:	6a 1e                	push   $0x1e
  802809:	e8 c0 fc ff ff       	call   8024ce <syscall>
  80280e:	83 c4 18             	add    $0x18,%esp
}
  802811:	c9                   	leave  
  802812:	c3                   	ret    

00802813 <sys_getMaxShares>:

uint32 	sys_getMaxShares()
{
  802813:	55                   	push   %ebp
  802814:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_max_shares,0, 0, 0, 0, 0);
  802816:	6a 00                	push   $0x0
  802818:	6a 00                	push   $0x0
  80281a:	6a 00                	push   $0x0
  80281c:	6a 00                	push   $0x0
  80281e:	6a 00                	push   $0x0
  802820:	6a 1f                	push   $0x1f
  802822:	e8 a7 fc ff ff       	call   8024ce <syscall>
  802827:	83 c4 18             	add    $0x18,%esp
}
  80282a:	c9                   	leave  
  80282b:	c3                   	ret    

0080282c <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  80282c:	55                   	push   %ebp
  80282d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  80282f:	8b 45 08             	mov    0x8(%ebp),%eax
  802832:	6a 00                	push   $0x0
  802834:	ff 75 14             	pushl  0x14(%ebp)
  802837:	ff 75 10             	pushl  0x10(%ebp)
  80283a:	ff 75 0c             	pushl  0xc(%ebp)
  80283d:	50                   	push   %eax
  80283e:	6a 20                	push   $0x20
  802840:	e8 89 fc ff ff       	call   8024ce <syscall>
  802845:	83 c4 18             	add    $0x18,%esp
}
  802848:	c9                   	leave  
  802849:	c3                   	ret    

0080284a <sys_run_env>:

void
sys_run_env(int32 envId)
{
  80284a:	55                   	push   %ebp
  80284b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  80284d:	8b 45 08             	mov    0x8(%ebp),%eax
  802850:	6a 00                	push   $0x0
  802852:	6a 00                	push   $0x0
  802854:	6a 00                	push   $0x0
  802856:	6a 00                	push   $0x0
  802858:	50                   	push   %eax
  802859:	6a 21                	push   $0x21
  80285b:	e8 6e fc ff ff       	call   8024ce <syscall>
  802860:	83 c4 18             	add    $0x18,%esp
}
  802863:	90                   	nop
  802864:	c9                   	leave  
  802865:	c3                   	ret    

00802866 <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  802866:	55                   	push   %ebp
  802867:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  802869:	8b 45 08             	mov    0x8(%ebp),%eax
  80286c:	6a 00                	push   $0x0
  80286e:	6a 00                	push   $0x0
  802870:	6a 00                	push   $0x0
  802872:	6a 00                	push   $0x0
  802874:	50                   	push   %eax
  802875:	6a 22                	push   $0x22
  802877:	e8 52 fc ff ff       	call   8024ce <syscall>
  80287c:	83 c4 18             	add    $0x18,%esp
}
  80287f:	c9                   	leave  
  802880:	c3                   	ret    

00802881 <sys_getenvid>:

int32 sys_getenvid(void)
{
  802881:	55                   	push   %ebp
  802882:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  802884:	6a 00                	push   $0x0
  802886:	6a 00                	push   $0x0
  802888:	6a 00                	push   $0x0
  80288a:	6a 00                	push   $0x0
  80288c:	6a 00                	push   $0x0
  80288e:	6a 02                	push   $0x2
  802890:	e8 39 fc ff ff       	call   8024ce <syscall>
  802895:	83 c4 18             	add    $0x18,%esp
}
  802898:	c9                   	leave  
  802899:	c3                   	ret    

0080289a <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  80289a:	55                   	push   %ebp
  80289b:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  80289d:	6a 00                	push   $0x0
  80289f:	6a 00                	push   $0x0
  8028a1:	6a 00                	push   $0x0
  8028a3:	6a 00                	push   $0x0
  8028a5:	6a 00                	push   $0x0
  8028a7:	6a 03                	push   $0x3
  8028a9:	e8 20 fc ff ff       	call   8024ce <syscall>
  8028ae:	83 c4 18             	add    $0x18,%esp
}
  8028b1:	c9                   	leave  
  8028b2:	c3                   	ret    

008028b3 <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  8028b3:	55                   	push   %ebp
  8028b4:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  8028b6:	6a 00                	push   $0x0
  8028b8:	6a 00                	push   $0x0
  8028ba:	6a 00                	push   $0x0
  8028bc:	6a 00                	push   $0x0
  8028be:	6a 00                	push   $0x0
  8028c0:	6a 04                	push   $0x4
  8028c2:	e8 07 fc ff ff       	call   8024ce <syscall>
  8028c7:	83 c4 18             	add    $0x18,%esp
}
  8028ca:	c9                   	leave  
  8028cb:	c3                   	ret    

008028cc <sys_exit_env>:


void sys_exit_env(void)
{
  8028cc:	55                   	push   %ebp
  8028cd:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  8028cf:	6a 00                	push   $0x0
  8028d1:	6a 00                	push   $0x0
  8028d3:	6a 00                	push   $0x0
  8028d5:	6a 00                	push   $0x0
  8028d7:	6a 00                	push   $0x0
  8028d9:	6a 23                	push   $0x23
  8028db:	e8 ee fb ff ff       	call   8024ce <syscall>
  8028e0:	83 c4 18             	add    $0x18,%esp
}
  8028e3:	90                   	nop
  8028e4:	c9                   	leave  
  8028e5:	c3                   	ret    

008028e6 <sys_get_virtual_time>:


struct uint64
sys_get_virtual_time()
{
  8028e6:	55                   	push   %ebp
  8028e7:	89 e5                	mov    %esp,%ebp
  8028e9:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  8028ec:	8d 45 f8             	lea    -0x8(%ebp),%eax
  8028ef:	8d 50 04             	lea    0x4(%eax),%edx
  8028f2:	8d 45 f8             	lea    -0x8(%ebp),%eax
  8028f5:	6a 00                	push   $0x0
  8028f7:	6a 00                	push   $0x0
  8028f9:	6a 00                	push   $0x0
  8028fb:	52                   	push   %edx
  8028fc:	50                   	push   %eax
  8028fd:	6a 24                	push   $0x24
  8028ff:	e8 ca fb ff ff       	call   8024ce <syscall>
  802904:	83 c4 18             	add    $0x18,%esp
	return result;
  802907:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80290a:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80290d:	8b 55 fc             	mov    -0x4(%ebp),%edx
  802910:	89 01                	mov    %eax,(%ecx)
  802912:	89 51 04             	mov    %edx,0x4(%ecx)
}
  802915:	8b 45 08             	mov    0x8(%ebp),%eax
  802918:	c9                   	leave  
  802919:	c2 04 00             	ret    $0x4

0080291c <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  80291c:	55                   	push   %ebp
  80291d:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  80291f:	6a 00                	push   $0x0
  802921:	6a 00                	push   $0x0
  802923:	ff 75 10             	pushl  0x10(%ebp)
  802926:	ff 75 0c             	pushl  0xc(%ebp)
  802929:	ff 75 08             	pushl  0x8(%ebp)
  80292c:	6a 12                	push   $0x12
  80292e:	e8 9b fb ff ff       	call   8024ce <syscall>
  802933:	83 c4 18             	add    $0x18,%esp
	return ;
  802936:	90                   	nop
}
  802937:	c9                   	leave  
  802938:	c3                   	ret    

00802939 <sys_rcr2>:
uint32 sys_rcr2()
{
  802939:	55                   	push   %ebp
  80293a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  80293c:	6a 00                	push   $0x0
  80293e:	6a 00                	push   $0x0
  802940:	6a 00                	push   $0x0
  802942:	6a 00                	push   $0x0
  802944:	6a 00                	push   $0x0
  802946:	6a 25                	push   $0x25
  802948:	e8 81 fb ff ff       	call   8024ce <syscall>
  80294d:	83 c4 18             	add    $0x18,%esp
}
  802950:	c9                   	leave  
  802951:	c3                   	ret    

00802952 <sys_bypassPageFault>:
void sys_bypassPageFault(uint8 instrLength)
{
  802952:	55                   	push   %ebp
  802953:	89 e5                	mov    %esp,%ebp
  802955:	83 ec 04             	sub    $0x4,%esp
  802958:	8b 45 08             	mov    0x8(%ebp),%eax
  80295b:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  80295e:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  802962:	6a 00                	push   $0x0
  802964:	6a 00                	push   $0x0
  802966:	6a 00                	push   $0x0
  802968:	6a 00                	push   $0x0
  80296a:	50                   	push   %eax
  80296b:	6a 26                	push   $0x26
  80296d:	e8 5c fb ff ff       	call   8024ce <syscall>
  802972:	83 c4 18             	add    $0x18,%esp
	return ;
  802975:	90                   	nop
}
  802976:	c9                   	leave  
  802977:	c3                   	ret    

00802978 <rsttst>:
void rsttst()
{
  802978:	55                   	push   %ebp
  802979:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  80297b:	6a 00                	push   $0x0
  80297d:	6a 00                	push   $0x0
  80297f:	6a 00                	push   $0x0
  802981:	6a 00                	push   $0x0
  802983:	6a 00                	push   $0x0
  802985:	6a 28                	push   $0x28
  802987:	e8 42 fb ff ff       	call   8024ce <syscall>
  80298c:	83 c4 18             	add    $0x18,%esp
	return ;
  80298f:	90                   	nop
}
  802990:	c9                   	leave  
  802991:	c3                   	ret    

00802992 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  802992:	55                   	push   %ebp
  802993:	89 e5                	mov    %esp,%ebp
  802995:	83 ec 04             	sub    $0x4,%esp
  802998:	8b 45 14             	mov    0x14(%ebp),%eax
  80299b:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  80299e:	8b 55 18             	mov    0x18(%ebp),%edx
  8029a1:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  8029a5:	52                   	push   %edx
  8029a6:	50                   	push   %eax
  8029a7:	ff 75 10             	pushl  0x10(%ebp)
  8029aa:	ff 75 0c             	pushl  0xc(%ebp)
  8029ad:	ff 75 08             	pushl  0x8(%ebp)
  8029b0:	6a 27                	push   $0x27
  8029b2:	e8 17 fb ff ff       	call   8024ce <syscall>
  8029b7:	83 c4 18             	add    $0x18,%esp
	return ;
  8029ba:	90                   	nop
}
  8029bb:	c9                   	leave  
  8029bc:	c3                   	ret    

008029bd <chktst>:
void chktst(uint32 n)
{
  8029bd:	55                   	push   %ebp
  8029be:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  8029c0:	6a 00                	push   $0x0
  8029c2:	6a 00                	push   $0x0
  8029c4:	6a 00                	push   $0x0
  8029c6:	6a 00                	push   $0x0
  8029c8:	ff 75 08             	pushl  0x8(%ebp)
  8029cb:	6a 29                	push   $0x29
  8029cd:	e8 fc fa ff ff       	call   8024ce <syscall>
  8029d2:	83 c4 18             	add    $0x18,%esp
	return ;
  8029d5:	90                   	nop
}
  8029d6:	c9                   	leave  
  8029d7:	c3                   	ret    

008029d8 <inctst>:

void inctst()
{
  8029d8:	55                   	push   %ebp
  8029d9:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  8029db:	6a 00                	push   $0x0
  8029dd:	6a 00                	push   $0x0
  8029df:	6a 00                	push   $0x0
  8029e1:	6a 00                	push   $0x0
  8029e3:	6a 00                	push   $0x0
  8029e5:	6a 2a                	push   $0x2a
  8029e7:	e8 e2 fa ff ff       	call   8024ce <syscall>
  8029ec:	83 c4 18             	add    $0x18,%esp
	return ;
  8029ef:	90                   	nop
}
  8029f0:	c9                   	leave  
  8029f1:	c3                   	ret    

008029f2 <gettst>:
uint32 gettst()
{
  8029f2:	55                   	push   %ebp
  8029f3:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  8029f5:	6a 00                	push   $0x0
  8029f7:	6a 00                	push   $0x0
  8029f9:	6a 00                	push   $0x0
  8029fb:	6a 00                	push   $0x0
  8029fd:	6a 00                	push   $0x0
  8029ff:	6a 2b                	push   $0x2b
  802a01:	e8 c8 fa ff ff       	call   8024ce <syscall>
  802a06:	83 c4 18             	add    $0x18,%esp
}
  802a09:	c9                   	leave  
  802a0a:	c3                   	ret    

00802a0b <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  802a0b:	55                   	push   %ebp
  802a0c:	89 e5                	mov    %esp,%ebp
  802a0e:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  802a11:	6a 00                	push   $0x0
  802a13:	6a 00                	push   $0x0
  802a15:	6a 00                	push   $0x0
  802a17:	6a 00                	push   $0x0
  802a19:	6a 00                	push   $0x0
  802a1b:	6a 2c                	push   $0x2c
  802a1d:	e8 ac fa ff ff       	call   8024ce <syscall>
  802a22:	83 c4 18             	add    $0x18,%esp
  802a25:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  802a28:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  802a2c:	75 07                	jne    802a35 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  802a2e:	b8 01 00 00 00       	mov    $0x1,%eax
  802a33:	eb 05                	jmp    802a3a <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  802a35:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802a3a:	c9                   	leave  
  802a3b:	c3                   	ret    

00802a3c <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  802a3c:	55                   	push   %ebp
  802a3d:	89 e5                	mov    %esp,%ebp
  802a3f:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  802a42:	6a 00                	push   $0x0
  802a44:	6a 00                	push   $0x0
  802a46:	6a 00                	push   $0x0
  802a48:	6a 00                	push   $0x0
  802a4a:	6a 00                	push   $0x0
  802a4c:	6a 2c                	push   $0x2c
  802a4e:	e8 7b fa ff ff       	call   8024ce <syscall>
  802a53:	83 c4 18             	add    $0x18,%esp
  802a56:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  802a59:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  802a5d:	75 07                	jne    802a66 <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  802a5f:	b8 01 00 00 00       	mov    $0x1,%eax
  802a64:	eb 05                	jmp    802a6b <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  802a66:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802a6b:	c9                   	leave  
  802a6c:	c3                   	ret    

00802a6d <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  802a6d:	55                   	push   %ebp
  802a6e:	89 e5                	mov    %esp,%ebp
  802a70:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  802a73:	6a 00                	push   $0x0
  802a75:	6a 00                	push   $0x0
  802a77:	6a 00                	push   $0x0
  802a79:	6a 00                	push   $0x0
  802a7b:	6a 00                	push   $0x0
  802a7d:	6a 2c                	push   $0x2c
  802a7f:	e8 4a fa ff ff       	call   8024ce <syscall>
  802a84:	83 c4 18             	add    $0x18,%esp
  802a87:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  802a8a:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  802a8e:	75 07                	jne    802a97 <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  802a90:	b8 01 00 00 00       	mov    $0x1,%eax
  802a95:	eb 05                	jmp    802a9c <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  802a97:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802a9c:	c9                   	leave  
  802a9d:	c3                   	ret    

00802a9e <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  802a9e:	55                   	push   %ebp
  802a9f:	89 e5                	mov    %esp,%ebp
  802aa1:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  802aa4:	6a 00                	push   $0x0
  802aa6:	6a 00                	push   $0x0
  802aa8:	6a 00                	push   $0x0
  802aaa:	6a 00                	push   $0x0
  802aac:	6a 00                	push   $0x0
  802aae:	6a 2c                	push   $0x2c
  802ab0:	e8 19 fa ff ff       	call   8024ce <syscall>
  802ab5:	83 c4 18             	add    $0x18,%esp
  802ab8:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  802abb:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  802abf:	75 07                	jne    802ac8 <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  802ac1:	b8 01 00 00 00       	mov    $0x1,%eax
  802ac6:	eb 05                	jmp    802acd <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  802ac8:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802acd:	c9                   	leave  
  802ace:	c3                   	ret    

00802acf <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  802acf:	55                   	push   %ebp
  802ad0:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  802ad2:	6a 00                	push   $0x0
  802ad4:	6a 00                	push   $0x0
  802ad6:	6a 00                	push   $0x0
  802ad8:	6a 00                	push   $0x0
  802ada:	ff 75 08             	pushl  0x8(%ebp)
  802add:	6a 2d                	push   $0x2d
  802adf:	e8 ea f9 ff ff       	call   8024ce <syscall>
  802ae4:	83 c4 18             	add    $0x18,%esp
	return ;
  802ae7:	90                   	nop
}
  802ae8:	c9                   	leave  
  802ae9:	c3                   	ret    

00802aea <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  802aea:	55                   	push   %ebp
  802aeb:	89 e5                	mov    %esp,%ebp
  802aed:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  802aee:	8b 5d 14             	mov    0x14(%ebp),%ebx
  802af1:	8b 4d 10             	mov    0x10(%ebp),%ecx
  802af4:	8b 55 0c             	mov    0xc(%ebp),%edx
  802af7:	8b 45 08             	mov    0x8(%ebp),%eax
  802afa:	6a 00                	push   $0x0
  802afc:	53                   	push   %ebx
  802afd:	51                   	push   %ecx
  802afe:	52                   	push   %edx
  802aff:	50                   	push   %eax
  802b00:	6a 2e                	push   $0x2e
  802b02:	e8 c7 f9 ff ff       	call   8024ce <syscall>
  802b07:	83 c4 18             	add    $0x18,%esp
}
  802b0a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802b0d:	c9                   	leave  
  802b0e:	c3                   	ret    

00802b0f <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  802b0f:	55                   	push   %ebp
  802b10:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  802b12:	8b 55 0c             	mov    0xc(%ebp),%edx
  802b15:	8b 45 08             	mov    0x8(%ebp),%eax
  802b18:	6a 00                	push   $0x0
  802b1a:	6a 00                	push   $0x0
  802b1c:	6a 00                	push   $0x0
  802b1e:	52                   	push   %edx
  802b1f:	50                   	push   %eax
  802b20:	6a 2f                	push   $0x2f
  802b22:	e8 a7 f9 ff ff       	call   8024ce <syscall>
  802b27:	83 c4 18             	add    $0x18,%esp
}
  802b2a:	c9                   	leave  
  802b2b:	c3                   	ret    

00802b2c <print_mem_block_lists>:
//===========================
// PRINT MEM BLOCK LISTS:
//===========================

void print_mem_block_lists()
{
  802b2c:	55                   	push   %ebp
  802b2d:	89 e5                	mov    %esp,%ebp
  802b2f:	83 ec 18             	sub    $0x18,%esp
	cprintf("\n=========================================\n");
  802b32:	83 ec 0c             	sub    $0xc,%esp
  802b35:	68 80 45 80 00       	push   $0x804580
  802b3a:	e8 dd e6 ff ff       	call   80121c <cprintf>
  802b3f:	83 c4 10             	add    $0x10,%esp
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
  802b42:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nFreeMemBlocksList:\n");
  802b49:	83 ec 0c             	sub    $0xc,%esp
  802b4c:	68 ac 45 80 00       	push   $0x8045ac
  802b51:	e8 c6 e6 ff ff       	call   80121c <cprintf>
  802b56:	83 c4 10             	add    $0x10,%esp
	uint8 sorted = 1 ;
  802b59:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &FreeMemBlocksList)
  802b5d:	a1 38 51 80 00       	mov    0x805138,%eax
  802b62:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802b65:	eb 56                	jmp    802bbd <print_mem_block_lists+0x91>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  802b67:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802b6b:	74 1c                	je     802b89 <print_mem_block_lists+0x5d>
  802b6d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b70:	8b 50 08             	mov    0x8(%eax),%edx
  802b73:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b76:	8b 48 08             	mov    0x8(%eax),%ecx
  802b79:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b7c:	8b 40 0c             	mov    0xc(%eax),%eax
  802b7f:	01 c8                	add    %ecx,%eax
  802b81:	39 c2                	cmp    %eax,%edx
  802b83:	73 04                	jae    802b89 <print_mem_block_lists+0x5d>
			sorted = 0 ;
  802b85:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  802b89:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b8c:	8b 50 08             	mov    0x8(%eax),%edx
  802b8f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b92:	8b 40 0c             	mov    0xc(%eax),%eax
  802b95:	01 c2                	add    %eax,%edx
  802b97:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b9a:	8b 40 08             	mov    0x8(%eax),%eax
  802b9d:	83 ec 04             	sub    $0x4,%esp
  802ba0:	52                   	push   %edx
  802ba1:	50                   	push   %eax
  802ba2:	68 c1 45 80 00       	push   $0x8045c1
  802ba7:	e8 70 e6 ff ff       	call   80121c <cprintf>
  802bac:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  802baf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bb2:	89 45 f0             	mov    %eax,-0x10(%ebp)
	cprintf("\n=========================================\n");
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
	cprintf("\nFreeMemBlocksList:\n");
	uint8 sorted = 1 ;
	LIST_FOREACH(blk, &FreeMemBlocksList)
  802bb5:	a1 40 51 80 00       	mov    0x805140,%eax
  802bba:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802bbd:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802bc1:	74 07                	je     802bca <print_mem_block_lists+0x9e>
  802bc3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bc6:	8b 00                	mov    (%eax),%eax
  802bc8:	eb 05                	jmp    802bcf <print_mem_block_lists+0xa3>
  802bca:	b8 00 00 00 00       	mov    $0x0,%eax
  802bcf:	a3 40 51 80 00       	mov    %eax,0x805140
  802bd4:	a1 40 51 80 00       	mov    0x805140,%eax
  802bd9:	85 c0                	test   %eax,%eax
  802bdb:	75 8a                	jne    802b67 <print_mem_block_lists+0x3b>
  802bdd:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802be1:	75 84                	jne    802b67 <print_mem_block_lists+0x3b>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;
  802be3:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  802be7:	75 10                	jne    802bf9 <print_mem_block_lists+0xcd>
  802be9:	83 ec 0c             	sub    $0xc,%esp
  802bec:	68 d0 45 80 00       	push   $0x8045d0
  802bf1:	e8 26 e6 ff ff       	call   80121c <cprintf>
  802bf6:	83 c4 10             	add    $0x10,%esp

	lastBlk = NULL ;
  802bf9:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nAllocMemBlocksList:\n");
  802c00:	83 ec 0c             	sub    $0xc,%esp
  802c03:	68 f4 45 80 00       	push   $0x8045f4
  802c08:	e8 0f e6 ff ff       	call   80121c <cprintf>
  802c0d:	83 c4 10             	add    $0x10,%esp
	sorted = 1 ;
  802c10:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &AllocMemBlocksList)
  802c14:	a1 40 50 80 00       	mov    0x805040,%eax
  802c19:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802c1c:	eb 56                	jmp    802c74 <print_mem_block_lists+0x148>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  802c1e:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802c22:	74 1c                	je     802c40 <print_mem_block_lists+0x114>
  802c24:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c27:	8b 50 08             	mov    0x8(%eax),%edx
  802c2a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c2d:	8b 48 08             	mov    0x8(%eax),%ecx
  802c30:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c33:	8b 40 0c             	mov    0xc(%eax),%eax
  802c36:	01 c8                	add    %ecx,%eax
  802c38:	39 c2                	cmp    %eax,%edx
  802c3a:	73 04                	jae    802c40 <print_mem_block_lists+0x114>
			sorted = 0 ;
  802c3c:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  802c40:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c43:	8b 50 08             	mov    0x8(%eax),%edx
  802c46:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c49:	8b 40 0c             	mov    0xc(%eax),%eax
  802c4c:	01 c2                	add    %eax,%edx
  802c4e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c51:	8b 40 08             	mov    0x8(%eax),%eax
  802c54:	83 ec 04             	sub    $0x4,%esp
  802c57:	52                   	push   %edx
  802c58:	50                   	push   %eax
  802c59:	68 c1 45 80 00       	push   $0x8045c1
  802c5e:	e8 b9 e5 ff ff       	call   80121c <cprintf>
  802c63:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  802c66:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c69:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;

	lastBlk = NULL ;
	cprintf("\nAllocMemBlocksList:\n");
	sorted = 1 ;
	LIST_FOREACH(blk, &AllocMemBlocksList)
  802c6c:	a1 48 50 80 00       	mov    0x805048,%eax
  802c71:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802c74:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802c78:	74 07                	je     802c81 <print_mem_block_lists+0x155>
  802c7a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c7d:	8b 00                	mov    (%eax),%eax
  802c7f:	eb 05                	jmp    802c86 <print_mem_block_lists+0x15a>
  802c81:	b8 00 00 00 00       	mov    $0x0,%eax
  802c86:	a3 48 50 80 00       	mov    %eax,0x805048
  802c8b:	a1 48 50 80 00       	mov    0x805048,%eax
  802c90:	85 c0                	test   %eax,%eax
  802c92:	75 8a                	jne    802c1e <print_mem_block_lists+0xf2>
  802c94:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802c98:	75 84                	jne    802c1e <print_mem_block_lists+0xf2>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nAllocMemBlocksList is NOT SORTED!!\n") ;
  802c9a:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  802c9e:	75 10                	jne    802cb0 <print_mem_block_lists+0x184>
  802ca0:	83 ec 0c             	sub    $0xc,%esp
  802ca3:	68 0c 46 80 00       	push   $0x80460c
  802ca8:	e8 6f e5 ff ff       	call   80121c <cprintf>
  802cad:	83 c4 10             	add    $0x10,%esp
	cprintf("\n=========================================\n");
  802cb0:	83 ec 0c             	sub    $0xc,%esp
  802cb3:	68 80 45 80 00       	push   $0x804580
  802cb8:	e8 5f e5 ff ff       	call   80121c <cprintf>
  802cbd:	83 c4 10             	add    $0x10,%esp

}
  802cc0:	90                   	nop
  802cc1:	c9                   	leave  
  802cc2:	c3                   	ret    

00802cc3 <initialize_MemBlocksList>:

//===============================
// [1] INITIALIZE AVAILABLE LIST:
//===============================
void initialize_MemBlocksList(uint32 numOfBlocks)
{
  802cc3:	55                   	push   %ebp
  802cc4:	89 e5                	mov    %esp,%ebp
  802cc6:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] initialize_MemBlocksList
	// Write your code here, remove the panic and write your code
	//panic("initialize_MemBlocksList() is not implemented yet...!!");
	uint32 n = numOfBlocks;
  802cc9:	8b 45 08             	mov    0x8(%ebp),%eax
  802ccc:	89 45 f0             	mov    %eax,-0x10(%ebp)

	LIST_INIT(&AvailableMemBlocksList);
  802ccf:	c7 05 48 51 80 00 00 	movl   $0x0,0x805148
  802cd6:	00 00 00 
  802cd9:	c7 05 4c 51 80 00 00 	movl   $0x0,0x80514c
  802ce0:	00 00 00 
  802ce3:	c7 05 54 51 80 00 00 	movl   $0x0,0x805154
  802cea:	00 00 00 
	for(int i = 0; i<n;i++)
  802ced:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  802cf4:	e9 9e 00 00 00       	jmp    802d97 <initialize_MemBlocksList+0xd4>
	{
		LIST_INSERT_HEAD(&AvailableMemBlocksList, &(MemBlockNodes[i]));
  802cf9:	a1 50 50 80 00       	mov    0x805050,%eax
  802cfe:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802d01:	c1 e2 04             	shl    $0x4,%edx
  802d04:	01 d0                	add    %edx,%eax
  802d06:	85 c0                	test   %eax,%eax
  802d08:	75 14                	jne    802d1e <initialize_MemBlocksList+0x5b>
  802d0a:	83 ec 04             	sub    $0x4,%esp
  802d0d:	68 34 46 80 00       	push   $0x804634
  802d12:	6a 47                	push   $0x47
  802d14:	68 57 46 80 00       	push   $0x804657
  802d19:	e8 4a e2 ff ff       	call   800f68 <_panic>
  802d1e:	a1 50 50 80 00       	mov    0x805050,%eax
  802d23:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802d26:	c1 e2 04             	shl    $0x4,%edx
  802d29:	01 d0                	add    %edx,%eax
  802d2b:	8b 15 48 51 80 00    	mov    0x805148,%edx
  802d31:	89 10                	mov    %edx,(%eax)
  802d33:	8b 00                	mov    (%eax),%eax
  802d35:	85 c0                	test   %eax,%eax
  802d37:	74 18                	je     802d51 <initialize_MemBlocksList+0x8e>
  802d39:	a1 48 51 80 00       	mov    0x805148,%eax
  802d3e:	8b 15 50 50 80 00    	mov    0x805050,%edx
  802d44:	8b 4d f4             	mov    -0xc(%ebp),%ecx
  802d47:	c1 e1 04             	shl    $0x4,%ecx
  802d4a:	01 ca                	add    %ecx,%edx
  802d4c:	89 50 04             	mov    %edx,0x4(%eax)
  802d4f:	eb 12                	jmp    802d63 <initialize_MemBlocksList+0xa0>
  802d51:	a1 50 50 80 00       	mov    0x805050,%eax
  802d56:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802d59:	c1 e2 04             	shl    $0x4,%edx
  802d5c:	01 d0                	add    %edx,%eax
  802d5e:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802d63:	a1 50 50 80 00       	mov    0x805050,%eax
  802d68:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802d6b:	c1 e2 04             	shl    $0x4,%edx
  802d6e:	01 d0                	add    %edx,%eax
  802d70:	a3 48 51 80 00       	mov    %eax,0x805148
  802d75:	a1 50 50 80 00       	mov    0x805050,%eax
  802d7a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802d7d:	c1 e2 04             	shl    $0x4,%edx
  802d80:	01 d0                	add    %edx,%eax
  802d82:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802d89:	a1 54 51 80 00       	mov    0x805154,%eax
  802d8e:	40                   	inc    %eax
  802d8f:	a3 54 51 80 00       	mov    %eax,0x805154
	// Write your code here, remove the panic and write your code
	//panic("initialize_MemBlocksList() is not implemented yet...!!");
	uint32 n = numOfBlocks;

	LIST_INIT(&AvailableMemBlocksList);
	for(int i = 0; i<n;i++)
  802d94:	ff 45 f4             	incl   -0xc(%ebp)
  802d97:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d9a:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  802d9d:	0f 82 56 ff ff ff    	jb     802cf9 <initialize_MemBlocksList+0x36>
	{
		LIST_INSERT_HEAD(&AvailableMemBlocksList, &(MemBlockNodes[i]));
	}
}
  802da3:	90                   	nop
  802da4:	c9                   	leave  
  802da5:	c3                   	ret    

00802da6 <find_block>:

//===============================
// [2] FIND BLOCK:
//===============================
struct MemBlock *find_block(struct MemBlock_List *blockList, uint32 va)
{
  802da6:	55                   	push   %ebp
  802da7:	89 e5                	mov    %esp,%ebp
  802da9:	83 ec 10             	sub    $0x10,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] find_block
	// Write your code here, remove the panic and write your code
	//panic("find_block() is not implemented yet...!!");
	uint32 virAddress = va;
  802dac:	8b 45 0c             	mov    0xc(%ebp),%eax
  802daf:	89 45 f4             	mov    %eax,-0xc(%ebp)
	struct MemBlock* blk;
	int found = 0;
  802db2:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	LIST_FOREACH(blk, &(AllocMemBlocksList))
  802db9:	a1 40 50 80 00       	mov    0x805040,%eax
  802dbe:	89 45 fc             	mov    %eax,-0x4(%ebp)
  802dc1:	eb 23                	jmp    802de6 <find_block+0x40>
	{
		if(blk->sva == virAddress)
  802dc3:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802dc6:	8b 40 08             	mov    0x8(%eax),%eax
  802dc9:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  802dcc:	75 09                	jne    802dd7 <find_block+0x31>
		{
			found = 1;
  802dce:	c7 45 f8 01 00 00 00 	movl   $0x1,-0x8(%ebp)
			break;
  802dd5:	eb 35                	jmp    802e0c <find_block+0x66>
		}
		else
		{
			found = 0;
  802dd7:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	//panic("find_block() is not implemented yet...!!");
	uint32 virAddress = va;
	struct MemBlock* blk;
	int found = 0;

	LIST_FOREACH(blk, &(AllocMemBlocksList))
  802dde:	a1 48 50 80 00       	mov    0x805048,%eax
  802de3:	89 45 fc             	mov    %eax,-0x4(%ebp)
  802de6:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  802dea:	74 07                	je     802df3 <find_block+0x4d>
  802dec:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802def:	8b 00                	mov    (%eax),%eax
  802df1:	eb 05                	jmp    802df8 <find_block+0x52>
  802df3:	b8 00 00 00 00       	mov    $0x0,%eax
  802df8:	a3 48 50 80 00       	mov    %eax,0x805048
  802dfd:	a1 48 50 80 00       	mov    0x805048,%eax
  802e02:	85 c0                	test   %eax,%eax
  802e04:	75 bd                	jne    802dc3 <find_block+0x1d>
  802e06:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  802e0a:	75 b7                	jne    802dc3 <find_block+0x1d>
		{
			found = 0;
			continue;
		}
	}
	if(found == 1)
  802e0c:	83 7d f8 01          	cmpl   $0x1,-0x8(%ebp)
  802e10:	75 05                	jne    802e17 <find_block+0x71>
	{
		return blk;
  802e12:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802e15:	eb 05                	jmp    802e1c <find_block+0x76>
	}
	else
	{
		return NULL;
  802e17:	b8 00 00 00 00       	mov    $0x0,%eax
	}
}
  802e1c:	c9                   	leave  
  802e1d:	c3                   	ret    

00802e1e <insert_sorted_allocList>:

//=========================================
// [3] INSERT BLOCK IN ALLOC LIST [SORTED]:
//=========================================
void insert_sorted_allocList(struct MemBlock *blockToInsert)
{
  802e1e:	55                   	push   %ebp
  802e1f:	89 e5                	mov    %esp,%ebp
  802e21:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] insert_sorted_allocList
	// Write your code here, remove the panic and write your code
	//panic("insert_sorted_allocList() is not implemented yet...!!");
	struct MemBlock* blk;
	struct MemBlock* newblk = blockToInsert;
  802e24:	8b 45 08             	mov    0x8(%ebp),%eax
  802e27:	89 45 f0             	mov    %eax,-0x10(%ebp)

	if((LIST_EMPTY(&AllocMemBlocksList)) || (newblk->sva < LIST_FIRST(&AllocMemBlocksList)->sva))
  802e2a:	a1 40 50 80 00       	mov    0x805040,%eax
  802e2f:	85 c0                	test   %eax,%eax
  802e31:	74 12                	je     802e45 <insert_sorted_allocList+0x27>
  802e33:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e36:	8b 50 08             	mov    0x8(%eax),%edx
  802e39:	a1 40 50 80 00       	mov    0x805040,%eax
  802e3e:	8b 40 08             	mov    0x8(%eax),%eax
  802e41:	39 c2                	cmp    %eax,%edx
  802e43:	73 65                	jae    802eaa <insert_sorted_allocList+0x8c>
	{
		LIST_INSERT_HEAD(&(AllocMemBlocksList), newblk);
  802e45:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802e49:	75 14                	jne    802e5f <insert_sorted_allocList+0x41>
  802e4b:	83 ec 04             	sub    $0x4,%esp
  802e4e:	68 34 46 80 00       	push   $0x804634
  802e53:	6a 7b                	push   $0x7b
  802e55:	68 57 46 80 00       	push   $0x804657
  802e5a:	e8 09 e1 ff ff       	call   800f68 <_panic>
  802e5f:	8b 15 40 50 80 00    	mov    0x805040,%edx
  802e65:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e68:	89 10                	mov    %edx,(%eax)
  802e6a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e6d:	8b 00                	mov    (%eax),%eax
  802e6f:	85 c0                	test   %eax,%eax
  802e71:	74 0d                	je     802e80 <insert_sorted_allocList+0x62>
  802e73:	a1 40 50 80 00       	mov    0x805040,%eax
  802e78:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802e7b:	89 50 04             	mov    %edx,0x4(%eax)
  802e7e:	eb 08                	jmp    802e88 <insert_sorted_allocList+0x6a>
  802e80:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e83:	a3 44 50 80 00       	mov    %eax,0x805044
  802e88:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e8b:	a3 40 50 80 00       	mov    %eax,0x805040
  802e90:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e93:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802e9a:	a1 4c 50 80 00       	mov    0x80504c,%eax
  802e9f:	40                   	inc    %eax
  802ea0:	a3 4c 50 80 00       	mov    %eax,0x80504c
  802ea5:	e9 5f 01 00 00       	jmp    803009 <insert_sorted_allocList+0x1eb>
	}
	else if(newblk->sva > LIST_LAST(&AllocMemBlocksList)->sva)
  802eaa:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ead:	8b 50 08             	mov    0x8(%eax),%edx
  802eb0:	a1 44 50 80 00       	mov    0x805044,%eax
  802eb5:	8b 40 08             	mov    0x8(%eax),%eax
  802eb8:	39 c2                	cmp    %eax,%edx
  802eba:	76 65                	jbe    802f21 <insert_sorted_allocList+0x103>
	{
		LIST_INSERT_TAIL(&AllocMemBlocksList, newblk);
  802ebc:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802ec0:	75 14                	jne    802ed6 <insert_sorted_allocList+0xb8>
  802ec2:	83 ec 04             	sub    $0x4,%esp
  802ec5:	68 70 46 80 00       	push   $0x804670
  802eca:	6a 7f                	push   $0x7f
  802ecc:	68 57 46 80 00       	push   $0x804657
  802ed1:	e8 92 e0 ff ff       	call   800f68 <_panic>
  802ed6:	8b 15 44 50 80 00    	mov    0x805044,%edx
  802edc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802edf:	89 50 04             	mov    %edx,0x4(%eax)
  802ee2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ee5:	8b 40 04             	mov    0x4(%eax),%eax
  802ee8:	85 c0                	test   %eax,%eax
  802eea:	74 0c                	je     802ef8 <insert_sorted_allocList+0xda>
  802eec:	a1 44 50 80 00       	mov    0x805044,%eax
  802ef1:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802ef4:	89 10                	mov    %edx,(%eax)
  802ef6:	eb 08                	jmp    802f00 <insert_sorted_allocList+0xe2>
  802ef8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802efb:	a3 40 50 80 00       	mov    %eax,0x805040
  802f00:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802f03:	a3 44 50 80 00       	mov    %eax,0x805044
  802f08:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802f0b:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802f11:	a1 4c 50 80 00       	mov    0x80504c,%eax
  802f16:	40                   	inc    %eax
  802f17:	a3 4c 50 80 00       	mov    %eax,0x80504c
				LIST_INSERT_AFTER(&AllocMemBlocksList, blk, newblk);
				break;
			}
		}
	}
}
  802f1c:	e9 e8 00 00 00       	jmp    803009 <insert_sorted_allocList+0x1eb>
	{
		LIST_INSERT_TAIL(&AllocMemBlocksList, newblk);
	}
	else
	{
		LIST_FOREACH(blk, &AllocMemBlocksList)
  802f21:	a1 40 50 80 00       	mov    0x805040,%eax
  802f26:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802f29:	e9 ab 00 00 00       	jmp    802fd9 <insert_sorted_allocList+0x1bb>
		{
			if(blk->prev_next_info.le_next != NULL && newblk->sva > blk->sva  && newblk->sva < blk->prev_next_info.le_next->sva)
  802f2e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f31:	8b 00                	mov    (%eax),%eax
  802f33:	85 c0                	test   %eax,%eax
  802f35:	0f 84 96 00 00 00    	je     802fd1 <insert_sorted_allocList+0x1b3>
  802f3b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802f3e:	8b 50 08             	mov    0x8(%eax),%edx
  802f41:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f44:	8b 40 08             	mov    0x8(%eax),%eax
  802f47:	39 c2                	cmp    %eax,%edx
  802f49:	0f 86 82 00 00 00    	jbe    802fd1 <insert_sorted_allocList+0x1b3>
  802f4f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802f52:	8b 50 08             	mov    0x8(%eax),%edx
  802f55:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f58:	8b 00                	mov    (%eax),%eax
  802f5a:	8b 40 08             	mov    0x8(%eax),%eax
  802f5d:	39 c2                	cmp    %eax,%edx
  802f5f:	73 70                	jae    802fd1 <insert_sorted_allocList+0x1b3>
			{
				LIST_INSERT_AFTER(&AllocMemBlocksList, blk, newblk);
  802f61:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802f65:	74 06                	je     802f6d <insert_sorted_allocList+0x14f>
  802f67:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802f6b:	75 17                	jne    802f84 <insert_sorted_allocList+0x166>
  802f6d:	83 ec 04             	sub    $0x4,%esp
  802f70:	68 94 46 80 00       	push   $0x804694
  802f75:	68 87 00 00 00       	push   $0x87
  802f7a:	68 57 46 80 00       	push   $0x804657
  802f7f:	e8 e4 df ff ff       	call   800f68 <_panic>
  802f84:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f87:	8b 10                	mov    (%eax),%edx
  802f89:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802f8c:	89 10                	mov    %edx,(%eax)
  802f8e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802f91:	8b 00                	mov    (%eax),%eax
  802f93:	85 c0                	test   %eax,%eax
  802f95:	74 0b                	je     802fa2 <insert_sorted_allocList+0x184>
  802f97:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f9a:	8b 00                	mov    (%eax),%eax
  802f9c:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802f9f:	89 50 04             	mov    %edx,0x4(%eax)
  802fa2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802fa5:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802fa8:	89 10                	mov    %edx,(%eax)
  802faa:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802fad:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802fb0:	89 50 04             	mov    %edx,0x4(%eax)
  802fb3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802fb6:	8b 00                	mov    (%eax),%eax
  802fb8:	85 c0                	test   %eax,%eax
  802fba:	75 08                	jne    802fc4 <insert_sorted_allocList+0x1a6>
  802fbc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802fbf:	a3 44 50 80 00       	mov    %eax,0x805044
  802fc4:	a1 4c 50 80 00       	mov    0x80504c,%eax
  802fc9:	40                   	inc    %eax
  802fca:	a3 4c 50 80 00       	mov    %eax,0x80504c
				break;
  802fcf:	eb 38                	jmp    803009 <insert_sorted_allocList+0x1eb>
	{
		LIST_INSERT_TAIL(&AllocMemBlocksList, newblk);
	}
	else
	{
		LIST_FOREACH(blk, &AllocMemBlocksList)
  802fd1:	a1 48 50 80 00       	mov    0x805048,%eax
  802fd6:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802fd9:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802fdd:	74 07                	je     802fe6 <insert_sorted_allocList+0x1c8>
  802fdf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802fe2:	8b 00                	mov    (%eax),%eax
  802fe4:	eb 05                	jmp    802feb <insert_sorted_allocList+0x1cd>
  802fe6:	b8 00 00 00 00       	mov    $0x0,%eax
  802feb:	a3 48 50 80 00       	mov    %eax,0x805048
  802ff0:	a1 48 50 80 00       	mov    0x805048,%eax
  802ff5:	85 c0                	test   %eax,%eax
  802ff7:	0f 85 31 ff ff ff    	jne    802f2e <insert_sorted_allocList+0x110>
  802ffd:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803001:	0f 85 27 ff ff ff    	jne    802f2e <insert_sorted_allocList+0x110>
				LIST_INSERT_AFTER(&AllocMemBlocksList, blk, newblk);
				break;
			}
		}
	}
}
  803007:	eb 00                	jmp    803009 <insert_sorted_allocList+0x1eb>
  803009:	90                   	nop
  80300a:	c9                   	leave  
  80300b:	c3                   	ret    

0080300c <alloc_block_FF>:

//=========================================
// [4] ALLOCATE BLOCK BY FIRST FIT:
//=========================================
struct MemBlock *alloc_block_FF(uint32 size)
{
  80300c:	55                   	push   %ebp
  80300d:	89 e5                	mov    %esp,%ebp
  80300f:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_FF
	// Write your code here, remove the panic and write your code
	//panic("alloc_block_FF() is not implemented yet...!!");
	uint32 versize = size;
  803012:	8b 45 08             	mov    0x8(%ebp),%eax
  803015:	89 45 f0             	mov    %eax,-0x10(%ebp)
	struct MemBlock* blk;
	struct MemBlock* newblk = LIST_FIRST(&AvailableMemBlocksList);
  803018:	a1 48 51 80 00       	mov    0x805148,%eax
  80301d:	89 45 ec             	mov    %eax,-0x14(%ebp)

	LIST_FOREACH(blk,&FreeMemBlocksList)
  803020:	a1 38 51 80 00       	mov    0x805138,%eax
  803025:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803028:	e9 77 01 00 00       	jmp    8031a4 <alloc_block_FF+0x198>
	{
		if(blk->size == versize)
  80302d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803030:	8b 40 0c             	mov    0xc(%eax),%eax
  803033:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  803036:	0f 85 8a 00 00 00    	jne    8030c6 <alloc_block_FF+0xba>
		{
			LIST_REMOVE(&FreeMemBlocksList,blk);
  80303c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803040:	75 17                	jne    803059 <alloc_block_FF+0x4d>
  803042:	83 ec 04             	sub    $0x4,%esp
  803045:	68 c8 46 80 00       	push   $0x8046c8
  80304a:	68 9e 00 00 00       	push   $0x9e
  80304f:	68 57 46 80 00       	push   $0x804657
  803054:	e8 0f df ff ff       	call   800f68 <_panic>
  803059:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80305c:	8b 00                	mov    (%eax),%eax
  80305e:	85 c0                	test   %eax,%eax
  803060:	74 10                	je     803072 <alloc_block_FF+0x66>
  803062:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803065:	8b 00                	mov    (%eax),%eax
  803067:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80306a:	8b 52 04             	mov    0x4(%edx),%edx
  80306d:	89 50 04             	mov    %edx,0x4(%eax)
  803070:	eb 0b                	jmp    80307d <alloc_block_FF+0x71>
  803072:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803075:	8b 40 04             	mov    0x4(%eax),%eax
  803078:	a3 3c 51 80 00       	mov    %eax,0x80513c
  80307d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803080:	8b 40 04             	mov    0x4(%eax),%eax
  803083:	85 c0                	test   %eax,%eax
  803085:	74 0f                	je     803096 <alloc_block_FF+0x8a>
  803087:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80308a:	8b 40 04             	mov    0x4(%eax),%eax
  80308d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803090:	8b 12                	mov    (%edx),%edx
  803092:	89 10                	mov    %edx,(%eax)
  803094:	eb 0a                	jmp    8030a0 <alloc_block_FF+0x94>
  803096:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803099:	8b 00                	mov    (%eax),%eax
  80309b:	a3 38 51 80 00       	mov    %eax,0x805138
  8030a0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030a3:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8030a9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030ac:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8030b3:	a1 44 51 80 00       	mov    0x805144,%eax
  8030b8:	48                   	dec    %eax
  8030b9:	a3 44 51 80 00       	mov    %eax,0x805144
			return blk;
  8030be:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030c1:	e9 11 01 00 00       	jmp    8031d7 <alloc_block_FF+0x1cb>
		}
		else if(blk->size > versize)
  8030c6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030c9:	8b 40 0c             	mov    0xc(%eax),%eax
  8030cc:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8030cf:	0f 86 c7 00 00 00    	jbe    80319c <alloc_block_FF+0x190>
		{
			LIST_REMOVE(&AvailableMemBlocksList,newblk);
  8030d5:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8030d9:	75 17                	jne    8030f2 <alloc_block_FF+0xe6>
  8030db:	83 ec 04             	sub    $0x4,%esp
  8030de:	68 c8 46 80 00       	push   $0x8046c8
  8030e3:	68 a3 00 00 00       	push   $0xa3
  8030e8:	68 57 46 80 00       	push   $0x804657
  8030ed:	e8 76 de ff ff       	call   800f68 <_panic>
  8030f2:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8030f5:	8b 00                	mov    (%eax),%eax
  8030f7:	85 c0                	test   %eax,%eax
  8030f9:	74 10                	je     80310b <alloc_block_FF+0xff>
  8030fb:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8030fe:	8b 00                	mov    (%eax),%eax
  803100:	8b 55 ec             	mov    -0x14(%ebp),%edx
  803103:	8b 52 04             	mov    0x4(%edx),%edx
  803106:	89 50 04             	mov    %edx,0x4(%eax)
  803109:	eb 0b                	jmp    803116 <alloc_block_FF+0x10a>
  80310b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80310e:	8b 40 04             	mov    0x4(%eax),%eax
  803111:	a3 4c 51 80 00       	mov    %eax,0x80514c
  803116:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803119:	8b 40 04             	mov    0x4(%eax),%eax
  80311c:	85 c0                	test   %eax,%eax
  80311e:	74 0f                	je     80312f <alloc_block_FF+0x123>
  803120:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803123:	8b 40 04             	mov    0x4(%eax),%eax
  803126:	8b 55 ec             	mov    -0x14(%ebp),%edx
  803129:	8b 12                	mov    (%edx),%edx
  80312b:	89 10                	mov    %edx,(%eax)
  80312d:	eb 0a                	jmp    803139 <alloc_block_FF+0x12d>
  80312f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803132:	8b 00                	mov    (%eax),%eax
  803134:	a3 48 51 80 00       	mov    %eax,0x805148
  803139:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80313c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803142:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803145:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80314c:	a1 54 51 80 00       	mov    0x805154,%eax
  803151:	48                   	dec    %eax
  803152:	a3 54 51 80 00       	mov    %eax,0x805154
			newblk->size = versize;
  803157:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80315a:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80315d:	89 50 0c             	mov    %edx,0xc(%eax)
			blk->size = blk->size-versize;
  803160:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803163:	8b 40 0c             	mov    0xc(%eax),%eax
  803166:	2b 45 f0             	sub    -0x10(%ebp),%eax
  803169:	89 c2                	mov    %eax,%edx
  80316b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80316e:	89 50 0c             	mov    %edx,0xc(%eax)
			uint32 newveradd = blk->sva;
  803171:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803174:	8b 40 08             	mov    0x8(%eax),%eax
  803177:	89 45 e8             	mov    %eax,-0x18(%ebp)
			blk->sva+=newblk->size;
  80317a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80317d:	8b 50 08             	mov    0x8(%eax),%edx
  803180:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803183:	8b 40 0c             	mov    0xc(%eax),%eax
  803186:	01 c2                	add    %eax,%edx
  803188:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80318b:	89 50 08             	mov    %edx,0x8(%eax)
			newblk->sva = newveradd;
  80318e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803191:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803194:	89 50 08             	mov    %edx,0x8(%eax)
			return newblk;
  803197:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80319a:	eb 3b                	jmp    8031d7 <alloc_block_FF+0x1cb>
	//panic("alloc_block_FF() is not implemented yet...!!");
	uint32 versize = size;
	struct MemBlock* blk;
	struct MemBlock* newblk = LIST_FIRST(&AvailableMemBlocksList);

	LIST_FOREACH(blk,&FreeMemBlocksList)
  80319c:	a1 40 51 80 00       	mov    0x805140,%eax
  8031a1:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8031a4:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8031a8:	74 07                	je     8031b1 <alloc_block_FF+0x1a5>
  8031aa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8031ad:	8b 00                	mov    (%eax),%eax
  8031af:	eb 05                	jmp    8031b6 <alloc_block_FF+0x1aa>
  8031b1:	b8 00 00 00 00       	mov    $0x0,%eax
  8031b6:	a3 40 51 80 00       	mov    %eax,0x805140
  8031bb:	a1 40 51 80 00       	mov    0x805140,%eax
  8031c0:	85 c0                	test   %eax,%eax
  8031c2:	0f 85 65 fe ff ff    	jne    80302d <alloc_block_FF+0x21>
  8031c8:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8031cc:	0f 85 5b fe ff ff    	jne    80302d <alloc_block_FF+0x21>
			blk->sva+=newblk->size;
			newblk->sva = newveradd;
			return newblk;
		}
	}
	return NULL;
  8031d2:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8031d7:	c9                   	leave  
  8031d8:	c3                   	ret    

008031d9 <alloc_block_BF>:

//=========================================
// [5] ALLOCATE BLOCK BY BEST FIT:
//=========================================
struct MemBlock *alloc_block_BF(uint32 size)
{
  8031d9:	55                   	push   %ebp
  8031da:	89 e5                	mov    %esp,%ebp
  8031dc:	83 ec 28             	sub    $0x28,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_BF
	// Write your code here, remove the panic and write your code
	//panic("alloc_block_BF() is not implemented yet...!!");
	uint32 versize=size;
  8031df:	8b 45 08             	mov    0x8(%ebp),%eax
  8031e2:	89 45 e8             	mov    %eax,-0x18(%ebp)
	struct MemBlock* blk;
	struct MemBlock* newblk=LIST_FIRST(&AvailableMemBlocksList);
  8031e5:	a1 48 51 80 00       	mov    0x805148,%eax
  8031ea:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	uint32 newveradd;
	uint32 newsize;
	int size_free = LIST_SIZE(&FreeMemBlocksList);
  8031ed:	a1 44 51 80 00       	mov    0x805144,%eax
  8031f2:	89 45 e0             	mov    %eax,-0x20(%ebp)

	LIST_FOREACH(blk, &FreeMemBlocksList)
  8031f5:	a1 38 51 80 00       	mov    0x805138,%eax
  8031fa:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8031fd:	e9 a1 00 00 00       	jmp    8032a3 <alloc_block_BF+0xca>
	{
		if(blk->size == versize)
  803202:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803205:	8b 40 0c             	mov    0xc(%eax),%eax
  803208:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  80320b:	0f 85 8a 00 00 00    	jne    80329b <alloc_block_BF+0xc2>
		{
			LIST_REMOVE(&FreeMemBlocksList, blk);
  803211:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803215:	75 17                	jne    80322e <alloc_block_BF+0x55>
  803217:	83 ec 04             	sub    $0x4,%esp
  80321a:	68 c8 46 80 00       	push   $0x8046c8
  80321f:	68 c2 00 00 00       	push   $0xc2
  803224:	68 57 46 80 00       	push   $0x804657
  803229:	e8 3a dd ff ff       	call   800f68 <_panic>
  80322e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803231:	8b 00                	mov    (%eax),%eax
  803233:	85 c0                	test   %eax,%eax
  803235:	74 10                	je     803247 <alloc_block_BF+0x6e>
  803237:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80323a:	8b 00                	mov    (%eax),%eax
  80323c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80323f:	8b 52 04             	mov    0x4(%edx),%edx
  803242:	89 50 04             	mov    %edx,0x4(%eax)
  803245:	eb 0b                	jmp    803252 <alloc_block_BF+0x79>
  803247:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80324a:	8b 40 04             	mov    0x4(%eax),%eax
  80324d:	a3 3c 51 80 00       	mov    %eax,0x80513c
  803252:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803255:	8b 40 04             	mov    0x4(%eax),%eax
  803258:	85 c0                	test   %eax,%eax
  80325a:	74 0f                	je     80326b <alloc_block_BF+0x92>
  80325c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80325f:	8b 40 04             	mov    0x4(%eax),%eax
  803262:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803265:	8b 12                	mov    (%edx),%edx
  803267:	89 10                	mov    %edx,(%eax)
  803269:	eb 0a                	jmp    803275 <alloc_block_BF+0x9c>
  80326b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80326e:	8b 00                	mov    (%eax),%eax
  803270:	a3 38 51 80 00       	mov    %eax,0x805138
  803275:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803278:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80327e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803281:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803288:	a1 44 51 80 00       	mov    0x805144,%eax
  80328d:	48                   	dec    %eax
  80328e:	a3 44 51 80 00       	mov    %eax,0x805144
			return blk;
  803293:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803296:	e9 11 02 00 00       	jmp    8034ac <alloc_block_BF+0x2d3>
	struct MemBlock* newblk=LIST_FIRST(&AvailableMemBlocksList);
	uint32 newveradd;
	uint32 newsize;
	int size_free = LIST_SIZE(&FreeMemBlocksList);

	LIST_FOREACH(blk, &FreeMemBlocksList)
  80329b:	a1 40 51 80 00       	mov    0x805140,%eax
  8032a0:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8032a3:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8032a7:	74 07                	je     8032b0 <alloc_block_BF+0xd7>
  8032a9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8032ac:	8b 00                	mov    (%eax),%eax
  8032ae:	eb 05                	jmp    8032b5 <alloc_block_BF+0xdc>
  8032b0:	b8 00 00 00 00       	mov    $0x0,%eax
  8032b5:	a3 40 51 80 00       	mov    %eax,0x805140
  8032ba:	a1 40 51 80 00       	mov    0x805140,%eax
  8032bf:	85 c0                	test   %eax,%eax
  8032c1:	0f 85 3b ff ff ff    	jne    803202 <alloc_block_BF+0x29>
  8032c7:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8032cb:	0f 85 31 ff ff ff    	jne    803202 <alloc_block_BF+0x29>
		{
			LIST_REMOVE(&FreeMemBlocksList, blk);
			return blk;
		}
	}
	LIST_FOREACH(blk, &FreeMemBlocksList)
  8032d1:	a1 38 51 80 00       	mov    0x805138,%eax
  8032d6:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8032d9:	eb 27                	jmp    803302 <alloc_block_BF+0x129>
	{
		if(blk->size > versize)
  8032db:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8032de:	8b 40 0c             	mov    0xc(%eax),%eax
  8032e1:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  8032e4:	76 14                	jbe    8032fa <alloc_block_BF+0x121>
		{
			newsize = blk->size;
  8032e6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8032e9:	8b 40 0c             	mov    0xc(%eax),%eax
  8032ec:	89 45 ec             	mov    %eax,-0x14(%ebp)
			newveradd = blk->sva;
  8032ef:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8032f2:	8b 40 08             	mov    0x8(%eax),%eax
  8032f5:	89 45 f0             	mov    %eax,-0x10(%ebp)
			break;
  8032f8:	eb 2e                	jmp    803328 <alloc_block_BF+0x14f>
		{
			LIST_REMOVE(&FreeMemBlocksList, blk);
			return blk;
		}
	}
	LIST_FOREACH(blk, &FreeMemBlocksList)
  8032fa:	a1 40 51 80 00       	mov    0x805140,%eax
  8032ff:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803302:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803306:	74 07                	je     80330f <alloc_block_BF+0x136>
  803308:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80330b:	8b 00                	mov    (%eax),%eax
  80330d:	eb 05                	jmp    803314 <alloc_block_BF+0x13b>
  80330f:	b8 00 00 00 00       	mov    $0x0,%eax
  803314:	a3 40 51 80 00       	mov    %eax,0x805140
  803319:	a1 40 51 80 00       	mov    0x805140,%eax
  80331e:	85 c0                	test   %eax,%eax
  803320:	75 b9                	jne    8032db <alloc_block_BF+0x102>
  803322:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803326:	75 b3                	jne    8032db <alloc_block_BF+0x102>
			newsize = blk->size;
			newveradd = blk->sva;
			break;
		}
	}
	LIST_FOREACH(blk, &FreeMemBlocksList)
  803328:	a1 38 51 80 00       	mov    0x805138,%eax
  80332d:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803330:	eb 30                	jmp    803362 <alloc_block_BF+0x189>
	{
		if(newsize > blk->size && blk->size > versize)
  803332:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803335:	8b 40 0c             	mov    0xc(%eax),%eax
  803338:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  80333b:	73 1d                	jae    80335a <alloc_block_BF+0x181>
  80333d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803340:	8b 40 0c             	mov    0xc(%eax),%eax
  803343:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  803346:	76 12                	jbe    80335a <alloc_block_BF+0x181>
		{
	       newsize = blk->size;
  803348:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80334b:	8b 40 0c             	mov    0xc(%eax),%eax
  80334e:	89 45 ec             	mov    %eax,-0x14(%ebp)
		   newveradd = blk->sva;
  803351:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803354:	8b 40 08             	mov    0x8(%eax),%eax
  803357:	89 45 f0             	mov    %eax,-0x10(%ebp)
			newsize = blk->size;
			newveradd = blk->sva;
			break;
		}
	}
	LIST_FOREACH(blk, &FreeMemBlocksList)
  80335a:	a1 40 51 80 00       	mov    0x805140,%eax
  80335f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803362:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803366:	74 07                	je     80336f <alloc_block_BF+0x196>
  803368:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80336b:	8b 00                	mov    (%eax),%eax
  80336d:	eb 05                	jmp    803374 <alloc_block_BF+0x19b>
  80336f:	b8 00 00 00 00       	mov    $0x0,%eax
  803374:	a3 40 51 80 00       	mov    %eax,0x805140
  803379:	a1 40 51 80 00       	mov    0x805140,%eax
  80337e:	85 c0                	test   %eax,%eax
  803380:	75 b0                	jne    803332 <alloc_block_BF+0x159>
  803382:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803386:	75 aa                	jne    803332 <alloc_block_BF+0x159>
		{
	       newsize = blk->size;
		   newveradd = blk->sva;
		}
	}
	LIST_FOREACH(blk, &FreeMemBlocksList)
  803388:	a1 38 51 80 00       	mov    0x805138,%eax
  80338d:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803390:	e9 e4 00 00 00       	jmp    803479 <alloc_block_BF+0x2a0>
	{
		if(blk->size == newsize && blk->sva == newveradd)
  803395:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803398:	8b 40 0c             	mov    0xc(%eax),%eax
  80339b:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  80339e:	0f 85 cd 00 00 00    	jne    803471 <alloc_block_BF+0x298>
  8033a4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8033a7:	8b 40 08             	mov    0x8(%eax),%eax
  8033aa:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8033ad:	0f 85 be 00 00 00    	jne    803471 <alloc_block_BF+0x298>
		{
			LIST_REMOVE(&AvailableMemBlocksList, newblk);
  8033b3:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8033b7:	75 17                	jne    8033d0 <alloc_block_BF+0x1f7>
  8033b9:	83 ec 04             	sub    $0x4,%esp
  8033bc:	68 c8 46 80 00       	push   $0x8046c8
  8033c1:	68 db 00 00 00       	push   $0xdb
  8033c6:	68 57 46 80 00       	push   $0x804657
  8033cb:	e8 98 db ff ff       	call   800f68 <_panic>
  8033d0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8033d3:	8b 00                	mov    (%eax),%eax
  8033d5:	85 c0                	test   %eax,%eax
  8033d7:	74 10                	je     8033e9 <alloc_block_BF+0x210>
  8033d9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8033dc:	8b 00                	mov    (%eax),%eax
  8033de:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8033e1:	8b 52 04             	mov    0x4(%edx),%edx
  8033e4:	89 50 04             	mov    %edx,0x4(%eax)
  8033e7:	eb 0b                	jmp    8033f4 <alloc_block_BF+0x21b>
  8033e9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8033ec:	8b 40 04             	mov    0x4(%eax),%eax
  8033ef:	a3 4c 51 80 00       	mov    %eax,0x80514c
  8033f4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8033f7:	8b 40 04             	mov    0x4(%eax),%eax
  8033fa:	85 c0                	test   %eax,%eax
  8033fc:	74 0f                	je     80340d <alloc_block_BF+0x234>
  8033fe:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803401:	8b 40 04             	mov    0x4(%eax),%eax
  803404:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803407:	8b 12                	mov    (%edx),%edx
  803409:	89 10                	mov    %edx,(%eax)
  80340b:	eb 0a                	jmp    803417 <alloc_block_BF+0x23e>
  80340d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803410:	8b 00                	mov    (%eax),%eax
  803412:	a3 48 51 80 00       	mov    %eax,0x805148
  803417:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80341a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803420:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803423:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80342a:	a1 54 51 80 00       	mov    0x805154,%eax
  80342f:	48                   	dec    %eax
  803430:	a3 54 51 80 00       	mov    %eax,0x805154
			newblk->size = versize;
  803435:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803438:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80343b:	89 50 0c             	mov    %edx,0xc(%eax)
			newblk->sva = newveradd;
  80343e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803441:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803444:	89 50 08             	mov    %edx,0x8(%eax)
			blk->size = blk->size - versize;
  803447:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80344a:	8b 40 0c             	mov    0xc(%eax),%eax
  80344d:	2b 45 e8             	sub    -0x18(%ebp),%eax
  803450:	89 c2                	mov    %eax,%edx
  803452:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803455:	89 50 0c             	mov    %edx,0xc(%eax)
			blk->sva+= newblk->size;
  803458:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80345b:	8b 50 08             	mov    0x8(%eax),%edx
  80345e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803461:	8b 40 0c             	mov    0xc(%eax),%eax
  803464:	01 c2                	add    %eax,%edx
  803466:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803469:	89 50 08             	mov    %edx,0x8(%eax)
			return newblk;
  80346c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80346f:	eb 3b                	jmp    8034ac <alloc_block_BF+0x2d3>
		{
	       newsize = blk->size;
		   newveradd = blk->sva;
		}
	}
	LIST_FOREACH(blk, &FreeMemBlocksList)
  803471:	a1 40 51 80 00       	mov    0x805140,%eax
  803476:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803479:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80347d:	74 07                	je     803486 <alloc_block_BF+0x2ad>
  80347f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803482:	8b 00                	mov    (%eax),%eax
  803484:	eb 05                	jmp    80348b <alloc_block_BF+0x2b2>
  803486:	b8 00 00 00 00       	mov    $0x0,%eax
  80348b:	a3 40 51 80 00       	mov    %eax,0x805140
  803490:	a1 40 51 80 00       	mov    0x805140,%eax
  803495:	85 c0                	test   %eax,%eax
  803497:	0f 85 f8 fe ff ff    	jne    803395 <alloc_block_BF+0x1bc>
  80349d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8034a1:	0f 85 ee fe ff ff    	jne    803395 <alloc_block_BF+0x1bc>
			blk->size = blk->size - versize;
			blk->sva+= newblk->size;
			return newblk;
		}
	}
	return NULL;
  8034a7:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8034ac:	c9                   	leave  
  8034ad:	c3                   	ret    

008034ae <alloc_block_NF>:
//=========================================
// [7] ALLOCATE BLOCK BY NEXT FIT:
//=========================================
struct MemBlock *last_allocate;
struct MemBlock *alloc_block_NF(uint32 size)
{
  8034ae:	55                   	push   %ebp
  8034af:	89 e5                	mov    %esp,%ebp
  8034b1:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1 - BONUS] [DYNAMIC ALLOCATOR] alloc_block_NF
	// Write your code here, remove the panic and write your code
	//panic("alloc_block_NF() is not implemented yet...!!");
	uint32 versize = size;
  8034b4:	8b 45 08             	mov    0x8(%ebp),%eax
  8034b7:	89 45 f0             	mov    %eax,-0x10(%ebp)
	struct MemBlock* blk;
	struct MemBlock* newblk = LIST_FIRST(&AvailableMemBlocksList);
  8034ba:	a1 48 51 80 00       	mov    0x805148,%eax
  8034bf:	89 45 ec             	mov    %eax,-0x14(%ebp)

	LIST_FOREACH(blk,&FreeMemBlocksList)
  8034c2:	a1 38 51 80 00       	mov    0x805138,%eax
  8034c7:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8034ca:	e9 77 01 00 00       	jmp    803646 <alloc_block_NF+0x198>
	{
		if(blk->size == versize)
  8034cf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8034d2:	8b 40 0c             	mov    0xc(%eax),%eax
  8034d5:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8034d8:	0f 85 8a 00 00 00    	jne    803568 <alloc_block_NF+0xba>
		{
			LIST_REMOVE(&FreeMemBlocksList,blk);
  8034de:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8034e2:	75 17                	jne    8034fb <alloc_block_NF+0x4d>
  8034e4:	83 ec 04             	sub    $0x4,%esp
  8034e7:	68 c8 46 80 00       	push   $0x8046c8
  8034ec:	68 f7 00 00 00       	push   $0xf7
  8034f1:	68 57 46 80 00       	push   $0x804657
  8034f6:	e8 6d da ff ff       	call   800f68 <_panic>
  8034fb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8034fe:	8b 00                	mov    (%eax),%eax
  803500:	85 c0                	test   %eax,%eax
  803502:	74 10                	je     803514 <alloc_block_NF+0x66>
  803504:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803507:	8b 00                	mov    (%eax),%eax
  803509:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80350c:	8b 52 04             	mov    0x4(%edx),%edx
  80350f:	89 50 04             	mov    %edx,0x4(%eax)
  803512:	eb 0b                	jmp    80351f <alloc_block_NF+0x71>
  803514:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803517:	8b 40 04             	mov    0x4(%eax),%eax
  80351a:	a3 3c 51 80 00       	mov    %eax,0x80513c
  80351f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803522:	8b 40 04             	mov    0x4(%eax),%eax
  803525:	85 c0                	test   %eax,%eax
  803527:	74 0f                	je     803538 <alloc_block_NF+0x8a>
  803529:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80352c:	8b 40 04             	mov    0x4(%eax),%eax
  80352f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803532:	8b 12                	mov    (%edx),%edx
  803534:	89 10                	mov    %edx,(%eax)
  803536:	eb 0a                	jmp    803542 <alloc_block_NF+0x94>
  803538:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80353b:	8b 00                	mov    (%eax),%eax
  80353d:	a3 38 51 80 00       	mov    %eax,0x805138
  803542:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803545:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80354b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80354e:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803555:	a1 44 51 80 00       	mov    0x805144,%eax
  80355a:	48                   	dec    %eax
  80355b:	a3 44 51 80 00       	mov    %eax,0x805144
			return blk;
  803560:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803563:	e9 11 01 00 00       	jmp    803679 <alloc_block_NF+0x1cb>
		}
		else if(blk->size > versize)
  803568:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80356b:	8b 40 0c             	mov    0xc(%eax),%eax
  80356e:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  803571:	0f 86 c7 00 00 00    	jbe    80363e <alloc_block_NF+0x190>
		{
			LIST_REMOVE(&AvailableMemBlocksList,newblk);
  803577:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  80357b:	75 17                	jne    803594 <alloc_block_NF+0xe6>
  80357d:	83 ec 04             	sub    $0x4,%esp
  803580:	68 c8 46 80 00       	push   $0x8046c8
  803585:	68 fc 00 00 00       	push   $0xfc
  80358a:	68 57 46 80 00       	push   $0x804657
  80358f:	e8 d4 d9 ff ff       	call   800f68 <_panic>
  803594:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803597:	8b 00                	mov    (%eax),%eax
  803599:	85 c0                	test   %eax,%eax
  80359b:	74 10                	je     8035ad <alloc_block_NF+0xff>
  80359d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8035a0:	8b 00                	mov    (%eax),%eax
  8035a2:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8035a5:	8b 52 04             	mov    0x4(%edx),%edx
  8035a8:	89 50 04             	mov    %edx,0x4(%eax)
  8035ab:	eb 0b                	jmp    8035b8 <alloc_block_NF+0x10a>
  8035ad:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8035b0:	8b 40 04             	mov    0x4(%eax),%eax
  8035b3:	a3 4c 51 80 00       	mov    %eax,0x80514c
  8035b8:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8035bb:	8b 40 04             	mov    0x4(%eax),%eax
  8035be:	85 c0                	test   %eax,%eax
  8035c0:	74 0f                	je     8035d1 <alloc_block_NF+0x123>
  8035c2:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8035c5:	8b 40 04             	mov    0x4(%eax),%eax
  8035c8:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8035cb:	8b 12                	mov    (%edx),%edx
  8035cd:	89 10                	mov    %edx,(%eax)
  8035cf:	eb 0a                	jmp    8035db <alloc_block_NF+0x12d>
  8035d1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8035d4:	8b 00                	mov    (%eax),%eax
  8035d6:	a3 48 51 80 00       	mov    %eax,0x805148
  8035db:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8035de:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8035e4:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8035e7:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8035ee:	a1 54 51 80 00       	mov    0x805154,%eax
  8035f3:	48                   	dec    %eax
  8035f4:	a3 54 51 80 00       	mov    %eax,0x805154
			newblk->size = versize;
  8035f9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8035fc:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8035ff:	89 50 0c             	mov    %edx,0xc(%eax)
			blk->size = blk->size-versize;
  803602:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803605:	8b 40 0c             	mov    0xc(%eax),%eax
  803608:	2b 45 f0             	sub    -0x10(%ebp),%eax
  80360b:	89 c2                	mov    %eax,%edx
  80360d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803610:	89 50 0c             	mov    %edx,0xc(%eax)
			uint32 newveradd = blk->sva;
  803613:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803616:	8b 40 08             	mov    0x8(%eax),%eax
  803619:	89 45 e8             	mov    %eax,-0x18(%ebp)
			blk->sva+=newblk->size;
  80361c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80361f:	8b 50 08             	mov    0x8(%eax),%edx
  803622:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803625:	8b 40 0c             	mov    0xc(%eax),%eax
  803628:	01 c2                	add    %eax,%edx
  80362a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80362d:	89 50 08             	mov    %edx,0x8(%eax)
			newblk->sva = newveradd;
  803630:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803633:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803636:	89 50 08             	mov    %edx,0x8(%eax)
			return newblk;
  803639:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80363c:	eb 3b                	jmp    803679 <alloc_block_NF+0x1cb>
	//panic("alloc_block_NF() is not implemented yet...!!");
	uint32 versize = size;
	struct MemBlock* blk;
	struct MemBlock* newblk = LIST_FIRST(&AvailableMemBlocksList);

	LIST_FOREACH(blk,&FreeMemBlocksList)
  80363e:	a1 40 51 80 00       	mov    0x805140,%eax
  803643:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803646:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80364a:	74 07                	je     803653 <alloc_block_NF+0x1a5>
  80364c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80364f:	8b 00                	mov    (%eax),%eax
  803651:	eb 05                	jmp    803658 <alloc_block_NF+0x1aa>
  803653:	b8 00 00 00 00       	mov    $0x0,%eax
  803658:	a3 40 51 80 00       	mov    %eax,0x805140
  80365d:	a1 40 51 80 00       	mov    0x805140,%eax
  803662:	85 c0                	test   %eax,%eax
  803664:	0f 85 65 fe ff ff    	jne    8034cf <alloc_block_NF+0x21>
  80366a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80366e:	0f 85 5b fe ff ff    	jne    8034cf <alloc_block_NF+0x21>
			blk->sva+=newblk->size;
			newblk->sva = newveradd;
			return newblk;
		}
	}
	return NULL;
  803674:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803679:	c9                   	leave  
  80367a:	c3                   	ret    

0080367b <addToAvailMemBlocksList>:

//===================================================
// [8] INSERT BLOCK (SORTED WITH MERGE) IN FREE LIST:
//===================================================
void addToAvailMemBlocksList(struct MemBlock *blockToInsert)
{
  80367b:	55                   	push   %ebp
  80367c:	89 e5                	mov    %esp,%ebp
  80367e:	83 ec 08             	sub    $0x8,%esp
	blockToInsert->sva = 0;
  803681:	8b 45 08             	mov    0x8(%ebp),%eax
  803684:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
	blockToInsert->size = 0;
  80368b:	8b 45 08             	mov    0x8(%ebp),%eax
  80368e:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
	//add to avail
	LIST_INSERT_TAIL(&AvailableMemBlocksList, blockToInsert);
  803695:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803699:	75 17                	jne    8036b2 <addToAvailMemBlocksList+0x37>
  80369b:	83 ec 04             	sub    $0x4,%esp
  80369e:	68 70 46 80 00       	push   $0x804670
  8036a3:	68 10 01 00 00       	push   $0x110
  8036a8:	68 57 46 80 00       	push   $0x804657
  8036ad:	e8 b6 d8 ff ff       	call   800f68 <_panic>
  8036b2:	8b 15 4c 51 80 00    	mov    0x80514c,%edx
  8036b8:	8b 45 08             	mov    0x8(%ebp),%eax
  8036bb:	89 50 04             	mov    %edx,0x4(%eax)
  8036be:	8b 45 08             	mov    0x8(%ebp),%eax
  8036c1:	8b 40 04             	mov    0x4(%eax),%eax
  8036c4:	85 c0                	test   %eax,%eax
  8036c6:	74 0c                	je     8036d4 <addToAvailMemBlocksList+0x59>
  8036c8:	a1 4c 51 80 00       	mov    0x80514c,%eax
  8036cd:	8b 55 08             	mov    0x8(%ebp),%edx
  8036d0:	89 10                	mov    %edx,(%eax)
  8036d2:	eb 08                	jmp    8036dc <addToAvailMemBlocksList+0x61>
  8036d4:	8b 45 08             	mov    0x8(%ebp),%eax
  8036d7:	a3 48 51 80 00       	mov    %eax,0x805148
  8036dc:	8b 45 08             	mov    0x8(%ebp),%eax
  8036df:	a3 4c 51 80 00       	mov    %eax,0x80514c
  8036e4:	8b 45 08             	mov    0x8(%ebp),%eax
  8036e7:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8036ed:	a1 54 51 80 00       	mov    0x805154,%eax
  8036f2:	40                   	inc    %eax
  8036f3:	a3 54 51 80 00       	mov    %eax,0x805154
}
  8036f8:	90                   	nop
  8036f9:	c9                   	leave  
  8036fa:	c3                   	ret    

008036fb <insert_sorted_with_merge_freeList>:
void insert_sorted_with_merge_freeList(struct MemBlock *blockToInsert)
{
  8036fb:	55                   	push   %ebp
  8036fc:	89 e5                	mov    %esp,%ebp
  8036fe:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] insert_sorted_with_merge_freeList
	// Write your code here, remove the panic and write your code

	struct MemBlock* last = LIST_LAST(&FreeMemBlocksList);
  803701:	a1 3c 51 80 00       	mov    0x80513c,%eax
  803706:	89 45 f0             	mov    %eax,-0x10(%ebp)
	//check if list empty
	if (LIST_SIZE(&(FreeMemBlocksList)) == 0)
  803709:	a1 44 51 80 00       	mov    0x805144,%eax
  80370e:	85 c0                	test   %eax,%eax
  803710:	75 68                	jne    80377a <insert_sorted_with_merge_freeList+0x7f>
		LIST_INSERT_HEAD(&FreeMemBlocksList, blockToInsert);
  803712:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803716:	75 17                	jne    80372f <insert_sorted_with_merge_freeList+0x34>
  803718:	83 ec 04             	sub    $0x4,%esp
  80371b:	68 34 46 80 00       	push   $0x804634
  803720:	68 1a 01 00 00       	push   $0x11a
  803725:	68 57 46 80 00       	push   $0x804657
  80372a:	e8 39 d8 ff ff       	call   800f68 <_panic>
  80372f:	8b 15 38 51 80 00    	mov    0x805138,%edx
  803735:	8b 45 08             	mov    0x8(%ebp),%eax
  803738:	89 10                	mov    %edx,(%eax)
  80373a:	8b 45 08             	mov    0x8(%ebp),%eax
  80373d:	8b 00                	mov    (%eax),%eax
  80373f:	85 c0                	test   %eax,%eax
  803741:	74 0d                	je     803750 <insert_sorted_with_merge_freeList+0x55>
  803743:	a1 38 51 80 00       	mov    0x805138,%eax
  803748:	8b 55 08             	mov    0x8(%ebp),%edx
  80374b:	89 50 04             	mov    %edx,0x4(%eax)
  80374e:	eb 08                	jmp    803758 <insert_sorted_with_merge_freeList+0x5d>
  803750:	8b 45 08             	mov    0x8(%ebp),%eax
  803753:	a3 3c 51 80 00       	mov    %eax,0x80513c
  803758:	8b 45 08             	mov    0x8(%ebp),%eax
  80375b:	a3 38 51 80 00       	mov    %eax,0x805138
  803760:	8b 45 08             	mov    0x8(%ebp),%eax
  803763:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80376a:	a1 44 51 80 00       	mov    0x805144,%eax
  80376f:	40                   	inc    %eax
  803770:	a3 44 51 80 00       	mov    %eax,0x805144
		}
	}

	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  803775:	e9 c5 03 00 00       	jmp    803b3f <insert_sorted_with_merge_freeList+0x444>
	struct MemBlock* last = LIST_LAST(&FreeMemBlocksList);
	//check if list empty
	if (LIST_SIZE(&(FreeMemBlocksList)) == 0)
		LIST_INSERT_HEAD(&FreeMemBlocksList, blockToInsert);
	//check if it's position is at last
	else if (last->sva < blockToInsert->sva) {
  80377a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80377d:	8b 50 08             	mov    0x8(%eax),%edx
  803780:	8b 45 08             	mov    0x8(%ebp),%eax
  803783:	8b 40 08             	mov    0x8(%eax),%eax
  803786:	39 c2                	cmp    %eax,%edx
  803788:	0f 83 b2 00 00 00    	jae    803840 <insert_sorted_with_merge_freeList+0x145>

		//if i have to merge
		if (last->sva + last->size == blockToInsert->sva) {
  80378e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803791:	8b 50 08             	mov    0x8(%eax),%edx
  803794:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803797:	8b 40 0c             	mov    0xc(%eax),%eax
  80379a:	01 c2                	add    %eax,%edx
  80379c:	8b 45 08             	mov    0x8(%ebp),%eax
  80379f:	8b 40 08             	mov    0x8(%eax),%eax
  8037a2:	39 c2                	cmp    %eax,%edx
  8037a4:	75 27                	jne    8037cd <insert_sorted_with_merge_freeList+0xd2>
			last->size = last->size + blockToInsert->size;
  8037a6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8037a9:	8b 50 0c             	mov    0xc(%eax),%edx
  8037ac:	8b 45 08             	mov    0x8(%ebp),%eax
  8037af:	8b 40 0c             	mov    0xc(%eax),%eax
  8037b2:	01 c2                	add    %eax,%edx
  8037b4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8037b7:	89 50 0c             	mov    %edx,0xc(%eax)
			addToAvailMemBlocksList(blockToInsert);
  8037ba:	83 ec 0c             	sub    $0xc,%esp
  8037bd:	ff 75 08             	pushl  0x8(%ebp)
  8037c0:	e8 b6 fe ff ff       	call   80367b <addToAvailMemBlocksList>
  8037c5:	83 c4 10             	add    $0x10,%esp
		}
	}

	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  8037c8:	e9 72 03 00 00       	jmp    803b3f <insert_sorted_with_merge_freeList+0x444>
		if (last->sva + last->size == blockToInsert->sva) {
			last->size = last->size + blockToInsert->size;
			addToAvailMemBlocksList(blockToInsert);

		} else {
			LIST_INSERT_AFTER(&FreeMemBlocksList, last, blockToInsert);
  8037cd:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8037d1:	74 06                	je     8037d9 <insert_sorted_with_merge_freeList+0xde>
  8037d3:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8037d7:	75 17                	jne    8037f0 <insert_sorted_with_merge_freeList+0xf5>
  8037d9:	83 ec 04             	sub    $0x4,%esp
  8037dc:	68 94 46 80 00       	push   $0x804694
  8037e1:	68 24 01 00 00       	push   $0x124
  8037e6:	68 57 46 80 00       	push   $0x804657
  8037eb:	e8 78 d7 ff ff       	call   800f68 <_panic>
  8037f0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8037f3:	8b 10                	mov    (%eax),%edx
  8037f5:	8b 45 08             	mov    0x8(%ebp),%eax
  8037f8:	89 10                	mov    %edx,(%eax)
  8037fa:	8b 45 08             	mov    0x8(%ebp),%eax
  8037fd:	8b 00                	mov    (%eax),%eax
  8037ff:	85 c0                	test   %eax,%eax
  803801:	74 0b                	je     80380e <insert_sorted_with_merge_freeList+0x113>
  803803:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803806:	8b 00                	mov    (%eax),%eax
  803808:	8b 55 08             	mov    0x8(%ebp),%edx
  80380b:	89 50 04             	mov    %edx,0x4(%eax)
  80380e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803811:	8b 55 08             	mov    0x8(%ebp),%edx
  803814:	89 10                	mov    %edx,(%eax)
  803816:	8b 45 08             	mov    0x8(%ebp),%eax
  803819:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80381c:	89 50 04             	mov    %edx,0x4(%eax)
  80381f:	8b 45 08             	mov    0x8(%ebp),%eax
  803822:	8b 00                	mov    (%eax),%eax
  803824:	85 c0                	test   %eax,%eax
  803826:	75 08                	jne    803830 <insert_sorted_with_merge_freeList+0x135>
  803828:	8b 45 08             	mov    0x8(%ebp),%eax
  80382b:	a3 3c 51 80 00       	mov    %eax,0x80513c
  803830:	a1 44 51 80 00       	mov    0x805144,%eax
  803835:	40                   	inc    %eax
  803836:	a3 44 51 80 00       	mov    %eax,0x805144
		}
	}

	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  80383b:	e9 ff 02 00 00       	jmp    803b3f <insert_sorted_with_merge_freeList+0x444>
		} else {
			LIST_INSERT_AFTER(&FreeMemBlocksList, last, blockToInsert);
		}
	} else {
		struct MemBlock *iterator;
		LIST_FOREACH(iterator, &(FreeMemBlocksList))
  803840:	a1 38 51 80 00       	mov    0x805138,%eax
  803845:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803848:	e9 c2 02 00 00       	jmp    803b0f <insert_sorted_with_merge_freeList+0x414>
		{

			if (iterator->sva > blockToInsert->sva) {
  80384d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803850:	8b 50 08             	mov    0x8(%eax),%edx
  803853:	8b 45 08             	mov    0x8(%ebp),%eax
  803856:	8b 40 08             	mov    0x8(%eax),%eax
  803859:	39 c2                	cmp    %eax,%edx
  80385b:	0f 86 a6 02 00 00    	jbe    803b07 <insert_sorted_with_merge_freeList+0x40c>

				struct MemBlock* prev = LIST_PREV(iterator);
  803861:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803864:	8b 40 04             	mov    0x4(%eax),%eax
  803867:	89 45 ec             	mov    %eax,-0x14(%ebp)
				if (prev == NULL) {
  80386a:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  80386e:	0f 85 ba 00 00 00    	jne    80392e <insert_sorted_with_merge_freeList+0x233>
					//check merge
					if (blockToInsert->size + blockToInsert->sva
  803874:	8b 45 08             	mov    0x8(%ebp),%eax
  803877:	8b 50 0c             	mov    0xc(%eax),%edx
  80387a:	8b 45 08             	mov    0x8(%ebp),%eax
  80387d:	8b 40 08             	mov    0x8(%eax),%eax
  803880:	01 c2                	add    %eax,%edx
							== iterator->sva) {
  803882:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803885:	8b 40 08             	mov    0x8(%eax),%eax
			if (iterator->sva > blockToInsert->sva) {

				struct MemBlock* prev = LIST_PREV(iterator);
				if (prev == NULL) {
					//check merge
					if (blockToInsert->size + blockToInsert->sva
  803888:	39 c2                	cmp    %eax,%edx
  80388a:	75 33                	jne    8038bf <insert_sorted_with_merge_freeList+0x1c4>
							== iterator->sva) {
						iterator->sva = blockToInsert->sva;
  80388c:	8b 45 08             	mov    0x8(%ebp),%eax
  80388f:	8b 50 08             	mov    0x8(%eax),%edx
  803892:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803895:	89 50 08             	mov    %edx,0x8(%eax)
						iterator->size = iterator->size + blockToInsert->size;
  803898:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80389b:	8b 50 0c             	mov    0xc(%eax),%edx
  80389e:	8b 45 08             	mov    0x8(%ebp),%eax
  8038a1:	8b 40 0c             	mov    0xc(%eax),%eax
  8038a4:	01 c2                	add    %eax,%edx
  8038a6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8038a9:	89 50 0c             	mov    %edx,0xc(%eax)
						addToAvailMemBlocksList(blockToInsert);
  8038ac:	83 ec 0c             	sub    $0xc,%esp
  8038af:	ff 75 08             	pushl  0x8(%ebp)
  8038b2:	e8 c4 fd ff ff       	call   80367b <addToAvailMemBlocksList>
  8038b7:	83 c4 10             	add    $0x10,%esp

					else {
						LIST_INSERT_BEFORE(&FreeMemBlocksList, iterator,
								blockToInsert);
					}
					break;
  8038ba:	e9 80 02 00 00       	jmp    803b3f <insert_sorted_with_merge_freeList+0x444>
						addToAvailMemBlocksList(blockToInsert);

					}

					else {
						LIST_INSERT_BEFORE(&FreeMemBlocksList, iterator,
  8038bf:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8038c3:	74 06                	je     8038cb <insert_sorted_with_merge_freeList+0x1d0>
  8038c5:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8038c9:	75 17                	jne    8038e2 <insert_sorted_with_merge_freeList+0x1e7>
  8038cb:	83 ec 04             	sub    $0x4,%esp
  8038ce:	68 e8 46 80 00       	push   $0x8046e8
  8038d3:	68 3a 01 00 00       	push   $0x13a
  8038d8:	68 57 46 80 00       	push   $0x804657
  8038dd:	e8 86 d6 ff ff       	call   800f68 <_panic>
  8038e2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8038e5:	8b 50 04             	mov    0x4(%eax),%edx
  8038e8:	8b 45 08             	mov    0x8(%ebp),%eax
  8038eb:	89 50 04             	mov    %edx,0x4(%eax)
  8038ee:	8b 45 08             	mov    0x8(%ebp),%eax
  8038f1:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8038f4:	89 10                	mov    %edx,(%eax)
  8038f6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8038f9:	8b 40 04             	mov    0x4(%eax),%eax
  8038fc:	85 c0                	test   %eax,%eax
  8038fe:	74 0d                	je     80390d <insert_sorted_with_merge_freeList+0x212>
  803900:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803903:	8b 40 04             	mov    0x4(%eax),%eax
  803906:	8b 55 08             	mov    0x8(%ebp),%edx
  803909:	89 10                	mov    %edx,(%eax)
  80390b:	eb 08                	jmp    803915 <insert_sorted_with_merge_freeList+0x21a>
  80390d:	8b 45 08             	mov    0x8(%ebp),%eax
  803910:	a3 38 51 80 00       	mov    %eax,0x805138
  803915:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803918:	8b 55 08             	mov    0x8(%ebp),%edx
  80391b:	89 50 04             	mov    %edx,0x4(%eax)
  80391e:	a1 44 51 80 00       	mov    0x805144,%eax
  803923:	40                   	inc    %eax
  803924:	a3 44 51 80 00       	mov    %eax,0x805144
								blockToInsert);
					}
					break;
  803929:	e9 11 02 00 00       	jmp    803b3f <insert_sorted_with_merge_freeList+0x444>
				} else {
					//prev and next merge
					if (prev->sva + prev->size + blockToInsert->size
  80392e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803931:	8b 50 08             	mov    0x8(%eax),%edx
  803934:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803937:	8b 40 0c             	mov    0xc(%eax),%eax
  80393a:	01 c2                	add    %eax,%edx
  80393c:	8b 45 08             	mov    0x8(%ebp),%eax
  80393f:	8b 40 0c             	mov    0xc(%eax),%eax
  803942:	01 c2                	add    %eax,%edx
							== iterator->sva) {
  803944:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803947:	8b 40 08             	mov    0x8(%eax),%eax
								blockToInsert);
					}
					break;
				} else {
					//prev and next merge
					if (prev->sva + prev->size + blockToInsert->size
  80394a:	39 c2                	cmp    %eax,%edx
  80394c:	0f 85 bf 00 00 00    	jne    803a11 <insert_sorted_with_merge_freeList+0x316>
							== iterator->sva) {
						prev->size = prev->size + blockToInsert->size
  803952:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803955:	8b 50 0c             	mov    0xc(%eax),%edx
  803958:	8b 45 08             	mov    0x8(%ebp),%eax
  80395b:	8b 40 0c             	mov    0xc(%eax),%eax
  80395e:	01 c2                	add    %eax,%edx
								+ iterator->size;
  803960:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803963:	8b 40 0c             	mov    0xc(%eax),%eax
  803966:	01 c2                	add    %eax,%edx
					break;
				} else {
					//prev and next merge
					if (prev->sva + prev->size + blockToInsert->size
							== iterator->sva) {
						prev->size = prev->size + blockToInsert->size
  803968:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80396b:	89 50 0c             	mov    %edx,0xc(%eax)
								+ iterator->size;
						LIST_REMOVE(&FreeMemBlocksList, iterator);
  80396e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803972:	75 17                	jne    80398b <insert_sorted_with_merge_freeList+0x290>
  803974:	83 ec 04             	sub    $0x4,%esp
  803977:	68 c8 46 80 00       	push   $0x8046c8
  80397c:	68 43 01 00 00       	push   $0x143
  803981:	68 57 46 80 00       	push   $0x804657
  803986:	e8 dd d5 ff ff       	call   800f68 <_panic>
  80398b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80398e:	8b 00                	mov    (%eax),%eax
  803990:	85 c0                	test   %eax,%eax
  803992:	74 10                	je     8039a4 <insert_sorted_with_merge_freeList+0x2a9>
  803994:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803997:	8b 00                	mov    (%eax),%eax
  803999:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80399c:	8b 52 04             	mov    0x4(%edx),%edx
  80399f:	89 50 04             	mov    %edx,0x4(%eax)
  8039a2:	eb 0b                	jmp    8039af <insert_sorted_with_merge_freeList+0x2b4>
  8039a4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8039a7:	8b 40 04             	mov    0x4(%eax),%eax
  8039aa:	a3 3c 51 80 00       	mov    %eax,0x80513c
  8039af:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8039b2:	8b 40 04             	mov    0x4(%eax),%eax
  8039b5:	85 c0                	test   %eax,%eax
  8039b7:	74 0f                	je     8039c8 <insert_sorted_with_merge_freeList+0x2cd>
  8039b9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8039bc:	8b 40 04             	mov    0x4(%eax),%eax
  8039bf:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8039c2:	8b 12                	mov    (%edx),%edx
  8039c4:	89 10                	mov    %edx,(%eax)
  8039c6:	eb 0a                	jmp    8039d2 <insert_sorted_with_merge_freeList+0x2d7>
  8039c8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8039cb:	8b 00                	mov    (%eax),%eax
  8039cd:	a3 38 51 80 00       	mov    %eax,0x805138
  8039d2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8039d5:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8039db:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8039de:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8039e5:	a1 44 51 80 00       	mov    0x805144,%eax
  8039ea:	48                   	dec    %eax
  8039eb:	a3 44 51 80 00       	mov    %eax,0x805144
						addToAvailMemBlocksList(blockToInsert);
  8039f0:	83 ec 0c             	sub    $0xc,%esp
  8039f3:	ff 75 08             	pushl  0x8(%ebp)
  8039f6:	e8 80 fc ff ff       	call   80367b <addToAvailMemBlocksList>
  8039fb:	83 c4 10             	add    $0x10,%esp
						addToAvailMemBlocksList(iterator);
  8039fe:	83 ec 0c             	sub    $0xc,%esp
  803a01:	ff 75 f4             	pushl  -0xc(%ebp)
  803a04:	e8 72 fc ff ff       	call   80367b <addToAvailMemBlocksList>
  803a09:	83 c4 10             	add    $0x10,%esp
					//Insert
					else {
						LIST_INSERT_BEFORE(&FreeMemBlocksList, iterator,
								blockToInsert);
					}
					break;
  803a0c:	e9 2e 01 00 00       	jmp    803b3f <insert_sorted_with_merge_freeList+0x444>
						LIST_REMOVE(&FreeMemBlocksList, iterator);
						addToAvailMemBlocksList(blockToInsert);
						addToAvailMemBlocksList(iterator);
					}
					//previous merge
					else if (prev->sva + prev->size == blockToInsert->sva) {
  803a11:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803a14:	8b 50 08             	mov    0x8(%eax),%edx
  803a17:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803a1a:	8b 40 0c             	mov    0xc(%eax),%eax
  803a1d:	01 c2                	add    %eax,%edx
  803a1f:	8b 45 08             	mov    0x8(%ebp),%eax
  803a22:	8b 40 08             	mov    0x8(%eax),%eax
  803a25:	39 c2                	cmp    %eax,%edx
  803a27:	75 27                	jne    803a50 <insert_sorted_with_merge_freeList+0x355>
						prev->size = prev->size + blockToInsert->size;
  803a29:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803a2c:	8b 50 0c             	mov    0xc(%eax),%edx
  803a2f:	8b 45 08             	mov    0x8(%ebp),%eax
  803a32:	8b 40 0c             	mov    0xc(%eax),%eax
  803a35:	01 c2                	add    %eax,%edx
  803a37:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803a3a:	89 50 0c             	mov    %edx,0xc(%eax)
						addToAvailMemBlocksList(blockToInsert);
  803a3d:	83 ec 0c             	sub    $0xc,%esp
  803a40:	ff 75 08             	pushl  0x8(%ebp)
  803a43:	e8 33 fc ff ff       	call   80367b <addToAvailMemBlocksList>
  803a48:	83 c4 10             	add    $0x10,%esp
					//Insert
					else {
						LIST_INSERT_BEFORE(&FreeMemBlocksList, iterator,
								blockToInsert);
					}
					break;
  803a4b:	e9 ef 00 00 00       	jmp    803b3f <insert_sorted_with_merge_freeList+0x444>
					else if (prev->sva + prev->size == blockToInsert->sva) {
						prev->size = prev->size + blockToInsert->size;
						addToAvailMemBlocksList(blockToInsert);
					}
					//next merge
					else if (blockToInsert->size + blockToInsert->sva
  803a50:	8b 45 08             	mov    0x8(%ebp),%eax
  803a53:	8b 50 0c             	mov    0xc(%eax),%edx
  803a56:	8b 45 08             	mov    0x8(%ebp),%eax
  803a59:	8b 40 08             	mov    0x8(%eax),%eax
  803a5c:	01 c2                	add    %eax,%edx
							== iterator->sva) {
  803a5e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803a61:	8b 40 08             	mov    0x8(%eax),%eax
					else if (prev->sva + prev->size == blockToInsert->sva) {
						prev->size = prev->size + blockToInsert->size;
						addToAvailMemBlocksList(blockToInsert);
					}
					//next merge
					else if (blockToInsert->size + blockToInsert->sva
  803a64:	39 c2                	cmp    %eax,%edx
  803a66:	75 33                	jne    803a9b <insert_sorted_with_merge_freeList+0x3a0>
							== iterator->sva) {
						iterator->sva = blockToInsert->sva;
  803a68:	8b 45 08             	mov    0x8(%ebp),%eax
  803a6b:	8b 50 08             	mov    0x8(%eax),%edx
  803a6e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803a71:	89 50 08             	mov    %edx,0x8(%eax)
						iterator->size = iterator->size + blockToInsert->size;
  803a74:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803a77:	8b 50 0c             	mov    0xc(%eax),%edx
  803a7a:	8b 45 08             	mov    0x8(%ebp),%eax
  803a7d:	8b 40 0c             	mov    0xc(%eax),%eax
  803a80:	01 c2                	add    %eax,%edx
  803a82:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803a85:	89 50 0c             	mov    %edx,0xc(%eax)
						addToAvailMemBlocksList(blockToInsert);
  803a88:	83 ec 0c             	sub    $0xc,%esp
  803a8b:	ff 75 08             	pushl  0x8(%ebp)
  803a8e:	e8 e8 fb ff ff       	call   80367b <addToAvailMemBlocksList>
  803a93:	83 c4 10             	add    $0x10,%esp
					//Insert
					else {
						LIST_INSERT_BEFORE(&FreeMemBlocksList, iterator,
								blockToInsert);
					}
					break;
  803a96:	e9 a4 00 00 00       	jmp    803b3f <insert_sorted_with_merge_freeList+0x444>
						iterator->size = iterator->size + blockToInsert->size;
						addToAvailMemBlocksList(blockToInsert);
					}
					//Insert
					else {
						LIST_INSERT_BEFORE(&FreeMemBlocksList, iterator,
  803a9b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803a9f:	74 06                	je     803aa7 <insert_sorted_with_merge_freeList+0x3ac>
  803aa1:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803aa5:	75 17                	jne    803abe <insert_sorted_with_merge_freeList+0x3c3>
  803aa7:	83 ec 04             	sub    $0x4,%esp
  803aaa:	68 e8 46 80 00       	push   $0x8046e8
  803aaf:	68 56 01 00 00       	push   $0x156
  803ab4:	68 57 46 80 00       	push   $0x804657
  803ab9:	e8 aa d4 ff ff       	call   800f68 <_panic>
  803abe:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803ac1:	8b 50 04             	mov    0x4(%eax),%edx
  803ac4:	8b 45 08             	mov    0x8(%ebp),%eax
  803ac7:	89 50 04             	mov    %edx,0x4(%eax)
  803aca:	8b 45 08             	mov    0x8(%ebp),%eax
  803acd:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803ad0:	89 10                	mov    %edx,(%eax)
  803ad2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803ad5:	8b 40 04             	mov    0x4(%eax),%eax
  803ad8:	85 c0                	test   %eax,%eax
  803ada:	74 0d                	je     803ae9 <insert_sorted_with_merge_freeList+0x3ee>
  803adc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803adf:	8b 40 04             	mov    0x4(%eax),%eax
  803ae2:	8b 55 08             	mov    0x8(%ebp),%edx
  803ae5:	89 10                	mov    %edx,(%eax)
  803ae7:	eb 08                	jmp    803af1 <insert_sorted_with_merge_freeList+0x3f6>
  803ae9:	8b 45 08             	mov    0x8(%ebp),%eax
  803aec:	a3 38 51 80 00       	mov    %eax,0x805138
  803af1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803af4:	8b 55 08             	mov    0x8(%ebp),%edx
  803af7:	89 50 04             	mov    %edx,0x4(%eax)
  803afa:	a1 44 51 80 00       	mov    0x805144,%eax
  803aff:	40                   	inc    %eax
  803b00:	a3 44 51 80 00       	mov    %eax,0x805144
								blockToInsert);
					}
					break;
  803b05:	eb 38                	jmp    803b3f <insert_sorted_with_merge_freeList+0x444>
		} else {
			LIST_INSERT_AFTER(&FreeMemBlocksList, last, blockToInsert);
		}
	} else {
		struct MemBlock *iterator;
		LIST_FOREACH(iterator, &(FreeMemBlocksList))
  803b07:	a1 40 51 80 00       	mov    0x805140,%eax
  803b0c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803b0f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803b13:	74 07                	je     803b1c <insert_sorted_with_merge_freeList+0x421>
  803b15:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803b18:	8b 00                	mov    (%eax),%eax
  803b1a:	eb 05                	jmp    803b21 <insert_sorted_with_merge_freeList+0x426>
  803b1c:	b8 00 00 00 00       	mov    $0x0,%eax
  803b21:	a3 40 51 80 00       	mov    %eax,0x805140
  803b26:	a1 40 51 80 00       	mov    0x805140,%eax
  803b2b:	85 c0                	test   %eax,%eax
  803b2d:	0f 85 1a fd ff ff    	jne    80384d <insert_sorted_with_merge_freeList+0x152>
  803b33:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803b37:	0f 85 10 fd ff ff    	jne    80384d <insert_sorted_with_merge_freeList+0x152>
		}
	}

	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  803b3d:	eb 00                	jmp    803b3f <insert_sorted_with_merge_freeList+0x444>
  803b3f:	90                   	nop
  803b40:	c9                   	leave  
  803b41:	c3                   	ret    
  803b42:	66 90                	xchg   %ax,%ax

00803b44 <__udivdi3>:
  803b44:	55                   	push   %ebp
  803b45:	57                   	push   %edi
  803b46:	56                   	push   %esi
  803b47:	53                   	push   %ebx
  803b48:	83 ec 1c             	sub    $0x1c,%esp
  803b4b:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  803b4f:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  803b53:	8b 7c 24 38          	mov    0x38(%esp),%edi
  803b57:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  803b5b:	89 ca                	mov    %ecx,%edx
  803b5d:	89 f8                	mov    %edi,%eax
  803b5f:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  803b63:	85 f6                	test   %esi,%esi
  803b65:	75 2d                	jne    803b94 <__udivdi3+0x50>
  803b67:	39 cf                	cmp    %ecx,%edi
  803b69:	77 65                	ja     803bd0 <__udivdi3+0x8c>
  803b6b:	89 fd                	mov    %edi,%ebp
  803b6d:	85 ff                	test   %edi,%edi
  803b6f:	75 0b                	jne    803b7c <__udivdi3+0x38>
  803b71:	b8 01 00 00 00       	mov    $0x1,%eax
  803b76:	31 d2                	xor    %edx,%edx
  803b78:	f7 f7                	div    %edi
  803b7a:	89 c5                	mov    %eax,%ebp
  803b7c:	31 d2                	xor    %edx,%edx
  803b7e:	89 c8                	mov    %ecx,%eax
  803b80:	f7 f5                	div    %ebp
  803b82:	89 c1                	mov    %eax,%ecx
  803b84:	89 d8                	mov    %ebx,%eax
  803b86:	f7 f5                	div    %ebp
  803b88:	89 cf                	mov    %ecx,%edi
  803b8a:	89 fa                	mov    %edi,%edx
  803b8c:	83 c4 1c             	add    $0x1c,%esp
  803b8f:	5b                   	pop    %ebx
  803b90:	5e                   	pop    %esi
  803b91:	5f                   	pop    %edi
  803b92:	5d                   	pop    %ebp
  803b93:	c3                   	ret    
  803b94:	39 ce                	cmp    %ecx,%esi
  803b96:	77 28                	ja     803bc0 <__udivdi3+0x7c>
  803b98:	0f bd fe             	bsr    %esi,%edi
  803b9b:	83 f7 1f             	xor    $0x1f,%edi
  803b9e:	75 40                	jne    803be0 <__udivdi3+0x9c>
  803ba0:	39 ce                	cmp    %ecx,%esi
  803ba2:	72 0a                	jb     803bae <__udivdi3+0x6a>
  803ba4:	3b 44 24 08          	cmp    0x8(%esp),%eax
  803ba8:	0f 87 9e 00 00 00    	ja     803c4c <__udivdi3+0x108>
  803bae:	b8 01 00 00 00       	mov    $0x1,%eax
  803bb3:	89 fa                	mov    %edi,%edx
  803bb5:	83 c4 1c             	add    $0x1c,%esp
  803bb8:	5b                   	pop    %ebx
  803bb9:	5e                   	pop    %esi
  803bba:	5f                   	pop    %edi
  803bbb:	5d                   	pop    %ebp
  803bbc:	c3                   	ret    
  803bbd:	8d 76 00             	lea    0x0(%esi),%esi
  803bc0:	31 ff                	xor    %edi,%edi
  803bc2:	31 c0                	xor    %eax,%eax
  803bc4:	89 fa                	mov    %edi,%edx
  803bc6:	83 c4 1c             	add    $0x1c,%esp
  803bc9:	5b                   	pop    %ebx
  803bca:	5e                   	pop    %esi
  803bcb:	5f                   	pop    %edi
  803bcc:	5d                   	pop    %ebp
  803bcd:	c3                   	ret    
  803bce:	66 90                	xchg   %ax,%ax
  803bd0:	89 d8                	mov    %ebx,%eax
  803bd2:	f7 f7                	div    %edi
  803bd4:	31 ff                	xor    %edi,%edi
  803bd6:	89 fa                	mov    %edi,%edx
  803bd8:	83 c4 1c             	add    $0x1c,%esp
  803bdb:	5b                   	pop    %ebx
  803bdc:	5e                   	pop    %esi
  803bdd:	5f                   	pop    %edi
  803bde:	5d                   	pop    %ebp
  803bdf:	c3                   	ret    
  803be0:	bd 20 00 00 00       	mov    $0x20,%ebp
  803be5:	89 eb                	mov    %ebp,%ebx
  803be7:	29 fb                	sub    %edi,%ebx
  803be9:	89 f9                	mov    %edi,%ecx
  803beb:	d3 e6                	shl    %cl,%esi
  803bed:	89 c5                	mov    %eax,%ebp
  803bef:	88 d9                	mov    %bl,%cl
  803bf1:	d3 ed                	shr    %cl,%ebp
  803bf3:	89 e9                	mov    %ebp,%ecx
  803bf5:	09 f1                	or     %esi,%ecx
  803bf7:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  803bfb:	89 f9                	mov    %edi,%ecx
  803bfd:	d3 e0                	shl    %cl,%eax
  803bff:	89 c5                	mov    %eax,%ebp
  803c01:	89 d6                	mov    %edx,%esi
  803c03:	88 d9                	mov    %bl,%cl
  803c05:	d3 ee                	shr    %cl,%esi
  803c07:	89 f9                	mov    %edi,%ecx
  803c09:	d3 e2                	shl    %cl,%edx
  803c0b:	8b 44 24 08          	mov    0x8(%esp),%eax
  803c0f:	88 d9                	mov    %bl,%cl
  803c11:	d3 e8                	shr    %cl,%eax
  803c13:	09 c2                	or     %eax,%edx
  803c15:	89 d0                	mov    %edx,%eax
  803c17:	89 f2                	mov    %esi,%edx
  803c19:	f7 74 24 0c          	divl   0xc(%esp)
  803c1d:	89 d6                	mov    %edx,%esi
  803c1f:	89 c3                	mov    %eax,%ebx
  803c21:	f7 e5                	mul    %ebp
  803c23:	39 d6                	cmp    %edx,%esi
  803c25:	72 19                	jb     803c40 <__udivdi3+0xfc>
  803c27:	74 0b                	je     803c34 <__udivdi3+0xf0>
  803c29:	89 d8                	mov    %ebx,%eax
  803c2b:	31 ff                	xor    %edi,%edi
  803c2d:	e9 58 ff ff ff       	jmp    803b8a <__udivdi3+0x46>
  803c32:	66 90                	xchg   %ax,%ax
  803c34:	8b 54 24 08          	mov    0x8(%esp),%edx
  803c38:	89 f9                	mov    %edi,%ecx
  803c3a:	d3 e2                	shl    %cl,%edx
  803c3c:	39 c2                	cmp    %eax,%edx
  803c3e:	73 e9                	jae    803c29 <__udivdi3+0xe5>
  803c40:	8d 43 ff             	lea    -0x1(%ebx),%eax
  803c43:	31 ff                	xor    %edi,%edi
  803c45:	e9 40 ff ff ff       	jmp    803b8a <__udivdi3+0x46>
  803c4a:	66 90                	xchg   %ax,%ax
  803c4c:	31 c0                	xor    %eax,%eax
  803c4e:	e9 37 ff ff ff       	jmp    803b8a <__udivdi3+0x46>
  803c53:	90                   	nop

00803c54 <__umoddi3>:
  803c54:	55                   	push   %ebp
  803c55:	57                   	push   %edi
  803c56:	56                   	push   %esi
  803c57:	53                   	push   %ebx
  803c58:	83 ec 1c             	sub    $0x1c,%esp
  803c5b:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  803c5f:	8b 74 24 34          	mov    0x34(%esp),%esi
  803c63:	8b 7c 24 38          	mov    0x38(%esp),%edi
  803c67:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  803c6b:	89 44 24 0c          	mov    %eax,0xc(%esp)
  803c6f:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  803c73:	89 f3                	mov    %esi,%ebx
  803c75:	89 fa                	mov    %edi,%edx
  803c77:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  803c7b:	89 34 24             	mov    %esi,(%esp)
  803c7e:	85 c0                	test   %eax,%eax
  803c80:	75 1a                	jne    803c9c <__umoddi3+0x48>
  803c82:	39 f7                	cmp    %esi,%edi
  803c84:	0f 86 a2 00 00 00    	jbe    803d2c <__umoddi3+0xd8>
  803c8a:	89 c8                	mov    %ecx,%eax
  803c8c:	89 f2                	mov    %esi,%edx
  803c8e:	f7 f7                	div    %edi
  803c90:	89 d0                	mov    %edx,%eax
  803c92:	31 d2                	xor    %edx,%edx
  803c94:	83 c4 1c             	add    $0x1c,%esp
  803c97:	5b                   	pop    %ebx
  803c98:	5e                   	pop    %esi
  803c99:	5f                   	pop    %edi
  803c9a:	5d                   	pop    %ebp
  803c9b:	c3                   	ret    
  803c9c:	39 f0                	cmp    %esi,%eax
  803c9e:	0f 87 ac 00 00 00    	ja     803d50 <__umoddi3+0xfc>
  803ca4:	0f bd e8             	bsr    %eax,%ebp
  803ca7:	83 f5 1f             	xor    $0x1f,%ebp
  803caa:	0f 84 ac 00 00 00    	je     803d5c <__umoddi3+0x108>
  803cb0:	bf 20 00 00 00       	mov    $0x20,%edi
  803cb5:	29 ef                	sub    %ebp,%edi
  803cb7:	89 fe                	mov    %edi,%esi
  803cb9:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  803cbd:	89 e9                	mov    %ebp,%ecx
  803cbf:	d3 e0                	shl    %cl,%eax
  803cc1:	89 d7                	mov    %edx,%edi
  803cc3:	89 f1                	mov    %esi,%ecx
  803cc5:	d3 ef                	shr    %cl,%edi
  803cc7:	09 c7                	or     %eax,%edi
  803cc9:	89 e9                	mov    %ebp,%ecx
  803ccb:	d3 e2                	shl    %cl,%edx
  803ccd:	89 14 24             	mov    %edx,(%esp)
  803cd0:	89 d8                	mov    %ebx,%eax
  803cd2:	d3 e0                	shl    %cl,%eax
  803cd4:	89 c2                	mov    %eax,%edx
  803cd6:	8b 44 24 08          	mov    0x8(%esp),%eax
  803cda:	d3 e0                	shl    %cl,%eax
  803cdc:	89 44 24 04          	mov    %eax,0x4(%esp)
  803ce0:	8b 44 24 08          	mov    0x8(%esp),%eax
  803ce4:	89 f1                	mov    %esi,%ecx
  803ce6:	d3 e8                	shr    %cl,%eax
  803ce8:	09 d0                	or     %edx,%eax
  803cea:	d3 eb                	shr    %cl,%ebx
  803cec:	89 da                	mov    %ebx,%edx
  803cee:	f7 f7                	div    %edi
  803cf0:	89 d3                	mov    %edx,%ebx
  803cf2:	f7 24 24             	mull   (%esp)
  803cf5:	89 c6                	mov    %eax,%esi
  803cf7:	89 d1                	mov    %edx,%ecx
  803cf9:	39 d3                	cmp    %edx,%ebx
  803cfb:	0f 82 87 00 00 00    	jb     803d88 <__umoddi3+0x134>
  803d01:	0f 84 91 00 00 00    	je     803d98 <__umoddi3+0x144>
  803d07:	8b 54 24 04          	mov    0x4(%esp),%edx
  803d0b:	29 f2                	sub    %esi,%edx
  803d0d:	19 cb                	sbb    %ecx,%ebx
  803d0f:	89 d8                	mov    %ebx,%eax
  803d11:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  803d15:	d3 e0                	shl    %cl,%eax
  803d17:	89 e9                	mov    %ebp,%ecx
  803d19:	d3 ea                	shr    %cl,%edx
  803d1b:	09 d0                	or     %edx,%eax
  803d1d:	89 e9                	mov    %ebp,%ecx
  803d1f:	d3 eb                	shr    %cl,%ebx
  803d21:	89 da                	mov    %ebx,%edx
  803d23:	83 c4 1c             	add    $0x1c,%esp
  803d26:	5b                   	pop    %ebx
  803d27:	5e                   	pop    %esi
  803d28:	5f                   	pop    %edi
  803d29:	5d                   	pop    %ebp
  803d2a:	c3                   	ret    
  803d2b:	90                   	nop
  803d2c:	89 fd                	mov    %edi,%ebp
  803d2e:	85 ff                	test   %edi,%edi
  803d30:	75 0b                	jne    803d3d <__umoddi3+0xe9>
  803d32:	b8 01 00 00 00       	mov    $0x1,%eax
  803d37:	31 d2                	xor    %edx,%edx
  803d39:	f7 f7                	div    %edi
  803d3b:	89 c5                	mov    %eax,%ebp
  803d3d:	89 f0                	mov    %esi,%eax
  803d3f:	31 d2                	xor    %edx,%edx
  803d41:	f7 f5                	div    %ebp
  803d43:	89 c8                	mov    %ecx,%eax
  803d45:	f7 f5                	div    %ebp
  803d47:	89 d0                	mov    %edx,%eax
  803d49:	e9 44 ff ff ff       	jmp    803c92 <__umoddi3+0x3e>
  803d4e:	66 90                	xchg   %ax,%ax
  803d50:	89 c8                	mov    %ecx,%eax
  803d52:	89 f2                	mov    %esi,%edx
  803d54:	83 c4 1c             	add    $0x1c,%esp
  803d57:	5b                   	pop    %ebx
  803d58:	5e                   	pop    %esi
  803d59:	5f                   	pop    %edi
  803d5a:	5d                   	pop    %ebp
  803d5b:	c3                   	ret    
  803d5c:	3b 04 24             	cmp    (%esp),%eax
  803d5f:	72 06                	jb     803d67 <__umoddi3+0x113>
  803d61:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  803d65:	77 0f                	ja     803d76 <__umoddi3+0x122>
  803d67:	89 f2                	mov    %esi,%edx
  803d69:	29 f9                	sub    %edi,%ecx
  803d6b:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  803d6f:	89 14 24             	mov    %edx,(%esp)
  803d72:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  803d76:	8b 44 24 04          	mov    0x4(%esp),%eax
  803d7a:	8b 14 24             	mov    (%esp),%edx
  803d7d:	83 c4 1c             	add    $0x1c,%esp
  803d80:	5b                   	pop    %ebx
  803d81:	5e                   	pop    %esi
  803d82:	5f                   	pop    %edi
  803d83:	5d                   	pop    %ebp
  803d84:	c3                   	ret    
  803d85:	8d 76 00             	lea    0x0(%esi),%esi
  803d88:	2b 04 24             	sub    (%esp),%eax
  803d8b:	19 fa                	sbb    %edi,%edx
  803d8d:	89 d1                	mov    %edx,%ecx
  803d8f:	89 c6                	mov    %eax,%esi
  803d91:	e9 71 ff ff ff       	jmp    803d07 <__umoddi3+0xb3>
  803d96:	66 90                	xchg   %ax,%ax
  803d98:	39 44 24 04          	cmp    %eax,0x4(%esp)
  803d9c:	72 ea                	jb     803d88 <__umoddi3+0x134>
  803d9e:	89 d9                	mov    %ebx,%ecx
  803da0:	e9 62 ff ff ff       	jmp    803d07 <__umoddi3+0xb3>
