
obj/user/tst_malloc_1:     file format elf32-i386


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
  800031:	e8 6f 05 00 00       	call   8005a5 <libmain>
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
  80003c:	83 ec 74             	sub    $0x74,%esp
	//Initial test to ensure it works on "PLACEMENT" not "REPLACEMENT"
	{
		uint8 fullWS = 1;
  80003f:	c6 45 f7 01          	movb   $0x1,-0x9(%ebp)
		for (int i = 0; i < myEnv->page_WS_max_size; ++i)
  800043:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  80004a:	eb 29                	jmp    800075 <_main+0x3d>
		{
			if (myEnv->__uptr_pws[i].empty)
  80004c:	a1 20 40 80 00       	mov    0x804020,%eax
  800051:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  800057:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80005a:	89 d0                	mov    %edx,%eax
  80005c:	01 c0                	add    %eax,%eax
  80005e:	01 d0                	add    %edx,%eax
  800060:	c1 e0 03             	shl    $0x3,%eax
  800063:	01 c8                	add    %ecx,%eax
  800065:	8a 40 04             	mov    0x4(%eax),%al
  800068:	84 c0                	test   %al,%al
  80006a:	74 06                	je     800072 <_main+0x3a>
			{
				fullWS = 0;
  80006c:	c6 45 f7 00          	movb   $0x0,-0x9(%ebp)
				break;
  800070:	eb 12                	jmp    800084 <_main+0x4c>
void _main(void)
{
	//Initial test to ensure it works on "PLACEMENT" not "REPLACEMENT"
	{
		uint8 fullWS = 1;
		for (int i = 0; i < myEnv->page_WS_max_size; ++i)
  800072:	ff 45 f0             	incl   -0x10(%ebp)
  800075:	a1 20 40 80 00       	mov    0x804020,%eax
  80007a:	8b 50 74             	mov    0x74(%eax),%edx
  80007d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800080:	39 c2                	cmp    %eax,%edx
  800082:	77 c8                	ja     80004c <_main+0x14>
			{
				fullWS = 0;
				break;
			}
		}
		if (fullWS) panic("Please increase the WS size");
  800084:	80 7d f7 00          	cmpb   $0x0,-0x9(%ebp)
  800088:	74 14                	je     80009e <_main+0x66>
  80008a:	83 ec 04             	sub    $0x4,%esp
  80008d:	68 20 35 80 00       	push   $0x803520
  800092:	6a 14                	push   $0x14
  800094:	68 3c 35 80 00       	push   $0x80353c
  800099:	e8 43 06 00 00       	call   8006e1 <_panic>
	}
	/*Dummy malloc to enforce the UHEAP initializations*/
	malloc(0);
  80009e:	83 ec 0c             	sub    $0xc,%esp
  8000a1:	6a 00                	push   $0x0
  8000a3:	e8 7f 18 00 00       	call   801927 <malloc>
  8000a8:	83 c4 10             	add    $0x10,%esp
	/*=================================================*/


	int Mega = 1024*1024;
  8000ab:	c7 45 ec 00 00 10 00 	movl   $0x100000,-0x14(%ebp)
	int kilo = 1024;
  8000b2:	c7 45 e8 00 04 00 00 	movl   $0x400,-0x18(%ebp)
	//int sizeOfMemBlocksArray = ROUNDUP(((USER_HEAP_MAX-USER_HEAP_START)/PAGE_SIZE) * sizeof(struct MemBlock), PAGE_SIZE) ;
	void* ptr_allocations[20] = {0};
  8000b9:	8d 55 90             	lea    -0x70(%ebp),%edx
  8000bc:	b9 14 00 00 00       	mov    $0x14,%ecx
  8000c1:	b8 00 00 00 00       	mov    $0x0,%eax
  8000c6:	89 d7                	mov    %edx,%edi
  8000c8:	f3 ab                	rep stos %eax,%es:(%edi)
	{
		int freeFrames = sys_calculate_free_frames() ;
  8000ca:	e8 64 1c 00 00       	call   801d33 <sys_calculate_free_frames>
  8000cf:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		int usedDiskPages = sys_pf_calculate_allocated_pages() ;
  8000d2:	e8 fc 1c 00 00       	call   801dd3 <sys_pf_calculate_allocated_pages>
  8000d7:	89 45 e0             	mov    %eax,-0x20(%ebp)
		ptr_allocations[0] = malloc(2*Mega-kilo);
  8000da:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8000dd:	01 c0                	add    %eax,%eax
  8000df:	2b 45 e8             	sub    -0x18(%ebp),%eax
  8000e2:	83 ec 0c             	sub    $0xc,%esp
  8000e5:	50                   	push   %eax
  8000e6:	e8 3c 18 00 00       	call   801927 <malloc>
  8000eb:	83 c4 10             	add    $0x10,%esp
  8000ee:	89 45 90             	mov    %eax,-0x70(%ebp)
		if ((uint32) ptr_allocations[0] <  (USER_HEAP_START) || (uint32) ptr_allocations[0] > (USER_HEAP_START + PAGE_SIZE)) panic("Wrong start address for the allocated space... ");
  8000f1:	8b 45 90             	mov    -0x70(%ebp),%eax
  8000f4:	85 c0                	test   %eax,%eax
  8000f6:	79 0a                	jns    800102 <_main+0xca>
  8000f8:	8b 45 90             	mov    -0x70(%ebp),%eax
  8000fb:	3d 00 10 00 80       	cmp    $0x80001000,%eax
  800100:	76 14                	jbe    800116 <_main+0xde>
  800102:	83 ec 04             	sub    $0x4,%esp
  800105:	68 50 35 80 00       	push   $0x803550
  80010a:	6a 23                	push   $0x23
  80010c:	68 3c 35 80 00       	push   $0x80353c
  800111:	e8 cb 05 00 00       	call   8006e1 <_panic>
		//		if ((freeFrames - sys_calculate_free_frames()) != 512+1 ) panic("Wrong allocation: ");
		//cprintf("freeFrames - sys_calculate_free_frames() = %d\n", freeFrames - sys_calculate_free_frames()) ;
		//cprintf("Expected = %d\n", (1 + sizeOfMemBlocksArray/PAGE_SIZE));
		if ((freeFrames - sys_calculate_free_frames()) != 0) panic("Wrong allocation: either extra pages are allocated in memory or pages not allocated correctly on PageFile");
  800116:	e8 18 1c 00 00       	call   801d33 <sys_calculate_free_frames>
  80011b:	89 c2                	mov    %eax,%edx
  80011d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800120:	39 c2                	cmp    %eax,%edx
  800122:	74 14                	je     800138 <_main+0x100>
  800124:	83 ec 04             	sub    $0x4,%esp
  800127:	68 80 35 80 00       	push   $0x803580
  80012c:	6a 27                	push   $0x27
  80012e:	68 3c 35 80 00       	push   $0x80353c
  800133:	e8 a9 05 00 00       	call   8006e1 <_panic>
		if ((sys_pf_calculate_allocated_pages() - usedDiskPages) != 0) panic("Extra or less pages are allocated in PageFile");
  800138:	e8 96 1c 00 00       	call   801dd3 <sys_pf_calculate_allocated_pages>
  80013d:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  800140:	74 14                	je     800156 <_main+0x11e>
  800142:	83 ec 04             	sub    $0x4,%esp
  800145:	68 ec 35 80 00       	push   $0x8035ec
  80014a:	6a 28                	push   $0x28
  80014c:	68 3c 35 80 00       	push   $0x80353c
  800151:	e8 8b 05 00 00       	call   8006e1 <_panic>

		freeFrames = sys_calculate_free_frames() ;
  800156:	e8 d8 1b 00 00       	call   801d33 <sys_calculate_free_frames>
  80015b:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  80015e:	e8 70 1c 00 00       	call   801dd3 <sys_pf_calculate_allocated_pages>
  800163:	89 45 e0             	mov    %eax,-0x20(%ebp)
		ptr_allocations[1] = malloc(2*Mega-kilo);
  800166:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800169:	01 c0                	add    %eax,%eax
  80016b:	2b 45 e8             	sub    -0x18(%ebp),%eax
  80016e:	83 ec 0c             	sub    $0xc,%esp
  800171:	50                   	push   %eax
  800172:	e8 b0 17 00 00       	call   801927 <malloc>
  800177:	83 c4 10             	add    $0x10,%esp
  80017a:	89 45 94             	mov    %eax,-0x6c(%ebp)
		if ((uint32) ptr_allocations[1] < (USER_HEAP_START + 2*Mega) || (uint32) ptr_allocations[1] > (USER_HEAP_START + 2*Mega + PAGE_SIZE)) panic("Wrong start address for the allocated space... ");
  80017d:	8b 45 94             	mov    -0x6c(%ebp),%eax
  800180:	89 c2                	mov    %eax,%edx
  800182:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800185:	01 c0                	add    %eax,%eax
  800187:	05 00 00 00 80       	add    $0x80000000,%eax
  80018c:	39 c2                	cmp    %eax,%edx
  80018e:	72 13                	jb     8001a3 <_main+0x16b>
  800190:	8b 45 94             	mov    -0x6c(%ebp),%eax
  800193:	89 c2                	mov    %eax,%edx
  800195:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800198:	01 c0                	add    %eax,%eax
  80019a:	2d 00 f0 ff 7f       	sub    $0x7ffff000,%eax
  80019f:	39 c2                	cmp    %eax,%edx
  8001a1:	76 14                	jbe    8001b7 <_main+0x17f>
  8001a3:	83 ec 04             	sub    $0x4,%esp
  8001a6:	68 50 35 80 00       	push   $0x803550
  8001ab:	6a 2d                	push   $0x2d
  8001ad:	68 3c 35 80 00       	push   $0x80353c
  8001b2:	e8 2a 05 00 00       	call   8006e1 <_panic>
		//		if ((freeFrames - sys_calculate_free_frames()) != 512 ) panic("Wrong allocation: ");
		if ((freeFrames - sys_calculate_free_frames()) != 0 ) panic("Wrong allocation: either extra pages are allocated in memory or pages not allocated correctly on PageFile");
  8001b7:	e8 77 1b 00 00       	call   801d33 <sys_calculate_free_frames>
  8001bc:	89 c2                	mov    %eax,%edx
  8001be:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8001c1:	39 c2                	cmp    %eax,%edx
  8001c3:	74 14                	je     8001d9 <_main+0x1a1>
  8001c5:	83 ec 04             	sub    $0x4,%esp
  8001c8:	68 80 35 80 00       	push   $0x803580
  8001cd:	6a 2f                	push   $0x2f
  8001cf:	68 3c 35 80 00       	push   $0x80353c
  8001d4:	e8 08 05 00 00       	call   8006e1 <_panic>
		if ((sys_pf_calculate_allocated_pages() - usedDiskPages) != 0) panic("Extra or less pages are allocated in PageFile");
  8001d9:	e8 f5 1b 00 00       	call   801dd3 <sys_pf_calculate_allocated_pages>
  8001de:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  8001e1:	74 14                	je     8001f7 <_main+0x1bf>
  8001e3:	83 ec 04             	sub    $0x4,%esp
  8001e6:	68 ec 35 80 00       	push   $0x8035ec
  8001eb:	6a 30                	push   $0x30
  8001ed:	68 3c 35 80 00       	push   $0x80353c
  8001f2:	e8 ea 04 00 00       	call   8006e1 <_panic>

		freeFrames = sys_calculate_free_frames() ;
  8001f7:	e8 37 1b 00 00       	call   801d33 <sys_calculate_free_frames>
  8001fc:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  8001ff:	e8 cf 1b 00 00       	call   801dd3 <sys_pf_calculate_allocated_pages>
  800204:	89 45 e0             	mov    %eax,-0x20(%ebp)
		ptr_allocations[2] = malloc(3*kilo);
  800207:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80020a:	89 c2                	mov    %eax,%edx
  80020c:	01 d2                	add    %edx,%edx
  80020e:	01 d0                	add    %edx,%eax
  800210:	83 ec 0c             	sub    $0xc,%esp
  800213:	50                   	push   %eax
  800214:	e8 0e 17 00 00       	call   801927 <malloc>
  800219:	83 c4 10             	add    $0x10,%esp
  80021c:	89 45 98             	mov    %eax,-0x68(%ebp)
		if ((uint32) ptr_allocations[2] < (USER_HEAP_START + 4*Mega) || (uint32) ptr_allocations[2] > (USER_HEAP_START + 4*Mega + PAGE_SIZE)) panic("Wrong start address for the allocated space... ");
  80021f:	8b 45 98             	mov    -0x68(%ebp),%eax
  800222:	89 c2                	mov    %eax,%edx
  800224:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800227:	c1 e0 02             	shl    $0x2,%eax
  80022a:	05 00 00 00 80       	add    $0x80000000,%eax
  80022f:	39 c2                	cmp    %eax,%edx
  800231:	72 14                	jb     800247 <_main+0x20f>
  800233:	8b 45 98             	mov    -0x68(%ebp),%eax
  800236:	89 c2                	mov    %eax,%edx
  800238:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80023b:	c1 e0 02             	shl    $0x2,%eax
  80023e:	2d 00 f0 ff 7f       	sub    $0x7ffff000,%eax
  800243:	39 c2                	cmp    %eax,%edx
  800245:	76 14                	jbe    80025b <_main+0x223>
  800247:	83 ec 04             	sub    $0x4,%esp
  80024a:	68 50 35 80 00       	push   $0x803550
  80024f:	6a 35                	push   $0x35
  800251:	68 3c 35 80 00       	push   $0x80353c
  800256:	e8 86 04 00 00       	call   8006e1 <_panic>
		//		if ((freeFrames - sys_calculate_free_frames()) != 1+1 ) panic("Wrong allocation: ");
		if ((freeFrames - sys_calculate_free_frames()) != 0 ) panic("Wrong allocation: either extra pages are allocated in memory or pages not allocated correctly on PageFile");
  80025b:	e8 d3 1a 00 00       	call   801d33 <sys_calculate_free_frames>
  800260:	89 c2                	mov    %eax,%edx
  800262:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800265:	39 c2                	cmp    %eax,%edx
  800267:	74 14                	je     80027d <_main+0x245>
  800269:	83 ec 04             	sub    $0x4,%esp
  80026c:	68 80 35 80 00       	push   $0x803580
  800271:	6a 37                	push   $0x37
  800273:	68 3c 35 80 00       	push   $0x80353c
  800278:	e8 64 04 00 00       	call   8006e1 <_panic>
		if ((sys_pf_calculate_allocated_pages() - usedDiskPages) != 0) panic("Extra or less pages are allocated in PageFile");
  80027d:	e8 51 1b 00 00       	call   801dd3 <sys_pf_calculate_allocated_pages>
  800282:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  800285:	74 14                	je     80029b <_main+0x263>
  800287:	83 ec 04             	sub    $0x4,%esp
  80028a:	68 ec 35 80 00       	push   $0x8035ec
  80028f:	6a 38                	push   $0x38
  800291:	68 3c 35 80 00       	push   $0x80353c
  800296:	e8 46 04 00 00       	call   8006e1 <_panic>

		freeFrames = sys_calculate_free_frames() ;
  80029b:	e8 93 1a 00 00       	call   801d33 <sys_calculate_free_frames>
  8002a0:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  8002a3:	e8 2b 1b 00 00       	call   801dd3 <sys_pf_calculate_allocated_pages>
  8002a8:	89 45 e0             	mov    %eax,-0x20(%ebp)
		ptr_allocations[3] = malloc(3*kilo);
  8002ab:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8002ae:	89 c2                	mov    %eax,%edx
  8002b0:	01 d2                	add    %edx,%edx
  8002b2:	01 d0                	add    %edx,%eax
  8002b4:	83 ec 0c             	sub    $0xc,%esp
  8002b7:	50                   	push   %eax
  8002b8:	e8 6a 16 00 00       	call   801927 <malloc>
  8002bd:	83 c4 10             	add    $0x10,%esp
  8002c0:	89 45 9c             	mov    %eax,-0x64(%ebp)
		if ((uint32) ptr_allocations[3] < (USER_HEAP_START + 4*Mega + 4*kilo) || (uint32) ptr_allocations[3] > (USER_HEAP_START + 4*Mega + 4*kilo + PAGE_SIZE)) panic("Wrong start address for the allocated space... ");
  8002c3:	8b 45 9c             	mov    -0x64(%ebp),%eax
  8002c6:	89 c2                	mov    %eax,%edx
  8002c8:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8002cb:	c1 e0 02             	shl    $0x2,%eax
  8002ce:	89 c1                	mov    %eax,%ecx
  8002d0:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8002d3:	c1 e0 02             	shl    $0x2,%eax
  8002d6:	01 c8                	add    %ecx,%eax
  8002d8:	05 00 00 00 80       	add    $0x80000000,%eax
  8002dd:	39 c2                	cmp    %eax,%edx
  8002df:	72 1e                	jb     8002ff <_main+0x2c7>
  8002e1:	8b 45 9c             	mov    -0x64(%ebp),%eax
  8002e4:	89 c2                	mov    %eax,%edx
  8002e6:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8002e9:	c1 e0 02             	shl    $0x2,%eax
  8002ec:	89 c1                	mov    %eax,%ecx
  8002ee:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8002f1:	c1 e0 02             	shl    $0x2,%eax
  8002f4:	01 c8                	add    %ecx,%eax
  8002f6:	2d 00 f0 ff 7f       	sub    $0x7ffff000,%eax
  8002fb:	39 c2                	cmp    %eax,%edx
  8002fd:	76 14                	jbe    800313 <_main+0x2db>
  8002ff:	83 ec 04             	sub    $0x4,%esp
  800302:	68 50 35 80 00       	push   $0x803550
  800307:	6a 3d                	push   $0x3d
  800309:	68 3c 35 80 00       	push   $0x80353c
  80030e:	e8 ce 03 00 00       	call   8006e1 <_panic>
		//		if ((freeFrames - sys_calculate_free_frames()) != 1 ) panic("Wrong allocation: ");
		if ((freeFrames - sys_calculate_free_frames()) != 0 ) panic("Wrong allocation: either extra pages are allocated in memory or pages not allocated correctly on PageFile");
  800313:	e8 1b 1a 00 00       	call   801d33 <sys_calculate_free_frames>
  800318:	89 c2                	mov    %eax,%edx
  80031a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80031d:	39 c2                	cmp    %eax,%edx
  80031f:	74 14                	je     800335 <_main+0x2fd>
  800321:	83 ec 04             	sub    $0x4,%esp
  800324:	68 80 35 80 00       	push   $0x803580
  800329:	6a 3f                	push   $0x3f
  80032b:	68 3c 35 80 00       	push   $0x80353c
  800330:	e8 ac 03 00 00       	call   8006e1 <_panic>
		if ((sys_pf_calculate_allocated_pages() - usedDiskPages) != 0) panic("Extra or less pages are allocated in PageFile");
  800335:	e8 99 1a 00 00       	call   801dd3 <sys_pf_calculate_allocated_pages>
  80033a:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  80033d:	74 14                	je     800353 <_main+0x31b>
  80033f:	83 ec 04             	sub    $0x4,%esp
  800342:	68 ec 35 80 00       	push   $0x8035ec
  800347:	6a 40                	push   $0x40
  800349:	68 3c 35 80 00       	push   $0x80353c
  80034e:	e8 8e 03 00 00       	call   8006e1 <_panic>

		freeFrames = sys_calculate_free_frames() ;
  800353:	e8 db 19 00 00       	call   801d33 <sys_calculate_free_frames>
  800358:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  80035b:	e8 73 1a 00 00       	call   801dd3 <sys_pf_calculate_allocated_pages>
  800360:	89 45 e0             	mov    %eax,-0x20(%ebp)
		ptr_allocations[4] = malloc(7*kilo);
  800363:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800366:	89 d0                	mov    %edx,%eax
  800368:	01 c0                	add    %eax,%eax
  80036a:	01 d0                	add    %edx,%eax
  80036c:	01 c0                	add    %eax,%eax
  80036e:	01 d0                	add    %edx,%eax
  800370:	83 ec 0c             	sub    $0xc,%esp
  800373:	50                   	push   %eax
  800374:	e8 ae 15 00 00       	call   801927 <malloc>
  800379:	83 c4 10             	add    $0x10,%esp
  80037c:	89 45 a0             	mov    %eax,-0x60(%ebp)
		if ((uint32) ptr_allocations[4] < (USER_HEAP_START + 4*Mega + 8*kilo) || (uint32) ptr_allocations[4] > (USER_HEAP_START + 4*Mega + 8*kilo + PAGE_SIZE)) panic("Wrong start address for the allocated space... ");
  80037f:	8b 45 a0             	mov    -0x60(%ebp),%eax
  800382:	89 c2                	mov    %eax,%edx
  800384:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800387:	c1 e0 02             	shl    $0x2,%eax
  80038a:	89 c1                	mov    %eax,%ecx
  80038c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80038f:	c1 e0 03             	shl    $0x3,%eax
  800392:	01 c8                	add    %ecx,%eax
  800394:	05 00 00 00 80       	add    $0x80000000,%eax
  800399:	39 c2                	cmp    %eax,%edx
  80039b:	72 1e                	jb     8003bb <_main+0x383>
  80039d:	8b 45 a0             	mov    -0x60(%ebp),%eax
  8003a0:	89 c2                	mov    %eax,%edx
  8003a2:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8003a5:	c1 e0 02             	shl    $0x2,%eax
  8003a8:	89 c1                	mov    %eax,%ecx
  8003aa:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8003ad:	c1 e0 03             	shl    $0x3,%eax
  8003b0:	01 c8                	add    %ecx,%eax
  8003b2:	2d 00 f0 ff 7f       	sub    $0x7ffff000,%eax
  8003b7:	39 c2                	cmp    %eax,%edx
  8003b9:	76 14                	jbe    8003cf <_main+0x397>
  8003bb:	83 ec 04             	sub    $0x4,%esp
  8003be:	68 50 35 80 00       	push   $0x803550
  8003c3:	6a 45                	push   $0x45
  8003c5:	68 3c 35 80 00       	push   $0x80353c
  8003ca:	e8 12 03 00 00       	call   8006e1 <_panic>
		//		if ((freeFrames - sys_calculate_free_frames()) != 2)panic("Wrong allocation: ");
		if ((freeFrames - sys_calculate_free_frames()) != 0 ) panic("Wrong allocation: either extra pages are allocated in memory or pages not allocated correctly on PageFile");
  8003cf:	e8 5f 19 00 00       	call   801d33 <sys_calculate_free_frames>
  8003d4:	89 c2                	mov    %eax,%edx
  8003d6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8003d9:	39 c2                	cmp    %eax,%edx
  8003db:	74 14                	je     8003f1 <_main+0x3b9>
  8003dd:	83 ec 04             	sub    $0x4,%esp
  8003e0:	68 80 35 80 00       	push   $0x803580
  8003e5:	6a 47                	push   $0x47
  8003e7:	68 3c 35 80 00       	push   $0x80353c
  8003ec:	e8 f0 02 00 00       	call   8006e1 <_panic>
		if ((sys_pf_calculate_allocated_pages() - usedDiskPages) != 0) panic("Extra or less pages are allocated in PageFile");
  8003f1:	e8 dd 19 00 00       	call   801dd3 <sys_pf_calculate_allocated_pages>
  8003f6:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  8003f9:	74 14                	je     80040f <_main+0x3d7>
  8003fb:	83 ec 04             	sub    $0x4,%esp
  8003fe:	68 ec 35 80 00       	push   $0x8035ec
  800403:	6a 48                	push   $0x48
  800405:	68 3c 35 80 00       	push   $0x80353c
  80040a:	e8 d2 02 00 00       	call   8006e1 <_panic>

		freeFrames = sys_calculate_free_frames() ;
  80040f:	e8 1f 19 00 00       	call   801d33 <sys_calculate_free_frames>
  800414:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  800417:	e8 b7 19 00 00       	call   801dd3 <sys_pf_calculate_allocated_pages>
  80041c:	89 45 e0             	mov    %eax,-0x20(%ebp)
		ptr_allocations[5] = malloc(3*Mega-kilo);
  80041f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800422:	89 c2                	mov    %eax,%edx
  800424:	01 d2                	add    %edx,%edx
  800426:	01 d0                	add    %edx,%eax
  800428:	2b 45 e8             	sub    -0x18(%ebp),%eax
  80042b:	83 ec 0c             	sub    $0xc,%esp
  80042e:	50                   	push   %eax
  80042f:	e8 f3 14 00 00       	call   801927 <malloc>
  800434:	83 c4 10             	add    $0x10,%esp
  800437:	89 45 a4             	mov    %eax,-0x5c(%ebp)
		if ((uint32) ptr_allocations[5] < (USER_HEAP_START + 4*Mega + 16*kilo) || (uint32) ptr_allocations[5] > (USER_HEAP_START + 4*Mega + 16*kilo + PAGE_SIZE)) panic("Wrong start address for the allocated space... ");
  80043a:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  80043d:	89 c2                	mov    %eax,%edx
  80043f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800442:	c1 e0 02             	shl    $0x2,%eax
  800445:	89 c1                	mov    %eax,%ecx
  800447:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80044a:	c1 e0 04             	shl    $0x4,%eax
  80044d:	01 c8                	add    %ecx,%eax
  80044f:	05 00 00 00 80       	add    $0x80000000,%eax
  800454:	39 c2                	cmp    %eax,%edx
  800456:	72 1e                	jb     800476 <_main+0x43e>
  800458:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  80045b:	89 c2                	mov    %eax,%edx
  80045d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800460:	c1 e0 02             	shl    $0x2,%eax
  800463:	89 c1                	mov    %eax,%ecx
  800465:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800468:	c1 e0 04             	shl    $0x4,%eax
  80046b:	01 c8                	add    %ecx,%eax
  80046d:	2d 00 f0 ff 7f       	sub    $0x7ffff000,%eax
  800472:	39 c2                	cmp    %eax,%edx
  800474:	76 14                	jbe    80048a <_main+0x452>
  800476:	83 ec 04             	sub    $0x4,%esp
  800479:	68 50 35 80 00       	push   $0x803550
  80047e:	6a 4d                	push   $0x4d
  800480:	68 3c 35 80 00       	push   $0x80353c
  800485:	e8 57 02 00 00       	call   8006e1 <_panic>
		if ((freeFrames - sys_calculate_free_frames()) != 0 ) panic("Wrong allocation: ");
  80048a:	e8 a4 18 00 00       	call   801d33 <sys_calculate_free_frames>
  80048f:	89 c2                	mov    %eax,%edx
  800491:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800494:	39 c2                	cmp    %eax,%edx
  800496:	74 14                	je     8004ac <_main+0x474>
  800498:	83 ec 04             	sub    $0x4,%esp
  80049b:	68 1a 36 80 00       	push   $0x80361a
  8004a0:	6a 4e                	push   $0x4e
  8004a2:	68 3c 35 80 00       	push   $0x80353c
  8004a7:	e8 35 02 00 00       	call   8006e1 <_panic>
		if ((sys_pf_calculate_allocated_pages() - usedDiskPages) != 0) panic("Extra or less pages are allocated in PageFile");
  8004ac:	e8 22 19 00 00       	call   801dd3 <sys_pf_calculate_allocated_pages>
  8004b1:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  8004b4:	74 14                	je     8004ca <_main+0x492>
  8004b6:	83 ec 04             	sub    $0x4,%esp
  8004b9:	68 ec 35 80 00       	push   $0x8035ec
  8004be:	6a 4f                	push   $0x4f
  8004c0:	68 3c 35 80 00       	push   $0x80353c
  8004c5:	e8 17 02 00 00       	call   8006e1 <_panic>

		freeFrames = sys_calculate_free_frames() ;
  8004ca:	e8 64 18 00 00       	call   801d33 <sys_calculate_free_frames>
  8004cf:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  8004d2:	e8 fc 18 00 00       	call   801dd3 <sys_pf_calculate_allocated_pages>
  8004d7:	89 45 e0             	mov    %eax,-0x20(%ebp)
		ptr_allocations[6] = malloc(2*Mega-kilo);
  8004da:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8004dd:	01 c0                	add    %eax,%eax
  8004df:	2b 45 e8             	sub    -0x18(%ebp),%eax
  8004e2:	83 ec 0c             	sub    $0xc,%esp
  8004e5:	50                   	push   %eax
  8004e6:	e8 3c 14 00 00       	call   801927 <malloc>
  8004eb:	83 c4 10             	add    $0x10,%esp
  8004ee:	89 45 a8             	mov    %eax,-0x58(%ebp)
		if ((uint32) ptr_allocations[6] < (USER_HEAP_START + 7*Mega + 16*kilo) || (uint32) ptr_allocations[6] > (USER_HEAP_START + 7*Mega + 16*kilo + PAGE_SIZE)) panic("Wrong start address for the allocated space... ");
  8004f1:	8b 45 a8             	mov    -0x58(%ebp),%eax
  8004f4:	89 c1                	mov    %eax,%ecx
  8004f6:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8004f9:	89 d0                	mov    %edx,%eax
  8004fb:	01 c0                	add    %eax,%eax
  8004fd:	01 d0                	add    %edx,%eax
  8004ff:	01 c0                	add    %eax,%eax
  800501:	01 d0                	add    %edx,%eax
  800503:	89 c2                	mov    %eax,%edx
  800505:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800508:	c1 e0 04             	shl    $0x4,%eax
  80050b:	01 d0                	add    %edx,%eax
  80050d:	05 00 00 00 80       	add    $0x80000000,%eax
  800512:	39 c1                	cmp    %eax,%ecx
  800514:	72 25                	jb     80053b <_main+0x503>
  800516:	8b 45 a8             	mov    -0x58(%ebp),%eax
  800519:	89 c1                	mov    %eax,%ecx
  80051b:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80051e:	89 d0                	mov    %edx,%eax
  800520:	01 c0                	add    %eax,%eax
  800522:	01 d0                	add    %edx,%eax
  800524:	01 c0                	add    %eax,%eax
  800526:	01 d0                	add    %edx,%eax
  800528:	89 c2                	mov    %eax,%edx
  80052a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80052d:	c1 e0 04             	shl    $0x4,%eax
  800530:	01 d0                	add    %edx,%eax
  800532:	2d 00 f0 ff 7f       	sub    $0x7ffff000,%eax
  800537:	39 c1                	cmp    %eax,%ecx
  800539:	76 14                	jbe    80054f <_main+0x517>
  80053b:	83 ec 04             	sub    $0x4,%esp
  80053e:	68 50 35 80 00       	push   $0x803550
  800543:	6a 54                	push   $0x54
  800545:	68 3c 35 80 00       	push   $0x80353c
  80054a:	e8 92 01 00 00       	call   8006e1 <_panic>
		if ((freeFrames - sys_calculate_free_frames()) != 0 ) panic("Wrong allocation: ");
  80054f:	e8 df 17 00 00       	call   801d33 <sys_calculate_free_frames>
  800554:	89 c2                	mov    %eax,%edx
  800556:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800559:	39 c2                	cmp    %eax,%edx
  80055b:	74 14                	je     800571 <_main+0x539>
  80055d:	83 ec 04             	sub    $0x4,%esp
  800560:	68 1a 36 80 00       	push   $0x80361a
  800565:	6a 55                	push   $0x55
  800567:	68 3c 35 80 00       	push   $0x80353c
  80056c:	e8 70 01 00 00       	call   8006e1 <_panic>
		if ((sys_pf_calculate_allocated_pages() - usedDiskPages) != 0) panic("Extra or less pages are allocated in PageFile");
  800571:	e8 5d 18 00 00       	call   801dd3 <sys_pf_calculate_allocated_pages>
  800576:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  800579:	74 14                	je     80058f <_main+0x557>
  80057b:	83 ec 04             	sub    $0x4,%esp
  80057e:	68 ec 35 80 00       	push   $0x8035ec
  800583:	6a 56                	push   $0x56
  800585:	68 3c 35 80 00       	push   $0x80353c
  80058a:	e8 52 01 00 00       	call   8006e1 <_panic>
	}

	cprintf("Congratulations!! test malloc (1) completed successfully.\n");
  80058f:	83 ec 0c             	sub    $0xc,%esp
  800592:	68 30 36 80 00       	push   $0x803630
  800597:	e8 f9 03 00 00       	call   800995 <cprintf>
  80059c:	83 c4 10             	add    $0x10,%esp

	return;
  80059f:	90                   	nop
}
  8005a0:	8b 7d fc             	mov    -0x4(%ebp),%edi
  8005a3:	c9                   	leave  
  8005a4:	c3                   	ret    

008005a5 <libmain>:
volatile struct Env *myEnv = NULL;
volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";

void
libmain(int argc, char **argv)
{
  8005a5:	55                   	push   %ebp
  8005a6:	89 e5                	mov    %esp,%ebp
  8005a8:	83 ec 18             	sub    $0x18,%esp
	int envIndex = sys_getenvindex();
  8005ab:	e8 63 1a 00 00       	call   802013 <sys_getenvindex>
  8005b0:	89 45 f4             	mov    %eax,-0xc(%ebp)
	myEnv = &(envs[envIndex]);
  8005b3:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8005b6:	89 d0                	mov    %edx,%eax
  8005b8:	c1 e0 03             	shl    $0x3,%eax
  8005bb:	01 d0                	add    %edx,%eax
  8005bd:	01 c0                	add    %eax,%eax
  8005bf:	01 d0                	add    %edx,%eax
  8005c1:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8005c8:	01 d0                	add    %edx,%eax
  8005ca:	c1 e0 04             	shl    $0x4,%eax
  8005cd:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8005d2:	a3 20 40 80 00       	mov    %eax,0x804020

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  8005d7:	a1 20 40 80 00       	mov    0x804020,%eax
  8005dc:	8a 80 5c 05 00 00    	mov    0x55c(%eax),%al
  8005e2:	84 c0                	test   %al,%al
  8005e4:	74 0f                	je     8005f5 <libmain+0x50>
		binaryname = myEnv->prog_name;
  8005e6:	a1 20 40 80 00       	mov    0x804020,%eax
  8005eb:	05 5c 05 00 00       	add    $0x55c,%eax
  8005f0:	a3 00 40 80 00       	mov    %eax,0x804000

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8005f5:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8005f9:	7e 0a                	jle    800605 <libmain+0x60>
		binaryname = argv[0];
  8005fb:	8b 45 0c             	mov    0xc(%ebp),%eax
  8005fe:	8b 00                	mov    (%eax),%eax
  800600:	a3 00 40 80 00       	mov    %eax,0x804000

	// call user main routine
	_main(argc, argv);
  800605:	83 ec 08             	sub    $0x8,%esp
  800608:	ff 75 0c             	pushl  0xc(%ebp)
  80060b:	ff 75 08             	pushl  0x8(%ebp)
  80060e:	e8 25 fa ff ff       	call   800038 <_main>
  800613:	83 c4 10             	add    $0x10,%esp



	sys_disable_interrupt();
  800616:	e8 05 18 00 00       	call   801e20 <sys_disable_interrupt>
	cprintf("**************************************\n");
  80061b:	83 ec 0c             	sub    $0xc,%esp
  80061e:	68 84 36 80 00       	push   $0x803684
  800623:	e8 6d 03 00 00       	call   800995 <cprintf>
  800628:	83 c4 10             	add    $0x10,%esp
	cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  80062b:	a1 20 40 80 00       	mov    0x804020,%eax
  800630:	8b 90 44 05 00 00    	mov    0x544(%eax),%edx
  800636:	a1 20 40 80 00       	mov    0x804020,%eax
  80063b:	8b 80 34 05 00 00    	mov    0x534(%eax),%eax
  800641:	83 ec 04             	sub    $0x4,%esp
  800644:	52                   	push   %edx
  800645:	50                   	push   %eax
  800646:	68 ac 36 80 00       	push   $0x8036ac
  80064b:	e8 45 03 00 00       	call   800995 <cprintf>
  800650:	83 c4 10             	add    $0x10,%esp
	cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  800653:	a1 20 40 80 00       	mov    0x804020,%eax
  800658:	8b 88 54 05 00 00    	mov    0x554(%eax),%ecx
  80065e:	a1 20 40 80 00       	mov    0x804020,%eax
  800663:	8b 90 50 05 00 00    	mov    0x550(%eax),%edx
  800669:	a1 20 40 80 00       	mov    0x804020,%eax
  80066e:	8b 80 4c 05 00 00    	mov    0x54c(%eax),%eax
  800674:	51                   	push   %ecx
  800675:	52                   	push   %edx
  800676:	50                   	push   %eax
  800677:	68 d4 36 80 00       	push   $0x8036d4
  80067c:	e8 14 03 00 00       	call   800995 <cprintf>
  800681:	83 c4 10             	add    $0x10,%esp
	//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
	cprintf("Num of clocks = %d\n", myEnv->nClocks);
  800684:	a1 20 40 80 00       	mov    0x804020,%eax
  800689:	8b 80 a4 05 00 00    	mov    0x5a4(%eax),%eax
  80068f:	83 ec 08             	sub    $0x8,%esp
  800692:	50                   	push   %eax
  800693:	68 2c 37 80 00       	push   $0x80372c
  800698:	e8 f8 02 00 00       	call   800995 <cprintf>
  80069d:	83 c4 10             	add    $0x10,%esp
	cprintf("**************************************\n");
  8006a0:	83 ec 0c             	sub    $0xc,%esp
  8006a3:	68 84 36 80 00       	push   $0x803684
  8006a8:	e8 e8 02 00 00       	call   800995 <cprintf>
  8006ad:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  8006b0:	e8 85 17 00 00       	call   801e3a <sys_enable_interrupt>

	// exit gracefully
	exit();
  8006b5:	e8 19 00 00 00       	call   8006d3 <exit>
}
  8006ba:	90                   	nop
  8006bb:	c9                   	leave  
  8006bc:	c3                   	ret    

008006bd <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  8006bd:	55                   	push   %ebp
  8006be:	89 e5                	mov    %esp,%ebp
  8006c0:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  8006c3:	83 ec 0c             	sub    $0xc,%esp
  8006c6:	6a 00                	push   $0x0
  8006c8:	e8 12 19 00 00       	call   801fdf <sys_destroy_env>
  8006cd:	83 c4 10             	add    $0x10,%esp
}
  8006d0:	90                   	nop
  8006d1:	c9                   	leave  
  8006d2:	c3                   	ret    

008006d3 <exit>:

void
exit(void)
{
  8006d3:	55                   	push   %ebp
  8006d4:	89 e5                	mov    %esp,%ebp
  8006d6:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  8006d9:	e8 67 19 00 00       	call   802045 <sys_exit_env>
}
  8006de:	90                   	nop
  8006df:	c9                   	leave  
  8006e0:	c3                   	ret    

008006e1 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  8006e1:	55                   	push   %ebp
  8006e2:	89 e5                	mov    %esp,%ebp
  8006e4:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  8006e7:	8d 45 10             	lea    0x10(%ebp),%eax
  8006ea:	83 c0 04             	add    $0x4,%eax
  8006ed:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  8006f0:	a1 5c 41 80 00       	mov    0x80415c,%eax
  8006f5:	85 c0                	test   %eax,%eax
  8006f7:	74 16                	je     80070f <_panic+0x2e>
		cprintf("%s: ", argv0);
  8006f9:	a1 5c 41 80 00       	mov    0x80415c,%eax
  8006fe:	83 ec 08             	sub    $0x8,%esp
  800701:	50                   	push   %eax
  800702:	68 40 37 80 00       	push   $0x803740
  800707:	e8 89 02 00 00       	call   800995 <cprintf>
  80070c:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  80070f:	a1 00 40 80 00       	mov    0x804000,%eax
  800714:	ff 75 0c             	pushl  0xc(%ebp)
  800717:	ff 75 08             	pushl  0x8(%ebp)
  80071a:	50                   	push   %eax
  80071b:	68 45 37 80 00       	push   $0x803745
  800720:	e8 70 02 00 00       	call   800995 <cprintf>
  800725:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  800728:	8b 45 10             	mov    0x10(%ebp),%eax
  80072b:	83 ec 08             	sub    $0x8,%esp
  80072e:	ff 75 f4             	pushl  -0xc(%ebp)
  800731:	50                   	push   %eax
  800732:	e8 f3 01 00 00       	call   80092a <vcprintf>
  800737:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  80073a:	83 ec 08             	sub    $0x8,%esp
  80073d:	6a 00                	push   $0x0
  80073f:	68 61 37 80 00       	push   $0x803761
  800744:	e8 e1 01 00 00       	call   80092a <vcprintf>
  800749:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  80074c:	e8 82 ff ff ff       	call   8006d3 <exit>

	// should not return here
	while (1) ;
  800751:	eb fe                	jmp    800751 <_panic+0x70>

00800753 <CheckWSWithoutLastIndex>:
}

void CheckWSWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  800753:	55                   	push   %ebp
  800754:	89 e5                	mov    %esp,%ebp
  800756:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  800759:	a1 20 40 80 00       	mov    0x804020,%eax
  80075e:	8b 50 74             	mov    0x74(%eax),%edx
  800761:	8b 45 0c             	mov    0xc(%ebp),%eax
  800764:	39 c2                	cmp    %eax,%edx
  800766:	74 14                	je     80077c <CheckWSWithoutLastIndex+0x29>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  800768:	83 ec 04             	sub    $0x4,%esp
  80076b:	68 64 37 80 00       	push   $0x803764
  800770:	6a 26                	push   $0x26
  800772:	68 b0 37 80 00       	push   $0x8037b0
  800777:	e8 65 ff ff ff       	call   8006e1 <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  80077c:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  800783:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  80078a:	e9 c2 00 00 00       	jmp    800851 <CheckWSWithoutLastIndex+0xfe>
		if (expectedPages[e] == 0) {
  80078f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800792:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800799:	8b 45 08             	mov    0x8(%ebp),%eax
  80079c:	01 d0                	add    %edx,%eax
  80079e:	8b 00                	mov    (%eax),%eax
  8007a0:	85 c0                	test   %eax,%eax
  8007a2:	75 08                	jne    8007ac <CheckWSWithoutLastIndex+0x59>
			expectedNumOfEmptyLocs++;
  8007a4:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  8007a7:	e9 a2 00 00 00       	jmp    80084e <CheckWSWithoutLastIndex+0xfb>
		}
		int found = 0;
  8007ac:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8007b3:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  8007ba:	eb 69                	jmp    800825 <CheckWSWithoutLastIndex+0xd2>
			if (myEnv->__uptr_pws[w].empty == 0) {
  8007bc:	a1 20 40 80 00       	mov    0x804020,%eax
  8007c1:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  8007c7:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8007ca:	89 d0                	mov    %edx,%eax
  8007cc:	01 c0                	add    %eax,%eax
  8007ce:	01 d0                	add    %edx,%eax
  8007d0:	c1 e0 03             	shl    $0x3,%eax
  8007d3:	01 c8                	add    %ecx,%eax
  8007d5:	8a 40 04             	mov    0x4(%eax),%al
  8007d8:	84 c0                	test   %al,%al
  8007da:	75 46                	jne    800822 <CheckWSWithoutLastIndex+0xcf>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  8007dc:	a1 20 40 80 00       	mov    0x804020,%eax
  8007e1:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  8007e7:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8007ea:	89 d0                	mov    %edx,%eax
  8007ec:	01 c0                	add    %eax,%eax
  8007ee:	01 d0                	add    %edx,%eax
  8007f0:	c1 e0 03             	shl    $0x3,%eax
  8007f3:	01 c8                	add    %ecx,%eax
  8007f5:	8b 00                	mov    (%eax),%eax
  8007f7:	89 45 dc             	mov    %eax,-0x24(%ebp)
  8007fa:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8007fd:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800802:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  800804:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800807:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  80080e:	8b 45 08             	mov    0x8(%ebp),%eax
  800811:	01 c8                	add    %ecx,%eax
  800813:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  800815:	39 c2                	cmp    %eax,%edx
  800817:	75 09                	jne    800822 <CheckWSWithoutLastIndex+0xcf>
						== expectedPages[e]) {
					found = 1;
  800819:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  800820:	eb 12                	jmp    800834 <CheckWSWithoutLastIndex+0xe1>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800822:	ff 45 e8             	incl   -0x18(%ebp)
  800825:	a1 20 40 80 00       	mov    0x804020,%eax
  80082a:	8b 50 74             	mov    0x74(%eax),%edx
  80082d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800830:	39 c2                	cmp    %eax,%edx
  800832:	77 88                	ja     8007bc <CheckWSWithoutLastIndex+0x69>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  800834:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  800838:	75 14                	jne    80084e <CheckWSWithoutLastIndex+0xfb>
			panic(
  80083a:	83 ec 04             	sub    $0x4,%esp
  80083d:	68 bc 37 80 00       	push   $0x8037bc
  800842:	6a 3a                	push   $0x3a
  800844:	68 b0 37 80 00       	push   $0x8037b0
  800849:	e8 93 fe ff ff       	call   8006e1 <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  80084e:	ff 45 f0             	incl   -0x10(%ebp)
  800851:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800854:	3b 45 0c             	cmp    0xc(%ebp),%eax
  800857:	0f 8c 32 ff ff ff    	jl     80078f <CheckWSWithoutLastIndex+0x3c>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  80085d:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800864:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  80086b:	eb 26                	jmp    800893 <CheckWSWithoutLastIndex+0x140>
		if (myEnv->__uptr_pws[w].empty == 1) {
  80086d:	a1 20 40 80 00       	mov    0x804020,%eax
  800872:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  800878:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80087b:	89 d0                	mov    %edx,%eax
  80087d:	01 c0                	add    %eax,%eax
  80087f:	01 d0                	add    %edx,%eax
  800881:	c1 e0 03             	shl    $0x3,%eax
  800884:	01 c8                	add    %ecx,%eax
  800886:	8a 40 04             	mov    0x4(%eax),%al
  800889:	3c 01                	cmp    $0x1,%al
  80088b:	75 03                	jne    800890 <CheckWSWithoutLastIndex+0x13d>
			actualNumOfEmptyLocs++;
  80088d:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800890:	ff 45 e0             	incl   -0x20(%ebp)
  800893:	a1 20 40 80 00       	mov    0x804020,%eax
  800898:	8b 50 74             	mov    0x74(%eax),%edx
  80089b:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80089e:	39 c2                	cmp    %eax,%edx
  8008a0:	77 cb                	ja     80086d <CheckWSWithoutLastIndex+0x11a>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  8008a2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8008a5:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  8008a8:	74 14                	je     8008be <CheckWSWithoutLastIndex+0x16b>
		panic(
  8008aa:	83 ec 04             	sub    $0x4,%esp
  8008ad:	68 10 38 80 00       	push   $0x803810
  8008b2:	6a 44                	push   $0x44
  8008b4:	68 b0 37 80 00       	push   $0x8037b0
  8008b9:	e8 23 fe ff ff       	call   8006e1 <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  8008be:	90                   	nop
  8008bf:	c9                   	leave  
  8008c0:	c3                   	ret    

008008c1 <putch>:
};

//2017:
uint8 printProgName = 0;

static void putch(int ch, struct printbuf *b) {
  8008c1:	55                   	push   %ebp
  8008c2:	89 e5                	mov    %esp,%ebp
  8008c4:	83 ec 08             	sub    $0x8,%esp
	b->buf[b->idx++] = ch;
  8008c7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8008ca:	8b 00                	mov    (%eax),%eax
  8008cc:	8d 48 01             	lea    0x1(%eax),%ecx
  8008cf:	8b 55 0c             	mov    0xc(%ebp),%edx
  8008d2:	89 0a                	mov    %ecx,(%edx)
  8008d4:	8b 55 08             	mov    0x8(%ebp),%edx
  8008d7:	88 d1                	mov    %dl,%cl
  8008d9:	8b 55 0c             	mov    0xc(%ebp),%edx
  8008dc:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  8008e0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8008e3:	8b 00                	mov    (%eax),%eax
  8008e5:	3d ff 00 00 00       	cmp    $0xff,%eax
  8008ea:	75 2c                	jne    800918 <putch+0x57>
		sys_cputs(b->buf, b->idx, printProgName);
  8008ec:	a0 24 40 80 00       	mov    0x804024,%al
  8008f1:	0f b6 c0             	movzbl %al,%eax
  8008f4:	8b 55 0c             	mov    0xc(%ebp),%edx
  8008f7:	8b 12                	mov    (%edx),%edx
  8008f9:	89 d1                	mov    %edx,%ecx
  8008fb:	8b 55 0c             	mov    0xc(%ebp),%edx
  8008fe:	83 c2 08             	add    $0x8,%edx
  800901:	83 ec 04             	sub    $0x4,%esp
  800904:	50                   	push   %eax
  800905:	51                   	push   %ecx
  800906:	52                   	push   %edx
  800907:	e8 66 13 00 00       	call   801c72 <sys_cputs>
  80090c:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  80090f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800912:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  800918:	8b 45 0c             	mov    0xc(%ebp),%eax
  80091b:	8b 40 04             	mov    0x4(%eax),%eax
  80091e:	8d 50 01             	lea    0x1(%eax),%edx
  800921:	8b 45 0c             	mov    0xc(%ebp),%eax
  800924:	89 50 04             	mov    %edx,0x4(%eax)
}
  800927:	90                   	nop
  800928:	c9                   	leave  
  800929:	c3                   	ret    

0080092a <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  80092a:	55                   	push   %ebp
  80092b:	89 e5                	mov    %esp,%ebp
  80092d:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  800933:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  80093a:	00 00 00 
	b.cnt = 0;
  80093d:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800944:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  800947:	ff 75 0c             	pushl  0xc(%ebp)
  80094a:	ff 75 08             	pushl  0x8(%ebp)
  80094d:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800953:	50                   	push   %eax
  800954:	68 c1 08 80 00       	push   $0x8008c1
  800959:	e8 11 02 00 00       	call   800b6f <vprintfmt>
  80095e:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName);
  800961:	a0 24 40 80 00       	mov    0x804024,%al
  800966:	0f b6 c0             	movzbl %al,%eax
  800969:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  80096f:	83 ec 04             	sub    $0x4,%esp
  800972:	50                   	push   %eax
  800973:	52                   	push   %edx
  800974:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  80097a:	83 c0 08             	add    $0x8,%eax
  80097d:	50                   	push   %eax
  80097e:	e8 ef 12 00 00       	call   801c72 <sys_cputs>
  800983:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  800986:	c6 05 24 40 80 00 00 	movb   $0x0,0x804024
	return b.cnt;
  80098d:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  800993:	c9                   	leave  
  800994:	c3                   	ret    

00800995 <cprintf>:

int cprintf(const char *fmt, ...) {
  800995:	55                   	push   %ebp
  800996:	89 e5                	mov    %esp,%ebp
  800998:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  80099b:	c6 05 24 40 80 00 01 	movb   $0x1,0x804024
	va_start(ap, fmt);
  8009a2:	8d 45 0c             	lea    0xc(%ebp),%eax
  8009a5:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  8009a8:	8b 45 08             	mov    0x8(%ebp),%eax
  8009ab:	83 ec 08             	sub    $0x8,%esp
  8009ae:	ff 75 f4             	pushl  -0xc(%ebp)
  8009b1:	50                   	push   %eax
  8009b2:	e8 73 ff ff ff       	call   80092a <vcprintf>
  8009b7:	83 c4 10             	add    $0x10,%esp
  8009ba:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  8009bd:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8009c0:	c9                   	leave  
  8009c1:	c3                   	ret    

008009c2 <atomic_cprintf>:

int atomic_cprintf(const char *fmt, ...) {
  8009c2:	55                   	push   %ebp
  8009c3:	89 e5                	mov    %esp,%ebp
  8009c5:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  8009c8:	e8 53 14 00 00       	call   801e20 <sys_disable_interrupt>
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  8009cd:	8d 45 0c             	lea    0xc(%ebp),%eax
  8009d0:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  8009d3:	8b 45 08             	mov    0x8(%ebp),%eax
  8009d6:	83 ec 08             	sub    $0x8,%esp
  8009d9:	ff 75 f4             	pushl  -0xc(%ebp)
  8009dc:	50                   	push   %eax
  8009dd:	e8 48 ff ff ff       	call   80092a <vcprintf>
  8009e2:	83 c4 10             	add    $0x10,%esp
  8009e5:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	sys_enable_interrupt();
  8009e8:	e8 4d 14 00 00       	call   801e3a <sys_enable_interrupt>
	return cnt;
  8009ed:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8009f0:	c9                   	leave  
  8009f1:	c3                   	ret    

008009f2 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8009f2:	55                   	push   %ebp
  8009f3:	89 e5                	mov    %esp,%ebp
  8009f5:	53                   	push   %ebx
  8009f6:	83 ec 14             	sub    $0x14,%esp
  8009f9:	8b 45 10             	mov    0x10(%ebp),%eax
  8009fc:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8009ff:	8b 45 14             	mov    0x14(%ebp),%eax
  800a02:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800a05:	8b 45 18             	mov    0x18(%ebp),%eax
  800a08:	ba 00 00 00 00       	mov    $0x0,%edx
  800a0d:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800a10:	77 55                	ja     800a67 <printnum+0x75>
  800a12:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800a15:	72 05                	jb     800a1c <printnum+0x2a>
  800a17:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800a1a:	77 4b                	ja     800a67 <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800a1c:	8b 45 1c             	mov    0x1c(%ebp),%eax
  800a1f:	8d 58 ff             	lea    -0x1(%eax),%ebx
  800a22:	8b 45 18             	mov    0x18(%ebp),%eax
  800a25:	ba 00 00 00 00       	mov    $0x0,%edx
  800a2a:	52                   	push   %edx
  800a2b:	50                   	push   %eax
  800a2c:	ff 75 f4             	pushl  -0xc(%ebp)
  800a2f:	ff 75 f0             	pushl  -0x10(%ebp)
  800a32:	e8 85 28 00 00       	call   8032bc <__udivdi3>
  800a37:	83 c4 10             	add    $0x10,%esp
  800a3a:	83 ec 04             	sub    $0x4,%esp
  800a3d:	ff 75 20             	pushl  0x20(%ebp)
  800a40:	53                   	push   %ebx
  800a41:	ff 75 18             	pushl  0x18(%ebp)
  800a44:	52                   	push   %edx
  800a45:	50                   	push   %eax
  800a46:	ff 75 0c             	pushl  0xc(%ebp)
  800a49:	ff 75 08             	pushl  0x8(%ebp)
  800a4c:	e8 a1 ff ff ff       	call   8009f2 <printnum>
  800a51:	83 c4 20             	add    $0x20,%esp
  800a54:	eb 1a                	jmp    800a70 <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800a56:	83 ec 08             	sub    $0x8,%esp
  800a59:	ff 75 0c             	pushl  0xc(%ebp)
  800a5c:	ff 75 20             	pushl  0x20(%ebp)
  800a5f:	8b 45 08             	mov    0x8(%ebp),%eax
  800a62:	ff d0                	call   *%eax
  800a64:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800a67:	ff 4d 1c             	decl   0x1c(%ebp)
  800a6a:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  800a6e:	7f e6                	jg     800a56 <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800a70:	8b 4d 18             	mov    0x18(%ebp),%ecx
  800a73:	bb 00 00 00 00       	mov    $0x0,%ebx
  800a78:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800a7b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800a7e:	53                   	push   %ebx
  800a7f:	51                   	push   %ecx
  800a80:	52                   	push   %edx
  800a81:	50                   	push   %eax
  800a82:	e8 45 29 00 00       	call   8033cc <__umoddi3>
  800a87:	83 c4 10             	add    $0x10,%esp
  800a8a:	05 74 3a 80 00       	add    $0x803a74,%eax
  800a8f:	8a 00                	mov    (%eax),%al
  800a91:	0f be c0             	movsbl %al,%eax
  800a94:	83 ec 08             	sub    $0x8,%esp
  800a97:	ff 75 0c             	pushl  0xc(%ebp)
  800a9a:	50                   	push   %eax
  800a9b:	8b 45 08             	mov    0x8(%ebp),%eax
  800a9e:	ff d0                	call   *%eax
  800aa0:	83 c4 10             	add    $0x10,%esp
}
  800aa3:	90                   	nop
  800aa4:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800aa7:	c9                   	leave  
  800aa8:	c3                   	ret    

00800aa9 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  800aa9:	55                   	push   %ebp
  800aaa:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800aac:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800ab0:	7e 1c                	jle    800ace <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  800ab2:	8b 45 08             	mov    0x8(%ebp),%eax
  800ab5:	8b 00                	mov    (%eax),%eax
  800ab7:	8d 50 08             	lea    0x8(%eax),%edx
  800aba:	8b 45 08             	mov    0x8(%ebp),%eax
  800abd:	89 10                	mov    %edx,(%eax)
  800abf:	8b 45 08             	mov    0x8(%ebp),%eax
  800ac2:	8b 00                	mov    (%eax),%eax
  800ac4:	83 e8 08             	sub    $0x8,%eax
  800ac7:	8b 50 04             	mov    0x4(%eax),%edx
  800aca:	8b 00                	mov    (%eax),%eax
  800acc:	eb 40                	jmp    800b0e <getuint+0x65>
	else if (lflag)
  800ace:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800ad2:	74 1e                	je     800af2 <getuint+0x49>
		return va_arg(*ap, unsigned long);
  800ad4:	8b 45 08             	mov    0x8(%ebp),%eax
  800ad7:	8b 00                	mov    (%eax),%eax
  800ad9:	8d 50 04             	lea    0x4(%eax),%edx
  800adc:	8b 45 08             	mov    0x8(%ebp),%eax
  800adf:	89 10                	mov    %edx,(%eax)
  800ae1:	8b 45 08             	mov    0x8(%ebp),%eax
  800ae4:	8b 00                	mov    (%eax),%eax
  800ae6:	83 e8 04             	sub    $0x4,%eax
  800ae9:	8b 00                	mov    (%eax),%eax
  800aeb:	ba 00 00 00 00       	mov    $0x0,%edx
  800af0:	eb 1c                	jmp    800b0e <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  800af2:	8b 45 08             	mov    0x8(%ebp),%eax
  800af5:	8b 00                	mov    (%eax),%eax
  800af7:	8d 50 04             	lea    0x4(%eax),%edx
  800afa:	8b 45 08             	mov    0x8(%ebp),%eax
  800afd:	89 10                	mov    %edx,(%eax)
  800aff:	8b 45 08             	mov    0x8(%ebp),%eax
  800b02:	8b 00                	mov    (%eax),%eax
  800b04:	83 e8 04             	sub    $0x4,%eax
  800b07:	8b 00                	mov    (%eax),%eax
  800b09:	ba 00 00 00 00       	mov    $0x0,%edx
}
  800b0e:	5d                   	pop    %ebp
  800b0f:	c3                   	ret    

00800b10 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  800b10:	55                   	push   %ebp
  800b11:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800b13:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800b17:	7e 1c                	jle    800b35 <getint+0x25>
		return va_arg(*ap, long long);
  800b19:	8b 45 08             	mov    0x8(%ebp),%eax
  800b1c:	8b 00                	mov    (%eax),%eax
  800b1e:	8d 50 08             	lea    0x8(%eax),%edx
  800b21:	8b 45 08             	mov    0x8(%ebp),%eax
  800b24:	89 10                	mov    %edx,(%eax)
  800b26:	8b 45 08             	mov    0x8(%ebp),%eax
  800b29:	8b 00                	mov    (%eax),%eax
  800b2b:	83 e8 08             	sub    $0x8,%eax
  800b2e:	8b 50 04             	mov    0x4(%eax),%edx
  800b31:	8b 00                	mov    (%eax),%eax
  800b33:	eb 38                	jmp    800b6d <getint+0x5d>
	else if (lflag)
  800b35:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800b39:	74 1a                	je     800b55 <getint+0x45>
		return va_arg(*ap, long);
  800b3b:	8b 45 08             	mov    0x8(%ebp),%eax
  800b3e:	8b 00                	mov    (%eax),%eax
  800b40:	8d 50 04             	lea    0x4(%eax),%edx
  800b43:	8b 45 08             	mov    0x8(%ebp),%eax
  800b46:	89 10                	mov    %edx,(%eax)
  800b48:	8b 45 08             	mov    0x8(%ebp),%eax
  800b4b:	8b 00                	mov    (%eax),%eax
  800b4d:	83 e8 04             	sub    $0x4,%eax
  800b50:	8b 00                	mov    (%eax),%eax
  800b52:	99                   	cltd   
  800b53:	eb 18                	jmp    800b6d <getint+0x5d>
	else
		return va_arg(*ap, int);
  800b55:	8b 45 08             	mov    0x8(%ebp),%eax
  800b58:	8b 00                	mov    (%eax),%eax
  800b5a:	8d 50 04             	lea    0x4(%eax),%edx
  800b5d:	8b 45 08             	mov    0x8(%ebp),%eax
  800b60:	89 10                	mov    %edx,(%eax)
  800b62:	8b 45 08             	mov    0x8(%ebp),%eax
  800b65:	8b 00                	mov    (%eax),%eax
  800b67:	83 e8 04             	sub    $0x4,%eax
  800b6a:	8b 00                	mov    (%eax),%eax
  800b6c:	99                   	cltd   
}
  800b6d:	5d                   	pop    %ebp
  800b6e:	c3                   	ret    

00800b6f <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  800b6f:	55                   	push   %ebp
  800b70:	89 e5                	mov    %esp,%ebp
  800b72:	56                   	push   %esi
  800b73:	53                   	push   %ebx
  800b74:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800b77:	eb 17                	jmp    800b90 <vprintfmt+0x21>
			if (ch == '\0')
  800b79:	85 db                	test   %ebx,%ebx
  800b7b:	0f 84 af 03 00 00    	je     800f30 <vprintfmt+0x3c1>
				return;
			putch(ch, putdat);
  800b81:	83 ec 08             	sub    $0x8,%esp
  800b84:	ff 75 0c             	pushl  0xc(%ebp)
  800b87:	53                   	push   %ebx
  800b88:	8b 45 08             	mov    0x8(%ebp),%eax
  800b8b:	ff d0                	call   *%eax
  800b8d:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800b90:	8b 45 10             	mov    0x10(%ebp),%eax
  800b93:	8d 50 01             	lea    0x1(%eax),%edx
  800b96:	89 55 10             	mov    %edx,0x10(%ebp)
  800b99:	8a 00                	mov    (%eax),%al
  800b9b:	0f b6 d8             	movzbl %al,%ebx
  800b9e:	83 fb 25             	cmp    $0x25,%ebx
  800ba1:	75 d6                	jne    800b79 <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  800ba3:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  800ba7:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  800bae:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  800bb5:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  800bbc:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800bc3:	8b 45 10             	mov    0x10(%ebp),%eax
  800bc6:	8d 50 01             	lea    0x1(%eax),%edx
  800bc9:	89 55 10             	mov    %edx,0x10(%ebp)
  800bcc:	8a 00                	mov    (%eax),%al
  800bce:	0f b6 d8             	movzbl %al,%ebx
  800bd1:	8d 43 dd             	lea    -0x23(%ebx),%eax
  800bd4:	83 f8 55             	cmp    $0x55,%eax
  800bd7:	0f 87 2b 03 00 00    	ja     800f08 <vprintfmt+0x399>
  800bdd:	8b 04 85 98 3a 80 00 	mov    0x803a98(,%eax,4),%eax
  800be4:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  800be6:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  800bea:	eb d7                	jmp    800bc3 <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800bec:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  800bf0:	eb d1                	jmp    800bc3 <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800bf2:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  800bf9:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800bfc:	89 d0                	mov    %edx,%eax
  800bfe:	c1 e0 02             	shl    $0x2,%eax
  800c01:	01 d0                	add    %edx,%eax
  800c03:	01 c0                	add    %eax,%eax
  800c05:	01 d8                	add    %ebx,%eax
  800c07:	83 e8 30             	sub    $0x30,%eax
  800c0a:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  800c0d:	8b 45 10             	mov    0x10(%ebp),%eax
  800c10:	8a 00                	mov    (%eax),%al
  800c12:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  800c15:	83 fb 2f             	cmp    $0x2f,%ebx
  800c18:	7e 3e                	jle    800c58 <vprintfmt+0xe9>
  800c1a:	83 fb 39             	cmp    $0x39,%ebx
  800c1d:	7f 39                	jg     800c58 <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800c1f:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800c22:	eb d5                	jmp    800bf9 <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  800c24:	8b 45 14             	mov    0x14(%ebp),%eax
  800c27:	83 c0 04             	add    $0x4,%eax
  800c2a:	89 45 14             	mov    %eax,0x14(%ebp)
  800c2d:	8b 45 14             	mov    0x14(%ebp),%eax
  800c30:	83 e8 04             	sub    $0x4,%eax
  800c33:	8b 00                	mov    (%eax),%eax
  800c35:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  800c38:	eb 1f                	jmp    800c59 <vprintfmt+0xea>

		case '.':
			if (width < 0)
  800c3a:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800c3e:	79 83                	jns    800bc3 <vprintfmt+0x54>
				width = 0;
  800c40:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  800c47:	e9 77 ff ff ff       	jmp    800bc3 <vprintfmt+0x54>

		case '#':
			altflag = 1;
  800c4c:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  800c53:	e9 6b ff ff ff       	jmp    800bc3 <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  800c58:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  800c59:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800c5d:	0f 89 60 ff ff ff    	jns    800bc3 <vprintfmt+0x54>
				width = precision, precision = -1;
  800c63:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800c66:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800c69:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  800c70:	e9 4e ff ff ff       	jmp    800bc3 <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  800c75:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  800c78:	e9 46 ff ff ff       	jmp    800bc3 <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  800c7d:	8b 45 14             	mov    0x14(%ebp),%eax
  800c80:	83 c0 04             	add    $0x4,%eax
  800c83:	89 45 14             	mov    %eax,0x14(%ebp)
  800c86:	8b 45 14             	mov    0x14(%ebp),%eax
  800c89:	83 e8 04             	sub    $0x4,%eax
  800c8c:	8b 00                	mov    (%eax),%eax
  800c8e:	83 ec 08             	sub    $0x8,%esp
  800c91:	ff 75 0c             	pushl  0xc(%ebp)
  800c94:	50                   	push   %eax
  800c95:	8b 45 08             	mov    0x8(%ebp),%eax
  800c98:	ff d0                	call   *%eax
  800c9a:	83 c4 10             	add    $0x10,%esp
			break;
  800c9d:	e9 89 02 00 00       	jmp    800f2b <vprintfmt+0x3bc>

		// error message
		case 'e':
			err = va_arg(ap, int);
  800ca2:	8b 45 14             	mov    0x14(%ebp),%eax
  800ca5:	83 c0 04             	add    $0x4,%eax
  800ca8:	89 45 14             	mov    %eax,0x14(%ebp)
  800cab:	8b 45 14             	mov    0x14(%ebp),%eax
  800cae:	83 e8 04             	sub    $0x4,%eax
  800cb1:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  800cb3:	85 db                	test   %ebx,%ebx
  800cb5:	79 02                	jns    800cb9 <vprintfmt+0x14a>
				err = -err;
  800cb7:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  800cb9:	83 fb 64             	cmp    $0x64,%ebx
  800cbc:	7f 0b                	jg     800cc9 <vprintfmt+0x15a>
  800cbe:	8b 34 9d e0 38 80 00 	mov    0x8038e0(,%ebx,4),%esi
  800cc5:	85 f6                	test   %esi,%esi
  800cc7:	75 19                	jne    800ce2 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  800cc9:	53                   	push   %ebx
  800cca:	68 85 3a 80 00       	push   $0x803a85
  800ccf:	ff 75 0c             	pushl  0xc(%ebp)
  800cd2:	ff 75 08             	pushl  0x8(%ebp)
  800cd5:	e8 5e 02 00 00       	call   800f38 <printfmt>
  800cda:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800cdd:	e9 49 02 00 00       	jmp    800f2b <vprintfmt+0x3bc>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800ce2:	56                   	push   %esi
  800ce3:	68 8e 3a 80 00       	push   $0x803a8e
  800ce8:	ff 75 0c             	pushl  0xc(%ebp)
  800ceb:	ff 75 08             	pushl  0x8(%ebp)
  800cee:	e8 45 02 00 00       	call   800f38 <printfmt>
  800cf3:	83 c4 10             	add    $0x10,%esp
			break;
  800cf6:	e9 30 02 00 00       	jmp    800f2b <vprintfmt+0x3bc>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  800cfb:	8b 45 14             	mov    0x14(%ebp),%eax
  800cfe:	83 c0 04             	add    $0x4,%eax
  800d01:	89 45 14             	mov    %eax,0x14(%ebp)
  800d04:	8b 45 14             	mov    0x14(%ebp),%eax
  800d07:	83 e8 04             	sub    $0x4,%eax
  800d0a:	8b 30                	mov    (%eax),%esi
  800d0c:	85 f6                	test   %esi,%esi
  800d0e:	75 05                	jne    800d15 <vprintfmt+0x1a6>
				p = "(null)";
  800d10:	be 91 3a 80 00       	mov    $0x803a91,%esi
			if (width > 0 && padc != '-')
  800d15:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800d19:	7e 6d                	jle    800d88 <vprintfmt+0x219>
  800d1b:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  800d1f:	74 67                	je     800d88 <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  800d21:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800d24:	83 ec 08             	sub    $0x8,%esp
  800d27:	50                   	push   %eax
  800d28:	56                   	push   %esi
  800d29:	e8 0c 03 00 00       	call   80103a <strnlen>
  800d2e:	83 c4 10             	add    $0x10,%esp
  800d31:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  800d34:	eb 16                	jmp    800d4c <vprintfmt+0x1dd>
					putch(padc, putdat);
  800d36:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  800d3a:	83 ec 08             	sub    $0x8,%esp
  800d3d:	ff 75 0c             	pushl  0xc(%ebp)
  800d40:	50                   	push   %eax
  800d41:	8b 45 08             	mov    0x8(%ebp),%eax
  800d44:	ff d0                	call   *%eax
  800d46:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800d49:	ff 4d e4             	decl   -0x1c(%ebp)
  800d4c:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800d50:	7f e4                	jg     800d36 <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800d52:	eb 34                	jmp    800d88 <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  800d54:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800d58:	74 1c                	je     800d76 <vprintfmt+0x207>
  800d5a:	83 fb 1f             	cmp    $0x1f,%ebx
  800d5d:	7e 05                	jle    800d64 <vprintfmt+0x1f5>
  800d5f:	83 fb 7e             	cmp    $0x7e,%ebx
  800d62:	7e 12                	jle    800d76 <vprintfmt+0x207>
					putch('?', putdat);
  800d64:	83 ec 08             	sub    $0x8,%esp
  800d67:	ff 75 0c             	pushl  0xc(%ebp)
  800d6a:	6a 3f                	push   $0x3f
  800d6c:	8b 45 08             	mov    0x8(%ebp),%eax
  800d6f:	ff d0                	call   *%eax
  800d71:	83 c4 10             	add    $0x10,%esp
  800d74:	eb 0f                	jmp    800d85 <vprintfmt+0x216>
				else
					putch(ch, putdat);
  800d76:	83 ec 08             	sub    $0x8,%esp
  800d79:	ff 75 0c             	pushl  0xc(%ebp)
  800d7c:	53                   	push   %ebx
  800d7d:	8b 45 08             	mov    0x8(%ebp),%eax
  800d80:	ff d0                	call   *%eax
  800d82:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800d85:	ff 4d e4             	decl   -0x1c(%ebp)
  800d88:	89 f0                	mov    %esi,%eax
  800d8a:	8d 70 01             	lea    0x1(%eax),%esi
  800d8d:	8a 00                	mov    (%eax),%al
  800d8f:	0f be d8             	movsbl %al,%ebx
  800d92:	85 db                	test   %ebx,%ebx
  800d94:	74 24                	je     800dba <vprintfmt+0x24b>
  800d96:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800d9a:	78 b8                	js     800d54 <vprintfmt+0x1e5>
  800d9c:	ff 4d e0             	decl   -0x20(%ebp)
  800d9f:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800da3:	79 af                	jns    800d54 <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800da5:	eb 13                	jmp    800dba <vprintfmt+0x24b>
				putch(' ', putdat);
  800da7:	83 ec 08             	sub    $0x8,%esp
  800daa:	ff 75 0c             	pushl  0xc(%ebp)
  800dad:	6a 20                	push   $0x20
  800daf:	8b 45 08             	mov    0x8(%ebp),%eax
  800db2:	ff d0                	call   *%eax
  800db4:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800db7:	ff 4d e4             	decl   -0x1c(%ebp)
  800dba:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800dbe:	7f e7                	jg     800da7 <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  800dc0:	e9 66 01 00 00       	jmp    800f2b <vprintfmt+0x3bc>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  800dc5:	83 ec 08             	sub    $0x8,%esp
  800dc8:	ff 75 e8             	pushl  -0x18(%ebp)
  800dcb:	8d 45 14             	lea    0x14(%ebp),%eax
  800dce:	50                   	push   %eax
  800dcf:	e8 3c fd ff ff       	call   800b10 <getint>
  800dd4:	83 c4 10             	add    $0x10,%esp
  800dd7:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800dda:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  800ddd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800de0:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800de3:	85 d2                	test   %edx,%edx
  800de5:	79 23                	jns    800e0a <vprintfmt+0x29b>
				putch('-', putdat);
  800de7:	83 ec 08             	sub    $0x8,%esp
  800dea:	ff 75 0c             	pushl  0xc(%ebp)
  800ded:	6a 2d                	push   $0x2d
  800def:	8b 45 08             	mov    0x8(%ebp),%eax
  800df2:	ff d0                	call   *%eax
  800df4:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  800df7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800dfa:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800dfd:	f7 d8                	neg    %eax
  800dff:	83 d2 00             	adc    $0x0,%edx
  800e02:	f7 da                	neg    %edx
  800e04:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800e07:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  800e0a:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800e11:	e9 bc 00 00 00       	jmp    800ed2 <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  800e16:	83 ec 08             	sub    $0x8,%esp
  800e19:	ff 75 e8             	pushl  -0x18(%ebp)
  800e1c:	8d 45 14             	lea    0x14(%ebp),%eax
  800e1f:	50                   	push   %eax
  800e20:	e8 84 fc ff ff       	call   800aa9 <getuint>
  800e25:	83 c4 10             	add    $0x10,%esp
  800e28:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800e2b:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  800e2e:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800e35:	e9 98 00 00 00       	jmp    800ed2 <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  800e3a:	83 ec 08             	sub    $0x8,%esp
  800e3d:	ff 75 0c             	pushl  0xc(%ebp)
  800e40:	6a 58                	push   $0x58
  800e42:	8b 45 08             	mov    0x8(%ebp),%eax
  800e45:	ff d0                	call   *%eax
  800e47:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800e4a:	83 ec 08             	sub    $0x8,%esp
  800e4d:	ff 75 0c             	pushl  0xc(%ebp)
  800e50:	6a 58                	push   $0x58
  800e52:	8b 45 08             	mov    0x8(%ebp),%eax
  800e55:	ff d0                	call   *%eax
  800e57:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800e5a:	83 ec 08             	sub    $0x8,%esp
  800e5d:	ff 75 0c             	pushl  0xc(%ebp)
  800e60:	6a 58                	push   $0x58
  800e62:	8b 45 08             	mov    0x8(%ebp),%eax
  800e65:	ff d0                	call   *%eax
  800e67:	83 c4 10             	add    $0x10,%esp
			break;
  800e6a:	e9 bc 00 00 00       	jmp    800f2b <vprintfmt+0x3bc>

		// pointer
		case 'p':
			putch('0', putdat);
  800e6f:	83 ec 08             	sub    $0x8,%esp
  800e72:	ff 75 0c             	pushl  0xc(%ebp)
  800e75:	6a 30                	push   $0x30
  800e77:	8b 45 08             	mov    0x8(%ebp),%eax
  800e7a:	ff d0                	call   *%eax
  800e7c:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  800e7f:	83 ec 08             	sub    $0x8,%esp
  800e82:	ff 75 0c             	pushl  0xc(%ebp)
  800e85:	6a 78                	push   $0x78
  800e87:	8b 45 08             	mov    0x8(%ebp),%eax
  800e8a:	ff d0                	call   *%eax
  800e8c:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  800e8f:	8b 45 14             	mov    0x14(%ebp),%eax
  800e92:	83 c0 04             	add    $0x4,%eax
  800e95:	89 45 14             	mov    %eax,0x14(%ebp)
  800e98:	8b 45 14             	mov    0x14(%ebp),%eax
  800e9b:	83 e8 04             	sub    $0x4,%eax
  800e9e:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800ea0:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800ea3:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  800eaa:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  800eb1:	eb 1f                	jmp    800ed2 <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800eb3:	83 ec 08             	sub    $0x8,%esp
  800eb6:	ff 75 e8             	pushl  -0x18(%ebp)
  800eb9:	8d 45 14             	lea    0x14(%ebp),%eax
  800ebc:	50                   	push   %eax
  800ebd:	e8 e7 fb ff ff       	call   800aa9 <getuint>
  800ec2:	83 c4 10             	add    $0x10,%esp
  800ec5:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800ec8:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  800ecb:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800ed2:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  800ed6:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800ed9:	83 ec 04             	sub    $0x4,%esp
  800edc:	52                   	push   %edx
  800edd:	ff 75 e4             	pushl  -0x1c(%ebp)
  800ee0:	50                   	push   %eax
  800ee1:	ff 75 f4             	pushl  -0xc(%ebp)
  800ee4:	ff 75 f0             	pushl  -0x10(%ebp)
  800ee7:	ff 75 0c             	pushl  0xc(%ebp)
  800eea:	ff 75 08             	pushl  0x8(%ebp)
  800eed:	e8 00 fb ff ff       	call   8009f2 <printnum>
  800ef2:	83 c4 20             	add    $0x20,%esp
			break;
  800ef5:	eb 34                	jmp    800f2b <vprintfmt+0x3bc>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  800ef7:	83 ec 08             	sub    $0x8,%esp
  800efa:	ff 75 0c             	pushl  0xc(%ebp)
  800efd:	53                   	push   %ebx
  800efe:	8b 45 08             	mov    0x8(%ebp),%eax
  800f01:	ff d0                	call   *%eax
  800f03:	83 c4 10             	add    $0x10,%esp
			break;
  800f06:	eb 23                	jmp    800f2b <vprintfmt+0x3bc>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800f08:	83 ec 08             	sub    $0x8,%esp
  800f0b:	ff 75 0c             	pushl  0xc(%ebp)
  800f0e:	6a 25                	push   $0x25
  800f10:	8b 45 08             	mov    0x8(%ebp),%eax
  800f13:	ff d0                	call   *%eax
  800f15:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  800f18:	ff 4d 10             	decl   0x10(%ebp)
  800f1b:	eb 03                	jmp    800f20 <vprintfmt+0x3b1>
  800f1d:	ff 4d 10             	decl   0x10(%ebp)
  800f20:	8b 45 10             	mov    0x10(%ebp),%eax
  800f23:	48                   	dec    %eax
  800f24:	8a 00                	mov    (%eax),%al
  800f26:	3c 25                	cmp    $0x25,%al
  800f28:	75 f3                	jne    800f1d <vprintfmt+0x3ae>
				/* do nothing */;
			break;
  800f2a:	90                   	nop
		}
	}
  800f2b:	e9 47 fc ff ff       	jmp    800b77 <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  800f30:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  800f31:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800f34:	5b                   	pop    %ebx
  800f35:	5e                   	pop    %esi
  800f36:	5d                   	pop    %ebp
  800f37:	c3                   	ret    

