
obj/user/tst_realloc_3:     file format elf32-i386


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
  800031:	e8 29 06 00 00       	call   80065f <libmain>
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
  80003d:	83 ec 40             	sub    $0x40,%esp
	int Mega = 1024*1024;
  800040:	c7 45 f0 00 00 10 00 	movl   $0x100000,-0x10(%ebp)
	int kilo = 1024;
  800047:	c7 45 ec 00 04 00 00 	movl   $0x400,-0x14(%ebp)
	void* ptr_allocations[5] = {0};
  80004e:	8d 55 c4             	lea    -0x3c(%ebp),%edx
  800051:	b9 05 00 00 00       	mov    $0x5,%ecx
  800056:	b8 00 00 00 00       	mov    $0x0,%eax
  80005b:	89 d7                	mov    %edx,%edi
  80005d:	f3 ab                	rep stos %eax,%es:(%edi)
	int freeFrames ;
	int usedDiskPages;
	cprintf("realloc: current evaluation = 00%");
  80005f:	83 ec 0c             	sub    $0xc,%esp
  800062:	68 e0 35 80 00       	push   $0x8035e0
  800067:	e8 e3 09 00 00       	call   800a4f <cprintf>
  80006c:	83 c4 10             	add    $0x10,%esp
	//[1] Allocate all
	{
		//Allocate 100 KB
		freeFrames = sys_calculate_free_frames() ;
  80006f:	e8 79 1d 00 00       	call   801ded <sys_calculate_free_frames>
  800074:	89 45 e8             	mov    %eax,-0x18(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  800077:	e8 11 1e 00 00       	call   801e8d <sys_pf_calculate_allocated_pages>
  80007c:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		ptr_allocations[0] = malloc(100*kilo - kilo);
  80007f:	8b 55 ec             	mov    -0x14(%ebp),%edx
  800082:	89 d0                	mov    %edx,%eax
  800084:	01 c0                	add    %eax,%eax
  800086:	01 d0                	add    %edx,%eax
  800088:	89 c2                	mov    %eax,%edx
  80008a:	c1 e2 05             	shl    $0x5,%edx
  80008d:	01 d0                	add    %edx,%eax
  80008f:	83 ec 0c             	sub    $0xc,%esp
  800092:	50                   	push   %eax
  800093:	e8 49 19 00 00       	call   8019e1 <malloc>
  800098:	83 c4 10             	add    $0x10,%esp
  80009b:	89 45 c4             	mov    %eax,-0x3c(%ebp)
		if ((uint32) ptr_allocations[0] !=  (USER_HEAP_START)) panic("Wrong start address for the allocated space... ");
  80009e:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  8000a1:	3d 00 00 00 80       	cmp    $0x80000000,%eax
  8000a6:	74 14                	je     8000bc <_main+0x84>
  8000a8:	83 ec 04             	sub    $0x4,%esp
  8000ab:	68 04 36 80 00       	push   $0x803604
  8000b0:	6a 11                	push   $0x11
  8000b2:	68 34 36 80 00       	push   $0x803634
  8000b7:	e8 df 06 00 00       	call   80079b <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 256+1 ) panic("Wrong allocation: ");
		if((freeFrames - sys_calculate_free_frames()) != 1) panic("Wrong allocation: either extra pages are allocated in memory or pages not allocated correctly on PageFile");
  8000bc:	8b 5d e8             	mov    -0x18(%ebp),%ebx
  8000bf:	e8 29 1d 00 00       	call   801ded <sys_calculate_free_frames>
  8000c4:	29 c3                	sub    %eax,%ebx
  8000c6:	89 d8                	mov    %ebx,%eax
  8000c8:	83 f8 01             	cmp    $0x1,%eax
  8000cb:	74 14                	je     8000e1 <_main+0xa9>
  8000cd:	83 ec 04             	sub    $0x4,%esp
  8000d0:	68 4c 36 80 00       	push   $0x80364c
  8000d5:	6a 13                	push   $0x13
  8000d7:	68 34 36 80 00       	push   $0x803634
  8000dc:	e8 ba 06 00 00       	call   80079b <_panic>
		if((sys_pf_calculate_allocated_pages() - usedDiskPages) != 25) panic("Extra or less pages are allocated in PageFile");
  8000e1:	e8 a7 1d 00 00       	call   801e8d <sys_pf_calculate_allocated_pages>
  8000e6:	2b 45 e4             	sub    -0x1c(%ebp),%eax
  8000e9:	83 f8 19             	cmp    $0x19,%eax
  8000ec:	74 14                	je     800102 <_main+0xca>
  8000ee:	83 ec 04             	sub    $0x4,%esp
  8000f1:	68 b8 36 80 00       	push   $0x8036b8
  8000f6:	6a 14                	push   $0x14
  8000f8:	68 34 36 80 00       	push   $0x803634
  8000fd:	e8 99 06 00 00       	call   80079b <_panic>

		//Allocate 20 KB
		freeFrames = sys_calculate_free_frames() ;
  800102:	e8 e6 1c 00 00       	call   801ded <sys_calculate_free_frames>
  800107:	89 45 e8             	mov    %eax,-0x18(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  80010a:	e8 7e 1d 00 00       	call   801e8d <sys_pf_calculate_allocated_pages>
  80010f:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		ptr_allocations[1] = malloc(20*kilo-kilo);
  800112:	8b 55 ec             	mov    -0x14(%ebp),%edx
  800115:	89 d0                	mov    %edx,%eax
  800117:	c1 e0 03             	shl    $0x3,%eax
  80011a:	01 d0                	add    %edx,%eax
  80011c:	01 c0                	add    %eax,%eax
  80011e:	01 d0                	add    %edx,%eax
  800120:	83 ec 0c             	sub    $0xc,%esp
  800123:	50                   	push   %eax
  800124:	e8 b8 18 00 00       	call   8019e1 <malloc>
  800129:	83 c4 10             	add    $0x10,%esp
  80012c:	89 45 c8             	mov    %eax,-0x38(%ebp)
		if ((uint32) ptr_allocations[1] !=  (USER_HEAP_START + 100 * kilo)) panic("Wrong start address for the allocated space... ");
  80012f:	8b 45 c8             	mov    -0x38(%ebp),%eax
  800132:	89 c1                	mov    %eax,%ecx
  800134:	8b 55 ec             	mov    -0x14(%ebp),%edx
  800137:	89 d0                	mov    %edx,%eax
  800139:	c1 e0 02             	shl    $0x2,%eax
  80013c:	01 d0                	add    %edx,%eax
  80013e:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800145:	01 d0                	add    %edx,%eax
  800147:	c1 e0 02             	shl    $0x2,%eax
  80014a:	05 00 00 00 80       	add    $0x80000000,%eax
  80014f:	39 c1                	cmp    %eax,%ecx
  800151:	74 14                	je     800167 <_main+0x12f>
  800153:	83 ec 04             	sub    $0x4,%esp
  800156:	68 04 36 80 00       	push   $0x803604
  80015b:	6a 1a                	push   $0x1a
  80015d:	68 34 36 80 00       	push   $0x803634
  800162:	e8 34 06 00 00       	call   80079b <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 256 ) panic("Wrong allocation: ");
		if((freeFrames - sys_calculate_free_frames()) != 0) panic("Wrong allocation: either extra pages are allocated in memory or pages not allocated correctly on PageFile");
  800167:	e8 81 1c 00 00       	call   801ded <sys_calculate_free_frames>
  80016c:	89 c2                	mov    %eax,%edx
  80016e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800171:	39 c2                	cmp    %eax,%edx
  800173:	74 14                	je     800189 <_main+0x151>
  800175:	83 ec 04             	sub    $0x4,%esp
  800178:	68 4c 36 80 00       	push   $0x80364c
  80017d:	6a 1c                	push   $0x1c
  80017f:	68 34 36 80 00       	push   $0x803634
  800184:	e8 12 06 00 00       	call   80079b <_panic>
		if((sys_pf_calculate_allocated_pages() - usedDiskPages) != 5) panic("Extra or less pages are allocated in PageFile");
  800189:	e8 ff 1c 00 00       	call   801e8d <sys_pf_calculate_allocated_pages>
  80018e:	2b 45 e4             	sub    -0x1c(%ebp),%eax
  800191:	83 f8 05             	cmp    $0x5,%eax
  800194:	74 14                	je     8001aa <_main+0x172>
  800196:	83 ec 04             	sub    $0x4,%esp
  800199:	68 b8 36 80 00       	push   $0x8036b8
  80019e:	6a 1d                	push   $0x1d
  8001a0:	68 34 36 80 00       	push   $0x803634
  8001a5:	e8 f1 05 00 00       	call   80079b <_panic>

		//Allocate 30 KB
		freeFrames = sys_calculate_free_frames() ;
  8001aa:	e8 3e 1c 00 00       	call   801ded <sys_calculate_free_frames>
  8001af:	89 45 e8             	mov    %eax,-0x18(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  8001b2:	e8 d6 1c 00 00       	call   801e8d <sys_pf_calculate_allocated_pages>
  8001b7:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		ptr_allocations[2] = malloc(30 * kilo -kilo);
  8001ba:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8001bd:	89 d0                	mov    %edx,%eax
  8001bf:	01 c0                	add    %eax,%eax
  8001c1:	01 d0                	add    %edx,%eax
  8001c3:	01 c0                	add    %eax,%eax
  8001c5:	01 d0                	add    %edx,%eax
  8001c7:	c1 e0 02             	shl    $0x2,%eax
  8001ca:	01 d0                	add    %edx,%eax
  8001cc:	83 ec 0c             	sub    $0xc,%esp
  8001cf:	50                   	push   %eax
  8001d0:	e8 0c 18 00 00       	call   8019e1 <malloc>
  8001d5:	83 c4 10             	add    $0x10,%esp
  8001d8:	89 45 cc             	mov    %eax,-0x34(%ebp)
		if ((uint32) ptr_allocations[2] !=  (USER_HEAP_START + 120 * kilo)) panic("Wrong start address for the allocated space... ");
  8001db:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8001de:	89 c1                	mov    %eax,%ecx
  8001e0:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8001e3:	89 d0                	mov    %edx,%eax
  8001e5:	01 c0                	add    %eax,%eax
  8001e7:	01 d0                	add    %edx,%eax
  8001e9:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8001f0:	01 d0                	add    %edx,%eax
  8001f2:	c1 e0 03             	shl    $0x3,%eax
  8001f5:	05 00 00 00 80       	add    $0x80000000,%eax
  8001fa:	39 c1                	cmp    %eax,%ecx
  8001fc:	74 14                	je     800212 <_main+0x1da>
  8001fe:	83 ec 04             	sub    $0x4,%esp
  800201:	68 04 36 80 00       	push   $0x803604
  800206:	6a 23                	push   $0x23
  800208:	68 34 36 80 00       	push   $0x803634
  80020d:	e8 89 05 00 00       	call   80079b <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 256 ) panic("Wrong allocation: ");
		if((freeFrames - sys_calculate_free_frames()) != 0) panic("Wrong allocation: either extra pages are allocated in memory or pages not allocated correctly on PageFile");
  800212:	e8 d6 1b 00 00       	call   801ded <sys_calculate_free_frames>
  800217:	89 c2                	mov    %eax,%edx
  800219:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80021c:	39 c2                	cmp    %eax,%edx
  80021e:	74 14                	je     800234 <_main+0x1fc>
  800220:	83 ec 04             	sub    $0x4,%esp
  800223:	68 4c 36 80 00       	push   $0x80364c
  800228:	6a 25                	push   $0x25
  80022a:	68 34 36 80 00       	push   $0x803634
  80022f:	e8 67 05 00 00       	call   80079b <_panic>
		if((sys_pf_calculate_allocated_pages() - usedDiskPages) != 8) panic("Extra or less pages are allocated in PageFile");
  800234:	e8 54 1c 00 00       	call   801e8d <sys_pf_calculate_allocated_pages>
  800239:	2b 45 e4             	sub    -0x1c(%ebp),%eax
  80023c:	83 f8 08             	cmp    $0x8,%eax
  80023f:	74 14                	je     800255 <_main+0x21d>
  800241:	83 ec 04             	sub    $0x4,%esp
  800244:	68 b8 36 80 00       	push   $0x8036b8
  800249:	6a 26                	push   $0x26
  80024b:	68 34 36 80 00       	push   $0x803634
  800250:	e8 46 05 00 00       	call   80079b <_panic>

		//Allocate 40 KB
		freeFrames = sys_calculate_free_frames() ;
  800255:	e8 93 1b 00 00       	call   801ded <sys_calculate_free_frames>
  80025a:	89 45 e8             	mov    %eax,-0x18(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  80025d:	e8 2b 1c 00 00       	call   801e8d <sys_pf_calculate_allocated_pages>
  800262:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		ptr_allocations[3] = malloc(40 * kilo -kilo);
  800265:	8b 55 ec             	mov    -0x14(%ebp),%edx
  800268:	89 d0                	mov    %edx,%eax
  80026a:	c1 e0 03             	shl    $0x3,%eax
  80026d:	01 d0                	add    %edx,%eax
  80026f:	01 c0                	add    %eax,%eax
  800271:	01 d0                	add    %edx,%eax
  800273:	01 c0                	add    %eax,%eax
  800275:	01 d0                	add    %edx,%eax
  800277:	83 ec 0c             	sub    $0xc,%esp
  80027a:	50                   	push   %eax
  80027b:	e8 61 17 00 00       	call   8019e1 <malloc>
  800280:	83 c4 10             	add    $0x10,%esp
  800283:	89 45 d0             	mov    %eax,-0x30(%ebp)
		if ((uint32) ptr_allocations[3] !=  (USER_HEAP_START + 152 * kilo)) panic("Wrong start address for the allocated space... ");
  800286:	8b 45 d0             	mov    -0x30(%ebp),%eax
  800289:	89 c1                	mov    %eax,%ecx
  80028b:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80028e:	89 d0                	mov    %edx,%eax
  800290:	c1 e0 03             	shl    $0x3,%eax
  800293:	01 d0                	add    %edx,%eax
  800295:	01 c0                	add    %eax,%eax
  800297:	01 d0                	add    %edx,%eax
  800299:	c1 e0 03             	shl    $0x3,%eax
  80029c:	05 00 00 00 80       	add    $0x80000000,%eax
  8002a1:	39 c1                	cmp    %eax,%ecx
  8002a3:	74 14                	je     8002b9 <_main+0x281>
  8002a5:	83 ec 04             	sub    $0x4,%esp
  8002a8:	68 04 36 80 00       	push   $0x803604
  8002ad:	6a 2c                	push   $0x2c
  8002af:	68 34 36 80 00       	push   $0x803634
  8002b4:	e8 e2 04 00 00       	call   80079b <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 256 ) panic("Wrong allocation: ");
		if((freeFrames - sys_calculate_free_frames()) != 0) panic("Wrong allocation: either extra pages are allocated in memory or pages not allocated correctly on PageFile");
  8002b9:	e8 2f 1b 00 00       	call   801ded <sys_calculate_free_frames>
  8002be:	89 c2                	mov    %eax,%edx
  8002c0:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8002c3:	39 c2                	cmp    %eax,%edx
  8002c5:	74 14                	je     8002db <_main+0x2a3>
  8002c7:	83 ec 04             	sub    $0x4,%esp
  8002ca:	68 4c 36 80 00       	push   $0x80364c
  8002cf:	6a 2e                	push   $0x2e
  8002d1:	68 34 36 80 00       	push   $0x803634
  8002d6:	e8 c0 04 00 00       	call   80079b <_panic>
		if((sys_pf_calculate_allocated_pages() - usedDiskPages) != 10) panic("Extra or less pages are allocated in PageFile");
  8002db:	e8 ad 1b 00 00       	call   801e8d <sys_pf_calculate_allocated_pages>
  8002e0:	2b 45 e4             	sub    -0x1c(%ebp),%eax
  8002e3:	83 f8 0a             	cmp    $0xa,%eax
  8002e6:	74 14                	je     8002fc <_main+0x2c4>
  8002e8:	83 ec 04             	sub    $0x4,%esp
  8002eb:	68 b8 36 80 00       	push   $0x8036b8
  8002f0:	6a 2f                	push   $0x2f
  8002f2:	68 34 36 80 00       	push   $0x803634
  8002f7:	e8 9f 04 00 00       	call   80079b <_panic>


	}


	int cnt = 0;
  8002fc:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
	//[2] Test Re-allocation
	{
		/*Reallocate the first array (100 KB) to the last hole*/

		//Fill the first array with data
		int *intArr = (int*) ptr_allocations[0];
  800303:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  800306:	89 45 dc             	mov    %eax,-0x24(%ebp)
		int lastIndexOfInt1 = (100*kilo)/sizeof(int) - 1;
  800309:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80030c:	89 d0                	mov    %edx,%eax
  80030e:	c1 e0 02             	shl    $0x2,%eax
  800311:	01 d0                	add    %edx,%eax
  800313:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80031a:	01 d0                	add    %edx,%eax
  80031c:	c1 e0 02             	shl    $0x2,%eax
  80031f:	c1 e8 02             	shr    $0x2,%eax
  800322:	48                   	dec    %eax
  800323:	89 45 d8             	mov    %eax,-0x28(%ebp)

		int i = 0;
  800326:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
		for (i=0; i < lastIndexOfInt1 ; i++)
  80032d:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  800334:	eb 17                	jmp    80034d <_main+0x315>
		{
			intArr[i] = i ;
  800336:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800339:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800340:	8b 45 dc             	mov    -0x24(%ebp),%eax
  800343:	01 c2                	add    %eax,%edx
  800345:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800348:	89 02                	mov    %eax,(%edx)
		//Fill the first array with data
		int *intArr = (int*) ptr_allocations[0];
		int lastIndexOfInt1 = (100*kilo)/sizeof(int) - 1;

		int i = 0;
		for (i=0; i < lastIndexOfInt1 ; i++)
  80034a:	ff 45 f4             	incl   -0xc(%ebp)
  80034d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800350:	3b 45 d8             	cmp    -0x28(%ebp),%eax
  800353:	7c e1                	jl     800336 <_main+0x2fe>
		{
			intArr[i] = i ;
		}

		//Fill the second array with data
		intArr = (int*) ptr_allocations[1];
  800355:	8b 45 c8             	mov    -0x38(%ebp),%eax
  800358:	89 45 dc             	mov    %eax,-0x24(%ebp)
		lastIndexOfInt1 = (20*kilo)/sizeof(int) - 1;
  80035b:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80035e:	89 d0                	mov    %edx,%eax
  800360:	c1 e0 02             	shl    $0x2,%eax
  800363:	01 d0                	add    %edx,%eax
  800365:	c1 e0 02             	shl    $0x2,%eax
  800368:	c1 e8 02             	shr    $0x2,%eax
  80036b:	48                   	dec    %eax
  80036c:	89 45 d8             	mov    %eax,-0x28(%ebp)

		for (i=0; i < lastIndexOfInt1 ; i++)
  80036f:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  800376:	eb 17                	jmp    80038f <_main+0x357>
		{
			intArr[i] = i ;
  800378:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80037b:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800382:	8b 45 dc             	mov    -0x24(%ebp),%eax
  800385:	01 c2                	add    %eax,%edx
  800387:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80038a:	89 02                	mov    %eax,(%edx)

		//Fill the second array with data
		intArr = (int*) ptr_allocations[1];
		lastIndexOfInt1 = (20*kilo)/sizeof(int) - 1;

		for (i=0; i < lastIndexOfInt1 ; i++)
  80038c:	ff 45 f4             	incl   -0xc(%ebp)
  80038f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800392:	3b 45 d8             	cmp    -0x28(%ebp),%eax
  800395:	7c e1                	jl     800378 <_main+0x340>
		{
			intArr[i] = i ;
		}

		//Fill the third array with data
		intArr = (int*) ptr_allocations[2];
  800397:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80039a:	89 45 dc             	mov    %eax,-0x24(%ebp)
		lastIndexOfInt1 = (30*kilo)/sizeof(int) - 1;
  80039d:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8003a0:	89 d0                	mov    %edx,%eax
  8003a2:	01 c0                	add    %eax,%eax
  8003a4:	01 d0                	add    %edx,%eax
  8003a6:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8003ad:	01 d0                	add    %edx,%eax
  8003af:	01 c0                	add    %eax,%eax
  8003b1:	c1 e8 02             	shr    $0x2,%eax
  8003b4:	48                   	dec    %eax
  8003b5:	89 45 d8             	mov    %eax,-0x28(%ebp)

		for (i=0; i < lastIndexOfInt1 ; i++)
  8003b8:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  8003bf:	eb 17                	jmp    8003d8 <_main+0x3a0>
		{
			intArr[i] = i ;
  8003c1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8003c4:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8003cb:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8003ce:	01 c2                	add    %eax,%edx
  8003d0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8003d3:	89 02                	mov    %eax,(%edx)

		//Fill the third array with data
		intArr = (int*) ptr_allocations[2];
		lastIndexOfInt1 = (30*kilo)/sizeof(int) - 1;

		for (i=0; i < lastIndexOfInt1 ; i++)
  8003d5:	ff 45 f4             	incl   -0xc(%ebp)
  8003d8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8003db:	3b 45 d8             	cmp    -0x28(%ebp),%eax
  8003de:	7c e1                	jl     8003c1 <_main+0x389>
		{
			intArr[i] = i ;
		}

		//Fill the fourth array with data
		intArr = (int*) ptr_allocations[3];
  8003e0:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8003e3:	89 45 dc             	mov    %eax,-0x24(%ebp)
		lastIndexOfInt1 = (40*kilo)/sizeof(int) - 1;
  8003e6:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8003e9:	89 d0                	mov    %edx,%eax
  8003eb:	c1 e0 02             	shl    $0x2,%eax
  8003ee:	01 d0                	add    %edx,%eax
  8003f0:	c1 e0 03             	shl    $0x3,%eax
  8003f3:	c1 e8 02             	shr    $0x2,%eax
  8003f6:	48                   	dec    %eax
  8003f7:	89 45 d8             	mov    %eax,-0x28(%ebp)

		for (i=0; i < lastIndexOfInt1 ; i++)
  8003fa:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  800401:	eb 17                	jmp    80041a <_main+0x3e2>
		{
			intArr[i] = i ;
  800403:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800406:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80040d:	8b 45 dc             	mov    -0x24(%ebp),%eax
  800410:	01 c2                	add    %eax,%edx
  800412:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800415:	89 02                	mov    %eax,(%edx)

		//Fill the fourth array with data
		intArr = (int*) ptr_allocations[3];
		lastIndexOfInt1 = (40*kilo)/sizeof(int) - 1;

		for (i=0; i < lastIndexOfInt1 ; i++)
  800417:	ff 45 f4             	incl   -0xc(%ebp)
  80041a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80041d:	3b 45 d8             	cmp    -0x28(%ebp),%eax
  800420:	7c e1                	jl     800403 <_main+0x3cb>
			intArr[i] = i ;
		}


		//Reallocate the first array to 200 KB [should be moved to after the fourth one]
		freeFrames = sys_calculate_free_frames() ;
  800422:	e8 c6 19 00 00       	call   801ded <sys_calculate_free_frames>
  800427:	89 45 e8             	mov    %eax,-0x18(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  80042a:	e8 5e 1a 00 00       	call   801e8d <sys_pf_calculate_allocated_pages>
  80042f:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		ptr_allocations[0] = realloc(ptr_allocations[0], 200 * kilo - kilo);
  800432:	8b 55 ec             	mov    -0x14(%ebp),%edx
  800435:	89 d0                	mov    %edx,%eax
  800437:	01 c0                	add    %eax,%eax
  800439:	01 d0                	add    %edx,%eax
  80043b:	89 c1                	mov    %eax,%ecx
  80043d:	c1 e1 05             	shl    $0x5,%ecx
  800440:	01 c8                	add    %ecx,%eax
  800442:	01 c0                	add    %eax,%eax
  800444:	01 d0                	add    %edx,%eax
  800446:	89 c2                	mov    %eax,%edx
  800448:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  80044b:	83 ec 08             	sub    $0x8,%esp
  80044e:	52                   	push   %edx
  80044f:	50                   	push   %eax
  800450:	e8 16 18 00 00       	call   801c6b <realloc>
  800455:	83 c4 10             	add    $0x10,%esp
  800458:	89 45 c4             	mov    %eax,-0x3c(%ebp)

		//[1] test return address & re-allocated space
		if ((uint32) ptr_allocations[0] != (USER_HEAP_START + 192 * kilo)) panic("Wrong start address for the re-allocated space... ");
  80045b:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  80045e:	89 c1                	mov    %eax,%ecx
  800460:	8b 55 ec             	mov    -0x14(%ebp),%edx
  800463:	89 d0                	mov    %edx,%eax
  800465:	01 c0                	add    %eax,%eax
  800467:	01 d0                	add    %edx,%eax
  800469:	c1 e0 06             	shl    $0x6,%eax
  80046c:	05 00 00 00 80       	add    $0x80000000,%eax
  800471:	39 c1                	cmp    %eax,%ecx
  800473:	74 14                	je     800489 <_main+0x451>
  800475:	83 ec 04             	sub    $0x4,%esp
  800478:	68 e8 36 80 00       	push   $0x8036e8
  80047d:	6a 6b                	push   $0x6b
  80047f:	68 34 36 80 00       	push   $0x803634
  800484:	e8 12 03 00 00       	call   80079b <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 64) panic("Wrong re-allocation");
		//if((freeFrames - sys_calculate_free_frames()) != 0) panic("Wrong re-allocation: either extra pages are re-allocated in memory or pages not allocated correctly on PageFile");
		if((sys_pf_calculate_allocated_pages() - usedDiskPages) != 25) panic("Extra or less pages are re-allocated in PageFile");
  800489:	e8 ff 19 00 00       	call   801e8d <sys_pf_calculate_allocated_pages>
  80048e:	2b 45 e4             	sub    -0x1c(%ebp),%eax
  800491:	83 f8 19             	cmp    $0x19,%eax
  800494:	74 14                	je     8004aa <_main+0x472>
  800496:	83 ec 04             	sub    $0x4,%esp
  800499:	68 1c 37 80 00       	push   $0x80371c
  80049e:	6a 6e                	push   $0x6e
  8004a0:	68 34 36 80 00       	push   $0x803634
  8004a5:	e8 f1 02 00 00       	call   80079b <_panic>


		vcprintf("\b\b\b50%", NULL);
  8004aa:	83 ec 08             	sub    $0x8,%esp
  8004ad:	6a 00                	push   $0x0
  8004af:	68 4d 37 80 00       	push   $0x80374d
  8004b4:	e8 2b 05 00 00       	call   8009e4 <vcprintf>
  8004b9:	83 c4 10             	add    $0x10,%esp

		//Fill the first array with data
		intArr = (int*) ptr_allocations[0];
  8004bc:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  8004bf:	89 45 dc             	mov    %eax,-0x24(%ebp)
		lastIndexOfInt1 = (100*kilo)/sizeof(int) - 1;
  8004c2:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8004c5:	89 d0                	mov    %edx,%eax
  8004c7:	c1 e0 02             	shl    $0x2,%eax
  8004ca:	01 d0                	add    %edx,%eax
  8004cc:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8004d3:	01 d0                	add    %edx,%eax
  8004d5:	c1 e0 02             	shl    $0x2,%eax
  8004d8:	c1 e8 02             	shr    $0x2,%eax
  8004db:	48                   	dec    %eax
  8004dc:	89 45 d8             	mov    %eax,-0x28(%ebp)

		for (i=0; i < lastIndexOfInt1 ; i++)
  8004df:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  8004e6:	eb 2d                	jmp    800515 <_main+0x4dd>
		{
			if(intArr[i] != i)
  8004e8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8004eb:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8004f2:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8004f5:	01 d0                	add    %edx,%eax
  8004f7:	8b 00                	mov    (%eax),%eax
  8004f9:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  8004fc:	74 14                	je     800512 <_main+0x4da>
				panic("Wrong re-allocation: stored values are wrongly changed!");
  8004fe:	83 ec 04             	sub    $0x4,%esp
  800501:	68 54 37 80 00       	push   $0x803754
  800506:	6a 7a                	push   $0x7a
  800508:	68 34 36 80 00       	push   $0x803634
  80050d:	e8 89 02 00 00       	call   80079b <_panic>

		//Fill the first array with data
		intArr = (int*) ptr_allocations[0];
		lastIndexOfInt1 = (100*kilo)/sizeof(int) - 1;

		for (i=0; i < lastIndexOfInt1 ; i++)
  800512:	ff 45 f4             	incl   -0xc(%ebp)
  800515:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800518:	3b 45 d8             	cmp    -0x28(%ebp),%eax
  80051b:	7c cb                	jl     8004e8 <_main+0x4b0>
			if(intArr[i] != i)
				panic("Wrong re-allocation: stored values are wrongly changed!");
		}

		//Fill the second array with data
		intArr = (int*) ptr_allocations[1];
  80051d:	8b 45 c8             	mov    -0x38(%ebp),%eax
  800520:	89 45 dc             	mov    %eax,-0x24(%ebp)
		lastIndexOfInt1 = (20*kilo)/sizeof(int) - 1;
  800523:	8b 55 ec             	mov    -0x14(%ebp),%edx
  800526:	89 d0                	mov    %edx,%eax
  800528:	c1 e0 02             	shl    $0x2,%eax
  80052b:	01 d0                	add    %edx,%eax
  80052d:	c1 e0 02             	shl    $0x2,%eax
  800530:	c1 e8 02             	shr    $0x2,%eax
  800533:	48                   	dec    %eax
  800534:	89 45 d8             	mov    %eax,-0x28(%ebp)

		for (i=0; i < lastIndexOfInt1 ; i++)
  800537:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  80053e:	eb 30                	jmp    800570 <_main+0x538>
		{
			if(intArr[i] != i)
  800540:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800543:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80054a:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80054d:	01 d0                	add    %edx,%eax
  80054f:	8b 00                	mov    (%eax),%eax
  800551:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  800554:	74 17                	je     80056d <_main+0x535>
				panic("Wrong re-allocation: stored values are wrongly changed!");
  800556:	83 ec 04             	sub    $0x4,%esp
  800559:	68 54 37 80 00       	push   $0x803754
  80055e:	68 84 00 00 00       	push   $0x84
  800563:	68 34 36 80 00       	push   $0x803634
  800568:	e8 2e 02 00 00       	call   80079b <_panic>

		//Fill the second array with data
		intArr = (int*) ptr_allocations[1];
		lastIndexOfInt1 = (20*kilo)/sizeof(int) - 1;

		for (i=0; i < lastIndexOfInt1 ; i++)
  80056d:	ff 45 f4             	incl   -0xc(%ebp)
  800570:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800573:	3b 45 d8             	cmp    -0x28(%ebp),%eax
  800576:	7c c8                	jl     800540 <_main+0x508>
			if(intArr[i] != i)
				panic("Wrong re-allocation: stored values are wrongly changed!");
		}

		//Fill the third array with data
		intArr = (int*) ptr_allocations[2];
  800578:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80057b:	89 45 dc             	mov    %eax,-0x24(%ebp)
		lastIndexOfInt1 = (30*kilo)/sizeof(int) - 1;
  80057e:	8b 55 ec             	mov    -0x14(%ebp),%edx
  800581:	89 d0                	mov    %edx,%eax
  800583:	01 c0                	add    %eax,%eax
  800585:	01 d0                	add    %edx,%eax
  800587:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80058e:	01 d0                	add    %edx,%eax
  800590:	01 c0                	add    %eax,%eax
  800592:	c1 e8 02             	shr    $0x2,%eax
  800595:	48                   	dec    %eax
  800596:	89 45 d8             	mov    %eax,-0x28(%ebp)

		for (i=0; i < lastIndexOfInt1 ; i++)
  800599:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  8005a0:	eb 30                	jmp    8005d2 <_main+0x59a>
		{
			if(intArr[i] != i)
  8005a2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8005a5:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8005ac:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8005af:	01 d0                	add    %edx,%eax
  8005b1:	8b 00                	mov    (%eax),%eax
  8005b3:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  8005b6:	74 17                	je     8005cf <_main+0x597>
				panic("Wrong re-allocation: stored values are wrongly changed!");
  8005b8:	83 ec 04             	sub    $0x4,%esp
  8005bb:	68 54 37 80 00       	push   $0x803754
  8005c0:	68 8e 00 00 00       	push   $0x8e
  8005c5:	68 34 36 80 00       	push   $0x803634
  8005ca:	e8 cc 01 00 00       	call   80079b <_panic>

		//Fill the third array with data
		intArr = (int*) ptr_allocations[2];
		lastIndexOfInt1 = (30*kilo)/sizeof(int) - 1;

		for (i=0; i < lastIndexOfInt1 ; i++)
  8005cf:	ff 45 f4             	incl   -0xc(%ebp)
  8005d2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8005d5:	3b 45 d8             	cmp    -0x28(%ebp),%eax
  8005d8:	7c c8                	jl     8005a2 <_main+0x56a>
			if(intArr[i] != i)
				panic("Wrong re-allocation: stored values are wrongly changed!");
		}

		//Fill the fourth array with data
		intArr = (int*) ptr_allocations[3];
  8005da:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8005dd:	89 45 dc             	mov    %eax,-0x24(%ebp)
		lastIndexOfInt1 = (40*kilo)/sizeof(int) - 1;
  8005e0:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8005e3:	89 d0                	mov    %edx,%eax
  8005e5:	c1 e0 02             	shl    $0x2,%eax
  8005e8:	01 d0                	add    %edx,%eax
  8005ea:	c1 e0 03             	shl    $0x3,%eax
  8005ed:	c1 e8 02             	shr    $0x2,%eax
  8005f0:	48                   	dec    %eax
  8005f1:	89 45 d8             	mov    %eax,-0x28(%ebp)

		for (i=0; i < lastIndexOfInt1 ; i++)
  8005f4:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  8005fb:	eb 30                	jmp    80062d <_main+0x5f5>
		{
			if(intArr[i] != i)
  8005fd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800600:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800607:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80060a:	01 d0                	add    %edx,%eax
  80060c:	8b 00                	mov    (%eax),%eax
  80060e:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  800611:	74 17                	je     80062a <_main+0x5f2>
				panic("Wrong re-allocation: stored values are wrongly changed!");
  800613:	83 ec 04             	sub    $0x4,%esp
  800616:	68 54 37 80 00       	push   $0x803754
  80061b:	68 98 00 00 00       	push   $0x98
  800620:	68 34 36 80 00       	push   $0x803634
  800625:	e8 71 01 00 00       	call   80079b <_panic>

		//Fill the fourth array with data
		intArr = (int*) ptr_allocations[3];
		lastIndexOfInt1 = (40*kilo)/sizeof(int) - 1;

		for (i=0; i < lastIndexOfInt1 ; i++)
  80062a:	ff 45 f4             	incl   -0xc(%ebp)
  80062d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800630:	3b 45 d8             	cmp    -0x28(%ebp),%eax
  800633:	7c c8                	jl     8005fd <_main+0x5c5>
				panic("Wrong re-allocation: stored values are wrongly changed!");

		}


		vcprintf("\b\b\b100%\n", NULL);
  800635:	83 ec 08             	sub    $0x8,%esp
  800638:	6a 00                	push   $0x0
  80063a:	68 8c 37 80 00       	push   $0x80378c
  80063f:	e8 a0 03 00 00       	call   8009e4 <vcprintf>
  800644:	83 c4 10             	add    $0x10,%esp
	}



	cprintf("Congratulations!! test realloc [3] completed successfully.\n");
  800647:	83 ec 0c             	sub    $0xc,%esp
  80064a:	68 98 37 80 00       	push   $0x803798
  80064f:	e8 fb 03 00 00       	call   800a4f <cprintf>
  800654:	83 c4 10             	add    $0x10,%esp

	return;
  800657:	90                   	nop
}
  800658:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80065b:	5b                   	pop    %ebx
  80065c:	5f                   	pop    %edi
  80065d:	5d                   	pop    %ebp
  80065e:	c3                   	ret    

0080065f <libmain>:
volatile struct Env *myEnv = NULL;
volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";

void
libmain(int argc, char **argv)
{
  80065f:	55                   	push   %ebp
  800660:	89 e5                	mov    %esp,%ebp
  800662:	83 ec 18             	sub    $0x18,%esp
	int envIndex = sys_getenvindex();
  800665:	e8 63 1a 00 00       	call   8020cd <sys_getenvindex>
  80066a:	89 45 f4             	mov    %eax,-0xc(%ebp)
	myEnv = &(envs[envIndex]);
  80066d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800670:	89 d0                	mov    %edx,%eax
  800672:	c1 e0 03             	shl    $0x3,%eax
  800675:	01 d0                	add    %edx,%eax
  800677:	01 c0                	add    %eax,%eax
  800679:	01 d0                	add    %edx,%eax
  80067b:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800682:	01 d0                	add    %edx,%eax
  800684:	c1 e0 04             	shl    $0x4,%eax
  800687:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  80068c:	a3 20 40 80 00       	mov    %eax,0x804020

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  800691:	a1 20 40 80 00       	mov    0x804020,%eax
  800696:	8a 80 5c 05 00 00    	mov    0x55c(%eax),%al
  80069c:	84 c0                	test   %al,%al
  80069e:	74 0f                	je     8006af <libmain+0x50>
		binaryname = myEnv->prog_name;
  8006a0:	a1 20 40 80 00       	mov    0x804020,%eax
  8006a5:	05 5c 05 00 00       	add    $0x55c,%eax
  8006aa:	a3 00 40 80 00       	mov    %eax,0x804000

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8006af:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8006b3:	7e 0a                	jle    8006bf <libmain+0x60>
		binaryname = argv[0];
  8006b5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8006b8:	8b 00                	mov    (%eax),%eax
  8006ba:	a3 00 40 80 00       	mov    %eax,0x804000

	// call user main routine
	_main(argc, argv);
  8006bf:	83 ec 08             	sub    $0x8,%esp
  8006c2:	ff 75 0c             	pushl  0xc(%ebp)
  8006c5:	ff 75 08             	pushl  0x8(%ebp)
  8006c8:	e8 6b f9 ff ff       	call   800038 <_main>
  8006cd:	83 c4 10             	add    $0x10,%esp



	sys_disable_interrupt();
  8006d0:	e8 05 18 00 00       	call   801eda <sys_disable_interrupt>
	cprintf("**************************************\n");
  8006d5:	83 ec 0c             	sub    $0xc,%esp
  8006d8:	68 ec 37 80 00       	push   $0x8037ec
  8006dd:	e8 6d 03 00 00       	call   800a4f <cprintf>
  8006e2:	83 c4 10             	add    $0x10,%esp
	cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  8006e5:	a1 20 40 80 00       	mov    0x804020,%eax
  8006ea:	8b 90 44 05 00 00    	mov    0x544(%eax),%edx
  8006f0:	a1 20 40 80 00       	mov    0x804020,%eax
  8006f5:	8b 80 34 05 00 00    	mov    0x534(%eax),%eax
  8006fb:	83 ec 04             	sub    $0x4,%esp
  8006fe:	52                   	push   %edx
  8006ff:	50                   	push   %eax
  800700:	68 14 38 80 00       	push   $0x803814
  800705:	e8 45 03 00 00       	call   800a4f <cprintf>
  80070a:	83 c4 10             	add    $0x10,%esp
	cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  80070d:	a1 20 40 80 00       	mov    0x804020,%eax
  800712:	8b 88 54 05 00 00    	mov    0x554(%eax),%ecx
  800718:	a1 20 40 80 00       	mov    0x804020,%eax
  80071d:	8b 90 50 05 00 00    	mov    0x550(%eax),%edx
  800723:	a1 20 40 80 00       	mov    0x804020,%eax
  800728:	8b 80 4c 05 00 00    	mov    0x54c(%eax),%eax
  80072e:	51                   	push   %ecx
  80072f:	52                   	push   %edx
  800730:	50                   	push   %eax
  800731:	68 3c 38 80 00       	push   $0x80383c
  800736:	e8 14 03 00 00       	call   800a4f <cprintf>
  80073b:	83 c4 10             	add    $0x10,%esp
	//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
	cprintf("Num of clocks = %d\n", myEnv->nClocks);
  80073e:	a1 20 40 80 00       	mov    0x804020,%eax
  800743:	8b 80 a4 05 00 00    	mov    0x5a4(%eax),%eax
  800749:	83 ec 08             	sub    $0x8,%esp
  80074c:	50                   	push   %eax
  80074d:	68 94 38 80 00       	push   $0x803894
  800752:	e8 f8 02 00 00       	call   800a4f <cprintf>
  800757:	83 c4 10             	add    $0x10,%esp
	cprintf("**************************************\n");
  80075a:	83 ec 0c             	sub    $0xc,%esp
  80075d:	68 ec 37 80 00       	push   $0x8037ec
  800762:	e8 e8 02 00 00       	call   800a4f <cprintf>
  800767:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  80076a:	e8 85 17 00 00       	call   801ef4 <sys_enable_interrupt>

	// exit gracefully
	exit();
  80076f:	e8 19 00 00 00       	call   80078d <exit>
}
  800774:	90                   	nop
  800775:	c9                   	leave  
  800776:	c3                   	ret    

00800777 <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  800777:	55                   	push   %ebp
  800778:	89 e5                	mov    %esp,%ebp
  80077a:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  80077d:	83 ec 0c             	sub    $0xc,%esp
  800780:	6a 00                	push   $0x0
  800782:	e8 12 19 00 00       	call   802099 <sys_destroy_env>
  800787:	83 c4 10             	add    $0x10,%esp
}
  80078a:	90                   	nop
  80078b:	c9                   	leave  
  80078c:	c3                   	ret    

0080078d <exit>:

void
exit(void)
{
  80078d:	55                   	push   %ebp
  80078e:	89 e5                	mov    %esp,%ebp
  800790:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  800793:	e8 67 19 00 00       	call   8020ff <sys_exit_env>
}
  800798:	90                   	nop
  800799:	c9                   	leave  
  80079a:	c3                   	ret    

0080079b <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  80079b:	55                   	push   %ebp
  80079c:	89 e5                	mov    %esp,%ebp
  80079e:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  8007a1:	8d 45 10             	lea    0x10(%ebp),%eax
  8007a4:	83 c0 04             	add    $0x4,%eax
  8007a7:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  8007aa:	a1 5c 41 80 00       	mov    0x80415c,%eax
  8007af:	85 c0                	test   %eax,%eax
  8007b1:	74 16                	je     8007c9 <_panic+0x2e>
		cprintf("%s: ", argv0);
  8007b3:	a1 5c 41 80 00       	mov    0x80415c,%eax
  8007b8:	83 ec 08             	sub    $0x8,%esp
  8007bb:	50                   	push   %eax
  8007bc:	68 a8 38 80 00       	push   $0x8038a8
  8007c1:	e8 89 02 00 00       	call   800a4f <cprintf>
  8007c6:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  8007c9:	a1 00 40 80 00       	mov    0x804000,%eax
  8007ce:	ff 75 0c             	pushl  0xc(%ebp)
  8007d1:	ff 75 08             	pushl  0x8(%ebp)
  8007d4:	50                   	push   %eax
  8007d5:	68 ad 38 80 00       	push   $0x8038ad
  8007da:	e8 70 02 00 00       	call   800a4f <cprintf>
  8007df:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  8007e2:	8b 45 10             	mov    0x10(%ebp),%eax
  8007e5:	83 ec 08             	sub    $0x8,%esp
  8007e8:	ff 75 f4             	pushl  -0xc(%ebp)
  8007eb:	50                   	push   %eax
  8007ec:	e8 f3 01 00 00       	call   8009e4 <vcprintf>
  8007f1:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  8007f4:	83 ec 08             	sub    $0x8,%esp
  8007f7:	6a 00                	push   $0x0
  8007f9:	68 c9 38 80 00       	push   $0x8038c9
  8007fe:	e8 e1 01 00 00       	call   8009e4 <vcprintf>
  800803:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  800806:	e8 82 ff ff ff       	call   80078d <exit>

	// should not return here
	while (1) ;
  80080b:	eb fe                	jmp    80080b <_panic+0x70>

0080080d <CheckWSWithoutLastIndex>:
}

void CheckWSWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  80080d:	55                   	push   %ebp
  80080e:	89 e5                	mov    %esp,%ebp
  800810:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  800813:	a1 20 40 80 00       	mov    0x804020,%eax
  800818:	8b 50 74             	mov    0x74(%eax),%edx
  80081b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80081e:	39 c2                	cmp    %eax,%edx
  800820:	74 14                	je     800836 <CheckWSWithoutLastIndex+0x29>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  800822:	83 ec 04             	sub    $0x4,%esp
  800825:	68 cc 38 80 00       	push   $0x8038cc
  80082a:	6a 26                	push   $0x26
  80082c:	68 18 39 80 00       	push   $0x803918
  800831:	e8 65 ff ff ff       	call   80079b <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  800836:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  80083d:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800844:	e9 c2 00 00 00       	jmp    80090b <CheckWSWithoutLastIndex+0xfe>
		if (expectedPages[e] == 0) {
  800849:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80084c:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800853:	8b 45 08             	mov    0x8(%ebp),%eax
  800856:	01 d0                	add    %edx,%eax
  800858:	8b 00                	mov    (%eax),%eax
  80085a:	85 c0                	test   %eax,%eax
  80085c:	75 08                	jne    800866 <CheckWSWithoutLastIndex+0x59>
			expectedNumOfEmptyLocs++;
  80085e:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  800861:	e9 a2 00 00 00       	jmp    800908 <CheckWSWithoutLastIndex+0xfb>
		}
		int found = 0;
  800866:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  80086d:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  800874:	eb 69                	jmp    8008df <CheckWSWithoutLastIndex+0xd2>
			if (myEnv->__uptr_pws[w].empty == 0) {
  800876:	a1 20 40 80 00       	mov    0x804020,%eax
  80087b:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  800881:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800884:	89 d0                	mov    %edx,%eax
  800886:	01 c0                	add    %eax,%eax
  800888:	01 d0                	add    %edx,%eax
  80088a:	c1 e0 03             	shl    $0x3,%eax
  80088d:	01 c8                	add    %ecx,%eax
  80088f:	8a 40 04             	mov    0x4(%eax),%al
  800892:	84 c0                	test   %al,%al
  800894:	75 46                	jne    8008dc <CheckWSWithoutLastIndex+0xcf>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  800896:	a1 20 40 80 00       	mov    0x804020,%eax
  80089b:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  8008a1:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8008a4:	89 d0                	mov    %edx,%eax
  8008a6:	01 c0                	add    %eax,%eax
  8008a8:	01 d0                	add    %edx,%eax
  8008aa:	c1 e0 03             	shl    $0x3,%eax
  8008ad:	01 c8                	add    %ecx,%eax
  8008af:	8b 00                	mov    (%eax),%eax
  8008b1:	89 45 dc             	mov    %eax,-0x24(%ebp)
  8008b4:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8008b7:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8008bc:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  8008be:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8008c1:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  8008c8:	8b 45 08             	mov    0x8(%ebp),%eax
  8008cb:	01 c8                	add    %ecx,%eax
  8008cd:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  8008cf:	39 c2                	cmp    %eax,%edx
  8008d1:	75 09                	jne    8008dc <CheckWSWithoutLastIndex+0xcf>
						== expectedPages[e]) {
					found = 1;
  8008d3:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  8008da:	eb 12                	jmp    8008ee <CheckWSWithoutLastIndex+0xe1>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8008dc:	ff 45 e8             	incl   -0x18(%ebp)
  8008df:	a1 20 40 80 00       	mov    0x804020,%eax
  8008e4:	8b 50 74             	mov    0x74(%eax),%edx
  8008e7:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8008ea:	39 c2                	cmp    %eax,%edx
  8008ec:	77 88                	ja     800876 <CheckWSWithoutLastIndex+0x69>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  8008ee:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8008f2:	75 14                	jne    800908 <CheckWSWithoutLastIndex+0xfb>
			panic(
  8008f4:	83 ec 04             	sub    $0x4,%esp
  8008f7:	68 24 39 80 00       	push   $0x803924
  8008fc:	6a 3a                	push   $0x3a
  8008fe:	68 18 39 80 00       	push   $0x803918
  800903:	e8 93 fe ff ff       	call   80079b <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  800908:	ff 45 f0             	incl   -0x10(%ebp)
  80090b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80090e:	3b 45 0c             	cmp    0xc(%ebp),%eax
  800911:	0f 8c 32 ff ff ff    	jl     800849 <CheckWSWithoutLastIndex+0x3c>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  800917:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  80091e:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  800925:	eb 26                	jmp    80094d <CheckWSWithoutLastIndex+0x140>
		if (myEnv->__uptr_pws[w].empty == 1) {
  800927:	a1 20 40 80 00       	mov    0x804020,%eax
  80092c:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  800932:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800935:	89 d0                	mov    %edx,%eax
  800937:	01 c0                	add    %eax,%eax
  800939:	01 d0                	add    %edx,%eax
  80093b:	c1 e0 03             	shl    $0x3,%eax
  80093e:	01 c8                	add    %ecx,%eax
  800940:	8a 40 04             	mov    0x4(%eax),%al
  800943:	3c 01                	cmp    $0x1,%al
  800945:	75 03                	jne    80094a <CheckWSWithoutLastIndex+0x13d>
			actualNumOfEmptyLocs++;
  800947:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  80094a:	ff 45 e0             	incl   -0x20(%ebp)
  80094d:	a1 20 40 80 00       	mov    0x804020,%eax
  800952:	8b 50 74             	mov    0x74(%eax),%edx
  800955:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800958:	39 c2                	cmp    %eax,%edx
  80095a:	77 cb                	ja     800927 <CheckWSWithoutLastIndex+0x11a>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  80095c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80095f:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  800962:	74 14                	je     800978 <CheckWSWithoutLastIndex+0x16b>
		panic(
  800964:	83 ec 04             	sub    $0x4,%esp
  800967:	68 78 39 80 00       	push   $0x803978
  80096c:	6a 44                	push   $0x44
  80096e:	68 18 39 80 00       	push   $0x803918
  800973:	e8 23 fe ff ff       	call   80079b <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  800978:	90                   	nop
  800979:	c9                   	leave  
  80097a:	c3                   	ret    

0080097b <putch>:
};

//2017:
uint8 printProgName = 0;

static void putch(int ch, struct printbuf *b) {
  80097b:	55                   	push   %ebp
  80097c:	89 e5                	mov    %esp,%ebp
  80097e:	83 ec 08             	sub    $0x8,%esp
	b->buf[b->idx++] = ch;
  800981:	8b 45 0c             	mov    0xc(%ebp),%eax
  800984:	8b 00                	mov    (%eax),%eax
  800986:	8d 48 01             	lea    0x1(%eax),%ecx
  800989:	8b 55 0c             	mov    0xc(%ebp),%edx
  80098c:	89 0a                	mov    %ecx,(%edx)
  80098e:	8b 55 08             	mov    0x8(%ebp),%edx
  800991:	88 d1                	mov    %dl,%cl
  800993:	8b 55 0c             	mov    0xc(%ebp),%edx
  800996:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  80099a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80099d:	8b 00                	mov    (%eax),%eax
  80099f:	3d ff 00 00 00       	cmp    $0xff,%eax
  8009a4:	75 2c                	jne    8009d2 <putch+0x57>
		sys_cputs(b->buf, b->idx, printProgName);
  8009a6:	a0 24 40 80 00       	mov    0x804024,%al
  8009ab:	0f b6 c0             	movzbl %al,%eax
  8009ae:	8b 55 0c             	mov    0xc(%ebp),%edx
  8009b1:	8b 12                	mov    (%edx),%edx
  8009b3:	89 d1                	mov    %edx,%ecx
  8009b5:	8b 55 0c             	mov    0xc(%ebp),%edx
  8009b8:	83 c2 08             	add    $0x8,%edx
  8009bb:	83 ec 04             	sub    $0x4,%esp
  8009be:	50                   	push   %eax
  8009bf:	51                   	push   %ecx
  8009c0:	52                   	push   %edx
  8009c1:	e8 66 13 00 00       	call   801d2c <sys_cputs>
  8009c6:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  8009c9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8009cc:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  8009d2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8009d5:	8b 40 04             	mov    0x4(%eax),%eax
  8009d8:	8d 50 01             	lea    0x1(%eax),%edx
  8009db:	8b 45 0c             	mov    0xc(%ebp),%eax
  8009de:	89 50 04             	mov    %edx,0x4(%eax)
}
  8009e1:	90                   	nop
  8009e2:	c9                   	leave  
  8009e3:	c3                   	ret    

008009e4 <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  8009e4:	55                   	push   %ebp
  8009e5:	89 e5                	mov    %esp,%ebp
  8009e7:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  8009ed:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  8009f4:	00 00 00 
	b.cnt = 0;
  8009f7:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  8009fe:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  800a01:	ff 75 0c             	pushl  0xc(%ebp)
  800a04:	ff 75 08             	pushl  0x8(%ebp)
  800a07:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800a0d:	50                   	push   %eax
  800a0e:	68 7b 09 80 00       	push   $0x80097b
  800a13:	e8 11 02 00 00       	call   800c29 <vprintfmt>
  800a18:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName);
  800a1b:	a0 24 40 80 00       	mov    0x804024,%al
  800a20:	0f b6 c0             	movzbl %al,%eax
  800a23:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  800a29:	83 ec 04             	sub    $0x4,%esp
  800a2c:	50                   	push   %eax
  800a2d:	52                   	push   %edx
  800a2e:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800a34:	83 c0 08             	add    $0x8,%eax
  800a37:	50                   	push   %eax
  800a38:	e8 ef 12 00 00       	call   801d2c <sys_cputs>
  800a3d:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  800a40:	c6 05 24 40 80 00 00 	movb   $0x0,0x804024
	return b.cnt;
  800a47:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  800a4d:	c9                   	leave  
  800a4e:	c3                   	ret    

00800a4f <cprintf>:

int cprintf(const char *fmt, ...) {
  800a4f:	55                   	push   %ebp
  800a50:	89 e5                	mov    %esp,%ebp
  800a52:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  800a55:	c6 05 24 40 80 00 01 	movb   $0x1,0x804024
	va_start(ap, fmt);
  800a5c:	8d 45 0c             	lea    0xc(%ebp),%eax
  800a5f:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800a62:	8b 45 08             	mov    0x8(%ebp),%eax
  800a65:	83 ec 08             	sub    $0x8,%esp
  800a68:	ff 75 f4             	pushl  -0xc(%ebp)
  800a6b:	50                   	push   %eax
  800a6c:	e8 73 ff ff ff       	call   8009e4 <vcprintf>
  800a71:	83 c4 10             	add    $0x10,%esp
  800a74:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  800a77:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800a7a:	c9                   	leave  
  800a7b:	c3                   	ret    

00800a7c <atomic_cprintf>:

int atomic_cprintf(const char *fmt, ...) {
  800a7c:	55                   	push   %ebp
  800a7d:	89 e5                	mov    %esp,%ebp
  800a7f:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  800a82:	e8 53 14 00 00       	call   801eda <sys_disable_interrupt>
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  800a87:	8d 45 0c             	lea    0xc(%ebp),%eax
  800a8a:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800a8d:	8b 45 08             	mov    0x8(%ebp),%eax
  800a90:	83 ec 08             	sub    $0x8,%esp
  800a93:	ff 75 f4             	pushl  -0xc(%ebp)
  800a96:	50                   	push   %eax
  800a97:	e8 48 ff ff ff       	call   8009e4 <vcprintf>
  800a9c:	83 c4 10             	add    $0x10,%esp
  800a9f:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	sys_enable_interrupt();
  800aa2:	e8 4d 14 00 00       	call   801ef4 <sys_enable_interrupt>
	return cnt;
  800aa7:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800aaa:	c9                   	leave  
  800aab:	c3                   	ret    

00800aac <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800aac:	55                   	push   %ebp
  800aad:	89 e5                	mov    %esp,%ebp
  800aaf:	53                   	push   %ebx
  800ab0:	83 ec 14             	sub    $0x14,%esp
  800ab3:	8b 45 10             	mov    0x10(%ebp),%eax
  800ab6:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800ab9:	8b 45 14             	mov    0x14(%ebp),%eax
  800abc:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800abf:	8b 45 18             	mov    0x18(%ebp),%eax
  800ac2:	ba 00 00 00 00       	mov    $0x0,%edx
  800ac7:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800aca:	77 55                	ja     800b21 <printnum+0x75>
  800acc:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800acf:	72 05                	jb     800ad6 <printnum+0x2a>
  800ad1:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800ad4:	77 4b                	ja     800b21 <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800ad6:	8b 45 1c             	mov    0x1c(%ebp),%eax
  800ad9:	8d 58 ff             	lea    -0x1(%eax),%ebx
  800adc:	8b 45 18             	mov    0x18(%ebp),%eax
  800adf:	ba 00 00 00 00       	mov    $0x0,%edx
  800ae4:	52                   	push   %edx
  800ae5:	50                   	push   %eax
  800ae6:	ff 75 f4             	pushl  -0xc(%ebp)
  800ae9:	ff 75 f0             	pushl  -0x10(%ebp)
  800aec:	e8 87 28 00 00       	call   803378 <__udivdi3>
  800af1:	83 c4 10             	add    $0x10,%esp
  800af4:	83 ec 04             	sub    $0x4,%esp
  800af7:	ff 75 20             	pushl  0x20(%ebp)
  800afa:	53                   	push   %ebx
  800afb:	ff 75 18             	pushl  0x18(%ebp)
  800afe:	52                   	push   %edx
  800aff:	50                   	push   %eax
  800b00:	ff 75 0c             	pushl  0xc(%ebp)
  800b03:	ff 75 08             	pushl  0x8(%ebp)
  800b06:	e8 a1 ff ff ff       	call   800aac <printnum>
  800b0b:	83 c4 20             	add    $0x20,%esp
  800b0e:	eb 1a                	jmp    800b2a <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800b10:	83 ec 08             	sub    $0x8,%esp
  800b13:	ff 75 0c             	pushl  0xc(%ebp)
  800b16:	ff 75 20             	pushl  0x20(%ebp)
  800b19:	8b 45 08             	mov    0x8(%ebp),%eax
  800b1c:	ff d0                	call   *%eax
  800b1e:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800b21:	ff 4d 1c             	decl   0x1c(%ebp)
  800b24:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  800b28:	7f e6                	jg     800b10 <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800b2a:	8b 4d 18             	mov    0x18(%ebp),%ecx
  800b2d:	bb 00 00 00 00       	mov    $0x0,%ebx
  800b32:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800b35:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800b38:	53                   	push   %ebx
  800b39:	51                   	push   %ecx
  800b3a:	52                   	push   %edx
  800b3b:	50                   	push   %eax
  800b3c:	e8 47 29 00 00       	call   803488 <__umoddi3>
  800b41:	83 c4 10             	add    $0x10,%esp
  800b44:	05 f4 3b 80 00       	add    $0x803bf4,%eax
  800b49:	8a 00                	mov    (%eax),%al
  800b4b:	0f be c0             	movsbl %al,%eax
  800b4e:	83 ec 08             	sub    $0x8,%esp
  800b51:	ff 75 0c             	pushl  0xc(%ebp)
  800b54:	50                   	push   %eax
  800b55:	8b 45 08             	mov    0x8(%ebp),%eax
  800b58:	ff d0                	call   *%eax
  800b5a:	83 c4 10             	add    $0x10,%esp
}
  800b5d:	90                   	nop
  800b5e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800b61:	c9                   	leave  
  800b62:	c3                   	ret    

00800b63 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  800b63:	55                   	push   %ebp
  800b64:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800b66:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800b6a:	7e 1c                	jle    800b88 <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  800b6c:	8b 45 08             	mov    0x8(%ebp),%eax
  800b6f:	8b 00                	mov    (%eax),%eax
  800b71:	8d 50 08             	lea    0x8(%eax),%edx
  800b74:	8b 45 08             	mov    0x8(%ebp),%eax
  800b77:	89 10                	mov    %edx,(%eax)
  800b79:	8b 45 08             	mov    0x8(%ebp),%eax
  800b7c:	8b 00                	mov    (%eax),%eax
  800b7e:	83 e8 08             	sub    $0x8,%eax
  800b81:	8b 50 04             	mov    0x4(%eax),%edx
  800b84:	8b 00                	mov    (%eax),%eax
  800b86:	eb 40                	jmp    800bc8 <getuint+0x65>
	else if (lflag)
  800b88:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800b8c:	74 1e                	je     800bac <getuint+0x49>
		return va_arg(*ap, unsigned long);
  800b8e:	8b 45 08             	mov    0x8(%ebp),%eax
  800b91:	8b 00                	mov    (%eax),%eax
  800b93:	8d 50 04             	lea    0x4(%eax),%edx
  800b96:	8b 45 08             	mov    0x8(%ebp),%eax
  800b99:	89 10                	mov    %edx,(%eax)
  800b9b:	8b 45 08             	mov    0x8(%ebp),%eax
  800b9e:	8b 00                	mov    (%eax),%eax
  800ba0:	83 e8 04             	sub    $0x4,%eax
  800ba3:	8b 00                	mov    (%eax),%eax
  800ba5:	ba 00 00 00 00       	mov    $0x0,%edx
  800baa:	eb 1c                	jmp    800bc8 <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  800bac:	8b 45 08             	mov    0x8(%ebp),%eax
  800baf:	8b 00                	mov    (%eax),%eax
  800bb1:	8d 50 04             	lea    0x4(%eax),%edx
  800bb4:	8b 45 08             	mov    0x8(%ebp),%eax
  800bb7:	89 10                	mov    %edx,(%eax)
  800bb9:	8b 45 08             	mov    0x8(%ebp),%eax
  800bbc:	8b 00                	mov    (%eax),%eax
  800bbe:	83 e8 04             	sub    $0x4,%eax
  800bc1:	8b 00                	mov    (%eax),%eax
  800bc3:	ba 00 00 00 00       	mov    $0x0,%edx
}
  800bc8:	5d                   	pop    %ebp
  800bc9:	c3                   	ret    

00800bca <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  800bca:	55                   	push   %ebp
  800bcb:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800bcd:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800bd1:	7e 1c                	jle    800bef <getint+0x25>
		return va_arg(*ap, long long);
  800bd3:	8b 45 08             	mov    0x8(%ebp),%eax
  800bd6:	8b 00                	mov    (%eax),%eax
  800bd8:	8d 50 08             	lea    0x8(%eax),%edx
  800bdb:	8b 45 08             	mov    0x8(%ebp),%eax
  800bde:	89 10                	mov    %edx,(%eax)
  800be0:	8b 45 08             	mov    0x8(%ebp),%eax
  800be3:	8b 00                	mov    (%eax),%eax
  800be5:	83 e8 08             	sub    $0x8,%eax
  800be8:	8b 50 04             	mov    0x4(%eax),%edx
  800beb:	8b 00                	mov    (%eax),%eax
  800bed:	eb 38                	jmp    800c27 <getint+0x5d>
	else if (lflag)
  800bef:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800bf3:	74 1a                	je     800c0f <getint+0x45>
		return va_arg(*ap, long);
  800bf5:	8b 45 08             	mov    0x8(%ebp),%eax
  800bf8:	8b 00                	mov    (%eax),%eax
  800bfa:	8d 50 04             	lea    0x4(%eax),%edx
  800bfd:	8b 45 08             	mov    0x8(%ebp),%eax
  800c00:	89 10                	mov    %edx,(%eax)
  800c02:	8b 45 08             	mov    0x8(%ebp),%eax
  800c05:	8b 00                	mov    (%eax),%eax
  800c07:	83 e8 04             	sub    $0x4,%eax
  800c0a:	8b 00                	mov    (%eax),%eax
  800c0c:	99                   	cltd   
  800c0d:	eb 18                	jmp    800c27 <getint+0x5d>
	else
		return va_arg(*ap, int);
  800c0f:	8b 45 08             	mov    0x8(%ebp),%eax
  800c12:	8b 00                	mov    (%eax),%eax
  800c14:	8d 50 04             	lea    0x4(%eax),%edx
  800c17:	8b 45 08             	mov    0x8(%ebp),%eax
  800c1a:	89 10                	mov    %edx,(%eax)
  800c1c:	8b 45 08             	mov    0x8(%ebp),%eax
  800c1f:	8b 00                	mov    (%eax),%eax
  800c21:	83 e8 04             	sub    $0x4,%eax
  800c24:	8b 00                	mov    (%eax),%eax
  800c26:	99                   	cltd   
}
  800c27:	5d                   	pop    %ebp
  800c28:	c3                   	ret    

00800c29 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  800c29:	55                   	push   %ebp
  800c2a:	89 e5                	mov    %esp,%ebp
  800c2c:	56                   	push   %esi
  800c2d:	53                   	push   %ebx
  800c2e:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800c31:	eb 17                	jmp    800c4a <vprintfmt+0x21>
			if (ch == '\0')
  800c33:	85 db                	test   %ebx,%ebx
  800c35:	0f 84 af 03 00 00    	je     800fea <vprintfmt+0x3c1>
				return;
			putch(ch, putdat);
  800c3b:	83 ec 08             	sub    $0x8,%esp
  800c3e:	ff 75 0c             	pushl  0xc(%ebp)
  800c41:	53                   	push   %ebx
  800c42:	8b 45 08             	mov    0x8(%ebp),%eax
  800c45:	ff d0                	call   *%eax
  800c47:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800c4a:	8b 45 10             	mov    0x10(%ebp),%eax
  800c4d:	8d 50 01             	lea    0x1(%eax),%edx
  800c50:	89 55 10             	mov    %edx,0x10(%ebp)
  800c53:	8a 00                	mov    (%eax),%al
  800c55:	0f b6 d8             	movzbl %al,%ebx
  800c58:	83 fb 25             	cmp    $0x25,%ebx
  800c5b:	75 d6                	jne    800c33 <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  800c5d:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  800c61:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  800c68:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  800c6f:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  800c76:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800c7d:	8b 45 10             	mov    0x10(%ebp),%eax
  800c80:	8d 50 01             	lea    0x1(%eax),%edx
  800c83:	89 55 10             	mov    %edx,0x10(%ebp)
  800c86:	8a 00                	mov    (%eax),%al
  800c88:	0f b6 d8             	movzbl %al,%ebx
  800c8b:	8d 43 dd             	lea    -0x23(%ebx),%eax
  800c8e:	83 f8 55             	cmp    $0x55,%eax
  800c91:	0f 87 2b 03 00 00    	ja     800fc2 <vprintfmt+0x399>
  800c97:	8b 04 85 18 3c 80 00 	mov    0x803c18(,%eax,4),%eax
  800c9e:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  800ca0:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  800ca4:	eb d7                	jmp    800c7d <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800ca6:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  800caa:	eb d1                	jmp    800c7d <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800cac:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  800cb3:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800cb6:	89 d0                	mov    %edx,%eax
  800cb8:	c1 e0 02             	shl    $0x2,%eax
  800cbb:	01 d0                	add    %edx,%eax
  800cbd:	01 c0                	add    %eax,%eax
  800cbf:	01 d8                	add    %ebx,%eax
  800cc1:	83 e8 30             	sub    $0x30,%eax
  800cc4:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  800cc7:	8b 45 10             	mov    0x10(%ebp),%eax
  800cca:	8a 00                	mov    (%eax),%al
  800ccc:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  800ccf:	83 fb 2f             	cmp    $0x2f,%ebx
  800cd2:	7e 3e                	jle    800d12 <vprintfmt+0xe9>
  800cd4:	83 fb 39             	cmp    $0x39,%ebx
  800cd7:	7f 39                	jg     800d12 <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800cd9:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800cdc:	eb d5                	jmp    800cb3 <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  800cde:	8b 45 14             	mov    0x14(%ebp),%eax
  800ce1:	83 c0 04             	add    $0x4,%eax
  800ce4:	89 45 14             	mov    %eax,0x14(%ebp)
  800ce7:	8b 45 14             	mov    0x14(%ebp),%eax
  800cea:	83 e8 04             	sub    $0x4,%eax
  800ced:	8b 00                	mov    (%eax),%eax
  800cef:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  800cf2:	eb 1f                	jmp    800d13 <vprintfmt+0xea>

		case '.':
			if (width < 0)
  800cf4:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800cf8:	79 83                	jns    800c7d <vprintfmt+0x54>
				width = 0;
  800cfa:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  800d01:	e9 77 ff ff ff       	jmp    800c7d <vprintfmt+0x54>

		case '#':
			altflag = 1;
  800d06:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  800d0d:	e9 6b ff ff ff       	jmp    800c7d <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  800d12:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  800d13:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800d17:	0f 89 60 ff ff ff    	jns    800c7d <vprintfmt+0x54>
				width = precision, precision = -1;
  800d1d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800d20:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800d23:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  800d2a:	e9 4e ff ff ff       	jmp    800c7d <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  800d2f:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  800d32:	e9 46 ff ff ff       	jmp    800c7d <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  800d37:	8b 45 14             	mov    0x14(%ebp),%eax
  800d3a:	83 c0 04             	add    $0x4,%eax
  800d3d:	89 45 14             	mov    %eax,0x14(%ebp)
  800d40:	8b 45 14             	mov    0x14(%ebp),%eax
  800d43:	83 e8 04             	sub    $0x4,%eax
  800d46:	8b 00                	mov    (%eax),%eax
  800d48:	83 ec 08             	sub    $0x8,%esp
  800d4b:	ff 75 0c             	pushl  0xc(%ebp)
  800d4e:	50                   	push   %eax
  800d4f:	8b 45 08             	mov    0x8(%ebp),%eax
  800d52:	ff d0                	call   *%eax
  800d54:	83 c4 10             	add    $0x10,%esp
			break;
  800d57:	e9 89 02 00 00       	jmp    800fe5 <vprintfmt+0x3bc>

		// error message
		case 'e':
			err = va_arg(ap, int);
  800d5c:	8b 45 14             	mov    0x14(%ebp),%eax
  800d5f:	83 c0 04             	add    $0x4,%eax
  800d62:	89 45 14             	mov    %eax,0x14(%ebp)
  800d65:	8b 45 14             	mov    0x14(%ebp),%eax
  800d68:	83 e8 04             	sub    $0x4,%eax
  800d6b:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  800d6d:	85 db                	test   %ebx,%ebx
  800d6f:	79 02                	jns    800d73 <vprintfmt+0x14a>
				err = -err;
  800d71:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  800d73:	83 fb 64             	cmp    $0x64,%ebx
  800d76:	7f 0b                	jg     800d83 <vprintfmt+0x15a>
  800d78:	8b 34 9d 60 3a 80 00 	mov    0x803a60(,%ebx,4),%esi
  800d7f:	85 f6                	test   %esi,%esi
  800d81:	75 19                	jne    800d9c <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  800d83:	53                   	push   %ebx
  800d84:	68 05 3c 80 00       	push   $0x803c05
  800d89:	ff 75 0c             	pushl  0xc(%ebp)
  800d8c:	ff 75 08             	pushl  0x8(%ebp)
  800d8f:	e8 5e 02 00 00       	call   800ff2 <printfmt>
  800d94:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800d97:	e9 49 02 00 00       	jmp    800fe5 <vprintfmt+0x3bc>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800d9c:	56                   	push   %esi
  800d9d:	68 0e 3c 80 00       	push   $0x803c0e
  800da2:	ff 75 0c             	pushl  0xc(%ebp)
  800da5:	ff 75 08             	pushl  0x8(%ebp)
  800da8:	e8 45 02 00 00       	call   800ff2 <printfmt>
  800dad:	83 c4 10             	add    $0x10,%esp
			break;
  800db0:	e9 30 02 00 00       	jmp    800fe5 <vprintfmt+0x3bc>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  800db5:	8b 45 14             	mov    0x14(%ebp),%eax
  800db8:	83 c0 04             	add    $0x4,%eax
  800dbb:	89 45 14             	mov    %eax,0x14(%ebp)
  800dbe:	8b 45 14             	mov    0x14(%ebp),%eax
  800dc1:	83 e8 04             	sub    $0x4,%eax
  800dc4:	8b 30                	mov    (%eax),%esi
  800dc6:	85 f6                	test   %esi,%esi
  800dc8:	75 05                	jne    800dcf <vprintfmt+0x1a6>
				p = "(null)";
  800dca:	be 11 3c 80 00       	mov    $0x803c11,%esi
			if (width > 0 && padc != '-')
  800dcf:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800dd3:	7e 6d                	jle    800e42 <vprintfmt+0x219>
  800dd5:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  800dd9:	74 67                	je     800e42 <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  800ddb:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800dde:	83 ec 08             	sub    $0x8,%esp
  800de1:	50                   	push   %eax
  800de2:	56                   	push   %esi
  800de3:	e8 0c 03 00 00       	call   8010f4 <strnlen>
  800de8:	83 c4 10             	add    $0x10,%esp
  800deb:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  800dee:	eb 16                	jmp    800e06 <vprintfmt+0x1dd>
					putch(padc, putdat);
  800df0:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  800df4:	83 ec 08             	sub    $0x8,%esp
  800df7:	ff 75 0c             	pushl  0xc(%ebp)
  800dfa:	50                   	push   %eax
  800dfb:	8b 45 08             	mov    0x8(%ebp),%eax
  800dfe:	ff d0                	call   *%eax
  800e00:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800e03:	ff 4d e4             	decl   -0x1c(%ebp)
  800e06:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800e0a:	7f e4                	jg     800df0 <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800e0c:	eb 34                	jmp    800e42 <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  800e0e:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800e12:	74 1c                	je     800e30 <vprintfmt+0x207>
  800e14:	83 fb 1f             	cmp    $0x1f,%ebx
  800e17:	7e 05                	jle    800e1e <vprintfmt+0x1f5>
  800e19:	83 fb 7e             	cmp    $0x7e,%ebx
  800e1c:	7e 12                	jle    800e30 <vprintfmt+0x207>
					putch('?', putdat);
  800e1e:	83 ec 08             	sub    $0x8,%esp
  800e21:	ff 75 0c             	pushl  0xc(%ebp)
  800e24:	6a 3f                	push   $0x3f
  800e26:	8b 45 08             	mov    0x8(%ebp),%eax
  800e29:	ff d0                	call   *%eax
  800e2b:	83 c4 10             	add    $0x10,%esp
  800e2e:	eb 0f                	jmp    800e3f <vprintfmt+0x216>
				else
					putch(ch, putdat);
  800e30:	83 ec 08             	sub    $0x8,%esp
  800e33:	ff 75 0c             	pushl  0xc(%ebp)
  800e36:	53                   	push   %ebx
  800e37:	8b 45 08             	mov    0x8(%ebp),%eax
  800e3a:	ff d0                	call   *%eax
  800e3c:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800e3f:	ff 4d e4             	decl   -0x1c(%ebp)
  800e42:	89 f0                	mov    %esi,%eax
  800e44:	8d 70 01             	lea    0x1(%eax),%esi
  800e47:	8a 00                	mov    (%eax),%al
  800e49:	0f be d8             	movsbl %al,%ebx
  800e4c:	85 db                	test   %ebx,%ebx
  800e4e:	74 24                	je     800e74 <vprintfmt+0x24b>
  800e50:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800e54:	78 b8                	js     800e0e <vprintfmt+0x1e5>
  800e56:	ff 4d e0             	decl   -0x20(%ebp)
  800e59:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800e5d:	79 af                	jns    800e0e <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800e5f:	eb 13                	jmp    800e74 <vprintfmt+0x24b>
				putch(' ', putdat);
  800e61:	83 ec 08             	sub    $0x8,%esp
  800e64:	ff 75 0c             	pushl  0xc(%ebp)
  800e67:	6a 20                	push   $0x20
  800e69:	8b 45 08             	mov    0x8(%ebp),%eax
  800e6c:	ff d0                	call   *%eax
  800e6e:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800e71:	ff 4d e4             	decl   -0x1c(%ebp)
  800e74:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800e78:	7f e7                	jg     800e61 <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  800e7a:	e9 66 01 00 00       	jmp    800fe5 <vprintfmt+0x3bc>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  800e7f:	83 ec 08             	sub    $0x8,%esp
  800e82:	ff 75 e8             	pushl  -0x18(%ebp)
  800e85:	8d 45 14             	lea    0x14(%ebp),%eax
  800e88:	50                   	push   %eax
  800e89:	e8 3c fd ff ff       	call   800bca <getint>
  800e8e:	83 c4 10             	add    $0x10,%esp
  800e91:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800e94:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  800e97:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800e9a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800e9d:	85 d2                	test   %edx,%edx
  800e9f:	79 23                	jns    800ec4 <vprintfmt+0x29b>
				putch('-', putdat);
  800ea1:	83 ec 08             	sub    $0x8,%esp
  800ea4:	ff 75 0c             	pushl  0xc(%ebp)
  800ea7:	6a 2d                	push   $0x2d
  800ea9:	8b 45 08             	mov    0x8(%ebp),%eax
  800eac:	ff d0                	call   *%eax
  800eae:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  800eb1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800eb4:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800eb7:	f7 d8                	neg    %eax
  800eb9:	83 d2 00             	adc    $0x0,%edx
  800ebc:	f7 da                	neg    %edx
  800ebe:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800ec1:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  800ec4:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800ecb:	e9 bc 00 00 00       	jmp    800f8c <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  800ed0:	83 ec 08             	sub    $0x8,%esp
  800ed3:	ff 75 e8             	pushl  -0x18(%ebp)
  800ed6:	8d 45 14             	lea    0x14(%ebp),%eax
  800ed9:	50                   	push   %eax
  800eda:	e8 84 fc ff ff       	call   800b63 <getuint>
  800edf:	83 c4 10             	add    $0x10,%esp
  800ee2:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800ee5:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  800ee8:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800eef:	e9 98 00 00 00       	jmp    800f8c <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  800ef4:	83 ec 08             	sub    $0x8,%esp
  800ef7:	ff 75 0c             	pushl  0xc(%ebp)
  800efa:	6a 58                	push   $0x58
  800efc:	8b 45 08             	mov    0x8(%ebp),%eax
  800eff:	ff d0                	call   *%eax
  800f01:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800f04:	83 ec 08             	sub    $0x8,%esp
  800f07:	ff 75 0c             	pushl  0xc(%ebp)
  800f0a:	6a 58                	push   $0x58
  800f0c:	8b 45 08             	mov    0x8(%ebp),%eax
  800f0f:	ff d0                	call   *%eax
  800f11:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800f14:	83 ec 08             	sub    $0x8,%esp
  800f17:	ff 75 0c             	pushl  0xc(%ebp)
  800f1a:	6a 58                	push   $0x58
  800f1c:	8b 45 08             	mov    0x8(%ebp),%eax
  800f1f:	ff d0                	call   *%eax
  800f21:	83 c4 10             	add    $0x10,%esp
			break;
  800f24:	e9 bc 00 00 00       	jmp    800fe5 <vprintfmt+0x3bc>

		// pointer
		case 'p':
			putch('0', putdat);
  800f29:	83 ec 08             	sub    $0x8,%esp
  800f2c:	ff 75 0c             	pushl  0xc(%ebp)
  800f2f:	6a 30                	push   $0x30
  800f31:	8b 45 08             	mov    0x8(%ebp),%eax
  800f34:	ff d0                	call   *%eax
  800f36:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  800f39:	83 ec 08             	sub    $0x8,%esp
  800f3c:	ff 75 0c             	pushl  0xc(%ebp)
  800f3f:	6a 78                	push   $0x78
  800f41:	8b 45 08             	mov    0x8(%ebp),%eax
  800f44:	ff d0                	call   *%eax
  800f46:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  800f49:	8b 45 14             	mov    0x14(%ebp),%eax
  800f4c:	83 c0 04             	add    $0x4,%eax
  800f4f:	89 45 14             	mov    %eax,0x14(%ebp)
  800f52:	8b 45 14             	mov    0x14(%ebp),%eax
  800f55:	83 e8 04             	sub    $0x4,%eax
  800f58:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800f5a:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800f5d:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  800f64:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  800f6b:	eb 1f                	jmp    800f8c <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800f6d:	83 ec 08             	sub    $0x8,%esp
  800f70:	ff 75 e8             	pushl  -0x18(%ebp)
  800f73:	8d 45 14             	lea    0x14(%ebp),%eax
  800f76:	50                   	push   %eax
  800f77:	e8 e7 fb ff ff       	call   800b63 <getuint>
  800f7c:	83 c4 10             	add    $0x10,%esp
  800f7f:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800f82:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  800f85:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800f8c:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  800f90:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800f93:	83 ec 04             	sub    $0x4,%esp
  800f96:	52                   	push   %edx
  800f97:	ff 75 e4             	pushl  -0x1c(%ebp)
  800f9a:	50                   	push   %eax
  800f9b:	ff 75 f4             	pushl  -0xc(%ebp)
  800f9e:	ff 75 f0             	pushl  -0x10(%ebp)
  800fa1:	ff 75 0c             	pushl  0xc(%ebp)
  800fa4:	ff 75 08             	pushl  0x8(%ebp)
  800fa7:	e8 00 fb ff ff       	call   800aac <printnum>
  800fac:	83 c4 20             	add    $0x20,%esp
			break;
  800faf:	eb 34                	jmp    800fe5 <vprintfmt+0x3bc>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  800fb1:	83 ec 08             	sub    $0x8,%esp
  800fb4:	ff 75 0c             	pushl  0xc(%ebp)
  800fb7:	53                   	push   %ebx
  800fb8:	8b 45 08             	mov    0x8(%ebp),%eax
  800fbb:	ff d0                	call   *%eax
  800fbd:	83 c4 10             	add    $0x10,%esp
			break;
  800fc0:	eb 23                	jmp    800fe5 <vprintfmt+0x3bc>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800fc2:	83 ec 08             	sub    $0x8,%esp
  800fc5:	ff 75 0c             	pushl  0xc(%ebp)
  800fc8:	6a 25                	push   $0x25
  800fca:	8b 45 08             	mov    0x8(%ebp),%eax
  800fcd:	ff d0                	call   *%eax
  800fcf:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  800fd2:	ff 4d 10             	decl   0x10(%ebp)
  800fd5:	eb 03                	jmp    800fda <vprintfmt+0x3b1>
  800fd7:	ff 4d 10             	decl   0x10(%ebp)
  800fda:	8b 45 10             	mov    0x10(%ebp),%eax
  800fdd:	48                   	dec    %eax
  800fde:	8a 00                	mov    (%eax),%al
  800fe0:	3c 25                	cmp    $0x25,%al
  800fe2:	75 f3                	jne    800fd7 <vprintfmt+0x3ae>
				/* do nothing */;
			break;
  800fe4:	90                   	nop
		}
	}
  800fe5:	e9 47 fc ff ff       	jmp    800c31 <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  800fea:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  800feb:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800fee:	5b                   	pop    %ebx
  800fef:	5e                   	pop    %esi
  800ff0:	5d                   	pop    %ebp
  800ff1:	c3                   	ret    

