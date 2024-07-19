
obj/user/tst_free_1:     file format elf32-i386


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
  800031:	e8 b8 17 00 00       	call   8017ee <libmain>
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
  80003d:	81 ec 90 01 00 00    	sub    $0x190,%esp
	//Initial test to ensure it works on "PLACEMENT" not "REPLACEMENT"
	{
		uint8 fullWS = 1;
  800043:	c6 45 f7 01          	movb   $0x1,-0x9(%ebp)
		for (int i = 0; i < myEnv->page_WS_max_size; ++i)
  800047:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  80004e:	eb 29                	jmp    800079 <_main+0x41>
		{
			if (myEnv->__uptr_pws[i].empty)
  800050:	a1 20 60 80 00       	mov    0x806020,%eax
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
  800079:	a1 20 60 80 00       	mov    0x806020,%eax
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
  800091:	68 80 47 80 00       	push   $0x804780
  800096:	6a 1a                	push   $0x1a
  800098:	68 9c 47 80 00       	push   $0x80479c
  80009d:	e8 88 18 00 00       	call   80192a <_panic>





	int Mega = 1024*1024;
  8000a2:	c7 45 e0 00 00 10 00 	movl   $0x100000,-0x20(%ebp)
	int kilo = 1024;
  8000a9:	c7 45 dc 00 04 00 00 	movl   $0x400,-0x24(%ebp)
	char minByte = 1<<7;
  8000b0:	c6 45 db 80          	movb   $0x80,-0x25(%ebp)
	char maxByte = 0x7F;
  8000b4:	c6 45 da 7f          	movb   $0x7f,-0x26(%ebp)
	short minShort = 1<<15 ;
  8000b8:	66 c7 45 d8 00 80    	movw   $0x8000,-0x28(%ebp)
	short maxShort = 0x7FFF;
  8000be:	66 c7 45 d6 ff 7f    	movw   $0x7fff,-0x2a(%ebp)
	int minInt = 1<<31 ;
  8000c4:	c7 45 d0 00 00 00 80 	movl   $0x80000000,-0x30(%ebp)
	int maxInt = 0x7FFFFFFF;
  8000cb:	c7 45 cc ff ff ff 7f 	movl   $0x7fffffff,-0x34(%ebp)
	short *shortArr, *shortArr2 ;
	int *intArr;
	struct MyStruct *structArr ;
	int lastIndexOfByte, lastIndexOfByte2, lastIndexOfShort, lastIndexOfShort2, lastIndexOfInt, lastIndexOfStruct;
	/*Dummy malloc to enforce the UHEAP initializations*/
	malloc(0);
  8000d2:	83 ec 0c             	sub    $0xc,%esp
  8000d5:	6a 00                	push   $0x0
  8000d7:	e8 94 2a 00 00       	call   802b70 <malloc>
  8000dc:	83 c4 10             	add    $0x10,%esp
	/*=================================================*/

	int start_freeFrames = sys_calculate_free_frames() ;
  8000df:	e8 98 2e 00 00       	call   802f7c <sys_calculate_free_frames>
  8000e4:	89 45 c8             	mov    %eax,-0x38(%ebp)

	void* ptr_allocations[20] = {0};
  8000e7:	8d 95 68 fe ff ff    	lea    -0x198(%ebp),%edx
  8000ed:	b9 14 00 00 00       	mov    $0x14,%ecx
  8000f2:	b8 00 00 00 00       	mov    $0x0,%eax
  8000f7:	89 d7                	mov    %edx,%edi
  8000f9:	f3 ab                	rep stos %eax,%es:(%edi)
	{
		//2 MB
		int usedDiskPages = sys_pf_calculate_allocated_pages() ;
  8000fb:	e8 1c 2f 00 00       	call   80301c <sys_pf_calculate_allocated_pages>
  800100:	89 45 c4             	mov    %eax,-0x3c(%ebp)
		ptr_allocations[0] = malloc(2*Mega-kilo);
  800103:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800106:	01 c0                	add    %eax,%eax
  800108:	2b 45 dc             	sub    -0x24(%ebp),%eax
  80010b:	83 ec 0c             	sub    $0xc,%esp
  80010e:	50                   	push   %eax
  80010f:	e8 5c 2a 00 00       	call   802b70 <malloc>
  800114:	83 c4 10             	add    $0x10,%esp
  800117:	89 85 68 fe ff ff    	mov    %eax,-0x198(%ebp)
		if ((uint32) ptr_allocations[0] <  (USER_HEAP_START) || (uint32) ptr_allocations[0] > (USER_HEAP_START+PAGE_SIZE)) panic("Wrong start address for the allocated space... check return address of malloc & updating of heap ptr");
  80011d:	8b 85 68 fe ff ff    	mov    -0x198(%ebp),%eax
  800123:	85 c0                	test   %eax,%eax
  800125:	79 0d                	jns    800134 <_main+0xfc>
  800127:	8b 85 68 fe ff ff    	mov    -0x198(%ebp),%eax
  80012d:	3d 00 10 00 80       	cmp    $0x80001000,%eax
  800132:	76 14                	jbe    800148 <_main+0x110>
  800134:	83 ec 04             	sub    $0x4,%esp
  800137:	68 b0 47 80 00       	push   $0x8047b0
  80013c:	6a 3a                	push   $0x3a
  80013e:	68 9c 47 80 00       	push   $0x80479c
  800143:	e8 e2 17 00 00       	call   80192a <_panic>
		if ((sys_pf_calculate_allocated_pages() - usedDiskPages) != 0) panic("Extra or less pages are allocated in PageFile");
  800148:	e8 cf 2e 00 00       	call   80301c <sys_pf_calculate_allocated_pages>
  80014d:	3b 45 c4             	cmp    -0x3c(%ebp),%eax
  800150:	74 14                	je     800166 <_main+0x12e>
  800152:	83 ec 04             	sub    $0x4,%esp
  800155:	68 18 48 80 00       	push   $0x804818
  80015a:	6a 3b                	push   $0x3b
  80015c:	68 9c 47 80 00       	push   $0x80479c
  800161:	e8 c4 17 00 00       	call   80192a <_panic>

		int freeFrames = sys_calculate_free_frames() ;
  800166:	e8 11 2e 00 00       	call   802f7c <sys_calculate_free_frames>
  80016b:	89 45 c0             	mov    %eax,-0x40(%ebp)
		lastIndexOfByte = (2*Mega-kilo)/sizeof(char) - 1;
  80016e:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800171:	01 c0                	add    %eax,%eax
  800173:	2b 45 dc             	sub    -0x24(%ebp),%eax
  800176:	48                   	dec    %eax
  800177:	89 45 bc             	mov    %eax,-0x44(%ebp)
		byteArr = (char *) ptr_allocations[0];
  80017a:	8b 85 68 fe ff ff    	mov    -0x198(%ebp),%eax
  800180:	89 45 b8             	mov    %eax,-0x48(%ebp)
		byteArr[0] = minByte ;
  800183:	8b 45 b8             	mov    -0x48(%ebp),%eax
  800186:	8a 55 db             	mov    -0x25(%ebp),%dl
  800189:	88 10                	mov    %dl,(%eax)
		byteArr[lastIndexOfByte] = maxByte ;
  80018b:	8b 55 bc             	mov    -0x44(%ebp),%edx
  80018e:	8b 45 b8             	mov    -0x48(%ebp),%eax
  800191:	01 c2                	add    %eax,%edx
  800193:	8a 45 da             	mov    -0x26(%ebp),%al
  800196:	88 02                	mov    %al,(%edx)
		if ((freeFrames - sys_calculate_free_frames()) != 2 + 1) panic("Wrong allocation: pages are not loaded successfully into memory/WS");
  800198:	8b 5d c0             	mov    -0x40(%ebp),%ebx
  80019b:	e8 dc 2d 00 00       	call   802f7c <sys_calculate_free_frames>
  8001a0:	29 c3                	sub    %eax,%ebx
  8001a2:	89 d8                	mov    %ebx,%eax
  8001a4:	83 f8 03             	cmp    $0x3,%eax
  8001a7:	74 14                	je     8001bd <_main+0x185>
  8001a9:	83 ec 04             	sub    $0x4,%esp
  8001ac:	68 48 48 80 00       	push   $0x804848
  8001b1:	6a 42                	push   $0x42
  8001b3:	68 9c 47 80 00       	push   $0x80479c
  8001b8:	e8 6d 17 00 00       	call   80192a <_panic>
		int var;
		int found = 0;
  8001bd:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		for (var = 0; var < (myEnv->page_WS_max_size); ++var)
  8001c4:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  8001cb:	e9 82 00 00 00       	jmp    800252 <_main+0x21a>
		{
			if(ROUNDDOWN(myEnv->__uptr_pws[var].virtual_address,PAGE_SIZE) == ROUNDDOWN((uint32)(&(byteArr[0])), PAGE_SIZE))
  8001d0:	a1 20 60 80 00       	mov    0x806020,%eax
  8001d5:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  8001db:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8001de:	89 d0                	mov    %edx,%eax
  8001e0:	01 c0                	add    %eax,%eax
  8001e2:	01 d0                	add    %edx,%eax
  8001e4:	c1 e0 03             	shl    $0x3,%eax
  8001e7:	01 c8                	add    %ecx,%eax
  8001e9:	8b 00                	mov    (%eax),%eax
  8001eb:	89 45 b4             	mov    %eax,-0x4c(%ebp)
  8001ee:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  8001f1:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8001f6:	89 c2                	mov    %eax,%edx
  8001f8:	8b 45 b8             	mov    -0x48(%ebp),%eax
  8001fb:	89 45 b0             	mov    %eax,-0x50(%ebp)
  8001fe:	8b 45 b0             	mov    -0x50(%ebp),%eax
  800201:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800206:	39 c2                	cmp    %eax,%edx
  800208:	75 03                	jne    80020d <_main+0x1d5>
				found++;
  80020a:	ff 45 e8             	incl   -0x18(%ebp)
			if(ROUNDDOWN(myEnv->__uptr_pws[var].virtual_address,PAGE_SIZE) == ROUNDDOWN((uint32)(&(byteArr[lastIndexOfByte])), PAGE_SIZE))
  80020d:	a1 20 60 80 00       	mov    0x806020,%eax
  800212:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  800218:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80021b:	89 d0                	mov    %edx,%eax
  80021d:	01 c0                	add    %eax,%eax
  80021f:	01 d0                	add    %edx,%eax
  800221:	c1 e0 03             	shl    $0x3,%eax
  800224:	01 c8                	add    %ecx,%eax
  800226:	8b 00                	mov    (%eax),%eax
  800228:	89 45 ac             	mov    %eax,-0x54(%ebp)
  80022b:	8b 45 ac             	mov    -0x54(%ebp),%eax
  80022e:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800233:	89 c1                	mov    %eax,%ecx
  800235:	8b 55 bc             	mov    -0x44(%ebp),%edx
  800238:	8b 45 b8             	mov    -0x48(%ebp),%eax
  80023b:	01 d0                	add    %edx,%eax
  80023d:	89 45 a8             	mov    %eax,-0x58(%ebp)
  800240:	8b 45 a8             	mov    -0x58(%ebp),%eax
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
  800252:	a1 20 60 80 00       	mov    0x806020,%eax
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
  80026e:	68 8c 48 80 00       	push   $0x80488c
  800273:	6a 4c                	push   $0x4c
  800275:	68 9c 47 80 00       	push   $0x80479c
  80027a:	e8 ab 16 00 00       	call   80192a <_panic>

		//2 MB
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  80027f:	e8 98 2d 00 00       	call   80301c <sys_pf_calculate_allocated_pages>
  800284:	89 45 c4             	mov    %eax,-0x3c(%ebp)
		ptr_allocations[1] = malloc(2*Mega-kilo);
  800287:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80028a:	01 c0                	add    %eax,%eax
  80028c:	2b 45 dc             	sub    -0x24(%ebp),%eax
  80028f:	83 ec 0c             	sub    $0xc,%esp
  800292:	50                   	push   %eax
  800293:	e8 d8 28 00 00       	call   802b70 <malloc>
  800298:	83 c4 10             	add    $0x10,%esp
  80029b:	89 85 6c fe ff ff    	mov    %eax,-0x194(%ebp)
		if ((uint32) ptr_allocations[1] < (USER_HEAP_START + 2*Mega) || (uint32) ptr_allocations[1] > (USER_HEAP_START+ 2*Mega+PAGE_SIZE)) panic("Wrong start address for the allocated space... check return address of malloc & updating of heap ptr");
  8002a1:	8b 85 6c fe ff ff    	mov    -0x194(%ebp),%eax
  8002a7:	89 c2                	mov    %eax,%edx
  8002a9:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8002ac:	01 c0                	add    %eax,%eax
  8002ae:	05 00 00 00 80       	add    $0x80000000,%eax
  8002b3:	39 c2                	cmp    %eax,%edx
  8002b5:	72 16                	jb     8002cd <_main+0x295>
  8002b7:	8b 85 6c fe ff ff    	mov    -0x194(%ebp),%eax
  8002bd:	89 c2                	mov    %eax,%edx
  8002bf:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8002c2:	01 c0                	add    %eax,%eax
  8002c4:	2d 00 f0 ff 7f       	sub    $0x7ffff000,%eax
  8002c9:	39 c2                	cmp    %eax,%edx
  8002cb:	76 14                	jbe    8002e1 <_main+0x2a9>
  8002cd:	83 ec 04             	sub    $0x4,%esp
  8002d0:	68 b0 47 80 00       	push   $0x8047b0
  8002d5:	6a 51                	push   $0x51
  8002d7:	68 9c 47 80 00       	push   $0x80479c
  8002dc:	e8 49 16 00 00       	call   80192a <_panic>
		if ((sys_pf_calculate_allocated_pages() - usedDiskPages) != 0) panic("Extra or less pages are allocated in PageFile");
  8002e1:	e8 36 2d 00 00       	call   80301c <sys_pf_calculate_allocated_pages>
  8002e6:	3b 45 c4             	cmp    -0x3c(%ebp),%eax
  8002e9:	74 14                	je     8002ff <_main+0x2c7>
  8002eb:	83 ec 04             	sub    $0x4,%esp
  8002ee:	68 18 48 80 00       	push   $0x804818
  8002f3:	6a 52                	push   $0x52
  8002f5:	68 9c 47 80 00       	push   $0x80479c
  8002fa:	e8 2b 16 00 00       	call   80192a <_panic>

		freeFrames = sys_calculate_free_frames() ;
  8002ff:	e8 78 2c 00 00       	call   802f7c <sys_calculate_free_frames>
  800304:	89 45 c0             	mov    %eax,-0x40(%ebp)
		shortArr = (short *) ptr_allocations[1];
  800307:	8b 85 6c fe ff ff    	mov    -0x194(%ebp),%eax
  80030d:	89 45 a4             	mov    %eax,-0x5c(%ebp)
		lastIndexOfShort = (2*Mega-kilo)/sizeof(short) - 1;
  800310:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800313:	01 c0                	add    %eax,%eax
  800315:	2b 45 dc             	sub    -0x24(%ebp),%eax
  800318:	d1 e8                	shr    %eax
  80031a:	48                   	dec    %eax
  80031b:	89 45 a0             	mov    %eax,-0x60(%ebp)
		shortArr[0] = minShort;
  80031e:	8b 55 a4             	mov    -0x5c(%ebp),%edx
  800321:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800324:	66 89 02             	mov    %ax,(%edx)
		shortArr[lastIndexOfShort] = maxShort;
  800327:	8b 45 a0             	mov    -0x60(%ebp),%eax
  80032a:	01 c0                	add    %eax,%eax
  80032c:	89 c2                	mov    %eax,%edx
  80032e:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  800331:	01 c2                	add    %eax,%edx
  800333:	66 8b 45 d6          	mov    -0x2a(%ebp),%ax
  800337:	66 89 02             	mov    %ax,(%edx)
		if ((freeFrames - sys_calculate_free_frames()) != 2 ) panic("Wrong allocation: pages are not loaded successfully into memory/WS");
  80033a:	8b 5d c0             	mov    -0x40(%ebp),%ebx
  80033d:	e8 3a 2c 00 00       	call   802f7c <sys_calculate_free_frames>
  800342:	29 c3                	sub    %eax,%ebx
  800344:	89 d8                	mov    %ebx,%eax
  800346:	83 f8 02             	cmp    $0x2,%eax
  800349:	74 14                	je     80035f <_main+0x327>
  80034b:	83 ec 04             	sub    $0x4,%esp
  80034e:	68 48 48 80 00       	push   $0x804848
  800353:	6a 59                	push   $0x59
  800355:	68 9c 47 80 00       	push   $0x80479c
  80035a:	e8 cb 15 00 00       	call   80192a <_panic>
		found = 0;
  80035f:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		for (var = 0; var < (myEnv->page_WS_max_size); ++var)
  800366:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  80036d:	e9 86 00 00 00       	jmp    8003f8 <_main+0x3c0>
		{
			if(ROUNDDOWN(myEnv->__uptr_pws[var].virtual_address,PAGE_SIZE) == ROUNDDOWN((uint32)(&(shortArr[0])), PAGE_SIZE))
  800372:	a1 20 60 80 00       	mov    0x806020,%eax
  800377:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  80037d:	8b 55 ec             	mov    -0x14(%ebp),%edx
  800380:	89 d0                	mov    %edx,%eax
  800382:	01 c0                	add    %eax,%eax
  800384:	01 d0                	add    %edx,%eax
  800386:	c1 e0 03             	shl    $0x3,%eax
  800389:	01 c8                	add    %ecx,%eax
  80038b:	8b 00                	mov    (%eax),%eax
  80038d:	89 45 9c             	mov    %eax,-0x64(%ebp)
  800390:	8b 45 9c             	mov    -0x64(%ebp),%eax
  800393:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800398:	89 c2                	mov    %eax,%edx
  80039a:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  80039d:	89 45 98             	mov    %eax,-0x68(%ebp)
  8003a0:	8b 45 98             	mov    -0x68(%ebp),%eax
  8003a3:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8003a8:	39 c2                	cmp    %eax,%edx
  8003aa:	75 03                	jne    8003af <_main+0x377>
				found++;
  8003ac:	ff 45 e8             	incl   -0x18(%ebp)
			if(ROUNDDOWN(myEnv->__uptr_pws[var].virtual_address,PAGE_SIZE) == ROUNDDOWN((uint32)(&(shortArr[lastIndexOfShort])), PAGE_SIZE))
  8003af:	a1 20 60 80 00       	mov    0x806020,%eax
  8003b4:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  8003ba:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8003bd:	89 d0                	mov    %edx,%eax
  8003bf:	01 c0                	add    %eax,%eax
  8003c1:	01 d0                	add    %edx,%eax
  8003c3:	c1 e0 03             	shl    $0x3,%eax
  8003c6:	01 c8                	add    %ecx,%eax
  8003c8:	8b 00                	mov    (%eax),%eax
  8003ca:	89 45 94             	mov    %eax,-0x6c(%ebp)
  8003cd:	8b 45 94             	mov    -0x6c(%ebp),%eax
  8003d0:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8003d5:	89 c2                	mov    %eax,%edx
  8003d7:	8b 45 a0             	mov    -0x60(%ebp),%eax
  8003da:	01 c0                	add    %eax,%eax
  8003dc:	89 c1                	mov    %eax,%ecx
  8003de:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  8003e1:	01 c8                	add    %ecx,%eax
  8003e3:	89 45 90             	mov    %eax,-0x70(%ebp)
  8003e6:	8b 45 90             	mov    -0x70(%ebp),%eax
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
  8003f8:	a1 20 60 80 00       	mov    0x806020,%eax
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
  800414:	68 8c 48 80 00       	push   $0x80488c
  800419:	6a 62                	push   $0x62
  80041b:	68 9c 47 80 00       	push   $0x80479c
  800420:	e8 05 15 00 00       	call   80192a <_panic>

		//2 KB
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  800425:	e8 f2 2b 00 00       	call   80301c <sys_pf_calculate_allocated_pages>
  80042a:	89 45 c4             	mov    %eax,-0x3c(%ebp)
		ptr_allocations[2] = malloc(2*kilo);
  80042d:	8b 45 dc             	mov    -0x24(%ebp),%eax
  800430:	01 c0                	add    %eax,%eax
  800432:	83 ec 0c             	sub    $0xc,%esp
  800435:	50                   	push   %eax
  800436:	e8 35 27 00 00       	call   802b70 <malloc>
  80043b:	83 c4 10             	add    $0x10,%esp
  80043e:	89 85 70 fe ff ff    	mov    %eax,-0x190(%ebp)
		if ((uint32) ptr_allocations[2] < (USER_HEAP_START + 4*Mega) || (uint32) ptr_allocations[2] > (USER_HEAP_START+ 4*Mega+PAGE_SIZE)) panic("Wrong start address for the allocated space... check return address of malloc & updating of heap ptr");
  800444:	8b 85 70 fe ff ff    	mov    -0x190(%ebp),%eax
  80044a:	89 c2                	mov    %eax,%edx
  80044c:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80044f:	c1 e0 02             	shl    $0x2,%eax
  800452:	05 00 00 00 80       	add    $0x80000000,%eax
  800457:	39 c2                	cmp    %eax,%edx
  800459:	72 17                	jb     800472 <_main+0x43a>
  80045b:	8b 85 70 fe ff ff    	mov    -0x190(%ebp),%eax
  800461:	89 c2                	mov    %eax,%edx
  800463:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800466:	c1 e0 02             	shl    $0x2,%eax
  800469:	2d 00 f0 ff 7f       	sub    $0x7ffff000,%eax
  80046e:	39 c2                	cmp    %eax,%edx
  800470:	76 14                	jbe    800486 <_main+0x44e>
  800472:	83 ec 04             	sub    $0x4,%esp
  800475:	68 b0 47 80 00       	push   $0x8047b0
  80047a:	6a 67                	push   $0x67
  80047c:	68 9c 47 80 00       	push   $0x80479c
  800481:	e8 a4 14 00 00       	call   80192a <_panic>
		if ((sys_pf_calculate_allocated_pages() - usedDiskPages) != 0) panic("Extra or less pages are allocated in PageFile");
  800486:	e8 91 2b 00 00       	call   80301c <sys_pf_calculate_allocated_pages>
  80048b:	3b 45 c4             	cmp    -0x3c(%ebp),%eax
  80048e:	74 14                	je     8004a4 <_main+0x46c>
  800490:	83 ec 04             	sub    $0x4,%esp
  800493:	68 18 48 80 00       	push   $0x804818
  800498:	6a 68                	push   $0x68
  80049a:	68 9c 47 80 00       	push   $0x80479c
  80049f:	e8 86 14 00 00       	call   80192a <_panic>

		freeFrames = sys_calculate_free_frames() ;
  8004a4:	e8 d3 2a 00 00       	call   802f7c <sys_calculate_free_frames>
  8004a9:	89 45 c0             	mov    %eax,-0x40(%ebp)
		intArr = (int *) ptr_allocations[2];
  8004ac:	8b 85 70 fe ff ff    	mov    -0x190(%ebp),%eax
  8004b2:	89 45 8c             	mov    %eax,-0x74(%ebp)
		lastIndexOfInt = (2*kilo)/sizeof(int) - 1;
  8004b5:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8004b8:	01 c0                	add    %eax,%eax
  8004ba:	c1 e8 02             	shr    $0x2,%eax
  8004bd:	48                   	dec    %eax
  8004be:	89 45 88             	mov    %eax,-0x78(%ebp)
		intArr[0] = minInt;
  8004c1:	8b 45 8c             	mov    -0x74(%ebp),%eax
  8004c4:	8b 55 d0             	mov    -0x30(%ebp),%edx
  8004c7:	89 10                	mov    %edx,(%eax)
		intArr[lastIndexOfInt] = maxInt;
  8004c9:	8b 45 88             	mov    -0x78(%ebp),%eax
  8004cc:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8004d3:	8b 45 8c             	mov    -0x74(%ebp),%eax
  8004d6:	01 c2                	add    %eax,%edx
  8004d8:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8004db:	89 02                	mov    %eax,(%edx)
		if ((freeFrames - sys_calculate_free_frames()) != 1 + 1) panic("Wrong allocation: pages are not loaded successfully into memory/WS");
  8004dd:	8b 5d c0             	mov    -0x40(%ebp),%ebx
  8004e0:	e8 97 2a 00 00       	call   802f7c <sys_calculate_free_frames>
  8004e5:	29 c3                	sub    %eax,%ebx
  8004e7:	89 d8                	mov    %ebx,%eax
  8004e9:	83 f8 02             	cmp    $0x2,%eax
  8004ec:	74 14                	je     800502 <_main+0x4ca>
  8004ee:	83 ec 04             	sub    $0x4,%esp
  8004f1:	68 48 48 80 00       	push   $0x804848
  8004f6:	6a 6f                	push   $0x6f
  8004f8:	68 9c 47 80 00       	push   $0x80479c
  8004fd:	e8 28 14 00 00       	call   80192a <_panic>
		found = 0;
  800502:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		for (var = 0; var < (myEnv->page_WS_max_size); ++var)
  800509:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  800510:	e9 95 00 00 00       	jmp    8005aa <_main+0x572>
		{
			if(ROUNDDOWN(myEnv->__uptr_pws[var].virtual_address,PAGE_SIZE) == ROUNDDOWN((uint32)(&(intArr[0])), PAGE_SIZE))
  800515:	a1 20 60 80 00       	mov    0x806020,%eax
  80051a:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  800520:	8b 55 ec             	mov    -0x14(%ebp),%edx
  800523:	89 d0                	mov    %edx,%eax
  800525:	01 c0                	add    %eax,%eax
  800527:	01 d0                	add    %edx,%eax
  800529:	c1 e0 03             	shl    $0x3,%eax
  80052c:	01 c8                	add    %ecx,%eax
  80052e:	8b 00                	mov    (%eax),%eax
  800530:	89 45 84             	mov    %eax,-0x7c(%ebp)
  800533:	8b 45 84             	mov    -0x7c(%ebp),%eax
  800536:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80053b:	89 c2                	mov    %eax,%edx
  80053d:	8b 45 8c             	mov    -0x74(%ebp),%eax
  800540:	89 45 80             	mov    %eax,-0x80(%ebp)
  800543:	8b 45 80             	mov    -0x80(%ebp),%eax
  800546:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80054b:	39 c2                	cmp    %eax,%edx
  80054d:	75 03                	jne    800552 <_main+0x51a>
				found++;
  80054f:	ff 45 e8             	incl   -0x18(%ebp)
			if(ROUNDDOWN(myEnv->__uptr_pws[var].virtual_address,PAGE_SIZE) == ROUNDDOWN((uint32)(&(intArr[lastIndexOfInt])), PAGE_SIZE))
  800552:	a1 20 60 80 00       	mov    0x806020,%eax
  800557:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  80055d:	8b 55 ec             	mov    -0x14(%ebp),%edx
  800560:	89 d0                	mov    %edx,%eax
  800562:	01 c0                	add    %eax,%eax
  800564:	01 d0                	add    %edx,%eax
  800566:	c1 e0 03             	shl    $0x3,%eax
  800569:	01 c8                	add    %ecx,%eax
  80056b:	8b 00                	mov    (%eax),%eax
  80056d:	89 85 7c ff ff ff    	mov    %eax,-0x84(%ebp)
  800573:	8b 85 7c ff ff ff    	mov    -0x84(%ebp),%eax
  800579:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80057e:	89 c2                	mov    %eax,%edx
  800580:	8b 45 88             	mov    -0x78(%ebp),%eax
  800583:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  80058a:	8b 45 8c             	mov    -0x74(%ebp),%eax
  80058d:	01 c8                	add    %ecx,%eax
  80058f:	89 85 78 ff ff ff    	mov    %eax,-0x88(%ebp)
  800595:	8b 85 78 ff ff ff    	mov    -0x88(%ebp),%eax
  80059b:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8005a0:	39 c2                	cmp    %eax,%edx
  8005a2:	75 03                	jne    8005a7 <_main+0x56f>
				found++;
  8005a4:	ff 45 e8             	incl   -0x18(%ebp)
		lastIndexOfInt = (2*kilo)/sizeof(int) - 1;
		intArr[0] = minInt;
		intArr[lastIndexOfInt] = maxInt;
		if ((freeFrames - sys_calculate_free_frames()) != 1 + 1) panic("Wrong allocation: pages are not loaded successfully into memory/WS");
		found = 0;
		for (var = 0; var < (myEnv->page_WS_max_size); ++var)
  8005a7:	ff 45 ec             	incl   -0x14(%ebp)
  8005aa:	a1 20 60 80 00       	mov    0x806020,%eax
  8005af:	8b 50 74             	mov    0x74(%eax),%edx
  8005b2:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8005b5:	39 c2                	cmp    %eax,%edx
  8005b7:	0f 87 58 ff ff ff    	ja     800515 <_main+0x4dd>
			if(ROUNDDOWN(myEnv->__uptr_pws[var].virtual_address,PAGE_SIZE) == ROUNDDOWN((uint32)(&(intArr[0])), PAGE_SIZE))
				found++;
			if(ROUNDDOWN(myEnv->__uptr_pws[var].virtual_address,PAGE_SIZE) == ROUNDDOWN((uint32)(&(intArr[lastIndexOfInt])), PAGE_SIZE))
				found++;
		}
		if (found != 2) panic("malloc: page is not added to WS");
  8005bd:	83 7d e8 02          	cmpl   $0x2,-0x18(%ebp)
  8005c1:	74 14                	je     8005d7 <_main+0x59f>
  8005c3:	83 ec 04             	sub    $0x4,%esp
  8005c6:	68 8c 48 80 00       	push   $0x80488c
  8005cb:	6a 78                	push   $0x78
  8005cd:	68 9c 47 80 00       	push   $0x80479c
  8005d2:	e8 53 13 00 00       	call   80192a <_panic>

		//2 KB
		freeFrames = sys_calculate_free_frames() ;
  8005d7:	e8 a0 29 00 00       	call   802f7c <sys_calculate_free_frames>
  8005dc:	89 45 c0             	mov    %eax,-0x40(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  8005df:	e8 38 2a 00 00       	call   80301c <sys_pf_calculate_allocated_pages>
  8005e4:	89 45 c4             	mov    %eax,-0x3c(%ebp)
		ptr_allocations[3] = malloc(2*kilo);
  8005e7:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8005ea:	01 c0                	add    %eax,%eax
  8005ec:	83 ec 0c             	sub    $0xc,%esp
  8005ef:	50                   	push   %eax
  8005f0:	e8 7b 25 00 00       	call   802b70 <malloc>
  8005f5:	83 c4 10             	add    $0x10,%esp
  8005f8:	89 85 74 fe ff ff    	mov    %eax,-0x18c(%ebp)
		if ((uint32) ptr_allocations[3] < (USER_HEAP_START + 4*Mega + 4*kilo) || (uint32) ptr_allocations[3] > (USER_HEAP_START+ 4*Mega + 4*kilo +PAGE_SIZE)) panic("Wrong start address for the allocated space... check return address of malloc & updating of heap ptr");
  8005fe:	8b 85 74 fe ff ff    	mov    -0x18c(%ebp),%eax
  800604:	89 c2                	mov    %eax,%edx
  800606:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800609:	c1 e0 02             	shl    $0x2,%eax
  80060c:	89 c1                	mov    %eax,%ecx
  80060e:	8b 45 dc             	mov    -0x24(%ebp),%eax
  800611:	c1 e0 02             	shl    $0x2,%eax
  800614:	01 c8                	add    %ecx,%eax
  800616:	05 00 00 00 80       	add    $0x80000000,%eax
  80061b:	39 c2                	cmp    %eax,%edx
  80061d:	72 21                	jb     800640 <_main+0x608>
  80061f:	8b 85 74 fe ff ff    	mov    -0x18c(%ebp),%eax
  800625:	89 c2                	mov    %eax,%edx
  800627:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80062a:	c1 e0 02             	shl    $0x2,%eax
  80062d:	89 c1                	mov    %eax,%ecx
  80062f:	8b 45 dc             	mov    -0x24(%ebp),%eax
  800632:	c1 e0 02             	shl    $0x2,%eax
  800635:	01 c8                	add    %ecx,%eax
  800637:	2d 00 f0 ff 7f       	sub    $0x7ffff000,%eax
  80063c:	39 c2                	cmp    %eax,%edx
  80063e:	76 14                	jbe    800654 <_main+0x61c>
  800640:	83 ec 04             	sub    $0x4,%esp
  800643:	68 b0 47 80 00       	push   $0x8047b0
  800648:	6a 7e                	push   $0x7e
  80064a:	68 9c 47 80 00       	push   $0x80479c
  80064f:	e8 d6 12 00 00       	call   80192a <_panic>
		if ((sys_pf_calculate_allocated_pages() - usedDiskPages) != 0) panic("Extra or less pages are allocated in PageFile");
  800654:	e8 c3 29 00 00       	call   80301c <sys_pf_calculate_allocated_pages>
  800659:	3b 45 c4             	cmp    -0x3c(%ebp),%eax
  80065c:	74 14                	je     800672 <_main+0x63a>
  80065e:	83 ec 04             	sub    $0x4,%esp
  800661:	68 18 48 80 00       	push   $0x804818
  800666:	6a 7f                	push   $0x7f
  800668:	68 9c 47 80 00       	push   $0x80479c
  80066d:	e8 b8 12 00 00       	call   80192a <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 0) panic("Wrong allocation: ");

		//7 KB
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  800672:	e8 a5 29 00 00       	call   80301c <sys_pf_calculate_allocated_pages>
  800677:	89 45 c4             	mov    %eax,-0x3c(%ebp)
		ptr_allocations[4] = malloc(7*kilo);
  80067a:	8b 55 dc             	mov    -0x24(%ebp),%edx
  80067d:	89 d0                	mov    %edx,%eax
  80067f:	01 c0                	add    %eax,%eax
  800681:	01 d0                	add    %edx,%eax
  800683:	01 c0                	add    %eax,%eax
  800685:	01 d0                	add    %edx,%eax
  800687:	83 ec 0c             	sub    $0xc,%esp
  80068a:	50                   	push   %eax
  80068b:	e8 e0 24 00 00       	call   802b70 <malloc>
  800690:	83 c4 10             	add    $0x10,%esp
  800693:	89 85 78 fe ff ff    	mov    %eax,-0x188(%ebp)
		if ((uint32) ptr_allocations[4] < (USER_HEAP_START + 4*Mega + 8*kilo)|| (uint32) ptr_allocations[4] > (USER_HEAP_START+ 4*Mega + 8*kilo +PAGE_SIZE)) panic("Wrong start address for the allocated space... check return address of malloc & updating of heap ptr");
  800699:	8b 85 78 fe ff ff    	mov    -0x188(%ebp),%eax
  80069f:	89 c2                	mov    %eax,%edx
  8006a1:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8006a4:	c1 e0 02             	shl    $0x2,%eax
  8006a7:	89 c1                	mov    %eax,%ecx
  8006a9:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8006ac:	c1 e0 03             	shl    $0x3,%eax
  8006af:	01 c8                	add    %ecx,%eax
  8006b1:	05 00 00 00 80       	add    $0x80000000,%eax
  8006b6:	39 c2                	cmp    %eax,%edx
  8006b8:	72 21                	jb     8006db <_main+0x6a3>
  8006ba:	8b 85 78 fe ff ff    	mov    -0x188(%ebp),%eax
  8006c0:	89 c2                	mov    %eax,%edx
  8006c2:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8006c5:	c1 e0 02             	shl    $0x2,%eax
  8006c8:	89 c1                	mov    %eax,%ecx
  8006ca:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8006cd:	c1 e0 03             	shl    $0x3,%eax
  8006d0:	01 c8                	add    %ecx,%eax
  8006d2:	2d 00 f0 ff 7f       	sub    $0x7ffff000,%eax
  8006d7:	39 c2                	cmp    %eax,%edx
  8006d9:	76 17                	jbe    8006f2 <_main+0x6ba>
  8006db:	83 ec 04             	sub    $0x4,%esp
  8006de:	68 b0 47 80 00       	push   $0x8047b0
  8006e3:	68 85 00 00 00       	push   $0x85
  8006e8:	68 9c 47 80 00       	push   $0x80479c
  8006ed:	e8 38 12 00 00       	call   80192a <_panic>
		if ((sys_pf_calculate_allocated_pages() - usedDiskPages) != 0) panic("Extra or less pages are allocated in PageFile");
  8006f2:	e8 25 29 00 00       	call   80301c <sys_pf_calculate_allocated_pages>
  8006f7:	3b 45 c4             	cmp    -0x3c(%ebp),%eax
  8006fa:	74 17                	je     800713 <_main+0x6db>
  8006fc:	83 ec 04             	sub    $0x4,%esp
  8006ff:	68 18 48 80 00       	push   $0x804818
  800704:	68 86 00 00 00       	push   $0x86
  800709:	68 9c 47 80 00       	push   $0x80479c
  80070e:	e8 17 12 00 00       	call   80192a <_panic>

		freeFrames = sys_calculate_free_frames() ;
  800713:	e8 64 28 00 00       	call   802f7c <sys_calculate_free_frames>
  800718:	89 45 c0             	mov    %eax,-0x40(%ebp)
		structArr = (struct MyStruct *) ptr_allocations[4];
  80071b:	8b 85 78 fe ff ff    	mov    -0x188(%ebp),%eax
  800721:	89 85 74 ff ff ff    	mov    %eax,-0x8c(%ebp)
		lastIndexOfStruct = (7*kilo)/sizeof(struct MyStruct) - 1;
  800727:	8b 55 dc             	mov    -0x24(%ebp),%edx
  80072a:	89 d0                	mov    %edx,%eax
  80072c:	01 c0                	add    %eax,%eax
  80072e:	01 d0                	add    %edx,%eax
  800730:	01 c0                	add    %eax,%eax
  800732:	01 d0                	add    %edx,%eax
  800734:	c1 e8 03             	shr    $0x3,%eax
  800737:	48                   	dec    %eax
  800738:	89 85 70 ff ff ff    	mov    %eax,-0x90(%ebp)
		structArr[0].a = minByte; structArr[0].b = minShort; structArr[0].c = minInt;
  80073e:	8b 85 74 ff ff ff    	mov    -0x8c(%ebp),%eax
  800744:	8a 55 db             	mov    -0x25(%ebp),%dl
  800747:	88 10                	mov    %dl,(%eax)
  800749:	8b 95 74 ff ff ff    	mov    -0x8c(%ebp),%edx
  80074f:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800752:	66 89 42 02          	mov    %ax,0x2(%edx)
  800756:	8b 85 74 ff ff ff    	mov    -0x8c(%ebp),%eax
  80075c:	8b 55 d0             	mov    -0x30(%ebp),%edx
  80075f:	89 50 04             	mov    %edx,0x4(%eax)
		structArr[lastIndexOfStruct].a = maxByte; structArr[lastIndexOfStruct].b = maxShort; structArr[lastIndexOfStruct].c = maxInt;
  800762:	8b 85 70 ff ff ff    	mov    -0x90(%ebp),%eax
  800768:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
  80076f:	8b 85 74 ff ff ff    	mov    -0x8c(%ebp),%eax
  800775:	01 c2                	add    %eax,%edx
  800777:	8a 45 da             	mov    -0x26(%ebp),%al
  80077a:	88 02                	mov    %al,(%edx)
  80077c:	8b 85 70 ff ff ff    	mov    -0x90(%ebp),%eax
  800782:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
  800789:	8b 85 74 ff ff ff    	mov    -0x8c(%ebp),%eax
  80078f:	01 c2                	add    %eax,%edx
  800791:	66 8b 45 d6          	mov    -0x2a(%ebp),%ax
  800795:	66 89 42 02          	mov    %ax,0x2(%edx)
  800799:	8b 85 70 ff ff ff    	mov    -0x90(%ebp),%eax
  80079f:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
  8007a6:	8b 85 74 ff ff ff    	mov    -0x8c(%ebp),%eax
  8007ac:	01 c2                	add    %eax,%edx
  8007ae:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8007b1:	89 42 04             	mov    %eax,0x4(%edx)
		if ((freeFrames - sys_calculate_free_frames()) != 2) panic("Wrong allocation: pages are not loaded successfully into memory/WS");
  8007b4:	8b 5d c0             	mov    -0x40(%ebp),%ebx
  8007b7:	e8 c0 27 00 00       	call   802f7c <sys_calculate_free_frames>
  8007bc:	29 c3                	sub    %eax,%ebx
  8007be:	89 d8                	mov    %ebx,%eax
  8007c0:	83 f8 02             	cmp    $0x2,%eax
  8007c3:	74 17                	je     8007dc <_main+0x7a4>
  8007c5:	83 ec 04             	sub    $0x4,%esp
  8007c8:	68 48 48 80 00       	push   $0x804848
  8007cd:	68 8d 00 00 00       	push   $0x8d
  8007d2:	68 9c 47 80 00       	push   $0x80479c
  8007d7:	e8 4e 11 00 00       	call   80192a <_panic>
		found = 0;
  8007dc:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		for (var = 0; var < (myEnv->page_WS_max_size); ++var)
  8007e3:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  8007ea:	e9 aa 00 00 00       	jmp    800899 <_main+0x861>
		{
			if(ROUNDDOWN(myEnv->__uptr_pws[var].virtual_address,PAGE_SIZE) == ROUNDDOWN((uint32)(&(structArr[0])), PAGE_SIZE))
  8007ef:	a1 20 60 80 00       	mov    0x806020,%eax
  8007f4:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  8007fa:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8007fd:	89 d0                	mov    %edx,%eax
  8007ff:	01 c0                	add    %eax,%eax
  800801:	01 d0                	add    %edx,%eax
  800803:	c1 e0 03             	shl    $0x3,%eax
  800806:	01 c8                	add    %ecx,%eax
  800808:	8b 00                	mov    (%eax),%eax
  80080a:	89 85 6c ff ff ff    	mov    %eax,-0x94(%ebp)
  800810:	8b 85 6c ff ff ff    	mov    -0x94(%ebp),%eax
  800816:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80081b:	89 c2                	mov    %eax,%edx
  80081d:	8b 85 74 ff ff ff    	mov    -0x8c(%ebp),%eax
  800823:	89 85 68 ff ff ff    	mov    %eax,-0x98(%ebp)
  800829:	8b 85 68 ff ff ff    	mov    -0x98(%ebp),%eax
  80082f:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800834:	39 c2                	cmp    %eax,%edx
  800836:	75 03                	jne    80083b <_main+0x803>
				found++;
  800838:	ff 45 e8             	incl   -0x18(%ebp)
			if(ROUNDDOWN(myEnv->__uptr_pws[var].virtual_address,PAGE_SIZE) == ROUNDDOWN((uint32)(&(structArr[lastIndexOfStruct])), PAGE_SIZE))
  80083b:	a1 20 60 80 00       	mov    0x806020,%eax
  800840:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  800846:	8b 55 ec             	mov    -0x14(%ebp),%edx
  800849:	89 d0                	mov    %edx,%eax
  80084b:	01 c0                	add    %eax,%eax
  80084d:	01 d0                	add    %edx,%eax
  80084f:	c1 e0 03             	shl    $0x3,%eax
  800852:	01 c8                	add    %ecx,%eax
  800854:	8b 00                	mov    (%eax),%eax
  800856:	89 85 64 ff ff ff    	mov    %eax,-0x9c(%ebp)
  80085c:	8b 85 64 ff ff ff    	mov    -0x9c(%ebp),%eax
  800862:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800867:	89 c2                	mov    %eax,%edx
  800869:	8b 85 70 ff ff ff    	mov    -0x90(%ebp),%eax
  80086f:	8d 0c c5 00 00 00 00 	lea    0x0(,%eax,8),%ecx
  800876:	8b 85 74 ff ff ff    	mov    -0x8c(%ebp),%eax
  80087c:	01 c8                	add    %ecx,%eax
  80087e:	89 85 60 ff ff ff    	mov    %eax,-0xa0(%ebp)
  800884:	8b 85 60 ff ff ff    	mov    -0xa0(%ebp),%eax
  80088a:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80088f:	39 c2                	cmp    %eax,%edx
  800891:	75 03                	jne    800896 <_main+0x85e>
				found++;
  800893:	ff 45 e8             	incl   -0x18(%ebp)
		lastIndexOfStruct = (7*kilo)/sizeof(struct MyStruct) - 1;
		structArr[0].a = minByte; structArr[0].b = minShort; structArr[0].c = minInt;
		structArr[lastIndexOfStruct].a = maxByte; structArr[lastIndexOfStruct].b = maxShort; structArr[lastIndexOfStruct].c = maxInt;
		if ((freeFrames - sys_calculate_free_frames()) != 2) panic("Wrong allocation: pages are not loaded successfully into memory/WS");
		found = 0;
		for (var = 0; var < (myEnv->page_WS_max_size); ++var)
  800896:	ff 45 ec             	incl   -0x14(%ebp)
  800899:	a1 20 60 80 00       	mov    0x806020,%eax
  80089e:	8b 50 74             	mov    0x74(%eax),%edx
  8008a1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8008a4:	39 c2                	cmp    %eax,%edx
  8008a6:	0f 87 43 ff ff ff    	ja     8007ef <_main+0x7b7>
			if(ROUNDDOWN(myEnv->__uptr_pws[var].virtual_address,PAGE_SIZE) == ROUNDDOWN((uint32)(&(structArr[0])), PAGE_SIZE))
				found++;
			if(ROUNDDOWN(myEnv->__uptr_pws[var].virtual_address,PAGE_SIZE) == ROUNDDOWN((uint32)(&(structArr[lastIndexOfStruct])), PAGE_SIZE))
				found++;
		}
		if (found != 2) panic("malloc: page is not added to WS");
  8008ac:	83 7d e8 02          	cmpl   $0x2,-0x18(%ebp)
  8008b0:	74 17                	je     8008c9 <_main+0x891>
  8008b2:	83 ec 04             	sub    $0x4,%esp
  8008b5:	68 8c 48 80 00       	push   $0x80488c
  8008ba:	68 96 00 00 00       	push   $0x96
  8008bf:	68 9c 47 80 00       	push   $0x80479c
  8008c4:	e8 61 10 00 00       	call   80192a <_panic>

		//3 MB
		freeFrames = sys_calculate_free_frames() ;
  8008c9:	e8 ae 26 00 00       	call   802f7c <sys_calculate_free_frames>
  8008ce:	89 45 c0             	mov    %eax,-0x40(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  8008d1:	e8 46 27 00 00       	call   80301c <sys_pf_calculate_allocated_pages>
  8008d6:	89 45 c4             	mov    %eax,-0x3c(%ebp)
		ptr_allocations[5] = malloc(3*Mega-kilo);
  8008d9:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8008dc:	89 c2                	mov    %eax,%edx
  8008de:	01 d2                	add    %edx,%edx
  8008e0:	01 d0                	add    %edx,%eax
  8008e2:	2b 45 dc             	sub    -0x24(%ebp),%eax
  8008e5:	83 ec 0c             	sub    $0xc,%esp
  8008e8:	50                   	push   %eax
  8008e9:	e8 82 22 00 00       	call   802b70 <malloc>
  8008ee:	83 c4 10             	add    $0x10,%esp
  8008f1:	89 85 7c fe ff ff    	mov    %eax,-0x184(%ebp)
		if ((uint32) ptr_allocations[5] < (USER_HEAP_START + 4*Mega + 16*kilo) || (uint32) ptr_allocations[5] > (USER_HEAP_START+ 4*Mega + 16*kilo +PAGE_SIZE)) panic("Wrong start address for the allocated space... check return address of malloc & updating of heap ptr");
  8008f7:	8b 85 7c fe ff ff    	mov    -0x184(%ebp),%eax
  8008fd:	89 c2                	mov    %eax,%edx
  8008ff:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800902:	c1 e0 02             	shl    $0x2,%eax
  800905:	89 c1                	mov    %eax,%ecx
  800907:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80090a:	c1 e0 04             	shl    $0x4,%eax
  80090d:	01 c8                	add    %ecx,%eax
  80090f:	05 00 00 00 80       	add    $0x80000000,%eax
  800914:	39 c2                	cmp    %eax,%edx
  800916:	72 21                	jb     800939 <_main+0x901>
  800918:	8b 85 7c fe ff ff    	mov    -0x184(%ebp),%eax
  80091e:	89 c2                	mov    %eax,%edx
  800920:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800923:	c1 e0 02             	shl    $0x2,%eax
  800926:	89 c1                	mov    %eax,%ecx
  800928:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80092b:	c1 e0 04             	shl    $0x4,%eax
  80092e:	01 c8                	add    %ecx,%eax
  800930:	2d 00 f0 ff 7f       	sub    $0x7ffff000,%eax
  800935:	39 c2                	cmp    %eax,%edx
  800937:	76 17                	jbe    800950 <_main+0x918>
  800939:	83 ec 04             	sub    $0x4,%esp
  80093c:	68 b0 47 80 00       	push   $0x8047b0
  800941:	68 9c 00 00 00       	push   $0x9c
  800946:	68 9c 47 80 00       	push   $0x80479c
  80094b:	e8 da 0f 00 00       	call   80192a <_panic>
		if ((sys_pf_calculate_allocated_pages() - usedDiskPages) != 0) panic("Extra or less pages are allocated in PageFile");
  800950:	e8 c7 26 00 00       	call   80301c <sys_pf_calculate_allocated_pages>
  800955:	3b 45 c4             	cmp    -0x3c(%ebp),%eax
  800958:	74 17                	je     800971 <_main+0x939>
  80095a:	83 ec 04             	sub    $0x4,%esp
  80095d:	68 18 48 80 00       	push   $0x804818
  800962:	68 9d 00 00 00       	push   $0x9d
  800967:	68 9c 47 80 00       	push   $0x80479c
  80096c:	e8 b9 0f 00 00       	call   80192a <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 0) panic("Wrong allocation: ");

		//6 MB
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  800971:	e8 a6 26 00 00       	call   80301c <sys_pf_calculate_allocated_pages>
  800976:	89 45 c4             	mov    %eax,-0x3c(%ebp)
		ptr_allocations[6] = malloc(6*Mega-kilo);
  800979:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80097c:	89 d0                	mov    %edx,%eax
  80097e:	01 c0                	add    %eax,%eax
  800980:	01 d0                	add    %edx,%eax
  800982:	01 c0                	add    %eax,%eax
  800984:	2b 45 dc             	sub    -0x24(%ebp),%eax
  800987:	83 ec 0c             	sub    $0xc,%esp
  80098a:	50                   	push   %eax
  80098b:	e8 e0 21 00 00       	call   802b70 <malloc>
  800990:	83 c4 10             	add    $0x10,%esp
  800993:	89 85 80 fe ff ff    	mov    %eax,-0x180(%ebp)
		if ((uint32) ptr_allocations[6] < (USER_HEAP_START + 7*Mega + 16*kilo) || (uint32) ptr_allocations[6] > (USER_HEAP_START+ 7*Mega + 16*kilo +PAGE_SIZE)) panic("Wrong start address for the allocated space... check return address of malloc & updating of heap ptr");
  800999:	8b 85 80 fe ff ff    	mov    -0x180(%ebp),%eax
  80099f:	89 c1                	mov    %eax,%ecx
  8009a1:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8009a4:	89 d0                	mov    %edx,%eax
  8009a6:	01 c0                	add    %eax,%eax
  8009a8:	01 d0                	add    %edx,%eax
  8009aa:	01 c0                	add    %eax,%eax
  8009ac:	01 d0                	add    %edx,%eax
  8009ae:	89 c2                	mov    %eax,%edx
  8009b0:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8009b3:	c1 e0 04             	shl    $0x4,%eax
  8009b6:	01 d0                	add    %edx,%eax
  8009b8:	05 00 00 00 80       	add    $0x80000000,%eax
  8009bd:	39 c1                	cmp    %eax,%ecx
  8009bf:	72 28                	jb     8009e9 <_main+0x9b1>
  8009c1:	8b 85 80 fe ff ff    	mov    -0x180(%ebp),%eax
  8009c7:	89 c1                	mov    %eax,%ecx
  8009c9:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8009cc:	89 d0                	mov    %edx,%eax
  8009ce:	01 c0                	add    %eax,%eax
  8009d0:	01 d0                	add    %edx,%eax
  8009d2:	01 c0                	add    %eax,%eax
  8009d4:	01 d0                	add    %edx,%eax
  8009d6:	89 c2                	mov    %eax,%edx
  8009d8:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8009db:	c1 e0 04             	shl    $0x4,%eax
  8009de:	01 d0                	add    %edx,%eax
  8009e0:	2d 00 f0 ff 7f       	sub    $0x7ffff000,%eax
  8009e5:	39 c1                	cmp    %eax,%ecx
  8009e7:	76 17                	jbe    800a00 <_main+0x9c8>
  8009e9:	83 ec 04             	sub    $0x4,%esp
  8009ec:	68 b0 47 80 00       	push   $0x8047b0
  8009f1:	68 a3 00 00 00       	push   $0xa3
  8009f6:	68 9c 47 80 00       	push   $0x80479c
  8009fb:	e8 2a 0f 00 00       	call   80192a <_panic>
		if ((sys_pf_calculate_allocated_pages() - usedDiskPages) != 0) panic("Extra or less pages are allocated in PageFile");
  800a00:	e8 17 26 00 00       	call   80301c <sys_pf_calculate_allocated_pages>
  800a05:	3b 45 c4             	cmp    -0x3c(%ebp),%eax
  800a08:	74 17                	je     800a21 <_main+0x9e9>
  800a0a:	83 ec 04             	sub    $0x4,%esp
  800a0d:	68 18 48 80 00       	push   $0x804818
  800a12:	68 a4 00 00 00       	push   $0xa4
  800a17:	68 9c 47 80 00       	push   $0x80479c
  800a1c:	e8 09 0f 00 00       	call   80192a <_panic>

		freeFrames = sys_calculate_free_frames() ;
  800a21:	e8 56 25 00 00       	call   802f7c <sys_calculate_free_frames>
  800a26:	89 45 c0             	mov    %eax,-0x40(%ebp)
		lastIndexOfByte2 = (6*Mega-kilo)/sizeof(char) - 1;
  800a29:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800a2c:	89 d0                	mov    %edx,%eax
  800a2e:	01 c0                	add    %eax,%eax
  800a30:	01 d0                	add    %edx,%eax
  800a32:	01 c0                	add    %eax,%eax
  800a34:	2b 45 dc             	sub    -0x24(%ebp),%eax
  800a37:	48                   	dec    %eax
  800a38:	89 85 5c ff ff ff    	mov    %eax,-0xa4(%ebp)
		byteArr2 = (char *) ptr_allocations[6];
  800a3e:	8b 85 80 fe ff ff    	mov    -0x180(%ebp),%eax
  800a44:	89 85 58 ff ff ff    	mov    %eax,-0xa8(%ebp)
		byteArr2[0] = minByte ;
  800a4a:	8b 85 58 ff ff ff    	mov    -0xa8(%ebp),%eax
  800a50:	8a 55 db             	mov    -0x25(%ebp),%dl
  800a53:	88 10                	mov    %dl,(%eax)
		byteArr2[lastIndexOfByte2 / 2] = maxByte / 2;
  800a55:	8b 85 5c ff ff ff    	mov    -0xa4(%ebp),%eax
  800a5b:	89 c2                	mov    %eax,%edx
  800a5d:	c1 ea 1f             	shr    $0x1f,%edx
  800a60:	01 d0                	add    %edx,%eax
  800a62:	d1 f8                	sar    %eax
  800a64:	89 c2                	mov    %eax,%edx
  800a66:	8b 85 58 ff ff ff    	mov    -0xa8(%ebp),%eax
  800a6c:	01 c2                	add    %eax,%edx
  800a6e:	8a 45 da             	mov    -0x26(%ebp),%al
  800a71:	88 c1                	mov    %al,%cl
  800a73:	c0 e9 07             	shr    $0x7,%cl
  800a76:	01 c8                	add    %ecx,%eax
  800a78:	d0 f8                	sar    %al
  800a7a:	88 02                	mov    %al,(%edx)
		byteArr2[lastIndexOfByte2] = maxByte ;
  800a7c:	8b 95 5c ff ff ff    	mov    -0xa4(%ebp),%edx
  800a82:	8b 85 58 ff ff ff    	mov    -0xa8(%ebp),%eax
  800a88:	01 c2                	add    %eax,%edx
  800a8a:	8a 45 da             	mov    -0x26(%ebp),%al
  800a8d:	88 02                	mov    %al,(%edx)
		if ((freeFrames - sys_calculate_free_frames()) != 3 + 2) panic("Wrong allocation: pages are not loaded successfully into memory/WS");
  800a8f:	8b 5d c0             	mov    -0x40(%ebp),%ebx
  800a92:	e8 e5 24 00 00       	call   802f7c <sys_calculate_free_frames>
  800a97:	29 c3                	sub    %eax,%ebx
  800a99:	89 d8                	mov    %ebx,%eax
  800a9b:	83 f8 05             	cmp    $0x5,%eax
  800a9e:	74 17                	je     800ab7 <_main+0xa7f>
  800aa0:	83 ec 04             	sub    $0x4,%esp
  800aa3:	68 48 48 80 00       	push   $0x804848
  800aa8:	68 ac 00 00 00       	push   $0xac
  800aad:	68 9c 47 80 00       	push   $0x80479c
  800ab2:	e8 73 0e 00 00       	call   80192a <_panic>
		found = 0;
  800ab7:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		for (var = 0; var < (myEnv->page_WS_max_size); ++var)
  800abe:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  800ac5:	e9 02 01 00 00       	jmp    800bcc <_main+0xb94>
		{
			if(ROUNDDOWN(myEnv->__uptr_pws[var].virtual_address,PAGE_SIZE) == ROUNDDOWN((uint32)(&(byteArr2[0])), PAGE_SIZE))
  800aca:	a1 20 60 80 00       	mov    0x806020,%eax
  800acf:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  800ad5:	8b 55 ec             	mov    -0x14(%ebp),%edx
  800ad8:	89 d0                	mov    %edx,%eax
  800ada:	01 c0                	add    %eax,%eax
  800adc:	01 d0                	add    %edx,%eax
  800ade:	c1 e0 03             	shl    $0x3,%eax
  800ae1:	01 c8                	add    %ecx,%eax
  800ae3:	8b 00                	mov    (%eax),%eax
  800ae5:	89 85 54 ff ff ff    	mov    %eax,-0xac(%ebp)
  800aeb:	8b 85 54 ff ff ff    	mov    -0xac(%ebp),%eax
  800af1:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800af6:	89 c2                	mov    %eax,%edx
  800af8:	8b 85 58 ff ff ff    	mov    -0xa8(%ebp),%eax
  800afe:	89 85 50 ff ff ff    	mov    %eax,-0xb0(%ebp)
  800b04:	8b 85 50 ff ff ff    	mov    -0xb0(%ebp),%eax
  800b0a:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800b0f:	39 c2                	cmp    %eax,%edx
  800b11:	75 03                	jne    800b16 <_main+0xade>
				found++;
  800b13:	ff 45 e8             	incl   -0x18(%ebp)
			if(ROUNDDOWN(myEnv->__uptr_pws[var].virtual_address,PAGE_SIZE) == ROUNDDOWN((uint32)(&(byteArr2[lastIndexOfByte2/2])), PAGE_SIZE))
  800b16:	a1 20 60 80 00       	mov    0x806020,%eax
  800b1b:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  800b21:	8b 55 ec             	mov    -0x14(%ebp),%edx
  800b24:	89 d0                	mov    %edx,%eax
  800b26:	01 c0                	add    %eax,%eax
  800b28:	01 d0                	add    %edx,%eax
  800b2a:	c1 e0 03             	shl    $0x3,%eax
  800b2d:	01 c8                	add    %ecx,%eax
  800b2f:	8b 00                	mov    (%eax),%eax
  800b31:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%ebp)
  800b37:	8b 85 4c ff ff ff    	mov    -0xb4(%ebp),%eax
  800b3d:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800b42:	89 c2                	mov    %eax,%edx
  800b44:	8b 85 5c ff ff ff    	mov    -0xa4(%ebp),%eax
  800b4a:	89 c1                	mov    %eax,%ecx
  800b4c:	c1 e9 1f             	shr    $0x1f,%ecx
  800b4f:	01 c8                	add    %ecx,%eax
  800b51:	d1 f8                	sar    %eax
  800b53:	89 c1                	mov    %eax,%ecx
  800b55:	8b 85 58 ff ff ff    	mov    -0xa8(%ebp),%eax
  800b5b:	01 c8                	add    %ecx,%eax
  800b5d:	89 85 48 ff ff ff    	mov    %eax,-0xb8(%ebp)
  800b63:	8b 85 48 ff ff ff    	mov    -0xb8(%ebp),%eax
  800b69:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800b6e:	39 c2                	cmp    %eax,%edx
  800b70:	75 03                	jne    800b75 <_main+0xb3d>
				found++;
  800b72:	ff 45 e8             	incl   -0x18(%ebp)
			if(ROUNDDOWN(myEnv->__uptr_pws[var].virtual_address,PAGE_SIZE) == ROUNDDOWN((uint32)(&(byteArr2[lastIndexOfByte2])), PAGE_SIZE))
  800b75:	a1 20 60 80 00       	mov    0x806020,%eax
  800b7a:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  800b80:	8b 55 ec             	mov    -0x14(%ebp),%edx
  800b83:	89 d0                	mov    %edx,%eax
  800b85:	01 c0                	add    %eax,%eax
  800b87:	01 d0                	add    %edx,%eax
  800b89:	c1 e0 03             	shl    $0x3,%eax
  800b8c:	01 c8                	add    %ecx,%eax
  800b8e:	8b 00                	mov    (%eax),%eax
  800b90:	89 85 44 ff ff ff    	mov    %eax,-0xbc(%ebp)
  800b96:	8b 85 44 ff ff ff    	mov    -0xbc(%ebp),%eax
  800b9c:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800ba1:	89 c1                	mov    %eax,%ecx
  800ba3:	8b 95 5c ff ff ff    	mov    -0xa4(%ebp),%edx
  800ba9:	8b 85 58 ff ff ff    	mov    -0xa8(%ebp),%eax
  800baf:	01 d0                	add    %edx,%eax
  800bb1:	89 85 40 ff ff ff    	mov    %eax,-0xc0(%ebp)
  800bb7:	8b 85 40 ff ff ff    	mov    -0xc0(%ebp),%eax
  800bbd:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800bc2:	39 c1                	cmp    %eax,%ecx
  800bc4:	75 03                	jne    800bc9 <_main+0xb91>
				found++;
  800bc6:	ff 45 e8             	incl   -0x18(%ebp)
		byteArr2[0] = minByte ;
		byteArr2[lastIndexOfByte2 / 2] = maxByte / 2;
		byteArr2[lastIndexOfByte2] = maxByte ;
		if ((freeFrames - sys_calculate_free_frames()) != 3 + 2) panic("Wrong allocation: pages are not loaded successfully into memory/WS");
		found = 0;
		for (var = 0; var < (myEnv->page_WS_max_size); ++var)
  800bc9:	ff 45 ec             	incl   -0x14(%ebp)
  800bcc:	a1 20 60 80 00       	mov    0x806020,%eax
  800bd1:	8b 50 74             	mov    0x74(%eax),%edx
  800bd4:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800bd7:	39 c2                	cmp    %eax,%edx
  800bd9:	0f 87 eb fe ff ff    	ja     800aca <_main+0xa92>
			if(ROUNDDOWN(myEnv->__uptr_pws[var].virtual_address,PAGE_SIZE) == ROUNDDOWN((uint32)(&(byteArr2[lastIndexOfByte2/2])), PAGE_SIZE))
				found++;
			if(ROUNDDOWN(myEnv->__uptr_pws[var].virtual_address,PAGE_SIZE) == ROUNDDOWN((uint32)(&(byteArr2[lastIndexOfByte2])), PAGE_SIZE))
				found++;
		}
		if (found != 3) panic("malloc: page is not added to WS");
  800bdf:	83 7d e8 03          	cmpl   $0x3,-0x18(%ebp)
  800be3:	74 17                	je     800bfc <_main+0xbc4>
  800be5:	83 ec 04             	sub    $0x4,%esp
  800be8:	68 8c 48 80 00       	push   $0x80488c
  800bed:	68 b7 00 00 00       	push   $0xb7
  800bf2:	68 9c 47 80 00       	push   $0x80479c
  800bf7:	e8 2e 0d 00 00       	call   80192a <_panic>

		//14 KB
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  800bfc:	e8 1b 24 00 00       	call   80301c <sys_pf_calculate_allocated_pages>
  800c01:	89 45 c4             	mov    %eax,-0x3c(%ebp)
		ptr_allocations[7] = malloc(14*kilo);
  800c04:	8b 55 dc             	mov    -0x24(%ebp),%edx
  800c07:	89 d0                	mov    %edx,%eax
  800c09:	01 c0                	add    %eax,%eax
  800c0b:	01 d0                	add    %edx,%eax
  800c0d:	01 c0                	add    %eax,%eax
  800c0f:	01 d0                	add    %edx,%eax
  800c11:	01 c0                	add    %eax,%eax
  800c13:	83 ec 0c             	sub    $0xc,%esp
  800c16:	50                   	push   %eax
  800c17:	e8 54 1f 00 00       	call   802b70 <malloc>
  800c1c:	83 c4 10             	add    $0x10,%esp
  800c1f:	89 85 84 fe ff ff    	mov    %eax,-0x17c(%ebp)
		if ((uint32) ptr_allocations[7] < (USER_HEAP_START + 13*Mega + 16*kilo)|| (uint32) ptr_allocations[7] > (USER_HEAP_START+ 13*Mega + 16*kilo +PAGE_SIZE)) panic("Wrong start address for the allocated space... check return address of malloc & updating of heap ptr");
  800c25:	8b 85 84 fe ff ff    	mov    -0x17c(%ebp),%eax
  800c2b:	89 c1                	mov    %eax,%ecx
  800c2d:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800c30:	89 d0                	mov    %edx,%eax
  800c32:	01 c0                	add    %eax,%eax
  800c34:	01 d0                	add    %edx,%eax
  800c36:	c1 e0 02             	shl    $0x2,%eax
  800c39:	01 d0                	add    %edx,%eax
  800c3b:	89 c2                	mov    %eax,%edx
  800c3d:	8b 45 dc             	mov    -0x24(%ebp),%eax
  800c40:	c1 e0 04             	shl    $0x4,%eax
  800c43:	01 d0                	add    %edx,%eax
  800c45:	05 00 00 00 80       	add    $0x80000000,%eax
  800c4a:	39 c1                	cmp    %eax,%ecx
  800c4c:	72 29                	jb     800c77 <_main+0xc3f>
  800c4e:	8b 85 84 fe ff ff    	mov    -0x17c(%ebp),%eax
  800c54:	89 c1                	mov    %eax,%ecx
  800c56:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800c59:	89 d0                	mov    %edx,%eax
  800c5b:	01 c0                	add    %eax,%eax
  800c5d:	01 d0                	add    %edx,%eax
  800c5f:	c1 e0 02             	shl    $0x2,%eax
  800c62:	01 d0                	add    %edx,%eax
  800c64:	89 c2                	mov    %eax,%edx
  800c66:	8b 45 dc             	mov    -0x24(%ebp),%eax
  800c69:	c1 e0 04             	shl    $0x4,%eax
  800c6c:	01 d0                	add    %edx,%eax
  800c6e:	2d 00 f0 ff 7f       	sub    $0x7ffff000,%eax
  800c73:	39 c1                	cmp    %eax,%ecx
  800c75:	76 17                	jbe    800c8e <_main+0xc56>
  800c77:	83 ec 04             	sub    $0x4,%esp
  800c7a:	68 b0 47 80 00       	push   $0x8047b0
  800c7f:	68 bc 00 00 00       	push   $0xbc
  800c84:	68 9c 47 80 00       	push   $0x80479c
  800c89:	e8 9c 0c 00 00       	call   80192a <_panic>
		if ((sys_pf_calculate_allocated_pages() - usedDiskPages) != 0) panic("Extra or less pages are allocated in PageFile");
  800c8e:	e8 89 23 00 00       	call   80301c <sys_pf_calculate_allocated_pages>
  800c93:	3b 45 c4             	cmp    -0x3c(%ebp),%eax
  800c96:	74 17                	je     800caf <_main+0xc77>
  800c98:	83 ec 04             	sub    $0x4,%esp
  800c9b:	68 18 48 80 00       	push   $0x804818
  800ca0:	68 bd 00 00 00       	push   $0xbd
  800ca5:	68 9c 47 80 00       	push   $0x80479c
  800caa:	e8 7b 0c 00 00       	call   80192a <_panic>

		freeFrames = sys_calculate_free_frames() ;
  800caf:	e8 c8 22 00 00       	call   802f7c <sys_calculate_free_frames>
  800cb4:	89 45 c0             	mov    %eax,-0x40(%ebp)
		shortArr2 = (short *) ptr_allocations[7];
  800cb7:	8b 85 84 fe ff ff    	mov    -0x17c(%ebp),%eax
  800cbd:	89 85 3c ff ff ff    	mov    %eax,-0xc4(%ebp)
		lastIndexOfShort2 = (14*kilo)/sizeof(short) - 1;
  800cc3:	8b 55 dc             	mov    -0x24(%ebp),%edx
  800cc6:	89 d0                	mov    %edx,%eax
  800cc8:	01 c0                	add    %eax,%eax
  800cca:	01 d0                	add    %edx,%eax
  800ccc:	01 c0                	add    %eax,%eax
  800cce:	01 d0                	add    %edx,%eax
  800cd0:	01 c0                	add    %eax,%eax
  800cd2:	d1 e8                	shr    %eax
  800cd4:	48                   	dec    %eax
  800cd5:	89 85 38 ff ff ff    	mov    %eax,-0xc8(%ebp)
		shortArr2[0] = minShort;
  800cdb:	8b 95 3c ff ff ff    	mov    -0xc4(%ebp),%edx
  800ce1:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800ce4:	66 89 02             	mov    %ax,(%edx)
		shortArr2[lastIndexOfShort2] = maxShort;
  800ce7:	8b 85 38 ff ff ff    	mov    -0xc8(%ebp),%eax
  800ced:	01 c0                	add    %eax,%eax
  800cef:	89 c2                	mov    %eax,%edx
  800cf1:	8b 85 3c ff ff ff    	mov    -0xc4(%ebp),%eax
  800cf7:	01 c2                	add    %eax,%edx
  800cf9:	66 8b 45 d6          	mov    -0x2a(%ebp),%ax
  800cfd:	66 89 02             	mov    %ax,(%edx)
		if ((freeFrames - sys_calculate_free_frames()) != 2) panic("Wrong allocation: pages are not loaded successfully into memory/WS");
  800d00:	8b 5d c0             	mov    -0x40(%ebp),%ebx
  800d03:	e8 74 22 00 00       	call   802f7c <sys_calculate_free_frames>
  800d08:	29 c3                	sub    %eax,%ebx
  800d0a:	89 d8                	mov    %ebx,%eax
  800d0c:	83 f8 02             	cmp    $0x2,%eax
  800d0f:	74 17                	je     800d28 <_main+0xcf0>
  800d11:	83 ec 04             	sub    $0x4,%esp
  800d14:	68 48 48 80 00       	push   $0x804848
  800d19:	68 c4 00 00 00       	push   $0xc4
  800d1e:	68 9c 47 80 00       	push   $0x80479c
  800d23:	e8 02 0c 00 00       	call   80192a <_panic>
		found = 0;
  800d28:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		for (var = 0; var < (myEnv->page_WS_max_size); ++var)
  800d2f:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  800d36:	e9 a7 00 00 00       	jmp    800de2 <_main+0xdaa>
		{
			if(ROUNDDOWN(myEnv->__uptr_pws[var].virtual_address,PAGE_SIZE) == ROUNDDOWN((uint32)(&(shortArr2[0])), PAGE_SIZE))
  800d3b:	a1 20 60 80 00       	mov    0x806020,%eax
  800d40:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  800d46:	8b 55 ec             	mov    -0x14(%ebp),%edx
  800d49:	89 d0                	mov    %edx,%eax
  800d4b:	01 c0                	add    %eax,%eax
  800d4d:	01 d0                	add    %edx,%eax
  800d4f:	c1 e0 03             	shl    $0x3,%eax
  800d52:	01 c8                	add    %ecx,%eax
  800d54:	8b 00                	mov    (%eax),%eax
  800d56:	89 85 34 ff ff ff    	mov    %eax,-0xcc(%ebp)
  800d5c:	8b 85 34 ff ff ff    	mov    -0xcc(%ebp),%eax
  800d62:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800d67:	89 c2                	mov    %eax,%edx
  800d69:	8b 85 3c ff ff ff    	mov    -0xc4(%ebp),%eax
  800d6f:	89 85 30 ff ff ff    	mov    %eax,-0xd0(%ebp)
  800d75:	8b 85 30 ff ff ff    	mov    -0xd0(%ebp),%eax
  800d7b:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800d80:	39 c2                	cmp    %eax,%edx
  800d82:	75 03                	jne    800d87 <_main+0xd4f>
				found++;
  800d84:	ff 45 e8             	incl   -0x18(%ebp)
			if(ROUNDDOWN(myEnv->__uptr_pws[var].virtual_address,PAGE_SIZE) == ROUNDDOWN((uint32)(&(shortArr2[lastIndexOfShort2])), PAGE_SIZE))
  800d87:	a1 20 60 80 00       	mov    0x806020,%eax
  800d8c:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  800d92:	8b 55 ec             	mov    -0x14(%ebp),%edx
  800d95:	89 d0                	mov    %edx,%eax
  800d97:	01 c0                	add    %eax,%eax
  800d99:	01 d0                	add    %edx,%eax
  800d9b:	c1 e0 03             	shl    $0x3,%eax
  800d9e:	01 c8                	add    %ecx,%eax
  800da0:	8b 00                	mov    (%eax),%eax
  800da2:	89 85 2c ff ff ff    	mov    %eax,-0xd4(%ebp)
  800da8:	8b 85 2c ff ff ff    	mov    -0xd4(%ebp),%eax
  800dae:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800db3:	89 c2                	mov    %eax,%edx
  800db5:	8b 85 38 ff ff ff    	mov    -0xc8(%ebp),%eax
  800dbb:	01 c0                	add    %eax,%eax
  800dbd:	89 c1                	mov    %eax,%ecx
  800dbf:	8b 85 3c ff ff ff    	mov    -0xc4(%ebp),%eax
  800dc5:	01 c8                	add    %ecx,%eax
  800dc7:	89 85 28 ff ff ff    	mov    %eax,-0xd8(%ebp)
  800dcd:	8b 85 28 ff ff ff    	mov    -0xd8(%ebp),%eax
  800dd3:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800dd8:	39 c2                	cmp    %eax,%edx
  800dda:	75 03                	jne    800ddf <_main+0xda7>
				found++;
  800ddc:	ff 45 e8             	incl   -0x18(%ebp)
		lastIndexOfShort2 = (14*kilo)/sizeof(short) - 1;
		shortArr2[0] = minShort;
		shortArr2[lastIndexOfShort2] = maxShort;
		if ((freeFrames - sys_calculate_free_frames()) != 2) panic("Wrong allocation: pages are not loaded successfully into memory/WS");
		found = 0;
		for (var = 0; var < (myEnv->page_WS_max_size); ++var)
  800ddf:	ff 45 ec             	incl   -0x14(%ebp)
  800de2:	a1 20 60 80 00       	mov    0x806020,%eax
  800de7:	8b 50 74             	mov    0x74(%eax),%edx
  800dea:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800ded:	39 c2                	cmp    %eax,%edx
  800def:	0f 87 46 ff ff ff    	ja     800d3b <_main+0xd03>
			if(ROUNDDOWN(myEnv->__uptr_pws[var].virtual_address,PAGE_SIZE) == ROUNDDOWN((uint32)(&(shortArr2[0])), PAGE_SIZE))
				found++;
			if(ROUNDDOWN(myEnv->__uptr_pws[var].virtual_address,PAGE_SIZE) == ROUNDDOWN((uint32)(&(shortArr2[lastIndexOfShort2])), PAGE_SIZE))
				found++;
		}
		if (found != 2) panic("malloc: page is not added to WS");
  800df5:	83 7d e8 02          	cmpl   $0x2,-0x18(%ebp)
  800df9:	74 17                	je     800e12 <_main+0xdda>
  800dfb:	83 ec 04             	sub    $0x4,%esp
  800dfe:	68 8c 48 80 00       	push   $0x80488c
  800e03:	68 cd 00 00 00       	push   $0xcd
  800e08:	68 9c 47 80 00       	push   $0x80479c
  800e0d:	e8 18 0b 00 00       	call   80192a <_panic>
	}

	{
		//Free 1st 2 MB
		int freeFrames = sys_calculate_free_frames() ;
  800e12:	e8 65 21 00 00       	call   802f7c <sys_calculate_free_frames>
  800e17:	89 85 24 ff ff ff    	mov    %eax,-0xdc(%ebp)
		int usedDiskPages = sys_pf_calculate_allocated_pages() ;
  800e1d:	e8 fa 21 00 00       	call   80301c <sys_pf_calculate_allocated_pages>
  800e22:	89 85 20 ff ff ff    	mov    %eax,-0xe0(%ebp)
		free(ptr_allocations[0]);
  800e28:	8b 85 68 fe ff ff    	mov    -0x198(%ebp),%eax
  800e2e:	83 ec 0c             	sub    $0xc,%esp
  800e31:	50                   	push   %eax
  800e32:	e8 ba 1d 00 00       	call   802bf1 <free>
  800e37:	83 c4 10             	add    $0x10,%esp

		if ((usedDiskPages - sys_pf_calculate_allocated_pages()) != 0) panic("Wrong free: Extra or less pages are removed from PageFile");
  800e3a:	e8 dd 21 00 00       	call   80301c <sys_pf_calculate_allocated_pages>
  800e3f:	3b 85 20 ff ff ff    	cmp    -0xe0(%ebp),%eax
  800e45:	74 17                	je     800e5e <_main+0xe26>
  800e47:	83 ec 04             	sub    $0x4,%esp
  800e4a:	68 ac 48 80 00       	push   $0x8048ac
  800e4f:	68 d6 00 00 00       	push   $0xd6
  800e54:	68 9c 47 80 00       	push   $0x80479c
  800e59:	e8 cc 0a 00 00       	call   80192a <_panic>
		if ((sys_calculate_free_frames() - freeFrames) != 2 ) panic("Wrong free: WS pages in memory and/or page tables are not freed correctly");
  800e5e:	e8 19 21 00 00       	call   802f7c <sys_calculate_free_frames>
  800e63:	89 c2                	mov    %eax,%edx
  800e65:	8b 85 24 ff ff ff    	mov    -0xdc(%ebp),%eax
  800e6b:	29 c2                	sub    %eax,%edx
  800e6d:	89 d0                	mov    %edx,%eax
  800e6f:	83 f8 02             	cmp    $0x2,%eax
  800e72:	74 17                	je     800e8b <_main+0xe53>
  800e74:	83 ec 04             	sub    $0x4,%esp
  800e77:	68 e8 48 80 00       	push   $0x8048e8
  800e7c:	68 d7 00 00 00       	push   $0xd7
  800e81:	68 9c 47 80 00       	push   $0x80479c
  800e86:	e8 9f 0a 00 00       	call   80192a <_panic>
		int var;
		for (var = 0; var < (myEnv->page_WS_max_size); ++var)
  800e8b:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  800e92:	e9 c2 00 00 00       	jmp    800f59 <_main+0xf21>
		{
			if(ROUNDDOWN(myEnv->__uptr_pws[var].virtual_address,PAGE_SIZE) == ROUNDDOWN((uint32)(&(byteArr[0])), PAGE_SIZE))
  800e97:	a1 20 60 80 00       	mov    0x806020,%eax
  800e9c:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  800ea2:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  800ea5:	89 d0                	mov    %edx,%eax
  800ea7:	01 c0                	add    %eax,%eax
  800ea9:	01 d0                	add    %edx,%eax
  800eab:	c1 e0 03             	shl    $0x3,%eax
  800eae:	01 c8                	add    %ecx,%eax
  800eb0:	8b 00                	mov    (%eax),%eax
  800eb2:	89 85 1c ff ff ff    	mov    %eax,-0xe4(%ebp)
  800eb8:	8b 85 1c ff ff ff    	mov    -0xe4(%ebp),%eax
  800ebe:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800ec3:	89 c2                	mov    %eax,%edx
  800ec5:	8b 45 b8             	mov    -0x48(%ebp),%eax
  800ec8:	89 85 18 ff ff ff    	mov    %eax,-0xe8(%ebp)
  800ece:	8b 85 18 ff ff ff    	mov    -0xe8(%ebp),%eax
  800ed4:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800ed9:	39 c2                	cmp    %eax,%edx
  800edb:	75 17                	jne    800ef4 <_main+0xebc>
				panic("free: page is not removed from WS");
  800edd:	83 ec 04             	sub    $0x4,%esp
  800ee0:	68 34 49 80 00       	push   $0x804934
  800ee5:	68 dc 00 00 00       	push   $0xdc
  800eea:	68 9c 47 80 00       	push   $0x80479c
  800eef:	e8 36 0a 00 00       	call   80192a <_panic>
			if(ROUNDDOWN(myEnv->__uptr_pws[var].virtual_address,PAGE_SIZE) == ROUNDDOWN((uint32)(&(byteArr[lastIndexOfByte])), PAGE_SIZE))
  800ef4:	a1 20 60 80 00       	mov    0x806020,%eax
  800ef9:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  800eff:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  800f02:	89 d0                	mov    %edx,%eax
  800f04:	01 c0                	add    %eax,%eax
  800f06:	01 d0                	add    %edx,%eax
  800f08:	c1 e0 03             	shl    $0x3,%eax
  800f0b:	01 c8                	add    %ecx,%eax
  800f0d:	8b 00                	mov    (%eax),%eax
  800f0f:	89 85 14 ff ff ff    	mov    %eax,-0xec(%ebp)
  800f15:	8b 85 14 ff ff ff    	mov    -0xec(%ebp),%eax
  800f1b:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800f20:	89 c1                	mov    %eax,%ecx
  800f22:	8b 55 bc             	mov    -0x44(%ebp),%edx
  800f25:	8b 45 b8             	mov    -0x48(%ebp),%eax
  800f28:	01 d0                	add    %edx,%eax
  800f2a:	89 85 10 ff ff ff    	mov    %eax,-0xf0(%ebp)
  800f30:	8b 85 10 ff ff ff    	mov    -0xf0(%ebp),%eax
  800f36:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800f3b:	39 c1                	cmp    %eax,%ecx
  800f3d:	75 17                	jne    800f56 <_main+0xf1e>
				panic("free: page is not removed from WS");
  800f3f:	83 ec 04             	sub    $0x4,%esp
  800f42:	68 34 49 80 00       	push   $0x804934
  800f47:	68 de 00 00 00       	push   $0xde
  800f4c:	68 9c 47 80 00       	push   $0x80479c
  800f51:	e8 d4 09 00 00       	call   80192a <_panic>
		free(ptr_allocations[0]);

		if ((usedDiskPages - sys_pf_calculate_allocated_pages()) != 0) panic("Wrong free: Extra or less pages are removed from PageFile");
		if ((sys_calculate_free_frames() - freeFrames) != 2 ) panic("Wrong free: WS pages in memory and/or page tables are not freed correctly");
		int var;
		for (var = 0; var < (myEnv->page_WS_max_size); ++var)
  800f56:	ff 45 e4             	incl   -0x1c(%ebp)
  800f59:	a1 20 60 80 00       	mov    0x806020,%eax
  800f5e:	8b 50 74             	mov    0x74(%eax),%edx
  800f61:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800f64:	39 c2                	cmp    %eax,%edx
  800f66:	0f 87 2b ff ff ff    	ja     800e97 <_main+0xe5f>
				panic("free: page is not removed from WS");
		}


		//Free 2nd 2 MB
		freeFrames = sys_calculate_free_frames() ;
  800f6c:	e8 0b 20 00 00       	call   802f7c <sys_calculate_free_frames>
  800f71:	89 85 24 ff ff ff    	mov    %eax,-0xdc(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  800f77:	e8 a0 20 00 00       	call   80301c <sys_pf_calculate_allocated_pages>
  800f7c:	89 85 20 ff ff ff    	mov    %eax,-0xe0(%ebp)
		free(ptr_allocations[1]);
  800f82:	8b 85 6c fe ff ff    	mov    -0x194(%ebp),%eax
  800f88:	83 ec 0c             	sub    $0xc,%esp
  800f8b:	50                   	push   %eax
  800f8c:	e8 60 1c 00 00       	call   802bf1 <free>
  800f91:	83 c4 10             	add    $0x10,%esp
		if ((usedDiskPages - sys_pf_calculate_allocated_pages()) != 0) panic("Wrong free: Extra or less pages are removed from PageFile");
  800f94:	e8 83 20 00 00       	call   80301c <sys_pf_calculate_allocated_pages>
  800f99:	3b 85 20 ff ff ff    	cmp    -0xe0(%ebp),%eax
  800f9f:	74 17                	je     800fb8 <_main+0xf80>
  800fa1:	83 ec 04             	sub    $0x4,%esp
  800fa4:	68 ac 48 80 00       	push   $0x8048ac
  800fa9:	68 e6 00 00 00       	push   $0xe6
  800fae:	68 9c 47 80 00       	push   $0x80479c
  800fb3:	e8 72 09 00 00       	call   80192a <_panic>
		if ((sys_calculate_free_frames() - freeFrames) != 2 + 1) panic("Wrong free: WS pages in memory and/or page tables are not freed correctly");
  800fb8:	e8 bf 1f 00 00       	call   802f7c <sys_calculate_free_frames>
  800fbd:	89 c2                	mov    %eax,%edx
  800fbf:	8b 85 24 ff ff ff    	mov    -0xdc(%ebp),%eax
  800fc5:	29 c2                	sub    %eax,%edx
  800fc7:	89 d0                	mov    %edx,%eax
  800fc9:	83 f8 03             	cmp    $0x3,%eax
  800fcc:	74 17                	je     800fe5 <_main+0xfad>
  800fce:	83 ec 04             	sub    $0x4,%esp
  800fd1:	68 e8 48 80 00       	push   $0x8048e8
  800fd6:	68 e7 00 00 00       	push   $0xe7
  800fdb:	68 9c 47 80 00       	push   $0x80479c
  800fe0:	e8 45 09 00 00       	call   80192a <_panic>
		for (var = 0; var < (myEnv->page_WS_max_size); ++var)
  800fe5:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  800fec:	e9 c6 00 00 00       	jmp    8010b7 <_main+0x107f>
		{
			if(ROUNDDOWN(myEnv->__uptr_pws[var].virtual_address,PAGE_SIZE) == ROUNDDOWN((uint32)(&(shortArr[0])), PAGE_SIZE))
  800ff1:	a1 20 60 80 00       	mov    0x806020,%eax
  800ff6:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  800ffc:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  800fff:	89 d0                	mov    %edx,%eax
  801001:	01 c0                	add    %eax,%eax
  801003:	01 d0                	add    %edx,%eax
  801005:	c1 e0 03             	shl    $0x3,%eax
  801008:	01 c8                	add    %ecx,%eax
  80100a:	8b 00                	mov    (%eax),%eax
  80100c:	89 85 0c ff ff ff    	mov    %eax,-0xf4(%ebp)
  801012:	8b 85 0c ff ff ff    	mov    -0xf4(%ebp),%eax
  801018:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80101d:	89 c2                	mov    %eax,%edx
  80101f:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  801022:	89 85 08 ff ff ff    	mov    %eax,-0xf8(%ebp)
  801028:	8b 85 08 ff ff ff    	mov    -0xf8(%ebp),%eax
  80102e:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801033:	39 c2                	cmp    %eax,%edx
  801035:	75 17                	jne    80104e <_main+0x1016>
				panic("free: page is not removed from WS");
  801037:	83 ec 04             	sub    $0x4,%esp
  80103a:	68 34 49 80 00       	push   $0x804934
  80103f:	68 eb 00 00 00       	push   $0xeb
  801044:	68 9c 47 80 00       	push   $0x80479c
  801049:	e8 dc 08 00 00       	call   80192a <_panic>
			if(ROUNDDOWN(myEnv->__uptr_pws[var].virtual_address,PAGE_SIZE) == ROUNDDOWN((uint32)(&(shortArr[lastIndexOfShort])), PAGE_SIZE))
  80104e:	a1 20 60 80 00       	mov    0x806020,%eax
  801053:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  801059:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80105c:	89 d0                	mov    %edx,%eax
  80105e:	01 c0                	add    %eax,%eax
  801060:	01 d0                	add    %edx,%eax
  801062:	c1 e0 03             	shl    $0x3,%eax
  801065:	01 c8                	add    %ecx,%eax
  801067:	8b 00                	mov    (%eax),%eax
  801069:	89 85 04 ff ff ff    	mov    %eax,-0xfc(%ebp)
  80106f:	8b 85 04 ff ff ff    	mov    -0xfc(%ebp),%eax
  801075:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80107a:	89 c2                	mov    %eax,%edx
  80107c:	8b 45 a0             	mov    -0x60(%ebp),%eax
  80107f:	01 c0                	add    %eax,%eax
  801081:	89 c1                	mov    %eax,%ecx
  801083:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  801086:	01 c8                	add    %ecx,%eax
  801088:	89 85 00 ff ff ff    	mov    %eax,-0x100(%ebp)
  80108e:	8b 85 00 ff ff ff    	mov    -0x100(%ebp),%eax
  801094:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801099:	39 c2                	cmp    %eax,%edx
  80109b:	75 17                	jne    8010b4 <_main+0x107c>
				panic("free: page is not removed from WS");
  80109d:	83 ec 04             	sub    $0x4,%esp
  8010a0:	68 34 49 80 00       	push   $0x804934
  8010a5:	68 ed 00 00 00       	push   $0xed
  8010aa:	68 9c 47 80 00       	push   $0x80479c
  8010af:	e8 76 08 00 00       	call   80192a <_panic>
		freeFrames = sys_calculate_free_frames() ;
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
		free(ptr_allocations[1]);
		if ((usedDiskPages - sys_pf_calculate_allocated_pages()) != 0) panic("Wrong free: Extra or less pages are removed from PageFile");
		if ((sys_calculate_free_frames() - freeFrames) != 2 + 1) panic("Wrong free: WS pages in memory and/or page tables are not freed correctly");
		for (var = 0; var < (myEnv->page_WS_max_size); ++var)
  8010b4:	ff 45 e4             	incl   -0x1c(%ebp)
  8010b7:	a1 20 60 80 00       	mov    0x806020,%eax
  8010bc:	8b 50 74             	mov    0x74(%eax),%edx
  8010bf:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8010c2:	39 c2                	cmp    %eax,%edx
  8010c4:	0f 87 27 ff ff ff    	ja     800ff1 <_main+0xfb9>
			if(ROUNDDOWN(myEnv->__uptr_pws[var].virtual_address,PAGE_SIZE) == ROUNDDOWN((uint32)(&(shortArr[lastIndexOfShort])), PAGE_SIZE))
				panic("free: page is not removed from WS");
		}

		//Free 6 MB
		freeFrames = sys_calculate_free_frames() ;
  8010ca:	e8 ad 1e 00 00       	call   802f7c <sys_calculate_free_frames>
  8010cf:	89 85 24 ff ff ff    	mov    %eax,-0xdc(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  8010d5:	e8 42 1f 00 00       	call   80301c <sys_pf_calculate_allocated_pages>
  8010da:	89 85 20 ff ff ff    	mov    %eax,-0xe0(%ebp)
		free(ptr_allocations[6]);
  8010e0:	8b 85 80 fe ff ff    	mov    -0x180(%ebp),%eax
  8010e6:	83 ec 0c             	sub    $0xc,%esp
  8010e9:	50                   	push   %eax
  8010ea:	e8 02 1b 00 00       	call   802bf1 <free>
  8010ef:	83 c4 10             	add    $0x10,%esp
		if ((usedDiskPages - sys_pf_calculate_allocated_pages()) != 0) panic("Wrong free: Extra or less pages are removed from PageFile");
  8010f2:	e8 25 1f 00 00       	call   80301c <sys_pf_calculate_allocated_pages>
  8010f7:	3b 85 20 ff ff ff    	cmp    -0xe0(%ebp),%eax
  8010fd:	74 17                	je     801116 <_main+0x10de>
  8010ff:	83 ec 04             	sub    $0x4,%esp
  801102:	68 ac 48 80 00       	push   $0x8048ac
  801107:	68 f4 00 00 00       	push   $0xf4
  80110c:	68 9c 47 80 00       	push   $0x80479c
  801111:	e8 14 08 00 00       	call   80192a <_panic>
		if ((sys_calculate_free_frames() - freeFrames) != 3 + 1) panic("Wrong free: WS pages in memory and/or page tables are not freed correctly");
  801116:	e8 61 1e 00 00       	call   802f7c <sys_calculate_free_frames>
  80111b:	89 c2                	mov    %eax,%edx
  80111d:	8b 85 24 ff ff ff    	mov    -0xdc(%ebp),%eax
  801123:	29 c2                	sub    %eax,%edx
  801125:	89 d0                	mov    %edx,%eax
  801127:	83 f8 04             	cmp    $0x4,%eax
  80112a:	74 17                	je     801143 <_main+0x110b>
  80112c:	83 ec 04             	sub    $0x4,%esp
  80112f:	68 e8 48 80 00       	push   $0x8048e8
  801134:	68 f5 00 00 00       	push   $0xf5
  801139:	68 9c 47 80 00       	push   $0x80479c
  80113e:	e8 e7 07 00 00       	call   80192a <_panic>
		for (var = 0; var < (myEnv->page_WS_max_size); ++var)
  801143:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  80114a:	e9 3e 01 00 00       	jmp    80128d <_main+0x1255>
		{
			if(ROUNDDOWN(myEnv->__uptr_pws[var].virtual_address,PAGE_SIZE) == ROUNDDOWN((uint32)(&(byteArr2[0])), PAGE_SIZE))
  80114f:	a1 20 60 80 00       	mov    0x806020,%eax
  801154:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  80115a:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80115d:	89 d0                	mov    %edx,%eax
  80115f:	01 c0                	add    %eax,%eax
  801161:	01 d0                	add    %edx,%eax
  801163:	c1 e0 03             	shl    $0x3,%eax
  801166:	01 c8                	add    %ecx,%eax
  801168:	8b 00                	mov    (%eax),%eax
  80116a:	89 85 fc fe ff ff    	mov    %eax,-0x104(%ebp)
  801170:	8b 85 fc fe ff ff    	mov    -0x104(%ebp),%eax
  801176:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80117b:	89 c2                	mov    %eax,%edx
  80117d:	8b 85 58 ff ff ff    	mov    -0xa8(%ebp),%eax
  801183:	89 85 f8 fe ff ff    	mov    %eax,-0x108(%ebp)
  801189:	8b 85 f8 fe ff ff    	mov    -0x108(%ebp),%eax
  80118f:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801194:	39 c2                	cmp    %eax,%edx
  801196:	75 17                	jne    8011af <_main+0x1177>
				panic("free: page is not removed from WS");
  801198:	83 ec 04             	sub    $0x4,%esp
  80119b:	68 34 49 80 00       	push   $0x804934
  8011a0:	68 f9 00 00 00       	push   $0xf9
  8011a5:	68 9c 47 80 00       	push   $0x80479c
  8011aa:	e8 7b 07 00 00       	call   80192a <_panic>
			if(ROUNDDOWN(myEnv->__uptr_pws[var].virtual_address,PAGE_SIZE) == ROUNDDOWN((uint32)(&(byteArr2[lastIndexOfByte2/2])), PAGE_SIZE))
  8011af:	a1 20 60 80 00       	mov    0x806020,%eax
  8011b4:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  8011ba:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8011bd:	89 d0                	mov    %edx,%eax
  8011bf:	01 c0                	add    %eax,%eax
  8011c1:	01 d0                	add    %edx,%eax
  8011c3:	c1 e0 03             	shl    $0x3,%eax
  8011c6:	01 c8                	add    %ecx,%eax
  8011c8:	8b 00                	mov    (%eax),%eax
  8011ca:	89 85 f4 fe ff ff    	mov    %eax,-0x10c(%ebp)
  8011d0:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  8011d6:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8011db:	89 c2                	mov    %eax,%edx
  8011dd:	8b 85 5c ff ff ff    	mov    -0xa4(%ebp),%eax
  8011e3:	89 c1                	mov    %eax,%ecx
  8011e5:	c1 e9 1f             	shr    $0x1f,%ecx
  8011e8:	01 c8                	add    %ecx,%eax
  8011ea:	d1 f8                	sar    %eax
  8011ec:	89 c1                	mov    %eax,%ecx
  8011ee:	8b 85 58 ff ff ff    	mov    -0xa8(%ebp),%eax
  8011f4:	01 c8                	add    %ecx,%eax
  8011f6:	89 85 f0 fe ff ff    	mov    %eax,-0x110(%ebp)
  8011fc:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
  801202:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801207:	39 c2                	cmp    %eax,%edx
  801209:	75 17                	jne    801222 <_main+0x11ea>
				panic("free: page is not removed from WS");
  80120b:	83 ec 04             	sub    $0x4,%esp
  80120e:	68 34 49 80 00       	push   $0x804934
  801213:	68 fb 00 00 00       	push   $0xfb
  801218:	68 9c 47 80 00       	push   $0x80479c
  80121d:	e8 08 07 00 00       	call   80192a <_panic>
			if(ROUNDDOWN(myEnv->__uptr_pws[var].virtual_address,PAGE_SIZE) == ROUNDDOWN((uint32)(&(byteArr2[lastIndexOfByte2])), PAGE_SIZE))
  801222:	a1 20 60 80 00       	mov    0x806020,%eax
  801227:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  80122d:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  801230:	89 d0                	mov    %edx,%eax
  801232:	01 c0                	add    %eax,%eax
  801234:	01 d0                	add    %edx,%eax
  801236:	c1 e0 03             	shl    $0x3,%eax
  801239:	01 c8                	add    %ecx,%eax
  80123b:	8b 00                	mov    (%eax),%eax
  80123d:	89 85 ec fe ff ff    	mov    %eax,-0x114(%ebp)
  801243:	8b 85 ec fe ff ff    	mov    -0x114(%ebp),%eax
  801249:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80124e:	89 c1                	mov    %eax,%ecx
  801250:	8b 95 5c ff ff ff    	mov    -0xa4(%ebp),%edx
  801256:	8b 85 58 ff ff ff    	mov    -0xa8(%ebp),%eax
  80125c:	01 d0                	add    %edx,%eax
  80125e:	89 85 e8 fe ff ff    	mov    %eax,-0x118(%ebp)
  801264:	8b 85 e8 fe ff ff    	mov    -0x118(%ebp),%eax
  80126a:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80126f:	39 c1                	cmp    %eax,%ecx
  801271:	75 17                	jne    80128a <_main+0x1252>
				panic("free: page is not removed from WS");
  801273:	83 ec 04             	sub    $0x4,%esp
  801276:	68 34 49 80 00       	push   $0x804934
  80127b:	68 fd 00 00 00       	push   $0xfd
  801280:	68 9c 47 80 00       	push   $0x80479c
  801285:	e8 a0 06 00 00       	call   80192a <_panic>
		freeFrames = sys_calculate_free_frames() ;
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
		free(ptr_allocations[6]);
		if ((usedDiskPages - sys_pf_calculate_allocated_pages()) != 0) panic("Wrong free: Extra or less pages are removed from PageFile");
		if ((sys_calculate_free_frames() - freeFrames) != 3 + 1) panic("Wrong free: WS pages in memory and/or page tables are not freed correctly");
		for (var = 0; var < (myEnv->page_WS_max_size); ++var)
  80128a:	ff 45 e4             	incl   -0x1c(%ebp)
  80128d:	a1 20 60 80 00       	mov    0x806020,%eax
  801292:	8b 50 74             	mov    0x74(%eax),%edx
  801295:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801298:	39 c2                	cmp    %eax,%edx
  80129a:	0f 87 af fe ff ff    	ja     80114f <_main+0x1117>
			if(ROUNDDOWN(myEnv->__uptr_pws[var].virtual_address,PAGE_SIZE) == ROUNDDOWN((uint32)(&(byteArr2[lastIndexOfByte2])), PAGE_SIZE))
				panic("free: page is not removed from WS");
		}

		//Free 7 KB
		freeFrames = sys_calculate_free_frames() ;
  8012a0:	e8 d7 1c 00 00       	call   802f7c <sys_calculate_free_frames>
  8012a5:	89 85 24 ff ff ff    	mov    %eax,-0xdc(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  8012ab:	e8 6c 1d 00 00       	call   80301c <sys_pf_calculate_allocated_pages>
  8012b0:	89 85 20 ff ff ff    	mov    %eax,-0xe0(%ebp)
		free(ptr_allocations[4]);
  8012b6:	8b 85 78 fe ff ff    	mov    -0x188(%ebp),%eax
  8012bc:	83 ec 0c             	sub    $0xc,%esp
  8012bf:	50                   	push   %eax
  8012c0:	e8 2c 19 00 00       	call   802bf1 <free>
  8012c5:	83 c4 10             	add    $0x10,%esp
		if ((usedDiskPages - sys_pf_calculate_allocated_pages()) != 0) panic("Wrong free: Extra or less pages are removed from PageFile");
  8012c8:	e8 4f 1d 00 00       	call   80301c <sys_pf_calculate_allocated_pages>
  8012cd:	3b 85 20 ff ff ff    	cmp    -0xe0(%ebp),%eax
  8012d3:	74 17                	je     8012ec <_main+0x12b4>
  8012d5:	83 ec 04             	sub    $0x4,%esp
  8012d8:	68 ac 48 80 00       	push   $0x8048ac
  8012dd:	68 04 01 00 00       	push   $0x104
  8012e2:	68 9c 47 80 00       	push   $0x80479c
  8012e7:	e8 3e 06 00 00       	call   80192a <_panic>
		if ((sys_calculate_free_frames() - freeFrames) != 2) panic("Wrong free: WS pages in memory and/or page tables are not freed correctly");
  8012ec:	e8 8b 1c 00 00       	call   802f7c <sys_calculate_free_frames>
  8012f1:	89 c2                	mov    %eax,%edx
  8012f3:	8b 85 24 ff ff ff    	mov    -0xdc(%ebp),%eax
  8012f9:	29 c2                	sub    %eax,%edx
  8012fb:	89 d0                	mov    %edx,%eax
  8012fd:	83 f8 02             	cmp    $0x2,%eax
  801300:	74 17                	je     801319 <_main+0x12e1>
  801302:	83 ec 04             	sub    $0x4,%esp
  801305:	68 e8 48 80 00       	push   $0x8048e8
  80130a:	68 05 01 00 00       	push   $0x105
  80130f:	68 9c 47 80 00       	push   $0x80479c
  801314:	e8 11 06 00 00       	call   80192a <_panic>
		for (var = 0; var < (myEnv->page_WS_max_size); ++var)
  801319:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  801320:	e9 d2 00 00 00       	jmp    8013f7 <_main+0x13bf>
		{
			if(ROUNDDOWN(myEnv->__uptr_pws[var].virtual_address,PAGE_SIZE) == ROUNDDOWN((uint32)(&(structArr[0])), PAGE_SIZE))
  801325:	a1 20 60 80 00       	mov    0x806020,%eax
  80132a:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  801330:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  801333:	89 d0                	mov    %edx,%eax
  801335:	01 c0                	add    %eax,%eax
  801337:	01 d0                	add    %edx,%eax
  801339:	c1 e0 03             	shl    $0x3,%eax
  80133c:	01 c8                	add    %ecx,%eax
  80133e:	8b 00                	mov    (%eax),%eax
  801340:	89 85 e4 fe ff ff    	mov    %eax,-0x11c(%ebp)
  801346:	8b 85 e4 fe ff ff    	mov    -0x11c(%ebp),%eax
  80134c:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801351:	89 c2                	mov    %eax,%edx
  801353:	8b 85 74 ff ff ff    	mov    -0x8c(%ebp),%eax
  801359:	89 85 e0 fe ff ff    	mov    %eax,-0x120(%ebp)
  80135f:	8b 85 e0 fe ff ff    	mov    -0x120(%ebp),%eax
  801365:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80136a:	39 c2                	cmp    %eax,%edx
  80136c:	75 17                	jne    801385 <_main+0x134d>
				panic("free: page is not removed from WS");
  80136e:	83 ec 04             	sub    $0x4,%esp
  801371:	68 34 49 80 00       	push   $0x804934
  801376:	68 09 01 00 00       	push   $0x109
  80137b:	68 9c 47 80 00       	push   $0x80479c
  801380:	e8 a5 05 00 00       	call   80192a <_panic>
			if(ROUNDDOWN(myEnv->__uptr_pws[var].virtual_address,PAGE_SIZE) == ROUNDDOWN((uint32)(&(structArr[lastIndexOfStruct])), PAGE_SIZE))
  801385:	a1 20 60 80 00       	mov    0x806020,%eax
  80138a:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  801390:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  801393:	89 d0                	mov    %edx,%eax
  801395:	01 c0                	add    %eax,%eax
  801397:	01 d0                	add    %edx,%eax
  801399:	c1 e0 03             	shl    $0x3,%eax
  80139c:	01 c8                	add    %ecx,%eax
  80139e:	8b 00                	mov    (%eax),%eax
  8013a0:	89 85 dc fe ff ff    	mov    %eax,-0x124(%ebp)
  8013a6:	8b 85 dc fe ff ff    	mov    -0x124(%ebp),%eax
  8013ac:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8013b1:	89 c2                	mov    %eax,%edx
  8013b3:	8b 85 70 ff ff ff    	mov    -0x90(%ebp),%eax
  8013b9:	8d 0c c5 00 00 00 00 	lea    0x0(,%eax,8),%ecx
  8013c0:	8b 85 74 ff ff ff    	mov    -0x8c(%ebp),%eax
  8013c6:	01 c8                	add    %ecx,%eax
  8013c8:	89 85 d8 fe ff ff    	mov    %eax,-0x128(%ebp)
  8013ce:	8b 85 d8 fe ff ff    	mov    -0x128(%ebp),%eax
  8013d4:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8013d9:	39 c2                	cmp    %eax,%edx
  8013db:	75 17                	jne    8013f4 <_main+0x13bc>
				panic("free: page is not removed from WS");
  8013dd:	83 ec 04             	sub    $0x4,%esp
  8013e0:	68 34 49 80 00       	push   $0x804934
  8013e5:	68 0b 01 00 00       	push   $0x10b
  8013ea:	68 9c 47 80 00       	push   $0x80479c
  8013ef:	e8 36 05 00 00       	call   80192a <_panic>
		freeFrames = sys_calculate_free_frames() ;
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
		free(ptr_allocations[4]);
		if ((usedDiskPages - sys_pf_calculate_allocated_pages()) != 0) panic("Wrong free: Extra or less pages are removed from PageFile");
		if ((sys_calculate_free_frames() - freeFrames) != 2) panic("Wrong free: WS pages in memory and/or page tables are not freed correctly");
		for (var = 0; var < (myEnv->page_WS_max_size); ++var)
  8013f4:	ff 45 e4             	incl   -0x1c(%ebp)
  8013f7:	a1 20 60 80 00       	mov    0x806020,%eax
  8013fc:	8b 50 74             	mov    0x74(%eax),%edx
  8013ff:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801402:	39 c2                	cmp    %eax,%edx
  801404:	0f 87 1b ff ff ff    	ja     801325 <_main+0x12ed>
			if(ROUNDDOWN(myEnv->__uptr_pws[var].virtual_address,PAGE_SIZE) == ROUNDDOWN((uint32)(&(structArr[lastIndexOfStruct])), PAGE_SIZE))
				panic("free: page is not removed from WS");
		}

		//Free 3 MB
		freeFrames = sys_calculate_free_frames() ;
  80140a:	e8 6d 1b 00 00       	call   802f7c <sys_calculate_free_frames>
  80140f:	89 85 24 ff ff ff    	mov    %eax,-0xdc(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  801415:	e8 02 1c 00 00       	call   80301c <sys_pf_calculate_allocated_pages>
  80141a:	89 85 20 ff ff ff    	mov    %eax,-0xe0(%ebp)
		free(ptr_allocations[5]);
  801420:	8b 85 7c fe ff ff    	mov    -0x184(%ebp),%eax
  801426:	83 ec 0c             	sub    $0xc,%esp
  801429:	50                   	push   %eax
  80142a:	e8 c2 17 00 00       	call   802bf1 <free>
  80142f:	83 c4 10             	add    $0x10,%esp
		if ((usedDiskPages - sys_pf_calculate_allocated_pages()) != 0) panic("Wrong free: Extra or less pages are removed from PageFile");
  801432:	e8 e5 1b 00 00       	call   80301c <sys_pf_calculate_allocated_pages>
  801437:	3b 85 20 ff ff ff    	cmp    -0xe0(%ebp),%eax
  80143d:	74 17                	je     801456 <_main+0x141e>
  80143f:	83 ec 04             	sub    $0x4,%esp
  801442:	68 ac 48 80 00       	push   $0x8048ac
  801447:	68 12 01 00 00       	push   $0x112
  80144c:	68 9c 47 80 00       	push   $0x80479c
  801451:	e8 d4 04 00 00       	call   80192a <_panic>
		if ((sys_calculate_free_frames() - freeFrames) != 0) panic("Wrong free: WS pages in memory and/or page tables are not freed correctly");
  801456:	e8 21 1b 00 00       	call   802f7c <sys_calculate_free_frames>
  80145b:	89 c2                	mov    %eax,%edx
  80145d:	8b 85 24 ff ff ff    	mov    -0xdc(%ebp),%eax
  801463:	39 c2                	cmp    %eax,%edx
  801465:	74 17                	je     80147e <_main+0x1446>
  801467:	83 ec 04             	sub    $0x4,%esp
  80146a:	68 e8 48 80 00       	push   $0x8048e8
  80146f:	68 13 01 00 00       	push   $0x113
  801474:	68 9c 47 80 00       	push   $0x80479c
  801479:	e8 ac 04 00 00       	call   80192a <_panic>

		//Free 1st 2 KB
		freeFrames = sys_calculate_free_frames() ;
  80147e:	e8 f9 1a 00 00       	call   802f7c <sys_calculate_free_frames>
  801483:	89 85 24 ff ff ff    	mov    %eax,-0xdc(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  801489:	e8 8e 1b 00 00       	call   80301c <sys_pf_calculate_allocated_pages>
  80148e:	89 85 20 ff ff ff    	mov    %eax,-0xe0(%ebp)
		free(ptr_allocations[2]);
  801494:	8b 85 70 fe ff ff    	mov    -0x190(%ebp),%eax
  80149a:	83 ec 0c             	sub    $0xc,%esp
  80149d:	50                   	push   %eax
  80149e:	e8 4e 17 00 00       	call   802bf1 <free>
  8014a3:	83 c4 10             	add    $0x10,%esp
		if ((usedDiskPages - sys_pf_calculate_allocated_pages()) != 0) panic("Wrong free: Extra or less pages are removed from PageFile");
  8014a6:	e8 71 1b 00 00       	call   80301c <sys_pf_calculate_allocated_pages>
  8014ab:	3b 85 20 ff ff ff    	cmp    -0xe0(%ebp),%eax
  8014b1:	74 17                	je     8014ca <_main+0x1492>
  8014b3:	83 ec 04             	sub    $0x4,%esp
  8014b6:	68 ac 48 80 00       	push   $0x8048ac
  8014bb:	68 19 01 00 00       	push   $0x119
  8014c0:	68 9c 47 80 00       	push   $0x80479c
  8014c5:	e8 60 04 00 00       	call   80192a <_panic>
		if ((sys_calculate_free_frames() - freeFrames) != 1 + 1) panic("Wrong free: WS pages in memory and/or page tables are not freed correctly");
  8014ca:	e8 ad 1a 00 00       	call   802f7c <sys_calculate_free_frames>
  8014cf:	89 c2                	mov    %eax,%edx
  8014d1:	8b 85 24 ff ff ff    	mov    -0xdc(%ebp),%eax
  8014d7:	29 c2                	sub    %eax,%edx
  8014d9:	89 d0                	mov    %edx,%eax
  8014db:	83 f8 02             	cmp    $0x2,%eax
  8014de:	74 17                	je     8014f7 <_main+0x14bf>
  8014e0:	83 ec 04             	sub    $0x4,%esp
  8014e3:	68 e8 48 80 00       	push   $0x8048e8
  8014e8:	68 1a 01 00 00       	push   $0x11a
  8014ed:	68 9c 47 80 00       	push   $0x80479c
  8014f2:	e8 33 04 00 00       	call   80192a <_panic>
		for (var = 0; var < (myEnv->page_WS_max_size); ++var)
  8014f7:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  8014fe:	e9 c9 00 00 00       	jmp    8015cc <_main+0x1594>
		{
			if(ROUNDDOWN(myEnv->__uptr_pws[var].virtual_address,PAGE_SIZE) == ROUNDDOWN((uint32)(&(intArr[0])), PAGE_SIZE))
  801503:	a1 20 60 80 00       	mov    0x806020,%eax
  801508:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  80150e:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  801511:	89 d0                	mov    %edx,%eax
  801513:	01 c0                	add    %eax,%eax
  801515:	01 d0                	add    %edx,%eax
  801517:	c1 e0 03             	shl    $0x3,%eax
  80151a:	01 c8                	add    %ecx,%eax
  80151c:	8b 00                	mov    (%eax),%eax
  80151e:	89 85 d4 fe ff ff    	mov    %eax,-0x12c(%ebp)
  801524:	8b 85 d4 fe ff ff    	mov    -0x12c(%ebp),%eax
  80152a:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80152f:	89 c2                	mov    %eax,%edx
  801531:	8b 45 8c             	mov    -0x74(%ebp),%eax
  801534:	89 85 d0 fe ff ff    	mov    %eax,-0x130(%ebp)
  80153a:	8b 85 d0 fe ff ff    	mov    -0x130(%ebp),%eax
  801540:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801545:	39 c2                	cmp    %eax,%edx
  801547:	75 17                	jne    801560 <_main+0x1528>
				panic("free: page is not removed from WS");
  801549:	83 ec 04             	sub    $0x4,%esp
  80154c:	68 34 49 80 00       	push   $0x804934
  801551:	68 1e 01 00 00       	push   $0x11e
  801556:	68 9c 47 80 00       	push   $0x80479c
  80155b:	e8 ca 03 00 00       	call   80192a <_panic>
			if(ROUNDDOWN(myEnv->__uptr_pws[var].virtual_address,PAGE_SIZE) == ROUNDDOWN((uint32)(&(intArr[lastIndexOfInt])), PAGE_SIZE))
  801560:	a1 20 60 80 00       	mov    0x806020,%eax
  801565:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  80156b:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80156e:	89 d0                	mov    %edx,%eax
  801570:	01 c0                	add    %eax,%eax
  801572:	01 d0                	add    %edx,%eax
  801574:	c1 e0 03             	shl    $0x3,%eax
  801577:	01 c8                	add    %ecx,%eax
  801579:	8b 00                	mov    (%eax),%eax
  80157b:	89 85 cc fe ff ff    	mov    %eax,-0x134(%ebp)
  801581:	8b 85 cc fe ff ff    	mov    -0x134(%ebp),%eax
  801587:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80158c:	89 c2                	mov    %eax,%edx
  80158e:	8b 45 88             	mov    -0x78(%ebp),%eax
  801591:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  801598:	8b 45 8c             	mov    -0x74(%ebp),%eax
  80159b:	01 c8                	add    %ecx,%eax
  80159d:	89 85 c8 fe ff ff    	mov    %eax,-0x138(%ebp)
  8015a3:	8b 85 c8 fe ff ff    	mov    -0x138(%ebp),%eax
  8015a9:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8015ae:	39 c2                	cmp    %eax,%edx
  8015b0:	75 17                	jne    8015c9 <_main+0x1591>
				panic("free: page is not removed from WS");
  8015b2:	83 ec 04             	sub    $0x4,%esp
  8015b5:	68 34 49 80 00       	push   $0x804934
  8015ba:	68 20 01 00 00       	push   $0x120
  8015bf:	68 9c 47 80 00       	push   $0x80479c
  8015c4:	e8 61 03 00 00       	call   80192a <_panic>
		freeFrames = sys_calculate_free_frames() ;
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
		free(ptr_allocations[2]);
		if ((usedDiskPages - sys_pf_calculate_allocated_pages()) != 0) panic("Wrong free: Extra or less pages are removed from PageFile");
		if ((sys_calculate_free_frames() - freeFrames) != 1 + 1) panic("Wrong free: WS pages in memory and/or page tables are not freed correctly");
		for (var = 0; var < (myEnv->page_WS_max_size); ++var)
  8015c9:	ff 45 e4             	incl   -0x1c(%ebp)
  8015cc:	a1 20 60 80 00       	mov    0x806020,%eax
  8015d1:	8b 50 74             	mov    0x74(%eax),%edx
  8015d4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8015d7:	39 c2                	cmp    %eax,%edx
  8015d9:	0f 87 24 ff ff ff    	ja     801503 <_main+0x14cb>
			if(ROUNDDOWN(myEnv->__uptr_pws[var].virtual_address,PAGE_SIZE) == ROUNDDOWN((uint32)(&(intArr[lastIndexOfInt])), PAGE_SIZE))
				panic("free: page is not removed from WS");
		}

		//Free 2nd 2 KB
		freeFrames = sys_calculate_free_frames() ;
  8015df:	e8 98 19 00 00       	call   802f7c <sys_calculate_free_frames>
  8015e4:	89 85 24 ff ff ff    	mov    %eax,-0xdc(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  8015ea:	e8 2d 1a 00 00       	call   80301c <sys_pf_calculate_allocated_pages>
  8015ef:	89 85 20 ff ff ff    	mov    %eax,-0xe0(%ebp)
		free(ptr_allocations[3]);
  8015f5:	8b 85 74 fe ff ff    	mov    -0x18c(%ebp),%eax
  8015fb:	83 ec 0c             	sub    $0xc,%esp
  8015fe:	50                   	push   %eax
  8015ff:	e8 ed 15 00 00       	call   802bf1 <free>
  801604:	83 c4 10             	add    $0x10,%esp
		if ((usedDiskPages - sys_pf_calculate_allocated_pages()) != 0) panic("Wrong free: Extra or less pages are removed from PageFile");
  801607:	e8 10 1a 00 00       	call   80301c <sys_pf_calculate_allocated_pages>
  80160c:	3b 85 20 ff ff ff    	cmp    -0xe0(%ebp),%eax
  801612:	74 17                	je     80162b <_main+0x15f3>
  801614:	83 ec 04             	sub    $0x4,%esp
  801617:	68 ac 48 80 00       	push   $0x8048ac
  80161c:	68 27 01 00 00       	push   $0x127
  801621:	68 9c 47 80 00       	push   $0x80479c
  801626:	e8 ff 02 00 00       	call   80192a <_panic>
		if ((sys_calculate_free_frames() - freeFrames) != 0) panic("Wrong free: WS pages in memory and/or page tables are not freed correctly");
  80162b:	e8 4c 19 00 00       	call   802f7c <sys_calculate_free_frames>
  801630:	89 c2                	mov    %eax,%edx
  801632:	8b 85 24 ff ff ff    	mov    -0xdc(%ebp),%eax
  801638:	39 c2                	cmp    %eax,%edx
  80163a:	74 17                	je     801653 <_main+0x161b>
  80163c:	83 ec 04             	sub    $0x4,%esp
  80163f:	68 e8 48 80 00       	push   $0x8048e8
  801644:	68 28 01 00 00       	push   $0x128
  801649:	68 9c 47 80 00       	push   $0x80479c
  80164e:	e8 d7 02 00 00       	call   80192a <_panic>


		//Free last 14 KB
		freeFrames = sys_calculate_free_frames() ;
  801653:	e8 24 19 00 00       	call   802f7c <sys_calculate_free_frames>
  801658:	89 85 24 ff ff ff    	mov    %eax,-0xdc(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  80165e:	e8 b9 19 00 00       	call   80301c <sys_pf_calculate_allocated_pages>
  801663:	89 85 20 ff ff ff    	mov    %eax,-0xe0(%ebp)
		free(ptr_allocations[7]);
  801669:	8b 85 84 fe ff ff    	mov    -0x17c(%ebp),%eax
  80166f:	83 ec 0c             	sub    $0xc,%esp
  801672:	50                   	push   %eax
  801673:	e8 79 15 00 00       	call   802bf1 <free>
  801678:	83 c4 10             	add    $0x10,%esp
		if ((usedDiskPages - sys_pf_calculate_allocated_pages()) != 0) panic("Wrong free: Extra or less pages are removed from PageFile");
  80167b:	e8 9c 19 00 00       	call   80301c <sys_pf_calculate_allocated_pages>
  801680:	3b 85 20 ff ff ff    	cmp    -0xe0(%ebp),%eax
  801686:	74 17                	je     80169f <_main+0x1667>
  801688:	83 ec 04             	sub    $0x4,%esp
  80168b:	68 ac 48 80 00       	push   $0x8048ac
  801690:	68 2f 01 00 00       	push   $0x12f
  801695:	68 9c 47 80 00       	push   $0x80479c
  80169a:	e8 8b 02 00 00       	call   80192a <_panic>
		if ((sys_calculate_free_frames() - freeFrames) != 2 + 1) panic("Wrong free: WS pages in memory and/or page tables are not freed correctly");
  80169f:	e8 d8 18 00 00       	call   802f7c <sys_calculate_free_frames>
  8016a4:	89 c2                	mov    %eax,%edx
  8016a6:	8b 85 24 ff ff ff    	mov    -0xdc(%ebp),%eax
  8016ac:	29 c2                	sub    %eax,%edx
  8016ae:	89 d0                	mov    %edx,%eax
  8016b0:	83 f8 03             	cmp    $0x3,%eax
  8016b3:	74 17                	je     8016cc <_main+0x1694>
  8016b5:	83 ec 04             	sub    $0x4,%esp
  8016b8:	68 e8 48 80 00       	push   $0x8048e8
  8016bd:	68 30 01 00 00       	push   $0x130
  8016c2:	68 9c 47 80 00       	push   $0x80479c
  8016c7:	e8 5e 02 00 00       	call   80192a <_panic>
		for (var = 0; var < (myEnv->page_WS_max_size); ++var)
  8016cc:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  8016d3:	e9 c6 00 00 00       	jmp    80179e <_main+0x1766>
		{
			if(ROUNDDOWN(myEnv->__uptr_pws[var].virtual_address,PAGE_SIZE) == ROUNDDOWN((uint32)(&(shortArr[0])), PAGE_SIZE))
  8016d8:	a1 20 60 80 00       	mov    0x806020,%eax
  8016dd:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  8016e3:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8016e6:	89 d0                	mov    %edx,%eax
  8016e8:	01 c0                	add    %eax,%eax
  8016ea:	01 d0                	add    %edx,%eax
  8016ec:	c1 e0 03             	shl    $0x3,%eax
  8016ef:	01 c8                	add    %ecx,%eax
  8016f1:	8b 00                	mov    (%eax),%eax
  8016f3:	89 85 c4 fe ff ff    	mov    %eax,-0x13c(%ebp)
  8016f9:	8b 85 c4 fe ff ff    	mov    -0x13c(%ebp),%eax
  8016ff:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801704:	89 c2                	mov    %eax,%edx
  801706:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  801709:	89 85 c0 fe ff ff    	mov    %eax,-0x140(%ebp)
  80170f:	8b 85 c0 fe ff ff    	mov    -0x140(%ebp),%eax
  801715:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80171a:	39 c2                	cmp    %eax,%edx
  80171c:	75 17                	jne    801735 <_main+0x16fd>
				panic("free: page is not removed from WS");
  80171e:	83 ec 04             	sub    $0x4,%esp
  801721:	68 34 49 80 00       	push   $0x804934
  801726:	68 34 01 00 00       	push   $0x134
  80172b:	68 9c 47 80 00       	push   $0x80479c
  801730:	e8 f5 01 00 00       	call   80192a <_panic>
			if(ROUNDDOWN(myEnv->__uptr_pws[var].virtual_address,PAGE_SIZE) == ROUNDDOWN((uint32)(&(shortArr[lastIndexOfShort])), PAGE_SIZE))
  801735:	a1 20 60 80 00       	mov    0x806020,%eax
  80173a:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  801740:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  801743:	89 d0                	mov    %edx,%eax
  801745:	01 c0                	add    %eax,%eax
  801747:	01 d0                	add    %edx,%eax
  801749:	c1 e0 03             	shl    $0x3,%eax
  80174c:	01 c8                	add    %ecx,%eax
  80174e:	8b 00                	mov    (%eax),%eax
  801750:	89 85 bc fe ff ff    	mov    %eax,-0x144(%ebp)
  801756:	8b 85 bc fe ff ff    	mov    -0x144(%ebp),%eax
  80175c:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801761:	89 c2                	mov    %eax,%edx
  801763:	8b 45 a0             	mov    -0x60(%ebp),%eax
  801766:	01 c0                	add    %eax,%eax
  801768:	89 c1                	mov    %eax,%ecx
  80176a:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  80176d:	01 c8                	add    %ecx,%eax
  80176f:	89 85 b8 fe ff ff    	mov    %eax,-0x148(%ebp)
  801775:	8b 85 b8 fe ff ff    	mov    -0x148(%ebp),%eax
  80177b:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801780:	39 c2                	cmp    %eax,%edx
  801782:	75 17                	jne    80179b <_main+0x1763>
				panic("free: page is not removed from WS");
  801784:	83 ec 04             	sub    $0x4,%esp
  801787:	68 34 49 80 00       	push   $0x804934
  80178c:	68 36 01 00 00       	push   $0x136
  801791:	68 9c 47 80 00       	push   $0x80479c
  801796:	e8 8f 01 00 00       	call   80192a <_panic>
		freeFrames = sys_calculate_free_frames() ;
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
		free(ptr_allocations[7]);
		if ((usedDiskPages - sys_pf_calculate_allocated_pages()) != 0) panic("Wrong free: Extra or less pages are removed from PageFile");
		if ((sys_calculate_free_frames() - freeFrames) != 2 + 1) panic("Wrong free: WS pages in memory and/or page tables are not freed correctly");
		for (var = 0; var < (myEnv->page_WS_max_size); ++var)
  80179b:	ff 45 e4             	incl   -0x1c(%ebp)
  80179e:	a1 20 60 80 00       	mov    0x806020,%eax
  8017a3:	8b 50 74             	mov    0x74(%eax),%edx
  8017a6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8017a9:	39 c2                	cmp    %eax,%edx
  8017ab:	0f 87 27 ff ff ff    	ja     8016d8 <_main+0x16a0>
				panic("free: page is not removed from WS");
			if(ROUNDDOWN(myEnv->__uptr_pws[var].virtual_address,PAGE_SIZE) == ROUNDDOWN((uint32)(&(shortArr[lastIndexOfShort])), PAGE_SIZE))
				panic("free: page is not removed from WS");
		}

		if(start_freeFrames != (sys_calculate_free_frames())) {panic("Wrong free: not all pages removed correctly at end");}
  8017b1:	e8 c6 17 00 00       	call   802f7c <sys_calculate_free_frames>
  8017b6:	89 c2                	mov    %eax,%edx
  8017b8:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8017bb:	39 c2                	cmp    %eax,%edx
  8017bd:	74 17                	je     8017d6 <_main+0x179e>
  8017bf:	83 ec 04             	sub    $0x4,%esp
  8017c2:	68 58 49 80 00       	push   $0x804958
  8017c7:	68 39 01 00 00       	push   $0x139
  8017cc:	68 9c 47 80 00       	push   $0x80479c
  8017d1:	e8 54 01 00 00       	call   80192a <_panic>
	}

	cprintf("Congratulations!! test free [1] completed successfully.\n");
  8017d6:	83 ec 0c             	sub    $0xc,%esp
  8017d9:	68 8c 49 80 00       	push   $0x80498c
  8017de:	e8 fb 03 00 00       	call   801bde <cprintf>
  8017e3:	83 c4 10             	add    $0x10,%esp

	return;
  8017e6:	90                   	nop
}
  8017e7:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8017ea:	5b                   	pop    %ebx
  8017eb:	5f                   	pop    %edi
  8017ec:	5d                   	pop    %ebp
  8017ed:	c3                   	ret    

008017ee <libmain>:
volatile struct Env *myEnv = NULL;
volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";

void
libmain(int argc, char **argv)
{
  8017ee:	55                   	push   %ebp
  8017ef:	89 e5                	mov    %esp,%ebp
  8017f1:	83 ec 18             	sub    $0x18,%esp
	int envIndex = sys_getenvindex();
  8017f4:	e8 63 1a 00 00       	call   80325c <sys_getenvindex>
  8017f9:	89 45 f4             	mov    %eax,-0xc(%ebp)
	myEnv = &(envs[envIndex]);
  8017fc:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8017ff:	89 d0                	mov    %edx,%eax
  801801:	c1 e0 03             	shl    $0x3,%eax
  801804:	01 d0                	add    %edx,%eax
  801806:	01 c0                	add    %eax,%eax
  801808:	01 d0                	add    %edx,%eax
  80180a:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801811:	01 d0                	add    %edx,%eax
  801813:	c1 e0 04             	shl    $0x4,%eax
  801816:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  80181b:	a3 20 60 80 00       	mov    %eax,0x806020

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  801820:	a1 20 60 80 00       	mov    0x806020,%eax
  801825:	8a 80 5c 05 00 00    	mov    0x55c(%eax),%al
  80182b:	84 c0                	test   %al,%al
  80182d:	74 0f                	je     80183e <libmain+0x50>
		binaryname = myEnv->prog_name;
  80182f:	a1 20 60 80 00       	mov    0x806020,%eax
  801834:	05 5c 05 00 00       	add    $0x55c,%eax
  801839:	a3 00 60 80 00       	mov    %eax,0x806000

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  80183e:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801842:	7e 0a                	jle    80184e <libmain+0x60>
		binaryname = argv[0];
  801844:	8b 45 0c             	mov    0xc(%ebp),%eax
  801847:	8b 00                	mov    (%eax),%eax
  801849:	a3 00 60 80 00       	mov    %eax,0x806000

	// call user main routine
	_main(argc, argv);
  80184e:	83 ec 08             	sub    $0x8,%esp
  801851:	ff 75 0c             	pushl  0xc(%ebp)
  801854:	ff 75 08             	pushl  0x8(%ebp)
  801857:	e8 dc e7 ff ff       	call   800038 <_main>
  80185c:	83 c4 10             	add    $0x10,%esp



	sys_disable_interrupt();
  80185f:	e8 05 18 00 00       	call   803069 <sys_disable_interrupt>
	cprintf("**************************************\n");
  801864:	83 ec 0c             	sub    $0xc,%esp
  801867:	68 e0 49 80 00       	push   $0x8049e0
  80186c:	e8 6d 03 00 00       	call   801bde <cprintf>
  801871:	83 c4 10             	add    $0x10,%esp
	cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  801874:	a1 20 60 80 00       	mov    0x806020,%eax
  801879:	8b 90 44 05 00 00    	mov    0x544(%eax),%edx
  80187f:	a1 20 60 80 00       	mov    0x806020,%eax
  801884:	8b 80 34 05 00 00    	mov    0x534(%eax),%eax
  80188a:	83 ec 04             	sub    $0x4,%esp
  80188d:	52                   	push   %edx
  80188e:	50                   	push   %eax
  80188f:	68 08 4a 80 00       	push   $0x804a08
  801894:	e8 45 03 00 00       	call   801bde <cprintf>
  801899:	83 c4 10             	add    $0x10,%esp
	cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  80189c:	a1 20 60 80 00       	mov    0x806020,%eax
  8018a1:	8b 88 54 05 00 00    	mov    0x554(%eax),%ecx
  8018a7:	a1 20 60 80 00       	mov    0x806020,%eax
  8018ac:	8b 90 50 05 00 00    	mov    0x550(%eax),%edx
  8018b2:	a1 20 60 80 00       	mov    0x806020,%eax
  8018b7:	8b 80 4c 05 00 00    	mov    0x54c(%eax),%eax
  8018bd:	51                   	push   %ecx
  8018be:	52                   	push   %edx
  8018bf:	50                   	push   %eax
  8018c0:	68 30 4a 80 00       	push   $0x804a30
  8018c5:	e8 14 03 00 00       	call   801bde <cprintf>
  8018ca:	83 c4 10             	add    $0x10,%esp
	//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
	cprintf("Num of clocks = %d\n", myEnv->nClocks);
  8018cd:	a1 20 60 80 00       	mov    0x806020,%eax
  8018d2:	8b 80 a4 05 00 00    	mov    0x5a4(%eax),%eax
  8018d8:	83 ec 08             	sub    $0x8,%esp
  8018db:	50                   	push   %eax
  8018dc:	68 88 4a 80 00       	push   $0x804a88
  8018e1:	e8 f8 02 00 00       	call   801bde <cprintf>
  8018e6:	83 c4 10             	add    $0x10,%esp
	cprintf("**************************************\n");
  8018e9:	83 ec 0c             	sub    $0xc,%esp
  8018ec:	68 e0 49 80 00       	push   $0x8049e0
  8018f1:	e8 e8 02 00 00       	call   801bde <cprintf>
  8018f6:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  8018f9:	e8 85 17 00 00       	call   803083 <sys_enable_interrupt>

	// exit gracefully
	exit();
  8018fe:	e8 19 00 00 00       	call   80191c <exit>
}
  801903:	90                   	nop
  801904:	c9                   	leave  
  801905:	c3                   	ret    

00801906 <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  801906:	55                   	push   %ebp
  801907:	89 e5                	mov    %esp,%ebp
  801909:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  80190c:	83 ec 0c             	sub    $0xc,%esp
  80190f:	6a 00                	push   $0x0
  801911:	e8 12 19 00 00       	call   803228 <sys_destroy_env>
  801916:	83 c4 10             	add    $0x10,%esp
}
  801919:	90                   	nop
  80191a:	c9                   	leave  
  80191b:	c3                   	ret    

0080191c <exit>:

void
exit(void)
{
  80191c:	55                   	push   %ebp
  80191d:	89 e5                	mov    %esp,%ebp
  80191f:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  801922:	e8 67 19 00 00       	call   80328e <sys_exit_env>
}
  801927:	90                   	nop
  801928:	c9                   	leave  
  801929:	c3                   	ret    

0080192a <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  80192a:	55                   	push   %ebp
  80192b:	89 e5                	mov    %esp,%ebp
  80192d:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  801930:	8d 45 10             	lea    0x10(%ebp),%eax
  801933:	83 c0 04             	add    $0x4,%eax
  801936:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  801939:	a1 5c 61 80 00       	mov    0x80615c,%eax
  80193e:	85 c0                	test   %eax,%eax
  801940:	74 16                	je     801958 <_panic+0x2e>
		cprintf("%s: ", argv0);
  801942:	a1 5c 61 80 00       	mov    0x80615c,%eax
  801947:	83 ec 08             	sub    $0x8,%esp
  80194a:	50                   	push   %eax
  80194b:	68 9c 4a 80 00       	push   $0x804a9c
  801950:	e8 89 02 00 00       	call   801bde <cprintf>
  801955:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  801958:	a1 00 60 80 00       	mov    0x806000,%eax
  80195d:	ff 75 0c             	pushl  0xc(%ebp)
  801960:	ff 75 08             	pushl  0x8(%ebp)
  801963:	50                   	push   %eax
  801964:	68 a1 4a 80 00       	push   $0x804aa1
  801969:	e8 70 02 00 00       	call   801bde <cprintf>
  80196e:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  801971:	8b 45 10             	mov    0x10(%ebp),%eax
  801974:	83 ec 08             	sub    $0x8,%esp
  801977:	ff 75 f4             	pushl  -0xc(%ebp)
  80197a:	50                   	push   %eax
  80197b:	e8 f3 01 00 00       	call   801b73 <vcprintf>
  801980:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  801983:	83 ec 08             	sub    $0x8,%esp
  801986:	6a 00                	push   $0x0
  801988:	68 bd 4a 80 00       	push   $0x804abd
  80198d:	e8 e1 01 00 00       	call   801b73 <vcprintf>
  801992:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  801995:	e8 82 ff ff ff       	call   80191c <exit>

	// should not return here
	while (1) ;
  80199a:	eb fe                	jmp    80199a <_panic+0x70>

0080199c <CheckWSWithoutLastIndex>:
}

void CheckWSWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  80199c:	55                   	push   %ebp
  80199d:	89 e5                	mov    %esp,%ebp
  80199f:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  8019a2:	a1 20 60 80 00       	mov    0x806020,%eax
  8019a7:	8b 50 74             	mov    0x74(%eax),%edx
  8019aa:	8b 45 0c             	mov    0xc(%ebp),%eax
  8019ad:	39 c2                	cmp    %eax,%edx
  8019af:	74 14                	je     8019c5 <CheckWSWithoutLastIndex+0x29>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  8019b1:	83 ec 04             	sub    $0x4,%esp
  8019b4:	68 c0 4a 80 00       	push   $0x804ac0
  8019b9:	6a 26                	push   $0x26
  8019bb:	68 0c 4b 80 00       	push   $0x804b0c
  8019c0:	e8 65 ff ff ff       	call   80192a <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  8019c5:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  8019cc:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  8019d3:	e9 c2 00 00 00       	jmp    801a9a <CheckWSWithoutLastIndex+0xfe>
		if (expectedPages[e] == 0) {
  8019d8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8019db:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8019e2:	8b 45 08             	mov    0x8(%ebp),%eax
  8019e5:	01 d0                	add    %edx,%eax
  8019e7:	8b 00                	mov    (%eax),%eax
  8019e9:	85 c0                	test   %eax,%eax
  8019eb:	75 08                	jne    8019f5 <CheckWSWithoutLastIndex+0x59>
			expectedNumOfEmptyLocs++;
  8019ed:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  8019f0:	e9 a2 00 00 00       	jmp    801a97 <CheckWSWithoutLastIndex+0xfb>
		}
		int found = 0;
  8019f5:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8019fc:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  801a03:	eb 69                	jmp    801a6e <CheckWSWithoutLastIndex+0xd2>
			if (myEnv->__uptr_pws[w].empty == 0) {
  801a05:	a1 20 60 80 00       	mov    0x806020,%eax
  801a0a:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  801a10:	8b 55 e8             	mov    -0x18(%ebp),%edx
  801a13:	89 d0                	mov    %edx,%eax
  801a15:	01 c0                	add    %eax,%eax
  801a17:	01 d0                	add    %edx,%eax
  801a19:	c1 e0 03             	shl    $0x3,%eax
  801a1c:	01 c8                	add    %ecx,%eax
  801a1e:	8a 40 04             	mov    0x4(%eax),%al
  801a21:	84 c0                	test   %al,%al
  801a23:	75 46                	jne    801a6b <CheckWSWithoutLastIndex+0xcf>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  801a25:	a1 20 60 80 00       	mov    0x806020,%eax
  801a2a:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  801a30:	8b 55 e8             	mov    -0x18(%ebp),%edx
  801a33:	89 d0                	mov    %edx,%eax
  801a35:	01 c0                	add    %eax,%eax
  801a37:	01 d0                	add    %edx,%eax
  801a39:	c1 e0 03             	shl    $0x3,%eax
  801a3c:	01 c8                	add    %ecx,%eax
  801a3e:	8b 00                	mov    (%eax),%eax
  801a40:	89 45 dc             	mov    %eax,-0x24(%ebp)
  801a43:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801a46:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801a4b:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  801a4d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801a50:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  801a57:	8b 45 08             	mov    0x8(%ebp),%eax
  801a5a:	01 c8                	add    %ecx,%eax
  801a5c:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  801a5e:	39 c2                	cmp    %eax,%edx
  801a60:	75 09                	jne    801a6b <CheckWSWithoutLastIndex+0xcf>
						== expectedPages[e]) {
					found = 1;
  801a62:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  801a69:	eb 12                	jmp    801a7d <CheckWSWithoutLastIndex+0xe1>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  801a6b:	ff 45 e8             	incl   -0x18(%ebp)
  801a6e:	a1 20 60 80 00       	mov    0x806020,%eax
  801a73:	8b 50 74             	mov    0x74(%eax),%edx
  801a76:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801a79:	39 c2                	cmp    %eax,%edx
  801a7b:	77 88                	ja     801a05 <CheckWSWithoutLastIndex+0x69>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  801a7d:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  801a81:	75 14                	jne    801a97 <CheckWSWithoutLastIndex+0xfb>
			panic(
  801a83:	83 ec 04             	sub    $0x4,%esp
  801a86:	68 18 4b 80 00       	push   $0x804b18
  801a8b:	6a 3a                	push   $0x3a
  801a8d:	68 0c 4b 80 00       	push   $0x804b0c
  801a92:	e8 93 fe ff ff       	call   80192a <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  801a97:	ff 45 f0             	incl   -0x10(%ebp)
  801a9a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801a9d:	3b 45 0c             	cmp    0xc(%ebp),%eax
  801aa0:	0f 8c 32 ff ff ff    	jl     8019d8 <CheckWSWithoutLastIndex+0x3c>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  801aa6:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  801aad:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  801ab4:	eb 26                	jmp    801adc <CheckWSWithoutLastIndex+0x140>
		if (myEnv->__uptr_pws[w].empty == 1) {
  801ab6:	a1 20 60 80 00       	mov    0x806020,%eax
  801abb:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  801ac1:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801ac4:	89 d0                	mov    %edx,%eax
  801ac6:	01 c0                	add    %eax,%eax
  801ac8:	01 d0                	add    %edx,%eax
  801aca:	c1 e0 03             	shl    $0x3,%eax
  801acd:	01 c8                	add    %ecx,%eax
  801acf:	8a 40 04             	mov    0x4(%eax),%al
  801ad2:	3c 01                	cmp    $0x1,%al
  801ad4:	75 03                	jne    801ad9 <CheckWSWithoutLastIndex+0x13d>
			actualNumOfEmptyLocs++;
  801ad6:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  801ad9:	ff 45 e0             	incl   -0x20(%ebp)
  801adc:	a1 20 60 80 00       	mov    0x806020,%eax
  801ae1:	8b 50 74             	mov    0x74(%eax),%edx
  801ae4:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801ae7:	39 c2                	cmp    %eax,%edx
  801ae9:	77 cb                	ja     801ab6 <CheckWSWithoutLastIndex+0x11a>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  801aeb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801aee:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  801af1:	74 14                	je     801b07 <CheckWSWithoutLastIndex+0x16b>
		panic(
  801af3:	83 ec 04             	sub    $0x4,%esp
  801af6:	68 6c 4b 80 00       	push   $0x804b6c
  801afb:	6a 44                	push   $0x44
  801afd:	68 0c 4b 80 00       	push   $0x804b0c
  801b02:	e8 23 fe ff ff       	call   80192a <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  801b07:	90                   	nop
  801b08:	c9                   	leave  
  801b09:	c3                   	ret    

00801b0a <putch>:
};

//2017:
uint8 printProgName = 0;

static void putch(int ch, struct printbuf *b) {
  801b0a:	55                   	push   %ebp
  801b0b:	89 e5                	mov    %esp,%ebp
  801b0d:	83 ec 08             	sub    $0x8,%esp
	b->buf[b->idx++] = ch;
  801b10:	8b 45 0c             	mov    0xc(%ebp),%eax
  801b13:	8b 00                	mov    (%eax),%eax
  801b15:	8d 48 01             	lea    0x1(%eax),%ecx
  801b18:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b1b:	89 0a                	mov    %ecx,(%edx)
  801b1d:	8b 55 08             	mov    0x8(%ebp),%edx
  801b20:	88 d1                	mov    %dl,%cl
  801b22:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b25:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  801b29:	8b 45 0c             	mov    0xc(%ebp),%eax
  801b2c:	8b 00                	mov    (%eax),%eax
  801b2e:	3d ff 00 00 00       	cmp    $0xff,%eax
  801b33:	75 2c                	jne    801b61 <putch+0x57>
		sys_cputs(b->buf, b->idx, printProgName);
  801b35:	a0 24 60 80 00       	mov    0x806024,%al
  801b3a:	0f b6 c0             	movzbl %al,%eax
  801b3d:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b40:	8b 12                	mov    (%edx),%edx
  801b42:	89 d1                	mov    %edx,%ecx
  801b44:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b47:	83 c2 08             	add    $0x8,%edx
  801b4a:	83 ec 04             	sub    $0x4,%esp
  801b4d:	50                   	push   %eax
  801b4e:	51                   	push   %ecx
  801b4f:	52                   	push   %edx
  801b50:	e8 66 13 00 00       	call   802ebb <sys_cputs>
  801b55:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  801b58:	8b 45 0c             	mov    0xc(%ebp),%eax
  801b5b:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  801b61:	8b 45 0c             	mov    0xc(%ebp),%eax
  801b64:	8b 40 04             	mov    0x4(%eax),%eax
  801b67:	8d 50 01             	lea    0x1(%eax),%edx
  801b6a:	8b 45 0c             	mov    0xc(%ebp),%eax
  801b6d:	89 50 04             	mov    %edx,0x4(%eax)
}
  801b70:	90                   	nop
  801b71:	c9                   	leave  
  801b72:	c3                   	ret    

00801b73 <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  801b73:	55                   	push   %ebp
  801b74:	89 e5                	mov    %esp,%ebp
  801b76:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  801b7c:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  801b83:	00 00 00 
	b.cnt = 0;
  801b86:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  801b8d:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  801b90:	ff 75 0c             	pushl  0xc(%ebp)
  801b93:	ff 75 08             	pushl  0x8(%ebp)
  801b96:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  801b9c:	50                   	push   %eax
  801b9d:	68 0a 1b 80 00       	push   $0x801b0a
  801ba2:	e8 11 02 00 00       	call   801db8 <vprintfmt>
  801ba7:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName);
  801baa:	a0 24 60 80 00       	mov    0x806024,%al
  801baf:	0f b6 c0             	movzbl %al,%eax
  801bb2:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  801bb8:	83 ec 04             	sub    $0x4,%esp
  801bbb:	50                   	push   %eax
  801bbc:	52                   	push   %edx
  801bbd:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  801bc3:	83 c0 08             	add    $0x8,%eax
  801bc6:	50                   	push   %eax
  801bc7:	e8 ef 12 00 00       	call   802ebb <sys_cputs>
  801bcc:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  801bcf:	c6 05 24 60 80 00 00 	movb   $0x0,0x806024
	return b.cnt;
  801bd6:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  801bdc:	c9                   	leave  
  801bdd:	c3                   	ret    

00801bde <cprintf>:

int cprintf(const char *fmt, ...) {
  801bde:	55                   	push   %ebp
  801bdf:	89 e5                	mov    %esp,%ebp
  801be1:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  801be4:	c6 05 24 60 80 00 01 	movb   $0x1,0x806024
	va_start(ap, fmt);
  801beb:	8d 45 0c             	lea    0xc(%ebp),%eax
  801bee:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  801bf1:	8b 45 08             	mov    0x8(%ebp),%eax
  801bf4:	83 ec 08             	sub    $0x8,%esp
  801bf7:	ff 75 f4             	pushl  -0xc(%ebp)
  801bfa:	50                   	push   %eax
  801bfb:	e8 73 ff ff ff       	call   801b73 <vcprintf>
  801c00:	83 c4 10             	add    $0x10,%esp
  801c03:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  801c06:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801c09:	c9                   	leave  
  801c0a:	c3                   	ret    

00801c0b <atomic_cprintf>:

int atomic_cprintf(const char *fmt, ...) {
  801c0b:	55                   	push   %ebp
  801c0c:	89 e5                	mov    %esp,%ebp
  801c0e:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  801c11:	e8 53 14 00 00       	call   803069 <sys_disable_interrupt>
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  801c16:	8d 45 0c             	lea    0xc(%ebp),%eax
  801c19:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  801c1c:	8b 45 08             	mov    0x8(%ebp),%eax
  801c1f:	83 ec 08             	sub    $0x8,%esp
  801c22:	ff 75 f4             	pushl  -0xc(%ebp)
  801c25:	50                   	push   %eax
  801c26:	e8 48 ff ff ff       	call   801b73 <vcprintf>
  801c2b:	83 c4 10             	add    $0x10,%esp
  801c2e:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	sys_enable_interrupt();
  801c31:	e8 4d 14 00 00       	call   803083 <sys_enable_interrupt>
	return cnt;
  801c36:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801c39:	c9                   	leave  
  801c3a:	c3                   	ret    

00801c3b <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  801c3b:	55                   	push   %ebp
  801c3c:	89 e5                	mov    %esp,%ebp
  801c3e:	53                   	push   %ebx
  801c3f:	83 ec 14             	sub    $0x14,%esp
  801c42:	8b 45 10             	mov    0x10(%ebp),%eax
  801c45:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801c48:	8b 45 14             	mov    0x14(%ebp),%eax
  801c4b:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  801c4e:	8b 45 18             	mov    0x18(%ebp),%eax
  801c51:	ba 00 00 00 00       	mov    $0x0,%edx
  801c56:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  801c59:	77 55                	ja     801cb0 <printnum+0x75>
  801c5b:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  801c5e:	72 05                	jb     801c65 <printnum+0x2a>
  801c60:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801c63:	77 4b                	ja     801cb0 <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  801c65:	8b 45 1c             	mov    0x1c(%ebp),%eax
  801c68:	8d 58 ff             	lea    -0x1(%eax),%ebx
  801c6b:	8b 45 18             	mov    0x18(%ebp),%eax
  801c6e:	ba 00 00 00 00       	mov    $0x0,%edx
  801c73:	52                   	push   %edx
  801c74:	50                   	push   %eax
  801c75:	ff 75 f4             	pushl  -0xc(%ebp)
  801c78:	ff 75 f0             	pushl  -0x10(%ebp)
  801c7b:	e8 84 28 00 00       	call   804504 <__udivdi3>
  801c80:	83 c4 10             	add    $0x10,%esp
  801c83:	83 ec 04             	sub    $0x4,%esp
  801c86:	ff 75 20             	pushl  0x20(%ebp)
  801c89:	53                   	push   %ebx
  801c8a:	ff 75 18             	pushl  0x18(%ebp)
  801c8d:	52                   	push   %edx
  801c8e:	50                   	push   %eax
  801c8f:	ff 75 0c             	pushl  0xc(%ebp)
  801c92:	ff 75 08             	pushl  0x8(%ebp)
  801c95:	e8 a1 ff ff ff       	call   801c3b <printnum>
  801c9a:	83 c4 20             	add    $0x20,%esp
  801c9d:	eb 1a                	jmp    801cb9 <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  801c9f:	83 ec 08             	sub    $0x8,%esp
  801ca2:	ff 75 0c             	pushl  0xc(%ebp)
  801ca5:	ff 75 20             	pushl  0x20(%ebp)
  801ca8:	8b 45 08             	mov    0x8(%ebp),%eax
  801cab:	ff d0                	call   *%eax
  801cad:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  801cb0:	ff 4d 1c             	decl   0x1c(%ebp)
  801cb3:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  801cb7:	7f e6                	jg     801c9f <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  801cb9:	8b 4d 18             	mov    0x18(%ebp),%ecx
  801cbc:	bb 00 00 00 00       	mov    $0x0,%ebx
  801cc1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801cc4:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801cc7:	53                   	push   %ebx
  801cc8:	51                   	push   %ecx
  801cc9:	52                   	push   %edx
  801cca:	50                   	push   %eax
  801ccb:	e8 44 29 00 00       	call   804614 <__umoddi3>
  801cd0:	83 c4 10             	add    $0x10,%esp
  801cd3:	05 d4 4d 80 00       	add    $0x804dd4,%eax
  801cd8:	8a 00                	mov    (%eax),%al
  801cda:	0f be c0             	movsbl %al,%eax
  801cdd:	83 ec 08             	sub    $0x8,%esp
  801ce0:	ff 75 0c             	pushl  0xc(%ebp)
  801ce3:	50                   	push   %eax
  801ce4:	8b 45 08             	mov    0x8(%ebp),%eax
  801ce7:	ff d0                	call   *%eax
  801ce9:	83 c4 10             	add    $0x10,%esp
}
  801cec:	90                   	nop
  801ced:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801cf0:	c9                   	leave  
  801cf1:	c3                   	ret    

00801cf2 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  801cf2:	55                   	push   %ebp
  801cf3:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  801cf5:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  801cf9:	7e 1c                	jle    801d17 <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  801cfb:	8b 45 08             	mov    0x8(%ebp),%eax
  801cfe:	8b 00                	mov    (%eax),%eax
  801d00:	8d 50 08             	lea    0x8(%eax),%edx
  801d03:	8b 45 08             	mov    0x8(%ebp),%eax
  801d06:	89 10                	mov    %edx,(%eax)
  801d08:	8b 45 08             	mov    0x8(%ebp),%eax
  801d0b:	8b 00                	mov    (%eax),%eax
  801d0d:	83 e8 08             	sub    $0x8,%eax
  801d10:	8b 50 04             	mov    0x4(%eax),%edx
  801d13:	8b 00                	mov    (%eax),%eax
  801d15:	eb 40                	jmp    801d57 <getuint+0x65>
	else if (lflag)
  801d17:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801d1b:	74 1e                	je     801d3b <getuint+0x49>
		return va_arg(*ap, unsigned long);
  801d1d:	8b 45 08             	mov    0x8(%ebp),%eax
  801d20:	8b 00                	mov    (%eax),%eax
  801d22:	8d 50 04             	lea    0x4(%eax),%edx
  801d25:	8b 45 08             	mov    0x8(%ebp),%eax
  801d28:	89 10                	mov    %edx,(%eax)
  801d2a:	8b 45 08             	mov    0x8(%ebp),%eax
  801d2d:	8b 00                	mov    (%eax),%eax
  801d2f:	83 e8 04             	sub    $0x4,%eax
  801d32:	8b 00                	mov    (%eax),%eax
  801d34:	ba 00 00 00 00       	mov    $0x0,%edx
  801d39:	eb 1c                	jmp    801d57 <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  801d3b:	8b 45 08             	mov    0x8(%ebp),%eax
  801d3e:	8b 00                	mov    (%eax),%eax
  801d40:	8d 50 04             	lea    0x4(%eax),%edx
  801d43:	8b 45 08             	mov    0x8(%ebp),%eax
  801d46:	89 10                	mov    %edx,(%eax)
  801d48:	8b 45 08             	mov    0x8(%ebp),%eax
  801d4b:	8b 00                	mov    (%eax),%eax
  801d4d:	83 e8 04             	sub    $0x4,%eax
  801d50:	8b 00                	mov    (%eax),%eax
  801d52:	ba 00 00 00 00       	mov    $0x0,%edx
}
  801d57:	5d                   	pop    %ebp
  801d58:	c3                   	ret    

00801d59 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  801d59:	55                   	push   %ebp
  801d5a:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  801d5c:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  801d60:	7e 1c                	jle    801d7e <getint+0x25>
		return va_arg(*ap, long long);
  801d62:	8b 45 08             	mov    0x8(%ebp),%eax
  801d65:	8b 00                	mov    (%eax),%eax
  801d67:	8d 50 08             	lea    0x8(%eax),%edx
  801d6a:	8b 45 08             	mov    0x8(%ebp),%eax
  801d6d:	89 10                	mov    %edx,(%eax)
  801d6f:	8b 45 08             	mov    0x8(%ebp),%eax
  801d72:	8b 00                	mov    (%eax),%eax
  801d74:	83 e8 08             	sub    $0x8,%eax
  801d77:	8b 50 04             	mov    0x4(%eax),%edx
  801d7a:	8b 00                	mov    (%eax),%eax
  801d7c:	eb 38                	jmp    801db6 <getint+0x5d>
	else if (lflag)
  801d7e:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801d82:	74 1a                	je     801d9e <getint+0x45>
		return va_arg(*ap, long);
  801d84:	8b 45 08             	mov    0x8(%ebp),%eax
  801d87:	8b 00                	mov    (%eax),%eax
  801d89:	8d 50 04             	lea    0x4(%eax),%edx
  801d8c:	8b 45 08             	mov    0x8(%ebp),%eax
  801d8f:	89 10                	mov    %edx,(%eax)
  801d91:	8b 45 08             	mov    0x8(%ebp),%eax
  801d94:	8b 00                	mov    (%eax),%eax
  801d96:	83 e8 04             	sub    $0x4,%eax
  801d99:	8b 00                	mov    (%eax),%eax
  801d9b:	99                   	cltd   
  801d9c:	eb 18                	jmp    801db6 <getint+0x5d>
	else
		return va_arg(*ap, int);
  801d9e:	8b 45 08             	mov    0x8(%ebp),%eax
  801da1:	8b 00                	mov    (%eax),%eax
  801da3:	8d 50 04             	lea    0x4(%eax),%edx
  801da6:	8b 45 08             	mov    0x8(%ebp),%eax
  801da9:	89 10                	mov    %edx,(%eax)
  801dab:	8b 45 08             	mov    0x8(%ebp),%eax
  801dae:	8b 00                	mov    (%eax),%eax
  801db0:	83 e8 04             	sub    $0x4,%eax
  801db3:	8b 00                	mov    (%eax),%eax
  801db5:	99                   	cltd   
}
  801db6:	5d                   	pop    %ebp
  801db7:	c3                   	ret    

00801db8 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  801db8:	55                   	push   %ebp
  801db9:	89 e5                	mov    %esp,%ebp
  801dbb:	56                   	push   %esi
  801dbc:	53                   	push   %ebx
  801dbd:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  801dc0:	eb 17                	jmp    801dd9 <vprintfmt+0x21>
			if (ch == '\0')
  801dc2:	85 db                	test   %ebx,%ebx
  801dc4:	0f 84 af 03 00 00    	je     802179 <vprintfmt+0x3c1>
				return;
			putch(ch, putdat);
  801dca:	83 ec 08             	sub    $0x8,%esp
  801dcd:	ff 75 0c             	pushl  0xc(%ebp)
  801dd0:	53                   	push   %ebx
  801dd1:	8b 45 08             	mov    0x8(%ebp),%eax
  801dd4:	ff d0                	call   *%eax
  801dd6:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  801dd9:	8b 45 10             	mov    0x10(%ebp),%eax
  801ddc:	8d 50 01             	lea    0x1(%eax),%edx
  801ddf:	89 55 10             	mov    %edx,0x10(%ebp)
  801de2:	8a 00                	mov    (%eax),%al
  801de4:	0f b6 d8             	movzbl %al,%ebx
  801de7:	83 fb 25             	cmp    $0x25,%ebx
  801dea:	75 d6                	jne    801dc2 <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  801dec:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  801df0:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  801df7:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  801dfe:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  801e05:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  801e0c:	8b 45 10             	mov    0x10(%ebp),%eax
  801e0f:	8d 50 01             	lea    0x1(%eax),%edx
  801e12:	89 55 10             	mov    %edx,0x10(%ebp)
  801e15:	8a 00                	mov    (%eax),%al
  801e17:	0f b6 d8             	movzbl %al,%ebx
  801e1a:	8d 43 dd             	lea    -0x23(%ebx),%eax
  801e1d:	83 f8 55             	cmp    $0x55,%eax
  801e20:	0f 87 2b 03 00 00    	ja     802151 <vprintfmt+0x399>
  801e26:	8b 04 85 f8 4d 80 00 	mov    0x804df8(,%eax,4),%eax
  801e2d:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  801e2f:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  801e33:	eb d7                	jmp    801e0c <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  801e35:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  801e39:	eb d1                	jmp    801e0c <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  801e3b:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  801e42:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801e45:	89 d0                	mov    %edx,%eax
  801e47:	c1 e0 02             	shl    $0x2,%eax
  801e4a:	01 d0                	add    %edx,%eax
  801e4c:	01 c0                	add    %eax,%eax
  801e4e:	01 d8                	add    %ebx,%eax
  801e50:	83 e8 30             	sub    $0x30,%eax
  801e53:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  801e56:	8b 45 10             	mov    0x10(%ebp),%eax
  801e59:	8a 00                	mov    (%eax),%al
  801e5b:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  801e5e:	83 fb 2f             	cmp    $0x2f,%ebx
  801e61:	7e 3e                	jle    801ea1 <vprintfmt+0xe9>
  801e63:	83 fb 39             	cmp    $0x39,%ebx
  801e66:	7f 39                	jg     801ea1 <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  801e68:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  801e6b:	eb d5                	jmp    801e42 <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  801e6d:	8b 45 14             	mov    0x14(%ebp),%eax
  801e70:	83 c0 04             	add    $0x4,%eax
  801e73:	89 45 14             	mov    %eax,0x14(%ebp)
  801e76:	8b 45 14             	mov    0x14(%ebp),%eax
  801e79:	83 e8 04             	sub    $0x4,%eax
  801e7c:	8b 00                	mov    (%eax),%eax
  801e7e:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  801e81:	eb 1f                	jmp    801ea2 <vprintfmt+0xea>

		case '.':
			if (width < 0)
  801e83:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  801e87:	79 83                	jns    801e0c <vprintfmt+0x54>
				width = 0;
  801e89:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  801e90:	e9 77 ff ff ff       	jmp    801e0c <vprintfmt+0x54>

		case '#':
			altflag = 1;
  801e95:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  801e9c:	e9 6b ff ff ff       	jmp    801e0c <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  801ea1:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  801ea2:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  801ea6:	0f 89 60 ff ff ff    	jns    801e0c <vprintfmt+0x54>
				width = precision, precision = -1;
  801eac:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801eaf:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  801eb2:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  801eb9:	e9 4e ff ff ff       	jmp    801e0c <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  801ebe:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  801ec1:	e9 46 ff ff ff       	jmp    801e0c <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  801ec6:	8b 45 14             	mov    0x14(%ebp),%eax
  801ec9:	83 c0 04             	add    $0x4,%eax
  801ecc:	89 45 14             	mov    %eax,0x14(%ebp)
  801ecf:	8b 45 14             	mov    0x14(%ebp),%eax
  801ed2:	83 e8 04             	sub    $0x4,%eax
  801ed5:	8b 00                	mov    (%eax),%eax
  801ed7:	83 ec 08             	sub    $0x8,%esp
  801eda:	ff 75 0c             	pushl  0xc(%ebp)
  801edd:	50                   	push   %eax
  801ede:	8b 45 08             	mov    0x8(%ebp),%eax
  801ee1:	ff d0                	call   *%eax
  801ee3:	83 c4 10             	add    $0x10,%esp
			break;
  801ee6:	e9 89 02 00 00       	jmp    802174 <vprintfmt+0x3bc>

		// error message
		case 'e':
			err = va_arg(ap, int);
  801eeb:	8b 45 14             	mov    0x14(%ebp),%eax
  801eee:	83 c0 04             	add    $0x4,%eax
  801ef1:	89 45 14             	mov    %eax,0x14(%ebp)
  801ef4:	8b 45 14             	mov    0x14(%ebp),%eax
  801ef7:	83 e8 04             	sub    $0x4,%eax
  801efa:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  801efc:	85 db                	test   %ebx,%ebx
  801efe:	79 02                	jns    801f02 <vprintfmt+0x14a>
				err = -err;
  801f00:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  801f02:	83 fb 64             	cmp    $0x64,%ebx
  801f05:	7f 0b                	jg     801f12 <vprintfmt+0x15a>
  801f07:	8b 34 9d 40 4c 80 00 	mov    0x804c40(,%ebx,4),%esi
  801f0e:	85 f6                	test   %esi,%esi
  801f10:	75 19                	jne    801f2b <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  801f12:	53                   	push   %ebx
  801f13:	68 e5 4d 80 00       	push   $0x804de5
  801f18:	ff 75 0c             	pushl  0xc(%ebp)
  801f1b:	ff 75 08             	pushl  0x8(%ebp)
  801f1e:	e8 5e 02 00 00       	call   802181 <printfmt>
  801f23:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  801f26:	e9 49 02 00 00       	jmp    802174 <vprintfmt+0x3bc>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  801f2b:	56                   	push   %esi
  801f2c:	68 ee 4d 80 00       	push   $0x804dee
  801f31:	ff 75 0c             	pushl  0xc(%ebp)
  801f34:	ff 75 08             	pushl  0x8(%ebp)
  801f37:	e8 45 02 00 00       	call   802181 <printfmt>
  801f3c:	83 c4 10             	add    $0x10,%esp
			break;
  801f3f:	e9 30 02 00 00       	jmp    802174 <vprintfmt+0x3bc>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  801f44:	8b 45 14             	mov    0x14(%ebp),%eax
  801f47:	83 c0 04             	add    $0x4,%eax
  801f4a:	89 45 14             	mov    %eax,0x14(%ebp)
  801f4d:	8b 45 14             	mov    0x14(%ebp),%eax
  801f50:	83 e8 04             	sub    $0x4,%eax
  801f53:	8b 30                	mov    (%eax),%esi
  801f55:	85 f6                	test   %esi,%esi
  801f57:	75 05                	jne    801f5e <vprintfmt+0x1a6>
				p = "(null)";
  801f59:	be f1 4d 80 00       	mov    $0x804df1,%esi
			if (width > 0 && padc != '-')
  801f5e:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  801f62:	7e 6d                	jle    801fd1 <vprintfmt+0x219>
  801f64:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  801f68:	74 67                	je     801fd1 <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  801f6a:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801f6d:	83 ec 08             	sub    $0x8,%esp
  801f70:	50                   	push   %eax
  801f71:	56                   	push   %esi
  801f72:	e8 0c 03 00 00       	call   802283 <strnlen>
  801f77:	83 c4 10             	add    $0x10,%esp
  801f7a:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  801f7d:	eb 16                	jmp    801f95 <vprintfmt+0x1dd>
					putch(padc, putdat);
  801f7f:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  801f83:	83 ec 08             	sub    $0x8,%esp
  801f86:	ff 75 0c             	pushl  0xc(%ebp)
  801f89:	50                   	push   %eax
  801f8a:	8b 45 08             	mov    0x8(%ebp),%eax
  801f8d:	ff d0                	call   *%eax
  801f8f:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  801f92:	ff 4d e4             	decl   -0x1c(%ebp)
  801f95:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  801f99:	7f e4                	jg     801f7f <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  801f9b:	eb 34                	jmp    801fd1 <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  801f9d:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  801fa1:	74 1c                	je     801fbf <vprintfmt+0x207>
  801fa3:	83 fb 1f             	cmp    $0x1f,%ebx
  801fa6:	7e 05                	jle    801fad <vprintfmt+0x1f5>
  801fa8:	83 fb 7e             	cmp    $0x7e,%ebx
  801fab:	7e 12                	jle    801fbf <vprintfmt+0x207>
					putch('?', putdat);
  801fad:	83 ec 08             	sub    $0x8,%esp
  801fb0:	ff 75 0c             	pushl  0xc(%ebp)
  801fb3:	6a 3f                	push   $0x3f
  801fb5:	8b 45 08             	mov    0x8(%ebp),%eax
  801fb8:	ff d0                	call   *%eax
  801fba:	83 c4 10             	add    $0x10,%esp
  801fbd:	eb 0f                	jmp    801fce <vprintfmt+0x216>
				else
					putch(ch, putdat);
  801fbf:	83 ec 08             	sub    $0x8,%esp
  801fc2:	ff 75 0c             	pushl  0xc(%ebp)
  801fc5:	53                   	push   %ebx
  801fc6:	8b 45 08             	mov    0x8(%ebp),%eax
  801fc9:	ff d0                	call   *%eax
  801fcb:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  801fce:	ff 4d e4             	decl   -0x1c(%ebp)
  801fd1:	89 f0                	mov    %esi,%eax
  801fd3:	8d 70 01             	lea    0x1(%eax),%esi
  801fd6:	8a 00                	mov    (%eax),%al
  801fd8:	0f be d8             	movsbl %al,%ebx
  801fdb:	85 db                	test   %ebx,%ebx
  801fdd:	74 24                	je     802003 <vprintfmt+0x24b>
  801fdf:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  801fe3:	78 b8                	js     801f9d <vprintfmt+0x1e5>
  801fe5:	ff 4d e0             	decl   -0x20(%ebp)
  801fe8:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  801fec:	79 af                	jns    801f9d <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  801fee:	eb 13                	jmp    802003 <vprintfmt+0x24b>
				putch(' ', putdat);
  801ff0:	83 ec 08             	sub    $0x8,%esp
  801ff3:	ff 75 0c             	pushl  0xc(%ebp)
  801ff6:	6a 20                	push   $0x20
  801ff8:	8b 45 08             	mov    0x8(%ebp),%eax
  801ffb:	ff d0                	call   *%eax
  801ffd:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  802000:	ff 4d e4             	decl   -0x1c(%ebp)
  802003:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  802007:	7f e7                	jg     801ff0 <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  802009:	e9 66 01 00 00       	jmp    802174 <vprintfmt+0x3bc>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  80200e:	83 ec 08             	sub    $0x8,%esp
  802011:	ff 75 e8             	pushl  -0x18(%ebp)
  802014:	8d 45 14             	lea    0x14(%ebp),%eax
  802017:	50                   	push   %eax
  802018:	e8 3c fd ff ff       	call   801d59 <getint>
  80201d:	83 c4 10             	add    $0x10,%esp
  802020:	89 45 f0             	mov    %eax,-0x10(%ebp)
  802023:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  802026:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802029:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80202c:	85 d2                	test   %edx,%edx
  80202e:	79 23                	jns    802053 <vprintfmt+0x29b>
				putch('-', putdat);
  802030:	83 ec 08             	sub    $0x8,%esp
  802033:	ff 75 0c             	pushl  0xc(%ebp)
  802036:	6a 2d                	push   $0x2d
  802038:	8b 45 08             	mov    0x8(%ebp),%eax
  80203b:	ff d0                	call   *%eax
  80203d:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  802040:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802043:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802046:	f7 d8                	neg    %eax
  802048:	83 d2 00             	adc    $0x0,%edx
  80204b:	f7 da                	neg    %edx
  80204d:	89 45 f0             	mov    %eax,-0x10(%ebp)
  802050:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  802053:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  80205a:	e9 bc 00 00 00       	jmp    80211b <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  80205f:	83 ec 08             	sub    $0x8,%esp
  802062:	ff 75 e8             	pushl  -0x18(%ebp)
  802065:	8d 45 14             	lea    0x14(%ebp),%eax
  802068:	50                   	push   %eax
  802069:	e8 84 fc ff ff       	call   801cf2 <getuint>
  80206e:	83 c4 10             	add    $0x10,%esp
  802071:	89 45 f0             	mov    %eax,-0x10(%ebp)
  802074:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  802077:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  80207e:	e9 98 00 00 00       	jmp    80211b <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  802083:	83 ec 08             	sub    $0x8,%esp
  802086:	ff 75 0c             	pushl  0xc(%ebp)
  802089:	6a 58                	push   $0x58
  80208b:	8b 45 08             	mov    0x8(%ebp),%eax
  80208e:	ff d0                	call   *%eax
  802090:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  802093:	83 ec 08             	sub    $0x8,%esp
  802096:	ff 75 0c             	pushl  0xc(%ebp)
  802099:	6a 58                	push   $0x58
  80209b:	8b 45 08             	mov    0x8(%ebp),%eax
  80209e:	ff d0                	call   *%eax
  8020a0:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  8020a3:	83 ec 08             	sub    $0x8,%esp
  8020a6:	ff 75 0c             	pushl  0xc(%ebp)
  8020a9:	6a 58                	push   $0x58
  8020ab:	8b 45 08             	mov    0x8(%ebp),%eax
  8020ae:	ff d0                	call   *%eax
  8020b0:	83 c4 10             	add    $0x10,%esp
			break;
  8020b3:	e9 bc 00 00 00       	jmp    802174 <vprintfmt+0x3bc>

		// pointer
		case 'p':
			putch('0', putdat);
  8020b8:	83 ec 08             	sub    $0x8,%esp
  8020bb:	ff 75 0c             	pushl  0xc(%ebp)
  8020be:	6a 30                	push   $0x30
  8020c0:	8b 45 08             	mov    0x8(%ebp),%eax
  8020c3:	ff d0                	call   *%eax
  8020c5:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  8020c8:	83 ec 08             	sub    $0x8,%esp
  8020cb:	ff 75 0c             	pushl  0xc(%ebp)
  8020ce:	6a 78                	push   $0x78
  8020d0:	8b 45 08             	mov    0x8(%ebp),%eax
  8020d3:	ff d0                	call   *%eax
  8020d5:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  8020d8:	8b 45 14             	mov    0x14(%ebp),%eax
  8020db:	83 c0 04             	add    $0x4,%eax
  8020de:	89 45 14             	mov    %eax,0x14(%ebp)
  8020e1:	8b 45 14             	mov    0x14(%ebp),%eax
  8020e4:	83 e8 04             	sub    $0x4,%eax
  8020e7:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  8020e9:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8020ec:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  8020f3:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  8020fa:	eb 1f                	jmp    80211b <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  8020fc:	83 ec 08             	sub    $0x8,%esp
  8020ff:	ff 75 e8             	pushl  -0x18(%ebp)
  802102:	8d 45 14             	lea    0x14(%ebp),%eax
  802105:	50                   	push   %eax
  802106:	e8 e7 fb ff ff       	call   801cf2 <getuint>
  80210b:	83 c4 10             	add    $0x10,%esp
  80210e:	89 45 f0             	mov    %eax,-0x10(%ebp)
  802111:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  802114:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  80211b:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  80211f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802122:	83 ec 04             	sub    $0x4,%esp
  802125:	52                   	push   %edx
  802126:	ff 75 e4             	pushl  -0x1c(%ebp)
  802129:	50                   	push   %eax
  80212a:	ff 75 f4             	pushl  -0xc(%ebp)
  80212d:	ff 75 f0             	pushl  -0x10(%ebp)
  802130:	ff 75 0c             	pushl  0xc(%ebp)
  802133:	ff 75 08             	pushl  0x8(%ebp)
  802136:	e8 00 fb ff ff       	call   801c3b <printnum>
  80213b:	83 c4 20             	add    $0x20,%esp
			break;
  80213e:	eb 34                	jmp    802174 <vprintfmt+0x3bc>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  802140:	83 ec 08             	sub    $0x8,%esp
  802143:	ff 75 0c             	pushl  0xc(%ebp)
  802146:	53                   	push   %ebx
  802147:	8b 45 08             	mov    0x8(%ebp),%eax
  80214a:	ff d0                	call   *%eax
  80214c:	83 c4 10             	add    $0x10,%esp
			break;
  80214f:	eb 23                	jmp    802174 <vprintfmt+0x3bc>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  802151:	83 ec 08             	sub    $0x8,%esp
  802154:	ff 75 0c             	pushl  0xc(%ebp)
  802157:	6a 25                	push   $0x25
  802159:	8b 45 08             	mov    0x8(%ebp),%eax
  80215c:	ff d0                	call   *%eax
  80215e:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  802161:	ff 4d 10             	decl   0x10(%ebp)
  802164:	eb 03                	jmp    802169 <vprintfmt+0x3b1>
  802166:	ff 4d 10             	decl   0x10(%ebp)
  802169:	8b 45 10             	mov    0x10(%ebp),%eax
  80216c:	48                   	dec    %eax
  80216d:	8a 00                	mov    (%eax),%al
  80216f:	3c 25                	cmp    $0x25,%al
  802171:	75 f3                	jne    802166 <vprintfmt+0x3ae>
				/* do nothing */;
			break;
  802173:	90                   	nop
		}
	}
  802174:	e9 47 fc ff ff       	jmp    801dc0 <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  802179:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  80217a:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80217d:	5b                   	pop    %ebx
  80217e:	5e                   	pop    %esi
  80217f:	5d                   	pop    %ebp
  802180:	c3                   	ret    

00802181 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  802181:	55                   	push   %ebp
  802182:	89 e5                	mov    %esp,%ebp
  802184:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  802187:	8d 45 10             	lea    0x10(%ebp),%eax
  80218a:	83 c0 04             	add    $0x4,%eax
  80218d:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  802190:	8b 45 10             	mov    0x10(%ebp),%eax
  802193:	ff 75 f4             	pushl  -0xc(%ebp)
  802196:	50                   	push   %eax
  802197:	ff 75 0c             	pushl  0xc(%ebp)
  80219a:	ff 75 08             	pushl  0x8(%ebp)
  80219d:	e8 16 fc ff ff       	call   801db8 <vprintfmt>
  8021a2:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  8021a5:	90                   	nop
  8021a6:	c9                   	leave  
  8021a7:	c3                   	ret    

008021a8 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  8021a8:	55                   	push   %ebp
  8021a9:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  8021ab:	8b 45 0c             	mov    0xc(%ebp),%eax
  8021ae:	8b 40 08             	mov    0x8(%eax),%eax
  8021b1:	8d 50 01             	lea    0x1(%eax),%edx
  8021b4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8021b7:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  8021ba:	8b 45 0c             	mov    0xc(%ebp),%eax
  8021bd:	8b 10                	mov    (%eax),%edx
  8021bf:	8b 45 0c             	mov    0xc(%ebp),%eax
  8021c2:	8b 40 04             	mov    0x4(%eax),%eax
  8021c5:	39 c2                	cmp    %eax,%edx
  8021c7:	73 12                	jae    8021db <sprintputch+0x33>
		*b->buf++ = ch;
  8021c9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8021cc:	8b 00                	mov    (%eax),%eax
  8021ce:	8d 48 01             	lea    0x1(%eax),%ecx
  8021d1:	8b 55 0c             	mov    0xc(%ebp),%edx
  8021d4:	89 0a                	mov    %ecx,(%edx)
  8021d6:	8b 55 08             	mov    0x8(%ebp),%edx
  8021d9:	88 10                	mov    %dl,(%eax)
}
  8021db:	90                   	nop
  8021dc:	5d                   	pop    %ebp
  8021dd:	c3                   	ret    

008021de <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  8021de:	55                   	push   %ebp
  8021df:	89 e5                	mov    %esp,%ebp
  8021e1:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  8021e4:	8b 45 08             	mov    0x8(%ebp),%eax
  8021e7:	89 45 ec             	mov    %eax,-0x14(%ebp)
  8021ea:	8b 45 0c             	mov    0xc(%ebp),%eax
  8021ed:	8d 50 ff             	lea    -0x1(%eax),%edx
  8021f0:	8b 45 08             	mov    0x8(%ebp),%eax
  8021f3:	01 d0                	add    %edx,%eax
  8021f5:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8021f8:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  8021ff:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802203:	74 06                	je     80220b <vsnprintf+0x2d>
  802205:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  802209:	7f 07                	jg     802212 <vsnprintf+0x34>
		return -E_INVAL;
  80220b:	b8 03 00 00 00       	mov    $0x3,%eax
  802210:	eb 20                	jmp    802232 <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  802212:	ff 75 14             	pushl  0x14(%ebp)
  802215:	ff 75 10             	pushl  0x10(%ebp)
  802218:	8d 45 ec             	lea    -0x14(%ebp),%eax
  80221b:	50                   	push   %eax
  80221c:	68 a8 21 80 00       	push   $0x8021a8
  802221:	e8 92 fb ff ff       	call   801db8 <vprintfmt>
  802226:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  802229:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80222c:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  80222f:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  802232:	c9                   	leave  
  802233:	c3                   	ret    

00802234 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  802234:	55                   	push   %ebp
  802235:	89 e5                	mov    %esp,%ebp
  802237:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  80223a:	8d 45 10             	lea    0x10(%ebp),%eax
  80223d:	83 c0 04             	add    $0x4,%eax
  802240:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  802243:	8b 45 10             	mov    0x10(%ebp),%eax
  802246:	ff 75 f4             	pushl  -0xc(%ebp)
  802249:	50                   	push   %eax
  80224a:	ff 75 0c             	pushl  0xc(%ebp)
  80224d:	ff 75 08             	pushl  0x8(%ebp)
  802250:	e8 89 ff ff ff       	call   8021de <vsnprintf>
  802255:	83 c4 10             	add    $0x10,%esp
  802258:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  80225b:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  80225e:	c9                   	leave  
  80225f:	c3                   	ret    

00802260 <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  802260:	55                   	push   %ebp
  802261:	89 e5                	mov    %esp,%ebp
  802263:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  802266:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  80226d:	eb 06                	jmp    802275 <strlen+0x15>
		n++;
  80226f:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  802272:	ff 45 08             	incl   0x8(%ebp)
  802275:	8b 45 08             	mov    0x8(%ebp),%eax
  802278:	8a 00                	mov    (%eax),%al
  80227a:	84 c0                	test   %al,%al
  80227c:	75 f1                	jne    80226f <strlen+0xf>
		n++;
	return n;
  80227e:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  802281:	c9                   	leave  
  802282:	c3                   	ret    

00802283 <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  802283:	55                   	push   %ebp
  802284:	89 e5                	mov    %esp,%ebp
  802286:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  802289:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  802290:	eb 09                	jmp    80229b <strnlen+0x18>
		n++;
  802292:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  802295:	ff 45 08             	incl   0x8(%ebp)
  802298:	ff 4d 0c             	decl   0xc(%ebp)
  80229b:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80229f:	74 09                	je     8022aa <strnlen+0x27>
  8022a1:	8b 45 08             	mov    0x8(%ebp),%eax
  8022a4:	8a 00                	mov    (%eax),%al
  8022a6:	84 c0                	test   %al,%al
  8022a8:	75 e8                	jne    802292 <strnlen+0xf>
		n++;
	return n;
  8022aa:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  8022ad:	c9                   	leave  
  8022ae:	c3                   	ret    

008022af <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  8022af:	55                   	push   %ebp
  8022b0:	89 e5                	mov    %esp,%ebp
  8022b2:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  8022b5:	8b 45 08             	mov    0x8(%ebp),%eax
  8022b8:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  8022bb:	90                   	nop
  8022bc:	8b 45 08             	mov    0x8(%ebp),%eax
  8022bf:	8d 50 01             	lea    0x1(%eax),%edx
  8022c2:	89 55 08             	mov    %edx,0x8(%ebp)
  8022c5:	8b 55 0c             	mov    0xc(%ebp),%edx
  8022c8:	8d 4a 01             	lea    0x1(%edx),%ecx
  8022cb:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  8022ce:	8a 12                	mov    (%edx),%dl
  8022d0:	88 10                	mov    %dl,(%eax)
  8022d2:	8a 00                	mov    (%eax),%al
  8022d4:	84 c0                	test   %al,%al
  8022d6:	75 e4                	jne    8022bc <strcpy+0xd>
		/* do nothing */;
	return ret;
  8022d8:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  8022db:	c9                   	leave  
  8022dc:	c3                   	ret    

008022dd <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  8022dd:	55                   	push   %ebp
  8022de:	89 e5                	mov    %esp,%ebp
  8022e0:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  8022e3:	8b 45 08             	mov    0x8(%ebp),%eax
  8022e6:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  8022e9:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8022f0:	eb 1f                	jmp    802311 <strncpy+0x34>
		*dst++ = *src;
  8022f2:	8b 45 08             	mov    0x8(%ebp),%eax
  8022f5:	8d 50 01             	lea    0x1(%eax),%edx
  8022f8:	89 55 08             	mov    %edx,0x8(%ebp)
  8022fb:	8b 55 0c             	mov    0xc(%ebp),%edx
  8022fe:	8a 12                	mov    (%edx),%dl
  802300:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  802302:	8b 45 0c             	mov    0xc(%ebp),%eax
  802305:	8a 00                	mov    (%eax),%al
  802307:	84 c0                	test   %al,%al
  802309:	74 03                	je     80230e <strncpy+0x31>
			src++;
  80230b:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  80230e:	ff 45 fc             	incl   -0x4(%ebp)
  802311:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802314:	3b 45 10             	cmp    0x10(%ebp),%eax
  802317:	72 d9                	jb     8022f2 <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  802319:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  80231c:	c9                   	leave  
  80231d:	c3                   	ret    

0080231e <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  80231e:	55                   	push   %ebp
  80231f:	89 e5                	mov    %esp,%ebp
  802321:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  802324:	8b 45 08             	mov    0x8(%ebp),%eax
  802327:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  80232a:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80232e:	74 30                	je     802360 <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  802330:	eb 16                	jmp    802348 <strlcpy+0x2a>
			*dst++ = *src++;
  802332:	8b 45 08             	mov    0x8(%ebp),%eax
  802335:	8d 50 01             	lea    0x1(%eax),%edx
  802338:	89 55 08             	mov    %edx,0x8(%ebp)
  80233b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80233e:	8d 4a 01             	lea    0x1(%edx),%ecx
  802341:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  802344:	8a 12                	mov    (%edx),%dl
  802346:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  802348:	ff 4d 10             	decl   0x10(%ebp)
  80234b:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80234f:	74 09                	je     80235a <strlcpy+0x3c>
  802351:	8b 45 0c             	mov    0xc(%ebp),%eax
  802354:	8a 00                	mov    (%eax),%al
  802356:	84 c0                	test   %al,%al
  802358:	75 d8                	jne    802332 <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  80235a:	8b 45 08             	mov    0x8(%ebp),%eax
  80235d:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  802360:	8b 55 08             	mov    0x8(%ebp),%edx
  802363:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802366:	29 c2                	sub    %eax,%edx
  802368:	89 d0                	mov    %edx,%eax
}
  80236a:	c9                   	leave  
  80236b:	c3                   	ret    

0080236c <strcmp>:

int
strcmp(const char *p, const char *q)
{
  80236c:	55                   	push   %ebp
  80236d:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  80236f:	eb 06                	jmp    802377 <strcmp+0xb>
		p++, q++;
  802371:	ff 45 08             	incl   0x8(%ebp)
  802374:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  802377:	8b 45 08             	mov    0x8(%ebp),%eax
  80237a:	8a 00                	mov    (%eax),%al
  80237c:	84 c0                	test   %al,%al
  80237e:	74 0e                	je     80238e <strcmp+0x22>
  802380:	8b 45 08             	mov    0x8(%ebp),%eax
  802383:	8a 10                	mov    (%eax),%dl
  802385:	8b 45 0c             	mov    0xc(%ebp),%eax
  802388:	8a 00                	mov    (%eax),%al
  80238a:	38 c2                	cmp    %al,%dl
  80238c:	74 e3                	je     802371 <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  80238e:	8b 45 08             	mov    0x8(%ebp),%eax
  802391:	8a 00                	mov    (%eax),%al
  802393:	0f b6 d0             	movzbl %al,%edx
  802396:	8b 45 0c             	mov    0xc(%ebp),%eax
  802399:	8a 00                	mov    (%eax),%al
  80239b:	0f b6 c0             	movzbl %al,%eax
  80239e:	29 c2                	sub    %eax,%edx
  8023a0:	89 d0                	mov    %edx,%eax
}
  8023a2:	5d                   	pop    %ebp
  8023a3:	c3                   	ret    

008023a4 <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  8023a4:	55                   	push   %ebp
  8023a5:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  8023a7:	eb 09                	jmp    8023b2 <strncmp+0xe>
		n--, p++, q++;
  8023a9:	ff 4d 10             	decl   0x10(%ebp)
  8023ac:	ff 45 08             	incl   0x8(%ebp)
  8023af:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  8023b2:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8023b6:	74 17                	je     8023cf <strncmp+0x2b>
  8023b8:	8b 45 08             	mov    0x8(%ebp),%eax
  8023bb:	8a 00                	mov    (%eax),%al
  8023bd:	84 c0                	test   %al,%al
  8023bf:	74 0e                	je     8023cf <strncmp+0x2b>
  8023c1:	8b 45 08             	mov    0x8(%ebp),%eax
  8023c4:	8a 10                	mov    (%eax),%dl
  8023c6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8023c9:	8a 00                	mov    (%eax),%al
  8023cb:	38 c2                	cmp    %al,%dl
  8023cd:	74 da                	je     8023a9 <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  8023cf:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8023d3:	75 07                	jne    8023dc <strncmp+0x38>
		return 0;
  8023d5:	b8 00 00 00 00       	mov    $0x0,%eax
  8023da:	eb 14                	jmp    8023f0 <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  8023dc:	8b 45 08             	mov    0x8(%ebp),%eax
  8023df:	8a 00                	mov    (%eax),%al
  8023e1:	0f b6 d0             	movzbl %al,%edx
  8023e4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8023e7:	8a 00                	mov    (%eax),%al
  8023e9:	0f b6 c0             	movzbl %al,%eax
  8023ec:	29 c2                	sub    %eax,%edx
  8023ee:	89 d0                	mov    %edx,%eax
}
  8023f0:	5d                   	pop    %ebp
  8023f1:	c3                   	ret    

008023f2 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  8023f2:	55                   	push   %ebp
  8023f3:	89 e5                	mov    %esp,%ebp
  8023f5:	83 ec 04             	sub    $0x4,%esp
  8023f8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8023fb:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  8023fe:	eb 12                	jmp    802412 <strchr+0x20>
		if (*s == c)
  802400:	8b 45 08             	mov    0x8(%ebp),%eax
  802403:	8a 00                	mov    (%eax),%al
  802405:	3a 45 fc             	cmp    -0x4(%ebp),%al
  802408:	75 05                	jne    80240f <strchr+0x1d>
			return (char *) s;
  80240a:	8b 45 08             	mov    0x8(%ebp),%eax
  80240d:	eb 11                	jmp    802420 <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  80240f:	ff 45 08             	incl   0x8(%ebp)
  802412:	8b 45 08             	mov    0x8(%ebp),%eax
  802415:	8a 00                	mov    (%eax),%al
  802417:	84 c0                	test   %al,%al
  802419:	75 e5                	jne    802400 <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  80241b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802420:	c9                   	leave  
  802421:	c3                   	ret    

00802422 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  802422:	55                   	push   %ebp
  802423:	89 e5                	mov    %esp,%ebp
  802425:	83 ec 04             	sub    $0x4,%esp
  802428:	8b 45 0c             	mov    0xc(%ebp),%eax
  80242b:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  80242e:	eb 0d                	jmp    80243d <strfind+0x1b>
		if (*s == c)
  802430:	8b 45 08             	mov    0x8(%ebp),%eax
  802433:	8a 00                	mov    (%eax),%al
  802435:	3a 45 fc             	cmp    -0x4(%ebp),%al
  802438:	74 0e                	je     802448 <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  80243a:	ff 45 08             	incl   0x8(%ebp)
  80243d:	8b 45 08             	mov    0x8(%ebp),%eax
  802440:	8a 00                	mov    (%eax),%al
  802442:	84 c0                	test   %al,%al
  802444:	75 ea                	jne    802430 <strfind+0xe>
  802446:	eb 01                	jmp    802449 <strfind+0x27>
		if (*s == c)
			break;
  802448:	90                   	nop
	return (char *) s;
  802449:	8b 45 08             	mov    0x8(%ebp),%eax
}
  80244c:	c9                   	leave  
  80244d:	c3                   	ret    

0080244e <memset>:


void *
memset(void *v, int c, uint32 n)
{
  80244e:	55                   	push   %ebp
  80244f:	89 e5                	mov    %esp,%ebp
  802451:	83 ec 10             	sub    $0x10,%esp
	char *p;
	int m;

	p = v;
  802454:	8b 45 08             	mov    0x8(%ebp),%eax
  802457:	89 45 fc             	mov    %eax,-0x4(%ebp)
	m = n;
  80245a:	8b 45 10             	mov    0x10(%ebp),%eax
  80245d:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (--m >= 0)
  802460:	eb 0e                	jmp    802470 <memset+0x22>
		*p++ = c;
  802462:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802465:	8d 50 01             	lea    0x1(%eax),%edx
  802468:	89 55 fc             	mov    %edx,-0x4(%ebp)
  80246b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80246e:	88 10                	mov    %dl,(%eax)
	char *p;
	int m;

	p = v;
	m = n;
	while (--m >= 0)
  802470:	ff 4d f8             	decl   -0x8(%ebp)
  802473:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  802477:	79 e9                	jns    802462 <memset+0x14>
		*p++ = c;

	return v;
  802479:	8b 45 08             	mov    0x8(%ebp),%eax
}
  80247c:	c9                   	leave  
  80247d:	c3                   	ret    

0080247e <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  80247e:	55                   	push   %ebp
  80247f:	89 e5                	mov    %esp,%ebp
  802481:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  802484:	8b 45 0c             	mov    0xc(%ebp),%eax
  802487:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  80248a:	8b 45 08             	mov    0x8(%ebp),%eax
  80248d:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (n-- > 0)
  802490:	eb 16                	jmp    8024a8 <memcpy+0x2a>
		*d++ = *s++;
  802492:	8b 45 f8             	mov    -0x8(%ebp),%eax
  802495:	8d 50 01             	lea    0x1(%eax),%edx
  802498:	89 55 f8             	mov    %edx,-0x8(%ebp)
  80249b:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80249e:	8d 4a 01             	lea    0x1(%edx),%ecx
  8024a1:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  8024a4:	8a 12                	mov    (%edx),%dl
  8024a6:	88 10                	mov    %dl,(%eax)
	const char *s;
	char *d;

	s = src;
	d = dst;
	while (n-- > 0)
  8024a8:	8b 45 10             	mov    0x10(%ebp),%eax
  8024ab:	8d 50 ff             	lea    -0x1(%eax),%edx
  8024ae:	89 55 10             	mov    %edx,0x10(%ebp)
  8024b1:	85 c0                	test   %eax,%eax
  8024b3:	75 dd                	jne    802492 <memcpy+0x14>
		*d++ = *s++;

	return dst;
  8024b5:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8024b8:	c9                   	leave  
  8024b9:	c3                   	ret    

008024ba <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  8024ba:	55                   	push   %ebp
  8024bb:	89 e5                	mov    %esp,%ebp
  8024bd:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  8024c0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8024c3:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  8024c6:	8b 45 08             	mov    0x8(%ebp),%eax
  8024c9:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  8024cc:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8024cf:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  8024d2:	73 50                	jae    802524 <memmove+0x6a>
  8024d4:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8024d7:	8b 45 10             	mov    0x10(%ebp),%eax
  8024da:	01 d0                	add    %edx,%eax
  8024dc:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  8024df:	76 43                	jbe    802524 <memmove+0x6a>
		s += n;
  8024e1:	8b 45 10             	mov    0x10(%ebp),%eax
  8024e4:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  8024e7:	8b 45 10             	mov    0x10(%ebp),%eax
  8024ea:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  8024ed:	eb 10                	jmp    8024ff <memmove+0x45>
			*--d = *--s;
  8024ef:	ff 4d f8             	decl   -0x8(%ebp)
  8024f2:	ff 4d fc             	decl   -0x4(%ebp)
  8024f5:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8024f8:	8a 10                	mov    (%eax),%dl
  8024fa:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8024fd:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  8024ff:	8b 45 10             	mov    0x10(%ebp),%eax
  802502:	8d 50 ff             	lea    -0x1(%eax),%edx
  802505:	89 55 10             	mov    %edx,0x10(%ebp)
  802508:	85 c0                	test   %eax,%eax
  80250a:	75 e3                	jne    8024ef <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  80250c:	eb 23                	jmp    802531 <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  80250e:	8b 45 f8             	mov    -0x8(%ebp),%eax
  802511:	8d 50 01             	lea    0x1(%eax),%edx
  802514:	89 55 f8             	mov    %edx,-0x8(%ebp)
  802517:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80251a:	8d 4a 01             	lea    0x1(%edx),%ecx
  80251d:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  802520:	8a 12                	mov    (%edx),%dl
  802522:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  802524:	8b 45 10             	mov    0x10(%ebp),%eax
  802527:	8d 50 ff             	lea    -0x1(%eax),%edx
  80252a:	89 55 10             	mov    %edx,0x10(%ebp)
  80252d:	85 c0                	test   %eax,%eax
  80252f:	75 dd                	jne    80250e <memmove+0x54>
			*d++ = *s++;

	return dst;
  802531:	8b 45 08             	mov    0x8(%ebp),%eax
}
  802534:	c9                   	leave  
  802535:	c3                   	ret    

00802536 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  802536:	55                   	push   %ebp
  802537:	89 e5                	mov    %esp,%ebp
  802539:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  80253c:	8b 45 08             	mov    0x8(%ebp),%eax
  80253f:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  802542:	8b 45 0c             	mov    0xc(%ebp),%eax
  802545:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  802548:	eb 2a                	jmp    802574 <memcmp+0x3e>
		if (*s1 != *s2)
  80254a:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80254d:	8a 10                	mov    (%eax),%dl
  80254f:	8b 45 f8             	mov    -0x8(%ebp),%eax
  802552:	8a 00                	mov    (%eax),%al
  802554:	38 c2                	cmp    %al,%dl
  802556:	74 16                	je     80256e <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  802558:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80255b:	8a 00                	mov    (%eax),%al
  80255d:	0f b6 d0             	movzbl %al,%edx
  802560:	8b 45 f8             	mov    -0x8(%ebp),%eax
  802563:	8a 00                	mov    (%eax),%al
  802565:	0f b6 c0             	movzbl %al,%eax
  802568:	29 c2                	sub    %eax,%edx
  80256a:	89 d0                	mov    %edx,%eax
  80256c:	eb 18                	jmp    802586 <memcmp+0x50>
		s1++, s2++;
  80256e:	ff 45 fc             	incl   -0x4(%ebp)
  802571:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  802574:	8b 45 10             	mov    0x10(%ebp),%eax
  802577:	8d 50 ff             	lea    -0x1(%eax),%edx
  80257a:	89 55 10             	mov    %edx,0x10(%ebp)
  80257d:	85 c0                	test   %eax,%eax
  80257f:	75 c9                	jne    80254a <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  802581:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802586:	c9                   	leave  
  802587:	c3                   	ret    

00802588 <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  802588:	55                   	push   %ebp
  802589:	89 e5                	mov    %esp,%ebp
  80258b:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  80258e:	8b 55 08             	mov    0x8(%ebp),%edx
  802591:	8b 45 10             	mov    0x10(%ebp),%eax
  802594:	01 d0                	add    %edx,%eax
  802596:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  802599:	eb 15                	jmp    8025b0 <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  80259b:	8b 45 08             	mov    0x8(%ebp),%eax
  80259e:	8a 00                	mov    (%eax),%al
  8025a0:	0f b6 d0             	movzbl %al,%edx
  8025a3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8025a6:	0f b6 c0             	movzbl %al,%eax
  8025a9:	39 c2                	cmp    %eax,%edx
  8025ab:	74 0d                	je     8025ba <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  8025ad:	ff 45 08             	incl   0x8(%ebp)
  8025b0:	8b 45 08             	mov    0x8(%ebp),%eax
  8025b3:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  8025b6:	72 e3                	jb     80259b <memfind+0x13>
  8025b8:	eb 01                	jmp    8025bb <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  8025ba:	90                   	nop
	return (void *) s;
  8025bb:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8025be:	c9                   	leave  
  8025bf:	c3                   	ret    

008025c0 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  8025c0:	55                   	push   %ebp
  8025c1:	89 e5                	mov    %esp,%ebp
  8025c3:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  8025c6:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  8025cd:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  8025d4:	eb 03                	jmp    8025d9 <strtol+0x19>
		s++;
  8025d6:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  8025d9:	8b 45 08             	mov    0x8(%ebp),%eax
  8025dc:	8a 00                	mov    (%eax),%al
  8025de:	3c 20                	cmp    $0x20,%al
  8025e0:	74 f4                	je     8025d6 <strtol+0x16>
  8025e2:	8b 45 08             	mov    0x8(%ebp),%eax
  8025e5:	8a 00                	mov    (%eax),%al
  8025e7:	3c 09                	cmp    $0x9,%al
  8025e9:	74 eb                	je     8025d6 <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  8025eb:	8b 45 08             	mov    0x8(%ebp),%eax
  8025ee:	8a 00                	mov    (%eax),%al
  8025f0:	3c 2b                	cmp    $0x2b,%al
  8025f2:	75 05                	jne    8025f9 <strtol+0x39>
		s++;
  8025f4:	ff 45 08             	incl   0x8(%ebp)
  8025f7:	eb 13                	jmp    80260c <strtol+0x4c>
	else if (*s == '-')
  8025f9:	8b 45 08             	mov    0x8(%ebp),%eax
  8025fc:	8a 00                	mov    (%eax),%al
  8025fe:	3c 2d                	cmp    $0x2d,%al
  802600:	75 0a                	jne    80260c <strtol+0x4c>
		s++, neg = 1;
  802602:	ff 45 08             	incl   0x8(%ebp)
  802605:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  80260c:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  802610:	74 06                	je     802618 <strtol+0x58>
  802612:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  802616:	75 20                	jne    802638 <strtol+0x78>
  802618:	8b 45 08             	mov    0x8(%ebp),%eax
  80261b:	8a 00                	mov    (%eax),%al
  80261d:	3c 30                	cmp    $0x30,%al
  80261f:	75 17                	jne    802638 <strtol+0x78>
  802621:	8b 45 08             	mov    0x8(%ebp),%eax
  802624:	40                   	inc    %eax
  802625:	8a 00                	mov    (%eax),%al
  802627:	3c 78                	cmp    $0x78,%al
  802629:	75 0d                	jne    802638 <strtol+0x78>
		s += 2, base = 16;
  80262b:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  80262f:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  802636:	eb 28                	jmp    802660 <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  802638:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80263c:	75 15                	jne    802653 <strtol+0x93>
  80263e:	8b 45 08             	mov    0x8(%ebp),%eax
  802641:	8a 00                	mov    (%eax),%al
  802643:	3c 30                	cmp    $0x30,%al
  802645:	75 0c                	jne    802653 <strtol+0x93>
		s++, base = 8;
  802647:	ff 45 08             	incl   0x8(%ebp)
  80264a:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  802651:	eb 0d                	jmp    802660 <strtol+0xa0>
	else if (base == 0)
  802653:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  802657:	75 07                	jne    802660 <strtol+0xa0>
		base = 10;
  802659:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  802660:	8b 45 08             	mov    0x8(%ebp),%eax
  802663:	8a 00                	mov    (%eax),%al
  802665:	3c 2f                	cmp    $0x2f,%al
  802667:	7e 19                	jle    802682 <strtol+0xc2>
  802669:	8b 45 08             	mov    0x8(%ebp),%eax
  80266c:	8a 00                	mov    (%eax),%al
  80266e:	3c 39                	cmp    $0x39,%al
  802670:	7f 10                	jg     802682 <strtol+0xc2>
			dig = *s - '0';
  802672:	8b 45 08             	mov    0x8(%ebp),%eax
  802675:	8a 00                	mov    (%eax),%al
  802677:	0f be c0             	movsbl %al,%eax
  80267a:	83 e8 30             	sub    $0x30,%eax
  80267d:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802680:	eb 42                	jmp    8026c4 <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  802682:	8b 45 08             	mov    0x8(%ebp),%eax
  802685:	8a 00                	mov    (%eax),%al
  802687:	3c 60                	cmp    $0x60,%al
  802689:	7e 19                	jle    8026a4 <strtol+0xe4>
  80268b:	8b 45 08             	mov    0x8(%ebp),%eax
  80268e:	8a 00                	mov    (%eax),%al
  802690:	3c 7a                	cmp    $0x7a,%al
  802692:	7f 10                	jg     8026a4 <strtol+0xe4>
			dig = *s - 'a' + 10;
  802694:	8b 45 08             	mov    0x8(%ebp),%eax
  802697:	8a 00                	mov    (%eax),%al
  802699:	0f be c0             	movsbl %al,%eax
  80269c:	83 e8 57             	sub    $0x57,%eax
  80269f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8026a2:	eb 20                	jmp    8026c4 <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  8026a4:	8b 45 08             	mov    0x8(%ebp),%eax
  8026a7:	8a 00                	mov    (%eax),%al
  8026a9:	3c 40                	cmp    $0x40,%al
  8026ab:	7e 39                	jle    8026e6 <strtol+0x126>
  8026ad:	8b 45 08             	mov    0x8(%ebp),%eax
  8026b0:	8a 00                	mov    (%eax),%al
  8026b2:	3c 5a                	cmp    $0x5a,%al
  8026b4:	7f 30                	jg     8026e6 <strtol+0x126>
			dig = *s - 'A' + 10;
  8026b6:	8b 45 08             	mov    0x8(%ebp),%eax
  8026b9:	8a 00                	mov    (%eax),%al
  8026bb:	0f be c0             	movsbl %al,%eax
  8026be:	83 e8 37             	sub    $0x37,%eax
  8026c1:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  8026c4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026c7:	3b 45 10             	cmp    0x10(%ebp),%eax
  8026ca:	7d 19                	jge    8026e5 <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  8026cc:	ff 45 08             	incl   0x8(%ebp)
  8026cf:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8026d2:	0f af 45 10          	imul   0x10(%ebp),%eax
  8026d6:	89 c2                	mov    %eax,%edx
  8026d8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026db:	01 d0                	add    %edx,%eax
  8026dd:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  8026e0:	e9 7b ff ff ff       	jmp    802660 <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  8026e5:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  8026e6:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8026ea:	74 08                	je     8026f4 <strtol+0x134>
		*endptr = (char *) s;
  8026ec:	8b 45 0c             	mov    0xc(%ebp),%eax
  8026ef:	8b 55 08             	mov    0x8(%ebp),%edx
  8026f2:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  8026f4:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8026f8:	74 07                	je     802701 <strtol+0x141>
  8026fa:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8026fd:	f7 d8                	neg    %eax
  8026ff:	eb 03                	jmp    802704 <strtol+0x144>
  802701:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  802704:	c9                   	leave  
  802705:	c3                   	ret    

00802706 <ltostr>:

void
ltostr(long value, char *str)
{
  802706:	55                   	push   %ebp
  802707:	89 e5                	mov    %esp,%ebp
  802709:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  80270c:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  802713:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  80271a:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80271e:	79 13                	jns    802733 <ltostr+0x2d>
	{
		neg = 1;
  802720:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  802727:	8b 45 0c             	mov    0xc(%ebp),%eax
  80272a:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  80272d:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  802730:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  802733:	8b 45 08             	mov    0x8(%ebp),%eax
  802736:	b9 0a 00 00 00       	mov    $0xa,%ecx
  80273b:	99                   	cltd   
  80273c:	f7 f9                	idiv   %ecx
  80273e:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  802741:	8b 45 f8             	mov    -0x8(%ebp),%eax
  802744:	8d 50 01             	lea    0x1(%eax),%edx
  802747:	89 55 f8             	mov    %edx,-0x8(%ebp)
  80274a:	89 c2                	mov    %eax,%edx
  80274c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80274f:	01 d0                	add    %edx,%eax
  802751:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802754:	83 c2 30             	add    $0x30,%edx
  802757:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  802759:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80275c:	b8 67 66 66 66       	mov    $0x66666667,%eax
  802761:	f7 e9                	imul   %ecx
  802763:	c1 fa 02             	sar    $0x2,%edx
  802766:	89 c8                	mov    %ecx,%eax
  802768:	c1 f8 1f             	sar    $0x1f,%eax
  80276b:	29 c2                	sub    %eax,%edx
  80276d:	89 d0                	mov    %edx,%eax
  80276f:	89 45 08             	mov    %eax,0x8(%ebp)
	} while (value % 10 != 0);
  802772:	8b 4d 08             	mov    0x8(%ebp),%ecx
  802775:	b8 67 66 66 66       	mov    $0x66666667,%eax
  80277a:	f7 e9                	imul   %ecx
  80277c:	c1 fa 02             	sar    $0x2,%edx
  80277f:	89 c8                	mov    %ecx,%eax
  802781:	c1 f8 1f             	sar    $0x1f,%eax
  802784:	29 c2                	sub    %eax,%edx
  802786:	89 d0                	mov    %edx,%eax
  802788:	c1 e0 02             	shl    $0x2,%eax
  80278b:	01 d0                	add    %edx,%eax
  80278d:	01 c0                	add    %eax,%eax
  80278f:	29 c1                	sub    %eax,%ecx
  802791:	89 ca                	mov    %ecx,%edx
  802793:	85 d2                	test   %edx,%edx
  802795:	75 9c                	jne    802733 <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  802797:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  80279e:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8027a1:	48                   	dec    %eax
  8027a2:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  8027a5:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8027a9:	74 3d                	je     8027e8 <ltostr+0xe2>
		start = 1 ;
  8027ab:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  8027b2:	eb 34                	jmp    8027e8 <ltostr+0xe2>
	{
		char tmp = str[start] ;
  8027b4:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8027b7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8027ba:	01 d0                	add    %edx,%eax
  8027bc:	8a 00                	mov    (%eax),%al
  8027be:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  8027c1:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8027c4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8027c7:	01 c2                	add    %eax,%edx
  8027c9:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  8027cc:	8b 45 0c             	mov    0xc(%ebp),%eax
  8027cf:	01 c8                	add    %ecx,%eax
  8027d1:	8a 00                	mov    (%eax),%al
  8027d3:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  8027d5:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8027d8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8027db:	01 c2                	add    %eax,%edx
  8027dd:	8a 45 eb             	mov    -0x15(%ebp),%al
  8027e0:	88 02                	mov    %al,(%edx)
		start++ ;
  8027e2:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  8027e5:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  8027e8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027eb:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8027ee:	7c c4                	jl     8027b4 <ltostr+0xae>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  8027f0:	8b 55 f8             	mov    -0x8(%ebp),%edx
  8027f3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8027f6:	01 d0                	add    %edx,%eax
  8027f8:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  8027fb:	90                   	nop
  8027fc:	c9                   	leave  
  8027fd:	c3                   	ret    

008027fe <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  8027fe:	55                   	push   %ebp
  8027ff:	89 e5                	mov    %esp,%ebp
  802801:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  802804:	ff 75 08             	pushl  0x8(%ebp)
  802807:	e8 54 fa ff ff       	call   802260 <strlen>
  80280c:	83 c4 04             	add    $0x4,%esp
  80280f:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  802812:	ff 75 0c             	pushl  0xc(%ebp)
  802815:	e8 46 fa ff ff       	call   802260 <strlen>
  80281a:	83 c4 04             	add    $0x4,%esp
  80281d:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  802820:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  802827:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  80282e:	eb 17                	jmp    802847 <strcconcat+0x49>
		final[s] = str1[s] ;
  802830:	8b 55 fc             	mov    -0x4(%ebp),%edx
  802833:	8b 45 10             	mov    0x10(%ebp),%eax
  802836:	01 c2                	add    %eax,%edx
  802838:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  80283b:	8b 45 08             	mov    0x8(%ebp),%eax
  80283e:	01 c8                	add    %ecx,%eax
  802840:	8a 00                	mov    (%eax),%al
  802842:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  802844:	ff 45 fc             	incl   -0x4(%ebp)
  802847:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80284a:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  80284d:	7c e1                	jl     802830 <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  80284f:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  802856:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  80285d:	eb 1f                	jmp    80287e <strcconcat+0x80>
		final[s++] = str2[i] ;
  80285f:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802862:	8d 50 01             	lea    0x1(%eax),%edx
  802865:	89 55 fc             	mov    %edx,-0x4(%ebp)
  802868:	89 c2                	mov    %eax,%edx
  80286a:	8b 45 10             	mov    0x10(%ebp),%eax
  80286d:	01 c2                	add    %eax,%edx
  80286f:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  802872:	8b 45 0c             	mov    0xc(%ebp),%eax
  802875:	01 c8                	add    %ecx,%eax
  802877:	8a 00                	mov    (%eax),%al
  802879:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  80287b:	ff 45 f8             	incl   -0x8(%ebp)
  80287e:	8b 45 f8             	mov    -0x8(%ebp),%eax
  802881:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  802884:	7c d9                	jl     80285f <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  802886:	8b 55 fc             	mov    -0x4(%ebp),%edx
  802889:	8b 45 10             	mov    0x10(%ebp),%eax
  80288c:	01 d0                	add    %edx,%eax
  80288e:	c6 00 00             	movb   $0x0,(%eax)
}
  802891:	90                   	nop
  802892:	c9                   	leave  
  802893:	c3                   	ret    

00802894 <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  802894:	55                   	push   %ebp
  802895:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  802897:	8b 45 14             	mov    0x14(%ebp),%eax
  80289a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  8028a0:	8b 45 14             	mov    0x14(%ebp),%eax
  8028a3:	8b 00                	mov    (%eax),%eax
  8028a5:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8028ac:	8b 45 10             	mov    0x10(%ebp),%eax
  8028af:	01 d0                	add    %edx,%eax
  8028b1:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  8028b7:	eb 0c                	jmp    8028c5 <strsplit+0x31>
			*string++ = 0;
  8028b9:	8b 45 08             	mov    0x8(%ebp),%eax
  8028bc:	8d 50 01             	lea    0x1(%eax),%edx
  8028bf:	89 55 08             	mov    %edx,0x8(%ebp)
  8028c2:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  8028c5:	8b 45 08             	mov    0x8(%ebp),%eax
  8028c8:	8a 00                	mov    (%eax),%al
  8028ca:	84 c0                	test   %al,%al
  8028cc:	74 18                	je     8028e6 <strsplit+0x52>
  8028ce:	8b 45 08             	mov    0x8(%ebp),%eax
  8028d1:	8a 00                	mov    (%eax),%al
  8028d3:	0f be c0             	movsbl %al,%eax
  8028d6:	50                   	push   %eax
  8028d7:	ff 75 0c             	pushl  0xc(%ebp)
  8028da:	e8 13 fb ff ff       	call   8023f2 <strchr>
  8028df:	83 c4 08             	add    $0x8,%esp
  8028e2:	85 c0                	test   %eax,%eax
  8028e4:	75 d3                	jne    8028b9 <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  8028e6:	8b 45 08             	mov    0x8(%ebp),%eax
  8028e9:	8a 00                	mov    (%eax),%al
  8028eb:	84 c0                	test   %al,%al
  8028ed:	74 5a                	je     802949 <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  8028ef:	8b 45 14             	mov    0x14(%ebp),%eax
  8028f2:	8b 00                	mov    (%eax),%eax
  8028f4:	83 f8 0f             	cmp    $0xf,%eax
  8028f7:	75 07                	jne    802900 <strsplit+0x6c>
		{
			return 0;
  8028f9:	b8 00 00 00 00       	mov    $0x0,%eax
  8028fe:	eb 66                	jmp    802966 <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  802900:	8b 45 14             	mov    0x14(%ebp),%eax
  802903:	8b 00                	mov    (%eax),%eax
  802905:	8d 48 01             	lea    0x1(%eax),%ecx
  802908:	8b 55 14             	mov    0x14(%ebp),%edx
  80290b:	89 0a                	mov    %ecx,(%edx)
  80290d:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  802914:	8b 45 10             	mov    0x10(%ebp),%eax
  802917:	01 c2                	add    %eax,%edx
  802919:	8b 45 08             	mov    0x8(%ebp),%eax
  80291c:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  80291e:	eb 03                	jmp    802923 <strsplit+0x8f>
			string++;
  802920:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  802923:	8b 45 08             	mov    0x8(%ebp),%eax
  802926:	8a 00                	mov    (%eax),%al
  802928:	84 c0                	test   %al,%al
  80292a:	74 8b                	je     8028b7 <strsplit+0x23>
  80292c:	8b 45 08             	mov    0x8(%ebp),%eax
  80292f:	8a 00                	mov    (%eax),%al
  802931:	0f be c0             	movsbl %al,%eax
  802934:	50                   	push   %eax
  802935:	ff 75 0c             	pushl  0xc(%ebp)
  802938:	e8 b5 fa ff ff       	call   8023f2 <strchr>
  80293d:	83 c4 08             	add    $0x8,%esp
  802940:	85 c0                	test   %eax,%eax
  802942:	74 dc                	je     802920 <strsplit+0x8c>
			string++;
	}
  802944:	e9 6e ff ff ff       	jmp    8028b7 <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  802949:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  80294a:	8b 45 14             	mov    0x14(%ebp),%eax
  80294d:	8b 00                	mov    (%eax),%eax
  80294f:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  802956:	8b 45 10             	mov    0x10(%ebp),%eax
  802959:	01 d0                	add    %edx,%eax
  80295b:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  802961:	b8 01 00 00 00       	mov    $0x1,%eax
}
  802966:	c9                   	leave  
  802967:	c3                   	ret    

00802968 <InitializeUHeap>:
//============================== GIVEN FUNCTIONS ===================================//
//==================================================================================//

int FirstTimeFlag = 1;
void InitializeUHeap()
{
  802968:	55                   	push   %ebp
  802969:	89 e5                	mov    %esp,%ebp
  80296b:	83 ec 08             	sub    $0x8,%esp
	if(FirstTimeFlag)
  80296e:	a1 04 60 80 00       	mov    0x806004,%eax
  802973:	85 c0                	test   %eax,%eax
  802975:	74 1f                	je     802996 <InitializeUHeap+0x2e>
	{
		initialize_dyn_block_system();
  802977:	e8 1d 00 00 00       	call   802999 <initialize_dyn_block_system>
		cprintf("DYNAMIC BLOCK SYSTEM IS INITIALIZED\n");
  80297c:	83 ec 0c             	sub    $0xc,%esp
  80297f:	68 50 4f 80 00       	push   $0x804f50
  802984:	e8 55 f2 ff ff       	call   801bde <cprintf>
  802989:	83 c4 10             	add    $0x10,%esp
#if UHP_USE_BUDDY
		initialize_buddy();
		cprintf("BUDDY SYSTEM IS INITIALIZED\n");
#endif
		FirstTimeFlag = 0;
  80298c:	c7 05 04 60 80 00 00 	movl   $0x0,0x806004
  802993:	00 00 00 
	}
}
  802996:	90                   	nop
  802997:	c9                   	leave  
  802998:	c3                   	ret    

00802999 <initialize_dyn_block_system>:

//=================================
// [1] INITIALIZE DYNAMIC ALLOCATOR:
//=================================
void initialize_dyn_block_system()
{
  802999:	55                   	push   %ebp
  80299a:	89 e5                	mov    %esp,%ebp
  80299c:	83 ec 28             	sub    $0x28,%esp
	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] initialize_dyn_block_system
	// your code is here, remove the panic and write your code
	//panic("initialize_dyn_block_system() is not implemented yet...!!");

	LIST_INIT(&AllocMemBlocksList);
  80299f:	c7 05 40 60 80 00 00 	movl   $0x0,0x806040
  8029a6:	00 00 00 
  8029a9:	c7 05 44 60 80 00 00 	movl   $0x0,0x806044
  8029b0:	00 00 00 
  8029b3:	c7 05 4c 60 80 00 00 	movl   $0x0,0x80604c
  8029ba:	00 00 00 
	LIST_INIT(&FreeMemBlocksList);
  8029bd:	c7 05 38 61 80 00 00 	movl   $0x0,0x806138
  8029c4:	00 00 00 
  8029c7:	c7 05 3c 61 80 00 00 	movl   $0x0,0x80613c
  8029ce:	00 00 00 
  8029d1:	c7 05 44 61 80 00 00 	movl   $0x0,0x806144
  8029d8:	00 00 00 
	MAX_MEM_BLOCK_CNT = NUM_OF_UHEAP_PAGES;
  8029db:	c7 05 20 61 80 00 00 	movl   $0x20000,0x806120
  8029e2:	00 02 00 
	MemBlockNodes = (void*)USER_DYN_BLKS_ARRAY;
  8029e5:	c7 45 f4 00 00 e0 7f 	movl   $0x7fe00000,-0xc(%ebp)
  8029ec:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029ef:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8029f4:	2d 00 10 00 00       	sub    $0x1000,%eax
  8029f9:	a3 50 60 80 00       	mov    %eax,0x806050
	int size_of_block = sizeof(struct MemBlock);
  8029fe:	c7 45 f0 10 00 00 00 	movl   $0x10,-0x10(%ebp)
	int size_all_struct = size_of_block*MAX_MEM_BLOCK_CNT;
  802a05:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802a08:	a1 20 61 80 00       	mov    0x806120,%eax
  802a0d:	0f af c2             	imul   %edx,%eax
  802a10:	89 45 ec             	mov    %eax,-0x14(%ebp)
	size_all_struct = ROUNDUP(size_all_struct, PAGE_SIZE);
  802a13:	c7 45 e8 00 10 00 00 	movl   $0x1000,-0x18(%ebp)
  802a1a:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802a1d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802a20:	01 d0                	add    %edx,%eax
  802a22:	48                   	dec    %eax
  802a23:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  802a26:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802a29:	ba 00 00 00 00       	mov    $0x0,%edx
  802a2e:	f7 75 e8             	divl   -0x18(%ebp)
  802a31:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802a34:	29 d0                	sub    %edx,%eax
  802a36:	89 45 ec             	mov    %eax,-0x14(%ebp)
	sys_allocate_chunk(USER_DYN_BLKS_ARRAY, size_all_struct,PERM_USER| PERM_WRITEABLE);
  802a39:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802a3c:	c7 45 e0 00 00 e0 7f 	movl   $0x7fe00000,-0x20(%ebp)
  802a43:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802a46:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
  802a4c:	81 ea 00 10 00 00    	sub    $0x1000,%edx
  802a52:	83 ec 04             	sub    $0x4,%esp
  802a55:	6a 06                	push   $0x6
  802a57:	50                   	push   %eax
  802a58:	52                   	push   %edx
  802a59:	e8 a1 05 00 00       	call   802fff <sys_allocate_chunk>
  802a5e:	83 c4 10             	add    $0x10,%esp
	initialize_MemBlocksList(MAX_MEM_BLOCK_CNT);
  802a61:	a1 20 61 80 00       	mov    0x806120,%eax
  802a66:	83 ec 0c             	sub    $0xc,%esp
  802a69:	50                   	push   %eax
  802a6a:	e8 16 0c 00 00       	call   803685 <initialize_MemBlocksList>
  802a6f:	83 c4 10             	add    $0x10,%esp
	struct MemBlock* ourBlock =LIST_LAST(&AvailableMemBlocksList);
  802a72:	a1 4c 61 80 00       	mov    0x80614c,%eax
  802a77:	89 45 dc             	mov    %eax,-0x24(%ebp)
	LIST_REMOVE(&AvailableMemBlocksList,ourBlock);
  802a7a:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  802a7e:	75 14                	jne    802a94 <initialize_dyn_block_system+0xfb>
  802a80:	83 ec 04             	sub    $0x4,%esp
  802a83:	68 75 4f 80 00       	push   $0x804f75
  802a88:	6a 2d                	push   $0x2d
  802a8a:	68 93 4f 80 00       	push   $0x804f93
  802a8f:	e8 96 ee ff ff       	call   80192a <_panic>
  802a94:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802a97:	8b 00                	mov    (%eax),%eax
  802a99:	85 c0                	test   %eax,%eax
  802a9b:	74 10                	je     802aad <initialize_dyn_block_system+0x114>
  802a9d:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802aa0:	8b 00                	mov    (%eax),%eax
  802aa2:	8b 55 dc             	mov    -0x24(%ebp),%edx
  802aa5:	8b 52 04             	mov    0x4(%edx),%edx
  802aa8:	89 50 04             	mov    %edx,0x4(%eax)
  802aab:	eb 0b                	jmp    802ab8 <initialize_dyn_block_system+0x11f>
  802aad:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802ab0:	8b 40 04             	mov    0x4(%eax),%eax
  802ab3:	a3 4c 61 80 00       	mov    %eax,0x80614c
  802ab8:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802abb:	8b 40 04             	mov    0x4(%eax),%eax
  802abe:	85 c0                	test   %eax,%eax
  802ac0:	74 0f                	je     802ad1 <initialize_dyn_block_system+0x138>
  802ac2:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802ac5:	8b 40 04             	mov    0x4(%eax),%eax
  802ac8:	8b 55 dc             	mov    -0x24(%ebp),%edx
  802acb:	8b 12                	mov    (%edx),%edx
  802acd:	89 10                	mov    %edx,(%eax)
  802acf:	eb 0a                	jmp    802adb <initialize_dyn_block_system+0x142>
  802ad1:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802ad4:	8b 00                	mov    (%eax),%eax
  802ad6:	a3 48 61 80 00       	mov    %eax,0x806148
  802adb:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802ade:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802ae4:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802ae7:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802aee:	a1 54 61 80 00       	mov    0x806154,%eax
  802af3:	48                   	dec    %eax
  802af4:	a3 54 61 80 00       	mov    %eax,0x806154
	ourBlock->size = USER_HEAP_MAX-USER_HEAP_START;
  802af9:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802afc:	c7 40 0c 00 00 00 20 	movl   $0x20000000,0xc(%eax)
	ourBlock->sva=USER_HEAP_START;
  802b03:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802b06:	c7 40 08 00 00 00 80 	movl   $0x80000000,0x8(%eax)
	LIST_INSERT_TAIL(&FreeMemBlocksList, ourBlock);
  802b0d:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  802b11:	75 14                	jne    802b27 <initialize_dyn_block_system+0x18e>
  802b13:	83 ec 04             	sub    $0x4,%esp
  802b16:	68 a0 4f 80 00       	push   $0x804fa0
  802b1b:	6a 30                	push   $0x30
  802b1d:	68 93 4f 80 00       	push   $0x804f93
  802b22:	e8 03 ee ff ff       	call   80192a <_panic>
  802b27:	8b 15 3c 61 80 00    	mov    0x80613c,%edx
  802b2d:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802b30:	89 50 04             	mov    %edx,0x4(%eax)
  802b33:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802b36:	8b 40 04             	mov    0x4(%eax),%eax
  802b39:	85 c0                	test   %eax,%eax
  802b3b:	74 0c                	je     802b49 <initialize_dyn_block_system+0x1b0>
  802b3d:	a1 3c 61 80 00       	mov    0x80613c,%eax
  802b42:	8b 55 dc             	mov    -0x24(%ebp),%edx
  802b45:	89 10                	mov    %edx,(%eax)
  802b47:	eb 08                	jmp    802b51 <initialize_dyn_block_system+0x1b8>
  802b49:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802b4c:	a3 38 61 80 00       	mov    %eax,0x806138
  802b51:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802b54:	a3 3c 61 80 00       	mov    %eax,0x80613c
  802b59:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802b5c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802b62:	a1 44 61 80 00       	mov    0x806144,%eax
  802b67:	40                   	inc    %eax
  802b68:	a3 44 61 80 00       	mov    %eax,0x806144
	//[1] Initialize two lists (AllocMemBlocksList & FreeMemBlocksList) [Hint: use LIST_INIT()]
	//[2] Dynamically allocate the array of MemBlockNodes at VA USER_DYN_BLKS_ARRAY
	//	  (remember to set MAX_MEM_BLOCK_CNT with the chosen size of the array)
	//[3] Initialize AvailableMemBlocksList by filling it with the MemBlockNodes
	//[4] Insert a new MemBlock with the heap size into the FreeMemBlocksList
}
  802b6d:	90                   	nop
  802b6e:	c9                   	leave  
  802b6f:	c3                   	ret    

00802b70 <malloc>:
//=================================
// [2] ALLOCATE SPACE IN USER HEAP:
//=================================

void* malloc(uint32 size)
{
  802b70:	55                   	push   %ebp
  802b71:	89 e5                	mov    %esp,%ebp
  802b73:	83 ec 18             	sub    $0x18,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  802b76:	e8 ed fd ff ff       	call   802968 <InitializeUHeap>
	if (size == 0) return NULL ;
  802b7b:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802b7f:	75 07                	jne    802b88 <malloc+0x18>
  802b81:	b8 00 00 00 00       	mov    $0x0,%eax
  802b86:	eb 67                	jmp    802bef <malloc+0x7f>

	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] malloc
	// your code is here, remove the panic and write your code
	//panic("malloc() is not implemented yet...!!");

	size = ROUNDUP(size, PAGE_SIZE);
  802b88:	c7 45 f4 00 10 00 00 	movl   $0x1000,-0xc(%ebp)
  802b8f:	8b 55 08             	mov    0x8(%ebp),%edx
  802b92:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b95:	01 d0                	add    %edx,%eax
  802b97:	48                   	dec    %eax
  802b98:	89 45 f0             	mov    %eax,-0x10(%ebp)
  802b9b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b9e:	ba 00 00 00 00       	mov    $0x0,%edx
  802ba3:	f7 75 f4             	divl   -0xc(%ebp)
  802ba6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ba9:	29 d0                	sub    %edx,%eax
  802bab:	89 45 08             	mov    %eax,0x8(%ebp)
	if(sys_isUHeapPlacementStrategyFIRSTFIT())
  802bae:	e8 1a 08 00 00       	call   8033cd <sys_isUHeapPlacementStrategyFIRSTFIT>
  802bb3:	85 c0                	test   %eax,%eax
  802bb5:	74 33                	je     802bea <malloc+0x7a>
	{
		struct MemBlock * myBlock = alloc_block_FF(size);
  802bb7:	83 ec 0c             	sub    $0xc,%esp
  802bba:	ff 75 08             	pushl  0x8(%ebp)
  802bbd:	e8 0c 0e 00 00       	call   8039ce <alloc_block_FF>
  802bc2:	83 c4 10             	add    $0x10,%esp
  802bc5:	89 45 ec             	mov    %eax,-0x14(%ebp)
		if(myBlock != NULL)
  802bc8:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802bcc:	74 1c                	je     802bea <malloc+0x7a>
		{
			insert_sorted_allocList(myBlock);
  802bce:	83 ec 0c             	sub    $0xc,%esp
  802bd1:	ff 75 ec             	pushl  -0x14(%ebp)
  802bd4:	e8 07 0c 00 00       	call   8037e0 <insert_sorted_allocList>
  802bd9:	83 c4 10             	add    $0x10,%esp
			uint32 ptr = myBlock->sva;
  802bdc:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802bdf:	8b 40 08             	mov    0x8(%eax),%eax
  802be2:	89 45 e8             	mov    %eax,-0x18(%ebp)
			return (void *)ptr;
  802be5:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802be8:	eb 05                	jmp    802bef <malloc+0x7f>
		}
	}
	return NULL;
  802bea:	b8 00 00 00 00       	mov    $0x0,%eax
	//		to the required allocation size (space should be on 4 KB BOUNDARY)
	//	2) if no suitable space found, return NULL
	// 	3) Return pointer containing the virtual address of allocated space,
	//
	//Use sys_isUHeapPlacementStrategyFIRSTFIT()... to check the current strategy
}
  802bef:	c9                   	leave  
  802bf0:	c3                   	ret    

00802bf1 <free>:
//	We can use sys_free_user_mem(uint32 virtual_address, uint32 size); which
//		switches to the kernel mode, calls free_user_mem() in
//		"kern/mem/chunk_operations.c", then switch back to the user mode here
//	the free_user_mem function is empty, make sure to implement it.
void free(void* virtual_address)
{
  802bf1:	55                   	push   %ebp
  802bf2:	89 e5                	mov    %esp,%ebp
  802bf4:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] free
	// your code is here, remove the panic and write your code
	//panic("free() is not implemented yet...!!");

	uint32 virtualAddress = (uint32 )(virtual_address);
  802bf7:	8b 45 08             	mov    0x8(%ebp),%eax
  802bfa:	89 45 f4             	mov    %eax,-0xc(%ebp)
//	virtualAddress = ROUNDDOWN(virtualAddress, PAGE_SIZE);
	struct MemBlock * myBlock = find_block(&AllocMemBlocksList, virtualAddress);
  802bfd:	83 ec 08             	sub    $0x8,%esp
  802c00:	ff 75 f4             	pushl  -0xc(%ebp)
  802c03:	68 40 60 80 00       	push   $0x806040
  802c08:	e8 5b 0b 00 00       	call   803768 <find_block>
  802c0d:	83 c4 10             	add    $0x10,%esp
  802c10:	89 45 f0             	mov    %eax,-0x10(%ebp)
//	cprintf ("ptr sva at free user side = %x \n", myBlock->sva);
	sys_free_user_mem(virtualAddress, myBlock->size);
  802c13:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c16:	8b 40 0c             	mov    0xc(%eax),%eax
  802c19:	83 ec 08             	sub    $0x8,%esp
  802c1c:	50                   	push   %eax
  802c1d:	ff 75 f4             	pushl  -0xc(%ebp)
  802c20:	e8 a2 03 00 00       	call   802fc7 <sys_free_user_mem>
  802c25:	83 c4 10             	add    $0x10,%esp
	LIST_REMOVE(&AllocMemBlocksList, myBlock);
  802c28:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802c2c:	75 14                	jne    802c42 <free+0x51>
  802c2e:	83 ec 04             	sub    $0x4,%esp
  802c31:	68 75 4f 80 00       	push   $0x804f75
  802c36:	6a 76                	push   $0x76
  802c38:	68 93 4f 80 00       	push   $0x804f93
  802c3d:	e8 e8 ec ff ff       	call   80192a <_panic>
  802c42:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c45:	8b 00                	mov    (%eax),%eax
  802c47:	85 c0                	test   %eax,%eax
  802c49:	74 10                	je     802c5b <free+0x6a>
  802c4b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c4e:	8b 00                	mov    (%eax),%eax
  802c50:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802c53:	8b 52 04             	mov    0x4(%edx),%edx
  802c56:	89 50 04             	mov    %edx,0x4(%eax)
  802c59:	eb 0b                	jmp    802c66 <free+0x75>
  802c5b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c5e:	8b 40 04             	mov    0x4(%eax),%eax
  802c61:	a3 44 60 80 00       	mov    %eax,0x806044
  802c66:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c69:	8b 40 04             	mov    0x4(%eax),%eax
  802c6c:	85 c0                	test   %eax,%eax
  802c6e:	74 0f                	je     802c7f <free+0x8e>
  802c70:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c73:	8b 40 04             	mov    0x4(%eax),%eax
  802c76:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802c79:	8b 12                	mov    (%edx),%edx
  802c7b:	89 10                	mov    %edx,(%eax)
  802c7d:	eb 0a                	jmp    802c89 <free+0x98>
  802c7f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c82:	8b 00                	mov    (%eax),%eax
  802c84:	a3 40 60 80 00       	mov    %eax,0x806040
  802c89:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c8c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802c92:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c95:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802c9c:	a1 4c 60 80 00       	mov    0x80604c,%eax
  802ca1:	48                   	dec    %eax
  802ca2:	a3 4c 60 80 00       	mov    %eax,0x80604c
	insert_sorted_with_merge_freeList(myBlock);
  802ca7:	83 ec 0c             	sub    $0xc,%esp
  802caa:	ff 75 f0             	pushl  -0x10(%ebp)
  802cad:	e8 0b 14 00 00       	call   8040bd <insert_sorted_with_merge_freeList>
  802cb2:	83 c4 10             	add    $0x10,%esp

	//you should get the size of the given allocation using its address
	//you need to call sys_free_user_mem()
	//refer to the project presentation and documentation for details
}
  802cb5:	90                   	nop
  802cb6:	c9                   	leave  
  802cb7:	c3                   	ret    

00802cb8 <smalloc>:

//=================================
// [4] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
  802cb8:	55                   	push   %ebp
  802cb9:	89 e5                	mov    %esp,%ebp
  802cbb:	83 ec 28             	sub    $0x28,%esp
  802cbe:	8b 45 10             	mov    0x10(%ebp),%eax
  802cc1:	88 45 e4             	mov    %al,-0x1c(%ebp)
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  802cc4:	e8 9f fc ff ff       	call   802968 <InitializeUHeap>
	if (size == 0) return NULL ;
  802cc9:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  802ccd:	75 0a                	jne    802cd9 <smalloc+0x21>
  802ccf:	b8 00 00 00 00       	mov    $0x0,%eax
  802cd4:	e9 8d 00 00 00       	jmp    802d66 <smalloc+0xae>

	//This function should find the space of the required range
	// * ON 4KB BOUNDARY **** //
	//Use sys_isUHeapPlacementStrategyFIRSTFIT() to check the current strategy

	size = ROUNDUP(size, PAGE_SIZE);
  802cd9:	c7 45 f4 00 10 00 00 	movl   $0x1000,-0xc(%ebp)
  802ce0:	8b 55 0c             	mov    0xc(%ebp),%edx
  802ce3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ce6:	01 d0                	add    %edx,%eax
  802ce8:	48                   	dec    %eax
  802ce9:	89 45 f0             	mov    %eax,-0x10(%ebp)
  802cec:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802cef:	ba 00 00 00 00       	mov    $0x0,%edx
  802cf4:	f7 75 f4             	divl   -0xc(%ebp)
  802cf7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802cfa:	29 d0                	sub    %edx,%eax
  802cfc:	89 45 0c             	mov    %eax,0xc(%ebp)
		if(sys_isUHeapPlacementStrategyFIRSTFIT())
  802cff:	e8 c9 06 00 00       	call   8033cd <sys_isUHeapPlacementStrategyFIRSTFIT>
  802d04:	85 c0                	test   %eax,%eax
  802d06:	74 59                	je     802d61 <smalloc+0xa9>
		{
			struct MemBlock * v1=NULL;
  802d08:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
			v1= alloc_block_FF(size);
  802d0f:	83 ec 0c             	sub    $0xc,%esp
  802d12:	ff 75 0c             	pushl  0xc(%ebp)
  802d15:	e8 b4 0c 00 00       	call   8039ce <alloc_block_FF>
  802d1a:	83 c4 10             	add    $0x10,%esp
  802d1d:	89 45 ec             	mov    %eax,-0x14(%ebp)
			if(v1==NULL)
  802d20:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802d24:	75 07                	jne    802d2d <smalloc+0x75>
			{
				return NULL;
  802d26:	b8 00 00 00 00       	mov    $0x0,%eax
  802d2b:	eb 39                	jmp    802d66 <smalloc+0xae>
			}
			else
			{
				int ret=sys_createSharedObject(sharedVarName,  size,  isWritable,(void*)v1->sva);
  802d2d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802d30:	8b 40 08             	mov    0x8(%eax),%eax
  802d33:	89 c2                	mov    %eax,%edx
  802d35:	0f b6 45 e4          	movzbl -0x1c(%ebp),%eax
  802d39:	52                   	push   %edx
  802d3a:	50                   	push   %eax
  802d3b:	ff 75 0c             	pushl  0xc(%ebp)
  802d3e:	ff 75 08             	pushl  0x8(%ebp)
  802d41:	e8 0c 04 00 00       	call   803152 <sys_createSharedObject>
  802d46:	83 c4 10             	add    $0x10,%esp
  802d49:	89 45 e8             	mov    %eax,-0x18(%ebp)
				if(ret>=0)
  802d4c:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  802d50:	78 08                	js     802d5a <smalloc+0xa2>
				{
					return (void*)v1->sva;
  802d52:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802d55:	8b 40 08             	mov    0x8(%eax),%eax
  802d58:	eb 0c                	jmp    802d66 <smalloc+0xae>
				}
				else
				{
					return NULL;
  802d5a:	b8 00 00 00 00       	mov    $0x0,%eax
  802d5f:	eb 05                	jmp    802d66 <smalloc+0xae>
				}
			}

		}
		return NULL;
  802d61:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802d66:	c9                   	leave  
  802d67:	c3                   	ret    

00802d68 <sget>:

//========================================
// [5] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  802d68:	55                   	push   %ebp
  802d69:	89 e5                	mov    %esp,%ebp
  802d6b:	83 ec 18             	sub    $0x18,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  802d6e:	e8 f5 fb ff ff       	call   802968 <InitializeUHeap>

	//This function should find the space for sharing the variable
	// *** ON 4KB BOUNDARY ******** //

	//Use sys_isUHeapPlacementStrategyFIRSTFIT() to check the current strategy
	int ret=sys_getSizeOfSharedObject(ownerEnvID,sharedVarName);
  802d73:	83 ec 08             	sub    $0x8,%esp
  802d76:	ff 75 0c             	pushl  0xc(%ebp)
  802d79:	ff 75 08             	pushl  0x8(%ebp)
  802d7c:	e8 fb 03 00 00       	call   80317c <sys_getSizeOfSharedObject>
  802d81:	83 c4 10             	add    $0x10,%esp
  802d84:	89 45 f4             	mov    %eax,-0xc(%ebp)
	if(ret==0)
  802d87:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802d8b:	75 07                	jne    802d94 <sget+0x2c>
	{
		return NULL;
  802d8d:	b8 00 00 00 00       	mov    $0x0,%eax
  802d92:	eb 64                	jmp    802df8 <sget+0x90>
	}
	if(sys_isUHeapPlacementStrategyFIRSTFIT())
  802d94:	e8 34 06 00 00       	call   8033cd <sys_isUHeapPlacementStrategyFIRSTFIT>
  802d99:	85 c0                	test   %eax,%eax
  802d9b:	74 56                	je     802df3 <sget+0x8b>
	{
		struct MemBlock * v1=NULL;
  802d9d:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
		v1= alloc_block_FF(ret);
  802da4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802da7:	83 ec 0c             	sub    $0xc,%esp
  802daa:	50                   	push   %eax
  802dab:	e8 1e 0c 00 00       	call   8039ce <alloc_block_FF>
  802db0:	83 c4 10             	add    $0x10,%esp
  802db3:	89 45 f0             	mov    %eax,-0x10(%ebp)
		if(v1==NULL)
  802db6:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802dba:	75 07                	jne    802dc3 <sget+0x5b>
		{
		return NULL;
  802dbc:	b8 00 00 00 00       	mov    $0x0,%eax
  802dc1:	eb 35                	jmp    802df8 <sget+0x90>
	    }
		else
		{
			int ret1=sys_getSharedObject(ownerEnvID,sharedVarName,(void*)v1->sva);
  802dc3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802dc6:	8b 40 08             	mov    0x8(%eax),%eax
  802dc9:	83 ec 04             	sub    $0x4,%esp
  802dcc:	50                   	push   %eax
  802dcd:	ff 75 0c             	pushl  0xc(%ebp)
  802dd0:	ff 75 08             	pushl  0x8(%ebp)
  802dd3:	e8 c1 03 00 00       	call   803199 <sys_getSharedObject>
  802dd8:	83 c4 10             	add    $0x10,%esp
  802ddb:	89 45 ec             	mov    %eax,-0x14(%ebp)
			if(ret1>=0)
  802dde:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802de2:	78 08                	js     802dec <sget+0x84>
			{
				return (void*)v1->sva;
  802de4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802de7:	8b 40 08             	mov    0x8(%eax),%eax
  802dea:	eb 0c                	jmp    802df8 <sget+0x90>
			}
			else
			{
				return NULL;
  802dec:	b8 00 00 00 00       	mov    $0x0,%eax
  802df1:	eb 05                	jmp    802df8 <sget+0x90>
			}
		}
	}
  return NULL;
  802df3:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802df8:	c9                   	leave  
  802df9:	c3                   	ret    

00802dfa <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  802dfa:	55                   	push   %ebp
  802dfb:	89 e5                	mov    %esp,%ebp
  802dfd:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  802e00:	e8 63 fb ff ff       	call   802968 <InitializeUHeap>
	//==============================================================
	// [USER HEAP - USER SIDE] realloc
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  802e05:	83 ec 04             	sub    $0x4,%esp
  802e08:	68 c4 4f 80 00       	push   $0x804fc4
  802e0d:	68 0e 01 00 00       	push   $0x10e
  802e12:	68 93 4f 80 00       	push   $0x804f93
  802e17:	e8 0e eb ff ff       	call   80192a <_panic>

00802e1c <sfree>:
//	use sys_freeSharedObject(...); which switches to the kernel mode,
//	calls freeSharedObject(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the freeSharedObject() function is empty, make sure to implement it.

void sfree(void* virtual_address)
{
  802e1c:	55                   	push   %ebp
  802e1d:	89 e5                	mov    %esp,%ebp
  802e1f:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS3 - BONUS] [SHARING - USER SIDE] sfree()

	// Write your code here, remove the panic and write your code
	panic("sfree() is not implemented yet...!!");
  802e22:	83 ec 04             	sub    $0x4,%esp
  802e25:	68 ec 4f 80 00       	push   $0x804fec
  802e2a:	68 22 01 00 00       	push   $0x122
  802e2f:	68 93 4f 80 00       	push   $0x804f93
  802e34:	e8 f1 ea ff ff       	call   80192a <_panic>

00802e39 <expand>:

//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//
void expand(uint32 newSize)
{
  802e39:	55                   	push   %ebp
  802e3a:	89 e5                	mov    %esp,%ebp
  802e3c:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  802e3f:	83 ec 04             	sub    $0x4,%esp
  802e42:	68 10 50 80 00       	push   $0x805010
  802e47:	68 2d 01 00 00       	push   $0x12d
  802e4c:	68 93 4f 80 00       	push   $0x804f93
  802e51:	e8 d4 ea ff ff       	call   80192a <_panic>

00802e56 <shrink>:

}
void shrink(uint32 newSize)
{
  802e56:	55                   	push   %ebp
  802e57:	89 e5                	mov    %esp,%ebp
  802e59:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  802e5c:	83 ec 04             	sub    $0x4,%esp
  802e5f:	68 10 50 80 00       	push   $0x805010
  802e64:	68 32 01 00 00       	push   $0x132
  802e69:	68 93 4f 80 00       	push   $0x804f93
  802e6e:	e8 b7 ea ff ff       	call   80192a <_panic>

00802e73 <freeHeap>:

}
void freeHeap(void* virtual_address)
{
  802e73:	55                   	push   %ebp
  802e74:	89 e5                	mov    %esp,%ebp
  802e76:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  802e79:	83 ec 04             	sub    $0x4,%esp
  802e7c:	68 10 50 80 00       	push   $0x805010
  802e81:	68 37 01 00 00       	push   $0x137
  802e86:	68 93 4f 80 00       	push   $0x804f93
  802e8b:	e8 9a ea ff ff       	call   80192a <_panic>

00802e90 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  802e90:	55                   	push   %ebp
  802e91:	89 e5                	mov    %esp,%ebp
  802e93:	57                   	push   %edi
  802e94:	56                   	push   %esi
  802e95:	53                   	push   %ebx
  802e96:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  802e99:	8b 45 08             	mov    0x8(%ebp),%eax
  802e9c:	8b 55 0c             	mov    0xc(%ebp),%edx
  802e9f:	8b 4d 10             	mov    0x10(%ebp),%ecx
  802ea2:	8b 5d 14             	mov    0x14(%ebp),%ebx
  802ea5:	8b 7d 18             	mov    0x18(%ebp),%edi
  802ea8:	8b 75 1c             	mov    0x1c(%ebp),%esi
  802eab:	cd 30                	int    $0x30
  802ead:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  802eb0:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  802eb3:	83 c4 10             	add    $0x10,%esp
  802eb6:	5b                   	pop    %ebx
  802eb7:	5e                   	pop    %esi
  802eb8:	5f                   	pop    %edi
  802eb9:	5d                   	pop    %ebp
  802eba:	c3                   	ret    

00802ebb <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  802ebb:	55                   	push   %ebp
  802ebc:	89 e5                	mov    %esp,%ebp
  802ebe:	83 ec 04             	sub    $0x4,%esp
  802ec1:	8b 45 10             	mov    0x10(%ebp),%eax
  802ec4:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  802ec7:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  802ecb:	8b 45 08             	mov    0x8(%ebp),%eax
  802ece:	6a 00                	push   $0x0
  802ed0:	6a 00                	push   $0x0
  802ed2:	52                   	push   %edx
  802ed3:	ff 75 0c             	pushl  0xc(%ebp)
  802ed6:	50                   	push   %eax
  802ed7:	6a 00                	push   $0x0
  802ed9:	e8 b2 ff ff ff       	call   802e90 <syscall>
  802ede:	83 c4 18             	add    $0x18,%esp
}
  802ee1:	90                   	nop
  802ee2:	c9                   	leave  
  802ee3:	c3                   	ret    

00802ee4 <sys_cgetc>:

int
sys_cgetc(void)
{
  802ee4:	55                   	push   %ebp
  802ee5:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  802ee7:	6a 00                	push   $0x0
  802ee9:	6a 00                	push   $0x0
  802eeb:	6a 00                	push   $0x0
  802eed:	6a 00                	push   $0x0
  802eef:	6a 00                	push   $0x0
  802ef1:	6a 01                	push   $0x1
  802ef3:	e8 98 ff ff ff       	call   802e90 <syscall>
  802ef8:	83 c4 18             	add    $0x18,%esp
}
  802efb:	c9                   	leave  
  802efc:	c3                   	ret    

00802efd <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  802efd:	55                   	push   %ebp
  802efe:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  802f00:	8b 55 0c             	mov    0xc(%ebp),%edx
  802f03:	8b 45 08             	mov    0x8(%ebp),%eax
  802f06:	6a 00                	push   $0x0
  802f08:	6a 00                	push   $0x0
  802f0a:	6a 00                	push   $0x0
  802f0c:	52                   	push   %edx
  802f0d:	50                   	push   %eax
  802f0e:	6a 05                	push   $0x5
  802f10:	e8 7b ff ff ff       	call   802e90 <syscall>
  802f15:	83 c4 18             	add    $0x18,%esp
}
  802f18:	c9                   	leave  
  802f19:	c3                   	ret    

00802f1a <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  802f1a:	55                   	push   %ebp
  802f1b:	89 e5                	mov    %esp,%ebp
  802f1d:	56                   	push   %esi
  802f1e:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  802f1f:	8b 75 18             	mov    0x18(%ebp),%esi
  802f22:	8b 5d 14             	mov    0x14(%ebp),%ebx
  802f25:	8b 4d 10             	mov    0x10(%ebp),%ecx
  802f28:	8b 55 0c             	mov    0xc(%ebp),%edx
  802f2b:	8b 45 08             	mov    0x8(%ebp),%eax
  802f2e:	56                   	push   %esi
  802f2f:	53                   	push   %ebx
  802f30:	51                   	push   %ecx
  802f31:	52                   	push   %edx
  802f32:	50                   	push   %eax
  802f33:	6a 06                	push   $0x6
  802f35:	e8 56 ff ff ff       	call   802e90 <syscall>
  802f3a:	83 c4 18             	add    $0x18,%esp
}
  802f3d:	8d 65 f8             	lea    -0x8(%ebp),%esp
  802f40:	5b                   	pop    %ebx
  802f41:	5e                   	pop    %esi
  802f42:	5d                   	pop    %ebp
  802f43:	c3                   	ret    

00802f44 <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  802f44:	55                   	push   %ebp
  802f45:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  802f47:	8b 55 0c             	mov    0xc(%ebp),%edx
  802f4a:	8b 45 08             	mov    0x8(%ebp),%eax
  802f4d:	6a 00                	push   $0x0
  802f4f:	6a 00                	push   $0x0
  802f51:	6a 00                	push   $0x0
  802f53:	52                   	push   %edx
  802f54:	50                   	push   %eax
  802f55:	6a 07                	push   $0x7
  802f57:	e8 34 ff ff ff       	call   802e90 <syscall>
  802f5c:	83 c4 18             	add    $0x18,%esp
}
  802f5f:	c9                   	leave  
  802f60:	c3                   	ret    

00802f61 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  802f61:	55                   	push   %ebp
  802f62:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  802f64:	6a 00                	push   $0x0
  802f66:	6a 00                	push   $0x0
  802f68:	6a 00                	push   $0x0
  802f6a:	ff 75 0c             	pushl  0xc(%ebp)
  802f6d:	ff 75 08             	pushl  0x8(%ebp)
  802f70:	6a 08                	push   $0x8
  802f72:	e8 19 ff ff ff       	call   802e90 <syscall>
  802f77:	83 c4 18             	add    $0x18,%esp
}
  802f7a:	c9                   	leave  
  802f7b:	c3                   	ret    

00802f7c <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  802f7c:	55                   	push   %ebp
  802f7d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  802f7f:	6a 00                	push   $0x0
  802f81:	6a 00                	push   $0x0
  802f83:	6a 00                	push   $0x0
  802f85:	6a 00                	push   $0x0
  802f87:	6a 00                	push   $0x0
  802f89:	6a 09                	push   $0x9
  802f8b:	e8 00 ff ff ff       	call   802e90 <syscall>
  802f90:	83 c4 18             	add    $0x18,%esp
}
  802f93:	c9                   	leave  
  802f94:	c3                   	ret    

00802f95 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  802f95:	55                   	push   %ebp
  802f96:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  802f98:	6a 00                	push   $0x0
  802f9a:	6a 00                	push   $0x0
  802f9c:	6a 00                	push   $0x0
  802f9e:	6a 00                	push   $0x0
  802fa0:	6a 00                	push   $0x0
  802fa2:	6a 0a                	push   $0xa
  802fa4:	e8 e7 fe ff ff       	call   802e90 <syscall>
  802fa9:	83 c4 18             	add    $0x18,%esp
}
  802fac:	c9                   	leave  
  802fad:	c3                   	ret    

00802fae <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  802fae:	55                   	push   %ebp
  802faf:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  802fb1:	6a 00                	push   $0x0
  802fb3:	6a 00                	push   $0x0
  802fb5:	6a 00                	push   $0x0
  802fb7:	6a 00                	push   $0x0
  802fb9:	6a 00                	push   $0x0
  802fbb:	6a 0b                	push   $0xb
  802fbd:	e8 ce fe ff ff       	call   802e90 <syscall>
  802fc2:	83 c4 18             	add    $0x18,%esp
}
  802fc5:	c9                   	leave  
  802fc6:	c3                   	ret    

00802fc7 <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  802fc7:	55                   	push   %ebp
  802fc8:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  802fca:	6a 00                	push   $0x0
  802fcc:	6a 00                	push   $0x0
  802fce:	6a 00                	push   $0x0
  802fd0:	ff 75 0c             	pushl  0xc(%ebp)
  802fd3:	ff 75 08             	pushl  0x8(%ebp)
  802fd6:	6a 0f                	push   $0xf
  802fd8:	e8 b3 fe ff ff       	call   802e90 <syscall>
  802fdd:	83 c4 18             	add    $0x18,%esp
	return;
  802fe0:	90                   	nop
}
  802fe1:	c9                   	leave  
  802fe2:	c3                   	ret    

00802fe3 <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  802fe3:	55                   	push   %ebp
  802fe4:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  802fe6:	6a 00                	push   $0x0
  802fe8:	6a 00                	push   $0x0
  802fea:	6a 00                	push   $0x0
  802fec:	ff 75 0c             	pushl  0xc(%ebp)
  802fef:	ff 75 08             	pushl  0x8(%ebp)
  802ff2:	6a 10                	push   $0x10
  802ff4:	e8 97 fe ff ff       	call   802e90 <syscall>
  802ff9:	83 c4 18             	add    $0x18,%esp
	return ;
  802ffc:	90                   	nop
}
  802ffd:	c9                   	leave  
  802ffe:	c3                   	ret    

00802fff <sys_allocate_chunk>:

void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  802fff:	55                   	push   %ebp
  803000:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  803002:	6a 00                	push   $0x0
  803004:	6a 00                	push   $0x0
  803006:	ff 75 10             	pushl  0x10(%ebp)
  803009:	ff 75 0c             	pushl  0xc(%ebp)
  80300c:	ff 75 08             	pushl  0x8(%ebp)
  80300f:	6a 11                	push   $0x11
  803011:	e8 7a fe ff ff       	call   802e90 <syscall>
  803016:	83 c4 18             	add    $0x18,%esp
	return ;
  803019:	90                   	nop
}
  80301a:	c9                   	leave  
  80301b:	c3                   	ret    

0080301c <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  80301c:	55                   	push   %ebp
  80301d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  80301f:	6a 00                	push   $0x0
  803021:	6a 00                	push   $0x0
  803023:	6a 00                	push   $0x0
  803025:	6a 00                	push   $0x0
  803027:	6a 00                	push   $0x0
  803029:	6a 0c                	push   $0xc
  80302b:	e8 60 fe ff ff       	call   802e90 <syscall>
  803030:	83 c4 18             	add    $0x18,%esp
}
  803033:	c9                   	leave  
  803034:	c3                   	ret    

00803035 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  803035:	55                   	push   %ebp
  803036:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  803038:	6a 00                	push   $0x0
  80303a:	6a 00                	push   $0x0
  80303c:	6a 00                	push   $0x0
  80303e:	6a 00                	push   $0x0
  803040:	ff 75 08             	pushl  0x8(%ebp)
  803043:	6a 0d                	push   $0xd
  803045:	e8 46 fe ff ff       	call   802e90 <syscall>
  80304a:	83 c4 18             	add    $0x18,%esp
}
  80304d:	c9                   	leave  
  80304e:	c3                   	ret    

0080304f <sys_scarce_memory>:

void sys_scarce_memory()
{
  80304f:	55                   	push   %ebp
  803050:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  803052:	6a 00                	push   $0x0
  803054:	6a 00                	push   $0x0
  803056:	6a 00                	push   $0x0
  803058:	6a 00                	push   $0x0
  80305a:	6a 00                	push   $0x0
  80305c:	6a 0e                	push   $0xe
  80305e:	e8 2d fe ff ff       	call   802e90 <syscall>
  803063:	83 c4 18             	add    $0x18,%esp
}
  803066:	90                   	nop
  803067:	c9                   	leave  
  803068:	c3                   	ret    

00803069 <sys_disable_interrupt>:

//NEW !! 2012...
void
sys_disable_interrupt()
{
  803069:	55                   	push   %ebp
  80306a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_disableINTR,0, 0, 0, 0, 0);
  80306c:	6a 00                	push   $0x0
  80306e:	6a 00                	push   $0x0
  803070:	6a 00                	push   $0x0
  803072:	6a 00                	push   $0x0
  803074:	6a 00                	push   $0x0
  803076:	6a 13                	push   $0x13
  803078:	e8 13 fe ff ff       	call   802e90 <syscall>
  80307d:	83 c4 18             	add    $0x18,%esp
}
  803080:	90                   	nop
  803081:	c9                   	leave  
  803082:	c3                   	ret    

00803083 <sys_enable_interrupt>:


void
sys_enable_interrupt()
{
  803083:	55                   	push   %ebp
  803084:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enableINTR,0, 0, 0, 0, 0);
  803086:	6a 00                	push   $0x0
  803088:	6a 00                	push   $0x0
  80308a:	6a 00                	push   $0x0
  80308c:	6a 00                	push   $0x0
  80308e:	6a 00                	push   $0x0
  803090:	6a 14                	push   $0x14
  803092:	e8 f9 fd ff ff       	call   802e90 <syscall>
  803097:	83 c4 18             	add    $0x18,%esp
}
  80309a:	90                   	nop
  80309b:	c9                   	leave  
  80309c:	c3                   	ret    

0080309d <sys_cputc>:


void
sys_cputc(const char c)
{
  80309d:	55                   	push   %ebp
  80309e:	89 e5                	mov    %esp,%ebp
  8030a0:	83 ec 04             	sub    $0x4,%esp
  8030a3:	8b 45 08             	mov    0x8(%ebp),%eax
  8030a6:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  8030a9:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  8030ad:	6a 00                	push   $0x0
  8030af:	6a 00                	push   $0x0
  8030b1:	6a 00                	push   $0x0
  8030b3:	6a 00                	push   $0x0
  8030b5:	50                   	push   %eax
  8030b6:	6a 15                	push   $0x15
  8030b8:	e8 d3 fd ff ff       	call   802e90 <syscall>
  8030bd:	83 c4 18             	add    $0x18,%esp
}
  8030c0:	90                   	nop
  8030c1:	c9                   	leave  
  8030c2:	c3                   	ret    

008030c3 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  8030c3:	55                   	push   %ebp
  8030c4:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  8030c6:	6a 00                	push   $0x0
  8030c8:	6a 00                	push   $0x0
  8030ca:	6a 00                	push   $0x0
  8030cc:	6a 00                	push   $0x0
  8030ce:	6a 00                	push   $0x0
  8030d0:	6a 16                	push   $0x16
  8030d2:	e8 b9 fd ff ff       	call   802e90 <syscall>
  8030d7:	83 c4 18             	add    $0x18,%esp
}
  8030da:	90                   	nop
  8030db:	c9                   	leave  
  8030dc:	c3                   	ret    

008030dd <sys_createSemaphore>:

int
sys_createSemaphore(char* semaphoreName, uint32 initialValue)
{
  8030dd:	55                   	push   %ebp
  8030de:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_semaphore,(uint32)semaphoreName, (uint32)initialValue, 0, 0, 0);
  8030e0:	8b 45 08             	mov    0x8(%ebp),%eax
  8030e3:	6a 00                	push   $0x0
  8030e5:	6a 00                	push   $0x0
  8030e7:	6a 00                	push   $0x0
  8030e9:	ff 75 0c             	pushl  0xc(%ebp)
  8030ec:	50                   	push   %eax
  8030ed:	6a 17                	push   $0x17
  8030ef:	e8 9c fd ff ff       	call   802e90 <syscall>
  8030f4:	83 c4 18             	add    $0x18,%esp
}
  8030f7:	c9                   	leave  
  8030f8:	c3                   	ret    

008030f9 <sys_getSemaphoreValue>:

int
sys_getSemaphoreValue(int32 ownerEnvID, char* semaphoreName)
{
  8030f9:	55                   	push   %ebp
  8030fa:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_semaphore_value,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  8030fc:	8b 55 0c             	mov    0xc(%ebp),%edx
  8030ff:	8b 45 08             	mov    0x8(%ebp),%eax
  803102:	6a 00                	push   $0x0
  803104:	6a 00                	push   $0x0
  803106:	6a 00                	push   $0x0
  803108:	52                   	push   %edx
  803109:	50                   	push   %eax
  80310a:	6a 1a                	push   $0x1a
  80310c:	e8 7f fd ff ff       	call   802e90 <syscall>
  803111:	83 c4 18             	add    $0x18,%esp
}
  803114:	c9                   	leave  
  803115:	c3                   	ret    

00803116 <sys_waitSemaphore>:

void
sys_waitSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  803116:	55                   	push   %ebp
  803117:	89 e5                	mov    %esp,%ebp
	syscall(SYS_wait_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  803119:	8b 55 0c             	mov    0xc(%ebp),%edx
  80311c:	8b 45 08             	mov    0x8(%ebp),%eax
  80311f:	6a 00                	push   $0x0
  803121:	6a 00                	push   $0x0
  803123:	6a 00                	push   $0x0
  803125:	52                   	push   %edx
  803126:	50                   	push   %eax
  803127:	6a 18                	push   $0x18
  803129:	e8 62 fd ff ff       	call   802e90 <syscall>
  80312e:	83 c4 18             	add    $0x18,%esp
}
  803131:	90                   	nop
  803132:	c9                   	leave  
  803133:	c3                   	ret    

00803134 <sys_signalSemaphore>:

void
sys_signalSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  803134:	55                   	push   %ebp
  803135:	89 e5                	mov    %esp,%ebp
	syscall(SYS_signal_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  803137:	8b 55 0c             	mov    0xc(%ebp),%edx
  80313a:	8b 45 08             	mov    0x8(%ebp),%eax
  80313d:	6a 00                	push   $0x0
  80313f:	6a 00                	push   $0x0
  803141:	6a 00                	push   $0x0
  803143:	52                   	push   %edx
  803144:	50                   	push   %eax
  803145:	6a 19                	push   $0x19
  803147:	e8 44 fd ff ff       	call   802e90 <syscall>
  80314c:	83 c4 18             	add    $0x18,%esp
}
  80314f:	90                   	nop
  803150:	c9                   	leave  
  803151:	c3                   	ret    

00803152 <sys_createSharedObject>:

int
sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  803152:	55                   	push   %ebp
  803153:	89 e5                	mov    %esp,%ebp
  803155:	83 ec 04             	sub    $0x4,%esp
  803158:	8b 45 10             	mov    0x10(%ebp),%eax
  80315b:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  80315e:	8b 4d 14             	mov    0x14(%ebp),%ecx
  803161:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  803165:	8b 45 08             	mov    0x8(%ebp),%eax
  803168:	6a 00                	push   $0x0
  80316a:	51                   	push   %ecx
  80316b:	52                   	push   %edx
  80316c:	ff 75 0c             	pushl  0xc(%ebp)
  80316f:	50                   	push   %eax
  803170:	6a 1b                	push   $0x1b
  803172:	e8 19 fd ff ff       	call   802e90 <syscall>
  803177:	83 c4 18             	add    $0x18,%esp
}
  80317a:	c9                   	leave  
  80317b:	c3                   	ret    

0080317c <sys_getSizeOfSharedObject>:

//2017:
int
sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  80317c:	55                   	push   %ebp
  80317d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  80317f:	8b 55 0c             	mov    0xc(%ebp),%edx
  803182:	8b 45 08             	mov    0x8(%ebp),%eax
  803185:	6a 00                	push   $0x0
  803187:	6a 00                	push   $0x0
  803189:	6a 00                	push   $0x0
  80318b:	52                   	push   %edx
  80318c:	50                   	push   %eax
  80318d:	6a 1c                	push   $0x1c
  80318f:	e8 fc fc ff ff       	call   802e90 <syscall>
  803194:	83 c4 18             	add    $0x18,%esp
}
  803197:	c9                   	leave  
  803198:	c3                   	ret    

00803199 <sys_getSharedObject>:
//==========

int
sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  803199:	55                   	push   %ebp
  80319a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  80319c:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80319f:	8b 55 0c             	mov    0xc(%ebp),%edx
  8031a2:	8b 45 08             	mov    0x8(%ebp),%eax
  8031a5:	6a 00                	push   $0x0
  8031a7:	6a 00                	push   $0x0
  8031a9:	51                   	push   %ecx
  8031aa:	52                   	push   %edx
  8031ab:	50                   	push   %eax
  8031ac:	6a 1d                	push   $0x1d
  8031ae:	e8 dd fc ff ff       	call   802e90 <syscall>
  8031b3:	83 c4 18             	add    $0x18,%esp
}
  8031b6:	c9                   	leave  
  8031b7:	c3                   	ret    

008031b8 <sys_freeSharedObject>:

int
sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  8031b8:	55                   	push   %ebp
  8031b9:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  8031bb:	8b 55 0c             	mov    0xc(%ebp),%edx
  8031be:	8b 45 08             	mov    0x8(%ebp),%eax
  8031c1:	6a 00                	push   $0x0
  8031c3:	6a 00                	push   $0x0
  8031c5:	6a 00                	push   $0x0
  8031c7:	52                   	push   %edx
  8031c8:	50                   	push   %eax
  8031c9:	6a 1e                	push   $0x1e
  8031cb:	e8 c0 fc ff ff       	call   802e90 <syscall>
  8031d0:	83 c4 18             	add    $0x18,%esp
}
  8031d3:	c9                   	leave  
  8031d4:	c3                   	ret    

008031d5 <sys_getMaxShares>:

uint32 	sys_getMaxShares()
{
  8031d5:	55                   	push   %ebp
  8031d6:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_max_shares,0, 0, 0, 0, 0);
  8031d8:	6a 00                	push   $0x0
  8031da:	6a 00                	push   $0x0
  8031dc:	6a 00                	push   $0x0
  8031de:	6a 00                	push   $0x0
  8031e0:	6a 00                	push   $0x0
  8031e2:	6a 1f                	push   $0x1f
  8031e4:	e8 a7 fc ff ff       	call   802e90 <syscall>
  8031e9:	83 c4 18             	add    $0x18,%esp
}
  8031ec:	c9                   	leave  
  8031ed:	c3                   	ret    

008031ee <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  8031ee:	55                   	push   %ebp
  8031ef:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  8031f1:	8b 45 08             	mov    0x8(%ebp),%eax
  8031f4:	6a 00                	push   $0x0
  8031f6:	ff 75 14             	pushl  0x14(%ebp)
  8031f9:	ff 75 10             	pushl  0x10(%ebp)
  8031fc:	ff 75 0c             	pushl  0xc(%ebp)
  8031ff:	50                   	push   %eax
  803200:	6a 20                	push   $0x20
  803202:	e8 89 fc ff ff       	call   802e90 <syscall>
  803207:	83 c4 18             	add    $0x18,%esp
}
  80320a:	c9                   	leave  
  80320b:	c3                   	ret    

0080320c <sys_run_env>:

void
sys_run_env(int32 envId)
{
  80320c:	55                   	push   %ebp
  80320d:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  80320f:	8b 45 08             	mov    0x8(%ebp),%eax
  803212:	6a 00                	push   $0x0
  803214:	6a 00                	push   $0x0
  803216:	6a 00                	push   $0x0
  803218:	6a 00                	push   $0x0
  80321a:	50                   	push   %eax
  80321b:	6a 21                	push   $0x21
  80321d:	e8 6e fc ff ff       	call   802e90 <syscall>
  803222:	83 c4 18             	add    $0x18,%esp
}
  803225:	90                   	nop
  803226:	c9                   	leave  
  803227:	c3                   	ret    

00803228 <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  803228:	55                   	push   %ebp
  803229:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  80322b:	8b 45 08             	mov    0x8(%ebp),%eax
  80322e:	6a 00                	push   $0x0
  803230:	6a 00                	push   $0x0
  803232:	6a 00                	push   $0x0
  803234:	6a 00                	push   $0x0
  803236:	50                   	push   %eax
  803237:	6a 22                	push   $0x22
  803239:	e8 52 fc ff ff       	call   802e90 <syscall>
  80323e:	83 c4 18             	add    $0x18,%esp
}
  803241:	c9                   	leave  
  803242:	c3                   	ret    

00803243 <sys_getenvid>:

int32 sys_getenvid(void)
{
  803243:	55                   	push   %ebp
  803244:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  803246:	6a 00                	push   $0x0
  803248:	6a 00                	push   $0x0
  80324a:	6a 00                	push   $0x0
  80324c:	6a 00                	push   $0x0
  80324e:	6a 00                	push   $0x0
  803250:	6a 02                	push   $0x2
  803252:	e8 39 fc ff ff       	call   802e90 <syscall>
  803257:	83 c4 18             	add    $0x18,%esp
}
  80325a:	c9                   	leave  
  80325b:	c3                   	ret    

0080325c <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  80325c:	55                   	push   %ebp
  80325d:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  80325f:	6a 00                	push   $0x0
  803261:	6a 00                	push   $0x0
  803263:	6a 00                	push   $0x0
  803265:	6a 00                	push   $0x0
  803267:	6a 00                	push   $0x0
  803269:	6a 03                	push   $0x3
  80326b:	e8 20 fc ff ff       	call   802e90 <syscall>
  803270:	83 c4 18             	add    $0x18,%esp
}
  803273:	c9                   	leave  
  803274:	c3                   	ret    

00803275 <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  803275:	55                   	push   %ebp
  803276:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  803278:	6a 00                	push   $0x0
  80327a:	6a 00                	push   $0x0
  80327c:	6a 00                	push   $0x0
  80327e:	6a 00                	push   $0x0
  803280:	6a 00                	push   $0x0
  803282:	6a 04                	push   $0x4
  803284:	e8 07 fc ff ff       	call   802e90 <syscall>
  803289:	83 c4 18             	add    $0x18,%esp
}
  80328c:	c9                   	leave  
  80328d:	c3                   	ret    

0080328e <sys_exit_env>:


void sys_exit_env(void)
{
  80328e:	55                   	push   %ebp
  80328f:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  803291:	6a 00                	push   $0x0
  803293:	6a 00                	push   $0x0
  803295:	6a 00                	push   $0x0
  803297:	6a 00                	push   $0x0
  803299:	6a 00                	push   $0x0
  80329b:	6a 23                	push   $0x23
  80329d:	e8 ee fb ff ff       	call   802e90 <syscall>
  8032a2:	83 c4 18             	add    $0x18,%esp
}
  8032a5:	90                   	nop
  8032a6:	c9                   	leave  
  8032a7:	c3                   	ret    

008032a8 <sys_get_virtual_time>:


struct uint64
sys_get_virtual_time()
{
  8032a8:	55                   	push   %ebp
  8032a9:	89 e5                	mov    %esp,%ebp
  8032ab:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  8032ae:	8d 45 f8             	lea    -0x8(%ebp),%eax
  8032b1:	8d 50 04             	lea    0x4(%eax),%edx
  8032b4:	8d 45 f8             	lea    -0x8(%ebp),%eax
  8032b7:	6a 00                	push   $0x0
  8032b9:	6a 00                	push   $0x0
  8032bb:	6a 00                	push   $0x0
  8032bd:	52                   	push   %edx
  8032be:	50                   	push   %eax
  8032bf:	6a 24                	push   $0x24
  8032c1:	e8 ca fb ff ff       	call   802e90 <syscall>
  8032c6:	83 c4 18             	add    $0x18,%esp
	return result;
  8032c9:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8032cc:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8032cf:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8032d2:	89 01                	mov    %eax,(%ecx)
  8032d4:	89 51 04             	mov    %edx,0x4(%ecx)
}
  8032d7:	8b 45 08             	mov    0x8(%ebp),%eax
  8032da:	c9                   	leave  
  8032db:	c2 04 00             	ret    $0x4

008032de <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  8032de:	55                   	push   %ebp
  8032df:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  8032e1:	6a 00                	push   $0x0
  8032e3:	6a 00                	push   $0x0
  8032e5:	ff 75 10             	pushl  0x10(%ebp)
  8032e8:	ff 75 0c             	pushl  0xc(%ebp)
  8032eb:	ff 75 08             	pushl  0x8(%ebp)
  8032ee:	6a 12                	push   $0x12
  8032f0:	e8 9b fb ff ff       	call   802e90 <syscall>
  8032f5:	83 c4 18             	add    $0x18,%esp
	return ;
  8032f8:	90                   	nop
}
  8032f9:	c9                   	leave  
  8032fa:	c3                   	ret    

008032fb <sys_rcr2>:
uint32 sys_rcr2()
{
  8032fb:	55                   	push   %ebp
  8032fc:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  8032fe:	6a 00                	push   $0x0
  803300:	6a 00                	push   $0x0
  803302:	6a 00                	push   $0x0
  803304:	6a 00                	push   $0x0
  803306:	6a 00                	push   $0x0
  803308:	6a 25                	push   $0x25
  80330a:	e8 81 fb ff ff       	call   802e90 <syscall>
  80330f:	83 c4 18             	add    $0x18,%esp
}
  803312:	c9                   	leave  
  803313:	c3                   	ret    

00803314 <sys_bypassPageFault>:
void sys_bypassPageFault(uint8 instrLength)
{
  803314:	55                   	push   %ebp
  803315:	89 e5                	mov    %esp,%ebp
  803317:	83 ec 04             	sub    $0x4,%esp
  80331a:	8b 45 08             	mov    0x8(%ebp),%eax
  80331d:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  803320:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  803324:	6a 00                	push   $0x0
  803326:	6a 00                	push   $0x0
  803328:	6a 00                	push   $0x0
  80332a:	6a 00                	push   $0x0
  80332c:	50                   	push   %eax
  80332d:	6a 26                	push   $0x26
  80332f:	e8 5c fb ff ff       	call   802e90 <syscall>
  803334:	83 c4 18             	add    $0x18,%esp
	return ;
  803337:	90                   	nop
}
  803338:	c9                   	leave  
  803339:	c3                   	ret    

0080333a <rsttst>:
void rsttst()
{
  80333a:	55                   	push   %ebp
  80333b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  80333d:	6a 00                	push   $0x0
  80333f:	6a 00                	push   $0x0
  803341:	6a 00                	push   $0x0
  803343:	6a 00                	push   $0x0
  803345:	6a 00                	push   $0x0
  803347:	6a 28                	push   $0x28
  803349:	e8 42 fb ff ff       	call   802e90 <syscall>
  80334e:	83 c4 18             	add    $0x18,%esp
	return ;
  803351:	90                   	nop
}
  803352:	c9                   	leave  
  803353:	c3                   	ret    

00803354 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  803354:	55                   	push   %ebp
  803355:	89 e5                	mov    %esp,%ebp
  803357:	83 ec 04             	sub    $0x4,%esp
  80335a:	8b 45 14             	mov    0x14(%ebp),%eax
  80335d:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  803360:	8b 55 18             	mov    0x18(%ebp),%edx
  803363:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  803367:	52                   	push   %edx
  803368:	50                   	push   %eax
  803369:	ff 75 10             	pushl  0x10(%ebp)
  80336c:	ff 75 0c             	pushl  0xc(%ebp)
  80336f:	ff 75 08             	pushl  0x8(%ebp)
  803372:	6a 27                	push   $0x27
  803374:	e8 17 fb ff ff       	call   802e90 <syscall>
  803379:	83 c4 18             	add    $0x18,%esp
	return ;
  80337c:	90                   	nop
}
  80337d:	c9                   	leave  
  80337e:	c3                   	ret    

0080337f <chktst>:
void chktst(uint32 n)
{
  80337f:	55                   	push   %ebp
  803380:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  803382:	6a 00                	push   $0x0
  803384:	6a 00                	push   $0x0
  803386:	6a 00                	push   $0x0
  803388:	6a 00                	push   $0x0
  80338a:	ff 75 08             	pushl  0x8(%ebp)
  80338d:	6a 29                	push   $0x29
  80338f:	e8 fc fa ff ff       	call   802e90 <syscall>
  803394:	83 c4 18             	add    $0x18,%esp
	return ;
  803397:	90                   	nop
}
  803398:	c9                   	leave  
  803399:	c3                   	ret    

0080339a <inctst>:

void inctst()
{
  80339a:	55                   	push   %ebp
  80339b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  80339d:	6a 00                	push   $0x0
  80339f:	6a 00                	push   $0x0
  8033a1:	6a 00                	push   $0x0
  8033a3:	6a 00                	push   $0x0
  8033a5:	6a 00                	push   $0x0
  8033a7:	6a 2a                	push   $0x2a
  8033a9:	e8 e2 fa ff ff       	call   802e90 <syscall>
  8033ae:	83 c4 18             	add    $0x18,%esp
	return ;
  8033b1:	90                   	nop
}
  8033b2:	c9                   	leave  
  8033b3:	c3                   	ret    

008033b4 <gettst>:
uint32 gettst()
{
  8033b4:	55                   	push   %ebp
  8033b5:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  8033b7:	6a 00                	push   $0x0
  8033b9:	6a 00                	push   $0x0
  8033bb:	6a 00                	push   $0x0
  8033bd:	6a 00                	push   $0x0
  8033bf:	6a 00                	push   $0x0
  8033c1:	6a 2b                	push   $0x2b
  8033c3:	e8 c8 fa ff ff       	call   802e90 <syscall>
  8033c8:	83 c4 18             	add    $0x18,%esp
}
  8033cb:	c9                   	leave  
  8033cc:	c3                   	ret    

008033cd <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  8033cd:	55                   	push   %ebp
  8033ce:	89 e5                	mov    %esp,%ebp
  8033d0:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8033d3:	6a 00                	push   $0x0
  8033d5:	6a 00                	push   $0x0
  8033d7:	6a 00                	push   $0x0
  8033d9:	6a 00                	push   $0x0
  8033db:	6a 00                	push   $0x0
  8033dd:	6a 2c                	push   $0x2c
  8033df:	e8 ac fa ff ff       	call   802e90 <syscall>
  8033e4:	83 c4 18             	add    $0x18,%esp
  8033e7:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  8033ea:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  8033ee:	75 07                	jne    8033f7 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  8033f0:	b8 01 00 00 00       	mov    $0x1,%eax
  8033f5:	eb 05                	jmp    8033fc <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  8033f7:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8033fc:	c9                   	leave  
  8033fd:	c3                   	ret    

008033fe <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  8033fe:	55                   	push   %ebp
  8033ff:	89 e5                	mov    %esp,%ebp
  803401:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  803404:	6a 00                	push   $0x0
  803406:	6a 00                	push   $0x0
  803408:	6a 00                	push   $0x0
  80340a:	6a 00                	push   $0x0
  80340c:	6a 00                	push   $0x0
  80340e:	6a 2c                	push   $0x2c
  803410:	e8 7b fa ff ff       	call   802e90 <syscall>
  803415:	83 c4 18             	add    $0x18,%esp
  803418:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  80341b:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  80341f:	75 07                	jne    803428 <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  803421:	b8 01 00 00 00       	mov    $0x1,%eax
  803426:	eb 05                	jmp    80342d <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  803428:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80342d:	c9                   	leave  
  80342e:	c3                   	ret    

0080342f <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  80342f:	55                   	push   %ebp
  803430:	89 e5                	mov    %esp,%ebp
  803432:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  803435:	6a 00                	push   $0x0
  803437:	6a 00                	push   $0x0
  803439:	6a 00                	push   $0x0
  80343b:	6a 00                	push   $0x0
  80343d:	6a 00                	push   $0x0
  80343f:	6a 2c                	push   $0x2c
  803441:	e8 4a fa ff ff       	call   802e90 <syscall>
  803446:	83 c4 18             	add    $0x18,%esp
  803449:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  80344c:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  803450:	75 07                	jne    803459 <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  803452:	b8 01 00 00 00       	mov    $0x1,%eax
  803457:	eb 05                	jmp    80345e <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  803459:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80345e:	c9                   	leave  
  80345f:	c3                   	ret    

00803460 <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  803460:	55                   	push   %ebp
  803461:	89 e5                	mov    %esp,%ebp
  803463:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  803466:	6a 00                	push   $0x0
  803468:	6a 00                	push   $0x0
  80346a:	6a 00                	push   $0x0
  80346c:	6a 00                	push   $0x0
  80346e:	6a 00                	push   $0x0
  803470:	6a 2c                	push   $0x2c
  803472:	e8 19 fa ff ff       	call   802e90 <syscall>
  803477:	83 c4 18             	add    $0x18,%esp
  80347a:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  80347d:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  803481:	75 07                	jne    80348a <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  803483:	b8 01 00 00 00       	mov    $0x1,%eax
  803488:	eb 05                	jmp    80348f <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  80348a:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80348f:	c9                   	leave  
  803490:	c3                   	ret    

00803491 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  803491:	55                   	push   %ebp
  803492:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  803494:	6a 00                	push   $0x0
  803496:	6a 00                	push   $0x0
  803498:	6a 00                	push   $0x0
  80349a:	6a 00                	push   $0x0
  80349c:	ff 75 08             	pushl  0x8(%ebp)
  80349f:	6a 2d                	push   $0x2d
  8034a1:	e8 ea f9 ff ff       	call   802e90 <syscall>
  8034a6:	83 c4 18             	add    $0x18,%esp
	return ;
  8034a9:	90                   	nop
}
  8034aa:	c9                   	leave  
  8034ab:	c3                   	ret    

008034ac <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  8034ac:	55                   	push   %ebp
  8034ad:	89 e5                	mov    %esp,%ebp
  8034af:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  8034b0:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8034b3:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8034b6:	8b 55 0c             	mov    0xc(%ebp),%edx
  8034b9:	8b 45 08             	mov    0x8(%ebp),%eax
  8034bc:	6a 00                	push   $0x0
  8034be:	53                   	push   %ebx
  8034bf:	51                   	push   %ecx
  8034c0:	52                   	push   %edx
  8034c1:	50                   	push   %eax
  8034c2:	6a 2e                	push   $0x2e
  8034c4:	e8 c7 f9 ff ff       	call   802e90 <syscall>
  8034c9:	83 c4 18             	add    $0x18,%esp
}
  8034cc:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8034cf:	c9                   	leave  
  8034d0:	c3                   	ret    

008034d1 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  8034d1:	55                   	push   %ebp
  8034d2:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  8034d4:	8b 55 0c             	mov    0xc(%ebp),%edx
  8034d7:	8b 45 08             	mov    0x8(%ebp),%eax
  8034da:	6a 00                	push   $0x0
  8034dc:	6a 00                	push   $0x0
  8034de:	6a 00                	push   $0x0
  8034e0:	52                   	push   %edx
  8034e1:	50                   	push   %eax
  8034e2:	6a 2f                	push   $0x2f
  8034e4:	e8 a7 f9 ff ff       	call   802e90 <syscall>
  8034e9:	83 c4 18             	add    $0x18,%esp
}
  8034ec:	c9                   	leave  
  8034ed:	c3                   	ret    

008034ee <print_mem_block_lists>:
//===========================
// PRINT MEM BLOCK LISTS:
//===========================

void print_mem_block_lists()
{
  8034ee:	55                   	push   %ebp
  8034ef:	89 e5                	mov    %esp,%ebp
  8034f1:	83 ec 18             	sub    $0x18,%esp
	cprintf("\n=========================================\n");
  8034f4:	83 ec 0c             	sub    $0xc,%esp
  8034f7:	68 20 50 80 00       	push   $0x805020
  8034fc:	e8 dd e6 ff ff       	call   801bde <cprintf>
  803501:	83 c4 10             	add    $0x10,%esp
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
  803504:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nFreeMemBlocksList:\n");
  80350b:	83 ec 0c             	sub    $0xc,%esp
  80350e:	68 4c 50 80 00       	push   $0x80504c
  803513:	e8 c6 e6 ff ff       	call   801bde <cprintf>
  803518:	83 c4 10             	add    $0x10,%esp
	uint8 sorted = 1 ;
  80351b:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &FreeMemBlocksList)
  80351f:	a1 38 61 80 00       	mov    0x806138,%eax
  803524:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803527:	eb 56                	jmp    80357f <print_mem_block_lists+0x91>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  803529:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80352d:	74 1c                	je     80354b <print_mem_block_lists+0x5d>
  80352f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803532:	8b 50 08             	mov    0x8(%eax),%edx
  803535:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803538:	8b 48 08             	mov    0x8(%eax),%ecx
  80353b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80353e:	8b 40 0c             	mov    0xc(%eax),%eax
  803541:	01 c8                	add    %ecx,%eax
  803543:	39 c2                	cmp    %eax,%edx
  803545:	73 04                	jae    80354b <print_mem_block_lists+0x5d>
			sorted = 0 ;
  803547:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  80354b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80354e:	8b 50 08             	mov    0x8(%eax),%edx
  803551:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803554:	8b 40 0c             	mov    0xc(%eax),%eax
  803557:	01 c2                	add    %eax,%edx
  803559:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80355c:	8b 40 08             	mov    0x8(%eax),%eax
  80355f:	83 ec 04             	sub    $0x4,%esp
  803562:	52                   	push   %edx
  803563:	50                   	push   %eax
  803564:	68 61 50 80 00       	push   $0x805061
  803569:	e8 70 e6 ff ff       	call   801bde <cprintf>
  80356e:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  803571:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803574:	89 45 f0             	mov    %eax,-0x10(%ebp)
	cprintf("\n=========================================\n");
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
	cprintf("\nFreeMemBlocksList:\n");
	uint8 sorted = 1 ;
	LIST_FOREACH(blk, &FreeMemBlocksList)
  803577:	a1 40 61 80 00       	mov    0x806140,%eax
  80357c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80357f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803583:	74 07                	je     80358c <print_mem_block_lists+0x9e>
  803585:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803588:	8b 00                	mov    (%eax),%eax
  80358a:	eb 05                	jmp    803591 <print_mem_block_lists+0xa3>
  80358c:	b8 00 00 00 00       	mov    $0x0,%eax
  803591:	a3 40 61 80 00       	mov    %eax,0x806140
  803596:	a1 40 61 80 00       	mov    0x806140,%eax
  80359b:	85 c0                	test   %eax,%eax
  80359d:	75 8a                	jne    803529 <print_mem_block_lists+0x3b>
  80359f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8035a3:	75 84                	jne    803529 <print_mem_block_lists+0x3b>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;
  8035a5:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  8035a9:	75 10                	jne    8035bb <print_mem_block_lists+0xcd>
  8035ab:	83 ec 0c             	sub    $0xc,%esp
  8035ae:	68 70 50 80 00       	push   $0x805070
  8035b3:	e8 26 e6 ff ff       	call   801bde <cprintf>
  8035b8:	83 c4 10             	add    $0x10,%esp

	lastBlk = NULL ;
  8035bb:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nAllocMemBlocksList:\n");
  8035c2:	83 ec 0c             	sub    $0xc,%esp
  8035c5:	68 94 50 80 00       	push   $0x805094
  8035ca:	e8 0f e6 ff ff       	call   801bde <cprintf>
  8035cf:	83 c4 10             	add    $0x10,%esp
	sorted = 1 ;
  8035d2:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &AllocMemBlocksList)
  8035d6:	a1 40 60 80 00       	mov    0x806040,%eax
  8035db:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8035de:	eb 56                	jmp    803636 <print_mem_block_lists+0x148>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  8035e0:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8035e4:	74 1c                	je     803602 <print_mem_block_lists+0x114>
  8035e6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8035e9:	8b 50 08             	mov    0x8(%eax),%edx
  8035ec:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8035ef:	8b 48 08             	mov    0x8(%eax),%ecx
  8035f2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8035f5:	8b 40 0c             	mov    0xc(%eax),%eax
  8035f8:	01 c8                	add    %ecx,%eax
  8035fa:	39 c2                	cmp    %eax,%edx
  8035fc:	73 04                	jae    803602 <print_mem_block_lists+0x114>
			sorted = 0 ;
  8035fe:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  803602:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803605:	8b 50 08             	mov    0x8(%eax),%edx
  803608:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80360b:	8b 40 0c             	mov    0xc(%eax),%eax
  80360e:	01 c2                	add    %eax,%edx
  803610:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803613:	8b 40 08             	mov    0x8(%eax),%eax
  803616:	83 ec 04             	sub    $0x4,%esp
  803619:	52                   	push   %edx
  80361a:	50                   	push   %eax
  80361b:	68 61 50 80 00       	push   $0x805061
  803620:	e8 b9 e5 ff ff       	call   801bde <cprintf>
  803625:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  803628:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80362b:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;

	lastBlk = NULL ;
	cprintf("\nAllocMemBlocksList:\n");
	sorted = 1 ;
	LIST_FOREACH(blk, &AllocMemBlocksList)
  80362e:	a1 48 60 80 00       	mov    0x806048,%eax
  803633:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803636:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80363a:	74 07                	je     803643 <print_mem_block_lists+0x155>
  80363c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80363f:	8b 00                	mov    (%eax),%eax
  803641:	eb 05                	jmp    803648 <print_mem_block_lists+0x15a>
  803643:	b8 00 00 00 00       	mov    $0x0,%eax
  803648:	a3 48 60 80 00       	mov    %eax,0x806048
  80364d:	a1 48 60 80 00       	mov    0x806048,%eax
  803652:	85 c0                	test   %eax,%eax
  803654:	75 8a                	jne    8035e0 <print_mem_block_lists+0xf2>
  803656:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80365a:	75 84                	jne    8035e0 <print_mem_block_lists+0xf2>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nAllocMemBlocksList is NOT SORTED!!\n") ;
  80365c:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  803660:	75 10                	jne    803672 <print_mem_block_lists+0x184>
  803662:	83 ec 0c             	sub    $0xc,%esp
  803665:	68 ac 50 80 00       	push   $0x8050ac
  80366a:	e8 6f e5 ff ff       	call   801bde <cprintf>
  80366f:	83 c4 10             	add    $0x10,%esp
	cprintf("\n=========================================\n");
  803672:	83 ec 0c             	sub    $0xc,%esp
  803675:	68 20 50 80 00       	push   $0x805020
  80367a:	e8 5f e5 ff ff       	call   801bde <cprintf>
  80367f:	83 c4 10             	add    $0x10,%esp

}
  803682:	90                   	nop
  803683:	c9                   	leave  
  803684:	c3                   	ret    

00803685 <initialize_MemBlocksList>:

//===============================
// [1] INITIALIZE AVAILABLE LIST:
//===============================
void initialize_MemBlocksList(uint32 numOfBlocks)
{
  803685:	55                   	push   %ebp
  803686:	89 e5                	mov    %esp,%ebp
  803688:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] initialize_MemBlocksList
	// Write your code here, remove the panic and write your code
	//panic("initialize_MemBlocksList() is not implemented yet...!!");
	uint32 n = numOfBlocks;
  80368b:	8b 45 08             	mov    0x8(%ebp),%eax
  80368e:	89 45 f0             	mov    %eax,-0x10(%ebp)

	LIST_INIT(&AvailableMemBlocksList);
  803691:	c7 05 48 61 80 00 00 	movl   $0x0,0x806148
  803698:	00 00 00 
  80369b:	c7 05 4c 61 80 00 00 	movl   $0x0,0x80614c
  8036a2:	00 00 00 
  8036a5:	c7 05 54 61 80 00 00 	movl   $0x0,0x806154
  8036ac:	00 00 00 
	for(int i = 0; i<n;i++)
  8036af:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  8036b6:	e9 9e 00 00 00       	jmp    803759 <initialize_MemBlocksList+0xd4>
	{
		LIST_INSERT_HEAD(&AvailableMemBlocksList, &(MemBlockNodes[i]));
  8036bb:	a1 50 60 80 00       	mov    0x806050,%eax
  8036c0:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8036c3:	c1 e2 04             	shl    $0x4,%edx
  8036c6:	01 d0                	add    %edx,%eax
  8036c8:	85 c0                	test   %eax,%eax
  8036ca:	75 14                	jne    8036e0 <initialize_MemBlocksList+0x5b>
  8036cc:	83 ec 04             	sub    $0x4,%esp
  8036cf:	68 d4 50 80 00       	push   $0x8050d4
  8036d4:	6a 47                	push   $0x47
  8036d6:	68 f7 50 80 00       	push   $0x8050f7
  8036db:	e8 4a e2 ff ff       	call   80192a <_panic>
  8036e0:	a1 50 60 80 00       	mov    0x806050,%eax
  8036e5:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8036e8:	c1 e2 04             	shl    $0x4,%edx
  8036eb:	01 d0                	add    %edx,%eax
  8036ed:	8b 15 48 61 80 00    	mov    0x806148,%edx
  8036f3:	89 10                	mov    %edx,(%eax)
  8036f5:	8b 00                	mov    (%eax),%eax
  8036f7:	85 c0                	test   %eax,%eax
  8036f9:	74 18                	je     803713 <initialize_MemBlocksList+0x8e>
  8036fb:	a1 48 61 80 00       	mov    0x806148,%eax
  803700:	8b 15 50 60 80 00    	mov    0x806050,%edx
  803706:	8b 4d f4             	mov    -0xc(%ebp),%ecx
  803709:	c1 e1 04             	shl    $0x4,%ecx
  80370c:	01 ca                	add    %ecx,%edx
  80370e:	89 50 04             	mov    %edx,0x4(%eax)
  803711:	eb 12                	jmp    803725 <initialize_MemBlocksList+0xa0>
  803713:	a1 50 60 80 00       	mov    0x806050,%eax
  803718:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80371b:	c1 e2 04             	shl    $0x4,%edx
  80371e:	01 d0                	add    %edx,%eax
  803720:	a3 4c 61 80 00       	mov    %eax,0x80614c
  803725:	a1 50 60 80 00       	mov    0x806050,%eax
  80372a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80372d:	c1 e2 04             	shl    $0x4,%edx
  803730:	01 d0                	add    %edx,%eax
  803732:	a3 48 61 80 00       	mov    %eax,0x806148
  803737:	a1 50 60 80 00       	mov    0x806050,%eax
  80373c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80373f:	c1 e2 04             	shl    $0x4,%edx
  803742:	01 d0                	add    %edx,%eax
  803744:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80374b:	a1 54 61 80 00       	mov    0x806154,%eax
  803750:	40                   	inc    %eax
  803751:	a3 54 61 80 00       	mov    %eax,0x806154
	// Write your code here, remove the panic and write your code
	//panic("initialize_MemBlocksList() is not implemented yet...!!");
	uint32 n = numOfBlocks;

	LIST_INIT(&AvailableMemBlocksList);
	for(int i = 0; i<n;i++)
  803756:	ff 45 f4             	incl   -0xc(%ebp)
  803759:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80375c:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80375f:	0f 82 56 ff ff ff    	jb     8036bb <initialize_MemBlocksList+0x36>
	{
		LIST_INSERT_HEAD(&AvailableMemBlocksList, &(MemBlockNodes[i]));
	}
}
  803765:	90                   	nop
  803766:	c9                   	leave  
  803767:	c3                   	ret    

00803768 <find_block>:

//===============================
// [2] FIND BLOCK:
//===============================
struct MemBlock *find_block(struct MemBlock_List *blockList, uint32 va)
{
  803768:	55                   	push   %ebp
  803769:	89 e5                	mov    %esp,%ebp
  80376b:	83 ec 10             	sub    $0x10,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] find_block
	// Write your code here, remove the panic and write your code
	//panic("find_block() is not implemented yet...!!");
	uint32 virAddress = va;
  80376e:	8b 45 0c             	mov    0xc(%ebp),%eax
  803771:	89 45 f4             	mov    %eax,-0xc(%ebp)
	struct MemBlock* blk;
	int found = 0;
  803774:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	LIST_FOREACH(blk, &(AllocMemBlocksList))
  80377b:	a1 40 60 80 00       	mov    0x806040,%eax
  803780:	89 45 fc             	mov    %eax,-0x4(%ebp)
  803783:	eb 23                	jmp    8037a8 <find_block+0x40>
	{
		if(blk->sva == virAddress)
  803785:	8b 45 fc             	mov    -0x4(%ebp),%eax
  803788:	8b 40 08             	mov    0x8(%eax),%eax
  80378b:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  80378e:	75 09                	jne    803799 <find_block+0x31>
		{
			found = 1;
  803790:	c7 45 f8 01 00 00 00 	movl   $0x1,-0x8(%ebp)
			break;
  803797:	eb 35                	jmp    8037ce <find_block+0x66>
		}
		else
		{
			found = 0;
  803799:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	//panic("find_block() is not implemented yet...!!");
	uint32 virAddress = va;
	struct MemBlock* blk;
	int found = 0;

	LIST_FOREACH(blk, &(AllocMemBlocksList))
  8037a0:	a1 48 60 80 00       	mov    0x806048,%eax
  8037a5:	89 45 fc             	mov    %eax,-0x4(%ebp)
  8037a8:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8037ac:	74 07                	je     8037b5 <find_block+0x4d>
  8037ae:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8037b1:	8b 00                	mov    (%eax),%eax
  8037b3:	eb 05                	jmp    8037ba <find_block+0x52>
  8037b5:	b8 00 00 00 00       	mov    $0x0,%eax
  8037ba:	a3 48 60 80 00       	mov    %eax,0x806048
  8037bf:	a1 48 60 80 00       	mov    0x806048,%eax
  8037c4:	85 c0                	test   %eax,%eax
  8037c6:	75 bd                	jne    803785 <find_block+0x1d>
  8037c8:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8037cc:	75 b7                	jne    803785 <find_block+0x1d>
		{
			found = 0;
			continue;
		}
	}
	if(found == 1)
  8037ce:	83 7d f8 01          	cmpl   $0x1,-0x8(%ebp)
  8037d2:	75 05                	jne    8037d9 <find_block+0x71>
	{
		return blk;
  8037d4:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8037d7:	eb 05                	jmp    8037de <find_block+0x76>
	}
	else
	{
		return NULL;
  8037d9:	b8 00 00 00 00       	mov    $0x0,%eax
	}
}
  8037de:	c9                   	leave  
  8037df:	c3                   	ret    

008037e0 <insert_sorted_allocList>:

//=========================================
// [3] INSERT BLOCK IN ALLOC LIST [SORTED]:
//=========================================
void insert_sorted_allocList(struct MemBlock *blockToInsert)
{
  8037e0:	55                   	push   %ebp
  8037e1:	89 e5                	mov    %esp,%ebp
  8037e3:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] insert_sorted_allocList
	// Write your code here, remove the panic and write your code
	//panic("insert_sorted_allocList() is not implemented yet...!!");
	struct MemBlock* blk;
	struct MemBlock* newblk = blockToInsert;
  8037e6:	8b 45 08             	mov    0x8(%ebp),%eax
  8037e9:	89 45 f0             	mov    %eax,-0x10(%ebp)

	if((LIST_EMPTY(&AllocMemBlocksList)) || (newblk->sva < LIST_FIRST(&AllocMemBlocksList)->sva))
  8037ec:	a1 40 60 80 00       	mov    0x806040,%eax
  8037f1:	85 c0                	test   %eax,%eax
  8037f3:	74 12                	je     803807 <insert_sorted_allocList+0x27>
  8037f5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8037f8:	8b 50 08             	mov    0x8(%eax),%edx
  8037fb:	a1 40 60 80 00       	mov    0x806040,%eax
  803800:	8b 40 08             	mov    0x8(%eax),%eax
  803803:	39 c2                	cmp    %eax,%edx
  803805:	73 65                	jae    80386c <insert_sorted_allocList+0x8c>
	{
		LIST_INSERT_HEAD(&(AllocMemBlocksList), newblk);
  803807:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80380b:	75 14                	jne    803821 <insert_sorted_allocList+0x41>
  80380d:	83 ec 04             	sub    $0x4,%esp
  803810:	68 d4 50 80 00       	push   $0x8050d4
  803815:	6a 7b                	push   $0x7b
  803817:	68 f7 50 80 00       	push   $0x8050f7
  80381c:	e8 09 e1 ff ff       	call   80192a <_panic>
  803821:	8b 15 40 60 80 00    	mov    0x806040,%edx
  803827:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80382a:	89 10                	mov    %edx,(%eax)
  80382c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80382f:	8b 00                	mov    (%eax),%eax
  803831:	85 c0                	test   %eax,%eax
  803833:	74 0d                	je     803842 <insert_sorted_allocList+0x62>
  803835:	a1 40 60 80 00       	mov    0x806040,%eax
  80383a:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80383d:	89 50 04             	mov    %edx,0x4(%eax)
  803840:	eb 08                	jmp    80384a <insert_sorted_allocList+0x6a>
  803842:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803845:	a3 44 60 80 00       	mov    %eax,0x806044
  80384a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80384d:	a3 40 60 80 00       	mov    %eax,0x806040
  803852:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803855:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80385c:	a1 4c 60 80 00       	mov    0x80604c,%eax
  803861:	40                   	inc    %eax
  803862:	a3 4c 60 80 00       	mov    %eax,0x80604c
  803867:	e9 5f 01 00 00       	jmp    8039cb <insert_sorted_allocList+0x1eb>
	}
	else if(newblk->sva > LIST_LAST(&AllocMemBlocksList)->sva)
  80386c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80386f:	8b 50 08             	mov    0x8(%eax),%edx
  803872:	a1 44 60 80 00       	mov    0x806044,%eax
  803877:	8b 40 08             	mov    0x8(%eax),%eax
  80387a:	39 c2                	cmp    %eax,%edx
  80387c:	76 65                	jbe    8038e3 <insert_sorted_allocList+0x103>
	{
		LIST_INSERT_TAIL(&AllocMemBlocksList, newblk);
  80387e:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  803882:	75 14                	jne    803898 <insert_sorted_allocList+0xb8>
  803884:	83 ec 04             	sub    $0x4,%esp
  803887:	68 10 51 80 00       	push   $0x805110
  80388c:	6a 7f                	push   $0x7f
  80388e:	68 f7 50 80 00       	push   $0x8050f7
  803893:	e8 92 e0 ff ff       	call   80192a <_panic>
  803898:	8b 15 44 60 80 00    	mov    0x806044,%edx
  80389e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8038a1:	89 50 04             	mov    %edx,0x4(%eax)
  8038a4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8038a7:	8b 40 04             	mov    0x4(%eax),%eax
  8038aa:	85 c0                	test   %eax,%eax
  8038ac:	74 0c                	je     8038ba <insert_sorted_allocList+0xda>
  8038ae:	a1 44 60 80 00       	mov    0x806044,%eax
  8038b3:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8038b6:	89 10                	mov    %edx,(%eax)
  8038b8:	eb 08                	jmp    8038c2 <insert_sorted_allocList+0xe2>
  8038ba:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8038bd:	a3 40 60 80 00       	mov    %eax,0x806040
  8038c2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8038c5:	a3 44 60 80 00       	mov    %eax,0x806044
  8038ca:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8038cd:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8038d3:	a1 4c 60 80 00       	mov    0x80604c,%eax
  8038d8:	40                   	inc    %eax
  8038d9:	a3 4c 60 80 00       	mov    %eax,0x80604c
				LIST_INSERT_AFTER(&AllocMemBlocksList, blk, newblk);
				break;
			}
		}
	}
}
  8038de:	e9 e8 00 00 00       	jmp    8039cb <insert_sorted_allocList+0x1eb>
	{
		LIST_INSERT_TAIL(&AllocMemBlocksList, newblk);
	}
	else
	{
		LIST_FOREACH(blk, &AllocMemBlocksList)
  8038e3:	a1 40 60 80 00       	mov    0x806040,%eax
  8038e8:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8038eb:	e9 ab 00 00 00       	jmp    80399b <insert_sorted_allocList+0x1bb>
		{
			if(blk->prev_next_info.le_next != NULL && newblk->sva > blk->sva  && newblk->sva < blk->prev_next_info.le_next->sva)
  8038f0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8038f3:	8b 00                	mov    (%eax),%eax
  8038f5:	85 c0                	test   %eax,%eax
  8038f7:	0f 84 96 00 00 00    	je     803993 <insert_sorted_allocList+0x1b3>
  8038fd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803900:	8b 50 08             	mov    0x8(%eax),%edx
  803903:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803906:	8b 40 08             	mov    0x8(%eax),%eax
  803909:	39 c2                	cmp    %eax,%edx
  80390b:	0f 86 82 00 00 00    	jbe    803993 <insert_sorted_allocList+0x1b3>
  803911:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803914:	8b 50 08             	mov    0x8(%eax),%edx
  803917:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80391a:	8b 00                	mov    (%eax),%eax
  80391c:	8b 40 08             	mov    0x8(%eax),%eax
  80391f:	39 c2                	cmp    %eax,%edx
  803921:	73 70                	jae    803993 <insert_sorted_allocList+0x1b3>
			{
				LIST_INSERT_AFTER(&AllocMemBlocksList, blk, newblk);
  803923:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803927:	74 06                	je     80392f <insert_sorted_allocList+0x14f>
  803929:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80392d:	75 17                	jne    803946 <insert_sorted_allocList+0x166>
  80392f:	83 ec 04             	sub    $0x4,%esp
  803932:	68 34 51 80 00       	push   $0x805134
  803937:	68 87 00 00 00       	push   $0x87
  80393c:	68 f7 50 80 00       	push   $0x8050f7
  803941:	e8 e4 df ff ff       	call   80192a <_panic>
  803946:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803949:	8b 10                	mov    (%eax),%edx
  80394b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80394e:	89 10                	mov    %edx,(%eax)
  803950:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803953:	8b 00                	mov    (%eax),%eax
  803955:	85 c0                	test   %eax,%eax
  803957:	74 0b                	je     803964 <insert_sorted_allocList+0x184>
  803959:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80395c:	8b 00                	mov    (%eax),%eax
  80395e:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803961:	89 50 04             	mov    %edx,0x4(%eax)
  803964:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803967:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80396a:	89 10                	mov    %edx,(%eax)
  80396c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80396f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803972:	89 50 04             	mov    %edx,0x4(%eax)
  803975:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803978:	8b 00                	mov    (%eax),%eax
  80397a:	85 c0                	test   %eax,%eax
  80397c:	75 08                	jne    803986 <insert_sorted_allocList+0x1a6>
  80397e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803981:	a3 44 60 80 00       	mov    %eax,0x806044
  803986:	a1 4c 60 80 00       	mov    0x80604c,%eax
  80398b:	40                   	inc    %eax
  80398c:	a3 4c 60 80 00       	mov    %eax,0x80604c
				break;
  803991:	eb 38                	jmp    8039cb <insert_sorted_allocList+0x1eb>
	{
		LIST_INSERT_TAIL(&AllocMemBlocksList, newblk);
	}
	else
	{
		LIST_FOREACH(blk, &AllocMemBlocksList)
  803993:	a1 48 60 80 00       	mov    0x806048,%eax
  803998:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80399b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80399f:	74 07                	je     8039a8 <insert_sorted_allocList+0x1c8>
  8039a1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8039a4:	8b 00                	mov    (%eax),%eax
  8039a6:	eb 05                	jmp    8039ad <insert_sorted_allocList+0x1cd>
  8039a8:	b8 00 00 00 00       	mov    $0x0,%eax
  8039ad:	a3 48 60 80 00       	mov    %eax,0x806048
  8039b2:	a1 48 60 80 00       	mov    0x806048,%eax
  8039b7:	85 c0                	test   %eax,%eax
  8039b9:	0f 85 31 ff ff ff    	jne    8038f0 <insert_sorted_allocList+0x110>
  8039bf:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8039c3:	0f 85 27 ff ff ff    	jne    8038f0 <insert_sorted_allocList+0x110>
				LIST_INSERT_AFTER(&AllocMemBlocksList, blk, newblk);
				break;
			}
		}
	}
}
  8039c9:	eb 00                	jmp    8039cb <insert_sorted_allocList+0x1eb>
  8039cb:	90                   	nop
  8039cc:	c9                   	leave  
  8039cd:	c3                   	ret    

008039ce <alloc_block_FF>:

//=========================================
// [4] ALLOCATE BLOCK BY FIRST FIT:
//=========================================
struct MemBlock *alloc_block_FF(uint32 size)
{
  8039ce:	55                   	push   %ebp
  8039cf:	89 e5                	mov    %esp,%ebp
  8039d1:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_FF
	// Write your code here, remove the panic and write your code
	//panic("alloc_block_FF() is not implemented yet...!!");
	uint32 versize = size;
  8039d4:	8b 45 08             	mov    0x8(%ebp),%eax
  8039d7:	89 45 f0             	mov    %eax,-0x10(%ebp)
	struct MemBlock* blk;
	struct MemBlock* newblk = LIST_FIRST(&AvailableMemBlocksList);
  8039da:	a1 48 61 80 00       	mov    0x806148,%eax
  8039df:	89 45 ec             	mov    %eax,-0x14(%ebp)

	LIST_FOREACH(blk,&FreeMemBlocksList)
  8039e2:	a1 38 61 80 00       	mov    0x806138,%eax
  8039e7:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8039ea:	e9 77 01 00 00       	jmp    803b66 <alloc_block_FF+0x198>
	{
		if(blk->size == versize)
  8039ef:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8039f2:	8b 40 0c             	mov    0xc(%eax),%eax
  8039f5:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8039f8:	0f 85 8a 00 00 00    	jne    803a88 <alloc_block_FF+0xba>
		{
			LIST_REMOVE(&FreeMemBlocksList,blk);
  8039fe:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803a02:	75 17                	jne    803a1b <alloc_block_FF+0x4d>
  803a04:	83 ec 04             	sub    $0x4,%esp
  803a07:	68 68 51 80 00       	push   $0x805168
  803a0c:	68 9e 00 00 00       	push   $0x9e
  803a11:	68 f7 50 80 00       	push   $0x8050f7
  803a16:	e8 0f df ff ff       	call   80192a <_panic>
  803a1b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803a1e:	8b 00                	mov    (%eax),%eax
  803a20:	85 c0                	test   %eax,%eax
  803a22:	74 10                	je     803a34 <alloc_block_FF+0x66>
  803a24:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803a27:	8b 00                	mov    (%eax),%eax
  803a29:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803a2c:	8b 52 04             	mov    0x4(%edx),%edx
  803a2f:	89 50 04             	mov    %edx,0x4(%eax)
  803a32:	eb 0b                	jmp    803a3f <alloc_block_FF+0x71>
  803a34:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803a37:	8b 40 04             	mov    0x4(%eax),%eax
  803a3a:	a3 3c 61 80 00       	mov    %eax,0x80613c
  803a3f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803a42:	8b 40 04             	mov    0x4(%eax),%eax
  803a45:	85 c0                	test   %eax,%eax
  803a47:	74 0f                	je     803a58 <alloc_block_FF+0x8a>
  803a49:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803a4c:	8b 40 04             	mov    0x4(%eax),%eax
  803a4f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803a52:	8b 12                	mov    (%edx),%edx
  803a54:	89 10                	mov    %edx,(%eax)
  803a56:	eb 0a                	jmp    803a62 <alloc_block_FF+0x94>
  803a58:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803a5b:	8b 00                	mov    (%eax),%eax
  803a5d:	a3 38 61 80 00       	mov    %eax,0x806138
  803a62:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803a65:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803a6b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803a6e:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803a75:	a1 44 61 80 00       	mov    0x806144,%eax
  803a7a:	48                   	dec    %eax
  803a7b:	a3 44 61 80 00       	mov    %eax,0x806144
			return blk;
  803a80:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803a83:	e9 11 01 00 00       	jmp    803b99 <alloc_block_FF+0x1cb>
		}
		else if(blk->size > versize)
  803a88:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803a8b:	8b 40 0c             	mov    0xc(%eax),%eax
  803a8e:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  803a91:	0f 86 c7 00 00 00    	jbe    803b5e <alloc_block_FF+0x190>
		{
			LIST_REMOVE(&AvailableMemBlocksList,newblk);
  803a97:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  803a9b:	75 17                	jne    803ab4 <alloc_block_FF+0xe6>
  803a9d:	83 ec 04             	sub    $0x4,%esp
  803aa0:	68 68 51 80 00       	push   $0x805168
  803aa5:	68 a3 00 00 00       	push   $0xa3
  803aaa:	68 f7 50 80 00       	push   $0x8050f7
  803aaf:	e8 76 de ff ff       	call   80192a <_panic>
  803ab4:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803ab7:	8b 00                	mov    (%eax),%eax
  803ab9:	85 c0                	test   %eax,%eax
  803abb:	74 10                	je     803acd <alloc_block_FF+0xff>
  803abd:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803ac0:	8b 00                	mov    (%eax),%eax
  803ac2:	8b 55 ec             	mov    -0x14(%ebp),%edx
  803ac5:	8b 52 04             	mov    0x4(%edx),%edx
  803ac8:	89 50 04             	mov    %edx,0x4(%eax)
  803acb:	eb 0b                	jmp    803ad8 <alloc_block_FF+0x10a>
  803acd:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803ad0:	8b 40 04             	mov    0x4(%eax),%eax
  803ad3:	a3 4c 61 80 00       	mov    %eax,0x80614c
  803ad8:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803adb:	8b 40 04             	mov    0x4(%eax),%eax
  803ade:	85 c0                	test   %eax,%eax
  803ae0:	74 0f                	je     803af1 <alloc_block_FF+0x123>
  803ae2:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803ae5:	8b 40 04             	mov    0x4(%eax),%eax
  803ae8:	8b 55 ec             	mov    -0x14(%ebp),%edx
  803aeb:	8b 12                	mov    (%edx),%edx
  803aed:	89 10                	mov    %edx,(%eax)
  803aef:	eb 0a                	jmp    803afb <alloc_block_FF+0x12d>
  803af1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803af4:	8b 00                	mov    (%eax),%eax
  803af6:	a3 48 61 80 00       	mov    %eax,0x806148
  803afb:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803afe:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803b04:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803b07:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803b0e:	a1 54 61 80 00       	mov    0x806154,%eax
  803b13:	48                   	dec    %eax
  803b14:	a3 54 61 80 00       	mov    %eax,0x806154
			newblk->size = versize;
  803b19:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803b1c:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803b1f:	89 50 0c             	mov    %edx,0xc(%eax)
			blk->size = blk->size-versize;
  803b22:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803b25:	8b 40 0c             	mov    0xc(%eax),%eax
  803b28:	2b 45 f0             	sub    -0x10(%ebp),%eax
  803b2b:	89 c2                	mov    %eax,%edx
  803b2d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803b30:	89 50 0c             	mov    %edx,0xc(%eax)
			uint32 newveradd = blk->sva;
  803b33:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803b36:	8b 40 08             	mov    0x8(%eax),%eax
  803b39:	89 45 e8             	mov    %eax,-0x18(%ebp)
			blk->sva+=newblk->size;
  803b3c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803b3f:	8b 50 08             	mov    0x8(%eax),%edx
  803b42:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803b45:	8b 40 0c             	mov    0xc(%eax),%eax
  803b48:	01 c2                	add    %eax,%edx
  803b4a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803b4d:	89 50 08             	mov    %edx,0x8(%eax)
			newblk->sva = newveradd;
  803b50:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803b53:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803b56:	89 50 08             	mov    %edx,0x8(%eax)
			return newblk;
  803b59:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803b5c:	eb 3b                	jmp    803b99 <alloc_block_FF+0x1cb>
	//panic("alloc_block_FF() is not implemented yet...!!");
	uint32 versize = size;
	struct MemBlock* blk;
	struct MemBlock* newblk = LIST_FIRST(&AvailableMemBlocksList);

	LIST_FOREACH(blk,&FreeMemBlocksList)
  803b5e:	a1 40 61 80 00       	mov    0x806140,%eax
  803b63:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803b66:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803b6a:	74 07                	je     803b73 <alloc_block_FF+0x1a5>
  803b6c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803b6f:	8b 00                	mov    (%eax),%eax
  803b71:	eb 05                	jmp    803b78 <alloc_block_FF+0x1aa>
  803b73:	b8 00 00 00 00       	mov    $0x0,%eax
  803b78:	a3 40 61 80 00       	mov    %eax,0x806140
  803b7d:	a1 40 61 80 00       	mov    0x806140,%eax
  803b82:	85 c0                	test   %eax,%eax
  803b84:	0f 85 65 fe ff ff    	jne    8039ef <alloc_block_FF+0x21>
  803b8a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803b8e:	0f 85 5b fe ff ff    	jne    8039ef <alloc_block_FF+0x21>
			blk->sva+=newblk->size;
			newblk->sva = newveradd;
			return newblk;
		}
	}
	return NULL;
  803b94:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803b99:	c9                   	leave  
  803b9a:	c3                   	ret    

00803b9b <alloc_block_BF>:

//=========================================
// [5] ALLOCATE BLOCK BY BEST FIT:
//=========================================
struct MemBlock *alloc_block_BF(uint32 size)
{
  803b9b:	55                   	push   %ebp
  803b9c:	89 e5                	mov    %esp,%ebp
  803b9e:	83 ec 28             	sub    $0x28,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_BF
	// Write your code here, remove the panic and write your code
	//panic("alloc_block_BF() is not implemented yet...!!");
	uint32 versize=size;
  803ba1:	8b 45 08             	mov    0x8(%ebp),%eax
  803ba4:	89 45 e8             	mov    %eax,-0x18(%ebp)
	struct MemBlock* blk;
	struct MemBlock* newblk=LIST_FIRST(&AvailableMemBlocksList);
  803ba7:	a1 48 61 80 00       	mov    0x806148,%eax
  803bac:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	uint32 newveradd;
	uint32 newsize;
	int size_free = LIST_SIZE(&FreeMemBlocksList);
  803baf:	a1 44 61 80 00       	mov    0x806144,%eax
  803bb4:	89 45 e0             	mov    %eax,-0x20(%ebp)

	LIST_FOREACH(blk, &FreeMemBlocksList)
  803bb7:	a1 38 61 80 00       	mov    0x806138,%eax
  803bbc:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803bbf:	e9 a1 00 00 00       	jmp    803c65 <alloc_block_BF+0xca>
	{
		if(blk->size == versize)
  803bc4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803bc7:	8b 40 0c             	mov    0xc(%eax),%eax
  803bca:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  803bcd:	0f 85 8a 00 00 00    	jne    803c5d <alloc_block_BF+0xc2>
		{
			LIST_REMOVE(&FreeMemBlocksList, blk);
  803bd3:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803bd7:	75 17                	jne    803bf0 <alloc_block_BF+0x55>
  803bd9:	83 ec 04             	sub    $0x4,%esp
  803bdc:	68 68 51 80 00       	push   $0x805168
  803be1:	68 c2 00 00 00       	push   $0xc2
  803be6:	68 f7 50 80 00       	push   $0x8050f7
  803beb:	e8 3a dd ff ff       	call   80192a <_panic>
  803bf0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803bf3:	8b 00                	mov    (%eax),%eax
  803bf5:	85 c0                	test   %eax,%eax
  803bf7:	74 10                	je     803c09 <alloc_block_BF+0x6e>
  803bf9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803bfc:	8b 00                	mov    (%eax),%eax
  803bfe:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803c01:	8b 52 04             	mov    0x4(%edx),%edx
  803c04:	89 50 04             	mov    %edx,0x4(%eax)
  803c07:	eb 0b                	jmp    803c14 <alloc_block_BF+0x79>
  803c09:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803c0c:	8b 40 04             	mov    0x4(%eax),%eax
  803c0f:	a3 3c 61 80 00       	mov    %eax,0x80613c
  803c14:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803c17:	8b 40 04             	mov    0x4(%eax),%eax
  803c1a:	85 c0                	test   %eax,%eax
  803c1c:	74 0f                	je     803c2d <alloc_block_BF+0x92>
  803c1e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803c21:	8b 40 04             	mov    0x4(%eax),%eax
  803c24:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803c27:	8b 12                	mov    (%edx),%edx
  803c29:	89 10                	mov    %edx,(%eax)
  803c2b:	eb 0a                	jmp    803c37 <alloc_block_BF+0x9c>
  803c2d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803c30:	8b 00                	mov    (%eax),%eax
  803c32:	a3 38 61 80 00       	mov    %eax,0x806138
  803c37:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803c3a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803c40:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803c43:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803c4a:	a1 44 61 80 00       	mov    0x806144,%eax
  803c4f:	48                   	dec    %eax
  803c50:	a3 44 61 80 00       	mov    %eax,0x806144
			return blk;
  803c55:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803c58:	e9 11 02 00 00       	jmp    803e6e <alloc_block_BF+0x2d3>
	struct MemBlock* newblk=LIST_FIRST(&AvailableMemBlocksList);
	uint32 newveradd;
	uint32 newsize;
	int size_free = LIST_SIZE(&FreeMemBlocksList);

	LIST_FOREACH(blk, &FreeMemBlocksList)
  803c5d:	a1 40 61 80 00       	mov    0x806140,%eax
  803c62:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803c65:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803c69:	74 07                	je     803c72 <alloc_block_BF+0xd7>
  803c6b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803c6e:	8b 00                	mov    (%eax),%eax
  803c70:	eb 05                	jmp    803c77 <alloc_block_BF+0xdc>
  803c72:	b8 00 00 00 00       	mov    $0x0,%eax
  803c77:	a3 40 61 80 00       	mov    %eax,0x806140
  803c7c:	a1 40 61 80 00       	mov    0x806140,%eax
  803c81:	85 c0                	test   %eax,%eax
  803c83:	0f 85 3b ff ff ff    	jne    803bc4 <alloc_block_BF+0x29>
  803c89:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803c8d:	0f 85 31 ff ff ff    	jne    803bc4 <alloc_block_BF+0x29>
		{
			LIST_REMOVE(&FreeMemBlocksList, blk);
			return blk;
		}
	}
	LIST_FOREACH(blk, &FreeMemBlocksList)
  803c93:	a1 38 61 80 00       	mov    0x806138,%eax
  803c98:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803c9b:	eb 27                	jmp    803cc4 <alloc_block_BF+0x129>
	{
		if(blk->size > versize)
  803c9d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803ca0:	8b 40 0c             	mov    0xc(%eax),%eax
  803ca3:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  803ca6:	76 14                	jbe    803cbc <alloc_block_BF+0x121>
		{
			newsize = blk->size;
  803ca8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803cab:	8b 40 0c             	mov    0xc(%eax),%eax
  803cae:	89 45 ec             	mov    %eax,-0x14(%ebp)
			newveradd = blk->sva;
  803cb1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803cb4:	8b 40 08             	mov    0x8(%eax),%eax
  803cb7:	89 45 f0             	mov    %eax,-0x10(%ebp)
			break;
  803cba:	eb 2e                	jmp    803cea <alloc_block_BF+0x14f>
		{
			LIST_REMOVE(&FreeMemBlocksList, blk);
			return blk;
		}
	}
	LIST_FOREACH(blk, &FreeMemBlocksList)
  803cbc:	a1 40 61 80 00       	mov    0x806140,%eax
  803cc1:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803cc4:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803cc8:	74 07                	je     803cd1 <alloc_block_BF+0x136>
  803cca:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803ccd:	8b 00                	mov    (%eax),%eax
  803ccf:	eb 05                	jmp    803cd6 <alloc_block_BF+0x13b>
  803cd1:	b8 00 00 00 00       	mov    $0x0,%eax
  803cd6:	a3 40 61 80 00       	mov    %eax,0x806140
  803cdb:	a1 40 61 80 00       	mov    0x806140,%eax
  803ce0:	85 c0                	test   %eax,%eax
  803ce2:	75 b9                	jne    803c9d <alloc_block_BF+0x102>
  803ce4:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803ce8:	75 b3                	jne    803c9d <alloc_block_BF+0x102>
			newsize = blk->size;
			newveradd = blk->sva;
			break;
		}
	}
	LIST_FOREACH(blk, &FreeMemBlocksList)
  803cea:	a1 38 61 80 00       	mov    0x806138,%eax
  803cef:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803cf2:	eb 30                	jmp    803d24 <alloc_block_BF+0x189>
	{
		if(newsize > blk->size && blk->size > versize)
  803cf4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803cf7:	8b 40 0c             	mov    0xc(%eax),%eax
  803cfa:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  803cfd:	73 1d                	jae    803d1c <alloc_block_BF+0x181>
  803cff:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803d02:	8b 40 0c             	mov    0xc(%eax),%eax
  803d05:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  803d08:	76 12                	jbe    803d1c <alloc_block_BF+0x181>
		{
	       newsize = blk->size;
  803d0a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803d0d:	8b 40 0c             	mov    0xc(%eax),%eax
  803d10:	89 45 ec             	mov    %eax,-0x14(%ebp)
		   newveradd = blk->sva;
  803d13:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803d16:	8b 40 08             	mov    0x8(%eax),%eax
  803d19:	89 45 f0             	mov    %eax,-0x10(%ebp)
			newsize = blk->size;
			newveradd = blk->sva;
			break;
		}
	}
	LIST_FOREACH(blk, &FreeMemBlocksList)
  803d1c:	a1 40 61 80 00       	mov    0x806140,%eax
  803d21:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803d24:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803d28:	74 07                	je     803d31 <alloc_block_BF+0x196>
  803d2a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803d2d:	8b 00                	mov    (%eax),%eax
  803d2f:	eb 05                	jmp    803d36 <alloc_block_BF+0x19b>
  803d31:	b8 00 00 00 00       	mov    $0x0,%eax
  803d36:	a3 40 61 80 00       	mov    %eax,0x806140
  803d3b:	a1 40 61 80 00       	mov    0x806140,%eax
  803d40:	85 c0                	test   %eax,%eax
  803d42:	75 b0                	jne    803cf4 <alloc_block_BF+0x159>
  803d44:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803d48:	75 aa                	jne    803cf4 <alloc_block_BF+0x159>
		{
	       newsize = blk->size;
		   newveradd = blk->sva;
		}
	}
	LIST_FOREACH(blk, &FreeMemBlocksList)
  803d4a:	a1 38 61 80 00       	mov    0x806138,%eax
  803d4f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803d52:	e9 e4 00 00 00       	jmp    803e3b <alloc_block_BF+0x2a0>
	{
		if(blk->size == newsize && blk->sva == newveradd)
  803d57:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803d5a:	8b 40 0c             	mov    0xc(%eax),%eax
  803d5d:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  803d60:	0f 85 cd 00 00 00    	jne    803e33 <alloc_block_BF+0x298>
  803d66:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803d69:	8b 40 08             	mov    0x8(%eax),%eax
  803d6c:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  803d6f:	0f 85 be 00 00 00    	jne    803e33 <alloc_block_BF+0x298>
		{
			LIST_REMOVE(&AvailableMemBlocksList, newblk);
  803d75:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  803d79:	75 17                	jne    803d92 <alloc_block_BF+0x1f7>
  803d7b:	83 ec 04             	sub    $0x4,%esp
  803d7e:	68 68 51 80 00       	push   $0x805168
  803d83:	68 db 00 00 00       	push   $0xdb
  803d88:	68 f7 50 80 00       	push   $0x8050f7
  803d8d:	e8 98 db ff ff       	call   80192a <_panic>
  803d92:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803d95:	8b 00                	mov    (%eax),%eax
  803d97:	85 c0                	test   %eax,%eax
  803d99:	74 10                	je     803dab <alloc_block_BF+0x210>
  803d9b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803d9e:	8b 00                	mov    (%eax),%eax
  803da0:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803da3:	8b 52 04             	mov    0x4(%edx),%edx
  803da6:	89 50 04             	mov    %edx,0x4(%eax)
  803da9:	eb 0b                	jmp    803db6 <alloc_block_BF+0x21b>
  803dab:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803dae:	8b 40 04             	mov    0x4(%eax),%eax
  803db1:	a3 4c 61 80 00       	mov    %eax,0x80614c
  803db6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803db9:	8b 40 04             	mov    0x4(%eax),%eax
  803dbc:	85 c0                	test   %eax,%eax
  803dbe:	74 0f                	je     803dcf <alloc_block_BF+0x234>
  803dc0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803dc3:	8b 40 04             	mov    0x4(%eax),%eax
  803dc6:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803dc9:	8b 12                	mov    (%edx),%edx
  803dcb:	89 10                	mov    %edx,(%eax)
  803dcd:	eb 0a                	jmp    803dd9 <alloc_block_BF+0x23e>
  803dcf:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803dd2:	8b 00                	mov    (%eax),%eax
  803dd4:	a3 48 61 80 00       	mov    %eax,0x806148
  803dd9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803ddc:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803de2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803de5:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803dec:	a1 54 61 80 00       	mov    0x806154,%eax
  803df1:	48                   	dec    %eax
  803df2:	a3 54 61 80 00       	mov    %eax,0x806154
			newblk->size = versize;
  803df7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803dfa:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803dfd:	89 50 0c             	mov    %edx,0xc(%eax)
			newblk->sva = newveradd;
  803e00:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803e03:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803e06:	89 50 08             	mov    %edx,0x8(%eax)
			blk->size = blk->size - versize;
  803e09:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803e0c:	8b 40 0c             	mov    0xc(%eax),%eax
  803e0f:	2b 45 e8             	sub    -0x18(%ebp),%eax
  803e12:	89 c2                	mov    %eax,%edx
  803e14:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803e17:	89 50 0c             	mov    %edx,0xc(%eax)
			blk->sva+= newblk->size;
  803e1a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803e1d:	8b 50 08             	mov    0x8(%eax),%edx
  803e20:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803e23:	8b 40 0c             	mov    0xc(%eax),%eax
  803e26:	01 c2                	add    %eax,%edx
  803e28:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803e2b:	89 50 08             	mov    %edx,0x8(%eax)
			return newblk;
  803e2e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803e31:	eb 3b                	jmp    803e6e <alloc_block_BF+0x2d3>
		{
	       newsize = blk->size;
		   newveradd = blk->sva;
		}
	}
	LIST_FOREACH(blk, &FreeMemBlocksList)
  803e33:	a1 40 61 80 00       	mov    0x806140,%eax
  803e38:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803e3b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803e3f:	74 07                	je     803e48 <alloc_block_BF+0x2ad>
  803e41:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803e44:	8b 00                	mov    (%eax),%eax
  803e46:	eb 05                	jmp    803e4d <alloc_block_BF+0x2b2>
  803e48:	b8 00 00 00 00       	mov    $0x0,%eax
  803e4d:	a3 40 61 80 00       	mov    %eax,0x806140
  803e52:	a1 40 61 80 00       	mov    0x806140,%eax
  803e57:	85 c0                	test   %eax,%eax
  803e59:	0f 85 f8 fe ff ff    	jne    803d57 <alloc_block_BF+0x1bc>
  803e5f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803e63:	0f 85 ee fe ff ff    	jne    803d57 <alloc_block_BF+0x1bc>
			blk->size = blk->size - versize;
			blk->sva+= newblk->size;
			return newblk;
		}
	}
	return NULL;
  803e69:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803e6e:	c9                   	leave  
  803e6f:	c3                   	ret    

00803e70 <alloc_block_NF>:
//=========================================
// [7] ALLOCATE BLOCK BY NEXT FIT:
//=========================================
struct MemBlock *last_allocate;
struct MemBlock *alloc_block_NF(uint32 size)
{
  803e70:	55                   	push   %ebp
  803e71:	89 e5                	mov    %esp,%ebp
  803e73:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1 - BONUS] [DYNAMIC ALLOCATOR] alloc_block_NF
	// Write your code here, remove the panic and write your code
	//panic("alloc_block_NF() is not implemented yet...!!");
	uint32 versize = size;
  803e76:	8b 45 08             	mov    0x8(%ebp),%eax
  803e79:	89 45 f0             	mov    %eax,-0x10(%ebp)
	struct MemBlock* blk;
	struct MemBlock* newblk = LIST_FIRST(&AvailableMemBlocksList);
  803e7c:	a1 48 61 80 00       	mov    0x806148,%eax
  803e81:	89 45 ec             	mov    %eax,-0x14(%ebp)

	LIST_FOREACH(blk,&FreeMemBlocksList)
  803e84:	a1 38 61 80 00       	mov    0x806138,%eax
  803e89:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803e8c:	e9 77 01 00 00       	jmp    804008 <alloc_block_NF+0x198>
	{
		if(blk->size == versize)
  803e91:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803e94:	8b 40 0c             	mov    0xc(%eax),%eax
  803e97:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  803e9a:	0f 85 8a 00 00 00    	jne    803f2a <alloc_block_NF+0xba>
		{
			LIST_REMOVE(&FreeMemBlocksList,blk);
  803ea0:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803ea4:	75 17                	jne    803ebd <alloc_block_NF+0x4d>
  803ea6:	83 ec 04             	sub    $0x4,%esp
  803ea9:	68 68 51 80 00       	push   $0x805168
  803eae:	68 f7 00 00 00       	push   $0xf7
  803eb3:	68 f7 50 80 00       	push   $0x8050f7
  803eb8:	e8 6d da ff ff       	call   80192a <_panic>
  803ebd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803ec0:	8b 00                	mov    (%eax),%eax
  803ec2:	85 c0                	test   %eax,%eax
  803ec4:	74 10                	je     803ed6 <alloc_block_NF+0x66>
  803ec6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803ec9:	8b 00                	mov    (%eax),%eax
  803ecb:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803ece:	8b 52 04             	mov    0x4(%edx),%edx
  803ed1:	89 50 04             	mov    %edx,0x4(%eax)
  803ed4:	eb 0b                	jmp    803ee1 <alloc_block_NF+0x71>
  803ed6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803ed9:	8b 40 04             	mov    0x4(%eax),%eax
  803edc:	a3 3c 61 80 00       	mov    %eax,0x80613c
  803ee1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803ee4:	8b 40 04             	mov    0x4(%eax),%eax
  803ee7:	85 c0                	test   %eax,%eax
  803ee9:	74 0f                	je     803efa <alloc_block_NF+0x8a>
  803eeb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803eee:	8b 40 04             	mov    0x4(%eax),%eax
  803ef1:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803ef4:	8b 12                	mov    (%edx),%edx
  803ef6:	89 10                	mov    %edx,(%eax)
  803ef8:	eb 0a                	jmp    803f04 <alloc_block_NF+0x94>
  803efa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803efd:	8b 00                	mov    (%eax),%eax
  803eff:	a3 38 61 80 00       	mov    %eax,0x806138
  803f04:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803f07:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803f0d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803f10:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803f17:	a1 44 61 80 00       	mov    0x806144,%eax
  803f1c:	48                   	dec    %eax
  803f1d:	a3 44 61 80 00       	mov    %eax,0x806144
			return blk;
  803f22:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803f25:	e9 11 01 00 00       	jmp    80403b <alloc_block_NF+0x1cb>
		}
		else if(blk->size > versize)
  803f2a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803f2d:	8b 40 0c             	mov    0xc(%eax),%eax
  803f30:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  803f33:	0f 86 c7 00 00 00    	jbe    804000 <alloc_block_NF+0x190>
		{
			LIST_REMOVE(&AvailableMemBlocksList,newblk);
  803f39:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  803f3d:	75 17                	jne    803f56 <alloc_block_NF+0xe6>
  803f3f:	83 ec 04             	sub    $0x4,%esp
  803f42:	68 68 51 80 00       	push   $0x805168
  803f47:	68 fc 00 00 00       	push   $0xfc
  803f4c:	68 f7 50 80 00       	push   $0x8050f7
  803f51:	e8 d4 d9 ff ff       	call   80192a <_panic>
  803f56:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803f59:	8b 00                	mov    (%eax),%eax
  803f5b:	85 c0                	test   %eax,%eax
  803f5d:	74 10                	je     803f6f <alloc_block_NF+0xff>
  803f5f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803f62:	8b 00                	mov    (%eax),%eax
  803f64:	8b 55 ec             	mov    -0x14(%ebp),%edx
  803f67:	8b 52 04             	mov    0x4(%edx),%edx
  803f6a:	89 50 04             	mov    %edx,0x4(%eax)
  803f6d:	eb 0b                	jmp    803f7a <alloc_block_NF+0x10a>
  803f6f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803f72:	8b 40 04             	mov    0x4(%eax),%eax
  803f75:	a3 4c 61 80 00       	mov    %eax,0x80614c
  803f7a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803f7d:	8b 40 04             	mov    0x4(%eax),%eax
  803f80:	85 c0                	test   %eax,%eax
  803f82:	74 0f                	je     803f93 <alloc_block_NF+0x123>
  803f84:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803f87:	8b 40 04             	mov    0x4(%eax),%eax
  803f8a:	8b 55 ec             	mov    -0x14(%ebp),%edx
  803f8d:	8b 12                	mov    (%edx),%edx
  803f8f:	89 10                	mov    %edx,(%eax)
  803f91:	eb 0a                	jmp    803f9d <alloc_block_NF+0x12d>
  803f93:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803f96:	8b 00                	mov    (%eax),%eax
  803f98:	a3 48 61 80 00       	mov    %eax,0x806148
  803f9d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803fa0:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803fa6:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803fa9:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803fb0:	a1 54 61 80 00       	mov    0x806154,%eax
  803fb5:	48                   	dec    %eax
  803fb6:	a3 54 61 80 00       	mov    %eax,0x806154
			newblk->size = versize;
  803fbb:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803fbe:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803fc1:	89 50 0c             	mov    %edx,0xc(%eax)
			blk->size = blk->size-versize;
  803fc4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803fc7:	8b 40 0c             	mov    0xc(%eax),%eax
  803fca:	2b 45 f0             	sub    -0x10(%ebp),%eax
  803fcd:	89 c2                	mov    %eax,%edx
  803fcf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803fd2:	89 50 0c             	mov    %edx,0xc(%eax)
			uint32 newveradd = blk->sva;
  803fd5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803fd8:	8b 40 08             	mov    0x8(%eax),%eax
  803fdb:	89 45 e8             	mov    %eax,-0x18(%ebp)
			blk->sva+=newblk->size;
  803fde:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803fe1:	8b 50 08             	mov    0x8(%eax),%edx
  803fe4:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803fe7:	8b 40 0c             	mov    0xc(%eax),%eax
  803fea:	01 c2                	add    %eax,%edx
  803fec:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803fef:	89 50 08             	mov    %edx,0x8(%eax)
			newblk->sva = newveradd;
  803ff2:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803ff5:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803ff8:	89 50 08             	mov    %edx,0x8(%eax)
			return newblk;
  803ffb:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803ffe:	eb 3b                	jmp    80403b <alloc_block_NF+0x1cb>
	//panic("alloc_block_NF() is not implemented yet...!!");
	uint32 versize = size;
	struct MemBlock* blk;
	struct MemBlock* newblk = LIST_FIRST(&AvailableMemBlocksList);

	LIST_FOREACH(blk,&FreeMemBlocksList)
  804000:	a1 40 61 80 00       	mov    0x806140,%eax
  804005:	89 45 f4             	mov    %eax,-0xc(%ebp)
  804008:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80400c:	74 07                	je     804015 <alloc_block_NF+0x1a5>
  80400e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  804011:	8b 00                	mov    (%eax),%eax
  804013:	eb 05                	jmp    80401a <alloc_block_NF+0x1aa>
  804015:	b8 00 00 00 00       	mov    $0x0,%eax
  80401a:	a3 40 61 80 00       	mov    %eax,0x806140
  80401f:	a1 40 61 80 00       	mov    0x806140,%eax
  804024:	85 c0                	test   %eax,%eax
  804026:	0f 85 65 fe ff ff    	jne    803e91 <alloc_block_NF+0x21>
  80402c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  804030:	0f 85 5b fe ff ff    	jne    803e91 <alloc_block_NF+0x21>
			blk->sva+=newblk->size;
			newblk->sva = newveradd;
			return newblk;
		}
	}
	return NULL;
  804036:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80403b:	c9                   	leave  
  80403c:	c3                   	ret    

0080403d <addToAvailMemBlocksList>:

//===================================================
// [8] INSERT BLOCK (SORTED WITH MERGE) IN FREE LIST:
//===================================================
void addToAvailMemBlocksList(struct MemBlock *blockToInsert)
{
  80403d:	55                   	push   %ebp
  80403e:	89 e5                	mov    %esp,%ebp
  804040:	83 ec 08             	sub    $0x8,%esp
	blockToInsert->sva = 0;
  804043:	8b 45 08             	mov    0x8(%ebp),%eax
  804046:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
	blockToInsert->size = 0;
  80404d:	8b 45 08             	mov    0x8(%ebp),%eax
  804050:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
	//add to avail
	LIST_INSERT_TAIL(&AvailableMemBlocksList, blockToInsert);
  804057:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80405b:	75 17                	jne    804074 <addToAvailMemBlocksList+0x37>
  80405d:	83 ec 04             	sub    $0x4,%esp
  804060:	68 10 51 80 00       	push   $0x805110
  804065:	68 10 01 00 00       	push   $0x110
  80406a:	68 f7 50 80 00       	push   $0x8050f7
  80406f:	e8 b6 d8 ff ff       	call   80192a <_panic>
  804074:	8b 15 4c 61 80 00    	mov    0x80614c,%edx
  80407a:	8b 45 08             	mov    0x8(%ebp),%eax
  80407d:	89 50 04             	mov    %edx,0x4(%eax)
  804080:	8b 45 08             	mov    0x8(%ebp),%eax
  804083:	8b 40 04             	mov    0x4(%eax),%eax
  804086:	85 c0                	test   %eax,%eax
  804088:	74 0c                	je     804096 <addToAvailMemBlocksList+0x59>
  80408a:	a1 4c 61 80 00       	mov    0x80614c,%eax
  80408f:	8b 55 08             	mov    0x8(%ebp),%edx
  804092:	89 10                	mov    %edx,(%eax)
  804094:	eb 08                	jmp    80409e <addToAvailMemBlocksList+0x61>
  804096:	8b 45 08             	mov    0x8(%ebp),%eax
  804099:	a3 48 61 80 00       	mov    %eax,0x806148
  80409e:	8b 45 08             	mov    0x8(%ebp),%eax
  8040a1:	a3 4c 61 80 00       	mov    %eax,0x80614c
  8040a6:	8b 45 08             	mov    0x8(%ebp),%eax
  8040a9:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8040af:	a1 54 61 80 00       	mov    0x806154,%eax
  8040b4:	40                   	inc    %eax
  8040b5:	a3 54 61 80 00       	mov    %eax,0x806154
}
  8040ba:	90                   	nop
  8040bb:	c9                   	leave  
  8040bc:	c3                   	ret    

008040bd <insert_sorted_with_merge_freeList>:
void insert_sorted_with_merge_freeList(struct MemBlock *blockToInsert)
{
  8040bd:	55                   	push   %ebp
  8040be:	89 e5                	mov    %esp,%ebp
  8040c0:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] insert_sorted_with_merge_freeList
	// Write your code here, remove the panic and write your code

	struct MemBlock* last = LIST_LAST(&FreeMemBlocksList);
  8040c3:	a1 3c 61 80 00       	mov    0x80613c,%eax
  8040c8:	89 45 f0             	mov    %eax,-0x10(%ebp)
	//check if list empty
	if (LIST_SIZE(&(FreeMemBlocksList)) == 0)
  8040cb:	a1 44 61 80 00       	mov    0x806144,%eax
  8040d0:	85 c0                	test   %eax,%eax
  8040d2:	75 68                	jne    80413c <insert_sorted_with_merge_freeList+0x7f>
		LIST_INSERT_HEAD(&FreeMemBlocksList, blockToInsert);
  8040d4:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8040d8:	75 17                	jne    8040f1 <insert_sorted_with_merge_freeList+0x34>
  8040da:	83 ec 04             	sub    $0x4,%esp
  8040dd:	68 d4 50 80 00       	push   $0x8050d4
  8040e2:	68 1a 01 00 00       	push   $0x11a
  8040e7:	68 f7 50 80 00       	push   $0x8050f7
  8040ec:	e8 39 d8 ff ff       	call   80192a <_panic>
  8040f1:	8b 15 38 61 80 00    	mov    0x806138,%edx
  8040f7:	8b 45 08             	mov    0x8(%ebp),%eax
  8040fa:	89 10                	mov    %edx,(%eax)
  8040fc:	8b 45 08             	mov    0x8(%ebp),%eax
  8040ff:	8b 00                	mov    (%eax),%eax
  804101:	85 c0                	test   %eax,%eax
  804103:	74 0d                	je     804112 <insert_sorted_with_merge_freeList+0x55>
  804105:	a1 38 61 80 00       	mov    0x806138,%eax
  80410a:	8b 55 08             	mov    0x8(%ebp),%edx
  80410d:	89 50 04             	mov    %edx,0x4(%eax)
  804110:	eb 08                	jmp    80411a <insert_sorted_with_merge_freeList+0x5d>
  804112:	8b 45 08             	mov    0x8(%ebp),%eax
  804115:	a3 3c 61 80 00       	mov    %eax,0x80613c
  80411a:	8b 45 08             	mov    0x8(%ebp),%eax
  80411d:	a3 38 61 80 00       	mov    %eax,0x806138
  804122:	8b 45 08             	mov    0x8(%ebp),%eax
  804125:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80412c:	a1 44 61 80 00       	mov    0x806144,%eax
  804131:	40                   	inc    %eax
  804132:	a3 44 61 80 00       	mov    %eax,0x806144
		}
	}

	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  804137:	e9 c5 03 00 00       	jmp    804501 <insert_sorted_with_merge_freeList+0x444>
	struct MemBlock* last = LIST_LAST(&FreeMemBlocksList);
	//check if list empty
	if (LIST_SIZE(&(FreeMemBlocksList)) == 0)
		LIST_INSERT_HEAD(&FreeMemBlocksList, blockToInsert);
	//check if it's position is at last
	else if (last->sva < blockToInsert->sva) {
  80413c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80413f:	8b 50 08             	mov    0x8(%eax),%edx
  804142:	8b 45 08             	mov    0x8(%ebp),%eax
  804145:	8b 40 08             	mov    0x8(%eax),%eax
  804148:	39 c2                	cmp    %eax,%edx
  80414a:	0f 83 b2 00 00 00    	jae    804202 <insert_sorted_with_merge_freeList+0x145>

		//if i have to merge
		if (last->sva + last->size == blockToInsert->sva) {
  804150:	8b 45 f0             	mov    -0x10(%ebp),%eax
  804153:	8b 50 08             	mov    0x8(%eax),%edx
  804156:	8b 45 f0             	mov    -0x10(%ebp),%eax
  804159:	8b 40 0c             	mov    0xc(%eax),%eax
  80415c:	01 c2                	add    %eax,%edx
  80415e:	8b 45 08             	mov    0x8(%ebp),%eax
  804161:	8b 40 08             	mov    0x8(%eax),%eax
  804164:	39 c2                	cmp    %eax,%edx
  804166:	75 27                	jne    80418f <insert_sorted_with_merge_freeList+0xd2>
			last->size = last->size + blockToInsert->size;
  804168:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80416b:	8b 50 0c             	mov    0xc(%eax),%edx
  80416e:	8b 45 08             	mov    0x8(%ebp),%eax
  804171:	8b 40 0c             	mov    0xc(%eax),%eax
  804174:	01 c2                	add    %eax,%edx
  804176:	8b 45 f0             	mov    -0x10(%ebp),%eax
  804179:	89 50 0c             	mov    %edx,0xc(%eax)
			addToAvailMemBlocksList(blockToInsert);
  80417c:	83 ec 0c             	sub    $0xc,%esp
  80417f:	ff 75 08             	pushl  0x8(%ebp)
  804182:	e8 b6 fe ff ff       	call   80403d <addToAvailMemBlocksList>
  804187:	83 c4 10             	add    $0x10,%esp
		}
	}

	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  80418a:	e9 72 03 00 00       	jmp    804501 <insert_sorted_with_merge_freeList+0x444>
		if (last->sva + last->size == blockToInsert->sva) {
			last->size = last->size + blockToInsert->size;
			addToAvailMemBlocksList(blockToInsert);

		} else {
			LIST_INSERT_AFTER(&FreeMemBlocksList, last, blockToInsert);
  80418f:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  804193:	74 06                	je     80419b <insert_sorted_with_merge_freeList+0xde>
  804195:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  804199:	75 17                	jne    8041b2 <insert_sorted_with_merge_freeList+0xf5>
  80419b:	83 ec 04             	sub    $0x4,%esp
  80419e:	68 34 51 80 00       	push   $0x805134
  8041a3:	68 24 01 00 00       	push   $0x124
  8041a8:	68 f7 50 80 00       	push   $0x8050f7
  8041ad:	e8 78 d7 ff ff       	call   80192a <_panic>
  8041b2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8041b5:	8b 10                	mov    (%eax),%edx
  8041b7:	8b 45 08             	mov    0x8(%ebp),%eax
  8041ba:	89 10                	mov    %edx,(%eax)
  8041bc:	8b 45 08             	mov    0x8(%ebp),%eax
  8041bf:	8b 00                	mov    (%eax),%eax
  8041c1:	85 c0                	test   %eax,%eax
  8041c3:	74 0b                	je     8041d0 <insert_sorted_with_merge_freeList+0x113>
  8041c5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8041c8:	8b 00                	mov    (%eax),%eax
  8041ca:	8b 55 08             	mov    0x8(%ebp),%edx
  8041cd:	89 50 04             	mov    %edx,0x4(%eax)
  8041d0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8041d3:	8b 55 08             	mov    0x8(%ebp),%edx
  8041d6:	89 10                	mov    %edx,(%eax)
  8041d8:	8b 45 08             	mov    0x8(%ebp),%eax
  8041db:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8041de:	89 50 04             	mov    %edx,0x4(%eax)
  8041e1:	8b 45 08             	mov    0x8(%ebp),%eax
  8041e4:	8b 00                	mov    (%eax),%eax
  8041e6:	85 c0                	test   %eax,%eax
  8041e8:	75 08                	jne    8041f2 <insert_sorted_with_merge_freeList+0x135>
  8041ea:	8b 45 08             	mov    0x8(%ebp),%eax
  8041ed:	a3 3c 61 80 00       	mov    %eax,0x80613c
  8041f2:	a1 44 61 80 00       	mov    0x806144,%eax
  8041f7:	40                   	inc    %eax
  8041f8:	a3 44 61 80 00       	mov    %eax,0x806144
		}
	}

	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  8041fd:	e9 ff 02 00 00       	jmp    804501 <insert_sorted_with_merge_freeList+0x444>
		} else {
			LIST_INSERT_AFTER(&FreeMemBlocksList, last, blockToInsert);
		}
	} else {
		struct MemBlock *iterator;
		LIST_FOREACH(iterator, &(FreeMemBlocksList))
  804202:	a1 38 61 80 00       	mov    0x806138,%eax
  804207:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80420a:	e9 c2 02 00 00       	jmp    8044d1 <insert_sorted_with_merge_freeList+0x414>
		{

			if (iterator->sva > blockToInsert->sva) {
  80420f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  804212:	8b 50 08             	mov    0x8(%eax),%edx
  804215:	8b 45 08             	mov    0x8(%ebp),%eax
  804218:	8b 40 08             	mov    0x8(%eax),%eax
  80421b:	39 c2                	cmp    %eax,%edx
  80421d:	0f 86 a6 02 00 00    	jbe    8044c9 <insert_sorted_with_merge_freeList+0x40c>

				struct MemBlock* prev = LIST_PREV(iterator);
  804223:	8b 45 f4             	mov    -0xc(%ebp),%eax
  804226:	8b 40 04             	mov    0x4(%eax),%eax
  804229:	89 45 ec             	mov    %eax,-0x14(%ebp)
				if (prev == NULL) {
  80422c:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  804230:	0f 85 ba 00 00 00    	jne    8042f0 <insert_sorted_with_merge_freeList+0x233>
					//check merge
					if (blockToInsert->size + blockToInsert->sva
  804236:	8b 45 08             	mov    0x8(%ebp),%eax
  804239:	8b 50 0c             	mov    0xc(%eax),%edx
  80423c:	8b 45 08             	mov    0x8(%ebp),%eax
  80423f:	8b 40 08             	mov    0x8(%eax),%eax
  804242:	01 c2                	add    %eax,%edx
							== iterator->sva) {
  804244:	8b 45 f4             	mov    -0xc(%ebp),%eax
  804247:	8b 40 08             	mov    0x8(%eax),%eax
			if (iterator->sva > blockToInsert->sva) {

				struct MemBlock* prev = LIST_PREV(iterator);
				if (prev == NULL) {
					//check merge
					if (blockToInsert->size + blockToInsert->sva
  80424a:	39 c2                	cmp    %eax,%edx
  80424c:	75 33                	jne    804281 <insert_sorted_with_merge_freeList+0x1c4>
							== iterator->sva) {
						iterator->sva = blockToInsert->sva;
  80424e:	8b 45 08             	mov    0x8(%ebp),%eax
  804251:	8b 50 08             	mov    0x8(%eax),%edx
  804254:	8b 45 f4             	mov    -0xc(%ebp),%eax
  804257:	89 50 08             	mov    %edx,0x8(%eax)
						iterator->size = iterator->size + blockToInsert->size;
  80425a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80425d:	8b 50 0c             	mov    0xc(%eax),%edx
  804260:	8b 45 08             	mov    0x8(%ebp),%eax
  804263:	8b 40 0c             	mov    0xc(%eax),%eax
  804266:	01 c2                	add    %eax,%edx
  804268:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80426b:	89 50 0c             	mov    %edx,0xc(%eax)
						addToAvailMemBlocksList(blockToInsert);
  80426e:	83 ec 0c             	sub    $0xc,%esp
  804271:	ff 75 08             	pushl  0x8(%ebp)
  804274:	e8 c4 fd ff ff       	call   80403d <addToAvailMemBlocksList>
  804279:	83 c4 10             	add    $0x10,%esp

					else {
						LIST_INSERT_BEFORE(&FreeMemBlocksList, iterator,
								blockToInsert);
					}
					break;
  80427c:	e9 80 02 00 00       	jmp    804501 <insert_sorted_with_merge_freeList+0x444>
						addToAvailMemBlocksList(blockToInsert);

					}

					else {
						LIST_INSERT_BEFORE(&FreeMemBlocksList, iterator,
  804281:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  804285:	74 06                	je     80428d <insert_sorted_with_merge_freeList+0x1d0>
  804287:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80428b:	75 17                	jne    8042a4 <insert_sorted_with_merge_freeList+0x1e7>
  80428d:	83 ec 04             	sub    $0x4,%esp
  804290:	68 88 51 80 00       	push   $0x805188
  804295:	68 3a 01 00 00       	push   $0x13a
  80429a:	68 f7 50 80 00       	push   $0x8050f7
  80429f:	e8 86 d6 ff ff       	call   80192a <_panic>
  8042a4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8042a7:	8b 50 04             	mov    0x4(%eax),%edx
  8042aa:	8b 45 08             	mov    0x8(%ebp),%eax
  8042ad:	89 50 04             	mov    %edx,0x4(%eax)
  8042b0:	8b 45 08             	mov    0x8(%ebp),%eax
  8042b3:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8042b6:	89 10                	mov    %edx,(%eax)
  8042b8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8042bb:	8b 40 04             	mov    0x4(%eax),%eax
  8042be:	85 c0                	test   %eax,%eax
  8042c0:	74 0d                	je     8042cf <insert_sorted_with_merge_freeList+0x212>
  8042c2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8042c5:	8b 40 04             	mov    0x4(%eax),%eax
  8042c8:	8b 55 08             	mov    0x8(%ebp),%edx
  8042cb:	89 10                	mov    %edx,(%eax)
  8042cd:	eb 08                	jmp    8042d7 <insert_sorted_with_merge_freeList+0x21a>
  8042cf:	8b 45 08             	mov    0x8(%ebp),%eax
  8042d2:	a3 38 61 80 00       	mov    %eax,0x806138
  8042d7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8042da:	8b 55 08             	mov    0x8(%ebp),%edx
  8042dd:	89 50 04             	mov    %edx,0x4(%eax)
  8042e0:	a1 44 61 80 00       	mov    0x806144,%eax
  8042e5:	40                   	inc    %eax
  8042e6:	a3 44 61 80 00       	mov    %eax,0x806144
								blockToInsert);
					}
					break;
  8042eb:	e9 11 02 00 00       	jmp    804501 <insert_sorted_with_merge_freeList+0x444>
				} else {
					//prev and next merge
					if (prev->sva + prev->size + blockToInsert->size
  8042f0:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8042f3:	8b 50 08             	mov    0x8(%eax),%edx
  8042f6:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8042f9:	8b 40 0c             	mov    0xc(%eax),%eax
  8042fc:	01 c2                	add    %eax,%edx
  8042fe:	8b 45 08             	mov    0x8(%ebp),%eax
  804301:	8b 40 0c             	mov    0xc(%eax),%eax
  804304:	01 c2                	add    %eax,%edx
							== iterator->sva) {
  804306:	8b 45 f4             	mov    -0xc(%ebp),%eax
  804309:	8b 40 08             	mov    0x8(%eax),%eax
								blockToInsert);
					}
					break;
				} else {
					//prev and next merge
					if (prev->sva + prev->size + blockToInsert->size
  80430c:	39 c2                	cmp    %eax,%edx
  80430e:	0f 85 bf 00 00 00    	jne    8043d3 <insert_sorted_with_merge_freeList+0x316>
							== iterator->sva) {
						prev->size = prev->size + blockToInsert->size
  804314:	8b 45 ec             	mov    -0x14(%ebp),%eax
  804317:	8b 50 0c             	mov    0xc(%eax),%edx
  80431a:	8b 45 08             	mov    0x8(%ebp),%eax
  80431d:	8b 40 0c             	mov    0xc(%eax),%eax
  804320:	01 c2                	add    %eax,%edx
								+ iterator->size;
  804322:	8b 45 f4             	mov    -0xc(%ebp),%eax
  804325:	8b 40 0c             	mov    0xc(%eax),%eax
  804328:	01 c2                	add    %eax,%edx
					break;
				} else {
					//prev and next merge
					if (prev->sva + prev->size + blockToInsert->size
							== iterator->sva) {
						prev->size = prev->size + blockToInsert->size
  80432a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80432d:	89 50 0c             	mov    %edx,0xc(%eax)
								+ iterator->size;
						LIST_REMOVE(&FreeMemBlocksList, iterator);
  804330:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  804334:	75 17                	jne    80434d <insert_sorted_with_merge_freeList+0x290>
  804336:	83 ec 04             	sub    $0x4,%esp
  804339:	68 68 51 80 00       	push   $0x805168
  80433e:	68 43 01 00 00       	push   $0x143
  804343:	68 f7 50 80 00       	push   $0x8050f7
  804348:	e8 dd d5 ff ff       	call   80192a <_panic>
  80434d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  804350:	8b 00                	mov    (%eax),%eax
  804352:	85 c0                	test   %eax,%eax
  804354:	74 10                	je     804366 <insert_sorted_with_merge_freeList+0x2a9>
  804356:	8b 45 f4             	mov    -0xc(%ebp),%eax
  804359:	8b 00                	mov    (%eax),%eax
  80435b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80435e:	8b 52 04             	mov    0x4(%edx),%edx
  804361:	89 50 04             	mov    %edx,0x4(%eax)
  804364:	eb 0b                	jmp    804371 <insert_sorted_with_merge_freeList+0x2b4>
  804366:	8b 45 f4             	mov    -0xc(%ebp),%eax
  804369:	8b 40 04             	mov    0x4(%eax),%eax
  80436c:	a3 3c 61 80 00       	mov    %eax,0x80613c
  804371:	8b 45 f4             	mov    -0xc(%ebp),%eax
  804374:	8b 40 04             	mov    0x4(%eax),%eax
  804377:	85 c0                	test   %eax,%eax
  804379:	74 0f                	je     80438a <insert_sorted_with_merge_freeList+0x2cd>
  80437b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80437e:	8b 40 04             	mov    0x4(%eax),%eax
  804381:	8b 55 f4             	mov    -0xc(%ebp),%edx
  804384:	8b 12                	mov    (%edx),%edx
  804386:	89 10                	mov    %edx,(%eax)
  804388:	eb 0a                	jmp    804394 <insert_sorted_with_merge_freeList+0x2d7>
  80438a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80438d:	8b 00                	mov    (%eax),%eax
  80438f:	a3 38 61 80 00       	mov    %eax,0x806138
  804394:	8b 45 f4             	mov    -0xc(%ebp),%eax
  804397:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80439d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8043a0:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8043a7:	a1 44 61 80 00       	mov    0x806144,%eax
  8043ac:	48                   	dec    %eax
  8043ad:	a3 44 61 80 00       	mov    %eax,0x806144
						addToAvailMemBlocksList(blockToInsert);
  8043b2:	83 ec 0c             	sub    $0xc,%esp
  8043b5:	ff 75 08             	pushl  0x8(%ebp)
  8043b8:	e8 80 fc ff ff       	call   80403d <addToAvailMemBlocksList>
  8043bd:	83 c4 10             	add    $0x10,%esp
						addToAvailMemBlocksList(iterator);
  8043c0:	83 ec 0c             	sub    $0xc,%esp
  8043c3:	ff 75 f4             	pushl  -0xc(%ebp)
  8043c6:	e8 72 fc ff ff       	call   80403d <addToAvailMemBlocksList>
  8043cb:	83 c4 10             	add    $0x10,%esp
					//Insert
					else {
						LIST_INSERT_BEFORE(&FreeMemBlocksList, iterator,
								blockToInsert);
					}
					break;
  8043ce:	e9 2e 01 00 00       	jmp    804501 <insert_sorted_with_merge_freeList+0x444>
						LIST_REMOVE(&FreeMemBlocksList, iterator);
						addToAvailMemBlocksList(blockToInsert);
						addToAvailMemBlocksList(iterator);
					}
					//previous merge
					else if (prev->sva + prev->size == blockToInsert->sva) {
  8043d3:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8043d6:	8b 50 08             	mov    0x8(%eax),%edx
  8043d9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8043dc:	8b 40 0c             	mov    0xc(%eax),%eax
  8043df:	01 c2                	add    %eax,%edx
  8043e1:	8b 45 08             	mov    0x8(%ebp),%eax
  8043e4:	8b 40 08             	mov    0x8(%eax),%eax
  8043e7:	39 c2                	cmp    %eax,%edx
  8043e9:	75 27                	jne    804412 <insert_sorted_with_merge_freeList+0x355>
						prev->size = prev->size + blockToInsert->size;
  8043eb:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8043ee:	8b 50 0c             	mov    0xc(%eax),%edx
  8043f1:	8b 45 08             	mov    0x8(%ebp),%eax
  8043f4:	8b 40 0c             	mov    0xc(%eax),%eax
  8043f7:	01 c2                	add    %eax,%edx
  8043f9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8043fc:	89 50 0c             	mov    %edx,0xc(%eax)
						addToAvailMemBlocksList(blockToInsert);
  8043ff:	83 ec 0c             	sub    $0xc,%esp
  804402:	ff 75 08             	pushl  0x8(%ebp)
  804405:	e8 33 fc ff ff       	call   80403d <addToAvailMemBlocksList>
  80440a:	83 c4 10             	add    $0x10,%esp
					//Insert
					else {
						LIST_INSERT_BEFORE(&FreeMemBlocksList, iterator,
								blockToInsert);
					}
					break;
  80440d:	e9 ef 00 00 00       	jmp    804501 <insert_sorted_with_merge_freeList+0x444>
					else if (prev->sva + prev->size == blockToInsert->sva) {
						prev->size = prev->size + blockToInsert->size;
						addToAvailMemBlocksList(blockToInsert);
					}
					//next merge
					else if (blockToInsert->size + blockToInsert->sva
  804412:	8b 45 08             	mov    0x8(%ebp),%eax
  804415:	8b 50 0c             	mov    0xc(%eax),%edx
  804418:	8b 45 08             	mov    0x8(%ebp),%eax
  80441b:	8b 40 08             	mov    0x8(%eax),%eax
  80441e:	01 c2                	add    %eax,%edx
							== iterator->sva) {
  804420:	8b 45 f4             	mov    -0xc(%ebp),%eax
  804423:	8b 40 08             	mov    0x8(%eax),%eax
					else if (prev->sva + prev->size == blockToInsert->sva) {
						prev->size = prev->size + blockToInsert->size;
						addToAvailMemBlocksList(blockToInsert);
					}
					//next merge
					else if (blockToInsert->size + blockToInsert->sva
  804426:	39 c2                	cmp    %eax,%edx
  804428:	75 33                	jne    80445d <insert_sorted_with_merge_freeList+0x3a0>
							== iterator->sva) {
						iterator->sva = blockToInsert->sva;
  80442a:	8b 45 08             	mov    0x8(%ebp),%eax
  80442d:	8b 50 08             	mov    0x8(%eax),%edx
  804430:	8b 45 f4             	mov    -0xc(%ebp),%eax
  804433:	89 50 08             	mov    %edx,0x8(%eax)
						iterator->size = iterator->size + blockToInsert->size;
  804436:	8b 45 f4             	mov    -0xc(%ebp),%eax
  804439:	8b 50 0c             	mov    0xc(%eax),%edx
  80443c:	8b 45 08             	mov    0x8(%ebp),%eax
  80443f:	8b 40 0c             	mov    0xc(%eax),%eax
  804442:	01 c2                	add    %eax,%edx
  804444:	8b 45 f4             	mov    -0xc(%ebp),%eax
  804447:	89 50 0c             	mov    %edx,0xc(%eax)
						addToAvailMemBlocksList(blockToInsert);
  80444a:	83 ec 0c             	sub    $0xc,%esp
  80444d:	ff 75 08             	pushl  0x8(%ebp)
  804450:	e8 e8 fb ff ff       	call   80403d <addToAvailMemBlocksList>
  804455:	83 c4 10             	add    $0x10,%esp
					//Insert
					else {
						LIST_INSERT_BEFORE(&FreeMemBlocksList, iterator,
								blockToInsert);
					}
					break;
  804458:	e9 a4 00 00 00       	jmp    804501 <insert_sorted_with_merge_freeList+0x444>
						iterator->size = iterator->size + blockToInsert->size;
						addToAvailMemBlocksList(blockToInsert);
					}
					//Insert
					else {
						LIST_INSERT_BEFORE(&FreeMemBlocksList, iterator,
  80445d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  804461:	74 06                	je     804469 <insert_sorted_with_merge_freeList+0x3ac>
  804463:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  804467:	75 17                	jne    804480 <insert_sorted_with_merge_freeList+0x3c3>
  804469:	83 ec 04             	sub    $0x4,%esp
  80446c:	68 88 51 80 00       	push   $0x805188
  804471:	68 56 01 00 00       	push   $0x156
  804476:	68 f7 50 80 00       	push   $0x8050f7
  80447b:	e8 aa d4 ff ff       	call   80192a <_panic>
  804480:	8b 45 f4             	mov    -0xc(%ebp),%eax
  804483:	8b 50 04             	mov    0x4(%eax),%edx
  804486:	8b 45 08             	mov    0x8(%ebp),%eax
  804489:	89 50 04             	mov    %edx,0x4(%eax)
  80448c:	8b 45 08             	mov    0x8(%ebp),%eax
  80448f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  804492:	89 10                	mov    %edx,(%eax)
  804494:	8b 45 f4             	mov    -0xc(%ebp),%eax
  804497:	8b 40 04             	mov    0x4(%eax),%eax
  80449a:	85 c0                	test   %eax,%eax
  80449c:	74 0d                	je     8044ab <insert_sorted_with_merge_freeList+0x3ee>
  80449e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8044a1:	8b 40 04             	mov    0x4(%eax),%eax
  8044a4:	8b 55 08             	mov    0x8(%ebp),%edx
  8044a7:	89 10                	mov    %edx,(%eax)
  8044a9:	eb 08                	jmp    8044b3 <insert_sorted_with_merge_freeList+0x3f6>
  8044ab:	8b 45 08             	mov    0x8(%ebp),%eax
  8044ae:	a3 38 61 80 00       	mov    %eax,0x806138
  8044b3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8044b6:	8b 55 08             	mov    0x8(%ebp),%edx
  8044b9:	89 50 04             	mov    %edx,0x4(%eax)
  8044bc:	a1 44 61 80 00       	mov    0x806144,%eax
  8044c1:	40                   	inc    %eax
  8044c2:	a3 44 61 80 00       	mov    %eax,0x806144
								blockToInsert);
					}
					break;
  8044c7:	eb 38                	jmp    804501 <insert_sorted_with_merge_freeList+0x444>
		} else {
			LIST_INSERT_AFTER(&FreeMemBlocksList, last, blockToInsert);
		}
	} else {
		struct MemBlock *iterator;
		LIST_FOREACH(iterator, &(FreeMemBlocksList))
  8044c9:	a1 40 61 80 00       	mov    0x806140,%eax
  8044ce:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8044d1:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8044d5:	74 07                	je     8044de <insert_sorted_with_merge_freeList+0x421>
  8044d7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8044da:	8b 00                	mov    (%eax),%eax
  8044dc:	eb 05                	jmp    8044e3 <insert_sorted_with_merge_freeList+0x426>
  8044de:	b8 00 00 00 00       	mov    $0x0,%eax
  8044e3:	a3 40 61 80 00       	mov    %eax,0x806140
  8044e8:	a1 40 61 80 00       	mov    0x806140,%eax
  8044ed:	85 c0                	test   %eax,%eax
  8044ef:	0f 85 1a fd ff ff    	jne    80420f <insert_sorted_with_merge_freeList+0x152>
  8044f5:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8044f9:	0f 85 10 fd ff ff    	jne    80420f <insert_sorted_with_merge_freeList+0x152>
		}
	}

	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  8044ff:	eb 00                	jmp    804501 <insert_sorted_with_merge_freeList+0x444>
  804501:	90                   	nop
  804502:	c9                   	leave  
  804503:	c3                   	ret    

00804504 <__udivdi3>:
  804504:	55                   	push   %ebp
  804505:	57                   	push   %edi
  804506:	56                   	push   %esi
  804507:	53                   	push   %ebx
  804508:	83 ec 1c             	sub    $0x1c,%esp
  80450b:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  80450f:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  804513:	8b 7c 24 38          	mov    0x38(%esp),%edi
  804517:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  80451b:	89 ca                	mov    %ecx,%edx
  80451d:	89 f8                	mov    %edi,%eax
  80451f:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  804523:	85 f6                	test   %esi,%esi
  804525:	75 2d                	jne    804554 <__udivdi3+0x50>
  804527:	39 cf                	cmp    %ecx,%edi
  804529:	77 65                	ja     804590 <__udivdi3+0x8c>
  80452b:	89 fd                	mov    %edi,%ebp
  80452d:	85 ff                	test   %edi,%edi
  80452f:	75 0b                	jne    80453c <__udivdi3+0x38>
  804531:	b8 01 00 00 00       	mov    $0x1,%eax
  804536:	31 d2                	xor    %edx,%edx
  804538:	f7 f7                	div    %edi
  80453a:	89 c5                	mov    %eax,%ebp
  80453c:	31 d2                	xor    %edx,%edx
  80453e:	89 c8                	mov    %ecx,%eax
  804540:	f7 f5                	div    %ebp
  804542:	89 c1                	mov    %eax,%ecx
  804544:	89 d8                	mov    %ebx,%eax
  804546:	f7 f5                	div    %ebp
  804548:	89 cf                	mov    %ecx,%edi
  80454a:	89 fa                	mov    %edi,%edx
  80454c:	83 c4 1c             	add    $0x1c,%esp
  80454f:	5b                   	pop    %ebx
  804550:	5e                   	pop    %esi
  804551:	5f                   	pop    %edi
  804552:	5d                   	pop    %ebp
  804553:	c3                   	ret    
  804554:	39 ce                	cmp    %ecx,%esi
  804556:	77 28                	ja     804580 <__udivdi3+0x7c>
  804558:	0f bd fe             	bsr    %esi,%edi
  80455b:	83 f7 1f             	xor    $0x1f,%edi
  80455e:	75 40                	jne    8045a0 <__udivdi3+0x9c>
  804560:	39 ce                	cmp    %ecx,%esi
  804562:	72 0a                	jb     80456e <__udivdi3+0x6a>
  804564:	3b 44 24 08          	cmp    0x8(%esp),%eax
  804568:	0f 87 9e 00 00 00    	ja     80460c <__udivdi3+0x108>
  80456e:	b8 01 00 00 00       	mov    $0x1,%eax
  804573:	89 fa                	mov    %edi,%edx
  804575:	83 c4 1c             	add    $0x1c,%esp
  804578:	5b                   	pop    %ebx
  804579:	5e                   	pop    %esi
  80457a:	5f                   	pop    %edi
  80457b:	5d                   	pop    %ebp
  80457c:	c3                   	ret    
  80457d:	8d 76 00             	lea    0x0(%esi),%esi
  804580:	31 ff                	xor    %edi,%edi
  804582:	31 c0                	xor    %eax,%eax
  804584:	89 fa                	mov    %edi,%edx
  804586:	83 c4 1c             	add    $0x1c,%esp
  804589:	5b                   	pop    %ebx
  80458a:	5e                   	pop    %esi
  80458b:	5f                   	pop    %edi
  80458c:	5d                   	pop    %ebp
  80458d:	c3                   	ret    
  80458e:	66 90                	xchg   %ax,%ax
  804590:	89 d8                	mov    %ebx,%eax
  804592:	f7 f7                	div    %edi
  804594:	31 ff                	xor    %edi,%edi
  804596:	89 fa                	mov    %edi,%edx
  804598:	83 c4 1c             	add    $0x1c,%esp
  80459b:	5b                   	pop    %ebx
  80459c:	5e                   	pop    %esi
  80459d:	5f                   	pop    %edi
  80459e:	5d                   	pop    %ebp
  80459f:	c3                   	ret    
  8045a0:	bd 20 00 00 00       	mov    $0x20,%ebp
  8045a5:	89 eb                	mov    %ebp,%ebx
  8045a7:	29 fb                	sub    %edi,%ebx
  8045a9:	89 f9                	mov    %edi,%ecx
  8045ab:	d3 e6                	shl    %cl,%esi
  8045ad:	89 c5                	mov    %eax,%ebp
  8045af:	88 d9                	mov    %bl,%cl
  8045b1:	d3 ed                	shr    %cl,%ebp
  8045b3:	89 e9                	mov    %ebp,%ecx
  8045b5:	09 f1                	or     %esi,%ecx
  8045b7:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  8045bb:	89 f9                	mov    %edi,%ecx
  8045bd:	d3 e0                	shl    %cl,%eax
  8045bf:	89 c5                	mov    %eax,%ebp
  8045c1:	89 d6                	mov    %edx,%esi
  8045c3:	88 d9                	mov    %bl,%cl
  8045c5:	d3 ee                	shr    %cl,%esi
  8045c7:	89 f9                	mov    %edi,%ecx
  8045c9:	d3 e2                	shl    %cl,%edx
  8045cb:	8b 44 24 08          	mov    0x8(%esp),%eax
  8045cf:	88 d9                	mov    %bl,%cl
  8045d1:	d3 e8                	shr    %cl,%eax
  8045d3:	09 c2                	or     %eax,%edx
  8045d5:	89 d0                	mov    %edx,%eax
  8045d7:	89 f2                	mov    %esi,%edx
  8045d9:	f7 74 24 0c          	divl   0xc(%esp)
  8045dd:	89 d6                	mov    %edx,%esi
  8045df:	89 c3                	mov    %eax,%ebx
  8045e1:	f7 e5                	mul    %ebp
  8045e3:	39 d6                	cmp    %edx,%esi
  8045e5:	72 19                	jb     804600 <__udivdi3+0xfc>
  8045e7:	74 0b                	je     8045f4 <__udivdi3+0xf0>
  8045e9:	89 d8                	mov    %ebx,%eax
  8045eb:	31 ff                	xor    %edi,%edi
  8045ed:	e9 58 ff ff ff       	jmp    80454a <__udivdi3+0x46>
  8045f2:	66 90                	xchg   %ax,%ax
  8045f4:	8b 54 24 08          	mov    0x8(%esp),%edx
  8045f8:	89 f9                	mov    %edi,%ecx
  8045fa:	d3 e2                	shl    %cl,%edx
  8045fc:	39 c2                	cmp    %eax,%edx
  8045fe:	73 e9                	jae    8045e9 <__udivdi3+0xe5>
  804600:	8d 43 ff             	lea    -0x1(%ebx),%eax
  804603:	31 ff                	xor    %edi,%edi
  804605:	e9 40 ff ff ff       	jmp    80454a <__udivdi3+0x46>
  80460a:	66 90                	xchg   %ax,%ax
  80460c:	31 c0                	xor    %eax,%eax
  80460e:	e9 37 ff ff ff       	jmp    80454a <__udivdi3+0x46>
  804613:	90                   	nop

00804614 <__umoddi3>:
  804614:	55                   	push   %ebp
  804615:	57                   	push   %edi
  804616:	56                   	push   %esi
  804617:	53                   	push   %ebx
  804618:	83 ec 1c             	sub    $0x1c,%esp
  80461b:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  80461f:	8b 74 24 34          	mov    0x34(%esp),%esi
  804623:	8b 7c 24 38          	mov    0x38(%esp),%edi
  804627:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  80462b:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80462f:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  804633:	89 f3                	mov    %esi,%ebx
  804635:	89 fa                	mov    %edi,%edx
  804637:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  80463b:	89 34 24             	mov    %esi,(%esp)
  80463e:	85 c0                	test   %eax,%eax
  804640:	75 1a                	jne    80465c <__umoddi3+0x48>
  804642:	39 f7                	cmp    %esi,%edi
  804644:	0f 86 a2 00 00 00    	jbe    8046ec <__umoddi3+0xd8>
  80464a:	89 c8                	mov    %ecx,%eax
  80464c:	89 f2                	mov    %esi,%edx
  80464e:	f7 f7                	div    %edi
  804650:	89 d0                	mov    %edx,%eax
  804652:	31 d2                	xor    %edx,%edx
  804654:	83 c4 1c             	add    $0x1c,%esp
  804657:	5b                   	pop    %ebx
  804658:	5e                   	pop    %esi
  804659:	5f                   	pop    %edi
  80465a:	5d                   	pop    %ebp
  80465b:	c3                   	ret    
  80465c:	39 f0                	cmp    %esi,%eax
  80465e:	0f 87 ac 00 00 00    	ja     804710 <__umoddi3+0xfc>
  804664:	0f bd e8             	bsr    %eax,%ebp
  804667:	83 f5 1f             	xor    $0x1f,%ebp
  80466a:	0f 84 ac 00 00 00    	je     80471c <__umoddi3+0x108>
  804670:	bf 20 00 00 00       	mov    $0x20,%edi
  804675:	29 ef                	sub    %ebp,%edi
  804677:	89 fe                	mov    %edi,%esi
  804679:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  80467d:	89 e9                	mov    %ebp,%ecx
  80467f:	d3 e0                	shl    %cl,%eax
  804681:	89 d7                	mov    %edx,%edi
  804683:	89 f1                	mov    %esi,%ecx
  804685:	d3 ef                	shr    %cl,%edi
  804687:	09 c7                	or     %eax,%edi
  804689:	89 e9                	mov    %ebp,%ecx
  80468b:	d3 e2                	shl    %cl,%edx
  80468d:	89 14 24             	mov    %edx,(%esp)
  804690:	89 d8                	mov    %ebx,%eax
  804692:	d3 e0                	shl    %cl,%eax
  804694:	89 c2                	mov    %eax,%edx
  804696:	8b 44 24 08          	mov    0x8(%esp),%eax
  80469a:	d3 e0                	shl    %cl,%eax
  80469c:	89 44 24 04          	mov    %eax,0x4(%esp)
  8046a0:	8b 44 24 08          	mov    0x8(%esp),%eax
  8046a4:	89 f1                	mov    %esi,%ecx
  8046a6:	d3 e8                	shr    %cl,%eax
  8046a8:	09 d0                	or     %edx,%eax
  8046aa:	d3 eb                	shr    %cl,%ebx
  8046ac:	89 da                	mov    %ebx,%edx
  8046ae:	f7 f7                	div    %edi
  8046b0:	89 d3                	mov    %edx,%ebx
  8046b2:	f7 24 24             	mull   (%esp)
  8046b5:	89 c6                	mov    %eax,%esi
  8046b7:	89 d1                	mov    %edx,%ecx
  8046b9:	39 d3                	cmp    %edx,%ebx
  8046bb:	0f 82 87 00 00 00    	jb     804748 <__umoddi3+0x134>
  8046c1:	0f 84 91 00 00 00    	je     804758 <__umoddi3+0x144>
  8046c7:	8b 54 24 04          	mov    0x4(%esp),%edx
  8046cb:	29 f2                	sub    %esi,%edx
  8046cd:	19 cb                	sbb    %ecx,%ebx
  8046cf:	89 d8                	mov    %ebx,%eax
  8046d1:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  8046d5:	d3 e0                	shl    %cl,%eax
  8046d7:	89 e9                	mov    %ebp,%ecx
  8046d9:	d3 ea                	shr    %cl,%edx
  8046db:	09 d0                	or     %edx,%eax
  8046dd:	89 e9                	mov    %ebp,%ecx
  8046df:	d3 eb                	shr    %cl,%ebx
  8046e1:	89 da                	mov    %ebx,%edx
  8046e3:	83 c4 1c             	add    $0x1c,%esp
  8046e6:	5b                   	pop    %ebx
  8046e7:	5e                   	pop    %esi
  8046e8:	5f                   	pop    %edi
  8046e9:	5d                   	pop    %ebp
  8046ea:	c3                   	ret    
  8046eb:	90                   	nop
  8046ec:	89 fd                	mov    %edi,%ebp
  8046ee:	85 ff                	test   %edi,%edi
  8046f0:	75 0b                	jne    8046fd <__umoddi3+0xe9>
  8046f2:	b8 01 00 00 00       	mov    $0x1,%eax
  8046f7:	31 d2                	xor    %edx,%edx
  8046f9:	f7 f7                	div    %edi
  8046fb:	89 c5                	mov    %eax,%ebp
  8046fd:	89 f0                	mov    %esi,%eax
  8046ff:	31 d2                	xor    %edx,%edx
  804701:	f7 f5                	div    %ebp
  804703:	89 c8                	mov    %ecx,%eax
  804705:	f7 f5                	div    %ebp
  804707:	89 d0                	mov    %edx,%eax
  804709:	e9 44 ff ff ff       	jmp    804652 <__umoddi3+0x3e>
  80470e:	66 90                	xchg   %ax,%ax
  804710:	89 c8                	mov    %ecx,%eax
  804712:	89 f2                	mov    %esi,%edx
  804714:	83 c4 1c             	add    $0x1c,%esp
  804717:	5b                   	pop    %ebx
  804718:	5e                   	pop    %esi
  804719:	5f                   	pop    %edi
  80471a:	5d                   	pop    %ebp
  80471b:	c3                   	ret    
  80471c:	3b 04 24             	cmp    (%esp),%eax
  80471f:	72 06                	jb     804727 <__umoddi3+0x113>
  804721:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  804725:	77 0f                	ja     804736 <__umoddi3+0x122>
  804727:	89 f2                	mov    %esi,%edx
  804729:	29 f9                	sub    %edi,%ecx
  80472b:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  80472f:	89 14 24             	mov    %edx,(%esp)
  804732:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  804736:	8b 44 24 04          	mov    0x4(%esp),%eax
  80473a:	8b 14 24             	mov    (%esp),%edx
  80473d:	83 c4 1c             	add    $0x1c,%esp
  804740:	5b                   	pop    %ebx
  804741:	5e                   	pop    %esi
  804742:	5f                   	pop    %edi
  804743:	5d                   	pop    %ebp
  804744:	c3                   	ret    
  804745:	8d 76 00             	lea    0x0(%esi),%esi
  804748:	2b 04 24             	sub    (%esp),%eax
  80474b:	19 fa                	sbb    %edi,%edx
  80474d:	89 d1                	mov    %edx,%ecx
  80474f:	89 c6                	mov    %eax,%esi
  804751:	e9 71 ff ff ff       	jmp    8046c7 <__umoddi3+0xb3>
  804756:	66 90                	xchg   %ax,%ax
  804758:	39 44 24 04          	cmp    %eax,0x4(%esp)
  80475c:	72 ea                	jb     804748 <__umoddi3+0x134>
  80475e:	89 d9                	mov    %ebx,%ecx
  804760:	e9 62 ff ff ff       	jmp    8046c7 <__umoddi3+0xb3>
