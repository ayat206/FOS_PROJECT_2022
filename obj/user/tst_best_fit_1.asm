
obj/user/tst_best_fit_1:     file format elf32-i386


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
  800031:	e8 d2 0a 00 00       	call   800b08 <libmain>
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
  80003c:	53                   	push   %ebx
  80003d:	83 ec 70             	sub    $0x70,%esp
	sys_set_uheap_strategy(UHP_PLACE_BESTFIT);
  800040:	83 ec 0c             	sub    $0xc,%esp
  800043:	6a 02                	push   $0x2
  800045:	e8 61 27 00 00       	call   8027ab <sys_set_uheap_strategy>
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
  80009b:	68 a0 3a 80 00       	push   $0x803aa0
  8000a0:	6a 15                	push   $0x15
  8000a2:	68 bc 3a 80 00       	push   $0x803abc
  8000a7:	e8 98 0b 00 00       	call   800c44 <_panic>
	}
	/*Dummy malloc to enforce the UHEAP initializations*/
	malloc(0);
  8000ac:	83 ec 0c             	sub    $0xc,%esp
  8000af:	6a 00                	push   $0x0
  8000b1:	e8 d4 1d 00 00       	call   801e8a <malloc>
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
	int freeFrames ;
	int usedDiskPages;
	//[1] Allocate all
	{
		//Allocate 3 MB
		freeFrames = sys_calculate_free_frames() ;
  8000d8:	e8 b9 21 00 00       	call   802296 <sys_calculate_free_frames>
  8000dd:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  8000e0:	e8 51 22 00 00       	call   802336 <sys_pf_calculate_allocated_pages>
  8000e5:	89 45 e0             	mov    %eax,-0x20(%ebp)
		ptr_allocations[0] = malloc(3*Mega-kilo);
  8000e8:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8000eb:	89 c2                	mov    %eax,%edx
  8000ed:	01 d2                	add    %edx,%edx
  8000ef:	01 d0                	add    %edx,%eax
  8000f1:	2b 45 e8             	sub    -0x18(%ebp),%eax
  8000f4:	83 ec 0c             	sub    $0xc,%esp
  8000f7:	50                   	push   %eax
  8000f8:	e8 8d 1d 00 00       	call   801e8a <malloc>
  8000fd:	83 c4 10             	add    $0x10,%esp
  800100:	89 45 90             	mov    %eax,-0x70(%ebp)
		if ((uint32) ptr_allocations[0] != (USER_HEAP_START)) panic("Wrong start address for the allocated space... ");
  800103:	8b 45 90             	mov    -0x70(%ebp),%eax
  800106:	3d 00 00 00 80       	cmp    $0x80000000,%eax
  80010b:	74 14                	je     800121 <_main+0xe9>
  80010d:	83 ec 04             	sub    $0x4,%esp
  800110:	68 d4 3a 80 00       	push   $0x803ad4
  800115:	6a 26                	push   $0x26
  800117:	68 bc 3a 80 00       	push   $0x803abc
  80011c:	e8 23 0b 00 00       	call   800c44 <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 256+1 ) panic("Wrong allocation: ");
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  3*256) panic("Wrong page file allocation: ");
  800121:	e8 10 22 00 00       	call   802336 <sys_pf_calculate_allocated_pages>
  800126:	2b 45 e0             	sub    -0x20(%ebp),%eax
  800129:	3d 00 03 00 00       	cmp    $0x300,%eax
  80012e:	74 14                	je     800144 <_main+0x10c>
  800130:	83 ec 04             	sub    $0x4,%esp
  800133:	68 04 3b 80 00       	push   $0x803b04
  800138:	6a 28                	push   $0x28
  80013a:	68 bc 3a 80 00       	push   $0x803abc
  80013f:	e8 00 0b 00 00       	call   800c44 <_panic>
		if ((freeFrames - sys_calculate_free_frames()) != 1 ) panic("Wrong allocation: ");
  800144:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
  800147:	e8 4a 21 00 00       	call   802296 <sys_calculate_free_frames>
  80014c:	29 c3                	sub    %eax,%ebx
  80014e:	89 d8                	mov    %ebx,%eax
  800150:	83 f8 01             	cmp    $0x1,%eax
  800153:	74 14                	je     800169 <_main+0x131>
  800155:	83 ec 04             	sub    $0x4,%esp
  800158:	68 21 3b 80 00       	push   $0x803b21
  80015d:	6a 29                	push   $0x29
  80015f:	68 bc 3a 80 00       	push   $0x803abc
  800164:	e8 db 0a 00 00       	call   800c44 <_panic>

		//Allocate 3 MB
		freeFrames = sys_calculate_free_frames() ;
  800169:	e8 28 21 00 00       	call   802296 <sys_calculate_free_frames>
  80016e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  800171:	e8 c0 21 00 00       	call   802336 <sys_pf_calculate_allocated_pages>
  800176:	89 45 e0             	mov    %eax,-0x20(%ebp)
		ptr_allocations[1] = malloc(3*Mega-kilo);
  800179:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80017c:	89 c2                	mov    %eax,%edx
  80017e:	01 d2                	add    %edx,%edx
  800180:	01 d0                	add    %edx,%eax
  800182:	2b 45 e8             	sub    -0x18(%ebp),%eax
  800185:	83 ec 0c             	sub    $0xc,%esp
  800188:	50                   	push   %eax
  800189:	e8 fc 1c 00 00       	call   801e8a <malloc>
  80018e:	83 c4 10             	add    $0x10,%esp
  800191:	89 45 94             	mov    %eax,-0x6c(%ebp)
		if ((uint32) ptr_allocations[1] !=  (USER_HEAP_START + 3*Mega)) panic("Wrong start address for the allocated space... ");
  800194:	8b 45 94             	mov    -0x6c(%ebp),%eax
  800197:	89 c1                	mov    %eax,%ecx
  800199:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80019c:	89 c2                	mov    %eax,%edx
  80019e:	01 d2                	add    %edx,%edx
  8001a0:	01 d0                	add    %edx,%eax
  8001a2:	05 00 00 00 80       	add    $0x80000000,%eax
  8001a7:	39 c1                	cmp    %eax,%ecx
  8001a9:	74 14                	je     8001bf <_main+0x187>
  8001ab:	83 ec 04             	sub    $0x4,%esp
  8001ae:	68 d4 3a 80 00       	push   $0x803ad4
  8001b3:	6a 2f                	push   $0x2f
  8001b5:	68 bc 3a 80 00       	push   $0x803abc
  8001ba:	e8 85 0a 00 00       	call   800c44 <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 256 ) panic("Wrong allocation: ");
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  3*256) panic("Wrong page file allocation: ");
  8001bf:	e8 72 21 00 00       	call   802336 <sys_pf_calculate_allocated_pages>
  8001c4:	2b 45 e0             	sub    -0x20(%ebp),%eax
  8001c7:	3d 00 03 00 00       	cmp    $0x300,%eax
  8001cc:	74 14                	je     8001e2 <_main+0x1aa>
  8001ce:	83 ec 04             	sub    $0x4,%esp
  8001d1:	68 04 3b 80 00       	push   $0x803b04
  8001d6:	6a 31                	push   $0x31
  8001d8:	68 bc 3a 80 00       	push   $0x803abc
  8001dd:	e8 62 0a 00 00       	call   800c44 <_panic>
		if ((freeFrames - sys_calculate_free_frames()) != 1 ) panic("Wrong allocation: ");
  8001e2:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
  8001e5:	e8 ac 20 00 00       	call   802296 <sys_calculate_free_frames>
  8001ea:	29 c3                	sub    %eax,%ebx
  8001ec:	89 d8                	mov    %ebx,%eax
  8001ee:	83 f8 01             	cmp    $0x1,%eax
  8001f1:	74 14                	je     800207 <_main+0x1cf>
  8001f3:	83 ec 04             	sub    $0x4,%esp
  8001f6:	68 21 3b 80 00       	push   $0x803b21
  8001fb:	6a 32                	push   $0x32
  8001fd:	68 bc 3a 80 00       	push   $0x803abc
  800202:	e8 3d 0a 00 00       	call   800c44 <_panic>

		//Allocate 2 MB
		freeFrames = sys_calculate_free_frames() ;
  800207:	e8 8a 20 00 00       	call   802296 <sys_calculate_free_frames>
  80020c:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  80020f:	e8 22 21 00 00       	call   802336 <sys_pf_calculate_allocated_pages>
  800214:	89 45 e0             	mov    %eax,-0x20(%ebp)
		ptr_allocations[2] = malloc(2*Mega-kilo);
  800217:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80021a:	01 c0                	add    %eax,%eax
  80021c:	2b 45 e8             	sub    -0x18(%ebp),%eax
  80021f:	83 ec 0c             	sub    $0xc,%esp
  800222:	50                   	push   %eax
  800223:	e8 62 1c 00 00       	call   801e8a <malloc>
  800228:	83 c4 10             	add    $0x10,%esp
  80022b:	89 45 98             	mov    %eax,-0x68(%ebp)
		if ((uint32) ptr_allocations[2] !=  (USER_HEAP_START + 6*Mega)) panic("Wrong start address for the allocated space... ");
  80022e:	8b 45 98             	mov    -0x68(%ebp),%eax
  800231:	89 c1                	mov    %eax,%ecx
  800233:	8b 55 ec             	mov    -0x14(%ebp),%edx
  800236:	89 d0                	mov    %edx,%eax
  800238:	01 c0                	add    %eax,%eax
  80023a:	01 d0                	add    %edx,%eax
  80023c:	01 c0                	add    %eax,%eax
  80023e:	05 00 00 00 80       	add    $0x80000000,%eax
  800243:	39 c1                	cmp    %eax,%ecx
  800245:	74 14                	je     80025b <_main+0x223>
  800247:	83 ec 04             	sub    $0x4,%esp
  80024a:	68 d4 3a 80 00       	push   $0x803ad4
  80024f:	6a 38                	push   $0x38
  800251:	68 bc 3a 80 00       	push   $0x803abc
  800256:	e8 e9 09 00 00       	call   800c44 <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 256 ) panic("Wrong allocation: ");
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  2*256) panic("Wrong page file allocation: ");
  80025b:	e8 d6 20 00 00       	call   802336 <sys_pf_calculate_allocated_pages>
  800260:	2b 45 e0             	sub    -0x20(%ebp),%eax
  800263:	3d 00 02 00 00       	cmp    $0x200,%eax
  800268:	74 14                	je     80027e <_main+0x246>
  80026a:	83 ec 04             	sub    $0x4,%esp
  80026d:	68 04 3b 80 00       	push   $0x803b04
  800272:	6a 3a                	push   $0x3a
  800274:	68 bc 3a 80 00       	push   $0x803abc
  800279:	e8 c6 09 00 00       	call   800c44 <_panic>
		if ((freeFrames - sys_calculate_free_frames()) != 0 ) panic("Wrong allocation: ");
  80027e:	e8 13 20 00 00       	call   802296 <sys_calculate_free_frames>
  800283:	89 c2                	mov    %eax,%edx
  800285:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800288:	39 c2                	cmp    %eax,%edx
  80028a:	74 14                	je     8002a0 <_main+0x268>
  80028c:	83 ec 04             	sub    $0x4,%esp
  80028f:	68 21 3b 80 00       	push   $0x803b21
  800294:	6a 3b                	push   $0x3b
  800296:	68 bc 3a 80 00       	push   $0x803abc
  80029b:	e8 a4 09 00 00       	call   800c44 <_panic>

		//Allocate 2 MB
		freeFrames = sys_calculate_free_frames() ;
  8002a0:	e8 f1 1f 00 00       	call   802296 <sys_calculate_free_frames>
  8002a5:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  8002a8:	e8 89 20 00 00       	call   802336 <sys_pf_calculate_allocated_pages>
  8002ad:	89 45 e0             	mov    %eax,-0x20(%ebp)
		ptr_allocations[3] = malloc(2*Mega-kilo);
  8002b0:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8002b3:	01 c0                	add    %eax,%eax
  8002b5:	2b 45 e8             	sub    -0x18(%ebp),%eax
  8002b8:	83 ec 0c             	sub    $0xc,%esp
  8002bb:	50                   	push   %eax
  8002bc:	e8 c9 1b 00 00       	call   801e8a <malloc>
  8002c1:	83 c4 10             	add    $0x10,%esp
  8002c4:	89 45 9c             	mov    %eax,-0x64(%ebp)
		if ((uint32) ptr_allocations[3] != (USER_HEAP_START + 8*Mega)) panic("Wrong start address for the allocated space... ");
  8002c7:	8b 45 9c             	mov    -0x64(%ebp),%eax
  8002ca:	89 c2                	mov    %eax,%edx
  8002cc:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8002cf:	c1 e0 03             	shl    $0x3,%eax
  8002d2:	05 00 00 00 80       	add    $0x80000000,%eax
  8002d7:	39 c2                	cmp    %eax,%edx
  8002d9:	74 14                	je     8002ef <_main+0x2b7>
  8002db:	83 ec 04             	sub    $0x4,%esp
  8002de:	68 d4 3a 80 00       	push   $0x803ad4
  8002e3:	6a 41                	push   $0x41
  8002e5:	68 bc 3a 80 00       	push   $0x803abc
  8002ea:	e8 55 09 00 00       	call   800c44 <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 256 ) panic("Wrong allocation: ");
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  2*256) panic("Wrong page file allocation: ");
  8002ef:	e8 42 20 00 00       	call   802336 <sys_pf_calculate_allocated_pages>
  8002f4:	2b 45 e0             	sub    -0x20(%ebp),%eax
  8002f7:	3d 00 02 00 00       	cmp    $0x200,%eax
  8002fc:	74 14                	je     800312 <_main+0x2da>
  8002fe:	83 ec 04             	sub    $0x4,%esp
  800301:	68 04 3b 80 00       	push   $0x803b04
  800306:	6a 43                	push   $0x43
  800308:	68 bc 3a 80 00       	push   $0x803abc
  80030d:	e8 32 09 00 00       	call   800c44 <_panic>
		if ((freeFrames - sys_calculate_free_frames()) != 1 ) panic("Wrong allocation: ");
  800312:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
  800315:	e8 7c 1f 00 00       	call   802296 <sys_calculate_free_frames>
  80031a:	29 c3                	sub    %eax,%ebx
  80031c:	89 d8                	mov    %ebx,%eax
  80031e:	83 f8 01             	cmp    $0x1,%eax
  800321:	74 14                	je     800337 <_main+0x2ff>
  800323:	83 ec 04             	sub    $0x4,%esp
  800326:	68 21 3b 80 00       	push   $0x803b21
  80032b:	6a 44                	push   $0x44
  80032d:	68 bc 3a 80 00       	push   $0x803abc
  800332:	e8 0d 09 00 00       	call   800c44 <_panic>

		//Allocate 1 MB
		freeFrames = sys_calculate_free_frames() ;
  800337:	e8 5a 1f 00 00       	call   802296 <sys_calculate_free_frames>
  80033c:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  80033f:	e8 f2 1f 00 00       	call   802336 <sys_pf_calculate_allocated_pages>
  800344:	89 45 e0             	mov    %eax,-0x20(%ebp)
		ptr_allocations[4] = malloc(1*Mega-kilo);
  800347:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80034a:	2b 45 e8             	sub    -0x18(%ebp),%eax
  80034d:	83 ec 0c             	sub    $0xc,%esp
  800350:	50                   	push   %eax
  800351:	e8 34 1b 00 00       	call   801e8a <malloc>
  800356:	83 c4 10             	add    $0x10,%esp
  800359:	89 45 a0             	mov    %eax,-0x60(%ebp)
		if ((uint32) ptr_allocations[4] !=  (USER_HEAP_START + 10*Mega) ) panic("Wrong start address for the allocated space... ");
  80035c:	8b 45 a0             	mov    -0x60(%ebp),%eax
  80035f:	89 c1                	mov    %eax,%ecx
  800361:	8b 55 ec             	mov    -0x14(%ebp),%edx
  800364:	89 d0                	mov    %edx,%eax
  800366:	c1 e0 02             	shl    $0x2,%eax
  800369:	01 d0                	add    %edx,%eax
  80036b:	01 c0                	add    %eax,%eax
  80036d:	05 00 00 00 80       	add    $0x80000000,%eax
  800372:	39 c1                	cmp    %eax,%ecx
  800374:	74 14                	je     80038a <_main+0x352>
  800376:	83 ec 04             	sub    $0x4,%esp
  800379:	68 d4 3a 80 00       	push   $0x803ad4
  80037e:	6a 4a                	push   $0x4a
  800380:	68 bc 3a 80 00       	push   $0x803abc
  800385:	e8 ba 08 00 00       	call   800c44 <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 512 + 1) panic("Wrong allocation: ");
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  256) panic("Wrong page file allocation: ");
  80038a:	e8 a7 1f 00 00       	call   802336 <sys_pf_calculate_allocated_pages>
  80038f:	2b 45 e0             	sub    -0x20(%ebp),%eax
  800392:	3d 00 01 00 00       	cmp    $0x100,%eax
  800397:	74 14                	je     8003ad <_main+0x375>
  800399:	83 ec 04             	sub    $0x4,%esp
  80039c:	68 04 3b 80 00       	push   $0x803b04
  8003a1:	6a 4c                	push   $0x4c
  8003a3:	68 bc 3a 80 00       	push   $0x803abc
  8003a8:	e8 97 08 00 00       	call   800c44 <_panic>
		if ((freeFrames - sys_calculate_free_frames()) != 0) panic("Wrong allocation: ");
  8003ad:	e8 e4 1e 00 00       	call   802296 <sys_calculate_free_frames>
  8003b2:	89 c2                	mov    %eax,%edx
  8003b4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8003b7:	39 c2                	cmp    %eax,%edx
  8003b9:	74 14                	je     8003cf <_main+0x397>
  8003bb:	83 ec 04             	sub    $0x4,%esp
  8003be:	68 21 3b 80 00       	push   $0x803b21
  8003c3:	6a 4d                	push   $0x4d
  8003c5:	68 bc 3a 80 00       	push   $0x803abc
  8003ca:	e8 75 08 00 00       	call   800c44 <_panic>

		//Allocate 1 MB
		freeFrames = sys_calculate_free_frames() ;
  8003cf:	e8 c2 1e 00 00       	call   802296 <sys_calculate_free_frames>
  8003d4:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  8003d7:	e8 5a 1f 00 00       	call   802336 <sys_pf_calculate_allocated_pages>
  8003dc:	89 45 e0             	mov    %eax,-0x20(%ebp)
		ptr_allocations[5] = malloc(1*Mega-kilo);
  8003df:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8003e2:	2b 45 e8             	sub    -0x18(%ebp),%eax
  8003e5:	83 ec 0c             	sub    $0xc,%esp
  8003e8:	50                   	push   %eax
  8003e9:	e8 9c 1a 00 00       	call   801e8a <malloc>
  8003ee:	83 c4 10             	add    $0x10,%esp
  8003f1:	89 45 a4             	mov    %eax,-0x5c(%ebp)
		if ((uint32) ptr_allocations[5] != (USER_HEAP_START + 11*Mega) ) panic("Wrong start address for the allocated space... ");
  8003f4:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  8003f7:	89 c1                	mov    %eax,%ecx
  8003f9:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8003fc:	89 d0                	mov    %edx,%eax
  8003fe:	c1 e0 02             	shl    $0x2,%eax
  800401:	01 d0                	add    %edx,%eax
  800403:	01 c0                	add    %eax,%eax
  800405:	01 d0                	add    %edx,%eax
  800407:	05 00 00 00 80       	add    $0x80000000,%eax
  80040c:	39 c1                	cmp    %eax,%ecx
  80040e:	74 14                	je     800424 <_main+0x3ec>
  800410:	83 ec 04             	sub    $0x4,%esp
  800413:	68 d4 3a 80 00       	push   $0x803ad4
  800418:	6a 53                	push   $0x53
  80041a:	68 bc 3a 80 00       	push   $0x803abc
  80041f:	e8 20 08 00 00       	call   800c44 <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 512) panic("Wrong allocation: ");
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  256) panic("Wrong page file allocation: ");
  800424:	e8 0d 1f 00 00       	call   802336 <sys_pf_calculate_allocated_pages>
  800429:	2b 45 e0             	sub    -0x20(%ebp),%eax
  80042c:	3d 00 01 00 00       	cmp    $0x100,%eax
  800431:	74 14                	je     800447 <_main+0x40f>
  800433:	83 ec 04             	sub    $0x4,%esp
  800436:	68 04 3b 80 00       	push   $0x803b04
  80043b:	6a 55                	push   $0x55
  80043d:	68 bc 3a 80 00       	push   $0x803abc
  800442:	e8 fd 07 00 00       	call   800c44 <_panic>
		if ((freeFrames - sys_calculate_free_frames()) != 0) panic("Wrong allocation: ");
  800447:	e8 4a 1e 00 00       	call   802296 <sys_calculate_free_frames>
  80044c:	89 c2                	mov    %eax,%edx
  80044e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800451:	39 c2                	cmp    %eax,%edx
  800453:	74 14                	je     800469 <_main+0x431>
  800455:	83 ec 04             	sub    $0x4,%esp
  800458:	68 21 3b 80 00       	push   $0x803b21
  80045d:	6a 56                	push   $0x56
  80045f:	68 bc 3a 80 00       	push   $0x803abc
  800464:	e8 db 07 00 00       	call   800c44 <_panic>

		//Allocate 1 MB
		freeFrames = sys_calculate_free_frames() ;
  800469:	e8 28 1e 00 00       	call   802296 <sys_calculate_free_frames>
  80046e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  800471:	e8 c0 1e 00 00       	call   802336 <sys_pf_calculate_allocated_pages>
  800476:	89 45 e0             	mov    %eax,-0x20(%ebp)
		ptr_allocations[6] = malloc(1*Mega-kilo);
  800479:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80047c:	2b 45 e8             	sub    -0x18(%ebp),%eax
  80047f:	83 ec 0c             	sub    $0xc,%esp
  800482:	50                   	push   %eax
  800483:	e8 02 1a 00 00       	call   801e8a <malloc>
  800488:	83 c4 10             	add    $0x10,%esp
  80048b:	89 45 a8             	mov    %eax,-0x58(%ebp)
		if ((uint32) ptr_allocations[6] != (USER_HEAP_START + 12*Mega) ) panic("Wrong start address for the allocated space... ");
  80048e:	8b 45 a8             	mov    -0x58(%ebp),%eax
  800491:	89 c1                	mov    %eax,%ecx
  800493:	8b 55 ec             	mov    -0x14(%ebp),%edx
  800496:	89 d0                	mov    %edx,%eax
  800498:	01 c0                	add    %eax,%eax
  80049a:	01 d0                	add    %edx,%eax
  80049c:	c1 e0 02             	shl    $0x2,%eax
  80049f:	05 00 00 00 80       	add    $0x80000000,%eax
  8004a4:	39 c1                	cmp    %eax,%ecx
  8004a6:	74 14                	je     8004bc <_main+0x484>
  8004a8:	83 ec 04             	sub    $0x4,%esp
  8004ab:	68 d4 3a 80 00       	push   $0x803ad4
  8004b0:	6a 5c                	push   $0x5c
  8004b2:	68 bc 3a 80 00       	push   $0x803abc
  8004b7:	e8 88 07 00 00       	call   800c44 <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 768 + 1) panic("Wrong allocation: ");
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  256) panic("Wrong page file allocation: ");
  8004bc:	e8 75 1e 00 00       	call   802336 <sys_pf_calculate_allocated_pages>
  8004c1:	2b 45 e0             	sub    -0x20(%ebp),%eax
  8004c4:	3d 00 01 00 00       	cmp    $0x100,%eax
  8004c9:	74 14                	je     8004df <_main+0x4a7>
  8004cb:	83 ec 04             	sub    $0x4,%esp
  8004ce:	68 04 3b 80 00       	push   $0x803b04
  8004d3:	6a 5e                	push   $0x5e
  8004d5:	68 bc 3a 80 00       	push   $0x803abc
  8004da:	e8 65 07 00 00       	call   800c44 <_panic>
		if ((freeFrames - sys_calculate_free_frames()) != 1) panic("Wrong allocation: ");
  8004df:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
  8004e2:	e8 af 1d 00 00       	call   802296 <sys_calculate_free_frames>
  8004e7:	29 c3                	sub    %eax,%ebx
  8004e9:	89 d8                	mov    %ebx,%eax
  8004eb:	83 f8 01             	cmp    $0x1,%eax
  8004ee:	74 14                	je     800504 <_main+0x4cc>
  8004f0:	83 ec 04             	sub    $0x4,%esp
  8004f3:	68 21 3b 80 00       	push   $0x803b21
  8004f8:	6a 5f                	push   $0x5f
  8004fa:	68 bc 3a 80 00       	push   $0x803abc
  8004ff:	e8 40 07 00 00       	call   800c44 <_panic>

		//Allocate 1 MB
		freeFrames = sys_calculate_free_frames() ;
  800504:	e8 8d 1d 00 00       	call   802296 <sys_calculate_free_frames>
  800509:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  80050c:	e8 25 1e 00 00       	call   802336 <sys_pf_calculate_allocated_pages>
  800511:	89 45 e0             	mov    %eax,-0x20(%ebp)
		ptr_allocations[7] = malloc(1*Mega-kilo);
  800514:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800517:	2b 45 e8             	sub    -0x18(%ebp),%eax
  80051a:	83 ec 0c             	sub    $0xc,%esp
  80051d:	50                   	push   %eax
  80051e:	e8 67 19 00 00       	call   801e8a <malloc>
  800523:	83 c4 10             	add    $0x10,%esp
  800526:	89 45 ac             	mov    %eax,-0x54(%ebp)
		if ((uint32) ptr_allocations[7] != (USER_HEAP_START + 13*Mega)) panic("Wrong start address for the allocated space... ");
  800529:	8b 45 ac             	mov    -0x54(%ebp),%eax
  80052c:	89 c1                	mov    %eax,%ecx
  80052e:	8b 55 ec             	mov    -0x14(%ebp),%edx
  800531:	89 d0                	mov    %edx,%eax
  800533:	01 c0                	add    %eax,%eax
  800535:	01 d0                	add    %edx,%eax
  800537:	c1 e0 02             	shl    $0x2,%eax
  80053a:	01 d0                	add    %edx,%eax
  80053c:	05 00 00 00 80       	add    $0x80000000,%eax
  800541:	39 c1                	cmp    %eax,%ecx
  800543:	74 14                	je     800559 <_main+0x521>
  800545:	83 ec 04             	sub    $0x4,%esp
  800548:	68 d4 3a 80 00       	push   $0x803ad4
  80054d:	6a 65                	push   $0x65
  80054f:	68 bc 3a 80 00       	push   $0x803abc
  800554:	e8 eb 06 00 00       	call   800c44 <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 768 + 1) panic("Wrong allocation: ");
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  256) panic("Wrong page file allocation: ");
  800559:	e8 d8 1d 00 00       	call   802336 <sys_pf_calculate_allocated_pages>
  80055e:	2b 45 e0             	sub    -0x20(%ebp),%eax
  800561:	3d 00 01 00 00       	cmp    $0x100,%eax
  800566:	74 14                	je     80057c <_main+0x544>
  800568:	83 ec 04             	sub    $0x4,%esp
  80056b:	68 04 3b 80 00       	push   $0x803b04
  800570:	6a 67                	push   $0x67
  800572:	68 bc 3a 80 00       	push   $0x803abc
  800577:	e8 c8 06 00 00       	call   800c44 <_panic>
		if ((freeFrames - sys_calculate_free_frames()) != 0) panic("Wrong allocation: ");
  80057c:	e8 15 1d 00 00       	call   802296 <sys_calculate_free_frames>
  800581:	89 c2                	mov    %eax,%edx
  800583:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800586:	39 c2                	cmp    %eax,%edx
  800588:	74 14                	je     80059e <_main+0x566>
  80058a:	83 ec 04             	sub    $0x4,%esp
  80058d:	68 21 3b 80 00       	push   $0x803b21
  800592:	6a 68                	push   $0x68
  800594:	68 bc 3a 80 00       	push   $0x803abc
  800599:	e8 a6 06 00 00       	call   800c44 <_panic>
	}

	//[2] Free some to create holes
	{
		//3 MB Hole
		freeFrames = sys_calculate_free_frames() ;
  80059e:	e8 f3 1c 00 00       	call   802296 <sys_calculate_free_frames>
  8005a3:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  8005a6:	e8 8b 1d 00 00       	call   802336 <sys_pf_calculate_allocated_pages>
  8005ab:	89 45 e0             	mov    %eax,-0x20(%ebp)
		free(ptr_allocations[1]);
  8005ae:	8b 45 94             	mov    -0x6c(%ebp),%eax
  8005b1:	83 ec 0c             	sub    $0xc,%esp
  8005b4:	50                   	push   %eax
  8005b5:	e8 51 19 00 00       	call   801f0b <free>
  8005ba:	83 c4 10             	add    $0x10,%esp
		//if ((sys_calculate_free_frames() - freeFrames) != 256) panic("Wrong free: ");
		if( (usedDiskPages - sys_pf_calculate_allocated_pages()) !=  3*256) panic("Wrong page file free: ");
  8005bd:	e8 74 1d 00 00       	call   802336 <sys_pf_calculate_allocated_pages>
  8005c2:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8005c5:	29 c2                	sub    %eax,%edx
  8005c7:	89 d0                	mov    %edx,%eax
  8005c9:	3d 00 03 00 00       	cmp    $0x300,%eax
  8005ce:	74 14                	je     8005e4 <_main+0x5ac>
  8005d0:	83 ec 04             	sub    $0x4,%esp
  8005d3:	68 34 3b 80 00       	push   $0x803b34
  8005d8:	6a 72                	push   $0x72
  8005da:	68 bc 3a 80 00       	push   $0x803abc
  8005df:	e8 60 06 00 00       	call   800c44 <_panic>
		if ((sys_calculate_free_frames() - freeFrames) != 0) panic("Wrong free: ");
  8005e4:	e8 ad 1c 00 00       	call   802296 <sys_calculate_free_frames>
  8005e9:	89 c2                	mov    %eax,%edx
  8005eb:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8005ee:	39 c2                	cmp    %eax,%edx
  8005f0:	74 14                	je     800606 <_main+0x5ce>
  8005f2:	83 ec 04             	sub    $0x4,%esp
  8005f5:	68 4b 3b 80 00       	push   $0x803b4b
  8005fa:	6a 73                	push   $0x73
  8005fc:	68 bc 3a 80 00       	push   $0x803abc
  800601:	e8 3e 06 00 00       	call   800c44 <_panic>

		//2 MB Hole
		freeFrames = sys_calculate_free_frames() ;
  800606:	e8 8b 1c 00 00       	call   802296 <sys_calculate_free_frames>
  80060b:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  80060e:	e8 23 1d 00 00       	call   802336 <sys_pf_calculate_allocated_pages>
  800613:	89 45 e0             	mov    %eax,-0x20(%ebp)
		free(ptr_allocations[3]);
  800616:	8b 45 9c             	mov    -0x64(%ebp),%eax
  800619:	83 ec 0c             	sub    $0xc,%esp
  80061c:	50                   	push   %eax
  80061d:	e8 e9 18 00 00       	call   801f0b <free>
  800622:	83 c4 10             	add    $0x10,%esp
		//if ((sys_calculate_free_frames() - freeFrames) != 512) panic("Wrong free: ");
		if( (usedDiskPages - sys_pf_calculate_allocated_pages()) !=  2*256) panic("Wrong page file free: ");
  800625:	e8 0c 1d 00 00       	call   802336 <sys_pf_calculate_allocated_pages>
  80062a:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80062d:	29 c2                	sub    %eax,%edx
  80062f:	89 d0                	mov    %edx,%eax
  800631:	3d 00 02 00 00       	cmp    $0x200,%eax
  800636:	74 14                	je     80064c <_main+0x614>
  800638:	83 ec 04             	sub    $0x4,%esp
  80063b:	68 34 3b 80 00       	push   $0x803b34
  800640:	6a 7a                	push   $0x7a
  800642:	68 bc 3a 80 00       	push   $0x803abc
  800647:	e8 f8 05 00 00       	call   800c44 <_panic>
		if ((sys_calculate_free_frames() - freeFrames) != 0) panic("Wrong free: ");
  80064c:	e8 45 1c 00 00       	call   802296 <sys_calculate_free_frames>
  800651:	89 c2                	mov    %eax,%edx
  800653:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800656:	39 c2                	cmp    %eax,%edx
  800658:	74 14                	je     80066e <_main+0x636>
  80065a:	83 ec 04             	sub    $0x4,%esp
  80065d:	68 4b 3b 80 00       	push   $0x803b4b
  800662:	6a 7b                	push   $0x7b
  800664:	68 bc 3a 80 00       	push   $0x803abc
  800669:	e8 d6 05 00 00       	call   800c44 <_panic>

		//1 MB Hole
		freeFrames = sys_calculate_free_frames() ;
  80066e:	e8 23 1c 00 00       	call   802296 <sys_calculate_free_frames>
  800673:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  800676:	e8 bb 1c 00 00       	call   802336 <sys_pf_calculate_allocated_pages>
  80067b:	89 45 e0             	mov    %eax,-0x20(%ebp)
		free(ptr_allocations[5]);
  80067e:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  800681:	83 ec 0c             	sub    $0xc,%esp
  800684:	50                   	push   %eax
  800685:	e8 81 18 00 00       	call   801f0b <free>
  80068a:	83 c4 10             	add    $0x10,%esp
		//if ((sys_calculate_free_frames() - freeFrames) != 768) panic("Wrong free: ");
		if( (usedDiskPages - sys_pf_calculate_allocated_pages()) !=  256) panic("Wrong page file free: ");
  80068d:	e8 a4 1c 00 00       	call   802336 <sys_pf_calculate_allocated_pages>
  800692:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800695:	29 c2                	sub    %eax,%edx
  800697:	89 d0                	mov    %edx,%eax
  800699:	3d 00 01 00 00       	cmp    $0x100,%eax
  80069e:	74 17                	je     8006b7 <_main+0x67f>
  8006a0:	83 ec 04             	sub    $0x4,%esp
  8006a3:	68 34 3b 80 00       	push   $0x803b34
  8006a8:	68 82 00 00 00       	push   $0x82
  8006ad:	68 bc 3a 80 00       	push   $0x803abc
  8006b2:	e8 8d 05 00 00       	call   800c44 <_panic>
		if ((sys_calculate_free_frames() - freeFrames) != 0) panic("Wrong free: ");
  8006b7:	e8 da 1b 00 00       	call   802296 <sys_calculate_free_frames>
  8006bc:	89 c2                	mov    %eax,%edx
  8006be:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8006c1:	39 c2                	cmp    %eax,%edx
  8006c3:	74 17                	je     8006dc <_main+0x6a4>
  8006c5:	83 ec 04             	sub    $0x4,%esp
  8006c8:	68 4b 3b 80 00       	push   $0x803b4b
  8006cd:	68 83 00 00 00       	push   $0x83
  8006d2:	68 bc 3a 80 00       	push   $0x803abc
  8006d7:	e8 68 05 00 00       	call   800c44 <_panic>
	}

	//[3] Allocate again [test best fit]
	{
		//Allocate 512 KB - should be placed in 3rd hole
		freeFrames = sys_calculate_free_frames() ;
  8006dc:	e8 b5 1b 00 00       	call   802296 <sys_calculate_free_frames>
  8006e1:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  8006e4:	e8 4d 1c 00 00       	call   802336 <sys_pf_calculate_allocated_pages>
  8006e9:	89 45 e0             	mov    %eax,-0x20(%ebp)
		ptr_allocations[8] = malloc(512*kilo);
  8006ec:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8006ef:	c1 e0 09             	shl    $0x9,%eax
  8006f2:	83 ec 0c             	sub    $0xc,%esp
  8006f5:	50                   	push   %eax
  8006f6:	e8 8f 17 00 00       	call   801e8a <malloc>
  8006fb:	83 c4 10             	add    $0x10,%esp
  8006fe:	89 45 b0             	mov    %eax,-0x50(%ebp)
		if ((uint32) ptr_allocations[8] !=  (USER_HEAP_START + 11*Mega)) panic("Wrong start address for the allocated space... ");
  800701:	8b 45 b0             	mov    -0x50(%ebp),%eax
  800704:	89 c1                	mov    %eax,%ecx
  800706:	8b 55 ec             	mov    -0x14(%ebp),%edx
  800709:	89 d0                	mov    %edx,%eax
  80070b:	c1 e0 02             	shl    $0x2,%eax
  80070e:	01 d0                	add    %edx,%eax
  800710:	01 c0                	add    %eax,%eax
  800712:	01 d0                	add    %edx,%eax
  800714:	05 00 00 00 80       	add    $0x80000000,%eax
  800719:	39 c1                	cmp    %eax,%ecx
  80071b:	74 17                	je     800734 <_main+0x6fc>
  80071d:	83 ec 04             	sub    $0x4,%esp
  800720:	68 d4 3a 80 00       	push   $0x803ad4
  800725:	68 8c 00 00 00       	push   $0x8c
  80072a:	68 bc 3a 80 00       	push   $0x803abc
  80072f:	e8 10 05 00 00       	call   800c44 <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 128) panic("Wrong allocation: ");
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  128) panic("Wrong page file allocation: ");
  800734:	e8 fd 1b 00 00       	call   802336 <sys_pf_calculate_allocated_pages>
  800739:	2b 45 e0             	sub    -0x20(%ebp),%eax
  80073c:	3d 80 00 00 00       	cmp    $0x80,%eax
  800741:	74 17                	je     80075a <_main+0x722>
  800743:	83 ec 04             	sub    $0x4,%esp
  800746:	68 04 3b 80 00       	push   $0x803b04
  80074b:	68 8e 00 00 00       	push   $0x8e
  800750:	68 bc 3a 80 00       	push   $0x803abc
  800755:	e8 ea 04 00 00       	call   800c44 <_panic>
		if ((freeFrames - sys_calculate_free_frames()) != 0) panic("Wrong allocation: ");
  80075a:	e8 37 1b 00 00       	call   802296 <sys_calculate_free_frames>
  80075f:	89 c2                	mov    %eax,%edx
  800761:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800764:	39 c2                	cmp    %eax,%edx
  800766:	74 17                	je     80077f <_main+0x747>
  800768:	83 ec 04             	sub    $0x4,%esp
  80076b:	68 21 3b 80 00       	push   $0x803b21
  800770:	68 8f 00 00 00       	push   $0x8f
  800775:	68 bc 3a 80 00       	push   $0x803abc
  80077a:	e8 c5 04 00 00       	call   800c44 <_panic>

		//Allocate 1 MB - should be placed in 2nd hole
		freeFrames = sys_calculate_free_frames() ;
  80077f:	e8 12 1b 00 00       	call   802296 <sys_calculate_free_frames>
  800784:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  800787:	e8 aa 1b 00 00       	call   802336 <sys_pf_calculate_allocated_pages>
  80078c:	89 45 e0             	mov    %eax,-0x20(%ebp)
		ptr_allocations[9] = malloc(1*Mega - kilo);
  80078f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800792:	2b 45 e8             	sub    -0x18(%ebp),%eax
  800795:	83 ec 0c             	sub    $0xc,%esp
  800798:	50                   	push   %eax
  800799:	e8 ec 16 00 00       	call   801e8a <malloc>
  80079e:	83 c4 10             	add    $0x10,%esp
  8007a1:	89 45 b4             	mov    %eax,-0x4c(%ebp)
		if ((uint32) ptr_allocations[9] != (USER_HEAP_START + 8*Mega)) panic("Wrong start address for the allocated space... ");
  8007a4:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  8007a7:	89 c2                	mov    %eax,%edx
  8007a9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8007ac:	c1 e0 03             	shl    $0x3,%eax
  8007af:	05 00 00 00 80       	add    $0x80000000,%eax
  8007b4:	39 c2                	cmp    %eax,%edx
  8007b6:	74 17                	je     8007cf <_main+0x797>
  8007b8:	83 ec 04             	sub    $0x4,%esp
  8007bb:	68 d4 3a 80 00       	push   $0x803ad4
  8007c0:	68 95 00 00 00       	push   $0x95
  8007c5:	68 bc 3a 80 00       	push   $0x803abc
  8007ca:	e8 75 04 00 00       	call   800c44 <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 256) panic("Wrong allocation: ");
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  256) panic("Wrong page file allocation: ");
  8007cf:	e8 62 1b 00 00       	call   802336 <sys_pf_calculate_allocated_pages>
  8007d4:	2b 45 e0             	sub    -0x20(%ebp),%eax
  8007d7:	3d 00 01 00 00       	cmp    $0x100,%eax
  8007dc:	74 17                	je     8007f5 <_main+0x7bd>
  8007de:	83 ec 04             	sub    $0x4,%esp
  8007e1:	68 04 3b 80 00       	push   $0x803b04
  8007e6:	68 97 00 00 00       	push   $0x97
  8007eb:	68 bc 3a 80 00       	push   $0x803abc
  8007f0:	e8 4f 04 00 00       	call   800c44 <_panic>
		if ((freeFrames - sys_calculate_free_frames()) != 0) panic("Wrong allocation: ");
  8007f5:	e8 9c 1a 00 00       	call   802296 <sys_calculate_free_frames>
  8007fa:	89 c2                	mov    %eax,%edx
  8007fc:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8007ff:	39 c2                	cmp    %eax,%edx
  800801:	74 17                	je     80081a <_main+0x7e2>
  800803:	83 ec 04             	sub    $0x4,%esp
  800806:	68 21 3b 80 00       	push   $0x803b21
  80080b:	68 98 00 00 00       	push   $0x98
  800810:	68 bc 3a 80 00       	push   $0x803abc
  800815:	e8 2a 04 00 00       	call   800c44 <_panic>

		//Allocate 256 KB - should be placed in remaining of 3rd hole
		freeFrames = sys_calculate_free_frames() ;
  80081a:	e8 77 1a 00 00       	call   802296 <sys_calculate_free_frames>
  80081f:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  800822:	e8 0f 1b 00 00       	call   802336 <sys_pf_calculate_allocated_pages>
  800827:	89 45 e0             	mov    %eax,-0x20(%ebp)
		ptr_allocations[10] = malloc(256*kilo - kilo);
  80082a:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80082d:	89 d0                	mov    %edx,%eax
  80082f:	c1 e0 08             	shl    $0x8,%eax
  800832:	29 d0                	sub    %edx,%eax
  800834:	83 ec 0c             	sub    $0xc,%esp
  800837:	50                   	push   %eax
  800838:	e8 4d 16 00 00       	call   801e8a <malloc>
  80083d:	83 c4 10             	add    $0x10,%esp
  800840:	89 45 b8             	mov    %eax,-0x48(%ebp)
		if ((uint32) ptr_allocations[10] !=  (USER_HEAP_START + 11*Mega + 512*kilo)) panic("Wrong start address for the allocated space... ");
  800843:	8b 45 b8             	mov    -0x48(%ebp),%eax
  800846:	89 c1                	mov    %eax,%ecx
  800848:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80084b:	89 d0                	mov    %edx,%eax
  80084d:	c1 e0 02             	shl    $0x2,%eax
  800850:	01 d0                	add    %edx,%eax
  800852:	01 c0                	add    %eax,%eax
  800854:	01 d0                	add    %edx,%eax
  800856:	89 c2                	mov    %eax,%edx
  800858:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80085b:	c1 e0 09             	shl    $0x9,%eax
  80085e:	01 d0                	add    %edx,%eax
  800860:	05 00 00 00 80       	add    $0x80000000,%eax
  800865:	39 c1                	cmp    %eax,%ecx
  800867:	74 17                	je     800880 <_main+0x848>
  800869:	83 ec 04             	sub    $0x4,%esp
  80086c:	68 d4 3a 80 00       	push   $0x803ad4
  800871:	68 9e 00 00 00       	push   $0x9e
  800876:	68 bc 3a 80 00       	push   $0x803abc
  80087b:	e8 c4 03 00 00       	call   800c44 <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 64) panic("Wrong allocation: ");
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  64) panic("Wrong page file allocation: ");
  800880:	e8 b1 1a 00 00       	call   802336 <sys_pf_calculate_allocated_pages>
  800885:	2b 45 e0             	sub    -0x20(%ebp),%eax
  800888:	83 f8 40             	cmp    $0x40,%eax
  80088b:	74 17                	je     8008a4 <_main+0x86c>
  80088d:	83 ec 04             	sub    $0x4,%esp
  800890:	68 04 3b 80 00       	push   $0x803b04
  800895:	68 a0 00 00 00       	push   $0xa0
  80089a:	68 bc 3a 80 00       	push   $0x803abc
  80089f:	e8 a0 03 00 00       	call   800c44 <_panic>
		if ((freeFrames - sys_calculate_free_frames()) != 0) panic("Wrong allocation: ");
  8008a4:	e8 ed 19 00 00       	call   802296 <sys_calculate_free_frames>
  8008a9:	89 c2                	mov    %eax,%edx
  8008ab:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8008ae:	39 c2                	cmp    %eax,%edx
  8008b0:	74 17                	je     8008c9 <_main+0x891>
  8008b2:	83 ec 04             	sub    $0x4,%esp
  8008b5:	68 21 3b 80 00       	push   $0x803b21
  8008ba:	68 a1 00 00 00       	push   $0xa1
  8008bf:	68 bc 3a 80 00       	push   $0x803abc
  8008c4:	e8 7b 03 00 00       	call   800c44 <_panic>

		//Allocate 4 MB - should be placed in end of all allocations
		freeFrames = sys_calculate_free_frames() ;
  8008c9:	e8 c8 19 00 00       	call   802296 <sys_calculate_free_frames>
  8008ce:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  8008d1:	e8 60 1a 00 00       	call   802336 <sys_pf_calculate_allocated_pages>
  8008d6:	89 45 e0             	mov    %eax,-0x20(%ebp)
		ptr_allocations[11] = malloc(4*Mega - kilo);
  8008d9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8008dc:	c1 e0 02             	shl    $0x2,%eax
  8008df:	2b 45 e8             	sub    -0x18(%ebp),%eax
  8008e2:	83 ec 0c             	sub    $0xc,%esp
  8008e5:	50                   	push   %eax
  8008e6:	e8 9f 15 00 00       	call   801e8a <malloc>
  8008eb:	83 c4 10             	add    $0x10,%esp
  8008ee:	89 45 bc             	mov    %eax,-0x44(%ebp)
		if ((uint32) ptr_allocations[11] != (USER_HEAP_START + 14*Mega)) panic("Wrong start address for the allocated space... ");
  8008f1:	8b 45 bc             	mov    -0x44(%ebp),%eax
  8008f4:	89 c1                	mov    %eax,%ecx
  8008f6:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8008f9:	89 d0                	mov    %edx,%eax
  8008fb:	01 c0                	add    %eax,%eax
  8008fd:	01 d0                	add    %edx,%eax
  8008ff:	01 c0                	add    %eax,%eax
  800901:	01 d0                	add    %edx,%eax
  800903:	01 c0                	add    %eax,%eax
  800905:	05 00 00 00 80       	add    $0x80000000,%eax
  80090a:	39 c1                	cmp    %eax,%ecx
  80090c:	74 17                	je     800925 <_main+0x8ed>
  80090e:	83 ec 04             	sub    $0x4,%esp
  800911:	68 d4 3a 80 00       	push   $0x803ad4
  800916:	68 a7 00 00 00       	push   $0xa7
  80091b:	68 bc 3a 80 00       	push   $0x803abc
  800920:	e8 1f 03 00 00       	call   800c44 <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 1024 + 1) panic("Wrong allocation: ");
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  1024) panic("Wrong page file allocation: ");
  800925:	e8 0c 1a 00 00       	call   802336 <sys_pf_calculate_allocated_pages>
  80092a:	2b 45 e0             	sub    -0x20(%ebp),%eax
  80092d:	3d 00 04 00 00       	cmp    $0x400,%eax
  800932:	74 17                	je     80094b <_main+0x913>
  800934:	83 ec 04             	sub    $0x4,%esp
  800937:	68 04 3b 80 00       	push   $0x803b04
  80093c:	68 a9 00 00 00       	push   $0xa9
  800941:	68 bc 3a 80 00       	push   $0x803abc
  800946:	e8 f9 02 00 00       	call   800c44 <_panic>
		if ((freeFrames - sys_calculate_free_frames()) != 1) panic("Wrong allocation: ");
  80094b:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
  80094e:	e8 43 19 00 00       	call   802296 <sys_calculate_free_frames>
  800953:	29 c3                	sub    %eax,%ebx
  800955:	89 d8                	mov    %ebx,%eax
  800957:	83 f8 01             	cmp    $0x1,%eax
  80095a:	74 17                	je     800973 <_main+0x93b>
  80095c:	83 ec 04             	sub    $0x4,%esp
  80095f:	68 21 3b 80 00       	push   $0x803b21
  800964:	68 aa 00 00 00       	push   $0xaa
  800969:	68 bc 3a 80 00       	push   $0x803abc
  80096e:	e8 d1 02 00 00       	call   800c44 <_panic>
	}

	//[4] Free contiguous allocations
	{
		//1M Hole appended to already existing 1M hole in the middle
		freeFrames = sys_calculate_free_frames() ;
  800973:	e8 1e 19 00 00       	call   802296 <sys_calculate_free_frames>
  800978:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  80097b:	e8 b6 19 00 00       	call   802336 <sys_pf_calculate_allocated_pages>
  800980:	89 45 e0             	mov    %eax,-0x20(%ebp)
		free(ptr_allocations[4]);
  800983:	8b 45 a0             	mov    -0x60(%ebp),%eax
  800986:	83 ec 0c             	sub    $0xc,%esp
  800989:	50                   	push   %eax
  80098a:	e8 7c 15 00 00       	call   801f0b <free>
  80098f:	83 c4 10             	add    $0x10,%esp
		//if ((sys_calculate_free_frames() - freeFrames) != 256) panic("Wrong free: ");
		if( (usedDiskPages - sys_pf_calculate_allocated_pages()) !=  256) panic("Wrong page file free: ");
  800992:	e8 9f 19 00 00       	call   802336 <sys_pf_calculate_allocated_pages>
  800997:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80099a:	29 c2                	sub    %eax,%edx
  80099c:	89 d0                	mov    %edx,%eax
  80099e:	3d 00 01 00 00       	cmp    $0x100,%eax
  8009a3:	74 17                	je     8009bc <_main+0x984>
  8009a5:	83 ec 04             	sub    $0x4,%esp
  8009a8:	68 34 3b 80 00       	push   $0x803b34
  8009ad:	68 b4 00 00 00       	push   $0xb4
  8009b2:	68 bc 3a 80 00       	push   $0x803abc
  8009b7:	e8 88 02 00 00       	call   800c44 <_panic>
		if ((sys_calculate_free_frames() - freeFrames) != 0) panic("Wrong free: ");
  8009bc:	e8 d5 18 00 00       	call   802296 <sys_calculate_free_frames>
  8009c1:	89 c2                	mov    %eax,%edx
  8009c3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8009c6:	39 c2                	cmp    %eax,%edx
  8009c8:	74 17                	je     8009e1 <_main+0x9a9>
  8009ca:	83 ec 04             	sub    $0x4,%esp
  8009cd:	68 4b 3b 80 00       	push   $0x803b4b
  8009d2:	68 b5 00 00 00       	push   $0xb5
  8009d7:	68 bc 3a 80 00       	push   $0x803abc
  8009dc:	e8 63 02 00 00       	call   800c44 <_panic>

		//another 512 KB Hole appended to the hole
		freeFrames = sys_calculate_free_frames() ;
  8009e1:	e8 b0 18 00 00       	call   802296 <sys_calculate_free_frames>
  8009e6:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  8009e9:	e8 48 19 00 00       	call   802336 <sys_pf_calculate_allocated_pages>
  8009ee:	89 45 e0             	mov    %eax,-0x20(%ebp)
		free(ptr_allocations[8]);
  8009f1:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8009f4:	83 ec 0c             	sub    $0xc,%esp
  8009f7:	50                   	push   %eax
  8009f8:	e8 0e 15 00 00       	call   801f0b <free>
  8009fd:	83 c4 10             	add    $0x10,%esp
		//if ((sys_calculate_free_frames() - freeFrames) != 256) panic("Wrong free: ");
		if( (usedDiskPages - sys_pf_calculate_allocated_pages()) !=  128) panic("Wrong page file free: ");
  800a00:	e8 31 19 00 00       	call   802336 <sys_pf_calculate_allocated_pages>
  800a05:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800a08:	29 c2                	sub    %eax,%edx
  800a0a:	89 d0                	mov    %edx,%eax
  800a0c:	3d 80 00 00 00       	cmp    $0x80,%eax
  800a11:	74 17                	je     800a2a <_main+0x9f2>
  800a13:	83 ec 04             	sub    $0x4,%esp
  800a16:	68 34 3b 80 00       	push   $0x803b34
  800a1b:	68 bc 00 00 00       	push   $0xbc
  800a20:	68 bc 3a 80 00       	push   $0x803abc
  800a25:	e8 1a 02 00 00       	call   800c44 <_panic>
		if ((sys_calculate_free_frames() - freeFrames) != 0) panic("Wrong free: ");
  800a2a:	e8 67 18 00 00       	call   802296 <sys_calculate_free_frames>
  800a2f:	89 c2                	mov    %eax,%edx
  800a31:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800a34:	39 c2                	cmp    %eax,%edx
  800a36:	74 17                	je     800a4f <_main+0xa17>
  800a38:	83 ec 04             	sub    $0x4,%esp
  800a3b:	68 4b 3b 80 00       	push   $0x803b4b
  800a40:	68 bd 00 00 00       	push   $0xbd
  800a45:	68 bc 3a 80 00       	push   $0x803abc
  800a4a:	e8 f5 01 00 00       	call   800c44 <_panic>
	}

	//[5] Allocate again [test best fit]
	{
		//Allocate 2 MB - should be placed in the contiguous hole (2 MB + 512 KB)
		freeFrames = sys_calculate_free_frames();
  800a4f:	e8 42 18 00 00       	call   802296 <sys_calculate_free_frames>
  800a54:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  800a57:	e8 da 18 00 00       	call   802336 <sys_pf_calculate_allocated_pages>
  800a5c:	89 45 e0             	mov    %eax,-0x20(%ebp)
		ptr_allocations[12] = malloc(2*Mega - kilo);
  800a5f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800a62:	01 c0                	add    %eax,%eax
  800a64:	2b 45 e8             	sub    -0x18(%ebp),%eax
  800a67:	83 ec 0c             	sub    $0xc,%esp
  800a6a:	50                   	push   %eax
  800a6b:	e8 1a 14 00 00       	call   801e8a <malloc>
  800a70:	83 c4 10             	add    $0x10,%esp
  800a73:	89 45 c0             	mov    %eax,-0x40(%ebp)
		if ((uint32) ptr_allocations[12] != (USER_HEAP_START + 9*Mega)) panic("Wrong start address for the allocated space... ");
  800a76:	8b 45 c0             	mov    -0x40(%ebp),%eax
  800a79:	89 c1                	mov    %eax,%ecx
  800a7b:	8b 55 ec             	mov    -0x14(%ebp),%edx
  800a7e:	89 d0                	mov    %edx,%eax
  800a80:	c1 e0 03             	shl    $0x3,%eax
  800a83:	01 d0                	add    %edx,%eax
  800a85:	05 00 00 00 80       	add    $0x80000000,%eax
  800a8a:	39 c1                	cmp    %eax,%ecx
  800a8c:	74 17                	je     800aa5 <_main+0xa6d>
  800a8e:	83 ec 04             	sub    $0x4,%esp
  800a91:	68 d4 3a 80 00       	push   $0x803ad4
  800a96:	68 c6 00 00 00       	push   $0xc6
  800a9b:	68 bc 3a 80 00       	push   $0x803abc
  800aa0:	e8 9f 01 00 00       	call   800c44 <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 512+32) panic("Wrong allocation: ");
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  2*256) panic("Wrong page file allocation: ");
  800aa5:	e8 8c 18 00 00       	call   802336 <sys_pf_calculate_allocated_pages>
  800aaa:	2b 45 e0             	sub    -0x20(%ebp),%eax
  800aad:	3d 00 02 00 00       	cmp    $0x200,%eax
  800ab2:	74 17                	je     800acb <_main+0xa93>
  800ab4:	83 ec 04             	sub    $0x4,%esp
  800ab7:	68 04 3b 80 00       	push   $0x803b04
  800abc:	68 c8 00 00 00       	push   $0xc8
  800ac1:	68 bc 3a 80 00       	push   $0x803abc
  800ac6:	e8 79 01 00 00       	call   800c44 <_panic>
		if ((freeFrames - sys_calculate_free_frames()) != 0) panic("Wrong allocation: ");
  800acb:	e8 c6 17 00 00       	call   802296 <sys_calculate_free_frames>
  800ad0:	89 c2                	mov    %eax,%edx
  800ad2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800ad5:	39 c2                	cmp    %eax,%edx
  800ad7:	74 17                	je     800af0 <_main+0xab8>
  800ad9:	83 ec 04             	sub    $0x4,%esp
  800adc:	68 21 3b 80 00       	push   $0x803b21
  800ae1:	68 c9 00 00 00       	push   $0xc9
  800ae6:	68 bc 3a 80 00       	push   $0x803abc
  800aeb:	e8 54 01 00 00       	call   800c44 <_panic>
	}
	cprintf("Congratulations!! test BEST FIT allocation (1) completed successfully.\n");
  800af0:	83 ec 0c             	sub    $0xc,%esp
  800af3:	68 58 3b 80 00       	push   $0x803b58
  800af8:	e8 fb 03 00 00       	call   800ef8 <cprintf>
  800afd:	83 c4 10             	add    $0x10,%esp

	return;
  800b00:	90                   	nop
}
  800b01:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800b04:	5b                   	pop    %ebx
  800b05:	5f                   	pop    %edi
  800b06:	5d                   	pop    %ebp
  800b07:	c3                   	ret    

