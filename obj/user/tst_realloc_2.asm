
obj/user/tst_realloc_2:     file format elf32-i386


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
  800031:	e8 b7 12 00 00       	call   8012ed <libmain>
1:      jmp 1b
  800036:	eb fe                	jmp    800036 <args_exist+0x5>

00800038 <_main>:
#include <inc/lib.h>

void _main(void)
{
  800038:	55                   	push   %ebp
  800039:	89 e5                	mov    %esp,%ebp
  80003b:	57                   	push   %edi
  80003c:	53                   	push   %ebx
  80003d:	83 c4 80             	add    $0xffffff80,%esp
	int Mega = 1024*1024;
  800040:	c7 45 e8 00 00 10 00 	movl   $0x100000,-0x18(%ebp)
	int kilo = 1024;
  800047:	c7 45 e4 00 04 00 00 	movl   $0x400,-0x1c(%ebp)
	void* ptr_allocations[20] = {0};
  80004e:	8d 95 78 ff ff ff    	lea    -0x88(%ebp),%edx
  800054:	b9 14 00 00 00       	mov    $0x14,%ecx
  800059:	b8 00 00 00 00       	mov    $0x0,%eax
  80005e:	89 d7                	mov    %edx,%edi
  800060:	f3 ab                	rep stos %eax,%es:(%edi)
	int freeFrames ;
	int usedDiskPages;
	cprintf("realloc: current evaluation = 00%");
  800062:	83 ec 0c             	sub    $0xc,%esp
  800065:	68 80 42 80 00       	push   $0x804280
  80006a:	e8 6e 16 00 00       	call   8016dd <cprintf>
  80006f:	83 c4 10             	add    $0x10,%esp
	//[1] Allocate all
	{
		//Allocate 1 MB
		freeFrames = sys_calculate_free_frames() ;
  800072:	e8 04 2a 00 00       	call   802a7b <sys_calculate_free_frames>
  800077:	89 45 e0             	mov    %eax,-0x20(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  80007a:	e8 9c 2a 00 00       	call   802b1b <sys_pf_calculate_allocated_pages>
  80007f:	89 45 dc             	mov    %eax,-0x24(%ebp)
		ptr_allocations[0] = malloc(1*Mega-kilo);
  800082:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800085:	2b 45 e4             	sub    -0x1c(%ebp),%eax
  800088:	83 ec 0c             	sub    $0xc,%esp
  80008b:	50                   	push   %eax
  80008c:	e8 de 25 00 00       	call   80266f <malloc>
  800091:	83 c4 10             	add    $0x10,%esp
  800094:	89 85 78 ff ff ff    	mov    %eax,-0x88(%ebp)
		if ((uint32) ptr_allocations[0] !=  (USER_HEAP_START)) panic("Wrong start address for the allocated space... ");
  80009a:	8b 85 78 ff ff ff    	mov    -0x88(%ebp),%eax
  8000a0:	3d 00 00 00 80       	cmp    $0x80000000,%eax
  8000a5:	74 14                	je     8000bb <_main+0x83>
  8000a7:	83 ec 04             	sub    $0x4,%esp
  8000aa:	68 a4 42 80 00       	push   $0x8042a4
  8000af:	6a 11                	push   $0x11
  8000b1:	68 d4 42 80 00       	push   $0x8042d4
  8000b6:	e8 6e 13 00 00       	call   801429 <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 256+1 ) panic("Wrong allocation: ");
		if((freeFrames - sys_calculate_free_frames()) != 1) panic("Wrong allocation: either extra pages are allocated in memory or pages not allocated correctly on PageFile");
  8000bb:	8b 5d e0             	mov    -0x20(%ebp),%ebx
  8000be:	e8 b8 29 00 00       	call   802a7b <sys_calculate_free_frames>
  8000c3:	29 c3                	sub    %eax,%ebx
  8000c5:	89 d8                	mov    %ebx,%eax
  8000c7:	83 f8 01             	cmp    $0x1,%eax
  8000ca:	74 14                	je     8000e0 <_main+0xa8>
  8000cc:	83 ec 04             	sub    $0x4,%esp
  8000cf:	68 ec 42 80 00       	push   $0x8042ec
  8000d4:	6a 13                	push   $0x13
  8000d6:	68 d4 42 80 00       	push   $0x8042d4
  8000db:	e8 49 13 00 00       	call   801429 <_panic>
		if((sys_pf_calculate_allocated_pages() - usedDiskPages) != 256) panic("Extra or less pages are allocated in PageFile");
  8000e0:	e8 36 2a 00 00       	call   802b1b <sys_pf_calculate_allocated_pages>
  8000e5:	2b 45 dc             	sub    -0x24(%ebp),%eax
  8000e8:	3d 00 01 00 00       	cmp    $0x100,%eax
  8000ed:	74 14                	je     800103 <_main+0xcb>
  8000ef:	83 ec 04             	sub    $0x4,%esp
  8000f2:	68 58 43 80 00       	push   $0x804358
  8000f7:	6a 14                	push   $0x14
  8000f9:	68 d4 42 80 00       	push   $0x8042d4
  8000fe:	e8 26 13 00 00       	call   801429 <_panic>

		//Allocate 1 MB
		freeFrames = sys_calculate_free_frames() ;
  800103:	e8 73 29 00 00       	call   802a7b <sys_calculate_free_frames>
  800108:	89 45 e0             	mov    %eax,-0x20(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  80010b:	e8 0b 2a 00 00       	call   802b1b <sys_pf_calculate_allocated_pages>
  800110:	89 45 dc             	mov    %eax,-0x24(%ebp)
		ptr_allocations[1] = malloc(1*Mega-kilo);
  800113:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800116:	2b 45 e4             	sub    -0x1c(%ebp),%eax
  800119:	83 ec 0c             	sub    $0xc,%esp
  80011c:	50                   	push   %eax
  80011d:	e8 4d 25 00 00       	call   80266f <malloc>
  800122:	83 c4 10             	add    $0x10,%esp
  800125:	89 85 7c ff ff ff    	mov    %eax,-0x84(%ebp)
		if ((uint32) ptr_allocations[1] !=  (USER_HEAP_START + 1*Mega)) panic("Wrong start address for the allocated space... ");
  80012b:	8b 85 7c ff ff ff    	mov    -0x84(%ebp),%eax
  800131:	89 c2                	mov    %eax,%edx
  800133:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800136:	05 00 00 00 80       	add    $0x80000000,%eax
  80013b:	39 c2                	cmp    %eax,%edx
  80013d:	74 14                	je     800153 <_main+0x11b>
  80013f:	83 ec 04             	sub    $0x4,%esp
  800142:	68 a4 42 80 00       	push   $0x8042a4
  800147:	6a 1a                	push   $0x1a
  800149:	68 d4 42 80 00       	push   $0x8042d4
  80014e:	e8 d6 12 00 00       	call   801429 <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 256 ) panic("Wrong allocation: ");
		if((freeFrames - sys_calculate_free_frames()) != 0) panic("Wrong allocation: either extra pages are allocated in memory or pages not allocated correctly on PageFile");
  800153:	e8 23 29 00 00       	call   802a7b <sys_calculate_free_frames>
  800158:	89 c2                	mov    %eax,%edx
  80015a:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80015d:	39 c2                	cmp    %eax,%edx
  80015f:	74 14                	je     800175 <_main+0x13d>
  800161:	83 ec 04             	sub    $0x4,%esp
  800164:	68 ec 42 80 00       	push   $0x8042ec
  800169:	6a 1c                	push   $0x1c
  80016b:	68 d4 42 80 00       	push   $0x8042d4
  800170:	e8 b4 12 00 00       	call   801429 <_panic>
		if((sys_pf_calculate_allocated_pages() - usedDiskPages) != 256) panic("Extra or less pages are allocated in PageFile");
  800175:	e8 a1 29 00 00       	call   802b1b <sys_pf_calculate_allocated_pages>
  80017a:	2b 45 dc             	sub    -0x24(%ebp),%eax
  80017d:	3d 00 01 00 00       	cmp    $0x100,%eax
  800182:	74 14                	je     800198 <_main+0x160>
  800184:	83 ec 04             	sub    $0x4,%esp
  800187:	68 58 43 80 00       	push   $0x804358
  80018c:	6a 1d                	push   $0x1d
  80018e:	68 d4 42 80 00       	push   $0x8042d4
  800193:	e8 91 12 00 00       	call   801429 <_panic>

		//Allocate 1 MB
		freeFrames = sys_calculate_free_frames() ;
  800198:	e8 de 28 00 00       	call   802a7b <sys_calculate_free_frames>
  80019d:	89 45 e0             	mov    %eax,-0x20(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  8001a0:	e8 76 29 00 00       	call   802b1b <sys_pf_calculate_allocated_pages>
  8001a5:	89 45 dc             	mov    %eax,-0x24(%ebp)
		ptr_allocations[2] = malloc(1*Mega-kilo);
  8001a8:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8001ab:	2b 45 e4             	sub    -0x1c(%ebp),%eax
  8001ae:	83 ec 0c             	sub    $0xc,%esp
  8001b1:	50                   	push   %eax
  8001b2:	e8 b8 24 00 00       	call   80266f <malloc>
  8001b7:	83 c4 10             	add    $0x10,%esp
  8001ba:	89 45 80             	mov    %eax,-0x80(%ebp)
		if ((uint32) ptr_allocations[2] !=  (USER_HEAP_START + 2*Mega)) panic("Wrong start address for the allocated space... ");
  8001bd:	8b 45 80             	mov    -0x80(%ebp),%eax
  8001c0:	89 c2                	mov    %eax,%edx
  8001c2:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8001c5:	01 c0                	add    %eax,%eax
  8001c7:	05 00 00 00 80       	add    $0x80000000,%eax
  8001cc:	39 c2                	cmp    %eax,%edx
  8001ce:	74 14                	je     8001e4 <_main+0x1ac>
  8001d0:	83 ec 04             	sub    $0x4,%esp
  8001d3:	68 a4 42 80 00       	push   $0x8042a4
  8001d8:	6a 23                	push   $0x23
  8001da:	68 d4 42 80 00       	push   $0x8042d4
  8001df:	e8 45 12 00 00       	call   801429 <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 256 ) panic("Wrong allocation: ");
		if((freeFrames - sys_calculate_free_frames()) != 0) panic("Wrong allocation: either extra pages are allocated in memory or pages not allocated correctly on PageFile");
  8001e4:	e8 92 28 00 00       	call   802a7b <sys_calculate_free_frames>
  8001e9:	89 c2                	mov    %eax,%edx
  8001eb:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8001ee:	39 c2                	cmp    %eax,%edx
  8001f0:	74 14                	je     800206 <_main+0x1ce>
  8001f2:	83 ec 04             	sub    $0x4,%esp
  8001f5:	68 ec 42 80 00       	push   $0x8042ec
  8001fa:	6a 25                	push   $0x25
  8001fc:	68 d4 42 80 00       	push   $0x8042d4
  800201:	e8 23 12 00 00       	call   801429 <_panic>
		if((sys_pf_calculate_allocated_pages() - usedDiskPages) != 256) panic("Extra or less pages are allocated in PageFile");
  800206:	e8 10 29 00 00       	call   802b1b <sys_pf_calculate_allocated_pages>
  80020b:	2b 45 dc             	sub    -0x24(%ebp),%eax
  80020e:	3d 00 01 00 00       	cmp    $0x100,%eax
  800213:	74 14                	je     800229 <_main+0x1f1>
  800215:	83 ec 04             	sub    $0x4,%esp
  800218:	68 58 43 80 00       	push   $0x804358
  80021d:	6a 26                	push   $0x26
  80021f:	68 d4 42 80 00       	push   $0x8042d4
  800224:	e8 00 12 00 00       	call   801429 <_panic>

		//Allocate 1 MB
		freeFrames = sys_calculate_free_frames() ;
  800229:	e8 4d 28 00 00       	call   802a7b <sys_calculate_free_frames>
  80022e:	89 45 e0             	mov    %eax,-0x20(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  800231:	e8 e5 28 00 00       	call   802b1b <sys_pf_calculate_allocated_pages>
  800236:	89 45 dc             	mov    %eax,-0x24(%ebp)
		ptr_allocations[3] = malloc(1*Mega-kilo);
  800239:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80023c:	2b 45 e4             	sub    -0x1c(%ebp),%eax
  80023f:	83 ec 0c             	sub    $0xc,%esp
  800242:	50                   	push   %eax
  800243:	e8 27 24 00 00       	call   80266f <malloc>
  800248:	83 c4 10             	add    $0x10,%esp
  80024b:	89 45 84             	mov    %eax,-0x7c(%ebp)
		if ((uint32) ptr_allocations[3] !=  (USER_HEAP_START + 3*Mega)) panic("Wrong start address for the allocated space... ");
  80024e:	8b 45 84             	mov    -0x7c(%ebp),%eax
  800251:	89 c1                	mov    %eax,%ecx
  800253:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800256:	89 c2                	mov    %eax,%edx
  800258:	01 d2                	add    %edx,%edx
  80025a:	01 d0                	add    %edx,%eax
  80025c:	05 00 00 00 80       	add    $0x80000000,%eax
  800261:	39 c1                	cmp    %eax,%ecx
  800263:	74 14                	je     800279 <_main+0x241>
  800265:	83 ec 04             	sub    $0x4,%esp
  800268:	68 a4 42 80 00       	push   $0x8042a4
  80026d:	6a 2c                	push   $0x2c
  80026f:	68 d4 42 80 00       	push   $0x8042d4
  800274:	e8 b0 11 00 00       	call   801429 <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 256 ) panic("Wrong allocation: ");
		if((freeFrames - sys_calculate_free_frames()) != 0) panic("Wrong allocation: either extra pages are allocated in memory or pages not allocated correctly on PageFile");
  800279:	e8 fd 27 00 00       	call   802a7b <sys_calculate_free_frames>
  80027e:	89 c2                	mov    %eax,%edx
  800280:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800283:	39 c2                	cmp    %eax,%edx
  800285:	74 14                	je     80029b <_main+0x263>
  800287:	83 ec 04             	sub    $0x4,%esp
  80028a:	68 ec 42 80 00       	push   $0x8042ec
  80028f:	6a 2e                	push   $0x2e
  800291:	68 d4 42 80 00       	push   $0x8042d4
  800296:	e8 8e 11 00 00       	call   801429 <_panic>
		if((sys_pf_calculate_allocated_pages() - usedDiskPages) != 256) panic("Extra or less pages are allocated in PageFile");
  80029b:	e8 7b 28 00 00       	call   802b1b <sys_pf_calculate_allocated_pages>
  8002a0:	2b 45 dc             	sub    -0x24(%ebp),%eax
  8002a3:	3d 00 01 00 00       	cmp    $0x100,%eax
  8002a8:	74 14                	je     8002be <_main+0x286>
  8002aa:	83 ec 04             	sub    $0x4,%esp
  8002ad:	68 58 43 80 00       	push   $0x804358
  8002b2:	6a 2f                	push   $0x2f
  8002b4:	68 d4 42 80 00       	push   $0x8042d4
  8002b9:	e8 6b 11 00 00       	call   801429 <_panic>

		//Allocate 2 MB
		freeFrames = sys_calculate_free_frames() ;
  8002be:	e8 b8 27 00 00       	call   802a7b <sys_calculate_free_frames>
  8002c3:	89 45 e0             	mov    %eax,-0x20(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  8002c6:	e8 50 28 00 00       	call   802b1b <sys_pf_calculate_allocated_pages>
  8002cb:	89 45 dc             	mov    %eax,-0x24(%ebp)
		ptr_allocations[4] = malloc(2*Mega-kilo);
  8002ce:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8002d1:	01 c0                	add    %eax,%eax
  8002d3:	2b 45 e4             	sub    -0x1c(%ebp),%eax
  8002d6:	83 ec 0c             	sub    $0xc,%esp
  8002d9:	50                   	push   %eax
  8002da:	e8 90 23 00 00       	call   80266f <malloc>
  8002df:	83 c4 10             	add    $0x10,%esp
  8002e2:	89 45 88             	mov    %eax,-0x78(%ebp)
		if ((uint32) ptr_allocations[4] !=  (USER_HEAP_START + 4*Mega)) panic("Wrong start address for the allocated space... ");
  8002e5:	8b 45 88             	mov    -0x78(%ebp),%eax
  8002e8:	89 c2                	mov    %eax,%edx
  8002ea:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8002ed:	c1 e0 02             	shl    $0x2,%eax
  8002f0:	05 00 00 00 80       	add    $0x80000000,%eax
  8002f5:	39 c2                	cmp    %eax,%edx
  8002f7:	74 14                	je     80030d <_main+0x2d5>
  8002f9:	83 ec 04             	sub    $0x4,%esp
  8002fc:	68 a4 42 80 00       	push   $0x8042a4
  800301:	6a 35                	push   $0x35
  800303:	68 d4 42 80 00       	push   $0x8042d4
  800308:	e8 1c 11 00 00       	call   801429 <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 512 + 1) panic("Wrong allocation: ");
		if((freeFrames - sys_calculate_free_frames()) != 1) panic("Wrong allocation: either extra pages are allocated in memory or pages not allocated correctly on PageFile");
  80030d:	8b 5d e0             	mov    -0x20(%ebp),%ebx
  800310:	e8 66 27 00 00       	call   802a7b <sys_calculate_free_frames>
  800315:	29 c3                	sub    %eax,%ebx
  800317:	89 d8                	mov    %ebx,%eax
  800319:	83 f8 01             	cmp    $0x1,%eax
  80031c:	74 14                	je     800332 <_main+0x2fa>
  80031e:	83 ec 04             	sub    $0x4,%esp
  800321:	68 ec 42 80 00       	push   $0x8042ec
  800326:	6a 37                	push   $0x37
  800328:	68 d4 42 80 00       	push   $0x8042d4
  80032d:	e8 f7 10 00 00       	call   801429 <_panic>
		if((sys_pf_calculate_allocated_pages() - usedDiskPages) != 512) panic("Extra or less pages are allocated in PageFile");
  800332:	e8 e4 27 00 00       	call   802b1b <sys_pf_calculate_allocated_pages>
  800337:	2b 45 dc             	sub    -0x24(%ebp),%eax
  80033a:	3d 00 02 00 00       	cmp    $0x200,%eax
  80033f:	74 14                	je     800355 <_main+0x31d>
  800341:	83 ec 04             	sub    $0x4,%esp
  800344:	68 58 43 80 00       	push   $0x804358
  800349:	6a 38                	push   $0x38
  80034b:	68 d4 42 80 00       	push   $0x8042d4
  800350:	e8 d4 10 00 00       	call   801429 <_panic>

		//Allocate 2 MB
		freeFrames = sys_calculate_free_frames() ;
  800355:	e8 21 27 00 00       	call   802a7b <sys_calculate_free_frames>
  80035a:	89 45 e0             	mov    %eax,-0x20(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  80035d:	e8 b9 27 00 00       	call   802b1b <sys_pf_calculate_allocated_pages>
  800362:	89 45 dc             	mov    %eax,-0x24(%ebp)
		ptr_allocations[5] = malloc(2*Mega-kilo);
  800365:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800368:	01 c0                	add    %eax,%eax
  80036a:	2b 45 e4             	sub    -0x1c(%ebp),%eax
  80036d:	83 ec 0c             	sub    $0xc,%esp
  800370:	50                   	push   %eax
  800371:	e8 f9 22 00 00       	call   80266f <malloc>
  800376:	83 c4 10             	add    $0x10,%esp
  800379:	89 45 8c             	mov    %eax,-0x74(%ebp)
		if ((uint32) ptr_allocations[5] !=  (USER_HEAP_START + 6*Mega)) panic("Wrong start address for the allocated space... ");
  80037c:	8b 45 8c             	mov    -0x74(%ebp),%eax
  80037f:	89 c1                	mov    %eax,%ecx
  800381:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800384:	89 d0                	mov    %edx,%eax
  800386:	01 c0                	add    %eax,%eax
  800388:	01 d0                	add    %edx,%eax
  80038a:	01 c0                	add    %eax,%eax
  80038c:	05 00 00 00 80       	add    $0x80000000,%eax
  800391:	39 c1                	cmp    %eax,%ecx
  800393:	74 14                	je     8003a9 <_main+0x371>
  800395:	83 ec 04             	sub    $0x4,%esp
  800398:	68 a4 42 80 00       	push   $0x8042a4
  80039d:	6a 3e                	push   $0x3e
  80039f:	68 d4 42 80 00       	push   $0x8042d4
  8003a4:	e8 80 10 00 00       	call   801429 <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 512) panic("Wrong allocation: ");
		if((freeFrames - sys_calculate_free_frames()) != 0) panic("Wrong allocation: either extra pages are allocated in memory or pages not allocated correctly on PageFile");
  8003a9:	e8 cd 26 00 00       	call   802a7b <sys_calculate_free_frames>
  8003ae:	89 c2                	mov    %eax,%edx
  8003b0:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8003b3:	39 c2                	cmp    %eax,%edx
  8003b5:	74 14                	je     8003cb <_main+0x393>
  8003b7:	83 ec 04             	sub    $0x4,%esp
  8003ba:	68 ec 42 80 00       	push   $0x8042ec
  8003bf:	6a 40                	push   $0x40
  8003c1:	68 d4 42 80 00       	push   $0x8042d4
  8003c6:	e8 5e 10 00 00       	call   801429 <_panic>
		if((sys_pf_calculate_allocated_pages() - usedDiskPages) != 512) panic("Extra or less pages are allocated in PageFile");
  8003cb:	e8 4b 27 00 00       	call   802b1b <sys_pf_calculate_allocated_pages>
  8003d0:	2b 45 dc             	sub    -0x24(%ebp),%eax
  8003d3:	3d 00 02 00 00       	cmp    $0x200,%eax
  8003d8:	74 14                	je     8003ee <_main+0x3b6>
  8003da:	83 ec 04             	sub    $0x4,%esp
  8003dd:	68 58 43 80 00       	push   $0x804358
  8003e2:	6a 41                	push   $0x41
  8003e4:	68 d4 42 80 00       	push   $0x8042d4
  8003e9:	e8 3b 10 00 00       	call   801429 <_panic>

		//Allocate 3 MB
		freeFrames = sys_calculate_free_frames() ;
  8003ee:	e8 88 26 00 00       	call   802a7b <sys_calculate_free_frames>
  8003f3:	89 45 e0             	mov    %eax,-0x20(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  8003f6:	e8 20 27 00 00       	call   802b1b <sys_pf_calculate_allocated_pages>
  8003fb:	89 45 dc             	mov    %eax,-0x24(%ebp)
		ptr_allocations[6] = malloc(3*Mega-kilo);
  8003fe:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800401:	89 c2                	mov    %eax,%edx
  800403:	01 d2                	add    %edx,%edx
  800405:	01 d0                	add    %edx,%eax
  800407:	2b 45 e4             	sub    -0x1c(%ebp),%eax
  80040a:	83 ec 0c             	sub    $0xc,%esp
  80040d:	50                   	push   %eax
  80040e:	e8 5c 22 00 00       	call   80266f <malloc>
  800413:	83 c4 10             	add    $0x10,%esp
  800416:	89 45 90             	mov    %eax,-0x70(%ebp)
		if ((uint32) ptr_allocations[6] !=  (USER_HEAP_START + 8*Mega)) panic("Wrong start address for the allocated space... ");
  800419:	8b 45 90             	mov    -0x70(%ebp),%eax
  80041c:	89 c2                	mov    %eax,%edx
  80041e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800421:	c1 e0 03             	shl    $0x3,%eax
  800424:	05 00 00 00 80       	add    $0x80000000,%eax
  800429:	39 c2                	cmp    %eax,%edx
  80042b:	74 14                	je     800441 <_main+0x409>
  80042d:	83 ec 04             	sub    $0x4,%esp
  800430:	68 a4 42 80 00       	push   $0x8042a4
  800435:	6a 47                	push   $0x47
  800437:	68 d4 42 80 00       	push   $0x8042d4
  80043c:	e8 e8 0f 00 00       	call   801429 <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 768 + 1) panic("Wrong allocation: ");
		if((freeFrames - sys_calculate_free_frames()) != 1) panic("Wrong allocation: either extra pages are allocated in memory or pages not allocated correctly on PageFile");
  800441:	8b 5d e0             	mov    -0x20(%ebp),%ebx
  800444:	e8 32 26 00 00       	call   802a7b <sys_calculate_free_frames>
  800449:	29 c3                	sub    %eax,%ebx
  80044b:	89 d8                	mov    %ebx,%eax
  80044d:	83 f8 01             	cmp    $0x1,%eax
  800450:	74 14                	je     800466 <_main+0x42e>
  800452:	83 ec 04             	sub    $0x4,%esp
  800455:	68 ec 42 80 00       	push   $0x8042ec
  80045a:	6a 49                	push   $0x49
  80045c:	68 d4 42 80 00       	push   $0x8042d4
  800461:	e8 c3 0f 00 00       	call   801429 <_panic>
		if((sys_pf_calculate_allocated_pages() - usedDiskPages) != 768) panic("Extra or less pages are allocated in PageFile");
  800466:	e8 b0 26 00 00       	call   802b1b <sys_pf_calculate_allocated_pages>
  80046b:	2b 45 dc             	sub    -0x24(%ebp),%eax
  80046e:	3d 00 03 00 00       	cmp    $0x300,%eax
  800473:	74 14                	je     800489 <_main+0x451>
  800475:	83 ec 04             	sub    $0x4,%esp
  800478:	68 58 43 80 00       	push   $0x804358
  80047d:	6a 4a                	push   $0x4a
  80047f:	68 d4 42 80 00       	push   $0x8042d4
  800484:	e8 a0 0f 00 00       	call   801429 <_panic>

		//Allocate 3 MB
		freeFrames = sys_calculate_free_frames() ;
  800489:	e8 ed 25 00 00       	call   802a7b <sys_calculate_free_frames>
  80048e:	89 45 e0             	mov    %eax,-0x20(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  800491:	e8 85 26 00 00       	call   802b1b <sys_pf_calculate_allocated_pages>
  800496:	89 45 dc             	mov    %eax,-0x24(%ebp)
		ptr_allocations[7] = malloc(3*Mega-kilo);
  800499:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80049c:	89 c2                	mov    %eax,%edx
  80049e:	01 d2                	add    %edx,%edx
  8004a0:	01 d0                	add    %edx,%eax
  8004a2:	2b 45 e4             	sub    -0x1c(%ebp),%eax
  8004a5:	83 ec 0c             	sub    $0xc,%esp
  8004a8:	50                   	push   %eax
  8004a9:	e8 c1 21 00 00       	call   80266f <malloc>
  8004ae:	83 c4 10             	add    $0x10,%esp
  8004b1:	89 45 94             	mov    %eax,-0x6c(%ebp)
		if ((uint32) ptr_allocations[7] !=  (USER_HEAP_START + 11*Mega)) panic("Wrong start address for the allocated space... ");
  8004b4:	8b 45 94             	mov    -0x6c(%ebp),%eax
  8004b7:	89 c1                	mov    %eax,%ecx
  8004b9:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8004bc:	89 d0                	mov    %edx,%eax
  8004be:	c1 e0 02             	shl    $0x2,%eax
  8004c1:	01 d0                	add    %edx,%eax
  8004c3:	01 c0                	add    %eax,%eax
  8004c5:	01 d0                	add    %edx,%eax
  8004c7:	05 00 00 00 80       	add    $0x80000000,%eax
  8004cc:	39 c1                	cmp    %eax,%ecx
  8004ce:	74 14                	je     8004e4 <_main+0x4ac>
  8004d0:	83 ec 04             	sub    $0x4,%esp
  8004d3:	68 a4 42 80 00       	push   $0x8042a4
  8004d8:	6a 50                	push   $0x50
  8004da:	68 d4 42 80 00       	push   $0x8042d4
  8004df:	e8 45 0f 00 00       	call   801429 <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 768 + 1) panic("Wrong allocation: ");
		if((freeFrames - sys_calculate_free_frames()) != 1) panic("Wrong allocation: either extra pages are allocated in memory or pages not allocated correctly on PageFile");
  8004e4:	8b 5d e0             	mov    -0x20(%ebp),%ebx
  8004e7:	e8 8f 25 00 00       	call   802a7b <sys_calculate_free_frames>
  8004ec:	29 c3                	sub    %eax,%ebx
  8004ee:	89 d8                	mov    %ebx,%eax
  8004f0:	83 f8 01             	cmp    $0x1,%eax
  8004f3:	74 14                	je     800509 <_main+0x4d1>
  8004f5:	83 ec 04             	sub    $0x4,%esp
  8004f8:	68 ec 42 80 00       	push   $0x8042ec
  8004fd:	6a 52                	push   $0x52
  8004ff:	68 d4 42 80 00       	push   $0x8042d4
  800504:	e8 20 0f 00 00       	call   801429 <_panic>
		if((sys_pf_calculate_allocated_pages() - usedDiskPages) != 768) panic("Extra or less pages are allocated in PageFile");
  800509:	e8 0d 26 00 00       	call   802b1b <sys_pf_calculate_allocated_pages>
  80050e:	2b 45 dc             	sub    -0x24(%ebp),%eax
  800511:	3d 00 03 00 00       	cmp    $0x300,%eax
  800516:	74 14                	je     80052c <_main+0x4f4>
  800518:	83 ec 04             	sub    $0x4,%esp
  80051b:	68 58 43 80 00       	push   $0x804358
  800520:	6a 53                	push   $0x53
  800522:	68 d4 42 80 00       	push   $0x8042d4
  800527:	e8 fd 0e 00 00       	call   801429 <_panic>

		//Allocate the remaining space in user heap
		freeFrames = sys_calculate_free_frames() ;
  80052c:	e8 4a 25 00 00       	call   802a7b <sys_calculate_free_frames>
  800531:	89 45 e0             	mov    %eax,-0x20(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  800534:	e8 e2 25 00 00       	call   802b1b <sys_pf_calculate_allocated_pages>
  800539:	89 45 dc             	mov    %eax,-0x24(%ebp)
		ptr_allocations[8] = malloc((USER_HEAP_MAX - USER_HEAP_START) - 14 * Mega - kilo);
  80053c:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80053f:	89 d0                	mov    %edx,%eax
  800541:	01 c0                	add    %eax,%eax
  800543:	01 d0                	add    %edx,%eax
  800545:	01 c0                	add    %eax,%eax
  800547:	01 d0                	add    %edx,%eax
  800549:	01 c0                	add    %eax,%eax
  80054b:	f7 d8                	neg    %eax
  80054d:	89 c2                	mov    %eax,%edx
  80054f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800552:	29 c2                	sub    %eax,%edx
  800554:	89 d0                	mov    %edx,%eax
  800556:	05 00 00 00 20       	add    $0x20000000,%eax
  80055b:	83 ec 0c             	sub    $0xc,%esp
  80055e:	50                   	push   %eax
  80055f:	e8 0b 21 00 00       	call   80266f <malloc>
  800564:	83 c4 10             	add    $0x10,%esp
  800567:	89 45 98             	mov    %eax,-0x68(%ebp)
		if ((uint32) ptr_allocations[8] !=  (USER_HEAP_START + 14*Mega)) panic("Wrong start address for the allocated space... ");
  80056a:	8b 45 98             	mov    -0x68(%ebp),%eax
  80056d:	89 c1                	mov    %eax,%ecx
  80056f:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800572:	89 d0                	mov    %edx,%eax
  800574:	01 c0                	add    %eax,%eax
  800576:	01 d0                	add    %edx,%eax
  800578:	01 c0                	add    %eax,%eax
  80057a:	01 d0                	add    %edx,%eax
  80057c:	01 c0                	add    %eax,%eax
  80057e:	05 00 00 00 80       	add    $0x80000000,%eax
  800583:	39 c1                	cmp    %eax,%ecx
  800585:	74 14                	je     80059b <_main+0x563>
  800587:	83 ec 04             	sub    $0x4,%esp
  80058a:	68 a4 42 80 00       	push   $0x8042a4
  80058f:	6a 59                	push   $0x59
  800591:	68 d4 42 80 00       	push   $0x8042d4
  800596:	e8 8e 0e 00 00       	call   801429 <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 768 + 1) panic("Wrong allocation: ");
		if((freeFrames - sys_calculate_free_frames()) != 124) panic("Wrong allocation: either extra pages are allocated in memory or pages not allocated correctly on PageFile");
  80059b:	8b 5d e0             	mov    -0x20(%ebp),%ebx
  80059e:	e8 d8 24 00 00       	call   802a7b <sys_calculate_free_frames>
  8005a3:	29 c3                	sub    %eax,%ebx
  8005a5:	89 d8                	mov    %ebx,%eax
  8005a7:	83 f8 7c             	cmp    $0x7c,%eax
  8005aa:	74 14                	je     8005c0 <_main+0x588>
  8005ac:	83 ec 04             	sub    $0x4,%esp
  8005af:	68 ec 42 80 00       	push   $0x8042ec
  8005b4:	6a 5b                	push   $0x5b
  8005b6:	68 d4 42 80 00       	push   $0x8042d4
  8005bb:	e8 69 0e 00 00       	call   801429 <_panic>
		if((sys_pf_calculate_allocated_pages() - usedDiskPages) != 127488) panic("Extra or less pages are allocated in PageFile");
  8005c0:	e8 56 25 00 00       	call   802b1b <sys_pf_calculate_allocated_pages>
  8005c5:	2b 45 dc             	sub    -0x24(%ebp),%eax
  8005c8:	3d 00 f2 01 00       	cmp    $0x1f200,%eax
  8005cd:	74 14                	je     8005e3 <_main+0x5ab>
  8005cf:	83 ec 04             	sub    $0x4,%esp
  8005d2:	68 58 43 80 00       	push   $0x804358
  8005d7:	6a 5c                	push   $0x5c
  8005d9:	68 d4 42 80 00       	push   $0x8042d4
  8005de:	e8 46 0e 00 00       	call   801429 <_panic>
	}

	//[2] Free some to create holes
	{
		//1 MB Hole
		freeFrames = sys_calculate_free_frames() ;
  8005e3:	e8 93 24 00 00       	call   802a7b <sys_calculate_free_frames>
  8005e8:	89 45 e0             	mov    %eax,-0x20(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  8005eb:	e8 2b 25 00 00       	call   802b1b <sys_pf_calculate_allocated_pages>
  8005f0:	89 45 dc             	mov    %eax,-0x24(%ebp)
		free(ptr_allocations[1]);
  8005f3:	8b 85 7c ff ff ff    	mov    -0x84(%ebp),%eax
  8005f9:	83 ec 0c             	sub    $0xc,%esp
  8005fc:	50                   	push   %eax
  8005fd:	e8 ee 20 00 00       	call   8026f0 <free>
  800602:	83 c4 10             	add    $0x10,%esp
		//if ((sys_calculate_free_frames() - freeFrames) != 256) panic("Wrong free: ");
		if ((usedDiskPages - sys_pf_calculate_allocated_pages()) != 256) panic("Wrong free: Extra or less pages are removed from PageFile");
  800605:	e8 11 25 00 00       	call   802b1b <sys_pf_calculate_allocated_pages>
  80060a:	8b 55 dc             	mov    -0x24(%ebp),%edx
  80060d:	29 c2                	sub    %eax,%edx
  80060f:	89 d0                	mov    %edx,%eax
  800611:	3d 00 01 00 00       	cmp    $0x100,%eax
  800616:	74 14                	je     80062c <_main+0x5f4>
  800618:	83 ec 04             	sub    $0x4,%esp
  80061b:	68 88 43 80 00       	push   $0x804388
  800620:	6a 67                	push   $0x67
  800622:	68 d4 42 80 00       	push   $0x8042d4
  800627:	e8 fd 0d 00 00       	call   801429 <_panic>
		if ((sys_calculate_free_frames() - freeFrames) != 0) panic("Wrong free: WS pages in memory and/or page tables are not freed correctly");
  80062c:	e8 4a 24 00 00       	call   802a7b <sys_calculate_free_frames>
  800631:	89 c2                	mov    %eax,%edx
  800633:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800636:	39 c2                	cmp    %eax,%edx
  800638:	74 14                	je     80064e <_main+0x616>
  80063a:	83 ec 04             	sub    $0x4,%esp
  80063d:	68 c4 43 80 00       	push   $0x8043c4
  800642:	6a 68                	push   $0x68
  800644:	68 d4 42 80 00       	push   $0x8042d4
  800649:	e8 db 0d 00 00       	call   801429 <_panic>

		//2 MB Hole
		freeFrames = sys_calculate_free_frames() ;
  80064e:	e8 28 24 00 00       	call   802a7b <sys_calculate_free_frames>
  800653:	89 45 e0             	mov    %eax,-0x20(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  800656:	e8 c0 24 00 00       	call   802b1b <sys_pf_calculate_allocated_pages>
  80065b:	89 45 dc             	mov    %eax,-0x24(%ebp)
		free(ptr_allocations[4]);
  80065e:	8b 45 88             	mov    -0x78(%ebp),%eax
  800661:	83 ec 0c             	sub    $0xc,%esp
  800664:	50                   	push   %eax
  800665:	e8 86 20 00 00       	call   8026f0 <free>
  80066a:	83 c4 10             	add    $0x10,%esp
		//if ((sys_calculate_free_frames() - freeFrames) != 512) panic("Wrong free: ");
		if ((usedDiskPages - sys_pf_calculate_allocated_pages()) != 512) panic("Wrong free: Extra or less pages are removed from PageFile");
  80066d:	e8 a9 24 00 00       	call   802b1b <sys_pf_calculate_allocated_pages>
  800672:	8b 55 dc             	mov    -0x24(%ebp),%edx
  800675:	29 c2                	sub    %eax,%edx
  800677:	89 d0                	mov    %edx,%eax
  800679:	3d 00 02 00 00       	cmp    $0x200,%eax
  80067e:	74 14                	je     800694 <_main+0x65c>
  800680:	83 ec 04             	sub    $0x4,%esp
  800683:	68 88 43 80 00       	push   $0x804388
  800688:	6a 6f                	push   $0x6f
  80068a:	68 d4 42 80 00       	push   $0x8042d4
  80068f:	e8 95 0d 00 00       	call   801429 <_panic>
		if ((sys_calculate_free_frames() - freeFrames) != 0) panic("Wrong free: WS pages in memory and/or page tables are not freed correctly");
  800694:	e8 e2 23 00 00       	call   802a7b <sys_calculate_free_frames>
  800699:	89 c2                	mov    %eax,%edx
  80069b:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80069e:	39 c2                	cmp    %eax,%edx
  8006a0:	74 14                	je     8006b6 <_main+0x67e>
  8006a2:	83 ec 04             	sub    $0x4,%esp
  8006a5:	68 c4 43 80 00       	push   $0x8043c4
  8006aa:	6a 70                	push   $0x70
  8006ac:	68 d4 42 80 00       	push   $0x8042d4
  8006b1:	e8 73 0d 00 00       	call   801429 <_panic>

		//3 MB Hole
		freeFrames = sys_calculate_free_frames() ;
  8006b6:	e8 c0 23 00 00       	call   802a7b <sys_calculate_free_frames>
  8006bb:	89 45 e0             	mov    %eax,-0x20(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  8006be:	e8 58 24 00 00       	call   802b1b <sys_pf_calculate_allocated_pages>
  8006c3:	89 45 dc             	mov    %eax,-0x24(%ebp)
		free(ptr_allocations[6]);
  8006c6:	8b 45 90             	mov    -0x70(%ebp),%eax
  8006c9:	83 ec 0c             	sub    $0xc,%esp
  8006cc:	50                   	push   %eax
  8006cd:	e8 1e 20 00 00       	call   8026f0 <free>
  8006d2:	83 c4 10             	add    $0x10,%esp
		//if ((sys_calculate_free_frames() - freeFrames) != 768) panic("Wrong free: ");
		if ((usedDiskPages - sys_pf_calculate_allocated_pages()) != 768) panic("Wrong free: Extra or less pages are removed from PageFile");
  8006d5:	e8 41 24 00 00       	call   802b1b <sys_pf_calculate_allocated_pages>
  8006da:	8b 55 dc             	mov    -0x24(%ebp),%edx
  8006dd:	29 c2                	sub    %eax,%edx
  8006df:	89 d0                	mov    %edx,%eax
  8006e1:	3d 00 03 00 00       	cmp    $0x300,%eax
  8006e6:	74 14                	je     8006fc <_main+0x6c4>
  8006e8:	83 ec 04             	sub    $0x4,%esp
  8006eb:	68 88 43 80 00       	push   $0x804388
  8006f0:	6a 77                	push   $0x77
  8006f2:	68 d4 42 80 00       	push   $0x8042d4
  8006f7:	e8 2d 0d 00 00       	call   801429 <_panic>
		if ((sys_calculate_free_frames() - freeFrames) != 0) panic("Wrong free: WS pages in memory and/or page tables are not freed correctly");
  8006fc:	e8 7a 23 00 00       	call   802a7b <sys_calculate_free_frames>
  800701:	89 c2                	mov    %eax,%edx
  800703:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800706:	39 c2                	cmp    %eax,%edx
  800708:	74 14                	je     80071e <_main+0x6e6>
  80070a:	83 ec 04             	sub    $0x4,%esp
  80070d:	68 c4 43 80 00       	push   $0x8043c4
  800712:	6a 78                	push   $0x78
  800714:	68 d4 42 80 00       	push   $0x8042d4
  800719:	e8 0b 0d 00 00       	call   801429 <_panic>
//		free(ptr_allocations[8]);
//		//if ((sys_calculate_free_frames() - freeFrames) != 768) panic("Wrong free: ");
//		if ((usedDiskPages - sys_pf_calculate_allocated_pages()) != 127488) panic("Wrong free: Extra or less pages are removed from PageFile");
//		if ((sys_calculate_free_frames() - freeFrames) != 0) panic("Wrong free: WS pages in memory and/or page tables are not freed correctly");
	}
	int cnt = 0;
  80071e:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	//Bypass the PAGE FAULT on <MOVB immediate, reg> instruction by setting its length
	//and continue executing the remaining code
	sys_bypassPageFault(3);
  800725:	83 ec 0c             	sub    $0xc,%esp
  800728:	6a 03                	push   $0x3
  80072a:	e8 e4 26 00 00       	call   802e13 <sys_bypassPageFault>
  80072f:	83 c4 10             	add    $0x10,%esp

	//[3] Test Re-allocation
	{
		/*CASE1: Re-allocate with size = 0*/

		char *byteArr = (char *) ptr_allocations[0];
  800732:	8b 85 78 ff ff ff    	mov    -0x88(%ebp),%eax
  800738:	89 45 d8             	mov    %eax,-0x28(%ebp)

		//Reallocate with size = 0 [delete it]
		freeFrames = sys_calculate_free_frames() ;
  80073b:	e8 3b 23 00 00       	call   802a7b <sys_calculate_free_frames>
  800740:	89 45 e0             	mov    %eax,-0x20(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  800743:	e8 d3 23 00 00       	call   802b1b <sys_pf_calculate_allocated_pages>
  800748:	89 45 dc             	mov    %eax,-0x24(%ebp)
		ptr_allocations[0] = realloc(ptr_allocations[0], 0);
  80074b:	8b 85 78 ff ff ff    	mov    -0x88(%ebp),%eax
  800751:	83 ec 08             	sub    $0x8,%esp
  800754:	6a 00                	push   $0x0
  800756:	50                   	push   %eax
  800757:	e8 9d 21 00 00       	call   8028f9 <realloc>
  80075c:	83 c4 10             	add    $0x10,%esp
  80075f:	89 85 78 ff ff ff    	mov    %eax,-0x88(%ebp)

		//[1] test return address & re-allocated space
		if ((uint32) ptr_allocations[0] != 0) panic("Wrong start address for the re-allocated space...it should return NULL!");
  800765:	8b 85 78 ff ff ff    	mov    -0x88(%ebp),%eax
  80076b:	85 c0                	test   %eax,%eax
  80076d:	74 17                	je     800786 <_main+0x74e>
  80076f:	83 ec 04             	sub    $0x4,%esp
  800772:	68 10 44 80 00       	push   $0x804410
  800777:	68 94 00 00 00       	push   $0x94
  80077c:	68 d4 42 80 00       	push   $0x8042d4
  800781:	e8 a3 0c 00 00       	call   801429 <_panic>
		//if ((sys_calculate_free_frames() - freeFrames) != 256) panic("Wrong re-allocation");
		if((freeFrames - sys_calculate_free_frames()) != 0) panic("Wrong re-allocation: either extra pages are re-allocated in memory or pages not allocated correctly on PageFile");
  800786:	e8 f0 22 00 00       	call   802a7b <sys_calculate_free_frames>
  80078b:	89 c2                	mov    %eax,%edx
  80078d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800790:	39 c2                	cmp    %eax,%edx
  800792:	74 17                	je     8007ab <_main+0x773>
  800794:	83 ec 04             	sub    $0x4,%esp
  800797:	68 58 44 80 00       	push   $0x804458
  80079c:	68 96 00 00 00       	push   $0x96
  8007a1:	68 d4 42 80 00       	push   $0x8042d4
  8007a6:	e8 7e 0c 00 00       	call   801429 <_panic>
		if((usedDiskPages - sys_pf_calculate_allocated_pages()) != 256) panic("Extra or less pages are re-allocated in PageFile");
  8007ab:	e8 6b 23 00 00       	call   802b1b <sys_pf_calculate_allocated_pages>
  8007b0:	8b 55 dc             	mov    -0x24(%ebp),%edx
  8007b3:	29 c2                	sub    %eax,%edx
  8007b5:	89 d0                	mov    %edx,%eax
  8007b7:	3d 00 01 00 00       	cmp    $0x100,%eax
  8007bc:	74 17                	je     8007d5 <_main+0x79d>
  8007be:	83 ec 04             	sub    $0x4,%esp
  8007c1:	68 c8 44 80 00       	push   $0x8044c8
  8007c6:	68 97 00 00 00       	push   $0x97
  8007cb:	68 d4 42 80 00       	push   $0x8042d4
  8007d0:	e8 54 0c 00 00       	call   801429 <_panic>

		//[2] test memory access
		byteArr[0] = 10;
  8007d5:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8007d8:	c6 00 0a             	movb   $0xa,(%eax)
		if (sys_rcr2() != (uint32)&(byteArr[0])) panic("successful access to re-allocated space with size 0!! it should not be succeeded");
  8007db:	e8 1a 26 00 00       	call   802dfa <sys_rcr2>
  8007e0:	89 c2                	mov    %eax,%edx
  8007e2:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8007e5:	39 c2                	cmp    %eax,%edx
  8007e7:	74 17                	je     800800 <_main+0x7c8>
  8007e9:	83 ec 04             	sub    $0x4,%esp
  8007ec:	68 fc 44 80 00       	push   $0x8044fc
  8007f1:	68 9b 00 00 00       	push   $0x9b
  8007f6:	68 d4 42 80 00       	push   $0x8042d4
  8007fb:	e8 29 0c 00 00       	call   801429 <_panic>
		byteArr[(1*Mega-kilo)/sizeof(char) - 1] = 10;
  800800:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800803:	2b 45 e4             	sub    -0x1c(%ebp),%eax
  800806:	8d 50 ff             	lea    -0x1(%eax),%edx
  800809:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80080c:	01 d0                	add    %edx,%eax
  80080e:	c6 00 0a             	movb   $0xa,(%eax)
		if (sys_rcr2() != (uint32)&(byteArr[(1*Mega-kilo)/sizeof(char) - 1])) panic("successful access to reallocated space of size 0!! it should not be succeeded");
  800811:	e8 e4 25 00 00       	call   802dfa <sys_rcr2>
  800816:	89 c2                	mov    %eax,%edx
  800818:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80081b:	2b 45 e4             	sub    -0x1c(%ebp),%eax
  80081e:	8d 48 ff             	lea    -0x1(%eax),%ecx
  800821:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800824:	01 c8                	add    %ecx,%eax
  800826:	39 c2                	cmp    %eax,%edx
  800828:	74 17                	je     800841 <_main+0x809>
  80082a:	83 ec 04             	sub    $0x4,%esp
  80082d:	68 50 45 80 00       	push   $0x804550
  800832:	68 9d 00 00 00       	push   $0x9d
  800837:	68 d4 42 80 00       	push   $0x8042d4
  80083c:	e8 e8 0b 00 00       	call   801429 <_panic>

		//set it to 0 again to cancel the bypassing option
		sys_bypassPageFault(0);
  800841:	83 ec 0c             	sub    $0xc,%esp
  800844:	6a 00                	push   $0x0
  800846:	e8 c8 25 00 00       	call   802e13 <sys_bypassPageFault>
  80084b:	83 c4 10             	add    $0x10,%esp

		vcprintf("\b\b\b20%", NULL);
  80084e:	83 ec 08             	sub    $0x8,%esp
  800851:	6a 00                	push   $0x0
  800853:	68 9e 45 80 00       	push   $0x80459e
  800858:	e8 15 0e 00 00       	call   801672 <vcprintf>
  80085d:	83 c4 10             	add    $0x10,%esp

		/*CASE2: Re-allocate with address = NULL*/

		//new allocation with size = 2.5 MB, should be placed in 3rd hole
		freeFrames = sys_calculate_free_frames() ;
  800860:	e8 16 22 00 00       	call   802a7b <sys_calculate_free_frames>
  800865:	89 45 e0             	mov    %eax,-0x20(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  800868:	e8 ae 22 00 00       	call   802b1b <sys_pf_calculate_allocated_pages>
  80086d:	89 45 dc             	mov    %eax,-0x24(%ebp)
		ptr_allocations[10] = realloc(NULL, 2*Mega + 510*kilo);
  800870:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  800873:	89 d0                	mov    %edx,%eax
  800875:	c1 e0 08             	shl    $0x8,%eax
  800878:	29 d0                	sub    %edx,%eax
  80087a:	89 c2                	mov    %eax,%edx
  80087c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80087f:	01 d0                	add    %edx,%eax
  800881:	01 c0                	add    %eax,%eax
  800883:	83 ec 08             	sub    $0x8,%esp
  800886:	50                   	push   %eax
  800887:	6a 00                	push   $0x0
  800889:	e8 6b 20 00 00       	call   8028f9 <realloc>
  80088e:	83 c4 10             	add    $0x10,%esp
  800891:	89 45 a0             	mov    %eax,-0x60(%ebp)
		if ((uint32) ptr_allocations[10] !=  (USER_HEAP_START + 8*Mega)) panic("Wrong start address for the allocated space... ");
  800894:	8b 45 a0             	mov    -0x60(%ebp),%eax
  800897:	89 c2                	mov    %eax,%edx
  800899:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80089c:	c1 e0 03             	shl    $0x3,%eax
  80089f:	05 00 00 00 80       	add    $0x80000000,%eax
  8008a4:	39 c2                	cmp    %eax,%edx
  8008a6:	74 17                	je     8008bf <_main+0x887>
  8008a8:	83 ec 04             	sub    $0x4,%esp
  8008ab:	68 a4 42 80 00       	push   $0x8042a4
  8008b0:	68 aa 00 00 00       	push   $0xaa
  8008b5:	68 d4 42 80 00       	push   $0x8042d4
  8008ba:	e8 6a 0b 00 00       	call   801429 <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 640) panic("Wrong re-allocation");
		if((freeFrames - sys_calculate_free_frames()) != 0) panic("Wrong re-allocation: either extra pages are re-allocated in memory or pages not allocated correctly on PageFile");
  8008bf:	e8 b7 21 00 00       	call   802a7b <sys_calculate_free_frames>
  8008c4:	89 c2                	mov    %eax,%edx
  8008c6:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8008c9:	39 c2                	cmp    %eax,%edx
  8008cb:	74 17                	je     8008e4 <_main+0x8ac>
  8008cd:	83 ec 04             	sub    $0x4,%esp
  8008d0:	68 58 44 80 00       	push   $0x804458
  8008d5:	68 ac 00 00 00       	push   $0xac
  8008da:	68 d4 42 80 00       	push   $0x8042d4
  8008df:	e8 45 0b 00 00       	call   801429 <_panic>
		if((sys_pf_calculate_allocated_pages() - usedDiskPages) != 640) panic("Extra or less pages are re-allocated in PageFile");
  8008e4:	e8 32 22 00 00       	call   802b1b <sys_pf_calculate_allocated_pages>
  8008e9:	2b 45 dc             	sub    -0x24(%ebp),%eax
  8008ec:	3d 80 02 00 00       	cmp    $0x280,%eax
  8008f1:	74 17                	je     80090a <_main+0x8d2>
  8008f3:	83 ec 04             	sub    $0x4,%esp
  8008f6:	68 c8 44 80 00       	push   $0x8044c8
  8008fb:	68 ad 00 00 00       	push   $0xad
  800900:	68 d4 42 80 00       	push   $0x8042d4
  800905:	e8 1f 0b 00 00       	call   801429 <_panic>

		//Fill it with data
		int *intArr = (int*) ptr_allocations[10];
  80090a:	8b 45 a0             	mov    -0x60(%ebp),%eax
  80090d:	89 45 d4             	mov    %eax,-0x2c(%ebp)
		int lastIndexOfInt1 = (2*Mega + 510*kilo)/sizeof(int) - 1;
  800910:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  800913:	89 d0                	mov    %edx,%eax
  800915:	c1 e0 08             	shl    $0x8,%eax
  800918:	29 d0                	sub    %edx,%eax
  80091a:	89 c2                	mov    %eax,%edx
  80091c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80091f:	01 d0                	add    %edx,%eax
  800921:	01 c0                	add    %eax,%eax
  800923:	c1 e8 02             	shr    $0x2,%eax
  800926:	48                   	dec    %eax
  800927:	89 45 d0             	mov    %eax,-0x30(%ebp)

		int i = 0;
  80092a:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
//		{
//			intArr[i] = i ;
//		}

		//fill the first 100 elements
		for(i = 0; i < 100; i++)
  800931:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800938:	eb 17                	jmp    800951 <_main+0x919>
		{
			intArr[i] = i;
  80093a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80093d:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800944:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  800947:	01 c2                	add    %eax,%edx
  800949:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80094c:	89 02                	mov    %eax,(%edx)
//		{
//			intArr[i] = i ;
//		}

		//fill the first 100 elements
		for(i = 0; i < 100; i++)
  80094e:	ff 45 f0             	incl   -0x10(%ebp)
  800951:	83 7d f0 63          	cmpl   $0x63,-0x10(%ebp)
  800955:	7e e3                	jle    80093a <_main+0x902>
			intArr[i] = i;
		}


		//fill the last 100 element
		for(i = lastIndexOfInt1; i >= lastIndexOfInt1 - 99; i--)
  800957:	8b 45 d0             	mov    -0x30(%ebp),%eax
  80095a:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80095d:	eb 17                	jmp    800976 <_main+0x93e>
		{
			intArr[i] = i;
  80095f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800962:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800969:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80096c:	01 c2                	add    %eax,%edx
  80096e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800971:	89 02                	mov    %eax,(%edx)
			intArr[i] = i;
		}


		//fill the last 100 element
		for(i = lastIndexOfInt1; i >= lastIndexOfInt1 - 99; i--)
  800973:	ff 4d f0             	decl   -0x10(%ebp)
  800976:	8b 45 d0             	mov    -0x30(%ebp),%eax
  800979:	83 e8 63             	sub    $0x63,%eax
  80097c:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80097f:	7e de                	jle    80095f <_main+0x927>
		{
			intArr[i] = i;
		}

		//[2] test memory access
		for (i=0; i < 100 ; i++)
  800981:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800988:	eb 33                	jmp    8009bd <_main+0x985>
		{
			cnt++;
  80098a:	ff 45 f4             	incl   -0xc(%ebp)
			if (intArr[i] != i) panic("Wrong re-allocation: stored values are wrongly changed!");
  80098d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800990:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800997:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80099a:	01 d0                	add    %edx,%eax
  80099c:	8b 00                	mov    (%eax),%eax
  80099e:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8009a1:	74 17                	je     8009ba <_main+0x982>
  8009a3:	83 ec 04             	sub    $0x4,%esp
  8009a6:	68 a8 45 80 00       	push   $0x8045a8
  8009ab:	68 ca 00 00 00       	push   $0xca
  8009b0:	68 d4 42 80 00       	push   $0x8042d4
  8009b5:	e8 6f 0a 00 00       	call   801429 <_panic>
		{
			intArr[i] = i;
		}

		//[2] test memory access
		for (i=0; i < 100 ; i++)
  8009ba:	ff 45 f0             	incl   -0x10(%ebp)
  8009bd:	83 7d f0 63          	cmpl   $0x63,-0x10(%ebp)
  8009c1:	7e c7                	jle    80098a <_main+0x952>
		{
			cnt++;
			if (intArr[i] != i) panic("Wrong re-allocation: stored values are wrongly changed!");
		}

		for(i = lastIndexOfInt1; i >= lastIndexOfInt1 - 99; i--)
  8009c3:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8009c6:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8009c9:	eb 33                	jmp    8009fe <_main+0x9c6>
		{
			cnt++;
  8009cb:	ff 45 f4             	incl   -0xc(%ebp)
			if (intArr[i] != i) panic("Wrong re-allocation: stored values are wrongly changed!");
  8009ce:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8009d1:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8009d8:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8009db:	01 d0                	add    %edx,%eax
  8009dd:	8b 00                	mov    (%eax),%eax
  8009df:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8009e2:	74 17                	je     8009fb <_main+0x9c3>
  8009e4:	83 ec 04             	sub    $0x4,%esp
  8009e7:	68 a8 45 80 00       	push   $0x8045a8
  8009ec:	68 d0 00 00 00       	push   $0xd0
  8009f1:	68 d4 42 80 00       	push   $0x8042d4
  8009f6:	e8 2e 0a 00 00       	call   801429 <_panic>
		{
			cnt++;
			if (intArr[i] != i) panic("Wrong re-allocation: stored values are wrongly changed!");
		}

		for(i = lastIndexOfInt1; i >= lastIndexOfInt1 - 99; i--)
  8009fb:	ff 4d f0             	decl   -0x10(%ebp)
  8009fe:	8b 45 d0             	mov    -0x30(%ebp),%eax
  800a01:	83 e8 63             	sub    $0x63,%eax
  800a04:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800a07:	7e c2                	jle    8009cb <_main+0x993>
		{
			cnt++;
			if (intArr[i] != i) panic("Wrong re-allocation: stored values are wrongly changed!");
		}
		vcprintf("\b\b\b40%", NULL);
  800a09:	83 ec 08             	sub    $0x8,%esp
  800a0c:	6a 00                	push   $0x0
  800a0e:	68 e0 45 80 00       	push   $0x8045e0
  800a13:	e8 5a 0c 00 00       	call   801672 <vcprintf>
  800a18:	83 c4 10             	add    $0x10,%esp

		/*CASE3: Re-allocate in the existing internal fragment (no additional pages are required)*/

		//Reallocate last allocation with 1 extra KB [should be placed in the existing 2 KB internal fragment]
		freeFrames = sys_calculate_free_frames() ;
  800a1b:	e8 5b 20 00 00       	call   802a7b <sys_calculate_free_frames>
  800a20:	89 45 e0             	mov    %eax,-0x20(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  800a23:	e8 f3 20 00 00       	call   802b1b <sys_pf_calculate_allocated_pages>
  800a28:	89 45 dc             	mov    %eax,-0x24(%ebp)
		ptr_allocations[10] = realloc(ptr_allocations[10], 2*Mega + 510*kilo + kilo);
  800a2b:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  800a2e:	89 d0                	mov    %edx,%eax
  800a30:	c1 e0 08             	shl    $0x8,%eax
  800a33:	29 d0                	sub    %edx,%eax
  800a35:	89 c2                	mov    %eax,%edx
  800a37:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800a3a:	01 d0                	add    %edx,%eax
  800a3c:	01 c0                	add    %eax,%eax
  800a3e:	89 c2                	mov    %eax,%edx
  800a40:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800a43:	01 d0                	add    %edx,%eax
  800a45:	89 c2                	mov    %eax,%edx
  800a47:	8b 45 a0             	mov    -0x60(%ebp),%eax
  800a4a:	83 ec 08             	sub    $0x8,%esp
  800a4d:	52                   	push   %edx
  800a4e:	50                   	push   %eax
  800a4f:	e8 a5 1e 00 00       	call   8028f9 <realloc>
  800a54:	83 c4 10             	add    $0x10,%esp
  800a57:	89 45 a0             	mov    %eax,-0x60(%ebp)

		//[1] test return address & re-allocated space
		if ((uint32) ptr_allocations[10] != (USER_HEAP_START + 8*Mega)) panic("Wrong start address for the re-allocated space... ");
  800a5a:	8b 45 a0             	mov    -0x60(%ebp),%eax
  800a5d:	89 c2                	mov    %eax,%edx
  800a5f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800a62:	c1 e0 03             	shl    $0x3,%eax
  800a65:	05 00 00 00 80       	add    $0x80000000,%eax
  800a6a:	39 c2                	cmp    %eax,%edx
  800a6c:	74 17                	je     800a85 <_main+0xa4d>
  800a6e:	83 ec 04             	sub    $0x4,%esp
  800a71:	68 e8 45 80 00       	push   $0x8045e8
  800a76:	68 dc 00 00 00       	push   $0xdc
  800a7b:	68 d4 42 80 00       	push   $0x8042d4
  800a80:	e8 a4 09 00 00       	call   801429 <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 0) panic("Wrong re-allocation");

		if((freeFrames - sys_calculate_free_frames()) != 0) panic("Wrong re-allocation: either extra pages are re-allocated in memory or pages not allocated correctly on PageFile");
  800a85:	e8 f1 1f 00 00       	call   802a7b <sys_calculate_free_frames>
  800a8a:	89 c2                	mov    %eax,%edx
  800a8c:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800a8f:	39 c2                	cmp    %eax,%edx
  800a91:	74 17                	je     800aaa <_main+0xa72>
  800a93:	83 ec 04             	sub    $0x4,%esp
  800a96:	68 58 44 80 00       	push   $0x804458
  800a9b:	68 df 00 00 00       	push   $0xdf
  800aa0:	68 d4 42 80 00       	push   $0x8042d4
  800aa5:	e8 7f 09 00 00       	call   801429 <_panic>
		if((sys_pf_calculate_allocated_pages() - usedDiskPages) != 0) panic("Extra or less pages are re-allocated in PageFile");
  800aaa:	e8 6c 20 00 00       	call   802b1b <sys_pf_calculate_allocated_pages>
  800aaf:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  800ab2:	74 17                	je     800acb <_main+0xa93>
  800ab4:	83 ec 04             	sub    $0x4,%esp
  800ab7:	68 c8 44 80 00       	push   $0x8044c8
  800abc:	68 e0 00 00 00       	push   $0xe0
  800ac1:	68 d4 42 80 00       	push   $0x8042d4
  800ac6:	e8 5e 09 00 00       	call   801429 <_panic>

		//[2] test memory access
		int lastIndexOfInt2 = (2*Mega + 510*kilo + kilo)/sizeof(int) - 1;
  800acb:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  800ace:	89 d0                	mov    %edx,%eax
  800ad0:	c1 e0 08             	shl    $0x8,%eax
  800ad3:	29 d0                	sub    %edx,%eax
  800ad5:	89 c2                	mov    %eax,%edx
  800ad7:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800ada:	01 d0                	add    %edx,%eax
  800adc:	01 c0                	add    %eax,%eax
  800ade:	89 c2                	mov    %eax,%edx
  800ae0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800ae3:	01 d0                	add    %edx,%eax
  800ae5:	c1 e8 02             	shr    $0x2,%eax
  800ae8:	48                   	dec    %eax
  800ae9:	89 45 cc             	mov    %eax,-0x34(%ebp)

		for (i=lastIndexOfInt1 + 1; i < lastIndexOfInt1 + 101 ; i++)
  800aec:	8b 45 d0             	mov    -0x30(%ebp),%eax
  800aef:	40                   	inc    %eax
  800af0:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800af3:	eb 17                	jmp    800b0c <_main+0xad4>
		{
			intArr[i] = i ;
  800af5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800af8:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800aff:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  800b02:	01 c2                	add    %eax,%edx
  800b04:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800b07:	89 02                	mov    %eax,(%edx)
		if((sys_pf_calculate_allocated_pages() - usedDiskPages) != 0) panic("Extra or less pages are re-allocated in PageFile");

		//[2] test memory access
		int lastIndexOfInt2 = (2*Mega + 510*kilo + kilo)/sizeof(int) - 1;

		for (i=lastIndexOfInt1 + 1; i < lastIndexOfInt1 + 101 ; i++)
  800b09:	ff 45 f0             	incl   -0x10(%ebp)
  800b0c:	8b 45 d0             	mov    -0x30(%ebp),%eax
  800b0f:	83 c0 65             	add    $0x65,%eax
  800b12:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800b15:	7f de                	jg     800af5 <_main+0xabd>
		{
			intArr[i] = i ;
		}


		for (i=lastIndexOfInt2 ; i >= lastIndexOfInt2 - 99 ; i--)
  800b17:	8b 45 cc             	mov    -0x34(%ebp),%eax
  800b1a:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800b1d:	eb 17                	jmp    800b36 <_main+0xafe>
		{
			intArr[i] = i ;
  800b1f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800b22:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800b29:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  800b2c:	01 c2                	add    %eax,%edx
  800b2e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800b31:	89 02                	mov    %eax,(%edx)
		{
			intArr[i] = i ;
		}


		for (i=lastIndexOfInt2 ; i >= lastIndexOfInt2 - 99 ; i--)
  800b33:	ff 4d f0             	decl   -0x10(%ebp)
  800b36:	8b 45 cc             	mov    -0x34(%ebp),%eax
  800b39:	83 e8 63             	sub    $0x63,%eax
  800b3c:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800b3f:	7e de                	jle    800b1f <_main+0xae7>
		{
			intArr[i] = i ;
		}


		for (i=0; i < 100 ; i++)
  800b41:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800b48:	eb 33                	jmp    800b7d <_main+0xb45>
		{
			cnt++;
  800b4a:	ff 45 f4             	incl   -0xc(%ebp)
			if (intArr[i] != i) panic("Wrong re-allocation: stored values are wrongly changed!");
  800b4d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800b50:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800b57:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  800b5a:	01 d0                	add    %edx,%eax
  800b5c:	8b 00                	mov    (%eax),%eax
  800b5e:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800b61:	74 17                	je     800b7a <_main+0xb42>
  800b63:	83 ec 04             	sub    $0x4,%esp
  800b66:	68 a8 45 80 00       	push   $0x8045a8
  800b6b:	68 f4 00 00 00       	push   $0xf4
  800b70:	68 d4 42 80 00       	push   $0x8042d4
  800b75:	e8 af 08 00 00       	call   801429 <_panic>
		{
			intArr[i] = i ;
		}


		for (i=0; i < 100 ; i++)
  800b7a:	ff 45 f0             	incl   -0x10(%ebp)
  800b7d:	83 7d f0 63          	cmpl   $0x63,-0x10(%ebp)
  800b81:	7e c7                	jle    800b4a <_main+0xb12>
		{
			cnt++;
			if (intArr[i] != i) panic("Wrong re-allocation: stored values are wrongly changed!");
		}
		for (i=lastIndexOfInt1 - 1; i >= lastIndexOfInt1 - 99 ; i--)
  800b83:	8b 45 d0             	mov    -0x30(%ebp),%eax
  800b86:	48                   	dec    %eax
  800b87:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800b8a:	eb 33                	jmp    800bbf <_main+0xb87>
		{
			cnt++;
  800b8c:	ff 45 f4             	incl   -0xc(%ebp)
			if (intArr[i] != i) panic("Wrong re-allocation: stored values are wrongly changed!");
  800b8f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800b92:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800b99:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  800b9c:	01 d0                	add    %edx,%eax
  800b9e:	8b 00                	mov    (%eax),%eax
  800ba0:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800ba3:	74 17                	je     800bbc <_main+0xb84>
  800ba5:	83 ec 04             	sub    $0x4,%esp
  800ba8:	68 a8 45 80 00       	push   $0x8045a8
  800bad:	68 f9 00 00 00       	push   $0xf9
  800bb2:	68 d4 42 80 00       	push   $0x8042d4
  800bb7:	e8 6d 08 00 00       	call   801429 <_panic>
		for (i=0; i < 100 ; i++)
		{
			cnt++;
			if (intArr[i] != i) panic("Wrong re-allocation: stored values are wrongly changed!");
		}
		for (i=lastIndexOfInt1 - 1; i >= lastIndexOfInt1 - 99 ; i--)
  800bbc:	ff 4d f0             	decl   -0x10(%ebp)
  800bbf:	8b 45 d0             	mov    -0x30(%ebp),%eax
  800bc2:	83 e8 63             	sub    $0x63,%eax
  800bc5:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800bc8:	7e c2                	jle    800b8c <_main+0xb54>
		{
			cnt++;
			if (intArr[i] != i) panic("Wrong re-allocation: stored values are wrongly changed!");
		}
		for (i=lastIndexOfInt1 + 1; i < lastIndexOfInt1 + 101 ; i++)
  800bca:	8b 45 d0             	mov    -0x30(%ebp),%eax
  800bcd:	40                   	inc    %eax
  800bce:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800bd1:	eb 33                	jmp    800c06 <_main+0xbce>
		{
			cnt++;
  800bd3:	ff 45 f4             	incl   -0xc(%ebp)
			if (intArr[i] != i) panic("Wrong re-allocation: stored values are wrongly changed!");
  800bd6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800bd9:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800be0:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  800be3:	01 d0                	add    %edx,%eax
  800be5:	8b 00                	mov    (%eax),%eax
  800be7:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800bea:	74 17                	je     800c03 <_main+0xbcb>
  800bec:	83 ec 04             	sub    $0x4,%esp
  800bef:	68 a8 45 80 00       	push   $0x8045a8
  800bf4:	68 fe 00 00 00       	push   $0xfe
  800bf9:	68 d4 42 80 00       	push   $0x8042d4
  800bfe:	e8 26 08 00 00       	call   801429 <_panic>
		for (i=lastIndexOfInt1 - 1; i >= lastIndexOfInt1 - 99 ; i--)
		{
			cnt++;
			if (intArr[i] != i) panic("Wrong re-allocation: stored values are wrongly changed!");
		}
		for (i=lastIndexOfInt1 + 1; i < lastIndexOfInt1 + 101 ; i++)
  800c03:	ff 45 f0             	incl   -0x10(%ebp)
  800c06:	8b 45 d0             	mov    -0x30(%ebp),%eax
  800c09:	83 c0 65             	add    $0x65,%eax
  800c0c:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800c0f:	7f c2                	jg     800bd3 <_main+0xb9b>
		{
			cnt++;
			if (intArr[i] != i) panic("Wrong re-allocation: stored values are wrongly changed!");
		}
		for (i=lastIndexOfInt2; i >= lastIndexOfInt2 - 99 ; i--)
  800c11:	8b 45 cc             	mov    -0x34(%ebp),%eax
  800c14:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800c17:	eb 33                	jmp    800c4c <_main+0xc14>
		{
			cnt++;
  800c19:	ff 45 f4             	incl   -0xc(%ebp)
			if (intArr[i] != i) panic("Wrong re-allocation: stored values are wrongly changed!");
  800c1c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800c1f:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800c26:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  800c29:	01 d0                	add    %edx,%eax
  800c2b:	8b 00                	mov    (%eax),%eax
  800c2d:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800c30:	74 17                	je     800c49 <_main+0xc11>
  800c32:	83 ec 04             	sub    $0x4,%esp
  800c35:	68 a8 45 80 00       	push   $0x8045a8
  800c3a:	68 03 01 00 00       	push   $0x103
  800c3f:	68 d4 42 80 00       	push   $0x8042d4
  800c44:	e8 e0 07 00 00       	call   801429 <_panic>
		for (i=lastIndexOfInt1 + 1; i < lastIndexOfInt1 + 101 ; i++)
		{
			cnt++;
			if (intArr[i] != i) panic("Wrong re-allocation: stored values are wrongly changed!");
		}
		for (i=lastIndexOfInt2; i >= lastIndexOfInt2 - 99 ; i--)
  800c49:	ff 4d f0             	decl   -0x10(%ebp)
  800c4c:	8b 45 cc             	mov    -0x34(%ebp),%eax
  800c4f:	83 e8 63             	sub    $0x63,%eax
  800c52:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800c55:	7e c2                	jle    800c19 <_main+0xbe1>
			if (intArr[i] != i) panic("Wrong re-allocation: stored values are wrongly changed!");
		}


		//[3] test freeing it after expansion
		freeFrames = sys_calculate_free_frames() ;
  800c57:	e8 1f 1e 00 00       	call   802a7b <sys_calculate_free_frames>
  800c5c:	89 45 e0             	mov    %eax,-0x20(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  800c5f:	e8 b7 1e 00 00       	call   802b1b <sys_pf_calculate_allocated_pages>
  800c64:	89 45 dc             	mov    %eax,-0x24(%ebp)
		free(ptr_allocations[10]);
  800c67:	8b 45 a0             	mov    -0x60(%ebp),%eax
  800c6a:	83 ec 0c             	sub    $0xc,%esp
  800c6d:	50                   	push   %eax
  800c6e:	e8 7d 1a 00 00       	call   8026f0 <free>
  800c73:	83 c4 10             	add    $0x10,%esp

		//if ((sys_calculate_free_frames() - freeFrames) != 640) panic("Wrong free of the re-allocated space");
		if ((usedDiskPages - sys_pf_calculate_allocated_pages()) != 640) panic("Wrong free of the re-allocated space: Extra or less pages are removed from PageFile");
  800c76:	e8 a0 1e 00 00       	call   802b1b <sys_pf_calculate_allocated_pages>
  800c7b:	8b 55 dc             	mov    -0x24(%ebp),%edx
  800c7e:	29 c2                	sub    %eax,%edx
  800c80:	89 d0                	mov    %edx,%eax
  800c82:	3d 80 02 00 00       	cmp    $0x280,%eax
  800c87:	74 17                	je     800ca0 <_main+0xc68>
  800c89:	83 ec 04             	sub    $0x4,%esp
  800c8c:	68 1c 46 80 00       	push   $0x80461c
  800c91:	68 0d 01 00 00       	push   $0x10d
  800c96:	68 d4 42 80 00       	push   $0x8042d4
  800c9b:	e8 89 07 00 00       	call   801429 <_panic>
		if ((sys_calculate_free_frames() - freeFrames) != 2 + 1) panic("Wrong free of the re-allocated space: WS pages in memory and/or page tables are not freed correctly");
  800ca0:	e8 d6 1d 00 00       	call   802a7b <sys_calculate_free_frames>
  800ca5:	89 c2                	mov    %eax,%edx
  800ca7:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800caa:	29 c2                	sub    %eax,%edx
  800cac:	89 d0                	mov    %edx,%eax
  800cae:	83 f8 03             	cmp    $0x3,%eax
  800cb1:	74 17                	je     800cca <_main+0xc92>
  800cb3:	83 ec 04             	sub    $0x4,%esp
  800cb6:	68 70 46 80 00       	push   $0x804670
  800cbb:	68 0e 01 00 00       	push   $0x10e
  800cc0:	68 d4 42 80 00       	push   $0x8042d4
  800cc5:	e8 5f 07 00 00       	call   801429 <_panic>

		vcprintf("\b\b\b60%", NULL);
  800cca:	83 ec 08             	sub    $0x8,%esp
  800ccd:	6a 00                	push   $0x0
  800ccf:	68 d4 46 80 00       	push   $0x8046d4
  800cd4:	e8 99 09 00 00       	call   801672 <vcprintf>
  800cd9:	83 c4 10             	add    $0x10,%esp

		/*CASE4: Re-allocate that can NOT fit in any free fragment*/

		//Fill 3rd allocation with data
		intArr = (int*) ptr_allocations[2];
  800cdc:	8b 45 80             	mov    -0x80(%ebp),%eax
  800cdf:	89 45 d4             	mov    %eax,-0x2c(%ebp)
		lastIndexOfInt1 = (1*Mega)/sizeof(int) - 1;
  800ce2:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800ce5:	c1 e8 02             	shr    $0x2,%eax
  800ce8:	48                   	dec    %eax
  800ce9:	89 45 d0             	mov    %eax,-0x30(%ebp)

		i = 0;
  800cec:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
		//filling the first 100 element
		for (i=0; i < 100 ; i++)
  800cf3:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800cfa:	eb 17                	jmp    800d13 <_main+0xcdb>
		{
			intArr[i] = i ;
  800cfc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800cff:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800d06:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  800d09:	01 c2                	add    %eax,%edx
  800d0b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800d0e:	89 02                	mov    %eax,(%edx)
		intArr = (int*) ptr_allocations[2];
		lastIndexOfInt1 = (1*Mega)/sizeof(int) - 1;

		i = 0;
		//filling the first 100 element
		for (i=0; i < 100 ; i++)
  800d10:	ff 45 f0             	incl   -0x10(%ebp)
  800d13:	83 7d f0 63          	cmpl   $0x63,-0x10(%ebp)
  800d17:	7e e3                	jle    800cfc <_main+0xcc4>
		{
			intArr[i] = i ;
		}

		//filling the last 100 element
		for(int i = lastIndexOfInt1; i > lastIndexOfInt1 - 100; i--)
  800d19:	8b 45 d0             	mov    -0x30(%ebp),%eax
  800d1c:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800d1f:	eb 17                	jmp    800d38 <_main+0xd00>
		{
			intArr[i] = i;
  800d21:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800d24:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800d2b:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  800d2e:	01 c2                	add    %eax,%edx
  800d30:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800d33:	89 02                	mov    %eax,(%edx)
		{
			intArr[i] = i ;
		}

		//filling the last 100 element
		for(int i = lastIndexOfInt1; i > lastIndexOfInt1 - 100; i--)
  800d35:	ff 4d ec             	decl   -0x14(%ebp)
  800d38:	8b 45 d0             	mov    -0x30(%ebp),%eax
  800d3b:	83 e8 64             	sub    $0x64,%eax
  800d3e:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  800d41:	7c de                	jl     800d21 <_main+0xce9>
		{
			intArr[i] = i;
		}

		//Reallocate it to large size that can't be fit in any free segment
		freeFrames = sys_calculate_free_frames() ;
  800d43:	e8 33 1d 00 00       	call   802a7b <sys_calculate_free_frames>
  800d48:	89 45 e0             	mov    %eax,-0x20(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  800d4b:	e8 cb 1d 00 00       	call   802b1b <sys_pf_calculate_allocated_pages>
  800d50:	89 45 dc             	mov    %eax,-0x24(%ebp)
		void* origAddress = ptr_allocations[2];
  800d53:	8b 45 80             	mov    -0x80(%ebp),%eax
  800d56:	89 45 c8             	mov    %eax,-0x38(%ebp)
		ptr_allocations[2] = realloc(ptr_allocations[2], (USER_HEAP_MAX - USER_HEAP_START - 13*Mega));
  800d59:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800d5c:	89 d0                	mov    %edx,%eax
  800d5e:	01 c0                	add    %eax,%eax
  800d60:	01 d0                	add    %edx,%eax
  800d62:	c1 e0 02             	shl    $0x2,%eax
  800d65:	01 d0                	add    %edx,%eax
  800d67:	f7 d8                	neg    %eax
  800d69:	8d 90 00 00 00 20    	lea    0x20000000(%eax),%edx
  800d6f:	8b 45 80             	mov    -0x80(%ebp),%eax
  800d72:	83 ec 08             	sub    $0x8,%esp
  800d75:	52                   	push   %edx
  800d76:	50                   	push   %eax
  800d77:	e8 7d 1b 00 00       	call   8028f9 <realloc>
  800d7c:	83 c4 10             	add    $0x10,%esp
  800d7f:	89 45 80             	mov    %eax,-0x80(%ebp)

		//cprintf("%x\n", ptr_allocations[2]);
		//[1] test return address & re-allocated space
		if ((uint32) ptr_allocations[2] != 0) panic("Wrong start address for the re-allocated space... ");
  800d82:	8b 45 80             	mov    -0x80(%ebp),%eax
  800d85:	85 c0                	test   %eax,%eax
  800d87:	74 17                	je     800da0 <_main+0xd68>
  800d89:	83 ec 04             	sub    $0x4,%esp
  800d8c:	68 e8 45 80 00       	push   $0x8045e8
  800d91:	68 2d 01 00 00       	push   $0x12d
  800d96:	68 d4 42 80 00       	push   $0x8042d4
  800d9b:	e8 89 06 00 00       	call   801429 <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 0) panic("Wrong re-allocation");
		if((freeFrames - sys_calculate_free_frames()) != 0) panic("Wrong re-allocation: either extra pages are re-allocated in memory or pages not allocated correctly on PageFile");
  800da0:	e8 d6 1c 00 00       	call   802a7b <sys_calculate_free_frames>
  800da5:	89 c2                	mov    %eax,%edx
  800da7:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800daa:	39 c2                	cmp    %eax,%edx
  800dac:	74 17                	je     800dc5 <_main+0xd8d>
  800dae:	83 ec 04             	sub    $0x4,%esp
  800db1:	68 58 44 80 00       	push   $0x804458
  800db6:	68 2f 01 00 00       	push   $0x12f
  800dbb:	68 d4 42 80 00       	push   $0x8042d4
  800dc0:	e8 64 06 00 00       	call   801429 <_panic>
		if((sys_pf_calculate_allocated_pages() - usedDiskPages) != 0) panic("Extra or less pages are re-allocated in PageFile");
  800dc5:	e8 51 1d 00 00       	call   802b1b <sys_pf_calculate_allocated_pages>
  800dca:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  800dcd:	74 17                	je     800de6 <_main+0xdae>
  800dcf:	83 ec 04             	sub    $0x4,%esp
  800dd2:	68 c8 44 80 00       	push   $0x8044c8
  800dd7:	68 30 01 00 00       	push   $0x130
  800ddc:	68 d4 42 80 00       	push   $0x8042d4
  800de1:	e8 43 06 00 00       	call   801429 <_panic>

		//[2] test memory access
		for (i=0; i < 100 ; i++)
  800de6:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800ded:	eb 33                	jmp    800e22 <_main+0xdea>
		{
			cnt++;
  800def:	ff 45 f4             	incl   -0xc(%ebp)
			if (intArr[i] != i) panic("Wrong re-allocation: stored values are wrongly changed!");
  800df2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800df5:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800dfc:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  800dff:	01 d0                	add    %edx,%eax
  800e01:	8b 00                	mov    (%eax),%eax
  800e03:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800e06:	74 17                	je     800e1f <_main+0xde7>
  800e08:	83 ec 04             	sub    $0x4,%esp
  800e0b:	68 a8 45 80 00       	push   $0x8045a8
  800e10:	68 36 01 00 00       	push   $0x136
  800e15:	68 d4 42 80 00       	push   $0x8042d4
  800e1a:	e8 0a 06 00 00       	call   801429 <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 0) panic("Wrong re-allocation");
		if((freeFrames - sys_calculate_free_frames()) != 0) panic("Wrong re-allocation: either extra pages are re-allocated in memory or pages not allocated correctly on PageFile");
		if((sys_pf_calculate_allocated_pages() - usedDiskPages) != 0) panic("Extra or less pages are re-allocated in PageFile");

		//[2] test memory access
		for (i=0; i < 100 ; i++)
  800e1f:	ff 45 f0             	incl   -0x10(%ebp)
  800e22:	83 7d f0 63          	cmpl   $0x63,-0x10(%ebp)
  800e26:	7e c7                	jle    800def <_main+0xdb7>
		{
			cnt++;
			if (intArr[i] != i) panic("Wrong re-allocation: stored values are wrongly changed!");
		}

		for(i = lastIndexOfInt1; i > lastIndexOfInt1 - 100; i--)
  800e28:	8b 45 d0             	mov    -0x30(%ebp),%eax
  800e2b:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800e2e:	eb 33                	jmp    800e63 <_main+0xe2b>
		{
			cnt++;
  800e30:	ff 45 f4             	incl   -0xc(%ebp)
			if (intArr[i] != i) panic("Wrong re-allocation: stored values are wrongly changed!");
  800e33:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800e36:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800e3d:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  800e40:	01 d0                	add    %edx,%eax
  800e42:	8b 00                	mov    (%eax),%eax
  800e44:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800e47:	74 17                	je     800e60 <_main+0xe28>
  800e49:	83 ec 04             	sub    $0x4,%esp
  800e4c:	68 a8 45 80 00       	push   $0x8045a8
  800e51:	68 3c 01 00 00       	push   $0x13c
  800e56:	68 d4 42 80 00       	push   $0x8042d4
  800e5b:	e8 c9 05 00 00       	call   801429 <_panic>
		{
			cnt++;
			if (intArr[i] != i) panic("Wrong re-allocation: stored values are wrongly changed!");
		}

		for(i = lastIndexOfInt1; i > lastIndexOfInt1 - 100; i--)
  800e60:	ff 4d f0             	decl   -0x10(%ebp)
  800e63:	8b 45 d0             	mov    -0x30(%ebp),%eax
  800e66:	83 e8 64             	sub    $0x64,%eax
  800e69:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800e6c:	7c c2                	jl     800e30 <_main+0xdf8>
			cnt++;
			if (intArr[i] != i) panic("Wrong re-allocation: stored values are wrongly changed!");
		}

		//[3] test freeing it after FAILURE expansion
		freeFrames = sys_calculate_free_frames() ;
  800e6e:	e8 08 1c 00 00       	call   802a7b <sys_calculate_free_frames>
  800e73:	89 45 e0             	mov    %eax,-0x20(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  800e76:	e8 a0 1c 00 00       	call   802b1b <sys_pf_calculate_allocated_pages>
  800e7b:	89 45 dc             	mov    %eax,-0x24(%ebp)
		free(origAddress);
  800e7e:	83 ec 0c             	sub    $0xc,%esp
  800e81:	ff 75 c8             	pushl  -0x38(%ebp)
  800e84:	e8 67 18 00 00       	call   8026f0 <free>
  800e89:	83 c4 10             	add    $0x10,%esp
		//if ((sys_calculate_free_frames() - freeFrames) != 256) panic("Wrong free of the re-allocated space");
		if ((usedDiskPages - sys_pf_calculate_allocated_pages()) != 256) panic("Wrong free of the re-allocated space: Extra or less pages are removed from PageFile");
  800e8c:	e8 8a 1c 00 00       	call   802b1b <sys_pf_calculate_allocated_pages>
  800e91:	8b 55 dc             	mov    -0x24(%ebp),%edx
  800e94:	29 c2                	sub    %eax,%edx
  800e96:	89 d0                	mov    %edx,%eax
  800e98:	3d 00 01 00 00       	cmp    $0x100,%eax
  800e9d:	74 17                	je     800eb6 <_main+0xe7e>
  800e9f:	83 ec 04             	sub    $0x4,%esp
  800ea2:	68 1c 46 80 00       	push   $0x80461c
  800ea7:	68 44 01 00 00       	push   $0x144
  800eac:	68 d4 42 80 00       	push   $0x8042d4
  800eb1:	e8 73 05 00 00       	call   801429 <_panic>
		if ((sys_calculate_free_frames() - freeFrames) != 2 + 1) panic("Wrong free of the re-allocated space: WS pages in memory and/or page tables are not freed correctly");
  800eb6:	e8 c0 1b 00 00       	call   802a7b <sys_calculate_free_frames>
  800ebb:	89 c2                	mov    %eax,%edx
  800ebd:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800ec0:	29 c2                	sub    %eax,%edx
  800ec2:	89 d0                	mov    %edx,%eax
  800ec4:	83 f8 03             	cmp    $0x3,%eax
  800ec7:	74 17                	je     800ee0 <_main+0xea8>
  800ec9:	83 ec 04             	sub    $0x4,%esp
  800ecc:	68 70 46 80 00       	push   $0x804670
  800ed1:	68 45 01 00 00       	push   $0x145
  800ed6:	68 d4 42 80 00       	push   $0x8042d4
  800edb:	e8 49 05 00 00       	call   801429 <_panic>

		vcprintf("\b\b\b80%", NULL);
  800ee0:	83 ec 08             	sub    $0x8,%esp
  800ee3:	6a 00                	push   $0x0
  800ee5:	68 db 46 80 00       	push   $0x8046db
  800eea:	e8 83 07 00 00       	call   801672 <vcprintf>
  800eef:	83 c4 10             	add    $0x10,%esp
		/*CASE5: Re-allocate that test FIRST FIT strategy*/

		//[1] create 4 MB hole at beginning of the heap

		//Take 2 MB from currently 3 MB hole at beginning of the heap
		freeFrames = sys_calculate_free_frames() ;
  800ef2:	e8 84 1b 00 00       	call   802a7b <sys_calculate_free_frames>
  800ef7:	89 45 e0             	mov    %eax,-0x20(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  800efa:	e8 1c 1c 00 00       	call   802b1b <sys_pf_calculate_allocated_pages>
  800eff:	89 45 dc             	mov    %eax,-0x24(%ebp)
		ptr_allocations[10] = malloc(2*Mega-kilo);
  800f02:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800f05:	01 c0                	add    %eax,%eax
  800f07:	2b 45 e4             	sub    -0x1c(%ebp),%eax
  800f0a:	83 ec 0c             	sub    $0xc,%esp
  800f0d:	50                   	push   %eax
  800f0e:	e8 5c 17 00 00       	call   80266f <malloc>
  800f13:	83 c4 10             	add    $0x10,%esp
  800f16:	89 45 a0             	mov    %eax,-0x60(%ebp)
		if ((uint32) ptr_allocations[10] != (USER_HEAP_START)) panic("Wrong start address for the allocated space... ");
  800f19:	8b 45 a0             	mov    -0x60(%ebp),%eax
  800f1c:	3d 00 00 00 80       	cmp    $0x80000000,%eax
  800f21:	74 17                	je     800f3a <_main+0xf02>
  800f23:	83 ec 04             	sub    $0x4,%esp
  800f26:	68 a4 42 80 00       	push   $0x8042a4
  800f2b:	68 51 01 00 00       	push   $0x151
  800f30:	68 d4 42 80 00       	push   $0x8042d4
  800f35:	e8 ef 04 00 00       	call   801429 <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 512 ) panic("Wrong allocation: ");
		if((freeFrames - sys_calculate_free_frames()) != 0) panic("Wrong allocation: either extra pages are allocated in memory or pages not allocated correctly on PageFile");
  800f3a:	e8 3c 1b 00 00       	call   802a7b <sys_calculate_free_frames>
  800f3f:	89 c2                	mov    %eax,%edx
  800f41:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800f44:	39 c2                	cmp    %eax,%edx
  800f46:	74 17                	je     800f5f <_main+0xf27>
  800f48:	83 ec 04             	sub    $0x4,%esp
  800f4b:	68 ec 42 80 00       	push   $0x8042ec
  800f50:	68 53 01 00 00       	push   $0x153
  800f55:	68 d4 42 80 00       	push   $0x8042d4
  800f5a:	e8 ca 04 00 00       	call   801429 <_panic>
		if((sys_pf_calculate_allocated_pages() - usedDiskPages) != 512) panic("Extra or less pages are allocated in PageFile");
  800f5f:	e8 b7 1b 00 00       	call   802b1b <sys_pf_calculate_allocated_pages>
  800f64:	2b 45 dc             	sub    -0x24(%ebp),%eax
  800f67:	3d 00 02 00 00       	cmp    $0x200,%eax
  800f6c:	74 17                	je     800f85 <_main+0xf4d>
  800f6e:	83 ec 04             	sub    $0x4,%esp
  800f71:	68 58 43 80 00       	push   $0x804358
  800f76:	68 54 01 00 00       	push   $0x154
  800f7b:	68 d4 42 80 00       	push   $0x8042d4
  800f80:	e8 a4 04 00 00       	call   801429 <_panic>

		//remove 1 MB allocation between 1 MB hole and 2 MB hole to create 4 MB hole
		freeFrames = sys_calculate_free_frames() ;
  800f85:	e8 f1 1a 00 00       	call   802a7b <sys_calculate_free_frames>
  800f8a:	89 45 e0             	mov    %eax,-0x20(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  800f8d:	e8 89 1b 00 00       	call   802b1b <sys_pf_calculate_allocated_pages>
  800f92:	89 45 dc             	mov    %eax,-0x24(%ebp)
		free(ptr_allocations[3]);
  800f95:	8b 45 84             	mov    -0x7c(%ebp),%eax
  800f98:	83 ec 0c             	sub    $0xc,%esp
  800f9b:	50                   	push   %eax
  800f9c:	e8 4f 17 00 00       	call   8026f0 <free>
  800fa1:	83 c4 10             	add    $0x10,%esp
		//if ((sys_calculate_free_frames() - freeFrames) != 256) panic("Wrong free: ");
		if ((usedDiskPages - sys_pf_calculate_allocated_pages()) != 256) panic("Wrong free: Extra or less pages are removed from PageFile");
  800fa4:	e8 72 1b 00 00       	call   802b1b <sys_pf_calculate_allocated_pages>
  800fa9:	8b 55 dc             	mov    -0x24(%ebp),%edx
  800fac:	29 c2                	sub    %eax,%edx
  800fae:	89 d0                	mov    %edx,%eax
  800fb0:	3d 00 01 00 00       	cmp    $0x100,%eax
  800fb5:	74 17                	je     800fce <_main+0xf96>
  800fb7:	83 ec 04             	sub    $0x4,%esp
  800fba:	68 88 43 80 00       	push   $0x804388
  800fbf:	68 5b 01 00 00       	push   $0x15b
  800fc4:	68 d4 42 80 00       	push   $0x8042d4
  800fc9:	e8 5b 04 00 00       	call   801429 <_panic>
		if ((sys_calculate_free_frames() - freeFrames) != 0) panic("Wrong free: WS pages in memory and/or page tables are not freed correctly");
  800fce:	e8 a8 1a 00 00       	call   802a7b <sys_calculate_free_frames>
  800fd3:	89 c2                	mov    %eax,%edx
  800fd5:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800fd8:	39 c2                	cmp    %eax,%edx
  800fda:	74 17                	je     800ff3 <_main+0xfbb>
  800fdc:	83 ec 04             	sub    $0x4,%esp
  800fdf:	68 c4 43 80 00       	push   $0x8043c4
  800fe4:	68 5c 01 00 00       	push   $0x15c
  800fe9:	68 d4 42 80 00       	push   $0x8042d4
  800fee:	e8 36 04 00 00       	call   801429 <_panic>
		{
			//allocate 1 page after each 3 MB
			sys_allocateMem(i, PAGE_SIZE) ;
		}*/

		malloc(5*Mega-kilo);
  800ff3:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800ff6:	89 d0                	mov    %edx,%eax
  800ff8:	c1 e0 02             	shl    $0x2,%eax
  800ffb:	01 d0                	add    %edx,%eax
  800ffd:	2b 45 e4             	sub    -0x1c(%ebp),%eax
  801000:	83 ec 0c             	sub    $0xc,%esp
  801003:	50                   	push   %eax
  801004:	e8 66 16 00 00       	call   80266f <malloc>
  801009:	83 c4 10             	add    $0x10,%esp

		//Fill last 3MB allocation with data
		intArr = (int*) ptr_allocations[7];
  80100c:	8b 45 94             	mov    -0x6c(%ebp),%eax
  80100f:	89 45 d4             	mov    %eax,-0x2c(%ebp)
		lastIndexOfInt1 = (3*Mega-kilo)/sizeof(int) - 1;
  801012:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801015:	89 c2                	mov    %eax,%edx
  801017:	01 d2                	add    %edx,%edx
  801019:	01 d0                	add    %edx,%eax
  80101b:	2b 45 e4             	sub    -0x1c(%ebp),%eax
  80101e:	c1 e8 02             	shr    $0x2,%eax
  801021:	48                   	dec    %eax
  801022:	89 45 d0             	mov    %eax,-0x30(%ebp)

		i = 0;
  801025:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
		//filling the first 100 elements of the last 3 mega
		for (i=0; i < 100 ; i++)
  80102c:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  801033:	eb 17                	jmp    80104c <_main+0x1014>
		{
			intArr[i] = i ;
  801035:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801038:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80103f:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  801042:	01 c2                	add    %eax,%edx
  801044:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801047:	89 02                	mov    %eax,(%edx)
		intArr = (int*) ptr_allocations[7];
		lastIndexOfInt1 = (3*Mega-kilo)/sizeof(int) - 1;

		i = 0;
		//filling the first 100 elements of the last 3 mega
		for (i=0; i < 100 ; i++)
  801049:	ff 45 f0             	incl   -0x10(%ebp)
  80104c:	83 7d f0 63          	cmpl   $0x63,-0x10(%ebp)
  801050:	7e e3                	jle    801035 <_main+0xffd>
		{
			intArr[i] = i ;
		}

		for(i = lastIndexOfInt1; i > lastIndexOfInt1 - 100; i--)
  801052:	8b 45 d0             	mov    -0x30(%ebp),%eax
  801055:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801058:	eb 17                	jmp    801071 <_main+0x1039>
		{
			intArr[i] = i;
  80105a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80105d:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801064:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  801067:	01 c2                	add    %eax,%edx
  801069:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80106c:	89 02                	mov    %eax,(%edx)
		for (i=0; i < 100 ; i++)
		{
			intArr[i] = i ;
		}

		for(i = lastIndexOfInt1; i > lastIndexOfInt1 - 100; i--)
  80106e:	ff 4d f0             	decl   -0x10(%ebp)
  801071:	8b 45 d0             	mov    -0x30(%ebp),%eax
  801074:	83 e8 64             	sub    $0x64,%eax
  801077:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80107a:	7c de                	jl     80105a <_main+0x1022>
		{
			intArr[i] = i;
		}

		//Reallocate it to 4 MB, so that it can only fit at the 1st fragment
		freeFrames = sys_calculate_free_frames() ;
  80107c:	e8 fa 19 00 00       	call   802a7b <sys_calculate_free_frames>
  801081:	89 45 e0             	mov    %eax,-0x20(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  801084:	e8 92 1a 00 00       	call   802b1b <sys_pf_calculate_allocated_pages>
  801089:	89 45 dc             	mov    %eax,-0x24(%ebp)
		ptr_allocations[7] = realloc(ptr_allocations[7], 4*Mega-kilo);
  80108c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80108f:	c1 e0 02             	shl    $0x2,%eax
  801092:	2b 45 e4             	sub    -0x1c(%ebp),%eax
  801095:	89 c2                	mov    %eax,%edx
  801097:	8b 45 94             	mov    -0x6c(%ebp),%eax
  80109a:	83 ec 08             	sub    $0x8,%esp
  80109d:	52                   	push   %edx
  80109e:	50                   	push   %eax
  80109f:	e8 55 18 00 00       	call   8028f9 <realloc>
  8010a4:	83 c4 10             	add    $0x10,%esp
  8010a7:	89 45 94             	mov    %eax,-0x6c(%ebp)

		//[1] test return address & re-allocated space
		if ((uint32) ptr_allocations[7] != (USER_HEAP_START + 2*Mega)) panic("Wrong start address for the re-allocated space... ");
  8010aa:	8b 45 94             	mov    -0x6c(%ebp),%eax
  8010ad:	89 c2                	mov    %eax,%edx
  8010af:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8010b2:	01 c0                	add    %eax,%eax
  8010b4:	05 00 00 00 80       	add    $0x80000000,%eax
  8010b9:	39 c2                	cmp    %eax,%edx
  8010bb:	74 17                	je     8010d4 <_main+0x109c>
  8010bd:	83 ec 04             	sub    $0x4,%esp
  8010c0:	68 e8 45 80 00       	push   $0x8045e8
  8010c5:	68 7d 01 00 00       	push   $0x17d
  8010ca:	68 d4 42 80 00       	push   $0x8042d4
  8010cf:	e8 55 03 00 00       	call   801429 <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 256 - 1) panic("Wrong re-allocation");
		//if((sys_calculate_free_frames() - freeFrames) != 2 + 2) panic("Wrong re-allocation: either extra pages are re-allocated in memory or pages not allocated correctly on PageFile");
		if((sys_pf_calculate_allocated_pages() - usedDiskPages) != 256) panic("Extra or less pages are re-allocated in PageFile");
  8010d4:	e8 42 1a 00 00       	call   802b1b <sys_pf_calculate_allocated_pages>
  8010d9:	2b 45 dc             	sub    -0x24(%ebp),%eax
  8010dc:	3d 00 01 00 00       	cmp    $0x100,%eax
  8010e1:	74 17                	je     8010fa <_main+0x10c2>
  8010e3:	83 ec 04             	sub    $0x4,%esp
  8010e6:	68 c8 44 80 00       	push   $0x8044c8
  8010eb:	68 80 01 00 00       	push   $0x180
  8010f0:	68 d4 42 80 00       	push   $0x8042d4
  8010f5:	e8 2f 03 00 00       	call   801429 <_panic>


		//[2] test memory access
		lastIndexOfInt2 = (4*Mega-kilo)/sizeof(int) - 1;
  8010fa:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8010fd:	c1 e0 02             	shl    $0x2,%eax
  801100:	2b 45 e4             	sub    -0x1c(%ebp),%eax
  801103:	c1 e8 02             	shr    $0x2,%eax
  801106:	48                   	dec    %eax
  801107:	89 45 cc             	mov    %eax,-0x34(%ebp)
		intArr = (int*) ptr_allocations[7];
  80110a:	8b 45 94             	mov    -0x6c(%ebp),%eax
  80110d:	89 45 d4             	mov    %eax,-0x2c(%ebp)
		for (i=lastIndexOfInt1 + 1; i < lastIndexOfInt1 + 101 ; i++)
  801110:	8b 45 d0             	mov    -0x30(%ebp),%eax
  801113:	40                   	inc    %eax
  801114:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801117:	eb 17                	jmp    801130 <_main+0x10f8>
		{
			intArr[i] = i ;
  801119:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80111c:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801123:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  801126:	01 c2                	add    %eax,%edx
  801128:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80112b:	89 02                	mov    %eax,(%edx)


		//[2] test memory access
		lastIndexOfInt2 = (4*Mega-kilo)/sizeof(int) - 1;
		intArr = (int*) ptr_allocations[7];
		for (i=lastIndexOfInt1 + 1; i < lastIndexOfInt1 + 101 ; i++)
  80112d:	ff 45 f0             	incl   -0x10(%ebp)
  801130:	8b 45 d0             	mov    -0x30(%ebp),%eax
  801133:	83 c0 65             	add    $0x65,%eax
  801136:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801139:	7f de                	jg     801119 <_main+0x10e1>
		{
			intArr[i] = i ;
		}

		for(i = lastIndexOfInt2; i > lastIndexOfInt2 - 100; i--)
  80113b:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80113e:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801141:	eb 17                	jmp    80115a <_main+0x1122>
		{
			intArr[i] = i;
  801143:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801146:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80114d:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  801150:	01 c2                	add    %eax,%edx
  801152:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801155:	89 02                	mov    %eax,(%edx)
		for (i=lastIndexOfInt1 + 1; i < lastIndexOfInt1 + 101 ; i++)
		{
			intArr[i] = i ;
		}

		for(i = lastIndexOfInt2; i > lastIndexOfInt2 - 100; i--)
  801157:	ff 4d f0             	decl   -0x10(%ebp)
  80115a:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80115d:	83 e8 64             	sub    $0x64,%eax
  801160:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801163:	7c de                	jl     801143 <_main+0x110b>
		{
			intArr[i] = i;
		}

		for (i=0; i < 100 ; i++)
  801165:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  80116c:	eb 33                	jmp    8011a1 <_main+0x1169>
		{
			cnt++;
  80116e:	ff 45 f4             	incl   -0xc(%ebp)
			if (intArr[i] != i) panic("Wrong re-allocation: stored values are wrongly changed!");
  801171:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801174:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80117b:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80117e:	01 d0                	add    %edx,%eax
  801180:	8b 00                	mov    (%eax),%eax
  801182:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801185:	74 17                	je     80119e <_main+0x1166>
  801187:	83 ec 04             	sub    $0x4,%esp
  80118a:	68 a8 45 80 00       	push   $0x8045a8
  80118f:	68 93 01 00 00       	push   $0x193
  801194:	68 d4 42 80 00       	push   $0x8042d4
  801199:	e8 8b 02 00 00       	call   801429 <_panic>
		for(i = lastIndexOfInt2; i > lastIndexOfInt2 - 100; i--)
		{
			intArr[i] = i;
		}

		for (i=0; i < 100 ; i++)
  80119e:	ff 45 f0             	incl   -0x10(%ebp)
  8011a1:	83 7d f0 63          	cmpl   $0x63,-0x10(%ebp)
  8011a5:	7e c7                	jle    80116e <_main+0x1136>
		{
			cnt++;
			if (intArr[i] != i) panic("Wrong re-allocation: stored values are wrongly changed!");
		}

		for (i=lastIndexOfInt1; i > lastIndexOfInt1 - 100 ; i--)
  8011a7:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8011aa:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8011ad:	eb 33                	jmp    8011e2 <_main+0x11aa>
		{
			cnt++;
  8011af:	ff 45 f4             	incl   -0xc(%ebp)
			if (intArr[i] != i) panic("Wrong re-allocation: stored values are wrongly changed!");
  8011b2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8011b5:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8011bc:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8011bf:	01 d0                	add    %edx,%eax
  8011c1:	8b 00                	mov    (%eax),%eax
  8011c3:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8011c6:	74 17                	je     8011df <_main+0x11a7>
  8011c8:	83 ec 04             	sub    $0x4,%esp
  8011cb:	68 a8 45 80 00       	push   $0x8045a8
  8011d0:	68 99 01 00 00       	push   $0x199
  8011d5:	68 d4 42 80 00       	push   $0x8042d4
  8011da:	e8 4a 02 00 00       	call   801429 <_panic>
		{
			cnt++;
			if (intArr[i] != i) panic("Wrong re-allocation: stored values are wrongly changed!");
		}

		for (i=lastIndexOfInt1; i > lastIndexOfInt1 - 100 ; i--)
  8011df:	ff 4d f0             	decl   -0x10(%ebp)
  8011e2:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8011e5:	83 e8 64             	sub    $0x64,%eax
  8011e8:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8011eb:	7c c2                	jl     8011af <_main+0x1177>
		{
			cnt++;
			if (intArr[i] != i) panic("Wrong re-allocation: stored values are wrongly changed!");
		}

		for (i=lastIndexOfInt1 + 1; i < lastIndexOfInt1 + 101 ; i++)
  8011ed:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8011f0:	40                   	inc    %eax
  8011f1:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8011f4:	eb 33                	jmp    801229 <_main+0x11f1>
		{
			cnt++;
  8011f6:	ff 45 f4             	incl   -0xc(%ebp)
			if (intArr[i] != i) panic("Wrong re-allocation: stored values are wrongly changed!");
  8011f9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8011fc:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801203:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  801206:	01 d0                	add    %edx,%eax
  801208:	8b 00                	mov    (%eax),%eax
  80120a:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80120d:	74 17                	je     801226 <_main+0x11ee>
  80120f:	83 ec 04             	sub    $0x4,%esp
  801212:	68 a8 45 80 00       	push   $0x8045a8
  801217:	68 9f 01 00 00       	push   $0x19f
  80121c:	68 d4 42 80 00       	push   $0x8042d4
  801221:	e8 03 02 00 00       	call   801429 <_panic>
		{
			cnt++;
			if (intArr[i] != i) panic("Wrong re-allocation: stored values are wrongly changed!");
		}

		for (i=lastIndexOfInt1 + 1; i < lastIndexOfInt1 + 101 ; i++)
  801226:	ff 45 f0             	incl   -0x10(%ebp)
  801229:	8b 45 d0             	mov    -0x30(%ebp),%eax
  80122c:	83 c0 65             	add    $0x65,%eax
  80122f:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801232:	7f c2                	jg     8011f6 <_main+0x11be>
		{
			cnt++;
			if (intArr[i] != i) panic("Wrong re-allocation: stored values are wrongly changed!");
		}

		for(i = lastIndexOfInt2; i > lastIndexOfInt2 - 100; i--)
  801234:	8b 45 cc             	mov    -0x34(%ebp),%eax
  801237:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80123a:	eb 33                	jmp    80126f <_main+0x1237>
		{
			cnt++;
  80123c:	ff 45 f4             	incl   -0xc(%ebp)
			if (intArr[i] != i) panic("Wrong re-allocation: stored values are wrongly changed!");
  80123f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801242:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801249:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80124c:	01 d0                	add    %edx,%eax
  80124e:	8b 00                	mov    (%eax),%eax
  801250:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801253:	74 17                	je     80126c <_main+0x1234>
  801255:	83 ec 04             	sub    $0x4,%esp
  801258:	68 a8 45 80 00       	push   $0x8045a8
  80125d:	68 a5 01 00 00       	push   $0x1a5
  801262:	68 d4 42 80 00       	push   $0x8042d4
  801267:	e8 bd 01 00 00       	call   801429 <_panic>
		{
			cnt++;
			if (intArr[i] != i) panic("Wrong re-allocation: stored values are wrongly changed!");
		}

		for(i = lastIndexOfInt2; i > lastIndexOfInt2 - 100; i--)
  80126c:	ff 4d f0             	decl   -0x10(%ebp)
  80126f:	8b 45 cc             	mov    -0x34(%ebp),%eax
  801272:	83 e8 64             	sub    $0x64,%eax
  801275:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801278:	7c c2                	jl     80123c <_main+0x1204>
			cnt++;
			if (intArr[i] != i) panic("Wrong re-allocation: stored values are wrongly changed!");
		}

		//[3] test freeing it after expansion
		freeFrames = sys_calculate_free_frames() ;
  80127a:	e8 fc 17 00 00       	call   802a7b <sys_calculate_free_frames>
  80127f:	89 45 e0             	mov    %eax,-0x20(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  801282:	e8 94 18 00 00       	call   802b1b <sys_pf_calculate_allocated_pages>
  801287:	89 45 dc             	mov    %eax,-0x24(%ebp)
		free(ptr_allocations[7]);
  80128a:	8b 45 94             	mov    -0x6c(%ebp),%eax
  80128d:	83 ec 0c             	sub    $0xc,%esp
  801290:	50                   	push   %eax
  801291:	e8 5a 14 00 00       	call   8026f0 <free>
  801296:	83 c4 10             	add    $0x10,%esp
		//if ((sys_calculate_free_frames() - freeFrames) != 1024) panic("Wrong free of the re-allocated space");
		if ((usedDiskPages - sys_pf_calculate_allocated_pages()) != 1024) panic("Wrong free of the re-allocated space: Extra or less pages are removed from PageFile");
  801299:	e8 7d 18 00 00       	call   802b1b <sys_pf_calculate_allocated_pages>
  80129e:	8b 55 dc             	mov    -0x24(%ebp),%edx
  8012a1:	29 c2                	sub    %eax,%edx
  8012a3:	89 d0                	mov    %edx,%eax
  8012a5:	3d 00 04 00 00       	cmp    $0x400,%eax
  8012aa:	74 17                	je     8012c3 <_main+0x128b>
  8012ac:	83 ec 04             	sub    $0x4,%esp
  8012af:	68 1c 46 80 00       	push   $0x80461c
  8012b4:	68 ad 01 00 00       	push   $0x1ad
  8012b9:	68 d4 42 80 00       	push   $0x8042d4
  8012be:	e8 66 01 00 00       	call   801429 <_panic>
		//if ((sys_calculate_free_frames() - freeFrames) != 4 + 1) panic("Wrong free of the re-allocated space: WS pages in memory and/or page tables are not freed correctly");

		vcprintf("\b\b\b100%\n", NULL);
  8012c3:	83 ec 08             	sub    $0x8,%esp
  8012c6:	6a 00                	push   $0x0
  8012c8:	68 e2 46 80 00       	push   $0x8046e2
  8012cd:	e8 a0 03 00 00       	call   801672 <vcprintf>
  8012d2:	83 c4 10             	add    $0x10,%esp
	}



	cprintf("Congratulations!! test realloc [2] completed successfully.\n");
  8012d5:	83 ec 0c             	sub    $0xc,%esp
  8012d8:	68 ec 46 80 00       	push   $0x8046ec
  8012dd:	e8 fb 03 00 00       	call   8016dd <cprintf>
  8012e2:	83 c4 10             	add    $0x10,%esp

	return;
  8012e5:	90                   	nop
}
  8012e6:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8012e9:	5b                   	pop    %ebx
  8012ea:	5f                   	pop    %edi
  8012eb:	5d                   	pop    %ebp
  8012ec:	c3                   	ret    

008012ed <libmain>:
volatile struct Env *myEnv = NULL;
volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";

void
libmain(int argc, char **argv)
{
  8012ed:	55                   	push   %ebp
  8012ee:	89 e5                	mov    %esp,%ebp
  8012f0:	83 ec 18             	sub    $0x18,%esp
	int envIndex = sys_getenvindex();
  8012f3:	e8 63 1a 00 00       	call   802d5b <sys_getenvindex>
  8012f8:	89 45 f4             	mov    %eax,-0xc(%ebp)
	myEnv = &(envs[envIndex]);
  8012fb:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8012fe:	89 d0                	mov    %edx,%eax
  801300:	c1 e0 03             	shl    $0x3,%eax
  801303:	01 d0                	add    %edx,%eax
  801305:	01 c0                	add    %eax,%eax
  801307:	01 d0                	add    %edx,%eax
  801309:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801310:	01 d0                	add    %edx,%eax
  801312:	c1 e0 04             	shl    $0x4,%eax
  801315:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  80131a:	a3 20 50 80 00       	mov    %eax,0x805020

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  80131f:	a1 20 50 80 00       	mov    0x805020,%eax
  801324:	8a 80 5c 05 00 00    	mov    0x55c(%eax),%al
  80132a:	84 c0                	test   %al,%al
  80132c:	74 0f                	je     80133d <libmain+0x50>
		binaryname = myEnv->prog_name;
  80132e:	a1 20 50 80 00       	mov    0x805020,%eax
  801333:	05 5c 05 00 00       	add    $0x55c,%eax
  801338:	a3 00 50 80 00       	mov    %eax,0x805000

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  80133d:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801341:	7e 0a                	jle    80134d <libmain+0x60>
		binaryname = argv[0];
  801343:	8b 45 0c             	mov    0xc(%ebp),%eax
  801346:	8b 00                	mov    (%eax),%eax
  801348:	a3 00 50 80 00       	mov    %eax,0x805000

	// call user main routine
	_main(argc, argv);
  80134d:	83 ec 08             	sub    $0x8,%esp
  801350:	ff 75 0c             	pushl  0xc(%ebp)
  801353:	ff 75 08             	pushl  0x8(%ebp)
  801356:	e8 dd ec ff ff       	call   800038 <_main>
  80135b:	83 c4 10             	add    $0x10,%esp



	sys_disable_interrupt();
  80135e:	e8 05 18 00 00       	call   802b68 <sys_disable_interrupt>
	cprintf("**************************************\n");
  801363:	83 ec 0c             	sub    $0xc,%esp
  801366:	68 40 47 80 00       	push   $0x804740
  80136b:	e8 6d 03 00 00       	call   8016dd <cprintf>
  801370:	83 c4 10             	add    $0x10,%esp
	cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  801373:	a1 20 50 80 00       	mov    0x805020,%eax
  801378:	8b 90 44 05 00 00    	mov    0x544(%eax),%edx
  80137e:	a1 20 50 80 00       	mov    0x805020,%eax
  801383:	8b 80 34 05 00 00    	mov    0x534(%eax),%eax
  801389:	83 ec 04             	sub    $0x4,%esp
  80138c:	52                   	push   %edx
  80138d:	50                   	push   %eax
  80138e:	68 68 47 80 00       	push   $0x804768
  801393:	e8 45 03 00 00       	call   8016dd <cprintf>
  801398:	83 c4 10             	add    $0x10,%esp
	cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  80139b:	a1 20 50 80 00       	mov    0x805020,%eax
  8013a0:	8b 88 54 05 00 00    	mov    0x554(%eax),%ecx
  8013a6:	a1 20 50 80 00       	mov    0x805020,%eax
  8013ab:	8b 90 50 05 00 00    	mov    0x550(%eax),%edx
  8013b1:	a1 20 50 80 00       	mov    0x805020,%eax
  8013b6:	8b 80 4c 05 00 00    	mov    0x54c(%eax),%eax
  8013bc:	51                   	push   %ecx
  8013bd:	52                   	push   %edx
  8013be:	50                   	push   %eax
  8013bf:	68 90 47 80 00       	push   $0x804790
  8013c4:	e8 14 03 00 00       	call   8016dd <cprintf>
  8013c9:	83 c4 10             	add    $0x10,%esp
	//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
	cprintf("Num of clocks = %d\n", myEnv->nClocks);
  8013cc:	a1 20 50 80 00       	mov    0x805020,%eax
  8013d1:	8b 80 a4 05 00 00    	mov    0x5a4(%eax),%eax
  8013d7:	83 ec 08             	sub    $0x8,%esp
  8013da:	50                   	push   %eax
  8013db:	68 e8 47 80 00       	push   $0x8047e8
  8013e0:	e8 f8 02 00 00       	call   8016dd <cprintf>
  8013e5:	83 c4 10             	add    $0x10,%esp
	cprintf("**************************************\n");
  8013e8:	83 ec 0c             	sub    $0xc,%esp
  8013eb:	68 40 47 80 00       	push   $0x804740
  8013f0:	e8 e8 02 00 00       	call   8016dd <cprintf>
  8013f5:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  8013f8:	e8 85 17 00 00       	call   802b82 <sys_enable_interrupt>

	// exit gracefully
	exit();
  8013fd:	e8 19 00 00 00       	call   80141b <exit>
}
  801402:	90                   	nop
  801403:	c9                   	leave  
  801404:	c3                   	ret    

00801405 <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  801405:	55                   	push   %ebp
  801406:	89 e5                	mov    %esp,%ebp
  801408:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  80140b:	83 ec 0c             	sub    $0xc,%esp
  80140e:	6a 00                	push   $0x0
  801410:	e8 12 19 00 00       	call   802d27 <sys_destroy_env>
  801415:	83 c4 10             	add    $0x10,%esp
}
  801418:	90                   	nop
  801419:	c9                   	leave  
  80141a:	c3                   	ret    

0080141b <exit>:

void
exit(void)
{
  80141b:	55                   	push   %ebp
  80141c:	89 e5                	mov    %esp,%ebp
  80141e:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  801421:	e8 67 19 00 00       	call   802d8d <sys_exit_env>
}
  801426:	90                   	nop
  801427:	c9                   	leave  
  801428:	c3                   	ret    

00801429 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  801429:	55                   	push   %ebp
  80142a:	89 e5                	mov    %esp,%ebp
  80142c:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  80142f:	8d 45 10             	lea    0x10(%ebp),%eax
  801432:	83 c0 04             	add    $0x4,%eax
  801435:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  801438:	a1 5c 51 80 00       	mov    0x80515c,%eax
  80143d:	85 c0                	test   %eax,%eax
  80143f:	74 16                	je     801457 <_panic+0x2e>
		cprintf("%s: ", argv0);
  801441:	a1 5c 51 80 00       	mov    0x80515c,%eax
  801446:	83 ec 08             	sub    $0x8,%esp
  801449:	50                   	push   %eax
  80144a:	68 fc 47 80 00       	push   $0x8047fc
  80144f:	e8 89 02 00 00       	call   8016dd <cprintf>
  801454:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  801457:	a1 00 50 80 00       	mov    0x805000,%eax
  80145c:	ff 75 0c             	pushl  0xc(%ebp)
  80145f:	ff 75 08             	pushl  0x8(%ebp)
  801462:	50                   	push   %eax
  801463:	68 01 48 80 00       	push   $0x804801
  801468:	e8 70 02 00 00       	call   8016dd <cprintf>
  80146d:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  801470:	8b 45 10             	mov    0x10(%ebp),%eax
  801473:	83 ec 08             	sub    $0x8,%esp
  801476:	ff 75 f4             	pushl  -0xc(%ebp)
  801479:	50                   	push   %eax
  80147a:	e8 f3 01 00 00       	call   801672 <vcprintf>
  80147f:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  801482:	83 ec 08             	sub    $0x8,%esp
  801485:	6a 00                	push   $0x0
  801487:	68 1d 48 80 00       	push   $0x80481d
  80148c:	e8 e1 01 00 00       	call   801672 <vcprintf>
  801491:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  801494:	e8 82 ff ff ff       	call   80141b <exit>

	// should not return here
	while (1) ;
  801499:	eb fe                	jmp    801499 <_panic+0x70>

0080149b <CheckWSWithoutLastIndex>:
}

void CheckWSWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  80149b:	55                   	push   %ebp
  80149c:	89 e5                	mov    %esp,%ebp
  80149e:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  8014a1:	a1 20 50 80 00       	mov    0x805020,%eax
  8014a6:	8b 50 74             	mov    0x74(%eax),%edx
  8014a9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8014ac:	39 c2                	cmp    %eax,%edx
  8014ae:	74 14                	je     8014c4 <CheckWSWithoutLastIndex+0x29>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  8014b0:	83 ec 04             	sub    $0x4,%esp
  8014b3:	68 20 48 80 00       	push   $0x804820
  8014b8:	6a 26                	push   $0x26
  8014ba:	68 6c 48 80 00       	push   $0x80486c
  8014bf:	e8 65 ff ff ff       	call   801429 <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  8014c4:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  8014cb:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  8014d2:	e9 c2 00 00 00       	jmp    801599 <CheckWSWithoutLastIndex+0xfe>
		if (expectedPages[e] == 0) {
  8014d7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8014da:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8014e1:	8b 45 08             	mov    0x8(%ebp),%eax
  8014e4:	01 d0                	add    %edx,%eax
  8014e6:	8b 00                	mov    (%eax),%eax
  8014e8:	85 c0                	test   %eax,%eax
  8014ea:	75 08                	jne    8014f4 <CheckWSWithoutLastIndex+0x59>
			expectedNumOfEmptyLocs++;
  8014ec:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  8014ef:	e9 a2 00 00 00       	jmp    801596 <CheckWSWithoutLastIndex+0xfb>
		}
		int found = 0;
  8014f4:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8014fb:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  801502:	eb 69                	jmp    80156d <CheckWSWithoutLastIndex+0xd2>
			if (myEnv->__uptr_pws[w].empty == 0) {
  801504:	a1 20 50 80 00       	mov    0x805020,%eax
  801509:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  80150f:	8b 55 e8             	mov    -0x18(%ebp),%edx
  801512:	89 d0                	mov    %edx,%eax
  801514:	01 c0                	add    %eax,%eax
  801516:	01 d0                	add    %edx,%eax
  801518:	c1 e0 03             	shl    $0x3,%eax
  80151b:	01 c8                	add    %ecx,%eax
  80151d:	8a 40 04             	mov    0x4(%eax),%al
  801520:	84 c0                	test   %al,%al
  801522:	75 46                	jne    80156a <CheckWSWithoutLastIndex+0xcf>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  801524:	a1 20 50 80 00       	mov    0x805020,%eax
  801529:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  80152f:	8b 55 e8             	mov    -0x18(%ebp),%edx
  801532:	89 d0                	mov    %edx,%eax
  801534:	01 c0                	add    %eax,%eax
  801536:	01 d0                	add    %edx,%eax
  801538:	c1 e0 03             	shl    $0x3,%eax
  80153b:	01 c8                	add    %ecx,%eax
  80153d:	8b 00                	mov    (%eax),%eax
  80153f:	89 45 dc             	mov    %eax,-0x24(%ebp)
  801542:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801545:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80154a:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  80154c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80154f:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  801556:	8b 45 08             	mov    0x8(%ebp),%eax
  801559:	01 c8                	add    %ecx,%eax
  80155b:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  80155d:	39 c2                	cmp    %eax,%edx
  80155f:	75 09                	jne    80156a <CheckWSWithoutLastIndex+0xcf>
						== expectedPages[e]) {
					found = 1;
  801561:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  801568:	eb 12                	jmp    80157c <CheckWSWithoutLastIndex+0xe1>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  80156a:	ff 45 e8             	incl   -0x18(%ebp)
  80156d:	a1 20 50 80 00       	mov    0x805020,%eax
  801572:	8b 50 74             	mov    0x74(%eax),%edx
  801575:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801578:	39 c2                	cmp    %eax,%edx
  80157a:	77 88                	ja     801504 <CheckWSWithoutLastIndex+0x69>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  80157c:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  801580:	75 14                	jne    801596 <CheckWSWithoutLastIndex+0xfb>
			panic(
  801582:	83 ec 04             	sub    $0x4,%esp
  801585:	68 78 48 80 00       	push   $0x804878
  80158a:	6a 3a                	push   $0x3a
  80158c:	68 6c 48 80 00       	push   $0x80486c
  801591:	e8 93 fe ff ff       	call   801429 <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  801596:	ff 45 f0             	incl   -0x10(%ebp)
  801599:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80159c:	3b 45 0c             	cmp    0xc(%ebp),%eax
  80159f:	0f 8c 32 ff ff ff    	jl     8014d7 <CheckWSWithoutLastIndex+0x3c>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  8015a5:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8015ac:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  8015b3:	eb 26                	jmp    8015db <CheckWSWithoutLastIndex+0x140>
		if (myEnv->__uptr_pws[w].empty == 1) {
  8015b5:	a1 20 50 80 00       	mov    0x805020,%eax
  8015ba:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  8015c0:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8015c3:	89 d0                	mov    %edx,%eax
  8015c5:	01 c0                	add    %eax,%eax
  8015c7:	01 d0                	add    %edx,%eax
  8015c9:	c1 e0 03             	shl    $0x3,%eax
  8015cc:	01 c8                	add    %ecx,%eax
  8015ce:	8a 40 04             	mov    0x4(%eax),%al
  8015d1:	3c 01                	cmp    $0x1,%al
  8015d3:	75 03                	jne    8015d8 <CheckWSWithoutLastIndex+0x13d>
			actualNumOfEmptyLocs++;
  8015d5:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8015d8:	ff 45 e0             	incl   -0x20(%ebp)
  8015db:	a1 20 50 80 00       	mov    0x805020,%eax
  8015e0:	8b 50 74             	mov    0x74(%eax),%edx
  8015e3:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8015e6:	39 c2                	cmp    %eax,%edx
  8015e8:	77 cb                	ja     8015b5 <CheckWSWithoutLastIndex+0x11a>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  8015ea:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8015ed:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  8015f0:	74 14                	je     801606 <CheckWSWithoutLastIndex+0x16b>
		panic(
  8015f2:	83 ec 04             	sub    $0x4,%esp
  8015f5:	68 cc 48 80 00       	push   $0x8048cc
  8015fa:	6a 44                	push   $0x44
  8015fc:	68 6c 48 80 00       	push   $0x80486c
  801601:	e8 23 fe ff ff       	call   801429 <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  801606:	90                   	nop
  801607:	c9                   	leave  
  801608:	c3                   	ret    

00801609 <putch>:
};

//2017:
uint8 printProgName = 0;

static void putch(int ch, struct printbuf *b) {
  801609:	55                   	push   %ebp
  80160a:	89 e5                	mov    %esp,%ebp
  80160c:	83 ec 08             	sub    $0x8,%esp
	b->buf[b->idx++] = ch;
  80160f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801612:	8b 00                	mov    (%eax),%eax
  801614:	8d 48 01             	lea    0x1(%eax),%ecx
  801617:	8b 55 0c             	mov    0xc(%ebp),%edx
  80161a:	89 0a                	mov    %ecx,(%edx)
  80161c:	8b 55 08             	mov    0x8(%ebp),%edx
  80161f:	88 d1                	mov    %dl,%cl
  801621:	8b 55 0c             	mov    0xc(%ebp),%edx
  801624:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  801628:	8b 45 0c             	mov    0xc(%ebp),%eax
  80162b:	8b 00                	mov    (%eax),%eax
  80162d:	3d ff 00 00 00       	cmp    $0xff,%eax
  801632:	75 2c                	jne    801660 <putch+0x57>
		sys_cputs(b->buf, b->idx, printProgName);
  801634:	a0 24 50 80 00       	mov    0x805024,%al
  801639:	0f b6 c0             	movzbl %al,%eax
  80163c:	8b 55 0c             	mov    0xc(%ebp),%edx
  80163f:	8b 12                	mov    (%edx),%edx
  801641:	89 d1                	mov    %edx,%ecx
  801643:	8b 55 0c             	mov    0xc(%ebp),%edx
  801646:	83 c2 08             	add    $0x8,%edx
  801649:	83 ec 04             	sub    $0x4,%esp
  80164c:	50                   	push   %eax
  80164d:	51                   	push   %ecx
  80164e:	52                   	push   %edx
  80164f:	e8 66 13 00 00       	call   8029ba <sys_cputs>
  801654:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  801657:	8b 45 0c             	mov    0xc(%ebp),%eax
  80165a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  801660:	8b 45 0c             	mov    0xc(%ebp),%eax
  801663:	8b 40 04             	mov    0x4(%eax),%eax
  801666:	8d 50 01             	lea    0x1(%eax),%edx
  801669:	8b 45 0c             	mov    0xc(%ebp),%eax
  80166c:	89 50 04             	mov    %edx,0x4(%eax)
}
  80166f:	90                   	nop
  801670:	c9                   	leave  
  801671:	c3                   	ret    

00801672 <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  801672:	55                   	push   %ebp
  801673:	89 e5                	mov    %esp,%ebp
  801675:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  80167b:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  801682:	00 00 00 
	b.cnt = 0;
  801685:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  80168c:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  80168f:	ff 75 0c             	pushl  0xc(%ebp)
  801692:	ff 75 08             	pushl  0x8(%ebp)
  801695:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  80169b:	50                   	push   %eax
  80169c:	68 09 16 80 00       	push   $0x801609
  8016a1:	e8 11 02 00 00       	call   8018b7 <vprintfmt>
  8016a6:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName);
  8016a9:	a0 24 50 80 00       	mov    0x805024,%al
  8016ae:	0f b6 c0             	movzbl %al,%eax
  8016b1:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  8016b7:	83 ec 04             	sub    $0x4,%esp
  8016ba:	50                   	push   %eax
  8016bb:	52                   	push   %edx
  8016bc:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8016c2:	83 c0 08             	add    $0x8,%eax
  8016c5:	50                   	push   %eax
  8016c6:	e8 ef 12 00 00       	call   8029ba <sys_cputs>
  8016cb:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  8016ce:	c6 05 24 50 80 00 00 	movb   $0x0,0x805024
	return b.cnt;
  8016d5:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  8016db:	c9                   	leave  
  8016dc:	c3                   	ret    

008016dd <cprintf>:

int cprintf(const char *fmt, ...) {
  8016dd:	55                   	push   %ebp
  8016de:	89 e5                	mov    %esp,%ebp
  8016e0:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  8016e3:	c6 05 24 50 80 00 01 	movb   $0x1,0x805024
	va_start(ap, fmt);
  8016ea:	8d 45 0c             	lea    0xc(%ebp),%eax
  8016ed:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  8016f0:	8b 45 08             	mov    0x8(%ebp),%eax
  8016f3:	83 ec 08             	sub    $0x8,%esp
  8016f6:	ff 75 f4             	pushl  -0xc(%ebp)
  8016f9:	50                   	push   %eax
  8016fa:	e8 73 ff ff ff       	call   801672 <vcprintf>
  8016ff:	83 c4 10             	add    $0x10,%esp
  801702:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  801705:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801708:	c9                   	leave  
  801709:	c3                   	ret    

0080170a <atomic_cprintf>:

int atomic_cprintf(const char *fmt, ...) {
  80170a:	55                   	push   %ebp
  80170b:	89 e5                	mov    %esp,%ebp
  80170d:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  801710:	e8 53 14 00 00       	call   802b68 <sys_disable_interrupt>
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  801715:	8d 45 0c             	lea    0xc(%ebp),%eax
  801718:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  80171b:	8b 45 08             	mov    0x8(%ebp),%eax
  80171e:	83 ec 08             	sub    $0x8,%esp
  801721:	ff 75 f4             	pushl  -0xc(%ebp)
  801724:	50                   	push   %eax
  801725:	e8 48 ff ff ff       	call   801672 <vcprintf>
  80172a:	83 c4 10             	add    $0x10,%esp
  80172d:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	sys_enable_interrupt();
  801730:	e8 4d 14 00 00       	call   802b82 <sys_enable_interrupt>
	return cnt;
  801735:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801738:	c9                   	leave  
  801739:	c3                   	ret    

0080173a <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  80173a:	55                   	push   %ebp
  80173b:	89 e5                	mov    %esp,%ebp
  80173d:	53                   	push   %ebx
  80173e:	83 ec 14             	sub    $0x14,%esp
  801741:	8b 45 10             	mov    0x10(%ebp),%eax
  801744:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801747:	8b 45 14             	mov    0x14(%ebp),%eax
  80174a:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  80174d:	8b 45 18             	mov    0x18(%ebp),%eax
  801750:	ba 00 00 00 00       	mov    $0x0,%edx
  801755:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  801758:	77 55                	ja     8017af <printnum+0x75>
  80175a:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  80175d:	72 05                	jb     801764 <printnum+0x2a>
  80175f:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801762:	77 4b                	ja     8017af <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  801764:	8b 45 1c             	mov    0x1c(%ebp),%eax
  801767:	8d 58 ff             	lea    -0x1(%eax),%ebx
  80176a:	8b 45 18             	mov    0x18(%ebp),%eax
  80176d:	ba 00 00 00 00       	mov    $0x0,%edx
  801772:	52                   	push   %edx
  801773:	50                   	push   %eax
  801774:	ff 75 f4             	pushl  -0xc(%ebp)
  801777:	ff 75 f0             	pushl  -0x10(%ebp)
  80177a:	e8 85 28 00 00       	call   804004 <__udivdi3>
  80177f:	83 c4 10             	add    $0x10,%esp
  801782:	83 ec 04             	sub    $0x4,%esp
  801785:	ff 75 20             	pushl  0x20(%ebp)
  801788:	53                   	push   %ebx
  801789:	ff 75 18             	pushl  0x18(%ebp)
  80178c:	52                   	push   %edx
  80178d:	50                   	push   %eax
  80178e:	ff 75 0c             	pushl  0xc(%ebp)
  801791:	ff 75 08             	pushl  0x8(%ebp)
  801794:	e8 a1 ff ff ff       	call   80173a <printnum>
  801799:	83 c4 20             	add    $0x20,%esp
  80179c:	eb 1a                	jmp    8017b8 <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  80179e:	83 ec 08             	sub    $0x8,%esp
  8017a1:	ff 75 0c             	pushl  0xc(%ebp)
  8017a4:	ff 75 20             	pushl  0x20(%ebp)
  8017a7:	8b 45 08             	mov    0x8(%ebp),%eax
  8017aa:	ff d0                	call   *%eax
  8017ac:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  8017af:	ff 4d 1c             	decl   0x1c(%ebp)
  8017b2:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  8017b6:	7f e6                	jg     80179e <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  8017b8:	8b 4d 18             	mov    0x18(%ebp),%ecx
  8017bb:	bb 00 00 00 00       	mov    $0x0,%ebx
  8017c0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8017c3:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8017c6:	53                   	push   %ebx
  8017c7:	51                   	push   %ecx
  8017c8:	52                   	push   %edx
  8017c9:	50                   	push   %eax
  8017ca:	e8 45 29 00 00       	call   804114 <__umoddi3>
  8017cf:	83 c4 10             	add    $0x10,%esp
  8017d2:	05 34 4b 80 00       	add    $0x804b34,%eax
  8017d7:	8a 00                	mov    (%eax),%al
  8017d9:	0f be c0             	movsbl %al,%eax
  8017dc:	83 ec 08             	sub    $0x8,%esp
  8017df:	ff 75 0c             	pushl  0xc(%ebp)
  8017e2:	50                   	push   %eax
  8017e3:	8b 45 08             	mov    0x8(%ebp),%eax
  8017e6:	ff d0                	call   *%eax
  8017e8:	83 c4 10             	add    $0x10,%esp
}
  8017eb:	90                   	nop
  8017ec:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8017ef:	c9                   	leave  
  8017f0:	c3                   	ret    

008017f1 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  8017f1:	55                   	push   %ebp
  8017f2:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  8017f4:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  8017f8:	7e 1c                	jle    801816 <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  8017fa:	8b 45 08             	mov    0x8(%ebp),%eax
  8017fd:	8b 00                	mov    (%eax),%eax
  8017ff:	8d 50 08             	lea    0x8(%eax),%edx
  801802:	8b 45 08             	mov    0x8(%ebp),%eax
  801805:	89 10                	mov    %edx,(%eax)
  801807:	8b 45 08             	mov    0x8(%ebp),%eax
  80180a:	8b 00                	mov    (%eax),%eax
  80180c:	83 e8 08             	sub    $0x8,%eax
  80180f:	8b 50 04             	mov    0x4(%eax),%edx
  801812:	8b 00                	mov    (%eax),%eax
  801814:	eb 40                	jmp    801856 <getuint+0x65>
	else if (lflag)
  801816:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80181a:	74 1e                	je     80183a <getuint+0x49>
		return va_arg(*ap, unsigned long);
  80181c:	8b 45 08             	mov    0x8(%ebp),%eax
  80181f:	8b 00                	mov    (%eax),%eax
  801821:	8d 50 04             	lea    0x4(%eax),%edx
  801824:	8b 45 08             	mov    0x8(%ebp),%eax
  801827:	89 10                	mov    %edx,(%eax)
  801829:	8b 45 08             	mov    0x8(%ebp),%eax
  80182c:	8b 00                	mov    (%eax),%eax
  80182e:	83 e8 04             	sub    $0x4,%eax
  801831:	8b 00                	mov    (%eax),%eax
  801833:	ba 00 00 00 00       	mov    $0x0,%edx
  801838:	eb 1c                	jmp    801856 <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  80183a:	8b 45 08             	mov    0x8(%ebp),%eax
  80183d:	8b 00                	mov    (%eax),%eax
  80183f:	8d 50 04             	lea    0x4(%eax),%edx
  801842:	8b 45 08             	mov    0x8(%ebp),%eax
  801845:	89 10                	mov    %edx,(%eax)
  801847:	8b 45 08             	mov    0x8(%ebp),%eax
  80184a:	8b 00                	mov    (%eax),%eax
  80184c:	83 e8 04             	sub    $0x4,%eax
  80184f:	8b 00                	mov    (%eax),%eax
  801851:	ba 00 00 00 00       	mov    $0x0,%edx
}
  801856:	5d                   	pop    %ebp
  801857:	c3                   	ret    

00801858 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  801858:	55                   	push   %ebp
  801859:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  80185b:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  80185f:	7e 1c                	jle    80187d <getint+0x25>
		return va_arg(*ap, long long);
  801861:	8b 45 08             	mov    0x8(%ebp),%eax
  801864:	8b 00                	mov    (%eax),%eax
  801866:	8d 50 08             	lea    0x8(%eax),%edx
  801869:	8b 45 08             	mov    0x8(%ebp),%eax
  80186c:	89 10                	mov    %edx,(%eax)
  80186e:	8b 45 08             	mov    0x8(%ebp),%eax
  801871:	8b 00                	mov    (%eax),%eax
  801873:	83 e8 08             	sub    $0x8,%eax
  801876:	8b 50 04             	mov    0x4(%eax),%edx
  801879:	8b 00                	mov    (%eax),%eax
  80187b:	eb 38                	jmp    8018b5 <getint+0x5d>
	else if (lflag)
  80187d:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801881:	74 1a                	je     80189d <getint+0x45>
		return va_arg(*ap, long);
  801883:	8b 45 08             	mov    0x8(%ebp),%eax
  801886:	8b 00                	mov    (%eax),%eax
  801888:	8d 50 04             	lea    0x4(%eax),%edx
  80188b:	8b 45 08             	mov    0x8(%ebp),%eax
  80188e:	89 10                	mov    %edx,(%eax)
  801890:	8b 45 08             	mov    0x8(%ebp),%eax
  801893:	8b 00                	mov    (%eax),%eax
  801895:	83 e8 04             	sub    $0x4,%eax
  801898:	8b 00                	mov    (%eax),%eax
  80189a:	99                   	cltd   
  80189b:	eb 18                	jmp    8018b5 <getint+0x5d>
	else
		return va_arg(*ap, int);
  80189d:	8b 45 08             	mov    0x8(%ebp),%eax
  8018a0:	8b 00                	mov    (%eax),%eax
  8018a2:	8d 50 04             	lea    0x4(%eax),%edx
  8018a5:	8b 45 08             	mov    0x8(%ebp),%eax
  8018a8:	89 10                	mov    %edx,(%eax)
  8018aa:	8b 45 08             	mov    0x8(%ebp),%eax
  8018ad:	8b 00                	mov    (%eax),%eax
  8018af:	83 e8 04             	sub    $0x4,%eax
  8018b2:	8b 00                	mov    (%eax),%eax
  8018b4:	99                   	cltd   
}
  8018b5:	5d                   	pop    %ebp
  8018b6:	c3                   	ret    

008018b7 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  8018b7:	55                   	push   %ebp
  8018b8:	89 e5                	mov    %esp,%ebp
  8018ba:	56                   	push   %esi
  8018bb:	53                   	push   %ebx
  8018bc:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8018bf:	eb 17                	jmp    8018d8 <vprintfmt+0x21>
			if (ch == '\0')
  8018c1:	85 db                	test   %ebx,%ebx
  8018c3:	0f 84 af 03 00 00    	je     801c78 <vprintfmt+0x3c1>
				return;
			putch(ch, putdat);
  8018c9:	83 ec 08             	sub    $0x8,%esp
  8018cc:	ff 75 0c             	pushl  0xc(%ebp)
  8018cf:	53                   	push   %ebx
  8018d0:	8b 45 08             	mov    0x8(%ebp),%eax
  8018d3:	ff d0                	call   *%eax
  8018d5:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8018d8:	8b 45 10             	mov    0x10(%ebp),%eax
  8018db:	8d 50 01             	lea    0x1(%eax),%edx
  8018de:	89 55 10             	mov    %edx,0x10(%ebp)
  8018e1:	8a 00                	mov    (%eax),%al
  8018e3:	0f b6 d8             	movzbl %al,%ebx
  8018e6:	83 fb 25             	cmp    $0x25,%ebx
  8018e9:	75 d6                	jne    8018c1 <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  8018eb:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  8018ef:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  8018f6:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  8018fd:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  801904:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  80190b:	8b 45 10             	mov    0x10(%ebp),%eax
  80190e:	8d 50 01             	lea    0x1(%eax),%edx
  801911:	89 55 10             	mov    %edx,0x10(%ebp)
  801914:	8a 00                	mov    (%eax),%al
  801916:	0f b6 d8             	movzbl %al,%ebx
  801919:	8d 43 dd             	lea    -0x23(%ebx),%eax
  80191c:	83 f8 55             	cmp    $0x55,%eax
  80191f:	0f 87 2b 03 00 00    	ja     801c50 <vprintfmt+0x399>
  801925:	8b 04 85 58 4b 80 00 	mov    0x804b58(,%eax,4),%eax
  80192c:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  80192e:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  801932:	eb d7                	jmp    80190b <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  801934:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  801938:	eb d1                	jmp    80190b <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  80193a:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  801941:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801944:	89 d0                	mov    %edx,%eax
  801946:	c1 e0 02             	shl    $0x2,%eax
  801949:	01 d0                	add    %edx,%eax
  80194b:	01 c0                	add    %eax,%eax
  80194d:	01 d8                	add    %ebx,%eax
  80194f:	83 e8 30             	sub    $0x30,%eax
  801952:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  801955:	8b 45 10             	mov    0x10(%ebp),%eax
  801958:	8a 00                	mov    (%eax),%al
  80195a:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  80195d:	83 fb 2f             	cmp    $0x2f,%ebx
  801960:	7e 3e                	jle    8019a0 <vprintfmt+0xe9>
  801962:	83 fb 39             	cmp    $0x39,%ebx
  801965:	7f 39                	jg     8019a0 <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  801967:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  80196a:	eb d5                	jmp    801941 <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  80196c:	8b 45 14             	mov    0x14(%ebp),%eax
  80196f:	83 c0 04             	add    $0x4,%eax
  801972:	89 45 14             	mov    %eax,0x14(%ebp)
  801975:	8b 45 14             	mov    0x14(%ebp),%eax
  801978:	83 e8 04             	sub    $0x4,%eax
  80197b:	8b 00                	mov    (%eax),%eax
  80197d:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  801980:	eb 1f                	jmp    8019a1 <vprintfmt+0xea>

		case '.':
			if (width < 0)
  801982:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  801986:	79 83                	jns    80190b <vprintfmt+0x54>
				width = 0;
  801988:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  80198f:	e9 77 ff ff ff       	jmp    80190b <vprintfmt+0x54>

		case '#':
			altflag = 1;
  801994:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  80199b:	e9 6b ff ff ff       	jmp    80190b <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  8019a0:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  8019a1:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8019a5:	0f 89 60 ff ff ff    	jns    80190b <vprintfmt+0x54>
				width = precision, precision = -1;
  8019ab:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8019ae:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8019b1:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  8019b8:	e9 4e ff ff ff       	jmp    80190b <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  8019bd:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  8019c0:	e9 46 ff ff ff       	jmp    80190b <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  8019c5:	8b 45 14             	mov    0x14(%ebp),%eax
  8019c8:	83 c0 04             	add    $0x4,%eax
  8019cb:	89 45 14             	mov    %eax,0x14(%ebp)
  8019ce:	8b 45 14             	mov    0x14(%ebp),%eax
  8019d1:	83 e8 04             	sub    $0x4,%eax
  8019d4:	8b 00                	mov    (%eax),%eax
  8019d6:	83 ec 08             	sub    $0x8,%esp
  8019d9:	ff 75 0c             	pushl  0xc(%ebp)
  8019dc:	50                   	push   %eax
  8019dd:	8b 45 08             	mov    0x8(%ebp),%eax
  8019e0:	ff d0                	call   *%eax
  8019e2:	83 c4 10             	add    $0x10,%esp
			break;
  8019e5:	e9 89 02 00 00       	jmp    801c73 <vprintfmt+0x3bc>

		// error message
		case 'e':
			err = va_arg(ap, int);
  8019ea:	8b 45 14             	mov    0x14(%ebp),%eax
  8019ed:	83 c0 04             	add    $0x4,%eax
  8019f0:	89 45 14             	mov    %eax,0x14(%ebp)
  8019f3:	8b 45 14             	mov    0x14(%ebp),%eax
  8019f6:	83 e8 04             	sub    $0x4,%eax
  8019f9:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  8019fb:	85 db                	test   %ebx,%ebx
  8019fd:	79 02                	jns    801a01 <vprintfmt+0x14a>
				err = -err;
  8019ff:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  801a01:	83 fb 64             	cmp    $0x64,%ebx
  801a04:	7f 0b                	jg     801a11 <vprintfmt+0x15a>
  801a06:	8b 34 9d a0 49 80 00 	mov    0x8049a0(,%ebx,4),%esi
  801a0d:	85 f6                	test   %esi,%esi
  801a0f:	75 19                	jne    801a2a <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  801a11:	53                   	push   %ebx
  801a12:	68 45 4b 80 00       	push   $0x804b45
  801a17:	ff 75 0c             	pushl  0xc(%ebp)
  801a1a:	ff 75 08             	pushl  0x8(%ebp)
  801a1d:	e8 5e 02 00 00       	call   801c80 <printfmt>
  801a22:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  801a25:	e9 49 02 00 00       	jmp    801c73 <vprintfmt+0x3bc>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  801a2a:	56                   	push   %esi
  801a2b:	68 4e 4b 80 00       	push   $0x804b4e
  801a30:	ff 75 0c             	pushl  0xc(%ebp)
  801a33:	ff 75 08             	pushl  0x8(%ebp)
  801a36:	e8 45 02 00 00       	call   801c80 <printfmt>
  801a3b:	83 c4 10             	add    $0x10,%esp
			break;
  801a3e:	e9 30 02 00 00       	jmp    801c73 <vprintfmt+0x3bc>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  801a43:	8b 45 14             	mov    0x14(%ebp),%eax
  801a46:	83 c0 04             	add    $0x4,%eax
  801a49:	89 45 14             	mov    %eax,0x14(%ebp)
  801a4c:	8b 45 14             	mov    0x14(%ebp),%eax
  801a4f:	83 e8 04             	sub    $0x4,%eax
  801a52:	8b 30                	mov    (%eax),%esi
  801a54:	85 f6                	test   %esi,%esi
  801a56:	75 05                	jne    801a5d <vprintfmt+0x1a6>
				p = "(null)";
  801a58:	be 51 4b 80 00       	mov    $0x804b51,%esi
			if (width > 0 && padc != '-')
  801a5d:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  801a61:	7e 6d                	jle    801ad0 <vprintfmt+0x219>
  801a63:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  801a67:	74 67                	je     801ad0 <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  801a69:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801a6c:	83 ec 08             	sub    $0x8,%esp
  801a6f:	50                   	push   %eax
  801a70:	56                   	push   %esi
  801a71:	e8 0c 03 00 00       	call   801d82 <strnlen>
  801a76:	83 c4 10             	add    $0x10,%esp
  801a79:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  801a7c:	eb 16                	jmp    801a94 <vprintfmt+0x1dd>
					putch(padc, putdat);
  801a7e:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  801a82:	83 ec 08             	sub    $0x8,%esp
  801a85:	ff 75 0c             	pushl  0xc(%ebp)
  801a88:	50                   	push   %eax
  801a89:	8b 45 08             	mov    0x8(%ebp),%eax
  801a8c:	ff d0                	call   *%eax
  801a8e:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  801a91:	ff 4d e4             	decl   -0x1c(%ebp)
  801a94:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  801a98:	7f e4                	jg     801a7e <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  801a9a:	eb 34                	jmp    801ad0 <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  801a9c:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  801aa0:	74 1c                	je     801abe <vprintfmt+0x207>
  801aa2:	83 fb 1f             	cmp    $0x1f,%ebx
  801aa5:	7e 05                	jle    801aac <vprintfmt+0x1f5>
  801aa7:	83 fb 7e             	cmp    $0x7e,%ebx
  801aaa:	7e 12                	jle    801abe <vprintfmt+0x207>
					putch('?', putdat);
  801aac:	83 ec 08             	sub    $0x8,%esp
  801aaf:	ff 75 0c             	pushl  0xc(%ebp)
  801ab2:	6a 3f                	push   $0x3f
  801ab4:	8b 45 08             	mov    0x8(%ebp),%eax
  801ab7:	ff d0                	call   *%eax
  801ab9:	83 c4 10             	add    $0x10,%esp
  801abc:	eb 0f                	jmp    801acd <vprintfmt+0x216>
				else
					putch(ch, putdat);
  801abe:	83 ec 08             	sub    $0x8,%esp
  801ac1:	ff 75 0c             	pushl  0xc(%ebp)
  801ac4:	53                   	push   %ebx
  801ac5:	8b 45 08             	mov    0x8(%ebp),%eax
  801ac8:	ff d0                	call   *%eax
  801aca:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  801acd:	ff 4d e4             	decl   -0x1c(%ebp)
  801ad0:	89 f0                	mov    %esi,%eax
  801ad2:	8d 70 01             	lea    0x1(%eax),%esi
  801ad5:	8a 00                	mov    (%eax),%al
  801ad7:	0f be d8             	movsbl %al,%ebx
  801ada:	85 db                	test   %ebx,%ebx
  801adc:	74 24                	je     801b02 <vprintfmt+0x24b>
  801ade:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  801ae2:	78 b8                	js     801a9c <vprintfmt+0x1e5>
  801ae4:	ff 4d e0             	decl   -0x20(%ebp)
  801ae7:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  801aeb:	79 af                	jns    801a9c <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  801aed:	eb 13                	jmp    801b02 <vprintfmt+0x24b>
				putch(' ', putdat);
  801aef:	83 ec 08             	sub    $0x8,%esp
  801af2:	ff 75 0c             	pushl  0xc(%ebp)
  801af5:	6a 20                	push   $0x20
  801af7:	8b 45 08             	mov    0x8(%ebp),%eax
  801afa:	ff d0                	call   *%eax
  801afc:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  801aff:	ff 4d e4             	decl   -0x1c(%ebp)
  801b02:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  801b06:	7f e7                	jg     801aef <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  801b08:	e9 66 01 00 00       	jmp    801c73 <vprintfmt+0x3bc>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  801b0d:	83 ec 08             	sub    $0x8,%esp
  801b10:	ff 75 e8             	pushl  -0x18(%ebp)
  801b13:	8d 45 14             	lea    0x14(%ebp),%eax
  801b16:	50                   	push   %eax
  801b17:	e8 3c fd ff ff       	call   801858 <getint>
  801b1c:	83 c4 10             	add    $0x10,%esp
  801b1f:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801b22:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  801b25:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801b28:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801b2b:	85 d2                	test   %edx,%edx
  801b2d:	79 23                	jns    801b52 <vprintfmt+0x29b>
				putch('-', putdat);
  801b2f:	83 ec 08             	sub    $0x8,%esp
  801b32:	ff 75 0c             	pushl  0xc(%ebp)
  801b35:	6a 2d                	push   $0x2d
  801b37:	8b 45 08             	mov    0x8(%ebp),%eax
  801b3a:	ff d0                	call   *%eax
  801b3c:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  801b3f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801b42:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801b45:	f7 d8                	neg    %eax
  801b47:	83 d2 00             	adc    $0x0,%edx
  801b4a:	f7 da                	neg    %edx
  801b4c:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801b4f:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  801b52:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  801b59:	e9 bc 00 00 00       	jmp    801c1a <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  801b5e:	83 ec 08             	sub    $0x8,%esp
  801b61:	ff 75 e8             	pushl  -0x18(%ebp)
  801b64:	8d 45 14             	lea    0x14(%ebp),%eax
  801b67:	50                   	push   %eax
  801b68:	e8 84 fc ff ff       	call   8017f1 <getuint>
  801b6d:	83 c4 10             	add    $0x10,%esp
  801b70:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801b73:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  801b76:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  801b7d:	e9 98 00 00 00       	jmp    801c1a <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  801b82:	83 ec 08             	sub    $0x8,%esp
  801b85:	ff 75 0c             	pushl  0xc(%ebp)
  801b88:	6a 58                	push   $0x58
  801b8a:	8b 45 08             	mov    0x8(%ebp),%eax
  801b8d:	ff d0                	call   *%eax
  801b8f:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  801b92:	83 ec 08             	sub    $0x8,%esp
  801b95:	ff 75 0c             	pushl  0xc(%ebp)
  801b98:	6a 58                	push   $0x58
  801b9a:	8b 45 08             	mov    0x8(%ebp),%eax
  801b9d:	ff d0                	call   *%eax
  801b9f:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  801ba2:	83 ec 08             	sub    $0x8,%esp
  801ba5:	ff 75 0c             	pushl  0xc(%ebp)
  801ba8:	6a 58                	push   $0x58
  801baa:	8b 45 08             	mov    0x8(%ebp),%eax
  801bad:	ff d0                	call   *%eax
  801baf:	83 c4 10             	add    $0x10,%esp
			break;
  801bb2:	e9 bc 00 00 00       	jmp    801c73 <vprintfmt+0x3bc>

		// pointer
		case 'p':
			putch('0', putdat);
  801bb7:	83 ec 08             	sub    $0x8,%esp
  801bba:	ff 75 0c             	pushl  0xc(%ebp)
  801bbd:	6a 30                	push   $0x30
  801bbf:	8b 45 08             	mov    0x8(%ebp),%eax
  801bc2:	ff d0                	call   *%eax
  801bc4:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  801bc7:	83 ec 08             	sub    $0x8,%esp
  801bca:	ff 75 0c             	pushl  0xc(%ebp)
  801bcd:	6a 78                	push   $0x78
  801bcf:	8b 45 08             	mov    0x8(%ebp),%eax
  801bd2:	ff d0                	call   *%eax
  801bd4:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  801bd7:	8b 45 14             	mov    0x14(%ebp),%eax
  801bda:	83 c0 04             	add    $0x4,%eax
  801bdd:	89 45 14             	mov    %eax,0x14(%ebp)
  801be0:	8b 45 14             	mov    0x14(%ebp),%eax
  801be3:	83 e8 04             	sub    $0x4,%eax
  801be6:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  801be8:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801beb:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  801bf2:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  801bf9:	eb 1f                	jmp    801c1a <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  801bfb:	83 ec 08             	sub    $0x8,%esp
  801bfe:	ff 75 e8             	pushl  -0x18(%ebp)
  801c01:	8d 45 14             	lea    0x14(%ebp),%eax
  801c04:	50                   	push   %eax
  801c05:	e8 e7 fb ff ff       	call   8017f1 <getuint>
  801c0a:	83 c4 10             	add    $0x10,%esp
  801c0d:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801c10:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  801c13:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  801c1a:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  801c1e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801c21:	83 ec 04             	sub    $0x4,%esp
  801c24:	52                   	push   %edx
  801c25:	ff 75 e4             	pushl  -0x1c(%ebp)
  801c28:	50                   	push   %eax
  801c29:	ff 75 f4             	pushl  -0xc(%ebp)
  801c2c:	ff 75 f0             	pushl  -0x10(%ebp)
  801c2f:	ff 75 0c             	pushl  0xc(%ebp)
  801c32:	ff 75 08             	pushl  0x8(%ebp)
  801c35:	e8 00 fb ff ff       	call   80173a <printnum>
  801c3a:	83 c4 20             	add    $0x20,%esp
			break;
  801c3d:	eb 34                	jmp    801c73 <vprintfmt+0x3bc>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  801c3f:	83 ec 08             	sub    $0x8,%esp
  801c42:	ff 75 0c             	pushl  0xc(%ebp)
  801c45:	53                   	push   %ebx
  801c46:	8b 45 08             	mov    0x8(%ebp),%eax
  801c49:	ff d0                	call   *%eax
  801c4b:	83 c4 10             	add    $0x10,%esp
			break;
  801c4e:	eb 23                	jmp    801c73 <vprintfmt+0x3bc>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  801c50:	83 ec 08             	sub    $0x8,%esp
  801c53:	ff 75 0c             	pushl  0xc(%ebp)
  801c56:	6a 25                	push   $0x25
  801c58:	8b 45 08             	mov    0x8(%ebp),%eax
  801c5b:	ff d0                	call   *%eax
  801c5d:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  801c60:	ff 4d 10             	decl   0x10(%ebp)
  801c63:	eb 03                	jmp    801c68 <vprintfmt+0x3b1>
  801c65:	ff 4d 10             	decl   0x10(%ebp)
  801c68:	8b 45 10             	mov    0x10(%ebp),%eax
  801c6b:	48                   	dec    %eax
  801c6c:	8a 00                	mov    (%eax),%al
  801c6e:	3c 25                	cmp    $0x25,%al
  801c70:	75 f3                	jne    801c65 <vprintfmt+0x3ae>
				/* do nothing */;
			break;
  801c72:	90                   	nop
		}
	}
  801c73:	e9 47 fc ff ff       	jmp    8018bf <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  801c78:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  801c79:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801c7c:	5b                   	pop    %ebx
  801c7d:	5e                   	pop    %esi
  801c7e:	5d                   	pop    %ebp
  801c7f:	c3                   	ret    

00801c80 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  801c80:	55                   	push   %ebp
  801c81:	89 e5                	mov    %esp,%ebp
  801c83:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  801c86:	8d 45 10             	lea    0x10(%ebp),%eax
  801c89:	83 c0 04             	add    $0x4,%eax
  801c8c:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  801c8f:	8b 45 10             	mov    0x10(%ebp),%eax
  801c92:	ff 75 f4             	pushl  -0xc(%ebp)
  801c95:	50                   	push   %eax
  801c96:	ff 75 0c             	pushl  0xc(%ebp)
  801c99:	ff 75 08             	pushl  0x8(%ebp)
  801c9c:	e8 16 fc ff ff       	call   8018b7 <vprintfmt>
  801ca1:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  801ca4:	90                   	nop
  801ca5:	c9                   	leave  
  801ca6:	c3                   	ret    

00801ca7 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  801ca7:	55                   	push   %ebp
  801ca8:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  801caa:	8b 45 0c             	mov    0xc(%ebp),%eax
  801cad:	8b 40 08             	mov    0x8(%eax),%eax
  801cb0:	8d 50 01             	lea    0x1(%eax),%edx
  801cb3:	8b 45 0c             	mov    0xc(%ebp),%eax
  801cb6:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  801cb9:	8b 45 0c             	mov    0xc(%ebp),%eax
  801cbc:	8b 10                	mov    (%eax),%edx
  801cbe:	8b 45 0c             	mov    0xc(%ebp),%eax
  801cc1:	8b 40 04             	mov    0x4(%eax),%eax
  801cc4:	39 c2                	cmp    %eax,%edx
  801cc6:	73 12                	jae    801cda <sprintputch+0x33>
		*b->buf++ = ch;
  801cc8:	8b 45 0c             	mov    0xc(%ebp),%eax
  801ccb:	8b 00                	mov    (%eax),%eax
  801ccd:	8d 48 01             	lea    0x1(%eax),%ecx
  801cd0:	8b 55 0c             	mov    0xc(%ebp),%edx
  801cd3:	89 0a                	mov    %ecx,(%edx)
  801cd5:	8b 55 08             	mov    0x8(%ebp),%edx
  801cd8:	88 10                	mov    %dl,(%eax)
}
  801cda:	90                   	nop
  801cdb:	5d                   	pop    %ebp
  801cdc:	c3                   	ret    

00801cdd <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  801cdd:	55                   	push   %ebp
  801cde:	89 e5                	mov    %esp,%ebp
  801ce0:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  801ce3:	8b 45 08             	mov    0x8(%ebp),%eax
  801ce6:	89 45 ec             	mov    %eax,-0x14(%ebp)
  801ce9:	8b 45 0c             	mov    0xc(%ebp),%eax
  801cec:	8d 50 ff             	lea    -0x1(%eax),%edx
  801cef:	8b 45 08             	mov    0x8(%ebp),%eax
  801cf2:	01 d0                	add    %edx,%eax
  801cf4:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801cf7:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  801cfe:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801d02:	74 06                	je     801d0a <vsnprintf+0x2d>
  801d04:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801d08:	7f 07                	jg     801d11 <vsnprintf+0x34>
		return -E_INVAL;
  801d0a:	b8 03 00 00 00       	mov    $0x3,%eax
  801d0f:	eb 20                	jmp    801d31 <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  801d11:	ff 75 14             	pushl  0x14(%ebp)
  801d14:	ff 75 10             	pushl  0x10(%ebp)
  801d17:	8d 45 ec             	lea    -0x14(%ebp),%eax
  801d1a:	50                   	push   %eax
  801d1b:	68 a7 1c 80 00       	push   $0x801ca7
  801d20:	e8 92 fb ff ff       	call   8018b7 <vprintfmt>
  801d25:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  801d28:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801d2b:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  801d2e:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  801d31:	c9                   	leave  
  801d32:	c3                   	ret    

00801d33 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  801d33:	55                   	push   %ebp
  801d34:	89 e5                	mov    %esp,%ebp
  801d36:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  801d39:	8d 45 10             	lea    0x10(%ebp),%eax
  801d3c:	83 c0 04             	add    $0x4,%eax
  801d3f:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  801d42:	8b 45 10             	mov    0x10(%ebp),%eax
  801d45:	ff 75 f4             	pushl  -0xc(%ebp)
  801d48:	50                   	push   %eax
  801d49:	ff 75 0c             	pushl  0xc(%ebp)
  801d4c:	ff 75 08             	pushl  0x8(%ebp)
  801d4f:	e8 89 ff ff ff       	call   801cdd <vsnprintf>
  801d54:	83 c4 10             	add    $0x10,%esp
  801d57:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  801d5a:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801d5d:	c9                   	leave  
  801d5e:	c3                   	ret    

00801d5f <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  801d5f:	55                   	push   %ebp
  801d60:	89 e5                	mov    %esp,%ebp
  801d62:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  801d65:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801d6c:	eb 06                	jmp    801d74 <strlen+0x15>
		n++;
  801d6e:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  801d71:	ff 45 08             	incl   0x8(%ebp)
  801d74:	8b 45 08             	mov    0x8(%ebp),%eax
  801d77:	8a 00                	mov    (%eax),%al
  801d79:	84 c0                	test   %al,%al
  801d7b:	75 f1                	jne    801d6e <strlen+0xf>
		n++;
	return n;
  801d7d:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  801d80:	c9                   	leave  
  801d81:	c3                   	ret    

00801d82 <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  801d82:	55                   	push   %ebp
  801d83:	89 e5                	mov    %esp,%ebp
  801d85:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  801d88:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801d8f:	eb 09                	jmp    801d9a <strnlen+0x18>
		n++;
  801d91:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  801d94:	ff 45 08             	incl   0x8(%ebp)
  801d97:	ff 4d 0c             	decl   0xc(%ebp)
  801d9a:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801d9e:	74 09                	je     801da9 <strnlen+0x27>
  801da0:	8b 45 08             	mov    0x8(%ebp),%eax
  801da3:	8a 00                	mov    (%eax),%al
  801da5:	84 c0                	test   %al,%al
  801da7:	75 e8                	jne    801d91 <strnlen+0xf>
		n++;
	return n;
  801da9:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  801dac:	c9                   	leave  
  801dad:	c3                   	ret    

00801dae <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  801dae:	55                   	push   %ebp
  801daf:	89 e5                	mov    %esp,%ebp
  801db1:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  801db4:	8b 45 08             	mov    0x8(%ebp),%eax
  801db7:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  801dba:	90                   	nop
  801dbb:	8b 45 08             	mov    0x8(%ebp),%eax
  801dbe:	8d 50 01             	lea    0x1(%eax),%edx
  801dc1:	89 55 08             	mov    %edx,0x8(%ebp)
  801dc4:	8b 55 0c             	mov    0xc(%ebp),%edx
  801dc7:	8d 4a 01             	lea    0x1(%edx),%ecx
  801dca:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  801dcd:	8a 12                	mov    (%edx),%dl
  801dcf:	88 10                	mov    %dl,(%eax)
  801dd1:	8a 00                	mov    (%eax),%al
  801dd3:	84 c0                	test   %al,%al
  801dd5:	75 e4                	jne    801dbb <strcpy+0xd>
		/* do nothing */;
	return ret;
  801dd7:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  801dda:	c9                   	leave  
  801ddb:	c3                   	ret    

00801ddc <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  801ddc:	55                   	push   %ebp
  801ddd:	89 e5                	mov    %esp,%ebp
  801ddf:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  801de2:	8b 45 08             	mov    0x8(%ebp),%eax
  801de5:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  801de8:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801def:	eb 1f                	jmp    801e10 <strncpy+0x34>
		*dst++ = *src;
  801df1:	8b 45 08             	mov    0x8(%ebp),%eax
  801df4:	8d 50 01             	lea    0x1(%eax),%edx
  801df7:	89 55 08             	mov    %edx,0x8(%ebp)
  801dfa:	8b 55 0c             	mov    0xc(%ebp),%edx
  801dfd:	8a 12                	mov    (%edx),%dl
  801dff:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  801e01:	8b 45 0c             	mov    0xc(%ebp),%eax
  801e04:	8a 00                	mov    (%eax),%al
  801e06:	84 c0                	test   %al,%al
  801e08:	74 03                	je     801e0d <strncpy+0x31>
			src++;
  801e0a:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  801e0d:	ff 45 fc             	incl   -0x4(%ebp)
  801e10:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801e13:	3b 45 10             	cmp    0x10(%ebp),%eax
  801e16:	72 d9                	jb     801df1 <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  801e18:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  801e1b:	c9                   	leave  
  801e1c:	c3                   	ret    

00801e1d <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  801e1d:	55                   	push   %ebp
  801e1e:	89 e5                	mov    %esp,%ebp
  801e20:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  801e23:	8b 45 08             	mov    0x8(%ebp),%eax
  801e26:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  801e29:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801e2d:	74 30                	je     801e5f <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  801e2f:	eb 16                	jmp    801e47 <strlcpy+0x2a>
			*dst++ = *src++;
  801e31:	8b 45 08             	mov    0x8(%ebp),%eax
  801e34:	8d 50 01             	lea    0x1(%eax),%edx
  801e37:	89 55 08             	mov    %edx,0x8(%ebp)
  801e3a:	8b 55 0c             	mov    0xc(%ebp),%edx
  801e3d:	8d 4a 01             	lea    0x1(%edx),%ecx
  801e40:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  801e43:	8a 12                	mov    (%edx),%dl
  801e45:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  801e47:	ff 4d 10             	decl   0x10(%ebp)
  801e4a:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801e4e:	74 09                	je     801e59 <strlcpy+0x3c>
  801e50:	8b 45 0c             	mov    0xc(%ebp),%eax
  801e53:	8a 00                	mov    (%eax),%al
  801e55:	84 c0                	test   %al,%al
  801e57:	75 d8                	jne    801e31 <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  801e59:	8b 45 08             	mov    0x8(%ebp),%eax
  801e5c:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  801e5f:	8b 55 08             	mov    0x8(%ebp),%edx
  801e62:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801e65:	29 c2                	sub    %eax,%edx
  801e67:	89 d0                	mov    %edx,%eax
}
  801e69:	c9                   	leave  
  801e6a:	c3                   	ret    

00801e6b <strcmp>:

int
strcmp(const char *p, const char *q)
{
  801e6b:	55                   	push   %ebp
  801e6c:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  801e6e:	eb 06                	jmp    801e76 <strcmp+0xb>
		p++, q++;
  801e70:	ff 45 08             	incl   0x8(%ebp)
  801e73:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  801e76:	8b 45 08             	mov    0x8(%ebp),%eax
  801e79:	8a 00                	mov    (%eax),%al
  801e7b:	84 c0                	test   %al,%al
  801e7d:	74 0e                	je     801e8d <strcmp+0x22>
  801e7f:	8b 45 08             	mov    0x8(%ebp),%eax
  801e82:	8a 10                	mov    (%eax),%dl
  801e84:	8b 45 0c             	mov    0xc(%ebp),%eax
  801e87:	8a 00                	mov    (%eax),%al
  801e89:	38 c2                	cmp    %al,%dl
  801e8b:	74 e3                	je     801e70 <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  801e8d:	8b 45 08             	mov    0x8(%ebp),%eax
  801e90:	8a 00                	mov    (%eax),%al
  801e92:	0f b6 d0             	movzbl %al,%edx
  801e95:	8b 45 0c             	mov    0xc(%ebp),%eax
  801e98:	8a 00                	mov    (%eax),%al
  801e9a:	0f b6 c0             	movzbl %al,%eax
  801e9d:	29 c2                	sub    %eax,%edx
  801e9f:	89 d0                	mov    %edx,%eax
}
  801ea1:	5d                   	pop    %ebp
  801ea2:	c3                   	ret    

00801ea3 <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  801ea3:	55                   	push   %ebp
  801ea4:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  801ea6:	eb 09                	jmp    801eb1 <strncmp+0xe>
		n--, p++, q++;
  801ea8:	ff 4d 10             	decl   0x10(%ebp)
  801eab:	ff 45 08             	incl   0x8(%ebp)
  801eae:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  801eb1:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801eb5:	74 17                	je     801ece <strncmp+0x2b>
  801eb7:	8b 45 08             	mov    0x8(%ebp),%eax
  801eba:	8a 00                	mov    (%eax),%al
  801ebc:	84 c0                	test   %al,%al
  801ebe:	74 0e                	je     801ece <strncmp+0x2b>
  801ec0:	8b 45 08             	mov    0x8(%ebp),%eax
  801ec3:	8a 10                	mov    (%eax),%dl
  801ec5:	8b 45 0c             	mov    0xc(%ebp),%eax
  801ec8:	8a 00                	mov    (%eax),%al
  801eca:	38 c2                	cmp    %al,%dl
  801ecc:	74 da                	je     801ea8 <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  801ece:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801ed2:	75 07                	jne    801edb <strncmp+0x38>
		return 0;
  801ed4:	b8 00 00 00 00       	mov    $0x0,%eax
  801ed9:	eb 14                	jmp    801eef <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  801edb:	8b 45 08             	mov    0x8(%ebp),%eax
  801ede:	8a 00                	mov    (%eax),%al
  801ee0:	0f b6 d0             	movzbl %al,%edx
  801ee3:	8b 45 0c             	mov    0xc(%ebp),%eax
  801ee6:	8a 00                	mov    (%eax),%al
  801ee8:	0f b6 c0             	movzbl %al,%eax
  801eeb:	29 c2                	sub    %eax,%edx
  801eed:	89 d0                	mov    %edx,%eax
}
  801eef:	5d                   	pop    %ebp
  801ef0:	c3                   	ret    

00801ef1 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  801ef1:	55                   	push   %ebp
  801ef2:	89 e5                	mov    %esp,%ebp
  801ef4:	83 ec 04             	sub    $0x4,%esp
  801ef7:	8b 45 0c             	mov    0xc(%ebp),%eax
  801efa:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  801efd:	eb 12                	jmp    801f11 <strchr+0x20>
		if (*s == c)
  801eff:	8b 45 08             	mov    0x8(%ebp),%eax
  801f02:	8a 00                	mov    (%eax),%al
  801f04:	3a 45 fc             	cmp    -0x4(%ebp),%al
  801f07:	75 05                	jne    801f0e <strchr+0x1d>
			return (char *) s;
  801f09:	8b 45 08             	mov    0x8(%ebp),%eax
  801f0c:	eb 11                	jmp    801f1f <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  801f0e:	ff 45 08             	incl   0x8(%ebp)
  801f11:	8b 45 08             	mov    0x8(%ebp),%eax
  801f14:	8a 00                	mov    (%eax),%al
  801f16:	84 c0                	test   %al,%al
  801f18:	75 e5                	jne    801eff <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  801f1a:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801f1f:	c9                   	leave  
  801f20:	c3                   	ret    

00801f21 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  801f21:	55                   	push   %ebp
  801f22:	89 e5                	mov    %esp,%ebp
  801f24:	83 ec 04             	sub    $0x4,%esp
  801f27:	8b 45 0c             	mov    0xc(%ebp),%eax
  801f2a:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  801f2d:	eb 0d                	jmp    801f3c <strfind+0x1b>
		if (*s == c)
  801f2f:	8b 45 08             	mov    0x8(%ebp),%eax
  801f32:	8a 00                	mov    (%eax),%al
  801f34:	3a 45 fc             	cmp    -0x4(%ebp),%al
  801f37:	74 0e                	je     801f47 <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  801f39:	ff 45 08             	incl   0x8(%ebp)
  801f3c:	8b 45 08             	mov    0x8(%ebp),%eax
  801f3f:	8a 00                	mov    (%eax),%al
  801f41:	84 c0                	test   %al,%al
  801f43:	75 ea                	jne    801f2f <strfind+0xe>
  801f45:	eb 01                	jmp    801f48 <strfind+0x27>
		if (*s == c)
			break;
  801f47:	90                   	nop
	return (char *) s;
  801f48:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801f4b:	c9                   	leave  
  801f4c:	c3                   	ret    

00801f4d <memset>:


void *
memset(void *v, int c, uint32 n)
{
  801f4d:	55                   	push   %ebp
  801f4e:	89 e5                	mov    %esp,%ebp
  801f50:	83 ec 10             	sub    $0x10,%esp
	char *p;
	int m;

	p = v;
  801f53:	8b 45 08             	mov    0x8(%ebp),%eax
  801f56:	89 45 fc             	mov    %eax,-0x4(%ebp)
	m = n;
  801f59:	8b 45 10             	mov    0x10(%ebp),%eax
  801f5c:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (--m >= 0)
  801f5f:	eb 0e                	jmp    801f6f <memset+0x22>
		*p++ = c;
  801f61:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801f64:	8d 50 01             	lea    0x1(%eax),%edx
  801f67:	89 55 fc             	mov    %edx,-0x4(%ebp)
  801f6a:	8b 55 0c             	mov    0xc(%ebp),%edx
  801f6d:	88 10                	mov    %dl,(%eax)
	char *p;
	int m;

	p = v;
	m = n;
	while (--m >= 0)
  801f6f:	ff 4d f8             	decl   -0x8(%ebp)
  801f72:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  801f76:	79 e9                	jns    801f61 <memset+0x14>
		*p++ = c;

	return v;
  801f78:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801f7b:	c9                   	leave  
  801f7c:	c3                   	ret    

00801f7d <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  801f7d:	55                   	push   %ebp
  801f7e:	89 e5                	mov    %esp,%ebp
  801f80:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  801f83:	8b 45 0c             	mov    0xc(%ebp),%eax
  801f86:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  801f89:	8b 45 08             	mov    0x8(%ebp),%eax
  801f8c:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (n-- > 0)
  801f8f:	eb 16                	jmp    801fa7 <memcpy+0x2a>
		*d++ = *s++;
  801f91:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801f94:	8d 50 01             	lea    0x1(%eax),%edx
  801f97:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801f9a:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801f9d:	8d 4a 01             	lea    0x1(%edx),%ecx
  801fa0:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  801fa3:	8a 12                	mov    (%edx),%dl
  801fa5:	88 10                	mov    %dl,(%eax)
	const char *s;
	char *d;

	s = src;
	d = dst;
	while (n-- > 0)
  801fa7:	8b 45 10             	mov    0x10(%ebp),%eax
  801faa:	8d 50 ff             	lea    -0x1(%eax),%edx
  801fad:	89 55 10             	mov    %edx,0x10(%ebp)
  801fb0:	85 c0                	test   %eax,%eax
  801fb2:	75 dd                	jne    801f91 <memcpy+0x14>
		*d++ = *s++;

	return dst;
  801fb4:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801fb7:	c9                   	leave  
  801fb8:	c3                   	ret    

00801fb9 <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  801fb9:	55                   	push   %ebp
  801fba:	89 e5                	mov    %esp,%ebp
  801fbc:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  801fbf:	8b 45 0c             	mov    0xc(%ebp),%eax
  801fc2:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  801fc5:	8b 45 08             	mov    0x8(%ebp),%eax
  801fc8:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  801fcb:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801fce:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  801fd1:	73 50                	jae    802023 <memmove+0x6a>
  801fd3:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801fd6:	8b 45 10             	mov    0x10(%ebp),%eax
  801fd9:	01 d0                	add    %edx,%eax
  801fdb:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  801fde:	76 43                	jbe    802023 <memmove+0x6a>
		s += n;
  801fe0:	8b 45 10             	mov    0x10(%ebp),%eax
  801fe3:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  801fe6:	8b 45 10             	mov    0x10(%ebp),%eax
  801fe9:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  801fec:	eb 10                	jmp    801ffe <memmove+0x45>
			*--d = *--s;
  801fee:	ff 4d f8             	decl   -0x8(%ebp)
  801ff1:	ff 4d fc             	decl   -0x4(%ebp)
  801ff4:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801ff7:	8a 10                	mov    (%eax),%dl
  801ff9:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801ffc:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  801ffe:	8b 45 10             	mov    0x10(%ebp),%eax
  802001:	8d 50 ff             	lea    -0x1(%eax),%edx
  802004:	89 55 10             	mov    %edx,0x10(%ebp)
  802007:	85 c0                	test   %eax,%eax
  802009:	75 e3                	jne    801fee <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  80200b:	eb 23                	jmp    802030 <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  80200d:	8b 45 f8             	mov    -0x8(%ebp),%eax
  802010:	8d 50 01             	lea    0x1(%eax),%edx
  802013:	89 55 f8             	mov    %edx,-0x8(%ebp)
  802016:	8b 55 fc             	mov    -0x4(%ebp),%edx
  802019:	8d 4a 01             	lea    0x1(%edx),%ecx
  80201c:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  80201f:	8a 12                	mov    (%edx),%dl
  802021:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  802023:	8b 45 10             	mov    0x10(%ebp),%eax
  802026:	8d 50 ff             	lea    -0x1(%eax),%edx
  802029:	89 55 10             	mov    %edx,0x10(%ebp)
  80202c:	85 c0                	test   %eax,%eax
  80202e:	75 dd                	jne    80200d <memmove+0x54>
			*d++ = *s++;

	return dst;
  802030:	8b 45 08             	mov    0x8(%ebp),%eax
}
  802033:	c9                   	leave  
  802034:	c3                   	ret    

00802035 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  802035:	55                   	push   %ebp
  802036:	89 e5                	mov    %esp,%ebp
  802038:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  80203b:	8b 45 08             	mov    0x8(%ebp),%eax
  80203e:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  802041:	8b 45 0c             	mov    0xc(%ebp),%eax
  802044:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  802047:	eb 2a                	jmp    802073 <memcmp+0x3e>
		if (*s1 != *s2)
  802049:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80204c:	8a 10                	mov    (%eax),%dl
  80204e:	8b 45 f8             	mov    -0x8(%ebp),%eax
  802051:	8a 00                	mov    (%eax),%al
  802053:	38 c2                	cmp    %al,%dl
  802055:	74 16                	je     80206d <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  802057:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80205a:	8a 00                	mov    (%eax),%al
  80205c:	0f b6 d0             	movzbl %al,%edx
  80205f:	8b 45 f8             	mov    -0x8(%ebp),%eax
  802062:	8a 00                	mov    (%eax),%al
  802064:	0f b6 c0             	movzbl %al,%eax
  802067:	29 c2                	sub    %eax,%edx
  802069:	89 d0                	mov    %edx,%eax
  80206b:	eb 18                	jmp    802085 <memcmp+0x50>
		s1++, s2++;
  80206d:	ff 45 fc             	incl   -0x4(%ebp)
  802070:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  802073:	8b 45 10             	mov    0x10(%ebp),%eax
  802076:	8d 50 ff             	lea    -0x1(%eax),%edx
  802079:	89 55 10             	mov    %edx,0x10(%ebp)
  80207c:	85 c0                	test   %eax,%eax
  80207e:	75 c9                	jne    802049 <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  802080:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802085:	c9                   	leave  
  802086:	c3                   	ret    

00802087 <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  802087:	55                   	push   %ebp
  802088:	89 e5                	mov    %esp,%ebp
  80208a:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  80208d:	8b 55 08             	mov    0x8(%ebp),%edx
  802090:	8b 45 10             	mov    0x10(%ebp),%eax
  802093:	01 d0                	add    %edx,%eax
  802095:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  802098:	eb 15                	jmp    8020af <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  80209a:	8b 45 08             	mov    0x8(%ebp),%eax
  80209d:	8a 00                	mov    (%eax),%al
  80209f:	0f b6 d0             	movzbl %al,%edx
  8020a2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8020a5:	0f b6 c0             	movzbl %al,%eax
  8020a8:	39 c2                	cmp    %eax,%edx
  8020aa:	74 0d                	je     8020b9 <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  8020ac:	ff 45 08             	incl   0x8(%ebp)
  8020af:	8b 45 08             	mov    0x8(%ebp),%eax
  8020b2:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  8020b5:	72 e3                	jb     80209a <memfind+0x13>
  8020b7:	eb 01                	jmp    8020ba <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  8020b9:	90                   	nop
	return (void *) s;
  8020ba:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8020bd:	c9                   	leave  
  8020be:	c3                   	ret    

008020bf <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  8020bf:	55                   	push   %ebp
  8020c0:	89 e5                	mov    %esp,%ebp
  8020c2:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  8020c5:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  8020cc:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  8020d3:	eb 03                	jmp    8020d8 <strtol+0x19>
		s++;
  8020d5:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  8020d8:	8b 45 08             	mov    0x8(%ebp),%eax
  8020db:	8a 00                	mov    (%eax),%al
  8020dd:	3c 20                	cmp    $0x20,%al
  8020df:	74 f4                	je     8020d5 <strtol+0x16>
  8020e1:	8b 45 08             	mov    0x8(%ebp),%eax
  8020e4:	8a 00                	mov    (%eax),%al
  8020e6:	3c 09                	cmp    $0x9,%al
  8020e8:	74 eb                	je     8020d5 <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  8020ea:	8b 45 08             	mov    0x8(%ebp),%eax
  8020ed:	8a 00                	mov    (%eax),%al
  8020ef:	3c 2b                	cmp    $0x2b,%al
  8020f1:	75 05                	jne    8020f8 <strtol+0x39>
		s++;
  8020f3:	ff 45 08             	incl   0x8(%ebp)
  8020f6:	eb 13                	jmp    80210b <strtol+0x4c>
	else if (*s == '-')
  8020f8:	8b 45 08             	mov    0x8(%ebp),%eax
  8020fb:	8a 00                	mov    (%eax),%al
  8020fd:	3c 2d                	cmp    $0x2d,%al
  8020ff:	75 0a                	jne    80210b <strtol+0x4c>
		s++, neg = 1;
  802101:	ff 45 08             	incl   0x8(%ebp)
  802104:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  80210b:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80210f:	74 06                	je     802117 <strtol+0x58>
  802111:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  802115:	75 20                	jne    802137 <strtol+0x78>
  802117:	8b 45 08             	mov    0x8(%ebp),%eax
  80211a:	8a 00                	mov    (%eax),%al
  80211c:	3c 30                	cmp    $0x30,%al
  80211e:	75 17                	jne    802137 <strtol+0x78>
  802120:	8b 45 08             	mov    0x8(%ebp),%eax
  802123:	40                   	inc    %eax
  802124:	8a 00                	mov    (%eax),%al
  802126:	3c 78                	cmp    $0x78,%al
  802128:	75 0d                	jne    802137 <strtol+0x78>
		s += 2, base = 16;
  80212a:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  80212e:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  802135:	eb 28                	jmp    80215f <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  802137:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80213b:	75 15                	jne    802152 <strtol+0x93>
  80213d:	8b 45 08             	mov    0x8(%ebp),%eax
  802140:	8a 00                	mov    (%eax),%al
  802142:	3c 30                	cmp    $0x30,%al
  802144:	75 0c                	jne    802152 <strtol+0x93>
		s++, base = 8;
  802146:	ff 45 08             	incl   0x8(%ebp)
  802149:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  802150:	eb 0d                	jmp    80215f <strtol+0xa0>
	else if (base == 0)
  802152:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  802156:	75 07                	jne    80215f <strtol+0xa0>
		base = 10;
  802158:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  80215f:	8b 45 08             	mov    0x8(%ebp),%eax
  802162:	8a 00                	mov    (%eax),%al
  802164:	3c 2f                	cmp    $0x2f,%al
  802166:	7e 19                	jle    802181 <strtol+0xc2>
  802168:	8b 45 08             	mov    0x8(%ebp),%eax
  80216b:	8a 00                	mov    (%eax),%al
  80216d:	3c 39                	cmp    $0x39,%al
  80216f:	7f 10                	jg     802181 <strtol+0xc2>
			dig = *s - '0';
  802171:	8b 45 08             	mov    0x8(%ebp),%eax
  802174:	8a 00                	mov    (%eax),%al
  802176:	0f be c0             	movsbl %al,%eax
  802179:	83 e8 30             	sub    $0x30,%eax
  80217c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80217f:	eb 42                	jmp    8021c3 <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  802181:	8b 45 08             	mov    0x8(%ebp),%eax
  802184:	8a 00                	mov    (%eax),%al
  802186:	3c 60                	cmp    $0x60,%al
  802188:	7e 19                	jle    8021a3 <strtol+0xe4>
  80218a:	8b 45 08             	mov    0x8(%ebp),%eax
  80218d:	8a 00                	mov    (%eax),%al
  80218f:	3c 7a                	cmp    $0x7a,%al
  802191:	7f 10                	jg     8021a3 <strtol+0xe4>
			dig = *s - 'a' + 10;
  802193:	8b 45 08             	mov    0x8(%ebp),%eax
  802196:	8a 00                	mov    (%eax),%al
  802198:	0f be c0             	movsbl %al,%eax
  80219b:	83 e8 57             	sub    $0x57,%eax
  80219e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8021a1:	eb 20                	jmp    8021c3 <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  8021a3:	8b 45 08             	mov    0x8(%ebp),%eax
  8021a6:	8a 00                	mov    (%eax),%al
  8021a8:	3c 40                	cmp    $0x40,%al
  8021aa:	7e 39                	jle    8021e5 <strtol+0x126>
  8021ac:	8b 45 08             	mov    0x8(%ebp),%eax
  8021af:	8a 00                	mov    (%eax),%al
  8021b1:	3c 5a                	cmp    $0x5a,%al
  8021b3:	7f 30                	jg     8021e5 <strtol+0x126>
			dig = *s - 'A' + 10;
  8021b5:	8b 45 08             	mov    0x8(%ebp),%eax
  8021b8:	8a 00                	mov    (%eax),%al
  8021ba:	0f be c0             	movsbl %al,%eax
  8021bd:	83 e8 37             	sub    $0x37,%eax
  8021c0:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  8021c3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021c6:	3b 45 10             	cmp    0x10(%ebp),%eax
  8021c9:	7d 19                	jge    8021e4 <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  8021cb:	ff 45 08             	incl   0x8(%ebp)
  8021ce:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8021d1:	0f af 45 10          	imul   0x10(%ebp),%eax
  8021d5:	89 c2                	mov    %eax,%edx
  8021d7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021da:	01 d0                	add    %edx,%eax
  8021dc:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  8021df:	e9 7b ff ff ff       	jmp    80215f <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  8021e4:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  8021e5:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8021e9:	74 08                	je     8021f3 <strtol+0x134>
		*endptr = (char *) s;
  8021eb:	8b 45 0c             	mov    0xc(%ebp),%eax
  8021ee:	8b 55 08             	mov    0x8(%ebp),%edx
  8021f1:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  8021f3:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8021f7:	74 07                	je     802200 <strtol+0x141>
  8021f9:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8021fc:	f7 d8                	neg    %eax
  8021fe:	eb 03                	jmp    802203 <strtol+0x144>
  802200:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  802203:	c9                   	leave  
  802204:	c3                   	ret    

00802205 <ltostr>:

void
ltostr(long value, char *str)
{
  802205:	55                   	push   %ebp
  802206:	89 e5                	mov    %esp,%ebp
  802208:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  80220b:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  802212:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  802219:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80221d:	79 13                	jns    802232 <ltostr+0x2d>
	{
		neg = 1;
  80221f:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  802226:	8b 45 0c             	mov    0xc(%ebp),%eax
  802229:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  80222c:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  80222f:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  802232:	8b 45 08             	mov    0x8(%ebp),%eax
  802235:	b9 0a 00 00 00       	mov    $0xa,%ecx
  80223a:	99                   	cltd   
  80223b:	f7 f9                	idiv   %ecx
  80223d:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  802240:	8b 45 f8             	mov    -0x8(%ebp),%eax
  802243:	8d 50 01             	lea    0x1(%eax),%edx
  802246:	89 55 f8             	mov    %edx,-0x8(%ebp)
  802249:	89 c2                	mov    %eax,%edx
  80224b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80224e:	01 d0                	add    %edx,%eax
  802250:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802253:	83 c2 30             	add    $0x30,%edx
  802256:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  802258:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80225b:	b8 67 66 66 66       	mov    $0x66666667,%eax
  802260:	f7 e9                	imul   %ecx
  802262:	c1 fa 02             	sar    $0x2,%edx
  802265:	89 c8                	mov    %ecx,%eax
  802267:	c1 f8 1f             	sar    $0x1f,%eax
  80226a:	29 c2                	sub    %eax,%edx
  80226c:	89 d0                	mov    %edx,%eax
  80226e:	89 45 08             	mov    %eax,0x8(%ebp)
	} while (value % 10 != 0);
  802271:	8b 4d 08             	mov    0x8(%ebp),%ecx
  802274:	b8 67 66 66 66       	mov    $0x66666667,%eax
  802279:	f7 e9                	imul   %ecx
  80227b:	c1 fa 02             	sar    $0x2,%edx
  80227e:	89 c8                	mov    %ecx,%eax
  802280:	c1 f8 1f             	sar    $0x1f,%eax
  802283:	29 c2                	sub    %eax,%edx
  802285:	89 d0                	mov    %edx,%eax
  802287:	c1 e0 02             	shl    $0x2,%eax
  80228a:	01 d0                	add    %edx,%eax
  80228c:	01 c0                	add    %eax,%eax
  80228e:	29 c1                	sub    %eax,%ecx
  802290:	89 ca                	mov    %ecx,%edx
  802292:	85 d2                	test   %edx,%edx
  802294:	75 9c                	jne    802232 <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  802296:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  80229d:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8022a0:	48                   	dec    %eax
  8022a1:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  8022a4:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8022a8:	74 3d                	je     8022e7 <ltostr+0xe2>
		start = 1 ;
  8022aa:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  8022b1:	eb 34                	jmp    8022e7 <ltostr+0xe2>
	{
		char tmp = str[start] ;
  8022b3:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8022b6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8022b9:	01 d0                	add    %edx,%eax
  8022bb:	8a 00                	mov    (%eax),%al
  8022bd:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  8022c0:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8022c3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8022c6:	01 c2                	add    %eax,%edx
  8022c8:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  8022cb:	8b 45 0c             	mov    0xc(%ebp),%eax
  8022ce:	01 c8                	add    %ecx,%eax
  8022d0:	8a 00                	mov    (%eax),%al
  8022d2:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  8022d4:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8022d7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8022da:	01 c2                	add    %eax,%edx
  8022dc:	8a 45 eb             	mov    -0x15(%ebp),%al
  8022df:	88 02                	mov    %al,(%edx)
		start++ ;
  8022e1:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  8022e4:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  8022e7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022ea:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8022ed:	7c c4                	jl     8022b3 <ltostr+0xae>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  8022ef:	8b 55 f8             	mov    -0x8(%ebp),%edx
  8022f2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8022f5:	01 d0                	add    %edx,%eax
  8022f7:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  8022fa:	90                   	nop
  8022fb:	c9                   	leave  
  8022fc:	c3                   	ret    

008022fd <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  8022fd:	55                   	push   %ebp
  8022fe:	89 e5                	mov    %esp,%ebp
  802300:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  802303:	ff 75 08             	pushl  0x8(%ebp)
  802306:	e8 54 fa ff ff       	call   801d5f <strlen>
  80230b:	83 c4 04             	add    $0x4,%esp
  80230e:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  802311:	ff 75 0c             	pushl  0xc(%ebp)
  802314:	e8 46 fa ff ff       	call   801d5f <strlen>
  802319:	83 c4 04             	add    $0x4,%esp
  80231c:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  80231f:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  802326:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  80232d:	eb 17                	jmp    802346 <strcconcat+0x49>
		final[s] = str1[s] ;
  80232f:	8b 55 fc             	mov    -0x4(%ebp),%edx
  802332:	8b 45 10             	mov    0x10(%ebp),%eax
  802335:	01 c2                	add    %eax,%edx
  802337:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  80233a:	8b 45 08             	mov    0x8(%ebp),%eax
  80233d:	01 c8                	add    %ecx,%eax
  80233f:	8a 00                	mov    (%eax),%al
  802341:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  802343:	ff 45 fc             	incl   -0x4(%ebp)
  802346:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802349:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  80234c:	7c e1                	jl     80232f <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  80234e:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  802355:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  80235c:	eb 1f                	jmp    80237d <strcconcat+0x80>
		final[s++] = str2[i] ;
  80235e:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802361:	8d 50 01             	lea    0x1(%eax),%edx
  802364:	89 55 fc             	mov    %edx,-0x4(%ebp)
  802367:	89 c2                	mov    %eax,%edx
  802369:	8b 45 10             	mov    0x10(%ebp),%eax
  80236c:	01 c2                	add    %eax,%edx
  80236e:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  802371:	8b 45 0c             	mov    0xc(%ebp),%eax
  802374:	01 c8                	add    %ecx,%eax
  802376:	8a 00                	mov    (%eax),%al
  802378:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  80237a:	ff 45 f8             	incl   -0x8(%ebp)
  80237d:	8b 45 f8             	mov    -0x8(%ebp),%eax
  802380:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  802383:	7c d9                	jl     80235e <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  802385:	8b 55 fc             	mov    -0x4(%ebp),%edx
  802388:	8b 45 10             	mov    0x10(%ebp),%eax
  80238b:	01 d0                	add    %edx,%eax
  80238d:	c6 00 00             	movb   $0x0,(%eax)
}
  802390:	90                   	nop
  802391:	c9                   	leave  
  802392:	c3                   	ret    

00802393 <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  802393:	55                   	push   %ebp
  802394:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  802396:	8b 45 14             	mov    0x14(%ebp),%eax
  802399:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  80239f:	8b 45 14             	mov    0x14(%ebp),%eax
  8023a2:	8b 00                	mov    (%eax),%eax
  8023a4:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8023ab:	8b 45 10             	mov    0x10(%ebp),%eax
  8023ae:	01 d0                	add    %edx,%eax
  8023b0:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  8023b6:	eb 0c                	jmp    8023c4 <strsplit+0x31>
			*string++ = 0;
  8023b8:	8b 45 08             	mov    0x8(%ebp),%eax
  8023bb:	8d 50 01             	lea    0x1(%eax),%edx
  8023be:	89 55 08             	mov    %edx,0x8(%ebp)
  8023c1:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  8023c4:	8b 45 08             	mov    0x8(%ebp),%eax
  8023c7:	8a 00                	mov    (%eax),%al
  8023c9:	84 c0                	test   %al,%al
  8023cb:	74 18                	je     8023e5 <strsplit+0x52>
  8023cd:	8b 45 08             	mov    0x8(%ebp),%eax
  8023d0:	8a 00                	mov    (%eax),%al
  8023d2:	0f be c0             	movsbl %al,%eax
  8023d5:	50                   	push   %eax
  8023d6:	ff 75 0c             	pushl  0xc(%ebp)
  8023d9:	e8 13 fb ff ff       	call   801ef1 <strchr>
  8023de:	83 c4 08             	add    $0x8,%esp
  8023e1:	85 c0                	test   %eax,%eax
  8023e3:	75 d3                	jne    8023b8 <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  8023e5:	8b 45 08             	mov    0x8(%ebp),%eax
  8023e8:	8a 00                	mov    (%eax),%al
  8023ea:	84 c0                	test   %al,%al
  8023ec:	74 5a                	je     802448 <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  8023ee:	8b 45 14             	mov    0x14(%ebp),%eax
  8023f1:	8b 00                	mov    (%eax),%eax
  8023f3:	83 f8 0f             	cmp    $0xf,%eax
  8023f6:	75 07                	jne    8023ff <strsplit+0x6c>
		{
			return 0;
  8023f8:	b8 00 00 00 00       	mov    $0x0,%eax
  8023fd:	eb 66                	jmp    802465 <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  8023ff:	8b 45 14             	mov    0x14(%ebp),%eax
  802402:	8b 00                	mov    (%eax),%eax
  802404:	8d 48 01             	lea    0x1(%eax),%ecx
  802407:	8b 55 14             	mov    0x14(%ebp),%edx
  80240a:	89 0a                	mov    %ecx,(%edx)
  80240c:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  802413:	8b 45 10             	mov    0x10(%ebp),%eax
  802416:	01 c2                	add    %eax,%edx
  802418:	8b 45 08             	mov    0x8(%ebp),%eax
  80241b:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  80241d:	eb 03                	jmp    802422 <strsplit+0x8f>
			string++;
  80241f:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  802422:	8b 45 08             	mov    0x8(%ebp),%eax
  802425:	8a 00                	mov    (%eax),%al
  802427:	84 c0                	test   %al,%al
  802429:	74 8b                	je     8023b6 <strsplit+0x23>
  80242b:	8b 45 08             	mov    0x8(%ebp),%eax
  80242e:	8a 00                	mov    (%eax),%al
  802430:	0f be c0             	movsbl %al,%eax
  802433:	50                   	push   %eax
  802434:	ff 75 0c             	pushl  0xc(%ebp)
  802437:	e8 b5 fa ff ff       	call   801ef1 <strchr>
  80243c:	83 c4 08             	add    $0x8,%esp
  80243f:	85 c0                	test   %eax,%eax
  802441:	74 dc                	je     80241f <strsplit+0x8c>
			string++;
	}
  802443:	e9 6e ff ff ff       	jmp    8023b6 <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  802448:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  802449:	8b 45 14             	mov    0x14(%ebp),%eax
  80244c:	8b 00                	mov    (%eax),%eax
  80244e:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  802455:	8b 45 10             	mov    0x10(%ebp),%eax
  802458:	01 d0                	add    %edx,%eax
  80245a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  802460:	b8 01 00 00 00       	mov    $0x1,%eax
}
  802465:	c9                   	leave  
  802466:	c3                   	ret    

00802467 <InitializeUHeap>:
//============================== GIVEN FUNCTIONS ===================================//
//==================================================================================//

int FirstTimeFlag = 1;
void InitializeUHeap()
{
  802467:	55                   	push   %ebp
  802468:	89 e5                	mov    %esp,%ebp
  80246a:	83 ec 08             	sub    $0x8,%esp
	if(FirstTimeFlag)
  80246d:	a1 04 50 80 00       	mov    0x805004,%eax
  802472:	85 c0                	test   %eax,%eax
  802474:	74 1f                	je     802495 <InitializeUHeap+0x2e>
	{
		initialize_dyn_block_system();
  802476:	e8 1d 00 00 00       	call   802498 <initialize_dyn_block_system>
		cprintf("DYNAMIC BLOCK SYSTEM IS INITIALIZED\n");
  80247b:	83 ec 0c             	sub    $0xc,%esp
  80247e:	68 b0 4c 80 00       	push   $0x804cb0
  802483:	e8 55 f2 ff ff       	call   8016dd <cprintf>
  802488:	83 c4 10             	add    $0x10,%esp
#if UHP_USE_BUDDY
		initialize_buddy();
		cprintf("BUDDY SYSTEM IS INITIALIZED\n");
#endif
		FirstTimeFlag = 0;
  80248b:	c7 05 04 50 80 00 00 	movl   $0x0,0x805004
  802492:	00 00 00 
	}
}
  802495:	90                   	nop
  802496:	c9                   	leave  
  802497:	c3                   	ret    

00802498 <initialize_dyn_block_system>:

//=================================
// [1] INITIALIZE DYNAMIC ALLOCATOR:
//=================================
void initialize_dyn_block_system()
{
  802498:	55                   	push   %ebp
  802499:	89 e5                	mov    %esp,%ebp
  80249b:	83 ec 28             	sub    $0x28,%esp
	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] initialize_dyn_block_system
	// your code is here, remove the panic and write your code
	//panic("initialize_dyn_block_system() is not implemented yet...!!");

	LIST_INIT(&AllocMemBlocksList);
  80249e:	c7 05 40 50 80 00 00 	movl   $0x0,0x805040
  8024a5:	00 00 00 
  8024a8:	c7 05 44 50 80 00 00 	movl   $0x0,0x805044
  8024af:	00 00 00 
  8024b2:	c7 05 4c 50 80 00 00 	movl   $0x0,0x80504c
  8024b9:	00 00 00 
	LIST_INIT(&FreeMemBlocksList);
  8024bc:	c7 05 38 51 80 00 00 	movl   $0x0,0x805138
  8024c3:	00 00 00 
  8024c6:	c7 05 3c 51 80 00 00 	movl   $0x0,0x80513c
  8024cd:	00 00 00 
  8024d0:	c7 05 44 51 80 00 00 	movl   $0x0,0x805144
  8024d7:	00 00 00 
	MAX_MEM_BLOCK_CNT = NUM_OF_UHEAP_PAGES;
  8024da:	c7 05 20 51 80 00 00 	movl   $0x20000,0x805120
  8024e1:	00 02 00 
	MemBlockNodes = (void*)USER_DYN_BLKS_ARRAY;
  8024e4:	c7 45 f4 00 00 e0 7f 	movl   $0x7fe00000,-0xc(%ebp)
  8024eb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024ee:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8024f3:	2d 00 10 00 00       	sub    $0x1000,%eax
  8024f8:	a3 50 50 80 00       	mov    %eax,0x805050
	int size_of_block = sizeof(struct MemBlock);
  8024fd:	c7 45 f0 10 00 00 00 	movl   $0x10,-0x10(%ebp)
	int size_all_struct = size_of_block*MAX_MEM_BLOCK_CNT;
  802504:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802507:	a1 20 51 80 00       	mov    0x805120,%eax
  80250c:	0f af c2             	imul   %edx,%eax
  80250f:	89 45 ec             	mov    %eax,-0x14(%ebp)
	size_all_struct = ROUNDUP(size_all_struct, PAGE_SIZE);
  802512:	c7 45 e8 00 10 00 00 	movl   $0x1000,-0x18(%ebp)
  802519:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80251c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80251f:	01 d0                	add    %edx,%eax
  802521:	48                   	dec    %eax
  802522:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  802525:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802528:	ba 00 00 00 00       	mov    $0x0,%edx
  80252d:	f7 75 e8             	divl   -0x18(%ebp)
  802530:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802533:	29 d0                	sub    %edx,%eax
  802535:	89 45 ec             	mov    %eax,-0x14(%ebp)
	sys_allocate_chunk(USER_DYN_BLKS_ARRAY, size_all_struct,PERM_USER| PERM_WRITEABLE);
  802538:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80253b:	c7 45 e0 00 00 e0 7f 	movl   $0x7fe00000,-0x20(%ebp)
  802542:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802545:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
  80254b:	81 ea 00 10 00 00    	sub    $0x1000,%edx
  802551:	83 ec 04             	sub    $0x4,%esp
  802554:	6a 06                	push   $0x6
  802556:	50                   	push   %eax
  802557:	52                   	push   %edx
  802558:	e8 a1 05 00 00       	call   802afe <sys_allocate_chunk>
  80255d:	83 c4 10             	add    $0x10,%esp
	initialize_MemBlocksList(MAX_MEM_BLOCK_CNT);
  802560:	a1 20 51 80 00       	mov    0x805120,%eax
  802565:	83 ec 0c             	sub    $0xc,%esp
  802568:	50                   	push   %eax
  802569:	e8 16 0c 00 00       	call   803184 <initialize_MemBlocksList>
  80256e:	83 c4 10             	add    $0x10,%esp
	struct MemBlock* ourBlock =LIST_LAST(&AvailableMemBlocksList);
  802571:	a1 4c 51 80 00       	mov    0x80514c,%eax
  802576:	89 45 dc             	mov    %eax,-0x24(%ebp)
	LIST_REMOVE(&AvailableMemBlocksList,ourBlock);
  802579:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  80257d:	75 14                	jne    802593 <initialize_dyn_block_system+0xfb>
  80257f:	83 ec 04             	sub    $0x4,%esp
  802582:	68 d5 4c 80 00       	push   $0x804cd5
  802587:	6a 2d                	push   $0x2d
  802589:	68 f3 4c 80 00       	push   $0x804cf3
  80258e:	e8 96 ee ff ff       	call   801429 <_panic>
  802593:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802596:	8b 00                	mov    (%eax),%eax
  802598:	85 c0                	test   %eax,%eax
  80259a:	74 10                	je     8025ac <initialize_dyn_block_system+0x114>
  80259c:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80259f:	8b 00                	mov    (%eax),%eax
  8025a1:	8b 55 dc             	mov    -0x24(%ebp),%edx
  8025a4:	8b 52 04             	mov    0x4(%edx),%edx
  8025a7:	89 50 04             	mov    %edx,0x4(%eax)
  8025aa:	eb 0b                	jmp    8025b7 <initialize_dyn_block_system+0x11f>
  8025ac:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8025af:	8b 40 04             	mov    0x4(%eax),%eax
  8025b2:	a3 4c 51 80 00       	mov    %eax,0x80514c
  8025b7:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8025ba:	8b 40 04             	mov    0x4(%eax),%eax
  8025bd:	85 c0                	test   %eax,%eax
  8025bf:	74 0f                	je     8025d0 <initialize_dyn_block_system+0x138>
  8025c1:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8025c4:	8b 40 04             	mov    0x4(%eax),%eax
  8025c7:	8b 55 dc             	mov    -0x24(%ebp),%edx
  8025ca:	8b 12                	mov    (%edx),%edx
  8025cc:	89 10                	mov    %edx,(%eax)
  8025ce:	eb 0a                	jmp    8025da <initialize_dyn_block_system+0x142>
  8025d0:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8025d3:	8b 00                	mov    (%eax),%eax
  8025d5:	a3 48 51 80 00       	mov    %eax,0x805148
  8025da:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8025dd:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8025e3:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8025e6:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8025ed:	a1 54 51 80 00       	mov    0x805154,%eax
  8025f2:	48                   	dec    %eax
  8025f3:	a3 54 51 80 00       	mov    %eax,0x805154
	ourBlock->size = USER_HEAP_MAX-USER_HEAP_START;
  8025f8:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8025fb:	c7 40 0c 00 00 00 20 	movl   $0x20000000,0xc(%eax)
	ourBlock->sva=USER_HEAP_START;
  802602:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802605:	c7 40 08 00 00 00 80 	movl   $0x80000000,0x8(%eax)
	LIST_INSERT_TAIL(&FreeMemBlocksList, ourBlock);
  80260c:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  802610:	75 14                	jne    802626 <initialize_dyn_block_system+0x18e>
  802612:	83 ec 04             	sub    $0x4,%esp
  802615:	68 00 4d 80 00       	push   $0x804d00
  80261a:	6a 30                	push   $0x30
  80261c:	68 f3 4c 80 00       	push   $0x804cf3
  802621:	e8 03 ee ff ff       	call   801429 <_panic>
  802626:	8b 15 3c 51 80 00    	mov    0x80513c,%edx
  80262c:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80262f:	89 50 04             	mov    %edx,0x4(%eax)
  802632:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802635:	8b 40 04             	mov    0x4(%eax),%eax
  802638:	85 c0                	test   %eax,%eax
  80263a:	74 0c                	je     802648 <initialize_dyn_block_system+0x1b0>
  80263c:	a1 3c 51 80 00       	mov    0x80513c,%eax
  802641:	8b 55 dc             	mov    -0x24(%ebp),%edx
  802644:	89 10                	mov    %edx,(%eax)
  802646:	eb 08                	jmp    802650 <initialize_dyn_block_system+0x1b8>
  802648:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80264b:	a3 38 51 80 00       	mov    %eax,0x805138
  802650:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802653:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802658:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80265b:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802661:	a1 44 51 80 00       	mov    0x805144,%eax
  802666:	40                   	inc    %eax
  802667:	a3 44 51 80 00       	mov    %eax,0x805144
	//[1] Initialize two lists (AllocMemBlocksList & FreeMemBlocksList) [Hint: use LIST_INIT()]
	//[2] Dynamically allocate the array of MemBlockNodes at VA USER_DYN_BLKS_ARRAY
	//	  (remember to set MAX_MEM_BLOCK_CNT with the chosen size of the array)
	//[3] Initialize AvailableMemBlocksList by filling it with the MemBlockNodes
	//[4] Insert a new MemBlock with the heap size into the FreeMemBlocksList
}
  80266c:	90                   	nop
  80266d:	c9                   	leave  
  80266e:	c3                   	ret    

0080266f <malloc>:
//=================================
// [2] ALLOCATE SPACE IN USER HEAP:
//=================================

void* malloc(uint32 size)
{
  80266f:	55                   	push   %ebp
  802670:	89 e5                	mov    %esp,%ebp
  802672:	83 ec 18             	sub    $0x18,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  802675:	e8 ed fd ff ff       	call   802467 <InitializeUHeap>
	if (size == 0) return NULL ;
  80267a:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80267e:	75 07                	jne    802687 <malloc+0x18>
  802680:	b8 00 00 00 00       	mov    $0x0,%eax
  802685:	eb 67                	jmp    8026ee <malloc+0x7f>

	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] malloc
	// your code is here, remove the panic and write your code
	//panic("malloc() is not implemented yet...!!");

	size = ROUNDUP(size, PAGE_SIZE);
  802687:	c7 45 f4 00 10 00 00 	movl   $0x1000,-0xc(%ebp)
  80268e:	8b 55 08             	mov    0x8(%ebp),%edx
  802691:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802694:	01 d0                	add    %edx,%eax
  802696:	48                   	dec    %eax
  802697:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80269a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80269d:	ba 00 00 00 00       	mov    $0x0,%edx
  8026a2:	f7 75 f4             	divl   -0xc(%ebp)
  8026a5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8026a8:	29 d0                	sub    %edx,%eax
  8026aa:	89 45 08             	mov    %eax,0x8(%ebp)
	if(sys_isUHeapPlacementStrategyFIRSTFIT())
  8026ad:	e8 1a 08 00 00       	call   802ecc <sys_isUHeapPlacementStrategyFIRSTFIT>
  8026b2:	85 c0                	test   %eax,%eax
  8026b4:	74 33                	je     8026e9 <malloc+0x7a>
	{
		struct MemBlock * myBlock = alloc_block_FF(size);
  8026b6:	83 ec 0c             	sub    $0xc,%esp
  8026b9:	ff 75 08             	pushl  0x8(%ebp)
  8026bc:	e8 0c 0e 00 00       	call   8034cd <alloc_block_FF>
  8026c1:	83 c4 10             	add    $0x10,%esp
  8026c4:	89 45 ec             	mov    %eax,-0x14(%ebp)
		if(myBlock != NULL)
  8026c7:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8026cb:	74 1c                	je     8026e9 <malloc+0x7a>
		{
			insert_sorted_allocList(myBlock);
  8026cd:	83 ec 0c             	sub    $0xc,%esp
  8026d0:	ff 75 ec             	pushl  -0x14(%ebp)
  8026d3:	e8 07 0c 00 00       	call   8032df <insert_sorted_allocList>
  8026d8:	83 c4 10             	add    $0x10,%esp
			uint32 ptr = myBlock->sva;
  8026db:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8026de:	8b 40 08             	mov    0x8(%eax),%eax
  8026e1:	89 45 e8             	mov    %eax,-0x18(%ebp)
			return (void *)ptr;
  8026e4:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8026e7:	eb 05                	jmp    8026ee <malloc+0x7f>
		}
	}
	return NULL;
  8026e9:	b8 00 00 00 00       	mov    $0x0,%eax
	//		to the required allocation size (space should be on 4 KB BOUNDARY)
	//	2) if no suitable space found, return NULL
	// 	3) Return pointer containing the virtual address of allocated space,
	//
	//Use sys_isUHeapPlacementStrategyFIRSTFIT()... to check the current strategy
}
  8026ee:	c9                   	leave  
  8026ef:	c3                   	ret    

008026f0 <free>:
//	We can use sys_free_user_mem(uint32 virtual_address, uint32 size); which
//		switches to the kernel mode, calls free_user_mem() in
//		"kern/mem/chunk_operations.c", then switch back to the user mode here
//	the free_user_mem function is empty, make sure to implement it.
void free(void* virtual_address)
{
  8026f0:	55                   	push   %ebp
  8026f1:	89 e5                	mov    %esp,%ebp
  8026f3:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] free
	// your code is here, remove the panic and write your code
	//panic("free() is not implemented yet...!!");

	uint32 virtualAddress = (uint32 )(virtual_address);
  8026f6:	8b 45 08             	mov    0x8(%ebp),%eax
  8026f9:	89 45 f4             	mov    %eax,-0xc(%ebp)
//	virtualAddress = ROUNDDOWN(virtualAddress, PAGE_SIZE);
	struct MemBlock * myBlock = find_block(&AllocMemBlocksList, virtualAddress);
  8026fc:	83 ec 08             	sub    $0x8,%esp
  8026ff:	ff 75 f4             	pushl  -0xc(%ebp)
  802702:	68 40 50 80 00       	push   $0x805040
  802707:	e8 5b 0b 00 00       	call   803267 <find_block>
  80270c:	83 c4 10             	add    $0x10,%esp
  80270f:	89 45 f0             	mov    %eax,-0x10(%ebp)
//	cprintf ("ptr sva at free user side = %x \n", myBlock->sva);
	sys_free_user_mem(virtualAddress, myBlock->size);
  802712:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802715:	8b 40 0c             	mov    0xc(%eax),%eax
  802718:	83 ec 08             	sub    $0x8,%esp
  80271b:	50                   	push   %eax
  80271c:	ff 75 f4             	pushl  -0xc(%ebp)
  80271f:	e8 a2 03 00 00       	call   802ac6 <sys_free_user_mem>
  802724:	83 c4 10             	add    $0x10,%esp
	LIST_REMOVE(&AllocMemBlocksList, myBlock);
  802727:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80272b:	75 14                	jne    802741 <free+0x51>
  80272d:	83 ec 04             	sub    $0x4,%esp
  802730:	68 d5 4c 80 00       	push   $0x804cd5
  802735:	6a 76                	push   $0x76
  802737:	68 f3 4c 80 00       	push   $0x804cf3
  80273c:	e8 e8 ec ff ff       	call   801429 <_panic>
  802741:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802744:	8b 00                	mov    (%eax),%eax
  802746:	85 c0                	test   %eax,%eax
  802748:	74 10                	je     80275a <free+0x6a>
  80274a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80274d:	8b 00                	mov    (%eax),%eax
  80274f:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802752:	8b 52 04             	mov    0x4(%edx),%edx
  802755:	89 50 04             	mov    %edx,0x4(%eax)
  802758:	eb 0b                	jmp    802765 <free+0x75>
  80275a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80275d:	8b 40 04             	mov    0x4(%eax),%eax
  802760:	a3 44 50 80 00       	mov    %eax,0x805044
  802765:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802768:	8b 40 04             	mov    0x4(%eax),%eax
  80276b:	85 c0                	test   %eax,%eax
  80276d:	74 0f                	je     80277e <free+0x8e>
  80276f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802772:	8b 40 04             	mov    0x4(%eax),%eax
  802775:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802778:	8b 12                	mov    (%edx),%edx
  80277a:	89 10                	mov    %edx,(%eax)
  80277c:	eb 0a                	jmp    802788 <free+0x98>
  80277e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802781:	8b 00                	mov    (%eax),%eax
  802783:	a3 40 50 80 00       	mov    %eax,0x805040
  802788:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80278b:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802791:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802794:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80279b:	a1 4c 50 80 00       	mov    0x80504c,%eax
  8027a0:	48                   	dec    %eax
  8027a1:	a3 4c 50 80 00       	mov    %eax,0x80504c
	insert_sorted_with_merge_freeList(myBlock);
  8027a6:	83 ec 0c             	sub    $0xc,%esp
  8027a9:	ff 75 f0             	pushl  -0x10(%ebp)
  8027ac:	e8 0b 14 00 00       	call   803bbc <insert_sorted_with_merge_freeList>
  8027b1:	83 c4 10             	add    $0x10,%esp

	//you should get the size of the given allocation using its address
	//you need to call sys_free_user_mem()
	//refer to the project presentation and documentation for details
}
  8027b4:	90                   	nop
  8027b5:	c9                   	leave  
  8027b6:	c3                   	ret    

008027b7 <smalloc>:

//=================================
// [4] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
  8027b7:	55                   	push   %ebp
  8027b8:	89 e5                	mov    %esp,%ebp
  8027ba:	83 ec 28             	sub    $0x28,%esp
  8027bd:	8b 45 10             	mov    0x10(%ebp),%eax
  8027c0:	88 45 e4             	mov    %al,-0x1c(%ebp)
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  8027c3:	e8 9f fc ff ff       	call   802467 <InitializeUHeap>
	if (size == 0) return NULL ;
  8027c8:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8027cc:	75 0a                	jne    8027d8 <smalloc+0x21>
  8027ce:	b8 00 00 00 00       	mov    $0x0,%eax
  8027d3:	e9 8d 00 00 00       	jmp    802865 <smalloc+0xae>

	//This function should find the space of the required range
	// * ON 4KB BOUNDARY **** //
	//Use sys_isUHeapPlacementStrategyFIRSTFIT() to check the current strategy

	size = ROUNDUP(size, PAGE_SIZE);
  8027d8:	c7 45 f4 00 10 00 00 	movl   $0x1000,-0xc(%ebp)
  8027df:	8b 55 0c             	mov    0xc(%ebp),%edx
  8027e2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027e5:	01 d0                	add    %edx,%eax
  8027e7:	48                   	dec    %eax
  8027e8:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8027eb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8027ee:	ba 00 00 00 00       	mov    $0x0,%edx
  8027f3:	f7 75 f4             	divl   -0xc(%ebp)
  8027f6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8027f9:	29 d0                	sub    %edx,%eax
  8027fb:	89 45 0c             	mov    %eax,0xc(%ebp)
		if(sys_isUHeapPlacementStrategyFIRSTFIT())
  8027fe:	e8 c9 06 00 00       	call   802ecc <sys_isUHeapPlacementStrategyFIRSTFIT>
  802803:	85 c0                	test   %eax,%eax
  802805:	74 59                	je     802860 <smalloc+0xa9>
		{
			struct MemBlock * v1=NULL;
  802807:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
			v1= alloc_block_FF(size);
  80280e:	83 ec 0c             	sub    $0xc,%esp
  802811:	ff 75 0c             	pushl  0xc(%ebp)
  802814:	e8 b4 0c 00 00       	call   8034cd <alloc_block_FF>
  802819:	83 c4 10             	add    $0x10,%esp
  80281c:	89 45 ec             	mov    %eax,-0x14(%ebp)
			if(v1==NULL)
  80281f:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802823:	75 07                	jne    80282c <smalloc+0x75>
			{
				return NULL;
  802825:	b8 00 00 00 00       	mov    $0x0,%eax
  80282a:	eb 39                	jmp    802865 <smalloc+0xae>
			}
			else
			{
				int ret=sys_createSharedObject(sharedVarName,  size,  isWritable,(void*)v1->sva);
  80282c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80282f:	8b 40 08             	mov    0x8(%eax),%eax
  802832:	89 c2                	mov    %eax,%edx
  802834:	0f b6 45 e4          	movzbl -0x1c(%ebp),%eax
  802838:	52                   	push   %edx
  802839:	50                   	push   %eax
  80283a:	ff 75 0c             	pushl  0xc(%ebp)
  80283d:	ff 75 08             	pushl  0x8(%ebp)
  802840:	e8 0c 04 00 00       	call   802c51 <sys_createSharedObject>
  802845:	83 c4 10             	add    $0x10,%esp
  802848:	89 45 e8             	mov    %eax,-0x18(%ebp)
				if(ret>=0)
  80284b:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  80284f:	78 08                	js     802859 <smalloc+0xa2>
				{
					return (void*)v1->sva;
  802851:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802854:	8b 40 08             	mov    0x8(%eax),%eax
  802857:	eb 0c                	jmp    802865 <smalloc+0xae>
				}
				else
				{
					return NULL;
  802859:	b8 00 00 00 00       	mov    $0x0,%eax
  80285e:	eb 05                	jmp    802865 <smalloc+0xae>
				}
			}

		}
		return NULL;
  802860:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802865:	c9                   	leave  
  802866:	c3                   	ret    

00802867 <sget>:

//========================================
// [5] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  802867:	55                   	push   %ebp
  802868:	89 e5                	mov    %esp,%ebp
  80286a:	83 ec 18             	sub    $0x18,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  80286d:	e8 f5 fb ff ff       	call   802467 <InitializeUHeap>

	//This function should find the space for sharing the variable
	// *** ON 4KB BOUNDARY ******** //

	//Use sys_isUHeapPlacementStrategyFIRSTFIT() to check the current strategy
	int ret=sys_getSizeOfSharedObject(ownerEnvID,sharedVarName);
  802872:	83 ec 08             	sub    $0x8,%esp
  802875:	ff 75 0c             	pushl  0xc(%ebp)
  802878:	ff 75 08             	pushl  0x8(%ebp)
  80287b:	e8 fb 03 00 00       	call   802c7b <sys_getSizeOfSharedObject>
  802880:	83 c4 10             	add    $0x10,%esp
  802883:	89 45 f4             	mov    %eax,-0xc(%ebp)
	if(ret==0)
  802886:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80288a:	75 07                	jne    802893 <sget+0x2c>
	{
		return NULL;
  80288c:	b8 00 00 00 00       	mov    $0x0,%eax
  802891:	eb 64                	jmp    8028f7 <sget+0x90>
	}
	if(sys_isUHeapPlacementStrategyFIRSTFIT())
  802893:	e8 34 06 00 00       	call   802ecc <sys_isUHeapPlacementStrategyFIRSTFIT>
  802898:	85 c0                	test   %eax,%eax
  80289a:	74 56                	je     8028f2 <sget+0x8b>
	{
		struct MemBlock * v1=NULL;
  80289c:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
		v1= alloc_block_FF(ret);
  8028a3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028a6:	83 ec 0c             	sub    $0xc,%esp
  8028a9:	50                   	push   %eax
  8028aa:	e8 1e 0c 00 00       	call   8034cd <alloc_block_FF>
  8028af:	83 c4 10             	add    $0x10,%esp
  8028b2:	89 45 f0             	mov    %eax,-0x10(%ebp)
		if(v1==NULL)
  8028b5:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8028b9:	75 07                	jne    8028c2 <sget+0x5b>
		{
		return NULL;
  8028bb:	b8 00 00 00 00       	mov    $0x0,%eax
  8028c0:	eb 35                	jmp    8028f7 <sget+0x90>
	    }
		else
		{
			int ret1=sys_getSharedObject(ownerEnvID,sharedVarName,(void*)v1->sva);
  8028c2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8028c5:	8b 40 08             	mov    0x8(%eax),%eax
  8028c8:	83 ec 04             	sub    $0x4,%esp
  8028cb:	50                   	push   %eax
  8028cc:	ff 75 0c             	pushl  0xc(%ebp)
  8028cf:	ff 75 08             	pushl  0x8(%ebp)
  8028d2:	e8 c1 03 00 00       	call   802c98 <sys_getSharedObject>
  8028d7:	83 c4 10             	add    $0x10,%esp
  8028da:	89 45 ec             	mov    %eax,-0x14(%ebp)
			if(ret1>=0)
  8028dd:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8028e1:	78 08                	js     8028eb <sget+0x84>
			{
				return (void*)v1->sva;
  8028e3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8028e6:	8b 40 08             	mov    0x8(%eax),%eax
  8028e9:	eb 0c                	jmp    8028f7 <sget+0x90>
			}
			else
			{
				return NULL;
  8028eb:	b8 00 00 00 00       	mov    $0x0,%eax
  8028f0:	eb 05                	jmp    8028f7 <sget+0x90>
			}
		}
	}
  return NULL;
  8028f2:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8028f7:	c9                   	leave  
  8028f8:	c3                   	ret    

008028f9 <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  8028f9:	55                   	push   %ebp
  8028fa:	89 e5                	mov    %esp,%ebp
  8028fc:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  8028ff:	e8 63 fb ff ff       	call   802467 <InitializeUHeap>
	//==============================================================
	// [USER HEAP - USER SIDE] realloc
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  802904:	83 ec 04             	sub    $0x4,%esp
  802907:	68 24 4d 80 00       	push   $0x804d24
  80290c:	68 0e 01 00 00       	push   $0x10e
  802911:	68 f3 4c 80 00       	push   $0x804cf3
  802916:	e8 0e eb ff ff       	call   801429 <_panic>

0080291b <sfree>:
//	use sys_freeSharedObject(...); which switches to the kernel mode,
//	calls freeSharedObject(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the freeSharedObject() function is empty, make sure to implement it.

void sfree(void* virtual_address)
{
  80291b:	55                   	push   %ebp
  80291c:	89 e5                	mov    %esp,%ebp
  80291e:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS3 - BONUS] [SHARING - USER SIDE] sfree()

	// Write your code here, remove the panic and write your code
	panic("sfree() is not implemented yet...!!");
  802921:	83 ec 04             	sub    $0x4,%esp
  802924:	68 4c 4d 80 00       	push   $0x804d4c
  802929:	68 22 01 00 00       	push   $0x122
  80292e:	68 f3 4c 80 00       	push   $0x804cf3
  802933:	e8 f1 ea ff ff       	call   801429 <_panic>

00802938 <expand>:

//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//
void expand(uint32 newSize)
{
  802938:	55                   	push   %ebp
  802939:	89 e5                	mov    %esp,%ebp
  80293b:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  80293e:	83 ec 04             	sub    $0x4,%esp
  802941:	68 70 4d 80 00       	push   $0x804d70
  802946:	68 2d 01 00 00       	push   $0x12d
  80294b:	68 f3 4c 80 00       	push   $0x804cf3
  802950:	e8 d4 ea ff ff       	call   801429 <_panic>

00802955 <shrink>:

}
void shrink(uint32 newSize)
{
  802955:	55                   	push   %ebp
  802956:	89 e5                	mov    %esp,%ebp
  802958:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  80295b:	83 ec 04             	sub    $0x4,%esp
  80295e:	68 70 4d 80 00       	push   $0x804d70
  802963:	68 32 01 00 00       	push   $0x132
  802968:	68 f3 4c 80 00       	push   $0x804cf3
  80296d:	e8 b7 ea ff ff       	call   801429 <_panic>

00802972 <freeHeap>:

}
void freeHeap(void* virtual_address)
{
  802972:	55                   	push   %ebp
  802973:	89 e5                	mov    %esp,%ebp
  802975:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  802978:	83 ec 04             	sub    $0x4,%esp
  80297b:	68 70 4d 80 00       	push   $0x804d70
  802980:	68 37 01 00 00       	push   $0x137
  802985:	68 f3 4c 80 00       	push   $0x804cf3
  80298a:	e8 9a ea ff ff       	call   801429 <_panic>

0080298f <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  80298f:	55                   	push   %ebp
  802990:	89 e5                	mov    %esp,%ebp
  802992:	57                   	push   %edi
  802993:	56                   	push   %esi
  802994:	53                   	push   %ebx
  802995:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  802998:	8b 45 08             	mov    0x8(%ebp),%eax
  80299b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80299e:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8029a1:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8029a4:	8b 7d 18             	mov    0x18(%ebp),%edi
  8029a7:	8b 75 1c             	mov    0x1c(%ebp),%esi
  8029aa:	cd 30                	int    $0x30
  8029ac:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  8029af:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8029b2:	83 c4 10             	add    $0x10,%esp
  8029b5:	5b                   	pop    %ebx
  8029b6:	5e                   	pop    %esi
  8029b7:	5f                   	pop    %edi
  8029b8:	5d                   	pop    %ebp
  8029b9:	c3                   	ret    

008029ba <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  8029ba:	55                   	push   %ebp
  8029bb:	89 e5                	mov    %esp,%ebp
  8029bd:	83 ec 04             	sub    $0x4,%esp
  8029c0:	8b 45 10             	mov    0x10(%ebp),%eax
  8029c3:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  8029c6:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  8029ca:	8b 45 08             	mov    0x8(%ebp),%eax
  8029cd:	6a 00                	push   $0x0
  8029cf:	6a 00                	push   $0x0
  8029d1:	52                   	push   %edx
  8029d2:	ff 75 0c             	pushl  0xc(%ebp)
  8029d5:	50                   	push   %eax
  8029d6:	6a 00                	push   $0x0
  8029d8:	e8 b2 ff ff ff       	call   80298f <syscall>
  8029dd:	83 c4 18             	add    $0x18,%esp
}
  8029e0:	90                   	nop
  8029e1:	c9                   	leave  
  8029e2:	c3                   	ret    

008029e3 <sys_cgetc>:

int
sys_cgetc(void)
{
  8029e3:	55                   	push   %ebp
  8029e4:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  8029e6:	6a 00                	push   $0x0
  8029e8:	6a 00                	push   $0x0
  8029ea:	6a 00                	push   $0x0
  8029ec:	6a 00                	push   $0x0
  8029ee:	6a 00                	push   $0x0
  8029f0:	6a 01                	push   $0x1
  8029f2:	e8 98 ff ff ff       	call   80298f <syscall>
  8029f7:	83 c4 18             	add    $0x18,%esp
}
  8029fa:	c9                   	leave  
  8029fb:	c3                   	ret    

008029fc <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  8029fc:	55                   	push   %ebp
  8029fd:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  8029ff:	8b 55 0c             	mov    0xc(%ebp),%edx
  802a02:	8b 45 08             	mov    0x8(%ebp),%eax
  802a05:	6a 00                	push   $0x0
  802a07:	6a 00                	push   $0x0
  802a09:	6a 00                	push   $0x0
  802a0b:	52                   	push   %edx
  802a0c:	50                   	push   %eax
  802a0d:	6a 05                	push   $0x5
  802a0f:	e8 7b ff ff ff       	call   80298f <syscall>
  802a14:	83 c4 18             	add    $0x18,%esp
}
  802a17:	c9                   	leave  
  802a18:	c3                   	ret    

00802a19 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  802a19:	55                   	push   %ebp
  802a1a:	89 e5                	mov    %esp,%ebp
  802a1c:	56                   	push   %esi
  802a1d:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  802a1e:	8b 75 18             	mov    0x18(%ebp),%esi
  802a21:	8b 5d 14             	mov    0x14(%ebp),%ebx
  802a24:	8b 4d 10             	mov    0x10(%ebp),%ecx
  802a27:	8b 55 0c             	mov    0xc(%ebp),%edx
  802a2a:	8b 45 08             	mov    0x8(%ebp),%eax
  802a2d:	56                   	push   %esi
  802a2e:	53                   	push   %ebx
  802a2f:	51                   	push   %ecx
  802a30:	52                   	push   %edx
  802a31:	50                   	push   %eax
  802a32:	6a 06                	push   $0x6
  802a34:	e8 56 ff ff ff       	call   80298f <syscall>
  802a39:	83 c4 18             	add    $0x18,%esp
}
  802a3c:	8d 65 f8             	lea    -0x8(%ebp),%esp
  802a3f:	5b                   	pop    %ebx
  802a40:	5e                   	pop    %esi
  802a41:	5d                   	pop    %ebp
  802a42:	c3                   	ret    

00802a43 <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  802a43:	55                   	push   %ebp
  802a44:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  802a46:	8b 55 0c             	mov    0xc(%ebp),%edx
  802a49:	8b 45 08             	mov    0x8(%ebp),%eax
  802a4c:	6a 00                	push   $0x0
  802a4e:	6a 00                	push   $0x0
  802a50:	6a 00                	push   $0x0
  802a52:	52                   	push   %edx
  802a53:	50                   	push   %eax
  802a54:	6a 07                	push   $0x7
  802a56:	e8 34 ff ff ff       	call   80298f <syscall>
  802a5b:	83 c4 18             	add    $0x18,%esp
}
  802a5e:	c9                   	leave  
  802a5f:	c3                   	ret    

00802a60 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  802a60:	55                   	push   %ebp
  802a61:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  802a63:	6a 00                	push   $0x0
  802a65:	6a 00                	push   $0x0
  802a67:	6a 00                	push   $0x0
  802a69:	ff 75 0c             	pushl  0xc(%ebp)
  802a6c:	ff 75 08             	pushl  0x8(%ebp)
  802a6f:	6a 08                	push   $0x8
  802a71:	e8 19 ff ff ff       	call   80298f <syscall>
  802a76:	83 c4 18             	add    $0x18,%esp
}
  802a79:	c9                   	leave  
  802a7a:	c3                   	ret    

00802a7b <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  802a7b:	55                   	push   %ebp
  802a7c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  802a7e:	6a 00                	push   $0x0
  802a80:	6a 00                	push   $0x0
  802a82:	6a 00                	push   $0x0
  802a84:	6a 00                	push   $0x0
  802a86:	6a 00                	push   $0x0
  802a88:	6a 09                	push   $0x9
  802a8a:	e8 00 ff ff ff       	call   80298f <syscall>
  802a8f:	83 c4 18             	add    $0x18,%esp
}
  802a92:	c9                   	leave  
  802a93:	c3                   	ret    

00802a94 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  802a94:	55                   	push   %ebp
  802a95:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  802a97:	6a 00                	push   $0x0
  802a99:	6a 00                	push   $0x0
  802a9b:	6a 00                	push   $0x0
  802a9d:	6a 00                	push   $0x0
  802a9f:	6a 00                	push   $0x0
  802aa1:	6a 0a                	push   $0xa
  802aa3:	e8 e7 fe ff ff       	call   80298f <syscall>
  802aa8:	83 c4 18             	add    $0x18,%esp
}
  802aab:	c9                   	leave  
  802aac:	c3                   	ret    

00802aad <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  802aad:	55                   	push   %ebp
  802aae:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  802ab0:	6a 00                	push   $0x0
  802ab2:	6a 00                	push   $0x0
  802ab4:	6a 00                	push   $0x0
  802ab6:	6a 00                	push   $0x0
  802ab8:	6a 00                	push   $0x0
  802aba:	6a 0b                	push   $0xb
  802abc:	e8 ce fe ff ff       	call   80298f <syscall>
  802ac1:	83 c4 18             	add    $0x18,%esp
}
  802ac4:	c9                   	leave  
  802ac5:	c3                   	ret    

00802ac6 <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  802ac6:	55                   	push   %ebp
  802ac7:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  802ac9:	6a 00                	push   $0x0
  802acb:	6a 00                	push   $0x0
  802acd:	6a 00                	push   $0x0
  802acf:	ff 75 0c             	pushl  0xc(%ebp)
  802ad2:	ff 75 08             	pushl  0x8(%ebp)
  802ad5:	6a 0f                	push   $0xf
  802ad7:	e8 b3 fe ff ff       	call   80298f <syscall>
  802adc:	83 c4 18             	add    $0x18,%esp
	return;
  802adf:	90                   	nop
}
  802ae0:	c9                   	leave  
  802ae1:	c3                   	ret    

00802ae2 <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  802ae2:	55                   	push   %ebp
  802ae3:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  802ae5:	6a 00                	push   $0x0
  802ae7:	6a 00                	push   $0x0
  802ae9:	6a 00                	push   $0x0
  802aeb:	ff 75 0c             	pushl  0xc(%ebp)
  802aee:	ff 75 08             	pushl  0x8(%ebp)
  802af1:	6a 10                	push   $0x10
  802af3:	e8 97 fe ff ff       	call   80298f <syscall>
  802af8:	83 c4 18             	add    $0x18,%esp
	return ;
  802afb:	90                   	nop
}
  802afc:	c9                   	leave  
  802afd:	c3                   	ret    

00802afe <sys_allocate_chunk>:

void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  802afe:	55                   	push   %ebp
  802aff:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  802b01:	6a 00                	push   $0x0
  802b03:	6a 00                	push   $0x0
  802b05:	ff 75 10             	pushl  0x10(%ebp)
  802b08:	ff 75 0c             	pushl  0xc(%ebp)
  802b0b:	ff 75 08             	pushl  0x8(%ebp)
  802b0e:	6a 11                	push   $0x11
  802b10:	e8 7a fe ff ff       	call   80298f <syscall>
  802b15:	83 c4 18             	add    $0x18,%esp
	return ;
  802b18:	90                   	nop
}
  802b19:	c9                   	leave  
  802b1a:	c3                   	ret    

00802b1b <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  802b1b:	55                   	push   %ebp
  802b1c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  802b1e:	6a 00                	push   $0x0
  802b20:	6a 00                	push   $0x0
  802b22:	6a 00                	push   $0x0
  802b24:	6a 00                	push   $0x0
  802b26:	6a 00                	push   $0x0
  802b28:	6a 0c                	push   $0xc
  802b2a:	e8 60 fe ff ff       	call   80298f <syscall>
  802b2f:	83 c4 18             	add    $0x18,%esp
}
  802b32:	c9                   	leave  
  802b33:	c3                   	ret    

00802b34 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  802b34:	55                   	push   %ebp
  802b35:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  802b37:	6a 00                	push   $0x0
  802b39:	6a 00                	push   $0x0
  802b3b:	6a 00                	push   $0x0
  802b3d:	6a 00                	push   $0x0
  802b3f:	ff 75 08             	pushl  0x8(%ebp)
  802b42:	6a 0d                	push   $0xd
  802b44:	e8 46 fe ff ff       	call   80298f <syscall>
  802b49:	83 c4 18             	add    $0x18,%esp
}
  802b4c:	c9                   	leave  
  802b4d:	c3                   	ret    

00802b4e <sys_scarce_memory>:

void sys_scarce_memory()
{
  802b4e:	55                   	push   %ebp
  802b4f:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  802b51:	6a 00                	push   $0x0
  802b53:	6a 00                	push   $0x0
  802b55:	6a 00                	push   $0x0
  802b57:	6a 00                	push   $0x0
  802b59:	6a 00                	push   $0x0
  802b5b:	6a 0e                	push   $0xe
  802b5d:	e8 2d fe ff ff       	call   80298f <syscall>
  802b62:	83 c4 18             	add    $0x18,%esp
}
  802b65:	90                   	nop
  802b66:	c9                   	leave  
  802b67:	c3                   	ret    

00802b68 <sys_disable_interrupt>:

//NEW !! 2012...
void
sys_disable_interrupt()
{
  802b68:	55                   	push   %ebp
  802b69:	89 e5                	mov    %esp,%ebp
	syscall(SYS_disableINTR,0, 0, 0, 0, 0);
  802b6b:	6a 00                	push   $0x0
  802b6d:	6a 00                	push   $0x0
  802b6f:	6a 00                	push   $0x0
  802b71:	6a 00                	push   $0x0
  802b73:	6a 00                	push   $0x0
  802b75:	6a 13                	push   $0x13
  802b77:	e8 13 fe ff ff       	call   80298f <syscall>
  802b7c:	83 c4 18             	add    $0x18,%esp
}
  802b7f:	90                   	nop
  802b80:	c9                   	leave  
  802b81:	c3                   	ret    

00802b82 <sys_enable_interrupt>:


void
sys_enable_interrupt()
{
  802b82:	55                   	push   %ebp
  802b83:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enableINTR,0, 0, 0, 0, 0);
  802b85:	6a 00                	push   $0x0
  802b87:	6a 00                	push   $0x0
  802b89:	6a 00                	push   $0x0
  802b8b:	6a 00                	push   $0x0
  802b8d:	6a 00                	push   $0x0
  802b8f:	6a 14                	push   $0x14
  802b91:	e8 f9 fd ff ff       	call   80298f <syscall>
  802b96:	83 c4 18             	add    $0x18,%esp
}
  802b99:	90                   	nop
  802b9a:	c9                   	leave  
  802b9b:	c3                   	ret    

00802b9c <sys_cputc>:


void
sys_cputc(const char c)
{
  802b9c:	55                   	push   %ebp
  802b9d:	89 e5                	mov    %esp,%ebp
  802b9f:	83 ec 04             	sub    $0x4,%esp
  802ba2:	8b 45 08             	mov    0x8(%ebp),%eax
  802ba5:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  802ba8:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  802bac:	6a 00                	push   $0x0
  802bae:	6a 00                	push   $0x0
  802bb0:	6a 00                	push   $0x0
  802bb2:	6a 00                	push   $0x0
  802bb4:	50                   	push   %eax
  802bb5:	6a 15                	push   $0x15
  802bb7:	e8 d3 fd ff ff       	call   80298f <syscall>
  802bbc:	83 c4 18             	add    $0x18,%esp
}
  802bbf:	90                   	nop
  802bc0:	c9                   	leave  
  802bc1:	c3                   	ret    

00802bc2 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  802bc2:	55                   	push   %ebp
  802bc3:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  802bc5:	6a 00                	push   $0x0
  802bc7:	6a 00                	push   $0x0
  802bc9:	6a 00                	push   $0x0
  802bcb:	6a 00                	push   $0x0
  802bcd:	6a 00                	push   $0x0
  802bcf:	6a 16                	push   $0x16
  802bd1:	e8 b9 fd ff ff       	call   80298f <syscall>
  802bd6:	83 c4 18             	add    $0x18,%esp
}
  802bd9:	90                   	nop
  802bda:	c9                   	leave  
  802bdb:	c3                   	ret    

00802bdc <sys_createSemaphore>:

int
sys_createSemaphore(char* semaphoreName, uint32 initialValue)
{
  802bdc:	55                   	push   %ebp
  802bdd:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_semaphore,(uint32)semaphoreName, (uint32)initialValue, 0, 0, 0);
  802bdf:	8b 45 08             	mov    0x8(%ebp),%eax
  802be2:	6a 00                	push   $0x0
  802be4:	6a 00                	push   $0x0
  802be6:	6a 00                	push   $0x0
  802be8:	ff 75 0c             	pushl  0xc(%ebp)
  802beb:	50                   	push   %eax
  802bec:	6a 17                	push   $0x17
  802bee:	e8 9c fd ff ff       	call   80298f <syscall>
  802bf3:	83 c4 18             	add    $0x18,%esp
}
  802bf6:	c9                   	leave  
  802bf7:	c3                   	ret    

00802bf8 <sys_getSemaphoreValue>:

int
sys_getSemaphoreValue(int32 ownerEnvID, char* semaphoreName)
{
  802bf8:	55                   	push   %ebp
  802bf9:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_semaphore_value,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  802bfb:	8b 55 0c             	mov    0xc(%ebp),%edx
  802bfe:	8b 45 08             	mov    0x8(%ebp),%eax
  802c01:	6a 00                	push   $0x0
  802c03:	6a 00                	push   $0x0
  802c05:	6a 00                	push   $0x0
  802c07:	52                   	push   %edx
  802c08:	50                   	push   %eax
  802c09:	6a 1a                	push   $0x1a
  802c0b:	e8 7f fd ff ff       	call   80298f <syscall>
  802c10:	83 c4 18             	add    $0x18,%esp
}
  802c13:	c9                   	leave  
  802c14:	c3                   	ret    

00802c15 <sys_waitSemaphore>:

void
sys_waitSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  802c15:	55                   	push   %ebp
  802c16:	89 e5                	mov    %esp,%ebp
	syscall(SYS_wait_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  802c18:	8b 55 0c             	mov    0xc(%ebp),%edx
  802c1b:	8b 45 08             	mov    0x8(%ebp),%eax
  802c1e:	6a 00                	push   $0x0
  802c20:	6a 00                	push   $0x0
  802c22:	6a 00                	push   $0x0
  802c24:	52                   	push   %edx
  802c25:	50                   	push   %eax
  802c26:	6a 18                	push   $0x18
  802c28:	e8 62 fd ff ff       	call   80298f <syscall>
  802c2d:	83 c4 18             	add    $0x18,%esp
}
  802c30:	90                   	nop
  802c31:	c9                   	leave  
  802c32:	c3                   	ret    

00802c33 <sys_signalSemaphore>:

void
sys_signalSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  802c33:	55                   	push   %ebp
  802c34:	89 e5                	mov    %esp,%ebp
	syscall(SYS_signal_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  802c36:	8b 55 0c             	mov    0xc(%ebp),%edx
  802c39:	8b 45 08             	mov    0x8(%ebp),%eax
  802c3c:	6a 00                	push   $0x0
  802c3e:	6a 00                	push   $0x0
  802c40:	6a 00                	push   $0x0
  802c42:	52                   	push   %edx
  802c43:	50                   	push   %eax
  802c44:	6a 19                	push   $0x19
  802c46:	e8 44 fd ff ff       	call   80298f <syscall>
  802c4b:	83 c4 18             	add    $0x18,%esp
}
  802c4e:	90                   	nop
  802c4f:	c9                   	leave  
  802c50:	c3                   	ret    

00802c51 <sys_createSharedObject>:

int
sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  802c51:	55                   	push   %ebp
  802c52:	89 e5                	mov    %esp,%ebp
  802c54:	83 ec 04             	sub    $0x4,%esp
  802c57:	8b 45 10             	mov    0x10(%ebp),%eax
  802c5a:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  802c5d:	8b 4d 14             	mov    0x14(%ebp),%ecx
  802c60:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  802c64:	8b 45 08             	mov    0x8(%ebp),%eax
  802c67:	6a 00                	push   $0x0
  802c69:	51                   	push   %ecx
  802c6a:	52                   	push   %edx
  802c6b:	ff 75 0c             	pushl  0xc(%ebp)
  802c6e:	50                   	push   %eax
  802c6f:	6a 1b                	push   $0x1b
  802c71:	e8 19 fd ff ff       	call   80298f <syscall>
  802c76:	83 c4 18             	add    $0x18,%esp
}
  802c79:	c9                   	leave  
  802c7a:	c3                   	ret    

00802c7b <sys_getSizeOfSharedObject>:

//2017:
int
sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  802c7b:	55                   	push   %ebp
  802c7c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  802c7e:	8b 55 0c             	mov    0xc(%ebp),%edx
  802c81:	8b 45 08             	mov    0x8(%ebp),%eax
  802c84:	6a 00                	push   $0x0
  802c86:	6a 00                	push   $0x0
  802c88:	6a 00                	push   $0x0
  802c8a:	52                   	push   %edx
  802c8b:	50                   	push   %eax
  802c8c:	6a 1c                	push   $0x1c
  802c8e:	e8 fc fc ff ff       	call   80298f <syscall>
  802c93:	83 c4 18             	add    $0x18,%esp
}
  802c96:	c9                   	leave  
  802c97:	c3                   	ret    

00802c98 <sys_getSharedObject>:
//==========

int
sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  802c98:	55                   	push   %ebp
  802c99:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  802c9b:	8b 4d 10             	mov    0x10(%ebp),%ecx
  802c9e:	8b 55 0c             	mov    0xc(%ebp),%edx
  802ca1:	8b 45 08             	mov    0x8(%ebp),%eax
  802ca4:	6a 00                	push   $0x0
  802ca6:	6a 00                	push   $0x0
  802ca8:	51                   	push   %ecx
  802ca9:	52                   	push   %edx
  802caa:	50                   	push   %eax
  802cab:	6a 1d                	push   $0x1d
  802cad:	e8 dd fc ff ff       	call   80298f <syscall>
  802cb2:	83 c4 18             	add    $0x18,%esp
}
  802cb5:	c9                   	leave  
  802cb6:	c3                   	ret    

00802cb7 <sys_freeSharedObject>:

int
sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  802cb7:	55                   	push   %ebp
  802cb8:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  802cba:	8b 55 0c             	mov    0xc(%ebp),%edx
  802cbd:	8b 45 08             	mov    0x8(%ebp),%eax
  802cc0:	6a 00                	push   $0x0
  802cc2:	6a 00                	push   $0x0
  802cc4:	6a 00                	push   $0x0
  802cc6:	52                   	push   %edx
  802cc7:	50                   	push   %eax
  802cc8:	6a 1e                	push   $0x1e
  802cca:	e8 c0 fc ff ff       	call   80298f <syscall>
  802ccf:	83 c4 18             	add    $0x18,%esp
}
  802cd2:	c9                   	leave  
  802cd3:	c3                   	ret    

00802cd4 <sys_getMaxShares>:

uint32 	sys_getMaxShares()
{
  802cd4:	55                   	push   %ebp
  802cd5:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_max_shares,0, 0, 0, 0, 0);
  802cd7:	6a 00                	push   $0x0
  802cd9:	6a 00                	push   $0x0
  802cdb:	6a 00                	push   $0x0
  802cdd:	6a 00                	push   $0x0
  802cdf:	6a 00                	push   $0x0
  802ce1:	6a 1f                	push   $0x1f
  802ce3:	e8 a7 fc ff ff       	call   80298f <syscall>
  802ce8:	83 c4 18             	add    $0x18,%esp
}
  802ceb:	c9                   	leave  
  802cec:	c3                   	ret    

00802ced <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  802ced:	55                   	push   %ebp
  802cee:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  802cf0:	8b 45 08             	mov    0x8(%ebp),%eax
  802cf3:	6a 00                	push   $0x0
  802cf5:	ff 75 14             	pushl  0x14(%ebp)
  802cf8:	ff 75 10             	pushl  0x10(%ebp)
  802cfb:	ff 75 0c             	pushl  0xc(%ebp)
  802cfe:	50                   	push   %eax
  802cff:	6a 20                	push   $0x20
  802d01:	e8 89 fc ff ff       	call   80298f <syscall>
  802d06:	83 c4 18             	add    $0x18,%esp
}
  802d09:	c9                   	leave  
  802d0a:	c3                   	ret    

00802d0b <sys_run_env>:

void
sys_run_env(int32 envId)
{
  802d0b:	55                   	push   %ebp
  802d0c:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  802d0e:	8b 45 08             	mov    0x8(%ebp),%eax
  802d11:	6a 00                	push   $0x0
  802d13:	6a 00                	push   $0x0
  802d15:	6a 00                	push   $0x0
  802d17:	6a 00                	push   $0x0
  802d19:	50                   	push   %eax
  802d1a:	6a 21                	push   $0x21
  802d1c:	e8 6e fc ff ff       	call   80298f <syscall>
  802d21:	83 c4 18             	add    $0x18,%esp
}
  802d24:	90                   	nop
  802d25:	c9                   	leave  
  802d26:	c3                   	ret    

00802d27 <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  802d27:	55                   	push   %ebp
  802d28:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  802d2a:	8b 45 08             	mov    0x8(%ebp),%eax
  802d2d:	6a 00                	push   $0x0
  802d2f:	6a 00                	push   $0x0
  802d31:	6a 00                	push   $0x0
  802d33:	6a 00                	push   $0x0
  802d35:	50                   	push   %eax
  802d36:	6a 22                	push   $0x22
  802d38:	e8 52 fc ff ff       	call   80298f <syscall>
  802d3d:	83 c4 18             	add    $0x18,%esp
}
  802d40:	c9                   	leave  
  802d41:	c3                   	ret    

00802d42 <sys_getenvid>:

int32 sys_getenvid(void)
{
  802d42:	55                   	push   %ebp
  802d43:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  802d45:	6a 00                	push   $0x0
  802d47:	6a 00                	push   $0x0
  802d49:	6a 00                	push   $0x0
  802d4b:	6a 00                	push   $0x0
  802d4d:	6a 00                	push   $0x0
  802d4f:	6a 02                	push   $0x2
  802d51:	e8 39 fc ff ff       	call   80298f <syscall>
  802d56:	83 c4 18             	add    $0x18,%esp
}
  802d59:	c9                   	leave  
  802d5a:	c3                   	ret    

00802d5b <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  802d5b:	55                   	push   %ebp
  802d5c:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  802d5e:	6a 00                	push   $0x0
  802d60:	6a 00                	push   $0x0
  802d62:	6a 00                	push   $0x0
  802d64:	6a 00                	push   $0x0
  802d66:	6a 00                	push   $0x0
  802d68:	6a 03                	push   $0x3
  802d6a:	e8 20 fc ff ff       	call   80298f <syscall>
  802d6f:	83 c4 18             	add    $0x18,%esp
}
  802d72:	c9                   	leave  
  802d73:	c3                   	ret    

00802d74 <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  802d74:	55                   	push   %ebp
  802d75:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  802d77:	6a 00                	push   $0x0
  802d79:	6a 00                	push   $0x0
  802d7b:	6a 00                	push   $0x0
  802d7d:	6a 00                	push   $0x0
  802d7f:	6a 00                	push   $0x0
  802d81:	6a 04                	push   $0x4
  802d83:	e8 07 fc ff ff       	call   80298f <syscall>
  802d88:	83 c4 18             	add    $0x18,%esp
}
  802d8b:	c9                   	leave  
  802d8c:	c3                   	ret    

00802d8d <sys_exit_env>:


void sys_exit_env(void)
{
  802d8d:	55                   	push   %ebp
  802d8e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  802d90:	6a 00                	push   $0x0
  802d92:	6a 00                	push   $0x0
  802d94:	6a 00                	push   $0x0
  802d96:	6a 00                	push   $0x0
  802d98:	6a 00                	push   $0x0
  802d9a:	6a 23                	push   $0x23
  802d9c:	e8 ee fb ff ff       	call   80298f <syscall>
  802da1:	83 c4 18             	add    $0x18,%esp
}
  802da4:	90                   	nop
  802da5:	c9                   	leave  
  802da6:	c3                   	ret    

00802da7 <sys_get_virtual_time>:


struct uint64
sys_get_virtual_time()
{
  802da7:	55                   	push   %ebp
  802da8:	89 e5                	mov    %esp,%ebp
  802daa:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  802dad:	8d 45 f8             	lea    -0x8(%ebp),%eax
  802db0:	8d 50 04             	lea    0x4(%eax),%edx
  802db3:	8d 45 f8             	lea    -0x8(%ebp),%eax
  802db6:	6a 00                	push   $0x0
  802db8:	6a 00                	push   $0x0
  802dba:	6a 00                	push   $0x0
  802dbc:	52                   	push   %edx
  802dbd:	50                   	push   %eax
  802dbe:	6a 24                	push   $0x24
  802dc0:	e8 ca fb ff ff       	call   80298f <syscall>
  802dc5:	83 c4 18             	add    $0x18,%esp
	return result;
  802dc8:	8b 4d 08             	mov    0x8(%ebp),%ecx
  802dcb:	8b 45 f8             	mov    -0x8(%ebp),%eax
  802dce:	8b 55 fc             	mov    -0x4(%ebp),%edx
  802dd1:	89 01                	mov    %eax,(%ecx)
  802dd3:	89 51 04             	mov    %edx,0x4(%ecx)
}
  802dd6:	8b 45 08             	mov    0x8(%ebp),%eax
  802dd9:	c9                   	leave  
  802dda:	c2 04 00             	ret    $0x4

00802ddd <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  802ddd:	55                   	push   %ebp
  802dde:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  802de0:	6a 00                	push   $0x0
  802de2:	6a 00                	push   $0x0
  802de4:	ff 75 10             	pushl  0x10(%ebp)
  802de7:	ff 75 0c             	pushl  0xc(%ebp)
  802dea:	ff 75 08             	pushl  0x8(%ebp)
  802ded:	6a 12                	push   $0x12
  802def:	e8 9b fb ff ff       	call   80298f <syscall>
  802df4:	83 c4 18             	add    $0x18,%esp
	return ;
  802df7:	90                   	nop
}
  802df8:	c9                   	leave  
  802df9:	c3                   	ret    

00802dfa <sys_rcr2>:
uint32 sys_rcr2()
{
  802dfa:	55                   	push   %ebp
  802dfb:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  802dfd:	6a 00                	push   $0x0
  802dff:	6a 00                	push   $0x0
  802e01:	6a 00                	push   $0x0
  802e03:	6a 00                	push   $0x0
  802e05:	6a 00                	push   $0x0
  802e07:	6a 25                	push   $0x25
  802e09:	e8 81 fb ff ff       	call   80298f <syscall>
  802e0e:	83 c4 18             	add    $0x18,%esp
}
  802e11:	c9                   	leave  
  802e12:	c3                   	ret    

00802e13 <sys_bypassPageFault>:
void sys_bypassPageFault(uint8 instrLength)
{
  802e13:	55                   	push   %ebp
  802e14:	89 e5                	mov    %esp,%ebp
  802e16:	83 ec 04             	sub    $0x4,%esp
  802e19:	8b 45 08             	mov    0x8(%ebp),%eax
  802e1c:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  802e1f:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  802e23:	6a 00                	push   $0x0
  802e25:	6a 00                	push   $0x0
  802e27:	6a 00                	push   $0x0
  802e29:	6a 00                	push   $0x0
  802e2b:	50                   	push   %eax
  802e2c:	6a 26                	push   $0x26
  802e2e:	e8 5c fb ff ff       	call   80298f <syscall>
  802e33:	83 c4 18             	add    $0x18,%esp
	return ;
  802e36:	90                   	nop
}
  802e37:	c9                   	leave  
  802e38:	c3                   	ret    

00802e39 <rsttst>:
void rsttst()
{
  802e39:	55                   	push   %ebp
  802e3a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  802e3c:	6a 00                	push   $0x0
  802e3e:	6a 00                	push   $0x0
  802e40:	6a 00                	push   $0x0
  802e42:	6a 00                	push   $0x0
  802e44:	6a 00                	push   $0x0
  802e46:	6a 28                	push   $0x28
  802e48:	e8 42 fb ff ff       	call   80298f <syscall>
  802e4d:	83 c4 18             	add    $0x18,%esp
	return ;
  802e50:	90                   	nop
}
  802e51:	c9                   	leave  
  802e52:	c3                   	ret    

00802e53 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  802e53:	55                   	push   %ebp
  802e54:	89 e5                	mov    %esp,%ebp
  802e56:	83 ec 04             	sub    $0x4,%esp
  802e59:	8b 45 14             	mov    0x14(%ebp),%eax
  802e5c:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  802e5f:	8b 55 18             	mov    0x18(%ebp),%edx
  802e62:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  802e66:	52                   	push   %edx
  802e67:	50                   	push   %eax
  802e68:	ff 75 10             	pushl  0x10(%ebp)
  802e6b:	ff 75 0c             	pushl  0xc(%ebp)
  802e6e:	ff 75 08             	pushl  0x8(%ebp)
  802e71:	6a 27                	push   $0x27
  802e73:	e8 17 fb ff ff       	call   80298f <syscall>
  802e78:	83 c4 18             	add    $0x18,%esp
	return ;
  802e7b:	90                   	nop
}
  802e7c:	c9                   	leave  
  802e7d:	c3                   	ret    

00802e7e <chktst>:
void chktst(uint32 n)
{
  802e7e:	55                   	push   %ebp
  802e7f:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  802e81:	6a 00                	push   $0x0
  802e83:	6a 00                	push   $0x0
  802e85:	6a 00                	push   $0x0
  802e87:	6a 00                	push   $0x0
  802e89:	ff 75 08             	pushl  0x8(%ebp)
  802e8c:	6a 29                	push   $0x29
  802e8e:	e8 fc fa ff ff       	call   80298f <syscall>
  802e93:	83 c4 18             	add    $0x18,%esp
	return ;
  802e96:	90                   	nop
}
  802e97:	c9                   	leave  
  802e98:	c3                   	ret    

00802e99 <inctst>:

void inctst()
{
  802e99:	55                   	push   %ebp
  802e9a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  802e9c:	6a 00                	push   $0x0
  802e9e:	6a 00                	push   $0x0
  802ea0:	6a 00                	push   $0x0
  802ea2:	6a 00                	push   $0x0
  802ea4:	6a 00                	push   $0x0
  802ea6:	6a 2a                	push   $0x2a
  802ea8:	e8 e2 fa ff ff       	call   80298f <syscall>
  802ead:	83 c4 18             	add    $0x18,%esp
	return ;
  802eb0:	90                   	nop
}
  802eb1:	c9                   	leave  
  802eb2:	c3                   	ret    

00802eb3 <gettst>:
uint32 gettst()
{
  802eb3:	55                   	push   %ebp
  802eb4:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  802eb6:	6a 00                	push   $0x0
  802eb8:	6a 00                	push   $0x0
  802eba:	6a 00                	push   $0x0
  802ebc:	6a 00                	push   $0x0
  802ebe:	6a 00                	push   $0x0
  802ec0:	6a 2b                	push   $0x2b
  802ec2:	e8 c8 fa ff ff       	call   80298f <syscall>
  802ec7:	83 c4 18             	add    $0x18,%esp
}
  802eca:	c9                   	leave  
  802ecb:	c3                   	ret    

00802ecc <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  802ecc:	55                   	push   %ebp
  802ecd:	89 e5                	mov    %esp,%ebp
  802ecf:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  802ed2:	6a 00                	push   $0x0
  802ed4:	6a 00                	push   $0x0
  802ed6:	6a 00                	push   $0x0
  802ed8:	6a 00                	push   $0x0
  802eda:	6a 00                	push   $0x0
  802edc:	6a 2c                	push   $0x2c
  802ede:	e8 ac fa ff ff       	call   80298f <syscall>
  802ee3:	83 c4 18             	add    $0x18,%esp
  802ee6:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  802ee9:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  802eed:	75 07                	jne    802ef6 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  802eef:	b8 01 00 00 00       	mov    $0x1,%eax
  802ef4:	eb 05                	jmp    802efb <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  802ef6:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802efb:	c9                   	leave  
  802efc:	c3                   	ret    

00802efd <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  802efd:	55                   	push   %ebp
  802efe:	89 e5                	mov    %esp,%ebp
  802f00:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  802f03:	6a 00                	push   $0x0
  802f05:	6a 00                	push   $0x0
  802f07:	6a 00                	push   $0x0
  802f09:	6a 00                	push   $0x0
  802f0b:	6a 00                	push   $0x0
  802f0d:	6a 2c                	push   $0x2c
  802f0f:	e8 7b fa ff ff       	call   80298f <syscall>
  802f14:	83 c4 18             	add    $0x18,%esp
  802f17:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  802f1a:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  802f1e:	75 07                	jne    802f27 <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  802f20:	b8 01 00 00 00       	mov    $0x1,%eax
  802f25:	eb 05                	jmp    802f2c <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  802f27:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802f2c:	c9                   	leave  
  802f2d:	c3                   	ret    

00802f2e <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  802f2e:	55                   	push   %ebp
  802f2f:	89 e5                	mov    %esp,%ebp
  802f31:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  802f34:	6a 00                	push   $0x0
  802f36:	6a 00                	push   $0x0
  802f38:	6a 00                	push   $0x0
  802f3a:	6a 00                	push   $0x0
  802f3c:	6a 00                	push   $0x0
  802f3e:	6a 2c                	push   $0x2c
  802f40:	e8 4a fa ff ff       	call   80298f <syscall>
  802f45:	83 c4 18             	add    $0x18,%esp
  802f48:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  802f4b:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  802f4f:	75 07                	jne    802f58 <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  802f51:	b8 01 00 00 00       	mov    $0x1,%eax
  802f56:	eb 05                	jmp    802f5d <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  802f58:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802f5d:	c9                   	leave  
  802f5e:	c3                   	ret    

00802f5f <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  802f5f:	55                   	push   %ebp
  802f60:	89 e5                	mov    %esp,%ebp
  802f62:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  802f65:	6a 00                	push   $0x0
  802f67:	6a 00                	push   $0x0
  802f69:	6a 00                	push   $0x0
  802f6b:	6a 00                	push   $0x0
  802f6d:	6a 00                	push   $0x0
  802f6f:	6a 2c                	push   $0x2c
  802f71:	e8 19 fa ff ff       	call   80298f <syscall>
  802f76:	83 c4 18             	add    $0x18,%esp
  802f79:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  802f7c:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  802f80:	75 07                	jne    802f89 <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  802f82:	b8 01 00 00 00       	mov    $0x1,%eax
  802f87:	eb 05                	jmp    802f8e <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  802f89:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802f8e:	c9                   	leave  
  802f8f:	c3                   	ret    

00802f90 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  802f90:	55                   	push   %ebp
  802f91:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  802f93:	6a 00                	push   $0x0
  802f95:	6a 00                	push   $0x0
  802f97:	6a 00                	push   $0x0
  802f99:	6a 00                	push   $0x0
  802f9b:	ff 75 08             	pushl  0x8(%ebp)
  802f9e:	6a 2d                	push   $0x2d
  802fa0:	e8 ea f9 ff ff       	call   80298f <syscall>
  802fa5:	83 c4 18             	add    $0x18,%esp
	return ;
  802fa8:	90                   	nop
}
  802fa9:	c9                   	leave  
  802faa:	c3                   	ret    

00802fab <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  802fab:	55                   	push   %ebp
  802fac:	89 e5                	mov    %esp,%ebp
  802fae:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  802faf:	8b 5d 14             	mov    0x14(%ebp),%ebx
  802fb2:	8b 4d 10             	mov    0x10(%ebp),%ecx
  802fb5:	8b 55 0c             	mov    0xc(%ebp),%edx
  802fb8:	8b 45 08             	mov    0x8(%ebp),%eax
  802fbb:	6a 00                	push   $0x0
  802fbd:	53                   	push   %ebx
  802fbe:	51                   	push   %ecx
  802fbf:	52                   	push   %edx
  802fc0:	50                   	push   %eax
  802fc1:	6a 2e                	push   $0x2e
  802fc3:	e8 c7 f9 ff ff       	call   80298f <syscall>
  802fc8:	83 c4 18             	add    $0x18,%esp
}
  802fcb:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802fce:	c9                   	leave  
  802fcf:	c3                   	ret    

00802fd0 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  802fd0:	55                   	push   %ebp
  802fd1:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  802fd3:	8b 55 0c             	mov    0xc(%ebp),%edx
  802fd6:	8b 45 08             	mov    0x8(%ebp),%eax
  802fd9:	6a 00                	push   $0x0
  802fdb:	6a 00                	push   $0x0
  802fdd:	6a 00                	push   $0x0
  802fdf:	52                   	push   %edx
  802fe0:	50                   	push   %eax
  802fe1:	6a 2f                	push   $0x2f
  802fe3:	e8 a7 f9 ff ff       	call   80298f <syscall>
  802fe8:	83 c4 18             	add    $0x18,%esp
}
  802feb:	c9                   	leave  
  802fec:	c3                   	ret    

00802fed <print_mem_block_lists>:
//===========================
// PRINT MEM BLOCK LISTS:
//===========================

void print_mem_block_lists()
{
  802fed:	55                   	push   %ebp
  802fee:	89 e5                	mov    %esp,%ebp
  802ff0:	83 ec 18             	sub    $0x18,%esp
	cprintf("\n=========================================\n");
  802ff3:	83 ec 0c             	sub    $0xc,%esp
  802ff6:	68 80 4d 80 00       	push   $0x804d80
  802ffb:	e8 dd e6 ff ff       	call   8016dd <cprintf>
  803000:	83 c4 10             	add    $0x10,%esp
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
  803003:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nFreeMemBlocksList:\n");
  80300a:	83 ec 0c             	sub    $0xc,%esp
  80300d:	68 ac 4d 80 00       	push   $0x804dac
  803012:	e8 c6 e6 ff ff       	call   8016dd <cprintf>
  803017:	83 c4 10             	add    $0x10,%esp
	uint8 sorted = 1 ;
  80301a:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &FreeMemBlocksList)
  80301e:	a1 38 51 80 00       	mov    0x805138,%eax
  803023:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803026:	eb 56                	jmp    80307e <print_mem_block_lists+0x91>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  803028:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80302c:	74 1c                	je     80304a <print_mem_block_lists+0x5d>
  80302e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803031:	8b 50 08             	mov    0x8(%eax),%edx
  803034:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803037:	8b 48 08             	mov    0x8(%eax),%ecx
  80303a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80303d:	8b 40 0c             	mov    0xc(%eax),%eax
  803040:	01 c8                	add    %ecx,%eax
  803042:	39 c2                	cmp    %eax,%edx
  803044:	73 04                	jae    80304a <print_mem_block_lists+0x5d>
			sorted = 0 ;
  803046:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  80304a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80304d:	8b 50 08             	mov    0x8(%eax),%edx
  803050:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803053:	8b 40 0c             	mov    0xc(%eax),%eax
  803056:	01 c2                	add    %eax,%edx
  803058:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80305b:	8b 40 08             	mov    0x8(%eax),%eax
  80305e:	83 ec 04             	sub    $0x4,%esp
  803061:	52                   	push   %edx
  803062:	50                   	push   %eax
  803063:	68 c1 4d 80 00       	push   $0x804dc1
  803068:	e8 70 e6 ff ff       	call   8016dd <cprintf>
  80306d:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  803070:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803073:	89 45 f0             	mov    %eax,-0x10(%ebp)
	cprintf("\n=========================================\n");
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
	cprintf("\nFreeMemBlocksList:\n");
	uint8 sorted = 1 ;
	LIST_FOREACH(blk, &FreeMemBlocksList)
  803076:	a1 40 51 80 00       	mov    0x805140,%eax
  80307b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80307e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803082:	74 07                	je     80308b <print_mem_block_lists+0x9e>
  803084:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803087:	8b 00                	mov    (%eax),%eax
  803089:	eb 05                	jmp    803090 <print_mem_block_lists+0xa3>
  80308b:	b8 00 00 00 00       	mov    $0x0,%eax
  803090:	a3 40 51 80 00       	mov    %eax,0x805140
  803095:	a1 40 51 80 00       	mov    0x805140,%eax
  80309a:	85 c0                	test   %eax,%eax
  80309c:	75 8a                	jne    803028 <print_mem_block_lists+0x3b>
  80309e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8030a2:	75 84                	jne    803028 <print_mem_block_lists+0x3b>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;
  8030a4:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  8030a8:	75 10                	jne    8030ba <print_mem_block_lists+0xcd>
  8030aa:	83 ec 0c             	sub    $0xc,%esp
  8030ad:	68 d0 4d 80 00       	push   $0x804dd0
  8030b2:	e8 26 e6 ff ff       	call   8016dd <cprintf>
  8030b7:	83 c4 10             	add    $0x10,%esp

	lastBlk = NULL ;
  8030ba:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nAllocMemBlocksList:\n");
  8030c1:	83 ec 0c             	sub    $0xc,%esp
  8030c4:	68 f4 4d 80 00       	push   $0x804df4
  8030c9:	e8 0f e6 ff ff       	call   8016dd <cprintf>
  8030ce:	83 c4 10             	add    $0x10,%esp
	sorted = 1 ;
  8030d1:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &AllocMemBlocksList)
  8030d5:	a1 40 50 80 00       	mov    0x805040,%eax
  8030da:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8030dd:	eb 56                	jmp    803135 <print_mem_block_lists+0x148>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  8030df:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8030e3:	74 1c                	je     803101 <print_mem_block_lists+0x114>
  8030e5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030e8:	8b 50 08             	mov    0x8(%eax),%edx
  8030eb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8030ee:	8b 48 08             	mov    0x8(%eax),%ecx
  8030f1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8030f4:	8b 40 0c             	mov    0xc(%eax),%eax
  8030f7:	01 c8                	add    %ecx,%eax
  8030f9:	39 c2                	cmp    %eax,%edx
  8030fb:	73 04                	jae    803101 <print_mem_block_lists+0x114>
			sorted = 0 ;
  8030fd:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  803101:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803104:	8b 50 08             	mov    0x8(%eax),%edx
  803107:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80310a:	8b 40 0c             	mov    0xc(%eax),%eax
  80310d:	01 c2                	add    %eax,%edx
  80310f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803112:	8b 40 08             	mov    0x8(%eax),%eax
  803115:	83 ec 04             	sub    $0x4,%esp
  803118:	52                   	push   %edx
  803119:	50                   	push   %eax
  80311a:	68 c1 4d 80 00       	push   $0x804dc1
  80311f:	e8 b9 e5 ff ff       	call   8016dd <cprintf>
  803124:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  803127:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80312a:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;

	lastBlk = NULL ;
	cprintf("\nAllocMemBlocksList:\n");
	sorted = 1 ;
	LIST_FOREACH(blk, &AllocMemBlocksList)
  80312d:	a1 48 50 80 00       	mov    0x805048,%eax
  803132:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803135:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803139:	74 07                	je     803142 <print_mem_block_lists+0x155>
  80313b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80313e:	8b 00                	mov    (%eax),%eax
  803140:	eb 05                	jmp    803147 <print_mem_block_lists+0x15a>
  803142:	b8 00 00 00 00       	mov    $0x0,%eax
  803147:	a3 48 50 80 00       	mov    %eax,0x805048
  80314c:	a1 48 50 80 00       	mov    0x805048,%eax
  803151:	85 c0                	test   %eax,%eax
  803153:	75 8a                	jne    8030df <print_mem_block_lists+0xf2>
  803155:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803159:	75 84                	jne    8030df <print_mem_block_lists+0xf2>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nAllocMemBlocksList is NOT SORTED!!\n") ;
  80315b:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  80315f:	75 10                	jne    803171 <print_mem_block_lists+0x184>
  803161:	83 ec 0c             	sub    $0xc,%esp
  803164:	68 0c 4e 80 00       	push   $0x804e0c
  803169:	e8 6f e5 ff ff       	call   8016dd <cprintf>
  80316e:	83 c4 10             	add    $0x10,%esp
	cprintf("\n=========================================\n");
  803171:	83 ec 0c             	sub    $0xc,%esp
  803174:	68 80 4d 80 00       	push   $0x804d80
  803179:	e8 5f e5 ff ff       	call   8016dd <cprintf>
  80317e:	83 c4 10             	add    $0x10,%esp

}
  803181:	90                   	nop
  803182:	c9                   	leave  
  803183:	c3                   	ret    

00803184 <initialize_MemBlocksList>:

//===============================
// [1] INITIALIZE AVAILABLE LIST:
//===============================
void initialize_MemBlocksList(uint32 numOfBlocks)
{
  803184:	55                   	push   %ebp
  803185:	89 e5                	mov    %esp,%ebp
  803187:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] initialize_MemBlocksList
	// Write your code here, remove the panic and write your code
	//panic("initialize_MemBlocksList() is not implemented yet...!!");
	uint32 n = numOfBlocks;
  80318a:	8b 45 08             	mov    0x8(%ebp),%eax
  80318d:	89 45 f0             	mov    %eax,-0x10(%ebp)

	LIST_INIT(&AvailableMemBlocksList);
  803190:	c7 05 48 51 80 00 00 	movl   $0x0,0x805148
  803197:	00 00 00 
  80319a:	c7 05 4c 51 80 00 00 	movl   $0x0,0x80514c
  8031a1:	00 00 00 
  8031a4:	c7 05 54 51 80 00 00 	movl   $0x0,0x805154
  8031ab:	00 00 00 
	for(int i = 0; i<n;i++)
  8031ae:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  8031b5:	e9 9e 00 00 00       	jmp    803258 <initialize_MemBlocksList+0xd4>
	{
		LIST_INSERT_HEAD(&AvailableMemBlocksList, &(MemBlockNodes[i]));
  8031ba:	a1 50 50 80 00       	mov    0x805050,%eax
  8031bf:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8031c2:	c1 e2 04             	shl    $0x4,%edx
  8031c5:	01 d0                	add    %edx,%eax
  8031c7:	85 c0                	test   %eax,%eax
  8031c9:	75 14                	jne    8031df <initialize_MemBlocksList+0x5b>
  8031cb:	83 ec 04             	sub    $0x4,%esp
  8031ce:	68 34 4e 80 00       	push   $0x804e34
  8031d3:	6a 47                	push   $0x47
  8031d5:	68 57 4e 80 00       	push   $0x804e57
  8031da:	e8 4a e2 ff ff       	call   801429 <_panic>
  8031df:	a1 50 50 80 00       	mov    0x805050,%eax
  8031e4:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8031e7:	c1 e2 04             	shl    $0x4,%edx
  8031ea:	01 d0                	add    %edx,%eax
  8031ec:	8b 15 48 51 80 00    	mov    0x805148,%edx
  8031f2:	89 10                	mov    %edx,(%eax)
  8031f4:	8b 00                	mov    (%eax),%eax
  8031f6:	85 c0                	test   %eax,%eax
  8031f8:	74 18                	je     803212 <initialize_MemBlocksList+0x8e>
  8031fa:	a1 48 51 80 00       	mov    0x805148,%eax
  8031ff:	8b 15 50 50 80 00    	mov    0x805050,%edx
  803205:	8b 4d f4             	mov    -0xc(%ebp),%ecx
  803208:	c1 e1 04             	shl    $0x4,%ecx
  80320b:	01 ca                	add    %ecx,%edx
  80320d:	89 50 04             	mov    %edx,0x4(%eax)
  803210:	eb 12                	jmp    803224 <initialize_MemBlocksList+0xa0>
  803212:	a1 50 50 80 00       	mov    0x805050,%eax
  803217:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80321a:	c1 e2 04             	shl    $0x4,%edx
  80321d:	01 d0                	add    %edx,%eax
  80321f:	a3 4c 51 80 00       	mov    %eax,0x80514c
  803224:	a1 50 50 80 00       	mov    0x805050,%eax
  803229:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80322c:	c1 e2 04             	shl    $0x4,%edx
  80322f:	01 d0                	add    %edx,%eax
  803231:	a3 48 51 80 00       	mov    %eax,0x805148
  803236:	a1 50 50 80 00       	mov    0x805050,%eax
  80323b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80323e:	c1 e2 04             	shl    $0x4,%edx
  803241:	01 d0                	add    %edx,%eax
  803243:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80324a:	a1 54 51 80 00       	mov    0x805154,%eax
  80324f:	40                   	inc    %eax
  803250:	a3 54 51 80 00       	mov    %eax,0x805154
	// Write your code here, remove the panic and write your code
	//panic("initialize_MemBlocksList() is not implemented yet...!!");
	uint32 n = numOfBlocks;

	LIST_INIT(&AvailableMemBlocksList);
	for(int i = 0; i<n;i++)
  803255:	ff 45 f4             	incl   -0xc(%ebp)
  803258:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80325b:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80325e:	0f 82 56 ff ff ff    	jb     8031ba <initialize_MemBlocksList+0x36>
	{
		LIST_INSERT_HEAD(&AvailableMemBlocksList, &(MemBlockNodes[i]));
	}
}
  803264:	90                   	nop
  803265:	c9                   	leave  
  803266:	c3                   	ret    

00803267 <find_block>:

//===============================
// [2] FIND BLOCK:
//===============================
struct MemBlock *find_block(struct MemBlock_List *blockList, uint32 va)
{
  803267:	55                   	push   %ebp
  803268:	89 e5                	mov    %esp,%ebp
  80326a:	83 ec 10             	sub    $0x10,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] find_block
	// Write your code here, remove the panic and write your code
	//panic("find_block() is not implemented yet...!!");
	uint32 virAddress = va;
  80326d:	8b 45 0c             	mov    0xc(%ebp),%eax
  803270:	89 45 f4             	mov    %eax,-0xc(%ebp)
	struct MemBlock* blk;
	int found = 0;
  803273:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	LIST_FOREACH(blk, &(AllocMemBlocksList))
  80327a:	a1 40 50 80 00       	mov    0x805040,%eax
  80327f:	89 45 fc             	mov    %eax,-0x4(%ebp)
  803282:	eb 23                	jmp    8032a7 <find_block+0x40>
	{
		if(blk->sva == virAddress)
  803284:	8b 45 fc             	mov    -0x4(%ebp),%eax
  803287:	8b 40 08             	mov    0x8(%eax),%eax
  80328a:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  80328d:	75 09                	jne    803298 <find_block+0x31>
		{
			found = 1;
  80328f:	c7 45 f8 01 00 00 00 	movl   $0x1,-0x8(%ebp)
			break;
  803296:	eb 35                	jmp    8032cd <find_block+0x66>
		}
		else
		{
			found = 0;
  803298:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	//panic("find_block() is not implemented yet...!!");
	uint32 virAddress = va;
	struct MemBlock* blk;
	int found = 0;

	LIST_FOREACH(blk, &(AllocMemBlocksList))
  80329f:	a1 48 50 80 00       	mov    0x805048,%eax
  8032a4:	89 45 fc             	mov    %eax,-0x4(%ebp)
  8032a7:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8032ab:	74 07                	je     8032b4 <find_block+0x4d>
  8032ad:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8032b0:	8b 00                	mov    (%eax),%eax
  8032b2:	eb 05                	jmp    8032b9 <find_block+0x52>
  8032b4:	b8 00 00 00 00       	mov    $0x0,%eax
  8032b9:	a3 48 50 80 00       	mov    %eax,0x805048
  8032be:	a1 48 50 80 00       	mov    0x805048,%eax
  8032c3:	85 c0                	test   %eax,%eax
  8032c5:	75 bd                	jne    803284 <find_block+0x1d>
  8032c7:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8032cb:	75 b7                	jne    803284 <find_block+0x1d>
		{
			found = 0;
			continue;
		}
	}
	if(found == 1)
  8032cd:	83 7d f8 01          	cmpl   $0x1,-0x8(%ebp)
  8032d1:	75 05                	jne    8032d8 <find_block+0x71>
	{
		return blk;
  8032d3:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8032d6:	eb 05                	jmp    8032dd <find_block+0x76>
	}
	else
	{
		return NULL;
  8032d8:	b8 00 00 00 00       	mov    $0x0,%eax
	}
}
  8032dd:	c9                   	leave  
  8032de:	c3                   	ret    

008032df <insert_sorted_allocList>:

//=========================================
// [3] INSERT BLOCK IN ALLOC LIST [SORTED]:
//=========================================
void insert_sorted_allocList(struct MemBlock *blockToInsert)
{
  8032df:	55                   	push   %ebp
  8032e0:	89 e5                	mov    %esp,%ebp
  8032e2:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] insert_sorted_allocList
	// Write your code here, remove the panic and write your code
	//panic("insert_sorted_allocList() is not implemented yet...!!");
	struct MemBlock* blk;
	struct MemBlock* newblk = blockToInsert;
  8032e5:	8b 45 08             	mov    0x8(%ebp),%eax
  8032e8:	89 45 f0             	mov    %eax,-0x10(%ebp)

	if((LIST_EMPTY(&AllocMemBlocksList)) || (newblk->sva < LIST_FIRST(&AllocMemBlocksList)->sva))
  8032eb:	a1 40 50 80 00       	mov    0x805040,%eax
  8032f0:	85 c0                	test   %eax,%eax
  8032f2:	74 12                	je     803306 <insert_sorted_allocList+0x27>
  8032f4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8032f7:	8b 50 08             	mov    0x8(%eax),%edx
  8032fa:	a1 40 50 80 00       	mov    0x805040,%eax
  8032ff:	8b 40 08             	mov    0x8(%eax),%eax
  803302:	39 c2                	cmp    %eax,%edx
  803304:	73 65                	jae    80336b <insert_sorted_allocList+0x8c>
	{
		LIST_INSERT_HEAD(&(AllocMemBlocksList), newblk);
  803306:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80330a:	75 14                	jne    803320 <insert_sorted_allocList+0x41>
  80330c:	83 ec 04             	sub    $0x4,%esp
  80330f:	68 34 4e 80 00       	push   $0x804e34
  803314:	6a 7b                	push   $0x7b
  803316:	68 57 4e 80 00       	push   $0x804e57
  80331b:	e8 09 e1 ff ff       	call   801429 <_panic>
  803320:	8b 15 40 50 80 00    	mov    0x805040,%edx
  803326:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803329:	89 10                	mov    %edx,(%eax)
  80332b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80332e:	8b 00                	mov    (%eax),%eax
  803330:	85 c0                	test   %eax,%eax
  803332:	74 0d                	je     803341 <insert_sorted_allocList+0x62>
  803334:	a1 40 50 80 00       	mov    0x805040,%eax
  803339:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80333c:	89 50 04             	mov    %edx,0x4(%eax)
  80333f:	eb 08                	jmp    803349 <insert_sorted_allocList+0x6a>
  803341:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803344:	a3 44 50 80 00       	mov    %eax,0x805044
  803349:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80334c:	a3 40 50 80 00       	mov    %eax,0x805040
  803351:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803354:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80335b:	a1 4c 50 80 00       	mov    0x80504c,%eax
  803360:	40                   	inc    %eax
  803361:	a3 4c 50 80 00       	mov    %eax,0x80504c
  803366:	e9 5f 01 00 00       	jmp    8034ca <insert_sorted_allocList+0x1eb>
	}
	else if(newblk->sva > LIST_LAST(&AllocMemBlocksList)->sva)
  80336b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80336e:	8b 50 08             	mov    0x8(%eax),%edx
  803371:	a1 44 50 80 00       	mov    0x805044,%eax
  803376:	8b 40 08             	mov    0x8(%eax),%eax
  803379:	39 c2                	cmp    %eax,%edx
  80337b:	76 65                	jbe    8033e2 <insert_sorted_allocList+0x103>
	{
		LIST_INSERT_TAIL(&AllocMemBlocksList, newblk);
  80337d:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  803381:	75 14                	jne    803397 <insert_sorted_allocList+0xb8>
  803383:	83 ec 04             	sub    $0x4,%esp
  803386:	68 70 4e 80 00       	push   $0x804e70
  80338b:	6a 7f                	push   $0x7f
  80338d:	68 57 4e 80 00       	push   $0x804e57
  803392:	e8 92 e0 ff ff       	call   801429 <_panic>
  803397:	8b 15 44 50 80 00    	mov    0x805044,%edx
  80339d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8033a0:	89 50 04             	mov    %edx,0x4(%eax)
  8033a3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8033a6:	8b 40 04             	mov    0x4(%eax),%eax
  8033a9:	85 c0                	test   %eax,%eax
  8033ab:	74 0c                	je     8033b9 <insert_sorted_allocList+0xda>
  8033ad:	a1 44 50 80 00       	mov    0x805044,%eax
  8033b2:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8033b5:	89 10                	mov    %edx,(%eax)
  8033b7:	eb 08                	jmp    8033c1 <insert_sorted_allocList+0xe2>
  8033b9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8033bc:	a3 40 50 80 00       	mov    %eax,0x805040
  8033c1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8033c4:	a3 44 50 80 00       	mov    %eax,0x805044
  8033c9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8033cc:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8033d2:	a1 4c 50 80 00       	mov    0x80504c,%eax
  8033d7:	40                   	inc    %eax
  8033d8:	a3 4c 50 80 00       	mov    %eax,0x80504c
				LIST_INSERT_AFTER(&AllocMemBlocksList, blk, newblk);
				break;
			}
		}
	}
}
  8033dd:	e9 e8 00 00 00       	jmp    8034ca <insert_sorted_allocList+0x1eb>
	{
		LIST_INSERT_TAIL(&AllocMemBlocksList, newblk);
	}
	else
	{
		LIST_FOREACH(blk, &AllocMemBlocksList)
  8033e2:	a1 40 50 80 00       	mov    0x805040,%eax
  8033e7:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8033ea:	e9 ab 00 00 00       	jmp    80349a <insert_sorted_allocList+0x1bb>
		{
			if(blk->prev_next_info.le_next != NULL && newblk->sva > blk->sva  && newblk->sva < blk->prev_next_info.le_next->sva)
  8033ef:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8033f2:	8b 00                	mov    (%eax),%eax
  8033f4:	85 c0                	test   %eax,%eax
  8033f6:	0f 84 96 00 00 00    	je     803492 <insert_sorted_allocList+0x1b3>
  8033fc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8033ff:	8b 50 08             	mov    0x8(%eax),%edx
  803402:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803405:	8b 40 08             	mov    0x8(%eax),%eax
  803408:	39 c2                	cmp    %eax,%edx
  80340a:	0f 86 82 00 00 00    	jbe    803492 <insert_sorted_allocList+0x1b3>
  803410:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803413:	8b 50 08             	mov    0x8(%eax),%edx
  803416:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803419:	8b 00                	mov    (%eax),%eax
  80341b:	8b 40 08             	mov    0x8(%eax),%eax
  80341e:	39 c2                	cmp    %eax,%edx
  803420:	73 70                	jae    803492 <insert_sorted_allocList+0x1b3>
			{
				LIST_INSERT_AFTER(&AllocMemBlocksList, blk, newblk);
  803422:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803426:	74 06                	je     80342e <insert_sorted_allocList+0x14f>
  803428:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80342c:	75 17                	jne    803445 <insert_sorted_allocList+0x166>
  80342e:	83 ec 04             	sub    $0x4,%esp
  803431:	68 94 4e 80 00       	push   $0x804e94
  803436:	68 87 00 00 00       	push   $0x87
  80343b:	68 57 4e 80 00       	push   $0x804e57
  803440:	e8 e4 df ff ff       	call   801429 <_panic>
  803445:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803448:	8b 10                	mov    (%eax),%edx
  80344a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80344d:	89 10                	mov    %edx,(%eax)
  80344f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803452:	8b 00                	mov    (%eax),%eax
  803454:	85 c0                	test   %eax,%eax
  803456:	74 0b                	je     803463 <insert_sorted_allocList+0x184>
  803458:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80345b:	8b 00                	mov    (%eax),%eax
  80345d:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803460:	89 50 04             	mov    %edx,0x4(%eax)
  803463:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803466:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803469:	89 10                	mov    %edx,(%eax)
  80346b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80346e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803471:	89 50 04             	mov    %edx,0x4(%eax)
  803474:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803477:	8b 00                	mov    (%eax),%eax
  803479:	85 c0                	test   %eax,%eax
  80347b:	75 08                	jne    803485 <insert_sorted_allocList+0x1a6>
  80347d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803480:	a3 44 50 80 00       	mov    %eax,0x805044
  803485:	a1 4c 50 80 00       	mov    0x80504c,%eax
  80348a:	40                   	inc    %eax
  80348b:	a3 4c 50 80 00       	mov    %eax,0x80504c
				break;
  803490:	eb 38                	jmp    8034ca <insert_sorted_allocList+0x1eb>
	{
		LIST_INSERT_TAIL(&AllocMemBlocksList, newblk);
	}
	else
	{
		LIST_FOREACH(blk, &AllocMemBlocksList)
  803492:	a1 48 50 80 00       	mov    0x805048,%eax
  803497:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80349a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80349e:	74 07                	je     8034a7 <insert_sorted_allocList+0x1c8>
  8034a0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8034a3:	8b 00                	mov    (%eax),%eax
  8034a5:	eb 05                	jmp    8034ac <insert_sorted_allocList+0x1cd>
  8034a7:	b8 00 00 00 00       	mov    $0x0,%eax
  8034ac:	a3 48 50 80 00       	mov    %eax,0x805048
  8034b1:	a1 48 50 80 00       	mov    0x805048,%eax
  8034b6:	85 c0                	test   %eax,%eax
  8034b8:	0f 85 31 ff ff ff    	jne    8033ef <insert_sorted_allocList+0x110>
  8034be:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8034c2:	0f 85 27 ff ff ff    	jne    8033ef <insert_sorted_allocList+0x110>
				LIST_INSERT_AFTER(&AllocMemBlocksList, blk, newblk);
				break;
			}
		}
	}
}
  8034c8:	eb 00                	jmp    8034ca <insert_sorted_allocList+0x1eb>
  8034ca:	90                   	nop
  8034cb:	c9                   	leave  
  8034cc:	c3                   	ret    

008034cd <alloc_block_FF>:

//=========================================
// [4] ALLOCATE BLOCK BY FIRST FIT:
//=========================================
struct MemBlock *alloc_block_FF(uint32 size)
{
  8034cd:	55                   	push   %ebp
  8034ce:	89 e5                	mov    %esp,%ebp
  8034d0:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_FF
	// Write your code here, remove the panic and write your code
	//panic("alloc_block_FF() is not implemented yet...!!");
	uint32 versize = size;
  8034d3:	8b 45 08             	mov    0x8(%ebp),%eax
  8034d6:	89 45 f0             	mov    %eax,-0x10(%ebp)
	struct MemBlock* blk;
	struct MemBlock* newblk = LIST_FIRST(&AvailableMemBlocksList);
  8034d9:	a1 48 51 80 00       	mov    0x805148,%eax
  8034de:	89 45 ec             	mov    %eax,-0x14(%ebp)

	LIST_FOREACH(blk,&FreeMemBlocksList)
  8034e1:	a1 38 51 80 00       	mov    0x805138,%eax
  8034e6:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8034e9:	e9 77 01 00 00       	jmp    803665 <alloc_block_FF+0x198>
	{
		if(blk->size == versize)
  8034ee:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8034f1:	8b 40 0c             	mov    0xc(%eax),%eax
  8034f4:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8034f7:	0f 85 8a 00 00 00    	jne    803587 <alloc_block_FF+0xba>
		{
			LIST_REMOVE(&FreeMemBlocksList,blk);
  8034fd:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803501:	75 17                	jne    80351a <alloc_block_FF+0x4d>
  803503:	83 ec 04             	sub    $0x4,%esp
  803506:	68 c8 4e 80 00       	push   $0x804ec8
  80350b:	68 9e 00 00 00       	push   $0x9e
  803510:	68 57 4e 80 00       	push   $0x804e57
  803515:	e8 0f df ff ff       	call   801429 <_panic>
  80351a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80351d:	8b 00                	mov    (%eax),%eax
  80351f:	85 c0                	test   %eax,%eax
  803521:	74 10                	je     803533 <alloc_block_FF+0x66>
  803523:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803526:	8b 00                	mov    (%eax),%eax
  803528:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80352b:	8b 52 04             	mov    0x4(%edx),%edx
  80352e:	89 50 04             	mov    %edx,0x4(%eax)
  803531:	eb 0b                	jmp    80353e <alloc_block_FF+0x71>
  803533:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803536:	8b 40 04             	mov    0x4(%eax),%eax
  803539:	a3 3c 51 80 00       	mov    %eax,0x80513c
  80353e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803541:	8b 40 04             	mov    0x4(%eax),%eax
  803544:	85 c0                	test   %eax,%eax
  803546:	74 0f                	je     803557 <alloc_block_FF+0x8a>
  803548:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80354b:	8b 40 04             	mov    0x4(%eax),%eax
  80354e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803551:	8b 12                	mov    (%edx),%edx
  803553:	89 10                	mov    %edx,(%eax)
  803555:	eb 0a                	jmp    803561 <alloc_block_FF+0x94>
  803557:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80355a:	8b 00                	mov    (%eax),%eax
  80355c:	a3 38 51 80 00       	mov    %eax,0x805138
  803561:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803564:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80356a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80356d:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803574:	a1 44 51 80 00       	mov    0x805144,%eax
  803579:	48                   	dec    %eax
  80357a:	a3 44 51 80 00       	mov    %eax,0x805144
			return blk;
  80357f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803582:	e9 11 01 00 00       	jmp    803698 <alloc_block_FF+0x1cb>
		}
		else if(blk->size > versize)
  803587:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80358a:	8b 40 0c             	mov    0xc(%eax),%eax
  80358d:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  803590:	0f 86 c7 00 00 00    	jbe    80365d <alloc_block_FF+0x190>
		{
			LIST_REMOVE(&AvailableMemBlocksList,newblk);
  803596:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  80359a:	75 17                	jne    8035b3 <alloc_block_FF+0xe6>
  80359c:	83 ec 04             	sub    $0x4,%esp
  80359f:	68 c8 4e 80 00       	push   $0x804ec8
  8035a4:	68 a3 00 00 00       	push   $0xa3
  8035a9:	68 57 4e 80 00       	push   $0x804e57
  8035ae:	e8 76 de ff ff       	call   801429 <_panic>
  8035b3:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8035b6:	8b 00                	mov    (%eax),%eax
  8035b8:	85 c0                	test   %eax,%eax
  8035ba:	74 10                	je     8035cc <alloc_block_FF+0xff>
  8035bc:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8035bf:	8b 00                	mov    (%eax),%eax
  8035c1:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8035c4:	8b 52 04             	mov    0x4(%edx),%edx
  8035c7:	89 50 04             	mov    %edx,0x4(%eax)
  8035ca:	eb 0b                	jmp    8035d7 <alloc_block_FF+0x10a>
  8035cc:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8035cf:	8b 40 04             	mov    0x4(%eax),%eax
  8035d2:	a3 4c 51 80 00       	mov    %eax,0x80514c
  8035d7:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8035da:	8b 40 04             	mov    0x4(%eax),%eax
  8035dd:	85 c0                	test   %eax,%eax
  8035df:	74 0f                	je     8035f0 <alloc_block_FF+0x123>
  8035e1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8035e4:	8b 40 04             	mov    0x4(%eax),%eax
  8035e7:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8035ea:	8b 12                	mov    (%edx),%edx
  8035ec:	89 10                	mov    %edx,(%eax)
  8035ee:	eb 0a                	jmp    8035fa <alloc_block_FF+0x12d>
  8035f0:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8035f3:	8b 00                	mov    (%eax),%eax
  8035f5:	a3 48 51 80 00       	mov    %eax,0x805148
  8035fa:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8035fd:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803603:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803606:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80360d:	a1 54 51 80 00       	mov    0x805154,%eax
  803612:	48                   	dec    %eax
  803613:	a3 54 51 80 00       	mov    %eax,0x805154
			newblk->size = versize;
  803618:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80361b:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80361e:	89 50 0c             	mov    %edx,0xc(%eax)
			blk->size = blk->size-versize;
  803621:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803624:	8b 40 0c             	mov    0xc(%eax),%eax
  803627:	2b 45 f0             	sub    -0x10(%ebp),%eax
  80362a:	89 c2                	mov    %eax,%edx
  80362c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80362f:	89 50 0c             	mov    %edx,0xc(%eax)
			uint32 newveradd = blk->sva;
  803632:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803635:	8b 40 08             	mov    0x8(%eax),%eax
  803638:	89 45 e8             	mov    %eax,-0x18(%ebp)
			blk->sva+=newblk->size;
  80363b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80363e:	8b 50 08             	mov    0x8(%eax),%edx
  803641:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803644:	8b 40 0c             	mov    0xc(%eax),%eax
  803647:	01 c2                	add    %eax,%edx
  803649:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80364c:	89 50 08             	mov    %edx,0x8(%eax)
			newblk->sva = newveradd;
  80364f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803652:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803655:	89 50 08             	mov    %edx,0x8(%eax)
			return newblk;
  803658:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80365b:	eb 3b                	jmp    803698 <alloc_block_FF+0x1cb>
	//panic("alloc_block_FF() is not implemented yet...!!");
	uint32 versize = size;
	struct MemBlock* blk;
	struct MemBlock* newblk = LIST_FIRST(&AvailableMemBlocksList);

	LIST_FOREACH(blk,&FreeMemBlocksList)
  80365d:	a1 40 51 80 00       	mov    0x805140,%eax
  803662:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803665:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803669:	74 07                	je     803672 <alloc_block_FF+0x1a5>
  80366b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80366e:	8b 00                	mov    (%eax),%eax
  803670:	eb 05                	jmp    803677 <alloc_block_FF+0x1aa>
  803672:	b8 00 00 00 00       	mov    $0x0,%eax
  803677:	a3 40 51 80 00       	mov    %eax,0x805140
  80367c:	a1 40 51 80 00       	mov    0x805140,%eax
  803681:	85 c0                	test   %eax,%eax
  803683:	0f 85 65 fe ff ff    	jne    8034ee <alloc_block_FF+0x21>
  803689:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80368d:	0f 85 5b fe ff ff    	jne    8034ee <alloc_block_FF+0x21>
			blk->sva+=newblk->size;
			newblk->sva = newveradd;
			return newblk;
		}
	}
	return NULL;
  803693:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803698:	c9                   	leave  
  803699:	c3                   	ret    

0080369a <alloc_block_BF>:

//=========================================
// [5] ALLOCATE BLOCK BY BEST FIT:
//=========================================
struct MemBlock *alloc_block_BF(uint32 size)
{
  80369a:	55                   	push   %ebp
  80369b:	89 e5                	mov    %esp,%ebp
  80369d:	83 ec 28             	sub    $0x28,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_BF
	// Write your code here, remove the panic and write your code
	//panic("alloc_block_BF() is not implemented yet...!!");
	uint32 versize=size;
  8036a0:	8b 45 08             	mov    0x8(%ebp),%eax
  8036a3:	89 45 e8             	mov    %eax,-0x18(%ebp)
	struct MemBlock* blk;
	struct MemBlock* newblk=LIST_FIRST(&AvailableMemBlocksList);
  8036a6:	a1 48 51 80 00       	mov    0x805148,%eax
  8036ab:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	uint32 newveradd;
	uint32 newsize;
	int size_free = LIST_SIZE(&FreeMemBlocksList);
  8036ae:	a1 44 51 80 00       	mov    0x805144,%eax
  8036b3:	89 45 e0             	mov    %eax,-0x20(%ebp)

	LIST_FOREACH(blk, &FreeMemBlocksList)
  8036b6:	a1 38 51 80 00       	mov    0x805138,%eax
  8036bb:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8036be:	e9 a1 00 00 00       	jmp    803764 <alloc_block_BF+0xca>
	{
		if(blk->size == versize)
  8036c3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8036c6:	8b 40 0c             	mov    0xc(%eax),%eax
  8036c9:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  8036cc:	0f 85 8a 00 00 00    	jne    80375c <alloc_block_BF+0xc2>
		{
			LIST_REMOVE(&FreeMemBlocksList, blk);
  8036d2:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8036d6:	75 17                	jne    8036ef <alloc_block_BF+0x55>
  8036d8:	83 ec 04             	sub    $0x4,%esp
  8036db:	68 c8 4e 80 00       	push   $0x804ec8
  8036e0:	68 c2 00 00 00       	push   $0xc2
  8036e5:	68 57 4e 80 00       	push   $0x804e57
  8036ea:	e8 3a dd ff ff       	call   801429 <_panic>
  8036ef:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8036f2:	8b 00                	mov    (%eax),%eax
  8036f4:	85 c0                	test   %eax,%eax
  8036f6:	74 10                	je     803708 <alloc_block_BF+0x6e>
  8036f8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8036fb:	8b 00                	mov    (%eax),%eax
  8036fd:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803700:	8b 52 04             	mov    0x4(%edx),%edx
  803703:	89 50 04             	mov    %edx,0x4(%eax)
  803706:	eb 0b                	jmp    803713 <alloc_block_BF+0x79>
  803708:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80370b:	8b 40 04             	mov    0x4(%eax),%eax
  80370e:	a3 3c 51 80 00       	mov    %eax,0x80513c
  803713:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803716:	8b 40 04             	mov    0x4(%eax),%eax
  803719:	85 c0                	test   %eax,%eax
  80371b:	74 0f                	je     80372c <alloc_block_BF+0x92>
  80371d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803720:	8b 40 04             	mov    0x4(%eax),%eax
  803723:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803726:	8b 12                	mov    (%edx),%edx
  803728:	89 10                	mov    %edx,(%eax)
  80372a:	eb 0a                	jmp    803736 <alloc_block_BF+0x9c>
  80372c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80372f:	8b 00                	mov    (%eax),%eax
  803731:	a3 38 51 80 00       	mov    %eax,0x805138
  803736:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803739:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80373f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803742:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803749:	a1 44 51 80 00       	mov    0x805144,%eax
  80374e:	48                   	dec    %eax
  80374f:	a3 44 51 80 00       	mov    %eax,0x805144
			return blk;
  803754:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803757:	e9 11 02 00 00       	jmp    80396d <alloc_block_BF+0x2d3>
	struct MemBlock* newblk=LIST_FIRST(&AvailableMemBlocksList);
	uint32 newveradd;
	uint32 newsize;
	int size_free = LIST_SIZE(&FreeMemBlocksList);

	LIST_FOREACH(blk, &FreeMemBlocksList)
  80375c:	a1 40 51 80 00       	mov    0x805140,%eax
  803761:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803764:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803768:	74 07                	je     803771 <alloc_block_BF+0xd7>
  80376a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80376d:	8b 00                	mov    (%eax),%eax
  80376f:	eb 05                	jmp    803776 <alloc_block_BF+0xdc>
  803771:	b8 00 00 00 00       	mov    $0x0,%eax
  803776:	a3 40 51 80 00       	mov    %eax,0x805140
  80377b:	a1 40 51 80 00       	mov    0x805140,%eax
  803780:	85 c0                	test   %eax,%eax
  803782:	0f 85 3b ff ff ff    	jne    8036c3 <alloc_block_BF+0x29>
  803788:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80378c:	0f 85 31 ff ff ff    	jne    8036c3 <alloc_block_BF+0x29>
		{
			LIST_REMOVE(&FreeMemBlocksList, blk);
			return blk;
		}
	}
	LIST_FOREACH(blk, &FreeMemBlocksList)
  803792:	a1 38 51 80 00       	mov    0x805138,%eax
  803797:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80379a:	eb 27                	jmp    8037c3 <alloc_block_BF+0x129>
	{
		if(blk->size > versize)
  80379c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80379f:	8b 40 0c             	mov    0xc(%eax),%eax
  8037a2:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  8037a5:	76 14                	jbe    8037bb <alloc_block_BF+0x121>
		{
			newsize = blk->size;
  8037a7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8037aa:	8b 40 0c             	mov    0xc(%eax),%eax
  8037ad:	89 45 ec             	mov    %eax,-0x14(%ebp)
			newveradd = blk->sva;
  8037b0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8037b3:	8b 40 08             	mov    0x8(%eax),%eax
  8037b6:	89 45 f0             	mov    %eax,-0x10(%ebp)
			break;
  8037b9:	eb 2e                	jmp    8037e9 <alloc_block_BF+0x14f>
		{
			LIST_REMOVE(&FreeMemBlocksList, blk);
			return blk;
		}
	}
	LIST_FOREACH(blk, &FreeMemBlocksList)
  8037bb:	a1 40 51 80 00       	mov    0x805140,%eax
  8037c0:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8037c3:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8037c7:	74 07                	je     8037d0 <alloc_block_BF+0x136>
  8037c9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8037cc:	8b 00                	mov    (%eax),%eax
  8037ce:	eb 05                	jmp    8037d5 <alloc_block_BF+0x13b>
  8037d0:	b8 00 00 00 00       	mov    $0x0,%eax
  8037d5:	a3 40 51 80 00       	mov    %eax,0x805140
  8037da:	a1 40 51 80 00       	mov    0x805140,%eax
  8037df:	85 c0                	test   %eax,%eax
  8037e1:	75 b9                	jne    80379c <alloc_block_BF+0x102>
  8037e3:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8037e7:	75 b3                	jne    80379c <alloc_block_BF+0x102>
			newsize = blk->size;
			newveradd = blk->sva;
			break;
		}
	}
	LIST_FOREACH(blk, &FreeMemBlocksList)
  8037e9:	a1 38 51 80 00       	mov    0x805138,%eax
  8037ee:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8037f1:	eb 30                	jmp    803823 <alloc_block_BF+0x189>
	{
		if(newsize > blk->size && blk->size > versize)
  8037f3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8037f6:	8b 40 0c             	mov    0xc(%eax),%eax
  8037f9:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  8037fc:	73 1d                	jae    80381b <alloc_block_BF+0x181>
  8037fe:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803801:	8b 40 0c             	mov    0xc(%eax),%eax
  803804:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  803807:	76 12                	jbe    80381b <alloc_block_BF+0x181>
		{
	       newsize = blk->size;
  803809:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80380c:	8b 40 0c             	mov    0xc(%eax),%eax
  80380f:	89 45 ec             	mov    %eax,-0x14(%ebp)
		   newveradd = blk->sva;
  803812:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803815:	8b 40 08             	mov    0x8(%eax),%eax
  803818:	89 45 f0             	mov    %eax,-0x10(%ebp)
			newsize = blk->size;
			newveradd = blk->sva;
			break;
		}
	}
	LIST_FOREACH(blk, &FreeMemBlocksList)
  80381b:	a1 40 51 80 00       	mov    0x805140,%eax
  803820:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803823:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803827:	74 07                	je     803830 <alloc_block_BF+0x196>
  803829:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80382c:	8b 00                	mov    (%eax),%eax
  80382e:	eb 05                	jmp    803835 <alloc_block_BF+0x19b>
  803830:	b8 00 00 00 00       	mov    $0x0,%eax
  803835:	a3 40 51 80 00       	mov    %eax,0x805140
  80383a:	a1 40 51 80 00       	mov    0x805140,%eax
  80383f:	85 c0                	test   %eax,%eax
  803841:	75 b0                	jne    8037f3 <alloc_block_BF+0x159>
  803843:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803847:	75 aa                	jne    8037f3 <alloc_block_BF+0x159>
		{
	       newsize = blk->size;
		   newveradd = blk->sva;
		}
	}
	LIST_FOREACH(blk, &FreeMemBlocksList)
  803849:	a1 38 51 80 00       	mov    0x805138,%eax
  80384e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803851:	e9 e4 00 00 00       	jmp    80393a <alloc_block_BF+0x2a0>
	{
		if(blk->size == newsize && blk->sva == newveradd)
  803856:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803859:	8b 40 0c             	mov    0xc(%eax),%eax
  80385c:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  80385f:	0f 85 cd 00 00 00    	jne    803932 <alloc_block_BF+0x298>
  803865:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803868:	8b 40 08             	mov    0x8(%eax),%eax
  80386b:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80386e:	0f 85 be 00 00 00    	jne    803932 <alloc_block_BF+0x298>
		{
			LIST_REMOVE(&AvailableMemBlocksList, newblk);
  803874:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  803878:	75 17                	jne    803891 <alloc_block_BF+0x1f7>
  80387a:	83 ec 04             	sub    $0x4,%esp
  80387d:	68 c8 4e 80 00       	push   $0x804ec8
  803882:	68 db 00 00 00       	push   $0xdb
  803887:	68 57 4e 80 00       	push   $0x804e57
  80388c:	e8 98 db ff ff       	call   801429 <_panic>
  803891:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803894:	8b 00                	mov    (%eax),%eax
  803896:	85 c0                	test   %eax,%eax
  803898:	74 10                	je     8038aa <alloc_block_BF+0x210>
  80389a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80389d:	8b 00                	mov    (%eax),%eax
  80389f:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8038a2:	8b 52 04             	mov    0x4(%edx),%edx
  8038a5:	89 50 04             	mov    %edx,0x4(%eax)
  8038a8:	eb 0b                	jmp    8038b5 <alloc_block_BF+0x21b>
  8038aa:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8038ad:	8b 40 04             	mov    0x4(%eax),%eax
  8038b0:	a3 4c 51 80 00       	mov    %eax,0x80514c
  8038b5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8038b8:	8b 40 04             	mov    0x4(%eax),%eax
  8038bb:	85 c0                	test   %eax,%eax
  8038bd:	74 0f                	je     8038ce <alloc_block_BF+0x234>
  8038bf:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8038c2:	8b 40 04             	mov    0x4(%eax),%eax
  8038c5:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8038c8:	8b 12                	mov    (%edx),%edx
  8038ca:	89 10                	mov    %edx,(%eax)
  8038cc:	eb 0a                	jmp    8038d8 <alloc_block_BF+0x23e>
  8038ce:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8038d1:	8b 00                	mov    (%eax),%eax
  8038d3:	a3 48 51 80 00       	mov    %eax,0x805148
  8038d8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8038db:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8038e1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8038e4:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8038eb:	a1 54 51 80 00       	mov    0x805154,%eax
  8038f0:	48                   	dec    %eax
  8038f1:	a3 54 51 80 00       	mov    %eax,0x805154
			newblk->size = versize;
  8038f6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8038f9:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8038fc:	89 50 0c             	mov    %edx,0xc(%eax)
			newblk->sva = newveradd;
  8038ff:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803902:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803905:	89 50 08             	mov    %edx,0x8(%eax)
			blk->size = blk->size - versize;
  803908:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80390b:	8b 40 0c             	mov    0xc(%eax),%eax
  80390e:	2b 45 e8             	sub    -0x18(%ebp),%eax
  803911:	89 c2                	mov    %eax,%edx
  803913:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803916:	89 50 0c             	mov    %edx,0xc(%eax)
			blk->sva+= newblk->size;
  803919:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80391c:	8b 50 08             	mov    0x8(%eax),%edx
  80391f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803922:	8b 40 0c             	mov    0xc(%eax),%eax
  803925:	01 c2                	add    %eax,%edx
  803927:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80392a:	89 50 08             	mov    %edx,0x8(%eax)
			return newblk;
  80392d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803930:	eb 3b                	jmp    80396d <alloc_block_BF+0x2d3>
		{
	       newsize = blk->size;
		   newveradd = blk->sva;
		}
	}
	LIST_FOREACH(blk, &FreeMemBlocksList)
  803932:	a1 40 51 80 00       	mov    0x805140,%eax
  803937:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80393a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80393e:	74 07                	je     803947 <alloc_block_BF+0x2ad>
  803940:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803943:	8b 00                	mov    (%eax),%eax
  803945:	eb 05                	jmp    80394c <alloc_block_BF+0x2b2>
  803947:	b8 00 00 00 00       	mov    $0x0,%eax
  80394c:	a3 40 51 80 00       	mov    %eax,0x805140
  803951:	a1 40 51 80 00       	mov    0x805140,%eax
  803956:	85 c0                	test   %eax,%eax
  803958:	0f 85 f8 fe ff ff    	jne    803856 <alloc_block_BF+0x1bc>
  80395e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803962:	0f 85 ee fe ff ff    	jne    803856 <alloc_block_BF+0x1bc>
			blk->size = blk->size - versize;
			blk->sva+= newblk->size;
			return newblk;
		}
	}
	return NULL;
  803968:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80396d:	c9                   	leave  
  80396e:	c3                   	ret    

0080396f <alloc_block_NF>:
//=========================================
// [7] ALLOCATE BLOCK BY NEXT FIT:
//=========================================
struct MemBlock *last_allocate;
struct MemBlock *alloc_block_NF(uint32 size)
{
  80396f:	55                   	push   %ebp
  803970:	89 e5                	mov    %esp,%ebp
  803972:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1 - BONUS] [DYNAMIC ALLOCATOR] alloc_block_NF
	// Write your code here, remove the panic and write your code
	//panic("alloc_block_NF() is not implemented yet...!!");
	uint32 versize = size;
  803975:	8b 45 08             	mov    0x8(%ebp),%eax
  803978:	89 45 f0             	mov    %eax,-0x10(%ebp)
	struct MemBlock* blk;
	struct MemBlock* newblk = LIST_FIRST(&AvailableMemBlocksList);
  80397b:	a1 48 51 80 00       	mov    0x805148,%eax
  803980:	89 45 ec             	mov    %eax,-0x14(%ebp)

	LIST_FOREACH(blk,&FreeMemBlocksList)
  803983:	a1 38 51 80 00       	mov    0x805138,%eax
  803988:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80398b:	e9 77 01 00 00       	jmp    803b07 <alloc_block_NF+0x198>
	{
		if(blk->size == versize)
  803990:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803993:	8b 40 0c             	mov    0xc(%eax),%eax
  803996:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  803999:	0f 85 8a 00 00 00    	jne    803a29 <alloc_block_NF+0xba>
		{
			LIST_REMOVE(&FreeMemBlocksList,blk);
  80399f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8039a3:	75 17                	jne    8039bc <alloc_block_NF+0x4d>
  8039a5:	83 ec 04             	sub    $0x4,%esp
  8039a8:	68 c8 4e 80 00       	push   $0x804ec8
  8039ad:	68 f7 00 00 00       	push   $0xf7
  8039b2:	68 57 4e 80 00       	push   $0x804e57
  8039b7:	e8 6d da ff ff       	call   801429 <_panic>
  8039bc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8039bf:	8b 00                	mov    (%eax),%eax
  8039c1:	85 c0                	test   %eax,%eax
  8039c3:	74 10                	je     8039d5 <alloc_block_NF+0x66>
  8039c5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8039c8:	8b 00                	mov    (%eax),%eax
  8039ca:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8039cd:	8b 52 04             	mov    0x4(%edx),%edx
  8039d0:	89 50 04             	mov    %edx,0x4(%eax)
  8039d3:	eb 0b                	jmp    8039e0 <alloc_block_NF+0x71>
  8039d5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8039d8:	8b 40 04             	mov    0x4(%eax),%eax
  8039db:	a3 3c 51 80 00       	mov    %eax,0x80513c
  8039e0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8039e3:	8b 40 04             	mov    0x4(%eax),%eax
  8039e6:	85 c0                	test   %eax,%eax
  8039e8:	74 0f                	je     8039f9 <alloc_block_NF+0x8a>
  8039ea:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8039ed:	8b 40 04             	mov    0x4(%eax),%eax
  8039f0:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8039f3:	8b 12                	mov    (%edx),%edx
  8039f5:	89 10                	mov    %edx,(%eax)
  8039f7:	eb 0a                	jmp    803a03 <alloc_block_NF+0x94>
  8039f9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8039fc:	8b 00                	mov    (%eax),%eax
  8039fe:	a3 38 51 80 00       	mov    %eax,0x805138
  803a03:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803a06:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803a0c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803a0f:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803a16:	a1 44 51 80 00       	mov    0x805144,%eax
  803a1b:	48                   	dec    %eax
  803a1c:	a3 44 51 80 00       	mov    %eax,0x805144
			return blk;
  803a21:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803a24:	e9 11 01 00 00       	jmp    803b3a <alloc_block_NF+0x1cb>
		}
		else if(blk->size > versize)
  803a29:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803a2c:	8b 40 0c             	mov    0xc(%eax),%eax
  803a2f:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  803a32:	0f 86 c7 00 00 00    	jbe    803aff <alloc_block_NF+0x190>
		{
			LIST_REMOVE(&AvailableMemBlocksList,newblk);
  803a38:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  803a3c:	75 17                	jne    803a55 <alloc_block_NF+0xe6>
  803a3e:	83 ec 04             	sub    $0x4,%esp
  803a41:	68 c8 4e 80 00       	push   $0x804ec8
  803a46:	68 fc 00 00 00       	push   $0xfc
  803a4b:	68 57 4e 80 00       	push   $0x804e57
  803a50:	e8 d4 d9 ff ff       	call   801429 <_panic>
  803a55:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803a58:	8b 00                	mov    (%eax),%eax
  803a5a:	85 c0                	test   %eax,%eax
  803a5c:	74 10                	je     803a6e <alloc_block_NF+0xff>
  803a5e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803a61:	8b 00                	mov    (%eax),%eax
  803a63:	8b 55 ec             	mov    -0x14(%ebp),%edx
  803a66:	8b 52 04             	mov    0x4(%edx),%edx
  803a69:	89 50 04             	mov    %edx,0x4(%eax)
  803a6c:	eb 0b                	jmp    803a79 <alloc_block_NF+0x10a>
  803a6e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803a71:	8b 40 04             	mov    0x4(%eax),%eax
  803a74:	a3 4c 51 80 00       	mov    %eax,0x80514c
  803a79:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803a7c:	8b 40 04             	mov    0x4(%eax),%eax
  803a7f:	85 c0                	test   %eax,%eax
  803a81:	74 0f                	je     803a92 <alloc_block_NF+0x123>
  803a83:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803a86:	8b 40 04             	mov    0x4(%eax),%eax
  803a89:	8b 55 ec             	mov    -0x14(%ebp),%edx
  803a8c:	8b 12                	mov    (%edx),%edx
  803a8e:	89 10                	mov    %edx,(%eax)
  803a90:	eb 0a                	jmp    803a9c <alloc_block_NF+0x12d>
  803a92:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803a95:	8b 00                	mov    (%eax),%eax
  803a97:	a3 48 51 80 00       	mov    %eax,0x805148
  803a9c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803a9f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803aa5:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803aa8:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803aaf:	a1 54 51 80 00       	mov    0x805154,%eax
  803ab4:	48                   	dec    %eax
  803ab5:	a3 54 51 80 00       	mov    %eax,0x805154
			newblk->size = versize;
  803aba:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803abd:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803ac0:	89 50 0c             	mov    %edx,0xc(%eax)
			blk->size = blk->size-versize;
  803ac3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803ac6:	8b 40 0c             	mov    0xc(%eax),%eax
  803ac9:	2b 45 f0             	sub    -0x10(%ebp),%eax
  803acc:	89 c2                	mov    %eax,%edx
  803ace:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803ad1:	89 50 0c             	mov    %edx,0xc(%eax)
			uint32 newveradd = blk->sva;
  803ad4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803ad7:	8b 40 08             	mov    0x8(%eax),%eax
  803ada:	89 45 e8             	mov    %eax,-0x18(%ebp)
			blk->sva+=newblk->size;
  803add:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803ae0:	8b 50 08             	mov    0x8(%eax),%edx
  803ae3:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803ae6:	8b 40 0c             	mov    0xc(%eax),%eax
  803ae9:	01 c2                	add    %eax,%edx
  803aeb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803aee:	89 50 08             	mov    %edx,0x8(%eax)
			newblk->sva = newveradd;
  803af1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803af4:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803af7:	89 50 08             	mov    %edx,0x8(%eax)
			return newblk;
  803afa:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803afd:	eb 3b                	jmp    803b3a <alloc_block_NF+0x1cb>
	//panic("alloc_block_NF() is not implemented yet...!!");
	uint32 versize = size;
	struct MemBlock* blk;
	struct MemBlock* newblk = LIST_FIRST(&AvailableMemBlocksList);

	LIST_FOREACH(blk,&FreeMemBlocksList)
  803aff:	a1 40 51 80 00       	mov    0x805140,%eax
  803b04:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803b07:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803b0b:	74 07                	je     803b14 <alloc_block_NF+0x1a5>
  803b0d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803b10:	8b 00                	mov    (%eax),%eax
  803b12:	eb 05                	jmp    803b19 <alloc_block_NF+0x1aa>
  803b14:	b8 00 00 00 00       	mov    $0x0,%eax
  803b19:	a3 40 51 80 00       	mov    %eax,0x805140
  803b1e:	a1 40 51 80 00       	mov    0x805140,%eax
  803b23:	85 c0                	test   %eax,%eax
  803b25:	0f 85 65 fe ff ff    	jne    803990 <alloc_block_NF+0x21>
  803b2b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803b2f:	0f 85 5b fe ff ff    	jne    803990 <alloc_block_NF+0x21>
			blk->sva+=newblk->size;
			newblk->sva = newveradd;
			return newblk;
		}
	}
	return NULL;
  803b35:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803b3a:	c9                   	leave  
  803b3b:	c3                   	ret    

00803b3c <addToAvailMemBlocksList>:

//===================================================
// [8] INSERT BLOCK (SORTED WITH MERGE) IN FREE LIST:
//===================================================
void addToAvailMemBlocksList(struct MemBlock *blockToInsert)
{
  803b3c:	55                   	push   %ebp
  803b3d:	89 e5                	mov    %esp,%ebp
  803b3f:	83 ec 08             	sub    $0x8,%esp
	blockToInsert->sva = 0;
  803b42:	8b 45 08             	mov    0x8(%ebp),%eax
  803b45:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
	blockToInsert->size = 0;
  803b4c:	8b 45 08             	mov    0x8(%ebp),%eax
  803b4f:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
	//add to avail
	LIST_INSERT_TAIL(&AvailableMemBlocksList, blockToInsert);
  803b56:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803b5a:	75 17                	jne    803b73 <addToAvailMemBlocksList+0x37>
  803b5c:	83 ec 04             	sub    $0x4,%esp
  803b5f:	68 70 4e 80 00       	push   $0x804e70
  803b64:	68 10 01 00 00       	push   $0x110
  803b69:	68 57 4e 80 00       	push   $0x804e57
  803b6e:	e8 b6 d8 ff ff       	call   801429 <_panic>
  803b73:	8b 15 4c 51 80 00    	mov    0x80514c,%edx
  803b79:	8b 45 08             	mov    0x8(%ebp),%eax
  803b7c:	89 50 04             	mov    %edx,0x4(%eax)
  803b7f:	8b 45 08             	mov    0x8(%ebp),%eax
  803b82:	8b 40 04             	mov    0x4(%eax),%eax
  803b85:	85 c0                	test   %eax,%eax
  803b87:	74 0c                	je     803b95 <addToAvailMemBlocksList+0x59>
  803b89:	a1 4c 51 80 00       	mov    0x80514c,%eax
  803b8e:	8b 55 08             	mov    0x8(%ebp),%edx
  803b91:	89 10                	mov    %edx,(%eax)
  803b93:	eb 08                	jmp    803b9d <addToAvailMemBlocksList+0x61>
  803b95:	8b 45 08             	mov    0x8(%ebp),%eax
  803b98:	a3 48 51 80 00       	mov    %eax,0x805148
  803b9d:	8b 45 08             	mov    0x8(%ebp),%eax
  803ba0:	a3 4c 51 80 00       	mov    %eax,0x80514c
  803ba5:	8b 45 08             	mov    0x8(%ebp),%eax
  803ba8:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803bae:	a1 54 51 80 00       	mov    0x805154,%eax
  803bb3:	40                   	inc    %eax
  803bb4:	a3 54 51 80 00       	mov    %eax,0x805154
}
  803bb9:	90                   	nop
  803bba:	c9                   	leave  
  803bbb:	c3                   	ret    

00803bbc <insert_sorted_with_merge_freeList>:
void insert_sorted_with_merge_freeList(struct MemBlock *blockToInsert)
{
  803bbc:	55                   	push   %ebp
  803bbd:	89 e5                	mov    %esp,%ebp
  803bbf:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] insert_sorted_with_merge_freeList
	// Write your code here, remove the panic and write your code

	struct MemBlock* last = LIST_LAST(&FreeMemBlocksList);
  803bc2:	a1 3c 51 80 00       	mov    0x80513c,%eax
  803bc7:	89 45 f0             	mov    %eax,-0x10(%ebp)
	//check if list empty
	if (LIST_SIZE(&(FreeMemBlocksList)) == 0)
  803bca:	a1 44 51 80 00       	mov    0x805144,%eax
  803bcf:	85 c0                	test   %eax,%eax
  803bd1:	75 68                	jne    803c3b <insert_sorted_with_merge_freeList+0x7f>
		LIST_INSERT_HEAD(&FreeMemBlocksList, blockToInsert);
  803bd3:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803bd7:	75 17                	jne    803bf0 <insert_sorted_with_merge_freeList+0x34>
  803bd9:	83 ec 04             	sub    $0x4,%esp
  803bdc:	68 34 4e 80 00       	push   $0x804e34
  803be1:	68 1a 01 00 00       	push   $0x11a
  803be6:	68 57 4e 80 00       	push   $0x804e57
  803beb:	e8 39 d8 ff ff       	call   801429 <_panic>
  803bf0:	8b 15 38 51 80 00    	mov    0x805138,%edx
  803bf6:	8b 45 08             	mov    0x8(%ebp),%eax
  803bf9:	89 10                	mov    %edx,(%eax)
  803bfb:	8b 45 08             	mov    0x8(%ebp),%eax
  803bfe:	8b 00                	mov    (%eax),%eax
  803c00:	85 c0                	test   %eax,%eax
  803c02:	74 0d                	je     803c11 <insert_sorted_with_merge_freeList+0x55>
  803c04:	a1 38 51 80 00       	mov    0x805138,%eax
  803c09:	8b 55 08             	mov    0x8(%ebp),%edx
  803c0c:	89 50 04             	mov    %edx,0x4(%eax)
  803c0f:	eb 08                	jmp    803c19 <insert_sorted_with_merge_freeList+0x5d>
  803c11:	8b 45 08             	mov    0x8(%ebp),%eax
  803c14:	a3 3c 51 80 00       	mov    %eax,0x80513c
  803c19:	8b 45 08             	mov    0x8(%ebp),%eax
  803c1c:	a3 38 51 80 00       	mov    %eax,0x805138
  803c21:	8b 45 08             	mov    0x8(%ebp),%eax
  803c24:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803c2b:	a1 44 51 80 00       	mov    0x805144,%eax
  803c30:	40                   	inc    %eax
  803c31:	a3 44 51 80 00       	mov    %eax,0x805144
		}
	}

	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  803c36:	e9 c5 03 00 00       	jmp    804000 <insert_sorted_with_merge_freeList+0x444>
	struct MemBlock* last = LIST_LAST(&FreeMemBlocksList);
	//check if list empty
	if (LIST_SIZE(&(FreeMemBlocksList)) == 0)
		LIST_INSERT_HEAD(&FreeMemBlocksList, blockToInsert);
	//check if it's position is at last
	else if (last->sva < blockToInsert->sva) {
  803c3b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803c3e:	8b 50 08             	mov    0x8(%eax),%edx
  803c41:	8b 45 08             	mov    0x8(%ebp),%eax
  803c44:	8b 40 08             	mov    0x8(%eax),%eax
  803c47:	39 c2                	cmp    %eax,%edx
  803c49:	0f 83 b2 00 00 00    	jae    803d01 <insert_sorted_with_merge_freeList+0x145>

		//if i have to merge
		if (last->sva + last->size == blockToInsert->sva) {
  803c4f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803c52:	8b 50 08             	mov    0x8(%eax),%edx
  803c55:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803c58:	8b 40 0c             	mov    0xc(%eax),%eax
  803c5b:	01 c2                	add    %eax,%edx
  803c5d:	8b 45 08             	mov    0x8(%ebp),%eax
  803c60:	8b 40 08             	mov    0x8(%eax),%eax
  803c63:	39 c2                	cmp    %eax,%edx
  803c65:	75 27                	jne    803c8e <insert_sorted_with_merge_freeList+0xd2>
			last->size = last->size + blockToInsert->size;
  803c67:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803c6a:	8b 50 0c             	mov    0xc(%eax),%edx
  803c6d:	8b 45 08             	mov    0x8(%ebp),%eax
  803c70:	8b 40 0c             	mov    0xc(%eax),%eax
  803c73:	01 c2                	add    %eax,%edx
  803c75:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803c78:	89 50 0c             	mov    %edx,0xc(%eax)
			addToAvailMemBlocksList(blockToInsert);
  803c7b:	83 ec 0c             	sub    $0xc,%esp
  803c7e:	ff 75 08             	pushl  0x8(%ebp)
  803c81:	e8 b6 fe ff ff       	call   803b3c <addToAvailMemBlocksList>
  803c86:	83 c4 10             	add    $0x10,%esp
		}
	}

	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  803c89:	e9 72 03 00 00       	jmp    804000 <insert_sorted_with_merge_freeList+0x444>
		if (last->sva + last->size == blockToInsert->sva) {
			last->size = last->size + blockToInsert->size;
			addToAvailMemBlocksList(blockToInsert);

		} else {
			LIST_INSERT_AFTER(&FreeMemBlocksList, last, blockToInsert);
  803c8e:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  803c92:	74 06                	je     803c9a <insert_sorted_with_merge_freeList+0xde>
  803c94:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803c98:	75 17                	jne    803cb1 <insert_sorted_with_merge_freeList+0xf5>
  803c9a:	83 ec 04             	sub    $0x4,%esp
  803c9d:	68 94 4e 80 00       	push   $0x804e94
  803ca2:	68 24 01 00 00       	push   $0x124
  803ca7:	68 57 4e 80 00       	push   $0x804e57
  803cac:	e8 78 d7 ff ff       	call   801429 <_panic>
  803cb1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803cb4:	8b 10                	mov    (%eax),%edx
  803cb6:	8b 45 08             	mov    0x8(%ebp),%eax
  803cb9:	89 10                	mov    %edx,(%eax)
  803cbb:	8b 45 08             	mov    0x8(%ebp),%eax
  803cbe:	8b 00                	mov    (%eax),%eax
  803cc0:	85 c0                	test   %eax,%eax
  803cc2:	74 0b                	je     803ccf <insert_sorted_with_merge_freeList+0x113>
  803cc4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803cc7:	8b 00                	mov    (%eax),%eax
  803cc9:	8b 55 08             	mov    0x8(%ebp),%edx
  803ccc:	89 50 04             	mov    %edx,0x4(%eax)
  803ccf:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803cd2:	8b 55 08             	mov    0x8(%ebp),%edx
  803cd5:	89 10                	mov    %edx,(%eax)
  803cd7:	8b 45 08             	mov    0x8(%ebp),%eax
  803cda:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803cdd:	89 50 04             	mov    %edx,0x4(%eax)
  803ce0:	8b 45 08             	mov    0x8(%ebp),%eax
  803ce3:	8b 00                	mov    (%eax),%eax
  803ce5:	85 c0                	test   %eax,%eax
  803ce7:	75 08                	jne    803cf1 <insert_sorted_with_merge_freeList+0x135>
  803ce9:	8b 45 08             	mov    0x8(%ebp),%eax
  803cec:	a3 3c 51 80 00       	mov    %eax,0x80513c
  803cf1:	a1 44 51 80 00       	mov    0x805144,%eax
  803cf6:	40                   	inc    %eax
  803cf7:	a3 44 51 80 00       	mov    %eax,0x805144
		}
	}

	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  803cfc:	e9 ff 02 00 00       	jmp    804000 <insert_sorted_with_merge_freeList+0x444>
		} else {
			LIST_INSERT_AFTER(&FreeMemBlocksList, last, blockToInsert);
		}
	} else {
		struct MemBlock *iterator;
		LIST_FOREACH(iterator, &(FreeMemBlocksList))
  803d01:	a1 38 51 80 00       	mov    0x805138,%eax
  803d06:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803d09:	e9 c2 02 00 00       	jmp    803fd0 <insert_sorted_with_merge_freeList+0x414>
		{

			if (iterator->sva > blockToInsert->sva) {
  803d0e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803d11:	8b 50 08             	mov    0x8(%eax),%edx
  803d14:	8b 45 08             	mov    0x8(%ebp),%eax
  803d17:	8b 40 08             	mov    0x8(%eax),%eax
  803d1a:	39 c2                	cmp    %eax,%edx
  803d1c:	0f 86 a6 02 00 00    	jbe    803fc8 <insert_sorted_with_merge_freeList+0x40c>

				struct MemBlock* prev = LIST_PREV(iterator);
  803d22:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803d25:	8b 40 04             	mov    0x4(%eax),%eax
  803d28:	89 45 ec             	mov    %eax,-0x14(%ebp)
				if (prev == NULL) {
  803d2b:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  803d2f:	0f 85 ba 00 00 00    	jne    803def <insert_sorted_with_merge_freeList+0x233>
					//check merge
					if (blockToInsert->size + blockToInsert->sva
  803d35:	8b 45 08             	mov    0x8(%ebp),%eax
  803d38:	8b 50 0c             	mov    0xc(%eax),%edx
  803d3b:	8b 45 08             	mov    0x8(%ebp),%eax
  803d3e:	8b 40 08             	mov    0x8(%eax),%eax
  803d41:	01 c2                	add    %eax,%edx
							== iterator->sva) {
  803d43:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803d46:	8b 40 08             	mov    0x8(%eax),%eax
			if (iterator->sva > blockToInsert->sva) {

				struct MemBlock* prev = LIST_PREV(iterator);
				if (prev == NULL) {
					//check merge
					if (blockToInsert->size + blockToInsert->sva
  803d49:	39 c2                	cmp    %eax,%edx
  803d4b:	75 33                	jne    803d80 <insert_sorted_with_merge_freeList+0x1c4>
							== iterator->sva) {
						iterator->sva = blockToInsert->sva;
  803d4d:	8b 45 08             	mov    0x8(%ebp),%eax
  803d50:	8b 50 08             	mov    0x8(%eax),%edx
  803d53:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803d56:	89 50 08             	mov    %edx,0x8(%eax)
						iterator->size = iterator->size + blockToInsert->size;
  803d59:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803d5c:	8b 50 0c             	mov    0xc(%eax),%edx
  803d5f:	8b 45 08             	mov    0x8(%ebp),%eax
  803d62:	8b 40 0c             	mov    0xc(%eax),%eax
  803d65:	01 c2                	add    %eax,%edx
  803d67:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803d6a:	89 50 0c             	mov    %edx,0xc(%eax)
						addToAvailMemBlocksList(blockToInsert);
  803d6d:	83 ec 0c             	sub    $0xc,%esp
  803d70:	ff 75 08             	pushl  0x8(%ebp)
  803d73:	e8 c4 fd ff ff       	call   803b3c <addToAvailMemBlocksList>
  803d78:	83 c4 10             	add    $0x10,%esp

					else {
						LIST_INSERT_BEFORE(&FreeMemBlocksList, iterator,
								blockToInsert);
					}
					break;
  803d7b:	e9 80 02 00 00       	jmp    804000 <insert_sorted_with_merge_freeList+0x444>
						addToAvailMemBlocksList(blockToInsert);

					}

					else {
						LIST_INSERT_BEFORE(&FreeMemBlocksList, iterator,
  803d80:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803d84:	74 06                	je     803d8c <insert_sorted_with_merge_freeList+0x1d0>
  803d86:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803d8a:	75 17                	jne    803da3 <insert_sorted_with_merge_freeList+0x1e7>
  803d8c:	83 ec 04             	sub    $0x4,%esp
  803d8f:	68 e8 4e 80 00       	push   $0x804ee8
  803d94:	68 3a 01 00 00       	push   $0x13a
  803d99:	68 57 4e 80 00       	push   $0x804e57
  803d9e:	e8 86 d6 ff ff       	call   801429 <_panic>
  803da3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803da6:	8b 50 04             	mov    0x4(%eax),%edx
  803da9:	8b 45 08             	mov    0x8(%ebp),%eax
  803dac:	89 50 04             	mov    %edx,0x4(%eax)
  803daf:	8b 45 08             	mov    0x8(%ebp),%eax
  803db2:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803db5:	89 10                	mov    %edx,(%eax)
  803db7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803dba:	8b 40 04             	mov    0x4(%eax),%eax
  803dbd:	85 c0                	test   %eax,%eax
  803dbf:	74 0d                	je     803dce <insert_sorted_with_merge_freeList+0x212>
  803dc1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803dc4:	8b 40 04             	mov    0x4(%eax),%eax
  803dc7:	8b 55 08             	mov    0x8(%ebp),%edx
  803dca:	89 10                	mov    %edx,(%eax)
  803dcc:	eb 08                	jmp    803dd6 <insert_sorted_with_merge_freeList+0x21a>
  803dce:	8b 45 08             	mov    0x8(%ebp),%eax
  803dd1:	a3 38 51 80 00       	mov    %eax,0x805138
  803dd6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803dd9:	8b 55 08             	mov    0x8(%ebp),%edx
  803ddc:	89 50 04             	mov    %edx,0x4(%eax)
  803ddf:	a1 44 51 80 00       	mov    0x805144,%eax
  803de4:	40                   	inc    %eax
  803de5:	a3 44 51 80 00       	mov    %eax,0x805144
								blockToInsert);
					}
					break;
  803dea:	e9 11 02 00 00       	jmp    804000 <insert_sorted_with_merge_freeList+0x444>
				} else {
					//prev and next merge
					if (prev->sva + prev->size + blockToInsert->size
  803def:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803df2:	8b 50 08             	mov    0x8(%eax),%edx
  803df5:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803df8:	8b 40 0c             	mov    0xc(%eax),%eax
  803dfb:	01 c2                	add    %eax,%edx
  803dfd:	8b 45 08             	mov    0x8(%ebp),%eax
  803e00:	8b 40 0c             	mov    0xc(%eax),%eax
  803e03:	01 c2                	add    %eax,%edx
							== iterator->sva) {
  803e05:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803e08:	8b 40 08             	mov    0x8(%eax),%eax
								blockToInsert);
					}
					break;
				} else {
					//prev and next merge
					if (prev->sva + prev->size + blockToInsert->size
  803e0b:	39 c2                	cmp    %eax,%edx
  803e0d:	0f 85 bf 00 00 00    	jne    803ed2 <insert_sorted_with_merge_freeList+0x316>
							== iterator->sva) {
						prev->size = prev->size + blockToInsert->size
  803e13:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803e16:	8b 50 0c             	mov    0xc(%eax),%edx
  803e19:	8b 45 08             	mov    0x8(%ebp),%eax
  803e1c:	8b 40 0c             	mov    0xc(%eax),%eax
  803e1f:	01 c2                	add    %eax,%edx
								+ iterator->size;
  803e21:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803e24:	8b 40 0c             	mov    0xc(%eax),%eax
  803e27:	01 c2                	add    %eax,%edx
					break;
				} else {
					//prev and next merge
					if (prev->sva + prev->size + blockToInsert->size
							== iterator->sva) {
						prev->size = prev->size + blockToInsert->size
  803e29:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803e2c:	89 50 0c             	mov    %edx,0xc(%eax)
								+ iterator->size;
						LIST_REMOVE(&FreeMemBlocksList, iterator);
  803e2f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803e33:	75 17                	jne    803e4c <insert_sorted_with_merge_freeList+0x290>
  803e35:	83 ec 04             	sub    $0x4,%esp
  803e38:	68 c8 4e 80 00       	push   $0x804ec8
  803e3d:	68 43 01 00 00       	push   $0x143
  803e42:	68 57 4e 80 00       	push   $0x804e57
  803e47:	e8 dd d5 ff ff       	call   801429 <_panic>
  803e4c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803e4f:	8b 00                	mov    (%eax),%eax
  803e51:	85 c0                	test   %eax,%eax
  803e53:	74 10                	je     803e65 <insert_sorted_with_merge_freeList+0x2a9>
  803e55:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803e58:	8b 00                	mov    (%eax),%eax
  803e5a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803e5d:	8b 52 04             	mov    0x4(%edx),%edx
  803e60:	89 50 04             	mov    %edx,0x4(%eax)
  803e63:	eb 0b                	jmp    803e70 <insert_sorted_with_merge_freeList+0x2b4>
  803e65:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803e68:	8b 40 04             	mov    0x4(%eax),%eax
  803e6b:	a3 3c 51 80 00       	mov    %eax,0x80513c
  803e70:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803e73:	8b 40 04             	mov    0x4(%eax),%eax
  803e76:	85 c0                	test   %eax,%eax
  803e78:	74 0f                	je     803e89 <insert_sorted_with_merge_freeList+0x2cd>
  803e7a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803e7d:	8b 40 04             	mov    0x4(%eax),%eax
  803e80:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803e83:	8b 12                	mov    (%edx),%edx
  803e85:	89 10                	mov    %edx,(%eax)
  803e87:	eb 0a                	jmp    803e93 <insert_sorted_with_merge_freeList+0x2d7>
  803e89:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803e8c:	8b 00                	mov    (%eax),%eax
  803e8e:	a3 38 51 80 00       	mov    %eax,0x805138
  803e93:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803e96:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803e9c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803e9f:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803ea6:	a1 44 51 80 00       	mov    0x805144,%eax
  803eab:	48                   	dec    %eax
  803eac:	a3 44 51 80 00       	mov    %eax,0x805144
						addToAvailMemBlocksList(blockToInsert);
  803eb1:	83 ec 0c             	sub    $0xc,%esp
  803eb4:	ff 75 08             	pushl  0x8(%ebp)
  803eb7:	e8 80 fc ff ff       	call   803b3c <addToAvailMemBlocksList>
  803ebc:	83 c4 10             	add    $0x10,%esp
						addToAvailMemBlocksList(iterator);
  803ebf:	83 ec 0c             	sub    $0xc,%esp
  803ec2:	ff 75 f4             	pushl  -0xc(%ebp)
  803ec5:	e8 72 fc ff ff       	call   803b3c <addToAvailMemBlocksList>
  803eca:	83 c4 10             	add    $0x10,%esp
					//Insert
					else {
						LIST_INSERT_BEFORE(&FreeMemBlocksList, iterator,
								blockToInsert);
					}
					break;
  803ecd:	e9 2e 01 00 00       	jmp    804000 <insert_sorted_with_merge_freeList+0x444>
						LIST_REMOVE(&FreeMemBlocksList, iterator);
						addToAvailMemBlocksList(blockToInsert);
						addToAvailMemBlocksList(iterator);
					}
					//previous merge
					else if (prev->sva + prev->size == blockToInsert->sva) {
  803ed2:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803ed5:	8b 50 08             	mov    0x8(%eax),%edx
  803ed8:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803edb:	8b 40 0c             	mov    0xc(%eax),%eax
  803ede:	01 c2                	add    %eax,%edx
  803ee0:	8b 45 08             	mov    0x8(%ebp),%eax
  803ee3:	8b 40 08             	mov    0x8(%eax),%eax
  803ee6:	39 c2                	cmp    %eax,%edx
  803ee8:	75 27                	jne    803f11 <insert_sorted_with_merge_freeList+0x355>
						prev->size = prev->size + blockToInsert->size;
  803eea:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803eed:	8b 50 0c             	mov    0xc(%eax),%edx
  803ef0:	8b 45 08             	mov    0x8(%ebp),%eax
  803ef3:	8b 40 0c             	mov    0xc(%eax),%eax
  803ef6:	01 c2                	add    %eax,%edx
  803ef8:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803efb:	89 50 0c             	mov    %edx,0xc(%eax)
						addToAvailMemBlocksList(blockToInsert);
  803efe:	83 ec 0c             	sub    $0xc,%esp
  803f01:	ff 75 08             	pushl  0x8(%ebp)
  803f04:	e8 33 fc ff ff       	call   803b3c <addToAvailMemBlocksList>
  803f09:	83 c4 10             	add    $0x10,%esp
					//Insert
					else {
						LIST_INSERT_BEFORE(&FreeMemBlocksList, iterator,
								blockToInsert);
					}
					break;
  803f0c:	e9 ef 00 00 00       	jmp    804000 <insert_sorted_with_merge_freeList+0x444>
					else if (prev->sva + prev->size == blockToInsert->sva) {
						prev->size = prev->size + blockToInsert->size;
						addToAvailMemBlocksList(blockToInsert);
					}
					//next merge
					else if (blockToInsert->size + blockToInsert->sva
  803f11:	8b 45 08             	mov    0x8(%ebp),%eax
  803f14:	8b 50 0c             	mov    0xc(%eax),%edx
  803f17:	8b 45 08             	mov    0x8(%ebp),%eax
  803f1a:	8b 40 08             	mov    0x8(%eax),%eax
  803f1d:	01 c2                	add    %eax,%edx
							== iterator->sva) {
  803f1f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803f22:	8b 40 08             	mov    0x8(%eax),%eax
					else if (prev->sva + prev->size == blockToInsert->sva) {
						prev->size = prev->size + blockToInsert->size;
						addToAvailMemBlocksList(blockToInsert);
					}
					//next merge
					else if (blockToInsert->size + blockToInsert->sva
  803f25:	39 c2                	cmp    %eax,%edx
  803f27:	75 33                	jne    803f5c <insert_sorted_with_merge_freeList+0x3a0>
							== iterator->sva) {
						iterator->sva = blockToInsert->sva;
  803f29:	8b 45 08             	mov    0x8(%ebp),%eax
  803f2c:	8b 50 08             	mov    0x8(%eax),%edx
  803f2f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803f32:	89 50 08             	mov    %edx,0x8(%eax)
						iterator->size = iterator->size + blockToInsert->size;
  803f35:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803f38:	8b 50 0c             	mov    0xc(%eax),%edx
  803f3b:	8b 45 08             	mov    0x8(%ebp),%eax
  803f3e:	8b 40 0c             	mov    0xc(%eax),%eax
  803f41:	01 c2                	add    %eax,%edx
  803f43:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803f46:	89 50 0c             	mov    %edx,0xc(%eax)
						addToAvailMemBlocksList(blockToInsert);
  803f49:	83 ec 0c             	sub    $0xc,%esp
  803f4c:	ff 75 08             	pushl  0x8(%ebp)
  803f4f:	e8 e8 fb ff ff       	call   803b3c <addToAvailMemBlocksList>
  803f54:	83 c4 10             	add    $0x10,%esp
					//Insert
					else {
						LIST_INSERT_BEFORE(&FreeMemBlocksList, iterator,
								blockToInsert);
					}
					break;
  803f57:	e9 a4 00 00 00       	jmp    804000 <insert_sorted_with_merge_freeList+0x444>
						iterator->size = iterator->size + blockToInsert->size;
						addToAvailMemBlocksList(blockToInsert);
					}
					//Insert
					else {
						LIST_INSERT_BEFORE(&FreeMemBlocksList, iterator,
  803f5c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803f60:	74 06                	je     803f68 <insert_sorted_with_merge_freeList+0x3ac>
  803f62:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803f66:	75 17                	jne    803f7f <insert_sorted_with_merge_freeList+0x3c3>
  803f68:	83 ec 04             	sub    $0x4,%esp
  803f6b:	68 e8 4e 80 00       	push   $0x804ee8
  803f70:	68 56 01 00 00       	push   $0x156
  803f75:	68 57 4e 80 00       	push   $0x804e57
  803f7a:	e8 aa d4 ff ff       	call   801429 <_panic>
  803f7f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803f82:	8b 50 04             	mov    0x4(%eax),%edx
  803f85:	8b 45 08             	mov    0x8(%ebp),%eax
  803f88:	89 50 04             	mov    %edx,0x4(%eax)
  803f8b:	8b 45 08             	mov    0x8(%ebp),%eax
  803f8e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803f91:	89 10                	mov    %edx,(%eax)
  803f93:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803f96:	8b 40 04             	mov    0x4(%eax),%eax
  803f99:	85 c0                	test   %eax,%eax
  803f9b:	74 0d                	je     803faa <insert_sorted_with_merge_freeList+0x3ee>
  803f9d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803fa0:	8b 40 04             	mov    0x4(%eax),%eax
  803fa3:	8b 55 08             	mov    0x8(%ebp),%edx
  803fa6:	89 10                	mov    %edx,(%eax)
  803fa8:	eb 08                	jmp    803fb2 <insert_sorted_with_merge_freeList+0x3f6>
  803faa:	8b 45 08             	mov    0x8(%ebp),%eax
  803fad:	a3 38 51 80 00       	mov    %eax,0x805138
  803fb2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803fb5:	8b 55 08             	mov    0x8(%ebp),%edx
  803fb8:	89 50 04             	mov    %edx,0x4(%eax)
  803fbb:	a1 44 51 80 00       	mov    0x805144,%eax
  803fc0:	40                   	inc    %eax
  803fc1:	a3 44 51 80 00       	mov    %eax,0x805144
								blockToInsert);
					}
					break;
  803fc6:	eb 38                	jmp    804000 <insert_sorted_with_merge_freeList+0x444>
		} else {
			LIST_INSERT_AFTER(&FreeMemBlocksList, last, blockToInsert);
		}
	} else {
		struct MemBlock *iterator;
		LIST_FOREACH(iterator, &(FreeMemBlocksList))
  803fc8:	a1 40 51 80 00       	mov    0x805140,%eax
  803fcd:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803fd0:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803fd4:	74 07                	je     803fdd <insert_sorted_with_merge_freeList+0x421>
  803fd6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803fd9:	8b 00                	mov    (%eax),%eax
  803fdb:	eb 05                	jmp    803fe2 <insert_sorted_with_merge_freeList+0x426>
  803fdd:	b8 00 00 00 00       	mov    $0x0,%eax
  803fe2:	a3 40 51 80 00       	mov    %eax,0x805140
  803fe7:	a1 40 51 80 00       	mov    0x805140,%eax
  803fec:	85 c0                	test   %eax,%eax
  803fee:	0f 85 1a fd ff ff    	jne    803d0e <insert_sorted_with_merge_freeList+0x152>
  803ff4:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803ff8:	0f 85 10 fd ff ff    	jne    803d0e <insert_sorted_with_merge_freeList+0x152>
		}
	}

	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  803ffe:	eb 00                	jmp    804000 <insert_sorted_with_merge_freeList+0x444>
  804000:	90                   	nop
  804001:	c9                   	leave  
  804002:	c3                   	ret    
  804003:	90                   	nop

00804004 <__udivdi3>:
  804004:	55                   	push   %ebp
  804005:	57                   	push   %edi
  804006:	56                   	push   %esi
  804007:	53                   	push   %ebx
  804008:	83 ec 1c             	sub    $0x1c,%esp
  80400b:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  80400f:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  804013:	8b 7c 24 38          	mov    0x38(%esp),%edi
  804017:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  80401b:	89 ca                	mov    %ecx,%edx
  80401d:	89 f8                	mov    %edi,%eax
  80401f:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  804023:	85 f6                	test   %esi,%esi
  804025:	75 2d                	jne    804054 <__udivdi3+0x50>
  804027:	39 cf                	cmp    %ecx,%edi
  804029:	77 65                	ja     804090 <__udivdi3+0x8c>
  80402b:	89 fd                	mov    %edi,%ebp
  80402d:	85 ff                	test   %edi,%edi
  80402f:	75 0b                	jne    80403c <__udivdi3+0x38>
  804031:	b8 01 00 00 00       	mov    $0x1,%eax
  804036:	31 d2                	xor    %edx,%edx
  804038:	f7 f7                	div    %edi
  80403a:	89 c5                	mov    %eax,%ebp
  80403c:	31 d2                	xor    %edx,%edx
  80403e:	89 c8                	mov    %ecx,%eax
  804040:	f7 f5                	div    %ebp
  804042:	89 c1                	mov    %eax,%ecx
  804044:	89 d8                	mov    %ebx,%eax
  804046:	f7 f5                	div    %ebp
  804048:	89 cf                	mov    %ecx,%edi
  80404a:	89 fa                	mov    %edi,%edx
  80404c:	83 c4 1c             	add    $0x1c,%esp
  80404f:	5b                   	pop    %ebx
  804050:	5e                   	pop    %esi
  804051:	5f                   	pop    %edi
  804052:	5d                   	pop    %ebp
  804053:	c3                   	ret    
  804054:	39 ce                	cmp    %ecx,%esi
  804056:	77 28                	ja     804080 <__udivdi3+0x7c>
  804058:	0f bd fe             	bsr    %esi,%edi
  80405b:	83 f7 1f             	xor    $0x1f,%edi
  80405e:	75 40                	jne    8040a0 <__udivdi3+0x9c>
  804060:	39 ce                	cmp    %ecx,%esi
  804062:	72 0a                	jb     80406e <__udivdi3+0x6a>
  804064:	3b 44 24 08          	cmp    0x8(%esp),%eax
  804068:	0f 87 9e 00 00 00    	ja     80410c <__udivdi3+0x108>
  80406e:	b8 01 00 00 00       	mov    $0x1,%eax
  804073:	89 fa                	mov    %edi,%edx
  804075:	83 c4 1c             	add    $0x1c,%esp
  804078:	5b                   	pop    %ebx
  804079:	5e                   	pop    %esi
  80407a:	5f                   	pop    %edi
  80407b:	5d                   	pop    %ebp
  80407c:	c3                   	ret    
  80407d:	8d 76 00             	lea    0x0(%esi),%esi
  804080:	31 ff                	xor    %edi,%edi
  804082:	31 c0                	xor    %eax,%eax
  804084:	89 fa                	mov    %edi,%edx
  804086:	83 c4 1c             	add    $0x1c,%esp
  804089:	5b                   	pop    %ebx
  80408a:	5e                   	pop    %esi
  80408b:	5f                   	pop    %edi
  80408c:	5d                   	pop    %ebp
  80408d:	c3                   	ret    
  80408e:	66 90                	xchg   %ax,%ax
  804090:	89 d8                	mov    %ebx,%eax
  804092:	f7 f7                	div    %edi
  804094:	31 ff                	xor    %edi,%edi
  804096:	89 fa                	mov    %edi,%edx
  804098:	83 c4 1c             	add    $0x1c,%esp
  80409b:	5b                   	pop    %ebx
  80409c:	5e                   	pop    %esi
  80409d:	5f                   	pop    %edi
  80409e:	5d                   	pop    %ebp
  80409f:	c3                   	ret    
  8040a0:	bd 20 00 00 00       	mov    $0x20,%ebp
  8040a5:	89 eb                	mov    %ebp,%ebx
  8040a7:	29 fb                	sub    %edi,%ebx
  8040a9:	89 f9                	mov    %edi,%ecx
  8040ab:	d3 e6                	shl    %cl,%esi
  8040ad:	89 c5                	mov    %eax,%ebp
  8040af:	88 d9                	mov    %bl,%cl
  8040b1:	d3 ed                	shr    %cl,%ebp
  8040b3:	89 e9                	mov    %ebp,%ecx
  8040b5:	09 f1                	or     %esi,%ecx
  8040b7:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  8040bb:	89 f9                	mov    %edi,%ecx
  8040bd:	d3 e0                	shl    %cl,%eax
  8040bf:	89 c5                	mov    %eax,%ebp
  8040c1:	89 d6                	mov    %edx,%esi
  8040c3:	88 d9                	mov    %bl,%cl
  8040c5:	d3 ee                	shr    %cl,%esi
  8040c7:	89 f9                	mov    %edi,%ecx
  8040c9:	d3 e2                	shl    %cl,%edx
  8040cb:	8b 44 24 08          	mov    0x8(%esp),%eax
  8040cf:	88 d9                	mov    %bl,%cl
  8040d1:	d3 e8                	shr    %cl,%eax
  8040d3:	09 c2                	or     %eax,%edx
  8040d5:	89 d0                	mov    %edx,%eax
  8040d7:	89 f2                	mov    %esi,%edx
  8040d9:	f7 74 24 0c          	divl   0xc(%esp)
  8040dd:	89 d6                	mov    %edx,%esi
  8040df:	89 c3                	mov    %eax,%ebx
  8040e1:	f7 e5                	mul    %ebp
  8040e3:	39 d6                	cmp    %edx,%esi
  8040e5:	72 19                	jb     804100 <__udivdi3+0xfc>
  8040e7:	74 0b                	je     8040f4 <__udivdi3+0xf0>
  8040e9:	89 d8                	mov    %ebx,%eax
  8040eb:	31 ff                	xor    %edi,%edi
  8040ed:	e9 58 ff ff ff       	jmp    80404a <__udivdi3+0x46>
  8040f2:	66 90                	xchg   %ax,%ax
  8040f4:	8b 54 24 08          	mov    0x8(%esp),%edx
  8040f8:	89 f9                	mov    %edi,%ecx
  8040fa:	d3 e2                	shl    %cl,%edx
  8040fc:	39 c2                	cmp    %eax,%edx
  8040fe:	73 e9                	jae    8040e9 <__udivdi3+0xe5>
  804100:	8d 43 ff             	lea    -0x1(%ebx),%eax
  804103:	31 ff                	xor    %edi,%edi
  804105:	e9 40 ff ff ff       	jmp    80404a <__udivdi3+0x46>
  80410a:	66 90                	xchg   %ax,%ax
  80410c:	31 c0                	xor    %eax,%eax
  80410e:	e9 37 ff ff ff       	jmp    80404a <__udivdi3+0x46>
  804113:	90                   	nop

00804114 <__umoddi3>:
  804114:	55                   	push   %ebp
  804115:	57                   	push   %edi
  804116:	56                   	push   %esi
  804117:	53                   	push   %ebx
  804118:	83 ec 1c             	sub    $0x1c,%esp
  80411b:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  80411f:	8b 74 24 34          	mov    0x34(%esp),%esi
  804123:	8b 7c 24 38          	mov    0x38(%esp),%edi
  804127:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  80412b:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80412f:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  804133:	89 f3                	mov    %esi,%ebx
  804135:	89 fa                	mov    %edi,%edx
  804137:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  80413b:	89 34 24             	mov    %esi,(%esp)
  80413e:	85 c0                	test   %eax,%eax
  804140:	75 1a                	jne    80415c <__umoddi3+0x48>
  804142:	39 f7                	cmp    %esi,%edi
  804144:	0f 86 a2 00 00 00    	jbe    8041ec <__umoddi3+0xd8>
  80414a:	89 c8                	mov    %ecx,%eax
  80414c:	89 f2                	mov    %esi,%edx
  80414e:	f7 f7                	div    %edi
  804150:	89 d0                	mov    %edx,%eax
  804152:	31 d2                	xor    %edx,%edx
  804154:	83 c4 1c             	add    $0x1c,%esp
  804157:	5b                   	pop    %ebx
  804158:	5e                   	pop    %esi
  804159:	5f                   	pop    %edi
  80415a:	5d                   	pop    %ebp
  80415b:	c3                   	ret    
  80415c:	39 f0                	cmp    %esi,%eax
  80415e:	0f 87 ac 00 00 00    	ja     804210 <__umoddi3+0xfc>
  804164:	0f bd e8             	bsr    %eax,%ebp
  804167:	83 f5 1f             	xor    $0x1f,%ebp
  80416a:	0f 84 ac 00 00 00    	je     80421c <__umoddi3+0x108>
  804170:	bf 20 00 00 00       	mov    $0x20,%edi
  804175:	29 ef                	sub    %ebp,%edi
  804177:	89 fe                	mov    %edi,%esi
  804179:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  80417d:	89 e9                	mov    %ebp,%ecx
  80417f:	d3 e0                	shl    %cl,%eax
  804181:	89 d7                	mov    %edx,%edi
  804183:	89 f1                	mov    %esi,%ecx
  804185:	d3 ef                	shr    %cl,%edi
  804187:	09 c7                	or     %eax,%edi
  804189:	89 e9                	mov    %ebp,%ecx
  80418b:	d3 e2                	shl    %cl,%edx
  80418d:	89 14 24             	mov    %edx,(%esp)
  804190:	89 d8                	mov    %ebx,%eax
  804192:	d3 e0                	shl    %cl,%eax
  804194:	89 c2                	mov    %eax,%edx
  804196:	8b 44 24 08          	mov    0x8(%esp),%eax
  80419a:	d3 e0                	shl    %cl,%eax
  80419c:	89 44 24 04          	mov    %eax,0x4(%esp)
  8041a0:	8b 44 24 08          	mov    0x8(%esp),%eax
  8041a4:	89 f1                	mov    %esi,%ecx
  8041a6:	d3 e8                	shr    %cl,%eax
  8041a8:	09 d0                	or     %edx,%eax
  8041aa:	d3 eb                	shr    %cl,%ebx
  8041ac:	89 da                	mov    %ebx,%edx
  8041ae:	f7 f7                	div    %edi
  8041b0:	89 d3                	mov    %edx,%ebx
  8041b2:	f7 24 24             	mull   (%esp)
  8041b5:	89 c6                	mov    %eax,%esi
  8041b7:	89 d1                	mov    %edx,%ecx
  8041b9:	39 d3                	cmp    %edx,%ebx
  8041bb:	0f 82 87 00 00 00    	jb     804248 <__umoddi3+0x134>
  8041c1:	0f 84 91 00 00 00    	je     804258 <__umoddi3+0x144>
  8041c7:	8b 54 24 04          	mov    0x4(%esp),%edx
  8041cb:	29 f2                	sub    %esi,%edx
  8041cd:	19 cb                	sbb    %ecx,%ebx
  8041cf:	89 d8                	mov    %ebx,%eax
  8041d1:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  8041d5:	d3 e0                	shl    %cl,%eax
  8041d7:	89 e9                	mov    %ebp,%ecx
  8041d9:	d3 ea                	shr    %cl,%edx
  8041db:	09 d0                	or     %edx,%eax
  8041dd:	89 e9                	mov    %ebp,%ecx
  8041df:	d3 eb                	shr    %cl,%ebx
  8041e1:	89 da                	mov    %ebx,%edx
  8041e3:	83 c4 1c             	add    $0x1c,%esp
  8041e6:	5b                   	pop    %ebx
  8041e7:	5e                   	pop    %esi
  8041e8:	5f                   	pop    %edi
  8041e9:	5d                   	pop    %ebp
  8041ea:	c3                   	ret    
  8041eb:	90                   	nop
  8041ec:	89 fd                	mov    %edi,%ebp
  8041ee:	85 ff                	test   %edi,%edi
  8041f0:	75 0b                	jne    8041fd <__umoddi3+0xe9>
  8041f2:	b8 01 00 00 00       	mov    $0x1,%eax
  8041f7:	31 d2                	xor    %edx,%edx
  8041f9:	f7 f7                	div    %edi
  8041fb:	89 c5                	mov    %eax,%ebp
  8041fd:	89 f0                	mov    %esi,%eax
  8041ff:	31 d2                	xor    %edx,%edx
  804201:	f7 f5                	div    %ebp
  804203:	89 c8                	mov    %ecx,%eax
  804205:	f7 f5                	div    %ebp
  804207:	89 d0                	mov    %edx,%eax
  804209:	e9 44 ff ff ff       	jmp    804152 <__umoddi3+0x3e>
  80420e:	66 90                	xchg   %ax,%ax
  804210:	89 c8                	mov    %ecx,%eax
  804212:	89 f2                	mov    %esi,%edx
  804214:	83 c4 1c             	add    $0x1c,%esp
  804217:	5b                   	pop    %ebx
  804218:	5e                   	pop    %esi
  804219:	5f                   	pop    %edi
  80421a:	5d                   	pop    %ebp
  80421b:	c3                   	ret    
  80421c:	3b 04 24             	cmp    (%esp),%eax
  80421f:	72 06                	jb     804227 <__umoddi3+0x113>
  804221:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  804225:	77 0f                	ja     804236 <__umoddi3+0x122>
  804227:	89 f2                	mov    %esi,%edx
  804229:	29 f9                	sub    %edi,%ecx
  80422b:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  80422f:	89 14 24             	mov    %edx,(%esp)
  804232:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  804236:	8b 44 24 04          	mov    0x4(%esp),%eax
  80423a:	8b 14 24             	mov    (%esp),%edx
  80423d:	83 c4 1c             	add    $0x1c,%esp
  804240:	5b                   	pop    %ebx
  804241:	5e                   	pop    %esi
  804242:	5f                   	pop    %edi
  804243:	5d                   	pop    %ebp
  804244:	c3                   	ret    
  804245:	8d 76 00             	lea    0x0(%esi),%esi
  804248:	2b 04 24             	sub    (%esp),%eax
  80424b:	19 fa                	sbb    %edi,%edx
  80424d:	89 d1                	mov    %edx,%ecx
  80424f:	89 c6                	mov    %eax,%esi
  804251:	e9 71 ff ff ff       	jmp    8041c7 <__umoddi3+0xb3>
  804256:	66 90                	xchg   %ax,%ax
  804258:	39 44 24 04          	cmp    %eax,0x4(%esp)
  80425c:	72 ea                	jb     804248 <__umoddi3+0x134>
  80425e:	89 d9                	mov    %ebx,%ecx
  804260:	e9 62 ff ff ff       	jmp    8041c7 <__umoddi3+0xb3>