00800f38 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800f38:	55                   	push   %ebp
  800f39:	89 e5                	mov    %esp,%ebp
  800f3b:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  800f3e:	8d 45 10             	lea    0x10(%ebp),%eax
  800f41:	83 c0 04             	add    $0x4,%eax
  800f44:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  800f47:	8b 45 10             	mov    0x10(%ebp),%eax
  800f4a:	ff 75 f4             	pushl  -0xc(%ebp)
  800f4d:	50                   	push   %eax
  800f4e:	ff 75 0c             	pushl  0xc(%ebp)
  800f51:	ff 75 08             	pushl  0x8(%ebp)
  800f54:	e8 16 fc ff ff       	call   800b6f <vprintfmt>
  800f59:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  800f5c:	90                   	nop
  800f5d:	c9                   	leave  
  800f5e:	c3                   	ret    

00800f5f <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800f5f:	55                   	push   %ebp
  800f60:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  800f62:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f65:	8b 40 08             	mov    0x8(%eax),%eax
  800f68:	8d 50 01             	lea    0x1(%eax),%edx
  800f6b:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f6e:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  800f71:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f74:	8b 10                	mov    (%eax),%edx
  800f76:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f79:	8b 40 04             	mov    0x4(%eax),%eax
  800f7c:	39 c2                	cmp    %eax,%edx
  800f7e:	73 12                	jae    800f92 <sprintputch+0x33>
		*b->buf++ = ch;
  800f80:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f83:	8b 00                	mov    (%eax),%eax
  800f85:	8d 48 01             	lea    0x1(%eax),%ecx
  800f88:	8b 55 0c             	mov    0xc(%ebp),%edx
  800f8b:	89 0a                	mov    %ecx,(%edx)
  800f8d:	8b 55 08             	mov    0x8(%ebp),%edx
  800f90:	88 10                	mov    %dl,(%eax)
}
  800f92:	90                   	nop
  800f93:	5d                   	pop    %ebp
  800f94:	c3                   	ret    

00800f95 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800f95:	55                   	push   %ebp
  800f96:	89 e5                	mov    %esp,%ebp
  800f98:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  800f9b:	8b 45 08             	mov    0x8(%ebp),%eax
  800f9e:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800fa1:	8b 45 0c             	mov    0xc(%ebp),%eax
  800fa4:	8d 50 ff             	lea    -0x1(%eax),%edx
  800fa7:	8b 45 08             	mov    0x8(%ebp),%eax
  800faa:	01 d0                	add    %edx,%eax
  800fac:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800faf:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800fb6:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800fba:	74 06                	je     800fc2 <vsnprintf+0x2d>
  800fbc:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800fc0:	7f 07                	jg     800fc9 <vsnprintf+0x34>
		return -E_INVAL;
  800fc2:	b8 03 00 00 00       	mov    $0x3,%eax
  800fc7:	eb 20                	jmp    800fe9 <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800fc9:	ff 75 14             	pushl  0x14(%ebp)
  800fcc:	ff 75 10             	pushl  0x10(%ebp)
  800fcf:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800fd2:	50                   	push   %eax
  800fd3:	68 5f 0f 80 00       	push   $0x800f5f
  800fd8:	e8 92 fb ff ff       	call   800b6f <vprintfmt>
  800fdd:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  800fe0:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800fe3:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800fe6:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  800fe9:	c9                   	leave  
  800fea:	c3                   	ret    

00800feb <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800feb:	55                   	push   %ebp
  800fec:	89 e5                	mov    %esp,%ebp
  800fee:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800ff1:	8d 45 10             	lea    0x10(%ebp),%eax
  800ff4:	83 c0 04             	add    $0x4,%eax
  800ff7:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  800ffa:	8b 45 10             	mov    0x10(%ebp),%eax
  800ffd:	ff 75 f4             	pushl  -0xc(%ebp)
  801000:	50                   	push   %eax
  801001:	ff 75 0c             	pushl  0xc(%ebp)
  801004:	ff 75 08             	pushl  0x8(%ebp)
  801007:	e8 89 ff ff ff       	call   800f95 <vsnprintf>
  80100c:	83 c4 10             	add    $0x10,%esp
  80100f:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  801012:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801015:	c9                   	leave  
  801016:	c3                   	ret    

00801017 <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  801017:	55                   	push   %ebp
  801018:	89 e5                	mov    %esp,%ebp
  80101a:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  80101d:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801024:	eb 06                	jmp    80102c <strlen+0x15>
		n++;
  801026:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  801029:	ff 45 08             	incl   0x8(%ebp)
  80102c:	8b 45 08             	mov    0x8(%ebp),%eax
  80102f:	8a 00                	mov    (%eax),%al
  801031:	84 c0                	test   %al,%al
  801033:	75 f1                	jne    801026 <strlen+0xf>
		n++;
	return n;
  801035:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  801038:	c9                   	leave  
  801039:	c3                   	ret    

0080103a <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  80103a:	55                   	push   %ebp
  80103b:	89 e5                	mov    %esp,%ebp
  80103d:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  801040:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801047:	eb 09                	jmp    801052 <strnlen+0x18>
		n++;
  801049:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  80104c:	ff 45 08             	incl   0x8(%ebp)
  80104f:	ff 4d 0c             	decl   0xc(%ebp)
  801052:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801056:	74 09                	je     801061 <strnlen+0x27>
  801058:	8b 45 08             	mov    0x8(%ebp),%eax
  80105b:	8a 00                	mov    (%eax),%al
  80105d:	84 c0                	test   %al,%al
  80105f:	75 e8                	jne    801049 <strnlen+0xf>
		n++;
	return n;
  801061:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  801064:	c9                   	leave  
  801065:	c3                   	ret    

00801066 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  801066:	55                   	push   %ebp
  801067:	89 e5                	mov    %esp,%ebp
  801069:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  80106c:	8b 45 08             	mov    0x8(%ebp),%eax
  80106f:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  801072:	90                   	nop
  801073:	8b 45 08             	mov    0x8(%ebp),%eax
  801076:	8d 50 01             	lea    0x1(%eax),%edx
  801079:	89 55 08             	mov    %edx,0x8(%ebp)
  80107c:	8b 55 0c             	mov    0xc(%ebp),%edx
  80107f:	8d 4a 01             	lea    0x1(%edx),%ecx
  801082:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  801085:	8a 12                	mov    (%edx),%dl
  801087:	88 10                	mov    %dl,(%eax)
  801089:	8a 00                	mov    (%eax),%al
  80108b:	84 c0                	test   %al,%al
  80108d:	75 e4                	jne    801073 <strcpy+0xd>
		/* do nothing */;
	return ret;
  80108f:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  801092:	c9                   	leave  
  801093:	c3                   	ret    

00801094 <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  801094:	55                   	push   %ebp
  801095:	89 e5                	mov    %esp,%ebp
  801097:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  80109a:	8b 45 08             	mov    0x8(%ebp),%eax
  80109d:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  8010a0:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8010a7:	eb 1f                	jmp    8010c8 <strncpy+0x34>
		*dst++ = *src;
  8010a9:	8b 45 08             	mov    0x8(%ebp),%eax
  8010ac:	8d 50 01             	lea    0x1(%eax),%edx
  8010af:	89 55 08             	mov    %edx,0x8(%ebp)
  8010b2:	8b 55 0c             	mov    0xc(%ebp),%edx
  8010b5:	8a 12                	mov    (%edx),%dl
  8010b7:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  8010b9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010bc:	8a 00                	mov    (%eax),%al
  8010be:	84 c0                	test   %al,%al
  8010c0:	74 03                	je     8010c5 <strncpy+0x31>
			src++;
  8010c2:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  8010c5:	ff 45 fc             	incl   -0x4(%ebp)
  8010c8:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8010cb:	3b 45 10             	cmp    0x10(%ebp),%eax
  8010ce:	72 d9                	jb     8010a9 <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  8010d0:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  8010d3:	c9                   	leave  
  8010d4:	c3                   	ret    

008010d5 <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  8010d5:	55                   	push   %ebp
  8010d6:	89 e5                	mov    %esp,%ebp
  8010d8:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  8010db:	8b 45 08             	mov    0x8(%ebp),%eax
  8010de:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  8010e1:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8010e5:	74 30                	je     801117 <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  8010e7:	eb 16                	jmp    8010ff <strlcpy+0x2a>
			*dst++ = *src++;
  8010e9:	8b 45 08             	mov    0x8(%ebp),%eax
  8010ec:	8d 50 01             	lea    0x1(%eax),%edx
  8010ef:	89 55 08             	mov    %edx,0x8(%ebp)
  8010f2:	8b 55 0c             	mov    0xc(%ebp),%edx
  8010f5:	8d 4a 01             	lea    0x1(%edx),%ecx
  8010f8:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  8010fb:	8a 12                	mov    (%edx),%dl
  8010fd:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  8010ff:	ff 4d 10             	decl   0x10(%ebp)
  801102:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801106:	74 09                	je     801111 <strlcpy+0x3c>
  801108:	8b 45 0c             	mov    0xc(%ebp),%eax
  80110b:	8a 00                	mov    (%eax),%al
  80110d:	84 c0                	test   %al,%al
  80110f:	75 d8                	jne    8010e9 <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  801111:	8b 45 08             	mov    0x8(%ebp),%eax
  801114:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  801117:	8b 55 08             	mov    0x8(%ebp),%edx
  80111a:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80111d:	29 c2                	sub    %eax,%edx
  80111f:	89 d0                	mov    %edx,%eax
}
  801121:	c9                   	leave  
  801122:	c3                   	ret    

00801123 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  801123:	55                   	push   %ebp
  801124:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  801126:	eb 06                	jmp    80112e <strcmp+0xb>
		p++, q++;
  801128:	ff 45 08             	incl   0x8(%ebp)
  80112b:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  80112e:	8b 45 08             	mov    0x8(%ebp),%eax
  801131:	8a 00                	mov    (%eax),%al
  801133:	84 c0                	test   %al,%al
  801135:	74 0e                	je     801145 <strcmp+0x22>
  801137:	8b 45 08             	mov    0x8(%ebp),%eax
  80113a:	8a 10                	mov    (%eax),%dl
  80113c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80113f:	8a 00                	mov    (%eax),%al
  801141:	38 c2                	cmp    %al,%dl
  801143:	74 e3                	je     801128 <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  801145:	8b 45 08             	mov    0x8(%ebp),%eax
  801148:	8a 00                	mov    (%eax),%al
  80114a:	0f b6 d0             	movzbl %al,%edx
  80114d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801150:	8a 00                	mov    (%eax),%al
  801152:	0f b6 c0             	movzbl %al,%eax
  801155:	29 c2                	sub    %eax,%edx
  801157:	89 d0                	mov    %edx,%eax
}
  801159:	5d                   	pop    %ebp
  80115a:	c3                   	ret    

0080115b <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  80115b:	55                   	push   %ebp
  80115c:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  80115e:	eb 09                	jmp    801169 <strncmp+0xe>
		n--, p++, q++;
  801160:	ff 4d 10             	decl   0x10(%ebp)
  801163:	ff 45 08             	incl   0x8(%ebp)
  801166:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  801169:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80116d:	74 17                	je     801186 <strncmp+0x2b>
  80116f:	8b 45 08             	mov    0x8(%ebp),%eax
  801172:	8a 00                	mov    (%eax),%al
  801174:	84 c0                	test   %al,%al
  801176:	74 0e                	je     801186 <strncmp+0x2b>
  801178:	8b 45 08             	mov    0x8(%ebp),%eax
  80117b:	8a 10                	mov    (%eax),%dl
  80117d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801180:	8a 00                	mov    (%eax),%al
  801182:	38 c2                	cmp    %al,%dl
  801184:	74 da                	je     801160 <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  801186:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80118a:	75 07                	jne    801193 <strncmp+0x38>
		return 0;
  80118c:	b8 00 00 00 00       	mov    $0x0,%eax
  801191:	eb 14                	jmp    8011a7 <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  801193:	8b 45 08             	mov    0x8(%ebp),%eax
  801196:	8a 00                	mov    (%eax),%al
  801198:	0f b6 d0             	movzbl %al,%edx
  80119b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80119e:	8a 00                	mov    (%eax),%al
  8011a0:	0f b6 c0             	movzbl %al,%eax
  8011a3:	29 c2                	sub    %eax,%edx
  8011a5:	89 d0                	mov    %edx,%eax
}
  8011a7:	5d                   	pop    %ebp
  8011a8:	c3                   	ret    

008011a9 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  8011a9:	55                   	push   %ebp
  8011aa:	89 e5                	mov    %esp,%ebp
  8011ac:	83 ec 04             	sub    $0x4,%esp
  8011af:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011b2:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  8011b5:	eb 12                	jmp    8011c9 <strchr+0x20>
		if (*s == c)
  8011b7:	8b 45 08             	mov    0x8(%ebp),%eax
  8011ba:	8a 00                	mov    (%eax),%al
  8011bc:	3a 45 fc             	cmp    -0x4(%ebp),%al
  8011bf:	75 05                	jne    8011c6 <strchr+0x1d>
			return (char *) s;
  8011c1:	8b 45 08             	mov    0x8(%ebp),%eax
  8011c4:	eb 11                	jmp    8011d7 <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  8011c6:	ff 45 08             	incl   0x8(%ebp)
  8011c9:	8b 45 08             	mov    0x8(%ebp),%eax
  8011cc:	8a 00                	mov    (%eax),%al
  8011ce:	84 c0                	test   %al,%al
  8011d0:	75 e5                	jne    8011b7 <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  8011d2:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8011d7:	c9                   	leave  
  8011d8:	c3                   	ret    

008011d9 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  8011d9:	55                   	push   %ebp
  8011da:	89 e5                	mov    %esp,%ebp
  8011dc:	83 ec 04             	sub    $0x4,%esp
  8011df:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011e2:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  8011e5:	eb 0d                	jmp    8011f4 <strfind+0x1b>
		if (*s == c)
  8011e7:	8b 45 08             	mov    0x8(%ebp),%eax
  8011ea:	8a 00                	mov    (%eax),%al
  8011ec:	3a 45 fc             	cmp    -0x4(%ebp),%al
  8011ef:	74 0e                	je     8011ff <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  8011f1:	ff 45 08             	incl   0x8(%ebp)
  8011f4:	8b 45 08             	mov    0x8(%ebp),%eax
  8011f7:	8a 00                	mov    (%eax),%al
  8011f9:	84 c0                	test   %al,%al
  8011fb:	75 ea                	jne    8011e7 <strfind+0xe>
  8011fd:	eb 01                	jmp    801200 <strfind+0x27>
		if (*s == c)
			break;
  8011ff:	90                   	nop
	return (char *) s;
  801200:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801203:	c9                   	leave  
  801204:	c3                   	ret    

00801205 <memset>:


void *
memset(void *v, int c, uint32 n)
{
  801205:	55                   	push   %ebp
  801206:	89 e5                	mov    %esp,%ebp
  801208:	83 ec 10             	sub    $0x10,%esp
	char *p;
	int m;

	p = v;
  80120b:	8b 45 08             	mov    0x8(%ebp),%eax
  80120e:	89 45 fc             	mov    %eax,-0x4(%ebp)
	m = n;
  801211:	8b 45 10             	mov    0x10(%ebp),%eax
  801214:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (--m >= 0)
  801217:	eb 0e                	jmp    801227 <memset+0x22>
		*p++ = c;
  801219:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80121c:	8d 50 01             	lea    0x1(%eax),%edx
  80121f:	89 55 fc             	mov    %edx,-0x4(%ebp)
  801222:	8b 55 0c             	mov    0xc(%ebp),%edx
  801225:	88 10                	mov    %dl,(%eax)
	char *p;
	int m;

	p = v;
	m = n;
	while (--m >= 0)
  801227:	ff 4d f8             	decl   -0x8(%ebp)
  80122a:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  80122e:	79 e9                	jns    801219 <memset+0x14>
		*p++ = c;

	return v;
  801230:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801233:	c9                   	leave  
  801234:	c3                   	ret    

00801235 <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  801235:	55                   	push   %ebp
  801236:	89 e5                	mov    %esp,%ebp
  801238:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  80123b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80123e:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  801241:	8b 45 08             	mov    0x8(%ebp),%eax
  801244:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (n-- > 0)
  801247:	eb 16                	jmp    80125f <memcpy+0x2a>
		*d++ = *s++;
  801249:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80124c:	8d 50 01             	lea    0x1(%eax),%edx
  80124f:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801252:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801255:	8d 4a 01             	lea    0x1(%edx),%ecx
  801258:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  80125b:	8a 12                	mov    (%edx),%dl
  80125d:	88 10                	mov    %dl,(%eax)
	const char *s;
	char *d;

	s = src;
	d = dst;
	while (n-- > 0)
  80125f:	8b 45 10             	mov    0x10(%ebp),%eax
  801262:	8d 50 ff             	lea    -0x1(%eax),%edx
  801265:	89 55 10             	mov    %edx,0x10(%ebp)
  801268:	85 c0                	test   %eax,%eax
  80126a:	75 dd                	jne    801249 <memcpy+0x14>
		*d++ = *s++;

	return dst;
  80126c:	8b 45 08             	mov    0x8(%ebp),%eax
}
  80126f:	c9                   	leave  
  801270:	c3                   	ret    

00801271 <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  801271:	55                   	push   %ebp
  801272:	89 e5                	mov    %esp,%ebp
  801274:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  801277:	8b 45 0c             	mov    0xc(%ebp),%eax
  80127a:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  80127d:	8b 45 08             	mov    0x8(%ebp),%eax
  801280:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  801283:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801286:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  801289:	73 50                	jae    8012db <memmove+0x6a>
  80128b:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80128e:	8b 45 10             	mov    0x10(%ebp),%eax
  801291:	01 d0                	add    %edx,%eax
  801293:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  801296:	76 43                	jbe    8012db <memmove+0x6a>
		s += n;
  801298:	8b 45 10             	mov    0x10(%ebp),%eax
  80129b:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  80129e:	8b 45 10             	mov    0x10(%ebp),%eax
  8012a1:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  8012a4:	eb 10                	jmp    8012b6 <memmove+0x45>
			*--d = *--s;
  8012a6:	ff 4d f8             	decl   -0x8(%ebp)
  8012a9:	ff 4d fc             	decl   -0x4(%ebp)
  8012ac:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8012af:	8a 10                	mov    (%eax),%dl
  8012b1:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8012b4:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  8012b6:	8b 45 10             	mov    0x10(%ebp),%eax
  8012b9:	8d 50 ff             	lea    -0x1(%eax),%edx
  8012bc:	89 55 10             	mov    %edx,0x10(%ebp)
  8012bf:	85 c0                	test   %eax,%eax
  8012c1:	75 e3                	jne    8012a6 <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  8012c3:	eb 23                	jmp    8012e8 <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  8012c5:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8012c8:	8d 50 01             	lea    0x1(%eax),%edx
  8012cb:	89 55 f8             	mov    %edx,-0x8(%ebp)
  8012ce:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8012d1:	8d 4a 01             	lea    0x1(%edx),%ecx
  8012d4:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  8012d7:	8a 12                	mov    (%edx),%dl
  8012d9:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  8012db:	8b 45 10             	mov    0x10(%ebp),%eax
  8012de:	8d 50 ff             	lea    -0x1(%eax),%edx
  8012e1:	89 55 10             	mov    %edx,0x10(%ebp)
  8012e4:	85 c0                	test   %eax,%eax
  8012e6:	75 dd                	jne    8012c5 <memmove+0x54>
			*d++ = *s++;

	return dst;
  8012e8:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8012eb:	c9                   	leave  
  8012ec:	c3                   	ret    

008012ed <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  8012ed:	55                   	push   %ebp
  8012ee:	89 e5                	mov    %esp,%ebp
  8012f0:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  8012f3:	8b 45 08             	mov    0x8(%ebp),%eax
  8012f6:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  8012f9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012fc:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  8012ff:	eb 2a                	jmp    80132b <memcmp+0x3e>
		if (*s1 != *s2)
  801301:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801304:	8a 10                	mov    (%eax),%dl
  801306:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801309:	8a 00                	mov    (%eax),%al
  80130b:	38 c2                	cmp    %al,%dl
  80130d:	74 16                	je     801325 <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  80130f:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801312:	8a 00                	mov    (%eax),%al
  801314:	0f b6 d0             	movzbl %al,%edx
  801317:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80131a:	8a 00                	mov    (%eax),%al
  80131c:	0f b6 c0             	movzbl %al,%eax
  80131f:	29 c2                	sub    %eax,%edx
  801321:	89 d0                	mov    %edx,%eax
  801323:	eb 18                	jmp    80133d <memcmp+0x50>
		s1++, s2++;
  801325:	ff 45 fc             	incl   -0x4(%ebp)
  801328:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  80132b:	8b 45 10             	mov    0x10(%ebp),%eax
  80132e:	8d 50 ff             	lea    -0x1(%eax),%edx
  801331:	89 55 10             	mov    %edx,0x10(%ebp)
  801334:	85 c0                	test   %eax,%eax
  801336:	75 c9                	jne    801301 <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  801338:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80133d:	c9                   	leave  
  80133e:	c3                   	ret    

0080133f <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  80133f:	55                   	push   %ebp
  801340:	89 e5                	mov    %esp,%ebp
  801342:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  801345:	8b 55 08             	mov    0x8(%ebp),%edx
  801348:	8b 45 10             	mov    0x10(%ebp),%eax
  80134b:	01 d0                	add    %edx,%eax
  80134d:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  801350:	eb 15                	jmp    801367 <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  801352:	8b 45 08             	mov    0x8(%ebp),%eax
  801355:	8a 00                	mov    (%eax),%al
  801357:	0f b6 d0             	movzbl %al,%edx
  80135a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80135d:	0f b6 c0             	movzbl %al,%eax
  801360:	39 c2                	cmp    %eax,%edx
  801362:	74 0d                	je     801371 <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  801364:	ff 45 08             	incl   0x8(%ebp)
  801367:	8b 45 08             	mov    0x8(%ebp),%eax
  80136a:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  80136d:	72 e3                	jb     801352 <memfind+0x13>
  80136f:	eb 01                	jmp    801372 <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  801371:	90                   	nop
	return (void *) s;
  801372:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801375:	c9                   	leave  
  801376:	c3                   	ret    

00801377 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  801377:	55                   	push   %ebp
  801378:	89 e5                	mov    %esp,%ebp
  80137a:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  80137d:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  801384:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  80138b:	eb 03                	jmp    801390 <strtol+0x19>
		s++;
  80138d:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801390:	8b 45 08             	mov    0x8(%ebp),%eax
  801393:	8a 00                	mov    (%eax),%al
  801395:	3c 20                	cmp    $0x20,%al
  801397:	74 f4                	je     80138d <strtol+0x16>
  801399:	8b 45 08             	mov    0x8(%ebp),%eax
  80139c:	8a 00                	mov    (%eax),%al
  80139e:	3c 09                	cmp    $0x9,%al
  8013a0:	74 eb                	je     80138d <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  8013a2:	8b 45 08             	mov    0x8(%ebp),%eax
  8013a5:	8a 00                	mov    (%eax),%al
  8013a7:	3c 2b                	cmp    $0x2b,%al
  8013a9:	75 05                	jne    8013b0 <strtol+0x39>
		s++;
  8013ab:	ff 45 08             	incl   0x8(%ebp)
  8013ae:	eb 13                	jmp    8013c3 <strtol+0x4c>
	else if (*s == '-')
  8013b0:	8b 45 08             	mov    0x8(%ebp),%eax
  8013b3:	8a 00                	mov    (%eax),%al
  8013b5:	3c 2d                	cmp    $0x2d,%al
  8013b7:	75 0a                	jne    8013c3 <strtol+0x4c>
		s++, neg = 1;
  8013b9:	ff 45 08             	incl   0x8(%ebp)
  8013bc:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  8013c3:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8013c7:	74 06                	je     8013cf <strtol+0x58>
  8013c9:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  8013cd:	75 20                	jne    8013ef <strtol+0x78>
  8013cf:	8b 45 08             	mov    0x8(%ebp),%eax
  8013d2:	8a 00                	mov    (%eax),%al
  8013d4:	3c 30                	cmp    $0x30,%al
  8013d6:	75 17                	jne    8013ef <strtol+0x78>
  8013d8:	8b 45 08             	mov    0x8(%ebp),%eax
  8013db:	40                   	inc    %eax
  8013dc:	8a 00                	mov    (%eax),%al
  8013de:	3c 78                	cmp    $0x78,%al
  8013e0:	75 0d                	jne    8013ef <strtol+0x78>
		s += 2, base = 16;
  8013e2:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  8013e6:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  8013ed:	eb 28                	jmp    801417 <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  8013ef:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8013f3:	75 15                	jne    80140a <strtol+0x93>
  8013f5:	8b 45 08             	mov    0x8(%ebp),%eax
  8013f8:	8a 00                	mov    (%eax),%al
  8013fa:	3c 30                	cmp    $0x30,%al
  8013fc:	75 0c                	jne    80140a <strtol+0x93>
		s++, base = 8;
  8013fe:	ff 45 08             	incl   0x8(%ebp)
  801401:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  801408:	eb 0d                	jmp    801417 <strtol+0xa0>
	else if (base == 0)
  80140a:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80140e:	75 07                	jne    801417 <strtol+0xa0>
		base = 10;
  801410:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  801417:	8b 45 08             	mov    0x8(%ebp),%eax
  80141a:	8a 00                	mov    (%eax),%al
  80141c:	3c 2f                	cmp    $0x2f,%al
  80141e:	7e 19                	jle    801439 <strtol+0xc2>
  801420:	8b 45 08             	mov    0x8(%ebp),%eax
  801423:	8a 00                	mov    (%eax),%al
  801425:	3c 39                	cmp    $0x39,%al
  801427:	7f 10                	jg     801439 <strtol+0xc2>
			dig = *s - '0';
  801429:	8b 45 08             	mov    0x8(%ebp),%eax
  80142c:	8a 00                	mov    (%eax),%al
  80142e:	0f be c0             	movsbl %al,%eax
  801431:	83 e8 30             	sub    $0x30,%eax
  801434:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801437:	eb 42                	jmp    80147b <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  801439:	8b 45 08             	mov    0x8(%ebp),%eax
  80143c:	8a 00                	mov    (%eax),%al
  80143e:	3c 60                	cmp    $0x60,%al
  801440:	7e 19                	jle    80145b <strtol+0xe4>
  801442:	8b 45 08             	mov    0x8(%ebp),%eax
  801445:	8a 00                	mov    (%eax),%al
  801447:	3c 7a                	cmp    $0x7a,%al
  801449:	7f 10                	jg     80145b <strtol+0xe4>
			dig = *s - 'a' + 10;
  80144b:	8b 45 08             	mov    0x8(%ebp),%eax
  80144e:	8a 00                	mov    (%eax),%al
  801450:	0f be c0             	movsbl %al,%eax
  801453:	83 e8 57             	sub    $0x57,%eax
  801456:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801459:	eb 20                	jmp    80147b <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  80145b:	8b 45 08             	mov    0x8(%ebp),%eax
  80145e:	8a 00                	mov    (%eax),%al
  801460:	3c 40                	cmp    $0x40,%al
  801462:	7e 39                	jle    80149d <strtol+0x126>
  801464:	8b 45 08             	mov    0x8(%ebp),%eax
  801467:	8a 00                	mov    (%eax),%al
  801469:	3c 5a                	cmp    $0x5a,%al
  80146b:	7f 30                	jg     80149d <strtol+0x126>
			dig = *s - 'A' + 10;
  80146d:	8b 45 08             	mov    0x8(%ebp),%eax
  801470:	8a 00                	mov    (%eax),%al
  801472:	0f be c0             	movsbl %al,%eax
  801475:	83 e8 37             	sub    $0x37,%eax
  801478:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  80147b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80147e:	3b 45 10             	cmp    0x10(%ebp),%eax
  801481:	7d 19                	jge    80149c <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  801483:	ff 45 08             	incl   0x8(%ebp)
  801486:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801489:	0f af 45 10          	imul   0x10(%ebp),%eax
  80148d:	89 c2                	mov    %eax,%edx
  80148f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801492:	01 d0                	add    %edx,%eax
  801494:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  801497:	e9 7b ff ff ff       	jmp    801417 <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  80149c:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  80149d:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8014a1:	74 08                	je     8014ab <strtol+0x134>
		*endptr = (char *) s;
  8014a3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8014a6:	8b 55 08             	mov    0x8(%ebp),%edx
  8014a9:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  8014ab:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8014af:	74 07                	je     8014b8 <strtol+0x141>
  8014b1:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8014b4:	f7 d8                	neg    %eax
  8014b6:	eb 03                	jmp    8014bb <strtol+0x144>
  8014b8:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  8014bb:	c9                   	leave  
  8014bc:	c3                   	ret    