00800b08 <libmain>:
volatile struct Env *myEnv = NULL;
volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";

void
libmain(int argc, char **argv)
{
  800b08:	55                   	push   %ebp
  800b09:	89 e5                	mov    %esp,%ebp
  800b0b:	83 ec 18             	sub    $0x18,%esp
	int envIndex = sys_getenvindex();
  800b0e:	e8 63 1a 00 00       	call   802576 <sys_getenvindex>
  800b13:	89 45 f4             	mov    %eax,-0xc(%ebp)
	myEnv = &(envs[envIndex]);
  800b16:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800b19:	89 d0                	mov    %edx,%eax
  800b1b:	c1 e0 03             	shl    $0x3,%eax
  800b1e:	01 d0                	add    %edx,%eax
  800b20:	01 c0                	add    %eax,%eax
  800b22:	01 d0                	add    %edx,%eax
  800b24:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800b2b:	01 d0                	add    %edx,%eax
  800b2d:	c1 e0 04             	shl    $0x4,%eax
  800b30:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  800b35:	a3 20 50 80 00       	mov    %eax,0x805020

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  800b3a:	a1 20 50 80 00       	mov    0x805020,%eax
  800b3f:	8a 80 5c 05 00 00    	mov    0x55c(%eax),%al
  800b45:	84 c0                	test   %al,%al
  800b47:	74 0f                	je     800b58 <libmain+0x50>
		binaryname = myEnv->prog_name;
  800b49:	a1 20 50 80 00       	mov    0x805020,%eax
  800b4e:	05 5c 05 00 00       	add    $0x55c,%eax
  800b53:	a3 00 50 80 00       	mov    %eax,0x805000

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800b58:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800b5c:	7e 0a                	jle    800b68 <libmain+0x60>
		binaryname = argv[0];
  800b5e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b61:	8b 00                	mov    (%eax),%eax
  800b63:	a3 00 50 80 00       	mov    %eax,0x805000

	// call user main routine
	_main(argc, argv);
  800b68:	83 ec 08             	sub    $0x8,%esp
  800b6b:	ff 75 0c             	pushl  0xc(%ebp)
  800b6e:	ff 75 08             	pushl  0x8(%ebp)
  800b71:	e8 c2 f4 ff ff       	call   800038 <_main>
  800b76:	83 c4 10             	add    $0x10,%esp



	sys_disable_interrupt();
  800b79:	e8 05 18 00 00       	call   802383 <sys_disable_interrupt>
	cprintf("**************************************\n");
  800b7e:	83 ec 0c             	sub    $0xc,%esp
  800b81:	68 b8 3b 80 00       	push   $0x803bb8
  800b86:	e8 6d 03 00 00       	call   800ef8 <cprintf>
  800b8b:	83 c4 10             	add    $0x10,%esp
	cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  800b8e:	a1 20 50 80 00       	mov    0x805020,%eax
  800b93:	8b 90 44 05 00 00    	mov    0x544(%eax),%edx
  800b99:	a1 20 50 80 00       	mov    0x805020,%eax
  800b9e:	8b 80 34 05 00 00    	mov    0x534(%eax),%eax
  800ba4:	83 ec 04             	sub    $0x4,%esp
  800ba7:	52                   	push   %edx
  800ba8:	50                   	push   %eax
  800ba9:	68 e0 3b 80 00       	push   $0x803be0
  800bae:	e8 45 03 00 00       	call   800ef8 <cprintf>
  800bb3:	83 c4 10             	add    $0x10,%esp
	cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  800bb6:	a1 20 50 80 00       	mov    0x805020,%eax
  800bbb:	8b 88 54 05 00 00    	mov    0x554(%eax),%ecx
  800bc1:	a1 20 50 80 00       	mov    0x805020,%eax
  800bc6:	8b 90 50 05 00 00    	mov    0x550(%eax),%edx
  800bcc:	a1 20 50 80 00       	mov    0x805020,%eax
  800bd1:	8b 80 4c 05 00 00    	mov    0x54c(%eax),%eax
  800bd7:	51                   	push   %ecx
  800bd8:	52                   	push   %edx
  800bd9:	50                   	push   %eax
  800bda:	68 08 3c 80 00       	push   $0x803c08
  800bdf:	e8 14 03 00 00       	call   800ef8 <cprintf>
  800be4:	83 c4 10             	add    $0x10,%esp
	//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
	cprintf("Num of clocks = %d\n", myEnv->nClocks);
  800be7:	a1 20 50 80 00       	mov    0x805020,%eax
  800bec:	8b 80 a4 05 00 00    	mov    0x5a4(%eax),%eax
  800bf2:	83 ec 08             	sub    $0x8,%esp
  800bf5:	50                   	push   %eax
  800bf6:	68 60 3c 80 00       	push   $0x803c60
  800bfb:	e8 f8 02 00 00       	call   800ef8 <cprintf>
  800c00:	83 c4 10             	add    $0x10,%esp
	cprintf("**************************************\n");
  800c03:	83 ec 0c             	sub    $0xc,%esp
  800c06:	68 b8 3b 80 00       	push   $0x803bb8
  800c0b:	e8 e8 02 00 00       	call   800ef8 <cprintf>
  800c10:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  800c13:	e8 85 17 00 00       	call   80239d <sys_enable_interrupt>

	// exit gracefully
	exit();
  800c18:	e8 19 00 00 00       	call   800c36 <exit>
}
  800c1d:	90                   	nop
  800c1e:	c9                   	leave  
  800c1f:	c3                   	ret    

00800c20 <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  800c20:	55                   	push   %ebp
  800c21:	89 e5                	mov    %esp,%ebp
  800c23:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  800c26:	83 ec 0c             	sub    $0xc,%esp
  800c29:	6a 00                	push   $0x0
  800c2b:	e8 12 19 00 00       	call   802542 <sys_destroy_env>
  800c30:	83 c4 10             	add    $0x10,%esp
}
  800c33:	90                   	nop
  800c34:	c9                   	leave  
  800c35:	c3                   	ret    

00800c36 <exit>:

void
exit(void)
{
  800c36:	55                   	push   %ebp
  800c37:	89 e5                	mov    %esp,%ebp
  800c39:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  800c3c:	e8 67 19 00 00       	call   8025a8 <sys_exit_env>
}
  800c41:	90                   	nop
  800c42:	c9                   	leave  
  800c43:	c3                   	ret    

00800c44 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  800c44:	55                   	push   %ebp
  800c45:	89 e5                	mov    %esp,%ebp
  800c47:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  800c4a:	8d 45 10             	lea    0x10(%ebp),%eax
  800c4d:	83 c0 04             	add    $0x4,%eax
  800c50:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  800c53:	a1 5c 51 80 00       	mov    0x80515c,%eax
  800c58:	85 c0                	test   %eax,%eax
  800c5a:	74 16                	je     800c72 <_panic+0x2e>
		cprintf("%s: ", argv0);
  800c5c:	a1 5c 51 80 00       	mov    0x80515c,%eax
  800c61:	83 ec 08             	sub    $0x8,%esp
  800c64:	50                   	push   %eax
  800c65:	68 74 3c 80 00       	push   $0x803c74
  800c6a:	e8 89 02 00 00       	call   800ef8 <cprintf>
  800c6f:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  800c72:	a1 00 50 80 00       	mov    0x805000,%eax
  800c77:	ff 75 0c             	pushl  0xc(%ebp)
  800c7a:	ff 75 08             	pushl  0x8(%ebp)
  800c7d:	50                   	push   %eax
  800c7e:	68 79 3c 80 00       	push   $0x803c79
  800c83:	e8 70 02 00 00       	call   800ef8 <cprintf>
  800c88:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  800c8b:	8b 45 10             	mov    0x10(%ebp),%eax
  800c8e:	83 ec 08             	sub    $0x8,%esp
  800c91:	ff 75 f4             	pushl  -0xc(%ebp)
  800c94:	50                   	push   %eax
  800c95:	e8 f3 01 00 00       	call   800e8d <vcprintf>
  800c9a:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  800c9d:	83 ec 08             	sub    $0x8,%esp
  800ca0:	6a 00                	push   $0x0
  800ca2:	68 95 3c 80 00       	push   $0x803c95
  800ca7:	e8 e1 01 00 00       	call   800e8d <vcprintf>
  800cac:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  800caf:	e8 82 ff ff ff       	call   800c36 <exit>

	// should not return here
	while (1) ;
  800cb4:	eb fe                	jmp    800cb4 <_panic+0x70>

00800cb6 <CheckWSWithoutLastIndex>:
}

void CheckWSWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  800cb6:	55                   	push   %ebp
  800cb7:	89 e5                	mov    %esp,%ebp
  800cb9:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  800cbc:	a1 20 50 80 00       	mov    0x805020,%eax
  800cc1:	8b 50 74             	mov    0x74(%eax),%edx
  800cc4:	8b 45 0c             	mov    0xc(%ebp),%eax
  800cc7:	39 c2                	cmp    %eax,%edx
  800cc9:	74 14                	je     800cdf <CheckWSWithoutLastIndex+0x29>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  800ccb:	83 ec 04             	sub    $0x4,%esp
  800cce:	68 98 3c 80 00       	push   $0x803c98
  800cd3:	6a 26                	push   $0x26
  800cd5:	68 e4 3c 80 00       	push   $0x803ce4
  800cda:	e8 65 ff ff ff       	call   800c44 <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  800cdf:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  800ce6:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800ced:	e9 c2 00 00 00       	jmp    800db4 <CheckWSWithoutLastIndex+0xfe>
		if (expectedPages[e] == 0) {
  800cf2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800cf5:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800cfc:	8b 45 08             	mov    0x8(%ebp),%eax
  800cff:	01 d0                	add    %edx,%eax
  800d01:	8b 00                	mov    (%eax),%eax
  800d03:	85 c0                	test   %eax,%eax
  800d05:	75 08                	jne    800d0f <CheckWSWithoutLastIndex+0x59>
			expectedNumOfEmptyLocs++;
  800d07:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  800d0a:	e9 a2 00 00 00       	jmp    800db1 <CheckWSWithoutLastIndex+0xfb>
		}
		int found = 0;
  800d0f:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800d16:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  800d1d:	eb 69                	jmp    800d88 <CheckWSWithoutLastIndex+0xd2>
			if (myEnv->__uptr_pws[w].empty == 0) {
  800d1f:	a1 20 50 80 00       	mov    0x805020,%eax
  800d24:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  800d2a:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800d2d:	89 d0                	mov    %edx,%eax
  800d2f:	01 c0                	add    %eax,%eax
  800d31:	01 d0                	add    %edx,%eax
  800d33:	c1 e0 03             	shl    $0x3,%eax
  800d36:	01 c8                	add    %ecx,%eax
  800d38:	8a 40 04             	mov    0x4(%eax),%al
  800d3b:	84 c0                	test   %al,%al
  800d3d:	75 46                	jne    800d85 <CheckWSWithoutLastIndex+0xcf>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  800d3f:	a1 20 50 80 00       	mov    0x805020,%eax
  800d44:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  800d4a:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800d4d:	89 d0                	mov    %edx,%eax
  800d4f:	01 c0                	add    %eax,%eax
  800d51:	01 d0                	add    %edx,%eax
  800d53:	c1 e0 03             	shl    $0x3,%eax
  800d56:	01 c8                	add    %ecx,%eax
  800d58:	8b 00                	mov    (%eax),%eax
  800d5a:	89 45 dc             	mov    %eax,-0x24(%ebp)
  800d5d:	8b 45 dc             	mov    -0x24(%ebp),%eax
  800d60:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800d65:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  800d67:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800d6a:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  800d71:	8b 45 08             	mov    0x8(%ebp),%eax
  800d74:	01 c8                	add    %ecx,%eax
  800d76:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  800d78:	39 c2                	cmp    %eax,%edx
  800d7a:	75 09                	jne    800d85 <CheckWSWithoutLastIndex+0xcf>
						== expectedPages[e]) {
					found = 1;
  800d7c:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  800d83:	eb 12                	jmp    800d97 <CheckWSWithoutLastIndex+0xe1>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800d85:	ff 45 e8             	incl   -0x18(%ebp)
  800d88:	a1 20 50 80 00       	mov    0x805020,%eax
  800d8d:	8b 50 74             	mov    0x74(%eax),%edx
  800d90:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800d93:	39 c2                	cmp    %eax,%edx
  800d95:	77 88                	ja     800d1f <CheckWSWithoutLastIndex+0x69>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  800d97:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  800d9b:	75 14                	jne    800db1 <CheckWSWithoutLastIndex+0xfb>
			panic(
  800d9d:	83 ec 04             	sub    $0x4,%esp
  800da0:	68 f0 3c 80 00       	push   $0x803cf0
  800da5:	6a 3a                	push   $0x3a
  800da7:	68 e4 3c 80 00       	push   $0x803ce4
  800dac:	e8 93 fe ff ff       	call   800c44 <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  800db1:	ff 45 f0             	incl   -0x10(%ebp)
  800db4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800db7:	3b 45 0c             	cmp    0xc(%ebp),%eax
  800dba:	0f 8c 32 ff ff ff    	jl     800cf2 <CheckWSWithoutLastIndex+0x3c>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  800dc0:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800dc7:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  800dce:	eb 26                	jmp    800df6 <CheckWSWithoutLastIndex+0x140>
		if (myEnv->__uptr_pws[w].empty == 1) {
  800dd0:	a1 20 50 80 00       	mov    0x805020,%eax
  800dd5:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  800ddb:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800dde:	89 d0                	mov    %edx,%eax
  800de0:	01 c0                	add    %eax,%eax
  800de2:	01 d0                	add    %edx,%eax
  800de4:	c1 e0 03             	shl    $0x3,%eax
  800de7:	01 c8                	add    %ecx,%eax
  800de9:	8a 40 04             	mov    0x4(%eax),%al
  800dec:	3c 01                	cmp    $0x1,%al
  800dee:	75 03                	jne    800df3 <CheckWSWithoutLastIndex+0x13d>
			actualNumOfEmptyLocs++;
  800df0:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800df3:	ff 45 e0             	incl   -0x20(%ebp)
  800df6:	a1 20 50 80 00       	mov    0x805020,%eax
  800dfb:	8b 50 74             	mov    0x74(%eax),%edx
  800dfe:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800e01:	39 c2                	cmp    %eax,%edx
  800e03:	77 cb                	ja     800dd0 <CheckWSWithoutLastIndex+0x11a>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  800e05:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800e08:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  800e0b:	74 14                	je     800e21 <CheckWSWithoutLastIndex+0x16b>
		panic(
  800e0d:	83 ec 04             	sub    $0x4,%esp
  800e10:	68 44 3d 80 00       	push   $0x803d44
  800e15:	6a 44                	push   $0x44
  800e17:	68 e4 3c 80 00       	push   $0x803ce4
  800e1c:	e8 23 fe ff ff       	call   800c44 <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  800e21:	90                   	nop
  800e22:	c9                   	leave  
  800e23:	c3                   	ret    

00800e24 <putch>:
};

//2017:
uint8 printProgName = 0;

static void putch(int ch, struct printbuf *b) {
  800e24:	55                   	push   %ebp
  800e25:	89 e5                	mov    %esp,%ebp
  800e27:	83 ec 08             	sub    $0x8,%esp
	b->buf[b->idx++] = ch;
  800e2a:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e2d:	8b 00                	mov    (%eax),%eax
  800e2f:	8d 48 01             	lea    0x1(%eax),%ecx
  800e32:	8b 55 0c             	mov    0xc(%ebp),%edx
  800e35:	89 0a                	mov    %ecx,(%edx)
  800e37:	8b 55 08             	mov    0x8(%ebp),%edx
  800e3a:	88 d1                	mov    %dl,%cl
  800e3c:	8b 55 0c             	mov    0xc(%ebp),%edx
  800e3f:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  800e43:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e46:	8b 00                	mov    (%eax),%eax
  800e48:	3d ff 00 00 00       	cmp    $0xff,%eax
  800e4d:	75 2c                	jne    800e7b <putch+0x57>
		sys_cputs(b->buf, b->idx, printProgName);
  800e4f:	a0 24 50 80 00       	mov    0x805024,%al
  800e54:	0f b6 c0             	movzbl %al,%eax
  800e57:	8b 55 0c             	mov    0xc(%ebp),%edx
  800e5a:	8b 12                	mov    (%edx),%edx
  800e5c:	89 d1                	mov    %edx,%ecx
  800e5e:	8b 55 0c             	mov    0xc(%ebp),%edx
  800e61:	83 c2 08             	add    $0x8,%edx
  800e64:	83 ec 04             	sub    $0x4,%esp
  800e67:	50                   	push   %eax
  800e68:	51                   	push   %ecx
  800e69:	52                   	push   %edx
  800e6a:	e8 66 13 00 00       	call   8021d5 <sys_cputs>
  800e6f:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  800e72:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e75:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  800e7b:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e7e:	8b 40 04             	mov    0x4(%eax),%eax
  800e81:	8d 50 01             	lea    0x1(%eax),%edx
  800e84:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e87:	89 50 04             	mov    %edx,0x4(%eax)
}
  800e8a:	90                   	nop
  800e8b:	c9                   	leave  
  800e8c:	c3                   	ret    

00800e8d <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  800e8d:	55                   	push   %ebp
  800e8e:	89 e5                	mov    %esp,%ebp
  800e90:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  800e96:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800e9d:	00 00 00 
	b.cnt = 0;
  800ea0:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800ea7:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  800eaa:	ff 75 0c             	pushl  0xc(%ebp)
  800ead:	ff 75 08             	pushl  0x8(%ebp)
  800eb0:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800eb6:	50                   	push   %eax
  800eb7:	68 24 0e 80 00       	push   $0x800e24
  800ebc:	e8 11 02 00 00       	call   8010d2 <vprintfmt>
  800ec1:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName);
  800ec4:	a0 24 50 80 00       	mov    0x805024,%al
  800ec9:	0f b6 c0             	movzbl %al,%eax
  800ecc:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  800ed2:	83 ec 04             	sub    $0x4,%esp
  800ed5:	50                   	push   %eax
  800ed6:	52                   	push   %edx
  800ed7:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800edd:	83 c0 08             	add    $0x8,%eax
  800ee0:	50                   	push   %eax
  800ee1:	e8 ef 12 00 00       	call   8021d5 <sys_cputs>
  800ee6:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  800ee9:	c6 05 24 50 80 00 00 	movb   $0x0,0x805024
	return b.cnt;
  800ef0:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  800ef6:	c9                   	leave  
  800ef7:	c3                   	ret    

00800ef8 <cprintf>:

int cprintf(const char *fmt, ...) {
  800ef8:	55                   	push   %ebp
  800ef9:	89 e5                	mov    %esp,%ebp
  800efb:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  800efe:	c6 05 24 50 80 00 01 	movb   $0x1,0x805024
	va_start(ap, fmt);
  800f05:	8d 45 0c             	lea    0xc(%ebp),%eax
  800f08:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800f0b:	8b 45 08             	mov    0x8(%ebp),%eax
  800f0e:	83 ec 08             	sub    $0x8,%esp
  800f11:	ff 75 f4             	pushl  -0xc(%ebp)
  800f14:	50                   	push   %eax
  800f15:	e8 73 ff ff ff       	call   800e8d <vcprintf>
  800f1a:	83 c4 10             	add    $0x10,%esp
  800f1d:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  800f20:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800f23:	c9                   	leave  
  800f24:	c3                   	ret    

00800f25 <atomic_cprintf>:

int atomic_cprintf(const char *fmt, ...) {
  800f25:	55                   	push   %ebp
  800f26:	89 e5                	mov    %esp,%ebp
  800f28:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  800f2b:	e8 53 14 00 00       	call   802383 <sys_disable_interrupt>
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  800f30:	8d 45 0c             	lea    0xc(%ebp),%eax
  800f33:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800f36:	8b 45 08             	mov    0x8(%ebp),%eax
  800f39:	83 ec 08             	sub    $0x8,%esp
  800f3c:	ff 75 f4             	pushl  -0xc(%ebp)
  800f3f:	50                   	push   %eax
  800f40:	e8 48 ff ff ff       	call   800e8d <vcprintf>
  800f45:	83 c4 10             	add    $0x10,%esp
  800f48:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	sys_enable_interrupt();
  800f4b:	e8 4d 14 00 00       	call   80239d <sys_enable_interrupt>
	return cnt;
  800f50:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800f53:	c9                   	leave  
  800f54:	c3                   	ret    

00800f55 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800f55:	55                   	push   %ebp
  800f56:	89 e5                	mov    %esp,%ebp
  800f58:	53                   	push   %ebx
  800f59:	83 ec 14             	sub    $0x14,%esp
  800f5c:	8b 45 10             	mov    0x10(%ebp),%eax
  800f5f:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800f62:	8b 45 14             	mov    0x14(%ebp),%eax
  800f65:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800f68:	8b 45 18             	mov    0x18(%ebp),%eax
  800f6b:	ba 00 00 00 00       	mov    $0x0,%edx
  800f70:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800f73:	77 55                	ja     800fca <printnum+0x75>
  800f75:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800f78:	72 05                	jb     800f7f <printnum+0x2a>
  800f7a:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800f7d:	77 4b                	ja     800fca <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800f7f:	8b 45 1c             	mov    0x1c(%ebp),%eax
  800f82:	8d 58 ff             	lea    -0x1(%eax),%ebx
  800f85:	8b 45 18             	mov    0x18(%ebp),%eax
  800f88:	ba 00 00 00 00       	mov    $0x0,%edx
  800f8d:	52                   	push   %edx
  800f8e:	50                   	push   %eax
  800f8f:	ff 75 f4             	pushl  -0xc(%ebp)
  800f92:	ff 75 f0             	pushl  -0x10(%ebp)
  800f95:	e8 86 28 00 00       	call   803820 <__udivdi3>
  800f9a:	83 c4 10             	add    $0x10,%esp
  800f9d:	83 ec 04             	sub    $0x4,%esp
  800fa0:	ff 75 20             	pushl  0x20(%ebp)
  800fa3:	53                   	push   %ebx
  800fa4:	ff 75 18             	pushl  0x18(%ebp)
  800fa7:	52                   	push   %edx
  800fa8:	50                   	push   %eax
  800fa9:	ff 75 0c             	pushl  0xc(%ebp)
  800fac:	ff 75 08             	pushl  0x8(%ebp)
  800faf:	e8 a1 ff ff ff       	call   800f55 <printnum>
  800fb4:	83 c4 20             	add    $0x20,%esp
  800fb7:	eb 1a                	jmp    800fd3 <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800fb9:	83 ec 08             	sub    $0x8,%esp
  800fbc:	ff 75 0c             	pushl  0xc(%ebp)
  800fbf:	ff 75 20             	pushl  0x20(%ebp)
  800fc2:	8b 45 08             	mov    0x8(%ebp),%eax
  800fc5:	ff d0                	call   *%eax
  800fc7:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800fca:	ff 4d 1c             	decl   0x1c(%ebp)
  800fcd:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  800fd1:	7f e6                	jg     800fb9 <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800fd3:	8b 4d 18             	mov    0x18(%ebp),%ecx
  800fd6:	bb 00 00 00 00       	mov    $0x0,%ebx
  800fdb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800fde:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800fe1:	53                   	push   %ebx
  800fe2:	51                   	push   %ecx
  800fe3:	52                   	push   %edx
  800fe4:	50                   	push   %eax
  800fe5:	e8 46 29 00 00       	call   803930 <__umoddi3>
  800fea:	83 c4 10             	add    $0x10,%esp
  800fed:	05 b4 3f 80 00       	add    $0x803fb4,%eax
  800ff2:	8a 00                	mov    (%eax),%al
  800ff4:	0f be c0             	movsbl %al,%eax
  800ff7:	83 ec 08             	sub    $0x8,%esp
  800ffa:	ff 75 0c             	pushl  0xc(%ebp)
  800ffd:	50                   	push   %eax
  800ffe:	8b 45 08             	mov    0x8(%ebp),%eax
  801001:	ff d0                	call   *%eax
  801003:	83 c4 10             	add    $0x10,%esp
}
  801006:	90                   	nop
  801007:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80100a:	c9                   	leave  
  80100b:	c3                   	ret    

0080100c <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  80100c:	55                   	push   %ebp
  80100d:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  80100f:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  801013:	7e 1c                	jle    801031 <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  801015:	8b 45 08             	mov    0x8(%ebp),%eax
  801018:	8b 00                	mov    (%eax),%eax
  80101a:	8d 50 08             	lea    0x8(%eax),%edx
  80101d:	8b 45 08             	mov    0x8(%ebp),%eax
  801020:	89 10                	mov    %edx,(%eax)
  801022:	8b 45 08             	mov    0x8(%ebp),%eax
  801025:	8b 00                	mov    (%eax),%eax
  801027:	83 e8 08             	sub    $0x8,%eax
  80102a:	8b 50 04             	mov    0x4(%eax),%edx
  80102d:	8b 00                	mov    (%eax),%eax
  80102f:	eb 40                	jmp    801071 <getuint+0x65>
	else if (lflag)
  801031:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801035:	74 1e                	je     801055 <getuint+0x49>
		return va_arg(*ap, unsigned long);
  801037:	8b 45 08             	mov    0x8(%ebp),%eax
  80103a:	8b 00                	mov    (%eax),%eax
  80103c:	8d 50 04             	lea    0x4(%eax),%edx
  80103f:	8b 45 08             	mov    0x8(%ebp),%eax
  801042:	89 10                	mov    %edx,(%eax)
  801044:	8b 45 08             	mov    0x8(%ebp),%eax
  801047:	8b 00                	mov    (%eax),%eax
  801049:	83 e8 04             	sub    $0x4,%eax
  80104c:	8b 00                	mov    (%eax),%eax
  80104e:	ba 00 00 00 00       	mov    $0x0,%edx
  801053:	eb 1c                	jmp    801071 <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  801055:	8b 45 08             	mov    0x8(%ebp),%eax
  801058:	8b 00                	mov    (%eax),%eax
  80105a:	8d 50 04             	lea    0x4(%eax),%edx
  80105d:	8b 45 08             	mov    0x8(%ebp),%eax
  801060:	89 10                	mov    %edx,(%eax)
  801062:	8b 45 08             	mov    0x8(%ebp),%eax
  801065:	8b 00                	mov    (%eax),%eax
  801067:	83 e8 04             	sub    $0x4,%eax
  80106a:	8b 00                	mov    (%eax),%eax
  80106c:	ba 00 00 00 00       	mov    $0x0,%edx
}
  801071:	5d                   	pop    %ebp
  801072:	c3                   	ret    

00801073 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  801073:	55                   	push   %ebp
  801074:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  801076:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  80107a:	7e 1c                	jle    801098 <getint+0x25>
		return va_arg(*ap, long long);
  80107c:	8b 45 08             	mov    0x8(%ebp),%eax
  80107f:	8b 00                	mov    (%eax),%eax
  801081:	8d 50 08             	lea    0x8(%eax),%edx
  801084:	8b 45 08             	mov    0x8(%ebp),%eax
  801087:	89 10                	mov    %edx,(%eax)
  801089:	8b 45 08             	mov    0x8(%ebp),%eax
  80108c:	8b 00                	mov    (%eax),%eax
  80108e:	83 e8 08             	sub    $0x8,%eax
  801091:	8b 50 04             	mov    0x4(%eax),%edx
  801094:	8b 00                	mov    (%eax),%eax
  801096:	eb 38                	jmp    8010d0 <getint+0x5d>
	else if (lflag)
  801098:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80109c:	74 1a                	je     8010b8 <getint+0x45>
		return va_arg(*ap, long);
  80109e:	8b 45 08             	mov    0x8(%ebp),%eax
  8010a1:	8b 00                	mov    (%eax),%eax
  8010a3:	8d 50 04             	lea    0x4(%eax),%edx
  8010a6:	8b 45 08             	mov    0x8(%ebp),%eax
  8010a9:	89 10                	mov    %edx,(%eax)
  8010ab:	8b 45 08             	mov    0x8(%ebp),%eax
  8010ae:	8b 00                	mov    (%eax),%eax
  8010b0:	83 e8 04             	sub    $0x4,%eax
  8010b3:	8b 00                	mov    (%eax),%eax
  8010b5:	99                   	cltd   
  8010b6:	eb 18                	jmp    8010d0 <getint+0x5d>
	else
		return va_arg(*ap, int);
  8010b8:	8b 45 08             	mov    0x8(%ebp),%eax
  8010bb:	8b 00                	mov    (%eax),%eax
  8010bd:	8d 50 04             	lea    0x4(%eax),%edx
  8010c0:	8b 45 08             	mov    0x8(%ebp),%eax
  8010c3:	89 10                	mov    %edx,(%eax)
  8010c5:	8b 45 08             	mov    0x8(%ebp),%eax
  8010c8:	8b 00                	mov    (%eax),%eax
  8010ca:	83 e8 04             	sub    $0x4,%eax
  8010cd:	8b 00                	mov    (%eax),%eax
  8010cf:	99                   	cltd   
}
  8010d0:	5d                   	pop    %ebp
  8010d1:	c3                   	ret    

008010d2 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  8010d2:	55                   	push   %ebp
  8010d3:	89 e5                	mov    %esp,%ebp
  8010d5:	56                   	push   %esi
  8010d6:	53                   	push   %ebx
  8010d7:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8010da:	eb 17                	jmp    8010f3 <vprintfmt+0x21>
			if (ch == '\0')
  8010dc:	85 db                	test   %ebx,%ebx
  8010de:	0f 84 af 03 00 00    	je     801493 <vprintfmt+0x3c1>
				return;
			putch(ch, putdat);
  8010e4:	83 ec 08             	sub    $0x8,%esp
  8010e7:	ff 75 0c             	pushl  0xc(%ebp)
  8010ea:	53                   	push   %ebx
  8010eb:	8b 45 08             	mov    0x8(%ebp),%eax
  8010ee:	ff d0                	call   *%eax
  8010f0:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8010f3:	8b 45 10             	mov    0x10(%ebp),%eax
  8010f6:	8d 50 01             	lea    0x1(%eax),%edx
  8010f9:	89 55 10             	mov    %edx,0x10(%ebp)
  8010fc:	8a 00                	mov    (%eax),%al
  8010fe:	0f b6 d8             	movzbl %al,%ebx
  801101:	83 fb 25             	cmp    $0x25,%ebx
  801104:	75 d6                	jne    8010dc <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  801106:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  80110a:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  801111:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  801118:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  80111f:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  801126:	8b 45 10             	mov    0x10(%ebp),%eax
  801129:	8d 50 01             	lea    0x1(%eax),%edx
  80112c:	89 55 10             	mov    %edx,0x10(%ebp)
  80112f:	8a 00                	mov    (%eax),%al
  801131:	0f b6 d8             	movzbl %al,%ebx
  801134:	8d 43 dd             	lea    -0x23(%ebx),%eax
  801137:	83 f8 55             	cmp    $0x55,%eax
  80113a:	0f 87 2b 03 00 00    	ja     80146b <vprintfmt+0x399>
  801140:	8b 04 85 d8 3f 80 00 	mov    0x803fd8(,%eax,4),%eax
  801147:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  801149:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  80114d:	eb d7                	jmp    801126 <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  80114f:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  801153:	eb d1                	jmp    801126 <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  801155:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  80115c:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80115f:	89 d0                	mov    %edx,%eax
  801161:	c1 e0 02             	shl    $0x2,%eax
  801164:	01 d0                	add    %edx,%eax
  801166:	01 c0                	add    %eax,%eax
  801168:	01 d8                	add    %ebx,%eax
  80116a:	83 e8 30             	sub    $0x30,%eax
  80116d:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  801170:	8b 45 10             	mov    0x10(%ebp),%eax
  801173:	8a 00                	mov    (%eax),%al
  801175:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  801178:	83 fb 2f             	cmp    $0x2f,%ebx
  80117b:	7e 3e                	jle    8011bb <vprintfmt+0xe9>
  80117d:	83 fb 39             	cmp    $0x39,%ebx
  801180:	7f 39                	jg     8011bb <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  801182:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  801185:	eb d5                	jmp    80115c <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  801187:	8b 45 14             	mov    0x14(%ebp),%eax
  80118a:	83 c0 04             	add    $0x4,%eax
  80118d:	89 45 14             	mov    %eax,0x14(%ebp)
  801190:	8b 45 14             	mov    0x14(%ebp),%eax
  801193:	83 e8 04             	sub    $0x4,%eax
  801196:	8b 00                	mov    (%eax),%eax
  801198:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  80119b:	eb 1f                	jmp    8011bc <vprintfmt+0xea>

		case '.':
			if (width < 0)
  80119d:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8011a1:	79 83                	jns    801126 <vprintfmt+0x54>
				width = 0;
  8011a3:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  8011aa:	e9 77 ff ff ff       	jmp    801126 <vprintfmt+0x54>

		case '#':
			altflag = 1;
  8011af:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  8011b6:	e9 6b ff ff ff       	jmp    801126 <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  8011bb:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  8011bc:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8011c0:	0f 89 60 ff ff ff    	jns    801126 <vprintfmt+0x54>
				width = precision, precision = -1;
  8011c6:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8011c9:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8011cc:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  8011d3:	e9 4e ff ff ff       	jmp    801126 <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  8011d8:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  8011db:	e9 46 ff ff ff       	jmp    801126 <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  8011e0:	8b 45 14             	mov    0x14(%ebp),%eax
  8011e3:	83 c0 04             	add    $0x4,%eax
  8011e6:	89 45 14             	mov    %eax,0x14(%ebp)
  8011e9:	8b 45 14             	mov    0x14(%ebp),%eax
  8011ec:	83 e8 04             	sub    $0x4,%eax
  8011ef:	8b 00                	mov    (%eax),%eax
  8011f1:	83 ec 08             	sub    $0x8,%esp
  8011f4:	ff 75 0c             	pushl  0xc(%ebp)
  8011f7:	50                   	push   %eax
  8011f8:	8b 45 08             	mov    0x8(%ebp),%eax
  8011fb:	ff d0                	call   *%eax
  8011fd:	83 c4 10             	add    $0x10,%esp
			break;
  801200:	e9 89 02 00 00       	jmp    80148e <vprintfmt+0x3bc>

		// error message
		case 'e':
			err = va_arg(ap, int);
  801205:	8b 45 14             	mov    0x14(%ebp),%eax
  801208:	83 c0 04             	add    $0x4,%eax
  80120b:	89 45 14             	mov    %eax,0x14(%ebp)
  80120e:	8b 45 14             	mov    0x14(%ebp),%eax
  801211:	83 e8 04             	sub    $0x4,%eax
  801214:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  801216:	85 db                	test   %ebx,%ebx
  801218:	79 02                	jns    80121c <vprintfmt+0x14a>
				err = -err;
  80121a:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  80121c:	83 fb 64             	cmp    $0x64,%ebx
  80121f:	7f 0b                	jg     80122c <vprintfmt+0x15a>
  801221:	8b 34 9d 20 3e 80 00 	mov    0x803e20(,%ebx,4),%esi
  801228:	85 f6                	test   %esi,%esi
  80122a:	75 19                	jne    801245 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  80122c:	53                   	push   %ebx
  80122d:	68 c5 3f 80 00       	push   $0x803fc5
  801232:	ff 75 0c             	pushl  0xc(%ebp)
  801235:	ff 75 08             	pushl  0x8(%ebp)
  801238:	e8 5e 02 00 00       	call   80149b <printfmt>
  80123d:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  801240:	e9 49 02 00 00       	jmp    80148e <vprintfmt+0x3bc>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  801245:	56                   	push   %esi
  801246:	68 ce 3f 80 00       	push   $0x803fce
  80124b:	ff 75 0c             	pushl  0xc(%ebp)
  80124e:	ff 75 08             	pushl  0x8(%ebp)
  801251:	e8 45 02 00 00       	call   80149b <printfmt>
  801256:	83 c4 10             	add    $0x10,%esp
			break;
  801259:	e9 30 02 00 00       	jmp    80148e <vprintfmt+0x3bc>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  80125e:	8b 45 14             	mov    0x14(%ebp),%eax
  801261:	83 c0 04             	add    $0x4,%eax
  801264:	89 45 14             	mov    %eax,0x14(%ebp)
  801267:	8b 45 14             	mov    0x14(%ebp),%eax
  80126a:	83 e8 04             	sub    $0x4,%eax
  80126d:	8b 30                	mov    (%eax),%esi
  80126f:	85 f6                	test   %esi,%esi
  801271:	75 05                	jne    801278 <vprintfmt+0x1a6>
				p = "(null)";
  801273:	be d1 3f 80 00       	mov    $0x803fd1,%esi
			if (width > 0 && padc != '-')
  801278:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80127c:	7e 6d                	jle    8012eb <vprintfmt+0x219>
  80127e:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  801282:	74 67                	je     8012eb <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  801284:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801287:	83 ec 08             	sub    $0x8,%esp
  80128a:	50                   	push   %eax
  80128b:	56                   	push   %esi
  80128c:	e8 0c 03 00 00       	call   80159d <strnlen>
  801291:	83 c4 10             	add    $0x10,%esp
  801294:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  801297:	eb 16                	jmp    8012af <vprintfmt+0x1dd>
					putch(padc, putdat);
  801299:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  80129d:	83 ec 08             	sub    $0x8,%esp
  8012a0:	ff 75 0c             	pushl  0xc(%ebp)
  8012a3:	50                   	push   %eax
  8012a4:	8b 45 08             	mov    0x8(%ebp),%eax
  8012a7:	ff d0                	call   *%eax
  8012a9:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  8012ac:	ff 4d e4             	decl   -0x1c(%ebp)
  8012af:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8012b3:	7f e4                	jg     801299 <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8012b5:	eb 34                	jmp    8012eb <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  8012b7:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  8012bb:	74 1c                	je     8012d9 <vprintfmt+0x207>
  8012bd:	83 fb 1f             	cmp    $0x1f,%ebx
  8012c0:	7e 05                	jle    8012c7 <vprintfmt+0x1f5>
  8012c2:	83 fb 7e             	cmp    $0x7e,%ebx
  8012c5:	7e 12                	jle    8012d9 <vprintfmt+0x207>
					putch('?', putdat);
  8012c7:	83 ec 08             	sub    $0x8,%esp
  8012ca:	ff 75 0c             	pushl  0xc(%ebp)
  8012cd:	6a 3f                	push   $0x3f
  8012cf:	8b 45 08             	mov    0x8(%ebp),%eax
  8012d2:	ff d0                	call   *%eax
  8012d4:	83 c4 10             	add    $0x10,%esp
  8012d7:	eb 0f                	jmp    8012e8 <vprintfmt+0x216>
				else
					putch(ch, putdat);
  8012d9:	83 ec 08             	sub    $0x8,%esp
  8012dc:	ff 75 0c             	pushl  0xc(%ebp)
  8012df:	53                   	push   %ebx
  8012e0:	8b 45 08             	mov    0x8(%ebp),%eax
  8012e3:	ff d0                	call   *%eax
  8012e5:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8012e8:	ff 4d e4             	decl   -0x1c(%ebp)
  8012eb:	89 f0                	mov    %esi,%eax
  8012ed:	8d 70 01             	lea    0x1(%eax),%esi
  8012f0:	8a 00                	mov    (%eax),%al
  8012f2:	0f be d8             	movsbl %al,%ebx
  8012f5:	85 db                	test   %ebx,%ebx
  8012f7:	74 24                	je     80131d <vprintfmt+0x24b>
  8012f9:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8012fd:	78 b8                	js     8012b7 <vprintfmt+0x1e5>
  8012ff:	ff 4d e0             	decl   -0x20(%ebp)
  801302:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  801306:	79 af                	jns    8012b7 <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  801308:	eb 13                	jmp    80131d <vprintfmt+0x24b>
				putch(' ', putdat);
  80130a:	83 ec 08             	sub    $0x8,%esp
  80130d:	ff 75 0c             	pushl  0xc(%ebp)
  801310:	6a 20                	push   $0x20
  801312:	8b 45 08             	mov    0x8(%ebp),%eax
  801315:	ff d0                	call   *%eax
  801317:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  80131a:	ff 4d e4             	decl   -0x1c(%ebp)
  80131d:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  801321:	7f e7                	jg     80130a <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  801323:	e9 66 01 00 00       	jmp    80148e <vprintfmt+0x3bc>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  801328:	83 ec 08             	sub    $0x8,%esp
  80132b:	ff 75 e8             	pushl  -0x18(%ebp)
  80132e:	8d 45 14             	lea    0x14(%ebp),%eax
  801331:	50                   	push   %eax
  801332:	e8 3c fd ff ff       	call   801073 <getint>
  801337:	83 c4 10             	add    $0x10,%esp
  80133a:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80133d:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  801340:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801343:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801346:	85 d2                	test   %edx,%edx
  801348:	79 23                	jns    80136d <vprintfmt+0x29b>
				putch('-', putdat);
  80134a:	83 ec 08             	sub    $0x8,%esp
  80134d:	ff 75 0c             	pushl  0xc(%ebp)
  801350:	6a 2d                	push   $0x2d
  801352:	8b 45 08             	mov    0x8(%ebp),%eax
  801355:	ff d0                	call   *%eax
  801357:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  80135a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80135d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801360:	f7 d8                	neg    %eax
  801362:	83 d2 00             	adc    $0x0,%edx
  801365:	f7 da                	neg    %edx
  801367:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80136a:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  80136d:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  801374:	e9 bc 00 00 00       	jmp    801435 <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  801379:	83 ec 08             	sub    $0x8,%esp
  80137c:	ff 75 e8             	pushl  -0x18(%ebp)
  80137f:	8d 45 14             	lea    0x14(%ebp),%eax
  801382:	50                   	push   %eax
  801383:	e8 84 fc ff ff       	call   80100c <getuint>
  801388:	83 c4 10             	add    $0x10,%esp
  80138b:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80138e:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  801391:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  801398:	e9 98 00 00 00       	jmp    801435 <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  80139d:	83 ec 08             	sub    $0x8,%esp
  8013a0:	ff 75 0c             	pushl  0xc(%ebp)
  8013a3:	6a 58                	push   $0x58
  8013a5:	8b 45 08             	mov    0x8(%ebp),%eax
  8013a8:	ff d0                	call   *%eax
  8013aa:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  8013ad:	83 ec 08             	sub    $0x8,%esp
  8013b0:	ff 75 0c             	pushl  0xc(%ebp)
  8013b3:	6a 58                	push   $0x58
  8013b5:	8b 45 08             	mov    0x8(%ebp),%eax
  8013b8:	ff d0                	call   *%eax
  8013ba:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  8013bd:	83 ec 08             	sub    $0x8,%esp
  8013c0:	ff 75 0c             	pushl  0xc(%ebp)
  8013c3:	6a 58                	push   $0x58
  8013c5:	8b 45 08             	mov    0x8(%ebp),%eax
  8013c8:	ff d0                	call   *%eax
  8013ca:	83 c4 10             	add    $0x10,%esp
			break;
  8013cd:	e9 bc 00 00 00       	jmp    80148e <vprintfmt+0x3bc>

		// pointer
		case 'p':
			putch('0', putdat);
  8013d2:	83 ec 08             	sub    $0x8,%esp
  8013d5:	ff 75 0c             	pushl  0xc(%ebp)
  8013d8:	6a 30                	push   $0x30
  8013da:	8b 45 08             	mov    0x8(%ebp),%eax
  8013dd:	ff d0                	call   *%eax
  8013df:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  8013e2:	83 ec 08             	sub    $0x8,%esp
  8013e5:	ff 75 0c             	pushl  0xc(%ebp)
  8013e8:	6a 78                	push   $0x78
  8013ea:	8b 45 08             	mov    0x8(%ebp),%eax
  8013ed:	ff d0                	call   *%eax
  8013ef:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  8013f2:	8b 45 14             	mov    0x14(%ebp),%eax
  8013f5:	83 c0 04             	add    $0x4,%eax
  8013f8:	89 45 14             	mov    %eax,0x14(%ebp)
  8013fb:	8b 45 14             	mov    0x14(%ebp),%eax
  8013fe:	83 e8 04             	sub    $0x4,%eax
  801401:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  801403:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801406:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  80140d:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  801414:	eb 1f                	jmp    801435 <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  801416:	83 ec 08             	sub    $0x8,%esp
  801419:	ff 75 e8             	pushl  -0x18(%ebp)
  80141c:	8d 45 14             	lea    0x14(%ebp),%eax
  80141f:	50                   	push   %eax
  801420:	e8 e7 fb ff ff       	call   80100c <getuint>
  801425:	83 c4 10             	add    $0x10,%esp
  801428:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80142b:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  80142e:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  801435:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  801439:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80143c:	83 ec 04             	sub    $0x4,%esp
  80143f:	52                   	push   %edx
  801440:	ff 75 e4             	pushl  -0x1c(%ebp)
  801443:	50                   	push   %eax
  801444:	ff 75 f4             	pushl  -0xc(%ebp)
  801447:	ff 75 f0             	pushl  -0x10(%ebp)
  80144a:	ff 75 0c             	pushl  0xc(%ebp)
  80144d:	ff 75 08             	pushl  0x8(%ebp)
  801450:	e8 00 fb ff ff       	call   800f55 <printnum>
  801455:	83 c4 20             	add    $0x20,%esp
			break;
  801458:	eb 34                	jmp    80148e <vprintfmt+0x3bc>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  80145a:	83 ec 08             	sub    $0x8,%esp
  80145d:	ff 75 0c             	pushl  0xc(%ebp)
  801460:	53                   	push   %ebx
  801461:	8b 45 08             	mov    0x8(%ebp),%eax
  801464:	ff d0                	call   *%eax
  801466:	83 c4 10             	add    $0x10,%esp
			break;
  801469:	eb 23                	jmp    80148e <vprintfmt+0x3bc>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  80146b:	83 ec 08             	sub    $0x8,%esp
  80146e:	ff 75 0c             	pushl  0xc(%ebp)
  801471:	6a 25                	push   $0x25
  801473:	8b 45 08             	mov    0x8(%ebp),%eax
  801476:	ff d0                	call   *%eax
  801478:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  80147b:	ff 4d 10             	decl   0x10(%ebp)
  80147e:	eb 03                	jmp    801483 <vprintfmt+0x3b1>
  801480:	ff 4d 10             	decl   0x10(%ebp)
  801483:	8b 45 10             	mov    0x10(%ebp),%eax
  801486:	48                   	dec    %eax
  801487:	8a 00                	mov    (%eax),%al
  801489:	3c 25                	cmp    $0x25,%al
  80148b:	75 f3                	jne    801480 <vprintfmt+0x3ae>
				/* do nothing */;
			break;
  80148d:	90                   	nop
		}
	}
  80148e:	e9 47 fc ff ff       	jmp    8010da <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  801493:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  801494:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801497:	5b                   	pop    %ebx
  801498:	5e                   	pop    %esi
  801499:	5d                   	pop    %ebp
  80149a:	c3                   	ret    

0080149b <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  80149b:	55                   	push   %ebp
  80149c:	89 e5                	mov    %esp,%ebp
  80149e:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  8014a1:	8d 45 10             	lea    0x10(%ebp),%eax
  8014a4:	83 c0 04             	add    $0x4,%eax
  8014a7:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  8014aa:	8b 45 10             	mov    0x10(%ebp),%eax
  8014ad:	ff 75 f4             	pushl  -0xc(%ebp)
  8014b0:	50                   	push   %eax
  8014b1:	ff 75 0c             	pushl  0xc(%ebp)
  8014b4:	ff 75 08             	pushl  0x8(%ebp)
  8014b7:	e8 16 fc ff ff       	call   8010d2 <vprintfmt>
  8014bc:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  8014bf:	90                   	nop
  8014c0:	c9                   	leave  
  8014c1:	c3                   	ret    

008014c2 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  8014c2:	55                   	push   %ebp
  8014c3:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  8014c5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8014c8:	8b 40 08             	mov    0x8(%eax),%eax
  8014cb:	8d 50 01             	lea    0x1(%eax),%edx
  8014ce:	8b 45 0c             	mov    0xc(%ebp),%eax
  8014d1:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  8014d4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8014d7:	8b 10                	mov    (%eax),%edx
  8014d9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8014dc:	8b 40 04             	mov    0x4(%eax),%eax
  8014df:	39 c2                	cmp    %eax,%edx
  8014e1:	73 12                	jae    8014f5 <sprintputch+0x33>
		*b->buf++ = ch;
  8014e3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8014e6:	8b 00                	mov    (%eax),%eax
  8014e8:	8d 48 01             	lea    0x1(%eax),%ecx
  8014eb:	8b 55 0c             	mov    0xc(%ebp),%edx
  8014ee:	89 0a                	mov    %ecx,(%edx)
  8014f0:	8b 55 08             	mov    0x8(%ebp),%edx
  8014f3:	88 10                	mov    %dl,(%eax)
}
  8014f5:	90                   	nop
  8014f6:	5d                   	pop    %ebp
  8014f7:	c3                   	ret    

008014f8 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  8014f8:	55                   	push   %ebp
  8014f9:	89 e5                	mov    %esp,%ebp
  8014fb:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  8014fe:	8b 45 08             	mov    0x8(%ebp),%eax
  801501:	89 45 ec             	mov    %eax,-0x14(%ebp)
  801504:	8b 45 0c             	mov    0xc(%ebp),%eax
  801507:	8d 50 ff             	lea    -0x1(%eax),%edx
  80150a:	8b 45 08             	mov    0x8(%ebp),%eax
  80150d:	01 d0                	add    %edx,%eax
  80150f:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801512:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  801519:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80151d:	74 06                	je     801525 <vsnprintf+0x2d>
  80151f:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801523:	7f 07                	jg     80152c <vsnprintf+0x34>
		return -E_INVAL;
  801525:	b8 03 00 00 00       	mov    $0x3,%eax
  80152a:	eb 20                	jmp    80154c <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  80152c:	ff 75 14             	pushl  0x14(%ebp)
  80152f:	ff 75 10             	pushl  0x10(%ebp)
  801532:	8d 45 ec             	lea    -0x14(%ebp),%eax
  801535:	50                   	push   %eax
  801536:	68 c2 14 80 00       	push   $0x8014c2
  80153b:	e8 92 fb ff ff       	call   8010d2 <vprintfmt>
  801540:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  801543:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801546:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  801549:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  80154c:	c9                   	leave  
  80154d:	c3                   	ret    

0080154e <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  80154e:	55                   	push   %ebp
  80154f:	89 e5                	mov    %esp,%ebp
  801551:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  801554:	8d 45 10             	lea    0x10(%ebp),%eax
  801557:	83 c0 04             	add    $0x4,%eax
  80155a:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  80155d:	8b 45 10             	mov    0x10(%ebp),%eax
  801560:	ff 75 f4             	pushl  -0xc(%ebp)
  801563:	50                   	push   %eax
  801564:	ff 75 0c             	pushl  0xc(%ebp)
  801567:	ff 75 08             	pushl  0x8(%ebp)
  80156a:	e8 89 ff ff ff       	call   8014f8 <vsnprintf>
  80156f:	83 c4 10             	add    $0x10,%esp
  801572:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  801575:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801578:	c9                   	leave  
  801579:	c3                   	ret    

0080157a <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  80157a:	55                   	push   %ebp
  80157b:	89 e5                	mov    %esp,%ebp
  80157d:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  801580:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801587:	eb 06                	jmp    80158f <strlen+0x15>
		n++;
  801589:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  80158c:	ff 45 08             	incl   0x8(%ebp)
  80158f:	8b 45 08             	mov    0x8(%ebp),%eax
  801592:	8a 00                	mov    (%eax),%al
  801594:	84 c0                	test   %al,%al
  801596:	75 f1                	jne    801589 <strlen+0xf>
		n++;
	return n;
  801598:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  80159b:	c9                   	leave  
  80159c:	c3                   	ret    

0080159d <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  80159d:	55                   	push   %ebp
  80159e:	89 e5                	mov    %esp,%ebp
  8015a0:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8015a3:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8015aa:	eb 09                	jmp    8015b5 <strnlen+0x18>
		n++;
  8015ac:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8015af:	ff 45 08             	incl   0x8(%ebp)
  8015b2:	ff 4d 0c             	decl   0xc(%ebp)
  8015b5:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8015b9:	74 09                	je     8015c4 <strnlen+0x27>
  8015bb:	8b 45 08             	mov    0x8(%ebp),%eax
  8015be:	8a 00                	mov    (%eax),%al
  8015c0:	84 c0                	test   %al,%al
  8015c2:	75 e8                	jne    8015ac <strnlen+0xf>
		n++;
	return n;
  8015c4:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  8015c7:	c9                   	leave  
  8015c8:	c3                   	ret    

008015c9 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  8015c9:	55                   	push   %ebp
  8015ca:	89 e5                	mov    %esp,%ebp
  8015cc:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  8015cf:	8b 45 08             	mov    0x8(%ebp),%eax
  8015d2:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  8015d5:	90                   	nop
  8015d6:	8b 45 08             	mov    0x8(%ebp),%eax
  8015d9:	8d 50 01             	lea    0x1(%eax),%edx
  8015dc:	89 55 08             	mov    %edx,0x8(%ebp)
  8015df:	8b 55 0c             	mov    0xc(%ebp),%edx
  8015e2:	8d 4a 01             	lea    0x1(%edx),%ecx
  8015e5:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  8015e8:	8a 12                	mov    (%edx),%dl
  8015ea:	88 10                	mov    %dl,(%eax)
  8015ec:	8a 00                	mov    (%eax),%al
  8015ee:	84 c0                	test   %al,%al
  8015f0:	75 e4                	jne    8015d6 <strcpy+0xd>
		/* do nothing */;
	return ret;
  8015f2:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  8015f5:	c9                   	leave  
  8015f6:	c3                   	ret    

008015f7 <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  8015f7:	55                   	push   %ebp
  8015f8:	89 e5                	mov    %esp,%ebp
  8015fa:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  8015fd:	8b 45 08             	mov    0x8(%ebp),%eax
  801600:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  801603:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  80160a:	eb 1f                	jmp    80162b <strncpy+0x34>
		*dst++ = *src;
  80160c:	8b 45 08             	mov    0x8(%ebp),%eax
  80160f:	8d 50 01             	lea    0x1(%eax),%edx
  801612:	89 55 08             	mov    %edx,0x8(%ebp)
  801615:	8b 55 0c             	mov    0xc(%ebp),%edx
  801618:	8a 12                	mov    (%edx),%dl
  80161a:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  80161c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80161f:	8a 00                	mov    (%eax),%al
  801621:	84 c0                	test   %al,%al
  801623:	74 03                	je     801628 <strncpy+0x31>
			src++;
  801625:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  801628:	ff 45 fc             	incl   -0x4(%ebp)
  80162b:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80162e:	3b 45 10             	cmp    0x10(%ebp),%eax
  801631:	72 d9                	jb     80160c <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  801633:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  801636:	c9                   	leave  
  801637:	c3                   	ret    

00801638 <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  801638:	55                   	push   %ebp
  801639:	89 e5                	mov    %esp,%ebp
  80163b:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  80163e:	8b 45 08             	mov    0x8(%ebp),%eax
  801641:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  801644:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801648:	74 30                	je     80167a <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  80164a:	eb 16                	jmp    801662 <strlcpy+0x2a>
			*dst++ = *src++;
  80164c:	8b 45 08             	mov    0x8(%ebp),%eax
  80164f:	8d 50 01             	lea    0x1(%eax),%edx
  801652:	89 55 08             	mov    %edx,0x8(%ebp)
  801655:	8b 55 0c             	mov    0xc(%ebp),%edx
  801658:	8d 4a 01             	lea    0x1(%edx),%ecx
  80165b:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  80165e:	8a 12                	mov    (%edx),%dl
  801660:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  801662:	ff 4d 10             	decl   0x10(%ebp)
  801665:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801669:	74 09                	je     801674 <strlcpy+0x3c>
  80166b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80166e:	8a 00                	mov    (%eax),%al
  801670:	84 c0                	test   %al,%al
  801672:	75 d8                	jne    80164c <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  801674:	8b 45 08             	mov    0x8(%ebp),%eax
  801677:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  80167a:	8b 55 08             	mov    0x8(%ebp),%edx
  80167d:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801680:	29 c2                	sub    %eax,%edx
  801682:	89 d0                	mov    %edx,%eax
}
  801684:	c9                   	leave  
  801685:	c3                   	ret    

00801686 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  801686:	55                   	push   %ebp
  801687:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  801689:	eb 06                	jmp    801691 <strcmp+0xb>
		p++, q++;
  80168b:	ff 45 08             	incl   0x8(%ebp)
  80168e:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  801691:	8b 45 08             	mov    0x8(%ebp),%eax
  801694:	8a 00                	mov    (%eax),%al
  801696:	84 c0                	test   %al,%al
  801698:	74 0e                	je     8016a8 <strcmp+0x22>
  80169a:	8b 45 08             	mov    0x8(%ebp),%eax
  80169d:	8a 10                	mov    (%eax),%dl
  80169f:	8b 45 0c             	mov    0xc(%ebp),%eax
  8016a2:	8a 00                	mov    (%eax),%al
  8016a4:	38 c2                	cmp    %al,%dl
  8016a6:	74 e3                	je     80168b <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  8016a8:	8b 45 08             	mov    0x8(%ebp),%eax
  8016ab:	8a 00                	mov    (%eax),%al
  8016ad:	0f b6 d0             	movzbl %al,%edx
  8016b0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8016b3:	8a 00                	mov    (%eax),%al
  8016b5:	0f b6 c0             	movzbl %al,%eax
  8016b8:	29 c2                	sub    %eax,%edx
  8016ba:	89 d0                	mov    %edx,%eax
}
  8016bc:	5d                   	pop    %ebp
  8016bd:	c3                   	ret    

008016be <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  8016be:	55                   	push   %ebp
  8016bf:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  8016c1:	eb 09                	jmp    8016cc <strncmp+0xe>
		n--, p++, q++;
  8016c3:	ff 4d 10             	decl   0x10(%ebp)
  8016c6:	ff 45 08             	incl   0x8(%ebp)
  8016c9:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  8016cc:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8016d0:	74 17                	je     8016e9 <strncmp+0x2b>
  8016d2:	8b 45 08             	mov    0x8(%ebp),%eax
  8016d5:	8a 00                	mov    (%eax),%al
  8016d7:	84 c0                	test   %al,%al
  8016d9:	74 0e                	je     8016e9 <strncmp+0x2b>
  8016db:	8b 45 08             	mov    0x8(%ebp),%eax
  8016de:	8a 10                	mov    (%eax),%dl
  8016e0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8016e3:	8a 00                	mov    (%eax),%al
  8016e5:	38 c2                	cmp    %al,%dl
  8016e7:	74 da                	je     8016c3 <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  8016e9:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8016ed:	75 07                	jne    8016f6 <strncmp+0x38>
		return 0;
  8016ef:	b8 00 00 00 00       	mov    $0x0,%eax
  8016f4:	eb 14                	jmp    80170a <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  8016f6:	8b 45 08             	mov    0x8(%ebp),%eax
  8016f9:	8a 00                	mov    (%eax),%al
  8016fb:	0f b6 d0             	movzbl %al,%edx
  8016fe:	8b 45 0c             	mov    0xc(%ebp),%eax
  801701:	8a 00                	mov    (%eax),%al
  801703:	0f b6 c0             	movzbl %al,%eax
  801706:	29 c2                	sub    %eax,%edx
  801708:	89 d0                	mov    %edx,%eax
}
  80170a:	5d                   	pop    %ebp
  80170b:	c3                   	ret    

