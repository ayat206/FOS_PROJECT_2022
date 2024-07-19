
obj/user/tst_realloc_1:     file format elf32-i386


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
  800031:	e8 38 11 00 00       	call   80116e <libmain>
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
  800040:	c7 45 f0 00 00 10 00 	movl   $0x100000,-0x10(%ebp)
	int kilo = 1024;
  800047:	c7 45 ec 00 04 00 00 	movl   $0x400,-0x14(%ebp)
	void* ptr_allocations[20] = {0};
  80004e:	8d 55 80             	lea    -0x80(%ebp),%edx
  800051:	b9 14 00 00 00       	mov    $0x14,%ecx
  800056:	b8 00 00 00 00       	mov    $0x0,%eax
  80005b:	89 d7                	mov    %edx,%edi
  80005d:	f3 ab                	rep stos %eax,%es:(%edi)
	int freeFrames ;
	int usedDiskPages;
	cprintf("realloc: current evaluation = 00%");
  80005f:	83 ec 0c             	sub    $0xc,%esp
  800062:	68 00 41 80 00       	push   $0x804100
  800067:	e8 f2 14 00 00       	call   80155e <cprintf>
  80006c:	83 c4 10             	add    $0x10,%esp
	//[1] Allocate all
	{
		//Allocate 1 MB
		freeFrames = sys_calculate_free_frames() ;
  80006f:	e8 88 28 00 00       	call   8028fc <sys_calculate_free_frames>
  800074:	89 45 e8             	mov    %eax,-0x18(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  800077:	e8 20 29 00 00       	call   80299c <sys_pf_calculate_allocated_pages>
  80007c:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		ptr_allocations[0] = malloc(1*Mega-kilo);
  80007f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800082:	2b 45 ec             	sub    -0x14(%ebp),%eax
  800085:	83 ec 0c             	sub    $0xc,%esp
  800088:	50                   	push   %eax
  800089:	e8 62 24 00 00       	call   8024f0 <malloc>
  80008e:	83 c4 10             	add    $0x10,%esp
  800091:	89 45 80             	mov    %eax,-0x80(%ebp)
		if ((uint32) ptr_allocations[0] != (USER_HEAP_START)) panic("Wrong start address for the allocated space... ");
  800094:	8b 45 80             	mov    -0x80(%ebp),%eax
  800097:	3d 00 00 00 80       	cmp    $0x80000000,%eax
  80009c:	74 14                	je     8000b2 <_main+0x7a>
  80009e:	83 ec 04             	sub    $0x4,%esp
  8000a1:	68 24 41 80 00       	push   $0x804124
  8000a6:	6a 11                	push   $0x11
  8000a8:	68 54 41 80 00       	push   $0x804154
  8000ad:	e8 f8 11 00 00       	call   8012aa <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 256+1 ) panic("Wrong allocation: ");
		if ((freeFrames - sys_calculate_free_frames()) != 1 ) panic("Wrong allocation: either extra pages are allocated in memory or pages not allocated correctly on PageFile");
  8000b2:	8b 5d e8             	mov    -0x18(%ebp),%ebx
  8000b5:	e8 42 28 00 00       	call   8028fc <sys_calculate_free_frames>
  8000ba:	29 c3                	sub    %eax,%ebx
  8000bc:	89 d8                	mov    %ebx,%eax
  8000be:	83 f8 01             	cmp    $0x1,%eax
  8000c1:	74 14                	je     8000d7 <_main+0x9f>
  8000c3:	83 ec 04             	sub    $0x4,%esp
  8000c6:	68 6c 41 80 00       	push   $0x80416c
  8000cb:	6a 13                	push   $0x13
  8000cd:	68 54 41 80 00       	push   $0x804154
  8000d2:	e8 d3 11 00 00       	call   8012aa <_panic>
		if((sys_pf_calculate_allocated_pages() - usedDiskPages) != 256)panic("Extra or less pages are allocated in PageFile");
  8000d7:	e8 c0 28 00 00       	call   80299c <sys_pf_calculate_allocated_pages>
  8000dc:	2b 45 e4             	sub    -0x1c(%ebp),%eax
  8000df:	3d 00 01 00 00       	cmp    $0x100,%eax
  8000e4:	74 14                	je     8000fa <_main+0xc2>
  8000e6:	83 ec 04             	sub    $0x4,%esp
  8000e9:	68 d8 41 80 00       	push   $0x8041d8
  8000ee:	6a 14                	push   $0x14
  8000f0:	68 54 41 80 00       	push   $0x804154
  8000f5:	e8 b0 11 00 00       	call   8012aa <_panic>
		//Allocate 1 MB
		freeFrames = sys_calculate_free_frames() ;
  8000fa:	e8 fd 27 00 00       	call   8028fc <sys_calculate_free_frames>
  8000ff:	89 45 e8             	mov    %eax,-0x18(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  800102:	e8 95 28 00 00       	call   80299c <sys_pf_calculate_allocated_pages>
  800107:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		ptr_allocations[1] = malloc(1*Mega-kilo);
  80010a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80010d:	2b 45 ec             	sub    -0x14(%ebp),%eax
  800110:	83 ec 0c             	sub    $0xc,%esp
  800113:	50                   	push   %eax
  800114:	e8 d7 23 00 00       	call   8024f0 <malloc>
  800119:	83 c4 10             	add    $0x10,%esp
  80011c:	89 45 84             	mov    %eax,-0x7c(%ebp)
		if ((uint32) ptr_allocations[1] !=  (USER_HEAP_START + 1*Mega)) panic("Wrong start address for the allocated space... ");
  80011f:	8b 45 84             	mov    -0x7c(%ebp),%eax
  800122:	89 c2                	mov    %eax,%edx
  800124:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800127:	05 00 00 00 80       	add    $0x80000000,%eax
  80012c:	39 c2                	cmp    %eax,%edx
  80012e:	74 14                	je     800144 <_main+0x10c>
  800130:	83 ec 04             	sub    $0x4,%esp
  800133:	68 24 41 80 00       	push   $0x804124
  800138:	6a 19                	push   $0x19
  80013a:	68 54 41 80 00       	push   $0x804154
  80013f:	e8 66 11 00 00       	call   8012aa <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 256 ) panic("Wrong allocation: ");
		if((freeFrames - sys_calculate_free_frames()) != 0) panic("Wrong allocation: either extra pages are allocated in memory or pages not allocated correctly on PageFile");
  800144:	e8 b3 27 00 00       	call   8028fc <sys_calculate_free_frames>
  800149:	89 c2                	mov    %eax,%edx
  80014b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80014e:	39 c2                	cmp    %eax,%edx
  800150:	74 14                	je     800166 <_main+0x12e>
  800152:	83 ec 04             	sub    $0x4,%esp
  800155:	68 6c 41 80 00       	push   $0x80416c
  80015a:	6a 1b                	push   $0x1b
  80015c:	68 54 41 80 00       	push   $0x804154
  800161:	e8 44 11 00 00       	call   8012aa <_panic>
		if((sys_pf_calculate_allocated_pages() - usedDiskPages) != 256) panic("Extra or less pages are allocated in PageFile");
  800166:	e8 31 28 00 00       	call   80299c <sys_pf_calculate_allocated_pages>
  80016b:	2b 45 e4             	sub    -0x1c(%ebp),%eax
  80016e:	3d 00 01 00 00       	cmp    $0x100,%eax
  800173:	74 14                	je     800189 <_main+0x151>
  800175:	83 ec 04             	sub    $0x4,%esp
  800178:	68 d8 41 80 00       	push   $0x8041d8
  80017d:	6a 1c                	push   $0x1c
  80017f:	68 54 41 80 00       	push   $0x804154
  800184:	e8 21 11 00 00       	call   8012aa <_panic>
		//Allocate 1 MB
		freeFrames = sys_calculate_free_frames() ;
  800189:	e8 6e 27 00 00       	call   8028fc <sys_calculate_free_frames>
  80018e:	89 45 e8             	mov    %eax,-0x18(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  800191:	e8 06 28 00 00       	call   80299c <sys_pf_calculate_allocated_pages>
  800196:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		ptr_allocations[2] = malloc(1*Mega-kilo);
  800199:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80019c:	2b 45 ec             	sub    -0x14(%ebp),%eax
  80019f:	83 ec 0c             	sub    $0xc,%esp
  8001a2:	50                   	push   %eax
  8001a3:	e8 48 23 00 00       	call   8024f0 <malloc>
  8001a8:	83 c4 10             	add    $0x10,%esp
  8001ab:	89 45 88             	mov    %eax,-0x78(%ebp)
		if ((uint32) ptr_allocations[2] !=  (USER_HEAP_START + 2*Mega)) panic("Wrong start address for the allocated space... ");
  8001ae:	8b 45 88             	mov    -0x78(%ebp),%eax
  8001b1:	89 c2                	mov    %eax,%edx
  8001b3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8001b6:	01 c0                	add    %eax,%eax
  8001b8:	05 00 00 00 80       	add    $0x80000000,%eax
  8001bd:	39 c2                	cmp    %eax,%edx
  8001bf:	74 14                	je     8001d5 <_main+0x19d>
  8001c1:	83 ec 04             	sub    $0x4,%esp
  8001c4:	68 24 41 80 00       	push   $0x804124
  8001c9:	6a 21                	push   $0x21
  8001cb:	68 54 41 80 00       	push   $0x804154
  8001d0:	e8 d5 10 00 00       	call   8012aa <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 256 ) panic("Wrong allocation: ");
		if((freeFrames - sys_calculate_free_frames()) != 0) panic("Wrong allocation: either extra pages are allocated in memory or pages not allocated correctly on PageFile");
  8001d5:	e8 22 27 00 00       	call   8028fc <sys_calculate_free_frames>
  8001da:	89 c2                	mov    %eax,%edx
  8001dc:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8001df:	39 c2                	cmp    %eax,%edx
  8001e1:	74 14                	je     8001f7 <_main+0x1bf>
  8001e3:	83 ec 04             	sub    $0x4,%esp
  8001e6:	68 6c 41 80 00       	push   $0x80416c
  8001eb:	6a 23                	push   $0x23
  8001ed:	68 54 41 80 00       	push   $0x804154
  8001f2:	e8 b3 10 00 00       	call   8012aa <_panic>
		if((sys_pf_calculate_allocated_pages() - usedDiskPages) != 256) panic("Extra or less pages are allocated in PageFile");
  8001f7:	e8 a0 27 00 00       	call   80299c <sys_pf_calculate_allocated_pages>
  8001fc:	2b 45 e4             	sub    -0x1c(%ebp),%eax
  8001ff:	3d 00 01 00 00       	cmp    $0x100,%eax
  800204:	74 14                	je     80021a <_main+0x1e2>
  800206:	83 ec 04             	sub    $0x4,%esp
  800209:	68 d8 41 80 00       	push   $0x8041d8
  80020e:	6a 24                	push   $0x24
  800210:	68 54 41 80 00       	push   $0x804154
  800215:	e8 90 10 00 00       	call   8012aa <_panic>

		//Allocate 1 MB
		freeFrames = sys_calculate_free_frames() ;
  80021a:	e8 dd 26 00 00       	call   8028fc <sys_calculate_free_frames>
  80021f:	89 45 e8             	mov    %eax,-0x18(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  800222:	e8 75 27 00 00       	call   80299c <sys_pf_calculate_allocated_pages>
  800227:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		ptr_allocations[3] = malloc(1*Mega-kilo);
  80022a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80022d:	2b 45 ec             	sub    -0x14(%ebp),%eax
  800230:	83 ec 0c             	sub    $0xc,%esp
  800233:	50                   	push   %eax
  800234:	e8 b7 22 00 00       	call   8024f0 <malloc>
  800239:	83 c4 10             	add    $0x10,%esp
  80023c:	89 45 8c             	mov    %eax,-0x74(%ebp)
		if ((uint32) ptr_allocations[3] !=  (USER_HEAP_START + 3*Mega)) panic("Wrong start address for the allocated space... ");
  80023f:	8b 45 8c             	mov    -0x74(%ebp),%eax
  800242:	89 c1                	mov    %eax,%ecx
  800244:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800247:	89 c2                	mov    %eax,%edx
  800249:	01 d2                	add    %edx,%edx
  80024b:	01 d0                	add    %edx,%eax
  80024d:	05 00 00 00 80       	add    $0x80000000,%eax
  800252:	39 c1                	cmp    %eax,%ecx
  800254:	74 14                	je     80026a <_main+0x232>
  800256:	83 ec 04             	sub    $0x4,%esp
  800259:	68 24 41 80 00       	push   $0x804124
  80025e:	6a 2a                	push   $0x2a
  800260:	68 54 41 80 00       	push   $0x804154
  800265:	e8 40 10 00 00       	call   8012aa <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 256 ) panic("Wrong allocation: ");
		if((freeFrames - sys_calculate_free_frames()) != 0) panic("Wrong allocation: either extra pages are allocated in memory or pages not allocated correctly on PageFile");
  80026a:	e8 8d 26 00 00       	call   8028fc <sys_calculate_free_frames>
  80026f:	89 c2                	mov    %eax,%edx
  800271:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800274:	39 c2                	cmp    %eax,%edx
  800276:	74 14                	je     80028c <_main+0x254>
  800278:	83 ec 04             	sub    $0x4,%esp
  80027b:	68 6c 41 80 00       	push   $0x80416c
  800280:	6a 2c                	push   $0x2c
  800282:	68 54 41 80 00       	push   $0x804154
  800287:	e8 1e 10 00 00       	call   8012aa <_panic>
		if((sys_pf_calculate_allocated_pages() - usedDiskPages) != 256) panic("Extra or less pages are allocated in PageFile");
  80028c:	e8 0b 27 00 00       	call   80299c <sys_pf_calculate_allocated_pages>
  800291:	2b 45 e4             	sub    -0x1c(%ebp),%eax
  800294:	3d 00 01 00 00       	cmp    $0x100,%eax
  800299:	74 14                	je     8002af <_main+0x277>
  80029b:	83 ec 04             	sub    $0x4,%esp
  80029e:	68 d8 41 80 00       	push   $0x8041d8
  8002a3:	6a 2d                	push   $0x2d
  8002a5:	68 54 41 80 00       	push   $0x804154
  8002aa:	e8 fb 0f 00 00       	call   8012aa <_panic>

		//Allocate 2 MB
		freeFrames = sys_calculate_free_frames() ;
  8002af:	e8 48 26 00 00       	call   8028fc <sys_calculate_free_frames>
  8002b4:	89 45 e8             	mov    %eax,-0x18(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  8002b7:	e8 e0 26 00 00       	call   80299c <sys_pf_calculate_allocated_pages>
  8002bc:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		ptr_allocations[4] = malloc(2*Mega-kilo);
  8002bf:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8002c2:	01 c0                	add    %eax,%eax
  8002c4:	2b 45 ec             	sub    -0x14(%ebp),%eax
  8002c7:	83 ec 0c             	sub    $0xc,%esp
  8002ca:	50                   	push   %eax
  8002cb:	e8 20 22 00 00       	call   8024f0 <malloc>
  8002d0:	83 c4 10             	add    $0x10,%esp
  8002d3:	89 45 90             	mov    %eax,-0x70(%ebp)
		if ((uint32) ptr_allocations[4] !=  (USER_HEAP_START + 4*Mega)) panic("Wrong start address for the allocated space... ");
  8002d6:	8b 45 90             	mov    -0x70(%ebp),%eax
  8002d9:	89 c2                	mov    %eax,%edx
  8002db:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8002de:	c1 e0 02             	shl    $0x2,%eax
  8002e1:	05 00 00 00 80       	add    $0x80000000,%eax
  8002e6:	39 c2                	cmp    %eax,%edx
  8002e8:	74 14                	je     8002fe <_main+0x2c6>
  8002ea:	83 ec 04             	sub    $0x4,%esp
  8002ed:	68 24 41 80 00       	push   $0x804124
  8002f2:	6a 33                	push   $0x33
  8002f4:	68 54 41 80 00       	push   $0x804154
  8002f9:	e8 ac 0f 00 00       	call   8012aa <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 512 + 1) panic("Wrong allocation: ");
		if((freeFrames - sys_calculate_free_frames()) != 1) panic("Wrong allocation: either extra pages are allocated in memory or pages not allocated correctly on PageFile");
  8002fe:	8b 5d e8             	mov    -0x18(%ebp),%ebx
  800301:	e8 f6 25 00 00       	call   8028fc <sys_calculate_free_frames>
  800306:	29 c3                	sub    %eax,%ebx
  800308:	89 d8                	mov    %ebx,%eax
  80030a:	83 f8 01             	cmp    $0x1,%eax
  80030d:	74 14                	je     800323 <_main+0x2eb>
  80030f:	83 ec 04             	sub    $0x4,%esp
  800312:	68 6c 41 80 00       	push   $0x80416c
  800317:	6a 35                	push   $0x35
  800319:	68 54 41 80 00       	push   $0x804154
  80031e:	e8 87 0f 00 00       	call   8012aa <_panic>
		if((sys_pf_calculate_allocated_pages() - usedDiskPages) != 512) panic("Extra or less pages are allocated in PageFile");
  800323:	e8 74 26 00 00       	call   80299c <sys_pf_calculate_allocated_pages>
  800328:	2b 45 e4             	sub    -0x1c(%ebp),%eax
  80032b:	3d 00 02 00 00       	cmp    $0x200,%eax
  800330:	74 14                	je     800346 <_main+0x30e>
  800332:	83 ec 04             	sub    $0x4,%esp
  800335:	68 d8 41 80 00       	push   $0x8041d8
  80033a:	6a 36                	push   $0x36
  80033c:	68 54 41 80 00       	push   $0x804154
  800341:	e8 64 0f 00 00       	call   8012aa <_panic>

		//Allocate 2 MB
		freeFrames = sys_calculate_free_frames() ;
  800346:	e8 b1 25 00 00       	call   8028fc <sys_calculate_free_frames>
  80034b:	89 45 e8             	mov    %eax,-0x18(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  80034e:	e8 49 26 00 00       	call   80299c <sys_pf_calculate_allocated_pages>
  800353:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		ptr_allocations[5] = malloc(2*Mega-kilo);
  800356:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800359:	01 c0                	add    %eax,%eax
  80035b:	2b 45 ec             	sub    -0x14(%ebp),%eax
  80035e:	83 ec 0c             	sub    $0xc,%esp
  800361:	50                   	push   %eax
  800362:	e8 89 21 00 00       	call   8024f0 <malloc>
  800367:	83 c4 10             	add    $0x10,%esp
  80036a:	89 45 94             	mov    %eax,-0x6c(%ebp)
		if ((uint32) ptr_allocations[5] !=  (USER_HEAP_START + 6*Mega)) panic("Wrong start address for the allocated space... ");
  80036d:	8b 45 94             	mov    -0x6c(%ebp),%eax
  800370:	89 c1                	mov    %eax,%ecx
  800372:	8b 55 f0             	mov    -0x10(%ebp),%edx
  800375:	89 d0                	mov    %edx,%eax
  800377:	01 c0                	add    %eax,%eax
  800379:	01 d0                	add    %edx,%eax
  80037b:	01 c0                	add    %eax,%eax
  80037d:	05 00 00 00 80       	add    $0x80000000,%eax
  800382:	39 c1                	cmp    %eax,%ecx
  800384:	74 14                	je     80039a <_main+0x362>
  800386:	83 ec 04             	sub    $0x4,%esp
  800389:	68 24 41 80 00       	push   $0x804124
  80038e:	6a 3c                	push   $0x3c
  800390:	68 54 41 80 00       	push   $0x804154
  800395:	e8 10 0f 00 00       	call   8012aa <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 512) panic("Wrong allocation: ");
		if((freeFrames - sys_calculate_free_frames()) != 0) panic("Wrong allocation: either extra pages are allocated in memory or pages not allocated correctly on PageFile");
  80039a:	e8 5d 25 00 00       	call   8028fc <sys_calculate_free_frames>
  80039f:	89 c2                	mov    %eax,%edx
  8003a1:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8003a4:	39 c2                	cmp    %eax,%edx
  8003a6:	74 14                	je     8003bc <_main+0x384>
  8003a8:	83 ec 04             	sub    $0x4,%esp
  8003ab:	68 6c 41 80 00       	push   $0x80416c
  8003b0:	6a 3e                	push   $0x3e
  8003b2:	68 54 41 80 00       	push   $0x804154
  8003b7:	e8 ee 0e 00 00       	call   8012aa <_panic>
		if((sys_pf_calculate_allocated_pages() - usedDiskPages) != 512) panic("Extra or less pages are allocated in PageFile");
  8003bc:	e8 db 25 00 00       	call   80299c <sys_pf_calculate_allocated_pages>
  8003c1:	2b 45 e4             	sub    -0x1c(%ebp),%eax
  8003c4:	3d 00 02 00 00       	cmp    $0x200,%eax
  8003c9:	74 14                	je     8003df <_main+0x3a7>
  8003cb:	83 ec 04             	sub    $0x4,%esp
  8003ce:	68 d8 41 80 00       	push   $0x8041d8
  8003d3:	6a 3f                	push   $0x3f
  8003d5:	68 54 41 80 00       	push   $0x804154
  8003da:	e8 cb 0e 00 00       	call   8012aa <_panic>

		//Allocate 3 MB
		freeFrames = sys_calculate_free_frames() ;
  8003df:	e8 18 25 00 00       	call   8028fc <sys_calculate_free_frames>
  8003e4:	89 45 e8             	mov    %eax,-0x18(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  8003e7:	e8 b0 25 00 00       	call   80299c <sys_pf_calculate_allocated_pages>
  8003ec:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		ptr_allocations[6] = malloc(3*Mega-kilo);
  8003ef:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8003f2:	89 c2                	mov    %eax,%edx
  8003f4:	01 d2                	add    %edx,%edx
  8003f6:	01 d0                	add    %edx,%eax
  8003f8:	2b 45 ec             	sub    -0x14(%ebp),%eax
  8003fb:	83 ec 0c             	sub    $0xc,%esp
  8003fe:	50                   	push   %eax
  8003ff:	e8 ec 20 00 00       	call   8024f0 <malloc>
  800404:	83 c4 10             	add    $0x10,%esp
  800407:	89 45 98             	mov    %eax,-0x68(%ebp)
		if ((uint32) ptr_allocations[6] !=  (USER_HEAP_START + 8*Mega)) panic("Wrong start address for the allocated space... ");
  80040a:	8b 45 98             	mov    -0x68(%ebp),%eax
  80040d:	89 c2                	mov    %eax,%edx
  80040f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800412:	c1 e0 03             	shl    $0x3,%eax
  800415:	05 00 00 00 80       	add    $0x80000000,%eax
  80041a:	39 c2                	cmp    %eax,%edx
  80041c:	74 14                	je     800432 <_main+0x3fa>
  80041e:	83 ec 04             	sub    $0x4,%esp
  800421:	68 24 41 80 00       	push   $0x804124
  800426:	6a 45                	push   $0x45
  800428:	68 54 41 80 00       	push   $0x804154
  80042d:	e8 78 0e 00 00       	call   8012aa <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 768 + 1) panic("Wrong allocation: ");
		if((freeFrames - sys_calculate_free_frames()) != 1) panic("Wrong allocation: either extra pages are allocated in memory or pages not allocated correctly on PageFile");
  800432:	8b 5d e8             	mov    -0x18(%ebp),%ebx
  800435:	e8 c2 24 00 00       	call   8028fc <sys_calculate_free_frames>
  80043a:	29 c3                	sub    %eax,%ebx
  80043c:	89 d8                	mov    %ebx,%eax
  80043e:	83 f8 01             	cmp    $0x1,%eax
  800441:	74 14                	je     800457 <_main+0x41f>
  800443:	83 ec 04             	sub    $0x4,%esp
  800446:	68 6c 41 80 00       	push   $0x80416c
  80044b:	6a 47                	push   $0x47
  80044d:	68 54 41 80 00       	push   $0x804154
  800452:	e8 53 0e 00 00       	call   8012aa <_panic>
		if((sys_pf_calculate_allocated_pages() - usedDiskPages) != 768) panic("Extra or less pages are allocated in PageFile");
  800457:	e8 40 25 00 00       	call   80299c <sys_pf_calculate_allocated_pages>
  80045c:	2b 45 e4             	sub    -0x1c(%ebp),%eax
  80045f:	3d 00 03 00 00       	cmp    $0x300,%eax
  800464:	74 14                	je     80047a <_main+0x442>
  800466:	83 ec 04             	sub    $0x4,%esp
  800469:	68 d8 41 80 00       	push   $0x8041d8
  80046e:	6a 48                	push   $0x48
  800470:	68 54 41 80 00       	push   $0x804154
  800475:	e8 30 0e 00 00       	call   8012aa <_panic>

		//Allocate 3 MB
		freeFrames = sys_calculate_free_frames() ;
  80047a:	e8 7d 24 00 00       	call   8028fc <sys_calculate_free_frames>
  80047f:	89 45 e8             	mov    %eax,-0x18(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  800482:	e8 15 25 00 00       	call   80299c <sys_pf_calculate_allocated_pages>
  800487:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		ptr_allocations[7] = malloc(3*Mega-kilo);
  80048a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80048d:	89 c2                	mov    %eax,%edx
  80048f:	01 d2                	add    %edx,%edx
  800491:	01 d0                	add    %edx,%eax
  800493:	2b 45 ec             	sub    -0x14(%ebp),%eax
  800496:	83 ec 0c             	sub    $0xc,%esp
  800499:	50                   	push   %eax
  80049a:	e8 51 20 00 00       	call   8024f0 <malloc>
  80049f:	83 c4 10             	add    $0x10,%esp
  8004a2:	89 45 9c             	mov    %eax,-0x64(%ebp)
		if ((uint32) ptr_allocations[7] !=  (USER_HEAP_START + 11*Mega)) panic("Wrong start address for the allocated space... ");
  8004a5:	8b 45 9c             	mov    -0x64(%ebp),%eax
  8004a8:	89 c1                	mov    %eax,%ecx
  8004aa:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8004ad:	89 d0                	mov    %edx,%eax
  8004af:	c1 e0 02             	shl    $0x2,%eax
  8004b2:	01 d0                	add    %edx,%eax
  8004b4:	01 c0                	add    %eax,%eax
  8004b6:	01 d0                	add    %edx,%eax
  8004b8:	05 00 00 00 80       	add    $0x80000000,%eax
  8004bd:	39 c1                	cmp    %eax,%ecx
  8004bf:	74 14                	je     8004d5 <_main+0x49d>
  8004c1:	83 ec 04             	sub    $0x4,%esp
  8004c4:	68 24 41 80 00       	push   $0x804124
  8004c9:	6a 4e                	push   $0x4e
  8004cb:	68 54 41 80 00       	push   $0x804154
  8004d0:	e8 d5 0d 00 00       	call   8012aa <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 768 + 1) panic("Wrong allocation: ");
		if((freeFrames - sys_calculate_free_frames()) != 1) panic("Wrong allocation: either extra pages are allocated in memory or pages not allocated correctly on PageFile");
  8004d5:	8b 5d e8             	mov    -0x18(%ebp),%ebx
  8004d8:	e8 1f 24 00 00       	call   8028fc <sys_calculate_free_frames>
  8004dd:	29 c3                	sub    %eax,%ebx
  8004df:	89 d8                	mov    %ebx,%eax
  8004e1:	83 f8 01             	cmp    $0x1,%eax
  8004e4:	74 14                	je     8004fa <_main+0x4c2>
  8004e6:	83 ec 04             	sub    $0x4,%esp
  8004e9:	68 6c 41 80 00       	push   $0x80416c
  8004ee:	6a 50                	push   $0x50
  8004f0:	68 54 41 80 00       	push   $0x804154
  8004f5:	e8 b0 0d 00 00       	call   8012aa <_panic>
		if((sys_pf_calculate_allocated_pages() - usedDiskPages) != 768) panic("Extra or less pages are allocated in PageFile");
  8004fa:	e8 9d 24 00 00       	call   80299c <sys_pf_calculate_allocated_pages>
  8004ff:	2b 45 e4             	sub    -0x1c(%ebp),%eax
  800502:	3d 00 03 00 00       	cmp    $0x300,%eax
  800507:	74 14                	je     80051d <_main+0x4e5>
  800509:	83 ec 04             	sub    $0x4,%esp
  80050c:	68 d8 41 80 00       	push   $0x8041d8
  800511:	6a 51                	push   $0x51
  800513:	68 54 41 80 00       	push   $0x804154
  800518:	e8 8d 0d 00 00       	call   8012aa <_panic>


		//NEW
		//Filling the remaining size of user heap
		freeFrames = sys_calculate_free_frames() ;
  80051d:	e8 da 23 00 00       	call   8028fc <sys_calculate_free_frames>
  800522:	89 45 e8             	mov    %eax,-0x18(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  800525:	e8 72 24 00 00       	call   80299c <sys_pf_calculate_allocated_pages>
  80052a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		uint32 remainingSpaceInUHeap = (USER_HEAP_MAX - USER_HEAP_START) - 14 * Mega;
  80052d:	8b 55 f0             	mov    -0x10(%ebp),%edx
  800530:	89 d0                	mov    %edx,%eax
  800532:	01 c0                	add    %eax,%eax
  800534:	01 d0                	add    %edx,%eax
  800536:	01 c0                	add    %eax,%eax
  800538:	01 d0                	add    %edx,%eax
  80053a:	01 c0                	add    %eax,%eax
  80053c:	f7 d8                	neg    %eax
  80053e:	05 00 00 00 20       	add    $0x20000000,%eax
  800543:	89 45 e0             	mov    %eax,-0x20(%ebp)
		ptr_allocations[8] = malloc(remainingSpaceInUHeap - kilo);
  800546:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800549:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80054c:	29 c2                	sub    %eax,%edx
  80054e:	89 d0                	mov    %edx,%eax
  800550:	83 ec 0c             	sub    $0xc,%esp
  800553:	50                   	push   %eax
  800554:	e8 97 1f 00 00       	call   8024f0 <malloc>
  800559:	83 c4 10             	add    $0x10,%esp
  80055c:	89 45 a0             	mov    %eax,-0x60(%ebp)
		if ((uint32) ptr_allocations[8] !=  (USER_HEAP_START + 14*Mega)) panic("Wrong start address for the allocated space... ");
  80055f:	8b 45 a0             	mov    -0x60(%ebp),%eax
  800562:	89 c1                	mov    %eax,%ecx
  800564:	8b 55 f0             	mov    -0x10(%ebp),%edx
  800567:	89 d0                	mov    %edx,%eax
  800569:	01 c0                	add    %eax,%eax
  80056b:	01 d0                	add    %edx,%eax
  80056d:	01 c0                	add    %eax,%eax
  80056f:	01 d0                	add    %edx,%eax
  800571:	01 c0                	add    %eax,%eax
  800573:	05 00 00 00 80       	add    $0x80000000,%eax
  800578:	39 c1                	cmp    %eax,%ecx
  80057a:	74 14                	je     800590 <_main+0x558>
  80057c:	83 ec 04             	sub    $0x4,%esp
  80057f:	68 24 41 80 00       	push   $0x804124
  800584:	6a 5a                	push   $0x5a
  800586:	68 54 41 80 00       	push   $0x804154
  80058b:	e8 1a 0d 00 00       	call   8012aa <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 768 + 1) panic("Wrong allocation: ");
		if((freeFrames - sys_calculate_free_frames()) != 124) panic("Wrong allocation: either extra pages are allocated in memory or pages not allocated correctly on PageFile");
  800590:	8b 5d e8             	mov    -0x18(%ebp),%ebx
  800593:	e8 64 23 00 00       	call   8028fc <sys_calculate_free_frames>
  800598:	29 c3                	sub    %eax,%ebx
  80059a:	89 d8                	mov    %ebx,%eax
  80059c:	83 f8 7c             	cmp    $0x7c,%eax
  80059f:	74 14                	je     8005b5 <_main+0x57d>
  8005a1:	83 ec 04             	sub    $0x4,%esp
  8005a4:	68 6c 41 80 00       	push   $0x80416c
  8005a9:	6a 5c                	push   $0x5c
  8005ab:	68 54 41 80 00       	push   $0x804154
  8005b0:	e8 f5 0c 00 00       	call   8012aa <_panic>
		if((sys_pf_calculate_allocated_pages() - usedDiskPages) != 127488) panic("Extra or less pages are allocated in PageFile");
  8005b5:	e8 e2 23 00 00       	call   80299c <sys_pf_calculate_allocated_pages>
  8005ba:	2b 45 e4             	sub    -0x1c(%ebp),%eax
  8005bd:	3d 00 f2 01 00       	cmp    $0x1f200,%eax
  8005c2:	74 14                	je     8005d8 <_main+0x5a0>
  8005c4:	83 ec 04             	sub    $0x4,%esp
  8005c7:	68 d8 41 80 00       	push   $0x8041d8
  8005cc:	6a 5d                	push   $0x5d
  8005ce:	68 54 41 80 00       	push   $0x804154
  8005d3:	e8 d2 0c 00 00       	call   8012aa <_panic>
	}

	//[2] Free some to create holes
	{
		//1 MB Hole
		freeFrames = sys_calculate_free_frames() ;
  8005d8:	e8 1f 23 00 00       	call   8028fc <sys_calculate_free_frames>
  8005dd:	89 45 e8             	mov    %eax,-0x18(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  8005e0:	e8 b7 23 00 00       	call   80299c <sys_pf_calculate_allocated_pages>
  8005e5:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		free(ptr_allocations[1]);
  8005e8:	8b 45 84             	mov    -0x7c(%ebp),%eax
  8005eb:	83 ec 0c             	sub    $0xc,%esp
  8005ee:	50                   	push   %eax
  8005ef:	e8 7d 1f 00 00       	call   802571 <free>
  8005f4:	83 c4 10             	add    $0x10,%esp
		//if ((sys_calculate_free_frames() - freeFrames) != 256) panic("Wrong free: ");
		if ((usedDiskPages - sys_pf_calculate_allocated_pages()) != 256) panic("Wrong free: Extra or less pages are removed from PageFile");
  8005f7:	e8 a0 23 00 00       	call   80299c <sys_pf_calculate_allocated_pages>
  8005fc:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8005ff:	29 c2                	sub    %eax,%edx
  800601:	89 d0                	mov    %edx,%eax
  800603:	3d 00 01 00 00       	cmp    $0x100,%eax
  800608:	74 14                	je     80061e <_main+0x5e6>
  80060a:	83 ec 04             	sub    $0x4,%esp
  80060d:	68 08 42 80 00       	push   $0x804208
  800612:	6a 68                	push   $0x68
  800614:	68 54 41 80 00       	push   $0x804154
  800619:	e8 8c 0c 00 00       	call   8012aa <_panic>
		if ((sys_calculate_free_frames() - freeFrames) != 0) panic("Wrong free: WS pages in memory and/or page tables are not freed correctly");
  80061e:	e8 d9 22 00 00       	call   8028fc <sys_calculate_free_frames>
  800623:	89 c2                	mov    %eax,%edx
  800625:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800628:	39 c2                	cmp    %eax,%edx
  80062a:	74 14                	je     800640 <_main+0x608>
  80062c:	83 ec 04             	sub    $0x4,%esp
  80062f:	68 44 42 80 00       	push   $0x804244
  800634:	6a 69                	push   $0x69
  800636:	68 54 41 80 00       	push   $0x804154
  80063b:	e8 6a 0c 00 00       	call   8012aa <_panic>

		//2 MB Hole
		freeFrames = sys_calculate_free_frames() ;
  800640:	e8 b7 22 00 00       	call   8028fc <sys_calculate_free_frames>
  800645:	89 45 e8             	mov    %eax,-0x18(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  800648:	e8 4f 23 00 00       	call   80299c <sys_pf_calculate_allocated_pages>
  80064d:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		free(ptr_allocations[4]);
  800650:	8b 45 90             	mov    -0x70(%ebp),%eax
  800653:	83 ec 0c             	sub    $0xc,%esp
  800656:	50                   	push   %eax
  800657:	e8 15 1f 00 00       	call   802571 <free>
  80065c:	83 c4 10             	add    $0x10,%esp
		//if ((sys_calculate_free_frames() - freeFrames) != 512) panic("Wrong free: ");
		if ((usedDiskPages - sys_pf_calculate_allocated_pages()) != 512) panic("Wrong free: Extra or less pages are removed from PageFile");
  80065f:	e8 38 23 00 00       	call   80299c <sys_pf_calculate_allocated_pages>
  800664:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  800667:	29 c2                	sub    %eax,%edx
  800669:	89 d0                	mov    %edx,%eax
  80066b:	3d 00 02 00 00       	cmp    $0x200,%eax
  800670:	74 14                	je     800686 <_main+0x64e>
  800672:	83 ec 04             	sub    $0x4,%esp
  800675:	68 08 42 80 00       	push   $0x804208
  80067a:	6a 70                	push   $0x70
  80067c:	68 54 41 80 00       	push   $0x804154
  800681:	e8 24 0c 00 00       	call   8012aa <_panic>
		if ((sys_calculate_free_frames() - freeFrames) != 0) panic("Wrong free: WS pages in memory and/or page tables are not freed correctly");
  800686:	e8 71 22 00 00       	call   8028fc <sys_calculate_free_frames>
  80068b:	89 c2                	mov    %eax,%edx
  80068d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800690:	39 c2                	cmp    %eax,%edx
  800692:	74 14                	je     8006a8 <_main+0x670>
  800694:	83 ec 04             	sub    $0x4,%esp
  800697:	68 44 42 80 00       	push   $0x804244
  80069c:	6a 71                	push   $0x71
  80069e:	68 54 41 80 00       	push   $0x804154
  8006a3:	e8 02 0c 00 00       	call   8012aa <_panic>

		//3 MB Hole
		freeFrames = sys_calculate_free_frames() ;
  8006a8:	e8 4f 22 00 00       	call   8028fc <sys_calculate_free_frames>
  8006ad:	89 45 e8             	mov    %eax,-0x18(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  8006b0:	e8 e7 22 00 00       	call   80299c <sys_pf_calculate_allocated_pages>
  8006b5:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		free(ptr_allocations[6]);
  8006b8:	8b 45 98             	mov    -0x68(%ebp),%eax
  8006bb:	83 ec 0c             	sub    $0xc,%esp
  8006be:	50                   	push   %eax
  8006bf:	e8 ad 1e 00 00       	call   802571 <free>
  8006c4:	83 c4 10             	add    $0x10,%esp
		//if ((sys_calculate_free_frames() - freeFrames) != 768) panic("Wrong free: ");
		if ((usedDiskPages - sys_pf_calculate_allocated_pages()) != 768) panic("Wrong free: Extra or less pages are removed from PageFile");
  8006c7:	e8 d0 22 00 00       	call   80299c <sys_pf_calculate_allocated_pages>
  8006cc:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8006cf:	29 c2                	sub    %eax,%edx
  8006d1:	89 d0                	mov    %edx,%eax
  8006d3:	3d 00 03 00 00       	cmp    $0x300,%eax
  8006d8:	74 14                	je     8006ee <_main+0x6b6>
  8006da:	83 ec 04             	sub    $0x4,%esp
  8006dd:	68 08 42 80 00       	push   $0x804208
  8006e2:	6a 78                	push   $0x78
  8006e4:	68 54 41 80 00       	push   $0x804154
  8006e9:	e8 bc 0b 00 00       	call   8012aa <_panic>
		if ((sys_calculate_free_frames() - freeFrames) != 0) panic("Wrong free: WS pages in memory and/or page tables are not freed correctly");
  8006ee:	e8 09 22 00 00       	call   8028fc <sys_calculate_free_frames>
  8006f3:	89 c2                	mov    %eax,%edx
  8006f5:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8006f8:	39 c2                	cmp    %eax,%edx
  8006fa:	74 14                	je     800710 <_main+0x6d8>
  8006fc:	83 ec 04             	sub    $0x4,%esp
  8006ff:	68 44 42 80 00       	push   $0x804244
  800704:	6a 79                	push   $0x79
  800706:	68 54 41 80 00       	push   $0x804154
  80070b:	e8 9a 0b 00 00       	call   8012aa <_panic>

		//NEW
		//free the latest Hole (the big one)
		freeFrames = sys_calculate_free_frames() ;
  800710:	e8 e7 21 00 00       	call   8028fc <sys_calculate_free_frames>
  800715:	89 45 e8             	mov    %eax,-0x18(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  800718:	e8 7f 22 00 00       	call   80299c <sys_pf_calculate_allocated_pages>
  80071d:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		free(ptr_allocations[8]);
  800720:	8b 45 a0             	mov    -0x60(%ebp),%eax
  800723:	83 ec 0c             	sub    $0xc,%esp
  800726:	50                   	push   %eax
  800727:	e8 45 1e 00 00       	call   802571 <free>
  80072c:	83 c4 10             	add    $0x10,%esp
		//if ((sys_calculate_free_frames() - freeFrames) != 768) panic("Wrong free: ");
		if ((usedDiskPages - sys_pf_calculate_allocated_pages()) != 127488) panic("Wrong free: Extra or less pages are removed from PageFile");
  80072f:	e8 68 22 00 00       	call   80299c <sys_pf_calculate_allocated_pages>
  800734:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  800737:	29 c2                	sub    %eax,%edx
  800739:	89 d0                	mov    %edx,%eax
  80073b:	3d 00 f2 01 00       	cmp    $0x1f200,%eax
  800740:	74 17                	je     800759 <_main+0x721>
  800742:	83 ec 04             	sub    $0x4,%esp
  800745:	68 08 42 80 00       	push   $0x804208
  80074a:	68 81 00 00 00       	push   $0x81
  80074f:	68 54 41 80 00       	push   $0x804154
  800754:	e8 51 0b 00 00       	call   8012aa <_panic>
		if ((sys_calculate_free_frames() - freeFrames) != 0) panic("Wrong free: WS pages in memory and/or page tables are not freed correctly");
  800759:	e8 9e 21 00 00       	call   8028fc <sys_calculate_free_frames>
  80075e:	89 c2                	mov    %eax,%edx
  800760:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800763:	39 c2                	cmp    %eax,%edx
  800765:	74 17                	je     80077e <_main+0x746>
  800767:	83 ec 04             	sub    $0x4,%esp
  80076a:	68 44 42 80 00       	push   $0x804244
  80076f:	68 82 00 00 00       	push   $0x82
  800774:	68 54 41 80 00       	push   $0x804154
  800779:	e8 2c 0b 00 00       	call   8012aa <_panic>
	}
	int cnt = 0;
  80077e:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	//[3] Test Re-allocation
	{
		/*CASE1: Re-allocate that's fit in the same location*/

		//Allocate 512 KB - should be placed in 1st hole
		freeFrames = sys_calculate_free_frames() ;
  800785:	e8 72 21 00 00       	call   8028fc <sys_calculate_free_frames>
  80078a:	89 45 e8             	mov    %eax,-0x18(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  80078d:	e8 0a 22 00 00       	call   80299c <sys_pf_calculate_allocated_pages>
  800792:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		ptr_allocations[9] = malloc(512*kilo - kilo);
  800795:	8b 55 ec             	mov    -0x14(%ebp),%edx
  800798:	89 d0                	mov    %edx,%eax
  80079a:	c1 e0 09             	shl    $0x9,%eax
  80079d:	29 d0                	sub    %edx,%eax
  80079f:	83 ec 0c             	sub    $0xc,%esp
  8007a2:	50                   	push   %eax
  8007a3:	e8 48 1d 00 00       	call   8024f0 <malloc>
  8007a8:	83 c4 10             	add    $0x10,%esp
  8007ab:	89 45 a4             	mov    %eax,-0x5c(%ebp)
		if ((uint32) ptr_allocations[9] !=  (USER_HEAP_START + 1*Mega)) panic("Wrong start address for the allocated space... ");
  8007ae:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  8007b1:	89 c2                	mov    %eax,%edx
  8007b3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8007b6:	05 00 00 00 80       	add    $0x80000000,%eax
  8007bb:	39 c2                	cmp    %eax,%edx
  8007bd:	74 17                	je     8007d6 <_main+0x79e>
  8007bf:	83 ec 04             	sub    $0x4,%esp
  8007c2:	68 24 41 80 00       	push   $0x804124
  8007c7:	68 8e 00 00 00       	push   $0x8e
  8007cc:	68 54 41 80 00       	push   $0x804154
  8007d1:	e8 d4 0a 00 00       	call   8012aa <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 128) panic("Wrong allocation: ");
		if((freeFrames - sys_calculate_free_frames()) != 0) panic("Wrong allocation: either extra pages are allocated in memory or pages not allocated correctly on PageFile");
  8007d6:	e8 21 21 00 00       	call   8028fc <sys_calculate_free_frames>
  8007db:	89 c2                	mov    %eax,%edx
  8007dd:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8007e0:	39 c2                	cmp    %eax,%edx
  8007e2:	74 17                	je     8007fb <_main+0x7c3>
  8007e4:	83 ec 04             	sub    $0x4,%esp
  8007e7:	68 6c 41 80 00       	push   $0x80416c
  8007ec:	68 90 00 00 00       	push   $0x90
  8007f1:	68 54 41 80 00       	push   $0x804154
  8007f6:	e8 af 0a 00 00       	call   8012aa <_panic>
		if((sys_pf_calculate_allocated_pages() - usedDiskPages) != 128) panic("Extra or less pages are allocated in PageFile");
  8007fb:	e8 9c 21 00 00       	call   80299c <sys_pf_calculate_allocated_pages>
  800800:	2b 45 e4             	sub    -0x1c(%ebp),%eax
  800803:	3d 80 00 00 00       	cmp    $0x80,%eax
  800808:	74 17                	je     800821 <_main+0x7e9>
  80080a:	83 ec 04             	sub    $0x4,%esp
  80080d:	68 d8 41 80 00       	push   $0x8041d8
  800812:	68 91 00 00 00       	push   $0x91
  800817:	68 54 41 80 00       	push   $0x804154
  80081c:	e8 89 0a 00 00       	call   8012aa <_panic>

		//Fill it with data
		int *intArr = (int*) ptr_allocations[9];
  800821:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  800824:	89 45 d8             	mov    %eax,-0x28(%ebp)
		int lastIndexOfInt1 = ((512)*kilo)/sizeof(int) - 1;
  800827:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80082a:	c1 e0 09             	shl    $0x9,%eax
  80082d:	c1 e8 02             	shr    $0x2,%eax
  800830:	48                   	dec    %eax
  800831:	89 45 d4             	mov    %eax,-0x2c(%ebp)

		int i = 0;
  800834:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)



		//NEW
		//filling the first 100 elements
		for (i=0; i < 100 ; i++)
  80083b:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  800842:	eb 17                	jmp    80085b <_main+0x823>
		{
			intArr[i] = i ;
  800844:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800847:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80084e:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800851:	01 c2                	add    %eax,%edx
  800853:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800856:	89 02                	mov    %eax,(%edx)



		//NEW
		//filling the first 100 elements
		for (i=0; i < 100 ; i++)
  800858:	ff 45 f4             	incl   -0xc(%ebp)
  80085b:	83 7d f4 63          	cmpl   $0x63,-0xc(%ebp)
  80085f:	7e e3                	jle    800844 <_main+0x80c>
		{
			intArr[i] = i ;
		}

		//filling the last 100 elements
		for (i=lastIndexOfInt1; i > lastIndexOfInt1 - 100 ; i--)
  800861:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  800864:	89 45 f4             	mov    %eax,-0xc(%ebp)
  800867:	eb 17                	jmp    800880 <_main+0x848>
		{
			intArr[i] = i ;
  800869:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80086c:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800873:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800876:	01 c2                	add    %eax,%edx
  800878:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80087b:	89 02                	mov    %eax,(%edx)
		{
			intArr[i] = i ;
		}

		//filling the last 100 elements
		for (i=lastIndexOfInt1; i > lastIndexOfInt1 - 100 ; i--)
  80087d:	ff 4d f4             	decl   -0xc(%ebp)
  800880:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  800883:	83 e8 64             	sub    $0x64,%eax
  800886:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  800889:	7c de                	jl     800869 <_main+0x831>
		{
			intArr[i] = i ;
		}

		//Reallocate it [expanded in the same place]
		freeFrames = sys_calculate_free_frames() ;
  80088b:	e8 6c 20 00 00       	call   8028fc <sys_calculate_free_frames>
  800890:	89 45 e8             	mov    %eax,-0x18(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  800893:	e8 04 21 00 00       	call   80299c <sys_pf_calculate_allocated_pages>
  800898:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		ptr_allocations[9] = realloc(ptr_allocations[9], 512*kilo + 256*kilo - kilo);
  80089b:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80089e:	89 d0                	mov    %edx,%eax
  8008a0:	01 c0                	add    %eax,%eax
  8008a2:	01 d0                	add    %edx,%eax
  8008a4:	c1 e0 08             	shl    $0x8,%eax
  8008a7:	29 d0                	sub    %edx,%eax
  8008a9:	89 c2                	mov    %eax,%edx
  8008ab:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  8008ae:	83 ec 08             	sub    $0x8,%esp
  8008b1:	52                   	push   %edx
  8008b2:	50                   	push   %eax
  8008b3:	e8 c2 1e 00 00       	call   80277a <realloc>
  8008b8:	83 c4 10             	add    $0x10,%esp
  8008bb:	89 45 a4             	mov    %eax,-0x5c(%ebp)

		//[1] test return address & re-allocated space
		if ((uint32) ptr_allocations[9] != (USER_HEAP_START + 1*Mega)) panic("Wrong start address for the re-allocated space... ");
  8008be:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  8008c1:	89 c2                	mov    %eax,%edx
  8008c3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8008c6:	05 00 00 00 80       	add    $0x80000000,%eax
  8008cb:	39 c2                	cmp    %eax,%edx
  8008cd:	74 17                	je     8008e6 <_main+0x8ae>
  8008cf:	83 ec 04             	sub    $0x4,%esp
  8008d2:	68 90 42 80 00       	push   $0x804290
  8008d7:	68 ae 00 00 00       	push   $0xae
  8008dc:	68 54 41 80 00       	push   $0x804154
  8008e1:	e8 c4 09 00 00       	call   8012aa <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 64) panic("Wrong re-allocation");
		if((freeFrames - sys_calculate_free_frames()) != 0) panic("Wrong re-allocation: either extra pages are re-allocated in memory or pages not allocated correctly on PageFile");
  8008e6:	e8 11 20 00 00       	call   8028fc <sys_calculate_free_frames>
  8008eb:	89 c2                	mov    %eax,%edx
  8008ed:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8008f0:	39 c2                	cmp    %eax,%edx
  8008f2:	74 17                	je     80090b <_main+0x8d3>
  8008f4:	83 ec 04             	sub    $0x4,%esp
  8008f7:	68 c4 42 80 00       	push   $0x8042c4
  8008fc:	68 b0 00 00 00       	push   $0xb0
  800901:	68 54 41 80 00       	push   $0x804154
  800906:	e8 9f 09 00 00       	call   8012aa <_panic>
		if((sys_pf_calculate_allocated_pages() - usedDiskPages) != 64) panic("Extra or less pages are re-allocated in PageFile");
  80090b:	e8 8c 20 00 00       	call   80299c <sys_pf_calculate_allocated_pages>
  800910:	2b 45 e4             	sub    -0x1c(%ebp),%eax
  800913:	83 f8 40             	cmp    $0x40,%eax
  800916:	74 17                	je     80092f <_main+0x8f7>
  800918:	83 ec 04             	sub    $0x4,%esp
  80091b:	68 34 43 80 00       	push   $0x804334
  800920:	68 b1 00 00 00       	push   $0xb1
  800925:	68 54 41 80 00       	push   $0x804154
  80092a:	e8 7b 09 00 00       	call   8012aa <_panic>


		//[2] test memory access
		int lastIndexOfInt2 = ((512+256)*kilo)/sizeof(int) - 1;
  80092f:	8b 55 ec             	mov    -0x14(%ebp),%edx
  800932:	89 d0                	mov    %edx,%eax
  800934:	01 c0                	add    %eax,%eax
  800936:	01 d0                	add    %edx,%eax
  800938:	c1 e0 08             	shl    $0x8,%eax
  80093b:	c1 e8 02             	shr    $0x2,%eax
  80093e:	48                   	dec    %eax
  80093f:	89 45 d0             	mov    %eax,-0x30(%ebp)

		//NEW
		//filling the first 100 elements of the new range
		for(i = lastIndexOfInt1 + 1; i < lastIndexOfInt1 + 101; i++)
  800942:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  800945:	40                   	inc    %eax
  800946:	89 45 f4             	mov    %eax,-0xc(%ebp)
  800949:	eb 17                	jmp    800962 <_main+0x92a>
		{
			intArr[i] = i;
  80094b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80094e:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800955:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800958:	01 c2                	add    %eax,%edx
  80095a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80095d:	89 02                	mov    %eax,(%edx)
		//[2] test memory access
		int lastIndexOfInt2 = ((512+256)*kilo)/sizeof(int) - 1;

		//NEW
		//filling the first 100 elements of the new range
		for(i = lastIndexOfInt1 + 1; i < lastIndexOfInt1 + 101; i++)
  80095f:	ff 45 f4             	incl   -0xc(%ebp)
  800962:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  800965:	83 c0 65             	add    $0x65,%eax
  800968:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  80096b:	7f de                	jg     80094b <_main+0x913>
		{
			intArr[i] = i;
		}
		//filling the last 100 elements of the new range
		for(i = lastIndexOfInt2; i > lastIndexOfInt2 - 100; i--)
  80096d:	8b 45 d0             	mov    -0x30(%ebp),%eax
  800970:	89 45 f4             	mov    %eax,-0xc(%ebp)
  800973:	eb 17                	jmp    80098c <_main+0x954>
		{
			intArr[i] = i;
  800975:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800978:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80097f:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800982:	01 c2                	add    %eax,%edx
  800984:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800987:	89 02                	mov    %eax,(%edx)
		for(i = lastIndexOfInt1 + 1; i < lastIndexOfInt1 + 101; i++)
		{
			intArr[i] = i;
		}
		//filling the last 100 elements of the new range
		for(i = lastIndexOfInt2; i > lastIndexOfInt2 - 100; i--)
  800989:	ff 4d f4             	decl   -0xc(%ebp)
  80098c:	8b 45 d0             	mov    -0x30(%ebp),%eax
  80098f:	83 e8 64             	sub    $0x64,%eax
  800992:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  800995:	7c de                	jl     800975 <_main+0x93d>
		{
			intArr[i] = i;
		}

		//checking the first 100 elements of the old range
		for(i = 0; i < 100; i++)
  800997:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  80099e:	eb 30                	jmp    8009d0 <_main+0x998>
		{
			if (intArr[i] != i) panic("Wrong re-allocation: stored values are wrongly changed!");
  8009a0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8009a3:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8009aa:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8009ad:	01 d0                	add    %edx,%eax
  8009af:	8b 00                	mov    (%eax),%eax
  8009b1:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  8009b4:	74 17                	je     8009cd <_main+0x995>
  8009b6:	83 ec 04             	sub    $0x4,%esp
  8009b9:	68 68 43 80 00       	push   $0x804368
  8009be:	68 c6 00 00 00       	push   $0xc6
  8009c3:	68 54 41 80 00       	push   $0x804154
  8009c8:	e8 dd 08 00 00       	call   8012aa <_panic>
		{
			intArr[i] = i;
		}

		//checking the first 100 elements of the old range
		for(i = 0; i < 100; i++)
  8009cd:	ff 45 f4             	incl   -0xc(%ebp)
  8009d0:	83 7d f4 63          	cmpl   $0x63,-0xc(%ebp)
  8009d4:	7e ca                	jle    8009a0 <_main+0x968>
		{
			if (intArr[i] != i) panic("Wrong re-allocation: stored values are wrongly changed!");
		}

		//checking the last 100 elements of the old range
		for(i = lastIndexOfInt1; i > lastIndexOfInt1 - 100; i--)
  8009d6:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8009d9:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8009dc:	eb 30                	jmp    800a0e <_main+0x9d6>
		{
			if (intArr[i] != i) panic("Wrong re-allocation: stored values are wrongly changed!");
  8009de:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8009e1:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8009e8:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8009eb:	01 d0                	add    %edx,%eax
  8009ed:	8b 00                	mov    (%eax),%eax
  8009ef:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  8009f2:	74 17                	je     800a0b <_main+0x9d3>
  8009f4:	83 ec 04             	sub    $0x4,%esp
  8009f7:	68 68 43 80 00       	push   $0x804368
  8009fc:	68 cc 00 00 00       	push   $0xcc
  800a01:	68 54 41 80 00       	push   $0x804154
  800a06:	e8 9f 08 00 00       	call   8012aa <_panic>
		{
			if (intArr[i] != i) panic("Wrong re-allocation: stored values are wrongly changed!");
		}

		//checking the last 100 elements of the old range
		for(i = lastIndexOfInt1; i > lastIndexOfInt1 - 100; i--)
  800a0b:	ff 4d f4             	decl   -0xc(%ebp)
  800a0e:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  800a11:	83 e8 64             	sub    $0x64,%eax
  800a14:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  800a17:	7c c5                	jl     8009de <_main+0x9a6>
		{
			if (intArr[i] != i) panic("Wrong re-allocation: stored values are wrongly changed!");
		}

		//checking the first 100 elements of the new range
		for(i = lastIndexOfInt1 + 1; i < lastIndexOfInt1 + 101; i++)
  800a19:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  800a1c:	40                   	inc    %eax
  800a1d:	89 45 f4             	mov    %eax,-0xc(%ebp)
  800a20:	eb 30                	jmp    800a52 <_main+0xa1a>
		{
			if (intArr[i] != i) panic("Wrong re-allocation: stored values are wrongly changed!");
  800a22:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800a25:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800a2c:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800a2f:	01 d0                	add    %edx,%eax
  800a31:	8b 00                	mov    (%eax),%eax
  800a33:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  800a36:	74 17                	je     800a4f <_main+0xa17>
  800a38:	83 ec 04             	sub    $0x4,%esp
  800a3b:	68 68 43 80 00       	push   $0x804368
  800a40:	68 d2 00 00 00       	push   $0xd2
  800a45:	68 54 41 80 00       	push   $0x804154
  800a4a:	e8 5b 08 00 00       	call   8012aa <_panic>
		{
			if (intArr[i] != i) panic("Wrong re-allocation: stored values are wrongly changed!");
		}

		//checking the first 100 elements of the new range
		for(i = lastIndexOfInt1 + 1; i < lastIndexOfInt1 + 101; i++)
  800a4f:	ff 45 f4             	incl   -0xc(%ebp)
  800a52:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  800a55:	83 c0 65             	add    $0x65,%eax
  800a58:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  800a5b:	7f c5                	jg     800a22 <_main+0x9ea>
		{
			if (intArr[i] != i) panic("Wrong re-allocation: stored values are wrongly changed!");
		}

		//checking the last 100 elements of the new range
		for(i = lastIndexOfInt2; i > lastIndexOfInt2 - 100; i--)
  800a5d:	8b 45 d0             	mov    -0x30(%ebp),%eax
  800a60:	89 45 f4             	mov    %eax,-0xc(%ebp)
  800a63:	eb 30                	jmp    800a95 <_main+0xa5d>
		{
			if (intArr[i] != i) panic("Wrong re-allocation: stored values are wrongly changed!");
  800a65:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800a68:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800a6f:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800a72:	01 d0                	add    %edx,%eax
  800a74:	8b 00                	mov    (%eax),%eax
  800a76:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  800a79:	74 17                	je     800a92 <_main+0xa5a>
  800a7b:	83 ec 04             	sub    $0x4,%esp
  800a7e:	68 68 43 80 00       	push   $0x804368
  800a83:	68 d8 00 00 00       	push   $0xd8
  800a88:	68 54 41 80 00       	push   $0x804154
  800a8d:	e8 18 08 00 00       	call   8012aa <_panic>
		{
			if (intArr[i] != i) panic("Wrong re-allocation: stored values are wrongly changed!");
		}

		//checking the last 100 elements of the new range
		for(i = lastIndexOfInt2; i > lastIndexOfInt2 - 100; i--)
  800a92:	ff 4d f4             	decl   -0xc(%ebp)
  800a95:	8b 45 d0             	mov    -0x30(%ebp),%eax
  800a98:	83 e8 64             	sub    $0x64,%eax
  800a9b:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  800a9e:	7c c5                	jl     800a65 <_main+0xa2d>
		{
			if (intArr[i] != i) panic("Wrong re-allocation: stored values are wrongly changed!");
		}

		//[3] test freeing it after expansion
		freeFrames = sys_calculate_free_frames() ;
  800aa0:	e8 57 1e 00 00       	call   8028fc <sys_calculate_free_frames>
  800aa5:	89 45 e8             	mov    %eax,-0x18(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  800aa8:	e8 ef 1e 00 00       	call   80299c <sys_pf_calculate_allocated_pages>
  800aad:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		free(ptr_allocations[9]);
  800ab0:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  800ab3:	83 ec 0c             	sub    $0xc,%esp
  800ab6:	50                   	push   %eax
  800ab7:	e8 b5 1a 00 00       	call   802571 <free>
  800abc:	83 c4 10             	add    $0x10,%esp
		//if ((sys_calculate_free_frames() - freeFrames) != 192) panic("Wrong free of the re-allocated space");
		if ((usedDiskPages - sys_pf_calculate_allocated_pages()) != 192) panic("Wrong free of the re-allocated space: Extra or less pages are removed from PageFile");
  800abf:	e8 d8 1e 00 00       	call   80299c <sys_pf_calculate_allocated_pages>
  800ac4:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  800ac7:	29 c2                	sub    %eax,%edx
  800ac9:	89 d0                	mov    %edx,%eax
  800acb:	3d c0 00 00 00       	cmp    $0xc0,%eax
  800ad0:	74 17                	je     800ae9 <_main+0xab1>
  800ad2:	83 ec 04             	sub    $0x4,%esp
  800ad5:	68 a0 43 80 00       	push   $0x8043a0
  800ada:	68 e0 00 00 00       	push   $0xe0
  800adf:	68 54 41 80 00       	push   $0x804154
  800ae4:	e8 c1 07 00 00       	call   8012aa <_panic>
		if ((sys_calculate_free_frames() - freeFrames) != 4 + 1) panic("Wrong free: WS pages in memory and/or page tables are not freed correctly");
  800ae9:	e8 0e 1e 00 00       	call   8028fc <sys_calculate_free_frames>
  800aee:	89 c2                	mov    %eax,%edx
  800af0:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800af3:	29 c2                	sub    %eax,%edx
  800af5:	89 d0                	mov    %edx,%eax
  800af7:	83 f8 05             	cmp    $0x5,%eax
  800afa:	74 17                	je     800b13 <_main+0xadb>
  800afc:	83 ec 04             	sub    $0x4,%esp
  800aff:	68 44 42 80 00       	push   $0x804244
  800b04:	68 e1 00 00 00       	push   $0xe1
  800b09:	68 54 41 80 00       	push   $0x804154
  800b0e:	e8 97 07 00 00       	call   8012aa <_panic>

		vcprintf("\b\b\b40%", NULL);
  800b13:	83 ec 08             	sub    $0x8,%esp
  800b16:	6a 00                	push   $0x0
  800b18:	68 f4 43 80 00       	push   $0x8043f4
  800b1d:	e8 d1 09 00 00       	call   8014f3 <vcprintf>
  800b22:	83 c4 10             	add    $0x10,%esp

		/*CASE2: Re-allocate that's not fit in the same location*/

		//Allocate 1.5 MB - should be placed in 2nd hole
		freeFrames = sys_calculate_free_frames() ;
  800b25:	e8 d2 1d 00 00       	call   8028fc <sys_calculate_free_frames>
  800b2a:	89 45 e8             	mov    %eax,-0x18(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  800b2d:	e8 6a 1e 00 00       	call   80299c <sys_pf_calculate_allocated_pages>
  800b32:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		ptr_allocations[9] = malloc(1*Mega + 512*kilo - kilo);
  800b35:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800b38:	c1 e0 09             	shl    $0x9,%eax
  800b3b:	89 c2                	mov    %eax,%edx
  800b3d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800b40:	01 d0                	add    %edx,%eax
  800b42:	2b 45 ec             	sub    -0x14(%ebp),%eax
  800b45:	83 ec 0c             	sub    $0xc,%esp
  800b48:	50                   	push   %eax
  800b49:	e8 a2 19 00 00       	call   8024f0 <malloc>
  800b4e:	83 c4 10             	add    $0x10,%esp
  800b51:	89 45 a4             	mov    %eax,-0x5c(%ebp)
		if ((uint32) ptr_allocations[9] !=  (USER_HEAP_START + 4*Mega)) panic("Wrong start address for the allocated space... ");
  800b54:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  800b57:	89 c2                	mov    %eax,%edx
  800b59:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800b5c:	c1 e0 02             	shl    $0x2,%eax
  800b5f:	05 00 00 00 80       	add    $0x80000000,%eax
  800b64:	39 c2                	cmp    %eax,%edx
  800b66:	74 17                	je     800b7f <_main+0xb47>
  800b68:	83 ec 04             	sub    $0x4,%esp
  800b6b:	68 24 41 80 00       	push   $0x804124
  800b70:	68 eb 00 00 00       	push   $0xeb
  800b75:	68 54 41 80 00       	push   $0x804154
  800b7a:	e8 2b 07 00 00       	call   8012aa <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 384) panic("Wrong allocation: ");
		if((freeFrames - sys_calculate_free_frames()) != 0) panic("Wrong allocation: either extra pages are allocated in memory or pages not allocated correctly on PageFile");
  800b7f:	e8 78 1d 00 00       	call   8028fc <sys_calculate_free_frames>
  800b84:	89 c2                	mov    %eax,%edx
  800b86:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800b89:	39 c2                	cmp    %eax,%edx
  800b8b:	74 17                	je     800ba4 <_main+0xb6c>
  800b8d:	83 ec 04             	sub    $0x4,%esp
  800b90:	68 6c 41 80 00       	push   $0x80416c
  800b95:	68 ed 00 00 00       	push   $0xed
  800b9a:	68 54 41 80 00       	push   $0x804154
  800b9f:	e8 06 07 00 00       	call   8012aa <_panic>
		if((sys_pf_calculate_allocated_pages() - usedDiskPages) != 384) panic("Extra or less pages are allocated in PageFile");
  800ba4:	e8 f3 1d 00 00       	call   80299c <sys_pf_calculate_allocated_pages>
  800ba9:	2b 45 e4             	sub    -0x1c(%ebp),%eax
  800bac:	3d 80 01 00 00       	cmp    $0x180,%eax
  800bb1:	74 17                	je     800bca <_main+0xb92>
  800bb3:	83 ec 04             	sub    $0x4,%esp
  800bb6:	68 d8 41 80 00       	push   $0x8041d8
  800bbb:	68 ee 00 00 00       	push   $0xee
  800bc0:	68 54 41 80 00       	push   $0x804154
  800bc5:	e8 e0 06 00 00       	call   8012aa <_panic>

		//Fill it with data
		intArr = (int*) ptr_allocations[9];
  800bca:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  800bcd:	89 45 d8             	mov    %eax,-0x28(%ebp)
		lastIndexOfInt1 = (1*Mega + 512*kilo)/sizeof(int) - 1;
  800bd0:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800bd3:	c1 e0 09             	shl    $0x9,%eax
  800bd6:	89 c2                	mov    %eax,%edx
  800bd8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800bdb:	01 d0                	add    %edx,%eax
  800bdd:	c1 e8 02             	shr    $0x2,%eax
  800be0:	48                   	dec    %eax
  800be1:	89 45 d4             	mov    %eax,-0x2c(%ebp)
		i = 0;
  800be4:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

		//NEW
		//filling the first 100 elements
		for (i=0; i < 100 ; i++)
  800beb:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  800bf2:	eb 17                	jmp    800c0b <_main+0xbd3>
		{
			intArr[i] = i ;
  800bf4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800bf7:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800bfe:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800c01:	01 c2                	add    %eax,%edx
  800c03:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800c06:	89 02                	mov    %eax,(%edx)
		lastIndexOfInt1 = (1*Mega + 512*kilo)/sizeof(int) - 1;
		i = 0;

		//NEW
		//filling the first 100 elements
		for (i=0; i < 100 ; i++)
  800c08:	ff 45 f4             	incl   -0xc(%ebp)
  800c0b:	83 7d f4 63          	cmpl   $0x63,-0xc(%ebp)
  800c0f:	7e e3                	jle    800bf4 <_main+0xbbc>
		{
			intArr[i] = i ;
		}

		//filling the last 100 elements
		for (i=lastIndexOfInt1; i > lastIndexOfInt1 - 100 ; i--)
  800c11:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  800c14:	89 45 f4             	mov    %eax,-0xc(%ebp)
  800c17:	eb 17                	jmp    800c30 <_main+0xbf8>
		{
			intArr[i] = i ;
  800c19:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800c1c:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800c23:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800c26:	01 c2                	add    %eax,%edx
  800c28:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800c2b:	89 02                	mov    %eax,(%edx)
		{
			intArr[i] = i ;
		}

		//filling the last 100 elements
		for (i=lastIndexOfInt1; i > lastIndexOfInt1 - 100 ; i--)
  800c2d:	ff 4d f4             	decl   -0xc(%ebp)
  800c30:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  800c33:	83 e8 64             	sub    $0x64,%eax
  800c36:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  800c39:	7c de                	jl     800c19 <_main+0xbe1>
		{
			intArr[i] = i ;
		}

		//Reallocate it to 2.5 MB [should be moved to next hole]
		freeFrames = sys_calculate_free_frames() ;
  800c3b:	e8 bc 1c 00 00       	call   8028fc <sys_calculate_free_frames>
  800c40:	89 45 e8             	mov    %eax,-0x18(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  800c43:	e8 54 1d 00 00       	call   80299c <sys_pf_calculate_allocated_pages>
  800c48:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		ptr_allocations[9] = realloc(ptr_allocations[9], 1*Mega + 512*kilo + 1*Mega - kilo);
  800c4b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800c4e:	c1 e0 09             	shl    $0x9,%eax
  800c51:	89 c2                	mov    %eax,%edx
  800c53:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800c56:	01 c2                	add    %eax,%edx
  800c58:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800c5b:	01 d0                	add    %edx,%eax
  800c5d:	2b 45 ec             	sub    -0x14(%ebp),%eax
  800c60:	89 c2                	mov    %eax,%edx
  800c62:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  800c65:	83 ec 08             	sub    $0x8,%esp
  800c68:	52                   	push   %edx
  800c69:	50                   	push   %eax
  800c6a:	e8 0b 1b 00 00       	call   80277a <realloc>
  800c6f:	83 c4 10             	add    $0x10,%esp
  800c72:	89 45 a4             	mov    %eax,-0x5c(%ebp)
		//[1] test return address & re-allocated space
		if ((uint32) ptr_allocations[9] != (USER_HEAP_START + 8*Mega)) panic("Wrong start address for the re-allocated space... ");
  800c75:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  800c78:	89 c2                	mov    %eax,%edx
  800c7a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800c7d:	c1 e0 03             	shl    $0x3,%eax
  800c80:	05 00 00 00 80       	add    $0x80000000,%eax
  800c85:	39 c2                	cmp    %eax,%edx
  800c87:	74 17                	je     800ca0 <_main+0xc68>
  800c89:	83 ec 04             	sub    $0x4,%esp
  800c8c:	68 90 42 80 00       	push   $0x804290
  800c91:	68 07 01 00 00       	push   $0x107
  800c96:	68 54 41 80 00       	push   $0x804154
  800c9b:	e8 0a 06 00 00       	call   8012aa <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 256) panic("Wrong re-allocation");

		//if((sys_calculate_free_frames() - freeFrames) != 3) panic("Wrong re-allocation: either extra pages are re-allocated in memory or pages not allocated correctly on PageFile");
		if((sys_pf_calculate_allocated_pages() - usedDiskPages) != 256) panic("Extra or less pages are re-allocated in PageFile");
  800ca0:	e8 f7 1c 00 00       	call   80299c <sys_pf_calculate_allocated_pages>
  800ca5:	2b 45 e4             	sub    -0x1c(%ebp),%eax
  800ca8:	3d 00 01 00 00       	cmp    $0x100,%eax
  800cad:	74 17                	je     800cc6 <_main+0xc8e>
  800caf:	83 ec 04             	sub    $0x4,%esp
  800cb2:	68 34 43 80 00       	push   $0x804334
  800cb7:	68 0b 01 00 00       	push   $0x10b
  800cbc:	68 54 41 80 00       	push   $0x804154
  800cc1:	e8 e4 05 00 00       	call   8012aa <_panic>

		//[2] test memory access
		lastIndexOfInt2 = (2*Mega + 512*kilo)/sizeof(int) - 1;
  800cc6:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800cc9:	c1 e0 08             	shl    $0x8,%eax
  800ccc:	89 c2                	mov    %eax,%edx
  800cce:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800cd1:	01 d0                	add    %edx,%eax
  800cd3:	01 c0                	add    %eax,%eax
  800cd5:	c1 e8 02             	shr    $0x2,%eax
  800cd8:	48                   	dec    %eax
  800cd9:	89 45 d0             	mov    %eax,-0x30(%ebp)
		intArr = (int*) ptr_allocations[9];
  800cdc:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  800cdf:	89 45 d8             	mov    %eax,-0x28(%ebp)



		//NEW
		//filling the first 100 elements of the new range
		for(i = lastIndexOfInt1 + 1; i < lastIndexOfInt1 + 101; i++)
  800ce2:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  800ce5:	40                   	inc    %eax
  800ce6:	89 45 f4             	mov    %eax,-0xc(%ebp)
  800ce9:	eb 17                	jmp    800d02 <_main+0xcca>
		{
			intArr[i] = i;
  800ceb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800cee:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800cf5:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800cf8:	01 c2                	add    %eax,%edx
  800cfa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800cfd:	89 02                	mov    %eax,(%edx)



		//NEW
		//filling the first 100 elements of the new range
		for(i = lastIndexOfInt1 + 1; i < lastIndexOfInt1 + 101; i++)
  800cff:	ff 45 f4             	incl   -0xc(%ebp)
  800d02:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  800d05:	83 c0 65             	add    $0x65,%eax
  800d08:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  800d0b:	7f de                	jg     800ceb <_main+0xcb3>
		{
			intArr[i] = i;
		}
		//filling the last 100 elements of the new range
		for(i = lastIndexOfInt2; i > lastIndexOfInt2 - 100; i--)
  800d0d:	8b 45 d0             	mov    -0x30(%ebp),%eax
  800d10:	89 45 f4             	mov    %eax,-0xc(%ebp)
  800d13:	eb 17                	jmp    800d2c <_main+0xcf4>
		{
			intArr[i] = i;
  800d15:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800d18:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800d1f:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800d22:	01 c2                	add    %eax,%edx
  800d24:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800d27:	89 02                	mov    %eax,(%edx)
		for(i = lastIndexOfInt1 + 1; i < lastIndexOfInt1 + 101; i++)
		{
			intArr[i] = i;
		}
		//filling the last 100 elements of the new range
		for(i = lastIndexOfInt2; i > lastIndexOfInt2 - 100; i--)
  800d29:	ff 4d f4             	decl   -0xc(%ebp)
  800d2c:	8b 45 d0             	mov    -0x30(%ebp),%eax
  800d2f:	83 e8 64             	sub    $0x64,%eax
  800d32:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  800d35:	7c de                	jl     800d15 <_main+0xcdd>
		{
			intArr[i] = i;
		}

		//checking the first 100 elements of the old range
		for(i = 0; i < 100; i++)
  800d37:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  800d3e:	eb 30                	jmp    800d70 <_main+0xd38>
		{
			if (intArr[i] != i) panic("Wrong re-allocation: stored values are wrongly changed!");
  800d40:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800d43:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800d4a:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800d4d:	01 d0                	add    %edx,%eax
  800d4f:	8b 00                	mov    (%eax),%eax
  800d51:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  800d54:	74 17                	je     800d6d <_main+0xd35>
  800d56:	83 ec 04             	sub    $0x4,%esp
  800d59:	68 68 43 80 00       	push   $0x804368
  800d5e:	68 22 01 00 00       	push   $0x122
  800d63:	68 54 41 80 00       	push   $0x804154
  800d68:	e8 3d 05 00 00       	call   8012aa <_panic>
		{
			intArr[i] = i;
		}

		//checking the first 100 elements of the old range
		for(i = 0; i < 100; i++)
  800d6d:	ff 45 f4             	incl   -0xc(%ebp)
  800d70:	83 7d f4 63          	cmpl   $0x63,-0xc(%ebp)
  800d74:	7e ca                	jle    800d40 <_main+0xd08>
		{
			if (intArr[i] != i) panic("Wrong re-allocation: stored values are wrongly changed!");
		}

		//checking the last 100 elements of the old range
		for(i = lastIndexOfInt1; i > lastIndexOfInt1 - 100; i--)
  800d76:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  800d79:	89 45 f4             	mov    %eax,-0xc(%ebp)
  800d7c:	eb 30                	jmp    800dae <_main+0xd76>
		{
			if (intArr[i] != i)
  800d7e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800d81:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800d88:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800d8b:	01 d0                	add    %edx,%eax
  800d8d:	8b 00                	mov    (%eax),%eax
  800d8f:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  800d92:	74 17                	je     800dab <_main+0xd73>
			{
				panic("Wrong re-allocation: stored values are wrongly changed!");
  800d94:	83 ec 04             	sub    $0x4,%esp
  800d97:	68 68 43 80 00       	push   $0x804368
  800d9c:	68 2a 01 00 00       	push   $0x12a
  800da1:	68 54 41 80 00       	push   $0x804154
  800da6:	e8 ff 04 00 00       	call   8012aa <_panic>
		{
			if (intArr[i] != i) panic("Wrong re-allocation: stored values are wrongly changed!");
		}

		//checking the last 100 elements of the old range
		for(i = lastIndexOfInt1; i > lastIndexOfInt1 - 100; i--)
  800dab:	ff 4d f4             	decl   -0xc(%ebp)
  800dae:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  800db1:	83 e8 64             	sub    $0x64,%eax
  800db4:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  800db7:	7c c5                	jl     800d7e <_main+0xd46>
				panic("Wrong re-allocation: stored values are wrongly changed!");
			}
		}

		//checking the first 100 elements of the new range
		for(i = lastIndexOfInt1 + 1; i < lastIndexOfInt1 + 101; i++)
  800db9:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  800dbc:	40                   	inc    %eax
  800dbd:	89 45 f4             	mov    %eax,-0xc(%ebp)
  800dc0:	eb 30                	jmp    800df2 <_main+0xdba>
		{
			if (intArr[i] != i) panic("Wrong re-allocation: stored values are wrongly changed!");
  800dc2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800dc5:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800dcc:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800dcf:	01 d0                	add    %edx,%eax
  800dd1:	8b 00                	mov    (%eax),%eax
  800dd3:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  800dd6:	74 17                	je     800def <_main+0xdb7>
  800dd8:	83 ec 04             	sub    $0x4,%esp
  800ddb:	68 68 43 80 00       	push   $0x804368
  800de0:	68 31 01 00 00       	push   $0x131
  800de5:	68 54 41 80 00       	push   $0x804154
  800dea:	e8 bb 04 00 00       	call   8012aa <_panic>
				panic("Wrong re-allocation: stored values are wrongly changed!");
			}
		}

		//checking the first 100 elements of the new range
		for(i = lastIndexOfInt1 + 1; i < lastIndexOfInt1 + 101; i++)
  800def:	ff 45 f4             	incl   -0xc(%ebp)
  800df2:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  800df5:	83 c0 65             	add    $0x65,%eax
  800df8:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  800dfb:	7f c5                	jg     800dc2 <_main+0xd8a>
		{
			if (intArr[i] != i) panic("Wrong re-allocation: stored values are wrongly changed!");
		}

		//checking the last 100 elements of the new range
		for(i = lastIndexOfInt2; i > lastIndexOfInt2 - 100; i--)
  800dfd:	8b 45 d0             	mov    -0x30(%ebp),%eax
  800e00:	89 45 f4             	mov    %eax,-0xc(%ebp)
  800e03:	eb 30                	jmp    800e35 <_main+0xdfd>
		{
			if (intArr[i] != i) panic("Wrong re-allocation: stored values are wrongly changed!");
  800e05:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800e08:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800e0f:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800e12:	01 d0                	add    %edx,%eax
  800e14:	8b 00                	mov    (%eax),%eax
  800e16:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  800e19:	74 17                	je     800e32 <_main+0xdfa>
  800e1b:	83 ec 04             	sub    $0x4,%esp
  800e1e:	68 68 43 80 00       	push   $0x804368
  800e23:	68 37 01 00 00       	push   $0x137
  800e28:	68 54 41 80 00       	push   $0x804154
  800e2d:	e8 78 04 00 00       	call   8012aa <_panic>
		{
			if (intArr[i] != i) panic("Wrong re-allocation: stored values are wrongly changed!");
		}

		//checking the last 100 elements of the new range
		for(i = lastIndexOfInt2; i > lastIndexOfInt2 - 100; i--)
  800e32:	ff 4d f4             	decl   -0xc(%ebp)
  800e35:	8b 45 d0             	mov    -0x30(%ebp),%eax
  800e38:	83 e8 64             	sub    $0x64,%eax
  800e3b:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  800e3e:	7c c5                	jl     800e05 <_main+0xdcd>
			if (intArr[i] != i) panic("Wrong re-allocation: stored values are wrongly changed!");
		}


		//[3] test freeing it after expansion
		freeFrames = sys_calculate_free_frames() ;
  800e40:	e8 b7 1a 00 00       	call   8028fc <sys_calculate_free_frames>
  800e45:	89 45 e8             	mov    %eax,-0x18(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  800e48:	e8 4f 1b 00 00       	call   80299c <sys_pf_calculate_allocated_pages>
  800e4d:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		free(ptr_allocations[9]);
  800e50:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  800e53:	83 ec 0c             	sub    $0xc,%esp
  800e56:	50                   	push   %eax
  800e57:	e8 15 17 00 00       	call   802571 <free>
  800e5c:	83 c4 10             	add    $0x10,%esp
		//if ((sys_calculate_free_frames() - freeFrames) != 640) panic("Wrong free of the re-allocated space");
		if ((usedDiskPages - sys_pf_calculate_allocated_pages()) != 640) panic("Wrong free of the re-allocated space: Extra or less pages are removed from PageFile");
  800e5f:	e8 38 1b 00 00       	call   80299c <sys_pf_calculate_allocated_pages>
  800e64:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  800e67:	29 c2                	sub    %eax,%edx
  800e69:	89 d0                	mov    %edx,%eax
  800e6b:	3d 80 02 00 00       	cmp    $0x280,%eax
  800e70:	74 17                	je     800e89 <_main+0xe51>
  800e72:	83 ec 04             	sub    $0x4,%esp
  800e75:	68 a0 43 80 00       	push   $0x8043a0
  800e7a:	68 40 01 00 00       	push   $0x140
  800e7f:	68 54 41 80 00       	push   $0x804154
  800e84:	e8 21 04 00 00       	call   8012aa <_panic>
		//if ((sys_calculate_free_frames() - freeFrames) != 4 + 1) panic("Wrong free of the re-allocated space: WS pages in memory and/or page tables are not freed correctly");

		vcprintf("\b\b\b70%", NULL);
  800e89:	83 ec 08             	sub    $0x8,%esp
  800e8c:	6a 00                	push   $0x0
  800e8e:	68 fb 43 80 00       	push   $0x8043fb
  800e93:	e8 5b 06 00 00       	call   8014f3 <vcprintf>
  800e98:	83 c4 10             	add    $0x10,%esp

		/*CASE3: Re-allocate that's not fit in the same location*/

		//Fill it with data
		intArr = (int*) ptr_allocations[0];
  800e9b:	8b 45 80             	mov    -0x80(%ebp),%eax
  800e9e:	89 45 d8             	mov    %eax,-0x28(%ebp)
		lastIndexOfInt1 = (1*Mega)/sizeof(int) - 1;
  800ea1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800ea4:	c1 e8 02             	shr    $0x2,%eax
  800ea7:	48                   	dec    %eax
  800ea8:	89 45 d4             	mov    %eax,-0x2c(%ebp)

		i = 0;
  800eab:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

		//NEW
		//filling the first 100 elements
		for (i=0; i < 100 ; i++)
  800eb2:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  800eb9:	eb 17                	jmp    800ed2 <_main+0xe9a>
		{
			intArr[i] = i ;
  800ebb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800ebe:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800ec5:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800ec8:	01 c2                	add    %eax,%edx
  800eca:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800ecd:	89 02                	mov    %eax,(%edx)

		i = 0;

		//NEW
		//filling the first 100 elements
		for (i=0; i < 100 ; i++)
  800ecf:	ff 45 f4             	incl   -0xc(%ebp)
  800ed2:	83 7d f4 63          	cmpl   $0x63,-0xc(%ebp)
  800ed6:	7e e3                	jle    800ebb <_main+0xe83>
		{
			intArr[i] = i ;
		}

		//filling the last 100 elements
		for (i=lastIndexOfInt1; i > lastIndexOfInt1 - 100 ; i--)
  800ed8:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  800edb:	89 45 f4             	mov    %eax,-0xc(%ebp)
  800ede:	eb 17                	jmp    800ef7 <_main+0xebf>
		{
			intArr[i] = i ;
  800ee0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800ee3:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800eea:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800eed:	01 c2                	add    %eax,%edx
  800eef:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800ef2:	89 02                	mov    %eax,(%edx)
		{
			intArr[i] = i ;
		}

		//filling the last 100 elements
		for (i=lastIndexOfInt1; i > lastIndexOfInt1 - 100 ; i--)
  800ef4:	ff 4d f4             	decl   -0xc(%ebp)
  800ef7:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  800efa:	83 e8 64             	sub    $0x64,%eax
  800efd:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  800f00:	7c de                	jl     800ee0 <_main+0xea8>
			intArr[i] = i ;
		}


		//Reallocate it to 4 MB [should be moved to last hole]
		freeFrames = sys_calculate_free_frames() ;
  800f02:	e8 f5 19 00 00       	call   8028fc <sys_calculate_free_frames>
  800f07:	89 45 e8             	mov    %eax,-0x18(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  800f0a:	e8 8d 1a 00 00       	call   80299c <sys_pf_calculate_allocated_pages>
  800f0f:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		ptr_allocations[0] = realloc(ptr_allocations[0], 1*Mega + 3*Mega - kilo);
  800f12:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800f15:	c1 e0 02             	shl    $0x2,%eax
  800f18:	2b 45 ec             	sub    -0x14(%ebp),%eax
  800f1b:	89 c2                	mov    %eax,%edx
  800f1d:	8b 45 80             	mov    -0x80(%ebp),%eax
  800f20:	83 ec 08             	sub    $0x8,%esp
  800f23:	52                   	push   %edx
  800f24:	50                   	push   %eax
  800f25:	e8 50 18 00 00       	call   80277a <realloc>
  800f2a:	83 c4 10             	add    $0x10,%esp
  800f2d:	89 45 80             	mov    %eax,-0x80(%ebp)
		//[1] test return address & re-allocated space
		if ((uint32) ptr_allocations[0] != (USER_HEAP_START + 14*Mega)) panic("Wrong start address for the re-allocated space... ");
  800f30:	8b 45 80             	mov    -0x80(%ebp),%eax
  800f33:	89 c1                	mov    %eax,%ecx
  800f35:	8b 55 f0             	mov    -0x10(%ebp),%edx
  800f38:	89 d0                	mov    %edx,%eax
  800f3a:	01 c0                	add    %eax,%eax
  800f3c:	01 d0                	add    %edx,%eax
  800f3e:	01 c0                	add    %eax,%eax
  800f40:	01 d0                	add    %edx,%eax
  800f42:	01 c0                	add    %eax,%eax
  800f44:	05 00 00 00 80       	add    $0x80000000,%eax
  800f49:	39 c1                	cmp    %eax,%ecx
  800f4b:	74 17                	je     800f64 <_main+0xf2c>
  800f4d:	83 ec 04             	sub    $0x4,%esp
  800f50:	68 90 42 80 00       	push   $0x804290
  800f55:	68 60 01 00 00       	push   $0x160
  800f5a:	68 54 41 80 00       	push   $0x804154
  800f5f:	e8 46 03 00 00       	call   8012aa <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 768 + 1) panic("Wrong re-allocation");
		//if((sys_calculate_free_frames() - freeFrames) != 2 + 1) panic("Wrong re-allocation: either extra pages are re-allocated in memory or pages not allocated correctly on PageFile");
		if((sys_pf_calculate_allocated_pages() - usedDiskPages) != 768) panic("Extra or less pages are re-allocated in PageFile");
  800f64:	e8 33 1a 00 00       	call   80299c <sys_pf_calculate_allocated_pages>
  800f69:	2b 45 e4             	sub    -0x1c(%ebp),%eax
  800f6c:	3d 00 03 00 00       	cmp    $0x300,%eax
  800f71:	74 17                	je     800f8a <_main+0xf52>
  800f73:	83 ec 04             	sub    $0x4,%esp
  800f76:	68 34 43 80 00       	push   $0x804334
  800f7b:	68 63 01 00 00       	push   $0x163
  800f80:	68 54 41 80 00       	push   $0x804154
  800f85:	e8 20 03 00 00       	call   8012aa <_panic>

		//[2] test memory access
		lastIndexOfInt2 = (4*Mega)/sizeof(int) - 1;
  800f8a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800f8d:	c1 e0 02             	shl    $0x2,%eax
  800f90:	c1 e8 02             	shr    $0x2,%eax
  800f93:	48                   	dec    %eax
  800f94:	89 45 d0             	mov    %eax,-0x30(%ebp)
		intArr = (int*) ptr_allocations[0];
  800f97:	8b 45 80             	mov    -0x80(%ebp),%eax
  800f9a:	89 45 d8             	mov    %eax,-0x28(%ebp)

		//NEW
		//filling the first 100 elements of the new range
		for(i = lastIndexOfInt1 + 1; i < lastIndexOfInt1 + 101; i++)
  800f9d:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  800fa0:	40                   	inc    %eax
  800fa1:	89 45 f4             	mov    %eax,-0xc(%ebp)
  800fa4:	eb 17                	jmp    800fbd <_main+0xf85>
		{
			intArr[i] = i;
  800fa6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800fa9:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800fb0:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800fb3:	01 c2                	add    %eax,%edx
  800fb5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800fb8:	89 02                	mov    %eax,(%edx)
		lastIndexOfInt2 = (4*Mega)/sizeof(int) - 1;
		intArr = (int*) ptr_allocations[0];

		//NEW
		//filling the first 100 elements of the new range
		for(i = lastIndexOfInt1 + 1; i < lastIndexOfInt1 + 101; i++)
  800fba:	ff 45 f4             	incl   -0xc(%ebp)
  800fbd:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  800fc0:	83 c0 65             	add    $0x65,%eax
  800fc3:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  800fc6:	7f de                	jg     800fa6 <_main+0xf6e>
		{
			intArr[i] = i;
		}

		//filling the last 100 elements of the new range
		for(i = lastIndexOfInt2; i > lastIndexOfInt2 - 100; i--)
  800fc8:	8b 45 d0             	mov    -0x30(%ebp),%eax
  800fcb:	89 45 f4             	mov    %eax,-0xc(%ebp)
  800fce:	eb 17                	jmp    800fe7 <_main+0xfaf>
		{
			intArr[i] = i;
  800fd0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800fd3:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800fda:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800fdd:	01 c2                	add    %eax,%edx
  800fdf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800fe2:	89 02                	mov    %eax,(%edx)
		{
			intArr[i] = i;
		}

		//filling the last 100 elements of the new range
		for(i = lastIndexOfInt2; i > lastIndexOfInt2 - 100; i--)
  800fe4:	ff 4d f4             	decl   -0xc(%ebp)
  800fe7:	8b 45 d0             	mov    -0x30(%ebp),%eax
  800fea:	83 e8 64             	sub    $0x64,%eax
  800fed:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  800ff0:	7c de                	jl     800fd0 <_main+0xf98>
		{
			intArr[i] = i;
		}

		//checking the first 100 elements of the old range
		for(i = 0; i < 100; i++)
  800ff2:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  800ff9:	eb 30                	jmp    80102b <_main+0xff3>
		{
			if (intArr[i] != i) panic("Wrong re-allocation: stored values are wrongly changed!");
  800ffb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800ffe:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801005:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801008:	01 d0                	add    %edx,%eax
  80100a:	8b 00                	mov    (%eax),%eax
  80100c:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  80100f:	74 17                	je     801028 <_main+0xff0>
  801011:	83 ec 04             	sub    $0x4,%esp
  801014:	68 68 43 80 00       	push   $0x804368
  801019:	68 79 01 00 00       	push   $0x179
  80101e:	68 54 41 80 00       	push   $0x804154
  801023:	e8 82 02 00 00       	call   8012aa <_panic>
		{
			intArr[i] = i;
		}

		//checking the first 100 elements of the old range
		for(i = 0; i < 100; i++)
  801028:	ff 45 f4             	incl   -0xc(%ebp)
  80102b:	83 7d f4 63          	cmpl   $0x63,-0xc(%ebp)
  80102f:	7e ca                	jle    800ffb <_main+0xfc3>
		{
			if (intArr[i] != i) panic("Wrong re-allocation: stored values are wrongly changed!");
		}

		//checking the last 100 elements of the old range
		for(i = lastIndexOfInt1; i > lastIndexOfInt1 - 100; i--)
  801031:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  801034:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801037:	eb 30                	jmp    801069 <_main+0x1031>
		{
			if (intArr[i] != i)
  801039:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80103c:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801043:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801046:	01 d0                	add    %edx,%eax
  801048:	8b 00                	mov    (%eax),%eax
  80104a:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  80104d:	74 17                	je     801066 <_main+0x102e>
			{
				panic("Wrong re-allocation: stored values are wrongly changed!");
  80104f:	83 ec 04             	sub    $0x4,%esp
  801052:	68 68 43 80 00       	push   $0x804368
  801057:	68 81 01 00 00       	push   $0x181
  80105c:	68 54 41 80 00       	push   $0x804154
  801061:	e8 44 02 00 00       	call   8012aa <_panic>
		{
			if (intArr[i] != i) panic("Wrong re-allocation: stored values are wrongly changed!");
		}

		//checking the last 100 elements of the old range
		for(i = lastIndexOfInt1; i > lastIndexOfInt1 - 100; i--)
  801066:	ff 4d f4             	decl   -0xc(%ebp)
  801069:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80106c:	83 e8 64             	sub    $0x64,%eax
  80106f:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  801072:	7c c5                	jl     801039 <_main+0x1001>
				panic("Wrong re-allocation: stored values are wrongly changed!");
			}
		}

		//checking the first 100 elements of the new range
		for(i = lastIndexOfInt1 + 1; i < lastIndexOfInt1 + 101; i++)
  801074:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  801077:	40                   	inc    %eax
  801078:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80107b:	eb 30                	jmp    8010ad <_main+0x1075>
		{
			if (intArr[i] != i) panic("Wrong re-allocation: stored values are wrongly changed!");
  80107d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801080:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801087:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80108a:	01 d0                	add    %edx,%eax
  80108c:	8b 00                	mov    (%eax),%eax
  80108e:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  801091:	74 17                	je     8010aa <_main+0x1072>
  801093:	83 ec 04             	sub    $0x4,%esp
  801096:	68 68 43 80 00       	push   $0x804368
  80109b:	68 88 01 00 00       	push   $0x188
  8010a0:	68 54 41 80 00       	push   $0x804154
  8010a5:	e8 00 02 00 00       	call   8012aa <_panic>
				panic("Wrong re-allocation: stored values are wrongly changed!");
			}
		}

		//checking the first 100 elements of the new range
		for(i = lastIndexOfInt1 + 1; i < lastIndexOfInt1 + 101; i++)
  8010aa:	ff 45 f4             	incl   -0xc(%ebp)
  8010ad:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8010b0:	83 c0 65             	add    $0x65,%eax
  8010b3:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  8010b6:	7f c5                	jg     80107d <_main+0x1045>
		{
			if (intArr[i] != i) panic("Wrong re-allocation: stored values are wrongly changed!");
		}

		//checking the last 100 elements of the new range
		for(i = lastIndexOfInt2; i > lastIndexOfInt2 - 100; i--)
  8010b8:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8010bb:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8010be:	eb 30                	jmp    8010f0 <_main+0x10b8>
		{
			if (intArr[i] != i) panic("Wrong re-allocation: stored values are wrongly changed!");
  8010c0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8010c3:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8010ca:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8010cd:	01 d0                	add    %edx,%eax
  8010cf:	8b 00                	mov    (%eax),%eax
  8010d1:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  8010d4:	74 17                	je     8010ed <_main+0x10b5>
  8010d6:	83 ec 04             	sub    $0x4,%esp
  8010d9:	68 68 43 80 00       	push   $0x804368
  8010de:	68 8e 01 00 00       	push   $0x18e
  8010e3:	68 54 41 80 00       	push   $0x804154
  8010e8:	e8 bd 01 00 00       	call   8012aa <_panic>
		{
			if (intArr[i] != i) panic("Wrong re-allocation: stored values are wrongly changed!");
		}

		//checking the last 100 elements of the new range
		for(i = lastIndexOfInt2; i > lastIndexOfInt2 - 100; i--)
  8010ed:	ff 4d f4             	decl   -0xc(%ebp)
  8010f0:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8010f3:	83 e8 64             	sub    $0x64,%eax
  8010f6:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  8010f9:	7c c5                	jl     8010c0 <_main+0x1088>
		{
			if (intArr[i] != i) panic("Wrong re-allocation: stored values are wrongly changed!");
		}

		//[3] test freeing it after expansion
		freeFrames = sys_calculate_free_frames() ;
  8010fb:	e8 fc 17 00 00       	call   8028fc <sys_calculate_free_frames>
  801100:	89 45 e8             	mov    %eax,-0x18(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  801103:	e8 94 18 00 00       	call   80299c <sys_pf_calculate_allocated_pages>
  801108:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		free(ptr_allocations[0]);
  80110b:	8b 45 80             	mov    -0x80(%ebp),%eax
  80110e:	83 ec 0c             	sub    $0xc,%esp
  801111:	50                   	push   %eax
  801112:	e8 5a 14 00 00       	call   802571 <free>
  801117:	83 c4 10             	add    $0x10,%esp
		//if ((sys_calculate_free_frames() - freeFrames) != 1024+1) panic("Wrong free of the re-allocated space");
		if ((usedDiskPages - sys_pf_calculate_allocated_pages()) != 1024) panic("Wrong free of the re-allocated space: Extra or less pages are removed from PageFile");
  80111a:	e8 7d 18 00 00       	call   80299c <sys_pf_calculate_allocated_pages>
  80111f:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  801122:	29 c2                	sub    %eax,%edx
  801124:	89 d0                	mov    %edx,%eax
  801126:	3d 00 04 00 00       	cmp    $0x400,%eax
  80112b:	74 17                	je     801144 <_main+0x110c>
  80112d:	83 ec 04             	sub    $0x4,%esp
  801130:	68 a0 43 80 00       	push   $0x8043a0
  801135:	68 96 01 00 00       	push   $0x196
  80113a:	68 54 41 80 00       	push   $0x804154
  80113f:	e8 66 01 00 00       	call   8012aa <_panic>
		//if ((sys_calculate_free_frames() - freeFrames) != 4 + 2) panic("Wrong free of the re-allocated space: WS pages in memory and/or page tables are not freed correctly");

		vcprintf("\b\b\b100%\n", NULL);
  801144:	83 ec 08             	sub    $0x8,%esp
  801147:	6a 00                	push   $0x0
  801149:	68 02 44 80 00       	push   $0x804402
  80114e:	e8 a0 03 00 00       	call   8014f3 <vcprintf>
  801153:	83 c4 10             	add    $0x10,%esp
	}

	cprintf("Congratulations!! test realloc [1] completed successfully.\n");
  801156:	83 ec 0c             	sub    $0xc,%esp
  801159:	68 0c 44 80 00       	push   $0x80440c
  80115e:	e8 fb 03 00 00       	call   80155e <cprintf>
  801163:	83 c4 10             	add    $0x10,%esp

	return;
  801166:	90                   	nop
}
  801167:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80116a:	5b                   	pop    %ebx
  80116b:	5f                   	pop    %edi
  80116c:	5d                   	pop    %ebp
  80116d:	c3                   	ret    

0080116e <libmain>:
volatile struct Env *myEnv = NULL;
volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";

void
libmain(int argc, char **argv)
{
  80116e:	55                   	push   %ebp
  80116f:	89 e5                	mov    %esp,%ebp
  801171:	83 ec 18             	sub    $0x18,%esp
	int envIndex = sys_getenvindex();
  801174:	e8 63 1a 00 00       	call   802bdc <sys_getenvindex>
  801179:	89 45 f4             	mov    %eax,-0xc(%ebp)
	myEnv = &(envs[envIndex]);
  80117c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80117f:	89 d0                	mov    %edx,%eax
  801181:	c1 e0 03             	shl    $0x3,%eax
  801184:	01 d0                	add    %edx,%eax
  801186:	01 c0                	add    %eax,%eax
  801188:	01 d0                	add    %edx,%eax
  80118a:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801191:	01 d0                	add    %edx,%eax
  801193:	c1 e0 04             	shl    $0x4,%eax
  801196:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  80119b:	a3 20 50 80 00       	mov    %eax,0x805020

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  8011a0:	a1 20 50 80 00       	mov    0x805020,%eax
  8011a5:	8a 80 5c 05 00 00    	mov    0x55c(%eax),%al
  8011ab:	84 c0                	test   %al,%al
  8011ad:	74 0f                	je     8011be <libmain+0x50>
		binaryname = myEnv->prog_name;
  8011af:	a1 20 50 80 00       	mov    0x805020,%eax
  8011b4:	05 5c 05 00 00       	add    $0x55c,%eax
  8011b9:	a3 00 50 80 00       	mov    %eax,0x805000

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8011be:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8011c2:	7e 0a                	jle    8011ce <libmain+0x60>
		binaryname = argv[0];
  8011c4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011c7:	8b 00                	mov    (%eax),%eax
  8011c9:	a3 00 50 80 00       	mov    %eax,0x805000

	// call user main routine
	_main(argc, argv);
  8011ce:	83 ec 08             	sub    $0x8,%esp
  8011d1:	ff 75 0c             	pushl  0xc(%ebp)
  8011d4:	ff 75 08             	pushl  0x8(%ebp)
  8011d7:	e8 5c ee ff ff       	call   800038 <_main>
  8011dc:	83 c4 10             	add    $0x10,%esp



	sys_disable_interrupt();
  8011df:	e8 05 18 00 00       	call   8029e9 <sys_disable_interrupt>
	cprintf("**************************************\n");
  8011e4:	83 ec 0c             	sub    $0xc,%esp
  8011e7:	68 60 44 80 00       	push   $0x804460
  8011ec:	e8 6d 03 00 00       	call   80155e <cprintf>
  8011f1:	83 c4 10             	add    $0x10,%esp
	cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  8011f4:	a1 20 50 80 00       	mov    0x805020,%eax
  8011f9:	8b 90 44 05 00 00    	mov    0x544(%eax),%edx
  8011ff:	a1 20 50 80 00       	mov    0x805020,%eax
  801204:	8b 80 34 05 00 00    	mov    0x534(%eax),%eax
  80120a:	83 ec 04             	sub    $0x4,%esp
  80120d:	52                   	push   %edx
  80120e:	50                   	push   %eax
  80120f:	68 88 44 80 00       	push   $0x804488
  801214:	e8 45 03 00 00       	call   80155e <cprintf>
  801219:	83 c4 10             	add    $0x10,%esp
	cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  80121c:	a1 20 50 80 00       	mov    0x805020,%eax
  801221:	8b 88 54 05 00 00    	mov    0x554(%eax),%ecx
  801227:	a1 20 50 80 00       	mov    0x805020,%eax
  80122c:	8b 90 50 05 00 00    	mov    0x550(%eax),%edx
  801232:	a1 20 50 80 00       	mov    0x805020,%eax
  801237:	8b 80 4c 05 00 00    	mov    0x54c(%eax),%eax
  80123d:	51                   	push   %ecx
  80123e:	52                   	push   %edx
  80123f:	50                   	push   %eax
  801240:	68 b0 44 80 00       	push   $0x8044b0
  801245:	e8 14 03 00 00       	call   80155e <cprintf>
  80124a:	83 c4 10             	add    $0x10,%esp
	//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
	cprintf("Num of clocks = %d\n", myEnv->nClocks);
  80124d:	a1 20 50 80 00       	mov    0x805020,%eax
  801252:	8b 80 a4 05 00 00    	mov    0x5a4(%eax),%eax
  801258:	83 ec 08             	sub    $0x8,%esp
  80125b:	50                   	push   %eax
  80125c:	68 08 45 80 00       	push   $0x804508
  801261:	e8 f8 02 00 00       	call   80155e <cprintf>
  801266:	83 c4 10             	add    $0x10,%esp
	cprintf("**************************************\n");
  801269:	83 ec 0c             	sub    $0xc,%esp
  80126c:	68 60 44 80 00       	push   $0x804460
  801271:	e8 e8 02 00 00       	call   80155e <cprintf>
  801276:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  801279:	e8 85 17 00 00       	call   802a03 <sys_enable_interrupt>

	// exit gracefully
	exit();
  80127e:	e8 19 00 00 00       	call   80129c <exit>
}
  801283:	90                   	nop
  801284:	c9                   	leave  
  801285:	c3                   	ret    

00801286 <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  801286:	55                   	push   %ebp
  801287:	89 e5                	mov    %esp,%ebp
  801289:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  80128c:	83 ec 0c             	sub    $0xc,%esp
  80128f:	6a 00                	push   $0x0
  801291:	e8 12 19 00 00       	call   802ba8 <sys_destroy_env>
  801296:	83 c4 10             	add    $0x10,%esp
}
  801299:	90                   	nop
  80129a:	c9                   	leave  
  80129b:	c3                   	ret    

0080129c <exit>:

void
exit(void)
{
  80129c:	55                   	push   %ebp
  80129d:	89 e5                	mov    %esp,%ebp
  80129f:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  8012a2:	e8 67 19 00 00       	call   802c0e <sys_exit_env>
}
  8012a7:	90                   	nop
  8012a8:	c9                   	leave  
  8012a9:	c3                   	ret    

008012aa <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  8012aa:	55                   	push   %ebp
  8012ab:	89 e5                	mov    %esp,%ebp
  8012ad:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  8012b0:	8d 45 10             	lea    0x10(%ebp),%eax
  8012b3:	83 c0 04             	add    $0x4,%eax
  8012b6:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  8012b9:	a1 5c 51 80 00       	mov    0x80515c,%eax
  8012be:	85 c0                	test   %eax,%eax
  8012c0:	74 16                	je     8012d8 <_panic+0x2e>
		cprintf("%s: ", argv0);
  8012c2:	a1 5c 51 80 00       	mov    0x80515c,%eax
  8012c7:	83 ec 08             	sub    $0x8,%esp
  8012ca:	50                   	push   %eax
  8012cb:	68 1c 45 80 00       	push   $0x80451c
  8012d0:	e8 89 02 00 00       	call   80155e <cprintf>
  8012d5:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  8012d8:	a1 00 50 80 00       	mov    0x805000,%eax
  8012dd:	ff 75 0c             	pushl  0xc(%ebp)
  8012e0:	ff 75 08             	pushl  0x8(%ebp)
  8012e3:	50                   	push   %eax
  8012e4:	68 21 45 80 00       	push   $0x804521
  8012e9:	e8 70 02 00 00       	call   80155e <cprintf>
  8012ee:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  8012f1:	8b 45 10             	mov    0x10(%ebp),%eax
  8012f4:	83 ec 08             	sub    $0x8,%esp
  8012f7:	ff 75 f4             	pushl  -0xc(%ebp)
  8012fa:	50                   	push   %eax
  8012fb:	e8 f3 01 00 00       	call   8014f3 <vcprintf>
  801300:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  801303:	83 ec 08             	sub    $0x8,%esp
  801306:	6a 00                	push   $0x0
  801308:	68 3d 45 80 00       	push   $0x80453d
  80130d:	e8 e1 01 00 00       	call   8014f3 <vcprintf>
  801312:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  801315:	e8 82 ff ff ff       	call   80129c <exit>

	// should not return here
	while (1) ;
  80131a:	eb fe                	jmp    80131a <_panic+0x70>

0080131c <CheckWSWithoutLastIndex>:
}

void CheckWSWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  80131c:	55                   	push   %ebp
  80131d:	89 e5                	mov    %esp,%ebp
  80131f:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  801322:	a1 20 50 80 00       	mov    0x805020,%eax
  801327:	8b 50 74             	mov    0x74(%eax),%edx
  80132a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80132d:	39 c2                	cmp    %eax,%edx
  80132f:	74 14                	je     801345 <CheckWSWithoutLastIndex+0x29>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  801331:	83 ec 04             	sub    $0x4,%esp
  801334:	68 40 45 80 00       	push   $0x804540
  801339:	6a 26                	push   $0x26
  80133b:	68 8c 45 80 00       	push   $0x80458c
  801340:	e8 65 ff ff ff       	call   8012aa <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  801345:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  80134c:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  801353:	e9 c2 00 00 00       	jmp    80141a <CheckWSWithoutLastIndex+0xfe>
		if (expectedPages[e] == 0) {
  801358:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80135b:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801362:	8b 45 08             	mov    0x8(%ebp),%eax
  801365:	01 d0                	add    %edx,%eax
  801367:	8b 00                	mov    (%eax),%eax
  801369:	85 c0                	test   %eax,%eax
  80136b:	75 08                	jne    801375 <CheckWSWithoutLastIndex+0x59>
			expectedNumOfEmptyLocs++;
  80136d:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  801370:	e9 a2 00 00 00       	jmp    801417 <CheckWSWithoutLastIndex+0xfb>
		}
		int found = 0;
  801375:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  80137c:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  801383:	eb 69                	jmp    8013ee <CheckWSWithoutLastIndex+0xd2>
			if (myEnv->__uptr_pws[w].empty == 0) {
  801385:	a1 20 50 80 00       	mov    0x805020,%eax
  80138a:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  801390:	8b 55 e8             	mov    -0x18(%ebp),%edx
  801393:	89 d0                	mov    %edx,%eax
  801395:	01 c0                	add    %eax,%eax
  801397:	01 d0                	add    %edx,%eax
  801399:	c1 e0 03             	shl    $0x3,%eax
  80139c:	01 c8                	add    %ecx,%eax
  80139e:	8a 40 04             	mov    0x4(%eax),%al
  8013a1:	84 c0                	test   %al,%al
  8013a3:	75 46                	jne    8013eb <CheckWSWithoutLastIndex+0xcf>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  8013a5:	a1 20 50 80 00       	mov    0x805020,%eax
  8013aa:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  8013b0:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8013b3:	89 d0                	mov    %edx,%eax
  8013b5:	01 c0                	add    %eax,%eax
  8013b7:	01 d0                	add    %edx,%eax
  8013b9:	c1 e0 03             	shl    $0x3,%eax
  8013bc:	01 c8                	add    %ecx,%eax
  8013be:	8b 00                	mov    (%eax),%eax
  8013c0:	89 45 dc             	mov    %eax,-0x24(%ebp)
  8013c3:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8013c6:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8013cb:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  8013cd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8013d0:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  8013d7:	8b 45 08             	mov    0x8(%ebp),%eax
  8013da:	01 c8                	add    %ecx,%eax
  8013dc:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  8013de:	39 c2                	cmp    %eax,%edx
  8013e0:	75 09                	jne    8013eb <CheckWSWithoutLastIndex+0xcf>
						== expectedPages[e]) {
					found = 1;
  8013e2:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  8013e9:	eb 12                	jmp    8013fd <CheckWSWithoutLastIndex+0xe1>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8013eb:	ff 45 e8             	incl   -0x18(%ebp)
  8013ee:	a1 20 50 80 00       	mov    0x805020,%eax
  8013f3:	8b 50 74             	mov    0x74(%eax),%edx
  8013f6:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8013f9:	39 c2                	cmp    %eax,%edx
  8013fb:	77 88                	ja     801385 <CheckWSWithoutLastIndex+0x69>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  8013fd:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  801401:	75 14                	jne    801417 <CheckWSWithoutLastIndex+0xfb>
			panic(
  801403:	83 ec 04             	sub    $0x4,%esp
  801406:	68 98 45 80 00       	push   $0x804598
  80140b:	6a 3a                	push   $0x3a
  80140d:	68 8c 45 80 00       	push   $0x80458c
  801412:	e8 93 fe ff ff       	call   8012aa <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  801417:	ff 45 f0             	incl   -0x10(%ebp)
  80141a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80141d:	3b 45 0c             	cmp    0xc(%ebp),%eax
  801420:	0f 8c 32 ff ff ff    	jl     801358 <CheckWSWithoutLastIndex+0x3c>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  801426:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  80142d:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  801434:	eb 26                	jmp    80145c <CheckWSWithoutLastIndex+0x140>
		if (myEnv->__uptr_pws[w].empty == 1) {
  801436:	a1 20 50 80 00       	mov    0x805020,%eax
  80143b:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  801441:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801444:	89 d0                	mov    %edx,%eax
  801446:	01 c0                	add    %eax,%eax
  801448:	01 d0                	add    %edx,%eax
  80144a:	c1 e0 03             	shl    $0x3,%eax
  80144d:	01 c8                	add    %ecx,%eax
  80144f:	8a 40 04             	mov    0x4(%eax),%al
  801452:	3c 01                	cmp    $0x1,%al
  801454:	75 03                	jne    801459 <CheckWSWithoutLastIndex+0x13d>
			actualNumOfEmptyLocs++;
  801456:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  801459:	ff 45 e0             	incl   -0x20(%ebp)
  80145c:	a1 20 50 80 00       	mov    0x805020,%eax
  801461:	8b 50 74             	mov    0x74(%eax),%edx
  801464:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801467:	39 c2                	cmp    %eax,%edx
  801469:	77 cb                	ja     801436 <CheckWSWithoutLastIndex+0x11a>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  80146b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80146e:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  801471:	74 14                	je     801487 <CheckWSWithoutLastIndex+0x16b>
		panic(
  801473:	83 ec 04             	sub    $0x4,%esp
  801476:	68 ec 45 80 00       	push   $0x8045ec
  80147b:	6a 44                	push   $0x44
  80147d:	68 8c 45 80 00       	push   $0x80458c
  801482:	e8 23 fe ff ff       	call   8012aa <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  801487:	90                   	nop
  801488:	c9                   	leave  
  801489:	c3                   	ret    

0080148a <putch>:
};

//2017:
uint8 printProgName = 0;

static void putch(int ch, struct printbuf *b) {
  80148a:	55                   	push   %ebp
  80148b:	89 e5                	mov    %esp,%ebp
  80148d:	83 ec 08             	sub    $0x8,%esp
	b->buf[b->idx++] = ch;
  801490:	8b 45 0c             	mov    0xc(%ebp),%eax
  801493:	8b 00                	mov    (%eax),%eax
  801495:	8d 48 01             	lea    0x1(%eax),%ecx
  801498:	8b 55 0c             	mov    0xc(%ebp),%edx
  80149b:	89 0a                	mov    %ecx,(%edx)
  80149d:	8b 55 08             	mov    0x8(%ebp),%edx
  8014a0:	88 d1                	mov    %dl,%cl
  8014a2:	8b 55 0c             	mov    0xc(%ebp),%edx
  8014a5:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  8014a9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8014ac:	8b 00                	mov    (%eax),%eax
  8014ae:	3d ff 00 00 00       	cmp    $0xff,%eax
  8014b3:	75 2c                	jne    8014e1 <putch+0x57>
		sys_cputs(b->buf, b->idx, printProgName);
  8014b5:	a0 24 50 80 00       	mov    0x805024,%al
  8014ba:	0f b6 c0             	movzbl %al,%eax
  8014bd:	8b 55 0c             	mov    0xc(%ebp),%edx
  8014c0:	8b 12                	mov    (%edx),%edx
  8014c2:	89 d1                	mov    %edx,%ecx
  8014c4:	8b 55 0c             	mov    0xc(%ebp),%edx
  8014c7:	83 c2 08             	add    $0x8,%edx
  8014ca:	83 ec 04             	sub    $0x4,%esp
  8014cd:	50                   	push   %eax
  8014ce:	51                   	push   %ecx
  8014cf:	52                   	push   %edx
  8014d0:	e8 66 13 00 00       	call   80283b <sys_cputs>
  8014d5:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  8014d8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8014db:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  8014e1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8014e4:	8b 40 04             	mov    0x4(%eax),%eax
  8014e7:	8d 50 01             	lea    0x1(%eax),%edx
  8014ea:	8b 45 0c             	mov    0xc(%ebp),%eax
  8014ed:	89 50 04             	mov    %edx,0x4(%eax)
}
  8014f0:	90                   	nop
  8014f1:	c9                   	leave  
  8014f2:	c3                   	ret    

008014f3 <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  8014f3:	55                   	push   %ebp
  8014f4:	89 e5                	mov    %esp,%ebp
  8014f6:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  8014fc:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  801503:	00 00 00 
	b.cnt = 0;
  801506:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  80150d:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  801510:	ff 75 0c             	pushl  0xc(%ebp)
  801513:	ff 75 08             	pushl  0x8(%ebp)
  801516:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  80151c:	50                   	push   %eax
  80151d:	68 8a 14 80 00       	push   $0x80148a
  801522:	e8 11 02 00 00       	call   801738 <vprintfmt>
  801527:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName);
  80152a:	a0 24 50 80 00       	mov    0x805024,%al
  80152f:	0f b6 c0             	movzbl %al,%eax
  801532:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  801538:	83 ec 04             	sub    $0x4,%esp
  80153b:	50                   	push   %eax
  80153c:	52                   	push   %edx
  80153d:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  801543:	83 c0 08             	add    $0x8,%eax
  801546:	50                   	push   %eax
  801547:	e8 ef 12 00 00       	call   80283b <sys_cputs>
  80154c:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  80154f:	c6 05 24 50 80 00 00 	movb   $0x0,0x805024
	return b.cnt;
  801556:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  80155c:	c9                   	leave  
  80155d:	c3                   	ret    

0080155e <cprintf>:

int cprintf(const char *fmt, ...) {
  80155e:	55                   	push   %ebp
  80155f:	89 e5                	mov    %esp,%ebp
  801561:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  801564:	c6 05 24 50 80 00 01 	movb   $0x1,0x805024
	va_start(ap, fmt);
  80156b:	8d 45 0c             	lea    0xc(%ebp),%eax
  80156e:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  801571:	8b 45 08             	mov    0x8(%ebp),%eax
  801574:	83 ec 08             	sub    $0x8,%esp
  801577:	ff 75 f4             	pushl  -0xc(%ebp)
  80157a:	50                   	push   %eax
  80157b:	e8 73 ff ff ff       	call   8014f3 <vcprintf>
  801580:	83 c4 10             	add    $0x10,%esp
  801583:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  801586:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801589:	c9                   	leave  
  80158a:	c3                   	ret    

0080158b <atomic_cprintf>:

int atomic_cprintf(const char *fmt, ...) {
  80158b:	55                   	push   %ebp
  80158c:	89 e5                	mov    %esp,%ebp
  80158e:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  801591:	e8 53 14 00 00       	call   8029e9 <sys_disable_interrupt>
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  801596:	8d 45 0c             	lea    0xc(%ebp),%eax
  801599:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  80159c:	8b 45 08             	mov    0x8(%ebp),%eax
  80159f:	83 ec 08             	sub    $0x8,%esp
  8015a2:	ff 75 f4             	pushl  -0xc(%ebp)
  8015a5:	50                   	push   %eax
  8015a6:	e8 48 ff ff ff       	call   8014f3 <vcprintf>
  8015ab:	83 c4 10             	add    $0x10,%esp
  8015ae:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	sys_enable_interrupt();
  8015b1:	e8 4d 14 00 00       	call   802a03 <sys_enable_interrupt>
	return cnt;
  8015b6:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8015b9:	c9                   	leave  
  8015ba:	c3                   	ret    

008015bb <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8015bb:	55                   	push   %ebp
  8015bc:	89 e5                	mov    %esp,%ebp
  8015be:	53                   	push   %ebx
  8015bf:	83 ec 14             	sub    $0x14,%esp
  8015c2:	8b 45 10             	mov    0x10(%ebp),%eax
  8015c5:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8015c8:	8b 45 14             	mov    0x14(%ebp),%eax
  8015cb:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  8015ce:	8b 45 18             	mov    0x18(%ebp),%eax
  8015d1:	ba 00 00 00 00       	mov    $0x0,%edx
  8015d6:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  8015d9:	77 55                	ja     801630 <printnum+0x75>
  8015db:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  8015de:	72 05                	jb     8015e5 <printnum+0x2a>
  8015e0:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8015e3:	77 4b                	ja     801630 <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  8015e5:	8b 45 1c             	mov    0x1c(%ebp),%eax
  8015e8:	8d 58 ff             	lea    -0x1(%eax),%ebx
  8015eb:	8b 45 18             	mov    0x18(%ebp),%eax
  8015ee:	ba 00 00 00 00       	mov    $0x0,%edx
  8015f3:	52                   	push   %edx
  8015f4:	50                   	push   %eax
  8015f5:	ff 75 f4             	pushl  -0xc(%ebp)
  8015f8:	ff 75 f0             	pushl  -0x10(%ebp)
  8015fb:	e8 84 28 00 00       	call   803e84 <__udivdi3>
  801600:	83 c4 10             	add    $0x10,%esp
  801603:	83 ec 04             	sub    $0x4,%esp
  801606:	ff 75 20             	pushl  0x20(%ebp)
  801609:	53                   	push   %ebx
  80160a:	ff 75 18             	pushl  0x18(%ebp)
  80160d:	52                   	push   %edx
  80160e:	50                   	push   %eax
  80160f:	ff 75 0c             	pushl  0xc(%ebp)
  801612:	ff 75 08             	pushl  0x8(%ebp)
  801615:	e8 a1 ff ff ff       	call   8015bb <printnum>
  80161a:	83 c4 20             	add    $0x20,%esp
  80161d:	eb 1a                	jmp    801639 <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  80161f:	83 ec 08             	sub    $0x8,%esp
  801622:	ff 75 0c             	pushl  0xc(%ebp)
  801625:	ff 75 20             	pushl  0x20(%ebp)
  801628:	8b 45 08             	mov    0x8(%ebp),%eax
  80162b:	ff d0                	call   *%eax
  80162d:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  801630:	ff 4d 1c             	decl   0x1c(%ebp)
  801633:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  801637:	7f e6                	jg     80161f <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  801639:	8b 4d 18             	mov    0x18(%ebp),%ecx
  80163c:	bb 00 00 00 00       	mov    $0x0,%ebx
  801641:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801644:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801647:	53                   	push   %ebx
  801648:	51                   	push   %ecx
  801649:	52                   	push   %edx
  80164a:	50                   	push   %eax
  80164b:	e8 44 29 00 00       	call   803f94 <__umoddi3>
  801650:	83 c4 10             	add    $0x10,%esp
  801653:	05 54 48 80 00       	add    $0x804854,%eax
  801658:	8a 00                	mov    (%eax),%al
  80165a:	0f be c0             	movsbl %al,%eax
  80165d:	83 ec 08             	sub    $0x8,%esp
  801660:	ff 75 0c             	pushl  0xc(%ebp)
  801663:	50                   	push   %eax
  801664:	8b 45 08             	mov    0x8(%ebp),%eax
  801667:	ff d0                	call   *%eax
  801669:	83 c4 10             	add    $0x10,%esp
}
  80166c:	90                   	nop
  80166d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801670:	c9                   	leave  
  801671:	c3                   	ret    

00801672 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  801672:	55                   	push   %ebp
  801673:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  801675:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  801679:	7e 1c                	jle    801697 <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  80167b:	8b 45 08             	mov    0x8(%ebp),%eax
  80167e:	8b 00                	mov    (%eax),%eax
  801680:	8d 50 08             	lea    0x8(%eax),%edx
  801683:	8b 45 08             	mov    0x8(%ebp),%eax
  801686:	89 10                	mov    %edx,(%eax)
  801688:	8b 45 08             	mov    0x8(%ebp),%eax
  80168b:	8b 00                	mov    (%eax),%eax
  80168d:	83 e8 08             	sub    $0x8,%eax
  801690:	8b 50 04             	mov    0x4(%eax),%edx
  801693:	8b 00                	mov    (%eax),%eax
  801695:	eb 40                	jmp    8016d7 <getuint+0x65>
	else if (lflag)
  801697:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80169b:	74 1e                	je     8016bb <getuint+0x49>
		return va_arg(*ap, unsigned long);
  80169d:	8b 45 08             	mov    0x8(%ebp),%eax
  8016a0:	8b 00                	mov    (%eax),%eax
  8016a2:	8d 50 04             	lea    0x4(%eax),%edx
  8016a5:	8b 45 08             	mov    0x8(%ebp),%eax
  8016a8:	89 10                	mov    %edx,(%eax)
  8016aa:	8b 45 08             	mov    0x8(%ebp),%eax
  8016ad:	8b 00                	mov    (%eax),%eax
  8016af:	83 e8 04             	sub    $0x4,%eax
  8016b2:	8b 00                	mov    (%eax),%eax
  8016b4:	ba 00 00 00 00       	mov    $0x0,%edx
  8016b9:	eb 1c                	jmp    8016d7 <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  8016bb:	8b 45 08             	mov    0x8(%ebp),%eax
  8016be:	8b 00                	mov    (%eax),%eax
  8016c0:	8d 50 04             	lea    0x4(%eax),%edx
  8016c3:	8b 45 08             	mov    0x8(%ebp),%eax
  8016c6:	89 10                	mov    %edx,(%eax)
  8016c8:	8b 45 08             	mov    0x8(%ebp),%eax
  8016cb:	8b 00                	mov    (%eax),%eax
  8016cd:	83 e8 04             	sub    $0x4,%eax
  8016d0:	8b 00                	mov    (%eax),%eax
  8016d2:	ba 00 00 00 00       	mov    $0x0,%edx
}
  8016d7:	5d                   	pop    %ebp
  8016d8:	c3                   	ret    

008016d9 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  8016d9:	55                   	push   %ebp
  8016da:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  8016dc:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  8016e0:	7e 1c                	jle    8016fe <getint+0x25>
		return va_arg(*ap, long long);
  8016e2:	8b 45 08             	mov    0x8(%ebp),%eax
  8016e5:	8b 00                	mov    (%eax),%eax
  8016e7:	8d 50 08             	lea    0x8(%eax),%edx
  8016ea:	8b 45 08             	mov    0x8(%ebp),%eax
  8016ed:	89 10                	mov    %edx,(%eax)
  8016ef:	8b 45 08             	mov    0x8(%ebp),%eax
  8016f2:	8b 00                	mov    (%eax),%eax
  8016f4:	83 e8 08             	sub    $0x8,%eax
  8016f7:	8b 50 04             	mov    0x4(%eax),%edx
  8016fa:	8b 00                	mov    (%eax),%eax
  8016fc:	eb 38                	jmp    801736 <getint+0x5d>
	else if (lflag)
  8016fe:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801702:	74 1a                	je     80171e <getint+0x45>
		return va_arg(*ap, long);
  801704:	8b 45 08             	mov    0x8(%ebp),%eax
  801707:	8b 00                	mov    (%eax),%eax
  801709:	8d 50 04             	lea    0x4(%eax),%edx
  80170c:	8b 45 08             	mov    0x8(%ebp),%eax
  80170f:	89 10                	mov    %edx,(%eax)
  801711:	8b 45 08             	mov    0x8(%ebp),%eax
  801714:	8b 00                	mov    (%eax),%eax
  801716:	83 e8 04             	sub    $0x4,%eax
  801719:	8b 00                	mov    (%eax),%eax
  80171b:	99                   	cltd   
  80171c:	eb 18                	jmp    801736 <getint+0x5d>
	else
		return va_arg(*ap, int);
  80171e:	8b 45 08             	mov    0x8(%ebp),%eax
  801721:	8b 00                	mov    (%eax),%eax
  801723:	8d 50 04             	lea    0x4(%eax),%edx
  801726:	8b 45 08             	mov    0x8(%ebp),%eax
  801729:	89 10                	mov    %edx,(%eax)
  80172b:	8b 45 08             	mov    0x8(%ebp),%eax
  80172e:	8b 00                	mov    (%eax),%eax
  801730:	83 e8 04             	sub    $0x4,%eax
  801733:	8b 00                	mov    (%eax),%eax
  801735:	99                   	cltd   
}
  801736:	5d                   	pop    %ebp
  801737:	c3                   	ret    

00801738 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  801738:	55                   	push   %ebp
  801739:	89 e5                	mov    %esp,%ebp
  80173b:	56                   	push   %esi
  80173c:	53                   	push   %ebx
  80173d:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  801740:	eb 17                	jmp    801759 <vprintfmt+0x21>
			if (ch == '\0')
  801742:	85 db                	test   %ebx,%ebx
  801744:	0f 84 af 03 00 00    	je     801af9 <vprintfmt+0x3c1>
				return;
			putch(ch, putdat);
  80174a:	83 ec 08             	sub    $0x8,%esp
  80174d:	ff 75 0c             	pushl  0xc(%ebp)
  801750:	53                   	push   %ebx
  801751:	8b 45 08             	mov    0x8(%ebp),%eax
  801754:	ff d0                	call   *%eax
  801756:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  801759:	8b 45 10             	mov    0x10(%ebp),%eax
  80175c:	8d 50 01             	lea    0x1(%eax),%edx
  80175f:	89 55 10             	mov    %edx,0x10(%ebp)
  801762:	8a 00                	mov    (%eax),%al
  801764:	0f b6 d8             	movzbl %al,%ebx
  801767:	83 fb 25             	cmp    $0x25,%ebx
  80176a:	75 d6                	jne    801742 <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  80176c:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  801770:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  801777:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  80177e:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  801785:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  80178c:	8b 45 10             	mov    0x10(%ebp),%eax
  80178f:	8d 50 01             	lea    0x1(%eax),%edx
  801792:	89 55 10             	mov    %edx,0x10(%ebp)
  801795:	8a 00                	mov    (%eax),%al
  801797:	0f b6 d8             	movzbl %al,%ebx
  80179a:	8d 43 dd             	lea    -0x23(%ebx),%eax
  80179d:	83 f8 55             	cmp    $0x55,%eax
  8017a0:	0f 87 2b 03 00 00    	ja     801ad1 <vprintfmt+0x399>
  8017a6:	8b 04 85 78 48 80 00 	mov    0x804878(,%eax,4),%eax
  8017ad:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  8017af:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  8017b3:	eb d7                	jmp    80178c <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  8017b5:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  8017b9:	eb d1                	jmp    80178c <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8017bb:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  8017c2:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8017c5:	89 d0                	mov    %edx,%eax
  8017c7:	c1 e0 02             	shl    $0x2,%eax
  8017ca:	01 d0                	add    %edx,%eax
  8017cc:	01 c0                	add    %eax,%eax
  8017ce:	01 d8                	add    %ebx,%eax
  8017d0:	83 e8 30             	sub    $0x30,%eax
  8017d3:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  8017d6:	8b 45 10             	mov    0x10(%ebp),%eax
  8017d9:	8a 00                	mov    (%eax),%al
  8017db:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  8017de:	83 fb 2f             	cmp    $0x2f,%ebx
  8017e1:	7e 3e                	jle    801821 <vprintfmt+0xe9>
  8017e3:	83 fb 39             	cmp    $0x39,%ebx
  8017e6:	7f 39                	jg     801821 <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8017e8:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  8017eb:	eb d5                	jmp    8017c2 <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  8017ed:	8b 45 14             	mov    0x14(%ebp),%eax
  8017f0:	83 c0 04             	add    $0x4,%eax
  8017f3:	89 45 14             	mov    %eax,0x14(%ebp)
  8017f6:	8b 45 14             	mov    0x14(%ebp),%eax
  8017f9:	83 e8 04             	sub    $0x4,%eax
  8017fc:	8b 00                	mov    (%eax),%eax
  8017fe:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  801801:	eb 1f                	jmp    801822 <vprintfmt+0xea>

		case '.':
			if (width < 0)
  801803:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  801807:	79 83                	jns    80178c <vprintfmt+0x54>
				width = 0;
  801809:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  801810:	e9 77 ff ff ff       	jmp    80178c <vprintfmt+0x54>

		case '#':
			altflag = 1;
  801815:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  80181c:	e9 6b ff ff ff       	jmp    80178c <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  801821:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  801822:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  801826:	0f 89 60 ff ff ff    	jns    80178c <vprintfmt+0x54>
				width = precision, precision = -1;
  80182c:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80182f:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  801832:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  801839:	e9 4e ff ff ff       	jmp    80178c <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  80183e:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  801841:	e9 46 ff ff ff       	jmp    80178c <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  801846:	8b 45 14             	mov    0x14(%ebp),%eax
  801849:	83 c0 04             	add    $0x4,%eax
  80184c:	89 45 14             	mov    %eax,0x14(%ebp)
  80184f:	8b 45 14             	mov    0x14(%ebp),%eax
  801852:	83 e8 04             	sub    $0x4,%eax
  801855:	8b 00                	mov    (%eax),%eax
  801857:	83 ec 08             	sub    $0x8,%esp
  80185a:	ff 75 0c             	pushl  0xc(%ebp)
  80185d:	50                   	push   %eax
  80185e:	8b 45 08             	mov    0x8(%ebp),%eax
  801861:	ff d0                	call   *%eax
  801863:	83 c4 10             	add    $0x10,%esp
			break;
  801866:	e9 89 02 00 00       	jmp    801af4 <vprintfmt+0x3bc>

		// error message
		case 'e':
			err = va_arg(ap, int);
  80186b:	8b 45 14             	mov    0x14(%ebp),%eax
  80186e:	83 c0 04             	add    $0x4,%eax
  801871:	89 45 14             	mov    %eax,0x14(%ebp)
  801874:	8b 45 14             	mov    0x14(%ebp),%eax
  801877:	83 e8 04             	sub    $0x4,%eax
  80187a:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  80187c:	85 db                	test   %ebx,%ebx
  80187e:	79 02                	jns    801882 <vprintfmt+0x14a>
				err = -err;
  801880:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  801882:	83 fb 64             	cmp    $0x64,%ebx
  801885:	7f 0b                	jg     801892 <vprintfmt+0x15a>
  801887:	8b 34 9d c0 46 80 00 	mov    0x8046c0(,%ebx,4),%esi
  80188e:	85 f6                	test   %esi,%esi
  801890:	75 19                	jne    8018ab <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  801892:	53                   	push   %ebx
  801893:	68 65 48 80 00       	push   $0x804865
  801898:	ff 75 0c             	pushl  0xc(%ebp)
  80189b:	ff 75 08             	pushl  0x8(%ebp)
  80189e:	e8 5e 02 00 00       	call   801b01 <printfmt>
  8018a3:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  8018a6:	e9 49 02 00 00       	jmp    801af4 <vprintfmt+0x3bc>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  8018ab:	56                   	push   %esi
  8018ac:	68 6e 48 80 00       	push   $0x80486e
  8018b1:	ff 75 0c             	pushl  0xc(%ebp)
  8018b4:	ff 75 08             	pushl  0x8(%ebp)
  8018b7:	e8 45 02 00 00       	call   801b01 <printfmt>
  8018bc:	83 c4 10             	add    $0x10,%esp
			break;
  8018bf:	e9 30 02 00 00       	jmp    801af4 <vprintfmt+0x3bc>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  8018c4:	8b 45 14             	mov    0x14(%ebp),%eax
  8018c7:	83 c0 04             	add    $0x4,%eax
  8018ca:	89 45 14             	mov    %eax,0x14(%ebp)
  8018cd:	8b 45 14             	mov    0x14(%ebp),%eax
  8018d0:	83 e8 04             	sub    $0x4,%eax
  8018d3:	8b 30                	mov    (%eax),%esi
  8018d5:	85 f6                	test   %esi,%esi
  8018d7:	75 05                	jne    8018de <vprintfmt+0x1a6>
				p = "(null)";
  8018d9:	be 71 48 80 00       	mov    $0x804871,%esi
			if (width > 0 && padc != '-')
  8018de:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8018e2:	7e 6d                	jle    801951 <vprintfmt+0x219>
  8018e4:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  8018e8:	74 67                	je     801951 <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  8018ea:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8018ed:	83 ec 08             	sub    $0x8,%esp
  8018f0:	50                   	push   %eax
  8018f1:	56                   	push   %esi
  8018f2:	e8 0c 03 00 00       	call   801c03 <strnlen>
  8018f7:	83 c4 10             	add    $0x10,%esp
  8018fa:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  8018fd:	eb 16                	jmp    801915 <vprintfmt+0x1dd>
					putch(padc, putdat);
  8018ff:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  801903:	83 ec 08             	sub    $0x8,%esp
  801906:	ff 75 0c             	pushl  0xc(%ebp)
  801909:	50                   	push   %eax
  80190a:	8b 45 08             	mov    0x8(%ebp),%eax
  80190d:	ff d0                	call   *%eax
  80190f:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  801912:	ff 4d e4             	decl   -0x1c(%ebp)
  801915:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  801919:	7f e4                	jg     8018ff <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  80191b:	eb 34                	jmp    801951 <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  80191d:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  801921:	74 1c                	je     80193f <vprintfmt+0x207>
  801923:	83 fb 1f             	cmp    $0x1f,%ebx
  801926:	7e 05                	jle    80192d <vprintfmt+0x1f5>
  801928:	83 fb 7e             	cmp    $0x7e,%ebx
  80192b:	7e 12                	jle    80193f <vprintfmt+0x207>
					putch('?', putdat);
  80192d:	83 ec 08             	sub    $0x8,%esp
  801930:	ff 75 0c             	pushl  0xc(%ebp)
  801933:	6a 3f                	push   $0x3f
  801935:	8b 45 08             	mov    0x8(%ebp),%eax
  801938:	ff d0                	call   *%eax
  80193a:	83 c4 10             	add    $0x10,%esp
  80193d:	eb 0f                	jmp    80194e <vprintfmt+0x216>
				else
					putch(ch, putdat);
  80193f:	83 ec 08             	sub    $0x8,%esp
  801942:	ff 75 0c             	pushl  0xc(%ebp)
  801945:	53                   	push   %ebx
  801946:	8b 45 08             	mov    0x8(%ebp),%eax
  801949:	ff d0                	call   *%eax
  80194b:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  80194e:	ff 4d e4             	decl   -0x1c(%ebp)
  801951:	89 f0                	mov    %esi,%eax
  801953:	8d 70 01             	lea    0x1(%eax),%esi
  801956:	8a 00                	mov    (%eax),%al
  801958:	0f be d8             	movsbl %al,%ebx
  80195b:	85 db                	test   %ebx,%ebx
  80195d:	74 24                	je     801983 <vprintfmt+0x24b>
  80195f:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  801963:	78 b8                	js     80191d <vprintfmt+0x1e5>
  801965:	ff 4d e0             	decl   -0x20(%ebp)
  801968:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80196c:	79 af                	jns    80191d <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  80196e:	eb 13                	jmp    801983 <vprintfmt+0x24b>
				putch(' ', putdat);
  801970:	83 ec 08             	sub    $0x8,%esp
  801973:	ff 75 0c             	pushl  0xc(%ebp)
  801976:	6a 20                	push   $0x20
  801978:	8b 45 08             	mov    0x8(%ebp),%eax
  80197b:	ff d0                	call   *%eax
  80197d:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  801980:	ff 4d e4             	decl   -0x1c(%ebp)
  801983:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  801987:	7f e7                	jg     801970 <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  801989:	e9 66 01 00 00       	jmp    801af4 <vprintfmt+0x3bc>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  80198e:	83 ec 08             	sub    $0x8,%esp
  801991:	ff 75 e8             	pushl  -0x18(%ebp)
  801994:	8d 45 14             	lea    0x14(%ebp),%eax
  801997:	50                   	push   %eax
  801998:	e8 3c fd ff ff       	call   8016d9 <getint>
  80199d:	83 c4 10             	add    $0x10,%esp
  8019a0:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8019a3:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  8019a6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8019a9:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8019ac:	85 d2                	test   %edx,%edx
  8019ae:	79 23                	jns    8019d3 <vprintfmt+0x29b>
				putch('-', putdat);
  8019b0:	83 ec 08             	sub    $0x8,%esp
  8019b3:	ff 75 0c             	pushl  0xc(%ebp)
  8019b6:	6a 2d                	push   $0x2d
  8019b8:	8b 45 08             	mov    0x8(%ebp),%eax
  8019bb:	ff d0                	call   *%eax
  8019bd:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  8019c0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8019c3:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8019c6:	f7 d8                	neg    %eax
  8019c8:	83 d2 00             	adc    $0x0,%edx
  8019cb:	f7 da                	neg    %edx
  8019cd:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8019d0:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  8019d3:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  8019da:	e9 bc 00 00 00       	jmp    801a9b <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  8019df:	83 ec 08             	sub    $0x8,%esp
  8019e2:	ff 75 e8             	pushl  -0x18(%ebp)
  8019e5:	8d 45 14             	lea    0x14(%ebp),%eax
  8019e8:	50                   	push   %eax
  8019e9:	e8 84 fc ff ff       	call   801672 <getuint>
  8019ee:	83 c4 10             	add    $0x10,%esp
  8019f1:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8019f4:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  8019f7:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  8019fe:	e9 98 00 00 00       	jmp    801a9b <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  801a03:	83 ec 08             	sub    $0x8,%esp
  801a06:	ff 75 0c             	pushl  0xc(%ebp)
  801a09:	6a 58                	push   $0x58
  801a0b:	8b 45 08             	mov    0x8(%ebp),%eax
  801a0e:	ff d0                	call   *%eax
  801a10:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  801a13:	83 ec 08             	sub    $0x8,%esp
  801a16:	ff 75 0c             	pushl  0xc(%ebp)
  801a19:	6a 58                	push   $0x58
  801a1b:	8b 45 08             	mov    0x8(%ebp),%eax
  801a1e:	ff d0                	call   *%eax
  801a20:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  801a23:	83 ec 08             	sub    $0x8,%esp
  801a26:	ff 75 0c             	pushl  0xc(%ebp)
  801a29:	6a 58                	push   $0x58
  801a2b:	8b 45 08             	mov    0x8(%ebp),%eax
  801a2e:	ff d0                	call   *%eax
  801a30:	83 c4 10             	add    $0x10,%esp
			break;
  801a33:	e9 bc 00 00 00       	jmp    801af4 <vprintfmt+0x3bc>

		// pointer
		case 'p':
			putch('0', putdat);
  801a38:	83 ec 08             	sub    $0x8,%esp
  801a3b:	ff 75 0c             	pushl  0xc(%ebp)
  801a3e:	6a 30                	push   $0x30
  801a40:	8b 45 08             	mov    0x8(%ebp),%eax
  801a43:	ff d0                	call   *%eax
  801a45:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  801a48:	83 ec 08             	sub    $0x8,%esp
  801a4b:	ff 75 0c             	pushl  0xc(%ebp)
  801a4e:	6a 78                	push   $0x78
  801a50:	8b 45 08             	mov    0x8(%ebp),%eax
  801a53:	ff d0                	call   *%eax
  801a55:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  801a58:	8b 45 14             	mov    0x14(%ebp),%eax
  801a5b:	83 c0 04             	add    $0x4,%eax
  801a5e:	89 45 14             	mov    %eax,0x14(%ebp)
  801a61:	8b 45 14             	mov    0x14(%ebp),%eax
  801a64:	83 e8 04             	sub    $0x4,%eax
  801a67:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  801a69:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801a6c:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  801a73:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  801a7a:	eb 1f                	jmp    801a9b <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  801a7c:	83 ec 08             	sub    $0x8,%esp
  801a7f:	ff 75 e8             	pushl  -0x18(%ebp)
  801a82:	8d 45 14             	lea    0x14(%ebp),%eax
  801a85:	50                   	push   %eax
  801a86:	e8 e7 fb ff ff       	call   801672 <getuint>
  801a8b:	83 c4 10             	add    $0x10,%esp
  801a8e:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801a91:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  801a94:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  801a9b:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  801a9f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801aa2:	83 ec 04             	sub    $0x4,%esp
  801aa5:	52                   	push   %edx
  801aa6:	ff 75 e4             	pushl  -0x1c(%ebp)
  801aa9:	50                   	push   %eax
  801aaa:	ff 75 f4             	pushl  -0xc(%ebp)
  801aad:	ff 75 f0             	pushl  -0x10(%ebp)
  801ab0:	ff 75 0c             	pushl  0xc(%ebp)
  801ab3:	ff 75 08             	pushl  0x8(%ebp)
  801ab6:	e8 00 fb ff ff       	call   8015bb <printnum>
  801abb:	83 c4 20             	add    $0x20,%esp
			break;
  801abe:	eb 34                	jmp    801af4 <vprintfmt+0x3bc>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  801ac0:	83 ec 08             	sub    $0x8,%esp
  801ac3:	ff 75 0c             	pushl  0xc(%ebp)
  801ac6:	53                   	push   %ebx
  801ac7:	8b 45 08             	mov    0x8(%ebp),%eax
  801aca:	ff d0                	call   *%eax
  801acc:	83 c4 10             	add    $0x10,%esp
			break;
  801acf:	eb 23                	jmp    801af4 <vprintfmt+0x3bc>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  801ad1:	83 ec 08             	sub    $0x8,%esp
  801ad4:	ff 75 0c             	pushl  0xc(%ebp)
  801ad7:	6a 25                	push   $0x25
  801ad9:	8b 45 08             	mov    0x8(%ebp),%eax
  801adc:	ff d0                	call   *%eax
  801ade:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  801ae1:	ff 4d 10             	decl   0x10(%ebp)
  801ae4:	eb 03                	jmp    801ae9 <vprintfmt+0x3b1>
  801ae6:	ff 4d 10             	decl   0x10(%ebp)
  801ae9:	8b 45 10             	mov    0x10(%ebp),%eax
  801aec:	48                   	dec    %eax
  801aed:	8a 00                	mov    (%eax),%al
  801aef:	3c 25                	cmp    $0x25,%al
  801af1:	75 f3                	jne    801ae6 <vprintfmt+0x3ae>
				/* do nothing */;
			break;
  801af3:	90                   	nop
		}
	}
  801af4:	e9 47 fc ff ff       	jmp    801740 <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  801af9:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  801afa:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801afd:	5b                   	pop    %ebx
  801afe:	5e                   	pop    %esi
  801aff:	5d                   	pop    %ebp
  801b00:	c3                   	ret    

00801b01 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  801b01:	55                   	push   %ebp
  801b02:	89 e5                	mov    %esp,%ebp
  801b04:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  801b07:	8d 45 10             	lea    0x10(%ebp),%eax
  801b0a:	83 c0 04             	add    $0x4,%eax
  801b0d:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  801b10:	8b 45 10             	mov    0x10(%ebp),%eax
  801b13:	ff 75 f4             	pushl  -0xc(%ebp)
  801b16:	50                   	push   %eax
  801b17:	ff 75 0c             	pushl  0xc(%ebp)
  801b1a:	ff 75 08             	pushl  0x8(%ebp)
  801b1d:	e8 16 fc ff ff       	call   801738 <vprintfmt>
  801b22:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  801b25:	90                   	nop
  801b26:	c9                   	leave  
  801b27:	c3                   	ret    

00801b28 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  801b28:	55                   	push   %ebp
  801b29:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  801b2b:	8b 45 0c             	mov    0xc(%ebp),%eax
  801b2e:	8b 40 08             	mov    0x8(%eax),%eax
  801b31:	8d 50 01             	lea    0x1(%eax),%edx
  801b34:	8b 45 0c             	mov    0xc(%ebp),%eax
  801b37:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  801b3a:	8b 45 0c             	mov    0xc(%ebp),%eax
  801b3d:	8b 10                	mov    (%eax),%edx
  801b3f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801b42:	8b 40 04             	mov    0x4(%eax),%eax
  801b45:	39 c2                	cmp    %eax,%edx
  801b47:	73 12                	jae    801b5b <sprintputch+0x33>
		*b->buf++ = ch;
  801b49:	8b 45 0c             	mov    0xc(%ebp),%eax
  801b4c:	8b 00                	mov    (%eax),%eax
  801b4e:	8d 48 01             	lea    0x1(%eax),%ecx
  801b51:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b54:	89 0a                	mov    %ecx,(%edx)
  801b56:	8b 55 08             	mov    0x8(%ebp),%edx
  801b59:	88 10                	mov    %dl,(%eax)
}
  801b5b:	90                   	nop
  801b5c:	5d                   	pop    %ebp
  801b5d:	c3                   	ret    

00801b5e <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  801b5e:	55                   	push   %ebp
  801b5f:	89 e5                	mov    %esp,%ebp
  801b61:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  801b64:	8b 45 08             	mov    0x8(%ebp),%eax
  801b67:	89 45 ec             	mov    %eax,-0x14(%ebp)
  801b6a:	8b 45 0c             	mov    0xc(%ebp),%eax
  801b6d:	8d 50 ff             	lea    -0x1(%eax),%edx
  801b70:	8b 45 08             	mov    0x8(%ebp),%eax
  801b73:	01 d0                	add    %edx,%eax
  801b75:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801b78:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  801b7f:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801b83:	74 06                	je     801b8b <vsnprintf+0x2d>
  801b85:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801b89:	7f 07                	jg     801b92 <vsnprintf+0x34>
		return -E_INVAL;
  801b8b:	b8 03 00 00 00       	mov    $0x3,%eax
  801b90:	eb 20                	jmp    801bb2 <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  801b92:	ff 75 14             	pushl  0x14(%ebp)
  801b95:	ff 75 10             	pushl  0x10(%ebp)
  801b98:	8d 45 ec             	lea    -0x14(%ebp),%eax
  801b9b:	50                   	push   %eax
  801b9c:	68 28 1b 80 00       	push   $0x801b28
  801ba1:	e8 92 fb ff ff       	call   801738 <vprintfmt>
  801ba6:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  801ba9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801bac:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  801baf:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  801bb2:	c9                   	leave  
  801bb3:	c3                   	ret    

00801bb4 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  801bb4:	55                   	push   %ebp
  801bb5:	89 e5                	mov    %esp,%ebp
  801bb7:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  801bba:	8d 45 10             	lea    0x10(%ebp),%eax
  801bbd:	83 c0 04             	add    $0x4,%eax
  801bc0:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  801bc3:	8b 45 10             	mov    0x10(%ebp),%eax
  801bc6:	ff 75 f4             	pushl  -0xc(%ebp)
  801bc9:	50                   	push   %eax
  801bca:	ff 75 0c             	pushl  0xc(%ebp)
  801bcd:	ff 75 08             	pushl  0x8(%ebp)
  801bd0:	e8 89 ff ff ff       	call   801b5e <vsnprintf>
  801bd5:	83 c4 10             	add    $0x10,%esp
  801bd8:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  801bdb:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801bde:	c9                   	leave  
  801bdf:	c3                   	ret    

00801be0 <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  801be0:	55                   	push   %ebp
  801be1:	89 e5                	mov    %esp,%ebp
  801be3:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  801be6:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801bed:	eb 06                	jmp    801bf5 <strlen+0x15>
		n++;
  801bef:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  801bf2:	ff 45 08             	incl   0x8(%ebp)
  801bf5:	8b 45 08             	mov    0x8(%ebp),%eax
  801bf8:	8a 00                	mov    (%eax),%al
  801bfa:	84 c0                	test   %al,%al
  801bfc:	75 f1                	jne    801bef <strlen+0xf>
		n++;
	return n;
  801bfe:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  801c01:	c9                   	leave  
  801c02:	c3                   	ret    

00801c03 <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  801c03:	55                   	push   %ebp
  801c04:	89 e5                	mov    %esp,%ebp
  801c06:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  801c09:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801c10:	eb 09                	jmp    801c1b <strnlen+0x18>
		n++;
  801c12:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  801c15:	ff 45 08             	incl   0x8(%ebp)
  801c18:	ff 4d 0c             	decl   0xc(%ebp)
  801c1b:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801c1f:	74 09                	je     801c2a <strnlen+0x27>
  801c21:	8b 45 08             	mov    0x8(%ebp),%eax
  801c24:	8a 00                	mov    (%eax),%al
  801c26:	84 c0                	test   %al,%al
  801c28:	75 e8                	jne    801c12 <strnlen+0xf>
		n++;
	return n;
  801c2a:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  801c2d:	c9                   	leave  
  801c2e:	c3                   	ret    

00801c2f <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  801c2f:	55                   	push   %ebp
  801c30:	89 e5                	mov    %esp,%ebp
  801c32:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  801c35:	8b 45 08             	mov    0x8(%ebp),%eax
  801c38:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  801c3b:	90                   	nop
  801c3c:	8b 45 08             	mov    0x8(%ebp),%eax
  801c3f:	8d 50 01             	lea    0x1(%eax),%edx
  801c42:	89 55 08             	mov    %edx,0x8(%ebp)
  801c45:	8b 55 0c             	mov    0xc(%ebp),%edx
  801c48:	8d 4a 01             	lea    0x1(%edx),%ecx
  801c4b:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  801c4e:	8a 12                	mov    (%edx),%dl
  801c50:	88 10                	mov    %dl,(%eax)
  801c52:	8a 00                	mov    (%eax),%al
  801c54:	84 c0                	test   %al,%al
  801c56:	75 e4                	jne    801c3c <strcpy+0xd>
		/* do nothing */;
	return ret;
  801c58:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  801c5b:	c9                   	leave  
  801c5c:	c3                   	ret    

00801c5d <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  801c5d:	55                   	push   %ebp
  801c5e:	89 e5                	mov    %esp,%ebp
  801c60:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  801c63:	8b 45 08             	mov    0x8(%ebp),%eax
  801c66:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  801c69:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801c70:	eb 1f                	jmp    801c91 <strncpy+0x34>
		*dst++ = *src;
  801c72:	8b 45 08             	mov    0x8(%ebp),%eax
  801c75:	8d 50 01             	lea    0x1(%eax),%edx
  801c78:	89 55 08             	mov    %edx,0x8(%ebp)
  801c7b:	8b 55 0c             	mov    0xc(%ebp),%edx
  801c7e:	8a 12                	mov    (%edx),%dl
  801c80:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  801c82:	8b 45 0c             	mov    0xc(%ebp),%eax
  801c85:	8a 00                	mov    (%eax),%al
  801c87:	84 c0                	test   %al,%al
  801c89:	74 03                	je     801c8e <strncpy+0x31>
			src++;
  801c8b:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  801c8e:	ff 45 fc             	incl   -0x4(%ebp)
  801c91:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801c94:	3b 45 10             	cmp    0x10(%ebp),%eax
  801c97:	72 d9                	jb     801c72 <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  801c99:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  801c9c:	c9                   	leave  
  801c9d:	c3                   	ret    

00801c9e <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  801c9e:	55                   	push   %ebp
  801c9f:	89 e5                	mov    %esp,%ebp
  801ca1:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  801ca4:	8b 45 08             	mov    0x8(%ebp),%eax
  801ca7:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  801caa:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801cae:	74 30                	je     801ce0 <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  801cb0:	eb 16                	jmp    801cc8 <strlcpy+0x2a>
			*dst++ = *src++;
  801cb2:	8b 45 08             	mov    0x8(%ebp),%eax
  801cb5:	8d 50 01             	lea    0x1(%eax),%edx
  801cb8:	89 55 08             	mov    %edx,0x8(%ebp)
  801cbb:	8b 55 0c             	mov    0xc(%ebp),%edx
  801cbe:	8d 4a 01             	lea    0x1(%edx),%ecx
  801cc1:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  801cc4:	8a 12                	mov    (%edx),%dl
  801cc6:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  801cc8:	ff 4d 10             	decl   0x10(%ebp)
  801ccb:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801ccf:	74 09                	je     801cda <strlcpy+0x3c>
  801cd1:	8b 45 0c             	mov    0xc(%ebp),%eax
  801cd4:	8a 00                	mov    (%eax),%al
  801cd6:	84 c0                	test   %al,%al
  801cd8:	75 d8                	jne    801cb2 <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  801cda:	8b 45 08             	mov    0x8(%ebp),%eax
  801cdd:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  801ce0:	8b 55 08             	mov    0x8(%ebp),%edx
  801ce3:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801ce6:	29 c2                	sub    %eax,%edx
  801ce8:	89 d0                	mov    %edx,%eax
}
  801cea:	c9                   	leave  
  801ceb:	c3                   	ret    

00801cec <strcmp>:

int
strcmp(const char *p, const char *q)
{
  801cec:	55                   	push   %ebp
  801ced:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  801cef:	eb 06                	jmp    801cf7 <strcmp+0xb>
		p++, q++;
  801cf1:	ff 45 08             	incl   0x8(%ebp)
  801cf4:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  801cf7:	8b 45 08             	mov    0x8(%ebp),%eax
  801cfa:	8a 00                	mov    (%eax),%al
  801cfc:	84 c0                	test   %al,%al
  801cfe:	74 0e                	je     801d0e <strcmp+0x22>
  801d00:	8b 45 08             	mov    0x8(%ebp),%eax
  801d03:	8a 10                	mov    (%eax),%dl
  801d05:	8b 45 0c             	mov    0xc(%ebp),%eax
  801d08:	8a 00                	mov    (%eax),%al
  801d0a:	38 c2                	cmp    %al,%dl
  801d0c:	74 e3                	je     801cf1 <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  801d0e:	8b 45 08             	mov    0x8(%ebp),%eax
  801d11:	8a 00                	mov    (%eax),%al
  801d13:	0f b6 d0             	movzbl %al,%edx
  801d16:	8b 45 0c             	mov    0xc(%ebp),%eax
  801d19:	8a 00                	mov    (%eax),%al
  801d1b:	0f b6 c0             	movzbl %al,%eax
  801d1e:	29 c2                	sub    %eax,%edx
  801d20:	89 d0                	mov    %edx,%eax
}
  801d22:	5d                   	pop    %ebp
  801d23:	c3                   	ret    

00801d24 <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  801d24:	55                   	push   %ebp
  801d25:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  801d27:	eb 09                	jmp    801d32 <strncmp+0xe>
		n--, p++, q++;
  801d29:	ff 4d 10             	decl   0x10(%ebp)
  801d2c:	ff 45 08             	incl   0x8(%ebp)
  801d2f:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  801d32:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801d36:	74 17                	je     801d4f <strncmp+0x2b>
  801d38:	8b 45 08             	mov    0x8(%ebp),%eax
  801d3b:	8a 00                	mov    (%eax),%al
  801d3d:	84 c0                	test   %al,%al
  801d3f:	74 0e                	je     801d4f <strncmp+0x2b>
  801d41:	8b 45 08             	mov    0x8(%ebp),%eax
  801d44:	8a 10                	mov    (%eax),%dl
  801d46:	8b 45 0c             	mov    0xc(%ebp),%eax
  801d49:	8a 00                	mov    (%eax),%al
  801d4b:	38 c2                	cmp    %al,%dl
  801d4d:	74 da                	je     801d29 <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  801d4f:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801d53:	75 07                	jne    801d5c <strncmp+0x38>
		return 0;
  801d55:	b8 00 00 00 00       	mov    $0x0,%eax
  801d5a:	eb 14                	jmp    801d70 <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  801d5c:	8b 45 08             	mov    0x8(%ebp),%eax
  801d5f:	8a 00                	mov    (%eax),%al
  801d61:	0f b6 d0             	movzbl %al,%edx
  801d64:	8b 45 0c             	mov    0xc(%ebp),%eax
  801d67:	8a 00                	mov    (%eax),%al
  801d69:	0f b6 c0             	movzbl %al,%eax
  801d6c:	29 c2                	sub    %eax,%edx
  801d6e:	89 d0                	mov    %edx,%eax
}
  801d70:	5d                   	pop    %ebp
  801d71:	c3                   	ret    

00801d72 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  801d72:	55                   	push   %ebp
  801d73:	89 e5                	mov    %esp,%ebp
  801d75:	83 ec 04             	sub    $0x4,%esp
  801d78:	8b 45 0c             	mov    0xc(%ebp),%eax
  801d7b:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  801d7e:	eb 12                	jmp    801d92 <strchr+0x20>
		if (*s == c)
  801d80:	8b 45 08             	mov    0x8(%ebp),%eax
  801d83:	8a 00                	mov    (%eax),%al
  801d85:	3a 45 fc             	cmp    -0x4(%ebp),%al
  801d88:	75 05                	jne    801d8f <strchr+0x1d>
			return (char *) s;
  801d8a:	8b 45 08             	mov    0x8(%ebp),%eax
  801d8d:	eb 11                	jmp    801da0 <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  801d8f:	ff 45 08             	incl   0x8(%ebp)
  801d92:	8b 45 08             	mov    0x8(%ebp),%eax
  801d95:	8a 00                	mov    (%eax),%al
  801d97:	84 c0                	test   %al,%al
  801d99:	75 e5                	jne    801d80 <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  801d9b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801da0:	c9                   	leave  
  801da1:	c3                   	ret    

00801da2 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  801da2:	55                   	push   %ebp
  801da3:	89 e5                	mov    %esp,%ebp
  801da5:	83 ec 04             	sub    $0x4,%esp
  801da8:	8b 45 0c             	mov    0xc(%ebp),%eax
  801dab:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  801dae:	eb 0d                	jmp    801dbd <strfind+0x1b>
		if (*s == c)
  801db0:	8b 45 08             	mov    0x8(%ebp),%eax
  801db3:	8a 00                	mov    (%eax),%al
  801db5:	3a 45 fc             	cmp    -0x4(%ebp),%al
  801db8:	74 0e                	je     801dc8 <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  801dba:	ff 45 08             	incl   0x8(%ebp)
  801dbd:	8b 45 08             	mov    0x8(%ebp),%eax
  801dc0:	8a 00                	mov    (%eax),%al
  801dc2:	84 c0                	test   %al,%al
  801dc4:	75 ea                	jne    801db0 <strfind+0xe>
  801dc6:	eb 01                	jmp    801dc9 <strfind+0x27>
		if (*s == c)
			break;
  801dc8:	90                   	nop
	return (char *) s;
  801dc9:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801dcc:	c9                   	leave  
  801dcd:	c3                   	ret    

00801dce <memset>:


void *
memset(void *v, int c, uint32 n)
{
  801dce:	55                   	push   %ebp
  801dcf:	89 e5                	mov    %esp,%ebp
  801dd1:	83 ec 10             	sub    $0x10,%esp
	char *p;
	int m;

	p = v;
  801dd4:	8b 45 08             	mov    0x8(%ebp),%eax
  801dd7:	89 45 fc             	mov    %eax,-0x4(%ebp)
	m = n;
  801dda:	8b 45 10             	mov    0x10(%ebp),%eax
  801ddd:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (--m >= 0)
  801de0:	eb 0e                	jmp    801df0 <memset+0x22>
		*p++ = c;
  801de2:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801de5:	8d 50 01             	lea    0x1(%eax),%edx
  801de8:	89 55 fc             	mov    %edx,-0x4(%ebp)
  801deb:	8b 55 0c             	mov    0xc(%ebp),%edx
  801dee:	88 10                	mov    %dl,(%eax)
	char *p;
	int m;

	p = v;
	m = n;
	while (--m >= 0)
  801df0:	ff 4d f8             	decl   -0x8(%ebp)
  801df3:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  801df7:	79 e9                	jns    801de2 <memset+0x14>
		*p++ = c;

	return v;
  801df9:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801dfc:	c9                   	leave  
  801dfd:	c3                   	ret    

00801dfe <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  801dfe:	55                   	push   %ebp
  801dff:	89 e5                	mov    %esp,%ebp
  801e01:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  801e04:	8b 45 0c             	mov    0xc(%ebp),%eax
  801e07:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  801e0a:	8b 45 08             	mov    0x8(%ebp),%eax
  801e0d:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (n-- > 0)
  801e10:	eb 16                	jmp    801e28 <memcpy+0x2a>
		*d++ = *s++;
  801e12:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801e15:	8d 50 01             	lea    0x1(%eax),%edx
  801e18:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801e1b:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801e1e:	8d 4a 01             	lea    0x1(%edx),%ecx
  801e21:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  801e24:	8a 12                	mov    (%edx),%dl
  801e26:	88 10                	mov    %dl,(%eax)
	const char *s;
	char *d;

	s = src;
	d = dst;
	while (n-- > 0)
  801e28:	8b 45 10             	mov    0x10(%ebp),%eax
  801e2b:	8d 50 ff             	lea    -0x1(%eax),%edx
  801e2e:	89 55 10             	mov    %edx,0x10(%ebp)
  801e31:	85 c0                	test   %eax,%eax
  801e33:	75 dd                	jne    801e12 <memcpy+0x14>
		*d++ = *s++;

	return dst;
  801e35:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801e38:	c9                   	leave  
  801e39:	c3                   	ret    

00801e3a <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  801e3a:	55                   	push   %ebp
  801e3b:	89 e5                	mov    %esp,%ebp
  801e3d:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  801e40:	8b 45 0c             	mov    0xc(%ebp),%eax
  801e43:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  801e46:	8b 45 08             	mov    0x8(%ebp),%eax
  801e49:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  801e4c:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801e4f:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  801e52:	73 50                	jae    801ea4 <memmove+0x6a>
  801e54:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801e57:	8b 45 10             	mov    0x10(%ebp),%eax
  801e5a:	01 d0                	add    %edx,%eax
  801e5c:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  801e5f:	76 43                	jbe    801ea4 <memmove+0x6a>
		s += n;
  801e61:	8b 45 10             	mov    0x10(%ebp),%eax
  801e64:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  801e67:	8b 45 10             	mov    0x10(%ebp),%eax
  801e6a:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  801e6d:	eb 10                	jmp    801e7f <memmove+0x45>
			*--d = *--s;
  801e6f:	ff 4d f8             	decl   -0x8(%ebp)
  801e72:	ff 4d fc             	decl   -0x4(%ebp)
  801e75:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801e78:	8a 10                	mov    (%eax),%dl
  801e7a:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801e7d:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  801e7f:	8b 45 10             	mov    0x10(%ebp),%eax
  801e82:	8d 50 ff             	lea    -0x1(%eax),%edx
  801e85:	89 55 10             	mov    %edx,0x10(%ebp)
  801e88:	85 c0                	test   %eax,%eax
  801e8a:	75 e3                	jne    801e6f <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  801e8c:	eb 23                	jmp    801eb1 <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  801e8e:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801e91:	8d 50 01             	lea    0x1(%eax),%edx
  801e94:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801e97:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801e9a:	8d 4a 01             	lea    0x1(%edx),%ecx
  801e9d:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  801ea0:	8a 12                	mov    (%edx),%dl
  801ea2:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  801ea4:	8b 45 10             	mov    0x10(%ebp),%eax
  801ea7:	8d 50 ff             	lea    -0x1(%eax),%edx
  801eaa:	89 55 10             	mov    %edx,0x10(%ebp)
  801ead:	85 c0                	test   %eax,%eax
  801eaf:	75 dd                	jne    801e8e <memmove+0x54>
			*d++ = *s++;

	return dst;
  801eb1:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801eb4:	c9                   	leave  
  801eb5:	c3                   	ret    

00801eb6 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  801eb6:	55                   	push   %ebp
  801eb7:	89 e5                	mov    %esp,%ebp
  801eb9:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  801ebc:	8b 45 08             	mov    0x8(%ebp),%eax
  801ebf:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  801ec2:	8b 45 0c             	mov    0xc(%ebp),%eax
  801ec5:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  801ec8:	eb 2a                	jmp    801ef4 <memcmp+0x3e>
		if (*s1 != *s2)
  801eca:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801ecd:	8a 10                	mov    (%eax),%dl
  801ecf:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801ed2:	8a 00                	mov    (%eax),%al
  801ed4:	38 c2                	cmp    %al,%dl
  801ed6:	74 16                	je     801eee <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  801ed8:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801edb:	8a 00                	mov    (%eax),%al
  801edd:	0f b6 d0             	movzbl %al,%edx
  801ee0:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801ee3:	8a 00                	mov    (%eax),%al
  801ee5:	0f b6 c0             	movzbl %al,%eax
  801ee8:	29 c2                	sub    %eax,%edx
  801eea:	89 d0                	mov    %edx,%eax
  801eec:	eb 18                	jmp    801f06 <memcmp+0x50>
		s1++, s2++;
  801eee:	ff 45 fc             	incl   -0x4(%ebp)
  801ef1:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  801ef4:	8b 45 10             	mov    0x10(%ebp),%eax
  801ef7:	8d 50 ff             	lea    -0x1(%eax),%edx
  801efa:	89 55 10             	mov    %edx,0x10(%ebp)
  801efd:	85 c0                	test   %eax,%eax
  801eff:	75 c9                	jne    801eca <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  801f01:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801f06:	c9                   	leave  
  801f07:	c3                   	ret    

00801f08 <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  801f08:	55                   	push   %ebp
  801f09:	89 e5                	mov    %esp,%ebp
  801f0b:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  801f0e:	8b 55 08             	mov    0x8(%ebp),%edx
  801f11:	8b 45 10             	mov    0x10(%ebp),%eax
  801f14:	01 d0                	add    %edx,%eax
  801f16:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  801f19:	eb 15                	jmp    801f30 <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  801f1b:	8b 45 08             	mov    0x8(%ebp),%eax
  801f1e:	8a 00                	mov    (%eax),%al
  801f20:	0f b6 d0             	movzbl %al,%edx
  801f23:	8b 45 0c             	mov    0xc(%ebp),%eax
  801f26:	0f b6 c0             	movzbl %al,%eax
  801f29:	39 c2                	cmp    %eax,%edx
  801f2b:	74 0d                	je     801f3a <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  801f2d:	ff 45 08             	incl   0x8(%ebp)
  801f30:	8b 45 08             	mov    0x8(%ebp),%eax
  801f33:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  801f36:	72 e3                	jb     801f1b <memfind+0x13>
  801f38:	eb 01                	jmp    801f3b <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  801f3a:	90                   	nop
	return (void *) s;
  801f3b:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801f3e:	c9                   	leave  
  801f3f:	c3                   	ret    

00801f40 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  801f40:	55                   	push   %ebp
  801f41:	89 e5                	mov    %esp,%ebp
  801f43:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  801f46:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  801f4d:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801f54:	eb 03                	jmp    801f59 <strtol+0x19>
		s++;
  801f56:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801f59:	8b 45 08             	mov    0x8(%ebp),%eax
  801f5c:	8a 00                	mov    (%eax),%al
  801f5e:	3c 20                	cmp    $0x20,%al
  801f60:	74 f4                	je     801f56 <strtol+0x16>
  801f62:	8b 45 08             	mov    0x8(%ebp),%eax
  801f65:	8a 00                	mov    (%eax),%al
  801f67:	3c 09                	cmp    $0x9,%al
  801f69:	74 eb                	je     801f56 <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  801f6b:	8b 45 08             	mov    0x8(%ebp),%eax
  801f6e:	8a 00                	mov    (%eax),%al
  801f70:	3c 2b                	cmp    $0x2b,%al
  801f72:	75 05                	jne    801f79 <strtol+0x39>
		s++;
  801f74:	ff 45 08             	incl   0x8(%ebp)
  801f77:	eb 13                	jmp    801f8c <strtol+0x4c>
	else if (*s == '-')
  801f79:	8b 45 08             	mov    0x8(%ebp),%eax
  801f7c:	8a 00                	mov    (%eax),%al
  801f7e:	3c 2d                	cmp    $0x2d,%al
  801f80:	75 0a                	jne    801f8c <strtol+0x4c>
		s++, neg = 1;
  801f82:	ff 45 08             	incl   0x8(%ebp)
  801f85:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  801f8c:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801f90:	74 06                	je     801f98 <strtol+0x58>
  801f92:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  801f96:	75 20                	jne    801fb8 <strtol+0x78>
  801f98:	8b 45 08             	mov    0x8(%ebp),%eax
  801f9b:	8a 00                	mov    (%eax),%al
  801f9d:	3c 30                	cmp    $0x30,%al
  801f9f:	75 17                	jne    801fb8 <strtol+0x78>
  801fa1:	8b 45 08             	mov    0x8(%ebp),%eax
  801fa4:	40                   	inc    %eax
  801fa5:	8a 00                	mov    (%eax),%al
  801fa7:	3c 78                	cmp    $0x78,%al
  801fa9:	75 0d                	jne    801fb8 <strtol+0x78>
		s += 2, base = 16;
  801fab:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  801faf:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  801fb6:	eb 28                	jmp    801fe0 <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  801fb8:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801fbc:	75 15                	jne    801fd3 <strtol+0x93>
  801fbe:	8b 45 08             	mov    0x8(%ebp),%eax
  801fc1:	8a 00                	mov    (%eax),%al
  801fc3:	3c 30                	cmp    $0x30,%al
  801fc5:	75 0c                	jne    801fd3 <strtol+0x93>
		s++, base = 8;
  801fc7:	ff 45 08             	incl   0x8(%ebp)
  801fca:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  801fd1:	eb 0d                	jmp    801fe0 <strtol+0xa0>
	else if (base == 0)
  801fd3:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801fd7:	75 07                	jne    801fe0 <strtol+0xa0>
		base = 10;
  801fd9:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  801fe0:	8b 45 08             	mov    0x8(%ebp),%eax
  801fe3:	8a 00                	mov    (%eax),%al
  801fe5:	3c 2f                	cmp    $0x2f,%al
  801fe7:	7e 19                	jle    802002 <strtol+0xc2>
  801fe9:	8b 45 08             	mov    0x8(%ebp),%eax
  801fec:	8a 00                	mov    (%eax),%al
  801fee:	3c 39                	cmp    $0x39,%al
  801ff0:	7f 10                	jg     802002 <strtol+0xc2>
			dig = *s - '0';
  801ff2:	8b 45 08             	mov    0x8(%ebp),%eax
  801ff5:	8a 00                	mov    (%eax),%al
  801ff7:	0f be c0             	movsbl %al,%eax
  801ffa:	83 e8 30             	sub    $0x30,%eax
  801ffd:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802000:	eb 42                	jmp    802044 <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  802002:	8b 45 08             	mov    0x8(%ebp),%eax
  802005:	8a 00                	mov    (%eax),%al
  802007:	3c 60                	cmp    $0x60,%al
  802009:	7e 19                	jle    802024 <strtol+0xe4>
  80200b:	8b 45 08             	mov    0x8(%ebp),%eax
  80200e:	8a 00                	mov    (%eax),%al
  802010:	3c 7a                	cmp    $0x7a,%al
  802012:	7f 10                	jg     802024 <strtol+0xe4>
			dig = *s - 'a' + 10;
  802014:	8b 45 08             	mov    0x8(%ebp),%eax
  802017:	8a 00                	mov    (%eax),%al
  802019:	0f be c0             	movsbl %al,%eax
  80201c:	83 e8 57             	sub    $0x57,%eax
  80201f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802022:	eb 20                	jmp    802044 <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  802024:	8b 45 08             	mov    0x8(%ebp),%eax
  802027:	8a 00                	mov    (%eax),%al
  802029:	3c 40                	cmp    $0x40,%al
  80202b:	7e 39                	jle    802066 <strtol+0x126>
  80202d:	8b 45 08             	mov    0x8(%ebp),%eax
  802030:	8a 00                	mov    (%eax),%al
  802032:	3c 5a                	cmp    $0x5a,%al
  802034:	7f 30                	jg     802066 <strtol+0x126>
			dig = *s - 'A' + 10;
  802036:	8b 45 08             	mov    0x8(%ebp),%eax
  802039:	8a 00                	mov    (%eax),%al
  80203b:	0f be c0             	movsbl %al,%eax
  80203e:	83 e8 37             	sub    $0x37,%eax
  802041:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  802044:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802047:	3b 45 10             	cmp    0x10(%ebp),%eax
  80204a:	7d 19                	jge    802065 <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  80204c:	ff 45 08             	incl   0x8(%ebp)
  80204f:	8b 45 f8             	mov    -0x8(%ebp),%eax
  802052:	0f af 45 10          	imul   0x10(%ebp),%eax
  802056:	89 c2                	mov    %eax,%edx
  802058:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80205b:	01 d0                	add    %edx,%eax
  80205d:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  802060:	e9 7b ff ff ff       	jmp    801fe0 <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  802065:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  802066:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80206a:	74 08                	je     802074 <strtol+0x134>
		*endptr = (char *) s;
  80206c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80206f:	8b 55 08             	mov    0x8(%ebp),%edx
  802072:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  802074:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  802078:	74 07                	je     802081 <strtol+0x141>
  80207a:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80207d:	f7 d8                	neg    %eax
  80207f:	eb 03                	jmp    802084 <strtol+0x144>
  802081:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  802084:	c9                   	leave  
  802085:	c3                   	ret    

00802086 <ltostr>:

void
ltostr(long value, char *str)
{
  802086:	55                   	push   %ebp
  802087:	89 e5                	mov    %esp,%ebp
  802089:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  80208c:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  802093:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  80209a:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80209e:	79 13                	jns    8020b3 <ltostr+0x2d>
	{
		neg = 1;
  8020a0:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  8020a7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8020aa:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  8020ad:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  8020b0:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  8020b3:	8b 45 08             	mov    0x8(%ebp),%eax
  8020b6:	b9 0a 00 00 00       	mov    $0xa,%ecx
  8020bb:	99                   	cltd   
  8020bc:	f7 f9                	idiv   %ecx
  8020be:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  8020c1:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8020c4:	8d 50 01             	lea    0x1(%eax),%edx
  8020c7:	89 55 f8             	mov    %edx,-0x8(%ebp)
  8020ca:	89 c2                	mov    %eax,%edx
  8020cc:	8b 45 0c             	mov    0xc(%ebp),%eax
  8020cf:	01 d0                	add    %edx,%eax
  8020d1:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8020d4:	83 c2 30             	add    $0x30,%edx
  8020d7:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  8020d9:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8020dc:	b8 67 66 66 66       	mov    $0x66666667,%eax
  8020e1:	f7 e9                	imul   %ecx
  8020e3:	c1 fa 02             	sar    $0x2,%edx
  8020e6:	89 c8                	mov    %ecx,%eax
  8020e8:	c1 f8 1f             	sar    $0x1f,%eax
  8020eb:	29 c2                	sub    %eax,%edx
  8020ed:	89 d0                	mov    %edx,%eax
  8020ef:	89 45 08             	mov    %eax,0x8(%ebp)
	} while (value % 10 != 0);
  8020f2:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8020f5:	b8 67 66 66 66       	mov    $0x66666667,%eax
  8020fa:	f7 e9                	imul   %ecx
  8020fc:	c1 fa 02             	sar    $0x2,%edx
  8020ff:	89 c8                	mov    %ecx,%eax
  802101:	c1 f8 1f             	sar    $0x1f,%eax
  802104:	29 c2                	sub    %eax,%edx
  802106:	89 d0                	mov    %edx,%eax
  802108:	c1 e0 02             	shl    $0x2,%eax
  80210b:	01 d0                	add    %edx,%eax
  80210d:	01 c0                	add    %eax,%eax
  80210f:	29 c1                	sub    %eax,%ecx
  802111:	89 ca                	mov    %ecx,%edx
  802113:	85 d2                	test   %edx,%edx
  802115:	75 9c                	jne    8020b3 <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  802117:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  80211e:	8b 45 f8             	mov    -0x8(%ebp),%eax
  802121:	48                   	dec    %eax
  802122:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  802125:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  802129:	74 3d                	je     802168 <ltostr+0xe2>
		start = 1 ;
  80212b:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  802132:	eb 34                	jmp    802168 <ltostr+0xe2>
	{
		char tmp = str[start] ;
  802134:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802137:	8b 45 0c             	mov    0xc(%ebp),%eax
  80213a:	01 d0                	add    %edx,%eax
  80213c:	8a 00                	mov    (%eax),%al
  80213e:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  802141:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802144:	8b 45 0c             	mov    0xc(%ebp),%eax
  802147:	01 c2                	add    %eax,%edx
  802149:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  80214c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80214f:	01 c8                	add    %ecx,%eax
  802151:	8a 00                	mov    (%eax),%al
  802153:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  802155:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802158:	8b 45 0c             	mov    0xc(%ebp),%eax
  80215b:	01 c2                	add    %eax,%edx
  80215d:	8a 45 eb             	mov    -0x15(%ebp),%al
  802160:	88 02                	mov    %al,(%edx)
		start++ ;
  802162:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  802165:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  802168:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80216b:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80216e:	7c c4                	jl     802134 <ltostr+0xae>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  802170:	8b 55 f8             	mov    -0x8(%ebp),%edx
  802173:	8b 45 0c             	mov    0xc(%ebp),%eax
  802176:	01 d0                	add    %edx,%eax
  802178:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  80217b:	90                   	nop
  80217c:	c9                   	leave  
  80217d:	c3                   	ret    

0080217e <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  80217e:	55                   	push   %ebp
  80217f:	89 e5                	mov    %esp,%ebp
  802181:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  802184:	ff 75 08             	pushl  0x8(%ebp)
  802187:	e8 54 fa ff ff       	call   801be0 <strlen>
  80218c:	83 c4 04             	add    $0x4,%esp
  80218f:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  802192:	ff 75 0c             	pushl  0xc(%ebp)
  802195:	e8 46 fa ff ff       	call   801be0 <strlen>
  80219a:	83 c4 04             	add    $0x4,%esp
  80219d:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  8021a0:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  8021a7:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8021ae:	eb 17                	jmp    8021c7 <strcconcat+0x49>
		final[s] = str1[s] ;
  8021b0:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8021b3:	8b 45 10             	mov    0x10(%ebp),%eax
  8021b6:	01 c2                	add    %eax,%edx
  8021b8:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  8021bb:	8b 45 08             	mov    0x8(%ebp),%eax
  8021be:	01 c8                	add    %ecx,%eax
  8021c0:	8a 00                	mov    (%eax),%al
  8021c2:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  8021c4:	ff 45 fc             	incl   -0x4(%ebp)
  8021c7:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8021ca:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  8021cd:	7c e1                	jl     8021b0 <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  8021cf:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  8021d6:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  8021dd:	eb 1f                	jmp    8021fe <strcconcat+0x80>
		final[s++] = str2[i] ;
  8021df:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8021e2:	8d 50 01             	lea    0x1(%eax),%edx
  8021e5:	89 55 fc             	mov    %edx,-0x4(%ebp)
  8021e8:	89 c2                	mov    %eax,%edx
  8021ea:	8b 45 10             	mov    0x10(%ebp),%eax
  8021ed:	01 c2                	add    %eax,%edx
  8021ef:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  8021f2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8021f5:	01 c8                	add    %ecx,%eax
  8021f7:	8a 00                	mov    (%eax),%al
  8021f9:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  8021fb:	ff 45 f8             	incl   -0x8(%ebp)
  8021fe:	8b 45 f8             	mov    -0x8(%ebp),%eax
  802201:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  802204:	7c d9                	jl     8021df <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  802206:	8b 55 fc             	mov    -0x4(%ebp),%edx
  802209:	8b 45 10             	mov    0x10(%ebp),%eax
  80220c:	01 d0                	add    %edx,%eax
  80220e:	c6 00 00             	movb   $0x0,(%eax)
}
  802211:	90                   	nop
  802212:	c9                   	leave  
  802213:	c3                   	ret    

00802214 <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  802214:	55                   	push   %ebp
  802215:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  802217:	8b 45 14             	mov    0x14(%ebp),%eax
  80221a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  802220:	8b 45 14             	mov    0x14(%ebp),%eax
  802223:	8b 00                	mov    (%eax),%eax
  802225:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80222c:	8b 45 10             	mov    0x10(%ebp),%eax
  80222f:	01 d0                	add    %edx,%eax
  802231:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  802237:	eb 0c                	jmp    802245 <strsplit+0x31>
			*string++ = 0;
  802239:	8b 45 08             	mov    0x8(%ebp),%eax
  80223c:	8d 50 01             	lea    0x1(%eax),%edx
  80223f:	89 55 08             	mov    %edx,0x8(%ebp)
  802242:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  802245:	8b 45 08             	mov    0x8(%ebp),%eax
  802248:	8a 00                	mov    (%eax),%al
  80224a:	84 c0                	test   %al,%al
  80224c:	74 18                	je     802266 <strsplit+0x52>
  80224e:	8b 45 08             	mov    0x8(%ebp),%eax
  802251:	8a 00                	mov    (%eax),%al
  802253:	0f be c0             	movsbl %al,%eax
  802256:	50                   	push   %eax
  802257:	ff 75 0c             	pushl  0xc(%ebp)
  80225a:	e8 13 fb ff ff       	call   801d72 <strchr>
  80225f:	83 c4 08             	add    $0x8,%esp
  802262:	85 c0                	test   %eax,%eax
  802264:	75 d3                	jne    802239 <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  802266:	8b 45 08             	mov    0x8(%ebp),%eax
  802269:	8a 00                	mov    (%eax),%al
  80226b:	84 c0                	test   %al,%al
  80226d:	74 5a                	je     8022c9 <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  80226f:	8b 45 14             	mov    0x14(%ebp),%eax
  802272:	8b 00                	mov    (%eax),%eax
  802274:	83 f8 0f             	cmp    $0xf,%eax
  802277:	75 07                	jne    802280 <strsplit+0x6c>
		{
			return 0;
  802279:	b8 00 00 00 00       	mov    $0x0,%eax
  80227e:	eb 66                	jmp    8022e6 <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  802280:	8b 45 14             	mov    0x14(%ebp),%eax
  802283:	8b 00                	mov    (%eax),%eax
  802285:	8d 48 01             	lea    0x1(%eax),%ecx
  802288:	8b 55 14             	mov    0x14(%ebp),%edx
  80228b:	89 0a                	mov    %ecx,(%edx)
  80228d:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  802294:	8b 45 10             	mov    0x10(%ebp),%eax
  802297:	01 c2                	add    %eax,%edx
  802299:	8b 45 08             	mov    0x8(%ebp),%eax
  80229c:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  80229e:	eb 03                	jmp    8022a3 <strsplit+0x8f>
			string++;
  8022a0:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  8022a3:	8b 45 08             	mov    0x8(%ebp),%eax
  8022a6:	8a 00                	mov    (%eax),%al
  8022a8:	84 c0                	test   %al,%al
  8022aa:	74 8b                	je     802237 <strsplit+0x23>
  8022ac:	8b 45 08             	mov    0x8(%ebp),%eax
  8022af:	8a 00                	mov    (%eax),%al
  8022b1:	0f be c0             	movsbl %al,%eax
  8022b4:	50                   	push   %eax
  8022b5:	ff 75 0c             	pushl  0xc(%ebp)
  8022b8:	e8 b5 fa ff ff       	call   801d72 <strchr>
  8022bd:	83 c4 08             	add    $0x8,%esp
  8022c0:	85 c0                	test   %eax,%eax
  8022c2:	74 dc                	je     8022a0 <strsplit+0x8c>
			string++;
	}
  8022c4:	e9 6e ff ff ff       	jmp    802237 <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  8022c9:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  8022ca:	8b 45 14             	mov    0x14(%ebp),%eax
  8022cd:	8b 00                	mov    (%eax),%eax
  8022cf:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8022d6:	8b 45 10             	mov    0x10(%ebp),%eax
  8022d9:	01 d0                	add    %edx,%eax
  8022db:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  8022e1:	b8 01 00 00 00       	mov    $0x1,%eax
}
  8022e6:	c9                   	leave  
  8022e7:	c3                   	ret    

008022e8 <InitializeUHeap>:
//============================== GIVEN FUNCTIONS ===================================//
//==================================================================================//

int FirstTimeFlag = 1;
void InitializeUHeap()
{
  8022e8:	55                   	push   %ebp
  8022e9:	89 e5                	mov    %esp,%ebp
  8022eb:	83 ec 08             	sub    $0x8,%esp
	if(FirstTimeFlag)
  8022ee:	a1 04 50 80 00       	mov    0x805004,%eax
  8022f3:	85 c0                	test   %eax,%eax
  8022f5:	74 1f                	je     802316 <InitializeUHeap+0x2e>
	{
		initialize_dyn_block_system();
  8022f7:	e8 1d 00 00 00       	call   802319 <initialize_dyn_block_system>
		cprintf("DYNAMIC BLOCK SYSTEM IS INITIALIZED\n");
  8022fc:	83 ec 0c             	sub    $0xc,%esp
  8022ff:	68 d0 49 80 00       	push   $0x8049d0
  802304:	e8 55 f2 ff ff       	call   80155e <cprintf>
  802309:	83 c4 10             	add    $0x10,%esp
#if UHP_USE_BUDDY
		initialize_buddy();
		cprintf("BUDDY SYSTEM IS INITIALIZED\n");
#endif
		FirstTimeFlag = 0;
  80230c:	c7 05 04 50 80 00 00 	movl   $0x0,0x805004
  802313:	00 00 00 
	}
}
  802316:	90                   	nop
  802317:	c9                   	leave  
  802318:	c3                   	ret    

00802319 <initialize_dyn_block_system>:

//=================================
// [1] INITIALIZE DYNAMIC ALLOCATOR:
//=================================
void initialize_dyn_block_system()
{
  802319:	55                   	push   %ebp
  80231a:	89 e5                	mov    %esp,%ebp
  80231c:	83 ec 28             	sub    $0x28,%esp
	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] initialize_dyn_block_system
	// your code is here, remove the panic and write your code
	//panic("initialize_dyn_block_system() is not implemented yet...!!");

	LIST_INIT(&AllocMemBlocksList);
  80231f:	c7 05 40 50 80 00 00 	movl   $0x0,0x805040
  802326:	00 00 00 
  802329:	c7 05 44 50 80 00 00 	movl   $0x0,0x805044
  802330:	00 00 00 
  802333:	c7 05 4c 50 80 00 00 	movl   $0x0,0x80504c
  80233a:	00 00 00 
	LIST_INIT(&FreeMemBlocksList);
  80233d:	c7 05 38 51 80 00 00 	movl   $0x0,0x805138
  802344:	00 00 00 
  802347:	c7 05 3c 51 80 00 00 	movl   $0x0,0x80513c
  80234e:	00 00 00 
  802351:	c7 05 44 51 80 00 00 	movl   $0x0,0x805144
  802358:	00 00 00 
	MAX_MEM_BLOCK_CNT = NUM_OF_UHEAP_PAGES;
  80235b:	c7 05 20 51 80 00 00 	movl   $0x20000,0x805120
  802362:	00 02 00 
	MemBlockNodes = (void*)USER_DYN_BLKS_ARRAY;
  802365:	c7 45 f4 00 00 e0 7f 	movl   $0x7fe00000,-0xc(%ebp)
  80236c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80236f:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  802374:	2d 00 10 00 00       	sub    $0x1000,%eax
  802379:	a3 50 50 80 00       	mov    %eax,0x805050
	int size_of_block = sizeof(struct MemBlock);
  80237e:	c7 45 f0 10 00 00 00 	movl   $0x10,-0x10(%ebp)
	int size_all_struct = size_of_block*MAX_MEM_BLOCK_CNT;
  802385:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802388:	a1 20 51 80 00       	mov    0x805120,%eax
  80238d:	0f af c2             	imul   %edx,%eax
  802390:	89 45 ec             	mov    %eax,-0x14(%ebp)
	size_all_struct = ROUNDUP(size_all_struct, PAGE_SIZE);
  802393:	c7 45 e8 00 10 00 00 	movl   $0x1000,-0x18(%ebp)
  80239a:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80239d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8023a0:	01 d0                	add    %edx,%eax
  8023a2:	48                   	dec    %eax
  8023a3:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8023a6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8023a9:	ba 00 00 00 00       	mov    $0x0,%edx
  8023ae:	f7 75 e8             	divl   -0x18(%ebp)
  8023b1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8023b4:	29 d0                	sub    %edx,%eax
  8023b6:	89 45 ec             	mov    %eax,-0x14(%ebp)
	sys_allocate_chunk(USER_DYN_BLKS_ARRAY, size_all_struct,PERM_USER| PERM_WRITEABLE);
  8023b9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8023bc:	c7 45 e0 00 00 e0 7f 	movl   $0x7fe00000,-0x20(%ebp)
  8023c3:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8023c6:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
  8023cc:	81 ea 00 10 00 00    	sub    $0x1000,%edx
  8023d2:	83 ec 04             	sub    $0x4,%esp
  8023d5:	6a 06                	push   $0x6
  8023d7:	50                   	push   %eax
  8023d8:	52                   	push   %edx
  8023d9:	e8 a1 05 00 00       	call   80297f <sys_allocate_chunk>
  8023de:	83 c4 10             	add    $0x10,%esp
	initialize_MemBlocksList(MAX_MEM_BLOCK_CNT);
  8023e1:	a1 20 51 80 00       	mov    0x805120,%eax
  8023e6:	83 ec 0c             	sub    $0xc,%esp
  8023e9:	50                   	push   %eax
  8023ea:	e8 16 0c 00 00       	call   803005 <initialize_MemBlocksList>
  8023ef:	83 c4 10             	add    $0x10,%esp
	struct MemBlock* ourBlock =LIST_LAST(&AvailableMemBlocksList);
  8023f2:	a1 4c 51 80 00       	mov    0x80514c,%eax
  8023f7:	89 45 dc             	mov    %eax,-0x24(%ebp)
	LIST_REMOVE(&AvailableMemBlocksList,ourBlock);
  8023fa:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  8023fe:	75 14                	jne    802414 <initialize_dyn_block_system+0xfb>
  802400:	83 ec 04             	sub    $0x4,%esp
  802403:	68 f5 49 80 00       	push   $0x8049f5
  802408:	6a 2d                	push   $0x2d
  80240a:	68 13 4a 80 00       	push   $0x804a13
  80240f:	e8 96 ee ff ff       	call   8012aa <_panic>
  802414:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802417:	8b 00                	mov    (%eax),%eax
  802419:	85 c0                	test   %eax,%eax
  80241b:	74 10                	je     80242d <initialize_dyn_block_system+0x114>
  80241d:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802420:	8b 00                	mov    (%eax),%eax
  802422:	8b 55 dc             	mov    -0x24(%ebp),%edx
  802425:	8b 52 04             	mov    0x4(%edx),%edx
  802428:	89 50 04             	mov    %edx,0x4(%eax)
  80242b:	eb 0b                	jmp    802438 <initialize_dyn_block_system+0x11f>
  80242d:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802430:	8b 40 04             	mov    0x4(%eax),%eax
  802433:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802438:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80243b:	8b 40 04             	mov    0x4(%eax),%eax
  80243e:	85 c0                	test   %eax,%eax
  802440:	74 0f                	je     802451 <initialize_dyn_block_system+0x138>
  802442:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802445:	8b 40 04             	mov    0x4(%eax),%eax
  802448:	8b 55 dc             	mov    -0x24(%ebp),%edx
  80244b:	8b 12                	mov    (%edx),%edx
  80244d:	89 10                	mov    %edx,(%eax)
  80244f:	eb 0a                	jmp    80245b <initialize_dyn_block_system+0x142>
  802451:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802454:	8b 00                	mov    (%eax),%eax
  802456:	a3 48 51 80 00       	mov    %eax,0x805148
  80245b:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80245e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802464:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802467:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80246e:	a1 54 51 80 00       	mov    0x805154,%eax
  802473:	48                   	dec    %eax
  802474:	a3 54 51 80 00       	mov    %eax,0x805154
	ourBlock->size = USER_HEAP_MAX-USER_HEAP_START;
  802479:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80247c:	c7 40 0c 00 00 00 20 	movl   $0x20000000,0xc(%eax)
	ourBlock->sva=USER_HEAP_START;
  802483:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802486:	c7 40 08 00 00 00 80 	movl   $0x80000000,0x8(%eax)
	LIST_INSERT_TAIL(&FreeMemBlocksList, ourBlock);
  80248d:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  802491:	75 14                	jne    8024a7 <initialize_dyn_block_system+0x18e>
  802493:	83 ec 04             	sub    $0x4,%esp
  802496:	68 20 4a 80 00       	push   $0x804a20
  80249b:	6a 30                	push   $0x30
  80249d:	68 13 4a 80 00       	push   $0x804a13
  8024a2:	e8 03 ee ff ff       	call   8012aa <_panic>
  8024a7:	8b 15 3c 51 80 00    	mov    0x80513c,%edx
  8024ad:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8024b0:	89 50 04             	mov    %edx,0x4(%eax)
  8024b3:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8024b6:	8b 40 04             	mov    0x4(%eax),%eax
  8024b9:	85 c0                	test   %eax,%eax
  8024bb:	74 0c                	je     8024c9 <initialize_dyn_block_system+0x1b0>
  8024bd:	a1 3c 51 80 00       	mov    0x80513c,%eax
  8024c2:	8b 55 dc             	mov    -0x24(%ebp),%edx
  8024c5:	89 10                	mov    %edx,(%eax)
  8024c7:	eb 08                	jmp    8024d1 <initialize_dyn_block_system+0x1b8>
  8024c9:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8024cc:	a3 38 51 80 00       	mov    %eax,0x805138
  8024d1:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8024d4:	a3 3c 51 80 00       	mov    %eax,0x80513c
  8024d9:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8024dc:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8024e2:	a1 44 51 80 00       	mov    0x805144,%eax
  8024e7:	40                   	inc    %eax
  8024e8:	a3 44 51 80 00       	mov    %eax,0x805144
	//[1] Initialize two lists (AllocMemBlocksList & FreeMemBlocksList) [Hint: use LIST_INIT()]
	//[2] Dynamically allocate the array of MemBlockNodes at VA USER_DYN_BLKS_ARRAY
	//	  (remember to set MAX_MEM_BLOCK_CNT with the chosen size of the array)
	//[3] Initialize AvailableMemBlocksList by filling it with the MemBlockNodes
	//[4] Insert a new MemBlock with the heap size into the FreeMemBlocksList
}
  8024ed:	90                   	nop
  8024ee:	c9                   	leave  
  8024ef:	c3                   	ret    

008024f0 <malloc>:
//=================================
// [2] ALLOCATE SPACE IN USER HEAP:
//=================================

void* malloc(uint32 size)
{
  8024f0:	55                   	push   %ebp
  8024f1:	89 e5                	mov    %esp,%ebp
  8024f3:	83 ec 18             	sub    $0x18,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  8024f6:	e8 ed fd ff ff       	call   8022e8 <InitializeUHeap>
	if (size == 0) return NULL ;
  8024fb:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8024ff:	75 07                	jne    802508 <malloc+0x18>
  802501:	b8 00 00 00 00       	mov    $0x0,%eax
  802506:	eb 67                	jmp    80256f <malloc+0x7f>

	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] malloc
	// your code is here, remove the panic and write your code
	//panic("malloc() is not implemented yet...!!");

	size = ROUNDUP(size, PAGE_SIZE);
  802508:	c7 45 f4 00 10 00 00 	movl   $0x1000,-0xc(%ebp)
  80250f:	8b 55 08             	mov    0x8(%ebp),%edx
  802512:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802515:	01 d0                	add    %edx,%eax
  802517:	48                   	dec    %eax
  802518:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80251b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80251e:	ba 00 00 00 00       	mov    $0x0,%edx
  802523:	f7 75 f4             	divl   -0xc(%ebp)
  802526:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802529:	29 d0                	sub    %edx,%eax
  80252b:	89 45 08             	mov    %eax,0x8(%ebp)
	if(sys_isUHeapPlacementStrategyFIRSTFIT())
  80252e:	e8 1a 08 00 00       	call   802d4d <sys_isUHeapPlacementStrategyFIRSTFIT>
  802533:	85 c0                	test   %eax,%eax
  802535:	74 33                	je     80256a <malloc+0x7a>
	{
		struct MemBlock * myBlock = alloc_block_FF(size);
  802537:	83 ec 0c             	sub    $0xc,%esp
  80253a:	ff 75 08             	pushl  0x8(%ebp)
  80253d:	e8 0c 0e 00 00       	call   80334e <alloc_block_FF>
  802542:	83 c4 10             	add    $0x10,%esp
  802545:	89 45 ec             	mov    %eax,-0x14(%ebp)
		if(myBlock != NULL)
  802548:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  80254c:	74 1c                	je     80256a <malloc+0x7a>
		{
			insert_sorted_allocList(myBlock);
  80254e:	83 ec 0c             	sub    $0xc,%esp
  802551:	ff 75 ec             	pushl  -0x14(%ebp)
  802554:	e8 07 0c 00 00       	call   803160 <insert_sorted_allocList>
  802559:	83 c4 10             	add    $0x10,%esp
			uint32 ptr = myBlock->sva;
  80255c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80255f:	8b 40 08             	mov    0x8(%eax),%eax
  802562:	89 45 e8             	mov    %eax,-0x18(%ebp)
			return (void *)ptr;
  802565:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802568:	eb 05                	jmp    80256f <malloc+0x7f>
		}
	}
	return NULL;
  80256a:	b8 00 00 00 00       	mov    $0x0,%eax
	//		to the required allocation size (space should be on 4 KB BOUNDARY)
	//	2) if no suitable space found, return NULL
	// 	3) Return pointer containing the virtual address of allocated space,
	//
	//Use sys_isUHeapPlacementStrategyFIRSTFIT()... to check the current strategy
}
  80256f:	c9                   	leave  
  802570:	c3                   	ret    

00802571 <free>:
//	We can use sys_free_user_mem(uint32 virtual_address, uint32 size); which
//		switches to the kernel mode, calls free_user_mem() in
//		"kern/mem/chunk_operations.c", then switch back to the user mode here
//	the free_user_mem function is empty, make sure to implement it.
void free(void* virtual_address)
{
  802571:	55                   	push   %ebp
  802572:	89 e5                	mov    %esp,%ebp
  802574:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] free
	// your code is here, remove the panic and write your code
	//panic("free() is not implemented yet...!!");

	uint32 virtualAddress = (uint32 )(virtual_address);
  802577:	8b 45 08             	mov    0x8(%ebp),%eax
  80257a:	89 45 f4             	mov    %eax,-0xc(%ebp)
//	virtualAddress = ROUNDDOWN(virtualAddress, PAGE_SIZE);
	struct MemBlock * myBlock = find_block(&AllocMemBlocksList, virtualAddress);
  80257d:	83 ec 08             	sub    $0x8,%esp
  802580:	ff 75 f4             	pushl  -0xc(%ebp)
  802583:	68 40 50 80 00       	push   $0x805040
  802588:	e8 5b 0b 00 00       	call   8030e8 <find_block>
  80258d:	83 c4 10             	add    $0x10,%esp
  802590:	89 45 f0             	mov    %eax,-0x10(%ebp)
//	cprintf ("ptr sva at free user side = %x \n", myBlock->sva);
	sys_free_user_mem(virtualAddress, myBlock->size);
  802593:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802596:	8b 40 0c             	mov    0xc(%eax),%eax
  802599:	83 ec 08             	sub    $0x8,%esp
  80259c:	50                   	push   %eax
  80259d:	ff 75 f4             	pushl  -0xc(%ebp)
  8025a0:	e8 a2 03 00 00       	call   802947 <sys_free_user_mem>
  8025a5:	83 c4 10             	add    $0x10,%esp
	LIST_REMOVE(&AllocMemBlocksList, myBlock);
  8025a8:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8025ac:	75 14                	jne    8025c2 <free+0x51>
  8025ae:	83 ec 04             	sub    $0x4,%esp
  8025b1:	68 f5 49 80 00       	push   $0x8049f5
  8025b6:	6a 76                	push   $0x76
  8025b8:	68 13 4a 80 00       	push   $0x804a13
  8025bd:	e8 e8 ec ff ff       	call   8012aa <_panic>
  8025c2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8025c5:	8b 00                	mov    (%eax),%eax
  8025c7:	85 c0                	test   %eax,%eax
  8025c9:	74 10                	je     8025db <free+0x6a>
  8025cb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8025ce:	8b 00                	mov    (%eax),%eax
  8025d0:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8025d3:	8b 52 04             	mov    0x4(%edx),%edx
  8025d6:	89 50 04             	mov    %edx,0x4(%eax)
  8025d9:	eb 0b                	jmp    8025e6 <free+0x75>
  8025db:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8025de:	8b 40 04             	mov    0x4(%eax),%eax
  8025e1:	a3 44 50 80 00       	mov    %eax,0x805044
  8025e6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8025e9:	8b 40 04             	mov    0x4(%eax),%eax
  8025ec:	85 c0                	test   %eax,%eax
  8025ee:	74 0f                	je     8025ff <free+0x8e>
  8025f0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8025f3:	8b 40 04             	mov    0x4(%eax),%eax
  8025f6:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8025f9:	8b 12                	mov    (%edx),%edx
  8025fb:	89 10                	mov    %edx,(%eax)
  8025fd:	eb 0a                	jmp    802609 <free+0x98>
  8025ff:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802602:	8b 00                	mov    (%eax),%eax
  802604:	a3 40 50 80 00       	mov    %eax,0x805040
  802609:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80260c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802612:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802615:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80261c:	a1 4c 50 80 00       	mov    0x80504c,%eax
  802621:	48                   	dec    %eax
  802622:	a3 4c 50 80 00       	mov    %eax,0x80504c
	insert_sorted_with_merge_freeList(myBlock);
  802627:	83 ec 0c             	sub    $0xc,%esp
  80262a:	ff 75 f0             	pushl  -0x10(%ebp)
  80262d:	e8 0b 14 00 00       	call   803a3d <insert_sorted_with_merge_freeList>
  802632:	83 c4 10             	add    $0x10,%esp

	//you should get the size of the given allocation using its address
	//you need to call sys_free_user_mem()
	//refer to the project presentation and documentation for details
}
  802635:	90                   	nop
  802636:	c9                   	leave  
  802637:	c3                   	ret    

00802638 <smalloc>:

//=================================
// [4] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
  802638:	55                   	push   %ebp
  802639:	89 e5                	mov    %esp,%ebp
  80263b:	83 ec 28             	sub    $0x28,%esp
  80263e:	8b 45 10             	mov    0x10(%ebp),%eax
  802641:	88 45 e4             	mov    %al,-0x1c(%ebp)
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  802644:	e8 9f fc ff ff       	call   8022e8 <InitializeUHeap>
	if (size == 0) return NULL ;
  802649:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80264d:	75 0a                	jne    802659 <smalloc+0x21>
  80264f:	b8 00 00 00 00       	mov    $0x0,%eax
  802654:	e9 8d 00 00 00       	jmp    8026e6 <smalloc+0xae>

	//This function should find the space of the required range
	// * ON 4KB BOUNDARY **** //
	//Use sys_isUHeapPlacementStrategyFIRSTFIT() to check the current strategy

	size = ROUNDUP(size, PAGE_SIZE);
  802659:	c7 45 f4 00 10 00 00 	movl   $0x1000,-0xc(%ebp)
  802660:	8b 55 0c             	mov    0xc(%ebp),%edx
  802663:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802666:	01 d0                	add    %edx,%eax
  802668:	48                   	dec    %eax
  802669:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80266c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80266f:	ba 00 00 00 00       	mov    $0x0,%edx
  802674:	f7 75 f4             	divl   -0xc(%ebp)
  802677:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80267a:	29 d0                	sub    %edx,%eax
  80267c:	89 45 0c             	mov    %eax,0xc(%ebp)
		if(sys_isUHeapPlacementStrategyFIRSTFIT())
  80267f:	e8 c9 06 00 00       	call   802d4d <sys_isUHeapPlacementStrategyFIRSTFIT>
  802684:	85 c0                	test   %eax,%eax
  802686:	74 59                	je     8026e1 <smalloc+0xa9>
		{
			struct MemBlock * v1=NULL;
  802688:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
			v1= alloc_block_FF(size);
  80268f:	83 ec 0c             	sub    $0xc,%esp
  802692:	ff 75 0c             	pushl  0xc(%ebp)
  802695:	e8 b4 0c 00 00       	call   80334e <alloc_block_FF>
  80269a:	83 c4 10             	add    $0x10,%esp
  80269d:	89 45 ec             	mov    %eax,-0x14(%ebp)
			if(v1==NULL)
  8026a0:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8026a4:	75 07                	jne    8026ad <smalloc+0x75>
			{
				return NULL;
  8026a6:	b8 00 00 00 00       	mov    $0x0,%eax
  8026ab:	eb 39                	jmp    8026e6 <smalloc+0xae>
			}
			else
			{
				int ret=sys_createSharedObject(sharedVarName,  size,  isWritable,(void*)v1->sva);
  8026ad:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8026b0:	8b 40 08             	mov    0x8(%eax),%eax
  8026b3:	89 c2                	mov    %eax,%edx
  8026b5:	0f b6 45 e4          	movzbl -0x1c(%ebp),%eax
  8026b9:	52                   	push   %edx
  8026ba:	50                   	push   %eax
  8026bb:	ff 75 0c             	pushl  0xc(%ebp)
  8026be:	ff 75 08             	pushl  0x8(%ebp)
  8026c1:	e8 0c 04 00 00       	call   802ad2 <sys_createSharedObject>
  8026c6:	83 c4 10             	add    $0x10,%esp
  8026c9:	89 45 e8             	mov    %eax,-0x18(%ebp)
				if(ret>=0)
  8026cc:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8026d0:	78 08                	js     8026da <smalloc+0xa2>
				{
					return (void*)v1->sva;
  8026d2:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8026d5:	8b 40 08             	mov    0x8(%eax),%eax
  8026d8:	eb 0c                	jmp    8026e6 <smalloc+0xae>
				}
				else
				{
					return NULL;
  8026da:	b8 00 00 00 00       	mov    $0x0,%eax
  8026df:	eb 05                	jmp    8026e6 <smalloc+0xae>
				}
			}

		}
		return NULL;
  8026e1:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8026e6:	c9                   	leave  
  8026e7:	c3                   	ret    

008026e8 <sget>:

//========================================
// [5] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  8026e8:	55                   	push   %ebp
  8026e9:	89 e5                	mov    %esp,%ebp
  8026eb:	83 ec 18             	sub    $0x18,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  8026ee:	e8 f5 fb ff ff       	call   8022e8 <InitializeUHeap>

	//This function should find the space for sharing the variable
	// *** ON 4KB BOUNDARY ******** //

	//Use sys_isUHeapPlacementStrategyFIRSTFIT() to check the current strategy
	int ret=sys_getSizeOfSharedObject(ownerEnvID,sharedVarName);
  8026f3:	83 ec 08             	sub    $0x8,%esp
  8026f6:	ff 75 0c             	pushl  0xc(%ebp)
  8026f9:	ff 75 08             	pushl  0x8(%ebp)
  8026fc:	e8 fb 03 00 00       	call   802afc <sys_getSizeOfSharedObject>
  802701:	83 c4 10             	add    $0x10,%esp
  802704:	89 45 f4             	mov    %eax,-0xc(%ebp)
	if(ret==0)
  802707:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80270b:	75 07                	jne    802714 <sget+0x2c>
	{
		return NULL;
  80270d:	b8 00 00 00 00       	mov    $0x0,%eax
  802712:	eb 64                	jmp    802778 <sget+0x90>
	}
	if(sys_isUHeapPlacementStrategyFIRSTFIT())
  802714:	e8 34 06 00 00       	call   802d4d <sys_isUHeapPlacementStrategyFIRSTFIT>
  802719:	85 c0                	test   %eax,%eax
  80271b:	74 56                	je     802773 <sget+0x8b>
	{
		struct MemBlock * v1=NULL;
  80271d:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
		v1= alloc_block_FF(ret);
  802724:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802727:	83 ec 0c             	sub    $0xc,%esp
  80272a:	50                   	push   %eax
  80272b:	e8 1e 0c 00 00       	call   80334e <alloc_block_FF>
  802730:	83 c4 10             	add    $0x10,%esp
  802733:	89 45 f0             	mov    %eax,-0x10(%ebp)
		if(v1==NULL)
  802736:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80273a:	75 07                	jne    802743 <sget+0x5b>
		{
		return NULL;
  80273c:	b8 00 00 00 00       	mov    $0x0,%eax
  802741:	eb 35                	jmp    802778 <sget+0x90>
	    }
		else
		{
			int ret1=sys_getSharedObject(ownerEnvID,sharedVarName,(void*)v1->sva);
  802743:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802746:	8b 40 08             	mov    0x8(%eax),%eax
  802749:	83 ec 04             	sub    $0x4,%esp
  80274c:	50                   	push   %eax
  80274d:	ff 75 0c             	pushl  0xc(%ebp)
  802750:	ff 75 08             	pushl  0x8(%ebp)
  802753:	e8 c1 03 00 00       	call   802b19 <sys_getSharedObject>
  802758:	83 c4 10             	add    $0x10,%esp
  80275b:	89 45 ec             	mov    %eax,-0x14(%ebp)
			if(ret1>=0)
  80275e:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802762:	78 08                	js     80276c <sget+0x84>
			{
				return (void*)v1->sva;
  802764:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802767:	8b 40 08             	mov    0x8(%eax),%eax
  80276a:	eb 0c                	jmp    802778 <sget+0x90>
			}
			else
			{
				return NULL;
  80276c:	b8 00 00 00 00       	mov    $0x0,%eax
  802771:	eb 05                	jmp    802778 <sget+0x90>
			}
		}
	}
  return NULL;
  802773:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802778:	c9                   	leave  
  802779:	c3                   	ret    

0080277a <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  80277a:	55                   	push   %ebp
  80277b:	89 e5                	mov    %esp,%ebp
  80277d:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  802780:	e8 63 fb ff ff       	call   8022e8 <InitializeUHeap>
	//==============================================================
	// [USER HEAP - USER SIDE] realloc
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  802785:	83 ec 04             	sub    $0x4,%esp
  802788:	68 44 4a 80 00       	push   $0x804a44
  80278d:	68 0e 01 00 00       	push   $0x10e
  802792:	68 13 4a 80 00       	push   $0x804a13
  802797:	e8 0e eb ff ff       	call   8012aa <_panic>

0080279c <sfree>:
//	use sys_freeSharedObject(...); which switches to the kernel mode,
//	calls freeSharedObject(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the freeSharedObject() function is empty, make sure to implement it.

void sfree(void* virtual_address)
{
  80279c:	55                   	push   %ebp
  80279d:	89 e5                	mov    %esp,%ebp
  80279f:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS3 - BONUS] [SHARING - USER SIDE] sfree()

	// Write your code here, remove the panic and write your code
	panic("sfree() is not implemented yet...!!");
  8027a2:	83 ec 04             	sub    $0x4,%esp
  8027a5:	68 6c 4a 80 00       	push   $0x804a6c
  8027aa:	68 22 01 00 00       	push   $0x122
  8027af:	68 13 4a 80 00       	push   $0x804a13
  8027b4:	e8 f1 ea ff ff       	call   8012aa <_panic>

008027b9 <expand>:

//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//
void expand(uint32 newSize)
{
  8027b9:	55                   	push   %ebp
  8027ba:	89 e5                	mov    %esp,%ebp
  8027bc:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  8027bf:	83 ec 04             	sub    $0x4,%esp
  8027c2:	68 90 4a 80 00       	push   $0x804a90
  8027c7:	68 2d 01 00 00       	push   $0x12d
  8027cc:	68 13 4a 80 00       	push   $0x804a13
  8027d1:	e8 d4 ea ff ff       	call   8012aa <_panic>

008027d6 <shrink>:

}
void shrink(uint32 newSize)
{
  8027d6:	55                   	push   %ebp
  8027d7:	89 e5                	mov    %esp,%ebp
  8027d9:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  8027dc:	83 ec 04             	sub    $0x4,%esp
  8027df:	68 90 4a 80 00       	push   $0x804a90
  8027e4:	68 32 01 00 00       	push   $0x132
  8027e9:	68 13 4a 80 00       	push   $0x804a13
  8027ee:	e8 b7 ea ff ff       	call   8012aa <_panic>

008027f3 <freeHeap>:

}
void freeHeap(void* virtual_address)
{
  8027f3:	55                   	push   %ebp
  8027f4:	89 e5                	mov    %esp,%ebp
  8027f6:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  8027f9:	83 ec 04             	sub    $0x4,%esp
  8027fc:	68 90 4a 80 00       	push   $0x804a90
  802801:	68 37 01 00 00       	push   $0x137
  802806:	68 13 4a 80 00       	push   $0x804a13
  80280b:	e8 9a ea ff ff       	call   8012aa <_panic>

00802810 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  802810:	55                   	push   %ebp
  802811:	89 e5                	mov    %esp,%ebp
  802813:	57                   	push   %edi
  802814:	56                   	push   %esi
  802815:	53                   	push   %ebx
  802816:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  802819:	8b 45 08             	mov    0x8(%ebp),%eax
  80281c:	8b 55 0c             	mov    0xc(%ebp),%edx
  80281f:	8b 4d 10             	mov    0x10(%ebp),%ecx
  802822:	8b 5d 14             	mov    0x14(%ebp),%ebx
  802825:	8b 7d 18             	mov    0x18(%ebp),%edi
  802828:	8b 75 1c             	mov    0x1c(%ebp),%esi
  80282b:	cd 30                	int    $0x30
  80282d:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  802830:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  802833:	83 c4 10             	add    $0x10,%esp
  802836:	5b                   	pop    %ebx
  802837:	5e                   	pop    %esi
  802838:	5f                   	pop    %edi
  802839:	5d                   	pop    %ebp
  80283a:	c3                   	ret    

0080283b <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  80283b:	55                   	push   %ebp
  80283c:	89 e5                	mov    %esp,%ebp
  80283e:	83 ec 04             	sub    $0x4,%esp
  802841:	8b 45 10             	mov    0x10(%ebp),%eax
  802844:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  802847:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  80284b:	8b 45 08             	mov    0x8(%ebp),%eax
  80284e:	6a 00                	push   $0x0
  802850:	6a 00                	push   $0x0
  802852:	52                   	push   %edx
  802853:	ff 75 0c             	pushl  0xc(%ebp)
  802856:	50                   	push   %eax
  802857:	6a 00                	push   $0x0
  802859:	e8 b2 ff ff ff       	call   802810 <syscall>
  80285e:	83 c4 18             	add    $0x18,%esp
}
  802861:	90                   	nop
  802862:	c9                   	leave  
  802863:	c3                   	ret    

00802864 <sys_cgetc>:

int
sys_cgetc(void)
{
  802864:	55                   	push   %ebp
  802865:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  802867:	6a 00                	push   $0x0
  802869:	6a 00                	push   $0x0
  80286b:	6a 00                	push   $0x0
  80286d:	6a 00                	push   $0x0
  80286f:	6a 00                	push   $0x0
  802871:	6a 01                	push   $0x1
  802873:	e8 98 ff ff ff       	call   802810 <syscall>
  802878:	83 c4 18             	add    $0x18,%esp
}
  80287b:	c9                   	leave  
  80287c:	c3                   	ret    

0080287d <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  80287d:	55                   	push   %ebp
  80287e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  802880:	8b 55 0c             	mov    0xc(%ebp),%edx
  802883:	8b 45 08             	mov    0x8(%ebp),%eax
  802886:	6a 00                	push   $0x0
  802888:	6a 00                	push   $0x0
  80288a:	6a 00                	push   $0x0
  80288c:	52                   	push   %edx
  80288d:	50                   	push   %eax
  80288e:	6a 05                	push   $0x5
  802890:	e8 7b ff ff ff       	call   802810 <syscall>
  802895:	83 c4 18             	add    $0x18,%esp
}
  802898:	c9                   	leave  
  802899:	c3                   	ret    

0080289a <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  80289a:	55                   	push   %ebp
  80289b:	89 e5                	mov    %esp,%ebp
  80289d:	56                   	push   %esi
  80289e:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  80289f:	8b 75 18             	mov    0x18(%ebp),%esi
  8028a2:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8028a5:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8028a8:	8b 55 0c             	mov    0xc(%ebp),%edx
  8028ab:	8b 45 08             	mov    0x8(%ebp),%eax
  8028ae:	56                   	push   %esi
  8028af:	53                   	push   %ebx
  8028b0:	51                   	push   %ecx
  8028b1:	52                   	push   %edx
  8028b2:	50                   	push   %eax
  8028b3:	6a 06                	push   $0x6
  8028b5:	e8 56 ff ff ff       	call   802810 <syscall>
  8028ba:	83 c4 18             	add    $0x18,%esp
}
  8028bd:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8028c0:	5b                   	pop    %ebx
  8028c1:	5e                   	pop    %esi
  8028c2:	5d                   	pop    %ebp
  8028c3:	c3                   	ret    

008028c4 <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  8028c4:	55                   	push   %ebp
  8028c5:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  8028c7:	8b 55 0c             	mov    0xc(%ebp),%edx
  8028ca:	8b 45 08             	mov    0x8(%ebp),%eax
  8028cd:	6a 00                	push   $0x0
  8028cf:	6a 00                	push   $0x0
  8028d1:	6a 00                	push   $0x0
  8028d3:	52                   	push   %edx
  8028d4:	50                   	push   %eax
  8028d5:	6a 07                	push   $0x7
  8028d7:	e8 34 ff ff ff       	call   802810 <syscall>
  8028dc:	83 c4 18             	add    $0x18,%esp
}
  8028df:	c9                   	leave  
  8028e0:	c3                   	ret    

008028e1 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  8028e1:	55                   	push   %ebp
  8028e2:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  8028e4:	6a 00                	push   $0x0
  8028e6:	6a 00                	push   $0x0
  8028e8:	6a 00                	push   $0x0
  8028ea:	ff 75 0c             	pushl  0xc(%ebp)
  8028ed:	ff 75 08             	pushl  0x8(%ebp)
  8028f0:	6a 08                	push   $0x8
  8028f2:	e8 19 ff ff ff       	call   802810 <syscall>
  8028f7:	83 c4 18             	add    $0x18,%esp
}
  8028fa:	c9                   	leave  
  8028fb:	c3                   	ret    

008028fc <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  8028fc:	55                   	push   %ebp
  8028fd:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  8028ff:	6a 00                	push   $0x0
  802901:	6a 00                	push   $0x0
  802903:	6a 00                	push   $0x0
  802905:	6a 00                	push   $0x0
  802907:	6a 00                	push   $0x0
  802909:	6a 09                	push   $0x9
  80290b:	e8 00 ff ff ff       	call   802810 <syscall>
  802910:	83 c4 18             	add    $0x18,%esp
}
  802913:	c9                   	leave  
  802914:	c3                   	ret    

00802915 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  802915:	55                   	push   %ebp
  802916:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  802918:	6a 00                	push   $0x0
  80291a:	6a 00                	push   $0x0
  80291c:	6a 00                	push   $0x0
  80291e:	6a 00                	push   $0x0
  802920:	6a 00                	push   $0x0
  802922:	6a 0a                	push   $0xa
  802924:	e8 e7 fe ff ff       	call   802810 <syscall>
  802929:	83 c4 18             	add    $0x18,%esp
}
  80292c:	c9                   	leave  
  80292d:	c3                   	ret    

0080292e <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  80292e:	55                   	push   %ebp
  80292f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  802931:	6a 00                	push   $0x0
  802933:	6a 00                	push   $0x0
  802935:	6a 00                	push   $0x0
  802937:	6a 00                	push   $0x0
  802939:	6a 00                	push   $0x0
  80293b:	6a 0b                	push   $0xb
  80293d:	e8 ce fe ff ff       	call   802810 <syscall>
  802942:	83 c4 18             	add    $0x18,%esp
}
  802945:	c9                   	leave  
  802946:	c3                   	ret    

00802947 <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  802947:	55                   	push   %ebp
  802948:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  80294a:	6a 00                	push   $0x0
  80294c:	6a 00                	push   $0x0
  80294e:	6a 00                	push   $0x0
  802950:	ff 75 0c             	pushl  0xc(%ebp)
  802953:	ff 75 08             	pushl  0x8(%ebp)
  802956:	6a 0f                	push   $0xf
  802958:	e8 b3 fe ff ff       	call   802810 <syscall>
  80295d:	83 c4 18             	add    $0x18,%esp
	return;
  802960:	90                   	nop
}
  802961:	c9                   	leave  
  802962:	c3                   	ret    

00802963 <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  802963:	55                   	push   %ebp
  802964:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  802966:	6a 00                	push   $0x0
  802968:	6a 00                	push   $0x0
  80296a:	6a 00                	push   $0x0
  80296c:	ff 75 0c             	pushl  0xc(%ebp)
  80296f:	ff 75 08             	pushl  0x8(%ebp)
  802972:	6a 10                	push   $0x10
  802974:	e8 97 fe ff ff       	call   802810 <syscall>
  802979:	83 c4 18             	add    $0x18,%esp
	return ;
  80297c:	90                   	nop
}
  80297d:	c9                   	leave  
  80297e:	c3                   	ret    

0080297f <sys_allocate_chunk>:

void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  80297f:	55                   	push   %ebp
  802980:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  802982:	6a 00                	push   $0x0
  802984:	6a 00                	push   $0x0
  802986:	ff 75 10             	pushl  0x10(%ebp)
  802989:	ff 75 0c             	pushl  0xc(%ebp)
  80298c:	ff 75 08             	pushl  0x8(%ebp)
  80298f:	6a 11                	push   $0x11
  802991:	e8 7a fe ff ff       	call   802810 <syscall>
  802996:	83 c4 18             	add    $0x18,%esp
	return ;
  802999:	90                   	nop
}
  80299a:	c9                   	leave  
  80299b:	c3                   	ret    

0080299c <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  80299c:	55                   	push   %ebp
  80299d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  80299f:	6a 00                	push   $0x0
  8029a1:	6a 00                	push   $0x0
  8029a3:	6a 00                	push   $0x0
  8029a5:	6a 00                	push   $0x0
  8029a7:	6a 00                	push   $0x0
  8029a9:	6a 0c                	push   $0xc
  8029ab:	e8 60 fe ff ff       	call   802810 <syscall>
  8029b0:	83 c4 18             	add    $0x18,%esp
}
  8029b3:	c9                   	leave  
  8029b4:	c3                   	ret    

008029b5 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  8029b5:	55                   	push   %ebp
  8029b6:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  8029b8:	6a 00                	push   $0x0
  8029ba:	6a 00                	push   $0x0
  8029bc:	6a 00                	push   $0x0
  8029be:	6a 00                	push   $0x0
  8029c0:	ff 75 08             	pushl  0x8(%ebp)
  8029c3:	6a 0d                	push   $0xd
  8029c5:	e8 46 fe ff ff       	call   802810 <syscall>
  8029ca:	83 c4 18             	add    $0x18,%esp
}
  8029cd:	c9                   	leave  
  8029ce:	c3                   	ret    

008029cf <sys_scarce_memory>:

void sys_scarce_memory()
{
  8029cf:	55                   	push   %ebp
  8029d0:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  8029d2:	6a 00                	push   $0x0
  8029d4:	6a 00                	push   $0x0
  8029d6:	6a 00                	push   $0x0
  8029d8:	6a 00                	push   $0x0
  8029da:	6a 00                	push   $0x0
  8029dc:	6a 0e                	push   $0xe
  8029de:	e8 2d fe ff ff       	call   802810 <syscall>
  8029e3:	83 c4 18             	add    $0x18,%esp
}
  8029e6:	90                   	nop
  8029e7:	c9                   	leave  
  8029e8:	c3                   	ret    

008029e9 <sys_disable_interrupt>:

//NEW !! 2012...
void
sys_disable_interrupt()
{
  8029e9:	55                   	push   %ebp
  8029ea:	89 e5                	mov    %esp,%ebp
	syscall(SYS_disableINTR,0, 0, 0, 0, 0);
  8029ec:	6a 00                	push   $0x0
  8029ee:	6a 00                	push   $0x0
  8029f0:	6a 00                	push   $0x0
  8029f2:	6a 00                	push   $0x0
  8029f4:	6a 00                	push   $0x0
  8029f6:	6a 13                	push   $0x13
  8029f8:	e8 13 fe ff ff       	call   802810 <syscall>
  8029fd:	83 c4 18             	add    $0x18,%esp
}
  802a00:	90                   	nop
  802a01:	c9                   	leave  
  802a02:	c3                   	ret    

00802a03 <sys_enable_interrupt>:


void
sys_enable_interrupt()
{
  802a03:	55                   	push   %ebp
  802a04:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enableINTR,0, 0, 0, 0, 0);
  802a06:	6a 00                	push   $0x0
  802a08:	6a 00                	push   $0x0
  802a0a:	6a 00                	push   $0x0
  802a0c:	6a 00                	push   $0x0
  802a0e:	6a 00                	push   $0x0
  802a10:	6a 14                	push   $0x14
  802a12:	e8 f9 fd ff ff       	call   802810 <syscall>
  802a17:	83 c4 18             	add    $0x18,%esp
}
  802a1a:	90                   	nop
  802a1b:	c9                   	leave  
  802a1c:	c3                   	ret    

00802a1d <sys_cputc>:


void
sys_cputc(const char c)
{
  802a1d:	55                   	push   %ebp
  802a1e:	89 e5                	mov    %esp,%ebp
  802a20:	83 ec 04             	sub    $0x4,%esp
  802a23:	8b 45 08             	mov    0x8(%ebp),%eax
  802a26:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  802a29:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  802a2d:	6a 00                	push   $0x0
  802a2f:	6a 00                	push   $0x0
  802a31:	6a 00                	push   $0x0
  802a33:	6a 00                	push   $0x0
  802a35:	50                   	push   %eax
  802a36:	6a 15                	push   $0x15
  802a38:	e8 d3 fd ff ff       	call   802810 <syscall>
  802a3d:	83 c4 18             	add    $0x18,%esp
}
  802a40:	90                   	nop
  802a41:	c9                   	leave  
  802a42:	c3                   	ret    

00802a43 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  802a43:	55                   	push   %ebp
  802a44:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  802a46:	6a 00                	push   $0x0
  802a48:	6a 00                	push   $0x0
  802a4a:	6a 00                	push   $0x0
  802a4c:	6a 00                	push   $0x0
  802a4e:	6a 00                	push   $0x0
  802a50:	6a 16                	push   $0x16
  802a52:	e8 b9 fd ff ff       	call   802810 <syscall>
  802a57:	83 c4 18             	add    $0x18,%esp
}
  802a5a:	90                   	nop
  802a5b:	c9                   	leave  
  802a5c:	c3                   	ret    

00802a5d <sys_createSemaphore>:

int
sys_createSemaphore(char* semaphoreName, uint32 initialValue)
{
  802a5d:	55                   	push   %ebp
  802a5e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_semaphore,(uint32)semaphoreName, (uint32)initialValue, 0, 0, 0);
  802a60:	8b 45 08             	mov    0x8(%ebp),%eax
  802a63:	6a 00                	push   $0x0
  802a65:	6a 00                	push   $0x0
  802a67:	6a 00                	push   $0x0
  802a69:	ff 75 0c             	pushl  0xc(%ebp)
  802a6c:	50                   	push   %eax
  802a6d:	6a 17                	push   $0x17
  802a6f:	e8 9c fd ff ff       	call   802810 <syscall>
  802a74:	83 c4 18             	add    $0x18,%esp
}
  802a77:	c9                   	leave  
  802a78:	c3                   	ret    

00802a79 <sys_getSemaphoreValue>:

int
sys_getSemaphoreValue(int32 ownerEnvID, char* semaphoreName)
{
  802a79:	55                   	push   %ebp
  802a7a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_semaphore_value,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  802a7c:	8b 55 0c             	mov    0xc(%ebp),%edx
  802a7f:	8b 45 08             	mov    0x8(%ebp),%eax
  802a82:	6a 00                	push   $0x0
  802a84:	6a 00                	push   $0x0
  802a86:	6a 00                	push   $0x0
  802a88:	52                   	push   %edx
  802a89:	50                   	push   %eax
  802a8a:	6a 1a                	push   $0x1a
  802a8c:	e8 7f fd ff ff       	call   802810 <syscall>
  802a91:	83 c4 18             	add    $0x18,%esp
}
  802a94:	c9                   	leave  
  802a95:	c3                   	ret    

00802a96 <sys_waitSemaphore>:

void
sys_waitSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  802a96:	55                   	push   %ebp
  802a97:	89 e5                	mov    %esp,%ebp
	syscall(SYS_wait_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  802a99:	8b 55 0c             	mov    0xc(%ebp),%edx
  802a9c:	8b 45 08             	mov    0x8(%ebp),%eax
  802a9f:	6a 00                	push   $0x0
  802aa1:	6a 00                	push   $0x0
  802aa3:	6a 00                	push   $0x0
  802aa5:	52                   	push   %edx
  802aa6:	50                   	push   %eax
  802aa7:	6a 18                	push   $0x18
  802aa9:	e8 62 fd ff ff       	call   802810 <syscall>
  802aae:	83 c4 18             	add    $0x18,%esp
}
  802ab1:	90                   	nop
  802ab2:	c9                   	leave  
  802ab3:	c3                   	ret    

00802ab4 <sys_signalSemaphore>:

void
sys_signalSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  802ab4:	55                   	push   %ebp
  802ab5:	89 e5                	mov    %esp,%ebp
	syscall(SYS_signal_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  802ab7:	8b 55 0c             	mov    0xc(%ebp),%edx
  802aba:	8b 45 08             	mov    0x8(%ebp),%eax
  802abd:	6a 00                	push   $0x0
  802abf:	6a 00                	push   $0x0
  802ac1:	6a 00                	push   $0x0
  802ac3:	52                   	push   %edx
  802ac4:	50                   	push   %eax
  802ac5:	6a 19                	push   $0x19
  802ac7:	e8 44 fd ff ff       	call   802810 <syscall>
  802acc:	83 c4 18             	add    $0x18,%esp
}
  802acf:	90                   	nop
  802ad0:	c9                   	leave  
  802ad1:	c3                   	ret    

00802ad2 <sys_createSharedObject>:

int
sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  802ad2:	55                   	push   %ebp
  802ad3:	89 e5                	mov    %esp,%ebp
  802ad5:	83 ec 04             	sub    $0x4,%esp
  802ad8:	8b 45 10             	mov    0x10(%ebp),%eax
  802adb:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  802ade:	8b 4d 14             	mov    0x14(%ebp),%ecx
  802ae1:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  802ae5:	8b 45 08             	mov    0x8(%ebp),%eax
  802ae8:	6a 00                	push   $0x0
  802aea:	51                   	push   %ecx
  802aeb:	52                   	push   %edx
  802aec:	ff 75 0c             	pushl  0xc(%ebp)
  802aef:	50                   	push   %eax
  802af0:	6a 1b                	push   $0x1b
  802af2:	e8 19 fd ff ff       	call   802810 <syscall>
  802af7:	83 c4 18             	add    $0x18,%esp
}
  802afa:	c9                   	leave  
  802afb:	c3                   	ret    

00802afc <sys_getSizeOfSharedObject>:

//2017:
int
sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  802afc:	55                   	push   %ebp
  802afd:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  802aff:	8b 55 0c             	mov    0xc(%ebp),%edx
  802b02:	8b 45 08             	mov    0x8(%ebp),%eax
  802b05:	6a 00                	push   $0x0
  802b07:	6a 00                	push   $0x0
  802b09:	6a 00                	push   $0x0
  802b0b:	52                   	push   %edx
  802b0c:	50                   	push   %eax
  802b0d:	6a 1c                	push   $0x1c
  802b0f:	e8 fc fc ff ff       	call   802810 <syscall>
  802b14:	83 c4 18             	add    $0x18,%esp
}
  802b17:	c9                   	leave  
  802b18:	c3                   	ret    

00802b19 <sys_getSharedObject>:
//==========

int
sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  802b19:	55                   	push   %ebp
  802b1a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  802b1c:	8b 4d 10             	mov    0x10(%ebp),%ecx
  802b1f:	8b 55 0c             	mov    0xc(%ebp),%edx
  802b22:	8b 45 08             	mov    0x8(%ebp),%eax
  802b25:	6a 00                	push   $0x0
  802b27:	6a 00                	push   $0x0
  802b29:	51                   	push   %ecx
  802b2a:	52                   	push   %edx
  802b2b:	50                   	push   %eax
  802b2c:	6a 1d                	push   $0x1d
  802b2e:	e8 dd fc ff ff       	call   802810 <syscall>
  802b33:	83 c4 18             	add    $0x18,%esp
}
  802b36:	c9                   	leave  
  802b37:	c3                   	ret    

00802b38 <sys_freeSharedObject>:

int
sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  802b38:	55                   	push   %ebp
  802b39:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  802b3b:	8b 55 0c             	mov    0xc(%ebp),%edx
  802b3e:	8b 45 08             	mov    0x8(%ebp),%eax
  802b41:	6a 00                	push   $0x0
  802b43:	6a 00                	push   $0x0
  802b45:	6a 00                	push   $0x0
  802b47:	52                   	push   %edx
  802b48:	50                   	push   %eax
  802b49:	6a 1e                	push   $0x1e
  802b4b:	e8 c0 fc ff ff       	call   802810 <syscall>
  802b50:	83 c4 18             	add    $0x18,%esp
}
  802b53:	c9                   	leave  
  802b54:	c3                   	ret    

00802b55 <sys_getMaxShares>:

uint32 	sys_getMaxShares()
{
  802b55:	55                   	push   %ebp
  802b56:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_max_shares,0, 0, 0, 0, 0);
  802b58:	6a 00                	push   $0x0
  802b5a:	6a 00                	push   $0x0
  802b5c:	6a 00                	push   $0x0
  802b5e:	6a 00                	push   $0x0
  802b60:	6a 00                	push   $0x0
  802b62:	6a 1f                	push   $0x1f
  802b64:	e8 a7 fc ff ff       	call   802810 <syscall>
  802b69:	83 c4 18             	add    $0x18,%esp
}
  802b6c:	c9                   	leave  
  802b6d:	c3                   	ret    

00802b6e <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  802b6e:	55                   	push   %ebp
  802b6f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  802b71:	8b 45 08             	mov    0x8(%ebp),%eax
  802b74:	6a 00                	push   $0x0
  802b76:	ff 75 14             	pushl  0x14(%ebp)
  802b79:	ff 75 10             	pushl  0x10(%ebp)
  802b7c:	ff 75 0c             	pushl  0xc(%ebp)
  802b7f:	50                   	push   %eax
  802b80:	6a 20                	push   $0x20
  802b82:	e8 89 fc ff ff       	call   802810 <syscall>
  802b87:	83 c4 18             	add    $0x18,%esp
}
  802b8a:	c9                   	leave  
  802b8b:	c3                   	ret    

00802b8c <sys_run_env>:

void
sys_run_env(int32 envId)
{
  802b8c:	55                   	push   %ebp
  802b8d:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  802b8f:	8b 45 08             	mov    0x8(%ebp),%eax
  802b92:	6a 00                	push   $0x0
  802b94:	6a 00                	push   $0x0
  802b96:	6a 00                	push   $0x0
  802b98:	6a 00                	push   $0x0
  802b9a:	50                   	push   %eax
  802b9b:	6a 21                	push   $0x21
  802b9d:	e8 6e fc ff ff       	call   802810 <syscall>
  802ba2:	83 c4 18             	add    $0x18,%esp
}
  802ba5:	90                   	nop
  802ba6:	c9                   	leave  
  802ba7:	c3                   	ret    

00802ba8 <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  802ba8:	55                   	push   %ebp
  802ba9:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  802bab:	8b 45 08             	mov    0x8(%ebp),%eax
  802bae:	6a 00                	push   $0x0
  802bb0:	6a 00                	push   $0x0
  802bb2:	6a 00                	push   $0x0
  802bb4:	6a 00                	push   $0x0
  802bb6:	50                   	push   %eax
  802bb7:	6a 22                	push   $0x22
  802bb9:	e8 52 fc ff ff       	call   802810 <syscall>
  802bbe:	83 c4 18             	add    $0x18,%esp
}
  802bc1:	c9                   	leave  
  802bc2:	c3                   	ret    

00802bc3 <sys_getenvid>:

int32 sys_getenvid(void)
{
  802bc3:	55                   	push   %ebp
  802bc4:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  802bc6:	6a 00                	push   $0x0
  802bc8:	6a 00                	push   $0x0
  802bca:	6a 00                	push   $0x0
  802bcc:	6a 00                	push   $0x0
  802bce:	6a 00                	push   $0x0
  802bd0:	6a 02                	push   $0x2
  802bd2:	e8 39 fc ff ff       	call   802810 <syscall>
  802bd7:	83 c4 18             	add    $0x18,%esp
}
  802bda:	c9                   	leave  
  802bdb:	c3                   	ret    

00802bdc <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  802bdc:	55                   	push   %ebp
  802bdd:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  802bdf:	6a 00                	push   $0x0
  802be1:	6a 00                	push   $0x0
  802be3:	6a 00                	push   $0x0
  802be5:	6a 00                	push   $0x0
  802be7:	6a 00                	push   $0x0
  802be9:	6a 03                	push   $0x3
  802beb:	e8 20 fc ff ff       	call   802810 <syscall>
  802bf0:	83 c4 18             	add    $0x18,%esp
}
  802bf3:	c9                   	leave  
  802bf4:	c3                   	ret    

00802bf5 <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  802bf5:	55                   	push   %ebp
  802bf6:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  802bf8:	6a 00                	push   $0x0
  802bfa:	6a 00                	push   $0x0
  802bfc:	6a 00                	push   $0x0
  802bfe:	6a 00                	push   $0x0
  802c00:	6a 00                	push   $0x0
  802c02:	6a 04                	push   $0x4
  802c04:	e8 07 fc ff ff       	call   802810 <syscall>
  802c09:	83 c4 18             	add    $0x18,%esp
}
  802c0c:	c9                   	leave  
  802c0d:	c3                   	ret    

00802c0e <sys_exit_env>:


void sys_exit_env(void)
{
  802c0e:	55                   	push   %ebp
  802c0f:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  802c11:	6a 00                	push   $0x0
  802c13:	6a 00                	push   $0x0
  802c15:	6a 00                	push   $0x0
  802c17:	6a 00                	push   $0x0
  802c19:	6a 00                	push   $0x0
  802c1b:	6a 23                	push   $0x23
  802c1d:	e8 ee fb ff ff       	call   802810 <syscall>
  802c22:	83 c4 18             	add    $0x18,%esp
}
  802c25:	90                   	nop
  802c26:	c9                   	leave  
  802c27:	c3                   	ret    

00802c28 <sys_get_virtual_time>:


struct uint64
sys_get_virtual_time()
{
  802c28:	55                   	push   %ebp
  802c29:	89 e5                	mov    %esp,%ebp
  802c2b:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  802c2e:	8d 45 f8             	lea    -0x8(%ebp),%eax
  802c31:	8d 50 04             	lea    0x4(%eax),%edx
  802c34:	8d 45 f8             	lea    -0x8(%ebp),%eax
  802c37:	6a 00                	push   $0x0
  802c39:	6a 00                	push   $0x0
  802c3b:	6a 00                	push   $0x0
  802c3d:	52                   	push   %edx
  802c3e:	50                   	push   %eax
  802c3f:	6a 24                	push   $0x24
  802c41:	e8 ca fb ff ff       	call   802810 <syscall>
  802c46:	83 c4 18             	add    $0x18,%esp
	return result;
  802c49:	8b 4d 08             	mov    0x8(%ebp),%ecx
  802c4c:	8b 45 f8             	mov    -0x8(%ebp),%eax
  802c4f:	8b 55 fc             	mov    -0x4(%ebp),%edx
  802c52:	89 01                	mov    %eax,(%ecx)
  802c54:	89 51 04             	mov    %edx,0x4(%ecx)
}
  802c57:	8b 45 08             	mov    0x8(%ebp),%eax
  802c5a:	c9                   	leave  
  802c5b:	c2 04 00             	ret    $0x4

00802c5e <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  802c5e:	55                   	push   %ebp
  802c5f:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  802c61:	6a 00                	push   $0x0
  802c63:	6a 00                	push   $0x0
  802c65:	ff 75 10             	pushl  0x10(%ebp)
  802c68:	ff 75 0c             	pushl  0xc(%ebp)
  802c6b:	ff 75 08             	pushl  0x8(%ebp)
  802c6e:	6a 12                	push   $0x12
  802c70:	e8 9b fb ff ff       	call   802810 <syscall>
  802c75:	83 c4 18             	add    $0x18,%esp
	return ;
  802c78:	90                   	nop
}
  802c79:	c9                   	leave  
  802c7a:	c3                   	ret    

00802c7b <sys_rcr2>:
uint32 sys_rcr2()
{
  802c7b:	55                   	push   %ebp
  802c7c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  802c7e:	6a 00                	push   $0x0
  802c80:	6a 00                	push   $0x0
  802c82:	6a 00                	push   $0x0
  802c84:	6a 00                	push   $0x0
  802c86:	6a 00                	push   $0x0
  802c88:	6a 25                	push   $0x25
  802c8a:	e8 81 fb ff ff       	call   802810 <syscall>
  802c8f:	83 c4 18             	add    $0x18,%esp
}
  802c92:	c9                   	leave  
  802c93:	c3                   	ret    

00802c94 <sys_bypassPageFault>:
void sys_bypassPageFault(uint8 instrLength)
{
  802c94:	55                   	push   %ebp
  802c95:	89 e5                	mov    %esp,%ebp
  802c97:	83 ec 04             	sub    $0x4,%esp
  802c9a:	8b 45 08             	mov    0x8(%ebp),%eax
  802c9d:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  802ca0:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  802ca4:	6a 00                	push   $0x0
  802ca6:	6a 00                	push   $0x0
  802ca8:	6a 00                	push   $0x0
  802caa:	6a 00                	push   $0x0
  802cac:	50                   	push   %eax
  802cad:	6a 26                	push   $0x26
  802caf:	e8 5c fb ff ff       	call   802810 <syscall>
  802cb4:	83 c4 18             	add    $0x18,%esp
	return ;
  802cb7:	90                   	nop
}
  802cb8:	c9                   	leave  
  802cb9:	c3                   	ret    

00802cba <rsttst>:
void rsttst()
{
  802cba:	55                   	push   %ebp
  802cbb:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  802cbd:	6a 00                	push   $0x0
  802cbf:	6a 00                	push   $0x0
  802cc1:	6a 00                	push   $0x0
  802cc3:	6a 00                	push   $0x0
  802cc5:	6a 00                	push   $0x0
  802cc7:	6a 28                	push   $0x28
  802cc9:	e8 42 fb ff ff       	call   802810 <syscall>
  802cce:	83 c4 18             	add    $0x18,%esp
	return ;
  802cd1:	90                   	nop
}
  802cd2:	c9                   	leave  
  802cd3:	c3                   	ret    

00802cd4 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  802cd4:	55                   	push   %ebp
  802cd5:	89 e5                	mov    %esp,%ebp
  802cd7:	83 ec 04             	sub    $0x4,%esp
  802cda:	8b 45 14             	mov    0x14(%ebp),%eax
  802cdd:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  802ce0:	8b 55 18             	mov    0x18(%ebp),%edx
  802ce3:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  802ce7:	52                   	push   %edx
  802ce8:	50                   	push   %eax
  802ce9:	ff 75 10             	pushl  0x10(%ebp)
  802cec:	ff 75 0c             	pushl  0xc(%ebp)
  802cef:	ff 75 08             	pushl  0x8(%ebp)
  802cf2:	6a 27                	push   $0x27
  802cf4:	e8 17 fb ff ff       	call   802810 <syscall>
  802cf9:	83 c4 18             	add    $0x18,%esp
	return ;
  802cfc:	90                   	nop
}
  802cfd:	c9                   	leave  
  802cfe:	c3                   	ret    

00802cff <chktst>:
void chktst(uint32 n)
{
  802cff:	55                   	push   %ebp
  802d00:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  802d02:	6a 00                	push   $0x0
  802d04:	6a 00                	push   $0x0
  802d06:	6a 00                	push   $0x0
  802d08:	6a 00                	push   $0x0
  802d0a:	ff 75 08             	pushl  0x8(%ebp)
  802d0d:	6a 29                	push   $0x29
  802d0f:	e8 fc fa ff ff       	call   802810 <syscall>
  802d14:	83 c4 18             	add    $0x18,%esp
	return ;
  802d17:	90                   	nop
}
  802d18:	c9                   	leave  
  802d19:	c3                   	ret    

00802d1a <inctst>:

void inctst()
{
  802d1a:	55                   	push   %ebp
  802d1b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  802d1d:	6a 00                	push   $0x0
  802d1f:	6a 00                	push   $0x0
  802d21:	6a 00                	push   $0x0
  802d23:	6a 00                	push   $0x0
  802d25:	6a 00                	push   $0x0
  802d27:	6a 2a                	push   $0x2a
  802d29:	e8 e2 fa ff ff       	call   802810 <syscall>
  802d2e:	83 c4 18             	add    $0x18,%esp
	return ;
  802d31:	90                   	nop
}
  802d32:	c9                   	leave  
  802d33:	c3                   	ret    

00802d34 <gettst>:
uint32 gettst()
{
  802d34:	55                   	push   %ebp
  802d35:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  802d37:	6a 00                	push   $0x0
  802d39:	6a 00                	push   $0x0
  802d3b:	6a 00                	push   $0x0
  802d3d:	6a 00                	push   $0x0
  802d3f:	6a 00                	push   $0x0
  802d41:	6a 2b                	push   $0x2b
  802d43:	e8 c8 fa ff ff       	call   802810 <syscall>
  802d48:	83 c4 18             	add    $0x18,%esp
}
  802d4b:	c9                   	leave  
  802d4c:	c3                   	ret    

00802d4d <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  802d4d:	55                   	push   %ebp
  802d4e:	89 e5                	mov    %esp,%ebp
  802d50:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  802d53:	6a 00                	push   $0x0
  802d55:	6a 00                	push   $0x0
  802d57:	6a 00                	push   $0x0
  802d59:	6a 00                	push   $0x0
  802d5b:	6a 00                	push   $0x0
  802d5d:	6a 2c                	push   $0x2c
  802d5f:	e8 ac fa ff ff       	call   802810 <syscall>
  802d64:	83 c4 18             	add    $0x18,%esp
  802d67:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  802d6a:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  802d6e:	75 07                	jne    802d77 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  802d70:	b8 01 00 00 00       	mov    $0x1,%eax
  802d75:	eb 05                	jmp    802d7c <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  802d77:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802d7c:	c9                   	leave  
  802d7d:	c3                   	ret    

00802d7e <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  802d7e:	55                   	push   %ebp
  802d7f:	89 e5                	mov    %esp,%ebp
  802d81:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  802d84:	6a 00                	push   $0x0
  802d86:	6a 00                	push   $0x0
  802d88:	6a 00                	push   $0x0
  802d8a:	6a 00                	push   $0x0
  802d8c:	6a 00                	push   $0x0
  802d8e:	6a 2c                	push   $0x2c
  802d90:	e8 7b fa ff ff       	call   802810 <syscall>
  802d95:	83 c4 18             	add    $0x18,%esp
  802d98:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  802d9b:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  802d9f:	75 07                	jne    802da8 <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  802da1:	b8 01 00 00 00       	mov    $0x1,%eax
  802da6:	eb 05                	jmp    802dad <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  802da8:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802dad:	c9                   	leave  
  802dae:	c3                   	ret    

00802daf <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  802daf:	55                   	push   %ebp
  802db0:	89 e5                	mov    %esp,%ebp
  802db2:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  802db5:	6a 00                	push   $0x0
  802db7:	6a 00                	push   $0x0
  802db9:	6a 00                	push   $0x0
  802dbb:	6a 00                	push   $0x0
  802dbd:	6a 00                	push   $0x0
  802dbf:	6a 2c                	push   $0x2c
  802dc1:	e8 4a fa ff ff       	call   802810 <syscall>
  802dc6:	83 c4 18             	add    $0x18,%esp
  802dc9:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  802dcc:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  802dd0:	75 07                	jne    802dd9 <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  802dd2:	b8 01 00 00 00       	mov    $0x1,%eax
  802dd7:	eb 05                	jmp    802dde <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  802dd9:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802dde:	c9                   	leave  
  802ddf:	c3                   	ret    

00802de0 <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  802de0:	55                   	push   %ebp
  802de1:	89 e5                	mov    %esp,%ebp
  802de3:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  802de6:	6a 00                	push   $0x0
  802de8:	6a 00                	push   $0x0
  802dea:	6a 00                	push   $0x0
  802dec:	6a 00                	push   $0x0
  802dee:	6a 00                	push   $0x0
  802df0:	6a 2c                	push   $0x2c
  802df2:	e8 19 fa ff ff       	call   802810 <syscall>
  802df7:	83 c4 18             	add    $0x18,%esp
  802dfa:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  802dfd:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  802e01:	75 07                	jne    802e0a <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  802e03:	b8 01 00 00 00       	mov    $0x1,%eax
  802e08:	eb 05                	jmp    802e0f <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  802e0a:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802e0f:	c9                   	leave  
  802e10:	c3                   	ret    

00802e11 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  802e11:	55                   	push   %ebp
  802e12:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  802e14:	6a 00                	push   $0x0
  802e16:	6a 00                	push   $0x0
  802e18:	6a 00                	push   $0x0
  802e1a:	6a 00                	push   $0x0
  802e1c:	ff 75 08             	pushl  0x8(%ebp)
  802e1f:	6a 2d                	push   $0x2d
  802e21:	e8 ea f9 ff ff       	call   802810 <syscall>
  802e26:	83 c4 18             	add    $0x18,%esp
	return ;
  802e29:	90                   	nop
}
  802e2a:	c9                   	leave  
  802e2b:	c3                   	ret    

00802e2c <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  802e2c:	55                   	push   %ebp
  802e2d:	89 e5                	mov    %esp,%ebp
  802e2f:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  802e30:	8b 5d 14             	mov    0x14(%ebp),%ebx
  802e33:	8b 4d 10             	mov    0x10(%ebp),%ecx
  802e36:	8b 55 0c             	mov    0xc(%ebp),%edx
  802e39:	8b 45 08             	mov    0x8(%ebp),%eax
  802e3c:	6a 00                	push   $0x0
  802e3e:	53                   	push   %ebx
  802e3f:	51                   	push   %ecx
  802e40:	52                   	push   %edx
  802e41:	50                   	push   %eax
  802e42:	6a 2e                	push   $0x2e
  802e44:	e8 c7 f9 ff ff       	call   802810 <syscall>
  802e49:	83 c4 18             	add    $0x18,%esp
}
  802e4c:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802e4f:	c9                   	leave  
  802e50:	c3                   	ret    

00802e51 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  802e51:	55                   	push   %ebp
  802e52:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  802e54:	8b 55 0c             	mov    0xc(%ebp),%edx
  802e57:	8b 45 08             	mov    0x8(%ebp),%eax
  802e5a:	6a 00                	push   $0x0
  802e5c:	6a 00                	push   $0x0
  802e5e:	6a 00                	push   $0x0
  802e60:	52                   	push   %edx
  802e61:	50                   	push   %eax
  802e62:	6a 2f                	push   $0x2f
  802e64:	e8 a7 f9 ff ff       	call   802810 <syscall>
  802e69:	83 c4 18             	add    $0x18,%esp
}
  802e6c:	c9                   	leave  
  802e6d:	c3                   	ret    

00802e6e <print_mem_block_lists>:
//===========================
// PRINT MEM BLOCK LISTS:
//===========================

void print_mem_block_lists()
{
  802e6e:	55                   	push   %ebp
  802e6f:	89 e5                	mov    %esp,%ebp
  802e71:	83 ec 18             	sub    $0x18,%esp
	cprintf("\n=========================================\n");
  802e74:	83 ec 0c             	sub    $0xc,%esp
  802e77:	68 a0 4a 80 00       	push   $0x804aa0
  802e7c:	e8 dd e6 ff ff       	call   80155e <cprintf>
  802e81:	83 c4 10             	add    $0x10,%esp
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
  802e84:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nFreeMemBlocksList:\n");
  802e8b:	83 ec 0c             	sub    $0xc,%esp
  802e8e:	68 cc 4a 80 00       	push   $0x804acc
  802e93:	e8 c6 e6 ff ff       	call   80155e <cprintf>
  802e98:	83 c4 10             	add    $0x10,%esp
	uint8 sorted = 1 ;
  802e9b:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &FreeMemBlocksList)
  802e9f:	a1 38 51 80 00       	mov    0x805138,%eax
  802ea4:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802ea7:	eb 56                	jmp    802eff <print_mem_block_lists+0x91>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  802ea9:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802ead:	74 1c                	je     802ecb <print_mem_block_lists+0x5d>
  802eaf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802eb2:	8b 50 08             	mov    0x8(%eax),%edx
  802eb5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802eb8:	8b 48 08             	mov    0x8(%eax),%ecx
  802ebb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ebe:	8b 40 0c             	mov    0xc(%eax),%eax
  802ec1:	01 c8                	add    %ecx,%eax
  802ec3:	39 c2                	cmp    %eax,%edx
  802ec5:	73 04                	jae    802ecb <print_mem_block_lists+0x5d>
			sorted = 0 ;
  802ec7:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  802ecb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ece:	8b 50 08             	mov    0x8(%eax),%edx
  802ed1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ed4:	8b 40 0c             	mov    0xc(%eax),%eax
  802ed7:	01 c2                	add    %eax,%edx
  802ed9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802edc:	8b 40 08             	mov    0x8(%eax),%eax
  802edf:	83 ec 04             	sub    $0x4,%esp
  802ee2:	52                   	push   %edx
  802ee3:	50                   	push   %eax
  802ee4:	68 e1 4a 80 00       	push   $0x804ae1
  802ee9:	e8 70 e6 ff ff       	call   80155e <cprintf>
  802eee:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  802ef1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ef4:	89 45 f0             	mov    %eax,-0x10(%ebp)
	cprintf("\n=========================================\n");
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
	cprintf("\nFreeMemBlocksList:\n");
	uint8 sorted = 1 ;
	LIST_FOREACH(blk, &FreeMemBlocksList)
  802ef7:	a1 40 51 80 00       	mov    0x805140,%eax
  802efc:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802eff:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802f03:	74 07                	je     802f0c <print_mem_block_lists+0x9e>
  802f05:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f08:	8b 00                	mov    (%eax),%eax
  802f0a:	eb 05                	jmp    802f11 <print_mem_block_lists+0xa3>
  802f0c:	b8 00 00 00 00       	mov    $0x0,%eax
  802f11:	a3 40 51 80 00       	mov    %eax,0x805140
  802f16:	a1 40 51 80 00       	mov    0x805140,%eax
  802f1b:	85 c0                	test   %eax,%eax
  802f1d:	75 8a                	jne    802ea9 <print_mem_block_lists+0x3b>
  802f1f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802f23:	75 84                	jne    802ea9 <print_mem_block_lists+0x3b>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;
  802f25:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  802f29:	75 10                	jne    802f3b <print_mem_block_lists+0xcd>
  802f2b:	83 ec 0c             	sub    $0xc,%esp
  802f2e:	68 f0 4a 80 00       	push   $0x804af0
  802f33:	e8 26 e6 ff ff       	call   80155e <cprintf>
  802f38:	83 c4 10             	add    $0x10,%esp

	lastBlk = NULL ;
  802f3b:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nAllocMemBlocksList:\n");
  802f42:	83 ec 0c             	sub    $0xc,%esp
  802f45:	68 14 4b 80 00       	push   $0x804b14
  802f4a:	e8 0f e6 ff ff       	call   80155e <cprintf>
  802f4f:	83 c4 10             	add    $0x10,%esp
	sorted = 1 ;
  802f52:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &AllocMemBlocksList)
  802f56:	a1 40 50 80 00       	mov    0x805040,%eax
  802f5b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802f5e:	eb 56                	jmp    802fb6 <print_mem_block_lists+0x148>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  802f60:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802f64:	74 1c                	je     802f82 <print_mem_block_lists+0x114>
  802f66:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f69:	8b 50 08             	mov    0x8(%eax),%edx
  802f6c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802f6f:	8b 48 08             	mov    0x8(%eax),%ecx
  802f72:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802f75:	8b 40 0c             	mov    0xc(%eax),%eax
  802f78:	01 c8                	add    %ecx,%eax
  802f7a:	39 c2                	cmp    %eax,%edx
  802f7c:	73 04                	jae    802f82 <print_mem_block_lists+0x114>
			sorted = 0 ;
  802f7e:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  802f82:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f85:	8b 50 08             	mov    0x8(%eax),%edx
  802f88:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f8b:	8b 40 0c             	mov    0xc(%eax),%eax
  802f8e:	01 c2                	add    %eax,%edx
  802f90:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f93:	8b 40 08             	mov    0x8(%eax),%eax
  802f96:	83 ec 04             	sub    $0x4,%esp
  802f99:	52                   	push   %edx
  802f9a:	50                   	push   %eax
  802f9b:	68 e1 4a 80 00       	push   $0x804ae1
  802fa0:	e8 b9 e5 ff ff       	call   80155e <cprintf>
  802fa5:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  802fa8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802fab:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;

	lastBlk = NULL ;
	cprintf("\nAllocMemBlocksList:\n");
	sorted = 1 ;
	LIST_FOREACH(blk, &AllocMemBlocksList)
  802fae:	a1 48 50 80 00       	mov    0x805048,%eax
  802fb3:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802fb6:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802fba:	74 07                	je     802fc3 <print_mem_block_lists+0x155>
  802fbc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802fbf:	8b 00                	mov    (%eax),%eax
  802fc1:	eb 05                	jmp    802fc8 <print_mem_block_lists+0x15a>
  802fc3:	b8 00 00 00 00       	mov    $0x0,%eax
  802fc8:	a3 48 50 80 00       	mov    %eax,0x805048
  802fcd:	a1 48 50 80 00       	mov    0x805048,%eax
  802fd2:	85 c0                	test   %eax,%eax
  802fd4:	75 8a                	jne    802f60 <print_mem_block_lists+0xf2>
  802fd6:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802fda:	75 84                	jne    802f60 <print_mem_block_lists+0xf2>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nAllocMemBlocksList is NOT SORTED!!\n") ;
  802fdc:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  802fe0:	75 10                	jne    802ff2 <print_mem_block_lists+0x184>
  802fe2:	83 ec 0c             	sub    $0xc,%esp
  802fe5:	68 2c 4b 80 00       	push   $0x804b2c
  802fea:	e8 6f e5 ff ff       	call   80155e <cprintf>
  802fef:	83 c4 10             	add    $0x10,%esp
	cprintf("\n=========================================\n");
  802ff2:	83 ec 0c             	sub    $0xc,%esp
  802ff5:	68 a0 4a 80 00       	push   $0x804aa0
  802ffa:	e8 5f e5 ff ff       	call   80155e <cprintf>
  802fff:	83 c4 10             	add    $0x10,%esp

}
  803002:	90                   	nop
  803003:	c9                   	leave  
  803004:	c3                   	ret    

00803005 <initialize_MemBlocksList>:

//===============================
// [1] INITIALIZE AVAILABLE LIST:
//===============================
void initialize_MemBlocksList(uint32 numOfBlocks)
{
  803005:	55                   	push   %ebp
  803006:	89 e5                	mov    %esp,%ebp
  803008:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] initialize_MemBlocksList
	// Write your code here, remove the panic and write your code
	//panic("initialize_MemBlocksList() is not implemented yet...!!");
	uint32 n = numOfBlocks;
  80300b:	8b 45 08             	mov    0x8(%ebp),%eax
  80300e:	89 45 f0             	mov    %eax,-0x10(%ebp)

	LIST_INIT(&AvailableMemBlocksList);
  803011:	c7 05 48 51 80 00 00 	movl   $0x0,0x805148
  803018:	00 00 00 
  80301b:	c7 05 4c 51 80 00 00 	movl   $0x0,0x80514c
  803022:	00 00 00 
  803025:	c7 05 54 51 80 00 00 	movl   $0x0,0x805154
  80302c:	00 00 00 
	for(int i = 0; i<n;i++)
  80302f:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  803036:	e9 9e 00 00 00       	jmp    8030d9 <initialize_MemBlocksList+0xd4>
	{
		LIST_INSERT_HEAD(&AvailableMemBlocksList, &(MemBlockNodes[i]));
  80303b:	a1 50 50 80 00       	mov    0x805050,%eax
  803040:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803043:	c1 e2 04             	shl    $0x4,%edx
  803046:	01 d0                	add    %edx,%eax
  803048:	85 c0                	test   %eax,%eax
  80304a:	75 14                	jne    803060 <initialize_MemBlocksList+0x5b>
  80304c:	83 ec 04             	sub    $0x4,%esp
  80304f:	68 54 4b 80 00       	push   $0x804b54
  803054:	6a 47                	push   $0x47
  803056:	68 77 4b 80 00       	push   $0x804b77
  80305b:	e8 4a e2 ff ff       	call   8012aa <_panic>
  803060:	a1 50 50 80 00       	mov    0x805050,%eax
  803065:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803068:	c1 e2 04             	shl    $0x4,%edx
  80306b:	01 d0                	add    %edx,%eax
  80306d:	8b 15 48 51 80 00    	mov    0x805148,%edx
  803073:	89 10                	mov    %edx,(%eax)
  803075:	8b 00                	mov    (%eax),%eax
  803077:	85 c0                	test   %eax,%eax
  803079:	74 18                	je     803093 <initialize_MemBlocksList+0x8e>
  80307b:	a1 48 51 80 00       	mov    0x805148,%eax
  803080:	8b 15 50 50 80 00    	mov    0x805050,%edx
  803086:	8b 4d f4             	mov    -0xc(%ebp),%ecx
  803089:	c1 e1 04             	shl    $0x4,%ecx
  80308c:	01 ca                	add    %ecx,%edx
  80308e:	89 50 04             	mov    %edx,0x4(%eax)
  803091:	eb 12                	jmp    8030a5 <initialize_MemBlocksList+0xa0>
  803093:	a1 50 50 80 00       	mov    0x805050,%eax
  803098:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80309b:	c1 e2 04             	shl    $0x4,%edx
  80309e:	01 d0                	add    %edx,%eax
  8030a0:	a3 4c 51 80 00       	mov    %eax,0x80514c
  8030a5:	a1 50 50 80 00       	mov    0x805050,%eax
  8030aa:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8030ad:	c1 e2 04             	shl    $0x4,%edx
  8030b0:	01 d0                	add    %edx,%eax
  8030b2:	a3 48 51 80 00       	mov    %eax,0x805148
  8030b7:	a1 50 50 80 00       	mov    0x805050,%eax
  8030bc:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8030bf:	c1 e2 04             	shl    $0x4,%edx
  8030c2:	01 d0                	add    %edx,%eax
  8030c4:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8030cb:	a1 54 51 80 00       	mov    0x805154,%eax
  8030d0:	40                   	inc    %eax
  8030d1:	a3 54 51 80 00       	mov    %eax,0x805154
	// Write your code here, remove the panic and write your code
	//panic("initialize_MemBlocksList() is not implemented yet...!!");
	uint32 n = numOfBlocks;

	LIST_INIT(&AvailableMemBlocksList);
	for(int i = 0; i<n;i++)
  8030d6:	ff 45 f4             	incl   -0xc(%ebp)
  8030d9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030dc:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8030df:	0f 82 56 ff ff ff    	jb     80303b <initialize_MemBlocksList+0x36>
	{
		LIST_INSERT_HEAD(&AvailableMemBlocksList, &(MemBlockNodes[i]));
	}
}
  8030e5:	90                   	nop
  8030e6:	c9                   	leave  
  8030e7:	c3                   	ret    

008030e8 <find_block>:

//===============================
// [2] FIND BLOCK:
//===============================
struct MemBlock *find_block(struct MemBlock_List *blockList, uint32 va)
{
  8030e8:	55                   	push   %ebp
  8030e9:	89 e5                	mov    %esp,%ebp
  8030eb:	83 ec 10             	sub    $0x10,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] find_block
	// Write your code here, remove the panic and write your code
	//panic("find_block() is not implemented yet...!!");
	uint32 virAddress = va;
  8030ee:	8b 45 0c             	mov    0xc(%ebp),%eax
  8030f1:	89 45 f4             	mov    %eax,-0xc(%ebp)
	struct MemBlock* blk;
	int found = 0;
  8030f4:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	LIST_FOREACH(blk, &(AllocMemBlocksList))
  8030fb:	a1 40 50 80 00       	mov    0x805040,%eax
  803100:	89 45 fc             	mov    %eax,-0x4(%ebp)
  803103:	eb 23                	jmp    803128 <find_block+0x40>
	{
		if(blk->sva == virAddress)
  803105:	8b 45 fc             	mov    -0x4(%ebp),%eax
  803108:	8b 40 08             	mov    0x8(%eax),%eax
  80310b:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  80310e:	75 09                	jne    803119 <find_block+0x31>
		{
			found = 1;
  803110:	c7 45 f8 01 00 00 00 	movl   $0x1,-0x8(%ebp)
			break;
  803117:	eb 35                	jmp    80314e <find_block+0x66>
		}
		else
		{
			found = 0;
  803119:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	//panic("find_block() is not implemented yet...!!");
	uint32 virAddress = va;
	struct MemBlock* blk;
	int found = 0;

	LIST_FOREACH(blk, &(AllocMemBlocksList))
  803120:	a1 48 50 80 00       	mov    0x805048,%eax
  803125:	89 45 fc             	mov    %eax,-0x4(%ebp)
  803128:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  80312c:	74 07                	je     803135 <find_block+0x4d>
  80312e:	8b 45 fc             	mov    -0x4(%ebp),%eax
  803131:	8b 00                	mov    (%eax),%eax
  803133:	eb 05                	jmp    80313a <find_block+0x52>
  803135:	b8 00 00 00 00       	mov    $0x0,%eax
  80313a:	a3 48 50 80 00       	mov    %eax,0x805048
  80313f:	a1 48 50 80 00       	mov    0x805048,%eax
  803144:	85 c0                	test   %eax,%eax
  803146:	75 bd                	jne    803105 <find_block+0x1d>
  803148:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  80314c:	75 b7                	jne    803105 <find_block+0x1d>
		{
			found = 0;
			continue;
		}
	}
	if(found == 1)
  80314e:	83 7d f8 01          	cmpl   $0x1,-0x8(%ebp)
  803152:	75 05                	jne    803159 <find_block+0x71>
	{
		return blk;
  803154:	8b 45 fc             	mov    -0x4(%ebp),%eax
  803157:	eb 05                	jmp    80315e <find_block+0x76>
	}
	else
	{
		return NULL;
  803159:	b8 00 00 00 00       	mov    $0x0,%eax
	}
}
  80315e:	c9                   	leave  
  80315f:	c3                   	ret    

00803160 <insert_sorted_allocList>:

//=========================================
// [3] INSERT BLOCK IN ALLOC LIST [SORTED]:
//=========================================
void insert_sorted_allocList(struct MemBlock *blockToInsert)
{
  803160:	55                   	push   %ebp
  803161:	89 e5                	mov    %esp,%ebp
  803163:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] insert_sorted_allocList
	// Write your code here, remove the panic and write your code
	//panic("insert_sorted_allocList() is not implemented yet...!!");
	struct MemBlock* blk;
	struct MemBlock* newblk = blockToInsert;
  803166:	8b 45 08             	mov    0x8(%ebp),%eax
  803169:	89 45 f0             	mov    %eax,-0x10(%ebp)

	if((LIST_EMPTY(&AllocMemBlocksList)) || (newblk->sva < LIST_FIRST(&AllocMemBlocksList)->sva))
  80316c:	a1 40 50 80 00       	mov    0x805040,%eax
  803171:	85 c0                	test   %eax,%eax
  803173:	74 12                	je     803187 <insert_sorted_allocList+0x27>
  803175:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803178:	8b 50 08             	mov    0x8(%eax),%edx
  80317b:	a1 40 50 80 00       	mov    0x805040,%eax
  803180:	8b 40 08             	mov    0x8(%eax),%eax
  803183:	39 c2                	cmp    %eax,%edx
  803185:	73 65                	jae    8031ec <insert_sorted_allocList+0x8c>
	{
		LIST_INSERT_HEAD(&(AllocMemBlocksList), newblk);
  803187:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80318b:	75 14                	jne    8031a1 <insert_sorted_allocList+0x41>
  80318d:	83 ec 04             	sub    $0x4,%esp
  803190:	68 54 4b 80 00       	push   $0x804b54
  803195:	6a 7b                	push   $0x7b
  803197:	68 77 4b 80 00       	push   $0x804b77
  80319c:	e8 09 e1 ff ff       	call   8012aa <_panic>
  8031a1:	8b 15 40 50 80 00    	mov    0x805040,%edx
  8031a7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8031aa:	89 10                	mov    %edx,(%eax)
  8031ac:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8031af:	8b 00                	mov    (%eax),%eax
  8031b1:	85 c0                	test   %eax,%eax
  8031b3:	74 0d                	je     8031c2 <insert_sorted_allocList+0x62>
  8031b5:	a1 40 50 80 00       	mov    0x805040,%eax
  8031ba:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8031bd:	89 50 04             	mov    %edx,0x4(%eax)
  8031c0:	eb 08                	jmp    8031ca <insert_sorted_allocList+0x6a>
  8031c2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8031c5:	a3 44 50 80 00       	mov    %eax,0x805044
  8031ca:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8031cd:	a3 40 50 80 00       	mov    %eax,0x805040
  8031d2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8031d5:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8031dc:	a1 4c 50 80 00       	mov    0x80504c,%eax
  8031e1:	40                   	inc    %eax
  8031e2:	a3 4c 50 80 00       	mov    %eax,0x80504c
  8031e7:	e9 5f 01 00 00       	jmp    80334b <insert_sorted_allocList+0x1eb>
	}
	else if(newblk->sva > LIST_LAST(&AllocMemBlocksList)->sva)
  8031ec:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8031ef:	8b 50 08             	mov    0x8(%eax),%edx
  8031f2:	a1 44 50 80 00       	mov    0x805044,%eax
  8031f7:	8b 40 08             	mov    0x8(%eax),%eax
  8031fa:	39 c2                	cmp    %eax,%edx
  8031fc:	76 65                	jbe    803263 <insert_sorted_allocList+0x103>
	{
		LIST_INSERT_TAIL(&AllocMemBlocksList, newblk);
  8031fe:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  803202:	75 14                	jne    803218 <insert_sorted_allocList+0xb8>
  803204:	83 ec 04             	sub    $0x4,%esp
  803207:	68 90 4b 80 00       	push   $0x804b90
  80320c:	6a 7f                	push   $0x7f
  80320e:	68 77 4b 80 00       	push   $0x804b77
  803213:	e8 92 e0 ff ff       	call   8012aa <_panic>
  803218:	8b 15 44 50 80 00    	mov    0x805044,%edx
  80321e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803221:	89 50 04             	mov    %edx,0x4(%eax)
  803224:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803227:	8b 40 04             	mov    0x4(%eax),%eax
  80322a:	85 c0                	test   %eax,%eax
  80322c:	74 0c                	je     80323a <insert_sorted_allocList+0xda>
  80322e:	a1 44 50 80 00       	mov    0x805044,%eax
  803233:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803236:	89 10                	mov    %edx,(%eax)
  803238:	eb 08                	jmp    803242 <insert_sorted_allocList+0xe2>
  80323a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80323d:	a3 40 50 80 00       	mov    %eax,0x805040
  803242:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803245:	a3 44 50 80 00       	mov    %eax,0x805044
  80324a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80324d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803253:	a1 4c 50 80 00       	mov    0x80504c,%eax
  803258:	40                   	inc    %eax
  803259:	a3 4c 50 80 00       	mov    %eax,0x80504c
				LIST_INSERT_AFTER(&AllocMemBlocksList, blk, newblk);
				break;
			}
		}
	}
}
  80325e:	e9 e8 00 00 00       	jmp    80334b <insert_sorted_allocList+0x1eb>
	{
		LIST_INSERT_TAIL(&AllocMemBlocksList, newblk);
	}
	else
	{
		LIST_FOREACH(blk, &AllocMemBlocksList)
  803263:	a1 40 50 80 00       	mov    0x805040,%eax
  803268:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80326b:	e9 ab 00 00 00       	jmp    80331b <insert_sorted_allocList+0x1bb>
		{
			if(blk->prev_next_info.le_next != NULL && newblk->sva > blk->sva  && newblk->sva < blk->prev_next_info.le_next->sva)
  803270:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803273:	8b 00                	mov    (%eax),%eax
  803275:	85 c0                	test   %eax,%eax
  803277:	0f 84 96 00 00 00    	je     803313 <insert_sorted_allocList+0x1b3>
  80327d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803280:	8b 50 08             	mov    0x8(%eax),%edx
  803283:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803286:	8b 40 08             	mov    0x8(%eax),%eax
  803289:	39 c2                	cmp    %eax,%edx
  80328b:	0f 86 82 00 00 00    	jbe    803313 <insert_sorted_allocList+0x1b3>
  803291:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803294:	8b 50 08             	mov    0x8(%eax),%edx
  803297:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80329a:	8b 00                	mov    (%eax),%eax
  80329c:	8b 40 08             	mov    0x8(%eax),%eax
  80329f:	39 c2                	cmp    %eax,%edx
  8032a1:	73 70                	jae    803313 <insert_sorted_allocList+0x1b3>
			{
				LIST_INSERT_AFTER(&AllocMemBlocksList, blk, newblk);
  8032a3:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8032a7:	74 06                	je     8032af <insert_sorted_allocList+0x14f>
  8032a9:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8032ad:	75 17                	jne    8032c6 <insert_sorted_allocList+0x166>
  8032af:	83 ec 04             	sub    $0x4,%esp
  8032b2:	68 b4 4b 80 00       	push   $0x804bb4
  8032b7:	68 87 00 00 00       	push   $0x87
  8032bc:	68 77 4b 80 00       	push   $0x804b77
  8032c1:	e8 e4 df ff ff       	call   8012aa <_panic>
  8032c6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8032c9:	8b 10                	mov    (%eax),%edx
  8032cb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8032ce:	89 10                	mov    %edx,(%eax)
  8032d0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8032d3:	8b 00                	mov    (%eax),%eax
  8032d5:	85 c0                	test   %eax,%eax
  8032d7:	74 0b                	je     8032e4 <insert_sorted_allocList+0x184>
  8032d9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8032dc:	8b 00                	mov    (%eax),%eax
  8032de:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8032e1:	89 50 04             	mov    %edx,0x4(%eax)
  8032e4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8032e7:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8032ea:	89 10                	mov    %edx,(%eax)
  8032ec:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8032ef:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8032f2:	89 50 04             	mov    %edx,0x4(%eax)
  8032f5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8032f8:	8b 00                	mov    (%eax),%eax
  8032fa:	85 c0                	test   %eax,%eax
  8032fc:	75 08                	jne    803306 <insert_sorted_allocList+0x1a6>
  8032fe:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803301:	a3 44 50 80 00       	mov    %eax,0x805044
  803306:	a1 4c 50 80 00       	mov    0x80504c,%eax
  80330b:	40                   	inc    %eax
  80330c:	a3 4c 50 80 00       	mov    %eax,0x80504c
				break;
  803311:	eb 38                	jmp    80334b <insert_sorted_allocList+0x1eb>
	{
		LIST_INSERT_TAIL(&AllocMemBlocksList, newblk);
	}
	else
	{
		LIST_FOREACH(blk, &AllocMemBlocksList)
  803313:	a1 48 50 80 00       	mov    0x805048,%eax
  803318:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80331b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80331f:	74 07                	je     803328 <insert_sorted_allocList+0x1c8>
  803321:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803324:	8b 00                	mov    (%eax),%eax
  803326:	eb 05                	jmp    80332d <insert_sorted_allocList+0x1cd>
  803328:	b8 00 00 00 00       	mov    $0x0,%eax
  80332d:	a3 48 50 80 00       	mov    %eax,0x805048
  803332:	a1 48 50 80 00       	mov    0x805048,%eax
  803337:	85 c0                	test   %eax,%eax
  803339:	0f 85 31 ff ff ff    	jne    803270 <insert_sorted_allocList+0x110>
  80333f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803343:	0f 85 27 ff ff ff    	jne    803270 <insert_sorted_allocList+0x110>
				LIST_INSERT_AFTER(&AllocMemBlocksList, blk, newblk);
				break;
			}
		}
	}
}
  803349:	eb 00                	jmp    80334b <insert_sorted_allocList+0x1eb>
  80334b:	90                   	nop
  80334c:	c9                   	leave  
  80334d:	c3                   	ret    

0080334e <alloc_block_FF>:

//=========================================
// [4] ALLOCATE BLOCK BY FIRST FIT:
//=========================================
struct MemBlock *alloc_block_FF(uint32 size)
{
  80334e:	55                   	push   %ebp
  80334f:	89 e5                	mov    %esp,%ebp
  803351:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_FF
	// Write your code here, remove the panic and write your code
	//panic("alloc_block_FF() is not implemented yet...!!");
	uint32 versize = size;
  803354:	8b 45 08             	mov    0x8(%ebp),%eax
  803357:	89 45 f0             	mov    %eax,-0x10(%ebp)
	struct MemBlock* blk;
	struct MemBlock* newblk = LIST_FIRST(&AvailableMemBlocksList);
  80335a:	a1 48 51 80 00       	mov    0x805148,%eax
  80335f:	89 45 ec             	mov    %eax,-0x14(%ebp)

	LIST_FOREACH(blk,&FreeMemBlocksList)
  803362:	a1 38 51 80 00       	mov    0x805138,%eax
  803367:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80336a:	e9 77 01 00 00       	jmp    8034e6 <alloc_block_FF+0x198>
	{
		if(blk->size == versize)
  80336f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803372:	8b 40 0c             	mov    0xc(%eax),%eax
  803375:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  803378:	0f 85 8a 00 00 00    	jne    803408 <alloc_block_FF+0xba>
		{
			LIST_REMOVE(&FreeMemBlocksList,blk);
  80337e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803382:	75 17                	jne    80339b <alloc_block_FF+0x4d>
  803384:	83 ec 04             	sub    $0x4,%esp
  803387:	68 e8 4b 80 00       	push   $0x804be8
  80338c:	68 9e 00 00 00       	push   $0x9e
  803391:	68 77 4b 80 00       	push   $0x804b77
  803396:	e8 0f df ff ff       	call   8012aa <_panic>
  80339b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80339e:	8b 00                	mov    (%eax),%eax
  8033a0:	85 c0                	test   %eax,%eax
  8033a2:	74 10                	je     8033b4 <alloc_block_FF+0x66>
  8033a4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8033a7:	8b 00                	mov    (%eax),%eax
  8033a9:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8033ac:	8b 52 04             	mov    0x4(%edx),%edx
  8033af:	89 50 04             	mov    %edx,0x4(%eax)
  8033b2:	eb 0b                	jmp    8033bf <alloc_block_FF+0x71>
  8033b4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8033b7:	8b 40 04             	mov    0x4(%eax),%eax
  8033ba:	a3 3c 51 80 00       	mov    %eax,0x80513c
  8033bf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8033c2:	8b 40 04             	mov    0x4(%eax),%eax
  8033c5:	85 c0                	test   %eax,%eax
  8033c7:	74 0f                	je     8033d8 <alloc_block_FF+0x8a>
  8033c9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8033cc:	8b 40 04             	mov    0x4(%eax),%eax
  8033cf:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8033d2:	8b 12                	mov    (%edx),%edx
  8033d4:	89 10                	mov    %edx,(%eax)
  8033d6:	eb 0a                	jmp    8033e2 <alloc_block_FF+0x94>
  8033d8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8033db:	8b 00                	mov    (%eax),%eax
  8033dd:	a3 38 51 80 00       	mov    %eax,0x805138
  8033e2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8033e5:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8033eb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8033ee:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8033f5:	a1 44 51 80 00       	mov    0x805144,%eax
  8033fa:	48                   	dec    %eax
  8033fb:	a3 44 51 80 00       	mov    %eax,0x805144
			return blk;
  803400:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803403:	e9 11 01 00 00       	jmp    803519 <alloc_block_FF+0x1cb>
		}
		else if(blk->size > versize)
  803408:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80340b:	8b 40 0c             	mov    0xc(%eax),%eax
  80340e:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  803411:	0f 86 c7 00 00 00    	jbe    8034de <alloc_block_FF+0x190>
		{
			LIST_REMOVE(&AvailableMemBlocksList,newblk);
  803417:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  80341b:	75 17                	jne    803434 <alloc_block_FF+0xe6>
  80341d:	83 ec 04             	sub    $0x4,%esp
  803420:	68 e8 4b 80 00       	push   $0x804be8
  803425:	68 a3 00 00 00       	push   $0xa3
  80342a:	68 77 4b 80 00       	push   $0x804b77
  80342f:	e8 76 de ff ff       	call   8012aa <_panic>
  803434:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803437:	8b 00                	mov    (%eax),%eax
  803439:	85 c0                	test   %eax,%eax
  80343b:	74 10                	je     80344d <alloc_block_FF+0xff>
  80343d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803440:	8b 00                	mov    (%eax),%eax
  803442:	8b 55 ec             	mov    -0x14(%ebp),%edx
  803445:	8b 52 04             	mov    0x4(%edx),%edx
  803448:	89 50 04             	mov    %edx,0x4(%eax)
  80344b:	eb 0b                	jmp    803458 <alloc_block_FF+0x10a>
  80344d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803450:	8b 40 04             	mov    0x4(%eax),%eax
  803453:	a3 4c 51 80 00       	mov    %eax,0x80514c
  803458:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80345b:	8b 40 04             	mov    0x4(%eax),%eax
  80345e:	85 c0                	test   %eax,%eax
  803460:	74 0f                	je     803471 <alloc_block_FF+0x123>
  803462:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803465:	8b 40 04             	mov    0x4(%eax),%eax
  803468:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80346b:	8b 12                	mov    (%edx),%edx
  80346d:	89 10                	mov    %edx,(%eax)
  80346f:	eb 0a                	jmp    80347b <alloc_block_FF+0x12d>
  803471:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803474:	8b 00                	mov    (%eax),%eax
  803476:	a3 48 51 80 00       	mov    %eax,0x805148
  80347b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80347e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803484:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803487:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80348e:	a1 54 51 80 00       	mov    0x805154,%eax
  803493:	48                   	dec    %eax
  803494:	a3 54 51 80 00       	mov    %eax,0x805154
			newblk->size = versize;
  803499:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80349c:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80349f:	89 50 0c             	mov    %edx,0xc(%eax)
			blk->size = blk->size-versize;
  8034a2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8034a5:	8b 40 0c             	mov    0xc(%eax),%eax
  8034a8:	2b 45 f0             	sub    -0x10(%ebp),%eax
  8034ab:	89 c2                	mov    %eax,%edx
  8034ad:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8034b0:	89 50 0c             	mov    %edx,0xc(%eax)
			uint32 newveradd = blk->sva;
  8034b3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8034b6:	8b 40 08             	mov    0x8(%eax),%eax
  8034b9:	89 45 e8             	mov    %eax,-0x18(%ebp)
			blk->sva+=newblk->size;
  8034bc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8034bf:	8b 50 08             	mov    0x8(%eax),%edx
  8034c2:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8034c5:	8b 40 0c             	mov    0xc(%eax),%eax
  8034c8:	01 c2                	add    %eax,%edx
  8034ca:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8034cd:	89 50 08             	mov    %edx,0x8(%eax)
			newblk->sva = newveradd;
  8034d0:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8034d3:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8034d6:	89 50 08             	mov    %edx,0x8(%eax)
			return newblk;
  8034d9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8034dc:	eb 3b                	jmp    803519 <alloc_block_FF+0x1cb>
	//panic("alloc_block_FF() is not implemented yet...!!");
	uint32 versize = size;
	struct MemBlock* blk;
	struct MemBlock* newblk = LIST_FIRST(&AvailableMemBlocksList);

	LIST_FOREACH(blk,&FreeMemBlocksList)
  8034de:	a1 40 51 80 00       	mov    0x805140,%eax
  8034e3:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8034e6:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8034ea:	74 07                	je     8034f3 <alloc_block_FF+0x1a5>
  8034ec:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8034ef:	8b 00                	mov    (%eax),%eax
  8034f1:	eb 05                	jmp    8034f8 <alloc_block_FF+0x1aa>
  8034f3:	b8 00 00 00 00       	mov    $0x0,%eax
  8034f8:	a3 40 51 80 00       	mov    %eax,0x805140
  8034fd:	a1 40 51 80 00       	mov    0x805140,%eax
  803502:	85 c0                	test   %eax,%eax
  803504:	0f 85 65 fe ff ff    	jne    80336f <alloc_block_FF+0x21>
  80350a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80350e:	0f 85 5b fe ff ff    	jne    80336f <alloc_block_FF+0x21>
			blk->sva+=newblk->size;
			newblk->sva = newveradd;
			return newblk;
		}
	}
	return NULL;
  803514:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803519:	c9                   	leave  
  80351a:	c3                   	ret    

0080351b <alloc_block_BF>:

//=========================================
// [5] ALLOCATE BLOCK BY BEST FIT:
//=========================================
struct MemBlock *alloc_block_BF(uint32 size)
{
  80351b:	55                   	push   %ebp
  80351c:	89 e5                	mov    %esp,%ebp
  80351e:	83 ec 28             	sub    $0x28,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_BF
	// Write your code here, remove the panic and write your code
	//panic("alloc_block_BF() is not implemented yet...!!");
	uint32 versize=size;
  803521:	8b 45 08             	mov    0x8(%ebp),%eax
  803524:	89 45 e8             	mov    %eax,-0x18(%ebp)
	struct MemBlock* blk;
	struct MemBlock* newblk=LIST_FIRST(&AvailableMemBlocksList);
  803527:	a1 48 51 80 00       	mov    0x805148,%eax
  80352c:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	uint32 newveradd;
	uint32 newsize;
	int size_free = LIST_SIZE(&FreeMemBlocksList);
  80352f:	a1 44 51 80 00       	mov    0x805144,%eax
  803534:	89 45 e0             	mov    %eax,-0x20(%ebp)

	LIST_FOREACH(blk, &FreeMemBlocksList)
  803537:	a1 38 51 80 00       	mov    0x805138,%eax
  80353c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80353f:	e9 a1 00 00 00       	jmp    8035e5 <alloc_block_BF+0xca>
	{
		if(blk->size == versize)
  803544:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803547:	8b 40 0c             	mov    0xc(%eax),%eax
  80354a:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  80354d:	0f 85 8a 00 00 00    	jne    8035dd <alloc_block_BF+0xc2>
		{
			LIST_REMOVE(&FreeMemBlocksList, blk);
  803553:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803557:	75 17                	jne    803570 <alloc_block_BF+0x55>
  803559:	83 ec 04             	sub    $0x4,%esp
  80355c:	68 e8 4b 80 00       	push   $0x804be8
  803561:	68 c2 00 00 00       	push   $0xc2
  803566:	68 77 4b 80 00       	push   $0x804b77
  80356b:	e8 3a dd ff ff       	call   8012aa <_panic>
  803570:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803573:	8b 00                	mov    (%eax),%eax
  803575:	85 c0                	test   %eax,%eax
  803577:	74 10                	je     803589 <alloc_block_BF+0x6e>
  803579:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80357c:	8b 00                	mov    (%eax),%eax
  80357e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803581:	8b 52 04             	mov    0x4(%edx),%edx
  803584:	89 50 04             	mov    %edx,0x4(%eax)
  803587:	eb 0b                	jmp    803594 <alloc_block_BF+0x79>
  803589:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80358c:	8b 40 04             	mov    0x4(%eax),%eax
  80358f:	a3 3c 51 80 00       	mov    %eax,0x80513c
  803594:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803597:	8b 40 04             	mov    0x4(%eax),%eax
  80359a:	85 c0                	test   %eax,%eax
  80359c:	74 0f                	je     8035ad <alloc_block_BF+0x92>
  80359e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8035a1:	8b 40 04             	mov    0x4(%eax),%eax
  8035a4:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8035a7:	8b 12                	mov    (%edx),%edx
  8035a9:	89 10                	mov    %edx,(%eax)
  8035ab:	eb 0a                	jmp    8035b7 <alloc_block_BF+0x9c>
  8035ad:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8035b0:	8b 00                	mov    (%eax),%eax
  8035b2:	a3 38 51 80 00       	mov    %eax,0x805138
  8035b7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8035ba:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8035c0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8035c3:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8035ca:	a1 44 51 80 00       	mov    0x805144,%eax
  8035cf:	48                   	dec    %eax
  8035d0:	a3 44 51 80 00       	mov    %eax,0x805144
			return blk;
  8035d5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8035d8:	e9 11 02 00 00       	jmp    8037ee <alloc_block_BF+0x2d3>
	struct MemBlock* newblk=LIST_FIRST(&AvailableMemBlocksList);
	uint32 newveradd;
	uint32 newsize;
	int size_free = LIST_SIZE(&FreeMemBlocksList);

	LIST_FOREACH(blk, &FreeMemBlocksList)
  8035dd:	a1 40 51 80 00       	mov    0x805140,%eax
  8035e2:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8035e5:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8035e9:	74 07                	je     8035f2 <alloc_block_BF+0xd7>
  8035eb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8035ee:	8b 00                	mov    (%eax),%eax
  8035f0:	eb 05                	jmp    8035f7 <alloc_block_BF+0xdc>
  8035f2:	b8 00 00 00 00       	mov    $0x0,%eax
  8035f7:	a3 40 51 80 00       	mov    %eax,0x805140
  8035fc:	a1 40 51 80 00       	mov    0x805140,%eax
  803601:	85 c0                	test   %eax,%eax
  803603:	0f 85 3b ff ff ff    	jne    803544 <alloc_block_BF+0x29>
  803609:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80360d:	0f 85 31 ff ff ff    	jne    803544 <alloc_block_BF+0x29>
		{
			LIST_REMOVE(&FreeMemBlocksList, blk);
			return blk;
		}
	}
	LIST_FOREACH(blk, &FreeMemBlocksList)
  803613:	a1 38 51 80 00       	mov    0x805138,%eax
  803618:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80361b:	eb 27                	jmp    803644 <alloc_block_BF+0x129>
	{
		if(blk->size > versize)
  80361d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803620:	8b 40 0c             	mov    0xc(%eax),%eax
  803623:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  803626:	76 14                	jbe    80363c <alloc_block_BF+0x121>
		{
			newsize = blk->size;
  803628:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80362b:	8b 40 0c             	mov    0xc(%eax),%eax
  80362e:	89 45 ec             	mov    %eax,-0x14(%ebp)
			newveradd = blk->sva;
  803631:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803634:	8b 40 08             	mov    0x8(%eax),%eax
  803637:	89 45 f0             	mov    %eax,-0x10(%ebp)
			break;
  80363a:	eb 2e                	jmp    80366a <alloc_block_BF+0x14f>
		{
			LIST_REMOVE(&FreeMemBlocksList, blk);
			return blk;
		}
	}
	LIST_FOREACH(blk, &FreeMemBlocksList)
  80363c:	a1 40 51 80 00       	mov    0x805140,%eax
  803641:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803644:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803648:	74 07                	je     803651 <alloc_block_BF+0x136>
  80364a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80364d:	8b 00                	mov    (%eax),%eax
  80364f:	eb 05                	jmp    803656 <alloc_block_BF+0x13b>
  803651:	b8 00 00 00 00       	mov    $0x0,%eax
  803656:	a3 40 51 80 00       	mov    %eax,0x805140
  80365b:	a1 40 51 80 00       	mov    0x805140,%eax
  803660:	85 c0                	test   %eax,%eax
  803662:	75 b9                	jne    80361d <alloc_block_BF+0x102>
  803664:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803668:	75 b3                	jne    80361d <alloc_block_BF+0x102>
			newsize = blk->size;
			newveradd = blk->sva;
			break;
		}
	}
	LIST_FOREACH(blk, &FreeMemBlocksList)
  80366a:	a1 38 51 80 00       	mov    0x805138,%eax
  80366f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803672:	eb 30                	jmp    8036a4 <alloc_block_BF+0x189>
	{
		if(newsize > blk->size && blk->size > versize)
  803674:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803677:	8b 40 0c             	mov    0xc(%eax),%eax
  80367a:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  80367d:	73 1d                	jae    80369c <alloc_block_BF+0x181>
  80367f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803682:	8b 40 0c             	mov    0xc(%eax),%eax
  803685:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  803688:	76 12                	jbe    80369c <alloc_block_BF+0x181>
		{
	       newsize = blk->size;
  80368a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80368d:	8b 40 0c             	mov    0xc(%eax),%eax
  803690:	89 45 ec             	mov    %eax,-0x14(%ebp)
		   newveradd = blk->sva;
  803693:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803696:	8b 40 08             	mov    0x8(%eax),%eax
  803699:	89 45 f0             	mov    %eax,-0x10(%ebp)
			newsize = blk->size;
			newveradd = blk->sva;
			break;
		}
	}
	LIST_FOREACH(blk, &FreeMemBlocksList)
  80369c:	a1 40 51 80 00       	mov    0x805140,%eax
  8036a1:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8036a4:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8036a8:	74 07                	je     8036b1 <alloc_block_BF+0x196>
  8036aa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8036ad:	8b 00                	mov    (%eax),%eax
  8036af:	eb 05                	jmp    8036b6 <alloc_block_BF+0x19b>
  8036b1:	b8 00 00 00 00       	mov    $0x0,%eax
  8036b6:	a3 40 51 80 00       	mov    %eax,0x805140
  8036bb:	a1 40 51 80 00       	mov    0x805140,%eax
  8036c0:	85 c0                	test   %eax,%eax
  8036c2:	75 b0                	jne    803674 <alloc_block_BF+0x159>
  8036c4:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8036c8:	75 aa                	jne    803674 <alloc_block_BF+0x159>
		{
	       newsize = blk->size;
		   newveradd = blk->sva;
		}
	}
	LIST_FOREACH(blk, &FreeMemBlocksList)
  8036ca:	a1 38 51 80 00       	mov    0x805138,%eax
  8036cf:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8036d2:	e9 e4 00 00 00       	jmp    8037bb <alloc_block_BF+0x2a0>
	{
		if(blk->size == newsize && blk->sva == newveradd)
  8036d7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8036da:	8b 40 0c             	mov    0xc(%eax),%eax
  8036dd:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  8036e0:	0f 85 cd 00 00 00    	jne    8037b3 <alloc_block_BF+0x298>
  8036e6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8036e9:	8b 40 08             	mov    0x8(%eax),%eax
  8036ec:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8036ef:	0f 85 be 00 00 00    	jne    8037b3 <alloc_block_BF+0x298>
		{
			LIST_REMOVE(&AvailableMemBlocksList, newblk);
  8036f5:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8036f9:	75 17                	jne    803712 <alloc_block_BF+0x1f7>
  8036fb:	83 ec 04             	sub    $0x4,%esp
  8036fe:	68 e8 4b 80 00       	push   $0x804be8
  803703:	68 db 00 00 00       	push   $0xdb
  803708:	68 77 4b 80 00       	push   $0x804b77
  80370d:	e8 98 db ff ff       	call   8012aa <_panic>
  803712:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803715:	8b 00                	mov    (%eax),%eax
  803717:	85 c0                	test   %eax,%eax
  803719:	74 10                	je     80372b <alloc_block_BF+0x210>
  80371b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80371e:	8b 00                	mov    (%eax),%eax
  803720:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803723:	8b 52 04             	mov    0x4(%edx),%edx
  803726:	89 50 04             	mov    %edx,0x4(%eax)
  803729:	eb 0b                	jmp    803736 <alloc_block_BF+0x21b>
  80372b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80372e:	8b 40 04             	mov    0x4(%eax),%eax
  803731:	a3 4c 51 80 00       	mov    %eax,0x80514c
  803736:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803739:	8b 40 04             	mov    0x4(%eax),%eax
  80373c:	85 c0                	test   %eax,%eax
  80373e:	74 0f                	je     80374f <alloc_block_BF+0x234>
  803740:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803743:	8b 40 04             	mov    0x4(%eax),%eax
  803746:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803749:	8b 12                	mov    (%edx),%edx
  80374b:	89 10                	mov    %edx,(%eax)
  80374d:	eb 0a                	jmp    803759 <alloc_block_BF+0x23e>
  80374f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803752:	8b 00                	mov    (%eax),%eax
  803754:	a3 48 51 80 00       	mov    %eax,0x805148
  803759:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80375c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803762:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803765:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80376c:	a1 54 51 80 00       	mov    0x805154,%eax
  803771:	48                   	dec    %eax
  803772:	a3 54 51 80 00       	mov    %eax,0x805154
			newblk->size = versize;
  803777:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80377a:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80377d:	89 50 0c             	mov    %edx,0xc(%eax)
			newblk->sva = newveradd;
  803780:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803783:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803786:	89 50 08             	mov    %edx,0x8(%eax)
			blk->size = blk->size - versize;
  803789:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80378c:	8b 40 0c             	mov    0xc(%eax),%eax
  80378f:	2b 45 e8             	sub    -0x18(%ebp),%eax
  803792:	89 c2                	mov    %eax,%edx
  803794:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803797:	89 50 0c             	mov    %edx,0xc(%eax)
			blk->sva+= newblk->size;
  80379a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80379d:	8b 50 08             	mov    0x8(%eax),%edx
  8037a0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8037a3:	8b 40 0c             	mov    0xc(%eax),%eax
  8037a6:	01 c2                	add    %eax,%edx
  8037a8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8037ab:	89 50 08             	mov    %edx,0x8(%eax)
			return newblk;
  8037ae:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8037b1:	eb 3b                	jmp    8037ee <alloc_block_BF+0x2d3>
		{
	       newsize = blk->size;
		   newveradd = blk->sva;
		}
	}
	LIST_FOREACH(blk, &FreeMemBlocksList)
  8037b3:	a1 40 51 80 00       	mov    0x805140,%eax
  8037b8:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8037bb:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8037bf:	74 07                	je     8037c8 <alloc_block_BF+0x2ad>
  8037c1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8037c4:	8b 00                	mov    (%eax),%eax
  8037c6:	eb 05                	jmp    8037cd <alloc_block_BF+0x2b2>
  8037c8:	b8 00 00 00 00       	mov    $0x0,%eax
  8037cd:	a3 40 51 80 00       	mov    %eax,0x805140
  8037d2:	a1 40 51 80 00       	mov    0x805140,%eax
  8037d7:	85 c0                	test   %eax,%eax
  8037d9:	0f 85 f8 fe ff ff    	jne    8036d7 <alloc_block_BF+0x1bc>
  8037df:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8037e3:	0f 85 ee fe ff ff    	jne    8036d7 <alloc_block_BF+0x1bc>
			blk->size = blk->size - versize;
			blk->sva+= newblk->size;
			return newblk;
		}
	}
	return NULL;
  8037e9:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8037ee:	c9                   	leave  
  8037ef:	c3                   	ret    

008037f0 <alloc_block_NF>:
//=========================================
// [7] ALLOCATE BLOCK BY NEXT FIT:
//=========================================
struct MemBlock *last_allocate;
struct MemBlock *alloc_block_NF(uint32 size)
{
  8037f0:	55                   	push   %ebp
  8037f1:	89 e5                	mov    %esp,%ebp
  8037f3:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1 - BONUS] [DYNAMIC ALLOCATOR] alloc_block_NF
	// Write your code here, remove the panic and write your code
	//panic("alloc_block_NF() is not implemented yet...!!");
	uint32 versize = size;
  8037f6:	8b 45 08             	mov    0x8(%ebp),%eax
  8037f9:	89 45 f0             	mov    %eax,-0x10(%ebp)
	struct MemBlock* blk;
	struct MemBlock* newblk = LIST_FIRST(&AvailableMemBlocksList);
  8037fc:	a1 48 51 80 00       	mov    0x805148,%eax
  803801:	89 45 ec             	mov    %eax,-0x14(%ebp)

	LIST_FOREACH(blk,&FreeMemBlocksList)
  803804:	a1 38 51 80 00       	mov    0x805138,%eax
  803809:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80380c:	e9 77 01 00 00       	jmp    803988 <alloc_block_NF+0x198>
	{
		if(blk->size == versize)
  803811:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803814:	8b 40 0c             	mov    0xc(%eax),%eax
  803817:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80381a:	0f 85 8a 00 00 00    	jne    8038aa <alloc_block_NF+0xba>
		{
			LIST_REMOVE(&FreeMemBlocksList,blk);
  803820:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803824:	75 17                	jne    80383d <alloc_block_NF+0x4d>
  803826:	83 ec 04             	sub    $0x4,%esp
  803829:	68 e8 4b 80 00       	push   $0x804be8
  80382e:	68 f7 00 00 00       	push   $0xf7
  803833:	68 77 4b 80 00       	push   $0x804b77
  803838:	e8 6d da ff ff       	call   8012aa <_panic>
  80383d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803840:	8b 00                	mov    (%eax),%eax
  803842:	85 c0                	test   %eax,%eax
  803844:	74 10                	je     803856 <alloc_block_NF+0x66>
  803846:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803849:	8b 00                	mov    (%eax),%eax
  80384b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80384e:	8b 52 04             	mov    0x4(%edx),%edx
  803851:	89 50 04             	mov    %edx,0x4(%eax)
  803854:	eb 0b                	jmp    803861 <alloc_block_NF+0x71>
  803856:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803859:	8b 40 04             	mov    0x4(%eax),%eax
  80385c:	a3 3c 51 80 00       	mov    %eax,0x80513c
  803861:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803864:	8b 40 04             	mov    0x4(%eax),%eax
  803867:	85 c0                	test   %eax,%eax
  803869:	74 0f                	je     80387a <alloc_block_NF+0x8a>
  80386b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80386e:	8b 40 04             	mov    0x4(%eax),%eax
  803871:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803874:	8b 12                	mov    (%edx),%edx
  803876:	89 10                	mov    %edx,(%eax)
  803878:	eb 0a                	jmp    803884 <alloc_block_NF+0x94>
  80387a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80387d:	8b 00                	mov    (%eax),%eax
  80387f:	a3 38 51 80 00       	mov    %eax,0x805138
  803884:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803887:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80388d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803890:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803897:	a1 44 51 80 00       	mov    0x805144,%eax
  80389c:	48                   	dec    %eax
  80389d:	a3 44 51 80 00       	mov    %eax,0x805144
			return blk;
  8038a2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8038a5:	e9 11 01 00 00       	jmp    8039bb <alloc_block_NF+0x1cb>
		}
		else if(blk->size > versize)
  8038aa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8038ad:	8b 40 0c             	mov    0xc(%eax),%eax
  8038b0:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8038b3:	0f 86 c7 00 00 00    	jbe    803980 <alloc_block_NF+0x190>
		{
			LIST_REMOVE(&AvailableMemBlocksList,newblk);
  8038b9:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8038bd:	75 17                	jne    8038d6 <alloc_block_NF+0xe6>
  8038bf:	83 ec 04             	sub    $0x4,%esp
  8038c2:	68 e8 4b 80 00       	push   $0x804be8
  8038c7:	68 fc 00 00 00       	push   $0xfc
  8038cc:	68 77 4b 80 00       	push   $0x804b77
  8038d1:	e8 d4 d9 ff ff       	call   8012aa <_panic>
  8038d6:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8038d9:	8b 00                	mov    (%eax),%eax
  8038db:	85 c0                	test   %eax,%eax
  8038dd:	74 10                	je     8038ef <alloc_block_NF+0xff>
  8038df:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8038e2:	8b 00                	mov    (%eax),%eax
  8038e4:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8038e7:	8b 52 04             	mov    0x4(%edx),%edx
  8038ea:	89 50 04             	mov    %edx,0x4(%eax)
  8038ed:	eb 0b                	jmp    8038fa <alloc_block_NF+0x10a>
  8038ef:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8038f2:	8b 40 04             	mov    0x4(%eax),%eax
  8038f5:	a3 4c 51 80 00       	mov    %eax,0x80514c
  8038fa:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8038fd:	8b 40 04             	mov    0x4(%eax),%eax
  803900:	85 c0                	test   %eax,%eax
  803902:	74 0f                	je     803913 <alloc_block_NF+0x123>
  803904:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803907:	8b 40 04             	mov    0x4(%eax),%eax
  80390a:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80390d:	8b 12                	mov    (%edx),%edx
  80390f:	89 10                	mov    %edx,(%eax)
  803911:	eb 0a                	jmp    80391d <alloc_block_NF+0x12d>
  803913:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803916:	8b 00                	mov    (%eax),%eax
  803918:	a3 48 51 80 00       	mov    %eax,0x805148
  80391d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803920:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803926:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803929:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803930:	a1 54 51 80 00       	mov    0x805154,%eax
  803935:	48                   	dec    %eax
  803936:	a3 54 51 80 00       	mov    %eax,0x805154
			newblk->size = versize;
  80393b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80393e:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803941:	89 50 0c             	mov    %edx,0xc(%eax)
			blk->size = blk->size-versize;
  803944:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803947:	8b 40 0c             	mov    0xc(%eax),%eax
  80394a:	2b 45 f0             	sub    -0x10(%ebp),%eax
  80394d:	89 c2                	mov    %eax,%edx
  80394f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803952:	89 50 0c             	mov    %edx,0xc(%eax)
			uint32 newveradd = blk->sva;
  803955:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803958:	8b 40 08             	mov    0x8(%eax),%eax
  80395b:	89 45 e8             	mov    %eax,-0x18(%ebp)
			blk->sva+=newblk->size;
  80395e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803961:	8b 50 08             	mov    0x8(%eax),%edx
  803964:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803967:	8b 40 0c             	mov    0xc(%eax),%eax
  80396a:	01 c2                	add    %eax,%edx
  80396c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80396f:	89 50 08             	mov    %edx,0x8(%eax)
			newblk->sva = newveradd;
  803972:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803975:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803978:	89 50 08             	mov    %edx,0x8(%eax)
			return newblk;
  80397b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80397e:	eb 3b                	jmp    8039bb <alloc_block_NF+0x1cb>
	//panic("alloc_block_NF() is not implemented yet...!!");
	uint32 versize = size;
	struct MemBlock* blk;
	struct MemBlock* newblk = LIST_FIRST(&AvailableMemBlocksList);

	LIST_FOREACH(blk,&FreeMemBlocksList)
  803980:	a1 40 51 80 00       	mov    0x805140,%eax
  803985:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803988:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80398c:	74 07                	je     803995 <alloc_block_NF+0x1a5>
  80398e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803991:	8b 00                	mov    (%eax),%eax
  803993:	eb 05                	jmp    80399a <alloc_block_NF+0x1aa>
  803995:	b8 00 00 00 00       	mov    $0x0,%eax
  80399a:	a3 40 51 80 00       	mov    %eax,0x805140
  80399f:	a1 40 51 80 00       	mov    0x805140,%eax
  8039a4:	85 c0                	test   %eax,%eax
  8039a6:	0f 85 65 fe ff ff    	jne    803811 <alloc_block_NF+0x21>
  8039ac:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8039b0:	0f 85 5b fe ff ff    	jne    803811 <alloc_block_NF+0x21>
			blk->sva+=newblk->size;
			newblk->sva = newveradd;
			return newblk;
		}
	}
	return NULL;
  8039b6:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8039bb:	c9                   	leave  
  8039bc:	c3                   	ret    

008039bd <addToAvailMemBlocksList>:

//===================================================
// [8] INSERT BLOCK (SORTED WITH MERGE) IN FREE LIST:
//===================================================
void addToAvailMemBlocksList(struct MemBlock *blockToInsert)
{
  8039bd:	55                   	push   %ebp
  8039be:	89 e5                	mov    %esp,%ebp
  8039c0:	83 ec 08             	sub    $0x8,%esp
	blockToInsert->sva = 0;
  8039c3:	8b 45 08             	mov    0x8(%ebp),%eax
  8039c6:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
	blockToInsert->size = 0;
  8039cd:	8b 45 08             	mov    0x8(%ebp),%eax
  8039d0:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
	//add to avail
	LIST_INSERT_TAIL(&AvailableMemBlocksList, blockToInsert);
  8039d7:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8039db:	75 17                	jne    8039f4 <addToAvailMemBlocksList+0x37>
  8039dd:	83 ec 04             	sub    $0x4,%esp
  8039e0:	68 90 4b 80 00       	push   $0x804b90
  8039e5:	68 10 01 00 00       	push   $0x110
  8039ea:	68 77 4b 80 00       	push   $0x804b77
  8039ef:	e8 b6 d8 ff ff       	call   8012aa <_panic>
  8039f4:	8b 15 4c 51 80 00    	mov    0x80514c,%edx
  8039fa:	8b 45 08             	mov    0x8(%ebp),%eax
  8039fd:	89 50 04             	mov    %edx,0x4(%eax)
  803a00:	8b 45 08             	mov    0x8(%ebp),%eax
  803a03:	8b 40 04             	mov    0x4(%eax),%eax
  803a06:	85 c0                	test   %eax,%eax
  803a08:	74 0c                	je     803a16 <addToAvailMemBlocksList+0x59>
  803a0a:	a1 4c 51 80 00       	mov    0x80514c,%eax
  803a0f:	8b 55 08             	mov    0x8(%ebp),%edx
  803a12:	89 10                	mov    %edx,(%eax)
  803a14:	eb 08                	jmp    803a1e <addToAvailMemBlocksList+0x61>
  803a16:	8b 45 08             	mov    0x8(%ebp),%eax
  803a19:	a3 48 51 80 00       	mov    %eax,0x805148
  803a1e:	8b 45 08             	mov    0x8(%ebp),%eax
  803a21:	a3 4c 51 80 00       	mov    %eax,0x80514c
  803a26:	8b 45 08             	mov    0x8(%ebp),%eax
  803a29:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803a2f:	a1 54 51 80 00       	mov    0x805154,%eax
  803a34:	40                   	inc    %eax
  803a35:	a3 54 51 80 00       	mov    %eax,0x805154
}
  803a3a:	90                   	nop
  803a3b:	c9                   	leave  
  803a3c:	c3                   	ret    

00803a3d <insert_sorted_with_merge_freeList>:
void insert_sorted_with_merge_freeList(struct MemBlock *blockToInsert)
{
  803a3d:	55                   	push   %ebp
  803a3e:	89 e5                	mov    %esp,%ebp
  803a40:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] insert_sorted_with_merge_freeList
	// Write your code here, remove the panic and write your code

	struct MemBlock* last = LIST_LAST(&FreeMemBlocksList);
  803a43:	a1 3c 51 80 00       	mov    0x80513c,%eax
  803a48:	89 45 f0             	mov    %eax,-0x10(%ebp)
	//check if list empty
	if (LIST_SIZE(&(FreeMemBlocksList)) == 0)
  803a4b:	a1 44 51 80 00       	mov    0x805144,%eax
  803a50:	85 c0                	test   %eax,%eax
  803a52:	75 68                	jne    803abc <insert_sorted_with_merge_freeList+0x7f>
		LIST_INSERT_HEAD(&FreeMemBlocksList, blockToInsert);
  803a54:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803a58:	75 17                	jne    803a71 <insert_sorted_with_merge_freeList+0x34>
  803a5a:	83 ec 04             	sub    $0x4,%esp
  803a5d:	68 54 4b 80 00       	push   $0x804b54
  803a62:	68 1a 01 00 00       	push   $0x11a
  803a67:	68 77 4b 80 00       	push   $0x804b77
  803a6c:	e8 39 d8 ff ff       	call   8012aa <_panic>
  803a71:	8b 15 38 51 80 00    	mov    0x805138,%edx
  803a77:	8b 45 08             	mov    0x8(%ebp),%eax
  803a7a:	89 10                	mov    %edx,(%eax)
  803a7c:	8b 45 08             	mov    0x8(%ebp),%eax
  803a7f:	8b 00                	mov    (%eax),%eax
  803a81:	85 c0                	test   %eax,%eax
  803a83:	74 0d                	je     803a92 <insert_sorted_with_merge_freeList+0x55>
  803a85:	a1 38 51 80 00       	mov    0x805138,%eax
  803a8a:	8b 55 08             	mov    0x8(%ebp),%edx
  803a8d:	89 50 04             	mov    %edx,0x4(%eax)
  803a90:	eb 08                	jmp    803a9a <insert_sorted_with_merge_freeList+0x5d>
  803a92:	8b 45 08             	mov    0x8(%ebp),%eax
  803a95:	a3 3c 51 80 00       	mov    %eax,0x80513c
  803a9a:	8b 45 08             	mov    0x8(%ebp),%eax
  803a9d:	a3 38 51 80 00       	mov    %eax,0x805138
  803aa2:	8b 45 08             	mov    0x8(%ebp),%eax
  803aa5:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803aac:	a1 44 51 80 00       	mov    0x805144,%eax
  803ab1:	40                   	inc    %eax
  803ab2:	a3 44 51 80 00       	mov    %eax,0x805144
		}
	}

	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  803ab7:	e9 c5 03 00 00       	jmp    803e81 <insert_sorted_with_merge_freeList+0x444>
	struct MemBlock* last = LIST_LAST(&FreeMemBlocksList);
	//check if list empty
	if (LIST_SIZE(&(FreeMemBlocksList)) == 0)
		LIST_INSERT_HEAD(&FreeMemBlocksList, blockToInsert);
	//check if it's position is at last
	else if (last->sva < blockToInsert->sva) {
  803abc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803abf:	8b 50 08             	mov    0x8(%eax),%edx
  803ac2:	8b 45 08             	mov    0x8(%ebp),%eax
  803ac5:	8b 40 08             	mov    0x8(%eax),%eax
  803ac8:	39 c2                	cmp    %eax,%edx
  803aca:	0f 83 b2 00 00 00    	jae    803b82 <insert_sorted_with_merge_freeList+0x145>

		//if i have to merge
		if (last->sva + last->size == blockToInsert->sva) {
  803ad0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803ad3:	8b 50 08             	mov    0x8(%eax),%edx
  803ad6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803ad9:	8b 40 0c             	mov    0xc(%eax),%eax
  803adc:	01 c2                	add    %eax,%edx
  803ade:	8b 45 08             	mov    0x8(%ebp),%eax
  803ae1:	8b 40 08             	mov    0x8(%eax),%eax
  803ae4:	39 c2                	cmp    %eax,%edx
  803ae6:	75 27                	jne    803b0f <insert_sorted_with_merge_freeList+0xd2>
			last->size = last->size + blockToInsert->size;
  803ae8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803aeb:	8b 50 0c             	mov    0xc(%eax),%edx
  803aee:	8b 45 08             	mov    0x8(%ebp),%eax
  803af1:	8b 40 0c             	mov    0xc(%eax),%eax
  803af4:	01 c2                	add    %eax,%edx
  803af6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803af9:	89 50 0c             	mov    %edx,0xc(%eax)
			addToAvailMemBlocksList(blockToInsert);
  803afc:	83 ec 0c             	sub    $0xc,%esp
  803aff:	ff 75 08             	pushl  0x8(%ebp)
  803b02:	e8 b6 fe ff ff       	call   8039bd <addToAvailMemBlocksList>
  803b07:	83 c4 10             	add    $0x10,%esp
		}
	}

	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  803b0a:	e9 72 03 00 00       	jmp    803e81 <insert_sorted_with_merge_freeList+0x444>
		if (last->sva + last->size == blockToInsert->sva) {
			last->size = last->size + blockToInsert->size;
			addToAvailMemBlocksList(blockToInsert);

		} else {
			LIST_INSERT_AFTER(&FreeMemBlocksList, last, blockToInsert);
  803b0f:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  803b13:	74 06                	je     803b1b <insert_sorted_with_merge_freeList+0xde>
  803b15:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803b19:	75 17                	jne    803b32 <insert_sorted_with_merge_freeList+0xf5>
  803b1b:	83 ec 04             	sub    $0x4,%esp
  803b1e:	68 b4 4b 80 00       	push   $0x804bb4
  803b23:	68 24 01 00 00       	push   $0x124
  803b28:	68 77 4b 80 00       	push   $0x804b77
  803b2d:	e8 78 d7 ff ff       	call   8012aa <_panic>
  803b32:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803b35:	8b 10                	mov    (%eax),%edx
  803b37:	8b 45 08             	mov    0x8(%ebp),%eax
  803b3a:	89 10                	mov    %edx,(%eax)
  803b3c:	8b 45 08             	mov    0x8(%ebp),%eax
  803b3f:	8b 00                	mov    (%eax),%eax
  803b41:	85 c0                	test   %eax,%eax
  803b43:	74 0b                	je     803b50 <insert_sorted_with_merge_freeList+0x113>
  803b45:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803b48:	8b 00                	mov    (%eax),%eax
  803b4a:	8b 55 08             	mov    0x8(%ebp),%edx
  803b4d:	89 50 04             	mov    %edx,0x4(%eax)
  803b50:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803b53:	8b 55 08             	mov    0x8(%ebp),%edx
  803b56:	89 10                	mov    %edx,(%eax)
  803b58:	8b 45 08             	mov    0x8(%ebp),%eax
  803b5b:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803b5e:	89 50 04             	mov    %edx,0x4(%eax)
  803b61:	8b 45 08             	mov    0x8(%ebp),%eax
  803b64:	8b 00                	mov    (%eax),%eax
  803b66:	85 c0                	test   %eax,%eax
  803b68:	75 08                	jne    803b72 <insert_sorted_with_merge_freeList+0x135>
  803b6a:	8b 45 08             	mov    0x8(%ebp),%eax
  803b6d:	a3 3c 51 80 00       	mov    %eax,0x80513c
  803b72:	a1 44 51 80 00       	mov    0x805144,%eax
  803b77:	40                   	inc    %eax
  803b78:	a3 44 51 80 00       	mov    %eax,0x805144
		}
	}

	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  803b7d:	e9 ff 02 00 00       	jmp    803e81 <insert_sorted_with_merge_freeList+0x444>
		} else {
			LIST_INSERT_AFTER(&FreeMemBlocksList, last, blockToInsert);
		}
	} else {
		struct MemBlock *iterator;
		LIST_FOREACH(iterator, &(FreeMemBlocksList))
  803b82:	a1 38 51 80 00       	mov    0x805138,%eax
  803b87:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803b8a:	e9 c2 02 00 00       	jmp    803e51 <insert_sorted_with_merge_freeList+0x414>
		{

			if (iterator->sva > blockToInsert->sva) {
  803b8f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803b92:	8b 50 08             	mov    0x8(%eax),%edx
  803b95:	8b 45 08             	mov    0x8(%ebp),%eax
  803b98:	8b 40 08             	mov    0x8(%eax),%eax
  803b9b:	39 c2                	cmp    %eax,%edx
  803b9d:	0f 86 a6 02 00 00    	jbe    803e49 <insert_sorted_with_merge_freeList+0x40c>

				struct MemBlock* prev = LIST_PREV(iterator);
  803ba3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803ba6:	8b 40 04             	mov    0x4(%eax),%eax
  803ba9:	89 45 ec             	mov    %eax,-0x14(%ebp)
				if (prev == NULL) {
  803bac:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  803bb0:	0f 85 ba 00 00 00    	jne    803c70 <insert_sorted_with_merge_freeList+0x233>
					//check merge
					if (blockToInsert->size + blockToInsert->sva
  803bb6:	8b 45 08             	mov    0x8(%ebp),%eax
  803bb9:	8b 50 0c             	mov    0xc(%eax),%edx
  803bbc:	8b 45 08             	mov    0x8(%ebp),%eax
  803bbf:	8b 40 08             	mov    0x8(%eax),%eax
  803bc2:	01 c2                	add    %eax,%edx
							== iterator->sva) {
  803bc4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803bc7:	8b 40 08             	mov    0x8(%eax),%eax
			if (iterator->sva > blockToInsert->sva) {

				struct MemBlock* prev = LIST_PREV(iterator);
				if (prev == NULL) {
					//check merge
					if (blockToInsert->size + blockToInsert->sva
  803bca:	39 c2                	cmp    %eax,%edx
  803bcc:	75 33                	jne    803c01 <insert_sorted_with_merge_freeList+0x1c4>
							== iterator->sva) {
						iterator->sva = blockToInsert->sva;
  803bce:	8b 45 08             	mov    0x8(%ebp),%eax
  803bd1:	8b 50 08             	mov    0x8(%eax),%edx
  803bd4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803bd7:	89 50 08             	mov    %edx,0x8(%eax)
						iterator->size = iterator->size + blockToInsert->size;
  803bda:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803bdd:	8b 50 0c             	mov    0xc(%eax),%edx
  803be0:	8b 45 08             	mov    0x8(%ebp),%eax
  803be3:	8b 40 0c             	mov    0xc(%eax),%eax
  803be6:	01 c2                	add    %eax,%edx
  803be8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803beb:	89 50 0c             	mov    %edx,0xc(%eax)
						addToAvailMemBlocksList(blockToInsert);
  803bee:	83 ec 0c             	sub    $0xc,%esp
  803bf1:	ff 75 08             	pushl  0x8(%ebp)
  803bf4:	e8 c4 fd ff ff       	call   8039bd <addToAvailMemBlocksList>
  803bf9:	83 c4 10             	add    $0x10,%esp

					else {
						LIST_INSERT_BEFORE(&FreeMemBlocksList, iterator,
								blockToInsert);
					}
					break;
  803bfc:	e9 80 02 00 00       	jmp    803e81 <insert_sorted_with_merge_freeList+0x444>
						addToAvailMemBlocksList(blockToInsert);

					}

					else {
						LIST_INSERT_BEFORE(&FreeMemBlocksList, iterator,
  803c01:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803c05:	74 06                	je     803c0d <insert_sorted_with_merge_freeList+0x1d0>
  803c07:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803c0b:	75 17                	jne    803c24 <insert_sorted_with_merge_freeList+0x1e7>
  803c0d:	83 ec 04             	sub    $0x4,%esp
  803c10:	68 08 4c 80 00       	push   $0x804c08
  803c15:	68 3a 01 00 00       	push   $0x13a
  803c1a:	68 77 4b 80 00       	push   $0x804b77
  803c1f:	e8 86 d6 ff ff       	call   8012aa <_panic>
  803c24:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803c27:	8b 50 04             	mov    0x4(%eax),%edx
  803c2a:	8b 45 08             	mov    0x8(%ebp),%eax
  803c2d:	89 50 04             	mov    %edx,0x4(%eax)
  803c30:	8b 45 08             	mov    0x8(%ebp),%eax
  803c33:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803c36:	89 10                	mov    %edx,(%eax)
  803c38:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803c3b:	8b 40 04             	mov    0x4(%eax),%eax
  803c3e:	85 c0                	test   %eax,%eax
  803c40:	74 0d                	je     803c4f <insert_sorted_with_merge_freeList+0x212>
  803c42:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803c45:	8b 40 04             	mov    0x4(%eax),%eax
  803c48:	8b 55 08             	mov    0x8(%ebp),%edx
  803c4b:	89 10                	mov    %edx,(%eax)
  803c4d:	eb 08                	jmp    803c57 <insert_sorted_with_merge_freeList+0x21a>
  803c4f:	8b 45 08             	mov    0x8(%ebp),%eax
  803c52:	a3 38 51 80 00       	mov    %eax,0x805138
  803c57:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803c5a:	8b 55 08             	mov    0x8(%ebp),%edx
  803c5d:	89 50 04             	mov    %edx,0x4(%eax)
  803c60:	a1 44 51 80 00       	mov    0x805144,%eax
  803c65:	40                   	inc    %eax
  803c66:	a3 44 51 80 00       	mov    %eax,0x805144
								blockToInsert);
					}
					break;
  803c6b:	e9 11 02 00 00       	jmp    803e81 <insert_sorted_with_merge_freeList+0x444>
				} else {
					//prev and next merge
					if (prev->sva + prev->size + blockToInsert->size
  803c70:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803c73:	8b 50 08             	mov    0x8(%eax),%edx
  803c76:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803c79:	8b 40 0c             	mov    0xc(%eax),%eax
  803c7c:	01 c2                	add    %eax,%edx
  803c7e:	8b 45 08             	mov    0x8(%ebp),%eax
  803c81:	8b 40 0c             	mov    0xc(%eax),%eax
  803c84:	01 c2                	add    %eax,%edx
							== iterator->sva) {
  803c86:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803c89:	8b 40 08             	mov    0x8(%eax),%eax
								blockToInsert);
					}
					break;
				} else {
					//prev and next merge
					if (prev->sva + prev->size + blockToInsert->size
  803c8c:	39 c2                	cmp    %eax,%edx
  803c8e:	0f 85 bf 00 00 00    	jne    803d53 <insert_sorted_with_merge_freeList+0x316>
							== iterator->sva) {
						prev->size = prev->size + blockToInsert->size
  803c94:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803c97:	8b 50 0c             	mov    0xc(%eax),%edx
  803c9a:	8b 45 08             	mov    0x8(%ebp),%eax
  803c9d:	8b 40 0c             	mov    0xc(%eax),%eax
  803ca0:	01 c2                	add    %eax,%edx
								+ iterator->size;
  803ca2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803ca5:	8b 40 0c             	mov    0xc(%eax),%eax
  803ca8:	01 c2                	add    %eax,%edx
					break;
				} else {
					//prev and next merge
					if (prev->sva + prev->size + blockToInsert->size
							== iterator->sva) {
						prev->size = prev->size + blockToInsert->size
  803caa:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803cad:	89 50 0c             	mov    %edx,0xc(%eax)
								+ iterator->size;
						LIST_REMOVE(&FreeMemBlocksList, iterator);
  803cb0:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803cb4:	75 17                	jne    803ccd <insert_sorted_with_merge_freeList+0x290>
  803cb6:	83 ec 04             	sub    $0x4,%esp
  803cb9:	68 e8 4b 80 00       	push   $0x804be8
  803cbe:	68 43 01 00 00       	push   $0x143
  803cc3:	68 77 4b 80 00       	push   $0x804b77
  803cc8:	e8 dd d5 ff ff       	call   8012aa <_panic>
  803ccd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803cd0:	8b 00                	mov    (%eax),%eax
  803cd2:	85 c0                	test   %eax,%eax
  803cd4:	74 10                	je     803ce6 <insert_sorted_with_merge_freeList+0x2a9>
  803cd6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803cd9:	8b 00                	mov    (%eax),%eax
  803cdb:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803cde:	8b 52 04             	mov    0x4(%edx),%edx
  803ce1:	89 50 04             	mov    %edx,0x4(%eax)
  803ce4:	eb 0b                	jmp    803cf1 <insert_sorted_with_merge_freeList+0x2b4>
  803ce6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803ce9:	8b 40 04             	mov    0x4(%eax),%eax
  803cec:	a3 3c 51 80 00       	mov    %eax,0x80513c
  803cf1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803cf4:	8b 40 04             	mov    0x4(%eax),%eax
  803cf7:	85 c0                	test   %eax,%eax
  803cf9:	74 0f                	je     803d0a <insert_sorted_with_merge_freeList+0x2cd>
  803cfb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803cfe:	8b 40 04             	mov    0x4(%eax),%eax
  803d01:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803d04:	8b 12                	mov    (%edx),%edx
  803d06:	89 10                	mov    %edx,(%eax)
  803d08:	eb 0a                	jmp    803d14 <insert_sorted_with_merge_freeList+0x2d7>
  803d0a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803d0d:	8b 00                	mov    (%eax),%eax
  803d0f:	a3 38 51 80 00       	mov    %eax,0x805138
  803d14:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803d17:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803d1d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803d20:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803d27:	a1 44 51 80 00       	mov    0x805144,%eax
  803d2c:	48                   	dec    %eax
  803d2d:	a3 44 51 80 00       	mov    %eax,0x805144
						addToAvailMemBlocksList(blockToInsert);
  803d32:	83 ec 0c             	sub    $0xc,%esp
  803d35:	ff 75 08             	pushl  0x8(%ebp)
  803d38:	e8 80 fc ff ff       	call   8039bd <addToAvailMemBlocksList>
  803d3d:	83 c4 10             	add    $0x10,%esp
						addToAvailMemBlocksList(iterator);
  803d40:	83 ec 0c             	sub    $0xc,%esp
  803d43:	ff 75 f4             	pushl  -0xc(%ebp)
  803d46:	e8 72 fc ff ff       	call   8039bd <addToAvailMemBlocksList>
  803d4b:	83 c4 10             	add    $0x10,%esp
					//Insert
					else {
						LIST_INSERT_BEFORE(&FreeMemBlocksList, iterator,
								blockToInsert);
					}
					break;
  803d4e:	e9 2e 01 00 00       	jmp    803e81 <insert_sorted_with_merge_freeList+0x444>
						LIST_REMOVE(&FreeMemBlocksList, iterator);
						addToAvailMemBlocksList(blockToInsert);
						addToAvailMemBlocksList(iterator);
					}
					//previous merge
					else if (prev->sva + prev->size == blockToInsert->sva) {
  803d53:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803d56:	8b 50 08             	mov    0x8(%eax),%edx
  803d59:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803d5c:	8b 40 0c             	mov    0xc(%eax),%eax
  803d5f:	01 c2                	add    %eax,%edx
  803d61:	8b 45 08             	mov    0x8(%ebp),%eax
  803d64:	8b 40 08             	mov    0x8(%eax),%eax
  803d67:	39 c2                	cmp    %eax,%edx
  803d69:	75 27                	jne    803d92 <insert_sorted_with_merge_freeList+0x355>
						prev->size = prev->size + blockToInsert->size;
  803d6b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803d6e:	8b 50 0c             	mov    0xc(%eax),%edx
  803d71:	8b 45 08             	mov    0x8(%ebp),%eax
  803d74:	8b 40 0c             	mov    0xc(%eax),%eax
  803d77:	01 c2                	add    %eax,%edx
  803d79:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803d7c:	89 50 0c             	mov    %edx,0xc(%eax)
						addToAvailMemBlocksList(blockToInsert);
  803d7f:	83 ec 0c             	sub    $0xc,%esp
  803d82:	ff 75 08             	pushl  0x8(%ebp)
  803d85:	e8 33 fc ff ff       	call   8039bd <addToAvailMemBlocksList>
  803d8a:	83 c4 10             	add    $0x10,%esp
					//Insert
					else {
						LIST_INSERT_BEFORE(&FreeMemBlocksList, iterator,
								blockToInsert);
					}
					break;
  803d8d:	e9 ef 00 00 00       	jmp    803e81 <insert_sorted_with_merge_freeList+0x444>
					else if (prev->sva + prev->size == blockToInsert->sva) {
						prev->size = prev->size + blockToInsert->size;
						addToAvailMemBlocksList(blockToInsert);
					}
					//next merge
					else if (blockToInsert->size + blockToInsert->sva
  803d92:	8b 45 08             	mov    0x8(%ebp),%eax
  803d95:	8b 50 0c             	mov    0xc(%eax),%edx
  803d98:	8b 45 08             	mov    0x8(%ebp),%eax
  803d9b:	8b 40 08             	mov    0x8(%eax),%eax
  803d9e:	01 c2                	add    %eax,%edx
							== iterator->sva) {
  803da0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803da3:	8b 40 08             	mov    0x8(%eax),%eax
					else if (prev->sva + prev->size == blockToInsert->sva) {
						prev->size = prev->size + blockToInsert->size;
						addToAvailMemBlocksList(blockToInsert);
					}
					//next merge
					else if (blockToInsert->size + blockToInsert->sva
  803da6:	39 c2                	cmp    %eax,%edx
  803da8:	75 33                	jne    803ddd <insert_sorted_with_merge_freeList+0x3a0>
							== iterator->sva) {
						iterator->sva = blockToInsert->sva;
  803daa:	8b 45 08             	mov    0x8(%ebp),%eax
  803dad:	8b 50 08             	mov    0x8(%eax),%edx
  803db0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803db3:	89 50 08             	mov    %edx,0x8(%eax)
						iterator->size = iterator->size + blockToInsert->size;
  803db6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803db9:	8b 50 0c             	mov    0xc(%eax),%edx
  803dbc:	8b 45 08             	mov    0x8(%ebp),%eax
  803dbf:	8b 40 0c             	mov    0xc(%eax),%eax
  803dc2:	01 c2                	add    %eax,%edx
  803dc4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803dc7:	89 50 0c             	mov    %edx,0xc(%eax)
						addToAvailMemBlocksList(blockToInsert);
  803dca:	83 ec 0c             	sub    $0xc,%esp
  803dcd:	ff 75 08             	pushl  0x8(%ebp)
  803dd0:	e8 e8 fb ff ff       	call   8039bd <addToAvailMemBlocksList>
  803dd5:	83 c4 10             	add    $0x10,%esp
					//Insert
					else {
						LIST_INSERT_BEFORE(&FreeMemBlocksList, iterator,
								blockToInsert);
					}
					break;
  803dd8:	e9 a4 00 00 00       	jmp    803e81 <insert_sorted_with_merge_freeList+0x444>
						iterator->size = iterator->size + blockToInsert->size;
						addToAvailMemBlocksList(blockToInsert);
					}
					//Insert
					else {
						LIST_INSERT_BEFORE(&FreeMemBlocksList, iterator,
  803ddd:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803de1:	74 06                	je     803de9 <insert_sorted_with_merge_freeList+0x3ac>
  803de3:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803de7:	75 17                	jne    803e00 <insert_sorted_with_merge_freeList+0x3c3>
  803de9:	83 ec 04             	sub    $0x4,%esp
  803dec:	68 08 4c 80 00       	push   $0x804c08
  803df1:	68 56 01 00 00       	push   $0x156
  803df6:	68 77 4b 80 00       	push   $0x804b77
  803dfb:	e8 aa d4 ff ff       	call   8012aa <_panic>
  803e00:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803e03:	8b 50 04             	mov    0x4(%eax),%edx
  803e06:	8b 45 08             	mov    0x8(%ebp),%eax
  803e09:	89 50 04             	mov    %edx,0x4(%eax)
  803e0c:	8b 45 08             	mov    0x8(%ebp),%eax
  803e0f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803e12:	89 10                	mov    %edx,(%eax)
  803e14:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803e17:	8b 40 04             	mov    0x4(%eax),%eax
  803e1a:	85 c0                	test   %eax,%eax
  803e1c:	74 0d                	je     803e2b <insert_sorted_with_merge_freeList+0x3ee>
  803e1e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803e21:	8b 40 04             	mov    0x4(%eax),%eax
  803e24:	8b 55 08             	mov    0x8(%ebp),%edx
  803e27:	89 10                	mov    %edx,(%eax)
  803e29:	eb 08                	jmp    803e33 <insert_sorted_with_merge_freeList+0x3f6>
  803e2b:	8b 45 08             	mov    0x8(%ebp),%eax
  803e2e:	a3 38 51 80 00       	mov    %eax,0x805138
  803e33:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803e36:	8b 55 08             	mov    0x8(%ebp),%edx
  803e39:	89 50 04             	mov    %edx,0x4(%eax)
  803e3c:	a1 44 51 80 00       	mov    0x805144,%eax
  803e41:	40                   	inc    %eax
  803e42:	a3 44 51 80 00       	mov    %eax,0x805144
								blockToInsert);
					}
					break;
  803e47:	eb 38                	jmp    803e81 <insert_sorted_with_merge_freeList+0x444>
		} else {
			LIST_INSERT_AFTER(&FreeMemBlocksList, last, blockToInsert);
		}
	} else {
		struct MemBlock *iterator;
		LIST_FOREACH(iterator, &(FreeMemBlocksList))
  803e49:	a1 40 51 80 00       	mov    0x805140,%eax
  803e4e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803e51:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803e55:	74 07                	je     803e5e <insert_sorted_with_merge_freeList+0x421>
  803e57:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803e5a:	8b 00                	mov    (%eax),%eax
  803e5c:	eb 05                	jmp    803e63 <insert_sorted_with_merge_freeList+0x426>
  803e5e:	b8 00 00 00 00       	mov    $0x0,%eax
  803e63:	a3 40 51 80 00       	mov    %eax,0x805140
  803e68:	a1 40 51 80 00       	mov    0x805140,%eax
  803e6d:	85 c0                	test   %eax,%eax
  803e6f:	0f 85 1a fd ff ff    	jne    803b8f <insert_sorted_with_merge_freeList+0x152>
  803e75:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803e79:	0f 85 10 fd ff ff    	jne    803b8f <insert_sorted_with_merge_freeList+0x152>
		}
	}

	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  803e7f:	eb 00                	jmp    803e81 <insert_sorted_with_merge_freeList+0x444>
  803e81:	90                   	nop
  803e82:	c9                   	leave  
  803e83:	c3                   	ret    

00803e84 <__udivdi3>:
  803e84:	55                   	push   %ebp
  803e85:	57                   	push   %edi
  803e86:	56                   	push   %esi
  803e87:	53                   	push   %ebx
  803e88:	83 ec 1c             	sub    $0x1c,%esp
  803e8b:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  803e8f:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  803e93:	8b 7c 24 38          	mov    0x38(%esp),%edi
  803e97:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  803e9b:	89 ca                	mov    %ecx,%edx
  803e9d:	89 f8                	mov    %edi,%eax
  803e9f:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  803ea3:	85 f6                	test   %esi,%esi
  803ea5:	75 2d                	jne    803ed4 <__udivdi3+0x50>
  803ea7:	39 cf                	cmp    %ecx,%edi
  803ea9:	77 65                	ja     803f10 <__udivdi3+0x8c>
  803eab:	89 fd                	mov    %edi,%ebp
  803ead:	85 ff                	test   %edi,%edi
  803eaf:	75 0b                	jne    803ebc <__udivdi3+0x38>
  803eb1:	b8 01 00 00 00       	mov    $0x1,%eax
  803eb6:	31 d2                	xor    %edx,%edx
  803eb8:	f7 f7                	div    %edi
  803eba:	89 c5                	mov    %eax,%ebp
  803ebc:	31 d2                	xor    %edx,%edx
  803ebe:	89 c8                	mov    %ecx,%eax
  803ec0:	f7 f5                	div    %ebp
  803ec2:	89 c1                	mov    %eax,%ecx
  803ec4:	89 d8                	mov    %ebx,%eax
  803ec6:	f7 f5                	div    %ebp
  803ec8:	89 cf                	mov    %ecx,%edi
  803eca:	89 fa                	mov    %edi,%edx
  803ecc:	83 c4 1c             	add    $0x1c,%esp
  803ecf:	5b                   	pop    %ebx
  803ed0:	5e                   	pop    %esi
  803ed1:	5f                   	pop    %edi
  803ed2:	5d                   	pop    %ebp
  803ed3:	c3                   	ret    
  803ed4:	39 ce                	cmp    %ecx,%esi
  803ed6:	77 28                	ja     803f00 <__udivdi3+0x7c>
  803ed8:	0f bd fe             	bsr    %esi,%edi
  803edb:	83 f7 1f             	xor    $0x1f,%edi
  803ede:	75 40                	jne    803f20 <__udivdi3+0x9c>
  803ee0:	39 ce                	cmp    %ecx,%esi
  803ee2:	72 0a                	jb     803eee <__udivdi3+0x6a>
  803ee4:	3b 44 24 08          	cmp    0x8(%esp),%eax
  803ee8:	0f 87 9e 00 00 00    	ja     803f8c <__udivdi3+0x108>
  803eee:	b8 01 00 00 00       	mov    $0x1,%eax
  803ef3:	89 fa                	mov    %edi,%edx
  803ef5:	83 c4 1c             	add    $0x1c,%esp
  803ef8:	5b                   	pop    %ebx
  803ef9:	5e                   	pop    %esi
  803efa:	5f                   	pop    %edi
  803efb:	5d                   	pop    %ebp
  803efc:	c3                   	ret    
  803efd:	8d 76 00             	lea    0x0(%esi),%esi
  803f00:	31 ff                	xor    %edi,%edi
  803f02:	31 c0                	xor    %eax,%eax
  803f04:	89 fa                	mov    %edi,%edx
  803f06:	83 c4 1c             	add    $0x1c,%esp
  803f09:	5b                   	pop    %ebx
  803f0a:	5e                   	pop    %esi
  803f0b:	5f                   	pop    %edi
  803f0c:	5d                   	pop    %ebp
  803f0d:	c3                   	ret    
  803f0e:	66 90                	xchg   %ax,%ax
  803f10:	89 d8                	mov    %ebx,%eax
  803f12:	f7 f7                	div    %edi
  803f14:	31 ff                	xor    %edi,%edi
  803f16:	89 fa                	mov    %edi,%edx
  803f18:	83 c4 1c             	add    $0x1c,%esp
  803f1b:	5b                   	pop    %ebx
  803f1c:	5e                   	pop    %esi
  803f1d:	5f                   	pop    %edi
  803f1e:	5d                   	pop    %ebp
  803f1f:	c3                   	ret    
  803f20:	bd 20 00 00 00       	mov    $0x20,%ebp
  803f25:	89 eb                	mov    %ebp,%ebx
  803f27:	29 fb                	sub    %edi,%ebx
  803f29:	89 f9                	mov    %edi,%ecx
  803f2b:	d3 e6                	shl    %cl,%esi
  803f2d:	89 c5                	mov    %eax,%ebp
  803f2f:	88 d9                	mov    %bl,%cl
  803f31:	d3 ed                	shr    %cl,%ebp
  803f33:	89 e9                	mov    %ebp,%ecx
  803f35:	09 f1                	or     %esi,%ecx
  803f37:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  803f3b:	89 f9                	mov    %edi,%ecx
  803f3d:	d3 e0                	shl    %cl,%eax
  803f3f:	89 c5                	mov    %eax,%ebp
  803f41:	89 d6                	mov    %edx,%esi
  803f43:	88 d9                	mov    %bl,%cl
  803f45:	d3 ee                	shr    %cl,%esi
  803f47:	89 f9                	mov    %edi,%ecx
  803f49:	d3 e2                	shl    %cl,%edx
  803f4b:	8b 44 24 08          	mov    0x8(%esp),%eax
  803f4f:	88 d9                	mov    %bl,%cl
  803f51:	d3 e8                	shr    %cl,%eax
  803f53:	09 c2                	or     %eax,%edx
  803f55:	89 d0                	mov    %edx,%eax
  803f57:	89 f2                	mov    %esi,%edx
  803f59:	f7 74 24 0c          	divl   0xc(%esp)
  803f5d:	89 d6                	mov    %edx,%esi
  803f5f:	89 c3                	mov    %eax,%ebx
  803f61:	f7 e5                	mul    %ebp
  803f63:	39 d6                	cmp    %edx,%esi
  803f65:	72 19                	jb     803f80 <__udivdi3+0xfc>
  803f67:	74 0b                	je     803f74 <__udivdi3+0xf0>
  803f69:	89 d8                	mov    %ebx,%eax
  803f6b:	31 ff                	xor    %edi,%edi
  803f6d:	e9 58 ff ff ff       	jmp    803eca <__udivdi3+0x46>
  803f72:	66 90                	xchg   %ax,%ax
  803f74:	8b 54 24 08          	mov    0x8(%esp),%edx
  803f78:	89 f9                	mov    %edi,%ecx
  803f7a:	d3 e2                	shl    %cl,%edx
  803f7c:	39 c2                	cmp    %eax,%edx
  803f7e:	73 e9                	jae    803f69 <__udivdi3+0xe5>
  803f80:	8d 43 ff             	lea    -0x1(%ebx),%eax
  803f83:	31 ff                	xor    %edi,%edi
  803f85:	e9 40 ff ff ff       	jmp    803eca <__udivdi3+0x46>
  803f8a:	66 90                	xchg   %ax,%ax
  803f8c:	31 c0                	xor    %eax,%eax
  803f8e:	e9 37 ff ff ff       	jmp    803eca <__udivdi3+0x46>
  803f93:	90                   	nop

00803f94 <__umoddi3>:
  803f94:	55                   	push   %ebp
  803f95:	57                   	push   %edi
  803f96:	56                   	push   %esi
  803f97:	53                   	push   %ebx
  803f98:	83 ec 1c             	sub    $0x1c,%esp
  803f9b:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  803f9f:	8b 74 24 34          	mov    0x34(%esp),%esi
  803fa3:	8b 7c 24 38          	mov    0x38(%esp),%edi
  803fa7:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  803fab:	89 44 24 0c          	mov    %eax,0xc(%esp)
  803faf:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  803fb3:	89 f3                	mov    %esi,%ebx
  803fb5:	89 fa                	mov    %edi,%edx
  803fb7:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  803fbb:	89 34 24             	mov    %esi,(%esp)
  803fbe:	85 c0                	test   %eax,%eax
  803fc0:	75 1a                	jne    803fdc <__umoddi3+0x48>
  803fc2:	39 f7                	cmp    %esi,%edi
  803fc4:	0f 86 a2 00 00 00    	jbe    80406c <__umoddi3+0xd8>
  803fca:	89 c8                	mov    %ecx,%eax
  803fcc:	89 f2                	mov    %esi,%edx
  803fce:	f7 f7                	div    %edi
  803fd0:	89 d0                	mov    %edx,%eax
  803fd2:	31 d2                	xor    %edx,%edx
  803fd4:	83 c4 1c             	add    $0x1c,%esp
  803fd7:	5b                   	pop    %ebx
  803fd8:	5e                   	pop    %esi
  803fd9:	5f                   	pop    %edi
  803fda:	5d                   	pop    %ebp
  803fdb:	c3                   	ret    
  803fdc:	39 f0                	cmp    %esi,%eax
  803fde:	0f 87 ac 00 00 00    	ja     804090 <__umoddi3+0xfc>
  803fe4:	0f bd e8             	bsr    %eax,%ebp
  803fe7:	83 f5 1f             	xor    $0x1f,%ebp
  803fea:	0f 84 ac 00 00 00    	je     80409c <__umoddi3+0x108>
  803ff0:	bf 20 00 00 00       	mov    $0x20,%edi
  803ff5:	29 ef                	sub    %ebp,%edi
  803ff7:	89 fe                	mov    %edi,%esi
  803ff9:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  803ffd:	89 e9                	mov    %ebp,%ecx
  803fff:	d3 e0                	shl    %cl,%eax
  804001:	89 d7                	mov    %edx,%edi
  804003:	89 f1                	mov    %esi,%ecx
  804005:	d3 ef                	shr    %cl,%edi
  804007:	09 c7                	or     %eax,%edi
  804009:	89 e9                	mov    %ebp,%ecx
  80400b:	d3 e2                	shl    %cl,%edx
  80400d:	89 14 24             	mov    %edx,(%esp)
  804010:	89 d8                	mov    %ebx,%eax
  804012:	d3 e0                	shl    %cl,%eax
  804014:	89 c2                	mov    %eax,%edx
  804016:	8b 44 24 08          	mov    0x8(%esp),%eax
  80401a:	d3 e0                	shl    %cl,%eax
  80401c:	89 44 24 04          	mov    %eax,0x4(%esp)
  804020:	8b 44 24 08          	mov    0x8(%esp),%eax
  804024:	89 f1                	mov    %esi,%ecx
  804026:	d3 e8                	shr    %cl,%eax
  804028:	09 d0                	or     %edx,%eax
  80402a:	d3 eb                	shr    %cl,%ebx
  80402c:	89 da                	mov    %ebx,%edx
  80402e:	f7 f7                	div    %edi
  804030:	89 d3                	mov    %edx,%ebx
  804032:	f7 24 24             	mull   (%esp)
  804035:	89 c6                	mov    %eax,%esi
  804037:	89 d1                	mov    %edx,%ecx
  804039:	39 d3                	cmp    %edx,%ebx
  80403b:	0f 82 87 00 00 00    	jb     8040c8 <__umoddi3+0x134>
  804041:	0f 84 91 00 00 00    	je     8040d8 <__umoddi3+0x144>
  804047:	8b 54 24 04          	mov    0x4(%esp),%edx
  80404b:	29 f2                	sub    %esi,%edx
  80404d:	19 cb                	sbb    %ecx,%ebx
  80404f:	89 d8                	mov    %ebx,%eax
  804051:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  804055:	d3 e0                	shl    %cl,%eax
  804057:	89 e9                	mov    %ebp,%ecx
  804059:	d3 ea                	shr    %cl,%edx
  80405b:	09 d0                	or     %edx,%eax
  80405d:	89 e9                	mov    %ebp,%ecx
  80405f:	d3 eb                	shr    %cl,%ebx
  804061:	89 da                	mov    %ebx,%edx
  804063:	83 c4 1c             	add    $0x1c,%esp
  804066:	5b                   	pop    %ebx
  804067:	5e                   	pop    %esi
  804068:	5f                   	pop    %edi
  804069:	5d                   	pop    %ebp
  80406a:	c3                   	ret    
  80406b:	90                   	nop
  80406c:	89 fd                	mov    %edi,%ebp
  80406e:	85 ff                	test   %edi,%edi
  804070:	75 0b                	jne    80407d <__umoddi3+0xe9>
  804072:	b8 01 00 00 00       	mov    $0x1,%eax
  804077:	31 d2                	xor    %edx,%edx
  804079:	f7 f7                	div    %edi
  80407b:	89 c5                	mov    %eax,%ebp
  80407d:	89 f0                	mov    %esi,%eax
  80407f:	31 d2                	xor    %edx,%edx
  804081:	f7 f5                	div    %ebp
  804083:	89 c8                	mov    %ecx,%eax
  804085:	f7 f5                	div    %ebp
  804087:	89 d0                	mov    %edx,%eax
  804089:	e9 44 ff ff ff       	jmp    803fd2 <__umoddi3+0x3e>
  80408e:	66 90                	xchg   %ax,%ax
  804090:	89 c8                	mov    %ecx,%eax
  804092:	89 f2                	mov    %esi,%edx
  804094:	83 c4 1c             	add    $0x1c,%esp
  804097:	5b                   	pop    %ebx
  804098:	5e                   	pop    %esi
  804099:	5f                   	pop    %edi
  80409a:	5d                   	pop    %ebp
  80409b:	c3                   	ret    
  80409c:	3b 04 24             	cmp    (%esp),%eax
  80409f:	72 06                	jb     8040a7 <__umoddi3+0x113>
  8040a1:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  8040a5:	77 0f                	ja     8040b6 <__umoddi3+0x122>
  8040a7:	89 f2                	mov    %esi,%edx
  8040a9:	29 f9                	sub    %edi,%ecx
  8040ab:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  8040af:	89 14 24             	mov    %edx,(%esp)
  8040b2:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8040b6:	8b 44 24 04          	mov    0x4(%esp),%eax
  8040ba:	8b 14 24             	mov    (%esp),%edx
  8040bd:	83 c4 1c             	add    $0x1c,%esp
  8040c0:	5b                   	pop    %ebx
  8040c1:	5e                   	pop    %esi
  8040c2:	5f                   	pop    %edi
  8040c3:	5d                   	pop    %ebp
  8040c4:	c3                   	ret    
  8040c5:	8d 76 00             	lea    0x0(%esi),%esi
  8040c8:	2b 04 24             	sub    (%esp),%eax
  8040cb:	19 fa                	sbb    %edi,%edx
  8040cd:	89 d1                	mov    %edx,%ecx
  8040cf:	89 c6                	mov    %eax,%esi
  8040d1:	e9 71 ff ff ff       	jmp    804047 <__umoddi3+0xb3>
  8040d6:	66 90                	xchg   %ax,%ax
  8040d8:	39 44 24 04          	cmp    %eax,0x4(%esp)
  8040dc:	72 ea                	jb     8040c8 <__umoddi3+0x134>
  8040de:	89 d9                	mov    %ebx,%ecx
  8040e0:	e9 62 ff ff ff       	jmp    804047 <__umoddi3+0xb3>