008014bd <ltostr>:

void
ltostr(long value, char *str)
{
  8014bd:	55                   	push   %ebp
  8014be:	89 e5                	mov    %esp,%ebp
  8014c0:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  8014c3:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  8014ca:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  8014d1:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8014d5:	79 13                	jns    8014ea <ltostr+0x2d>
	{
		neg = 1;
  8014d7:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  8014de:	8b 45 0c             	mov    0xc(%ebp),%eax
  8014e1:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  8014e4:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  8014e7:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  8014ea:	8b 45 08             	mov    0x8(%ebp),%eax
  8014ed:	b9 0a 00 00 00       	mov    $0xa,%ecx
  8014f2:	99                   	cltd   
  8014f3:	f7 f9                	idiv   %ecx
  8014f5:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  8014f8:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8014fb:	8d 50 01             	lea    0x1(%eax),%edx
  8014fe:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801501:	89 c2                	mov    %eax,%edx
  801503:	8b 45 0c             	mov    0xc(%ebp),%eax
  801506:	01 d0                	add    %edx,%eax
  801508:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80150b:	83 c2 30             	add    $0x30,%edx
  80150e:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  801510:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801513:	b8 67 66 66 66       	mov    $0x66666667,%eax
  801518:	f7 e9                	imul   %ecx
  80151a:	c1 fa 02             	sar    $0x2,%edx
  80151d:	89 c8                	mov    %ecx,%eax
  80151f:	c1 f8 1f             	sar    $0x1f,%eax
  801522:	29 c2                	sub    %eax,%edx
  801524:	89 d0                	mov    %edx,%eax
  801526:	89 45 08             	mov    %eax,0x8(%ebp)
	} while (value % 10 != 0);
  801529:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80152c:	b8 67 66 66 66       	mov    $0x66666667,%eax
  801531:	f7 e9                	imul   %ecx
  801533:	c1 fa 02             	sar    $0x2,%edx
  801536:	89 c8                	mov    %ecx,%eax
  801538:	c1 f8 1f             	sar    $0x1f,%eax
  80153b:	29 c2                	sub    %eax,%edx
  80153d:	89 d0                	mov    %edx,%eax
  80153f:	c1 e0 02             	shl    $0x2,%eax
  801542:	01 d0                	add    %edx,%eax
  801544:	01 c0                	add    %eax,%eax
  801546:	29 c1                	sub    %eax,%ecx
  801548:	89 ca                	mov    %ecx,%edx
  80154a:	85 d2                	test   %edx,%edx
  80154c:	75 9c                	jne    8014ea <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  80154e:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  801555:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801558:	48                   	dec    %eax
  801559:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  80155c:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801560:	74 3d                	je     80159f <ltostr+0xe2>
		start = 1 ;
  801562:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  801569:	eb 34                	jmp    80159f <ltostr+0xe2>
	{
		char tmp = str[start] ;
  80156b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80156e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801571:	01 d0                	add    %edx,%eax
  801573:	8a 00                	mov    (%eax),%al
  801575:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  801578:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80157b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80157e:	01 c2                	add    %eax,%edx
  801580:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  801583:	8b 45 0c             	mov    0xc(%ebp),%eax
  801586:	01 c8                	add    %ecx,%eax
  801588:	8a 00                	mov    (%eax),%al
  80158a:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  80158c:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80158f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801592:	01 c2                	add    %eax,%edx
  801594:	8a 45 eb             	mov    -0x15(%ebp),%al
  801597:	88 02                	mov    %al,(%edx)
		start++ ;
  801599:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  80159c:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  80159f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8015a2:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8015a5:	7c c4                	jl     80156b <ltostr+0xae>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  8015a7:	8b 55 f8             	mov    -0x8(%ebp),%edx
  8015aa:	8b 45 0c             	mov    0xc(%ebp),%eax
  8015ad:	01 d0                	add    %edx,%eax
  8015af:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  8015b2:	90                   	nop
  8015b3:	c9                   	leave  
  8015b4:	c3                   	ret    

008015b5 <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  8015b5:	55                   	push   %ebp
  8015b6:	89 e5                	mov    %esp,%ebp
  8015b8:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  8015bb:	ff 75 08             	pushl  0x8(%ebp)
  8015be:	e8 54 fa ff ff       	call   801017 <strlen>
  8015c3:	83 c4 04             	add    $0x4,%esp
  8015c6:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  8015c9:	ff 75 0c             	pushl  0xc(%ebp)
  8015cc:	e8 46 fa ff ff       	call   801017 <strlen>
  8015d1:	83 c4 04             	add    $0x4,%esp
  8015d4:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  8015d7:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  8015de:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8015e5:	eb 17                	jmp    8015fe <strcconcat+0x49>
		final[s] = str1[s] ;
  8015e7:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8015ea:	8b 45 10             	mov    0x10(%ebp),%eax
  8015ed:	01 c2                	add    %eax,%edx
  8015ef:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  8015f2:	8b 45 08             	mov    0x8(%ebp),%eax
  8015f5:	01 c8                	add    %ecx,%eax
  8015f7:	8a 00                	mov    (%eax),%al
  8015f9:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  8015fb:	ff 45 fc             	incl   -0x4(%ebp)
  8015fe:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801601:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  801604:	7c e1                	jl     8015e7 <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  801606:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  80160d:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  801614:	eb 1f                	jmp    801635 <strcconcat+0x80>
		final[s++] = str2[i] ;
  801616:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801619:	8d 50 01             	lea    0x1(%eax),%edx
  80161c:	89 55 fc             	mov    %edx,-0x4(%ebp)
  80161f:	89 c2                	mov    %eax,%edx
  801621:	8b 45 10             	mov    0x10(%ebp),%eax
  801624:	01 c2                	add    %eax,%edx
  801626:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  801629:	8b 45 0c             	mov    0xc(%ebp),%eax
  80162c:	01 c8                	add    %ecx,%eax
  80162e:	8a 00                	mov    (%eax),%al
  801630:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  801632:	ff 45 f8             	incl   -0x8(%ebp)
  801635:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801638:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80163b:	7c d9                	jl     801616 <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  80163d:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801640:	8b 45 10             	mov    0x10(%ebp),%eax
  801643:	01 d0                	add    %edx,%eax
  801645:	c6 00 00             	movb   $0x0,(%eax)
}
  801648:	90                   	nop
  801649:	c9                   	leave  
  80164a:	c3                   	ret    

0080164b <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  80164b:	55                   	push   %ebp
  80164c:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  80164e:	8b 45 14             	mov    0x14(%ebp),%eax
  801651:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  801657:	8b 45 14             	mov    0x14(%ebp),%eax
  80165a:	8b 00                	mov    (%eax),%eax
  80165c:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801663:	8b 45 10             	mov    0x10(%ebp),%eax
  801666:	01 d0                	add    %edx,%eax
  801668:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  80166e:	eb 0c                	jmp    80167c <strsplit+0x31>
			*string++ = 0;
  801670:	8b 45 08             	mov    0x8(%ebp),%eax
  801673:	8d 50 01             	lea    0x1(%eax),%edx
  801676:	89 55 08             	mov    %edx,0x8(%ebp)
  801679:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  80167c:	8b 45 08             	mov    0x8(%ebp),%eax
  80167f:	8a 00                	mov    (%eax),%al
  801681:	84 c0                	test   %al,%al
  801683:	74 18                	je     80169d <strsplit+0x52>
  801685:	8b 45 08             	mov    0x8(%ebp),%eax
  801688:	8a 00                	mov    (%eax),%al
  80168a:	0f be c0             	movsbl %al,%eax
  80168d:	50                   	push   %eax
  80168e:	ff 75 0c             	pushl  0xc(%ebp)
  801691:	e8 13 fb ff ff       	call   8011a9 <strchr>
  801696:	83 c4 08             	add    $0x8,%esp
  801699:	85 c0                	test   %eax,%eax
  80169b:	75 d3                	jne    801670 <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  80169d:	8b 45 08             	mov    0x8(%ebp),%eax
  8016a0:	8a 00                	mov    (%eax),%al
  8016a2:	84 c0                	test   %al,%al
  8016a4:	74 5a                	je     801700 <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  8016a6:	8b 45 14             	mov    0x14(%ebp),%eax
  8016a9:	8b 00                	mov    (%eax),%eax
  8016ab:	83 f8 0f             	cmp    $0xf,%eax
  8016ae:	75 07                	jne    8016b7 <strsplit+0x6c>
		{
			return 0;
  8016b0:	b8 00 00 00 00       	mov    $0x0,%eax
  8016b5:	eb 66                	jmp    80171d <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  8016b7:	8b 45 14             	mov    0x14(%ebp),%eax
  8016ba:	8b 00                	mov    (%eax),%eax
  8016bc:	8d 48 01             	lea    0x1(%eax),%ecx
  8016bf:	8b 55 14             	mov    0x14(%ebp),%edx
  8016c2:	89 0a                	mov    %ecx,(%edx)
  8016c4:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8016cb:	8b 45 10             	mov    0x10(%ebp),%eax
  8016ce:	01 c2                	add    %eax,%edx
  8016d0:	8b 45 08             	mov    0x8(%ebp),%eax
  8016d3:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  8016d5:	eb 03                	jmp    8016da <strsplit+0x8f>
			string++;
  8016d7:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  8016da:	8b 45 08             	mov    0x8(%ebp),%eax
  8016dd:	8a 00                	mov    (%eax),%al
  8016df:	84 c0                	test   %al,%al
  8016e1:	74 8b                	je     80166e <strsplit+0x23>
  8016e3:	8b 45 08             	mov    0x8(%ebp),%eax
  8016e6:	8a 00                	mov    (%eax),%al
  8016e8:	0f be c0             	movsbl %al,%eax
  8016eb:	50                   	push   %eax
  8016ec:	ff 75 0c             	pushl  0xc(%ebp)
  8016ef:	e8 b5 fa ff ff       	call   8011a9 <strchr>
  8016f4:	83 c4 08             	add    $0x8,%esp
  8016f7:	85 c0                	test   %eax,%eax
  8016f9:	74 dc                	je     8016d7 <strsplit+0x8c>
			string++;
	}
  8016fb:	e9 6e ff ff ff       	jmp    80166e <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  801700:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  801701:	8b 45 14             	mov    0x14(%ebp),%eax
  801704:	8b 00                	mov    (%eax),%eax
  801706:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80170d:	8b 45 10             	mov    0x10(%ebp),%eax
  801710:	01 d0                	add    %edx,%eax
  801712:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  801718:	b8 01 00 00 00       	mov    $0x1,%eax
}
  80171d:	c9                   	leave  
  80171e:	c3                   	ret    

0080171f <InitializeUHeap>:
//============================== GIVEN FUNCTIONS ===================================//
//==================================================================================//

int FirstTimeFlag = 1;
void InitializeUHeap()
{
  80171f:	55                   	push   %ebp
  801720:	89 e5                	mov    %esp,%ebp
  801722:	83 ec 08             	sub    $0x8,%esp
	if(FirstTimeFlag)
  801725:	a1 04 40 80 00       	mov    0x804004,%eax
  80172a:	85 c0                	test   %eax,%eax
  80172c:	74 1f                	je     80174d <InitializeUHeap+0x2e>
	{
		initialize_dyn_block_system();
  80172e:	e8 1d 00 00 00       	call   801750 <initialize_dyn_block_system>
		cprintf("DYNAMIC BLOCK SYSTEM IS INITIALIZED\n");
  801733:	83 ec 0c             	sub    $0xc,%esp
  801736:	68 f0 3b 80 00       	push   $0x803bf0
  80173b:	e8 55 f2 ff ff       	call   800995 <cprintf>
  801740:	83 c4 10             	add    $0x10,%esp
#if UHP_USE_BUDDY
		initialize_buddy();
		cprintf("BUDDY SYSTEM IS INITIALIZED\n");
#endif
		FirstTimeFlag = 0;
  801743:	c7 05 04 40 80 00 00 	movl   $0x0,0x804004
  80174a:	00 00 00 
	}
}
  80174d:	90                   	nop
  80174e:	c9                   	leave  
  80174f:	c3                   	ret    

00801750 <initialize_dyn_block_system>:

//=================================
// [1] INITIALIZE DYNAMIC ALLOCATOR:
//=================================
void initialize_dyn_block_system()
{
  801750:	55                   	push   %ebp
  801751:	89 e5                	mov    %esp,%ebp
  801753:	83 ec 28             	sub    $0x28,%esp
	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] initialize_dyn_block_system
	// your code is here, remove the panic and write your code
	//panic("initialize_dyn_block_system() is not implemented yet...!!");

	LIST_INIT(&AllocMemBlocksList);
  801756:	c7 05 40 40 80 00 00 	movl   $0x0,0x804040
  80175d:	00 00 00 
  801760:	c7 05 44 40 80 00 00 	movl   $0x0,0x804044
  801767:	00 00 00 
  80176a:	c7 05 4c 40 80 00 00 	movl   $0x0,0x80404c
  801771:	00 00 00 
	LIST_INIT(&FreeMemBlocksList);
  801774:	c7 05 38 41 80 00 00 	movl   $0x0,0x804138
  80177b:	00 00 00 
  80177e:	c7 05 3c 41 80 00 00 	movl   $0x0,0x80413c
  801785:	00 00 00 
  801788:	c7 05 44 41 80 00 00 	movl   $0x0,0x804144
  80178f:	00 00 00 
	MAX_MEM_BLOCK_CNT = NUM_OF_UHEAP_PAGES;
  801792:	c7 05 20 41 80 00 00 	movl   $0x20000,0x804120
  801799:	00 02 00 
	MemBlockNodes = (void*)USER_DYN_BLKS_ARRAY;
  80179c:	c7 45 f4 00 00 e0 7f 	movl   $0x7fe00000,-0xc(%ebp)
  8017a3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8017a6:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8017ab:	2d 00 10 00 00       	sub    $0x1000,%eax
  8017b0:	a3 50 40 80 00       	mov    %eax,0x804050
	int size_of_block = sizeof(struct MemBlock);
  8017b5:	c7 45 f0 10 00 00 00 	movl   $0x10,-0x10(%ebp)
	int size_all_struct = size_of_block*MAX_MEM_BLOCK_CNT;
  8017bc:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8017bf:	a1 20 41 80 00       	mov    0x804120,%eax
  8017c4:	0f af c2             	imul   %edx,%eax
  8017c7:	89 45 ec             	mov    %eax,-0x14(%ebp)
	size_all_struct = ROUNDUP(size_all_struct, PAGE_SIZE);
  8017ca:	c7 45 e8 00 10 00 00 	movl   $0x1000,-0x18(%ebp)
  8017d1:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8017d4:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8017d7:	01 d0                	add    %edx,%eax
  8017d9:	48                   	dec    %eax
  8017da:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8017dd:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8017e0:	ba 00 00 00 00       	mov    $0x0,%edx
  8017e5:	f7 75 e8             	divl   -0x18(%ebp)
  8017e8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8017eb:	29 d0                	sub    %edx,%eax
  8017ed:	89 45 ec             	mov    %eax,-0x14(%ebp)
	sys_allocate_chunk(USER_DYN_BLKS_ARRAY, size_all_struct,PERM_USER| PERM_WRITEABLE);
  8017f0:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8017f3:	c7 45 e0 00 00 e0 7f 	movl   $0x7fe00000,-0x20(%ebp)
  8017fa:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8017fd:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
  801803:	81 ea 00 10 00 00    	sub    $0x1000,%edx
  801809:	83 ec 04             	sub    $0x4,%esp
  80180c:	6a 06                	push   $0x6
  80180e:	50                   	push   %eax
  80180f:	52                   	push   %edx
  801810:	e8 a1 05 00 00       	call   801db6 <sys_allocate_chunk>
  801815:	83 c4 10             	add    $0x10,%esp
	initialize_MemBlocksList(MAX_MEM_BLOCK_CNT);
  801818:	a1 20 41 80 00       	mov    0x804120,%eax
  80181d:	83 ec 0c             	sub    $0xc,%esp
  801820:	50                   	push   %eax
  801821:	e8 16 0c 00 00       	call   80243c <initialize_MemBlocksList>
  801826:	83 c4 10             	add    $0x10,%esp
	struct MemBlock* ourBlock =LIST_LAST(&AvailableMemBlocksList);
  801829:	a1 4c 41 80 00       	mov    0x80414c,%eax
  80182e:	89 45 dc             	mov    %eax,-0x24(%ebp)
	LIST_REMOVE(&AvailableMemBlocksList,ourBlock);
  801831:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  801835:	75 14                	jne    80184b <initialize_dyn_block_system+0xfb>
  801837:	83 ec 04             	sub    $0x4,%esp
  80183a:	68 15 3c 80 00       	push   $0x803c15
  80183f:	6a 2d                	push   $0x2d
  801841:	68 33 3c 80 00       	push   $0x803c33
  801846:	e8 96 ee ff ff       	call   8006e1 <_panic>
  80184b:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80184e:	8b 00                	mov    (%eax),%eax
  801850:	85 c0                	test   %eax,%eax
  801852:	74 10                	je     801864 <initialize_dyn_block_system+0x114>
  801854:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801857:	8b 00                	mov    (%eax),%eax
  801859:	8b 55 dc             	mov    -0x24(%ebp),%edx
  80185c:	8b 52 04             	mov    0x4(%edx),%edx
  80185f:	89 50 04             	mov    %edx,0x4(%eax)
  801862:	eb 0b                	jmp    80186f <initialize_dyn_block_system+0x11f>
  801864:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801867:	8b 40 04             	mov    0x4(%eax),%eax
  80186a:	a3 4c 41 80 00       	mov    %eax,0x80414c
  80186f:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801872:	8b 40 04             	mov    0x4(%eax),%eax
  801875:	85 c0                	test   %eax,%eax
  801877:	74 0f                	je     801888 <initialize_dyn_block_system+0x138>
  801879:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80187c:	8b 40 04             	mov    0x4(%eax),%eax
  80187f:	8b 55 dc             	mov    -0x24(%ebp),%edx
  801882:	8b 12                	mov    (%edx),%edx
  801884:	89 10                	mov    %edx,(%eax)
  801886:	eb 0a                	jmp    801892 <initialize_dyn_block_system+0x142>
  801888:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80188b:	8b 00                	mov    (%eax),%eax
  80188d:	a3 48 41 80 00       	mov    %eax,0x804148
  801892:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801895:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80189b:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80189e:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8018a5:	a1 54 41 80 00       	mov    0x804154,%eax
  8018aa:	48                   	dec    %eax
  8018ab:	a3 54 41 80 00       	mov    %eax,0x804154
	ourBlock->size = USER_HEAP_MAX-USER_HEAP_START;
  8018b0:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8018b3:	c7 40 0c 00 00 00 20 	movl   $0x20000000,0xc(%eax)
	ourBlock->sva=USER_HEAP_START;
  8018ba:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8018bd:	c7 40 08 00 00 00 80 	movl   $0x80000000,0x8(%eax)
	LIST_INSERT_TAIL(&FreeMemBlocksList, ourBlock);
  8018c4:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  8018c8:	75 14                	jne    8018de <initialize_dyn_block_system+0x18e>
  8018ca:	83 ec 04             	sub    $0x4,%esp
  8018cd:	68 40 3c 80 00       	push   $0x803c40
  8018d2:	6a 30                	push   $0x30
  8018d4:	68 33 3c 80 00       	push   $0x803c33
  8018d9:	e8 03 ee ff ff       	call   8006e1 <_panic>
  8018de:	8b 15 3c 41 80 00    	mov    0x80413c,%edx
  8018e4:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8018e7:	89 50 04             	mov    %edx,0x4(%eax)
  8018ea:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8018ed:	8b 40 04             	mov    0x4(%eax),%eax
  8018f0:	85 c0                	test   %eax,%eax
  8018f2:	74 0c                	je     801900 <initialize_dyn_block_system+0x1b0>
  8018f4:	a1 3c 41 80 00       	mov    0x80413c,%eax
  8018f9:	8b 55 dc             	mov    -0x24(%ebp),%edx
  8018fc:	89 10                	mov    %edx,(%eax)
  8018fe:	eb 08                	jmp    801908 <initialize_dyn_block_system+0x1b8>
  801900:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801903:	a3 38 41 80 00       	mov    %eax,0x804138
  801908:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80190b:	a3 3c 41 80 00       	mov    %eax,0x80413c
  801910:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801913:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  801919:	a1 44 41 80 00       	mov    0x804144,%eax
  80191e:	40                   	inc    %eax
  80191f:	a3 44 41 80 00       	mov    %eax,0x804144
	//[1] Initialize two lists (AllocMemBlocksList & FreeMemBlocksList) [Hint: use LIST_INIT()]
	//[2] Dynamically allocate the array of MemBlockNodes at VA USER_DYN_BLKS_ARRAY
	//	  (remember to set MAX_MEM_BLOCK_CNT with the chosen size of the array)
	//[3] Initialize AvailableMemBlocksList by filling it with the MemBlockNodes
	//[4] Insert a new MemBlock with the heap size into the FreeMemBlocksList
}
  801924:	90                   	nop
  801925:	c9                   	leave  
  801926:	c3                   	ret    

00801927 <malloc>:
//=================================
// [2] ALLOCATE SPACE IN USER HEAP:
//=================================

void* malloc(uint32 size)
{
  801927:	55                   	push   %ebp
  801928:	89 e5                	mov    %esp,%ebp
  80192a:	83 ec 18             	sub    $0x18,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  80192d:	e8 ed fd ff ff       	call   80171f <InitializeUHeap>
	if (size == 0) return NULL ;
  801932:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801936:	75 07                	jne    80193f <malloc+0x18>
  801938:	b8 00 00 00 00       	mov    $0x0,%eax
  80193d:	eb 67                	jmp    8019a6 <malloc+0x7f>

	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] malloc
	// your code is here, remove the panic and write your code
	//panic("malloc() is not implemented yet...!!");

	size = ROUNDUP(size, PAGE_SIZE);
  80193f:	c7 45 f4 00 10 00 00 	movl   $0x1000,-0xc(%ebp)
  801946:	8b 55 08             	mov    0x8(%ebp),%edx
  801949:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80194c:	01 d0                	add    %edx,%eax
  80194e:	48                   	dec    %eax
  80194f:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801952:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801955:	ba 00 00 00 00       	mov    $0x0,%edx
  80195a:	f7 75 f4             	divl   -0xc(%ebp)
  80195d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801960:	29 d0                	sub    %edx,%eax
  801962:	89 45 08             	mov    %eax,0x8(%ebp)
	if(sys_isUHeapPlacementStrategyFIRSTFIT())
  801965:	e8 1a 08 00 00       	call   802184 <sys_isUHeapPlacementStrategyFIRSTFIT>
  80196a:	85 c0                	test   %eax,%eax
  80196c:	74 33                	je     8019a1 <malloc+0x7a>
	{
		struct MemBlock * myBlock = alloc_block_FF(size);
  80196e:	83 ec 0c             	sub    $0xc,%esp
  801971:	ff 75 08             	pushl  0x8(%ebp)
  801974:	e8 0c 0e 00 00       	call   802785 <alloc_block_FF>
  801979:	83 c4 10             	add    $0x10,%esp
  80197c:	89 45 ec             	mov    %eax,-0x14(%ebp)
		if(myBlock != NULL)
  80197f:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  801983:	74 1c                	je     8019a1 <malloc+0x7a>
		{
			insert_sorted_allocList(myBlock);
  801985:	83 ec 0c             	sub    $0xc,%esp
  801988:	ff 75 ec             	pushl  -0x14(%ebp)
  80198b:	e8 07 0c 00 00       	call   802597 <insert_sorted_allocList>
  801990:	83 c4 10             	add    $0x10,%esp
			uint32 ptr = myBlock->sva;
  801993:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801996:	8b 40 08             	mov    0x8(%eax),%eax
  801999:	89 45 e8             	mov    %eax,-0x18(%ebp)
			return (void *)ptr;
  80199c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80199f:	eb 05                	jmp    8019a6 <malloc+0x7f>
		}
	}
	return NULL;
  8019a1:	b8 00 00 00 00       	mov    $0x0,%eax
	//		to the required allocation size (space should be on 4 KB BOUNDARY)
	//	2) if no suitable space found, return NULL
	// 	3) Return pointer containing the virtual address of allocated space,
	//
	//Use sys_isUHeapPlacementStrategyFIRSTFIT()... to check the current strategy
}
  8019a6:	c9                   	leave  
  8019a7:	c3                   	ret    

008019a8 <free>:
//	We can use sys_free_user_mem(uint32 virtual_address, uint32 size); which
//		switches to the kernel mode, calls free_user_mem() in
//		"kern/mem/chunk_operations.c", then switch back to the user mode here
//	the free_user_mem function is empty, make sure to implement it.
void free(void* virtual_address)
{
  8019a8:	55                   	push   %ebp
  8019a9:	89 e5                	mov    %esp,%ebp
  8019ab:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] free
	// your code is here, remove the panic and write your code
	//panic("free() is not implemented yet...!!");

	uint32 virtualAddress = (uint32 )(virtual_address);
  8019ae:	8b 45 08             	mov    0x8(%ebp),%eax
  8019b1:	89 45 f4             	mov    %eax,-0xc(%ebp)
//	virtualAddress = ROUNDDOWN(virtualAddress, PAGE_SIZE);
	struct MemBlock * myBlock = find_block(&AllocMemBlocksList, virtualAddress);
  8019b4:	83 ec 08             	sub    $0x8,%esp
  8019b7:	ff 75 f4             	pushl  -0xc(%ebp)
  8019ba:	68 40 40 80 00       	push   $0x804040
  8019bf:	e8 5b 0b 00 00       	call   80251f <find_block>
  8019c4:	83 c4 10             	add    $0x10,%esp
  8019c7:	89 45 f0             	mov    %eax,-0x10(%ebp)
//	cprintf ("ptr sva at free user side = %x \n", myBlock->sva);
	sys_free_user_mem(virtualAddress, myBlock->size);
  8019ca:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8019cd:	8b 40 0c             	mov    0xc(%eax),%eax
  8019d0:	83 ec 08             	sub    $0x8,%esp
  8019d3:	50                   	push   %eax
  8019d4:	ff 75 f4             	pushl  -0xc(%ebp)
  8019d7:	e8 a2 03 00 00       	call   801d7e <sys_free_user_mem>
  8019dc:	83 c4 10             	add    $0x10,%esp
	LIST_REMOVE(&AllocMemBlocksList, myBlock);
  8019df:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8019e3:	75 14                	jne    8019f9 <free+0x51>
  8019e5:	83 ec 04             	sub    $0x4,%esp
  8019e8:	68 15 3c 80 00       	push   $0x803c15
  8019ed:	6a 76                	push   $0x76
  8019ef:	68 33 3c 80 00       	push   $0x803c33
  8019f4:	e8 e8 ec ff ff       	call   8006e1 <_panic>
  8019f9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8019fc:	8b 00                	mov    (%eax),%eax
  8019fe:	85 c0                	test   %eax,%eax
  801a00:	74 10                	je     801a12 <free+0x6a>
  801a02:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801a05:	8b 00                	mov    (%eax),%eax
  801a07:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801a0a:	8b 52 04             	mov    0x4(%edx),%edx
  801a0d:	89 50 04             	mov    %edx,0x4(%eax)
  801a10:	eb 0b                	jmp    801a1d <free+0x75>
  801a12:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801a15:	8b 40 04             	mov    0x4(%eax),%eax
  801a18:	a3 44 40 80 00       	mov    %eax,0x804044
  801a1d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801a20:	8b 40 04             	mov    0x4(%eax),%eax
  801a23:	85 c0                	test   %eax,%eax
  801a25:	74 0f                	je     801a36 <free+0x8e>
  801a27:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801a2a:	8b 40 04             	mov    0x4(%eax),%eax
  801a2d:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801a30:	8b 12                	mov    (%edx),%edx
  801a32:	89 10                	mov    %edx,(%eax)
  801a34:	eb 0a                	jmp    801a40 <free+0x98>
  801a36:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801a39:	8b 00                	mov    (%eax),%eax
  801a3b:	a3 40 40 80 00       	mov    %eax,0x804040
  801a40:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801a43:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  801a49:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801a4c:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  801a53:	a1 4c 40 80 00       	mov    0x80404c,%eax
  801a58:	48                   	dec    %eax
  801a59:	a3 4c 40 80 00       	mov    %eax,0x80404c
	insert_sorted_with_merge_freeList(myBlock);
  801a5e:	83 ec 0c             	sub    $0xc,%esp
  801a61:	ff 75 f0             	pushl  -0x10(%ebp)
  801a64:	e8 0b 14 00 00       	call   802e74 <insert_sorted_with_merge_freeList>
  801a69:	83 c4 10             	add    $0x10,%esp

	//you should get the size of the given allocation using its address
	//you need to call sys_free_user_mem()
	//refer to the project presentation and documentation for details
}
  801a6c:	90                   	nop
  801a6d:	c9                   	leave  
  801a6e:	c3                   	ret    

00801a6f <smalloc>:

//=================================
// [4] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
  801a6f:	55                   	push   %ebp
  801a70:	89 e5                	mov    %esp,%ebp
  801a72:	83 ec 28             	sub    $0x28,%esp
  801a75:	8b 45 10             	mov    0x10(%ebp),%eax
  801a78:	88 45 e4             	mov    %al,-0x1c(%ebp)
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801a7b:	e8 9f fc ff ff       	call   80171f <InitializeUHeap>
	if (size == 0) return NULL ;
  801a80:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801a84:	75 0a                	jne    801a90 <smalloc+0x21>
  801a86:	b8 00 00 00 00       	mov    $0x0,%eax
  801a8b:	e9 8d 00 00 00       	jmp    801b1d <smalloc+0xae>

	//This function should find the space of the required range
	// * ON 4KB BOUNDARY **** //
	//Use sys_isUHeapPlacementStrategyFIRSTFIT() to check the current strategy

	size = ROUNDUP(size, PAGE_SIZE);
  801a90:	c7 45 f4 00 10 00 00 	movl   $0x1000,-0xc(%ebp)
  801a97:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a9a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801a9d:	01 d0                	add    %edx,%eax
  801a9f:	48                   	dec    %eax
  801aa0:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801aa3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801aa6:	ba 00 00 00 00       	mov    $0x0,%edx
  801aab:	f7 75 f4             	divl   -0xc(%ebp)
  801aae:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801ab1:	29 d0                	sub    %edx,%eax
  801ab3:	89 45 0c             	mov    %eax,0xc(%ebp)
		if(sys_isUHeapPlacementStrategyFIRSTFIT())
  801ab6:	e8 c9 06 00 00       	call   802184 <sys_isUHeapPlacementStrategyFIRSTFIT>
  801abb:	85 c0                	test   %eax,%eax
  801abd:	74 59                	je     801b18 <smalloc+0xa9>
		{
			struct MemBlock * v1=NULL;
  801abf:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
			v1= alloc_block_FF(size);
  801ac6:	83 ec 0c             	sub    $0xc,%esp
  801ac9:	ff 75 0c             	pushl  0xc(%ebp)
  801acc:	e8 b4 0c 00 00       	call   802785 <alloc_block_FF>
  801ad1:	83 c4 10             	add    $0x10,%esp
  801ad4:	89 45 ec             	mov    %eax,-0x14(%ebp)
			if(v1==NULL)
  801ad7:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  801adb:	75 07                	jne    801ae4 <smalloc+0x75>
			{
				return NULL;
  801add:	b8 00 00 00 00       	mov    $0x0,%eax
  801ae2:	eb 39                	jmp    801b1d <smalloc+0xae>
			}
			else
			{
				int ret=sys_createSharedObject(sharedVarName,  size,  isWritable,(void*)v1->sva);
  801ae4:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801ae7:	8b 40 08             	mov    0x8(%eax),%eax
  801aea:	89 c2                	mov    %eax,%edx
  801aec:	0f b6 45 e4          	movzbl -0x1c(%ebp),%eax
  801af0:	52                   	push   %edx
  801af1:	50                   	push   %eax
  801af2:	ff 75 0c             	pushl  0xc(%ebp)
  801af5:	ff 75 08             	pushl  0x8(%ebp)
  801af8:	e8 0c 04 00 00       	call   801f09 <sys_createSharedObject>
  801afd:	83 c4 10             	add    $0x10,%esp
  801b00:	89 45 e8             	mov    %eax,-0x18(%ebp)
				if(ret>=0)
  801b03:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  801b07:	78 08                	js     801b11 <smalloc+0xa2>
				{
					return (void*)v1->sva;
  801b09:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801b0c:	8b 40 08             	mov    0x8(%eax),%eax
  801b0f:	eb 0c                	jmp    801b1d <smalloc+0xae>
				}
				else
				{
					return NULL;
  801b11:	b8 00 00 00 00       	mov    $0x0,%eax
  801b16:	eb 05                	jmp    801b1d <smalloc+0xae>
				}
			}

		}
		return NULL;
  801b18:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801b1d:	c9                   	leave  
  801b1e:	c3                   	ret    

00801b1f <sget>:

