
obj/user/tst_first_fit_3:     file format elf32-i386


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
  800031:	e8 50 0d 00 00       	call   800d86 <libmain>
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

	sys_set_uheap_strategy(UHP_PLACE_FIRSTFIT);
  800040:	83 ec 0c             	sub    $0xc,%esp
  800043:	6a 01                	push   $0x1
  800045:	e8 df 29 00 00       	call   802a29 <sys_set_uheap_strategy>
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
	sys_set_uheap_strategy(UHP_PLACE_FIRSTFIT);

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
  80009b:	68 00 3d 80 00       	push   $0x803d00
  8000a0:	6a 16                	push   $0x16
  8000a2:	68 1c 3d 80 00       	push   $0x803d1c
  8000a7:	e8 16 0e 00 00       	call   800ec2 <_panic>
	}

	int envID = sys_getenvid();
  8000ac:	e8 2a 27 00 00       	call   8027db <sys_getenvid>
  8000b1:	89 45 ec             	mov    %eax,-0x14(%ebp)

	/*Dummy malloc to enforce the UHEAP initializations*/
	malloc(0);
  8000b4:	83 ec 0c             	sub    $0xc,%esp
  8000b7:	6a 00                	push   $0x0
  8000b9:	e8 4a 20 00 00       	call   802108 <malloc>
  8000be:	83 c4 10             	add    $0x10,%esp
	/*=================================================*/

	int Mega = 1024*1024;
  8000c1:	c7 45 e8 00 00 10 00 	movl   $0x100000,-0x18(%ebp)
	int kilo = 1024;
  8000c8:	c7 45 e4 00 04 00 00 	movl   $0x400,-0x1c(%ebp)
	void* ptr_allocations[20] = {0};
  8000cf:	8d 55 8c             	lea    -0x74(%ebp),%edx
  8000d2:	b9 14 00 00 00       	mov    $0x14,%ecx
  8000d7:	b8 00 00 00 00       	mov    $0x0,%eax
  8000dc:	89 d7                	mov    %edx,%edi
  8000de:	f3 ab                	rep stos %eax,%es:(%edi)
	int freeFrames ;
	int usedDiskPages;
	//[1] Allocate all
	{
		//Allocate Shared 1 MB
		freeFrames = sys_calculate_free_frames() ;
  8000e0:	e8 2f 24 00 00       	call   802514 <sys_calculate_free_frames>
  8000e5:	89 45 e0             	mov    %eax,-0x20(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  8000e8:	e8 c7 24 00 00       	call   8025b4 <sys_pf_calculate_allocated_pages>
  8000ed:	89 45 dc             	mov    %eax,-0x24(%ebp)
		ptr_allocations[0] = smalloc("x", 1*Mega, 1);
  8000f0:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8000f3:	83 ec 04             	sub    $0x4,%esp
  8000f6:	6a 01                	push   $0x1
  8000f8:	50                   	push   %eax
  8000f9:	68 33 3d 80 00       	push   $0x803d33
  8000fe:	e8 4d 21 00 00       	call   802250 <smalloc>
  800103:	83 c4 10             	add    $0x10,%esp
  800106:	89 45 8c             	mov    %eax,-0x74(%ebp)
		if (ptr_allocations[0] != (uint32*)USER_HEAP_START) panic("Returned address is not correct. check the setting of it and/or the updating of the shared_mem_free_address");
  800109:	8b 45 8c             	mov    -0x74(%ebp),%eax
  80010c:	3d 00 00 00 80       	cmp    $0x80000000,%eax
  800111:	74 14                	je     800127 <_main+0xef>
  800113:	83 ec 04             	sub    $0x4,%esp
  800116:	68 38 3d 80 00       	push   $0x803d38
  80011b:	6a 2a                	push   $0x2a
  80011d:	68 1c 3d 80 00       	push   $0x803d1c
  800122:	e8 9b 0d 00 00       	call   800ec2 <_panic>
		if ((freeFrames - sys_calculate_free_frames()) !=  256+1+2) panic("Wrong allocation: make sure that you allocate the required space in the user environment and add its frames to frames_storage");
  800127:	8b 5d e0             	mov    -0x20(%ebp),%ebx
  80012a:	e8 e5 23 00 00       	call   802514 <sys_calculate_free_frames>
  80012f:	29 c3                	sub    %eax,%ebx
  800131:	89 d8                	mov    %ebx,%eax
  800133:	3d 03 01 00 00       	cmp    $0x103,%eax
  800138:	74 14                	je     80014e <_main+0x116>
  80013a:	83 ec 04             	sub    $0x4,%esp
  80013d:	68 a4 3d 80 00       	push   $0x803da4
  800142:	6a 2b                	push   $0x2b
  800144:	68 1c 3d 80 00       	push   $0x803d1c
  800149:	e8 74 0d 00 00       	call   800ec2 <_panic>
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  0) panic("Wrong page file allocation: ");
  80014e:	e8 61 24 00 00       	call   8025b4 <sys_pf_calculate_allocated_pages>
  800153:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  800156:	74 14                	je     80016c <_main+0x134>
  800158:	83 ec 04             	sub    $0x4,%esp
  80015b:	68 22 3e 80 00       	push   $0x803e22
  800160:	6a 2c                	push   $0x2c
  800162:	68 1c 3d 80 00       	push   $0x803d1c
  800167:	e8 56 0d 00 00       	call   800ec2 <_panic>

		//Allocate 1 MB
		freeFrames = sys_calculate_free_frames() ;
  80016c:	e8 a3 23 00 00       	call   802514 <sys_calculate_free_frames>
  800171:	89 45 e0             	mov    %eax,-0x20(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  800174:	e8 3b 24 00 00       	call   8025b4 <sys_pf_calculate_allocated_pages>
  800179:	89 45 dc             	mov    %eax,-0x24(%ebp)
		ptr_allocations[1] = malloc(1*Mega-kilo);
  80017c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80017f:	2b 45 e4             	sub    -0x1c(%ebp),%eax
  800182:	83 ec 0c             	sub    $0xc,%esp
  800185:	50                   	push   %eax
  800186:	e8 7d 1f 00 00       	call   802108 <malloc>
  80018b:	83 c4 10             	add    $0x10,%esp
  80018e:	89 45 90             	mov    %eax,-0x70(%ebp)
		if ((uint32) ptr_allocations[1] != (USER_HEAP_START + 1*Mega)) panic("Wrong start address for the allocated space... ");
  800191:	8b 45 90             	mov    -0x70(%ebp),%eax
  800194:	89 c2                	mov    %eax,%edx
  800196:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800199:	05 00 00 00 80       	add    $0x80000000,%eax
  80019e:	39 c2                	cmp    %eax,%edx
  8001a0:	74 14                	je     8001b6 <_main+0x17e>
  8001a2:	83 ec 04             	sub    $0x4,%esp
  8001a5:	68 40 3e 80 00       	push   $0x803e40
  8001aa:	6a 32                	push   $0x32
  8001ac:	68 1c 3d 80 00       	push   $0x803d1c
  8001b1:	e8 0c 0d 00 00       	call   800ec2 <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 256 ) panic("Wrong allocation: ");
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  0) panic("Wrong page file allocation: ");
  8001b6:	e8 f9 23 00 00       	call   8025b4 <sys_pf_calculate_allocated_pages>
  8001bb:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  8001be:	74 14                	je     8001d4 <_main+0x19c>
  8001c0:	83 ec 04             	sub    $0x4,%esp
  8001c3:	68 22 3e 80 00       	push   $0x803e22
  8001c8:	6a 34                	push   $0x34
  8001ca:	68 1c 3d 80 00       	push   $0x803d1c
  8001cf:	e8 ee 0c 00 00       	call   800ec2 <_panic>
		if ((freeFrames - sys_calculate_free_frames()) != 0 ) panic("Wrong allocation: ");
  8001d4:	e8 3b 23 00 00       	call   802514 <sys_calculate_free_frames>
  8001d9:	89 c2                	mov    %eax,%edx
  8001db:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8001de:	39 c2                	cmp    %eax,%edx
  8001e0:	74 14                	je     8001f6 <_main+0x1be>
  8001e2:	83 ec 04             	sub    $0x4,%esp
  8001e5:	68 70 3e 80 00       	push   $0x803e70
  8001ea:	6a 35                	push   $0x35
  8001ec:	68 1c 3d 80 00       	push   $0x803d1c
  8001f1:	e8 cc 0c 00 00       	call   800ec2 <_panic>

		//Allocate 1 MB
		freeFrames = sys_calculate_free_frames() ;
  8001f6:	e8 19 23 00 00       	call   802514 <sys_calculate_free_frames>
  8001fb:	89 45 e0             	mov    %eax,-0x20(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  8001fe:	e8 b1 23 00 00       	call   8025b4 <sys_pf_calculate_allocated_pages>
  800203:	89 45 dc             	mov    %eax,-0x24(%ebp)
		ptr_allocations[2] = malloc(1*Mega-kilo);
  800206:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800209:	2b 45 e4             	sub    -0x1c(%ebp),%eax
  80020c:	83 ec 0c             	sub    $0xc,%esp
  80020f:	50                   	push   %eax
  800210:	e8 f3 1e 00 00       	call   802108 <malloc>
  800215:	83 c4 10             	add    $0x10,%esp
  800218:	89 45 94             	mov    %eax,-0x6c(%ebp)
		if ((uint32) ptr_allocations[2] != (USER_HEAP_START + 2*Mega)) panic("Wrong start address for the allocated space... ");
  80021b:	8b 45 94             	mov    -0x6c(%ebp),%eax
  80021e:	89 c2                	mov    %eax,%edx
  800220:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800223:	01 c0                	add    %eax,%eax
  800225:	05 00 00 00 80       	add    $0x80000000,%eax
  80022a:	39 c2                	cmp    %eax,%edx
  80022c:	74 14                	je     800242 <_main+0x20a>
  80022e:	83 ec 04             	sub    $0x4,%esp
  800231:	68 40 3e 80 00       	push   $0x803e40
  800236:	6a 3b                	push   $0x3b
  800238:	68 1c 3d 80 00       	push   $0x803d1c
  80023d:	e8 80 0c 00 00       	call   800ec2 <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 256 ) panic("Wrong allocation: ");
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  0) panic("Wrong page file allocation: ");
  800242:	e8 6d 23 00 00       	call   8025b4 <sys_pf_calculate_allocated_pages>
  800247:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  80024a:	74 14                	je     800260 <_main+0x228>
  80024c:	83 ec 04             	sub    $0x4,%esp
  80024f:	68 22 3e 80 00       	push   $0x803e22
  800254:	6a 3d                	push   $0x3d
  800256:	68 1c 3d 80 00       	push   $0x803d1c
  80025b:	e8 62 0c 00 00       	call   800ec2 <_panic>
		if ((freeFrames - sys_calculate_free_frames()) != 0 ) panic("Wrong allocation: ");
  800260:	e8 af 22 00 00       	call   802514 <sys_calculate_free_frames>
  800265:	89 c2                	mov    %eax,%edx
  800267:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80026a:	39 c2                	cmp    %eax,%edx
  80026c:	74 14                	je     800282 <_main+0x24a>
  80026e:	83 ec 04             	sub    $0x4,%esp
  800271:	68 70 3e 80 00       	push   $0x803e70
  800276:	6a 3e                	push   $0x3e
  800278:	68 1c 3d 80 00       	push   $0x803d1c
  80027d:	e8 40 0c 00 00       	call   800ec2 <_panic>

		//Allocate 1 MB
		freeFrames = sys_calculate_free_frames() ;
  800282:	e8 8d 22 00 00       	call   802514 <sys_calculate_free_frames>
  800287:	89 45 e0             	mov    %eax,-0x20(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  80028a:	e8 25 23 00 00       	call   8025b4 <sys_pf_calculate_allocated_pages>
  80028f:	89 45 dc             	mov    %eax,-0x24(%ebp)
		ptr_allocations[3] = malloc(1*Mega-kilo);
  800292:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800295:	2b 45 e4             	sub    -0x1c(%ebp),%eax
  800298:	83 ec 0c             	sub    $0xc,%esp
  80029b:	50                   	push   %eax
  80029c:	e8 67 1e 00 00       	call   802108 <malloc>
  8002a1:	83 c4 10             	add    $0x10,%esp
  8002a4:	89 45 98             	mov    %eax,-0x68(%ebp)
		if ((uint32) ptr_allocations[3] != (USER_HEAP_START + 3*Mega) ) panic("Wrong start address for the allocated space... ");
  8002a7:	8b 45 98             	mov    -0x68(%ebp),%eax
  8002aa:	89 c1                	mov    %eax,%ecx
  8002ac:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8002af:	89 c2                	mov    %eax,%edx
  8002b1:	01 d2                	add    %edx,%edx
  8002b3:	01 d0                	add    %edx,%eax
  8002b5:	05 00 00 00 80       	add    $0x80000000,%eax
  8002ba:	39 c1                	cmp    %eax,%ecx
  8002bc:	74 14                	je     8002d2 <_main+0x29a>
  8002be:	83 ec 04             	sub    $0x4,%esp
  8002c1:	68 40 3e 80 00       	push   $0x803e40
  8002c6:	6a 44                	push   $0x44
  8002c8:	68 1c 3d 80 00       	push   $0x803d1c
  8002cd:	e8 f0 0b 00 00       	call   800ec2 <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 256 ) panic("Wrong allocation: ");
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  0) panic("Wrong page file allocation: ");
  8002d2:	e8 dd 22 00 00       	call   8025b4 <sys_pf_calculate_allocated_pages>
  8002d7:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  8002da:	74 14                	je     8002f0 <_main+0x2b8>
  8002dc:	83 ec 04             	sub    $0x4,%esp
  8002df:	68 22 3e 80 00       	push   $0x803e22
  8002e4:	6a 46                	push   $0x46
  8002e6:	68 1c 3d 80 00       	push   $0x803d1c
  8002eb:	e8 d2 0b 00 00       	call   800ec2 <_panic>
		if ((freeFrames - sys_calculate_free_frames()) != 0 ) panic("Wrong allocation: ");
  8002f0:	e8 1f 22 00 00       	call   802514 <sys_calculate_free_frames>
  8002f5:	89 c2                	mov    %eax,%edx
  8002f7:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8002fa:	39 c2                	cmp    %eax,%edx
  8002fc:	74 14                	je     800312 <_main+0x2da>
  8002fe:	83 ec 04             	sub    $0x4,%esp
  800301:	68 70 3e 80 00       	push   $0x803e70
  800306:	6a 47                	push   $0x47
  800308:	68 1c 3d 80 00       	push   $0x803d1c
  80030d:	e8 b0 0b 00 00       	call   800ec2 <_panic>

		//Allocate 2 MB
		freeFrames = sys_calculate_free_frames() ;
  800312:	e8 fd 21 00 00       	call   802514 <sys_calculate_free_frames>
  800317:	89 45 e0             	mov    %eax,-0x20(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  80031a:	e8 95 22 00 00       	call   8025b4 <sys_pf_calculate_allocated_pages>
  80031f:	89 45 dc             	mov    %eax,-0x24(%ebp)
		ptr_allocations[4] = malloc(2*Mega-kilo);
  800322:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800325:	01 c0                	add    %eax,%eax
  800327:	2b 45 e4             	sub    -0x1c(%ebp),%eax
  80032a:	83 ec 0c             	sub    $0xc,%esp
  80032d:	50                   	push   %eax
  80032e:	e8 d5 1d 00 00       	call   802108 <malloc>
  800333:	83 c4 10             	add    $0x10,%esp
  800336:	89 45 9c             	mov    %eax,-0x64(%ebp)
		if ((uint32) ptr_allocations[4] != (USER_HEAP_START + 4*Mega)) panic("Wrong start address for the allocated space... ");
  800339:	8b 45 9c             	mov    -0x64(%ebp),%eax
  80033c:	89 c2                	mov    %eax,%edx
  80033e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800341:	c1 e0 02             	shl    $0x2,%eax
  800344:	05 00 00 00 80       	add    $0x80000000,%eax
  800349:	39 c2                	cmp    %eax,%edx
  80034b:	74 14                	je     800361 <_main+0x329>
  80034d:	83 ec 04             	sub    $0x4,%esp
  800350:	68 40 3e 80 00       	push   $0x803e40
  800355:	6a 4d                	push   $0x4d
  800357:	68 1c 3d 80 00       	push   $0x803d1c
  80035c:	e8 61 0b 00 00       	call   800ec2 <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 512 + 1) panic("Wrong allocation: ");
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  0) panic("Wrong page file allocation: ");
  800361:	e8 4e 22 00 00       	call   8025b4 <sys_pf_calculate_allocated_pages>
  800366:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  800369:	74 14                	je     80037f <_main+0x347>
  80036b:	83 ec 04             	sub    $0x4,%esp
  80036e:	68 22 3e 80 00       	push   $0x803e22
  800373:	6a 4f                	push   $0x4f
  800375:	68 1c 3d 80 00       	push   $0x803d1c
  80037a:	e8 43 0b 00 00       	call   800ec2 <_panic>
		if ((freeFrames - sys_calculate_free_frames()) != 0) panic("Wrong allocation: ");
  80037f:	e8 90 21 00 00       	call   802514 <sys_calculate_free_frames>
  800384:	89 c2                	mov    %eax,%edx
  800386:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800389:	39 c2                	cmp    %eax,%edx
  80038b:	74 14                	je     8003a1 <_main+0x369>
  80038d:	83 ec 04             	sub    $0x4,%esp
  800390:	68 70 3e 80 00       	push   $0x803e70
  800395:	6a 50                	push   $0x50
  800397:	68 1c 3d 80 00       	push   $0x803d1c
  80039c:	e8 21 0b 00 00       	call   800ec2 <_panic>

		//Allocate Shared 2 MB
		freeFrames = sys_calculate_free_frames() ;
  8003a1:	e8 6e 21 00 00       	call   802514 <sys_calculate_free_frames>
  8003a6:	89 45 e0             	mov    %eax,-0x20(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  8003a9:	e8 06 22 00 00       	call   8025b4 <sys_pf_calculate_allocated_pages>
  8003ae:	89 45 dc             	mov    %eax,-0x24(%ebp)
		ptr_allocations[5] = smalloc("y", 2*Mega, 1);
  8003b1:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8003b4:	01 c0                	add    %eax,%eax
  8003b6:	83 ec 04             	sub    $0x4,%esp
  8003b9:	6a 01                	push   $0x1
  8003bb:	50                   	push   %eax
  8003bc:	68 83 3e 80 00       	push   $0x803e83
  8003c1:	e8 8a 1e 00 00       	call   802250 <smalloc>
  8003c6:	83 c4 10             	add    $0x10,%esp
  8003c9:	89 45 a0             	mov    %eax,-0x60(%ebp)
		if (ptr_allocations[5] != (uint32*)(USER_HEAP_START + 6*Mega)) panic("Returned address is not correct. check the setting of it and/or the updating of the shared_mem_free_address");
  8003cc:	8b 4d a0             	mov    -0x60(%ebp),%ecx
  8003cf:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8003d2:	89 d0                	mov    %edx,%eax
  8003d4:	01 c0                	add    %eax,%eax
  8003d6:	01 d0                	add    %edx,%eax
  8003d8:	01 c0                	add    %eax,%eax
  8003da:	05 00 00 00 80       	add    $0x80000000,%eax
  8003df:	39 c1                	cmp    %eax,%ecx
  8003e1:	74 14                	je     8003f7 <_main+0x3bf>
  8003e3:	83 ec 04             	sub    $0x4,%esp
  8003e6:	68 38 3d 80 00       	push   $0x803d38
  8003eb:	6a 56                	push   $0x56
  8003ed:	68 1c 3d 80 00       	push   $0x803d1c
  8003f2:	e8 cb 0a 00 00       	call   800ec2 <_panic>
		if ((freeFrames - sys_calculate_free_frames()) !=  512+1+2) panic("Wrong allocation: make sure that you allocate the required space in the user environment and add its frames to frames_storage");
  8003f7:	8b 5d e0             	mov    -0x20(%ebp),%ebx
  8003fa:	e8 15 21 00 00       	call   802514 <sys_calculate_free_frames>
  8003ff:	29 c3                	sub    %eax,%ebx
  800401:	89 d8                	mov    %ebx,%eax
  800403:	3d 03 02 00 00       	cmp    $0x203,%eax
  800408:	74 14                	je     80041e <_main+0x3e6>
  80040a:	83 ec 04             	sub    $0x4,%esp
  80040d:	68 a4 3d 80 00       	push   $0x803da4
  800412:	6a 57                	push   $0x57
  800414:	68 1c 3d 80 00       	push   $0x803d1c
  800419:	e8 a4 0a 00 00       	call   800ec2 <_panic>
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  0) panic("Wrong page file allocation: ");
  80041e:	e8 91 21 00 00       	call   8025b4 <sys_pf_calculate_allocated_pages>
  800423:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  800426:	74 14                	je     80043c <_main+0x404>
  800428:	83 ec 04             	sub    $0x4,%esp
  80042b:	68 22 3e 80 00       	push   $0x803e22
  800430:	6a 58                	push   $0x58
  800432:	68 1c 3d 80 00       	push   $0x803d1c
  800437:	e8 86 0a 00 00       	call   800ec2 <_panic>

		//Allocate 3 MB
		freeFrames = sys_calculate_free_frames() ;
  80043c:	e8 d3 20 00 00       	call   802514 <sys_calculate_free_frames>
  800441:	89 45 e0             	mov    %eax,-0x20(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  800444:	e8 6b 21 00 00       	call   8025b4 <sys_pf_calculate_allocated_pages>
  800449:	89 45 dc             	mov    %eax,-0x24(%ebp)
		ptr_allocations[6] = malloc(3*Mega-kilo);
  80044c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80044f:	89 c2                	mov    %eax,%edx
  800451:	01 d2                	add    %edx,%edx
  800453:	01 d0                	add    %edx,%eax
  800455:	2b 45 e4             	sub    -0x1c(%ebp),%eax
  800458:	83 ec 0c             	sub    $0xc,%esp
  80045b:	50                   	push   %eax
  80045c:	e8 a7 1c 00 00       	call   802108 <malloc>
  800461:	83 c4 10             	add    $0x10,%esp
  800464:	89 45 a4             	mov    %eax,-0x5c(%ebp)
		if ((uint32) ptr_allocations[6] != (USER_HEAP_START + 8*Mega)) panic("Wrong start address for the allocated space... ");
  800467:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  80046a:	89 c2                	mov    %eax,%edx
  80046c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80046f:	c1 e0 03             	shl    $0x3,%eax
  800472:	05 00 00 00 80       	add    $0x80000000,%eax
  800477:	39 c2                	cmp    %eax,%edx
  800479:	74 14                	je     80048f <_main+0x457>
  80047b:	83 ec 04             	sub    $0x4,%esp
  80047e:	68 40 3e 80 00       	push   $0x803e40
  800483:	6a 5e                	push   $0x5e
  800485:	68 1c 3d 80 00       	push   $0x803d1c
  80048a:	e8 33 0a 00 00       	call   800ec2 <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 768 + 1) panic("Wrong allocation: ");
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  0) panic("Wrong page file allocation: ");
  80048f:	e8 20 21 00 00       	call   8025b4 <sys_pf_calculate_allocated_pages>
  800494:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  800497:	74 14                	je     8004ad <_main+0x475>
  800499:	83 ec 04             	sub    $0x4,%esp
  80049c:	68 22 3e 80 00       	push   $0x803e22
  8004a1:	6a 60                	push   $0x60
  8004a3:	68 1c 3d 80 00       	push   $0x803d1c
  8004a8:	e8 15 0a 00 00       	call   800ec2 <_panic>
		if ((freeFrames - sys_calculate_free_frames()) != 0) panic("Wrong allocation: ");
  8004ad:	e8 62 20 00 00       	call   802514 <sys_calculate_free_frames>
  8004b2:	89 c2                	mov    %eax,%edx
  8004b4:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8004b7:	39 c2                	cmp    %eax,%edx
  8004b9:	74 14                	je     8004cf <_main+0x497>
  8004bb:	83 ec 04             	sub    $0x4,%esp
  8004be:	68 70 3e 80 00       	push   $0x803e70
  8004c3:	6a 61                	push   $0x61
  8004c5:	68 1c 3d 80 00       	push   $0x803d1c
  8004ca:	e8 f3 09 00 00       	call   800ec2 <_panic>

		//Allocate Shared 3 MB
		freeFrames = sys_calculate_free_frames() ;
  8004cf:	e8 40 20 00 00       	call   802514 <sys_calculate_free_frames>
  8004d4:	89 45 e0             	mov    %eax,-0x20(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  8004d7:	e8 d8 20 00 00       	call   8025b4 <sys_pf_calculate_allocated_pages>
  8004dc:	89 45 dc             	mov    %eax,-0x24(%ebp)
		ptr_allocations[7] = smalloc("z", 3*Mega, 0);
  8004df:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8004e2:	89 c2                	mov    %eax,%edx
  8004e4:	01 d2                	add    %edx,%edx
  8004e6:	01 d0                	add    %edx,%eax
  8004e8:	83 ec 04             	sub    $0x4,%esp
  8004eb:	6a 00                	push   $0x0
  8004ed:	50                   	push   %eax
  8004ee:	68 85 3e 80 00       	push   $0x803e85
  8004f3:	e8 58 1d 00 00       	call   802250 <smalloc>
  8004f8:	83 c4 10             	add    $0x10,%esp
  8004fb:	89 45 a8             	mov    %eax,-0x58(%ebp)
		if (ptr_allocations[7] != (uint32*)(USER_HEAP_START + 11*Mega)) panic("Returned address is not correct. check the setting of it and/or the updating of the shared_mem_free_address");
  8004fe:	8b 4d a8             	mov    -0x58(%ebp),%ecx
  800501:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800504:	89 d0                	mov    %edx,%eax
  800506:	c1 e0 02             	shl    $0x2,%eax
  800509:	01 d0                	add    %edx,%eax
  80050b:	01 c0                	add    %eax,%eax
  80050d:	01 d0                	add    %edx,%eax
  80050f:	05 00 00 00 80       	add    $0x80000000,%eax
  800514:	39 c1                	cmp    %eax,%ecx
  800516:	74 14                	je     80052c <_main+0x4f4>
  800518:	83 ec 04             	sub    $0x4,%esp
  80051b:	68 38 3d 80 00       	push   $0x803d38
  800520:	6a 67                	push   $0x67
  800522:	68 1c 3d 80 00       	push   $0x803d1c
  800527:	e8 96 09 00 00       	call   800ec2 <_panic>
		if ((freeFrames - sys_calculate_free_frames()) !=  768+2+2) panic("Wrong allocation: make sure that you allocate the required space in the user environment and add its frames to frames_storage");
  80052c:	8b 5d e0             	mov    -0x20(%ebp),%ebx
  80052f:	e8 e0 1f 00 00       	call   802514 <sys_calculate_free_frames>
  800534:	29 c3                	sub    %eax,%ebx
  800536:	89 d8                	mov    %ebx,%eax
  800538:	3d 04 03 00 00       	cmp    $0x304,%eax
  80053d:	74 14                	je     800553 <_main+0x51b>
  80053f:	83 ec 04             	sub    $0x4,%esp
  800542:	68 a4 3d 80 00       	push   $0x803da4
  800547:	6a 68                	push   $0x68
  800549:	68 1c 3d 80 00       	push   $0x803d1c
  80054e:	e8 6f 09 00 00       	call   800ec2 <_panic>
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  0) panic("Wrong page file allocation: ");
  800553:	e8 5c 20 00 00       	call   8025b4 <sys_pf_calculate_allocated_pages>
  800558:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  80055b:	74 14                	je     800571 <_main+0x539>
  80055d:	83 ec 04             	sub    $0x4,%esp
  800560:	68 22 3e 80 00       	push   $0x803e22
  800565:	6a 69                	push   $0x69
  800567:	68 1c 3d 80 00       	push   $0x803d1c
  80056c:	e8 51 09 00 00       	call   800ec2 <_panic>
	}

	//[2] Free some to create holes
	{
		//1 MB Hole
		freeFrames = sys_calculate_free_frames() ;
  800571:	e8 9e 1f 00 00       	call   802514 <sys_calculate_free_frames>
  800576:	89 45 e0             	mov    %eax,-0x20(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  800579:	e8 36 20 00 00       	call   8025b4 <sys_pf_calculate_allocated_pages>
  80057e:	89 45 dc             	mov    %eax,-0x24(%ebp)
		free(ptr_allocations[1]);
  800581:	8b 45 90             	mov    -0x70(%ebp),%eax
  800584:	83 ec 0c             	sub    $0xc,%esp
  800587:	50                   	push   %eax
  800588:	e8 fc 1b 00 00       	call   802189 <free>
  80058d:	83 c4 10             	add    $0x10,%esp
		//if ((sys_calculate_free_frames() - freeFrames) != 256) panic("Wrong free: ");
		if( (usedDiskPages - sys_pf_calculate_allocated_pages()) !=  0) panic("Wrong page file free: ");
  800590:	e8 1f 20 00 00       	call   8025b4 <sys_pf_calculate_allocated_pages>
  800595:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  800598:	74 14                	je     8005ae <_main+0x576>
  80059a:	83 ec 04             	sub    $0x4,%esp
  80059d:	68 87 3e 80 00       	push   $0x803e87
  8005a2:	6a 73                	push   $0x73
  8005a4:	68 1c 3d 80 00       	push   $0x803d1c
  8005a9:	e8 14 09 00 00       	call   800ec2 <_panic>
		if ((sys_calculate_free_frames() - freeFrames) != 0) panic("Wrong free: ");
  8005ae:	e8 61 1f 00 00       	call   802514 <sys_calculate_free_frames>
  8005b3:	89 c2                	mov    %eax,%edx
  8005b5:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8005b8:	39 c2                	cmp    %eax,%edx
  8005ba:	74 14                	je     8005d0 <_main+0x598>
  8005bc:	83 ec 04             	sub    $0x4,%esp
  8005bf:	68 9e 3e 80 00       	push   $0x803e9e
  8005c4:	6a 74                	push   $0x74
  8005c6:	68 1c 3d 80 00       	push   $0x803d1c
  8005cb:	e8 f2 08 00 00       	call   800ec2 <_panic>

		//2 MB Hole
		freeFrames = sys_calculate_free_frames() ;
  8005d0:	e8 3f 1f 00 00       	call   802514 <sys_calculate_free_frames>
  8005d5:	89 45 e0             	mov    %eax,-0x20(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  8005d8:	e8 d7 1f 00 00       	call   8025b4 <sys_pf_calculate_allocated_pages>
  8005dd:	89 45 dc             	mov    %eax,-0x24(%ebp)
		free(ptr_allocations[4]);
  8005e0:	8b 45 9c             	mov    -0x64(%ebp),%eax
  8005e3:	83 ec 0c             	sub    $0xc,%esp
  8005e6:	50                   	push   %eax
  8005e7:	e8 9d 1b 00 00       	call   802189 <free>
  8005ec:	83 c4 10             	add    $0x10,%esp
		//if ((sys_calculate_free_frames() - freeFrames) != 512) panic("Wrong free: ");
		if( (usedDiskPages - sys_pf_calculate_allocated_pages()) !=  0) panic("Wrong page file free: ");
  8005ef:	e8 c0 1f 00 00       	call   8025b4 <sys_pf_calculate_allocated_pages>
  8005f4:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  8005f7:	74 14                	je     80060d <_main+0x5d5>
  8005f9:	83 ec 04             	sub    $0x4,%esp
  8005fc:	68 87 3e 80 00       	push   $0x803e87
  800601:	6a 7b                	push   $0x7b
  800603:	68 1c 3d 80 00       	push   $0x803d1c
  800608:	e8 b5 08 00 00       	call   800ec2 <_panic>
		if ((sys_calculate_free_frames() - freeFrames) != 0) panic("Wrong free: ");
  80060d:	e8 02 1f 00 00       	call   802514 <sys_calculate_free_frames>
  800612:	89 c2                	mov    %eax,%edx
  800614:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800617:	39 c2                	cmp    %eax,%edx
  800619:	74 14                	je     80062f <_main+0x5f7>
  80061b:	83 ec 04             	sub    $0x4,%esp
  80061e:	68 9e 3e 80 00       	push   $0x803e9e
  800623:	6a 7c                	push   $0x7c
  800625:	68 1c 3d 80 00       	push   $0x803d1c
  80062a:	e8 93 08 00 00       	call   800ec2 <_panic>

		//3 MB Hole
		freeFrames = sys_calculate_free_frames() ;
  80062f:	e8 e0 1e 00 00       	call   802514 <sys_calculate_free_frames>
  800634:	89 45 e0             	mov    %eax,-0x20(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  800637:	e8 78 1f 00 00       	call   8025b4 <sys_pf_calculate_allocated_pages>
  80063c:	89 45 dc             	mov    %eax,-0x24(%ebp)
		free(ptr_allocations[6]);
  80063f:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  800642:	83 ec 0c             	sub    $0xc,%esp
  800645:	50                   	push   %eax
  800646:	e8 3e 1b 00 00       	call   802189 <free>
  80064b:	83 c4 10             	add    $0x10,%esp
		//if ((sys_calculate_free_frames() - freeFrames) != 768) panic("Wrong free: ");
		if( (usedDiskPages - sys_pf_calculate_allocated_pages()) !=  0) panic("Wrong page file free: ");
  80064e:	e8 61 1f 00 00       	call   8025b4 <sys_pf_calculate_allocated_pages>
  800653:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  800656:	74 17                	je     80066f <_main+0x637>
  800658:	83 ec 04             	sub    $0x4,%esp
  80065b:	68 87 3e 80 00       	push   $0x803e87
  800660:	68 83 00 00 00       	push   $0x83
  800665:	68 1c 3d 80 00       	push   $0x803d1c
  80066a:	e8 53 08 00 00       	call   800ec2 <_panic>
		if ((sys_calculate_free_frames() - freeFrames) != 0) panic("Wrong free: ");
  80066f:	e8 a0 1e 00 00       	call   802514 <sys_calculate_free_frames>
  800674:	89 c2                	mov    %eax,%edx
  800676:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800679:	39 c2                	cmp    %eax,%edx
  80067b:	74 17                	je     800694 <_main+0x65c>
  80067d:	83 ec 04             	sub    $0x4,%esp
  800680:	68 9e 3e 80 00       	push   $0x803e9e
  800685:	68 84 00 00 00       	push   $0x84
  80068a:	68 1c 3d 80 00       	push   $0x803d1c
  80068f:	e8 2e 08 00 00       	call   800ec2 <_panic>
	}

	//[3] Allocate again [test first fit]
	{
		//Allocate 512 KB - should be placed in 1st hole
		freeFrames = sys_calculate_free_frames() ;
  800694:	e8 7b 1e 00 00       	call   802514 <sys_calculate_free_frames>
  800699:	89 45 e0             	mov    %eax,-0x20(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  80069c:	e8 13 1f 00 00       	call   8025b4 <sys_pf_calculate_allocated_pages>
  8006a1:	89 45 dc             	mov    %eax,-0x24(%ebp)
		ptr_allocations[8] = malloc(512*kilo - kilo);
  8006a4:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8006a7:	89 d0                	mov    %edx,%eax
  8006a9:	c1 e0 09             	shl    $0x9,%eax
  8006ac:	29 d0                	sub    %edx,%eax
  8006ae:	83 ec 0c             	sub    $0xc,%esp
  8006b1:	50                   	push   %eax
  8006b2:	e8 51 1a 00 00       	call   802108 <malloc>
  8006b7:	83 c4 10             	add    $0x10,%esp
  8006ba:	89 45 ac             	mov    %eax,-0x54(%ebp)
		if ((uint32) ptr_allocations[8] != (USER_HEAP_START + 1*Mega)) panic("Wrong start address for the allocated space... ");
  8006bd:	8b 45 ac             	mov    -0x54(%ebp),%eax
  8006c0:	89 c2                	mov    %eax,%edx
  8006c2:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8006c5:	05 00 00 00 80       	add    $0x80000000,%eax
  8006ca:	39 c2                	cmp    %eax,%edx
  8006cc:	74 17                	je     8006e5 <_main+0x6ad>
  8006ce:	83 ec 04             	sub    $0x4,%esp
  8006d1:	68 40 3e 80 00       	push   $0x803e40
  8006d6:	68 8d 00 00 00       	push   $0x8d
  8006db:	68 1c 3d 80 00       	push   $0x803d1c
  8006e0:	e8 dd 07 00 00       	call   800ec2 <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 128) panic("Wrong allocation: ");
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  0) panic("Wrong page file allocation: ");
  8006e5:	e8 ca 1e 00 00       	call   8025b4 <sys_pf_calculate_allocated_pages>
  8006ea:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  8006ed:	74 17                	je     800706 <_main+0x6ce>
  8006ef:	83 ec 04             	sub    $0x4,%esp
  8006f2:	68 22 3e 80 00       	push   $0x803e22
  8006f7:	68 8f 00 00 00       	push   $0x8f
  8006fc:	68 1c 3d 80 00       	push   $0x803d1c
  800701:	e8 bc 07 00 00       	call   800ec2 <_panic>
		if ((freeFrames - sys_calculate_free_frames()) != 0) panic("Wrong allocation: ");
  800706:	e8 09 1e 00 00       	call   802514 <sys_calculate_free_frames>
  80070b:	89 c2                	mov    %eax,%edx
  80070d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800710:	39 c2                	cmp    %eax,%edx
  800712:	74 17                	je     80072b <_main+0x6f3>
  800714:	83 ec 04             	sub    $0x4,%esp
  800717:	68 70 3e 80 00       	push   $0x803e70
  80071c:	68 90 00 00 00       	push   $0x90
  800721:	68 1c 3d 80 00       	push   $0x803d1c
  800726:	e8 97 07 00 00       	call   800ec2 <_panic>

		//Allocate 1 MB - should be placed in 2nd hole
		freeFrames = sys_calculate_free_frames() ;
  80072b:	e8 e4 1d 00 00       	call   802514 <sys_calculate_free_frames>
  800730:	89 45 e0             	mov    %eax,-0x20(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  800733:	e8 7c 1e 00 00       	call   8025b4 <sys_pf_calculate_allocated_pages>
  800738:	89 45 dc             	mov    %eax,-0x24(%ebp)
		ptr_allocations[9] = malloc(1*Mega - kilo);
  80073b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80073e:	2b 45 e4             	sub    -0x1c(%ebp),%eax
  800741:	83 ec 0c             	sub    $0xc,%esp
  800744:	50                   	push   %eax
  800745:	e8 be 19 00 00       	call   802108 <malloc>
  80074a:	83 c4 10             	add    $0x10,%esp
  80074d:	89 45 b0             	mov    %eax,-0x50(%ebp)
		if ((uint32) ptr_allocations[9] != (USER_HEAP_START + 4*Mega)) panic("Wrong start address for the allocated space... ");
  800750:	8b 45 b0             	mov    -0x50(%ebp),%eax
  800753:	89 c2                	mov    %eax,%edx
  800755:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800758:	c1 e0 02             	shl    $0x2,%eax
  80075b:	05 00 00 00 80       	add    $0x80000000,%eax
  800760:	39 c2                	cmp    %eax,%edx
  800762:	74 17                	je     80077b <_main+0x743>
  800764:	83 ec 04             	sub    $0x4,%esp
  800767:	68 40 3e 80 00       	push   $0x803e40
  80076c:	68 96 00 00 00       	push   $0x96
  800771:	68 1c 3d 80 00       	push   $0x803d1c
  800776:	e8 47 07 00 00       	call   800ec2 <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 256) panic("Wrong allocation: ");
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  0) panic("Wrong page file allocation: ");
  80077b:	e8 34 1e 00 00       	call   8025b4 <sys_pf_calculate_allocated_pages>
  800780:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  800783:	74 17                	je     80079c <_main+0x764>
  800785:	83 ec 04             	sub    $0x4,%esp
  800788:	68 22 3e 80 00       	push   $0x803e22
  80078d:	68 98 00 00 00       	push   $0x98
  800792:	68 1c 3d 80 00       	push   $0x803d1c
  800797:	e8 26 07 00 00       	call   800ec2 <_panic>
		if ((freeFrames - sys_calculate_free_frames()) != 0) panic("Wrong allocation: ");
  80079c:	e8 73 1d 00 00       	call   802514 <sys_calculate_free_frames>
  8007a1:	89 c2                	mov    %eax,%edx
  8007a3:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8007a6:	39 c2                	cmp    %eax,%edx
  8007a8:	74 17                	je     8007c1 <_main+0x789>
  8007aa:	83 ec 04             	sub    $0x4,%esp
  8007ad:	68 70 3e 80 00       	push   $0x803e70
  8007b2:	68 99 00 00 00       	push   $0x99
  8007b7:	68 1c 3d 80 00       	push   $0x803d1c
  8007bc:	e8 01 07 00 00       	call   800ec2 <_panic>

		//Allocate Shared 256 KB - should be placed in remaining of 1st hole
		freeFrames = sys_calculate_free_frames() ;
  8007c1:	e8 4e 1d 00 00       	call   802514 <sys_calculate_free_frames>
  8007c6:	89 45 e0             	mov    %eax,-0x20(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  8007c9:	e8 e6 1d 00 00       	call   8025b4 <sys_pf_calculate_allocated_pages>
  8007ce:	89 45 dc             	mov    %eax,-0x24(%ebp)
		//ptr_allocations[10] = malloc(256*kilo - kilo);
		ptr_allocations[10] = smalloc("a", 256*kilo - kilo, 0);
  8007d1:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8007d4:	89 d0                	mov    %edx,%eax
  8007d6:	c1 e0 08             	shl    $0x8,%eax
  8007d9:	29 d0                	sub    %edx,%eax
  8007db:	83 ec 04             	sub    $0x4,%esp
  8007de:	6a 00                	push   $0x0
  8007e0:	50                   	push   %eax
  8007e1:	68 ab 3e 80 00       	push   $0x803eab
  8007e6:	e8 65 1a 00 00       	call   802250 <smalloc>
  8007eb:	83 c4 10             	add    $0x10,%esp
  8007ee:	89 45 b4             	mov    %eax,-0x4c(%ebp)
		if ((uint32) ptr_allocations[10] != (USER_HEAP_START + 1*Mega + 512*kilo)) panic("Wrong start address for the allocated space... ");
  8007f1:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  8007f4:	89 c2                	mov    %eax,%edx
  8007f6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8007f9:	c1 e0 09             	shl    $0x9,%eax
  8007fc:	89 c1                	mov    %eax,%ecx
  8007fe:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800801:	01 c8                	add    %ecx,%eax
  800803:	05 00 00 00 80       	add    $0x80000000,%eax
  800808:	39 c2                	cmp    %eax,%edx
  80080a:	74 17                	je     800823 <_main+0x7eb>
  80080c:	83 ec 04             	sub    $0x4,%esp
  80080f:	68 40 3e 80 00       	push   $0x803e40
  800814:	68 a0 00 00 00       	push   $0xa0
  800819:	68 1c 3d 80 00       	push   $0x803d1c
  80081e:	e8 9f 06 00 00       	call   800ec2 <_panic>
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  0) panic("Wrong page file allocation: ");
  800823:	e8 8c 1d 00 00       	call   8025b4 <sys_pf_calculate_allocated_pages>
  800828:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  80082b:	74 17                	je     800844 <_main+0x80c>
  80082d:	83 ec 04             	sub    $0x4,%esp
  800830:	68 22 3e 80 00       	push   $0x803e22
  800835:	68 a1 00 00 00       	push   $0xa1
  80083a:	68 1c 3d 80 00       	push   $0x803d1c
  80083f:	e8 7e 06 00 00       	call   800ec2 <_panic>
		if ((freeFrames - sys_calculate_free_frames()) != 64+0+2) panic("Wrong allocation: %d", (freeFrames - sys_calculate_free_frames()));
  800844:	8b 5d e0             	mov    -0x20(%ebp),%ebx
  800847:	e8 c8 1c 00 00       	call   802514 <sys_calculate_free_frames>
  80084c:	29 c3                	sub    %eax,%ebx
  80084e:	89 d8                	mov    %ebx,%eax
  800850:	83 f8 42             	cmp    $0x42,%eax
  800853:	74 21                	je     800876 <_main+0x83e>
  800855:	8b 5d e0             	mov    -0x20(%ebp),%ebx
  800858:	e8 b7 1c 00 00       	call   802514 <sys_calculate_free_frames>
  80085d:	29 c3                	sub    %eax,%ebx
  80085f:	89 d8                	mov    %ebx,%eax
  800861:	50                   	push   %eax
  800862:	68 ad 3e 80 00       	push   $0x803ead
  800867:	68 a2 00 00 00       	push   $0xa2
  80086c:	68 1c 3d 80 00       	push   $0x803d1c
  800871:	e8 4c 06 00 00       	call   800ec2 <_panic>

		//Allocate 2 MB - should be placed in 3rd hole
		freeFrames = sys_calculate_free_frames() ;
  800876:	e8 99 1c 00 00       	call   802514 <sys_calculate_free_frames>
  80087b:	89 45 e0             	mov    %eax,-0x20(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  80087e:	e8 31 1d 00 00       	call   8025b4 <sys_pf_calculate_allocated_pages>
  800883:	89 45 dc             	mov    %eax,-0x24(%ebp)
		ptr_allocations[11] = malloc(2*Mega);
  800886:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800889:	01 c0                	add    %eax,%eax
  80088b:	83 ec 0c             	sub    $0xc,%esp
  80088e:	50                   	push   %eax
  80088f:	e8 74 18 00 00       	call   802108 <malloc>
  800894:	83 c4 10             	add    $0x10,%esp
  800897:	89 45 b8             	mov    %eax,-0x48(%ebp)
		if ((uint32) ptr_allocations[11] != (USER_HEAP_START + 8*Mega)) panic("Wrong start address for the allocated space... ");
  80089a:	8b 45 b8             	mov    -0x48(%ebp),%eax
  80089d:	89 c2                	mov    %eax,%edx
  80089f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8008a2:	c1 e0 03             	shl    $0x3,%eax
  8008a5:	05 00 00 00 80       	add    $0x80000000,%eax
  8008aa:	39 c2                	cmp    %eax,%edx
  8008ac:	74 17                	je     8008c5 <_main+0x88d>
  8008ae:	83 ec 04             	sub    $0x4,%esp
  8008b1:	68 40 3e 80 00       	push   $0x803e40
  8008b6:	68 a8 00 00 00       	push   $0xa8
  8008bb:	68 1c 3d 80 00       	push   $0x803d1c
  8008c0:	e8 fd 05 00 00       	call   800ec2 <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 256) panic("Wrong allocation: ");
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  0) panic("Wrong page file allocation: ");
  8008c5:	e8 ea 1c 00 00       	call   8025b4 <sys_pf_calculate_allocated_pages>
  8008ca:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  8008cd:	74 17                	je     8008e6 <_main+0x8ae>
  8008cf:	83 ec 04             	sub    $0x4,%esp
  8008d2:	68 22 3e 80 00       	push   $0x803e22
  8008d7:	68 aa 00 00 00       	push   $0xaa
  8008dc:	68 1c 3d 80 00       	push   $0x803d1c
  8008e1:	e8 dc 05 00 00       	call   800ec2 <_panic>
		if ((freeFrames - sys_calculate_free_frames()) != 0) panic("Wrong allocation: ");
  8008e6:	e8 29 1c 00 00       	call   802514 <sys_calculate_free_frames>
  8008eb:	89 c2                	mov    %eax,%edx
  8008ed:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8008f0:	39 c2                	cmp    %eax,%edx
  8008f2:	74 17                	je     80090b <_main+0x8d3>
  8008f4:	83 ec 04             	sub    $0x4,%esp
  8008f7:	68 70 3e 80 00       	push   $0x803e70
  8008fc:	68 ab 00 00 00       	push   $0xab
  800901:	68 1c 3d 80 00       	push   $0x803d1c
  800906:	e8 b7 05 00 00       	call   800ec2 <_panic>

		//Allocate 4 MB - should be placed in end of all allocations
		freeFrames = sys_calculate_free_frames() ;
  80090b:	e8 04 1c 00 00       	call   802514 <sys_calculate_free_frames>
  800910:	89 45 e0             	mov    %eax,-0x20(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  800913:	e8 9c 1c 00 00       	call   8025b4 <sys_pf_calculate_allocated_pages>
  800918:	89 45 dc             	mov    %eax,-0x24(%ebp)
		//ptr_allocations[12] = malloc(4*Mega - kilo);
		ptr_allocations[12] = smalloc("b", 4*Mega - kilo, 0);
  80091b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80091e:	c1 e0 02             	shl    $0x2,%eax
  800921:	2b 45 e4             	sub    -0x1c(%ebp),%eax
  800924:	83 ec 04             	sub    $0x4,%esp
  800927:	6a 00                	push   $0x0
  800929:	50                   	push   %eax
  80092a:	68 c2 3e 80 00       	push   $0x803ec2
  80092f:	e8 1c 19 00 00       	call   802250 <smalloc>
  800934:	83 c4 10             	add    $0x10,%esp
  800937:	89 45 bc             	mov    %eax,-0x44(%ebp)
		if ((uint32) ptr_allocations[12] != (USER_HEAP_START + 14*Mega) ) panic("Wrong start address for the allocated space... ");
  80093a:	8b 45 bc             	mov    -0x44(%ebp),%eax
  80093d:	89 c1                	mov    %eax,%ecx
  80093f:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800942:	89 d0                	mov    %edx,%eax
  800944:	01 c0                	add    %eax,%eax
  800946:	01 d0                	add    %edx,%eax
  800948:	01 c0                	add    %eax,%eax
  80094a:	01 d0                	add    %edx,%eax
  80094c:	01 c0                	add    %eax,%eax
  80094e:	05 00 00 00 80       	add    $0x80000000,%eax
  800953:	39 c1                	cmp    %eax,%ecx
  800955:	74 17                	je     80096e <_main+0x936>
  800957:	83 ec 04             	sub    $0x4,%esp
  80095a:	68 40 3e 80 00       	push   $0x803e40
  80095f:	68 b2 00 00 00       	push   $0xb2
  800964:	68 1c 3d 80 00       	push   $0x803d1c
  800969:	e8 54 05 00 00       	call   800ec2 <_panic>
		if ((freeFrames - sys_calculate_free_frames()) != 1024+1+2) panic("Wrong allocation: ");
  80096e:	8b 5d e0             	mov    -0x20(%ebp),%ebx
  800971:	e8 9e 1b 00 00       	call   802514 <sys_calculate_free_frames>
  800976:	29 c3                	sub    %eax,%ebx
  800978:	89 d8                	mov    %ebx,%eax
  80097a:	3d 03 04 00 00       	cmp    $0x403,%eax
  80097f:	74 17                	je     800998 <_main+0x960>
  800981:	83 ec 04             	sub    $0x4,%esp
  800984:	68 70 3e 80 00       	push   $0x803e70
  800989:	68 b3 00 00 00       	push   $0xb3
  80098e:	68 1c 3d 80 00       	push   $0x803d1c
  800993:	e8 2a 05 00 00       	call   800ec2 <_panic>
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  0) panic("Wrong page file allocation: ");
  800998:	e8 17 1c 00 00       	call   8025b4 <sys_pf_calculate_allocated_pages>
  80099d:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  8009a0:	74 17                	je     8009b9 <_main+0x981>
  8009a2:	83 ec 04             	sub    $0x4,%esp
  8009a5:	68 22 3e 80 00       	push   $0x803e22
  8009aa:	68 b4 00 00 00       	push   $0xb4
  8009af:	68 1c 3d 80 00       	push   $0x803d1c
  8009b4:	e8 09 05 00 00       	call   800ec2 <_panic>
	}

	//[4] Free contiguous allocations
	{
		//1 MB Hole appended to previous 256 KB hole
		freeFrames = sys_calculate_free_frames() ;
  8009b9:	e8 56 1b 00 00       	call   802514 <sys_calculate_free_frames>
  8009be:	89 45 e0             	mov    %eax,-0x20(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  8009c1:	e8 ee 1b 00 00       	call   8025b4 <sys_pf_calculate_allocated_pages>
  8009c6:	89 45 dc             	mov    %eax,-0x24(%ebp)
		free(ptr_allocations[2]);
  8009c9:	8b 45 94             	mov    -0x6c(%ebp),%eax
  8009cc:	83 ec 0c             	sub    $0xc,%esp
  8009cf:	50                   	push   %eax
  8009d0:	e8 b4 17 00 00       	call   802189 <free>
  8009d5:	83 c4 10             	add    $0x10,%esp
		//if ((sys_calculate_free_frames() - freeFrames) != 256) panic("Wrong free: ");
		if( (usedDiskPages - sys_pf_calculate_allocated_pages()) !=  0) panic("Wrong page file free: ");
  8009d8:	e8 d7 1b 00 00       	call   8025b4 <sys_pf_calculate_allocated_pages>
  8009dd:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  8009e0:	74 17                	je     8009f9 <_main+0x9c1>
  8009e2:	83 ec 04             	sub    $0x4,%esp
  8009e5:	68 87 3e 80 00       	push   $0x803e87
  8009ea:	68 bf 00 00 00       	push   $0xbf
  8009ef:	68 1c 3d 80 00       	push   $0x803d1c
  8009f4:	e8 c9 04 00 00       	call   800ec2 <_panic>
		if ((sys_calculate_free_frames() - freeFrames) != 0) panic("Wrong free: ");
  8009f9:	e8 16 1b 00 00       	call   802514 <sys_calculate_free_frames>
  8009fe:	89 c2                	mov    %eax,%edx
  800a00:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800a03:	39 c2                	cmp    %eax,%edx
  800a05:	74 17                	je     800a1e <_main+0x9e6>
  800a07:	83 ec 04             	sub    $0x4,%esp
  800a0a:	68 9e 3e 80 00       	push   $0x803e9e
  800a0f:	68 c0 00 00 00       	push   $0xc0
  800a14:	68 1c 3d 80 00       	push   $0x803d1c
  800a19:	e8 a4 04 00 00       	call   800ec2 <_panic>

		//1 MB Hole appended to next 1 MB hole
		freeFrames = sys_calculate_free_frames() ;
  800a1e:	e8 f1 1a 00 00       	call   802514 <sys_calculate_free_frames>
  800a23:	89 45 e0             	mov    %eax,-0x20(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  800a26:	e8 89 1b 00 00       	call   8025b4 <sys_pf_calculate_allocated_pages>
  800a2b:	89 45 dc             	mov    %eax,-0x24(%ebp)
		free(ptr_allocations[9]);
  800a2e:	8b 45 b0             	mov    -0x50(%ebp),%eax
  800a31:	83 ec 0c             	sub    $0xc,%esp
  800a34:	50                   	push   %eax
  800a35:	e8 4f 17 00 00       	call   802189 <free>
  800a3a:	83 c4 10             	add    $0x10,%esp
		//if ((sys_calculate_free_frames() - freeFrames) != 256) panic("Wrong free: ");
		if( (usedDiskPages - sys_pf_calculate_allocated_pages()) !=  0) panic("Wrong page file free: ");
  800a3d:	e8 72 1b 00 00       	call   8025b4 <sys_pf_calculate_allocated_pages>
  800a42:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  800a45:	74 17                	je     800a5e <_main+0xa26>
  800a47:	83 ec 04             	sub    $0x4,%esp
  800a4a:	68 87 3e 80 00       	push   $0x803e87
  800a4f:	68 c7 00 00 00       	push   $0xc7
  800a54:	68 1c 3d 80 00       	push   $0x803d1c
  800a59:	e8 64 04 00 00       	call   800ec2 <_panic>
		if ((sys_calculate_free_frames() - freeFrames) != 0) panic("Wrong free: ");
  800a5e:	e8 b1 1a 00 00       	call   802514 <sys_calculate_free_frames>
  800a63:	89 c2                	mov    %eax,%edx
  800a65:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800a68:	39 c2                	cmp    %eax,%edx
  800a6a:	74 17                	je     800a83 <_main+0xa4b>
  800a6c:	83 ec 04             	sub    $0x4,%esp
  800a6f:	68 9e 3e 80 00       	push   $0x803e9e
  800a74:	68 c8 00 00 00       	push   $0xc8
  800a79:	68 1c 3d 80 00       	push   $0x803d1c
  800a7e:	e8 3f 04 00 00       	call   800ec2 <_panic>

		//1 MB Hole appended to previous 1 MB + 256 KB hole and next 2 MB hole
		freeFrames = sys_calculate_free_frames() ;
  800a83:	e8 8c 1a 00 00       	call   802514 <sys_calculate_free_frames>
  800a88:	89 45 e0             	mov    %eax,-0x20(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  800a8b:	e8 24 1b 00 00       	call   8025b4 <sys_pf_calculate_allocated_pages>
  800a90:	89 45 dc             	mov    %eax,-0x24(%ebp)
		free(ptr_allocations[3]);
  800a93:	8b 45 98             	mov    -0x68(%ebp),%eax
  800a96:	83 ec 0c             	sub    $0xc,%esp
  800a99:	50                   	push   %eax
  800a9a:	e8 ea 16 00 00       	call   802189 <free>
  800a9f:	83 c4 10             	add    $0x10,%esp
		//if ((sys_calculate_free_frames() - freeFrames) != 256) panic("Wrong free: ");
		if( (usedDiskPages - sys_pf_calculate_allocated_pages()) !=  0) panic("Wrong page file free: ");
  800aa2:	e8 0d 1b 00 00       	call   8025b4 <sys_pf_calculate_allocated_pages>
  800aa7:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  800aaa:	74 17                	je     800ac3 <_main+0xa8b>
  800aac:	83 ec 04             	sub    $0x4,%esp
  800aaf:	68 87 3e 80 00       	push   $0x803e87
  800ab4:	68 cf 00 00 00       	push   $0xcf
  800ab9:	68 1c 3d 80 00       	push   $0x803d1c
  800abe:	e8 ff 03 00 00       	call   800ec2 <_panic>
		if ((sys_calculate_free_frames() - freeFrames) != 0) panic("Wrong free: ");
  800ac3:	e8 4c 1a 00 00       	call   802514 <sys_calculate_free_frames>
  800ac8:	89 c2                	mov    %eax,%edx
  800aca:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800acd:	39 c2                	cmp    %eax,%edx
  800acf:	74 17                	je     800ae8 <_main+0xab0>
  800ad1:	83 ec 04             	sub    $0x4,%esp
  800ad4:	68 9e 3e 80 00       	push   $0x803e9e
  800ad9:	68 d0 00 00 00       	push   $0xd0
  800ade:	68 1c 3d 80 00       	push   $0x803d1c
  800ae3:	e8 da 03 00 00       	call   800ec2 <_panic>

	//[5] Allocate again [test first fit]
	{
		//[FIRST FIT Case]
		//Allocate 1 MB + 256 KB - should be placed in the contiguous hole (256 KB + 4 MB)
		freeFrames = sys_calculate_free_frames() ;
  800ae8:	e8 27 1a 00 00       	call   802514 <sys_calculate_free_frames>
  800aed:	89 45 e0             	mov    %eax,-0x20(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  800af0:	e8 bf 1a 00 00       	call   8025b4 <sys_pf_calculate_allocated_pages>
  800af5:	89 45 dc             	mov    %eax,-0x24(%ebp)
		ptr_allocations[13] = malloc(1*Mega + 256*kilo - kilo);
  800af8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800afb:	c1 e0 08             	shl    $0x8,%eax
  800afe:	89 c2                	mov    %eax,%edx
  800b00:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800b03:	01 d0                	add    %edx,%eax
  800b05:	2b 45 e4             	sub    -0x1c(%ebp),%eax
  800b08:	83 ec 0c             	sub    $0xc,%esp
  800b0b:	50                   	push   %eax
  800b0c:	e8 f7 15 00 00       	call   802108 <malloc>
  800b11:	83 c4 10             	add    $0x10,%esp
  800b14:	89 45 c0             	mov    %eax,-0x40(%ebp)
		if ((uint32) ptr_allocations[13] != (USER_HEAP_START + 1*Mega + 768*kilo)) panic("Wrong start address for the allocated space... ");
  800b17:	8b 45 c0             	mov    -0x40(%ebp),%eax
  800b1a:	89 c1                	mov    %eax,%ecx
  800b1c:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  800b1f:	89 d0                	mov    %edx,%eax
  800b21:	01 c0                	add    %eax,%eax
  800b23:	01 d0                	add    %edx,%eax
  800b25:	c1 e0 08             	shl    $0x8,%eax
  800b28:	89 c2                	mov    %eax,%edx
  800b2a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800b2d:	01 d0                	add    %edx,%eax
  800b2f:	05 00 00 00 80       	add    $0x80000000,%eax
  800b34:	39 c1                	cmp    %eax,%ecx
  800b36:	74 17                	je     800b4f <_main+0xb17>
  800b38:	83 ec 04             	sub    $0x4,%esp
  800b3b:	68 40 3e 80 00       	push   $0x803e40
  800b40:	68 da 00 00 00       	push   $0xda
  800b45:	68 1c 3d 80 00       	push   $0x803d1c
  800b4a:	e8 73 03 00 00       	call   800ec2 <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 512+32) panic("Wrong allocation: ");
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  0) panic("Wrong page file allocation: ");
  800b4f:	e8 60 1a 00 00       	call   8025b4 <sys_pf_calculate_allocated_pages>
  800b54:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  800b57:	74 17                	je     800b70 <_main+0xb38>
  800b59:	83 ec 04             	sub    $0x4,%esp
  800b5c:	68 22 3e 80 00       	push   $0x803e22
  800b61:	68 dc 00 00 00       	push   $0xdc
  800b66:	68 1c 3d 80 00       	push   $0x803d1c
  800b6b:	e8 52 03 00 00       	call   800ec2 <_panic>
		if ((freeFrames - sys_calculate_free_frames()) != 0) panic("Wrong allocation: ");
  800b70:	e8 9f 19 00 00       	call   802514 <sys_calculate_free_frames>
  800b75:	89 c2                	mov    %eax,%edx
  800b77:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800b7a:	39 c2                	cmp    %eax,%edx
  800b7c:	74 17                	je     800b95 <_main+0xb5d>
  800b7e:	83 ec 04             	sub    $0x4,%esp
  800b81:	68 70 3e 80 00       	push   $0x803e70
  800b86:	68 dd 00 00 00       	push   $0xdd
  800b8b:	68 1c 3d 80 00       	push   $0x803d1c
  800b90:	e8 2d 03 00 00       	call   800ec2 <_panic>

		//Allocate Shared 4 MB [should be placed at the end of all allocations
		freeFrames = sys_calculate_free_frames() ;
  800b95:	e8 7a 19 00 00       	call   802514 <sys_calculate_free_frames>
  800b9a:	89 45 e0             	mov    %eax,-0x20(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  800b9d:	e8 12 1a 00 00       	call   8025b4 <sys_pf_calculate_allocated_pages>
  800ba2:	89 45 dc             	mov    %eax,-0x24(%ebp)
		ptr_allocations[14] = smalloc("w", 4*Mega, 0);
  800ba5:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800ba8:	c1 e0 02             	shl    $0x2,%eax
  800bab:	83 ec 04             	sub    $0x4,%esp
  800bae:	6a 00                	push   $0x0
  800bb0:	50                   	push   %eax
  800bb1:	68 c4 3e 80 00       	push   $0x803ec4
  800bb6:	e8 95 16 00 00       	call   802250 <smalloc>
  800bbb:	83 c4 10             	add    $0x10,%esp
  800bbe:	89 45 c4             	mov    %eax,-0x3c(%ebp)
		if (ptr_allocations[14] != (uint32*)(USER_HEAP_START + 18*Mega)) panic("Returned address is not correct. check the setting of it and/or the updating of the shared_mem_free_address");
  800bc1:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
  800bc4:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800bc7:	89 d0                	mov    %edx,%eax
  800bc9:	c1 e0 03             	shl    $0x3,%eax
  800bcc:	01 d0                	add    %edx,%eax
  800bce:	01 c0                	add    %eax,%eax
  800bd0:	05 00 00 00 80       	add    $0x80000000,%eax
  800bd5:	39 c1                	cmp    %eax,%ecx
  800bd7:	74 17                	je     800bf0 <_main+0xbb8>
  800bd9:	83 ec 04             	sub    $0x4,%esp
  800bdc:	68 38 3d 80 00       	push   $0x803d38
  800be1:	68 e3 00 00 00       	push   $0xe3
  800be6:	68 1c 3d 80 00       	push   $0x803d1c
  800beb:	e8 d2 02 00 00       	call   800ec2 <_panic>
		if ((freeFrames - sys_calculate_free_frames()) !=  1024+1+2) panic("Wrong allocation: make sure that you allocate the required space in the user environment and add its frames to frames_storage");
  800bf0:	8b 5d e0             	mov    -0x20(%ebp),%ebx
  800bf3:	e8 1c 19 00 00       	call   802514 <sys_calculate_free_frames>
  800bf8:	29 c3                	sub    %eax,%ebx
  800bfa:	89 d8                	mov    %ebx,%eax
  800bfc:	3d 03 04 00 00       	cmp    $0x403,%eax
  800c01:	74 17                	je     800c1a <_main+0xbe2>
  800c03:	83 ec 04             	sub    $0x4,%esp
  800c06:	68 a4 3d 80 00       	push   $0x803da4
  800c0b:	68 e4 00 00 00       	push   $0xe4
  800c10:	68 1c 3d 80 00       	push   $0x803d1c
  800c15:	e8 a8 02 00 00       	call   800ec2 <_panic>
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  0) panic("Wrong page file allocation: ");
  800c1a:	e8 95 19 00 00       	call   8025b4 <sys_pf_calculate_allocated_pages>
  800c1f:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  800c22:	74 17                	je     800c3b <_main+0xc03>
  800c24:	83 ec 04             	sub    $0x4,%esp
  800c27:	68 22 3e 80 00       	push   $0x803e22
  800c2c:	68 e5 00 00 00       	push   $0xe5
  800c31:	68 1c 3d 80 00       	push   $0x803d1c
  800c36:	e8 87 02 00 00       	call   800ec2 <_panic>

		//Get shared of 3 MB [should be placed in the remaining part of the contiguous (256 KB + 4 MB) hole
		freeFrames = sys_calculate_free_frames() ;
  800c3b:	e8 d4 18 00 00       	call   802514 <sys_calculate_free_frames>
  800c40:	89 45 e0             	mov    %eax,-0x20(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  800c43:	e8 6c 19 00 00       	call   8025b4 <sys_pf_calculate_allocated_pages>
  800c48:	89 45 dc             	mov    %eax,-0x24(%ebp)
		ptr_allocations[15] = sget(envID, "z");
  800c4b:	83 ec 08             	sub    $0x8,%esp
  800c4e:	68 85 3e 80 00       	push   $0x803e85
  800c53:	ff 75 ec             	pushl  -0x14(%ebp)
  800c56:	e8 a5 16 00 00       	call   802300 <sget>
  800c5b:	83 c4 10             	add    $0x10,%esp
  800c5e:	89 45 c8             	mov    %eax,-0x38(%ebp)
		if (ptr_allocations[15] != (uint32*)(USER_HEAP_START + 3*Mega)) panic("Returned address is not correct. check the setting of it and/or the updating of the shared_mem_free_address");
  800c61:	8b 55 c8             	mov    -0x38(%ebp),%edx
  800c64:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800c67:	89 c1                	mov    %eax,%ecx
  800c69:	01 c9                	add    %ecx,%ecx
  800c6b:	01 c8                	add    %ecx,%eax
  800c6d:	05 00 00 00 80       	add    $0x80000000,%eax
  800c72:	39 c2                	cmp    %eax,%edx
  800c74:	74 17                	je     800c8d <_main+0xc55>
  800c76:	83 ec 04             	sub    $0x4,%esp
  800c79:	68 38 3d 80 00       	push   $0x803d38
  800c7e:	68 eb 00 00 00       	push   $0xeb
  800c83:	68 1c 3d 80 00       	push   $0x803d1c
  800c88:	e8 35 02 00 00       	call   800ec2 <_panic>
		if ((freeFrames - sys_calculate_free_frames()) !=  0+0+0) panic("Wrong allocation: make sure that you allocate the required space in the user environment and add its frames to frames_storage");
  800c8d:	e8 82 18 00 00       	call   802514 <sys_calculate_free_frames>
  800c92:	89 c2                	mov    %eax,%edx
  800c94:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800c97:	39 c2                	cmp    %eax,%edx
  800c99:	74 17                	je     800cb2 <_main+0xc7a>
  800c9b:	83 ec 04             	sub    $0x4,%esp
  800c9e:	68 a4 3d 80 00       	push   $0x803da4
  800ca3:	68 ec 00 00 00       	push   $0xec
  800ca8:	68 1c 3d 80 00       	push   $0x803d1c
  800cad:	e8 10 02 00 00       	call   800ec2 <_panic>
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  0) panic("Wrong page file allocation: ");
  800cb2:	e8 fd 18 00 00       	call   8025b4 <sys_pf_calculate_allocated_pages>
  800cb7:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  800cba:	74 17                	je     800cd3 <_main+0xc9b>
  800cbc:	83 ec 04             	sub    $0x4,%esp
  800cbf:	68 22 3e 80 00       	push   $0x803e22
  800cc4:	68 ed 00 00 00       	push   $0xed
  800cc9:	68 1c 3d 80 00       	push   $0x803d1c
  800cce:	e8 ef 01 00 00       	call   800ec2 <_panic>

		//Get shared of 1st 1 MB [should be placed in the remaining part of the 3 MB hole
		freeFrames = sys_calculate_free_frames() ;
  800cd3:	e8 3c 18 00 00       	call   802514 <sys_calculate_free_frames>
  800cd8:	89 45 e0             	mov    %eax,-0x20(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  800cdb:	e8 d4 18 00 00       	call   8025b4 <sys_pf_calculate_allocated_pages>
  800ce0:	89 45 dc             	mov    %eax,-0x24(%ebp)
		ptr_allocations[16] = sget(envID, "x");
  800ce3:	83 ec 08             	sub    $0x8,%esp
  800ce6:	68 33 3d 80 00       	push   $0x803d33
  800ceb:	ff 75 ec             	pushl  -0x14(%ebp)
  800cee:	e8 0d 16 00 00       	call   802300 <sget>
  800cf3:	83 c4 10             	add    $0x10,%esp
  800cf6:	89 45 cc             	mov    %eax,-0x34(%ebp)
		if (ptr_allocations[16] != (uint32*)(USER_HEAP_START + 10*Mega)) panic("Returned address is not correct. check the setting of it and/or the updating of the shared_mem_free_address");
  800cf9:	8b 4d cc             	mov    -0x34(%ebp),%ecx
  800cfc:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800cff:	89 d0                	mov    %edx,%eax
  800d01:	c1 e0 02             	shl    $0x2,%eax
  800d04:	01 d0                	add    %edx,%eax
  800d06:	01 c0                	add    %eax,%eax
  800d08:	05 00 00 00 80       	add    $0x80000000,%eax
  800d0d:	39 c1                	cmp    %eax,%ecx
  800d0f:	74 17                	je     800d28 <_main+0xcf0>
  800d11:	83 ec 04             	sub    $0x4,%esp
  800d14:	68 38 3d 80 00       	push   $0x803d38
  800d19:	68 f3 00 00 00       	push   $0xf3
  800d1e:	68 1c 3d 80 00       	push   $0x803d1c
  800d23:	e8 9a 01 00 00       	call   800ec2 <_panic>
		if ((freeFrames - sys_calculate_free_frames()) !=  0+0+0) panic("Wrong allocation: make sure that you allocate the required space in the user environment and add its frames to frames_storage");
  800d28:	e8 e7 17 00 00       	call   802514 <sys_calculate_free_frames>
  800d2d:	89 c2                	mov    %eax,%edx
  800d2f:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800d32:	39 c2                	cmp    %eax,%edx
  800d34:	74 17                	je     800d4d <_main+0xd15>
  800d36:	83 ec 04             	sub    $0x4,%esp
  800d39:	68 a4 3d 80 00       	push   $0x803da4
  800d3e:	68 f4 00 00 00       	push   $0xf4
  800d43:	68 1c 3d 80 00       	push   $0x803d1c
  800d48:	e8 75 01 00 00       	call   800ec2 <_panic>
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  0) panic("Wrong page file allocation: ");
  800d4d:	e8 62 18 00 00       	call   8025b4 <sys_pf_calculate_allocated_pages>
  800d52:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  800d55:	74 17                	je     800d6e <_main+0xd36>
  800d57:	83 ec 04             	sub    $0x4,%esp
  800d5a:	68 22 3e 80 00       	push   $0x803e22
  800d5f:	68 f5 00 00 00       	push   $0xf5
  800d64:	68 1c 3d 80 00       	push   $0x803d1c
  800d69:	e8 54 01 00 00       	call   800ec2 <_panic>

	}
	cprintf("Congratulations!! test FIRST FIT allocation (3) completed successfully.\n");
  800d6e:	83 ec 0c             	sub    $0xc,%esp
  800d71:	68 c8 3e 80 00       	push   $0x803ec8
  800d76:	e8 fb 03 00 00       	call   801176 <cprintf>
  800d7b:	83 c4 10             	add    $0x10,%esp

	return;
  800d7e:	90                   	nop
}
  800d7f:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800d82:	5b                   	pop    %ebx
  800d83:	5f                   	pop    %edi
  800d84:	5d                   	pop    %ebp
  800d85:	c3                   	ret    

00800d86 <libmain>:
volatile struct Env *myEnv = NULL;
volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";

void
libmain(int argc, char **argv)
{
  800d86:	55                   	push   %ebp
  800d87:	89 e5                	mov    %esp,%ebp
  800d89:	83 ec 18             	sub    $0x18,%esp
	int envIndex = sys_getenvindex();
  800d8c:	e8 63 1a 00 00       	call   8027f4 <sys_getenvindex>
  800d91:	89 45 f4             	mov    %eax,-0xc(%ebp)
	myEnv = &(envs[envIndex]);
  800d94:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800d97:	89 d0                	mov    %edx,%eax
  800d99:	c1 e0 03             	shl    $0x3,%eax
  800d9c:	01 d0                	add    %edx,%eax
  800d9e:	01 c0                	add    %eax,%eax
  800da0:	01 d0                	add    %edx,%eax
  800da2:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800da9:	01 d0                	add    %edx,%eax
  800dab:	c1 e0 04             	shl    $0x4,%eax
  800dae:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  800db3:	a3 20 50 80 00       	mov    %eax,0x805020

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  800db8:	a1 20 50 80 00       	mov    0x805020,%eax
  800dbd:	8a 80 5c 05 00 00    	mov    0x55c(%eax),%al
  800dc3:	84 c0                	test   %al,%al
  800dc5:	74 0f                	je     800dd6 <libmain+0x50>
		binaryname = myEnv->prog_name;
  800dc7:	a1 20 50 80 00       	mov    0x805020,%eax
  800dcc:	05 5c 05 00 00       	add    $0x55c,%eax
  800dd1:	a3 00 50 80 00       	mov    %eax,0x805000

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800dd6:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800dda:	7e 0a                	jle    800de6 <libmain+0x60>
		binaryname = argv[0];
  800ddc:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ddf:	8b 00                	mov    (%eax),%eax
  800de1:	a3 00 50 80 00       	mov    %eax,0x805000

	// call user main routine
	_main(argc, argv);
  800de6:	83 ec 08             	sub    $0x8,%esp
  800de9:	ff 75 0c             	pushl  0xc(%ebp)
  800dec:	ff 75 08             	pushl  0x8(%ebp)
  800def:	e8 44 f2 ff ff       	call   800038 <_main>
  800df4:	83 c4 10             	add    $0x10,%esp



	sys_disable_interrupt();
  800df7:	e8 05 18 00 00       	call   802601 <sys_disable_interrupt>
	cprintf("**************************************\n");
  800dfc:	83 ec 0c             	sub    $0xc,%esp
  800dff:	68 2c 3f 80 00       	push   $0x803f2c
  800e04:	e8 6d 03 00 00       	call   801176 <cprintf>
  800e09:	83 c4 10             	add    $0x10,%esp
	cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  800e0c:	a1 20 50 80 00       	mov    0x805020,%eax
  800e11:	8b 90 44 05 00 00    	mov    0x544(%eax),%edx
  800e17:	a1 20 50 80 00       	mov    0x805020,%eax
  800e1c:	8b 80 34 05 00 00    	mov    0x534(%eax),%eax
  800e22:	83 ec 04             	sub    $0x4,%esp
  800e25:	52                   	push   %edx
  800e26:	50                   	push   %eax
  800e27:	68 54 3f 80 00       	push   $0x803f54
  800e2c:	e8 45 03 00 00       	call   801176 <cprintf>
  800e31:	83 c4 10             	add    $0x10,%esp
	cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  800e34:	a1 20 50 80 00       	mov    0x805020,%eax
  800e39:	8b 88 54 05 00 00    	mov    0x554(%eax),%ecx
  800e3f:	a1 20 50 80 00       	mov    0x805020,%eax
  800e44:	8b 90 50 05 00 00    	mov    0x550(%eax),%edx
  800e4a:	a1 20 50 80 00       	mov    0x805020,%eax
  800e4f:	8b 80 4c 05 00 00    	mov    0x54c(%eax),%eax
  800e55:	51                   	push   %ecx
  800e56:	52                   	push   %edx
  800e57:	50                   	push   %eax
  800e58:	68 7c 3f 80 00       	push   $0x803f7c
  800e5d:	e8 14 03 00 00       	call   801176 <cprintf>
  800e62:	83 c4 10             	add    $0x10,%esp
	//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
	cprintf("Num of clocks = %d\n", myEnv->nClocks);
  800e65:	a1 20 50 80 00       	mov    0x805020,%eax
  800e6a:	8b 80 a4 05 00 00    	mov    0x5a4(%eax),%eax
  800e70:	83 ec 08             	sub    $0x8,%esp
  800e73:	50                   	push   %eax
  800e74:	68 d4 3f 80 00       	push   $0x803fd4
  800e79:	e8 f8 02 00 00       	call   801176 <cprintf>
  800e7e:	83 c4 10             	add    $0x10,%esp
	cprintf("**************************************\n");
  800e81:	83 ec 0c             	sub    $0xc,%esp
  800e84:	68 2c 3f 80 00       	push   $0x803f2c
  800e89:	e8 e8 02 00 00       	call   801176 <cprintf>
  800e8e:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  800e91:	e8 85 17 00 00       	call   80261b <sys_enable_interrupt>

	// exit gracefully
	exit();
  800e96:	e8 19 00 00 00       	call   800eb4 <exit>
}
  800e9b:	90                   	nop
  800e9c:	c9                   	leave  
  800e9d:	c3                   	ret    

00800e9e <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  800e9e:	55                   	push   %ebp
  800e9f:	89 e5                	mov    %esp,%ebp
  800ea1:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  800ea4:	83 ec 0c             	sub    $0xc,%esp
  800ea7:	6a 00                	push   $0x0
  800ea9:	e8 12 19 00 00       	call   8027c0 <sys_destroy_env>
  800eae:	83 c4 10             	add    $0x10,%esp
}
  800eb1:	90                   	nop
  800eb2:	c9                   	leave  
  800eb3:	c3                   	ret    

00800eb4 <exit>:

void
exit(void)
{
  800eb4:	55                   	push   %ebp
  800eb5:	89 e5                	mov    %esp,%ebp
  800eb7:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  800eba:	e8 67 19 00 00       	call   802826 <sys_exit_env>
}
  800ebf:	90                   	nop
  800ec0:	c9                   	leave  
  800ec1:	c3                   	ret    

00800ec2 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  800ec2:	55                   	push   %ebp
  800ec3:	89 e5                	mov    %esp,%ebp
  800ec5:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  800ec8:	8d 45 10             	lea    0x10(%ebp),%eax
  800ecb:	83 c0 04             	add    $0x4,%eax
  800ece:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  800ed1:	a1 5c 51 80 00       	mov    0x80515c,%eax
  800ed6:	85 c0                	test   %eax,%eax
  800ed8:	74 16                	je     800ef0 <_panic+0x2e>
		cprintf("%s: ", argv0);
  800eda:	a1 5c 51 80 00       	mov    0x80515c,%eax
  800edf:	83 ec 08             	sub    $0x8,%esp
  800ee2:	50                   	push   %eax
  800ee3:	68 e8 3f 80 00       	push   $0x803fe8
  800ee8:	e8 89 02 00 00       	call   801176 <cprintf>
  800eed:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  800ef0:	a1 00 50 80 00       	mov    0x805000,%eax
  800ef5:	ff 75 0c             	pushl  0xc(%ebp)
  800ef8:	ff 75 08             	pushl  0x8(%ebp)
  800efb:	50                   	push   %eax
  800efc:	68 ed 3f 80 00       	push   $0x803fed
  800f01:	e8 70 02 00 00       	call   801176 <cprintf>
  800f06:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  800f09:	8b 45 10             	mov    0x10(%ebp),%eax
  800f0c:	83 ec 08             	sub    $0x8,%esp
  800f0f:	ff 75 f4             	pushl  -0xc(%ebp)
  800f12:	50                   	push   %eax
  800f13:	e8 f3 01 00 00       	call   80110b <vcprintf>
  800f18:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  800f1b:	83 ec 08             	sub    $0x8,%esp
  800f1e:	6a 00                	push   $0x0
  800f20:	68 09 40 80 00       	push   $0x804009
  800f25:	e8 e1 01 00 00       	call   80110b <vcprintf>
  800f2a:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  800f2d:	e8 82 ff ff ff       	call   800eb4 <exit>

	// should not return here
	while (1) ;
  800f32:	eb fe                	jmp    800f32 <_panic+0x70>

00800f34 <CheckWSWithoutLastIndex>:
}

void CheckWSWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  800f34:	55                   	push   %ebp
  800f35:	89 e5                	mov    %esp,%ebp
  800f37:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  800f3a:	a1 20 50 80 00       	mov    0x805020,%eax
  800f3f:	8b 50 74             	mov    0x74(%eax),%edx
  800f42:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f45:	39 c2                	cmp    %eax,%edx
  800f47:	74 14                	je     800f5d <CheckWSWithoutLastIndex+0x29>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  800f49:	83 ec 04             	sub    $0x4,%esp
  800f4c:	68 0c 40 80 00       	push   $0x80400c
  800f51:	6a 26                	push   $0x26
  800f53:	68 58 40 80 00       	push   $0x804058
  800f58:	e8 65 ff ff ff       	call   800ec2 <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  800f5d:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  800f64:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800f6b:	e9 c2 00 00 00       	jmp    801032 <CheckWSWithoutLastIndex+0xfe>
		if (expectedPages[e] == 0) {
  800f70:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800f73:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800f7a:	8b 45 08             	mov    0x8(%ebp),%eax
  800f7d:	01 d0                	add    %edx,%eax
  800f7f:	8b 00                	mov    (%eax),%eax
  800f81:	85 c0                	test   %eax,%eax
  800f83:	75 08                	jne    800f8d <CheckWSWithoutLastIndex+0x59>
			expectedNumOfEmptyLocs++;
  800f85:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  800f88:	e9 a2 00 00 00       	jmp    80102f <CheckWSWithoutLastIndex+0xfb>
		}
		int found = 0;
  800f8d:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800f94:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  800f9b:	eb 69                	jmp    801006 <CheckWSWithoutLastIndex+0xd2>
			if (myEnv->__uptr_pws[w].empty == 0) {
  800f9d:	a1 20 50 80 00       	mov    0x805020,%eax
  800fa2:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  800fa8:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800fab:	89 d0                	mov    %edx,%eax
  800fad:	01 c0                	add    %eax,%eax
  800faf:	01 d0                	add    %edx,%eax
  800fb1:	c1 e0 03             	shl    $0x3,%eax
  800fb4:	01 c8                	add    %ecx,%eax
  800fb6:	8a 40 04             	mov    0x4(%eax),%al
  800fb9:	84 c0                	test   %al,%al
  800fbb:	75 46                	jne    801003 <CheckWSWithoutLastIndex+0xcf>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  800fbd:	a1 20 50 80 00       	mov    0x805020,%eax
  800fc2:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  800fc8:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800fcb:	89 d0                	mov    %edx,%eax
  800fcd:	01 c0                	add    %eax,%eax
  800fcf:	01 d0                	add    %edx,%eax
  800fd1:	c1 e0 03             	shl    $0x3,%eax
  800fd4:	01 c8                	add    %ecx,%eax
  800fd6:	8b 00                	mov    (%eax),%eax
  800fd8:	89 45 dc             	mov    %eax,-0x24(%ebp)
  800fdb:	8b 45 dc             	mov    -0x24(%ebp),%eax
  800fde:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800fe3:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  800fe5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800fe8:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  800fef:	8b 45 08             	mov    0x8(%ebp),%eax
  800ff2:	01 c8                	add    %ecx,%eax
  800ff4:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  800ff6:	39 c2                	cmp    %eax,%edx
  800ff8:	75 09                	jne    801003 <CheckWSWithoutLastIndex+0xcf>
						== expectedPages[e]) {
					found = 1;
  800ffa:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  801001:	eb 12                	jmp    801015 <CheckWSWithoutLastIndex+0xe1>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  801003:	ff 45 e8             	incl   -0x18(%ebp)
  801006:	a1 20 50 80 00       	mov    0x805020,%eax
  80100b:	8b 50 74             	mov    0x74(%eax),%edx
  80100e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801011:	39 c2                	cmp    %eax,%edx
  801013:	77 88                	ja     800f9d <CheckWSWithoutLastIndex+0x69>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  801015:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  801019:	75 14                	jne    80102f <CheckWSWithoutLastIndex+0xfb>
			panic(
  80101b:	83 ec 04             	sub    $0x4,%esp
  80101e:	68 64 40 80 00       	push   $0x804064
  801023:	6a 3a                	push   $0x3a
  801025:	68 58 40 80 00       	push   $0x804058
  80102a:	e8 93 fe ff ff       	call   800ec2 <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  80102f:	ff 45 f0             	incl   -0x10(%ebp)
  801032:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801035:	3b 45 0c             	cmp    0xc(%ebp),%eax
  801038:	0f 8c 32 ff ff ff    	jl     800f70 <CheckWSWithoutLastIndex+0x3c>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  80103e:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  801045:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  80104c:	eb 26                	jmp    801074 <CheckWSWithoutLastIndex+0x140>
		if (myEnv->__uptr_pws[w].empty == 1) {
  80104e:	a1 20 50 80 00       	mov    0x805020,%eax
  801053:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  801059:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80105c:	89 d0                	mov    %edx,%eax
  80105e:	01 c0                	add    %eax,%eax
  801060:	01 d0                	add    %edx,%eax
  801062:	c1 e0 03             	shl    $0x3,%eax
  801065:	01 c8                	add    %ecx,%eax
  801067:	8a 40 04             	mov    0x4(%eax),%al
  80106a:	3c 01                	cmp    $0x1,%al
  80106c:	75 03                	jne    801071 <CheckWSWithoutLastIndex+0x13d>
			actualNumOfEmptyLocs++;
  80106e:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  801071:	ff 45 e0             	incl   -0x20(%ebp)
  801074:	a1 20 50 80 00       	mov    0x805020,%eax
  801079:	8b 50 74             	mov    0x74(%eax),%edx
  80107c:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80107f:	39 c2                	cmp    %eax,%edx
  801081:	77 cb                	ja     80104e <CheckWSWithoutLastIndex+0x11a>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  801083:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801086:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  801089:	74 14                	je     80109f <CheckWSWithoutLastIndex+0x16b>
		panic(
  80108b:	83 ec 04             	sub    $0x4,%esp
  80108e:	68 b8 40 80 00       	push   $0x8040b8
  801093:	6a 44                	push   $0x44
  801095:	68 58 40 80 00       	push   $0x804058
  80109a:	e8 23 fe ff ff       	call   800ec2 <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  80109f:	90                   	nop
  8010a0:	c9                   	leave  
  8010a1:	c3                   	ret    

008010a2 <putch>:
};

//2017:
uint8 printProgName = 0;

static void putch(int ch, struct printbuf *b) {
  8010a2:	55                   	push   %ebp
  8010a3:	89 e5                	mov    %esp,%ebp
  8010a5:	83 ec 08             	sub    $0x8,%esp
	b->buf[b->idx++] = ch;
  8010a8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010ab:	8b 00                	mov    (%eax),%eax
  8010ad:	8d 48 01             	lea    0x1(%eax),%ecx
  8010b0:	8b 55 0c             	mov    0xc(%ebp),%edx
  8010b3:	89 0a                	mov    %ecx,(%edx)
  8010b5:	8b 55 08             	mov    0x8(%ebp),%edx
  8010b8:	88 d1                	mov    %dl,%cl
  8010ba:	8b 55 0c             	mov    0xc(%ebp),%edx
  8010bd:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  8010c1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010c4:	8b 00                	mov    (%eax),%eax
  8010c6:	3d ff 00 00 00       	cmp    $0xff,%eax
  8010cb:	75 2c                	jne    8010f9 <putch+0x57>
		sys_cputs(b->buf, b->idx, printProgName);
  8010cd:	a0 24 50 80 00       	mov    0x805024,%al
  8010d2:	0f b6 c0             	movzbl %al,%eax
  8010d5:	8b 55 0c             	mov    0xc(%ebp),%edx
  8010d8:	8b 12                	mov    (%edx),%edx
  8010da:	89 d1                	mov    %edx,%ecx
  8010dc:	8b 55 0c             	mov    0xc(%ebp),%edx
  8010df:	83 c2 08             	add    $0x8,%edx
  8010e2:	83 ec 04             	sub    $0x4,%esp
  8010e5:	50                   	push   %eax
  8010e6:	51                   	push   %ecx
  8010e7:	52                   	push   %edx
  8010e8:	e8 66 13 00 00       	call   802453 <sys_cputs>
  8010ed:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  8010f0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010f3:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  8010f9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010fc:	8b 40 04             	mov    0x4(%eax),%eax
  8010ff:	8d 50 01             	lea    0x1(%eax),%edx
  801102:	8b 45 0c             	mov    0xc(%ebp),%eax
  801105:	89 50 04             	mov    %edx,0x4(%eax)
}
  801108:	90                   	nop
  801109:	c9                   	leave  
  80110a:	c3                   	ret    

0080110b <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  80110b:	55                   	push   %ebp
  80110c:	89 e5                	mov    %esp,%ebp
  80110e:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  801114:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  80111b:	00 00 00 
	b.cnt = 0;
  80111e:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  801125:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  801128:	ff 75 0c             	pushl  0xc(%ebp)
  80112b:	ff 75 08             	pushl  0x8(%ebp)
  80112e:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  801134:	50                   	push   %eax
  801135:	68 a2 10 80 00       	push   $0x8010a2
  80113a:	e8 11 02 00 00       	call   801350 <vprintfmt>
  80113f:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName);
  801142:	a0 24 50 80 00       	mov    0x805024,%al
  801147:	0f b6 c0             	movzbl %al,%eax
  80114a:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  801150:	83 ec 04             	sub    $0x4,%esp
  801153:	50                   	push   %eax
  801154:	52                   	push   %edx
  801155:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  80115b:	83 c0 08             	add    $0x8,%eax
  80115e:	50                   	push   %eax
  80115f:	e8 ef 12 00 00       	call   802453 <sys_cputs>
  801164:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  801167:	c6 05 24 50 80 00 00 	movb   $0x0,0x805024
	return b.cnt;
  80116e:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  801174:	c9                   	leave  
  801175:	c3                   	ret    

00801176 <cprintf>:

int cprintf(const char *fmt, ...) {
  801176:	55                   	push   %ebp
  801177:	89 e5                	mov    %esp,%ebp
  801179:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  80117c:	c6 05 24 50 80 00 01 	movb   $0x1,0x805024
	va_start(ap, fmt);
  801183:	8d 45 0c             	lea    0xc(%ebp),%eax
  801186:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  801189:	8b 45 08             	mov    0x8(%ebp),%eax
  80118c:	83 ec 08             	sub    $0x8,%esp
  80118f:	ff 75 f4             	pushl  -0xc(%ebp)
  801192:	50                   	push   %eax
  801193:	e8 73 ff ff ff       	call   80110b <vcprintf>
  801198:	83 c4 10             	add    $0x10,%esp
  80119b:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  80119e:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8011a1:	c9                   	leave  
  8011a2:	c3                   	ret    

008011a3 <atomic_cprintf>:

int atomic_cprintf(const char *fmt, ...) {
  8011a3:	55                   	push   %ebp
  8011a4:	89 e5                	mov    %esp,%ebp
  8011a6:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  8011a9:	e8 53 14 00 00       	call   802601 <sys_disable_interrupt>
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  8011ae:	8d 45 0c             	lea    0xc(%ebp),%eax
  8011b1:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  8011b4:	8b 45 08             	mov    0x8(%ebp),%eax
  8011b7:	83 ec 08             	sub    $0x8,%esp
  8011ba:	ff 75 f4             	pushl  -0xc(%ebp)
  8011bd:	50                   	push   %eax
  8011be:	e8 48 ff ff ff       	call   80110b <vcprintf>
  8011c3:	83 c4 10             	add    $0x10,%esp
  8011c6:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	sys_enable_interrupt();
  8011c9:	e8 4d 14 00 00       	call   80261b <sys_enable_interrupt>
	return cnt;
  8011ce:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8011d1:	c9                   	leave  
  8011d2:	c3                   	ret    

008011d3 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8011d3:	55                   	push   %ebp
  8011d4:	89 e5                	mov    %esp,%ebp
  8011d6:	53                   	push   %ebx
  8011d7:	83 ec 14             	sub    $0x14,%esp
  8011da:	8b 45 10             	mov    0x10(%ebp),%eax
  8011dd:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8011e0:	8b 45 14             	mov    0x14(%ebp),%eax
  8011e3:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  8011e6:	8b 45 18             	mov    0x18(%ebp),%eax
  8011e9:	ba 00 00 00 00       	mov    $0x0,%edx
  8011ee:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  8011f1:	77 55                	ja     801248 <printnum+0x75>
  8011f3:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  8011f6:	72 05                	jb     8011fd <printnum+0x2a>
  8011f8:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8011fb:	77 4b                	ja     801248 <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  8011fd:	8b 45 1c             	mov    0x1c(%ebp),%eax
  801200:	8d 58 ff             	lea    -0x1(%eax),%ebx
  801203:	8b 45 18             	mov    0x18(%ebp),%eax
  801206:	ba 00 00 00 00       	mov    $0x0,%edx
  80120b:	52                   	push   %edx
  80120c:	50                   	push   %eax
  80120d:	ff 75 f4             	pushl  -0xc(%ebp)
  801210:	ff 75 f0             	pushl  -0x10(%ebp)
  801213:	e8 84 28 00 00       	call   803a9c <__udivdi3>
  801218:	83 c4 10             	add    $0x10,%esp
  80121b:	83 ec 04             	sub    $0x4,%esp
  80121e:	ff 75 20             	pushl  0x20(%ebp)
  801221:	53                   	push   %ebx
  801222:	ff 75 18             	pushl  0x18(%ebp)
  801225:	52                   	push   %edx
  801226:	50                   	push   %eax
  801227:	ff 75 0c             	pushl  0xc(%ebp)
  80122a:	ff 75 08             	pushl  0x8(%ebp)
  80122d:	e8 a1 ff ff ff       	call   8011d3 <printnum>
  801232:	83 c4 20             	add    $0x20,%esp
  801235:	eb 1a                	jmp    801251 <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  801237:	83 ec 08             	sub    $0x8,%esp
  80123a:	ff 75 0c             	pushl  0xc(%ebp)
  80123d:	ff 75 20             	pushl  0x20(%ebp)
  801240:	8b 45 08             	mov    0x8(%ebp),%eax
  801243:	ff d0                	call   *%eax
  801245:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  801248:	ff 4d 1c             	decl   0x1c(%ebp)
  80124b:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  80124f:	7f e6                	jg     801237 <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  801251:	8b 4d 18             	mov    0x18(%ebp),%ecx
  801254:	bb 00 00 00 00       	mov    $0x0,%ebx
  801259:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80125c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80125f:	53                   	push   %ebx
  801260:	51                   	push   %ecx
  801261:	52                   	push   %edx
  801262:	50                   	push   %eax
  801263:	e8 44 29 00 00       	call   803bac <__umoddi3>
  801268:	83 c4 10             	add    $0x10,%esp
  80126b:	05 34 43 80 00       	add    $0x804334,%eax
  801270:	8a 00                	mov    (%eax),%al
  801272:	0f be c0             	movsbl %al,%eax
  801275:	83 ec 08             	sub    $0x8,%esp
  801278:	ff 75 0c             	pushl  0xc(%ebp)
  80127b:	50                   	push   %eax
  80127c:	8b 45 08             	mov    0x8(%ebp),%eax
  80127f:	ff d0                	call   *%eax
  801281:	83 c4 10             	add    $0x10,%esp
}
  801284:	90                   	nop
  801285:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801288:	c9                   	leave  
  801289:	c3                   	ret    

0080128a <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  80128a:	55                   	push   %ebp
  80128b:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  80128d:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  801291:	7e 1c                	jle    8012af <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  801293:	8b 45 08             	mov    0x8(%ebp),%eax
  801296:	8b 00                	mov    (%eax),%eax
  801298:	8d 50 08             	lea    0x8(%eax),%edx
  80129b:	8b 45 08             	mov    0x8(%ebp),%eax
  80129e:	89 10                	mov    %edx,(%eax)
  8012a0:	8b 45 08             	mov    0x8(%ebp),%eax
  8012a3:	8b 00                	mov    (%eax),%eax
  8012a5:	83 e8 08             	sub    $0x8,%eax
  8012a8:	8b 50 04             	mov    0x4(%eax),%edx
  8012ab:	8b 00                	mov    (%eax),%eax
  8012ad:	eb 40                	jmp    8012ef <getuint+0x65>
	else if (lflag)
  8012af:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8012b3:	74 1e                	je     8012d3 <getuint+0x49>
		return va_arg(*ap, unsigned long);
  8012b5:	8b 45 08             	mov    0x8(%ebp),%eax
  8012b8:	8b 00                	mov    (%eax),%eax
  8012ba:	8d 50 04             	lea    0x4(%eax),%edx
  8012bd:	8b 45 08             	mov    0x8(%ebp),%eax
  8012c0:	89 10                	mov    %edx,(%eax)
  8012c2:	8b 45 08             	mov    0x8(%ebp),%eax
  8012c5:	8b 00                	mov    (%eax),%eax
  8012c7:	83 e8 04             	sub    $0x4,%eax
  8012ca:	8b 00                	mov    (%eax),%eax
  8012cc:	ba 00 00 00 00       	mov    $0x0,%edx
  8012d1:	eb 1c                	jmp    8012ef <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  8012d3:	8b 45 08             	mov    0x8(%ebp),%eax
  8012d6:	8b 00                	mov    (%eax),%eax
  8012d8:	8d 50 04             	lea    0x4(%eax),%edx
  8012db:	8b 45 08             	mov    0x8(%ebp),%eax
  8012de:	89 10                	mov    %edx,(%eax)
  8012e0:	8b 45 08             	mov    0x8(%ebp),%eax
  8012e3:	8b 00                	mov    (%eax),%eax
  8012e5:	83 e8 04             	sub    $0x4,%eax
  8012e8:	8b 00                	mov    (%eax),%eax
  8012ea:	ba 00 00 00 00       	mov    $0x0,%edx
}
  8012ef:	5d                   	pop    %ebp
  8012f0:	c3                   	ret    

008012f1 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  8012f1:	55                   	push   %ebp
  8012f2:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  8012f4:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  8012f8:	7e 1c                	jle    801316 <getint+0x25>
		return va_arg(*ap, long long);
  8012fa:	8b 45 08             	mov    0x8(%ebp),%eax
  8012fd:	8b 00                	mov    (%eax),%eax
  8012ff:	8d 50 08             	lea    0x8(%eax),%edx
  801302:	8b 45 08             	mov    0x8(%ebp),%eax
  801305:	89 10                	mov    %edx,(%eax)
  801307:	8b 45 08             	mov    0x8(%ebp),%eax
  80130a:	8b 00                	mov    (%eax),%eax
  80130c:	83 e8 08             	sub    $0x8,%eax
  80130f:	8b 50 04             	mov    0x4(%eax),%edx
  801312:	8b 00                	mov    (%eax),%eax
  801314:	eb 38                	jmp    80134e <getint+0x5d>
	else if (lflag)
  801316:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80131a:	74 1a                	je     801336 <getint+0x45>
		return va_arg(*ap, long);
  80131c:	8b 45 08             	mov    0x8(%ebp),%eax
  80131f:	8b 00                	mov    (%eax),%eax
  801321:	8d 50 04             	lea    0x4(%eax),%edx
  801324:	8b 45 08             	mov    0x8(%ebp),%eax
  801327:	89 10                	mov    %edx,(%eax)
  801329:	8b 45 08             	mov    0x8(%ebp),%eax
  80132c:	8b 00                	mov    (%eax),%eax
  80132e:	83 e8 04             	sub    $0x4,%eax
  801331:	8b 00                	mov    (%eax),%eax
  801333:	99                   	cltd   
  801334:	eb 18                	jmp    80134e <getint+0x5d>
	else
		return va_arg(*ap, int);
  801336:	8b 45 08             	mov    0x8(%ebp),%eax
  801339:	8b 00                	mov    (%eax),%eax
  80133b:	8d 50 04             	lea    0x4(%eax),%edx
  80133e:	8b 45 08             	mov    0x8(%ebp),%eax
  801341:	89 10                	mov    %edx,(%eax)
  801343:	8b 45 08             	mov    0x8(%ebp),%eax
  801346:	8b 00                	mov    (%eax),%eax
  801348:	83 e8 04             	sub    $0x4,%eax
  80134b:	8b 00                	mov    (%eax),%eax
  80134d:	99                   	cltd   
}
  80134e:	5d                   	pop    %ebp
  80134f:	c3                   	ret    

00801350 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  801350:	55                   	push   %ebp
  801351:	89 e5                	mov    %esp,%ebp
  801353:	56                   	push   %esi
  801354:	53                   	push   %ebx
  801355:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  801358:	eb 17                	jmp    801371 <vprintfmt+0x21>
			if (ch == '\0')
  80135a:	85 db                	test   %ebx,%ebx
  80135c:	0f 84 af 03 00 00    	je     801711 <vprintfmt+0x3c1>
				return;
			putch(ch, putdat);
  801362:	83 ec 08             	sub    $0x8,%esp
  801365:	ff 75 0c             	pushl  0xc(%ebp)
  801368:	53                   	push   %ebx
  801369:	8b 45 08             	mov    0x8(%ebp),%eax
  80136c:	ff d0                	call   *%eax
  80136e:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  801371:	8b 45 10             	mov    0x10(%ebp),%eax
  801374:	8d 50 01             	lea    0x1(%eax),%edx
  801377:	89 55 10             	mov    %edx,0x10(%ebp)
  80137a:	8a 00                	mov    (%eax),%al
  80137c:	0f b6 d8             	movzbl %al,%ebx
  80137f:	83 fb 25             	cmp    $0x25,%ebx
  801382:	75 d6                	jne    80135a <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  801384:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  801388:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  80138f:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  801396:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  80139d:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8013a4:	8b 45 10             	mov    0x10(%ebp),%eax
  8013a7:	8d 50 01             	lea    0x1(%eax),%edx
  8013aa:	89 55 10             	mov    %edx,0x10(%ebp)
  8013ad:	8a 00                	mov    (%eax),%al
  8013af:	0f b6 d8             	movzbl %al,%ebx
  8013b2:	8d 43 dd             	lea    -0x23(%ebx),%eax
  8013b5:	83 f8 55             	cmp    $0x55,%eax
  8013b8:	0f 87 2b 03 00 00    	ja     8016e9 <vprintfmt+0x399>
  8013be:	8b 04 85 58 43 80 00 	mov    0x804358(,%eax,4),%eax
  8013c5:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  8013c7:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  8013cb:	eb d7                	jmp    8013a4 <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  8013cd:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  8013d1:	eb d1                	jmp    8013a4 <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8013d3:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  8013da:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8013dd:	89 d0                	mov    %edx,%eax
  8013df:	c1 e0 02             	shl    $0x2,%eax
  8013e2:	01 d0                	add    %edx,%eax
  8013e4:	01 c0                	add    %eax,%eax
  8013e6:	01 d8                	add    %ebx,%eax
  8013e8:	83 e8 30             	sub    $0x30,%eax
  8013eb:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  8013ee:	8b 45 10             	mov    0x10(%ebp),%eax
  8013f1:	8a 00                	mov    (%eax),%al
  8013f3:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  8013f6:	83 fb 2f             	cmp    $0x2f,%ebx
  8013f9:	7e 3e                	jle    801439 <vprintfmt+0xe9>
  8013fb:	83 fb 39             	cmp    $0x39,%ebx
  8013fe:	7f 39                	jg     801439 <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  801400:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  801403:	eb d5                	jmp    8013da <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  801405:	8b 45 14             	mov    0x14(%ebp),%eax
  801408:	83 c0 04             	add    $0x4,%eax
  80140b:	89 45 14             	mov    %eax,0x14(%ebp)
  80140e:	8b 45 14             	mov    0x14(%ebp),%eax
  801411:	83 e8 04             	sub    $0x4,%eax
  801414:	8b 00                	mov    (%eax),%eax
  801416:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  801419:	eb 1f                	jmp    80143a <vprintfmt+0xea>

		case '.':
			if (width < 0)
  80141b:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80141f:	79 83                	jns    8013a4 <vprintfmt+0x54>
				width = 0;
  801421:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  801428:	e9 77 ff ff ff       	jmp    8013a4 <vprintfmt+0x54>

		case '#':
			altflag = 1;
  80142d:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  801434:	e9 6b ff ff ff       	jmp    8013a4 <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  801439:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  80143a:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80143e:	0f 89 60 ff ff ff    	jns    8013a4 <vprintfmt+0x54>
				width = precision, precision = -1;
  801444:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801447:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  80144a:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  801451:	e9 4e ff ff ff       	jmp    8013a4 <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  801456:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  801459:	e9 46 ff ff ff       	jmp    8013a4 <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  80145e:	8b 45 14             	mov    0x14(%ebp),%eax
  801461:	83 c0 04             	add    $0x4,%eax
  801464:	89 45 14             	mov    %eax,0x14(%ebp)
  801467:	8b 45 14             	mov    0x14(%ebp),%eax
  80146a:	83 e8 04             	sub    $0x4,%eax
  80146d:	8b 00                	mov    (%eax),%eax
  80146f:	83 ec 08             	sub    $0x8,%esp
  801472:	ff 75 0c             	pushl  0xc(%ebp)
  801475:	50                   	push   %eax
  801476:	8b 45 08             	mov    0x8(%ebp),%eax
  801479:	ff d0                	call   *%eax
  80147b:	83 c4 10             	add    $0x10,%esp
			break;
  80147e:	e9 89 02 00 00       	jmp    80170c <vprintfmt+0x3bc>

		// error message
		case 'e':
			err = va_arg(ap, int);
  801483:	8b 45 14             	mov    0x14(%ebp),%eax
  801486:	83 c0 04             	add    $0x4,%eax
  801489:	89 45 14             	mov    %eax,0x14(%ebp)
  80148c:	8b 45 14             	mov    0x14(%ebp),%eax
  80148f:	83 e8 04             	sub    $0x4,%eax
  801492:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  801494:	85 db                	test   %ebx,%ebx
  801496:	79 02                	jns    80149a <vprintfmt+0x14a>
				err = -err;
  801498:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  80149a:	83 fb 64             	cmp    $0x64,%ebx
  80149d:	7f 0b                	jg     8014aa <vprintfmt+0x15a>
  80149f:	8b 34 9d a0 41 80 00 	mov    0x8041a0(,%ebx,4),%esi
  8014a6:	85 f6                	test   %esi,%esi
  8014a8:	75 19                	jne    8014c3 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  8014aa:	53                   	push   %ebx
  8014ab:	68 45 43 80 00       	push   $0x804345
  8014b0:	ff 75 0c             	pushl  0xc(%ebp)
  8014b3:	ff 75 08             	pushl  0x8(%ebp)
  8014b6:	e8 5e 02 00 00       	call   801719 <printfmt>
  8014bb:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  8014be:	e9 49 02 00 00       	jmp    80170c <vprintfmt+0x3bc>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  8014c3:	56                   	push   %esi
  8014c4:	68 4e 43 80 00       	push   $0x80434e
  8014c9:	ff 75 0c             	pushl  0xc(%ebp)
  8014cc:	ff 75 08             	pushl  0x8(%ebp)
  8014cf:	e8 45 02 00 00       	call   801719 <printfmt>
  8014d4:	83 c4 10             	add    $0x10,%esp
			break;
  8014d7:	e9 30 02 00 00       	jmp    80170c <vprintfmt+0x3bc>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  8014dc:	8b 45 14             	mov    0x14(%ebp),%eax
  8014df:	83 c0 04             	add    $0x4,%eax
  8014e2:	89 45 14             	mov    %eax,0x14(%ebp)
  8014e5:	8b 45 14             	mov    0x14(%ebp),%eax
  8014e8:	83 e8 04             	sub    $0x4,%eax
  8014eb:	8b 30                	mov    (%eax),%esi
  8014ed:	85 f6                	test   %esi,%esi
  8014ef:	75 05                	jne    8014f6 <vprintfmt+0x1a6>
				p = "(null)";
  8014f1:	be 51 43 80 00       	mov    $0x804351,%esi
			if (width > 0 && padc != '-')
  8014f6:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8014fa:	7e 6d                	jle    801569 <vprintfmt+0x219>
  8014fc:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  801500:	74 67                	je     801569 <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  801502:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801505:	83 ec 08             	sub    $0x8,%esp
  801508:	50                   	push   %eax
  801509:	56                   	push   %esi
  80150a:	e8 0c 03 00 00       	call   80181b <strnlen>
  80150f:	83 c4 10             	add    $0x10,%esp
  801512:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  801515:	eb 16                	jmp    80152d <vprintfmt+0x1dd>
					putch(padc, putdat);
  801517:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  80151b:	83 ec 08             	sub    $0x8,%esp
  80151e:	ff 75 0c             	pushl  0xc(%ebp)
  801521:	50                   	push   %eax
  801522:	8b 45 08             	mov    0x8(%ebp),%eax
  801525:	ff d0                	call   *%eax
  801527:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  80152a:	ff 4d e4             	decl   -0x1c(%ebp)
  80152d:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  801531:	7f e4                	jg     801517 <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  801533:	eb 34                	jmp    801569 <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  801535:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  801539:	74 1c                	je     801557 <vprintfmt+0x207>
  80153b:	83 fb 1f             	cmp    $0x1f,%ebx
  80153e:	7e 05                	jle    801545 <vprintfmt+0x1f5>
  801540:	83 fb 7e             	cmp    $0x7e,%ebx
  801543:	7e 12                	jle    801557 <vprintfmt+0x207>
					putch('?', putdat);
  801545:	83 ec 08             	sub    $0x8,%esp
  801548:	ff 75 0c             	pushl  0xc(%ebp)
  80154b:	6a 3f                	push   $0x3f
  80154d:	8b 45 08             	mov    0x8(%ebp),%eax
  801550:	ff d0                	call   *%eax
  801552:	83 c4 10             	add    $0x10,%esp
  801555:	eb 0f                	jmp    801566 <vprintfmt+0x216>
				else
					putch(ch, putdat);
  801557:	83 ec 08             	sub    $0x8,%esp
  80155a:	ff 75 0c             	pushl  0xc(%ebp)
  80155d:	53                   	push   %ebx
  80155e:	8b 45 08             	mov    0x8(%ebp),%eax
  801561:	ff d0                	call   *%eax
  801563:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  801566:	ff 4d e4             	decl   -0x1c(%ebp)
  801569:	89 f0                	mov    %esi,%eax
  80156b:	8d 70 01             	lea    0x1(%eax),%esi
  80156e:	8a 00                	mov    (%eax),%al
  801570:	0f be d8             	movsbl %al,%ebx
  801573:	85 db                	test   %ebx,%ebx
  801575:	74 24                	je     80159b <vprintfmt+0x24b>
  801577:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80157b:	78 b8                	js     801535 <vprintfmt+0x1e5>
  80157d:	ff 4d e0             	decl   -0x20(%ebp)
  801580:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  801584:	79 af                	jns    801535 <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  801586:	eb 13                	jmp    80159b <vprintfmt+0x24b>
				putch(' ', putdat);
  801588:	83 ec 08             	sub    $0x8,%esp
  80158b:	ff 75 0c             	pushl  0xc(%ebp)
  80158e:	6a 20                	push   $0x20
  801590:	8b 45 08             	mov    0x8(%ebp),%eax
  801593:	ff d0                	call   *%eax
  801595:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  801598:	ff 4d e4             	decl   -0x1c(%ebp)
  80159b:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80159f:	7f e7                	jg     801588 <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  8015a1:	e9 66 01 00 00       	jmp    80170c <vprintfmt+0x3bc>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  8015a6:	83 ec 08             	sub    $0x8,%esp
  8015a9:	ff 75 e8             	pushl  -0x18(%ebp)
  8015ac:	8d 45 14             	lea    0x14(%ebp),%eax
  8015af:	50                   	push   %eax
  8015b0:	e8 3c fd ff ff       	call   8012f1 <getint>
  8015b5:	83 c4 10             	add    $0x10,%esp
  8015b8:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8015bb:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  8015be:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8015c1:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8015c4:	85 d2                	test   %edx,%edx
  8015c6:	79 23                	jns    8015eb <vprintfmt+0x29b>
				putch('-', putdat);
  8015c8:	83 ec 08             	sub    $0x8,%esp
  8015cb:	ff 75 0c             	pushl  0xc(%ebp)
  8015ce:	6a 2d                	push   $0x2d
  8015d0:	8b 45 08             	mov    0x8(%ebp),%eax
  8015d3:	ff d0                	call   *%eax
  8015d5:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  8015d8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8015db:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8015de:	f7 d8                	neg    %eax
  8015e0:	83 d2 00             	adc    $0x0,%edx
  8015e3:	f7 da                	neg    %edx
  8015e5:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8015e8:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  8015eb:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  8015f2:	e9 bc 00 00 00       	jmp    8016b3 <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  8015f7:	83 ec 08             	sub    $0x8,%esp
  8015fa:	ff 75 e8             	pushl  -0x18(%ebp)
  8015fd:	8d 45 14             	lea    0x14(%ebp),%eax
  801600:	50                   	push   %eax
  801601:	e8 84 fc ff ff       	call   80128a <getuint>
  801606:	83 c4 10             	add    $0x10,%esp
  801609:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80160c:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  80160f:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  801616:	e9 98 00 00 00       	jmp    8016b3 <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  80161b:	83 ec 08             	sub    $0x8,%esp
  80161e:	ff 75 0c             	pushl  0xc(%ebp)
  801621:	6a 58                	push   $0x58
  801623:	8b 45 08             	mov    0x8(%ebp),%eax
  801626:	ff d0                	call   *%eax
  801628:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  80162b:	83 ec 08             	sub    $0x8,%esp
  80162e:	ff 75 0c             	pushl  0xc(%ebp)
  801631:	6a 58                	push   $0x58
  801633:	8b 45 08             	mov    0x8(%ebp),%eax
  801636:	ff d0                	call   *%eax
  801638:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  80163b:	83 ec 08             	sub    $0x8,%esp
  80163e:	ff 75 0c             	pushl  0xc(%ebp)
  801641:	6a 58                	push   $0x58
  801643:	8b 45 08             	mov    0x8(%ebp),%eax
  801646:	ff d0                	call   *%eax
  801648:	83 c4 10             	add    $0x10,%esp
			break;
  80164b:	e9 bc 00 00 00       	jmp    80170c <vprintfmt+0x3bc>

		// pointer
		case 'p':
			putch('0', putdat);
  801650:	83 ec 08             	sub    $0x8,%esp
  801653:	ff 75 0c             	pushl  0xc(%ebp)
  801656:	6a 30                	push   $0x30
  801658:	8b 45 08             	mov    0x8(%ebp),%eax
  80165b:	ff d0                	call   *%eax
  80165d:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  801660:	83 ec 08             	sub    $0x8,%esp
  801663:	ff 75 0c             	pushl  0xc(%ebp)
  801666:	6a 78                	push   $0x78
  801668:	8b 45 08             	mov    0x8(%ebp),%eax
  80166b:	ff d0                	call   *%eax
  80166d:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  801670:	8b 45 14             	mov    0x14(%ebp),%eax
  801673:	83 c0 04             	add    $0x4,%eax
  801676:	89 45 14             	mov    %eax,0x14(%ebp)
  801679:	8b 45 14             	mov    0x14(%ebp),%eax
  80167c:	83 e8 04             	sub    $0x4,%eax
  80167f:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  801681:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801684:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  80168b:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  801692:	eb 1f                	jmp    8016b3 <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  801694:	83 ec 08             	sub    $0x8,%esp
  801697:	ff 75 e8             	pushl  -0x18(%ebp)
  80169a:	8d 45 14             	lea    0x14(%ebp),%eax
  80169d:	50                   	push   %eax
  80169e:	e8 e7 fb ff ff       	call   80128a <getuint>
  8016a3:	83 c4 10             	add    $0x10,%esp
  8016a6:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8016a9:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  8016ac:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  8016b3:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  8016b7:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8016ba:	83 ec 04             	sub    $0x4,%esp
  8016bd:	52                   	push   %edx
  8016be:	ff 75 e4             	pushl  -0x1c(%ebp)
  8016c1:	50                   	push   %eax
  8016c2:	ff 75 f4             	pushl  -0xc(%ebp)
  8016c5:	ff 75 f0             	pushl  -0x10(%ebp)
  8016c8:	ff 75 0c             	pushl  0xc(%ebp)
  8016cb:	ff 75 08             	pushl  0x8(%ebp)
  8016ce:	e8 00 fb ff ff       	call   8011d3 <printnum>
  8016d3:	83 c4 20             	add    $0x20,%esp
			break;
  8016d6:	eb 34                	jmp    80170c <vprintfmt+0x3bc>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  8016d8:	83 ec 08             	sub    $0x8,%esp
  8016db:	ff 75 0c             	pushl  0xc(%ebp)
  8016de:	53                   	push   %ebx
  8016df:	8b 45 08             	mov    0x8(%ebp),%eax
  8016e2:	ff d0                	call   *%eax
  8016e4:	83 c4 10             	add    $0x10,%esp
			break;
  8016e7:	eb 23                	jmp    80170c <vprintfmt+0x3bc>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  8016e9:	83 ec 08             	sub    $0x8,%esp
  8016ec:	ff 75 0c             	pushl  0xc(%ebp)
  8016ef:	6a 25                	push   $0x25
  8016f1:	8b 45 08             	mov    0x8(%ebp),%eax
  8016f4:	ff d0                	call   *%eax
  8016f6:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  8016f9:	ff 4d 10             	decl   0x10(%ebp)
  8016fc:	eb 03                	jmp    801701 <vprintfmt+0x3b1>
  8016fe:	ff 4d 10             	decl   0x10(%ebp)
  801701:	8b 45 10             	mov    0x10(%ebp),%eax
  801704:	48                   	dec    %eax
  801705:	8a 00                	mov    (%eax),%al
  801707:	3c 25                	cmp    $0x25,%al
  801709:	75 f3                	jne    8016fe <vprintfmt+0x3ae>
				/* do nothing */;
			break;
  80170b:	90                   	nop
		}
	}
  80170c:	e9 47 fc ff ff       	jmp    801358 <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  801711:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  801712:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801715:	5b                   	pop    %ebx
  801716:	5e                   	pop    %esi
  801717:	5d                   	pop    %ebp
  801718:	c3                   	ret    

00801719 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  801719:	55                   	push   %ebp
  80171a:	89 e5                	mov    %esp,%ebp
  80171c:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  80171f:	8d 45 10             	lea    0x10(%ebp),%eax
  801722:	83 c0 04             	add    $0x4,%eax
  801725:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  801728:	8b 45 10             	mov    0x10(%ebp),%eax
  80172b:	ff 75 f4             	pushl  -0xc(%ebp)
  80172e:	50                   	push   %eax
  80172f:	ff 75 0c             	pushl  0xc(%ebp)
  801732:	ff 75 08             	pushl  0x8(%ebp)
  801735:	e8 16 fc ff ff       	call   801350 <vprintfmt>
  80173a:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  80173d:	90                   	nop
  80173e:	c9                   	leave  
  80173f:	c3                   	ret    

00801740 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  801740:	55                   	push   %ebp
  801741:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  801743:	8b 45 0c             	mov    0xc(%ebp),%eax
  801746:	8b 40 08             	mov    0x8(%eax),%eax
  801749:	8d 50 01             	lea    0x1(%eax),%edx
  80174c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80174f:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  801752:	8b 45 0c             	mov    0xc(%ebp),%eax
  801755:	8b 10                	mov    (%eax),%edx
  801757:	8b 45 0c             	mov    0xc(%ebp),%eax
  80175a:	8b 40 04             	mov    0x4(%eax),%eax
  80175d:	39 c2                	cmp    %eax,%edx
  80175f:	73 12                	jae    801773 <sprintputch+0x33>
		*b->buf++ = ch;
  801761:	8b 45 0c             	mov    0xc(%ebp),%eax
  801764:	8b 00                	mov    (%eax),%eax
  801766:	8d 48 01             	lea    0x1(%eax),%ecx
  801769:	8b 55 0c             	mov    0xc(%ebp),%edx
  80176c:	89 0a                	mov    %ecx,(%edx)
  80176e:	8b 55 08             	mov    0x8(%ebp),%edx
  801771:	88 10                	mov    %dl,(%eax)
}
  801773:	90                   	nop
  801774:	5d                   	pop    %ebp
  801775:	c3                   	ret    

00801776 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  801776:	55                   	push   %ebp
  801777:	89 e5                	mov    %esp,%ebp
  801779:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  80177c:	8b 45 08             	mov    0x8(%ebp),%eax
  80177f:	89 45 ec             	mov    %eax,-0x14(%ebp)
  801782:	8b 45 0c             	mov    0xc(%ebp),%eax
  801785:	8d 50 ff             	lea    -0x1(%eax),%edx
  801788:	8b 45 08             	mov    0x8(%ebp),%eax
  80178b:	01 d0                	add    %edx,%eax
  80178d:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801790:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  801797:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80179b:	74 06                	je     8017a3 <vsnprintf+0x2d>
  80179d:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8017a1:	7f 07                	jg     8017aa <vsnprintf+0x34>
		return -E_INVAL;
  8017a3:	b8 03 00 00 00       	mov    $0x3,%eax
  8017a8:	eb 20                	jmp    8017ca <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  8017aa:	ff 75 14             	pushl  0x14(%ebp)
  8017ad:	ff 75 10             	pushl  0x10(%ebp)
  8017b0:	8d 45 ec             	lea    -0x14(%ebp),%eax
  8017b3:	50                   	push   %eax
  8017b4:	68 40 17 80 00       	push   $0x801740
  8017b9:	e8 92 fb ff ff       	call   801350 <vprintfmt>
  8017be:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  8017c1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8017c4:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  8017c7:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  8017ca:	c9                   	leave  
  8017cb:	c3                   	ret    

008017cc <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  8017cc:	55                   	push   %ebp
  8017cd:	89 e5                	mov    %esp,%ebp
  8017cf:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  8017d2:	8d 45 10             	lea    0x10(%ebp),%eax
  8017d5:	83 c0 04             	add    $0x4,%eax
  8017d8:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  8017db:	8b 45 10             	mov    0x10(%ebp),%eax
  8017de:	ff 75 f4             	pushl  -0xc(%ebp)
  8017e1:	50                   	push   %eax
  8017e2:	ff 75 0c             	pushl  0xc(%ebp)
  8017e5:	ff 75 08             	pushl  0x8(%ebp)
  8017e8:	e8 89 ff ff ff       	call   801776 <vsnprintf>
  8017ed:	83 c4 10             	add    $0x10,%esp
  8017f0:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  8017f3:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8017f6:	c9                   	leave  
  8017f7:	c3                   	ret    

008017f8 <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  8017f8:	55                   	push   %ebp
  8017f9:	89 e5                	mov    %esp,%ebp
  8017fb:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  8017fe:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801805:	eb 06                	jmp    80180d <strlen+0x15>
		n++;
  801807:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  80180a:	ff 45 08             	incl   0x8(%ebp)
  80180d:	8b 45 08             	mov    0x8(%ebp),%eax
  801810:	8a 00                	mov    (%eax),%al
  801812:	84 c0                	test   %al,%al
  801814:	75 f1                	jne    801807 <strlen+0xf>
		n++;
	return n;
  801816:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  801819:	c9                   	leave  
  80181a:	c3                   	ret    

0080181b <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  80181b:	55                   	push   %ebp
  80181c:	89 e5                	mov    %esp,%ebp
  80181e:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  801821:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801828:	eb 09                	jmp    801833 <strnlen+0x18>
		n++;
  80182a:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  80182d:	ff 45 08             	incl   0x8(%ebp)
  801830:	ff 4d 0c             	decl   0xc(%ebp)
  801833:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801837:	74 09                	je     801842 <strnlen+0x27>
  801839:	8b 45 08             	mov    0x8(%ebp),%eax
  80183c:	8a 00                	mov    (%eax),%al
  80183e:	84 c0                	test   %al,%al
  801840:	75 e8                	jne    80182a <strnlen+0xf>
		n++;
	return n;
  801842:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  801845:	c9                   	leave  
  801846:	c3                   	ret    

00801847 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  801847:	55                   	push   %ebp
  801848:	89 e5                	mov    %esp,%ebp
  80184a:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  80184d:	8b 45 08             	mov    0x8(%ebp),%eax
  801850:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  801853:	90                   	nop
  801854:	8b 45 08             	mov    0x8(%ebp),%eax
  801857:	8d 50 01             	lea    0x1(%eax),%edx
  80185a:	89 55 08             	mov    %edx,0x8(%ebp)
  80185d:	8b 55 0c             	mov    0xc(%ebp),%edx
  801860:	8d 4a 01             	lea    0x1(%edx),%ecx
  801863:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  801866:	8a 12                	mov    (%edx),%dl
  801868:	88 10                	mov    %dl,(%eax)
  80186a:	8a 00                	mov    (%eax),%al
  80186c:	84 c0                	test   %al,%al
  80186e:	75 e4                	jne    801854 <strcpy+0xd>
		/* do nothing */;
	return ret;
  801870:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  801873:	c9                   	leave  
  801874:	c3                   	ret    

00801875 <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  801875:	55                   	push   %ebp
  801876:	89 e5                	mov    %esp,%ebp
  801878:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  80187b:	8b 45 08             	mov    0x8(%ebp),%eax
  80187e:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  801881:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801888:	eb 1f                	jmp    8018a9 <strncpy+0x34>
		*dst++ = *src;
  80188a:	8b 45 08             	mov    0x8(%ebp),%eax
  80188d:	8d 50 01             	lea    0x1(%eax),%edx
  801890:	89 55 08             	mov    %edx,0x8(%ebp)
  801893:	8b 55 0c             	mov    0xc(%ebp),%edx
  801896:	8a 12                	mov    (%edx),%dl
  801898:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  80189a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80189d:	8a 00                	mov    (%eax),%al
  80189f:	84 c0                	test   %al,%al
  8018a1:	74 03                	je     8018a6 <strncpy+0x31>
			src++;
  8018a3:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  8018a6:	ff 45 fc             	incl   -0x4(%ebp)
  8018a9:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8018ac:	3b 45 10             	cmp    0x10(%ebp),%eax
  8018af:	72 d9                	jb     80188a <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  8018b1:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  8018b4:	c9                   	leave  
  8018b5:	c3                   	ret    

008018b6 <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  8018b6:	55                   	push   %ebp
  8018b7:	89 e5                	mov    %esp,%ebp
  8018b9:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  8018bc:	8b 45 08             	mov    0x8(%ebp),%eax
  8018bf:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  8018c2:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8018c6:	74 30                	je     8018f8 <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  8018c8:	eb 16                	jmp    8018e0 <strlcpy+0x2a>
			*dst++ = *src++;
  8018ca:	8b 45 08             	mov    0x8(%ebp),%eax
  8018cd:	8d 50 01             	lea    0x1(%eax),%edx
  8018d0:	89 55 08             	mov    %edx,0x8(%ebp)
  8018d3:	8b 55 0c             	mov    0xc(%ebp),%edx
  8018d6:	8d 4a 01             	lea    0x1(%edx),%ecx
  8018d9:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  8018dc:	8a 12                	mov    (%edx),%dl
  8018de:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  8018e0:	ff 4d 10             	decl   0x10(%ebp)
  8018e3:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8018e7:	74 09                	je     8018f2 <strlcpy+0x3c>
  8018e9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8018ec:	8a 00                	mov    (%eax),%al
  8018ee:	84 c0                	test   %al,%al
  8018f0:	75 d8                	jne    8018ca <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  8018f2:	8b 45 08             	mov    0x8(%ebp),%eax
  8018f5:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  8018f8:	8b 55 08             	mov    0x8(%ebp),%edx
  8018fb:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8018fe:	29 c2                	sub    %eax,%edx
  801900:	89 d0                	mov    %edx,%eax
}
  801902:	c9                   	leave  
  801903:	c3                   	ret    

00801904 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  801904:	55                   	push   %ebp
  801905:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  801907:	eb 06                	jmp    80190f <strcmp+0xb>
		p++, q++;
  801909:	ff 45 08             	incl   0x8(%ebp)
  80190c:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  80190f:	8b 45 08             	mov    0x8(%ebp),%eax
  801912:	8a 00                	mov    (%eax),%al
  801914:	84 c0                	test   %al,%al
  801916:	74 0e                	je     801926 <strcmp+0x22>
  801918:	8b 45 08             	mov    0x8(%ebp),%eax
  80191b:	8a 10                	mov    (%eax),%dl
  80191d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801920:	8a 00                	mov    (%eax),%al
  801922:	38 c2                	cmp    %al,%dl
  801924:	74 e3                	je     801909 <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  801926:	8b 45 08             	mov    0x8(%ebp),%eax
  801929:	8a 00                	mov    (%eax),%al
  80192b:	0f b6 d0             	movzbl %al,%edx
  80192e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801931:	8a 00                	mov    (%eax),%al
  801933:	0f b6 c0             	movzbl %al,%eax
  801936:	29 c2                	sub    %eax,%edx
  801938:	89 d0                	mov    %edx,%eax
}
  80193a:	5d                   	pop    %ebp
  80193b:	c3                   	ret    

0080193c <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  80193c:	55                   	push   %ebp
  80193d:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  80193f:	eb 09                	jmp    80194a <strncmp+0xe>
		n--, p++, q++;
  801941:	ff 4d 10             	decl   0x10(%ebp)
  801944:	ff 45 08             	incl   0x8(%ebp)
  801947:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  80194a:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80194e:	74 17                	je     801967 <strncmp+0x2b>
  801950:	8b 45 08             	mov    0x8(%ebp),%eax
  801953:	8a 00                	mov    (%eax),%al
  801955:	84 c0                	test   %al,%al
  801957:	74 0e                	je     801967 <strncmp+0x2b>
  801959:	8b 45 08             	mov    0x8(%ebp),%eax
  80195c:	8a 10                	mov    (%eax),%dl
  80195e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801961:	8a 00                	mov    (%eax),%al
  801963:	38 c2                	cmp    %al,%dl
  801965:	74 da                	je     801941 <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  801967:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80196b:	75 07                	jne    801974 <strncmp+0x38>
		return 0;
  80196d:	b8 00 00 00 00       	mov    $0x0,%eax
  801972:	eb 14                	jmp    801988 <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  801974:	8b 45 08             	mov    0x8(%ebp),%eax
  801977:	8a 00                	mov    (%eax),%al
  801979:	0f b6 d0             	movzbl %al,%edx
  80197c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80197f:	8a 00                	mov    (%eax),%al
  801981:	0f b6 c0             	movzbl %al,%eax
  801984:	29 c2                	sub    %eax,%edx
  801986:	89 d0                	mov    %edx,%eax
}
  801988:	5d                   	pop    %ebp
  801989:	c3                   	ret    

0080198a <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  80198a:	55                   	push   %ebp
  80198b:	89 e5                	mov    %esp,%ebp
  80198d:	83 ec 04             	sub    $0x4,%esp
  801990:	8b 45 0c             	mov    0xc(%ebp),%eax
  801993:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  801996:	eb 12                	jmp    8019aa <strchr+0x20>
		if (*s == c)
  801998:	8b 45 08             	mov    0x8(%ebp),%eax
  80199b:	8a 00                	mov    (%eax),%al
  80199d:	3a 45 fc             	cmp    -0x4(%ebp),%al
  8019a0:	75 05                	jne    8019a7 <strchr+0x1d>
			return (char *) s;
  8019a2:	8b 45 08             	mov    0x8(%ebp),%eax
  8019a5:	eb 11                	jmp    8019b8 <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  8019a7:	ff 45 08             	incl   0x8(%ebp)
  8019aa:	8b 45 08             	mov    0x8(%ebp),%eax
  8019ad:	8a 00                	mov    (%eax),%al
  8019af:	84 c0                	test   %al,%al
  8019b1:	75 e5                	jne    801998 <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  8019b3:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8019b8:	c9                   	leave  
  8019b9:	c3                   	ret    

008019ba <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  8019ba:	55                   	push   %ebp
  8019bb:	89 e5                	mov    %esp,%ebp
  8019bd:	83 ec 04             	sub    $0x4,%esp
  8019c0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8019c3:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  8019c6:	eb 0d                	jmp    8019d5 <strfind+0x1b>
		if (*s == c)
  8019c8:	8b 45 08             	mov    0x8(%ebp),%eax
  8019cb:	8a 00                	mov    (%eax),%al
  8019cd:	3a 45 fc             	cmp    -0x4(%ebp),%al
  8019d0:	74 0e                	je     8019e0 <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  8019d2:	ff 45 08             	incl   0x8(%ebp)
  8019d5:	8b 45 08             	mov    0x8(%ebp),%eax
  8019d8:	8a 00                	mov    (%eax),%al
  8019da:	84 c0                	test   %al,%al
  8019dc:	75 ea                	jne    8019c8 <strfind+0xe>
  8019de:	eb 01                	jmp    8019e1 <strfind+0x27>
		if (*s == c)
			break;
  8019e0:	90                   	nop
	return (char *) s;
  8019e1:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8019e4:	c9                   	leave  
  8019e5:	c3                   	ret    

008019e6 <memset>:


void *
memset(void *v, int c, uint32 n)
{
  8019e6:	55                   	push   %ebp
  8019e7:	89 e5                	mov    %esp,%ebp
  8019e9:	83 ec 10             	sub    $0x10,%esp
	char *p;
	int m;

	p = v;
  8019ec:	8b 45 08             	mov    0x8(%ebp),%eax
  8019ef:	89 45 fc             	mov    %eax,-0x4(%ebp)
	m = n;
  8019f2:	8b 45 10             	mov    0x10(%ebp),%eax
  8019f5:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (--m >= 0)
  8019f8:	eb 0e                	jmp    801a08 <memset+0x22>
		*p++ = c;
  8019fa:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8019fd:	8d 50 01             	lea    0x1(%eax),%edx
  801a00:	89 55 fc             	mov    %edx,-0x4(%ebp)
  801a03:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a06:	88 10                	mov    %dl,(%eax)
	char *p;
	int m;

	p = v;
	m = n;
	while (--m >= 0)
  801a08:	ff 4d f8             	decl   -0x8(%ebp)
  801a0b:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  801a0f:	79 e9                	jns    8019fa <memset+0x14>
		*p++ = c;

	return v;
  801a11:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801a14:	c9                   	leave  
  801a15:	c3                   	ret    

00801a16 <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  801a16:	55                   	push   %ebp
  801a17:	89 e5                	mov    %esp,%ebp
  801a19:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  801a1c:	8b 45 0c             	mov    0xc(%ebp),%eax
  801a1f:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  801a22:	8b 45 08             	mov    0x8(%ebp),%eax
  801a25:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (n-- > 0)
  801a28:	eb 16                	jmp    801a40 <memcpy+0x2a>
		*d++ = *s++;
  801a2a:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801a2d:	8d 50 01             	lea    0x1(%eax),%edx
  801a30:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801a33:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801a36:	8d 4a 01             	lea    0x1(%edx),%ecx
  801a39:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  801a3c:	8a 12                	mov    (%edx),%dl
  801a3e:	88 10                	mov    %dl,(%eax)
	const char *s;
	char *d;

	s = src;
	d = dst;
	while (n-- > 0)
  801a40:	8b 45 10             	mov    0x10(%ebp),%eax
  801a43:	8d 50 ff             	lea    -0x1(%eax),%edx
  801a46:	89 55 10             	mov    %edx,0x10(%ebp)
  801a49:	85 c0                	test   %eax,%eax
  801a4b:	75 dd                	jne    801a2a <memcpy+0x14>
		*d++ = *s++;

	return dst;
  801a4d:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801a50:	c9                   	leave  
  801a51:	c3                   	ret    

00801a52 <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  801a52:	55                   	push   %ebp
  801a53:	89 e5                	mov    %esp,%ebp
  801a55:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  801a58:	8b 45 0c             	mov    0xc(%ebp),%eax
  801a5b:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  801a5e:	8b 45 08             	mov    0x8(%ebp),%eax
  801a61:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  801a64:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801a67:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  801a6a:	73 50                	jae    801abc <memmove+0x6a>
  801a6c:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801a6f:	8b 45 10             	mov    0x10(%ebp),%eax
  801a72:	01 d0                	add    %edx,%eax
  801a74:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  801a77:	76 43                	jbe    801abc <memmove+0x6a>
		s += n;
  801a79:	8b 45 10             	mov    0x10(%ebp),%eax
  801a7c:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  801a7f:	8b 45 10             	mov    0x10(%ebp),%eax
  801a82:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  801a85:	eb 10                	jmp    801a97 <memmove+0x45>
			*--d = *--s;
  801a87:	ff 4d f8             	decl   -0x8(%ebp)
  801a8a:	ff 4d fc             	decl   -0x4(%ebp)
  801a8d:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801a90:	8a 10                	mov    (%eax),%dl
  801a92:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801a95:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  801a97:	8b 45 10             	mov    0x10(%ebp),%eax
  801a9a:	8d 50 ff             	lea    -0x1(%eax),%edx
  801a9d:	89 55 10             	mov    %edx,0x10(%ebp)
  801aa0:	85 c0                	test   %eax,%eax
  801aa2:	75 e3                	jne    801a87 <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  801aa4:	eb 23                	jmp    801ac9 <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  801aa6:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801aa9:	8d 50 01             	lea    0x1(%eax),%edx
  801aac:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801aaf:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801ab2:	8d 4a 01             	lea    0x1(%edx),%ecx
  801ab5:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  801ab8:	8a 12                	mov    (%edx),%dl
  801aba:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  801abc:	8b 45 10             	mov    0x10(%ebp),%eax
  801abf:	8d 50 ff             	lea    -0x1(%eax),%edx
  801ac2:	89 55 10             	mov    %edx,0x10(%ebp)
  801ac5:	85 c0                	test   %eax,%eax
  801ac7:	75 dd                	jne    801aa6 <memmove+0x54>
			*d++ = *s++;

	return dst;
  801ac9:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801acc:	c9                   	leave  
  801acd:	c3                   	ret    

00801ace <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  801ace:	55                   	push   %ebp
  801acf:	89 e5                	mov    %esp,%ebp
  801ad1:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  801ad4:	8b 45 08             	mov    0x8(%ebp),%eax
  801ad7:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  801ada:	8b 45 0c             	mov    0xc(%ebp),%eax
  801add:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  801ae0:	eb 2a                	jmp    801b0c <memcmp+0x3e>
		if (*s1 != *s2)
  801ae2:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801ae5:	8a 10                	mov    (%eax),%dl
  801ae7:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801aea:	8a 00                	mov    (%eax),%al
  801aec:	38 c2                	cmp    %al,%dl
  801aee:	74 16                	je     801b06 <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  801af0:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801af3:	8a 00                	mov    (%eax),%al
  801af5:	0f b6 d0             	movzbl %al,%edx
  801af8:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801afb:	8a 00                	mov    (%eax),%al
  801afd:	0f b6 c0             	movzbl %al,%eax
  801b00:	29 c2                	sub    %eax,%edx
  801b02:	89 d0                	mov    %edx,%eax
  801b04:	eb 18                	jmp    801b1e <memcmp+0x50>
		s1++, s2++;
  801b06:	ff 45 fc             	incl   -0x4(%ebp)
  801b09:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  801b0c:	8b 45 10             	mov    0x10(%ebp),%eax
  801b0f:	8d 50 ff             	lea    -0x1(%eax),%edx
  801b12:	89 55 10             	mov    %edx,0x10(%ebp)
  801b15:	85 c0                	test   %eax,%eax
  801b17:	75 c9                	jne    801ae2 <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  801b19:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801b1e:	c9                   	leave  
  801b1f:	c3                   	ret    

00801b20 <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  801b20:	55                   	push   %ebp
  801b21:	89 e5                	mov    %esp,%ebp
  801b23:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  801b26:	8b 55 08             	mov    0x8(%ebp),%edx
  801b29:	8b 45 10             	mov    0x10(%ebp),%eax
  801b2c:	01 d0                	add    %edx,%eax
  801b2e:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  801b31:	eb 15                	jmp    801b48 <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  801b33:	8b 45 08             	mov    0x8(%ebp),%eax
  801b36:	8a 00                	mov    (%eax),%al
  801b38:	0f b6 d0             	movzbl %al,%edx
  801b3b:	8b 45 0c             	mov    0xc(%ebp),%eax
  801b3e:	0f b6 c0             	movzbl %al,%eax
  801b41:	39 c2                	cmp    %eax,%edx
  801b43:	74 0d                	je     801b52 <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  801b45:	ff 45 08             	incl   0x8(%ebp)
  801b48:	8b 45 08             	mov    0x8(%ebp),%eax
  801b4b:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  801b4e:	72 e3                	jb     801b33 <memfind+0x13>
  801b50:	eb 01                	jmp    801b53 <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  801b52:	90                   	nop
	return (void *) s;
  801b53:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801b56:	c9                   	leave  
  801b57:	c3                   	ret    

00801b58 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  801b58:	55                   	push   %ebp
  801b59:	89 e5                	mov    %esp,%ebp
  801b5b:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  801b5e:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  801b65:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801b6c:	eb 03                	jmp    801b71 <strtol+0x19>
		s++;
  801b6e:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801b71:	8b 45 08             	mov    0x8(%ebp),%eax
  801b74:	8a 00                	mov    (%eax),%al
  801b76:	3c 20                	cmp    $0x20,%al
  801b78:	74 f4                	je     801b6e <strtol+0x16>
  801b7a:	8b 45 08             	mov    0x8(%ebp),%eax
  801b7d:	8a 00                	mov    (%eax),%al
  801b7f:	3c 09                	cmp    $0x9,%al
  801b81:	74 eb                	je     801b6e <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  801b83:	8b 45 08             	mov    0x8(%ebp),%eax
  801b86:	8a 00                	mov    (%eax),%al
  801b88:	3c 2b                	cmp    $0x2b,%al
  801b8a:	75 05                	jne    801b91 <strtol+0x39>
		s++;
  801b8c:	ff 45 08             	incl   0x8(%ebp)
  801b8f:	eb 13                	jmp    801ba4 <strtol+0x4c>
	else if (*s == '-')
  801b91:	8b 45 08             	mov    0x8(%ebp),%eax
  801b94:	8a 00                	mov    (%eax),%al
  801b96:	3c 2d                	cmp    $0x2d,%al
  801b98:	75 0a                	jne    801ba4 <strtol+0x4c>
		s++, neg = 1;
  801b9a:	ff 45 08             	incl   0x8(%ebp)
  801b9d:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  801ba4:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801ba8:	74 06                	je     801bb0 <strtol+0x58>
  801baa:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  801bae:	75 20                	jne    801bd0 <strtol+0x78>
  801bb0:	8b 45 08             	mov    0x8(%ebp),%eax
  801bb3:	8a 00                	mov    (%eax),%al
  801bb5:	3c 30                	cmp    $0x30,%al
  801bb7:	75 17                	jne    801bd0 <strtol+0x78>
  801bb9:	8b 45 08             	mov    0x8(%ebp),%eax
  801bbc:	40                   	inc    %eax
  801bbd:	8a 00                	mov    (%eax),%al
  801bbf:	3c 78                	cmp    $0x78,%al
  801bc1:	75 0d                	jne    801bd0 <strtol+0x78>
		s += 2, base = 16;
  801bc3:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  801bc7:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  801bce:	eb 28                	jmp    801bf8 <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  801bd0:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801bd4:	75 15                	jne    801beb <strtol+0x93>
  801bd6:	8b 45 08             	mov    0x8(%ebp),%eax
  801bd9:	8a 00                	mov    (%eax),%al
  801bdb:	3c 30                	cmp    $0x30,%al
  801bdd:	75 0c                	jne    801beb <strtol+0x93>
		s++, base = 8;
  801bdf:	ff 45 08             	incl   0x8(%ebp)
  801be2:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  801be9:	eb 0d                	jmp    801bf8 <strtol+0xa0>
	else if (base == 0)
  801beb:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801bef:	75 07                	jne    801bf8 <strtol+0xa0>
		base = 10;
  801bf1:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  801bf8:	8b 45 08             	mov    0x8(%ebp),%eax
  801bfb:	8a 00                	mov    (%eax),%al
  801bfd:	3c 2f                	cmp    $0x2f,%al
  801bff:	7e 19                	jle    801c1a <strtol+0xc2>
  801c01:	8b 45 08             	mov    0x8(%ebp),%eax
  801c04:	8a 00                	mov    (%eax),%al
  801c06:	3c 39                	cmp    $0x39,%al
  801c08:	7f 10                	jg     801c1a <strtol+0xc2>
			dig = *s - '0';
  801c0a:	8b 45 08             	mov    0x8(%ebp),%eax
  801c0d:	8a 00                	mov    (%eax),%al
  801c0f:	0f be c0             	movsbl %al,%eax
  801c12:	83 e8 30             	sub    $0x30,%eax
  801c15:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801c18:	eb 42                	jmp    801c5c <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  801c1a:	8b 45 08             	mov    0x8(%ebp),%eax
  801c1d:	8a 00                	mov    (%eax),%al
  801c1f:	3c 60                	cmp    $0x60,%al
  801c21:	7e 19                	jle    801c3c <strtol+0xe4>
  801c23:	8b 45 08             	mov    0x8(%ebp),%eax
  801c26:	8a 00                	mov    (%eax),%al
  801c28:	3c 7a                	cmp    $0x7a,%al
  801c2a:	7f 10                	jg     801c3c <strtol+0xe4>
			dig = *s - 'a' + 10;
  801c2c:	8b 45 08             	mov    0x8(%ebp),%eax
  801c2f:	8a 00                	mov    (%eax),%al
  801c31:	0f be c0             	movsbl %al,%eax
  801c34:	83 e8 57             	sub    $0x57,%eax
  801c37:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801c3a:	eb 20                	jmp    801c5c <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  801c3c:	8b 45 08             	mov    0x8(%ebp),%eax
  801c3f:	8a 00                	mov    (%eax),%al
  801c41:	3c 40                	cmp    $0x40,%al
  801c43:	7e 39                	jle    801c7e <strtol+0x126>
  801c45:	8b 45 08             	mov    0x8(%ebp),%eax
  801c48:	8a 00                	mov    (%eax),%al
  801c4a:	3c 5a                	cmp    $0x5a,%al
  801c4c:	7f 30                	jg     801c7e <strtol+0x126>
			dig = *s - 'A' + 10;
  801c4e:	8b 45 08             	mov    0x8(%ebp),%eax
  801c51:	8a 00                	mov    (%eax),%al
  801c53:	0f be c0             	movsbl %al,%eax
  801c56:	83 e8 37             	sub    $0x37,%eax
  801c59:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  801c5c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801c5f:	3b 45 10             	cmp    0x10(%ebp),%eax
  801c62:	7d 19                	jge    801c7d <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  801c64:	ff 45 08             	incl   0x8(%ebp)
  801c67:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801c6a:	0f af 45 10          	imul   0x10(%ebp),%eax
  801c6e:	89 c2                	mov    %eax,%edx
  801c70:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801c73:	01 d0                	add    %edx,%eax
  801c75:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  801c78:	e9 7b ff ff ff       	jmp    801bf8 <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  801c7d:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  801c7e:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801c82:	74 08                	je     801c8c <strtol+0x134>
		*endptr = (char *) s;
  801c84:	8b 45 0c             	mov    0xc(%ebp),%eax
  801c87:	8b 55 08             	mov    0x8(%ebp),%edx
  801c8a:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  801c8c:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801c90:	74 07                	je     801c99 <strtol+0x141>
  801c92:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801c95:	f7 d8                	neg    %eax
  801c97:	eb 03                	jmp    801c9c <strtol+0x144>
  801c99:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  801c9c:	c9                   	leave  
  801c9d:	c3                   	ret    

00801c9e <ltostr>:

void
ltostr(long value, char *str)
{
  801c9e:	55                   	push   %ebp
  801c9f:	89 e5                	mov    %esp,%ebp
  801ca1:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  801ca4:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  801cab:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  801cb2:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801cb6:	79 13                	jns    801ccb <ltostr+0x2d>
	{
		neg = 1;
  801cb8:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  801cbf:	8b 45 0c             	mov    0xc(%ebp),%eax
  801cc2:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  801cc5:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  801cc8:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  801ccb:	8b 45 08             	mov    0x8(%ebp),%eax
  801cce:	b9 0a 00 00 00       	mov    $0xa,%ecx
  801cd3:	99                   	cltd   
  801cd4:	f7 f9                	idiv   %ecx
  801cd6:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  801cd9:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801cdc:	8d 50 01             	lea    0x1(%eax),%edx
  801cdf:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801ce2:	89 c2                	mov    %eax,%edx
  801ce4:	8b 45 0c             	mov    0xc(%ebp),%eax
  801ce7:	01 d0                	add    %edx,%eax
  801ce9:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801cec:	83 c2 30             	add    $0x30,%edx
  801cef:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  801cf1:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801cf4:	b8 67 66 66 66       	mov    $0x66666667,%eax
  801cf9:	f7 e9                	imul   %ecx
  801cfb:	c1 fa 02             	sar    $0x2,%edx
  801cfe:	89 c8                	mov    %ecx,%eax
  801d00:	c1 f8 1f             	sar    $0x1f,%eax
  801d03:	29 c2                	sub    %eax,%edx
  801d05:	89 d0                	mov    %edx,%eax
  801d07:	89 45 08             	mov    %eax,0x8(%ebp)
	} while (value % 10 != 0);
  801d0a:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801d0d:	b8 67 66 66 66       	mov    $0x66666667,%eax
  801d12:	f7 e9                	imul   %ecx
  801d14:	c1 fa 02             	sar    $0x2,%edx
  801d17:	89 c8                	mov    %ecx,%eax
  801d19:	c1 f8 1f             	sar    $0x1f,%eax
  801d1c:	29 c2                	sub    %eax,%edx
  801d1e:	89 d0                	mov    %edx,%eax
  801d20:	c1 e0 02             	shl    $0x2,%eax
  801d23:	01 d0                	add    %edx,%eax
  801d25:	01 c0                	add    %eax,%eax
  801d27:	29 c1                	sub    %eax,%ecx
  801d29:	89 ca                	mov    %ecx,%edx
  801d2b:	85 d2                	test   %edx,%edx
  801d2d:	75 9c                	jne    801ccb <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  801d2f:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  801d36:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801d39:	48                   	dec    %eax
  801d3a:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  801d3d:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801d41:	74 3d                	je     801d80 <ltostr+0xe2>
		start = 1 ;
  801d43:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  801d4a:	eb 34                	jmp    801d80 <ltostr+0xe2>
	{
		char tmp = str[start] ;
  801d4c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801d4f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801d52:	01 d0                	add    %edx,%eax
  801d54:	8a 00                	mov    (%eax),%al
  801d56:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  801d59:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801d5c:	8b 45 0c             	mov    0xc(%ebp),%eax
  801d5f:	01 c2                	add    %eax,%edx
  801d61:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  801d64:	8b 45 0c             	mov    0xc(%ebp),%eax
  801d67:	01 c8                	add    %ecx,%eax
  801d69:	8a 00                	mov    (%eax),%al
  801d6b:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  801d6d:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801d70:	8b 45 0c             	mov    0xc(%ebp),%eax
  801d73:	01 c2                	add    %eax,%edx
  801d75:	8a 45 eb             	mov    -0x15(%ebp),%al
  801d78:	88 02                	mov    %al,(%edx)
		start++ ;
  801d7a:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  801d7d:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  801d80:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801d83:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801d86:	7c c4                	jl     801d4c <ltostr+0xae>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  801d88:	8b 55 f8             	mov    -0x8(%ebp),%edx
  801d8b:	8b 45 0c             	mov    0xc(%ebp),%eax
  801d8e:	01 d0                	add    %edx,%eax
  801d90:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  801d93:	90                   	nop
  801d94:	c9                   	leave  
  801d95:	c3                   	ret    

00801d96 <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  801d96:	55                   	push   %ebp
  801d97:	89 e5                	mov    %esp,%ebp
  801d99:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  801d9c:	ff 75 08             	pushl  0x8(%ebp)
  801d9f:	e8 54 fa ff ff       	call   8017f8 <strlen>
  801da4:	83 c4 04             	add    $0x4,%esp
  801da7:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  801daa:	ff 75 0c             	pushl  0xc(%ebp)
  801dad:	e8 46 fa ff ff       	call   8017f8 <strlen>
  801db2:	83 c4 04             	add    $0x4,%esp
  801db5:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  801db8:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  801dbf:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801dc6:	eb 17                	jmp    801ddf <strcconcat+0x49>
		final[s] = str1[s] ;
  801dc8:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801dcb:	8b 45 10             	mov    0x10(%ebp),%eax
  801dce:	01 c2                	add    %eax,%edx
  801dd0:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  801dd3:	8b 45 08             	mov    0x8(%ebp),%eax
  801dd6:	01 c8                	add    %ecx,%eax
  801dd8:	8a 00                	mov    (%eax),%al
  801dda:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  801ddc:	ff 45 fc             	incl   -0x4(%ebp)
  801ddf:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801de2:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  801de5:	7c e1                	jl     801dc8 <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  801de7:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  801dee:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  801df5:	eb 1f                	jmp    801e16 <strcconcat+0x80>
		final[s++] = str2[i] ;
  801df7:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801dfa:	8d 50 01             	lea    0x1(%eax),%edx
  801dfd:	89 55 fc             	mov    %edx,-0x4(%ebp)
  801e00:	89 c2                	mov    %eax,%edx
  801e02:	8b 45 10             	mov    0x10(%ebp),%eax
  801e05:	01 c2                	add    %eax,%edx
  801e07:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  801e0a:	8b 45 0c             	mov    0xc(%ebp),%eax
  801e0d:	01 c8                	add    %ecx,%eax
  801e0f:	8a 00                	mov    (%eax),%al
  801e11:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  801e13:	ff 45 f8             	incl   -0x8(%ebp)
  801e16:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801e19:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801e1c:	7c d9                	jl     801df7 <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  801e1e:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801e21:	8b 45 10             	mov    0x10(%ebp),%eax
  801e24:	01 d0                	add    %edx,%eax
  801e26:	c6 00 00             	movb   $0x0,(%eax)
}
  801e29:	90                   	nop
  801e2a:	c9                   	leave  
  801e2b:	c3                   	ret    

00801e2c <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  801e2c:	55                   	push   %ebp
  801e2d:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  801e2f:	8b 45 14             	mov    0x14(%ebp),%eax
  801e32:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  801e38:	8b 45 14             	mov    0x14(%ebp),%eax
  801e3b:	8b 00                	mov    (%eax),%eax
  801e3d:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801e44:	8b 45 10             	mov    0x10(%ebp),%eax
  801e47:	01 d0                	add    %edx,%eax
  801e49:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801e4f:	eb 0c                	jmp    801e5d <strsplit+0x31>
			*string++ = 0;
  801e51:	8b 45 08             	mov    0x8(%ebp),%eax
  801e54:	8d 50 01             	lea    0x1(%eax),%edx
  801e57:	89 55 08             	mov    %edx,0x8(%ebp)
  801e5a:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801e5d:	8b 45 08             	mov    0x8(%ebp),%eax
  801e60:	8a 00                	mov    (%eax),%al
  801e62:	84 c0                	test   %al,%al
  801e64:	74 18                	je     801e7e <strsplit+0x52>
  801e66:	8b 45 08             	mov    0x8(%ebp),%eax
  801e69:	8a 00                	mov    (%eax),%al
  801e6b:	0f be c0             	movsbl %al,%eax
  801e6e:	50                   	push   %eax
  801e6f:	ff 75 0c             	pushl  0xc(%ebp)
  801e72:	e8 13 fb ff ff       	call   80198a <strchr>
  801e77:	83 c4 08             	add    $0x8,%esp
  801e7a:	85 c0                	test   %eax,%eax
  801e7c:	75 d3                	jne    801e51 <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  801e7e:	8b 45 08             	mov    0x8(%ebp),%eax
  801e81:	8a 00                	mov    (%eax),%al
  801e83:	84 c0                	test   %al,%al
  801e85:	74 5a                	je     801ee1 <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  801e87:	8b 45 14             	mov    0x14(%ebp),%eax
  801e8a:	8b 00                	mov    (%eax),%eax
  801e8c:	83 f8 0f             	cmp    $0xf,%eax
  801e8f:	75 07                	jne    801e98 <strsplit+0x6c>
		{
			return 0;
  801e91:	b8 00 00 00 00       	mov    $0x0,%eax
  801e96:	eb 66                	jmp    801efe <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  801e98:	8b 45 14             	mov    0x14(%ebp),%eax
  801e9b:	8b 00                	mov    (%eax),%eax
  801e9d:	8d 48 01             	lea    0x1(%eax),%ecx
  801ea0:	8b 55 14             	mov    0x14(%ebp),%edx
  801ea3:	89 0a                	mov    %ecx,(%edx)
  801ea5:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801eac:	8b 45 10             	mov    0x10(%ebp),%eax
  801eaf:	01 c2                	add    %eax,%edx
  801eb1:	8b 45 08             	mov    0x8(%ebp),%eax
  801eb4:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  801eb6:	eb 03                	jmp    801ebb <strsplit+0x8f>
			string++;
  801eb8:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  801ebb:	8b 45 08             	mov    0x8(%ebp),%eax
  801ebe:	8a 00                	mov    (%eax),%al
  801ec0:	84 c0                	test   %al,%al
  801ec2:	74 8b                	je     801e4f <strsplit+0x23>
  801ec4:	8b 45 08             	mov    0x8(%ebp),%eax
  801ec7:	8a 00                	mov    (%eax),%al
  801ec9:	0f be c0             	movsbl %al,%eax
  801ecc:	50                   	push   %eax
  801ecd:	ff 75 0c             	pushl  0xc(%ebp)
  801ed0:	e8 b5 fa ff ff       	call   80198a <strchr>
  801ed5:	83 c4 08             	add    $0x8,%esp
  801ed8:	85 c0                	test   %eax,%eax
  801eda:	74 dc                	je     801eb8 <strsplit+0x8c>
			string++;
	}
  801edc:	e9 6e ff ff ff       	jmp    801e4f <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  801ee1:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  801ee2:	8b 45 14             	mov    0x14(%ebp),%eax
  801ee5:	8b 00                	mov    (%eax),%eax
  801ee7:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801eee:	8b 45 10             	mov    0x10(%ebp),%eax
  801ef1:	01 d0                	add    %edx,%eax
  801ef3:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  801ef9:	b8 01 00 00 00       	mov    $0x1,%eax
}
  801efe:	c9                   	leave  
  801eff:	c3                   	ret    

00801f00 <InitializeUHeap>:
//============================== GIVEN FUNCTIONS ===================================//
//==================================================================================//

int FirstTimeFlag = 1;
void InitializeUHeap()
{
  801f00:	55                   	push   %ebp
  801f01:	89 e5                	mov    %esp,%ebp
  801f03:	83 ec 08             	sub    $0x8,%esp
	if(FirstTimeFlag)
  801f06:	a1 04 50 80 00       	mov    0x805004,%eax
  801f0b:	85 c0                	test   %eax,%eax
  801f0d:	74 1f                	je     801f2e <InitializeUHeap+0x2e>
	{
		initialize_dyn_block_system();
  801f0f:	e8 1d 00 00 00       	call   801f31 <initialize_dyn_block_system>
		cprintf("DYNAMIC BLOCK SYSTEM IS INITIALIZED\n");
  801f14:	83 ec 0c             	sub    $0xc,%esp
  801f17:	68 b0 44 80 00       	push   $0x8044b0
  801f1c:	e8 55 f2 ff ff       	call   801176 <cprintf>
  801f21:	83 c4 10             	add    $0x10,%esp
#if UHP_USE_BUDDY
		initialize_buddy();
		cprintf("BUDDY SYSTEM IS INITIALIZED\n");
#endif
		FirstTimeFlag = 0;
  801f24:	c7 05 04 50 80 00 00 	movl   $0x0,0x805004
  801f2b:	00 00 00 
	}
}
  801f2e:	90                   	nop
  801f2f:	c9                   	leave  
  801f30:	c3                   	ret    

00801f31 <initialize_dyn_block_system>:

//=================================
// [1] INITIALIZE DYNAMIC ALLOCATOR:
//=================================
void initialize_dyn_block_system()
{
  801f31:	55                   	push   %ebp
  801f32:	89 e5                	mov    %esp,%ebp
  801f34:	83 ec 28             	sub    $0x28,%esp
	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] initialize_dyn_block_system
	// your code is here, remove the panic and write your code
	//panic("initialize_dyn_block_system() is not implemented yet...!!");

	LIST_INIT(&AllocMemBlocksList);
  801f37:	c7 05 40 50 80 00 00 	movl   $0x0,0x805040
  801f3e:	00 00 00 
  801f41:	c7 05 44 50 80 00 00 	movl   $0x0,0x805044
  801f48:	00 00 00 
  801f4b:	c7 05 4c 50 80 00 00 	movl   $0x0,0x80504c
  801f52:	00 00 00 
	LIST_INIT(&FreeMemBlocksList);
  801f55:	c7 05 38 51 80 00 00 	movl   $0x0,0x805138
  801f5c:	00 00 00 
  801f5f:	c7 05 3c 51 80 00 00 	movl   $0x0,0x80513c
  801f66:	00 00 00 
  801f69:	c7 05 44 51 80 00 00 	movl   $0x0,0x805144
  801f70:	00 00 00 
	MAX_MEM_BLOCK_CNT = NUM_OF_UHEAP_PAGES;
  801f73:	c7 05 20 51 80 00 00 	movl   $0x20000,0x805120
  801f7a:	00 02 00 
	MemBlockNodes = (void*)USER_DYN_BLKS_ARRAY;
  801f7d:	c7 45 f4 00 00 e0 7f 	movl   $0x7fe00000,-0xc(%ebp)
  801f84:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f87:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801f8c:	2d 00 10 00 00       	sub    $0x1000,%eax
  801f91:	a3 50 50 80 00       	mov    %eax,0x805050
	int size_of_block = sizeof(struct MemBlock);
  801f96:	c7 45 f0 10 00 00 00 	movl   $0x10,-0x10(%ebp)
	int size_all_struct = size_of_block*MAX_MEM_BLOCK_CNT;
  801f9d:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801fa0:	a1 20 51 80 00       	mov    0x805120,%eax
  801fa5:	0f af c2             	imul   %edx,%eax
  801fa8:	89 45 ec             	mov    %eax,-0x14(%ebp)
	size_all_struct = ROUNDUP(size_all_struct, PAGE_SIZE);
  801fab:	c7 45 e8 00 10 00 00 	movl   $0x1000,-0x18(%ebp)
  801fb2:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801fb5:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801fb8:	01 d0                	add    %edx,%eax
  801fba:	48                   	dec    %eax
  801fbb:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  801fbe:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801fc1:	ba 00 00 00 00       	mov    $0x0,%edx
  801fc6:	f7 75 e8             	divl   -0x18(%ebp)
  801fc9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801fcc:	29 d0                	sub    %edx,%eax
  801fce:	89 45 ec             	mov    %eax,-0x14(%ebp)
	sys_allocate_chunk(USER_DYN_BLKS_ARRAY, size_all_struct,PERM_USER| PERM_WRITEABLE);
  801fd1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801fd4:	c7 45 e0 00 00 e0 7f 	movl   $0x7fe00000,-0x20(%ebp)
  801fdb:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801fde:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
  801fe4:	81 ea 00 10 00 00    	sub    $0x1000,%edx
  801fea:	83 ec 04             	sub    $0x4,%esp
  801fed:	6a 06                	push   $0x6
  801fef:	50                   	push   %eax
  801ff0:	52                   	push   %edx
  801ff1:	e8 a1 05 00 00       	call   802597 <sys_allocate_chunk>
  801ff6:	83 c4 10             	add    $0x10,%esp
	initialize_MemBlocksList(MAX_MEM_BLOCK_CNT);
  801ff9:	a1 20 51 80 00       	mov    0x805120,%eax
  801ffe:	83 ec 0c             	sub    $0xc,%esp
  802001:	50                   	push   %eax
  802002:	e8 16 0c 00 00       	call   802c1d <initialize_MemBlocksList>
  802007:	83 c4 10             	add    $0x10,%esp
	struct MemBlock* ourBlock =LIST_LAST(&AvailableMemBlocksList);
  80200a:	a1 4c 51 80 00       	mov    0x80514c,%eax
  80200f:	89 45 dc             	mov    %eax,-0x24(%ebp)
	LIST_REMOVE(&AvailableMemBlocksList,ourBlock);
  802012:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  802016:	75 14                	jne    80202c <initialize_dyn_block_system+0xfb>
  802018:	83 ec 04             	sub    $0x4,%esp
  80201b:	68 d5 44 80 00       	push   $0x8044d5
  802020:	6a 2d                	push   $0x2d
  802022:	68 f3 44 80 00       	push   $0x8044f3
  802027:	e8 96 ee ff ff       	call   800ec2 <_panic>
  80202c:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80202f:	8b 00                	mov    (%eax),%eax
  802031:	85 c0                	test   %eax,%eax
  802033:	74 10                	je     802045 <initialize_dyn_block_system+0x114>
  802035:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802038:	8b 00                	mov    (%eax),%eax
  80203a:	8b 55 dc             	mov    -0x24(%ebp),%edx
  80203d:	8b 52 04             	mov    0x4(%edx),%edx
  802040:	89 50 04             	mov    %edx,0x4(%eax)
  802043:	eb 0b                	jmp    802050 <initialize_dyn_block_system+0x11f>
  802045:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802048:	8b 40 04             	mov    0x4(%eax),%eax
  80204b:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802050:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802053:	8b 40 04             	mov    0x4(%eax),%eax
  802056:	85 c0                	test   %eax,%eax
  802058:	74 0f                	je     802069 <initialize_dyn_block_system+0x138>
  80205a:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80205d:	8b 40 04             	mov    0x4(%eax),%eax
  802060:	8b 55 dc             	mov    -0x24(%ebp),%edx
  802063:	8b 12                	mov    (%edx),%edx
  802065:	89 10                	mov    %edx,(%eax)
  802067:	eb 0a                	jmp    802073 <initialize_dyn_block_system+0x142>
  802069:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80206c:	8b 00                	mov    (%eax),%eax
  80206e:	a3 48 51 80 00       	mov    %eax,0x805148
  802073:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802076:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80207c:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80207f:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802086:	a1 54 51 80 00       	mov    0x805154,%eax
  80208b:	48                   	dec    %eax
  80208c:	a3 54 51 80 00       	mov    %eax,0x805154
	ourBlock->size = USER_HEAP_MAX-USER_HEAP_START;
  802091:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802094:	c7 40 0c 00 00 00 20 	movl   $0x20000000,0xc(%eax)
	ourBlock->sva=USER_HEAP_START;
  80209b:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80209e:	c7 40 08 00 00 00 80 	movl   $0x80000000,0x8(%eax)
	LIST_INSERT_TAIL(&FreeMemBlocksList, ourBlock);
  8020a5:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  8020a9:	75 14                	jne    8020bf <initialize_dyn_block_system+0x18e>
  8020ab:	83 ec 04             	sub    $0x4,%esp
  8020ae:	68 00 45 80 00       	push   $0x804500
  8020b3:	6a 30                	push   $0x30
  8020b5:	68 f3 44 80 00       	push   $0x8044f3
  8020ba:	e8 03 ee ff ff       	call   800ec2 <_panic>
  8020bf:	8b 15 3c 51 80 00    	mov    0x80513c,%edx
  8020c5:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8020c8:	89 50 04             	mov    %edx,0x4(%eax)
  8020cb:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8020ce:	8b 40 04             	mov    0x4(%eax),%eax
  8020d1:	85 c0                	test   %eax,%eax
  8020d3:	74 0c                	je     8020e1 <initialize_dyn_block_system+0x1b0>
  8020d5:	a1 3c 51 80 00       	mov    0x80513c,%eax
  8020da:	8b 55 dc             	mov    -0x24(%ebp),%edx
  8020dd:	89 10                	mov    %edx,(%eax)
  8020df:	eb 08                	jmp    8020e9 <initialize_dyn_block_system+0x1b8>
  8020e1:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8020e4:	a3 38 51 80 00       	mov    %eax,0x805138
  8020e9:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8020ec:	a3 3c 51 80 00       	mov    %eax,0x80513c
  8020f1:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8020f4:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8020fa:	a1 44 51 80 00       	mov    0x805144,%eax
  8020ff:	40                   	inc    %eax
  802100:	a3 44 51 80 00       	mov    %eax,0x805144
	//[1] Initialize two lists (AllocMemBlocksList & FreeMemBlocksList) [Hint: use LIST_INIT()]
	//[2] Dynamically allocate the array of MemBlockNodes at VA USER_DYN_BLKS_ARRAY
	//	  (remember to set MAX_MEM_BLOCK_CNT with the chosen size of the array)
	//[3] Initialize AvailableMemBlocksList by filling it with the MemBlockNodes
	//[4] Insert a new MemBlock with the heap size into the FreeMemBlocksList
}
  802105:	90                   	nop
  802106:	c9                   	leave  
  802107:	c3                   	ret    

00802108 <malloc>:
//=================================
// [2] ALLOCATE SPACE IN USER HEAP:
//=================================

void* malloc(uint32 size)
{
  802108:	55                   	push   %ebp
  802109:	89 e5                	mov    %esp,%ebp
  80210b:	83 ec 18             	sub    $0x18,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  80210e:	e8 ed fd ff ff       	call   801f00 <InitializeUHeap>
	if (size == 0) return NULL ;
  802113:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802117:	75 07                	jne    802120 <malloc+0x18>
  802119:	b8 00 00 00 00       	mov    $0x0,%eax
  80211e:	eb 67                	jmp    802187 <malloc+0x7f>

	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] malloc
	// your code is here, remove the panic and write your code
	//panic("malloc() is not implemented yet...!!");

	size = ROUNDUP(size, PAGE_SIZE);
  802120:	c7 45 f4 00 10 00 00 	movl   $0x1000,-0xc(%ebp)
  802127:	8b 55 08             	mov    0x8(%ebp),%edx
  80212a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80212d:	01 d0                	add    %edx,%eax
  80212f:	48                   	dec    %eax
  802130:	89 45 f0             	mov    %eax,-0x10(%ebp)
  802133:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802136:	ba 00 00 00 00       	mov    $0x0,%edx
  80213b:	f7 75 f4             	divl   -0xc(%ebp)
  80213e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802141:	29 d0                	sub    %edx,%eax
  802143:	89 45 08             	mov    %eax,0x8(%ebp)
	if(sys_isUHeapPlacementStrategyFIRSTFIT())
  802146:	e8 1a 08 00 00       	call   802965 <sys_isUHeapPlacementStrategyFIRSTFIT>
  80214b:	85 c0                	test   %eax,%eax
  80214d:	74 33                	je     802182 <malloc+0x7a>
	{
		struct MemBlock * myBlock = alloc_block_FF(size);
  80214f:	83 ec 0c             	sub    $0xc,%esp
  802152:	ff 75 08             	pushl  0x8(%ebp)
  802155:	e8 0c 0e 00 00       	call   802f66 <alloc_block_FF>
  80215a:	83 c4 10             	add    $0x10,%esp
  80215d:	89 45 ec             	mov    %eax,-0x14(%ebp)
		if(myBlock != NULL)
  802160:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802164:	74 1c                	je     802182 <malloc+0x7a>
		{
			insert_sorted_allocList(myBlock);
  802166:	83 ec 0c             	sub    $0xc,%esp
  802169:	ff 75 ec             	pushl  -0x14(%ebp)
  80216c:	e8 07 0c 00 00       	call   802d78 <insert_sorted_allocList>
  802171:	83 c4 10             	add    $0x10,%esp
			uint32 ptr = myBlock->sva;
  802174:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802177:	8b 40 08             	mov    0x8(%eax),%eax
  80217a:	89 45 e8             	mov    %eax,-0x18(%ebp)
			return (void *)ptr;
  80217d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802180:	eb 05                	jmp    802187 <malloc+0x7f>
		}
	}
	return NULL;
  802182:	b8 00 00 00 00       	mov    $0x0,%eax
	//		to the required allocation size (space should be on 4 KB BOUNDARY)
	//	2) if no suitable space found, return NULL
	// 	3) Return pointer containing the virtual address of allocated space,
	//
	//Use sys_isUHeapPlacementStrategyFIRSTFIT()... to check the current strategy
}
  802187:	c9                   	leave  
  802188:	c3                   	ret    

00802189 <free>:
//	We can use sys_free_user_mem(uint32 virtual_address, uint32 size); which
//		switches to the kernel mode, calls free_user_mem() in
//		"kern/mem/chunk_operations.c", then switch back to the user mode here
//	the free_user_mem function is empty, make sure to implement it.
void free(void* virtual_address)
{
  802189:	55                   	push   %ebp
  80218a:	89 e5                	mov    %esp,%ebp
  80218c:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] free
	// your code is here, remove the panic and write your code
	//panic("free() is not implemented yet...!!");

	uint32 virtualAddress = (uint32 )(virtual_address);
  80218f:	8b 45 08             	mov    0x8(%ebp),%eax
  802192:	89 45 f4             	mov    %eax,-0xc(%ebp)
//	virtualAddress = ROUNDDOWN(virtualAddress, PAGE_SIZE);
	struct MemBlock * myBlock = find_block(&AllocMemBlocksList, virtualAddress);
  802195:	83 ec 08             	sub    $0x8,%esp
  802198:	ff 75 f4             	pushl  -0xc(%ebp)
  80219b:	68 40 50 80 00       	push   $0x805040
  8021a0:	e8 5b 0b 00 00       	call   802d00 <find_block>
  8021a5:	83 c4 10             	add    $0x10,%esp
  8021a8:	89 45 f0             	mov    %eax,-0x10(%ebp)
//	cprintf ("ptr sva at free user side = %x \n", myBlock->sva);
	sys_free_user_mem(virtualAddress, myBlock->size);
  8021ab:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8021ae:	8b 40 0c             	mov    0xc(%eax),%eax
  8021b1:	83 ec 08             	sub    $0x8,%esp
  8021b4:	50                   	push   %eax
  8021b5:	ff 75 f4             	pushl  -0xc(%ebp)
  8021b8:	e8 a2 03 00 00       	call   80255f <sys_free_user_mem>
  8021bd:	83 c4 10             	add    $0x10,%esp
	LIST_REMOVE(&AllocMemBlocksList, myBlock);
  8021c0:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8021c4:	75 14                	jne    8021da <free+0x51>
  8021c6:	83 ec 04             	sub    $0x4,%esp
  8021c9:	68 d5 44 80 00       	push   $0x8044d5
  8021ce:	6a 76                	push   $0x76
  8021d0:	68 f3 44 80 00       	push   $0x8044f3
  8021d5:	e8 e8 ec ff ff       	call   800ec2 <_panic>
  8021da:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8021dd:	8b 00                	mov    (%eax),%eax
  8021df:	85 c0                	test   %eax,%eax
  8021e1:	74 10                	je     8021f3 <free+0x6a>
  8021e3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8021e6:	8b 00                	mov    (%eax),%eax
  8021e8:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8021eb:	8b 52 04             	mov    0x4(%edx),%edx
  8021ee:	89 50 04             	mov    %edx,0x4(%eax)
  8021f1:	eb 0b                	jmp    8021fe <free+0x75>
  8021f3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8021f6:	8b 40 04             	mov    0x4(%eax),%eax
  8021f9:	a3 44 50 80 00       	mov    %eax,0x805044
  8021fe:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802201:	8b 40 04             	mov    0x4(%eax),%eax
  802204:	85 c0                	test   %eax,%eax
  802206:	74 0f                	je     802217 <free+0x8e>
  802208:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80220b:	8b 40 04             	mov    0x4(%eax),%eax
  80220e:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802211:	8b 12                	mov    (%edx),%edx
  802213:	89 10                	mov    %edx,(%eax)
  802215:	eb 0a                	jmp    802221 <free+0x98>
  802217:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80221a:	8b 00                	mov    (%eax),%eax
  80221c:	a3 40 50 80 00       	mov    %eax,0x805040
  802221:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802224:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80222a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80222d:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802234:	a1 4c 50 80 00       	mov    0x80504c,%eax
  802239:	48                   	dec    %eax
  80223a:	a3 4c 50 80 00       	mov    %eax,0x80504c
	insert_sorted_with_merge_freeList(myBlock);
  80223f:	83 ec 0c             	sub    $0xc,%esp
  802242:	ff 75 f0             	pushl  -0x10(%ebp)
  802245:	e8 0b 14 00 00       	call   803655 <insert_sorted_with_merge_freeList>
  80224a:	83 c4 10             	add    $0x10,%esp

	//you should get the size of the given allocation using its address
	//you need to call sys_free_user_mem()
	//refer to the project presentation and documentation for details
}
  80224d:	90                   	nop
  80224e:	c9                   	leave  
  80224f:	c3                   	ret    

00802250 <smalloc>:

//=================================
// [4] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
  802250:	55                   	push   %ebp
  802251:	89 e5                	mov    %esp,%ebp
  802253:	83 ec 28             	sub    $0x28,%esp
  802256:	8b 45 10             	mov    0x10(%ebp),%eax
  802259:	88 45 e4             	mov    %al,-0x1c(%ebp)
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  80225c:	e8 9f fc ff ff       	call   801f00 <InitializeUHeap>
	if (size == 0) return NULL ;
  802261:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  802265:	75 0a                	jne    802271 <smalloc+0x21>
  802267:	b8 00 00 00 00       	mov    $0x0,%eax
  80226c:	e9 8d 00 00 00       	jmp    8022fe <smalloc+0xae>

	//This function should find the space of the required range
	// * ON 4KB BOUNDARY **** //
	//Use sys_isUHeapPlacementStrategyFIRSTFIT() to check the current strategy

	size = ROUNDUP(size, PAGE_SIZE);
  802271:	c7 45 f4 00 10 00 00 	movl   $0x1000,-0xc(%ebp)
  802278:	8b 55 0c             	mov    0xc(%ebp),%edx
  80227b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80227e:	01 d0                	add    %edx,%eax
  802280:	48                   	dec    %eax
  802281:	89 45 f0             	mov    %eax,-0x10(%ebp)
  802284:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802287:	ba 00 00 00 00       	mov    $0x0,%edx
  80228c:	f7 75 f4             	divl   -0xc(%ebp)
  80228f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802292:	29 d0                	sub    %edx,%eax
  802294:	89 45 0c             	mov    %eax,0xc(%ebp)
		if(sys_isUHeapPlacementStrategyFIRSTFIT())
  802297:	e8 c9 06 00 00       	call   802965 <sys_isUHeapPlacementStrategyFIRSTFIT>
  80229c:	85 c0                	test   %eax,%eax
  80229e:	74 59                	je     8022f9 <smalloc+0xa9>
		{
			struct MemBlock * v1=NULL;
  8022a0:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
			v1= alloc_block_FF(size);
  8022a7:	83 ec 0c             	sub    $0xc,%esp
  8022aa:	ff 75 0c             	pushl  0xc(%ebp)
  8022ad:	e8 b4 0c 00 00       	call   802f66 <alloc_block_FF>
  8022b2:	83 c4 10             	add    $0x10,%esp
  8022b5:	89 45 ec             	mov    %eax,-0x14(%ebp)
			if(v1==NULL)
  8022b8:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8022bc:	75 07                	jne    8022c5 <smalloc+0x75>
			{
				return NULL;
  8022be:	b8 00 00 00 00       	mov    $0x0,%eax
  8022c3:	eb 39                	jmp    8022fe <smalloc+0xae>
			}
			else
			{
				int ret=sys_createSharedObject(sharedVarName,  size,  isWritable,(void*)v1->sva);
  8022c5:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8022c8:	8b 40 08             	mov    0x8(%eax),%eax
  8022cb:	89 c2                	mov    %eax,%edx
  8022cd:	0f b6 45 e4          	movzbl -0x1c(%ebp),%eax
  8022d1:	52                   	push   %edx
  8022d2:	50                   	push   %eax
  8022d3:	ff 75 0c             	pushl  0xc(%ebp)
  8022d6:	ff 75 08             	pushl  0x8(%ebp)
  8022d9:	e8 0c 04 00 00       	call   8026ea <sys_createSharedObject>
  8022de:	83 c4 10             	add    $0x10,%esp
  8022e1:	89 45 e8             	mov    %eax,-0x18(%ebp)
				if(ret>=0)
  8022e4:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8022e8:	78 08                	js     8022f2 <smalloc+0xa2>
				{
					return (void*)v1->sva;
  8022ea:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8022ed:	8b 40 08             	mov    0x8(%eax),%eax
  8022f0:	eb 0c                	jmp    8022fe <smalloc+0xae>
				}
				else
				{
					return NULL;
  8022f2:	b8 00 00 00 00       	mov    $0x0,%eax
  8022f7:	eb 05                	jmp    8022fe <smalloc+0xae>
				}
			}

		}
		return NULL;
  8022f9:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8022fe:	c9                   	leave  
  8022ff:	c3                   	ret    

00802300 <sget>:

//========================================
// [5] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  802300:	55                   	push   %ebp
  802301:	89 e5                	mov    %esp,%ebp
  802303:	83 ec 18             	sub    $0x18,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  802306:	e8 f5 fb ff ff       	call   801f00 <InitializeUHeap>

	//This function should find the space for sharing the variable
	// *** ON 4KB BOUNDARY ******** //

	//Use sys_isUHeapPlacementStrategyFIRSTFIT() to check the current strategy
	int ret=sys_getSizeOfSharedObject(ownerEnvID,sharedVarName);
  80230b:	83 ec 08             	sub    $0x8,%esp
  80230e:	ff 75 0c             	pushl  0xc(%ebp)
  802311:	ff 75 08             	pushl  0x8(%ebp)
  802314:	e8 fb 03 00 00       	call   802714 <sys_getSizeOfSharedObject>
  802319:	83 c4 10             	add    $0x10,%esp
  80231c:	89 45 f4             	mov    %eax,-0xc(%ebp)
	if(ret==0)
  80231f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802323:	75 07                	jne    80232c <sget+0x2c>
	{
		return NULL;
  802325:	b8 00 00 00 00       	mov    $0x0,%eax
  80232a:	eb 64                	jmp    802390 <sget+0x90>
	}
	if(sys_isUHeapPlacementStrategyFIRSTFIT())
  80232c:	e8 34 06 00 00       	call   802965 <sys_isUHeapPlacementStrategyFIRSTFIT>
  802331:	85 c0                	test   %eax,%eax
  802333:	74 56                	je     80238b <sget+0x8b>
	{
		struct MemBlock * v1=NULL;
  802335:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
		v1= alloc_block_FF(ret);
  80233c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80233f:	83 ec 0c             	sub    $0xc,%esp
  802342:	50                   	push   %eax
  802343:	e8 1e 0c 00 00       	call   802f66 <alloc_block_FF>
  802348:	83 c4 10             	add    $0x10,%esp
  80234b:	89 45 f0             	mov    %eax,-0x10(%ebp)
		if(v1==NULL)
  80234e:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802352:	75 07                	jne    80235b <sget+0x5b>
		{
		return NULL;
  802354:	b8 00 00 00 00       	mov    $0x0,%eax
  802359:	eb 35                	jmp    802390 <sget+0x90>
	    }
		else
		{
			int ret1=sys_getSharedObject(ownerEnvID,sharedVarName,(void*)v1->sva);
  80235b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80235e:	8b 40 08             	mov    0x8(%eax),%eax
  802361:	83 ec 04             	sub    $0x4,%esp
  802364:	50                   	push   %eax
  802365:	ff 75 0c             	pushl  0xc(%ebp)
  802368:	ff 75 08             	pushl  0x8(%ebp)
  80236b:	e8 c1 03 00 00       	call   802731 <sys_getSharedObject>
  802370:	83 c4 10             	add    $0x10,%esp
  802373:	89 45 ec             	mov    %eax,-0x14(%ebp)
			if(ret1>=0)
  802376:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  80237a:	78 08                	js     802384 <sget+0x84>
			{
				return (void*)v1->sva;
  80237c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80237f:	8b 40 08             	mov    0x8(%eax),%eax
  802382:	eb 0c                	jmp    802390 <sget+0x90>
			}
			else
			{
				return NULL;
  802384:	b8 00 00 00 00       	mov    $0x0,%eax
  802389:	eb 05                	jmp    802390 <sget+0x90>
			}
		}
	}
  return NULL;
  80238b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802390:	c9                   	leave  
  802391:	c3                   	ret    

00802392 <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  802392:	55                   	push   %ebp
  802393:	89 e5                	mov    %esp,%ebp
  802395:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  802398:	e8 63 fb ff ff       	call   801f00 <InitializeUHeap>
	//==============================================================
	// [USER HEAP - USER SIDE] realloc
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  80239d:	83 ec 04             	sub    $0x4,%esp
  8023a0:	68 24 45 80 00       	push   $0x804524
  8023a5:	68 0e 01 00 00       	push   $0x10e
  8023aa:	68 f3 44 80 00       	push   $0x8044f3
  8023af:	e8 0e eb ff ff       	call   800ec2 <_panic>

008023b4 <sfree>:
//	use sys_freeSharedObject(...); which switches to the kernel mode,
//	calls freeSharedObject(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the freeSharedObject() function is empty, make sure to implement it.

void sfree(void* virtual_address)
{
  8023b4:	55                   	push   %ebp
  8023b5:	89 e5                	mov    %esp,%ebp
  8023b7:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS3 - BONUS] [SHARING - USER SIDE] sfree()

	// Write your code here, remove the panic and write your code
	panic("sfree() is not implemented yet...!!");
  8023ba:	83 ec 04             	sub    $0x4,%esp
  8023bd:	68 4c 45 80 00       	push   $0x80454c
  8023c2:	68 22 01 00 00       	push   $0x122
  8023c7:	68 f3 44 80 00       	push   $0x8044f3
  8023cc:	e8 f1 ea ff ff       	call   800ec2 <_panic>

008023d1 <expand>:

//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//
void expand(uint32 newSize)
{
  8023d1:	55                   	push   %ebp
  8023d2:	89 e5                	mov    %esp,%ebp
  8023d4:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  8023d7:	83 ec 04             	sub    $0x4,%esp
  8023da:	68 70 45 80 00       	push   $0x804570
  8023df:	68 2d 01 00 00       	push   $0x12d
  8023e4:	68 f3 44 80 00       	push   $0x8044f3
  8023e9:	e8 d4 ea ff ff       	call   800ec2 <_panic>

008023ee <shrink>:

}
void shrink(uint32 newSize)
{
  8023ee:	55                   	push   %ebp
  8023ef:	89 e5                	mov    %esp,%ebp
  8023f1:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  8023f4:	83 ec 04             	sub    $0x4,%esp
  8023f7:	68 70 45 80 00       	push   $0x804570
  8023fc:	68 32 01 00 00       	push   $0x132
  802401:	68 f3 44 80 00       	push   $0x8044f3
  802406:	e8 b7 ea ff ff       	call   800ec2 <_panic>

0080240b <freeHeap>:

}
void freeHeap(void* virtual_address)
{
  80240b:	55                   	push   %ebp
  80240c:	89 e5                	mov    %esp,%ebp
  80240e:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  802411:	83 ec 04             	sub    $0x4,%esp
  802414:	68 70 45 80 00       	push   $0x804570
  802419:	68 37 01 00 00       	push   $0x137
  80241e:	68 f3 44 80 00       	push   $0x8044f3
  802423:	e8 9a ea ff ff       	call   800ec2 <_panic>

00802428 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  802428:	55                   	push   %ebp
  802429:	89 e5                	mov    %esp,%ebp
  80242b:	57                   	push   %edi
  80242c:	56                   	push   %esi
  80242d:	53                   	push   %ebx
  80242e:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  802431:	8b 45 08             	mov    0x8(%ebp),%eax
  802434:	8b 55 0c             	mov    0xc(%ebp),%edx
  802437:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80243a:	8b 5d 14             	mov    0x14(%ebp),%ebx
  80243d:	8b 7d 18             	mov    0x18(%ebp),%edi
  802440:	8b 75 1c             	mov    0x1c(%ebp),%esi
  802443:	cd 30                	int    $0x30
  802445:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  802448:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  80244b:	83 c4 10             	add    $0x10,%esp
  80244e:	5b                   	pop    %ebx
  80244f:	5e                   	pop    %esi
  802450:	5f                   	pop    %edi
  802451:	5d                   	pop    %ebp
  802452:	c3                   	ret    

00802453 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  802453:	55                   	push   %ebp
  802454:	89 e5                	mov    %esp,%ebp
  802456:	83 ec 04             	sub    $0x4,%esp
  802459:	8b 45 10             	mov    0x10(%ebp),%eax
  80245c:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  80245f:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  802463:	8b 45 08             	mov    0x8(%ebp),%eax
  802466:	6a 00                	push   $0x0
  802468:	6a 00                	push   $0x0
  80246a:	52                   	push   %edx
  80246b:	ff 75 0c             	pushl  0xc(%ebp)
  80246e:	50                   	push   %eax
  80246f:	6a 00                	push   $0x0
  802471:	e8 b2 ff ff ff       	call   802428 <syscall>
  802476:	83 c4 18             	add    $0x18,%esp
}
  802479:	90                   	nop
  80247a:	c9                   	leave  
  80247b:	c3                   	ret    

0080247c <sys_cgetc>:

int
sys_cgetc(void)
{
  80247c:	55                   	push   %ebp
  80247d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  80247f:	6a 00                	push   $0x0
  802481:	6a 00                	push   $0x0
  802483:	6a 00                	push   $0x0
  802485:	6a 00                	push   $0x0
  802487:	6a 00                	push   $0x0
  802489:	6a 01                	push   $0x1
  80248b:	e8 98 ff ff ff       	call   802428 <syscall>
  802490:	83 c4 18             	add    $0x18,%esp
}
  802493:	c9                   	leave  
  802494:	c3                   	ret    

00802495 <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  802495:	55                   	push   %ebp
  802496:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  802498:	8b 55 0c             	mov    0xc(%ebp),%edx
  80249b:	8b 45 08             	mov    0x8(%ebp),%eax
  80249e:	6a 00                	push   $0x0
  8024a0:	6a 00                	push   $0x0
  8024a2:	6a 00                	push   $0x0
  8024a4:	52                   	push   %edx
  8024a5:	50                   	push   %eax
  8024a6:	6a 05                	push   $0x5
  8024a8:	e8 7b ff ff ff       	call   802428 <syscall>
  8024ad:	83 c4 18             	add    $0x18,%esp
}
  8024b0:	c9                   	leave  
  8024b1:	c3                   	ret    

008024b2 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  8024b2:	55                   	push   %ebp
  8024b3:	89 e5                	mov    %esp,%ebp
  8024b5:	56                   	push   %esi
  8024b6:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  8024b7:	8b 75 18             	mov    0x18(%ebp),%esi
  8024ba:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8024bd:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8024c0:	8b 55 0c             	mov    0xc(%ebp),%edx
  8024c3:	8b 45 08             	mov    0x8(%ebp),%eax
  8024c6:	56                   	push   %esi
  8024c7:	53                   	push   %ebx
  8024c8:	51                   	push   %ecx
  8024c9:	52                   	push   %edx
  8024ca:	50                   	push   %eax
  8024cb:	6a 06                	push   $0x6
  8024cd:	e8 56 ff ff ff       	call   802428 <syscall>
  8024d2:	83 c4 18             	add    $0x18,%esp
}
  8024d5:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8024d8:	5b                   	pop    %ebx
  8024d9:	5e                   	pop    %esi
  8024da:	5d                   	pop    %ebp
  8024db:	c3                   	ret    

008024dc <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  8024dc:	55                   	push   %ebp
  8024dd:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  8024df:	8b 55 0c             	mov    0xc(%ebp),%edx
  8024e2:	8b 45 08             	mov    0x8(%ebp),%eax
  8024e5:	6a 00                	push   $0x0
  8024e7:	6a 00                	push   $0x0
  8024e9:	6a 00                	push   $0x0
  8024eb:	52                   	push   %edx
  8024ec:	50                   	push   %eax
  8024ed:	6a 07                	push   $0x7
  8024ef:	e8 34 ff ff ff       	call   802428 <syscall>
  8024f4:	83 c4 18             	add    $0x18,%esp
}
  8024f7:	c9                   	leave  
  8024f8:	c3                   	ret    

008024f9 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  8024f9:	55                   	push   %ebp
  8024fa:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  8024fc:	6a 00                	push   $0x0
  8024fe:	6a 00                	push   $0x0
  802500:	6a 00                	push   $0x0
  802502:	ff 75 0c             	pushl  0xc(%ebp)
  802505:	ff 75 08             	pushl  0x8(%ebp)
  802508:	6a 08                	push   $0x8
  80250a:	e8 19 ff ff ff       	call   802428 <syscall>
  80250f:	83 c4 18             	add    $0x18,%esp
}
  802512:	c9                   	leave  
  802513:	c3                   	ret    

00802514 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  802514:	55                   	push   %ebp
  802515:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  802517:	6a 00                	push   $0x0
  802519:	6a 00                	push   $0x0
  80251b:	6a 00                	push   $0x0
  80251d:	6a 00                	push   $0x0
  80251f:	6a 00                	push   $0x0
  802521:	6a 09                	push   $0x9
  802523:	e8 00 ff ff ff       	call   802428 <syscall>
  802528:	83 c4 18             	add    $0x18,%esp
}
  80252b:	c9                   	leave  
  80252c:	c3                   	ret    

0080252d <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  80252d:	55                   	push   %ebp
  80252e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  802530:	6a 00                	push   $0x0
  802532:	6a 00                	push   $0x0
  802534:	6a 00                	push   $0x0
  802536:	6a 00                	push   $0x0
  802538:	6a 00                	push   $0x0
  80253a:	6a 0a                	push   $0xa
  80253c:	e8 e7 fe ff ff       	call   802428 <syscall>
  802541:	83 c4 18             	add    $0x18,%esp
}
  802544:	c9                   	leave  
  802545:	c3                   	ret    

00802546 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  802546:	55                   	push   %ebp
  802547:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  802549:	6a 00                	push   $0x0
  80254b:	6a 00                	push   $0x0
  80254d:	6a 00                	push   $0x0
  80254f:	6a 00                	push   $0x0
  802551:	6a 00                	push   $0x0
  802553:	6a 0b                	push   $0xb
  802555:	e8 ce fe ff ff       	call   802428 <syscall>
  80255a:	83 c4 18             	add    $0x18,%esp
}
  80255d:	c9                   	leave  
  80255e:	c3                   	ret    

0080255f <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  80255f:	55                   	push   %ebp
  802560:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  802562:	6a 00                	push   $0x0
  802564:	6a 00                	push   $0x0
  802566:	6a 00                	push   $0x0
  802568:	ff 75 0c             	pushl  0xc(%ebp)
  80256b:	ff 75 08             	pushl  0x8(%ebp)
  80256e:	6a 0f                	push   $0xf
  802570:	e8 b3 fe ff ff       	call   802428 <syscall>
  802575:	83 c4 18             	add    $0x18,%esp
	return;
  802578:	90                   	nop
}
  802579:	c9                   	leave  
  80257a:	c3                   	ret    

0080257b <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  80257b:	55                   	push   %ebp
  80257c:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  80257e:	6a 00                	push   $0x0
  802580:	6a 00                	push   $0x0
  802582:	6a 00                	push   $0x0
  802584:	ff 75 0c             	pushl  0xc(%ebp)
  802587:	ff 75 08             	pushl  0x8(%ebp)
  80258a:	6a 10                	push   $0x10
  80258c:	e8 97 fe ff ff       	call   802428 <syscall>
  802591:	83 c4 18             	add    $0x18,%esp
	return ;
  802594:	90                   	nop
}
  802595:	c9                   	leave  
  802596:	c3                   	ret    

00802597 <sys_allocate_chunk>:

void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  802597:	55                   	push   %ebp
  802598:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  80259a:	6a 00                	push   $0x0
  80259c:	6a 00                	push   $0x0
  80259e:	ff 75 10             	pushl  0x10(%ebp)
  8025a1:	ff 75 0c             	pushl  0xc(%ebp)
  8025a4:	ff 75 08             	pushl  0x8(%ebp)
  8025a7:	6a 11                	push   $0x11
  8025a9:	e8 7a fe ff ff       	call   802428 <syscall>
  8025ae:	83 c4 18             	add    $0x18,%esp
	return ;
  8025b1:	90                   	nop
}
  8025b2:	c9                   	leave  
  8025b3:	c3                   	ret    

008025b4 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  8025b4:	55                   	push   %ebp
  8025b5:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  8025b7:	6a 00                	push   $0x0
  8025b9:	6a 00                	push   $0x0
  8025bb:	6a 00                	push   $0x0
  8025bd:	6a 00                	push   $0x0
  8025bf:	6a 00                	push   $0x0
  8025c1:	6a 0c                	push   $0xc
  8025c3:	e8 60 fe ff ff       	call   802428 <syscall>
  8025c8:	83 c4 18             	add    $0x18,%esp
}
  8025cb:	c9                   	leave  
  8025cc:	c3                   	ret    

008025cd <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  8025cd:	55                   	push   %ebp
  8025ce:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  8025d0:	6a 00                	push   $0x0
  8025d2:	6a 00                	push   $0x0
  8025d4:	6a 00                	push   $0x0
  8025d6:	6a 00                	push   $0x0
  8025d8:	ff 75 08             	pushl  0x8(%ebp)
  8025db:	6a 0d                	push   $0xd
  8025dd:	e8 46 fe ff ff       	call   802428 <syscall>
  8025e2:	83 c4 18             	add    $0x18,%esp
}
  8025e5:	c9                   	leave  
  8025e6:	c3                   	ret    

008025e7 <sys_scarce_memory>:

void sys_scarce_memory()
{
  8025e7:	55                   	push   %ebp
  8025e8:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  8025ea:	6a 00                	push   $0x0
  8025ec:	6a 00                	push   $0x0
  8025ee:	6a 00                	push   $0x0
  8025f0:	6a 00                	push   $0x0
  8025f2:	6a 00                	push   $0x0
  8025f4:	6a 0e                	push   $0xe
  8025f6:	e8 2d fe ff ff       	call   802428 <syscall>
  8025fb:	83 c4 18             	add    $0x18,%esp
}
  8025fe:	90                   	nop
  8025ff:	c9                   	leave  
  802600:	c3                   	ret    

00802601 <sys_disable_interrupt>:

//NEW !! 2012...
void
sys_disable_interrupt()
{
  802601:	55                   	push   %ebp
  802602:	89 e5                	mov    %esp,%ebp
	syscall(SYS_disableINTR,0, 0, 0, 0, 0);
  802604:	6a 00                	push   $0x0
  802606:	6a 00                	push   $0x0
  802608:	6a 00                	push   $0x0
  80260a:	6a 00                	push   $0x0
  80260c:	6a 00                	push   $0x0
  80260e:	6a 13                	push   $0x13
  802610:	e8 13 fe ff ff       	call   802428 <syscall>
  802615:	83 c4 18             	add    $0x18,%esp
}
  802618:	90                   	nop
  802619:	c9                   	leave  
  80261a:	c3                   	ret    

0080261b <sys_enable_interrupt>:


void
sys_enable_interrupt()
{
  80261b:	55                   	push   %ebp
  80261c:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enableINTR,0, 0, 0, 0, 0);
  80261e:	6a 00                	push   $0x0
  802620:	6a 00                	push   $0x0
  802622:	6a 00                	push   $0x0
  802624:	6a 00                	push   $0x0
  802626:	6a 00                	push   $0x0
  802628:	6a 14                	push   $0x14
  80262a:	e8 f9 fd ff ff       	call   802428 <syscall>
  80262f:	83 c4 18             	add    $0x18,%esp
}
  802632:	90                   	nop
  802633:	c9                   	leave  
  802634:	c3                   	ret    

00802635 <sys_cputc>:


void
sys_cputc(const char c)
{
  802635:	55                   	push   %ebp
  802636:	89 e5                	mov    %esp,%ebp
  802638:	83 ec 04             	sub    $0x4,%esp
  80263b:	8b 45 08             	mov    0x8(%ebp),%eax
  80263e:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  802641:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  802645:	6a 00                	push   $0x0
  802647:	6a 00                	push   $0x0
  802649:	6a 00                	push   $0x0
  80264b:	6a 00                	push   $0x0
  80264d:	50                   	push   %eax
  80264e:	6a 15                	push   $0x15
  802650:	e8 d3 fd ff ff       	call   802428 <syscall>
  802655:	83 c4 18             	add    $0x18,%esp
}
  802658:	90                   	nop
  802659:	c9                   	leave  
  80265a:	c3                   	ret    

0080265b <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  80265b:	55                   	push   %ebp
  80265c:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  80265e:	6a 00                	push   $0x0
  802660:	6a 00                	push   $0x0
  802662:	6a 00                	push   $0x0
  802664:	6a 00                	push   $0x0
  802666:	6a 00                	push   $0x0
  802668:	6a 16                	push   $0x16
  80266a:	e8 b9 fd ff ff       	call   802428 <syscall>
  80266f:	83 c4 18             	add    $0x18,%esp
}
  802672:	90                   	nop
  802673:	c9                   	leave  
  802674:	c3                   	ret    

00802675 <sys_createSemaphore>:

int
sys_createSemaphore(char* semaphoreName, uint32 initialValue)
{
  802675:	55                   	push   %ebp
  802676:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_semaphore,(uint32)semaphoreName, (uint32)initialValue, 0, 0, 0);
  802678:	8b 45 08             	mov    0x8(%ebp),%eax
  80267b:	6a 00                	push   $0x0
  80267d:	6a 00                	push   $0x0
  80267f:	6a 00                	push   $0x0
  802681:	ff 75 0c             	pushl  0xc(%ebp)
  802684:	50                   	push   %eax
  802685:	6a 17                	push   $0x17
  802687:	e8 9c fd ff ff       	call   802428 <syscall>
  80268c:	83 c4 18             	add    $0x18,%esp
}
  80268f:	c9                   	leave  
  802690:	c3                   	ret    

00802691 <sys_getSemaphoreValue>:

int
sys_getSemaphoreValue(int32 ownerEnvID, char* semaphoreName)
{
  802691:	55                   	push   %ebp
  802692:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_semaphore_value,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  802694:	8b 55 0c             	mov    0xc(%ebp),%edx
  802697:	8b 45 08             	mov    0x8(%ebp),%eax
  80269a:	6a 00                	push   $0x0
  80269c:	6a 00                	push   $0x0
  80269e:	6a 00                	push   $0x0
  8026a0:	52                   	push   %edx
  8026a1:	50                   	push   %eax
  8026a2:	6a 1a                	push   $0x1a
  8026a4:	e8 7f fd ff ff       	call   802428 <syscall>
  8026a9:	83 c4 18             	add    $0x18,%esp
}
  8026ac:	c9                   	leave  
  8026ad:	c3                   	ret    

008026ae <sys_waitSemaphore>:

void
sys_waitSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  8026ae:	55                   	push   %ebp
  8026af:	89 e5                	mov    %esp,%ebp
	syscall(SYS_wait_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  8026b1:	8b 55 0c             	mov    0xc(%ebp),%edx
  8026b4:	8b 45 08             	mov    0x8(%ebp),%eax
  8026b7:	6a 00                	push   $0x0
  8026b9:	6a 00                	push   $0x0
  8026bb:	6a 00                	push   $0x0
  8026bd:	52                   	push   %edx
  8026be:	50                   	push   %eax
  8026bf:	6a 18                	push   $0x18
  8026c1:	e8 62 fd ff ff       	call   802428 <syscall>
  8026c6:	83 c4 18             	add    $0x18,%esp
}
  8026c9:	90                   	nop
  8026ca:	c9                   	leave  
  8026cb:	c3                   	ret    

008026cc <sys_signalSemaphore>:

void
sys_signalSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  8026cc:	55                   	push   %ebp
  8026cd:	89 e5                	mov    %esp,%ebp
	syscall(SYS_signal_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  8026cf:	8b 55 0c             	mov    0xc(%ebp),%edx
  8026d2:	8b 45 08             	mov    0x8(%ebp),%eax
  8026d5:	6a 00                	push   $0x0
  8026d7:	6a 00                	push   $0x0
  8026d9:	6a 00                	push   $0x0
  8026db:	52                   	push   %edx
  8026dc:	50                   	push   %eax
  8026dd:	6a 19                	push   $0x19
  8026df:	e8 44 fd ff ff       	call   802428 <syscall>
  8026e4:	83 c4 18             	add    $0x18,%esp
}
  8026e7:	90                   	nop
  8026e8:	c9                   	leave  
  8026e9:	c3                   	ret    

008026ea <sys_createSharedObject>:

int
sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  8026ea:	55                   	push   %ebp
  8026eb:	89 e5                	mov    %esp,%ebp
  8026ed:	83 ec 04             	sub    $0x4,%esp
  8026f0:	8b 45 10             	mov    0x10(%ebp),%eax
  8026f3:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  8026f6:	8b 4d 14             	mov    0x14(%ebp),%ecx
  8026f9:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  8026fd:	8b 45 08             	mov    0x8(%ebp),%eax
  802700:	6a 00                	push   $0x0
  802702:	51                   	push   %ecx
  802703:	52                   	push   %edx
  802704:	ff 75 0c             	pushl  0xc(%ebp)
  802707:	50                   	push   %eax
  802708:	6a 1b                	push   $0x1b
  80270a:	e8 19 fd ff ff       	call   802428 <syscall>
  80270f:	83 c4 18             	add    $0x18,%esp
}
  802712:	c9                   	leave  
  802713:	c3                   	ret    

00802714 <sys_getSizeOfSharedObject>:

//2017:
int
sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  802714:	55                   	push   %ebp
  802715:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  802717:	8b 55 0c             	mov    0xc(%ebp),%edx
  80271a:	8b 45 08             	mov    0x8(%ebp),%eax
  80271d:	6a 00                	push   $0x0
  80271f:	6a 00                	push   $0x0
  802721:	6a 00                	push   $0x0
  802723:	52                   	push   %edx
  802724:	50                   	push   %eax
  802725:	6a 1c                	push   $0x1c
  802727:	e8 fc fc ff ff       	call   802428 <syscall>
  80272c:	83 c4 18             	add    $0x18,%esp
}
  80272f:	c9                   	leave  
  802730:	c3                   	ret    

00802731 <sys_getSharedObject>:
//==========

int
sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  802731:	55                   	push   %ebp
  802732:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  802734:	8b 4d 10             	mov    0x10(%ebp),%ecx
  802737:	8b 55 0c             	mov    0xc(%ebp),%edx
  80273a:	8b 45 08             	mov    0x8(%ebp),%eax
  80273d:	6a 00                	push   $0x0
  80273f:	6a 00                	push   $0x0
  802741:	51                   	push   %ecx
  802742:	52                   	push   %edx
  802743:	50                   	push   %eax
  802744:	6a 1d                	push   $0x1d
  802746:	e8 dd fc ff ff       	call   802428 <syscall>
  80274b:	83 c4 18             	add    $0x18,%esp
}
  80274e:	c9                   	leave  
  80274f:	c3                   	ret    

00802750 <sys_freeSharedObject>:

int
sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  802750:	55                   	push   %ebp
  802751:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  802753:	8b 55 0c             	mov    0xc(%ebp),%edx
  802756:	8b 45 08             	mov    0x8(%ebp),%eax
  802759:	6a 00                	push   $0x0
  80275b:	6a 00                	push   $0x0
  80275d:	6a 00                	push   $0x0
  80275f:	52                   	push   %edx
  802760:	50                   	push   %eax
  802761:	6a 1e                	push   $0x1e
  802763:	e8 c0 fc ff ff       	call   802428 <syscall>
  802768:	83 c4 18             	add    $0x18,%esp
}
  80276b:	c9                   	leave  
  80276c:	c3                   	ret    

0080276d <sys_getMaxShares>:

uint32 	sys_getMaxShares()
{
  80276d:	55                   	push   %ebp
  80276e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_max_shares,0, 0, 0, 0, 0);
  802770:	6a 00                	push   $0x0
  802772:	6a 00                	push   $0x0
  802774:	6a 00                	push   $0x0
  802776:	6a 00                	push   $0x0
  802778:	6a 00                	push   $0x0
  80277a:	6a 1f                	push   $0x1f
  80277c:	e8 a7 fc ff ff       	call   802428 <syscall>
  802781:	83 c4 18             	add    $0x18,%esp
}
  802784:	c9                   	leave  
  802785:	c3                   	ret    

00802786 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  802786:	55                   	push   %ebp
  802787:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  802789:	8b 45 08             	mov    0x8(%ebp),%eax
  80278c:	6a 00                	push   $0x0
  80278e:	ff 75 14             	pushl  0x14(%ebp)
  802791:	ff 75 10             	pushl  0x10(%ebp)
  802794:	ff 75 0c             	pushl  0xc(%ebp)
  802797:	50                   	push   %eax
  802798:	6a 20                	push   $0x20
  80279a:	e8 89 fc ff ff       	call   802428 <syscall>
  80279f:	83 c4 18             	add    $0x18,%esp
}
  8027a2:	c9                   	leave  
  8027a3:	c3                   	ret    

008027a4 <sys_run_env>:

void
sys_run_env(int32 envId)
{
  8027a4:	55                   	push   %ebp
  8027a5:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  8027a7:	8b 45 08             	mov    0x8(%ebp),%eax
  8027aa:	6a 00                	push   $0x0
  8027ac:	6a 00                	push   $0x0
  8027ae:	6a 00                	push   $0x0
  8027b0:	6a 00                	push   $0x0
  8027b2:	50                   	push   %eax
  8027b3:	6a 21                	push   $0x21
  8027b5:	e8 6e fc ff ff       	call   802428 <syscall>
  8027ba:	83 c4 18             	add    $0x18,%esp
}
  8027bd:	90                   	nop
  8027be:	c9                   	leave  
  8027bf:	c3                   	ret    

008027c0 <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  8027c0:	55                   	push   %ebp
  8027c1:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  8027c3:	8b 45 08             	mov    0x8(%ebp),%eax
  8027c6:	6a 00                	push   $0x0
  8027c8:	6a 00                	push   $0x0
  8027ca:	6a 00                	push   $0x0
  8027cc:	6a 00                	push   $0x0
  8027ce:	50                   	push   %eax
  8027cf:	6a 22                	push   $0x22
  8027d1:	e8 52 fc ff ff       	call   802428 <syscall>
  8027d6:	83 c4 18             	add    $0x18,%esp
}
  8027d9:	c9                   	leave  
  8027da:	c3                   	ret    

008027db <sys_getenvid>:

int32 sys_getenvid(void)
{
  8027db:	55                   	push   %ebp
  8027dc:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  8027de:	6a 00                	push   $0x0
  8027e0:	6a 00                	push   $0x0
  8027e2:	6a 00                	push   $0x0
  8027e4:	6a 00                	push   $0x0
  8027e6:	6a 00                	push   $0x0
  8027e8:	6a 02                	push   $0x2
  8027ea:	e8 39 fc ff ff       	call   802428 <syscall>
  8027ef:	83 c4 18             	add    $0x18,%esp
}
  8027f2:	c9                   	leave  
  8027f3:	c3                   	ret    

008027f4 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  8027f4:	55                   	push   %ebp
  8027f5:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  8027f7:	6a 00                	push   $0x0
  8027f9:	6a 00                	push   $0x0
  8027fb:	6a 00                	push   $0x0
  8027fd:	6a 00                	push   $0x0
  8027ff:	6a 00                	push   $0x0
  802801:	6a 03                	push   $0x3
  802803:	e8 20 fc ff ff       	call   802428 <syscall>
  802808:	83 c4 18             	add    $0x18,%esp
}
  80280b:	c9                   	leave  
  80280c:	c3                   	ret    

0080280d <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  80280d:	55                   	push   %ebp
  80280e:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  802810:	6a 00                	push   $0x0
  802812:	6a 00                	push   $0x0
  802814:	6a 00                	push   $0x0
  802816:	6a 00                	push   $0x0
  802818:	6a 00                	push   $0x0
  80281a:	6a 04                	push   $0x4
  80281c:	e8 07 fc ff ff       	call   802428 <syscall>
  802821:	83 c4 18             	add    $0x18,%esp
}
  802824:	c9                   	leave  
  802825:	c3                   	ret    

00802826 <sys_exit_env>:


void sys_exit_env(void)
{
  802826:	55                   	push   %ebp
  802827:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  802829:	6a 00                	push   $0x0
  80282b:	6a 00                	push   $0x0
  80282d:	6a 00                	push   $0x0
  80282f:	6a 00                	push   $0x0
  802831:	6a 00                	push   $0x0
  802833:	6a 23                	push   $0x23
  802835:	e8 ee fb ff ff       	call   802428 <syscall>
  80283a:	83 c4 18             	add    $0x18,%esp
}
  80283d:	90                   	nop
  80283e:	c9                   	leave  
  80283f:	c3                   	ret    

00802840 <sys_get_virtual_time>:


struct uint64
sys_get_virtual_time()
{
  802840:	55                   	push   %ebp
  802841:	89 e5                	mov    %esp,%ebp
  802843:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  802846:	8d 45 f8             	lea    -0x8(%ebp),%eax
  802849:	8d 50 04             	lea    0x4(%eax),%edx
  80284c:	8d 45 f8             	lea    -0x8(%ebp),%eax
  80284f:	6a 00                	push   $0x0
  802851:	6a 00                	push   $0x0
  802853:	6a 00                	push   $0x0
  802855:	52                   	push   %edx
  802856:	50                   	push   %eax
  802857:	6a 24                	push   $0x24
  802859:	e8 ca fb ff ff       	call   802428 <syscall>
  80285e:	83 c4 18             	add    $0x18,%esp
	return result;
  802861:	8b 4d 08             	mov    0x8(%ebp),%ecx
  802864:	8b 45 f8             	mov    -0x8(%ebp),%eax
  802867:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80286a:	89 01                	mov    %eax,(%ecx)
  80286c:	89 51 04             	mov    %edx,0x4(%ecx)
}
  80286f:	8b 45 08             	mov    0x8(%ebp),%eax
  802872:	c9                   	leave  
  802873:	c2 04 00             	ret    $0x4

00802876 <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  802876:	55                   	push   %ebp
  802877:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  802879:	6a 00                	push   $0x0
  80287b:	6a 00                	push   $0x0
  80287d:	ff 75 10             	pushl  0x10(%ebp)
  802880:	ff 75 0c             	pushl  0xc(%ebp)
  802883:	ff 75 08             	pushl  0x8(%ebp)
  802886:	6a 12                	push   $0x12
  802888:	e8 9b fb ff ff       	call   802428 <syscall>
  80288d:	83 c4 18             	add    $0x18,%esp
	return ;
  802890:	90                   	nop
}
  802891:	c9                   	leave  
  802892:	c3                   	ret    

00802893 <sys_rcr2>:
uint32 sys_rcr2()
{
  802893:	55                   	push   %ebp
  802894:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  802896:	6a 00                	push   $0x0
  802898:	6a 00                	push   $0x0
  80289a:	6a 00                	push   $0x0
  80289c:	6a 00                	push   $0x0
  80289e:	6a 00                	push   $0x0
  8028a0:	6a 25                	push   $0x25
  8028a2:	e8 81 fb ff ff       	call   802428 <syscall>
  8028a7:	83 c4 18             	add    $0x18,%esp
}
  8028aa:	c9                   	leave  
  8028ab:	c3                   	ret    

008028ac <sys_bypassPageFault>:
void sys_bypassPageFault(uint8 instrLength)
{
  8028ac:	55                   	push   %ebp
  8028ad:	89 e5                	mov    %esp,%ebp
  8028af:	83 ec 04             	sub    $0x4,%esp
  8028b2:	8b 45 08             	mov    0x8(%ebp),%eax
  8028b5:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  8028b8:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  8028bc:	6a 00                	push   $0x0
  8028be:	6a 00                	push   $0x0
  8028c0:	6a 00                	push   $0x0
  8028c2:	6a 00                	push   $0x0
  8028c4:	50                   	push   %eax
  8028c5:	6a 26                	push   $0x26
  8028c7:	e8 5c fb ff ff       	call   802428 <syscall>
  8028cc:	83 c4 18             	add    $0x18,%esp
	return ;
  8028cf:	90                   	nop
}
  8028d0:	c9                   	leave  
  8028d1:	c3                   	ret    

008028d2 <rsttst>:
void rsttst()
{
  8028d2:	55                   	push   %ebp
  8028d3:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  8028d5:	6a 00                	push   $0x0
  8028d7:	6a 00                	push   $0x0
  8028d9:	6a 00                	push   $0x0
  8028db:	6a 00                	push   $0x0
  8028dd:	6a 00                	push   $0x0
  8028df:	6a 28                	push   $0x28
  8028e1:	e8 42 fb ff ff       	call   802428 <syscall>
  8028e6:	83 c4 18             	add    $0x18,%esp
	return ;
  8028e9:	90                   	nop
}
  8028ea:	c9                   	leave  
  8028eb:	c3                   	ret    

008028ec <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  8028ec:	55                   	push   %ebp
  8028ed:	89 e5                	mov    %esp,%ebp
  8028ef:	83 ec 04             	sub    $0x4,%esp
  8028f2:	8b 45 14             	mov    0x14(%ebp),%eax
  8028f5:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  8028f8:	8b 55 18             	mov    0x18(%ebp),%edx
  8028fb:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  8028ff:	52                   	push   %edx
  802900:	50                   	push   %eax
  802901:	ff 75 10             	pushl  0x10(%ebp)
  802904:	ff 75 0c             	pushl  0xc(%ebp)
  802907:	ff 75 08             	pushl  0x8(%ebp)
  80290a:	6a 27                	push   $0x27
  80290c:	e8 17 fb ff ff       	call   802428 <syscall>
  802911:	83 c4 18             	add    $0x18,%esp
	return ;
  802914:	90                   	nop
}
  802915:	c9                   	leave  
  802916:	c3                   	ret    

00802917 <chktst>:
void chktst(uint32 n)
{
  802917:	55                   	push   %ebp
  802918:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  80291a:	6a 00                	push   $0x0
  80291c:	6a 00                	push   $0x0
  80291e:	6a 00                	push   $0x0
  802920:	6a 00                	push   $0x0
  802922:	ff 75 08             	pushl  0x8(%ebp)
  802925:	6a 29                	push   $0x29
  802927:	e8 fc fa ff ff       	call   802428 <syscall>
  80292c:	83 c4 18             	add    $0x18,%esp
	return ;
  80292f:	90                   	nop
}
  802930:	c9                   	leave  
  802931:	c3                   	ret    

00802932 <inctst>:

void inctst()
{
  802932:	55                   	push   %ebp
  802933:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  802935:	6a 00                	push   $0x0
  802937:	6a 00                	push   $0x0
  802939:	6a 00                	push   $0x0
  80293b:	6a 00                	push   $0x0
  80293d:	6a 00                	push   $0x0
  80293f:	6a 2a                	push   $0x2a
  802941:	e8 e2 fa ff ff       	call   802428 <syscall>
  802946:	83 c4 18             	add    $0x18,%esp
	return ;
  802949:	90                   	nop
}
  80294a:	c9                   	leave  
  80294b:	c3                   	ret    

0080294c <gettst>:
uint32 gettst()
{
  80294c:	55                   	push   %ebp
  80294d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  80294f:	6a 00                	push   $0x0
  802951:	6a 00                	push   $0x0
  802953:	6a 00                	push   $0x0
  802955:	6a 00                	push   $0x0
  802957:	6a 00                	push   $0x0
  802959:	6a 2b                	push   $0x2b
  80295b:	e8 c8 fa ff ff       	call   802428 <syscall>
  802960:	83 c4 18             	add    $0x18,%esp
}
  802963:	c9                   	leave  
  802964:	c3                   	ret    

00802965 <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  802965:	55                   	push   %ebp
  802966:	89 e5                	mov    %esp,%ebp
  802968:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  80296b:	6a 00                	push   $0x0
  80296d:	6a 00                	push   $0x0
  80296f:	6a 00                	push   $0x0
  802971:	6a 00                	push   $0x0
  802973:	6a 00                	push   $0x0
  802975:	6a 2c                	push   $0x2c
  802977:	e8 ac fa ff ff       	call   802428 <syscall>
  80297c:	83 c4 18             	add    $0x18,%esp
  80297f:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  802982:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  802986:	75 07                	jne    80298f <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  802988:	b8 01 00 00 00       	mov    $0x1,%eax
  80298d:	eb 05                	jmp    802994 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  80298f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802994:	c9                   	leave  
  802995:	c3                   	ret    

00802996 <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  802996:	55                   	push   %ebp
  802997:	89 e5                	mov    %esp,%ebp
  802999:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  80299c:	6a 00                	push   $0x0
  80299e:	6a 00                	push   $0x0
  8029a0:	6a 00                	push   $0x0
  8029a2:	6a 00                	push   $0x0
  8029a4:	6a 00                	push   $0x0
  8029a6:	6a 2c                	push   $0x2c
  8029a8:	e8 7b fa ff ff       	call   802428 <syscall>
  8029ad:	83 c4 18             	add    $0x18,%esp
  8029b0:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  8029b3:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  8029b7:	75 07                	jne    8029c0 <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  8029b9:	b8 01 00 00 00       	mov    $0x1,%eax
  8029be:	eb 05                	jmp    8029c5 <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  8029c0:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8029c5:	c9                   	leave  
  8029c6:	c3                   	ret    

008029c7 <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  8029c7:	55                   	push   %ebp
  8029c8:	89 e5                	mov    %esp,%ebp
  8029ca:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8029cd:	6a 00                	push   $0x0
  8029cf:	6a 00                	push   $0x0
  8029d1:	6a 00                	push   $0x0
  8029d3:	6a 00                	push   $0x0
  8029d5:	6a 00                	push   $0x0
  8029d7:	6a 2c                	push   $0x2c
  8029d9:	e8 4a fa ff ff       	call   802428 <syscall>
  8029de:	83 c4 18             	add    $0x18,%esp
  8029e1:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  8029e4:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  8029e8:	75 07                	jne    8029f1 <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  8029ea:	b8 01 00 00 00       	mov    $0x1,%eax
  8029ef:	eb 05                	jmp    8029f6 <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  8029f1:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8029f6:	c9                   	leave  
  8029f7:	c3                   	ret    

008029f8 <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  8029f8:	55                   	push   %ebp
  8029f9:	89 e5                	mov    %esp,%ebp
  8029fb:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8029fe:	6a 00                	push   $0x0
  802a00:	6a 00                	push   $0x0
  802a02:	6a 00                	push   $0x0
  802a04:	6a 00                	push   $0x0
  802a06:	6a 00                	push   $0x0
  802a08:	6a 2c                	push   $0x2c
  802a0a:	e8 19 fa ff ff       	call   802428 <syscall>
  802a0f:	83 c4 18             	add    $0x18,%esp
  802a12:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  802a15:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  802a19:	75 07                	jne    802a22 <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  802a1b:	b8 01 00 00 00       	mov    $0x1,%eax
  802a20:	eb 05                	jmp    802a27 <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  802a22:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802a27:	c9                   	leave  
  802a28:	c3                   	ret    

00802a29 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  802a29:	55                   	push   %ebp
  802a2a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  802a2c:	6a 00                	push   $0x0
  802a2e:	6a 00                	push   $0x0
  802a30:	6a 00                	push   $0x0
  802a32:	6a 00                	push   $0x0
  802a34:	ff 75 08             	pushl  0x8(%ebp)
  802a37:	6a 2d                	push   $0x2d
  802a39:	e8 ea f9 ff ff       	call   802428 <syscall>
  802a3e:	83 c4 18             	add    $0x18,%esp
	return ;
  802a41:	90                   	nop
}
  802a42:	c9                   	leave  
  802a43:	c3                   	ret    

00802a44 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  802a44:	55                   	push   %ebp
  802a45:	89 e5                	mov    %esp,%ebp
  802a47:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  802a48:	8b 5d 14             	mov    0x14(%ebp),%ebx
  802a4b:	8b 4d 10             	mov    0x10(%ebp),%ecx
  802a4e:	8b 55 0c             	mov    0xc(%ebp),%edx
  802a51:	8b 45 08             	mov    0x8(%ebp),%eax
  802a54:	6a 00                	push   $0x0
  802a56:	53                   	push   %ebx
  802a57:	51                   	push   %ecx
  802a58:	52                   	push   %edx
  802a59:	50                   	push   %eax
  802a5a:	6a 2e                	push   $0x2e
  802a5c:	e8 c7 f9 ff ff       	call   802428 <syscall>
  802a61:	83 c4 18             	add    $0x18,%esp
}
  802a64:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802a67:	c9                   	leave  
  802a68:	c3                   	ret    

00802a69 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  802a69:	55                   	push   %ebp
  802a6a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  802a6c:	8b 55 0c             	mov    0xc(%ebp),%edx
  802a6f:	8b 45 08             	mov    0x8(%ebp),%eax
  802a72:	6a 00                	push   $0x0
  802a74:	6a 00                	push   $0x0
  802a76:	6a 00                	push   $0x0
  802a78:	52                   	push   %edx
  802a79:	50                   	push   %eax
  802a7a:	6a 2f                	push   $0x2f
  802a7c:	e8 a7 f9 ff ff       	call   802428 <syscall>
  802a81:	83 c4 18             	add    $0x18,%esp
}
  802a84:	c9                   	leave  
  802a85:	c3                   	ret    

00802a86 <print_mem_block_lists>:
//===========================
// PRINT MEM BLOCK LISTS:
//===========================

void print_mem_block_lists()
{
  802a86:	55                   	push   %ebp
  802a87:	89 e5                	mov    %esp,%ebp
  802a89:	83 ec 18             	sub    $0x18,%esp
	cprintf("\n=========================================\n");
  802a8c:	83 ec 0c             	sub    $0xc,%esp
  802a8f:	68 80 45 80 00       	push   $0x804580
  802a94:	e8 dd e6 ff ff       	call   801176 <cprintf>
  802a99:	83 c4 10             	add    $0x10,%esp
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
  802a9c:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nFreeMemBlocksList:\n");
  802aa3:	83 ec 0c             	sub    $0xc,%esp
  802aa6:	68 ac 45 80 00       	push   $0x8045ac
  802aab:	e8 c6 e6 ff ff       	call   801176 <cprintf>
  802ab0:	83 c4 10             	add    $0x10,%esp
	uint8 sorted = 1 ;
  802ab3:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &FreeMemBlocksList)
  802ab7:	a1 38 51 80 00       	mov    0x805138,%eax
  802abc:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802abf:	eb 56                	jmp    802b17 <print_mem_block_lists+0x91>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  802ac1:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802ac5:	74 1c                	je     802ae3 <print_mem_block_lists+0x5d>
  802ac7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802aca:	8b 50 08             	mov    0x8(%eax),%edx
  802acd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ad0:	8b 48 08             	mov    0x8(%eax),%ecx
  802ad3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ad6:	8b 40 0c             	mov    0xc(%eax),%eax
  802ad9:	01 c8                	add    %ecx,%eax
  802adb:	39 c2                	cmp    %eax,%edx
  802add:	73 04                	jae    802ae3 <print_mem_block_lists+0x5d>
			sorted = 0 ;
  802adf:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  802ae3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ae6:	8b 50 08             	mov    0x8(%eax),%edx
  802ae9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802aec:	8b 40 0c             	mov    0xc(%eax),%eax
  802aef:	01 c2                	add    %eax,%edx
  802af1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802af4:	8b 40 08             	mov    0x8(%eax),%eax
  802af7:	83 ec 04             	sub    $0x4,%esp
  802afa:	52                   	push   %edx
  802afb:	50                   	push   %eax
  802afc:	68 c1 45 80 00       	push   $0x8045c1
  802b01:	e8 70 e6 ff ff       	call   801176 <cprintf>
  802b06:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  802b09:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b0c:	89 45 f0             	mov    %eax,-0x10(%ebp)
	cprintf("\n=========================================\n");
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
	cprintf("\nFreeMemBlocksList:\n");
	uint8 sorted = 1 ;
	LIST_FOREACH(blk, &FreeMemBlocksList)
  802b0f:	a1 40 51 80 00       	mov    0x805140,%eax
  802b14:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802b17:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802b1b:	74 07                	je     802b24 <print_mem_block_lists+0x9e>
  802b1d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b20:	8b 00                	mov    (%eax),%eax
  802b22:	eb 05                	jmp    802b29 <print_mem_block_lists+0xa3>
  802b24:	b8 00 00 00 00       	mov    $0x0,%eax
  802b29:	a3 40 51 80 00       	mov    %eax,0x805140
  802b2e:	a1 40 51 80 00       	mov    0x805140,%eax
  802b33:	85 c0                	test   %eax,%eax
  802b35:	75 8a                	jne    802ac1 <print_mem_block_lists+0x3b>
  802b37:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802b3b:	75 84                	jne    802ac1 <print_mem_block_lists+0x3b>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;
  802b3d:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  802b41:	75 10                	jne    802b53 <print_mem_block_lists+0xcd>
  802b43:	83 ec 0c             	sub    $0xc,%esp
  802b46:	68 d0 45 80 00       	push   $0x8045d0
  802b4b:	e8 26 e6 ff ff       	call   801176 <cprintf>
  802b50:	83 c4 10             	add    $0x10,%esp

	lastBlk = NULL ;
  802b53:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nAllocMemBlocksList:\n");
  802b5a:	83 ec 0c             	sub    $0xc,%esp
  802b5d:	68 f4 45 80 00       	push   $0x8045f4
  802b62:	e8 0f e6 ff ff       	call   801176 <cprintf>
  802b67:	83 c4 10             	add    $0x10,%esp
	sorted = 1 ;
  802b6a:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &AllocMemBlocksList)
  802b6e:	a1 40 50 80 00       	mov    0x805040,%eax
  802b73:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802b76:	eb 56                	jmp    802bce <print_mem_block_lists+0x148>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  802b78:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802b7c:	74 1c                	je     802b9a <print_mem_block_lists+0x114>
  802b7e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b81:	8b 50 08             	mov    0x8(%eax),%edx
  802b84:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b87:	8b 48 08             	mov    0x8(%eax),%ecx
  802b8a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b8d:	8b 40 0c             	mov    0xc(%eax),%eax
  802b90:	01 c8                	add    %ecx,%eax
  802b92:	39 c2                	cmp    %eax,%edx
  802b94:	73 04                	jae    802b9a <print_mem_block_lists+0x114>
			sorted = 0 ;
  802b96:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  802b9a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b9d:	8b 50 08             	mov    0x8(%eax),%edx
  802ba0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ba3:	8b 40 0c             	mov    0xc(%eax),%eax
  802ba6:	01 c2                	add    %eax,%edx
  802ba8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bab:	8b 40 08             	mov    0x8(%eax),%eax
  802bae:	83 ec 04             	sub    $0x4,%esp
  802bb1:	52                   	push   %edx
  802bb2:	50                   	push   %eax
  802bb3:	68 c1 45 80 00       	push   $0x8045c1
  802bb8:	e8 b9 e5 ff ff       	call   801176 <cprintf>
  802bbd:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  802bc0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bc3:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;

	lastBlk = NULL ;
	cprintf("\nAllocMemBlocksList:\n");
	sorted = 1 ;
	LIST_FOREACH(blk, &AllocMemBlocksList)
  802bc6:	a1 48 50 80 00       	mov    0x805048,%eax
  802bcb:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802bce:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802bd2:	74 07                	je     802bdb <print_mem_block_lists+0x155>
  802bd4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bd7:	8b 00                	mov    (%eax),%eax
  802bd9:	eb 05                	jmp    802be0 <print_mem_block_lists+0x15a>
  802bdb:	b8 00 00 00 00       	mov    $0x0,%eax
  802be0:	a3 48 50 80 00       	mov    %eax,0x805048
  802be5:	a1 48 50 80 00       	mov    0x805048,%eax
  802bea:	85 c0                	test   %eax,%eax
  802bec:	75 8a                	jne    802b78 <print_mem_block_lists+0xf2>
  802bee:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802bf2:	75 84                	jne    802b78 <print_mem_block_lists+0xf2>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nAllocMemBlocksList is NOT SORTED!!\n") ;
  802bf4:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  802bf8:	75 10                	jne    802c0a <print_mem_block_lists+0x184>
  802bfa:	83 ec 0c             	sub    $0xc,%esp
  802bfd:	68 0c 46 80 00       	push   $0x80460c
  802c02:	e8 6f e5 ff ff       	call   801176 <cprintf>
  802c07:	83 c4 10             	add    $0x10,%esp
	cprintf("\n=========================================\n");
  802c0a:	83 ec 0c             	sub    $0xc,%esp
  802c0d:	68 80 45 80 00       	push   $0x804580
  802c12:	e8 5f e5 ff ff       	call   801176 <cprintf>
  802c17:	83 c4 10             	add    $0x10,%esp

}
  802c1a:	90                   	nop
  802c1b:	c9                   	leave  
  802c1c:	c3                   	ret    

00802c1d <initialize_MemBlocksList>:

//===============================
// [1] INITIALIZE AVAILABLE LIST:
//===============================
void initialize_MemBlocksList(uint32 numOfBlocks)
{
  802c1d:	55                   	push   %ebp
  802c1e:	89 e5                	mov    %esp,%ebp
  802c20:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] initialize_MemBlocksList
	// Write your code here, remove the panic and write your code
	//panic("initialize_MemBlocksList() is not implemented yet...!!");
	uint32 n = numOfBlocks;
  802c23:	8b 45 08             	mov    0x8(%ebp),%eax
  802c26:	89 45 f0             	mov    %eax,-0x10(%ebp)

	LIST_INIT(&AvailableMemBlocksList);
  802c29:	c7 05 48 51 80 00 00 	movl   $0x0,0x805148
  802c30:	00 00 00 
  802c33:	c7 05 4c 51 80 00 00 	movl   $0x0,0x80514c
  802c3a:	00 00 00 
  802c3d:	c7 05 54 51 80 00 00 	movl   $0x0,0x805154
  802c44:	00 00 00 
	for(int i = 0; i<n;i++)
  802c47:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  802c4e:	e9 9e 00 00 00       	jmp    802cf1 <initialize_MemBlocksList+0xd4>
	{
		LIST_INSERT_HEAD(&AvailableMemBlocksList, &(MemBlockNodes[i]));
  802c53:	a1 50 50 80 00       	mov    0x805050,%eax
  802c58:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802c5b:	c1 e2 04             	shl    $0x4,%edx
  802c5e:	01 d0                	add    %edx,%eax
  802c60:	85 c0                	test   %eax,%eax
  802c62:	75 14                	jne    802c78 <initialize_MemBlocksList+0x5b>
  802c64:	83 ec 04             	sub    $0x4,%esp
  802c67:	68 34 46 80 00       	push   $0x804634
  802c6c:	6a 47                	push   $0x47
  802c6e:	68 57 46 80 00       	push   $0x804657
  802c73:	e8 4a e2 ff ff       	call   800ec2 <_panic>
  802c78:	a1 50 50 80 00       	mov    0x805050,%eax
  802c7d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802c80:	c1 e2 04             	shl    $0x4,%edx
  802c83:	01 d0                	add    %edx,%eax
  802c85:	8b 15 48 51 80 00    	mov    0x805148,%edx
  802c8b:	89 10                	mov    %edx,(%eax)
  802c8d:	8b 00                	mov    (%eax),%eax
  802c8f:	85 c0                	test   %eax,%eax
  802c91:	74 18                	je     802cab <initialize_MemBlocksList+0x8e>
  802c93:	a1 48 51 80 00       	mov    0x805148,%eax
  802c98:	8b 15 50 50 80 00    	mov    0x805050,%edx
  802c9e:	8b 4d f4             	mov    -0xc(%ebp),%ecx
  802ca1:	c1 e1 04             	shl    $0x4,%ecx
  802ca4:	01 ca                	add    %ecx,%edx
  802ca6:	89 50 04             	mov    %edx,0x4(%eax)
  802ca9:	eb 12                	jmp    802cbd <initialize_MemBlocksList+0xa0>
  802cab:	a1 50 50 80 00       	mov    0x805050,%eax
  802cb0:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802cb3:	c1 e2 04             	shl    $0x4,%edx
  802cb6:	01 d0                	add    %edx,%eax
  802cb8:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802cbd:	a1 50 50 80 00       	mov    0x805050,%eax
  802cc2:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802cc5:	c1 e2 04             	shl    $0x4,%edx
  802cc8:	01 d0                	add    %edx,%eax
  802cca:	a3 48 51 80 00       	mov    %eax,0x805148
  802ccf:	a1 50 50 80 00       	mov    0x805050,%eax
  802cd4:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802cd7:	c1 e2 04             	shl    $0x4,%edx
  802cda:	01 d0                	add    %edx,%eax
  802cdc:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802ce3:	a1 54 51 80 00       	mov    0x805154,%eax
  802ce8:	40                   	inc    %eax
  802ce9:	a3 54 51 80 00       	mov    %eax,0x805154
	// Write your code here, remove the panic and write your code
	//panic("initialize_MemBlocksList() is not implemented yet...!!");
	uint32 n = numOfBlocks;

	LIST_INIT(&AvailableMemBlocksList);
	for(int i = 0; i<n;i++)
  802cee:	ff 45 f4             	incl   -0xc(%ebp)
  802cf1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cf4:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  802cf7:	0f 82 56 ff ff ff    	jb     802c53 <initialize_MemBlocksList+0x36>
	{
		LIST_INSERT_HEAD(&AvailableMemBlocksList, &(MemBlockNodes[i]));
	}
}
  802cfd:	90                   	nop
  802cfe:	c9                   	leave  
  802cff:	c3                   	ret    

00802d00 <find_block>:

//===============================
// [2] FIND BLOCK:
//===============================
struct MemBlock *find_block(struct MemBlock_List *blockList, uint32 va)
{
  802d00:	55                   	push   %ebp
  802d01:	89 e5                	mov    %esp,%ebp
  802d03:	83 ec 10             	sub    $0x10,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] find_block
	// Write your code here, remove the panic and write your code
	//panic("find_block() is not implemented yet...!!");
	uint32 virAddress = va;
  802d06:	8b 45 0c             	mov    0xc(%ebp),%eax
  802d09:	89 45 f4             	mov    %eax,-0xc(%ebp)
	struct MemBlock* blk;
	int found = 0;
  802d0c:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	LIST_FOREACH(blk, &(AllocMemBlocksList))
  802d13:	a1 40 50 80 00       	mov    0x805040,%eax
  802d18:	89 45 fc             	mov    %eax,-0x4(%ebp)
  802d1b:	eb 23                	jmp    802d40 <find_block+0x40>
	{
		if(blk->sva == virAddress)
  802d1d:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802d20:	8b 40 08             	mov    0x8(%eax),%eax
  802d23:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  802d26:	75 09                	jne    802d31 <find_block+0x31>
		{
			found = 1;
  802d28:	c7 45 f8 01 00 00 00 	movl   $0x1,-0x8(%ebp)
			break;
  802d2f:	eb 35                	jmp    802d66 <find_block+0x66>
		}
		else
		{
			found = 0;
  802d31:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	//panic("find_block() is not implemented yet...!!");
	uint32 virAddress = va;
	struct MemBlock* blk;
	int found = 0;

	LIST_FOREACH(blk, &(AllocMemBlocksList))
  802d38:	a1 48 50 80 00       	mov    0x805048,%eax
  802d3d:	89 45 fc             	mov    %eax,-0x4(%ebp)
  802d40:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  802d44:	74 07                	je     802d4d <find_block+0x4d>
  802d46:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802d49:	8b 00                	mov    (%eax),%eax
  802d4b:	eb 05                	jmp    802d52 <find_block+0x52>
  802d4d:	b8 00 00 00 00       	mov    $0x0,%eax
  802d52:	a3 48 50 80 00       	mov    %eax,0x805048
  802d57:	a1 48 50 80 00       	mov    0x805048,%eax
  802d5c:	85 c0                	test   %eax,%eax
  802d5e:	75 bd                	jne    802d1d <find_block+0x1d>
  802d60:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  802d64:	75 b7                	jne    802d1d <find_block+0x1d>
		{
			found = 0;
			continue;
		}
	}
	if(found == 1)
  802d66:	83 7d f8 01          	cmpl   $0x1,-0x8(%ebp)
  802d6a:	75 05                	jne    802d71 <find_block+0x71>
	{
		return blk;
  802d6c:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802d6f:	eb 05                	jmp    802d76 <find_block+0x76>
	}
	else
	{
		return NULL;
  802d71:	b8 00 00 00 00       	mov    $0x0,%eax
	}
}
  802d76:	c9                   	leave  
  802d77:	c3                   	ret    

00802d78 <insert_sorted_allocList>:

//=========================================
// [3] INSERT BLOCK IN ALLOC LIST [SORTED]:
//=========================================
void insert_sorted_allocList(struct MemBlock *blockToInsert)
{
  802d78:	55                   	push   %ebp
  802d79:	89 e5                	mov    %esp,%ebp
  802d7b:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] insert_sorted_allocList
	// Write your code here, remove the panic and write your code
	//panic("insert_sorted_allocList() is not implemented yet...!!");
	struct MemBlock* blk;
	struct MemBlock* newblk = blockToInsert;
  802d7e:	8b 45 08             	mov    0x8(%ebp),%eax
  802d81:	89 45 f0             	mov    %eax,-0x10(%ebp)

	if((LIST_EMPTY(&AllocMemBlocksList)) || (newblk->sva < LIST_FIRST(&AllocMemBlocksList)->sva))
  802d84:	a1 40 50 80 00       	mov    0x805040,%eax
  802d89:	85 c0                	test   %eax,%eax
  802d8b:	74 12                	je     802d9f <insert_sorted_allocList+0x27>
  802d8d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d90:	8b 50 08             	mov    0x8(%eax),%edx
  802d93:	a1 40 50 80 00       	mov    0x805040,%eax
  802d98:	8b 40 08             	mov    0x8(%eax),%eax
  802d9b:	39 c2                	cmp    %eax,%edx
  802d9d:	73 65                	jae    802e04 <insert_sorted_allocList+0x8c>
	{
		LIST_INSERT_HEAD(&(AllocMemBlocksList), newblk);
  802d9f:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802da3:	75 14                	jne    802db9 <insert_sorted_allocList+0x41>
  802da5:	83 ec 04             	sub    $0x4,%esp
  802da8:	68 34 46 80 00       	push   $0x804634
  802dad:	6a 7b                	push   $0x7b
  802daf:	68 57 46 80 00       	push   $0x804657
  802db4:	e8 09 e1 ff ff       	call   800ec2 <_panic>
  802db9:	8b 15 40 50 80 00    	mov    0x805040,%edx
  802dbf:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802dc2:	89 10                	mov    %edx,(%eax)
  802dc4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802dc7:	8b 00                	mov    (%eax),%eax
  802dc9:	85 c0                	test   %eax,%eax
  802dcb:	74 0d                	je     802dda <insert_sorted_allocList+0x62>
  802dcd:	a1 40 50 80 00       	mov    0x805040,%eax
  802dd2:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802dd5:	89 50 04             	mov    %edx,0x4(%eax)
  802dd8:	eb 08                	jmp    802de2 <insert_sorted_allocList+0x6a>
  802dda:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ddd:	a3 44 50 80 00       	mov    %eax,0x805044
  802de2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802de5:	a3 40 50 80 00       	mov    %eax,0x805040
  802dea:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ded:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802df4:	a1 4c 50 80 00       	mov    0x80504c,%eax
  802df9:	40                   	inc    %eax
  802dfa:	a3 4c 50 80 00       	mov    %eax,0x80504c
  802dff:	e9 5f 01 00 00       	jmp    802f63 <insert_sorted_allocList+0x1eb>
	}
	else if(newblk->sva > LIST_LAST(&AllocMemBlocksList)->sva)
  802e04:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e07:	8b 50 08             	mov    0x8(%eax),%edx
  802e0a:	a1 44 50 80 00       	mov    0x805044,%eax
  802e0f:	8b 40 08             	mov    0x8(%eax),%eax
  802e12:	39 c2                	cmp    %eax,%edx
  802e14:	76 65                	jbe    802e7b <insert_sorted_allocList+0x103>
	{
		LIST_INSERT_TAIL(&AllocMemBlocksList, newblk);
  802e16:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802e1a:	75 14                	jne    802e30 <insert_sorted_allocList+0xb8>
  802e1c:	83 ec 04             	sub    $0x4,%esp
  802e1f:	68 70 46 80 00       	push   $0x804670
  802e24:	6a 7f                	push   $0x7f
  802e26:	68 57 46 80 00       	push   $0x804657
  802e2b:	e8 92 e0 ff ff       	call   800ec2 <_panic>
  802e30:	8b 15 44 50 80 00    	mov    0x805044,%edx
  802e36:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e39:	89 50 04             	mov    %edx,0x4(%eax)
  802e3c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e3f:	8b 40 04             	mov    0x4(%eax),%eax
  802e42:	85 c0                	test   %eax,%eax
  802e44:	74 0c                	je     802e52 <insert_sorted_allocList+0xda>
  802e46:	a1 44 50 80 00       	mov    0x805044,%eax
  802e4b:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802e4e:	89 10                	mov    %edx,(%eax)
  802e50:	eb 08                	jmp    802e5a <insert_sorted_allocList+0xe2>
  802e52:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e55:	a3 40 50 80 00       	mov    %eax,0x805040
  802e5a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e5d:	a3 44 50 80 00       	mov    %eax,0x805044
  802e62:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e65:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802e6b:	a1 4c 50 80 00       	mov    0x80504c,%eax
  802e70:	40                   	inc    %eax
  802e71:	a3 4c 50 80 00       	mov    %eax,0x80504c
				LIST_INSERT_AFTER(&AllocMemBlocksList, blk, newblk);
				break;
			}
		}
	}
}
  802e76:	e9 e8 00 00 00       	jmp    802f63 <insert_sorted_allocList+0x1eb>
	{
		LIST_INSERT_TAIL(&AllocMemBlocksList, newblk);
	}
	else
	{
		LIST_FOREACH(blk, &AllocMemBlocksList)
  802e7b:	a1 40 50 80 00       	mov    0x805040,%eax
  802e80:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802e83:	e9 ab 00 00 00       	jmp    802f33 <insert_sorted_allocList+0x1bb>
		{
			if(blk->prev_next_info.le_next != NULL && newblk->sva > blk->sva  && newblk->sva < blk->prev_next_info.le_next->sva)
  802e88:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e8b:	8b 00                	mov    (%eax),%eax
  802e8d:	85 c0                	test   %eax,%eax
  802e8f:	0f 84 96 00 00 00    	je     802f2b <insert_sorted_allocList+0x1b3>
  802e95:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e98:	8b 50 08             	mov    0x8(%eax),%edx
  802e9b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e9e:	8b 40 08             	mov    0x8(%eax),%eax
  802ea1:	39 c2                	cmp    %eax,%edx
  802ea3:	0f 86 82 00 00 00    	jbe    802f2b <insert_sorted_allocList+0x1b3>
  802ea9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802eac:	8b 50 08             	mov    0x8(%eax),%edx
  802eaf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802eb2:	8b 00                	mov    (%eax),%eax
  802eb4:	8b 40 08             	mov    0x8(%eax),%eax
  802eb7:	39 c2                	cmp    %eax,%edx
  802eb9:	73 70                	jae    802f2b <insert_sorted_allocList+0x1b3>
			{
				LIST_INSERT_AFTER(&AllocMemBlocksList, blk, newblk);
  802ebb:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802ebf:	74 06                	je     802ec7 <insert_sorted_allocList+0x14f>
  802ec1:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802ec5:	75 17                	jne    802ede <insert_sorted_allocList+0x166>
  802ec7:	83 ec 04             	sub    $0x4,%esp
  802eca:	68 94 46 80 00       	push   $0x804694
  802ecf:	68 87 00 00 00       	push   $0x87
  802ed4:	68 57 46 80 00       	push   $0x804657
  802ed9:	e8 e4 df ff ff       	call   800ec2 <_panic>
  802ede:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ee1:	8b 10                	mov    (%eax),%edx
  802ee3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ee6:	89 10                	mov    %edx,(%eax)
  802ee8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802eeb:	8b 00                	mov    (%eax),%eax
  802eed:	85 c0                	test   %eax,%eax
  802eef:	74 0b                	je     802efc <insert_sorted_allocList+0x184>
  802ef1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ef4:	8b 00                	mov    (%eax),%eax
  802ef6:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802ef9:	89 50 04             	mov    %edx,0x4(%eax)
  802efc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802eff:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802f02:	89 10                	mov    %edx,(%eax)
  802f04:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802f07:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802f0a:	89 50 04             	mov    %edx,0x4(%eax)
  802f0d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802f10:	8b 00                	mov    (%eax),%eax
  802f12:	85 c0                	test   %eax,%eax
  802f14:	75 08                	jne    802f1e <insert_sorted_allocList+0x1a6>
  802f16:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802f19:	a3 44 50 80 00       	mov    %eax,0x805044
  802f1e:	a1 4c 50 80 00       	mov    0x80504c,%eax
  802f23:	40                   	inc    %eax
  802f24:	a3 4c 50 80 00       	mov    %eax,0x80504c
				break;
  802f29:	eb 38                	jmp    802f63 <insert_sorted_allocList+0x1eb>
	{
		LIST_INSERT_TAIL(&AllocMemBlocksList, newblk);
	}
	else
	{
		LIST_FOREACH(blk, &AllocMemBlocksList)
  802f2b:	a1 48 50 80 00       	mov    0x805048,%eax
  802f30:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802f33:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802f37:	74 07                	je     802f40 <insert_sorted_allocList+0x1c8>
  802f39:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f3c:	8b 00                	mov    (%eax),%eax
  802f3e:	eb 05                	jmp    802f45 <insert_sorted_allocList+0x1cd>
  802f40:	b8 00 00 00 00       	mov    $0x0,%eax
  802f45:	a3 48 50 80 00       	mov    %eax,0x805048
  802f4a:	a1 48 50 80 00       	mov    0x805048,%eax
  802f4f:	85 c0                	test   %eax,%eax
  802f51:	0f 85 31 ff ff ff    	jne    802e88 <insert_sorted_allocList+0x110>
  802f57:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802f5b:	0f 85 27 ff ff ff    	jne    802e88 <insert_sorted_allocList+0x110>
				LIST_INSERT_AFTER(&AllocMemBlocksList, blk, newblk);
				break;
			}
		}
	}
}
  802f61:	eb 00                	jmp    802f63 <insert_sorted_allocList+0x1eb>
  802f63:	90                   	nop
  802f64:	c9                   	leave  
  802f65:	c3                   	ret    

00802f66 <alloc_block_FF>:

//=========================================
// [4] ALLOCATE BLOCK BY FIRST FIT:
//=========================================
struct MemBlock *alloc_block_FF(uint32 size)
{
  802f66:	55                   	push   %ebp
  802f67:	89 e5                	mov    %esp,%ebp
  802f69:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_FF
	// Write your code here, remove the panic and write your code
	//panic("alloc_block_FF() is not implemented yet...!!");
	uint32 versize = size;
  802f6c:	8b 45 08             	mov    0x8(%ebp),%eax
  802f6f:	89 45 f0             	mov    %eax,-0x10(%ebp)
	struct MemBlock* blk;
	struct MemBlock* newblk = LIST_FIRST(&AvailableMemBlocksList);
  802f72:	a1 48 51 80 00       	mov    0x805148,%eax
  802f77:	89 45 ec             	mov    %eax,-0x14(%ebp)

	LIST_FOREACH(blk,&FreeMemBlocksList)
  802f7a:	a1 38 51 80 00       	mov    0x805138,%eax
  802f7f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802f82:	e9 77 01 00 00       	jmp    8030fe <alloc_block_FF+0x198>
	{
		if(blk->size == versize)
  802f87:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f8a:	8b 40 0c             	mov    0xc(%eax),%eax
  802f8d:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  802f90:	0f 85 8a 00 00 00    	jne    803020 <alloc_block_FF+0xba>
		{
			LIST_REMOVE(&FreeMemBlocksList,blk);
  802f96:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802f9a:	75 17                	jne    802fb3 <alloc_block_FF+0x4d>
  802f9c:	83 ec 04             	sub    $0x4,%esp
  802f9f:	68 c8 46 80 00       	push   $0x8046c8
  802fa4:	68 9e 00 00 00       	push   $0x9e
  802fa9:	68 57 46 80 00       	push   $0x804657
  802fae:	e8 0f df ff ff       	call   800ec2 <_panic>
  802fb3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802fb6:	8b 00                	mov    (%eax),%eax
  802fb8:	85 c0                	test   %eax,%eax
  802fba:	74 10                	je     802fcc <alloc_block_FF+0x66>
  802fbc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802fbf:	8b 00                	mov    (%eax),%eax
  802fc1:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802fc4:	8b 52 04             	mov    0x4(%edx),%edx
  802fc7:	89 50 04             	mov    %edx,0x4(%eax)
  802fca:	eb 0b                	jmp    802fd7 <alloc_block_FF+0x71>
  802fcc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802fcf:	8b 40 04             	mov    0x4(%eax),%eax
  802fd2:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802fd7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802fda:	8b 40 04             	mov    0x4(%eax),%eax
  802fdd:	85 c0                	test   %eax,%eax
  802fdf:	74 0f                	je     802ff0 <alloc_block_FF+0x8a>
  802fe1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802fe4:	8b 40 04             	mov    0x4(%eax),%eax
  802fe7:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802fea:	8b 12                	mov    (%edx),%edx
  802fec:	89 10                	mov    %edx,(%eax)
  802fee:	eb 0a                	jmp    802ffa <alloc_block_FF+0x94>
  802ff0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ff3:	8b 00                	mov    (%eax),%eax
  802ff5:	a3 38 51 80 00       	mov    %eax,0x805138
  802ffa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ffd:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803003:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803006:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80300d:	a1 44 51 80 00       	mov    0x805144,%eax
  803012:	48                   	dec    %eax
  803013:	a3 44 51 80 00       	mov    %eax,0x805144
			return blk;
  803018:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80301b:	e9 11 01 00 00       	jmp    803131 <alloc_block_FF+0x1cb>
		}
		else if(blk->size > versize)
  803020:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803023:	8b 40 0c             	mov    0xc(%eax),%eax
  803026:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  803029:	0f 86 c7 00 00 00    	jbe    8030f6 <alloc_block_FF+0x190>
		{
			LIST_REMOVE(&AvailableMemBlocksList,newblk);
  80302f:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  803033:	75 17                	jne    80304c <alloc_block_FF+0xe6>
  803035:	83 ec 04             	sub    $0x4,%esp
  803038:	68 c8 46 80 00       	push   $0x8046c8
  80303d:	68 a3 00 00 00       	push   $0xa3
  803042:	68 57 46 80 00       	push   $0x804657
  803047:	e8 76 de ff ff       	call   800ec2 <_panic>
  80304c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80304f:	8b 00                	mov    (%eax),%eax
  803051:	85 c0                	test   %eax,%eax
  803053:	74 10                	je     803065 <alloc_block_FF+0xff>
  803055:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803058:	8b 00                	mov    (%eax),%eax
  80305a:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80305d:	8b 52 04             	mov    0x4(%edx),%edx
  803060:	89 50 04             	mov    %edx,0x4(%eax)
  803063:	eb 0b                	jmp    803070 <alloc_block_FF+0x10a>
  803065:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803068:	8b 40 04             	mov    0x4(%eax),%eax
  80306b:	a3 4c 51 80 00       	mov    %eax,0x80514c
  803070:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803073:	8b 40 04             	mov    0x4(%eax),%eax
  803076:	85 c0                	test   %eax,%eax
  803078:	74 0f                	je     803089 <alloc_block_FF+0x123>
  80307a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80307d:	8b 40 04             	mov    0x4(%eax),%eax
  803080:	8b 55 ec             	mov    -0x14(%ebp),%edx
  803083:	8b 12                	mov    (%edx),%edx
  803085:	89 10                	mov    %edx,(%eax)
  803087:	eb 0a                	jmp    803093 <alloc_block_FF+0x12d>
  803089:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80308c:	8b 00                	mov    (%eax),%eax
  80308e:	a3 48 51 80 00       	mov    %eax,0x805148
  803093:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803096:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80309c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80309f:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8030a6:	a1 54 51 80 00       	mov    0x805154,%eax
  8030ab:	48                   	dec    %eax
  8030ac:	a3 54 51 80 00       	mov    %eax,0x805154
			newblk->size = versize;
  8030b1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8030b4:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8030b7:	89 50 0c             	mov    %edx,0xc(%eax)
			blk->size = blk->size-versize;
  8030ba:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030bd:	8b 40 0c             	mov    0xc(%eax),%eax
  8030c0:	2b 45 f0             	sub    -0x10(%ebp),%eax
  8030c3:	89 c2                	mov    %eax,%edx
  8030c5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030c8:	89 50 0c             	mov    %edx,0xc(%eax)
			uint32 newveradd = blk->sva;
  8030cb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030ce:	8b 40 08             	mov    0x8(%eax),%eax
  8030d1:	89 45 e8             	mov    %eax,-0x18(%ebp)
			blk->sva+=newblk->size;
  8030d4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030d7:	8b 50 08             	mov    0x8(%eax),%edx
  8030da:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8030dd:	8b 40 0c             	mov    0xc(%eax),%eax
  8030e0:	01 c2                	add    %eax,%edx
  8030e2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030e5:	89 50 08             	mov    %edx,0x8(%eax)
			newblk->sva = newveradd;
  8030e8:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8030eb:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8030ee:	89 50 08             	mov    %edx,0x8(%eax)
			return newblk;
  8030f1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8030f4:	eb 3b                	jmp    803131 <alloc_block_FF+0x1cb>
	//panic("alloc_block_FF() is not implemented yet...!!");
	uint32 versize = size;
	struct MemBlock* blk;
	struct MemBlock* newblk = LIST_FIRST(&AvailableMemBlocksList);

	LIST_FOREACH(blk,&FreeMemBlocksList)
  8030f6:	a1 40 51 80 00       	mov    0x805140,%eax
  8030fb:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8030fe:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803102:	74 07                	je     80310b <alloc_block_FF+0x1a5>
  803104:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803107:	8b 00                	mov    (%eax),%eax
  803109:	eb 05                	jmp    803110 <alloc_block_FF+0x1aa>
  80310b:	b8 00 00 00 00       	mov    $0x0,%eax
  803110:	a3 40 51 80 00       	mov    %eax,0x805140
  803115:	a1 40 51 80 00       	mov    0x805140,%eax
  80311a:	85 c0                	test   %eax,%eax
  80311c:	0f 85 65 fe ff ff    	jne    802f87 <alloc_block_FF+0x21>
  803122:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803126:	0f 85 5b fe ff ff    	jne    802f87 <alloc_block_FF+0x21>
			blk->sva+=newblk->size;
			newblk->sva = newveradd;
			return newblk;
		}
	}
	return NULL;
  80312c:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803131:	c9                   	leave  
  803132:	c3                   	ret    

00803133 <alloc_block_BF>:

//=========================================
// [5] ALLOCATE BLOCK BY BEST FIT:
//=========================================
struct MemBlock *alloc_block_BF(uint32 size)
{
  803133:	55                   	push   %ebp
  803134:	89 e5                	mov    %esp,%ebp
  803136:	83 ec 28             	sub    $0x28,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_BF
	// Write your code here, remove the panic and write your code
	//panic("alloc_block_BF() is not implemented yet...!!");
	uint32 versize=size;
  803139:	8b 45 08             	mov    0x8(%ebp),%eax
  80313c:	89 45 e8             	mov    %eax,-0x18(%ebp)
	struct MemBlock* blk;
	struct MemBlock* newblk=LIST_FIRST(&AvailableMemBlocksList);
  80313f:	a1 48 51 80 00       	mov    0x805148,%eax
  803144:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	uint32 newveradd;
	uint32 newsize;
	int size_free = LIST_SIZE(&FreeMemBlocksList);
  803147:	a1 44 51 80 00       	mov    0x805144,%eax
  80314c:	89 45 e0             	mov    %eax,-0x20(%ebp)

	LIST_FOREACH(blk, &FreeMemBlocksList)
  80314f:	a1 38 51 80 00       	mov    0x805138,%eax
  803154:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803157:	e9 a1 00 00 00       	jmp    8031fd <alloc_block_BF+0xca>
	{
		if(blk->size == versize)
  80315c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80315f:	8b 40 0c             	mov    0xc(%eax),%eax
  803162:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  803165:	0f 85 8a 00 00 00    	jne    8031f5 <alloc_block_BF+0xc2>
		{
			LIST_REMOVE(&FreeMemBlocksList, blk);
  80316b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80316f:	75 17                	jne    803188 <alloc_block_BF+0x55>
  803171:	83 ec 04             	sub    $0x4,%esp
  803174:	68 c8 46 80 00       	push   $0x8046c8
  803179:	68 c2 00 00 00       	push   $0xc2
  80317e:	68 57 46 80 00       	push   $0x804657
  803183:	e8 3a dd ff ff       	call   800ec2 <_panic>
  803188:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80318b:	8b 00                	mov    (%eax),%eax
  80318d:	85 c0                	test   %eax,%eax
  80318f:	74 10                	je     8031a1 <alloc_block_BF+0x6e>
  803191:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803194:	8b 00                	mov    (%eax),%eax
  803196:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803199:	8b 52 04             	mov    0x4(%edx),%edx
  80319c:	89 50 04             	mov    %edx,0x4(%eax)
  80319f:	eb 0b                	jmp    8031ac <alloc_block_BF+0x79>
  8031a1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8031a4:	8b 40 04             	mov    0x4(%eax),%eax
  8031a7:	a3 3c 51 80 00       	mov    %eax,0x80513c
  8031ac:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8031af:	8b 40 04             	mov    0x4(%eax),%eax
  8031b2:	85 c0                	test   %eax,%eax
  8031b4:	74 0f                	je     8031c5 <alloc_block_BF+0x92>
  8031b6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8031b9:	8b 40 04             	mov    0x4(%eax),%eax
  8031bc:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8031bf:	8b 12                	mov    (%edx),%edx
  8031c1:	89 10                	mov    %edx,(%eax)
  8031c3:	eb 0a                	jmp    8031cf <alloc_block_BF+0x9c>
  8031c5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8031c8:	8b 00                	mov    (%eax),%eax
  8031ca:	a3 38 51 80 00       	mov    %eax,0x805138
  8031cf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8031d2:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8031d8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8031db:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8031e2:	a1 44 51 80 00       	mov    0x805144,%eax
  8031e7:	48                   	dec    %eax
  8031e8:	a3 44 51 80 00       	mov    %eax,0x805144
			return blk;
  8031ed:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8031f0:	e9 11 02 00 00       	jmp    803406 <alloc_block_BF+0x2d3>
	struct MemBlock* newblk=LIST_FIRST(&AvailableMemBlocksList);
	uint32 newveradd;
	uint32 newsize;
	int size_free = LIST_SIZE(&FreeMemBlocksList);

	LIST_FOREACH(blk, &FreeMemBlocksList)
  8031f5:	a1 40 51 80 00       	mov    0x805140,%eax
  8031fa:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8031fd:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803201:	74 07                	je     80320a <alloc_block_BF+0xd7>
  803203:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803206:	8b 00                	mov    (%eax),%eax
  803208:	eb 05                	jmp    80320f <alloc_block_BF+0xdc>
  80320a:	b8 00 00 00 00       	mov    $0x0,%eax
  80320f:	a3 40 51 80 00       	mov    %eax,0x805140
  803214:	a1 40 51 80 00       	mov    0x805140,%eax
  803219:	85 c0                	test   %eax,%eax
  80321b:	0f 85 3b ff ff ff    	jne    80315c <alloc_block_BF+0x29>
  803221:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803225:	0f 85 31 ff ff ff    	jne    80315c <alloc_block_BF+0x29>
		{
			LIST_REMOVE(&FreeMemBlocksList, blk);
			return blk;
		}
	}
	LIST_FOREACH(blk, &FreeMemBlocksList)
  80322b:	a1 38 51 80 00       	mov    0x805138,%eax
  803230:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803233:	eb 27                	jmp    80325c <alloc_block_BF+0x129>
	{
		if(blk->size > versize)
  803235:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803238:	8b 40 0c             	mov    0xc(%eax),%eax
  80323b:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  80323e:	76 14                	jbe    803254 <alloc_block_BF+0x121>
		{
			newsize = blk->size;
  803240:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803243:	8b 40 0c             	mov    0xc(%eax),%eax
  803246:	89 45 ec             	mov    %eax,-0x14(%ebp)
			newveradd = blk->sva;
  803249:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80324c:	8b 40 08             	mov    0x8(%eax),%eax
  80324f:	89 45 f0             	mov    %eax,-0x10(%ebp)
			break;
  803252:	eb 2e                	jmp    803282 <alloc_block_BF+0x14f>
		{
			LIST_REMOVE(&FreeMemBlocksList, blk);
			return blk;
		}
	}
	LIST_FOREACH(blk, &FreeMemBlocksList)
  803254:	a1 40 51 80 00       	mov    0x805140,%eax
  803259:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80325c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803260:	74 07                	je     803269 <alloc_block_BF+0x136>
  803262:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803265:	8b 00                	mov    (%eax),%eax
  803267:	eb 05                	jmp    80326e <alloc_block_BF+0x13b>
  803269:	b8 00 00 00 00       	mov    $0x0,%eax
  80326e:	a3 40 51 80 00       	mov    %eax,0x805140
  803273:	a1 40 51 80 00       	mov    0x805140,%eax
  803278:	85 c0                	test   %eax,%eax
  80327a:	75 b9                	jne    803235 <alloc_block_BF+0x102>
  80327c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803280:	75 b3                	jne    803235 <alloc_block_BF+0x102>
			newsize = blk->size;
			newveradd = blk->sva;
			break;
		}
	}
	LIST_FOREACH(blk, &FreeMemBlocksList)
  803282:	a1 38 51 80 00       	mov    0x805138,%eax
  803287:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80328a:	eb 30                	jmp    8032bc <alloc_block_BF+0x189>
	{
		if(newsize > blk->size && blk->size > versize)
  80328c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80328f:	8b 40 0c             	mov    0xc(%eax),%eax
  803292:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  803295:	73 1d                	jae    8032b4 <alloc_block_BF+0x181>
  803297:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80329a:	8b 40 0c             	mov    0xc(%eax),%eax
  80329d:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  8032a0:	76 12                	jbe    8032b4 <alloc_block_BF+0x181>
		{
	       newsize = blk->size;
  8032a2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8032a5:	8b 40 0c             	mov    0xc(%eax),%eax
  8032a8:	89 45 ec             	mov    %eax,-0x14(%ebp)
		   newveradd = blk->sva;
  8032ab:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8032ae:	8b 40 08             	mov    0x8(%eax),%eax
  8032b1:	89 45 f0             	mov    %eax,-0x10(%ebp)
			newsize = blk->size;
			newveradd = blk->sva;
			break;
		}
	}
	LIST_FOREACH(blk, &FreeMemBlocksList)
  8032b4:	a1 40 51 80 00       	mov    0x805140,%eax
  8032b9:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8032bc:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8032c0:	74 07                	je     8032c9 <alloc_block_BF+0x196>
  8032c2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8032c5:	8b 00                	mov    (%eax),%eax
  8032c7:	eb 05                	jmp    8032ce <alloc_block_BF+0x19b>
  8032c9:	b8 00 00 00 00       	mov    $0x0,%eax
  8032ce:	a3 40 51 80 00       	mov    %eax,0x805140
  8032d3:	a1 40 51 80 00       	mov    0x805140,%eax
  8032d8:	85 c0                	test   %eax,%eax
  8032da:	75 b0                	jne    80328c <alloc_block_BF+0x159>
  8032dc:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8032e0:	75 aa                	jne    80328c <alloc_block_BF+0x159>
		{
	       newsize = blk->size;
		   newveradd = blk->sva;
		}
	}
	LIST_FOREACH(blk, &FreeMemBlocksList)
  8032e2:	a1 38 51 80 00       	mov    0x805138,%eax
  8032e7:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8032ea:	e9 e4 00 00 00       	jmp    8033d3 <alloc_block_BF+0x2a0>
	{
		if(blk->size == newsize && blk->sva == newveradd)
  8032ef:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8032f2:	8b 40 0c             	mov    0xc(%eax),%eax
  8032f5:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  8032f8:	0f 85 cd 00 00 00    	jne    8033cb <alloc_block_BF+0x298>
  8032fe:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803301:	8b 40 08             	mov    0x8(%eax),%eax
  803304:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  803307:	0f 85 be 00 00 00    	jne    8033cb <alloc_block_BF+0x298>
		{
			LIST_REMOVE(&AvailableMemBlocksList, newblk);
  80330d:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  803311:	75 17                	jne    80332a <alloc_block_BF+0x1f7>
  803313:	83 ec 04             	sub    $0x4,%esp
  803316:	68 c8 46 80 00       	push   $0x8046c8
  80331b:	68 db 00 00 00       	push   $0xdb
  803320:	68 57 46 80 00       	push   $0x804657
  803325:	e8 98 db ff ff       	call   800ec2 <_panic>
  80332a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80332d:	8b 00                	mov    (%eax),%eax
  80332f:	85 c0                	test   %eax,%eax
  803331:	74 10                	je     803343 <alloc_block_BF+0x210>
  803333:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803336:	8b 00                	mov    (%eax),%eax
  803338:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80333b:	8b 52 04             	mov    0x4(%edx),%edx
  80333e:	89 50 04             	mov    %edx,0x4(%eax)
  803341:	eb 0b                	jmp    80334e <alloc_block_BF+0x21b>
  803343:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803346:	8b 40 04             	mov    0x4(%eax),%eax
  803349:	a3 4c 51 80 00       	mov    %eax,0x80514c
  80334e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803351:	8b 40 04             	mov    0x4(%eax),%eax
  803354:	85 c0                	test   %eax,%eax
  803356:	74 0f                	je     803367 <alloc_block_BF+0x234>
  803358:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80335b:	8b 40 04             	mov    0x4(%eax),%eax
  80335e:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803361:	8b 12                	mov    (%edx),%edx
  803363:	89 10                	mov    %edx,(%eax)
  803365:	eb 0a                	jmp    803371 <alloc_block_BF+0x23e>
  803367:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80336a:	8b 00                	mov    (%eax),%eax
  80336c:	a3 48 51 80 00       	mov    %eax,0x805148
  803371:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803374:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80337a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80337d:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803384:	a1 54 51 80 00       	mov    0x805154,%eax
  803389:	48                   	dec    %eax
  80338a:	a3 54 51 80 00       	mov    %eax,0x805154
			newblk->size = versize;
  80338f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803392:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803395:	89 50 0c             	mov    %edx,0xc(%eax)
			newblk->sva = newveradd;
  803398:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80339b:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80339e:	89 50 08             	mov    %edx,0x8(%eax)
			blk->size = blk->size - versize;
  8033a1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8033a4:	8b 40 0c             	mov    0xc(%eax),%eax
  8033a7:	2b 45 e8             	sub    -0x18(%ebp),%eax
  8033aa:	89 c2                	mov    %eax,%edx
  8033ac:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8033af:	89 50 0c             	mov    %edx,0xc(%eax)
			blk->sva+= newblk->size;
  8033b2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8033b5:	8b 50 08             	mov    0x8(%eax),%edx
  8033b8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8033bb:	8b 40 0c             	mov    0xc(%eax),%eax
  8033be:	01 c2                	add    %eax,%edx
  8033c0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8033c3:	89 50 08             	mov    %edx,0x8(%eax)
			return newblk;
  8033c6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8033c9:	eb 3b                	jmp    803406 <alloc_block_BF+0x2d3>
		{
	       newsize = blk->size;
		   newveradd = blk->sva;
		}
	}
	LIST_FOREACH(blk, &FreeMemBlocksList)
  8033cb:	a1 40 51 80 00       	mov    0x805140,%eax
  8033d0:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8033d3:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8033d7:	74 07                	je     8033e0 <alloc_block_BF+0x2ad>
  8033d9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8033dc:	8b 00                	mov    (%eax),%eax
  8033de:	eb 05                	jmp    8033e5 <alloc_block_BF+0x2b2>
  8033e0:	b8 00 00 00 00       	mov    $0x0,%eax
  8033e5:	a3 40 51 80 00       	mov    %eax,0x805140
  8033ea:	a1 40 51 80 00       	mov    0x805140,%eax
  8033ef:	85 c0                	test   %eax,%eax
  8033f1:	0f 85 f8 fe ff ff    	jne    8032ef <alloc_block_BF+0x1bc>
  8033f7:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8033fb:	0f 85 ee fe ff ff    	jne    8032ef <alloc_block_BF+0x1bc>
			blk->size = blk->size - versize;
			blk->sva+= newblk->size;
			return newblk;
		}
	}
	return NULL;
  803401:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803406:	c9                   	leave  
  803407:	c3                   	ret    

00803408 <alloc_block_NF>:
//=========================================
// [7] ALLOCATE BLOCK BY NEXT FIT:
//=========================================
struct MemBlock *last_allocate;
struct MemBlock *alloc_block_NF(uint32 size)
{
  803408:	55                   	push   %ebp
  803409:	89 e5                	mov    %esp,%ebp
  80340b:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1 - BONUS] [DYNAMIC ALLOCATOR] alloc_block_NF
	// Write your code here, remove the panic and write your code
	//panic("alloc_block_NF() is not implemented yet...!!");
	uint32 versize = size;
  80340e:	8b 45 08             	mov    0x8(%ebp),%eax
  803411:	89 45 f0             	mov    %eax,-0x10(%ebp)
	struct MemBlock* blk;
	struct MemBlock* newblk = LIST_FIRST(&AvailableMemBlocksList);
  803414:	a1 48 51 80 00       	mov    0x805148,%eax
  803419:	89 45 ec             	mov    %eax,-0x14(%ebp)

	LIST_FOREACH(blk,&FreeMemBlocksList)
  80341c:	a1 38 51 80 00       	mov    0x805138,%eax
  803421:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803424:	e9 77 01 00 00       	jmp    8035a0 <alloc_block_NF+0x198>
	{
		if(blk->size == versize)
  803429:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80342c:	8b 40 0c             	mov    0xc(%eax),%eax
  80342f:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  803432:	0f 85 8a 00 00 00    	jne    8034c2 <alloc_block_NF+0xba>
		{
			LIST_REMOVE(&FreeMemBlocksList,blk);
  803438:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80343c:	75 17                	jne    803455 <alloc_block_NF+0x4d>
  80343e:	83 ec 04             	sub    $0x4,%esp
  803441:	68 c8 46 80 00       	push   $0x8046c8
  803446:	68 f7 00 00 00       	push   $0xf7
  80344b:	68 57 46 80 00       	push   $0x804657
  803450:	e8 6d da ff ff       	call   800ec2 <_panic>
  803455:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803458:	8b 00                	mov    (%eax),%eax
  80345a:	85 c0                	test   %eax,%eax
  80345c:	74 10                	je     80346e <alloc_block_NF+0x66>
  80345e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803461:	8b 00                	mov    (%eax),%eax
  803463:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803466:	8b 52 04             	mov    0x4(%edx),%edx
  803469:	89 50 04             	mov    %edx,0x4(%eax)
  80346c:	eb 0b                	jmp    803479 <alloc_block_NF+0x71>
  80346e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803471:	8b 40 04             	mov    0x4(%eax),%eax
  803474:	a3 3c 51 80 00       	mov    %eax,0x80513c
  803479:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80347c:	8b 40 04             	mov    0x4(%eax),%eax
  80347f:	85 c0                	test   %eax,%eax
  803481:	74 0f                	je     803492 <alloc_block_NF+0x8a>
  803483:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803486:	8b 40 04             	mov    0x4(%eax),%eax
  803489:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80348c:	8b 12                	mov    (%edx),%edx
  80348e:	89 10                	mov    %edx,(%eax)
  803490:	eb 0a                	jmp    80349c <alloc_block_NF+0x94>
  803492:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803495:	8b 00                	mov    (%eax),%eax
  803497:	a3 38 51 80 00       	mov    %eax,0x805138
  80349c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80349f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8034a5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8034a8:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8034af:	a1 44 51 80 00       	mov    0x805144,%eax
  8034b4:	48                   	dec    %eax
  8034b5:	a3 44 51 80 00       	mov    %eax,0x805144
			return blk;
  8034ba:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8034bd:	e9 11 01 00 00       	jmp    8035d3 <alloc_block_NF+0x1cb>
		}
		else if(blk->size > versize)
  8034c2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8034c5:	8b 40 0c             	mov    0xc(%eax),%eax
  8034c8:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8034cb:	0f 86 c7 00 00 00    	jbe    803598 <alloc_block_NF+0x190>
		{
			LIST_REMOVE(&AvailableMemBlocksList,newblk);
  8034d1:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8034d5:	75 17                	jne    8034ee <alloc_block_NF+0xe6>
  8034d7:	83 ec 04             	sub    $0x4,%esp
  8034da:	68 c8 46 80 00       	push   $0x8046c8
  8034df:	68 fc 00 00 00       	push   $0xfc
  8034e4:	68 57 46 80 00       	push   $0x804657
  8034e9:	e8 d4 d9 ff ff       	call   800ec2 <_panic>
  8034ee:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8034f1:	8b 00                	mov    (%eax),%eax
  8034f3:	85 c0                	test   %eax,%eax
  8034f5:	74 10                	je     803507 <alloc_block_NF+0xff>
  8034f7:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8034fa:	8b 00                	mov    (%eax),%eax
  8034fc:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8034ff:	8b 52 04             	mov    0x4(%edx),%edx
  803502:	89 50 04             	mov    %edx,0x4(%eax)
  803505:	eb 0b                	jmp    803512 <alloc_block_NF+0x10a>
  803507:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80350a:	8b 40 04             	mov    0x4(%eax),%eax
  80350d:	a3 4c 51 80 00       	mov    %eax,0x80514c
  803512:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803515:	8b 40 04             	mov    0x4(%eax),%eax
  803518:	85 c0                	test   %eax,%eax
  80351a:	74 0f                	je     80352b <alloc_block_NF+0x123>
  80351c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80351f:	8b 40 04             	mov    0x4(%eax),%eax
  803522:	8b 55 ec             	mov    -0x14(%ebp),%edx
  803525:	8b 12                	mov    (%edx),%edx
  803527:	89 10                	mov    %edx,(%eax)
  803529:	eb 0a                	jmp    803535 <alloc_block_NF+0x12d>
  80352b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80352e:	8b 00                	mov    (%eax),%eax
  803530:	a3 48 51 80 00       	mov    %eax,0x805148
  803535:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803538:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80353e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803541:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803548:	a1 54 51 80 00       	mov    0x805154,%eax
  80354d:	48                   	dec    %eax
  80354e:	a3 54 51 80 00       	mov    %eax,0x805154
			newblk->size = versize;
  803553:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803556:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803559:	89 50 0c             	mov    %edx,0xc(%eax)
			blk->size = blk->size-versize;
  80355c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80355f:	8b 40 0c             	mov    0xc(%eax),%eax
  803562:	2b 45 f0             	sub    -0x10(%ebp),%eax
  803565:	89 c2                	mov    %eax,%edx
  803567:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80356a:	89 50 0c             	mov    %edx,0xc(%eax)
			uint32 newveradd = blk->sva;
  80356d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803570:	8b 40 08             	mov    0x8(%eax),%eax
  803573:	89 45 e8             	mov    %eax,-0x18(%ebp)
			blk->sva+=newblk->size;
  803576:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803579:	8b 50 08             	mov    0x8(%eax),%edx
  80357c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80357f:	8b 40 0c             	mov    0xc(%eax),%eax
  803582:	01 c2                	add    %eax,%edx
  803584:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803587:	89 50 08             	mov    %edx,0x8(%eax)
			newblk->sva = newveradd;
  80358a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80358d:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803590:	89 50 08             	mov    %edx,0x8(%eax)
			return newblk;
  803593:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803596:	eb 3b                	jmp    8035d3 <alloc_block_NF+0x1cb>
	//panic("alloc_block_NF() is not implemented yet...!!");
	uint32 versize = size;
	struct MemBlock* blk;
	struct MemBlock* newblk = LIST_FIRST(&AvailableMemBlocksList);

	LIST_FOREACH(blk,&FreeMemBlocksList)
  803598:	a1 40 51 80 00       	mov    0x805140,%eax
  80359d:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8035a0:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8035a4:	74 07                	je     8035ad <alloc_block_NF+0x1a5>
  8035a6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8035a9:	8b 00                	mov    (%eax),%eax
  8035ab:	eb 05                	jmp    8035b2 <alloc_block_NF+0x1aa>
  8035ad:	b8 00 00 00 00       	mov    $0x0,%eax
  8035b2:	a3 40 51 80 00       	mov    %eax,0x805140
  8035b7:	a1 40 51 80 00       	mov    0x805140,%eax
  8035bc:	85 c0                	test   %eax,%eax
  8035be:	0f 85 65 fe ff ff    	jne    803429 <alloc_block_NF+0x21>
  8035c4:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8035c8:	0f 85 5b fe ff ff    	jne    803429 <alloc_block_NF+0x21>
			blk->sva+=newblk->size;
			newblk->sva = newveradd;
			return newblk;
		}
	}
	return NULL;
  8035ce:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8035d3:	c9                   	leave  
  8035d4:	c3                   	ret    

008035d5 <addToAvailMemBlocksList>:

//===================================================
// [8] INSERT BLOCK (SORTED WITH MERGE) IN FREE LIST:
//===================================================
void addToAvailMemBlocksList(struct MemBlock *blockToInsert)
{
  8035d5:	55                   	push   %ebp
  8035d6:	89 e5                	mov    %esp,%ebp
  8035d8:	83 ec 08             	sub    $0x8,%esp
	blockToInsert->sva = 0;
  8035db:	8b 45 08             	mov    0x8(%ebp),%eax
  8035de:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
	blockToInsert->size = 0;
  8035e5:	8b 45 08             	mov    0x8(%ebp),%eax
  8035e8:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
	//add to avail
	LIST_INSERT_TAIL(&AvailableMemBlocksList, blockToInsert);
  8035ef:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8035f3:	75 17                	jne    80360c <addToAvailMemBlocksList+0x37>
  8035f5:	83 ec 04             	sub    $0x4,%esp
  8035f8:	68 70 46 80 00       	push   $0x804670
  8035fd:	68 10 01 00 00       	push   $0x110
  803602:	68 57 46 80 00       	push   $0x804657
  803607:	e8 b6 d8 ff ff       	call   800ec2 <_panic>
  80360c:	8b 15 4c 51 80 00    	mov    0x80514c,%edx
  803612:	8b 45 08             	mov    0x8(%ebp),%eax
  803615:	89 50 04             	mov    %edx,0x4(%eax)
  803618:	8b 45 08             	mov    0x8(%ebp),%eax
  80361b:	8b 40 04             	mov    0x4(%eax),%eax
  80361e:	85 c0                	test   %eax,%eax
  803620:	74 0c                	je     80362e <addToAvailMemBlocksList+0x59>
  803622:	a1 4c 51 80 00       	mov    0x80514c,%eax
  803627:	8b 55 08             	mov    0x8(%ebp),%edx
  80362a:	89 10                	mov    %edx,(%eax)
  80362c:	eb 08                	jmp    803636 <addToAvailMemBlocksList+0x61>
  80362e:	8b 45 08             	mov    0x8(%ebp),%eax
  803631:	a3 48 51 80 00       	mov    %eax,0x805148
  803636:	8b 45 08             	mov    0x8(%ebp),%eax
  803639:	a3 4c 51 80 00       	mov    %eax,0x80514c
  80363e:	8b 45 08             	mov    0x8(%ebp),%eax
  803641:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803647:	a1 54 51 80 00       	mov    0x805154,%eax
  80364c:	40                   	inc    %eax
  80364d:	a3 54 51 80 00       	mov    %eax,0x805154
}
  803652:	90                   	nop
  803653:	c9                   	leave  
  803654:	c3                   	ret    

00803655 <insert_sorted_with_merge_freeList>:
void insert_sorted_with_merge_freeList(struct MemBlock *blockToInsert)
{
  803655:	55                   	push   %ebp
  803656:	89 e5                	mov    %esp,%ebp
  803658:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] insert_sorted_with_merge_freeList
	// Write your code here, remove the panic and write your code

	struct MemBlock* last = LIST_LAST(&FreeMemBlocksList);
  80365b:	a1 3c 51 80 00       	mov    0x80513c,%eax
  803660:	89 45 f0             	mov    %eax,-0x10(%ebp)
	//check if list empty
	if (LIST_SIZE(&(FreeMemBlocksList)) == 0)
  803663:	a1 44 51 80 00       	mov    0x805144,%eax
  803668:	85 c0                	test   %eax,%eax
  80366a:	75 68                	jne    8036d4 <insert_sorted_with_merge_freeList+0x7f>
		LIST_INSERT_HEAD(&FreeMemBlocksList, blockToInsert);
  80366c:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803670:	75 17                	jne    803689 <insert_sorted_with_merge_freeList+0x34>
  803672:	83 ec 04             	sub    $0x4,%esp
  803675:	68 34 46 80 00       	push   $0x804634
  80367a:	68 1a 01 00 00       	push   $0x11a
  80367f:	68 57 46 80 00       	push   $0x804657
  803684:	e8 39 d8 ff ff       	call   800ec2 <_panic>
  803689:	8b 15 38 51 80 00    	mov    0x805138,%edx
  80368f:	8b 45 08             	mov    0x8(%ebp),%eax
  803692:	89 10                	mov    %edx,(%eax)
  803694:	8b 45 08             	mov    0x8(%ebp),%eax
  803697:	8b 00                	mov    (%eax),%eax
  803699:	85 c0                	test   %eax,%eax
  80369b:	74 0d                	je     8036aa <insert_sorted_with_merge_freeList+0x55>
  80369d:	a1 38 51 80 00       	mov    0x805138,%eax
  8036a2:	8b 55 08             	mov    0x8(%ebp),%edx
  8036a5:	89 50 04             	mov    %edx,0x4(%eax)
  8036a8:	eb 08                	jmp    8036b2 <insert_sorted_with_merge_freeList+0x5d>
  8036aa:	8b 45 08             	mov    0x8(%ebp),%eax
  8036ad:	a3 3c 51 80 00       	mov    %eax,0x80513c
  8036b2:	8b 45 08             	mov    0x8(%ebp),%eax
  8036b5:	a3 38 51 80 00       	mov    %eax,0x805138
  8036ba:	8b 45 08             	mov    0x8(%ebp),%eax
  8036bd:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8036c4:	a1 44 51 80 00       	mov    0x805144,%eax
  8036c9:	40                   	inc    %eax
  8036ca:	a3 44 51 80 00       	mov    %eax,0x805144
		}
	}

	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  8036cf:	e9 c5 03 00 00       	jmp    803a99 <insert_sorted_with_merge_freeList+0x444>
	struct MemBlock* last = LIST_LAST(&FreeMemBlocksList);
	//check if list empty
	if (LIST_SIZE(&(FreeMemBlocksList)) == 0)
		LIST_INSERT_HEAD(&FreeMemBlocksList, blockToInsert);
	//check if it's position is at last
	else if (last->sva < blockToInsert->sva) {
  8036d4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8036d7:	8b 50 08             	mov    0x8(%eax),%edx
  8036da:	8b 45 08             	mov    0x8(%ebp),%eax
  8036dd:	8b 40 08             	mov    0x8(%eax),%eax
  8036e0:	39 c2                	cmp    %eax,%edx
  8036e2:	0f 83 b2 00 00 00    	jae    80379a <insert_sorted_with_merge_freeList+0x145>

		//if i have to merge
		if (last->sva + last->size == blockToInsert->sva) {
  8036e8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8036eb:	8b 50 08             	mov    0x8(%eax),%edx
  8036ee:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8036f1:	8b 40 0c             	mov    0xc(%eax),%eax
  8036f4:	01 c2                	add    %eax,%edx
  8036f6:	8b 45 08             	mov    0x8(%ebp),%eax
  8036f9:	8b 40 08             	mov    0x8(%eax),%eax
  8036fc:	39 c2                	cmp    %eax,%edx
  8036fe:	75 27                	jne    803727 <insert_sorted_with_merge_freeList+0xd2>
			last->size = last->size + blockToInsert->size;
  803700:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803703:	8b 50 0c             	mov    0xc(%eax),%edx
  803706:	8b 45 08             	mov    0x8(%ebp),%eax
  803709:	8b 40 0c             	mov    0xc(%eax),%eax
  80370c:	01 c2                	add    %eax,%edx
  80370e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803711:	89 50 0c             	mov    %edx,0xc(%eax)
			addToAvailMemBlocksList(blockToInsert);
  803714:	83 ec 0c             	sub    $0xc,%esp
  803717:	ff 75 08             	pushl  0x8(%ebp)
  80371a:	e8 b6 fe ff ff       	call   8035d5 <addToAvailMemBlocksList>
  80371f:	83 c4 10             	add    $0x10,%esp
		}
	}

	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  803722:	e9 72 03 00 00       	jmp    803a99 <insert_sorted_with_merge_freeList+0x444>
		if (last->sva + last->size == blockToInsert->sva) {
			last->size = last->size + blockToInsert->size;
			addToAvailMemBlocksList(blockToInsert);

		} else {
			LIST_INSERT_AFTER(&FreeMemBlocksList, last, blockToInsert);
  803727:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80372b:	74 06                	je     803733 <insert_sorted_with_merge_freeList+0xde>
  80372d:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803731:	75 17                	jne    80374a <insert_sorted_with_merge_freeList+0xf5>
  803733:	83 ec 04             	sub    $0x4,%esp
  803736:	68 94 46 80 00       	push   $0x804694
  80373b:	68 24 01 00 00       	push   $0x124
  803740:	68 57 46 80 00       	push   $0x804657
  803745:	e8 78 d7 ff ff       	call   800ec2 <_panic>
  80374a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80374d:	8b 10                	mov    (%eax),%edx
  80374f:	8b 45 08             	mov    0x8(%ebp),%eax
  803752:	89 10                	mov    %edx,(%eax)
  803754:	8b 45 08             	mov    0x8(%ebp),%eax
  803757:	8b 00                	mov    (%eax),%eax
  803759:	85 c0                	test   %eax,%eax
  80375b:	74 0b                	je     803768 <insert_sorted_with_merge_freeList+0x113>
  80375d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803760:	8b 00                	mov    (%eax),%eax
  803762:	8b 55 08             	mov    0x8(%ebp),%edx
  803765:	89 50 04             	mov    %edx,0x4(%eax)
  803768:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80376b:	8b 55 08             	mov    0x8(%ebp),%edx
  80376e:	89 10                	mov    %edx,(%eax)
  803770:	8b 45 08             	mov    0x8(%ebp),%eax
  803773:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803776:	89 50 04             	mov    %edx,0x4(%eax)
  803779:	8b 45 08             	mov    0x8(%ebp),%eax
  80377c:	8b 00                	mov    (%eax),%eax
  80377e:	85 c0                	test   %eax,%eax
  803780:	75 08                	jne    80378a <insert_sorted_with_merge_freeList+0x135>
  803782:	8b 45 08             	mov    0x8(%ebp),%eax
  803785:	a3 3c 51 80 00       	mov    %eax,0x80513c
  80378a:	a1 44 51 80 00       	mov    0x805144,%eax
  80378f:	40                   	inc    %eax
  803790:	a3 44 51 80 00       	mov    %eax,0x805144
		}
	}

	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  803795:	e9 ff 02 00 00       	jmp    803a99 <insert_sorted_with_merge_freeList+0x444>
		} else {
			LIST_INSERT_AFTER(&FreeMemBlocksList, last, blockToInsert);
		}
	} else {
		struct MemBlock *iterator;
		LIST_FOREACH(iterator, &(FreeMemBlocksList))
  80379a:	a1 38 51 80 00       	mov    0x805138,%eax
  80379f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8037a2:	e9 c2 02 00 00       	jmp    803a69 <insert_sorted_with_merge_freeList+0x414>
		{

			if (iterator->sva > blockToInsert->sva) {
  8037a7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8037aa:	8b 50 08             	mov    0x8(%eax),%edx
  8037ad:	8b 45 08             	mov    0x8(%ebp),%eax
  8037b0:	8b 40 08             	mov    0x8(%eax),%eax
  8037b3:	39 c2                	cmp    %eax,%edx
  8037b5:	0f 86 a6 02 00 00    	jbe    803a61 <insert_sorted_with_merge_freeList+0x40c>

				struct MemBlock* prev = LIST_PREV(iterator);
  8037bb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8037be:	8b 40 04             	mov    0x4(%eax),%eax
  8037c1:	89 45 ec             	mov    %eax,-0x14(%ebp)
				if (prev == NULL) {
  8037c4:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8037c8:	0f 85 ba 00 00 00    	jne    803888 <insert_sorted_with_merge_freeList+0x233>
					//check merge
					if (blockToInsert->size + blockToInsert->sva
  8037ce:	8b 45 08             	mov    0x8(%ebp),%eax
  8037d1:	8b 50 0c             	mov    0xc(%eax),%edx
  8037d4:	8b 45 08             	mov    0x8(%ebp),%eax
  8037d7:	8b 40 08             	mov    0x8(%eax),%eax
  8037da:	01 c2                	add    %eax,%edx
							== iterator->sva) {
  8037dc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8037df:	8b 40 08             	mov    0x8(%eax),%eax
			if (iterator->sva > blockToInsert->sva) {

				struct MemBlock* prev = LIST_PREV(iterator);
				if (prev == NULL) {
					//check merge
					if (blockToInsert->size + blockToInsert->sva
  8037e2:	39 c2                	cmp    %eax,%edx
  8037e4:	75 33                	jne    803819 <insert_sorted_with_merge_freeList+0x1c4>
							== iterator->sva) {
						iterator->sva = blockToInsert->sva;
  8037e6:	8b 45 08             	mov    0x8(%ebp),%eax
  8037e9:	8b 50 08             	mov    0x8(%eax),%edx
  8037ec:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8037ef:	89 50 08             	mov    %edx,0x8(%eax)
						iterator->size = iterator->size + blockToInsert->size;
  8037f2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8037f5:	8b 50 0c             	mov    0xc(%eax),%edx
  8037f8:	8b 45 08             	mov    0x8(%ebp),%eax
  8037fb:	8b 40 0c             	mov    0xc(%eax),%eax
  8037fe:	01 c2                	add    %eax,%edx
  803800:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803803:	89 50 0c             	mov    %edx,0xc(%eax)
						addToAvailMemBlocksList(blockToInsert);
  803806:	83 ec 0c             	sub    $0xc,%esp
  803809:	ff 75 08             	pushl  0x8(%ebp)
  80380c:	e8 c4 fd ff ff       	call   8035d5 <addToAvailMemBlocksList>
  803811:	83 c4 10             	add    $0x10,%esp

					else {
						LIST_INSERT_BEFORE(&FreeMemBlocksList, iterator,
								blockToInsert);
					}
					break;
  803814:	e9 80 02 00 00       	jmp    803a99 <insert_sorted_with_merge_freeList+0x444>
						addToAvailMemBlocksList(blockToInsert);

					}

					else {
						LIST_INSERT_BEFORE(&FreeMemBlocksList, iterator,
  803819:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80381d:	74 06                	je     803825 <insert_sorted_with_merge_freeList+0x1d0>
  80381f:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803823:	75 17                	jne    80383c <insert_sorted_with_merge_freeList+0x1e7>
  803825:	83 ec 04             	sub    $0x4,%esp
  803828:	68 e8 46 80 00       	push   $0x8046e8
  80382d:	68 3a 01 00 00       	push   $0x13a
  803832:	68 57 46 80 00       	push   $0x804657
  803837:	e8 86 d6 ff ff       	call   800ec2 <_panic>
  80383c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80383f:	8b 50 04             	mov    0x4(%eax),%edx
  803842:	8b 45 08             	mov    0x8(%ebp),%eax
  803845:	89 50 04             	mov    %edx,0x4(%eax)
  803848:	8b 45 08             	mov    0x8(%ebp),%eax
  80384b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80384e:	89 10                	mov    %edx,(%eax)
  803850:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803853:	8b 40 04             	mov    0x4(%eax),%eax
  803856:	85 c0                	test   %eax,%eax
  803858:	74 0d                	je     803867 <insert_sorted_with_merge_freeList+0x212>
  80385a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80385d:	8b 40 04             	mov    0x4(%eax),%eax
  803860:	8b 55 08             	mov    0x8(%ebp),%edx
  803863:	89 10                	mov    %edx,(%eax)
  803865:	eb 08                	jmp    80386f <insert_sorted_with_merge_freeList+0x21a>
  803867:	8b 45 08             	mov    0x8(%ebp),%eax
  80386a:	a3 38 51 80 00       	mov    %eax,0x805138
  80386f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803872:	8b 55 08             	mov    0x8(%ebp),%edx
  803875:	89 50 04             	mov    %edx,0x4(%eax)
  803878:	a1 44 51 80 00       	mov    0x805144,%eax
  80387d:	40                   	inc    %eax
  80387e:	a3 44 51 80 00       	mov    %eax,0x805144
								blockToInsert);
					}
					break;
  803883:	e9 11 02 00 00       	jmp    803a99 <insert_sorted_with_merge_freeList+0x444>
				} else {
					//prev and next merge
					if (prev->sva + prev->size + blockToInsert->size
  803888:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80388b:	8b 50 08             	mov    0x8(%eax),%edx
  80388e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803891:	8b 40 0c             	mov    0xc(%eax),%eax
  803894:	01 c2                	add    %eax,%edx
  803896:	8b 45 08             	mov    0x8(%ebp),%eax
  803899:	8b 40 0c             	mov    0xc(%eax),%eax
  80389c:	01 c2                	add    %eax,%edx
							== iterator->sva) {
  80389e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8038a1:	8b 40 08             	mov    0x8(%eax),%eax
								blockToInsert);
					}
					break;
				} else {
					//prev and next merge
					if (prev->sva + prev->size + blockToInsert->size
  8038a4:	39 c2                	cmp    %eax,%edx
  8038a6:	0f 85 bf 00 00 00    	jne    80396b <insert_sorted_with_merge_freeList+0x316>
							== iterator->sva) {
						prev->size = prev->size + blockToInsert->size
  8038ac:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8038af:	8b 50 0c             	mov    0xc(%eax),%edx
  8038b2:	8b 45 08             	mov    0x8(%ebp),%eax
  8038b5:	8b 40 0c             	mov    0xc(%eax),%eax
  8038b8:	01 c2                	add    %eax,%edx
								+ iterator->size;
  8038ba:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8038bd:	8b 40 0c             	mov    0xc(%eax),%eax
  8038c0:	01 c2                	add    %eax,%edx
					break;
				} else {
					//prev and next merge
					if (prev->sva + prev->size + blockToInsert->size
							== iterator->sva) {
						prev->size = prev->size + blockToInsert->size
  8038c2:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8038c5:	89 50 0c             	mov    %edx,0xc(%eax)
								+ iterator->size;
						LIST_REMOVE(&FreeMemBlocksList, iterator);
  8038c8:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8038cc:	75 17                	jne    8038e5 <insert_sorted_with_merge_freeList+0x290>
  8038ce:	83 ec 04             	sub    $0x4,%esp
  8038d1:	68 c8 46 80 00       	push   $0x8046c8
  8038d6:	68 43 01 00 00       	push   $0x143
  8038db:	68 57 46 80 00       	push   $0x804657
  8038e0:	e8 dd d5 ff ff       	call   800ec2 <_panic>
  8038e5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8038e8:	8b 00                	mov    (%eax),%eax
  8038ea:	85 c0                	test   %eax,%eax
  8038ec:	74 10                	je     8038fe <insert_sorted_with_merge_freeList+0x2a9>
  8038ee:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8038f1:	8b 00                	mov    (%eax),%eax
  8038f3:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8038f6:	8b 52 04             	mov    0x4(%edx),%edx
  8038f9:	89 50 04             	mov    %edx,0x4(%eax)
  8038fc:	eb 0b                	jmp    803909 <insert_sorted_with_merge_freeList+0x2b4>
  8038fe:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803901:	8b 40 04             	mov    0x4(%eax),%eax
  803904:	a3 3c 51 80 00       	mov    %eax,0x80513c
  803909:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80390c:	8b 40 04             	mov    0x4(%eax),%eax
  80390f:	85 c0                	test   %eax,%eax
  803911:	74 0f                	je     803922 <insert_sorted_with_merge_freeList+0x2cd>
  803913:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803916:	8b 40 04             	mov    0x4(%eax),%eax
  803919:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80391c:	8b 12                	mov    (%edx),%edx
  80391e:	89 10                	mov    %edx,(%eax)
  803920:	eb 0a                	jmp    80392c <insert_sorted_with_merge_freeList+0x2d7>
  803922:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803925:	8b 00                	mov    (%eax),%eax
  803927:	a3 38 51 80 00       	mov    %eax,0x805138
  80392c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80392f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803935:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803938:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80393f:	a1 44 51 80 00       	mov    0x805144,%eax
  803944:	48                   	dec    %eax
  803945:	a3 44 51 80 00       	mov    %eax,0x805144
						addToAvailMemBlocksList(blockToInsert);
  80394a:	83 ec 0c             	sub    $0xc,%esp
  80394d:	ff 75 08             	pushl  0x8(%ebp)
  803950:	e8 80 fc ff ff       	call   8035d5 <addToAvailMemBlocksList>
  803955:	83 c4 10             	add    $0x10,%esp
						addToAvailMemBlocksList(iterator);
  803958:	83 ec 0c             	sub    $0xc,%esp
  80395b:	ff 75 f4             	pushl  -0xc(%ebp)
  80395e:	e8 72 fc ff ff       	call   8035d5 <addToAvailMemBlocksList>
  803963:	83 c4 10             	add    $0x10,%esp
					//Insert
					else {
						LIST_INSERT_BEFORE(&FreeMemBlocksList, iterator,
								blockToInsert);
					}
					break;
  803966:	e9 2e 01 00 00       	jmp    803a99 <insert_sorted_with_merge_freeList+0x444>
						LIST_REMOVE(&FreeMemBlocksList, iterator);
						addToAvailMemBlocksList(blockToInsert);
						addToAvailMemBlocksList(iterator);
					}
					//previous merge
					else if (prev->sva + prev->size == blockToInsert->sva) {
  80396b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80396e:	8b 50 08             	mov    0x8(%eax),%edx
  803971:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803974:	8b 40 0c             	mov    0xc(%eax),%eax
  803977:	01 c2                	add    %eax,%edx
  803979:	8b 45 08             	mov    0x8(%ebp),%eax
  80397c:	8b 40 08             	mov    0x8(%eax),%eax
  80397f:	39 c2                	cmp    %eax,%edx
  803981:	75 27                	jne    8039aa <insert_sorted_with_merge_freeList+0x355>
						prev->size = prev->size + blockToInsert->size;
  803983:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803986:	8b 50 0c             	mov    0xc(%eax),%edx
  803989:	8b 45 08             	mov    0x8(%ebp),%eax
  80398c:	8b 40 0c             	mov    0xc(%eax),%eax
  80398f:	01 c2                	add    %eax,%edx
  803991:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803994:	89 50 0c             	mov    %edx,0xc(%eax)
						addToAvailMemBlocksList(blockToInsert);
  803997:	83 ec 0c             	sub    $0xc,%esp
  80399a:	ff 75 08             	pushl  0x8(%ebp)
  80399d:	e8 33 fc ff ff       	call   8035d5 <addToAvailMemBlocksList>
  8039a2:	83 c4 10             	add    $0x10,%esp
					//Insert
					else {
						LIST_INSERT_BEFORE(&FreeMemBlocksList, iterator,
								blockToInsert);
					}
					break;
  8039a5:	e9 ef 00 00 00       	jmp    803a99 <insert_sorted_with_merge_freeList+0x444>
					else if (prev->sva + prev->size == blockToInsert->sva) {
						prev->size = prev->size + blockToInsert->size;
						addToAvailMemBlocksList(blockToInsert);
					}
					//next merge
					else if (blockToInsert->size + blockToInsert->sva
  8039aa:	8b 45 08             	mov    0x8(%ebp),%eax
  8039ad:	8b 50 0c             	mov    0xc(%eax),%edx
  8039b0:	8b 45 08             	mov    0x8(%ebp),%eax
  8039b3:	8b 40 08             	mov    0x8(%eax),%eax
  8039b6:	01 c2                	add    %eax,%edx
							== iterator->sva) {
  8039b8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8039bb:	8b 40 08             	mov    0x8(%eax),%eax
					else if (prev->sva + prev->size == blockToInsert->sva) {
						prev->size = prev->size + blockToInsert->size;
						addToAvailMemBlocksList(blockToInsert);
					}
					//next merge
					else if (blockToInsert->size + blockToInsert->sva
  8039be:	39 c2                	cmp    %eax,%edx
  8039c0:	75 33                	jne    8039f5 <insert_sorted_with_merge_freeList+0x3a0>
							== iterator->sva) {
						iterator->sva = blockToInsert->sva;
  8039c2:	8b 45 08             	mov    0x8(%ebp),%eax
  8039c5:	8b 50 08             	mov    0x8(%eax),%edx
  8039c8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8039cb:	89 50 08             	mov    %edx,0x8(%eax)
						iterator->size = iterator->size + blockToInsert->size;
  8039ce:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8039d1:	8b 50 0c             	mov    0xc(%eax),%edx
  8039d4:	8b 45 08             	mov    0x8(%ebp),%eax
  8039d7:	8b 40 0c             	mov    0xc(%eax),%eax
  8039da:	01 c2                	add    %eax,%edx
  8039dc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8039df:	89 50 0c             	mov    %edx,0xc(%eax)
						addToAvailMemBlocksList(blockToInsert);
  8039e2:	83 ec 0c             	sub    $0xc,%esp
  8039e5:	ff 75 08             	pushl  0x8(%ebp)
  8039e8:	e8 e8 fb ff ff       	call   8035d5 <addToAvailMemBlocksList>
  8039ed:	83 c4 10             	add    $0x10,%esp
					//Insert
					else {
						LIST_INSERT_BEFORE(&FreeMemBlocksList, iterator,
								blockToInsert);
					}
					break;
  8039f0:	e9 a4 00 00 00       	jmp    803a99 <insert_sorted_with_merge_freeList+0x444>
						iterator->size = iterator->size + blockToInsert->size;
						addToAvailMemBlocksList(blockToInsert);
					}
					//Insert
					else {
						LIST_INSERT_BEFORE(&FreeMemBlocksList, iterator,
  8039f5:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8039f9:	74 06                	je     803a01 <insert_sorted_with_merge_freeList+0x3ac>
  8039fb:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8039ff:	75 17                	jne    803a18 <insert_sorted_with_merge_freeList+0x3c3>
  803a01:	83 ec 04             	sub    $0x4,%esp
  803a04:	68 e8 46 80 00       	push   $0x8046e8
  803a09:	68 56 01 00 00       	push   $0x156
  803a0e:	68 57 46 80 00       	push   $0x804657
  803a13:	e8 aa d4 ff ff       	call   800ec2 <_panic>
  803a18:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803a1b:	8b 50 04             	mov    0x4(%eax),%edx
  803a1e:	8b 45 08             	mov    0x8(%ebp),%eax
  803a21:	89 50 04             	mov    %edx,0x4(%eax)
  803a24:	8b 45 08             	mov    0x8(%ebp),%eax
  803a27:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803a2a:	89 10                	mov    %edx,(%eax)
  803a2c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803a2f:	8b 40 04             	mov    0x4(%eax),%eax
  803a32:	85 c0                	test   %eax,%eax
  803a34:	74 0d                	je     803a43 <insert_sorted_with_merge_freeList+0x3ee>
  803a36:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803a39:	8b 40 04             	mov    0x4(%eax),%eax
  803a3c:	8b 55 08             	mov    0x8(%ebp),%edx
  803a3f:	89 10                	mov    %edx,(%eax)
  803a41:	eb 08                	jmp    803a4b <insert_sorted_with_merge_freeList+0x3f6>
  803a43:	8b 45 08             	mov    0x8(%ebp),%eax
  803a46:	a3 38 51 80 00       	mov    %eax,0x805138
  803a4b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803a4e:	8b 55 08             	mov    0x8(%ebp),%edx
  803a51:	89 50 04             	mov    %edx,0x4(%eax)
  803a54:	a1 44 51 80 00       	mov    0x805144,%eax
  803a59:	40                   	inc    %eax
  803a5a:	a3 44 51 80 00       	mov    %eax,0x805144
								blockToInsert);
					}
					break;
  803a5f:	eb 38                	jmp    803a99 <insert_sorted_with_merge_freeList+0x444>
		} else {
			LIST_INSERT_AFTER(&FreeMemBlocksList, last, blockToInsert);
		}
	} else {
		struct MemBlock *iterator;
		LIST_FOREACH(iterator, &(FreeMemBlocksList))
  803a61:	a1 40 51 80 00       	mov    0x805140,%eax
  803a66:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803a69:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803a6d:	74 07                	je     803a76 <insert_sorted_with_merge_freeList+0x421>
  803a6f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803a72:	8b 00                	mov    (%eax),%eax
  803a74:	eb 05                	jmp    803a7b <insert_sorted_with_merge_freeList+0x426>
  803a76:	b8 00 00 00 00       	mov    $0x0,%eax
  803a7b:	a3 40 51 80 00       	mov    %eax,0x805140
  803a80:	a1 40 51 80 00       	mov    0x805140,%eax
  803a85:	85 c0                	test   %eax,%eax
  803a87:	0f 85 1a fd ff ff    	jne    8037a7 <insert_sorted_with_merge_freeList+0x152>
  803a8d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803a91:	0f 85 10 fd ff ff    	jne    8037a7 <insert_sorted_with_merge_freeList+0x152>
		}
	}

	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  803a97:	eb 00                	jmp    803a99 <insert_sorted_with_merge_freeList+0x444>
  803a99:	90                   	nop
  803a9a:	c9                   	leave  
  803a9b:	c3                   	ret    

00803a9c <__udivdi3>:
  803a9c:	55                   	push   %ebp
  803a9d:	57                   	push   %edi
  803a9e:	56                   	push   %esi
  803a9f:	53                   	push   %ebx
  803aa0:	83 ec 1c             	sub    $0x1c,%esp
  803aa3:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  803aa7:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  803aab:	8b 7c 24 38          	mov    0x38(%esp),%edi
  803aaf:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  803ab3:	89 ca                	mov    %ecx,%edx
  803ab5:	89 f8                	mov    %edi,%eax
  803ab7:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  803abb:	85 f6                	test   %esi,%esi
  803abd:	75 2d                	jne    803aec <__udivdi3+0x50>
  803abf:	39 cf                	cmp    %ecx,%edi
  803ac1:	77 65                	ja     803b28 <__udivdi3+0x8c>
  803ac3:	89 fd                	mov    %edi,%ebp
  803ac5:	85 ff                	test   %edi,%edi
  803ac7:	75 0b                	jne    803ad4 <__udivdi3+0x38>
  803ac9:	b8 01 00 00 00       	mov    $0x1,%eax
  803ace:	31 d2                	xor    %edx,%edx
  803ad0:	f7 f7                	div    %edi
  803ad2:	89 c5                	mov    %eax,%ebp
  803ad4:	31 d2                	xor    %edx,%edx
  803ad6:	89 c8                	mov    %ecx,%eax
  803ad8:	f7 f5                	div    %ebp
  803ada:	89 c1                	mov    %eax,%ecx
  803adc:	89 d8                	mov    %ebx,%eax
  803ade:	f7 f5                	div    %ebp
  803ae0:	89 cf                	mov    %ecx,%edi
  803ae2:	89 fa                	mov    %edi,%edx
  803ae4:	83 c4 1c             	add    $0x1c,%esp
  803ae7:	5b                   	pop    %ebx
  803ae8:	5e                   	pop    %esi
  803ae9:	5f                   	pop    %edi
  803aea:	5d                   	pop    %ebp
  803aeb:	c3                   	ret    
  803aec:	39 ce                	cmp    %ecx,%esi
  803aee:	77 28                	ja     803b18 <__udivdi3+0x7c>
  803af0:	0f bd fe             	bsr    %esi,%edi
  803af3:	83 f7 1f             	xor    $0x1f,%edi
  803af6:	75 40                	jne    803b38 <__udivdi3+0x9c>
  803af8:	39 ce                	cmp    %ecx,%esi
  803afa:	72 0a                	jb     803b06 <__udivdi3+0x6a>
  803afc:	3b 44 24 08          	cmp    0x8(%esp),%eax
  803b00:	0f 87 9e 00 00 00    	ja     803ba4 <__udivdi3+0x108>
  803b06:	b8 01 00 00 00       	mov    $0x1,%eax
  803b0b:	89 fa                	mov    %edi,%edx
  803b0d:	83 c4 1c             	add    $0x1c,%esp
  803b10:	5b                   	pop    %ebx
  803b11:	5e                   	pop    %esi
  803b12:	5f                   	pop    %edi
  803b13:	5d                   	pop    %ebp
  803b14:	c3                   	ret    
  803b15:	8d 76 00             	lea    0x0(%esi),%esi
  803b18:	31 ff                	xor    %edi,%edi
  803b1a:	31 c0                	xor    %eax,%eax
  803b1c:	89 fa                	mov    %edi,%edx
  803b1e:	83 c4 1c             	add    $0x1c,%esp
  803b21:	5b                   	pop    %ebx
  803b22:	5e                   	pop    %esi
  803b23:	5f                   	pop    %edi
  803b24:	5d                   	pop    %ebp
  803b25:	c3                   	ret    
  803b26:	66 90                	xchg   %ax,%ax
  803b28:	89 d8                	mov    %ebx,%eax
  803b2a:	f7 f7                	div    %edi
  803b2c:	31 ff                	xor    %edi,%edi
  803b2e:	89 fa                	mov    %edi,%edx
  803b30:	83 c4 1c             	add    $0x1c,%esp
  803b33:	5b                   	pop    %ebx
  803b34:	5e                   	pop    %esi
  803b35:	5f                   	pop    %edi
  803b36:	5d                   	pop    %ebp
  803b37:	c3                   	ret    
  803b38:	bd 20 00 00 00       	mov    $0x20,%ebp
  803b3d:	89 eb                	mov    %ebp,%ebx
  803b3f:	29 fb                	sub    %edi,%ebx
  803b41:	89 f9                	mov    %edi,%ecx
  803b43:	d3 e6                	shl    %cl,%esi
  803b45:	89 c5                	mov    %eax,%ebp
  803b47:	88 d9                	mov    %bl,%cl
  803b49:	d3 ed                	shr    %cl,%ebp
  803b4b:	89 e9                	mov    %ebp,%ecx
  803b4d:	09 f1                	or     %esi,%ecx
  803b4f:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  803b53:	89 f9                	mov    %edi,%ecx
  803b55:	d3 e0                	shl    %cl,%eax
  803b57:	89 c5                	mov    %eax,%ebp
  803b59:	89 d6                	mov    %edx,%esi
  803b5b:	88 d9                	mov    %bl,%cl
  803b5d:	d3 ee                	shr    %cl,%esi
  803b5f:	89 f9                	mov    %edi,%ecx
  803b61:	d3 e2                	shl    %cl,%edx
  803b63:	8b 44 24 08          	mov    0x8(%esp),%eax
  803b67:	88 d9                	mov    %bl,%cl
  803b69:	d3 e8                	shr    %cl,%eax
  803b6b:	09 c2                	or     %eax,%edx
  803b6d:	89 d0                	mov    %edx,%eax
  803b6f:	89 f2                	mov    %esi,%edx
  803b71:	f7 74 24 0c          	divl   0xc(%esp)
  803b75:	89 d6                	mov    %edx,%esi
  803b77:	89 c3                	mov    %eax,%ebx
  803b79:	f7 e5                	mul    %ebp
  803b7b:	39 d6                	cmp    %edx,%esi
  803b7d:	72 19                	jb     803b98 <__udivdi3+0xfc>
  803b7f:	74 0b                	je     803b8c <__udivdi3+0xf0>
  803b81:	89 d8                	mov    %ebx,%eax
  803b83:	31 ff                	xor    %edi,%edi
  803b85:	e9 58 ff ff ff       	jmp    803ae2 <__udivdi3+0x46>
  803b8a:	66 90                	xchg   %ax,%ax
  803b8c:	8b 54 24 08          	mov    0x8(%esp),%edx
  803b90:	89 f9                	mov    %edi,%ecx
  803b92:	d3 e2                	shl    %cl,%edx
  803b94:	39 c2                	cmp    %eax,%edx
  803b96:	73 e9                	jae    803b81 <__udivdi3+0xe5>
  803b98:	8d 43 ff             	lea    -0x1(%ebx),%eax
  803b9b:	31 ff                	xor    %edi,%edi
  803b9d:	e9 40 ff ff ff       	jmp    803ae2 <__udivdi3+0x46>
  803ba2:	66 90                	xchg   %ax,%ax
  803ba4:	31 c0                	xor    %eax,%eax
  803ba6:	e9 37 ff ff ff       	jmp    803ae2 <__udivdi3+0x46>
  803bab:	90                   	nop

00803bac <__umoddi3>:
  803bac:	55                   	push   %ebp
  803bad:	57                   	push   %edi
  803bae:	56                   	push   %esi
  803baf:	53                   	push   %ebx
  803bb0:	83 ec 1c             	sub    $0x1c,%esp
  803bb3:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  803bb7:	8b 74 24 34          	mov    0x34(%esp),%esi
  803bbb:	8b 7c 24 38          	mov    0x38(%esp),%edi
  803bbf:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  803bc3:	89 44 24 0c          	mov    %eax,0xc(%esp)
  803bc7:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  803bcb:	89 f3                	mov    %esi,%ebx
  803bcd:	89 fa                	mov    %edi,%edx
  803bcf:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  803bd3:	89 34 24             	mov    %esi,(%esp)
  803bd6:	85 c0                	test   %eax,%eax
  803bd8:	75 1a                	jne    803bf4 <__umoddi3+0x48>
  803bda:	39 f7                	cmp    %esi,%edi
  803bdc:	0f 86 a2 00 00 00    	jbe    803c84 <__umoddi3+0xd8>
  803be2:	89 c8                	mov    %ecx,%eax
  803be4:	89 f2                	mov    %esi,%edx
  803be6:	f7 f7                	div    %edi
  803be8:	89 d0                	mov    %edx,%eax
  803bea:	31 d2                	xor    %edx,%edx
  803bec:	83 c4 1c             	add    $0x1c,%esp
  803bef:	5b                   	pop    %ebx
  803bf0:	5e                   	pop    %esi
  803bf1:	5f                   	pop    %edi
  803bf2:	5d                   	pop    %ebp
  803bf3:	c3                   	ret    
  803bf4:	39 f0                	cmp    %esi,%eax
  803bf6:	0f 87 ac 00 00 00    	ja     803ca8 <__umoddi3+0xfc>
  803bfc:	0f bd e8             	bsr    %eax,%ebp
  803bff:	83 f5 1f             	xor    $0x1f,%ebp
  803c02:	0f 84 ac 00 00 00    	je     803cb4 <__umoddi3+0x108>
  803c08:	bf 20 00 00 00       	mov    $0x20,%edi
  803c0d:	29 ef                	sub    %ebp,%edi
  803c0f:	89 fe                	mov    %edi,%esi
  803c11:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  803c15:	89 e9                	mov    %ebp,%ecx
  803c17:	d3 e0                	shl    %cl,%eax
  803c19:	89 d7                	mov    %edx,%edi
  803c1b:	89 f1                	mov    %esi,%ecx
  803c1d:	d3 ef                	shr    %cl,%edi
  803c1f:	09 c7                	or     %eax,%edi
  803c21:	89 e9                	mov    %ebp,%ecx
  803c23:	d3 e2                	shl    %cl,%edx
  803c25:	89 14 24             	mov    %edx,(%esp)
  803c28:	89 d8                	mov    %ebx,%eax
  803c2a:	d3 e0                	shl    %cl,%eax
  803c2c:	89 c2                	mov    %eax,%edx
  803c2e:	8b 44 24 08          	mov    0x8(%esp),%eax
  803c32:	d3 e0                	shl    %cl,%eax
  803c34:	89 44 24 04          	mov    %eax,0x4(%esp)
  803c38:	8b 44 24 08          	mov    0x8(%esp),%eax
  803c3c:	89 f1                	mov    %esi,%ecx
  803c3e:	d3 e8                	shr    %cl,%eax
  803c40:	09 d0                	or     %edx,%eax
  803c42:	d3 eb                	shr    %cl,%ebx
  803c44:	89 da                	mov    %ebx,%edx
  803c46:	f7 f7                	div    %edi
  803c48:	89 d3                	mov    %edx,%ebx
  803c4a:	f7 24 24             	mull   (%esp)
  803c4d:	89 c6                	mov    %eax,%esi
  803c4f:	89 d1                	mov    %edx,%ecx
  803c51:	39 d3                	cmp    %edx,%ebx
  803c53:	0f 82 87 00 00 00    	jb     803ce0 <__umoddi3+0x134>
  803c59:	0f 84 91 00 00 00    	je     803cf0 <__umoddi3+0x144>
  803c5f:	8b 54 24 04          	mov    0x4(%esp),%edx
  803c63:	29 f2                	sub    %esi,%edx
  803c65:	19 cb                	sbb    %ecx,%ebx
  803c67:	89 d8                	mov    %ebx,%eax
  803c69:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  803c6d:	d3 e0                	shl    %cl,%eax
  803c6f:	89 e9                	mov    %ebp,%ecx
  803c71:	d3 ea                	shr    %cl,%edx
  803c73:	09 d0                	or     %edx,%eax
  803c75:	89 e9                	mov    %ebp,%ecx
  803c77:	d3 eb                	shr    %cl,%ebx
  803c79:	89 da                	mov    %ebx,%edx
  803c7b:	83 c4 1c             	add    $0x1c,%esp
  803c7e:	5b                   	pop    %ebx
  803c7f:	5e                   	pop    %esi
  803c80:	5f                   	pop    %edi
  803c81:	5d                   	pop    %ebp
  803c82:	c3                   	ret    
  803c83:	90                   	nop
  803c84:	89 fd                	mov    %edi,%ebp
  803c86:	85 ff                	test   %edi,%edi
  803c88:	75 0b                	jne    803c95 <__umoddi3+0xe9>
  803c8a:	b8 01 00 00 00       	mov    $0x1,%eax
  803c8f:	31 d2                	xor    %edx,%edx
  803c91:	f7 f7                	div    %edi
  803c93:	89 c5                	mov    %eax,%ebp
  803c95:	89 f0                	mov    %esi,%eax
  803c97:	31 d2                	xor    %edx,%edx
  803c99:	f7 f5                	div    %ebp
  803c9b:	89 c8                	mov    %ecx,%eax
  803c9d:	f7 f5                	div    %ebp
  803c9f:	89 d0                	mov    %edx,%eax
  803ca1:	e9 44 ff ff ff       	jmp    803bea <__umoddi3+0x3e>
  803ca6:	66 90                	xchg   %ax,%ax
  803ca8:	89 c8                	mov    %ecx,%eax
  803caa:	89 f2                	mov    %esi,%edx
  803cac:	83 c4 1c             	add    $0x1c,%esp
  803caf:	5b                   	pop    %ebx
  803cb0:	5e                   	pop    %esi
  803cb1:	5f                   	pop    %edi
  803cb2:	5d                   	pop    %ebp
  803cb3:	c3                   	ret    
  803cb4:	3b 04 24             	cmp    (%esp),%eax
  803cb7:	72 06                	jb     803cbf <__umoddi3+0x113>
  803cb9:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  803cbd:	77 0f                	ja     803cce <__umoddi3+0x122>
  803cbf:	89 f2                	mov    %esi,%edx
  803cc1:	29 f9                	sub    %edi,%ecx
  803cc3:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  803cc7:	89 14 24             	mov    %edx,(%esp)
  803cca:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  803cce:	8b 44 24 04          	mov    0x4(%esp),%eax
  803cd2:	8b 14 24             	mov    (%esp),%edx
  803cd5:	83 c4 1c             	add    $0x1c,%esp
  803cd8:	5b                   	pop    %ebx
  803cd9:	5e                   	pop    %esi
  803cda:	5f                   	pop    %edi
  803cdb:	5d                   	pop    %ebp
  803cdc:	c3                   	ret    
  803cdd:	8d 76 00             	lea    0x0(%esi),%esi
  803ce0:	2b 04 24             	sub    (%esp),%eax
  803ce3:	19 fa                	sbb    %edi,%edx
  803ce5:	89 d1                	mov    %edx,%ecx
  803ce7:	89 c6                	mov    %eax,%esi
  803ce9:	e9 71 ff ff ff       	jmp    803c5f <__umoddi3+0xb3>
  803cee:	66 90                	xchg   %ax,%ax
  803cf0:	39 44 24 04          	cmp    %eax,0x4(%esp)
  803cf4:	72 ea                	jb     803ce0 <__umoddi3+0x134>
  803cf6:	89 d9                	mov    %ebx,%ecx
  803cf8:	e9 62 ff ff ff       	jmp    803c5f <__umoddi3+0xb3>