0080170c <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  80170c:	55                   	push   %ebp
  80170d:	89 e5                	mov    %esp,%ebp
  80170f:	83 ec 04             	sub    $0x4,%esp
  801712:	8b 45 0c             	mov    0xc(%ebp),%eax
  801715:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  801718:	eb 12                	jmp    80172c <strchr+0x20>
		if (*s == c)
  80171a:	8b 45 08             	mov    0x8(%ebp),%eax
  80171d:	8a 00                	mov    (%eax),%al
  80171f:	3a 45 fc             	cmp    -0x4(%ebp),%al
  801722:	75 05                	jne    801729 <strchr+0x1d>
			return (char *) s;
  801724:	8b 45 08             	mov    0x8(%ebp),%eax
  801727:	eb 11                	jmp    80173a <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  801729:	ff 45 08             	incl   0x8(%ebp)
  80172c:	8b 45 08             	mov    0x8(%ebp),%eax
  80172f:	8a 00                	mov    (%eax),%al
  801731:	84 c0                	test   %al,%al
  801733:	75 e5                	jne    80171a <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  801735:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80173a:	c9                   	leave  
  80173b:	c3                   	ret    

0080173c <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  80173c:	55                   	push   %ebp
  80173d:	89 e5                	mov    %esp,%ebp
  80173f:	83 ec 04             	sub    $0x4,%esp
  801742:	8b 45 0c             	mov    0xc(%ebp),%eax
  801745:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  801748:	eb 0d                	jmp    801757 <strfind+0x1b>
		if (*s == c)
  80174a:	8b 45 08             	mov    0x8(%ebp),%eax
  80174d:	8a 00                	mov    (%eax),%al
  80174f:	3a 45 fc             	cmp    -0x4(%ebp),%al
  801752:	74 0e                	je     801762 <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  801754:	ff 45 08             	incl   0x8(%ebp)
  801757:	8b 45 08             	mov    0x8(%ebp),%eax
  80175a:	8a 00                	mov    (%eax),%al
  80175c:	84 c0                	test   %al,%al
  80175e:	75 ea                	jne    80174a <strfind+0xe>
  801760:	eb 01                	jmp    801763 <strfind+0x27>
		if (*s == c)
			break;
  801762:	90                   	nop
	return (char *) s;
  801763:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801766:	c9                   	leave  
  801767:	c3                   	ret    

00801768 <memset>:


void *
memset(void *v, int c, uint32 n)
{
  801768:	55                   	push   %ebp
  801769:	89 e5                	mov    %esp,%ebp
  80176b:	83 ec 10             	sub    $0x10,%esp
	char *p;
	int m;

	p = v;
  80176e:	8b 45 08             	mov    0x8(%ebp),%eax
  801771:	89 45 fc             	mov    %eax,-0x4(%ebp)
	m = n;
  801774:	8b 45 10             	mov    0x10(%ebp),%eax
  801777:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (--m >= 0)
  80177a:	eb 0e                	jmp    80178a <memset+0x22>
		*p++ = c;
  80177c:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80177f:	8d 50 01             	lea    0x1(%eax),%edx
  801782:	89 55 fc             	mov    %edx,-0x4(%ebp)
  801785:	8b 55 0c             	mov    0xc(%ebp),%edx
  801788:	88 10                	mov    %dl,(%eax)
	char *p;
	int m;

	p = v;
	m = n;
	while (--m >= 0)
  80178a:	ff 4d f8             	decl   -0x8(%ebp)
  80178d:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  801791:	79 e9                	jns    80177c <memset+0x14>
		*p++ = c;

	return v;
  801793:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801796:	c9                   	leave  
  801797:	c3                   	ret    

00801798 <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  801798:	55                   	push   %ebp
  801799:	89 e5                	mov    %esp,%ebp
  80179b:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  80179e:	8b 45 0c             	mov    0xc(%ebp),%eax
  8017a1:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  8017a4:	8b 45 08             	mov    0x8(%ebp),%eax
  8017a7:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (n-- > 0)
  8017aa:	eb 16                	jmp    8017c2 <memcpy+0x2a>
		*d++ = *s++;
  8017ac:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8017af:	8d 50 01             	lea    0x1(%eax),%edx
  8017b2:	89 55 f8             	mov    %edx,-0x8(%ebp)
  8017b5:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8017b8:	8d 4a 01             	lea    0x1(%edx),%ecx
  8017bb:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  8017be:	8a 12                	mov    (%edx),%dl
  8017c0:	88 10                	mov    %dl,(%eax)
	const char *s;
	char *d;

	s = src;
	d = dst;
	while (n-- > 0)
  8017c2:	8b 45 10             	mov    0x10(%ebp),%eax
  8017c5:	8d 50 ff             	lea    -0x1(%eax),%edx
  8017c8:	89 55 10             	mov    %edx,0x10(%ebp)
  8017cb:	85 c0                	test   %eax,%eax
  8017cd:	75 dd                	jne    8017ac <memcpy+0x14>
		*d++ = *s++;

	return dst;
  8017cf:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8017d2:	c9                   	leave  
  8017d3:	c3                   	ret    

008017d4 <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  8017d4:	55                   	push   %ebp
  8017d5:	89 e5                	mov    %esp,%ebp
  8017d7:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  8017da:	8b 45 0c             	mov    0xc(%ebp),%eax
  8017dd:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  8017e0:	8b 45 08             	mov    0x8(%ebp),%eax
  8017e3:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  8017e6:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8017e9:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  8017ec:	73 50                	jae    80183e <memmove+0x6a>
  8017ee:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8017f1:	8b 45 10             	mov    0x10(%ebp),%eax
  8017f4:	01 d0                	add    %edx,%eax
  8017f6:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  8017f9:	76 43                	jbe    80183e <memmove+0x6a>
		s += n;
  8017fb:	8b 45 10             	mov    0x10(%ebp),%eax
  8017fe:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  801801:	8b 45 10             	mov    0x10(%ebp),%eax
  801804:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  801807:	eb 10                	jmp    801819 <memmove+0x45>
			*--d = *--s;
  801809:	ff 4d f8             	decl   -0x8(%ebp)
  80180c:	ff 4d fc             	decl   -0x4(%ebp)
  80180f:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801812:	8a 10                	mov    (%eax),%dl
  801814:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801817:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  801819:	8b 45 10             	mov    0x10(%ebp),%eax
  80181c:	8d 50 ff             	lea    -0x1(%eax),%edx
  80181f:	89 55 10             	mov    %edx,0x10(%ebp)
  801822:	85 c0                	test   %eax,%eax
  801824:	75 e3                	jne    801809 <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  801826:	eb 23                	jmp    80184b <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  801828:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80182b:	8d 50 01             	lea    0x1(%eax),%edx
  80182e:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801831:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801834:	8d 4a 01             	lea    0x1(%edx),%ecx
  801837:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  80183a:	8a 12                	mov    (%edx),%dl
  80183c:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  80183e:	8b 45 10             	mov    0x10(%ebp),%eax
  801841:	8d 50 ff             	lea    -0x1(%eax),%edx
  801844:	89 55 10             	mov    %edx,0x10(%ebp)
  801847:	85 c0                	test   %eax,%eax
  801849:	75 dd                	jne    801828 <memmove+0x54>
			*d++ = *s++;

	return dst;
  80184b:	8b 45 08             	mov    0x8(%ebp),%eax
}
  80184e:	c9                   	leave  
  80184f:	c3                   	ret    

00801850 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  801850:	55                   	push   %ebp
  801851:	89 e5                	mov    %esp,%ebp
  801853:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  801856:	8b 45 08             	mov    0x8(%ebp),%eax
  801859:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  80185c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80185f:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  801862:	eb 2a                	jmp    80188e <memcmp+0x3e>
		if (*s1 != *s2)
  801864:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801867:	8a 10                	mov    (%eax),%dl
  801869:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80186c:	8a 00                	mov    (%eax),%al
  80186e:	38 c2                	cmp    %al,%dl
  801870:	74 16                	je     801888 <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  801872:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801875:	8a 00                	mov    (%eax),%al
  801877:	0f b6 d0             	movzbl %al,%edx
  80187a:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80187d:	8a 00                	mov    (%eax),%al
  80187f:	0f b6 c0             	movzbl %al,%eax
  801882:	29 c2                	sub    %eax,%edx
  801884:	89 d0                	mov    %edx,%eax
  801886:	eb 18                	jmp    8018a0 <memcmp+0x50>
		s1++, s2++;
  801888:	ff 45 fc             	incl   -0x4(%ebp)
  80188b:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  80188e:	8b 45 10             	mov    0x10(%ebp),%eax
  801891:	8d 50 ff             	lea    -0x1(%eax),%edx
  801894:	89 55 10             	mov    %edx,0x10(%ebp)
  801897:	85 c0                	test   %eax,%eax
  801899:	75 c9                	jne    801864 <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  80189b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8018a0:	c9                   	leave  
  8018a1:	c3                   	ret    

008018a2 <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  8018a2:	55                   	push   %ebp
  8018a3:	89 e5                	mov    %esp,%ebp
  8018a5:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  8018a8:	8b 55 08             	mov    0x8(%ebp),%edx
  8018ab:	8b 45 10             	mov    0x10(%ebp),%eax
  8018ae:	01 d0                	add    %edx,%eax
  8018b0:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  8018b3:	eb 15                	jmp    8018ca <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  8018b5:	8b 45 08             	mov    0x8(%ebp),%eax
  8018b8:	8a 00                	mov    (%eax),%al
  8018ba:	0f b6 d0             	movzbl %al,%edx
  8018bd:	8b 45 0c             	mov    0xc(%ebp),%eax
  8018c0:	0f b6 c0             	movzbl %al,%eax
  8018c3:	39 c2                	cmp    %eax,%edx
  8018c5:	74 0d                	je     8018d4 <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  8018c7:	ff 45 08             	incl   0x8(%ebp)
  8018ca:	8b 45 08             	mov    0x8(%ebp),%eax
  8018cd:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  8018d0:	72 e3                	jb     8018b5 <memfind+0x13>
  8018d2:	eb 01                	jmp    8018d5 <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  8018d4:	90                   	nop
	return (void *) s;
  8018d5:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8018d8:	c9                   	leave  
  8018d9:	c3                   	ret    

008018da <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  8018da:	55                   	push   %ebp
  8018db:	89 e5                	mov    %esp,%ebp
  8018dd:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  8018e0:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  8018e7:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  8018ee:	eb 03                	jmp    8018f3 <strtol+0x19>
		s++;
  8018f0:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  8018f3:	8b 45 08             	mov    0x8(%ebp),%eax
  8018f6:	8a 00                	mov    (%eax),%al
  8018f8:	3c 20                	cmp    $0x20,%al
  8018fa:	74 f4                	je     8018f0 <strtol+0x16>
  8018fc:	8b 45 08             	mov    0x8(%ebp),%eax
  8018ff:	8a 00                	mov    (%eax),%al
  801901:	3c 09                	cmp    $0x9,%al
  801903:	74 eb                	je     8018f0 <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  801905:	8b 45 08             	mov    0x8(%ebp),%eax
  801908:	8a 00                	mov    (%eax),%al
  80190a:	3c 2b                	cmp    $0x2b,%al
  80190c:	75 05                	jne    801913 <strtol+0x39>
		s++;
  80190e:	ff 45 08             	incl   0x8(%ebp)
  801911:	eb 13                	jmp    801926 <strtol+0x4c>
	else if (*s == '-')
  801913:	8b 45 08             	mov    0x8(%ebp),%eax
  801916:	8a 00                	mov    (%eax),%al
  801918:	3c 2d                	cmp    $0x2d,%al
  80191a:	75 0a                	jne    801926 <strtol+0x4c>
		s++, neg = 1;
  80191c:	ff 45 08             	incl   0x8(%ebp)
  80191f:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  801926:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80192a:	74 06                	je     801932 <strtol+0x58>
  80192c:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  801930:	75 20                	jne    801952 <strtol+0x78>
  801932:	8b 45 08             	mov    0x8(%ebp),%eax
  801935:	8a 00                	mov    (%eax),%al
  801937:	3c 30                	cmp    $0x30,%al
  801939:	75 17                	jne    801952 <strtol+0x78>
  80193b:	8b 45 08             	mov    0x8(%ebp),%eax
  80193e:	40                   	inc    %eax
  80193f:	8a 00                	mov    (%eax),%al
  801941:	3c 78                	cmp    $0x78,%al
  801943:	75 0d                	jne    801952 <strtol+0x78>
		s += 2, base = 16;
  801945:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  801949:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  801950:	eb 28                	jmp    80197a <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  801952:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801956:	75 15                	jne    80196d <strtol+0x93>
  801958:	8b 45 08             	mov    0x8(%ebp),%eax
  80195b:	8a 00                	mov    (%eax),%al
  80195d:	3c 30                	cmp    $0x30,%al
  80195f:	75 0c                	jne    80196d <strtol+0x93>
		s++, base = 8;
  801961:	ff 45 08             	incl   0x8(%ebp)
  801964:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  80196b:	eb 0d                	jmp    80197a <strtol+0xa0>
	else if (base == 0)
  80196d:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801971:	75 07                	jne    80197a <strtol+0xa0>
		base = 10;
  801973:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  80197a:	8b 45 08             	mov    0x8(%ebp),%eax
  80197d:	8a 00                	mov    (%eax),%al
  80197f:	3c 2f                	cmp    $0x2f,%al
  801981:	7e 19                	jle    80199c <strtol+0xc2>
  801983:	8b 45 08             	mov    0x8(%ebp),%eax
  801986:	8a 00                	mov    (%eax),%al
  801988:	3c 39                	cmp    $0x39,%al
  80198a:	7f 10                	jg     80199c <strtol+0xc2>
			dig = *s - '0';
  80198c:	8b 45 08             	mov    0x8(%ebp),%eax
  80198f:	8a 00                	mov    (%eax),%al
  801991:	0f be c0             	movsbl %al,%eax
  801994:	83 e8 30             	sub    $0x30,%eax
  801997:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80199a:	eb 42                	jmp    8019de <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  80199c:	8b 45 08             	mov    0x8(%ebp),%eax
  80199f:	8a 00                	mov    (%eax),%al
  8019a1:	3c 60                	cmp    $0x60,%al
  8019a3:	7e 19                	jle    8019be <strtol+0xe4>
  8019a5:	8b 45 08             	mov    0x8(%ebp),%eax
  8019a8:	8a 00                	mov    (%eax),%al
  8019aa:	3c 7a                	cmp    $0x7a,%al
  8019ac:	7f 10                	jg     8019be <strtol+0xe4>
			dig = *s - 'a' + 10;
  8019ae:	8b 45 08             	mov    0x8(%ebp),%eax
  8019b1:	8a 00                	mov    (%eax),%al
  8019b3:	0f be c0             	movsbl %al,%eax
  8019b6:	83 e8 57             	sub    $0x57,%eax
  8019b9:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8019bc:	eb 20                	jmp    8019de <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  8019be:	8b 45 08             	mov    0x8(%ebp),%eax
  8019c1:	8a 00                	mov    (%eax),%al
  8019c3:	3c 40                	cmp    $0x40,%al
  8019c5:	7e 39                	jle    801a00 <strtol+0x126>
  8019c7:	8b 45 08             	mov    0x8(%ebp),%eax
  8019ca:	8a 00                	mov    (%eax),%al
  8019cc:	3c 5a                	cmp    $0x5a,%al
  8019ce:	7f 30                	jg     801a00 <strtol+0x126>
			dig = *s - 'A' + 10;
  8019d0:	8b 45 08             	mov    0x8(%ebp),%eax
  8019d3:	8a 00                	mov    (%eax),%al
  8019d5:	0f be c0             	movsbl %al,%eax
  8019d8:	83 e8 37             	sub    $0x37,%eax
  8019db:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  8019de:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8019e1:	3b 45 10             	cmp    0x10(%ebp),%eax
  8019e4:	7d 19                	jge    8019ff <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  8019e6:	ff 45 08             	incl   0x8(%ebp)
  8019e9:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8019ec:	0f af 45 10          	imul   0x10(%ebp),%eax
  8019f0:	89 c2                	mov    %eax,%edx
  8019f2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8019f5:	01 d0                	add    %edx,%eax
  8019f7:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  8019fa:	e9 7b ff ff ff       	jmp    80197a <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  8019ff:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  801a00:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801a04:	74 08                	je     801a0e <strtol+0x134>
		*endptr = (char *) s;
  801a06:	8b 45 0c             	mov    0xc(%ebp),%eax
  801a09:	8b 55 08             	mov    0x8(%ebp),%edx
  801a0c:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  801a0e:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801a12:	74 07                	je     801a1b <strtol+0x141>
  801a14:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801a17:	f7 d8                	neg    %eax
  801a19:	eb 03                	jmp    801a1e <strtol+0x144>
  801a1b:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  801a1e:	c9                   	leave  
  801a1f:	c3                   	ret    

00801a20 <ltostr>:

void
ltostr(long value, char *str)
{
  801a20:	55                   	push   %ebp
  801a21:	89 e5                	mov    %esp,%ebp
  801a23:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  801a26:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  801a2d:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  801a34:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801a38:	79 13                	jns    801a4d <ltostr+0x2d>
	{
		neg = 1;
  801a3a:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  801a41:	8b 45 0c             	mov    0xc(%ebp),%eax
  801a44:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  801a47:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  801a4a:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  801a4d:	8b 45 08             	mov    0x8(%ebp),%eax
  801a50:	b9 0a 00 00 00       	mov    $0xa,%ecx
  801a55:	99                   	cltd   
  801a56:	f7 f9                	idiv   %ecx
  801a58:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  801a5b:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801a5e:	8d 50 01             	lea    0x1(%eax),%edx
  801a61:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801a64:	89 c2                	mov    %eax,%edx
  801a66:	8b 45 0c             	mov    0xc(%ebp),%eax
  801a69:	01 d0                	add    %edx,%eax
  801a6b:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801a6e:	83 c2 30             	add    $0x30,%edx
  801a71:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  801a73:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801a76:	b8 67 66 66 66       	mov    $0x66666667,%eax
  801a7b:	f7 e9                	imul   %ecx
  801a7d:	c1 fa 02             	sar    $0x2,%edx
  801a80:	89 c8                	mov    %ecx,%eax
  801a82:	c1 f8 1f             	sar    $0x1f,%eax
  801a85:	29 c2                	sub    %eax,%edx
  801a87:	89 d0                	mov    %edx,%eax
  801a89:	89 45 08             	mov    %eax,0x8(%ebp)
	} while (value % 10 != 0);
  801a8c:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801a8f:	b8 67 66 66 66       	mov    $0x66666667,%eax
  801a94:	f7 e9                	imul   %ecx
  801a96:	c1 fa 02             	sar    $0x2,%edx
  801a99:	89 c8                	mov    %ecx,%eax
  801a9b:	c1 f8 1f             	sar    $0x1f,%eax
  801a9e:	29 c2                	sub    %eax,%edx
  801aa0:	89 d0                	mov    %edx,%eax
  801aa2:	c1 e0 02             	shl    $0x2,%eax
  801aa5:	01 d0                	add    %edx,%eax
  801aa7:	01 c0                	add    %eax,%eax
  801aa9:	29 c1                	sub    %eax,%ecx
  801aab:	89 ca                	mov    %ecx,%edx
  801aad:	85 d2                	test   %edx,%edx
  801aaf:	75 9c                	jne    801a4d <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  801ab1:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  801ab8:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801abb:	48                   	dec    %eax
  801abc:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  801abf:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801ac3:	74 3d                	je     801b02 <ltostr+0xe2>
		start = 1 ;
  801ac5:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  801acc:	eb 34                	jmp    801b02 <ltostr+0xe2>
	{
		char tmp = str[start] ;
  801ace:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801ad1:	8b 45 0c             	mov    0xc(%ebp),%eax
  801ad4:	01 d0                	add    %edx,%eax
  801ad6:	8a 00                	mov    (%eax),%al
  801ad8:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  801adb:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801ade:	8b 45 0c             	mov    0xc(%ebp),%eax
  801ae1:	01 c2                	add    %eax,%edx
  801ae3:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  801ae6:	8b 45 0c             	mov    0xc(%ebp),%eax
  801ae9:	01 c8                	add    %ecx,%eax
  801aeb:	8a 00                	mov    (%eax),%al
  801aed:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  801aef:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801af2:	8b 45 0c             	mov    0xc(%ebp),%eax
  801af5:	01 c2                	add    %eax,%edx
  801af7:	8a 45 eb             	mov    -0x15(%ebp),%al
  801afa:	88 02                	mov    %al,(%edx)
		start++ ;
  801afc:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  801aff:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  801b02:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801b05:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801b08:	7c c4                	jl     801ace <ltostr+0xae>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  801b0a:	8b 55 f8             	mov    -0x8(%ebp),%edx
  801b0d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801b10:	01 d0                	add    %edx,%eax
  801b12:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  801b15:	90                   	nop
  801b16:	c9                   	leave  
  801b17:	c3                   	ret    

00801b18 <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  801b18:	55                   	push   %ebp
  801b19:	89 e5                	mov    %esp,%ebp
  801b1b:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  801b1e:	ff 75 08             	pushl  0x8(%ebp)
  801b21:	e8 54 fa ff ff       	call   80157a <strlen>
  801b26:	83 c4 04             	add    $0x4,%esp
  801b29:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  801b2c:	ff 75 0c             	pushl  0xc(%ebp)
  801b2f:	e8 46 fa ff ff       	call   80157a <strlen>
  801b34:	83 c4 04             	add    $0x4,%esp
  801b37:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  801b3a:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  801b41:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801b48:	eb 17                	jmp    801b61 <strcconcat+0x49>
		final[s] = str1[s] ;
  801b4a:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801b4d:	8b 45 10             	mov    0x10(%ebp),%eax
  801b50:	01 c2                	add    %eax,%edx
  801b52:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  801b55:	8b 45 08             	mov    0x8(%ebp),%eax
  801b58:	01 c8                	add    %ecx,%eax
  801b5a:	8a 00                	mov    (%eax),%al
  801b5c:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  801b5e:	ff 45 fc             	incl   -0x4(%ebp)
  801b61:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801b64:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  801b67:	7c e1                	jl     801b4a <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  801b69:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  801b70:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  801b77:	eb 1f                	jmp    801b98 <strcconcat+0x80>
		final[s++] = str2[i] ;
  801b79:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801b7c:	8d 50 01             	lea    0x1(%eax),%edx
  801b7f:	89 55 fc             	mov    %edx,-0x4(%ebp)
  801b82:	89 c2                	mov    %eax,%edx
  801b84:	8b 45 10             	mov    0x10(%ebp),%eax
  801b87:	01 c2                	add    %eax,%edx
  801b89:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  801b8c:	8b 45 0c             	mov    0xc(%ebp),%eax
  801b8f:	01 c8                	add    %ecx,%eax
  801b91:	8a 00                	mov    (%eax),%al
  801b93:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  801b95:	ff 45 f8             	incl   -0x8(%ebp)
  801b98:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801b9b:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801b9e:	7c d9                	jl     801b79 <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  801ba0:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801ba3:	8b 45 10             	mov    0x10(%ebp),%eax
  801ba6:	01 d0                	add    %edx,%eax
  801ba8:	c6 00 00             	movb   $0x0,(%eax)
}
  801bab:	90                   	nop
  801bac:	c9                   	leave  
  801bad:	c3                   	ret    

00801bae <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  801bae:	55                   	push   %ebp
  801baf:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  801bb1:	8b 45 14             	mov    0x14(%ebp),%eax
  801bb4:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  801bba:	8b 45 14             	mov    0x14(%ebp),%eax
  801bbd:	8b 00                	mov    (%eax),%eax
  801bbf:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801bc6:	8b 45 10             	mov    0x10(%ebp),%eax
  801bc9:	01 d0                	add    %edx,%eax
  801bcb:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801bd1:	eb 0c                	jmp    801bdf <strsplit+0x31>
			*string++ = 0;
  801bd3:	8b 45 08             	mov    0x8(%ebp),%eax
  801bd6:	8d 50 01             	lea    0x1(%eax),%edx
  801bd9:	89 55 08             	mov    %edx,0x8(%ebp)
  801bdc:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801bdf:	8b 45 08             	mov    0x8(%ebp),%eax
  801be2:	8a 00                	mov    (%eax),%al
  801be4:	84 c0                	test   %al,%al
  801be6:	74 18                	je     801c00 <strsplit+0x52>
  801be8:	8b 45 08             	mov    0x8(%ebp),%eax
  801beb:	8a 00                	mov    (%eax),%al
  801bed:	0f be c0             	movsbl %al,%eax
  801bf0:	50                   	push   %eax
  801bf1:	ff 75 0c             	pushl  0xc(%ebp)
  801bf4:	e8 13 fb ff ff       	call   80170c <strchr>
  801bf9:	83 c4 08             	add    $0x8,%esp
  801bfc:	85 c0                	test   %eax,%eax
  801bfe:	75 d3                	jne    801bd3 <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  801c00:	8b 45 08             	mov    0x8(%ebp),%eax
  801c03:	8a 00                	mov    (%eax),%al
  801c05:	84 c0                	test   %al,%al
  801c07:	74 5a                	je     801c63 <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  801c09:	8b 45 14             	mov    0x14(%ebp),%eax
  801c0c:	8b 00                	mov    (%eax),%eax
  801c0e:	83 f8 0f             	cmp    $0xf,%eax
  801c11:	75 07                	jne    801c1a <strsplit+0x6c>
		{
			return 0;
  801c13:	b8 00 00 00 00       	mov    $0x0,%eax
  801c18:	eb 66                	jmp    801c80 <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  801c1a:	8b 45 14             	mov    0x14(%ebp),%eax
  801c1d:	8b 00                	mov    (%eax),%eax
  801c1f:	8d 48 01             	lea    0x1(%eax),%ecx
  801c22:	8b 55 14             	mov    0x14(%ebp),%edx
  801c25:	89 0a                	mov    %ecx,(%edx)
  801c27:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801c2e:	8b 45 10             	mov    0x10(%ebp),%eax
  801c31:	01 c2                	add    %eax,%edx
  801c33:	8b 45 08             	mov    0x8(%ebp),%eax
  801c36:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  801c38:	eb 03                	jmp    801c3d <strsplit+0x8f>
			string++;
  801c3a:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  801c3d:	8b 45 08             	mov    0x8(%ebp),%eax
  801c40:	8a 00                	mov    (%eax),%al
  801c42:	84 c0                	test   %al,%al
  801c44:	74 8b                	je     801bd1 <strsplit+0x23>
  801c46:	8b 45 08             	mov    0x8(%ebp),%eax
  801c49:	8a 00                	mov    (%eax),%al
  801c4b:	0f be c0             	movsbl %al,%eax
  801c4e:	50                   	push   %eax
  801c4f:	ff 75 0c             	pushl  0xc(%ebp)
  801c52:	e8 b5 fa ff ff       	call   80170c <strchr>
  801c57:	83 c4 08             	add    $0x8,%esp
  801c5a:	85 c0                	test   %eax,%eax
  801c5c:	74 dc                	je     801c3a <strsplit+0x8c>
			string++;
	}
  801c5e:	e9 6e ff ff ff       	jmp    801bd1 <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  801c63:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  801c64:	8b 45 14             	mov    0x14(%ebp),%eax
  801c67:	8b 00                	mov    (%eax),%eax
  801c69:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801c70:	8b 45 10             	mov    0x10(%ebp),%eax
  801c73:	01 d0                	add    %edx,%eax
  801c75:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  801c7b:	b8 01 00 00 00       	mov    $0x1,%eax
}
  801c80:	c9                   	leave  
  801c81:	c3                   	ret    

00801c82 <InitializeUHeap>:
//============================== GIVEN FUNCTIONS ===================================//
//==================================================================================//

int FirstTimeFlag = 1;
void InitializeUHeap()
{
  801c82:	55                   	push   %ebp
  801c83:	89 e5                	mov    %esp,%ebp
  801c85:	83 ec 08             	sub    $0x8,%esp
	if(FirstTimeFlag)
  801c88:	a1 04 50 80 00       	mov    0x805004,%eax
  801c8d:	85 c0                	test   %eax,%eax
  801c8f:	74 1f                	je     801cb0 <InitializeUHeap+0x2e>
	{
		initialize_dyn_block_system();
  801c91:	e8 1d 00 00 00       	call   801cb3 <initialize_dyn_block_system>
		cprintf("DYNAMIC BLOCK SYSTEM IS INITIALIZED\n");
  801c96:	83 ec 0c             	sub    $0xc,%esp
  801c99:	68 30 41 80 00       	push   $0x804130
  801c9e:	e8 55 f2 ff ff       	call   800ef8 <cprintf>
  801ca3:	83 c4 10             	add    $0x10,%esp
#if UHP_USE_BUDDY
		initialize_buddy();
		cprintf("BUDDY SYSTEM IS INITIALIZED\n");
#endif
		FirstTimeFlag = 0;
  801ca6:	c7 05 04 50 80 00 00 	movl   $0x0,0x805004
  801cad:	00 00 00 
	}
}
  801cb0:	90                   	nop
  801cb1:	c9                   	leave  
  801cb2:	c3                   	ret    

00801cb3 <initialize_dyn_block_system>:

//=================================
// [1] INITIALIZE DYNAMIC ALLOCATOR:
//=================================
void initialize_dyn_block_system()
{
  801cb3:	55                   	push   %ebp
  801cb4:	89 e5                	mov    %esp,%ebp
  801cb6:	83 ec 28             	sub    $0x28,%esp
	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] initialize_dyn_block_system
	// your code is here, remove the panic and write your code
	//panic("initialize_dyn_block_system() is not implemented yet...!!");

	LIST_INIT(&AllocMemBlocksList);
  801cb9:	c7 05 40 50 80 00 00 	movl   $0x0,0x805040
  801cc0:	00 00 00 
  801cc3:	c7 05 44 50 80 00 00 	movl   $0x0,0x805044
  801cca:	00 00 00 
  801ccd:	c7 05 4c 50 80 00 00 	movl   $0x0,0x80504c
  801cd4:	00 00 00 
	LIST_INIT(&FreeMemBlocksList);
  801cd7:	c7 05 38 51 80 00 00 	movl   $0x0,0x805138
  801cde:	00 00 00 
  801ce1:	c7 05 3c 51 80 00 00 	movl   $0x0,0x80513c
  801ce8:	00 00 00 
  801ceb:	c7 05 44 51 80 00 00 	movl   $0x0,0x805144
  801cf2:	00 00 00 
	MAX_MEM_BLOCK_CNT = NUM_OF_UHEAP_PAGES;
  801cf5:	c7 05 20 51 80 00 00 	movl   $0x20000,0x805120
  801cfc:	00 02 00 
	MemBlockNodes = (void*)USER_DYN_BLKS_ARRAY;
  801cff:	c7 45 f4 00 00 e0 7f 	movl   $0x7fe00000,-0xc(%ebp)
  801d06:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801d09:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801d0e:	2d 00 10 00 00       	sub    $0x1000,%eax
  801d13:	a3 50 50 80 00       	mov    %eax,0x805050
	int size_of_block = sizeof(struct MemBlock);
  801d18:	c7 45 f0 10 00 00 00 	movl   $0x10,-0x10(%ebp)
	int size_all_struct = size_of_block*MAX_MEM_BLOCK_CNT;
  801d1f:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801d22:	a1 20 51 80 00       	mov    0x805120,%eax
  801d27:	0f af c2             	imul   %edx,%eax
  801d2a:	89 45 ec             	mov    %eax,-0x14(%ebp)
	size_all_struct = ROUNDUP(size_all_struct, PAGE_SIZE);
  801d2d:	c7 45 e8 00 10 00 00 	movl   $0x1000,-0x18(%ebp)
  801d34:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801d37:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801d3a:	01 d0                	add    %edx,%eax
  801d3c:	48                   	dec    %eax
  801d3d:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  801d40:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801d43:	ba 00 00 00 00       	mov    $0x0,%edx
  801d48:	f7 75 e8             	divl   -0x18(%ebp)
  801d4b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801d4e:	29 d0                	sub    %edx,%eax
  801d50:	89 45 ec             	mov    %eax,-0x14(%ebp)
	sys_allocate_chunk(USER_DYN_BLKS_ARRAY, size_all_struct,PERM_USER| PERM_WRITEABLE);
  801d53:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801d56:	c7 45 e0 00 00 e0 7f 	movl   $0x7fe00000,-0x20(%ebp)
  801d5d:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801d60:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
  801d66:	81 ea 00 10 00 00    	sub    $0x1000,%edx
  801d6c:	83 ec 04             	sub    $0x4,%esp
  801d6f:	6a 06                	push   $0x6
  801d71:	50                   	push   %eax
  801d72:	52                   	push   %edx
  801d73:	e8 a1 05 00 00       	call   802319 <sys_allocate_chunk>
  801d78:	83 c4 10             	add    $0x10,%esp
	initialize_MemBlocksList(MAX_MEM_BLOCK_CNT);
  801d7b:	a1 20 51 80 00       	mov    0x805120,%eax
  801d80:	83 ec 0c             	sub    $0xc,%esp
  801d83:	50                   	push   %eax
  801d84:	e8 16 0c 00 00       	call   80299f <initialize_MemBlocksList>
  801d89:	83 c4 10             	add    $0x10,%esp
	struct MemBlock* ourBlock =LIST_LAST(&AvailableMemBlocksList);
  801d8c:	a1 4c 51 80 00       	mov    0x80514c,%eax
  801d91:	89 45 dc             	mov    %eax,-0x24(%ebp)
	LIST_REMOVE(&AvailableMemBlocksList,ourBlock);
  801d94:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  801d98:	75 14                	jne    801dae <initialize_dyn_block_system+0xfb>
  801d9a:	83 ec 04             	sub    $0x4,%esp
  801d9d:	68 55 41 80 00       	push   $0x804155
  801da2:	6a 2d                	push   $0x2d
  801da4:	68 73 41 80 00       	push   $0x804173
  801da9:	e8 96 ee ff ff       	call   800c44 <_panic>
  801dae:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801db1:	8b 00                	mov    (%eax),%eax
  801db3:	85 c0                	test   %eax,%eax
  801db5:	74 10                	je     801dc7 <initialize_dyn_block_system+0x114>
  801db7:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801dba:	8b 00                	mov    (%eax),%eax
  801dbc:	8b 55 dc             	mov    -0x24(%ebp),%edx
  801dbf:	8b 52 04             	mov    0x4(%edx),%edx
  801dc2:	89 50 04             	mov    %edx,0x4(%eax)
  801dc5:	eb 0b                	jmp    801dd2 <initialize_dyn_block_system+0x11f>
  801dc7:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801dca:	8b 40 04             	mov    0x4(%eax),%eax
  801dcd:	a3 4c 51 80 00       	mov    %eax,0x80514c
  801dd2:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801dd5:	8b 40 04             	mov    0x4(%eax),%eax
  801dd8:	85 c0                	test   %eax,%eax
  801dda:	74 0f                	je     801deb <initialize_dyn_block_system+0x138>
  801ddc:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801ddf:	8b 40 04             	mov    0x4(%eax),%eax
  801de2:	8b 55 dc             	mov    -0x24(%ebp),%edx
  801de5:	8b 12                	mov    (%edx),%edx
  801de7:	89 10                	mov    %edx,(%eax)
  801de9:	eb 0a                	jmp    801df5 <initialize_dyn_block_system+0x142>
  801deb:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801dee:	8b 00                	mov    (%eax),%eax
  801df0:	a3 48 51 80 00       	mov    %eax,0x805148
  801df5:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801df8:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  801dfe:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801e01:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  801e08:	a1 54 51 80 00       	mov    0x805154,%eax
  801e0d:	48                   	dec    %eax
  801e0e:	a3 54 51 80 00       	mov    %eax,0x805154
	ourBlock->size = USER_HEAP_MAX-USER_HEAP_START;
  801e13:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801e16:	c7 40 0c 00 00 00 20 	movl   $0x20000000,0xc(%eax)
	ourBlock->sva=USER_HEAP_START;
  801e1d:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801e20:	c7 40 08 00 00 00 80 	movl   $0x80000000,0x8(%eax)
	LIST_INSERT_TAIL(&FreeMemBlocksList, ourBlock);
  801e27:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  801e2b:	75 14                	jne    801e41 <initialize_dyn_block_system+0x18e>
  801e2d:	83 ec 04             	sub    $0x4,%esp
  801e30:	68 80 41 80 00       	push   $0x804180
  801e35:	6a 30                	push   $0x30
  801e37:	68 73 41 80 00       	push   $0x804173
  801e3c:	e8 03 ee ff ff       	call   800c44 <_panic>
  801e41:	8b 15 3c 51 80 00    	mov    0x80513c,%edx
  801e47:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801e4a:	89 50 04             	mov    %edx,0x4(%eax)
  801e4d:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801e50:	8b 40 04             	mov    0x4(%eax),%eax
  801e53:	85 c0                	test   %eax,%eax
  801e55:	74 0c                	je     801e63 <initialize_dyn_block_system+0x1b0>
  801e57:	a1 3c 51 80 00       	mov    0x80513c,%eax
  801e5c:	8b 55 dc             	mov    -0x24(%ebp),%edx
  801e5f:	89 10                	mov    %edx,(%eax)
  801e61:	eb 08                	jmp    801e6b <initialize_dyn_block_system+0x1b8>
  801e63:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801e66:	a3 38 51 80 00       	mov    %eax,0x805138
  801e6b:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801e6e:	a3 3c 51 80 00       	mov    %eax,0x80513c
  801e73:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801e76:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  801e7c:	a1 44 51 80 00       	mov    0x805144,%eax
  801e81:	40                   	inc    %eax
  801e82:	a3 44 51 80 00       	mov    %eax,0x805144
	//[1] Initialize two lists (AllocMemBlocksList & FreeMemBlocksList) [Hint: use LIST_INIT()]
	//[2] Dynamically allocate the array of MemBlockNodes at VA USER_DYN_BLKS_ARRAY
	//	  (remember to set MAX_MEM_BLOCK_CNT with the chosen size of the array)
	//[3] Initialize AvailableMemBlocksList by filling it with the MemBlockNodes
	//[4] Insert a new MemBlock with the heap size into the FreeMemBlocksList
}
  801e87:	90                   	nop
  801e88:	c9                   	leave  
  801e89:	c3                   	ret    

00801e8a <malloc>:
//=================================
// [2] ALLOCATE SPACE IN USER HEAP:
//=================================