00800ff2 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800ff2:	55                   	push   %ebp
  800ff3:	89 e5                	mov    %esp,%ebp
  800ff5:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  800ff8:	8d 45 10             	lea    0x10(%ebp),%eax
  800ffb:	83 c0 04             	add    $0x4,%eax
  800ffe:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  801001:	8b 45 10             	mov    0x10(%ebp),%eax
  801004:	ff 75 f4             	pushl  -0xc(%ebp)
  801007:	50                   	push   %eax
  801008:	ff 75 0c             	pushl  0xc(%ebp)
  80100b:	ff 75 08             	pushl  0x8(%ebp)
  80100e:	e8 16 fc ff ff       	call   800c29 <vprintfmt>
  801013:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  801016:	90                   	nop
  801017:	c9                   	leave  
  801018:	c3                   	ret    

00801019 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  801019:	55                   	push   %ebp
  80101a:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  80101c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80101f:	8b 40 08             	mov    0x8(%eax),%eax
  801022:	8d 50 01             	lea    0x1(%eax),%edx
  801025:	8b 45 0c             	mov    0xc(%ebp),%eax
  801028:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  80102b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80102e:	8b 10                	mov    (%eax),%edx
  801030:	8b 45 0c             	mov    0xc(%ebp),%eax
  801033:	8b 40 04             	mov    0x4(%eax),%eax
  801036:	39 c2                	cmp    %eax,%edx
  801038:	73 12                	jae    80104c <sprintputch+0x33>
		*b->buf++ = ch;
  80103a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80103d:	8b 00                	mov    (%eax),%eax
  80103f:	8d 48 01             	lea    0x1(%eax),%ecx
  801042:	8b 55 0c             	mov    0xc(%ebp),%edx
  801045:	89 0a                	mov    %ecx,(%edx)
  801047:	8b 55 08             	mov    0x8(%ebp),%edx
  80104a:	88 10                	mov    %dl,(%eax)
}
  80104c:	90                   	nop
  80104d:	5d                   	pop    %ebp
  80104e:	c3                   	ret    

0080104f <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  80104f:	55                   	push   %ebp
  801050:	89 e5                	mov    %esp,%ebp
  801052:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  801055:	8b 45 08             	mov    0x8(%ebp),%eax
  801058:	89 45 ec             	mov    %eax,-0x14(%ebp)
  80105b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80105e:	8d 50 ff             	lea    -0x1(%eax),%edx
  801061:	8b 45 08             	mov    0x8(%ebp),%eax
  801064:	01 d0                	add    %edx,%eax
  801066:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801069:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  801070:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801074:	74 06                	je     80107c <vsnprintf+0x2d>
  801076:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80107a:	7f 07                	jg     801083 <vsnprintf+0x34>
		return -E_INVAL;
  80107c:	b8 03 00 00 00       	mov    $0x3,%eax
  801081:	eb 20                	jmp    8010a3 <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  801083:	ff 75 14             	pushl  0x14(%ebp)
  801086:	ff 75 10             	pushl  0x10(%ebp)
  801089:	8d 45 ec             	lea    -0x14(%ebp),%eax
  80108c:	50                   	push   %eax
  80108d:	68 19 10 80 00       	push   $0x801019
  801092:	e8 92 fb ff ff       	call   800c29 <vprintfmt>
  801097:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  80109a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80109d:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  8010a0:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  8010a3:	c9                   	leave  
  8010a4:	c3                   	ret    

008010a5 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  8010a5:	55                   	push   %ebp
  8010a6:	89 e5                	mov    %esp,%ebp
  8010a8:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  8010ab:	8d 45 10             	lea    0x10(%ebp),%eax
  8010ae:	83 c0 04             	add    $0x4,%eax
  8010b1:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  8010b4:	8b 45 10             	mov    0x10(%ebp),%eax
  8010b7:	ff 75 f4             	pushl  -0xc(%ebp)
  8010ba:	50                   	push   %eax
  8010bb:	ff 75 0c             	pushl  0xc(%ebp)
  8010be:	ff 75 08             	pushl  0x8(%ebp)
  8010c1:	e8 89 ff ff ff       	call   80104f <vsnprintf>
  8010c6:	83 c4 10             	add    $0x10,%esp
  8010c9:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  8010cc:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8010cf:	c9                   	leave  
  8010d0:	c3                   	ret    

008010d1 <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  8010d1:	55                   	push   %ebp
  8010d2:	89 e5                	mov    %esp,%ebp
  8010d4:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  8010d7:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8010de:	eb 06                	jmp    8010e6 <strlen+0x15>
		n++;
  8010e0:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  8010e3:	ff 45 08             	incl   0x8(%ebp)
  8010e6:	8b 45 08             	mov    0x8(%ebp),%eax
  8010e9:	8a 00                	mov    (%eax),%al
  8010eb:	84 c0                	test   %al,%al
  8010ed:	75 f1                	jne    8010e0 <strlen+0xf>
		n++;
	return n;
  8010ef:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  8010f2:	c9                   	leave  
  8010f3:	c3                   	ret    

008010f4 <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  8010f4:	55                   	push   %ebp
  8010f5:	89 e5                	mov    %esp,%ebp
  8010f7:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8010fa:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801101:	eb 09                	jmp    80110c <strnlen+0x18>
		n++;
  801103:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  801106:	ff 45 08             	incl   0x8(%ebp)
  801109:	ff 4d 0c             	decl   0xc(%ebp)
  80110c:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801110:	74 09                	je     80111b <strnlen+0x27>
  801112:	8b 45 08             	mov    0x8(%ebp),%eax
  801115:	8a 00                	mov    (%eax),%al
  801117:	84 c0                	test   %al,%al
  801119:	75 e8                	jne    801103 <strnlen+0xf>
		n++;
	return n;
  80111b:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  80111e:	c9                   	leave  
  80111f:	c3                   	ret    

00801120 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  801120:	55                   	push   %ebp
  801121:	89 e5                	mov    %esp,%ebp
  801123:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  801126:	8b 45 08             	mov    0x8(%ebp),%eax
  801129:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  80112c:	90                   	nop
  80112d:	8b 45 08             	mov    0x8(%ebp),%eax
  801130:	8d 50 01             	lea    0x1(%eax),%edx
  801133:	89 55 08             	mov    %edx,0x8(%ebp)
  801136:	8b 55 0c             	mov    0xc(%ebp),%edx
  801139:	8d 4a 01             	lea    0x1(%edx),%ecx
  80113c:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  80113f:	8a 12                	mov    (%edx),%dl
  801141:	88 10                	mov    %dl,(%eax)
  801143:	8a 00                	mov    (%eax),%al
  801145:	84 c0                	test   %al,%al
  801147:	75 e4                	jne    80112d <strcpy+0xd>
		/* do nothing */;
	return ret;
  801149:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  80114c:	c9                   	leave  
  80114d:	c3                   	ret    

0080114e <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  80114e:	55                   	push   %ebp
  80114f:	89 e5                	mov    %esp,%ebp
  801151:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  801154:	8b 45 08             	mov    0x8(%ebp),%eax
  801157:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  80115a:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801161:	eb 1f                	jmp    801182 <strncpy+0x34>
		*dst++ = *src;
  801163:	8b 45 08             	mov    0x8(%ebp),%eax
  801166:	8d 50 01             	lea    0x1(%eax),%edx
  801169:	89 55 08             	mov    %edx,0x8(%ebp)
  80116c:	8b 55 0c             	mov    0xc(%ebp),%edx
  80116f:	8a 12                	mov    (%edx),%dl
  801171:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  801173:	8b 45 0c             	mov    0xc(%ebp),%eax
  801176:	8a 00                	mov    (%eax),%al
  801178:	84 c0                	test   %al,%al
  80117a:	74 03                	je     80117f <strncpy+0x31>
			src++;
  80117c:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  80117f:	ff 45 fc             	incl   -0x4(%ebp)
  801182:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801185:	3b 45 10             	cmp    0x10(%ebp),%eax
  801188:	72 d9                	jb     801163 <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  80118a:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  80118d:	c9                   	leave  
  80118e:	c3                   	ret    

0080118f <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  80118f:	55                   	push   %ebp
  801190:	89 e5                	mov    %esp,%ebp
  801192:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  801195:	8b 45 08             	mov    0x8(%ebp),%eax
  801198:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  80119b:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80119f:	74 30                	je     8011d1 <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  8011a1:	eb 16                	jmp    8011b9 <strlcpy+0x2a>
			*dst++ = *src++;
  8011a3:	8b 45 08             	mov    0x8(%ebp),%eax
  8011a6:	8d 50 01             	lea    0x1(%eax),%edx
  8011a9:	89 55 08             	mov    %edx,0x8(%ebp)
  8011ac:	8b 55 0c             	mov    0xc(%ebp),%edx
  8011af:	8d 4a 01             	lea    0x1(%edx),%ecx
  8011b2:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  8011b5:	8a 12                	mov    (%edx),%dl
  8011b7:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  8011b9:	ff 4d 10             	decl   0x10(%ebp)
  8011bc:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8011c0:	74 09                	je     8011cb <strlcpy+0x3c>
  8011c2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011c5:	8a 00                	mov    (%eax),%al
  8011c7:	84 c0                	test   %al,%al
  8011c9:	75 d8                	jne    8011a3 <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  8011cb:	8b 45 08             	mov    0x8(%ebp),%eax
  8011ce:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  8011d1:	8b 55 08             	mov    0x8(%ebp),%edx
  8011d4:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8011d7:	29 c2                	sub    %eax,%edx
  8011d9:	89 d0                	mov    %edx,%eax
}
  8011db:	c9                   	leave  
  8011dc:	c3                   	ret    

008011dd <strcmp>:

int
strcmp(const char *p, const char *q)
{
  8011dd:	55                   	push   %ebp
  8011de:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  8011e0:	eb 06                	jmp    8011e8 <strcmp+0xb>
		p++, q++;
  8011e2:	ff 45 08             	incl   0x8(%ebp)
  8011e5:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  8011e8:	8b 45 08             	mov    0x8(%ebp),%eax
  8011eb:	8a 00                	mov    (%eax),%al
  8011ed:	84 c0                	test   %al,%al
  8011ef:	74 0e                	je     8011ff <strcmp+0x22>
  8011f1:	8b 45 08             	mov    0x8(%ebp),%eax
  8011f4:	8a 10                	mov    (%eax),%dl
  8011f6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011f9:	8a 00                	mov    (%eax),%al
  8011fb:	38 c2                	cmp    %al,%dl
  8011fd:	74 e3                	je     8011e2 <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  8011ff:	8b 45 08             	mov    0x8(%ebp),%eax
  801202:	8a 00                	mov    (%eax),%al
  801204:	0f b6 d0             	movzbl %al,%edx
  801207:	8b 45 0c             	mov    0xc(%ebp),%eax
  80120a:	8a 00                	mov    (%eax),%al
  80120c:	0f b6 c0             	movzbl %al,%eax
  80120f:	29 c2                	sub    %eax,%edx
  801211:	89 d0                	mov    %edx,%eax
}
  801213:	5d                   	pop    %ebp
  801214:	c3                   	ret    

00801215 <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  801215:	55                   	push   %ebp
  801216:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  801218:	eb 09                	jmp    801223 <strncmp+0xe>
		n--, p++, q++;
  80121a:	ff 4d 10             	decl   0x10(%ebp)
  80121d:	ff 45 08             	incl   0x8(%ebp)
  801220:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  801223:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801227:	74 17                	je     801240 <strncmp+0x2b>
  801229:	8b 45 08             	mov    0x8(%ebp),%eax
  80122c:	8a 00                	mov    (%eax),%al
  80122e:	84 c0                	test   %al,%al
  801230:	74 0e                	je     801240 <strncmp+0x2b>
  801232:	8b 45 08             	mov    0x8(%ebp),%eax
  801235:	8a 10                	mov    (%eax),%dl
  801237:	8b 45 0c             	mov    0xc(%ebp),%eax
  80123a:	8a 00                	mov    (%eax),%al
  80123c:	38 c2                	cmp    %al,%dl
  80123e:	74 da                	je     80121a <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  801240:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801244:	75 07                	jne    80124d <strncmp+0x38>
		return 0;
  801246:	b8 00 00 00 00       	mov    $0x0,%eax
  80124b:	eb 14                	jmp    801261 <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  80124d:	8b 45 08             	mov    0x8(%ebp),%eax
  801250:	8a 00                	mov    (%eax),%al
  801252:	0f b6 d0             	movzbl %al,%edx
  801255:	8b 45 0c             	mov    0xc(%ebp),%eax
  801258:	8a 00                	mov    (%eax),%al
  80125a:	0f b6 c0             	movzbl %al,%eax
  80125d:	29 c2                	sub    %eax,%edx
  80125f:	89 d0                	mov    %edx,%eax
}
  801261:	5d                   	pop    %ebp
  801262:	c3                   	ret    

00801263 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  801263:	55                   	push   %ebp
  801264:	89 e5                	mov    %esp,%ebp
  801266:	83 ec 04             	sub    $0x4,%esp
  801269:	8b 45 0c             	mov    0xc(%ebp),%eax
  80126c:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  80126f:	eb 12                	jmp    801283 <strchr+0x20>
		if (*s == c)
  801271:	8b 45 08             	mov    0x8(%ebp),%eax
  801274:	8a 00                	mov    (%eax),%al
  801276:	3a 45 fc             	cmp    -0x4(%ebp),%al
  801279:	75 05                	jne    801280 <strchr+0x1d>
			return (char *) s;
  80127b:	8b 45 08             	mov    0x8(%ebp),%eax
  80127e:	eb 11                	jmp    801291 <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  801280:	ff 45 08             	incl   0x8(%ebp)
  801283:	8b 45 08             	mov    0x8(%ebp),%eax
  801286:	8a 00                	mov    (%eax),%al
  801288:	84 c0                	test   %al,%al
  80128a:	75 e5                	jne    801271 <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  80128c:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801291:	c9                   	leave  
  801292:	c3                   	ret    

00801293 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  801293:	55                   	push   %ebp
  801294:	89 e5                	mov    %esp,%ebp
  801296:	83 ec 04             	sub    $0x4,%esp
  801299:	8b 45 0c             	mov    0xc(%ebp),%eax
  80129c:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  80129f:	eb 0d                	jmp    8012ae <strfind+0x1b>
		if (*s == c)
  8012a1:	8b 45 08             	mov    0x8(%ebp),%eax
  8012a4:	8a 00                	mov    (%eax),%al
  8012a6:	3a 45 fc             	cmp    -0x4(%ebp),%al
  8012a9:	74 0e                	je     8012b9 <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  8012ab:	ff 45 08             	incl   0x8(%ebp)
  8012ae:	8b 45 08             	mov    0x8(%ebp),%eax
  8012b1:	8a 00                	mov    (%eax),%al
  8012b3:	84 c0                	test   %al,%al
  8012b5:	75 ea                	jne    8012a1 <strfind+0xe>
  8012b7:	eb 01                	jmp    8012ba <strfind+0x27>
		if (*s == c)
			break;
  8012b9:	90                   	nop
	return (char *) s;
  8012ba:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8012bd:	c9                   	leave  
  8012be:	c3                   	ret    

008012bf <memset>:


void *
memset(void *v, int c, uint32 n)
{
  8012bf:	55                   	push   %ebp
  8012c0:	89 e5                	mov    %esp,%ebp
  8012c2:	83 ec 10             	sub    $0x10,%esp
	char *p;
	int m;

	p = v;
  8012c5:	8b 45 08             	mov    0x8(%ebp),%eax
  8012c8:	89 45 fc             	mov    %eax,-0x4(%ebp)
	m = n;
  8012cb:	8b 45 10             	mov    0x10(%ebp),%eax
  8012ce:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (--m >= 0)
  8012d1:	eb 0e                	jmp    8012e1 <memset+0x22>
		*p++ = c;
  8012d3:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8012d6:	8d 50 01             	lea    0x1(%eax),%edx
  8012d9:	89 55 fc             	mov    %edx,-0x4(%ebp)
  8012dc:	8b 55 0c             	mov    0xc(%ebp),%edx
  8012df:	88 10                	mov    %dl,(%eax)
	char *p;
	int m;

	p = v;
	m = n;
	while (--m >= 0)
  8012e1:	ff 4d f8             	decl   -0x8(%ebp)
  8012e4:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  8012e8:	79 e9                	jns    8012d3 <memset+0x14>
		*p++ = c;

	return v;
  8012ea:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8012ed:	c9                   	leave  
  8012ee:	c3                   	ret    

008012ef <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  8012ef:	55                   	push   %ebp
  8012f0:	89 e5                	mov    %esp,%ebp
  8012f2:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  8012f5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012f8:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  8012fb:	8b 45 08             	mov    0x8(%ebp),%eax
  8012fe:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (n-- > 0)
  801301:	eb 16                	jmp    801319 <memcpy+0x2a>
		*d++ = *s++;
  801303:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801306:	8d 50 01             	lea    0x1(%eax),%edx
  801309:	89 55 f8             	mov    %edx,-0x8(%ebp)
  80130c:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80130f:	8d 4a 01             	lea    0x1(%edx),%ecx
  801312:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  801315:	8a 12                	mov    (%edx),%dl
  801317:	88 10                	mov    %dl,(%eax)
	const char *s;
	char *d;

	s = src;
	d = dst;
	while (n-- > 0)
  801319:	8b 45 10             	mov    0x10(%ebp),%eax
  80131c:	8d 50 ff             	lea    -0x1(%eax),%edx
  80131f:	89 55 10             	mov    %edx,0x10(%ebp)
  801322:	85 c0                	test   %eax,%eax
  801324:	75 dd                	jne    801303 <memcpy+0x14>
		*d++ = *s++;

	return dst;
  801326:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801329:	c9                   	leave  
  80132a:	c3                   	ret    

0080132b <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  80132b:	55                   	push   %ebp
  80132c:	89 e5                	mov    %esp,%ebp
  80132e:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  801331:	8b 45 0c             	mov    0xc(%ebp),%eax
  801334:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  801337:	8b 45 08             	mov    0x8(%ebp),%eax
  80133a:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  80133d:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801340:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  801343:	73 50                	jae    801395 <memmove+0x6a>
  801345:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801348:	8b 45 10             	mov    0x10(%ebp),%eax
  80134b:	01 d0                	add    %edx,%eax
  80134d:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  801350:	76 43                	jbe    801395 <memmove+0x6a>
		s += n;
  801352:	8b 45 10             	mov    0x10(%ebp),%eax
  801355:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  801358:	8b 45 10             	mov    0x10(%ebp),%eax
  80135b:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  80135e:	eb 10                	jmp    801370 <memmove+0x45>
			*--d = *--s;
  801360:	ff 4d f8             	decl   -0x8(%ebp)
  801363:	ff 4d fc             	decl   -0x4(%ebp)
  801366:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801369:	8a 10                	mov    (%eax),%dl
  80136b:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80136e:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  801370:	8b 45 10             	mov    0x10(%ebp),%eax
  801373:	8d 50 ff             	lea    -0x1(%eax),%edx
  801376:	89 55 10             	mov    %edx,0x10(%ebp)
  801379:	85 c0                	test   %eax,%eax
  80137b:	75 e3                	jne    801360 <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  80137d:	eb 23                	jmp    8013a2 <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  80137f:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801382:	8d 50 01             	lea    0x1(%eax),%edx
  801385:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801388:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80138b:	8d 4a 01             	lea    0x1(%edx),%ecx
  80138e:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  801391:	8a 12                	mov    (%edx),%dl
  801393:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  801395:	8b 45 10             	mov    0x10(%ebp),%eax
  801398:	8d 50 ff             	lea    -0x1(%eax),%edx
  80139b:	89 55 10             	mov    %edx,0x10(%ebp)
  80139e:	85 c0                	test   %eax,%eax
  8013a0:	75 dd                	jne    80137f <memmove+0x54>
			*d++ = *s++;

	return dst;
  8013a2:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8013a5:	c9                   	leave  
  8013a6:	c3                   	ret    

008013a7 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  8013a7:	55                   	push   %ebp
  8013a8:	89 e5                	mov    %esp,%ebp
  8013aa:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  8013ad:	8b 45 08             	mov    0x8(%ebp),%eax
  8013b0:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  8013b3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8013b6:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  8013b9:	eb 2a                	jmp    8013e5 <memcmp+0x3e>
		if (*s1 != *s2)
  8013bb:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8013be:	8a 10                	mov    (%eax),%dl
  8013c0:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8013c3:	8a 00                	mov    (%eax),%al
  8013c5:	38 c2                	cmp    %al,%dl
  8013c7:	74 16                	je     8013df <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  8013c9:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8013cc:	8a 00                	mov    (%eax),%al
  8013ce:	0f b6 d0             	movzbl %al,%edx
  8013d1:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8013d4:	8a 00                	mov    (%eax),%al
  8013d6:	0f b6 c0             	movzbl %al,%eax
  8013d9:	29 c2                	sub    %eax,%edx
  8013db:	89 d0                	mov    %edx,%eax
  8013dd:	eb 18                	jmp    8013f7 <memcmp+0x50>
		s1++, s2++;
  8013df:	ff 45 fc             	incl   -0x4(%ebp)
  8013e2:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  8013e5:	8b 45 10             	mov    0x10(%ebp),%eax
  8013e8:	8d 50 ff             	lea    -0x1(%eax),%edx
  8013eb:	89 55 10             	mov    %edx,0x10(%ebp)
  8013ee:	85 c0                	test   %eax,%eax
  8013f0:	75 c9                	jne    8013bb <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  8013f2:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8013f7:	c9                   	leave  
  8013f8:	c3                   	ret    

008013f9 <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  8013f9:	55                   	push   %ebp
  8013fa:	89 e5                	mov    %esp,%ebp
  8013fc:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  8013ff:	8b 55 08             	mov    0x8(%ebp),%edx
  801402:	8b 45 10             	mov    0x10(%ebp),%eax
  801405:	01 d0                	add    %edx,%eax
  801407:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  80140a:	eb 15                	jmp    801421 <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  80140c:	8b 45 08             	mov    0x8(%ebp),%eax
  80140f:	8a 00                	mov    (%eax),%al
  801411:	0f b6 d0             	movzbl %al,%edx
  801414:	8b 45 0c             	mov    0xc(%ebp),%eax
  801417:	0f b6 c0             	movzbl %al,%eax
  80141a:	39 c2                	cmp    %eax,%edx
  80141c:	74 0d                	je     80142b <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  80141e:	ff 45 08             	incl   0x8(%ebp)
  801421:	8b 45 08             	mov    0x8(%ebp),%eax
  801424:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  801427:	72 e3                	jb     80140c <memfind+0x13>
  801429:	eb 01                	jmp    80142c <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  80142b:	90                   	nop
	return (void *) s;
  80142c:	8b 45 08             	mov    0x8(%ebp),%eax
}
  80142f:	c9                   	leave  
  801430:	c3                   	ret    