//========================================
// [5] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  801b1f:	55                   	push   %ebp
  801b20:	89 e5                	mov    %esp,%ebp
  801b22:	83 ec 18             	sub    $0x18,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801b25:	e8 f5 fb ff ff       	call   80171f <InitializeUHeap>

	//This function should find the space for sharing the variable
	// *** ON 4KB BOUNDARY ******** //

	//Use sys_isUHeapPlacementStrategyFIRSTFIT() to check the current strategy
	int ret=sys_getSizeOfSharedObject(ownerEnvID,sharedVarName);
  801b2a:	83 ec 08             	sub    $0x8,%esp
  801b2d:	ff 75 0c             	pushl  0xc(%ebp)
  801b30:	ff 75 08             	pushl  0x8(%ebp)
  801b33:	e8 fb 03 00 00       	call   801f33 <sys_getSizeOfSharedObject>
  801b38:	83 c4 10             	add    $0x10,%esp
  801b3b:	89 45 f4             	mov    %eax,-0xc(%ebp)
	if(ret==0)
  801b3e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801b42:	75 07                	jne    801b4b <sget+0x2c>
	{
		return NULL;
  801b44:	b8 00 00 00 00       	mov    $0x0,%eax
  801b49:	eb 64                	jmp    801baf <sget+0x90>
	}
	if(sys_isUHeapPlacementStrategyFIRSTFIT())
  801b4b:	e8 34 06 00 00       	call   802184 <sys_isUHeapPlacementStrategyFIRSTFIT>
  801b50:	85 c0                	test   %eax,%eax
  801b52:	74 56                	je     801baa <sget+0x8b>
	{
		struct MemBlock * v1=NULL;
  801b54:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
		v1= alloc_block_FF(ret);
  801b5b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801b5e:	83 ec 0c             	sub    $0xc,%esp
  801b61:	50                   	push   %eax
  801b62:	e8 1e 0c 00 00       	call   802785 <alloc_block_FF>
  801b67:	83 c4 10             	add    $0x10,%esp
  801b6a:	89 45 f0             	mov    %eax,-0x10(%ebp)
		if(v1==NULL)
  801b6d:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801b71:	75 07                	jne    801b7a <sget+0x5b>
		{
		return NULL;
  801b73:	b8 00 00 00 00       	mov    $0x0,%eax
  801b78:	eb 35                	jmp    801baf <sget+0x90>
	    }
		else
		{
			int ret1=sys_getSharedObject(ownerEnvID,sharedVarName,(void*)v1->sva);
  801b7a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801b7d:	8b 40 08             	mov    0x8(%eax),%eax
  801b80:	83 ec 04             	sub    $0x4,%esp
  801b83:	50                   	push   %eax
  801b84:	ff 75 0c             	pushl  0xc(%ebp)
  801b87:	ff 75 08             	pushl  0x8(%ebp)
  801b8a:	e8 c1 03 00 00       	call   801f50 <sys_getSharedObject>
  801b8f:	83 c4 10             	add    $0x10,%esp
  801b92:	89 45 ec             	mov    %eax,-0x14(%ebp)
			if(ret1>=0)
  801b95:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  801b99:	78 08                	js     801ba3 <sget+0x84>
			{
				return (void*)v1->sva;
  801b9b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801b9e:	8b 40 08             	mov    0x8(%eax),%eax
  801ba1:	eb 0c                	jmp    801baf <sget+0x90>
			}
			else
			{
				return NULL;
  801ba3:	b8 00 00 00 00       	mov    $0x0,%eax
  801ba8:	eb 05                	jmp    801baf <sget+0x90>
			}
		}
	}
  return NULL;
  801baa:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801baf:	c9                   	leave  
  801bb0:	c3                   	ret    

00801bb1 <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  801bb1:	55                   	push   %ebp
  801bb2:	89 e5                	mov    %esp,%ebp
  801bb4:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801bb7:	e8 63 fb ff ff       	call   80171f <InitializeUHeap>
	//==============================================================
	// [USER HEAP - USER SIDE] realloc
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  801bbc:	83 ec 04             	sub    $0x4,%esp
  801bbf:	68 64 3c 80 00       	push   $0x803c64
  801bc4:	68 0e 01 00 00       	push   $0x10e
  801bc9:	68 33 3c 80 00       	push   $0x803c33
  801bce:	e8 0e eb ff ff       	call   8006e1 <_panic>

00801bd3 <sfree>:
//	use sys_freeSharedObject(...); which switches to the kernel mode,
//	calls freeSharedObject(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the freeSharedObject() function is empty, make sure to implement it.

void sfree(void* virtual_address)
{
  801bd3:	55                   	push   %ebp
  801bd4:	89 e5                	mov    %esp,%ebp
  801bd6:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS3 - BONUS] [SHARING - USER SIDE] sfree()

	// Write your code here, remove the panic and write your code
	panic("sfree() is not implemented yet...!!");
  801bd9:	83 ec 04             	sub    $0x4,%esp
  801bdc:	68 8c 3c 80 00       	push   $0x803c8c
  801be1:	68 22 01 00 00       	push   $0x122
  801be6:	68 33 3c 80 00       	push   $0x803c33
  801beb:	e8 f1 ea ff ff       	call   8006e1 <_panic>

00801bf0 <expand>:

//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//
void expand(uint32 newSize)
{
  801bf0:	55                   	push   %ebp
  801bf1:	89 e5                	mov    %esp,%ebp
  801bf3:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801bf6:	83 ec 04             	sub    $0x4,%esp
  801bf9:	68 b0 3c 80 00       	push   $0x803cb0
  801bfe:	68 2d 01 00 00       	push   $0x12d
  801c03:	68 33 3c 80 00       	push   $0x803c33
  801c08:	e8 d4 ea ff ff       	call   8006e1 <_panic>

00801c0d <shrink>:

}
void shrink(uint32 newSize)
{
  801c0d:	55                   	push   %ebp
  801c0e:	89 e5                	mov    %esp,%ebp
  801c10:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801c13:	83 ec 04             	sub    $0x4,%esp
  801c16:	68 b0 3c 80 00       	push   $0x803cb0
  801c1b:	68 32 01 00 00       	push   $0x132
  801c20:	68 33 3c 80 00       	push   $0x803c33
  801c25:	e8 b7 ea ff ff       	call   8006e1 <_panic>

00801c2a <freeHeap>:

}
void freeHeap(void* virtual_address)
{
  801c2a:	55                   	push   %ebp
  801c2b:	89 e5                	mov    %esp,%ebp
  801c2d:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801c30:	83 ec 04             	sub    $0x4,%esp
  801c33:	68 b0 3c 80 00       	push   $0x803cb0
  801c38:	68 37 01 00 00       	push   $0x137
  801c3d:	68 33 3c 80 00       	push   $0x803c33
  801c42:	e8 9a ea ff ff       	call   8006e1 <_panic>

00801c47 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  801c47:	55                   	push   %ebp
  801c48:	89 e5                	mov    %esp,%ebp
  801c4a:	57                   	push   %edi
  801c4b:	56                   	push   %esi
  801c4c:	53                   	push   %ebx
  801c4d:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801c50:	8b 45 08             	mov    0x8(%ebp),%eax
  801c53:	8b 55 0c             	mov    0xc(%ebp),%edx
  801c56:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801c59:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801c5c:	8b 7d 18             	mov    0x18(%ebp),%edi
  801c5f:	8b 75 1c             	mov    0x1c(%ebp),%esi
  801c62:	cd 30                	int    $0x30
  801c64:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  801c67:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801c6a:	83 c4 10             	add    $0x10,%esp
  801c6d:	5b                   	pop    %ebx
  801c6e:	5e                   	pop    %esi
  801c6f:	5f                   	pop    %edi
  801c70:	5d                   	pop    %ebp
  801c71:	c3                   	ret    

00801c72 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  801c72:	55                   	push   %ebp
  801c73:	89 e5                	mov    %esp,%ebp
  801c75:	83 ec 04             	sub    $0x4,%esp
  801c78:	8b 45 10             	mov    0x10(%ebp),%eax
  801c7b:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  801c7e:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801c82:	8b 45 08             	mov    0x8(%ebp),%eax
  801c85:	6a 00                	push   $0x0
  801c87:	6a 00                	push   $0x0
  801c89:	52                   	push   %edx
  801c8a:	ff 75 0c             	pushl  0xc(%ebp)
  801c8d:	50                   	push   %eax
  801c8e:	6a 00                	push   $0x0
  801c90:	e8 b2 ff ff ff       	call   801c47 <syscall>
  801c95:	83 c4 18             	add    $0x18,%esp
}
  801c98:	90                   	nop
  801c99:	c9                   	leave  
  801c9a:	c3                   	ret    

00801c9b <sys_cgetc>:

int
sys_cgetc(void)
{
  801c9b:	55                   	push   %ebp
  801c9c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  801c9e:	6a 00                	push   $0x0
  801ca0:	6a 00                	push   $0x0
  801ca2:	6a 00                	push   $0x0
  801ca4:	6a 00                	push   $0x0
  801ca6:	6a 00                	push   $0x0
  801ca8:	6a 01                	push   $0x1
  801caa:	e8 98 ff ff ff       	call   801c47 <syscall>
  801caf:	83 c4 18             	add    $0x18,%esp
}
  801cb2:	c9                   	leave  
  801cb3:	c3                   	ret    

00801cb4 <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  801cb4:	55                   	push   %ebp
  801cb5:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  801cb7:	8b 55 0c             	mov    0xc(%ebp),%edx
  801cba:	8b 45 08             	mov    0x8(%ebp),%eax
  801cbd:	6a 00                	push   $0x0
  801cbf:	6a 00                	push   $0x0
  801cc1:	6a 00                	push   $0x0
  801cc3:	52                   	push   %edx
  801cc4:	50                   	push   %eax
  801cc5:	6a 05                	push   $0x5
  801cc7:	e8 7b ff ff ff       	call   801c47 <syscall>
  801ccc:	83 c4 18             	add    $0x18,%esp
}
  801ccf:	c9                   	leave  
  801cd0:	c3                   	ret    

00801cd1 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  801cd1:	55                   	push   %ebp
  801cd2:	89 e5                	mov    %esp,%ebp
  801cd4:	56                   	push   %esi
  801cd5:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  801cd6:	8b 75 18             	mov    0x18(%ebp),%esi
  801cd9:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801cdc:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801cdf:	8b 55 0c             	mov    0xc(%ebp),%edx
  801ce2:	8b 45 08             	mov    0x8(%ebp),%eax
  801ce5:	56                   	push   %esi
  801ce6:	53                   	push   %ebx
  801ce7:	51                   	push   %ecx
  801ce8:	52                   	push   %edx
  801ce9:	50                   	push   %eax
  801cea:	6a 06                	push   $0x6
  801cec:	e8 56 ff ff ff       	call   801c47 <syscall>
  801cf1:	83 c4 18             	add    $0x18,%esp
}
  801cf4:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801cf7:	5b                   	pop    %ebx
  801cf8:	5e                   	pop    %esi
  801cf9:	5d                   	pop    %ebp
  801cfa:	c3                   	ret    

00801cfb <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  801cfb:	55                   	push   %ebp
  801cfc:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  801cfe:	8b 55 0c             	mov    0xc(%ebp),%edx
  801d01:	8b 45 08             	mov    0x8(%ebp),%eax
  801d04:	6a 00                	push   $0x0
  801d06:	6a 00                	push   $0x0
  801d08:	6a 00                	push   $0x0
  801d0a:	52                   	push   %edx
  801d0b:	50                   	push   %eax
  801d0c:	6a 07                	push   $0x7
  801d0e:	e8 34 ff ff ff       	call   801c47 <syscall>
  801d13:	83 c4 18             	add    $0x18,%esp
}
  801d16:	c9                   	leave  
  801d17:	c3                   	ret    

00801d18 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  801d18:	55                   	push   %ebp
  801d19:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  801d1b:	6a 00                	push   $0x0
  801d1d:	6a 00                	push   $0x0
  801d1f:	6a 00                	push   $0x0
  801d21:	ff 75 0c             	pushl  0xc(%ebp)
  801d24:	ff 75 08             	pushl  0x8(%ebp)
  801d27:	6a 08                	push   $0x8
  801d29:	e8 19 ff ff ff       	call   801c47 <syscall>
  801d2e:	83 c4 18             	add    $0x18,%esp
}
  801d31:	c9                   	leave  
  801d32:	c3                   	ret    

00801d33 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  801d33:	55                   	push   %ebp
  801d34:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  801d36:	6a 00                	push   $0x0
  801d38:	6a 00                	push   $0x0
  801d3a:	6a 00                	push   $0x0
  801d3c:	6a 00                	push   $0x0
  801d3e:	6a 00                	push   $0x0
  801d40:	6a 09                	push   $0x9
  801d42:	e8 00 ff ff ff       	call   801c47 <syscall>
  801d47:	83 c4 18             	add    $0x18,%esp
}
  801d4a:	c9                   	leave  
  801d4b:	c3                   	ret    

00801d4c <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  801d4c:	55                   	push   %ebp
  801d4d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  801d4f:	6a 00                	push   $0x0
  801d51:	6a 00                	push   $0x0
  801d53:	6a 00                	push   $0x0
  801d55:	6a 00                	push   $0x0
  801d57:	6a 00                	push   $0x0
  801d59:	6a 0a                	push   $0xa
  801d5b:	e8 e7 fe ff ff       	call   801c47 <syscall>
  801d60:	83 c4 18             	add    $0x18,%esp
}
  801d63:	c9                   	leave  
  801d64:	c3                   	ret    

00801d65 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  801d65:	55                   	push   %ebp
  801d66:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  801d68:	6a 00                	push   $0x0
  801d6a:	6a 00                	push   $0x0
  801d6c:	6a 00                	push   $0x0
  801d6e:	6a 00                	push   $0x0
  801d70:	6a 00                	push   $0x0
  801d72:	6a 0b                	push   $0xb
  801d74:	e8 ce fe ff ff       	call   801c47 <syscall>
  801d79:	83 c4 18             	add    $0x18,%esp
}
  801d7c:	c9                   	leave  
  801d7d:	c3                   	ret    

00801d7e <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  801d7e:	55                   	push   %ebp
  801d7f:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  801d81:	6a 00                	push   $0x0
  801d83:	6a 00                	push   $0x0
  801d85:	6a 00                	push   $0x0
  801d87:	ff 75 0c             	pushl  0xc(%ebp)
  801d8a:	ff 75 08             	pushl  0x8(%ebp)
  801d8d:	6a 0f                	push   $0xf
  801d8f:	e8 b3 fe ff ff       	call   801c47 <syscall>
  801d94:	83 c4 18             	add    $0x18,%esp
	return;
  801d97:	90                   	nop
}
  801d98:	c9                   	leave  
  801d99:	c3                   	ret    

00801d9a <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  801d9a:	55                   	push   %ebp
  801d9b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  801d9d:	6a 00                	push   $0x0
  801d9f:	6a 00                	push   $0x0
  801da1:	6a 00                	push   $0x0
  801da3:	ff 75 0c             	pushl  0xc(%ebp)
  801da6:	ff 75 08             	pushl  0x8(%ebp)
  801da9:	6a 10                	push   $0x10
  801dab:	e8 97 fe ff ff       	call   801c47 <syscall>
  801db0:	83 c4 18             	add    $0x18,%esp
	return ;
  801db3:	90                   	nop
}
  801db4:	c9                   	leave  
  801db5:	c3                   	ret    

00801db6 <sys_allocate_chunk>:

void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  801db6:	55                   	push   %ebp
  801db7:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  801db9:	6a 00                	push   $0x0
  801dbb:	6a 00                	push   $0x0
  801dbd:	ff 75 10             	pushl  0x10(%ebp)
  801dc0:	ff 75 0c             	pushl  0xc(%ebp)
  801dc3:	ff 75 08             	pushl  0x8(%ebp)
  801dc6:	6a 11                	push   $0x11
  801dc8:	e8 7a fe ff ff       	call   801c47 <syscall>
  801dcd:	83 c4 18             	add    $0x18,%esp
	return ;
  801dd0:	90                   	nop
}
  801dd1:	c9                   	leave  
  801dd2:	c3                   	ret    

00801dd3 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  801dd3:	55                   	push   %ebp
  801dd4:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  801dd6:	6a 00                	push   $0x0
  801dd8:	6a 00                	push   $0x0
  801dda:	6a 00                	push   $0x0
  801ddc:	6a 00                	push   $0x0
  801dde:	6a 00                	push   $0x0
  801de0:	6a 0c                	push   $0xc
  801de2:	e8 60 fe ff ff       	call   801c47 <syscall>
  801de7:	83 c4 18             	add    $0x18,%esp
}
  801dea:	c9                   	leave  
  801deb:	c3                   	ret    

00801dec <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  801dec:	55                   	push   %ebp
  801ded:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  801def:	6a 00                	push   $0x0
  801df1:	6a 00                	push   $0x0
  801df3:	6a 00                	push   $0x0
  801df5:	6a 00                	push   $0x0
  801df7:	ff 75 08             	pushl  0x8(%ebp)
  801dfa:	6a 0d                	push   $0xd
  801dfc:	e8 46 fe ff ff       	call   801c47 <syscall>
  801e01:	83 c4 18             	add    $0x18,%esp
}
  801e04:	c9                   	leave  
  801e05:	c3                   	ret    

00801e06 <sys_scarce_memory>:

void sys_scarce_memory()
{
  801e06:	55                   	push   %ebp
  801e07:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  801e09:	6a 00                	push   $0x0
  801e0b:	6a 00                	push   $0x0
  801e0d:	6a 00                	push   $0x0
  801e0f:	6a 00                	push   $0x0
  801e11:	6a 00                	push   $0x0
  801e13:	6a 0e                	push   $0xe
  801e15:	e8 2d fe ff ff       	call   801c47 <syscall>
  801e1a:	83 c4 18             	add    $0x18,%esp
}
  801e1d:	90                   	nop
  801e1e:	c9                   	leave  
  801e1f:	c3                   	ret    

00801e20 <sys_disable_interrupt>:

//NEW !! 2012...
void
sys_disable_interrupt()
{
  801e20:	55                   	push   %ebp
  801e21:	89 e5                	mov    %esp,%ebp
	syscall(SYS_disableINTR,0, 0, 0, 0, 0);
  801e23:	6a 00                	push   $0x0
  801e25:	6a 00                	push   $0x0
  801e27:	6a 00                	push   $0x0
  801e29:	6a 00                	push   $0x0
  801e2b:	6a 00                	push   $0x0
  801e2d:	6a 13                	push   $0x13
  801e2f:	e8 13 fe ff ff       	call   801c47 <syscall>
  801e34:	83 c4 18             	add    $0x18,%esp
}
  801e37:	90                   	nop
  801e38:	c9                   	leave  
  801e39:	c3                   	ret    

00801e3a <sys_enable_interrupt>:


void
sys_enable_interrupt()
{
  801e3a:	55                   	push   %ebp
  801e3b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enableINTR,0, 0, 0, 0, 0);
  801e3d:	6a 00                	push   $0x0
  801e3f:	6a 00                	push   $0x0
  801e41:	6a 00                	push   $0x0
  801e43:	6a 00                	push   $0x0
  801e45:	6a 00                	push   $0x0
  801e47:	6a 14                	push   $0x14
  801e49:	e8 f9 fd ff ff       	call   801c47 <syscall>
  801e4e:	83 c4 18             	add    $0x18,%esp
}
  801e51:	90                   	nop
  801e52:	c9                   	leave  
  801e53:	c3                   	ret    

00801e54 <sys_cputc>:


void
sys_cputc(const char c)
{
  801e54:	55                   	push   %ebp
  801e55:	89 e5                	mov    %esp,%ebp
  801e57:	83 ec 04             	sub    $0x4,%esp
  801e5a:	8b 45 08             	mov    0x8(%ebp),%eax
  801e5d:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  801e60:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801e64:	6a 00                	push   $0x0
  801e66:	6a 00                	push   $0x0
  801e68:	6a 00                	push   $0x0
  801e6a:	6a 00                	push   $0x0
  801e6c:	50                   	push   %eax
  801e6d:	6a 15                	push   $0x15
  801e6f:	e8 d3 fd ff ff       	call   801c47 <syscall>
  801e74:	83 c4 18             	add    $0x18,%esp
}
  801e77:	90                   	nop
  801e78:	c9                   	leave  
  801e79:	c3                   	ret    

00801e7a <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  801e7a:	55                   	push   %ebp
  801e7b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  801e7d:	6a 00                	push   $0x0
  801e7f:	6a 00                	push   $0x0
  801e81:	6a 00                	push   $0x0
  801e83:	6a 00                	push   $0x0
  801e85:	6a 00                	push   $0x0
  801e87:	6a 16                	push   $0x16
  801e89:	e8 b9 fd ff ff       	call   801c47 <syscall>
  801e8e:	83 c4 18             	add    $0x18,%esp
}
  801e91:	90                   	nop
  801e92:	c9                   	leave  
  801e93:	c3                   	ret    

00801e94 <sys_createSemaphore>:

int
sys_createSemaphore(char* semaphoreName, uint32 initialValue)
{
  801e94:	55                   	push   %ebp
  801e95:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_semaphore,(uint32)semaphoreName, (uint32)initialValue, 0, 0, 0);
  801e97:	8b 45 08             	mov    0x8(%ebp),%eax
  801e9a:	6a 00                	push   $0x0
  801e9c:	6a 00                	push   $0x0
  801e9e:	6a 00                	push   $0x0
  801ea0:	ff 75 0c             	pushl  0xc(%ebp)
  801ea3:	50                   	push   %eax
  801ea4:	6a 17                	push   $0x17
  801ea6:	e8 9c fd ff ff       	call   801c47 <syscall>
  801eab:	83 c4 18             	add    $0x18,%esp
}
  801eae:	c9                   	leave  
  801eaf:	c3                   	ret    

00801eb0 <sys_getSemaphoreValue>:

int
sys_getSemaphoreValue(int32 ownerEnvID, char* semaphoreName)
{
  801eb0:	55                   	push   %ebp
  801eb1:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_semaphore_value,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801eb3:	8b 55 0c             	mov    0xc(%ebp),%edx
  801eb6:	8b 45 08             	mov    0x8(%ebp),%eax
  801eb9:	6a 00                	push   $0x0
  801ebb:	6a 00                	push   $0x0
  801ebd:	6a 00                	push   $0x0
  801ebf:	52                   	push   %edx
  801ec0:	50                   	push   %eax
  801ec1:	6a 1a                	push   $0x1a
  801ec3:	e8 7f fd ff ff       	call   801c47 <syscall>
  801ec8:	83 c4 18             	add    $0x18,%esp
}
  801ecb:	c9                   	leave  
  801ecc:	c3                   	ret    

00801ecd <sys_waitSemaphore>:

void
sys_waitSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801ecd:	55                   	push   %ebp
  801ece:	89 e5                	mov    %esp,%ebp
	syscall(SYS_wait_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801ed0:	8b 55 0c             	mov    0xc(%ebp),%edx
  801ed3:	8b 45 08             	mov    0x8(%ebp),%eax
  801ed6:	6a 00                	push   $0x0
  801ed8:	6a 00                	push   $0x0
  801eda:	6a 00                	push   $0x0
  801edc:	52                   	push   %edx
  801edd:	50                   	push   %eax
  801ede:	6a 18                	push   $0x18
  801ee0:	e8 62 fd ff ff       	call   801c47 <syscall>
  801ee5:	83 c4 18             	add    $0x18,%esp
}
  801ee8:	90                   	nop
  801ee9:	c9                   	leave  
  801eea:	c3                   	ret    

00801eeb <sys_signalSemaphore>:

void
sys_signalSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801eeb:	55                   	push   %ebp
  801eec:	89 e5                	mov    %esp,%ebp
	syscall(SYS_signal_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801eee:	8b 55 0c             	mov    0xc(%ebp),%edx
  801ef1:	8b 45 08             	mov    0x8(%ebp),%eax
  801ef4:	6a 00                	push   $0x0
  801ef6:	6a 00                	push   $0x0
  801ef8:	6a 00                	push   $0x0
  801efa:	52                   	push   %edx
  801efb:	50                   	push   %eax
  801efc:	6a 19                	push   $0x19
  801efe:	e8 44 fd ff ff       	call   801c47 <syscall>
  801f03:	83 c4 18             	add    $0x18,%esp
}
  801f06:	90                   	nop
  801f07:	c9                   	leave  
  801f08:	c3                   	ret    

00801f09 <sys_createSharedObject>:

int
sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  801f09:	55                   	push   %ebp
  801f0a:	89 e5                	mov    %esp,%ebp
  801f0c:	83 ec 04             	sub    $0x4,%esp
  801f0f:	8b 45 10             	mov    0x10(%ebp),%eax
  801f12:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  801f15:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801f18:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801f1c:	8b 45 08             	mov    0x8(%ebp),%eax
  801f1f:	6a 00                	push   $0x0
  801f21:	51                   	push   %ecx
  801f22:	52                   	push   %edx
  801f23:	ff 75 0c             	pushl  0xc(%ebp)
  801f26:	50                   	push   %eax
  801f27:	6a 1b                	push   $0x1b
  801f29:	e8 19 fd ff ff       	call   801c47 <syscall>
  801f2e:	83 c4 18             	add    $0x18,%esp
}
  801f31:	c9                   	leave  
  801f32:	c3                   	ret    

00801f33 <sys_getSizeOfSharedObject>:

//2017:
int
sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  801f33:	55                   	push   %ebp
  801f34:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  801f36:	8b 55 0c             	mov    0xc(%ebp),%edx
  801f39:	8b 45 08             	mov    0x8(%ebp),%eax
  801f3c:	6a 00                	push   $0x0
  801f3e:	6a 00                	push   $0x0
  801f40:	6a 00                	push   $0x0
  801f42:	52                   	push   %edx
  801f43:	50                   	push   %eax
  801f44:	6a 1c                	push   $0x1c
  801f46:	e8 fc fc ff ff       	call   801c47 <syscall>
  801f4b:	83 c4 18             	add    $0x18,%esp
}
  801f4e:	c9                   	leave  
  801f4f:	c3                   	ret    

00801f50 <sys_getSharedObject>:
//==========

int
sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  801f50:	55                   	push   %ebp
  801f51:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  801f53:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801f56:	8b 55 0c             	mov    0xc(%ebp),%edx
  801f59:	8b 45 08             	mov    0x8(%ebp),%eax
  801f5c:	6a 00                	push   $0x0
  801f5e:	6a 00                	push   $0x0
  801f60:	51                   	push   %ecx
  801f61:	52                   	push   %edx
  801f62:	50                   	push   %eax
  801f63:	6a 1d                	push   $0x1d
  801f65:	e8 dd fc ff ff       	call   801c47 <syscall>
  801f6a:	83 c4 18             	add    $0x18,%esp
}
  801f6d:	c9                   	leave  
  801f6e:	c3                   	ret    

00801f6f <sys_freeSharedObject>:

int
sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  801f6f:	55                   	push   %ebp
  801f70:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  801f72:	8b 55 0c             	mov    0xc(%ebp),%edx
  801f75:	8b 45 08             	mov    0x8(%ebp),%eax
  801f78:	6a 00                	push   $0x0
  801f7a:	6a 00                	push   $0x0
  801f7c:	6a 00                	push   $0x0
  801f7e:	52                   	push   %edx
  801f7f:	50                   	push   %eax
  801f80:	6a 1e                	push   $0x1e
  801f82:	e8 c0 fc ff ff       	call   801c47 <syscall>
  801f87:	83 c4 18             	add    $0x18,%esp
}
  801f8a:	c9                   	leave  
  801f8b:	c3                   	ret    

00801f8c <sys_getMaxShares>:

uint32 	sys_getMaxShares()
{
  801f8c:	55                   	push   %ebp
  801f8d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_max_shares,0, 0, 0, 0, 0);
  801f8f:	6a 00                	push   $0x0
  801f91:	6a 00                	push   $0x0
  801f93:	6a 00                	push   $0x0
  801f95:	6a 00                	push   $0x0
  801f97:	6a 00                	push   $0x0
  801f99:	6a 1f                	push   $0x1f
  801f9b:	e8 a7 fc ff ff       	call   801c47 <syscall>
  801fa0:	83 c4 18             	add    $0x18,%esp
}
  801fa3:	c9                   	leave  
  801fa4:	c3                   	ret    

00801fa5 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  801fa5:	55                   	push   %ebp
  801fa6:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  801fa8:	8b 45 08             	mov    0x8(%ebp),%eax
  801fab:	6a 00                	push   $0x0
  801fad:	ff 75 14             	pushl  0x14(%ebp)
  801fb0:	ff 75 10             	pushl  0x10(%ebp)
  801fb3:	ff 75 0c             	pushl  0xc(%ebp)
  801fb6:	50                   	push   %eax
  801fb7:	6a 20                	push   $0x20
  801fb9:	e8 89 fc ff ff       	call   801c47 <syscall>
  801fbe:	83 c4 18             	add    $0x18,%esp
}
  801fc1:	c9                   	leave  
  801fc2:	c3                   	ret    

00801fc3 <sys_run_env>:

void
sys_run_env(int32 envId)
{
  801fc3:	55                   	push   %ebp
  801fc4:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  801fc6:	8b 45 08             	mov    0x8(%ebp),%eax
  801fc9:	6a 00                	push   $0x0
  801fcb:	6a 00                	push   $0x0
  801fcd:	6a 00                	push   $0x0
  801fcf:	6a 00                	push   $0x0
  801fd1:	50                   	push   %eax
  801fd2:	6a 21                	push   $0x21
  801fd4:	e8 6e fc ff ff       	call   801c47 <syscall>
  801fd9:	83 c4 18             	add    $0x18,%esp
}
  801fdc:	90                   	nop
  801fdd:	c9                   	leave  
  801fde:	c3                   	ret    

00801fdf <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  801fdf:	55                   	push   %ebp
  801fe0:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  801fe2:	8b 45 08             	mov    0x8(%ebp),%eax
  801fe5:	6a 00                	push   $0x0
  801fe7:	6a 00                	push   $0x0
  801fe9:	6a 00                	push   $0x0
  801feb:	6a 00                	push   $0x0
  801fed:	50                   	push   %eax
  801fee:	6a 22                	push   $0x22
  801ff0:	e8 52 fc ff ff       	call   801c47 <syscall>
  801ff5:	83 c4 18             	add    $0x18,%esp
}
  801ff8:	c9                   	leave  
  801ff9:	c3                   	ret    

00801ffa <sys_getenvid>:

int32 sys_getenvid(void)
{
  801ffa:	55                   	push   %ebp
  801ffb:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  801ffd:	6a 00                	push   $0x0
  801fff:	6a 00                	push   $0x0
  802001:	6a 00                	push   $0x0
  802003:	6a 00                	push   $0x0
  802005:	6a 00                	push   $0x0
  802007:	6a 02                	push   $0x2
  802009:	e8 39 fc ff ff       	call   801c47 <syscall>
  80200e:	83 c4 18             	add    $0x18,%esp
}
  802011:	c9                   	leave  
  802012:	c3                   	ret    

00802013 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  802013:	55                   	push   %ebp
  802014:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  802016:	6a 00                	push   $0x0
  802018:	6a 00                	push   $0x0
  80201a:	6a 00                	push   $0x0
  80201c:	6a 00                	push   $0x0
  80201e:	6a 00                	push   $0x0
  802020:	6a 03                	push   $0x3
  802022:	e8 20 fc ff ff       	call   801c47 <syscall>
  802027:	83 c4 18             	add    $0x18,%esp
}
  80202a:	c9                   	leave  
  80202b:	c3                   	ret    

0080202c <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  80202c:	55                   	push   %ebp
  80202d:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  80202f:	6a 00                	push   $0x0
  802031:	6a 00                	push   $0x0
  802033:	6a 00                	push   $0x0
  802035:	6a 00                	push   $0x0
  802037:	6a 00                	push   $0x0
  802039:	6a 04                	push   $0x4
  80203b:	e8 07 fc ff ff       	call   801c47 <syscall>
  802040:	83 c4 18             	add    $0x18,%esp
}
  802043:	c9                   	leave  
  802044:	c3                   	ret    

00802045 <sys_exit_env>:


void sys_exit_env(void)
{
  802045:	55                   	push   %ebp
  802046:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  802048:	6a 00                	push   $0x0
  80204a:	6a 00                	push   $0x0
  80204c:	6a 00                	push   $0x0
  80204e:	6a 00                	push   $0x0
  802050:	6a 00                	push   $0x0
  802052:	6a 23                	push   $0x23
  802054:	e8 ee fb ff ff       	call   801c47 <syscall>
  802059:	83 c4 18             	add    $0x18,%esp
}
  80205c:	90                   	nop
  80205d:	c9                   	leave  
  80205e:	c3                   	ret    

0080205f <sys_get_virtual_time>:


struct uint64
sys_get_virtual_time()
{
  80205f:	55                   	push   %ebp
  802060:	89 e5                	mov    %esp,%ebp
  802062:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  802065:	8d 45 f8             	lea    -0x8(%ebp),%eax
  802068:	8d 50 04             	lea    0x4(%eax),%edx
  80206b:	8d 45 f8             	lea    -0x8(%ebp),%eax
  80206e:	6a 00                	push   $0x0
  802070:	6a 00                	push   $0x0
  802072:	6a 00                	push   $0x0
  802074:	52                   	push   %edx
  802075:	50                   	push   %eax
  802076:	6a 24                	push   $0x24
  802078:	e8 ca fb ff ff       	call   801c47 <syscall>
  80207d:	83 c4 18             	add    $0x18,%esp
	return result;
  802080:	8b 4d 08             	mov    0x8(%ebp),%ecx
  802083:	8b 45 f8             	mov    -0x8(%ebp),%eax
  802086:	8b 55 fc             	mov    -0x4(%ebp),%edx
  802089:	89 01                	mov    %eax,(%ecx)
  80208b:	89 51 04             	mov    %edx,0x4(%ecx)
}
  80208e:	8b 45 08             	mov    0x8(%ebp),%eax
  802091:	c9                   	leave  
  802092:	c2 04 00             	ret    $0x4

00802095 <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  802095:	55                   	push   %ebp
  802096:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  802098:	6a 00                	push   $0x0
  80209a:	6a 00                	push   $0x0
  80209c:	ff 75 10             	pushl  0x10(%ebp)
  80209f:	ff 75 0c             	pushl  0xc(%ebp)
  8020a2:	ff 75 08             	pushl  0x8(%ebp)
  8020a5:	6a 12                	push   $0x12
  8020a7:	e8 9b fb ff ff       	call   801c47 <syscall>
  8020ac:	83 c4 18             	add    $0x18,%esp
	return ;
  8020af:	90                   	nop
}
  8020b0:	c9                   	leave  
  8020b1:	c3                   	ret    

008020b2 <sys_rcr2>:
uint32 sys_rcr2()
{
  8020b2:	55                   	push   %ebp
  8020b3:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  8020b5:	6a 00                	push   $0x0
  8020b7:	6a 00                	push   $0x0
  8020b9:	6a 00                	push   $0x0
  8020bb:	6a 00                	push   $0x0
  8020bd:	6a 00                	push   $0x0
  8020bf:	6a 25                	push   $0x25
  8020c1:	e8 81 fb ff ff       	call   801c47 <syscall>
  8020c6:	83 c4 18             	add    $0x18,%esp
}
  8020c9:	c9                   	leave  
  8020ca:	c3                   	ret    

008020cb <sys_bypassPageFault>:
void sys_bypassPageFault(uint8 instrLength)
{
  8020cb:	55                   	push   %ebp
  8020cc:	89 e5                	mov    %esp,%ebp
  8020ce:	83 ec 04             	sub    $0x4,%esp
  8020d1:	8b 45 08             	mov    0x8(%ebp),%eax
  8020d4:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  8020d7:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  8020db:	6a 00                	push   $0x0
  8020dd:	6a 00                	push   $0x0
  8020df:	6a 00                	push   $0x0
  8020e1:	6a 00                	push   $0x0
  8020e3:	50                   	push   %eax
  8020e4:	6a 26                	push   $0x26
  8020e6:	e8 5c fb ff ff       	call   801c47 <syscall>
  8020eb:	83 c4 18             	add    $0x18,%esp
	return ;
  8020ee:	90                   	nop
}
  8020ef:	c9                   	leave  
  8020f0:	c3                   	ret    

008020f1 <rsttst>:
void rsttst()
{
  8020f1:	55                   	push   %ebp
  8020f2:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  8020f4:	6a 00                	push   $0x0
  8020f6:	6a 00                	push   $0x0
  8020f8:	6a 00                	push   $0x0
  8020fa:	6a 00                	push   $0x0
  8020fc:	6a 00                	push   $0x0
  8020fe:	6a 28                	push   $0x28
  802100:	e8 42 fb ff ff       	call   801c47 <syscall>
  802105:	83 c4 18             	add    $0x18,%esp
	return ;
  802108:	90                   	nop
}
  802109:	c9                   	leave  
  80210a:	c3                   	ret    

0080210b <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  80210b:	55                   	push   %ebp
  80210c:	89 e5                	mov    %esp,%ebp
  80210e:	83 ec 04             	sub    $0x4,%esp
  802111:	8b 45 14             	mov    0x14(%ebp),%eax
  802114:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  802117:	8b 55 18             	mov    0x18(%ebp),%edx
  80211a:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  80211e:	52                   	push   %edx
  80211f:	50                   	push   %eax
  802120:	ff 75 10             	pushl  0x10(%ebp)
  802123:	ff 75 0c             	pushl  0xc(%ebp)
  802126:	ff 75 08             	pushl  0x8(%ebp)
  802129:	6a 27                	push   $0x27
  80212b:	e8 17 fb ff ff       	call   801c47 <syscall>
  802130:	83 c4 18             	add    $0x18,%esp
	return ;
  802133:	90                   	nop
}
  802134:	c9                   	leave  
  802135:	c3                   	ret    