void* malloc(uint32 size)
{
  801e8a:	55                   	push   %ebp
  801e8b:	89 e5                	mov    %esp,%ebp
  801e8d:	83 ec 18             	sub    $0x18,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801e90:	e8 ed fd ff ff       	call   801c82 <InitializeUHeap>
	if (size == 0) return NULL ;
  801e95:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801e99:	75 07                	jne    801ea2 <malloc+0x18>
  801e9b:	b8 00 00 00 00       	mov    $0x0,%eax
  801ea0:	eb 67                	jmp    801f09 <malloc+0x7f>

	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] malloc
	// your code is here, remove the panic and write your code
	//panic("malloc() is not implemented yet...!!");

	size = ROUNDUP(size, PAGE_SIZE);
  801ea2:	c7 45 f4 00 10 00 00 	movl   $0x1000,-0xc(%ebp)
  801ea9:	8b 55 08             	mov    0x8(%ebp),%edx
  801eac:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801eaf:	01 d0                	add    %edx,%eax
  801eb1:	48                   	dec    %eax
  801eb2:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801eb5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801eb8:	ba 00 00 00 00       	mov    $0x0,%edx
  801ebd:	f7 75 f4             	divl   -0xc(%ebp)
  801ec0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801ec3:	29 d0                	sub    %edx,%eax
  801ec5:	89 45 08             	mov    %eax,0x8(%ebp)
	if(sys_isUHeapPlacementStrategyFIRSTFIT())
  801ec8:	e8 1a 08 00 00       	call   8026e7 <sys_isUHeapPlacementStrategyFIRSTFIT>
  801ecd:	85 c0                	test   %eax,%eax
  801ecf:	74 33                	je     801f04 <malloc+0x7a>
	{
		struct MemBlock * myBlock = alloc_block_FF(size);
  801ed1:	83 ec 0c             	sub    $0xc,%esp
  801ed4:	ff 75 08             	pushl  0x8(%ebp)
  801ed7:	e8 0c 0e 00 00       	call   802ce8 <alloc_block_FF>
  801edc:	83 c4 10             	add    $0x10,%esp
  801edf:	89 45 ec             	mov    %eax,-0x14(%ebp)
		if(myBlock != NULL)
  801ee2:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  801ee6:	74 1c                	je     801f04 <malloc+0x7a>
		{
			insert_sorted_allocList(myBlock);
  801ee8:	83 ec 0c             	sub    $0xc,%esp
  801eeb:	ff 75 ec             	pushl  -0x14(%ebp)
  801eee:	e8 07 0c 00 00       	call   802afa <insert_sorted_allocList>
  801ef3:	83 c4 10             	add    $0x10,%esp
			uint32 ptr = myBlock->sva;
  801ef6:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801ef9:	8b 40 08             	mov    0x8(%eax),%eax
  801efc:	89 45 e8             	mov    %eax,-0x18(%ebp)
			return (void *)ptr;
  801eff:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801f02:	eb 05                	jmp    801f09 <malloc+0x7f>
		}
	}
	return NULL;
  801f04:	b8 00 00 00 00       	mov    $0x0,%eax
	//		to the required allocation size (space should be on 4 KB BOUNDARY)
	//	2) if no suitable space found, return NULL
	// 	3) Return pointer containing the virtual address of allocated space,
	//
	//Use sys_isUHeapPlacementStrategyFIRSTFIT()... to check the current strategy
}
  801f09:	c9                   	leave  
  801f0a:	c3                   	ret    

00801f0b <free>:
//	We can use sys_free_user_mem(uint32 virtual_address, uint32 size); which
//		switches to the kernel mode, calls free_user_mem() in
//		"kern/mem/chunk_operations.c", then switch back to the user mode here
//	the free_user_mem function is empty, make sure to implement it.
void free(void* virtual_address)
{
  801f0b:	55                   	push   %ebp
  801f0c:	89 e5                	mov    %esp,%ebp
  801f0e:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] free
	// your code is here, remove the panic and write your code
	//panic("free() is not implemented yet...!!");

	uint32 virtualAddress = (uint32 )(virtual_address);
  801f11:	8b 45 08             	mov    0x8(%ebp),%eax
  801f14:	89 45 f4             	mov    %eax,-0xc(%ebp)
//	virtualAddress = ROUNDDOWN(virtualAddress, PAGE_SIZE);
	struct MemBlock * myBlock = find_block(&AllocMemBlocksList, virtualAddress);
  801f17:	83 ec 08             	sub    $0x8,%esp
  801f1a:	ff 75 f4             	pushl  -0xc(%ebp)
  801f1d:	68 40 50 80 00       	push   $0x805040
  801f22:	e8 5b 0b 00 00       	call   802a82 <find_block>
  801f27:	83 c4 10             	add    $0x10,%esp
  801f2a:	89 45 f0             	mov    %eax,-0x10(%ebp)
//	cprintf ("ptr sva at free user side = %x \n", myBlock->sva);
	sys_free_user_mem(virtualAddress, myBlock->size);
  801f2d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801f30:	8b 40 0c             	mov    0xc(%eax),%eax
  801f33:	83 ec 08             	sub    $0x8,%esp
  801f36:	50                   	push   %eax
  801f37:	ff 75 f4             	pushl  -0xc(%ebp)
  801f3a:	e8 a2 03 00 00       	call   8022e1 <sys_free_user_mem>
  801f3f:	83 c4 10             	add    $0x10,%esp
	LIST_REMOVE(&AllocMemBlocksList, myBlock);
  801f42:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801f46:	75 14                	jne    801f5c <free+0x51>
  801f48:	83 ec 04             	sub    $0x4,%esp
  801f4b:	68 55 41 80 00       	push   $0x804155
  801f50:	6a 76                	push   $0x76
  801f52:	68 73 41 80 00       	push   $0x804173
  801f57:	e8 e8 ec ff ff       	call   800c44 <_panic>
  801f5c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801f5f:	8b 00                	mov    (%eax),%eax
  801f61:	85 c0                	test   %eax,%eax
  801f63:	74 10                	je     801f75 <free+0x6a>
  801f65:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801f68:	8b 00                	mov    (%eax),%eax
  801f6a:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801f6d:	8b 52 04             	mov    0x4(%edx),%edx
  801f70:	89 50 04             	mov    %edx,0x4(%eax)
  801f73:	eb 0b                	jmp    801f80 <free+0x75>
  801f75:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801f78:	8b 40 04             	mov    0x4(%eax),%eax
  801f7b:	a3 44 50 80 00       	mov    %eax,0x805044
  801f80:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801f83:	8b 40 04             	mov    0x4(%eax),%eax
  801f86:	85 c0                	test   %eax,%eax
  801f88:	74 0f                	je     801f99 <free+0x8e>
  801f8a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801f8d:	8b 40 04             	mov    0x4(%eax),%eax
  801f90:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801f93:	8b 12                	mov    (%edx),%edx
  801f95:	89 10                	mov    %edx,(%eax)
  801f97:	eb 0a                	jmp    801fa3 <free+0x98>
  801f99:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801f9c:	8b 00                	mov    (%eax),%eax
  801f9e:	a3 40 50 80 00       	mov    %eax,0x805040
  801fa3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801fa6:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  801fac:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801faf:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  801fb6:	a1 4c 50 80 00       	mov    0x80504c,%eax
  801fbb:	48                   	dec    %eax
  801fbc:	a3 4c 50 80 00       	mov    %eax,0x80504c
	insert_sorted_with_merge_freeList(myBlock);
  801fc1:	83 ec 0c             	sub    $0xc,%esp
  801fc4:	ff 75 f0             	pushl  -0x10(%ebp)
  801fc7:	e8 0b 14 00 00       	call   8033d7 <insert_sorted_with_merge_freeList>
  801fcc:	83 c4 10             	add    $0x10,%esp

	//you should get the size of the given allocation using its address
	//you need to call sys_free_user_mem()
	//refer to the project presentation and documentation for details
}
  801fcf:	90                   	nop
  801fd0:	c9                   	leave  
  801fd1:	c3                   	ret    

00801fd2 <smalloc>:

//=================================
// [4] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
  801fd2:	55                   	push   %ebp
  801fd3:	89 e5                	mov    %esp,%ebp
  801fd5:	83 ec 28             	sub    $0x28,%esp
  801fd8:	8b 45 10             	mov    0x10(%ebp),%eax
  801fdb:	88 45 e4             	mov    %al,-0x1c(%ebp)
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801fde:	e8 9f fc ff ff       	call   801c82 <InitializeUHeap>
	if (size == 0) return NULL ;
  801fe3:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801fe7:	75 0a                	jne    801ff3 <smalloc+0x21>
  801fe9:	b8 00 00 00 00       	mov    $0x0,%eax
  801fee:	e9 8d 00 00 00       	jmp    802080 <smalloc+0xae>

	//This function should find the space of the required range
	// * ON 4KB BOUNDARY **** //
	//Use sys_isUHeapPlacementStrategyFIRSTFIT() to check the current strategy

	size = ROUNDUP(size, PAGE_SIZE);
  801ff3:	c7 45 f4 00 10 00 00 	movl   $0x1000,-0xc(%ebp)
  801ffa:	8b 55 0c             	mov    0xc(%ebp),%edx
  801ffd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802000:	01 d0                	add    %edx,%eax
  802002:	48                   	dec    %eax
  802003:	89 45 f0             	mov    %eax,-0x10(%ebp)
  802006:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802009:	ba 00 00 00 00       	mov    $0x0,%edx
  80200e:	f7 75 f4             	divl   -0xc(%ebp)
  802011:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802014:	29 d0                	sub    %edx,%eax
  802016:	89 45 0c             	mov    %eax,0xc(%ebp)
		if(sys_isUHeapPlacementStrategyFIRSTFIT())
  802019:	e8 c9 06 00 00       	call   8026e7 <sys_isUHeapPlacementStrategyFIRSTFIT>
  80201e:	85 c0                	test   %eax,%eax
  802020:	74 59                	je     80207b <smalloc+0xa9>
		{
			struct MemBlock * v1=NULL;
  802022:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
			v1= alloc_block_FF(size);
  802029:	83 ec 0c             	sub    $0xc,%esp
  80202c:	ff 75 0c             	pushl  0xc(%ebp)
  80202f:	e8 b4 0c 00 00       	call   802ce8 <alloc_block_FF>
  802034:	83 c4 10             	add    $0x10,%esp
  802037:	89 45 ec             	mov    %eax,-0x14(%ebp)
			if(v1==NULL)
  80203a:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  80203e:	75 07                	jne    802047 <smalloc+0x75>
			{
				return NULL;
  802040:	b8 00 00 00 00       	mov    $0x0,%eax
  802045:	eb 39                	jmp    802080 <smalloc+0xae>
			}
			else
			{
				int ret=sys_createSharedObject(sharedVarName,  size,  isWritable,(void*)v1->sva);
  802047:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80204a:	8b 40 08             	mov    0x8(%eax),%eax
  80204d:	89 c2                	mov    %eax,%edx
  80204f:	0f b6 45 e4          	movzbl -0x1c(%ebp),%eax
  802053:	52                   	push   %edx
  802054:	50                   	push   %eax
  802055:	ff 75 0c             	pushl  0xc(%ebp)
  802058:	ff 75 08             	pushl  0x8(%ebp)
  80205b:	e8 0c 04 00 00       	call   80246c <sys_createSharedObject>
  802060:	83 c4 10             	add    $0x10,%esp
  802063:	89 45 e8             	mov    %eax,-0x18(%ebp)
				if(ret>=0)
  802066:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  80206a:	78 08                	js     802074 <smalloc+0xa2>
				{
					return (void*)v1->sva;
  80206c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80206f:	8b 40 08             	mov    0x8(%eax),%eax
  802072:	eb 0c                	jmp    802080 <smalloc+0xae>
				}
				else
				{
					return NULL;
  802074:	b8 00 00 00 00       	mov    $0x0,%eax
  802079:	eb 05                	jmp    802080 <smalloc+0xae>
				}
			}

		}
		return NULL;
  80207b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802080:	c9                   	leave  
  802081:	c3                   	ret    

00802082 <sget>:

//========================================
// [5] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  802082:	55                   	push   %ebp
  802083:	89 e5                	mov    %esp,%ebp
  802085:	83 ec 18             	sub    $0x18,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  802088:	e8 f5 fb ff ff       	call   801c82 <InitializeUHeap>

	//This function should find the space for sharing the variable
	// *** ON 4KB BOUNDARY ******** //

	//Use sys_isUHeapPlacementStrategyFIRSTFIT() to check the current strategy
	int ret=sys_getSizeOfSharedObject(ownerEnvID,sharedVarName);
  80208d:	83 ec 08             	sub    $0x8,%esp
  802090:	ff 75 0c             	pushl  0xc(%ebp)
  802093:	ff 75 08             	pushl  0x8(%ebp)
  802096:	e8 fb 03 00 00       	call   802496 <sys_getSizeOfSharedObject>
  80209b:	83 c4 10             	add    $0x10,%esp
  80209e:	89 45 f4             	mov    %eax,-0xc(%ebp)
	if(ret==0)
  8020a1:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8020a5:	75 07                	jne    8020ae <sget+0x2c>
	{
		return NULL;
  8020a7:	b8 00 00 00 00       	mov    $0x0,%eax
  8020ac:	eb 64                	jmp    802112 <sget+0x90>
	}
	if(sys_isUHeapPlacementStrategyFIRSTFIT())
  8020ae:	e8 34 06 00 00       	call   8026e7 <sys_isUHeapPlacementStrategyFIRSTFIT>
  8020b3:	85 c0                	test   %eax,%eax
  8020b5:	74 56                	je     80210d <sget+0x8b>
	{
		struct MemBlock * v1=NULL;
  8020b7:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
		v1= alloc_block_FF(ret);
  8020be:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020c1:	83 ec 0c             	sub    $0xc,%esp
  8020c4:	50                   	push   %eax
  8020c5:	e8 1e 0c 00 00       	call   802ce8 <alloc_block_FF>
  8020ca:	83 c4 10             	add    $0x10,%esp
  8020cd:	89 45 f0             	mov    %eax,-0x10(%ebp)
		if(v1==NULL)
  8020d0:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8020d4:	75 07                	jne    8020dd <sget+0x5b>
		{
		return NULL;
  8020d6:	b8 00 00 00 00       	mov    $0x0,%eax
  8020db:	eb 35                	jmp    802112 <sget+0x90>
	    }
		else
		{
			int ret1=sys_getSharedObject(ownerEnvID,sharedVarName,(void*)v1->sva);
  8020dd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8020e0:	8b 40 08             	mov    0x8(%eax),%eax
  8020e3:	83 ec 04             	sub    $0x4,%esp
  8020e6:	50                   	push   %eax
  8020e7:	ff 75 0c             	pushl  0xc(%ebp)
  8020ea:	ff 75 08             	pushl  0x8(%ebp)
  8020ed:	e8 c1 03 00 00       	call   8024b3 <sys_getSharedObject>
  8020f2:	83 c4 10             	add    $0x10,%esp
  8020f5:	89 45 ec             	mov    %eax,-0x14(%ebp)
			if(ret1>=0)
  8020f8:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8020fc:	78 08                	js     802106 <sget+0x84>
			{
				return (void*)v1->sva;
  8020fe:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802101:	8b 40 08             	mov    0x8(%eax),%eax
  802104:	eb 0c                	jmp    802112 <sget+0x90>
			}
			else
			{
				return NULL;
  802106:	b8 00 00 00 00       	mov    $0x0,%eax
  80210b:	eb 05                	jmp    802112 <sget+0x90>
			}
		}
	}
  return NULL;
  80210d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802112:	c9                   	leave  
  802113:	c3                   	ret    

00802114 <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  802114:	55                   	push   %ebp
  802115:	89 e5                	mov    %esp,%ebp
  802117:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  80211a:	e8 63 fb ff ff       	call   801c82 <InitializeUHeap>
	//==============================================================
	// [USER HEAP - USER SIDE] realloc
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  80211f:	83 ec 04             	sub    $0x4,%esp
  802122:	68 a4 41 80 00       	push   $0x8041a4
  802127:	68 0e 01 00 00       	push   $0x10e
  80212c:	68 73 41 80 00       	push   $0x804173
  802131:	e8 0e eb ff ff       	call   800c44 <_panic>

00802136 <sfree>:
//	use sys_freeSharedObject(...); which switches to the kernel mode,
//	calls freeSharedObject(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the freeSharedObject() function is empty, make sure to implement it.

void sfree(void* virtual_address)
{
  802136:	55                   	push   %ebp
  802137:	89 e5                	mov    %esp,%ebp
  802139:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS3 - BONUS] [SHARING - USER SIDE] sfree()

	// Write your code here, remove the panic and write your code
	panic("sfree() is not implemented yet...!!");
  80213c:	83 ec 04             	sub    $0x4,%esp
  80213f:	68 cc 41 80 00       	push   $0x8041cc
  802144:	68 22 01 00 00       	push   $0x122
  802149:	68 73 41 80 00       	push   $0x804173
  80214e:	e8 f1 ea ff ff       	call   800c44 <_panic>

00802153 <expand>:

//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//
void expand(uint32 newSize)
{
  802153:	55                   	push   %ebp
  802154:	89 e5                	mov    %esp,%ebp
  802156:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  802159:	83 ec 04             	sub    $0x4,%esp
  80215c:	68 f0 41 80 00       	push   $0x8041f0
  802161:	68 2d 01 00 00       	push   $0x12d
  802166:	68 73 41 80 00       	push   $0x804173
  80216b:	e8 d4 ea ff ff       	call   800c44 <_panic>

00802170 <shrink>:

}
void shrink(uint32 newSize)
{
  802170:	55                   	push   %ebp
  802171:	89 e5                	mov    %esp,%ebp
  802173:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  802176:	83 ec 04             	sub    $0x4,%esp
  802179:	68 f0 41 80 00       	push   $0x8041f0
  80217e:	68 32 01 00 00       	push   $0x132
  802183:	68 73 41 80 00       	push   $0x804173
  802188:	e8 b7 ea ff ff       	call   800c44 <_panic>

0080218d <freeHeap>:

}
void freeHeap(void* virtual_address)
{
  80218d:	55                   	push   %ebp
  80218e:	89 e5                	mov    %esp,%ebp
  802190:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  802193:	83 ec 04             	sub    $0x4,%esp
  802196:	68 f0 41 80 00       	push   $0x8041f0
  80219b:	68 37 01 00 00       	push   $0x137
  8021a0:	68 73 41 80 00       	push   $0x804173
  8021a5:	e8 9a ea ff ff       	call   800c44 <_panic>

008021aa <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  8021aa:	55                   	push   %ebp
  8021ab:	89 e5                	mov    %esp,%ebp
  8021ad:	57                   	push   %edi
  8021ae:	56                   	push   %esi
  8021af:	53                   	push   %ebx
  8021b0:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8021b3:	8b 45 08             	mov    0x8(%ebp),%eax
  8021b6:	8b 55 0c             	mov    0xc(%ebp),%edx
  8021b9:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8021bc:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8021bf:	8b 7d 18             	mov    0x18(%ebp),%edi
  8021c2:	8b 75 1c             	mov    0x1c(%ebp),%esi
  8021c5:	cd 30                	int    $0x30
  8021c7:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  8021ca:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8021cd:	83 c4 10             	add    $0x10,%esp
  8021d0:	5b                   	pop    %ebx
  8021d1:	5e                   	pop    %esi
  8021d2:	5f                   	pop    %edi
  8021d3:	5d                   	pop    %ebp
  8021d4:	c3                   	ret    

008021d5 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  8021d5:	55                   	push   %ebp
  8021d6:	89 e5                	mov    %esp,%ebp
  8021d8:	83 ec 04             	sub    $0x4,%esp
  8021db:	8b 45 10             	mov    0x10(%ebp),%eax
  8021de:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  8021e1:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  8021e5:	8b 45 08             	mov    0x8(%ebp),%eax
  8021e8:	6a 00                	push   $0x0
  8021ea:	6a 00                	push   $0x0
  8021ec:	52                   	push   %edx
  8021ed:	ff 75 0c             	pushl  0xc(%ebp)
  8021f0:	50                   	push   %eax
  8021f1:	6a 00                	push   $0x0
  8021f3:	e8 b2 ff ff ff       	call   8021aa <syscall>
  8021f8:	83 c4 18             	add    $0x18,%esp
}
  8021fb:	90                   	nop
  8021fc:	c9                   	leave  
  8021fd:	c3                   	ret    

008021fe <sys_cgetc>:

int
sys_cgetc(void)
{
  8021fe:	55                   	push   %ebp
  8021ff:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  802201:	6a 00                	push   $0x0
  802203:	6a 00                	push   $0x0
  802205:	6a 00                	push   $0x0
  802207:	6a 00                	push   $0x0
  802209:	6a 00                	push   $0x0
  80220b:	6a 01                	push   $0x1
  80220d:	e8 98 ff ff ff       	call   8021aa <syscall>
  802212:	83 c4 18             	add    $0x18,%esp
}
  802215:	c9                   	leave  
  802216:	c3                   	ret    

00802217 <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  802217:	55                   	push   %ebp
  802218:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  80221a:	8b 55 0c             	mov    0xc(%ebp),%edx
  80221d:	8b 45 08             	mov    0x8(%ebp),%eax
  802220:	6a 00                	push   $0x0
  802222:	6a 00                	push   $0x0
  802224:	6a 00                	push   $0x0
  802226:	52                   	push   %edx
  802227:	50                   	push   %eax
  802228:	6a 05                	push   $0x5
  80222a:	e8 7b ff ff ff       	call   8021aa <syscall>
  80222f:	83 c4 18             	add    $0x18,%esp
}
  802232:	c9                   	leave  
  802233:	c3                   	ret    

00802234 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  802234:	55                   	push   %ebp
  802235:	89 e5                	mov    %esp,%ebp
  802237:	56                   	push   %esi
  802238:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  802239:	8b 75 18             	mov    0x18(%ebp),%esi
  80223c:	8b 5d 14             	mov    0x14(%ebp),%ebx
  80223f:	8b 4d 10             	mov    0x10(%ebp),%ecx
  802242:	8b 55 0c             	mov    0xc(%ebp),%edx
  802245:	8b 45 08             	mov    0x8(%ebp),%eax
  802248:	56                   	push   %esi
  802249:	53                   	push   %ebx
  80224a:	51                   	push   %ecx
  80224b:	52                   	push   %edx
  80224c:	50                   	push   %eax
  80224d:	6a 06                	push   $0x6
  80224f:	e8 56 ff ff ff       	call   8021aa <syscall>
  802254:	83 c4 18             	add    $0x18,%esp
}
  802257:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80225a:	5b                   	pop    %ebx
  80225b:	5e                   	pop    %esi
  80225c:	5d                   	pop    %ebp
  80225d:	c3                   	ret    

0080225e <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  80225e:	55                   	push   %ebp
  80225f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  802261:	8b 55 0c             	mov    0xc(%ebp),%edx
  802264:	8b 45 08             	mov    0x8(%ebp),%eax
  802267:	6a 00                	push   $0x0
  802269:	6a 00                	push   $0x0
  80226b:	6a 00                	push   $0x0
  80226d:	52                   	push   %edx
  80226e:	50                   	push   %eax
  80226f:	6a 07                	push   $0x7
  802271:	e8 34 ff ff ff       	call   8021aa <syscall>
  802276:	83 c4 18             	add    $0x18,%esp
}
  802279:	c9                   	leave  
  80227a:	c3                   	ret    

0080227b <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  80227b:	55                   	push   %ebp
  80227c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  80227e:	6a 00                	push   $0x0
  802280:	6a 00                	push   $0x0
  802282:	6a 00                	push   $0x0
  802284:	ff 75 0c             	pushl  0xc(%ebp)
  802287:	ff 75 08             	pushl  0x8(%ebp)
  80228a:	6a 08                	push   $0x8
  80228c:	e8 19 ff ff ff       	call   8021aa <syscall>
  802291:	83 c4 18             	add    $0x18,%esp
}
  802294:	c9                   	leave  
  802295:	c3                   	ret    

00802296 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  802296:	55                   	push   %ebp
  802297:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  802299:	6a 00                	push   $0x0
  80229b:	6a 00                	push   $0x0
  80229d:	6a 00                	push   $0x0
  80229f:	6a 00                	push   $0x0
  8022a1:	6a 00                	push   $0x0
  8022a3:	6a 09                	push   $0x9
  8022a5:	e8 00 ff ff ff       	call   8021aa <syscall>
  8022aa:	83 c4 18             	add    $0x18,%esp
}
  8022ad:	c9                   	leave  
  8022ae:	c3                   	ret    

008022af <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  8022af:	55                   	push   %ebp
  8022b0:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  8022b2:	6a 00                	push   $0x0
  8022b4:	6a 00                	push   $0x0
  8022b6:	6a 00                	push   $0x0
  8022b8:	6a 00                	push   $0x0
  8022ba:	6a 00                	push   $0x0
  8022bc:	6a 0a                	push   $0xa
  8022be:	e8 e7 fe ff ff       	call   8021aa <syscall>
  8022c3:	83 c4 18             	add    $0x18,%esp
}
  8022c6:	c9                   	leave  
  8022c7:	c3                   	ret    

008022c8 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  8022c8:	55                   	push   %ebp
  8022c9:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  8022cb:	6a 00                	push   $0x0
  8022cd:	6a 00                	push   $0x0
  8022cf:	6a 00                	push   $0x0
  8022d1:	6a 00                	push   $0x0
  8022d3:	6a 00                	push   $0x0
  8022d5:	6a 0b                	push   $0xb
  8022d7:	e8 ce fe ff ff       	call   8021aa <syscall>
  8022dc:	83 c4 18             	add    $0x18,%esp
}
  8022df:	c9                   	leave  
  8022e0:	c3                   	ret    

008022e1 <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  8022e1:	55                   	push   %ebp
  8022e2:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  8022e4:	6a 00                	push   $0x0
  8022e6:	6a 00                	push   $0x0
  8022e8:	6a 00                	push   $0x0
  8022ea:	ff 75 0c             	pushl  0xc(%ebp)
  8022ed:	ff 75 08             	pushl  0x8(%ebp)
  8022f0:	6a 0f                	push   $0xf
  8022f2:	e8 b3 fe ff ff       	call   8021aa <syscall>
  8022f7:	83 c4 18             	add    $0x18,%esp
	return;
  8022fa:	90                   	nop
}
  8022fb:	c9                   	leave  
  8022fc:	c3                   	ret    

008022fd <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  8022fd:	55                   	push   %ebp
  8022fe:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  802300:	6a 00                	push   $0x0
  802302:	6a 00                	push   $0x0
  802304:	6a 00                	push   $0x0
  802306:	ff 75 0c             	pushl  0xc(%ebp)
  802309:	ff 75 08             	pushl  0x8(%ebp)
  80230c:	6a 10                	push   $0x10
  80230e:	e8 97 fe ff ff       	call   8021aa <syscall>
  802313:	83 c4 18             	add    $0x18,%esp
	return ;
  802316:	90                   	nop
}
  802317:	c9                   	leave  
  802318:	c3                   	ret    

00802319 <sys_allocate_chunk>:

void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  802319:	55                   	push   %ebp
  80231a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  80231c:	6a 00                	push   $0x0
  80231e:	6a 00                	push   $0x0
  802320:	ff 75 10             	pushl  0x10(%ebp)
  802323:	ff 75 0c             	pushl  0xc(%ebp)
  802326:	ff 75 08             	pushl  0x8(%ebp)
  802329:	6a 11                	push   $0x11
  80232b:	e8 7a fe ff ff       	call   8021aa <syscall>
  802330:	83 c4 18             	add    $0x18,%esp
	return ;
  802333:	90                   	nop
}
  802334:	c9                   	leave  
  802335:	c3                   	ret    

00802336 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  802336:	55                   	push   %ebp
  802337:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  802339:	6a 00                	push   $0x0
  80233b:	6a 00                	push   $0x0
  80233d:	6a 00                	push   $0x0
  80233f:	6a 00                	push   $0x0
  802341:	6a 00                	push   $0x0
  802343:	6a 0c                	push   $0xc
  802345:	e8 60 fe ff ff       	call   8021aa <syscall>
  80234a:	83 c4 18             	add    $0x18,%esp
}
  80234d:	c9                   	leave  
  80234e:	c3                   	ret    

0080234f <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  80234f:	55                   	push   %ebp
  802350:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  802352:	6a 00                	push   $0x0
  802354:	6a 00                	push   $0x0
  802356:	6a 00                	push   $0x0
  802358:	6a 00                	push   $0x0
  80235a:	ff 75 08             	pushl  0x8(%ebp)
  80235d:	6a 0d                	push   $0xd
  80235f:	e8 46 fe ff ff       	call   8021aa <syscall>
  802364:	83 c4 18             	add    $0x18,%esp
}
  802367:	c9                   	leave  
  802368:	c3                   	ret    

00802369 <sys_scarce_memory>:

void sys_scarce_memory()
{
  802369:	55                   	push   %ebp
  80236a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  80236c:	6a 00                	push   $0x0
  80236e:	6a 00                	push   $0x0
  802370:	6a 00                	push   $0x0
  802372:	6a 00                	push   $0x0
  802374:	6a 00                	push   $0x0
  802376:	6a 0e                	push   $0xe
  802378:	e8 2d fe ff ff       	call   8021aa <syscall>
  80237d:	83 c4 18             	add    $0x18,%esp
}
  802380:	90                   	nop
  802381:	c9                   	leave  
  802382:	c3                   	ret    

00802383 <sys_disable_interrupt>:

//NEW !! 2012...
void
sys_disable_interrupt()
{
  802383:	55                   	push   %ebp
  802384:	89 e5                	mov    %esp,%ebp
	syscall(SYS_disableINTR,0, 0, 0, 0, 0);
  802386:	6a 00                	push   $0x0
  802388:	6a 00                	push   $0x0
  80238a:	6a 00                	push   $0x0
  80238c:	6a 00                	push   $0x0
  80238e:	6a 00                	push   $0x0
  802390:	6a 13                	push   $0x13
  802392:	e8 13 fe ff ff       	call   8021aa <syscall>
  802397:	83 c4 18             	add    $0x18,%esp
}
  80239a:	90                   	nop
  80239b:	c9                   	leave  
  80239c:	c3                   	ret    

0080239d <sys_enable_interrupt>:


void
sys_enable_interrupt()
{
  80239d:	55                   	push   %ebp
  80239e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enableINTR,0, 0, 0, 0, 0);
  8023a0:	6a 00                	push   $0x0
  8023a2:	6a 00                	push   $0x0
  8023a4:	6a 00                	push   $0x0
  8023a6:	6a 00                	push   $0x0
  8023a8:	6a 00                	push   $0x0
  8023aa:	6a 14                	push   $0x14
  8023ac:	e8 f9 fd ff ff       	call   8021aa <syscall>
  8023b1:	83 c4 18             	add    $0x18,%esp
}
  8023b4:	90                   	nop
  8023b5:	c9                   	leave  
  8023b6:	c3                   	ret    

008023b7 <sys_cputc>:


void
sys_cputc(const char c)
{
  8023b7:	55                   	push   %ebp
  8023b8:	89 e5                	mov    %esp,%ebp
  8023ba:	83 ec 04             	sub    $0x4,%esp
  8023bd:	8b 45 08             	mov    0x8(%ebp),%eax
  8023c0:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  8023c3:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  8023c7:	6a 00                	push   $0x0
  8023c9:	6a 00                	push   $0x0
  8023cb:	6a 00                	push   $0x0
  8023cd:	6a 00                	push   $0x0
  8023cf:	50                   	push   %eax
  8023d0:	6a 15                	push   $0x15
  8023d2:	e8 d3 fd ff ff       	call   8021aa <syscall>
  8023d7:	83 c4 18             	add    $0x18,%esp
}
  8023da:	90                   	nop
  8023db:	c9                   	leave  
  8023dc:	c3                   	ret    

008023dd <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  8023dd:	55                   	push   %ebp
  8023de:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  8023e0:	6a 00                	push   $0x0
  8023e2:	6a 00                	push   $0x0
  8023e4:	6a 00                	push   $0x0
  8023e6:	6a 00                	push   $0x0
  8023e8:	6a 00                	push   $0x0
  8023ea:	6a 16                	push   $0x16
  8023ec:	e8 b9 fd ff ff       	call   8021aa <syscall>
  8023f1:	83 c4 18             	add    $0x18,%esp
}
  8023f4:	90                   	nop
  8023f5:	c9                   	leave  
  8023f6:	c3                   	ret    

008023f7 <sys_createSemaphore>:

int
sys_createSemaphore(char* semaphoreName, uint32 initialValue)
{
  8023f7:	55                   	push   %ebp
  8023f8:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_semaphore,(uint32)semaphoreName, (uint32)initialValue, 0, 0, 0);
  8023fa:	8b 45 08             	mov    0x8(%ebp),%eax
  8023fd:	6a 00                	push   $0x0
  8023ff:	6a 00                	push   $0x0
  802401:	6a 00                	push   $0x0
  802403:	ff 75 0c             	pushl  0xc(%ebp)
  802406:	50                   	push   %eax
  802407:	6a 17                	push   $0x17
  802409:	e8 9c fd ff ff       	call   8021aa <syscall>
  80240e:	83 c4 18             	add    $0x18,%esp
}
  802411:	c9                   	leave  
  802412:	c3                   	ret    

00802413 <sys_getSemaphoreValue>:

int
sys_getSemaphoreValue(int32 ownerEnvID, char* semaphoreName)
{
  802413:	55                   	push   %ebp
  802414:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_semaphore_value,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  802416:	8b 55 0c             	mov    0xc(%ebp),%edx
  802419:	8b 45 08             	mov    0x8(%ebp),%eax
  80241c:	6a 00                	push   $0x0
  80241e:	6a 00                	push   $0x0
  802420:	6a 00                	push   $0x0
  802422:	52                   	push   %edx
  802423:	50                   	push   %eax
  802424:	6a 1a                	push   $0x1a
  802426:	e8 7f fd ff ff       	call   8021aa <syscall>
  80242b:	83 c4 18             	add    $0x18,%esp
}
  80242e:	c9                   	leave  
  80242f:	c3                   	ret    

00802430 <sys_waitSemaphore>:

void
sys_waitSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  802430:	55                   	push   %ebp
  802431:	89 e5                	mov    %esp,%ebp
	syscall(SYS_wait_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  802433:	8b 55 0c             	mov    0xc(%ebp),%edx
  802436:	8b 45 08             	mov    0x8(%ebp),%eax
  802439:	6a 00                	push   $0x0
  80243b:	6a 00                	push   $0x0
  80243d:	6a 00                	push   $0x0
  80243f:	52                   	push   %edx
  802440:	50                   	push   %eax
  802441:	6a 18                	push   $0x18
  802443:	e8 62 fd ff ff       	call   8021aa <syscall>
  802448:	83 c4 18             	add    $0x18,%esp
}
  80244b:	90                   	nop
  80244c:	c9                   	leave  
  80244d:	c3                   	ret    

0080244e <sys_signalSemaphore>:

void
sys_signalSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  80244e:	55                   	push   %ebp
  80244f:	89 e5                	mov    %esp,%ebp
	syscall(SYS_signal_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  802451:	8b 55 0c             	mov    0xc(%ebp),%edx
  802454:	8b 45 08             	mov    0x8(%ebp),%eax
  802457:	6a 00                	push   $0x0
  802459:	6a 00                	push   $0x0
  80245b:	6a 00                	push   $0x0
  80245d:	52                   	push   %edx
  80245e:	50                   	push   %eax
  80245f:	6a 19                	push   $0x19
  802461:	e8 44 fd ff ff       	call   8021aa <syscall>
  802466:	83 c4 18             	add    $0x18,%esp
}
  802469:	90                   	nop
  80246a:	c9                   	leave  
  80246b:	c3                   	ret    

0080246c <sys_createSharedObject>:

int
sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  80246c:	55                   	push   %ebp
  80246d:	89 e5                	mov    %esp,%ebp
  80246f:	83 ec 04             	sub    $0x4,%esp
  802472:	8b 45 10             	mov    0x10(%ebp),%eax
  802475:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  802478:	8b 4d 14             	mov    0x14(%ebp),%ecx
  80247b:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  80247f:	8b 45 08             	mov    0x8(%ebp),%eax
  802482:	6a 00                	push   $0x0
  802484:	51                   	push   %ecx
  802485:	52                   	push   %edx
  802486:	ff 75 0c             	pushl  0xc(%ebp)
  802489:	50                   	push   %eax
  80248a:	6a 1b                	push   $0x1b
  80248c:	e8 19 fd ff ff       	call   8021aa <syscall>
  802491:	83 c4 18             	add    $0x18,%esp
}
  802494:	c9                   	leave  
  802495:	c3                   	ret    

00802496 <sys_getSizeOfSharedObject>:

//2017:
int
sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  802496:	55                   	push   %ebp
  802497:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  802499:	8b 55 0c             	mov    0xc(%ebp),%edx
  80249c:	8b 45 08             	mov    0x8(%ebp),%eax
  80249f:	6a 00                	push   $0x0
  8024a1:	6a 00                	push   $0x0
  8024a3:	6a 00                	push   $0x0
  8024a5:	52                   	push   %edx
  8024a6:	50                   	push   %eax
  8024a7:	6a 1c                	push   $0x1c
  8024a9:	e8 fc fc ff ff       	call   8021aa <syscall>
  8024ae:	83 c4 18             	add    $0x18,%esp
}
  8024b1:	c9                   	leave  
  8024b2:	c3                   	ret    

008024b3 <sys_getSharedObject>:
//==========

int
sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  8024b3:	55                   	push   %ebp
  8024b4:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  8024b6:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8024b9:	8b 55 0c             	mov    0xc(%ebp),%edx
  8024bc:	8b 45 08             	mov    0x8(%ebp),%eax
  8024bf:	6a 00                	push   $0x0
  8024c1:	6a 00                	push   $0x0
  8024c3:	51                   	push   %ecx
  8024c4:	52                   	push   %edx
  8024c5:	50                   	push   %eax
  8024c6:	6a 1d                	push   $0x1d
  8024c8:	e8 dd fc ff ff       	call   8021aa <syscall>
  8024cd:	83 c4 18             	add    $0x18,%esp
}
  8024d0:	c9                   	leave  
  8024d1:	c3                   	ret    

008024d2 <sys_freeSharedObject>:

int
sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  8024d2:	55                   	push   %ebp
  8024d3:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  8024d5:	8b 55 0c             	mov    0xc(%ebp),%edx
  8024d8:	8b 45 08             	mov    0x8(%ebp),%eax
  8024db:	6a 00                	push   $0x0
  8024dd:	6a 00                	push   $0x0
  8024df:	6a 00                	push   $0x0
  8024e1:	52                   	push   %edx
  8024e2:	50                   	push   %eax
  8024e3:	6a 1e                	push   $0x1e
  8024e5:	e8 c0 fc ff ff       	call   8021aa <syscall>
  8024ea:	83 c4 18             	add    $0x18,%esp
}
  8024ed:	c9                   	leave  
  8024ee:	c3                   	ret    

008024ef <sys_getMaxShares>:

uint32 	sys_getMaxShares()
{
  8024ef:	55                   	push   %ebp
  8024f0:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_max_shares,0, 0, 0, 0, 0);
  8024f2:	6a 00                	push   $0x0
  8024f4:	6a 00                	push   $0x0
  8024f6:	6a 00                	push   $0x0
  8024f8:	6a 00                	push   $0x0
  8024fa:	6a 00                	push   $0x0
  8024fc:	6a 1f                	push   $0x1f
  8024fe:	e8 a7 fc ff ff       	call   8021aa <syscall>
  802503:	83 c4 18             	add    $0x18,%esp
}
  802506:	c9                   	leave  
  802507:	c3                   	ret    

00802508 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  802508:	55                   	push   %ebp
  802509:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  80250b:	8b 45 08             	mov    0x8(%ebp),%eax
  80250e:	6a 00                	push   $0x0
  802510:	ff 75 14             	pushl  0x14(%ebp)
  802513:	ff 75 10             	pushl  0x10(%ebp)
  802516:	ff 75 0c             	pushl  0xc(%ebp)
  802519:	50                   	push   %eax
  80251a:	6a 20                	push   $0x20
  80251c:	e8 89 fc ff ff       	call   8021aa <syscall>
  802521:	83 c4 18             	add    $0x18,%esp
}
  802524:	c9                   	leave  
  802525:	c3                   	ret    

00802526 <sys_run_env>:

void
sys_run_env(int32 envId)
{
  802526:	55                   	push   %ebp
  802527:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  802529:	8b 45 08             	mov    0x8(%ebp),%eax
  80252c:	6a 00                	push   $0x0
  80252e:	6a 00                	push   $0x0
  802530:	6a 00                	push   $0x0
  802532:	6a 00                	push   $0x0
  802534:	50                   	push   %eax
  802535:	6a 21                	push   $0x21
  802537:	e8 6e fc ff ff       	call   8021aa <syscall>
  80253c:	83 c4 18             	add    $0x18,%esp
}
  80253f:	90                   	nop
  802540:	c9                   	leave  
  802541:	c3                   	ret    

00802542 <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  802542:	55                   	push   %ebp
  802543:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  802545:	8b 45 08             	mov    0x8(%ebp),%eax
  802548:	6a 00                	push   $0x0
  80254a:	6a 00                	push   $0x0
  80254c:	6a 00                	push   $0x0
  80254e:	6a 00                	push   $0x0
  802550:	50                   	push   %eax
  802551:	6a 22                	push   $0x22
  802553:	e8 52 fc ff ff       	call   8021aa <syscall>
  802558:	83 c4 18             	add    $0x18,%esp
}
  80255b:	c9                   	leave  
  80255c:	c3                   	ret    

0080255d <sys_getenvid>:

int32 sys_getenvid(void)
{
  80255d:	55                   	push   %ebp
  80255e:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  802560:	6a 00                	push   $0x0
  802562:	6a 00                	push   $0x0
  802564:	6a 00                	push   $0x0
  802566:	6a 00                	push   $0x0
  802568:	6a 00                	push   $0x0
  80256a:	6a 02                	push   $0x2
  80256c:	e8 39 fc ff ff       	call   8021aa <syscall>
  802571:	83 c4 18             	add    $0x18,%esp
}
  802574:	c9                   	leave  
  802575:	c3                   	ret    

00802576 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  802576:	55                   	push   %ebp
  802577:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  802579:	6a 00                	push   $0x0
  80257b:	6a 00                	push   $0x0
  80257d:	6a 00                	push   $0x0
  80257f:	6a 00                	push   $0x0
  802581:	6a 00                	push   $0x0
  802583:	6a 03                	push   $0x3
  802585:	e8 20 fc ff ff       	call   8021aa <syscall>
  80258a:	83 c4 18             	add    $0x18,%esp
}
  80258d:	c9                   	leave  
  80258e:	c3                   	ret    

0080258f <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  80258f:	55                   	push   %ebp
  802590:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  802592:	6a 00                	push   $0x0
  802594:	6a 00                	push   $0x0
  802596:	6a 00                	push   $0x0
  802598:	6a 00                	push   $0x0
  80259a:	6a 00                	push   $0x0
  80259c:	6a 04                	push   $0x4
  80259e:	e8 07 fc ff ff       	call   8021aa <syscall>
  8025a3:	83 c4 18             	add    $0x18,%esp
}
  8025a6:	c9                   	leave  
  8025a7:	c3                   	ret    

008025a8 <sys_exit_env>:


void sys_exit_env(void)
{
  8025a8:	55                   	push   %ebp
  8025a9:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  8025ab:	6a 00                	push   $0x0
  8025ad:	6a 00                	push   $0x0
  8025af:	6a 00                	push   $0x0
  8025b1:	6a 00                	push   $0x0
  8025b3:	6a 00                	push   $0x0
  8025b5:	6a 23                	push   $0x23
  8025b7:	e8 ee fb ff ff       	call   8021aa <syscall>
  8025bc:	83 c4 18             	add    $0x18,%esp
}
  8025bf:	90                   	nop
  8025c0:	c9                   	leave  
  8025c1:	c3                   	ret    

008025c2 <sys_get_virtual_time>:


struct uint64
sys_get_virtual_time()
{
  8025c2:	55                   	push   %ebp
  8025c3:	89 e5                	mov    %esp,%ebp
  8025c5:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  8025c8:	8d 45 f8             	lea    -0x8(%ebp),%eax
  8025cb:	8d 50 04             	lea    0x4(%eax),%edx
  8025ce:	8d 45 f8             	lea    -0x8(%ebp),%eax
  8025d1:	6a 00                	push   $0x0
  8025d3:	6a 00                	push   $0x0
  8025d5:	6a 00                	push   $0x0
  8025d7:	52                   	push   %edx
  8025d8:	50                   	push   %eax
  8025d9:	6a 24                	push   $0x24
  8025db:	e8 ca fb ff ff       	call   8021aa <syscall>
  8025e0:	83 c4 18             	add    $0x18,%esp
	return result;
  8025e3:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8025e6:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8025e9:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8025ec:	89 01                	mov    %eax,(%ecx)
  8025ee:	89 51 04             	mov    %edx,0x4(%ecx)
}
  8025f1:	8b 45 08             	mov    0x8(%ebp),%eax
  8025f4:	c9                   	leave  
  8025f5:	c2 04 00             	ret    $0x4

008025f8 <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  8025f8:	55                   	push   %ebp
  8025f9:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  8025fb:	6a 00                	push   $0x0
  8025fd:	6a 00                	push   $0x0
  8025ff:	ff 75 10             	pushl  0x10(%ebp)
  802602:	ff 75 0c             	pushl  0xc(%ebp)
  802605:	ff 75 08             	pushl  0x8(%ebp)
  802608:	6a 12                	push   $0x12
  80260a:	e8 9b fb ff ff       	call   8021aa <syscall>
  80260f:	83 c4 18             	add    $0x18,%esp
	return ;
  802612:	90                   	nop
}
  802613:	c9                   	leave  
  802614:	c3                   	ret    

00802615 <sys_rcr2>:
uint32 sys_rcr2()
{
  802615:	55                   	push   %ebp
  802616:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  802618:	6a 00                	push   $0x0
  80261a:	6a 00                	push   $0x0
  80261c:	6a 00                	push   $0x0
  80261e:	6a 00                	push   $0x0
  802620:	6a 00                	push   $0x0
  802622:	6a 25                	push   $0x25
  802624:	e8 81 fb ff ff       	call   8021aa <syscall>
  802629:	83 c4 18             	add    $0x18,%esp
}
  80262c:	c9                   	leave  
  80262d:	c3                   	ret    

0080262e <sys_bypassPageFault>:
void sys_bypassPageFault(uint8 instrLength)
{
  80262e:	55                   	push   %ebp
  80262f:	89 e5                	mov    %esp,%ebp
  802631:	83 ec 04             	sub    $0x4,%esp
  802634:	8b 45 08             	mov    0x8(%ebp),%eax
  802637:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  80263a:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  80263e:	6a 00                	push   $0x0
  802640:	6a 00                	push   $0x0
  802642:	6a 00                	push   $0x0
  802644:	6a 00                	push   $0x0
  802646:	50                   	push   %eax
  802647:	6a 26                	push   $0x26
  802649:	e8 5c fb ff ff       	call   8021aa <syscall>
  80264e:	83 c4 18             	add    $0x18,%esp
	return ;
  802651:	90                   	nop
}
  802652:	c9                   	leave  
  802653:	c3                   	ret    

00802654 <rsttst>:
void rsttst()
{
  802654:	55                   	push   %ebp
  802655:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  802657:	6a 00                	push   $0x0
  802659:	6a 00                	push   $0x0
  80265b:	6a 00                	push   $0x0
  80265d:	6a 00                	push   $0x0
  80265f:	6a 00                	push   $0x0
  802661:	6a 28                	push   $0x28
  802663:	e8 42 fb ff ff       	call   8021aa <syscall>
  802668:	83 c4 18             	add    $0x18,%esp
	return ;
  80266b:	90                   	nop
}
  80266c:	c9                   	leave  
  80266d:	c3                   	ret    

0080266e <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  80266e:	55                   	push   %ebp
  80266f:	89 e5                	mov    %esp,%ebp
  802671:	83 ec 04             	sub    $0x4,%esp
  802674:	8b 45 14             	mov    0x14(%ebp),%eax
  802677:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  80267a:	8b 55 18             	mov    0x18(%ebp),%edx
  80267d:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  802681:	52                   	push   %edx
  802682:	50                   	push   %eax
  802683:	ff 75 10             	pushl  0x10(%ebp)
  802686:	ff 75 0c             	pushl  0xc(%ebp)
  802689:	ff 75 08             	pushl  0x8(%ebp)
  80268c:	6a 27                	push   $0x27
  80268e:	e8 17 fb ff ff       	call   8021aa <syscall>
  802693:	83 c4 18             	add    $0x18,%esp
	return ;
  802696:	90                   	nop
}
  802697:	c9                   	leave  
  802698:	c3                   	ret    

00802699 <chktst>:
void chktst(uint32 n)
{
  802699:	55                   	push   %ebp
  80269a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  80269c:	6a 00                	push   $0x0
  80269e:	6a 00                	push   $0x0
  8026a0:	6a 00                	push   $0x0
  8026a2:	6a 00                	push   $0x0
  8026a4:	ff 75 08             	pushl  0x8(%ebp)
  8026a7:	6a 29                	push   $0x29
  8026a9:	e8 fc fa ff ff       	call   8021aa <syscall>
  8026ae:	83 c4 18             	add    $0x18,%esp
	return ;
  8026b1:	90                   	nop
}
  8026b2:	c9                   	leave  
  8026b3:	c3                   	ret    

008026b4 <inctst>:

void inctst()
{
  8026b4:	55                   	push   %ebp
  8026b5:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  8026b7:	6a 00                	push   $0x0
  8026b9:	6a 00                	push   $0x0
  8026bb:	6a 00                	push   $0x0
  8026bd:	6a 00                	push   $0x0
  8026bf:	6a 00                	push   $0x0
  8026c1:	6a 2a                	push   $0x2a
  8026c3:	e8 e2 fa ff ff       	call   8021aa <syscall>
  8026c8:	83 c4 18             	add    $0x18,%esp
	return ;
  8026cb:	90                   	nop
}
  8026cc:	c9                   	leave  
  8026cd:	c3                   	ret    

008026ce <gettst>:
uint32 gettst()
{
  8026ce:	55                   	push   %ebp
  8026cf:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  8026d1:	6a 00                	push   $0x0
  8026d3:	6a 00                	push   $0x0
  8026d5:	6a 00                	push   $0x0
  8026d7:	6a 00                	push   $0x0
  8026d9:	6a 00                	push   $0x0
  8026db:	6a 2b                	push   $0x2b
  8026dd:	e8 c8 fa ff ff       	call   8021aa <syscall>
  8026e2:	83 c4 18             	add    $0x18,%esp
}
  8026e5:	c9                   	leave  
  8026e6:	c3                   	ret    

008026e7 <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  8026e7:	55                   	push   %ebp
  8026e8:	89 e5                	mov    %esp,%ebp
  8026ea:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8026ed:	6a 00                	push   $0x0
  8026ef:	6a 00                	push   $0x0
  8026f1:	6a 00                	push   $0x0
  8026f3:	6a 00                	push   $0x0
  8026f5:	6a 00                	push   $0x0
  8026f7:	6a 2c                	push   $0x2c
  8026f9:	e8 ac fa ff ff       	call   8021aa <syscall>
  8026fe:	83 c4 18             	add    $0x18,%esp
  802701:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  802704:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  802708:	75 07                	jne    802711 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  80270a:	b8 01 00 00 00       	mov    $0x1,%eax
  80270f:	eb 05                	jmp    802716 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  802711:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802716:	c9                   	leave  
  802717:	c3                   	ret    

00802718 <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  802718:	55                   	push   %ebp
  802719:	89 e5                	mov    %esp,%ebp
  80271b:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  80271e:	6a 00                	push   $0x0
  802720:	6a 00                	push   $0x0
  802722:	6a 00                	push   $0x0
  802724:	6a 00                	push   $0x0
  802726:	6a 00                	push   $0x0
  802728:	6a 2c                	push   $0x2c
  80272a:	e8 7b fa ff ff       	call   8021aa <syscall>
  80272f:	83 c4 18             	add    $0x18,%esp
  802732:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  802735:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  802739:	75 07                	jne    802742 <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  80273b:	b8 01 00 00 00       	mov    $0x1,%eax
  802740:	eb 05                	jmp    802747 <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  802742:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802747:	c9                   	leave  
  802748:	c3                   	ret    

00802749 <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  802749:	55                   	push   %ebp
  80274a:	89 e5                	mov    %esp,%ebp
  80274c:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  80274f:	6a 00                	push   $0x0
  802751:	6a 00                	push   $0x0
  802753:	6a 00                	push   $0x0
  802755:	6a 00                	push   $0x0
  802757:	6a 00                	push   $0x0
  802759:	6a 2c                	push   $0x2c
  80275b:	e8 4a fa ff ff       	call   8021aa <syscall>
  802760:	83 c4 18             	add    $0x18,%esp
  802763:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  802766:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  80276a:	75 07                	jne    802773 <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  80276c:	b8 01 00 00 00       	mov    $0x1,%eax
  802771:	eb 05                	jmp    802778 <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  802773:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802778:	c9                   	leave  
  802779:	c3                   	ret    

0080277a <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  80277a:	55                   	push   %ebp
  80277b:	89 e5                	mov    %esp,%ebp
  80277d:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  802780:	6a 00                	push   $0x0
  802782:	6a 00                	push   $0x0
  802784:	6a 00                	push   $0x0
  802786:	6a 00                	push   $0x0
  802788:	6a 00                	push   $0x0
  80278a:	6a 2c                	push   $0x2c
  80278c:	e8 19 fa ff ff       	call   8021aa <syscall>
  802791:	83 c4 18             	add    $0x18,%esp
  802794:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  802797:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  80279b:	75 07                	jne    8027a4 <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  80279d:	b8 01 00 00 00       	mov    $0x1,%eax
  8027a2:	eb 05                	jmp    8027a9 <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  8027a4:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8027a9:	c9                   	leave  
  8027aa:	c3                   	ret    

008027ab <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  8027ab:	55                   	push   %ebp
  8027ac:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  8027ae:	6a 00                	push   $0x0
  8027b0:	6a 00                	push   $0x0
  8027b2:	6a 00                	push   $0x0
  8027b4:	6a 00                	push   $0x0
  8027b6:	ff 75 08             	pushl  0x8(%ebp)
  8027b9:	6a 2d                	push   $0x2d
  8027bb:	e8 ea f9 ff ff       	call   8021aa <syscall>
  8027c0:	83 c4 18             	add    $0x18,%esp
	return ;
  8027c3:	90                   	nop
}
  8027c4:	c9                   	leave  
  8027c5:	c3                   	ret    

008027c6 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  8027c6:	55                   	push   %ebp
  8027c7:	89 e5                	mov    %esp,%ebp
  8027c9:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  8027ca:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8027cd:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8027d0:	8b 55 0c             	mov    0xc(%ebp),%edx
  8027d3:	8b 45 08             	mov    0x8(%ebp),%eax
  8027d6:	6a 00                	push   $0x0
  8027d8:	53                   	push   %ebx
  8027d9:	51                   	push   %ecx
  8027da:	52                   	push   %edx
  8027db:	50                   	push   %eax
  8027dc:	6a 2e                	push   $0x2e
  8027de:	e8 c7 f9 ff ff       	call   8021aa <syscall>
  8027e3:	83 c4 18             	add    $0x18,%esp
}
  8027e6:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8027e9:	c9                   	leave  
  8027ea:	c3                   	ret    

008027eb <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  8027eb:	55                   	push   %ebp
  8027ec:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  8027ee:	8b 55 0c             	mov    0xc(%ebp),%edx
  8027f1:	8b 45 08             	mov    0x8(%ebp),%eax
  8027f4:	6a 00                	push   $0x0
  8027f6:	6a 00                	push   $0x0
  8027f8:	6a 00                	push   $0x0
  8027fa:	52                   	push   %edx
  8027fb:	50                   	push   %eax
  8027fc:	6a 2f                	push   $0x2f
  8027fe:	e8 a7 f9 ff ff       	call   8021aa <syscall>
  802803:	83 c4 18             	add    $0x18,%esp
}
  802806:	c9                   	leave  
  802807:	c3                   	ret    

00802808 <print_mem_block_lists>:
//===========================
// PRINT MEM BLOCK LISTS:
//===========================

void print_mem_block_lists()
{
  802808:	55                   	push   %ebp
  802809:	89 e5                	mov    %esp,%ebp
  80280b:	83 ec 18             	sub    $0x18,%esp
	cprintf("\n=========================================\n");
  80280e:	83 ec 0c             	sub    $0xc,%esp
  802811:	68 00 42 80 00       	push   $0x804200
  802816:	e8 dd e6 ff ff       	call   800ef8 <cprintf>
  80281b:	83 c4 10             	add    $0x10,%esp
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
  80281e:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nFreeMemBlocksList:\n");
  802825:	83 ec 0c             	sub    $0xc,%esp
  802828:	68 2c 42 80 00       	push   $0x80422c
  80282d:	e8 c6 e6 ff ff       	call   800ef8 <cprintf>
  802832:	83 c4 10             	add    $0x10,%esp
	uint8 sorted = 1 ;
  802835:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &FreeMemBlocksList)
  802839:	a1 38 51 80 00       	mov    0x805138,%eax
  80283e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802841:	eb 56                	jmp    802899 <print_mem_block_lists+0x91>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  802843:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802847:	74 1c                	je     802865 <print_mem_block_lists+0x5d>
  802849:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80284c:	8b 50 08             	mov    0x8(%eax),%edx
  80284f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802852:	8b 48 08             	mov    0x8(%eax),%ecx
  802855:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802858:	8b 40 0c             	mov    0xc(%eax),%eax
  80285b:	01 c8                	add    %ecx,%eax
  80285d:	39 c2                	cmp    %eax,%edx
  80285f:	73 04                	jae    802865 <print_mem_block_lists+0x5d>
			sorted = 0 ;
  802861:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  802865:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802868:	8b 50 08             	mov    0x8(%eax),%edx
  80286b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80286e:	8b 40 0c             	mov    0xc(%eax),%eax
  802871:	01 c2                	add    %eax,%edx
  802873:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802876:	8b 40 08             	mov    0x8(%eax),%eax
  802879:	83 ec 04             	sub    $0x4,%esp
  80287c:	52                   	push   %edx
  80287d:	50                   	push   %eax
  80287e:	68 41 42 80 00       	push   $0x804241
  802883:	e8 70 e6 ff ff       	call   800ef8 <cprintf>
  802888:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  80288b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80288e:	89 45 f0             	mov    %eax,-0x10(%ebp)
	cprintf("\n=========================================\n");
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
	cprintf("\nFreeMemBlocksList:\n");
	uint8 sorted = 1 ;
	LIST_FOREACH(blk, &FreeMemBlocksList)
  802891:	a1 40 51 80 00       	mov    0x805140,%eax
  802896:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802899:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80289d:	74 07                	je     8028a6 <print_mem_block_lists+0x9e>
  80289f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028a2:	8b 00                	mov    (%eax),%eax
  8028a4:	eb 05                	jmp    8028ab <print_mem_block_lists+0xa3>
  8028a6:	b8 00 00 00 00       	mov    $0x0,%eax
  8028ab:	a3 40 51 80 00       	mov    %eax,0x805140
  8028b0:	a1 40 51 80 00       	mov    0x805140,%eax
  8028b5:	85 c0                	test   %eax,%eax
  8028b7:	75 8a                	jne    802843 <print_mem_block_lists+0x3b>
  8028b9:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8028bd:	75 84                	jne    802843 <print_mem_block_lists+0x3b>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;
  8028bf:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  8028c3:	75 10                	jne    8028d5 <print_mem_block_lists+0xcd>
  8028c5:	83 ec 0c             	sub    $0xc,%esp
  8028c8:	68 50 42 80 00       	push   $0x804250
  8028cd:	e8 26 e6 ff ff       	call   800ef8 <cprintf>
  8028d2:	83 c4 10             	add    $0x10,%esp

	lastBlk = NULL ;
  8028d5:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nAllocMemBlocksList:\n");
  8028dc:	83 ec 0c             	sub    $0xc,%esp
  8028df:	68 74 42 80 00       	push   $0x804274
  8028e4:	e8 0f e6 ff ff       	call   800ef8 <cprintf>
  8028e9:	83 c4 10             	add    $0x10,%esp
	sorted = 1 ;
  8028ec:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &AllocMemBlocksList)
  8028f0:	a1 40 50 80 00       	mov    0x805040,%eax
  8028f5:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8028f8:	eb 56                	jmp    802950 <print_mem_block_lists+0x148>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  8028fa:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8028fe:	74 1c                	je     80291c <print_mem_block_lists+0x114>
  802900:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802903:	8b 50 08             	mov    0x8(%eax),%edx
  802906:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802909:	8b 48 08             	mov    0x8(%eax),%ecx
  80290c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80290f:	8b 40 0c             	mov    0xc(%eax),%eax
  802912:	01 c8                	add    %ecx,%eax
  802914:	39 c2                	cmp    %eax,%edx
  802916:	73 04                	jae    80291c <print_mem_block_lists+0x114>
			sorted = 0 ;
  802918:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  80291c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80291f:	8b 50 08             	mov    0x8(%eax),%edx
  802922:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802925:	8b 40 0c             	mov    0xc(%eax),%eax
  802928:	01 c2                	add    %eax,%edx
  80292a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80292d:	8b 40 08             	mov    0x8(%eax),%eax
  802930:	83 ec 04             	sub    $0x4,%esp
  802933:	52                   	push   %edx
  802934:	50                   	push   %eax
  802935:	68 41 42 80 00       	push   $0x804241
  80293a:	e8 b9 e5 ff ff       	call   800ef8 <cprintf>
  80293f:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  802942:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802945:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;

	lastBlk = NULL ;
	cprintf("\nAllocMemBlocksList:\n");
	sorted = 1 ;
	LIST_FOREACH(blk, &AllocMemBlocksList)
  802948:	a1 48 50 80 00       	mov    0x805048,%eax
  80294d:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802950:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802954:	74 07                	je     80295d <print_mem_block_lists+0x155>
  802956:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802959:	8b 00                	mov    (%eax),%eax
  80295b:	eb 05                	jmp    802962 <print_mem_block_lists+0x15a>
  80295d:	b8 00 00 00 00       	mov    $0x0,%eax
  802962:	a3 48 50 80 00       	mov    %eax,0x805048
  802967:	a1 48 50 80 00       	mov    0x805048,%eax
  80296c:	85 c0                	test   %eax,%eax
  80296e:	75 8a                	jne    8028fa <print_mem_block_lists+0xf2>
  802970:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802974:	75 84                	jne    8028fa <print_mem_block_lists+0xf2>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nAllocMemBlocksList is NOT SORTED!!\n") ;
  802976:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  80297a:	75 10                	jne    80298c <print_mem_block_lists+0x184>
  80297c:	83 ec 0c             	sub    $0xc,%esp
  80297f:	68 8c 42 80 00       	push   $0x80428c
  802984:	e8 6f e5 ff ff       	call   800ef8 <cprintf>
  802989:	83 c4 10             	add    $0x10,%esp
	cprintf("\n=========================================\n");
  80298c:	83 ec 0c             	sub    $0xc,%esp
  80298f:	68 00 42 80 00       	push   $0x804200
  802994:	e8 5f e5 ff ff       	call   800ef8 <cprintf>
  802999:	83 c4 10             	add    $0x10,%esp

}
  80299c:	90                   	nop
  80299d:	c9                   	leave  
  80299e:	c3                   	ret    

0080299f <initialize_MemBlocksList>:

//===============================
// [1] INITIALIZE AVAILABLE LIST:
//===============================
void initialize_MemBlocksList(uint32 numOfBlocks)
{
  80299f:	55                   	push   %ebp
  8029a0:	89 e5                	mov    %esp,%ebp
  8029a2:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] initialize_MemBlocksList
	// Write your code here, remove the panic and write your code
	//panic("initialize_MemBlocksList() is not implemented yet...!!");
	uint32 n = numOfBlocks;
  8029a5:	8b 45 08             	mov    0x8(%ebp),%eax
  8029a8:	89 45 f0             	mov    %eax,-0x10(%ebp)

	LIST_INIT(&AvailableMemBlocksList);
  8029ab:	c7 05 48 51 80 00 00 	movl   $0x0,0x805148
  8029b2:	00 00 00 
  8029b5:	c7 05 4c 51 80 00 00 	movl   $0x0,0x80514c
  8029bc:	00 00 00 
  8029bf:	c7 05 54 51 80 00 00 	movl   $0x0,0x805154
  8029c6:	00 00 00 
	for(int i = 0; i<n;i++)
  8029c9:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  8029d0:	e9 9e 00 00 00       	jmp    802a73 <initialize_MemBlocksList+0xd4>
	{
		LIST_INSERT_HEAD(&AvailableMemBlocksList, &(MemBlockNodes[i]));
  8029d5:	a1 50 50 80 00       	mov    0x805050,%eax
  8029da:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8029dd:	c1 e2 04             	shl    $0x4,%edx
  8029e0:	01 d0                	add    %edx,%eax
  8029e2:	85 c0                	test   %eax,%eax
  8029e4:	75 14                	jne    8029fa <initialize_MemBlocksList+0x5b>
  8029e6:	83 ec 04             	sub    $0x4,%esp
  8029e9:	68 b4 42 80 00       	push   $0x8042b4
  8029ee:	6a 47                	push   $0x47
  8029f0:	68 d7 42 80 00       	push   $0x8042d7
  8029f5:	e8 4a e2 ff ff       	call   800c44 <_panic>
  8029fa:	a1 50 50 80 00       	mov    0x805050,%eax
  8029ff:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802a02:	c1 e2 04             	shl    $0x4,%edx
  802a05:	01 d0                	add    %edx,%eax
  802a07:	8b 15 48 51 80 00    	mov    0x805148,%edx
  802a0d:	89 10                	mov    %edx,(%eax)
  802a0f:	8b 00                	mov    (%eax),%eax
  802a11:	85 c0                	test   %eax,%eax
  802a13:	74 18                	je     802a2d <initialize_MemBlocksList+0x8e>
  802a15:	a1 48 51 80 00       	mov    0x805148,%eax
  802a1a:	8b 15 50 50 80 00    	mov    0x805050,%edx
  802a20:	8b 4d f4             	mov    -0xc(%ebp),%ecx
  802a23:	c1 e1 04             	shl    $0x4,%ecx
  802a26:	01 ca                	add    %ecx,%edx
  802a28:	89 50 04             	mov    %edx,0x4(%eax)
  802a2b:	eb 12                	jmp    802a3f <initialize_MemBlocksList+0xa0>
  802a2d:	a1 50 50 80 00       	mov    0x805050,%eax
  802a32:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802a35:	c1 e2 04             	shl    $0x4,%edx
  802a38:	01 d0                	add    %edx,%eax
  802a3a:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802a3f:	a1 50 50 80 00       	mov    0x805050,%eax
  802a44:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802a47:	c1 e2 04             	shl    $0x4,%edx
  802a4a:	01 d0                	add    %edx,%eax
  802a4c:	a3 48 51 80 00       	mov    %eax,0x805148
  802a51:	a1 50 50 80 00       	mov    0x805050,%eax
  802a56:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802a59:	c1 e2 04             	shl    $0x4,%edx
  802a5c:	01 d0                	add    %edx,%eax
  802a5e:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802a65:	a1 54 51 80 00       	mov    0x805154,%eax
  802a6a:	40                   	inc    %eax
  802a6b:	a3 54 51 80 00       	mov    %eax,0x805154
	// Write your code here, remove the panic and write your code
	//panic("initialize_MemBlocksList() is not implemented yet...!!");
	uint32 n = numOfBlocks;

	LIST_INIT(&AvailableMemBlocksList);
	for(int i = 0; i<n;i++)
  802a70:	ff 45 f4             	incl   -0xc(%ebp)
  802a73:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a76:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  802a79:	0f 82 56 ff ff ff    	jb     8029d5 <initialize_MemBlocksList+0x36>
	{
		LIST_INSERT_HEAD(&AvailableMemBlocksList, &(MemBlockNodes[i]));
	}
}
  802a7f:	90                   	nop
  802a80:	c9                   	leave  
  802a81:	c3                   	ret    

00802a82 <find_block>:

//===============================
// [2] FIND BLOCK:
//===============================
struct MemBlock *find_block(struct MemBlock_List *blockList, uint32 va)
{
  802a82:	55                   	push   %ebp
  802a83:	89 e5                	mov    %esp,%ebp
  802a85:	83 ec 10             	sub    $0x10,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] find_block
	// Write your code here, remove the panic and write your code
	//panic("find_block() is not implemented yet...!!");
	uint32 virAddress = va;
  802a88:	8b 45 0c             	mov    0xc(%ebp),%eax
  802a8b:	89 45 f4             	mov    %eax,-0xc(%ebp)
	struct MemBlock* blk;
	int found = 0;
  802a8e:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	LIST_FOREACH(blk, &(AllocMemBlocksList))
  802a95:	a1 40 50 80 00       	mov    0x805040,%eax
  802a9a:	89 45 fc             	mov    %eax,-0x4(%ebp)
  802a9d:	eb 23                	jmp    802ac2 <find_block+0x40>
	{
		if(blk->sva == virAddress)
  802a9f:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802aa2:	8b 40 08             	mov    0x8(%eax),%eax
  802aa5:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  802aa8:	75 09                	jne    802ab3 <find_block+0x31>
		{
			found = 1;
  802aaa:	c7 45 f8 01 00 00 00 	movl   $0x1,-0x8(%ebp)
			break;
  802ab1:	eb 35                	jmp    802ae8 <find_block+0x66>
		}
		else
		{
			found = 0;
  802ab3:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	//panic("find_block() is not implemented yet...!!");
	uint32 virAddress = va;
	struct MemBlock* blk;
	int found = 0;

	LIST_FOREACH(blk, &(AllocMemBlocksList))
  802aba:	a1 48 50 80 00       	mov    0x805048,%eax
  802abf:	89 45 fc             	mov    %eax,-0x4(%ebp)
  802ac2:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  802ac6:	74 07                	je     802acf <find_block+0x4d>
  802ac8:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802acb:	8b 00                	mov    (%eax),%eax
  802acd:	eb 05                	jmp    802ad4 <find_block+0x52>
  802acf:	b8 00 00 00 00       	mov    $0x0,%eax
  802ad4:	a3 48 50 80 00       	mov    %eax,0x805048
  802ad9:	a1 48 50 80 00       	mov    0x805048,%eax
  802ade:	85 c0                	test   %eax,%eax
  802ae0:	75 bd                	jne    802a9f <find_block+0x1d>
  802ae2:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  802ae6:	75 b7                	jne    802a9f <find_block+0x1d>
		{
			found = 0;
			continue;
		}
	}
	if(found == 1)
  802ae8:	83 7d f8 01          	cmpl   $0x1,-0x8(%ebp)
  802aec:	75 05                	jne    802af3 <find_block+0x71>
	{
		return blk;
  802aee:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802af1:	eb 05                	jmp    802af8 <find_block+0x76>
	}
	else
	{
		return NULL;
  802af3:	b8 00 00 00 00       	mov    $0x0,%eax
	}
}
  802af8:	c9                   	leave  
  802af9:	c3                   	ret    

00802afa <insert_sorted_allocList>:

//=========================================
// [3] INSERT BLOCK IN ALLOC LIST [SORTED]:
//=========================================
void insert_sorted_allocList(struct MemBlock *blockToInsert)
{
  802afa:	55                   	push   %ebp
  802afb:	89 e5                	mov    %esp,%ebp
  802afd:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] insert_sorted_allocList
	// Write your code here, remove the panic and write your code
	//panic("insert_sorted_allocList() is not implemented yet...!!");
	struct MemBlock* blk;
	struct MemBlock* newblk = blockToInsert;
  802b00:	8b 45 08             	mov    0x8(%ebp),%eax
  802b03:	89 45 f0             	mov    %eax,-0x10(%ebp)

	if((LIST_EMPTY(&AllocMemBlocksList)) || (newblk->sva < LIST_FIRST(&AllocMemBlocksList)->sva))
  802b06:	a1 40 50 80 00       	mov    0x805040,%eax
  802b0b:	85 c0                	test   %eax,%eax
  802b0d:	74 12                	je     802b21 <insert_sorted_allocList+0x27>
  802b0f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b12:	8b 50 08             	mov    0x8(%eax),%edx
  802b15:	a1 40 50 80 00       	mov    0x805040,%eax
  802b1a:	8b 40 08             	mov    0x8(%eax),%eax
  802b1d:	39 c2                	cmp    %eax,%edx
  802b1f:	73 65                	jae    802b86 <insert_sorted_allocList+0x8c>
	{
		LIST_INSERT_HEAD(&(AllocMemBlocksList), newblk);
  802b21:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802b25:	75 14                	jne    802b3b <insert_sorted_allocList+0x41>
  802b27:	83 ec 04             	sub    $0x4,%esp
  802b2a:	68 b4 42 80 00       	push   $0x8042b4
  802b2f:	6a 7b                	push   $0x7b
  802b31:	68 d7 42 80 00       	push   $0x8042d7
  802b36:	e8 09 e1 ff ff       	call   800c44 <_panic>
  802b3b:	8b 15 40 50 80 00    	mov    0x805040,%edx
  802b41:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b44:	89 10                	mov    %edx,(%eax)
  802b46:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b49:	8b 00                	mov    (%eax),%eax
  802b4b:	85 c0                	test   %eax,%eax
  802b4d:	74 0d                	je     802b5c <insert_sorted_allocList+0x62>
  802b4f:	a1 40 50 80 00       	mov    0x805040,%eax
  802b54:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802b57:	89 50 04             	mov    %edx,0x4(%eax)
  802b5a:	eb 08                	jmp    802b64 <insert_sorted_allocList+0x6a>
  802b5c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b5f:	a3 44 50 80 00       	mov    %eax,0x805044
  802b64:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b67:	a3 40 50 80 00       	mov    %eax,0x805040
  802b6c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b6f:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802b76:	a1 4c 50 80 00       	mov    0x80504c,%eax
  802b7b:	40                   	inc    %eax
  802b7c:	a3 4c 50 80 00       	mov    %eax,0x80504c
  802b81:	e9 5f 01 00 00       	jmp    802ce5 <insert_sorted_allocList+0x1eb>
	}
	else if(newblk->sva > LIST_LAST(&AllocMemBlocksList)->sva)
  802b86:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b89:	8b 50 08             	mov    0x8(%eax),%edx
  802b8c:	a1 44 50 80 00       	mov    0x805044,%eax
  802b91:	8b 40 08             	mov    0x8(%eax),%eax
  802b94:	39 c2                	cmp    %eax,%edx
  802b96:	76 65                	jbe    802bfd <insert_sorted_allocList+0x103>
	{
		LIST_INSERT_TAIL(&AllocMemBlocksList, newblk);
  802b98:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802b9c:	75 14                	jne    802bb2 <insert_sorted_allocList+0xb8>
  802b9e:	83 ec 04             	sub    $0x4,%esp
  802ba1:	68 f0 42 80 00       	push   $0x8042f0
  802ba6:	6a 7f                	push   $0x7f
  802ba8:	68 d7 42 80 00       	push   $0x8042d7
  802bad:	e8 92 e0 ff ff       	call   800c44 <_panic>
  802bb2:	8b 15 44 50 80 00    	mov    0x805044,%edx
  802bb8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802bbb:	89 50 04             	mov    %edx,0x4(%eax)
  802bbe:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802bc1:	8b 40 04             	mov    0x4(%eax),%eax
  802bc4:	85 c0                	test   %eax,%eax
  802bc6:	74 0c                	je     802bd4 <insert_sorted_allocList+0xda>
  802bc8:	a1 44 50 80 00       	mov    0x805044,%eax
  802bcd:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802bd0:	89 10                	mov    %edx,(%eax)
  802bd2:	eb 08                	jmp    802bdc <insert_sorted_allocList+0xe2>
  802bd4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802bd7:	a3 40 50 80 00       	mov    %eax,0x805040
  802bdc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802bdf:	a3 44 50 80 00       	mov    %eax,0x805044
  802be4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802be7:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802bed:	a1 4c 50 80 00       	mov    0x80504c,%eax
  802bf2:	40                   	inc    %eax
  802bf3:	a3 4c 50 80 00       	mov    %eax,0x80504c
				LIST_INSERT_AFTER(&AllocMemBlocksList, blk, newblk);
				break;
			}
		}
	}
}
  802bf8:	e9 e8 00 00 00       	jmp    802ce5 <insert_sorted_allocList+0x1eb>
	{
		LIST_INSERT_TAIL(&AllocMemBlocksList, newblk);
	}
	else
	{
		LIST_FOREACH(blk, &AllocMemBlocksList)
  802bfd:	a1 40 50 80 00       	mov    0x805040,%eax
  802c02:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802c05:	e9 ab 00 00 00       	jmp    802cb5 <insert_sorted_allocList+0x1bb>
		{
			if(blk->prev_next_info.le_next != NULL && newblk->sva > blk->sva  && newblk->sva < blk->prev_next_info.le_next->sva)
  802c0a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c0d:	8b 00                	mov    (%eax),%eax
  802c0f:	85 c0                	test   %eax,%eax
  802c11:	0f 84 96 00 00 00    	je     802cad <insert_sorted_allocList+0x1b3>
  802c17:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c1a:	8b 50 08             	mov    0x8(%eax),%edx
  802c1d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c20:	8b 40 08             	mov    0x8(%eax),%eax
  802c23:	39 c2                	cmp    %eax,%edx
  802c25:	0f 86 82 00 00 00    	jbe    802cad <insert_sorted_allocList+0x1b3>
  802c2b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c2e:	8b 50 08             	mov    0x8(%eax),%edx
  802c31:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c34:	8b 00                	mov    (%eax),%eax
  802c36:	8b 40 08             	mov    0x8(%eax),%eax
  802c39:	39 c2                	cmp    %eax,%edx
  802c3b:	73 70                	jae    802cad <insert_sorted_allocList+0x1b3>
			{
				LIST_INSERT_AFTER(&AllocMemBlocksList, blk, newblk);
  802c3d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802c41:	74 06                	je     802c49 <insert_sorted_allocList+0x14f>
  802c43:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802c47:	75 17                	jne    802c60 <insert_sorted_allocList+0x166>
  802c49:	83 ec 04             	sub    $0x4,%esp
  802c4c:	68 14 43 80 00       	push   $0x804314
  802c51:	68 87 00 00 00       	push   $0x87
  802c56:	68 d7 42 80 00       	push   $0x8042d7
  802c5b:	e8 e4 df ff ff       	call   800c44 <_panic>
  802c60:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c63:	8b 10                	mov    (%eax),%edx
  802c65:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c68:	89 10                	mov    %edx,(%eax)
  802c6a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c6d:	8b 00                	mov    (%eax),%eax
  802c6f:	85 c0                	test   %eax,%eax
  802c71:	74 0b                	je     802c7e <insert_sorted_allocList+0x184>
  802c73:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c76:	8b 00                	mov    (%eax),%eax
  802c78:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802c7b:	89 50 04             	mov    %edx,0x4(%eax)
  802c7e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c81:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802c84:	89 10                	mov    %edx,(%eax)
  802c86:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c89:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802c8c:	89 50 04             	mov    %edx,0x4(%eax)
  802c8f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c92:	8b 00                	mov    (%eax),%eax
  802c94:	85 c0                	test   %eax,%eax
  802c96:	75 08                	jne    802ca0 <insert_sorted_allocList+0x1a6>
  802c98:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c9b:	a3 44 50 80 00       	mov    %eax,0x805044
  802ca0:	a1 4c 50 80 00       	mov    0x80504c,%eax
  802ca5:	40                   	inc    %eax
  802ca6:	a3 4c 50 80 00       	mov    %eax,0x80504c
				break;
  802cab:	eb 38                	jmp    802ce5 <insert_sorted_allocList+0x1eb>
	{
		LIST_INSERT_TAIL(&AllocMemBlocksList, newblk);
	}
	else
	{
		LIST_FOREACH(blk, &AllocMemBlocksList)
  802cad:	a1 48 50 80 00       	mov    0x805048,%eax
  802cb2:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802cb5:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802cb9:	74 07                	je     802cc2 <insert_sorted_allocList+0x1c8>
  802cbb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cbe:	8b 00                	mov    (%eax),%eax
  802cc0:	eb 05                	jmp    802cc7 <insert_sorted_allocList+0x1cd>
  802cc2:	b8 00 00 00 00       	mov    $0x0,%eax
  802cc7:	a3 48 50 80 00       	mov    %eax,0x805048
  802ccc:	a1 48 50 80 00       	mov    0x805048,%eax
  802cd1:	85 c0                	test   %eax,%eax
  802cd3:	0f 85 31 ff ff ff    	jne    802c0a <insert_sorted_allocList+0x110>
  802cd9:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802cdd:	0f 85 27 ff ff ff    	jne    802c0a <insert_sorted_allocList+0x110>
				LIST_INSERT_AFTER(&AllocMemBlocksList, blk, newblk);
				break;
			}
		}
	}
}
  802ce3:	eb 00                	jmp    802ce5 <insert_sorted_allocList+0x1eb>
  802ce5:	90                   	nop
  802ce6:	c9                   	leave  
  802ce7:	c3                   	ret    