00801431 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  801431:	55                   	push   %ebp
  801432:	89 e5                	mov    %esp,%ebp
  801434:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  801437:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  80143e:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801445:	eb 03                	jmp    80144a <strtol+0x19>
		s++;
  801447:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  80144a:	8b 45 08             	mov    0x8(%ebp),%eax
  80144d:	8a 00                	mov    (%eax),%al
  80144f:	3c 20                	cmp    $0x20,%al
  801451:	74 f4                	je     801447 <strtol+0x16>
  801453:	8b 45 08             	mov    0x8(%ebp),%eax
  801456:	8a 00                	mov    (%eax),%al
  801458:	3c 09                	cmp    $0x9,%al
  80145a:	74 eb                	je     801447 <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  80145c:	8b 45 08             	mov    0x8(%ebp),%eax
  80145f:	8a 00                	mov    (%eax),%al
  801461:	3c 2b                	cmp    $0x2b,%al
  801463:	75 05                	jne    80146a <strtol+0x39>
		s++;
  801465:	ff 45 08             	incl   0x8(%ebp)
  801468:	eb 13                	jmp    80147d <strtol+0x4c>
	else if (*s == '-')
  80146a:	8b 45 08             	mov    0x8(%ebp),%eax
  80146d:	8a 00                	mov    (%eax),%al
  80146f:	3c 2d                	cmp    $0x2d,%al
  801471:	75 0a                	jne    80147d <strtol+0x4c>
		s++, neg = 1;
  801473:	ff 45 08             	incl   0x8(%ebp)
  801476:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  80147d:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801481:	74 06                	je     801489 <strtol+0x58>
  801483:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  801487:	75 20                	jne    8014a9 <strtol+0x78>
  801489:	8b 45 08             	mov    0x8(%ebp),%eax
  80148c:	8a 00                	mov    (%eax),%al
  80148e:	3c 30                	cmp    $0x30,%al
  801490:	75 17                	jne    8014a9 <strtol+0x78>
  801492:	8b 45 08             	mov    0x8(%ebp),%eax
  801495:	40                   	inc    %eax
  801496:	8a 00                	mov    (%eax),%al
  801498:	3c 78                	cmp    $0x78,%al
  80149a:	75 0d                	jne    8014a9 <strtol+0x78>
		s += 2, base = 16;
  80149c:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  8014a0:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  8014a7:	eb 28                	jmp    8014d1 <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  8014a9:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8014ad:	75 15                	jne    8014c4 <strtol+0x93>
  8014af:	8b 45 08             	mov    0x8(%ebp),%eax
  8014b2:	8a 00                	mov    (%eax),%al
  8014b4:	3c 30                	cmp    $0x30,%al
  8014b6:	75 0c                	jne    8014c4 <strtol+0x93>
		s++, base = 8;
  8014b8:	ff 45 08             	incl   0x8(%ebp)
  8014bb:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  8014c2:	eb 0d                	jmp    8014d1 <strtol+0xa0>
	else if (base == 0)
  8014c4:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8014c8:	75 07                	jne    8014d1 <strtol+0xa0>
		base = 10;
  8014ca:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  8014d1:	8b 45 08             	mov    0x8(%ebp),%eax
  8014d4:	8a 00                	mov    (%eax),%al
  8014d6:	3c 2f                	cmp    $0x2f,%al
  8014d8:	7e 19                	jle    8014f3 <strtol+0xc2>
  8014da:	8b 45 08             	mov    0x8(%ebp),%eax
  8014dd:	8a 00                	mov    (%eax),%al
  8014df:	3c 39                	cmp    $0x39,%al
  8014e1:	7f 10                	jg     8014f3 <strtol+0xc2>
			dig = *s - '0';
  8014e3:	8b 45 08             	mov    0x8(%ebp),%eax
  8014e6:	8a 00                	mov    (%eax),%al
  8014e8:	0f be c0             	movsbl %al,%eax
  8014eb:	83 e8 30             	sub    $0x30,%eax
  8014ee:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8014f1:	eb 42                	jmp    801535 <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  8014f3:	8b 45 08             	mov    0x8(%ebp),%eax
  8014f6:	8a 00                	mov    (%eax),%al
  8014f8:	3c 60                	cmp    $0x60,%al
  8014fa:	7e 19                	jle    801515 <strtol+0xe4>
  8014fc:	8b 45 08             	mov    0x8(%ebp),%eax
  8014ff:	8a 00                	mov    (%eax),%al
  801501:	3c 7a                	cmp    $0x7a,%al
  801503:	7f 10                	jg     801515 <strtol+0xe4>
			dig = *s - 'a' + 10;
  801505:	8b 45 08             	mov    0x8(%ebp),%eax
  801508:	8a 00                	mov    (%eax),%al
  80150a:	0f be c0             	movsbl %al,%eax
  80150d:	83 e8 57             	sub    $0x57,%eax
  801510:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801513:	eb 20                	jmp    801535 <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  801515:	8b 45 08             	mov    0x8(%ebp),%eax
  801518:	8a 00                	mov    (%eax),%al
  80151a:	3c 40                	cmp    $0x40,%al
  80151c:	7e 39                	jle    801557 <strtol+0x126>
  80151e:	8b 45 08             	mov    0x8(%ebp),%eax
  801521:	8a 00                	mov    (%eax),%al
  801523:	3c 5a                	cmp    $0x5a,%al
  801525:	7f 30                	jg     801557 <strtol+0x126>
			dig = *s - 'A' + 10;
  801527:	8b 45 08             	mov    0x8(%ebp),%eax
  80152a:	8a 00                	mov    (%eax),%al
  80152c:	0f be c0             	movsbl %al,%eax
  80152f:	83 e8 37             	sub    $0x37,%eax
  801532:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  801535:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801538:	3b 45 10             	cmp    0x10(%ebp),%eax
  80153b:	7d 19                	jge    801556 <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  80153d:	ff 45 08             	incl   0x8(%ebp)
  801540:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801543:	0f af 45 10          	imul   0x10(%ebp),%eax
  801547:	89 c2                	mov    %eax,%edx
  801549:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80154c:	01 d0                	add    %edx,%eax
  80154e:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  801551:	e9 7b ff ff ff       	jmp    8014d1 <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  801556:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  801557:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80155b:	74 08                	je     801565 <strtol+0x134>
		*endptr = (char *) s;
  80155d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801560:	8b 55 08             	mov    0x8(%ebp),%edx
  801563:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  801565:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801569:	74 07                	je     801572 <strtol+0x141>
  80156b:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80156e:	f7 d8                	neg    %eax
  801570:	eb 03                	jmp    801575 <strtol+0x144>
  801572:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  801575:	c9                   	leave  
  801576:	c3                   	ret    

00801577 <ltostr>:

void
ltostr(long value, char *str)
{
  801577:	55                   	push   %ebp
  801578:	89 e5                	mov    %esp,%ebp
  80157a:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  80157d:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  801584:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  80158b:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80158f:	79 13                	jns    8015a4 <ltostr+0x2d>
	{
		neg = 1;
  801591:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  801598:	8b 45 0c             	mov    0xc(%ebp),%eax
  80159b:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  80159e:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  8015a1:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  8015a4:	8b 45 08             	mov    0x8(%ebp),%eax
  8015a7:	b9 0a 00 00 00       	mov    $0xa,%ecx
  8015ac:	99                   	cltd   
  8015ad:	f7 f9                	idiv   %ecx
  8015af:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  8015b2:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8015b5:	8d 50 01             	lea    0x1(%eax),%edx
  8015b8:	89 55 f8             	mov    %edx,-0x8(%ebp)
  8015bb:	89 c2                	mov    %eax,%edx
  8015bd:	8b 45 0c             	mov    0xc(%ebp),%eax
  8015c0:	01 d0                	add    %edx,%eax
  8015c2:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8015c5:	83 c2 30             	add    $0x30,%edx
  8015c8:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  8015ca:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8015cd:	b8 67 66 66 66       	mov    $0x66666667,%eax
  8015d2:	f7 e9                	imul   %ecx
  8015d4:	c1 fa 02             	sar    $0x2,%edx
  8015d7:	89 c8                	mov    %ecx,%eax
  8015d9:	c1 f8 1f             	sar    $0x1f,%eax
  8015dc:	29 c2                	sub    %eax,%edx
  8015de:	89 d0                	mov    %edx,%eax
  8015e0:	89 45 08             	mov    %eax,0x8(%ebp)
	} while (value % 10 != 0);
  8015e3:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8015e6:	b8 67 66 66 66       	mov    $0x66666667,%eax
  8015eb:	f7 e9                	imul   %ecx
  8015ed:	c1 fa 02             	sar    $0x2,%edx
  8015f0:	89 c8                	mov    %ecx,%eax
  8015f2:	c1 f8 1f             	sar    $0x1f,%eax
  8015f5:	29 c2                	sub    %eax,%edx
  8015f7:	89 d0                	mov    %edx,%eax
  8015f9:	c1 e0 02             	shl    $0x2,%eax
  8015fc:	01 d0                	add    %edx,%eax
  8015fe:	01 c0                	add    %eax,%eax
  801600:	29 c1                	sub    %eax,%ecx
  801602:	89 ca                	mov    %ecx,%edx
  801604:	85 d2                	test   %edx,%edx
  801606:	75 9c                	jne    8015a4 <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  801608:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  80160f:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801612:	48                   	dec    %eax
  801613:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  801616:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  80161a:	74 3d                	je     801659 <ltostr+0xe2>
		start = 1 ;
  80161c:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  801623:	eb 34                	jmp    801659 <ltostr+0xe2>
	{
		char tmp = str[start] ;
  801625:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801628:	8b 45 0c             	mov    0xc(%ebp),%eax
  80162b:	01 d0                	add    %edx,%eax
  80162d:	8a 00                	mov    (%eax),%al
  80162f:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  801632:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801635:	8b 45 0c             	mov    0xc(%ebp),%eax
  801638:	01 c2                	add    %eax,%edx
  80163a:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  80163d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801640:	01 c8                	add    %ecx,%eax
  801642:	8a 00                	mov    (%eax),%al
  801644:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  801646:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801649:	8b 45 0c             	mov    0xc(%ebp),%eax
  80164c:	01 c2                	add    %eax,%edx
  80164e:	8a 45 eb             	mov    -0x15(%ebp),%al
  801651:	88 02                	mov    %al,(%edx)
		start++ ;
  801653:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  801656:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  801659:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80165c:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80165f:	7c c4                	jl     801625 <ltostr+0xae>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  801661:	8b 55 f8             	mov    -0x8(%ebp),%edx
  801664:	8b 45 0c             	mov    0xc(%ebp),%eax
  801667:	01 d0                	add    %edx,%eax
  801669:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  80166c:	90                   	nop
  80166d:	c9                   	leave  
  80166e:	c3                   	ret    

0080166f <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  80166f:	55                   	push   %ebp
  801670:	89 e5                	mov    %esp,%ebp
  801672:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  801675:	ff 75 08             	pushl  0x8(%ebp)
  801678:	e8 54 fa ff ff       	call   8010d1 <strlen>
  80167d:	83 c4 04             	add    $0x4,%esp
  801680:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  801683:	ff 75 0c             	pushl  0xc(%ebp)
  801686:	e8 46 fa ff ff       	call   8010d1 <strlen>
  80168b:	83 c4 04             	add    $0x4,%esp
  80168e:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  801691:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  801698:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  80169f:	eb 17                	jmp    8016b8 <strcconcat+0x49>
		final[s] = str1[s] ;
  8016a1:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8016a4:	8b 45 10             	mov    0x10(%ebp),%eax
  8016a7:	01 c2                	add    %eax,%edx
  8016a9:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  8016ac:	8b 45 08             	mov    0x8(%ebp),%eax
  8016af:	01 c8                	add    %ecx,%eax
  8016b1:	8a 00                	mov    (%eax),%al
  8016b3:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  8016b5:	ff 45 fc             	incl   -0x4(%ebp)
  8016b8:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8016bb:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  8016be:	7c e1                	jl     8016a1 <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  8016c0:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  8016c7:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  8016ce:	eb 1f                	jmp    8016ef <strcconcat+0x80>
		final[s++] = str2[i] ;
  8016d0:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8016d3:	8d 50 01             	lea    0x1(%eax),%edx
  8016d6:	89 55 fc             	mov    %edx,-0x4(%ebp)
  8016d9:	89 c2                	mov    %eax,%edx
  8016db:	8b 45 10             	mov    0x10(%ebp),%eax
  8016de:	01 c2                	add    %eax,%edx
  8016e0:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  8016e3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8016e6:	01 c8                	add    %ecx,%eax
  8016e8:	8a 00                	mov    (%eax),%al
  8016ea:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  8016ec:	ff 45 f8             	incl   -0x8(%ebp)
  8016ef:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8016f2:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8016f5:	7c d9                	jl     8016d0 <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  8016f7:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8016fa:	8b 45 10             	mov    0x10(%ebp),%eax
  8016fd:	01 d0                	add    %edx,%eax
  8016ff:	c6 00 00             	movb   $0x0,(%eax)
}
  801702:	90                   	nop
  801703:	c9                   	leave  
  801704:	c3                   	ret    

00801705 <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  801705:	55                   	push   %ebp
  801706:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  801708:	8b 45 14             	mov    0x14(%ebp),%eax
  80170b:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  801711:	8b 45 14             	mov    0x14(%ebp),%eax
  801714:	8b 00                	mov    (%eax),%eax
  801716:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80171d:	8b 45 10             	mov    0x10(%ebp),%eax
  801720:	01 d0                	add    %edx,%eax
  801722:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801728:	eb 0c                	jmp    801736 <strsplit+0x31>
			*string++ = 0;
  80172a:	8b 45 08             	mov    0x8(%ebp),%eax
  80172d:	8d 50 01             	lea    0x1(%eax),%edx
  801730:	89 55 08             	mov    %edx,0x8(%ebp)
  801733:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801736:	8b 45 08             	mov    0x8(%ebp),%eax
  801739:	8a 00                	mov    (%eax),%al
  80173b:	84 c0                	test   %al,%al
  80173d:	74 18                	je     801757 <strsplit+0x52>
  80173f:	8b 45 08             	mov    0x8(%ebp),%eax
  801742:	8a 00                	mov    (%eax),%al
  801744:	0f be c0             	movsbl %al,%eax
  801747:	50                   	push   %eax
  801748:	ff 75 0c             	pushl  0xc(%ebp)
  80174b:	e8 13 fb ff ff       	call   801263 <strchr>
  801750:	83 c4 08             	add    $0x8,%esp
  801753:	85 c0                	test   %eax,%eax
  801755:	75 d3                	jne    80172a <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  801757:	8b 45 08             	mov    0x8(%ebp),%eax
  80175a:	8a 00                	mov    (%eax),%al
  80175c:	84 c0                	test   %al,%al
  80175e:	74 5a                	je     8017ba <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  801760:	8b 45 14             	mov    0x14(%ebp),%eax
  801763:	8b 00                	mov    (%eax),%eax
  801765:	83 f8 0f             	cmp    $0xf,%eax
  801768:	75 07                	jne    801771 <strsplit+0x6c>
		{
			return 0;
  80176a:	b8 00 00 00 00       	mov    $0x0,%eax
  80176f:	eb 66                	jmp    8017d7 <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  801771:	8b 45 14             	mov    0x14(%ebp),%eax
  801774:	8b 00                	mov    (%eax),%eax
  801776:	8d 48 01             	lea    0x1(%eax),%ecx
  801779:	8b 55 14             	mov    0x14(%ebp),%edx
  80177c:	89 0a                	mov    %ecx,(%edx)
  80177e:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801785:	8b 45 10             	mov    0x10(%ebp),%eax
  801788:	01 c2                	add    %eax,%edx
  80178a:	8b 45 08             	mov    0x8(%ebp),%eax
  80178d:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  80178f:	eb 03                	jmp    801794 <strsplit+0x8f>
			string++;
  801791:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  801794:	8b 45 08             	mov    0x8(%ebp),%eax
  801797:	8a 00                	mov    (%eax),%al
  801799:	84 c0                	test   %al,%al
  80179b:	74 8b                	je     801728 <strsplit+0x23>
  80179d:	8b 45 08             	mov    0x8(%ebp),%eax
  8017a0:	8a 00                	mov    (%eax),%al
  8017a2:	0f be c0             	movsbl %al,%eax
  8017a5:	50                   	push   %eax
  8017a6:	ff 75 0c             	pushl  0xc(%ebp)
  8017a9:	e8 b5 fa ff ff       	call   801263 <strchr>
  8017ae:	83 c4 08             	add    $0x8,%esp
  8017b1:	85 c0                	test   %eax,%eax
  8017b3:	74 dc                	je     801791 <strsplit+0x8c>
			string++;
	}
  8017b5:	e9 6e ff ff ff       	jmp    801728 <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  8017ba:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  8017bb:	8b 45 14             	mov    0x14(%ebp),%eax
  8017be:	8b 00                	mov    (%eax),%eax
  8017c0:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8017c7:	8b 45 10             	mov    0x10(%ebp),%eax
  8017ca:	01 d0                	add    %edx,%eax
  8017cc:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  8017d2:	b8 01 00 00 00       	mov    $0x1,%eax
}
  8017d7:	c9                   	leave  
  8017d8:	c3                   	ret    

008017d9 <InitializeUHeap>:
//============================== GIVEN FUNCTIONS ===================================//
//==================================================================================//

int FirstTimeFlag = 1;
void InitializeUHeap()
{
  8017d9:	55                   	push   %ebp
  8017da:	89 e5                	mov    %esp,%ebp
  8017dc:	83 ec 08             	sub    $0x8,%esp
	if(FirstTimeFlag)
  8017df:	a1 04 40 80 00       	mov    0x804004,%eax
  8017e4:	85 c0                	test   %eax,%eax
  8017e6:	74 1f                	je     801807 <InitializeUHeap+0x2e>
	{
		initialize_dyn_block_system();
  8017e8:	e8 1d 00 00 00       	call   80180a <initialize_dyn_block_system>
		cprintf("DYNAMIC BLOCK SYSTEM IS INITIALIZED\n");
  8017ed:	83 ec 0c             	sub    $0xc,%esp
  8017f0:	68 70 3d 80 00       	push   $0x803d70
  8017f5:	e8 55 f2 ff ff       	call   800a4f <cprintf>
  8017fa:	83 c4 10             	add    $0x10,%esp
#if UHP_USE_BUDDY
		initialize_buddy();
		cprintf("BUDDY SYSTEM IS INITIALIZED\n");
#endif
		FirstTimeFlag = 0;
  8017fd:	c7 05 04 40 80 00 00 	movl   $0x0,0x804004
  801804:	00 00 00 
	}
}
  801807:	90                   	nop
  801808:	c9                   	leave  
  801809:	c3                   	ret    

0080180a <initialize_dyn_block_system>:

//=================================
// [1] INITIALIZE DYNAMIC ALLOCATOR:
//=================================
void initialize_dyn_block_system()
{
  80180a:	55                   	push   %ebp
  80180b:	89 e5                	mov    %esp,%ebp
  80180d:	83 ec 28             	sub    $0x28,%esp
	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] initialize_dyn_block_system
	// your code is here, remove the panic and write your code
	//panic("initialize_dyn_block_system() is not implemented yet...!!");

	LIST_INIT(&AllocMemBlocksList);
  801810:	c7 05 40 40 80 00 00 	movl   $0x0,0x804040
  801817:	00 00 00 
  80181a:	c7 05 44 40 80 00 00 	movl   $0x0,0x804044
  801821:	00 00 00 
  801824:	c7 05 4c 40 80 00 00 	movl   $0x0,0x80404c
  80182b:	00 00 00 
	LIST_INIT(&FreeMemBlocksList);
  80182e:	c7 05 38 41 80 00 00 	movl   $0x0,0x804138
  801835:	00 00 00 
  801838:	c7 05 3c 41 80 00 00 	movl   $0x0,0x80413c
  80183f:	00 00 00 
  801842:	c7 05 44 41 80 00 00 	movl   $0x0,0x804144
  801849:	00 00 00 
	MAX_MEM_BLOCK_CNT = NUM_OF_UHEAP_PAGES;
  80184c:	c7 05 20 41 80 00 00 	movl   $0x20000,0x804120
  801853:	00 02 00 
	MemBlockNodes = (void*)USER_DYN_BLKS_ARRAY;
  801856:	c7 45 f4 00 00 e0 7f 	movl   $0x7fe00000,-0xc(%ebp)
  80185d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801860:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801865:	2d 00 10 00 00       	sub    $0x1000,%eax
  80186a:	a3 50 40 80 00       	mov    %eax,0x804050
	int size_of_block = sizeof(struct MemBlock);
  80186f:	c7 45 f0 10 00 00 00 	movl   $0x10,-0x10(%ebp)
	int size_all_struct = size_of_block*MAX_MEM_BLOCK_CNT;
  801876:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801879:	a1 20 41 80 00       	mov    0x804120,%eax
  80187e:	0f af c2             	imul   %edx,%eax
  801881:	89 45 ec             	mov    %eax,-0x14(%ebp)
	size_all_struct = ROUNDUP(size_all_struct, PAGE_SIZE);
  801884:	c7 45 e8 00 10 00 00 	movl   $0x1000,-0x18(%ebp)
  80188b:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80188e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801891:	01 d0                	add    %edx,%eax
  801893:	48                   	dec    %eax
  801894:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  801897:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80189a:	ba 00 00 00 00       	mov    $0x0,%edx
  80189f:	f7 75 e8             	divl   -0x18(%ebp)
  8018a2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8018a5:	29 d0                	sub    %edx,%eax
  8018a7:	89 45 ec             	mov    %eax,-0x14(%ebp)
	sys_allocate_chunk(USER_DYN_BLKS_ARRAY, size_all_struct,PERM_USER| PERM_WRITEABLE);
  8018aa:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8018ad:	c7 45 e0 00 00 e0 7f 	movl   $0x7fe00000,-0x20(%ebp)
  8018b4:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8018b7:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
  8018bd:	81 ea 00 10 00 00    	sub    $0x1000,%edx
  8018c3:	83 ec 04             	sub    $0x4,%esp
  8018c6:	6a 06                	push   $0x6
  8018c8:	50                   	push   %eax
  8018c9:	52                   	push   %edx
  8018ca:	e8 a1 05 00 00       	call   801e70 <sys_allocate_chunk>
  8018cf:	83 c4 10             	add    $0x10,%esp
	initialize_MemBlocksList(MAX_MEM_BLOCK_CNT);
  8018d2:	a1 20 41 80 00       	mov    0x804120,%eax
  8018d7:	83 ec 0c             	sub    $0xc,%esp
  8018da:	50                   	push   %eax
  8018db:	e8 16 0c 00 00       	call   8024f6 <initialize_MemBlocksList>
  8018e0:	83 c4 10             	add    $0x10,%esp
	struct MemBlock* ourBlock =LIST_LAST(&AvailableMemBlocksList);
  8018e3:	a1 4c 41 80 00       	mov    0x80414c,%eax
  8018e8:	89 45 dc             	mov    %eax,-0x24(%ebp)
	LIST_REMOVE(&AvailableMemBlocksList,ourBlock);
  8018eb:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  8018ef:	75 14                	jne    801905 <initialize_dyn_block_system+0xfb>
  8018f1:	83 ec 04             	sub    $0x4,%esp
  8018f4:	68 95 3d 80 00       	push   $0x803d95
  8018f9:	6a 2d                	push   $0x2d
  8018fb:	68 b3 3d 80 00       	push   $0x803db3
  801900:	e8 96 ee ff ff       	call   80079b <_panic>
  801905:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801908:	8b 00                	mov    (%eax),%eax
  80190a:	85 c0                	test   %eax,%eax
  80190c:	74 10                	je     80191e <initialize_dyn_block_system+0x114>
  80190e:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801911:	8b 00                	mov    (%eax),%eax
  801913:	8b 55 dc             	mov    -0x24(%ebp),%edx
  801916:	8b 52 04             	mov    0x4(%edx),%edx
  801919:	89 50 04             	mov    %edx,0x4(%eax)
  80191c:	eb 0b                	jmp    801929 <initialize_dyn_block_system+0x11f>
  80191e:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801921:	8b 40 04             	mov    0x4(%eax),%eax
  801924:	a3 4c 41 80 00       	mov    %eax,0x80414c
  801929:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80192c:	8b 40 04             	mov    0x4(%eax),%eax
  80192f:	85 c0                	test   %eax,%eax
  801931:	74 0f                	je     801942 <initialize_dyn_block_system+0x138>
  801933:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801936:	8b 40 04             	mov    0x4(%eax),%eax
  801939:	8b 55 dc             	mov    -0x24(%ebp),%edx
  80193c:	8b 12                	mov    (%edx),%edx
  80193e:	89 10                	mov    %edx,(%eax)
  801940:	eb 0a                	jmp    80194c <initialize_dyn_block_system+0x142>
  801942:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801945:	8b 00                	mov    (%eax),%eax
  801947:	a3 48 41 80 00       	mov    %eax,0x804148
  80194c:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80194f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  801955:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801958:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80195f:	a1 54 41 80 00       	mov    0x804154,%eax
  801964:	48                   	dec    %eax
  801965:	a3 54 41 80 00       	mov    %eax,0x804154
	ourBlock->size = USER_HEAP_MAX-USER_HEAP_START;
  80196a:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80196d:	c7 40 0c 00 00 00 20 	movl   $0x20000000,0xc(%eax)
	ourBlock->sva=USER_HEAP_START;
  801974:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801977:	c7 40 08 00 00 00 80 	movl   $0x80000000,0x8(%eax)
	LIST_INSERT_TAIL(&FreeMemBlocksList, ourBlock);
  80197e:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  801982:	75 14                	jne    801998 <initialize_dyn_block_system+0x18e>
  801984:	83 ec 04             	sub    $0x4,%esp
  801987:	68 c0 3d 80 00       	push   $0x803dc0
  80198c:	6a 30                	push   $0x30
  80198e:	68 b3 3d 80 00       	push   $0x803db3
  801993:	e8 03 ee ff ff       	call   80079b <_panic>
  801998:	8b 15 3c 41 80 00    	mov    0x80413c,%edx
  80199e:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8019a1:	89 50 04             	mov    %edx,0x4(%eax)
  8019a4:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8019a7:	8b 40 04             	mov    0x4(%eax),%eax
  8019aa:	85 c0                	test   %eax,%eax
  8019ac:	74 0c                	je     8019ba <initialize_dyn_block_system+0x1b0>
  8019ae:	a1 3c 41 80 00       	mov    0x80413c,%eax
  8019b3:	8b 55 dc             	mov    -0x24(%ebp),%edx
  8019b6:	89 10                	mov    %edx,(%eax)
  8019b8:	eb 08                	jmp    8019c2 <initialize_dyn_block_system+0x1b8>
  8019ba:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8019bd:	a3 38 41 80 00       	mov    %eax,0x804138
  8019c2:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8019c5:	a3 3c 41 80 00       	mov    %eax,0x80413c
  8019ca:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8019cd:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8019d3:	a1 44 41 80 00       	mov    0x804144,%eax
  8019d8:	40                   	inc    %eax
  8019d9:	a3 44 41 80 00       	mov    %eax,0x804144
	//[1] Initialize two lists (AllocMemBlocksList & FreeMemBlocksList) [Hint: use LIST_INIT()]
	//[2] Dynamically allocate the array of MemBlockNodes at VA USER_DYN_BLKS_ARRAY
	//	  (remember to set MAX_MEM_BLOCK_CNT with the chosen size of the array)
	//[3] Initialize AvailableMemBlocksList by filling it with the MemBlockNodes
	//[4] Insert a new MemBlock with the heap size into the FreeMemBlocksList
}
  8019de:	90                   	nop
  8019df:	c9                   	leave  
  8019e0:	c3                   	ret    

008019e1 <malloc>:
//=================================
// [2] ALLOCATE SPACE IN USER HEAP:
//=================================

void* malloc(uint32 size)
{
  8019e1:	55                   	push   %ebp
  8019e2:	89 e5                	mov    %esp,%ebp
  8019e4:	83 ec 18             	sub    $0x18,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  8019e7:	e8 ed fd ff ff       	call   8017d9 <InitializeUHeap>
	if (size == 0) return NULL ;
  8019ec:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8019f0:	75 07                	jne    8019f9 <malloc+0x18>
  8019f2:	b8 00 00 00 00       	mov    $0x0,%eax
  8019f7:	eb 67                	jmp    801a60 <malloc+0x7f>

	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] malloc
	// your code is here, remove the panic and write your code
	//panic("malloc() is not implemented yet...!!");

	size = ROUNDUP(size, PAGE_SIZE);
  8019f9:	c7 45 f4 00 10 00 00 	movl   $0x1000,-0xc(%ebp)
  801a00:	8b 55 08             	mov    0x8(%ebp),%edx
  801a03:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801a06:	01 d0                	add    %edx,%eax
  801a08:	48                   	dec    %eax
  801a09:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801a0c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801a0f:	ba 00 00 00 00       	mov    $0x0,%edx
  801a14:	f7 75 f4             	divl   -0xc(%ebp)
  801a17:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801a1a:	29 d0                	sub    %edx,%eax
  801a1c:	89 45 08             	mov    %eax,0x8(%ebp)
	if(sys_isUHeapPlacementStrategyFIRSTFIT())
  801a1f:	e8 1a 08 00 00       	call   80223e <sys_isUHeapPlacementStrategyFIRSTFIT>
  801a24:	85 c0                	test   %eax,%eax
  801a26:	74 33                	je     801a5b <malloc+0x7a>
	{
		struct MemBlock * myBlock = alloc_block_FF(size);
  801a28:	83 ec 0c             	sub    $0xc,%esp
  801a2b:	ff 75 08             	pushl  0x8(%ebp)
  801a2e:	e8 0c 0e 00 00       	call   80283f <alloc_block_FF>
  801a33:	83 c4 10             	add    $0x10,%esp
  801a36:	89 45 ec             	mov    %eax,-0x14(%ebp)
		if(myBlock != NULL)
  801a39:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  801a3d:	74 1c                	je     801a5b <malloc+0x7a>
		{
			insert_sorted_allocList(myBlock);
  801a3f:	83 ec 0c             	sub    $0xc,%esp
  801a42:	ff 75 ec             	pushl  -0x14(%ebp)
  801a45:	e8 07 0c 00 00       	call   802651 <insert_sorted_allocList>
  801a4a:	83 c4 10             	add    $0x10,%esp
			uint32 ptr = myBlock->sva;
  801a4d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801a50:	8b 40 08             	mov    0x8(%eax),%eax
  801a53:	89 45 e8             	mov    %eax,-0x18(%ebp)
			return (void *)ptr;
  801a56:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801a59:	eb 05                	jmp    801a60 <malloc+0x7f>
		}
	}
	return NULL;
  801a5b:	b8 00 00 00 00       	mov    $0x0,%eax
	//		to the required allocation size (space should be on 4 KB BOUNDARY)
	//	2) if no suitable space found, return NULL
	// 	3) Return pointer containing the virtual address of allocated space,
	//
	//Use sys_isUHeapPlacementStrategyFIRSTFIT()... to check the current strategy
}
  801a60:	c9                   	leave  
  801a61:	c3                   	ret    

00801a62 <free>:
//	We can use sys_free_user_mem(uint32 virtual_address, uint32 size); which
//		switches to the kernel mode, calls free_user_mem() in
//		"kern/mem/chunk_operations.c", then switch back to the user mode here
//	the free_user_mem function is empty, make sure to implement it.
void free(void* virtual_address)
{
  801a62:	55                   	push   %ebp
  801a63:	89 e5                	mov    %esp,%ebp
  801a65:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] free
	// your code is here, remove the panic and write your code
	//panic("free() is not implemented yet...!!");

	uint32 virtualAddress = (uint32 )(virtual_address);
  801a68:	8b 45 08             	mov    0x8(%ebp),%eax
  801a6b:	89 45 f4             	mov    %eax,-0xc(%ebp)
//	virtualAddress = ROUNDDOWN(virtualAddress, PAGE_SIZE);
	struct MemBlock * myBlock = find_block(&AllocMemBlocksList, virtualAddress);
  801a6e:	83 ec 08             	sub    $0x8,%esp
  801a71:	ff 75 f4             	pushl  -0xc(%ebp)
  801a74:	68 40 40 80 00       	push   $0x804040
  801a79:	e8 5b 0b 00 00       	call   8025d9 <find_block>
  801a7e:	83 c4 10             	add    $0x10,%esp
  801a81:	89 45 f0             	mov    %eax,-0x10(%ebp)
//	cprintf ("ptr sva at free user side = %x \n", myBlock->sva);
	sys_free_user_mem(virtualAddress, myBlock->size);
  801a84:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801a87:	8b 40 0c             	mov    0xc(%eax),%eax
  801a8a:	83 ec 08             	sub    $0x8,%esp
  801a8d:	50                   	push   %eax
  801a8e:	ff 75 f4             	pushl  -0xc(%ebp)
  801a91:	e8 a2 03 00 00       	call   801e38 <sys_free_user_mem>
  801a96:	83 c4 10             	add    $0x10,%esp
	LIST_REMOVE(&AllocMemBlocksList, myBlock);
  801a99:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801a9d:	75 14                	jne    801ab3 <free+0x51>
  801a9f:	83 ec 04             	sub    $0x4,%esp
  801aa2:	68 95 3d 80 00       	push   $0x803d95
  801aa7:	6a 76                	push   $0x76
  801aa9:	68 b3 3d 80 00       	push   $0x803db3
  801aae:	e8 e8 ec ff ff       	call   80079b <_panic>
  801ab3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801ab6:	8b 00                	mov    (%eax),%eax
  801ab8:	85 c0                	test   %eax,%eax
  801aba:	74 10                	je     801acc <free+0x6a>
  801abc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801abf:	8b 00                	mov    (%eax),%eax
  801ac1:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801ac4:	8b 52 04             	mov    0x4(%edx),%edx
  801ac7:	89 50 04             	mov    %edx,0x4(%eax)
  801aca:	eb 0b                	jmp    801ad7 <free+0x75>
  801acc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801acf:	8b 40 04             	mov    0x4(%eax),%eax
  801ad2:	a3 44 40 80 00       	mov    %eax,0x804044
  801ad7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801ada:	8b 40 04             	mov    0x4(%eax),%eax
  801add:	85 c0                	test   %eax,%eax
  801adf:	74 0f                	je     801af0 <free+0x8e>
  801ae1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801ae4:	8b 40 04             	mov    0x4(%eax),%eax
  801ae7:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801aea:	8b 12                	mov    (%edx),%edx
  801aec:	89 10                	mov    %edx,(%eax)
  801aee:	eb 0a                	jmp    801afa <free+0x98>
  801af0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801af3:	8b 00                	mov    (%eax),%eax
  801af5:	a3 40 40 80 00       	mov    %eax,0x804040
  801afa:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801afd:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  801b03:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801b06:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  801b0d:	a1 4c 40 80 00       	mov    0x80404c,%eax
  801b12:	48                   	dec    %eax
  801b13:	a3 4c 40 80 00       	mov    %eax,0x80404c
	insert_sorted_with_merge_freeList(myBlock);
  801b18:	83 ec 0c             	sub    $0xc,%esp
  801b1b:	ff 75 f0             	pushl  -0x10(%ebp)
  801b1e:	e8 0b 14 00 00       	call   802f2e <insert_sorted_with_merge_freeList>
  801b23:	83 c4 10             	add    $0x10,%esp

	//you should get the size of the given allocation using its address
	//you need to call sys_free_user_mem()
	//refer to the project presentation and documentation for details
}
  801b26:	90                   	nop
  801b27:	c9                   	leave  
  801b28:	c3                   	ret    

00801b29 <smalloc>:

//=================================
// [4] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
  801b29:	55                   	push   %ebp
  801b2a:	89 e5                	mov    %esp,%ebp
  801b2c:	83 ec 28             	sub    $0x28,%esp
  801b2f:	8b 45 10             	mov    0x10(%ebp),%eax
  801b32:	88 45 e4             	mov    %al,-0x1c(%ebp)
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801b35:	e8 9f fc ff ff       	call   8017d9 <InitializeUHeap>
	if (size == 0) return NULL ;
  801b3a:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801b3e:	75 0a                	jne    801b4a <smalloc+0x21>
  801b40:	b8 00 00 00 00       	mov    $0x0,%eax
  801b45:	e9 8d 00 00 00       	jmp    801bd7 <smalloc+0xae>

	//This function should find the space of the required range
	// * ON 4KB BOUNDARY **** //
	//Use sys_isUHeapPlacementStrategyFIRSTFIT() to check the current strategy

	size = ROUNDUP(size, PAGE_SIZE);
  801b4a:	c7 45 f4 00 10 00 00 	movl   $0x1000,-0xc(%ebp)
  801b51:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b54:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801b57:	01 d0                	add    %edx,%eax
  801b59:	48                   	dec    %eax
  801b5a:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801b5d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801b60:	ba 00 00 00 00       	mov    $0x0,%edx
  801b65:	f7 75 f4             	divl   -0xc(%ebp)
  801b68:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801b6b:	29 d0                	sub    %edx,%eax
  801b6d:	89 45 0c             	mov    %eax,0xc(%ebp)
		if(sys_isUHeapPlacementStrategyFIRSTFIT())
  801b70:	e8 c9 06 00 00       	call   80223e <sys_isUHeapPlacementStrategyFIRSTFIT>
  801b75:	85 c0                	test   %eax,%eax
  801b77:	74 59                	je     801bd2 <smalloc+0xa9>
		{
			struct MemBlock * v1=NULL;
  801b79:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
			v1= alloc_block_FF(size);
  801b80:	83 ec 0c             	sub    $0xc,%esp
  801b83:	ff 75 0c             	pushl  0xc(%ebp)
  801b86:	e8 b4 0c 00 00       	call   80283f <alloc_block_FF>
  801b8b:	83 c4 10             	add    $0x10,%esp
  801b8e:	89 45 ec             	mov    %eax,-0x14(%ebp)
			if(v1==NULL)
  801b91:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  801b95:	75 07                	jne    801b9e <smalloc+0x75>
			{
				return NULL;
  801b97:	b8 00 00 00 00       	mov    $0x0,%eax
  801b9c:	eb 39                	jmp    801bd7 <smalloc+0xae>
			}
			else
			{
				int ret=sys_createSharedObject(sharedVarName,  size,  isWritable,(void*)v1->sva);
  801b9e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801ba1:	8b 40 08             	mov    0x8(%eax),%eax
  801ba4:	89 c2                	mov    %eax,%edx
  801ba6:	0f b6 45 e4          	movzbl -0x1c(%ebp),%eax
  801baa:	52                   	push   %edx
  801bab:	50                   	push   %eax
  801bac:	ff 75 0c             	pushl  0xc(%ebp)
  801baf:	ff 75 08             	pushl  0x8(%ebp)
  801bb2:	e8 0c 04 00 00       	call   801fc3 <sys_createSharedObject>
  801bb7:	83 c4 10             	add    $0x10,%esp
  801bba:	89 45 e8             	mov    %eax,-0x18(%ebp)
				if(ret>=0)
  801bbd:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  801bc1:	78 08                	js     801bcb <smalloc+0xa2>
				{
					return (void*)v1->sva;
  801bc3:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801bc6:	8b 40 08             	mov    0x8(%eax),%eax
  801bc9:	eb 0c                	jmp    801bd7 <smalloc+0xae>
				}
				else
				{
					return NULL;
  801bcb:	b8 00 00 00 00       	mov    $0x0,%eax
  801bd0:	eb 05                	jmp    801bd7 <smalloc+0xae>
				}
			}

		}
		return NULL;
  801bd2:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801bd7:	c9                   	leave  
  801bd8:	c3                   	ret    