00802136 <chktst>:
void chktst(uint32 n)
{
  802136:	55                   	push   %ebp
  802137:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  802139:	6a 00                	push   $0x0
  80213b:	6a 00                	push   $0x0
  80213d:	6a 00                	push   $0x0
  80213f:	6a 00                	push   $0x0
  802141:	ff 75 08             	pushl  0x8(%ebp)
  802144:	6a 29                	push   $0x29
  802146:	e8 fc fa ff ff       	call   801c47 <syscall>
  80214b:	83 c4 18             	add    $0x18,%esp
	return ;
  80214e:	90                   	nop
}
  80214f:	c9                   	leave  
  802150:	c3                   	ret    

00802151 <inctst>:

void inctst()
{
  802151:	55                   	push   %ebp
  802152:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  802154:	6a 00                	push   $0x0
  802156:	6a 00                	push   $0x0
  802158:	6a 00                	push   $0x0
  80215a:	6a 00                	push   $0x0
  80215c:	6a 00                	push   $0x0
  80215e:	6a 2a                	push   $0x2a
  802160:	e8 e2 fa ff ff       	call   801c47 <syscall>
  802165:	83 c4 18             	add    $0x18,%esp
	return ;
  802168:	90                   	nop
}
  802169:	c9                   	leave  
  80216a:	c3                   	ret    

0080216b <gettst>:
uint32 gettst()
{
  80216b:	55                   	push   %ebp
  80216c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  80216e:	6a 00                	push   $0x0
  802170:	6a 00                	push   $0x0
  802172:	6a 00                	push   $0x0
  802174:	6a 00                	push   $0x0
  802176:	6a 00                	push   $0x0
  802178:	6a 2b                	push   $0x2b
  80217a:	e8 c8 fa ff ff       	call   801c47 <syscall>
  80217f:	83 c4 18             	add    $0x18,%esp
}
  802182:	c9                   	leave  
  802183:	c3                   	ret    

00802184 <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  802184:	55                   	push   %ebp
  802185:	89 e5                	mov    %esp,%ebp
  802187:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  80218a:	6a 00                	push   $0x0
  80218c:	6a 00                	push   $0x0
  80218e:	6a 00                	push   $0x0
  802190:	6a 00                	push   $0x0
  802192:	6a 00                	push   $0x0
  802194:	6a 2c                	push   $0x2c
  802196:	e8 ac fa ff ff       	call   801c47 <syscall>
  80219b:	83 c4 18             	add    $0x18,%esp
  80219e:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  8021a1:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  8021a5:	75 07                	jne    8021ae <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  8021a7:	b8 01 00 00 00       	mov    $0x1,%eax
  8021ac:	eb 05                	jmp    8021b3 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  8021ae:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8021b3:	c9                   	leave  
  8021b4:	c3                   	ret    

008021b5 <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  8021b5:	55                   	push   %ebp
  8021b6:	89 e5                	mov    %esp,%ebp
  8021b8:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8021bb:	6a 00                	push   $0x0
  8021bd:	6a 00                	push   $0x0
  8021bf:	6a 00                	push   $0x0
  8021c1:	6a 00                	push   $0x0
  8021c3:	6a 00                	push   $0x0
  8021c5:	6a 2c                	push   $0x2c
  8021c7:	e8 7b fa ff ff       	call   801c47 <syscall>
  8021cc:	83 c4 18             	add    $0x18,%esp
  8021cf:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  8021d2:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  8021d6:	75 07                	jne    8021df <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  8021d8:	b8 01 00 00 00       	mov    $0x1,%eax
  8021dd:	eb 05                	jmp    8021e4 <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  8021df:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8021e4:	c9                   	leave  
  8021e5:	c3                   	ret    

008021e6 <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  8021e6:	55                   	push   %ebp
  8021e7:	89 e5                	mov    %esp,%ebp
  8021e9:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8021ec:	6a 00                	push   $0x0
  8021ee:	6a 00                	push   $0x0
  8021f0:	6a 00                	push   $0x0
  8021f2:	6a 00                	push   $0x0
  8021f4:	6a 00                	push   $0x0
  8021f6:	6a 2c                	push   $0x2c
  8021f8:	e8 4a fa ff ff       	call   801c47 <syscall>
  8021fd:	83 c4 18             	add    $0x18,%esp
  802200:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  802203:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  802207:	75 07                	jne    802210 <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  802209:	b8 01 00 00 00       	mov    $0x1,%eax
  80220e:	eb 05                	jmp    802215 <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  802210:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802215:	c9                   	leave  
  802216:	c3                   	ret    

00802217 <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  802217:	55                   	push   %ebp
  802218:	89 e5                	mov    %esp,%ebp
  80221a:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  80221d:	6a 00                	push   $0x0
  80221f:	6a 00                	push   $0x0
  802221:	6a 00                	push   $0x0
  802223:	6a 00                	push   $0x0
  802225:	6a 00                	push   $0x0
  802227:	6a 2c                	push   $0x2c
  802229:	e8 19 fa ff ff       	call   801c47 <syscall>
  80222e:	83 c4 18             	add    $0x18,%esp
  802231:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  802234:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  802238:	75 07                	jne    802241 <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  80223a:	b8 01 00 00 00       	mov    $0x1,%eax
  80223f:	eb 05                	jmp    802246 <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  802241:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802246:	c9                   	leave  
  802247:	c3                   	ret    

00802248 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  802248:	55                   	push   %ebp
  802249:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  80224b:	6a 00                	push   $0x0
  80224d:	6a 00                	push   $0x0
  80224f:	6a 00                	push   $0x0
  802251:	6a 00                	push   $0x0
  802253:	ff 75 08             	pushl  0x8(%ebp)
  802256:	6a 2d                	push   $0x2d
  802258:	e8 ea f9 ff ff       	call   801c47 <syscall>
  80225d:	83 c4 18             	add    $0x18,%esp
	return ;
  802260:	90                   	nop
}
  802261:	c9                   	leave  
  802262:	c3                   	ret    

00802263 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  802263:	55                   	push   %ebp
  802264:	89 e5                	mov    %esp,%ebp
  802266:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  802267:	8b 5d 14             	mov    0x14(%ebp),%ebx
  80226a:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80226d:	8b 55 0c             	mov    0xc(%ebp),%edx
  802270:	8b 45 08             	mov    0x8(%ebp),%eax
  802273:	6a 00                	push   $0x0
  802275:	53                   	push   %ebx
  802276:	51                   	push   %ecx
  802277:	52                   	push   %edx
  802278:	50                   	push   %eax
  802279:	6a 2e                	push   $0x2e
  80227b:	e8 c7 f9 ff ff       	call   801c47 <syscall>
  802280:	83 c4 18             	add    $0x18,%esp
}
  802283:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802286:	c9                   	leave  
  802287:	c3                   	ret    

00802288 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  802288:	55                   	push   %ebp
  802289:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  80228b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80228e:	8b 45 08             	mov    0x8(%ebp),%eax
  802291:	6a 00                	push   $0x0
  802293:	6a 00                	push   $0x0
  802295:	6a 00                	push   $0x0
  802297:	52                   	push   %edx
  802298:	50                   	push   %eax
  802299:	6a 2f                	push   $0x2f
  80229b:	e8 a7 f9 ff ff       	call   801c47 <syscall>
  8022a0:	83 c4 18             	add    $0x18,%esp
}
  8022a3:	c9                   	leave  
  8022a4:	c3                   	ret    

008022a5 <print_mem_block_lists>:
//===========================
// PRINT MEM BLOCK LISTS:
//===========================

void print_mem_block_lists()
{
  8022a5:	55                   	push   %ebp
  8022a6:	89 e5                	mov    %esp,%ebp
  8022a8:	83 ec 18             	sub    $0x18,%esp
	cprintf("\n=========================================\n");
  8022ab:	83 ec 0c             	sub    $0xc,%esp
  8022ae:	68 c0 3c 80 00       	push   $0x803cc0
  8022b3:	e8 dd e6 ff ff       	call   800995 <cprintf>
  8022b8:	83 c4 10             	add    $0x10,%esp
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
  8022bb:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nFreeMemBlocksList:\n");
  8022c2:	83 ec 0c             	sub    $0xc,%esp
  8022c5:	68 ec 3c 80 00       	push   $0x803cec
  8022ca:	e8 c6 e6 ff ff       	call   800995 <cprintf>
  8022cf:	83 c4 10             	add    $0x10,%esp
	uint8 sorted = 1 ;
  8022d2:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &FreeMemBlocksList)
  8022d6:	a1 38 41 80 00       	mov    0x804138,%eax
  8022db:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8022de:	eb 56                	jmp    802336 <print_mem_block_lists+0x91>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  8022e0:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8022e4:	74 1c                	je     802302 <print_mem_block_lists+0x5d>
  8022e6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022e9:	8b 50 08             	mov    0x8(%eax),%edx
  8022ec:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8022ef:	8b 48 08             	mov    0x8(%eax),%ecx
  8022f2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8022f5:	8b 40 0c             	mov    0xc(%eax),%eax
  8022f8:	01 c8                	add    %ecx,%eax
  8022fa:	39 c2                	cmp    %eax,%edx
  8022fc:	73 04                	jae    802302 <print_mem_block_lists+0x5d>
			sorted = 0 ;
  8022fe:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  802302:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802305:	8b 50 08             	mov    0x8(%eax),%edx
  802308:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80230b:	8b 40 0c             	mov    0xc(%eax),%eax
  80230e:	01 c2                	add    %eax,%edx
  802310:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802313:	8b 40 08             	mov    0x8(%eax),%eax
  802316:	83 ec 04             	sub    $0x4,%esp
  802319:	52                   	push   %edx
  80231a:	50                   	push   %eax
  80231b:	68 01 3d 80 00       	push   $0x803d01
  802320:	e8 70 e6 ff ff       	call   800995 <cprintf>
  802325:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  802328:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80232b:	89 45 f0             	mov    %eax,-0x10(%ebp)
	cprintf("\n=========================================\n");
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
	cprintf("\nFreeMemBlocksList:\n");
	uint8 sorted = 1 ;
	LIST_FOREACH(blk, &FreeMemBlocksList)
  80232e:	a1 40 41 80 00       	mov    0x804140,%eax
  802333:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802336:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80233a:	74 07                	je     802343 <print_mem_block_lists+0x9e>
  80233c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80233f:	8b 00                	mov    (%eax),%eax
  802341:	eb 05                	jmp    802348 <print_mem_block_lists+0xa3>
  802343:	b8 00 00 00 00       	mov    $0x0,%eax
  802348:	a3 40 41 80 00       	mov    %eax,0x804140
  80234d:	a1 40 41 80 00       	mov    0x804140,%eax
  802352:	85 c0                	test   %eax,%eax
  802354:	75 8a                	jne    8022e0 <print_mem_block_lists+0x3b>
  802356:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80235a:	75 84                	jne    8022e0 <print_mem_block_lists+0x3b>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;
  80235c:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  802360:	75 10                	jne    802372 <print_mem_block_lists+0xcd>
  802362:	83 ec 0c             	sub    $0xc,%esp
  802365:	68 10 3d 80 00       	push   $0x803d10
  80236a:	e8 26 e6 ff ff       	call   800995 <cprintf>
  80236f:	83 c4 10             	add    $0x10,%esp

	lastBlk = NULL ;
  802372:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nAllocMemBlocksList:\n");
  802379:	83 ec 0c             	sub    $0xc,%esp
  80237c:	68 34 3d 80 00       	push   $0x803d34
  802381:	e8 0f e6 ff ff       	call   800995 <cprintf>
  802386:	83 c4 10             	add    $0x10,%esp
	sorted = 1 ;
  802389:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &AllocMemBlocksList)
  80238d:	a1 40 40 80 00       	mov    0x804040,%eax
  802392:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802395:	eb 56                	jmp    8023ed <print_mem_block_lists+0x148>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  802397:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80239b:	74 1c                	je     8023b9 <print_mem_block_lists+0x114>
  80239d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023a0:	8b 50 08             	mov    0x8(%eax),%edx
  8023a3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8023a6:	8b 48 08             	mov    0x8(%eax),%ecx
  8023a9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8023ac:	8b 40 0c             	mov    0xc(%eax),%eax
  8023af:	01 c8                	add    %ecx,%eax
  8023b1:	39 c2                	cmp    %eax,%edx
  8023b3:	73 04                	jae    8023b9 <print_mem_block_lists+0x114>
			sorted = 0 ;
  8023b5:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  8023b9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023bc:	8b 50 08             	mov    0x8(%eax),%edx
  8023bf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023c2:	8b 40 0c             	mov    0xc(%eax),%eax
  8023c5:	01 c2                	add    %eax,%edx
  8023c7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023ca:	8b 40 08             	mov    0x8(%eax),%eax
  8023cd:	83 ec 04             	sub    $0x4,%esp
  8023d0:	52                   	push   %edx
  8023d1:	50                   	push   %eax
  8023d2:	68 01 3d 80 00       	push   $0x803d01
  8023d7:	e8 b9 e5 ff ff       	call   800995 <cprintf>
  8023dc:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  8023df:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023e2:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;

	lastBlk = NULL ;
	cprintf("\nAllocMemBlocksList:\n");
	sorted = 1 ;
	LIST_FOREACH(blk, &AllocMemBlocksList)
  8023e5:	a1 48 40 80 00       	mov    0x804048,%eax
  8023ea:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8023ed:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8023f1:	74 07                	je     8023fa <print_mem_block_lists+0x155>
  8023f3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023f6:	8b 00                	mov    (%eax),%eax
  8023f8:	eb 05                	jmp    8023ff <print_mem_block_lists+0x15a>
  8023fa:	b8 00 00 00 00       	mov    $0x0,%eax
  8023ff:	a3 48 40 80 00       	mov    %eax,0x804048
  802404:	a1 48 40 80 00       	mov    0x804048,%eax
  802409:	85 c0                	test   %eax,%eax
  80240b:	75 8a                	jne    802397 <print_mem_block_lists+0xf2>
  80240d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802411:	75 84                	jne    802397 <print_mem_block_lists+0xf2>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nAllocMemBlocksList is NOT SORTED!!\n") ;
  802413:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  802417:	75 10                	jne    802429 <print_mem_block_lists+0x184>
  802419:	83 ec 0c             	sub    $0xc,%esp
  80241c:	68 4c 3d 80 00       	push   $0x803d4c
  802421:	e8 6f e5 ff ff       	call   800995 <cprintf>
  802426:	83 c4 10             	add    $0x10,%esp
	cprintf("\n=========================================\n");
  802429:	83 ec 0c             	sub    $0xc,%esp
  80242c:	68 c0 3c 80 00       	push   $0x803cc0
  802431:	e8 5f e5 ff ff       	call   800995 <cprintf>
  802436:	83 c4 10             	add    $0x10,%esp

}
  802439:	90                   	nop
  80243a:	c9                   	leave  
  80243b:	c3                   	ret    

0080243c <initialize_MemBlocksList>:

//===============================
// [1] INITIALIZE AVAILABLE LIST:
//===============================
void initialize_MemBlocksList(uint32 numOfBlocks)
{
  80243c:	55                   	push   %ebp
  80243d:	89 e5                	mov    %esp,%ebp
  80243f:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] initialize_MemBlocksList
	// Write your code here, remove the panic and write your code
	//panic("initialize_MemBlocksList() is not implemented yet...!!");
	uint32 n = numOfBlocks;
  802442:	8b 45 08             	mov    0x8(%ebp),%eax
  802445:	89 45 f0             	mov    %eax,-0x10(%ebp)

	LIST_INIT(&AvailableMemBlocksList);
  802448:	c7 05 48 41 80 00 00 	movl   $0x0,0x804148
  80244f:	00 00 00 
  802452:	c7 05 4c 41 80 00 00 	movl   $0x0,0x80414c
  802459:	00 00 00 
  80245c:	c7 05 54 41 80 00 00 	movl   $0x0,0x804154
  802463:	00 00 00 
	for(int i = 0; i<n;i++)
  802466:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  80246d:	e9 9e 00 00 00       	jmp    802510 <initialize_MemBlocksList+0xd4>
	{
		LIST_INSERT_HEAD(&AvailableMemBlocksList, &(MemBlockNodes[i]));
  802472:	a1 50 40 80 00       	mov    0x804050,%eax
  802477:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80247a:	c1 e2 04             	shl    $0x4,%edx
  80247d:	01 d0                	add    %edx,%eax
  80247f:	85 c0                	test   %eax,%eax
  802481:	75 14                	jne    802497 <initialize_MemBlocksList+0x5b>
  802483:	83 ec 04             	sub    $0x4,%esp
  802486:	68 74 3d 80 00       	push   $0x803d74
  80248b:	6a 47                	push   $0x47
  80248d:	68 97 3d 80 00       	push   $0x803d97
  802492:	e8 4a e2 ff ff       	call   8006e1 <_panic>
  802497:	a1 50 40 80 00       	mov    0x804050,%eax
  80249c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80249f:	c1 e2 04             	shl    $0x4,%edx
  8024a2:	01 d0                	add    %edx,%eax
  8024a4:	8b 15 48 41 80 00    	mov    0x804148,%edx
  8024aa:	89 10                	mov    %edx,(%eax)
  8024ac:	8b 00                	mov    (%eax),%eax
  8024ae:	85 c0                	test   %eax,%eax
  8024b0:	74 18                	je     8024ca <initialize_MemBlocksList+0x8e>
  8024b2:	a1 48 41 80 00       	mov    0x804148,%eax
  8024b7:	8b 15 50 40 80 00    	mov    0x804050,%edx
  8024bd:	8b 4d f4             	mov    -0xc(%ebp),%ecx
  8024c0:	c1 e1 04             	shl    $0x4,%ecx
  8024c3:	01 ca                	add    %ecx,%edx
  8024c5:	89 50 04             	mov    %edx,0x4(%eax)
  8024c8:	eb 12                	jmp    8024dc <initialize_MemBlocksList+0xa0>
  8024ca:	a1 50 40 80 00       	mov    0x804050,%eax
  8024cf:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8024d2:	c1 e2 04             	shl    $0x4,%edx
  8024d5:	01 d0                	add    %edx,%eax
  8024d7:	a3 4c 41 80 00       	mov    %eax,0x80414c
  8024dc:	a1 50 40 80 00       	mov    0x804050,%eax
  8024e1:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8024e4:	c1 e2 04             	shl    $0x4,%edx
  8024e7:	01 d0                	add    %edx,%eax
  8024e9:	a3 48 41 80 00       	mov    %eax,0x804148
  8024ee:	a1 50 40 80 00       	mov    0x804050,%eax
  8024f3:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8024f6:	c1 e2 04             	shl    $0x4,%edx
  8024f9:	01 d0                	add    %edx,%eax
  8024fb:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802502:	a1 54 41 80 00       	mov    0x804154,%eax
  802507:	40                   	inc    %eax
  802508:	a3 54 41 80 00       	mov    %eax,0x804154
	// Write your code here, remove the panic and write your code
	//panic("initialize_MemBlocksList() is not implemented yet...!!");
	uint32 n = numOfBlocks;

	LIST_INIT(&AvailableMemBlocksList);
	for(int i = 0; i<n;i++)
  80250d:	ff 45 f4             	incl   -0xc(%ebp)
  802510:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802513:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  802516:	0f 82 56 ff ff ff    	jb     802472 <initialize_MemBlocksList+0x36>
	{
		LIST_INSERT_HEAD(&AvailableMemBlocksList, &(MemBlockNodes[i]));
	}
}
  80251c:	90                   	nop
  80251d:	c9                   	leave  
  80251e:	c3                   	ret    

0080251f <find_block>:

//===============================
// [2] FIND BLOCK:
//===============================
struct MemBlock *find_block(struct MemBlock_List *blockList, uint32 va)
{
  80251f:	55                   	push   %ebp
  802520:	89 e5                	mov    %esp,%ebp
  802522:	83 ec 10             	sub    $0x10,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] find_block
	// Write your code here, remove the panic and write your code
	//panic("find_block() is not implemented yet...!!");
	uint32 virAddress = va;
  802525:	8b 45 0c             	mov    0xc(%ebp),%eax
  802528:	89 45 f4             	mov    %eax,-0xc(%ebp)
	struct MemBlock* blk;
	int found = 0;
  80252b:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	LIST_FOREACH(blk, &(AllocMemBlocksList))
  802532:	a1 40 40 80 00       	mov    0x804040,%eax
  802537:	89 45 fc             	mov    %eax,-0x4(%ebp)
  80253a:	eb 23                	jmp    80255f <find_block+0x40>
	{
		if(blk->sva == virAddress)
  80253c:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80253f:	8b 40 08             	mov    0x8(%eax),%eax
  802542:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  802545:	75 09                	jne    802550 <find_block+0x31>
		{
			found = 1;
  802547:	c7 45 f8 01 00 00 00 	movl   $0x1,-0x8(%ebp)
			break;
  80254e:	eb 35                	jmp    802585 <find_block+0x66>
		}
		else
		{
			found = 0;
  802550:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	//panic("find_block() is not implemented yet...!!");
	uint32 virAddress = va;
	struct MemBlock* blk;
	int found = 0;

	LIST_FOREACH(blk, &(AllocMemBlocksList))
  802557:	a1 48 40 80 00       	mov    0x804048,%eax
  80255c:	89 45 fc             	mov    %eax,-0x4(%ebp)
  80255f:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  802563:	74 07                	je     80256c <find_block+0x4d>
  802565:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802568:	8b 00                	mov    (%eax),%eax
  80256a:	eb 05                	jmp    802571 <find_block+0x52>
  80256c:	b8 00 00 00 00       	mov    $0x0,%eax
  802571:	a3 48 40 80 00       	mov    %eax,0x804048
  802576:	a1 48 40 80 00       	mov    0x804048,%eax
  80257b:	85 c0                	test   %eax,%eax
  80257d:	75 bd                	jne    80253c <find_block+0x1d>
  80257f:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  802583:	75 b7                	jne    80253c <find_block+0x1d>
		{
			found = 0;
			continue;
		}
	}
	if(found == 1)
  802585:	83 7d f8 01          	cmpl   $0x1,-0x8(%ebp)
  802589:	75 05                	jne    802590 <find_block+0x71>
	{
		return blk;
  80258b:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80258e:	eb 05                	jmp    802595 <find_block+0x76>
	}
	else
	{
		return NULL;
  802590:	b8 00 00 00 00       	mov    $0x0,%eax
	}
}
  802595:	c9                   	leave  
  802596:	c3                   	ret    

00802597 <insert_sorted_allocList>:

//=========================================
// [3] INSERT BLOCK IN ALLOC LIST [SORTED]:
//=========================================
void insert_sorted_allocList(struct MemBlock *blockToInsert)
{
  802597:	55                   	push   %ebp
  802598:	89 e5                	mov    %esp,%ebp
  80259a:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] insert_sorted_allocList
	// Write your code here, remove the panic and write your code
	//panic("insert_sorted_allocList() is not implemented yet...!!");
	struct MemBlock* blk;
	struct MemBlock* newblk = blockToInsert;
  80259d:	8b 45 08             	mov    0x8(%ebp),%eax
  8025a0:	89 45 f0             	mov    %eax,-0x10(%ebp)

	if((LIST_EMPTY(&AllocMemBlocksList)) || (newblk->sva < LIST_FIRST(&AllocMemBlocksList)->sva))
  8025a3:	a1 40 40 80 00       	mov    0x804040,%eax
  8025a8:	85 c0                	test   %eax,%eax
  8025aa:	74 12                	je     8025be <insert_sorted_allocList+0x27>
  8025ac:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8025af:	8b 50 08             	mov    0x8(%eax),%edx
  8025b2:	a1 40 40 80 00       	mov    0x804040,%eax
  8025b7:	8b 40 08             	mov    0x8(%eax),%eax
  8025ba:	39 c2                	cmp    %eax,%edx
  8025bc:	73 65                	jae    802623 <insert_sorted_allocList+0x8c>
	{
		LIST_INSERT_HEAD(&(AllocMemBlocksList), newblk);
  8025be:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8025c2:	75 14                	jne    8025d8 <insert_sorted_allocList+0x41>
  8025c4:	83 ec 04             	sub    $0x4,%esp
  8025c7:	68 74 3d 80 00       	push   $0x803d74
  8025cc:	6a 7b                	push   $0x7b
  8025ce:	68 97 3d 80 00       	push   $0x803d97
  8025d3:	e8 09 e1 ff ff       	call   8006e1 <_panic>
  8025d8:	8b 15 40 40 80 00    	mov    0x804040,%edx
  8025de:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8025e1:	89 10                	mov    %edx,(%eax)
  8025e3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8025e6:	8b 00                	mov    (%eax),%eax
  8025e8:	85 c0                	test   %eax,%eax
  8025ea:	74 0d                	je     8025f9 <insert_sorted_allocList+0x62>
  8025ec:	a1 40 40 80 00       	mov    0x804040,%eax
  8025f1:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8025f4:	89 50 04             	mov    %edx,0x4(%eax)
  8025f7:	eb 08                	jmp    802601 <insert_sorted_allocList+0x6a>
  8025f9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8025fc:	a3 44 40 80 00       	mov    %eax,0x804044
  802601:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802604:	a3 40 40 80 00       	mov    %eax,0x804040
  802609:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80260c:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802613:	a1 4c 40 80 00       	mov    0x80404c,%eax
  802618:	40                   	inc    %eax
  802619:	a3 4c 40 80 00       	mov    %eax,0x80404c
  80261e:	e9 5f 01 00 00       	jmp    802782 <insert_sorted_allocList+0x1eb>
	}
	else if(newblk->sva > LIST_LAST(&AllocMemBlocksList)->sva)
  802623:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802626:	8b 50 08             	mov    0x8(%eax),%edx
  802629:	a1 44 40 80 00       	mov    0x804044,%eax
  80262e:	8b 40 08             	mov    0x8(%eax),%eax
  802631:	39 c2                	cmp    %eax,%edx
  802633:	76 65                	jbe    80269a <insert_sorted_allocList+0x103>
	{
		LIST_INSERT_TAIL(&AllocMemBlocksList, newblk);
  802635:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802639:	75 14                	jne    80264f <insert_sorted_allocList+0xb8>
  80263b:	83 ec 04             	sub    $0x4,%esp
  80263e:	68 b0 3d 80 00       	push   $0x803db0
  802643:	6a 7f                	push   $0x7f
  802645:	68 97 3d 80 00       	push   $0x803d97
  80264a:	e8 92 e0 ff ff       	call   8006e1 <_panic>
  80264f:	8b 15 44 40 80 00    	mov    0x804044,%edx
  802655:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802658:	89 50 04             	mov    %edx,0x4(%eax)
  80265b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80265e:	8b 40 04             	mov    0x4(%eax),%eax
  802661:	85 c0                	test   %eax,%eax
  802663:	74 0c                	je     802671 <insert_sorted_allocList+0xda>
  802665:	a1 44 40 80 00       	mov    0x804044,%eax
  80266a:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80266d:	89 10                	mov    %edx,(%eax)
  80266f:	eb 08                	jmp    802679 <insert_sorted_allocList+0xe2>
  802671:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802674:	a3 40 40 80 00       	mov    %eax,0x804040
  802679:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80267c:	a3 44 40 80 00       	mov    %eax,0x804044
  802681:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802684:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80268a:	a1 4c 40 80 00       	mov    0x80404c,%eax
  80268f:	40                   	inc    %eax
  802690:	a3 4c 40 80 00       	mov    %eax,0x80404c
				LIST_INSERT_AFTER(&AllocMemBlocksList, blk, newblk);
				break;
			}
		}
	}
}
  802695:	e9 e8 00 00 00       	jmp    802782 <insert_sorted_allocList+0x1eb>
	{
		LIST_INSERT_TAIL(&AllocMemBlocksList, newblk);
	}
	else
	{
		LIST_FOREACH(blk, &AllocMemBlocksList)
  80269a:	a1 40 40 80 00       	mov    0x804040,%eax
  80269f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8026a2:	e9 ab 00 00 00       	jmp    802752 <insert_sorted_allocList+0x1bb>
		{
			if(blk->prev_next_info.le_next != NULL && newblk->sva > blk->sva  && newblk->sva < blk->prev_next_info.le_next->sva)
  8026a7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026aa:	8b 00                	mov    (%eax),%eax
  8026ac:	85 c0                	test   %eax,%eax
  8026ae:	0f 84 96 00 00 00    	je     80274a <insert_sorted_allocList+0x1b3>
  8026b4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8026b7:	8b 50 08             	mov    0x8(%eax),%edx
  8026ba:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026bd:	8b 40 08             	mov    0x8(%eax),%eax
  8026c0:	39 c2                	cmp    %eax,%edx
  8026c2:	0f 86 82 00 00 00    	jbe    80274a <insert_sorted_allocList+0x1b3>
  8026c8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8026cb:	8b 50 08             	mov    0x8(%eax),%edx
  8026ce:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026d1:	8b 00                	mov    (%eax),%eax
  8026d3:	8b 40 08             	mov    0x8(%eax),%eax
  8026d6:	39 c2                	cmp    %eax,%edx
  8026d8:	73 70                	jae    80274a <insert_sorted_allocList+0x1b3>
			{
				LIST_INSERT_AFTER(&AllocMemBlocksList, blk, newblk);
  8026da:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8026de:	74 06                	je     8026e6 <insert_sorted_allocList+0x14f>
  8026e0:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8026e4:	75 17                	jne    8026fd <insert_sorted_allocList+0x166>
  8026e6:	83 ec 04             	sub    $0x4,%esp
  8026e9:	68 d4 3d 80 00       	push   $0x803dd4
  8026ee:	68 87 00 00 00       	push   $0x87
  8026f3:	68 97 3d 80 00       	push   $0x803d97
  8026f8:	e8 e4 df ff ff       	call   8006e1 <_panic>
  8026fd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802700:	8b 10                	mov    (%eax),%edx
  802702:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802705:	89 10                	mov    %edx,(%eax)
  802707:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80270a:	8b 00                	mov    (%eax),%eax
  80270c:	85 c0                	test   %eax,%eax
  80270e:	74 0b                	je     80271b <insert_sorted_allocList+0x184>
  802710:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802713:	8b 00                	mov    (%eax),%eax
  802715:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802718:	89 50 04             	mov    %edx,0x4(%eax)
  80271b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80271e:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802721:	89 10                	mov    %edx,(%eax)
  802723:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802726:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802729:	89 50 04             	mov    %edx,0x4(%eax)
  80272c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80272f:	8b 00                	mov    (%eax),%eax
  802731:	85 c0                	test   %eax,%eax
  802733:	75 08                	jne    80273d <insert_sorted_allocList+0x1a6>
  802735:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802738:	a3 44 40 80 00       	mov    %eax,0x804044
  80273d:	a1 4c 40 80 00       	mov    0x80404c,%eax
  802742:	40                   	inc    %eax
  802743:	a3 4c 40 80 00       	mov    %eax,0x80404c
				break;
  802748:	eb 38                	jmp    802782 <insert_sorted_allocList+0x1eb>
	{
		LIST_INSERT_TAIL(&AllocMemBlocksList, newblk);
	}
	else
	{
		LIST_FOREACH(blk, &AllocMemBlocksList)
  80274a:	a1 48 40 80 00       	mov    0x804048,%eax
  80274f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802752:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802756:	74 07                	je     80275f <insert_sorted_allocList+0x1c8>
  802758:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80275b:	8b 00                	mov    (%eax),%eax
  80275d:	eb 05                	jmp    802764 <insert_sorted_allocList+0x1cd>
  80275f:	b8 00 00 00 00       	mov    $0x0,%eax
  802764:	a3 48 40 80 00       	mov    %eax,0x804048
  802769:	a1 48 40 80 00       	mov    0x804048,%eax
  80276e:	85 c0                	test   %eax,%eax
  802770:	0f 85 31 ff ff ff    	jne    8026a7 <insert_sorted_allocList+0x110>
  802776:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80277a:	0f 85 27 ff ff ff    	jne    8026a7 <insert_sorted_allocList+0x110>
				LIST_INSERT_AFTER(&AllocMemBlocksList, blk, newblk);
				break;
			}
		}
	}
}
  802780:	eb 00                	jmp    802782 <insert_sorted_allocList+0x1eb>
  802782:	90                   	nop
  802783:	c9                   	leave  
  802784:	c3                   	ret    

00802785 <alloc_block_FF>:

//=========================================
// [4] ALLOCATE BLOCK BY FIRST FIT:
//=========================================
struct MemBlock *alloc_block_FF(uint32 size)
{
  802785:	55                   	push   %ebp
  802786:	89 e5                	mov    %esp,%ebp
  802788:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_FF
	// Write your code here, remove the panic and write your code
	//panic("alloc_block_FF() is not implemented yet...!!");
	uint32 versize = size;
  80278b:	8b 45 08             	mov    0x8(%ebp),%eax
  80278e:	89 45 f0             	mov    %eax,-0x10(%ebp)
	struct MemBlock* blk;
	struct MemBlock* newblk = LIST_FIRST(&AvailableMemBlocksList);
  802791:	a1 48 41 80 00       	mov    0x804148,%eax
  802796:	89 45 ec             	mov    %eax,-0x14(%ebp)