00802ce8 <alloc_block_FF>:

//=========================================
// [4] ALLOCATE BLOCK BY FIRST FIT:
//=========================================
struct MemBlock *alloc_block_FF(uint32 size)
{
  802ce8:	55                   	push   %ebp
  802ce9:	89 e5                	mov    %esp,%ebp
  802ceb:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_FF
	// Write your code here, remove the panic and write your code
	//panic("alloc_block_FF() is not implemented yet...!!");
	uint32 versize = size;
  802cee:	8b 45 08             	mov    0x8(%ebp),%eax
  802cf1:	89 45 f0             	mov    %eax,-0x10(%ebp)
	struct MemBlock* blk;
	struct MemBlock* newblk = LIST_FIRST(&AvailableMemBlocksList);
  802cf4:	a1 48 51 80 00       	mov    0x805148,%eax
  802cf9:	89 45 ec             	mov    %eax,-0x14(%ebp)

	LIST_FOREACH(blk,&FreeMemBlocksList)
  802cfc:	a1 38 51 80 00       	mov    0x805138,%eax
  802d01:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802d04:	e9 77 01 00 00       	jmp    802e80 <alloc_block_FF+0x198>
	{
		if(blk->size == versize)
  802d09:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d0c:	8b 40 0c             	mov    0xc(%eax),%eax
  802d0f:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  802d12:	0f 85 8a 00 00 00    	jne    802da2 <alloc_block_FF+0xba>
		{
			LIST_REMOVE(&FreeMemBlocksList,blk);
  802d18:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802d1c:	75 17                	jne    802d35 <alloc_block_FF+0x4d>
  802d1e:	83 ec 04             	sub    $0x4,%esp
  802d21:	68 48 43 80 00       	push   $0x804348
  802d26:	68 9e 00 00 00       	push   $0x9e
  802d2b:	68 d7 42 80 00       	push   $0x8042d7
  802d30:	e8 0f df ff ff       	call   800c44 <_panic>
  802d35:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d38:	8b 00                	mov    (%eax),%eax
  802d3a:	85 c0                	test   %eax,%eax
  802d3c:	74 10                	je     802d4e <alloc_block_FF+0x66>
  802d3e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d41:	8b 00                	mov    (%eax),%eax
  802d43:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802d46:	8b 52 04             	mov    0x4(%edx),%edx
  802d49:	89 50 04             	mov    %edx,0x4(%eax)
  802d4c:	eb 0b                	jmp    802d59 <alloc_block_FF+0x71>
  802d4e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d51:	8b 40 04             	mov    0x4(%eax),%eax
  802d54:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802d59:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d5c:	8b 40 04             	mov    0x4(%eax),%eax
  802d5f:	85 c0                	test   %eax,%eax
  802d61:	74 0f                	je     802d72 <alloc_block_FF+0x8a>
  802d63:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d66:	8b 40 04             	mov    0x4(%eax),%eax
  802d69:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802d6c:	8b 12                	mov    (%edx),%edx
  802d6e:	89 10                	mov    %edx,(%eax)
  802d70:	eb 0a                	jmp    802d7c <alloc_block_FF+0x94>
  802d72:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d75:	8b 00                	mov    (%eax),%eax
  802d77:	a3 38 51 80 00       	mov    %eax,0x805138
  802d7c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d7f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802d85:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d88:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802d8f:	a1 44 51 80 00       	mov    0x805144,%eax
  802d94:	48                   	dec    %eax
  802d95:	a3 44 51 80 00       	mov    %eax,0x805144
			return blk;
  802d9a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d9d:	e9 11 01 00 00       	jmp    802eb3 <alloc_block_FF+0x1cb>
		}
		else if(blk->size > versize)
  802da2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802da5:	8b 40 0c             	mov    0xc(%eax),%eax
  802da8:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  802dab:	0f 86 c7 00 00 00    	jbe    802e78 <alloc_block_FF+0x190>
		{
			LIST_REMOVE(&AvailableMemBlocksList,newblk);
  802db1:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802db5:	75 17                	jne    802dce <alloc_block_FF+0xe6>
  802db7:	83 ec 04             	sub    $0x4,%esp
  802dba:	68 48 43 80 00       	push   $0x804348
  802dbf:	68 a3 00 00 00       	push   $0xa3
  802dc4:	68 d7 42 80 00       	push   $0x8042d7
  802dc9:	e8 76 de ff ff       	call   800c44 <_panic>
  802dce:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802dd1:	8b 00                	mov    (%eax),%eax
  802dd3:	85 c0                	test   %eax,%eax
  802dd5:	74 10                	je     802de7 <alloc_block_FF+0xff>
  802dd7:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802dda:	8b 00                	mov    (%eax),%eax
  802ddc:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802ddf:	8b 52 04             	mov    0x4(%edx),%edx
  802de2:	89 50 04             	mov    %edx,0x4(%eax)
  802de5:	eb 0b                	jmp    802df2 <alloc_block_FF+0x10a>
  802de7:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802dea:	8b 40 04             	mov    0x4(%eax),%eax
  802ded:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802df2:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802df5:	8b 40 04             	mov    0x4(%eax),%eax
  802df8:	85 c0                	test   %eax,%eax
  802dfa:	74 0f                	je     802e0b <alloc_block_FF+0x123>
  802dfc:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802dff:	8b 40 04             	mov    0x4(%eax),%eax
  802e02:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802e05:	8b 12                	mov    (%edx),%edx
  802e07:	89 10                	mov    %edx,(%eax)
  802e09:	eb 0a                	jmp    802e15 <alloc_block_FF+0x12d>
  802e0b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802e0e:	8b 00                	mov    (%eax),%eax
  802e10:	a3 48 51 80 00       	mov    %eax,0x805148
  802e15:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802e18:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802e1e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802e21:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802e28:	a1 54 51 80 00       	mov    0x805154,%eax
  802e2d:	48                   	dec    %eax
  802e2e:	a3 54 51 80 00       	mov    %eax,0x805154
			newblk->size = versize;
  802e33:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802e36:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802e39:	89 50 0c             	mov    %edx,0xc(%eax)
			blk->size = blk->size-versize;
  802e3c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e3f:	8b 40 0c             	mov    0xc(%eax),%eax
  802e42:	2b 45 f0             	sub    -0x10(%ebp),%eax
  802e45:	89 c2                	mov    %eax,%edx
  802e47:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e4a:	89 50 0c             	mov    %edx,0xc(%eax)
			uint32 newveradd = blk->sva;
  802e4d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e50:	8b 40 08             	mov    0x8(%eax),%eax
  802e53:	89 45 e8             	mov    %eax,-0x18(%ebp)
			blk->sva+=newblk->size;
  802e56:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e59:	8b 50 08             	mov    0x8(%eax),%edx
  802e5c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802e5f:	8b 40 0c             	mov    0xc(%eax),%eax
  802e62:	01 c2                	add    %eax,%edx
  802e64:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e67:	89 50 08             	mov    %edx,0x8(%eax)
			newblk->sva = newveradd;
  802e6a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802e6d:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802e70:	89 50 08             	mov    %edx,0x8(%eax)
			return newblk;
  802e73:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802e76:	eb 3b                	jmp    802eb3 <alloc_block_FF+0x1cb>
	//panic("alloc_block_FF() is not implemented yet...!!");
	uint32 versize = size;
	struct MemBlock* blk;
	struct MemBlock* newblk = LIST_FIRST(&AvailableMemBlocksList);

	LIST_FOREACH(blk,&FreeMemBlocksList)
  802e78:	a1 40 51 80 00       	mov    0x805140,%eax
  802e7d:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802e80:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802e84:	74 07                	je     802e8d <alloc_block_FF+0x1a5>
  802e86:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e89:	8b 00                	mov    (%eax),%eax
  802e8b:	eb 05                	jmp    802e92 <alloc_block_FF+0x1aa>
  802e8d:	b8 00 00 00 00       	mov    $0x0,%eax
  802e92:	a3 40 51 80 00       	mov    %eax,0x805140
  802e97:	a1 40 51 80 00       	mov    0x805140,%eax
  802e9c:	85 c0                	test   %eax,%eax
  802e9e:	0f 85 65 fe ff ff    	jne    802d09 <alloc_block_FF+0x21>
  802ea4:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802ea8:	0f 85 5b fe ff ff    	jne    802d09 <alloc_block_FF+0x21>
			blk->sva+=newblk->size;
			newblk->sva = newveradd;
			return newblk;
		}
	}
	return NULL;
  802eae:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802eb3:	c9                   	leave  
  802eb4:	c3                   	ret    

00802eb5 <alloc_block_BF>:

//=========================================
// [5] ALLOCATE BLOCK BY BEST FIT:
//=========================================
struct MemBlock *alloc_block_BF(uint32 size)
{
  802eb5:	55                   	push   %ebp
  802eb6:	89 e5                	mov    %esp,%ebp
  802eb8:	83 ec 28             	sub    $0x28,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_BF
	// Write your code here, remove the panic and write your code
	//panic("alloc_block_BF() is not implemented yet...!!");
	uint32 versize=size;
  802ebb:	8b 45 08             	mov    0x8(%ebp),%eax
  802ebe:	89 45 e8             	mov    %eax,-0x18(%ebp)
	struct MemBlock* blk;
	struct MemBlock* newblk=LIST_FIRST(&AvailableMemBlocksList);
  802ec1:	a1 48 51 80 00       	mov    0x805148,%eax
  802ec6:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	uint32 newveradd;
	uint32 newsize;
	int size_free = LIST_SIZE(&FreeMemBlocksList);
  802ec9:	a1 44 51 80 00       	mov    0x805144,%eax
  802ece:	89 45 e0             	mov    %eax,-0x20(%ebp)

	LIST_FOREACH(blk, &FreeMemBlocksList)
  802ed1:	a1 38 51 80 00       	mov    0x805138,%eax
  802ed6:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802ed9:	e9 a1 00 00 00       	jmp    802f7f <alloc_block_BF+0xca>
	{
		if(blk->size == versize)
  802ede:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ee1:	8b 40 0c             	mov    0xc(%eax),%eax
  802ee4:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  802ee7:	0f 85 8a 00 00 00    	jne    802f77 <alloc_block_BF+0xc2>
		{
			LIST_REMOVE(&FreeMemBlocksList, blk);
  802eed:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802ef1:	75 17                	jne    802f0a <alloc_block_BF+0x55>
  802ef3:	83 ec 04             	sub    $0x4,%esp
  802ef6:	68 48 43 80 00       	push   $0x804348
  802efb:	68 c2 00 00 00       	push   $0xc2
  802f00:	68 d7 42 80 00       	push   $0x8042d7
  802f05:	e8 3a dd ff ff       	call   800c44 <_panic>
  802f0a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f0d:	8b 00                	mov    (%eax),%eax
  802f0f:	85 c0                	test   %eax,%eax
  802f11:	74 10                	je     802f23 <alloc_block_BF+0x6e>
  802f13:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f16:	8b 00                	mov    (%eax),%eax
  802f18:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802f1b:	8b 52 04             	mov    0x4(%edx),%edx
  802f1e:	89 50 04             	mov    %edx,0x4(%eax)
  802f21:	eb 0b                	jmp    802f2e <alloc_block_BF+0x79>
  802f23:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f26:	8b 40 04             	mov    0x4(%eax),%eax
  802f29:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802f2e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f31:	8b 40 04             	mov    0x4(%eax),%eax
  802f34:	85 c0                	test   %eax,%eax
  802f36:	74 0f                	je     802f47 <alloc_block_BF+0x92>
  802f38:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f3b:	8b 40 04             	mov    0x4(%eax),%eax
  802f3e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802f41:	8b 12                	mov    (%edx),%edx
  802f43:	89 10                	mov    %edx,(%eax)
  802f45:	eb 0a                	jmp    802f51 <alloc_block_BF+0x9c>
  802f47:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f4a:	8b 00                	mov    (%eax),%eax
  802f4c:	a3 38 51 80 00       	mov    %eax,0x805138
  802f51:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f54:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802f5a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f5d:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802f64:	a1 44 51 80 00       	mov    0x805144,%eax
  802f69:	48                   	dec    %eax
  802f6a:	a3 44 51 80 00       	mov    %eax,0x805144
			return blk;
  802f6f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f72:	e9 11 02 00 00       	jmp    803188 <alloc_block_BF+0x2d3>
	struct MemBlock* newblk=LIST_FIRST(&AvailableMemBlocksList);
	uint32 newveradd;
	uint32 newsize;
	int size_free = LIST_SIZE(&FreeMemBlocksList);

	LIST_FOREACH(blk, &FreeMemBlocksList)
  802f77:	a1 40 51 80 00       	mov    0x805140,%eax
  802f7c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802f7f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802f83:	74 07                	je     802f8c <alloc_block_BF+0xd7>
  802f85:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f88:	8b 00                	mov    (%eax),%eax
  802f8a:	eb 05                	jmp    802f91 <alloc_block_BF+0xdc>
  802f8c:	b8 00 00 00 00       	mov    $0x0,%eax
  802f91:	a3 40 51 80 00       	mov    %eax,0x805140
  802f96:	a1 40 51 80 00       	mov    0x805140,%eax
  802f9b:	85 c0                	test   %eax,%eax
  802f9d:	0f 85 3b ff ff ff    	jne    802ede <alloc_block_BF+0x29>
  802fa3:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802fa7:	0f 85 31 ff ff ff    	jne    802ede <alloc_block_BF+0x29>
		{
			LIST_REMOVE(&FreeMemBlocksList, blk);
			return blk;
		}
	}
	LIST_FOREACH(blk, &FreeMemBlocksList)
  802fad:	a1 38 51 80 00       	mov    0x805138,%eax
  802fb2:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802fb5:	eb 27                	jmp    802fde <alloc_block_BF+0x129>
	{
		if(blk->size > versize)
  802fb7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802fba:	8b 40 0c             	mov    0xc(%eax),%eax
  802fbd:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  802fc0:	76 14                	jbe    802fd6 <alloc_block_BF+0x121>
		{
			newsize = blk->size;
  802fc2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802fc5:	8b 40 0c             	mov    0xc(%eax),%eax
  802fc8:	89 45 ec             	mov    %eax,-0x14(%ebp)
			newveradd = blk->sva;
  802fcb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802fce:	8b 40 08             	mov    0x8(%eax),%eax
  802fd1:	89 45 f0             	mov    %eax,-0x10(%ebp)
			break;
  802fd4:	eb 2e                	jmp    803004 <alloc_block_BF+0x14f>
		{
			LIST_REMOVE(&FreeMemBlocksList, blk);
			return blk;
		}
	}
	LIST_FOREACH(blk, &FreeMemBlocksList)
  802fd6:	a1 40 51 80 00       	mov    0x805140,%eax
  802fdb:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802fde:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802fe2:	74 07                	je     802feb <alloc_block_BF+0x136>
  802fe4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802fe7:	8b 00                	mov    (%eax),%eax
  802fe9:	eb 05                	jmp    802ff0 <alloc_block_BF+0x13b>
  802feb:	b8 00 00 00 00       	mov    $0x0,%eax
  802ff0:	a3 40 51 80 00       	mov    %eax,0x805140
  802ff5:	a1 40 51 80 00       	mov    0x805140,%eax
  802ffa:	85 c0                	test   %eax,%eax
  802ffc:	75 b9                	jne    802fb7 <alloc_block_BF+0x102>
  802ffe:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803002:	75 b3                	jne    802fb7 <alloc_block_BF+0x102>
			newsize = blk->size;
			newveradd = blk->sva;
			break;
		}
	}
	LIST_FOREACH(blk, &FreeMemBlocksList)
  803004:	a1 38 51 80 00       	mov    0x805138,%eax
  803009:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80300c:	eb 30                	jmp    80303e <alloc_block_BF+0x189>
	{
		if(newsize > blk->size && blk->size > versize)
  80300e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803011:	8b 40 0c             	mov    0xc(%eax),%eax
  803014:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  803017:	73 1d                	jae    803036 <alloc_block_BF+0x181>
  803019:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80301c:	8b 40 0c             	mov    0xc(%eax),%eax
  80301f:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  803022:	76 12                	jbe    803036 <alloc_block_BF+0x181>
		{
	       newsize = blk->size;
  803024:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803027:	8b 40 0c             	mov    0xc(%eax),%eax
  80302a:	89 45 ec             	mov    %eax,-0x14(%ebp)
		   newveradd = blk->sva;
  80302d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803030:	8b 40 08             	mov    0x8(%eax),%eax
  803033:	89 45 f0             	mov    %eax,-0x10(%ebp)
			newsize = blk->size;
			newveradd = blk->sva;
			break;
		}
	}
	LIST_FOREACH(blk, &FreeMemBlocksList)
  803036:	a1 40 51 80 00       	mov    0x805140,%eax
  80303b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80303e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803042:	74 07                	je     80304b <alloc_block_BF+0x196>
  803044:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803047:	8b 00                	mov    (%eax),%eax
  803049:	eb 05                	jmp    803050 <alloc_block_BF+0x19b>
  80304b:	b8 00 00 00 00       	mov    $0x0,%eax
  803050:	a3 40 51 80 00       	mov    %eax,0x805140
  803055:	a1 40 51 80 00       	mov    0x805140,%eax
  80305a:	85 c0                	test   %eax,%eax
  80305c:	75 b0                	jne    80300e <alloc_block_BF+0x159>
  80305e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803062:	75 aa                	jne    80300e <alloc_block_BF+0x159>
		{
	       newsize = blk->size;
		   newveradd = blk->sva;
		}
	}
	LIST_FOREACH(blk, &FreeMemBlocksList)
  803064:	a1 38 51 80 00       	mov    0x805138,%eax
  803069:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80306c:	e9 e4 00 00 00       	jmp    803155 <alloc_block_BF+0x2a0>
	{
		if(blk->size == newsize && blk->sva == newveradd)
  803071:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803074:	8b 40 0c             	mov    0xc(%eax),%eax
  803077:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  80307a:	0f 85 cd 00 00 00    	jne    80314d <alloc_block_BF+0x298>
  803080:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803083:	8b 40 08             	mov    0x8(%eax),%eax
  803086:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  803089:	0f 85 be 00 00 00    	jne    80314d <alloc_block_BF+0x298>
		{
			LIST_REMOVE(&AvailableMemBlocksList, newblk);
  80308f:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  803093:	75 17                	jne    8030ac <alloc_block_BF+0x1f7>
  803095:	83 ec 04             	sub    $0x4,%esp
  803098:	68 48 43 80 00       	push   $0x804348
  80309d:	68 db 00 00 00       	push   $0xdb
  8030a2:	68 d7 42 80 00       	push   $0x8042d7
  8030a7:	e8 98 db ff ff       	call   800c44 <_panic>
  8030ac:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8030af:	8b 00                	mov    (%eax),%eax
  8030b1:	85 c0                	test   %eax,%eax
  8030b3:	74 10                	je     8030c5 <alloc_block_BF+0x210>
  8030b5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8030b8:	8b 00                	mov    (%eax),%eax
  8030ba:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8030bd:	8b 52 04             	mov    0x4(%edx),%edx
  8030c0:	89 50 04             	mov    %edx,0x4(%eax)
  8030c3:	eb 0b                	jmp    8030d0 <alloc_block_BF+0x21b>
  8030c5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8030c8:	8b 40 04             	mov    0x4(%eax),%eax
  8030cb:	a3 4c 51 80 00       	mov    %eax,0x80514c
  8030d0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8030d3:	8b 40 04             	mov    0x4(%eax),%eax
  8030d6:	85 c0                	test   %eax,%eax
  8030d8:	74 0f                	je     8030e9 <alloc_block_BF+0x234>
  8030da:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8030dd:	8b 40 04             	mov    0x4(%eax),%eax
  8030e0:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8030e3:	8b 12                	mov    (%edx),%edx
  8030e5:	89 10                	mov    %edx,(%eax)
  8030e7:	eb 0a                	jmp    8030f3 <alloc_block_BF+0x23e>
  8030e9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8030ec:	8b 00                	mov    (%eax),%eax
  8030ee:	a3 48 51 80 00       	mov    %eax,0x805148
  8030f3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8030f6:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8030fc:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8030ff:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803106:	a1 54 51 80 00       	mov    0x805154,%eax
  80310b:	48                   	dec    %eax
  80310c:	a3 54 51 80 00       	mov    %eax,0x805154
			newblk->size = versize;
  803111:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803114:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803117:	89 50 0c             	mov    %edx,0xc(%eax)
			newblk->sva = newveradd;
  80311a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80311d:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803120:	89 50 08             	mov    %edx,0x8(%eax)
			blk->size = blk->size - versize;
  803123:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803126:	8b 40 0c             	mov    0xc(%eax),%eax
  803129:	2b 45 e8             	sub    -0x18(%ebp),%eax
  80312c:	89 c2                	mov    %eax,%edx
  80312e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803131:	89 50 0c             	mov    %edx,0xc(%eax)
			blk->sva+= newblk->size;
  803134:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803137:	8b 50 08             	mov    0x8(%eax),%edx
  80313a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80313d:	8b 40 0c             	mov    0xc(%eax),%eax
  803140:	01 c2                	add    %eax,%edx
  803142:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803145:	89 50 08             	mov    %edx,0x8(%eax)
			return newblk;
  803148:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80314b:	eb 3b                	jmp    803188 <alloc_block_BF+0x2d3>
		{
	       newsize = blk->size;
		   newveradd = blk->sva;
		}
	}
	LIST_FOREACH(blk, &FreeMemBlocksList)
  80314d:	a1 40 51 80 00       	mov    0x805140,%eax
  803152:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803155:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803159:	74 07                	je     803162 <alloc_block_BF+0x2ad>
  80315b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80315e:	8b 00                	mov    (%eax),%eax
  803160:	eb 05                	jmp    803167 <alloc_block_BF+0x2b2>
  803162:	b8 00 00 00 00       	mov    $0x0,%eax
  803167:	a3 40 51 80 00       	mov    %eax,0x805140
  80316c:	a1 40 51 80 00       	mov    0x805140,%eax
  803171:	85 c0                	test   %eax,%eax
  803173:	0f 85 f8 fe ff ff    	jne    803071 <alloc_block_BF+0x1bc>
  803179:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80317d:	0f 85 ee fe ff ff    	jne    803071 <alloc_block_BF+0x1bc>
			blk->size = blk->size - versize;
			blk->sva+= newblk->size;
			return newblk;
		}
	}
	return NULL;
  803183:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803188:	c9                   	leave  
  803189:	c3                   	ret    

0080318a <alloc_block_NF>:
//=========================================
// [7] ALLOCATE BLOCK BY NEXT FIT:
//=========================================
struct MemBlock *last_allocate;
struct MemBlock *alloc_block_NF(uint32 size)
{
  80318a:	55                   	push   %ebp
  80318b:	89 e5                	mov    %esp,%ebp
  80318d:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1 - BONUS] [DYNAMIC ALLOCATOR] alloc_block_NF
	// Write your code here, remove the panic and write your code
	//panic("alloc_block_NF() is not implemented yet...!!");
	uint32 versize = size;
  803190:	8b 45 08             	mov    0x8(%ebp),%eax
  803193:	89 45 f0             	mov    %eax,-0x10(%ebp)
	struct MemBlock* blk;
	struct MemBlock* newblk = LIST_FIRST(&AvailableMemBlocksList);
  803196:	a1 48 51 80 00       	mov    0x805148,%eax
  80319b:	89 45 ec             	mov    %eax,-0x14(%ebp)

	LIST_FOREACH(blk,&FreeMemBlocksList)
  80319e:	a1 38 51 80 00       	mov    0x805138,%eax
  8031a3:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8031a6:	e9 77 01 00 00       	jmp    803322 <alloc_block_NF+0x198>
	{
		if(blk->size == versize)
  8031ab:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8031ae:	8b 40 0c             	mov    0xc(%eax),%eax
  8031b1:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8031b4:	0f 85 8a 00 00 00    	jne    803244 <alloc_block_NF+0xba>
		{
			LIST_REMOVE(&FreeMemBlocksList,blk);
  8031ba:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8031be:	75 17                	jne    8031d7 <alloc_block_NF+0x4d>
  8031c0:	83 ec 04             	sub    $0x4,%esp
  8031c3:	68 48 43 80 00       	push   $0x804348
  8031c8:	68 f7 00 00 00       	push   $0xf7
  8031cd:	68 d7 42 80 00       	push   $0x8042d7
  8031d2:	e8 6d da ff ff       	call   800c44 <_panic>
  8031d7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8031da:	8b 00                	mov    (%eax),%eax
  8031dc:	85 c0                	test   %eax,%eax
  8031de:	74 10                	je     8031f0 <alloc_block_NF+0x66>
  8031e0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8031e3:	8b 00                	mov    (%eax),%eax
  8031e5:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8031e8:	8b 52 04             	mov    0x4(%edx),%edx
  8031eb:	89 50 04             	mov    %edx,0x4(%eax)
  8031ee:	eb 0b                	jmp    8031fb <alloc_block_NF+0x71>
  8031f0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8031f3:	8b 40 04             	mov    0x4(%eax),%eax
  8031f6:	a3 3c 51 80 00       	mov    %eax,0x80513c
  8031fb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8031fe:	8b 40 04             	mov    0x4(%eax),%eax
  803201:	85 c0                	test   %eax,%eax
  803203:	74 0f                	je     803214 <alloc_block_NF+0x8a>
  803205:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803208:	8b 40 04             	mov    0x4(%eax),%eax
  80320b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80320e:	8b 12                	mov    (%edx),%edx
  803210:	89 10                	mov    %edx,(%eax)
  803212:	eb 0a                	jmp    80321e <alloc_block_NF+0x94>
  803214:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803217:	8b 00                	mov    (%eax),%eax
  803219:	a3 38 51 80 00       	mov    %eax,0x805138
  80321e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803221:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803227:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80322a:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803231:	a1 44 51 80 00       	mov    0x805144,%eax
  803236:	48                   	dec    %eax
  803237:	a3 44 51 80 00       	mov    %eax,0x805144
			return blk;
  80323c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80323f:	e9 11 01 00 00       	jmp    803355 <alloc_block_NF+0x1cb>
		}
		else if(blk->size > versize)
  803244:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803247:	8b 40 0c             	mov    0xc(%eax),%eax
  80324a:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80324d:	0f 86 c7 00 00 00    	jbe    80331a <alloc_block_NF+0x190>
		{
			LIST_REMOVE(&AvailableMemBlocksList,newblk);
  803253:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  803257:	75 17                	jne    803270 <alloc_block_NF+0xe6>
  803259:	83 ec 04             	sub    $0x4,%esp
  80325c:	68 48 43 80 00       	push   $0x804348
  803261:	68 fc 00 00 00       	push   $0xfc
  803266:	68 d7 42 80 00       	push   $0x8042d7
  80326b:	e8 d4 d9 ff ff       	call   800c44 <_panic>
  803270:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803273:	8b 00                	mov    (%eax),%eax
  803275:	85 c0                	test   %eax,%eax
  803277:	74 10                	je     803289 <alloc_block_NF+0xff>
  803279:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80327c:	8b 00                	mov    (%eax),%eax
  80327e:	8b 55 ec             	mov    -0x14(%ebp),%edx
  803281:	8b 52 04             	mov    0x4(%edx),%edx
  803284:	89 50 04             	mov    %edx,0x4(%eax)
  803287:	eb 0b                	jmp    803294 <alloc_block_NF+0x10a>
  803289:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80328c:	8b 40 04             	mov    0x4(%eax),%eax
  80328f:	a3 4c 51 80 00       	mov    %eax,0x80514c
  803294:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803297:	8b 40 04             	mov    0x4(%eax),%eax
  80329a:	85 c0                	test   %eax,%eax
  80329c:	74 0f                	je     8032ad <alloc_block_NF+0x123>
  80329e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8032a1:	8b 40 04             	mov    0x4(%eax),%eax
  8032a4:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8032a7:	8b 12                	mov    (%edx),%edx
  8032a9:	89 10                	mov    %edx,(%eax)
  8032ab:	eb 0a                	jmp    8032b7 <alloc_block_NF+0x12d>
  8032ad:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8032b0:	8b 00                	mov    (%eax),%eax
  8032b2:	a3 48 51 80 00       	mov    %eax,0x805148
  8032b7:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8032ba:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8032c0:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8032c3:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8032ca:	a1 54 51 80 00       	mov    0x805154,%eax
  8032cf:	48                   	dec    %eax
  8032d0:	a3 54 51 80 00       	mov    %eax,0x805154
			newblk->size = versize;
  8032d5:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8032d8:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8032db:	89 50 0c             	mov    %edx,0xc(%eax)
			blk->size = blk->size-versize;
  8032de:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8032e1:	8b 40 0c             	mov    0xc(%eax),%eax
  8032e4:	2b 45 f0             	sub    -0x10(%ebp),%eax
  8032e7:	89 c2                	mov    %eax,%edx
  8032e9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8032ec:	89 50 0c             	mov    %edx,0xc(%eax)
			uint32 newveradd = blk->sva;
  8032ef:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8032f2:	8b 40 08             	mov    0x8(%eax),%eax
  8032f5:	89 45 e8             	mov    %eax,-0x18(%ebp)
			blk->sva+=newblk->size;
  8032f8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8032fb:	8b 50 08             	mov    0x8(%eax),%edx
  8032fe:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803301:	8b 40 0c             	mov    0xc(%eax),%eax
  803304:	01 c2                	add    %eax,%edx
  803306:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803309:	89 50 08             	mov    %edx,0x8(%eax)
			newblk->sva = newveradd;
  80330c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80330f:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803312:	89 50 08             	mov    %edx,0x8(%eax)
			return newblk;
  803315:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803318:	eb 3b                	jmp    803355 <alloc_block_NF+0x1cb>
	//panic("alloc_block_NF() is not implemented yet...!!");
	uint32 versize = size;
	struct MemBlock* blk;
	struct MemBlock* newblk = LIST_FIRST(&AvailableMemBlocksList);

	LIST_FOREACH(blk,&FreeMemBlocksList)
  80331a:	a1 40 51 80 00       	mov    0x805140,%eax
  80331f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803322:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803326:	74 07                	je     80332f <alloc_block_NF+0x1a5>
  803328:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80332b:	8b 00                	mov    (%eax),%eax
  80332d:	eb 05                	jmp    803334 <alloc_block_NF+0x1aa>
  80332f:	b8 00 00 00 00       	mov    $0x0,%eax
  803334:	a3 40 51 80 00       	mov    %eax,0x805140
  803339:	a1 40 51 80 00       	mov    0x805140,%eax
  80333e:	85 c0                	test   %eax,%eax
  803340:	0f 85 65 fe ff ff    	jne    8031ab <alloc_block_NF+0x21>
  803346:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80334a:	0f 85 5b fe ff ff    	jne    8031ab <alloc_block_NF+0x21>
			blk->sva+=newblk->size;
			newblk->sva = newveradd;
			return newblk;
		}
	}
	return NULL;
  803350:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803355:	c9                   	leave  
  803356:	c3                   	ret    

00803357 <addToAvailMemBlocksList>:

//===================================================
// [8] INSERT BLOCK (SORTED WITH MERGE) IN FREE LIST:
//===================================================
void addToAvailMemBlocksList(struct MemBlock *blockToInsert)
{
  803357:	55                   	push   %ebp
  803358:	89 e5                	mov    %esp,%ebp
  80335a:	83 ec 08             	sub    $0x8,%esp
	blockToInsert->sva = 0;
  80335d:	8b 45 08             	mov    0x8(%ebp),%eax
  803360:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
	blockToInsert->size = 0;
  803367:	8b 45 08             	mov    0x8(%ebp),%eax
  80336a:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
	//add to avail
	LIST_INSERT_TAIL(&AvailableMemBlocksList, blockToInsert);
  803371:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803375:	75 17                	jne    80338e <addToAvailMemBlocksList+0x37>
  803377:	83 ec 04             	sub    $0x4,%esp
  80337a:	68 f0 42 80 00       	push   $0x8042f0
  80337f:	68 10 01 00 00       	push   $0x110
  803384:	68 d7 42 80 00       	push   $0x8042d7
  803389:	e8 b6 d8 ff ff       	call   800c44 <_panic>
  80338e:	8b 15 4c 51 80 00    	mov    0x80514c,%edx
  803394:	8b 45 08             	mov    0x8(%ebp),%eax
  803397:	89 50 04             	mov    %edx,0x4(%eax)
  80339a:	8b 45 08             	mov    0x8(%ebp),%eax
  80339d:	8b 40 04             	mov    0x4(%eax),%eax
  8033a0:	85 c0                	test   %eax,%eax
  8033a2:	74 0c                	je     8033b0 <addToAvailMemBlocksList+0x59>
  8033a4:	a1 4c 51 80 00       	mov    0x80514c,%eax
  8033a9:	8b 55 08             	mov    0x8(%ebp),%edx
  8033ac:	89 10                	mov    %edx,(%eax)
  8033ae:	eb 08                	jmp    8033b8 <addToAvailMemBlocksList+0x61>
  8033b0:	8b 45 08             	mov    0x8(%ebp),%eax
  8033b3:	a3 48 51 80 00       	mov    %eax,0x805148
  8033b8:	8b 45 08             	mov    0x8(%ebp),%eax
  8033bb:	a3 4c 51 80 00       	mov    %eax,0x80514c
  8033c0:	8b 45 08             	mov    0x8(%ebp),%eax
  8033c3:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8033c9:	a1 54 51 80 00       	mov    0x805154,%eax
  8033ce:	40                   	inc    %eax
  8033cf:	a3 54 51 80 00       	mov    %eax,0x805154
}
  8033d4:	90                   	nop
  8033d5:	c9                   	leave  
  8033d6:	c3                   	ret    