00801bd9 <sget>:

//========================================
// [5] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  801bd9:	55                   	push   %ebp
  801bda:	89 e5                	mov    %esp,%ebp
  801bdc:	83 ec 18             	sub    $0x18,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801bdf:	e8 f5 fb ff ff       	call   8017d9 <InitializeUHeap>

	//This function should find the space for sharing the variable
	// *** ON 4KB BOUNDARY ******** //

	//Use sys_isUHeapPlacementStrategyFIRSTFIT() to check the current strategy
	int ret=sys_getSizeOfSharedObject(ownerEnvID,sharedVarName);
  801be4:	83 ec 08             	sub    $0x8,%esp
  801be7:	ff 75 0c             	pushl  0xc(%ebp)
  801bea:	ff 75 08             	pushl  0x8(%ebp)
  801bed:	e8 fb 03 00 00       	call   801fed <sys_getSizeOfSharedObject>
  801bf2:	83 c4 10             	add    $0x10,%esp
  801bf5:	89 45 f4             	mov    %eax,-0xc(%ebp)
	if(ret==0)
  801bf8:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801bfc:	75 07                	jne    801c05 <sget+0x2c>
	{
		return NULL;
  801bfe:	b8 00 00 00 00       	mov    $0x0,%eax
  801c03:	eb 64                	jmp    801c69 <sget+0x90>
	}
	if(sys_isUHeapPlacementStrategyFIRSTFIT())
  801c05:	e8 34 06 00 00       	call   80223e <sys_isUHeapPlacementStrategyFIRSTFIT>
  801c0a:	85 c0                	test   %eax,%eax
  801c0c:	74 56                	je     801c64 <sget+0x8b>
	{
		struct MemBlock * v1=NULL;
  801c0e:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
		v1= alloc_block_FF(ret);
  801c15:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801c18:	83 ec 0c             	sub    $0xc,%esp
  801c1b:	50                   	push   %eax
  801c1c:	e8 1e 0c 00 00       	call   80283f <alloc_block_FF>
  801c21:	83 c4 10             	add    $0x10,%esp
  801c24:	89 45 f0             	mov    %eax,-0x10(%ebp)
		if(v1==NULL)
  801c27:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801c2b:	75 07                	jne    801c34 <sget+0x5b>
		{
		return NULL;
  801c2d:	b8 00 00 00 00       	mov    $0x0,%eax
  801c32:	eb 35                	jmp    801c69 <sget+0x90>
	    }
		else
		{
			int ret1=sys_getSharedObject(ownerEnvID,sharedVarName,(void*)v1->sva);
  801c34:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801c37:	8b 40 08             	mov    0x8(%eax),%eax
  801c3a:	83 ec 04             	sub    $0x4,%esp
  801c3d:	50                   	push   %eax
  801c3e:	ff 75 0c             	pushl  0xc(%ebp)
  801c41:	ff 75 08             	pushl  0x8(%ebp)
  801c44:	e8 c1 03 00 00       	call   80200a <sys_getSharedObject>
  801c49:	83 c4 10             	add    $0x10,%esp
  801c4c:	89 45 ec             	mov    %eax,-0x14(%ebp)
			if(ret1>=0)
  801c4f:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  801c53:	78 08                	js     801c5d <sget+0x84>
			{
				return (void*)v1->sva;
  801c55:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801c58:	8b 40 08             	mov    0x8(%eax),%eax
  801c5b:	eb 0c                	jmp    801c69 <sget+0x90>
			}
			else
			{
				return NULL;
  801c5d:	b8 00 00 00 00       	mov    $0x0,%eax
  801c62:	eb 05                	jmp    801c69 <sget+0x90>
			}
		}
	}
  return NULL;
  801c64:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801c69:	c9                   	leave  
  801c6a:	c3                   	ret    

00801c6b <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  801c6b:	55                   	push   %ebp
  801c6c:	89 e5                	mov    %esp,%ebp
  801c6e:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801c71:	e8 63 fb ff ff       	call   8017d9 <InitializeUHeap>
	//==============================================================
	// [USER HEAP - USER SIDE] realloc
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  801c76:	83 ec 04             	sub    $0x4,%esp
  801c79:	68 e4 3d 80 00       	push   $0x803de4
  801c7e:	68 0e 01 00 00       	push   $0x10e
  801c83:	68 b3 3d 80 00       	push   $0x803db3
  801c88:	e8 0e eb ff ff       	call   80079b <_panic>

00801c8d <sfree>:
//	use sys_freeSharedObject(...); which switches to the kernel mode,
//	calls freeSharedObject(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the freeSharedObject() function is empty, make sure to implement it.

void sfree(void* virtual_address)
{
  801c8d:	55                   	push   %ebp
  801c8e:	89 e5                	mov    %esp,%ebp
  801c90:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS3 - BONUS] [SHARING - USER SIDE] sfree()

	// Write your code here, remove the panic and write your code
	panic("sfree() is not implemented yet...!!");
  801c93:	83 ec 04             	sub    $0x4,%esp
  801c96:	68 0c 3e 80 00       	push   $0x803e0c
  801c9b:	68 22 01 00 00       	push   $0x122
  801ca0:	68 b3 3d 80 00       	push   $0x803db3
  801ca5:	e8 f1 ea ff ff       	call   80079b <_panic>

00801caa <expand>:

//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//
void expand(uint32 newSize)
{
  801caa:	55                   	push   %ebp
  801cab:	89 e5                	mov    %esp,%ebp
  801cad:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801cb0:	83 ec 04             	sub    $0x4,%esp
  801cb3:	68 30 3e 80 00       	push   $0x803e30
  801cb8:	68 2d 01 00 00       	push   $0x12d
  801cbd:	68 b3 3d 80 00       	push   $0x803db3
  801cc2:	e8 d4 ea ff ff       	call   80079b <_panic>

00801cc7 <shrink>:

}
void shrink(uint32 newSize)
{
  801cc7:	55                   	push   %ebp
  801cc8:	89 e5                	mov    %esp,%ebp
  801cca:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801ccd:	83 ec 04             	sub    $0x4,%esp
  801cd0:	68 30 3e 80 00       	push   $0x803e30
  801cd5:	68 32 01 00 00       	push   $0x132
  801cda:	68 b3 3d 80 00       	push   $0x803db3
  801cdf:	e8 b7 ea ff ff       	call   80079b <_panic>

00801ce4 <freeHeap>:

}
void freeHeap(void* virtual_address)
{
  801ce4:	55                   	push   %ebp
  801ce5:	89 e5                	mov    %esp,%ebp
  801ce7:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801cea:	83 ec 04             	sub    $0x4,%esp
  801ced:	68 30 3e 80 00       	push   $0x803e30
  801cf2:	68 37 01 00 00       	push   $0x137
  801cf7:	68 b3 3d 80 00       	push   $0x803db3
  801cfc:	e8 9a ea ff ff       	call   80079b <_panic>

00801d01 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  801d01:	55                   	push   %ebp
  801d02:	89 e5                	mov    %esp,%ebp
  801d04:	57                   	push   %edi
  801d05:	56                   	push   %esi
  801d06:	53                   	push   %ebx
  801d07:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801d0a:	8b 45 08             	mov    0x8(%ebp),%eax
  801d0d:	8b 55 0c             	mov    0xc(%ebp),%edx
  801d10:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801d13:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801d16:	8b 7d 18             	mov    0x18(%ebp),%edi
  801d19:	8b 75 1c             	mov    0x1c(%ebp),%esi
  801d1c:	cd 30                	int    $0x30
  801d1e:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  801d21:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801d24:	83 c4 10             	add    $0x10,%esp
  801d27:	5b                   	pop    %ebx
  801d28:	5e                   	pop    %esi
  801d29:	5f                   	pop    %edi
  801d2a:	5d                   	pop    %ebp
  801d2b:	c3                   	ret    

00801d2c <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  801d2c:	55                   	push   %ebp
  801d2d:	89 e5                	mov    %esp,%ebp
  801d2f:	83 ec 04             	sub    $0x4,%esp
  801d32:	8b 45 10             	mov    0x10(%ebp),%eax
  801d35:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  801d38:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801d3c:	8b 45 08             	mov    0x8(%ebp),%eax
  801d3f:	6a 00                	push   $0x0
  801d41:	6a 00                	push   $0x0
  801d43:	52                   	push   %edx
  801d44:	ff 75 0c             	pushl  0xc(%ebp)
  801d47:	50                   	push   %eax
  801d48:	6a 00                	push   $0x0
  801d4a:	e8 b2 ff ff ff       	call   801d01 <syscall>
  801d4f:	83 c4 18             	add    $0x18,%esp
}
  801d52:	90                   	nop
  801d53:	c9                   	leave  
  801d54:	c3                   	ret    

00801d55 <sys_cgetc>:

int
sys_cgetc(void)
{
  801d55:	55                   	push   %ebp
  801d56:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  801d58:	6a 00                	push   $0x0
  801d5a:	6a 00                	push   $0x0
  801d5c:	6a 00                	push   $0x0
  801d5e:	6a 00                	push   $0x0
  801d60:	6a 00                	push   $0x0
  801d62:	6a 01                	push   $0x1
  801d64:	e8 98 ff ff ff       	call   801d01 <syscall>
  801d69:	83 c4 18             	add    $0x18,%esp
}
  801d6c:	c9                   	leave  
  801d6d:	c3                   	ret    

00801d6e <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  801d6e:	55                   	push   %ebp
  801d6f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  801d71:	8b 55 0c             	mov    0xc(%ebp),%edx
  801d74:	8b 45 08             	mov    0x8(%ebp),%eax
  801d77:	6a 00                	push   $0x0
  801d79:	6a 00                	push   $0x0
  801d7b:	6a 00                	push   $0x0
  801d7d:	52                   	push   %edx
  801d7e:	50                   	push   %eax
  801d7f:	6a 05                	push   $0x5
  801d81:	e8 7b ff ff ff       	call   801d01 <syscall>
  801d86:	83 c4 18             	add    $0x18,%esp
}
  801d89:	c9                   	leave  
  801d8a:	c3                   	ret    

00801d8b <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  801d8b:	55                   	push   %ebp
  801d8c:	89 e5                	mov    %esp,%ebp
  801d8e:	56                   	push   %esi
  801d8f:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  801d90:	8b 75 18             	mov    0x18(%ebp),%esi
  801d93:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801d96:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801d99:	8b 55 0c             	mov    0xc(%ebp),%edx
  801d9c:	8b 45 08             	mov    0x8(%ebp),%eax
  801d9f:	56                   	push   %esi
  801da0:	53                   	push   %ebx
  801da1:	51                   	push   %ecx
  801da2:	52                   	push   %edx
  801da3:	50                   	push   %eax
  801da4:	6a 06                	push   $0x6
  801da6:	e8 56 ff ff ff       	call   801d01 <syscall>
  801dab:	83 c4 18             	add    $0x18,%esp
}
  801dae:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801db1:	5b                   	pop    %ebx
  801db2:	5e                   	pop    %esi
  801db3:	5d                   	pop    %ebp
  801db4:	c3                   	ret    

00801db5 <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  801db5:	55                   	push   %ebp
  801db6:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  801db8:	8b 55 0c             	mov    0xc(%ebp),%edx
  801dbb:	8b 45 08             	mov    0x8(%ebp),%eax
  801dbe:	6a 00                	push   $0x0
  801dc0:	6a 00                	push   $0x0
  801dc2:	6a 00                	push   $0x0
  801dc4:	52                   	push   %edx
  801dc5:	50                   	push   %eax
  801dc6:	6a 07                	push   $0x7
  801dc8:	e8 34 ff ff ff       	call   801d01 <syscall>
  801dcd:	83 c4 18             	add    $0x18,%esp
}
  801dd0:	c9                   	leave  
  801dd1:	c3                   	ret    

00801dd2 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  801dd2:	55                   	push   %ebp
  801dd3:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  801dd5:	6a 00                	push   $0x0
  801dd7:	6a 00                	push   $0x0
  801dd9:	6a 00                	push   $0x0
  801ddb:	ff 75 0c             	pushl  0xc(%ebp)
  801dde:	ff 75 08             	pushl  0x8(%ebp)
  801de1:	6a 08                	push   $0x8
  801de3:	e8 19 ff ff ff       	call   801d01 <syscall>
  801de8:	83 c4 18             	add    $0x18,%esp
}
  801deb:	c9                   	leave  
  801dec:	c3                   	ret    

00801ded <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  801ded:	55                   	push   %ebp
  801dee:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  801df0:	6a 00                	push   $0x0
  801df2:	6a 00                	push   $0x0
  801df4:	6a 00                	push   $0x0
  801df6:	6a 00                	push   $0x0
  801df8:	6a 00                	push   $0x0
  801dfa:	6a 09                	push   $0x9
  801dfc:	e8 00 ff ff ff       	call   801d01 <syscall>
  801e01:	83 c4 18             	add    $0x18,%esp
}
  801e04:	c9                   	leave  
  801e05:	c3                   	ret    

00801e06 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  801e06:	55                   	push   %ebp
  801e07:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  801e09:	6a 00                	push   $0x0
  801e0b:	6a 00                	push   $0x0
  801e0d:	6a 00                	push   $0x0
  801e0f:	6a 00                	push   $0x0
  801e11:	6a 00                	push   $0x0
  801e13:	6a 0a                	push   $0xa
  801e15:	e8 e7 fe ff ff       	call   801d01 <syscall>
  801e1a:	83 c4 18             	add    $0x18,%esp
}
  801e1d:	c9                   	leave  
  801e1e:	c3                   	ret    

00801e1f <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  801e1f:	55                   	push   %ebp
  801e20:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  801e22:	6a 00                	push   $0x0
  801e24:	6a 00                	push   $0x0
  801e26:	6a 00                	push   $0x0
  801e28:	6a 00                	push   $0x0
  801e2a:	6a 00                	push   $0x0
  801e2c:	6a 0b                	push   $0xb
  801e2e:	e8 ce fe ff ff       	call   801d01 <syscall>
  801e33:	83 c4 18             	add    $0x18,%esp
}
  801e36:	c9                   	leave  
  801e37:	c3                   	ret    

00801e38 <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  801e38:	55                   	push   %ebp
  801e39:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  801e3b:	6a 00                	push   $0x0
  801e3d:	6a 00                	push   $0x0
  801e3f:	6a 00                	push   $0x0
  801e41:	ff 75 0c             	pushl  0xc(%ebp)
  801e44:	ff 75 08             	pushl  0x8(%ebp)
  801e47:	6a 0f                	push   $0xf
  801e49:	e8 b3 fe ff ff       	call   801d01 <syscall>
  801e4e:	83 c4 18             	add    $0x18,%esp
	return;
  801e51:	90                   	nop
}
  801e52:	c9                   	leave  
  801e53:	c3                   	ret    

00801e54 <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  801e54:	55                   	push   %ebp
  801e55:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  801e57:	6a 00                	push   $0x0
  801e59:	6a 00                	push   $0x0
  801e5b:	6a 00                	push   $0x0
  801e5d:	ff 75 0c             	pushl  0xc(%ebp)
  801e60:	ff 75 08             	pushl  0x8(%ebp)
  801e63:	6a 10                	push   $0x10
  801e65:	e8 97 fe ff ff       	call   801d01 <syscall>
  801e6a:	83 c4 18             	add    $0x18,%esp
	return ;
  801e6d:	90                   	nop
}
  801e6e:	c9                   	leave  
  801e6f:	c3                   	ret    

00801e70 <sys_allocate_chunk>:

void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  801e70:	55                   	push   %ebp
  801e71:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  801e73:	6a 00                	push   $0x0
  801e75:	6a 00                	push   $0x0
  801e77:	ff 75 10             	pushl  0x10(%ebp)
  801e7a:	ff 75 0c             	pushl  0xc(%ebp)
  801e7d:	ff 75 08             	pushl  0x8(%ebp)
  801e80:	6a 11                	push   $0x11
  801e82:	e8 7a fe ff ff       	call   801d01 <syscall>
  801e87:	83 c4 18             	add    $0x18,%esp
	return ;
  801e8a:	90                   	nop
}
  801e8b:	c9                   	leave  
  801e8c:	c3                   	ret    

00801e8d <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  801e8d:	55                   	push   %ebp
  801e8e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  801e90:	6a 00                	push   $0x0
  801e92:	6a 00                	push   $0x0
  801e94:	6a 00                	push   $0x0
  801e96:	6a 00                	push   $0x0
  801e98:	6a 00                	push   $0x0
  801e9a:	6a 0c                	push   $0xc
  801e9c:	e8 60 fe ff ff       	call   801d01 <syscall>
  801ea1:	83 c4 18             	add    $0x18,%esp
}
  801ea4:	c9                   	leave  
  801ea5:	c3                   	ret    

00801ea6 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  801ea6:	55                   	push   %ebp
  801ea7:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  801ea9:	6a 00                	push   $0x0
  801eab:	6a 00                	push   $0x0
  801ead:	6a 00                	push   $0x0
  801eaf:	6a 00                	push   $0x0
  801eb1:	ff 75 08             	pushl  0x8(%ebp)
  801eb4:	6a 0d                	push   $0xd
  801eb6:	e8 46 fe ff ff       	call   801d01 <syscall>
  801ebb:	83 c4 18             	add    $0x18,%esp
}
  801ebe:	c9                   	leave  
  801ebf:	c3                   	ret    

00801ec0 <sys_scarce_memory>:

void sys_scarce_memory()
{
  801ec0:	55                   	push   %ebp
  801ec1:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  801ec3:	6a 00                	push   $0x0
  801ec5:	6a 00                	push   $0x0
  801ec7:	6a 00                	push   $0x0
  801ec9:	6a 00                	push   $0x0
  801ecb:	6a 00                	push   $0x0
  801ecd:	6a 0e                	push   $0xe
  801ecf:	e8 2d fe ff ff       	call   801d01 <syscall>
  801ed4:	83 c4 18             	add    $0x18,%esp
}
  801ed7:	90                   	nop
  801ed8:	c9                   	leave  
  801ed9:	c3                   	ret    

00801eda <sys_disable_interrupt>:

//NEW !! 2012...
void
sys_disable_interrupt()
{
  801eda:	55                   	push   %ebp
  801edb:	89 e5                	mov    %esp,%ebp
	syscall(SYS_disableINTR,0, 0, 0, 0, 0);
  801edd:	6a 00                	push   $0x0
  801edf:	6a 00                	push   $0x0
  801ee1:	6a 00                	push   $0x0
  801ee3:	6a 00                	push   $0x0
  801ee5:	6a 00                	push   $0x0
  801ee7:	6a 13                	push   $0x13
  801ee9:	e8 13 fe ff ff       	call   801d01 <syscall>
  801eee:	83 c4 18             	add    $0x18,%esp
}
  801ef1:	90                   	nop
  801ef2:	c9                   	leave  
  801ef3:	c3                   	ret    

00801ef4 <sys_enable_interrupt>:


void
sys_enable_interrupt()
{
  801ef4:	55                   	push   %ebp
  801ef5:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enableINTR,0, 0, 0, 0, 0);
  801ef7:	6a 00                	push   $0x0
  801ef9:	6a 00                	push   $0x0
  801efb:	6a 00                	push   $0x0
  801efd:	6a 00                	push   $0x0
  801eff:	6a 00                	push   $0x0
  801f01:	6a 14                	push   $0x14
  801f03:	e8 f9 fd ff ff       	call   801d01 <syscall>
  801f08:	83 c4 18             	add    $0x18,%esp
}
  801f0b:	90                   	nop
  801f0c:	c9                   	leave  
  801f0d:	c3                   	ret    

00801f0e <sys_cputc>:


void
sys_cputc(const char c)
{
  801f0e:	55                   	push   %ebp
  801f0f:	89 e5                	mov    %esp,%ebp
  801f11:	83 ec 04             	sub    $0x4,%esp
  801f14:	8b 45 08             	mov    0x8(%ebp),%eax
  801f17:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  801f1a:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801f1e:	6a 00                	push   $0x0
  801f20:	6a 00                	push   $0x0
  801f22:	6a 00                	push   $0x0
  801f24:	6a 00                	push   $0x0
  801f26:	50                   	push   %eax
  801f27:	6a 15                	push   $0x15
  801f29:	e8 d3 fd ff ff       	call   801d01 <syscall>
  801f2e:	83 c4 18             	add    $0x18,%esp
}
  801f31:	90                   	nop
  801f32:	c9                   	leave  
  801f33:	c3                   	ret    

00801f34 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  801f34:	55                   	push   %ebp
  801f35:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  801f37:	6a 00                	push   $0x0
  801f39:	6a 00                	push   $0x0
  801f3b:	6a 00                	push   $0x0
  801f3d:	6a 00                	push   $0x0
  801f3f:	6a 00                	push   $0x0
  801f41:	6a 16                	push   $0x16
  801f43:	e8 b9 fd ff ff       	call   801d01 <syscall>
  801f48:	83 c4 18             	add    $0x18,%esp
}
  801f4b:	90                   	nop
  801f4c:	c9                   	leave  
  801f4d:	c3                   	ret    

00801f4e <sys_createSemaphore>:

int
sys_createSemaphore(char* semaphoreName, uint32 initialValue)
{
  801f4e:	55                   	push   %ebp
  801f4f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_semaphore,(uint32)semaphoreName, (uint32)initialValue, 0, 0, 0);
  801f51:	8b 45 08             	mov    0x8(%ebp),%eax
  801f54:	6a 00                	push   $0x0
  801f56:	6a 00                	push   $0x0
  801f58:	6a 00                	push   $0x0
  801f5a:	ff 75 0c             	pushl  0xc(%ebp)
  801f5d:	50                   	push   %eax
  801f5e:	6a 17                	push   $0x17
  801f60:	e8 9c fd ff ff       	call   801d01 <syscall>
  801f65:	83 c4 18             	add    $0x18,%esp
}
  801f68:	c9                   	leave  
  801f69:	c3                   	ret    

00801f6a <sys_getSemaphoreValue>:

int
sys_getSemaphoreValue(int32 ownerEnvID, char* semaphoreName)
{
  801f6a:	55                   	push   %ebp
  801f6b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_semaphore_value,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801f6d:	8b 55 0c             	mov    0xc(%ebp),%edx
  801f70:	8b 45 08             	mov    0x8(%ebp),%eax
  801f73:	6a 00                	push   $0x0
  801f75:	6a 00                	push   $0x0
  801f77:	6a 00                	push   $0x0
  801f79:	52                   	push   %edx
  801f7a:	50                   	push   %eax
  801f7b:	6a 1a                	push   $0x1a
  801f7d:	e8 7f fd ff ff       	call   801d01 <syscall>
  801f82:	83 c4 18             	add    $0x18,%esp
}
  801f85:	c9                   	leave  
  801f86:	c3                   	ret    

00801f87 <sys_waitSemaphore>:

void
sys_waitSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801f87:	55                   	push   %ebp
  801f88:	89 e5                	mov    %esp,%ebp
	syscall(SYS_wait_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801f8a:	8b 55 0c             	mov    0xc(%ebp),%edx
  801f8d:	8b 45 08             	mov    0x8(%ebp),%eax
  801f90:	6a 00                	push   $0x0
  801f92:	6a 00                	push   $0x0
  801f94:	6a 00                	push   $0x0
  801f96:	52                   	push   %edx
  801f97:	50                   	push   %eax
  801f98:	6a 18                	push   $0x18
  801f9a:	e8 62 fd ff ff       	call   801d01 <syscall>
  801f9f:	83 c4 18             	add    $0x18,%esp
}
  801fa2:	90                   	nop
  801fa3:	c9                   	leave  
  801fa4:	c3                   	ret    

00801fa5 <sys_signalSemaphore>:

void
sys_signalSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801fa5:	55                   	push   %ebp
  801fa6:	89 e5                	mov    %esp,%ebp
	syscall(SYS_signal_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801fa8:	8b 55 0c             	mov    0xc(%ebp),%edx
  801fab:	8b 45 08             	mov    0x8(%ebp),%eax
  801fae:	6a 00                	push   $0x0
  801fb0:	6a 00                	push   $0x0
  801fb2:	6a 00                	push   $0x0
  801fb4:	52                   	push   %edx
  801fb5:	50                   	push   %eax
  801fb6:	6a 19                	push   $0x19
  801fb8:	e8 44 fd ff ff       	call   801d01 <syscall>
  801fbd:	83 c4 18             	add    $0x18,%esp
}
  801fc0:	90                   	nop
  801fc1:	c9                   	leave  
  801fc2:	c3                   	ret    

00801fc3 <sys_createSharedObject>:

int
sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  801fc3:	55                   	push   %ebp
  801fc4:	89 e5                	mov    %esp,%ebp
  801fc6:	83 ec 04             	sub    $0x4,%esp
  801fc9:	8b 45 10             	mov    0x10(%ebp),%eax
  801fcc:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  801fcf:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801fd2:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801fd6:	8b 45 08             	mov    0x8(%ebp),%eax
  801fd9:	6a 00                	push   $0x0
  801fdb:	51                   	push   %ecx
  801fdc:	52                   	push   %edx
  801fdd:	ff 75 0c             	pushl  0xc(%ebp)
  801fe0:	50                   	push   %eax
  801fe1:	6a 1b                	push   $0x1b
  801fe3:	e8 19 fd ff ff       	call   801d01 <syscall>
  801fe8:	83 c4 18             	add    $0x18,%esp
}
  801feb:	c9                   	leave  
  801fec:	c3                   	ret    

00801fed <sys_getSizeOfSharedObject>:

//2017:
int
sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  801fed:	55                   	push   %ebp
  801fee:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  801ff0:	8b 55 0c             	mov    0xc(%ebp),%edx
  801ff3:	8b 45 08             	mov    0x8(%ebp),%eax
  801ff6:	6a 00                	push   $0x0
  801ff8:	6a 00                	push   $0x0
  801ffa:	6a 00                	push   $0x0
  801ffc:	52                   	push   %edx
  801ffd:	50                   	push   %eax
  801ffe:	6a 1c                	push   $0x1c
  802000:	e8 fc fc ff ff       	call   801d01 <syscall>
  802005:	83 c4 18             	add    $0x18,%esp
}
  802008:	c9                   	leave  
  802009:	c3                   	ret    

0080200a <sys_getSharedObject>:
//==========

int
sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  80200a:	55                   	push   %ebp
  80200b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  80200d:	8b 4d 10             	mov    0x10(%ebp),%ecx
  802010:	8b 55 0c             	mov    0xc(%ebp),%edx
  802013:	8b 45 08             	mov    0x8(%ebp),%eax
  802016:	6a 00                	push   $0x0
  802018:	6a 00                	push   $0x0
  80201a:	51                   	push   %ecx
  80201b:	52                   	push   %edx
  80201c:	50                   	push   %eax
  80201d:	6a 1d                	push   $0x1d
  80201f:	e8 dd fc ff ff       	call   801d01 <syscall>
  802024:	83 c4 18             	add    $0x18,%esp
}
  802027:	c9                   	leave  
  802028:	c3                   	ret    

00802029 <sys_freeSharedObject>:

int
sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  802029:	55                   	push   %ebp
  80202a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  80202c:	8b 55 0c             	mov    0xc(%ebp),%edx
  80202f:	8b 45 08             	mov    0x8(%ebp),%eax
  802032:	6a 00                	push   $0x0
  802034:	6a 00                	push   $0x0
  802036:	6a 00                	push   $0x0
  802038:	52                   	push   %edx
  802039:	50                   	push   %eax
  80203a:	6a 1e                	push   $0x1e
  80203c:	e8 c0 fc ff ff       	call   801d01 <syscall>
  802041:	83 c4 18             	add    $0x18,%esp
}
  802044:	c9                   	leave  
  802045:	c3                   	ret    

00802046 <sys_getMaxShares>:

uint32 	sys_getMaxShares()
{
  802046:	55                   	push   %ebp
  802047:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_max_shares,0, 0, 0, 0, 0);
  802049:	6a 00                	push   $0x0
  80204b:	6a 00                	push   $0x0
  80204d:	6a 00                	push   $0x0
  80204f:	6a 00                	push   $0x0
  802051:	6a 00                	push   $0x0
  802053:	6a 1f                	push   $0x1f
  802055:	e8 a7 fc ff ff       	call   801d01 <syscall>
  80205a:	83 c4 18             	add    $0x18,%esp
}
  80205d:	c9                   	leave  
  80205e:	c3                   	ret    

0080205f <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  80205f:	55                   	push   %ebp
  802060:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  802062:	8b 45 08             	mov    0x8(%ebp),%eax
  802065:	6a 00                	push   $0x0
  802067:	ff 75 14             	pushl  0x14(%ebp)
  80206a:	ff 75 10             	pushl  0x10(%ebp)
  80206d:	ff 75 0c             	pushl  0xc(%ebp)
  802070:	50                   	push   %eax
  802071:	6a 20                	push   $0x20
  802073:	e8 89 fc ff ff       	call   801d01 <syscall>
  802078:	83 c4 18             	add    $0x18,%esp
}
  80207b:	c9                   	leave  
  80207c:	c3                   	ret    

0080207d <sys_run_env>:

void
sys_run_env(int32 envId)
{
  80207d:	55                   	push   %ebp
  80207e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  802080:	8b 45 08             	mov    0x8(%ebp),%eax
  802083:	6a 00                	push   $0x0
  802085:	6a 00                	push   $0x0
  802087:	6a 00                	push   $0x0
  802089:	6a 00                	push   $0x0
  80208b:	50                   	push   %eax
  80208c:	6a 21                	push   $0x21
  80208e:	e8 6e fc ff ff       	call   801d01 <syscall>
  802093:	83 c4 18             	add    $0x18,%esp
}
  802096:	90                   	nop
  802097:	c9                   	leave  
  802098:	c3                   	ret    

00802099 <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  802099:	55                   	push   %ebp
  80209a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  80209c:	8b 45 08             	mov    0x8(%ebp),%eax
  80209f:	6a 00                	push   $0x0
  8020a1:	6a 00                	push   $0x0
  8020a3:	6a 00                	push   $0x0
  8020a5:	6a 00                	push   $0x0
  8020a7:	50                   	push   %eax
  8020a8:	6a 22                	push   $0x22
  8020aa:	e8 52 fc ff ff       	call   801d01 <syscall>
  8020af:	83 c4 18             	add    $0x18,%esp
}
  8020b2:	c9                   	leave  
  8020b3:	c3                   	ret    

008020b4 <sys_getenvid>:

int32 sys_getenvid(void)
{
  8020b4:	55                   	push   %ebp
  8020b5:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  8020b7:	6a 00                	push   $0x0
  8020b9:	6a 00                	push   $0x0
  8020bb:	6a 00                	push   $0x0
  8020bd:	6a 00                	push   $0x0
  8020bf:	6a 00                	push   $0x0
  8020c1:	6a 02                	push   $0x2
  8020c3:	e8 39 fc ff ff       	call   801d01 <syscall>
  8020c8:	83 c4 18             	add    $0x18,%esp
}
  8020cb:	c9                   	leave  
  8020cc:	c3                   	ret    

008020cd <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  8020cd:	55                   	push   %ebp
  8020ce:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  8020d0:	6a 00                	push   $0x0
  8020d2:	6a 00                	push   $0x0
  8020d4:	6a 00                	push   $0x0
  8020d6:	6a 00                	push   $0x0
  8020d8:	6a 00                	push   $0x0
  8020da:	6a 03                	push   $0x3
  8020dc:	e8 20 fc ff ff       	call   801d01 <syscall>
  8020e1:	83 c4 18             	add    $0x18,%esp
}
  8020e4:	c9                   	leave  
  8020e5:	c3                   	ret    

008020e6 <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  8020e6:	55                   	push   %ebp
  8020e7:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  8020e9:	6a 00                	push   $0x0
  8020eb:	6a 00                	push   $0x0
  8020ed:	6a 00                	push   $0x0
  8020ef:	6a 00                	push   $0x0
  8020f1:	6a 00                	push   $0x0
  8020f3:	6a 04                	push   $0x4
  8020f5:	e8 07 fc ff ff       	call   801d01 <syscall>
  8020fa:	83 c4 18             	add    $0x18,%esp
}
  8020fd:	c9                   	leave  
  8020fe:	c3                   	ret    

008020ff <sys_exit_env>:


void sys_exit_env(void)
{
  8020ff:	55                   	push   %ebp
  802100:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  802102:	6a 00                	push   $0x0
  802104:	6a 00                	push   $0x0
  802106:	6a 00                	push   $0x0
  802108:	6a 00                	push   $0x0
  80210a:	6a 00                	push   $0x0
  80210c:	6a 23                	push   $0x23
  80210e:	e8 ee fb ff ff       	call   801d01 <syscall>
  802113:	83 c4 18             	add    $0x18,%esp
}
  802116:	90                   	nop
  802117:	c9                   	leave  
  802118:	c3                   	ret    

00802119 <sys_get_virtual_time>:


struct uint64
sys_get_virtual_time()
{
  802119:	55                   	push   %ebp
  80211a:	89 e5                	mov    %esp,%ebp
  80211c:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  80211f:	8d 45 f8             	lea    -0x8(%ebp),%eax
  802122:	8d 50 04             	lea    0x4(%eax),%edx
  802125:	8d 45 f8             	lea    -0x8(%ebp),%eax
  802128:	6a 00                	push   $0x0
  80212a:	6a 00                	push   $0x0
  80212c:	6a 00                	push   $0x0
  80212e:	52                   	push   %edx
  80212f:	50                   	push   %eax
  802130:	6a 24                	push   $0x24
  802132:	e8 ca fb ff ff       	call   801d01 <syscall>
  802137:	83 c4 18             	add    $0x18,%esp
	return result;
  80213a:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80213d:	8b 45 f8             	mov    -0x8(%ebp),%eax
  802140:	8b 55 fc             	mov    -0x4(%ebp),%edx
  802143:	89 01                	mov    %eax,(%ecx)
  802145:	89 51 04             	mov    %edx,0x4(%ecx)
}
  802148:	8b 45 08             	mov    0x8(%ebp),%eax
  80214b:	c9                   	leave  
  80214c:	c2 04 00             	ret    $0x4

0080214f <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  80214f:	55                   	push   %ebp
  802150:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  802152:	6a 00                	push   $0x0
  802154:	6a 00                	push   $0x0
  802156:	ff 75 10             	pushl  0x10(%ebp)
  802159:	ff 75 0c             	pushl  0xc(%ebp)
  80215c:	ff 75 08             	pushl  0x8(%ebp)
  80215f:	6a 12                	push   $0x12
  802161:	e8 9b fb ff ff       	call   801d01 <syscall>
  802166:	83 c4 18             	add    $0x18,%esp
	return ;
  802169:	90                   	nop
}
  80216a:	c9                   	leave  
  80216b:	c3                   	ret    

0080216c <sys_rcr2>:
uint32 sys_rcr2()
{
  80216c:	55                   	push   %ebp
  80216d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  80216f:	6a 00                	push   $0x0
  802171:	6a 00                	push   $0x0
  802173:	6a 00                	push   $0x0
  802175:	6a 00                	push   $0x0
  802177:	6a 00                	push   $0x0
  802179:	6a 25                	push   $0x25
  80217b:	e8 81 fb ff ff       	call   801d01 <syscall>
  802180:	83 c4 18             	add    $0x18,%esp
}
  802183:	c9                   	leave  
  802184:	c3                   	ret    

00802185 <sys_bypassPageFault>:
void sys_bypassPageFault(uint8 instrLength)
{
  802185:	55                   	push   %ebp
  802186:	89 e5                	mov    %esp,%ebp
  802188:	83 ec 04             	sub    $0x4,%esp
  80218b:	8b 45 08             	mov    0x8(%ebp),%eax
  80218e:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  802191:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  802195:	6a 00                	push   $0x0
  802197:	6a 00                	push   $0x0
  802199:	6a 00                	push   $0x0
  80219b:	6a 00                	push   $0x0
  80219d:	50                   	push   %eax
  80219e:	6a 26                	push   $0x26
  8021a0:	e8 5c fb ff ff       	call   801d01 <syscall>
  8021a5:	83 c4 18             	add    $0x18,%esp
	return ;
  8021a8:	90                   	nop
}
  8021a9:	c9                   	leave  
  8021aa:	c3                   	ret    