	LIST_FOREACH(blk,&FreeMemBlocksList)
  802799:	a1 38 41 80 00       	mov    0x804138,%eax
  80279e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8027a1:	e9 77 01 00 00       	jmp    80291d <alloc_block_FF+0x198>
	{
		if(blk->size == versize)
  8027a6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027a9:	8b 40 0c             	mov    0xc(%eax),%eax
  8027ac:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8027af:	0f 85 8a 00 00 00    	jne    80283f <alloc_block_FF+0xba>
		{
			LIST_REMOVE(&FreeMemBlocksList,blk);
  8027b5:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8027b9:	75 17                	jne    8027d2 <alloc_block_FF+0x4d>
  8027bb:	83 ec 04             	sub    $0x4,%esp
  8027be:	68 08 3e 80 00       	push   $0x803e08
  8027c3:	68 9e 00 00 00       	push   $0x9e
  8027c8:	68 97 3d 80 00       	push   $0x803d97
  8027cd:	e8 0f df ff ff       	call   8006e1 <_panic>
  8027d2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027d5:	8b 00                	mov    (%eax),%eax
  8027d7:	85 c0                	test   %eax,%eax
  8027d9:	74 10                	je     8027eb <alloc_block_FF+0x66>
  8027db:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027de:	8b 00                	mov    (%eax),%eax
  8027e0:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8027e3:	8b 52 04             	mov    0x4(%edx),%edx
  8027e6:	89 50 04             	mov    %edx,0x4(%eax)
  8027e9:	eb 0b                	jmp    8027f6 <alloc_block_FF+0x71>
  8027eb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027ee:	8b 40 04             	mov    0x4(%eax),%eax
  8027f1:	a3 3c 41 80 00       	mov    %eax,0x80413c
  8027f6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027f9:	8b 40 04             	mov    0x4(%eax),%eax
  8027fc:	85 c0                	test   %eax,%eax
  8027fe:	74 0f                	je     80280f <alloc_block_FF+0x8a>
  802800:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802803:	8b 40 04             	mov    0x4(%eax),%eax
  802806:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802809:	8b 12                	mov    (%edx),%edx
  80280b:	89 10                	mov    %edx,(%eax)
  80280d:	eb 0a                	jmp    802819 <alloc_block_FF+0x94>
  80280f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802812:	8b 00                	mov    (%eax),%eax
  802814:	a3 38 41 80 00       	mov    %eax,0x804138
  802819:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80281c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802822:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802825:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80282c:	a1 44 41 80 00       	mov    0x804144,%eax
  802831:	48                   	dec    %eax
  802832:	a3 44 41 80 00       	mov    %eax,0x804144
			return blk;
  802837:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80283a:	e9 11 01 00 00       	jmp    802950 <alloc_block_FF+0x1cb>
		}
		else if(blk->size > versize)
  80283f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802842:	8b 40 0c             	mov    0xc(%eax),%eax
  802845:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  802848:	0f 86 c7 00 00 00    	jbe    802915 <alloc_block_FF+0x190>
		{
			LIST_REMOVE(&AvailableMemBlocksList,newblk);
  80284e:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802852:	75 17                	jne    80286b <alloc_block_FF+0xe6>
  802854:	83 ec 04             	sub    $0x4,%esp
  802857:	68 08 3e 80 00       	push   $0x803e08
  80285c:	68 a3 00 00 00       	push   $0xa3
  802861:	68 97 3d 80 00       	push   $0x803d97
  802866:	e8 76 de ff ff       	call   8006e1 <_panic>
  80286b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80286e:	8b 00                	mov    (%eax),%eax
  802870:	85 c0                	test   %eax,%eax
  802872:	74 10                	je     802884 <alloc_block_FF+0xff>
  802874:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802877:	8b 00                	mov    (%eax),%eax
  802879:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80287c:	8b 52 04             	mov    0x4(%edx),%edx
  80287f:	89 50 04             	mov    %edx,0x4(%eax)
  802882:	eb 0b                	jmp    80288f <alloc_block_FF+0x10a>
  802884:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802887:	8b 40 04             	mov    0x4(%eax),%eax
  80288a:	a3 4c 41 80 00       	mov    %eax,0x80414c
  80288f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802892:	8b 40 04             	mov    0x4(%eax),%eax
  802895:	85 c0                	test   %eax,%eax
  802897:	74 0f                	je     8028a8 <alloc_block_FF+0x123>
  802899:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80289c:	8b 40 04             	mov    0x4(%eax),%eax
  80289f:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8028a2:	8b 12                	mov    (%edx),%edx
  8028a4:	89 10                	mov    %edx,(%eax)
  8028a6:	eb 0a                	jmp    8028b2 <alloc_block_FF+0x12d>
  8028a8:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8028ab:	8b 00                	mov    (%eax),%eax
  8028ad:	a3 48 41 80 00       	mov    %eax,0x804148
  8028b2:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8028b5:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8028bb:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8028be:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8028c5:	a1 54 41 80 00       	mov    0x804154,%eax
  8028ca:	48                   	dec    %eax
  8028cb:	a3 54 41 80 00       	mov    %eax,0x804154
			newblk->size = versize;
  8028d0:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8028d3:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8028d6:	89 50 0c             	mov    %edx,0xc(%eax)
			blk->size = blk->size-versize;
  8028d9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028dc:	8b 40 0c             	mov    0xc(%eax),%eax
  8028df:	2b 45 f0             	sub    -0x10(%ebp),%eax
  8028e2:	89 c2                	mov    %eax,%edx
  8028e4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028e7:	89 50 0c             	mov    %edx,0xc(%eax)
			uint32 newveradd = blk->sva;
  8028ea:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028ed:	8b 40 08             	mov    0x8(%eax),%eax
  8028f0:	89 45 e8             	mov    %eax,-0x18(%ebp)
			blk->sva+=newblk->size;
  8028f3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028f6:	8b 50 08             	mov    0x8(%eax),%edx
  8028f9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8028fc:	8b 40 0c             	mov    0xc(%eax),%eax
  8028ff:	01 c2                	add    %eax,%edx
  802901:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802904:	89 50 08             	mov    %edx,0x8(%eax)
			newblk->sva = newveradd;
  802907:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80290a:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80290d:	89 50 08             	mov    %edx,0x8(%eax)
			return newblk;
  802910:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802913:	eb 3b                	jmp    802950 <alloc_block_FF+0x1cb>
	//panic("alloc_block_FF() is not implemented yet...!!");
	uint32 versize = size;
	struct MemBlock* blk;
	struct MemBlock* newblk = LIST_FIRST(&AvailableMemBlocksList);

	LIST_FOREACH(blk,&FreeMemBlocksList)
  802915:	a1 40 41 80 00       	mov    0x804140,%eax
  80291a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80291d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802921:	74 07                	je     80292a <alloc_block_FF+0x1a5>
  802923:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802926:	8b 00                	mov    (%eax),%eax
  802928:	eb 05                	jmp    80292f <alloc_block_FF+0x1aa>
  80292a:	b8 00 00 00 00       	mov    $0x0,%eax
  80292f:	a3 40 41 80 00       	mov    %eax,0x804140
  802934:	a1 40 41 80 00       	mov    0x804140,%eax
  802939:	85 c0                	test   %eax,%eax
  80293b:	0f 85 65 fe ff ff    	jne    8027a6 <alloc_block_FF+0x21>
  802941:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802945:	0f 85 5b fe ff ff    	jne    8027a6 <alloc_block_FF+0x21>
			blk->sva+=newblk->size;
			newblk->sva = newveradd;
			return newblk;
		}
	}
	return NULL;
  80294b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802950:	c9                   	leave  
  802951:	c3                   	ret    

00802952 <alloc_block_BF>:

//=========================================
// [5] ALLOCATE BLOCK BY BEST FIT:
//=========================================
struct MemBlock *alloc_block_BF(uint32 size)
{
  802952:	55                   	push   %ebp
  802953:	89 e5                	mov    %esp,%ebp
  802955:	83 ec 28             	sub    $0x28,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_BF
	// Write your code here, remove the panic and write your code
	//panic("alloc_block_BF() is not implemented yet...!!");
	uint32 versize=size;
  802958:	8b 45 08             	mov    0x8(%ebp),%eax
  80295b:	89 45 e8             	mov    %eax,-0x18(%ebp)
	struct MemBlock* blk;
	struct MemBlock* newblk=LIST_FIRST(&AvailableMemBlocksList);
  80295e:	a1 48 41 80 00       	mov    0x804148,%eax
  802963:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	uint32 newveradd;
	uint32 newsize;
	int size_free = LIST_SIZE(&FreeMemBlocksList);
  802966:	a1 44 41 80 00       	mov    0x804144,%eax
  80296b:	89 45 e0             	mov    %eax,-0x20(%ebp)

	LIST_FOREACH(blk, &FreeMemBlocksList)
  80296e:	a1 38 41 80 00       	mov    0x804138,%eax
  802973:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802976:	e9 a1 00 00 00       	jmp    802a1c <alloc_block_BF+0xca>
	{
		if(blk->size == versize)
  80297b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80297e:	8b 40 0c             	mov    0xc(%eax),%eax
  802981:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  802984:	0f 85 8a 00 00 00    	jne    802a14 <alloc_block_BF+0xc2>
		{
			LIST_REMOVE(&FreeMemBlocksList, blk);
  80298a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80298e:	75 17                	jne    8029a7 <alloc_block_BF+0x55>
  802990:	83 ec 04             	sub    $0x4,%esp
  802993:	68 08 3e 80 00       	push   $0x803e08
  802998:	68 c2 00 00 00       	push   $0xc2
  80299d:	68 97 3d 80 00       	push   $0x803d97
  8029a2:	e8 3a dd ff ff       	call   8006e1 <_panic>
  8029a7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029aa:	8b 00                	mov    (%eax),%eax
  8029ac:	85 c0                	test   %eax,%eax
  8029ae:	74 10                	je     8029c0 <alloc_block_BF+0x6e>
  8029b0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029b3:	8b 00                	mov    (%eax),%eax
  8029b5:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8029b8:	8b 52 04             	mov    0x4(%edx),%edx
  8029bb:	89 50 04             	mov    %edx,0x4(%eax)
  8029be:	eb 0b                	jmp    8029cb <alloc_block_BF+0x79>
  8029c0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029c3:	8b 40 04             	mov    0x4(%eax),%eax
  8029c6:	a3 3c 41 80 00       	mov    %eax,0x80413c
  8029cb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029ce:	8b 40 04             	mov    0x4(%eax),%eax
  8029d1:	85 c0                	test   %eax,%eax
  8029d3:	74 0f                	je     8029e4 <alloc_block_BF+0x92>
  8029d5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029d8:	8b 40 04             	mov    0x4(%eax),%eax
  8029db:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8029de:	8b 12                	mov    (%edx),%edx
  8029e0:	89 10                	mov    %edx,(%eax)
  8029e2:	eb 0a                	jmp    8029ee <alloc_block_BF+0x9c>
  8029e4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029e7:	8b 00                	mov    (%eax),%eax
  8029e9:	a3 38 41 80 00       	mov    %eax,0x804138
  8029ee:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029f1:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8029f7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029fa:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802a01:	a1 44 41 80 00       	mov    0x804144,%eax
  802a06:	48                   	dec    %eax
  802a07:	a3 44 41 80 00       	mov    %eax,0x804144
			return blk;
  802a0c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a0f:	e9 11 02 00 00       	jmp    802c25 <alloc_block_BF+0x2d3>
	struct MemBlock* newblk=LIST_FIRST(&AvailableMemBlocksList);
	uint32 newveradd;
	uint32 newsize;
	int size_free = LIST_SIZE(&FreeMemBlocksList);

	LIST_FOREACH(blk, &FreeMemBlocksList)
  802a14:	a1 40 41 80 00       	mov    0x804140,%eax
  802a19:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802a1c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802a20:	74 07                	je     802a29 <alloc_block_BF+0xd7>
  802a22:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a25:	8b 00                	mov    (%eax),%eax
  802a27:	eb 05                	jmp    802a2e <alloc_block_BF+0xdc>
  802a29:	b8 00 00 00 00       	mov    $0x0,%eax
  802a2e:	a3 40 41 80 00       	mov    %eax,0x804140
  802a33:	a1 40 41 80 00       	mov    0x804140,%eax
  802a38:	85 c0                	test   %eax,%eax
  802a3a:	0f 85 3b ff ff ff    	jne    80297b <alloc_block_BF+0x29>
  802a40:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802a44:	0f 85 31 ff ff ff    	jne    80297b <alloc_block_BF+0x29>
		{
			LIST_REMOVE(&FreeMemBlocksList, blk);
			return blk;
		}
	}
	LIST_FOREACH(blk, &FreeMemBlocksList)
  802a4a:	a1 38 41 80 00       	mov    0x804138,%eax
  802a4f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802a52:	eb 27                	jmp    802a7b <alloc_block_BF+0x129>
	{
		if(blk->size > versize)
  802a54:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a57:	8b 40 0c             	mov    0xc(%eax),%eax
  802a5a:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  802a5d:	76 14                	jbe    802a73 <alloc_block_BF+0x121>
		{
			newsize = blk->size;
  802a5f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a62:	8b 40 0c             	mov    0xc(%eax),%eax
  802a65:	89 45 ec             	mov    %eax,-0x14(%ebp)
			newveradd = blk->sva;
  802a68:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a6b:	8b 40 08             	mov    0x8(%eax),%eax
  802a6e:	89 45 f0             	mov    %eax,-0x10(%ebp)
			break;
  802a71:	eb 2e                	jmp    802aa1 <alloc_block_BF+0x14f>
		{
			LIST_REMOVE(&FreeMemBlocksList, blk);
			return blk;
		}
	}
	LIST_FOREACH(blk, &FreeMemBlocksList)
  802a73:	a1 40 41 80 00       	mov    0x804140,%eax
  802a78:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802a7b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802a7f:	74 07                	je     802a88 <alloc_block_BF+0x136>
  802a81:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a84:	8b 00                	mov    (%eax),%eax
  802a86:	eb 05                	jmp    802a8d <alloc_block_BF+0x13b>
  802a88:	b8 00 00 00 00       	mov    $0x0,%eax
  802a8d:	a3 40 41 80 00       	mov    %eax,0x804140
  802a92:	a1 40 41 80 00       	mov    0x804140,%eax
  802a97:	85 c0                	test   %eax,%eax
  802a99:	75 b9                	jne    802a54 <alloc_block_BF+0x102>
  802a9b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802a9f:	75 b3                	jne    802a54 <alloc_block_BF+0x102>
			newsize = blk->size;
			newveradd = blk->sva;
			break;
		}
	}
	LIST_FOREACH(blk, &FreeMemBlocksList)
  802aa1:	a1 38 41 80 00       	mov    0x804138,%eax
  802aa6:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802aa9:	eb 30                	jmp    802adb <alloc_block_BF+0x189>
	{
		if(newsize > blk->size && blk->size > versize)
  802aab:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802aae:	8b 40 0c             	mov    0xc(%eax),%eax
  802ab1:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  802ab4:	73 1d                	jae    802ad3 <alloc_block_BF+0x181>
  802ab6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ab9:	8b 40 0c             	mov    0xc(%eax),%eax
  802abc:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  802abf:	76 12                	jbe    802ad3 <alloc_block_BF+0x181>
		{
	       newsize = blk->size;
  802ac1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ac4:	8b 40 0c             	mov    0xc(%eax),%eax
  802ac7:	89 45 ec             	mov    %eax,-0x14(%ebp)
		   newveradd = blk->sva;
  802aca:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802acd:	8b 40 08             	mov    0x8(%eax),%eax
  802ad0:	89 45 f0             	mov    %eax,-0x10(%ebp)
			newsize = blk->size;
			newveradd = blk->sva;
			break;
		}
	}
	LIST_FOREACH(blk, &FreeMemBlocksList)
  802ad3:	a1 40 41 80 00       	mov    0x804140,%eax
  802ad8:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802adb:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802adf:	74 07                	je     802ae8 <alloc_block_BF+0x196>
  802ae1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ae4:	8b 00                	mov    (%eax),%eax
  802ae6:	eb 05                	jmp    802aed <alloc_block_BF+0x19b>
  802ae8:	b8 00 00 00 00       	mov    $0x0,%eax
  802aed:	a3 40 41 80 00       	mov    %eax,0x804140
  802af2:	a1 40 41 80 00       	mov    0x804140,%eax
  802af7:	85 c0                	test   %eax,%eax
  802af9:	75 b0                	jne    802aab <alloc_block_BF+0x159>
  802afb:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802aff:	75 aa                	jne    802aab <alloc_block_BF+0x159>
		{
	       newsize = blk->size;
		   newveradd = blk->sva;
		}
	}
	LIST_FOREACH(blk, &FreeMemBlocksList)
  802b01:	a1 38 41 80 00       	mov    0x804138,%eax
  802b06:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802b09:	e9 e4 00 00 00       	jmp    802bf2 <alloc_block_BF+0x2a0>
	{
		if(blk->size == newsize && blk->sva == newveradd)
  802b0e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b11:	8b 40 0c             	mov    0xc(%eax),%eax
  802b14:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  802b17:	0f 85 cd 00 00 00    	jne    802bea <alloc_block_BF+0x298>
  802b1d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b20:	8b 40 08             	mov    0x8(%eax),%eax
  802b23:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  802b26:	0f 85 be 00 00 00    	jne    802bea <alloc_block_BF+0x298>
		{
			LIST_REMOVE(&AvailableMemBlocksList, newblk);
  802b2c:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  802b30:	75 17                	jne    802b49 <alloc_block_BF+0x1f7>
  802b32:	83 ec 04             	sub    $0x4,%esp
  802b35:	68 08 3e 80 00       	push   $0x803e08
  802b3a:	68 db 00 00 00       	push   $0xdb
  802b3f:	68 97 3d 80 00       	push   $0x803d97
  802b44:	e8 98 db ff ff       	call   8006e1 <_panic>
  802b49:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802b4c:	8b 00                	mov    (%eax),%eax
  802b4e:	85 c0                	test   %eax,%eax
  802b50:	74 10                	je     802b62 <alloc_block_BF+0x210>
  802b52:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802b55:	8b 00                	mov    (%eax),%eax
  802b57:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802b5a:	8b 52 04             	mov    0x4(%edx),%edx
  802b5d:	89 50 04             	mov    %edx,0x4(%eax)
  802b60:	eb 0b                	jmp    802b6d <alloc_block_BF+0x21b>
  802b62:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802b65:	8b 40 04             	mov    0x4(%eax),%eax
  802b68:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802b6d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802b70:	8b 40 04             	mov    0x4(%eax),%eax
  802b73:	85 c0                	test   %eax,%eax
  802b75:	74 0f                	je     802b86 <alloc_block_BF+0x234>
  802b77:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802b7a:	8b 40 04             	mov    0x4(%eax),%eax
  802b7d:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802b80:	8b 12                	mov    (%edx),%edx
  802b82:	89 10                	mov    %edx,(%eax)
  802b84:	eb 0a                	jmp    802b90 <alloc_block_BF+0x23e>
  802b86:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802b89:	8b 00                	mov    (%eax),%eax
  802b8b:	a3 48 41 80 00       	mov    %eax,0x804148
  802b90:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802b93:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802b99:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802b9c:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802ba3:	a1 54 41 80 00       	mov    0x804154,%eax
  802ba8:	48                   	dec    %eax
  802ba9:	a3 54 41 80 00       	mov    %eax,0x804154
			newblk->size = versize;
  802bae:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802bb1:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802bb4:	89 50 0c             	mov    %edx,0xc(%eax)
			newblk->sva = newveradd;
  802bb7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802bba:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802bbd:	89 50 08             	mov    %edx,0x8(%eax)
			blk->size = blk->size - versize;
  802bc0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bc3:	8b 40 0c             	mov    0xc(%eax),%eax
  802bc6:	2b 45 e8             	sub    -0x18(%ebp),%eax
  802bc9:	89 c2                	mov    %eax,%edx
  802bcb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bce:	89 50 0c             	mov    %edx,0xc(%eax)
			blk->sva+= newblk->size;
  802bd1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bd4:	8b 50 08             	mov    0x8(%eax),%edx
  802bd7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802bda:	8b 40 0c             	mov    0xc(%eax),%eax
  802bdd:	01 c2                	add    %eax,%edx
  802bdf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802be2:	89 50 08             	mov    %edx,0x8(%eax)
			return newblk;
  802be5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802be8:	eb 3b                	jmp    802c25 <alloc_block_BF+0x2d3>
		{
	       newsize = blk->size;
		   newveradd = blk->sva;
		}
	}
	LIST_FOREACH(blk, &FreeMemBlocksList)
  802bea:	a1 40 41 80 00       	mov    0x804140,%eax
  802bef:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802bf2:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802bf6:	74 07                	je     802bff <alloc_block_BF+0x2ad>
  802bf8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bfb:	8b 00                	mov    (%eax),%eax
  802bfd:	eb 05                	jmp    802c04 <alloc_block_BF+0x2b2>
  802bff:	b8 00 00 00 00       	mov    $0x0,%eax
  802c04:	a3 40 41 80 00       	mov    %eax,0x804140
  802c09:	a1 40 41 80 00       	mov    0x804140,%eax
  802c0e:	85 c0                	test   %eax,%eax
  802c10:	0f 85 f8 fe ff ff    	jne    802b0e <alloc_block_BF+0x1bc>
  802c16:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802c1a:	0f 85 ee fe ff ff    	jne    802b0e <alloc_block_BF+0x1bc>
			blk->size = blk->size - versize;
			blk->sva+= newblk->size;
			return newblk;
		}
	}
	return NULL;
  802c20:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802c25:	c9                   	leave  
  802c26:	c3                   	ret    

00802c27 <alloc_block_NF>:
//=========================================
// [7] ALLOCATE BLOCK BY NEXT FIT:
//=========================================
struct MemBlock *last_allocate;
struct MemBlock *alloc_block_NF(uint32 size)
{
  802c27:	55                   	push   %ebp
  802c28:	89 e5                	mov    %esp,%ebp
  802c2a:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1 - BONUS] [DYNAMIC ALLOCATOR] alloc_block_NF
	// Write your code here, remove the panic and write your code
	//panic("alloc_block_NF() is not implemented yet...!!");
	uint32 versize = size;
  802c2d:	8b 45 08             	mov    0x8(%ebp),%eax
  802c30:	89 45 f0             	mov    %eax,-0x10(%ebp)
	struct MemBlock* blk;
	struct MemBlock* newblk = LIST_FIRST(&AvailableMemBlocksList);
  802c33:	a1 48 41 80 00       	mov    0x804148,%eax
  802c38:	89 45 ec             	mov    %eax,-0x14(%ebp)

	LIST_FOREACH(blk,&FreeMemBlocksList)
  802c3b:	a1 38 41 80 00       	mov    0x804138,%eax
  802c40:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802c43:	e9 77 01 00 00       	jmp    802dbf <alloc_block_NF+0x198>
	{
		if(blk->size == versize)
  802c48:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c4b:	8b 40 0c             	mov    0xc(%eax),%eax
  802c4e:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  802c51:	0f 85 8a 00 00 00    	jne    802ce1 <alloc_block_NF+0xba>
		{
			LIST_REMOVE(&FreeMemBlocksList,blk);
  802c57:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802c5b:	75 17                	jne    802c74 <alloc_block_NF+0x4d>
  802c5d:	83 ec 04             	sub    $0x4,%esp
  802c60:	68 08 3e 80 00       	push   $0x803e08
  802c65:	68 f7 00 00 00       	push   $0xf7
  802c6a:	68 97 3d 80 00       	push   $0x803d97
  802c6f:	e8 6d da ff ff       	call   8006e1 <_panic>
  802c74:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c77:	8b 00                	mov    (%eax),%eax
  802c79:	85 c0                	test   %eax,%eax
  802c7b:	74 10                	je     802c8d <alloc_block_NF+0x66>
  802c7d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c80:	8b 00                	mov    (%eax),%eax
  802c82:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802c85:	8b 52 04             	mov    0x4(%edx),%edx
  802c88:	89 50 04             	mov    %edx,0x4(%eax)
  802c8b:	eb 0b                	jmp    802c98 <alloc_block_NF+0x71>
  802c8d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c90:	8b 40 04             	mov    0x4(%eax),%eax
  802c93:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802c98:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c9b:	8b 40 04             	mov    0x4(%eax),%eax
  802c9e:	85 c0                	test   %eax,%eax
  802ca0:	74 0f                	je     802cb1 <alloc_block_NF+0x8a>
  802ca2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ca5:	8b 40 04             	mov    0x4(%eax),%eax
  802ca8:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802cab:	8b 12                	mov    (%edx),%edx
  802cad:	89 10                	mov    %edx,(%eax)
  802caf:	eb 0a                	jmp    802cbb <alloc_block_NF+0x94>
  802cb1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cb4:	8b 00                	mov    (%eax),%eax
  802cb6:	a3 38 41 80 00       	mov    %eax,0x804138
  802cbb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cbe:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802cc4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cc7:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802cce:	a1 44 41 80 00       	mov    0x804144,%eax
  802cd3:	48                   	dec    %eax
  802cd4:	a3 44 41 80 00       	mov    %eax,0x804144
			return blk;
  802cd9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cdc:	e9 11 01 00 00       	jmp    802df2 <alloc_block_NF+0x1cb>
		}
		else if(blk->size > versize)
  802ce1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ce4:	8b 40 0c             	mov    0xc(%eax),%eax
  802ce7:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  802cea:	0f 86 c7 00 00 00    	jbe    802db7 <alloc_block_NF+0x190>
		{
			LIST_REMOVE(&AvailableMemBlocksList,newblk);
  802cf0:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802cf4:	75 17                	jne    802d0d <alloc_block_NF+0xe6>
  802cf6:	83 ec 04             	sub    $0x4,%esp
  802cf9:	68 08 3e 80 00       	push   $0x803e08
  802cfe:	68 fc 00 00 00       	push   $0xfc
  802d03:	68 97 3d 80 00       	push   $0x803d97
  802d08:	e8 d4 d9 ff ff       	call   8006e1 <_panic>
  802d0d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802d10:	8b 00                	mov    (%eax),%eax
  802d12:	85 c0                	test   %eax,%eax
  802d14:	74 10                	je     802d26 <alloc_block_NF+0xff>
  802d16:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802d19:	8b 00                	mov    (%eax),%eax
  802d1b:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802d1e:	8b 52 04             	mov    0x4(%edx),%edx
  802d21:	89 50 04             	mov    %edx,0x4(%eax)
  802d24:	eb 0b                	jmp    802d31 <alloc_block_NF+0x10a>
  802d26:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802d29:	8b 40 04             	mov    0x4(%eax),%eax
  802d2c:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802d31:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802d34:	8b 40 04             	mov    0x4(%eax),%eax
  802d37:	85 c0                	test   %eax,%eax
  802d39:	74 0f                	je     802d4a <alloc_block_NF+0x123>
  802d3b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802d3e:	8b 40 04             	mov    0x4(%eax),%eax
  802d41:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802d44:	8b 12                	mov    (%edx),%edx
  802d46:	89 10                	mov    %edx,(%eax)
  802d48:	eb 0a                	jmp    802d54 <alloc_block_NF+0x12d>
  802d4a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802d4d:	8b 00                	mov    (%eax),%eax
  802d4f:	a3 48 41 80 00       	mov    %eax,0x804148
  802d54:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802d57:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802d5d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802d60:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802d67:	a1 54 41 80 00       	mov    0x804154,%eax
  802d6c:	48                   	dec    %eax
  802d6d:	a3 54 41 80 00       	mov    %eax,0x804154
			newblk->size = versize;
  802d72:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802d75:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802d78:	89 50 0c             	mov    %edx,0xc(%eax)
			blk->size = blk->size-versize;
  802d7b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d7e:	8b 40 0c             	mov    0xc(%eax),%eax
  802d81:	2b 45 f0             	sub    -0x10(%ebp),%eax
  802d84:	89 c2                	mov    %eax,%edx
  802d86:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d89:	89 50 0c             	mov    %edx,0xc(%eax)
			uint32 newveradd = blk->sva;
  802d8c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d8f:	8b 40 08             	mov    0x8(%eax),%eax
  802d92:	89 45 e8             	mov    %eax,-0x18(%ebp)
			blk->sva+=newblk->size;
  802d95:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d98:	8b 50 08             	mov    0x8(%eax),%edx
  802d9b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802d9e:	8b 40 0c             	mov    0xc(%eax),%eax
  802da1:	01 c2                	add    %eax,%edx
  802da3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802da6:	89 50 08             	mov    %edx,0x8(%eax)
			newblk->sva = newveradd;
  802da9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802dac:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802daf:	89 50 08             	mov    %edx,0x8(%eax)
			return newblk;
  802db2:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802db5:	eb 3b                	jmp    802df2 <alloc_block_NF+0x1cb>
	//panic("alloc_block_NF() is not implemented yet...!!");
	uint32 versize = size;
	struct MemBlock* blk;
	struct MemBlock* newblk = LIST_FIRST(&AvailableMemBlocksList);

	LIST_FOREACH(blk,&FreeMemBlocksList)
  802db7:	a1 40 41 80 00       	mov    0x804140,%eax
  802dbc:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802dbf:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802dc3:	74 07                	je     802dcc <alloc_block_NF+0x1a5>
  802dc5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802dc8:	8b 00                	mov    (%eax),%eax
  802dca:	eb 05                	jmp    802dd1 <alloc_block_NF+0x1aa>
  802dcc:	b8 00 00 00 00       	mov    $0x0,%eax
  802dd1:	a3 40 41 80 00       	mov    %eax,0x804140
  802dd6:	a1 40 41 80 00       	mov    0x804140,%eax
  802ddb:	85 c0                	test   %eax,%eax
  802ddd:	0f 85 65 fe ff ff    	jne    802c48 <alloc_block_NF+0x21>
  802de3:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802de7:	0f 85 5b fe ff ff    	jne    802c48 <alloc_block_NF+0x21>
			blk->sva+=newblk->size;
			newblk->sva = newveradd;
			return newblk;
		}
	}
	return NULL;
  802ded:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802df2:	c9                   	leave  
  802df3:	c3                   	ret    

00802df4 <addToAvailMemBlocksList>:

//===================================================
// [8] INSERT BLOCK (SORTED WITH MERGE) IN FREE LIST:
//===================================================
void addToAvailMemBlocksList(struct MemBlock *blockToInsert)
{
  802df4:	55                   	push   %ebp
  802df5:	89 e5                	mov    %esp,%ebp
  802df7:	83 ec 08             	sub    $0x8,%esp
	blockToInsert->sva = 0;
  802dfa:	8b 45 08             	mov    0x8(%ebp),%eax
  802dfd:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
	blockToInsert->size = 0;
  802e04:	8b 45 08             	mov    0x8(%ebp),%eax
  802e07:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
	//add to avail
	LIST_INSERT_TAIL(&AvailableMemBlocksList, blockToInsert);
  802e0e:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802e12:	75 17                	jne    802e2b <addToAvailMemBlocksList+0x37>
  802e14:	83 ec 04             	sub    $0x4,%esp
  802e17:	68 b0 3d 80 00       	push   $0x803db0
  802e1c:	68 10 01 00 00       	push   $0x110
  802e21:	68 97 3d 80 00       	push   $0x803d97
  802e26:	e8 b6 d8 ff ff       	call   8006e1 <_panic>
  802e2b:	8b 15 4c 41 80 00    	mov    0x80414c,%edx
  802e31:	8b 45 08             	mov    0x8(%ebp),%eax
  802e34:	89 50 04             	mov    %edx,0x4(%eax)
  802e37:	8b 45 08             	mov    0x8(%ebp),%eax
  802e3a:	8b 40 04             	mov    0x4(%eax),%eax
  802e3d:	85 c0                	test   %eax,%eax
  802e3f:	74 0c                	je     802e4d <addToAvailMemBlocksList+0x59>
  802e41:	a1 4c 41 80 00       	mov    0x80414c,%eax
  802e46:	8b 55 08             	mov    0x8(%ebp),%edx
  802e49:	89 10                	mov    %edx,(%eax)
  802e4b:	eb 08                	jmp    802e55 <addToAvailMemBlocksList+0x61>
  802e4d:	8b 45 08             	mov    0x8(%ebp),%eax
  802e50:	a3 48 41 80 00       	mov    %eax,0x804148
  802e55:	8b 45 08             	mov    0x8(%ebp),%eax
  802e58:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802e5d:	8b 45 08             	mov    0x8(%ebp),%eax
  802e60:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802e66:	a1 54 41 80 00       	mov    0x804154,%eax
  802e6b:	40                   	inc    %eax
  802e6c:	a3 54 41 80 00       	mov    %eax,0x804154
}
  802e71:	90                   	nop
  802e72:	c9                   	leave  
  802e73:	c3                   	ret    