008033d7 <insert_sorted_with_merge_freeList>:
void insert_sorted_with_merge_freeList(struct MemBlock *blockToInsert)
{
  8033d7:	55                   	push   %ebp
  8033d8:	89 e5                	mov    %esp,%ebp
  8033da:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] insert_sorted_with_merge_freeList
	// Write your code here, remove the panic and write your code

	struct MemBlock* last = LIST_LAST(&FreeMemBlocksList);
  8033dd:	a1 3c 51 80 00       	mov    0x80513c,%eax
  8033e2:	89 45 f0             	mov    %eax,-0x10(%ebp)
	//check if list empty
	if (LIST_SIZE(&(FreeMemBlocksList)) == 0)
  8033e5:	a1 44 51 80 00       	mov    0x805144,%eax
  8033ea:	85 c0                	test   %eax,%eax
  8033ec:	75 68                	jne    803456 <insert_sorted_with_merge_freeList+0x7f>
		LIST_INSERT_HEAD(&FreeMemBlocksList, blockToInsert);
  8033ee:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8033f2:	75 17                	jne    80340b <insert_sorted_with_merge_freeList+0x34>
  8033f4:	83 ec 04             	sub    $0x4,%esp
  8033f7:	68 b4 42 80 00       	push   $0x8042b4
  8033fc:	68 1a 01 00 00       	push   $0x11a
  803401:	68 d7 42 80 00       	push   $0x8042d7
  803406:	e8 39 d8 ff ff       	call   800c44 <_panic>
  80340b:	8b 15 38 51 80 00    	mov    0x805138,%edx
  803411:	8b 45 08             	mov    0x8(%ebp),%eax
  803414:	89 10                	mov    %edx,(%eax)
  803416:	8b 45 08             	mov    0x8(%ebp),%eax
  803419:	8b 00                	mov    (%eax),%eax
  80341b:	85 c0                	test   %eax,%eax
  80341d:	74 0d                	je     80342c <insert_sorted_with_merge_freeList+0x55>
  80341f:	a1 38 51 80 00       	mov    0x805138,%eax
  803424:	8b 55 08             	mov    0x8(%ebp),%edx
  803427:	89 50 04             	mov    %edx,0x4(%eax)
  80342a:	eb 08                	jmp    803434 <insert_sorted_with_merge_freeList+0x5d>
  80342c:	8b 45 08             	mov    0x8(%ebp),%eax
  80342f:	a3 3c 51 80 00       	mov    %eax,0x80513c
  803434:	8b 45 08             	mov    0x8(%ebp),%eax
  803437:	a3 38 51 80 00       	mov    %eax,0x805138
  80343c:	8b 45 08             	mov    0x8(%ebp),%eax
  80343f:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803446:	a1 44 51 80 00       	mov    0x805144,%eax
  80344b:	40                   	inc    %eax
  80344c:	a3 44 51 80 00       	mov    %eax,0x805144
		}
	}

	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  803451:	e9 c5 03 00 00       	jmp    80381b <insert_sorted_with_merge_freeList+0x444>
	struct MemBlock* last = LIST_LAST(&FreeMemBlocksList);
	//check if list empty
	if (LIST_SIZE(&(FreeMemBlocksList)) == 0)
		LIST_INSERT_HEAD(&FreeMemBlocksList, blockToInsert);
	//check if it's position is at last
	else if (last->sva < blockToInsert->sva) {
  803456:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803459:	8b 50 08             	mov    0x8(%eax),%edx
  80345c:	8b 45 08             	mov    0x8(%ebp),%eax
  80345f:	8b 40 08             	mov    0x8(%eax),%eax
  803462:	39 c2                	cmp    %eax,%edx
  803464:	0f 83 b2 00 00 00    	jae    80351c <insert_sorted_with_merge_freeList+0x145>

		//if i have to merge
		if (last->sva + last->size == blockToInsert->sva) {
  80346a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80346d:	8b 50 08             	mov    0x8(%eax),%edx
  803470:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803473:	8b 40 0c             	mov    0xc(%eax),%eax
  803476:	01 c2                	add    %eax,%edx
  803478:	8b 45 08             	mov    0x8(%ebp),%eax
  80347b:	8b 40 08             	mov    0x8(%eax),%eax
  80347e:	39 c2                	cmp    %eax,%edx
  803480:	75 27                	jne    8034a9 <insert_sorted_with_merge_freeList+0xd2>
			last->size = last->size + blockToInsert->size;
  803482:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803485:	8b 50 0c             	mov    0xc(%eax),%edx
  803488:	8b 45 08             	mov    0x8(%ebp),%eax
  80348b:	8b 40 0c             	mov    0xc(%eax),%eax
  80348e:	01 c2                	add    %eax,%edx
  803490:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803493:	89 50 0c             	mov    %edx,0xc(%eax)
			addToAvailMemBlocksList(blockToInsert);
  803496:	83 ec 0c             	sub    $0xc,%esp
  803499:	ff 75 08             	pushl  0x8(%ebp)
  80349c:	e8 b6 fe ff ff       	call   803357 <addToAvailMemBlocksList>
  8034a1:	83 c4 10             	add    $0x10,%esp
		}
	}

	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  8034a4:	e9 72 03 00 00       	jmp    80381b <insert_sorted_with_merge_freeList+0x444>
		if (last->sva + last->size == blockToInsert->sva) {
			last->size = last->size + blockToInsert->size;
			addToAvailMemBlocksList(blockToInsert);

		} else {
			LIST_INSERT_AFTER(&FreeMemBlocksList, last, blockToInsert);
  8034a9:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8034ad:	74 06                	je     8034b5 <insert_sorted_with_merge_freeList+0xde>
  8034af:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8034b3:	75 17                	jne    8034cc <insert_sorted_with_merge_freeList+0xf5>
  8034b5:	83 ec 04             	sub    $0x4,%esp
  8034b8:	68 14 43 80 00       	push   $0x804314
  8034bd:	68 24 01 00 00       	push   $0x124
  8034c2:	68 d7 42 80 00       	push   $0x8042d7
  8034c7:	e8 78 d7 ff ff       	call   800c44 <_panic>
  8034cc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8034cf:	8b 10                	mov    (%eax),%edx
  8034d1:	8b 45 08             	mov    0x8(%ebp),%eax
  8034d4:	89 10                	mov    %edx,(%eax)
  8034d6:	8b 45 08             	mov    0x8(%ebp),%eax
  8034d9:	8b 00                	mov    (%eax),%eax
  8034db:	85 c0                	test   %eax,%eax
  8034dd:	74 0b                	je     8034ea <insert_sorted_with_merge_freeList+0x113>
  8034df:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8034e2:	8b 00                	mov    (%eax),%eax
  8034e4:	8b 55 08             	mov    0x8(%ebp),%edx
  8034e7:	89 50 04             	mov    %edx,0x4(%eax)
  8034ea:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8034ed:	8b 55 08             	mov    0x8(%ebp),%edx
  8034f0:	89 10                	mov    %edx,(%eax)
  8034f2:	8b 45 08             	mov    0x8(%ebp),%eax
  8034f5:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8034f8:	89 50 04             	mov    %edx,0x4(%eax)
  8034fb:	8b 45 08             	mov    0x8(%ebp),%eax
  8034fe:	8b 00                	mov    (%eax),%eax
  803500:	85 c0                	test   %eax,%eax
  803502:	75 08                	jne    80350c <insert_sorted_with_merge_freeList+0x135>
  803504:	8b 45 08             	mov    0x8(%ebp),%eax
  803507:	a3 3c 51 80 00       	mov    %eax,0x80513c
  80350c:	a1 44 51 80 00       	mov    0x805144,%eax
  803511:	40                   	inc    %eax
  803512:	a3 44 51 80 00       	mov    %eax,0x805144
		}
	}

	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  803517:	e9 ff 02 00 00       	jmp    80381b <insert_sorted_with_merge_freeList+0x444>
		} else {
			LIST_INSERT_AFTER(&FreeMemBlocksList, last, blockToInsert);
		}
	} else {
		struct MemBlock *iterator;
		LIST_FOREACH(iterator, &(FreeMemBlocksList))
  80351c:	a1 38 51 80 00       	mov    0x805138,%eax
  803521:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803524:	e9 c2 02 00 00       	jmp    8037eb <insert_sorted_with_merge_freeList+0x414>
		{

			if (iterator->sva > blockToInsert->sva) {
  803529:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80352c:	8b 50 08             	mov    0x8(%eax),%edx
  80352f:	8b 45 08             	mov    0x8(%ebp),%eax
  803532:	8b 40 08             	mov    0x8(%eax),%eax
  803535:	39 c2                	cmp    %eax,%edx
  803537:	0f 86 a6 02 00 00    	jbe    8037e3 <insert_sorted_with_merge_freeList+0x40c>

				struct MemBlock* prev = LIST_PREV(iterator);
  80353d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803540:	8b 40 04             	mov    0x4(%eax),%eax
  803543:	89 45 ec             	mov    %eax,-0x14(%ebp)
				if (prev == NULL) {
  803546:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  80354a:	0f 85 ba 00 00 00    	jne    80360a <insert_sorted_with_merge_freeList+0x233>
					//check merge
					if (blockToInsert->size + blockToInsert->sva
  803550:	8b 45 08             	mov    0x8(%ebp),%eax
  803553:	8b 50 0c             	mov    0xc(%eax),%edx
  803556:	8b 45 08             	mov    0x8(%ebp),%eax
  803559:	8b 40 08             	mov    0x8(%eax),%eax
  80355c:	01 c2                	add    %eax,%edx
							== iterator->sva) {
  80355e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803561:	8b 40 08             	mov    0x8(%eax),%eax
			if (iterator->sva > blockToInsert->sva) {

				struct MemBlock* prev = LIST_PREV(iterator);
				if (prev == NULL) {
					//check merge
					if (blockToInsert->size + blockToInsert->sva
  803564:	39 c2                	cmp    %eax,%edx
  803566:	75 33                	jne    80359b <insert_sorted_with_merge_freeList+0x1c4>
							== iterator->sva) {
						iterator->sva = blockToInsert->sva;
  803568:	8b 45 08             	mov    0x8(%ebp),%eax
  80356b:	8b 50 08             	mov    0x8(%eax),%edx
  80356e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803571:	89 50 08             	mov    %edx,0x8(%eax)
						iterator->size = iterator->size + blockToInsert->size;
  803574:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803577:	8b 50 0c             	mov    0xc(%eax),%edx
  80357a:	8b 45 08             	mov    0x8(%ebp),%eax
  80357d:	8b 40 0c             	mov    0xc(%eax),%eax
  803580:	01 c2                	add    %eax,%edx
  803582:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803585:	89 50 0c             	mov    %edx,0xc(%eax)
						addToAvailMemBlocksList(blockToInsert);
  803588:	83 ec 0c             	sub    $0xc,%esp
  80358b:	ff 75 08             	pushl  0x8(%ebp)
  80358e:	e8 c4 fd ff ff       	call   803357 <addToAvailMemBlocksList>
  803593:	83 c4 10             	add    $0x10,%esp

					else {
						LIST_INSERT_BEFORE(&FreeMemBlocksList, iterator,
								blockToInsert);
					}
					break;
  803596:	e9 80 02 00 00       	jmp    80381b <insert_sorted_with_merge_freeList+0x444>
						addToAvailMemBlocksList(blockToInsert);

					}

					else {
						LIST_INSERT_BEFORE(&FreeMemBlocksList, iterator,
  80359b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80359f:	74 06                	je     8035a7 <insert_sorted_with_merge_freeList+0x1d0>
  8035a1:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8035a5:	75 17                	jne    8035be <insert_sorted_with_merge_freeList+0x1e7>
  8035a7:	83 ec 04             	sub    $0x4,%esp
  8035aa:	68 68 43 80 00       	push   $0x804368
  8035af:	68 3a 01 00 00       	push   $0x13a
  8035b4:	68 d7 42 80 00       	push   $0x8042d7
  8035b9:	e8 86 d6 ff ff       	call   800c44 <_panic>
  8035be:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8035c1:	8b 50 04             	mov    0x4(%eax),%edx
  8035c4:	8b 45 08             	mov    0x8(%ebp),%eax
  8035c7:	89 50 04             	mov    %edx,0x4(%eax)
  8035ca:	8b 45 08             	mov    0x8(%ebp),%eax
  8035cd:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8035d0:	89 10                	mov    %edx,(%eax)
  8035d2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8035d5:	8b 40 04             	mov    0x4(%eax),%eax
  8035d8:	85 c0                	test   %eax,%eax
  8035da:	74 0d                	je     8035e9 <insert_sorted_with_merge_freeList+0x212>
  8035dc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8035df:	8b 40 04             	mov    0x4(%eax),%eax
  8035e2:	8b 55 08             	mov    0x8(%ebp),%edx
  8035e5:	89 10                	mov    %edx,(%eax)
  8035e7:	eb 08                	jmp    8035f1 <insert_sorted_with_merge_freeList+0x21a>
  8035e9:	8b 45 08             	mov    0x8(%ebp),%eax
  8035ec:	a3 38 51 80 00       	mov    %eax,0x805138
  8035f1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8035f4:	8b 55 08             	mov    0x8(%ebp),%edx
  8035f7:	89 50 04             	mov    %edx,0x4(%eax)
  8035fa:	a1 44 51 80 00       	mov    0x805144,%eax
  8035ff:	40                   	inc    %eax
  803600:	a3 44 51 80 00       	mov    %eax,0x805144
								blockToInsert);
					}
					break;
  803605:	e9 11 02 00 00       	jmp    80381b <insert_sorted_with_merge_freeList+0x444>
				} else {
					//prev and next merge
					if (prev->sva + prev->size + blockToInsert->size
  80360a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80360d:	8b 50 08             	mov    0x8(%eax),%edx
  803610:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803613:	8b 40 0c             	mov    0xc(%eax),%eax
  803616:	01 c2                	add    %eax,%edx
  803618:	8b 45 08             	mov    0x8(%ebp),%eax
  80361b:	8b 40 0c             	mov    0xc(%eax),%eax
  80361e:	01 c2                	add    %eax,%edx
							== iterator->sva) {
  803620:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803623:	8b 40 08             	mov    0x8(%eax),%eax
								blockToInsert);
					}
					break;
				} else {
					//prev and next merge
					if (prev->sva + prev->size + blockToInsert->size
  803626:	39 c2                	cmp    %eax,%edx
  803628:	0f 85 bf 00 00 00    	jne    8036ed <insert_sorted_with_merge_freeList+0x316>
							== iterator->sva) {
						prev->size = prev->size + blockToInsert->size
  80362e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803631:	8b 50 0c             	mov    0xc(%eax),%edx
  803634:	8b 45 08             	mov    0x8(%ebp),%eax
  803637:	8b 40 0c             	mov    0xc(%eax),%eax
  80363a:	01 c2                	add    %eax,%edx
								+ iterator->size;
  80363c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80363f:	8b 40 0c             	mov    0xc(%eax),%eax
  803642:	01 c2                	add    %eax,%edx
					break;
				} else {
					//prev and next merge
					if (prev->sva + prev->size + blockToInsert->size
							== iterator->sva) {
						prev->size = prev->size + blockToInsert->size
  803644:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803647:	89 50 0c             	mov    %edx,0xc(%eax)
								+ iterator->size;
						LIST_REMOVE(&FreeMemBlocksList, iterator);
  80364a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80364e:	75 17                	jne    803667 <insert_sorted_with_merge_freeList+0x290>
  803650:	83 ec 04             	sub    $0x4,%esp
  803653:	68 48 43 80 00       	push   $0x804348
  803658:	68 43 01 00 00       	push   $0x143
  80365d:	68 d7 42 80 00       	push   $0x8042d7
  803662:	e8 dd d5 ff ff       	call   800c44 <_panic>
  803667:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80366a:	8b 00                	mov    (%eax),%eax
  80366c:	85 c0                	test   %eax,%eax
  80366e:	74 10                	je     803680 <insert_sorted_with_merge_freeList+0x2a9>
  803670:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803673:	8b 00                	mov    (%eax),%eax
  803675:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803678:	8b 52 04             	mov    0x4(%edx),%edx
  80367b:	89 50 04             	mov    %edx,0x4(%eax)
  80367e:	eb 0b                	jmp    80368b <insert_sorted_with_merge_freeList+0x2b4>
  803680:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803683:	8b 40 04             	mov    0x4(%eax),%eax
  803686:	a3 3c 51 80 00       	mov    %eax,0x80513c
  80368b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80368e:	8b 40 04             	mov    0x4(%eax),%eax
  803691:	85 c0                	test   %eax,%eax
  803693:	74 0f                	je     8036a4 <insert_sorted_with_merge_freeList+0x2cd>
  803695:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803698:	8b 40 04             	mov    0x4(%eax),%eax
  80369b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80369e:	8b 12                	mov    (%edx),%edx
  8036a0:	89 10                	mov    %edx,(%eax)
  8036a2:	eb 0a                	jmp    8036ae <insert_sorted_with_merge_freeList+0x2d7>
  8036a4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8036a7:	8b 00                	mov    (%eax),%eax
  8036a9:	a3 38 51 80 00       	mov    %eax,0x805138
  8036ae:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8036b1:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8036b7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8036ba:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8036c1:	a1 44 51 80 00       	mov    0x805144,%eax
  8036c6:	48                   	dec    %eax
  8036c7:	a3 44 51 80 00       	mov    %eax,0x805144
						addToAvailMemBlocksList(blockToInsert);
  8036cc:	83 ec 0c             	sub    $0xc,%esp
  8036cf:	ff 75 08             	pushl  0x8(%ebp)
  8036d2:	e8 80 fc ff ff       	call   803357 <addToAvailMemBlocksList>
  8036d7:	83 c4 10             	add    $0x10,%esp
						addToAvailMemBlocksList(iterator);
  8036da:	83 ec 0c             	sub    $0xc,%esp
  8036dd:	ff 75 f4             	pushl  -0xc(%ebp)
  8036e0:	e8 72 fc ff ff       	call   803357 <addToAvailMemBlocksList>
  8036e5:	83 c4 10             	add    $0x10,%esp
					//Insert
					else {
						LIST_INSERT_BEFORE(&FreeMemBlocksList, iterator,
								blockToInsert);
					}
					break;
  8036e8:	e9 2e 01 00 00       	jmp    80381b <insert_sorted_with_merge_freeList+0x444>
						LIST_REMOVE(&FreeMemBlocksList, iterator);
						addToAvailMemBlocksList(blockToInsert);
						addToAvailMemBlocksList(iterator);
					}
					//previous merge
					else if (prev->sva + prev->size == blockToInsert->sva) {
  8036ed:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8036f0:	8b 50 08             	mov    0x8(%eax),%edx
  8036f3:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8036f6:	8b 40 0c             	mov    0xc(%eax),%eax
  8036f9:	01 c2                	add    %eax,%edx
  8036fb:	8b 45 08             	mov    0x8(%ebp),%eax
  8036fe:	8b 40 08             	mov    0x8(%eax),%eax
  803701:	39 c2                	cmp    %eax,%edx
  803703:	75 27                	jne    80372c <insert_sorted_with_merge_freeList+0x355>
						prev->size = prev->size + blockToInsert->size;
  803705:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803708:	8b 50 0c             	mov    0xc(%eax),%edx
  80370b:	8b 45 08             	mov    0x8(%ebp),%eax
  80370e:	8b 40 0c             	mov    0xc(%eax),%eax
  803711:	01 c2                	add    %eax,%edx
  803713:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803716:	89 50 0c             	mov    %edx,0xc(%eax)
						addToAvailMemBlocksList(blockToInsert);
  803719:	83 ec 0c             	sub    $0xc,%esp
  80371c:	ff 75 08             	pushl  0x8(%ebp)
  80371f:	e8 33 fc ff ff       	call   803357 <addToAvailMemBlocksList>
  803724:	83 c4 10             	add    $0x10,%esp
					//Insert
					else {
						LIST_INSERT_BEFORE(&FreeMemBlocksList, iterator,
								blockToInsert);
					}
					break;
  803727:	e9 ef 00 00 00       	jmp    80381b <insert_sorted_with_merge_freeList+0x444>
					else if (prev->sva + prev->size == blockToInsert->sva) {
						prev->size = prev->size + blockToInsert->size;
						addToAvailMemBlocksList(blockToInsert);
					}
					//next merge
					else if (blockToInsert->size + blockToInsert->sva
  80372c:	8b 45 08             	mov    0x8(%ebp),%eax
  80372f:	8b 50 0c             	mov    0xc(%eax),%edx
  803732:	8b 45 08             	mov    0x8(%ebp),%eax
  803735:	8b 40 08             	mov    0x8(%eax),%eax
  803738:	01 c2                	add    %eax,%edx
							== iterator->sva) {
  80373a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80373d:	8b 40 08             	mov    0x8(%eax),%eax
					else if (prev->sva + prev->size == blockToInsert->sva) {
						prev->size = prev->size + blockToInsert->size;
						addToAvailMemBlocksList(blockToInsert);
					}
					//next merge
					else if (blockToInsert->size + blockToInsert->sva
  803740:	39 c2                	cmp    %eax,%edx
  803742:	75 33                	jne    803777 <insert_sorted_with_merge_freeList+0x3a0>
							== iterator->sva) {
						iterator->sva = blockToInsert->sva;
  803744:	8b 45 08             	mov    0x8(%ebp),%eax
  803747:	8b 50 08             	mov    0x8(%eax),%edx
  80374a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80374d:	89 50 08             	mov    %edx,0x8(%eax)
						iterator->size = iterator->size + blockToInsert->size;
  803750:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803753:	8b 50 0c             	mov    0xc(%eax),%edx
  803756:	8b 45 08             	mov    0x8(%ebp),%eax
  803759:	8b 40 0c             	mov    0xc(%eax),%eax
  80375c:	01 c2                	add    %eax,%edx
  80375e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803761:	89 50 0c             	mov    %edx,0xc(%eax)
						addToAvailMemBlocksList(blockToInsert);
  803764:	83 ec 0c             	sub    $0xc,%esp
  803767:	ff 75 08             	pushl  0x8(%ebp)
  80376a:	e8 e8 fb ff ff       	call   803357 <addToAvailMemBlocksList>
  80376f:	83 c4 10             	add    $0x10,%esp
					//Insert
					else {
						LIST_INSERT_BEFORE(&FreeMemBlocksList, iterator,
								blockToInsert);
					}
					break;
  803772:	e9 a4 00 00 00       	jmp    80381b <insert_sorted_with_merge_freeList+0x444>
						iterator->size = iterator->size + blockToInsert->size;
						addToAvailMemBlocksList(blockToInsert);
					}
					//Insert
					else {
						LIST_INSERT_BEFORE(&FreeMemBlocksList, iterator,
  803777:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80377b:	74 06                	je     803783 <insert_sorted_with_merge_freeList+0x3ac>
  80377d:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803781:	75 17                	jne    80379a <insert_sorted_with_merge_freeList+0x3c3>
  803783:	83 ec 04             	sub    $0x4,%esp
  803786:	68 68 43 80 00       	push   $0x804368
  80378b:	68 56 01 00 00       	push   $0x156
  803790:	68 d7 42 80 00       	push   $0x8042d7
  803795:	e8 aa d4 ff ff       	call   800c44 <_panic>
  80379a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80379d:	8b 50 04             	mov    0x4(%eax),%edx
  8037a0:	8b 45 08             	mov    0x8(%ebp),%eax
  8037a3:	89 50 04             	mov    %edx,0x4(%eax)
  8037a6:	8b 45 08             	mov    0x8(%ebp),%eax
  8037a9:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8037ac:	89 10                	mov    %edx,(%eax)
  8037ae:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8037b1:	8b 40 04             	mov    0x4(%eax),%eax
  8037b4:	85 c0                	test   %eax,%eax
  8037b6:	74 0d                	je     8037c5 <insert_sorted_with_merge_freeList+0x3ee>
  8037b8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8037bb:	8b 40 04             	mov    0x4(%eax),%eax
  8037be:	8b 55 08             	mov    0x8(%ebp),%edx
  8037c1:	89 10                	mov    %edx,(%eax)
  8037c3:	eb 08                	jmp    8037cd <insert_sorted_with_merge_freeList+0x3f6>
  8037c5:	8b 45 08             	mov    0x8(%ebp),%eax
  8037c8:	a3 38 51 80 00       	mov    %eax,0x805138
  8037cd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8037d0:	8b 55 08             	mov    0x8(%ebp),%edx
  8037d3:	89 50 04             	mov    %edx,0x4(%eax)
  8037d6:	a1 44 51 80 00       	mov    0x805144,%eax
  8037db:	40                   	inc    %eax
  8037dc:	a3 44 51 80 00       	mov    %eax,0x805144
								blockToInsert);
					}
					break;
  8037e1:	eb 38                	jmp    80381b <insert_sorted_with_merge_freeList+0x444>
		} else {
			LIST_INSERT_AFTER(&FreeMemBlocksList, last, blockToInsert);
		}
	} else {
		struct MemBlock *iterator;
		LIST_FOREACH(iterator, &(FreeMemBlocksList))
  8037e3:	a1 40 51 80 00       	mov    0x805140,%eax
  8037e8:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8037eb:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8037ef:	74 07                	je     8037f8 <insert_sorted_with_merge_freeList+0x421>
  8037f1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8037f4:	8b 00                	mov    (%eax),%eax
  8037f6:	eb 05                	jmp    8037fd <insert_sorted_with_merge_freeList+0x426>
  8037f8:	b8 00 00 00 00       	mov    $0x0,%eax
  8037fd:	a3 40 51 80 00       	mov    %eax,0x805140
  803802:	a1 40 51 80 00       	mov    0x805140,%eax
  803807:	85 c0                	test   %eax,%eax
  803809:	0f 85 1a fd ff ff    	jne    803529 <insert_sorted_with_merge_freeList+0x152>
  80380f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803813:	0f 85 10 fd ff ff    	jne    803529 <insert_sorted_with_merge_freeList+0x152>
		}
	}

	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  803819:	eb 00                	jmp    80381b <insert_sorted_with_merge_freeList+0x444>
  80381b:	90                   	nop
  80381c:	c9                   	leave  
  80381d:	c3                   	ret    
  80381e:	66 90                	xchg   %ax,%ax

00803820 <__udivdi3>:
  803820:	55                   	push   %ebp
  803821:	57                   	push   %edi
  803822:	56                   	push   %esi
  803823:	53                   	push   %ebx
  803824:	83 ec 1c             	sub    $0x1c,%esp
  803827:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  80382b:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  80382f:	8b 7c 24 38          	mov    0x38(%esp),%edi
  803833:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  803837:	89 ca                	mov    %ecx,%edx
  803839:	89 f8                	mov    %edi,%eax
  80383b:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  80383f:	85 f6                	test   %esi,%esi
  803841:	75 2d                	jne    803870 <__udivdi3+0x50>
  803843:	39 cf                	cmp    %ecx,%edi
  803845:	77 65                	ja     8038ac <__udivdi3+0x8c>
  803847:	89 fd                	mov    %edi,%ebp
  803849:	85 ff                	test   %edi,%edi
  80384b:	75 0b                	jne    803858 <__udivdi3+0x38>
  80384d:	b8 01 00 00 00       	mov    $0x1,%eax
  803852:	31 d2                	xor    %edx,%edx
  803854:	f7 f7                	div    %edi
  803856:	89 c5                	mov    %eax,%ebp
  803858:	31 d2                	xor    %edx,%edx
  80385a:	89 c8                	mov    %ecx,%eax
  80385c:	f7 f5                	div    %ebp
  80385e:	89 c1                	mov    %eax,%ecx
  803860:	89 d8                	mov    %ebx,%eax
  803862:	f7 f5                	div    %ebp
  803864:	89 cf                	mov    %ecx,%edi
  803866:	89 fa                	mov    %edi,%edx
  803868:	83 c4 1c             	add    $0x1c,%esp
  80386b:	5b                   	pop    %ebx
  80386c:	5e                   	pop    %esi
  80386d:	5f                   	pop    %edi
  80386e:	5d                   	pop    %ebp
  80386f:	c3                   	ret    
  803870:	39 ce                	cmp    %ecx,%esi
  803872:	77 28                	ja     80389c <__udivdi3+0x7c>
  803874:	0f bd fe             	bsr    %esi,%edi
  803877:	83 f7 1f             	xor    $0x1f,%edi
  80387a:	75 40                	jne    8038bc <__udivdi3+0x9c>
  80387c:	39 ce                	cmp    %ecx,%esi
  80387e:	72 0a                	jb     80388a <__udivdi3+0x6a>
  803880:	3b 44 24 08          	cmp    0x8(%esp),%eax
  803884:	0f 87 9e 00 00 00    	ja     803928 <__udivdi3+0x108>
  80388a:	b8 01 00 00 00       	mov    $0x1,%eax
  80388f:	89 fa                	mov    %edi,%edx
  803891:	83 c4 1c             	add    $0x1c,%esp
  803894:	5b                   	pop    %ebx
  803895:	5e                   	pop    %esi
  803896:	5f                   	pop    %edi
  803897:	5d                   	pop    %ebp
  803898:	c3                   	ret    
  803899:	8d 76 00             	lea    0x0(%esi),%esi
  80389c:	31 ff                	xor    %edi,%edi
  80389e:	31 c0                	xor    %eax,%eax
  8038a0:	89 fa                	mov    %edi,%edx
  8038a2:	83 c4 1c             	add    $0x1c,%esp
  8038a5:	5b                   	pop    %ebx
  8038a6:	5e                   	pop    %esi
  8038a7:	5f                   	pop    %edi
  8038a8:	5d                   	pop    %ebp
  8038a9:	c3                   	ret    
  8038aa:	66 90                	xchg   %ax,%ax
  8038ac:	89 d8                	mov    %ebx,%eax
  8038ae:	f7 f7                	div    %edi
  8038b0:	31 ff                	xor    %edi,%edi
  8038b2:	89 fa                	mov    %edi,%edx
  8038b4:	83 c4 1c             	add    $0x1c,%esp
  8038b7:	5b                   	pop    %ebx
  8038b8:	5e                   	pop    %esi
  8038b9:	5f                   	pop    %edi
  8038ba:	5d                   	pop    %ebp
  8038bb:	c3                   	ret    
  8038bc:	bd 20 00 00 00       	mov    $0x20,%ebp
  8038c1:	89 eb                	mov    %ebp,%ebx
  8038c3:	29 fb                	sub    %edi,%ebx
  8038c5:	89 f9                	mov    %edi,%ecx
  8038c7:	d3 e6                	shl    %cl,%esi
  8038c9:	89 c5                	mov    %eax,%ebp
  8038cb:	88 d9                	mov    %bl,%cl
  8038cd:	d3 ed                	shr    %cl,%ebp
  8038cf:	89 e9                	mov    %ebp,%ecx
  8038d1:	09 f1                	or     %esi,%ecx
  8038d3:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  8038d7:	89 f9                	mov    %edi,%ecx
  8038d9:	d3 e0                	shl    %cl,%eax
  8038db:	89 c5                	mov    %eax,%ebp
  8038dd:	89 d6                	mov    %edx,%esi
  8038df:	88 d9                	mov    %bl,%cl
  8038e1:	d3 ee                	shr    %cl,%esi
  8038e3:	89 f9                	mov    %edi,%ecx
  8038e5:	d3 e2                	shl    %cl,%edx
  8038e7:	8b 44 24 08          	mov    0x8(%esp),%eax
  8038eb:	88 d9                	mov    %bl,%cl
  8038ed:	d3 e8                	shr    %cl,%eax
  8038ef:	09 c2                	or     %eax,%edx
  8038f1:	89 d0                	mov    %edx,%eax
  8038f3:	89 f2                	mov    %esi,%edx
  8038f5:	f7 74 24 0c          	divl   0xc(%esp)
  8038f9:	89 d6                	mov    %edx,%esi
  8038fb:	89 c3                	mov    %eax,%ebx
  8038fd:	f7 e5                	mul    %ebp
  8038ff:	39 d6                	cmp    %edx,%esi
  803901:	72 19                	jb     80391c <__udivdi3+0xfc>
  803903:	74 0b                	je     803910 <__udivdi3+0xf0>
  803905:	89 d8                	mov    %ebx,%eax
  803907:	31 ff                	xor    %edi,%edi
  803909:	e9 58 ff ff ff       	jmp    803866 <__udivdi3+0x46>
  80390e:	66 90                	xchg   %ax,%ax
  803910:	8b 54 24 08          	mov    0x8(%esp),%edx
  803914:	89 f9                	mov    %edi,%ecx
  803916:	d3 e2                	shl    %cl,%edx
  803918:	39 c2                	cmp    %eax,%edx
  80391a:	73 e9                	jae    803905 <__udivdi3+0xe5>
  80391c:	8d 43 ff             	lea    -0x1(%ebx),%eax
  80391f:	31 ff                	xor    %edi,%edi
  803921:	e9 40 ff ff ff       	jmp    803866 <__udivdi3+0x46>
  803926:	66 90                	xchg   %ax,%ax
  803928:	31 c0                	xor    %eax,%eax
  80392a:	e9 37 ff ff ff       	jmp    803866 <__udivdi3+0x46>
  80392f:	90                   	nop

00803930 <__umoddi3>:
  803930:	55                   	push   %ebp
  803931:	57                   	push   %edi
  803932:	56                   	push   %esi
  803933:	53                   	push   %ebx
  803934:	83 ec 1c             	sub    $0x1c,%esp
  803937:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  80393b:	8b 74 24 34          	mov    0x34(%esp),%esi
  80393f:	8b 7c 24 38          	mov    0x38(%esp),%edi
  803943:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  803947:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80394b:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  80394f:	89 f3                	mov    %esi,%ebx
  803951:	89 fa                	mov    %edi,%edx
  803953:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  803957:	89 34 24             	mov    %esi,(%esp)
  80395a:	85 c0                	test   %eax,%eax
  80395c:	75 1a                	jne    803978 <__umoddi3+0x48>
  80395e:	39 f7                	cmp    %esi,%edi
  803960:	0f 86 a2 00 00 00    	jbe    803a08 <__umoddi3+0xd8>
  803966:	89 c8                	mov    %ecx,%eax
  803968:	89 f2                	mov    %esi,%edx
  80396a:	f7 f7                	div    %edi
  80396c:	89 d0                	mov    %edx,%eax
  80396e:	31 d2                	xor    %edx,%edx
  803970:	83 c4 1c             	add    $0x1c,%esp
  803973:	5b                   	pop    %ebx
  803974:	5e                   	pop    %esi
  803975:	5f                   	pop    %edi
  803976:	5d                   	pop    %ebp
  803977:	c3                   	ret    
  803978:	39 f0                	cmp    %esi,%eax
  80397a:	0f 87 ac 00 00 00    	ja     803a2c <__umoddi3+0xfc>
  803980:	0f bd e8             	bsr    %eax,%ebp
  803983:	83 f5 1f             	xor    $0x1f,%ebp
  803986:	0f 84 ac 00 00 00    	je     803a38 <__umoddi3+0x108>
  80398c:	bf 20 00 00 00       	mov    $0x20,%edi
  803991:	29 ef                	sub    %ebp,%edi
  803993:	89 fe                	mov    %edi,%esi
  803995:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  803999:	89 e9                	mov    %ebp,%ecx
  80399b:	d3 e0                	shl    %cl,%eax
  80399d:	89 d7                	mov    %edx,%edi
  80399f:	89 f1                	mov    %esi,%ecx
  8039a1:	d3 ef                	shr    %cl,%edi
  8039a3:	09 c7                	or     %eax,%edi
  8039a5:	89 e9                	mov    %ebp,%ecx
  8039a7:	d3 e2                	shl    %cl,%edx
  8039a9:	89 14 24             	mov    %edx,(%esp)
  8039ac:	89 d8                	mov    %ebx,%eax
  8039ae:	d3 e0                	shl    %cl,%eax
  8039b0:	89 c2                	mov    %eax,%edx
  8039b2:	8b 44 24 08          	mov    0x8(%esp),%eax
  8039b6:	d3 e0                	shl    %cl,%eax
  8039b8:	89 44 24 04          	mov    %eax,0x4(%esp)
  8039bc:	8b 44 24 08          	mov    0x8(%esp),%eax
  8039c0:	89 f1                	mov    %esi,%ecx
  8039c2:	d3 e8                	shr    %cl,%eax
  8039c4:	09 d0                	or     %edx,%eax
  8039c6:	d3 eb                	shr    %cl,%ebx
  8039c8:	89 da                	mov    %ebx,%edx
  8039ca:	f7 f7                	div    %edi
  8039cc:	89 d3                	mov    %edx,%ebx
  8039ce:	f7 24 24             	mull   (%esp)
  8039d1:	89 c6                	mov    %eax,%esi
  8039d3:	89 d1                	mov    %edx,%ecx
  8039d5:	39 d3                	cmp    %edx,%ebx
  8039d7:	0f 82 87 00 00 00    	jb     803a64 <__umoddi3+0x134>
  8039dd:	0f 84 91 00 00 00    	je     803a74 <__umoddi3+0x144>
  8039e3:	8b 54 24 04          	mov    0x4(%esp),%edx
  8039e7:	29 f2                	sub    %esi,%edx
  8039e9:	19 cb                	sbb    %ecx,%ebx
  8039eb:	89 d8                	mov    %ebx,%eax
  8039ed:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  8039f1:	d3 e0                	shl    %cl,%eax
  8039f3:	89 e9                	mov    %ebp,%ecx
  8039f5:	d3 ea                	shr    %cl,%edx
  8039f7:	09 d0                	or     %edx,%eax
  8039f9:	89 e9                	mov    %ebp,%ecx
  8039fb:	d3 eb                	shr    %cl,%ebx
  8039fd:	89 da                	mov    %ebx,%edx
  8039ff:	83 c4 1c             	add    $0x1c,%esp
  803a02:	5b                   	pop    %ebx
  803a03:	5e                   	pop    %esi
  803a04:	5f                   	pop    %edi
  803a05:	5d                   	pop    %ebp
  803a06:	c3                   	ret    
  803a07:	90                   	nop
  803a08:	89 fd                	mov    %edi,%ebp
  803a0a:	85 ff                	test   %edi,%edi
  803a0c:	75 0b                	jne    803a19 <__umoddi3+0xe9>
  803a0e:	b8 01 00 00 00       	mov    $0x1,%eax
  803a13:	31 d2                	xor    %edx,%edx
  803a15:	f7 f7                	div    %edi
  803a17:	89 c5                	mov    %eax,%ebp
  803a19:	89 f0                	mov    %esi,%eax
  803a1b:	31 d2                	xor    %edx,%edx
  803a1d:	f7 f5                	div    %ebp
  803a1f:	89 c8                	mov    %ecx,%eax
  803a21:	f7 f5                	div    %ebp
  803a23:	89 d0                	mov    %edx,%eax
  803a25:	e9 44 ff ff ff       	jmp    80396e <__umoddi3+0x3e>
  803a2a:	66 90                	xchg   %ax,%ax
  803a2c:	89 c8                	mov    %ecx,%eax
  803a2e:	89 f2                	mov    %esi,%edx
  803a30:	83 c4 1c             	add    $0x1c,%esp
  803a33:	5b                   	pop    %ebx
  803a34:	5e                   	pop    %esi
  803a35:	5f                   	pop    %edi
  803a36:	5d                   	pop    %ebp
  803a37:	c3                   	ret    
  803a38:	3b 04 24             	cmp    (%esp),%eax
  803a3b:	72 06                	jb     803a43 <__umoddi3+0x113>
  803a3d:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  803a41:	77 0f                	ja     803a52 <__umoddi3+0x122>
  803a43:	89 f2                	mov    %esi,%edx
  803a45:	29 f9                	sub    %edi,%ecx
  803a47:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  803a4b:	89 14 24             	mov    %edx,(%esp)
  803a4e:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  803a52:	8b 44 24 04          	mov    0x4(%esp),%eax
  803a56:	8b 14 24             	mov    (%esp),%edx
  803a59:	83 c4 1c             	add    $0x1c,%esp
  803a5c:	5b                   	pop    %ebx
  803a5d:	5e                   	pop    %esi
  803a5e:	5f                   	pop    %edi
  803a5f:	5d                   	pop    %ebp
  803a60:	c3                   	ret    
  803a61:	8d 76 00             	lea    0x0(%esi),%esi
  803a64:	2b 04 24             	sub    (%esp),%eax
  803a67:	19 fa                	sbb    %edi,%edx
  803a69:	89 d1                	mov    %edx,%ecx
  803a6b:	89 c6                	mov    %eax,%esi
  803a6d:	e9 71 ff ff ff       	jmp    8039e3 <__umoddi3+0xb3>
  803a72:	66 90                	xchg   %ax,%ax
  803a74:	39 44 24 04          	cmp    %eax,0x4(%esp)
  803a78:	72 ea                	jb     803a64 <__umoddi3+0x134>
  803a7a:	89 d9                	mov    %ebx,%ecx
  803a7c:	e9 62 ff ff ff       	jmp    8039e3 <__umoddi3+0xb3>