008021ab <rsttst>:
void rsttst()
{
  8021ab:	55                   	push   %ebp
  8021ac:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  8021ae:	6a 00                	push   $0x0
  8021b0:	6a 00                	push   $0x0
  8021b2:	6a 00                	push   $0x0
  8021b4:	6a 00                	push   $0x0
  8021b6:	6a 00                	push   $0x0
  8021b8:	6a 28                	push   $0x28
  8021ba:	e8 42 fb ff ff       	call   801d01 <syscall>
  8021bf:	83 c4 18             	add    $0x18,%esp
	return ;
  8021c2:	90                   	nop
}
  8021c3:	c9                   	leave  
  8021c4:	c3                   	ret    

008021c5 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  8021c5:	55                   	push   %ebp
  8021c6:	89 e5                	mov    %esp,%ebp
  8021c8:	83 ec 04             	sub    $0x4,%esp
  8021cb:	8b 45 14             	mov    0x14(%ebp),%eax
  8021ce:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  8021d1:	8b 55 18             	mov    0x18(%ebp),%edx
  8021d4:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  8021d8:	52                   	push   %edx
  8021d9:	50                   	push   %eax
  8021da:	ff 75 10             	pushl  0x10(%ebp)
  8021dd:	ff 75 0c             	pushl  0xc(%ebp)
  8021e0:	ff 75 08             	pushl  0x8(%ebp)
  8021e3:	6a 27                	push   $0x27
  8021e5:	e8 17 fb ff ff       	call   801d01 <syscall>
  8021ea:	83 c4 18             	add    $0x18,%esp
	return ;
  8021ed:	90                   	nop
}
  8021ee:	c9                   	leave  
  8021ef:	c3                   	ret    

008021f0 <chktst>:
void chktst(uint32 n)
{
  8021f0:	55                   	push   %ebp
  8021f1:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  8021f3:	6a 00                	push   $0x0
  8021f5:	6a 00                	push   $0x0
  8021f7:	6a 00                	push   $0x0
  8021f9:	6a 00                	push   $0x0
  8021fb:	ff 75 08             	pushl  0x8(%ebp)
  8021fe:	6a 29                	push   $0x29
  802200:	e8 fc fa ff ff       	call   801d01 <syscall>
  802205:	83 c4 18             	add    $0x18,%esp
	return ;
  802208:	90                   	nop
}
  802209:	c9                   	leave  
  80220a:	c3                   	ret    

0080220b <inctst>:

void inctst()
{
  80220b:	55                   	push   %ebp
  80220c:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  80220e:	6a 00                	push   $0x0
  802210:	6a 00                	push   $0x0
  802212:	6a 00                	push   $0x0
  802214:	6a 00                	push   $0x0
  802216:	6a 00                	push   $0x0
  802218:	6a 2a                	push   $0x2a
  80221a:	e8 e2 fa ff ff       	call   801d01 <syscall>
  80221f:	83 c4 18             	add    $0x18,%esp
	return ;
  802222:	90                   	nop
}
  802223:	c9                   	leave  
  802224:	c3                   	ret    

00802225 <gettst>:
uint32 gettst()
{
  802225:	55                   	push   %ebp
  802226:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  802228:	6a 00                	push   $0x0
  80222a:	6a 00                	push   $0x0
  80222c:	6a 00                	push   $0x0
  80222e:	6a 00                	push   $0x0
  802230:	6a 00                	push   $0x0
  802232:	6a 2b                	push   $0x2b
  802234:	e8 c8 fa ff ff       	call   801d01 <syscall>
  802239:	83 c4 18             	add    $0x18,%esp
}
  80223c:	c9                   	leave  
  80223d:	c3                   	ret    

0080223e <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  80223e:	55                   	push   %ebp
  80223f:	89 e5                	mov    %esp,%ebp
  802241:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  802244:	6a 00                	push   $0x0
  802246:	6a 00                	push   $0x0
  802248:	6a 00                	push   $0x0
  80224a:	6a 00                	push   $0x0
  80224c:	6a 00                	push   $0x0
  80224e:	6a 2c                	push   $0x2c
  802250:	e8 ac fa ff ff       	call   801d01 <syscall>
  802255:	83 c4 18             	add    $0x18,%esp
  802258:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  80225b:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  80225f:	75 07                	jne    802268 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  802261:	b8 01 00 00 00       	mov    $0x1,%eax
  802266:	eb 05                	jmp    80226d <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  802268:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80226d:	c9                   	leave  
  80226e:	c3                   	ret    

0080226f <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  80226f:	55                   	push   %ebp
  802270:	89 e5                	mov    %esp,%ebp
  802272:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  802275:	6a 00                	push   $0x0
  802277:	6a 00                	push   $0x0
  802279:	6a 00                	push   $0x0
  80227b:	6a 00                	push   $0x0
  80227d:	6a 00                	push   $0x0
  80227f:	6a 2c                	push   $0x2c
  802281:	e8 7b fa ff ff       	call   801d01 <syscall>
  802286:	83 c4 18             	add    $0x18,%esp
  802289:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  80228c:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  802290:	75 07                	jne    802299 <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  802292:	b8 01 00 00 00       	mov    $0x1,%eax
  802297:	eb 05                	jmp    80229e <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  802299:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80229e:	c9                   	leave  
  80229f:	c3                   	ret    

008022a0 <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  8022a0:	55                   	push   %ebp
  8022a1:	89 e5                	mov    %esp,%ebp
  8022a3:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8022a6:	6a 00                	push   $0x0
  8022a8:	6a 00                	push   $0x0
  8022aa:	6a 00                	push   $0x0
  8022ac:	6a 00                	push   $0x0
  8022ae:	6a 00                	push   $0x0
  8022b0:	6a 2c                	push   $0x2c
  8022b2:	e8 4a fa ff ff       	call   801d01 <syscall>
  8022b7:	83 c4 18             	add    $0x18,%esp
  8022ba:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  8022bd:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  8022c1:	75 07                	jne    8022ca <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  8022c3:	b8 01 00 00 00       	mov    $0x1,%eax
  8022c8:	eb 05                	jmp    8022cf <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  8022ca:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8022cf:	c9                   	leave  
  8022d0:	c3                   	ret    

008022d1 <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  8022d1:	55                   	push   %ebp
  8022d2:	89 e5                	mov    %esp,%ebp
  8022d4:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8022d7:	6a 00                	push   $0x0
  8022d9:	6a 00                	push   $0x0
  8022db:	6a 00                	push   $0x0
  8022dd:	6a 00                	push   $0x0
  8022df:	6a 00                	push   $0x0
  8022e1:	6a 2c                	push   $0x2c
  8022e3:	e8 19 fa ff ff       	call   801d01 <syscall>
  8022e8:	83 c4 18             	add    $0x18,%esp
  8022eb:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  8022ee:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  8022f2:	75 07                	jne    8022fb <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  8022f4:	b8 01 00 00 00       	mov    $0x1,%eax
  8022f9:	eb 05                	jmp    802300 <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  8022fb:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802300:	c9                   	leave  
  802301:	c3                   	ret    

00802302 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  802302:	55                   	push   %ebp
  802303:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  802305:	6a 00                	push   $0x0
  802307:	6a 00                	push   $0x0
  802309:	6a 00                	push   $0x0
  80230b:	6a 00                	push   $0x0
  80230d:	ff 75 08             	pushl  0x8(%ebp)
  802310:	6a 2d                	push   $0x2d
  802312:	e8 ea f9 ff ff       	call   801d01 <syscall>
  802317:	83 c4 18             	add    $0x18,%esp
	return ;
  80231a:	90                   	nop
}
  80231b:	c9                   	leave  
  80231c:	c3                   	ret    

0080231d <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  80231d:	55                   	push   %ebp
  80231e:	89 e5                	mov    %esp,%ebp
  802320:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  802321:	8b 5d 14             	mov    0x14(%ebp),%ebx
  802324:	8b 4d 10             	mov    0x10(%ebp),%ecx
  802327:	8b 55 0c             	mov    0xc(%ebp),%edx
  80232a:	8b 45 08             	mov    0x8(%ebp),%eax
  80232d:	6a 00                	push   $0x0
  80232f:	53                   	push   %ebx
  802330:	51                   	push   %ecx
  802331:	52                   	push   %edx
  802332:	50                   	push   %eax
  802333:	6a 2e                	push   $0x2e
  802335:	e8 c7 f9 ff ff       	call   801d01 <syscall>
  80233a:	83 c4 18             	add    $0x18,%esp
}
  80233d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802340:	c9                   	leave  
  802341:	c3                   	ret    

00802342 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  802342:	55                   	push   %ebp
  802343:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  802345:	8b 55 0c             	mov    0xc(%ebp),%edx
  802348:	8b 45 08             	mov    0x8(%ebp),%eax
  80234b:	6a 00                	push   $0x0
  80234d:	6a 00                	push   $0x0
  80234f:	6a 00                	push   $0x0
  802351:	52                   	push   %edx
  802352:	50                   	push   %eax
  802353:	6a 2f                	push   $0x2f
  802355:	e8 a7 f9 ff ff       	call   801d01 <syscall>
  80235a:	83 c4 18             	add    $0x18,%esp
}
  80235d:	c9                   	leave  
  80235e:	c3                   	ret    

0080235f <print_mem_block_lists>:
//===========================
// PRINT MEM BLOCK LISTS:
//===========================

void print_mem_block_lists()
{
  80235f:	55                   	push   %ebp
  802360:	89 e5                	mov    %esp,%ebp
  802362:	83 ec 18             	sub    $0x18,%esp
	cprintf("\n=========================================\n");
  802365:	83 ec 0c             	sub    $0xc,%esp
  802368:	68 40 3e 80 00       	push   $0x803e40
  80236d:	e8 dd e6 ff ff       	call   800a4f <cprintf>
  802372:	83 c4 10             	add    $0x10,%esp
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
  802375:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nFreeMemBlocksList:\n");
  80237c:	83 ec 0c             	sub    $0xc,%esp
  80237f:	68 6c 3e 80 00       	push   $0x803e6c
  802384:	e8 c6 e6 ff ff       	call   800a4f <cprintf>
  802389:	83 c4 10             	add    $0x10,%esp
	uint8 sorted = 1 ;
  80238c:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &FreeMemBlocksList)
  802390:	a1 38 41 80 00       	mov    0x804138,%eax
  802395:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802398:	eb 56                	jmp    8023f0 <print_mem_block_lists+0x91>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  80239a:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80239e:	74 1c                	je     8023bc <print_mem_block_lists+0x5d>
  8023a0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023a3:	8b 50 08             	mov    0x8(%eax),%edx
  8023a6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8023a9:	8b 48 08             	mov    0x8(%eax),%ecx
  8023ac:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8023af:	8b 40 0c             	mov    0xc(%eax),%eax
  8023b2:	01 c8                	add    %ecx,%eax
  8023b4:	39 c2                	cmp    %eax,%edx
  8023b6:	73 04                	jae    8023bc <print_mem_block_lists+0x5d>
			sorted = 0 ;
  8023b8:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  8023bc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023bf:	8b 50 08             	mov    0x8(%eax),%edx
  8023c2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023c5:	8b 40 0c             	mov    0xc(%eax),%eax
  8023c8:	01 c2                	add    %eax,%edx
  8023ca:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023cd:	8b 40 08             	mov    0x8(%eax),%eax
  8023d0:	83 ec 04             	sub    $0x4,%esp
  8023d3:	52                   	push   %edx
  8023d4:	50                   	push   %eax
  8023d5:	68 81 3e 80 00       	push   $0x803e81
  8023da:	e8 70 e6 ff ff       	call   800a4f <cprintf>
  8023df:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  8023e2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023e5:	89 45 f0             	mov    %eax,-0x10(%ebp)
	cprintf("\n=========================================\n");
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
	cprintf("\nFreeMemBlocksList:\n");
	uint8 sorted = 1 ;
	LIST_FOREACH(blk, &FreeMemBlocksList)
  8023e8:	a1 40 41 80 00       	mov    0x804140,%eax
  8023ed:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8023f0:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8023f4:	74 07                	je     8023fd <print_mem_block_lists+0x9e>
  8023f6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023f9:	8b 00                	mov    (%eax),%eax
  8023fb:	eb 05                	jmp    802402 <print_mem_block_lists+0xa3>
  8023fd:	b8 00 00 00 00       	mov    $0x0,%eax
  802402:	a3 40 41 80 00       	mov    %eax,0x804140
  802407:	a1 40 41 80 00       	mov    0x804140,%eax
  80240c:	85 c0                	test   %eax,%eax
  80240e:	75 8a                	jne    80239a <print_mem_block_lists+0x3b>
  802410:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802414:	75 84                	jne    80239a <print_mem_block_lists+0x3b>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;
  802416:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  80241a:	75 10                	jne    80242c <print_mem_block_lists+0xcd>
  80241c:	83 ec 0c             	sub    $0xc,%esp
  80241f:	68 90 3e 80 00       	push   $0x803e90
  802424:	e8 26 e6 ff ff       	call   800a4f <cprintf>
  802429:	83 c4 10             	add    $0x10,%esp

	lastBlk = NULL ;
  80242c:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nAllocMemBlocksList:\n");
  802433:	83 ec 0c             	sub    $0xc,%esp
  802436:	68 b4 3e 80 00       	push   $0x803eb4
  80243b:	e8 0f e6 ff ff       	call   800a4f <cprintf>
  802440:	83 c4 10             	add    $0x10,%esp
	sorted = 1 ;
  802443:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &AllocMemBlocksList)
  802447:	a1 40 40 80 00       	mov    0x804040,%eax
  80244c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80244f:	eb 56                	jmp    8024a7 <print_mem_block_lists+0x148>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  802451:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802455:	74 1c                	je     802473 <print_mem_block_lists+0x114>
  802457:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80245a:	8b 50 08             	mov    0x8(%eax),%edx
  80245d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802460:	8b 48 08             	mov    0x8(%eax),%ecx
  802463:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802466:	8b 40 0c             	mov    0xc(%eax),%eax
  802469:	01 c8                	add    %ecx,%eax
  80246b:	39 c2                	cmp    %eax,%edx
  80246d:	73 04                	jae    802473 <print_mem_block_lists+0x114>
			sorted = 0 ;
  80246f:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  802473:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802476:	8b 50 08             	mov    0x8(%eax),%edx
  802479:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80247c:	8b 40 0c             	mov    0xc(%eax),%eax
  80247f:	01 c2                	add    %eax,%edx
  802481:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802484:	8b 40 08             	mov    0x8(%eax),%eax
  802487:	83 ec 04             	sub    $0x4,%esp
  80248a:	52                   	push   %edx
  80248b:	50                   	push   %eax
  80248c:	68 81 3e 80 00       	push   $0x803e81
  802491:	e8 b9 e5 ff ff       	call   800a4f <cprintf>
  802496:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  802499:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80249c:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;

	lastBlk = NULL ;
	cprintf("\nAllocMemBlocksList:\n");
	sorted = 1 ;
	LIST_FOREACH(blk, &AllocMemBlocksList)
  80249f:	a1 48 40 80 00       	mov    0x804048,%eax
  8024a4:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8024a7:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8024ab:	74 07                	je     8024b4 <print_mem_block_lists+0x155>
  8024ad:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024b0:	8b 00                	mov    (%eax),%eax
  8024b2:	eb 05                	jmp    8024b9 <print_mem_block_lists+0x15a>
  8024b4:	b8 00 00 00 00       	mov    $0x0,%eax
  8024b9:	a3 48 40 80 00       	mov    %eax,0x804048
  8024be:	a1 48 40 80 00       	mov    0x804048,%eax
  8024c3:	85 c0                	test   %eax,%eax
  8024c5:	75 8a                	jne    802451 <print_mem_block_lists+0xf2>
  8024c7:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8024cb:	75 84                	jne    802451 <print_mem_block_lists+0xf2>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nAllocMemBlocksList is NOT SORTED!!\n") ;
  8024cd:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  8024d1:	75 10                	jne    8024e3 <print_mem_block_lists+0x184>
  8024d3:	83 ec 0c             	sub    $0xc,%esp
  8024d6:	68 cc 3e 80 00       	push   $0x803ecc
  8024db:	e8 6f e5 ff ff       	call   800a4f <cprintf>
  8024e0:	83 c4 10             	add    $0x10,%esp
	cprintf("\n=========================================\n");
  8024e3:	83 ec 0c             	sub    $0xc,%esp
  8024e6:	68 40 3e 80 00       	push   $0x803e40
  8024eb:	e8 5f e5 ff ff       	call   800a4f <cprintf>
  8024f0:	83 c4 10             	add    $0x10,%esp

}
  8024f3:	90                   	nop
  8024f4:	c9                   	leave  
  8024f5:	c3                   	ret    

008024f6 <initialize_MemBlocksList>:

//===============================
// [1] INITIALIZE AVAILABLE LIST:
//===============================
void initialize_MemBlocksList(uint32 numOfBlocks)
{
  8024f6:	55                   	push   %ebp
  8024f7:	89 e5                	mov    %esp,%ebp
  8024f9:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] initialize_MemBlocksList
	// Write your code here, remove the panic and write your code
	//panic("initialize_MemBlocksList() is not implemented yet...!!");
	uint32 n = numOfBlocks;
  8024fc:	8b 45 08             	mov    0x8(%ebp),%eax
  8024ff:	89 45 f0             	mov    %eax,-0x10(%ebp)

	LIST_INIT(&AvailableMemBlocksList);
  802502:	c7 05 48 41 80 00 00 	movl   $0x0,0x804148
  802509:	00 00 00 
  80250c:	c7 05 4c 41 80 00 00 	movl   $0x0,0x80414c
  802513:	00 00 00 
  802516:	c7 05 54 41 80 00 00 	movl   $0x0,0x804154
  80251d:	00 00 00 
	for(int i = 0; i<n;i++)
  802520:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  802527:	e9 9e 00 00 00       	jmp    8025ca <initialize_MemBlocksList+0xd4>
	{
		LIST_INSERT_HEAD(&AvailableMemBlocksList, &(MemBlockNodes[i]));
  80252c:	a1 50 40 80 00       	mov    0x804050,%eax
  802531:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802534:	c1 e2 04             	shl    $0x4,%edx
  802537:	01 d0                	add    %edx,%eax
  802539:	85 c0                	test   %eax,%eax
  80253b:	75 14                	jne    802551 <initialize_MemBlocksList+0x5b>
  80253d:	83 ec 04             	sub    $0x4,%esp
  802540:	68 f4 3e 80 00       	push   $0x803ef4
  802545:	6a 47                	push   $0x47
  802547:	68 17 3f 80 00       	push   $0x803f17
  80254c:	e8 4a e2 ff ff       	call   80079b <_panic>
  802551:	a1 50 40 80 00       	mov    0x804050,%eax
  802556:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802559:	c1 e2 04             	shl    $0x4,%edx
  80255c:	01 d0                	add    %edx,%eax
  80255e:	8b 15 48 41 80 00    	mov    0x804148,%edx
  802564:	89 10                	mov    %edx,(%eax)
  802566:	8b 00                	mov    (%eax),%eax
  802568:	85 c0                	test   %eax,%eax
  80256a:	74 18                	je     802584 <initialize_MemBlocksList+0x8e>
  80256c:	a1 48 41 80 00       	mov    0x804148,%eax
  802571:	8b 15 50 40 80 00    	mov    0x804050,%edx
  802577:	8b 4d f4             	mov    -0xc(%ebp),%ecx
  80257a:	c1 e1 04             	shl    $0x4,%ecx
  80257d:	01 ca                	add    %ecx,%edx
  80257f:	89 50 04             	mov    %edx,0x4(%eax)
  802582:	eb 12                	jmp    802596 <initialize_MemBlocksList+0xa0>
  802584:	a1 50 40 80 00       	mov    0x804050,%eax
  802589:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80258c:	c1 e2 04             	shl    $0x4,%edx
  80258f:	01 d0                	add    %edx,%eax
  802591:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802596:	a1 50 40 80 00       	mov    0x804050,%eax
  80259b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80259e:	c1 e2 04             	shl    $0x4,%edx
  8025a1:	01 d0                	add    %edx,%eax
  8025a3:	a3 48 41 80 00       	mov    %eax,0x804148
  8025a8:	a1 50 40 80 00       	mov    0x804050,%eax
  8025ad:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8025b0:	c1 e2 04             	shl    $0x4,%edx
  8025b3:	01 d0                	add    %edx,%eax
  8025b5:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8025bc:	a1 54 41 80 00       	mov    0x804154,%eax
  8025c1:	40                   	inc    %eax
  8025c2:	a3 54 41 80 00       	mov    %eax,0x804154
	// Write your code here, remove the panic and write your code
	//panic("initialize_MemBlocksList() is not implemented yet...!!");
	uint32 n = numOfBlocks;

	LIST_INIT(&AvailableMemBlocksList);
	for(int i = 0; i<n;i++)
  8025c7:	ff 45 f4             	incl   -0xc(%ebp)
  8025ca:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025cd:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8025d0:	0f 82 56 ff ff ff    	jb     80252c <initialize_MemBlocksList+0x36>
	{
		LIST_INSERT_HEAD(&AvailableMemBlocksList, &(MemBlockNodes[i]));
	}
}
  8025d6:	90                   	nop
  8025d7:	c9                   	leave  
  8025d8:	c3                   	ret    

008025d9 <find_block>:

//===============================
// [2] FIND BLOCK:
//===============================
struct MemBlock *find_block(struct MemBlock_List *blockList, uint32 va)
{
  8025d9:	55                   	push   %ebp
  8025da:	89 e5                	mov    %esp,%ebp
  8025dc:	83 ec 10             	sub    $0x10,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] find_block
	// Write your code here, remove the panic and write your code
	//panic("find_block() is not implemented yet...!!");
	uint32 virAddress = va;
  8025df:	8b 45 0c             	mov    0xc(%ebp),%eax
  8025e2:	89 45 f4             	mov    %eax,-0xc(%ebp)
	struct MemBlock* blk;
	int found = 0;
  8025e5:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	LIST_FOREACH(blk, &(AllocMemBlocksList))
  8025ec:	a1 40 40 80 00       	mov    0x804040,%eax
  8025f1:	89 45 fc             	mov    %eax,-0x4(%ebp)
  8025f4:	eb 23                	jmp    802619 <find_block+0x40>
	{
		if(blk->sva == virAddress)
  8025f6:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8025f9:	8b 40 08             	mov    0x8(%eax),%eax
  8025fc:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  8025ff:	75 09                	jne    80260a <find_block+0x31>
		{
			found = 1;
  802601:	c7 45 f8 01 00 00 00 	movl   $0x1,-0x8(%ebp)
			break;
  802608:	eb 35                	jmp    80263f <find_block+0x66>
		}
		else
		{
			found = 0;
  80260a:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	//panic("find_block() is not implemented yet...!!");
	uint32 virAddress = va;
	struct MemBlock* blk;
	int found = 0;

	LIST_FOREACH(blk, &(AllocMemBlocksList))
  802611:	a1 48 40 80 00       	mov    0x804048,%eax
  802616:	89 45 fc             	mov    %eax,-0x4(%ebp)
  802619:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  80261d:	74 07                	je     802626 <find_block+0x4d>
  80261f:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802622:	8b 00                	mov    (%eax),%eax
  802624:	eb 05                	jmp    80262b <find_block+0x52>
  802626:	b8 00 00 00 00       	mov    $0x0,%eax
  80262b:	a3 48 40 80 00       	mov    %eax,0x804048
  802630:	a1 48 40 80 00       	mov    0x804048,%eax
  802635:	85 c0                	test   %eax,%eax
  802637:	75 bd                	jne    8025f6 <find_block+0x1d>
  802639:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  80263d:	75 b7                	jne    8025f6 <find_block+0x1d>
		{
			found = 0;
			continue;
		}
	}
	if(found == 1)
  80263f:	83 7d f8 01          	cmpl   $0x1,-0x8(%ebp)
  802643:	75 05                	jne    80264a <find_block+0x71>
	{
		return blk;
  802645:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802648:	eb 05                	jmp    80264f <find_block+0x76>
	}
	else
	{
		return NULL;
  80264a:	b8 00 00 00 00       	mov    $0x0,%eax
	}
}
  80264f:	c9                   	leave  
  802650:	c3                   	ret    

00802651 <insert_sorted_allocList>:

//=========================================
// [3] INSERT BLOCK IN ALLOC LIST [SORTED]:
//=========================================
void insert_sorted_allocList(struct MemBlock *blockToInsert)
{
  802651:	55                   	push   %ebp
  802652:	89 e5                	mov    %esp,%ebp
  802654:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] insert_sorted_allocList
	// Write your code here, remove the panic and write your code
	//panic("insert_sorted_allocList() is not implemented yet...!!");
	struct MemBlock* blk;
	struct MemBlock* newblk = blockToInsert;
  802657:	8b 45 08             	mov    0x8(%ebp),%eax
  80265a:	89 45 f0             	mov    %eax,-0x10(%ebp)

	if((LIST_EMPTY(&AllocMemBlocksList)) || (newblk->sva < LIST_FIRST(&AllocMemBlocksList)->sva))
  80265d:	a1 40 40 80 00       	mov    0x804040,%eax
  802662:	85 c0                	test   %eax,%eax
  802664:	74 12                	je     802678 <insert_sorted_allocList+0x27>
  802666:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802669:	8b 50 08             	mov    0x8(%eax),%edx
  80266c:	a1 40 40 80 00       	mov    0x804040,%eax
  802671:	8b 40 08             	mov    0x8(%eax),%eax
  802674:	39 c2                	cmp    %eax,%edx
  802676:	73 65                	jae    8026dd <insert_sorted_allocList+0x8c>
	{
		LIST_INSERT_HEAD(&(AllocMemBlocksList), newblk);
  802678:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80267c:	75 14                	jne    802692 <insert_sorted_allocList+0x41>
  80267e:	83 ec 04             	sub    $0x4,%esp
  802681:	68 f4 3e 80 00       	push   $0x803ef4
  802686:	6a 7b                	push   $0x7b
  802688:	68 17 3f 80 00       	push   $0x803f17
  80268d:	e8 09 e1 ff ff       	call   80079b <_panic>
  802692:	8b 15 40 40 80 00    	mov    0x804040,%edx
  802698:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80269b:	89 10                	mov    %edx,(%eax)
  80269d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8026a0:	8b 00                	mov    (%eax),%eax
  8026a2:	85 c0                	test   %eax,%eax
  8026a4:	74 0d                	je     8026b3 <insert_sorted_allocList+0x62>
  8026a6:	a1 40 40 80 00       	mov    0x804040,%eax
  8026ab:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8026ae:	89 50 04             	mov    %edx,0x4(%eax)
  8026b1:	eb 08                	jmp    8026bb <insert_sorted_allocList+0x6a>
  8026b3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8026b6:	a3 44 40 80 00       	mov    %eax,0x804044
  8026bb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8026be:	a3 40 40 80 00       	mov    %eax,0x804040
  8026c3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8026c6:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8026cd:	a1 4c 40 80 00       	mov    0x80404c,%eax
  8026d2:	40                   	inc    %eax
  8026d3:	a3 4c 40 80 00       	mov    %eax,0x80404c
  8026d8:	e9 5f 01 00 00       	jmp    80283c <insert_sorted_allocList+0x1eb>
	}
	else if(newblk->sva > LIST_LAST(&AllocMemBlocksList)->sva)
  8026dd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8026e0:	8b 50 08             	mov    0x8(%eax),%edx
  8026e3:	a1 44 40 80 00       	mov    0x804044,%eax
  8026e8:	8b 40 08             	mov    0x8(%eax),%eax
  8026eb:	39 c2                	cmp    %eax,%edx
  8026ed:	76 65                	jbe    802754 <insert_sorted_allocList+0x103>
	{
		LIST_INSERT_TAIL(&AllocMemBlocksList, newblk);
  8026ef:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8026f3:	75 14                	jne    802709 <insert_sorted_allocList+0xb8>
  8026f5:	83 ec 04             	sub    $0x4,%esp
  8026f8:	68 30 3f 80 00       	push   $0x803f30
  8026fd:	6a 7f                	push   $0x7f
  8026ff:	68 17 3f 80 00       	push   $0x803f17
  802704:	e8 92 e0 ff ff       	call   80079b <_panic>
  802709:	8b 15 44 40 80 00    	mov    0x804044,%edx
  80270f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802712:	89 50 04             	mov    %edx,0x4(%eax)
  802715:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802718:	8b 40 04             	mov    0x4(%eax),%eax
  80271b:	85 c0                	test   %eax,%eax
  80271d:	74 0c                	je     80272b <insert_sorted_allocList+0xda>
  80271f:	a1 44 40 80 00       	mov    0x804044,%eax
  802724:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802727:	89 10                	mov    %edx,(%eax)
  802729:	eb 08                	jmp    802733 <insert_sorted_allocList+0xe2>
  80272b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80272e:	a3 40 40 80 00       	mov    %eax,0x804040
  802733:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802736:	a3 44 40 80 00       	mov    %eax,0x804044
  80273b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80273e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802744:	a1 4c 40 80 00       	mov    0x80404c,%eax
  802749:	40                   	inc    %eax
  80274a:	a3 4c 40 80 00       	mov    %eax,0x80404c
				LIST_INSERT_AFTER(&AllocMemBlocksList, blk, newblk);
				break;
			}
		}
	}
}
  80274f:	e9 e8 00 00 00       	jmp    80283c <insert_sorted_allocList+0x1eb>
	{
		LIST_INSERT_TAIL(&AllocMemBlocksList, newblk);
	}
	else
	{
		LIST_FOREACH(blk, &AllocMemBlocksList)
  802754:	a1 40 40 80 00       	mov    0x804040,%eax
  802759:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80275c:	e9 ab 00 00 00       	jmp    80280c <insert_sorted_allocList+0x1bb>
		{
			if(blk->prev_next_info.le_next != NULL && newblk->sva > blk->sva  && newblk->sva < blk->prev_next_info.le_next->sva)
  802761:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802764:	8b 00                	mov    (%eax),%eax
  802766:	85 c0                	test   %eax,%eax
  802768:	0f 84 96 00 00 00    	je     802804 <insert_sorted_allocList+0x1b3>
  80276e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802771:	8b 50 08             	mov    0x8(%eax),%edx
  802774:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802777:	8b 40 08             	mov    0x8(%eax),%eax
  80277a:	39 c2                	cmp    %eax,%edx
  80277c:	0f 86 82 00 00 00    	jbe    802804 <insert_sorted_allocList+0x1b3>
  802782:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802785:	8b 50 08             	mov    0x8(%eax),%edx
  802788:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80278b:	8b 00                	mov    (%eax),%eax
  80278d:	8b 40 08             	mov    0x8(%eax),%eax
  802790:	39 c2                	cmp    %eax,%edx
  802792:	73 70                	jae    802804 <insert_sorted_allocList+0x1b3>
			{
				LIST_INSERT_AFTER(&AllocMemBlocksList, blk, newblk);
  802794:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802798:	74 06                	je     8027a0 <insert_sorted_allocList+0x14f>
  80279a:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80279e:	75 17                	jne    8027b7 <insert_sorted_allocList+0x166>
  8027a0:	83 ec 04             	sub    $0x4,%esp
  8027a3:	68 54 3f 80 00       	push   $0x803f54
  8027a8:	68 87 00 00 00       	push   $0x87
  8027ad:	68 17 3f 80 00       	push   $0x803f17
  8027b2:	e8 e4 df ff ff       	call   80079b <_panic>
  8027b7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027ba:	8b 10                	mov    (%eax),%edx
  8027bc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8027bf:	89 10                	mov    %edx,(%eax)
  8027c1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8027c4:	8b 00                	mov    (%eax),%eax
  8027c6:	85 c0                	test   %eax,%eax
  8027c8:	74 0b                	je     8027d5 <insert_sorted_allocList+0x184>
  8027ca:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027cd:	8b 00                	mov    (%eax),%eax
  8027cf:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8027d2:	89 50 04             	mov    %edx,0x4(%eax)
  8027d5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027d8:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8027db:	89 10                	mov    %edx,(%eax)
  8027dd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8027e0:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8027e3:	89 50 04             	mov    %edx,0x4(%eax)
  8027e6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8027e9:	8b 00                	mov    (%eax),%eax
  8027eb:	85 c0                	test   %eax,%eax
  8027ed:	75 08                	jne    8027f7 <insert_sorted_allocList+0x1a6>
  8027ef:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8027f2:	a3 44 40 80 00       	mov    %eax,0x804044
  8027f7:	a1 4c 40 80 00       	mov    0x80404c,%eax
  8027fc:	40                   	inc    %eax
  8027fd:	a3 4c 40 80 00       	mov    %eax,0x80404c
				break;
  802802:	eb 38                	jmp    80283c <insert_sorted_allocList+0x1eb>
	{
		LIST_INSERT_TAIL(&AllocMemBlocksList, newblk);
	}
	else
	{
		LIST_FOREACH(blk, &AllocMemBlocksList)
  802804:	a1 48 40 80 00       	mov    0x804048,%eax
  802809:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80280c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802810:	74 07                	je     802819 <insert_sorted_allocList+0x1c8>
  802812:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802815:	8b 00                	mov    (%eax),%eax
  802817:	eb 05                	jmp    80281e <insert_sorted_allocList+0x1cd>
  802819:	b8 00 00 00 00       	mov    $0x0,%eax
  80281e:	a3 48 40 80 00       	mov    %eax,0x804048
  802823:	a1 48 40 80 00       	mov    0x804048,%eax
  802828:	85 c0                	test   %eax,%eax
  80282a:	0f 85 31 ff ff ff    	jne    802761 <insert_sorted_allocList+0x110>
  802830:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802834:	0f 85 27 ff ff ff    	jne    802761 <insert_sorted_allocList+0x110>
				LIST_INSERT_AFTER(&AllocMemBlocksList, blk, newblk);
				break;
			}
		}
	}
}
  80283a:	eb 00                	jmp    80283c <insert_sorted_allocList+0x1eb>
  80283c:	90                   	nop
  80283d:	c9                   	leave  
  80283e:	c3                   	ret    

0080283f <alloc_block_FF>:

//=========================================
// [4] ALLOCATE BLOCK BY FIRST FIT:
//=========================================
struct MemBlock *alloc_block_FF(uint32 size)
{
  80283f:	55                   	push   %ebp
  802840:	89 e5                	mov    %esp,%ebp
  802842:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_FF
	// Write your code here, remove the panic and write your code
	//panic("alloc_block_FF() is not implemented yet...!!");
	uint32 versize = size;
  802845:	8b 45 08             	mov    0x8(%ebp),%eax
  802848:	89 45 f0             	mov    %eax,-0x10(%ebp)
	struct MemBlock* blk;
	struct MemBlock* newblk = LIST_FIRST(&AvailableMemBlocksList);
  80284b:	a1 48 41 80 00       	mov    0x804148,%eax
  802850:	89 45 ec             	mov    %eax,-0x14(%ebp)