00802e74 <insert_sorted_with_merge_freeList>:
void insert_sorted_with_merge_freeList(struct MemBlock *blockToInsert)
{
  802e74:	55                   	push   %ebp
  802e75:	89 e5                	mov    %esp,%ebp
  802e77:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] insert_sorted_with_merge_freeList
	// Write your code here, remove the panic and write your code

	struct MemBlock* last = LIST_LAST(&FreeMemBlocksList);
  802e7a:	a1 3c 41 80 00       	mov    0x80413c,%eax
  802e7f:	89 45 f0             	mov    %eax,-0x10(%ebp)
	//check if list empty
	if (LIST_SIZE(&(FreeMemBlocksList)) == 0)
  802e82:	a1 44 41 80 00       	mov    0x804144,%eax
  802e87:	85 c0                	test   %eax,%eax
  802e89:	75 68                	jne    802ef3 <insert_sorted_with_merge_freeList+0x7f>
		LIST_INSERT_HEAD(&FreeMemBlocksList, blockToInsert);
  802e8b:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802e8f:	75 17                	jne    802ea8 <insert_sorted_with_merge_freeList+0x34>
  802e91:	83 ec 04             	sub    $0x4,%esp
  802e94:	68 74 3d 80 00       	push   $0x803d74
  802e99:	68 1a 01 00 00       	push   $0x11a
  802e9e:	68 97 3d 80 00       	push   $0x803d97
  802ea3:	e8 39 d8 ff ff       	call   8006e1 <_panic>
  802ea8:	8b 15 38 41 80 00    	mov    0x804138,%edx
  802eae:	8b 45 08             	mov    0x8(%ebp),%eax
  802eb1:	89 10                	mov    %edx,(%eax)
  802eb3:	8b 45 08             	mov    0x8(%ebp),%eax
  802eb6:	8b 00                	mov    (%eax),%eax
  802eb8:	85 c0                	test   %eax,%eax
  802eba:	74 0d                	je     802ec9 <insert_sorted_with_merge_freeList+0x55>
  802ebc:	a1 38 41 80 00       	mov    0x804138,%eax
  802ec1:	8b 55 08             	mov    0x8(%ebp),%edx
  802ec4:	89 50 04             	mov    %edx,0x4(%eax)
  802ec7:	eb 08                	jmp    802ed1 <insert_sorted_with_merge_freeList+0x5d>
  802ec9:	8b 45 08             	mov    0x8(%ebp),%eax
  802ecc:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802ed1:	8b 45 08             	mov    0x8(%ebp),%eax
  802ed4:	a3 38 41 80 00       	mov    %eax,0x804138
  802ed9:	8b 45 08             	mov    0x8(%ebp),%eax
  802edc:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802ee3:	a1 44 41 80 00       	mov    0x804144,%eax
  802ee8:	40                   	inc    %eax
  802ee9:	a3 44 41 80 00       	mov    %eax,0x804144
		}
	}

	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  802eee:	e9 c5 03 00 00       	jmp    8032b8 <insert_sorted_with_merge_freeList+0x444>
	struct MemBlock* last = LIST_LAST(&FreeMemBlocksList);
	//check if list empty
	if (LIST_SIZE(&(FreeMemBlocksList)) == 0)
		LIST_INSERT_HEAD(&FreeMemBlocksList, blockToInsert);
	//check if it's position is at last
	else if (last->sva < blockToInsert->sva) {
  802ef3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ef6:	8b 50 08             	mov    0x8(%eax),%edx
  802ef9:	8b 45 08             	mov    0x8(%ebp),%eax
  802efc:	8b 40 08             	mov    0x8(%eax),%eax
  802eff:	39 c2                	cmp    %eax,%edx
  802f01:	0f 83 b2 00 00 00    	jae    802fb9 <insert_sorted_with_merge_freeList+0x145>

		//if i have to merge
		if (last->sva + last->size == blockToInsert->sva) {
  802f07:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802f0a:	8b 50 08             	mov    0x8(%eax),%edx
  802f0d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802f10:	8b 40 0c             	mov    0xc(%eax),%eax
  802f13:	01 c2                	add    %eax,%edx
  802f15:	8b 45 08             	mov    0x8(%ebp),%eax
  802f18:	8b 40 08             	mov    0x8(%eax),%eax
  802f1b:	39 c2                	cmp    %eax,%edx
  802f1d:	75 27                	jne    802f46 <insert_sorted_with_merge_freeList+0xd2>
			last->size = last->size + blockToInsert->size;
  802f1f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802f22:	8b 50 0c             	mov    0xc(%eax),%edx
  802f25:	8b 45 08             	mov    0x8(%ebp),%eax
  802f28:	8b 40 0c             	mov    0xc(%eax),%eax
  802f2b:	01 c2                	add    %eax,%edx
  802f2d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802f30:	89 50 0c             	mov    %edx,0xc(%eax)
			addToAvailMemBlocksList(blockToInsert);
  802f33:	83 ec 0c             	sub    $0xc,%esp
  802f36:	ff 75 08             	pushl  0x8(%ebp)
  802f39:	e8 b6 fe ff ff       	call   802df4 <addToAvailMemBlocksList>
  802f3e:	83 c4 10             	add    $0x10,%esp
		}
	}

	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  802f41:	e9 72 03 00 00       	jmp    8032b8 <insert_sorted_with_merge_freeList+0x444>
		if (last->sva + last->size == blockToInsert->sva) {
			last->size = last->size + blockToInsert->size;
			addToAvailMemBlocksList(blockToInsert);

		} else {
			LIST_INSERT_AFTER(&FreeMemBlocksList, last, blockToInsert);
  802f46:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802f4a:	74 06                	je     802f52 <insert_sorted_with_merge_freeList+0xde>
  802f4c:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802f50:	75 17                	jne    802f69 <insert_sorted_with_merge_freeList+0xf5>
  802f52:	83 ec 04             	sub    $0x4,%esp
  802f55:	68 d4 3d 80 00       	push   $0x803dd4
  802f5a:	68 24 01 00 00       	push   $0x124
  802f5f:	68 97 3d 80 00       	push   $0x803d97
  802f64:	e8 78 d7 ff ff       	call   8006e1 <_panic>
  802f69:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802f6c:	8b 10                	mov    (%eax),%edx
  802f6e:	8b 45 08             	mov    0x8(%ebp),%eax
  802f71:	89 10                	mov    %edx,(%eax)
  802f73:	8b 45 08             	mov    0x8(%ebp),%eax
  802f76:	8b 00                	mov    (%eax),%eax
  802f78:	85 c0                	test   %eax,%eax
  802f7a:	74 0b                	je     802f87 <insert_sorted_with_merge_freeList+0x113>
  802f7c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802f7f:	8b 00                	mov    (%eax),%eax
  802f81:	8b 55 08             	mov    0x8(%ebp),%edx
  802f84:	89 50 04             	mov    %edx,0x4(%eax)
  802f87:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802f8a:	8b 55 08             	mov    0x8(%ebp),%edx
  802f8d:	89 10                	mov    %edx,(%eax)
  802f8f:	8b 45 08             	mov    0x8(%ebp),%eax
  802f92:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802f95:	89 50 04             	mov    %edx,0x4(%eax)
  802f98:	8b 45 08             	mov    0x8(%ebp),%eax
  802f9b:	8b 00                	mov    (%eax),%eax
  802f9d:	85 c0                	test   %eax,%eax
  802f9f:	75 08                	jne    802fa9 <insert_sorted_with_merge_freeList+0x135>
  802fa1:	8b 45 08             	mov    0x8(%ebp),%eax
  802fa4:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802fa9:	a1 44 41 80 00       	mov    0x804144,%eax
  802fae:	40                   	inc    %eax
  802faf:	a3 44 41 80 00       	mov    %eax,0x804144
		}
	}

	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  802fb4:	e9 ff 02 00 00       	jmp    8032b8 <insert_sorted_with_merge_freeList+0x444>
		} else {
			LIST_INSERT_AFTER(&FreeMemBlocksList, last, blockToInsert);
		}
	} else {
		struct MemBlock *iterator;
		LIST_FOREACH(iterator, &(FreeMemBlocksList))
  802fb9:	a1 38 41 80 00       	mov    0x804138,%eax
  802fbe:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802fc1:	e9 c2 02 00 00       	jmp    803288 <insert_sorted_with_merge_freeList+0x414>
		{

			if (iterator->sva > blockToInsert->sva) {
  802fc6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802fc9:	8b 50 08             	mov    0x8(%eax),%edx
  802fcc:	8b 45 08             	mov    0x8(%ebp),%eax
  802fcf:	8b 40 08             	mov    0x8(%eax),%eax
  802fd2:	39 c2                	cmp    %eax,%edx
  802fd4:	0f 86 a6 02 00 00    	jbe    803280 <insert_sorted_with_merge_freeList+0x40c>

				struct MemBlock* prev = LIST_PREV(iterator);
  802fda:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802fdd:	8b 40 04             	mov    0x4(%eax),%eax
  802fe0:	89 45 ec             	mov    %eax,-0x14(%ebp)
				if (prev == NULL) {
  802fe3:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802fe7:	0f 85 ba 00 00 00    	jne    8030a7 <insert_sorted_with_merge_freeList+0x233>
					//check merge
					if (blockToInsert->size + blockToInsert->sva
  802fed:	8b 45 08             	mov    0x8(%ebp),%eax
  802ff0:	8b 50 0c             	mov    0xc(%eax),%edx
  802ff3:	8b 45 08             	mov    0x8(%ebp),%eax
  802ff6:	8b 40 08             	mov    0x8(%eax),%eax
  802ff9:	01 c2                	add    %eax,%edx
							== iterator->sva) {
  802ffb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ffe:	8b 40 08             	mov    0x8(%eax),%eax
			if (iterator->sva > blockToInsert->sva) {

				struct MemBlock* prev = LIST_PREV(iterator);
				if (prev == NULL) {
					//check merge
					if (blockToInsert->size + blockToInsert->sva
  803001:	39 c2                	cmp    %eax,%edx
  803003:	75 33                	jne    803038 <insert_sorted_with_merge_freeList+0x1c4>
							== iterator->sva) {
						iterator->sva = blockToInsert->sva;
  803005:	8b 45 08             	mov    0x8(%ebp),%eax
  803008:	8b 50 08             	mov    0x8(%eax),%edx
  80300b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80300e:	89 50 08             	mov    %edx,0x8(%eax)
						iterator->size = iterator->size + blockToInsert->size;
  803011:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803014:	8b 50 0c             	mov    0xc(%eax),%edx
  803017:	8b 45 08             	mov    0x8(%ebp),%eax
  80301a:	8b 40 0c             	mov    0xc(%eax),%eax
  80301d:	01 c2                	add    %eax,%edx
  80301f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803022:	89 50 0c             	mov    %edx,0xc(%eax)
						addToAvailMemBlocksList(blockToInsert);
  803025:	83 ec 0c             	sub    $0xc,%esp
  803028:	ff 75 08             	pushl  0x8(%ebp)
  80302b:	e8 c4 fd ff ff       	call   802df4 <addToAvailMemBlocksList>
  803030:	83 c4 10             	add    $0x10,%esp

					else {
						LIST_INSERT_BEFORE(&FreeMemBlocksList, iterator,
								blockToInsert);
					}
					break;
  803033:	e9 80 02 00 00       	jmp    8032b8 <insert_sorted_with_merge_freeList+0x444>
						addToAvailMemBlocksList(blockToInsert);

					}

					else {
						LIST_INSERT_BEFORE(&FreeMemBlocksList, iterator,
  803038:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80303c:	74 06                	je     803044 <insert_sorted_with_merge_freeList+0x1d0>
  80303e:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803042:	75 17                	jne    80305b <insert_sorted_with_merge_freeList+0x1e7>
  803044:	83 ec 04             	sub    $0x4,%esp
  803047:	68 28 3e 80 00       	push   $0x803e28
  80304c:	68 3a 01 00 00       	push   $0x13a
  803051:	68 97 3d 80 00       	push   $0x803d97
  803056:	e8 86 d6 ff ff       	call   8006e1 <_panic>
  80305b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80305e:	8b 50 04             	mov    0x4(%eax),%edx
  803061:	8b 45 08             	mov    0x8(%ebp),%eax
  803064:	89 50 04             	mov    %edx,0x4(%eax)
  803067:	8b 45 08             	mov    0x8(%ebp),%eax
  80306a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80306d:	89 10                	mov    %edx,(%eax)
  80306f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803072:	8b 40 04             	mov    0x4(%eax),%eax
  803075:	85 c0                	test   %eax,%eax
  803077:	74 0d                	je     803086 <insert_sorted_with_merge_freeList+0x212>
  803079:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80307c:	8b 40 04             	mov    0x4(%eax),%eax
  80307f:	8b 55 08             	mov    0x8(%ebp),%edx
  803082:	89 10                	mov    %edx,(%eax)
  803084:	eb 08                	jmp    80308e <insert_sorted_with_merge_freeList+0x21a>
  803086:	8b 45 08             	mov    0x8(%ebp),%eax
  803089:	a3 38 41 80 00       	mov    %eax,0x804138
  80308e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803091:	8b 55 08             	mov    0x8(%ebp),%edx
  803094:	89 50 04             	mov    %edx,0x4(%eax)
  803097:	a1 44 41 80 00       	mov    0x804144,%eax
  80309c:	40                   	inc    %eax
  80309d:	a3 44 41 80 00       	mov    %eax,0x804144
								blockToInsert);
					}
					break;
  8030a2:	e9 11 02 00 00       	jmp    8032b8 <insert_sorted_with_merge_freeList+0x444>
				} else {
					//prev and next merge
					if (prev->sva + prev->size + blockToInsert->size
  8030a7:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8030aa:	8b 50 08             	mov    0x8(%eax),%edx
  8030ad:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8030b0:	8b 40 0c             	mov    0xc(%eax),%eax
  8030b3:	01 c2                	add    %eax,%edx
  8030b5:	8b 45 08             	mov    0x8(%ebp),%eax
  8030b8:	8b 40 0c             	mov    0xc(%eax),%eax
  8030bb:	01 c2                	add    %eax,%edx
							== iterator->sva) {
  8030bd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030c0:	8b 40 08             	mov    0x8(%eax),%eax
								blockToInsert);
					}
					break;
				} else {
					//prev and next merge
					if (prev->sva + prev->size + blockToInsert->size
  8030c3:	39 c2                	cmp    %eax,%edx
  8030c5:	0f 85 bf 00 00 00    	jne    80318a <insert_sorted_with_merge_freeList+0x316>
							== iterator->sva) {
						prev->size = prev->size + blockToInsert->size
  8030cb:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8030ce:	8b 50 0c             	mov    0xc(%eax),%edx
  8030d1:	8b 45 08             	mov    0x8(%ebp),%eax
  8030d4:	8b 40 0c             	mov    0xc(%eax),%eax
  8030d7:	01 c2                	add    %eax,%edx
								+ iterator->size;
  8030d9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030dc:	8b 40 0c             	mov    0xc(%eax),%eax
  8030df:	01 c2                	add    %eax,%edx
					break;
				} else {
					//prev and next merge
					if (prev->sva + prev->size + blockToInsert->size
							== iterator->sva) {
						prev->size = prev->size + blockToInsert->size
  8030e1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8030e4:	89 50 0c             	mov    %edx,0xc(%eax)
								+ iterator->size;
						LIST_REMOVE(&FreeMemBlocksList, iterator);
  8030e7:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8030eb:	75 17                	jne    803104 <insert_sorted_with_merge_freeList+0x290>
  8030ed:	83 ec 04             	sub    $0x4,%esp
  8030f0:	68 08 3e 80 00       	push   $0x803e08
  8030f5:	68 43 01 00 00       	push   $0x143
  8030fa:	68 97 3d 80 00       	push   $0x803d97
  8030ff:	e8 dd d5 ff ff       	call   8006e1 <_panic>
  803104:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803107:	8b 00                	mov    (%eax),%eax
  803109:	85 c0                	test   %eax,%eax
  80310b:	74 10                	je     80311d <insert_sorted_with_merge_freeList+0x2a9>
  80310d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803110:	8b 00                	mov    (%eax),%eax
  803112:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803115:	8b 52 04             	mov    0x4(%edx),%edx
  803118:	89 50 04             	mov    %edx,0x4(%eax)
  80311b:	eb 0b                	jmp    803128 <insert_sorted_with_merge_freeList+0x2b4>
  80311d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803120:	8b 40 04             	mov    0x4(%eax),%eax
  803123:	a3 3c 41 80 00       	mov    %eax,0x80413c
  803128:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80312b:	8b 40 04             	mov    0x4(%eax),%eax
  80312e:	85 c0                	test   %eax,%eax
  803130:	74 0f                	je     803141 <insert_sorted_with_merge_freeList+0x2cd>
  803132:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803135:	8b 40 04             	mov    0x4(%eax),%eax
  803138:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80313b:	8b 12                	mov    (%edx),%edx
  80313d:	89 10                	mov    %edx,(%eax)
  80313f:	eb 0a                	jmp    80314b <insert_sorted_with_merge_freeList+0x2d7>
  803141:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803144:	8b 00                	mov    (%eax),%eax
  803146:	a3 38 41 80 00       	mov    %eax,0x804138
  80314b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80314e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803154:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803157:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80315e:	a1 44 41 80 00       	mov    0x804144,%eax
  803163:	48                   	dec    %eax
  803164:	a3 44 41 80 00       	mov    %eax,0x804144
						addToAvailMemBlocksList(blockToInsert);
  803169:	83 ec 0c             	sub    $0xc,%esp
  80316c:	ff 75 08             	pushl  0x8(%ebp)
  80316f:	e8 80 fc ff ff       	call   802df4 <addToAvailMemBlocksList>
  803174:	83 c4 10             	add    $0x10,%esp
						addToAvailMemBlocksList(iterator);
  803177:	83 ec 0c             	sub    $0xc,%esp
  80317a:	ff 75 f4             	pushl  -0xc(%ebp)
  80317d:	e8 72 fc ff ff       	call   802df4 <addToAvailMemBlocksList>
  803182:	83 c4 10             	add    $0x10,%esp
					//Insert
					else {
						LIST_INSERT_BEFORE(&FreeMemBlocksList, iterator,
								blockToInsert);
					}
					break;
  803185:	e9 2e 01 00 00       	jmp    8032b8 <insert_sorted_with_merge_freeList+0x444>
						LIST_REMOVE(&FreeMemBlocksList, iterator);
						addToAvailMemBlocksList(blockToInsert);
						addToAvailMemBlocksList(iterator);
					}
					//previous merge
					else if (prev->sva + prev->size == blockToInsert->sva) {
  80318a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80318d:	8b 50 08             	mov    0x8(%eax),%edx
  803190:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803193:	8b 40 0c             	mov    0xc(%eax),%eax
  803196:	01 c2                	add    %eax,%edx
  803198:	8b 45 08             	mov    0x8(%ebp),%eax
  80319b:	8b 40 08             	mov    0x8(%eax),%eax
  80319e:	39 c2                	cmp    %eax,%edx
  8031a0:	75 27                	jne    8031c9 <insert_sorted_with_merge_freeList+0x355>
						prev->size = prev->size + blockToInsert->size;
  8031a2:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8031a5:	8b 50 0c             	mov    0xc(%eax),%edx
  8031a8:	8b 45 08             	mov    0x8(%ebp),%eax
  8031ab:	8b 40 0c             	mov    0xc(%eax),%eax
  8031ae:	01 c2                	add    %eax,%edx
  8031b0:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8031b3:	89 50 0c             	mov    %edx,0xc(%eax)
						addToAvailMemBlocksList(blockToInsert);
  8031b6:	83 ec 0c             	sub    $0xc,%esp
  8031b9:	ff 75 08             	pushl  0x8(%ebp)
  8031bc:	e8 33 fc ff ff       	call   802df4 <addToAvailMemBlocksList>
  8031c1:	83 c4 10             	add    $0x10,%esp
					//Insert
					else {
						LIST_INSERT_BEFORE(&FreeMemBlocksList, iterator,
								blockToInsert);
					}
					break;
  8031c4:	e9 ef 00 00 00       	jmp    8032b8 <insert_sorted_with_merge_freeList+0x444>
					else if (prev->sva + prev->size == blockToInsert->sva) {
						prev->size = prev->size + blockToInsert->size;
						addToAvailMemBlocksList(blockToInsert);
					}
					//next merge
					else if (blockToInsert->size + blockToInsert->sva
  8031c9:	8b 45 08             	mov    0x8(%ebp),%eax
  8031cc:	8b 50 0c             	mov    0xc(%eax),%edx
  8031cf:	8b 45 08             	mov    0x8(%ebp),%eax
  8031d2:	8b 40 08             	mov    0x8(%eax),%eax
  8031d5:	01 c2                	add    %eax,%edx
							== iterator->sva) {
  8031d7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8031da:	8b 40 08             	mov    0x8(%eax),%eax
					else if (prev->sva + prev->size == blockToInsert->sva) {
						prev->size = prev->size + blockToInsert->size;
						addToAvailMemBlocksList(blockToInsert);
					}
					//next merge
					else if (blockToInsert->size + blockToInsert->sva
  8031dd:	39 c2                	cmp    %eax,%edx
  8031df:	75 33                	jne    803214 <insert_sorted_with_merge_freeList+0x3a0>
							== iterator->sva) {
						iterator->sva = blockToInsert->sva;
  8031e1:	8b 45 08             	mov    0x8(%ebp),%eax
  8031e4:	8b 50 08             	mov    0x8(%eax),%edx
  8031e7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8031ea:	89 50 08             	mov    %edx,0x8(%eax)
						iterator->size = iterator->size + blockToInsert->size;
  8031ed:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8031f0:	8b 50 0c             	mov    0xc(%eax),%edx
  8031f3:	8b 45 08             	mov    0x8(%ebp),%eax
  8031f6:	8b 40 0c             	mov    0xc(%eax),%eax
  8031f9:	01 c2                	add    %eax,%edx
  8031fb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8031fe:	89 50 0c             	mov    %edx,0xc(%eax)
						addToAvailMemBlocksList(blockToInsert);
  803201:	83 ec 0c             	sub    $0xc,%esp
  803204:	ff 75 08             	pushl  0x8(%ebp)
  803207:	e8 e8 fb ff ff       	call   802df4 <addToAvailMemBlocksList>
  80320c:	83 c4 10             	add    $0x10,%esp
					//Insert
					else {
						LIST_INSERT_BEFORE(&FreeMemBlocksList, iterator,
								blockToInsert);
					}
					break;
  80320f:	e9 a4 00 00 00       	jmp    8032b8 <insert_sorted_with_merge_freeList+0x444>
						iterator->size = iterator->size + blockToInsert->size;
						addToAvailMemBlocksList(blockToInsert);
					}
					//Insert
					else {
						LIST_INSERT_BEFORE(&FreeMemBlocksList, iterator,
  803214:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803218:	74 06                	je     803220 <insert_sorted_with_merge_freeList+0x3ac>
  80321a:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80321e:	75 17                	jne    803237 <insert_sorted_with_merge_freeList+0x3c3>
  803220:	83 ec 04             	sub    $0x4,%esp
  803223:	68 28 3e 80 00       	push   $0x803e28
  803228:	68 56 01 00 00       	push   $0x156
  80322d:	68 97 3d 80 00       	push   $0x803d97
  803232:	e8 aa d4 ff ff       	call   8006e1 <_panic>
  803237:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80323a:	8b 50 04             	mov    0x4(%eax),%edx
  80323d:	8b 45 08             	mov    0x8(%ebp),%eax
  803240:	89 50 04             	mov    %edx,0x4(%eax)
  803243:	8b 45 08             	mov    0x8(%ebp),%eax
  803246:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803249:	89 10                	mov    %edx,(%eax)
  80324b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80324e:	8b 40 04             	mov    0x4(%eax),%eax
  803251:	85 c0                	test   %eax,%eax
  803253:	74 0d                	je     803262 <insert_sorted_with_merge_freeList+0x3ee>
  803255:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803258:	8b 40 04             	mov    0x4(%eax),%eax
  80325b:	8b 55 08             	mov    0x8(%ebp),%edx
  80325e:	89 10                	mov    %edx,(%eax)
  803260:	eb 08                	jmp    80326a <insert_sorted_with_merge_freeList+0x3f6>
  803262:	8b 45 08             	mov    0x8(%ebp),%eax
  803265:	a3 38 41 80 00       	mov    %eax,0x804138
  80326a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80326d:	8b 55 08             	mov    0x8(%ebp),%edx
  803270:	89 50 04             	mov    %edx,0x4(%eax)
  803273:	a1 44 41 80 00       	mov    0x804144,%eax
  803278:	40                   	inc    %eax
  803279:	a3 44 41 80 00       	mov    %eax,0x804144
								blockToInsert);
					}
					break;
  80327e:	eb 38                	jmp    8032b8 <insert_sorted_with_merge_freeList+0x444>
		} else {
			LIST_INSERT_AFTER(&FreeMemBlocksList, last, blockToInsert);
		}
	} else {
		struct MemBlock *iterator;
		LIST_FOREACH(iterator, &(FreeMemBlocksList))
  803280:	a1 40 41 80 00       	mov    0x804140,%eax
  803285:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803288:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80328c:	74 07                	je     803295 <insert_sorted_with_merge_freeList+0x421>
  80328e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803291:	8b 00                	mov    (%eax),%eax
  803293:	eb 05                	jmp    80329a <insert_sorted_with_merge_freeList+0x426>
  803295:	b8 00 00 00 00       	mov    $0x0,%eax
  80329a:	a3 40 41 80 00       	mov    %eax,0x804140
  80329f:	a1 40 41 80 00       	mov    0x804140,%eax
  8032a4:	85 c0                	test   %eax,%eax
  8032a6:	0f 85 1a fd ff ff    	jne    802fc6 <insert_sorted_with_merge_freeList+0x152>
  8032ac:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8032b0:	0f 85 10 fd ff ff    	jne    802fc6 <insert_sorted_with_merge_freeList+0x152>
		}
	}

	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  8032b6:	eb 00                	jmp    8032b8 <insert_sorted_with_merge_freeList+0x444>
  8032b8:	90                   	nop
  8032b9:	c9                   	leave  
  8032ba:	c3                   	ret    
  8032bb:	90                   	nop

008032bc <__udivdi3>:
  8032bc:	55                   	push   %ebp
  8032bd:	57                   	push   %edi
  8032be:	56                   	push   %esi
  8032bf:	53                   	push   %ebx
  8032c0:	83 ec 1c             	sub    $0x1c,%esp
  8032c3:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  8032c7:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  8032cb:	8b 7c 24 38          	mov    0x38(%esp),%edi
  8032cf:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8032d3:	89 ca                	mov    %ecx,%edx
  8032d5:	89 f8                	mov    %edi,%eax
  8032d7:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  8032db:	85 f6                	test   %esi,%esi
  8032dd:	75 2d                	jne    80330c <__udivdi3+0x50>
  8032df:	39 cf                	cmp    %ecx,%edi
  8032e1:	77 65                	ja     803348 <__udivdi3+0x8c>
  8032e3:	89 fd                	mov    %edi,%ebp
  8032e5:	85 ff                	test   %edi,%edi
  8032e7:	75 0b                	jne    8032f4 <__udivdi3+0x38>
  8032e9:	b8 01 00 00 00       	mov    $0x1,%eax
  8032ee:	31 d2                	xor    %edx,%edx
  8032f0:	f7 f7                	div    %edi
  8032f2:	89 c5                	mov    %eax,%ebp
  8032f4:	31 d2                	xor    %edx,%edx
  8032f6:	89 c8                	mov    %ecx,%eax
  8032f8:	f7 f5                	div    %ebp
  8032fa:	89 c1                	mov    %eax,%ecx
  8032fc:	89 d8                	mov    %ebx,%eax
  8032fe:	f7 f5                	div    %ebp
  803300:	89 cf                	mov    %ecx,%edi
  803302:	89 fa                	mov    %edi,%edx
  803304:	83 c4 1c             	add    $0x1c,%esp
  803307:	5b                   	pop    %ebx
  803308:	5e                   	pop    %esi
  803309:	5f                   	pop    %edi
  80330a:	5d                   	pop    %ebp
  80330b:	c3                   	ret    
  80330c:	39 ce                	cmp    %ecx,%esi
  80330e:	77 28                	ja     803338 <__udivdi3+0x7c>
  803310:	0f bd fe             	bsr    %esi,%edi
  803313:	83 f7 1f             	xor    $0x1f,%edi
  803316:	75 40                	jne    803358 <__udivdi3+0x9c>
  803318:	39 ce                	cmp    %ecx,%esi
  80331a:	72 0a                	jb     803326 <__udivdi3+0x6a>
  80331c:	3b 44 24 08          	cmp    0x8(%esp),%eax
  803320:	0f 87 9e 00 00 00    	ja     8033c4 <__udivdi3+0x108>
  803326:	b8 01 00 00 00       	mov    $0x1,%eax
  80332b:	89 fa                	mov    %edi,%edx
  80332d:	83 c4 1c             	add    $0x1c,%esp
  803330:	5b                   	pop    %ebx
  803331:	5e                   	pop    %esi
  803332:	5f                   	pop    %edi
  803333:	5d                   	pop    %ebp
  803334:	c3                   	ret    
  803335:	8d 76 00             	lea    0x0(%esi),%esi
  803338:	31 ff                	xor    %edi,%edi
  80333a:	31 c0                	xor    %eax,%eax
  80333c:	89 fa                	mov    %edi,%edx
  80333e:	83 c4 1c             	add    $0x1c,%esp
  803341:	5b                   	pop    %ebx
  803342:	5e                   	pop    %esi
  803343:	5f                   	pop    %edi
  803344:	5d                   	pop    %ebp
  803345:	c3                   	ret    
  803346:	66 90                	xchg   %ax,%ax
  803348:	89 d8                	mov    %ebx,%eax
  80334a:	f7 f7                	div    %edi
  80334c:	31 ff                	xor    %edi,%edi
  80334e:	89 fa                	mov    %edi,%edx
  803350:	83 c4 1c             	add    $0x1c,%esp
  803353:	5b                   	pop    %ebx
  803354:	5e                   	pop    %esi
  803355:	5f                   	pop    %edi
  803356:	5d                   	pop    %ebp
  803357:	c3                   	ret    
  803358:	bd 20 00 00 00       	mov    $0x20,%ebp
  80335d:	89 eb                	mov    %ebp,%ebx
  80335f:	29 fb                	sub    %edi,%ebx
  803361:	89 f9                	mov    %edi,%ecx
  803363:	d3 e6                	shl    %cl,%esi
  803365:	89 c5                	mov    %eax,%ebp
  803367:	88 d9                	mov    %bl,%cl
  803369:	d3 ed                	shr    %cl,%ebp
  80336b:	89 e9                	mov    %ebp,%ecx
  80336d:	09 f1                	or     %esi,%ecx
  80336f:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  803373:	89 f9                	mov    %edi,%ecx
  803375:	d3 e0                	shl    %cl,%eax
  803377:	89 c5                	mov    %eax,%ebp
  803379:	89 d6                	mov    %edx,%esi
  80337b:	88 d9                	mov    %bl,%cl
  80337d:	d3 ee                	shr    %cl,%esi
  80337f:	89 f9                	mov    %edi,%ecx
  803381:	d3 e2                	shl    %cl,%edx
  803383:	8b 44 24 08          	mov    0x8(%esp),%eax
  803387:	88 d9                	mov    %bl,%cl
  803389:	d3 e8                	shr    %cl,%eax
  80338b:	09 c2                	or     %eax,%edx
  80338d:	89 d0                	mov    %edx,%eax
  80338f:	89 f2                	mov    %esi,%edx
  803391:	f7 74 24 0c          	divl   0xc(%esp)
  803395:	89 d6                	mov    %edx,%esi
  803397:	89 c3                	mov    %eax,%ebx
  803399:	f7 e5                	mul    %ebp
  80339b:	39 d6                	cmp    %edx,%esi
  80339d:	72 19                	jb     8033b8 <__udivdi3+0xfc>
  80339f:	74 0b                	je     8033ac <__udivdi3+0xf0>
  8033a1:	89 d8                	mov    %ebx,%eax
  8033a3:	31 ff                	xor    %edi,%edi
  8033a5:	e9 58 ff ff ff       	jmp    803302 <__udivdi3+0x46>
  8033aa:	66 90                	xchg   %ax,%ax
  8033ac:	8b 54 24 08          	mov    0x8(%esp),%edx
  8033b0:	89 f9                	mov    %edi,%ecx
  8033b2:	d3 e2                	shl    %cl,%edx
  8033b4:	39 c2                	cmp    %eax,%edx
  8033b6:	73 e9                	jae    8033a1 <__udivdi3+0xe5>
  8033b8:	8d 43 ff             	lea    -0x1(%ebx),%eax
  8033bb:	31 ff                	xor    %edi,%edi
  8033bd:	e9 40 ff ff ff       	jmp    803302 <__udivdi3+0x46>
  8033c2:	66 90                	xchg   %ax,%ax
  8033c4:	31 c0                	xor    %eax,%eax
  8033c6:	e9 37 ff ff ff       	jmp    803302 <__udivdi3+0x46>
  8033cb:	90                   	nop

008033cc <__umoddi3>:
  8033cc:	55                   	push   %ebp
  8033cd:	57                   	push   %edi
  8033ce:	56                   	push   %esi
  8033cf:	53                   	push   %ebx
  8033d0:	83 ec 1c             	sub    $0x1c,%esp
  8033d3:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  8033d7:	8b 74 24 34          	mov    0x34(%esp),%esi
  8033db:	8b 7c 24 38          	mov    0x38(%esp),%edi
  8033df:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  8033e3:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8033e7:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8033eb:	89 f3                	mov    %esi,%ebx
  8033ed:	89 fa                	mov    %edi,%edx
  8033ef:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8033f3:	89 34 24             	mov    %esi,(%esp)
  8033f6:	85 c0                	test   %eax,%eax
  8033f8:	75 1a                	jne    803414 <__umoddi3+0x48>
  8033fa:	39 f7                	cmp    %esi,%edi
  8033fc:	0f 86 a2 00 00 00    	jbe    8034a4 <__umoddi3+0xd8>
  803402:	89 c8                	mov    %ecx,%eax
  803404:	89 f2                	mov    %esi,%edx
  803406:	f7 f7                	div    %edi
  803408:	89 d0                	mov    %edx,%eax
  80340a:	31 d2                	xor    %edx,%edx
  80340c:	83 c4 1c             	add    $0x1c,%esp
  80340f:	5b                   	pop    %ebx
  803410:	5e                   	pop    %esi
  803411:	5f                   	pop    %edi
  803412:	5d                   	pop    %ebp
  803413:	c3                   	ret    
  803414:	39 f0                	cmp    %esi,%eax
  803416:	0f 87 ac 00 00 00    	ja     8034c8 <__umoddi3+0xfc>
  80341c:	0f bd e8             	bsr    %eax,%ebp
  80341f:	83 f5 1f             	xor    $0x1f,%ebp
  803422:	0f 84 ac 00 00 00    	je     8034d4 <__umoddi3+0x108>
  803428:	bf 20 00 00 00       	mov    $0x20,%edi
  80342d:	29 ef                	sub    %ebp,%edi
  80342f:	89 fe                	mov    %edi,%esi
  803431:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  803435:	89 e9                	mov    %ebp,%ecx
  803437:	d3 e0                	shl    %cl,%eax
  803439:	89 d7                	mov    %edx,%edi
  80343b:	89 f1                	mov    %esi,%ecx
  80343d:	d3 ef                	shr    %cl,%edi
  80343f:	09 c7                	or     %eax,%edi
  803441:	89 e9                	mov    %ebp,%ecx
  803443:	d3 e2                	shl    %cl,%edx
  803445:	89 14 24             	mov    %edx,(%esp)
  803448:	89 d8                	mov    %ebx,%eax
  80344a:	d3 e0                	shl    %cl,%eax
  80344c:	89 c2                	mov    %eax,%edx
  80344e:	8b 44 24 08          	mov    0x8(%esp),%eax
  803452:	d3 e0                	shl    %cl,%eax
  803454:	89 44 24 04          	mov    %eax,0x4(%esp)
  803458:	8b 44 24 08          	mov    0x8(%esp),%eax
  80345c:	89 f1                	mov    %esi,%ecx
  80345e:	d3 e8                	shr    %cl,%eax
  803460:	09 d0                	or     %edx,%eax
  803462:	d3 eb                	shr    %cl,%ebx
  803464:	89 da                	mov    %ebx,%edx
  803466:	f7 f7                	div    %edi
  803468:	89 d3                	mov    %edx,%ebx
  80346a:	f7 24 24             	mull   (%esp)
  80346d:	89 c6                	mov    %eax,%esi
  80346f:	89 d1                	mov    %edx,%ecx
  803471:	39 d3                	cmp    %edx,%ebx
  803473:	0f 82 87 00 00 00    	jb     803500 <__umoddi3+0x134>
  803479:	0f 84 91 00 00 00    	je     803510 <__umoddi3+0x144>
  80347f:	8b 54 24 04          	mov    0x4(%esp),%edx
  803483:	29 f2                	sub    %esi,%edx
  803485:	19 cb                	sbb    %ecx,%ebx
  803487:	89 d8                	mov    %ebx,%eax
  803489:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  80348d:	d3 e0                	shl    %cl,%eax
  80348f:	89 e9                	mov    %ebp,%ecx
  803491:	d3 ea                	shr    %cl,%edx
  803493:	09 d0                	or     %edx,%eax
  803495:	89 e9                	mov    %ebp,%ecx
  803497:	d3 eb                	shr    %cl,%ebx
  803499:	89 da                	mov    %ebx,%edx
  80349b:	83 c4 1c             	add    $0x1c,%esp
  80349e:	5b                   	pop    %ebx
  80349f:	5e                   	pop    %esi
  8034a0:	5f                   	pop    %edi
  8034a1:	5d                   	pop    %ebp
  8034a2:	c3                   	ret    
  8034a3:	90                   	nop
  8034a4:	89 fd                	mov    %edi,%ebp
  8034a6:	85 ff                	test   %edi,%edi
  8034a8:	75 0b                	jne    8034b5 <__umoddi3+0xe9>
  8034aa:	b8 01 00 00 00       	mov    $0x1,%eax
  8034af:	31 d2                	xor    %edx,%edx
  8034b1:	f7 f7                	div    %edi
  8034b3:	89 c5                	mov    %eax,%ebp
  8034b5:	89 f0                	mov    %esi,%eax
  8034b7:	31 d2                	xor    %edx,%edx
  8034b9:	f7 f5                	div    %ebp
  8034bb:	89 c8                	mov    %ecx,%eax
  8034bd:	f7 f5                	div    %ebp
  8034bf:	89 d0                	mov    %edx,%eax
  8034c1:	e9 44 ff ff ff       	jmp    80340a <__umoddi3+0x3e>
  8034c6:	66 90                	xchg   %ax,%ax
  8034c8:	89 c8                	mov    %ecx,%eax
  8034ca:	89 f2                	mov    %esi,%edx
  8034cc:	83 c4 1c             	add    $0x1c,%esp
  8034cf:	5b                   	pop    %ebx
  8034d0:	5e                   	pop    %esi
  8034d1:	5f                   	pop    %edi
  8034d2:	5d                   	pop    %ebp
  8034d3:	c3                   	ret    
  8034d4:	3b 04 24             	cmp    (%esp),%eax
  8034d7:	72 06                	jb     8034df <__umoddi3+0x113>
  8034d9:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  8034dd:	77 0f                	ja     8034ee <__umoddi3+0x122>
  8034df:	89 f2                	mov    %esi,%edx
  8034e1:	29 f9                	sub    %edi,%ecx
  8034e3:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  8034e7:	89 14 24             	mov    %edx,(%esp)
  8034ea:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8034ee:	8b 44 24 04          	mov    0x4(%esp),%eax
  8034f2:	8b 14 24             	mov    (%esp),%edx
  8034f5:	83 c4 1c             	add    $0x1c,%esp
  8034f8:	5b                   	pop    %ebx
  8034f9:	5e                   	pop    %esi
  8034fa:	5f                   	pop    %edi
  8034fb:	5d                   	pop    %ebp
  8034fc:	c3                   	ret    
  8034fd:	8d 76 00             	lea    0x0(%esi),%esi
  803500:	2b 04 24             	sub    (%esp),%eax
  803503:	19 fa                	sbb    %edi,%edx
  803505:	89 d1                	mov    %edx,%ecx
  803507:	89 c6                	mov    %eax,%esi
  803509:	e9 71 ff ff ff       	jmp    80347f <__umoddi3+0xb3>
  80350e:	66 90                	xchg   %ax,%ax
  803510:	39 44 24 04          	cmp    %eax,0x4(%esp)
  803514:	72 ea                	jb     803500 <__umoddi3+0x134>
  803516:	89 d9                	mov    %ebx,%ecx
  803518:	e9 62 ff ff ff       	jmp    80347f <__umoddi3+0xb3>