	LIST_FOREACH(blk,&FreeMemBlocksList)
  802853:	a1 38 41 80 00       	mov    0x804138,%eax
  802858:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80285b:	e9 77 01 00 00       	jmp    8029d7 <alloc_block_FF+0x198>
	{
		if(blk->size == versize)
  802860:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802863:	8b 40 0c             	mov    0xc(%eax),%eax
  802866:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  802869:	0f 85 8a 00 00 00    	jne    8028f9 <alloc_block_FF+0xba>
		{
			LIST_REMOVE(&FreeMemBlocksList,blk);
  80286f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802873:	75 17                	jne    80288c <alloc_block_FF+0x4d>
  802875:	83 ec 04             	sub    $0x4,%esp
  802878:	68 88 3f 80 00       	push   $0x803f88
  80287d:	68 9e 00 00 00       	push   $0x9e
  802882:	68 17 3f 80 00       	push   $0x803f17
  802887:	e8 0f df ff ff       	call   80079b <_panic>
  80288c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80288f:	8b 00                	mov    (%eax),%eax
  802891:	85 c0                	test   %eax,%eax
  802893:	74 10                	je     8028a5 <alloc_block_FF+0x66>
  802895:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802898:	8b 00                	mov    (%eax),%eax
  80289a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80289d:	8b 52 04             	mov    0x4(%edx),%edx
  8028a0:	89 50 04             	mov    %edx,0x4(%eax)
  8028a3:	eb 0b                	jmp    8028b0 <alloc_block_FF+0x71>
  8028a5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028a8:	8b 40 04             	mov    0x4(%eax),%eax
  8028ab:	a3 3c 41 80 00       	mov    %eax,0x80413c
  8028b0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028b3:	8b 40 04             	mov    0x4(%eax),%eax
  8028b6:	85 c0                	test   %eax,%eax
  8028b8:	74 0f                	je     8028c9 <alloc_block_FF+0x8a>
  8028ba:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028bd:	8b 40 04             	mov    0x4(%eax),%eax
  8028c0:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8028c3:	8b 12                	mov    (%edx),%edx
  8028c5:	89 10                	mov    %edx,(%eax)
  8028c7:	eb 0a                	jmp    8028d3 <alloc_block_FF+0x94>
  8028c9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028cc:	8b 00                	mov    (%eax),%eax
  8028ce:	a3 38 41 80 00       	mov    %eax,0x804138
  8028d3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028d6:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8028dc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028df:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8028e6:	a1 44 41 80 00       	mov    0x804144,%eax
  8028eb:	48                   	dec    %eax
  8028ec:	a3 44 41 80 00       	mov    %eax,0x804144
			return blk;
  8028f1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028f4:	e9 11 01 00 00       	jmp    802a0a <alloc_block_FF+0x1cb>
		}
		else if(blk->size > versize)
  8028f9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028fc:	8b 40 0c             	mov    0xc(%eax),%eax
  8028ff:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  802902:	0f 86 c7 00 00 00    	jbe    8029cf <alloc_block_FF+0x190>
		{
			LIST_REMOVE(&AvailableMemBlocksList,newblk);
  802908:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  80290c:	75 17                	jne    802925 <alloc_block_FF+0xe6>
  80290e:	83 ec 04             	sub    $0x4,%esp
  802911:	68 88 3f 80 00       	push   $0x803f88
  802916:	68 a3 00 00 00       	push   $0xa3
  80291b:	68 17 3f 80 00       	push   $0x803f17
  802920:	e8 76 de ff ff       	call   80079b <_panic>
  802925:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802928:	8b 00                	mov    (%eax),%eax
  80292a:	85 c0                	test   %eax,%eax
  80292c:	74 10                	je     80293e <alloc_block_FF+0xff>
  80292e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802931:	8b 00                	mov    (%eax),%eax
  802933:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802936:	8b 52 04             	mov    0x4(%edx),%edx
  802939:	89 50 04             	mov    %edx,0x4(%eax)
  80293c:	eb 0b                	jmp    802949 <alloc_block_FF+0x10a>
  80293e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802941:	8b 40 04             	mov    0x4(%eax),%eax
  802944:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802949:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80294c:	8b 40 04             	mov    0x4(%eax),%eax
  80294f:	85 c0                	test   %eax,%eax
  802951:	74 0f                	je     802962 <alloc_block_FF+0x123>
  802953:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802956:	8b 40 04             	mov    0x4(%eax),%eax
  802959:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80295c:	8b 12                	mov    (%edx),%edx
  80295e:	89 10                	mov    %edx,(%eax)
  802960:	eb 0a                	jmp    80296c <alloc_block_FF+0x12d>
  802962:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802965:	8b 00                	mov    (%eax),%eax
  802967:	a3 48 41 80 00       	mov    %eax,0x804148
  80296c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80296f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802975:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802978:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80297f:	a1 54 41 80 00       	mov    0x804154,%eax
  802984:	48                   	dec    %eax
  802985:	a3 54 41 80 00       	mov    %eax,0x804154
			newblk->size = versize;
  80298a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80298d:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802990:	89 50 0c             	mov    %edx,0xc(%eax)
			blk->size = blk->size-versize;
  802993:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802996:	8b 40 0c             	mov    0xc(%eax),%eax
  802999:	2b 45 f0             	sub    -0x10(%ebp),%eax
  80299c:	89 c2                	mov    %eax,%edx
  80299e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029a1:	89 50 0c             	mov    %edx,0xc(%eax)
			uint32 newveradd = blk->sva;
  8029a4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029a7:	8b 40 08             	mov    0x8(%eax),%eax
  8029aa:	89 45 e8             	mov    %eax,-0x18(%ebp)
			blk->sva+=newblk->size;
  8029ad:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029b0:	8b 50 08             	mov    0x8(%eax),%edx
  8029b3:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8029b6:	8b 40 0c             	mov    0xc(%eax),%eax
  8029b9:	01 c2                	add    %eax,%edx
  8029bb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029be:	89 50 08             	mov    %edx,0x8(%eax)
			newblk->sva = newveradd;
  8029c1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8029c4:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8029c7:	89 50 08             	mov    %edx,0x8(%eax)
			return newblk;
  8029ca:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8029cd:	eb 3b                	jmp    802a0a <alloc_block_FF+0x1cb>
	//panic("alloc_block_FF() is not implemented yet...!!");
	uint32 versize = size;
	struct MemBlock* blk;
	struct MemBlock* newblk = LIST_FIRST(&AvailableMemBlocksList);

	LIST_FOREACH(blk,&FreeMemBlocksList)
  8029cf:	a1 40 41 80 00       	mov    0x804140,%eax
  8029d4:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8029d7:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8029db:	74 07                	je     8029e4 <alloc_block_FF+0x1a5>
  8029dd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029e0:	8b 00                	mov    (%eax),%eax
  8029e2:	eb 05                	jmp    8029e9 <alloc_block_FF+0x1aa>
  8029e4:	b8 00 00 00 00       	mov    $0x0,%eax
  8029e9:	a3 40 41 80 00       	mov    %eax,0x804140
  8029ee:	a1 40 41 80 00       	mov    0x804140,%eax
  8029f3:	85 c0                	test   %eax,%eax
  8029f5:	0f 85 65 fe ff ff    	jne    802860 <alloc_block_FF+0x21>
  8029fb:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8029ff:	0f 85 5b fe ff ff    	jne    802860 <alloc_block_FF+0x21>
			blk->sva+=newblk->size;
			newblk->sva = newveradd;
			return newblk;
		}
	}
	return NULL;
  802a05:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802a0a:	c9                   	leave  
  802a0b:	c3                   	ret    

00802a0c <alloc_block_BF>:

//=========================================
// [5] ALLOCATE BLOCK BY BEST FIT:
//=========================================
struct MemBlock *alloc_block_BF(uint32 size)
{
  802a0c:	55                   	push   %ebp
  802a0d:	89 e5                	mov    %esp,%ebp
  802a0f:	83 ec 28             	sub    $0x28,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_BF
	// Write your code here, remove the panic and write your code
	//panic("alloc_block_BF() is not implemented yet...!!");
	uint32 versize=size;
  802a12:	8b 45 08             	mov    0x8(%ebp),%eax
  802a15:	89 45 e8             	mov    %eax,-0x18(%ebp)
	struct MemBlock* blk;
	struct MemBlock* newblk=LIST_FIRST(&AvailableMemBlocksList);
  802a18:	a1 48 41 80 00       	mov    0x804148,%eax
  802a1d:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	uint32 newveradd;
	uint32 newsize;
	int size_free = LIST_SIZE(&FreeMemBlocksList);
  802a20:	a1 44 41 80 00       	mov    0x804144,%eax
  802a25:	89 45 e0             	mov    %eax,-0x20(%ebp)

	LIST_FOREACH(blk, &FreeMemBlocksList)
  802a28:	a1 38 41 80 00       	mov    0x804138,%eax
  802a2d:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802a30:	e9 a1 00 00 00       	jmp    802ad6 <alloc_block_BF+0xca>
	{
		if(blk->size == versize)
  802a35:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a38:	8b 40 0c             	mov    0xc(%eax),%eax
  802a3b:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  802a3e:	0f 85 8a 00 00 00    	jne    802ace <alloc_block_BF+0xc2>
		{
			LIST_REMOVE(&FreeMemBlocksList, blk);
  802a44:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802a48:	75 17                	jne    802a61 <alloc_block_BF+0x55>
  802a4a:	83 ec 04             	sub    $0x4,%esp
  802a4d:	68 88 3f 80 00       	push   $0x803f88
  802a52:	68 c2 00 00 00       	push   $0xc2
  802a57:	68 17 3f 80 00       	push   $0x803f17
  802a5c:	e8 3a dd ff ff       	call   80079b <_panic>
  802a61:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a64:	8b 00                	mov    (%eax),%eax
  802a66:	85 c0                	test   %eax,%eax
  802a68:	74 10                	je     802a7a <alloc_block_BF+0x6e>
  802a6a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a6d:	8b 00                	mov    (%eax),%eax
  802a6f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802a72:	8b 52 04             	mov    0x4(%edx),%edx
  802a75:	89 50 04             	mov    %edx,0x4(%eax)
  802a78:	eb 0b                	jmp    802a85 <alloc_block_BF+0x79>
  802a7a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a7d:	8b 40 04             	mov    0x4(%eax),%eax
  802a80:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802a85:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a88:	8b 40 04             	mov    0x4(%eax),%eax
  802a8b:	85 c0                	test   %eax,%eax
  802a8d:	74 0f                	je     802a9e <alloc_block_BF+0x92>
  802a8f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a92:	8b 40 04             	mov    0x4(%eax),%eax
  802a95:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802a98:	8b 12                	mov    (%edx),%edx
  802a9a:	89 10                	mov    %edx,(%eax)
  802a9c:	eb 0a                	jmp    802aa8 <alloc_block_BF+0x9c>
  802a9e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802aa1:	8b 00                	mov    (%eax),%eax
  802aa3:	a3 38 41 80 00       	mov    %eax,0x804138
  802aa8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802aab:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802ab1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ab4:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802abb:	a1 44 41 80 00       	mov    0x804144,%eax
  802ac0:	48                   	dec    %eax
  802ac1:	a3 44 41 80 00       	mov    %eax,0x804144
			return blk;
  802ac6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ac9:	e9 11 02 00 00       	jmp    802cdf <alloc_block_BF+0x2d3>
	struct MemBlock* newblk=LIST_FIRST(&AvailableMemBlocksList);
	uint32 newveradd;
	uint32 newsize;
	int size_free = LIST_SIZE(&FreeMemBlocksList);

	LIST_FOREACH(blk, &FreeMemBlocksList)
  802ace:	a1 40 41 80 00       	mov    0x804140,%eax
  802ad3:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802ad6:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802ada:	74 07                	je     802ae3 <alloc_block_BF+0xd7>
  802adc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802adf:	8b 00                	mov    (%eax),%eax
  802ae1:	eb 05                	jmp    802ae8 <alloc_block_BF+0xdc>
  802ae3:	b8 00 00 00 00       	mov    $0x0,%eax
  802ae8:	a3 40 41 80 00       	mov    %eax,0x804140
  802aed:	a1 40 41 80 00       	mov    0x804140,%eax
  802af2:	85 c0                	test   %eax,%eax
  802af4:	0f 85 3b ff ff ff    	jne    802a35 <alloc_block_BF+0x29>
  802afa:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802afe:	0f 85 31 ff ff ff    	jne    802a35 <alloc_block_BF+0x29>
		{
			LIST_REMOVE(&FreeMemBlocksList, blk);
			return blk;
		}
	}
	LIST_FOREACH(blk, &FreeMemBlocksList)
  802b04:	a1 38 41 80 00       	mov    0x804138,%eax
  802b09:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802b0c:	eb 27                	jmp    802b35 <alloc_block_BF+0x129>
	{
		if(blk->size > versize)
  802b0e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b11:	8b 40 0c             	mov    0xc(%eax),%eax
  802b14:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  802b17:	76 14                	jbe    802b2d <alloc_block_BF+0x121>
		{
			newsize = blk->size;
  802b19:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b1c:	8b 40 0c             	mov    0xc(%eax),%eax
  802b1f:	89 45 ec             	mov    %eax,-0x14(%ebp)
			newveradd = blk->sva;
  802b22:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b25:	8b 40 08             	mov    0x8(%eax),%eax
  802b28:	89 45 f0             	mov    %eax,-0x10(%ebp)
			break;
  802b2b:	eb 2e                	jmp    802b5b <alloc_block_BF+0x14f>
		{
			LIST_REMOVE(&FreeMemBlocksList, blk);
			return blk;
		}
	}
	LIST_FOREACH(blk, &FreeMemBlocksList)
  802b2d:	a1 40 41 80 00       	mov    0x804140,%eax
  802b32:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802b35:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802b39:	74 07                	je     802b42 <alloc_block_BF+0x136>
  802b3b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b3e:	8b 00                	mov    (%eax),%eax
  802b40:	eb 05                	jmp    802b47 <alloc_block_BF+0x13b>
  802b42:	b8 00 00 00 00       	mov    $0x0,%eax
  802b47:	a3 40 41 80 00       	mov    %eax,0x804140
  802b4c:	a1 40 41 80 00       	mov    0x804140,%eax
  802b51:	85 c0                	test   %eax,%eax
  802b53:	75 b9                	jne    802b0e <alloc_block_BF+0x102>
  802b55:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802b59:	75 b3                	jne    802b0e <alloc_block_BF+0x102>
			newsize = blk->size;
			newveradd = blk->sva;
			break;
		}
	}
	LIST_FOREACH(blk, &FreeMemBlocksList)
  802b5b:	a1 38 41 80 00       	mov    0x804138,%eax
  802b60:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802b63:	eb 30                	jmp    802b95 <alloc_block_BF+0x189>
	{
		if(newsize > blk->size && blk->size > versize)
  802b65:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b68:	8b 40 0c             	mov    0xc(%eax),%eax
  802b6b:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  802b6e:	73 1d                	jae    802b8d <alloc_block_BF+0x181>
  802b70:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b73:	8b 40 0c             	mov    0xc(%eax),%eax
  802b76:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  802b79:	76 12                	jbe    802b8d <alloc_block_BF+0x181>
		{
	       newsize = blk->size;
  802b7b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b7e:	8b 40 0c             	mov    0xc(%eax),%eax
  802b81:	89 45 ec             	mov    %eax,-0x14(%ebp)
		   newveradd = blk->sva;
  802b84:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b87:	8b 40 08             	mov    0x8(%eax),%eax
  802b8a:	89 45 f0             	mov    %eax,-0x10(%ebp)
			newsize = blk->size;
			newveradd = blk->sva;
			break;
		}
	}
	LIST_FOREACH(blk, &FreeMemBlocksList)
  802b8d:	a1 40 41 80 00       	mov    0x804140,%eax
  802b92:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802b95:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802b99:	74 07                	je     802ba2 <alloc_block_BF+0x196>
  802b9b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b9e:	8b 00                	mov    (%eax),%eax
  802ba0:	eb 05                	jmp    802ba7 <alloc_block_BF+0x19b>
  802ba2:	b8 00 00 00 00       	mov    $0x0,%eax
  802ba7:	a3 40 41 80 00       	mov    %eax,0x804140
  802bac:	a1 40 41 80 00       	mov    0x804140,%eax
  802bb1:	85 c0                	test   %eax,%eax
  802bb3:	75 b0                	jne    802b65 <alloc_block_BF+0x159>
  802bb5:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802bb9:	75 aa                	jne    802b65 <alloc_block_BF+0x159>
		{
	       newsize = blk->size;
		   newveradd = blk->sva;
		}
	}
	LIST_FOREACH(blk, &FreeMemBlocksList)
  802bbb:	a1 38 41 80 00       	mov    0x804138,%eax
  802bc0:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802bc3:	e9 e4 00 00 00       	jmp    802cac <alloc_block_BF+0x2a0>
	{
		if(blk->size == newsize && blk->sva == newveradd)
  802bc8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bcb:	8b 40 0c             	mov    0xc(%eax),%eax
  802bce:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  802bd1:	0f 85 cd 00 00 00    	jne    802ca4 <alloc_block_BF+0x298>
  802bd7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bda:	8b 40 08             	mov    0x8(%eax),%eax
  802bdd:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  802be0:	0f 85 be 00 00 00    	jne    802ca4 <alloc_block_BF+0x298>
		{
			LIST_REMOVE(&AvailableMemBlocksList, newblk);
  802be6:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  802bea:	75 17                	jne    802c03 <alloc_block_BF+0x1f7>
  802bec:	83 ec 04             	sub    $0x4,%esp
  802bef:	68 88 3f 80 00       	push   $0x803f88
  802bf4:	68 db 00 00 00       	push   $0xdb
  802bf9:	68 17 3f 80 00       	push   $0x803f17
  802bfe:	e8 98 db ff ff       	call   80079b <_panic>
  802c03:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802c06:	8b 00                	mov    (%eax),%eax
  802c08:	85 c0                	test   %eax,%eax
  802c0a:	74 10                	je     802c1c <alloc_block_BF+0x210>
  802c0c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802c0f:	8b 00                	mov    (%eax),%eax
  802c11:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802c14:	8b 52 04             	mov    0x4(%edx),%edx
  802c17:	89 50 04             	mov    %edx,0x4(%eax)
  802c1a:	eb 0b                	jmp    802c27 <alloc_block_BF+0x21b>
  802c1c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802c1f:	8b 40 04             	mov    0x4(%eax),%eax
  802c22:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802c27:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802c2a:	8b 40 04             	mov    0x4(%eax),%eax
  802c2d:	85 c0                	test   %eax,%eax
  802c2f:	74 0f                	je     802c40 <alloc_block_BF+0x234>
  802c31:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802c34:	8b 40 04             	mov    0x4(%eax),%eax
  802c37:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802c3a:	8b 12                	mov    (%edx),%edx
  802c3c:	89 10                	mov    %edx,(%eax)
  802c3e:	eb 0a                	jmp    802c4a <alloc_block_BF+0x23e>
  802c40:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802c43:	8b 00                	mov    (%eax),%eax
  802c45:	a3 48 41 80 00       	mov    %eax,0x804148
  802c4a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802c4d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802c53:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802c56:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802c5d:	a1 54 41 80 00       	mov    0x804154,%eax
  802c62:	48                   	dec    %eax
  802c63:	a3 54 41 80 00       	mov    %eax,0x804154
			newblk->size = versize;
  802c68:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802c6b:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802c6e:	89 50 0c             	mov    %edx,0xc(%eax)
			newblk->sva = newveradd;
  802c71:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802c74:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802c77:	89 50 08             	mov    %edx,0x8(%eax)
			blk->size = blk->size - versize;
  802c7a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c7d:	8b 40 0c             	mov    0xc(%eax),%eax
  802c80:	2b 45 e8             	sub    -0x18(%ebp),%eax
  802c83:	89 c2                	mov    %eax,%edx
  802c85:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c88:	89 50 0c             	mov    %edx,0xc(%eax)
			blk->sva+= newblk->size;
  802c8b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c8e:	8b 50 08             	mov    0x8(%eax),%edx
  802c91:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802c94:	8b 40 0c             	mov    0xc(%eax),%eax
  802c97:	01 c2                	add    %eax,%edx
  802c99:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c9c:	89 50 08             	mov    %edx,0x8(%eax)
			return newblk;
  802c9f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802ca2:	eb 3b                	jmp    802cdf <alloc_block_BF+0x2d3>
		{
	       newsize = blk->size;
		   newveradd = blk->sva;
		}
	}
	LIST_FOREACH(blk, &FreeMemBlocksList)
  802ca4:	a1 40 41 80 00       	mov    0x804140,%eax
  802ca9:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802cac:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802cb0:	74 07                	je     802cb9 <alloc_block_BF+0x2ad>
  802cb2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cb5:	8b 00                	mov    (%eax),%eax
  802cb7:	eb 05                	jmp    802cbe <alloc_block_BF+0x2b2>
  802cb9:	b8 00 00 00 00       	mov    $0x0,%eax
  802cbe:	a3 40 41 80 00       	mov    %eax,0x804140
  802cc3:	a1 40 41 80 00       	mov    0x804140,%eax
  802cc8:	85 c0                	test   %eax,%eax
  802cca:	0f 85 f8 fe ff ff    	jne    802bc8 <alloc_block_BF+0x1bc>
  802cd0:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802cd4:	0f 85 ee fe ff ff    	jne    802bc8 <alloc_block_BF+0x1bc>
			blk->size = blk->size - versize;
			blk->sva+= newblk->size;
			return newblk;
		}
	}
	return NULL;
  802cda:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802cdf:	c9                   	leave  
  802ce0:	c3                   	ret    

00802ce1 <alloc_block_NF>:
//=========================================
// [7] ALLOCATE BLOCK BY NEXT FIT:
//=========================================
struct MemBlock *last_allocate;
struct MemBlock *alloc_block_NF(uint32 size)
{
  802ce1:	55                   	push   %ebp
  802ce2:	89 e5                	mov    %esp,%ebp
  802ce4:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1 - BONUS] [DYNAMIC ALLOCATOR] alloc_block_NF
	// Write your code here, remove the panic and write your code
	//panic("alloc_block_NF() is not implemented yet...!!");
	uint32 versize = size;
  802ce7:	8b 45 08             	mov    0x8(%ebp),%eax
  802cea:	89 45 f0             	mov    %eax,-0x10(%ebp)
	struct MemBlock* blk;
	struct MemBlock* newblk = LIST_FIRST(&AvailableMemBlocksList);
  802ced:	a1 48 41 80 00       	mov    0x804148,%eax
  802cf2:	89 45 ec             	mov    %eax,-0x14(%ebp)

	LIST_FOREACH(blk,&FreeMemBlocksList)
  802cf5:	a1 38 41 80 00       	mov    0x804138,%eax
  802cfa:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802cfd:	e9 77 01 00 00       	jmp    802e79 <alloc_block_NF+0x198>
	{
		if(blk->size == versize)
  802d02:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d05:	8b 40 0c             	mov    0xc(%eax),%eax
  802d08:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  802d0b:	0f 85 8a 00 00 00    	jne    802d9b <alloc_block_NF+0xba>
		{
			LIST_REMOVE(&FreeMemBlocksList,blk);
  802d11:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802d15:	75 17                	jne    802d2e <alloc_block_NF+0x4d>
  802d17:	83 ec 04             	sub    $0x4,%esp
  802d1a:	68 88 3f 80 00       	push   $0x803f88
  802d1f:	68 f7 00 00 00       	push   $0xf7
  802d24:	68 17 3f 80 00       	push   $0x803f17
  802d29:	e8 6d da ff ff       	call   80079b <_panic>
  802d2e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d31:	8b 00                	mov    (%eax),%eax
  802d33:	85 c0                	test   %eax,%eax
  802d35:	74 10                	je     802d47 <alloc_block_NF+0x66>
  802d37:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d3a:	8b 00                	mov    (%eax),%eax
  802d3c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802d3f:	8b 52 04             	mov    0x4(%edx),%edx
  802d42:	89 50 04             	mov    %edx,0x4(%eax)
  802d45:	eb 0b                	jmp    802d52 <alloc_block_NF+0x71>
  802d47:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d4a:	8b 40 04             	mov    0x4(%eax),%eax
  802d4d:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802d52:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d55:	8b 40 04             	mov    0x4(%eax),%eax
  802d58:	85 c0                	test   %eax,%eax
  802d5a:	74 0f                	je     802d6b <alloc_block_NF+0x8a>
  802d5c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d5f:	8b 40 04             	mov    0x4(%eax),%eax
  802d62:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802d65:	8b 12                	mov    (%edx),%edx
  802d67:	89 10                	mov    %edx,(%eax)
  802d69:	eb 0a                	jmp    802d75 <alloc_block_NF+0x94>
  802d6b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d6e:	8b 00                	mov    (%eax),%eax
  802d70:	a3 38 41 80 00       	mov    %eax,0x804138
  802d75:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d78:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802d7e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d81:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802d88:	a1 44 41 80 00       	mov    0x804144,%eax
  802d8d:	48                   	dec    %eax
  802d8e:	a3 44 41 80 00       	mov    %eax,0x804144
			return blk;
  802d93:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d96:	e9 11 01 00 00       	jmp    802eac <alloc_block_NF+0x1cb>
		}
		else if(blk->size > versize)
  802d9b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d9e:	8b 40 0c             	mov    0xc(%eax),%eax
  802da1:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  802da4:	0f 86 c7 00 00 00    	jbe    802e71 <alloc_block_NF+0x190>
		{
			LIST_REMOVE(&AvailableMemBlocksList,newblk);
  802daa:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802dae:	75 17                	jne    802dc7 <alloc_block_NF+0xe6>
  802db0:	83 ec 04             	sub    $0x4,%esp
  802db3:	68 88 3f 80 00       	push   $0x803f88
  802db8:	68 fc 00 00 00       	push   $0xfc
  802dbd:	68 17 3f 80 00       	push   $0x803f17
  802dc2:	e8 d4 d9 ff ff       	call   80079b <_panic>
  802dc7:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802dca:	8b 00                	mov    (%eax),%eax
  802dcc:	85 c0                	test   %eax,%eax
  802dce:	74 10                	je     802de0 <alloc_block_NF+0xff>
  802dd0:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802dd3:	8b 00                	mov    (%eax),%eax
  802dd5:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802dd8:	8b 52 04             	mov    0x4(%edx),%edx
  802ddb:	89 50 04             	mov    %edx,0x4(%eax)
  802dde:	eb 0b                	jmp    802deb <alloc_block_NF+0x10a>
  802de0:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802de3:	8b 40 04             	mov    0x4(%eax),%eax
  802de6:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802deb:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802dee:	8b 40 04             	mov    0x4(%eax),%eax
  802df1:	85 c0                	test   %eax,%eax
  802df3:	74 0f                	je     802e04 <alloc_block_NF+0x123>
  802df5:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802df8:	8b 40 04             	mov    0x4(%eax),%eax
  802dfb:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802dfe:	8b 12                	mov    (%edx),%edx
  802e00:	89 10                	mov    %edx,(%eax)
  802e02:	eb 0a                	jmp    802e0e <alloc_block_NF+0x12d>
  802e04:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802e07:	8b 00                	mov    (%eax),%eax
  802e09:	a3 48 41 80 00       	mov    %eax,0x804148
  802e0e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802e11:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802e17:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802e1a:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802e21:	a1 54 41 80 00       	mov    0x804154,%eax
  802e26:	48                   	dec    %eax
  802e27:	a3 54 41 80 00       	mov    %eax,0x804154
			newblk->size = versize;
  802e2c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802e2f:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802e32:	89 50 0c             	mov    %edx,0xc(%eax)
			blk->size = blk->size-versize;
  802e35:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e38:	8b 40 0c             	mov    0xc(%eax),%eax
  802e3b:	2b 45 f0             	sub    -0x10(%ebp),%eax
  802e3e:	89 c2                	mov    %eax,%edx
  802e40:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e43:	89 50 0c             	mov    %edx,0xc(%eax)
			uint32 newveradd = blk->sva;
  802e46:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e49:	8b 40 08             	mov    0x8(%eax),%eax
  802e4c:	89 45 e8             	mov    %eax,-0x18(%ebp)
			blk->sva+=newblk->size;
  802e4f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e52:	8b 50 08             	mov    0x8(%eax),%edx
  802e55:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802e58:	8b 40 0c             	mov    0xc(%eax),%eax
  802e5b:	01 c2                	add    %eax,%edx
  802e5d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e60:	89 50 08             	mov    %edx,0x8(%eax)
			newblk->sva = newveradd;
  802e63:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802e66:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802e69:	89 50 08             	mov    %edx,0x8(%eax)
			return newblk;
  802e6c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802e6f:	eb 3b                	jmp    802eac <alloc_block_NF+0x1cb>
	//panic("alloc_block_NF() is not implemented yet...!!");
	uint32 versize = size;
	struct MemBlock* blk;
	struct MemBlock* newblk = LIST_FIRST(&AvailableMemBlocksList);

	LIST_FOREACH(blk,&FreeMemBlocksList)
  802e71:	a1 40 41 80 00       	mov    0x804140,%eax
  802e76:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802e79:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802e7d:	74 07                	je     802e86 <alloc_block_NF+0x1a5>
  802e7f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e82:	8b 00                	mov    (%eax),%eax
  802e84:	eb 05                	jmp    802e8b <alloc_block_NF+0x1aa>
  802e86:	b8 00 00 00 00       	mov    $0x0,%eax
  802e8b:	a3 40 41 80 00       	mov    %eax,0x804140
  802e90:	a1 40 41 80 00       	mov    0x804140,%eax
  802e95:	85 c0                	test   %eax,%eax
  802e97:	0f 85 65 fe ff ff    	jne    802d02 <alloc_block_NF+0x21>
  802e9d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802ea1:	0f 85 5b fe ff ff    	jne    802d02 <alloc_block_NF+0x21>
			blk->sva+=newblk->size;
			newblk->sva = newveradd;
			return newblk;
		}
	}
	return NULL;
  802ea7:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802eac:	c9                   	leave  
  802ead:	c3                   	ret    

00802eae <addToAvailMemBlocksList>:

//===================================================
// [8] INSERT BLOCK (SORTED WITH MERGE) IN FREE LIST:
//===================================================
void addToAvailMemBlocksList(struct MemBlock *blockToInsert)
{
  802eae:	55                   	push   %ebp
  802eaf:	89 e5                	mov    %esp,%ebp
  802eb1:	83 ec 08             	sub    $0x8,%esp
	blockToInsert->sva = 0;
  802eb4:	8b 45 08             	mov    0x8(%ebp),%eax
  802eb7:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
	blockToInsert->size = 0;
  802ebe:	8b 45 08             	mov    0x8(%ebp),%eax
  802ec1:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
	//add to avail
	LIST_INSERT_TAIL(&AvailableMemBlocksList, blockToInsert);
  802ec8:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802ecc:	75 17                	jne    802ee5 <addToAvailMemBlocksList+0x37>
  802ece:	83 ec 04             	sub    $0x4,%esp
  802ed1:	68 30 3f 80 00       	push   $0x803f30
  802ed6:	68 10 01 00 00       	push   $0x110
  802edb:	68 17 3f 80 00       	push   $0x803f17
  802ee0:	e8 b6 d8 ff ff       	call   80079b <_panic>
  802ee5:	8b 15 4c 41 80 00    	mov    0x80414c,%edx
  802eeb:	8b 45 08             	mov    0x8(%ebp),%eax
  802eee:	89 50 04             	mov    %edx,0x4(%eax)
  802ef1:	8b 45 08             	mov    0x8(%ebp),%eax
  802ef4:	8b 40 04             	mov    0x4(%eax),%eax
  802ef7:	85 c0                	test   %eax,%eax
  802ef9:	74 0c                	je     802f07 <addToAvailMemBlocksList+0x59>
  802efb:	a1 4c 41 80 00       	mov    0x80414c,%eax
  802f00:	8b 55 08             	mov    0x8(%ebp),%edx
  802f03:	89 10                	mov    %edx,(%eax)
  802f05:	eb 08                	jmp    802f0f <addToAvailMemBlocksList+0x61>
  802f07:	8b 45 08             	mov    0x8(%ebp),%eax
  802f0a:	a3 48 41 80 00       	mov    %eax,0x804148
  802f0f:	8b 45 08             	mov    0x8(%ebp),%eax
  802f12:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802f17:	8b 45 08             	mov    0x8(%ebp),%eax
  802f1a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802f20:	a1 54 41 80 00       	mov    0x804154,%eax
  802f25:	40                   	inc    %eax
  802f26:	a3 54 41 80 00       	mov    %eax,0x804154
}
  802f2b:	90                   	nop
  802f2c:	c9                   	leave  
  802f2d:	c3                   	ret    

00802f2e <insert_sorted_with_merge_freeList>:
void insert_sorted_with_merge_freeList(struct MemBlock *blockToInsert)
{
  802f2e:	55                   	push   %ebp
  802f2f:	89 e5                	mov    %esp,%ebp
  802f31:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] insert_sorted_with_merge_freeList
	// Write your code here, remove the panic and write your code

	struct MemBlock* last = LIST_LAST(&FreeMemBlocksList);
  802f34:	a1 3c 41 80 00       	mov    0x80413c,%eax
  802f39:	89 45 f0             	mov    %eax,-0x10(%ebp)
	//check if list empty
	if (LIST_SIZE(&(FreeMemBlocksList)) == 0)
  802f3c:	a1 44 41 80 00       	mov    0x804144,%eax
  802f41:	85 c0                	test   %eax,%eax
  802f43:	75 68                	jne    802fad <insert_sorted_with_merge_freeList+0x7f>
		LIST_INSERT_HEAD(&FreeMemBlocksList, blockToInsert);
  802f45:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802f49:	75 17                	jne    802f62 <insert_sorted_with_merge_freeList+0x34>
  802f4b:	83 ec 04             	sub    $0x4,%esp
  802f4e:	68 f4 3e 80 00       	push   $0x803ef4
  802f53:	68 1a 01 00 00       	push   $0x11a
  802f58:	68 17 3f 80 00       	push   $0x803f17
  802f5d:	e8 39 d8 ff ff       	call   80079b <_panic>
  802f62:	8b 15 38 41 80 00    	mov    0x804138,%edx
  802f68:	8b 45 08             	mov    0x8(%ebp),%eax
  802f6b:	89 10                	mov    %edx,(%eax)
  802f6d:	8b 45 08             	mov    0x8(%ebp),%eax
  802f70:	8b 00                	mov    (%eax),%eax
  802f72:	85 c0                	test   %eax,%eax
  802f74:	74 0d                	je     802f83 <insert_sorted_with_merge_freeList+0x55>
  802f76:	a1 38 41 80 00       	mov    0x804138,%eax
  802f7b:	8b 55 08             	mov    0x8(%ebp),%edx
  802f7e:	89 50 04             	mov    %edx,0x4(%eax)
  802f81:	eb 08                	jmp    802f8b <insert_sorted_with_merge_freeList+0x5d>
  802f83:	8b 45 08             	mov    0x8(%ebp),%eax
  802f86:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802f8b:	8b 45 08             	mov    0x8(%ebp),%eax
  802f8e:	a3 38 41 80 00       	mov    %eax,0x804138
  802f93:	8b 45 08             	mov    0x8(%ebp),%eax
  802f96:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802f9d:	a1 44 41 80 00       	mov    0x804144,%eax
  802fa2:	40                   	inc    %eax
  802fa3:	a3 44 41 80 00       	mov    %eax,0x804144
		}
	}

	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  802fa8:	e9 c5 03 00 00       	jmp    803372 <insert_sorted_with_merge_freeList+0x444>
	struct MemBlock* last = LIST_LAST(&FreeMemBlocksList);
	//check if list empty
	if (LIST_SIZE(&(FreeMemBlocksList)) == 0)
		LIST_INSERT_HEAD(&FreeMemBlocksList, blockToInsert);
	//check if it's position is at last
	else if (last->sva < blockToInsert->sva) {
  802fad:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802fb0:	8b 50 08             	mov    0x8(%eax),%edx
  802fb3:	8b 45 08             	mov    0x8(%ebp),%eax
  802fb6:	8b 40 08             	mov    0x8(%eax),%eax
  802fb9:	39 c2                	cmp    %eax,%edx
  802fbb:	0f 83 b2 00 00 00    	jae    803073 <insert_sorted_with_merge_freeList+0x145>

		//if i have to merge
		if (last->sva + last->size == blockToInsert->sva) {
  802fc1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802fc4:	8b 50 08             	mov    0x8(%eax),%edx
  802fc7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802fca:	8b 40 0c             	mov    0xc(%eax),%eax
  802fcd:	01 c2                	add    %eax,%edx
  802fcf:	8b 45 08             	mov    0x8(%ebp),%eax
  802fd2:	8b 40 08             	mov    0x8(%eax),%eax
  802fd5:	39 c2                	cmp    %eax,%edx
  802fd7:	75 27                	jne    803000 <insert_sorted_with_merge_freeList+0xd2>
			last->size = last->size + blockToInsert->size;
  802fd9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802fdc:	8b 50 0c             	mov    0xc(%eax),%edx
  802fdf:	8b 45 08             	mov    0x8(%ebp),%eax
  802fe2:	8b 40 0c             	mov    0xc(%eax),%eax
  802fe5:	01 c2                	add    %eax,%edx
  802fe7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802fea:	89 50 0c             	mov    %edx,0xc(%eax)
			addToAvailMemBlocksList(blockToInsert);
  802fed:	83 ec 0c             	sub    $0xc,%esp
  802ff0:	ff 75 08             	pushl  0x8(%ebp)
  802ff3:	e8 b6 fe ff ff       	call   802eae <addToAvailMemBlocksList>
  802ff8:	83 c4 10             	add    $0x10,%esp
		}
	}

	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  802ffb:	e9 72 03 00 00       	jmp    803372 <insert_sorted_with_merge_freeList+0x444>
		if (last->sva + last->size == blockToInsert->sva) {
			last->size = last->size + blockToInsert->size;
			addToAvailMemBlocksList(blockToInsert);

		} else {
			LIST_INSERT_AFTER(&FreeMemBlocksList, last, blockToInsert);
  803000:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  803004:	74 06                	je     80300c <insert_sorted_with_merge_freeList+0xde>
  803006:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80300a:	75 17                	jne    803023 <insert_sorted_with_merge_freeList+0xf5>
  80300c:	83 ec 04             	sub    $0x4,%esp
  80300f:	68 54 3f 80 00       	push   $0x803f54
  803014:	68 24 01 00 00       	push   $0x124
  803019:	68 17 3f 80 00       	push   $0x803f17
  80301e:	e8 78 d7 ff ff       	call   80079b <_panic>
  803023:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803026:	8b 10                	mov    (%eax),%edx
  803028:	8b 45 08             	mov    0x8(%ebp),%eax
  80302b:	89 10                	mov    %edx,(%eax)
  80302d:	8b 45 08             	mov    0x8(%ebp),%eax
  803030:	8b 00                	mov    (%eax),%eax
  803032:	85 c0                	test   %eax,%eax
  803034:	74 0b                	je     803041 <insert_sorted_with_merge_freeList+0x113>
  803036:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803039:	8b 00                	mov    (%eax),%eax
  80303b:	8b 55 08             	mov    0x8(%ebp),%edx
  80303e:	89 50 04             	mov    %edx,0x4(%eax)
  803041:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803044:	8b 55 08             	mov    0x8(%ebp),%edx
  803047:	89 10                	mov    %edx,(%eax)
  803049:	8b 45 08             	mov    0x8(%ebp),%eax
  80304c:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80304f:	89 50 04             	mov    %edx,0x4(%eax)
  803052:	8b 45 08             	mov    0x8(%ebp),%eax
  803055:	8b 00                	mov    (%eax),%eax
  803057:	85 c0                	test   %eax,%eax
  803059:	75 08                	jne    803063 <insert_sorted_with_merge_freeList+0x135>
  80305b:	8b 45 08             	mov    0x8(%ebp),%eax
  80305e:	a3 3c 41 80 00       	mov    %eax,0x80413c
  803063:	a1 44 41 80 00       	mov    0x804144,%eax
  803068:	40                   	inc    %eax
  803069:	a3 44 41 80 00       	mov    %eax,0x804144
		}
	}

	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  80306e:	e9 ff 02 00 00       	jmp    803372 <insert_sorted_with_merge_freeList+0x444>
		} else {
			LIST_INSERT_AFTER(&FreeMemBlocksList, last, blockToInsert);
		}
	} else {
		struct MemBlock *iterator;
		LIST_FOREACH(iterator, &(FreeMemBlocksList))
  803073:	a1 38 41 80 00       	mov    0x804138,%eax
  803078:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80307b:	e9 c2 02 00 00       	jmp    803342 <insert_sorted_with_merge_freeList+0x414>
		{

			if (iterator->sva > blockToInsert->sva) {
  803080:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803083:	8b 50 08             	mov    0x8(%eax),%edx
  803086:	8b 45 08             	mov    0x8(%ebp),%eax
  803089:	8b 40 08             	mov    0x8(%eax),%eax
  80308c:	39 c2                	cmp    %eax,%edx
  80308e:	0f 86 a6 02 00 00    	jbe    80333a <insert_sorted_with_merge_freeList+0x40c>

				struct MemBlock* prev = LIST_PREV(iterator);
  803094:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803097:	8b 40 04             	mov    0x4(%eax),%eax
  80309a:	89 45 ec             	mov    %eax,-0x14(%ebp)
				if (prev == NULL) {
  80309d:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8030a1:	0f 85 ba 00 00 00    	jne    803161 <insert_sorted_with_merge_freeList+0x233>
					//check merge
					if (blockToInsert->size + blockToInsert->sva
  8030a7:	8b 45 08             	mov    0x8(%ebp),%eax
  8030aa:	8b 50 0c             	mov    0xc(%eax),%edx
  8030ad:	8b 45 08             	mov    0x8(%ebp),%eax
  8030b0:	8b 40 08             	mov    0x8(%eax),%eax
  8030b3:	01 c2                	add    %eax,%edx
							== iterator->sva) {
  8030b5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030b8:	8b 40 08             	mov    0x8(%eax),%eax
			if (iterator->sva > blockToInsert->sva) {

				struct MemBlock* prev = LIST_PREV(iterator);
				if (prev == NULL) {
					//check merge
					if (blockToInsert->size + blockToInsert->sva
  8030bb:	39 c2                	cmp    %eax,%edx
  8030bd:	75 33                	jne    8030f2 <insert_sorted_with_merge_freeList+0x1c4>
							== iterator->sva) {
						iterator->sva = blockToInsert->sva;
  8030bf:	8b 45 08             	mov    0x8(%ebp),%eax
  8030c2:	8b 50 08             	mov    0x8(%eax),%edx
  8030c5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030c8:	89 50 08             	mov    %edx,0x8(%eax)
						iterator->size = iterator->size + blockToInsert->size;
  8030cb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030ce:	8b 50 0c             	mov    0xc(%eax),%edx
  8030d1:	8b 45 08             	mov    0x8(%ebp),%eax
  8030d4:	8b 40 0c             	mov    0xc(%eax),%eax
  8030d7:	01 c2                	add    %eax,%edx
  8030d9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030dc:	89 50 0c             	mov    %edx,0xc(%eax)
						addToAvailMemBlocksList(blockToInsert);
  8030df:	83 ec 0c             	sub    $0xc,%esp
  8030e2:	ff 75 08             	pushl  0x8(%ebp)
  8030e5:	e8 c4 fd ff ff       	call   802eae <addToAvailMemBlocksList>
  8030ea:	83 c4 10             	add    $0x10,%esp

					else {
						LIST_INSERT_BEFORE(&FreeMemBlocksList, iterator,
								blockToInsert);
					}
					break;
  8030ed:	e9 80 02 00 00       	jmp    803372 <insert_sorted_with_merge_freeList+0x444>
						addToAvailMemBlocksList(blockToInsert);

					}

					else {
						LIST_INSERT_BEFORE(&FreeMemBlocksList, iterator,
  8030f2:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8030f6:	74 06                	je     8030fe <insert_sorted_with_merge_freeList+0x1d0>
  8030f8:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8030fc:	75 17                	jne    803115 <insert_sorted_with_merge_freeList+0x1e7>
  8030fe:	83 ec 04             	sub    $0x4,%esp
  803101:	68 a8 3f 80 00       	push   $0x803fa8
  803106:	68 3a 01 00 00       	push   $0x13a
  80310b:	68 17 3f 80 00       	push   $0x803f17
  803110:	e8 86 d6 ff ff       	call   80079b <_panic>
  803115:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803118:	8b 50 04             	mov    0x4(%eax),%edx
  80311b:	8b 45 08             	mov    0x8(%ebp),%eax
  80311e:	89 50 04             	mov    %edx,0x4(%eax)
  803121:	8b 45 08             	mov    0x8(%ebp),%eax
  803124:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803127:	89 10                	mov    %edx,(%eax)
  803129:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80312c:	8b 40 04             	mov    0x4(%eax),%eax
  80312f:	85 c0                	test   %eax,%eax
  803131:	74 0d                	je     803140 <insert_sorted_with_merge_freeList+0x212>
  803133:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803136:	8b 40 04             	mov    0x4(%eax),%eax
  803139:	8b 55 08             	mov    0x8(%ebp),%edx
  80313c:	89 10                	mov    %edx,(%eax)
  80313e:	eb 08                	jmp    803148 <insert_sorted_with_merge_freeList+0x21a>
  803140:	8b 45 08             	mov    0x8(%ebp),%eax
  803143:	a3 38 41 80 00       	mov    %eax,0x804138
  803148:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80314b:	8b 55 08             	mov    0x8(%ebp),%edx
  80314e:	89 50 04             	mov    %edx,0x4(%eax)
  803151:	a1 44 41 80 00       	mov    0x804144,%eax
  803156:	40                   	inc    %eax
  803157:	a3 44 41 80 00       	mov    %eax,0x804144
								blockToInsert);
					}
					break;
  80315c:	e9 11 02 00 00       	jmp    803372 <insert_sorted_with_merge_freeList+0x444>
				} else {
					//prev and next merge
					if (prev->sva + prev->size + blockToInsert->size
  803161:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803164:	8b 50 08             	mov    0x8(%eax),%edx
  803167:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80316a:	8b 40 0c             	mov    0xc(%eax),%eax
  80316d:	01 c2                	add    %eax,%edx
  80316f:	8b 45 08             	mov    0x8(%ebp),%eax
  803172:	8b 40 0c             	mov    0xc(%eax),%eax
  803175:	01 c2                	add    %eax,%edx
							== iterator->sva) {
  803177:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80317a:	8b 40 08             	mov    0x8(%eax),%eax
								blockToInsert);
					}
					break;
				} else {
					//prev and next merge
					if (prev->sva + prev->size + blockToInsert->size
  80317d:	39 c2                	cmp    %eax,%edx
  80317f:	0f 85 bf 00 00 00    	jne    803244 <insert_sorted_with_merge_freeList+0x316>
							== iterator->sva) {
						prev->size = prev->size + blockToInsert->size
  803185:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803188:	8b 50 0c             	mov    0xc(%eax),%edx
  80318b:	8b 45 08             	mov    0x8(%ebp),%eax
  80318e:	8b 40 0c             	mov    0xc(%eax),%eax
  803191:	01 c2                	add    %eax,%edx
								+ iterator->size;
  803193:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803196:	8b 40 0c             	mov    0xc(%eax),%eax
  803199:	01 c2                	add    %eax,%edx
					break;
				} else {
					//prev and next merge
					if (prev->sva + prev->size + blockToInsert->size
							== iterator->sva) {
						prev->size = prev->size + blockToInsert->size
  80319b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80319e:	89 50 0c             	mov    %edx,0xc(%eax)
								+ iterator->size;
						LIST_REMOVE(&FreeMemBlocksList, iterator);
  8031a1:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8031a5:	75 17                	jne    8031be <insert_sorted_with_merge_freeList+0x290>
  8031a7:	83 ec 04             	sub    $0x4,%esp
  8031aa:	68 88 3f 80 00       	push   $0x803f88
  8031af:	68 43 01 00 00       	push   $0x143
  8031b4:	68 17 3f 80 00       	push   $0x803f17
  8031b9:	e8 dd d5 ff ff       	call   80079b <_panic>
  8031be:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8031c1:	8b 00                	mov    (%eax),%eax
  8031c3:	85 c0                	test   %eax,%eax
  8031c5:	74 10                	je     8031d7 <insert_sorted_with_merge_freeList+0x2a9>
  8031c7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8031ca:	8b 00                	mov    (%eax),%eax
  8031cc:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8031cf:	8b 52 04             	mov    0x4(%edx),%edx
  8031d2:	89 50 04             	mov    %edx,0x4(%eax)
  8031d5:	eb 0b                	jmp    8031e2 <insert_sorted_with_merge_freeList+0x2b4>
  8031d7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8031da:	8b 40 04             	mov    0x4(%eax),%eax
  8031dd:	a3 3c 41 80 00       	mov    %eax,0x80413c
  8031e2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8031e5:	8b 40 04             	mov    0x4(%eax),%eax
  8031e8:	85 c0                	test   %eax,%eax
  8031ea:	74 0f                	je     8031fb <insert_sorted_with_merge_freeList+0x2cd>
  8031ec:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8031ef:	8b 40 04             	mov    0x4(%eax),%eax
  8031f2:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8031f5:	8b 12                	mov    (%edx),%edx
  8031f7:	89 10                	mov    %edx,(%eax)
  8031f9:	eb 0a                	jmp    803205 <insert_sorted_with_merge_freeList+0x2d7>
  8031fb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8031fe:	8b 00                	mov    (%eax),%eax
  803200:	a3 38 41 80 00       	mov    %eax,0x804138
  803205:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803208:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80320e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803211:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803218:	a1 44 41 80 00       	mov    0x804144,%eax
  80321d:	48                   	dec    %eax
  80321e:	a3 44 41 80 00       	mov    %eax,0x804144
						addToAvailMemBlocksList(blockToInsert);
  803223:	83 ec 0c             	sub    $0xc,%esp
  803226:	ff 75 08             	pushl  0x8(%ebp)
  803229:	e8 80 fc ff ff       	call   802eae <addToAvailMemBlocksList>
  80322e:	83 c4 10             	add    $0x10,%esp
						addToAvailMemBlocksList(iterator);
  803231:	83 ec 0c             	sub    $0xc,%esp
  803234:	ff 75 f4             	pushl  -0xc(%ebp)
  803237:	e8 72 fc ff ff       	call   802eae <addToAvailMemBlocksList>
  80323c:	83 c4 10             	add    $0x10,%esp
					//Insert
					else {
						LIST_INSERT_BEFORE(&FreeMemBlocksList, iterator,
								blockToInsert);
					}
					break;
  80323f:	e9 2e 01 00 00       	jmp    803372 <insert_sorted_with_merge_freeList+0x444>
						LIST_REMOVE(&FreeMemBlocksList, iterator);
						addToAvailMemBlocksList(blockToInsert);
						addToAvailMemBlocksList(iterator);
					}
					//previous merge
					else if (prev->sva + prev->size == blockToInsert->sva) {
  803244:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803247:	8b 50 08             	mov    0x8(%eax),%edx
  80324a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80324d:	8b 40 0c             	mov    0xc(%eax),%eax
  803250:	01 c2                	add    %eax,%edx
  803252:	8b 45 08             	mov    0x8(%ebp),%eax
  803255:	8b 40 08             	mov    0x8(%eax),%eax
  803258:	39 c2                	cmp    %eax,%edx
  80325a:	75 27                	jne    803283 <insert_sorted_with_merge_freeList+0x355>
						prev->size = prev->size + blockToInsert->size;
  80325c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80325f:	8b 50 0c             	mov    0xc(%eax),%edx
  803262:	8b 45 08             	mov    0x8(%ebp),%eax
  803265:	8b 40 0c             	mov    0xc(%eax),%eax
  803268:	01 c2                	add    %eax,%edx
  80326a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80326d:	89 50 0c             	mov    %edx,0xc(%eax)
						addToAvailMemBlocksList(blockToInsert);
  803270:	83 ec 0c             	sub    $0xc,%esp
  803273:	ff 75 08             	pushl  0x8(%ebp)
  803276:	e8 33 fc ff ff       	call   802eae <addToAvailMemBlocksList>
  80327b:	83 c4 10             	add    $0x10,%esp
					//Insert
					else {
						LIST_INSERT_BEFORE(&FreeMemBlocksList, iterator,
								blockToInsert);
					}
					break;
  80327e:	e9 ef 00 00 00       	jmp    803372 <insert_sorted_with_merge_freeList+0x444>
					else if (prev->sva + prev->size == blockToInsert->sva) {
						prev->size = prev->size + blockToInsert->size;
						addToAvailMemBlocksList(blockToInsert);
					}
					//next merge
					else if (blockToInsert->size + blockToInsert->sva
  803283:	8b 45 08             	mov    0x8(%ebp),%eax
  803286:	8b 50 0c             	mov    0xc(%eax),%edx
  803289:	8b 45 08             	mov    0x8(%ebp),%eax
  80328c:	8b 40 08             	mov    0x8(%eax),%eax
  80328f:	01 c2                	add    %eax,%edx
							== iterator->sva) {
  803291:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803294:	8b 40 08             	mov    0x8(%eax),%eax
					else if (prev->sva + prev->size == blockToInsert->sva) {
						prev->size = prev->size + blockToInsert->size;
						addToAvailMemBlocksList(blockToInsert);
					}
					//next merge
					else if (blockToInsert->size + blockToInsert->sva
  803297:	39 c2                	cmp    %eax,%edx
  803299:	75 33                	jne    8032ce <insert_sorted_with_merge_freeList+0x3a0>
							== iterator->sva) {
						iterator->sva = blockToInsert->sva;
  80329b:	8b 45 08             	mov    0x8(%ebp),%eax
  80329e:	8b 50 08             	mov    0x8(%eax),%edx
  8032a1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8032a4:	89 50 08             	mov    %edx,0x8(%eax)
						iterator->size = iterator->size + blockToInsert->size;
  8032a7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8032aa:	8b 50 0c             	mov    0xc(%eax),%edx
  8032ad:	8b 45 08             	mov    0x8(%ebp),%eax
  8032b0:	8b 40 0c             	mov    0xc(%eax),%eax
  8032b3:	01 c2                	add    %eax,%edx
  8032b5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8032b8:	89 50 0c             	mov    %edx,0xc(%eax)
						addToAvailMemBlocksList(blockToInsert);
  8032bb:	83 ec 0c             	sub    $0xc,%esp
  8032be:	ff 75 08             	pushl  0x8(%ebp)
  8032c1:	e8 e8 fb ff ff       	call   802eae <addToAvailMemBlocksList>
  8032c6:	83 c4 10             	add    $0x10,%esp
					//Insert
					else {
						LIST_INSERT_BEFORE(&FreeMemBlocksList, iterator,
								blockToInsert);
					}
					break;
  8032c9:	e9 a4 00 00 00       	jmp    803372 <insert_sorted_with_merge_freeList+0x444>
						iterator->size = iterator->size + blockToInsert->size;
						addToAvailMemBlocksList(blockToInsert);
					}
					//Insert
					else {
						LIST_INSERT_BEFORE(&FreeMemBlocksList, iterator,
  8032ce:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8032d2:	74 06                	je     8032da <insert_sorted_with_merge_freeList+0x3ac>
  8032d4:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8032d8:	75 17                	jne    8032f1 <insert_sorted_with_merge_freeList+0x3c3>
  8032da:	83 ec 04             	sub    $0x4,%esp
  8032dd:	68 a8 3f 80 00       	push   $0x803fa8
  8032e2:	68 56 01 00 00       	push   $0x156
  8032e7:	68 17 3f 80 00       	push   $0x803f17
  8032ec:	e8 aa d4 ff ff       	call   80079b <_panic>
  8032f1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8032f4:	8b 50 04             	mov    0x4(%eax),%edx
  8032f7:	8b 45 08             	mov    0x8(%ebp),%eax
  8032fa:	89 50 04             	mov    %edx,0x4(%eax)
  8032fd:	8b 45 08             	mov    0x8(%ebp),%eax
  803300:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803303:	89 10                	mov    %edx,(%eax)
  803305:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803308:	8b 40 04             	mov    0x4(%eax),%eax
  80330b:	85 c0                	test   %eax,%eax
  80330d:	74 0d                	je     80331c <insert_sorted_with_merge_freeList+0x3ee>
  80330f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803312:	8b 40 04             	mov    0x4(%eax),%eax
  803315:	8b 55 08             	mov    0x8(%ebp),%edx
  803318:	89 10                	mov    %edx,(%eax)
  80331a:	eb 08                	jmp    803324 <insert_sorted_with_merge_freeList+0x3f6>
  80331c:	8b 45 08             	mov    0x8(%ebp),%eax
  80331f:	a3 38 41 80 00       	mov    %eax,0x804138
  803324:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803327:	8b 55 08             	mov    0x8(%ebp),%edx
  80332a:	89 50 04             	mov    %edx,0x4(%eax)
  80332d:	a1 44 41 80 00       	mov    0x804144,%eax
  803332:	40                   	inc    %eax
  803333:	a3 44 41 80 00       	mov    %eax,0x804144
								blockToInsert);
					}
					break;
  803338:	eb 38                	jmp    803372 <insert_sorted_with_merge_freeList+0x444>
		} else {
			LIST_INSERT_AFTER(&FreeMemBlocksList, last, blockToInsert);
		}
	} else {
		struct MemBlock *iterator;
		LIST_FOREACH(iterator, &(FreeMemBlocksList))
  80333a:	a1 40 41 80 00       	mov    0x804140,%eax
  80333f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803342:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803346:	74 07                	je     80334f <insert_sorted_with_merge_freeList+0x421>
  803348:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80334b:	8b 00                	mov    (%eax),%eax
  80334d:	eb 05                	jmp    803354 <insert_sorted_with_merge_freeList+0x426>
  80334f:	b8 00 00 00 00       	mov    $0x0,%eax
  803354:	a3 40 41 80 00       	mov    %eax,0x804140
  803359:	a1 40 41 80 00       	mov    0x804140,%eax
  80335e:	85 c0                	test   %eax,%eax
  803360:	0f 85 1a fd ff ff    	jne    803080 <insert_sorted_with_merge_freeList+0x152>
  803366:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80336a:	0f 85 10 fd ff ff    	jne    803080 <insert_sorted_with_merge_freeList+0x152>
		}
	}

	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  803370:	eb 00                	jmp    803372 <insert_sorted_with_merge_freeList+0x444>
  803372:	90                   	nop
  803373:	c9                   	leave  
  803374:	c3                   	ret    
  803375:	66 90                	xchg   %ax,%ax
  803377:	90                   	nop

00803378 <__udivdi3>:
  803378:	55                   	push   %ebp
  803379:	57                   	push   %edi
  80337a:	56                   	push   %esi
  80337b:	53                   	push   %ebx
  80337c:	83 ec 1c             	sub    $0x1c,%esp
  80337f:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  803383:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  803387:	8b 7c 24 38          	mov    0x38(%esp),%edi
  80338b:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  80338f:	89 ca                	mov    %ecx,%edx
  803391:	89 f8                	mov    %edi,%eax
  803393:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  803397:	85 f6                	test   %esi,%esi
  803399:	75 2d                	jne    8033c8 <__udivdi3+0x50>
  80339b:	39 cf                	cmp    %ecx,%edi
  80339d:	77 65                	ja     803404 <__udivdi3+0x8c>
  80339f:	89 fd                	mov    %edi,%ebp
  8033a1:	85 ff                	test   %edi,%edi
  8033a3:	75 0b                	jne    8033b0 <__udivdi3+0x38>
  8033a5:	b8 01 00 00 00       	mov    $0x1,%eax
  8033aa:	31 d2                	xor    %edx,%edx
  8033ac:	f7 f7                	div    %edi
  8033ae:	89 c5                	mov    %eax,%ebp
  8033b0:	31 d2                	xor    %edx,%edx
  8033b2:	89 c8                	mov    %ecx,%eax
  8033b4:	f7 f5                	div    %ebp
  8033b6:	89 c1                	mov    %eax,%ecx
  8033b8:	89 d8                	mov    %ebx,%eax
  8033ba:	f7 f5                	div    %ebp
  8033bc:	89 cf                	mov    %ecx,%edi
  8033be:	89 fa                	mov    %edi,%edx
  8033c0:	83 c4 1c             	add    $0x1c,%esp
  8033c3:	5b                   	pop    %ebx
  8033c4:	5e                   	pop    %esi
  8033c5:	5f                   	pop    %edi
  8033c6:	5d                   	pop    %ebp
  8033c7:	c3                   	ret    
  8033c8:	39 ce                	cmp    %ecx,%esi
  8033ca:	77 28                	ja     8033f4 <__udivdi3+0x7c>
  8033cc:	0f bd fe             	bsr    %esi,%edi
  8033cf:	83 f7 1f             	xor    $0x1f,%edi
  8033d2:	75 40                	jne    803414 <__udivdi3+0x9c>
  8033d4:	39 ce                	cmp    %ecx,%esi
  8033d6:	72 0a                	jb     8033e2 <__udivdi3+0x6a>
  8033d8:	3b 44 24 08          	cmp    0x8(%esp),%eax
  8033dc:	0f 87 9e 00 00 00    	ja     803480 <__udivdi3+0x108>
  8033e2:	b8 01 00 00 00       	mov    $0x1,%eax
  8033e7:	89 fa                	mov    %edi,%edx
  8033e9:	83 c4 1c             	add    $0x1c,%esp
  8033ec:	5b                   	pop    %ebx
  8033ed:	5e                   	pop    %esi
  8033ee:	5f                   	pop    %edi
  8033ef:	5d                   	pop    %ebp
  8033f0:	c3                   	ret    
  8033f1:	8d 76 00             	lea    0x0(%esi),%esi
  8033f4:	31 ff                	xor    %edi,%edi
  8033f6:	31 c0                	xor    %eax,%eax
  8033f8:	89 fa                	mov    %edi,%edx
  8033fa:	83 c4 1c             	add    $0x1c,%esp
  8033fd:	5b                   	pop    %ebx
  8033fe:	5e                   	pop    %esi
  8033ff:	5f                   	pop    %edi
  803400:	5d                   	pop    %ebp
  803401:	c3                   	ret    
  803402:	66 90                	xchg   %ax,%ax
  803404:	89 d8                	mov    %ebx,%eax
  803406:	f7 f7                	div    %edi
  803408:	31 ff                	xor    %edi,%edi
  80340a:	89 fa                	mov    %edi,%edx
  80340c:	83 c4 1c             	add    $0x1c,%esp
  80340f:	5b                   	pop    %ebx
  803410:	5e                   	pop    %esi
  803411:	5f                   	pop    %edi
  803412:	5d                   	pop    %ebp
  803413:	c3                   	ret    
  803414:	bd 20 00 00 00       	mov    $0x20,%ebp
  803419:	89 eb                	mov    %ebp,%ebx
  80341b:	29 fb                	sub    %edi,%ebx
  80341d:	89 f9                	mov    %edi,%ecx
  80341f:	d3 e6                	shl    %cl,%esi
  803421:	89 c5                	mov    %eax,%ebp
  803423:	88 d9                	mov    %bl,%cl
  803425:	d3 ed                	shr    %cl,%ebp
  803427:	89 e9                	mov    %ebp,%ecx
  803429:	09 f1                	or     %esi,%ecx
  80342b:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  80342f:	89 f9                	mov    %edi,%ecx
  803431:	d3 e0                	shl    %cl,%eax
  803433:	89 c5                	mov    %eax,%ebp
  803435:	89 d6                	mov    %edx,%esi
  803437:	88 d9                	mov    %bl,%cl
  803439:	d3 ee                	shr    %cl,%esi
  80343b:	89 f9                	mov    %edi,%ecx
  80343d:	d3 e2                	shl    %cl,%edx
  80343f:	8b 44 24 08          	mov    0x8(%esp),%eax
  803443:	88 d9                	mov    %bl,%cl
  803445:	d3 e8                	shr    %cl,%eax
  803447:	09 c2                	or     %eax,%edx
  803449:	89 d0                	mov    %edx,%eax
  80344b:	89 f2                	mov    %esi,%edx
  80344d:	f7 74 24 0c          	divl   0xc(%esp)
  803451:	89 d6                	mov    %edx,%esi
  803453:	89 c3                	mov    %eax,%ebx
  803455:	f7 e5                	mul    %ebp
  803457:	39 d6                	cmp    %edx,%esi
  803459:	72 19                	jb     803474 <__udivdi3+0xfc>
  80345b:	74 0b                	je     803468 <__udivdi3+0xf0>
  80345d:	89 d8                	mov    %ebx,%eax
  80345f:	31 ff                	xor    %edi,%edi
  803461:	e9 58 ff ff ff       	jmp    8033be <__udivdi3+0x46>
  803466:	66 90                	xchg   %ax,%ax
  803468:	8b 54 24 08          	mov    0x8(%esp),%edx
  80346c:	89 f9                	mov    %edi,%ecx
  80346e:	d3 e2                	shl    %cl,%edx
  803470:	39 c2                	cmp    %eax,%edx
  803472:	73 e9                	jae    80345d <__udivdi3+0xe5>
  803474:	8d 43 ff             	lea    -0x1(%ebx),%eax
  803477:	31 ff                	xor    %edi,%edi
  803479:	e9 40 ff ff ff       	jmp    8033be <__udivdi3+0x46>
  80347e:	66 90                	xchg   %ax,%ax
  803480:	31 c0                	xor    %eax,%eax
  803482:	e9 37 ff ff ff       	jmp    8033be <__udivdi3+0x46>
  803487:	90                   	nop

00803488 <__umoddi3>:
  803488:	55                   	push   %ebp
  803489:	57                   	push   %edi
  80348a:	56                   	push   %esi
  80348b:	53                   	push   %ebx
  80348c:	83 ec 1c             	sub    $0x1c,%esp
  80348f:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  803493:	8b 74 24 34          	mov    0x34(%esp),%esi
  803497:	8b 7c 24 38          	mov    0x38(%esp),%edi
  80349b:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  80349f:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8034a3:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8034a7:	89 f3                	mov    %esi,%ebx
  8034a9:	89 fa                	mov    %edi,%edx
  8034ab:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8034af:	89 34 24             	mov    %esi,(%esp)
  8034b2:	85 c0                	test   %eax,%eax
  8034b4:	75 1a                	jne    8034d0 <__umoddi3+0x48>
  8034b6:	39 f7                	cmp    %esi,%edi
  8034b8:	0f 86 a2 00 00 00    	jbe    803560 <__umoddi3+0xd8>
  8034be:	89 c8                	mov    %ecx,%eax
  8034c0:	89 f2                	mov    %esi,%edx
  8034c2:	f7 f7                	div    %edi
  8034c4:	89 d0                	mov    %edx,%eax
  8034c6:	31 d2                	xor    %edx,%edx
  8034c8:	83 c4 1c             	add    $0x1c,%esp
  8034cb:	5b                   	pop    %ebx
  8034cc:	5e                   	pop    %esi
  8034cd:	5f                   	pop    %edi
  8034ce:	5d                   	pop    %ebp
  8034cf:	c3                   	ret    
  8034d0:	39 f0                	cmp    %esi,%eax
  8034d2:	0f 87 ac 00 00 00    	ja     803584 <__umoddi3+0xfc>
  8034d8:	0f bd e8             	bsr    %eax,%ebp
  8034db:	83 f5 1f             	xor    $0x1f,%ebp
  8034de:	0f 84 ac 00 00 00    	je     803590 <__umoddi3+0x108>
  8034e4:	bf 20 00 00 00       	mov    $0x20,%edi
  8034e9:	29 ef                	sub    %ebp,%edi
  8034eb:	89 fe                	mov    %edi,%esi
  8034ed:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  8034f1:	89 e9                	mov    %ebp,%ecx
  8034f3:	d3 e0                	shl    %cl,%eax
  8034f5:	89 d7                	mov    %edx,%edi
  8034f7:	89 f1                	mov    %esi,%ecx
  8034f9:	d3 ef                	shr    %cl,%edi
  8034fb:	09 c7                	or     %eax,%edi
  8034fd:	89 e9                	mov    %ebp,%ecx
  8034ff:	d3 e2                	shl    %cl,%edx
  803501:	89 14 24             	mov    %edx,(%esp)
  803504:	89 d8                	mov    %ebx,%eax
  803506:	d3 e0                	shl    %cl,%eax
  803508:	89 c2                	mov    %eax,%edx
  80350a:	8b 44 24 08          	mov    0x8(%esp),%eax
  80350e:	d3 e0                	shl    %cl,%eax
  803510:	89 44 24 04          	mov    %eax,0x4(%esp)
  803514:	8b 44 24 08          	mov    0x8(%esp),%eax
  803518:	89 f1                	mov    %esi,%ecx
  80351a:	d3 e8                	shr    %cl,%eax
  80351c:	09 d0                	or     %edx,%eax
  80351e:	d3 eb                	shr    %cl,%ebx
  803520:	89 da                	mov    %ebx,%edx
  803522:	f7 f7                	div    %edi
  803524:	89 d3                	mov    %edx,%ebx
  803526:	f7 24 24             	mull   (%esp)
  803529:	89 c6                	mov    %eax,%esi
  80352b:	89 d1                	mov    %edx,%ecx
  80352d:	39 d3                	cmp    %edx,%ebx
  80352f:	0f 82 87 00 00 00    	jb     8035bc <__umoddi3+0x134>
  803535:	0f 84 91 00 00 00    	je     8035cc <__umoddi3+0x144>
  80353b:	8b 54 24 04          	mov    0x4(%esp),%edx
  80353f:	29 f2                	sub    %esi,%edx
  803541:	19 cb                	sbb    %ecx,%ebx
  803543:	89 d8                	mov    %ebx,%eax
  803545:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  803549:	d3 e0                	shl    %cl,%eax
  80354b:	89 e9                	mov    %ebp,%ecx
  80354d:	d3 ea                	shr    %cl,%edx
  80354f:	09 d0                	or     %edx,%eax
  803551:	89 e9                	mov    %ebp,%ecx
  803553:	d3 eb                	shr    %cl,%ebx
  803555:	89 da                	mov    %ebx,%edx
  803557:	83 c4 1c             	add    $0x1c,%esp
  80355a:	5b                   	pop    %ebx
  80355b:	5e                   	pop    %esi
  80355c:	5f                   	pop    %edi
  80355d:	5d                   	pop    %ebp
  80355e:	c3                   	ret    
  80355f:	90                   	nop
  803560:	89 fd                	mov    %edi,%ebp
  803562:	85 ff                	test   %edi,%edi
  803564:	75 0b                	jne    803571 <__umoddi3+0xe9>
  803566:	b8 01 00 00 00       	mov    $0x1,%eax
  80356b:	31 d2                	xor    %edx,%edx
  80356d:	f7 f7                	div    %edi
  80356f:	89 c5                	mov    %eax,%ebp
  803571:	89 f0                	mov    %esi,%eax
  803573:	31 d2                	xor    %edx,%edx
  803575:	f7 f5                	div    %ebp
  803577:	89 c8                	mov    %ecx,%eax
  803579:	f7 f5                	div    %ebp
  80357b:	89 d0                	mov    %edx,%eax
  80357d:	e9 44 ff ff ff       	jmp    8034c6 <__umoddi3+0x3e>
  803582:	66 90                	xchg   %ax,%ax
  803584:	89 c8                	mov    %ecx,%eax
  803586:	89 f2                	mov    %esi,%edx
  803588:	83 c4 1c             	add    $0x1c,%esp
  80358b:	5b                   	pop    %ebx
  80358c:	5e                   	pop    %esi
  80358d:	5f                   	pop    %edi
  80358e:	5d                   	pop    %ebp
  80358f:	c3                   	ret    
  803590:	3b 04 24             	cmp    (%esp),%eax
  803593:	72 06                	jb     80359b <__umoddi3+0x113>
  803595:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  803599:	77 0f                	ja     8035aa <__umoddi3+0x122>
  80359b:	89 f2                	mov    %esi,%edx
  80359d:	29 f9                	sub    %edi,%ecx
  80359f:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  8035a3:	89 14 24             	mov    %edx,(%esp)
  8035a6:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8035aa:	8b 44 24 04          	mov    0x4(%esp),%eax
  8035ae:	8b 14 24             	mov    (%esp),%edx
  8035b1:	83 c4 1c             	add    $0x1c,%esp
  8035b4:	5b                   	pop    %ebx
  8035b5:	5e                   	pop    %esi
  8035b6:	5f                   	pop    %edi
  8035b7:	5d                   	pop    %ebp
  8035b8:	c3                   	ret    
  8035b9:	8d 76 00             	lea    0x0(%esi),%esi
  8035bc:	2b 04 24             	sub    (%esp),%eax
  8035bf:	19 fa                	sbb    %edi,%edx
  8035c1:	89 d1                	mov    %edx,%ecx
  8035c3:	89 c6                	mov    %eax,%esi
  8035c5:	e9 71 ff ff ff       	jmp    80353b <__umoddi3+0xb3>
  8035ca:	66 90                	xchg   %ax,%ax
  8035cc:	39 44 24 04          	cmp    %eax,0x4(%esp)
  8035d0:	72 ea                	jb     8035bc <__umoddi3+0x134>
  8035d2:	89 d9                	mov    %ebx,%ecx
  8035d4:	e9 62 ff ff ff       	jmp    80353b <__umoddi3+0xb3>
